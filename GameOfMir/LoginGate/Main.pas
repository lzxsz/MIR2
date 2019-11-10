unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Menus, ExtCtrls, ComCtrls, JSocket, WinSock, IniFiles, GateShare;
const
  GATEMAXSESSION      = 10000;
type
  TUserSession = record
    Socket            :TCustomWinSocket;  //0x00
    sRemoteIPaddr     :String;   //0x04
    nSendMsgLen       :Integer;  //0x08
    bo0C              :Boolean;  //0x0C
    dw10Tick          :LongWord; //0x10
    nCheckSendLength  :Integer;  //0x14
    boSendAvailable   :Boolean;  //0x18
    boSendCheck       :Boolean;  //0x19
    dwSendLockTimeOut :LongWord; //0x1C
    n20               :Integer;  //0x20
    dwUserTimeOutTick :LongWord; //0x24
    SocketHandle      :Integer;  //0x28
    sIP               :String;   //0x2C
    MsgList           :TStringList; //0x30
    dwConnctCheckTick :LongWord;  //连接数据传输空闲超时检测
  end;
  pTUserSession = ^TUserSession;
  TSessionArray = array [0..GATEMAXSESSION - 1] of TUserSession;
  TFrmMain=class(TForm)
    MemoLog: TMemo;
    SendTimer: TTimer;
    ClientSocket: TClientSocket;
    Panel: TPanel;
    Timer: TTimer;
    DecodeTimer: TTimer;
    LbHold: TLabel;
    LbLack: TLabel;
    Label2: TLabel;
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    StartTimer: TTimer;
    MENU_CONTROL_START: TMenuItem;
    MENU_CONTROL_STOP: TMenuItem;
    MENU_CONTROL_RECONNECT: TMenuItem;
    MENU_CONTROL_CLEAELOG: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    MENU_VIEW: TMenuItem;
    MENU_VIEW_LOGMSG: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_IPFILTER: TMenuItem;
    ServerSocket: TServerSocket;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    
    procedure MemoLogChange(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure SendTimerTimer(Sender : TObject);
    procedure TimerTimer(Sender : TObject);
    procedure DecodeTimerTimer(Sender : TObject);


    procedure ClientSocketConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StartTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MENU_CONTROL_STARTClick(Sender: TObject);
    procedure MENU_CONTROL_STOPClick(Sender: TObject);
    procedure MENU_CONTROL_RECONNECTClick(Sender: TObject);
    procedure MENU_CONTROL_CLEAELOGClick(Sender: TObject);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure MENU_VIEW_LOGMSGClick(Sender: TObject);
    procedure MENU_OPTION_GENERALClick(Sender: TObject);
    procedure MENU_OPTION_IPFILTERClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    dwShowMainLogTick    :LongWord;
    boShowLocked         :Boolean;
    TempLogList          :TStringList;
    nSessionCount        :Integer;
    StringList30C        :TStringList;
    dwSendKeepAliveTick  :LongWord;
    boServerReady        :Boolean;
    StringList318        :TStringList;

    dwDecodeMsgTime      :LongWord;
    dwReConnectServerTick:LongWord;
    procedure ResUserSessionArray();
    procedure StartService();
    procedure StopService();
    procedure LoadConfig();
    procedure ShowLogMsg(boFlag: Boolean);
    function IsBlockIP(sIPaddr: String): Boolean;
    function IsConnLimited(sIPaddr: String): Boolean;
    procedure CloseSocket(nSocketHandle:Integer);
    function  SendUserMsg(UserSession:pTUserSession;sSendMsg:String):Integer;
    procedure ShowMainLogMsg;
    procedure IniUserSessionArray;
    { Private declarations }
  public
    procedure CloseConnect(sIPaddr: String);
    procedure MyMessage(var MsgData:TWmCopyData);message WM_COPYDATA;
    { Public declarations }
  end ;
  procedure MainOutMessage(sMsg:String;nMsgLevel:Integer);
var
  FrmMain: TFrmMain;
  g_SessionArray        :TSessionArray;
  ClientSockeMsgList     :TStringList;
  sProcMsg               :String;
implementation

uses HUtil32, GeneralConfig, IPaddrFilter, Grobal2;

{$R *.DFM}
procedure MainOutMessage(sMsg:String;nMsgLevel:Integer);
var
 tMsg:String;
begin
  try
    CS_MainLog.Enter;
    if nMsgLevel <= nShowLogLevel then begin
       //tMsg:='[' + TimeToStr(Now) + '] ' + sMsg;
      tMsg:='[' + DateTimeToStr(Now) + '] ' + sMsg; //Mofiy TimeToStr() to DateTimeToStr() by Davy 2019-11-9
      MainLogMsgList.Add(tMsg);
    end;
  finally
    CS_MainLog.Leave;
  end;
end;

procedure TFrmMain.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  UserSession:pTUserSession;
  sRemoteIPaddr,sLocalIPaddr:String;
  nSockIndex:Integer;
  IPaddr  :pTSockaddr;
begin
  Socket.nIndex:=-1;
  sRemoteIPaddr:=Socket.RemoteAddress;

  if g_boDynamicIPDisMode then  begin
    sLocalIPaddr:=ClientSocket.Socket.RemoteAddress;
  end else begin
    sLocalIPaddr:=Socket.LocalAddress;
  end;

  if IsBlockIP(sRemoteIPaddr) then begin
    MainOutMessage('过滤连接: ' + sRemoteIPaddr,1);
    Socket.Close;
    exit;
  end;

  if IsConnLimited(sRemoteIPaddr) then begin
    case BlockMethod of
      mDisconnect: begin
        Socket.Close;
      end;
      mBlock: begin
        New(IPaddr);
        IPaddr.nIPaddr:=inet_addr(PChar(sRemoteIPaddr));
        TempBlockIPList.Add(IPaddr);
        CloseConnect(sRemoteIPaddr);
      end;
      mBlockList: begin
        New(IPaddr);
        IPaddr.nIPaddr:=inet_addr(PChar(sRemoteIPaddr));
        BlockIPList.Add(IPaddr);
        CloseConnect(sRemoteIPaddr);
      end;
    end;
    MainOutMessage('端口攻击: ' + sRemoteIPaddr,1);
    exit;
  end;


  if boGateReady then begin
    for nSockIndex:= 0 to GATEMAXSESSION - 1 do begin
      UserSession:=@g_SessionArray[nSockIndex];
      if UserSession.Socket = nil then begin
        UserSession.Socket:=Socket;
        UserSession.sRemoteIPaddr:=sRemoteIPaddr;
        UserSession.nSendMsgLen:=0;
        UserSession.bo0C:=False;
        UserSession.dw10Tick:=GetTickCount();
        UserSession.dwConnctCheckTick:=GetTickCount();

        UserSession.boSendAvailable:=True;
        UserSession.boSendCheck:=False;
        UserSession.nCheckSendLength:=0;
        UserSession.n20:=0;
        UserSession.dwUserTimeOutTick:=GetTickCount();
        UserSession.SocketHandle:=Socket.SocketHandle;
        UserSession.sIP:=sRemoteIPaddr;
        UserSession.MsgList.Clear;
        Socket.nIndex:=nSockIndex;
        Inc(nSessionCount);
        break;
      end;
    end;
    if Socket.nIndex >= 0 then begin
      ClientSocket.Socket.SendText('%O' +
                                   IntToStr(Socket.SocketHandle) +
                                   '/' +
                                   sRemoteIPaddr +
                                   '/' +
                                   sLocalIPaddr +
                                   '$');
      MainOutMessage('Connect: ' + sRemoteIPaddr,5);
    end else begin
      Socket.Close;
      MainOutMessage('Kick Off: ' + sRemoteIPaddr,1);
    end;
  end else begin //0x004529EF
    Socket.Close;
    MainOutMessage('Kick Off: ' + sRemoteIPaddr,1);
  end;
end;

procedure TFrmMain.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I:Integer;
  UserSession:pTUserSession;
  nSockIndex:Integer;
  sRemoteIPaddr:String;
  IPaddr  :pTSockaddr;
  nIPaddr :Integer;
begin
  sRemoteIPaddr:=Socket.RemoteAddress;
  nIPaddr:=inet_addr(PChar(sRemoteIPaddr));
  nSockIndex:=Socket.nIndex;
  for I := 0 to CurrIPaddrList.Count - 1 do begin
    IPaddr:=CurrIPaddrList.Items[I];
    if IPaddr.nIPaddr = nIPaddr then begin
      Dec(IPaddr.nCount);
      if IPaddr.nCount <= 0 then begin
        Dispose(IPaddr);
        CurrIPaddrList.Delete(I);
      end;
      Break;  
    end;
      
  end;
  if (nSockIndex >= 0) and (nSockIndex < GATEMAXSESSION) then begin
    UserSession:=@g_SessionArray[nSockIndex];
    UserSession.Socket:=nil;
    UserSession.sRemoteIPaddr:='';
    UserSession.SocketHandle:=-1;
    UserSession.MsgList.Clear;
    Dec(nSessionCount);
    if boGateReady then begin
      ClientSocket.Socket.SendText('%X' +
                                   IntToStr(Socket.SocketHandle) +
                                   '$');
      MainOutMessage('DisConnect: ' + sRemoteIPaddr,5);
    end;
  end;
end;

procedure TFrmMain.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  StringList30C.Add('Error ' + IntToStr(ErrorCode) + ': ' + Socket.RemoteAddress);
  Socket.Close;
  ErrorCode:=0;
end;

procedure TFrmMain.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  UserSession:pTUserSession;
  nSockIndex:Integer;
  sReviceMsg,s10,s1C:String;
  nPos:Integer;
  nMsgLen:Integer;
begin
  nSockIndex:=Socket.nIndex;
  if (nSockIndex >= 0) and (nSockIndex < GATEMAXSESSION) then begin
    UserSession:=@g_SessionArray[nSockIndex];
    sReviceMsg:=Socket.ReceiveText;
    if (sReviceMsg <> '') and (boServerReady) then begin
      nPos:=Pos('*',sReviceMsg);
      if nPos > 0 then begin
        UserSession.boSendAvailable:=True;
        UserSession.boSendCheck:=False;
        UserSession.nCheckSendLength:=0;
        s10:=Copy(sReviceMsg,1,nPos -1);
        s1C:=Copy(sReviceMsg,nPos + 1,Length(sReviceMsg) - nPos);
        sReviceMsg:=s10 + s1C;
      end;
      nMsgLen:=length(sReviceMsg);
      if (sReviceMsg <> '') and (boGateReady) and (not boKeepAliveTimcOut)then begin
        UserSession.dwConnctCheckTick:=GetTickCount();
        if (GetTickCount - UserSession.dwUserTimeOutTick) < 1000 then begin
          Inc(UserSession.n20,nMsgLen);
        end else UserSession.n20:= nMsgLen;
        ClientSocket.Socket.SendText('%A' +
                                     IntToStr(Socket.SocketHandle) +
                                     '/' +
                                     sReviceMsg +
                                     '$');
      end;
    end;
  end;
end;

procedure TFrmMain.MemoLogChange(Sender : TObject);
begin
  if MemoLog.Lines.Count > 200 then MemoLog.Clear;    
end;

procedure TFrmMain.FormDestroy(Sender : TObject);
var
  nIndex:Integer;
begin
  StringList30C.Free;
  TempLogList.Free;


  for nIndex:= 0 to GATEMAXSESSION - 1 do begin
    g_SessionArray[nIndex].MsgList.Free;
  end;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if boClose then exit;
  if Application.MessageBox('是否确认退出服务器?',
                            '提示信息',
                            MB_YESNO + MB_ICONQUESTION ) = IDYES then begin
    if boServiceStart then begin
      StartTimer.Enabled:=True;
      CanClose:=False;
    end;
  end else CanClose:=False;
end;

procedure TFrmMain.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  boGateReady     := True;
  nSessionCount   := 0;
  dwKeepAliveTick := GetTickCount();
  ResUserSessionArray();
  boServerReady   := True;
end;

procedure TFrmMain.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  UserSession:pTUserSession;
  nIndex:Integer;
begin
  for nIndex:= 0 to GATEMAXSESSION - 1 do begin
    UserSession:=@g_SessionArray[nIndex];
    if UserSession.Socket <> nil then
      UserSession.Socket.Close;
    UserSession.Socket        := nil;
    UserSession.sRemoteIPaddr := '';
    UserSession.SocketHandle  := -1;
  end;
  ResUserSessionArray();
  ClientSockeMsgList.Clear;
  boGateReady   :=False;
  nSessionCount :=0;
end;

procedure TFrmMain.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode:=0;
  boServerReady:=False;
end;

procedure TFrmMain.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  sRecvMsg:String;
begin
  sRecvMsg:=Socket.ReceiveText;
  ClientSockeMsgList.Add(sRecvMsg);
end;

procedure TFrmMain.SendTimerTimer(Sender : TObject);
var
  nIndex:Integer;
  UserSession:pTUserSession;
begin
  if ServerSocket.Active then begin
    n456A30:=ServerSocket.Socket.ActiveConnections;
  end;
  if boSendHoldTimeOut then begin
    LbHold.Caption:=IntToStr(n456A30) + '#';
    if (GetTickCount - dwSendHoldTick) > 3 * 1000 then boSendHoldTimeOut:=False;
  end else begin
    LbHold.Caption:=IntToStr(n456A30);    
  end;
  if boGateReady and (not boKeepAliveTimcOut)then begin
    for nIndex:= 0 to GATEMAXSESSION - 1 do begin
      UserSession:=@g_SessionArray[nIndex];
      if UserSession.Socket <> nil then begin
        if (GetTickCount - UserSession.dwUserTimeOutTick) > 60 * 60 * 1000 then begin
          UserSession.Socket.Close;
          UserSession.Socket:=nil;
          UserSession.SocketHandle:=-1;
          UserSession.MsgList.Clear;
          UserSession.sRemoteIPaddr:='';
        end;
      end;
    end;
  end;
  if not boGateReady and (boServiceStart)then begin
    if (GetTickCount - dwReConnectServerTick) > 1000{30 * 1000} then begin
      dwReConnectServerTick:=GetTickCount();
      ClientSocket.Active:=False;
      ClientSocket.Port:=ServerPort;
      ClientSocket.Host:=ServerAddr;
      ClientSocket.Active:=True;
    end;
  end;
end;

procedure TFrmMain.TimerTimer(Sender : TObject);
begin
  if ServerSocket.Active then begin
    StatusBar.Panels[0].Text:=IntToStr(ServerSocket.Port);
    if boSendHoldTimeOut then
      StatusBar.Panels[2].Text:=IntToStr(nSessionCount) + '/#' + IntToStr(ServerSocket.Socket.ActiveConnections)
    else
      StatusBar.Panels[2].Text:=IntToStr(nSessionCount) + '/' + IntToStr(ServerSocket.Socket.ActiveConnections);
  end else begin
    StatusBar.Panels[0].Text:='????';
    StatusBar.Panels[2].Text:='????';
  end;
  Label2.Caption:=IntToStr(dwDecodeMsgTime);  
  if not boGateReady then begin
    StatusBar.Panels[1].Text:='未连接';
  end else begin
    if boKeepAliveTimcOut then begin
      StatusBar.Panels[1].Text:='超时';
    end else begin
      StatusBar.Panels[1].Text:='已连接';
      LbLack.Caption:=IntToStr(n456A2C) + '/' + IntToStr(nSendMsgCount);
    end;
  end;
end;

procedure TFrmMain.DecodeTimerTimer(Sender : TObject);
var
  sProcessMsg   :String;
  sSocketMsg    :String;
  sSocketHandle :String;
  nSocketIndex  :Integer;
  nMsgCount     :Integer;
  nSendRetCode  :Integer;
  nSocketHandle :Integer;
  dwDecodeTick  :LongWord;
  dwDecodeTime  :LongWord;
  sRemoteIPaddr :String;
  UserSession   :pTUserSession;
  IPaddr  :pTSockaddr;
begin
  ShowMainLogMsg();
  if boDecodeLock or (not boGateReady)then exit;

  try
    dwDecodeTick:=GetTickCount();
    boDecodeLock:=True;
    sProcessMsg:='';
    while (True) do begin
      if ClientSockeMsgList.Count <= 0 then break;
       sProcessMsg:=sProcMsg + ClientSockeMsgList.Strings[0];
       sProcMsg:='';
       ClientSockeMsgList.Delete(0);
       while (True) do begin
         if TagCount(sProcessMsg,'$') < 1 then break;
         sProcessMsg:=ArrestStringEx(sProcessMsg,'%','$',sSocketMsg);
         if sSocketMsg = ''then break;
         if sSocketMsg[1] = '+' then begin
           if sSocketMsg[2] = '-' then begin
             CloseSocket(Str_ToInt(Copy(sSocketMsg,3,Length(sSocketMsg) - 2),0));
             Continue;
           end else begin //0x004521B7
             dwKeepAliveTick:=GetTickCount();
             boKeepAliveTimcOut:=False;
             Continue;
           end;
         end; //0x004521CD
         sSocketMsg:=GetValidStr3(sSocketMsg,sSocketHandle,['/']);
         nSocketHandle:=Str_ToInt(sSocketHandle,-1);
         if nSocketHandle < 0 then Continue;
         for nSocketIndex:= 0 to GATEMAXSESSION - 1 do begin
           if g_SessionArray[nSocketIndex].SocketHandle = nSocketHandle then begin
             g_SessionArray[nSocketIndex].MsgList.Add(sSocketMsg);
             break;
           end;
         end;
       end; //0x00452246
     end; //0x452252
     //if sProcessMsg <> '' then ClientSockeMsgList.Add(sProcessMsg);
     if sProcessMsg <> '' then sProcMsg:=sProcessMsg;

     nSendMsgCount:=0;
     n456A2C:=0;
     StringList318.Clear;
     for nSocketIndex:= 0 to GATEMAXSESSION - 1 do begin
       if g_SessionArray[nSocketIndex].SocketHandle <= -1 then Continue;

       //踢除超时无数据传输连接
       if (GetTickCount - g_SessionArray[nSocketIndex].dwConnctCheckTick) > dwKeepConnectTimeOut then begin
         sRemoteIPaddr:=g_SessionArray[nSocketIndex].sRemoteIPaddr;
         case BlockMethod of    //
           mDisconnect: begin
             g_SessionArray[nSocketIndex].Socket.Close;
           end;
           mBlock: begin
             New(IPaddr);
             IPaddr.nIPaddr:=inet_addr(PChar(sRemoteIPaddr));
             TempBlockIPList.Add(IPaddr);
             CloseConnect(sRemoteIPaddr);
           end;
           mBlockList: begin
             New(IPaddr);
             IPaddr.nIPaddr:=inet_addr(PChar(sRemoteIPaddr));
             BlockIPList.Add(IPaddr);
             CloseConnect(sRemoteIPaddr);
           end;
         end;
         MainOutMessage('端口空连接攻击: ' + sRemoteIPaddr,1);
         Continue;
       end;
       
       while (True) do begin;
         if g_SessionArray[nSocketIndex].MsgList.Count <= 0 then break;
         UserSession:=@g_SessionArray[nSocketIndex];
         nSendRetCode:=SendUserMsg(UserSession,UserSession.MsgList.Strings[0]);
         if (nSendRetCode >= 0) then begin
           if nSendRetCode = 1 then begin
             UserSession.dwConnctCheckTick:=GetTickCount();
             UserSession.MsgList.Delete(0);
             Continue;
           end;
           if UserSession.MsgList.Count > 100 then begin
             nMsgCount:=0;
             while nMsgCount <> 51 do begin
               UserSession.MsgList.Delete(0);
               Inc(nMsgCount);
             end;
           end;
           Inc(n456A2C,UserSession.MsgList.Count);
           MainOutMessage(UserSession.sIP +
                      ' : ' +
                      IntToStr(UserSession.MsgList.Count),5);
           Inc(nSendMsgCount);
         end else begin //0x004523A4
           UserSession.SocketHandle:= -1;
           UserSession.Socket:= nil;
           UserSession.MsgList.Clear;
         end;
       end;
     end;
     if (GetTickCount - dwSendKeepAliveTick) > 2 * 1000 then begin
       dwSendKeepAliveTick:=GetTickCount();
       if boGateReady then
         ClientSocket.Socket.SendText('%--$');
     end;
     if (GetTickCount - dwKeepAliveTick) > 10 * 1000 then begin
       boKeepAliveTimcOut:=True;
       ClientSocket.Close;
     end;
  finally
    boDecodeLock:=False;
  end;
  dwDecodeTime:=GetTickCount - dwDecodeTick;
  if dwDecodeMsgTime < dwDecodeTime then dwDecodeMsgTime:=dwDecodeTime;
  if dwDecodeMsgTime > 50 then Dec(dwDecodeMsgTime,50);
end;

procedure TFrmMain.CloseSocket(nSocketHandle:Integer);
var
  nIndex:Integer;
  UserSession:pTUserSession;
begin
  for nIndex:= 0 to GATEMAXSESSION - 1 do begin
    UserSession:=@g_SessionArray[nIndex];
    if (UserSession.Socket <> nil) and (UserSession.SocketHandle = nSocketHandle)then begin
      UserSession.Socket.Close;
      break;
    end;
  end;
end;

function TFrmMain.SendUserMsg(UserSession:pTUserSession;sSendMsg:String):Integer;
begin
  Result:= -1;
  if UserSession.Socket <> nil then begin
    if not UserSession.bo0C then begin
      if not UserSession.boSendAvailable and (GetTickCount > UserSession.dwSendLockTimeOut) then begin
          UserSession.boSendAvailable  := True;
          UserSession.nCheckSendLength := 0;
          boSendHoldTimeOut            := True;
          dwSendHoldTick               := GetTickCount();
      end; //004525DD
      if UserSession.boSendAvailable then begin
        if UserSession.nCheckSendLength >= 250 then begin
          if not UserSession.boSendCheck then begin
            UserSession.boSendCheck:=True;
            sSendMsg:='*' + sSendMsg;
          end;
          if UserSession.nCheckSendLength >= 512 then begin
            UserSession.boSendAvailable:=False;
            UserSession.dwSendLockTimeOut:=GetTickCount + 3 * 1000;
          end;
        end; //00452620
        UserSession.Socket.SendText(sSendMsg);
        Inc(UserSession.nSendMsgLen,length(sSendMsg));
        Inc(UserSession.nCheckSendLength,length(sSendMsg));
        Result:= 1;
      end else begin //0x0045264A
        Result:= 0;
      end;
    end else begin //0x00452651
      Result:= 0;
    end;
  end;
end;

procedure TFrmMain.LoadConfig;
var
  Conf:TIniFile;
  sConfigFileName:String;
begin
  sConfigFileName:='.\Config.ini';
  Conf        := TIniFile.Create(sConfigFileName);
  TitleName  := Conf.ReadString(GateClass,'Title',TitleName);
  ServerPort := Conf.ReadInteger(GateClass,'ServerPort',ServerPort);
  ServerAddr := Conf.ReadString(GateClass,'ServerAddr',ServerAddr);
  GatePort   := Conf.ReadInteger(GateClass,'GatePort',GatePort);
  GateAddr      := Conf.ReadString(GateClass,'GateAddr',GateAddr);
  nShowLogLevel := Conf.ReadInteger(GateClass,'ShowLogLevel',nShowLogLevel);

  BlockMethod:=TBlockIPMethod(Conf.ReadInteger(GateClass,'BlockMethod',Integer(BlockMethod)));

  if Conf.ReadInteger(GateClass,'KeepConnectTimeOut',-1) <= 0 then
    Conf.WriteInteger(GateClass,'KeepConnectTimeOut',dwKeepConnectTimeOut);

  nMaxConnOfIPaddr:=Conf.ReadInteger(GateClass,'MaxConnOfIPaddr',nMaxConnOfIPaddr);
  dwKeepConnectTimeOut:= Conf.ReadInteger(GateClass,'KeepConnectTimeOut',dwKeepConnectTimeOut);
  g_boDynamicIPDisMode:= Conf.ReadBool(GateClass,'DynamicIPDisMode',g_boDynamicIPDisMode);
  Conf.Free;
  LoadBlockIPFile();
end;

procedure TFrmMain.StartService;
begin
try
    //MainOutMessage('欢迎使用MIR2系统软件...',0);
    MainOutMessage('正在启动服务...',3);
    SendGameCenterMsg(SG_STARTNOW,g_sNowStartGate);
    boServiceStart:=True;
    boGateReady:=False;
    boServerReady:=False;    
    nSessionCount:=0;
    MENU_CONTROL_START.Enabled:=False;
    MENU_CONTROL_STOP.Enabled:=True;

    //Caption:=GateName + ' - ' + TitleName;         //Midified by Davy 2019-11-9
    dwReConnectServerTick:=GetTickCount - 25 * 1000;
    boKeepAliveTimcOut:=False;
    nSendMsgCount:=0;
    n456A2C:=0;
    dwSendKeepAliveTick:=GetTickCount();
    boSendHoldTimeOut:=False;
    dwSendHoldTick:=GetTickCount();

    CurrIPaddrList     :=TList.Create;
    BlockIPList        :=TList.Create;
    TempBlockIPList    :=TList.Create;
    ClientSockeMsgList :=TStringList.Create;

    ResUserSessionArray();
    LoadConfig();

    //Midified by Davy 2019-11-9 ，  标题赋值要放有LoadConfig()函数后面，因为该函数会修改TitleName的值
    if(TitleName <> '') then
     begin
      Caption:=GateName + ' - ' + TitleName;
      end
    else
    begin
      Caption:=GateName;
    end;

    ClientSocket.Active:=False;
    ClientSocket.Host:=ServerAddr;
    ClientSocket.Port:=ServerPort;
    ClientSocket.Active:=True;


    ServerSocket.Active:=False;
    ServerSocket.Address:=GateAddr;
    ServerSocket.Port:=GatePort;
    ServerSocket.Active:=True;

    SendTimer.Enabled:=True;
    MainOutMessage('启动服务完成...',3);
    SendGameCenterMsg(SG_STARTOK,g_sNowStartOK);
  except
    on E:Exception do begin
      MENU_CONTROL_START.Enabled:=True;
      MENU_CONTROL_STOP.Enabled:=False;
      MainOutMessage(E.Message,0);
    end;
  end;
end;

procedure TFrmMain.StopService;
var
  I        :Integer;
  nSockIdx :Integer;
  IPaddr   :pTSockaddr;
begin
  MainOutMessage('正在停止服务...',3);
  boServiceStart:=False;
  boGateReady:=False;
  MENU_CONTROL_START.Enabled:=True;
  MENU_CONTROL_STOP.Enabled:=False;
  SendTimer.Enabled:=False;
  for nSockIdx:=0 to GATEMAXSESSION - 1 do begin
    if g_SessionArray[nSockIdx].Socket <> nil then
      g_SessionArray[nSockIdx].Socket.Close;
  end;
  SaveBlockIPList();
  ServerSocket.Close;
  ClientSocket.Close;
  ClientSockeMsgList.Free;
  for I := 0 to CurrIPaddrList.Count - 1 do begin
    IPaddr:=CurrIPaddrList.Items[I];
    Dispose(IPaddr);
  end;
  CurrIPaddrList.Free;
  for I := 0 to BlockIPList.Count - 1 do begin
    IPaddr:=BlockIPList.Items[I];
    Dispose(IPaddr);
  end;
  BlockIPList.Free;
  for I := 0 to TempBlockIPList.Count - 1 do begin
    IPaddr:=TempBlockIPList.Items[I];
    Dispose(IPaddr);
  end;
  TempBlockIPList.Free;
  MainOutMessage('停止服务完成...',3);
end;

procedure TFrmMain.ResUserSessionArray;
var
  UserSession:pTUserSession;
  nIndex:Integer;
begin
  for nIndex:= 0 to GATEMAXSESSION - 1 do begin
    UserSession:=@g_SessionArray[nIndex];
    UserSession.Socket    := nil;
    UserSession.sRemoteIPaddr     := '';
    UserSession.SocketHandle       :=-1;
    UserSession.MsgList.Clear;
  end;
end;
procedure TFrmMain.IniUserSessionArray();
var
  UserSession:pTUserSession;
  nIndex:Integer;
begin
  for nIndex:= 0 to GATEMAXSESSION - 1 do begin
    UserSession:=@g_SessionArray[nIndex];
    UserSession.Socket           := nil;
    UserSession.sRemoteIPaddr    := '';
    UserSession.nSendMsgLen      :=0;
    UserSession.bo0C             :=False;
    UserSession.dw10Tick         :=GetTickCount();
    UserSession.boSendAvailable  :=True;
    UserSession.boSendCheck      :=False;
    UserSession.nCheckSendLength :=0;
    UserSession.n20              :=0;
    UserSession.dwUserTimeOutTick:=GetTickCount();
    UserSession.SocketHandle     :=-1;
    UserSession.MsgList          :=TStringList.Create;
  end;
end;
procedure TFrmMain.StartTimerTimer(Sender: TObject);
begin
  if boStarted then begin
    StartTimer.Enabled:=False;
    StopService();
    boClose:=True;
    Close;
  end else begin
    MENU_VIEW_LOGMSGClick(Sender);
    boStarted:=True;
    StartTimer.Enabled:=False;
    StartService();
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  nX,nY:Integer;
begin
  g_dwGameCenterHandle:=Str_ToInt(ParamStr(1),0);
  nX:=Str_ToInt(ParamStr(2),-1);
  nY:=Str_ToInt(ParamStr(3),-1);
  if (nX >= 0) or (nY >= 0) then begin
    Left:=nX;
    Top:=nY;
  end;
    
  
  TempLogList:=TStringList.Create;
  StringList30C:=TStringList.Create;
  StringList318:=TStringList.Create;
  dwDecodeMsgTime:=0;
  SendGameCenterMsg(SG_FORMHANDLE,IntToStr(Self.Handle));
  IniUserSessionArray();
end;

procedure TFrmMain.MENU_CONTROL_STARTClick(Sender: TObject);
begin
  StartService();
end;

procedure TFrmMain.MENU_CONTROL_STOPClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认停止服务?',
                            '确认信息',
                            MB_YESNO + MB_ICONQUESTION ) = IDYES then
    StopService();
