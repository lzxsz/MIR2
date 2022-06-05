unit UsrSoc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, JSocket, SyncObjs,IniFiles,Grobal2,DBShare;
type
//  TServerInfo = record
//    nGateCount    :Integer;
//    sSelGateIP    :String;  //0x2EC
//    sGameGateIP1  :String;  //0x2F0
//    nGameGatePort1:Integer; //0x2F4
//    sGameGateIP2  :String;  //0x2F8
//    nGameGatePort2:Integer; //0x2FC
//    sGameGateIP3  :String;  //0x300
//    nGameGatePort3:Integer; //0x304
//    sGameGateIP4  :String;  //0x308
//    nGameGatePort4:Integer; //0x30C
//    sGameGateIP5  :String;
//    nGameGatePort5:Integer;
//    sGameGateIP6  :String;
//    nGameGatePort6:Integer;
//    sGameGateIP7  :String;
//    nGameGatePort7:Integer;
//    sGameGateIP8  :String;
//    nGameGatePort8:Integer;
//  end;

  TFrmUserSoc=class(TForm)
    UserSocket: TServerSocket;
    Timer1: TTimer;
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure Timer1Timer(Sender : TObject);
    procedure UserSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure UserSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure UserSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure UserSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    dwKeepAliveTick    :LongWord;    //0x10
    CS_GateSession:TCriticalSection; //0x2D8
    n2DC:Integer;
    n2E0:Integer;
    n2E4:Integer;
    GateList:TList;         //0x2E8
    CurGate:pTGateInfo;    //0x51C
    MapList:TStringList;
    
    function LoadChrNameList(sFileName:string):Boolean;
    function LoadClearMakeIndexList(sFileName: string):Boolean;
    procedure ProcessGateMsg(var GateInfo: pTGateInfo);
    procedure SendKeepAlivePacket(Socket: TCustomWinSocket);
    procedure ProcessUserMsg(var UserInfo: pTUserInfo);
    procedure CloseUser(sID: String; var GateInfo: pTGateInfo);
    procedure OpenUser(sID, sIP: String; var GateInfo: pTGateInfo);
    procedure DeCodeUserMsg(sData: String; var UserInfo: pTUserInfo);
    function QueryChr(sData: String; var UserInfo: pTUserInfo): Boolean;
    procedure DelChr(sData: String; var UserInfo: pTUserInfo);
    procedure OutOfConnect(const UserInfo: pTUserInfo);
    procedure NewChr(sData: String; var UserInfo: pTUserInfo);
    function SelectChr(sData: String; var UserInfo: pTUserInfo): Boolean;
    procedure SendUserSocket(Socket: TCustomWinSocket; sSessionID,
      sSendMsg: String);
    function GetMapIndex(sMap: String): Integer;

    function GateRoutePort(sGateIP: String): Integer;
    function CheckDenyChrName(sChrName:String):Boolean;    
    { Private declarations }
  public
    function GateRouteIP(sGateIP: String;var nPort:Integer): String;
    procedure LoadServerInfo();
    function  NewChrData(sChrName:String;nSex,nJob,nHair:Integer):Boolean;
    function GetUserCount():Integer;
    { Public declarations }
  end;

var
  FrmUserSoc: TFrmUserSoc;

implementation

uses HumDB, HUtil32, IDSocCli, EDcode, MudUtil, DBSMain;

{$R *.DFM}

procedure TFrmUserSoc.UserSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
//0x004A2A10
var
  GateInfo:pTGateInfo;
  sIPaddr:String;
begin
  sIPaddr:=Socket.RemoteAddress;
  if not CheckServerIP(sIPaddr) then begin
    OutMainMessage('非法网关连接: ' + sIPaddr);
    Socket.Close;
    exit;
  end;
  if not boOpenDBBusy then begin
    New(GateInfo);
    GateInfo.Socket    := Socket;
    GateInfo.sGateaddr := sIPaddr;
    GateInfo.sText     := '';
    GateInfo.UserList  := TList.Create;
    GateInfo.dwTick10  := GetTickCount();
    GateInfo.nGateID   := GetGateID(sIPaddr);
    try
      CS_GateSession.Enter;
      GateList.Add(GateInfo);
    finally
      CS_GateSession.Leave;
    end;
  end else begin
    Socket.Close;
  end;
end;

procedure TFrmUserSoc.UserSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
//0x004A2B08
var
  i,ii:integer;
  GateInfo:pTGateInfo;
  UserInfo:pTUserInfo;
