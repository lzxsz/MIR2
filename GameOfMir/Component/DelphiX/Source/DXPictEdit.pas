unit DXPictEdit;

interface

uses
  Windows, SysUtils, Classes, Forms, Dialogs, Controls, StdCtrls, ExtCtrls,
  ExtDlgs, DIB, Menus, Graphics, Clipbrd;

type

  {  TDelphiXDIBEditForm  }

  TDelphiXPictureEditForm = class(TForm)
    LoadButton: TButton;
    SaveButton: TButton;
    ClearButton: TButton;
    OKButton: TButton;
    CancelButton: TButton;
    Panel1: TPanel;
    Bevel1: TBevel;
    NoneLabel: TLabel;
    Shape: TShape;
    SizeLabel: TLabel;
    BitCountLabel: TLabel;
    Bevel2: TBevel;
    OpenDialog: TOpenPictureDialog;
    SaveDialog: TSavePictureDialog;
    BitSizeLabel: TLabel;
    ViewBox: TImage;
    ConvertToDIB: TButton;
    ClassNameLabel: TLabel;
    PopupMenu1: TPopupMenu;
    geConvertColor: TMenuItem;
    N15: TMenuItem;
    N41: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    geGreyscale: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    geNegative: TMenuItem;
    N1: TMenuItem;
    geCompress: TMenuItem;
    geDecompress: TMenuItem;
    N3: TMenuItem;
    geCopy: TMenuItem;
    gePaste: TMenuItem;
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure geGreyscaleClick(Sender: TObject);
    procedure geNegativeClick(Sender: TObject);
    procedure geConvertColorClick(Sender: TObject);
    procedure geCompressClick(Sender: TObject);
    procedure geDecompressClick(Sender: TObject);
    procedure ConvertToDIBClick(Sender: TObject);
    procedure geCopyClick(Sender: TObject);
    procedure gePasteClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    FChanged: Boolean;
    procedure UpdateData;
  public
    DIBClassOnly: Boolean;
  end;

var
  DelphiXPictureEditForm: TDelphiXPictureEditForm;

implementation

uses DXConsts;

{$R *.DFM}

{  TDelphiXDIBEditForm  }

procedure TDelphiXPictureEditForm.FormShow(Sender: TObject);
begin
  ConvertToDIB.Visible := not DIBClassOnly;
  UpDateData;
  CancelButton.SetFocus;
end;

procedure TDelphiXPictureEditForm.OKButtonClick(Sender: TObject);
begin
  if FChanged then
    Tag := 1;
  Close;
end;

procedure TDelphiXPictureEditForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TDelphiXPictureEditForm.ClearButtonClick(Sender: TObject);
begin
  FChanged := True;

  ViewBox.Picture.Graphic := nil;
  UpDateData;
end;

procedure TDelphiXPictureEditForm.LoadButtonClick(Sender: TObject);
var
  DIB: TDIB;
begin
  if DIBClassOnly then
  begin
    OpenDialog.Filter := GraphicFilter(TGraphic);

    if OpenDialog.Execute then
    begin
      FChanged := True;

      try
        DIB := TDIB.Create;
        try
          DIB.LoadFromFile(OpenDialog.FileName);
          ViewBox.Picture.Graphic := DIB;
        finally
          DIB.Free;
        end;
      except
        ViewBox.Picture.LoadFromFile(OpenDialog.FileName);
        ConvertToDIBClick(nil);
      end;

      UpDateData;
    end;
  end else
  begin
    OpenDialog.Filter := GraphicFilter(TGraphic);

    if OpenDialog.Execute then
    begin
      FChanged := True;

      try
        DIB := TDIB.Create;
        try
          DIB.LoadFromFile(OpenDialog.FileName);
          ViewBox.Picture.Graphic := DIB;
        finally
          DIB.Free;
        end;
      except
        ViewBox.Picture.LoadFromFile(OpenDialog.FileName);
      end;

      UpDateData;
    end;
  end;
end;

