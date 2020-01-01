unit GShare;

interface
uses
  Windows,Messages,Classes,SysUtils,IniFiles;
type
  TProgram = record
    boGetStart   :Boolean;
    boReStart    :Boolean; //程序异常停止，是否重新启动
    btStartStatus:Byte; //0,1,2,3 未启动，正在启动，已启动,正在关闭
    sProgramFile :String[50];
    sDirectory   :String[100];
    ProcessInfo  :TProcessInformation;
    ProcessHandle:THandle;
    MainFormHandle:THandle;
    nMainFormX     :Integer;
    nMainFormY     :Integer;
  end;
  pTProgram = ^TProgram;
  procedure  LoadConfig();
  function   RunProgram(var ProgramInfo:TProgram;sHandle:String;dwWaitTime:LongWord):LongWord;
  function  StopProgram(var ProgramInfo:TProgram;dwWaitTime:LongWord):Integer;
  procedure SendProgramMsg(DesForm:THandle;wIdent:Word;sSendMsg:String);
var

  g_sServerAddr:String = '0.0.0.0';
  g_nServerPort:Integer = 6350;
  g_SessionList:TStringList;

  g_sGameFile:String = '.\GameList.txt';
  g_sNoticeUrl:String = '';   //'www.mir2.com.cn';
  g_nClientForm:Integer = -1;

  g_IniConf        :TIniFile;
  g_sButtonStartGame        :String = '启动游戏服务器(&S)';
  g_sButtonStopGame         :String = '停止游戏服务器(&T)';
  g_sButtonStopStartGame    :String = '取消启动游戏服务器(&T)';
  g_sButtonStopStopGame     :String = '取消停止游戏服务器(&T)';

  g_sConfFile      :String = '.\Config.ini';
  g_sGameDirectory :String = 'D:\MirServer\';
  g_sHeroDBName    :String = 'HeroDB';
  g_sGameName      :String = '热血传奇';
  g_sGameName1     :String = '热血传奇一';
  g_sAllIPaddr     :String = '0.0.0.0';
  g_sLocalIPaddr   :String = '127.0.0.1';
  g_sExtIPaddr     :String = '127.0.0.1';
  g_boDynamicIPMode               :Boolean = False;
  g_nLimitOnlineUser              :Integer = 2000;  //服务器最高上线人数

  g_sDBServer_ProgramFile         :String = 'DBServer.exe';
  g_sDBServer_Directory           :String = 'DBServer\';
  g_boDBServer_GetStart           :Boolean = True;
  g_sDBServer_ConfigFile          :String = 'dbsrc.ini';
  g_sDBServer_Config_ServerAddr   :String = '127.0.0.1';
  g_nDBServer_Config_ServerPort   :Integer = 6000;
  g_sDBServer_Config_GateAddr     :String = '127.0.0.1';
  g_nDBServer_Config_GatePort     :Integer = 5100;
  g_sDBServer_Config_IDSAddr      :String = '127.0.0.1';
  g_nDBServer_Config_IDSPort      :Integer = 5600;

  g_nDBServer_Config_Interval     :Integer = 1000;
  g_nDBServer_Config_Level1       :Integer = 1;
  g_nDBServer_Config_Level2       :Integer = 7;
  g_nDBServer_Config_Level3       :Integer = 14;
  g_nDBServer_Config_Day1         :Integer = 7;
  g_nDBServer_Config_Day2         :Integer = 62;
  g_nDBServer_Config_Day3         :Integer = 124;
  g_nDBServer_Config_Month1       :Integer = 0;
  g_nDBServer_Config_Month2       :Integer = 0;
  g_nDBServer_Config_Month3       :Integer = 0;

  g_sDBServer_Config_Dir          :String = 'FDB\';
  g_sDBServer_Config_IdDir        :String = 'FDB\';
  g_sDBServer_Config_HumDir       :String = 'FDB\';
  g_sDBServer_Config_FeeDir       :String = 'FDB\';
  g_sDBServer_Config_BackupDir    :String = 'Backup\';
  g_sDBServer_Config_ConnectDir   :String = 'Connection\';
  g_sDBServer_Config_LogDir       :String = 'Log\';
  g_sDBServer_ClearLogDir         :String = 'ClearLog\';

  g_sDBServer_Config_MapFile      :String  = 'D:\mirserver\Mir200\Envir\MapInfo.txt';
  g_boDBServer_Config_ViewHackMsg :Boolean = False;
  g_sDBServer_AddrTableFile       :String  = '!addrtable.txt';
  g_sDBServer_ServerinfoFile      :String  = '!serverinfo.txt';
  g_nDBServer_MainFormX           :Integer = 0;
  g_nDBServer_MainFormY           :Integer = 326;
  g_boDBServer_AutoBackup         :Boolean = False;
  g_boDBServer_BackupClearData    :Boolean = True;
  g_dwDBServer_BackupTime         :LongWord = 7200000;
  g_sDBServer_DBName              :String = 'HeroDB';
  g_boDBServer_ShowItemName       :Boolean = False;
  
  g_sLoginServer_ProgramFile       :String = 'LoginSrv.exe';
  g_sLoginServer_Directory         :String = 'LoginSrv\';
  g_sLoginServer_ConfigFile        :String = 'Logsrv.ini';
  g_boLoginServer_GetStart         :Boolean = True;
  g_sLoginServer_GateAddr          :String = '127.0.0.1';
  g_nLoginServer_GatePort          :Integer = 5500;
  g_sLoginServer_ServerAddr        :String = '127.0.0.1';
  g_nLoginServer_ServerPort        :Integer = 5600;

  g_sLoginServer_MonAddr           :String = '127.0.0.1';
  g_nLoginServer_MonPort           :Integer = 3000;


  g_boLoginServer_EnableGetbackPassword :Boolean = True;
  g_nLoginServer_ReadyServers     :Integer = 0;
  g_boLoginServer_EnableMakingID  :Boolean = True;
  g_boLoginServer_TestServer      :Boolean = True;
  g_boLoginServer_AutoClear       :Boolean = False;
  g_dwLoginServer_AutoClearTime   :LongWord = 1000;


  g_sLoginServer_IdDir            :String = 'IDDB\';
  g_sLoginServer_FeedIDList       :String = 'FeedIDList.txt';
  g_sLoginServer_FeedIPList       :String = 'FeedIPList.txt';
  g_sLoginServer_CountLogDir      :String = 'CountLog\';
  g_sLoginServer_WebLogDir        :String = 'GameWFolder\';
  g_sLoginServer_ChrLogDir        :String = 'ChrLog\';
  g_sLoginServer_IdLogDir         :String = 'IdLog\';

  g_sLoginServer_AddrTableFile    :String = '!addrtable.txt';
  g_sLoginServer_ServeraddrFile   :String = '!serveraddr.txt';
  g_sLoginServerUserLimitFile     :String = '!UserLimit.txt';
  g_sLoginServerFeedIDListFile    :String = 'FeedIDList.txt';
  g_sLoginServerFeedIPListFile    :String = 'FeedIPList.txt';
  g_nLoginServer_MainFormX        :Integer = 251;
  g_nLoginServer_MainFormY        :Integer = 0;
  g_nLoginServer_RouteList        :TList;




  g_sLogServer_ProgramFile        :String = 'LogDataServer.exe';
  g_sLogServer_Directory          :String = 'LogServer\';
  g_boLogServer_GetStart          :Boolean = True;
  g_sLogServer_ConfigFile         :String = 'LogData.ini';
  g_sLogServer_BaseDir            :String = 'BaseDir\';
  g_sLogServer_ServerAddr         :String = '127.0.0.1';
  g_nLogServer_Port               :Integer = 10000;
  g_nLogServer_MainFormX          :Integer = 251;
  g_nLogServer_MainFormY          :Integer = 239;

  g_sM2Server_ProgramFile         :String = 'M2Server.exe';
  g_sM2Server_Directory           :String = 'Mir200\';
  g_boM2Server_GetStart           :Boolean = True;
  g_sM2Server_ConfigFile          :String = '!setup.txt';
  g_sM2Server_AbuseFile           :String = '!abuse.txt';
  g_sM2Server_RunAddrFile         :String = '!runaddr.txt';
  g_sM2Server_ServerTableFile     :String = '!servertable.txt';


  g_nM2Server_ServerNumber        :Integer = 0;
  g_nM2Server_ServerIndex         :Integer = 0;
  g_boM2Server_VentureServer      :Boolean = False;
  g_boM2Server_TestServer         :Boolean = True;
  g_nM2Server_TestLevel           :Integer = 1;
  g_nM2Server_TestGold            :Integer = 0;
  g_boM2Server_ServiceMode        :Boolean = False;
  g_boM2Server_NonPKServer        :Boolean = False;
  g_sM2Server_MsgSrvAddr          :String = '127.0.0.1';
  g_nM2Server_MsgSrvPort          :Integer = 4900;
  g_sM2Server_GateAddr            :String = '127.0.0.1';
  g_nM2Server_GatePort            :Integer = 5000;

  g_sM2Server_BaseDir             :String = 'Share\';
  g_sM2Server_GuildDir            :String = 'GuildBase\Guilds\';
  g_sM2Server_GuildFile           :String = 'GuildBase\Guildlist.txt';
  g_sM2Server_VentureDir          :String = 'ShareV\';
  g_sM2Server_ConLogDir           :String = 'ConLog\';
  g_sM2Server_LogDir              :String = 'Log\';
  g_sM2Server_CastleDir           :String = 'Castle\';
  g_sM2Server_EnvirDir            :String = 'Envir\';
  g_sM2Server_MapDir              :String = 'Map\';
  g_sM2Server_NoticeDir           :String = 'Notice\';
  g_nM2Server_MainFormX          :Integer = 560;
  g_nM2Server_MainFormY          :Integer = 0;

  g_sLoginGate_ProgramFile        :String = 'LoginGate.exe';
  g_sLoginGate_Directory          :String = 'LoginGate\';
  g_boLoginGate_GetStart          :Boolean = True;
  g_sLoginGate_ConfigFile         :String = 'Config.ini';
  g_sLoginGate_ServerAddr         :String = '127.0.0.1';
  g_nLoginGate_ServerPort         :Integer = 5500;
  g_sLoginGate_GateAddr           :String = '0.0.0.0';
  g_nLoginGate_GatePort           :Integer = 7000;
  g_nLoginGate_ShowLogLevel       :Integer = 3;
  g_nLoginGate_MaxConnOfIPaddr    :Integer = 20;
  g_nLoginGate_BlockMethod        :Integer = 0;
  g_nLoginGate_KeepConnectTimeOut :Integer = 60000;
  g_nLoginGate_MainFormX          :Integer = 0;
  g_nLoginGate_MainFormY          :Integer = 0;

  g_sSelGate_ProgramFile        :String = 'SelGate.exe';
  g_sSelGate_Directory          :String = 'SelGate\';
  g_boSelGate_GetStart          :Boolean = True;
  g_sSelGate_ConfigFile         :String = 'Config.ini';
  g_sSelGate_ServerAddr         :String = '127.0.0.1';
  g_nSelGate_ServerPort         :Integer = 5100;
  g_sSelGate_GateAddr           :String = '0.0.0.0';
  g_nSelGate_GatePort           :Integer = 7100;
  g_sSelGate_GateAddr1          :String = '0.0.0.0';
  g_nSelGate_GatePort1          :Integer = 7100;
  g_nSelGate_ShowLogLevel       :Integer = 3;
  g_nSelGate_MaxConnOfIPaddr    :Integer = 20;
  g_nSelGate_BlockMethod        :Integer = 0;
  g_nSelGate_KeepConnectTimeOut :Integer = 60000;
  g_nSelGate_MainFormX          :Integer = 0;
  g_nSelGate_MainFormY          :Integer = 163;

  g_sRunGate_ProgramFile          :String = 'RunGate.exe';
  g_sRunGate_Directory            :String = 'RunGate\';
  g_boRunGate_GetStart            :Boolean = True;
  g_boRunGate1_GetStart           :Boolean = True;
  g_boRunGate2_GetStart           :Boolean = True;
  g_boRunGate3_GetStart           :Boolean = True;
  g_boRunGate4_GetStart           :Boolean = True;
  g_boRunGate5_GetStart           :Boolean = True;
  g_boRunGate6_GetStart           :Boolean = True;
  g_boRunGate7_GetStart           :Boolean = True;
  g_sRunGate_ConfigFile           :String = 'Config.ini';
  g_nRunGate_Count                :Integer = 1;
  g_sRunGate_ServerAddr           :String = '127.0.0.1';
  g_nRunGate_ServerPort           :Integer = 5000;
  g_sRunGate_GateAddr             :String = '0.0.0.0';
  g_nRunGate_GatePort             :Integer = 7200;
  g_sRunGate1_GateAddr            :String = '0.0.0.0';
  g_nRunGate1_GatePort            :Integer = 7300;
  g_sRunGate2_GateAddr            :String = '0.0.0.0';
  g_nRunGate2_GatePort            :Integer = 7400;
  g_sRunGate3_GateAddr            :String = '0.0.0.0';
  g_nRunGate3_GatePort            :Integer = 7500;
  g_sRunGate4_GateAddr            :String = '0.0.0.0';
  g_nRunGate4_GatePort            :Integer = 7600;
  g_sRunGate5_GateAddr            :String = '0.0.0.0';
  g_nRunGate5_GatePort            :Integer = 7700;
  g_sRunGate6_GateAddr            :String = '0.0.0.0';
  g_nRunGate6_GatePort            :Integer = 7800;
  g_sRunGate7_GateAddr            :String = '0.0.0.0';
  g_nRunGate7_GatePort            :Integer = 7900;

  DBServer       :TProgram;
  LoginServer    :TProgram;
  LogServer      :TProgram;
  M2Server       :TProgram;
  RunGate        :TProgram;
  RunGate1       :TProgram;
  RunGate2       :TProgram;
  RunGate3       :TProgram;
  RunGate4       :TProgram;
  RunGate5       :TProgram;
  RunGate6       :TProgram;
  RunGate7       :TProgram;
  
  SelGate        :TProgram;
  SelGate1       :TProgram;
  LoginGate      :TProgram;
  LoginGate1     :TProgram;

  g_dwStopTick   :LongWord;
  g_dwStopTimeOut :LongWord = 10000;
  g_boShowDebugTab:Boolean = False;
  g_dwM2CheckCodeAddr:LongWord;
  g_dwDBCheckCodeAddr:LongWord;
