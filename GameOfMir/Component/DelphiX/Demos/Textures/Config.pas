unit Config;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DXDraws, DXClass;

type
  TConfigForm = class(TForm)
    AutomaticButton: TRadioButton;
    ManualButton: TRadioButton;
    Bevel1: TBevel;
    DriverBox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    DisplayModeBox: TComboBox;
    HardwareCheckBox: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    FullScreenButton: TCheckBox;
    Bevel2: TBevel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DriverBoxClick(Sender: TObject);
    procedure DisplayModeBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
    DXDraw: TDXDraw;
  end;

var
  ConfigForm: TConfigForm;

implementation

{$R *.DFM}

procedure TConfigForm.FormShow(Sender: TObject);
var
  i: Integer;
  Mode: TDXDrawDisplayMode;
begin
  for i:=0 to TDXDraw.Drivers.Count-1 do
    DriverBox.Items.AddObject(TDXDraw.Drivers[i].Description, TDXDraw.Drivers[i]);
  DriverBox.ItemIndex := 0;

  for i:=0 to DXDraw.Display.Count-1 do
  begin
    Mode := DXDraw.Display[i];
    with Mode do
      DisplayModeBox.Items.AddObject(Format('%dx%d %dbit', [Width, Height, BitCount]), Mode);
  end;

  DisplayModeBox.ItemIndex := DisplayModeBox.Items.IndexOf('640x480 16bit');
end;

procedure TConfigForm.Button1Click(Sender: TObject);
var
  Mode: TDXDrawDisplayMode;
begin
  if ManualButton.Checked then
  begin
    DXDraw.Options := DXDraw.Options - [doSelectDriver];
    DXDraw.Driver := TDirectXDriver(DriverBox.Items.Objects[DriverBox.ItemIndex]).GUID;

    Mode := TDXDrawDisplayMode(DisplayModeBox.Items.Objects[DisplayModeBox.ItemIndex]);

    DXDraw.Display.Width := Mode.Width;
    DXDraw.Display.Height := Mode.Height;
    DXDraw.Display.BitCount := Mode.BitCount;

    if FullScreenButton.Checked then begin
      DXDraw.Options := DXDraw.Options + [doFullScreen];
      DXDraw.Options := DXDraw.Options - [doFlip];
    end
    else begin
      DXDraw.Options := DXDraw.Options - [doFullScreen];
      DXDraw.Options := DXDraw.Options + [doFlip];
    end;
    
    if HardwareCheckBox.Checked then
      DXDraw.Options := DXDraw.Options + [doHardware]
    else
      DXDraw.Options := DXDraw.Options - [doHardware];
  end;

  Tag := 1;
  Close;
end;

procedure TConfigForm.Button2Click(Sender: TObject);
begin                
  Close;
end;

procedure TConfigForm.DriverBoxClick(Sender: TObject);
begin
  ManualButton.Checked := True;
end;

procedure TConfigForm.DisplayModeBoxClick(Sender: TObject);
begin
  ManualButton.Checked := True;
  FullScreenButton.Checked := True;
end;

end.
