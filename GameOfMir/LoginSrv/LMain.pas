unit LMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, JSocket, SyncObjs, Grids, Buttons,IniFiles,MudUtil,Parse,
  Menus,Grobal2,LSShare, SDK, ScktComp;
type
  TConnInfo = record //Size 0x20 Address: 0x00468601
    sAccount      :String;  //0x00
    sIPaddr       :String;  //0x04
    sServerName   :String;  //0x08
    nSessionID    :Integer; //0x0C
    boPayCost     :Boolean; //0x10
    bo11          :Boolean; //0x11
    dwKickTick    :LongWord;//0x14
    dwStartTick   :LongWord;//0x18
    boKicked      :Boolean; //0x1C
    nLockCount    :Integer;
  end;
  pTConnInfo = ^TConnInfo;
  TGateInfo = record //Size 0x14 Address: 0x004686A0
    Socket          :TCustomWinSocket; //0x00
    sIPaddr         :String;           //0x04
    sReceiveMsg     :String;           //0x08
    UserList        :TList;            //0x0C
    dwKeepAliveTick :LongWord;         //0x10
  end;

  pTGateInfo =^TGateInfo;
  TUserInfo = record //Size 0x68 Address: 0x004686C8
    sAccount          :String;            //0x00
    sUserIPaddr       :String;            //0x0B
    sGateIPaddr       :String;            //用户连接到网关，网关的连接IP
    sSockIndex        :String;            //0x20
    nVersionDate      :Integer;           //0x24
    boCertificationOK :Boolean;           //0x28
    bo29           :Boolean;           //0x29
    bo2A           :Boolean;           //0x2A
    bo2B           :Boolean;           //0x2B
    nSessionID     :Integer;           //0x2C
    boPayCost      :Boolean;           //0x30
    nIDDay         :Integer;           //0x34
    nIDHour        :Integer;           //0x38
    nIPDay         :Integer;           //0x3C
    nIPHour        :Integer;           //0x40
    dtDateTime     :TDateTime;         //0x48
    boSelServer    :Boolean;           //0x50
    bo51           :Boolean;           //0x51
    Socket         :TCustomWinSocket;  //0x54
    sReceiveMsg    :String;            //0x58
    dwTime5C       :LongWord;          //0x5C
    bo60           :Boolean;           //0x60
    bo61           :Boolean;           //0x61
    bo62           :Boolean;           //0x62
    bo63           :Boolean;           //0x63
    dwClientTick   :LongWord;          //0x64
    Gate           :pTGateInfo
  end;
  pTUserInfo = ^TUserInfo;
  TFrmMain=class(TForm)
    GSocket: TServerSocket;
    ExecTimer: TTimer;
    Panel1: TPanel;
    Memo1: TMemo;
    Timer1: TTimer;
    StartTimer: TTimer;
    WebLogTimer: TTimer;
    BtnDump: TSpeedButton;
    LogTimer: TTimer;
    MonitorGrid: TStringGrid;
    Panel2: TPanel;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    LbMasCount: TLabel;
    CkLogin: TCheckBox;
    CbViewLog: TCheckBox;
    BtnView: TSpeedButton;
    CountLogTimer: TTimer;
    BtnShowServerUsers: TSpeedButton;
    MonitorTimer: TTimer;
    SpeedButton2: TSpeedButton;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    MENU_VIEW: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_HELP: TMenuItem;
    MENU_HELP_ABOUT: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_ROUTE: TMenuItem;
    MENU_VIEW_SESSION: TMenuItem;

    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure ExecTimerTimer(Sender : TObject);
    procedure Memo1DblClick(Sender : TObject);
    procedure Timer1Timer(Sender : TObject);
    procedure StartTimerTimer(Sender : TObject);
    procedure SpeedButton1Click(Sender : TObject);
    procedure BtnViewClick(Sender : TObject);
    procedure CountLogTimerTimer(Sender : TObject);
    procedure BtnShowServerUsersClick(Sender : TObject);
    procedure MonitorTimerTimer(Sender : TObject);
    procedure SpeedButton2Click(Sender : TObject);

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure GSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure GSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure GSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure GSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Panel2DblClick(Sender: TObject);
    procedure CbViewLogClick(Sender: TObject);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure MENU_OPTION_ROUTEClick(Sender: TObject);
    procedure MENU_VIEW_SESSIONClick(Sender: TObject);
    procedure MENU_HELP_ABOUTClick(Sender: TObject);

    //Add by davy 2019-11-9
    procedure MainOutMessage(sMsg: string);     //Out Message with datetime
    procedure MainLogOutMessage(sMsg: String);  //Out Message without datetime
  private
    //sGateIPaddr     :String;      //0x334
    //GateList        :TList;  //0x338
    //SessionList     :TList; //0x33C
    //ServerNameList  :TStringList;   //0x340
    SList_0344      :TStringList;   //0x344
    //AccountCostList :TQuickList;   //0x348
    //IPaddrCostList  :TQuickList;   //0x34C
    ParseList       :TThreadParseList;   //0x350
    //m_boRemoteClose :Boolean;

    procedure GameCenterGetUserAccount(sData:String);
    procedure GameCenterChangeAccountInfo(sData:String);
    procedure OpenRouteConfig();
    { Private declarations }
  public



    procedure MyMessage(var MsgData:TWmCopyData);message WM_COPYDATA;

    { Public declarations }
  end;
  procedure StartService(Config:pTConfig);
  procedure StopService(Config:pTConfig);
  procedure InitializeConfig(Config:pTConfig);
  procedure UnInitializeConfig(Config:pTConfig);
  procedure LoadConfig(Config:pTConfig);
  procedure LoadAddrTable(Config:pTConfig);
  procedure GenServerNameList(Config:pTConfig);

  procedure WriteLogMsg(Config:pTConfig;sType:String;var UserEntry:TUserEntry;var UserAddEntry:TUserEntryAdd);
  procedure SaveContLogMsg(Config:pTConfig;sLogMsg:String);
  
  procedure SendGateMsg(Socket: TCustomWinSocket; sSockIndex,sMsg: String);
  procedure SendGateKickMsg(Socket: TCustomWinSocket;sSockIndex: String);
  procedure SendKeepAlivePacket(Socket:TCustomWinSocket);
  
  procedure SessionAdd(Config:pTConfig;sAccount,sIPaddr:String;nSessionID:Integer;boPayCost,bo11:Boolean);
  procedure SessionDel(Config:pTConfig;nSessionID:Integer);
  procedure SessionKick(Config:pTConfig;sLoginID:String);
  procedure SessionUpdate(Config:pTConfig;nSessionID: Integer; sServerName: String;boPayCost: Boolean);
  procedure SessionClearKick(Config:pTConfig);
  function  IsPayMent(Config:pTConfig;sIPaddr,sAccount:String):Boolean;
  procedure SessionClearNoPayMent(Config:pTConfig);
  function  IsLogin(Config:pTConfig;sLoginID:String):Boolean;overload;
  function  IsLogin(Config:pTConfig;nSessionID:Integer):Boolean;overload;

  function  GetServerListInfo():String;
  procedure GetSelGateInfo(Config:pTConfig;sServerName, sIPaddr: String;var sSelGateIP: String; var nSelGatePort: Integer);
  
  function  KickUser(Config:pTConfig;UserInfo:pTUserInfo):Boolean;
  procedure CloseUser(Config:pTConfig;sAccount: String; nSessionID: Integer);
  
  procedure AccountCreate(Config:pTConfig;UserInfo:pTUserInfo;sData:String);
  procedure AccountChangePassword(Config:pTConfig;UserInfo:pTUserInfo;sData:String);
  procedure AccountCheckProtocol(UserInfo:pTUserInfo;nDate:Integer);
  procedure AccountLogin(Config:pTConfig;UserInfo:pTUserInfo;sData:String);
  procedure AccountSelectServer(Config:pTConfig;UserInfo:pTUserInfo;sData:String);
  procedure AccountUpdateUserInfo(Config:pTConfig;UserInfo:pTUserInfo;sData:String);
  procedure AccountGetBackPassword(UserInfo:pTUserInfo;sData:String);
  
  procedure ReceiveSendUser(Config:pTConfig;sSockIndex:String;GateInfo:pTGateInfo;sData:String);
  procedure ReceiveOpenUser(Config:pTConfig;sSockIndex:String;sIPaddr:String;GateInfo:pTGateInfo);
  procedure ReceiveCloseUser(Config:pTConfig;sSockIndex:String;GateInfo:pTGateInfo);

  procedure ProcessUserMsg(Config:pTConfig;UserInfo:pTUserInfo;sMsg:String);

  procedure DecodeGateData(Config:pTConfig;GateInfo:pTGateInfo);
  procedure DecodeUserData(Config:pTConfig;UserInfo:pTUserInfo);
  procedure ProcessGate(Config:pTConfig);
  
  procedure LoadAccountCostList(Config:pTConfig;QuickList: TQuickList);
  procedure LoadIPaddrCostList(Config:pTConfig;QuickList: TQuickList);
var
  FrmMain: TFrmMain;

implementation

uses IDDB, MasSock, FrmFindId, HUtil32, EDcode, GateSet,
  FAccountView, GrobalSession;

{$R *.DFM}
procedure TFrmMain.OpenRouteConfig;
begin
  FrmGateSetting:=TFrmGateSetting.Create(nil);
  FrmGateSetting.Open;
  FrmGateSetting.Free;
end;
{
procedure TFrmMain.OpenRouteConfig;
var
  Config  :pTConfig;
begin
  Config:=@g_Config;
  if FrmGateSetting.Open then begin
    LoadAddrTable(Config);
  end;
end;
}
procedure TFrmMain.MENU_OPTION_ROUTEClick(Sender: TObject);
begin
  OpenRouteConfig();
end;

procedure TFrmMain.MENU_VIEW_SESSIONClick(Sender: TObject);
begin
  frmGrobalSession:=TfrmGrobalSession.Create(nil);
  frmGrobalSession.Open;
  frmGrobalSession.Free;
