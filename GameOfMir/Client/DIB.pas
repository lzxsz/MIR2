unit DIB;

interface

{$INCLUDE DelphiXcfg.inc}

uses
  Windows, SysUtils, Classes, Graphics, Controls;

type
  TRGBQuads = array[0..255] of TRGBQuad;

  TPaletteEntries = array[0..255] of TPaletteEntry;

  PBGR = ^TBGR;
  TBGR = packed record
    B, G, R: Byte;
  end;

  PArrayBGR = ^TArrayBGR;
  TArrayBGR = array[0..10000] of TBGR;

  PArrayByte = ^TArrayByte;
  TArrayByte = array[0..10000] of Byte;

  PArrayWord = ^TArrayWord;
  TArrayWord = array[0..10000] of Word;

  PArrayDWord = ^TArrayDWord;
  TArrayDWord = array[0..10000] of DWord;

  {  TDIB  }

  TDIBPixelFormat = record
    RBitMask, GBitMask, BBitMask: DWORD;
    RBitCount, GBitCount, BBitCount: DWORD;
    RShift, GShift, BShift: DWORD;
    RBitCount2, GBitCount2, BBitCount2: DWORD;
  end;

  TDIBSharedImage = class(TSharedImage)
  private       
    FBitCount: Integer;
    FBitmapInfo: PBitmapInfo;
    FBitmapInfoSize: Integer;
    FChangePalette: Boolean;
    FColorTable: TRGBQuads;
    FColorTablePos: Integer;
    FCompressed: Boolean;
    FDC: THandle;
    FHandle: THandle;
    FHeight: Integer;
    FMemoryImage: Boolean;
    FNextLine: Integer;
    FOldHandle: THandle;
    FPalette: HPalette;
    FPaletteCount: Integer;
    FPBits: Pointer;
    FPixelFormat: TDIBPixelFormat;
    FSize: Integer;
    FTopPBits: Pointer;
    FWidth: Integer;
    FWidthBytes: Integer;
    constructor Create;
    procedure NewImage(AWidth, AHeight, ABitCount: Integer;
      const PixelFormat: TDIBPixelFormat; const ColorTable: TRGBQuads; MemoryImage, Compressed: Boolean);
    procedure Duplicate(Source: TDIBSharedImage; MemoryImage: Boolean);
    procedure Compress(Source: TDIBSharedImage);
    procedure Decompress(Source: TDIBSharedImage; MemoryImage: Boolean);
    procedure ReadData(Stream: TStream; MemoryImage: Boolean);
    function GetPalette: THandle;
    procedure SetColorTable(const Value: TRGBQuads);
  protected
    procedure FreeHandle; override;
  public
    destructor Destroy; override;
  end;

  TDIB = class(TGraphic)
  private
    FCanvas: TCanvas;
    FImage: TDIBSharedImage;    

    FProgressName: string;
    FProgressOldY: DWORD;
    FProgressOldTime: DWORD;
    FProgressOld: DWORD;
    FProgressY: DWORD;
    {  For speed-up  }
    FBitCount: Integer;
    FHeight: Integer;
    FNextLine: Integer;
    FNowPixelFormat: TDIBPixelFormat;
    FPBits: Pointer;
    FSize: Integer;
    FTopPBits: Pointer;
    FWidth: Integer;
    FWidthBytes: Integer;
    procedure AllocHandle;
    procedure CanvasChanging(Sender: TObject);
    procedure Changing(MemoryImage: Boolean);
    procedure ConvertBitCount(ABitCount: Integer);
    function GetBitmapInfo: PBitmapInfo;
    function GetBitmapInfoSize: Integer;
    function GetCanvas: TCanvas;
    function GetHandle: THandle;
    function GetPaletteCount: Integer;
    function GetPixel(X, Y: Integer): DWORD;
    function GetPBits: Pointer;
    function GetPBitsReadOnly: Pointer;
    function GetScanLine(Y: Integer): Pointer;
    function GetScanLineReadOnly(Y: Integer): Pointer;
    function GetTopPBits: Pointer;
    function GetTopPBitsReadOnly: Pointer;
    procedure SetBitCount(Value: Integer);
    procedure SetImage(Value: TDIBSharedImage);
    procedure SetNowPixelFormat(const Value: TDIBPixelFormat);
    procedure SetPixel(X, Y: Integer; Value: DWORD);
    procedure StartProgress(const Name: string);
    procedure EndProgress;
    procedure UpdateProgress(PercentY: Integer);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    function GetEmpty: Boolean; override;
    function GetHeight: Integer; override;
    function GetPalette: HPalette; override;
    function GetWidth: Integer; override;
    procedure ReadData(Stream: TStream); override;
    procedure SetHeight(Value: Integer); override;
    procedure SetPalette(Value: HPalette); override;
    procedure SetWidth(Value: Integer); override;
    procedure WriteData(Stream: TStream); override;
  public
    ColorTable: TRGBQuads;
    PixelFormat: TDIBPixelFormat;
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    procedure Compress;
    procedure Decompress;
    procedure FreeHandle;
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
      APalette: HPALETTE); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
      var APalette: HPALETTE); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SetSize(AWidth, AHeight, ABitCount: Integer);
    procedure UpdatePalette;
    {  Special effect  }
    procedure Blur(ABitCount: Integer; Radius: Integer);
    procedure Greyscale(ABitCount: Integer);
    procedure Mirror(MirrorX, MirrorY: Boolean);
    procedure Negative;

    property BitCount: Integer read FBitCount write SetBitCount;
    property BitmapInfo: PBitmapInfo read GetBitmapInfo;
    property BitmapInfoSize: Integer read GetBitmapInfoSize;
    property Canvas: TCanvas read GetCanvas;
    property Handle: THandle read GetHandle;
    property Height: Integer read FHeight write SetHeight;
    property NextLine: Integer read FNextLine;
    property NowPixelFormat: TDIBPixelFormat read FNowPixelFormat write SetNowPixelFormat;
    property PaletteCount: Integer read GetPaletteCount;
    property PBits: Pointer read GetPBits;
    property PBitsReadOnly: Pointer read GetPBitsReadOnly;
    property Pixels[X, Y: Integer]: DWORD read GetPixel write SetPixel;
    property ScanLine[Y: Integer]: Pointer read GetScanLine;
    property ScanLineReadOnly[Y: Integer]: Pointer read GetScanLineReadOnly;
    property Size: Integer read FSize;
    property TopPBits: Pointer read GetTopPBits;
    property TopPBitsReadOnly: Pointer read GetTopPBitsReadOnly;
    property Width: Integer read FWidth write SetWidth;
    property WidthBytes: Integer read FWidthBytes;
  end;

  TDIBitmap = class(TDIB) end;

  {  TCustomDXDIB  }

  TCustomDXDIB = class(TComponent)
  private
    FDIB: TDIB;
    procedure SetDIB(Value: TDIB);
  public
    constructor Create(AOnwer: TComponent); override;
    destructor Destroy; override;
    property DIB: TDIB read FDIB write SetDIB;
  end;

  {  TDXDIB  }

  TDXDIB = class(TCustomDXDIB)
  published
    property DIB;
  end;

  {  TCustomDXPaintBox  }

  TCustomDXPaintBox = class(TGraphicControl)
  private
    FAutoStretch: Boolean;
    FCenter: Boolean;
    FDIB: TDIB;
    FKeepAspect: Boolean;
    FStretch: Boolean;
    FViewWidth: Integer;
    FViewHeight: Integer;
    procedure SetAutoStretch(Value: Boolean);
    procedure SetCenter(Value: Boolean);
    procedure SetDIB(Value: TDIB);
    procedure SetKeepAspect(Value: Boolean);
    procedure SetStretch(Value: Boolean);
    procedure SetViewWidth(Value: Integer);
    procedure SetViewHeight(Value: Integer);
  protected
    function GetPalette: HPALETTE; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    property AutoStretch: Boolean read FAutoStretch write SetAutoStretch;
    property Canvas;
    property Center: Boolean read FCenter write SetCenter;
    property DIB: TDIB read FDIB write SetDIB;
    property KeepAspect: Boolean read FKeepAspect write SetKeepAspect;
    property Stretch: Boolean read FStretch write SetStretch;
    property ViewWidth: Integer read FViewWidth write SetViewWidth;
    property ViewHeight: Integer read FViewHeight write SetViewHeight;
  end;

  {  TDXPaintBox  }

  TDXPaintBox = class(TCustomDXPaintBox)
  published
    {$IFDEF DelphiX_Spt4}property Anchors;{$ENDIF}
    property AutoStretch;
    property Center;
    {$IFDEF DelphiX_Spt4}property Constraints;{$ENDIF}
    property DIB;
    property KeepAspect;
    property Stretch;
    property ViewWidth;
    property ViewHeight;

    property Align;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

function MakeDIBPixelFormat(RBitCount, GBitCount, BBitCount: Integer): TDIBPixelFormat;
function MakeDIBPixelFormatMask(RBitMask, GBitMask, BBitMask: Integer): TDIBPixelFormat;
function pfRGB(const PixelFormat: TDIBPixelFormat; R, G, B: Byte): DWORD;
procedure pfGetRGB(const PixelFormat: TDIBPixelFormat; Color: DWORD; var R, G, B: Byte);
function pfGetRValue(const PixelFormat: TDIBPixelFormat; Color: DWORD): Byte;
function pfGetGValue(const PixelFormat: TDIBPixelFormat; Color: DWORD): Byte;
function pfGetBValue(const PixelFormat: TDIBPixelFormat; Color: DWORD): Byte;

function GreyscaleColorTable: TRGBQuads;

function RGBQuad(R, G, B: Byte): TRGBQuad;
function PaletteEntryToRGBQuad(const Entry: TPaletteEntry): TRGBQuad;
function PaletteEntriesToRGBQuads(const Entries: TPaletteEntries): TRGBQuads;
function RGBQuadToPaletteEntry(const RGBQuad: TRGBQuad): TPaletteEntry;
function RGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads): TPaletteEntries;

implementation

uses DXConsts;

function Max(B1, B2: Integer): Integer;
begin
  if B1>=B2 then Result := B1 else Result := B2;
end;

function MakeDIBPixelFormat(RBitCount, GBitCount, BBitCount: Integer): TDIBPixelFormat;
begin
  Result.RBitMask := ((1 shl RBitCount)-1) shl (GBitCount+BBitCount);
  Result.GBitMask := ((1 shl GBitCount)-1) shl (BBitCount);
  Result.BBitMask := (1 shl BBitCount)-1;
  Result.RBitCount := RBitCount;
  Result.GBitCount := GBitCount;
  Result.BBitCount := BBitCount;
  Result.RBitCount2 := 8-RBitCount;
  Result.GBitCount2 := 8-GBitCount;
  Result.BBitCount2 := 8-BBitCount;
  Result.RShift := (GBitCount+BBitCount)-(8-RBitCount);
  Result.GShift := BBitCount-(8-GBitCount);
  Result.BShift := 8-BBitCount;
end;

function MakeDIBPixelFormatMask(RBitMask, GBitMask, BBitMask: Integer): TDIBPixelFormat;

  function GetBitCount(b: Integer): Integer;
  var
    i: Integer;
  begin
    i := 0;
    while (i<31) and (((1 shl i) and b)=0) do Inc(i);

    Result := 0;
    while ((1 shl i) and b)<>0 do
    begin
      Inc(i);
      Inc(Result);
    end;
  end;

begin
  Result := MakeDIBPixelFormat(GetBitCount(RBitMask), GetBitCount(GBitMask),
    GetBitCount(BBitMask));
end;

function pfRGB(const PixelFormat: TDIBPixelFormat; R, G, B: Byte): DWORD;
begin
  with PixelFormat do
    Result := ((R shl RShift) and RBitMask) or ((G shl GShift) and GBitMask) or
      ((B shr BShift) and BBitMask);
end;

procedure pfGetRGB(const PixelFormat: TDIBPixelFormat; Color: DWORD; var R, G, B: Byte);
begin
  with PixelFormat do
  begin
    R := (Color and RBitMask) shr RShift;
    R := R or (R shr RBitCount2);
    G := (Color and GBitMask) shr GShift;
    G := G or (G shr GBitCount2);
    B := (Color and BBitMask) shl BShift;
    B := B or (B shr BBitCount2);
  end;
