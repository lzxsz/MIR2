program M2Server;

uses
  Forms,
  Windows,
  Graphics,
  svMain in 'svMain.pas' {FrmMain},
  LocalDB in 'LocalDB.pas' {FrmDB},
  InterServerMsg in 'InterServerMsg.pas' {FrmSrvMsg},
  InterMsgClient in 'InterMsgClient.pas' {FrmMsgClient},
  IdSrvClient in 'IdSrvClient.pas' {FrmIDSoc},
  FSrvValue in 'FSrvValue.pas' {FrmServerValue},
  DBPWDlg in 'DBPWDlg.pas' {PasswordDialog},
  DBLogDlg in 'DBLogDlg.pas' {LoginDialog},
  UsrEngn in 'UsrEngn.pas',
  ObjNpc in 'ObjNpc.pas',
  ObjMon2 in 'ObjMon2.pas',
  ObjMon in 'ObjMon.pas',
  ObjGuard in 'ObjGuard.pas',
  ObjBase in 'ObjBase.pas',
  ObjAxeMon in 'ObjAxeMon.pas',
  NoticeM in 'NoticeM.pas',
  Mission in 'Mission.pas',
  Magic in 'Magic.pas',
  M2Share in 'M2Share.pas',
  ItmUnit in 'ItmUnit.pas',
  Guild in 'Guild.pas',
  FrnEngn in 'FrnEngn.pas',
  Event in 'Event.pas',
  Envir in 'Envir.pas',
  Castle in 'Castle.pas',
  RunDB in 'RunDB.pas',
  RunSock in 'RunSock.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  GeneralConfig in 'GeneralConfig.pas' {frmGeneralConfig},
  GameConfig in 'GameConfig.pas' {frmGameConfig},
  FunctionConfig in 'FunctionConfig.pas' {frmFunctionConfig},
  ObjRobot in 'ObjRobot.pas',
  BnkEngn in 'BnkEngn.pas',
  ViewSession in 'ViewSession.pas' {frmViewSession},
  ViewOnlineHuman in 'ViewOnlineHuman.pas' {frmViewOnlineHuman},
  ViewLevel in 'ViewLevel.pas' {frmViewLevel},
  ViewList in 'ViewList.pas' {frmViewList},
  OnlineMsg in 'OnlineMsg.pas' {frmOnlineMsg},
  HumanInfo in 'HumanInfo.pas' {frmHumanInfo},
  ViewKernelInfo in 'ViewKernelInfo.pas' {frmViewKernelInfo},
  ConfigMerchant in 'ConfigMerchant.pas' {frmConfigMerchant},
  ItemSet in 'ItemSet.pas' {frmItemSet},
  ConfigMonGen in 'ConfigMonGen.pas' {frmConfigMonGen},
  SDK in '..\SDK\SDK.pas',
  EncryptUnit in '..\Common\EncryptUnit.pas',
  GameCommand in 'GameCommand.pas' {frmGameCmd},
  MonsterConfig in 'MonsterConfig.pas' {frmMonsterConfig},
  UnitManage in 'UnitManage.pas',
  JClasses in 'JClasses.pas',
  ActionSpeedConfig in 'ActionSpeedConfig.pas' {frmActionSpeed},
  EDcode in 'EDcode.pas',
  CastleManage in 'CastleManage.pas' {frmCastleManage},
  MD5Unit in 'MD5Unit.pas',
  MudUtil in '..\Common\MudUtil.pas',
  ObjMon3 in 'ObjMon3.pas',
  IP in 'IP.pas' {FormIP},
  AddGuild in 'AddGuild.pas' {FromAddGuild},
  AboutUnit in 'AboutUnit.pas' {FrmAbout},
  ConfigGameShop in 'ConfigGameShop.pas' {frmConfigGameShop};

{$R *.res}

begin
  g_Config.nM2Crc := CalcFileCRC(Application.ExeName);
  Application.Initialize;
  Application.HintPause := 100;
  Application.HintShortPause := 100;
  Application.HintHidePause := 5000;

  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmSrvMsg, FrmSrvMsg);
  Application.CreateForm(TFrmMsgClient, FrmMsgClient);
  Application.CreateForm(TFrmIDSoc, FrmIDSoc);
  Application.CreateForm(TFrmServerValue, FrmServerValue);
  Application.CreateForm(TfrmGameCmd, frmGameCmd);
  Application.CreateForm(TfrmMonsterConfig, frmMonsterConfig);
  Application.CreateForm(TFormIP, FormIP);
  Application.CreateForm(TFromAddGuild, FromAddGuild);
  Application.CreateForm(TFrmAbout, FrmAbout);
  Application.Run;

end.

