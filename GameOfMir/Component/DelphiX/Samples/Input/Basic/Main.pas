unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DXInput, DXSounds, DXClass;

type
  TMainForm = class(TForm)
    DXInput1: TDXInput;
    Label1: TLabel;
    Label2: TLabel;
    AnalogMode: TCheckBox;
    POVLabel: TLabel;
    DXWaveList1: TDXWaveList;
    DXSound1: TDXSound;
    Label4: TLabel;
    Timer: TDXTimer;
    procedure TimerTimer(Sender: TObject; LagCount: Integer);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.TimerTimer(Sender: TObject; LagCount: Integer);
begin
  DXInput1.Update;

  if AnalogMode.Checked and ((DXInput1.Joystick.X<>0) or (DXInput1.Joystick.Y<>0)) then
  begin
    {  Analog  }
    Label1.Left := Label1.Left + DXInput1.Joystick.X;
    Label1.Top := Label1.Top + DXInput1.Joystick.Y;
  end else
  begin
    {  Digital  }
    if isLeft in DXInput1.States then
      Label1.Left := Label1.Left - 10;

    if isRight in DXInput1.States then
      Label1.Left := Label1.Left + 10;

    if isUp in DXInput1.States then
      Label1.Top := Label1.Top - 10;

    if isDown in DXInput1.States then
      Label1.Top := Label1.Top + 10;
  end;

  if isButton1 in DXInput1.States then
  begin
    DXWaveList1.Items[0].Play(False);
                                   
    {  Next,  button 1 is invalidated until button 1 is pushed.  }
    DXInput1.States := DXInput1.States - [isButton1];
  end;

  POVLabel.Caption := Format('POV (Point of view): %d', [DXInput1.Joystick.Joystate.rgdwPOV[0]]);
end;

end.