end;

function pfGetRValue(const PixelFormat: TDIBPixelFormat; Color: DWORD): Byte;
begin
  with PixelFormat do
  begin
    Result := (Color and RBitMask) shr RShift;
    Result := Result or (Result shr RBitCount);
  end;
end;

function pfGetGValue(const PixelFormat: TDIBPixelFormat; Color: DWORD): Byte;
begin
  with PixelFormat do
  begin
    Result := (Color and GBitMask) shr GShift;
    Result := Result or (Result shr GBitCount);
  end;
end;

function pfGetBValue(const PixelFormat: TDIBPixelFormat; Color: DWORD): Byte;
begin
  with PixelFormat do
  begin
    Result := (Color and BBitMask) shl BShift;
    Result := Result or (Result shr BBitCount);
  end;
end;

function GreyscaleColorTable: TRGBQuads;
var
  i: Integer;
begin
  for i:=0 to 255 do
    with Result[i] do
    begin
      rgbRed := i;
      rgbGreen := i;
      rgbBlue := i;
      rgbReserved := 0;
    end;
end;

function RGBQuad(R, G, B: Byte): TRGBQuad;
begin
  with Result do
  begin
    rgbRed := R;
    rgbGreen := G;
    rgbBlue := B;
    rgbReserved := 0;
  end;
end;

function PaletteEntryToRGBQuad(const Entry: TPaletteEntry): TRGBQuad;
begin
  with Result do
    with Entry do
    begin
      rgbRed := peRed;
      rgbGreen := peGreen;
      rgbBlue := peBlue;
      rgbReserved := 0;
    end;
end;

function PaletteEntriesToRGBQuads(const Entries: TPaletteEntries): TRGBQuads;
var
  i: Integer;
begin
  for i:=0 to 255 do
    Result[i] := PaletteEntryToRGBQuad(Entries[i]);
end;

function RGBQuadToPaletteEntry(const RGBQuad: TRGBQuad): TPaletteEntry;
begin
  with Result do
    with RGBQuad do
    begin
      peRed := rgbRed;
      peGreen := rgbGreen;
      peBlue := rgbBlue;
      peFlags := 0;
    end;
end;

function RGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads): TPaletteEntries;
var
  i: Integer;
begin
  for i:=0 to 255 do
    Result[i] := RGBQuadToPaletteEntry(RGBQuads[i]);
end;

{  TDIBSharedImage  }

type
  PLocalDIBPixelFormat = ^TLocalDIBPixelFormat;
  TLocalDIBPixelFormat = packed record
    RBitMask, GBitMask, BBitMask: DWORD;
  end;

  TPaletteItem = class(TCollectionItem)
  private
    ID: Integer;
    Palette: HPalette;
    RefCount: Integer;
    ColorTable: TRGBQuads;
    ColorTableCount: Integer;
    destructor Destroy; override;
    procedure AddRef;
    procedure Release;
  end;

  TPaletteManager = class
  private
    FList: TCollection;
    constructor Create;
    destructor Destroy; override;
    function CreatePalette(const ColorTable: TRGBQuads; ColorTableCount: Integer): HPalette;
    procedure DeletePalette(var Palette: HPalette);
  end;

destructor TPaletteItem.Destroy;
begin
  DeleteObject(Palette);
  inherited Destroy;
end;

procedure TPaletteItem.AddRef;
begin
  Inc(RefCount);
end;

procedure TPaletteItem.Release;
begin
  Dec(RefCount);
  if RefCount<=0 then Free;
end;

constructor TPaletteManager.Create;
begin
  inherited Create;
  FList := TCollection.Create(TPaletteItem);
end;

destructor TPaletteManager.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TPaletteManager.CreatePalette(const ColorTable: TRGBQuads; ColorTableCount: Integer): HPalette;
type
  TMyLogPalette = record
    palVersion: Word;
    palNumEntries: Word;
    palPalEntry: TPaletteEntries;
  end;
var
  i, ID: Integer;
  Item: TPaletteItem;
  LogPalette: TMyLogPalette;
begin
  {  Hash key making  }
  ID := ColorTableCount;
  for i:=0 to ColorTableCount-1 do
    with ColorTable[i] do
    begin
      Inc(ID, rgbRed);
      Inc(ID, rgbGreen);
      Inc(ID, rgbBlue);
    end;

  {  Does the same palette already exist?  }
  for i:=0 to FList.Count-1 do
  begin
    Item := TPaletteItem(FList.Items[i]);
    if (Item.ID=ID) and (Item.ColorTableCount=ColorTableCount) and
      CompareMem(@Item.ColorTable, @ColorTable, ColorTableCount*SizeOf(TRGBQuad)) then
    begin
      Item.AddRef; Result := Item.Palette;
      Exit;
    end;
  end;

  {  New palette making  }
  Item := TPaletteItem.Create(FList);
  Item.ID := ID;
  Move(ColorTable, Item.ColorTable, ColorTableCount*SizeOf(TRGBQuad));
  Item.ColorTableCount := ColorTableCount;

  with LogPalette do
  begin
    palVersion := $300;
    palNumEntries := ColorTableCount;
    palPalEntry := RGBQuadsToPaletteEntries(ColorTable);
  end;

  Item.Palette := Windows.CreatePalette(PLogPalette(@LogPalette)^);
  Item.AddRef; Result := Item.Palette;
end;

procedure TPaletteManager.DeletePalette(var Palette: HPalette);
var
  i: Integer;
  Item: TPaletteItem;
begin
  if Palette=0 then Exit;

  for i:=0 to FList.Count-1 do
  begin
    Item := TPaletteItem(FList.Items[i]);
    if (Item.Palette=Palette) then
    begin
      Palette := 0;
      Item.Release;
      Exit;
    end;
  end;
end;

var
  FPaletteManager: TPaletteManager;

function PaletteManager: TPaletteManager;
begin
  if FPaletteManager=nil then
    FPaletteManager := TPaletteManager.Create;
  Result := FPaletteManager;
end;

constructor TDIBSharedImage.Create;
begin
  inherited Create;
  FMemoryImage := True;
  SetColorTable(GreyscaleColorTable);
  FColorTable := GreyscaleColorTable;
  FPixelFormat := MakeDIBPixelFormat(8, 8, 8);
end;

procedure TDIBSharedImage.NewImage(AWidth, AHeight, ABitCount: Integer;
  const PixelFormat: TDIBPixelFormat; const ColorTable: TRGBQuads; MemoryImage, Compressed: Boolean);
var
  InfoOfs: Integer;
  UsePixelFormat: Boolean;
begin
  Create;

  {  Pixel format check  }
  case ABitCount of
    1 : if not ((PixelFormat.RBitMask=$FF0000) and (PixelFormat.GBitMask=$00FF00) and (PixelFormat.BBitMask=$0000FF)) then
            raise EInvalidGraphicOperation.Create(SInvalidDIBPixelFormat);
    4 : if not ((PixelFormat.RBitMask=$FF0000) and (PixelFormat.GBitMask=$00FF00) and (PixelFormat.BBitMask=$0000FF)) then
            raise EInvalidGraphicOperation.Create(SInvalidDIBPixelFormat);
    8 : if not ((PixelFormat.RBitMask=$FF0000) and (PixelFormat.GBitMask=$00FF00) and (PixelFormat.BBitMask=$0000FF)) then
            raise EInvalidGraphicOperation.Create(SInvalidDIBPixelFormat);
    16: begin
          if not (((PixelFormat.RBitMask=$7C00) and (PixelFormat.GBitMask=$03E0) and (PixelFormat.BBitMask=$001F)) or
            ((PixelFormat.RBitMask=$F800) and (PixelFormat.GBitMask=$07E0) and (PixelFormat.BBitMask=$001F))) then
            raise EInvalidGraphicOperation.Create(SInvalidDIBPixelFormat);
        end;
    24: begin
          if not ((PixelFormat.RBitMask=$FF0000) and (PixelFormat.GBitMask=$00FF00) and (PixelFormat.BBitMask=$0000FF)) then
            raise EInvalidGraphicOperation.Create(SInvalidDIBPixelFormat);
        end;
    32: begin
          if not ((PixelFormat.RBitMask=$FF0000) and (PixelFormat.GBitMask=$00FF00) and (PixelFormat.BBitMask=$0000FF)) then
            raise EInvalidGraphicOperation.Create(SInvalidDIBPixelFormat);
        end;
  else
    raise EInvalidGraphicOperation.CreateFmt(SInvalidDIBBitCount, [ABitCount]);
  end;

  FBitCount := ABitCount;
  FHeight := AHeight;
  FWidth := AWidth;
  FWidthBytes := (((AWidth*ABitCount)+31) shr 5) * 4;
  FNextLine := -FWidthBytes;
  FSize := FWidthBytes*FHeight;
  UsePixelFormat := ABitCount in [16, 32];

  FPixelFormat := PixelFormat;

  FPaletteCount := 0;
  if FBitCount<=8 then
    FPaletteCount := 1 shl FBitCount;

  FBitmapInfoSize := SizeOf(TBitmapInfoHeader);
  if UsePixelFormat then
    Inc(FBitmapInfoSize, SizeOf(TLocalDIBPixelFormat));
  Inc(FBitmapInfoSize, SizeOf(TRGBQuad)*FPaletteCount);

  GetMem(FBitmapInfo, FBitmapInfoSize);
  FillChar(FBitmapInfo^, FBitmapInfoSize, 0);

  {  BitmapInfo setting.  }
  with FBitmapInfo^.bmiHeader do
  begin
    biSize := SizeOf(TBitmapInfoHeader);
    biWidth := FWidth;
    biHeight := FHeight;
    biPlanes := 1;
    biBitCount := FBitCount;
    if UsePixelFormat then
      biCompression := BI_BITFIELDS
    else
    begin
      if (FBitCount=4) and (Compressed) then
        biCompression := BI_RLE4
      else if (FBitCount=8) and (Compressed) then
        biCompression := BI_RLE8
      else
        biCompression := BI_RGB;
    end;
    biSizeImage := FSize;
    biXPelsPerMeter := 0;
    biYPelsPerMeter := 0;
    biClrUsed := 0;
    biClrImportant := 0;
  end;
  InfoOfs := SizeOf(TBitmapInfoHeader);

  if UsePixelFormat then
  begin
    with PLocalDIBPixelFormat(Integer(FBitmapInfo)+InfoOfs)^ do
    begin
      RBitMask := PixelFormat.RBitMask;
      GBitMask := PixelFormat.GBitMask;
      BBitMask := PixelFormat.BBitMask;
    end;

    Inc(InfoOfs, SizeOf(TLocalDIBPixelFormat));
  end;

  FColorTablePos := InfoOfs;

  FColorTable := ColorTable;
  Move(FColorTable, Pointer(Integer(FBitmapInfo)+FColorTablePos)^, SizeOf(TRGBQuad)*FPaletteCount);

  FCompressed := FBitmapInfo^.bmiHeader.biCompression in [BI_RLE4, BI_RLE8];
  FMemoryImage := MemoryImage or FCompressed;

  {  DIB making.  }
  if not Compressed then
  begin
    if MemoryImage then
    begin
      FPBits := Pointer(GlobalAlloc(GMEM_FIXED, FSize));
      if FPBits=nil then
        OutOfMemoryError;
    end else
    begin
      FDC := CreateCompatibleDC(0);

      FHandle := CreateDIBSection(FDC, FBitmapInfo^, DIB_RGB_COLORS, FPBits, 0, 0);
      if FHandle=0 then
        raise EOutOfResources.CreateFmt(SCannotMade, ['DIB']);

      FOldHandle := SelectObject(FDC, FHandle);
    end;
  end;

  FTopPBits := Pointer(Integer(FPBits)+(FHeight-1)*FWidthBytes);
end;

