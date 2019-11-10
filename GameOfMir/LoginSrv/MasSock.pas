unit MasSock;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, JSocket;
type
  TMsgServerInfo = record
    sReceiveMsg     :String;
    Socket          :TCustomWinSocket;
    sServerName     :String;            //0x08
    nServerIndex    :Integer;           //0x0C
    nOnlineCount    :Integer;           //0x10
    dwKeepAliveTick :LongWord;          //0x14
    sIPaddr         :String;
  end;
  pTMsgServerInfo = ^TMsgServerInfo;
  TLimitServerUserInfo = record
    sServerName    :String;
    sName          :String;
    nLimitCountMin :Integer;
    nLimitCountMax :Integer;
  end;
  pTLimitServerUserInfo = ^TLimitServerUserInfo;
  TFrmMasSoc=class(TForm)
    MSocket: TServerSocket;

    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure MSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure MSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure MSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure MSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    procedure SortServerList(nIndex:Integer);
    procedure RefServerLimit(sServerName:String);
    function  LimitName(sServerName:String):String;
    procedure LoadUserLimit;
    { Private declarations }
  public
    m_ServerList:TList;
    procedure LoadServerAddr();
    function  CheckReadyServers():Boolean;
    procedure SendServerMsg(wIdent:Word;sServerName,sMsg:String);
    procedure SendServerMsgA(wIdent:Word;sMsg:String);
    function  IsNotUserFull(sServerName:String):Boolean;
    function  ServerStatus(sServerName:String):Integer;
    function  GetOnlineHumCount():Integer;
    { Public declarations }
  end;

var
  FrmMasSoc: TFrmMasSoc;
  nUserLimit:Integer;
  UserLimit:array[0..99] of TLimitServerUserInfo;

implementation

uses LSShare, LMain, HUtil32, Grobal2;

{$R *.DFM}
//00465934
procedure TFrmMasSoc.FormCreate(Sender : TObject);
var
  Config  :pTConfig;
begin
  Config:=@g_Config;
  m_ServerList:=TList.Create;
  MSocket.Address:=Config.sServerAddr;
  MSocket.Port:=Config.nServerPort;
  MSocket.Active:=True;
  LoadServerAddr();
  LoadUserLimit();
end;
//00465B08
procedure TFrmMasSoc.MSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I           :Integer;
  sRemoteAddr :String;
  boAllowed   :Boolean;
  MsgServer   :pTMsgServerInfo;