procedure TDelphiXPictureEditForm.SaveButtonClick(Sender: TObject);
begin
  if ViewBox.Picture.Graphic is TDIB then
  begin
    SaveDialog.Filter := 'Bitmap file(*.bmp;*.dib)|*.bmp;*.dib';
    SaveDialog.DefaultExt := 'bmp';
  end else
  begin
    SaveDialog.Filter := GraphicFilter(TGraphicClass(ViewBox.Picture.Graphic.ClassType));
    SaveDialog.DefaultExt := GraphicExtension(TGraphicClass(ViewBox.Picture.Graphic.ClassType));
  end;

  if SaveDialog.Execute then
    ViewBox.Picture.SaveToFile(SaveDialog.FileName);
end;

procedure TDelphiXPictureEditForm.ConvertToDIBClick(Sender: TObject);
var
  DIB: TDIB;
begin                                 
  if (ViewBox.Picture.Graphic<>nil) and (not (ViewBox.Picture.Graphic is TDIB)) then
  begin
    DIB := TDIB.Create;
    try
      DIB.Assign(ViewBox.Picture.Graphic);
      ViewBox.Picture.Graphic := DIB;
    finally
      DIB.Free;
    end;

    UpdateData;
  end;
end;

procedure TDelphiXPictureEditForm.UpdateData;

  procedure Draw2(Width, Height: Integer);
  begin
    ViewBox.Stretch := True;
    ViewBox.Left := 6 + -(Width-ViewBox.Width) div 2;
    ViewBox.Top := 6 + -(Height-ViewBox.Height) div 2;
    ViewBox.Width := Width;
    ViewBox.Height := Height;
  end;

var
  i: Integer;
  r, r2: Double;
  DIB: TDIB;
begin
  if (ViewBox.Picture.Graphic<>nil) and (not ViewBox.Picture.Graphic.Empty) and
    (ViewBox.Picture.Width>0) and (ViewBox.Picture.Height>0) then
  begin
    SizeLabel.Caption := Format(SDIBSize, [ViewBox.Picture.Width, ViewBox.Picture.Height]);

    ClassNameLabel.Caption := ViewBox.Picture.Graphic.ClassName;

    if ViewBox.Picture.Graphic is TDIB then
    begin
      i := (ViewBox.Picture.Graphic as TDIB).BitCount;
      if i=32 then i := 32;
      BitCountLabel.Caption := Format(SDIBColor, [1 shl i]);

      DIB := ViewBox.Picture.Graphic as TDIB;

      if DIB.BitmapInfo.bmiHeader.biSizeImage>100*1024 then
        BitSizeLabel.Caption := Format(SDIBBitSize_K, [DIB.BitmapInfo.bmiHeader.biSizeImage div 1024])
      else
        BitSizeLabel.Caption := Format(SDIBBitSize, [DIB.BitmapInfo.bmiHeader.biSizeImage]);
    end else
    begin
      BitCountLabel.Caption := '';
      BitSizeLabel.Caption := '';
    end;

    ConvertToDIB.Enabled := not (ViewBox.Picture.Graphic is TDIB);

    NoneLabel.Visible := True;
    ClearButton.Enabled := True;
    NoneLabel.Visible := False;
    SaveButton.Enabled := True;

    ViewBox.Width := 228;
    ViewBox.Height := 228;

    if (ViewBox.Picture.Width>ViewBox.Width) or (ViewBox.Picture.Height>ViewBox.Height) then
    begin
      r := ViewBox.Width/ViewBox.Picture.Width;
      r2 := ViewBox.Height/ViewBox.Picture.Height;
      if r>r2 then
        r := r2;
      Draw2(Round(r*ViewBox.Picture.Width), Round(r*ViewBox.Picture.Height));
    end else
      Draw2(ViewBox.Picture.Width, ViewBox.Picture.Height);

    for i:=0 to PopupMenu1.Items.Count-1 do
      if PopupMenu1.Items[i].Tag<>0 then
        PopupMenu1.Items[i].Enabled := True;
  end else
  begin
    SizeLabel.Caption := '';
    BitCountLabel.Caption := '';
    BitSizeLabel.Caption := '';
    ClassNameLabel.Caption := '';

    NoneLabel.Visible := False;
    ClearButton.Enabled := False;
    NoneLabel.Visible := True;
    SaveButton.Enabled := False;

    ConvertToDIB.Enabled := False;

    for i:=0 to PopupMenu1.Items.Count-1 do
      if PopupMenu1.Items[i].Tag<>0 then
        PopupMenu1.Items[i].Enabled := False;
  end;

  PaletteChanged(True);
  ViewBox.Invalidate;