procedure TDIBSharedImage.Duplicate(Source: TDIBSharedImage; MemoryImage: Boolean);
begin
  if Source.FSize=0 then
  begin
    Create;
    FMemoryImage := MemoryImage;
  end else
  begin
    NewImage(Source.FWidth, Source.FHeight, Source.FBitCount,
      Source.FPixelFormat, Source.FColorTable, MemoryImage, Source.FCompressed);
    if FCompressed then
    begin
      FBitmapInfo.bmiHeader.biSizeImage := Source.FBitmapInfo.bmiHeader.biSizeImage;
      GetMem(FPBits, FBitmapInfo.bmiHeader.biSizeImage);
      Move(Source.FPBits^, FPBits^, FBitmapInfo.bmiHeader.biSizeImage);
    end else
    begin
      Move(Source.FPBits^, FPBits^, FBitmapInfo.bmiHeader.biSizeImage);
    end;
  end;
end;

procedure TDIBSharedImage.Compress(Source: TDIBSharedImage);

  procedure EncodeRLE4;
  var
    Size: Integer;

    function AllocByte: PByte;
    begin
      if Size mod 4096=0 then
        ReAllocMem(FPBits, Size+4095);
      Result := Pointer(Integer(FPBits)+Size);
      Inc(Size);
    end;

  var
    B1, B2, C: Byte;
    PB1, PB2: Integer;
    Src: PByte;
    X, Y: Integer;

    function GetPixel(x: Integer): Integer;
    begin
      if X and 1=0 then
        Result := PArrayByte(Src)[X shr 1] shr 4
      else
        Result := PArrayByte(Src)[X shr 1] and $0F;
    end;

  begin
    Size := 0;

    for y:=0 to Source.FHeight-1 do
    begin
      x := 0;
      Src := Pointer(Integer(Source.FPBits)+y*FWidthBytes);
      while x<Source.FWidth do
      begin
        if (Source.FWidth-x>3) and (GetPixel(x)=GetPixel(x+2)) then
        begin
          {  Encoding mode  }
          B1 := 2;
          B2 := (GetPixel(x) shl 4) or GetPixel(x+1);

          Inc(x, 2);

          C := B2;

          while (x<Source.FWidth) and (C and $F=GetPixel(x)) and (B1<255) do
          begin
            Inc(B1);
            Inc(x);
            C := (C shr 4) or (C shl 4);
          end;

          AllocByte^ := B1;
          AllocByte^ := B2;
        end else
        if (Source.FWidth-x>5) and ((GetPixel(x)<>GetPixel(x+2)) or (GetPixel(x+1)<>GetPixel(x+3))) and
          ((GetPixel(x+2)=GetPixel(x+4)) and (GetPixel(x+3)=GetPixel(x+5))) then
        begin
          {  Encoding mode }
          AllocByte^ := 2;
          AllocByte^ := (GetPixel(x) shl 4) or GetPixel(x+1);
          Inc(x, 2);
        end else
        begin
          if (Source.FWidth-x<4) then
          begin
            {  Encoding mode }
            while Source.FWidth-x>=2 do
            begin
              AllocByte^ := 2;
              AllocByte^ := (GetPixel(x) shl 4) or GetPixel(x+1);
              Inc(x, 2);
            end;

            if Source.FWidth-x=1 then
            begin
              AllocByte^ := 1;
              AllocByte^ := GetPixel(x) shl 4;
              Inc(x);
            end;
          end else
          begin
            {  Absolute mode  }
            PB1 := Size; AllocByte;
            PB2 := Size; AllocByte;

            B1 := 0;
            B2 := 4;

            AllocByte^ := (GetPixel(x) shl 4) or GetPixel(x+1);
            AllocByte^ := (GetPixel(x+2) shl 4) or GetPixel(x+3);

            Inc(x, 4);

            while (x+1<Source.FWidth) and (B2<254) do
            begin
              if (Source.FWidth-x>3) and (GetPixel(x)=GetPixel(x+2)) and (GetPixel(x+1)=GetPixel(x+3)) then
                Break;

              AllocByte^ := (GetPixel(x) shl 4) or GetPixel(x+1);
              Inc(B2, 2);
              Inc(x, 2);
            end;

            PByte(Integer(FPBits)+PB1)^ := B1;
            PByte(Integer(FPBits)+PB2)^ := B2;
          end;
        end;

        if Size and 1=1 then AllocByte;
      end;

      {  End of line  }
      AllocByte^ := 0;
      AllocByte^ := 0;
    end;

    {  End of bitmap  }
    AllocByte^ := 0;
    AllocByte^ := 1;

    FBitmapInfo.bmiHeader.biSizeImage := Size;
    FSize := Size;
  end;

  procedure EncodeRLE8;
  var
    Size: Integer;

    function AllocByte: PByte;
    begin
      if Size mod 4096=0 then
        ReAllocMem(FPBits, Size+4095);
      Result := Pointer(Integer(FPBits)+Size);
      Inc(Size);
    end;

  var
    B1, B2: Byte;
    PB1, PB2: Integer;
    Src: PByte;
    X, Y: Integer;
  begin
    Size := 0;

    for y:=0 to Source.FHeight-1 do
    begin
      x := 0;
      Src := Pointer(Integer(Source.FPBits)+y*FWidthBytes);
      while x<Source.FWidth do
      begin
        if (Source.FWidth-x>2) and (Src^=PByte(Integer(Src)+1)^) then
        begin
          {  Encoding mode  }
          B1 := 2;
          B2 := Src^;

          Inc(x, 2);
          Inc(Src, 2);

          while (x<Source.FWidth) and (Src^=B2) and (B1<255) do
          begin
            Inc(B1);
            Inc(x);
            Inc(Src);
          end;

          AllocByte^ := B1;
          AllocByte^ := B2;
        end else
        if (Source.FWidth-x>2) and (Src^<>PByte(Integer(Src)+1)^) and (PByte(Integer(Src)+1)^=PByte(Integer(Src)+2)^) then
        begin
          {  Encoding mode }
          AllocByte^ := 1;
          AllocByte^ := Src^; Inc(Src);
          Inc(x);
        end else
        begin
          if (Source.FWidth-x<4) then
          begin
            {  Encoding mode }
            if Source.FWidth-x=2 then
            begin
              AllocByte^ := 1;
              AllocByte^ := Src^; Inc(Src);

              AllocByte^ := 1;
              AllocByte^ := Src^; Inc(Src);
              Inc(x, 2);
            end else
            begin
              AllocByte^ := 1;
              AllocByte^ := Src^; Inc(Src);
              Inc(x);
            end;
          end else
          begin
            {  Absolute mode  }
            PB1 := Size; AllocByte;
            PB2 := Size; AllocByte;

            B1 := 0;
            B2 := 3;

            Inc(x, 3);

            AllocByte^ := Src^; Inc(Src);
            AllocByte^ := Src^; Inc(Src);
            AllocByte^ := Src^; Inc(Src);

            while (x<Source.FWidth) and (B2<255) do
            begin
              if (Source.FWidth-x>3) and (Src^=PByte(Integer(Src)+1)^) and (Src^=PByte(Integer(Src)+2)^) and (Src^=PByte(Integer(Src)+3)^) then
                Break;

              AllocByte^ := Src^; Inc(Src);
              Inc(B2);
              Inc(x);
            end;

            PByte(Integer(FPBits)+PB1)^ := B1;
            PByte(Integer(FPBits)+PB2)^ := B2;
          end;
        end;

        if Size and 1=1 then AllocByte;
      end;

      {  End of line  }
      AllocByte^ := 0;
      AllocByte^ := 0;
    end;

    {  End of bitmap  }
    AllocByte^ := 0;
    AllocByte^ := 1;

    FBitmapInfo.bmiHeader.biSizeImage := Size;
    FSize := Size;
  end;

begin
  if Source.FCompressed then
    Duplicate(Source, Source.FMemoryImage)
  else begin
    NewImage(Source.FWidth, Source.FHeight, Source.FBitCount,
      Source.FPixelFormat, Source.FColorTable, True, True);
    case FBitmapInfo.bmiHeader.biCompression of
      BI_RLE4: EncodeRLE4;
      BI_RLE8: EncodeRLE8;
    else
      Duplicate(Source, Source.FMemoryImage);
    end;
  end;
end;

procedure TDIBSharedImage.Decompress(Source: TDIBSharedImage; MemoryImage: Boolean);

  procedure DecodeRLE4;
  var
    B1, B2, C: Byte;
    Dest, Src, P: PByte;
    X, Y, i: Integer;
  begin
    Src := Source.FPBits;
    X := 0;
    Y := 0;

    while True do
    begin
      B1 := Src^; Inc(Src);
      B2 := Src^; Inc(Src);

      if B1=0 then
      begin
        case B2 of
          0: begin  {  End of line  }
               X := 0;
               Inc(Y);
             end;
          1: Break; {  End of bitmap  }
          2: begin  {  Difference of coordinates  }
               Inc(X, B1);
               Inc(Y, B2); Inc(Src, 2);
             end;
        else
          {  Absolute mode  }
          Dest := Pointer(Longint(FPBits)+Y*FWidthBytes);

          C := 0;
          for i:=0 to B2-1 do
          begin
            if i and 1=0 then
            begin
              C := Src^; Inc(Src);
            end else
            begin
              C := C shl 4;
            end;

            P := Pointer(Integer(Dest)+X shr 1);
            if X and 1=0 then
              P^ := (P^ and $0F) or (C and $F0)
            else
              P^ := (P^ and $F0) or ((C and $F0) shr 4);

            Inc(X);
          end;
        end;
      end else
      begin
        {  Encoding mode  }
        Dest := Pointer(Longint(FPBits)+Y*FWidthBytes);

        for i:=0 to B1-1 do
        begin
          P := Pointer(Integer(Dest)+X shr 1);
          if X and 1=0 then
            P^ := (P^ and $0F) or (B2 and $F0)
          else
            P^ := (P^ and $F0) or ((B2 and $F0) shr 4);

          Inc(X);

          // Swap nibble
          B2 := (B2 shr 4) or (B2 shl 4);
        end;
      end;

      {  Word arrangement  }
      Inc(Src, Longint(Src) and 1);
    end;
  end;

  procedure DecodeRLE8;
  var
    B1, B2: Byte;
    Dest, Src: PByte;
    X, Y: Integer;
  begin
    Dest := FPBits;
    Src := Source.FPBits;
    X := 0;
    Y := 0;

    while True do
    begin
      B1 := Src^; Inc(Src);
      B2 := Src^; Inc(Src);

      if B1=0 then
      begin
        case B2 of
          0: begin  {  End of line  }
               X := 0; Inc(Y);
               Dest := Pointer(Longint(FPBits)+Y*FWidthBytes+X);
             end;
          1: Break; {  End of bitmap  }
          2: begin  {  Difference of coordinates  }
               Inc(X, B1); Inc(Y, B2); Inc(Src, 2);
               Dest := Pointer(Longint(FPBits)+Y*FWidthBytes+X);
             end;
        else
          {  Absolute mode  }
          Move(Src^, Dest^, B2); Inc(Dest, B2); Inc(Src, B2);
        end;
      end else
      begin
        {  Encoding mode  }
        FillChar(Dest^, B1, B2); Inc(Dest, B1);
      end;

      {  Word arrangement  }
      Inc(Src, Longint(Src) and 1);
    end;
  end;

begin
  if not Source.FCompressed then
    Duplicate(Source, MemoryImage)
  else begin
    NewImage(Source.FWidth, Source.FHeight, Source.FBitCount,
      Source.FPixelFormat, Source.FColorTable, MemoryImage, False);
    case Source.FBitmapInfo.bmiHeader.biCompression of
      BI_RLE4: DecodeRLE4;
      BI_RLE8: DecodeRLE8;
    else
      Duplicate(Source, MemoryImage);
    end;                                               
  end;
end;