end;

procedure TFrmMain.MENU_CONTROL_RECONNECTClick(Sender: TObject);
begin
  dwReConnectServerTick:=0;
end;

procedure TFrmMain.MENU_CONTROL_CLEAELOGClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认清除显示的日志信息?',
                            '确认信息',
                            MB_OKCANCEL + MB_ICONQUESTION
                            ) <> IDOK then exit;
  MemoLog.Clear;
end;

procedure TFrmMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.MENU_VIEW_LOGMSGClick(Sender: TObject);
begin
  MENU_VIEW_LOGMSG.Checked:=not MENU_VIEW_LOGMSG.Checked;
  ShowLogMsg(MENU_VIEW_LOGMSG.Checked);
end;

procedure TFrmMain.ShowLogMsg(boFlag: Boolean);
var
  nHeight:Integer;
begin
  case boFlag of
    True: begin
      nHeight:=Panel.Height;
      Panel.Height:=0;
      MemoLog.Height:=nHeight;
      MemoLog.Top:=Panel.Top;
    end;
    False: begin
      nHeight:=MemoLog.Height;
      MemoLog.Height:=0;
      Panel.Height:=nHeight;
    end;
  end;
end;

procedure TFrmMain.MENU_OPTION_GENERALClick(Sender: TObject);
begin
  CenterDialog(Handle, frmGeneralConfig.Handle);
  with frmGeneralConfig do begin
    EditGateIPaddr.Text:=GateAddr;
    EditGatePort.Text:=IntToStr(GatePort);
    EditServerIPaddr.Text:=ServerAddr;
    EditServerPort.Text:=IntToStr(ServerPort);
    EditTitle.Text:=TitleName;
    TrackBarLogLevel.Position:=nShowLogLevel;
  end;
  frmGeneralConfig.ShowModal;