begin
  try
    CS_GateSession.Enter;
    for i:=0 to GateList.Count -1 do begin
      GateInfo:=GateList.Items[i];
      if GateInfo <> nil then begin
        for ii:=0 to GateInfo.UserList.Count -1 do begin
          UserInfo:=GateInfo.UserList.Items[ii];
          Dispose(UserInfo);
        end;
        GateInfo.UserList.Free;
      end;
      GateList.Delete(i);
      break;
    end;
  finally
    CS_GateSession.Leave;
  end;
end;

procedure TFrmUserSoc.UserSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
//0x004A2C10
begin
  ErrorCode:=0;
  Socket.Close;
end;

procedure TFrmUserSoc.UserSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i:integer;
  sReviceMsg:String;
  GateInfo:pTGateInfo;
begin
  try
    CS_GateSession.Enter;
    for i:=0 to GateList.Count -1 do begin
      GateInfo:=GateList.Items[i];
      if GateInfo.Socket = Socket then begin
        CurGate:=GateInfo;
        sReviceMsg:=Socket.ReceiveText;
        GateInfo.sText:=GateInfo.sText + sReviceMsg;
        if Length(GateInfo.sText) < 81920 then begin
          if Pos('$',GateInfo.sText) > 1 then begin
            ProcessGateMsg(GateInfo);
          end;
        end else begin
          GateInfo.sText:='';
        end;
      end;
    end;
  finally
    CS_GateSession.Leave;
  end;
end;

procedure TFrmUserSoc.FormCreate(Sender : TObject);
//0x004A2898
begin
  CS_GateSession:=TCriticalSection.Create;
  GateList:=TList.Create;
  MapList:=TStringList.Create;
  UserSocket.Port:=g_nGatePort;
  UserSocket.Address:=g_sGateAddr;
  UserSocket.Active:=True;
  LoadServerInfo();
  LoadChrNameList('DenyChrName.txt');
  LoadClearMakeIndexList('ClearMakeIndex.txt');
end;

procedure TFrmUserSoc.FormDestroy(Sender : TObject);
//ox004A2954
var
  i,ii:Integer;
  GateInfo:pTGateInfo;
  UserInfo:pTUserInfo;  
begin
  for i:=0 to GateList.Count -1 do begin
    GateInfo:=GateList.Items[i];
    if GateInfo <> nil then begin
      for ii:=0 to GateInfo.UserList.Count -1 do begin
        UserInfo:=GateInfo.UserList.Items[ii];
        Dispose(UserInfo);
      end;
      GateInfo.UserList.Free;
    end;
    GateList.Delete(i);
    break;
  end;
  GateList.Free;
  MapList.Free;
  CS_GateSession.Free;
end;

procedure TFrmUserSoc.Timer1Timer(Sender : TObject);
//0x004A4EFC
var
  n8:Integer;
begin
  n8:=g_nQueryChrCount + nHackerNewChrCount + nHackerDelChrCount + nHackerSelChrCount + n4ADC1C + n4ADC20 + n4ADC24 + n4ADC28;
  if n4ADBB8 <> n8 then begin
    n4ADBB8:=n8;
    OutMainMessage('H-QyChr=' + IntToStr(g_nQueryChrCount) + ' ' +
                   'H-NwChr=' + IntToStr(nHackerNewChrCount) + ' ' +
                   'H-DlChr=' + IntToStr(nHackerDelChrCount) + ' ' +
                   'Dubl-Sl=' + IntToStr(nHackerSelChrCount) + ' ' +
                   'H-Er-P1=' + IntToStr(n4ADC1C) + ' ' +
                   'Dubl-P2=' + IntToStr(n4ADC20) + ' ' +
                   'Dubl-P3=' + IntToStr(n4ADC24) + ' ' +
                   'Dubl-P4=' + IntToStr(n4ADC28));
  end;
end;

function TFrmUserSoc.GetUserCount():Integer;
var
  i:Integer;
  GateInfo:pTGateInfo;
  nUserCount:Integer;
begin
  nUserCount:=0;
  try
    CS_GateSession.Enter;
    for I := 0 to GateList.Count - 1 do begin
      GateInfo:=GateList.Items[i];
      Inc(nUserCount,GateInfo.UserList.Count);
    end;
  finally
    CS_GateSession.Leave;
  end;
  Result:=nUserCount;
end;

//创建新角色
function TFrmUserSoc.NewChrData(sChrName:String;nSex,nJob,nHair:Integer):Boolean;
var
  ChrRecord:THumDataInfo;