end;

procedure TDelphiXPictureEditForm.geConvertColorClick(Sender: TObject);
begin
  ConvertToDIBClick(nil);
  FChanged := True;
  (ViewBox.Picture.Graphic as TDIB).PixelFormat := MakeDIBPixelFormat(8, 8, 8);
  (ViewBox.Picture.Graphic as TDIB).BitCount := TMenuItem(Sender).Tag;
  UpdateData;
end;

procedure TDelphiXPictureEditForm.geGreyscaleClick(Sender: TObject);
begin
  ConvertToDIBClick(nil);
  FChanged := True;
  (ViewBox.Picture.Graphic as TDIB).PixelFormat := MakeDIBPixelFormat(8, 8, 8);
  (ViewBox.Picture.Graphic as TDIB).Greyscale(TMenuItem(Sender).Tag);
  UpdateData;
end;

procedure TDelphiXPictureEditForm.geNegativeClick(Sender: TObject);
begin
  ConvertToDIBClick(nil);
  FChanged := True;
  (ViewBox.Picture.Graphic as TDIB).Negative;
  UpdateData;
end;

procedure TDelphiXPictureEditForm.geCompressClick(Sender: TObject);
begin
  ConvertToDIBClick(nil);
  FChanged := True;
  (ViewBox.Picture.Graphic as TDIB).Compress;
  UpdateData;
end;

procedure TDelphiXPictureEditForm.geDecompressClick(Sender: TObject);
begin
  ConvertToDIBClick(nil);
  FChanged := True;
  (ViewBox.Picture.Graphic as TDIB).Decompress;
  UpdateData;
end;

procedure TDelphiXPictureEditForm.geCopyClick(Sender: TObject);
var
  AFormat: Word;
  AData: THandle;
  APalette: HPALETTE;
begin
  Clipboard.Open;
  try
    ViewBox.Picture.Graphic.SaveToClipboardFormat(AFormat, AData, APalette);
    Clipboard.SetAsHandle(AFormat, AData);
  finally                                 
    Clipboard.Close;
  end;
end;

procedure TDelphiXPictureEditForm.gePasteClick(Sender: TObject);
var
  DIB: TDIB;
begin
  if DIBClassOnly then
  begin
    FChanged := True;

    try
      DIB := TDIB.Create;
      try
        Clipboard.Open;
        try
          DIB.LoadFromClipboardFormat(CF_DIB, Clipboard.GetAsHandle(CF_DIB), 0);
        finally
          Clipboard.Close;
        end;
        ViewBox.Picture.Graphic := DIB;
      finally
        DIB.Free;
      end;
    except
      ViewBox.Picture.Assign(Clipboard);
      ConvertToDIBClick(nil);
    end;
  end else
  begin
    FChanged := True;
    ViewBox.Picture.Assign(Clipboard);
  end;

  UpdateData;
end;

procedure TDelphiXPictureEditForm.PopupMenu1Popup(Sender: TObject);
var
  i: Integer;
begin
  if DIBClassOnly then
  begin
    gePaste.Enabled := False;
    for i:=0 to Clipboard.FormatCount-1 do
      if Clipboard.Formats[i]=CF_DIB then
      begin
        gePaste.Enabled := True;
        Break;
      end;
  end else
  begin
    gePaste.Enabled := False;
    for i:=0 to Clipboard.FormatCount-1 do
      if ViewBox.Picture.SupportsClipboardFormat(Clipboard.Formats[i]) then
      begin
        gePaste.Enabled := True;
        Break;
      end;
  end;
end;

end.