procedure TDIBSharedImage.ReadData(Stream: TStream; MemoryImage: Boolean);
var
  BI: TBitmapInfoHeader;
  BC: TBitmapCoreHeader;
  BCRGB: array[0..255] of TRGBTriple;

  procedure LoadRLE4;
  begin
    FSize := BI.biSizeImage;
    FPBits := GlobalAllocPtr(GMEM_FIXED, FSize);
    FBitmapInfo.bmiHeader.biSizeImage := FSize;
    Stream.ReadBuffer(FPBits^, FSize);
  end;

  procedure LoadRLE8;
  begin
    FSize := BI.biSizeImage;
    FPBits := GlobalAllocPtr(GMEM_FIXED, FSize);
    FBitmapInfo.bmiHeader.biSizeImage := FSize;
    Stream.ReadBuffer(FPBits^, FSize);
  end;

  procedure LoadRGB;
  var
    y: Integer;
  begin
    if BI.biHeight<0 then
    begin
      for y:=0 to Abs(BI.biHeight)-1 do
        Stream.ReadBuffer(Pointer(Integer(FTopPBits)+y*FNextLine)^, FWidthBytes);
    end else
    begin
      Stream.ReadBuffer(FPBits^, FSize);
    end;
  end;

var
  i, PalCount: Integer;
  OS2: Boolean;
  Localpf: TLocalDIBPixelFormat;
  AColorTable: TRGBQuads;
  APixelFormat: TDIBPixelFormat;
begin
  {  Header size reading  }
  i := Stream.Read(BI.biSize, 4);

  if i=0 then
  begin
    Create;
    Exit;
  end;
  if i<>4 then
    raise EInvalidGraphic.Create(SInvalidDIB);

  {  Kind check of DIB  }
  OS2 := False;

  case BI.biSize of
    SizeOf(TBitmapCoreHeader):
      begin
        {  OS/2 type  }
        Stream.ReadBuffer(Pointer(Integer(@BC)+4)^, SizeOf(TBitmapCoreHeader)-4);

        with BI do
        begin
          biClrUsed := 0;
          biCompression := BI_RGB;
          biBitCount := BC.bcBitCount;
          biHeight := BC.bcHeight;
          biWidth := BC.bcWidth;
        end;

        OS2 := True;
      end;
    SizeOf(TBitmapInfoHeader):
      begin
        {  Windows type  }
        Stream.ReadBuffer(Pointer(Integer(@BI)+4)^, SizeOf(TBitmapInfoHeader)-4);
      end;
  else
    raise EInvalidGraphic.Create(SInvalidDIB);
  end;

  {  Bit mask reading.  }
  if BI.biCompression = BI_BITFIELDS then
  begin
    Stream.ReadBuffer(Localpf, SizeOf(Localpf));
    with Localpf do
      APixelFormat := MakeDIBPixelFormatMask(RBitMask, GBitMask, BBitMask);
  end else
  begin
    if BI.biBitCount=16 then
      APixelFormat := MakeDIBPixelFormat(5, 5, 5)
    else if BI.biBitCount=32 then
      APixelFormat := MakeDIBPixelFormat(8, 8, 8)
    else
      APixelFormat := MakeDIBPixelFormat(8, 8, 8);
  end;

    {  Palette reading  }
  PalCount := BI.biClrUsed;
  if (PalCount=0) and (BI.biBitCount<=8) then
    PalCount := 1 shl BI.biBitCount;
  if PalCount>256 then PalCount := 256;

  FillChar(AColorTable, SizeOf(AColorTable), 0);

  if OS2 then
  begin
    {  OS/2 type  }
    Stream.ReadBuffer(BCRGB, SizeOf(TRGBTriple)*PalCount);
    for i:=0 to PalCount-1 do
    begin
      with BCRGB[i] do
        AColorTable[i] := RGBQuad(rgbtRed, rgbtGreen, rgbtBlue);
    end;
  end else
  begin
    {  Windows type  }
    Stream.ReadBuffer(AColorTable, SizeOf(TRGBQuad)*PalCount);
  end;

  {  DIB çÏê¨  }
  NewImage(BI.biWidth, Abs(BI.biHeight), BI.biBitCount, APixelFormat, AColorTable,
    MemoryImage, BI.biCompression in [BI_RLE4, BI_RLE8]);

  {  Pixel data reading  }
  case BI.biCompression of
    BI_RGB      : LoadRGB;
    BI_RLE4     : LoadRLE4;
    BI_RLE8     : LoadRLE8;
    BI_BITFIELDS: LoadRGB;
  else
    raise EInvalidGraphic.Create(SInvalidDIB);
  end;
end;

destructor TDIBSharedImage.Destroy;
begin
  if FHandle<>0 then
  begin
    if FOldHandle<>0 then SelectObject(FDC, FOldHandle);
    DeleteObject(FHandle);
  end else
  begin
    if FPBits<>nil then
      GlobalFreePtr(FPBits);
  end;

  PaletteManager.DeletePalette(FPalette);
  if FDC<>0 then DeleteDC(FDC);

  FreeMem(FBitmapInfo);
  inherited Destroy;
end;

procedure TDIBSharedImage.FreeHandle;
begin
end;

function TDIBSharedImage.GetPalette: THandle;
begin
  if FPaletteCount>0 then
  begin
    if FChangePalette then
    begin
      FChangePalette := False;
      PaletteManager.DeletePalette(FPalette);
      FPalette := PaletteManager.CreatePalette(FColorTable, FPaletteCount);
    end;
    Result := FPalette;
  end else
    Result := 0;
end;

procedure TDIBSharedImage.SetColorTable(const Value: TRGBQuads);
begin
  FColorTable := Value;
  FChangePalette := True;

  if (FSize>0) and (FPaletteCount>0) then
  begin
    SetDIBColorTable(FDC, 0, 256, FColorTable);
    Move(FColorTable, Pointer(Integer(FBitmapInfo)+FColorTablePos)^, SizeOf(TRGBQuad)*FPaletteCount);
  end;
end;

{ TDIB }

var
  FEmptyDIBImage: TDIBSharedImage;

function EmptyDIBImage: TDIBSharedImage;
begin
  if FEmptyDIBImage=nil then
  begin
    FEmptyDIBImage := TDIBSharedImage.Create;
    FEmptyDIBImage.Reference;
  end;
  Result := FEmptyDIBImage;
end;

constructor TDIB.Create;
begin
  inherited Create;
  SetImage(EmptyDIBImage);
end;

destructor TDIB.Destroy;
begin
  SetImage(EmptyDIBImage);
  FCanvas.Free;
  inherited Destroy;
end;

procedure TDIB.Assign(Source: TPersistent);

  procedure AssignBitmap(Source: TBitmap);
  var
    Data: array[0..1023] of Byte;
    BitmapRec: Windows.PBitmap;
    DIBSectionRec: PDIBSection;
    PaletteEntries: TPaletteEntries;
  begin
    GetPaletteEntries(Source.Palette, 0, 256, PaletteEntries);
    ColorTable := PaletteEntriesToRGBQuads(PaletteEntries);
    UpdatePalette;

    case GetObject(Source.Handle, SizeOf(Data), @Data) of
      SizeOf(Windows.TBitmap):
          begin
            BitmapRec := @Data;
            case BitmapRec^.bmBitsPixel of
              16: PixelFormat := MakeDIBPixelFormat(5, 5, 5);
            else
              PixelFormat := MakeDIBPixelFormat(8, 8, 8);
            end;
            SetSize(BitmapRec^.bmWidth, BitmapRec^.bmHeight, BitmapRec^.bmBitsPixel);
          end;
      SizeOf(TDIBSection):
          begin
            DIBSectionRec := @Data;
            if DIBSectionRec^.dsBm.bmBitsPixel>=24 then
            begin
              PixelFormat := MakeDIBPixelFormat(8, 8, 8);
            end else
            if DIBSectionRec^.dsBm.bmBitsPixel>8 then
            begin
              PixelFormat := MakeDIBPixelFormat(DIBSectionRec^.dsBitfields[0],
                DIBSectionRec^.dsBitfields[1], DIBSectionRec^.dsBitfields[2]);
            end else
            begin
              PixelFormat := MakeDIBPixelFormat(8, 8, 8);
            end;
            SetSize(DIBSectionRec^.dsBm.bmWidth, DIBSectionRec^.dsBm.bmHeight,
              DIBSectionRec^.dsBm.bmBitsPixel);
          end;
    else
      Exit;
    end;

    FillChar(PBits^, Size, 0);
    Canvas.Draw(0, 0, Source);
  end;

  procedure AssignGraphic(Source: TGraphic);
  begin
    if Source is TBitmap then
      AssignBitmap(TBitmap(Source))
    else
    begin
      SetSize(Source.Width, Source.Height, 24);
      FillChar(PBits^, Size, 0);
      Canvas.Draw(0, 0, Source);
    end;
  end;

begin
  if Source=nil then
  begin
    Clear;
  end else if Source is TDIB then
  begin
    if Source<>Self then
      SetImage(TDIB(Source).FImage);
  end else if Source is TGraphic then
  begin
    AssignGraphic(TGraphic(Source));
  end else if Source is TPicture then
  begin
    if TPicture(Source).Graphic<>nil then
      AssignGraphic(TPicture(Source).Graphic)
    else
      Clear;
  end else 
    inherited Assign(Source);
end;

procedure TDIB.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  OldPalette: HPalette;
  OldMode: Integer;
begin
  if Size>0 then
  begin
    if PaletteCount>0 then
    begin
      OldPalette := SelectPalette(ACanvas.Handle, Palette, False);
      RealizePalette(ACanvas.Handle);
    end else
      OldPalette := 0;
    try
      OldMode := SetStretchBltMode(ACanvas.Handle, COLORONCOLOR);
      try
        GdiFlush;
        if FImage.FMemoryImage then
        begin
          with Rect do
            StretchDIBits(ACanvas.Handle, Left, Top, Right - Left, Bottom - Top,
              0, 0, Width, Height, FImage.FPBits, FImage.FBitmapInfo^, DIB_RGB_COLORS , ACanvas.CopyMode);
        end else
        begin
          with Rect do
            StretchBlt(ACanvas.Handle, Left, Top, Right - Left, Bottom - Top,
              FImage.FDC, 0, 0, Width, Height, ACanvas.CopyMode);
        end;
      finally
        SetStretchBltMode(ACanvas.Handle, OldMode);
      end;
    finally
      SelectPalette(ACanvas.Handle, OldPalette, False);
    end;
  end;
end;

procedure TDIB.Clear;
begin
  SetImage(EmptyDIBImage);
end;

procedure TDIB.CanvasChanging(Sender: TObject);
begin
  Changing(False);
end;

procedure TDIB.Changing(MemoryImage: Boolean);
var
  TempImage: TDIBSharedImage;
begin
  if (FImage.RefCount>1) or (FImage.FCompressed) or ((not MemoryImage) and (FImage.FMemoryImage)) then
  begin
    TempImage := TDIBSharedImage.Create;
    try
      TempImage.Decompress(FImage, FImage.FMemoryImage and MemoryImage);
    except
      TempImage.Free;
      raise;
    end;
    SetImage(TempImage);
  end;
end;

procedure TDIB.AllocHandle;
var
  TempImage: TDIBSharedImage;
begin
  if FImage.FMemoryImage then
  begin
    TempImage := TDIBSharedImage.Create;
    try
      TempImage.Decompress(FImage, False);
    except
      TempImage.Free;
      raise;
    end;
    SetImage(TempImage);
  end;
end;

procedure TDIB.Compress;
var
  TempImage: TDIBSharedImage;
begin
  if (not FImage.FCompressed) and (BitCount in [4, 8]) then
  begin
    TempImage := TDIBSharedImage.Create;
    try
      TempImage.Compress(FImage);
    except
      TempImage.Free;
      raise;
    end;
    SetImage(TempImage);
  end;
end;

procedure TDIB.Decompress;
var
  TempImage: TDIBSharedImage;
begin
  if FImage.FCompressed then
  begin
    TempImage := TDIBSharedImage.Create;
    try
      TempImage.Decompress(FImage, FImage.FMemoryImage);
    except
      TempImage.Free;
      raise;
    end;
    SetImage(TempImage);
  end;
end;

procedure TDIB.FreeHandle;
var
  TempImage: TDIBSharedImage;
begin
  if not FImage.FMemoryImage then
  begin
    TempImage := TDIBSharedImage.Create;
    try
      TempImage.Duplicate(FImage, True);
    except
      TempImage.Free;
      raise;
    end;
    SetImage(TempImage);
  end;