begin
  sRemoteAddr :=Socket.RemoteAddress;
  boAllowed   :=False;
  for I:= Low(ServerAddr) to High(ServerAddr) do
    if sRemoteAddr = ServerAddr[I] then begin
      boAllowed:=True;
      break;
    end;
  if boAllowed then begin
    New(MsgServer);
    FillChar(MsgServer^,SizeOf(TMsgServerInfo),#0);
    MsgServer.sReceiveMsg := '';
    MsgServer.Socket      := Socket;
    m_ServerList.Add(MsgServer);
  end else begin
    MainOutMessage('非法地址连接:' + sRemoteAddr);
    Socket.Close;
  end;
end;
//00465C54
procedure TFrmMasSoc.MSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I         :Integer;
  MsgServer :pTMsgServerInfo;
begin
  for I:= 0 to m_ServerList.Count - 1 do  begin
    MsgServer:=m_ServerList.Items[I];
    if MsgServer.Socket =  Socket then begin
      Dispose(MsgServer);
      m_ServerList.Delete(I);
      break;
    end;
  end;
end;

procedure TFrmMasSoc.MSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode:=0;
  Socket.Close;
end;
//0046611C
procedure TFrmMasSoc.MSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I            :Integer;
  MsgServer    :pTMsgServerInfo;
  sReviceMsg   :String;
  sMsg         :String;
  sCode        :String;
  sAccount     :String;
  sServerName  :String;
  sIndex       :String;
  sOnlineCount :String;
  nCode        :Integer;
  Config       :pTConfig;
begin
  Config:=@g_Config;
  for I:= 0 to m_ServerList.Count - 1 do  begin
    MsgServer:=m_ServerList.Items[I];
    if MsgServer.Socket =  Socket then begin
      sReviceMsg:=MsgServer.sReceiveMsg + Socket.ReceiveText;
      while (Pos(')',sReviceMsg) > 0) do begin
        sReviceMsg:=ArrestStringEx(sReviceMsg,'(',')',sMsg);
        if sMsg = '' then break;
        sMsg:=GetValidStr3(sMsg,sCode,['/']);
        nCode:=Str_ToInt(sCode,-1);
        case nCode of
          SS_SOFTOUTSESSION: begin
            sMsg:=GetValidStr3(sMsg,sAccount,['/']);
            CloseUser(Config,sAccount,Str_ToInt(sMsg,0));
          end;
          SS_SERVERINFO: begin
           sMsg:=GetValidStr3(sMsg,sServerName,['/']);
           sMsg:=GetValidStr3(sMsg,sIndex,['/']);
           sMsg:=GetValidStr3(sMsg,sOnlineCount,['/']);
           MsgServer.sServerName     := sServerName;
           MsgServer.nServerIndex    := Str_ToInt(sIndex,0);
           MsgServer.nOnlineCount    := Str_ToInt(sOnlineCount,0);
           MsgServer.dwKeepAliveTick := GetTickCount();
           SortServerList(I);
           nOnlineCountMin:=GetOnlineHumCount();
           if nOnlineCountMin > nOnlineCountMax then nOnlineCountMax:=nOnlineCountMin;
           SendServerMsgA(SS_KEEPALIVE,IntToStr(nOnlineCountMin));
           RefServerLimit(sServerName);
          end;
          UNKNOWMSG: SendServerMsgA(UNKNOWMSG,sMsg);
          else begin
            FrmMain.Memo1.Lines.Add(inttostr(nCode)); //Damian - Debugging purposes
          end;
        end;
      end;
    end;
    MsgServer.sReceiveMsg:=sReviceMsg;
  end;
end;

procedure TFrmMasSoc.FormDestroy(Sender : TObject);
begin
  m_ServerList.Free;
end;

//00465CF8
procedure TFrmMasSoc.RefServerLimit(sServerName:String);
var
  I         :Integer;
  nCount    :Integer;
  MsgServer :pTMsgServerInfo;
begin
try
  nCount:=0;
  for I:=0 to m_ServerList.Count -1 do begin
    MsgServer:=m_ServerList.Items[I];
    if (MsgServer.nServerIndex <> 99) and (MsgServer.sServerName = sServerName) then
      Inc(nCount,MsgServer.nOnlineCount);
  end;
  for I:=Low(UserLimit) to High(UserLimit) do begin
    if UserLimit[I].sServerName = sServerName then begin
      UserLimit[I].nLimitCountMin:=nCount;
      break;
    end;
  end;
except
  MainOutMessage('TFrmMasSoc.RefServerLimit');
end;
end;


//00465E78
function TFrmMasSoc.IsNotUserFull(sServerName:String):Boolean;
var
  I: Integer;
begin
  Result:=True;
  for I := Low(UserLimit) to High(UserLimit) do begin
    if UserLimit[I].sServerName = sServerName then begin
      if UserLimit[I].nLimitCountMin > UserLimit[I].nLimitCountMax then
        Result:=False;
      break;
    end;
  end;
end;
//00465F18
procedure TFrmMasSoc.SortServerList(nIndex:Integer);
var
  nC,n10,n14: Integer;
  MsgServerSort:pTMsgServerInfo;
  MsgServer:pTMsgServerInfo;
  nNewIndex:integer;
begin
try
  if m_ServerList.Count <= nIndex then exit;
  MsgServerSort:=m_ServerList.Items[nIndex];
  m_ServerList.Delete(nIndex);
  for nC := 0 to m_ServerList.Count - 1 do begin
    MsgServer:=m_ServerList.Items[nC];
    if MsgServer.sServerName = MsgServerSort.sServerName then begin
      if MsgServer.nServerIndex < MsgServerSort.nServerIndex then begin
        m_ServerList.Insert(nC,MsgServerSort);
        exit;
      end else begin //00465FD8
        nNewIndex:=nC + 1;
        if nNewIndex < m_ServerList.Count then begin   //Jacky 增加
        for n10 := nNewIndex to m_ServerList.Count - 1 do begin
          MsgServer:=m_ServerList.Items[n10];
          if MsgServer.sServerName = MsgServerSort.sServerName then begin
            if MsgServer.nServerIndex < MsgServerSort.nServerIndex then begin
              m_ServerList.Insert(n10,MsgServerSort);
              for n14:= n10 + 1 to m_ServerList.Count - 1 do begin
                MsgServer:=m_ServerList.Items[n14];
                if (MsgServer.sServerName = MsgServerSort.sServerName) and (MsgServer.nServerIndex = MsgServerSort.nServerIndex) then begin
                  m_ServerList.Delete(n14);
                  exit;
                end;
              end;
              exit;
            end else begin //004660D1
              nNewIndex:=n10 + 1;
            end;
          end;
        end; //00465FF1
        m_ServerList.Insert(nNewIndex,MsgServerSort);
        exit;
        end;
      end;
    end;
  end;
  m_ServerList.Add(MsgServerSort);
except
  MainOutMessage('TFrmMasSoc.SortServerList');
end;
end;


//004665BD
procedure TFrmMasSoc.SendServerMsg(wIdent:Word;sServerName,sMsg:String);
var
  I         :Integer;
  MsgServer :pTMsgServerInfo;
  sSendMsg  :String;
  s18       :String;
ResourceString
  sFormatMsg = '(%d/%s)';
begin
try
  s18:=LimitName(sServerName);
  sSendMsg:=format(sFormatMsg,[wIdent,sMsg]);
  for I:=0 to m_ServerList.Count -1 do begin
    MsgServer:=pTMsgServerInfo(m_ServerList.Items[I]);
    if MsgServer.Socket.Connected then begin
      if (s18 = '') or (MsgServer.sServerName = '') or (CompareText(MsgServer.sServerName,s18) = 0) or (MsgServer.nServerIndex = 99) then begin
        MsgServer.Socket.SendText(sSendMsg);
      end;
    end;
  end;
except
  MainOutMessage('TFrmMasSoc.SendServerMsg');
end;
end;
//004659BC
procedure TFrmMasSoc.LoadServerAddr();
var
  sFileName    :String;
  LoadList     :TStringList;
  I,nServerIdx :Integer;
  sLineText    :String;
begin
  sFileName:='.\!ServerAddr.txt';
  nServerIdx:=0;
  FillChar(ServerAddr,SizeOf(ServerAddr),#0);
  if FileExists(sFileName) then begin
    LoadList:=TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for I := 0 to LoadList.Count - 1 do begin
      sLineText:=Trim(LoadList.Strings[i]);
      if (sLineText <> '') and (sLineText[I] <> ';') then begin
        if TagCount(sLineText,'.') = 3 then begin
          ServerAddr[nServerIdx]:=sLineText;
          Inc(nServerIdx);
          if nServerIdx >= 100 then break;
        end;
      end;
    end;
    LoadList.Free;
  end;
end;


//00466460
function  TFrmMasSoc.GetOnlineHumCount():Integer;
var
  i,nCount:Integer;
  MsgServer:pTMsgServerInfo;
begin
try
  nCount:=0;
  for i:=0 to m_ServerList.Count -1 do begin
    MsgServer:=m_ServerList.Items[i];
    if MsgServer.nServerIndex <> 99 then
      Inc(nCount,MsgServer.nOnlineCount);
  end;
  Result:=nCount;
except
  MainOutMessage('TFrmMasSoc.GetOnlineHumCount');
end;
end;
//00465AD8
function TFrmMasSoc.CheckReadyServers: Boolean;
var
  Config  :pTConfig;
begin
  Config:=@g_Config;
  Result:=False;
  if m_ServerList.Count >= Config.nReadyServers then
    Result:=True;
end;

//004664B0
procedure TFrmMasSoc.SendServerMsgA(wIdent: Word; sMsg: String);
var
  I         :Integer;
  sSendMsg  :String;
  MsgServer :pTMsgServerInfo;
ResourceString
  sFormatMsg = '(%d/%s)';
begin
try
  sSendMsg:=format(sFormatMsg,[wIdent,sMsg]);
  for I:=0 to m_ServerList.Count -1 do begin
    MsgServer:=pTMsgServerInfo(m_ServerList.Items[I]);
    if MsgServer.Socket.Connected then MsgServer.Socket.SendText(sSendMsg);
  end;
except
  on e: Exception do begin
    MainOutMessage('TFrmMasSoc.SendServerMsgA');
    MainOutMessage(E.Message);    
  end;
end;
end;
//00465DE0
function TFrmMasSoc.LimitName(sServerName: String): String;
var
  i:Integer;
begin
try
  Result:='';
  for i:=Low(UserLimit) to High(UserLimit) do begin
    if CompareText(UserLimit[i].sServerName,sServerName) = 0 then begin
      Result:=UserLimit[i].sName;
      break;
    end;
  end;
except
  MainOutMessage('TFrmMasSoc.LimitName');
end;
end;
//00465730
procedure TFrmMasSoc.LoadUserLimit();
var
  LoadList:TStringList;
  sFileName:String;
  i,nC:integer;
  sLineText,sServerName,s10,s14:String;

begin
  nC:=0;
  sFileName:='.\!UserLimit.txt';
  if FileExists(sFileName) then begin
    LoadList:=TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for i:= 0 to LoadList.Count - 1 do begin
      sLineText:=LoadList.Strings[i];
      sLineText:=GetValidStr3(sLineText,sServerName,[' ',#9]);
      sLineText:=GetValidStr3(sLineText,s10,[' ',#9]);
      sLineText:=GetValidStr3(sLineText,s14,[' ',#9]);
      if sServerName <> '' then begin
        UserLimit[nC].sServerName:=sServerName;
        UserLimit[nC].sName:=s10;
        UserLimit[nC].nLimitCountMax:=Str_ToInt(s14,3000);
        UserLimit[nC].nLimitCountMin:=0;
        Inc(nC);
      end;
    end;
    nUserLimit:=nC;
    LoadList.Free;
  end else ShowMessage('[Critical Failure] file not found. .\!UserLimit.txt');
end;
function TFrmMasSoc.ServerStatus(sServerName: String): Integer;
var
  I              :Integer;
  nStatus        :Integer;
  MsgServer      :pTMsgServerInfo;
  boServerOnLine :Boolean;
begin
try
  Result:=0;
  boServerOnLine:=False;
  for I:=0 to m_ServerList.Count -1 do begin
    MsgServer:=m_ServerList.Items[I];
    if (MsgServer.nServerIndex <> 99) and (MsgServer.sServerName = sServerName) then begin
      boServerOnLine:=True;
    end;
  end;
  if not boServerOnLine then exit;
    
  for I := Low(UserLimit) to High(UserLimit) do begin
    if UserLimit[I].sServerName = sServerName then begin
      if UserLimit[I].nLimitCountMin <= UserLimit[I].nLimitCountMax div 2 then begin
        nStatus:=1; //空闲
        break;
      end;

      if UserLimit[I].nLimitCountMin <= UserLimit[I].nLimitCountMax - (UserLimit[I].nLimitCountMax div 5) then begin
        nStatus:=2; //良好
        break;
      end;
      if UserLimit[I].nLimitCountMin < UserLimit[I].nLimitCountMax then begin
        nStatus:=3; //繁忙
        break;
      end;
      if UserLimit[I].nLimitCountMin >= UserLimit[I].nLimitCountMax then begin
        nStatus:=4; //满员
        break;
      end;
    end;
  end;
  Result:=nStatus;
except
  MainOutMessage('TFrmMasSoc.ServerStatus');
end;
end;

end.
