unit SSaver_config;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  jpeg, ExtCtrls, StdCtrls, Spin, ShellAPI;

type
  TSConfig = class(TForm)
    res: TComboBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    GroupBox: TGroupBox;
    num: TSpinEdit;
    rand: TCheckBox;
    Label2: TLabel;
    mail: TLabel;
    Image: TImage;
    back: TCheckBox;
    procedure mailMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure randClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mailClick(Sender: TObject);
    procedure backClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SConfig: TSConfig;

implementation

uses SSaver_main, Global_func;

{$R *.DFM}

procedure TSConfig.mailMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
with mail.font do
  begin
  Color := clRed;
  Style := Style + [fsUnderline];
  end;
end;

procedure TSConfig.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
with mail.font do
  begin
  Color := clBlue;
  Style := Style - [fsUnderline];
  end;
end;

procedure TSConfig.Button3Click(Sender: TObject);
begin
Close;
end;

procedure TSConfig.Button2Click(Sender: TObject);
begin
  TestMode := True;
  Random_num := rand.Checked;
  Draw_back := back.Checked;
  Lights := num.Value;
  Resolution := res.Items[res.itemindex];
  MainForm := TMainForm.Create(Application);
  MainForm.ShowModal;
  MainForm.Free;
  SetFocus;
  TestMode := False;
end;

procedure TSConfig.randClick(Sender: TObject);
begin
random_num := rand.checked;
Num.Enabled := not rand.Checked;
end;

procedure TSConfig.Button1Click(Sender: TObject);
begin
resolution := res.Items[res.itemindex];
lights := num.Value;
WriteIniFile;
Close;
end;

procedure TSConfig.FormCreate(Sender: TObject);
begin
ReadIniFile;
res.ItemIndex := res.Items.IndexOf(resolution);
rand.Checked := random_num;
num.Value := lights;
Num.Enabled := not random_num;
back.Checked := draw_back;
end;

procedure TSConfig.mailClick(Sender: TObject);
begin
ShellExecute(handle, 'open', 'mailto:keeper@milnet.co.yu?subject=Dancing Lights', nil, nil, SW_NORMAL);
end;

procedure TSConfig.backClick(Sender: TObject);
begin
draw_back := back.Checked;
end;

end.