end;

function TDIB.GetBitmapInfo: PBitmapInfo;
begin
  Result := FImage.FBitmapInfo;
end;

function TDIB.GetBitmapInfoSize: Integer;
begin
  Result := FImage.FBitmapInfoSize;
end;

function TDIB.GetCanvas: TCanvas;
begin
  if (FCanvas=nil) or (FCanvas.Handle=0) then
  begin
    AllocHandle;

    FCanvas := TCanvas.Create;
    FCanvas.Handle := FImage.FDC;
    FCanvas.OnChanging := CanvasChanging;
  end;
  Result := FCanvas;
end;

function TDIB.GetEmpty: Boolean;
begin
  Result := Size=0;
end;

function TDIB.GetHandle: THandle;
begin
  Changing(True);
  Result := FImage.FHandle;
end;

function TDIB.GetHeight: Integer;
begin
  Result := FHeight;
end;

function TDIB.GetPalette: HPalette;
begin
  Result := FImage.GetPalette;
end;

function TDIB.GetPaletteCount: Integer;
begin
  Result := FImage.FPaletteCount;
end;

function TDIB.GetPBits: Pointer;
begin
  Changing(True);

  if not FImage.FMemoryImage then
    GDIFlush;
  Result := FPBits;
end;

function TDIB.GetPBitsReadOnly: Pointer;
begin
  if not FImage.FMemoryImage then
    GDIFlush;
  Result := FPBits;
end;

function TDIB.GetScanLine(Y: Integer): Pointer;
begin
  Changing(True);
  if (Y<0) or (Y>=FHeight) then
    raise EInvalidGraphicOperation.CreateFmt(SScanline, [Y]);

  if not FImage.FMemoryImage then
    GDIFlush;
  Result := Pointer(Integer(FTopPBits)+Y*FNextLine);
end;

function TDIB.GetScanLineReadOnly(Y: Integer): Pointer;
begin
  if (Y<0) or (Y>=FHeight) then
    raise EInvalidGraphicOperation.CreateFmt(SScanline, [Y]);

  if not FImage.FMemoryImage then
    GDIFlush;
  Result := Pointer(Integer(FTopPBits)+Y*FNextLine);
end;

function TDIB.GetTopPBits: Pointer;
begin
  Changing(True);

  if not FImage.FMemoryImage then
    GDIFlush;
  Result := FTopPBits;
end;

function TDIB.GetTopPBitsReadOnly: Pointer;
begin
  if not FImage.FMemoryImage then
    GDIFlush;
  Result := FTopPBits;
end;           

function TDIB.GetWidth: Integer;
begin
  Result := FWidth;
end;

const
  Mask1: array[0..7] of DWORD = ($80, $40, $20, $10, $08, $04, $02, $01);
  Mask1n: array[0..7] of DWORD = ($FFFFFF7F, $FFFFFFBF, $FFFFFFDF, $FFFFFFEF,
    $FFFFFFF7, $FFFFFFFB, $FFFFFFFD, $FFFFFFFE);
  Mask4: array[0..1] of DWORD = ($F0, $0F);
  Mask4n: array[0..1] of DWORD = ($FFFFFF0F, $FFFFFFF0);

  Shift1: array[0..7] of DWORD = (7, 6, 5, 4, 3, 2, 1, 0);
  Shift4: array[0..1] of DWORD = (4, 0);

function TDIB.GetPixel(X, Y: Integer): DWORD;
begin
  Decompress;

  Result := 0;
  if (X>=0) and (X<FWidth) and (Y>=0) and (Y<FHeight) then
  begin
    case FBitCount of
      1 : Result := (PArrayByte(Integer(FTopPBits)+Y*FNextLine)[X shr 3] and Mask1[X and 7]) shr Shift1[X and 7];
      4 : Result := (PArrayByte(Integer(FTopPBits)+Y*FNextLine)[X shr 1] and Mask4[X and 1]) shr Shift4[X and 1];
      8 : Result := PArrayByte(Integer(FTopPBits)+Y*FNextLine)[X];
      16: Result := PArrayWord(Integer(FTopPBits)+Y*FNextLine)[X];
      24: with PArrayBGR(Integer(FTopPBits)+Y*FNextLine)[X] do
            Result := R or (G shl 8) or (B shl 16);
      32: Result := PArrayDWord(Integer(FTopPBits)+Y*FNextLine)[X];
    end;
  end;
end;

procedure TDIB.SetPixel(X, Y: Integer; Value: DWORD);
var
  P: PByte;
begin
  Changing(True);

  if (X>=0) and (X<FWidth) and (Y>=0) and (Y<FHeight) then
  begin
    case FBitCount of
      1 : begin
            P := @PArrayByte(Integer(FTopPBits)+Y*FNextLine)[X shr 3];
            P^ := (P^ and Mask1n[X and 7]) or ((Value and 1) shl Shift1[X and 7]);
          end;
      4 : begin
            P := @PArrayByte(Integer(FTopPBits)+Y*FNextLine)[X shr 3];
            P^ := (P^ and Mask4n[X and 1]) or ((Value and 15) shl Shift4[X and 1]);
          end;
      8 : PArrayByte(Integer(FTopPBits)+Y*FNextLine)[X] := Value;
      16: PArrayWord(Integer(FTopPBits)+Y*FNextLine)[X] := Value;
      24: with PArrayBGR(Integer(FTopPBits)+Y*FNextLine)[X] do
          begin
            B := Byte(Value shr 16);
            G := Byte(Value shr 8);
            R := Byte(Value);
          end;
      32: PArrayDWord(Integer(FTopPBits)+Y*FNextLine)[X] := Value;
    end;
  end;
end;
                            
procedure TDIB.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  {  For interchangeability with an old version.  }
  Filer.DefineBinaryProperty('DIB', LoadFromStream, nil, False);
end;

type
  TGlobalMemoryStream = class(TMemoryStream)
  private
    FHandle: THandle;
  public
    constructor Create(AHandle: THandle);
    destructor Destroy; override;
  end;

constructor TGlobalMemoryStream.Create(AHandle: THandle);
begin
  inherited Create;
  FHandle := AHandle;
  SetPointer(GlobalLock(AHandle), GlobalSize(AHandle));
end;

destructor TGlobalMemoryStream.Destroy;
begin
  GlobalUnLock(FHandle);
  SetPointer(nil, 0);
  inherited Destroy;
end;

procedure TDIB.LoadFromClipboardFormat(AFormat: Word; AData: THandle;
  APalette: HPALETTE);
var
  Stream: TGlobalMemoryStream;
begin
  Stream := TGlobalMemoryStream.Create(AData);
  try
    ReadData(Stream);
  finally
    Stream.Free;
  end;
end;

const
  BitmapFileType = Ord('B') + Ord('M')*$100;

procedure TDIB.LoadFromStream(Stream: TStream);
var
  BF: TBitmapFileHeader;
  i: Integer;
begin
  {  File header reading  }
  i := Stream.Read(BF, SizeOf(TBitmapFileHeader));
  if i=0 then Exit;
  if i<>SizeOf(TBitmapFileHeader) then
    raise EInvalidGraphic.Create(SInvalidDIB);

  {  Is the head 'BM'?  }
  if BF.bfType<>BitmapFileType then
    raise EInvalidGraphic.Create(SInvalidDIB);

  ReadData(Stream);
end;

procedure TDIB.ReadData(Stream: TStream);
var
  TempImage: TDIBSharedImage;
begin
  TempImage := TDIBSharedImage.Create;
  try
    TempImage.ReadData(Stream, FImage.FMemoryImage);
  except
    TempImage.Free;
    raise;
  end;
  SetImage(TempImage);
end;

procedure TDIB.SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
  var APalette: HPALETTE);
var
  P: Pointer;
  Stream: TMemoryStream;
begin
  AFormat := CF_DIB;
  APalette := 0;

  Stream := TMemoryStream.Create;
  try
    WriteData(Stream);

    AData := GlobalAlloc(GHND, Stream.Size);
    if AData=0 then OutOfMemoryError;

    P := GlobalLock(AData);
    Move(Stream.Memory^, P^, Stream.Size);
    GlobalUnLock(AData);
  finally
    Stream.Free;
  end;
end;

procedure TDIB.SaveToStream(Stream: TStream);
var
  BF: TBitmapFileHeader;
begin
  if Empty then Exit;

  with BF do
  begin
    bfType    := BitmapFileType;
    bfOffBits := SizeOf(TBitmapFileHeader)+BitmapInfoSize;
    bfSize    := bfOffBits+FImage.FBitmapInfo^.bmiHeader.biSizeImage;
    bfReserved1 := 0;
    bfReserved2 := 0;
  end;
  Stream.WriteBuffer(BF, SizeOf(TBitmapFileHeader));

  WriteData(Stream);
end;

procedure TDIB.WriteData(Stream: TStream);
begin
  if Empty then Exit;

  if not FImage.FMemoryImage then
    GDIFlush;

  Stream.WriteBuffer(FImage.FBitmapInfo^, FImage.FBitmapInfoSize);
  Stream.WriteBuffer(FImage.FPBits^, FImage.FBitmapInfo.bmiHeader.biSizeImage);
end;

procedure TDIB.SetBitCount(Value: Integer);
begin
  if Value<=0 then
    Clear
  else
  begin
    if Empty then
    begin
      SetSize(Max(Width, 1), Max(Height, 1), Value)
    end else
    begin
      ConvertBitCount(Value);
    end;
  end;
end;

procedure TDIB.SetHeight(Value: Integer);
begin
  if Value<=0 then
    Clear
  else
  begin
    if Empty then
      SetSize(Max(Width, 1), Value, 8)
    else
      SetSize(Width, Value, BitCount);
  end;
end;

procedure TDIB.SetWidth(Value: Integer);
begin
  if Value<=0 then
    Clear
  else
  begin
    if Empty then
      SetSize(Value, Max(Height, 1), 8)
    else
      SetSize(Value, Height, BitCount);
  end;
end;

procedure TDIB.SetImage(Value: TDIBSharedImage);
begin
  if FImage<>Value then
  begin
    if FCanvas<>nil then
      FCanvas.Handle := 0;
    
    FImage.Release;
    FImage := Value;
    FImage.Reference;

    if FCanvas<>nil then
      FCanvas.Handle := FImage.FDC;

    ColorTable := FImage.FColorTable;
    PixelFormat := FImage.FPixelFormat;

    FBitCount := FImage.FBitCount;
    FHeight := FImage.FHeight;
    FNextLine := FImage.FNextLine;
    FNowPixelFormat := FImage.FPixelFormat;
    FPBits := FImage.FPBits;
    FSize := FImage.FSize;
    FTopPBits := FImage.FTopPBits;
    FWidth := FImage.FWidth;
    FWidthBytes := FImage.FWidthBytes;
  end;
end;

procedure TDIB.SetNowPixelFormat(const Value: TDIBPixelFormat);
var
  Temp: TDIB;
begin
  if CompareMem(@Value, @FImage.FPixelFormat, SizeOf(TDIBPixelFormat)) then exit;

  PixelFormat := Value;

  Temp := TDIB.Create;
  try
    Temp.Assign(Self);
    SetSize(Width, Height, BitCount);
    Canvas.Draw(0, 0, Temp);
  finally
    Temp.Free;
  end;
end;

procedure TDIB.SetPalette(Value: HPalette);
var
  PaletteEntries: TPaletteEntries;
begin
  GetPaletteEntries(Value, 0, 256, PaletteEntries);
  DeleteObject(Value);

  ColorTable := PaletteEntriesToRGBQuads(PaletteEntries);
  UpdatePalette;
end;

procedure TDIB.SetSize(AWidth, AHeight, ABitCount: Integer);
var
  TempImage: TDIBSharedImage;
