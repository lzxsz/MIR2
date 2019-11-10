unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, DXSounds, MMSystem, DXWave;

type
  TMainForm = class(TForm)
    DXSound: TDXSound;
    Timer: TTimer;
    PlayButton: TButton;
    PanTrackBar: TTrackBar;
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    FileOpen: TMenuItem;
    FileClose: TMenuItem;
    FileEnd: TMenuItem;
    N1: TMenuItem;
    LoopCheckBox: TCheckBox;
    VolumeTrackBar: TTrackBar;
    FrequencyTrackBar: TTrackBar;
    ProgressTrackBar: TTrackBar;
    StopButton: TButton;
    PanLabel: TLabel;
    VolumeLabel: TLabel;
    FrequencyLabel: TLabel;
    ProgressLabel: TLabel;
    OpenDialog: TOpenDialog;
    Bevel1: TBevel;
    BytesLabel: TLabel;
    PauseButton: TButton;
    O1: TMenuItem;
    GlobalFocusItem: TMenuItem;
    procedure TimerTimer(Sender: TObject);
    procedure FileCloseClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FileOpenClick(Sender: TObject);
    procedure PlayButtonClick(Sender: TObject);
    procedure LoopCheckBoxClick(Sender: TObject);
    procedure PanTrackBarChange(Sender: TObject);
    procedure VolumeTrackBarChange(Sender: TObject);
    procedure FrequencyTrackBarChange(Sender: TObject);
    procedure FileEndClick(Sender: TObject);
    procedure ProgressTrackBarChange(Sender: TObject);
    procedure PauseButtonClick(Sender: TObject);
    procedure DXSoundFinalize(Sender: TObject);
    procedure GlobalFocusItemClick(Sender: TObject);
  private
    FUpdating: Integer;
    procedure ChangeStates;
  public
    Audio: TAudioFileStream;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.DXSoundFinalize(Sender: TObject);
begin
  Audio.Free; Audio := nil;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  ChangeStates;
end;

procedure TMainForm.FileOpenClick(Sender: TObject);
var
  WaveFormat: TWaveFormatEx;
begin
  if not OpenDialog.Execute then Exit;

  FileCloseClick(nil);
  try
    Caption := Application.Title + ' - ' + ExtractFileName(OpenDialog.FileName);

    DXSound.Initialize;

    Audio := TAudioFileStream.Create(DXSound.DSound);
    Audio.AutoUpdate := True;
    Audio.BufferLength := 1000;
    Audio.FileName := OpenDialog.FileName;
    Audio.Looped := LoopCheckBox.Checked;

    {  Setting of format of primary buffer.  }
    MakePCMWaveFormatEx(WaveFormat, 44100, Audio.Format.wBitsPerSample, 2);
    DXSound.Primary.SetFormat(WaveFormat);


    ChangeStates;

    PlayButton.Enabled := True;
    PauseButton.Enabled := False;
    StopButton.Enabled := False;

    LoopCheckBox.Enabled := True;
    PanTrackBar.Enabled := True;
    VolumeTrackBar.Enabled := True;
    FrequencyTrackBar.Enabled := True;
    ProgressTrackBar.Enabled := True;

    Inc(FUpdating);
    try
      PanTrackBar.Position := Audio.Pan;
      VolumeTrackBar.Position := Audio.Volume;
      FrequencyTrackBar.Position := Audio.Frequency;
      ProgressTrackBar.Max := Audio.Size;
      ProgressTrackBar.PageSize := ProgressTrackBar.Max div 25;
    finally
      Dec(FUpdating);
    end;
  except
    FileCloseClick(nil);
    raise;
  end;
end;

procedure TMainForm.FileCloseClick(Sender: TObject);
begin
  Timer.Enabled := False;

  DXSound.Finalize;

  Caption := Application.Title;

  PlayButton.Enabled := False;
  PauseButton.Enabled := False;
  StopButton.Enabled := False;

  LoopCheckBox.Enabled := False;
  PanTrackBar.Enabled := False;
  VolumeTrackBar.Enabled := False;
  FrequencyTrackBar.Enabled := False;
  ProgressTrackBar.Enabled := False;

  ChangeStates;
