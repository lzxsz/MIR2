unit MonsterConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Spin;

type
  TfrmMonsterConfig = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox8: TGroupBox;
    Label23: TLabel;
    EditMonOneDropGoldCount: TSpinEdit;
    ButtonGeneralSave: TButton;
    CheckBoxGoldToBag: TCheckBox;
    procedure ButtonGeneralSaveClick(Sender: TObject);
    procedure EditMonOneDropGoldCountChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxGoldToBagClick(Sender: TObject);
  private
    boOpened:Boolean;
    boModValued:Boolean;
    procedure ModValue();
    procedure uModValue();  
    procedure RefGeneralInfo();
    { Private declarations }
  public
    procedure Open;
    { Public declarations }
  end;

var
  frmMonsterConfig: TfrmMonsterConfig;

implementation

uses M2Share, SDK;

{$R *.dfm}

{ TfrmMonsterConfig }

procedure TfrmMonsterConfig.ModValue;
begin
  boModValued:=True;
  ButtonGeneralSave.Enabled:=True;
end;

procedure TfrmMonsterConfig.uModValue;
begin
  boModValued:=False;
  ButtonGeneralSave.Enabled:=False;
end;

procedure TfrmMonsterConfig.FormCreate(Sender: TObject);
begin
{$IF SoftVersion = VERDEMO}
  Caption:='游戏参数[演示版本，所有设置调整有效，但不能保存]'
{$IFEND}
end;

procedure TfrmMonsterConfig.Open;
begin
  boOpened:=False;
  uModValue();
  RefGeneralInfo();
  boOpened:=True;
  PageControl1.ActivePageIndex:=0;
  ShowModal;
end;

procedure TfrmMonsterConfig.RefGeneralInfo;
begin
  EditMonOneDropGoldCount.Value:=g_Config.nMonOneDropGoldCount;
end;


procedure TfrmMonsterConfig.ButtonGeneralSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup','MonOneDropGoldCount', g_Config.nMonOneDropGoldCount);
  Config.WriteBool('Setup','DropGoldToPlayBag',g_Config.boDropGoldToPlayBag);
{$IFEND}
  uModValue();
end;

procedure TfrmMonsterConfig.EditMonOneDropGoldCountChange(Sender: TObject);
begin
  if EditMonOneDropGoldCount.Text = '' then begin
    EditMonOneDropGoldCount.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nMonOneDropGoldCount:=EditMonOneDropGoldCount.Value;
  ModValue();
end;


procedure TfrmMonsterConfig.CheckBoxGoldToBagClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boDropGoldToPlayBag:=CheckBoxGoldToBag.Checked;
  ModValue();
end;

end.



