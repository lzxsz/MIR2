unit GeneralConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, IniFiles, grobal2;

type
  TfrmGeneralConfig = class(TForm)
    GroupBoxNet: TGroupBox;
    LabelGateIPaddr: TLabel;
    EditGateIPaddr: TEdit;
    EditGatePort: TEdit;
    LabelGatePort: TLabel;
    EditServerPort: TEdit;
    LabelServerPort: TLabel;
    LabelServerIPaddr: TLabel;
    EditServerIPaddr: TEdit;
    GroupBoxInfo: TGroupBox;
    Label1: TLabel;
    EditTitle: TEdit;
    TrackBarLogLevel: TTrackBar;
    LabelShowLogLevel: TLabel;
    LabelShowBite: TLabel;
    ComboBoxShowBite: TComboBox;
    ButtonOK: TButton;
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGeneralConfig: TfrmGeneralConfig;

implementation

uses HUtil32, GateShare;

{$R *.dfm}

procedure TfrmGeneralConfig.ButtonOKClick(Sender: TObject);
var
  sGateIPaddr,sServerIPaddr,sTitle:String;
  nGatePort,nServerPort,nShowBite,nShowLogLv:Integer;
begin
  sGateIPaddr:=Trim(EditGateIPaddr.Text);
  nGatePort:=Str_ToInt(Trim(EditGateport.Text), -1);
  sServerIPaddr:=Trim(EditServerIPaddr.Text);
  nServerPort:=Str_ToInt(Trim(EditServerPort.Text), -1);
  sTitle:=Trim(EditTitle.Text);
  nShowBite:=ComboBoxShowBite.ItemIndex;
  nShowLogLv:=TrackBarLogLevel.Position;

  if not IsIPaddr(sGateIPaddr) then begin
    Application.MessageBox('网关地址设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditGateIPaddr.SetFocus;
    exit;
  end;

  if (nGatePort < 0) or (nGatePort > 65535) then begin
    Application.MessageBox('网关端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditGateport.SetFocus;
    exit;
  end;

  if not IsIPaddr(sServerIPaddr) then begin
    Application.MessageBox('服务器地址设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditServerIPaddr.SetFocus;
    exit;
  end;

  if (nServerPort < 0) or (nServerPort > 65535) then begin
    Application.MessageBox('网关端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditServerPort.SetFocus;
    exit;
  end;
  if sTitle = '' then begin
    Application.MessageBox('标题设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditTitle.SetFocus;
    exit;
  end;
  if nShowBite  < 0 then begin
    Application.MessageBox('无效字节类型选择了...','错误信息',MB_OK + MB_ICONERROR);
    ComboBoxShowBite.SetFocus;
    exit;
  end;
  nShowLogLevel:=nShowLogLv;
  TitleName:=sTitle;
  ServerAddr:=sServerIPaddr;
  ServerPort:=nServerPort;
  GateAddr:=sGateIPaddr;
  GatePort:=nGatePort;
  boShowBite:=Boolean(nShowBite);

  Conf.WriteString(GateClass,'Title',TitleName);
  Conf.WriteString(GateClass,'ServerAddr',ServerAddr);
  Conf.WriteInteger(GateClass,'ServerPort',ServerPort);
  Conf.WriteString(GateClass,'GateAddr',GateAddr);
  Conf.WriteInteger(GateClass,'GatePort',GatePort);

  Conf.WriteInteger(GateClass,'ShowLogLevel',nShowLogLevel);
  Conf.WriteBool(GateClass,'ShowBite',boShowBite);
  Close;
end;

end.
