unit IdSrvClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, IniFiles, JSocket, WinSock, Grobal2, SDK, M2Share, MudUtil;

type
  TFrmIDSoc = class(TForm)
    IDSocket: TClientSocket;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IDSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure IDSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure IDSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure IDSocketDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
  private

    TList_2DC: TList;
    IDSrvAddr: string; //0x2E0
    IDSrvPort: Integer; //0x2E4
//    sIDSckStr :String; //0x2E8
//    boConnected:Boolean;
    dwClearEmptySessionTick: LongWord;
    procedure GetPasswdSuccess(sData: string);
    procedure GetCancelAdmission(sData: string);
    procedure GetCancelAdmissionA(sData: string);
    procedure SetTotalHumanCount(sData: string);
    procedure GetServerLoad(sData: string);
    procedure DelSession(nSessionID: Integer);
    procedure NewSession(sAccount, sIPaddr: string; nSessionID, nPayMent, nPayMode: Integer);
    procedure ClearSession();
    procedure ClearEmptySession();
    procedure SendSocket(sSENDMSG: string);
    { Private declarations }
  public
    m_SessionList: TGList; //0x2D8
    procedure Initialize();
    procedure Run();
    procedure SendOnlineHumCountMsg(nCount: Integer);
    procedure SendHumanLogOutMsg(sUserID: string; nID: Integer);
    function GetAdmission(sAccount, sIPaddr: string; nSessionID: Integer; var nPayMode: Integer; var nPayMent: Integer): pTSessInfo;
    function GetSessionCount(): Integer;
    procedure GetSessionList(List: TList);
    procedure SendLogonCostMsg(sAccount: string; nTime: Integer);
    procedure Close();
    { Public declarations }
  end;
procedure IDSocketThread(ThreadInfo: pTThreadInfo); stdcall;
var
  FrmIDSoc: TFrmIDSoc;

implementation

uses HUtil32;

{$R *.dfm}

{ TFrmIDSoc }



procedure TFrmIDSoc.FormCreate(Sender: TObject);
var
  Conf: TIniFile;
begin
  IDSocket.Host := '';
  if FileExists(sConfigFileName) then
  begin
    Conf := TIniFile.Create(sConfigFileName);
    if Conf <> nil then
    begin
      IDSrvAddr := Conf.ReadString('Server', 'IDSAddr', '127.0.0.1');
      IDSrvPort := Conf.ReadInteger('Server', 'IDSPort', 5600);
    end;
    Conf.Free;
  end else
    ShowMessage('File not found... <' + sConfigFileName + '>');

  m_SessionList := TGList.Create;
  TList_2DC := TList.Create;
  g_Config.boIDSocketConnected := False;
//    sub_48D290();
end;

procedure TFrmIDSoc.FormDestroy(Sender: TObject);
begin
  ClearSession();
  m_SessionList.Free;
  TList_2DC.Free;
end;

procedure TFrmIDSoc.Timer1Timer(Sender: TObject);
begin
  if not IDSocket.Active then
  begin
    IDSocket.Active := True;
  end;
end;

procedure TFrmIDSoc.IDSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmIDSoc.IDSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  EnterCriticalSection(g_Config.UserIDSection);
  try
    g_Config.sIDSocketRecvText := g_Config.sIDSocketRecvText + Socket.ReceiveText;
  finally
    LeaveCriticalSection(g_Config.UserIDSection);
  end;
end;

procedure TFrmIDSoc.Initialize; //0048D3F8
begin
  IDSocket.Active := False;
  IDSocket.Address := IDSrvAddr;
  IDSocket.Port := IDSrvPort;
  IDSocket.Active := True;
  Timer1.Enabled := True;
end;
{$IF IDSOCKETMODE = TIMERENGINE}
procedure TFrmIDSoc.SendSocket(sSENDMSG: string);
begin
  if IDSocket.Socket.Connected then
  begin
    IDSocket.Socket.SendText(sSENDMSG);
  end;
end;
{$ELSE}
procedure TFrmIDSoc.SendSocket(sSENDMSG: string);
var
  boSendData: Boolean;
  Config: pTM2Config;
  ThreadInfo: pTThreadInfo;
  timeout: TTimeVal;
  writefds: TFDSet;
  nRet: Integer;
  s: TSocket;