end;
procedure TFrmMain.CloseConnect(sIPaddr: String);
var
  i:Integer;
  boCheck:Boolean;
begin
  if ServerSocket.Active then
    while (True) do begin
      boCheck:=False;
      for i:= 0 to ServerSocket.Socket.ActiveConnections - 1 do begin
        if sIPaddr=ServerSocket.Socket.Connections[i].RemoteAddress then begin
          ServerSocket.Socket.Connections[i].Close;
          boCheck:=True;
          break;
        end;
      end;
      if not boCheck then break;        
    end;
end;
procedure TFrmMain.MENU_OPTION_IPFILTERClick(Sender: TObject);
var
  i:Integer;
  sIPaddr:String;
begin
  CenterDialog(Handle, frmIPaddrFilter.Handle);
  frmIPaddrFilter.ListBoxActiveList.Clear;
  frmIPaddrFilter.ListBoxTempList.Clear;
  frmIPaddrFilter.ListBoxBlockList.Clear;
  if ServerSocket.Active then
    for i:= 0 to ServerSocket.Socket.ActiveConnections - 1 do begin
      sIPaddr:=ServerSocket.Socket.Connections[i].RemoteAddress;
      if sIPaddr <> '' then
        frmIPaddrFilter.ListBoxActiveList.Items.AddObject(sIPaddr,Tobject(ServerSocket.Socket.Connections[i]));
    end;

  for i:= 0 to TempBlockIPList.Count - 1 do begin
    frmIPaddrFilter.ListBoxTempList.Items.Add(StrPas(inet_ntoa(TInAddr(pTSockaddr(TempBlockIPList.Items[I]).nIPaddr))));
  end;
  for i:= 0 to BlockIPList.Count - 1 do begin
    frmIPaddrFilter.ListBoxBlockList.Items.Add(StrPas(inet_ntoa(TInAddr(pTSockaddr(BlockIPList.Items[I]).nIPaddr))));
  end;
  frmIPaddrFilter.EditMaxConnect.Value:=nMaxConnOfIPaddr;
  case BlockMethod of
    mDisconnect: frmIPaddrFilter.RadioDisConnect.Checked:=True;
    mBlock: frmIPaddrFilter.RadioAddTempList.Checked:=True;
    mBlockList: frmIPaddrFilter.RadioAddBlockList.Checked:=True;
  end;

  frmIPaddrFilter.ShowModal;

