unit DIB;

interface

{$INCLUDE DelphiXcfg.inc}
{$DEFINE USE_SCANLINE}

uses
  Windows, SysUtils, Classes, Graphics, Controls, Math;

type
  TColorLineStyle = (csSolid, csGradient, csRainbow);
  TColorLinePixelGeometry = (pgPoint, pgCircular, pgRectangular);

  TRGBQuads = array[0..255] of TRGBQuad;

  TPaletteEntries = array[0..255] of TPaletteEntry;

  PBGR = ^TBGR;
  TBGR = packed record
    B, G, R: Byte;
  end;

  {   Added this type for New SPecial Effect   }
  TFilter = array[0..2, 0..2] of SmallInt;
  TLines = array[0..0] of TBGR;
  PLines = ^TLines;
  TBytes = array[0..0] of Byte;
  PBytes = ^TBytes;
  TPBytes = array[0..0] of PBytes;
  PPBytes = ^TPBytes;
  {   End of type's   }

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

  TFilterTypeResample = (ftrBox, ftrTriangle, ftrHermite, ftrBell, ftrBSpline,
    ftrLanczos3, ftrMitchell);

  TDistortType = (dtFast, dtSlow);
  {DXFusion effect type}
  TFilterMode = (fmNormal, fmMix50, fmMix25, fmMix75);

  TLightSource = record
    X, Y: Integer;
    Size1, Size2: Integer;
    Color: TColor;
  end;

  TLightArray = array{$IFDEF DelphiX_Delphi3} [0..0]{$ENDIF} of TLightsource;

  TMatrixSetting = array[0..9] of Integer;
  {--}
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
    FLUTDist: array[0..255, 0..255] of Integer;
    LG_COUNT: Integer;
    LG_DETAIL: Integer;
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

    {   Added these 3 functions for New Specials Effects   }
    function Interval(iMin, iMax, iValue: Integer; iMark: boolean): Integer;
    function IntToByte(i: Integer): Byte;
    function TrimInt(i, Min, Max: Integer): Integer;
    {   End of 3 functions for New Special Effect   }
    procedure DoSmoothRotate(Src: TDIB; cx, cy: Integer; Angle: Extended);
    procedure Darkness(Amount: integer);
    function GetAlphaChannel: TDIB;
    procedure SetAlphaChannel(const Value: TDIB);
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
    function HasAlphaChannel: Boolean;
    function AssignAlphaChannel(DIB: TDIB): Boolean;
    procedure RetAlphaChannel(out DIB: TDIB);
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

    {   Added New Special Effect   }
    procedure Spray(Amount: integer);
    procedure Emboss;
    procedure AddMonoNoise(Amount: integer);
    procedure AddGradiantNoise(Amount: byte);
    function Twist(bmp: TDIB; Amount: byte): boolean;
    function FishEye(bmp: TDIB): boolean;
    function SmoothRotateWrap(Bmp: TDIB; cx, cy: Integer; Degree: Extended): boolean;
    procedure Lightness(Amount: integer);
    procedure Saturation(Amount: integer);
    procedure Contrast(Amount: integer);
    procedure AddRGB(ra, ga, ba: byte);
    function Filter(Dest: TDIB; Filter: TFilter): boolean;
    procedure Sharpen(Amount: Integer);
    function IntToColor(i: Integer): TBGR;
    function Rotate(Dst: TDIB; cx, cy: Integer; Angle: Double): boolean;
    procedure SplitBlur(Amount: Integer);
    procedure GaussianBlur(Bmp: TDIB; Amount: Integer);
    {   End of New Special Effect   }
    {
    New effect for TDIB
    with Some Effects like AntiAlias, Contrast,
    Lightness, Saturation, GaussianBlur, Mosaic,
    Twist, Splitlight, Trace, Emboss, etc.
    Works with 24bit color DIBs.

    This component is based on TProEffectImage component version 1.0 by
    Written By Babak Sateli (babak_sateli@yahoo.com, http://raveland.netfirms.com)

    and modified by (c) 2004 Jaro Benes
    for DelphiX use.

    Demo was modifies into DXForm with function like  original

    DISCLAIMER
    This component is provided AS-IS without any warranty of any kind, either express or
    implied. This component is freeware and can be used in any software product.
    }
    procedure DoInvert;
    procedure DoAddColorNoise(Amount: Integer);
    procedure DoAddMonoNoise(Amount: Integer);
    procedure DoAntiAlias;
    procedure DoContrast(Amount: Integer);
    procedure DoFishEye(Amount: Integer);
    procedure DoGrayScale;
    procedure DoLightness(Amount: Integer);
    procedure DoDarkness(Amount: Integer);
    procedure DoSaturation(Amount: Integer);
    procedure DoSplitBlur(Amount: Integer);
    procedure DoGaussianBlur(Amount: Integer);
    procedure DoMosaic(Size: Integer);
    procedure DoTwist(Amount: Integer);
    procedure DoSplitlight(Amount: integer);
    procedure DoTile(Amount: integer);
    procedure DoSpotLight(Amount: integer; Spot: TRect);
    procedure DoTrace(Amount: integer);
    procedure DoEmboss;
    procedure DoSolorize(Amount: integer);
    procedure DoPosterize(Amount: integer);
    procedure DoBrightness(Amount: integer);
    procedure DoResample(AmountX, AmountY: integer; TypeResample: TFilterTypeResample);
    procedure DoColorize(ForeColor, BackColor: TColor);

    { Standalone DXFusion }
    {--- c o n F u s i o n ---}
    {By Joakim Back, www.back.mine.nu}
    {Huge thanks to Ilkka Tuomioja for helping out with the project.}

    procedure CreateDIBFromBitmap(const Bitmap: TBitmap);
    {Drawing Methods.}
    procedure DrawOn(SrcCanvas: TCanvas; Dest: TRect; DestCanvas: TCanvas;
      Xsrc, Ysrc: Integer);
    procedure DrawTo(SrcDIB: TDIB; X, Y, Width, Height, SourceX,
      SourceY: Integer);
    procedure DrawTransparent(SrcDIB: TDIB; const X, Y, Width, Height,
      SourceX, SourceY: Integer; const Color: TColor);
    procedure DrawShadow(SrcDIB: TDIB; X, Y, Width, Height, Frame: Integer;
      FilterMode: TFilterMode);
    procedure DrawDarken(SrcDIB: TDIB; X, Y, Width, Height,
      Frame: Integer);
    procedure DrawAdditive(SrcDIB: TDIB; X, Y, Width, Height, Alpha,
      Frame: Integer);
    procedure DrawQuickAlpha(SrcDIB: TDIB; const X, Y, Width, Height,
      SourceX, SourceY: Integer; const Color: TColor;
      FilterMode: TFilterMode);
    procedure DrawTranslucent(SrcDIB: TDIB; const X, Y, Width, Height,
      SourceX, SourceY: Integer; const Color: TColor);
    procedure DrawMorphed(SrcDIB: TDIB; const X, Y, Width, Height, SourceX,
      SourceY: Integer; const Color: TColor);
    procedure DrawAlpha(SrcDIB: TDIB; const X, Y, Width, Height, SourceX,
      SourceY, Alpha: Integer; const Color: TColor);
    procedure DrawAlphaMask(SrcDIB, MaskDIB: TDIB; const X, Y, Width,
      Height, SourceX, SourceY: Integer);
    procedure DrawAntialias(SrcDIB: TDIB);
    procedure Draw3x3Matrix(SrcDIB: TDIB; Setting: TMatrixSetting);
    procedure DrawMono(SrcDIB: TDIB; const X, Y, Width, Height, SourceX,
      SourceY: integer; const TransColor, ForeColor, BackColor: TColor);
    {One-color Filters.}
    procedure FilterLine(X1, Y1, X2, Y2: Integer; Color: TColor;
      FilterMode: TFilterMode);
    procedure FilterRect(X, Y, Width, Height: Integer; Color: TColor;
      FilterMode: TFilterMode);
    { Lightsource. }
    procedure InitLight(Count, Detail: Integer);
    procedure DrawLights(FLight: TLightArray; AmbientLight: TColor);
    //
    // effect for special purpose
    //
    procedure FadeOut(DIB2: TDIB; Step: Byte);
    procedure DoZoom(DIB2: TDIB; ZoomRatio: Real);
    procedure DoBlur(DIB2: TDIB);
    procedure FadeIn(DIB2: TDIB; Step: Byte);
    procedure FillDIB8(Color: Byte);
    procedure DoRotate(DIB1: TDIB; xc, yc, a: Integer);
    procedure Distort(DIB1: TDIB; dt: TDistortType; xc, yc, b: Integer; factor: Real);
    function Ink(DIB: TDIB; const SprayInit: Boolean; const AmountSpray: Integer): Boolean;
    // lines
    procedure AntialiasedLine(x1, y1, x2, y2: integer; color: TColor);
    function GetColorBetween(StartColor, EndColor: TColor; Pointvalue,
      FromPoint, ToPoint: Extended): TColor;
    procedure ColoredLine(const iStart, iEnd: TPoint; iColorStyle: TColorLineStyle;
      iGradientFrom, iGradientTo: TColor; iPixelGeometry: TColorLinePixelGeometry;
      iRadius: WORD);
    // standard property
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
    property AlphaChannel: TDIB read GetAlphaChannel write SetAlphaChannel;
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
{$IFDEF DelphiX_Spt4}property Anchors; {$ENDIF}
    property AutoStretch;
    property Center;
{$IFDEF DelphiX_Spt4}property Constraints; {$ENDIF}
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
{$IFDEF DelphiX_Spt9}property OnMouseWheel; {$ENDIF}
{$IFDEF DelphiX_Spt9}property OnResize; {$ENDIF}
{$IFDEF DelphiX_Spt9}property OnCanResize; {$ENDIF}
{$IFDEF DelphiX_Spt9}property OnContextPopup; {$ENDIF}
    property OnStartDrag;
  end;

const
  DefaultFilterRadius: array[TFilterTypeResample] of Single = (0.5, 1, 1, 1.5, 2, 3, 2);

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

function PosValue(Value: Integer): Integer;

type
  TOC = 0..511;
function DSin(const C: TOC): Single; {$IFDEF VER9UP}inline; {$ENDIF}
function DCos(const C: TOC): Single; {$IFDEF VER9UP}inline; {$ENDIF}

{   Added Constants for TFilter Type   }
const
  EdgeFilter: TFilter = ((-1, -1, -1), (-1, 8, -1), (-1, -1, -1));
  StrongOutlineFilter: TFilter = ((-100, 0, 0), (0, 0, 0), (0, 0, 100));
  Enhance3DFilter: TFilter = ((-100, 5, 5), (5, 5, 5), (5, 5, 100));
  LinearFilter: TFilter = ((-40, -40, -40), (-40, 255, -40), (-40, -40, -40));
  GranularFilter: TFilter = ((-20, 5, 20), (5, -10, 5), (100, 5, -100));
  SharpFilter: TFilter = ((-2, -2, -2), (-2, 20, -2), (-2, -2, -2));
{   End of constants   }

{   Added Constants for DXFusion Type   }
const
  { 3x3 Matrix Presets. }
  msEmboss: TMatrixSetting = (-1, -1, 0, -1, 6, 1, 0, 1, 1, 6);
  msHardEmboss: TMatrixSetting = (-4, -2, -1, -2, 10, 2, -1, 2, 4, 8);
  msBlur: TMatrixSetting = (1, 2, 1, 2, 4, 2, 1, 2, 1, 16);
  msSharpen: TMatrixSetting = (-1, -1, -1, -1, 15, -1, -1, -1, -1, 7);
  msEdgeDetect: TMatrixSetting = (-1, -1, -1, -1, 8, -1, -1, -1, -1, 1);

implementation

uses DXConsts;

{$IFDEF DelphiX_Delphi3}

function Max(B1, B2: Integer): Integer;
begin
  if B1 >= B2 then Result := B1 else Result := B2;
end;

function Min(B1, B2: Integer): Integer;
begin
  if B1 <= B2 then Result := B1 else Result := B2;
end;
{$ENDIF}

function DSin(const C: TOC): Single; {$IFDEF VER9UP}inline; {$ENDIF}
begin
  Result := sin(((c * 360) / 511) * Pi / 180);
end;

function DCos(const C: TOC): Single; {$IFDEF VER9UP}inline; {$ENDIF}
begin
  Result := cos(((c * 360) / 511) * Pi / 180);
end;

function MakeDIBPixelFormat(RBitCount, GBitCount, BBitCount: Integer): TDIBPixelFormat;
begin
  Result.RBitMask := ((1 shl RBitCount) - 1) shl (GBitCount + BBitCount);
  Result.GBitMask := ((1 shl GBitCount) - 1) shl (BBitCount);
  Result.BBitMask := (1 shl BBitCount) - 1;
  Result.RBitCount := RBitCount;
  Result.GBitCount := GBitCount;
  Result.BBitCount := BBitCount;
  Result.RBitCount2 := 8 - RBitCount;
  Result.GBitCount2 := 8 - GBitCount;
  Result.BBitCount2 := 8 - BBitCount;
  Result.RShift := (GBitCount + BBitCount) - (8 - RBitCount);
  Result.GShift := BBitCount - (8 - GBitCount);
  Result.BShift := 8 - BBitCount;
end;

function MakeDIBPixelFormatMask(RBitMask, GBitMask, BBitMask: Integer): TDIBPixelFormat;

  function GetBitCount(b: Integer): Integer;
  var
    i: Integer;
  begin
    i := 0;
    while (i < 31) and (((1 shl i) and b) = 0) do Inc(i);

    Result := 0;
    while ((1 shl i) and b) <> 0 do
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
    Result := Result or (Result shr RBitCount2);
  end;
end;

function pfGetGValue(const PixelFormat: TDIBPixelFormat; Color: DWORD): Byte;
begin
  with PixelFormat do
  begin
    Result := (Color and GBitMask) shr GShift;
    Result := Result or (Result shr GBitCount2);
  end;
end;

function pfGetBValue(const PixelFormat: TDIBPixelFormat; Color: DWORD): Byte;
begin
  with PixelFormat do
  begin
    Result := (Color and BBitMask) shl BShift;
    Result := Result or (Result shr BBitCount2);
  end;
end;

function GreyscaleColorTable: TRGBQuads;
var
  i: Integer;
begin
  for i := 0 to 255 do
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
  for i := 0 to 255 do
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
  for i := 0 to 255 do
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
  if RefCount <= 0 then Free;
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
  for i := 0 to ColorTableCount - 1 do
    with ColorTable[i] do
    begin
      Inc(ID, rgbRed);
      Inc(ID, rgbGreen);
      Inc(ID, rgbBlue);
    end;

  {  Does the same palette already exist?  }
  for i := 0 to FList.Count - 1 do
  begin
    Item := TPaletteItem(FList.Items[i]);
    if (Item.ID = ID) and (Item.ColorTableCount = ColorTableCount) and
      CompareMem(@Item.ColorTable, @ColorTable, ColorTableCount * SizeOf(TRGBQuad)) then
    begin
      Item.AddRef; Result := Item.Palette;
      Exit;
    end;
  end;

  {  New palette making  }
  Item := TPaletteItem.Create(FList);
  Item.ID := ID;
  Move(ColorTable, Item.ColorTable, ColorTableCount * SizeOf(TRGBQuad));
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
  if Palette = 0 then Exit;

  for i := 0 to FList.Count - 1 do
  begin
    Item := TPaletteItem(FList.Items[i]);
    if (Item.Palette = Palette) then
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
  if FPaletteManager = nil then
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
    1: if not ((PixelFormat.RBitMask = $FF0000) and (PixelFormat.GBitMask = $00FF00) and (PixelFormat.BBitMask = $0000FF)) then
        raise EInvalidGraphicOperation.Create(SInvalidDIBPixelFormat);
    4: if not ((PixelFormat.RBitMask = $FF0000) and (PixelFormat.GBitMask = $00FF00) and (PixelFormat.BBitMask = $0000FF)) then
        raise EInvalidGraphicOperation.Create(SInvalidDIBPixelFormat);
    8: if not ((PixelFormat.RBitMask = $FF0000) and (PixelFormat.GBitMask = $00FF00) and (PixelFormat.BBitMask = $0000FF)) then
        raise EInvalidGraphicOperation.Create(SInvalidDIBPixelFormat);
    16: begin
        if not (((PixelFormat.RBitMask = $7C00) and (PixelFormat.GBitMask = $03E0) and (PixelFormat.BBitMask = $001F)) or
          ((PixelFormat.RBitMask = $F800) and (PixelFormat.GBitMask = $07E0) and (PixelFormat.BBitMask = $001F))) then
          raise EInvalidGraphicOperation.Create(SInvalidDIBPixelFormat);
      end;
    24: begin
        if not ((PixelFormat.RBitMask = $FF0000) and (PixelFormat.GBitMask = $00FF00) and (PixelFormat.BBitMask = $0000FF)) then
          raise EInvalidGraphicOperation.Create(SInvalidDIBPixelFormat);
      end;
    32: begin
        if not ((PixelFormat.RBitMask = $FF0000) and (PixelFormat.GBitMask = $00FF00) and (PixelFormat.BBitMask = $0000FF)) then
          raise EInvalidGraphicOperation.Create(SInvalidDIBPixelFormat);
      end;
  else
    raise EInvalidGraphicOperation.CreateFmt(SInvalidDIBBitCount, [ABitCount]);
  end;

  FBitCount := ABitCount;
  FHeight := AHeight;
  FWidth := AWidth;
  FWidthBytes := (((AWidth * ABitCount) + 31) shr 5) * 4;
  FNextLine := -FWidthBytes;
  FSize := FWidthBytes * FHeight;
  UsePixelFormat := ABitCount in [16, 32];

  FPixelFormat := PixelFormat;

  FPaletteCount := 0;
  if FBitCount <= 8 then
    FPaletteCount := 1 shl FBitCount;

  FBitmapInfoSize := SizeOf(TBitmapInfoHeader);
  if UsePixelFormat then
    Inc(FBitmapInfoSize, SizeOf(TLocalDIBPixelFormat));
  Inc(FBitmapInfoSize, SizeOf(TRGBQuad) * FPaletteCount);

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
      if (FBitCount = 4) and (Compressed) then
        biCompression := BI_RLE4
      else if (FBitCount = 8) and (Compressed) then
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
    with PLocalDIBPixelFormat(Integer(FBitmapInfo) + InfoOfs)^ do
    begin
      RBitMask := PixelFormat.RBitMask;
      GBitMask := PixelFormat.GBitMask;
      BBitMask := PixelFormat.BBitMask;
    end;

    Inc(InfoOfs, SizeOf(TLocalDIBPixelFormat));
  end;

  FColorTablePos := InfoOfs;

  FColorTable := ColorTable;
  Move(FColorTable, Pointer(Integer(FBitmapInfo) + FColorTablePos)^, SizeOf(TRGBQuad) * FPaletteCount);

  FCompressed := FBitmapInfo^.bmiHeader.biCompression in [BI_RLE4, BI_RLE8];
  FMemoryImage := MemoryImage or FCompressed;

  {  DIB making.  }
  if not Compressed then
  begin
    if MemoryImage then
    begin
      FPBits := Pointer(GlobalAlloc(GMEM_FIXED, FSize));
      if FPBits = nil then
        OutOfMemoryError;
    end else
    begin
      FDC := CreateCompatibleDC(0);

      FHandle := CreateDIBSection(FDC, FBitmapInfo^, DIB_RGB_COLORS, FPBits, 0, 0);
      if FHandle = 0 then
        raise EOutOfResources.CreateFmt(SCannotMade, ['DIB']);

      FOldHandle := SelectObject(FDC, FHandle);
    end;
  end;

  FTopPBits := Pointer(Integer(FPBits) + (FHeight - 1) * FWidthBytes);
end;

procedure TDIBSharedImage.Duplicate(Source: TDIBSharedImage; MemoryImage: Boolean);
begin
  if Source.FSize = 0 then
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
      if Size mod 4096 = 0 then
        ReAllocMem(FPBits, Size + 4095);
      Result := Pointer(Integer(FPBits) + Size);
      Inc(Size);
    end;

  var
    B1, B2, C: Byte;
    PB1, PB2: Integer;
    Src: PByte;
    X, Y: Integer;

    function GetPixel(x: Integer): Integer;
    begin
      if X and 1 = 0 then
        Result := PArrayByte(Src)[X shr 1] shr 4
      else
        Result := PArrayByte(Src)[X shr 1] and $0F;
    end;

  begin
    Size := 0;

    for y := 0 to Source.FHeight - 1 do
    begin
      x := 0;
      Src := Pointer(Integer(Source.FPBits) + y * FWidthBytes);
      while x < Source.FWidth do
      begin
        if (Source.FWidth - x > 3) and (GetPixel(x) = GetPixel(x + 2)) then
        begin
          {  Encoding mode  }
          B1 := 2;
          B2 := (GetPixel(x) shl 4) or GetPixel(x + 1);

          Inc(x, 2);

          C := B2;

          while (x < Source.FWidth) and (C and $F = GetPixel(x)) and (B1 < 255) do
          begin
            Inc(B1);
            Inc(x);
            C := (C shr 4) or (C shl 4);
          end;

          AllocByte^ := B1;
          AllocByte^ := B2;
        end else
          if (Source.FWidth - x > 5) and ((GetPixel(x) <> GetPixel(x + 2)) or (GetPixel(x + 1) <> GetPixel(x + 3))) and
            ((GetPixel(x + 2) = GetPixel(x + 4)) and (GetPixel(x + 3) = GetPixel(x + 5))) then
          begin
          {  Encoding mode }
            AllocByte^ := 2;
            AllocByte^ := (GetPixel(x) shl 4) or GetPixel(x + 1);
            Inc(x, 2);
          end else
          begin
            if (Source.FWidth - x < 4) then
            begin
            {  Encoding mode }
              while Source.FWidth - x >= 2 do
              begin
                AllocByte^ := 2;
                AllocByte^ := (GetPixel(x) shl 4) or GetPixel(x + 1);
                Inc(x, 2);
              end;

              if Source.FWidth - x = 1 then
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

              AllocByte^ := (GetPixel(x) shl 4) or GetPixel(x + 1);
              AllocByte^ := (GetPixel(x + 2) shl 4) or GetPixel(x + 3);

              Inc(x, 4);

              while (x + 1 < Source.FWidth) and (B2 < 254) do
              begin
                if (Source.FWidth - x > 3) and (GetPixel(x) = GetPixel(x + 2)) and (GetPixel(x + 1) = GetPixel(x + 3)) then
                  Break;

                AllocByte^ := (GetPixel(x) shl 4) or GetPixel(x + 1);
                Inc(B2, 2);
                Inc(x, 2);
              end;

              PByte(Integer(FPBits) + PB1)^ := B1;
              PByte(Integer(FPBits) + PB2)^ := B2;
            end;
          end;

        if Size and 1 = 1 then AllocByte;
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
      if Size mod 4096 = 0 then
        ReAllocMem(FPBits, Size + 4095);
      Result := Pointer(Integer(FPBits) + Size);
      Inc(Size);
    end;

  var
    B1, B2: Byte;
    PB1, PB2: Integer;
    Src: PByte;
    X, Y: Integer;
  begin
    Size := 0;

    for y := 0 to Source.FHeight - 1 do
    begin
      x := 0;
      Src := Pointer(Integer(Source.FPBits) + y * FWidthBytes);
      while x < Source.FWidth do
      begin
        if (Source.FWidth - x > 2) and (Src^ = PByte(Integer(Src) + 1)^) then
        begin
          {  Encoding mode  }
          B1 := 2;
          B2 := Src^;

          Inc(x, 2);
          Inc(Src, 2);

          while (x < Source.FWidth) and (Src^ = B2) and (B1 < 255) do
          begin
            Inc(B1);
            Inc(x);
            Inc(Src);
          end;

          AllocByte^ := B1;
          AllocByte^ := B2;
        end else
          if (Source.FWidth - x > 2) and (Src^ <> PByte(Integer(Src) + 1)^) and (PByte(Integer(Src) + 1)^ = PByte(Integer(Src) + 2)^) then
          begin
          {  Encoding mode }
            AllocByte^ := 1;
            AllocByte^ := Src^; Inc(Src);
            Inc(x);
          end else
          begin
            if (Source.FWidth - x < 4) then
            begin
            {  Encoding mode }
              if Source.FWidth - x = 2 then
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

              while (x < Source.FWidth) and (B2 < 255) do
              begin
                if (Source.FWidth - x > 3) and (Src^ = PByte(Integer(Src) + 1)^) and (Src^ = PByte(Integer(Src) + 2)^) and (Src^ = PByte(Integer(Src) + 3)^) then
                  Break;

                AllocByte^ := Src^; Inc(Src);
                Inc(B2);
                Inc(x);
              end;

              PByte(Integer(FPBits) + PB1)^ := B1;
              PByte(Integer(FPBits) + PB2)^ := B2;
            end;
          end;

        if Size and 1 = 1 then AllocByte;
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

      if B1 = 0 then
      begin
        case B2 of
          0: begin {  End of line  }
              X := 0;
              Inc(Y);
            end;
          1: Break; {  End of bitmap  }
          2: begin {  Difference of coordinates  }
              Inc(X, B1);
              Inc(Y, B2); Inc(Src, 2);
            end;
        else
          {  Absolute mode  }
          Dest := Pointer(Longint(FPBits) + Y * FWidthBytes);

          C := 0;
          for i := 0 to B2 - 1 do
          begin
            if i and 1 = 0 then
            begin
              C := Src^; Inc(Src);
            end else
            begin
              C := C shl 4;
            end;

            P := Pointer(Integer(Dest) + X shr 1);
            if X and 1 = 0 then
              P^ := (P^ and $0F) or (C and $F0)
            else
              P^ := (P^ and $F0) or ((C and $F0) shr 4);

            Inc(X);
          end;
        end;
      end else
      begin
        {  Encoding mode  }
        Dest := Pointer(Longint(FPBits) + Y * FWidthBytes);

        for i := 0 to B1 - 1 do
        begin
          P := Pointer(Integer(Dest) + X shr 1);
          if X and 1 = 0 then
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

      if B1 = 0 then
      begin
        case B2 of
          0: begin {  End of line  }
              X := 0; Inc(Y);
              Dest := Pointer(Longint(FPBits) + Y * FWidthBytes + X);
            end;
          1: Break; {  End of bitmap  }
          2: begin {  Difference of coordinates  }
              Inc(X, B1); Inc(Y, B2); Inc(Src, 2);
              Dest := Pointer(Longint(FPBits) + Y * FWidthBytes + X);
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
    //GetMem(FPBits, FSize);
    FPBits := GlobalAllocPtr(GMEM_FIXED, FSize);
    FBitmapInfo.bmiHeader.biSizeImage := FSize;
    Stream.ReadBuffer(FPBits^, FSize);
  end;

  procedure LoadRLE8;
  begin
    FSize := BI.biSizeImage;
    //GetMem(FPBits, FSize);
    FPBits := GlobalAllocPtr(GMEM_FIXED, FSize);
    FBitmapInfo.bmiHeader.biSizeImage := FSize;
    Stream.ReadBuffer(FPBits^, FSize);
  end;

  procedure LoadRGB;
  var
    y: Integer;
  begin
    if BI.biHeight < 0 then
    begin
      for y := 0 to Abs(BI.biHeight) - 1 do
        Stream.ReadBuffer(Pointer(Integer(FTopPBits) + y * FNextLine)^, FWidthBytes);
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

  if i = 0 then
  begin
    Create;
    Exit;
  end;
  if i <> 4 then
    raise EInvalidGraphic.Create(SInvalidDIB);

  {  Kind check of DIB  }
  OS2 := False;

  case BI.biSize of
    SizeOf(TBitmapCoreHeader):
      begin
        {  OS/2 type  }
        Stream.ReadBuffer(Pointer(Integer(@BC) + 4)^, SizeOf(TBitmapCoreHeader) - 4);

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
        Stream.ReadBuffer(Pointer(Integer(@BI) + 4)^, SizeOf(TBitmapInfoHeader) - 4);
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
    if BI.biBitCount = 16 then
      APixelFormat := MakeDIBPixelFormat(5, 5, 5)
    else if BI.biBitCount = 32 then
      APixelFormat := MakeDIBPixelFormat(8, 8, 8)
    else
      APixelFormat := MakeDIBPixelFormat(8, 8, 8);
  end;

    {  Palette reading  }
  PalCount := BI.biClrUsed;
  if (PalCount = 0) and (BI.biBitCount <= 8) then
    PalCount := 1 shl BI.biBitCount;
  if PalCount > 256 then PalCount := 256;

  FillChar(AColorTable, SizeOf(AColorTable), 0);

  if OS2 then
  begin
    {  OS/2 type  }
    Stream.ReadBuffer(BCRGB, SizeOf(TRGBTriple) * PalCount);
    for i := 0 to PalCount - 1 do
    begin
      with BCRGB[i] do
        AColorTable[i] := RGBQuad(rgbtRed, rgbtGreen, rgbtBlue);
    end;
  end else
  begin
    {  Windows type  }
    Stream.ReadBuffer(AColorTable, SizeOf(TRGBQuad) * PalCount);
  end;

  {  DIB compilation  }
  NewImage(BI.biWidth, Abs(BI.biHeight), BI.biBitCount, APixelFormat, AColorTable,
    MemoryImage, BI.biCompression in [BI_RLE4, BI_RLE8]);

  {  Pixel data reading  }
  case BI.biCompression of
    BI_RGB: LoadRGB;
    BI_RLE4: LoadRLE4;
    BI_RLE8: LoadRLE8;
    BI_BITFIELDS: LoadRGB;
  else
    raise EInvalidGraphic.Create(SInvalidDIB);
  end;
end;

destructor TDIBSharedImage.Destroy;
begin
  if FHandle <> 0 then
  begin
    if FOldHandle <> 0 then SelectObject(FDC, FOldHandle);
    DeleteObject(FHandle);
  end else
//    GlobalFree(THandle(FPBits));
  begin
    if FPBits <> nil then
      GlobalFreePtr(FPBits);
  end;

  PaletteManager.DeletePalette(FPalette);
  if FDC <> 0 then DeleteDC(FDC);

  FreeMem(FBitmapInfo);
  inherited Destroy;
end;

procedure TDIBSharedImage.FreeHandle;
begin
end;

function TDIBSharedImage.GetPalette: THandle;
begin
  if FPaletteCount > 0 then
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

  if (FSize > 0) and (FPaletteCount > 0) then
  begin
    SetDIBColorTable(FDC, 0, 256, FColorTable);
    Move(FColorTable, Pointer(Integer(FBitmapInfo) + FColorTablePos)^, SizeOf(TRGBQuad) * FPaletteCount);
  end;
end;

{ TDIB }

var
  FEmptyDIBImage: TDIBSharedImage;

function EmptyDIBImage: TDIBSharedImage;
begin
  if FEmptyDIBImage = nil then
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
          if DIBSectionRec^.dsBm.bmBitsPixel >= 24 then
          begin
            PixelFormat := MakeDIBPixelFormat(8, 8, 8);
          end else
            if DIBSectionRec^.dsBm.bmBitsPixel > 8 then
            begin
              PixelFormat := MakeDIBPixelFormatMask(DIBSectionRec^.dsBitfields[0], //correct I.Ceneff, thanks
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
  if Source = nil then
  begin
    Clear;
  end else if Source is TDIB then
  begin
    if Source <> Self then
      SetImage(TDIB(Source).FImage);
  end else if Source is TGraphic then
  begin
    AssignGraphic(TGraphic(Source));
  end else if Source is TPicture then
  begin
    if TPicture(Source).Graphic <> nil then
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
  if Size > 0 then
  begin
    if PaletteCount > 0 then
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
              0, 0, Width, Height, FImage.FPBits, FImage.FBitmapInfo^, DIB_RGB_COLORS, ACanvas.CopyMode);
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
  if (FImage.RefCount > 1) or (FImage.FCompressed) or ((not MemoryImage) and (FImage.FMemoryImage)) then
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

type
  PRGBA = ^TRGBA;
  TRGBA = array[0..0] of Windows.TRGBQuad;

function TDIB.HasAlphaChannel: Boolean;
  {give that DIB contain the alphachannel}
var
  p: PRGBA;
  X, Y: Integer;
begin
  Result := True;
  if BitCount = 32 then
    for Y := 0 to Height - 1 do begin
      p := ScanLine[Y];
      for X := 0 to Width - 1 do begin
        if p[X].rgbReserved <> $0 then Exit;
      end
    end;
  Result := False;
end;

function TDIB.AssignAlphaChannel(DIB: TDIB): Boolean;
  {copy alphachannel from other DIB or add from DIB8}
var
  p0, p1: PRGBA;
  pB: PArrayByte;
  X, Y: Integer;
  tmpDIB: TDIB;
begin
  Result := False;
  if GetEmpty then Exit;
  {Alphachannel can be copy into 32bit DIB only!}
  if BitCount <> 32 then begin
    tmpDIB := TDIB.Create;
    try
      tmpDIB.Assign(Self);
      Clear;
      SetSize(Width, Height, 32);
      Canvas.Draw(0, 0, tmpDIB);
    finally
      tmpDIB.Free;
    end;
  end;
  {Must be the same size!}
  if not ((Width = DIB.Width) and (Height = DIB.Height)) then Exit;
  case DIB.BitCount of
    32: begin
        for Y := 0 to Height - 1 do begin
          p0 := ScanLine[Y];
          p1 := DIB.ScanLine[Y];
          for X := 0 to Width - 1 do begin
            p0[X].rgbReserved := p1[X].rgbReserved;
          end
        end;
      end;
    8: begin
        for Y := 0 to Height - 1 do begin
          p0 := ScanLine[Y];
          pB := DIB.ScanLine[Y];
          for X := 0 to Width - 1 do begin
            p0[X].rgbReserved := pB[X];
          end
        end;
      end;
  else
    Exit;
  end;
  Result := True;
end;

procedure TDIB.RetAlphaChannel(out DIB: TDIB);
  {Store alphachannel information into DIB8}
var
  p0: PRGBA;
  pB: PArrayByte;
  X, Y: Integer;
begin
  DIB := nil;
  if not HasAlphaChannel then exit;
  DIB := TDIB.Create;
  DIB.SetSize(Width, Height, 8);
  for Y := 0 to Height - 1 do begin
    p0 := ScanLine[Y];
    pB := DIB.ScanLine[Y];
    for X := 0 to Width - 1 do begin
      pB[X] := p0[X].rgbReserved;
    end
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
  if (FCanvas = nil) or (FCanvas.Handle = 0) then
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
  Result := Size = 0;
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
  if (Y < 0) or (Y >= FHeight) then
    raise EInvalidGraphicOperation.CreateFmt(SScanline, [Y]);

  if not FImage.FMemoryImage then
    GDIFlush;
  Result := Pointer(Integer(FTopPBits) + Y * FNextLine);
end;

function TDIB.GetScanLineReadOnly(Y: Integer): Pointer;
begin
  if (Y < 0) or (Y >= FHeight) then
    raise EInvalidGraphicOperation.CreateFmt(SScanline, [Y]);

  if not FImage.FMemoryImage then
    GDIFlush;
  Result := Pointer(Integer(FTopPBits) + Y * FNextLine);
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
  if (X >= 0) and (X < FWidth) and (Y >= 0) and (Y < FHeight) then
  begin
    case FBitCount of
      1: Result := (PArrayByte(Integer(FTopPBits) + Y * FNextLine)[X shr 3] and Mask1[X and 7]) shr Shift1[X and 7];
      4: Result := ((PArrayByte(Integer(FTopPBits) + Y * FNextLine)[X shr 1] and Mask4[X and 1]) shr Shift4[X and 1]);
      8: Result := PArrayByte(Integer(FTopPBits) + Y * FNextLine)[X];
      16: Result := PArrayWord(Integer(FTopPBits) + Y * FNextLine)[X];
      24: with PArrayBGR(Integer(FTopPBits) + Y * FNextLine)[X] do
          Result := R or (G shl 8) or (B shl 16);
      32: Result := PArrayDWord(Integer(FTopPBits) + Y * FNextLine)[X];
    end;
  end;
end;

procedure TDIB.SetPixel(X, Y: Integer; Value: DWORD);
var
  P: PByte;
begin
  Changing(True);

  if (X >= 0) and (X < FWidth) and (Y >= 0) and (Y < FHeight) then
  begin
    case FBitCount of
      1: begin
          P := @PArrayByte(Integer(FTopPBits) + Y * FNextLine)[X shr 3];
          P^ := (P^ and Mask1n[X and 7]) or ((Value and 1) shl Shift1[X and 7]);
        end;
      4: begin
          P := (@PArrayByte(Integer(FTopPBits) + Y * FNextLine)[X shr 3]);
          P^ := ((P^ and Mask4n[X and 1]) or ((Value and 15) shl Shift4[X and 1]));
        end;
      8: PArrayByte(Integer(FTopPBits) + Y * FNextLine)[X] := Value;
      16: PArrayWord(Integer(FTopPBits) + Y * FNextLine)[X] := Value;
      24: with PArrayBGR(Integer(FTopPBits) + Y * FNextLine)[X] do
        begin
          B := Byte(Value shr 16);
          G := Byte(Value shr 8);
          R := Byte(Value);
        end;
      32: PArrayDWord(Integer(FTopPBits) + Y * FNextLine)[X] := Value;
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
  BitmapFileType = Ord('B') + Ord('M') * $100;

procedure TDIB.LoadFromStream(Stream: TStream);
var
  BF: TBitmapFileHeader;
  i: Integer;
begin
  {  File header reading  }
  i := Stream.Read(BF, SizeOf(TBitmapFileHeader));
  if i = 0 then Exit;
  if i <> SizeOf(TBitmapFileHeader) then
    raise EInvalidGraphic.Create(SInvalidDIB);

  {  Is the head 'BM'?  }
  if BF.bfType <> BitmapFileType then
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
    if AData = 0 then OutOfMemoryError;

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
    bfType := BitmapFileType;
    bfOffBits := SizeOf(TBitmapFileHeader) + BitmapInfoSize;
    bfSize := bfOffBits + FImage.FBitmapInfo^.bmiHeader.biSizeImage;
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
  if Value <= 0 then
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
  if Value <= 0 then
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
  if Value <= 0 then
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
  if FImage <> Value then
  begin
    if FCanvas <> nil then
      FCanvas.Handle := 0;

    FImage.Release;
    FImage := Value;
    FImage.Reference;

    if FCanvas <> nil then
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
  if (AWidth = Width) and (AHeight = Height) and (ABitCount = BitCount) and
    (NowPixelFormat.RBitMask = PixelFormat.RBitMask) and
    (NowPixelFormat.GBitMask = PixelFormat.GBitMask) and
    (NowPixelFormat.BBitMask = PixelFormat.BBitMask) then Exit;

  if (AWidth <= 0) or (AHeight <= 0) then
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
    for i := 0 to 255 do
      with ColorTable[i] do
      begin
        rgbRed := ((i shr (G + B - 1)) and (1 shl R - 1)) * 255 div (1 shl R - 1);
        rgbGreen := ((i shr (B - 1)) and (1 shl G - 1)) * 255 div (1 shl G - 1);
        rgbBlue := ((i shr 0) and (1 shl B - 1)) * 255 div (1 shl B - 1);
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

    for y := 0 to Height - 1 do
    begin
      SrcP := Temp.ScanLine[y];
      DestP := ScanLine[y];

      for x := 0 to Width - 1 do
      begin
        case Temp.BitCount of
          1: begin
              i := (PArrayByte(SrcP)[X shr 3] and Mask1[X and 7]) shr Shift1[X and 7];
            end;
          4: begin
              i := (PArrayByte(SrcP)[X and 1] and Mask4[X and 1]) shr Shift4[X and 1];
            end;
          8: begin
              i := PByte(SrcP)^;
              Inc(PByte(SrcP));
            end;
        end;

        case BitCount of
          1: begin
              P := @PArrayByte(DestP)[X shr 3];
              P^ := (P^ and Mask1n[X and 7]) or (i shl Shift1[X shr 3]);
            end;
          4: begin
              P := @PArrayByte(DestP)[X shr 1];
              P^ := (P^ and Mask4n[X and 1]) or (i shl Shift4[X and 1]);
            end;
          8: begin
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

    for y := 0 to Height - 1 do
    begin
      SrcP := Temp.ScanLine[y];
      DestP := ScanLine[y];

      for x := 0 to Width - 1 do
      begin
        case Temp.BitCount of
          1: begin
              with Temp.ColorTable[(PArrayByte(SrcP)[X shr 3] and Mask1[X and 7]) shr Shift1[X and 7]] do
              begin
                cR := rgbRed;
                cG := rgbGreen;
                cB := rgbBlue;
              end;
            end;
          4: begin
              with Temp.ColorTable[(PArrayByte(SrcP)[X shr 1] and Mask4[X and 1]) shr Shift4[X and 1]] do
              begin
                cR := rgbRed;
                cG := rgbGreen;
                cB := rgbBlue;
              end;
            end;
          8: begin
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
  if Size = 0 then exit;

  Temp := TDIB.Create;
  try
    Temp.Assign(Self);
    SetSize(Temp.Width, Temp.Height, ABitCount);

    if FImage = Temp.FImage then Exit;

    if (Temp.BitCount <= 8) and (BitCount <= 8) then
    begin
      {  The image is converted from the palette color image into the palette color image.  }
      if Temp.BitCount <= BitCount then
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
      if (Temp.BitCount <= 8) and (BitCount > 8) then
      begin
      {  The image is converted from the palette color image into the rgb color image.  }
        PaletteToRGB_or_RGBToRGB;
      end else
        if (Temp.BitCount > 8) and (BitCount <= 8) then
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
          if (Temp.BitCount > 8) and (BitCount > 8) then
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
  Redraw := (GetTickCount - FProgressOldTime > 200) and (FProgressY - FProgressOldY > 32) and
    (((Height div 3 > Integer(FProgressY)) and (FProgressOldY = 0)) or (FProgressOldY <> 0));

  Percent := PercentY * 100 div Height;

  if (Percent <> FProgressOld) or (Redraw) then
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
        for y := 0 to Height shr 1 - 1 do
        begin
          P1 := ScanLine[y];
          P2 := ScanLine[Height - y - 1];

          Move(P1^, TempBuf^, WidthBytes);
          Move(P2^, P1^, WidthBytes);
          Move(TempBuf^, P2^, WidthBytes);

          UpdateProgress(y * 2);
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
      for y := 0 to Height - 1 do
      begin
        P1 := ScanLine[y];

        case BitCount of
          1: begin
              for x := 0 to Width2 - 1 do
              begin
                c := Pixels[x, y];
                Pixels[x, y] := Pixels[Width - x - 1, y];
                Pixels[Width - x - 1, y] := c;
              end;
            end;
          4: begin
              for x := 0 to Width2 - 1 do
              begin
                c := Pixels[x, y];
                Pixels[x, y] := Pixels[Width - x - 1, y];
                Pixels[Width - x - 1, y] := c;
              end;
            end;
          8: begin
              P2 := Pointer(Integer(P1) + Width - 1);
              for x := 0 to Width2 - 1 do
              begin
                PByte(@c)^ := PByte(P1)^;
                PByte(P1)^ := PByte(P2)^;
                PByte(P2)^ := PByte(@c)^;
                Inc(PByte(P1));
                Dec(PByte(P2));
              end;
            end;
          16: begin
              P2 := Pointer(Integer(P1) + (Width - 1) * 2);
              for x := 0 to Width2 - 1 do
              begin
                PWord(@c)^ := PWord(P1)^;
                PWord(P1)^ := PWord(P2)^;
                PWord(P2)^ := PWord(@c)^;
                Inc(PWord(P1));
                Dec(PWord(P2));
              end;
            end;
          24: begin
              P2 := Pointer(Integer(P1) + (Width - 1) * 3);
              for x := 0 to Width2 - 1 do
              begin
                PBGR(@c)^ := PBGR(P1)^;
                PBGR(P1)^ := PBGR(P2)^;
                PBGR(P2)^ := PBGR(@c)^;
                Inc(PBGR(P1));
                Dec(PBGR(P2));
              end;
            end;
          32: begin
              P2 := Pointer(Integer(P1) + (Width - 1) * 4);
              for x := 0 to Width2 - 1 do
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
      for y := 0 to Height shr 1 - 1 do
      begin
        P1 := ScanLine[y];
        P2 := ScanLine[Height - y - 1];

        case BitCount of
          1: begin
              for x := 0 to Width - 1 do
              begin
                c := Pixels[x, y];
                Pixels[x, y] := Pixels[Width - x - 1, Height - y - 1];
                Pixels[Width - x - 1, Height - y - 1] := c;
              end;
            end;
          4: begin
              for x := 0 to Width - 1 do
              begin
                c := Pixels[x, y];
                Pixels[x, y] := Pixels[Width - x - 1, Height - y - 1];
                Pixels[Width - x - 1, Height - y - 1] := c;
              end;
            end;
          8: begin
              P2 := Pointer(Integer(P2) + Width - 1);
              for x := 0 to Width - 1 do
              begin
                PByte(@c)^ := PByte(P1)^;
                PByte(P1)^ := PByte(P2)^;
                PByte(P2)^ := PByte(@c)^;
                Inc(PByte(P1));
                Dec(PByte(P2));
              end;
            end;
          16: begin
              P2 := Pointer(Integer(P2) + (Width - 1) * 2);
              for x := 0 to Width - 1 do
              begin
                PWord(@c)^ := PWord(P1)^;
                PWord(P1)^ := PWord(P2)^;
                PWord(P2)^ := PWord(@c)^;
                Inc(PWord(P1));
                Dec(PWord(P2));
              end;
            end;
          24: begin
              P2 := Pointer(Integer(P2) + (Width - 1) * 3);
              for x := 0 to Width - 1 do
              begin
                PBGR(@c)^ := PBGR(P1)^;
                PBGR(P1)^ := PBGR(P2)^;
                PBGR(P2)^ := PBGR(@c)^;
                Inc(PBGR(P1));
                Dec(PBGR(P2));
              end;
            end;
          32: begin
              P2 := Pointer(Integer(P2) + (Width - 1) * 4);
              for x := 0 to Width - 1 do
              begin
                PDWORD(@c)^ := PDWORD(P1)^;
                PDWORD(P1)^ := PDWORD(P2)^;
                PDWORD(P2)^ := PDWORD(@c)^;
                Inc(PDWORD(P1));
                Dec(PDWORD(P2));
              end;
            end;
        end;

        UpdateProgress(y * 2);
      end;
    finally
      EndProgress;
    end;
  end;
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
      1: begin
          SrcP := Pointer(Integer(Temp.TopPBits) + Y * Temp.NextLine);
          AveP := @Ave;
          for x := 0 to XCount - 1 do
          begin
            with Temp.ColorTable[(PByte(Integer(SrcP) + X shr 3)^ and Mask1[x and 7]) shr Shift1[x and 7]], AveP^ do
            begin
              Inc(cR, rgbRed);
              Inc(cG, rgbGreen);
              Inc(cB, rgbBlue);
              Inc(c);
            end;
            Inc(AveP);
          end;
        end;
      4: begin
          SrcP := Pointer(Integer(Temp.TopPBits) + Y * Temp.NextLine);
          AveP := @Ave;
          for x := 0 to XCount - 1 do
          begin
            with Temp.ColorTable[(PByte(Integer(SrcP) + X shr 1)^ and Mask4[x and 1]) shr Shift4[x and 1]], AveP^ do
            begin
              Inc(cR, rgbRed);
              Inc(cG, rgbGreen);
              Inc(cB, rgbBlue);
              Inc(c);
            end;
            Inc(AveP);
          end;
        end;
      8: begin
          SrcP := Pointer(Integer(Temp.TopPBits) + Y * Temp.NextLine);
          AveP := @Ave;
          for x := 0 to XCount - 1 do
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
          SrcP := Pointer(Integer(Temp.TopPBits) + Y * Temp.NextLine);
          AveP := @Ave;
          for x := 0 to XCount - 1 do
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
          SrcP := Pointer(Integer(Temp.TopPBits) + Y * Temp.NextLine);
          AveP := @Ave;
          for x := 0 to XCount - 1 do
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
          SrcP := Pointer(Integer(Temp.TopPBits) + Y * Temp.NextLine);
          AveP := @Ave;
          for x := 0 to XCount - 1 do
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
      1: begin
          SrcP := Pointer(Integer(Temp.TopPBits) + Y * Temp.NextLine);
          AveP := @Ave;
          for x := 0 to XCount - 1 do
          begin
            with Temp.ColorTable[(PByte(Integer(SrcP) + X shr 3)^ and Mask1[x and 7]) shr Shift1[x and 7]], AveP^ do
            begin
              Dec(cR, rgbRed);
              Dec(cG, rgbGreen);
              Dec(cB, rgbBlue);
              Dec(c);
            end;
            Inc(AveP);
          end;
        end;
      4: begin
          SrcP := Pointer(Integer(Temp.TopPBits) + Y * Temp.NextLine);
          AveP := @Ave;
          for x := 0 to XCount - 1 do
          begin
            with Temp.ColorTable[(PByte(Integer(SrcP) + X shr 1)^ and Mask4[x and 1]) shr Shift4[x and 1]], AveP^ do
            begin
              Dec(cR, rgbRed);
              Dec(cG, rgbGreen);
              Dec(cB, rgbBlue);
              Dec(c);
            end;
            Inc(AveP);
          end;
        end;
      8: begin
          SrcP := Pointer(Integer(Temp.TopPBits) + Y * Temp.NextLine);
          AveP := @Ave;
          for x := 0 to XCount - 1 do
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
          SrcP := Pointer(Integer(Temp.TopPBits) + Y * Temp.NextLine);
          AveP := @Ave;
          for x := 0 to XCount - 1 do
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
          SrcP := Pointer(Integer(Temp.TopPBits) + Y * Temp.NextLine);
          AveP := @Ave;
          for x := 0 to XCount - 1 do
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
          SrcP := Pointer(Integer(Temp.TopPBits) + Y * Temp.NextLine);
          AveP := @Ave;
          for x := 0 to XCount - 1 do
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
    GetMem(AveX, Width * SizeOf(TAve));
    try
      FillChar(AveX^, Width * SizeOf(TAve), 0);

      FirstX2 := -1;
      LastX2 := -1;
      FirstY := -1;
      LastY := -1;

      x := 0;
      for x2 := -Radius to Radius do
      begin
        jx := x + x2;
        if (jx >= 0) and (jx < Width) then
        begin
          if FirstX2 = -1 then FirstX2 := jx;
          if LastX2 < jx then LastX2 := jx;
        end;
      end;

      y := 0;
      for y2 := -Radius to Radius do
      begin
        jy := y + y2;
        if (jy >= 0) and (jy < Height) then
        begin
          if FirstY = -1 then FirstY := jy;
          if LastY < jy then LastY := jy;
        end;
      end;

      for y := FirstY to LastY do
        AddAverage(y, Temp.Width, AveX^);

      for y := 0 to Height - 1 do
      begin
        DestP := ScanLine[y];

        {  The average is updated.  }
        if y - FirstY = Radius + 1 then
        begin
          DeleteAverage(FirstY, Temp.Width, AveX^);
          Inc(FirstY);
        end;

        if LastY - y = Radius - 1 then
        begin
          Inc(LastY); if LastY >= Height then LastY := Height - 1;
          AddAverage(LastY, Temp.Width, AveX^);
        end;

        {  The average is calculated again.  }
        FirstX := FirstX2;
        LastX := LastX2;

        FillChar(Ave, SizeOf(Ave), 0);
        for x := FirstX to LastX do
          with AveX[x] do
          begin
            Inc(Ave.cR, cR);
            Inc(Ave.cG, cG);
            Inc(Ave.cB, cB);
            Inc(Ave.c, c);
          end;

        for x := 0 to Width - 1 do
        begin
          {  The average is updated.  }
          if x - FirstX = Radius + 1 then
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

          if LastX - x = Radius - 1 then
          begin
            Inc(LastX); if LastX >= Width then LastX := Width - 1;
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
            1: begin
                P := @PArrayByte(DestP)[X shr 3];
                with Ave do
                  P^ := (P^ and Mask1n[X and 7]) or (DWORD(Ord(((cR + cG + cB) div c) div 3 > 127)) shl Shift1[X and 7]);
              end;
            4: begin
                P := @PArrayByte(DestP)[X shr 1];
                with Ave do
                  P^ := (P^ and Mask4n[X and 1]) or (((((cR + cG + cB) div c) div 3) shr 4) shl Shift4[X and 1]);
              end;
            8: begin
                with Ave do
                  PByte(DestP)^ := ((cR + cG + cB) div c) div 3;
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
  if Empty or (Radius = 0) then Exit;

  Radius := Abs(Radius);

  StartProgress('Blur');
  try
    Temp := TDIB.Create;
    try
      Temp.Assign(Self);
      SetSize(Width, Height, ABitCount);

      if ABitCount <= 8 then
      begin
        FillChar(ColorTable, SizeOf(ColorTable), 0);
        for i := 0 to (1 shl ABitCount) - 1 do
        begin
          j := i * (1 shl (8 - ABitCount));
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

procedure TDIB.Negative;
var
  i, i2: Integer;
  P: Pointer;
begin
  if Empty then exit;

  if BitCount <= 8 then
  begin
    for i := 0 to 255 do
      with ColorTable[i] do
      begin
        rgbRed := 255 - rgbRed;
        rgbGreen := 255 - rgbGreen;
        rgbBlue := 255 - rgbBlue;
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

    if ABitCount <= 8 then
    begin
      FillChar(ColorTable, SizeOf(ColorTable), 0);
      for i := 0 to (1 shl ABitCount) - 1 do
      begin
        j := i * (1 shl (8 - ABitCount));
        j := j or (j shr ABitCount);
        ColorTable[i] := RGBQuad(j, j, j);
      end;
      UpdatePalette;
    end;

    for i := 0 to 255 do
    begin
      YTblR[i] := Trunc(0.3588 * i);
      YTblG[i] := Trunc(0.4020 * i);
      YTblB[i] := Trunc(0.2392 * i);
    end;

    c := 0;

    StartProgress('Greyscale');
    try
      for y := 0 to Height - 1 do
      begin
        DestP := ScanLine[y];
        SrcP := Temp.ScanLine[y];

        for x := 0 to Width - 1 do
        begin
          case Temp.BitCount of
            1: begin
                with Temp.ColorTable[(PArrayByte(SrcP)[X shr 3] and Mask1[X and 7]) shr Shift1[X and 7]] do
                  c := YTblR[rgbRed] + YTblG[rgbGreen] + YTblB[rgbBlue];
              end;
            4: begin
                with Temp.ColorTable[(PArrayByte(SrcP)[X shr 1] and Mask4[X and 1]) shr Shift4[X and 1]] do
                  c := YTblR[rgbRed] + YTblG[rgbGreen] + YTblB[rgbBlue];
              end;
            8: begin
                with Temp.ColorTable[PByte(SrcP)^] do
                  c := YTblR[rgbRed] + YTblG[rgbGreen] + YTblB[rgbBlue];
                Inc(PByte(SrcP));
              end;
            16: begin
                pfGetRGB(Temp.NowPixelFormat, PWord(SrcP)^, R, G, B);
                c := YTblR[R] + YTblR[G] + YTblR[B];
                Inc(PWord(SrcP));
              end;
            24: begin
                with PBGR(SrcP)^ do
                  c := YTblR[R] + YTblG[G] + YTblB[B];
                Inc(PBGR(SrcP));
              end;
            32: begin
                pfGetRGB(Temp.NowPixelFormat, PDWORD(SrcP)^, R, G, B);
                c := YTblR[R] + YTblR[G] + YTblR[B];
                Inc(PDWORD(SrcP));
              end;
          end;

          case BitCount of
            1: begin
                P := @PArrayByte(DestP)[X shr 3];
                P^ := (P^ and Mask1n[X and 7]) or (DWORD(Ord(c > 127)) shl Shift1[X and 7]);
              end;
            4: begin
                P := @PArrayByte(DestP)[X shr 1];
                P^ := (P^ and Mask4n[X and 1]) or ((c shr 4) shl Shift4[X and 1]);
              end;
            8: begin
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

//--------------------------------------------------------------------------------------------------
// Version : 0.1 - 26/06/2000                                                                     //
// Version : 0.2 - 04/07/2000                                                                     //
//   At someone's request, i have added 3 news effects :                                          //
//    1 - Rotate                                                                                  //
//    2 - SplitBlur                                                                               //
//    3 - GaussianBlur                                                                            //
//--------------------------------------------------------------------------------------------------
//                           -   NEW SPECIAL EFFECT   -  (English)                                //
//--------------------------------------------------------------------------------------------------
//   At the start, my idea was to create a component derived from TCustomDXDraw. Unfortunately,   //
// it's impossible to run a graphic component (derived from TCustomDXDraw) in a conception's      //
// mode (i don't success, but perhaps, somebody know how doing ! In that case, please help me !!!)//
// Then, i'm used the DIB's unit for my work, but this unit is poor in special effect. Knowing a  //
// library with more effect, i'm undertaked to import this library in DIB's unit. You can see the //
// FastLib library at :                                                                           //
//                                                                                                //
//      ->      Gordon Alex Cowie <gfody@jps.net> www.jps.net/gfody                               //
//                                                                                                //
//   It was very difficult, because implementation's graphic was very different that DIB's unit.  //
// Sometimes, i'm deserted the possibility of original effect, particularly in conversion of DIB  //
// whith 256, 16 and 2 colors. If someone can implement this fonctionnality, thanks to tell me    //
// how this miracle is possible !!!                                                               //
// All these procedures are translated and adapted by :                                           //
//                                                                                                //
//      ->      Mickey (Michel HIBON) <mhibon@ifrance.com> http://mickey.tsx.org                  //
//                                                                                                //
// IMPORTANT : These procedures don't modify the DIB's unit structure                             //
// Nota Bene : I don't implement these type of graphics (32 and 16 bit per pixels),               //
//             for one reason : I haven't bitmaps of this type !!!                                //
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
//                        -   NOUVEAUX EFFETS SPECIAUX   -  (Français)                            //
//--------------------------------------------------------------------------------------------------
//   Au commencement, mon idée était de dériver un composant de TCustomDXDraw. Malheureusement,   //
// c'est impossible de faire fonctionner un composant graphique (derivé de TCustomDXDraw) en mode //
// conception (je n'y suis pas parvenu, mais peut-être, que quelqu'un sait comment faire ! Dans   //
// ce cas, vous seriez aimable de m'aider !!!)                                                    //
// Alors, j'ai utilisé l'unité DIB pour mon travail,mais celle-ci est pauvre en effet spéciaux.   //
// Connaissant une librairie avec beaucoup plus d'effets spéciaux, j'ai entrepris d'importer      //
// cette librairie dans l'unité DIB. Vous pouvez voir la librairie FastLib à :                    //
//                                                                                                //
//      ->      Gordon Alex Cowie <gfody@jps.net> www.jps.net/gfody                               //
//                                                                                                //
//   C'était très difficile car l'implémentation graphique est très différente de l'unité DIB.    //
// Parfois, j'ai abandonné les possibilités de l'effet original, particulièrement dans la         //
// conversion des DIB avec 256, 16 et 2 couleurs. Si quelqu'un arrive à implémenter ces           //
// fonctionnalités, merci de me dire comment ce miracle est possible !!!                          //
// Toutes ces procédures ont été traduites et adaptées par:                                       //
//                                                                                                //
//      ->      Mickey (Michel HIBON) <mhibon@ifrance.com> http://mickey.tsx.org                  //
//                                                                                                //
// IMPORTANT : Ces procédures ne modifient pas la structure de l'unité DIB                        //
// Nota Bene : Je n'ai pas implémenté ces types de graphiques (32 et 16 bit par pixels),          //
//             pour une raison : je n'ai pas de bitmap de ce type !!!                                //
//--------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------

function TDIB.IntToColor(i: integer): TBGR;
begin
  Result.b := i shr 16;
  Result.g := i shr 8;
  Result.r := i;
end;

//--------------------------------------------------------------------------------------------------

function TDIB.Interval(iMin, iMax, iValue: Integer; iMark: boolean): Integer;
begin
  if iMark then
  begin
    if iValue < iMin then
      Result := iMin
    else
      if iValue > iMax then
        Result := iMax
      else
        Result := iValue;
  end
  else
  begin
    if iValue < iMin then
      Result := iMin
    else
      if iValue > iMax then
        Result := iMin
      else
        Result := iValue;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TDIB.Contrast(Amount: integer);
var
  x, y: Integer;
  Table1: array[0..255] of Byte;
  i: Byte;
  S, D: pointer;
  Temp1: TDIB;
  color: DWORD;
  P: PByte;
  R, G, B: Byte;

begin
  D := nil;
  S := nil;
  Temp1 := nil;
  for i := 0 to 126 do
  begin
    y := (Abs(128 - i) * Amount) div 256;
    Table1[i] := IntToByte(i - y);
  end;
  for i := 127 to 255 do
  begin
    y := (Abs(128 - i) * Amount) div 256;
    Table1[i] := IntToByte(i + y);
  end;
  case BitCount of
    32: Exit; // I haven't bitmap of this type ! Sorry
    24: ; // nothing to do
    16: ; // I have an artificial bitmap for this type ! i don't sure that it works
    8, 4:
      begin
        Temp1 := TDIB.Create;
        Temp1.Assign(self);
        Temp1.SetSize(Width, Height, BitCount);
        for i := 0 to 255 do
        begin
          with ColorTable[i] do
          begin
            rgbRed := IntToByte(Table1[rgbRed]);
            rgbGreen := IntToByte(Table1[rgbGreen]);
            rgbBlue := IntToByte(Table1[rgbBlue]);
          end;
        end;
        UpdatePalette;
      end;
  else
    // if the number of pixel is equal to 1 then exit of procedure
    Exit;
  end;
  for y := 0 to Pred(Height) do
  begin
    case BitCount of
      24, 16: D := ScanLine[y];
      8, 4:
        begin
          D := Temp1.ScanLine[y];
          S := Temp1.ScanLine[y];
        end;
    else
    end;
    for x := 0 to Pred(Width) do
    begin
      case BitCount of
        32: ;
        24:
          begin
            PBGR(D)^.B := Table1[PBGR(D)^.B];
            PBGR(D)^.G := Table1[PBGR(D)^.G];
            PBGR(D)^.R := Table1[PBGR(D)^.R];
            Inc(PBGR(D));
          end;
        16:
          begin
            pfGetRGB(NowPixelFormat, PWord(D)^, R, G, B);
            PWord(D)^ := Table1[R] + Table1[G] + Table1[B];
            Inc(PWord(D));
          end;
        8:
          begin
            with Temp1.ColorTable[PByte(S)^] do
              color := rgbRed + rgbGreen + rgbBlue;
            Inc(PByte(S));
            PByte(D)^ := color;
            Inc(PByte(D));
          end;
        4:
          begin
            with Temp1.ColorTable[PByte(S)^] do
              color := rgbRed + rgbGreen + rgbBlue;
            Inc(PByte(S));
            P := @PArrayByte(D)[X shr 1];
            P^ := (P^ and Mask4n[X and 1]) or (color shl Shift4[X and 1]);
          end;
      else
      end;
    end;
  end;
  case BitCount of
    8, 4: Temp1.Free;
  else
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TDIB.Saturation(Amount: integer);
var
  Grays: array[0..767] of Integer;
  Alpha: array[0..255] of Word;
  Gray, x, y: Integer;
  i: Byte;
  S, D: pointer;
  Temp1: TDIB;
  color: DWORD;
  P: PByte;
  R, G, B: Byte;

begin
  D := nil;
  S := nil;
  Temp1 := nil;
  for i := 0 to 255 do
    Alpha[i] := (i * Amount) shr 8;
  x := 0;
  for i := 0 to 255 do
  begin
    Gray := i - Alpha[i];
    Grays[x] := Gray;
    Inc(x);
    Grays[x] := Gray;
    Inc(x);
    Grays[x] := Gray;
    Inc(x);
  end;
  case BitCount of
    32: Exit; // I haven't bitmap of this type ! Sorry
    24: ; // nothing to do
    16: ; // I have an artificial bitmap for this type ! i don't sure that it works
    8, 4:
      begin
        Temp1 := TDIB.Create;
        Temp1.Assign(self);
        Temp1.SetSize(Width, Height, BitCount);
        for i := 0 to 255 do
        begin
          with ColorTable[i] do
          begin
            Gray := Grays[rgbRed + rgbGreen + rgbBlue];
            rgbRed := IntToByte(Gray + Alpha[rgbRed]);
            rgbGreen := IntToByte(Gray + Alpha[rgbGreen]);
            rgbBlue := IntToByte(Gray + Alpha[rgbBlue]);
          end;
        end;
        UpdatePalette;
      end;
  else
    // if the number of pixel is equal to 1 then exit of procedure
    Exit;
  end;
  for y := 0 to Pred(Height) do
  begin
    case BitCount of
      24, 16: D := ScanLine[y];
      8, 4:
        begin
          D := Temp1.ScanLine[y];
          S := Temp1.ScanLine[y];
        end;
    else
    end;
    for x := 0 to Pred(Width) do
    begin
      case BitCount of
        32: ;
        24:
          begin
            Gray := Grays[PBGR(D)^.R + PBGR(D)^.G + PBGR(D)^.B];
            PBGR(D)^.B := IntToByte(Gray + Alpha[PBGR(D)^.B]);
            PBGR(D)^.G := IntToByte(Gray + Alpha[PBGR(D)^.G]);
            PBGR(D)^.R := IntToByte(Gray + Alpha[PBGR(D)^.R]);
            Inc(PBGR(D));
          end;
        16:
          begin
            pfGetRGB(NowPixelFormat, PWord(D)^, R, G, B);
            PWord(D)^ := IntToByte(Gray + Alpha[B]) + IntToByte(Gray + Alpha[G]) +
              IntToByte(Gray + Alpha[R]);
            Inc(PWord(D));
          end;
        8:
          begin
            with Temp1.ColorTable[PByte(S)^] do
              color := rgbRed + rgbGreen + rgbBlue;
            Inc(PByte(S));
            PByte(D)^ := color;
            Inc(PByte(D));
          end;
        4:
          begin
            with Temp1.ColorTable[PByte(S)^] do
              color := rgbRed + rgbGreen + rgbBlue;
            Inc(PByte(S));
            P := @PArrayByte(D)[X shr 1];
            P^ := (P^ and Mask4n[X and 1]) or (color shl Shift4[X and 1]);
          end;
      else
      end;
    end;
  end;
  case BitCount of
    8, 4: Temp1.Free;
  else
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TDIB.Lightness(Amount: integer);
var
  x, y: Integer;
  Table1: array[0..255] of Byte;
  i: Byte;
  S, D: pointer;
  Temp1: TDIB;
  color: DWORD;
  P: PByte;
  R, G, B: Byte;

begin
  D := nil;
  S := nil;
  Temp1 := nil;
  if Amount < 0 then
  begin
    Amount := -Amount;
    for i := 0 to 255 do
      Table1[i] := IntToByte(i - ((Amount * i) shr 8));
  end
  else
    for i := 0 to 255 do
      Table1[i] := IntToByte(i + ((Amount * (i xor 255)) shr 8));
  case BitCount of
    32: Exit; // I haven't bitmap of this type ! Sorry
    24: ; // nothing to do
    16: ; // I have an artificial bitmap for this type ! i don't sure that it works
    8, 4:
      begin
        Temp1 := TDIB.Create;
        Temp1.Assign(self);
        Temp1.SetSize(Width, Height, BitCount);
        for i := 0 to 255 do
        begin
          with ColorTable[i] do
          begin
            rgbRed := IntToByte(Table1[rgbRed]);
            rgbGreen := IntToByte(Table1[rgbGreen]);
            rgbBlue := IntToByte(Table1[rgbBlue]);
          end;
        end;
        UpdatePalette;
      end;
  else
    // if the number of pixel is equal to 1 then exit of procedure
    Exit;
  end;
  for y := 0 to Pred(Height) do
  begin
    case BitCount of
      24, 16: D := ScanLine[y];
      8, 4:
        begin
          D := Temp1.ScanLine[y];
          S := Temp1.ScanLine[y];
        end;
    else
    end;
    for x := 0 to Pred(Width) do
    begin
      case BitCount of
        32: ;
        24:
          begin
            PBGR(D)^.B := Table1[PBGR(D)^.B];
            PBGR(D)^.G := Table1[PBGR(D)^.G];
            PBGR(D)^.R := Table1[PBGR(D)^.R];
            Inc(PBGR(D));
          end;
        16:
          begin
            pfGetRGB(NowPixelFormat, PWord(D)^, R, G, B);
            PWord(D)^ := Table1[R] + Table1[G] + Table1[B];
            Inc(PWord(D));
          end;
        8:
          begin
            with Temp1.ColorTable[PByte(S)^] do
              color := rgbRed + rgbGreen + rgbBlue;
            Inc(PByte(S));
            PByte(D)^ := color;
            Inc(PByte(D));
          end;
        4:
          begin
            with Temp1.ColorTable[PByte(S)^] do
              color := rgbRed + rgbGreen + rgbBlue;
            Inc(PByte(S));
            P := @PArrayByte(D)[X shr 1];
            P^ := (P^ and Mask4n[X and 1]) or (color shl Shift4[X and 1]);
          end;
      else
      end;
    end;
  end;
  case BitCount of
    8, 4: Temp1.Free;
  else
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TDIB.AddRGB(ra, ga, ba: byte);
var
  Table: array[0..255] of TBGR;
  x, y: Integer;
  i: Byte;
  D: pointer;
  P: PByte;
  color: DWORD;
  Temp1: TDIB;
  R, G, B: Byte;

begin
  color := 0;
  D := nil;
  Temp1 := nil;
  case BitCount of
    32: Exit; // I haven't bitmap of this type ! Sorry
    24, 16:
      begin
        for i := 0 to 255 do
        begin
          Table[i].b := IntToByte(i + ba);
          Table[i].g := IntToByte(i + ga);
          Table[i].r := IntToByte(i + ra);
        end;
      end;
    8, 4:
      begin
        Temp1 := TDIB.Create;
        Temp1.Assign(self);
        Temp1.SetSize(Width, Height, BitCount);
        for i := 0 to 255 do
        begin
          with ColorTable[i] do
          begin
            rgbRed := IntToByte(rgbRed + ra);
            rgbGreen := IntToByte(rgbGreen + ga);
            rgbBlue := IntToByte(rgbBlue + ba);
          end;
        end;
        UpdatePalette;
      end;
  else
    // if the number of pixel is equal to 1 then exit of procedure
    Exit;
  end;
  for y := 0 to Pred(Height) do
  begin
    case BitCount of
      24, 16: D := ScanLine[y];
      8, 4:
        begin
          D := Temp1.ScanLine[y];
        end;
    else
    end;
    for x := 0 to Pred(Width) do
    begin
      case BitCount of
        32: ; // I haven't bitmap of this type ! Sorry
        24:
          begin
            PBGR(D)^.B := Table[PBGR(D)^.B].b;
            PBGR(D)^.G := Table[PBGR(D)^.G].g;
            PBGR(D)^.R := Table[PBGR(D)^.R].r;
            Inc(PBGR(D));
          end;
        16:
          begin
            pfGetRGB(NowPixelFormat, PWord(D)^, R, G, B);
            PWord(D)^ := Table[R].r + Table[G].g + Table[B].b;
            Inc(PWord(D));
          end;
        8:
          begin
            Inc(PByte(D));
          end;
        4:
          begin
            P := @PArrayByte(D)[X shr 1];
            P^ := (P^ and Mask4n[X and 1]) or (color shl Shift4[X and 1]);
          end;
      else
      end;
    end;
  end;
  case BitCount of
    8, 4: Temp1.Free;
  else
  end;
end;

//--------------------------------------------------------------------------------------------------

function TDIB.Filter(Dest: TDIB; Filter: TFilter): boolean;
var
  Sum, r, g, b, x, y: integer;
  a, i, j: byte;
  tmp: TBGR;
  Col: PBGR;
  D: Pointer;

begin
  Result := True;
  Sum := Filter[0, 0] + Filter[1, 0] + Filter[2, 0] +
    Filter[0, 1] + Filter[1, 1] + Filter[2, 1] +
    Filter[0, 2] + Filter[1, 2] + Filter[2, 2];
  if Sum = 0 then
    Sum := 1;
  Col := PBits;
  for y := 0 to Pred(Height) do
  begin
    D := Dest.ScanLine[y];
    for x := 0 to Pred(Width) do
    begin
      r := 0; g := 0; b := 0;
      case BitCount of
        32, 16, 4, 1:
          begin
            Result := False;
            Exit;
          end;
        24:
          begin
            for i := 0 to 2 do
            begin
              for j := 0 to 2 do
              begin
                Tmp := IntToColor(Pixels[Interval(0, Pred(Width), x + Pred(i), True),
                  Interval(0, Pred(Height), y + Pred(j), True)]);
                Inc(b, Filter[i, j] * Tmp.b);
                Inc(g, Filter[i, j] * Tmp.g);
                Inc(r, Filter[i, j] * Tmp.r);
              end;
            end;
            Col.b := IntToByte(b div Sum);
            Col.g := IntToByte(g div Sum);
            Col.r := IntToByte(r div Sum);
            Dest.Pixels[x, y] := rgb(Col.r, Col.g, Col.b);
          end;
        8:
          begin
            for i := 0 to 2 do
            begin
              for j := 0 to 2 do
              begin
                a := (Pixels[Interval(0, Pred(Width), x + Pred(i), True),
                  Interval(0, Pred(Height), y + Pred(j), True)]);
                tmp.r := ColorTable[a].rgbRed;
                tmp.g := ColorTable[a].rgbGreen;
                tmp.b := ColorTable[a].rgbBlue;
                Inc(b, Filter[i, j] * Tmp.b);
                Inc(g, Filter[i, j] * Tmp.g);
                Inc(r, Filter[i, j] * Tmp.r);
              end;
            end;
            Col.b := IntToByte(b div Sum);
            Col.g := IntToByte(g div Sum);
            Col.r := IntToByte(r div Sum);
            PByte(D)^ := rgb(Col.r, Col.g, Col.b);
            Inc(PByte(D));
          end;
      end;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TDIB.Spray(Amount: integer);
var
  value, x, y: Integer;
  D: Pointer;
  color: DWORD;
  P: PByte;

begin
  for y := Pred(Height) downto 0 do
  begin
    D := ScanLine[y];
    for x := 0 to Pred(Width) do
    begin
      value := Random(Amount);
      color := Pixels[Interval(0, Pred(Width), x + (value - Random(value * 2)), True),
        Interval(0, Pred(Height), y + (value - Random(value * 2)), True)];
      case BitCount of
        32:
          begin
            PDWord(D)^ := color;
            Inc(PDWord(D));
          end;
        24:
          begin
            PBGR(D)^ := IntToColor(color);
            Inc(PBGR(D));
          end;
        16:
          begin
            PWord(D)^ := color;
            Inc(PWord(D));
          end;
        8:
          begin
            PByte(D)^ := color;
            Inc(PByte(D));
          end;
        4:
          begin
            P := @PArrayByte(D)[X shr 1];
            P^ := (P^ and Mask4n[X and 1]) or (color shl Shift4[X and 1]);
          end;
        1:
          begin
            P := @PArrayByte(D)[X shr 3];
            P^ := (P^ and Mask1n[X and 7]) or (color shl Shift1[X and 7]);
          end;
      else
      end;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TDIB.Sharpen(Amount: Integer);
var
  Lin0, Lin1, Lin2: PLines;
  pc: PBGR;
  cx, x, y: Integer;
  Buf: array[0..8] of TBGR;
  S, D, D1, P: pointer;
  color: TBGR;
  c: DWORD;
  i: byte;
  P1: PByte;
  Temp1: TDIB;

begin
  D := nil;
  GetMem(pc, SizeOf(TBGR));
  c := 0;
  Temp1 := nil;
  case Bitcount of
    32, 16, 1: Exit;
    24:
      begin
        Temp1 := TDIB.Create;
        Temp1.Assign(self);
        Temp1.SetSize(Width, Height, bitCount);
      end;
    8:
      begin
        Temp1 := TDIB.Create;
        Temp1.Assign(self);
        Temp1.SetSize(Width, Height, bitCount);
        for i := 0 to 255 do
        begin
          with Temp1.ColorTable[i] do
          begin
            Buf[0].B := ColorTable[i - Amount].rgbBlue;
            Buf[0].G := ColorTable[i - Amount].rgbGreen;
            Buf[0].R := ColorTable[i - Amount].rgbRed;
            Buf[1].B := ColorTable[i].rgbBlue;
            Buf[1].G := ColorTable[i].rgbGreen;
            Buf[1].R := ColorTable[i].rgbRed;
            Buf[2].B := ColorTable[i + Amount].rgbBlue;
            Buf[2].G := ColorTable[i + Amount].rgbGreen;
            Buf[2].R := ColorTable[i + Amount].rgbRed;
            Buf[3].B := ColorTable[i - Amount].rgbBlue;
            Buf[3].G := ColorTable[i - Amount].rgbGreen;
            Buf[3].R := ColorTable[i - Amount].rgbRed;
            Buf[4].B := ColorTable[i].rgbBlue;
            Buf[4].G := ColorTable[i].rgbGreen;
            Buf[4].R := ColorTable[i].rgbRed;
            Buf[5].B := ColorTable[i + Amount].rgbBlue;
            Buf[5].G := ColorTable[i + Amount].rgbGreen;
            Buf[5].R := ColorTable[i + Amount].rgbRed;
            Buf[6].B := ColorTable[i - Amount].rgbBlue;
            Buf[6].G := ColorTable[i - Amount].rgbGreen;
            Buf[6].R := ColorTable[i - Amount].rgbRed;
            Buf[7].B := ColorTable[i].rgbBlue;
            Buf[7].G := ColorTable[i].rgbGreen;
            Buf[7].R := ColorTable[i].rgbRed;
            Buf[8].B := ColorTable[i + Amount].rgbBlue;
            Buf[8].G := ColorTable[i + Amount].rgbGreen;
            Buf[8].R := ColorTable[i + Amount].rgbRed;
            Temp1.colorTable[i].rgbBlue := IntToByte((256 * Buf[4].b - (Buf[0].b + Buf[1].b + Buf[2].b + Buf[3].b +
              Buf[5].b + Buf[6].b + Buf[7].b + Buf[8].b) * 16) div 128);
            Temp1.colorTable[i].rgbGreen := IntToByte((256 * Buf[4].g - (Buf[0].g + Buf[1].g + Buf[2].g + Buf[3].g +
              Buf[5].g + Buf[6].g + Buf[7].g + Buf[8].g) * 16) div 128);
            Temp1.colorTable[i].rgbRed := IntToByte((256 * Buf[4].r - (Buf[0].r + Buf[1].r + Buf[2].r + Buf[3].r +
              Buf[5].r + Buf[6].r + Buf[7].r + Buf[8].r) * 16) div 128);

          end;
        end;
        Temp1.UpdatePalette;
      end;
    4:
      begin
        Temp1 := TDIB.Create;
        Temp1.Assign(self);
        Temp1.SetSize(Width, Height, bitCount);
        for i := 0 to 255 do
        begin
          with Temp1.ColorTable[i] do
          begin
            Buf[0].B := ColorTable[i - Amount].rgbBlue;
            Buf[0].G := ColorTable[i - Amount].rgbGreen;
            Buf[0].R := ColorTable[i - Amount].rgbRed;
            Buf[1].B := ColorTable[i].rgbBlue;
            Buf[1].G := ColorTable[i].rgbGreen;
            Buf[1].R := ColorTable[i].rgbRed;
            Buf[2].B := ColorTable[i + Amount].rgbBlue;
            Buf[2].G := ColorTable[i + Amount].rgbGreen;
            Buf[2].R := ColorTable[i + Amount].rgbRed;
            Buf[3].B := ColorTable[i - Amount].rgbBlue;
            Buf[3].G := ColorTable[i - Amount].rgbGreen;
            Buf[3].R := ColorTable[i - Amount].rgbRed;
            Buf[4].B := ColorTable[i].rgbBlue;
            Buf[4].G := ColorTable[i].rgbGreen;
            Buf[4].R := ColorTable[i].rgbRed;
            Buf[5].B := ColorTable[i + Amount].rgbBlue;
            Buf[5].G := ColorTable[i + Amount].rgbGreen;
            Buf[5].R := ColorTable[i + Amount].rgbRed;
            Buf[6].B := ColorTable[i - Amount].rgbBlue;
            Buf[6].G := ColorTable[i - Amount].rgbGreen;
            Buf[6].R := ColorTable[i - Amount].rgbRed;
            Buf[7].B := ColorTable[i].rgbBlue;
            Buf[7].G := ColorTable[i].rgbGreen;
            Buf[7].R := ColorTable[i].rgbRed;
            Buf[8].B := ColorTable[i + Amount].rgbBlue;
            Buf[8].G := ColorTable[i + Amount].rgbGreen;
            Buf[8].R := ColorTable[i + Amount].rgbRed;
            colorTable[i].rgbBlue := IntToByte((256 * Buf[4].b - (Buf[0].b + Buf[1].b + Buf[2].b + Buf[3].b +
              Buf[5].b + Buf[6].b + Buf[7].b + Buf[8].b) * 16) div 128);
            colorTable[i].rgbGreen := IntToByte((256 * Buf[4].g - (Buf[0].g + Buf[1].g + Buf[2].g + Buf[3].g +
              Buf[5].g + Buf[6].g + Buf[7].g + Buf[8].g) * 16) div 128);
            colorTable[i].rgbRed := IntToByte((256 * Buf[4].r - (Buf[0].r + Buf[1].r + Buf[2].r + Buf[3].r +
              Buf[5].r + Buf[6].r + Buf[7].r + Buf[8].r) * 16) div 128);
          end;
        end;
        UpdatePalette;
      end;
  end;
  for y := 0 to Pred(Height) do
  begin
    Lin0 := ScanLine[Interval(0, Pred(Height), y - Amount, True)];
    Lin1 := ScanLine[y];
    Lin2 := ScanLine[Interval(0, Pred(Height), y + Amount, True)];
    case Bitcount of
      24, 8, 4: D := Temp1.ScanLine[y];
    end;
    for x := 0 to Pred(Width) do
    begin
      case BitCount of
        24:
          begin
            cx := Interval(0, Pred(Width), x - Amount, True);
            Buf[0] := Lin0[cx];
            Buf[1] := Lin1[cx];
            Buf[2] := Lin2[cx];
            Buf[3] := Lin0[x];
            Buf[4] := Lin1[x];
            Buf[5] := Lin2[x];
            cx := Interval(0, Pred(Width), x + Amount, true);
            Buf[6] := Lin0[cx];
            Buf[7] := Lin1[cx];
            Buf[8] := Lin0[cx];
            pc.b := IntToByte((256 * Buf[4].b - (Buf[0].b + Buf[1].b + Buf[2].b + Buf[3].b +
              Buf[5].b + Buf[6].b + Buf[7].b + Buf[8].b) * 16) div 128);
            pc.g := IntToByte((256 * Buf[4].g - (Buf[0].g + Buf[1].g + Buf[2].g + Buf[3].g +
              Buf[5].g + Buf[6].g + Buf[7].g + Buf[8].g) * 16) div 128);
            pc.r := IntToByte((256 * Buf[4].r - (Buf[0].r + Buf[1].r + Buf[2].r + Buf[3].r +
              Buf[5].r + Buf[6].r + Buf[7].r + Buf[8].r) * 16) div 128);
            PBGR(D)^.B := pc.b;
            PBGR(D)^.G := pc.g;
            PBGR(D)^.R := pc.r;
            Inc(PBGR(D));
          end;
        8:
          begin
            Inc(PByte(D));
          end;
        4:
          begin
            P1 := @PArrayByte(D)[X shr 1];
            P1^ := ((P1^ and Mask4n[X and 1]) or ((c shl Shift4[X and 1])));
          end;
      end;
    end;
  end;
  case BitCount of
    24, 8:
      begin
        Assign(Temp1);
        Temp1.Free;
      end;
    4: Temp1.Free;
  end;
  FreeMem(pc, SizeOf(TBGR));
end;

//--------------------------------------------------------------------------------------------------

procedure TDIB.Emboss;
var
  x, y: longint;
  D, D1, P: pointer;
  color: TBGR;
  c: DWORD;
  P1: PByte;

begin
  D := nil;
  D1 := nil;
  P := nil;
  case BitCount of
    32, 16, 1: Exit;
    24:
      begin
        D := PBits;
        D1 := Ptr(Integer(D) + 3);
      end;
  else
  end;
  for y := 0 to Pred(Height) do
  begin
    case Bitcount of
      8, 4:
        begin
          P := ScanLine[y];
        end;
    end;
    for x := 0 to Pred(Width) do
    begin
      case BitCount of
        24:
          begin
            PBGR(D)^.B := ((PBGR(D)^.B + (PBGR(D1)^.B xor $FF)) shr 1);
            PBGR(D)^.G := ((PBGR(D)^.G + (PBGR(D1)^.G xor $FF)) shr 1);
            PBGR(D)^.R := ((PBGR(D)^.R + (PBGR(D1)^.R xor $FF)) shr 1);
            Inc(PBGR(D));
            if (y < Height - 2) and (x < Width - 2) then
              Inc(PBGR(D1));
          end;
        8:
          begin
            color.R := (((Pixels[x, y] + (Pixels[x + 3, y] xor $FF)) shr 1) + 30) div 3;
            color.G := (((Pixels[x, y] + (Pixels[x + 3, y] xor $FF)) shr 1) + 30) div 3;
            color.B := (((Pixels[x, y] + (Pixels[x + 3, y] xor $FF)) shr 1) + 30) div 3;
            c := (color.R + color.G + color.B) shr 1;
            PByte(P)^ := c;
            Inc(PByte(P));
          end;
        4:
          begin
            color.R := (((Pixels[x, y] + (Pixels[x + 3, y] xor $FF) + 1) shr 1) + 30) div 3;
            color.G := (((Pixels[x, y] + (Pixels[x + 3, y] xor $FF) - 1) shr 1) + 30) div 3;
            color.B := (((Pixels[x, y] + (Pixels[x + 3, y] xor $FF) + 1) shr 1) + 30) div 3;
            c := (color.R + color.G + color.B) shr 1;
            if c > 64 then
              c := c - 8;
            P1 := @PArrayByte(P)[X shr 1];
            P1^ := (P1^ and Mask4n[X and 1]) or ((c) shl Shift4[X and 1]);
          end;
      else
      end;
    end;
    case BitCount of
      24:
        begin
          D := Ptr(Integer(D1));
          if y < Height - 2 then
            D1 := Ptr(Integer(D1) + 6)
          else
            D1 := Ptr(Integer(ScanLine[Pred(Height)]) + 3);
        end;
    else
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TDIB.AddMonoNoise(Amount: integer);
var
  value: cardinal;
  x, y: longint;
  a: byte;
  D: pointer;
  color: DWORD;
  P: PByte;

begin
  for y := 0 to Pred(Height) do
  begin
    D := ScanLine[y];
    for x := 0 to Pred(Width) do
    begin
      case BitCount of
        32: Exit; // I haven't bitmap of this type ! Sorry
        24:
          begin
            value := Random(Amount) - (Amount shr 1);
            PBGR(D)^.B := IntToByte(PBGR(D)^.B + value);
            PBGR(D)^.G := IntToByte(PBGR(D)^.G + value);
            PBGR(D)^.R := IntToByte(PBGR(D)^.R + value);
            Inc(PBGR(D));
          end;
        16: Exit; // I haven't bitmap of this type ! Sorry
        8:
          begin
            a := ((Random(Amount shr 1) - (Amount div 4))) div 8;
            color := Interval(0, 255, (pixels[x, y] - a), True);
            PByte(D)^ := color;
            Inc(PByte(D));
          end;
        4:
          begin
            a := ((Random(Amount shr 1) - (Amount div 4))) div 16;
            color := Interval(0, 15, (pixels[x, y] - a), True);
            P := @PArrayByte(D)[X shr 1];
            P^ := ((P^ and Mask4n[X and 1]) or ((color shl Shift4[X and 1])));
          end;
        1:
          begin
            a := ((Random(Amount shr 1) - (Amount div 4))) div 32;
            color := Interval(0, 1, (pixels[x, y] - a), True);
            P := @PArrayByte(D)[X shr 3];
            P^ := (P^ and Mask1n[X and 7]) or (color shl Shift1[X and 7]);
          end;
      else
      end;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TDIB.AddGradiantNoise(Amount: byte);
var
  a, i: byte;
  x, y: Integer;
  Table: array[0..255] of TBGR;
  S, D: pointer;
  color: DWORD;
  Temp1: TDIB;
  P: PByte;

begin
  D := nil;
  S := nil;
  Temp1 := nil;
  case BitCount of
    32: Exit; // I haven't bitmap of this type ! Sorry
    24:
      begin
        for i := 0 to 255 do
        begin
          a := Random(Amount);
          Table[i].b := IntToByte(i + a);
          Table[i].g := IntToByte(i + a);
          Table[i].r := IntToByte(i + a);
        end;
      end;
    16: Exit; // I haven't bitmap of this type ! Sorry
    8, 4:
      begin
        Temp1 := TDIB.Create;
        Temp1.Assign(self);
        Temp1.SetSize(Width, Height, BitCount);
        for i := 0 to 255 do
        begin
          with ColorTable[i] do
          begin
            a := Random(Amount);
            rgbRed := IntToByte(rgbRed + a);
            rgbGreen := IntToByte(rgbGreen + a);
            rgbBlue := IntToByte(rgbBlue + a);
          end;
        end;
        UpdatePalette;
      end;
  else
    // if the number of pixel is equal to 1 then exit of procedure
    Exit;
  end;
  for y := 0 to Pred(Height) do
  begin
    case BitCount of
      24: D := ScanLine[y];
      8, 4:
        begin
          D := Temp1.ScanLine[y];
          S := Temp1.ScanLine[y];
        end;
    else
    end;
    for x := 0 to Pred(Width) do
    begin
      case BitCount of
        32: ; // I haven't bitmap of this type ! Sorry
        24:
          begin
            PBGR(D)^.B := Table[PBGR(D)^.B].b;
            PBGR(D)^.G := Table[PBGR(D)^.G].g;
            PBGR(D)^.R := Table[PBGR(D)^.R].r;
            Inc(PBGR(D));
          end;
        16: ; // I haven't bitmap of this type ! Sorry
        8:
          begin
            with Temp1.ColorTable[PByte(S)^] do
              color := rgbRed + rgbGreen + rgbBlue;
            Inc(PByte(S));
            PByte(D)^ := color;
            Inc(PByte(D));
          end;
        4:
          begin
            with Temp1.ColorTable[PByte(S)^] do
              color := rgbRed + rgbGreen + rgbBlue;
            Inc(PByte(S));
            P := @PArrayByte(D)[X shr 1];
            P^ := (P^ and Mask4n[X and 1]) or (color shl Shift4[X and 1]);
          end;
      else
      end;
    end;
  end;
  case BitCount of
    8, 4: Temp1.Free;
  else
  end;
end;

//--------------------------------------------------------------------------------------------------

function TDIB.FishEye(bmp: TDIB): boolean;
var
  weight, xmid, ymid, fx, fy, r1, r2, dx, dy, rmax: Single;
  Amount, ifx, ify, ty, tx, new_red, new_green, new_blue, ix, iy: Integer;
  weight_x, weight_y: array[0..1] of Single;
  total_red, total_green, total_blue: Single;
  sli, slo: PLines;
  D: pointer;

begin
  Result := True;
  case BitCount of
    32, 16, 8, 4, 1:
      begin
        Result := False;
        Exit;
      end;
  end;
  Amount := 1;
  xmid := Width / 2;
  ymid := Height / 2;
  rmax := Bmp.Width * Amount;
  for ty := 0 to Pred(Height) do
  begin
    for tx := 0 to Pred(Width) do
    begin
      dx := tx - xmid;
      dy := ty - ymid;
      r1 := Sqrt(dx * dx + dy * dy);
      if r1 = 0 then
      begin
        fx := xmid;
        fy := ymid;
      end
      else
      begin
        r2 := rmax / 2 * (1 / (1 - r1 / rmax) - 1);
        fx := dx * r2 / r1 + xmid;
        fy := dy * r2 / r1 + ymid;
      end;
      ify := Trunc(fy);
      ifx := Trunc(fx);
      if fy >= 0 then
      begin
        weight_y[1] := fy - ify;
        weight_y[0] := 1 - weight_y[1];
      end
      else
      begin
        weight_y[0] := -(fy - ify);
        weight_y[1] := 1 - weight_y[0];
      end;
      if fx >= 0 then
      begin
        weight_x[1] := fx - ifx;
        weight_x[0] := 1 - weight_x[1];
      end
      else
      begin
        weight_x[0] := -(fx - ifx);
        Weight_x[1] := 1 - weight_x[0];
      end;
      if ifx < 0 then
        ifx := Pred(Width) - (-ifx mod Width)
      else
        if ifx > Pred(Width) then
          ifx := ifx mod Width;
      if ify < 0 then
        ify := Pred(Height) - (-ify mod Height)
      else
        if ify > Pred(Height) then
          ify := ify mod Height;
      total_red := 0.0;
      total_green := 0.0;
      total_blue := 0.0;
      for ix := 0 to 1 do
      begin
        for iy := 0 to 1 do
        begin
          if ify + iy < Height then
            sli := ScanLine[ify + iy]
          else
            sli := ScanLine[Height - ify - iy];
          if ifx + ix < Width then
          begin
            new_red := sli^[ifx + ix].r;
            new_green := sli^[ifx + ix].g;
            new_blue := sli^[ifx + ix].b;
          end
          else
          begin
            new_red := sli^[Width - ifx - ix].r;
            new_green := sli^[Width - ifx - ix].g;
            new_blue := sli^[Width - ifx - ix].b;
          end;
          weight := weight_x[ix] * weight_y[iy];
          total_red := total_red + new_red * weight;
          total_green := total_green + new_green * weight;
          total_blue := total_blue + new_blue * weight;
        end;
      end;
      case bitCount of
        24:
          begin
            slo := Bmp.ScanLine[ty];
            slo^[tx].r := Round(total_red);
            slo^[tx].g := Round(total_green);
            slo^[tx].b := Round(total_blue);
          end;
      else
            // You can implement this procedure for 16,8,4,2 and 32 BitCount's DIB
        Exit;
      end;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TDIB.SmoothRotateWrap(Bmp: TDIB; cx, cy: Integer; Degree: Extended): boolean;
var
  weight, Theta, cosTheta, sinTheta, sfrom_y, sfrom_x: Single;
  ifrom_y, ifrom_x, xDiff, yDiff, to_y, to_x: Integer;
  weight_x, weight_y: array[0..1] of Single;
  ix, iy, new_red, new_green, new_blue: Integer;
  total_red, total_green, total_blue: Single;
  sli, slo: PLines;

begin
  Result := True;
  case BitCount of
    32, 16, 8, 4, 1:
      begin
        Result := False;
        Exit;
      end;
  end;
  Theta := -Degree * Pi / 180;
  sinTheta := Sin(Theta);
  cosTheta := Cos(Theta);
  xDiff := (Bmp.Width - Width) div 2;
  yDiff := (Bmp.Height - Height) div 2;
  for to_y := 0 to Pred(Bmp.Height) do
  begin
    for to_x := 0 to Pred(Bmp.Width) do
    begin
      sfrom_x := (cx + (to_x - cx) * cosTheta - (to_y - cy) * sinTheta) - xDiff;
      ifrom_x := Trunc(sfrom_x);
      sfrom_y := (cy + (to_x - cx) * sinTheta + (to_y - cy) * cosTheta) - yDiff;
      ifrom_y := Trunc(sfrom_y);
      if sfrom_y >= 0 then
      begin
        weight_y[1] := sfrom_y - ifrom_y;
        weight_y[0] := 1 - weight_y[1];
      end
      else
      begin
        weight_y[0] := -(sfrom_y - ifrom_y);
        weight_y[1] := 1 - weight_y[0];
      end;
      if sfrom_x >= 0 then
      begin
        weight_x[1] := sfrom_x - ifrom_x;
        weight_x[0] := 1 - weight_x[1];
      end
      else
      begin
        weight_x[0] := -(sfrom_x - ifrom_x);
        Weight_x[1] := 1 - weight_x[0];
      end;
      if ifrom_x < 0 then
        ifrom_x := Pred(Width) - (-ifrom_x mod Width)
      else
        if ifrom_x > Pred(Width) then
          ifrom_x := ifrom_x mod Width;
      if ifrom_y < 0 then
        ifrom_y := Pred(Height) - (-ifrom_y mod Height)
      else
        if ifrom_y > Pred(Height) then
          ifrom_y := ifrom_y mod Height;
      total_red := 0.0;
      total_green := 0.0;
      total_blue := 0.0;
      for ix := 0 to 1 do
      begin
        for iy := 0 to 1 do
        begin
          if ifrom_y + iy < Height then
            sli := ScanLine[ifrom_y + iy]
          else
            sli := ScanLine[Height - ifrom_y - iy];
          if ifrom_x + ix < Width then
          begin
            new_red := sli^[ifrom_x + ix].r;
            new_green := sli^[ifrom_x + ix].g;
            new_blue := sli^[ifrom_x + ix].b;
          end
          else
          begin
            new_red := sli^[Width - ifrom_x - ix].r;
            new_green := sli^[Width - ifrom_x - ix].g;
            new_blue := sli^[Width - ifrom_x - ix].b;
          end;
          weight := weight_x[ix] * weight_y[iy];
          total_red := total_red + new_red * weight;
          total_green := total_green + new_green * weight;
          total_blue := total_blue + new_blue * weight;
        end;
      end;
      case bitCount of
        24:
          begin
            slo := Bmp.ScanLine[to_y];
            slo^[to_x].r := Round(total_red);
            slo^[to_x].g := Round(total_green);
            slo^[to_x].b := Round(total_blue);
          end;
      else
            // You can implement this procedure for 16,8,4,2 and 32 BitCount's DIB
        Exit;
      end;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TDIB.Rotate(Dst: TDIB; cx, cy: Integer; Angle: Double): boolean;
var
  x, y, dx, dy, sdx, sdy, xDiff, yDiff, isinTheta, icosTheta: Integer;
  D, S: Pointer;
  sinTheta, cosTheta, Theta: Double;
  Col: TBGR;
  i: byte;
  color: DWORD;
  P: PByte;

begin
  D := nil;
  S := nil;
  Result := True;
  dst.SetSize(Width, Height, Bitcount);
  dst.Canvas.Brush.Color := clBlack;
  Dst.Canvas.FillRect(Bounds(0, 0, Width, Height));
  case BitCount of
    32, 16:
      begin
        Result := False;
        Exit;
      end;
    8, 4, 1:
      begin
        for i := 0 to 255 do
          Dst.ColorTable[i] := ColorTable[i];
        Dst.UpdatePalette;
      end;
  end;
  Theta := -Angle * Pi / 180;
  sinTheta := Sin(Theta);
  cosTheta := Cos(Theta);
  xDiff := (Dst.Width - Width) div 2;
  yDiff := (Dst.Height - Height) div 2;
  isinTheta := Round(sinTheta * $10000);
  icosTheta := Round(cosTheta * $10000);
  for y := 0 to Pred(Dst.Height) do
  begin
    case BitCount of
      4, 1:
        begin
          D := Dst.ScanLine[y];
          S := ScanLine[y];
        end;
    else
    end;
    sdx := Round(((cx + (-cx) * cosTheta - (y - cy) * sinTheta) - xDiff) * $10000);
    sdy := Round(((cy + (-cy) * sinTheta + (y - cy) * cosTheta) - yDiff) * $10000);
    for x := 0 to Pred(Dst.Width) do
    begin
      dx := (sdx shr 16);
      dy := (sdy shr 16);
      if (dx > -1) and (dx < Width) and (dy > -1) and (dy < Height) then
      begin
        case bitcount of
          8, 24: Dst.pixels[x, y] := Pixels[dx, dy];
          4:
            begin
              pfGetRGB(NowPixelFormat, Pixels[dx, dy], col.r, col.g, col.b);
              color := col.r + col.g + col.b;
              Inc(PByte(S));
              P := @PArrayByte(D)[x shr 1];
              P^ := (P^ and Mask4n[x and 1]) or (color shl Shift4[x and 1]);
            end;
          1:
            begin
              pfGetRGB(NowPixelFormat, Pixels[dx, dy], col.r, col.g, col.b);
              color := col.r + col.g + col.b;
              Inc(PByte(S));
              P := @PArrayByte(D)[X shr 3];
              P^ := (P^ and Mask1n[X and 7]) or (color shl Shift1[X and 7]);
            end;
        end;
      end;
      Inc(sdx, icosTheta);
      Inc(sdy, isinTheta);
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TDIB.GaussianBlur(Bmp: TDIB; Amount: Integer);
var
  i: integer;
begin
  for i := 1 to Amount do
    Bmp.SplitBlur(i);
end;
//--------------------------------------------------------------------------------------------------

procedure TDIB.SplitBlur(Amount: Integer);
var
  Lin1, Lin2: PLines;
  cx, x, y: Integer;
  Buf: array[0..3] of TBGR;
  D: Pointer;

begin
  case Bitcount of
    32, 16, 8, 4, 1: Exit;
  end;
  for y := 0 to Pred(Height) do
  begin
    Lin1 := ScanLine[TrimInt(y + Amount, 0, Pred(Height))];
    Lin2 := ScanLine[TrimInt(y - Amount, 0, Pred(Height))];
    D := ScanLine[y];
    for x := 0 to Pred(Width) do
    begin
      cx := TrimInt(x + Amount, 0, Pred(Width));
      Buf[0] := Lin1[cx];
      Buf[1] := Lin2[cx];
      cx := TrimInt(x - Amount, 0, Pred(Width));
      Buf[2] := Lin1[cx];
      Buf[3] := Lin2[cx];
      PBGR(D)^.b := (Buf[0].b + Buf[1].b + Buf[2].b + Buf[3].b) shr 2;
      PBGR(D)^.g := (Buf[0].g + Buf[1].g + Buf[2].g + Buf[3].g) shr 2;
      PBGR(D)^.r := (Buf[0].r + Buf[1].r + Buf[2].r + Buf[3].r) shr 2;
      Inc(PBGR(D));
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TDIB.Twist(bmp: TDIB; Amount: byte): boolean;
var
  fxmid, fymid: Single;
  txmid, tymid: Single;
  fx, fy: Single;
  tx2, ty2: Single;
  r: Single;
  theta: Single;
  ifx, ify: integer;
  dx, dy: Single;
  OFFSET: Single;
  ty, tx, ix, iy: Integer;
  weight_x, weight_y: array[0..1] of Single;
  weight: Single;
  new_red, new_green, new_blue: Integer;
  total_red, total_green, total_blue: Single;
  sli, slo: PLines;

  function ArcTan2(xt, yt: Single): Single;
  begin
    if xt = 0 then
      if yt > 0 then
        Result := Pi / 2
      else
        Result := -(Pi / 2)
    else begin
      Result := ArcTan(yt / xt);
      if xt < 0 then
        Result := Pi + ArcTan(yt / xt);
    end;
  end;

begin
  Result := True;
  case BitCount of
    32, 16, 8, 4, 1:
      begin
        Result := False;
        Exit;
      end;
  end;
  if Amount = 0 then
    Amount := 1;
  OFFSET := -(Pi / 2);
  dx := Pred(Width);
  dy := Pred(Height);
  r := Sqrt(dx * dx + dy * dy);
  tx2 := r;
  ty2 := r;
  txmid := (Pred(Width)) / 2;
  tymid := (Pred(Height)) / 2;
  fxmid := (Pred(Width)) / 2;
  fymid := (Pred(Height)) / 2;
  if tx2 >= Width then
    tx2 := Pred(Width);
  if ty2 >= Height then
    ty2 := Pred(Height);
  for ty := 0 to Round(ty2) do
  begin
    for tx := 0 to Round(tx2) do
    begin
      dx := tx - txmid;
      dy := ty - tymid;
      r := Sqrt(dx * dx + dy * dy);
      if r = 0 then
      begin
        fx := 0;
        fy := 0;
      end
      else
      begin
        theta := ArcTan2(dx, dy) - r / Amount - OFFSET;
        fx := r * Cos(theta);
        fy := r * Sin(theta);
      end;
      fx := fx + fxmid;
      fy := fy + fymid;
      ify := Trunc(fy);
      ifx := Trunc(fx);
      if fy >= 0 then
      begin
        weight_y[1] := fy - ify;
        weight_y[0] := 1 - weight_y[1];
      end
      else
      begin
        weight_y[0] := -(fy - ify);
        weight_y[1] := 1 - weight_y[0];
      end;
      if fx >= 0 then
      begin
        weight_x[1] := fx - ifx;
        weight_x[0] := 1 - weight_x[1];
      end
      else
      begin
        weight_x[0] := -(fx - ifx);
        Weight_x[1] := 1 - weight_x[0];
      end;
      if ifx < 0 then
        ifx := Pred(Width) - (-ifx mod Width)
      else
        if ifx > Pred(Width) then
          ifx := ifx mod Width;
      if ify < 0 then
        ify := Pred(Height) - (-ify mod Height)
      else
        if ify > Pred(Height) then
          ify := ify mod Height;
      total_red := 0.0;
      total_green := 0.0;
      total_blue := 0.0;
      for ix := 0 to 1 do
      begin
        for iy := 0 to 1 do
        begin
          if ify + iy < Height then
            sli := ScanLine[ify + iy]
          else
            sli := ScanLine[Height - ify - iy];
          if ifx + ix < Width then
          begin
            new_red := sli^[ifx + ix].r;
            new_green := sli^[ifx + ix].g;
            new_blue := sli^[ifx + ix].b;
          end
          else
          begin
            new_red := sli^[Width - ifx - ix].r;
            new_green := sli^[Width - ifx - ix].g;
            new_blue := sli^[Width - ifx - ix].b;
          end;
          weight := weight_x[ix] * weight_y[iy];
          total_red := total_red + new_red * weight;
          total_green := total_green + new_green * weight;
          total_blue := total_blue + new_blue * weight;
        end;
      end;
      case bitCount of
        24:
          begin
            slo := bmp.ScanLine[ty];
            slo^[tx].r := Round(total_red);
            slo^[tx].g := Round(total_green);
            slo^[tx].b := Round(total_blue);
          end;
      else
            // You can implement this procedure for 16,8,4,2 and 32 BitCount's DIB
        Exit;
      end;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TDIB.TrimInt(i, Min, Max: Integer): Integer;
begin
  if i > Max then
    Result := Max
  else
    if i < Min then
      Result := Min
    else
      Result := i;
end;

//--------------------------------------------------------------------------------------------------

function TDIB.IntToByte(i: Integer): Byte;
begin
  if i > 255 then
    Result := 255
  else
    if i < 0 then
      Result := 0
    else
      Result := i;
end;

//--------------------------------------------------------------------------------------------------
// End of these New Special Effect                                                                //
// Please contributes to add effects and filters to this collection                               //
// Please, work to implement 32,16,8,4,2 BitCount's DIB                                           //
// Have fun - Mickey - Good job                                                                   //
//--------------------------------------------------------------------------------------------------

function TDIB.GetAlphaChannel: TDIB;
begin
  RetAlphaChannel(Result);
end;

procedure TDIB.SetAlphaChannel(const Value: TDIB);
begin
  if not AssignAlphaChannel(Value) then
    Exception.Create('Cannot set alphachannel from DIB.');
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
    if (Width <> FDIB.Width) or (Height <> FDIB.Height) then
    begin
      if FCenter then
      begin
        inherited Canvas.StretchDraw(Bounds(-(Width - ClientWidth) div 2,
          -(Height - ClientHeight) div 2, Width, Height), FDIB);
      end else
      begin
        inherited Canvas.StretchDraw(Bounds(0, 0, Width, Height), FDIB);
      end;
    end else
    begin
      if FCenter then
      begin
        inherited Canvas.Draw(-(Width - ClientWidth) div 2, -(Height - ClientHeight) div 2,
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

    if (FViewWidth > 0) or (FViewHeight > 0) then
    begin
      ViewWidth2 := FViewWidth;
      if ViewWidth2 = 0 then ViewWidth2 := FDIB.Width;
      ViewHeight2 := FViewHeight;
      if ViewHeight2 = 0 then ViewHeight2 := FDIB.Height;

      if FAutoStretch then
      begin
        if (ClientWidth < ViewWidth2) or (ClientHeight < ViewHeight2) then
        begin
          r := ViewWidth2 / ClientWidth;
          r2 := ViewHeight2 / ClientHeight;
          if r > r2 then
            r := r2;
          Draw2(Round(r * ClientWidth), Round(r * ClientHeight));
        end else
          Draw2(ViewWidth2, ViewHeight2);
      end else
        Draw2(ViewWidth2, ViewHeight2);
    end else
    begin
      if FAutoStretch then
      begin
        if (FDIB.Width > ClientWidth) or (FDIB.Height > ClientHeight) then
        begin
          r := ClientWidth / FDIB.Width;
          r2 := ClientHeight / FDIB.Height;
          if r > r2 then
            r := r2;
          Draw2(Round(r * FDIB.Width), Round(r * FDIB.Height));
        end else
          Draw2(FDIB.Width, FDIB.Height);
      end else
        if FStretch then
        begin
          if FKeepAspect then
          begin
            r := ClientWidth / FDIB.Width;
            r2 := ClientHeight / FDIB.Height;
            if r > r2 then
              r := r2;
            Draw2(Round(r * FDIB.Width), Round(r * FDIB.Height));
          end else
            Draw2(ClientWidth, ClientHeight);
        end else
          Draw2(FDIB.Width, FDIB.Height);
    end;
  end;
end;

procedure TCustomDXPaintBox.SetAutoStretch(Value: Boolean);
begin
  if FAutoStretch <> Value then
  begin
    FAutoStretch := Value;
    Invalidate;
  end;
end;

procedure TCustomDXPaintBox.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    Invalidate;
  end;
end;

procedure TCustomDXPaintBox.SetDIB(Value: TDIB);
begin
  if FDIB <> Value then
  begin
    FDIB.Assign(Value);
    Invalidate;
  end;
end;

procedure TCustomDXPaintBox.SetKeepAspect(Value: Boolean);
begin
  if Value <> FKeepAspect then
  begin
    FKeepAspect := Value;
    Invalidate;
  end;
end;

procedure TCustomDXPaintBox.SetStretch(Value: Boolean);
begin
  if Value <> FStretch then
  begin
    FStretch := Value;
    Invalidate;
  end;
end;

procedure TCustomDXPaintBox.SetViewWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if Value <> FViewWidth then
  begin
    FViewWidth := Value;
    Invalidate;
  end;
end;

procedure TCustomDXPaintBox.SetViewHeight(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if Value <> FViewHeight then
  begin
    FViewHeight := Value;
    Invalidate;
  end;
end;

{ DXFusion -> }

function PosValue(Value: integer): integer;
begin
  if Value < 0 then result := 0 else result := Value;
end;

procedure TDIB.CreateDIBFromBitmap(const Bitmap: TBitmap);
begin
  {DestDIB := TDIB.Create;}
  SetSize(Bitmap.Width, Bitmap.Height, 24); {always 24}
  Canvas.Draw(0, 0, Bitmap);
end;

procedure TDIB.DrawTo(SrcDIB: TDIB; X, Y, Width, Height,
  SourceX, SourceY: Integer);
begin
  //SrcDIB.Canvas.CopyRect(Bounds(X,Y,Width,Height), Canvas,Bounds(SourceX,SourceY,SrcDIB.Width,SrcDIB.Height));
  DrawOn(SrcDIB.Canvas, Rect(X, Y, Width, Height), Canvas, SourceX, SourceY);
end;

procedure TDIB.DrawTransparent(SrcDIB: TDIB; const X, Y, Width, Height,
  SourceX, SourceY: Integer; const Color: TColor);
var
  i, j: Integer;
  k1, k2: Integer;
  n: Integer;
  p1, p2: PByteArray;

  Startk1, Startk2: Integer;

  StartY: Integer;
  EndY: Integer;

  DestStartY: Integer;
begin
  Startk1 := 3 * SourceX;
  Startk2 := 3 * X;

  DestStartY := Y - SourceY;

  StartY := SourceY;
  EndY := SourceY + Height;

  if (StartY + DestStartY < 0) then
    StartY := -DestStartY;
  if (EndY + DestStartY > Self.Height) then
    EndY := Self.Height - DestStartY;

  if (StartY < 0) then
    StartY := 0;
  if (EndY > SrcDIB.Height) then
    EndY := SrcDIB.Height;

  for j := StartY to EndY - 1 do
  begin
    p1 := Self.Scanline[j + DestStartY];
    p2 := SrcDIB.Scanline[j];

    k1 := Startk1;
    k2 := Startk2;

    for i := SourceX to SourceX + Width - 1 do
    begin
      n := (p2[k1] shl 16) + (p2[k1 + 1] shl 8) + p2[k1 + 2];

      if not (n = Color) then
      begin
        p1[k2] := p2[k1];
        p1[k2 + 1] := p2[k1 + 1];
        p1[k2 + 2] := p2[k1 + 2];
      end;

      k1 := k1 + 3;
      k2 := k2 + 3;
    end;
  end;
end;

procedure TDIB.DrawShadow(SrcDIB: TDIB; X, Y, Width, Height,
  Frame: Integer; FilterMode: TFilterMode);
var
  i, j: Integer;
  p1, p2: PByte;
  FW: Integer;
begin
  FW := Frame * Width;
  for i := 1 to Height - 1 do
  begin
    p1 := Self.Scanline[i + Y];
    p2 := SrcDIB.Scanline[i];
    inc(p1, 3 * (X + 1));
    inc(p2, 3 * (FW + 1));
    for j := 1 to Width - 1 do
    begin
      if (p2^ = 0) then
      begin
        case FilterMode of
          fmNormal, fmMix50: begin
              p1^ := p1^ shr 1; // Blue
              inc(p1);
              p1^ := p1^ shr 1; // Green
              inc(p1);
              p1^ := p1^ shr 1; // Red
              inc(p1);
            end;
          fmMix25: begin
              p1^ := p1^ - p1^ shr 2; // Blue
              inc(p1);
              p1^ := p1^ - p1^ shr 2; // Green
              inc(p1);
              p1^ := p1^ - p1^ shr 2; // Red
              inc(p1);
            end;
          fmMix75: begin
              p1^ := p1^ shr 2; // Blue
              inc(p1);
              p1^ := p1^ shr 2; // Green
              inc(p1);
              p1^ := p1^ shr 2; // Red
              inc(p1);
            end;
        end;
      end else inc(p1, 3); // Not in the loop...
      inc(p2, 3);
    end;
  end;
end;

procedure TDIB.DrawDarken(SrcDIB: TDIB; X, Y, Width, Height,
  Frame: Integer);
var
  frameoffset, i, j: integer;
  p1, p2: pByte;
  XOffset: Integer;
begin
  frameoffset := 3 * (Frame * Width) + 3;
  XOffset := 3 * X + 3;
  for i := 1 to Height - 1 do
  begin
    p1 := Self.Scanline[i + Y];
    p2 := SrcDIB.Scanline[i];
    inc(p1, XOffset);
    inc(p2, frameoffset);
    for j := 1 to Width - 1 do
    begin
      p1^ := (p2^ * p1^) shr 8; // R
      inc(p1);
      inc(p2);
      p1^ := (p2^ * p1^) shr 8; // G
      inc(p1);
      inc(p2);
      p1^ := (p2^ * p1^) shr 8; // B
      inc(p1);
      inc(p2);
    end;
  end;
end;

procedure TDIB.DrawQuickAlpha(SrcDIB: TDIB; const X, Y, Width, Height,
  SourceX, SourceY: Integer; const Color: TColor; FilterMode: TFilterMode);
var
  i, j: Integer;
  k1, k2: Integer;
  n: Integer;
  p1, p2: PByteArray;
  BitSwitch1, BitSwitch2: boolean;

  Startk1, Startk2: Integer;
  StartY: Integer;
  EndY: Integer;

  DestStartY: Integer;
begin
  Startk1 := 3 * SourceX;
  Startk2 := 3 * X;

  DestStartY := Y - SourceY;

  StartY := SourceY;
  EndY := SourceY + Height;

  if (StartY + DestStartY < 0) then
    StartY := -DestStartY;
  if (EndY + DestStartY > Self.Height) then
    EndY := Self.Height - DestStartY;

  if (StartY < 0) then
    StartY := 0;
  if (EndY > SrcDIB.Height) then
    EndY := SrcDIB.Height;

  if Odd(Y) then BitSwitch1 := true else BitSwitch1 := false;
  if Odd(X) then BitSwitch2 := true else BitSwitch2 := false;

  for j := StartY to EndY - 1 do
  begin
    BitSwitch1 := not BitSwitch1;
    p1 := Self.Scanline[j + DestStartY];
    p2 := SrcDIB.Scanline[j];

    k1 := Startk1;
    k2 := Startk2;

    for i := SourceX to SourceX + Width - 1 do
    begin
      BitSwitch2 := not BitSwitch2;

      n := (p2[k1] shl 16) + (p2[k1 + 1] shl 8) + p2[k1 + 2];

      case FilterMode of
        fmNormal, fmMix50: if not (n = Color) and (BitSwitch1 xor BitSwitch2) then
          begin
            p1[k2] := p2[k1];
            p1[k2 + 1] := p2[k1 + 1];
            p1[k2 + 2] := p2[k1 + 2];
          end;
        fmMix25: if not (n = Color) and (BitSwitch1 and BitSwitch2) then
          begin
            p1[k2] := p2[k1];
            p1[k2 + 1] := p2[k1 + 1];
            p1[k2 + 2] := p2[k1 + 2];
          end;
        fmMix75: if not (n = Color) and (BitSwitch1 or BitSwitch2) then
          begin
            p1[k2] := p2[k1];
            p1[k2 + 1] := p2[k1 + 1];
            p1[k2 + 2] := p2[k1 + 2];
          end;
      end;

      k1 := k1 + 3;
      k2 := k2 + 3;
    end;
  end;
end;

procedure TDIB.DrawAdditive(SrcDIB: TDIB; X, Y, Width, Height, Alpha, Frame:
  Integer);
var
  frameoffset, i, j, Wid: integer;
  p1, p2: pByte;
begin
  if (Alpha < 1) or (Alpha > 256) then Exit;
  Wid := Width shl 1 + Width;
  frameoffset := Wid * Frame;
  for i := 1 to Height - 1 do
  begin
    if (i + Y) > (Self.Height - 1) then Break; //add 25.5.2004 JB.
    p1 := Self.Scanline[i + Y];
    p2 := SrcDIB.Scanline[i];
    inc(p1, X shl 1 + X + 3);
    inc(p2, frameoffset + 3);
    for j := 3 to Wid - 4 do
    begin
      inc(p1^, (Alpha - p1^) * p2^ shr 8);
      inc(p1);
      inc(p2);
    end;
  end;
end;

procedure TDIB.DrawTranslucent(SrcDIB: TDIB; const X, Y, Width, Height,
  SourceX, SourceY: Integer; const Color: TColor);
var
  i, j: Integer;
  k1, k2: Integer;
  n: Integer;
  p1, p2: PByteArray;

  Startk1, Startk2: Integer;
  StartY: Integer;
  EndY: Integer;

  DestStartY: Integer;
begin
  Startk1 := 3 * SourceX;
  Startk2 := 3 * X;

  DestStartY := Y - SourceY;

  StartY := SourceY;
  EndY := SourceY + Height;

  if (StartY + DestStartY < 0) then
    StartY := -DestStartY;
  if (EndY + DestStartY > Self.Height) then
    EndY := Self.Height - DestStartY;

  if (StartY < 0) then
    StartY := 0;
  if (EndY > SrcDIB.Height) then
    EndY := SrcDIB.Height;

  for j := StartY to EndY - 1 do
  begin
    p1 := Self.Scanline[j + DestStartY];
    p2 := SrcDIB.Scanline[j];

    k1 := Startk1;
    k2 := Startk2;

    for i := SourceX to SourceX + Width - 1 do
    begin
      n := (p2[k1] shl 16) + (p2[k1 + 1] shl 8) + p2[k1 + 2];

      if not (n = Color) then
      begin
        p1[k2] := (p1[k2] + p2[k1]) shr 1;
        p1[k2 + 1] := (p1[k2 + 1] + p2[k1 + 1]) shr 1;
        p1[k2 + 2] := (p1[k2 + 2] + p2[k1 + 2]) shr 1;
      end;

      k1 := k1 + 3;
      k2 := k2 + 3;
    end;
  end;
end;

procedure TDIB.DrawAlpha(SrcDIB: TDIB; const X, Y, Width, Height,
  SourceX, SourceY, Alpha: Integer; const Color: TColor);
var
  i, j: Integer;
  k1, k2: Integer;
  n: Integer;
  p1, p2: PByteArray;

  Startk1, Startk2: Integer;
  StartY: Integer;
  EndY: Integer;

  DestStartY: Integer;
begin
  Startk1 := 3 * SourceX;
  Startk2 := 3 * x;

  DestStartY := Y - SourceY;

  StartY := SourceY;
  EndY := SourceY + Height;

  if (EndY + DestStartY > Self.Height) then
    EndY := Self.Height - DestStartY;

  if (EndY > SrcDIB.Height) then
    EndY := SrcDIB.Height;

  if (StartY < 0) then
    StartY := 0;

  if (StartY + DestStartY < 0) then
    StartY := DestStartY;

  for j := StartY to EndY - 1 do
  begin
    p1 := Self.Scanline[j + DestStartY];
    p2 := SrcDIB.Scanline[j];

    k1 := Startk1;
    k2 := Startk2;

    for i := SourceX to SourceX + Width - 1 do
    begin
      n := (p2[k1] shl 16) + (p2[k1 + 1] shl 8) + p2[k1 + 2];

      if not (n = Color) then
      begin
        p1[k2] := (p1[k2] * (256 - Alpha) + p2[k1] * Alpha) shr 8;
        p1[k2 + 1] := (p1[k2 + 1] * (256 - Alpha) + p2[k1 + 1] * Alpha) shr 8;
        p1[k2 + 2] := (p1[k2 + 2] * (256 - Alpha) + p2[k1 + 2] * Alpha) shr 8;
      end;

      k1 := k1 + 3;
      k2 := k2 + 3;
    end;
  end;
end;

procedure TDIB.DrawAlphaMask(SrcDIB, MaskDIB: TDIB; const X, Y,
  Width, Height, SourceX, SourceY: Integer);
var
  i, j: Integer;
  k1, k2, k3: Integer;
  p1, p2, p3: PByteArray;

  Startk1, Startk2: Integer;
  StartY: Integer;
  EndY: Integer;

  DestStartY: Integer;
begin
  Startk1 := 3 * SourceX;
  Startk2 := 3 * x;

  DestStartY := Y - SourceY;

  StartY := SourceY;
  EndY := SourceY + Height;

  if (EndY + DestStartY > Self.Height) then
    EndY := Self.Height - DestStartY;

  if (EndY > SrcDIB.Height) then
    EndY := SrcDIB.Height;

  if (StartY < 0) then
    StartY := 0;

  if (StartY + DestStartY < 0) then
    StartY := DestStartY;

  for j := StartY to EndY - 1 do
  begin
    p1 := Self.Scanline[j + DestStartY];
    p2 := SrcDIB.Scanline[j];
    p3 := MaskDIB.Scanline[j];

    k1 := Startk1;
    k2 := Startk2;
    k3 := 0;

    for i := SourceX to SourceX + Width - 1 do
    begin
      p1[k2] := (p1[k2] * (256 - p3[k3]) + p2[k1] * p3[k3]) shr 8;
      p1[k2 + 1] := (p1[k2 + 1] * (256 - p3[k3]) + p2[k1 + 1] * p3[k3]) shr 8;
      p1[k2 + 2] := (p1[k2 + 2] * (256 - p3[k3]) + p2[k1 + 2] * p3[k3]) shr 8;

      k1 := k1 + 3;
      k2 := k2 + 3;
      k3 := k3 + 3;
    end;
  end;
end;

procedure TDIB.DrawMorphed(SrcDIB: TDIB; const X, Y, Width, Height,
  SourceX, SourceY: Integer; const Color: TColor);
var
  i, j, r, g, b: Integer;
  k1, k2: Integer;
  n: Integer;
  p1, p2: PByteArray;

  Startk1, Startk2: Integer;
  StartY: Integer;
  EndY: Integer;

  DestStartY: Integer;
begin
  Startk1 := 3 * SourceX;
  Startk2 := 3 * x;

  DestStartY := Y - SourceY;

  StartY := SourceY;
  EndY := SourceY + Height;

  if (EndY + DestStartY > Self.Height) then
    EndY := Self.Height - DestStartY;

  if (EndY > SrcDIB.Height) then
    EndY := SrcDIB.Height;

  if (StartY < 0) then
    StartY := 0;

  if (StartY + DestStartY < 0) then
    StartY := DestStartY;

  r := 0;
  g := 0;
  b := 0;

  for j := StartY to EndY - 1 do
  begin
    p1 := Self.Scanline[j + DestStartY];
    p2 := SrcDIB.Scanline[j];

    k1 := Startk1;
    k2 := Startk2;

    for i := SourceX to SourceX + Width - 1 do
    begin
      n := (p2[k1] shl 16) + (p2[k1 + 1] shl 8) + p2[k1 + 2];

      if Random(100) < 50 then
      begin
        b := p1[k2];
        g := p1[k2 + 1];
        r := p1[k2 + 2];
      end;

      if not (n = Color) then
      begin
        p1[k2] := b;
        p1[k2 + 1] := g;
        p1[k2 + 2] := r;
      end;

      k1 := k1 + 3;
      k2 := k2 + 3;
    end;
  end;
end;

procedure TDIB.DrawMono(SrcDIB: TDIB; const X, Y, Width, Height,
  SourceX, SourceY: integer; const TransColor, ForeColor, BackColor: TColor);
var
  i, j, r1, g1, b1, r2, g2, b2: Integer;
  k1, k2: Integer;
  n: Integer;
  p1, p2: PByteArray;
  Startk1, Startk2, StartY, EndY, DestStartY: Integer;
begin
  Startk1 := 3 * SourceX;
  Startk2 := 3 * x;

  DestStartY := Y - SourceY;

  StartY := SourceY;
  EndY := SourceY + Height;

  if (EndY + DestStartY > Self.Height) then
    EndY := Self.Height - DestStartY;

  if (EndY > SrcDIB.Height) then
    EndY := SrcDIB.Height;

  if (StartY < 0) then
    StartY := 0;

  if (StartY + DestStartY < 0) then
    StartY := DestStartY;

  r1 := GetRValue(BackColor);
  g1 := GetGValue(BackColor);
  b1 := GetBValue(BackColor);

  r2 := GetRValue(ForeColor);
  g2 := GetGValue(ForeColor);
  b2 := GetBValue(ForeColor);


  for j := StartY to EndY - 1 do
  begin
    p1 := Self.Scanline[j + DestStartY];
    p2 := SrcDIB.Scanline[j];

    k1 := Startk1;
    k2 := Startk2;

    for i := SourceX to SourceX + Width - 1 do
    begin
      n := (p2[k1] shl 16) + (p2[k1 + 1] shl 8) + p2[k1 + 2];

      if (n = TransColor) then
      begin
        p1[k2] := b1;
        p1[k2 + 1] := g1;
        p1[k2 + 2] := r1;
      end else
      begin
        p1[k2] := b2;
        p1[k2 + 1] := g2;
        p1[k2 + 2] := r2;
      end;

      k1 := k1 + 3;
      k2 := k2 + 3;
    end;
  end;
end;

procedure TDIB.Draw3x3Matrix(SrcDIB: TDIB; Setting: TMatrixSetting);
var i, j, k: integer;
  p1, p2, p3, p4: PByteArray;
begin
  for i := 1 to SrcDIB.Height - 2 do
  begin
    p1 := SrcDIB.ScanLine[i - 1];
    p2 := SrcDIB.ScanLine[i];
    p3 := SrcDIB.ScanLine[i + 1];
    p4 := Self.ScanLine[i];
    for j := 3 to 3 * SrcDIB.Width - 4 do
    begin
      k := (p1[j - 3] * Setting[0] + p1[j] * Setting[1] + p1[j + 3] * Setting[2] +
        p2[j - 3] * Setting[3] + p2[j] * Setting[4] + p2[j + 3] * Setting[5] +
        p3[j - 3] * Setting[6] + p3[j] * Setting[7] + p3[j + 3] * Setting[8])
        div Setting[9];
      if k < 0 then k := 0;
      if k > 255 then k := 255;
      p4[j] := k;
    end;
  end;
end;

procedure TDIB.DrawAntialias(SrcDIB: TDIB);
var i, j, k, l, m: integer;
  p1, p2, p3: PByteArray;
begin
  for i := 1 to Self.Height - 1 do
  begin
    k := i shl 1;
    p1 := SrcDIB.Scanline[k];
    p2 := SrcDIB.Scanline[k + 1];
    p3 := Self.Scanline[i];
    for j := 1 to Self.Width - 1 do
    begin
      m := 3 * j;
      l := m shl 1;
      p3[m] := (p1[l] + p1[l + 3] + p2[l] + p2[l + 3]) shr 2;
      p3[m + 1] := (p1[l + 1] + p1[l + 4] + p2[l + 1] + p2[l + 4]) shr 2;
      p3[m + 2] := (p1[l + 2] + p1[l + 5] + p2[l + 2] + p2[l + 5]) shr 2;
    end;
  end;
end;

procedure TDIB.FilterLine(X1, Y1, X2, Y2: Integer; Color: TColor;
  FilterMode: TFilterMode);
var
  i, j: integer;
  t: TColor;
  r1, g1, b1, r2, g2, b2: integer;
begin
  j := ROUND(Sqrt(Sqr(ABS(X2 - X1)) + Sqr(ABS(Y2 - Y1))));
  if j < 1 then Exit;

  r1 := GetRValue(Color);
  g1 := GetGValue(Color);
  b1 := GetBValue(Color);

  for i := 0 to j do
  begin
    t := Self.Pixels[X1 + ((X2 - X1) * i div j), Y1 + ((Y2 - Y1) * i div j)];
    r2 := GetRValue(t);
    g2 := GetGValue(t);
    b2 := GetBValue(t);
    case FilterMode of
      fmNormal: t := RGB(r1 + (((256 - r1) * r2) shr 8),
          g1 + (((256 - g1) * g2) shr 8),
          b1 + (((256 - b1) * b2) shr 8));
      fmMix25: t := RGB((r1 + r2 * 3) shr 2, (g1 + g2 * 3) shr 2, (b1 + b2 * 3) shr 2);
      fmMix50: t := RGB((r1 + r2) shr 1, (g1 + g2) shr 1, (b1 + b2) shr 1);
      fmMix75: t := RGB((r1 * 3 + r2) shr 2, (g1 * 3 + g2) shr 2, (b1 * 3 + b2) shr 2);
    end;
    Self.Pixels[X1 + ((X2 - X1) * i div j), Y1 + ((Y2 - Y1) * i div j)] := t;
  end;
end;

procedure TDIB.FilterRect(X, Y, Width, Height: Integer;
  Color: TColor; FilterMode: TFilterMode);
var
  i, j, r, g, b, C1: integer;
  p1, p2, p3: pByte;
begin
  r := GetRValue(Color);
  g := GetGValue(Color);
  b := GetBValue(Color);

  for i := 0 to Height - 1 do
  begin
    p1 := Self.Scanline[i + Y];
    Inc(p1, (3 * X));
    for j := 0 to Width - 1 do
    begin
      case FilterMode of
        fmNormal: begin
            p2 := p1;
            Inc(p2);
            p3 := p2;
            Inc(p3);
            C1 := (p1^ + p2^ + p3^) div 3;

            p1^ := (C1 * b) shr 8;
            Inc(p1);
            p1^ := (C1 * g) shr 8;
            Inc(p1);
            p1^ := (C1 * r) shr 8;
            Inc(p1);
          end;
        fmMix25: begin
            p1^ := (3 * p1^ + b) shr 2;
            Inc(p1);
            p1^ := (3 * p1^ + g) shr 2;
            Inc(p1);
            p1^ := (3 * p1^ + r) shr 2;
            Inc(p1);
          end;
        fmMix50: begin
            p1^ := (p1^ + b) shr 1;
            Inc(p1);
            p1^ := (p1^ + g) shr 1;
            Inc(p1);
            p1^ := (p1^ + r) shr 1;
            Inc(p1);
          end;
        fmMix75: begin
            p1^ := (p1^ + 3 * b) shr 2;
            Inc(p1);
            p1^ := (p1^ + 3 * g) shr 2;
            Inc(p1);
            p1^ := (p1^ + 3 * r) shr 2;
            Inc(p1);
          end;
      end;
    end;
  end;
end;

procedure TDIB.InitLight(Count, Detail: Integer);
var
  i, j: Integer;
begin
  LG_COUNT := Count;
  LG_DETAIL := Detail;

  for i := 0 to 255 do // Build Lightning LUT
    for j := 0 to 255 do
      FLUTDist[i, j] := ROUND(Sqrt(Sqr(i * 10) + Sqr(j * 10)));
end;

procedure TDIB.DrawLights(FLight: TLightArray;
  AmbientLight: TColor);
var
  i, j, l, m, n, o, q, D1, D2, R, G, B, AR, AG, AB: integer;
  P: array{$IFDEF DelphiX_Delphi3} [0..4096]{$ENDIF} of PByteArray;
begin
{$IFNDEF DelphiX_Delphi3}
  SetLength(P, LG_DETAIL);
{$ENDIF}
  AR := GetRValue(AmbientLight);
  AG := GetGValue(AmbientLight);
  AB := GetBValue(AmbientLight);

  for i := (Self.Height div (LG_DETAIL + 1)) downto 1 do
  begin
    for o := 0 to LG_DETAIL do
      P[o] := Self.Scanline[(LG_DETAIL + 1) * i - o];

    for j := (Self.Width div (LG_DETAIL + 1)) downto 1 do
    begin
      R := AR;
      G := AG;
      B := AB;

      for l := LG_COUNT - 1 downto 0 do // Check the lightsources
      begin
        D1 := ABS(j * (LG_DETAIL + 1) - FLight[l].X) div FLight[l].Size1;
        D2 := ABS(i * (LG_DETAIL + 1) - FLight[l].Y) div FLight[l].Size2;
        if D1 > 255 then D1 := 255;
        if D2 > 255 then D2 := 255;

        m := 255 - FLUTDist[D1, D2];
        if m < 0 then m := 0;

        Inc(R, (PosValue(GetRValue(FLight[l].Color) - R) * m shr 8));
        Inc(G, (PosValue(GetGValue(FLight[l].Color) - G) * m shr 8));
        Inc(B, (PosValue(GetBValue(FLight[l].Color) - B) * m shr 8));
      end;

      for q := LG_DETAIL downto 0 do
      begin
        n := 3 * (j * (LG_DETAIL + 1) - q);

        for o := LG_DETAIL downto 0 do
        begin
          P[o][n] := (P[o][n] * B) shr 8;
          P[o][n + 1] := (P[o][n + 1] * G) shr 8;
          P[o][n + 2] := (P[o][n + 2] * R) shr 8;
        end;
      end;
    end;
  end;
{$IFNDEF DelphiX_Delphi3}
  SetLength(P, 0);
{$ENDIF}
end;

procedure TDIB.DrawOn(SrcCanvas: TCanvas; Dest: TRect; DestCanvas: TCanvas; Xsrc, Ysrc: Integer);
{procedure is supplement of original TDIBUltra function}
begin
  if not AsSigned(SrcCanvas) then Exit;
  if (Xsrc < 0) then
  begin
    Dec(Dest.Left, Xsrc);
    Inc(Dest.Right {Width }, Xsrc);
    Xsrc := 0
  end;
  if (Ysrc < 0) then
  begin
    Dec(Dest.Top, Ysrc);
    Inc(Dest.Bottom {Height}, Ysrc);
    Ysrc := 0
  end;
  BitBlt(DestCanvas.Handle, Dest.Left, Dest.Top, Dest.Right, Dest.Bottom, SrcCanvas.Handle, Xsrc, Ysrc, SRCCOPY);
end;

{ DXFusion <- }

{ added effect for DIB }

function IntToByte(i: Integer): Byte;
begin
  if i > 255 then Result := 255
  else if i < 0 then Result := 0
  else Result := i;
end;

{standalone routine}

procedure TDIB.Darkness(Amount: integer);
var
  p0: pbytearray;
  r, g, b, x, y: Integer;
begin
  if Self.BitCount <> 24 then Exit;
  for y := 0 to Self.Height - 1 do begin
    p0 := Self.ScanLine[y];
    for x := 0 to Self.Width - 1 do begin
      r := p0[x * 3];
      g := p0[x * 3 + 1];
      b := p0[x * 3 + 2];
      p0[x * 3] := IntToByte(r - ((r) * Amount) div 255);
      p0[x * 3 + 1] := IntToByte(g - ((g) * Amount) div 255);
      p0[x * 3 + 2] := IntToByte(b - ((b) * Amount) div 255);
    end;
  end;
end;

function TrimInt(i, Min, Max: Integer): Integer;
begin
  if i > Max then Result := Max
  else if i < Min then Result := Min
  else Result := i;
end;

procedure TDIB.DoSmoothRotate(Src: TDIB; cx, cy: Integer;
  Angle: Extended);
type
  TFColor = record b, g, r: Byte; end;
var
  Top, Bottom, Left, Right, eww, nsw, fx, fy, wx, wy: Extended;
  cAngle, sAngle: Double;
  xDiff, yDiff, ifx, ify, px, py, ix, iy, x, y: Integer;
  nw, ne, sw, se: TFColor;
  P1, P2, P3: Pbytearray;
begin
  Angle := angle;
  Angle := -Angle * Pi / 180;
  sAngle := Sin(Angle);
  cAngle := Cos(Angle);
  xDiff := (Self.Width - Src.Width) div 2;
  yDiff := (Self.Height - Src.Height) div 2;
  for y := 0 to Self.Height - 1 do begin
    P3 := Self.scanline[y];
    py := 2 * (y - cy) + 1;
    for x := 0 to Self.Width - 1 do begin
      px := 2 * (x - cx) + 1;
      fx := (((px * cAngle - py * sAngle) - 1) / 2 + cx) - xDiff;
      fy := (((px * sAngle + py * cAngle) - 1) / 2 + cy) - yDiff;
      ifx := Round(fx);
      ify := Round(fy);

      if (ifx > -1) and (ifx < Src.Width) and (ify > -1) and (ify < Src.Height) then begin
        eww := fx - ifx;
        nsw := fy - ify;
        iy := TrimInt(ify + 1, 0, Src.Height - 1);
        ix := TrimInt(ifx + 1, 0, Src.Width - 1);
        P1 := Src.scanline[ify];
        P2 := Src.scanline[iy];
        nw.r := P1[ifx * 3];
        nw.g := P1[ifx * 3 + 1];
        nw.b := P1[ifx * 3 + 2];
        ne.r := P1[ix * 3];
        ne.g := P1[ix * 3 + 1];
        ne.b := P1[ix * 3 + 2];
        sw.r := P2[ifx * 3];
        sw.g := P2[ifx * 3 + 1];
        sw.b := P2[ifx * 3 + 2];
        se.r := P2[ix * 3];
        se.g := P2[ix * 3 + 1];
        se.b := P2[ix * 3 + 2];

        Top := nw.b + eww * (ne.b - nw.b);
        Bottom := sw.b + eww * (se.b - sw.b);
        P3[x * 3 + 2] := IntToByte(Round(Top + nsw * (Bottom - Top)));

        Top := nw.g + eww * (ne.g - nw.g);
        Bottom := sw.g + eww * (se.g - sw.g);
        P3[x * 3 + 1] := IntToByte(Round(Top + nsw * (Bottom - Top)));

        Top := nw.r + eww * (ne.r - nw.r);
        Bottom := sw.r + eww * (se.r - sw.r);
        P3[x * 3] := IntToByte(Round(Top + nsw * (Bottom - Top)));
      end;
    end;
  end;
end;

//----------------------
//-------------------------
//----------------------

procedure TDIB.DoInvert;
  procedure PicInvert(src: TDIB);
  var w, h, x, y: integer;
    p: pbytearray;
  begin
    w := src.width;
    h := src.height;
    src.BitCount := 24;
    for y := 0 to h - 1 do
    begin
      p := src.scanline[y];
      for x := 0 to w - 1 do
      begin
        p[x * 3] := not p[x * 3];
        p[x * 3 + 1] := not p[x * 3 + 1];
        p[x * 3 + 2] := not p[x * 3 + 2];
      end;
    end;
  end;
begin
  PicInvert(Self);
end;

procedure TDIB.DoAddColorNoise(Amount: Integer);
  procedure AddColorNoise(var clip: TDIB; Amount: Integer);
  var
    p0: pbytearray;
    x, y, r, g, b: Integer;
  begin
    for y := 0 to clip.Height - 1 do
    begin
      p0 := clip.ScanLine[y];
      for x := 0 to clip.Width - 1 do
      begin
        r := p0[x * 3] + (Random(Amount) - (Amount shr 1));
        g := p0[x * 3 + 1] + (Random(Amount) - (Amount shr 1));
        b := p0[x * 3 + 2] + (Random(Amount) - (Amount shr 1));
        p0[x * 3] := IntToByte(r);
        p0[x * 3 + 1] := IntToByte(g);
        p0[x * 3 + 2] := IntToByte(b);
      end;
    end;
  end;
var BB: TDIB;
begin
  BB := TDIB.Create;
  BB.BitCount := 24;
  BB.Assign(Self);
  AddColorNoise(bb, Amount);
  Self.Assign(BB);
  BB.Free;
end;

procedure TDIB.DoAddMonoNoise(Amount: Integer);
  procedure _AddMonoNoise(var clip: TDIB; Amount: Integer);
  var
    p0: pbytearray;
    x, y, a, r, g, b: Integer;
  begin
    for y := 0 to clip.Height - 1 do
    begin
      p0 := clip.scanline[y];
      for x := 0 to clip.Width - 1 do
      begin
        a := Random(Amount) - (Amount shr 1);
        r := p0[x * 3] + a;
        g := p0[x * 3 + 1] + a;
        b := p0[x * 3 + 2] + a;
        p0[x * 3] := IntToByte(r);
        p0[x * 3 + 1] := IntToByte(g);
        p0[x * 3 + 2] := IntToByte(b);
      end;
    end;
  end;
var BB: TDIB;
begin
  BB := TDIB.Create;
  BB.BitCount := 24;
  BB.Assign(Self);
  _AddMonoNoise(bb, Amount);
  Self.Assign(BB);
  BB.Free;
end;

procedure TDIB.DoAntiAlias;
  procedure AntiAlias(clip: TDIB);
    procedure AntiAliasRect(clip: TDIB; XOrigin, YOrigin, XFinal, YFinal: Integer);
    var Memo, x, y: Integer; (* Composantes primaires des points environnants *)
      p0, p1, p2: pbytearray;
    begin
      if XFinal < XOrigin then begin Memo := XOrigin; XOrigin := XFinal; XFinal := Memo; end; (* Inversion des valeurs   *)
      if YFinal < YOrigin then begin Memo := YOrigin; YOrigin := YFinal; YFinal := Memo; end; (* si diff‚rence n‚gative*)
      XOrigin := max(1, XOrigin);
      YOrigin := max(1, YOrigin);
      XFinal := min(clip.width - 2, XFinal);
      YFinal := min(clip.height - 2, YFinal);
      clip.BitCount := 24;
      for y := YOrigin to YFinal do begin
        p0 := clip.ScanLine[y - 1];
        p1 := clip.scanline[y];
        p2 := clip.ScanLine[y + 1];
        for x := XOrigin to XFinal do begin
          p1[x * 3] := (p0[x * 3] + p2[x * 3] + p1[(x - 1) * 3] + p1[(x + 1) * 3]) div 4;
          p1[x * 3 + 1] := (p0[x * 3 + 1] + p2[x * 3 + 1] + p1[(x - 1) * 3 + 1] + p1[(x + 1) * 3 + 1]) div 4;
          p1[x * 3 + 2] := (p0[x * 3 + 2] + p2[x * 3 + 2] + p1[(x - 1) * 3 + 2] + p1[(x + 1) * 3 + 2]) div 4;
        end;
      end;
    end;
  begin
    AntiAliasRect(clip, 0, 0, clip.width, clip.height);
  end;
begin
  AntiAlias(Self);
end;

procedure TDIB.DoContrast(Amount: Integer);
  procedure _Contrast(var clip: TDIB; Amount: Integer);
  var
    p0: pbytearray;
    rg, gg, bg, r, g, b, x, y: Integer;
  begin
    for y := 0 to clip.Height - 1 do
    begin
      p0 := clip.scanline[y];
      for x := 0 to clip.Width - 1 do
      begin
        r := p0[x * 3];
        g := p0[x * 3 + 1];
        b := p0[x * 3 + 2];
        rg := (Abs(127 - r) * Amount) div 255;
        gg := (Abs(127 - g) * Amount) div 255;
        bg := (Abs(127 - b) * Amount) div 255;
        if r > 127 then r := r + rg else r := r - rg;
        if g > 127 then g := g + gg else g := g - gg;
        if b > 127 then b := b + bg else b := b - bg;
        p0[x * 3] := IntToByte(r);
        p0[x * 3 + 1] := IntToByte(g);
        p0[x * 3 + 2] := IntToByte(b);
      end;
    end;
  end;
var BB: TDIB;
begin
  BB := TDIB.Create;
  BB.BitCount := 24;
  BB.Assign(Self);
  _Contrast(bb, Amount);
  Self.Assign(BB);
  BB.Free;
end;

procedure TDIB.DoFishEye(Amount: Integer);
  procedure _FishEye(var Bmp, Dst: TDIB; Amount: Extended);
  var
    xmid, ymid: Single;
    fx, fy: Single;
    r1, r2: Single;
    ifx, ify: integer;
    dx, dy: Single;
    rmax: Single;
    ty, tx: Integer;
    weight_x, weight_y: array[0..1] of Single;
    weight: Single;
    new_red, new_green: Integer;
    new_blue: Integer;
    total_red, total_green: Single;
    total_blue: Single;
    ix, iy: Integer;
    sli, slo: PByteArray;
  begin
    xmid := Bmp.Width / 2;
    ymid := Bmp.Height / 2;
    rmax := Dst.Width * Amount;

    for ty := 0 to Dst.Height - 1 do begin
      for tx := 0 to Dst.Width - 1 do begin
        dx := tx - xmid;
        dy := ty - ymid;
        r1 := Sqrt(dx * dx + dy * dy);
        if r1 = 0 then begin
          fx := xmid;
          fy := ymid;
        end
        else begin
          r2 := rmax / 2 * (1 / (1 - r1 / rmax) - 1);
          fx := dx * r2 / r1 + xmid;
          fy := dy * r2 / r1 + ymid;
        end;
        ify := Trunc(fy);
        ifx := Trunc(fx);
        // Calculate the weights.
        if fy >= 0 then begin
          weight_y[1] := fy - ify;
          weight_y[0] := 1 - weight_y[1];
        end else begin
          weight_y[0] := -(fy - ify);
          weight_y[1] := 1 - weight_y[0];
        end;
        if fx >= 0 then begin
          weight_x[1] := fx - ifx;
          weight_x[0] := 1 - weight_x[1];
        end else begin
          weight_x[0] := -(fx - ifx);
          Weight_x[1] := 1 - weight_x[0];
        end;

        if ifx < 0 then
          ifx := Bmp.Width - 1 - (-ifx mod Bmp.Width)
        else if ifx > Bmp.Width - 1 then
          ifx := ifx mod Bmp.Width;
        if ify < 0 then
          ify := Bmp.Height - 1 - (-ify mod Bmp.Height)
        else if ify > Bmp.Height - 1 then
          ify := ify mod Bmp.Height;

        total_red := 0.0;
        total_green := 0.0;
        total_blue := 0.0;
        for ix := 0 to 1 do begin
          for iy := 0 to 1 do begin
            if ify + iy < Bmp.Height then
              sli := Bmp.scanline[ify + iy]
            else
              sli := Bmp.scanline[Bmp.Height - ify - iy];
            if ifx + ix < Bmp.Width then begin
              new_red := sli[(ifx + ix) * 3];
              new_green := sli[(ifx + ix) * 3 + 1];
              new_blue := sli[(ifx + ix) * 3 + 2];
            end
            else begin
              new_red := sli[(Bmp.Width - ifx - ix) * 3];
              new_green := sli[(Bmp.Width - ifx - ix) * 3 + 1];
              new_blue := sli[(Bmp.Width - ifx - ix) * 3 + 2];
            end;
            weight := weight_x[ix] * weight_y[iy];
            total_red := total_red + new_red * weight;
            total_green := total_green + new_green * weight;
            total_blue := total_blue + new_blue * weight;
          end;
        end;
        slo := Dst.scanline[ty];
        slo[tx * 3] := Round(total_red);
        slo[tx * 3 + 1] := Round(total_green);
        slo[tx * 3 + 2] := Round(total_blue);

      end;
    end;
  end;
var BB1, BB2: TDIB;
begin
  BB1 := TDIB.Create;
  BB1.BitCount := 24;
  BB1.Assign(Self);
  BB2 := TDIB.Create;
  BB2.BitCount := 24;
  BB2.Assign(BB1);
  _FishEye(BB1, BB2, Amount);
  Self.Assign(BB2);
  BB1.Free;
  BB2.Free;
end;

procedure TDIB.DoGrayScale;
  procedure GrayScale(var clip: TDIB);
  var
    p0: pbytearray;
    Gray, x, y: Integer;
  begin
    for y := 0 to clip.Height - 1 do begin
      p0 := clip.scanline[y];
      for x := 0 to clip.Width - 1 do begin
        Gray := Round(p0[x * 3] * 0.3 + p0[x * 3 + 1] * 0.59 + p0[x * 3 + 2] * 0.11);
        p0[x * 3] := Gray;
        p0[x * 3 + 1] := Gray;
        p0[x * 3 + 2] := Gray;
      end;
    end;
  end;
var BB: TDIB;
begin
  BB := TDIB.Create;
  BB.BitCount := 24;
  BB.Assign(Self);
  GrayScale(BB);
  Self.Assign(BB);
  BB.Free;
end;

procedure TDIB.DoLightness(Amount: Integer);
  procedure _Lightness(var clip: TDIB; Amount: Integer);
  var
    p0: pbytearray;
    r, g, b, x, y: Integer;
  begin
    for y := 0 to clip.Height - 1 do begin
      p0 := clip.scanline[y];
      for x := 0 to clip.Width - 1 do begin
        r := p0[x * 3];
        g := p0[x * 3 + 1];
        b := p0[x * 3 + 2];
        p0[x * 3] := IntToByte(r + ((255 - r) * Amount) div 255);
        p0[x * 3 + 1] := IntToByte(g + ((255 - g) * Amount) div 255);
        p0[x * 3 + 2] := IntToByte(b + ((255 - b) * Amount) div 255);
      end;
    end;
  end;
var BB: TDIB;
begin
  BB := TDIB.Create;
  BB.BitCount := 24;
  BB.Assign(Self);
  _Lightness(BB, Amount);
  Self.Assign(BB);
  BB.Free;
end;

procedure TDIB.DoDarkness(Amount: Integer);
var BB: TDIB;
begin
  BB := TDIB.Create;
  BB.BitCount := 24;
  BB.Assign(Self);
  BB.Darkness(Amount);
  Self.Assign(BB);
  BB.Free;
end;

procedure TDIB.DoSaturation(Amount: Integer);
  procedure _Saturation(var clip: TDIB; Amount: Integer);
  var
    p0: pbytearray;
    Gray, r, g, b, x, y: Integer;
  begin
    for y := 0 to clip.Height - 1 do begin
      p0 := clip.scanline[y];
      for x := 0 to clip.Width - 1 do begin
        r := p0[x * 3];
        g := p0[x * 3 + 1];
        b := p0[x * 3 + 2];
        Gray := (r + g + b) div 3;
        p0[x * 3] := IntToByte(Gray + (((r - Gray) * Amount) div 255));
        p0[x * 3 + 1] := IntToByte(Gray + (((g - Gray) * Amount) div 255));
        p0[x * 3 + 2] := IntToByte(Gray + (((b - Gray) * Amount) div 255));
      end;
    end;
  end;
var BB: TDIB;
begin
  BB := TDIB.Create;
  BB.BitCount := 24;
  BB.Assign(Self);
  _Saturation(BB, Amount);
  Self.Assign(BB);
  BB.Free;
end;

procedure TDIB.DoSplitBlur(Amount: Integer);
  {NOTE: For a gaussian blur is amount 3}
  procedure _SplitBlur(var clip: TDIB; Amount: integer);
  var
    p0, p1, p2: pbytearray;
    cx, x, y: Integer;
    Buf: array[0..3, 0..2] of byte;
  begin
    if Amount = 0 then Exit;
    for y := 0 to clip.Height - 1 do begin
      p0 := clip.scanline[y];
      if y - Amount < 0 then p1 := clip.scanline[y]
      else {y-Amount>0} p1 := clip.ScanLine[y - Amount];
      if y + Amount < clip.Height then p2 := clip.ScanLine[y + Amount]
      else {y+Amount>=Height} p2 := clip.ScanLine[clip.Height - y];

      for x := 0 to clip.Width - 1 do begin
        if x - Amount < 0 then cx := x
        else {x-Amount>0} cx := x - Amount;
        Buf[0, 0] := p1[cx * 3];
        Buf[0, 1] := p1[cx * 3 + 1];
        Buf[0, 2] := p1[cx * 3 + 2];
        Buf[1, 0] := p2[cx * 3];
        Buf[1, 1] := p2[cx * 3 + 1];
        Buf[1, 2] := p2[cx * 3 + 2];
        if x + Amount < clip.Width then cx := x + Amount
        else {x+Amount>=Width} cx := clip.Width - x;
        Buf[2, 0] := p1[cx * 3];
        Buf[2, 1] := p1[cx * 3 + 1];
        Buf[2, 2] := p1[cx * 3 + 2];
        Buf[3, 0] := p2[cx * 3];
        Buf[3, 1] := p2[cx * 3 + 1];
        Buf[3, 2] := p2[cx * 3 + 2];
        p0[x * 3] := (Buf[0, 0] + Buf[1, 0] + Buf[2, 0] + Buf[3, 0]) shr 2;
        p0[x * 3 + 1] := (Buf[0, 1] + Buf[1, 1] + Buf[2, 1] + Buf[3, 1]) shr 2;
        p0[x * 3 + 2] := (Buf[0, 2] + Buf[1, 2] + Buf[2, 2] + Buf[3, 2]) shr 2;
      end;
    end;
  end;
var BB: TDIB;
begin
  BB := TDIB.Create;
  BB.BitCount := 24;
  BB.Assign(Self);
  _SplitBlur(BB, Amount);
  Self.Assign(BB);
  BB.Free;
end;

procedure TDIB.DoGaussianBlur(Amount: Integer);
var BB: TDIB;
begin
  BB := TDIB.Create;
  BB.BitCount := 24;
  BB.BitCount := 24;
  BB.Assign(Self);
  GaussianBlur(BB, Amount);
  Self.Assign(BB);
  BB.Free;
end;

procedure TDIB.DoMosaic(Size: Integer);
  procedure Mosaic(var Bm: TDIB; size: Integer);
  var
    x, y, i, j: integer;
    p1, p2: pbytearray;
    r, g, b: byte;
  begin
    y := 0;
    repeat
      p1 := bm.scanline[y];
      x := 0;
      repeat
        j := 1;
        repeat
          p2 := bm.scanline[y];
          x := 0;
          repeat
            r := p1[x * 3];
            g := p1[x * 3 + 1];
            b := p1[x * 3 + 2];
            i := 1;
            repeat
              p2[x * 3] := r;
              p2[x * 3 + 1] := g;
              p2[x * 3 + 2] := b;
              inc(x);
              inc(i);
            until (x >= bm.width) or (i > size);
          until x >= bm.width;
          inc(j);
          inc(y);
        until (y >= bm.height) or (j > size);
      until (y >= bm.height) or (x >= bm.width);
    until y >= bm.height;
  end;
var BB: TDIB;
begin
  BB := TDIB.Create;
  BB.BitCount := 24;
  BB.Assign(Self);
  Mosaic(BB, Size);
  Self.Assign(BB);
  BB.Free;
end;

procedure TDIB.DoTwist(Amount: Integer);
  procedure _Twist(var Bmp, Dst: TDIB; Amount: integer);
  var
    fxmid, fymid: Single;
    txmid, tymid: Single;
    fx, fy: Single;
    tx2, ty2: Single;
    r: Single;
    theta: Single;
    ifx, ify: integer;
    dx, dy: Single;
    OFFSET: Single;
    ty, tx: Integer;
    weight_x, weight_y: array[0..1] of Single;
    weight: Single;
    new_red, new_green: Integer;
    new_blue: Integer;
    total_red, total_green: Single;
    total_blue: Single;
    ix, iy: Integer;
    sli, slo: PBytearray;

    function ArcTan2(xt, yt: Single): Single;
    begin
      if xt = 0 then
        if yt > 0 then
          Result := Pi / 2
        else
          Result := -(Pi / 2)
      else begin
        Result := ArcTan(yt / xt);
        if xt < 0 then
          Result := Pi + ArcTan(yt / xt);
      end;
    end;

  begin
    OFFSET := -(Pi / 2);
    dx := Bmp.Width - 1;
    dy := Bmp.Height - 1;
    r := Sqrt(dx * dx + dy * dy);
    tx2 := r;
    ty2 := r;
    txmid := (Bmp.Width - 1) / 2; //Adjust these to move center of rotation
    tymid := (Bmp.Height - 1) / 2; //Adjust these to move ......
    fxmid := (Bmp.Width - 1) / 2;
    fymid := (Bmp.Height - 1) / 2;
    if tx2 >= Bmp.Width then tx2 := Bmp.Width - 1;
    if ty2 >= Bmp.Height then ty2 := Bmp.Height - 1;

    for ty := 0 to Round(ty2) do begin
      for tx := 0 to Round(tx2) do begin
        dx := tx - txmid;
        dy := ty - tymid;
        r := Sqrt(dx * dx + dy * dy);
        if r = 0 then begin
          fx := 0;
          fy := 0;
        end
        else begin
          theta := ArcTan2(dx, dy) - r / Amount - OFFSET;
          fx := r * Cos(theta);
          fy := r * Sin(theta);
        end;
        fx := fx + fxmid;
        fy := fy + fymid;

        ify := Trunc(fy);
        ifx := Trunc(fx);
                  // Calculate the weights.
        if fy >= 0 then begin
          weight_y[1] := fy - ify;
          weight_y[0] := 1 - weight_y[1];
        end else begin
          weight_y[0] := -(fy - ify);
          weight_y[1] := 1 - weight_y[0];
        end;
        if fx >= 0 then begin
          weight_x[1] := fx - ifx;
          weight_x[0] := 1 - weight_x[1];
        end else begin
          weight_x[0] := -(fx - ifx);
          Weight_x[1] := 1 - weight_x[0];
        end;

        if ifx < 0 then
          ifx := Bmp.Width - 1 - (-ifx mod Bmp.Width)
        else if ifx > Bmp.Width - 1 then
          ifx := ifx mod Bmp.Width;
        if ify < 0 then
          ify := Bmp.Height - 1 - (-ify mod Bmp.Height)
        else if ify > Bmp.Height - 1 then
          ify := ify mod Bmp.Height;

        total_red := 0.0;
        total_green := 0.0;
        total_blue := 0.0;
        for ix := 0 to 1 do begin
          for iy := 0 to 1 do begin
            if ify + iy < Bmp.Height then
              sli := Bmp.scanline[ify + iy]
            else
              sli := Bmp.scanline[Bmp.Height - ify - iy];
            if ifx + ix < Bmp.Width then begin
              new_red := sli[(ifx + ix) * 3];
              new_green := sli[(ifx + ix) * 3 + 1];
              new_blue := sli[(ifx + ix) * 3 + 2];
            end
            else begin
              new_red := sli[(Bmp.Width - ifx - ix) * 3];
              new_green := sli[(Bmp.Width - ifx - ix) * 3 + 1];
              new_blue := sli[(Bmp.Width - ifx - ix) * 3 + 2];
            end;
            weight := weight_x[ix] * weight_y[iy];
            total_red := total_red + new_red * weight;
            total_green := total_green + new_green * weight;
            total_blue := total_blue + new_blue * weight;
          end;
        end;
        slo := Dst.scanline[ty];
        slo[tx * 3] := Round(total_red);
        slo[tx * 3 + 1] := Round(total_green);
        slo[tx * 3 + 2] := Round(total_blue);
      end;
    end;
  end;
var BB1, BB2: TDIB;
begin
  BB1 := TDIB.Create;
  BB1.BitCount := 24;
  BB1.Assign(Self);
  BB2 := TDIB.Create;
  BB2.BitCount := 24;
  BB2.Assign(BB1);
  _Twist(BB1, BB2, Amount);
  Self.Assign(BB2);
  BB1.Free;
  BB2.Free;
end;

procedure TDIB.DoTrace(Amount: integer);
  procedure Trace(src: TDIB; intensity: integer);
  var
    x, y, i: integer;
    P1, P2, P3, P4: PByteArray;
    tb, TraceB: byte;
    hasb: boolean;
    bitmap: TDIB;
  begin
    bitmap := TDIB.create;
    bitmap.width := src.width;
    bitmap.height := src.height;
    bitmap.canvas.draw(0, 0, src);
    bitmap.BitCount := 8;
    src.BitCount := 24;
    hasb := false;
    TraceB := $00;
    for i := 1 to Intensity do begin
      for y := 0 to BitMap.height - 2 do begin
        P1 := BitMap.ScanLine[y];
        P2 := BitMap.scanline[y + 1];
        P3 := src.scanline[y];
        P4 := src.scanline[y + 1];
        x := 0;
        repeat
          if p1[x] <> p1[x + 1] then begin
            if not hasb then begin
              tb := p1[x + 1];
              hasb := true;
              p3[x * 3] := TraceB;
              p3[x * 3 + 1] := TraceB;
              p3[x * 3 + 2] := TraceB;
            end
            else begin
              if p1[x] <> tb then
              begin
                p3[x * 3] := TraceB;
                p3[x * 3 + 1] := TraceB;
                p3[x * 3 + 2] := TraceB;
              end
              else
              begin
                p3[(x + 1) * 3] := TraceB;
                p3[(x + 1) * 3 + 1] := TraceB;
                p3[(x + 1) * 3 + 1] := TraceB;
              end;
            end;
          end;
          if p1[x] <> p2[x] then begin
            if not hasb then begin
              tb := p2[x];
              hasb := true;
              p3[x * 3] := TraceB;
              p3[x * 3 + 1] := TraceB;
              p3[x * 3 + 2] := TraceB;
            end
            else begin
              if p1[x] <> tb then
              begin
                p3[x * 3] := TraceB;
                p3[x * 3 + 1] := TraceB;
                p3[x * 3 + 2] := TraceB;
              end
              else
              begin
                p4[x * 3] := TraceB;
                p4[x * 3 + 1] := TraceB;
                p4[x * 3 + 2] := TraceB;
              end;
            end;
          end;
          inc(x);
        until x >= (BitMap.width - 2);
      end;
      if i > 1 then
        for y := BitMap.height - 1 downto 1 do begin
          P1 := BitMap.ScanLine[y];
          P2 := BitMap.scanline[y - 1];
          P3 := src.scanline[y];
          P4 := src.scanline[y - 1];
          x := Bitmap.width - 1;
          repeat
            if p1[x] <> p1[x - 1] then begin
              if not hasb then begin
                tb := p1[x - 1];
                hasb := true;
                p3[x * 3] := TraceB;
                p3[x * 3 + 1] := TraceB;
                p3[x * 3 + 2] := TraceB;
              end
              else begin
                if p1[x] <> tb then
                begin
                  p3[x * 3] := TraceB;
                  p3[x * 3 + 1] := TraceB;
                  p3[x * 3 + 2] := TraceB;
                end
                else
                begin
                  p3[(x - 1) * 3] := TraceB;
                  p3[(x - 1) * 3 + 1] := TraceB;
                  p3[(x - 1) * 3 + 2] := TraceB;
                end;
              end;
            end;
            if p1[x] <> p2[x] then begin
              if not hasb then begin
                tb := p2[x];
                hasb := true;
                p3[x * 3] := TraceB;
                p3[x * 3 + 1] := TraceB;
                p3[x * 3 + 2] := TraceB;
              end
              else begin
                if p1[x] <> tb then
                begin
                  p3[x * 3] := TraceB;
                  p3[x * 3 + 1] := TraceB;
                  p3[x * 3 + 2] := TraceB;
                end
                else
                begin
                  p4[x * 3] := TraceB;
                  p4[x * 3 + 1] := TraceB;
                  p4[x * 3 + 2] := TraceB;
                end;
              end;
            end;
            dec(x);
          until x <= 1;
        end;
    end;
    bitmap.free;
  end;
var BB1, BB2: TDIB;
begin
  BB1 := TDIB.Create;
  BB1.BitCount := 24;
  BB1.Assign(Self);
  BB2 := TDIB.Create;
  BB2.BitCount := 24;
  BB2.Assign(BB1);
  Trace(BB2, Amount);
  Self.Assign(BB2);
  BB1.Free;
  BB2.Free;
end;

procedure TDIB.DoSplitlight(Amount: integer);
  procedure Splitlight(var clip: TDIB; amount: integer);
  var
    x, y, i: integer;
    p1: pbytearray;

    function sinpixs(a: integer): integer;
    begin
      result := variant(sin(a / 255 * pi / 2) * 255);
    end;
  begin
    for i := 1 to amount do
      for y := 0 to clip.height - 1 do begin
        p1 := clip.scanline[y];
        for x := 0 to clip.width - 1 do begin
          p1[x * 3] := sinpixs(p1[x * 3]);
          p1[x * 3 + 1] := sinpixs(p1[x * 3 + 1]);
          p1[x * 3 + 2] := sinpixs(p1[x * 3 + 2]);
        end;
      end;
  end;
var BB1 {,BB2}: TDIB;
begin
  BB1 := TDIB.Create;
  BB1.BitCount := 24;
  BB1.Assign(Self);
//  BB2 := TDIB.Create;
//  BB2.BitCount := 24;
//  BB2.Assign (BB1);
  Splitlight(BB1, Amount);
  Self.Assign(BB1);
  BB1.Free;
//  BB2.Free;
end;

procedure TDIB.DoTile(Amount: integer);
  procedure SmoothResize(var Src, Dst: TDIB);
  var
    x, y, xP, yP,
      yP2, xP2: Integer;
    Read, Read2: PByteArray;
    t, z, z2, iz2: Integer;
    pc: PBytearray;
    w1, w2, w3, w4: Integer;
    Col1r, col1g, col1b, Col2r, col2g, col2b: byte;
  begin
    xP2 := ((src.Width - 1) shl 15) div Dst.Width;
    yP2 := ((src.Height - 1) shl 15) div Dst.Height;
    yP := 0;
    for y := 0 to Dst.Height - 1 do begin
      xP := 0;
      Read := src.ScanLine[yP shr 15];
      if yP shr 16 < src.Height - 1 then
        Read2 := src.ScanLine[yP shr 15 + 1]
      else
        Read2 := src.ScanLine[yP shr 15];
      pc := Dst.scanline[y];
      z2 := yP and $7FFF;
      iz2 := $8000 - z2;
      for x := 0 to Dst.Width - 1 do begin
        t := xP shr 15;
        Col1r := Read[t * 3];
        Col1g := Read[t * 3 + 1];
        Col1b := Read[t * 3 + 2];
        Col2r := Read2[t * 3];
        Col2g := Read2[t * 3 + 1];
        Col2b := Read2[t * 3 + 2];
        z := xP and $7FFF;
        w2 := (z * iz2) shr 15;
        w1 := iz2 - w2;
        w4 := (z * z2) shr 15;
        w3 := z2 - w4;
        pc[x * 3 + 2] :=
          (Col1b * w1 + Read[(t + 1) * 3 + 2] * w2 +
          Col2b * w3 + Read2[(t + 1) * 3 + 2] * w4) shr 15;
        pc[x * 3 + 1] :=
          (Col1g * w1 + Read[(t + 1) * 3 + 1] * w2 +
          Col2g * w3 + Read2[(t + 1) * 3 + 1] * w4) shr 15;
        pc[x * 3] :=
          (Col1r * w1 + Read2[(t + 1) * 3] * w2 +
          Col2r * w3 + Read2[(t + 1) * 3] * w4) shr 15;
        Inc(xP, xP2);
      end;
      Inc(yP, yP2);
    end;
  end;
  procedure Tile(src, dst: TDIB; amount: integer);
  var
    w, h, w2, h2, i, j: integer;
    bm: TDIB;
  begin
    w := src.width;
    h := src.height;
    dst.width := w;
    dst.height := h;
    dst.Canvas.draw(0, 0, src);
    if (amount <= 0) or ((w div amount) < 5) or ((h div amount) < 5) then exit;
    h2 := h div amount;
    w2 := w div amount;
    bm := TDIB.create;
    bm.width := w2;
    bm.height := h2;
    bm.BitCount := 24;
    smoothresize(src, bm);
    for j := 0 to amount - 1 do
      for i := 0 to amount - 1 do
        dst.canvas.Draw(i * w2, j * h2, bm);
    bm.free;
  end;
var BB1, BB2: TDIB;
begin
  BB1 := TDIB.Create;
  BB1.BitCount := 24;
  BB1.Assign(Self);
  BB2 := TDIB.Create;
  BB2.BitCount := 24;
  BB2.Assign(BB1);
  Tile(BB1, BB2, Amount);
  Self.Assign(BB2);
  BB1.Free;
  BB2.Free;
end;

procedure TDIB.DoSpotLight(Amount: integer; Spot: TRect);
  procedure SpotLight(var src: TDIB; Amount: integer; Spot: TRect);
  var
    bm, z: TDIB;
    w, h: integer;
  begin
    z := TDIB.Create;
    try
      z.SetSize(src.Width, src.Height, 24);
      z.DrawTo(src, 0, 0, src.Width, src.Height, 0, 0);
      z.Darkness(amount);
      w := z.Width;
      h := z.Height;
      bm := TDIB.create;
      try
        bm.width := w;
        bm.height := h;
        bm.Canvas.Brush.color := clblack;
        bm.Canvas.FillRect(rect(0, 0, w, h));
        bm.Canvas.Brush.Color := clwhite;
        bm.Canvas.Ellipse(Spot.left, spot.top, spot.right, spot.bottom);
        bm.Transparent := true;
        z.Canvas.CopyMode := cmSrcAnd; {as transparentcolor for white}
        z.Canvas.Draw(0, 0, bm);
      finally
        bm.Free;
      end;
    finally
      z.Free
    end;
  end;
var BB1, BB2: TDIB;
begin
  BB1 := TDIB.Create;
  BB1.BitCount := 24;
  BB1.Assign(Self);
  BB2 := TDIB.Create;
  BB2.BitCount := 24;
  BB2.Assign(BB1);
  SpotLight(BB2, Amount, Spot);
  Self.Assign(BB2);
  BB1.Free;
  BB2.Free;
end;

procedure TDIB.DoEmboss;
  procedure Emboss(var Bmp: TDIB);
  var
    x, y: Integer;
    p1, p2: Pbytearray;
  begin
    for y := 0 to Bmp.Height - 2 do begin
      p1 := bmp.scanline[y];
      p2 := bmp.scanline[y + 1];
      for x := 0 to Bmp.Width - 4 do begin
        p1[x * 3] := (p1[x * 3] + (p2[(x + 3) * 3] xor $FF)) shr 1;
        p1[x * 3 + 1] := (p1[x * 3 + 1] + (p2[(x + 3) * 3 + 1] xor $FF)) shr 1;
        p1[x * 3 + 2] := (p1[x * 3 + 2] + (p2[(x + 3) * 3 + 2] xor $FF)) shr 1;
      end;
    end;
  end;
var BB1, BB2: TDIB;
begin
  BB1 := TDIB.Create;
  BB1.BitCount := 24;
  BB1.Assign(Self);
  BB2 := TDIB.Create;
  BB2.BitCount := 24;
  BB2.Assign(BB1);
  Emboss(BB2);
  Self.Assign(BB2);
  BB1.Free;
  BB2.Free;
end;

procedure TDIB.DoSolorize(Amount: integer);
  procedure Solorize(src, dst: TDIB; amount: integer);
  var
    w, h, x, y: integer;
    ps, pd: pbytearray;
    c: integer;
  begin
    w := src.width;
    h := src.height;
    src.BitCount := 24;
    dst.BitCount := 24;
    for y := 0 to h - 1 do begin
      ps := src.scanline[y];
      pd := dst.scanline[y];
      for x := 0 to w - 1 do begin
        c := (ps[x * 3] + ps[x * 3 + 1] + ps[x * 3 + 2]) div 3;
        if c > amount then begin
          pd[x * 3] := 255 - ps[x * 3];
          pd[x * 3 + 1] := 255 - ps[x * 3 + 1];
          pd[x * 3 + 2] := 255 - ps[x * 3 + 2];
        end
        else begin
          pd[x * 3] := ps[x * 3];
          pd[x * 3 + 1] := ps[x * 3 + 1];
          pd[x * 3 + 2] := ps[x * 3 + 2];
        end;
      end;
    end;
  end;
var BB1, BB2: TDIB;
begin
  BB1 := TDIB.Create;
  BB1.BitCount := 24;
  BB1.Assign(Self);
  BB2 := TDIB.Create;
  BB2.BitCount := 24;
  BB2.Assign(BB1);
  Solorize(BB1, BB2, Amount);
  Self.Assign(BB2);
  BB1.Free;
  BB2.Free;
end;

procedure TDIB.DoPosterize(Amount: integer);
  procedure Posterize(src, dst: TDIB; amount: integer);
  var
    w, h, x, y: integer;
    ps, pd: pbytearray;
  begin
    w := src.width;
    h := src.height;
    src.BitCount := 24;
    dst.BitCount := 24;
    for y := 0 to h - 1 do begin
      ps := src.scanline[y];
      pd := dst.scanline[y];
      for x := 0 to w - 1 do begin
        pd[x * 3] := round(ps[x * 3] / amount) * amount;
        pd[x * 3 + 1] := round(ps[x * 3 + 1] / amount) * amount;
        pd[x * 3 + 2] := round(ps[x * 3 + 2] / amount) * amount;
      end;
    end;
  end;
var BB1, BB2: TDIB;
begin
  BB1 := TDIB.Create;
  BB1.BitCount := 24;
  BB1.Assign(Self);
  BB2 := TDIB.Create;
  BB2.BitCount := 24;
  BB2.Assign(BB1);
  Posterize(BB1, BB2, Amount);
  Self.Assign(BB2);
  BB1.Free;
  BB2.Free;
end;

procedure TDIB.DoBrightness(Amount: integer);
  procedure Brightness(src, dst: TDIB; level: Integer);
  const
    MaxPixelCount = 32768;
  type
    pRGBArray = ^TRGBArray;
    TRGBArray = array[0..MaxPixelCount - 1] of TRGBTriple;
  var
    i, j, value: integer;
    OrigRow, DestRow: pRGBArray;
  begin
    // get brightness increment value
    value := level;
    src.BitCount := 24;
    dst.BitCount := 24;
    // for each row of pixels
    for i := 0 to src.Height - 1 do begin
      OrigRow := src.ScanLine[i];
      DestRow := dst.ScanLine[i];
      // for each pixel in row
      for j := 0 to src.Width - 1 do begin
        // add brightness value to pixel's RGB values
        if value > 0 then begin
          // RGB values must be less than 256
          DestRow[j].rgbtRed := Min(255, OrigRow[j].rgbtRed + value);
          DestRow[j].rgbtGreen := Min(255, OrigRow[j].rgbtGreen + value);
          DestRow[j].rgbtBlue := Min(255, OrigRow[j].rgbtBlue + value);
        end else begin
          // RGB values must be greater or equal than 0
          DestRow[j].rgbtRed := Max(0, OrigRow[j].rgbtRed + value);
          DestRow[j].rgbtGreen := Max(0, OrigRow[j].rgbtGreen + value);
          DestRow[j].rgbtBlue := Max(0, OrigRow[j].rgbtBlue + value);
        end;
      end;
    end;
  end;
var BB1, BB2: TDIB;
begin
  BB1 := TDIB.Create;
  BB1.BitCount := 24;
  BB1.Assign(Self);
  BB2 := TDIB.Create;
  BB2.BitCount := 24;
  BB2.Assign(BB1);
  Brightness(BB1, BB2, Amount);
  Self.Assign(BB2);
  BB1.Free;
  BB2.Free;
end;

procedure TDIB.DoResample(AmountX, AmountY: integer; TypeResample: TFilterTypeResample);
  procedure Resample(Src, Dst: TDIB; filtertype: TFilterTypeResample; fwidth: single);
  // -----------------------------------------------------------------------------
  //
  //			Filter functions
  //
  // -----------------------------------------------------------------------------

  // Hermite filter
    function HermiteFilter(Value: Single): Single;
    begin
    // f(t) = 2|t|^3 - 3|t|^2 + 1, -1 <= t <= 1
      if (Value < 0.0) then
        Value := -Value;
      if (Value < 1.0) then
        Result := (2.0 * Value - 3.0) * Sqr(Value) + 1.0
      else
        Result := 0.0;
    end;

  // Box filter
  // a.k.a. "Nearest Neighbour" filter
  // anme: I have not been able to get acceptable
  //       results with this filter for subsampling.
    function BoxFilter(Value: Single): Single;
    begin
      if (Value > -0.5) and (Value <= 0.5) then
        Result := 1.0
      else
        Result := 0.0;
    end;

  // Triangle filter
  // a.k.a. "Linear" or "Bilinear" filter
    function TriangleFilter(Value: Single): Single;
    begin
      if (Value < 0.0) then
        Value := -Value;
      if (Value < 1.0) then
        Result := 1.0 - Value
      else
        Result := 0.0;
    end;

  // Bell filter
    function BellFilter(Value: Single): Single;
    begin
      if (Value < 0.0) then
        Value := -Value;
      if (Value < 0.5) then
        Result := 0.75 - Sqr(Value)
      else if (Value < 1.5) then
      begin
        Value := Value - 1.5;
        Result := 0.5 * Sqr(Value);
      end else
        Result := 0.0;
    end;

  // B-spline filter
    function SplineFilter(Value: Single): Single;
    var
      tt: single;
    begin
      if (Value < 0.0) then
        Value := -Value;
      if (Value < 1.0) then
      begin
        tt := Sqr(Value);
        Result := 0.5 * tt * Value - tt + 2.0 / 3.0;
      end else if (Value < 2.0) then
      begin
        Value := 2.0 - Value;
        Result := 1.0 / 6.0 * Sqr(Value) * Value;
      end else
        Result := 0.0;
    end;

  // Lanczos3 filter
    function Lanczos3Filter(Value: Single): Single;
      function SinC(Value: Single): Single;
      begin
        if (Value <> 0.0) then
        begin
          Value := Value * Pi;
          Result := sin(Value) / Value
        end else
          Result := 1.0;
      end;
    begin
      if (Value < 0.0) then
        Value := -Value;
      if (Value < 3.0) then
        Result := SinC(Value) * SinC(Value / 3.0)
      else
        Result := 0.0;
    end;

    function MitchellFilter(Value: Single): Single;
    const
      B = (1.0 / 3.0);
      C = (1.0 / 3.0);
    var
      tt: single;
    begin
      if (Value < 0.0) then
        Value := -Value;
      tt := Sqr(Value);
      if (Value < 1.0) then
      begin
        Value := (((12.0 - 9.0 * B - 6.0 * C) * (Value * tt))
          + ((-18.0 + 12.0 * B + 6.0 * C) * tt)
          + (6.0 - 2 * B));
        Result := Value / 6.0;
      end else
        if (Value < 2.0) then
        begin
          Value := (((-1.0 * B - 6.0 * C) * (Value * tt))
            + ((6.0 * B + 30.0 * C) * tt)
            + ((-12.0 * B - 48.0 * C) * Value)
            + (8.0 * B + 24 * C));
          Result := Value / 6.0;
        end else
          Result := 0.0;
    end;

  // -----------------------------------------------------------------------------
  //
  //			Interpolator
  //
  // -----------------------------------------------------------------------------
  type
    // Contributor for a pixel
    TContributor = record
      pixel: integer; // Source pixel
      weight: single; // Pixel weight
    end;

    TContributorList = array[0..0] of TContributor;
    PContributorList = ^TContributorList;

    // List of source pixels contributing to a destination pixel
    TCList = record
      n: integer;
      p: PContributorList;
    end;

    TCListList = array[0..0] of TCList;
    PCListList = ^TCListList;

    TRGB = packed record
      r, g, b: single;
    end;

    // Physical bitmap pixel
    TColorRGB = packed record
      r, g, b: BYTE;
    end;
    PColorRGB = ^TColorRGB;

    // Physical bitmap scanline (row)
    TRGBList = packed array[0..0] of TColorRGB;
    PRGBList = ^TRGBList;

  var
    xscale, yscale: single; // Zoom scale factors
    i, j, k: integer; // Loop variables
    center: single; // Filter calculation variables
    width, fscale, weight: single; // Filter calculation variables
    left, right: integer; // Filter calculation variables
    n: integer; // Pixel number
    Work: TDIB;
    contrib: PCListList;
    rgb: TRGB;
    color: TColorRGB;
  {$IFDEF USE_SCANLINE}
    SourceLine,
      DestLine: PRGBList;
    SourcePixel,
      DestPixel: PColorRGB;
    Delta,
      DestDelta: integer;
  {$ENDIF}
    SrcWidth,
      SrcHeight,
      DstWidth,
      DstHeight: integer;

    function Color2RGB(Color: TColor): TColorRGB;
    begin
      Result.r := Color and $000000FF;
      Result.g := (Color and $0000FF00) shr 8;
      Result.b := (Color and $00FF0000) shr 16;
    end;

    function RGB2Color(Color: TColorRGB): TColor;
    begin
      Result := Color.r or (Color.g shl 8) or (Color.b shl 16);
    end;

  begin
    DstWidth := Dst.Width;
    DstHeight := Dst.Height;
    SrcWidth := Src.Width;
    SrcHeight := Src.Height;
    if (SrcWidth < 1) or (SrcHeight < 1) then
      raise Exception.Create('Source bitmap too small');

    // Create intermediate image to hold horizontal zoom
    Work := TDIB.Create;
    try
      Work.Height := SrcHeight;
      Work.Width := DstWidth;
      // xscale := DstWidth / SrcWidth;
      // yscale := DstHeight / SrcHeight;
      // Improvement suggested by David Ullrich:
      if (SrcWidth = 1) then
        xscale := DstWidth / SrcWidth
      else
        xscale := (DstWidth - 1) / (SrcWidth - 1);
      if (SrcHeight = 1) then
        yscale := DstHeight / SrcHeight
      else
        yscale := (DstHeight - 1) / (SrcHeight - 1);
      // This implementation only works on 24-bit images because it uses
      // TDIB.Scanline
{$IFDEF USE_SCANLINE}
      //Src.PixelFormat := pf24bit;
      Src.BitCount := 24;
      //Dst.PixelFormat := Src.PixelFormat;
      dst.BitCount := 24;
      //Work.PixelFormat := Src.PixelFormat;
      work.BitCount := 24;
{$ENDIF}

      // --------------------------------------------
      // Pre-calculate filter contributions for a row
      // -----------------------------------------------
      GetMem(contrib, DstWidth * sizeof(TCList));
      // Horizontal sub-sampling
      // Scales from bigger to smaller width
      if (xscale < 1.0) then
      begin
        width := fwidth / xscale;
        fscale := 1.0 / xscale;
        for i := 0 to DstWidth - 1 do
        begin
          contrib^[i].n := 0;
          GetMem(contrib^[i].p, trunc(width * 2.0 + 1) * sizeof(TContributor));
          center := i / xscale;
          // Original code:
          // left := ceil(center - width);
          // right := floor(center + width);
          left := floor(center - width);
          right := ceil(center + width);
          for j := left to right do
          begin
            case filtertype of
              ftrBox: weight := boxfilter((center - j) / fscale) / fscale;
              ftrTriangle: weight := trianglefilter((center - j) / fscale) / fscale;
              ftrHermite: weight := hermitefilter((center - j) / fscale) / fscale;
              ftrBell: weight := bellfilter((center - j) / fscale) / fscale;
              ftrBSpline: weight := splinefilter((center - j) / fscale) / fscale;
              ftrLanczos3: weight := Lanczos3filter((center - j) / fscale) / fscale;
              ftrMitchell: weight := Mitchellfilter((center - j) / fscale) / fscale;
            end;
            if (weight = 0.0) then
              continue;
            if (j < 0) then
              n := -j
            else if (j >= SrcWidth) then
              n := SrcWidth - j + SrcWidth - 1
            else
              n := j;
            k := contrib^[i].n;
            contrib^[i].n := contrib^[i].n + 1;
            contrib^[i].p^[k].pixel := n;
            contrib^[i].p^[k].weight := weight;
          end;
        end;
      end else
      // Horizontal super-sampling
      // Scales from smaller to bigger width
      begin
        for i := 0 to DstWidth - 1 do
        begin
          contrib^[i].n := 0;
          GetMem(contrib^[i].p, trunc(fwidth * 2.0 + 1) * sizeof(TContributor));
          center := i / xscale;
          // Original code:
          // left := ceil(center - fwidth);
          // right := floor(center + fwidth);
          left := floor(center - fwidth);
          right := ceil(center + fwidth);
          for j := left to right do
          begin
            case filtertype of
              ftrBox: weight := boxfilter(center - j);
              ftrTriangle: weight := trianglefilter(center - j);
              ftrHermite: weight := hermitefilter(center - j);
              ftrBell: weight := bellfilter(center - j);
              ftrBSpline: weight := splinefilter(center - j);
              ftrLanczos3: weight := Lanczos3filter(center - j);
              ftrMitchell: weight := Mitchellfilter(center - j);
            end;
            if (weight = 0.0) then
              continue;
            if (j < 0) then
              n := -j
            else if (j >= SrcWidth) then
              n := SrcWidth - j + SrcWidth - 1
            else
              n := j;
            k := contrib^[i].n;
            contrib^[i].n := contrib^[i].n + 1;
            contrib^[i].p^[k].pixel := n;
            contrib^[i].p^[k].weight := weight;
          end;
        end;
      end;

      // ----------------------------------------------------
      // Apply filter to sample horizontally from Src to Work
      // ----------------------------------------------------
      for k := 0 to SrcHeight - 1 do
      begin
{$IFDEF USE_SCANLINE}
        SourceLine := Src.ScanLine[k];
        DestPixel := Work.ScanLine[k];
{$ENDIF}
        for i := 0 to DstWidth - 1 do
        begin
          rgb.r := 0.0;
          rgb.g := 0.0;
          rgb.b := 0.0;
          for j := 0 to contrib^[i].n - 1 do
          begin
{$IFDEF USE_SCANLINE}
            color := SourceLine^[contrib^[i].p^[j].pixel];
{$ELSE}
            color := Color2RGB(Src.Canvas.Pixels[contrib^[i].p^[j].pixel, k]);
{$ENDIF}
            weight := contrib^[i].p^[j].weight;
            if (weight = 0.0) then
              continue;
            rgb.r := rgb.r + color.r * weight;
            rgb.g := rgb.g + color.g * weight;
            rgb.b := rgb.b + color.b * weight;
          end;
          if (rgb.r > 255.0) then
            color.r := 255
          else if (rgb.r < 0.0) then
            color.r := 0
          else
            color.r := round(rgb.r);
          if (rgb.g > 255.0) then
            color.g := 255
          else if (rgb.g < 0.0) then
            color.g := 0
          else
            color.g := round(rgb.g);
          if (rgb.b > 255.0) then
            color.b := 255
          else if (rgb.b < 0.0) then
            color.b := 0
          else
            color.b := round(rgb.b);
{$IFDEF USE_SCANLINE}
          // Set new pixel value
          DestPixel^ := color;
          // Move on to next column
          inc(DestPixel);
{$ELSE}
          Work.Canvas.Pixels[i, k] := RGB2Color(color);
{$ENDIF}
        end;
      end;

      // Free the memory allocated for horizontal filter weights
      for i := 0 to DstWidth - 1 do
        FreeMem(contrib^[i].p);

      FreeMem(contrib);

      // -----------------------------------------------
      // Pre-calculate filter contributions for a column
      // -----------------------------------------------
      GetMem(contrib, DstHeight * sizeof(TCList));
      // Vertical sub-sampling
      // Scales from bigger to smaller height
      if (yscale < 1.0) then
      begin
        width := fwidth / yscale;
        fscale := 1.0 / yscale;
        for i := 0 to DstHeight - 1 do
        begin
          contrib^[i].n := 0;
          GetMem(contrib^[i].p, trunc(width * 2.0 + 1) * sizeof(TContributor));
          center := i / yscale;
          // Original code:
          // left := ceil(center - width);
          // right := floor(center + width);
          left := floor(center - width);
          right := ceil(center + width);
          for j := left to right do
          begin
            case filtertype of
              ftrBox: weight := boxfilter((center - j) / fscale) / fscale;
              ftrTriangle: weight := trianglefilter((center - j) / fscale) / fscale;
              ftrHermite: weight := hermitefilter((center - j) / fscale) / fscale;
              ftrBell: weight := bellfilter((center - j) / fscale) / fscale;
              ftrBSpline: weight := splinefilter((center - j) / fscale) / fscale;
              ftrLanczos3: weight := Lanczos3filter((center - j) / fscale) / fscale;
              ftrMitchell: weight := Mitchellfilter((center - j) / fscale) / fscale;
            end;
            if (weight = 0.0) then
              continue;
            if (j < 0) then
              n := -j
            else if (j >= SrcHeight) then
              n := SrcHeight - j + SrcHeight - 1
            else
              n := j;
            k := contrib^[i].n;
            contrib^[i].n := contrib^[i].n + 1;
            contrib^[i].p^[k].pixel := n;
            contrib^[i].p^[k].weight := weight;
          end;
        end
      end else
      // Vertical super-sampling
      // Scales from smaller to bigger height
      begin
        for i := 0 to DstHeight - 1 do
        begin
          contrib^[i].n := 0;
          GetMem(contrib^[i].p, trunc(fwidth * 2.0 + 1) * sizeof(TContributor));
          center := i / yscale;
          // Original code:
          // left := ceil(center - fwidth);
          // right := floor(center + fwidth);
          left := floor(center - fwidth);
          right := ceil(center + fwidth);
          for j := left to right do
          begin
            case filtertype of
              ftrBox: weight := boxfilter(center - j);
              ftrTriangle: weight := trianglefilter(center - j);
              ftrHermite: weight := hermitefilter(center - j);
              ftrBell: weight := bellfilter(center - j);
              ftrBSpline: weight := splinefilter(center - j);
              ftrLanczos3: weight := Lanczos3filter(center - j);
              ftrMitchell: weight := Mitchellfilter(center - j);
            end;
            if (weight = 0.0) then
              continue;
            if (j < 0) then
              n := -j
            else if (j >= SrcHeight) then
              n := SrcHeight - j + SrcHeight - 1
            else
              n := j;
            k := contrib^[i].n;
            contrib^[i].n := contrib^[i].n + 1;
            contrib^[i].p^[k].pixel := n;
            contrib^[i].p^[k].weight := weight;
          end;
        end;
      end;

      // --------------------------------------------------
      // Apply filter to sample vertically from Work to Dst
      // --------------------------------------------------
{$IFDEF USE_SCANLINE}
      SourceLine := Work.ScanLine[0];
      Delta := integer(Work.ScanLine[1]) - integer(SourceLine);
      DestLine := Dst.ScanLine[0];
      DestDelta := integer(Dst.ScanLine[1]) - integer(DestLine);
{$ENDIF}
      for k := 0 to DstWidth - 1 do
      begin
{$IFDEF USE_SCANLINE}
        DestPixel := pointer(DestLine);
{$ENDIF}
        for i := 0 to DstHeight - 1 do
        begin
          rgb.r := 0;
          rgb.g := 0;
          rgb.b := 0;
          // weight := 0.0;
          for j := 0 to contrib^[i].n - 1 do
          begin
{$IFDEF USE_SCANLINE}
            color := PColorRGB(integer(SourceLine) + contrib^[i].p^[j].pixel * Delta)^;
{$ELSE}
            color := Color2RGB(Work.Canvas.Pixels[k, contrib^[i].p^[j].pixel]);
{$ENDIF}
            weight := contrib^[i].p^[j].weight;
            if (weight = 0.0) then
              continue;
            rgb.r := rgb.r + color.r * weight;
            rgb.g := rgb.g + color.g * weight;
            rgb.b := rgb.b + color.b * weight;
          end;
          if (rgb.r > 255.0) then
            color.r := 255
          else if (rgb.r < 0.0) then
            color.r := 0
          else
            color.r := round(rgb.r);
          if (rgb.g > 255.0) then
            color.g := 255
          else if (rgb.g < 0.0) then
            color.g := 0
          else
            color.g := round(rgb.g);
          if (rgb.b > 255.0) then
            color.b := 255
          else if (rgb.b < 0.0) then
            color.b := 0
          else
            color.b := round(rgb.b);
{$IFDEF USE_SCANLINE}
          DestPixel^ := color;
          inc(integer(DestPixel), DestDelta);
{$ELSE}
          Dst.Canvas.Pixels[k, i] := RGB2Color(color);
{$ENDIF}
        end;
{$IFDEF USE_SCANLINE}
        Inc(SourceLine, 1);
        Inc(DestLine, 1);
{$ENDIF}
      end;

      // Free the memory allocated for vertical filter weights
      for i := 0 to DstHeight - 1 do
        FreeMem(contrib^[i].p);

      FreeMem(contrib);

    finally
      Work.Free;
    end;
  end;
var BB1, BB2: TDIB;
begin
  BB1 := TDIB.Create;
  BB1.BitCount := 24;
  BB1.Assign(Self);
  BB2 := TDIB.Create;
  BB2.SetSize(AmountX, AmountY, 24);
  //BB2.Assign (BB1);
  Resample(BB1, BB2, TypeResample, DefaultFilterRadius[TypeResample]);
  Self.Assign(BB2);
  BB1.Free;
  BB2.Free;
end;

procedure TDIB.DoColorize(ForeColor, BackColor: TColor);
  procedure Colorize(src, dst: TDIB; iForeColor, iBackColor: TColor);
  {for monochromatic picture change colors}
    procedure InvertBitmap(Bmp: TDIB);
    begin
      Bmp.Canvas.CopyMode := cmDstInvert;
      Bmp.Canvas.CopyRect(rect(0, 0, Bmp.Width, Bmp.Height),
        Bmp.Canvas, rect(0, 0, Bmp.Width, Bmp.Height));
    end;
  var
    fColor: TColor;
    fForeColor: TColor;
    fForeDither: Boolean;
    fBmpMade: Boolean;
    lTempBitmap: TDIB;
    lTempBitmap2: TDIB;
    lDitherBitmap: TDIB;
    lCRect: TRect;
    x, y, w, h: Integer;
  begin
    {--}
    fColor := iBackColor; ;
    fForeColor := iForeColor;

    w := src.Width;
    h := src.Height;
    lTempBitmap := TDIB.Create;
    lTempBitmap.SetSize(w, h, 24);
    lTempBitmap2 := TDIB.Create;
    lTempBitmap2.SetSize(w, h, 24);
    lCRect := rect(0, 0, w, h);
    with lTempBitmap.Canvas do begin
      Brush.Style := bsSolid;
      Brush.Color := iBackColor;
      FillRect(lCRect);
      CopyMode := cmSrcInvert;
      CopyRect(lCRect, src.Canvas, lCRect);
      InvertBitmap(src);
      CopyMode := cmSrcPaint;
      CopyRect(lCRect, src.Canvas, lCRect);
      InvertBitmap(lTempBitmap);
      CopyMode := cmSrcInvert;
      CopyRect(lCRect, src.Canvas, lCRect);
      InvertBitmap(src);
    end;
    with lTempBitmap2.Canvas do begin
      Brush.Style := bsSolid;
      Brush.Color := clBlack;
      FillRect(lCRect);
      if fForeDither then begin
        InvertBitmap(src);
        lDitherBitmap := TDIB.Create;
        lDitherBitmap.SetSize(8, 8, 24);
        with lDitherBitmap.Canvas do begin
          for x := 0 to 7 do
            for y := 0 to 7 do
              if ((x mod 2 = 0) and (y mod 2 > 0)) or
                ((x mod 2 > 0) and (y mod 2 = 0)) then
                pixels[x, y] := fForeColor
              else
                pixels[x, y] := iBackColor;
        end;
        Brush.Bitmap.Assign(lDitherBitmap);
      end
      else begin
        Brush.Style := bsSolid;
        Brush.Color := fForeColor;
      end;
      if not fForeDither then
        InvertBitmap(src);
      CopyMode := cmPatPaint;
      CopyRect(lCRect, src.Canvas, lCRect);
      if fForeDither then lDitherBitmap.Free;
      CopyMode := cmSrcInvert;
      CopyRect(lCRect, src.Canvas, lCRect);
    end;
    lTempBitmap.Canvas.CopyMode := cmSrcInvert;
    lTempBitmap.Canvas.Copyrect(lCRect, lTempBitmap2.Canvas, lCRect);
    InvertBitmap(src);
    lTempBitmap.Canvas.CopyMode := cmSrcErase;
    lTempBitmap.Canvas.Copyrect(lCRect, src.Canvas, lCRect);
    InvertBitmap(src);
    lTempBitmap.Canvas.CopyMode := cmSrcInvert;
    lTempBitmap.Canvas.Copyrect(lCRect, lTempBitmap2.Canvas, lCRect);
    InvertBitmap(lTempBitmap);
    InvertBitmap(src);
    dst.Assign(lTempBitmap);
    lTempBitmap.Free;
    fBmpMade := True;
  end;
var BB1, BB2: TDIB;
begin
  BB1 := TDIB.Create;
  BB1.BitCount := 24;
  BB1.Assign(Self);
  BB2 := TDIB.Create;
  Colorize(BB1, BB2, ForeColor, BackColor);
  Self.Assign(BB2);
  BB1.Free;
  BB2.Free;
end;

{ procedure for special purpose }

procedure TDIB.FadeOut(DIB2: TDIB; Step: Byte);
var
  P1, P2: PByteArray;
  W, H: Integer;
begin
  P1 := ScanLine[DIB2.Height - 1];
  P2 := DIB2.ScanLine[DIB2.Height - 1];
  W := WidthBytes;
  H := Height;
  asm
    PUSH ESI
    PUSH EDI
    MOV ESI, P1
    MOV EDI, P2
    MOV EDX, W
    MOV EAX, H
    IMUL EDX
    MOV ECX, EAX
    @@1:
    MOV AL, Step
    MOV AH, [ESI]
    CMP AL, AH
    JA @@2
    MOV AL, AH
@@2:
    MOV [EDI], AL
    INC ESI
    INC EDI
    DEC ECX
    JNZ @@1
    POP EDI
    POP ESI
  end;
end;

procedure TDIB.DoZoom(DIB2: TDIB; ZoomRatio: Real);
var
  P1, P2: PByteArray;
  W, H: Integer;
  x, y: Integer;
  xr, yr, xstep, ystep: real;
  xstart: real;
begin
  W := WidthBytes;
  H := Height;
  xstart := (W - (W * ZoomRatio)) / 2;

  xr := xstart;
  yr := (H - (H * ZoomRatio)) / 2;
  xstep := ZoomRatio;
  ystep := ZoomRatio;

  for y := 1 to Height - 1 do begin
    P2 := DIB2.ScanLine[y];
    if (yr >= 0) and (yr <= H) then begin
      P1 := ScanLine[Trunc(yr)];
      for x := 1 to Width - 1 do begin
        if (xr >= 0) and (xr <= W) then begin
          P2[x] := P1[Trunc(xr)];
        end else begin
          P2[x] := 0;
        end;
        xr := xr + xstep;
      end;
    end else begin
      for x := 1 to Width - 1 do begin
        P2[x] := 0;
      end;
    end;
    xr := xstart;
    yr := yr + ystep;
  end;
end;

procedure TDIB.DoBlur(DIB2: TDIB);
var
  P1, P2: PByteArray;
  W: Integer;
  x, y: Integer;
begin
  W := WidthBytes;
  for y := 1 to Height - 1 do begin
    P1 := ScanLine[y];
    P2 := DIB2.ScanLine[y];
    for x := 1 to Width - 1 do begin
      P2[x] := (P1[x] + P1[x - 1] + P1[x + 1] + P1[x + W] + P1[x - W]) div 5;
    end;
  end;
end;

procedure TDIB.FadeIn(DIB2: TDIB; Step: Byte);
var
  P1, P2: PByteArray;
  W, H: Integer;
begin
  P1 := ScanLine[DIB2.Height - 1];
  P2 := DIB2.ScanLine[DIB2.Height - 1];
  W := WidthBytes;
  H := Height;
  asm
    PUSH ESI
    PUSH EDI
    MOV ESI, P1
    MOV EDI, P2
    MOV EDX, W
    MOV EAX, H
    IMUL EDX
    MOV ECX, EAX
    @@1:
    MOV AL, Step
    MOV AH, [ESI]
    CMP AL, AH
    JB @@2
    MOV AL, AH
@@2:
    MOV [EDI], AL
    INC ESI
    INC EDI
    DEC ECX
    JNZ @@1
    POP EDI
    POP ESI
  end;
end;

procedure TDIB.FillDIB8(Color: Byte);
var
  P: PByteArray;
  W, H: Integer;
begin
  P := ScanLine[Height - 1];
  W := WidthBytes;
  H := Height;
  asm
    PUSH ESI
    MOV ESI, P
    MOV EDX, W
    MOV EAX, H
    IMUL EDX
    MOV ECX, EAX
    MOV AL, Color
    @@1:
    MOV [ESI], AL
    INC ESI
    DEC ECX
    JNZ @@1
    POP ESI
  end;
end;

procedure TDIB.DoRotate(DIB1: TDIB; xc, yc, a: Integer);
type
  T3Byte = array[0..2] of Byte;
  P3ByteArray = ^T3ByteArray;
  T3ByteArray = array[0..32767] of T3Byte;
  PLongArray = ^TLongArray;
  TLongArray = array[0..32767] of LongInt;
var
  p, p2: PByteArray;
  x, y, x2, y2, angle: Integer;
  cosy, siny: real;
begin
  angle := 384 + a;
  for y := 0 to Height - 1 do begin
    p := DIB1.ScanLine[y];
    cosy := (y - yc) * dcos(angle and $1FF);
    siny := (y - yc) * dsin(angle and $1FF);
    for x := 0 to Width - 1 do begin
      x2 := Trunc((x - xc) * dsin(angle and $1FF) + cosy) + xc;
      y2 := Trunc((x - xc) * dcos(angle and $1FF) - siny) + yc;
      case bitcount of
        8: begin
            if (y2 >= 0) and (y2 < Height) and (x2 >= 0) and (x2 < Width) then begin
              p2 := ScanLine[y2];
              p[x] := p2[Width - x2];
            end else begin
              if p[x] > 4 then
                p[x] := p[x] - 4
              else
                p[x] := 0;
            end;
          end;
        16: begin
            if (y2 >= 0) and (y2 < Height) and (x2 >= 0) and (x2 < Width) then begin
              PWordArray(p2) := ScanLine[y2];
              PWordArray(p)[x] := PWordArray(p2)[Width - x2];
            end else begin
              if PWordArray(p)[x] > 4 then
                PWordArray(p)[x] := PWordArray(p)[x] - 4
              else
                PWordArray(p)[x] := 0;
            end;
          end;
        24: begin
            if (y2 >= 0) and (y2 < Height) and (x2 >= 0) and (x2 < Width) then begin
              P3ByteArray(p2) := ScanLine[y2];
              P3ByteArray(p)[x] := P3ByteArray(p2)[Width - x2];
            end else begin
              if P3ByteArray(p)[x][0] > 4 then
                P3ByteArray(p)[x][0] := P3ByteArray(p)[x][0] - 4
              else if P3ByteArray(p)[x][1] > 4 then
                P3ByteArray(p)[x][1] := P3ByteArray(p)[x][1] - 4
              else if P3ByteArray(p)[x][2] > 4 then
                P3ByteArray(p)[x][2] := P3ByteArray(p)[x][2] - 4
              else begin
                P3ByteArray(p)[x][0] := 0;
                P3ByteArray(p)[x][1] := 0;
                P3ByteArray(p)[x][2] := 0;
              end;
            end;
          end;
        32: begin
            if (y2 >= 0) and (y2 < Height) and (x2 >= 0) and (x2 < Width) then begin
              plongarray(p2) := ScanLine[y2];
              plongarray(p)[x] := plongarray(p2)[Width - x2];
            end else begin
              if plongarray(p)[x] > 4 then
                plongarray(p)[x] := plongarray(p)[x] - 4
              else
                plongarray(p)[x] := 0;
            end;
          end;
      end
    end;
  end;
end;

function TDIB.Ink(DIB: TDIB; const SprayInit: Boolean; const AmountSpray: Integer): Boolean;
type
  T3Byte = array[0..2] of Byte;
  P3ByteArray = ^T3ByteArray;
  T3ByteArray = array[0..32767] of T3Byte;
  PLongArray = ^TLongArray;
  TLongArray = array[0..32767] of LongInt;
  function ColorToRGBTriple(const Color: TColor): TRGBTriple;
  begin
    with RESULT do
    begin
      rgbtRed := GetRValue(Color);
      rgbtGreen := GetGValue(Color);
      rgbtBlue := GetBValue(Color)
    end
  end {ColorToRGBTriple};

  function TestQuad(T: T3Byte; Color: Integer): Boolean;
  begin
    Result := (T[0] > GetRValue(Color)) and
      (T[1] > GetGValue(Color)) and
      (T[2] > GetBValue(Color))
  end;
var
  p0, p, p2: PByteArray;
  x, y, c: Integer;
  z: Integer;
begin
  if SprayInit then begin
    DIB.Assign(Self);
    { Spray seeds }
    for c := 0 to AmountSpray do begin
      DIB.Pixels[Random(Width - 1), Random(Height - 1)] := 0;
    end;
  end;
  Result := True; {all is black}
  for y := 0 to DIB.Height - 1 do begin
    p := DIB.ScanLine[y];
    for x := 0 to DIB.Width - 1 do begin
      case bitcount of
        8: begin
            if p[x] < 16 then begin
              if p[x] > 0 then Result := False;
              if y > 0 then begin
                p0 := DIB.ScanLine[y - 1];
                if p0[x] > 4 then
                  p0[x] := p0[x] - 4
                else
                  p0[x] := 0;
                if x > 0 then
                  if p0[x - 1] > 2 then
                    p0[x - 1] := p0[x - 1] - 2
                  else
                    p0[x - 1] := 0;
                if x < (DIB.Width - 1) then
                  if p0[x + 1] > 2 then
                    p0[x + 1] := p0[x + 1] - 2
                  else
                    p0[x + 1] := 0;
              end;
              if y < (DIB.Height - 1) then begin
                p2 := DIB.ScanLine[y + 1];
                if p2[x] > 4 then
                  p2[x] := p2[x] - 4
                else
                  p2[x] := 0;
                if x > 0 then
                  if p2[x - 1] > 2 then
                    p2[x - 1] := p2[x - 1] - 2
                  else
                    p2[x - 1] := 0;
                if x < (DIB.Width - 1) then
                  if p2[x + 1] > 2 then
                    p2[x + 1] := p2[x + 1] - 2
                  else
                    p2[x + 1] := 0;
              end;
              if p[x] > 8 then
                p[x] := p[x] - 8
              else
                p[x] := 0;
              if x > 0 then
                if p[x - 1] > 4 then
                  p[x - 1] := p[x - 1] - 4
                else
                  p[x - 1] := 0;
              if x < (DIB.Width - 1) then
                if p[x + 1] > 4 then
                  p[x + 1] := p[x + 1] - 4
                else
                  p[x + 1] := 0;
            end;
          end;
        16: begin
            if pwordarray(p)[x] < 16 then begin
              if pwordarray(p)[x] > 0 then Result := False;
              if y > 0 then begin
                pwordarray(p0) := DIB.ScanLine[y - 1];
                if pwordarray(p0)[x] > 4 then
                  pwordarray(p0)[x] := pwordarray(p0)[x] - 4
                else
                  pwordarray(p0)[x] := 0;
                if x > 0 then
                  if pwordarray(p0)[x - 1] > 2 then
                    pwordarray(p0)[x - 1] := pwordarray(p0)[x - 1] - 2
                  else
                    pwordarray(p0)[x - 1] := 0;
                if x < (DIB.Width - 1) then
                  if pwordarray(p0)[x + 1] > 2 then
                    pwordarray(p0)[x + 1] := pwordarray(p0)[x + 1] - 2
                  else
                    pwordarray(p0)[x + 1] := 0;
              end;
              if y < (DIB.Height - 1) then begin
                pwordarray(p2) := DIB.ScanLine[y + 1];
                if pwordarray(p2)[x] > 4 then
                  pwordarray(p2)[x] := pwordarray(p2)[x] - 4
                else
                  pwordarray(p2)[x] := 0;
                if x > 0 then
                  if pwordarray(p2)[x - 1] > 2 then
                    pwordarray(p2)[x - 1] := pwordarray(p2)[x - 1] - 2
                  else
                    pwordarray(p2)[x - 1] := 0;
                if x < (DIB.Width - 1) then
                  if pwordarray(p2)[x + 1] > 2 then
                    pwordarray(p2)[x + 1] := pwordarray(p2)[x + 1] - 2
                  else
                    pwordarray(p2)[x + 1] := 0;
              end;
              if pwordarray(p)[x] > 8 then
                pwordarray(p)[x] := pwordarray(p)[x] - 8
              else
                pwordarray(p)[x] := 0;
              if x > 0 then
                if pwordarray(p)[x - 1] > 4 then
                  pwordarray(p)[x - 1] := pwordarray(p)[x - 1] - 4
                else
                  pwordarray(p)[x - 1] := 0;
              if x < (DIB.Width - 1) then
                if pwordarray(p)[x + 1] > 4 then
                  pwordarray(p)[x + 1] := pwordarray(p)[x + 1] - 4
                else
                  pwordarray(p)[x + 1] := 0;
            end;
          end;
        24: begin
            if not TestQuad(P3ByteArray(p)[x], 16) then begin
              if TestQuad(P3ByteArray(p)[x], 0) then Result := False;
              if y > 0 then begin
                P3ByteArray(p0) := DIB.ScanLine[y - 1];
                if TestQuad(P3ByteArray(p0)[x], 4) then begin
                  for z := 0 to 2 do
                    if P3ByteArray(p0)[x][z] > 4 then
                      P3ByteArray(p0)[x][z] := P3ByteArray(p0)[x][z] - 4
                end
                else
                  for z := 0 to 2 do
                    P3ByteArray(p0)[x][z] := 0;
                if x > 0 then
                  if TestQuad(P3ByteArray(p0)[x - 1], 2) then begin
                    for z := 0 to 2 do
                      if P3ByteArray(p0)[x - 1][z] > 2 then
                        P3ByteArray(p0)[x - 1][z] := P3ByteArray(p0)[x - 1][z] - 2
                  end
                  else
                    for z := 0 to 2 do
                      P3ByteArray(p0)[x - 1][z] := 0;
                if x < (DIB.Width - 1) then
                  if TestQuad(P3ByteArray(p0)[x + 1], 2) then begin
                    for z := 0 to 2 do
                      if P3ByteArray(p0)[x + 1][z] > 2 then
                        P3ByteArray(p0)[x + 1][z] := P3ByteArray(p0)[x + 1][z] - 2
                  end
                  else
                    for z := 0 to 2 do
                      P3ByteArray(p0)[x + 1][z] := 0;
              end;
              if y < (DIB.Height - 1) then begin
                P3ByteArray(p2) := DIB.ScanLine[y + 1];
                if TestQuad(P3ByteArray(p2)[x], 4) then begin
                  for z := 0 to 2 do
                    if P3ByteArray(p2)[x][z] > 4 then
                      P3ByteArray(p2)[x][z] := P3ByteArray(p2)[x][z] - 4
                end
                else
                  for z := 0 to 2 do
                    P3ByteArray(p2)[x][z] := 0;
                if x > 0 then
                  if TestQuad(P3ByteArray(p2)[x - 1], 2) then begin
                    for z := 0 to 2 do
                      if P3ByteArray(p2)[x - 1][z] > 2 then
                        P3ByteArray(p2)[x - 1][z] := P3ByteArray(p2)[x - 1][z] - 2
                  end
                  else
                    for z := 0 to 2 do
                      P3ByteArray(p2)[x - 1][z] := 0;
                if x < (DIB.Width - 1) then
                  if TestQuad(P3ByteArray(p2)[x + 1], 2) then begin
                    for z := 0 to 2 do
                      if P3ByteArray(p2)[x + 1][z] > 2 then
                        P3ByteArray(p2)[x + 1][z] := P3ByteArray(p2)[x + 1][z] - 2
                  end
                  else
                    for z := 0 to 2 do
                      P3ByteArray(p2)[x + 1][z] := 0;
              end;
              if TestQuad(P3ByteArray(p)[x], 8) then begin
                for z := 0 to 2 do
                  if P3ByteArray(p)[x][z] > 8 then
                    P3ByteArray(p)[x][z] := P3ByteArray(p)[x][z] - 8
              end
              else
                for z := 0 to 2 do
                  P3ByteArray(p)[x][z] := 0;
              if x > 0 then
                if TestQuad(P3ByteArray(p)[x - 1], 4) then begin
                  for z := 0 to 2 do
                    if P3ByteArray(p)[x - 1][z] > 4 then
                      P3ByteArray(p)[x - 1][z] := P3ByteArray(p)[x - 1][z] - 4
                end
                else
                  for z := 0 to 2 do
                    P3ByteArray(p)[x - 1][z] := 0;
              if x < (DIB.Width - 1) then
                if TestQuad(P3ByteArray(p)[x + 1], 4) then begin
                  for z := 0 to 2 do
                    if P3ByteArray(p)[x + 1][z] > 4 then
                      P3ByteArray(p)[x + 1][z] := P3ByteArray(p)[x + 1][z] - 4
                end
                else
                  for z := 0 to 2 do
                    P3ByteArray(p)[x + 1][z] := 0;
            end;
          end;
        32: begin
            if plongarray(p)[x] < 16 then begin
              if plongarray(p)[x] > 0 then Result := False;
              if y > 0 then begin
                plongarray(p0) := DIB.ScanLine[y - 1];
                if plongarray(p0)[x] > 4 then
                  plongarray(p0)[x] := plongarray(p0)[x] - 4
                else
                  plongarray(p0)[x] := 0;
                if x > 0 then
                  if plongarray(p0)[x - 1] > 2 then
                    plongarray(p0)[x - 1] := plongarray(p0)[x - 1] - 2
                  else
                    plongarray(p0)[x - 1] := 0;
                if x < (DIB.Width - 1) then
                  if plongarray(p0)[x + 1] > 2 then
                    plongarray(p0)[x + 1] := plongarray(p0)[x + 1] - 2
                  else
                    plongarray(p0)[x + 1] := 0;
              end;
              if y < (DIB.Height - 1) then begin
                plongarray(p2) := DIB.ScanLine[y + 1];
                if plongarray(p2)[x] > 4 then
                  plongarray(p2)[x] := plongarray(p2)[x] - 4
                else
                  plongarray(p2)[x] := 0;
                if x > 0 then
                  if plongarray(p2)[x - 1] > 2 then
                    plongarray(p2)[x - 1] := plongarray(p2)[x - 1] - 2
                  else
                    plongarray(p2)[x - 1] := 0;
                if x < (DIB.Width - 1) then
                  if plongarray(p2)[x + 1] > 2 then
                    plongarray(p2)[x + 1] := plongarray(p2)[x + 1] - 2
                  else
                    plongarray(p2)[x + 1] := 0;
              end;
              if plongarray(p)[x] > 8 then
                plongarray(p)[x] := plongarray(p)[x] - 8
              else
                plongarray(p)[x] := 0;
              if x > 0 then
                if plongarray(p)[x - 1] > 4 then
                  plongarray(p)[x - 1] := plongarray(p)[x - 1] - 4
                else
                  plongarray(p)[x - 1] := 0;
              if x < (DIB.Width - 1) then
                if plongarray(p)[x + 1] > 4 then
                  plongarray(p)[x + 1] := plongarray(p)[x + 1] - 4
                else
                  plongarray(p)[x + 1] := 0;
            end;
          end;
      end {case};
    end;
  end;
end;

procedure TDIB.Distort(DIB1: TDIB; dt: TDistortType; xc, yc, b: Integer; factor: Real);
type
  T3Byte = array[0..2] of Byte;
  P3ByteArray = ^T3ByteArray;
  T3ByteArray = array[0..32767] of T3Byte;
  PLongArray = ^TLongArray;
  TLongArray = array[0..32767] of LongInt;
var
  p, p2: PByteArray;
  x, y, x2, y2, angle, ysqr: Integer;
  actdist, dist, cosy, siny: real;
begin
  dist := factor * sqrt(sqr(xc) + sqr(yc));
  for y := 0 to DIB1.Height - 1 do begin
    p := DIB1.ScanLine[y];
    ysqr := sqr(y - yc);
    for x := 0 to (DIB1.Width) - 1 do begin
      actdist := (sqrt((sqr(x - xc) + ysqr)) / dist);
      if dt = dtSlow then
        actdist := dsin((Trunc(actdist * 1024)) and $1FF);
      angle := 384 + Trunc((actdist) * b);

      cosy := (y - yc) * dcos(angle and $1FF);
      siny := (y - yc) * dsin(angle and $1FF);

      x2 := Trunc((x - xc) * dsin(angle and $1FF) + cosy) + xc;
      y2 := Trunc((x - xc) * dcos(angle and $1FF) - siny) + yc;
      case bitcount of
        8: begin
            if (y2 >= 0) and (y2 < Height) and (x2 >= 0) and (x2 < Width) then begin
              p2 := ScanLine[y2];
              p[x] := p2[Width - x2];
            end else begin
              if p[x] > 2 then
                p[x] := p[x] - 2
              else
                p[x] := 0;
            end;
          end;
        16: begin
            if (y2 >= 0) and (y2 < Height) and (x2 >= 0) and (x2 < Width) then begin
              pwordarray(p2) := ScanLine[y2];
              pwordarray(p)[x] := pwordarray(p2)[Width - x2];
            end else begin
              if pwordarray(p)[x] > 2 then
                pwordarray(p)[x] := pwordarray(p)[x] - 2
              else
                pwordarray(p)[x] := 0;
            end;
          end;
        24: begin
            if (y2 >= 0) and (y2 < Height) and (x2 >= 0) and (x2 < Width) then begin
              P3ByteArray(p2) := ScanLine[y2];
              P3ByteArray(p)[x] := P3ByteArray(p2)[Width - x2];
            end else begin
              if P3ByteArray(p)[x][0] > 2 then
                P3ByteArray(p)[x][0] := P3ByteArray(p)[x][0] - 2
              else if P3ByteArray(p)[x][1] > 2 then
                P3ByteArray(p)[x][1] := P3ByteArray(p)[x][1] - 2
              else if P3ByteArray(p)[x][2] > 2 then
                P3ByteArray(p)[x][2] := P3ByteArray(p)[x][2] - 2
              else begin
                P3ByteArray(p)[x][0] := 0;
                P3ByteArray(p)[x][1] := 0;
                P3ByteArray(p)[x][2] := 0;
              end;
            end;
          end;
        32: begin
            if (y2 >= 0) and (y2 < Height) and (x2 >= 0) and (x2 < Width) then begin
              plongarray(p2) := ScanLine[y2];
              plongarray(p)[x] := plongarray(p2)[Width - x2];
            end else begin
              if p[x] > 2 then
                plongarray(p)[x] := plongarray(p)[x] - 2
              else
                plongarray(p)[x] := 0;
            end;
          end;
      end {case}
    end;
  end;
end;

procedure TDIB.AntialiasedLine(x1, y1, x2, y2: integer; color: TColor);
//anti-aliased line using the Wu algorithm by Peter Bone
var
  dX, dY, X, Y, start, finish: integer;
  LM, LR: integer;
  dxi, dyi, dydxi: integer;
  P: PLines;
  R, G, B: byte;
begin
  R := GetRValue(Color);
  G := GetGValue(Color);
  B := GetBValue(Color);
  dX := abs(x2 - x1); // Calculate deltax and deltay for initialisation
  dY := abs(y2 - y1);
  if (dX = 0) or (dY = 0) then begin
    Canvas.Pen.Color := (B shl 16) + (G shl 8) + R;
    Canvas.MoveTo(x1, y1);
    Canvas.LineTo(x2, y2);
    exit;
  end;
  if dX > dY then begin // horizontal or vertical
    if y2 > y1 then // determine rise and run
      dydxi := -dY shl 16 div dX
    else
      dydxi := dY shl 16 div dX;
    if x2 < x1 then begin
      start := x2; // right to left
      finish := x1;
      dyi := y2 shl 16;
    end else begin
      start := x1; // left to right
      finish := x2;
      dyi := y1 shl 16;
      dydxi := -dydxi; // inverse slope
    end;
    if finish >= Width then finish := Width - 1;
    for X := start to finish do begin
      Y := dyi shr 16;
      if (X < 0) or (Y < 0) or (Y > Height - 2) then begin
        Inc(dyi, dydxi);
        Continue;
      end;
      LM := dyi - Y shl 16; // fractional part of dyi - in fixed-point
      LR := 65536 - LM;
      P := Scanline[Y];
      P^[X].B := (B * LR + P^[X].B * LM) shr 16;
      P^[X].G := (G * LR + P^[X].G * LM) shr 16;
      P^[X].R := (R * LR + P^[X].R * LM) shr 16;
      Inc(Y);
      P^[X].B := (B * LM + P^[X].B * LR) shr 16;
      P^[X].G := (G * LM + P^[X].G * LR) shr 16;
      P^[X].R := (R * LM + P^[X].R * LR) shr 16;
      Inc(dyi, dydxi); // next point
    end;
  end else begin
    if x2 > x1 then // determine rise and run
      dydxi := -dX shl 16 div dY
    else
      dydxi := dX shl 16 div dY;
    if y2 < y1 then begin
      start := y2; // right to left
      finish := y1;
      dxi := x2 shl 16;
    end else begin
      start := y1; // left to right
      finish := y2;
      dxi := x1 shl 16;
      dydxi := -dydxi; // inverse slope
    end;
    if finish >= Height then finish := Height - 1;
    for Y := start to finish do begin
      X := dxi shr 16;
      if (Y < 0) or (X < 0) or (X > Width - 2) then begin
        Inc(dxi, dydxi);
        Continue;
      end;
      LM := dxi - X shl 16;
      LR := 65536 - LM;
      P := Scanline[Y];
      P^[X].B := (B * LR + P^[X].B * LM) shr 16;
      P^[X].G := (G * LR + P^[X].G * LM) shr 16;
      P^[X].R := (R * LR + P^[X].R * LM) shr 16;
      Inc(X);
      P^[X].B := (B * LM + P^[X].B * LR) shr 16;
      P^[X].G := (G * LM + P^[X].G * LR) shr 16;
      P^[X].R := (R * LM + P^[X].R * LR) shr 16;
      Inc(dxi, dydxi); // next point
    end;
  end;
end;

function TDIB.GetColorBetween(StartColor, EndColor: TColor; Pointvalue,
  FromPoint, ToPoint: Extended): TColor;
var F: Extended; r1, r2, r3, g1, g2, g3, b1, b2, b3: Byte;
  function CalcColorBytes(fb1, fb2: Byte): Byte;
  begin
    result := fb1;
    if fb1 < fb2 then Result := FB1 + Trunc(F * (fb2 - fb1));
    if fb1 > fb2 then Result := FB1 - Trunc(F * (fb1 - fb2));
  end;
begin
  if Pointvalue <= FromPoint then begin
    result := StartColor;
    exit;
  end;
  if Pointvalue >= ToPoint then begin
    result := EndColor;
    exit;
  end;
  F := (Pointvalue - FromPoint) / (ToPoint - FromPoint);
  asm
    mov EAX, Startcolor
    cmp EAX, EndColor
    je @@exit  //when equal then exit
    mov r1, AL
    shr EAX,8
    mov g1, AL
    shr EAX,8
    mov b1, AL
    mov EAX, Endcolor
    mov r2, AL
    shr EAX,8
    mov g2, AL
    shr EAX,8
    mov b2, AL
    push ebp
    mov AL, r1
    mov DL, r2
    call CalcColorBytes
    pop ECX
    push EBP
    Mov r3, AL
    mov DL, g2
    mov AL, g1
    call CalcColorBytes
    pop ECX
    push EBP
    mov g3, Al
    mov DL, B2
    mov Al, B1
    call CalcColorBytes
    pop ECX
    mov b3, AL
    XOR EAX,EAX
    mov AL, B3
    shl EAX,8
    mov AL, G3
    shl EAX,8
    mov AL, R3
  @@Exit:
    mov @result, EAX
  end;
end;

procedure TDIB.ColoredLine(const iStart, iEnd: TPoint; iColorStyle: TColorLineStyle;
  iGradientFrom, iGradientTo: TColor; iPixelGeometry: TColorLinePixelGeometry; iRadius: Word);
var
  tempColor: TColor;
const
  WavelengthMinimum = 380;
  WavelengthMaximum = 780;

  procedure SetColor(Color:  TColor);
  begin
    Canvas.Pen.Color   := Color;
    Canvas.Brush.Color := Color;
    tempColor           := Color
  end {SetColor};

  function WL2RGB(const Wavelength: Double): TColor;
  const
    Gamma = 0.80;
    IntensityMax = 255;
  var
    Red, Blue, Green, Factor: Double;
    R, G, B: Byte;

    function Adjust(const Color, Factor: Double): Integer;
    begin
      if Color = 0.0 then Result := 0
      else Result := Round(IntensityMax * Power(Color * Factor, Gamma))
    end {Adjust};
  begin
    case Trunc(Wavelength) of
      380..439:
        begin
          Red := -(Wavelength - 440) / (440 - 380);
          Green := 0.0;
          Blue := 1.0
        end;
      440..489:
        begin
          Red := 0.0;
          Green := (Wavelength - 440) / (490 - 440);
          Blue := 1.0
        end;
      490..509:
        begin
          Red := 0.0;
          Green := 1.0;
          Blue := -(Wavelength - 510) / (510 - 490)
        end;
      510..579:
        begin
          Red := (Wavelength - 510) / (580 - 510);
          Green := 1.0;
          Blue := 0.0
        end;
      580..644:
        begin
          Red := 1.0;
          Green := -(Wavelength - 645) / (645 - 580);
          Blue := 0.0
        end;
      645..780:
        begin
          Red := 1.0;
          Green := 0.0;
          Blue := 0.0
        end;
    else
      Red := 0.0;
      Green := 0.0;
      Blue := 0.0
    end;
    case Trunc(Wavelength) of
      380..419: factor := 0.3 + 0.7 * (Wavelength - 380) / (420 - 380);
      420..700: factor := 1.0;
      701..780: factor := 0.3 + 0.7 * (780 - Wavelength) / (780 - 700)
    else
      factor := 0.0
    end;
    Result := RGB(Adjust(Red, Factor), Adjust(Green, Factor), Adjust(Blue, Factor));
  end;

  function Rainbow(const fraction: Double): TColor;
  begin
    if (fraction < 0.0) or (fraction > 1.0) then Result := clBlack
    else
      Result := WL2RGB(WavelengthMinimum + Fraction * (WavelengthMaximum - WavelengthMinimum))
  end {Raindbow};

  function ColorInterpolate(const fraction: Double; const Color1, Color2: TColor): TColor;
  var
    complement: Double;
    R1, R2, G1, G2, B1, B2: BYTE;
  begin
    if fraction <= 0 then Result := Color1
    else
      if fraction >= 1.0 then Result := Color2
      else begin
        R1 := GetRValue(Color1);
        G1 := GetGValue(Color1);
        B1 := GetBValue(Color1);
        R2 := GetRValue(Color2);
        G2 := GetGValue(Color2);
        B2 := GetBValue(Color2);
        complement := 1.0 - fraction;
        Result := RGB(Round(complement * R1 + fraction * R2),
          Round(complement * G1 + fraction * G2),
          Round(complement * B1 + fraction * B2))
      end
  end {ColorInterpolate};

  // Conversion utility routines
  function ColorToRGBTriple(const Color: TColor): TRGBTriple;
  begin
    with Result do begin
      rgbtRed := GetRValue(Color);
      rgbtGreen := GetGValue(Color);
      rgbtBlue := GetBValue(Color)
    end
  end {ColorToRGBTriple};

  function RGBTripleToColor(const Triple: TRGBTriple): TColor;
  begin
    Result := RGB(Triple.rgbtRed, Triple.rgbtGreen, Triple.rgbtBlue)
  end {RGBTripleToColor};
// Bresenham's Line Algorithm.  Byte, March 1988, pp. 249-253.
var
  a, b, d, diag_inc, dXdg, dXndg, dYdg, dYndg, i, nDginc, nDswap, x, y: Integer;
begin {DrawLine}
  x := iStart.X;
  y := iStart.Y;
  a := iEnd.X - iStart.X;
  b := iEnd.Y - iStart.Y;
  if a < 0 then begin
    a := -a;
    dXdg := -1
  end
  else dXdg := 1;
  if b < 0 then begin
    b := -b;
    dYdg := -1
  end
  else dYdg := 1;
  if a < b then begin
    nDswap := a;
    a := b;
    b := nDswap;
    dXndg := 0;
    dYndg := dYdg
  end
  else begin
    dXndg := dXdg;
    dYndg := 0
  end;
  d := b + b - a;
  nDginc := b + b;
  diag_inc := b + b - a - a;
  for i := 0 to a do begin
    case iPixelGeometry of
      pgPoint:
        case iColorStyle of
          csSolid:
            Canvas.Pixels[x, y] := tempColor;
          csGradient:
            Canvas.Pixels[x, y] := ColorInterpolate(i / a, iGradientFrom, iGradientTo);
          csRainbow:
            Canvas.Pixels[x, y] := Rainbow(i / a)
        end;
      pgCircular:
        begin
          case iColorStyle of
            csSolid: ;
            csGradient: SetColor(ColorInterpolate(i / a, iGradientFrom, iGradientTo));
            csRainbow: SetColor(Rainbow(i / a))
          end;
          Canvas.Ellipse(x - iRadius, y - iRadius, x + iRadius, y + iRadius)
        end;
      pgRectangular:
        begin
          case iColorStyle of
            csSolid: ;
            csGradient: SetColor(ColorInterpolate(i / a, iGradientFrom, iGradientTo));
            csRainbow: SetColor(Rainbow(i / a))
          end;
          Canvas.Rectangle(x - iRadius, y - iRadius, x + iRadius, y + iRadius)
        end
    end;
    if d < 0 then begin
      Inc(x, dXndg);
      Inc(y, dYndg);
      Inc(d, nDginc);
    end
    else begin
      Inc(x, dXdg);
      Inc(y, dYdg);
      Inc(d, diag_inc);
    end
  end
end {Line};

initialization
  TPicture.RegisterClipBoardFormat(CF_DIB, TDIB);
  TPicture.RegisterFileFormat('dib', 'Device Independent Bitmap', TDIB);
finalization
  TPicture.UnRegisterGraphicClass(TDIB);

  FEmptyDIBImage.Free;
  FPaletteManager.Free;
end.