begin
  Config := @g_Config;
  ThreadInfo := @g_Config.DBSOcketThread;
  s := Config.IDSocket;
  boSendData := False;
  while True do
  begin
    if not boSendData then Sleep(1)
    else Sleep(0);
    boSendData := False;
    ThreadInfo.dwRunTick := GetTickCount();
    ThreadInfo.boActived := True;
    ThreadInfo.nRunFlag := 128;

    ThreadInfo.nRunFlag := 129;
    timeout.tv_sec := 0;
    timeout.tv_usec := 20;

    writefds.fd_count := 1;
    writefds.fd_array[0] := s;

    nRet := select(0, nil, @writefds, nil, @timeout);
    if nRet = SOCKET_ERROR then
    begin
      nRet := WSAGetLastError();
      Config.nIDSocketWSAErrCode := nRet - WSABASEERR;
      Inc(Config.nIDSocketErrorCount);
      if nRet = WSAEWOULDBLOCK then
      begin
        Continue;
      end;
      if Config.IDSocket = INVALID_SOCKET then Break;
      Config.IDSocket := INVALID_SOCKET;
      Sleep(100);
      Config.boIDSocketConnected := False;
      Break;
    end;
    if nRet <= 0 then
    begin
      Continue;
    end;
    boSendData := True;
    nRet := send(s, sSENDMSG[1], Length(sSENDMSG), 0);
    if nRet = SOCKET_ERROR then
    begin
      Inc(Config.nIDSocketErrorCount);
      Config.nIDSocketWSAErrCode := WSAGetLastError - WSABASEERR;
      Continue;
    end;
    Inc(Config.nDBSocketSendLen, nRet);
    Break;
  end;
end;
{$IFEND}
procedure TFrmIDSoc.SendHumanLogOutMsg(sUserID: string; nID: Integer); //0048D448
var
  i: Integer;
  SessInfo: pTSessInfo;
resourcestring
  sFormatMsg = '(%d/%s/%d)';
begin
  m_SessionList.Lock;
  try
    for i := 0 to m_SessionList.Count - 1 do
    begin
      SessInfo := m_SessionList.Items[i];
      if (SessInfo.nSessionID = nID) and (SessInfo.sAccount = sUserID) then
      begin
        //SessInfo.dwCloseTick:=GetTickCount();
        //SessInfo.boClosed:=True;
        Break;
      end;
    end;
  finally
    m_SessionList.UnLock;
  end;
  SendSocket(Format(sFormatMsg, [SS_SOFTOUTSESSION, sUserID, nID]));
end;

procedure TFrmIDSoc.SendLogonCostMsg(sAccount: string; nTime: Integer); //0048D53C
resourcestring
  sFormatMsg = '(%d/%s/%d)';
begin
  SendSocket(Format(sFormatMsg, [SS_LOGINCOST, sAccount, nTime]));
end;

procedure TFrmIDSoc.SendOnlineHumCountMsg(nCount: Integer);
resourcestring
  sFormatMsg = '(%d/%s/%d/%d)';
begin
  SendSocket(Format(sFormatMsg, [SS_SERVERINFO, g_Config.sServerName, nServerIndex, nCount]));
end;

procedure TFrmIDSoc.Run; //0048D724
var
  sSocketText: string;
  sData: string;
  sBody: string;
  sCode: string;
  nLen: Integer;
  Config: pTM2Config;
resourcestring
  sExceptionMsg = '[Exception] TFrmIdSoc::DecodeSocStr';
