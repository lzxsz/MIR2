unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DIB, StdCtrls, ExtCtrls, ComCtrls, ToolWin, Menus, Buttons, ImgList, CheckLst,
  Spin, ExtDlgs, DXSounds;

type
  TMain = class(TForm)
    Splitter1: TSplitter;
    ItemPanel: TPanel;
    Splitter2: TSplitter;
    PicturePanel: TPanel;
    MainControlBar: TControlBar;
    MainToolBar: TToolBar;
    IconImageList: TImageList;
    OpenButton: TToolButton;
    SaveButton: TToolButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    StatusBar: TStatusBar;
    ImageBar: TToolBar;
    ImageDel: TToolButton;
    ImageDown: TToolButton;
    ImageUp: TToolButton;
    sep3: TToolButton;
    AddWAV: TToolButton;
    sep1: TToolButton;
    sep7: TToolButton;
    Info: TToolButton;
    CheckAll: TToolButton;
    sep8: TToolButton;
    PropBar: TToolBar;
    PlayWav: TToolButton;
    WaveListBox: TCheckListBox;
    New: TToolButton;
    sep2: TToolButton;
      Name: TEdit;
    ToolButton1: TToolButton;
    UpdateName: TToolButton;
    DXWaveList: TDXWaveList;
    Panel1: TPanel;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    DXSound1: TDXSound;
    StopMusic: TToolButton;
    procedure OpenButtonClick(Sender: TObject);
    procedure WaveListBoxClick(Sender: TObject);
    procedure PlayWavClick(Sender: TObject);
    procedure AddWAVClick(Sender: TObject);
    procedure CheckAllClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure UpdateNameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InfoClick(Sender: TObject);
    procedure StopMusicClick(Sender: TObject);
  private
    { Private declarations }
    CurrentSnd:String;
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

{$R *.DFM}

procedure TMain.OpenButtonClick(Sender: TObject);
var loop: integer;
begin
  if OpenDialog.Execute then
  begin
    WaveListBox.Items.Clear;
    DXWaveList.Items.Clear;
    DXWaveList.Items.LoadFromFile(OpenDialog.filename);
    for loop := 0 to DXWaveList.Items.Count - 1 do
      WaveListBox.Items.Add(DXWaveList.items[loop].Name);
  end;
end;

procedure TMain.WaveListBoxClick(Sender: TObject);
var i: integer;
begin
  if WaveListBox.Itemindex = -1 then exit;
  CurrentSnd := '';
  i := WaveListBox.itemindex {+ 1};
  Label1.Caption := DXWaveList.items[i].name;
  Name.Text := DXWaveList.Items[i].Name;
  StatusBar.Panels[0].Text := 'Wave Info: ' +
    ' Size: ' + IntToStr(DXWaveList.Items[i].Wave.Size) +
    ' Format: ' + IntToStr(DXWaveList.Items[i].Wave.FormatSize);
end;

procedure TMain.PlayWavClick(Sender: TObject);
begin
  If Label1.Caption <> '' Then
  Begin
    CurrentSnd := Label1.Caption;
    DXWaveList.Items.Find(CurrentSnd).Play(False);
  End;
end;

procedure TMain.AddWAVClick(Sender: TObject);
var i, loop: integer;
begin
  if OpenDialog1.Execute then
  begin
    i := DXWaveList.Items.Add.Index;
    DXWaveList.Items[i].Wave.LoadFromFile(OpenDialog1.Filename);
    DXWaveList.Items[i].Name := ExtractFileName(ChangeFileExt(OpenDialog1.Filename, ''));
    DXWaveList.Items[i].Restore;
    WaveListBox.Items.Clear;
    for loop := 0 to DXWaveList.Items.Count - 1 do
      WaveListBox.Items.Add(DXWaveList.items[loop].Name);
  end;
end;

procedure TMain.CheckAllClick(Sender: TObject);
var loop: integer;
begin
  for loop := 0 to WaveListBox.Items.Count - 1 do
    WaveListBox.Checked[loop] := True;
end;

procedure TMain.SaveButtonClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    DXWaveList.Items.SaveToFile(SaveDialog.filename);
  end;
end;

procedure TMain.NewClick(Sender: TObject);
begin
  WaveListBox.Items.Clear;
  DXWaveList.Items.Clear;
end;

procedure TMain.UpdateNameClick(Sender: TObject);
var i, loop: integer;
begin
  if WaveListBox.Itemindex = -1 then exit;
  i := WaveListBox.itemindex {+ 1};
  DXWaveList.Items[i].Name := Name.Text;
  DXWaveList.Items[i].Restore;
  WaveListBox.Items.Clear;
  for loop := 0 to DXWaveList.Items.Count - 1 do
    WaveListBox.Items.Add(DXWaveList.items[loop].Name);
end;

procedure TMain.FormCreate(Sender: TObject);
var loop: Integer;
begin
  If ParamCount > 0 Then
  Begin
    WaveListBox.Items.Clear;
    DXWaveList.Items.Clear;
    DXWaveList.Items.LoadFromFile(ParamStr(1));
    for loop := 0 to DXWaveList.Items.Count - 1 do
      WaveListBox.Items.Add(DXWaveList.items[loop].Name);
  End;
  CurrentSnd := '';
end;

procedure TMain.InfoClick(Sender: TObject);
begin
  ShowMessage('Simple DXW editor v 1.0 (derived from DXG).');
end;

procedure TMain.StopMusicClick(Sender: TObject);
begin
  If CurrentSnd <> '' Then
    DXWaveList.Items.Find(CurrentSnd).Stop;
  CurrentSnd := '';
end;

end.