end;

procedure TFrmMain.CbViewLogClick(Sender: TObject);
var
  Config  :pTConfig;
begin
  Config:=@g_Config;
  Config.boShowDetailMsg:=CbViewLog.Checked;
end;

//00469778
procedure TFrmMain.GSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  GateInfo:pTGateInfo;
  Config  :pTConfig;
begin
  Config:=@g_Config;
  if not ExecTimer.Enabled then begin
    Socket.Close;
    exit;
  end;
  New(GateInfo);
  GateInfo.Socket          := Socket;
  GateInfo.sIPaddr         := GetGatePublicAddr(Config,Socket.RemoteAddress);
  GateInfo.sReceiveMsg     := '';
  GateInfo.UserList        := TList.Create;
  GateInfo.dwKeepAliveTick := GetTickCount();
  EnterCriticalSection(Config.GateCriticalSection);
  try
    Config.GateList.Add(GateInfo);
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;
//0x00469898
procedure TFrmMain.GSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I        :Integer;
  II       :Integer;
  GateInfo :pTGateInfo;
  UserInfo :pTUserInfo;
  Config   :pTConfig;
begin
  Config:=@g_Config;
  EnterCriticalSection(Config.GateCriticalSection);
  try
    for I:= 0 to Config.GateList.Count - 1 do begin
      GateInfo:=Config.GateList.Items[I];
      if GateInfo.Socket = Socket then begin
        for II:=0 to GateInfo.UserList.Count -1 do begin
          UserInfo:=GateInfo.UserList.Items[II];
          if Config.boShowDetailMsg then
            MainOutMessage('Close: ' + UserInfo.sUserIPaddr);
          Dispose(UserInfo);
        end;
        GateInfo.UserList.Free;
        Dispose(GateInfo);
        Config.GateList.Delete(i);
        break;
      end;
    end;
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;

procedure TFrmMain.GSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode:=0;
  Socket.Close;
end;
//00469A60
procedure TFrmMain.GSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I        :Integer;
  GateInfo :pTGateInfo;
  Config   :pTConfig;
begin
  Config:=@g_Config;
  EnterCriticalSection(Config.GateCriticalSection);
  try
    for I:=0 to Config.GateList.Count -1 do begin
      GateInfo:=Config.GateList.Items[I];
      if GateInfo.Socket = Socket then begin
        GateInfo.sReceiveMsg:=GateInfo.sReceiveMsg + Socket.ReceiveText;
        break;
      end;
    end;
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;

//0046D19C
procedure LoadAddrTable(Config:pTConfig);
var
  LoadList    :TStringList;
  sFileName   :String;
  i           :Integer;
  nRouteIdx   :Integer;
  nSelGateIdx :Integer;
  sLineText,sTitle,sServerName,sGate,sRemote,sPublic,sGatePort:String;
begin
  sFileName:='.\!addrtable.txt';
  LoadList:=TStringList.Create;
  if FileExists(sFileName) then begin
    LoadList.LoadFromFile(sFileName);
    nRouteIdx:=0;
    for i:= 0 to LoadList.Count - 1 do begin
      sLineText:=LoadList.Strings[i];
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sLineText:=GetValidStr3(sLineText,sServerName,[' ']);
        sLineText:=GetValidStr3(sLineText,sTitle,[' ']);
        sLineText:=GetValidStr3(sLineText,sRemote,[' ']);
        sLineText:=GetValidStr3(sLineText,sPublic,[' ']);
        sLineText:=Trim(sLineText);
        if (sTitle <> '') and (sRemote <> '') and (sPublic <> '') and (nRouteIdx < 60)then begin
          Config.GateRoute[nRouteIdx].sServerName := sServerName;
          Config.GateRoute[nRouteIdx].sTitle      := sTitle;
          Config.GateRoute[nRouteIdx].sRemoteAddr := sRemote;
          Config.GateRoute[nRouteIdx].sPublicAddr := sPublic;
          nSelGateIdx:=0;
          while (sLineText <> '') do begin
            if nSelGateIdx > 9 then break;
            sLineText:=GetValidStr3(sLineText,sGate,[' ']);
            if sGate <> '' then begin
              if sGate[1] = '*' then begin
                sGate:=Copy(sGate,2,length(sGate) - 1);
                Config.GateRoute[nRouteIdx].Gate[nSelGateIdx].boEnable:=False;
              end else begin
                Config.GateRoute[nRouteIdx].Gate[nSelGateIdx].boEnable:=True;
              end;
              sGatePort:=GetValidStr3(sGate,sGate,[':']);
              Config.GateRoute[nRouteIdx].Gate[nSelGateIdx].sIPaddr := sGate;
              Config.GateRoute[nRouteIdx].Gate[nSelGateIdx].nPort   := Str_ToInt(sGatePort,0);
              Config.GateRoute[nRouteIdx].nSelIdx                   := 0;
              Inc(nSelGateIdx);
            end;//0046D44B
            sLineText:=Trim(sLineText);
          end;
          Inc(nRouteIdx);
        end;
      end;
    end;
    Config.nRouteCount:=nRouteIdx;
  end;//0046D482
  LoadList.Free;
  GenServerNameList(Config);
end;
//00468F84
procedure TFrmMain.FormCreate(Sender : TObject);
var
  nX,nY:Integer;
  Config  :pTConfig;
begin
  Config:=@g_Config;
  g_dwGameCenterHandle:=Str_ToInt(ParamStr(1),0);
  nX:=Str_ToInt(ParamStr(2),-1);
  nY:=Str_ToInt(ParamStr(3),-1);
  if (nX >= 0) or (nY >= 0) then begin
    Left:=nX;
    Top:=nY;
  end;
  Config.boRemoteClose:=False;

  SendGameCenterMsg(SG_FORMHANDLE,IntToStr(Self.Handle));
  AccountDB:=nil;
//  g_MainMsgList:=TStringList.Create;
  CS_DB:=TCriticalSection.Create;

  StringList_0    := TStringList.Create;

  nSessionIdx     := 1;
  n47328C         := 1;
  nMemoHeigh      := Memo1.Height;
  Config.GateList        := TList.Create;
  Config.SessionList     := TGList.Create;
  Config.ServerNameList  := TStringList.Create;
  SList_0344      := TStringList.Create;
  Config.AccountCostList := TQuickList.Create;
  Config.IPaddrCostList  := TQuickList.Create;
  ParseList       := TThreadParseList.Create(True);
  LoadAddrTable(Config);
  MonitorGrid.Cells[0,0]:='服务器名';
  MonitorGrid.Cells[1,0]:='用户数';
  MonitorGrid.Cells[2,0]:='状态';
  MonitorGrid.Cells[3,0]:='服务器名';
  MonitorGrid.Cells[4,0]:='用户数';
  MonitorGrid.Cells[5,0]:='状态';
end;

//00469598
procedure TFrmMain.FormDestroy(Sender : TObject);
var
  i,ii:integer;
  GateInfo:pTGateInfo;
  UserInfo:pTUserInfo;
  Config  :pTConfig;
begin
  Config:=@g_Config;
  StopService(Config);
  if AccountDB <> nil then AccountDB.Free;
  for i:= 0 to Config.GateList.Count - 1 do begin
    GateInfo:=Config.GateList.Items[i];
    for ii:= 0 to GateInfo.UserList.Count - 1 do begin
      UserInfo:=GateInfo.UserList.Items[i];
      Dispose(UserInfo);
    end;
    GateInfo.UserList.Free;
    Dispose(GateInfo);
  end;
  Config.GateList.Free;
  Config.SessionList.Free;
  Config.ServerNameList.Free;
  SList_0344.Free;
  StringList_0.Free;
  CS_DB.Free;
end;
//0046A7F4
procedure TFrmMain.ExecTimerTimer(Sender : TObject);
var
  Config  :pTConfig;
begin
  Config:=@g_Config;
  if bo470D20 and not g_boDataDBReady then exit;
  bo470D20:=True;
  try
    ProcessGate(Config);
  finally
    bo470D20:=False;
  end;
end;
//0046D178
procedure TFrmMain.Memo1DblClick(Sender : TObject);
begin
  OpenRouteConfig();

end;

//0046A9BC
procedure TFrmMain.Timer1Timer(Sender : TObject);
var
  I: Integer;
var
  Config  :pTConfig;
begin
  Config:=@g_Config;
  Label1.Caption:=IntToStr(Config.dwProcessGateTime);
  CkLogin.Checked:=GSocket.Socket.Connected;
  CkLogin.Caption:='连接 (' + IntToStr(GSocket.Socket.ActiveConnections) + ')';
  LbMasCount.Caption:=IntToStr(nOnlineCountMin) + '/' + IntToStr(nOnlineCountMax);
  if Memo1.Lines.Count > 2000 then Memo1.Clear;
  EnterCriticalSection(g_OutMessageCS);
  try
    for I := 0 to g_MainMsgList.Count - 1 do begin
      Memo1.Lines.Add(g_MainMsgList.Strings[i]);
    end;
    g_MainMsgList.Clear;
  finally
    LeaveCriticalSection(g_OutMessageCS);
  end;
  I:=0;
  while (true) do begin
    if StringList_0.Count <= i then break;
    if GetTickCount - LongWord(StringList_0.Objects[i]) > 60000 then begin
      StringList_0.Delete(i);
      Continue;
    end;
    Inc(i);
  end;
  SessionClearKick(Config);
  SessionClearNoPayMent(Config);
end;

//Add by Davy 2019-11-9
procedure TFrmMain.MainOutMessage(sMsg: string);
begin
  sMsg:='[' + DateTimeToStr(Now) + '] ' + sMsg;
  Memo1.Lines.Add(sMsg);
end;

//0046A674
procedure TFrmMain.StartTimerTimer(Sender : TObject);
var
  Config  :pTConfig;