begin
  Config := @g_Config;
  EnterCriticalSection(Config.UserIDSection);
  try
    if Pos(')', Config.sIDSocketRecvText) <= 0 then Exit;
    sSocketText := Config.sIDSocketRecvText;
    Config.sIDSocketRecvText := '';
  finally
    LeaveCriticalSection(Config.UserIDSection);
  end;
  try
    while (True) do
    begin
      sSocketText := ArrestStringEx(sSocketText, '(', ')', sData);
      if sData = '' then Break;
      sBody := GetValidStr3(sData, sCode, ['/']);
      case Str_ToInt(sCode, 0) of
        SS_OPENSESSION {100}: GetPasswdSuccess(sBody);
        SS_CLOSESESSION {101}: GetCancelAdmission(sBody);
        SS_KEEPALIVE {104}: SetTotalHumanCount(sBody);
        UNKNOWMSG: ;
        SS_KICKUSER {111}: GetCancelAdmissionA(sBody);
        SS_SERVERLOAD {113}: GetServerLoad(sBody);
      end;
      if Pos(')', sSocketText) <= 0 then Break;
    end;
    EnterCriticalSection(Config.UserIDSection);
    try
      Config.sIDSocketRecvText := sSocketText + Config.sIDSocketRecvText;
    finally
      LeaveCriticalSection(Config.UserIDSection);
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
  if GetTickCount - dwClearEmptySessionTick > 10000 then
  begin
    dwClearEmptySessionTick := GetTickCount();
    //ClearEmptySession();
  end;
{$IF (DEBUG = 0) and (SoftVersion <> VERDEMO)}
  if IsDebuggerPresent then
    Application.Terminate;
{$IFEND}
end;

procedure TFrmIDSoc.GetPasswdSuccess(sData: string); //0048D9B4
var
  sAccount: string;
  sSessionID: string;
  sPayCost: string;
  sIPaddr: string;
  sPayMode: string;
resourcestring
  sExceptionMsg = '[Exception] TFrmIdSoc::GetPasswdSuccess';
begin
  try
    sData := GetValidStr3(sData, sAccount, ['/']);
    sData := GetValidStr3(sData, sSessionID, ['/']);
    sData := GetValidStr3(sData, sPayCost, ['/']); //boPayCost
    sData := GetValidStr3(sData, sPayMode, ['/']); //nPayMode
    sData := GetValidStr3(sData, sIPaddr, ['/']); //sIPaddr
    NewSession(sAccount, sIPaddr, Str_ToInt(sSessionID, 0), Str_ToInt(sPayCost, 0), Str_ToInt(sPayMode, 0));
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

procedure TFrmIDSoc.GetCancelAdmission(sData: string); //0048DB60
var
  SC, sSessionID: string;
resourcestring
  sExceptionMsg = '[Exception] TFrmIdSoc::GetCancelAdmission';
begin
  try
    sSessionID := GetValidStr3(sData, SC, ['/']);
    DelSession(Str_ToInt(sSessionID, 0));
  except
    on E: Exception do
    begin
      MainOutMessage(sExceptionMsg);
      MainOutMessage(E.Message);
    end;
  end;
end;

procedure TFrmIDSoc.NewSession(sAccount, sIPaddr: string; nSessionID, nPayMent, nPayMode: Integer); //0048DC44
var
  SessInfo: pTSessInfo;
begin
  New(SessInfo);
  SessInfo.sAccount := sAccount;
  SessInfo.sIPaddr := sIPaddr;
  SessInfo.nSessionID := nSessionID;
  SessInfo.nPayMent := nPayMent;
  SessInfo.nPayMode := nPayMode;
  SessInfo.nSessionStatus := 0;
  SessInfo.dwStartTick := GetTickCount();
  SessInfo.dwActiveTick := GetTickCount();
  SessInfo.nRefCount := 1;
  m_SessionList.Lock;
  try
    m_SessionList.Add(SessInfo);
  finally
    m_SessionList.UnLock;
  end;
end;

procedure TFrmIDSoc.DelSession(nSessionID: Integer); //0048DD5C
var
  i: Integer;
  sAccount: string;
  SessInfo: pTSessInfo;
resourcestring
  sExceptionMsg = '[Exception] FrmIdSoc::DelSession %d';
begin
  try

    sAccount := '';
    m_SessionList.Lock;
    try

      for i := 0 to m_SessionList.Count - 1 do
      begin
        SessInfo := m_SessionList.Items[i];

        if SessInfo.nSessionID = nSessionID then
        begin
          sAccount := SessInfo.sAccount;
          m_SessionList.Delete(i);
          Dispose(SessInfo);
          Break;
        end;
      end;

    finally
      m_SessionList.UnLock;
    end;

    if sAccount <> '' then
    begin

      RunSocket.KickUser(sAccount, nSessionID);

    end;

  except
    on E: Exception do
    begin
      MainOutMessage(Format(sExceptionMsg, [0]));
      MainOutMessage(E.Message);
    end;
  end;

end;
procedure TFrmIDSoc.ClearEmptySession;
var
  i: Integer;
  SessInfo: pTSessInfo;
