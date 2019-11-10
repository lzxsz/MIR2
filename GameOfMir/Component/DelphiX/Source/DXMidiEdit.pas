unit DXMidiEdit;

interface

uses
  Windows, SysUtils, Classes, Forms, Dialogs, Controls, StdCtrls, ExtCtrls,
  Buttons, ComCtrls, Graphics, DXSounds;

type

  {  TDelphiXWaveEditForm  }

  TDelphiXMidiEditForm = class(TForm)
    Bevel2: TBevel;
    OKButton: TButton;
    CancelButton: TButton;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    ClearButton: TButton;
    SaveButton: TButton;
    LoadButton: TButton;
    Panel1: TPanel;
    LengthLabel: TLabel;
    SizeLabel: TLabel;
    filenamelabel: TLabel;
    SizeValueLabel: TLabel;
    DXSound1: TDXSound;
    DXMusic1: TDXMusic;
    btnPlay: TBitBtn;
    btnStop: TBitBtn;
    procedure btnStopClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FChanged: Boolean;
    FMidiFileName: string;
    FPlaying: Boolean;
    T: TMusicListCollectionItem;
    procedure UpDateData;
    procedure SetPlaying(const Value: Boolean);
  public
    MidiData: string;
    property MidiFileName: string read FMidiFileName write FMidiFileName;
    property Playing: Boolean read FPlaying write SetPlaying;
  end;

var
  DelphiXMidiEditForm: TDelphiXMidiEditForm;

implementation

uses DXConsts;

{$R *.DFM}

procedure TDelphiXMidiEditForm.FormDestroy(Sender: TObject);
begin
  if Playing then T.Stop;
end;

procedure TDelphiXMidiEditForm.FormShow(Sender: TObject);
begin
  if Length(MidiData) <> 0 then begin
    T := DXMusic1.Midis.Add;
    T.Midi.MusicData := MidiData;
    T.LoadFromFile(MidiFileName);
  end;
  filenamelabel.Caption := MidiFileName;
  SizeValueLabel.Caption := Format('%d bytes', [Length(MidiData)]);
  UpDateData;
end;

procedure TDelphiXMidiEditForm.OKButtonClick(Sender: TObject);
begin
  if FChanged then
  begin
    Tag := 1;
  end;
  Close;
end;

procedure TDelphiXMidiEditForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TDelphiXMidiEditForm.ClearButtonClick(Sender: TObject);
begin
  if Playing then Playing := False;
  SetLength(MidiData, 0);
  MidiFileName := '';
  filenamelabel.Caption := '';
  SizeValueLabel.Caption := '';
  DXMusic1.Midis.Clear;
  FChanged := True;
  UpdateData;
end;

procedure TDelphiXMidiEditForm.LoadButtonClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    if Playing then Playing := False;
    MidiFileName := OpenDialog.FileName;
    filenamelabel.Caption := ExtractFileName(MidiFileName);
    T := DXMusic1.Midis.Add;
    T.LoadFromFile(MidiFileName);
    MidiData := T.Midi.MusicData;
    SizeValueLabel.Caption := Format('%d bytes', [T.Size]);
    FChanged := True;
    UpdateData;
  end;
end;

procedure TDelphiXMidiEditForm.SaveButtonClick(Sender: TObject);
var
  F: file;
begin
  if SaveDialog.Execute then
  begin
    if Playing then Playing := False;
    if Length(MidiData) = 0 then Exit;
    if FChanged then
    begin
      if AnsiCompareFileName(MidiFileName, SaveDialog.FileName)=0 then Exit;
    end;
    AssignFile(F, SaveDialog.FileName);
    Rewrite(F,1);
    try
      BlockWrite(F, MidiData[1], Length(MidiData));
    finally
      CloseFile(F);
    end;
  end;
end;

procedure TDelphiXMidiEditForm.UpDateData;
begin
  if Length(mididata) > 0 then begin
    SaveButton.Enabled := True;
    ClearButton.Enabled := True;
    btnPlay.Enabled := True;
  end
  else begin
    SaveButton.Enabled := False;
    ClearButton.Enabled := False;
    btnPlay.Enabled := false;
  end
end;

procedure TDelphiXMidiEditForm.FormCreate(Sender: TObject);
begin
  Tag := 0;
  FPlaying := False;
end;

procedure TDelphiXMidiEditForm.SetPlaying(const Value: Boolean);
begin
  if not Value then T.Stop;
  FPlaying := Value;
end;

procedure TDelphiXMidiEditForm.btnPlayClick(Sender: TObject);
begin
  FPlaying := True;
  T.Play;
end;

procedure TDelphiXMidiEditForm.btnStopClick(Sender: TObject);
begin
  if Playing then Playing := False;
end;

end.
