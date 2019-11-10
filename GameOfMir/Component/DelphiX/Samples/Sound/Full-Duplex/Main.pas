unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, DXSounds;

type
  TMainForm = class(TForm)
    DXSound: TDXSound;
    PanTrackBar: TTrackBar;
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    FileEnd: TMenuItem;
    VolumeTrackBar: TTrackBar;
    PanLabel: TLabel;
    VolumeLabel: TLabel;
    Bevel1: TBevel;
    O1: TMenuItem;
    GlobalFocusItem: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure PanTrackBarChange(Sender: TObject);
    procedure VolumeTrackBarChange(Sender: TObject);
    procedure FileEndClick(Sender: TObject);
    procedure GlobalFocusItemClick(Sender: TObject);
    procedure DXSoundFinalize(Sender: TObject);
    procedure DXSoundInitialize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FUpdating: Boolean;
    procedure UpdateView;
  public
    Audio: TAudioStream;
    Capture: TSoundCaptureStream;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.DXSoundInitialize(Sender: TObject);
begin
  Capture := TSoundCaptureStream.Create(nil);

  Capture.CaptureFormat := Capture.SupportedFormats.Count-1;
  Capture.Start;

  Audio := TAudioStream.Create(DXSound.DSound);
  Audio.WaveStream := Capture;
  Audio.AutoUpdate := True;
  Audio.BufferLength := 100;
  Audio.Play;

  UpdateView;

  PanTrackBar.Enabled := True;
  VolumeTrackBar.Enabled := True;

  FUpdating := True;
  try
    PanTrackBar.Position := Audio.Pan;
    VolumeTrackBar.Position := Audio.Volume;
  finally
    FUpdating := False;
  end;
end;

procedure TMainForm.DXSoundFinalize(Sender: TObject);
begin
  Audio.Free; Audio := nil;
  Capture.Free; Capture := nil;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  UpdateView;
end;

procedure TMainForm.PanTrackBarChange(Sender: TObject);
begin
  if not FUpdating then
  begin
    Audio.Pan := PanTrackBar.Position*100;
    UpdateView;
  end;
end;

procedure TMainForm.VolumeTrackBarChange(Sender: TObject);
begin
  if not FUpdating then
  begin
    Audio.Volume := VolumeTrackBar.Position*100;
    UpdateView;
  end;
end;

procedure TMainForm.UpdateView;
begin
  if Audio<>nil then
  begin
    PanLabel.Caption := Format('Pan: %ddB', [Audio.Pan div 100]);
    VolumeLabel.Caption := Format('Volume: %ddB', [Audio.Volume div 100]);
  end;
end;

procedure TMainForm.FileEndClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.GlobalFocusItemClick(Sender: TObject);
begin
  GlobalFocusItem.Checked := not GlobalFocusItem.Checked;

  if GlobalFocusItem.Checked then
    DXSound.Options := DXSound.Options + [soGlobalFocus]
  else
    DXSound.Options := DXSound.Options - [soGlobalFocus];

  if Audio<>nil then
  begin
    {  Buffer re-making  }
    Audio.RecreateBuf;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  {  Because I want to display the exception,  AutoInitialize professional patty is not used.  }
  try
    DXSound.Initialize;
  except
    on E: Exception do
    begin
      Application.ShowMainForm := False;
      Application.HandleException(E);
      Application.Terminate;
    end;
  end;
end;

end.
