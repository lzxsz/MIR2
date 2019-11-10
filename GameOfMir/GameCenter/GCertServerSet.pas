unit GCertServerSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmCertServerSet = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditRunGate_Config_RegServerAddr: TEdit;
    Label2: TLabel;
    EditRunGate_Config_RegServerPort: TEdit;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    EditDBServer_Config_RegServerAddr: TEdit;
    EditDBServer_Config_RegServerPort: TEdit;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    EditM2Server_Config_RegServerAddr: TEdit;
    EditM2Server_Config_RegServerPort: TEdit;
    ButtonOK: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
  private
    m_boOpened:Boolean;
    m_boModValued:Boolean;
    procedure ModValue();
    procedure uModValue();
    procedure RefInfo();
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmCertServerSet: TfrmCertServerSet;

implementation

uses GShare, HUtil32;

{$R *.dfm}

procedure TfrmCertServerSet.ModValue;
begin
  m_boModValued:=True;
  ButtonOK.Enabled:=True;
end;

procedure TfrmCertServerSet.uModValue;
begin
  m_boModValued:=False;
  ButtonOK.Enabled:=False;
end;

procedure TfrmCertServerSet.FormCreate(Sender: TObject);
begin
  m_boOpened:=False;
  ButtonOK.Enabled:=False;
end;

procedure TfrmCertServerSet.Open;
begin
  RefInfo();
  ShowModal;
end;

procedure TfrmCertServerSet.RefInfo;
begin
  m_boOpened:=False;
  EditRunGate_Config_RegServerAddr.Text:=g_sRunGate_Config_RegServerAddr;
  EditRunGate_Config_RegServerPort.Text:=IntToStr(g_nRunGate_Config_RegServerPort);

  EditDBServer_Config_RegServerAddr.Text:=g_sDBServer_Config_RegServerAddr;
  EditDBServer_Config_RegServerPort.Text:=IntToStr(g_nDBServer_Config_RegServerPort);

  EditM2Server_Config_RegServerAddr.Text:=g_sM2Server_Config_RegServerAddr;
  EditM2Server_Config_RegServerPort.Text:=IntToStr(g_nM2Server_Config_RegServerPort);
  m_boOpened:=True;
end;



procedure TfrmCertServerSet.ButtonOKClick(Sender: TObject);
var
  sRunGate_Config_RegServerAddr:String;
  nRunGate_Config_RegServerPort:Integer;
  sDBServer_Config_RegServerAddr:String;
  nDBServer_Config_RegServerPort:Integer;
  sM2Server_Config_RegServerAddr:String;
  nM2Server_Config_RegServerPort:Integer;
begin
  sRunGate_Config_RegServerAddr:=Trim(EditRunGate_Config_RegServerAddr.Text);
  nRunGate_Config_RegServerPort:=Str_ToInt(EditRunGate_Config_RegServerPort.Text,-1);
  sDBServer_Config_RegServerAddr:=Trim(EditDBServer_Config_RegServerAddr.Text);
  nDBServer_Config_RegServerPort:=Str_ToInt(EditDBServer_Config_RegServerPort.Text,-1);
  sM2Server_Config_RegServerAddr:=Trim(EditM2Server_Config_RegServerAddr.Text);
  nM2Server_Config_RegServerPort:=Str_ToInt(EditM2Server_Config_RegServerPort.Text,-1);

  if not IsIPaddr(sRunGate_Config_RegServerAddr) then begin
    Application.MessageBox('游戏网关验证服务器地址设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditRunGate_Config_RegServerAddr.SetFocus;
    exit;
  end;
  if (nRunGate_Config_RegServerPort < 0) or (nRunGate_Config_RegServerPort > 65535) then begin
    Application.MessageBox('游戏网关验证服务器端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditRunGate_Config_RegServerPort.SetFocus;
    exit;
  end;

  if not IsIPaddr(sDBServer_Config_RegServerAddr) then begin
    Application.MessageBox('数据库验证服务器地址设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditDBServer_Config_RegServerAddr.SetFocus;
    exit;
  end;
  if (nDBServer_Config_RegServerPort < 0) or (nDBServer_Config_RegServerPort > 65535) then begin
    Application.MessageBox('数据库验证服务器端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditDBServer_Config_RegServerPort.SetFocus;
    exit;
  end;

  if not IsIPaddr(sRunGate_Config_RegServerAddr) then begin
    Application.MessageBox('游戏网关验证服务器地址设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditRunGate_Config_RegServerAddr.SetFocus;
    exit;
  end;
  if (nRunGate_Config_RegServerPort < 0) or (nRunGate_Config_RegServerPort > 65535) then begin
    Application.MessageBox('游戏网关验证服务器端口设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditRunGate_Config_RegServerPort.SetFocus;
    exit;
  end;
  g_sRunGate_Config_RegServerAddr:=sRunGate_Config_RegServerAddr;
  g_nRunGate_Config_RegServerPort:=nRunGate_Config_RegServerPort;
  g_sDBServer_Config_RegServerAddr:=sDBServer_Config_RegServerAddr;
  g_nDBServer_Config_RegServerPort:=nDBServer_Config_RegServerPort;
  g_sM2Server_Config_RegServerAddr:=sM2Server_Config_RegServerAddr;
  g_nM2Server_Config_RegServerPort:=nM2Server_Config_RegServerPort;

  uModValue();
end;

procedure TfrmCertServerSet.EditChange(Sender: TObject);
begin
  if m_boOpened then ModValue();
end;

end.