implementation
procedure  LoadConfig();
begin
  g_dwStopTimeOut:=g_IniConf.ReadInteger('GameConf','dwStopTimeOut',g_dwStopTimeOut);
  g_boShowDebugTab:=g_Iniconf.ReadBool('GameConf','ShowDebugTab',g_boShowDebugTab);
  g_sGameDirectory:=g_IniConf.ReadString('GameConf','GameDirectory',g_sGameDirectory);
  g_sHeroDBName:=g_IniConf.ReadString('GameConf','HeroDBName',g_sHeroDBName);
  g_sGameName:=g_IniConf.ReadString('GameConf','GameName',g_sGameName);
  g_sExtIPaddr:=g_IniConf.ReadString('GameConf','ExtIPaddr',g_sExtIPaddr);
  g_boDynamicIPMode:=g_IniConf.ReadBool('GameConf','DynamicIPMode',g_boDynamicIPMode);
  g_nDBServer_MainFormX:=g_IniConf.ReadInteger('DBServer','MainFormX',g_nDBServer_MainFormX);
  g_nDBServer_MainFormY:=g_IniConf.ReadInteger('DBServer','MainFormY',g_nDBServer_MainFormY);
  g_nDBServer_Config_GatePort:=g_IniConf.ReadInteger('DBServer','GatePort',g_nDBServer_Config_GatePort);
  g_nDBServer_Config_ServerPort:=g_IniConf.ReadInteger('DBServer','ServerPort',g_nDBServer_Config_ServerPort);
  g_boDBServer_GetStart:=g_IniConf.ReadBool('DBServer','GetStart',g_boDBServer_GetStart);
  g_boDBServer_AutoBackup:=g_IniConf.ReadBool('DBServer','AutoBackup',g_boDBServer_AutoBackup);
  g_boDBServer_BackupClearData:=g_IniConf.ReadBool('DBServer','BackupClearData',g_boDBServer_BackupClearData);
  g_dwDBServer_BackupTime:=g_IniConf.ReadInteger('DBServer','BackupTime',g_dwDBServer_BackupTime);
  g_sDBServer_DBName:=g_IniConf.ReadString('DBServer','DBName',g_sDBServer_DBName);
  g_boDBServer_ShowItemName:=g_IniConf.ReadBool('DBServer','ShowItemName',g_boDBServer_ShowItemName);

  g_nM2Server_MainFormX:=g_IniConf.ReadInteger('M2Server','MainFormX',g_nM2Server_MainFormX);
  g_nM2Server_MainFormY:=g_IniConf.ReadInteger('M2Server','MainFormY',g_nM2Server_MainFormY);
  g_nM2Server_TestLevel:=g_IniConf.ReadInteger('M2Server','TestLevel',g_nM2Server_TestLevel);
  g_nM2Server_TestGold:=g_IniConf.ReadInteger('M2Server','TestGold',g_nM2Server_TestGold);

  g_nM2Server_GatePort:=g_IniConf.ReadInteger('M2Server','GatePort',g_nM2Server_GatePort);
  g_nM2Server_MsgSrvPort:=g_IniConf.ReadInteger('M2Server','MsgSrvPort',g_nM2Server_MsgSrvPort);
  g_boM2Server_GetStart:=g_IniConf.ReadBool('M2Server','GetStart',g_boM2Server_GetStart);

  g_nLoginGate_MainFormX:=g_IniConf.ReadInteger('LoginGate','MainFormX',g_nLoginGate_MainFormX);
  g_nLoginGate_MainFormY:=g_IniConf.ReadInteger('LoginGate','MainFormY',g_nLoginGate_MainFormY);
  g_boLoginGate_GetStart:=g_IniConf.ReadBool('LoginGate','GetStart',g_boLoginGate_GetStart);
  g_nLoginGate_GatePort:=g_IniConf.ReadInteger('LoginGate','GatePort',g_nLoginGate_GatePort);

  g_nSelGate_MainFormX:=g_IniConf.ReadInteger('SelGate','MainFormX',g_nSelGate_MainFormX);
  g_nSelGate_MainFormY:=g_IniConf.ReadInteger('SelGate','MainFormY',g_nSelGate_MainFormY);
  g_nSelGate_GatePort:=g_IniConf.ReadInteger('SelGate','GatePort',g_nSelGate_GatePort);
  g_nSelGate_GatePort1:=g_IniConf.ReadInteger('SelGate','GatePort1',g_nSelGate_GatePort1);
  g_boSelGate_GetStart:=g_IniConf.ReadBool('SelGate','GetStart',g_boSelGate_GetStart);

  g_nRunGate_Count:=g_IniConf.ReadInteger('RunGate','Count',g_nRunGate_Count);
  g_nRunGate_GatePort:=g_IniConf.ReadInteger('RunGate','GatePort1',g_nRunGate_GatePort);
  g_nRunGate1_GatePort:=g_IniConf.ReadInteger('RunGate','GatePort2',g_nRunGate1_GatePort);
  g_nRunGate2_GatePort:=g_IniConf.ReadInteger('RunGate','GatePort3',g_nRunGate2_GatePort);
  g_nRunGate3_GatePort:=g_IniConf.ReadInteger('RunGate','GatePort4',g_nRunGate3_GatePort);
  g_nRunGate4_GatePort:=g_IniConf.ReadInteger('RunGate','GatePort5',g_nRunGate4_GatePort);
  g_nRunGate5_GatePort:=g_IniConf.ReadInteger('RunGate','GatePort6',g_nRunGate5_GatePort);
  g_nRunGate6_GatePort:=g_IniConf.ReadInteger('RunGate','GatePort7',g_nRunGate6_GatePort);
  g_nRunGate7_GatePort:=g_IniConf.ReadInteger('RunGate','GatePort8',g_nRunGate7_GatePort);

  g_boRunGate1_GetStart:=g_nRunGate_Count >= 2;
  g_boRunGate2_GetStart:=g_nRunGate_Count >= 3;
  g_boRunGate3_GetStart:=g_nRunGate_Count >= 4;
  g_boRunGate4_GetStart:=g_nRunGate_Count >= 5;
  g_boRunGate5_GetStart:=g_nRunGate_Count >= 6;
  g_boRunGate6_GetStart:=g_nRunGate_Count >= 7;
  g_boRunGate7_GetStart:=g_nRunGate_Count >= 8;
  if g_boRunGate4_GetStart then begin
    g_sDBServer_Config_GateAddr:=g_sAllIPaddr;
  end else begin
    g_sDBServer_Config_GateAddr:=g_sLocalIPaddr;
  end;

  g_nLoginServer_MainFormX:=g_IniConf.ReadInteger('LoginServer','MainFormX',g_nLoginServer_MainFormX);
  g_nLoginServer_MainFormY:=g_IniConf.ReadInteger('LoginServer','MainFormY',g_nLoginServer_MainFormY);

  g_sLoginServer_GateAddr:=g_IniConf.ReadString('LoginServer','GateAddr',g_sLoginServer_GateAddr);
  g_nLoginServer_GatePort:=g_IniConf.ReadInteger('LoginServer','GatePort',g_nLoginServer_GatePort);
  g_sLoginServer_ServerAddr:=g_IniConf.ReadString('LoginServer','ServerAddr',g_sLoginServer_ServerAddr);
  g_nLoginServer_ServerPort:=g_IniConf.ReadInteger('LoginServer','ServerPort',g_nLoginServer_ServerPort);
  g_sLoginServer_MonAddr:=g_IniConf.ReadString('LoginServer','MonAddr',g_sLoginServer_MonAddr);
  g_nLoginServer_MonPort:=g_IniConf.ReadInteger('LoginServer','MonPort',g_nLoginServer_MonPort);
  
  g_boLoginServer_GetStart:=g_IniConf.ReadBool('LoginServer','GetStart',g_boLoginServer_GetStart);
  g_boLoginServer_EnableGetbackPassword:=g_IniConf.ReadBool('LoginServer','EnableGetbackPassword',g_boLoginServer_EnableGetbackPassword);
  g_boLoginServer_EnableMakingID:=g_IniConf.ReadBool('LoginServer','EnableMakingID',g_boLoginServer_EnableMakingID);
  g_boLoginServer_TestServer:=g_IniConf.ReadBool('LoginServer','TestServer',g_boLoginServer_TestServer);
  g_boLoginServer_AutoClear:=g_IniConf.ReadBool('LoginServer','AutoClear',g_boLoginServer_AutoClear);
  g_dwLoginServer_AutoClearTime:=g_IniConf.ReadInteger('LoginServer','AutoClearTime',g_dwLoginServer_AutoClearTime);
  g_nLoginServer_ReadyServers:=g_IniConf.ReadInteger('LoginServer','ReadyServers',g_nLoginServer_ReadyServers);

  
  g_nLogServer_MainFormX:=g_IniConf.ReadInteger('LogServer','MainFormX',g_nLogServer_MainFormX);
  g_nLogServer_MainFormY:=g_IniConf.ReadInteger('LogServer','MainFormY',g_nLogServer_MainFormY);
  g_boLogServer_GetStart:=g_IniConf.ReadBool('LogServer','GetStart',g_boLogServer_GetStart);
  g_nLogServer_Port:=g_IniConf.ReadInteger('LogServer','Port',g_nLogServer_Port);
