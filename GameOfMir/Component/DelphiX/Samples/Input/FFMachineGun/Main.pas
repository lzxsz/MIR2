unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DXInput;

type
  TMainForm = class(TForm)
    Timer: TTimer;
    DXInput1: TDXInput;
    Label1: TLabel;
    procedure TimerTimer(Sender: TObject);
  private
    FOldStates: TDXInputStates;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  DXInput1.Update;
            
  if (isButton1 in DXInput1.States) and (not (isButton1 in FOldStates)) then
  begin
    DXInput1.Joystick.Effects.Find('Machine gun').Start;
  end else                                             
  if (not (isButton1 in DXInput1.States)) and (isButton1 in FOldStates) then
  begin
    DXInput1.Joystick.Effects.Find('Machine gun').Stop;
  end;                                               

  FOldStates := DXInput1.States;
end;

end.
