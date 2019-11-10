unit FrnEngn;

interface

uses
  Windows, Classes, SysUtils,Grobal2;

type

  TFrontEngine = class(TThread)
    m_UserCriticalSection :TRTLCriticalSection;
    m_LoadRcdList         :TList; //0x30
    m_SaveRcdList         :TList; //0x34
    m_ChangeGoldList      :TList; //0x38
  private
    m_LoadRcdTempList     :TList;
    m_SaveRcdTempList     :TList;
    procedure GetGameTime();
    procedure ProcessGameDate();
    function  LoadHumFromDB(LoadUser:pTLoadDBInfo;var boReTry:Boolean):Boolean;
    function  ChangeUserGoldInDB(GoldChangeInfo:pTGoldChangeInfo):Boolean;
    procedure Run();
    { Private declarations }
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    function  SaveListCount():Integer;
    function  IsIdle():Boolean;
    function  IsFull():Boolean;
    procedure DeleteHuman(nGateIndex, nSocket: Integer);
    function  InSaveRcdList(sChrName:String):Boolean;
    procedure AddChangeGoldList(sGameMasterName,sGetGoldUserName:String;nGold:Integer);
    procedure AddToLoadRcdList(sAccount,sChrName,sIPaddr:String;boFlag:Boolean;nSessionID:integer;nPayMent,nPayMode,nSoftVersionDate,nSocket,nGSocketIdx,nGateIdx:Integer);
    procedure AddToSaveRcdList(SaveRcd:pTSaveRcd);
  end;

implementation
uses
  M2Share, RunDB, ObjBase;
{ TFrontEngine }

constructor TFrontEngine.Create(CreateSuspended: Boolean);
begin
  inherited;
  InitializeCriticalSection(m_UserCriticalSection);
  m_LoadRcdList     := TList.Create;
  m_SaveRcdList     := TList.Create;
  m_ChangeGoldList  := TList.Create;
  m_LoadRcdTempList := TList.Create;
  m_SaveRcdTempList := TList.Create;
//  FreeOnTerminate:=True;
end;

destructor TFrontEngine.Destroy;
begin
  m_LoadRcdList.Free;
  m_SaveRcdList.Free;
  m_ChangeGoldList.Free;
  m_LoadRcdTempList.Free;
  m_SaveRcdTempList.Free;
  DeleteCriticalSection(m_UserCriticalSection);
  inherited;
end;
//004B5148
procedure TFrontEngine.Execute;
ResourceString
  sExceptionMsg = '[Exception] TFrontEngine::Execute';
begin
  While not Terminated do begin
    try
      Run();
    except
      MainOutMessage(sExceptionMsg);
    end;
    Sleep(1);
  end;
end;

procedure TFrontEngine.GetGameTime;//004B50AC
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(Time, Hour, Min, Sec, MSec);
  case Hour of
    5,6,7,8,9,10,16,17,18,19,20,21,22: g_nGameTime:=1;
    11,23: g_nGameTime:=2;
    4,15: g_nGameTime:=0;
    0,1,2,3,12,13,14: g_nGameTime:=3;
  end;
end;

function TFrontEngine.IsIdle: Boolean;
begin
  Result:=False;
  EnterCriticalSection(m_UserCriticalSection);
  try
    if m_SaveRcdList.Count = 0 then Result:=True;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;

end;
function TFrontEngine.SaveListCount: Integer;
begin
  Result:=0;
  EnterCriticalSection(m_UserCriticalSection);
  try
    Result:=m_SaveRcdList.Count;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.ProcessGameDate;
var
  I              :Integer;
  II             :Integer;
  TempList       :TList;
  ChangeGoldList :TList;
  LoadDBInfo     :pTLoadDBInfo;
  SaveRcd        :pTSaveRcd;
  GoldChangeInfo :pTGoldChangeInfo;
  boReTryLoadDB  :Boolean;
  resourcestring
  sExceptionMsg = '[Exception] TFrontEngine::ProcessGameDate Code:%d';
  sSaveExceptionMsg = '数据库服务器出现异常，请重新启动数据库服务器！！！';