end;
function RunProgram(var ProgramInfo:TProgram;sHandle:String;dwWaitTime:LongWord):LongWord;
var
  StartupInfo:TStartupInfo;
  sCommandLine:String;
  sCurDirectory:String;
begin
  Result:=0;
  FillChar(StartupInfo,SizeOf(TStartupInfo),#0);
  {
  StartupInfo.cb:=SizeOf(TStartupInfo);
  StartupInfo.lpReserved:=nil;
  StartupInfo.lpDesktop:=nil;
  StartupInfo.lpTitle:=nil;
  StartupInfo.dwFillAttribute:=0;
  StartupInfo.cbReserved2:=0;
  StartupInfo.lpReserved2:=nil;
  }
  GetStartupInfo(StartupInfo);
  sCommandLine:=format('%s%s %s %d %d',[ProgramInfo.sDirectory,ProgramInfo.sProgramFile,sHandle,ProgramInfo.nMainFormX,ProgramInfo.nMainFormY]);
  sCurDirectory:=ProgramInfo.sDirectory;
  if not CreateProcess(nil,                //lpApplicationName,
                  PChar(sCommandLine),     //lpCommandLine,
                  nil,                     //lpProcessAttributes,
                  nil,                     //lpThreadAttributes,
                  True,                   //bInheritHandles,
                  0,                       //dwCreationFlags,
                  nil,                     //lpEnvironment,
                  PChar(sCurDirectory),    //lpCurrentDirectory,
                  StartupInfo,             //lpStartupInfo,
                  ProgramInfo.ProcessInfo) then begin //lpProcessInformation

    Result:=GetLastError();
  end;
  Sleep(dwWaitTime);
end;
function StopProgram(var ProgramInfo:TProgram;dwWaitTime:LongWord):Integer;
var
  dwExitCode:LongWord;
begin
  Result:=0;
  if TerminateProcess(ProgramInfo.ProcessHandle,dwExitCode) then begin
    Result:=GetLastError();
  end;
  Sleep(dwWaitTime);
end;
procedure SendProgramMsg(DesForm:THandle;wIdent:Word;sSendMsg:String);
var
  SendData:TCopyDataStruct;
  nParam:Integer;
begin
  nParam:=MakeLong(0,wIdent);
  SendData.cbData:=Length (sSendMsg) + 1;
  GetMem(SendData.lpData,SendData.cbData);
  StrCopy (SendData.lpData, PChar(sSendMsg));
  SendMessage(DesForm,WM_COPYDATA,nParam,Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;
initialization
begin
  g_IniConf:=TIniFile.Create(g_sConfFile);
end;
finalization
begin
  g_IniConf.Free;
end;
end.





