begin
  Config:=@g_Config;
  StartService(Config);
  SendGameCenterMsg(SG_STARTNOW,'正在启动登录服务器...');
  StartTimer.Enabled:=False;
  //Memo1.Lines.Add('欢迎使用MIR系统软件…');
  //Memo1.Lines.Add('1) 正在启动服务器...');

  MainOutMessage('正在启动服务器...');
  Application.ProcessMessages;
  AccountDB:=TFileIDDB.Create(Config.sIdDir + 'Id.DB');
  ParseList.Resume;
  //Memo1.Lines.Add('2) 正在等待服务器连接...');
  
  MainOutMessage('正在等待服务器连接...');
  while (True) do begin
    Application.ProcessMessages;
    if Application.Terminated then exit;
    if FrmMasSoc.CheckReadyServers then break;
    Sleep(1);
  end;
  GSocket.Active  := False;
  //GSocket.Address := Config.sGateAddr;    //TServerSocket is not Address. modify by Davy 2019-11-5 
  GSocket.Port    := Config.nGatePort;
  GSocket.Active  := True;
  //Memo1.Lines.Add('3) 服务器启动完成...');
  
  MainOutMessage('服务器启动完成...');
  ExecTimer.Enabled:=True;
  SendGameCenterMsg(SG_STARTOK,'登录服务器启动完成...');
end;

procedure TFrmMain.SpeedButton1Click(Sender : TObject);
begin
  FrmFindUserId.Show;
end;


procedure TFrmMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;
procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
//0x0046DDB0
var
  Config  :pTConfig;
ResourceString
  sExitMsg   = '是否确认停止登录服务器?';
  sExitTitle = '确认信息';
begin
  Config:=@g_Config;
  if Config.boRemoteClose then exit;
  if MessageBox(Handle,PChar(sExitMsg),PChar(sExitTitle),MB_YESNO + MB_ICONQUESTION) = mrYes then
    CanClose:=True
  else CanClose:=False;
end;


//0046DB40
procedure TFrmMain.BtnViewClick(Sender : TObject);
var
  Config  :pTConfig;
begin
  Config:=@g_Config;
  try
    CS_DB.Enter;
    FrmAccountView.ListBox1.Items:=Config.AccountCostList;
    FrmAccountView.ListBox2.Items:=Config.IPaddrCostList;
  finally
    CS_DB.Leave;
  end;
  FrmAccountView.ShowModal;
end;

procedure TFrmMain.CountLogTimerTimer(Sender : TObject);
var
  sLogMsg:String;
  Config:pTConfig;
ResourceString
  sFormatMsg = '%d/%d';
begin
  Config:=@g_Config;
  sLogMsg:=format(sFormatMsg,[nOnlineCountMin,nOnlineCountMax]);
  SaveContLogMsg(Config,sLogMsg);
  nOnlineCountMax:=0;
end;

procedure TFrmMain.BtnShowServerUsersClick(Sender : TObject);
var
  I: Integer;
begin
  for I := 0 to nUserLimit - 1 do begin
    MainOutMessage(UserLimit[I].sServerName + ' ' + IntToStr(UserLimit[i].nLimitCountMin) + '/' + IntToStr(UserLimit[i].nLimitCountMax));
  end;
end;
//0046ECB4
procedure TFrmMain.MonitorTimerTimer(Sender : TObject);
var
  I           :Integer;
  nCol        :Integer;
  sServerName :String;
  ServerList  :TList;
  MsgServer   :pTMsgServerInfo;
begin
try
  ServerList:=FrmMasSoc.m_ServerList;
  if (ServerList.Count div 2) < 2 then begin
    MonitorGrid.RowCount:=2;
    MonitorGrid.Cells[0,1]:='';
    MonitorGrid.Cells[1,1]:='';
    MonitorGrid.Cells[2,1]:='';
    MonitorGrid.Cells[3,1]:='';
    MonitorGrid.Cells[4,1]:='';
    MonitorGrid.Cells[5,1]:='';
  end else begin
   MonitorGrid.RowCount:=((ServerList.Count div 2) + 1) + (ServerList.Count mod 2);
  end; //0046ED54
  for I := 0 to ServerList.Count - 1 do begin
    nCol:=(I mod 2) * 3;
    MsgServer:=ServerList.Items[I];
    sServerName:=MsgServer.sServerName;
    if sServerName <> '' then begin
      if MsgServer.nServerIndex = 99 then
        MonitorGrid.Cells[nCol,(I div 2 + 1)]:=sServerName + ' [DB]'
      else MonitorGrid.Cells[nCol,(I div 2 + 1)]:=sServerName + ' ' + IntToStr(MsgServer.nServerIndex);
      MonitorGrid.Cells[nCol + 1,(I div 2 + 1)]:=IntToStr(MsgServer.nOnlineCount);
      if (GetTickCount - MsgServer.dwKeepAliveTick) < 30000  then
        MonitorGrid.Cells[nCol + 2,(I div 2 + 1)]:='正常'
      else MonitorGrid.Cells[nCol + 2,(I div 2 + 1)]:='超时';
    end else begin //0046EEF2
      MonitorGrid.Cells[nCol,(I div 2 + 1)]:='-';
      MonitorGrid.Cells[nCol + 1,(I div 2 + 1)]:='-';
      MonitorGrid.Cells[nCol + 2,(I div 2 + 1)]:='-';
    end;
  end;
except
  MainOutMessage('TFrmMain.MonitorTimerTimer');
end;
end;
//0046F060
procedure TFrmMain.SpeedButton2Click(Sender : TObject);
begin
  if Memo1.Height = nMemoHeigh then Memo1.Height:= nMemoHeigh * 2
  else Memo1.Height:=nMemoHeigh;
end;

//0046A178
function IsPayMent(Config:pTConfig;sIPaddr,sAccount:String):Boolean;
begin
  Result:=False;
  try
    CS_DB.Enter;
    if (Config.AccountCostList.GetIndex(sAccount) >= 0) or (Config.IPaddrCostList.GetIndex(sIPaddr) >= 0) then
      Result:=True;
  finally
    CS_DB.Leave;
  end;
end;
//0046A23C
procedure CloseUser(Config:pTConfig;sAccount: String; nSessionID: Integer);
var
  ConnInfo :pTConnInfo;
  I        :Integer;
begin
  Config.SessionList.Lock;
  try
    for I := Config.SessionList.Count -1 downto 0 do begin
      ConnInfo:=Config.SessionList.Items[I];
      if (ConnInfo.sAccount = sAccount) or (ConnInfo.nSessionID = nSessionID ) then begin
        FrmMasSoc.SendServerMsg(SS_CLOSESESSION,ConnInfo.sServerName,ConnInfo.sAccount + '/' + IntToStr(ConnInfo.nSessionID));
        Dispose(ConnInfo);
        Config.SessionList.Delete(I);
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

procedure ProcessGate(Config:pTConfig);
var
  I        :Integer;
  II       :Integer;
  GateInfo :pTGateInfo;
  UserInfo :pTUserInfo;
begin
    EnterCriticalSection(Config.GateCriticalSection);
    try
      Config.dwProcessGateTick:=GetTickCount();
      I:=0;
      while (True) do begin
        if Config.GateList.Count <= I then break;
        GateInfo:=Config.GateList.Items[I];
        if GateInfo.sReceiveMsg <> '' then begin
          DecodeGateData(Config,GateInfo);
          Config.sGateIPaddr:=GateInfo.sIPaddr;
          II:=0;
          while (True) do begin
            if GateInfo.UserList.Count <= II then break;
            UserInfo:=GateInfo.UserList.Items[II];
            if UserInfo.sReceiveMsg <> '' then DecodeUserData(Config,UserInfo);
            Inc(II);
          end;
        end;
        Inc(I);
      end;
      if Config.dwProcessGateTime < Config.dwProcessGateTick then
        Config.dwProcessGateTime:=GetTickCount - Config.dwProcessGateTick;
      if Config.dwProcessGateTime > 100 then Dec(Config.dwProcessGateTime,100);
    finally
      LeaveCriticalSection(Config.GateCriticalSection);
    end;
end;

//0046AC08
procedure DecodeGateData(Config:pTConfig;GateInfo:pTGateInfo);
var
  nCount     :Integer;
  sMsg       :String;
  sSockIndex :String;
  sData      :String;
  Code       :Char;
begin
  try
    nCount:=0;
    while (True) do begin
      if TagCount(GateInfo.sReceiveMsg,'$') <= 0 then break;
      GateInfo.sReceiveMsg:=ArrestStringEx(GateInfo.sReceiveMsg,'%','$',sMsg);
      if sMsg <> '' then begin;
        Code:=sMsg[1];
        sMsg:=Copy(sMsg,2,Length(sMsg)-1);
        case Code of
          '-': begin
            SendKeepAlivePacket(GateInfo.Socket);
            GateInfo.dwKeepAliveTick:=GetTickCount();
          end;
          'A': begin
            sData:=GetValidStr3(sMsg,sSockIndex,['/']);
            ReceiveSendUser(Config,sSockIndex,GateInfo,sData);
          end;
          'O': begin
            sData:=GetValidStr3(sMsg,sSockIndex,['/']);
            ReceiveOpenUser(Config,sSockIndex,sData,GateInfo);
          end;
          'X': begin
            sSockIndex:=sMsg;
            ReceiveCloseUser(Config,sSockIndex,GateInfo);
          end;
        end;
      end else begin //0046AD85
        if nCount >= 1 then GateInfo.sReceiveMsg:='';
        Inc(nCount);
      end;
    end;
  except
    MainOutMessage('[Exception] TFrmMain.DecodeGateData');
  end;
end;
//0046A63C
procedure SendKeepAlivePacket(Socket: TCustomWinSocket);
begin
  if Socket.Connected then Socket.SendText('%++$');
end;
//0046B058
procedure ReceiveCloseUser(Config:pTConfig;sSockIndex: String;
  GateInfo: pTGateInfo);
var
  UserInfo :pTUserInfo;
  I        :Integer;
ResourceString
  sCloseMsg = 'Close: %s';