begin
  ChangeGoldList:=nil;
  EnterCriticalSection(m_UserCriticalSection);
  try
    for I:=0 to m_SaveRcdList.Count -1 do begin
      m_SaveRcdTempList.Add(m_SaveRcdList.Items[I]);
    end;

    TempList          := m_LoadRcdTempList;
    m_LoadRcdTempList := m_LoadRcdList;
    m_LoadRcdList     := TempList;

    if m_ChangeGoldList.Count > 0 then begin
      ChangeGoldList:=TList.Create;
      for I:=0 to m_ChangeGoldList.Count -1 do begin
        ChangeGoldList.Add(m_ChangeGoldList.Items[I]);
      end;
    end;
    m_ChangeGoldList.Clear;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
  for I:=0 to m_SaveRcdTempList.Count -1 do begin
    SaveRcd:=m_SaveRcdTempList.Items[I];
    if SaveHumRcdToDB(SaveRcd.sAccount,SaveRcd.sChrName,SaveRcd.nSessionID,SaveRcd.HumanRcd) or (SaveRcd.nReTryCount > 50) then begin
      if SaveRcd.PlayObject <> nil then begin
        TPlayObject(SaveRcd.PlayObject).m_boRcdSaved:=True;
      end;
      EnterCriticalSection(m_UserCriticalSection);
      try
        for II:=0 to m_SaveRcdList.Count - 1 do begin
          if m_SaveRcdList.Items[II] = SaveRcd then begin
            m_SaveRcdList.Delete(II);
            Dispose(SaveRcd);
            break;
          end;
        end;
      finally
        LeaveCriticalSection(m_UserCriticalSection);
      end;
    end else begin
      Inc(SaveRcd.nReTryCount);
    end;
  end;//004B4FDA
  m_SaveRcdTempList.Clear;

  for I:=0 to m_LoadRcdTempList.Count -1 do begin
    LoadDBInfo:= m_LoadRcdTempList.Items[I];
    if not LoadHumFromDB(LoadDBInfo,boReTryLoadDB) then
      RunSocket.CloseUser(LoadDBInfo.nGateIdx,LoadDBInfo.nSocket);
    if not boReTryLoadDB then begin
      Dispose(LoadDBInfo);
    end else begin //如果读取人物数据失败(数据还没有保存),则重新加入队列
      EnterCriticalSection(m_UserCriticalSection);
      try
        m_LoadRcdList.Add(LoadDBInfo);
      finally
        LeaveCriticalSection(m_UserCriticalSection);
      end;
    end;
  end;//004B504D
  m_LoadRcdTempList.Clear;

  if ChangeGoldList <> nil then begin
    for I:=0 to ChangeGoldList.Count -1 do begin
      GoldChangeInfo:=ChangeGoldList.Items[I];
      ChangeUserGoldInDB(GoldChangeInfo);
      Dispose(GoldChangeInfo);
    end;//004B509F
    ChangeGoldList.Free;
  end;//004B50A7
end;

function TFrontEngine.IsFull: Boolean;//004B4988
begin
  Result:=False;
  EnterCriticalSection(m_UserCriticalSection);
  try
    if m_SaveRcdList.Count >= 1000 then begin
      Result:=True;
    end;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.AddToLoadRcdList(sAccount, sChrName, sIPaddr: String;
  boFlag: Boolean; nSessionID, nPayMent, nPayMode,nSoftVersionDate,nSocket,nGSocketIdx,nGateIdx: Integer);
//004B46A0
var
  LoadRcdInfo:pTLoadDBInfo;
begin
  New(LoadRcdInfo);
  LoadRcdInfo.sAccount         := sAccount;
  LoadRcdInfo.sCharName        := sChrName;
  LoadRcdInfo.sIPaddr          := sIPaddr;
  //LoadRcdInfo.boClinetFlag     := boFlag;
  LoadRcdInfo.nSessionID       := nSessionID;
  LoadRcdInfo.nSoftVersionDate := nSoftVersionDate;
  LoadRcdInfo.nPayMent         := nPayMent;
  LoadRcdInfo.nPayMode         := nPayMode;
  LoadRcdInfo.nSocket          := nSocket;
  LoadRcdInfo.nGSocketIdx      := nGSocketIdx;
  LoadRcdInfo.nGateIdx         := nGateIdx;
  LoadRcdInfo.dwNewUserTick    := GetTickCount();
  LoadRcdInfo.PlayObject       := nil;
  LoadRcdInfo.nReLoadCount     := 0;

  EnterCriticalSection(m_UserCriticalSection);
  try
    m_LoadRcdList.Add(LoadRcdInfo);
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

