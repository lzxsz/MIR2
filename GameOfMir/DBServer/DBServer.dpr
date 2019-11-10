program DBServer;

uses
  Forms,
  DBPWDlg in 'DBPWDlg.pas' {PasswordDialog},
  DBLogDlg in 'DBLogDlg.pas' {LoginDialog},
  qrfilename in 'qrfilename.pas' {FrmQueryFileName},
  passwd in 'passwd.pas' {PasswordDlg},
  viewrcd in 'viewrcd.pas' {FrmFDBViewer},
  newchr in 'newchr.pas' {FrmNewChr},
  frmcpyrcd in 'frmcpyrcd.pas' {FrmCopyRcd},
  CreateId in 'CreateId.pas' {FrmCreateId},
  CreateChr in 'CreateChr.pas' {FrmCreateChr},
  FSMemo in 'FSMemo.pas' {FrmSysMemo},
  FAccount in 'FAccount.pas' {FrmAccountForm},
  FeeUtil in 'FeeUtil.pas' {FrmFeeUtil},
  CliMain in 'CliMain.pas' {FrmAccServer},
  FIDHum in 'FIDHum.pas' {FrmIDHum},
  IDSocCli in 'IDSocCli.pas' {FrmIDSoc},
  UsrSoc in 'UsrSoc.pas' {FrmUserSoc},
  FDBexpl in 'FDBexpl.pas' {FrmFDBExplore},
  AddrEdit in 'AddrEdit.pas' {FrmEditAddr},
  DBSMain in 'DBSMain.pas' {FrmDBSrv},
  FrmInID in 'FrmInID.pas' {FrmInputID},
  HumDB in 'HumDB.pas',
  DBShare in 'DBShare.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  MudUtil in '..\Common\MudUtil.pas',
  DBTools in 'DBTools.pas' {frmDBTool},
  SDK in '..\SDK\SDK.pas',
  EDcode in '..\Common\EDCode.pas',
  DataManage in 'DataManage.pas' {frmDataManage},
  EditRcd in 'EditRcd.pas' {frmEditRcd},
  TestSelGate in 'TestSelGate.pas' {frmTestSelGate},
  RouteManage in 'RouteManage.pas' {frmRouteManage},
  RouteEdit in 'RouteEdit.pas' {frmRouteEdit};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmDBSrv, FrmDBSrv);
  Application.CreateForm(TFrmFDBViewer, FrmFDBViewer);
  Application.CreateForm(TFrmNewChr, FrmNewChr);
  Application.CreateForm(TFrmCopyRcd, FrmCopyRcd);
  Application.CreateForm(TFrmCreateId, FrmCreateId);
  Application.CreateForm(TFrmCreateChr, FrmCreateChr);
  Application.CreateForm(TFrmIDHum, FrmIDHum);
  Application.CreateForm(TFrmIDSoc, FrmIDSoc);
  Application.CreateForm(TFrmUserSoc, FrmUserSoc);
  Application.CreateForm(TFrmFDBExplore, FrmFDBExplore);
  Application.CreateForm(TFrmInputID, FrmInputID);
  Application.CreateForm(TFrmCreateChr, FrmCreateChr);
  Application.CreateForm(TFrmEditAddr, FrmEditAddr);
  Application.CreateForm(TfrmDBTool, frmDBTool);
  Application.CreateForm(TfrmEditRcd, frmEditRcd);
  Application.CreateForm(TfrmRouteManage, frmRouteManage);
  Application.CreateForm(TfrmRouteEdit, frmRouteEdit);
  Application.Run;
end.