begin
  for I:=0 to GateInfo.UserList.Count -1 do begin
    UserInfo:=GateInfo.UserList.Items[I];
    if UserInfo.sSockIndex = sSockIndex then begin
      if Config.boShowDetailMsg then
        MainOutMessage(format(sCloseMsg,[UserInfo.sUserIPaddr]));
      if not UserInfo.boSelServer then SessionDel(Config,UserInfo.nSessionID);
      Dispose(UserInfo);
      GateInfo.UserList.Delete(I);
      break;
    end;
  end;
end;
//0046AE3C
procedure ReceiveOpenUser(Config:pTConfig;sSockIndex, sIPaddr: String;
  GateInfo: pTGateInfo);
var
  UserInfo    :pTUserInfo;
  I           :Integer;
  sGateIPaddr :String;
  sUserIPaddr :String;
ResourceString
  sOpenMsg = 'Open: %s/%s';
begin
  sGateIPaddr:=GetValidStr3(sIPaddr,sUserIPaddr,['/']);
try
  for I:=0 to GateInfo.UserList.Count -1 do begin
    UserInfo:=GateInfo.UserList.Items[I];
    if UserInfo.sSockIndex = sSockIndex then begin
      UserInfo.sUserIPaddr  := sUserIPaddr;
      UserInfo.sGateIPaddr  := sGateIPaddr;
      UserInfo.sAccount     := '';
      UserInfo.nSessionID   := 0;
      UserInfo.sReceiveMsg  := '';
      UserInfo.dwTime5C     := GetTickCount();
      UserInfo.dwClientTick :=GetTickCount();
      exit;
    end;
  end;
  New(UserInfo);
  UserInfo.sAccount          := '';
  UserInfo.sUserIPaddr       := sUserIPaddr;
  UserInfo.sGateIPaddr       := sGateIPaddr;
  UserInfo.sSockIndex        := sSockIndex;
  UserInfo.nVersionDate      := 0;
  UserInfo.boCertificationOK := False;
  UserInfo.nSessionID        := 0;
  UserInfo.bo51              := False;
  UserInfo.Socket            := GateInfo.Socket;
  UserInfo.sReceiveMsg       := '';
  UserInfo.dwTime5C          := GetTickCount();
  UserInfo.dwClientTick      := GetTickCount();
  UserInfo.bo60              := False;
  UserInfo.Gate              := GateInfo;
  GateInfo.UserList.Add(UserInfo);
  if Config.boShowDetailMsg then
    MainOutMessage(format(sOpenMsg,[sUserIPaddr,sGateIPaddr]));
except
  MainOutMessage('TFrmMain.ReceiveOpenUser');
end;
end;
//0046B1A8
procedure ReceiveSendUser(Config:pTConfig;sSockIndex: String;
  GateInfo: pTGateInfo; sData: String);
var
  UserInfo :pTUserInfo;
  I        :integer;
begin
try
  for I:=0 to GateInfo.UserList.Count -1 do begin
    UserInfo:=GateInfo.UserList.Items[I];
    if UserInfo.sSockIndex = sSockIndex then begin
      if Length(UserInfo.sReceiveMsg) < 4069 then begin
        UserInfo.sReceiveMsg:=UserInfo.sReceiveMsg + sData;
      end;
      Break;
    end;
  end;
except
  MainOutMessage('TFrmMain.ReceiveSendUser');
end;
end;


//00469D38
procedure SessionClearKick(Config:pTConfig);
var
  I        :Integer;
  ConnInfo :pTConnInfo;
begin
  Config.SessionList.Lock;
  try
    for I := Config.SessionList.Count - 1 downto 0 do begin
      ConnInfo:=Config.SessionList.Items[I];
      if ConnInfo.boKicked and ((GetTickCount - ConnInfo.dwKickTick) > 5 * 1000) then begin
        Dispose(ConnInfo);
        Config.SessionList.Delete(I);
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

//0046B284
procedure DecodeUserData(Config:pTConfig;UserInfo: pTUserInfo);
var
  sMsg   :String;
  nCount :Integer;
begin
  nCount:=0;
  try
    //if UserInfo = nil then nErrCode:=1;
    while (True) do begin
      if TagCount(UserInfo.sReceiveMsg,'!') <= 0 then break;
      UserInfo.sReceiveMsg:=ArrestStringEx(UserInfo.sReceiveMsg,'#','!',sMsg);
      if sMsg <> '' then begin;
        if Length(sMsg) >= DEFBLOCKSIZE + 1 then begin
          sMsg:=Copy(sMsg,2,Length(sMsg)-1);
          ProcessUserMsg(Config,UserInfo,sMsg);
        end;
      end else begin
        if nCount >= 1 then UserInfo.sReceiveMsg:='';
        Inc(nCount);
      end;
      if UserInfo.sReceiveMsg = '' then break;
    end;
  except
    MainOutMessage('[Exception] TFrmMain.DecodeUserData ');
  end;

end;
//0046A088
procedure SessionDel(Config:pTConfig;nSessionID: Integer);
var
  ConnInfo:pTConnInfo;
  i:Integer;
begin
  Config.SessionList.Lock;
  try
    for i:= 0 to Config.SessionList.Count -1 do begin
      ConnInfo:=Config.SessionList.Items[i];
      if ConnInfo.nSessionID=nSessionID then begin
        Dispose(ConnInfo);
        Config.SessionList.Delete(i);
        break;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;
//0046CC3C
procedure ProcessUserMsg(Config:pTConfig;UserInfo: pTUserInfo; sMsg: String);
var
  sDefMsg :String;
  sData   :String;
  DefMsg  :TDefaultMessage;
begin
  try
    sDefMsg := Copy(sMsg,1,DEFBLOCKSIZE);
    sData   := Copy(sMsg,DEFBLOCKSIZE+1,Length(sMsg)-DEFBLOCKSIZE);
    DefMsg  := DecodeMessage(sDefMsg);

    case DefMsg.Ident of
      CM_SELECTSERVER: begin
        if not UserInfo.boSelServer then begin
          AccountSelectServer(Config,UserInfo,sData);
        end;
      end;
      CM_PROTOCOL: begin
        AccountCheckProtocol(UserInfo,DefMsg.Recog);
      end;
      CM_IDPASSWORD: begin
        if UserInfo.sAccount = '' then begin
          AccountLogin(Config,UserInfo,sData);
        end else begin
          KickUser(Config,UserInfo);
        end;
      end;
      CM_ADDNEWUSER: begin
        if Config.boEnableMakingID then begin
          if (GetTickCount - UserInfo.dwClientTick) > 5000 then begin
            UserInfo.dwClientTick:=GetTickCount();
            AccountCreate(Config,UserInfo,sData);
          end else begin
            MainOutMessage('[超速操作] 创建帐号 ' + '/' + UserInfo.sUserIPaddr);
          end;
        end;
      end;
      CM_CHANGEPASSWORD: begin
        if UserInfo.sAccount = '' then begin
          if (GetTickCount - UserInfo.dwClientTick) > 5000 then begin
            UserInfo.dwClientTick:=GetTickCount();
            AccountChangePassword(Config,UserInfo,sData);
          end else begin
            MainOutMessage('[超速操作] 修改密码 ' + '/' + UserInfo.sUserIPaddr);
          end;
        end else UserInfo.sAccount:='';
      end;
      CM_UPDATEUSER: begin
        if (GetTickCount - UserInfo.dwClientTick) > 5000 then begin
          UserInfo.dwClientTick:=GetTickCount();
          AccountUpdateUserInfo(Config,UserInfo,sData);
        end else begin
          MainOutMessage('[超速操作] 更新帐号 ' + '/' + UserInfo.sUserIPaddr);
        end;
      end;
      CM_GETBACKPASSWORD: begin
        if (GetTickCount - UserInfo.dwClientTick) > 5000 then begin
          UserInfo.dwClientTick:=GetTickCount();
          AccountGetBackPassword(UserInfo,sData);
        end else begin
          MainOutMessage('[超速操作] 找回密码 ' + '/' + UserInfo.sUserIPaddr);
        end;
      end;
    end;
  except
    MainOutMessage('[Exception] TFrmMain.ProcessUserMsg ' + 'wIdent: ' + IntToStr(DefMsg.Ident) + ' sData: ' + sData);
  end;
end;

procedure AccountCreate(Config:pTConfig;UserInfo: pTUserInfo; sData: String);//0046C244
var
  UserEntry        :TUserEntry;
  UserAddEntry     :TUserEntryAdd;
  DBRecord         :TAccountDBRecord;
  nLen             :Integer;
  sUserEntryMsg    :String;
  sUserAddEntryMsg :String;
  nErrCode         :Integer;
  DefMsg           :TDefaultMessage;
  bo21             :Boolean;
  n10              :Integer;

ResourceString
  sAddNewuserFail = '[新建帐号失败] %s/%s';
  sLogFlag        = 'new';