end;
function TFrmMain.IsBlockIP(sIPaddr: String): Boolean;
var
  i:Integer;
  IPaddr  :pTSockaddr;
  nIPaddr :Integer;
begin
  Result:=False;
  nIPaddr:=inet_addr(PChar(sIPaddr));
  for I := 0 to TempBlockIPList.Count - 1 do begin
    IPaddr:=TempBlockIPList.Items[I];
    if IPaddr.nIPaddr = nIPaddr then begin
      Result:=True;
      exit;
    end;
  end;
  for I := 0 to BlockIPList.Count - 1 do begin
    IPaddr:=BlockIPList.Items[I];
    if IPaddr.nIPaddr = nIPaddr then begin
      Result:=True;
      exit;
    end;
  end;
end;
{function TFrmMain.IsConnLimited(sIPaddr: String): Boolean;
var
  i,nCount:Integer;
begin
  nCount:=0;
  Result:=False;
  for I := 0 to ServerSocket.Socket.ActiveConnections - 1 do begin
    if CompareText(sIPaddr,ServerSocket.Socket.Connections[i].RemoteAddress) = 0 then Inc(nCount);
  end;
  if nCount > nMaxConnOfIPaddr then begin
    Result:=True;
  end;
end;}
function TFrmMain.IsConnLimited(sIPaddr: String): Boolean;
var
  I       :Integer;
  IPaddr  :pTSockaddr;
  nIPaddr :Integer;
  boDenyConnect:Boolean;