begin
  if (AWidth=Width) and (AHeight=Height) and (ABitCount=BitCount) and
    (NowPixelFormat.RBitMask=PixelFormat.RBitMask) and
    (NowPixelFormat.GBitMask=PixelFormat.GBitMask) and
    (NowPixelFormat.BBitMask=PixelFormat.BBitMask) then Exit;

  if (AWidth<=0) or (AHeight<=0) then
  begin
    Clear;
    Exit;
  end;

  TempImage := TDIBSharedImage.Create;
  try
    TempImage.NewImage(AWidth, AHeight, ABitCount,
      PixelFormat, ColorTable, FImage.FMemoryImage, False);
  except
    TempImage.Free;
    raise;
  end;
  SetImage(TempImage);

  PaletteModified := True;
end;

procedure TDIB.UpdatePalette;
var
  Col: TRGBQuads;
begin
  if CompareMem(@ColorTable, @FImage.FColorTable, SizeOf(ColorTable)) then Exit;

  Col := ColorTable;
  Changing(True);
  ColorTable := Col;
  FImage.SetColorTable(ColorTable);

  PaletteModified := True;
end;

procedure TDIB.ConvertBitCount(ABitCount: Integer);
var
  Temp: TDIB;

  procedure CreateHalftonePalette(R, G, B: Integer);
  var
    i: Integer;
  begin
    for i:=0 to 255 do
      with ColorTable[i] do
      begin
        rgbRed   := ((i shr (G+B-1)) and (1 shl R-1)) * 255 div (1 shl R-1);
        rgbGreen := ((i shr (B-1)) and (1 shl G-1)) * 255 div (1 shl G-1);
        rgbBlue  := ((i shr 0) and (1 shl B-1)) * 255 div (1 shl B-1);
      end;
  end;

  procedure PaletteToPalette_Inc;
  var
    x, y: Integer;
    i: DWORD;
    SrcP, DestP: Pointer;
    P: PByte;
  begin
    i := 0;

    for y:=0 to Height-1 do
    begin
      SrcP := Temp.ScanLine[y];
      DestP := ScanLine[y];

      for x:=0 to Width-1 do
      begin
        case Temp.BitCount of
          1 : begin
                i := (PArrayByte(SrcP)[X shr 3] and Mask1[X and 7]) shr Shift1[X and 7];
              end;
          4 : begin
                i := (PArrayByte(SrcP)[X and 1] and Mask4[X and 1]) shr Shift4[X and 1];
              end;
          8 : begin
                i := PByte(SrcP)^;
                Inc(PByte(SrcP));
              end;
        end;

        case BitCount of
          1 : begin
                P := @PArrayByte(DestP)[X shr 3];
                P^ := (P^ and Mask1n[X and 7]) or (i shl Shift1[X shr 3]);
              end;
          4 : begin
                P := @PArrayByte(DestP)[X shr 1];
                P^ := (P^ and Mask4n[X and 1]) or (i shl Shift4[X and 1]);
              end;
          8 : begin
                PByte(DestP)^ := i;
                Inc(PByte(DestP));
              end;
        end;
      end;
    end;
  end;

  procedure PaletteToRGB_or_RGBToRGB;
  var
    x, y: Integer;
    SrcP, DestP: Pointer;
    cR, cG, cB: Byte;
  begin
    cR := 0;
    cG := 0;
    cB := 0;

    for y:=0 to Height-1 do
    begin
      SrcP := Temp.ScanLine[y];
      DestP := ScanLine[y];

      for x:=0 to Width-1 do
      begin
        case Temp.BitCount of
          1 : begin
                with Temp.ColorTable[(PArrayByte(SrcP)[X shr 3] and Mask1[X and 7]) shr Shift1[X and 7]] do
                begin
                  cR := rgbRed;
                  cG := rgbGreen;
                  cB := rgbBlue;
                end;
              end;
          4 : begin
                with Temp.ColorTable[(PArrayByte(SrcP)[X shr 1] and Mask4[X and 1]) shr Shift4[X and 1]] do
                begin
                  cR := rgbRed;
                  cG := rgbGreen;
                  cB := rgbBlue;
                end;
              end;
          8 : begin
                with Temp.ColorTable[PByte(SrcP)^] do
                begin
                  cR := rgbRed;
                  cG := rgbGreen;
                  cB := rgbBlue;
                end;
                Inc(PByte(SrcP));
              end;
          16: begin
                pfGetRGB(Temp.NowPixelFormat, PWord(SrcP)^, cR, cG, cB);
                Inc(PWord(SrcP));
              end;
          24: begin
                with PBGR(SrcP)^ do
                begin
                  cR := R;
                  cG := G;
                  cB := B;
                end;

                Inc(PBGR(SrcP));
              end;
          32: begin
                pfGetRGB(Temp.NowPixelFormat, PDWORD(SrcP)^, cR, cG, cB);
                Inc(PDWORD(SrcP));
              end;
        end;

        case BitCount of
          16: begin
                PWord(DestP)^ := pfRGB(NowPixelFormat, cR, cG, cB);
                Inc(PWord(DestP));
              end;
          24: begin
                with PBGR(DestP)^ do
                begin
                  R := cR;
                  G := cG;
                  B := cB;
                end;
                Inc(PBGR(DestP));
              end;
          32: begin
                PDWORD(DestP)^ := pfRGB(NowPixelFormat, cR, cG, cB);
                Inc(PDWORD(DestP));
              end;
        end;
      end;
    end;
  end;

begin
  if Size=0 then exit;

  Temp := TDIB.Create;
  try
    Temp.Assign(Self);
    SetSize(Temp.Width, Temp.Height, ABitCount);

    if FImage=Temp.FImage then Exit;

    if (Temp.BitCount<=8) and (BitCount<=8) then
    begin
      {  The image is converted from the palette color image into the palette color image.  }
      if Temp.BitCount<=BitCount then
      begin
        PaletteToPalette_Inc;
      end else
      begin
        case BitCount of
          1: begin
               ColorTable[0] := RGBQuad(0, 0, 0);
               ColorTable[1] := RGBQuad(255, 255, 255);
             end;
          4: CreateHalftonePalette(1, 2, 1);
          8: CreateHalftonePalette(3, 3, 2);
        end;
        UpdatePalette;

        Canvas.Draw(0, 0, Temp);
      end;
    end else
    if (Temp.BitCount<=8) and (BitCount>8) then
    begin
      {  The image is converted from the palette color image into the rgb color image.  }
      PaletteToRGB_or_RGBToRGB;
    end else
    if (Temp.BitCount>8) and (BitCount<=8) then
    begin
      {  The image is converted from the rgb color image into the palette color image.  }
      case BitCount of
        1: begin
             ColorTable[0] := RGBQuad(0, 0, 0);
             ColorTable[1] := RGBQuad(255, 255, 255);
           end;
        4: CreateHalftonePalette(1, 2, 1);
        8: CreateHalftonePalette(3, 3, 2);
      end;
      UpdatePalette;

      Canvas.Draw(0, 0, Temp);
    end else
    if (Temp.BitCount>8) and (BitCount>8) then
    begin
      {  The image is converted from the rgb color image into the rgb color image.  }
      PaletteToRGB_or_RGBToRGB;
    end;
  finally
    Temp.Free;
  end;
end;

{  Special effect  }

procedure TDIB.StartProgress(const Name: string);
begin
  FProgressName := Name;
  FProgressOld := 0;
  FProgressOldTime := GetTickCount;
  FProgressY := 0;
  FProgressOldY := 0;
  Progress(Self, psStarting, 0, False, Rect(0, 0, Width, Height), FProgressName);
end;

procedure TDIB.EndProgress;
begin
  Progress(Self, psEnding, 100, True, Rect(0, FProgressOldY, Width, Height), FProgressName);
end;

procedure TDIB.UpdateProgress(PercentY: Integer);
var
  Redraw: Boolean;
  Percent: DWORD;
begin
  Redraw := (GetTickCount-FProgressOldTime>200) and (FProgressY-FProgressOldY>32) and
    (((Height div 3>Integer(FProgressY)) and (FProgressOldY=0)) or (FProgressOldY<>0));

  Percent := PercentY*100 div Height;

  if (Percent<>FProgressOld) or (Redraw) then
  begin
    Progress(Self, psRunning, Percent, Redraw,
      Rect(0, FProgressOldY, Width, FProgressY), FProgressName);
    if Redraw then
    begin
      FProgressOldY := FProgressY;
      FProgressOldTime := GetTickCount;
    end;

    FProgressOld := Percent;
  end;

  Inc(FProgressY);
end;

procedure TDIB.Blur(ABitCount: Integer; Radius: Integer);
type
  TAve = record
    cR, cG, cB: DWORD;
    c: DWORD;
  end;
  TArrayAve = array[0..0] of TAve;