function TFrontEngine.LoadHumFromDB(LoadUser: pTLoadDBInfo;var boReTry:Boolean): Boolean;//004B4B10
var
  HumanRcd     :THumDataInfo;
  UserOpenInfo :pTUserOpenInfo;
ResourceString
  sReLoginFailMsg = '[非法登录] 全局会话验证失败(%s/%s/%s/%d)';
begin
  Result  := False;
  boReTry := False;
  if InSaveRcdList(LoadUser.sCharName) then begin
    boReTry:=True; //反回TRUE,则重新加入队列
    exit;
  end;
  if (UserEngine.GetPlayObjectEx(LoadUser.sCharName) <> nil) then begin
    UserEngine.KickPlayObjectEx(LoadUser.sCharName);
    boReTry:=True; //反回TRUE,则重新加入队列
    exit;
  end;
  if not LoadHumRcdFromDB(LoadUser.sAccount,LoadUser.sCharName,LoadUser.sIPaddr,HumanRcd,LoadUser.nSessionID) then begin
    RunSocket.SendOutConnectMsg(LoadUser.nGateIdx,LoadUser.nSocket,LoadUser.nGSocketIdx);
  end else begin
    New(UserOpenInfo);
    UserOpenInfo.sChrName := LoadUser.sCharName;
    UserOpenInfo.LoadUser := LoadUser^;
    UserOpenInfo.HumanRcd := HumanRcd;
    UserEngine.AddUserOpenInfo(UserOpenInfo);
    Result:=True;
  end;
end;

function TFrontEngine.InSaveRcdList(sChrName:String): Boolean;//004B4A48
var
  I: Integer;
begin
  Result:=False;
  EnterCriticalSection(m_UserCriticalSection);
  try
    for I := 0 to m_SaveRcdList.Count - 1 do begin
      if pTSaveRcd(m_SaveRcdList.Items[i]).sChrName = sChrName then begin
        Result:=True;
        break;
      end;
    end;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.AddChangeGoldList(sGameMasterName, sGetGoldUserName: String;
  nGold: Integer); //004B4828
var
  GoldInfo:pTGoldChangeInfo;
begin
  New(GoldInfo);
  GoldInfo.sGameMasterName:=sGameMasterName;
  GoldInfo.sGetGoldUser:=sGetGoldUserName;
  GoldInfo.nGold:=nGold;
  m_ChangeGoldList.Add(GoldInfo);
end;

procedure TFrontEngine.AddToSaveRcdList(SaveRcd: pTSaveRcd);//004B49EC
begin
  EnterCriticalSection(m_UserCriticalSection);
  try
    m_SaveRcdList.Add(SaveRcd);
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.DeleteHuman(nGateIndex,nSocket:Integer);//004B45EC
var
  I: Integer;
  LoadRcdInfo:pTLoadDBInfo;
begin
  EnterCriticalSection(m_UserCriticalSection);
  try
    for I := 0 to m_LoadRcdList.Count - 1 do begin
      LoadRcdInfo:=m_LoadRcdList.Items[I];
      if (LoadRcdInfo.nGateIdx = nGateIndex) and (LoadRcdInfo.nSocket = nSocket) then begin
        Dispose(LoadRcdInfo);
        m_LoadRcdList.Delete(I);
        break;
      end;
    end;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

function TFrontEngine.ChangeUserGoldInDB(GoldChangeInfo: pTGoldChangeInfo): Boolean;
var
  HumanRcd:THumDataInfo;
begin
  Result:=False;
  if LoadHumRcdFromDB('1',GoldChangeInfo.sGetGoldUser,'1',HumanRcd,1) then begin
    if ((HumanRcd.Data.nGold + GoldChangeInfo.nGold) > 0) and ((HumanRcd.Data.nGold + GoldChangeInfo.nGold) < 2000000000) then begin
      Inc(HumanRcd.Data.nGold,GoldChangeInfo.nGold);
      if SaveHumRcdToDB('1',GoldChangeInfo.sGetGoldUser,1,HumanRcd) then begin
        UserEngine.sub_4AE514(GoldChangeInfo);
        Result:=True;
      end;
    end;
  end;
end;

procedure TFrontEngine.Run;
begin
  ProcessGameDate();
  GetGameTime();
end;
end.