begin
  Result:=False;
  boDenyConnect:=False;
  nIPaddr:=inet_addr(PChar(sIPaddr));
  for I := 0 to CurrIPaddrList.Count - 1 do begin
    IPaddr:=CurrIPaddrList.Items[I];
    if IPaddr.nIPaddr = nIPaddr then begin
      Inc(IPaddr.nCount);
      if GetTickCount - IPaddr.dwIPCountTick1 < 1000 then begin
        Inc(IPaddr.nIPCount1);
        if IPaddr.nIPCount1 >= nIPCountLimit1 then boDenyConnect:=True;
      end else begin
        IPaddr.dwIPCountTick1:=GetTickCount();
        IPaddr.nIPCount1:=0;
      end;
      if GetTickCount - IPaddr.dwIPCountTick2 < 3000 then begin
        Inc(IPaddr.nIPCount2);
        if IPaddr.nIPCount2 >= nIPCountLimit2 then boDenyConnect:=True;
      end else begin
        IPaddr.dwIPCountTick2:=GetTickCount();
        IPaddr.nIPCount2:=0;
      end;
      if IPaddr.nCount > nMaxConnOfIPaddr then boDenyConnect:=True;
        
      Result:=boDenyConnect;
      exit;
    end;
  end;
  New(IPaddr);
  FillChar(IPaddr^,SizeOf(TSockaddr),0);
  IPaddr.nIPaddr:=nIPaddr;
  IPaddr.nCount:=1;
  CurrIPaddrList.Add(IPaddr);