var
  Temp: TDIB;

  procedure AddAverage(Y, XCount: Integer; var Ave: TArrayAve);
  var
    X: Integer;
    SrcP: Pointer;
    AveP: ^TAve;
    R, G, B: Byte;
  begin
    case Temp.BitCount of
      1 : begin
            SrcP := Pointer(Integer(Temp.TopPBits)+Y*Temp.NextLine);
            AveP := @Ave;
            for x:=0 to XCount-1 do
            begin
              with Temp.ColorTable[(PByte(Integer(SrcP)+X shr 3)^ and Mask1[x and 7]) shr Shift1[x and 7]], AveP^ do
              begin
                Inc(cR, rgbRed);
                Inc(cG, rgbGreen);
                Inc(cB, rgbBlue);
                Inc(c);
              end;
              Inc(AveP);
            end;
          end;
      4 : begin
            SrcP := Pointer(Integer(Temp.TopPBits)+Y*Temp.NextLine);
            AveP := @Ave;
            for x:=0 to XCount-1 do
            begin
              with Temp.ColorTable[(PByte(Integer(SrcP)+X shr 1)^ and Mask4[x and 1]) shr Shift4[x and 1]], AveP^ do
              begin
                Inc(cR, rgbRed);
                Inc(cG, rgbGreen);
                Inc(cB, rgbBlue);
                Inc(c);
              end;
              Inc(AveP);
            end;
          end;
      8 : begin
            SrcP := Pointer(Integer(Temp.TopPBits)+Y*Temp.NextLine);
            AveP := @Ave;
            for x:=0 to XCount-1 do
            begin
              with Temp.ColorTable[PByte(SrcP)^], AveP^ do
              begin
                Inc(cR, rgbRed);
                Inc(cG, rgbGreen);
                Inc(cB, rgbBlue);
                Inc(c);
              end;
              Inc(PByte(SrcP));
              Inc(AveP);
            end;
          end;
      16: begin
            SrcP := Pointer(Integer(Temp.TopPBits)+Y*Temp.NextLine);
            AveP := @Ave;
            for x:=0 to XCount-1 do
            begin
              pfGetRGB(Temp.NowPixelFormat, PWord(SrcP)^, R, G, B);
              with AveP^ do
              begin
                Inc(cR, R);
                Inc(cG, G);
                Inc(cB, B);
                Inc(c);
              end;
              Inc(PWord(SrcP));
              Inc(AveP);
            end;
          end;
      24: begin
            SrcP := Pointer(Integer(Temp.TopPBits)+Y*Temp.NextLine);
            AveP := @Ave;
            for x:=0 to XCount-1 do
            begin
              with PBGR(SrcP)^, AveP^ do
              begin
                Inc(cR, R);
                Inc(cG, G);
                Inc(cB, B);
                Inc(c);
              end;
              Inc(PBGR(SrcP));
              Inc(AveP);
            end;
          end;
      32: begin
            SrcP := Pointer(Integer(Temp.TopPBits)+Y*Temp.NextLine);
            AveP := @Ave;
            for x:=0 to XCount-1 do
            begin
              pfGetRGB(Temp.NowPixelFormat, PDWORD(SrcP)^, R, G, B);
              with AveP^ do
              begin
                Inc(cR, R);
                Inc(cG, G);
                Inc(cB, B);
                Inc(c);
              end;
              Inc(PDWORD(SrcP));
              Inc(AveP);
            end;
          end;
    end;
  end;

  procedure DeleteAverage(Y, XCount: Integer; var Ave: TArrayAve);
  var
    X: Integer;
    SrcP: Pointer;
    AveP: ^TAve;
    R, G, B: Byte;
  begin
    case Temp.BitCount of
      1 : begin
            SrcP := Pointer(Integer(Temp.TopPBits)+Y*Temp.NextLine);
            AveP := @Ave;
            for x:=0 to XCount-1 do
            begin
              with Temp.ColorTable[(PByte(Integer(SrcP)+X shr 3)^ and Mask1[x and 7]) shr Shift1[x and 7]], AveP^ do
              begin
                Dec(cR, rgbRed);
                Dec(cG, rgbGreen);
                Dec(cB, rgbBlue);
                Dec(c);
              end;
              Inc(AveP);
            end;
          end;
      4 : begin
            SrcP := Pointer(Integer(Temp.TopPBits)+Y*Temp.NextLine);
            AveP := @Ave;
            for x:=0 to XCount-1 do
            begin
              with Temp.ColorTable[(PByte(Integer(SrcP)+X shr 1)^ and Mask4[x and 1]) shr Shift4[x and 1]], AveP^ do
              begin
                Dec(cR, rgbRed);
                Dec(cG, rgbGreen);
                Dec(cB, rgbBlue);
                Dec(c);
              end;
              Inc(AveP);
            end;
          end;
      8 : begin
            SrcP := Pointer(Integer(Temp.TopPBits)+Y*Temp.NextLine);
            AveP := @Ave;
            for x:=0 to XCount-1 do
            begin
              with Temp.ColorTable[PByte(SrcP)^], AveP^ do
              begin
                Dec(cR, rgbRed);
                Dec(cG, rgbGreen);
                Dec(cB, rgbBlue);
                Dec(c);
              end;
              Inc(PByte(SrcP));
              Inc(AveP);
            end;
          end;
      16: begin
            SrcP := Pointer(Integer(Temp.TopPBits)+Y*Temp.NextLine);
            AveP := @Ave;
            for x:=0 to XCount-1 do
            begin
              pfGetRGB(Temp.NowPixelFormat, PWord(SrcP)^, R, G, B);
              with AveP^ do
              begin
                Dec(cR, R);
                Dec(cG, G);
                Dec(cB, B);
                Dec(c);
              end;
              Inc(PWord(SrcP));
              Inc(AveP);
            end;
          end;
      24: begin
            SrcP := Pointer(Integer(Temp.TopPBits)+Y*Temp.NextLine);
            AveP := @Ave;
            for x:=0 to XCount-1 do
            begin
              with PBGR(SrcP)^, AveP^ do
              begin
                Dec(cR, R);
                Dec(cG, G);
                Dec(cB, B);
                Dec(c);
              end;
              Inc(PBGR(SrcP));
              Inc(AveP);
            end;
          end;
      32: begin
            SrcP := Pointer(Integer(Temp.TopPBits)+Y*Temp.NextLine);
            AveP := @Ave;
            for x:=0 to XCount-1 do
            begin
              pfGetRGB(Temp.NowPixelFormat, PDWORD(SrcP)^, R, G, B);
              with AveP^ do
              begin
                Dec(cR, R);
                Dec(cG, G);
                Dec(cB, B);
                Dec(c);
              end;
              Inc(PDWORD(SrcP));
              Inc(AveP);
            end;
          end;
    end;
  end;

  procedure Blur_Radius_Other;
  var
    FirstX, LastX, FirstX2, LastX2, FirstY, LastY: Integer;
    x, y, x2, y2, jx, jy: Integer;
    Ave: TAve;
    AveX: ^TArrayAve;
    DestP: Pointer;
    P: PByte;
  begin
    GetMem(AveX, Width*SizeOf(TAve));
    try
      FillChar(AveX^, Width*SizeOf(TAve), 0);

      FirstX2 := -1;
      LastX2 := -1;
      FirstY := -1;
      LastY := -1;

      x := 0;
      for x2:=-Radius to Radius do
      begin
        jx := x+x2;
        if (jx>=0) and (jx<Width) then
        begin
          if FirstX2=-1 then FirstX2 := jx;
          if LastX2<jx then LastX2 := jx;
        end;
      end;

      y := 0;
      for y2:=-Radius to Radius do
      begin
        jy := y+y2;
        if (jy>=0) and (jy<Height) then
        begin
          if FirstY=-1 then FirstY := jy;
          if LastY<jy then LastY := jy;
        end;
      end;

      for y:=FirstY to LastY do
        AddAverage(y, Temp.Width, AveX^);

      for y:=0 to Height-1 do
      begin
        DestP := ScanLine[y];

        {  The average is updated.  }
        if y-FirstY=Radius+1 then
        begin
          DeleteAverage(FirstY, Temp.Width, AveX^);
          Inc(FirstY);
        end;

        if LastY-y=Radius-1 then
        begin
          Inc(LastY); if LastY>=Height then LastY := Height-1;
          AddAverage(LastY, Temp.Width, AveX^);
        end;

        {  The average is calculated again.  }
        FirstX := FirstX2;
        LastX := LastX2;

        FillChar(Ave, SizeOf(Ave), 0);
        for x:=FirstX to LastX do
          with AveX[x] do
          begin
            Inc(Ave.cR, cR);
            Inc(Ave.cG, cG);
            Inc(Ave.cB, cB);
            Inc(Ave.c, c);
          end;

        for x:=0 to Width-1 do
        begin
          {  The average is updated.  }
          if x-FirstX=Radius+1 then
          begin
            with AveX[FirstX] do
            begin
              Dec(Ave.cR, cR);
              Dec(Ave.cG, cG);
              Dec(Ave.cB, cB);
              Dec(Ave.c, c);
            end;
            Inc(FirstX);
          end;

          if LastX-x=Radius-1 then
          begin
            Inc(LastX); if LastX>=Width then LastX := Width-1;
            with AveX[LastX] do
            begin
              Inc(Ave.cR, cR);
              Inc(Ave.cG, cG);
              Inc(Ave.cB, cB);
              Inc(Ave.c, c);
            end;
          end;

          {  The average is written.  }
          case BitCount of
            1 : begin
                  P := @PArrayByte(DestP)[X shr 3];
                  with Ave do
                    P^ := (P^ and Mask1n[X and 7]) or (DWORD(Ord(((cR+cG+cB) div c) div 3>127)) shl Shift1[X and 7]);
                end;
            4 : begin
                  P := @PArrayByte(DestP)[X shr 1];
                  with Ave do
                    P^ := (P^ and Mask4n[X and 1]) or (((((cR+cG+cB) div c) div 3) shr 4) shl Shift4[X and 1]);
                end;
            8 : begin
                  with Ave do
                    PByte(DestP)^ := ((cR+cG+cB) div c) div 3;
                  Inc(PByte(DestP));
                end;
            16: begin
                  with Ave do
                    PWORD(DestP)^ := pfRGB(NowPixelFormat, cR div c, cG div c, cB div c);
                  Inc(PWORD(DestP));
                end;
            24: begin
                  with PBGR(DestP)^, Ave do
                  begin
                    R := cR div c;
                    G := cG div c;
                    B := cB div c;
                  end;
                  Inc(PBGR(DestP));
                end;
            32: begin
                  with Ave do
                    PDWORD(DestP)^ := pfRGB(NowPixelFormat, cR div c, cG div c, cB div c);
                  Inc(PDWORD(DestP));
                end;
          end;
        end;

        UpdateProgress(y);
      end;
    finally
      FreeMem(AveX);
    end;
  end;

var
  i, j: Integer;
begin
  if Empty or (Radius=0) then Exit;

  Radius := Abs(Radius);

  StartProgress('Blur');
  try
    Temp := TDIB.Create;
    try
      Temp.Assign(Self);
      SetSize(Width, Height, ABitCount);

      if ABitCount<=8 then
      begin
        FillChar(ColorTable, SizeOf(ColorTable), 0);
        for i:=0 to (1 shl ABitCount)-1 do
        begin
          j := i * (1 shl (8-ABitCount));
          j := j or (j shr ABitCount);
          ColorTable[i] := RGBQuad(j, j, j);
        end;
        UpdatePalette;
      end;

      Blur_Radius_Other;
    finally
      Temp.Free;
    end;
  finally
    EndProgress;
  end;
end;

procedure TDIB.Greyscale(ABitCount: Integer);
var
  YTblR, YTblG, YTblB: array[0..255] of Byte;
  i, j, x, y: Integer;
  c: DWORD;
  R, G, B: Byte;
  Temp: TDIB;
  DestP, SrcP: Pointer;
  P: PByte;
begin
  if Empty then exit;

  Temp := TDIB.Create;
  try
    Temp.Assign(Self);
    SetSize(Width, Height, ABitCount);

    if ABitCount<=8 then
    begin
      FillChar(ColorTable, SizeOf(ColorTable), 0);
      for i:=0 to (1 shl ABitCount)-1 do
      begin
        j := i * (1 shl (8-ABitCount));
        j := j or (j shr ABitCount);
        ColorTable[i] := RGBQuad(j, j, j);
      end;
      UpdatePalette;
    end;

    for i:=0 to 255 do
    begin
      YTblR[i] := Trunc(0.3588*i);
      YTblG[i] := Trunc(0.4020*i);
      YTblB[i] := Trunc(0.2392*i);
    end;

    c := 0;

    StartProgress('Greyscale');
    try
      for y:=0 to Height-1 do
      begin
        DestP := ScanLine[y];
        SrcP := Temp.ScanLine[y];

        for x:=0 to Width-1 do
        begin
          case Temp.BitCount of
            1 : begin
                  with Temp.ColorTable[(PArrayByte(SrcP)[X shr 3] and Mask1[X and 7]) shr Shift1[X and 7]] do
                    c := YTblR[rgbRed]+YTblG[rgbGreen]+YTblB[rgbBlue];
                end;
            4 : begin
                  with Temp.ColorTable[(PArrayByte(SrcP)[X shr 1] and Mask4[X and 1]) shr Shift4[X and 1]] do
                    c := YTblR[rgbRed]+YTblG[rgbGreen]+YTblB[rgbBlue];
                end;
            8 : begin
                  with Temp.ColorTable[PByte(SrcP)^] do
                    c := YTblR[rgbRed]+YTblG[rgbGreen]+YTblB[rgbBlue];
                  Inc(PByte(SrcP));
                end;
            16: begin
                  pfGetRGB(Temp.NowPixelFormat, PWord(SrcP)^, R, G, B);
                  c := YTblR[R]+YTblR[G]+YTblR[B];
                  Inc(PWord(SrcP));
                end;
            24: begin
                  with PBGR(SrcP)^ do
                    c := YTblR[R]+YTblG[G]+YTblB[B];
                  Inc(PBGR(SrcP));
                end;
            32: begin
                  pfGetRGB(Temp.NowPixelFormat, PDWORD(SrcP)^, R, G, B);
                  c := YTblR[R]+YTblR[G]+YTblR[B];
                  Inc(PDWORD(SrcP));
                end;
          end;

          case BitCount of
            1 : begin
                  P := @PArrayByte(DestP)[X shr 3];
                  P^ := (P^ and Mask1n[X and 7]) or (DWORD(Ord(c>127)) shl Shift1[X and 7]);
                end;
            4 : begin
                  P := @PArrayByte(DestP)[X shr 1];
                  P^ := (P^ and Mask4n[X and 1]) or ((c shr 4) shl Shift4[X and 1]);
                end;
            8 : begin
                  PByte(DestP)^ := c;
                  Inc(PByte(DestP));
                end;
            16: begin
                  PWord(DestP)^ := pfRGB(NowPixelFormat, c, c, c);
                  Inc(PWord(DestP));
                end;
            24: begin
                  with PBGR(DestP)^ do
                  begin
                    R := c;
                    G := c;
                    B := c;
                  end;
                  Inc(PBGR(DestP));
                end;
            32: begin
                  PDWORD(DestP)^ := pfRGB(NowPixelFormat, c, c, c);
                  Inc(PDWORD(DestP));
                end;
          end;
        end;

        UpdateProgress(y);
      end;
    finally
      EndProgress;
    end;
  finally
    Temp.Free;
  end;
end;

procedure TDIB.Mirror(MirrorX, MirrorY: Boolean);
var
  x, y, Width2, c: Integer;
  P1, P2, TempBuf: Pointer;
