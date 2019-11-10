unit DXWaveEdit;

interface

uses
  Windows, SysUtils, Classes, Forms, Dialogs, Controls, StdCtrls, ExtCtrls,
  Buttons, ComCtrls, DXSounds, DXWave, Graphics;

type

  {  TDelphiXWaveEditForm  }

  TDelphiXWaveEditForm = class(TForm)
    Bevel2: TBevel;
    OKButton: TButton;
    CancelButton: TButton;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    PlayImage: TImage;
    StopImage: TImage;
    Timer: TTimer;
    DXSound: TDXSound;
    ClearButton: TButton;
    SaveButton: TButton;
    LoadButton: TButton;
    Panel1: TPanel;
    TrackBar: TTrackBar;
    TestButton: TSpeedButton;
    LengthLabel: TLabel;
    FrequencyLabel: TLabel;
    TypeLabel: TLabel;
    SizeLabel: TLabel;
    LengthValueLabel: TLabel;
    FrequencyValueLabel: TLabel;
    TypeValueLabel: TLabel;
    SizeValueLabel: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DXSoundInitialize(Sender: TObject);
    procedure DXSoundFinalize(Sender: TObject);
    procedure TestButtonClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FChanged: Boolean;
    FAudio: TAudioStream;
    FPlaying: Boolean;
    FWaveStream: TCustomWaveStream;
    FWaveFileName: string;
    FUpdating: Boolean;
    procedure UpDateData;
    procedure SetPlaying(Value: Boolean);
    property Playing: Boolean read FPlaying write SetPlaying;
  public
    Wave: TWave;
  end;

var
  DelphiXWaveEditForm: TDelphiXWaveEditForm;

implementation

uses DXConsts;

{$R *.DFM}

procedure TDelphiXWaveEditForm.FormDestroy(Sender: TObject);
begin
  FWaveStream.Free;
end;

procedure TDelphiXWaveEditForm.FormShow(Sender: TObject);
begin
  if Wave.Size>0 then
    FWaveStream := TWaveObjectStream.Create(Wave);

  TestButton.Glyph := PlayImage.Picture.Bitmap;
  UpDateData;
end;

procedure TDelphiXWaveEditForm.OKButtonClick(Sender: TObject);
begin
  Playing := False;

  if FChanged then
  begin
    if FWaveStream=nil then
      Wave.Clear
    else
      Wave.LoadFromFile(FWaveFileName);

    Tag := 1;
  end;

  Close;
end;

procedure TDelphiXWaveEditForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TDelphiXWaveEditForm.ClearButtonClick(Sender: TObject);
begin
  Playing := False;

  FChanged := True;
  FWaveStream.Free; FWaveStream := nil;
  UpdateData;
end;

procedure TDelphiXWaveEditForm.LoadButtonClick(Sender: TObject);
var
  Stream: TWaveFileStream;
begin
  if OpenDialog.Execute then
  begin
    Playing := False;

    Stream := TWaveFileStream.Create(OpenDialog.FileName, fmOpenRead or fmShareDenyWrite);
    Stream.Open(False);

    FWaveStream.Free; FWaveStream := Stream;
    FWaveFileName := OpenDialog.FileName;
    FChanged := True;
    UpdateData;
  end;
end;

procedure TDelphiXWaveEditForm.SaveButtonClick(Sender: TObject);
var
  Dest, Source: TStream;
begin
  if SaveDialog.Execute then
  begin
    Playing := False;

    if FChanged then
    begin
      if AnsiCompareFileName(FWaveFileName, SaveDialog.FileName)=0 then Exit;

      Source := TFileStream.Create(FWaveFileName, fmOpenRead or fmShareDenyWrite);
      try
        Dest := TFileStream.Create(SaveDialog.FileName, fmCreate);
        try
          Dest.CopyFrom(Source, Source.Size);
        finally
          Dest.Free;
        end;
      finally
        Source.Free;
      end;
    end else
    begin
      Wave.SaveToFile(SaveDialog.FileName);
    end;
  end;
end;

procedure TDelphiXWaveEditForm.SetPlaying(Value: Boolean);
begin
  if FPlaying<>Value then
  begin
    if FPlaying then
    begin
      Timer.Enabled := False;
      FAudio.Stop;
      TrackBar.Position := FAudio.Position;
      DXSound.Finalize;
    end;

    if Value then
    begin
      DXSound.Initialize;
      DXSound.Primary.SetFormat(FAudio.Format^);

      FAudio.Position := TrackBar.Position;
      FAudio.Play;

      Timer.Enabled := True;

      TestButton.Glyph := StopImage.Picture.Bitmap
    end else
      TestButton.Glyph := PlayImage.Picture.Bitmap;

    FPlaying := Value;
  end;
end;

procedure TDelphiXWaveEditForm.UpDateData;
begin
  TestButton.Enabled := False;
  TrackBar.Enabled := False;
  Timer.Enabled := False;

  if FWaveStream<>nil then
  begin
    ClearButton.Enabled := True;
    SaveButton.Enabled := True;

    TrackBar.Position := 0;
    TrackBar.Max := FWaveStream.Size;
    TestButton.Enabled := True;
    TrackBar.Enabled := True;

    LengthValueLabel.Caption := Format(SWaveLength, [FWaveStream.Size/FWaveStream.Format^.nAvgBytesPerSec]);

    FrequencyValueLabel.Caption := Format(SWaveFrequency, [FWaveStream.Format^.nSamplesPerSec]);

    TypeValueLabel.Caption := Format(SWaveBitCount, [FWaveStream.Format^.wBitsPerSample]) + ' ';

    case FWaveStream.Format^.nChannels of
      1: TypeValueLabel.Caption := TypeValueLabel.Caption + SWaveMono;
      2: TypeValueLabel.Caption := TypeValueLabel.Caption + SWaveStereo;
    end;

    SizeValueLabel.Caption := Format(SWaveSize, [FWaveStream.Size]);
  end else
  begin
    LengthValueLabel.Caption := Format(SWaveLength, [0.0]);
    FrequencyValueLabel.Caption := Format(SWaveFrequency, [0]);
    TypeValueLabel.Caption := Format(SWaveBitCount, [0]) + ' ' + SWaveMono;
    SizeValueLabel.Caption := Format(SWaveSize, [0]);

    ClearButton.Enabled := False;
    SaveButton.Enabled := False;
    TrackBar.Position := 0;
  end;
end;

procedure TDelphiXWaveEditForm.DXSoundInitialize(Sender: TObject);
begin
  FAudio := TAudioStream.Create(DXSound.DSound);
  FAudio.WaveStream := FWaveStream;
  FAudio.BufferLength := 200;
end;

procedure TDelphiXWaveEditForm.DXSoundFinalize(Sender: TObject);
begin
  FAudio.Free; FAudio := nil;
end;

procedure TDelphiXWaveEditForm.TestButtonClick(Sender: TObject);
begin
  Playing := not Playing;
end;

procedure TDelphiXWaveEditForm.TimerTimer(Sender: TObject);
begin
  FAudio.Update;
  if FAudio.Playing then
  begin
    FUpdating := True;
    try
      TrackBar.Position := FAudio.Position;
    finally
      FUpdating := False;
    end;
  end else
  begin
    Playing := False;
    TrackBar.Position := 0;
  end;
end;

procedure TDelphiXWaveEditForm.TrackBarChange(Sender: TObject);
begin                       
  if (FAudio<>nil) and (not FUpdating) then
    FAudio.Position := TrackBar.Position;
end;


end.