begin
try
  nErrCode:= -1;
  FillChar(UserEntry, SizeOf(TUserEntry), #0);
  FillChar(UserAddEntry, SizeOf(TUserEntryAdd), #0);
  nLen:=GetCodeMsgSize(SizeOf(TUserEntry)* 4/3);
  bo21:=False;
  sUserEntryMsg:=Copy(sData,1,nLen);
  sUserAddEntryMsg:=Copy(sData,nLen+1,Length(sData)-nLen);
  if (sUserEntryMsg <> '') and (sUserAddEntryMsg <> '') then begin
    DecodeBuffer(sUserEntryMsg,@UserEntry,SizeOf(TUserEntry));
    DecodeBuffer(sUserAddEntryMsg,@UserAddEntry,SizeOf(TUserEntryAdd));
    if CheckAccountName(UserEntry.sAccount) then bo21:=True;
    if bo21 then begin
      try
        if AccountDB.Open then begin
          MainOutMessage('test...');
          n10:=AccountDB.Index(UserEntry.sAccount);
          if n10 < 0 then begin
            FillChar(DBRecord, SizeOf(TAccountDBRecord), #0);
            DBRecord.UserEntry:=UserEntry;
            DBRecord.UserEntryAdd:=UserAddEntry;
            if UserEntry.sAccount <> '' then
              if AccountDB.Add(DBRecord) then nErrCode:=1;
          end else nErrCode:=0;
        end;
      finally
        AccountDB.Close;
      end;
    end else begin
      MainOutMessage(format(sAddNewuserFail,[UserEntry.sAccount,UserAddEntry.sQuiz2]));
    end; //0046C480
  end;
  if nErrCode = 1 then begin
    WriteLogMsg(Config,sLogFlag,UserEntry,UserAddEntry);
    DefMsg:=MakeDefaultMsg(SM_NEWID_SUCCESS,0,0,0,0);
  end else begin
    DefMsg:=MakeDefaultMsg(SM_NEWID_FAIL,nErrCode,0,0,0);
  end;
  SendGateMsg(UserInfo.Socket,UserInfo.sSockIndex,EncodeMessage(DefMsg));
except
  MainOutMessage('TFrmMain.AddNewUser');
end;
end;
//0046C814
procedure AccountChangePassword(Config:pTConfig;UserInfo: pTUserInfo; sData: String);
var
  sMsg         :String;
  sLoginID     :String;
  sOldPassword :String;
  sNewPassword :String;
  DefMsg       :TDefaultMessage;
  nCode        :Integer;
  n10          :Integer;
  DBRecord     :TAccountDBRecord;
ResourceString
  sChgMsg = 'chg';
begin
try
  sMsg:=DecodeString(sData);
  sMsg:=GetValidStr3(sMsg,sLoginID,[#9]);
  sNewPassword:=GetValidStr3(sMsg,sOldPassword,[#9]);
  nCode:=0;
  try
    if AccountDB.Open and (Length(sNewPassword) >= 3) then begin
      n10:=AccountDB.Index(sLoginID);
      if (n10 >= 0) and (AccountDB.Get(n10,DBRecord) >= 0) then begin
        //if (DBRecord.nErrorCount >= 5) or ((GetTickCount - DBRecord.dwActionTick) > 180000) then begin
        if (DBRecord.nErrorCount < 5) or ((GetTickCount - DBRecord.dwActionTick) > 180000) then begin
          if DBRecord.UserEntry.sPassword = sOldPassword then begin
            DBRecord.nErrorCount:=0;
            DBRecord.UserEntry.sPassword:=sNewPassword;
            nCode:=1;
          end else begin
            Inc(DBRecord.nErrorCount);
            DBRecord.dwActionTick:=GetTickCount();
            nCode:=-1;
          end;
          AccountDB.Update(n10,DBRecord);
        end else begin
          nCode:=-2;
          if GetTickCount < DBRecord.dwActionTick then begin
            DBRecord.dwActionTick:=GetTickCount();
            AccountDB.Update(n10,DBRecord);
          end;
        end;
      end;
    end;
  finally
    AccountDB.Close;
  end;
  if nCode = 1 then begin
    DefMsg:=MakeDefaultMsg(SM_CHGPASSWD_SUCCESS,0,0,0,0);
    WriteLogMsg(Config,sChgMsg,DBRecord.UserEntry,DBRecord.UserEntryAdd);
  end else begin
    DefMsg:=MakeDefaultMsg(SM_CHGPASSWD_FAIL,nCode,0,0,0);
  end;
  SendGateMsg(UserInfo.Socket,UserInfo.sSockIndex,EncodeMessage(DefMsg));
except
  MainOutMessage('TFrmMain.ChangePassword');
end;
end;

procedure AccountCheckProtocol(UserInfo: pTUserInfo; nDate: Integer);
var
  DefMsg:TDefaultMessage;
begin
  if nDate < nVersionDate then begin
    DefMsg:=MakeDefaultMsg(SM_CERTIFICATION_FAIL,0,0,0,0);
  end else begin
    DefMsg:=MakeDefaultMsg(SM_CERTIFICATION_SUCCESS,0,0,0,0);
    UserInfo.nVersionDate      := nDate;
    UserInfo.boCertificationOK := True;
  end;
  SendGateMsg(UserInfo.Socket,UserInfo.sSockIndex,EncodeMessage(DefMsg));
end;
//0046A368
function KickUser(Config:pTConfig;UserInfo: pTUserInfo):Boolean;
var
  I        :Integer;
  II       :Integer;
  GateInfo :pTGateInfo;
  User     :pTUserInfo;
ResourceString
  sKickMsg = 'Kick: %s';
begin
  Result:=False;
  EnterCriticalSection(Config.GateCriticalSection);
  try
    for I:= 0 to Config.GateList.Count -1 do begin
      GateInfo:=Config.GateList.Items[I];
      for II:= 0 to GateInfo.UserList.Count -1 do begin
        User:=GateInfo.UserList.Items[II];
        if User = UserInfo then begin
          if Config.boShowDetailMsg then
            MainOutMessage(format(sKickMsg,[UserInfo.sUserIPaddr]));
          SendGateKickMsg(GateInfo.Socket,UserInfo.sSockIndex);
          Dispose(UserInfo);
          GateInfo.UserList.Delete(II);
          Result:=True;
          exit;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;
//0046B400
procedure AccountLogin(Config:pTConfig;UserInfo: pTUserInfo; sData: String);
var
  sLoginID     :String;
  sPassword    :String;
  nCode        :Integer;
  boNeedUpdate :Boolean;
  DefMsg       :TDefaultMessage;
  UserEntry    :TUserEntry;
  nIDCost      :Integer;
  nIPCost      :Integer;
  nIDCostIndex :Integer;
  nIPCostIndex :Integer;
  DBRecord     :TAccountDBRecord;
  n10          :Integer;
  boPayCost    :Boolean;
  sServerName  :String;
begin
try
  sPassword:=GetValidStr3(DecodeString(sData),sLoginID,['/']);
  nCode:=0;
  boNeedUpdate:=False;
  try
    if AccountDB.Open then begin
      n10:=AccountDB.Index(sLoginID);
      if (n10 >= 0) and (AccountDB.Get(n10,DBRecord) >= 0) then begin
        if (DBRecord.nErrorCount < 5) or ((GetTickCount - DBRecord.dwActionTick) > 60000) then begin
          if DBRecord.UserEntry.sPassword = sPassword then begin
            DBRecord.nErrorCount:=0;
            if (DBRecord.UserEntry.sUserName = '') or (DBRecord.UserEntryAdd.sQuiz2 = '')then begin
              UserEntry:=DBRecord.UserEntry;
              boNeedUpdate:=True;
            end;
            DBRecord.Header.CreateDate:=UserInfo.dtDateTime;
            nCode:=1;
          end else begin
            Inc(DBRecord.nErrorCount);
            DBRecord.dwActionTick:=GetTickCount();
            nCode:= -1;
          end;
          AccountDB.Update(n10,DBRecord);
        end else begin
          nCode:= -2;
          DBRecord.dwActionTick:=GetTickCount();
          AccountDB.Update(n10,DBRecord);
        end;
      end;
    end;
  finally
    AccountDB.Close;
  end;
  if (nCode = 1) and IsLogin(Config,sLoginID) then begin
    SessionKick(Config,sLoginID);
    nCode:= -3;
  end;
  if boNeedUpdate then begin
    DefMsg:=MakeDefaultMsg(SM_NEEDUPDATE_ACCOUNT,0,0,0,0);
    SendGateMsg(UserInfo.Socket,
                UserInfo.sSockIndex,
                EncodeMessage(DefMsg) + EncodeBuffer(@UserEntry,SizeOf(TUserEntry)));
  end;
  if nCode = 1 then begin
    UserInfo.sAccount:=sLoginID;
    UserInfo.nSessionID:=GetSessionID();
    UserInfo.boSelServer:=False;
    try
      CS_DB.Enter;
      nIDCostIndex:=Config.AccountCostList.GetIndex(UserInfo.sAccount);
      nIPCostIndex:=Config.IPaddrCostList.GetIndex(UserInfo.sUserIPaddr);
      nIDCost:=0;
      nIPCost:=0;
      boPayCost:=False;
      if nIDCostIndex >=0 then nIDCost:=Integer(Config.AccountCostList.Objects[nIDCostIndex]);
      if nIPCostIndex >=0 then begin
        nIPCost:=Integer(Config.IPaddrCostList.Objects[nIPCostIndex]);
        boPayCost:=True;
      end;
    finally
      CS_DB.Leave;
    end;
    if (nIDCost >= 0) or (nIPCost >= 0) then UserInfo.boPayCost:=True
    else UserInfo.boPayCost:=False;
    UserInfo.nIDDay  :=LoWord(nIDCost);
    UserInfo.nIDHour :=HiWord(nIDCost);
    UserInfo.nIPDay  :=LoWord(nIPCost);
    UserInfo.nIPHour :=HiWord(nIPCost);
    if not UserInfo.boPayCost then begin
      DefMsg:=MakeDefaultMsg(SM_PASSOK_SELECTSERVER,0,0,0,Config.ServerNameList.Count);
    end else begin
      DefMsg:=MakeDefaultMsg(SM_PASSOK_SELECTSERVER,
                             nIDCost,
                             Loword(nIPCost),
                             HiWord(nIPCost),
                             Config.ServerNameList.Count);
    end;
    sServerName:=GetServerListInfo;
    SendGateMsg(UserInfo.Socket,
                UserInfo.sSockIndex,
                EncodeMessage(DefMsg) + EncodeString(sServerName));
    SessionAdd(Config,
               UserInfo.sAccount,
               UserInfo.sUserIPaddr,
               UserInfo.nSessionID,
               UserInfo.boPayCost,
               False);
//CODE:0046B857                 call    sub_46C150
  end else begin
    DefMsg:=MakeDefaultMsg(SM_PASSWD_FAIL,nCode,0,0,0);
    SendGateMsg(UserInfo.Socket,UserInfo.sSockIndex,EncodeMessage(DefMsg));
  end;
except
  MainOutMessage('TFrmMain.LoginUser');
end;
end;
//0046D890
procedure GetSelGateInfo(Config:pTConfig;sServerName,sIPaddr:String;var sSelGateIP:String; var nSelGatePort:Integer);
var
  I          :Integer;
  nGateIdx   :Integer;
  nGateCount :Integer;
  nSelIdx    :Integer;
  boSelected :Boolean;
begin
try
  sSelGateIP   :='';
  nSelGatePort :=0;
  for I := 0 to Config.nRouteCount - 1 do begin
    if Config.boDynamicIPMode or ((Config.GateRoute[I].sServerName = sServerName) and (Config.GateRoute[I].sPublicAddr = sIPaddr)) then begin
      nGateCount:=0;
      nGateIdx  :=0;
      while (True) do begin
        if (Config.GateRoute[I].Gate[nGateIdx].sIPaddr <> '') and (Config.GateRoute[I].Gate[nGateIdx].boEnable) then
          Inc(nGateCount);
        Inc(nGateIdx);
        if nGateIdx >= 10 then break;
      end;//0046D956
      if nGateCount <= 0 then break;//如果没有相关网关IP设置，则跳出
        
      nSelIdx:=Config.GateRoute[I].nSelIdx;
      boSelected:=False;
      for nGateIdx:= nSelIdx + 1 to 9 do begin
        if (Config.GateRoute[I].Gate[nGateIdx].sIPaddr <> '') and (Config.GateRoute[I].Gate[nGateIdx].boEnable) then begin
          Config.GateRoute[I].nSelIdx:=nGateIdx;
          boSelected:=True;
          break;
        end;
      end;
      if not boSelected then begin
        for nGateIdx:= 0 to nSelIdx - 1 do begin
          if (Config.GateRoute[I].Gate[nGateIdx].sIPaddr <> '') and (Config.GateRoute[I].Gate[nGateIdx].boEnable) then begin
            Config.GateRoute[I].nSelIdx:=nGateIdx;
            break;
          end;
        end;
      end;//0046DA2B
      nSelIdx      :=Config.GateRoute[I].nSelIdx;
      sSelGateIP   :=Config.GateRoute[I].Gate[nSelIdx].sIPaddr;
      nSelGatePort :=Config.GateRoute[I].Gate[nSelIdx].nPort;
      break;
    end;//0046DA72
  end;//0046DA7E
except
  MainOutMessage('TFrmMain.GetSelGateInfo');
end;  
end;

function GetServerListInfo: String;
var
  sServerInfo :String;
  I           :Integer;
  sServerName :String;
  Config      :pTConfig;
begin
  Config:=@g_Config;
try
  for I := 0 to Config.ServerNameList.Count - 1 do begin
    sServerName:=Config.ServerNameList.Strings[I];
    if sServerName <> ''  then
      sServerInfo:=sServerInfo + sServerName + '/' + IntToStr(FrmMasSoc.ServerStatus(sServerName)) + '/';
  end;
  {
  for I := 0 to n473290 - 1 do begin
    if (GateRoute[i].sServerName <> '') then begin
      sServerInfo:=sServerInfo + GateRoute[i].sServerName + '/' + IntToStr(FrmMasSoc.ServerStatus(GateRoute[i].sServerName)) + '/';
    end;
  end;
  }
  Result:=sServerInfo;
except
  MainOutMessage('TFrmMain.GetServerListInfo');
end;
end;

procedure AccountSelectServer(Config:pTConfig;UserInfo: pTUserInfo; sData: String);//0046B908
var
  sServerName  :String;
  DefMsg       :TDefaultMessage;
  boPayCost    :Boolean;
  nPayMode     :Integer;
  sSelGateIP   :String;
  nSelGatePort :Integer;
ResourceString
  sSelServerMsg = 'Server: %s/%s-%s:%d';
begin
  sServerName:=DecodeString(sData);
  if (UserInfo.sAccount <> '') and (sServerName <> '') and IsLogin(Config,UserInfo.nSessionID) then begin
    GetSelGateInfo(Config,sServerName,Config.sGateIPaddr,sSelGateIP,nSelGatePort);

    if (sSelGateIP <> '') and (nSelGatePort > 0) then begin
      if Config.boDynamicIPMode then sSelGateIP:=UserInfo.sGateIPaddr;//增加支动态IP

    if Config.boShowDetailMsg then
      MainOutMessage(format(sSelServerMsg,[sServerName,Config.sGateIPaddr,sSelGateIP,nSelGatePort]));

      UserInfo.boSelServer:=True;
      boPayCost:=False;
      nPayMode:= 5;
      if UserInfo.nIDHour > 0 then nPayMode:= 2;
      if UserInfo.nIPHour > 0 then nPayMode:= 4;
      if UserInfo.nIPDay  > 0 then nPayMode:= 3;
      if UserInfo.nIDDay  > 0 then nPayMode:= 1;
      if FrmMasSoc.IsNotUserFull(sServerName) then begin
        SessionUpdate(Config,UserInfo.nSessionID,sServerName,boPayCost);
        FrmMasSoc.SendServerMsg(SS_OPENSESSION,sServerName,
                                UserInfo.sAccount + '/' + IntToStr(UserInfo.nSessionID) + '/' + IntToStr(Integer(UserInfo.boPayCost)) + '/' + IntToStr(nPayMode) + '/' + UserInfo.sUserIPaddr);
        DefMsg:=MakeDefaultMsg(SM_SELECTSERVER_OK,UserInfo.nSessionID,0,0,0);

        SendGateMsg(UserInfo.Socket,UserInfo.sSockIndex,EncodeMessage(DefMsg) + EncodeString(sSelGateIP + '/' + IntToStr(nSelGatePort) + '/' + IntToStr(UserInfo.nSessionID)));
      end else begin
        UserInfo.boSelServer:=False;
        SessionDel(Config,UserInfo.nSessionID);
        DefMsg:=MakeDefaultMsg(SM_STARTFAIL,0,0,0,0);
        SendGateMsg(UserInfo.Socket,UserInfo.sSockIndex,EncodeMessage(DefMsg));
      end;
    end;
  end;
end;
//0046C570
procedure AccountUpdateUserInfo(Config:pTConfig;UserInfo: pTUserInfo; sData: String);
var
  UserEntry        :TUserEntry;
  UserAddEntry     :TUserEntryAdd;
  DBRecord         :TAccountDBRecord;
  nLen             :Integer;
  sUserEntryMsg    :String;
  sUserAddEntryMsg :String;
  nCode            :Integer;
  DefMsg           :TDefaultMessage;
  n10              :Integer;
begin
try
  FillChar(UserEntry, SizeOf(TUserEntry), #0);
  FillChar(UserAddEntry, SizeOf(TUserEntryAdd), #0);
  nLen:=GetCodeMsgSize(SizeOf(TUserEntry)* 4/3);
  sUserEntryMsg:=Copy(sData,1,nLen);
  sUserAddEntryMsg:=Copy(sData,nLen+1,Length(sData)-nLen);
  DecodeBuffer(sUserEntryMsg,@UserEntry,SizeOf(TUserEntry));
  DecodeBuffer(sUserAddEntryMsg,@UserAddEntry,SizeOf(TUserEntryAdd));
  nCode:= -1;
  if (UserInfo.sAccount = UserEntry.sAccount) and CheckAccountName(UserEntry.sAccount) then begin
    try
      if AccountDB.Open then begin
        n10:=AccountDB.Index(UserEntry.sAccount);
        if (n10 >= 0) then begin
          if (AccountDB.Get(n10,DBRecord) >= 0) then begin
            DBRecord.UserEntry:=UserEntry;
            DBRecord.UserEntryAdd:=UserAddEntry;
            AccountDB.Update(n10,DBRecord);
            nCode:=1;
          end;
        end else nCode:=0;
      end;
    finally
      AccountDB.Close;
    end;
  end; //0046C74B
  if nCode = 1 then begin
    WriteLogMsg(Config,'upg',UserEntry,UserAddEntry);
    DefMsg:=MakeDefaultMsg(SM_UPDATEID_SUCCESS,0,0,0,0);
  end else begin
    DefMsg:=MakeDefaultMsg(SM_UPDATEID_FAIL,nCode,0,0,0);
  end;
  SendGateMsg(UserInfo.Socket,UserInfo.sSockIndex,EncodeMessage(DefMsg));
except
  MainOutMessage('TFrmMain.UpdateUserInfo');
end;
end;

procedure AccountGetBackPassword(UserInfo: pTUserInfo;
  sData: String);
var
  sMsg      :String;
  sAccount  :String;
  sQuest1   :String;
  sAnswer1  :String;
  sQuest2   :String;
  sAnswer2  :String;
  sPassword :String;
  sBirthDay :String;
  nCode     :Integer;
  nIndex    :Integer;
  DefMsg    :TDefaultMessage;
  DBRecord  :TAccountDBRecord;
begin
  sMsg:=DecodeString(sData);
  sMsg:=GetValidStr3(sMsg,sAccount,[#9]);
  sMsg:=GetValidStr3(sMsg,sQuest1,[#9]);
  sMsg:=GetValidStr3(sMsg,sAnswer1,[#9]);
  sMsg:=GetValidStr3(sMsg,sQuest2,[#9]);
  sMsg:=GetValidStr3(sMsg,sAnswer2,[#9]);
  sMsg:=GetValidStr3(sMsg,sBirthDay,[#9]);

  nCode:=0;
  try
    if (sAccount <> '') and AccountDB.Open then begin
      nIndex:=AccountDB.Index(sAccount);
      if (nIndex >= 0) and (AccountDB.Get(nIndex,DBRecord) >= 0) then begin
        if (DBRecord.nErrorCount < 5) or ((GetTickCount - DBRecord.dwActionTick) > 180000) then begin
          nCode:= -1;
          if (DBRecord.UserEntry.sQuiz = sQuest1) then begin
            nCode:= -3;
            if DBRecord.UserEntry.sAnswer = sAnswer1 then begin
              if DBRecord.UserEntryAdd.sBirthDay = sBirthDay then begin
                nCode:=1;
              end;
            end;
          end;
          if nCode <> 1 then begin
            if (DBRecord.UserEntryAdd.sQuiz2 = sQuest2) then begin
              nCode:= -3;
              if DBRecord.UserEntryAdd.sAnswer2 = sAnswer2 then begin
                if DBRecord.UserEntryAdd.sBirthDay = sBirthDay then begin
                  nCode:=1;
                end;
              end;
            end;
          end;
          if nCode = 1 then begin
            sPassword:=DBRecord.UserEntry.sPassword;
          end else begin
            Inc(DBRecord.nErrorCount);
            DBRecord.dwActionTick:=GetTickCount();
            AccountDB.Update(nIndex,DBRecord);
          end;
        end else begin
          nCode:=-2;
          if GetTickCount < DBRecord.dwActionTick then begin
            DBRecord.dwActionTick:=GetTickCount();
            AccountDB.Update(nIndex,DBRecord);
          end;
        end;
      end;
    end;
  finally
    AccountDB.Close;
  end;
  if nCode = 1 then begin
    DefMsg:=MakeDefaultMsg(SM_GETBACKPASSWD_SUCCESS,0,0,0,0);
    SendGateMsg(UserInfo.Socket,UserInfo.sSockIndex,EncodeMessage(DefMsg) + EncodeString(sPassword));
  end else begin
    DefMsg:=MakeDefaultMsg(SM_GETBACKPASSWD_FAIL,nCode,0,0,0);
    SendGateMsg(UserInfo.Socket,UserInfo.sSockIndex,EncodeMessage(DefMsg));    
  end;
end;

//0046A500
procedure SendGateMsg(Socket: TCustomWinSocket; sSockIndex,
  sMsg: String);
var
  sSendMsg:String;
begin
  sSendMsg:='%' + sSockIndex + '/#' + sMsg +'!$';
  Socket.SendText(sSendMsg);
end;
//0046A104
function IsLogin(Config:pTConfig;nSessionID: Integer): Boolean;
var
  ConnInfo :pTConnInfo;
  I        :Integer;
begin
  Result:=False;
  Config.SessionList.Lock;
  try
    for I:= 0 to Config.SessionList.Count -1 do begin
      ConnInfo:=Config.SessionList.Items[I];
      if (ConnInfo.nSessionID = nSessionID)then begin
        Result:=True;
        break;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;
//00469B54
function IsLogin(Config:pTConfig;sLoginID: String): Boolean;
var
  ConnInfo :pTConnInfo;
  I        :Integer;
begin
  Result:=False;
  Config.SessionList.Lock;
  try
    for I:= 0 to Config.SessionList.Count -1 do begin
      ConnInfo:=Config.SessionList.Items[I];
      if (ConnInfo.sAccount = sLoginID) then begin
        Result:=True;
        break;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;
//00469BE8
procedure SessionKick(Config:pTConfig;sLoginID: String);
var
  ConnInfo :pTConnInfo;
  I        :Integer;
begin
  Config.SessionList.Lock;
  try
    for I:= 0 to Config.SessionList.Count -1 do begin
      ConnInfo:=Config.SessionList.Items[I];
      if (ConnInfo.sAccount = sLoginID) and not ConnInfo.boKicked then begin
        FrmMasSoc.SendServerMsg(SS_CLOSESESSION,ConnInfo.sServerName,ConnInfo.sAccount + '/' + IntToStr(ConnInfo.nSessionID));
        ConnInfo.dwKickTick := GetTickCount();
        ConnInfo.boKicked   := True;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

//00469F00
procedure SessionAdd(Config:pTConfig;sAccount, sIPaddr: String;
  nSessionID: Integer; boPayCost, bo11: Boolean);
var
  ConnInfo:pTConnInfo;
begin
  New(ConnInfo);
  ConnInfo.sAccount   := sAccount;
  ConnInfo.sIPaddr    := sIPaddr;
  ConnInfo.nSessionID := nSessionID;
  ConnInfo.boPayCost  := boPayCost;
  ConnInfo.bo11       := bo11;
  ConnInfo.dwKickTick := GetTickCount();
  ConnInfo.dwStartTick:= GetTickCount();
  ConnInfo.boKicked   := False;
  Config.SessionList.Lock;
  try
    Config.SessionList.Add(ConnInfo);
  finally
    Config.SessionList.UnLock;
  end;
end;
//0046A5AC
procedure SendGateKickMsg(Socket: TCustomWinSocket;
  sSockIndex: String);
var
  sSendMsg:String;
begin
  sSendMsg:='%+-' + sSockIndex + '$';
  Socket.SendText(sSendMsg);
end;

procedure SessionUpdate(Config:pTConfig;nSessionID: Integer; sServerName: String; boPayCost: Boolean);
var
  ConnInfo :pTConnInfo;
  I        :Integer;
begin
  Config.SessionList.Lock;
  try
    for I:= 0 to Config.SessionList.Count -1 do begin
      ConnInfo:=Config.SessionList.Items[I];
      if (ConnInfo.nSessionID = nSessionID) then begin
        ConnInfo.sServerName:=sServerName;
        ConnInfo.bo11:=boPayCost;
        break;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;
//00469694
procedure GenServerNameList(Config:pTConfig);
var
  I,II: Integer;
  boD:Boolean;
begin
try
  Config.ServerNameList.Clear;
  for I:= 0 to Config.nRouteCount - 1 do begin
    boD:=True;
    for II:= 0 to Config.ServerNameList.Count - 1 do begin
      if Config.ServerNameList.Strings[II] = Config.GateRoute[I].sServerName then boD:=False;
    end;
    if boD then Config.ServerNameList.Add(Config.GateRoute[I].sServerName);
  end;
except
  MainOutMessage('TFrmMain.GenServerNameList');
end;
end;
//00469DB4
procedure SessionClearNoPayMent(Config:pTConfig);
var
  I: Integer;
  ConnInfo:pTConnInfo;
begin
  Config.SessionList.Lock;
  try
    for I := Config.SessionList.Count - 1 downto 0 do begin
      ConnInfo:=Config.SessionList.Items[I];
      if not ConnInfo.boKicked and not Config.boTestServer and not ConnInfo.bo11 then begin
        if (GetTickCount - ConnInfo.dwStartTick) > 60 * 60 * 1000 then begin
          ConnInfo.dwStartTick:=GetTickCount();
          if not IsPayMent(Config,ConnInfo.sIPaddr,ConnInfo.sAccount) then begin
            FrmMasSoc.SendServerMsg(SS_KICKUSER,ConnInfo.sServerName,ConnInfo.sAccount + '/' + IntToStr(ConnInfo.nSessionID));
            Dispose(ConnInfo);
            Config.SessionList.Delete(I);
          end;
        end;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;
//0046DD38
procedure LoadIPaddrCostList(Config:pTConfig;QuickList:TQuickList);
begin
  try
    CS_DB.Enter;
    Config.IPaddrCostList.Clear;
    Config.IPaddrCostList.AddStrings(QuickList);
  finally
    CS_DB.Leave;
  end;
end;
//0046DCD0
procedure LoadAccountCostList(Config:pTConfig;QuickList: TQuickList);
begin
  try
    CS_DB.Enter;
    Config.AccountCostList.Clear;
    Config.AccountCostList.AddStrings(QuickList);
  finally
    CS_DB.Leave;
  end;
end;



procedure TFrmMain.Panel2DblClick(Sender: TObject);
begin
  MainOutMessage(GetServerListInfo)
end;

procedure TFrmMain.MyMessage(var MsgData: TWmCopyData);
var
  sData   :String;
  wIdent  :Word;
  Config  :pTConfig;
begin
  Config:=@g_Config;
  wIdent:=HiWord(MsgData.From);
//  ProgramType:=TProgamType(LoWord(MsgData.From));
  sData:=StrPas(MsgData.CopyDataStruct^.lpData);
  case wIdent of    //
    GS_QUIT: begin
      Config.boRemoteClose:=True;
      Close();
    end;
    GS_USERACCOUNT: begin
      GameCenterGetUserAccount(sData);
    end;
    GS_CHANGEACCOUNTINFO: GameCenterChangeAccountInfo(sData);
    3: ;
  end;    // case
end;

procedure TFrmMain.GameCenterGetUserAccount(sData: String);
var
  DBRecord:TAccountDBRecord;
  nIndex:Integer;
  nCode:Integer;
  DefMsg:TDefaultMessage;
begin
  try
    nCode:=-1;
    if AccountDB.Open then begin
      nIndex:=AccountDB.Index(sData);
      if (nIndex >= 0) and (AccountDB.Get(nIndex,DBRecord) >= 0) then begin
        nCode:=1;
      end;
    end;
  finally
    AccountDB.Close;
  end;
  if nCode > 0 then begin
    DefMsg:=MakeDefaultMsg(0,nCode,0,0,0);
    SendGameCenterMsg(SG_USERACCOUNT,EncodeMessage(DefMsg) + EncodeBuffer(@DBRecord,SizeOf(DBRecord)));
  end else begin
    DefMsg:=MakeDefaultMsg(SG_USERACCOUNTNOTFOUND,nCode,0,0,0);
    SendGameCenterMsg(SG_USERACCOUNT,EncodeMessage(DefMsg));    
  end;

end;

procedure TFrmMain.GameCenterChangeAccountInfo(sData: String);
var
  NewRecord,DBRecord:TAccountDBRecord;
  DefMsg:TDefaultMessage;
  sDefMsg:String;
  nCode,nIndex:integer;
begin
  if Length(sData) < DEFBLOCKSIZE then exit;
  sDefMsg:=Copy(sData,1,DEFBLOCKSIZE);
  sData:=Copy(sData,DEFBLOCKSIZE+1,Length(sData)-DEFBLOCKSIZE);
  DefMsg:=DecodeMessage(sDefMsg);
  DecodeBuffer(sData,@NewRecord,SizeOf(NewRecord));
  nCode:=-1;
  try
    if AccountDB.Open then begin
      nIndex:=AccountDB.Index(NewRecord.UserEntry.sAccount);
      if (nIndex >= 0) and (AccountDB.Get(nIndex,DBRecord) >= 0) then begin
        if DBRecord.UserEntry.sAccount = NewRecord.UserEntry.sAccount then begin
          DBRecord.nErrorCount  := 0;
          DBRecord.dwActionTick := 0;
          DBRecord.UserEntry    := NewRecord.UserEntry;
          DBRecord.UserEntryAdd := NewRecord.UserEntryAdd;
          AccountDB.Update(nIndex,DBRecord);
          nCode:=1;
        end else begin
          nCode:=2;
        end;
      end;
    end;
  finally
    AccountDB.Close;
  end;
  DefMsg:=MakeDefaultMsg(0,nCode,0,0,0);
  SendGameCenterMsg(SG_USERACCOUNTCHANGESTATUS,EncodeMessage(DefMsg));
end;


procedure SaveContLogMsg(Config:pTConfig;sLogMsg: String);
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  sLogDir,sLogFileName:String;
  LogFile:TextFile;
begin
  if sLogMsg = '' then exit;

  DecodeDate(Date, Year, Month, Day);
  DecodeTime(Time, Hour, Min, Sec, MSec);
  if not DirectoryExists(Config.sCountLogDir) then begin
    CreateDir(Config.sCountLogDir);
  end;
  sLogDir:=Config.sCountLogDir + IntToStr(Year) + '-' + IntToStr2(Month);
  if not DirectoryExists(sLogDir) then begin
    CreateDirectory(PChar(sLogDir),nil);
  end;
  sLogFileName:=sLogDir + '\' + IntToStr(Year) + '-' + IntToStr2(Month) + '-' + IntToStr2(Day) + '.txt';
  AssignFile(LogFile,sLogFileName);
  if not FileExists(sLogFileName) then begin
    Rewrite(LogFile);
  end else begin
    Append(LogFile);
  end;
  sLogMsg:=sLogMsg + #9 + TimeToStr(Time);

  WriteLn(LogFile,sLogMsg);
  CloseFile(LogFile);
end;

procedure WriteLogMsg(Config:pTConfig;sType: String; var UserEntry: TUserEntry;
  var UserAddEntry: TUserEntryAdd);
var
  Year, Month, Day: Word;
  sLogDir,sLogFileName:String;
  LogFile:TextFile;
 sLogFormat,sLogMsg:String;

begin

  DecodeDate(Date, Year, Month, Day);
  if not DirectoryExists(Config.sChrLogDir) then begin
    CreateDir(Config.sChrLogDir);
  end;
  sLogDir:=Config.sChrLogDir + IntToStr(Year) + '-' + IntToStr2(Month);
  if not DirectoryExists(sLogDir) then begin
    CreateDirectory(PChar(sLogDir),nil);
  end;
  sLogFileName:=sLogDir + '\Id_' + IntToStr2(Day) + '.log';
  AssignFile(LogFile,sLogFileName);
  if not FileExists(sLogFileName) then begin
    Rewrite(LogFile);
  end else begin
    Append(LogFile);
  end;
  sLogFormat:= '*%s*'#9'%s'#9'"%s"'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'[%s]';
  sLogMsg:=format(sLogFormat,[sType,
                              UserEntry.sAccount,
                              UserEntry.sPassword,
                              UserEntry.sUserName,
                              UserEntry.sSSNo,
                              UserEntry.sQuiz,
                              UserEntry.sAnswer,
                              UserEntry.sEMail,
                              UserAddEntry.sQuiz2,
                              UserAddEntry.sAnswer2,
                              UserAddEntry.sBirthDay,
                              UserAddEntry.sMobilePhone,
                              TimeToStr(Now)]);

  //sLogMsg:= UserAddEntry.sQuiz2 + UserAddEntry.sAnswer2 + UserAddEntry.sBirthDay + UserAddEntry.sMobilePhone + '[' + TimeToStr(Now) + ']';

  WriteLn(LogFile,sLogMsg);
  CloseFile(LogFile);
end;

procedure StartService(Config:pTConfig);
begin
  InitializeConfig(Config);
  LoadConfig(Config);
end;
procedure StopService(Config:pTConfig);
begin
  UnInitializeConfig(Config);
end;
procedure InitializeConfig(Config:pTConfig);
ResourceString
  sConfigFile = '.\Logsrv.ini';
begin
  Config.IniConf:=TIniFile.Create(sConfigFile);
  InitializeCriticalSection(Config.GateCriticalSection);
end;
procedure UnInitializeConfig(Config:pTConfig);
begin
  Config.IniConf.Free;
  DeleteCriticalSection(Config.GateCriticalSection);
end;
procedure LoadConfig(Config:pTConfig);
  function LoadConfigString(sSection,sIdent,sDefault: String):String;
  var
    sString:String;
  begin
    sString:=Config.IniConf.ReadString(sSection,sIdent,'');
    if sString = '' then begin
      Config.IniConf.WriteString(sSection,sIdent,sDefault);
      Result:=sDefault;
    end else begin
      Result:=sString;
    end;
  end;
  function LoadConfigInteger(sSection,sIdent:String;nDefault:Integer):Integer;
  var
    nLoadInteger:Integer;
  begin
    nLoadInteger:=Config.IniConf.ReadInteger(sSection,sIdent,-1);
    if nLoadInteger < 0 then begin
      Config.IniConf.WriteInteger(sSection,sIdent,nDefault);
      Result:=nDefault;
    end else begin
      Result:=nLoadInteger;
    end;
  end;
  function LoadConfigBoolean(sSection,sIdent:String;boDefault:Boolean):Boolean;
  var
    nLoadInteger:Integer;
  begin
    nLoadInteger:=Config.IniConf.ReadInteger(sSection,sIdent,-1);
    if nLoadInteger < 0 then begin
      Config.IniConf.WriteBool(sSection,sIdent,boDefault);
      Result:=boDefault;
    end else begin
      Result:=nLoadInteger = 1;
    end;
  end;
ResourceString
  sSectionServer      = 'Server';
  sSectionDB          = 'DB';
  sIdentDBServer      = 'DBServer';
  sIdentFeeServer     = 'FeeServer';
  sIdentLogServer     = 'LogServer';
  sIdentGateAddr      = 'GateAddr';
  sIdentGatePort      = 'GatePort';
  sIdentServerAddr    = 'ServerAddr';
  sIdentServerPort    = 'ServerPort';
  sIdentMonAddr       = 'MonAddr';
  sIdentMonPort       = 'MonPort';
  sIdentDBSPort       = 'DBSPort';
  sIdentFeePort       = 'FeePort';
  sIdentLogPort       = 'LogPort';
  sIdentReadyServers  = 'ReadyServers';
  sIdentTestServer    = 'TestServer';
  sIdentDynamicIPMode = 'DynamicIPMode';
  sIdentIdDir         = 'IdDir';
  sIdentWebLogDir     = 'WebLogDir';
  sIdentCountLogDir   = 'CountLogDir';
  sIdentFeedIDList    = 'FeedIDList';
  sIdentFeedIPList    = 'FeedIPList';
begin
  Config.sDBServer       := LoadConfigString(sSectionServer,sIdentDBServer,Config.sDBServer);
  Config.sFeeServer      := LoadConfigString(sSectionServer,sIdentFeeServer,Config.sFeeServer);
  Config.sLogServer      := LoadConfigString(sSectionServer,sIdentLogServer,Config.sLogServer);

  Config.sGateAddr       := LoadConfigString(sSectionServer,sIdentGateAddr,Config.sGateAddr);
  Config.nGatePort       := LoadConfigInteger(sSectionServer,sIdentGatePort,Config.nGatePort);
  Config.sServerAddr     := LoadConfigString(sSectionServer,sIdentServerAddr,Config.sServerAddr);
  Config.nServerPort     := LoadConfigInteger(sSectionServer,sIdentServerPort,Config.nServerPort);
  Config.sMonAddr        := LoadConfigString(sSectionServer,sIdentMonAddr,Config.sMonAddr);
  Config.nMonPort        := LoadConfigInteger(sSectionServer,sIdentMonPort,Config.nMonPort);

  Config.nDBSPort               := LoadConfigInteger(sSectionServer,sIdentDBSPort,Config.nDBSPort);
  Config.nFeePort               := LoadConfigInteger(sSectionServer,sIdentFeePort,Config.nFeePort);
  Config.nLogPort               := LoadConfigInteger(sSectionServer,sIdentLogPort,Config.nLogPort);
  Config.nReadyServers          := LoadConfigInteger(sSectionServer,sIdentReadyServers,Config.nReadyServers);
  Config.boEnableMakingID       := LoadConfigBoolean(sSectionServer,sIdentTestServer,Config.boEnableMakingID);
  Config.boDynamicIPMode        := LoadConfigBoolean(sSectionServer,sIdentDynamicIPMode,Config.boDynamicIPMode);
  
  Config.sIdDir                 := LoadConfigString(sSectionDB,sIdentIdDir,Config.sIdDir);
  Config.sWebLogDir             := LoadConfigString(sSectionDB,sIdentWebLogDir,Config.sWebLogDir);
  Config.sCountLogDir           := LoadConfigString(sSectionDB,sIdentCountLogDir,Config.sCountLogDir);
  Config.sFeedIDList            := LoadConfigString(sSectionDB,sIdentFeedIDList,Config.sFeedIDList);
  Config.sFeedIPList            := LoadConfigString(sSectionDB,sIdentFeedIPList,Config.sFeedIPList);

end;          

//Out message. Add modified by Davy 2019-11-9
procedure TFrmMain.MainLogOutMessage(sMsg: String);
begin
  Memo1.Lines.Add(sMsg)
end;

procedure TFrmMain.MENU_HELP_ABOUTClick(Sender: TObject);
begin
    MainLogOutMessage('欢迎使用MIR2系统软件...');
    MainLogOutMessage('引擎版本: 1.5.0 (20020522)');
    MainLogOutMessage('更新日期: 2019/09/09');
    MainLogOutMessage('程序制作: Cola PI');
end;

end.