end;

procedure TMainForm.PanTrackBarChange(Sender: TObject);
begin
  if FUpdating=0 then
  begin
    Audio.Pan := PanTrackBar.Position*100;
    ChangeStates;
  end;
end;

procedure TMainForm.VolumeTrackBarChange(Sender: TObject);
begin
  if FUpdating=0 then
  begin
    Audio.Volume := VolumeTrackBar.Position*100;
    ChangeStates;
  end;
end;

procedure TMainForm.FrequencyTrackBarChange(Sender: TObject);
begin
  if FUpdating=0 then
  begin
    Audio.Frequency := FrequencyTrackBar.Position;
    ChangeStates;
  end;
end;

procedure TMainForm.LoopCheckBoxClick(Sender: TObject);
begin
  Audio.Looped := LoopCheckBox.Checked;
end;

procedure TMainForm.PlayButtonClick(Sender: TObject);
begin
  Audio.Play;

  PlayButton.Enabled := False;
  PauseButton.Enabled := True;
  StopButton.Enabled := True;
  Timer.Enabled := True;
end;

procedure TMainForm.PauseButtonClick(Sender: TObject);
begin
  Audio.Stop;

  PlayButton.Enabled := True;
  PauseButton.Enabled := False;
  StopButton.Enabled := False;
  Timer.Enabled := False;

  ChangeStates;
end;

procedure TMainForm.StopButtonClick(Sender: TObject);
begin
  Audio.Stop;
  Audio.Position := 0;

  PlayButton.Enabled := True;
  PauseButton.Enabled := False;
  StopButton.Enabled := False;
  Timer.Enabled := False;

  ChangeStates;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  if Audio.Playing then
  begin
    ChangeStates;
  end else
  begin
    Audio.Position := 0;
    StopButtonClick(nil);
  end;
end;

procedure TMainForm.ChangeStates;
var
  s: Integer;
begin
  if Audio<>nil then
  begin                                                                                        
    s := (Audio.Position div Audio.Format.nBlockAlign) div Integer(Audio.Format.nSamplesPerSec);

    PanLabel.Caption := Format('Pan: %ddB', [Audio.Pan div 100]);
    VolumeLabel.Caption := Format('Volume: %ddB', [Audio.Volume div 100]);
    FrequencyLabel.Caption := Format('Frequency: %dHz', [Audio.Frequency]);
    ProgressLabel.Caption := Format('Time: %.2d:%.2d:%.2d', [(s div 60) div 60, (s div 60) mod 60, s mod 60]);

    Inc(FUpdating);
    try
      ProgressTrackBar.Position := Audio.Position;
    finally
      Dec(FUpdating);
    end;

    BytesLabel.Caption := Format('%d Bytes', [Audio.Position]);
  end else
  begin
    PanLabel.Caption := 'Pan';
    VolumeLabel.Caption := 'Volume';
    FrequencyLabel.Caption := 'Frequency';
    ProgressLabel.Caption := 'Time';
    BytesLabel.Caption := 'Bytes';
  end;
end;

procedure TMainForm.FileEndClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.ProgressTrackBarChange(Sender: TObject);
begin
  if FUpdating=0 then
  begin
    Audio.Position := ProgressTrackBar.Position;
    ChangeStates;
  end;
end;

procedure TMainForm.GlobalFocusItemClick(Sender: TObject);
var
  OldPlaying: Boolean;
  OldEnabled: Boolean;
begin
  GlobalFocusItem.Checked := not GlobalFocusItem.Checked;

  if GlobalFocusItem.Checked then
    DXSound.Options := DXSound.Options + [soGlobalFocus]
  else
    DXSound.Options := DXSound.Options - [soGlobalFocus];

  if Audio<>nil then
  begin
    {  Buffer re-making  }
    OldEnabled := Timer.Enabled;
    Timer.Enabled := False;
    try
      OldPlaying := Audio.Playing;
      Audio.Stop;
      Application.ProcessMessages;
      Audio.RecreateBuf;
      if OldPlaying then Audio.Play;
    finally
      Timer.Enabled := OldEnabled;
    end;
  end;
end;

end.
