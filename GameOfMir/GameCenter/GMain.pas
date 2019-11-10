unit GMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,INIFiles, ExtCtrls,
  Spin, JSocket, jpeg, ScktComp;

type
  TfrmMain = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    PageControl2: TPageControl;
    PageControl3: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditGameDir: TEdit;
    Button1: TButton;
    Label2: TLabel;
    EditHeroDB: TEdit;
    ButtonNext1: TButton;
    ButtonNext2: TButton;
    GroupBox2: TGroupBox;
    ButtonPrv2: TButton;
    EditGameName: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    EditGameExtIPaddr: TEdit;
    GroupBox5: TGroupBox;
    EditM2ServerProgram: TEdit;
    EditDBServerProgram: TEdit;
    EditLoginSrvProgram: TEdit;
    EditLogServerProgram: TEdit;
    EditLoginGateProgram: TEdit;
    EditSelGateProgram: TEdit;
    EditRunGateProgram: TEdit;
    ButtonStartGame: TButton;
    CheckBoxM2Server: TCheckBox;
    CheckBoxDBServer: TCheckBox;
    CheckBoxLoginServer: TCheckBox;
    CheckBoxLogServer: TCheckBox;
    CheckBoxLoginGate: TCheckBox;
    CheckBoxSelGate: TCheckBox;
    CheckBoxRunGate: TCheckBox;
    CheckBoxRunGate1: TCheckBox;
    EditRunGate1Program: TEdit;
    CheckBoxRunGate2: TCheckBox;
    EditRunGate2Program: TEdit;
    TimerStartGame: TTimer;
    TimerStopGame: TTimer;
    TimerCheckRun: TTimer;
    MemoLog: TMemo;
    GroupBox6: TGroupBox;
    Label8: TLabel;
    EditSkin: TSpinEdit;
    ButtonFormSave: TButton;
    ButtonReLoadConfig: TButton;
    GroupBox7: TGroupBox;
    Label9: TLabel;
    EditLoginGate_MainFormX: TSpinEdit;
    Label10: TLabel;
    EditLoginGate_MainFormY: TSpinEdit;
    GroupBox3: TGroupBox;
    GroupBox8: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    EditSelGate_MainFormX: TSpinEdit;
    EditSelGate_MainFormY: TSpinEdit;
    TabSheet7: TTabSheet;
    GroupBox9: TGroupBox;
    GroupBox10: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    EditLoginServer_MainFormX: TSpinEdit;
    EditLoginServer_MainFormY: TSpinEdit;
    TabSheet8: TTabSheet;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    EditDBServer_MainFormX: TSpinEdit;
    EditDBServer_MainFormY: TSpinEdit;
    TabSheet9: TTabSheet;
    GroupBox13: TGroupBox;
    GroupBox14: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    EditLogServer_MainFormX: TSpinEdit;
    EditLogServer_MainFormY: TSpinEdit;
    TabSheet10: TTabSheet;
    GroupBox15: TGroupBox;
    GroupBox16: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    EditM2Server_MainFormX: TSpinEdit;
    EditM2Server_MainFormY: TSpinEdit;
    TabSheet11: TTabSheet;
    ButtonSave: TButton;
    ButtonGenGameConfig: TButton;
    ButtonPrv3: TButton;
    ButtonNext3: TButton;
    TabSheet12: TTabSheet;
    ButtonPrv4: TButton;
    ButtonNext4: TButton;
    ButtonPrv5: TButton;
    ButtonNext5: TButton;
    ButtonPrv6: TButton;
    ButtonNext6: TButton;
    ButtonPrv7: TButton;
    ButtonNext7: TButton;
    ButtonPrv8: TButton;
    ButtonNext8: TButton;
    ButtonPrv9: TButton;
    GroupBox17: TGroupBox;
    GroupBox18: TGroupBox;
    Label21: TLabel;
    Label22: TLabel;
    EditRunGate_MainFormX: TSpinEdit;
    EditRunGate_MainFormY: TSpinEdit;
    GroupBox19: TGroupBox;
    Label23: TLabel;
    EditRunGate_Connt: TSpinEdit;
    TabSheet13: TTabSheet;
    ButtonLoginServerConfig: TButton;
    CheckBoxDynamicIPMode: TCheckBox;
    GroupBox20: TGroupBox;
    CheckBoxAutoBackupHumData: TCheckBox;
    TabSheet14: TTabSheet;
    GroupBox21: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    LabelConnect: TLabel;
    Label27: TLabel;
    MemoGameList: TMemo;
    EditNoticeUrl: TEdit;
    Memo1: TMemo;
    Button2: TButton;
    EditClientForm: TSpinEdit;
    ServerSocket: TServerSocket;
    Timer: TTimer;
    GroupBox22: TGroupBox;
    LabelRunGate_GatePort1: TLabel;
    EditRunGate_GatePort1: TEdit;
    LabelLabelRunGate_GatePort2: TLabel;
    EditRunGate_GatePort2: TEdit;
    LabelRunGate_GatePort3: TLabel;
    EditRunGate_GatePort3: TEdit;
    LabelRunGate_GatePort4: TLabel;
    EditRunGate_GatePort4: TEdit;
    LabelRunGate_GatePort5: TLabel;
    EditRunGate_GatePort5: TEdit;
    LabelRunGate_GatePort6: TLabel;
    EditRunGate_GatePort6: TEdit;
    LabelRunGate_GatePort7: TLabel;
    EditRunGate_GatePort7: TEdit;
    EditRunGate_GatePort8: TEdit;
    LabelRunGate_GatePort78: TLabel;
    ButtonRunGateDefault: TButton;
    ButtonSelGateDefault: TButton;
    ButtonGeneralDefalult: TButton;
    ButtonLoginGateDefault: TButton;
    ButtonLoginSrvDefault: TButton;
    ButtonDBServerDefault: TButton;
    ButtonLogServerDefault: TButton;
    ButtonM2ServerDefault: TButton;
    GroupBox23: TGroupBox;
    Label28: TLabel;
    EditLoginGate_GatePort: TEdit;
    GroupBox24: TGroupBox;
    Label29: TLabel;
    EditSelGate_GatePort: TEdit;
    TabSheet15: TTabSheet;
    GroupBox25: TGroupBox;
    EditSearchLoginAccount: TEdit;
    Label30: TLabel;
    ButtonSearchLoginAccount: TButton;
    GroupBox26: TGroupBox;
    Label31: TLabel;
    EditLoginAccount: TEdit;
    Label32: TLabel;
    EditLoginAccountPasswd: TEdit;
    Label33: TLabel;
    EditLoginAccountUserName: TEdit;
    Label34: TLabel;
    EditLoginAccountSSNo: TEdit;
    Label35: TLabel;
    EditLoginAccountBirthDay: TEdit;
    Label36: TLabel;
    EditLoginAccountQuiz: TEdit;
    Label37: TLabel;
    EditLoginAccountAnswer: TEdit;
    Label38: TLabel;
    Label39: TLabel;
    EditLoginAccountQuiz2: TEdit;
    EditLoginAccountAnswer2: TEdit;
    Label40: TLabel;
    EditLoginAccountMobilePhone: TEdit;
    EditLoginAccountMemo1: TEdit;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    EditLoginAccountEMail: TEdit;
    EditLoginAccountMemo2: TEdit;
    CkFullEditMode: TCheckBox;
    ButtonLoginAccountOK: TButton;
    Label44: TLabel;
    EditLoginAccountPhone: TEdit;
    GroupBox27: TGroupBox;
    CheckBoxboLoginGate_GetStart: TCheckBox;
    GroupBox28: TGroupBox;
    CheckBoxboSelGate_GetStart: TCheckBox;
    TabSheetDebug: TTabSheet;
    GroupBox29: TGroupBox;
    GroupBox30: TGroupBox;
    Label45: TLabel;
    EditM2CheckCodeAddr: TEdit;
    TimerCheckDebug: TTimer;
    Label46: TLabel;
    EditM2CheckCode: TEdit;
    ButtonM2Suspend: TButton;
    GroupBox31: TGroupBox;
    Label47: TLabel;
    Label48: TLabel;
    EditDBCheckCodeAddr: TEdit;
    EditDBCheckCode: TEdit;
    Button3: TButton;
    GroupBox32: TGroupBox;
    Label61: TLabel;
    Label62: TLabel;
    EditM2Server_TestLevel: TSpinEdit;
    EditM2Server_TestGold: TSpinEdit;
    Label49: TLabel;
    EditSelGate_GatePort1: TEdit;
    GroupBox33: TGroupBox;
    Label50: TLabel;
    Label51: TLabel;
    EditLoginServerGatePort: TEdit;
    EditLoginServerServerPort: TEdit;
    GroupBox34: TGroupBox;
    CheckBoxboLoginServer_GetStart: TCheckBox;
    GroupBox35: TGroupBox;
    CheckBoxDBServerGetStart: TCheckBox;
    GroupBox36: TGroupBox;
    Label52: TLabel;
    Label53: TLabel;
    EditDBServerGatePort: TEdit;
    EditDBServerServerPort: TEdit;
    GroupBox37: TGroupBox;
    CheckBoxLogServerGetStart: TCheckBox;
    GroupBox38: TGroupBox;
    Label54: TLabel;
    EditLogServerPort: TEdit;
    GroupBox39: TGroupBox;
    Label55: TLabel;
    EditM2ServerGatePort: TEdit;
    GroupBox40: TGroupBox;
    CheckBoxM2ServerGetStart: TCheckBox;
    Label56: TLabel;
    EditM2ServerMsgSrvPort: TEdit;
    Label57: TLabel;
    EditDBCheckStr: TEdit;
    Label58: TLabel;
    EditM2CheckStr: TEdit;
    Label59: TLabel;
    EditBackupTime: TSpinEdit;
    Label60: TLabel;
    GroupBox4: TGroupBox;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    GroupBox41: TGroupBox;
    procedure ButtonNext1Click(Sender: TObject);
    procedure ButtonPrv2Click(Sender: TObject);
    procedure ButtonNext2Click(Sender: TObject);
    procedure ButtonPrv3Click(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonGenGameConfigClick(Sender: TObject);
    procedure ButtonStartGameClick(Sender: TObject);
    procedure TimerStartGameTimer(Sender: TObject);
    procedure CheckBoxDBServerClick(Sender: TObject);
    procedure CheckBoxLoginServerClick(Sender: TObject);
    procedure CheckBoxM2ServerClick(Sender: TObject);
    procedure CheckBoxLogServerClick(Sender: TObject);
    procedure CheckBoxLoginGateClick(Sender: TObject);
    procedure CheckBoxSelGateClick(Sender: TObject);
    procedure CheckBoxRunGateClick(Sender: TObject);
    procedure CheckBoxRunGate1Click(Sender: TObject);
    procedure CheckBoxRunGate2Click(Sender: TObject);
    procedure TimerStopGameTimer(Sender: TObject);
    procedure TimerCheckRunTimer(Sender: TObject);
    procedure EditSkinChange(Sender: TObject);
    procedure ButtonFormSaveClick(Sender: TObject);
    procedure ButtonReLoadConfigClick(Sender: TObject);
    procedure EditLoginGate_MainFormXChange(Sender: TObject);
    procedure EditLoginGate_MainFormYChange(Sender: TObject);
    procedure EditSelGate_MainFormXChange(Sender: TObject);
    procedure EditSelGate_MainFormYChange(Sender: TObject);
    procedure EditLoginServer_MainFormXChange(Sender: TObject);
    procedure EditLoginServer_MainFormYChange(Sender: TObject);
    procedure EditDBServer_MainFormXChange(Sender: TObject);
    procedure EditDBServer_MainFormYChange(Sender: TObject);
    procedure EditLogServer_MainFormXChange(Sender: TObject);
    procedure EditLogServer_MainFormYChange(Sender: TObject);
    procedure EditM2Server_MainFormXChange(Sender: TObject);
    procedure EditM2Server_MainFormYChange(Sender: TObject);
    procedure MemoLogChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ButtonNext3Click(Sender: TObject);
    procedure ButtonNext4Click(Sender: TObject);
    procedure ButtonNext5Click(Sender: TObject);
    procedure ButtonNext6Click(Sender: TObject);
    procedure ButtonNext7Click(Sender: TObject);
    procedure ButtonPrv4Click(Sender: TObject);
    procedure ButtonPrv5Click(Sender: TObject);
    procedure ButtonPrv6Click(Sender: TObject);
    procedure ButtonPrv7Click(Sender: TObject);
    procedure ButtonPrv8Click(Sender: TObject);
    procedure ButtonNext8Click(Sender: TObject);
    procedure ButtonPrv9Click(Sender: TObject);
    procedure EditRunGate_ConntChange(Sender: TObject);
    procedure ButtonLoginServerConfigClick(Sender: TObject);
    procedure CheckBoxDynamicIPModeClick(Sender: TObject);
    procedure CheckBoxAutoBackupHumDataClick(Sender: TObject);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure TimerTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure EditNoticeUrlChange(Sender: TObject);
    procedure EditClientFormChange(Sender: TObject);
    procedure MemoGameListChange(Sender: TObject);
    procedure ButtonRunGateDefaultClick(Sender: TObject);
    procedure ButtonGeneralDefalultClick(Sender: TObject);
    procedure ButtonLoginGateDefaultClick(Sender: TObject);
    procedure ButtonSelGateDefaultClick(Sender: TObject);
    procedure ButtonLoginSrvDefaultClick(Sender: TObject);
    procedure ButtonDBServerDefaultClick(Sender: TObject);
    procedure ButtonLogServerDefaultClick(Sender: TObject);
    procedure ButtonM2ServerDefaultClick(Sender: TObject);
    procedure ButtonSearchLoginAccountClick(Sender: TObject);
    procedure CkFullEditModeClick(Sender: TObject);
    procedure ButtonLoginAccountOKClick(Sender: TObject);
    procedure EditLoginAccountChange(Sender: TObject);
    procedure CheckBoxboLoginGate_GetStartClick(Sender: TObject);
    procedure CheckBoxboSelGate_GetStartClick(Sender: TObject);
    procedure TimerCheckDebugTimer(Sender: TObject);
    procedure ButtonM2SuspendClick(Sender: TObject);
    procedure EditM2Server_TestLevelChange(Sender: TObject);
    procedure EditM2Server_TestGoldChange(Sender: TObject);
    procedure CheckBoxboLoginServer_GetStartClick(Sender: TObject);
    procedure CheckBoxDBServerGetStartClick(Sender: TObject);
    procedure CheckBoxLogServerGetStartClick(Sender: TObject);
    procedure CheckBoxM2ServerGetStartClick(Sender: TObject);
    procedure EditBackupTimeChange(Sender: TObject);
  private
    m_boOpen:Boolean;
    m_nStartStatus:Integer;
    m_dwShowTick:LongWord;
    procedure RefGameConsole();
    procedure GenGameConfig();
    procedure GenDBServerConfig();
    procedure GenLoginServerConfig();
    procedure GenLogServerConfig();
    procedure GenM2ServerConfig();
    procedure GenLoginGateConfig();
    procedure GenSelGateConfig();
    procedure GenRunGateConfig;
    procedure StartGame();
    procedure StopGame();
    procedure MainOutMessage(sMsg:string);
    procedure ProcessDBServerMsg(wIdent:Word;sData:String);
    procedure ProcessLoginSrvMsg(wIdent:Word;sData:String);
    procedure ProcessLoginSrvGetUserAccount(sData:String);
    procedure ProcessLoginSrvChangeUserAccountStatus(sData:String);
    procedure UserAccountEditMode(boChecked:Boolean);
    procedure ProcessLogServerMsg(wIdent:Word;sData:String);

    procedure ProcessLoginGateMsg(wIdent:Word;sData:String);
    procedure ProcessLoginGate1Msg(wIdent:Word;sData:String);

    procedure ProcessSelGateMsg(wIdent:Word;sData:String);
    procedure ProcessSelGate1Msg(wIdent:Word;sData:String);

    procedure ProcessRunGateMsg(wIdent:Word;sData:String);
    procedure ProcessRunGate1Msg(wIdent:Word;sData:String);
    procedure ProcessRunGate2Msg(wIdent:Word;sData:String);
    procedure ProcessRunGate3Msg(wIdent:Word;sData:String);
    procedure ProcessRunGate4Msg(wIdent:Word;sData:String);
    procedure ProcessRunGate5Msg(wIdent:Word;sData:String);
    procedure ProcessRunGate6Msg(wIdent:Word;sData:String);
    procedure ProcessRunGate7Msg(wIdent:Word;sData:String);


    procedure ProcessM2ServerMsg(wIdent:Word;sData:String);
    procedure GetMutRunGateConfing(nIndex:Integer);


    procedure ProcessClientPacket();
    procedure SendGameList(Socket:TCustomWinSocket);
    procedure SendSocket(Socket:TCustomWinSocket;SendMsg: String);
    function StartService():Boolean;
    procedure StopService();
    procedure RefGameDebug();
    procedure GenMutSelGateConfig(nIndex: Integer);
    { Private declarations }
  public
    procedure ProcessMessage(var Msg: TMsg; var Handled: Boolean);
    procedure MyMessage(var MsgData:TWmCopyData);message WM_COPYDATA;

    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses GShare, HUtil32, Grobal2, GLoginServer, EDcode;

{$R *.dfm}

procedure TfrmMain.MainOutMessage(sMsg: string);
begin
  sMsg:='[' + DateTimeToStr(Now) + '] ' + sMsg;
  MemoLog.Lines.Add(sMsg);
end;

procedure TfrmMain.ButtonNext1Click(Sender: TObject);
var
  sGameDirectory:String;
  sHeroDBName:String;
  sGameName:String;
  sExtIPAddr:String;
begin
  sGameDirectory:=Trim(EditGameDir.Text);
  sHeroDBName:=Trim(EditHeroDB.Text);

  sGameName:=Trim(EditGameName.Text);
  sExtIPAddr:=Trim(EditGameExtIPaddr.Text);
  if sGameName = '' then begin
    Application.MessageBox('游戏服务器名称输入不正确！！！','提示信息',MB_OK + MB_ICONEXCLAMATION);
    EditGameName.SetFocus;
    exit;
  end;
  if (sExtIPAddr = '') or not IsIPaddr(sExtIPAddr) then begin
    Application.MessageBox('游戏服务器外部IP地址输入不正确！！！','提示信息',MB_OK + MB_ICONEXCLAMATION);
    EditGameExtIPaddr.SetFocus;
    exit;
  end;

  if (sGameDirectory = '') or not DirectoryExists(sGameDirectory) then begin
    Application.MessageBox('游戏目录输入不正确！！！','提示信息',MB_OK + MB_ICONEXCLAMATION);
    EditGameDir.SetFocus;
    exit;
  end;
  if not (sGameDirectory[length(sGameDirectory)] = '\') then begin
    Application.MessageBox('游戏目录名称最后一个字符必须为"\"！！！','提示信息',MB_OK + MB_ICONEXCLAMATION);
    EditGameDir.SetFocus;
    exit;
  end;
  if sHeroDBName = '' then begin
    Application.MessageBox('游戏数据库名称输入不正确！！！','提示信息',MB_OK + MB_ICONEXCLAMATION);
    EditHeroDB.SetFocus;
    exit;
  end;

  g_sGameDirectory:=sGameDirectory;
  g_sHeroDBName:=sHeroDBName;
  g_sGameName:=sGameName;
  g_sExtIPaddr:=sExtIPAddr;
  g_boDynamicIPMode:=CheckBoxDynamicIPMode.Checked;

    
  PageControl3.ActivePageIndex:=1;
end;

procedure TfrmMain.ButtonPrv2Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex:=0;
end;

procedure TfrmMain.ButtonNext2Click(Sender: TObject);
var
  nPort:Integer;
begin
  nPort:=Str_ToInt(Trim(EditLoginGate_GatePort.Text),-1);
  if (nPort < 0) or (nPort > 65535) then begin
    Application.MessageBox('网关端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditLoginGate_GatePort.SetFocus;
    exit;
  end;
  g_nLoginGate_GatePort:=nPort;
  PageControl3.ActivePageIndex:=2;
end;

procedure TfrmMain.ButtonPrv3Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex:=1;
end;
procedure TfrmMain.ButtonNext3Click(Sender: TObject);
var
  nPort:Integer;
begin
  nPort:=Str_ToInt(Trim(EditSelGate_GatePort.Text),-1);
  if (nPort < 0) or (nPort > 65535) then begin
    Application.MessageBox('网关端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditSelGate_GatePort.SetFocus;
    exit;
  end;
  g_nSeLGate_GatePort:=nPort;

  nPort:=Str_ToInt(Trim(EditSelGate_GatePort1.Text),-1);
  if (nPort < 0) or (nPort > 65535) then begin
    Application.MessageBox('网关端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditSelGate_GatePort1.SetFocus;
    exit;
  end;
  g_nSeLGate_GatePort1:=nPort;
  PageControl3.ActivePageIndex:=3;
end;

procedure TfrmMain.ButtonNext4Click(Sender: TObject);
var
  nPort1,nPort2,nPort3,nPort4,nPort5,nPort6,nPort7,nPort8:Integer;
begin
  nPort1:=Str_ToInt(Trim(EditRunGate_GatePort1.Text),-1);
  nPort2:=Str_ToInt(Trim(EditRunGate_GatePort2.Text),-1);
  nPort3:=Str_ToInt(Trim(EditRunGate_GatePort3.Text),-1);
  nPort4:=Str_ToInt(Trim(EditRunGate_GatePort4.Text),-1);
  nPort5:=Str_ToInt(Trim(EditRunGate_GatePort5.Text),-1);
  nPort6:=Str_ToInt(Trim(EditRunGate_GatePort6.Text),-1);
  nPort7:=Str_ToInt(Trim(EditRunGate_GatePort7.Text),-1);
  nPort8:=Str_ToInt(Trim(EditRunGate_GatePort8.Text),-1);

  if (nPort1 < 0) or (nPort1 > 65535) then begin
    Application.MessageBox('网关一端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditRunGate_GatePort1.SetFocus;
    exit;
  end;
  if (nPort2 < 0) or (nPort2 > 65535) then begin
    Application.MessageBox('网关二端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditRunGate_GatePort2.SetFocus;
    exit;
  end;
  if (nPort3 < 0) or (nPort3 > 65535) then begin
    Application.MessageBox('网关三端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditRunGate_GatePort3.SetFocus;
    exit;
  end;
  if (nPort4 < 0) or (nPort4 > 65535) then begin
    Application.MessageBox('网关四端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditRunGate_GatePort4.SetFocus;
    exit;
  end;
  if (nPort5 < 0) or (nPort5 > 65535) then begin
    Application.MessageBox('网关五端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditRunGate_GatePort5.SetFocus;
    exit;
  end;
  if (nPort6 < 0) or (nPort6 > 65535) then begin
    Application.MessageBox('网关六端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditRunGate_GatePort6.SetFocus;
    exit;
  end;
  if (nPort7 < 0) or (nPort7 > 65535) then begin
    Application.MessageBox('网关七端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditRunGate_GatePort7.SetFocus;
    exit;
  end;
  if (nPort8 < 0) or (nPort8 > 65535) then begin
    Application.MessageBox('网关八端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditRunGate_GatePort8.SetFocus;
    exit;
  end;

  g_nRunGate_GatePort:=nPort1;
  g_nRunGate1_GatePort:=nPort2;
  g_nRunGate2_GatePort:=nPort3;
  g_nRunGate3_GatePort:=nPort4;
  g_nRunGate4_GatePort:=nPort5;
  g_nRunGate5_GatePort:=nPort6;
  g_nRunGate6_GatePort:=nPort7;
  g_nRunGate7_GatePort:=nPort8;


  PageControl3.ActivePageIndex:=4;
end;

procedure TfrmMain.ButtonNext5Click(Sender: TObject);
var
  nGatePort,nServerPort:Integer;
begin
  nGatePort:=Str_ToInt(Trim(EditLoginServerGatePort.Text),-1);
  nServerPort:=Str_ToInt(Trim(EditLoginServerServerPort.Text),-1);

  if (nGatePort < 0) or (nGatePort > 65535) then begin
    Application.MessageBox('网关端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditLoginServerGatePort.SetFocus;
    exit;
  end;
  if (nServerPort < 0) or (nServerPort > 65535) then begin
    Application.MessageBox('通讯端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditLoginServerServerPort.SetFocus;
    exit;
  end;
  g_nLoginServer_GatePort         := nGatePort;
  g_nLoginServer_ServerPort       := nServerPort;
  PageControl3.ActivePageIndex:=5;
end;

procedure TfrmMain.ButtonNext6Click(Sender: TObject);
var
  nGatePort,nServerPort:Integer;
begin
  nGatePort:=Str_ToInt(Trim(EditDBServerGatePort.Text),-1);
  nServerPort:=Str_ToInt(Trim(EditDBServerServerPort.Text),-1);

  if (nGatePort < 0) or (nGatePort > 65535) then begin
    Application.MessageBox('网关端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditDBServerGatePort.SetFocus;
    exit;
  end;
  if (nServerPort < 0) or (nServerPort > 65535) then begin
    Application.MessageBox('通讯端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditDBServerServerPort.SetFocus;
    exit;
  end;
  g_nDBServer_Config_GatePort         := nGatePort;
  g_nDBServer_Config_ServerPort       := nServerPort;
  g_sDBServer_DBName                  := g_sHeroDBName;
  PageControl3.ActivePageIndex:=6;
end;

procedure TfrmMain.ButtonNext7Click(Sender: TObject);
var
  nPort:Integer;
begin
  nPort:=Str_ToInt(Trim(EditLogServerPort.Text),-1);
  if (nPort < 0) or (nPort > 65535) then begin
    Application.MessageBox('端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditLogServerPort.SetFocus;
    exit;
  end;
  g_nLogServer_Port:=nPort;
  PageControl3.ActivePageIndex:=7;
end;
procedure TfrmMain.ButtonNext8Click(Sender: TObject);
var
  nGatePort,nMsgSrvPort:Integer;
begin
  nGatePort:=Str_ToInt(Trim(EditM2ServerGatePort.Text),-1);
  nMsgSrvPort:=Str_ToInt(Trim(EditM2ServerMsgSrvPort.Text),-1);
  if (nGatePort < 0) or (nGatePort > 65535) then begin
    Application.MessageBox('网关端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditM2ServerGatePort.SetFocus;
    exit;
  end;
  if (nMsgSrvPort < 0) or (nMsgSrvPort > 65535) then begin
    Application.MessageBox('通讯端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditM2ServerMsgSrvPort.SetFocus;
    exit;
  end;
  g_nM2Server_GatePort:=nGatePort;
  g_nM2Server_MsgSrvPort:=nMsgSrvPort;
  PageControl3.ActivePageIndex:=8;
end;

procedure TfrmMain.ButtonPrv4Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex:=2;
end;

procedure TfrmMain.ButtonPrv5Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex:=3;
end;

procedure TfrmMain.ButtonPrv6Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex:=4;
end;

procedure TfrmMain.ButtonPrv7Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex:=5;
end;

procedure TfrmMain.ButtonPrv8Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex:=6;
end;


procedure TfrmMain.ButtonPrv9Click(Sender: TObject);
begin
  PageControl3.ActivePageIndex:=7;
end;
procedure TfrmMain.ButtonSaveClick(Sender: TObject);
begin
//  ButtonSave.Enabled:=False;
  g_IniConf.WriteInteger('GameConf','dwStopTimeOut',g_dwStopTimeOut);
  g_IniConf.WriteString('GameConf','GameDirectory',g_sGameDirectory);
  g_IniConf.WriteString('GameConf','HeroDBName',g_sHeroDBName);
  g_IniConf.WriteString('GameConf','GameName',g_sGameName);
  g_IniConf.WriteString('GameConf','ExtIPaddr',g_sExtIPaddr);

  g_IniConf.WriteBool('GameConf','DynamicIPMode',g_boDynamicIPMode);

  g_IniConf.WriteInteger('DBServer','MainFormX',g_nDBServer_MainFormX);
  g_IniConf.WriteInteger('DBServer','MainFormY',g_nDBServer_MainFormY);
  g_IniConf.WriteInteger('DBServer','GatePort',g_nDBServer_Config_GatePort);
  g_IniConf.WriteInteger('DBServer','ServerPort',g_nDBServer_Config_ServerPort);
  g_IniConf.WriteBool('DBServer','GetStart',g_boDBServer_GetStart);
  g_IniConf.WriteBool('DBServer','AutoBackup',g_boDBServer_AutoBackup);
  g_IniConf.WriteBool('DBServer','BackupClearData',g_boDBServer_BackupClearData);
  g_IniConf.WriteInteger('DBServer','BackupTime',g_dwDBServer_BackupTime);
  g_IniConf.WriteString('DBServer','DBName',g_sDBServer_DBName);
  g_IniConf.WriteBool('DBServer','ShowItemName',g_boDBServer_ShowItemName);

  g_IniConf.WriteInteger('M2Server','MainFormX',g_nM2Server_MainFormX);
  g_IniConf.WriteInteger('M2Server','MainFormY',g_nM2Server_MainFormY);
  g_IniConf.WriteInteger('M2Server','TestLevel',g_nM2Server_TestLevel);
  g_IniConf.WriteInteger('M2Server','TestGold',g_nM2Server_TestGold);

  g_IniConf.WriteInteger('M2Server','GatePort',g_nM2Server_GatePort);
  g_IniConf.WriteInteger('M2Server','MsgSrvPort',g_nM2Server_MsgSrvPort);
  g_IniConf.WriteBool('M2Server','GetStart',g_boM2Server_GetStart);

  g_IniConf.WriteInteger('RunGate','GatePort1',g_nRunGate_GatePort);
  g_IniConf.WriteInteger('RunGate','GatePort2',g_nRunGate1_GatePort);
  g_IniConf.WriteInteger('RunGate','GatePort3',g_nRunGate2_GatePort);
  g_IniConf.WriteInteger('RunGate','GatePort4',g_nRunGate3_GatePort);
  g_IniConf.WriteInteger('RunGate','GatePort5',g_nRunGate4_GatePort);
  g_IniConf.WriteInteger('RunGate','GatePort6',g_nRunGate5_GatePort);
  g_IniConf.WriteInteger('RunGate','GatePort7',g_nRunGate6_GatePort);
  g_IniConf.WriteInteger('RunGate','GatePort8',g_nRunGate7_GatePort);

  g_IniConf.WriteInteger('LoginGate','MainFormX',g_nLoginGate_MainFormX);
  g_IniConf.WriteInteger('LoginGate','MainFormY',g_nLoginGate_MainFormY);
  g_IniConf.WriteBool('LoginGate','GetStart',g_boLoginGate_GetStart);
  g_IniConf.WriteInteger('LoginGate','GatePort',g_nLoginGate_GatePort);


  g_IniConf.WriteInteger('SelGate','MainFormX',g_nSelGate_MainFormX);
  g_IniConf.WriteInteger('SelGate','MainFormY',g_nSelGate_MainFormY);
  g_IniConf.WriteBool('SelGate','GetStart',g_boSelGate_GetStart);

  g_IniConf.WriteInteger('SelGate','GatePort',g_nSelGate_GatePort);
  g_IniConf.WriteInteger('SelGate','GatePort1',g_nSelGate_GatePort1);


  g_IniConf.WriteInteger('RunGate','Count',g_nRunGate_Count);

  g_IniConf.WriteInteger('LoginServer','MainFormX',g_nLoginServer_MainFormX);
  g_IniConf.WriteInteger('LoginServer','MainFormY',g_nLoginServer_MainFormY);
  g_IniConf.WriteString('LoginServer','GateAddr',g_sLoginServer_GateAddr);
  g_IniConf.WriteInteger('LoginServer','GatePort',g_nLoginServer_GatePort);
  g_IniConf.WriteString('LoginServer','ServerAddr',g_sLoginServer_ServerAddr);
  g_IniConf.WriteInteger('LoginServer','ServerPort',g_nLoginServer_ServerPort);
  g_IniConf.WriteString('LoginServer','MonAddr',g_sLoginServer_MonAddr);
  g_IniConf.WriteInteger('LoginServer','MonPort',g_nLoginServer_MonPort);
  g_IniConf.WriteBool('LoginServer','GetStart',g_boLoginServer_GetStart);

  g_IniConf.WriteBool('LoginServer','EnableGetbackPassword',g_boLoginServer_EnableGetbackPassword);
  g_IniConf.WriteBool('LoginServer','EnableMakingID',g_boLoginServer_EnableMakingID);
  g_IniConf.WriteBool('LoginServer','TestServer',g_boLoginServer_TestServer);
  g_IniConf.WriteBool('LoginServer','AutoClear',g_boLoginServer_AutoClear);
  g_IniConf.WriteInteger('LoginServer','AutoClearTime',g_dwLoginServer_AutoClearTime);
  g_IniConf.WriteInteger('LoginServer','ReadyServers',g_nLoginServer_ReadyServers);



  g_IniConf.WriteInteger('LogServer','MainFormX',g_nLogServer_MainFormX);
  g_IniConf.WriteInteger('LogServer','MainFormY',g_nLogServer_MainFormY);

  g_IniConf.WriteInteger('LogServer','Port',g_nLogServer_Port);
  g_IniConf.WriteBool('LogServer','GetStart',g_boLogServer_GetStart);


  Application.MessageBox('配置文件已经保存完毕...','提示信息',MB_OK + MB_ICONINFORMATION);
  if Application.MessageBox('是否生成新的游戏服务器配置文件...','提示信息',MB_YESNO + MB_ICONQUESTION) = mrYes then begin
    ButtonGenGameConfigClick(ButtonGenGameConfig);
  end;
  PageControl3.ActivePageIndex:=0;
  PageControl1.ActivePageIndex:=0;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  m_boOpen:=False;

  PageControl1.ActivePageIndex:=0;
  PageControl3.ActivePageIndex:=0;
  m_nStartStatus:=0;
  MemoLog.Clear;
  LoadConfig();
  if not StartService() then exit;
  RefGameConsole();
  TabSheetDebug.TabVisible:=False;
  if g_boShowDebugTab then begin
    TabSheetDebug.TabVisible:=True;
    TimerCheckDebug.Enabled:=True;
  end;
  m_boOpen:=True;
  MainOutMessage('游戏控制器启动成功...');
//  SetWindowPos(Self.Handle,HWND_TOPMOST,Self.Left,Self.Top,Self.Width,Self.Height,$40);
end;

procedure TfrmMain.ButtonGenGameConfigClick(Sender: TObject);
begin
//  ButtonGenGameConfig.Enabled:=False;
  GenGameConfig();
  RefGameConsole();
  Application.MessageBox('游戏配置文件已经生成完毕...','提示信息',MB_OK + MB_ICONINFORMATION);
end;
procedure TfrmMain.GenGameConfig;
begin
  GenDBServerConfig();
  GenLoginServerConfig();
  GenLogServerConfig();
  GenM2ServerConfig();
  GenLoginGateConfig();
  GenSelGateConfig();
  GenRunGateConfig();
end;
procedure TfrmMain.GenDBServerConfig;
ResourceString
  sRunGate1 = '%s %s %d';
  sRunGate2 = '%s %s %d %s %d';
  sRunGate3 = '%s %s %d %s %d %s %d';
  sRunGate4 = '%s %s %d %s %d %s %d %s %d';
  sRunGate5 = '%s %s %d %s %d %s %d %s %d %s %d';
  sRunGate6 = '%s %s %d %s %d %s %d %s %d %s %d %s %d';
  sRunGate7 = '%s %s %d %s %d %s %d %s %d %s %d %s %d %s %d';
  sRunGate8 = '%s %s %d %s %d %s %d %s %d %s %d %s %d %s %d %s %d';
var
  IniGameConf:TIniFile;
  sIniFile:String;
  SaveList:TStringList;
begin
  sIniFile:=g_sGameDirectory + g_sDBServer_Directory;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;

  IniGameConf:=TIniFile.Create(sIniFile + g_sDBServer_ConfigFile);

  IniGameConf.WriteString('Setup','ServerName',g_sGameName);
  IniGameConf.WriteString('Setup','ServerAddr',g_sDBServer_Config_ServerAddr);
  IniGameConf.WriteInteger('Setup','ServerPort',g_nDBServer_Config_ServerPort);
  IniGameConf.WriteString('Setup','MapFile',g_sDBServer_Config_MapFile);
  IniGameConf.WriteBool('Setup','ViewHackMsg',g_boDBServer_Config_ViewHackMsg);
  IniGameConf.WriteBool('Setup','DynamicIPMode',g_boDynamicIPMode);
  IniGameConf.WriteString('Setup','GateAddr',g_sDBServer_Config_GateAddr);
  IniGameConf.WriteInteger('Setup','GatePort',g_nDBServer_Config_GatePort);

  IniGameConf.WriteBool('Setup','BackupClearData',g_boDBServer_BackupClearData);
  IniGameConf.WriteString('Setup','DBName',g_sDBServer_DBName);
  IniGameConf.WriteBool('Setup','ShowItemName',g_boDBServer_ShowItemName);


  IniGameConf.WriteBool('Backup','AutoBackup',g_boDBServer_AutoBackup);
  IniGameConf.WriteInteger('Backup','BackupTime',g_dwDBServer_BackupTime);


  IniGameConf.WriteString('Server','IDSAddr',g_sLoginServer_ServerAddr);  //登录服务器IP
  IniGameConf.WriteInteger('Server','IDSPort',g_nLoginServer_ServerPort); //登录服务器端口


  IniGameConf.WriteInteger('DBClear','Interval',g_nDBServer_Config_Interval);
  IniGameConf.WriteInteger('DBClear','Level1',g_nDBServer_Config_Level1);
  IniGameConf.WriteInteger('DBClear','Level2',g_nDBServer_Config_Level2);
  IniGameConf.WriteInteger('DBClear','Level3',g_nDBServer_Config_Level3);
  IniGameConf.WriteInteger('DBClear','Day1',g_nDBServer_Config_Day1);
  IniGameConf.WriteInteger('DBClear','Day2',g_nDBServer_Config_Day2);
  IniGameConf.WriteInteger('DBClear','Day3',g_nDBServer_Config_Day3);
  IniGameConf.WriteInteger('DBClear','Month1',g_nDBServer_Config_Month1);
  IniGameConf.WriteInteger('DBClear','Month2',g_nDBServer_Config_Month2);
  IniGameConf.WriteInteger('DBClear','Month3',g_nDBServer_Config_Month3);

  IniGameConf.WriteString('DB','Dir',sIniFile + g_sDBServer_Config_Dir);
  IniGameConf.WriteString('DB','IdDir',sIniFile + g_sDBServer_Config_IdDir);
  IniGameConf.WriteString('DB','HumDir',sIniFile + g_sDBServer_Config_HumDir);
  IniGameConf.WriteString('DB','FeeDir',sIniFile + g_sDBServer_Config_FeeDir);
  IniGameConf.WriteString('DB','BackupDir',sIniFile + g_sDBServer_Config_BackupDir);
  IniGameConf.WriteString('DB','ConnectDir',sIniFile + g_sDBServer_Config_ConnectDir);
  IniGameConf.WriteString('DB','LogDir',sIniFile + g_sDBServer_Config_LogDir);
  IniGameConf.WriteString('DB','ClearLogDir',sIniFile + g_sDBServer_ClearLogDir);



  IniGameConf.Free;

  SaveList:=TStringList.Create;
  SaveList.Add(g_sLocalIPaddr);
  SaveList.Add(g_sExtIPaddr);
  SaveList.SaveToFile(sIniFile + g_sDBServer_AddrTableFile);

  SaveList.Clear;
  case g_nRunGate_Count of
    1: SaveList.Add(format(sRunGate1,[g_sLocalIPaddr,
                                      g_sExtIPaddr,g_nRunGate_GatePort]));
    2: SaveList.Add(format(sRunGate2,[g_sLocalIPaddr,
                                      g_sExtIPaddr,g_nRunGate_GatePort,
                                      g_sExtIPaddr,g_nRunGate1_GatePort]));
    3: SaveList.Add(format(sRunGate3,[g_sLocalIPaddr,
                                      g_sExtIPaddr,g_nRunGate_GatePort,
                                      g_sExtIPaddr,g_nRunGate1_GatePort,
                                      g_sExtIPaddr,g_nRunGate2_GatePort]));
    4: SaveList.Add(format(sRunGate4,[g_sLocalIPaddr,
                                      g_sExtIPaddr,g_nRunGate_GatePort,
                                      g_sExtIPaddr,g_nRunGate1_GatePort,
                                      g_sExtIPaddr,g_nRunGate2_GatePort,
                                      g_sExtIPaddr,g_nRunGate3_GatePort]));
    5: SaveList.Add(format(sRunGate5,[g_sLocalIPaddr,
                                      g_sExtIPaddr,g_nRunGate1_GatePort,
                                      g_sExtIPaddr,g_nRunGate2_GatePort,
                                      g_sExtIPaddr,g_nRunGate3_GatePort,
                                      g_sExtIPaddr,g_nRunGate4_GatePort]));
    6: SaveList.Add(format(sRunGate6,[g_sLocalIPaddr,
                                      g_sExtIPaddr,g_nRunGate_GatePort,
                                      g_sExtIPaddr,g_nRunGate1_GatePort,
                                      g_sExtIPaddr,g_nRunGate2_GatePort,
                                      g_sExtIPaddr,g_nRunGate3_GatePort,
                                      g_sExtIPaddr,g_nRunGate4_GatePort,
                                      g_sExtIPaddr,g_nRunGate5_GatePort]));
    7: SaveList.Add(format(sRunGate7,[g_sLocalIPaddr,
                                      g_sExtIPaddr,g_nRunGate_GatePort,
                                      g_sExtIPaddr,g_nRunGate1_GatePort,
                                      g_sExtIPaddr,g_nRunGate2_GatePort,
                                      g_sExtIPaddr,g_nRunGate3_GatePort,
                                      g_sExtIPaddr,g_nRunGate4_GatePort,
                                      g_sExtIPaddr,g_nRunGate5_GatePort,
                                      g_sExtIPaddr,g_nRunGate6_GatePort]));
    8: SaveList.Add(format(sRunGate8,[g_sLocalIPaddr,
                                      g_sExtIPaddr,g_nRunGate_GatePort,
                                      g_sExtIPaddr,g_nRunGate1_GatePort,
                                      g_sExtIPaddr,g_nRunGate2_GatePort,
                                      g_sExtIPaddr,g_nRunGate3_GatePort,
                                      g_sExtIPaddr,g_nRunGate4_GatePort,
                                      g_sExtIPaddr,g_nRunGate5_GatePort,
                                      g_sExtIPaddr,g_nRunGate6_GatePort,
                                      g_sExtIPaddr,g_nRunGate7_GatePort]));
  end;
//  if g_nRunGate_Count > 4 then
//    case g_nRunGate_Count of    
//      5: SaveList.Add(format('%s %s %d',[g_sExtIPaddr,g_sExtIPaddr,g_nRunGate4_GatePort]));
//      6: SaveList.Add(format('%s %s %d %s %d',[g_sExtIPaddr,g_sExtIPaddr,g_nRunGate4_GatePort,g_sExtIPaddr,g_nRunGate5_GatePort]));
//      7: SaveList.Add(format('%s %s %d %s %d %s %d',[g_sExtIPaddr,g_sExtIPaddr,g_nRunGate4_GatePort,g_sExtIPaddr,g_nRunGate5_GatePort,g_sExtIPaddr,g_nRunGate6_GatePort]));
//      8: SaveList.Add(format('%s %s %d %s %d %s %d %s %d',[g_sExtIPaddr,g_sExtIPaddr,g_nRunGate4_GatePort,g_sExtIPaddr,g_nRunGate5_GatePort,g_sExtIPaddr,g_nRunGate6_GatePort,g_sExtIPaddr,g_nRunGate7_GatePort]));
//    end;

  SaveList.SaveToFile(sIniFile + g_sDBServer_ServerinfoFile);
  SaveList.Free;

  sIniFile:=g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_Config_Dir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_Config_IdDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_Config_HumDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_Config_FeeDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_Config_BackupDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_Config_ConnectDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_Config_LogDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_ClearLogDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
end;

procedure TfrmMain.GenLoginServerConfig;
var
  IniGameConf:TIniFile;
  sIniFile:String;
  SaveList:TStringList;
begin
  sIniFile:=g_sGameDirectory + g_sLoginServer_Directory;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;

  IniGameConf:=TIniFile.Create(sIniFile + g_sLoginServer_ConfigFile);

  IniGameConf.WriteString('Server','GateAddr',g_sLoginServer_GateAddr);
  IniGameConf.WriteInteger('Server','GatePort',g_nLoginServer_GatePort);
  IniGameConf.WriteString('Server','ServerAddr',g_sLoginServer_ServerAddr);
  IniGameConf.WriteInteger('Server','ServerPort',g_nLoginServer_ServerPort);

  IniGameConf.WriteString('Server','MonAddr',g_sLoginServer_MonAddr);
  IniGameConf.WriteInteger('Server','MonPort',g_nLoginServer_MonPort);
  
  IniGameConf.WriteInteger('Server','ReadyServers',g_nLoginServer_ReadyServers);

  IniGameConf.WriteBool('Server','EnableMakingID',g_boLoginServer_EnableMakingID);
  IniGameConf.WriteBool('Server','EnableGetbackPassword',g_boLoginServer_EnableGetbackPassword);
  IniGameConf.WriteBool('Server','TestServer',g_boLoginServer_TestServer);
  IniGameConf.WriteBool('Server','DynamicIPMode',g_boDynamicIPMode);

  IniGameConf.WriteBool('Server','AutoClear',g_boLoginServer_AutoClear);
  IniGameConf.WriteInteger('Server','AutoClearTime',g_dwLoginServer_AutoClearTime);



  IniGameConf.WriteString('DB','IdDir',sIniFile + g_sLoginServer_IdDir);
  IniGameConf.WriteString('DB','FeedIDList',sIniFile + g_sLoginServer_FeedIDList);
  IniGameConf.WriteString('DB','FeedIPList',sIniFile + g_sLoginServer_FeedIPList);
  IniGameConf.WriteString('DB','CountLogDir',sIniFile + g_sLoginServer_CountLogDir);
  IniGameConf.WriteString('DB','WebLogDir',sIniFile + g_sLoginServer_WebLogDir);
  IniGameConf.WriteString('DB','ChrLogDir',sIniFile + g_sLoginServer_ChrLogDir);
  IniGameConf.WriteString('DB','IdLogDir',sIniFile + g_sLoginServer_IdLogDir);

  IniGameConf.Free;


  SaveList:=TStringList.Create;
//  if g_boRunGate4_GetStart then begin
//    SaveList.Add(format('%s %s %s %s %s:%d %s:%d',[g_sGameName,'Title1',g_sLocalIPaddr,g_sLocalIPaddr,g_sExtIPaddr,g_nSelGate_GatePort,g_sExtIPaddr,g_nSelGate_GatePort1]));
//  end else begin
//    SaveList.Add(format('%s %s %s %s %s:%d',[g_sGameName,'Title1',g_sLocalIPaddr,g_sLocalIPaddr,g_sExtIPaddr,g_nSelGate_GatePort]));
//  end;
  SaveList.Add(format('%s %s %s %s %s:%d',[g_sGameName,'Title1',g_sLocalIPaddr,g_sLocalIPaddr,g_sExtIPaddr,g_nSelGate_GatePort]));


  SaveList.SaveToFile(sIniFile + g_sLoginServer_AddrTableFile);

  SaveList.Clear;
  SaveList.Add(g_sLocalIPaddr);
  SaveList.SaveToFile(sIniFile + g_sLoginServer_ServeraddrFile);

  SaveList.Clear;
  SaveList.Add(format('%s %s %d',[g_sGameName,g_sGameName,g_nLimitOnlineUser]));
  SaveList.SaveToFile(sIniFile + g_sLoginServerUserLimitFile);
  SaveList.Free;

  sIniFile:=g_sGameDirectory + g_sLoginServer_Directory + g_sLoginServer_IdDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;

  sIniFile:=g_sGameDirectory + g_sLoginServer_Directory + g_sLoginServer_CountLogDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;

  sIniFile:=g_sGameDirectory + g_sLoginServer_Directory + g_sLoginServer_WebLogDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;

  sIniFile:=g_sGameDirectory + g_sLoginServer_Directory + g_sLoginServer_ChrLogDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;

  sIniFile:=g_sGameDirectory + g_sLoginServer_Directory + g_sLoginServer_IdLogDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
end;

procedure TfrmMain.GenLogServerConfig;
var
  IniGameConf:TIniFile;
  sIniFile:String;
begin
  sIniFile:=g_sGameDirectory + g_sLogServer_Directory;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;

  IniGameConf:=TIniFile.Create(sIniFile + g_sLogServer_ConfigFile);
  IniGameConf.WriteString('Setup','ServerName',g_sGameName);
  IniGameConf.WriteInteger('Setup','Port',g_nLogServer_Port);
  IniGameConf.WriteString('Setup','BaseDir',sIniFile + g_sLogServer_BaseDir);

  sIniFile:=sIniFile + g_sLogServer_BaseDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;  
  IniGameConf.Free;
end;

procedure TfrmMain.GenM2ServerConfig;
var
  IniGameConf:TIniFile;
  sIniFile:String;
  SaveList:TStringList;
begin
  sIniFile:=g_sGameDirectory + g_sM2Server_Directory;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;

  IniGameConf:=TIniFile.Create(sIniFile + g_sM2Server_ConfigFile);

  IniGameConf.WriteString('Server','ServerName',g_sGameName);
  IniGameConf.WriteInteger('Server','ServerNumber',g_nM2Server_ServerNumber);
  IniGameConf.WriteInteger('Server','ServerIndex',g_nM2Server_ServerIndex);

  IniGameConf.WriteString('Server','VentureServer',BoolToStr(g_boM2Server_VentureServer));
  IniGameConf.WriteString('Server','TestServer',BoolToStr(g_boM2Server_TestServer));
  IniGameConf.WriteInteger('Server','TestLevel',g_nM2Server_TestLevel);
  IniGameConf.WriteInteger('Server','TestGold',g_nM2Server_TestGold);
  IniGameConf.WriteInteger('Server','TestServerUserLimit',g_nLimitOnlineUser);
  IniGameConf.WriteString('Server','ServiceMode',BoolToStr(g_boM2Server_ServiceMode));
  IniGameConf.WriteString('Server','NonPKServer',BoolToStr(g_boM2Server_NonPKServer));

  IniGameConf.WriteString('Server','DBAddr',g_sDBServer_Config_ServerAddr);
  IniGameConf.WriteInteger('Server','DBPort',g_nDBServer_Config_ServerPort);
  IniGameConf.WriteString('Server','IDSAddr',g_sLoginServer_ServerAddr);
  IniGameConf.WriteInteger('Server','IDSPort',g_nLoginServer_ServerPort);
  IniGameConf.WriteString('Server','MsgSrvAddr',g_sM2Server_MsgSrvAddr);
  IniGameConf.WriteInteger('Server','MsgSrvPort',g_nM2Server_MsgSrvPort);
  IniGameConf.WriteString('Server','LogServerAddr',g_sLogServer_ServerAddr);
  IniGameConf.WriteInteger('Server','LogServerPort',g_nLogServer_Port);
  IniGameConf.WriteString('Server','GateAddr',g_sM2Server_GateAddr);
  IniGameConf.WriteInteger('Server','GatePort',g_nM2Server_GatePort);

  IniGameConf.WriteString('Server','DBName',g_sHeroDBName);


  IniGameConf.WriteInteger('Server','UserFull',g_nLimitOnlineUser);

  IniGameConf.WriteString('Share','BaseDir',sIniFile + g_sM2Server_BaseDir);
  IniGameConf.WriteString('Share','GuildDir',sIniFile + g_sM2Server_GuildDir);
  IniGameConf.WriteString('Share','GuildFile',sIniFile + g_sM2Server_GuildFile);
  IniGameConf.WriteString('Share','VentureDir',sIniFile + g_sM2Server_VentureDir);
  IniGameConf.WriteString('Share','ConLogDir',sIniFile + g_sM2Server_ConLogDir);
  IniGameConf.WriteString('Share','LogDir',sIniFile + g_sM2Server_LogDir);

  IniGameConf.WriteString('Share','CastleDir',sIniFile + g_sM2Server_CastleDir);
  IniGameConf.WriteString('Share','EnvirDir',sIniFile + g_sM2Server_EnvirDir);
  IniGameConf.WriteString('Share','MapDir',sIniFile + g_sM2Server_MapDir);
  IniGameConf.WriteString('Share','NoticeDir',sIniFile + g_sM2Server_NoticeDir);

  IniGameConf.Free;

  sIniFile:=g_sGameDirectory + g_sM2Server_Directory + g_sM2Server_BaseDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sM2Server_Directory + g_sM2Server_GuildDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sM2Server_Directory + g_sM2Server_VentureDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sM2Server_Directory + g_sM2Server_ConLogDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sM2Server_Directory + g_sM2Server_LogDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sM2Server_Directory + g_sM2Server_CastleDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sM2Server_Directory + g_sM2Server_EnvirDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sM2Server_Directory + g_sM2Server_MapDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  sIniFile:=g_sGameDirectory + g_sM2Server_Directory + g_sM2Server_NoticeDir;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;

  sIniFile:=g_sGameDirectory + g_sM2Server_Directory;
  SaveList:=TStringList.Create;
  SaveList.Add('GM');
  SaveList.SaveToFile(sIniFile + g_sM2Server_AbuseFile);

  SaveList.Clear;
  SaveList.Add(g_sLocalIPaddr);
  SaveList.SaveToFile(sIniFile + g_sM2Server_RunAddrFile);

  SaveList.Clear;
  SaveList.Add(g_sLocalIPaddr);
  SaveList.SaveToFile(sIniFile + g_sM2Server_ServerTableFile);
  SaveList.Free;
end;

procedure TfrmMain.GenLoginGateConfig;
var
  IniGameConf:TIniFile;
  sIniFile:String;
  SaveList:TStringList;
begin
  sIniFile:=g_sGameDirectory + g_sLoginGate_Directory;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  IniGameConf:=TIniFile.Create(sIniFile + g_sLoginGate_ConfigFile);
  IniGameConf.WriteString('LoginGate','Title',g_sGameName);
  IniGameConf.WriteString('LoginGate','ServerAddr',g_sLoginGate_ServerAddr);
  IniGameConf.WriteInteger('LoginGate','ServerPort',g_nLoginServer_GatePort{g_nLoginGate_ServerPort});
  IniGameConf.WriteString('LoginGate','GateAddr',g_sLoginGate_GateAddr);
  IniGameConf.WriteInteger('LoginGate','GatePort',g_nLoginGate_GatePort);
  IniGameConf.WriteInteger('LoginGate','ShowLogLevel',g_nLoginGate_ShowLogLevel);
  IniGameConf.WriteInteger('LoginGate','MaxConnOfIPaddr',g_nLoginGate_MaxConnOfIPaddr);
  IniGameConf.WriteInteger('LoginGate','BlockMethod',g_nLoginGate_BlockMethod);
  IniGameConf.WriteInteger('LoginGate','KeepConnectTimeOut',g_nLoginGate_KeepConnectTimeOut);
  IniGameConf.Free;
end;

procedure TfrmMain.GenSelGateConfig();
var
  IniGameConf:TIniFile;
  sIniFile:String;
  SaveList:TStringList;
begin
  sIniFile:=g_sGameDirectory + g_sSelGate_Directory;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  IniGameConf:=TIniFile.Create(sIniFile + g_sSelGate_ConfigFile);
  IniGameConf.WriteString('SelGate','Title',g_sGameName);
  IniGameConf.WriteString('SelGate','ServerAddr',g_sSelGate_ServerAddr);
  IniGameConf.WriteInteger('SelGate','ServerPort',g_nDBServer_Config_GatePort{g_nSelGate_ServerPort});
  IniGameConf.WriteString('SelGate','GateAddr',g_sSelGate_GateAddr);
  IniGameConf.WriteInteger('SelGate','GatePort',g_nSelGate_GatePort);
  IniGameConf.WriteInteger('SelGate','ShowLogLevel',g_nSelGate_ShowLogLevel);
  IniGameConf.WriteInteger('SelGate','MaxConnOfIPaddr',g_nSelGate_MaxConnOfIPaddr);
  IniGameConf.WriteInteger('SelGate','BlockMethod',g_nSelGate_BlockMethod);
  IniGameConf.WriteInteger('SelGate','KeepConnectTimeOut',g_nSelGate_KeepConnectTimeOut);
  IniGameConf.Free;
end;

procedure TfrmMain.GenMutSelGateConfig(nIndex: Integer);
var
  IniGameConf:TIniFile;
  sIniFile:String;
  SaveList:TStringList;
  sGateAddr:String;
  nGatePort:Integer;
  sServerAddr:String;
begin
  sIniFile:=g_sGameDirectory + g_sSelGate_Directory;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  case nIndex of    //
    0: begin
      sGateAddr:=g_sSelGate_GateAddr;
      nGatePort:=g_nSelGate_GatePort;
      sServerAddr:=g_sLocalIPaddr;
    end;
    1: begin
      sGateAddr:=g_sSelGate_GateAddr1;
      nGatePort:=g_nSelGate_GatePort1;
      sServerAddr:=g_sExtIPaddr;
    end;
  end;
  IniGameConf:=TIniFile.Create(sIniFile + g_sSelGate_ConfigFile);
  IniGameConf.WriteString('SelGate','Title',g_sGameName);
  IniGameConf.WriteString('SelGate','ServerAddr',sServerAddr{g_sSelGate_ServerAddr});
  IniGameConf.WriteInteger('SelGate','ServerPort',g_nSelGate_ServerPort);
  IniGameConf.WriteString('SelGate','GateAddr',sGateAddr);
  IniGameConf.WriteInteger('SelGate','GatePort',nGatePort);
  IniGameConf.WriteInteger('SelGate','ShowLogLevel',g_nSelGate_ShowLogLevel);
  IniGameConf.WriteInteger('SelGate','MaxConnOfIPaddr',g_nSelGate_MaxConnOfIPaddr);
  IniGameConf.WriteInteger('SelGate','BlockMethod',g_nSelGate_BlockMethod);
  IniGameConf.WriteInteger('SelGate','KeepConnectTimeOut',g_nSelGate_KeepConnectTimeOut);
  IniGameConf.Free;
end;

procedure TfrmMain.GenRunGateConfig;
var
  IniGameConf:TIniFile;
  sIniFile:String;
  SaveList:TStringList;
begin
  sIniFile:=g_sGameDirectory + g_sRunGate_Directory;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  IniGameConf:=TIniFile.Create(sIniFile + g_sRunGate_ConfigFile);
  IniGameConf.WriteString('GameGate','Title',g_sGameName + '(' + IntToStr(g_nRunGate_GatePort) + ')');
  IniGameConf.WriteInteger('GameGate','ServerPort',g_nM2Server_GatePort{g_nRunGate_ServerPort});
  IniGameConf.WriteString('GameGate','GateAddr',g_sRunGate_GateAddr);
  IniGameConf.WriteInteger('GameGate','GatePort',g_nRunGate_GatePort);

  IniGameConf.Free;
end;


procedure TfrmMain.RefGameConsole;
begin
  m_boOpen:=False;
  EditM2ServerProgram.Text:=g_sGameDirectory + g_sM2Server_Directory + g_sM2Server_ProgramFile;
  EditDBServerProgram.Text:=g_sGameDirectory + g_sDBServer_Directory + g_sDBServer_ProgramFile;
  EditDBServerGatePort.Text:=IntToStr(g_nDBServer_Config_GatePort);
  EditDBServerServerPort.Text:=IntToStr(g_nDBServer_Config_ServerPort);
  CheckBoxDBServerGetStart.Checked:=g_boDBServer_GetStart;

  EditLoginSrvProgram.Text:=g_sGameDirectory + g_sLoginServer_Directory + g_sLoginServer_ProgramFile;
  EditLogServerProgram.Text:=g_sGameDirectory + g_sLogServer_Directory + g_sLogServer_ProgramFile;
  EditLoginGateProgram.Text:=g_sGameDirectory + g_sLoginGate_Directory + g_sLoginGate_ProgramFile;
  EditSelGateProgram.Text:=g_sGameDirectory + g_sSelGate_Directory + g_sSelGate_ProgramFile;
  EditRunGateProgram.Text:=g_sGameDirectory + g_sRunGate_Directory + g_sRunGate_ProgramFile;
  EditRunGate1Program.Text:=g_sGameDirectory + g_sRunGate_Directory + g_sRunGate_ProgramFile;
  EditRunGate2Program.Text:=g_sGameDirectory + g_sRunGate_Directory + g_sRunGate_ProgramFile;

  CheckBoxM2Server.Checked:=g_boM2Server_GetStart;
  CheckBoxM2Server.Hint:=format('程序所在位置: %s%s%s',[g_sGameDirectory,g_sDBServer_Directory,g_sM2Server_ProgramFile]);
  CheckBoxDBServer.Checked:=g_boDBServer_GetStart;
  CheckBoxDBServer.Hint:=format('程序所在位置: %s%s%s',[g_sGameDirectory,g_sDBServer_Directory,g_sDBServer_ProgramFile]);
  CheckBoxLoginServer.Checked:=g_boLoginServer_GetStart;
  CheckBoxLoginServer.Hint:=format('程序所在位置: %s%s%s',[g_sGameDirectory,g_sDBServer_Directory,g_sLoginServer_ProgramFile]);
  CheckBoxLogServer.Checked:=g_boLogServer_GetStart;
  CheckBoxLogServer.Hint:=format('程序所在位置: %s%s%s',[g_sGameDirectory,g_sDBServer_Directory,g_sLogServer_ProgramFile]);
  CheckBoxLoginGate.Checked:=g_boLoginGate_GetStart;
  CheckBoxLoginGate.Hint:=format('程序所在位置: %s%s%s',[g_sGameDirectory,g_sDBServer_Directory,g_sLoginGate_ProgramFile]);
  CheckBoxSelGate.Checked:=g_boSelGate_GetStart;
  CheckBoxSelGate.Hint:=format('程序所在位置: %s%s%s',[g_sGameDirectory,g_sDBServer_Directory,g_sSelGate_ProgramFile]);
  CheckBoxRunGate.Checked:=g_boRunGate_GetStart;
  CheckBoxRunGate.Hint:=format('程序所在位置: %s%s%s',[g_sGameDirectory,g_sDBServer_Directory,g_sRunGate_ProgramFile]);
  CheckBoxRunGate1.Checked:=g_boRunGate1_GetStart;
  CheckBoxRunGate1.Hint:=format('程序所在位置: %s%s%s',[g_sGameDirectory,g_sDBServer_Directory,g_sRunGate_ProgramFile]);
  CheckBoxRunGate2.Checked:=g_boRunGate2_GetStart;
  CheckBoxRunGate2.Hint:=format('程序所在位置: %s%s%s',[g_sGameDirectory,g_sDBServer_Directory,g_sRunGate_ProgramFile]);

  EditGameDir.Text:=g_sGameDirectory;
  EditHeroDB.Text:=g_sHeroDBName;
  EditGameName.Text:=g_sGameName;
  EditGameExtIPaddr.Text:=g_sExtIPaddr;
  CheckBoxDynamicIPMode.Checked:=g_boDynamicIPMode;
  EditGameExtIPaddr.Enabled:=not g_boDynamicIPMode;

  EditLoginGate_MainFormX.Value:=g_nLoginGate_MainFormX;
  EditLoginGate_MainFormY.Value:=g_nLoginGate_MainFormY;
  CheckBoxboLoginGate_GetStart.Checked:=g_boLoginGate_GetStart;
  EditLoginGate_GatePort.Text:=IntToStr(g_nLoginGate_GatePort);

  EditSelGate_MainFormX.Value:=g_nSelGate_MainFormX;
  EditSelGate_MainFormY.Value:=g_nSelGate_MainFormY;
  CheckBoxboSelGate_GetStart.Checked:=g_boSelGate_GetStart;
  EditSelGate_GatePort.Text:=IntToStr(g_nSelGate_GatePort);
  EditSelGate_GatePort1.Text:=IntToStr(g_nSelGate_GatePort1);

  EditRunGate_Connt.Value:=g_nRunGate_Count;
  EditRunGate_GatePort1.Text:=IntToStr(g_nRunGate_GatePort);
  EditRunGate_GatePort2.Text:=IntToStr(g_nRunGate1_GatePort);
  EditRunGate_GatePort3.Text:=IntToStr(g_nRunGate2_GatePort);
  EditRunGate_GatePort4.Text:=IntToStr(g_nRunGate3_GatePort);
  EditRunGate_GatePort5.Text:=IntToStr(g_nRunGate4_GatePort);
  EditRunGate_GatePort6.Text:=IntToStr(g_nRunGate5_GatePort);
  EditRunGate_GatePort7.Text:=IntToStr(g_nRunGate6_GatePort);
  EditRunGate_GatePort8.Text:=IntToStr(g_nRunGate7_GatePort);

  EditLoginServer_MainFormX.Value:=g_nLoginServer_MainFormX;
  EditLoginServer_MainFormY.Value:=g_nLoginServer_MainFormY;
  EditLoginServerGatePort.Text:=IntToStr(g_nLoginServer_GatePort);
  EditLoginServerServerPort.Text:=IntToStr(g_nLoginServer_ServerPort);
  CheckBoxboLoginServer_GetStart.Checked:=g_boLoginServer_GetStart;


  EditDBServer_MainFormX.Value:=g_nDBServer_MainFormX;
  EditDBServer_MainFormY.Value:=g_nDBServer_MainFormY;
  CheckBoxAutoBackupHumData.Checked:=g_boDBServer_AutoBackup;
  EditBackupTime.Value:=g_dwDBServer_BackupTime div (60 * 1000);
  
  EditLogServer_MainFormX.Value:=g_nLogServer_MainFormX;
  EditLogServer_MainFormY.Value:=g_nLogServer_MainFormY;
  EditLogServerPort.Text:=IntToStr(g_nLogServer_Port);
  CheckBoxLogServerGetStart.Checked:=g_boLogServer_GetStart;

  EditM2Server_MainFormX.Value:=g_nM2Server_MainFormX;
  EditM2Server_MainFormY.Value:=g_nM2Server_MainFormY;
  EditM2Server_TestLevel.Value:=g_nM2Server_TestLevel;
  EditM2Server_TestGold.Value:=g_nM2Server_TestGold;
  EditM2ServerGatePort.Text:=IntToStr(g_nM2Server_GatePort);
  EditM2ServerMsgSrvPort.Text:=IntToStr(g_nM2Server_MsgSrvPort);

  CheckBoxM2ServerGetStart.Checked:=g_boM2Server_GetStart;

  m_boOpen:=True;
end;
procedure TfrmMain.CheckBoxDBServerClick(Sender: TObject);
begin
  g_boDBServer_GetStart:=CheckBoxDBServer.Checked;
end;

procedure TfrmMain.CheckBoxLoginServerClick(Sender: TObject);
begin
  g_boLoginServer_GetStart:=CheckBoxLoginServer.Checked;
end;

procedure TfrmMain.CheckBoxM2ServerClick(Sender: TObject);
begin
  g_boM2Server_GetStart:=CheckBoxM2Server.Checked;
end;

procedure TfrmMain.CheckBoxLogServerClick(Sender: TObject);
begin
  g_boLogServer_GetStart:=CheckBoxLogServer.Checked;
end;

procedure TfrmMain.CheckBoxLoginGateClick(Sender: TObject);
begin
  g_boLoginGate_GetStart:=CheckBoxLoginGate.Checked;
end;

procedure TfrmMain.CheckBoxSelGateClick(Sender: TObject);
begin
  g_boSelGate_GetStart:=CheckBoxSelGate.Checked;
end;

procedure TfrmMain.CheckBoxRunGateClick(Sender: TObject);
begin
  g_boRunGate_GetStart:=CheckBoxRunGate.Checked;
end;

procedure TfrmMain.CheckBoxRunGate1Click(Sender: TObject);
begin
  g_boRunGate1_GetStart:=CheckBoxRunGate1.Checked;
end;

procedure TfrmMain.CheckBoxRunGate2Click(Sender: TObject);
begin
  g_boRunGate2_GetStart:=CheckBoxRunGate2.Checked;
end;
procedure TfrmMain.ButtonStartGameClick(Sender: TObject);
begin
  SetWindowPos(Self.Handle,Self.Handle,Self.Left,Self.Top,Self.Width,Self.Height,$40);
  case m_nStartStatus of
    0: begin
      if Application.MessageBox('是否确认启动游戏服务器 ?','确认信息',MB_YESNO + MB_ICONQUESTION) = mrYes then begin
        StartGame();
      end;
    end;
    1: begin
      if Application.MessageBox('是否确认中止启动游戏服务器 ?','确认信息',MB_YESNO + MB_ICONQUESTION) = mrYes then begin
        TimerStartGame.Enabled:=False;
        m_nStartStatus:=2;
        ButtonStartGame.Caption:=g_sButtonStopGame;
        Exit;
      end;
    end;
    2: begin
      if Application.MessageBox('是否确认停止游戏服务器 ?','确认信息',MB_YESNO + MB_ICONQUESTION) = mrYes then begin
        StopGame();
      end;
    end;
    3: begin
      if Application.MessageBox('是否确认中止启动游戏服务器 ?','确认信息',MB_YESNO + MB_ICONQUESTION) = mrYes then begin
        TimerStopGame.Enabled:=False;
        m_nStartStatus:=2;
        ButtonStartGame.Caption:=g_sButtonStopGame;
      end;
    end;
  end;
  {
  if CreateProcess(nil,
                   PChar(sProgamFile),
                   nil,
                   nil,
                   False,
                   IDLE_PRIORITY_CLASS,
                   nil,
                   nil,
                   StartUpInfo,
                   ProcessInfo) then begin
  }
end;

procedure TfrmMain.StartGame;
var
  nRetCode:Integer;
begin
  FillChar(DBServer,SizeOf(TProgram),#0);
  DBServer.boGetStart:=g_boDBServer_GetStart;
  DBServer.boReStart:=True;
  DBServer.sDirectory:=g_sGameDirectory + g_sDBServer_Directory;
  DBServer.sProgramFile:=g_sDBServer_ProgramFile;
  DBServer.nMainFormX:=g_nDBServer_MainFormX;
  DBServer.nMainFormY:=g_nDBServer_MainFormY;  

  FillChar(LoginServer,SizeOf(TProgram),#0);
  LoginServer.boGetStart:=g_boLoginServer_GetStart;
  LoginServer.boReStart:=True;
  LoginServer.sDirectory:=g_sGameDirectory + g_sLoginServer_Directory;
  LoginServer.sProgramFile:=g_sLoginServer_ProgramFile;
  LoginServer.nMainFormX:=g_nLoginServer_MainFormX;
  LoginServer.nMainFormY:=g_nLoginServer_MainFormY;  

  FillChar(LogServer,SizeOf(TProgram),#0);
  LogServer.boGetStart:=g_boLogServer_GetStart;
  LogServer.boReStart:=True;
  LogServer.sDirectory:=g_sGameDirectory + g_sLogServer_Directory;
  LogServer.sProgramFile:=g_sLogServer_ProgramFile;
  LogServer.nMainFormX:=g_nLogServer_MainFormX;
  LogServer.nMainFormY:=g_nLogServer_MainFormY;

  FillChar(M2Server,SizeOf(TProgram),#0);
  M2Server.boGetStart:=g_boM2Server_GetStart;
  M2Server.boReStart:=True;
  M2Server.sDirectory:=g_sGameDirectory + g_sM2Server_Directory;
  M2Server.sProgramFile:=g_sM2Server_ProgramFile;
  M2Server.nMainFormX:=g_nM2Server_MainFormX;
  M2Server.nMainFormY:=g_nM2Server_MainFormY;

  FillChar(RunGate,SizeOf(TProgram),#0);
  RunGate.boGetStart:=g_boRunGate_GetStart;
  RunGate.boReStart:=True;
  RunGate.sDirectory:=g_sGameDirectory + g_sRunGate_Directory;
  RunGate.sProgramFile:=g_sRunGate_ProgramFile;

  FillChar(RunGate1,SizeOf(TProgram),#0);
  RunGate1.boGetStart:=g_boRunGate1_GetStart;


  RunGate1.boReStart:=True;
  RunGate1.sDirectory:=g_sGameDirectory + g_sRunGate_Directory;
  RunGate1.sProgramFile:=g_sRunGate_ProgramFile;

  FillChar(RunGate2,SizeOf(TProgram),#0);
  RunGate2.boGetStart:=g_boRunGate2_GetStart;

  RunGate2.boReStart:=True;
  RunGate2.sDirectory:=g_sGameDirectory + g_sRunGate_Directory;
  RunGate2.sProgramFile:=g_sRunGate_ProgramFile;

  FillChar(RunGate3,SizeOf(TProgram),#0);
  RunGate3.boGetStart:=g_boRunGate3_GetStart;

  RunGate3.boReStart:=True;
  RunGate3.sDirectory:=g_sGameDirectory + g_sRunGate_Directory;
  RunGate3.sProgramFile:=g_sRunGate_ProgramFile;

  FillChar(RunGate4,SizeOf(TProgram),#0);
  RunGate4.boGetStart:=g_boRunGate4_GetStart;

  RunGate4.boReStart:=True;
  RunGate4.sDirectory:=g_sGameDirectory + g_sRunGate_Directory;
  RunGate4.sProgramFile:=g_sRunGate_ProgramFile;

  FillChar(RunGate5,SizeOf(TProgram),#0);
  RunGate5.boGetStart:=g_boRunGate5_GetStart;

  RunGate5.boReStart:=True;
  RunGate5.sDirectory:=g_sGameDirectory + g_sRunGate_Directory;
  RunGate5.sProgramFile:=g_sRunGate_ProgramFile;

  FillChar(RunGate6,SizeOf(TProgram),#0);
  RunGate6.boGetStart:=g_boRunGate6_GetStart;

  RunGate6.boReStart:=True;
  RunGate6.sDirectory:=g_sGameDirectory + g_sRunGate_Directory;
  RunGate6.sProgramFile:=g_sRunGate_ProgramFile;

  FillChar(RunGate7,SizeOf(TProgram),#0);
  RunGate7.boGetStart:=g_boRunGate7_GetStart;

  RunGate7.boReStart:=True;
  RunGate7.sDirectory:=g_sGameDirectory + g_sRunGate_Directory;
  RunGate7.sProgramFile:=g_sRunGate_ProgramFile;          

  FillChar(SelGate,SizeOf(TProgram),#0);
  SelGate.boGetStart:=g_boSelGate_GetStart;
  SelGate.boReStart:=True;
  SelGate.sDirectory:=g_sGameDirectory + g_sSelGate_Directory;
  SelGate.sProgramFile:=g_sSelGate_ProgramFile;
  SelGate.nMainFormX:=g_nSelGate_MainFormX;
  SelGate.nMainFormY:=g_nSelGate_MainFormY;

  FillChar(SelGate1,SizeOf(TProgram),#0);
//  if g_boRunGate4_GetStart then begin //如果设置了4开游戏网关以上则打开第二个角色网关
//    SelGate1.boGetStart:=g_boSelGate_GetStart;
//  end else SelGate1.boGetStart:=False;

  SelGate1.boReStart:=True;
  SelGate1.sDirectory:=g_sGameDirectory + g_sSelGate_Directory;
  SelGate1.sProgramFile:=g_sSelGate_ProgramFile;
  SelGate1.nMainFormX:=g_nSelGate_MainFormX;
  SelGate1.nMainFormY:=g_nSelGate_MainFormY;


  FillChar(LoginGate,SizeOf(TProgram),#0);
  LoginGate.boGetStart:=g_boLoginGate_GetStart;
  LoginGate.boReStart:=True;
  LoginGate.sDirectory:=g_sGameDirectory + g_sLoginGate_Directory;
  LoginGate.sProgramFile:=g_sLoginGate_ProgramFile;
  LoginGate.nMainFormX:=g_nLoginGate_MainFormX;
  LoginGate.nMainFormY:=g_nLoginGate_MainFormY;

  ButtonStartGame.Caption:=g_sButtonStopStartGame;
  m_nStartStatus:=1;
  TimerStartGame.Enabled:=True;
end;

procedure TfrmMain.StopGame;
begin
  ButtonStartGame.Caption:=g_sButtonStopStopGame;
  MainOutMessage('正在开始停止服务器...');
  TimerCheckRun.Enabled:=False;
  TimerStopGame.Enabled:=True;
  m_nStartStatus:=3;

end;

procedure TfrmMain.TimerStartGameTimer(Sender: TObject);
var
  nRetCode:Integer;
begin
  if DBServer.boGetStart then begin
    case DBServer.btStartStatus of    //
      0: begin
        nRetCode:=RunProgram(DBServer,IntToStr(Self.Handle),0);
        if nRetCode = 0 then begin
        DBServer.btStartStatus:=2;    //1
          DBServer.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,DBServer.ProcessInfo.dwProcessId);
        end else begin
         DBServer.btStartStatus:=9;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
//        DBServer.btStartStatus:=2;
      exit;
      end;
    end;
  end;
  if LoginServer.boGetStart then begin
    case LoginServer.btStartStatus of    //
    0: begin
        nRetCode:=RunProgram(LoginServer,IntToStr(Self.Handle),0);
        if nRetCode = 0 then begin
          LoginServer.btStartStatus:=1;
          LoginServer.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,LoginServer.ProcessInfo.dwProcessId);
        end else begin
          LoginServer.btStartStatus:=9;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
  //      LoginServer.btStartStatus:=2;
        exit;
      end;
    end;
  end;

  if LogServer.boGetStart then begin
    case LogServer.btStartStatus of    //
      0: begin
        nRetCode:=RunProgram(LogServer,IntToStr(Self.Handle),0);
        if nRetCode = 0 then begin
          LogServer.btStartStatus:=1;
          LogServer.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,LogServer.ProcessInfo.dwProcessId);
        end else begin
          LogServer.btStartStatus:=9;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
  //      LogServer.btStartStatus:=2;
        exit;
      end;
    end;
  end;

  if M2Server.boGetStart then begin
    case M2Server.btStartStatus of    //
      0: begin
        nRetCode:=RunProgram(M2Server,IntToStr(Self.Handle),0);
        if nRetCode = 0 then begin
          M2Server.btStartStatus:=1;
          M2Server.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,M2Server.ProcessInfo.dwProcessId);
        end else begin
          M2Server.btStartStatus:=9;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
   //     M2Server.btStartStatus:=2;
        exit;
      end;
    end;
  end;

  if RunGate.boGetStart then begin
    case RunGate.btStartStatus of    //
      0: begin
        GetMutRunGateConfing(0);
        nRetCode:=RunProgram(RunGate,IntToStr(Self.Handle),2000);
        if nRetCode = 0 then begin
          RunGate.btStartStatus:=2;
          RunGate.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,RunGate.ProcessInfo.dwProcessId);
        end else begin
          RunGate.btStartStatus:=1;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
 //       RunGate.btStartStatus:=2;
       exit;
      end;
    end;
  end;

  if RunGate1.boGetStart then begin
    case RunGate1.btStartStatus of    //
      0: begin
        GetMutRunGateConfing(1);
        nRetCode:=RunProgram(RunGate1,IntToStr(Self.Handle),2000);
        if nRetCode = 0 then begin
          RunGate1.btStartStatus:=2;
          RunGate1.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,RunGate1.ProcessInfo.dwProcessId);
        end else begin
          RunGate1.btStartStatus:=9;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
   //     RunGate1.btStartStatus:=2;
       exit;
      end;
    end;
  end;

  if RunGate2.boGetStart then begin
    case RunGate2.btStartStatus of    //
      0: begin
        GetMutRunGateConfing(2);
        nRetCode:=RunProgram(RunGate2,IntToStr(Self.Handle),2000);
        if nRetCode = 0 then begin
          RunGate2.btStartStatus:=2;
          RunGate2.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,RunGate2.ProcessInfo.dwProcessId);
        end else begin
          RunGate2.btStartStatus:=9;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
 //       RunGate2.btStartStatus:=2;
        exit;
      end;
    end;
  end;

  if RunGate3.boGetStart then begin
    case RunGate3.btStartStatus of    //
      0: begin
        GetMutRunGateConfing(3);
        nRetCode:=RunProgram(RunGate3,IntToStr(Self.Handle),2000);
        if nRetCode = 0 then begin
          RunGate3.btStartStatus:=1;
          RunGate3.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,RunGate3.ProcessInfo.dwProcessId);
        end else begin
          RunGate3.btStartStatus:=9;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
  //      RunGate3.btStartStatus:=2;
        exit;
      end;
    end;
  end;

  if RunGate4.boGetStart then begin
    case RunGate4.btStartStatus of    //
      0: begin
        GetMutRunGateConfing(4);
        nRetCode:=RunProgram(RunGate4,IntToStr(Self.Handle),2000);
        if nRetCode = 0 then begin
          RunGate4.btStartStatus:=1;
          RunGate4.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,RunGate4.ProcessInfo.dwProcessId);
        end else begin
          RunGate4.btStartStatus:=9;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
   //     RunGate4.btStartStatus:=2;
        exit;
      end;
    end;
  end;

  if RunGate5.boGetStart then begin
    case RunGate5.btStartStatus of    //
      0: begin
        GetMutRunGateConfing(5);
        nRetCode:=RunProgram(RunGate5,IntToStr(Self.Handle),2000);
        if nRetCode = 0 then begin
          RunGate5.btStartStatus:=1;
          RunGate5.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,RunGate5.ProcessInfo.dwProcessId);
        end else begin
          RunGate5.btStartStatus:=9;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
 //       RunGate5.btStartStatus:=2;
        exit;
      end;
    end;
  end;

  if RunGate6.boGetStart then begin
    case RunGate6.btStartStatus of
      0: begin
        GetMutRunGateConfing(6);
        nRetCode:=RunProgram(RunGate6,IntToStr(Self.Handle),2000);
        if nRetCode = 0 then begin
          RunGate6.btStartStatus:=1;
          RunGate6.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,RunGate6.ProcessInfo.dwProcessId);
        end else begin
          RunGate6.btStartStatus:=9;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
 //       RunGate6.btStartStatus:=2;
        exit;
      end;
    end;
  end;

  if RunGate7.boGetStart then begin
    case RunGate7.btStartStatus of    //
      0: begin
        GetMutRunGateConfing(7);
        nRetCode:=RunProgram(RunGate7,IntToStr(Self.Handle),2000);
        if nRetCode = 0 then begin
          RunGate7.btStartStatus:=1;
          RunGate7.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,RunGate7.ProcessInfo.dwProcessId);
        end else begin
          RunGate7.btStartStatus:=9;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
 //       RunGate7.btStartStatus:=2;
        exit;
      end;
    end;
  end;

  if SelGate.boGetStart then begin
    case SelGate.btStartStatus of    //
      0: begin
        if SelGate1.boGetStart then GenMutSelGateConfig(0);
        nRetCode:=RunProgram(SelGate,IntToStr(Self.Handle),0);
        if nRetCode = 0 then begin
          SelGate.btStartStatus:=2;
          SelGate.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,SelGate.ProcessInfo.dwProcessId);
        end else begin
          SelGate.btStartStatus:=1;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
     //  SelGate.btStartStatus:=2;
        exit;
      end;
    end;
  end;

  if SelGate1.boGetStart then begin
    case SelGate1.btStartStatus of    //
      0: begin
        GenMutSelGateConfig(1);
        nRetCode:=RunProgram(SelGate1,IntToStr(Self.Handle),0);
        if nRetCode = 0 then begin
          SelGate1.btStartStatus:=1;
          SelGate1.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,SelGate1.ProcessInfo.dwProcessId);
        end else begin
         SelGate1.btStartStatus:=9;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
   //     SelGate1.btStartStatus:=2;
        exit;
      end;
    end;
  end;

  if LoginGate.boGetStart then begin
    case LoginGate.btStartStatus of    //
      0: begin
        nRetCode:=RunProgram(LoginGate,IntToStr(Self.Handle),0);
        if nRetCode = 0 then begin
          LoginGate.btStartStatus:=1;       //1
          LoginGate.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,LoginGate.ProcessInfo.dwProcessId);
        end else begin
        LoginGate.btStartStatus:=9;
          ShowMessage(IntToStr(nRetCode));
        end;
        exit;
      end;
      1: begin  //如果状态为1 则还没启动完成
     //  LoginGate.btStartStatus:=2;
        exit;
      end;
    end;
  end;

 TimerStartGame.Enabled:=False;
  TimerCheckRun.Enabled:=True;
 ButtonStartGame.Caption:=g_sButtonStopGame;
 // ButtonStartGame.Enabled:=True;
  m_nStartStatus:=2;
 SetWindowPos(Self.Handle,HWND_TOPMOST,Self.Left,Self.Top,Self.Width,Self.Height,$40);
end;

procedure TfrmMain.TimerStopGameTimer(Sender: TObject);
var
  dwExitCode:LongWord;
  nRetCode:Integer;
begin
  if LoginGate.boGetStart and (LoginGate.btStartStatus in [2,3]) then begin
    GetExitCodeProcess(LoginGate.ProcessHandle,dwExitCode);
    if dwExitCode = STILL_ACTIVE then begin
      if LoginGate.btStartStatus = 3 then begin
        if GetTickCount - g_dwStopTick > g_dwStopTimeOut then begin
          StopProgram(LoginGate,0);
          MainOutMessage('正常关闭超时，登录网关已被强行停止...');
        end;
        exit; //如果正在关闭则等待，不处理下面
      end;
   //   SendProgramMsg(LoginGate.MainFormHandle,GS_QUIT,'');
      g_dwStopTick:=GetTickCount();
      LoginGate.btStartStatus := 3;//
      exit;
    end else begin
      CloseHandle(LoginGate.ProcessHandle);
      LoginGate.btStartStatus:=0;
      MainOutMessage('登录网关已停止...');
    end;
  end;

  if SelGate.boGetStart and (SelGate.btStartStatus in [2,3]) then begin
    GetExitCodeProcess(SelGate.ProcessHandle,dwExitCode);
    if dwExitCode = STILL_ACTIVE then begin
      if SelGate.btStartStatus = 3 then begin   //3
        if GetTickCount - g_dwStopTick > g_dwStopTimeOut then begin
          StopProgram(SelGate,0);
          MainOutMessage('正常关闭超时，角色网关已被强行停止...');
        end;
        exit; //如果正在关闭则等待，不处理下面
      end;
      SendProgramMsg(SelGate.MainFormHandle,GS_QUIT,'');
      g_dwStopTick:=GetTickCount();
      SelGate.btStartStatus := 3; //
      exit;
    end else begin
      CloseHandle(SelGate.ProcessHandle);
      SelGate.btStartStatus:=0;
      MainOutMessage('角色网关已停止...');
    end;
  end;

  if RunGate.boGetStart and (RunGate.btStartStatus in [2,3]) then begin
    GetExitCodeProcess(RunGate.ProcessHandle,dwExitCode);
    if dwExitCode = STILL_ACTIVE then begin
      nRetCode:=StopProgram(RunGate,2000);
      if nRetCode = 0 then begin
        CloseHandle(RunGate.ProcessHandle);
        RunGate.btStartStatus:=0;
        MainOutMessage('游戏网关一已停止...');
      end;
    end;
  end;

  if RunGate1.boGetStart and (RunGate1.btStartStatus in [2,3]) then begin
    GetExitCodeProcess(RunGate1.ProcessHandle,dwExitCode);
    if dwExitCode = STILL_ACTIVE then begin
      nRetCode:=StopProgram(RunGate1,2000);
      if nRetCode = 0 then begin
        CloseHandle(RunGate1.ProcessHandle);
        RunGate1.btStartStatus:=0;
        MainOutMessage('游戏网关二已停止...');
      end;
    end;
  end;

  if RunGate2.boGetStart and (RunGate2.btStartStatus in [2,3]) then begin
    GetExitCodeProcess(RunGate2.ProcessHandle,dwExitCode);
    if dwExitCode = STILL_ACTIVE then begin
      nRetCode:=StopProgram(RunGate2,2000);
      if nRetCode = 0 then begin
        CloseHandle(RunGate2.ProcessHandle);
        RunGate2.btStartStatus:=0;
        MainOutMessage('游戏网关三已停止...');
      end;
    end;
  end;
  if RunGate3.boGetStart and (RunGate3.btStartStatus in [2,3]) then begin
    GetExitCodeProcess(RunGate3.ProcessHandle,dwExitCode);
    if dwExitCode = STILL_ACTIVE then begin
      nRetCode:=StopProgram(RunGate3,2000);
      if nRetCode = 0 then begin
        CloseHandle(RunGate3.ProcessHandle);
        RunGate3.btStartStatus:=0;
        MainOutMessage('游戏网关四已停止...');
      end;
    end;
  end;

  if RunGate4.boGetStart and (RunGate4.btStartStatus in [2,3]) then begin
    GetExitCodeProcess(RunGate4.ProcessHandle,dwExitCode);
    if dwExitCode = STILL_ACTIVE then begin
      nRetCode:=StopProgram(RunGate4,2000);
      if nRetCode = 0 then begin
        CloseHandle(RunGate4.ProcessHandle);
        RunGate4.btStartStatus:=0;
        MainOutMessage('游戏网关五已停止...');
      end;
    end;
  end;

  if RunGate5.boGetStart and (RunGate5.btStartStatus in [2,3]) then begin
    GetExitCodeProcess(RunGate5.ProcessHandle,dwExitCode);
    if dwExitCode = STILL_ACTIVE then begin
      nRetCode:=StopProgram(RunGate5,2000);
      if nRetCode = 0 then begin
        CloseHandle(RunGate5.ProcessHandle);
        RunGate5.btStartStatus:=0;
        MainOutMessage('游戏网关六已停止...');
      end;
    end;
  end;

  if RunGate6.boGetStart and (RunGate6.btStartStatus in [2,3]) then begin
    GetExitCodeProcess(RunGate6.ProcessHandle,dwExitCode);
    if dwExitCode = STILL_ACTIVE then begin
      nRetCode:=StopProgram(RunGate6,2000);
      if nRetCode = 0 then begin
        CloseHandle(RunGate6.ProcessHandle);
        RunGate6.btStartStatus:=0;
        MainOutMessage('游戏网关七已停止...');
      end;
    end;
  end;

  if RunGate7.boGetStart and (RunGate7.btStartStatus in [2,3]) then begin
    GetExitCodeProcess(RunGate7.ProcessHandle,dwExitCode);
    if dwExitCode = STILL_ACTIVE then begin
      nRetCode:=StopProgram(RunGate7,2000);
      if nRetCode = 0 then begin
        CloseHandle(RunGate7.ProcessHandle);
        RunGate7.btStartStatus:=0;
        MainOutMessage('游戏网关八已停止...');
      end;
    end;
  end;

  if M2Server.boGetStart and (M2Server.btStartStatus in [2,3]) then begin
    GetExitCodeProcess(M2Server.ProcessHandle,dwExitCode);
    if dwExitCode = STILL_ACTIVE then begin
      if M2Server.btStartStatus = 3 then begin
        if GetTickCount - g_dwStopTick > g_dwStopTimeOut then begin
          StopProgram(M2Server,1000);
          MainOutMessage('正常关闭超时，游戏引擎主程序已被强行停止...');
        end;
        exit; //如果正在关闭则等待，不处理下面
      end;
      SendProgramMsg(M2Server.MainFormHandle,GS_QUIT,'');
      g_dwStopTick:=GetTickCount();
      M2Server.btStartStatus := 3;
      exit;
    end else begin
      CloseHandle(M2Server.ProcessHandle);
      M2Server.btStartStatus:=0;
      MainOutMessage('游戏引擎主程序已停止...');
    end;
  end;

  if LoginServer.boGetStart and (LoginServer.btStartStatus in [2,3]) then begin
    GetExitCodeProcess(LoginServer.ProcessHandle,dwExitCode);
    if dwExitCode = STILL_ACTIVE then begin
      if LoginServer.btStartStatus = 3 then begin
        if GetTickCount - g_dwStopTick > g_dwStopTimeOut then begin
          StopProgram(LoginServer,0);
          MainOutMessage('正常关闭超时，游戏引擎主程序已被强行停止...');
        end;
        exit; //如果正在关闭则等待，不处理下面
      end;
      SendProgramMsg(LoginServer.MainFormHandle,GS_QUIT,'');
      g_dwStopTick:=GetTickCount();
      LoginServer.btStartStatus := 3;
      exit;
    end else begin
      CloseHandle(LoginServer.ProcessHandle);
      LoginServer.btStartStatus:=0;
      MainOutMessage('登录服务器已停止...');
    end;
  end;

  if LogServer.boGetStart and (LogServer.btStartStatus in [2,3]) then begin
    GetExitCodeProcess(LogServer.ProcessHandle,dwExitCode);
    if dwExitCode = STILL_ACTIVE then begin
      if LogServer.btStartStatus = 3 then begin
        if GetTickCount - g_dwStopTick > g_dwStopTimeOut then begin
          StopProgram(LogServer,0);
          MainOutMessage('正常关闭超时，游戏引擎主程序已被强行停止...');
        end;
        exit; //如果正在关闭则等待，不处理下面
      end;
      SendProgramMsg(LogServer.MainFormHandle,GS_QUIT,'');
      g_dwStopTick:=GetTickCount();
      LogServer.btStartStatus := 3;
      exit;
    end else begin
      CloseHandle(LogServer.ProcessHandle);
      LogServer.btStartStatus:=0;
      MainOutMessage('游戏日志服务器已停止...');
    end;
  end;

  if DBServer.boGetStart and (DBServer.btStartStatus in [2,3]) then begin
    GetExitCodeProcess(DBServer.ProcessHandle,dwExitCode);
    if dwExitCode = STILL_ACTIVE then begin
      if DBServer.btStartStatus = 3 then begin      // 0
        if GetTickCount - g_dwStopTick > g_dwStopTimeOut then begin
          StopProgram(DBServer,0);
          MainOutMessage('正常关闭超时，游戏引擎主程序已被强行停止...');
        end;
        exit; //如果正在关闭则等待，不处理下面
      end;
      SendProgramMsg(DBServer.MainFormHandle,GS_QUIT,'');
      g_dwStopTick:=GetTickCount();
      DBServer.btStartStatus := 3; //3
      exit;
    end else begin
      CloseHandle(DBServer.ProcessHandle);
      DBServer.btStartStatus:=0;
      MainOutMessage('游戏数据库服务器已停止...');
    end;
  end;








  TimerStopGame.Enabled:=False;
  ButtonStartGame.Caption:=g_sButtonStartGame;
  m_nStartStatus:=0;
end;

procedure TfrmMain.TimerCheckRunTimer(Sender: TObject);
var
  dwExitCode:LongWord;
  nRetCode:Integer;
begin
  if DBServer.boGetStart then begin
    GetExitCodeProcess(DBServer.ProcessHandle,dwExitCode);
    if dwExitCode <> STILL_ACTIVE then begin
      nRetCode:=RunProgram(DBServer,IntToStr(Self.Handle),0);

      if nRetCode = 0 then begin
        CloseHandle(DBServer.ProcessHandle);
        DBServer.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,DBServer.ProcessInfo.dwProcessId);
        MainOutMessage('数据库异常关闭，已被重新启动...');
      end;
    end;
  end;

  if LoginServer.boGetStart then begin
    GetExitCodeProcess(LoginServer.ProcessHandle,dwExitCode);
    if dwExitCode <> STILL_ACTIVE then begin
      nRetCode:=RunProgram(LoginServer,IntToStr(Self.Handle),0);
      if nRetCode = 0 then begin
        CloseHandle(LoginServer.ProcessHandle);
        LoginServer.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,LoginServer.ProcessInfo.dwProcessId);
        MainOutMessage('登录服务器异常关闭，已被重新启动...');
      end;
    end;
  end;

  if LogServer.boGetStart then begin
    GetExitCodeProcess(LogServer.ProcessHandle,dwExitCode);
    if dwExitCode <> STILL_ACTIVE then begin
      nRetCode:=RunProgram(LogServer,IntToStr(Self.Handle),0);
      if nRetCode = 0 then begin
        CloseHandle(LogServer.ProcessHandle);
        LogServer.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,LogServer.ProcessInfo.dwProcessId);
        MainOutMessage('日志服务器异常关闭，已被重新启动...');
      end;
    end;
  end;

  if M2Server.boGetStart then begin
    GetExitCodeProcess(M2Server.ProcessHandle,dwExitCode);
    if dwExitCode <> STILL_ACTIVE then begin
      nRetCode:=RunProgram(M2Server,IntToStr(Self.Handle),0);
      if nRetCode = 0 then begin
        CloseHandle(M2Server.ProcessHandle);
        M2Server.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,M2Server.ProcessInfo.dwProcessId);
        MainOutMessage('游戏引擎服务器异常关闭，已被重新启动...');
      end;
    end;
  end;

  if RunGate.boGetStart then begin
    GetExitCodeProcess(RunGate.ProcessHandle,dwExitCode);
    if dwExitCode <> STILL_ACTIVE then begin
      GetMutRunGateConfing(0);
      nRetCode:=RunProgram(RunGate,IntToStr(Self.Handle),2000);
      if nRetCode = 0 then begin
        CloseHandle(RunGate.ProcessHandle);
        RunGate.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,RunGate.ProcessInfo.dwProcessId);
        MainOutMessage('游戏网关一异常关闭，已被重新启动...');
      end;
    end;
  end;

  if RunGate1.boGetStart then begin
    GetExitCodeProcess(RunGate1.ProcessHandle,dwExitCode);
    if dwExitCode <> STILL_ACTIVE then begin
      GetMutRunGateConfing(1);
      nRetCode:=RunProgram(RunGate1,IntToStr(Self.Handle),2000);
      if nRetCode = 0 then begin
        CloseHandle(RunGate1.ProcessHandle);
        RunGate1.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,RunGate1.ProcessInfo.dwProcessId);
        MainOutMessage('游戏网关二异常关闭，已被重新启动...');
      end;
    end;
  end;

  if RunGate2.boGetStart then begin
    GetExitCodeProcess(RunGate2.ProcessHandle,dwExitCode);
    if dwExitCode <> STILL_ACTIVE then begin
      GetMutRunGateConfing(2);
      nRetCode:=RunProgram(RunGate2,IntToStr(Self.Handle),2000);
      if nRetCode = 0 then begin
        CloseHandle(RunGate2.ProcessHandle);
        RunGate2.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,RunGate2.ProcessInfo.dwProcessId);
        MainOutMessage('游戏网关三异常关闭，已被重新启动...');
      end;
    end;
  end;

  if SelGate.boGetStart then begin
    GetExitCodeProcess(SelGate.ProcessHandle,dwExitCode);
    if dwExitCode <> STILL_ACTIVE then begin
      nRetCode:=RunProgram(SelGate,IntToStr(Self.Handle),0);
      if nRetCode = 0 then begin
        CloseHandle(SelGate.ProcessHandle);
        SelGate.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,SelGate.ProcessInfo.dwProcessId);
        MainOutMessage('角色网关异常关闭，已被重新启动...');
      end;
    end;
  end;

  if LoginGate.boGetStart then begin
    GetExitCodeProcess(LoginGate.ProcessHandle,dwExitCode);
    if dwExitCode <> STILL_ACTIVE then begin
      nRetCode:=RunProgram(LoginGate,IntToStr(Self.Handle),0);
      if nRetCode = 0 then begin
        CloseHandle(LoginGate.ProcessHandle);
        LoginGate.ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,LoginGate.ProcessInfo.dwProcessId);
        MainOutMessage('登录网关异常关闭，已被重新启动...');
      end;
    end;
  end;
end;


procedure TfrmMain.ProcessMessage(var Msg: TMsg; var Handled: Boolean);
begin

end;

procedure TfrmMain.MyMessage(var MsgData: TWmCopyData);
var
  sData:String;
  ProgramType:TProgamType;
  wIdent:Word;
begin
  wIdent:=HiWord(MsgData.From);
  ProgramType:=TProgamType(LoWord(MsgData.From));
  sData:=StrPas(MsgData.CopyDataStruct^.lpData);
  case ProgramType of    //
    tDBServer: ProcessDBServerMsg(wIdent,sData);
    tLoginSrv: ProcessLoginSrvMsg(wIdent,sData);
    tLogServer: ProcessLogServerMsg(wIdent,sData);
    tM2Server:  ProcessM2ServerMsg(wIdent,sData);
    tLoginGate: ProcessLoginGateMsg(wIdent,sData);
    tLoginGate1: ProcessLoginGate1Msg(wIdent,sData);
    tSelGate: ProcessSelGateMsg(wIdent,sData);
    tSelGate1: ProcessSelGate1Msg(wIdent,sData);
    tRunGate:  ProcessRunGateMsg(wIdent,sData);
    tRunGate1: ProcessRunGate1Msg(wIdent,sData);
    tRunGate2: ProcessRunGate2Msg(wIdent,sData);
    tRunGate3: ProcessRunGate3Msg(wIdent,sData);
    tRunGate4: ProcessRunGate4Msg(wIdent,sData);
    tRunGate5: ProcessRunGate5Msg(wIdent,sData);
    tRunGate6: ProcessRunGate6Msg(wIdent,sData);
    tRunGate7: ProcessRunGate7Msg(wIdent,sData);
  end;
end;

procedure TfrmMain.ProcessDBServerMsg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        DBServer.MainFormHandle:=Handle;
//        SetWindowPos(Self.Handle,Handle,Self.Left,Self.Top,Self.Width,Self.Height,$40);
      end;
    end;
    SG_STARTNOW: begin
      MainOutMessage(sData);
    end;
    SG_STARTOK: begin
      DBServer.btStartStatus:=2;
      MainOutMessage(sData);
    end;
    SG_CHECKCODEADDR: begin
      g_dwDBCheckCodeAddr:=Str_ToInt(sData,-1);
    end;
    3: ;
  end;
end;

procedure TfrmMain.ProcessLoginGateMsg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        LoginGate.MainFormHandle:=Handle;
//        SetWindowPos(Self.Handle,Handle,Self.Left,Self.Top,Self.Width,Self.Height,$40);
      end;
    end;
    SG_STARTNOW: begin
      MainOutMessage(sData);
    end;
    SG_STARTOK: begin
      LoginGate.btStartStatus:=2;
      MainOutMessage(sData);
    end;
    2: ;
    3: ;
  end;
end;

procedure TfrmMain.ProcessLoginGate1Msg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        LoginGate1.MainFormHandle:=Handle;
//        SetWindowPos(Self.Handle,Handle,Self.Left,Self.Top,Self.Width,Self.Height,$40);
      end;
    end;
    1: ;
    2: ;
    3: ;
  end;
end;

procedure TfrmMain.ProcessSelGateMsg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        SelGate.MainFormHandle:=Handle;
//        SetWindowPos(Self.Handle,Handle,Self.Left,Self.Top,Self.Width,Self.Height,$40);
      end;
    end;
    SG_STARTNOW: begin
      MainOutMessage(sData);
    end;
    SG_STARTOK: begin
      if SelGate.btStartStatus <> 2 then begin
        SelGate.btStartStatus:=2;
      end else begin
        SelGate1.btStartStatus:=2;
      end;
      MainOutMessage(sData);
    end;
  end;
end;

procedure TfrmMain.ProcessSelGate1Msg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        SelGate1.MainFormHandle:=Handle;
      end;
    end;
    1: ;
    2: ;
    3: ;
  end;

end;

procedure TfrmMain.ProcessM2ServerMsg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        M2Server.MainFormHandle:=Handle;
//        SetWindowPos(Self.Handle,Handle,Self.Left,Self.Top,Self.Width,Self.Height,$40);
      end;
    end;
    SG_STARTNOW: begin
      MainOutMessage(sData);
    end;
    SG_STARTOK: begin
      M2Server.btStartStatus:=2;
      MainOutMessage(sData);
    end;
    SG_CHECKCODEADDR: begin
      g_dwM2CheckCodeAddr:=Str_ToInt(sData,-1);
    end;
  end;

end;

procedure TfrmMain.ProcessLoginSrvMsg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        LoginServer.MainFormHandle:=Handle;
//        SetWindowPos(Self.Handle,Handle,Self.Left,Self.Top,Self.Width,Self.Height,$40);
      end;
    end;
    SG_STARTNOW: begin
      MainOutMessage(sData);
    end;
    SG_STARTOK: begin
      LoginServer.btStartStatus:=2;
      MainOutMessage(sData);
    end;
    SG_USERACCOUNT: begin
      ProcessLoginSrvGetUserAccount(sData);
    end;
    SG_USERACCOUNTCHANGESTATUS: begin
      ProcessLoginSrvChangeUserAccountStatus(sData);
    end;
  end;

end;

procedure TfrmMain.ProcessLogServerMsg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        LogServer.MainFormHandle:=Handle;
//        SetWindowPos(Self.Handle,Handle,Self.Left,Self.Top,Self.Width,Self.Height,$40);
      end;
    end;
    SG_STARTNOW: begin
      MainOutMessage(sData);
    end;
    SG_STARTOK: begin
      LogServer.btStartStatus:=2;
      MainOutMessage(sData);
    end;
  end;

end;



procedure TfrmMain.ProcessRunGate1Msg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        RunGate1.MainFormHandle:=Handle;
//        SetWindowPos(Self.Handle,Handle,Self.Left,Self.Top,Self.Width,Self.Height,$40);
      end;
    end;
    1: ;
    2: ;
    3: ;
  end;

end;

procedure TfrmMain.ProcessRunGate2Msg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        RunGate2.MainFormHandle:=Handle;
      end;
    end;
    1: ;
    2: ;
    3: ;
  end;

end;

procedure TfrmMain.ProcessRunGate3Msg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        RunGate3.MainFormHandle:=Handle;
      end;
    end;
    1: ;
    2: ;
    3: ;
  end;

end;

procedure TfrmMain.ProcessRunGate4Msg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        RunGate4.MainFormHandle:=Handle;
      end;
    end;
    1: ;
    2: ;
    3: ;
  end;

end;

procedure TfrmMain.ProcessRunGate5Msg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        RunGate5.MainFormHandle:=Handle;
      end;
    end;
    1: ;
    2: ;
    3: ;
  end;

end;

procedure TfrmMain.ProcessRunGate6Msg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        RunGate6.MainFormHandle:=Handle;
      end;
    end;
    1: ;
    2: ;
    3: ;
  end;

end;

procedure TfrmMain.ProcessRunGate7Msg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        RunGate7.MainFormHandle:=Handle;
      end;
    end;
    1: ;
    2: ;
    3: ;
  end;

end;

procedure TfrmMain.ProcessRunGateMsg(wIdent: Word; sData: String);
var
  Handle:THandle;
begin
  case wIdent of
    SG_FORMHANDLE: begin
      Handle:=Str_ToInt(sData,0);
      if Handle <> 0 then begin
        RunGate.MainFormHandle:=Handle;
      end;
    end;
    1: ;
    2: ;
    3: ;
  end;

end;



procedure TfrmMain.EditSkinChange(Sender: TObject);
begin
  if EditSkin.Text = '' then begin
    EditSkin.Text:='0';
  end;
  ButtonFormSave.Enabled:=True;
end;

procedure TfrmMain.ButtonFormSaveClick(Sender: TObject);
begin
  ButtonFormSave.Enabled:=False;

end;

procedure TfrmMain.ButtonReLoadConfigClick(Sender: TObject);
begin
  LoadConfig();
  RefGameConsole();
  Application.MessageBox('配置重加载完成...','提示信息',MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain.EditLoginGate_MainFormXChange(Sender: TObject);
begin
  if EditLoginGate_MainFormX.Text = '' then begin
    EditLoginGate_MainFormX.Text:='0';
  end;
  if not m_boOpen then exit;
  g_nLoginGate_MainFormX:=EditLoginGate_MainFormX.Value;
end;

procedure TfrmMain.EditLoginGate_MainFormYChange(Sender: TObject);
begin
  if EditLoginGate_MainFormY.Text = '' then begin
    EditLoginGate_MainFormY.Text:='0';
  end;
  if not m_boOpen then exit;
  g_nLoginGate_MainFormY:=EditLoginGate_MainFormY.Value;
end;

procedure TfrmMain.CheckBoxboLoginGate_GetStartClick(Sender: TObject);
begin
  if not m_boOpen then exit;
  g_boLoginGate_GetStart:=CheckBoxboLoginGate_GetStart.Checked;
end;

procedure TfrmMain.EditSelGate_MainFormXChange(Sender: TObject);
begin
  if EditSelGate_MainFormX.Text = '' then begin
    EditSelGate_MainFormX.Text:='0';
  end;
  if not m_boOpen then exit;
  g_nSelGate_MainFormX:=EditSelGate_MainFormX.Value;
end;

procedure TfrmMain.EditSelGate_MainFormYChange(Sender: TObject);
begin
  if EditSelGate_MainFormY.Text = '' then begin
    EditSelGate_MainFormY.Text:='0';
  end;
  if not m_boOpen then exit;
  g_nSelGate_MainFormY:=EditSelGate_MainFormY.Value;
end;

procedure TfrmMain.CheckBoxboSelGate_GetStartClick(Sender: TObject);
begin
  if not m_boOpen then exit;
  g_boSelGate_GetStart:=CheckBoxboSelGate_GetStart.Checked;
end;
procedure TfrmMain.EditLoginServer_MainFormXChange(Sender: TObject);
begin
  if EditLoginServer_MainFormX.Text = '' then begin
    EditLoginServer_MainFormX.Text:='0';
  end;
  if not m_boOpen then exit;
  g_nLoginServer_MainFormX:=EditLoginServer_MainFormX.Value;
end;

procedure TfrmMain.EditLoginServer_MainFormYChange(Sender: TObject);
begin
  if EditLoginServer_MainFormY.Text = '' then begin
    EditLoginServer_MainFormY.Text:='0';
  end;
  if not m_boOpen then exit;
  g_nLoginServer_MainFormY:=EditLoginServer_MainFormY.Value;
end;

procedure TfrmMain.CheckBoxboLoginServer_GetStartClick(Sender: TObject);
begin
  if not m_boOpen then exit;
  g_boLoginServer_GetStart:=CheckBoxboLoginServer_GetStart.Checked;
end;

procedure TfrmMain.EditDBServer_MainFormXChange(Sender: TObject);
begin
  if EditDBServer_MainFormX.Text = '' then begin
    EditDBServer_MainFormX.Text:='0';
  end;
  if not m_boOpen then exit;
  g_nDBServer_MainFormX:=EditDBServer_MainFormX.Value;
end;

procedure TfrmMain.EditDBServer_MainFormYChange(Sender: TObject);
begin
  if EditDBServer_MainFormY.Text = '' then begin
    EditDBServer_MainFormY.Text:='0';
  end;
  if not m_boOpen then exit;
  g_nDBServer_MainFormY:=EditDBServer_MainFormY.Value;
end;

procedure TfrmMain.CheckBoxAutoBackupHumDataClick(Sender: TObject);
begin
  if not m_boOpen then exit;
  g_boDBServer_AutoBackup:=CheckBoxAutoBackupHumData.Checked;
end;

procedure TfrmMain.EditBackupTimeChange(Sender: TObject);
begin
  if not m_boOpen then exit;
  g_dwDBServer_BackupTime:=EditBackupTime.Value * 60 * 1000;
end;

procedure TfrmMain.CheckBoxDBServerGetStartClick(Sender: TObject);
begin
  if not m_boOpen then exit;
  g_boDBServer_GetStart:=CheckBoxDBServerGetStart.Checked;
end;

procedure TfrmMain.EditLogServer_MainFormXChange(Sender: TObject);
begin
  if EditLogServer_MainFormX.Text = '' then begin
    EditLogServer_MainFormX.Text:='0';
  end;
  if not m_boOpen then exit;
  g_nLogServer_MainFormX:=EditLogServer_MainFormX.Value;
end;

procedure TfrmMain.EditLogServer_MainFormYChange(Sender: TObject);
begin
  if EditLogServer_MainFormY.Text = '' then begin
    EditLogServer_MainFormY.Text:='0';
  end;
  if not m_boOpen then exit;
  g_nLogServer_MainFormY:=EditLogServer_MainFormY.Value;
end;


procedure TfrmMain.CheckBoxLogServerGetStartClick(Sender: TObject);
begin
  if not m_boOpen then exit;
  g_boLogServer_GetStart:=CheckBoxLogServerGetStart.Checked;
end;

procedure TfrmMain.EditM2Server_MainFormXChange(Sender: TObject);
begin
  if EditM2Server_MainFormX.Text = '' then begin
    EditM2Server_MainFormX.Text:='0';
  end;
  if not m_boOpen then exit;
  g_nM2Server_MainFormX:=EditM2Server_MainFormX.Value;
end;

procedure TfrmMain.EditM2Server_MainFormYChange(Sender: TObject);
begin
  if EditM2Server_MainFormY.Text = '' then begin
    EditM2Server_MainFormY.Text:='0';
  end;
  if not m_boOpen then exit;
  g_nM2Server_MainFormY:=EditM2Server_MainFormY.Value;

end;


procedure TfrmMain.EditM2Server_TestLevelChange(Sender: TObject);
begin
  if EditM2Server_TestLevel.Text = '' then begin
    EditM2Server_TestLevel.Text:='0';
  end;
  if not m_boOpen then exit;
  g_nM2Server_TestLevel:=EditM2Server_TestLevel.Value;
end;


procedure TfrmMain.EditM2Server_TestGoldChange(Sender: TObject);
begin
  if EditM2Server_TestGold.Text = '' then begin
    EditM2Server_TestGold.Text:='0';
  end;
  if not m_boOpen then exit;
  g_nM2Server_TestGold:=EditM2Server_TestGold.Value;
end;

procedure TfrmMain.CheckBoxM2ServerGetStartClick(Sender: TObject);
begin
  if not m_boOpen then exit;
  g_boM2Server_GetStart:=CheckBoxM2ServerGetStart.Checked;
end;


procedure TfrmMain.MemoLogChange(Sender: TObject);
begin
  if MemoLog.Lines.Count > 100 then
    MemoLog.Clear;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if m_nStartStatus = 2 then begin
    if Application.MessageBox('游戏服务器正在运行，是否停止游戏服务器 ?','确认信息',MB_YESNO + MB_ICONQUESTION) = mrYes then begin
      ButtonStartGameClick(ButtonStartGame);
    end;
    CanClose:=False;
    exit;
  end;

  if Application.MessageBox('是否确认关闭游戏控制器 ?','确认信息',MB_YESNO + MB_ICONQUESTION) = mrYes then begin
    CanClose:=True;
  end else begin
    CanClose:=False;
  end;
end;



procedure TfrmMain.GetMutRunGateConfing(nIndex: Integer);
var
  IniGameConf:TIniFile;
  sIniFile:String;
  sGateAddr:String;
  nGatePort:Integer;
begin
  case nIndex of    //
    0: begin
      sGateAddr := g_sRunGate_GateAddr;
      nGatePort := g_nRunGate_GatePort;
    end;
    1: begin
      sGateAddr:=g_sRunGate1_GateAddr;
      nGatePort:=g_nRunGate1_GatePort;
    end;
    2: begin
      sGateAddr:=g_sRunGate2_GateAddr;
      nGatePort:=g_nRunGate2_GatePort;
    end;
    3: begin
      sGateAddr:=g_sRunGate3_GateAddr;
      nGatePort:=g_nRunGate3_GatePort;
    end;
    4: begin
      sGateAddr:=g_sRunGate4_GateAddr;
      nGatePort:=g_nRunGate4_GatePort;
    end;
    5: begin
      sGateAddr:=g_sRunGate5_GateAddr;
      nGatePort:=g_nRunGate5_GatePort;
    end;
    6: begin
      sGateAddr:=g_sRunGate6_GateAddr;
      nGatePort:=g_nRunGate6_GatePort;
    end;
    7: begin
      sGateAddr:=g_sRunGate7_GateAddr;
      nGatePort:=g_nRunGate7_GatePort;
    end;
  end;

  sIniFile:=g_sGameDirectory + g_sRunGate_Directory;
  if not DirectoryExists(sIniFile) then begin
    CreateDir(sIniFile);
  end;
  IniGameConf:=TIniFile.Create(sIniFile + g_sRunGate_ConfigFile);
  IniGameConf.WriteString('GameGate','Title',g_sGameName + '(' + IntToStr(nGatePort) + ')');
  IniGameConf.WriteString('GameGate','GateAddr',sGateAddr);
  IniGameConf.WriteInteger('GameGate','GatePort',nGatePort);

  IniGameConf.Free;
end;



procedure TfrmMain.EditRunGate_ConntChange(Sender: TObject);
begin
  if EditRunGate_Connt.Text = '' then begin
    EditRunGate_Connt.Text:='0';
  end;
  if not m_boOpen then exit;

  g_nRunGate_Count:=EditRunGate_Connt.Value;
  g_boRunGate1_GetStart:=g_nRunGate_Count >= 2;
  g_boRunGate2_GetStart:=g_nRunGate_Count >= 3;
  g_boRunGate3_GetStart:=g_nRunGate_Count >= 4;
  g_boRunGate4_GetStart:=g_nRunGate_Count >= 5;
  g_boRunGate5_GetStart:=g_nRunGate_Count >= 6;
  g_boRunGate6_GetStart:=g_nRunGate_Count >= 7;
  g_boRunGate7_GetStart:=g_nRunGate_Count >= 8;
//  if g_boRunGate4_GetStart then begin
//    g_sDBServer_Config_GateAddr:=g_sAllIPaddr;
//  end else begin
//    g_sDBServer_Config_GateAddr:=g_sLocalIPaddr;
//  end;
  g_sDBServer_Config_GateAddr:=g_sLocalIPaddr;
  RefGameConsole();
end;

procedure TfrmMain.ButtonLoginServerConfigClick(Sender: TObject);
begin
  frmLoginServerConfig.Open;
end;

procedure TfrmMain.CheckBoxDynamicIPModeClick(Sender: TObject);
begin
  EditGameExtIPaddr.Enabled:=not CheckBoxDynamicIPMode.Checked;
end;

function TfrmMain.StartService:Boolean;
begin
  Result:=False;
  MainOutMessage('正在启动游戏控制器...');
  g_SessionList:=TStringList.Create;
  if FileExists(g_sGameFile) then begin
    MemoGameList.Lines.LoadFromFile(g_sGameFile);
  end;
  g_sNoticeUrl:=g_IniConf.ReadString('Client','NoticeUrl',g_sNoticeUrl);
  g_nClientForm:=g_IniConf.ReadInteger('Client','ClientForm',g_nClientForm);
  g_nServerPort:=g_IniConf.ReadInteger('Client','ServerPort',g_nServerPort);
  g_sServerAddr:=g_IniConf.ReadString('Client','ServerAddr',g_sServerAddr);

  g_sServerAddr:=g_IniConf.ReadString('Client','ServerAddr',g_sServerAddr);
  g_nServerPort:=g_IniConf.ReadInteger('Client','ServerPort',g_nServerPort);
  EditNoticeUrl.Text:=g_sNoticeUrl;
  EditClientForm.Value:=g_nClientForm;
  try
    //ServerSocket.Address:=g_sServerAddr;   // Midified by Davy 2019-11-8
    ServerSocket.Port:=g_nServerPort;
    ServerSocket.Active:=True;
    m_dwShowTick:=GetTickCount();
    Timer.Enabled:=true;
  except
    on e: ESocketError do begin
      MainOutMessage(format('端口%d打开异常，检查端口是否被其它程序占用！！！',[g_nServerPort]));
      MainOutMessage(E.Message);
      exit;
    end;

  end;
  MainOutMessage('戏控制器启动完成...');
  Result:=True;
end;

procedure TfrmMain.StopService;
begin
  Timer.Enabled:=False;
  g_SessionList.Free;
  g_IniConf.Free;
end;

procedure TfrmMain.ProcessClientPacket;
var
  I: Integer;
  sLineText,sData,sDefMsg:String;
  nDataLen:Integer;
  DefMsg:TDefaultMessage;
  Socket:TCustomWinSocket;
begin
  for I := 0 to g_SessionList.Count - 1 do begin
    Socket:=TCustomWinSocket(g_SessionList.Objects[I]);
    sLineText:=g_SessionList.Strings[I];
    if sLineText = '' then Continue;
    while TagCount(sLineText,'!') > 0 do begin
      sLineText:=ArrestStringEx(sLineText,'#','!',sData);
      nDataLen:=length(sData);
      if (nDataLen >= DEFBLOCKSIZE) then begin
        sDefMsg:=Copy(sData,1,DEFBLOCKSIZE);
        DefMsg:=DecodeMessage(sDefMsg);
        case DefMsg.Ident of
          CM_GETGAMELIST: begin
            SendGameList(Socket);
          end;

        end;
      end;
    end;
    g_SessionList.Strings[I]:=sLineText;
  end;
end;

procedure TfrmMain.SendGameList(Socket: TCustomWinSocket);
var
  I: Integer;
  DefMsg:TDefaultMessage;
  sLineText:String;
  sNoticeUrl:String;
begin
  sNoticeUrl:=Trim(EditNoticeUrl.Text);
  DefMsg:=MakeDefaultMsg(SM_SENDGAMELIST,0,0,0,0);
  for I := 0 to MemoGameList.Lines.Count - 1 do begin
    sLineText:=MemoGameList.Lines.Strings[I];
    if (sLineText <> '') and (sLineText[1] <> ';') then begin
      SendSocket(Socket,EncodeMessage(DefMsg) + EncodeString(MemoGameList.Lines.Strings[I]));
    end;
  end;
  DefMsg:=MakeDefaultMsg(SM_SENDGAMELIST,g_nClientForm,1,0,0);
  SendSocket(Socket,EncodeMessage(DefMsg) + EncodeString(sNoticeUrl));
end;

procedure TfrmMain.SendSocket(Socket: TCustomWinSocket; SendMsg: String);
begin
  SendMsg:='#' + SendMsg + '!';
  if Socket.Connected then
    Socket.SendText(SendMsg);
end;

procedure TfrmMain.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I: Integer;
  boFound:Boolean;
begin
  boFound:=False;
  for I := 0 to g_SessionList.Count - 1 do begin
    if g_SessionList.Objects[I] = Socket then begin
      boFound:=True;
      break;
    end;
  end;
  if not boFound then begin
    g_SessionList.AddObject('',Socket)
  end;
end;

procedure TfrmMain.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I: Integer;
begin
  for I := 0 to g_SessionList.Count - 1 do begin
    if g_SessionList.Objects[I] = Socket then begin
      g_SessionList.Delete(I);
      break;
    end;
  end;
end;

procedure TfrmMain.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode:=0;
  Socket.Close;
end;

procedure TfrmMain.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I: Integer;
begin
  for I := 0 to g_SessionList.Count - 1 do begin
    if g_SessionList.Objects[I] = Socket then begin
      g_SessionList.Strings[I]:=g_SessionList.Strings[I] + Socket.ReceiveText;
      break;
    end;
  end;
end;

procedure TfrmMain.TimerTimer(Sender: TObject);
begin
  ProcessClientPacket();
  if GetTickCount - m_dwShowTick > 1000 then begin
    m_dwShowTick:=GetTickCount();
    LabelConnect.Caption:=format('端口：%d   当前连接数：%d',[ServerSocket.Port,ServerSocket.Socket.ActiveConnections]);
  end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  MemoGameList.Lines.SaveToFile(g_sGameFile);
  g_IniConf.WriteString('Client','NoticeUrl',g_sNoticeUrl);
  g_IniConf.WriteInteger('Client','ClientForm',g_nClientForm);
  g_IniConf.WriteString('Client','ServerAddr',g_sServerAddr);
  g_IniConf.WriteInteger('Client','ServerPort',g_nServerPort);
  Button2.Enabled:=False;
end;

procedure TfrmMain.EditNoticeUrlChange(Sender: TObject);
begin
  if not m_boOpen then exit;
  g_sNoticeUrl:=Trim(EditNoticeUrl.Text);
  Button2.Enabled:=True;
end;

procedure TfrmMain.EditClientFormChange(Sender: TObject);
begin
  if not m_boOpen then exit;
  g_nClientForm:=EditClientForm.Value;
  Button2.Enabled:=True;
end;

procedure TfrmMain.MemoGameListChange(Sender: TObject);
begin
  if not m_boOpen then exit;

  Button2.Enabled:=True;
end;

procedure TfrmMain.ButtonGeneralDefalultClick(Sender: TObject);
begin
  EditGameDir.Text:='D:\Mirserver\';
  EditHeroDB.Text:='HeroDB';
  EditGameName.Text:='热血传奇';
  EditGameExtIPaddr.Text:='127.0.0.1';
  CheckBoxDynamicIPMode.Checked:=False;
end;

procedure TfrmMain.ButtonRunGateDefaultClick(Sender: TObject);
begin
  EditRunGate_Connt.Value:=3;
  EditRunGate_GatePort1.Text:='7200';
  EditRunGate_GatePort2.Text:='7300';
  EditRunGate_GatePort3.Text:='7400';
  EditRunGate_GatePort4.Text:='7500';
  EditRunGate_GatePort5.Text:='7600';
  EditRunGate_GatePort6.Text:='7700';
  EditRunGate_GatePort7.Text:='7800';
  EditRunGate_GatePort8.Text:='7900';
end;


procedure TfrmMain.ButtonLoginGateDefaultClick(Sender: TObject);
begin
  EditLoginGate_MainFormX.Text:='0';
  EditLoginGate_MainFormY.Text:='0';
  EditLoginGate_GatePort.Text:='7000';
end;

procedure TfrmMain.ButtonSelGateDefaultClick(Sender: TObject);
begin
  EditSelGate_MainFormX.Text:='0';
  EditSelGate_MainFormY.Text:='163';
  EditSelGate_GatePort.Text:='7100';
end;

procedure TfrmMain.ButtonLoginSrvDefaultClick(Sender: TObject);
begin
  EditLoginServer_MainFormX.Text:='251';
  EditLoginServer_MainFormY.Text:='0';
  EditLoginServerGatePort.Text:='5500';
  EditLoginServerServerPort.Text:='5600';
  CheckBoxboLoginServer_GetStart.Checked:=True;
end;

procedure TfrmMain.ButtonDBServerDefaultClick(Sender: TObject);
begin
  EditDBServer_MainFormX.Text:='0';
  EditDBServer_MainFormY.Text:='326';
  CheckBoxAutoBackupHumData.Checked:=False;
  EditDBServerGatePort.Text:='5100';
  EditDBServerServerPort.Text:='6000';
  CheckBoxDBServerGetStart.Checked:=True;
end;

procedure TfrmMain.ButtonLogServerDefaultClick(Sender: TObject);
begin
  EditLogServer_MainFormX.Text:='251';
  EditLogServer_MainFormY.Text:='239';
  EditLogServerPort.Text:='10000';
  CheckBoxLogServerGetStart.Checked:=True;
end;

procedure TfrmMain.ButtonM2ServerDefaultClick(Sender: TObject);
begin
  EditM2Server_MainFormX.Text:='560';
  EditM2Server_MainFormY.Text:='0';
  EditM2Server_TestLevel.Value:=1;
  EditM2Server_TestGold.Value:=0;
  EditM2ServerGatePort.Text:='5000';
  EditM2ServerMsgSrvPort.Text:='4900';
  CheckBoxM2ServerGetStart.Checked:=True;
end;

procedure TfrmMain.ButtonSearchLoginAccountClick(Sender: TObject);
var
  sAccount:String;
begin
  if LoginServer.btStartStatus <> 2 then begin
    Application.MessageBox('游戏登录服务器未启动！！！' + #13#13 + '启动游戏登录服务器后才能使用此功能。','提示信息',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  sAccount:=Trim(EditSearchLoginAccount.Text);
  if sAccount = '' then begin
    Application.MessageBox('帐号不能为空！！！','错误信息',MB_OK + MB_ICONERROR);
    EditSearchLoginAccount.SetFocus;
    exit;
  end;
  EditLoginAccount.Text:='';
  EditLoginAccountPasswd.Text:='';
  EditLoginAccountUserName.Text:='';
  EditLoginAccountSSNo.Text:='';
  EditLoginAccountBirthDay.Text:='';
  EditLoginAccountPhone.Text:='';
  EditLoginAccountMobilePhone.Text:='';
  EditLoginAccountQuiz.Text:='';
  EditLoginAccountAnswer.Text:='';
  EditLoginAccountQuiz2.Text:='';
  EditLoginAccountAnswer2.Text:='';
  EditLoginAccountEMail.Text:='';
  EditLoginAccountMemo1.Text:='';
  EditLoginAccountMemo2.Text:='';
  CkFullEditMode.Checked:=False;
  UserAccountEditMode(False);
  EditLoginAccount.Enabled:=False;
  SendProgramMsg(LoginServer.MainFormHandle,GS_USERACCOUNT,sAccount);
end;

procedure TfrmMain.ProcessLoginSrvGetUserAccount(sData: String);
var
  DBRecord:TAccountDBRecord;
  DefMsg:TDefaultMessage;
  sDefMsg:String;
begin
  if Length(sData) < DEFBLOCKSIZE then exit;
  sDefMsg:=Copy(sData,1,DEFBLOCKSIZE);
  sData:=Copy(sData,DEFBLOCKSIZE+1,Length(sData)-DEFBLOCKSIZE);
  DefMsg:=DecodeMessage(sDefMsg);

  case DefMsg.Ident of    //
    SG_USERACCOUNTNOTFOUND: begin
      Application.MessageBox('帐号未找到！！！','提示信息',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    else begin
      DecodeBuffer(sData,@DBRecord,SizeOf(DBRecord));
    end;
  end;

  EditLoginAccount.Text:=DBRecord.UserEntry.sAccount;
  EditLoginAccountPasswd.Text:=DBRecord.UserEntry.sPassword;
  EditLoginAccountUserName.Text:=DBRecord.UserEntry.sUserName;
  EditLoginAccountSSNo.Text:=DBRecord.UserEntry.sSSNo;
  EditLoginAccountBirthDay.Text:=DBRecord.UserEntryAdd.sBirthDay;
  EditLoginAccountPhone.Text:=DBRecord.UserEntry.sPhone;
  EditLoginAccountMobilePhone.Text:=DBRecord.UserEntryAdd.sMobilePhone;
  EditLoginAccountQuiz.Text:=DBRecord.UserEntry.sQuiz;
  EditLoginAccountAnswer.Text:=DBRecord.UserEntry.sAnswer;
  EditLoginAccountQuiz2.Text:=DBRecord.UserEntryAdd.sQuiz2;
  EditLoginAccountAnswer2.Text:=DBRecord.UserEntryAdd.sAnswer2;
  EditLoginAccountEMail.Text:=DBRecord.UserEntry.sEMail;
  EditLoginAccountMemo1.Text:=DBRecord.UserEntryAdd.sMemo;
  EditLoginAccountMemo2.Text:=DBRecord.UserEntryAdd.sMemo2;
  ButtonLoginAccountOK.Enabled:=False;
//  ShowMessage(sData);
end;

procedure TfrmMain.EditLoginAccountChange(Sender: TObject);
begin
  ButtonLoginAccountOK.Enabled:=True;
end;
procedure TfrmMain.CkFullEditModeClick(Sender: TObject);
begin
  UserAccountEditMode(CkFullEditMode.Checked);
end;

procedure TfrmMain.UserAccountEditMode(boChecked: Boolean);
begin
  boChecked:=CkFullEditMode.Checked;
  EditLoginAccountUserName.Enabled:=boChecked;
  EditLoginAccountSSNo.Enabled:=boChecked;
  EditLoginAccountBirthDay.Enabled:=boChecked;
  EditLoginAccountQuiz.Enabled:=boChecked;
  EditLoginAccountAnswer.Enabled:=boChecked;
  EditLoginAccountQuiz2.Enabled:=boChecked;
  EditLoginAccountAnswer2.Enabled:=boChecked;
  EditLoginAccountMobilePhone.Enabled:=boChecked;
  EditLoginAccountPhone.Enabled:=boChecked;
  EditLoginAccountMemo1.Enabled:=boChecked;
  EditLoginAccountMemo2.Enabled:=boChecked;
  EditLoginAccountEMail.Enabled:=boChecked;
end;

procedure TfrmMain.ButtonLoginAccountOKClick(Sender: TObject);
var
  DBRecord:TAccountDBRecord;
  DefMsg:TDefaultMessage;
  sDefMsg:String;
  sAccount,sPassword,sUserName,sSSNo,sPhone,sQuiz,sAnswer,sEMail,sQuiz2,sAnswer2,sBirthDay,sMobilePhone,sMemo,sMemo2:String;
begin
  sAccount     :=Trim(EditLoginAccount.text);
  sPassword    :=Trim(EditLoginAccountPasswd.Text);
  sUserName    :=Trim(EditLoginAccountUserName.Text);
  sSSNo        :=Trim(EditLoginAccountSSNo.Text);
  sPhone       :=Trim(EditLoginAccountPhone.Text);
  sQuiz        :=Trim(EditLoginAccountQuiz.Text);
  sAnswer      :=Trim(EditLoginAccountAnswer.Text);
  sEMail       :=Trim(EditLoginAccountEMail.Text);
  sQuiz2       :=Trim(EditLoginAccountQuiz2.Text);
  sAnswer2     :=Trim(EditLoginAccountAnswer2.Text);
  sBirthDay    :=Trim(EditLoginAccountBirthDay.Text);
  sMobilePhone :=Trim(EditLoginAccountMobilePhone.Text);
  sMemo        :=Trim(EditLoginAccountMemo1.Text);
  sMemo2       :=Trim(EditLoginAccountMemo2.Text);
  if sAccount = '' then begin
    Application.MessageBox('帐号不能不空！！！','提示信息',MB_OK + MB_ICONERROR);
    EditLoginAccount.SetFocus;
    exit;
  end;
  if sPassword = '' then begin
    Application.MessageBox('密码不能不空！！！','提示信息',MB_OK + MB_ICONERROR);
    EditLoginAccountPasswd.SetFocus;
    exit;
  end;
  FillChar(DBRecord,SizeOf(DBRecord),0);
  DBRecord.UserEntry.sAccount:=sAccount;
  DBRecord.UserEntry.sPassword:=sPassword;
  DBRecord.UserEntry.sUserName:=sUserName;
  DBRecord.UserEntry.sSSNo:=sSSNo;
  DBRecord.UserEntry.sPhone:=sPhone;
  DBRecord.UserEntry.sQuiz:=sQuiz;
  DBRecord.UserEntry.sAnswer:=sAnswer;
  DBRecord.UserEntry.sEMail:=sEMail;
  DBRecord.UserEntryAdd.sQuiz2:=sQuiz2;
  DBRecord.UserEntryAdd.sAnswer2:=sAnswer2;
  DBRecord.UserEntryAdd.sBirthDay:=sBirthDay;
  DBRecord.UserEntryAdd.sMobilePhone:=sMobilePhone;
  DBRecord.UserEntryAdd.sMemo:=sMemo;
  DBRecord.UserEntryAdd.sMemo2:=sMemo2;
  DefMsg:=MakeDefaultMsg(0,0,0,0,0);
  SendProgramMsg(LoginServer.MainFormHandle,GS_CHANGEACCOUNTINFO,EncodeMessage(DefMsg) +  EncodeBuffer(@DBRecord,SizeOf(DBRecord)));
  ButtonLoginAccountOK.Enabled:=False;
end;
procedure TfrmMain.ProcessLoginSrvChangeUserAccountStatus(sData: String);
var
  DefMsg:TDefaultMessage;
  sDefMsg:String;
begin
  if Length(sData) < DEFBLOCKSIZE then exit;
  sDefMsg:=Copy(sData,1,DEFBLOCKSIZE);
  sData:=Copy(sData,DEFBLOCKSIZE+1,Length(sData)-DEFBLOCKSIZE);
  DefMsg:=DecodeMessage(sDefMsg);
  case DefMsg.Recog of    //
    -1: Application.MessageBox('指定的帐号不存在！！！','提示信息',MB_OK + MB_ICONERROR);
    1:  Application.MessageBox('帐号更新成功...','提示信息',MB_OK + MB_ICONINFORMATION);
    2:  Application.MessageBox('帐号更新失败！！！','提示信息',MB_OK + MB_ICONINFORMATION);
  end;    // case
end;

procedure TfrmMain.RefGameDebug;
var
  CheckCode:TCheckCode;
  dwReturn:LongWord;
begin
  EditM2CheckCodeAddr.Text:=IntToHex(g_dwM2CheckCodeAddr,2);
  FillChar(CheckCode,SizeOf(CheckCode),0);
  ReadProcessMemory(M2Server.ProcessHandle,Pointer(g_dwM2CheckCodeAddr),@CheckCode,SizeOf(CheckCode),dwReturn);
  if dwReturn = SizeOf(CheckCode) then begin
    EditM2CheckCode.Text:=IntToStr(CheckCode.dwThread0);
    EditM2CheckStr.Text:=String(CheckCode.sThread0);
  end;

  EditDBCheckCodeAddr.Text:=IntToHex(g_dwDBCheckCodeAddr,2);
  FillChar(CheckCode,SizeOf(CheckCode),0);
  ReadProcessMemory(DBServer.ProcessHandle,Pointer(g_dwDBCheckCodeAddr),@CheckCode,SizeOf(CheckCode),dwReturn);
  if dwReturn = SizeOf(CheckCode) then begin
    EditDBCheckCode.Text:=IntToStr(CheckCode.dwThread0);
    EditDBCheckStr.Text:=String(CheckCode.sThread0);
  end;
end;

procedure TfrmMain.TimerCheckDebugTimer(Sender: TObject);
begin
  RefGameDebug();
end;

procedure TfrmMain.ButtonM2SuspendClick(Sender: TObject);
begin
  SuspendThread(M2Server.ProcessInfo.hThread);
end;

end.
