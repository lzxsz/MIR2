unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DXInput, DXClass, ComCtrls;

type
  TMainForm = class(TForm)                            
    DXInput: TDXInput;
    TrackBar1: TTrackBar;
    Label1: TLabel;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DXInput.Joystick.Effects.Find('Condition').Start;
end;

procedure TMainForm.TrackBar1Change(Sender: TObject);
begin
  with DXInput.Joystick.Effects.Find('Condition') do
    Condition := Point(TrackBar1.Position*1000, TrackBar1.Position*1000);
end;

end.

