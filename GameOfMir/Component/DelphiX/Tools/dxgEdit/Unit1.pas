unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DIB, StdCtrls, ExtCtrls, ComCtrls, ToolWin, Menus,
  Buttons, ImgList, DXDraws, CheckLst, Spin, ExtDlgs;

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
    DXImageList: TDXImageList;
    StatusBar: TStatusBar;
    ImageBar: TToolBar;
    ImageDel: TToolButton;
    ImageDown: TToolButton;
    ImageUp: TToolButton;
    sep3: TToolButton;
    AddBMP: TToolButton;
    sep1: TToolButton;
    sep7: TToolButton;
    Info: TToolButton;
    CheckAll: TToolButton;
    sep8: TToolButton;
    PropBar: TToolBar;
    SysMem: TToolButton;
    Trans: TToolButton;
    sep5: TToolButton;
    GetTrans: TToolButton;
    sep4: TToolButton;
    ShowPat: TToolButton;
    KeyColor: TShape;
    AutoPatBar: TToolBar;
    AutoWidthEdit: TSpinEdit;
    AutoHeightEdit: TSpinEdit;
    AutoPatLabel: TPanel;
    PatternBar: TToolBar;
    PatLabel: TPanel;
    PatWidthEdit: TSpinEdit;
    PatHeightEdit: TSpinEdit;
    ShowAuto: TToolButton;
    SkipBar: TToolBar;
    SkipLabel: TPanel;
    SkipWidthEdit: TSpinEdit;
    SkipHeightEdit: TSpinEdit;
    SkipShow: TToolButton;
    sep6: TToolButton;
    FitImage: TToolButton;
    OpenPictureDialog: TOpenPictureDialog;
    ImageListBox: TCheckListBox;
    New: TToolButton;
    sep2: TToolButton;
    Image: TImage;
      Name: TEdit;
    ToolButton1: TToolButton;
    UpdateName: TToolButton;
    procedure OpenButtonClick(Sender: TObject);
    procedure ImageListBoxClick(Sender: TObject);
    procedure FitImageClick(Sender: TObject);
    procedure ShowPatClick(Sender: TObject);
    procedure ShowAutoClick(Sender: TObject);
    procedure SkipShowClick(Sender: TObject);
    procedure AddBMPClick(Sender: TObject);
    procedure SysMemClick(Sender: TObject);
    procedure TransClick(Sender: TObject);
    procedure CheckAllClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure UpdateNameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
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
    ImageListBox.Items.Clear;
    DXImageList.Items.Clear;
    DXImageList.Items.LoadFromFile(OpenDialog.filename);
    for loop := 0 to DXImageList.Items.Count - 1 do
      ImageListBox.Items.Add(DXImageList.items[loop].Name);
  end;
end;

procedure TMain.ImageListBoxClick(Sender: TObject);
var i: integer;
begin
  if ImageListBox.Itemindex = -1 then exit;
  i := ImageListBox.itemindex;
  Image.Picture := dximagelist.items[i].picture;
  KeyColor.Brush.Color := dximagelist.items[i].TransparentColor;
  SysMem.Down := dximagelist.Items[i].SystemMemory;
  Trans.Down := dximagelist.Items[i].Transparent;
  Name.Text := dximagelist.Items[i].Name;
  StatusBar.Panels[0].Text := 'Bitmap Info: ' +
    ' Width: ' + inttostr(dximagelist.items[i].Width) +
    ' Height: ' + inttostr(dximagelist.items[i].Height);
end;

procedure TMain.FitImageClick(Sender: TObject);
begin
  image.stretch := fitimage.Down;
  image.Update;
end;

procedure TMain.ShowPatClick(Sender: TObject);
begin
  PatternBar.Visible := showpat.down;
end;

procedure TMain.ShowAutoClick(Sender: TObject);
begin
  AutoPatBar.Visible := showauto.down;
end;

procedure TMain.SkipShowClick(Sender: TObject);
begin
  SkipBar.Visible := skipshow.down;
end;

procedure TMain.AddBMPClick(Sender: TObject);
var i, loop: integer;
begin
  if OpenPictureDialog.Execute then
  begin
    i := DXImageList.Items.Add.Index;
    DXImageList.Items[i].Picture.LoadFromFile(OpenPictureDialog.Filename);
    DXImageList.Items[i].Name := ExtractFileName(ChangeFileExt(OpenPictureDialog.Filename, ''));
    DXImageList.Items[i].Restore;
    ImageListBox.Items.Clear;
    for loop := 0 to DXImageList.Items.Count - 1 do
      ImageListBox.Items.Add(DXImageList.items[loop].Name);
  end;
end;

procedure TMain.SysMemClick(Sender: TObject);
var i: integer;
begin
  if ImageListBox.Itemindex = -1 then exit;
  i := ImageListBox.itemindex;
  dximagelist.Items[i].SystemMemory := SysMem.Down;
  dximagelist.Items[i].Restore;
end;

procedure TMain.TransClick(Sender: TObject);
var i: integer;
begin
  if ImageListBox.Itemindex = -1 then exit;
  i := ImageListBox.itemindex;
  dximagelist.Items[i].Transparent := Trans.Down;
  dximagelist.Items[i].Restore;
end;

procedure TMain.CheckAllClick(Sender: TObject);
var loop: integer;
begin
  for loop := 0 to ImageListBox.Items.Count - 1 do
    ImageListBox.Checked[loop] := True;
end;

procedure TMain.SaveButtonClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    DXImageList.Items.SaveToFile(SaveDialog.filename);
  end;
end;

procedure TMain.NewClick(Sender: TObject);
begin
  ImageListBox.Items.Clear;
  DXImageList.Items.Clear;
end;

procedure TMain.UpdateNameClick(Sender: TObject);
var i, loop: integer;
begin
  if ImageListBox.Itemindex = -1 then exit;
  i := ImageListBox.itemindex;
  dximagelist.Items[i].Name := Name.Text;
  dximagelist.Items[i].Restore;
  ImageListBox.Items.Clear;
  for loop := 0 to DXImageList.Items.Count - 1 do
    ImageListBox.Items.Add(DXImageList.items[loop].Name);
end;

procedure TMain.FormCreate(Sender: TObject);
var loop: Integer;
begin
  If ParamCount > 0 Then
  Begin
    ImageListBox.Items.Clear;
    DXImageList.Items.Clear;
    DXImageList.Items.LoadFromFile(ParamStr(1));
    for loop := 0 to DXImageList.Items.Count - 1 do
      ImageListBox.Items.Add(DXImageList.items[loop].Name);
  End;
end;

end.

