unit dumper;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ImgList, ComCtrls, ToolWin, ExtCtrls, ExtDlgs,
  DXDraws, DIB;

type
  Tdump = class(TForm)
    ControlBar1: TControlBar;
    toolbar: TToolBar;
    opendxg: TToolButton;
    iconlist: TImageList;
    names: TListBox;
    open: TOpenDialog;
    save: TSaveDialog;
    pagecontrol: TPageControl;
    Dumper: TTabSheet;
    SaveBMP: TSavePictureDialog;
    dump: TButton;
    stats: TMemo;
    Bevel1: TBevel;
    DXImageList: TDXImageList;
    savedxg: TToolButton;
    unDumper: TTabSheet;
    unStats: TMemo;
    Bevel2: TBevel;
    undump: TButton;
    openBMP: TOpenPictureDialog;
    compressor: TTabSheet;
    compstats: TMemo;
    Bevel3: TBevel;
    compress: TButton;
    ToolButton1: TToolButton;
    about: TToolButton;
    url: TLabel;
    make8: TCheckBox;
    keeptrans: TCheckBox;
    procedure opendxgClick(Sender: TObject);
    procedure dumpClick(Sender: TObject);
    procedure undumpClick(Sender: TObject);
    procedure savedxgClick(Sender: TObject);
    procedure compressClick(Sender: TObject);
    procedure aboutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dump: Tdump;

implementation

{$R *.DFM}

procedure Tdump.opendxgClick(Sender: TObject);
var loop: integer;
  f: file of Byte;
  size: Longint;
begin
  if open.Execute then
  begin
    names.Clear;
    DXImageList.Items.LoadFromFile(open.filename);
    for loop := 0 to DXImageList.Items.Count - 1 do
    begin
      names.items.Add(DXImageList.Items[loop].Name);
    end;
    stats.Lines.Add('Filename: ' + open.filename);
    stats.Lines.Add('Images: ' + inttostr(DXImageList.Items.Count));
    AssignFile(f, open.FileName);
    Reset(f);
    size := FileSize(f);
    CloseFile(f);
    stats.Lines.Add('File size in bytes: ' + IntToStr(size));
    SaveBMP.Filename := ChangeFileExt(open.filename, '.bmp');
    stats.Lines.Add('Default Save As... name: ' + ExtractFileName(SaveBMP.Filename));
  end;
end;

procedure Tdump.savedxgClick(Sender: TObject);
begin
  if save.Execute then
    DXImageList.Items.SaveToFile(save.filename);
end;

procedure Tdump.dumpClick(Sender: TObject);
var loop: integer;
  prefix: string;
begin
  if DXImageList.Items.Count = 0 then exit;
  if SaveBMP.Execute then
  begin
    stats.Lines.Add('Dumping...');
    for loop := 0 to DXImageList.Items.Count - 1 do
    begin
      prefix := ChangeFileExt(SaveBMP.filename, '.' + IntToHex(loop, 4)) + '.bmp';
      DXImageList.Items[loop].Picture.SaveToFile(prefix);
      stats.Lines.Add(prefix);
    end;
    stats.Lines.Add('Complete...');
    stats.Lines.Add('Remember TO SAVE!!!');
  end;
end;

procedure Tdump.undumpClick(Sender: TObject);
var loop: integer;
  stripped,
    prefix: string;
  f: file of Byte;
  size: Longint;
begin
  if DXImageList.Items.Count = 0 then exit;
  if openBMP.Execute then
  begin
    unstats.Lines.Add('unDumping...');
    stripped := openBMP.filename;
    Delete(stripped, LastDelimiter('.', stripped), 4);
    for loop := 0 to DXImageList.Items.Count - 1 do
    begin
      prefix := ChangeFileExt(stripped, '.' + IntToHex(loop, 4)) + '.bmp';
      DXImageList.Items[loop].Picture.LoadFromFile(prefix);
      unstats.Lines.Add(prefix);
    end;
    unstats.Lines.Add('Complete...');
    unstats.Lines.Add('Filename: ' + open.filename);
    unstats.Lines.Add('Images: ' + inttostr(DXImageList.Items.Count));
    AssignFile(f, open.FileName);
    Reset(f);
    size := FileSize(f);
    CloseFile(f);
    unstats.Lines.Add('File size in bytes: ' + IntToStr(size));
    unstats.Lines.Add('Remember TO SAVE!!!');
  end;
end;

procedure Tdump.compressClick(Sender: TObject);
var loop: integer;
  f: file of Byte;
  size, oldsize: Longint;
  compressedDIB: TDIB;
  tempfile: string;
begin
  if DXImageList.Items.Count = 0 then exit;
  compstats.Lines.Add('Compressing...');
  compstats.Lines.Add('Filename: ' + open.filename);
  compstats.Lines.Add('Images: ' + inttostr(DXImageList.Items.Count));
  AssignFile(f, open.FileName);
  Reset(f);
  oldsize := FileSize(f);
  CloseFile(f);
  compstats.Lines.Add('Old file size in bytes: ' + IntToStr(oldsize));
  for loop := 0 to DXImageList.Items.Count - 1 do
  begin
    compressedDIB := TDIB.Create;
    compstats.Lines.Add('Compressing: ' + DXImageList.Items[loop].name);
    try
      compressedDIB.Assign(DXImageList.Items[loop].Picture);
      compressedDIB.Compress;
      DXImageList.Items[loop].Picture.Graphic := compressedDIB;
    finally
      compressedDIB.Free;
    end;
  end;
  tempfile := extractfilepath(application.ExeName) + 'tempdxgfile' + inttohex(random($FFFF), 4);
  DXImageList.Items.SaveToFile(tempfile);
  compstats.Lines.Add('Complete...');
  compstats.Lines.Add('Images: ' + inttostr(DXImageList.Items.Count));
  AssignFile(f, tempfile);
  Reset(f);
  size := FileSize(f);
  CloseFile(f);
  DeleteFile(tempfile);
  compstats.Lines.Add('Compressed file size in bytes: ' + IntToStr(size) + ' (originally ' + IntToStr(oldsize) + ')');
  compstats.Lines.Add('Remember TO SAVE!!!');
end;

procedure Tdump.aboutClick(Sender: TObject);
begin
  Application.MessageBox('© 2000 Michael Wilson  |  wilson@no2games.com  | www.no2games.com/turbo', 'About', MB_OK)
end;

end.