begin
  m_SessionList.Lock;
  try
    for i := m_SessionList.Count - 1 downto 0 do
    begin
      SessInfo := m_SessionList.Items[i];
      if SessInfo.nRefCount <= 0 then
      begin
        Dispose(SessInfo);
        m_SessionList.Delete(i);
        Continue;
      end;
      {
      if GetTickCount - SessInfo.dwActiveTick > 10 * 60 * 1000 then begin
        Dispose(SessInfo);
        m_SessionList.Delete(I);
        Continue;
      end;
      }
    end;
  finally
    m_SessionList.UnLock;
  end;
end;

procedure TFrmIDSoc.ClearSession;
var
  i: Integer;
begin
  m_SessionList.Lock;
  try
    for i := 0 to m_SessionList.Count - 1 do
    begin
      Dispose(pTSessInfo(m_SessionList.Items[i]));
    end;
    m_SessionList.Clear;
  finally
    m_SessionList.UnLock;
  end;

end;

function TFrmIDSoc.GetAdmission(sAccount, sIPaddr: string; nSessionID: Integer; var nPayMode: Integer; var nPayMent: Integer): pTSessInfo; //0048DE80
var
  i: Integer;
  nCount: Integer;
  SessInfo: pTSessInfo;
  boFound: Boolean;
resourcestring
  sGetFailMsg = '[Exception] Failed to get admission (%s/%s/%d)';
begin

//  Result:=3;
//  exit;
  boFound := False;
  Result := nil;
  nPayMent := 0;
  nPayMode := 0;
  m_SessionList.Lock;
  try

    for i := 0 to m_SessionList.Count - 1 do
    begin
      SessInfo := m_SessionList.Items[i];

      if (SessInfo.nSessionID = nSessionID) and
        (SessInfo.sAccount = sAccount) {and (SessInfo.sIPaddr = sIPaddr)} then
      begin
        //if SessInfo.nSessionStatus <> 0 then break;
        //SessInfo.nSessionStatus:=1;

        case SessInfo.nPayMent of
          2: nPayMent := 3;
          1: nPayMent := 2;
          0: nPayMent := 1;
        end;
        Result := SessInfo;
        nPayMode := SessInfo.nPayMode;
        boFound := True;

        Break;
      end;
    end;

  finally
    m_SessionList.UnLock;
  end;

  if g_Config.boViewAdmissionFailure and not boFound then
  begin
    MainOutMessage(Format(sGetFailMsg, [sAccount, sIPaddr, nSessionID]));
  end;

end;

procedure TFrmIDSoc.SetTotalHumanCount(sData: string); //0048E014
begin
  g_nTotalHumCount := Str_ToInt(sData, 0)
end;

procedure TFrmIDSoc.GetCancelAdmissionA(sData: string); //0048E06C
var
  nSessionID: Integer;
  sSessionID: string;
  sAccount: string;
resourcestring
  sExceptionMsg = '[Exception] FrmIdSoc::GetCancelAdmissionA';
begin
  try
    sSessionID := GetValidStr3(sData, sAccount, ['/']);
    nSessionID := Str_ToInt(sSessionID, 0);
    if not g_Config.boTestServer then
    begin
      UserEngine.HumanExpire(sAccount);
      DelSession(nSessionID);
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;


procedure TFrmIDSoc.GetServerLoad(sData: string); //0048E174
var
  SC, s10, s14, s18, s1C: string;
begin
  sData := GetValidStr3(sData, SC, ['/']);
  sData := GetValidStr3(sData, s10, ['/']);
  sData := GetValidStr3(sData, s14, ['/']);
  sData := GetValidStr3(sData, s18, ['/']);
  sData := GetValidStr3(sData, s1C, ['/']);
  nCurrentMonthly := Str_ToInt(SC, 0);
  nLastMonthlyTotalUsage := Str_ToInt(s10, 0);
  nTotalTimeUsage := Str_ToInt(s14, 0);
  nGrossTotalCnt := Str_ToInt(s18, 0);
  nGrossResetCnt := Str_ToInt(s1C, 0);
end;
procedure TFrmIDSoc.IDSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  g_Config.boIDSocketConnected := True;
  MainOutMessage('登录服务器连接成功(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')');
end;

