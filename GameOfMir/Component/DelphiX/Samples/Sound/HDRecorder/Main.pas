unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXWave, StdCtrls, ExtCtrls, DXClass, DXSounds;

type
  TMainForm = class(TForm)
    StartButton: TButton;
    StopButton: TButton;
    FileNameEdit: TEdit;
    SizeLabel: TLabel;
    FormatBox: TComboBox;
    DriverBox: TComboBox;
    SaveDialog: TSaveDialog;
    BrowseButton: TButton;
    CloseButton: TButton;
    procedure StartButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DriverBoxChange(Sender: TObject);
    procedure BrowseButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
  private
    FCapture: TSoundCaptureStream;
    FWaveStream: TWaveStream;
    procedure CaptureFilledBuffer(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to TSoundCaptureStream.Drivers.Count-1 do
    DriverBox.Items.Add(TSoundCaptureStream.Drivers[i].Description);
  DriverBox.ItemIndex := 0;
  DriverBoxChange(nil);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopButtonClick(nil);
  FCapture.Free; FCapture := nil;
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.DriverBoxChange(Sender: TObject);
const
  ChannelText: array[1..2] of string = ('Mono', 'Stereo');
var
  i: Integer;
begin
  FCapture.Free;
  FCapture := TSoundCaptureStream.Create(nil);

  FormatBox.Items.Clear;
  for i:=0 to FCapture.SupportedFormats.Count-1 do
    with FCapture.SupportedFormats[i] do
      FormatBox.Items.Add(Format('%dHz %dbit %s', [SamplesPerSec, BitsPerSample, ChannelText[Channels]]));

  FormatBox.ItemIndex := FormatBox.Items.Count-1;
end;

procedure TMainForm.StartButtonClick(Sender: TObject);
begin
  StopButtonClick(nil);
  try
    FWaveStream := TWaveFileStream.Create(FileNameEdit.Text, fmCreate);
    with FCapture.SupportedFormats[FormatBox.ItemIndex] do
      FWaveStream.SetPCMFormat(SamplesPerSec, BitsPerSample, Channels);
    FWaveStream.Open(True);

    StartButton.Enabled := False;
    DriverBox.Enabled := False;
    FormatBox.Enabled := False;
    StopButton.Enabled := True;
    BrowseButton.Enabled := False;

    FileNameEdit.Color := clBtnFace;
    FileNameEdit.ReadOnly := True;

    FCapture.OnFilledBuffer := CaptureFilledBuffer;

    FCapture.CaptureFormat := FormatBox.ItemIndex;
    FCapture.Start;
  except
    StopButtonClick(nil);
    raise;
  end;
end;

procedure TMainForm.StopButtonClick(Sender: TObject);
begin
  if FCapture<>nil then FCapture.Stop;
  FWaveStream.Free; FWaveStream := nil;

  StartButton.Enabled := True;
  DriverBox.Enabled := True;
  FormatBox.Enabled := True;
  StopButton.Enabled := False;
  BrowseButton.Enabled := True;

  FileNameEdit.Color := clWindow;
  FileNameEdit.ReadOnly := False;
end;

procedure TMainForm.BrowseButtonClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    FileNameEdit.Text := SaveDialog.FileName;
end;

procedure TMainForm.CaptureFilledBuffer(Sender: TObject);
begin
  FWaveStream.CopyFrom(FCapture, FCapture.FilledSize);
  SizeLabel.Caption := Format('%d byte', [FWaveStream.Size]);
end;

end.
