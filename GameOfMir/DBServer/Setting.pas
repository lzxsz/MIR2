unit Setting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles;

type
  TFrmSetting = class(TForm)
    GroupBox1: TGroupBox;
    ButtonOK: TButton;
    CheckBoxAttack: TCheckBox;
    CheckBoxDenyChrName: TCheckBox;
    procedure CheckBoxAttackClick(Sender: TObject);
    procedure CheckBoxDenyChrNameClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open();
  end;

var
  FrmSetting: TFrmSetting;

implementation
uses DBShare;
{$R *.dfm}
procedure TFrmSetting.Open();
begin
  CheckBoxAttack.Checked := boAttack;
  CheckBoxDenyChrName.Checked := boDenyChrName;
  ButtonOK.Enabled := False;
  ShowModal;
end;

procedure TFrmSetting.CheckBoxAttackClick(Sender: TObject);
begin
  boAttack := CheckBoxAttack.Checked;
  ButtonOK.Enabled := True;
end;

procedure TFrmSetting.CheckBoxDenyChrNameClick(Sender: TObject);
begin
  boDenyChrName := CheckBoxDenyChrName.Checked;
  ButtonOK.Enabled := True;
end;

procedure TFrmSetting.ButtonOKClick(Sender: TObject);
var
  Conf: TIniFile;
begin
  Conf := TIniFile.Create(sConfFileName);
  if Conf <> nil then begin
    Conf.WriteBool('Setup', 'Attack', boAttack);
    Conf.WriteBool('Setup', 'DenyChrName', boDenyChrName);
    Conf.Free;
    ButtonOK.Enabled := False;
  end;
end;

end.