procedure TFrmIDSoc.IDSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if g_Config.boIDSocketConnected then
  begin
    ClearSession();
    g_Config.boIDSocketConnected := False;
    MainOutMessage('LoginServer Disconnected(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')');
  end;
end;
{$IF IDSOCKETMODE = TIMERENGINE}
procedure TFrmIDSoc.Close;
begin
  Timer1.Enabled := False;
  IDSocket.Active := False;
end;
{$ELSE}
procedure TFrmIDSoc.Close;
var
  ThreadInfo: pTThreadInfo;
begin
  ThreadInfo := @g_Config.IDSocketThread;
  ThreadInfo.boTerminaled := True;
  if WaitForSingleObject(ThreadInfo.hThreadHandle, 1000) <> 0 then
  begin
    SuspendThread(ThreadInfo.hThreadHandle);
  end;
end;
{$IFEND}
function TFrmIDSoc.GetSessionCount: Integer;
begin
  Result := 0;
  m_SessionList.Lock;
  try
    Result := m_SessionList.Count;
  finally
    m_SessionList.UnLock;
  end;
end;

procedure TFrmIDSoc.GetSessionList(List: TList);
var
  i: Integer;
begin
  m_SessionList.Lock;
  try
    for i := 0 to m_SessionList.Count - 1 do
    begin
      List.Add(m_SessionList.Items[i]);
    end;
  finally
    m_SessionList.UnLock;
  end;
end;

procedure IDSocketRead(Config: pTM2Config);
var
  dwReceiveTimeTick: LongWord;
  nReceiveTime: Integer;
  sRecvText: string;
  nRecvLen: Integer;
  nRet: Integer;
begin
  if Config.IDSocket = INVALID_SOCKET then Exit;

  dwReceiveTimeTick := GetTickCount();
  nRet := ioctlsocket(Config.IDSocket, FIONREAD, nRecvLen);
  if (nRet = SOCKET_ERROR) or (nRecvLen = 0) then
  begin
    nRet := WSAGetLastError;
    Config.IDSocket := INVALID_SOCKET;
    Sleep(100);
    Config.boIDSocketConnected := False;
    Exit;
  end;
  setlength(sRecvText, nRecvLen);
  nRecvLen := recv(Config.IDSocket, Pointer(sRecvText)^, nRecvLen, 0);
  setlength(sRecvText, nRecvLen);

  Inc(Config.nIDSocketRecvIncLen, nRecvLen);
  if (nRecvLen <> SOCKET_ERROR) and (nRecvLen > 0) then
  begin
    if nRecvLen > Config.nIDSocketRecvMaxLen then Config.nIDSocketRecvMaxLen := nRecvLen;
    EnterCriticalSection(Config.UserIDSection);
    try
      Config.sIDSocketRecvText := Config.sIDSocketRecvText + sRecvText;
    finally
      LeaveCriticalSection(Config.UserIDSection);
    end;
    FrmIDSoc.Run;
  end;
  Inc(Config.nIDSocketRecvCount);
  nReceiveTime := GetTickCount - dwReceiveTimeTick;
  if Config.nIDReceiveMaxTime < nReceiveTime then Config.nIDReceiveMaxTime := nReceiveTime;
end;
procedure IDSocketProcess(Config: pTM2Config; ThreadInfo: pTThreadInfo);
var
  s: TSocket;
  Name: sockaddr_in;
  HostEnt: PHostEnt;
  argp: LongInt;
  readfds: TFDSet;
  timeout: TTimeVal;
  nRet: Integer;
  boRecvData: BOOL;
  nRunTime: Integer;
  dwRunTick: LongWord;
resourcestring
  sIDServerConnected = '登录服务器连接成功(%s:%d)';