begin
  if Empty then exit;
  if (not MirrorX) and (not MirrorY) then Exit;

  if (not MirrorX) and (MirrorY) then
  begin
    GetMem(TempBuf, WidthBytes);
    try
      StartProgress('Mirror');
      try
        for y:=0 to Height shr 1-1 do
        begin
          P1 := ScanLine[y];
          P2 := ScanLine[Height-y-1];

          Move(P1^, TempBuf^, WidthBytes);
          Move(P2^, P1^, WidthBytes);
          Move(TempBuf^, P2^, WidthBytes);

          UpdateProgress(y*2);
        end;
      finally
        EndProgress;
      end;
    finally
      FreeMem(TempBuf, WidthBytes);
    end;
  end else if (MirrorX) and (not MirrorY) then
  begin
    Width2 := Width shr 1;

    StartProgress('Mirror');
    try
      for y:=0 to Height-1 do
      begin
        P1 := ScanLine[y];

        case BitCount of
          1 : begin
                for x:=0 to Width2-1 do
                begin
                  c := Pixels[x, y];
                  Pixels[x, y] := Pixels[Width-x-1, y];
                  Pixels[Width-x-1, y] := c;
                end;
              end;
          4 : begin
                for x:=0 to Width2-1 do
                begin
                  c := Pixels[x, y];
                  Pixels[x, y] := Pixels[Width-x-1, y];
                  Pixels[Width-x-1, y] := c;
                end;
              end;
          8 : begin
                P2 := Pointer(Integer(P1)+Width-1);
                for x:=0 to Width2-1 do
                begin
                  PByte(@c)^ := PByte(P1)^;
                  PByte(P1)^ := PByte(P2)^;
                  PByte(P2)^ := PByte(@c)^;
                  Inc(PByte(P1));
                  Dec(PByte(P2));
                end;
              end;
          16: begin
                P2 := Pointer(Integer(P1)+(Width-1)*2);
                for x:=0 to Width2-1 do
                begin
                  PWord(@c)^ := PWord(P1)^;
                  PWord(P1)^ := PWord(P2)^;
                  PWord(P2)^ := PWord(@c)^;
                  Inc(PWord(P1));
                  Dec(PWord(P2));
                end;       
              end;
          24: begin
                P2 := Pointer(Integer(P1)+(Width-1)*3);
                for x:=0 to Width2-1 do              
                begin
                  PBGR(@c)^ := PBGR(P1)^;
                  PBGR(P1)^ := PBGR(P2)^;
                  PBGR(P2)^ := PBGR(@c)^;
                  Inc(PBGR(P1));
                  Dec(PBGR(P2));
                end;
              end;
          32: begin
                P2 := Pointer(Integer(P1)+(Width-1)*4);
                for x:=0 to Width2-1 do
                begin
                  PDWORD(@c)^ := PDWORD(P1)^;
                  PDWORD(P1)^ := PDWORD(P2)^;
                  PDWORD(P2)^ := PDWORD(@c)^;
                  Inc(PDWORD(P1));
                  Dec(PDWORD(P2));
                end;
              end;
        end;

        UpdateProgress(y);
      end;
    finally
      EndProgress;
    end;
  end else if (MirrorX) and (MirrorY) then
  begin
    StartProgress('Mirror');
    try
      for y:=0 to Height shr 1-1 do
      begin
        P1 := ScanLine[y];
        P2 := ScanLine[Height-y-1];

        case BitCount of
          1 : begin
                for x:=0 to Width-1 do
                begin
                  c := Pixels[x, y];
                  Pixels[x, y] := Pixels[Width-x-1, Height-y-1];
                  Pixels[Width-x-1, Height-y-1] := c;
                end;
              end;
          4 : begin
                for x:=0 to Width-1 do
                begin
                  c := Pixels[x, y];
                  Pixels[x, y] := Pixels[Width-x-1, Height-y-1];
                  Pixels[Width-x-1, Height-y-1] := c;
                end;
              end;
          8 : begin
                P2 := Pointer(Integer(P2)+Width-1);
                for x:=0 to Width-1 do
                begin
                  PByte(@c)^ := PByte(P1)^;
                  PByte(P1)^ := PByte(P2)^;
                  PByte(P2)^ := PByte(@c)^;
                  Inc(PByte(P1));
                  Dec(PByte(P2));
                end;
              end;
          16: begin
                P2 := Pointer(Integer(P2)+(Width-1)*2);
                for x:=0 to Width-1 do
                begin
                  PWord(@c)^ := PWord(P1)^;
                  PWord(P1)^ := PWord(P2)^;
                  PWord(P2)^ := PWord(@c)^;
                  Inc(PWord(P1));
                  Dec(PWord(P2));
                end;
              end;
          24: begin
                P2 := Pointer(Integer(P2)+(Width-1)*3);
                for x:=0 to Width-1 do
                begin
                  PBGR(@c)^ := PBGR(P1)^;
                  PBGR(P1)^ := PBGR(P2)^;
                  PBGR(P2)^ := PBGR(@c)^;
                  Inc(PBGR(P1));
                  Dec(PBGR(P2));
                end;
              end;
          32: begin
                P2 := Pointer(Integer(P2)+(Width-1)*4);
                for x:=0 to Width-1 do
                begin
                  PDWORD(@c)^ := PDWORD(P1)^;
                  PDWORD(P1)^ := PDWORD(P2)^;
                  PDWORD(P2)^ := PDWORD(@c)^;
                  Inc(PDWORD(P1));
                  Dec(PDWORD(P2));
                end;
              end;
        end;

        UpdateProgress(y*2);
      end;
    finally
      EndProgress;
    end;
  end;
end;

procedure TDIB.Negative;
var
  i, i2: Integer;
  P: Pointer;
begin
  if Empty then exit;

  if BitCount<=8 then
  begin
    for i:=0 to 255 do
      with ColorTable[i] do
      begin
        rgbRed := 255-rgbRed;
        rgbGreen := 255-rgbGreen;
        rgbBlue := 255-rgbBlue;
      end;
    UpdatePalette;
  end else
  begin
    P := PBits;
    i2 := Size;
    asm
      mov ecx,i2
      mov eax,P
      mov edx,ecx

    {  Unit of DWORD.  }
    @@qword_skip:
      shr ecx,2
      jz @@dword_skip

      dec ecx
    @@dword_loop:
      not dword ptr [eax+ecx*4]
      dec ecx
      jnl @@dword_loop

      mov ecx,edx
      shr ecx,2
      add eax,ecx*4

    {  Unit of Byte.  }
    @@dword_skip:
      mov ecx,edx
      and ecx,3
      jz @@byte_skip

      dec ecx
    @@loop_byte:
      not byte ptr [eax+ecx]
      dec ecx
      jnl @@loop_byte

    @@byte_skip:
    end;
  end;
end;

{  TCustomDXDIB  }

constructor TCustomDXDIB.Create(AOnwer: TComponent);
begin
  inherited Create(AOnwer);
  FDIB := TDIB.Create;
end;

destructor TCustomDXDIB.Destroy;
begin
  FDIB.Free;
  inherited Destroy;
end;

procedure TCustomDXDIB.SetDIB(Value: TDIB);
begin
  FDIB.Assign(Value);
end;

{  TCustomDXPaintBox  }

constructor TCustomDXPaintBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDIB := TDIB.Create;

  ControlStyle := ControlStyle + [csReplicatable];
  Height := 105;
  Width := 105;
end;

destructor TCustomDXPaintBox.Destroy;
begin
  FDIB.Free;
  inherited Destroy;
end;

function TCustomDXPaintBox.GetPalette: HPALETTE;
begin
  Result := FDIB.Palette;
end;

procedure TCustomDXPaintBox.Paint;

  procedure Draw2(Width, Height: Integer);
  begin
    if (Width<>FDIB.Width) or (Height<>FDIB.Height) then
    begin
      if FCenter then
      begin
        inherited Canvas.StretchDraw(Bounds(-(Width-ClientWidth) div 2,
          -(Height-ClientHeight) div 2, Width, Height), FDIB);
      end else
      begin
        inherited Canvas.StretchDraw(Bounds(0, 0, Width, Height), FDIB);
      end;
    end else
    begin
      if FCenter then
      begin
        inherited Canvas.Draw(-(Width-ClientWidth) div 2, -(Height-ClientHeight) div 2,
          FDIB);
      end else
      begin
        inherited Canvas.Draw(0, 0, FDIB);
      end;
    end;
  end;

var
  r, r2: Single;
  ViewWidth2, ViewHeight2: Integer;
begin
  inherited Paint;

  with inherited Canvas do
  begin
    if (csDesigning in ComponentState) then
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;

    if FDIB.Empty then Exit;

    if (FViewWidth>0) or (FViewHeight>0) then
    begin
      ViewWidth2 := FViewWidth;
      if ViewWidth2=0 then ViewWidth2 := FDIB.Width;
      ViewHeight2 := FViewHeight;
      if ViewHeight2=0 then ViewHeight2 := FDIB.Height;

      if FAutoStretch then
      begin
        if (ClientWidth<ViewWidth2) or (ClientHeight<ViewHeight2) then
        begin
          r := ViewWidth2/ClientWidth;
          r2 := ViewHeight2/ClientHeight;
          if r>r2 then
            r := r2;
          Draw2(Round(r*ClientWidth), Round(r*ClientHeight));
        end else
          Draw2(ViewWidth2, ViewHeight2);
      end else
        Draw2(ViewWidth2, ViewHeight2);
    end else
    begin
      if FAutoStretch then
      begin
        if (FDIB.Width>ClientWidth) or (FDIB.Height>ClientHeight) then
        begin
          r := ClientWidth/FDIB.Width;
          r2 := ClientHeight/FDIB.Height;
          if r>r2 then
            r := r2;
          Draw2(Round(r*FDIB.Width), Round(r*FDIB.Height));
        end else
          Draw2(FDIB.Width, FDIB.Height);
      end else
      if FStretch then
      begin
        if FKeepAspect then
        begin
          r := ClientWidth/FDIB.Width;
          r2 := ClientHeight/FDIB.Height;
          if r>r2 then
            r := r2;
          Draw2(Round(r*FDIB.Width), Round(r*FDIB.Height));
        end else
          Draw2(ClientWidth, ClientHeight);
      end else
        Draw2(FDIB.Width, FDIB.Height);
    end;
  end;
end;

procedure TCustomDXPaintBox.SetAutoStretch(Value: Boolean);
begin
  if FAutoStretch<>Value then
  begin
    FAutoStretch := Value;
    Invalidate;
  end;
end;

procedure TCustomDXPaintBox.SetCenter(Value: Boolean);
begin
  if FCenter<>Value then
  begin
    FCenter := Value;
    Invalidate;
  end;
end;

procedure TCustomDXPaintBox.SetDIB(Value: TDIB);
begin
  if FDIB<>Value then
  begin
    FDIB.Assign(Value);
    Invalidate;
  end;
end;

procedure TCustomDXPaintBox.SetKeepAspect(Value: Boolean);
begin
  if Value<>FKeepAspect then
  begin
    FKeepAspect := Value;
    Invalidate;
  end;
end;

procedure TCustomDXPaintBox.SetStretch(Value: Boolean);
begin
  if Value<>FStretch then
  begin
    FStretch := Value;
    Invalidate;
  end;
end;

procedure TCustomDXPaintBox.SetViewWidth(Value: Integer);
begin
  if Value<0 then Value := 0;
  if Value<>FViewWidth then
  begin
    FViewWidth := Value;
    Invalidate;
  end;
end;

procedure TCustomDXPaintBox.SetViewHeight(Value: Integer);
begin
  if Value<0 then Value := 0;
  if Value<>FViewHeight then
  begin
    FViewHeight := Value;
    Invalidate;
  end;
end;

initialization
  TPicture.RegisterClipBoardFormat(CF_DIB, TDIB);
  TPicture.RegisterFileFormat('dib', 'Device Independent Bitmap', TDIB);
finalization
  TPicture.UnRegisterGraphicClass(TDIB);

  FEmptyDIBImage.Free;
  FPaletteManager.Free;
end.