begin
  Result:=False;
  FillChar(ChrRecord,SizeOf(THumDataInfo),#0);
  try
    //打开人物数据文件(Mir.DB)，查询该人物是否存在，如不在，则创建人物
    if HumDataDB.Open and (HumDataDB.Index(sChrName) = -1) then begin
      ChrRecord.Header.sName:=sChrName;
      ChrRecord.Data.sChrName:=sChrName;
      ChrRecord.Data.btSex:=nSex;
      ChrRecord.Data.btJob:=nJob;
      ChrRecord.Data.btHair:=nHair;
      HumDataDB.Add(ChrRecord);
      Result:= True;
    end;
  finally
    HumDataDB.Close;
  end;
end;


procedure TFrmUserSoc.LoadServerInfo;
//0x004A2018
var
  I: Integer;
  LoadList:TStringList;
  nRouteIdx,nGateIdx,nServerIndex:Integer;
  sLineText,sSelGateIPaddr,sGameGateIPaddr,sGameGate,sGameGatePort,sMapName,sMapInfo,sServerIndex:String;
  Conf:TIniFile;
begin
  try
    LoadList:=TStringList.Create;
    FillChar(g_RouteInfo,SizeOf(g_RouteInfo),#0);
    LoadList.LoadFromFile(sGateConfFileName);
    nRouteIdx:=0;
    nGateIdx:=0;
    for I := 0 to LoadList.Count - 1 do begin
      sLineText:=Trim(LoadList.Strings[I]);
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sGameGate:=GetValidStr3(sLineText,sSelGateIPaddr,[' ',#9]);
        if (sGameGate = '') or (sSelGateIPaddr = '') then Continue;
        g_RouteInfo[nRouteIdx].sSelGateIP:=Trim(sSelGateIPaddr);
        g_RouteInfo[nRouteIdx].nGateCount:=0;
        nGateIdx:=0;
        while (sGameGate <> '') do begin
          sGameGate:=GetValidStr3(sGameGate,sGameGateIPaddr,[' ',#9]);
          sGameGate:=GetValidStr3(sGameGate,sGameGatePort,[' ',#9]);
          g_RouteInfo[nRouteIdx].sGameGateIP[nGateIdx]:=Trim(sGameGateIPaddr);
          g_RouteInfo[nRouteIdx].nGameGatePort[nGateIdx]:=Str_ToInt(sGameGatePort,0);
          Inc(nGateIdx);
        end;
        g_RouteInfo[nRouteIdx].nGateCount:=nGateIdx;
        Inc(nRouteIdx);
      end;
    end;

    
    Conf:=TIniFile.Create(sConfFileName);
    sMapFile:=Conf.ReadString('Setup','MapFile',sMapFile);
    Conf.Free;
    MapList.Clear;
    if FileExists(sMapFile) then begin
      LoadList.Clear;
      LoadList.LoadFromFile(sMapFile);
      for I := 0 to LoadList.Count - 1 do begin
        sLineText:=LoadList.Strings[I];
        if (sLineText <> '') and (sLineText[1] = '[') then begin
         sLineText:=ArrestStringEx(sLineText,'[',']',sMapName);
         sMapInfo:=GetValidStr3(sMapName,sMapName,[#32,#9]);
         sServerIndex:=Trim(GetValidStr3(sMapInfo,sMapInfo,[#32,#9]));
         nServerIndex:=Str_ToInt(sServerIndex,0);
         MapList.AddObject(sMapName,TObject(nServerIndex));
        end;
      end;
    end;
    LoadList.Free;
  finally 
  end;
end;









function TFrmUserSoc.LoadChrNameList(sFileName: string):Boolean;
//0x0045C1A0
var
  i:integer;
begin
  Result:=False;
  if FileExists(sFileName) then begin
    DenyChrNameList.LoadFromFile(sFileName);
    i:=0;
    while (True) do begin
      if DenyChrNameList.Count <= i then break;
      if Trim(DenyChrNameList.Strings[i]) = '' then begin
        DenyChrNameList.Delete(i);
        Continue;
      end;
      Inc(i);
    end;
    Result:=True;
  end;


end;
function TFrmUserSoc.LoadClearMakeIndexList(sFileName: string):Boolean;
//0x0045C1A0
var
  i:integer;
  nIndex:integer;
  sLineText:String;
begin
  Result:=False;
  if FileExists(sFileName) then begin
    g_ClearMakeIndex.LoadFromFile(sFileName);
    i:=0;
    while (True) do begin
      if g_ClearMakeIndex.Count <= i then break;
      sLineText:=g_ClearMakeIndex.Strings[I];
      nIndex:=Str_ToInt(sLineText,-1);
      if nIndex < 0 then begin
        g_ClearMakeIndex.Delete(i);
        Continue;
      end;
      g_ClearMakeIndex.Objects[I]:=TObject(nIndex);
      Inc(i);
    end;
    Result:=True;
  end;
end;
procedure TFrmUserSoc.ProcessGateMsg(var GateInfo:pTGateInfo);
//0x004A3350
var
  s0C:String;
  s10:String;
  s19:Char;
  i:Integer;
  UserInfo:pTUserInfo;
begin
   while (True) do begin
     if Pos('$',GateInfo.sText) <= 0 then break;
     GateInfo.sText:=ArrestStringEx(GateInfo.sText,'%','$',s10);
     if s10 <> '' then begin
       s19:=s10[1];
       s10:=Copy(s10,2,Length(s10) -1);
       case Ord(s19) of
         Ord('-'): begin
           SendKeepAlivePacket(GateInfo.Socket);
           dwKeepAliveTick:=GetTickCount();
         end;
         Ord('A'): begin
           s10:=GetValidStr3(s10,s0C,['/']);
           for i:=0 to GateInfo.UserList.Count -1 do begin
             UserInfo:=GateInfo.UserList.Items[i];
             if UserInfo <> nil then begin
               if UserInfo.sConnID = s0C then begin
                 UserInfo.s2C:=UserInfo.s2C + s10;
                 if Pos('!',s10) < 1 then Continue;
                 ProcessUserMsg(UserInfo);
                 break;
               end;
             end;
           end;
         end;
         Ord('O'): begin
           s10:=GetValidStr3(s10,s0C,['/']);
           OpenUser(s0C,s10,GateInfo);
         end;
         Ord('X'): begin
           CloseUser(s10,GateInfo);
         end;
       end;
     end;//004A3587
   end;
end;
procedure TFrmUserSoc.SendKeepAlivePacket(Socket: TCustomWinSocket);
begin
  if Socket.Connected then
    Socket.SendText('%++$');
end;
procedure TFrmUserSoc.ProcessUserMsg(var UserInfo:pTUserInfo);
var
  s10:String;
  nC:Integer;
begin
  nC:=0;
  while (True) do begin
    if TagCount(UserInfo.s2C,'!') <= 0 then break;
    UserInfo.s2C:=ArrestStringEx(UserInfo.s2C,'#','!',s10);
    if s10 <> '' then begin
      s10:=Copy(s10,2,Length(s10)-1);
      if Length(s10) >= DEFBLOCKSIZE then begin
        DeCodeUserMsg(s10,UserInfo);
      end else Inc(n4ADC20);
    end else begin
      Inc(n4ADC1C);
      if nC >= 1 then begin
        UserInfo.s2C:='';
      end;
      Inc(nC);
    end;
  end;
end;

procedure TFrmUserSoc.OpenUser(sID, sIP: String;var GateInfo: pTGateInfo);
var
  I           :Integer;
  UserInfo    :pTUserInfo;
  sUserIPaddr :String;
  sGateIPaddr :String;
begin
  sGateIPaddr:=GetValidStr3(sIP,sUserIPaddr,['/']);
  for I:=0 to GateInfo.UserList.Count -1 do begin
    UserInfo:=GateInfo.UserList.Items[I];
    if (UserInfo <> nil) and (UserInfo.sConnID = sID) then begin
      exit;
    end;
  end;
  New(UserInfo);
  UserInfo.sAccount      :='';
  UserInfo.sUserIPaddr   :=sUserIPaddr;
  UserInfo.sGateIPaddr   :=sGateIPaddr;
  UserInfo.sConnID       :=sID;
  UserInfo.nSessionID    :=0;
  UserInfo.Socket        :=GateInfo.Socket;
  UserInfo.s2C           :='';
  UserInfo.dwTick34      :=GetTickCount();
  UserInfo.dwChrTick     :=GetTickCount();
  UserInfo.boChrSelected :=False;
  UserInfo.boChrQueryed  :=False;
  UserInfo.nSelGateID    :=GateInfo.nGateID;
  GateInfo.UserList.Add(UserInfo);
end;
//004A30B8
procedure TFrmUserSoc.CloseUser(sID: String; var GateInfo: pTGateInfo);
var
  I        :Integer;
  UserInfo :pTUserInfo;
begin
  for I:=0 to GateInfo.UserList.Count -1 do begin
    UserInfo:=GateInfo.UserList.Items[I];
    if (UserInfo <> nil) and (UserInfo.sConnID = sID) then begin
      if not FrmIDSoc.GetGlobaSessionStatus(UserInfo.nSessionID) then begin
        FrmIDSoc.SendSocketMsg(SS_SOFTOUTSESSION,UserInfo.sAccount + '/' + IntToStr(UserInfo.nSessionID));
        FrmIDSoc.CloseSession(UserInfo.sAccount,UserInfo.nSessionID);
      end;
      Dispose(UserInfo);
      GateInfo.UserList.Delete(I);
      break;
    end;
  end;
end;
procedure TFrmUserSoc.DeCodeUserMsg(sData: String;
  var UserInfo: pTUserInfo);//004A48E0
var
  sDefMsg,s18:String;
  Msg:TDefaultMessage;
begin
  sDefMsg:=Copy(sData,1,DEFBLOCKSIZE);
  s18:=Copy(sData,DEFBLOCKSIZE + 1,Length(sData) - DEFBLOCKSIZE);
  Msg:=DecodeMessage(sDefMsg);
  case Msg.Ident of
    CM_QUERYCHR: begin
      if not UserInfo.boChrQueryed or ((GetTIckCount - UserInfo.dwChrTick) > 200) then begin
        UserInfo.dwChrTick:=GetTickCount();
        if QueryChr(s18,UserInfo) then begin
          UserInfo.boChrQueryed:=True;
        end;
      end else begin
        Inc(g_nQueryChrCount);
        OutMainMessage('[超速操作] 查询人物 ' + UserInfo.sUserIPaddr);
      end;
    end;
    CM_NEWCHR: begin
      if (GetTickCount - UserInfo.dwChrTick) > 1000 then begin
        UserInfo.dwChrTick:=GetTickCount();
        if (UserInfo.sAccount <> '')
        and FrmIDSoc.CheckSession(UserInfo.sAccount,UserInfo.sUserIPaddr,UserInfo.nSessionID) then begin
          NewChr(s18,UserInfo);
          UserInfo.boChrQueryed:=False;
        end else begin
          OutOfConnect(UserInfo);
        end;
      end else begin
        Inc(nHackerNewChrCount);
        OutMainMessage('[超速操作] 创建人物 ' + UserInfo.sAccount + '/' + UserInfo.sUserIPaddr);
      end;
    end;
    CM_DELCHR: begin
      if (GetTickCount - UserInfo.dwChrTick) > 1000 then begin
        UserInfo.dwChrTick:=GetTickCount();
        if (UserInfo.sAccount <> '')
        and FrmIDSoc.CheckSession(UserInfo.sAccount,UserInfo.sUserIPaddr,UserInfo.nSessionID) then begin
          DelChr(s18,UserInfo);
          UserInfo.boChrQueryed:=False;
        end else begin
          OutOfConnect(UserInfo);
        end;
      end else begin
        Inc(nHackerDelChrCount);
        OutMainMessage('[超速操作] 删除人物 ' + UserInfo.sAccount + '/' + UserInfo.sUserIPaddr);
      end;
    end;
    CM_SELCHR: begin
      if not UserInfo.boChrQueryed then begin
        if (UserInfo.sAccount <> '')
        and FrmIDSoc.CheckSession(UserInfo.sAccount,UserInfo.sUserIPaddr,UserInfo.nSessionID) then begin
          if SelectChr(s18,UserInfo) then begin
            UserInfo.boChrSelected:=True;
          end;
        end else begin  //004A4D69
          OutOfConnect(UserInfo);
        end;
      end else begin//004A4D79
        Inc(nHackerSelChrCount);
        OutMainMessage('Double send _SELCHR ' + UserInfo.sAccount + '/' + UserInfo.sUserIPaddr);
      end;
    end;
    else begin
      Inc(n4ADC24);
    end;
  end;
end;
//004A3620
function TFrmUserSoc.QueryChr(sData: String; var UserInfo: pTUserInfo):Boolean;
var
  sAccount   :String;
  sSessionID :String;
  nSessionID :Integer;
  nChrCount  :Integer;
  ChrList    :TStringList;
  I          :Integer;
  nIndex     :Integer;
  ChrRecord  :THumDataInfo;
  HumRecord  :THumInfo;
  QuickID    :pTQuickID;
  btSex      :Byte;
  sChrName   :String;
  sJob       :String;
  sHair      :String;
  sLevel     :String;
  s40        :String;
begin
  Result     := False;
  sSessionID := GetValidStr3(DecodeString(sData),sAccount,['/']);
  nSessionID := Str_ToInt(sSessionID,-2);
  UserInfo.nSessionID:=nSessionID;
  nChrCount:=0;

  if FrmIDSoc.CheckSession(sAccount,UserInfo.sUserIPaddr,nSessionID) then begin
    FrmIDSoc.SetGlobaSessionNoPlay(nSessionID);
    UserInfo.sAccount:=sAccount;
    ChrList:=TStringList.Create;
    try
      if HumChrDB.Open and (HumChrDB.FindByAccount(sAccount,ChrList) >= 0) then begin
        try
          if HumDataDB.OpenEx then begin
            for I:=0 to ChrList.Count -1 do begin
              QuickID:=pTQuickID(ChrList.Objects[I]);
              //如果选择ID不对,则跳过
              if QuickID.nSelectID <> UserInfo.nSelGateID then Continue;
                
              if HumChrDB.GetBy(QuickID.nIndex,HumRecord) and not HumRecord.boDeleted then begin
                sChrName:=QuickID.sChrName;
                nIndex:=HumDataDB.Index(sChrName);
                if (nIndex < 0) or (nChrCount >= 2) then Continue;
                if HumDataDB.Get(nIndex,ChrRecord) >= 0 then begin
                  btSex:=ChrRecord.Data.btSex;
                  sJob:=IntToStr(ChrRecord.Data.btJob);
                  sHair:=IntToStr(ChrRecord.Data.btHair);
                  sLevel:=IntToStr(ChrRecord.Data.Abil.Level);
                  if HumRecord.boSelected then s40:=s40 + '*';
                    s40:=s40 + sChrName + '/' + sJob + '/' + sHair + '/' + sLevel + '/' + IntToStr(btSex) + '/';
                  Inc(nChrCount);
                end;
              end;
            end;
          end;
        finally
          HumDataDB.Close;
        end;
      end;
    finally
      HumChrDB.Close;
    end;
    ChrList.Free;
    SendUserSocket(UserInfo.Socket,
                   UserInfo.sConnID,
                   EncodeMessage(MakeDefaultMsg(SM_QUERYCHR,nChrCount,0,1,0)) + EncodeString(s40));
  //*ChrName/sJob/sHair/sLevel/sSex/
  end else begin
    SendUserSocket(UserInfo.Socket,
                   UserInfo.sConnID,
                   EncodeMessage(MakeDefaultMsg(SM_QUERYCHR_FAIL,nChrCount,0,1,0)));
    CloseUser(UserInfo.sConnID,CurGate);
  end;
end;
procedure TFrmUserSoc.OutOfConnect(Const UserInfo: pTUserInfo);
//004A4844
var
  Msg:TDefaultMessage;
  sMsg:String;
begin
  Msg:=MakeDefaultMsg(SM_OUTOFCONNECTION,0,0,0,0);
  sMsg:=EncodeMessage(Msg);
  SendUserSocket(UserInfo.Socket,sMsg,UserInfo.sConnID);
end;

procedure TFrmUserSoc.DelChr(sData: String;
  var UserInfo: pTUserInfo);
//004A424C
var
  sChrName:String;
  boCheck:Boolean;
  Msg:TDefaultMessage;
  sMsg:String;
  n10:Integer;
  HumRecord:THumInfo;
begin
  g_CheckCode.dwThread0:=1000300;
  sChrName:=DecodeString(sData);
  boCheck:=False;
  g_CheckCode.dwThread0:=1000301;
  try
    if HumChrDB.Open then begin
      n10:=HumChrDB.Index(sChrName);
      if n10 >= 0 then begin
        HumChrDB.Get(n10,HumRecord);
        if HumRecord.sAccount = UserInfo.sAccount then begin
          HumRecord.boDeleted:=True;
          HumRecord.dModDate:=Now();
          HumChrDB.Update(n10,HumRecord);
          boCheck:=True;
        end;
      end;
    end;
  finally
    HumChrDB.Close;
  end;
  g_CheckCode.dwThread0:=1000302;
  if boCheck then
    Msg:=MakeDefaultMsg(SM_DELCHR_SUCCESS,0,0,0,0)
  else
    Msg:=MakeDefaultMsg(SM_DELCHR_FAIL,0,0,0,0);

  sMsg:=EncodeMessage(Msg);
  SendUserSocket(UserInfo.Socket,UserInfo.sConnID,sMsg);
  g_CheckCode.dwThread0:=1000303;
end;

//创建人物角色
//向客户端返回的信息代码
// 0: [错误] 输入的角色名称包含非法字符!
// 2: [错误] 创建的角色名称已被使用!
// 3: [错误] 您只能创建二个游戏角色!
// 4: [错误] 创建角色时出现错误！ 错误代码 = 4

procedure TFrmUserSoc.NewChr(sData: String;var UserInfo: pTUserInfo);//004A3C08
var
  Data,sAccount,sChrName,sHair,sJob,sSex:String;
  nCode:Integer;
  Msg:TDefaultMessage;
  sMsg:String;
  HumRecord:THumInfo;
  i:Integer;
  nn,n08,nIndex:Integer;
  HumDBRecord:THumInfo;
begin
  nCode:= -1;
  Data:=DecodeString(sData);
  Data:=GetValidStr3(Data,sAccount,['/']);
  Data:=GetValidStr3(Data,sChrName,['/']);
  Data:=GetValidStr3(Data,sHair,['/']);
  Data:=GetValidStr3(Data,sJob,['/']);
  Data:=GetValidStr3(Data,sSex,['/']);
  if Trim(Data) <> '' then nCode:=0;
  
  sChrName:=Trim(sChrName);
  if length(sChrName) < 3 then nCode:=0;

  if g_boEnglishNames and not IsEnglishStr(sChrName) then nCode:=-1; //  语言验证
  if not CheckDenyChrName(sChrName) then nCode:= 2;
  
  if not CheckChrName(sChrName) then nCode:=0;
  for I := 1 to length(sChrName) do begin
    if (sChrName[i] = #$A1) or
       (sChrName[i] = ' ') or
       (sChrName[i] = '/') or
       (sChrName[i] = '@') or
       (sChrName[i] = '?') or
       (sChrName[i] = '''') or
       (sChrName[i] = '"') or
       (sChrName[i] = '\') or
       (sChrName[i] = '.') or
       (sChrName[i] = ',') or
       (sChrName[i] = ':') or
       (sChrName[i] = ';') or
       (sChrName[i] = '`') or
       (sChrName[i] = '~') or
       (sChrName[i] = '!') or
       (sChrName[i] = '#') or
       (sChrName[i] = '$') or
       (sChrName[i] = '%') or
       (sChrName[i] = '^') or
       (sChrName[i] = '&') or
       (sChrName[i] = '*') or
       (sChrName[i] = '(') or
       (sChrName[i] = ')') or
       (sChrName[i] = '-') or
       (sChrName[i] = '_') or
       (sChrName[i] = '+') or
       (sChrName[i] = '=') or
       (sChrName[i] = '|') or
       (sChrName[i] = '[') or
       (sChrName[i] = '{') or
       (sChrName[i] = ']') or
       (sChrName[i] = '}') then nCode:=0;    // 0: [错误] 输入的角色名称包含非法字符!
  end;

  if nCode = -1 then begin     //if1
  try
    HumDataDB.Lock;
    nIndex := HumDataDB.Index(sChrName);
    if nIndex >= 0 then nCode:=2;   //从查询人物在使用列表是否存，如果存在则设置nCode标记为2. 2: [错误] 创建角色名称已被其他人使用!
     
  finally
    HumDataDB.UnLock;
  end;

    try
      if HumChrDB.Open then begin

        //如果登录帐号人物角色数量小于2，则填定新角色的内容
        if HumChrDB.ChrCountOfAccount(sAccount) < 2 then begin
          HumRecord.sChrName         := sChrName;
          HumRecord.sAccount         := sAccount;
          HumRecord.boDeleted        := False;
          HumRecord.btCount          := 0;
          HumRecord.Header.sName     := sChrName;
          HumRecord.Header.nSelectID := UserInfo.nSelGateID;

          if HumRecord.Header.sName <> '' then
             if not HumChrDB.Add(HumRecord) then   nCode:= 2;  //2: [错误] 创建角色名称已被其他人使用!

         end else
           begin
             nCode:= 3;   //3: [错误] 您只能创建二个游戏角色!

           end;

      end;
    finally
      HumChrDB.Close;
    end;

  //新建人物角色
   if nCode = -1 then begin
        if NewChrData(sChrName,Str_ToInt(sSex,0),Str_ToInt(sJob,0),Str_ToInt(sHair,0)) then begin     //创建人物，加入人物传奇信息数据
           nCode:= 1;   //1: 创建成功
        end else begin
          nCode:=4;     //4: [错误] 创建角色时出现错误！ 错误代码 = 4
        end;
     
//    end else begin
//
//        //问题所在：删除人物要加条件。如果人物已经在，且没被禁用，则不能删除 。否则会把正常使用的人物被删除  Modified By lzx 2020/2/17
//        FrmDBSrv.DelHum(sChrName);
//        nCode:=4;

    end;

  end;   //if1

  if nCode = 1 then begin
    Msg:=MakeDefaultMsg(SM_NEWCHR_SUCCESS,0,0,0,0);   //创建人物角色成功
  end else begin
    Msg:=MakeDefaultMsg(SM_NEWCHR_FAIL,nCode,0,0,0);   //创建人物角色失败
  end;
  sMsg:=EncodeMessage(Msg);
  SendUserSocket(UserInfo.Socket,UserInfo.sConnID,sMsg);
end;

//004A440C
function TFrmUserSoc.SelectChr(sData: String;
  var UserInfo: pTUserInfo): Boolean;
var
  sAccount  :String;
  sChrName  :String;
  ChrList   :TStringList;
  HumRecord :THumInfo;
  I         :Integer;
  nIndex    :Integer;
  nMapIndex :Integer;
  QuickID   :pTQuickID;
  ChrRecord :THumDataInfo;
  sCurMap   :String;
  boDataOK  :Boolean;
  sDefMsg   :String;
  sRouteMsg :String;
  sRouteIP  :String;
  nRoutePort:Integer;
begin
  Result:=False;
  sChrName:=GetValidStr3(DecodeString(sData),sAccount,['/']);
  boDataOK:=False;
  if UserInfo.sAccount = sAccount then begin
    try
      if HumChrDB.Open then begin
        ChrList:=TStringList.Create;
        if HumChrDB.FindByAccount(sAccount,ChrList) >= 0 then begin
          for I := 0 to ChrList.Count - 1 do begin
            QuickID:=pTQuickID(ChrList.Objects[i]);
            nIndex:=QuickID.nIndex;
            if HumChrDB.GetBy(nIndex,HumRecord) then begin
              if HumRecord.sChrName = sChrName then begin
                HumRecord.boSelected:=True;
                HumChrDB.UpdateBy(nIndex,HumRecord);
              end else begin
                if HumRecord.boSelected then begin
                  HumRecord.boSelected:=False;
                  HumChrDB.UpdateBy(nIndex,HumRecord);
                end;
              end;
            end;
          end;
        end;
        ChrList.Free;
      end;
    finally
      HumChrDB.Close;
    end;
    try
      if HumDataDB.OpenEx then begin
        nIndex:=HumDataDB.Index(sChrName);
        if nIndex>= 0 then begin
          HumDataDB.Get(nIndex,ChrRecord);
          sCurMap:=ChrRecord.Data.sCurMap;
          boDataOK:=True;
        end;
      end;
    finally
      HumDataDB.Close;
    end;
  end;
    if boDataOK then begin
      nMapIndex:=GetMapIndex(sCurMap);
      sDefMsg:=EncodeMessage(MakeDefaultMsg(SM_STARTPLAY,0,0,0,0));
      sRouteIP:=GateRouteIP(CurGate.sGateaddr,nRoutePort);
      if g_boDynamicIPMode then sRouteIP:=UserInfo.sGateIPaddr; //使用动态IP

      sRouteMsg:=EncodeString(sRouteIP + '/' + IntToStr(nRoutePort + nMapIndex));
      SendUserSocket(UserInfo.Socket,
                     UserInfo.sConnID,
                     sDefMsg + sRouteMsg);
      FrmIDSoc.SetGlobaSessionPlay(UserInfo.nSessionID);
      Result:=True;
    end else begin
      SendUserSocket(UserInfo.Socket,
                     UserInfo.sConnID,
                     EncodeMessage(MakeDefaultMsg(SM_STARTFAIL,0,0,0,0)));
   end;
end;
function TFrmUserSoc.GateRoutePort(sGateIP:String):Integer;//004A2724
begin
  Result:=7200;
end;
function TFrmUserSoc.GateRouteIP(sGateIP:String;var nPort:Integer):String;//0x004A258C
  function GetRoute(RouteInfo:pTRouteInfo;var nGatePort:Integer):String;
  var
    nGateIndex:Integer;
  begin
    nGateIndex :=Random(RouteInfo.nGateCount);
    Result     :=RouteInfo.sGameGateIP[nGateIndex];
    nGatePort  :=RouteInfo.nGameGatePort[nGateIndex];
  end;
var
  I: Integer;
  RouteInfo:pTRouteInfo;
begin
  nPort:=0;
  Result:='';
  for I := Low(g_RouteInfo) to High(g_RouteInfo) do begin
    RouteInfo:=@g_RouteInfo[I];
    if RouteInfo.sSelGateIP = sGateIP then begin
      Result:=GetRoute(RouteInfo,nPort);
      break;
    end;
  end;    
end;
function TFrmUserSoc.GetMapIndex(sMap:String):Integer;//0x004A24D4
var
  i:Integer;
begin
  Result:=0;
  for I := 0 to MapList.Count - 1 do begin
    if MapList.Strings[i] =  sMap then begin
      Result:=Integer(MapList.Objects[i]);
      break;
    end;      
  end;
end;
procedure TFrmUserSoc.SendUserSocket(Socket: TCustomWinSocket; sSessionID,
  sSendMsg: String);
//004A2E18
begin
  Socket.SendText('%' + sSessionID + '/#' + sSendMsg + '!$');
end;
//0045C2C0
function TFrmUserSoc.CheckDenyChrName(sChrName: String): Boolean;
var
  i:Integer;
begin
  Result:=True;
  g_CheckCode.dwThread0:=1000700;
  for I := 0 to DenyChrNameList.Count - 1 do begin
    g_CheckCode.dwThread0:=1000701;
    if CompareText(sChrName,DenyChrNameList.Strings[i]) = 0 then begin
      g_CheckCode.dwThread0:=1000702;
      Result:=False;
      break;
    end;
  end;
  g_CheckCode.dwThread0:=1000703;
end;

end.