begin
  s := INVALID_SOCKET;
  if Config.IDSocket <> INVALID_SOCKET then
    s := Config.IDSocket;
  dwRunTick := GetTickCount();
  ThreadInfo.dwRunTick := dwRunTick;
  boRecvData := False;
  while True do
  begin
    if ThreadInfo.boTerminaled then Break;
    if not boRecvData then Sleep(1)
    else Sleep(0);
    boRecvData := False;
    nRunTime := GetTickCount - ThreadInfo.dwRunTick;
    if ThreadInfo.nRunTime < nRunTime then ThreadInfo.nRunTime := nRunTime;
    if ThreadInfo.nMaxRunTime < nRunTime then ThreadInfo.nMaxRunTime := nRunTime;
    if GetTickCount - dwRunTick >= 1000 then
    begin
      dwRunTick := GetTickCount();
      if ThreadInfo.nRunTime > 0 then Dec(ThreadInfo.nRunTime);
    end;

    ThreadInfo.dwRunTick := GetTickCount();
    ThreadInfo.boActived := True;
    ThreadInfo.nRunFlag := 125;
    if (Config.IDSocket = INVALID_SOCKET) or (s = INVALID_SOCKET) then
    begin
      if Config.IDSocket <> INVALID_SOCKET then
      begin
        Config.IDSocket := INVALID_SOCKET;
        Sleep(100);
        ThreadInfo.nRunFlag := 126;
        Config.boIDSocketConnected := False;
      end;
      if s <> INVALID_SOCKET then
      begin
        closesocket(s);
        s := INVALID_SOCKET;
      end;
      if Config.sIDSAddr = '' then Continue;

      s := Socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
      if s = INVALID_SOCKET then Continue;

      ThreadInfo.nRunFlag := 127;

      HostEnt := gethostbyname(PChar(@Config.sIDSAddr[1]));
      if HostEnt = nil then Continue;

      PInteger(@Name.sin_addr.S_addr)^ := PInteger(HostEnt.h_addr^)^;
      Name.sin_family := HostEnt.h_addrtype;
      Name.sin_port := htons(Config.nIDSPort);
      Name.sin_family := PF_INET;

      ThreadInfo.nRunFlag := 128;
      if connect(s, Name, SizeOf(Name)) = SOCKET_ERROR then
      begin
        nRet := WSAGetLastError;

        closesocket(s);
        s := INVALID_SOCKET;
        Continue;
      end;

      argp := 1;
      if ioctlsocket(s, FIONBIO, argp) = SOCKET_ERROR then
      begin
        closesocket(s);
        s := INVALID_SOCKET;
        Continue;
      end;
      ThreadInfo.nRunFlag := 129;
      Config.IDSocket := s;
      Config.boIDSocketConnected := True;
      MainOutMessage(Format(sIDServerConnected, [Config.sIDSAddr, Config.nIDSPort]));
    end;
    readfds.fd_count := 1;
    readfds.fd_array[0] := s;
    timeout.tv_sec := 0;
    timeout.tv_usec := 20;
    ThreadInfo.nRunFlag := 130;
    nRet := select(0, @readfds, nil, nil, @timeout);
    if nRet = SOCKET_ERROR then
    begin
      ThreadInfo.nRunFlag := 131;
      nRet := WSAGetLastError;
      if nRet = WSAEWOULDBLOCK then
      begin
        Sleep(10);
        Continue;
      end;
      ThreadInfo.nRunFlag := 132;
      nRet := WSAGetLastError;
      Config.nIDSocketWSAErrCode := nRet - WSABASEERR;
      Inc(Config.nIDSocketErrorCount);
      Config.DBSocket := INVALID_SOCKET;
      Sleep(100);
      Config.boIDSocketConnected := False;
      closesocket(s);
      s := INVALID_SOCKET;
      Continue;
    end;
    boRecvData := True;
    ThreadInfo.nRunFlag := 133;
    while (nRet > 0) do
    begin
      IDSocketRead(Config);
      Dec(nRet);
    end;
  end;
  if Config.IDSocket <> INVALID_SOCKET then
  begin
    Config.IDSocket := INVALID_SOCKET;
    Config.boIDSocketConnected := False;
  end;
  if s <> INVALID_SOCKET then
  begin
    closesocket(s);
  end;
end;
procedure IDSocketThread(ThreadInfo: pTThreadInfo); stdcall;
var
  nErrorCount: Integer;
resourcestring
  sExceptionMsg = '[Exception] DBSocketThread ErrorCount = %d';
begin
  nErrorCount := 0;
  while True do
  begin
    try
      IDSocketProcess(ThreadInfo.Config, ThreadInfo);
      Break;
    except
      Inc(nErrorCount);
      if nErrorCount > 10 then Break;
      MainOutMessage(Format(sExceptionMsg, [nErrorCount]));
    end;
  end;
  ExitThread(0);
end;


end.