end;
procedure TFrmMain.ShowMainLogMsg;
var
  i:Integer;
begin
  if (GetTickCount - dwShowMainLogTick) < 200 then exit;
  dwShowMainLogTick:=GetTickCount();
  try
    boShowLocked:=True;
    try
      CS_MainLog.Enter;
      for i:= 0 to MainLogMsgList.Count - 1 do begin
        TempLogList.Add(MainLogMsgList.Strings[i]);
      end;
      MainLogMsgList.Clear;
    finally
      CS_MainLog.Leave;
    end;
    for i:= 0 to TempLogList.Count - 1 do begin
      MemoLog.Lines.Add(TempLogList.Strings[i]);
    end;
    TempLogList.Clear;
  finally
    boShowLocked:=False;
  end;
end;
procedure TFrmMain.MyMessage(var MsgData: TWmCopyData);
var
  sData:String;
  wIdent:Word;
begin
  wIdent:=HiWord(MsgData.From);
  sData:=StrPas(MsgData.CopyDataStruct^.lpData);
  case wIdent of  
    GS_QUIT: begin
    showmessage('退出');
      if boServiceStart then begin
        StartTimer.Enabled:=True;
      end else begin
        boClose:=True;
        Close();
      end;
    end;
    1: ;
    2: ;
    3: ;
  end;
end;

//Out message. Add modified by Davy 2019-11-9
procedure MainLogOutMessage(sMsg: String);
begin
  MainLogMsgList.Add(sMsg)
end;

procedure TFrmMain.N4Click(Sender: TObject);
begin
  MainLogOutMessage('欢迎使用MIR2系统软件...');
  MainLogOutMessage('引擎版本: 1.5.0 (20020522)');
  MainLogOutMessage('更新日期: 2019/09/09');
  MainLogOutMessage('程序制作: Cola PI');
end;

end.

