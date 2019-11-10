(*******************************************************************************
                       EXTEND UNIT DXDRAWS FROM DELPHIX PACK

 *  Copyright (c) 2004-2006 Jaro Benes
 *  All Rights Reserved
 *  Version 1.07
 *  D2D Hardware module
 *  web site: www.micrel.cz/Dx
 *  e-mail: delphix_d2d@micrel.cz

 * Enhanced by User137

 * DISCLAIMER:
   This software is provided "as is" and is without warranty of any kind.
   The author of this software does not warrant, guarantee or make any
   representations regarding the use or results of use of this software
   in terms of reliability, accuracy or fitness for purpose. You assume
   the entire risk of direct or indirect, consequential or inconsequential
   results from the correct or incorrect usage of this software even if the
   author has been informed of the possibilities of such damage. Neither
   the author nor anybody connected to this software in any way can assume
   any responsibility.

   Tested in Delphi 3, 4, 5, 6, 7 and Delphi 2005

 * FEATURES:
   a) Implement Hardware acceleration for critical function like DrawAlpha {Blend},
      DrawSub and DrawAdd for both way DXIMAGELIST and DIRECTDRAWSURFACE with rotation too.
   b) Automatic adjustement for texture size different 2^n.
   c) Minimum current source code change, all accelerated code added into:
      DXDraw.BeginScene;
      //code here
      DXDraw.EndScene;
   d) DelphiX facade continues using still.

 * HOW TO USE
   a) Design code like as DelphiX and drawing routine put into
      DXDraw.BeginScene;
      //code here
      DXDraw.EndScene;
   b) setup options in code or property for turn-on acceleration like:
      DXDraw.Finalize; {done DXDraw}
      If HardwareSwitch Then
      {hardware}
      Begin
        if NOT (doDirectX7Mode in DXDraw.Options) then
          DXDraw.Options := DXDraw.Options + [doDirectX7Mode];
        if NOT (doHardware in DXDraw.Options) then
          DXDraw.Options := DXDraw.Options + [doHardware];
        if NOT (do3D in DXDraw.Options) then
          DXDraw.Options := DXDraw.Options + [do3D];
        if doSystemMemory in DXDraw.Options then
          DXDraw.Options := DXDraw.Options - [doSystemMemory];
      End
      Else
      {software}
      Begin
        if doDirectX7Mode in DXDraw.Options then
          DXDraw.Options := DXDraw.Options - [doDirectX7Mode];
        if do3D in DXDraw.Options then
          DXDraw.Options := DXDraw.Options - [do3D];
        if doHardware in DXDraw.Options then
          DXDraw.Options := DXDraw.Options - [doHardware];
        if NOT (doSystemMemory in DXDraw.Options) then
          DXDraw.Options := DXDraw.Options + [doSystemMemory];
      End;
      {to fullscreen}
      if doFullScreen in DXDraw.Options then
      begin
        RestoreWindow;
        DXDraw.Cursor := crDefault;
        BorderStyle := bsSingle;
        DXDraw.Options := DXDraw.Options - [doFullScreen];
        DXDraw.Options := DXDraw.Options + [doFlip];
      end else
      begin
        StoreWindow;
        DXDraw.Cursor := crNone;
        BorderStyle := bsNone;
        DXDraw.Options := DXDraw.Options + [doFullScreen];
        DXDraw.Options := DXDraw.Options - [doFlip];
      end;
      DXDraw1.Initialize; {up DXDraw now}

 * NOTE Main form has to declare like:
      TForm1 = class(TDXForm)

 * KNOWN BUGS OR RESTRICTION:
   1/ Cannot be use DirectDrawSurface other from DXDraw.Surface in HW mode.
   2/ New functions was not tested for two and more DXDraws on form. Sorry.

 ******************************************************************************)
unit DXDraws;

interface

{$INCLUDE DelphiXcfg.inc}
{.$DEFINE DXTextureImage_UseZLIB}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
{$IFDEF DXTextureImage_UseZLIB}ZLIB, {$ENDIF}
  DXClass, DIB,
{$IFDEF StandardDX}
  DirectDraw, DirectSound,
  {from DX7}Direct3D, Direct3DRM,
{$IFDEF DX9}
  Direct3D9, Direct3D, D3DX9, {Direct3D8,} DX7toDX8;
{$ELSE}
{$IFDEF DX81}
  D3DX8, DirectInput8, DirectXGraphics, DX7toDX8;
{$ELSE}
  DirectInput;
{$ENDIF}
{$ENDIF}
{$ELSE}
  DirectX;
{$ENDIF}


const
  maxTexBlock = 2048;
  maxVideoBlockSize = 2048;

  DXTextureImageGroupType_Normal = 0; // Normal group
  DXTextureImageGroupType_Mipmap = 1; // Mipmap group

  Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ"at  0123456789<>=()-''!_+\/{}^&%.=$#ÅÖÄ?*';
  PowerAlphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`1234567890-=~!@#$%^&*()_+[];'',./\{}:"<>?|©®™ ';
  ccDefaultSpecular = $FFFFFFFF;

  ZeroRect: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);

type

  {  TRenderType  }

  TRenderType = (rtDraw, rtBlend, rtAdd, rtSub);

  {  EDirectDrawError  }

  EDirectDrawError = class(EDirectXError);
  EDirectDrawPaletteError = class(EDirectDrawError);
  EDirectDrawClipperError = class(EDirectDrawError);
  EDirectDrawSurfaceError = class(EDirectDrawError);

  {  TDirectDraw  }

  TDirectDrawClipper = class;
  TDirectDrawPalette = class;
  TDirectDrawSurface = class;

  TDirectDraw = class(TDirectX)
  private
    FIDDraw: IDirectDraw;
    FIDDraw4: IDirectDraw4;
    FIDDraw7: IDirectDraw7;
    FDriverCaps: TDDCaps;
    FHELCaps: TDDCaps;
    FClippers: TList;
    FPalettes: TList;
    FSurfaces: TList;
    function GetClipper(Index: Integer): TDirectDrawClipper;
    function GetClipperCount: Integer;
    function GetDisplayMode: TDDSurfaceDesc;
    function GetIDDraw: IDirectDraw;
    function GetIDDraw4: IDirectDraw4;
    function GetIDDraw7: IDirectDraw7;
    function GetIDraw: IDirectDraw;
    function GetIDraw4: IDirectDraw4;
    function GetIDraw7: IDirectDraw7;
    function GetPalette(Index: Integer): TDirectDrawPalette;
    function GetPaletteCount: Integer;
    function GetSurface(Index: Integer): TDirectDrawSurface;
    function GetSurfaceCount: Integer;
  public
    constructor Create(GUID: PGUID);
    constructor CreateEx(GUID: PGUID; DirectX7Mode: Boolean);
    destructor Destroy; override;
    class function Drivers: TDirectXDrivers;
    property ClipperCount: Integer read GetClipperCount;
    property Clippers[Index: Integer]: TDirectDrawClipper read GetClipper;
    property DisplayMode: TDDSurfaceDesc read GetDisplayMode;
    property DriverCaps: TDDCaps read FDriverCaps;
    property HELCaps: TDDCaps read FHELCaps;
    property IDDraw: IDirectDraw read GetIDDraw;
    property IDDraw4: IDirectDraw4 read GetIDDraw4;
    property IDDraw7: IDirectDraw7 read GetIDDraw7;
    property IDraw: IDirectDraw read GetIDraw;
    property IDraw4: IDirectDraw4 read GetIDraw4;
    property IDraw7: IDirectDraw7 read GetIDraw7;
    property PaletteCount: Integer read GetPaletteCount;
    property Palettes[Index: Integer]: TDirectDrawPalette read GetPalette;
    property SurfaceCount: Integer read GetSurfaceCount;
    property Surfaces[Index: Integer]: TDirectDrawSurface read GetSurface;
  end;

  {  TDirectDrawClipper  }

  TDirectDrawClipper = class(TDirectX)
  private
    FDDraw: TDirectDraw;
    FIDDClipper: IDirectDrawClipper;
    function GetIDDClipper: IDirectDrawClipper;
    function GetIClipper: IDirectDrawClipper;
    procedure SetHandle(Value: THandle);
    procedure SetIDDClipper(Value: IDirectDrawClipper);
    property Handle: THandle write SetHandle;
  public
    constructor Create(ADirectDraw: TDirectDraw);
    destructor Destroy; override;
    procedure SetClipRects(const Rects: array of TRect);
    property DDraw: TDirectDraw read FDDraw;
    property IClipper: IDirectDrawClipper read GetIClipper;
    property IDDClipper: IDirectDrawClipper read GetIDDClipper write SetIDDClipper;
  end;

  {  TDirectDrawPalette  }

  TDirectDrawPalette = class(TDirectX)
  private
    FDDraw: TDirectDraw;
    FIDDPalette: IDirectDrawPalette;
    function GetEntry(Index: Integer): TPaletteEntry;
    function GetIDDPalette: IDirectDrawPalette;
    function GetIPalette: IDirectDrawPalette;
    procedure SetEntry(Index: Integer; Value: TPaletteEntry);
    procedure SetIDDPalette(Value: IDirectDrawPalette);
  public
    constructor Create(ADirectDraw: TDirectDraw);
    destructor Destroy; override;
    function CreatePalette(Caps: DWORD; const Entries): Boolean;
    function GetEntries(StartIndex, NumEntries: Integer; var Entries): Boolean;
    procedure LoadFromDIB(DIB: TDIB);
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
    function SetEntries(StartIndex, NumEntries: Integer; const Entries): Boolean;
    property DDraw: TDirectDraw read FDDraw;
    property Entries[Index: Integer]: TPaletteEntry read GetEntry write SetEntry;
    property IDDPalette: IDirectDrawPalette read GetIDDPalette write SetIDDPalette;
    property IPalette: IDirectDrawPalette read GetIPalette;
  end;

  {  TDirectDrawSurfaceCanvas  }

  TDirectDrawSurfaceCanvas = class(TCanvas)
  private
    FDC: HDC;
    FSurface: TDirectDrawSurface;
  protected
    procedure CreateHandle; override;
  public
    constructor Create(ASurface: TDirectDrawSurface);
    destructor Destroy; override;
    procedure Release;
  end;

  {  TDirectDrawSurface  }

  TDirectDrawSurface = class(TDirectX)
  private
    FCanvas: TDirectDrawSurfaceCanvas;
    FHasClipper: Boolean;
    FDDraw: TDirectDraw;
    FIDDSurface: IDirectDrawSurface;
    FIDDSurface4: IDirectDrawSurface4;
    FIDDSurface7: IDirectDrawSurface7;
    FSystemMemory: Boolean;
    FStretchDrawClipper: IDirectDrawClipper;
    FSurfaceDesc: TDDSurfaceDesc;
    FGammaControl: IDirectDrawGammaControl;
    FLockSurfaceDesc: TDDSurfaceDesc;
    FLockCount: Integer;
    FIsLocked: Boolean;
    function GetBitCount: Integer;
    function GetCanvas: TDirectDrawSurfaceCanvas;
    function GetClientRect: TRect;
    function GetHeight: Integer;
    function GetIDDSurface: IDirectDrawSurface;
    function GetIDDSurface4: IDirectDrawSurface4;
    function GetIDDSurface7: IDirectDrawSurface7;
    function GetISurface: IDirectDrawSurface;
    function GetISurface4: IDirectDrawSurface4;
    function GetISurface7: IDirectDrawSurface7;
    function GetPixel(X, Y: Integer): Longint;
    function GetWidth: Integer;
    procedure SetClipper(Value: TDirectDrawClipper);
    procedure SetColorKey(Flags: DWORD; const Value: TDDColorKey);
    procedure SetIDDSurface(Value: IDirectDrawSurface);
    procedure SetIDDSurface4(Value: IDirectDrawSurface4);
    procedure SetIDDSurface7(Value: IDirectDrawSurface7);
    procedure SetPalette(Value: TDirectDrawPalette);
    procedure SetPixel(X, Y: Integer; Value: Longint);
    procedure SetTransparentColor(Col: Longint);
    {support RGB routines}
    procedure LoadRGB(Color: cardinal; var R, G, B: Byte);
    function SaveRGB(const R, G, B: Byte): cardinal;
    {asm routine for direct surface by pixel}
    {no clipping}
    function GetPixel16(x, y: integer): integer; register;
    function GetPixel24(x, y: integer): integer; register;
    function GetPixel32(x, y: integer): integer; register;
    function GetPixel8(x, y: integer): integer; register;
    procedure PutPixel16(x, y, color: integer); register;
    procedure PutPixel24(x, y, color: integer); register;
    procedure PutPixel32(x, y, color: integer); register;
    procedure PutPixel8(x, y, color: integer); register;
    {routines calls asm pixel routine}
    function Peek(X, Y: Integer): LongInt;
    procedure Poke(X, Y: Integer; const Value: LongInt);
  public
    constructor Create(ADirectDraw: TDirectDraw);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignTo(Dest: TPersistent); override;
    function Blt(const DestRect, SrcRect: TRect; Flags: DWORD;
      const DF: TDDBltFX; Source: TDirectDrawSurface): Boolean;
    function BltFast(X, Y: Integer; const SrcRect: TRect;
      Flags: DWORD; Source: TDirectDrawSurface): Boolean;
    function ColorMatch(Col: TColor): Integer;
{$IFDEF DelphiX_Spt4}
    function CreateSurface(SurfaceDesc: TDDSurfaceDesc): Boolean; overload;
    function CreateSurface(SurfaceDesc: TDDSurfaceDesc2): Boolean; overload;
{$ELSE}
    function CreateSurface(SurfaceDesc: TDDSurfaceDesc): Boolean;
{$ENDIF}
{$IFDEF DelphiX_Spt4}
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDirectDrawSurface; Transparent: Boolean = True); overload;
    procedure Draw(X, Y: Integer; Source: TDirectDrawSurface; Transparent: Boolean = True); overload;
    procedure StretchDraw(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean = True); overload;
    procedure StretchDraw(const DestRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean = True); overload;
{$ELSE}
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean);
    procedure StretchDraw(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean);
{$ENDIF}
    procedure DrawAdd(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawAlpha(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Alpha: Integer);
    procedure DrawSub(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});

    procedure DrawAddCol(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Color, Alpha: Integer);
    procedure DrawAlphaCol(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Color, Alpha: Integer);
    procedure DrawSubCol(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Color, Alpha: Integer);

    {Rotate}
    procedure DrawRotate(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single);
    procedure DrawRotateAdd(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateAlpha(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single;
      Alpha: Integer);
    procedure DrawRotateSub(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});

    procedure DrawRotateAddCol(X, Y, Width, Height: Integer;
      const SrcRect: TRect; Source: TDirectDrawSurface; CenterX,
      CenterY: Double; Transparent: Boolean; Angle: Single; Color: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateAlphaCol(X, Y, Width, Height: Integer;
      const SrcRect: TRect; Source: TDirectDrawSurface; CenterX,
      CenterY: Double; Transparent: Boolean; Angle: Single; Color: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateCol(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; CenterX, CenterY: Double;
      Transparent: Boolean; Angle: Single; Color: Integer);
    procedure DrawRotateSubCol(X, Y, Width, Height: Integer;
      const SrcRect: TRect; Source: TDirectDrawSurface; CenterX,
      CenterY: Double; Transparent: Boolean; Angle: Single; Color: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    {WaveX}
    procedure DrawWaveX(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer);
    procedure DrawWaveXAdd(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveXAlpha(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveXSub(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    {WaveY}
    procedure DrawWaveY(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer);
    procedure DrawWaveYAdd(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveYAlpha(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveYSub(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    {Poke function}
    procedure PokeLine(X1, Y1, X2, Y2: Integer; Color: cardinal);
    procedure PokeLinePolar(x, y: integer; angle, length: extended;
      Color: cardinal);
    procedure PokeBox(xs, ys, xd, yd: Integer; Color: cardinal);
    procedure PokeBlendPixel(const X, Y: Integer; aColor: cardinal;
      Alpha: byte);
    procedure PokeWuLine(X1, Y1, X2, Y2, aColor: Integer);
    procedure Noise(Oblast: TRect; Density: Byte);
    procedure Blur;
    procedure DoRotate(cent1, cent2, angle: Integer; coord1, coord2: Real;
      color: word);
    procedure PokeCircle(X, Y, Radius, Color: integer);
    procedure PokeEllipse(exc, eyc, ea, eb, angle, color: Integer);
    procedure PokeFilledEllipse(exc, eyc, ea, eb, color: integer);
    procedure PokeVLine(x, y1, y2: integer; Color: cardinal);
    {Fill}
    procedure Fill(DevColor: Longint);
    procedure FillRect(const Rect: TRect; DevColor: Longint);
    procedure FillRectAdd(const DestRect: TRect; Color: TColor; Alpha: Byte{$IFDEF DelphiX_Spt4} = 128{$ENDIF});
    procedure FillRectAlpha(const DestRect: TRect; Color: TColor; Alpha: Integer);
    procedure FillRectSub(const DestRect: TRect; Color: TColor; Alpha: Byte{$IFDEF DelphiX_Spt4} = 128{$ENDIF});
    {Load}
    procedure LoadFromDIB(DIB: TDIB);
    procedure LoadFromDIBRect(DIB: TDIB; AWidth, AHeight: Integer; const SrcRect: TRect);
    procedure LoadFromGraphic(Graphic: TGraphic);
    procedure LoadFromGraphicRect(Graphic: TGraphic; AWidth, AHeight: Integer; const SrcRect: TRect);
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
{$IFDEF DelphiX_Spt4}
    function Lock(const Rect: TRect; var SurfaceDesc: TDDSurfaceDesc): Boolean; overload;
    function Lock(var SurfaceDesc: TDDSurfaceDesc): Boolean; overload;
    function Lock: Boolean; overload;
{$ELSE}
    function LockSurface: Boolean;
    function Lock(const Rect: TRect; var SurfaceDesc: TDDSurfaceDesc): Boolean;
{$ENDIF}
    procedure UnLock;
    function Restore: Boolean;
    property IsLocked: Boolean read FIsLocked;
    procedure SetSize(AWidth, AHeight: Integer);
    property BitCount: Integer read GetBitCount;
    property Canvas: TDirectDrawSurfaceCanvas read GetCanvas;
    property ClientRect: TRect read GetClientRect;
    property Clipper: TDirectDrawClipper write SetClipper;
    property ColorKey[Flags: DWORD]: TDDColorKey write SetColorKey;
    property DDraw: TDirectDraw read FDDraw;
    property GammaControl: IDirectDrawGammaControl read FGammaControl;
    property Height: Integer read GetHeight;
    property IDDSurface: IDirectDrawSurface read GetIDDSurface write SetIDDSurface;
    property IDDSurface4: IDirectDrawSurface4 read GetIDDSurface4 write SetIDDSurface4;
    property IDDSurface7: IDirectDrawSurface7 read GetIDDSurface7 write SetIDDSurface7;
    property ISurface: IDirectDrawSurface read GetISurface;
    property ISurface4: IDirectDrawSurface4 read GetISurface4;
    property ISurface7: IDirectDrawSurface7 read GetISurface7;
    property Palette: TDirectDrawPalette write SetPalette;
    property Pixels[X, Y: Integer]: Longint read GetPixel write SetPixel;
    property Pixel[X, Y: Integer]: LongInt read Peek write Poke;
    property SurfaceDesc: TDDSurfaceDesc read FSurfaceDesc;
    property SystemMemory: Boolean read FSystemMemory write FSystemMemory;
    property TransparentColor: Longint write SetTransparentColor;
    property Width: Integer read GetWidth;
  end;

  {  TDXDrawDisplay  }

  TCustomDXDraw = class;

  TDXDrawDisplayMode = class(TCollectionItem)
  private
    FSurfaceDesc: TDDSurfaceDesc;
    function GetBitCount: Integer;
    function GetHeight: Integer;
    function GetWidth: Integer;
  public
    property BitCount: Integer read GetBitCount;
    property Height: Integer read GetHeight;
    property SurfaceDesc: TDDSurfaceDesc read FSurfaceDesc;
    property Width: Integer read GetWidth;
  end;

  TDXDrawDisplay = class(TPersistent)
  private
    FBitCount: Integer;
    FDXDraw: TCustomDXDraw;
    FHeight: Integer;
    FModes: TCollection;
    FWidth: Integer;
    FFixedBitCount: Boolean;
    FFixedRatio: Boolean;
    FFixedSize: Boolean;
    function GetCount: Integer;
    function GetMode: TDXDrawDisplayMode;
    function GetMode2(Index: Integer): TDXDrawDisplayMode;
    procedure LoadDisplayModes;
    procedure SetBitCount(Value: Integer);
    procedure SetHeight(Value: Integer);
    procedure SetWidth(Value: Integer);
    function SetSize(AWidth, AHeight, ABitCount: Integer): Boolean;
    function DynSetSize(AWidth, AHeight, ABitCount: Integer): Boolean;
  public
    constructor Create(ADXDraw: TCustomDXDraw);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function IndexOf(Width, Height, BitCount: Integer): Integer;
    property Count: Integer read GetCount;
    property Mode: TDXDrawDisplayMode read GetMode;
    property Modes[Index: Integer]: TDXDrawDisplayMode read GetMode2; default;
  published
    property BitCount: Integer read FBitCount write SetBitCount default 16;
    property FixedBitCount: Boolean read FFixedBitCount write FFixedBitCount;
    property FixedRatio: Boolean read FFixedRatio write FFixedRatio;
    property FixedSize: Boolean read FFixedSize write FFixedSize;
    property Height: Integer read FHeight write SetHeight default 480;
    property Width: Integer read FWidth write SetWidth default 640;
  end;

  TDirectDrawDisplay = TDXDrawDisplay;
  TDirectDrawDisplayMode = TDXDrawDisplayMode;

  {  EDXDrawError  }

  EDXDrawError = class(Exception);

  { TD2D HW acceleration}

  TD2D = class;

  {  TCustomDXDraw  }

  TDXDrawOption = (doFullScreen, doNoWindowChange, doAllowReboot, doWaitVBlank,
    doAllowPalette256, doSystemMemory, doStretch, doCenter, doFlip,
    do3D, doDirectX7Mode, doRetainedMode, doHardware, doSelectDriver, doZBuffer);

  TDXDrawOptions = set of TDXDrawOption;

  TDXDrawNotifyType = (dxntDestroying, dxntInitializing, dxntInitialize, dxntInitializeSurface,
    dxntFinalize, dxntFinalizeSurface, dxntRestore, dxntSetSurfaceSize);

  TDXDrawNotifyEvent = procedure(Sender: TCustomDXDraw; NotifyType: TDXDrawNotifyType) of object;

  TCustomDXDraw = class(TCustomControl)
  private
    FAutoInitialize: Boolean;
    FAutoSize: Boolean;
    FCalledDoInitialize: Boolean;
    FCalledDoInitializeSurface: Boolean;
    FForm: TCustomForm;
    FNotifyEventList: TList;
    FInitialized: Boolean;
    FInitialized2: Boolean;
    FInternalInitialized: Boolean;
    FUpdating: Boolean;
    FSubClass: TControlSubClass;
    FNowOptions: TDXDrawOptions;
    FOptions: TDXDrawOptions;
    FOnFinalize: TNotifyEvent;
    FOnFinalizeSurface: TNotifyEvent;
    FOnInitialize: TNotifyEvent;
    FOnInitializeSurface: TNotifyEvent;
    FOnInitializing: TNotifyEvent;
    FOnRestoreSurface: TNotifyEvent;
    FOffNotifyRestore: Integer;
    { DirectDraw }
    FDXDrawDriver: TObject;
    FDriver: PGUID;
    FDriverGUID: TGUID;
    FDDraw: TDirectDraw;
    FDisplay: TDXDrawDisplay;
    FClipper: TDirectDrawClipper;
    FPalette: TDirectDrawPalette;
    FPrimary: TDirectDrawSurface;
    FSurface: TDirectDrawSurface;
    FSurfaceWidth: Integer;
    FSurfaceHeight: Integer;
    { Direct3D }
    FD3D: IDirect3D;
    FD3D2: IDirect3D2;
    FD3D3: IDirect3D3;
    FD3D7: IDirect3D7;
    FD3DDevice: IDirect3DDevice;
    FD3DDevice2: IDirect3DDevice2;
    FD3DDevice3: IDirect3DDevice3;
    FD3DDevice7: IDirect3DDevice7;
    FD3DRM: IDirect3DRM;
    FD3DRM2: IDirect3DRM2;
    FD3DRM3: IDirect3DRM3;
    FD3DRMDevice: IDirect3DRMDevice;
    FD3DRMDevice2: IDirect3DRMDevice2;
    FD3DRMDevice3: IDirect3DRMDevice3;
    FCamera: IDirect3DRMFrame;
    FScene: IDirect3DRMFrame;
    FViewport: IDirect3DRMViewport;
    FZBuffer: TDirectDrawSurface;
    FD2D: TD2D;
    procedure FormWndProc(var Message: TMessage; DefWindowProc: TWndMethod);
    function GetCanDraw: Boolean;
    function GetCanPaletteAnimation: Boolean;
    function GetSurfaceHeight: Integer;
    function GetSurfaceWidth: Integer;
    procedure NotifyEventList(NotifyType: TDXDrawNotifyType);
    procedure SetColorTable(const ColorTable: TRGBQuads);
    procedure SetCooperativeLevel;
    procedure SetDisplay(Value: TDXDrawDisplay);
    procedure SetDriver(Value: PGUID);
    procedure SetOptions(Value: TDXDrawOptions);
    procedure SetSurfaceHeight(Value: Integer);
    procedure SetSurfaceWidth(Value: Integer);
    function TryRestore: Boolean;
    procedure WMCreate(var Message: TMessage); message WM_CREATE;
    function Black2Screen(oldcolor: Integer): longint;
    function Fade2Black(colorfrom: Integer): longint;
    function Fade2Color(colorfrom, colorto: Integer): longint;
    function Fade2Screen(oldcolor, newcolour: Integer): longint;
    function Fade2White(colorfrom: Integer): longint;
    procedure GrabImage(x, y, width, height: integer; ddib: TDIB);
    function Grey2Fade(shadefrom, shadeto: integer): integer;
    procedure PasteImage(sdib: TDIB; x, y: integer);
    function White2Screen(oldcolor: Integer): longint;
  protected
    procedure DoFinalize; virtual;
    procedure DoFinalizeSurface; virtual;
    procedure DoInitialize; virtual;
    procedure DoInitializeSurface; virtual;
    procedure DoInitializing; virtual;
    procedure DoRestoreSurface; virtual;
    procedure Loaded; override;
    procedure Paint; override;
    function PaletteChanged(Foreground: Boolean): Boolean; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetAutoSize(Value: Boolean); {$IFDEF D6UP} override; {$ENDIF}
  public
    ColorTable: TRGBQuads;
    DefColorTable: TRGBQuads;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function Drivers: TDirectXDrivers;
    procedure Finalize;
    procedure Flip;
    procedure Initialize;
    procedure Render;
    procedure Restore;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetSize(ASurfaceWidth, ASurfaceHeight: Integer);
    procedure BeginScene;
    procedure EndScene;
    procedure TextureFilter(Grade: Integer);
    procedure ClearStack;
    procedure UpdatePalette;
    procedure RegisterNotifyEvent(NotifyEvent: TDXDrawNotifyEvent);
    procedure UnRegisterNotifyEvent(NotifyEvent: TDXDrawNotifyEvent);
    property AutoInitialize: Boolean read FAutoInitialize write FAutoInitialize;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property Camera: IDirect3DRMFrame read FCamera;
    property CanDraw: Boolean read GetCanDraw;
    property CanPaletteAnimation: Boolean read GetCanPaletteAnimation;
    property Clipper: TDirectDrawClipper read FClipper;
    property Color;
    property D3D: IDirect3D read FD3D;
    property D3D2: IDirect3D2 read FD3D2;
    property D3D3: IDirect3D3 read FD3D3;
    property D3D7: IDirect3D7 read FD3D7;
    property D3DDevice: IDirect3DDevice read FD3DDevice;
    property D3DDevice2: IDirect3DDevice2 read FD3DDevice2;
    property D3DDevice3: IDirect3DDevice3 read FD3DDevice3;
    property D3DDevice7: IDirect3DDevice7 read FD3DDevice7;
    property D3DRM: IDirect3DRM read FD3DRM;
    property D3DRM2: IDirect3DRM2 read FD3DRM2;
    property D3DRM3: IDirect3DRM3 read FD3DRM3;
    property D3DRMDevice: IDirect3DRMDevice read FD3DRMDevice;
    property D3DRMDevice2: IDirect3DRMDevice2 read FD3DRMDevice2;
    property D3DRMDevice3: IDirect3DRMDevice3 read FD3DRMDevice3;
    property DDraw: TDirectDraw read FDDraw;
    property Display: TDXDrawDisplay read FDisplay write SetDisplay;
    property Driver: PGUID read FDriver write SetDriver;
    property Initialized: Boolean read FInitialized;
    property NowOptions: TDXDrawOptions read FNowOptions;
    property OnFinalize: TNotifyEvent read FOnFinalize write FOnFinalize;
    property OnFinalizeSurface: TNotifyEvent read FOnFinalizeSurface write FOnFinalizeSurface;
    property OnInitialize: TNotifyEvent read FOnInitialize write FOnInitialize;
    property OnInitializeSurface: TNotifyEvent read FOnInitializeSurface write FOnInitializeSurface;
    property OnInitializing: TNotifyEvent read FOnInitializing write FOnInitializing;
    property OnRestoreSurface: TNotifyEvent read FOnRestoreSurface write FOnRestoreSurface;
    property Options: TDXDrawOptions read FOptions write SetOptions;
    property Palette: TDirectDrawPalette read FPalette;
    property Primary: TDirectDrawSurface read FPrimary;
    property Scene: IDirect3DRMFrame read FScene;
    property Surface: TDirectDrawSurface read FSurface;
    property SurfaceHeight: Integer read GetSurfaceHeight write SetSurfaceHeight default 480;
    property SurfaceWidth: Integer read GetSurfaceWidth write SetSurfaceWidth default 640;
    property Viewport: IDirect3DRMViewport read FViewport;
    property ZBuffer: TDirectDrawSurface read FZBuffer;
    property D2D1: TD2D read FD2D; {public object is here}
  end;

  {  TDXDraw  }

  TDXDraw = class(TCustomDXDraw)
  published
    property AutoInitialize;
    property AutoSize;
    property Color;
    property Display;
    property Options;
    property SurfaceHeight;
    property SurfaceWidth;
    property OnFinalize;
    property OnFinalizeSurface;
    property OnInitialize;
    property OnInitializeSurface;
    property OnInitializing;
    property OnRestoreSurface;

    property Align;
{$IFDEF DelphiX_Spt4}property Anchors; {$ENDIF}
{$IFDEF DelphiX_Spt4}property Constraints; {$ENDIF}
    property DragCursor;
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
{$IFDEF DelphiX_Spt4}property OnResize; {$ENDIF}
    property OnStartDrag;
  end;

  {  EDX3DError  }

  EDX3DError = class(Exception);

{$IFDEF DX3D_deprecated}

  {  TCustomDX3D  }

  TDX3DOption = (toRetainedMode, toSystemMemory, toHardware, toSelectDriver, toZBuffer);

  TDX3DOptions = set of TDX3DOption;

  TCustomDX3D = class(TComponent)
  private
    FAutoSize: Boolean;
    FCamera: IDirect3DRMFrame;
    FD3D: IDirect3D;
    FD3D2: IDirect3D2;
    FD3D3: IDirect3D3;
    FD3D7: IDirect3D7;
    FD3DDevice: IDirect3DDevice;
    FD3DDevice2: IDirect3DDevice2;
    FD3DDevice3: IDirect3DDevice3;
    FD3DDevice7: IDirect3DDevice7;
    FD3DRM: IDirect3DRM;
    FD3DRM2: IDirect3DRM2;
    FD3DRM3: IDirect3DRM3;
    FD3DRMDevice: IDirect3DRMDevice;
    FD3DRMDevice2: IDirect3DRMDevice2;
    FD3DRMDevice3: IDirect3DRMDevice3;
    FDXDraw: TCustomDXDraw;
    FInitFlag: Boolean;
    FInitialized: Boolean;
    FNowOptions: TDX3DOptions;
    FOnFinalize: TNotifyEvent;
    FOnInitialize: TNotifyEvent;
    FOptions: TDX3DOptions;
    FScene: IDirect3DRMFrame;
    FSurface: TDirectDrawSurface;
    FSurfaceHeight: Integer;
    FSurfaceWidth: Integer;
    FViewport: IDirect3DRMViewport;
    FZBuffer: TDirectDrawSurface;
    procedure Finalize;
    procedure Initialize;
    procedure DXDrawNotifyEvent(Sender: TCustomDXDraw; NotifyType: TDXDrawNotifyType);
    function GetCanDraw: Boolean;
    function GetSurfaceHeight: Integer;
    function GetSurfaceWidth: Integer;
    procedure SetAutoSize(Value: Boolean);
    procedure SetDXDraw(Value: TCustomDXDraw);
    procedure SetOptions(Value: TDX3DOptions); virtual; {TridenT}
    procedure SetSurfaceHeight(Value: Integer);
    procedure SetSurfaceWidth(Value: Integer);
  protected
    procedure DoFinalize; virtual;
    procedure DoInitialize; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Render;
    procedure SetSize(ASurfaceWidth, ASurfaceHeight: Integer);
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property Camera: IDirect3DRMFrame read FCamera;
    property CanDraw: Boolean read GetCanDraw;
    property D3D: IDirect3D read FD3D;
    property D3D2: IDirect3D2 read FD3D2;
    property D3D3: IDirect3D3 read FD3D3;
    property D3D7: IDirect3D7 read FD3D7;
    property D3DDevice: IDirect3DDevice read FD3DDevice;
    property D3DDevice2: IDirect3DDevice2 read FD3DDevice2;
    property D3DDevice3: IDirect3DDevice3 read FD3DDevice3;
    property D3DDevice7: IDirect3DDevice7 read FD3DDevice7;
    property D3DRM: IDirect3DRM read FD3DRM;
    property D3DRM2: IDirect3DRM2 read FD3DRM2;
    property D3DRM3: IDirect3DRM3 read FD3DRM3;
    property D3DRMDevice: IDirect3DRMDevice read FD3DRMDevice;
    property D3DRMDevice2: IDirect3DRMDevice2 read FD3DRMDevice2;
    property D3DRMDevice3: IDirect3DRMDevice3 read FD3DRMDevice3;
    property DXDraw: TCustomDXDraw read FDXDraw write SetDXDraw;
    property Initialized: Boolean read FInitialized;
    property NowOptions: TDX3DOptions read FNowOptions;
    property OnFinalize: TNotifyEvent read FOnFinalize write FOnFinalize;
    property OnInitialize: TNotifyEvent read FOnInitialize write FOnInitialize;
    property Options: TDX3DOptions read FOptions write SetOptions;
    property Scene: IDirect3DRMFrame read FScene;
    property Surface: TDirectDrawSurface read FSurface;
    property SurfaceHeight: Integer read GetSurfaceHeight write SetSurfaceHeight default 480;
    property SurfaceWidth: Integer read GetSurfaceWidth write SetSurfaceWidth default 640;
    property Viewport: IDirect3DRMViewport read FViewport;
    property ZBuffer: TDirectDrawSurface read FZBuffer;
  end;

  {  TDX3D  }

  TDX3D = class(TCustomDX3D)
  published
    property AutoSize;
    property DXDraw;
    property Options;
    property SurfaceHeight;
    property SurfaceWidth;
    property OnFinalize;
    property OnInitialize;
  end;
{$ENDIF}

  {  EDirect3DTextureError  }

  EDirect3DTextureError = class(Exception);

  {  TDirect3DTexture  }

  TDirect3DTexture = class
  private
    FBitCount: DWORD;
    FDXDraw: TComponent;
    FEnumFormatFlag: Boolean;
    FFormat: TDDSurfaceDesc;
    FGraphic: TGraphic;
    FHandle: TD3DTextureHandle;
    FPaletteEntries: TPaletteEntries;
    FSurface: TDirectDrawSurface;
    FTexture: IDirect3DTexture;
    FTransparentColor: TColor;
    procedure Clear;
    procedure DXDrawNotifyEvent(Sender: TCustomDXDraw; NotifyType: TDXDrawNotifyType);
    function GetHandle: TD3DTextureHandle;
    function GetSurface: TDirectDrawSurface;
    function GetTexture: IDirect3DTexture;
    procedure SetTransparentColor(Value: TColor);
  public
    constructor Create(Graphic: TGraphic; DXDraw: TComponent);
    destructor Destroy; override;
    procedure Restore;
    property Handle: TD3DTextureHandle read GetHandle;
    property Surface: TDirectDrawSurface read GetSurface;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor;
    property Texture: IDirect3DTexture read GetTexture;
  end;

  { EDXTextureImageError }

  EDXTextureImageError = class(Exception);

  { channel structure }

  TDXTextureImageChannel = record
    Mask: DWORD;
    BitCount: Integer;

    {  Internal use  }
    _Mask2: DWORD;
    _rshift: Integer;
    _lshift: Integer;
    _BitCount2: Integer;
  end;

  TDXTextureImage_PaletteEntries = array[0..255] of TPaletteEntry;

  TDXTextureImageType = (
    DXTextureImageType_PaletteIndexedColor,
    DXTextureImageType_RGBColor
    );

  TDXTextureImageFileCompressType = (
    DXTextureImageFileCompressType_None,
    DXTextureImageFileCompressType_ZLIB
    );

  {forward}

  TDXTextureImage = class;

  { TDXTextureImageLoadFunc }

  TDXTextureImageLoadFunc = procedure(Stream: TStream; Image: TDXTextureImage);

  { TDXTextureImageProgressEvent }

  TDXTextureImageProgressEvent = procedure(Sender: TObject; Progress, ProgressCount: Integer) of object;

  { TDXTextureImage }

  TDXTextureImage = class
  private
    FOwner: TDXTextureImage;
    FFileCompressType: TDXTextureImageFileCompressType;
    FOnSaveProgress: TDXTextureImageProgressEvent;
    FSubImage: TList;
    FImageType: TDXTextureImageType;
    FWidth: Integer;
    FHeight: Integer;
    FPBits: Pointer;
    FBitCount: Integer;
    FPackedPixelOrder: Boolean;
    FWidthBytes: Integer;
    FNextLine: Integer;
    FSize: Integer;
    FTopPBits: Pointer;
    FTransparent: Boolean;
    FTransparentColor: DWORD;
    FImageGroupType: DWORD;
    FImageID: DWORD;
    FImageName: string;
    FAutoFreeImage: Boolean;
    procedure ClearImage;
    function GetPixel(x, y: Integer): DWORD;
    procedure SetPixel(x, y: Integer; c: DWORD);
    function GetScanLine(y: Integer): Pointer;
    function GetSubGroupImageCount(GroupTypeID: DWORD): Integer;
    function GetSubGroupImage(GroupTypeID: DWORD; Index: Integer): TDXTextureImage;
    function GetSubImageCount: Integer;
    function GetSubImage(Index: Integer): TDXTextureImage;
  protected
    procedure DoSaveProgress(Progress, ProgressCount: Integer); virtual;
  public
    idx_index: TDXTextureImageChannel;
    idx_alpha: TDXTextureImageChannel;
    idx_palette: TDXTextureImage_PaletteEntries;
    rgb_red: TDXTextureImageChannel;
    rgb_green: TDXTextureImageChannel;
    rgb_blue: TDXTextureImageChannel;
    rgb_alpha: TDXTextureImageChannel;
    constructor Create;
    constructor CreateSub(AOwner: TDXTextureImage);
    destructor Destroy; override;
    procedure Assign(Source: TDXTextureImage);
    procedure Clear;
    procedure SetImage(ImageType: TDXTextureImageType; Width, Height, BitCount, WidthBytes, NextLine: Integer;
      PBits, TopPBits: Pointer; Size: Integer; AutoFree: Boolean);
    procedure SetSize(ImageType: TDXTextureImageType; Width, Height, BitCount, WidthBytes: Integer);
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: string);
    procedure SaveToStream(Stream: TStream);
    function EncodeColor(R, G, B, A: Byte): DWORD;
    function PaletteIndex(R, G, B: Byte): DWORD;
    class procedure RegisterLoadFunc(LoadFunc: TDXTextureImageLoadFunc);
    class procedure UnRegisterLoadFunc(LoadFunc: TDXTextureImageLoadFunc);
    property BitCount: Integer read FBitCount;
    property PackedPixelOrder: Boolean read FPackedPixelOrder write FPackedPixelOrder;
    property Height: Integer read FHeight;
    property ImageType: TDXTextureImageType read FImageType;
    property ImageGroupType: DWORD read FImageGroupType write FImageGroupType;
    property ImageID: DWORD read FImageID write FImageID;
    property ImageName: string read FImageName write FImageName;
    property NextLine: Integer read FNextLine;
    property PBits: Pointer read FPBits;
    property Pixels[x, y: Integer]: DWORD read GetPixel write SetPixel;
    property ScanLine[y: Integer]: Pointer read GetScanLine;
    property Size: Integer read FSize;
    property SubGroupImageCount[GroupTypeID: DWORD]: Integer read GetSubGroupImageCount;
    property SubGroupImages[GroupTypeID: DWORD; Index: Integer]: TDXTextureImage read GetSubGroupImage;
    property SubImageCount: Integer read GetSubImageCount;
    property SubImages[Index: Integer]: TDXTextureImage read GetSubImage;
    property TopPBits: Pointer read FTopPBits;
    property Transparent: Boolean read FTransparent write FTransparent;
    property TransparentColor: DWORD read FTransparentColor write FTransparentColor;
    property Width: Integer read FWidth;
    property WidthBytes: Integer read FWidthBytes;
    property FileCompressType: TDXTextureImageFileCompressType read FFileCompressType write FFileCompressType;
    property OnSaveProgress: TDXTextureImageProgressEvent read FOnSaveProgress write FOnSaveProgress;
  end;

  {  TDirect3DTexture2  }

  TDirect3DTexture2 = class
  private
    FDXDraw: TCustomDXDraw;
    FSrcImage: TObject;
    FImage: TDXTextureImage;
    FImage2: TDXTextureImage;
    FAutoFreeGraphic: Boolean;
    FSurface: TDirectDrawSurface;
    FTextureFormat: TDDSurfaceDesc2;
    FMipmap: Boolean;
    FTransparent: Boolean;
    FTransparentColor: TColorRef;
    FUseMipmap: Boolean;
    FUseColorKey: Boolean;
    FOnRestoreSurface: TNotifyEvent;
    FNeedLoadTexture: Boolean;
    FEnumTextureFormatFlag: Boolean;
    FD3DDevDesc: TD3DDeviceDesc;
    procedure DXDrawNotifyEvent(Sender: TCustomDXDraw; NotifyType: TDXDrawNotifyType);
    procedure SetDXDraw(ADXDraw: TCustomDXDraw);
    procedure LoadSubTexture(Dest: IDirectDrawSurface4; SrcImage: TDXTextureImage);
    procedure SetColorKey;
    procedure SetDIB(DIB: TDIB);
    function GetIsMipmap: Boolean;
    function GetSurface: TDirectDrawSurface;
    function GetTransparent: Boolean;
    procedure SetTransparent(Value: Boolean);
    procedure SetTransparentColor(Value: TColorRef);
  protected
    procedure DoRestoreSurface; virtual;
  public
    constructor Create(ADXDraw: TCustomDXDraw; Graphic: TObject; AutoFreeGraphic: Boolean);
    constructor CreateFromFile(ADXDraw: TCustomDXDraw; const FileName: string);
    constructor CreateVideoTexture(ADXDraw: TCustomDXDraw);
    destructor Destroy; override;
    procedure Finalize;
    procedure Load;
    procedure Initialize;
    property IsMipmap: Boolean read GetIsMipmap;
    property Surface: TDirectDrawSurface read GetSurface;
    property TextureFormat: TDDSurfaceDesc2 read FTextureFormat write FTextureFormat;
    property Transparent: Boolean read GetTransparent write SetTransparent;
    property TransparentColor: TColorRef read FTransparentColor write SetTransparentColor;
    property OnRestoreSurface: TNotifyEvent read FOnRestoreSurface write FOnRestoreSurface;
  end;

  {  EDXTBaseError  }

  EDXTBaseError = class(Exception);

  {  parameters for DXT generator  }

  TDXTImageChannel = (rgbNone, rgbRed, rgbGreen, rgbBlue, rgbAlpha, yuvY);
  TDXTImageChannels = set of TDXTImageChannel;

  TDXTImageChannelInfo = packed record
    Image: TDXTextureImage;
    BitCount: Integer;
  end;

  TDXTImageFormat = packed record
    ImageType: TDXTextureImageType;
    Width: Integer;
    Height: Integer;
    Bits: Pointer;
    BitCount: Integer;
    WidthBytes: Integer;
    {transparent}
    Transparent: Boolean;
    TransparentColor: TColorRef;
    {texture channels}
    idx_index: TDXTextureImageChannel;
    idx_alpha: TDXTextureImageChannel;
    idx_palette: TDXTextureImage_PaletteEntries;
    rgb_red: TDXTextureImageChannel;
    rgb_green: TDXTextureImageChannel;
    rgb_blue: TDXTextureImageChannel;
    rgb_alpha: TDXTextureImageChannel;
    {compress level}
    Compress: TDXTextureImageFileCompressType;
    MipmapCount: Integer;
    Name: string;
  end;

  {  TDXTBase  }

  {Note JB.}
  {Class for DXT generation files, primary use for load bitmap 32 with alphachannel}
  {recoded and class created by JB.}
  TDXTBase = class
  private
    FHasChannels: TDXTImageChannels;
    FHasChannelImages: array[TDXTImageChannel] of TDXTImageChannelInfo;
    FChannelChangeTable: array[TDXTImageChannel] of TDXTImageChannel;
    FHasImageList: TList;
    FParamsFormat: TDXTImageFormat;
    FStrImageFileName: string;
    FDIB: TDIB;
    function GetCompression: TDXTextureImageFileCompressType;
    function GetHeight: Integer;
    function GetMipmap: Integer;
    function GetTransparentColor: TColorRef;
    function GetWidth: Integer;
    procedure SetCompression(const Value: TDXTextureImageFileCompressType);
    procedure SetHeight(const Value: Integer);
    procedure SetMipmap(const Value: Integer);
    procedure SetTransparentColor(const Value: TColorRef);
    procedure SetWidth(const Value: Integer);
    procedure SetTransparentColorIndexed(const Value: TColorRef);
    function GetTexture: TDXTextureImage;
    procedure Resize(Image: TDXTextureImage; NewWidth, NewHeight: Integer;
      FilterTypeResample: TFilterTypeResample);
    procedure EvaluateChannels(const CheckChannelUsed: TDXTImageChannels;
      const CheckChannelChanged, CheckBitCountForChannel: string);
    function GetPicture: TDXTextureImage;
  protected
    procedure CalcOutputBitFormat;
    procedure BuildImage(Image: TDXTextureImage);
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetChannelR(T: TDIB);
    procedure SetChannelG(T: TDIB);
    procedure SetChannelB(T: TDIB);
    procedure SetChannelA(T: TDIB);
    procedure LoadChannelAFromFile(const FileName: string);
    procedure SetChannelY(T: TDIB);
    procedure SetChannelRGB(T: TDIB);
    procedure LoadChannelRGBFromFile(const FileName: string);
    procedure SetChannelRGBA(T: TDIB);
    procedure LoadChannelRGBAFromFile(const FileName: string);
    property TransparentColor: TColorRef read GetTransparentColor write SetTransparentColor;
    property TransparentColorIndexed: TColorRef read GetTransparentColor write SetTransparentColorIndexed;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Compression: TDXTextureImageFileCompressType read GetCompression write SetCompression;
    property Mipmap: Integer read GetMipmap write SetMipmap;
    property Texture: TDXTextureImage read GetTexture;
  end;

  {  EDirect3DRMUserVisualError  }

  EDirect3DRMUserVisualError = class(Exception);

  {  TDirect3DRMUserVisual  }

  TDirect3DRMUserVisual = class
  private
    FUserVisual: IDirect3DRMUserVisual;
  protected
    function DoRender(Reason: TD3DRMUserVisualReason;
      D3DRMDev: IDirect3DRMDevice; D3DRMView: IDirect3DRMViewport): HRESULT; virtual;
  public
    constructor Create(D3DRM: IDirect3DRM);
    destructor Destroy; override;
    property UserVisual: IDirect3DRMUserVisual read FUserVisual;
  end;

  {  EPictureCollectionError  }

  EPictureCollectionError = class(Exception);

  {  TPictureCollectionItem  }

  TPictureCollection = class;

  TPictureCollectionItem = class(THashCollectionItem)
  private
    FPicture: TPicture;
    FInitialized: Boolean;
    FPatternHeight: Integer;
    FPatternWidth: Integer;
    FPatterns: TCollection;
    FSkipHeight: Integer;
    FSkipWidth: Integer;
    FSurfaceList: TList;
    FSystemMemory: Boolean;
    FTransparent: Boolean;
    FTransparentColor: TColor;
    procedure ClearSurface;
    procedure Finalize;
    procedure Initialize;
    function GetHeight: Integer;
    function GetPictureCollection: TPictureCollection;
    function GetPatternRect(Index: Integer): TRect;
    function GetPatternSurface(Index: Integer): TDirectDrawSurface;
    function GetPatternCount: Integer;
    function GetWidth: Integer;
    procedure SetPicture(Value: TPicture);
    procedure SetTransparentColor(Value: TColor);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Draw(Dest: TDirectDrawSurface; X, Y: Integer; PatternIndex: Integer);
//	Modifier par MKost d'Uk@Team tous droit réservé.				*)
//	22:02 04/11/2005								*)
//	Ajouté :									*)
// Dans TPictureCollectionItem								*)
// procedure DrawFlipH(Dest: TDirectDrawSurface; X, Y: Integer; PatternIndex: Integer); *)
//      -Effectue un flip Horizontale de l'image					*)
// procedure DrawFlipHV(Dest: TDirectDrawSurface; X, Y: Integer; PatternIndex: Integer);*)
//      -Effectue un flip Oblique de l'image						*)
// procedure DrawFlipV(Dest: TDirectDrawSurface; X, Y: Integer; PatternIndex: Integer); *)
//      -Effectue un flip Verticale de l'image						*)
    procedure DrawFlipH(Dest: TDirectDrawSurface; X, Y: Integer; PatternIndex: Integer);
    procedure DrawFlipHV(Dest: TDirectDrawSurface; X, Y: Integer; PatternIndex: Integer);
    procedure DrawFlipV(Dest: TDirectDrawSurface; X, Y: Integer; PatternIndex: Integer);
    procedure StretchDraw(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer);
    procedure DrawAdd(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawAddCol(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
      Color: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawAlpha(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawAlphaCol(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
      Color: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawSub(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawSubCol(Dest: TDirectDrawSurface; const DestRect: TRect;
      PatternIndex, Color: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    {Rotate}
    procedure DrawRotate(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: single);
    procedure DrawRotateAdd(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: single;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateAddCol(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: single;
      Color: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateAlpha(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: single;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateAlphaCol(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: single;
      Color: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateSub(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: single;
      Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawRotateSubCol(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: single;
      Color: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    {WaveX}
    procedure DrawWaveX(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer);
    procedure DrawWaveXAdd(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveXAlpha(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveXSub(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    {WaveY}
    procedure DrawWaveY(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer);
    procedure DrawWaveYAdd(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveYAlpha(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure DrawWaveYSub(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    {SpecialDraw}
    procedure DrawCol(Dest: TDirectDrawSurface; const DestRect, SourceRect: TRect;
      PatternIndex: Integer; Faded: Boolean; RenderType: TRenderType; Color,
      Specular: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF});
    procedure Restore;
    property Height: Integer read GetHeight;
    property Initialized: Boolean read FInitialized;
    property PictureCollection: TPictureCollection read GetPictureCollection;
    property PatternCount: Integer read GetPatternCount;
    property PatternRects[Index: Integer]: TRect read GetPatternRect;
    property PatternSurfaces[Index: Integer]: TDirectDrawSurface read GetPatternSurface;
    property Width: Integer read GetWidth;
  published
    property PatternHeight: Integer read FPatternHeight write FPatternHeight;
    property PatternWidth: Integer read FPatternWidth write FPatternWidth;
    property Picture: TPicture read FPicture write SetPicture;
    property SkipHeight: Integer read FSkipHeight write FSkipHeight default 0;
    property SkipWidth: Integer read FSkipWidth write FSkipWidth default 0;
    property SystemMemory: Boolean read FSystemMemory write FSystemMemory;
    property Transparent: Boolean read FTransparent write FTransparent;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor;
  end;

  {  TPictureCollection  }

  TPictureCollection = class(THashCollection)
  private
    FDXDraw: TCustomDXDraw;
    FOwner: TPersistent;
    function GetItem(Index: Integer): TPictureCollectionItem;
    procedure ReadColorTable(Stream: TStream);
    procedure WriteColorTable(Stream: TStream);
    function Initialized: Boolean;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    function GetOwner: TPersistent; override;
  public
    ColorTable: TRGBQuads;
    constructor Create(AOwner: TPersistent);
    destructor Destroy; override;
    function Find(const Name: string): TPictureCollectionItem;
    procedure Finalize;
    procedure Initialize(DXDraw: TCustomDXDraw);
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure MakeColorTable;
    procedure Restore;
    procedure SaveToFile(const FileName: string);
    procedure SaveToStream(Stream: TStream);
    property DXDraw: TCustomDXDraw read FDXDraw;
    property Items[Index: Integer]: TPictureCollectionItem read GetItem; default;
  end;

  {  TCustomDXImageList  }

  TCustomDXImageList = class(TComponent)
  private
    FDXDraw: TCustomDXDraw;
    FItems: TPictureCollection;
    procedure DXDrawNotifyEvent(Sender: TCustomDXDraw; NotifyType: TDXDrawNotifyType);
    procedure SetDXDraw(Value: TCustomDXDraw);
    procedure SetItems(Value: TPictureCollection);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOnwer: TComponent); override;
    destructor Destroy; override;
    property DXDraw: TCustomDXDraw read FDXDraw write SetDXDraw;
    property Items: TPictureCollection read FItems write SetItems;
  end;

  {  TDXImageList  }

  TDXImageList = class(TCustomDXImageList)
  published
    property DXDraw;
    property Items;
  end;

  {  EDirectDrawOverlayError  }

  EDirectDrawOverlayError = class(Exception);

  {  TDirectDrawOverlay  }

  TDirectDrawOverlay = class
  private
    FDDraw: TDirectDraw;
    FTargetSurface: TDirectDrawSurface;
    FDDraw2: TDirectDraw;
    FTargetSurface2: TDirectDrawSurface;
    FSurface: TDirectDrawSurface;
    FBackSurface: TDirectDrawSurface;
    FOverlayColorKey: TColor;
    FOverlayRect: TRect;
    FVisible: Boolean;
    procedure SetOverlayColorKey(Value: TColor);
    procedure SetOverlayRect(const Value: TRect);
    procedure SetVisible(Value: Boolean);
  public
    constructor Create(DDraw: TDirectDraw; TargetSurface: TDirectDrawSurface);
    constructor CreateWindowed(WindowHandle: HWND);
    destructor Destroy; override;
    procedure Finalize;
    procedure Initialize(const SurfaceDesc: TDDSurfaceDesc);
    procedure Flip;
    property OverlayColorKey: TColor read FOverlayColorKey write SetOverlayColorKey;
    property OverlayRect: TRect read FOverlayRect write SetOverlayRect;
    property Surface: TDirectDrawSurface read FSurface;
    property BackSurface: TDirectDrawSurface read FBackSurface;
    property Visible: Boolean read FVisible write SetVisible;
  end;

{
 Modified by Michael Wilson 2/05/2001
 - re-added redundant assignment to Offset
 Modified by Marcus Knight 19/12/2000
 - replaces all referaces to 'pos' with 'AnsiPos' <- faster
 - replaces all referaces to 'uppercase' with 'Ansiuppercase' <- faster
 - Now only uppercases outside the loop
 - Fixed the non-virtual contructor
 - renamed & moved Offset to private(fOffSet), and added the property OffSet
 - Commented out the redundant assignment to Offset<- not needed, as Offset is now a readonly property
 - Added the Notification method to catch when the image list is destroyed
 - removed DXclasses from used list
}

  TDXFont = class(TComponent)
  private
    FDXImageList: TDXImageList;
    FFont: string;
    FFontIndex: Integer;
    FOffset: integer; // renamed from Offset -> fOffset
    procedure SetFont(const Value: string);
    procedure SetFontIndex(const Value: Integer);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override; // added
  public
    constructor Create(AOwner: TComponent); override; // Modified
    destructor Destroy; override;
    procedure TextOut(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string);
    property Offset: integer read FOffset write FOffset; // added
  published
    property Font: string read FFont write SetFont;
    property FontIndex: Integer read FFontIndex write SetFontIndex;
    property DXImageList: TDXImageList read FDXImageList write FDXImageList;
  end;

(*******************************************************************************
 * Unit Name: DXPowerFont.pas
 * Information: Writed By Ramin.S.Zaghi (Based On Wilson's DXFont Unit)
 * Last Changes: Dec 25 2000;
 * Unit Information:
 *     This unit includes a VCL-Component for DelphiX. This component draws the
 *     Character-Strings on a TDirectDrawSurface. This component helps the
 *     progarmmers to using custom fonts and printing texts easily such as
 *     TCanvas.TextOut function...
 * Includes:
 * 1. TDXPowerFontTextOutEffect ==> The kinds of drawing effects.
 *    - teNormal: Uses the Draw function. (Normal output)
 *    - teRotat: Uses the DrawRotate function. (Rotates each character)
 *    - teAlphaBlend: Uses DrawAlpha function. (Blends each character)
 *    - teWaveX: Uses DrawWaveX function. (Adds a Wave effect to the each character)
 *
 * 2. TDXPowerFontTextOutType ==> The kinds of each caracter.
 *    - ttUpperCase: Uppers all characters automaticaly.
 *    - ttLowerCase: Lowers all characters automaticaly.
 *    - ttNormal: Uses all characters with out any converting.
 *
 * 3. TDXPowerFontEffectsParameters ==> Includes the parameters for adding effects to the characters.
 *    - (CenterX, CenterY): The rotating center point.
 *    - (Width, Height): The new size of each character.
 *    - Angle: The angle of rotate.
 *    - AlphaValue: The value of Alpha-Chanel.
 *    - WAmplitude: The Amplitude of Wave function. (See The Help Of DelphiX)
 *    - WLenght: The Lenght Of Wave function. (See The Help Of DelphiX)
 *    - WPhase: The Phase Of Wave function. (See The Help Of DelphiX)
 *
 * 4. TDXPowerFontBeforeTextOutEvent ==> This is an event that occures before
 *    drawing texts on to TDirectDrawSurface object.
 *    - Sender: Retrieves the event caller object.
 *    - Text: Retrieves the text sended text for drawing.
 *      (NOTE: The changes will have effect)
 *    - DoTextOut: The False value means that the TextOut function must be stopped.
 *      (NOTE: The changes will have effect)
 *
 * 5. TDXPowerFontAfterTextOutEvent ==> This is an event that occures after
 *    drawing texts on to TDirectDrawSurface object.
 *    - Sender: Retrieves the event caller object.
 *    - Text: Retrieves the text sended text for drawing.
 *      (NOTE: The changes will not have any effects)
 *
 * 6. TDXPowerFont ==> I sthe main class of PowerFont VCL-Component.
 *    - property Font: string; The name of custom-font's image in the TDXImageList items.
 *    - property FontIndex: Integer; The index of custom-font's image in the TDXImageList items.
 *    - property DXImageList: TDXImageList; The TDXImageList that includes the image of custom-fonts.
 *    - property UseEnterChar: Boolean; When the value of this property is True, The component caculates Enter character.
 *    - property EnterCharacter: String;
 *==>   Note that TDXPowerFont calculates tow kinds of enter character:
 *==>   E1. The Enter character that draws the characters after it self in a new line and after last drawed character, ONLY.
 *==>   E2. The Enter character that draws the characters after it self in a new line such as #13#10 enter code in delphi.
 *==>   Imporatant::
 *==>       (E1) TDXPowerFont uses the first caracter of EnterCharacter string as the first enter caracter (Default value is '|').
 *==>       (E2) and uses the second character as the scond enter caracter (Default value is '<')
 *    - property BeforeTextOut: TDXPowerFontBeforeTextOutEvent; See TDXPowerFontBeforeTextOutEvent.
 *    - property AfterTextOut: TDXPowerFontAfterTextOutEvent; See TDXPowerFontAfterTextOutEvent.
 *    - property Alphabets: string; TDXPowerFont uses this character-string for retrieving the pattern number of each character.
 *    - property TextOutType: TDXPowerFontTextOutType; See TDXPowerFontTextOutType.
 *    - property TextOutEffect: TDXPowerFontTextOutEffect; See TDXPowerFontTextOutEffect.
 *    - property EffectsParameters: TDXPowerFontEffectsParameters; See TDXPowerFontEffectsParameters.
 *
 *    - function TextOut(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string): Boolean;
 *      This function draws/prints the given text on the given TDirectDrawSurface.
 *      - DirectDrawSurface: The surface for drawing text (character-string).
 *      - (X , Y): The first point of outputed text. (Such as X,Y parameters in TCanvas.TextOut function)
 *      - Text: The text for printing.
 *      Return values: This function returns False when an error occured or...
 *    - function TextOutFast(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string): Boolean;
 *      This function works such as TextOut function but,
 *      with out calculating any Parameters/Effects/Enter-Characters/etc...
 *      This function calculates the TextOutType, ONLY.
 *
 * Ramin.S.Zaghi (ramin_zaghi@yahoo.com)
 * (Based on wilson's code for TDXFont VCL-Component/Add-On)
 * (wilson@no2games.com)
 *
 * For more information visit:
 *  www.no2games.com
 *  turbo.gamedev.net
 ******************************************************************************)

 { DXPowerFont types }

  TDXPowerFontTextOutEffect = (teNormal, teRotat, teAlphaBlend, teWaveX);
  TDXPowerFontTextOutType = (ttUpperCase, ttLowerCase, ttNormal);
  TDXPowerFontBeforeTextOutEvent = procedure(Sender: TObject; var Text: string; var DoTextOut: Boolean) of object;
  TDXPowerFontAfterTextOutEvent = procedure(Sender: TObject; Text: string) of object;

 { TDXPowerFontEffectsParameters }

  TDXPowerFontEffectsParameters = class(TPersistent)
  private
    FCenterX: Integer;
    FCenterY: Integer;
    FHeight: Integer;
    FWidth: Integer;
    FAngle: Integer;
    FAlphaValue: Integer;
    FWPhase: Integer;
    FWAmplitude: Integer;
    FWLenght: Integer;
    procedure SetAngle(const Value: Integer);
    procedure SetCenterX(const Value: Integer);
    procedure SetCenterY(const Value: Integer);
    procedure SetHeight(const Value: Integer);
    procedure SetWidth(const Value: Integer);
    procedure SetAlphaValue(const Value: Integer);
    procedure SetWAmplitude(const Value: Integer);
    procedure SetWLenght(const Value: Integer);
    procedure SetWPhase(const Value: Integer);
  published
    property CenterX: Integer read FCenterX write SetCenterX;
    property CenterY: Integer read FCenterY write SetCenterY;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
    property Angle: Integer read FAngle write SetAngle;
    property AlphaValue: Integer read FAlphaValue write SetAlphaValue;
    property WAmplitude: Integer read FWAmplitude write SetWAmplitude;
    property WLenght: Integer read FWLenght write SetWLenght;
    property WPhase: Integer read FWPhase write SetWPhase;
  end;

 { TDXPowerFont }

  TDXPowerFont = class(TComponent)
  private
    FDXImageList: TDXImageList;
    FFont: string;
    FFontIndex: Integer;
    FUseEnterChar: Boolean;
    FEnterCharacter: string;
    FAfterTextOut: TDXPowerFontAfterTextOutEvent;
    FBeforeTextOut: TDXPowerFontBeforeTextOutEvent;
    FAlphabets: string;
    FTextOutType: TDXPowerFontTextOutType;
    FTextOutEffect: TDXPowerFontTextOutEffect;
    FEffectsParameters: TDXPowerFontEffectsParameters;
    procedure SetFont(const Value: string);
    procedure SetFontIndex(const Value: Integer);
    procedure SetUseEnterChar(const Value: Boolean);
    procedure SetEnterCharacter(const Value: string);
    procedure SetAlphabets(const Value: string);
    procedure SetTextOutType(const Value: TDXPowerFontTextOutType);
    procedure SetTextOutEffect(const Value: TDXPowerFontTextOutEffect);
    procedure SetEffectsParameters(const Value: TDXPowerFontEffectsParameters);
  published
    property Font: string read FFont write SetFont;
    property FontIndex: Integer read FFontIndex write SetFontIndex;
    property DXImageList: TDXImageList read FDXImageList write FDXImageList;
    property UseEnterChar: Boolean read FUseEnterChar write SetUseEnterChar;
    property EnterCharacter: string read FEnterCharacter write SetEnterCharacter;
    property BeforeTextOut: TDXPowerFontBeforeTextOutEvent read FBeforeTextOut write FBeforeTextOut;
    property AfterTextOut: TDXPowerFontAfterTextOutEvent read FAfterTextOut write FAfterTextOut;
    property Alphabets: string read FAlphabets write SetAlphabets;
    property TextOutType: TDXPowerFontTextOutType read FTextOutType write SetTextOutType;
    property TextOutEffect: TDXPowerFontTextOutEffect read FTextOutEffect write SetTextOutEffect;
    property EffectsParameters: TDXPowerFontEffectsParameters read FEffectsParameters write SetEffectsParameters;
  public
    Offset: integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function TextOut(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string): Boolean;
    function TextOutFast(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string): Boolean;
  end;

 {D2D unit for pure HW support
 *  Copyright (c) 2004-2006 Jaro Benes
 *  All Rights Reserved
 *  Version 1.07
 *  D2D Hardware module - interface part
 *  web site: www.micrel.cz/Dx
 *  e-mail: delphix_d2d@micrel.cz
 }

  {supported texture vertex as substitute type from DirectX}

  TD2DTextureFilter = (D2D_POINT, D2D_LINEAR, D2D_FLATCUBIC, D2D_GAUSSIANCUBIC, D2D_ANISOTROPIC);
  {TD2D4Vertex - used with D2DTexturedOn}

  TD2D4Vertex = array[0..3] of TD3DTLVERTEX;

  {TD2DTextures - texture storage used with Direct3D}

  TTextureRec = array{$IFDEF DelphiX_Delphi3} [0..0]{$ENDIF} of record
    D2DTexture: TDirect3DTexture2;
    FloatX1, FloatY1, FloatX2, FloatY2: Double; //uschov vyrez
    Name: string{$IFDEF DelphiX_Delphi3} [255]{$ENDIF}; //jmeno obrazku pro snadne dohledani
    Width, Height: Integer;
    AlphaChannel: Boolean;  //.06c
  end;
{$IFDEF DelphiX_Delphi3}
  PTextureRec = ^TTextureRec;
  EMaxTexturesError = class(Exception);
{$ENDIF}
  TD2DTextures = class
  public
{$IFDEF DelphiX_Delphi3}
    TexLen: Integer;
    Texture: PTextureRec;
{$ELSE}
    Texture: TTextureRec;
{$ENDIF}
    constructor Create;
    function Find(byName: string): Integer;
  end;

  {Main component for HW support}

  TD2D = class
  private
    FDDraw: TCustomDXDraw;
    FCanUseD2D: Boolean;
    FBitCount: Integer;
    FD2DTextureFilter: TD2DTextureFilter;
    FD2DAntialiasFilter: TD3DAntialiasMode;
    FVertex: TD2D4Vertex;
    FD2DTexture: TD2DTextures;
    function GetD2DMaxTextures: Integer;
    procedure SetD2DMaxTextures(const Value: Integer);
    {ukazuje pocet textur}
    property D2DMaxTextures: Integer read GetD2DMaxTextures write SetD2DMaxTextures;
    procedure D2DPruneTextures;
    procedure D2DPruneAllTextures;
    procedure D2DFreeTextures;

    procedure SetCanUseD2D(const Value: Boolean);
    function GetCanUseD2D: Boolean;
    {create the component}
    constructor Create(DDraw: TCustomDXDraw);
    procedure SetD2DTextureFilter(const Value: TD2DTextureFilter);
    procedure SetD2DAntialiasFilter(const Value: TD3DAntialiasMode);
    procedure D2DEffectSolid;
    procedure D2DEffectAdd;
    procedure D2DEffectSub;
    procedure D2DEffectBlend; // used with alpha

    {verticies}
    procedure InitVertex;
    function D2DWhite: Integer;
    procedure D2DColoredVertex(C: Integer);
    function D2DAlphaVertex(Alpha: Integer): Integer;
    procedure D2DSpecularVertex(C: Integer);
    procedure D2DColAlpha(C, Alpha: Integer);
    procedure D2DCol4Alpha(C1, C2, C3, C4, Alpha: Integer);
    {Fade used with Add and Sub}
    function D2DFade(Alpha: integer): Integer;
    procedure D2DFadeColored(C, Alpha: integer);
    procedure D2DFade4Colored(C1, C2, C3, C4, Alpha: integer);

    procedure RenderQuad;
    procedure RenderTri;

    procedure D2DRect(R: TRect);
    {texturing}
    function D2DTexturedOn(Image: TPictureCollectionItem; Pattern: Integer; SubPatternRect: TRect; RenderType: TRenderType): Boolean;
    function D2DTexturedOnDDS(dds: TDirectDrawSurface; SubPatternRect: TRect; Transparent: Boolean): Boolean;
    function D2DTexturedOnRect(Rect: TRect; Color: Integer): Boolean;

    {low level for rotate mesh}
    procedure D2DRotate(X, Y, W, H: Integer; Px, Py: Double; Angle: single);
    {low level bump-mapping routines}
    function D2DEffectEnvBumpMap(const lpDDSBase, lpDDSBump,
      lpDDSLightMap: IDirectDrawSurface7; ITypeBPE: Integer; Alpha: Byte): Boolean;
    function D2DEffectEmbossBumpMap(const lpDDSBase, lpDDSBump: IDirectDrawSurface7): Boolean;
    procedure SizeAdjust(var DIB: TDIB; var FloatX1, FloatY1, FloatX2,
      FloatY2: Double);
    {low lever routine for mesh mapping}
    procedure D2DMeshMapToRect(R: TRect);
    function D2DMeshMapToWave(dds: TDirectDrawSurface; Transparent: Boolean;
      TransparentColor: Integer; X, Y, iWidth, iHeight, PatternIndex: Integer;
      PatternRect: TRect;
      Amp, Len, Ph, Alpha: Integer;
      Effect: TRenderType; DoY: Boolean{$IFDEF DelphiX_Spt4} = False{$ENDIF}): Boolean;
  public
    {destruction textures and supported objects here}
    destructor Destroy; override;
    {use before starting rendering}
    procedure BeginScene;
    {use after all images have been rendered}
    procedure EndScene;
    {set directly of texture filter}
    property TextureFilter: TD2DTextureFilter write SetD2DTextureFilter;
    {indicate using of this object}
    property CanUseD2D: Boolean read GetCanUseD2D write SetCanUseD2D;
    {initialize surface}
    function D2DInitializeSurface: Boolean;

    {Render routines}
    function D2DRender(Image: TPictureCollectionItem; R: TRect;
      Pattern: Integer; RenderType: TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;

    function D2DRenderDDS(Source: TDirectDrawSurface; R: TRect; Transparent: Boolean;
      Pattern: Integer; RenderType: TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;

    function D2DRenderCol(Image: TPictureCollectionItem; R: TRect;
      Pattern, Color: integer; RenderType: TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;
    function D2DRenderColDDS(Source: TDirectDrawSurface; R: TRect;
      Transparent: Boolean; Pattern, Color: Integer; RenderType:
      TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;

    function D2DRenderDrawDDSXY(Source: TDirectDrawSurface; X, Y: Integer;
      Transparent: Boolean; Pattern: Integer; RenderType: TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): boolean;
{$IFDEF DelphiX_Spt4} overload;
    function D2DRenderDrawDDSXY(Source: TDirectDrawSurface; X, Y: Integer;
      SrcRect: TRect; Transparent: Boolean; Pattern: Integer; RenderType: TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): boolean; overload;
{$ENDIF}
    function D2DRenderDrawXY(Image: TPictureCollectionItem; X, Y: Integer;
      Pattern: Integer; RenderType: TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): boolean;

    {Rotate}
    function D2DRenderRotate(Image: TPictureCollectionItem; RotX, RotY,
      PictWidth, PictHeight, PatternIndex: Integer; RenderType: TRenderType;
      CenterX, CenterY: Double; Angle: single; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;
    function D2DRenderRotateDDS(Image: TDirectDrawSurface; RotX, RotY,
      PictWidth, PictHeight: Integer; RenderType: TRenderType;
      CenterX, CenterY: Double; Angle: single; Alpha: Byte;
      Transparent: Boolean): Boolean;

    function D2DRenderRotateModeCol(Image: TPictureCollectionItem; RenderType: TRenderType; RotX, RotY,
      PictWidth, PictHeight, PatternIndex: Integer; CenterX, CenterY: Double;
      Angle: single; Color: integer; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): boolean;
    function D2DRenderRotateModeColDDS(Image: TDirectDrawSurface;
      RotX, RotY, PictWidth, PictHeight: Integer; RenderType: TRenderType;
      CenterX, CenterY: Double; Angle: Single; Color: Integer; Alpha: Byte;
      Transparent: Boolean): Boolean;

    {WaveX}
    function D2DRenderWaveX(Image: TPictureCollectionItem; X, Y, Width, Height,
      PatternIndex: Integer; RenderType: TRenderType; Transparent: Boolean;
      Amp, Len, Ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;
    function D2DRenderWaveXDDS(Source: TDirectDrawSurface; X, Y, Width,
      Height: Integer; RenderType: TRenderType; Transparent: Boolean;
      Amp, Len, Ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;

    {WaveY}
    function D2DRenderWaveY(Image: TPictureCollectionItem; X, Y, Width, Height,
      PatternIndex: Integer; RenderType: TRenderType; Transparent: Boolean;
      Amp, Len, Ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;
    function D2DRenderWaveYDDS(Source: TDirectDrawSurface; X, Y, Width,
      Height: Integer; RenderType: TRenderType; Transparent: Boolean;
      Amp, Len, Ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;

    {Rect}
    function D2DRenderFillRect(Rect: TRect; RGBColor: LongInt;
      RenderType: TRenderType; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;

    {bump-mapping render}
    function D2DRenderEnvBumpMap(Image, Bump,
      Light: TPictureCollectionItem; R: TRect; ImagePattern, BumpPattern,
      LightPattern: Integer; Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;

    {addmod}
    function D2DRenderColoredPartition(Image: TPictureCollectionItem; DestRect: TRect; PatternIndex,
      Color, Specular: Integer; Faded: Boolean;
      SourceRect: TRect;
      RenderType: TRenderType;
      Alpha: Byte{$IFDEF DelphiX_Spt4} = 255{$ENDIF}): Boolean;
  end;

{ Support functions for texturing }
function dxtMakeChannel(Mask: DWORD; indexed: Boolean): TDXTextureImageChannel;
function dxtEncodeChannel(const Channel: TDXTextureImageChannel; c: DWORD): DWORD;
function dxtDecodeChannel(const Channel: TDXTextureImageChannel; c: DWORD): DWORD;

{ Single support routine for convert DIB32 to DXT in one line }
procedure dib2dxt(DIBImage: TDIB; out DXTImage: TDXTextureImage);

implementation

uses DXConsts, DXRender;

function DXDirectDrawEnumerate(lpCallback: TDDEnumCallbackA;
  lpContext: Pointer): HRESULT;
type
  TDirectDrawEnumerate = function(lpCallback: TDDEnumCallbackA;
    lpContext: Pointer): HRESULT; stdcall;
begin
  Result := TDirectDrawEnumerate(DXLoadLibrary('DDraw.dll', 'DirectDrawEnumerateA'))
    (lpCallback, lpContext);
end;

var
  DirectDrawDrivers: TDirectXDrivers;
  D2D: TD2D = nil; {for internal use only, }
  RenderError: boolean = false;

function EnumDirectDrawDrivers: TDirectXDrivers;

  function DDENUMCALLBACK(lpGuid: PGUID; lpstrDescription: LPCSTR;
    lpstrModule: LPCSTR; lpContext: Pointer): BOOL; stdcall;
  begin
    Result := True;
    with TDirectXDriver.Create(TDirectXDrivers(lpContext)) do
    begin
      Guid := lpGuid;
      Description := lpstrDescription;
      DriverName := lpstrModule;
    end;
  end;

begin
  if DirectDrawDrivers = nil then
  begin
    DirectDrawDrivers := TDirectXDrivers.Create;
    try
      DXDirectDrawEnumerate(@DDENUMCALLBACK, DirectDrawDrivers);
    except
      DirectDrawDrivers.Free;
      raise;
    end;
  end;

  Result := DirectDrawDrivers;
end;

function ClipRect(var DestRect: TRect; const DestRect2: TRect): Boolean;
begin
  with DestRect do
  begin
    Left := Max(Left, DestRect2.Left);
    Right := Min(Right, DestRect2.Right);
    Top := Max(Top, DestRect2.Top);
    Bottom := Min(Bottom, DestRect2.Bottom);

    Result := (Left < Right) and (Top < Bottom);
  end;
end;

function ClipRect2(var DestRect, SrcRect: TRect; const DestRect2, SrcRect2: TRect): Boolean;
begin
  if DestRect.Left < DestRect2.Left then
  begin
    SrcRect.Left := SrcRect.Left + (DestRect2.Left - DestRect.Left);
    DestRect.Left := DestRect2.Left;
  end;

  if DestRect.Top < DestRect2.Top then
  begin
    SrcRect.Top := SrcRect.Top + (DestRect2.Top - DestRect.Top);
    DestRect.Top := DestRect2.Top;
  end;

  if SrcRect.Left < SrcRect2.Left then
  begin
    DestRect.Left := DestRect.Left + (SrcRect2.Left - SrcRect.Left);
    SrcRect.Left := SrcRect2.Left;
  end;

  if SrcRect.Top < SrcRect2.Top then
  begin
    DestRect.Top := DestRect.Top + (SrcRect2.Top - SrcRect.Top);
    SrcRect.Top := SrcRect2.Top;
  end;

  if DestRect.Right > DestRect2.Right then
  begin
    SrcRect.Right := SrcRect.Right - (DestRect.Right - DestRect2.Right);
    DestRect.Right := DestRect2.Right;
  end;

  if DestRect.Bottom > DestRect2.Bottom then
  begin
    SrcRect.Bottom := SrcRect.Bottom - (DestRect.Bottom - DestRect2.Bottom);
    DestRect.Bottom := DestRect2.Bottom;
  end;

  if SrcRect.Right > SrcRect2.Right then
  begin
    DestRect.Right := DestRect.Right - (SrcRect.Right - SrcRect2.Right);
    SrcRect.Right := SrcRect2.Right;
  end;

  if SrcRect.Bottom > SrcRect2.Bottom then
  begin
    DestRect.Bottom := DestRect.Bottom - (SrcRect.Bottom - SrcRect2.Bottom);
    SrcRect.Bottom := SrcRect2.Bottom;
  end;

  Result := (DestRect.Left < DestRect.Right) and (DestRect.Top < DestRect.Bottom) and
    (SrcRect.Left < SrcRect.Right) and (SrcRect.Top < SrcRect.Bottom);
end;

{  TDirectDraw  }

constructor TDirectDraw.Create(GUID: PGUID);
begin
  CreateEx(GUID, True);
end;

constructor TDirectDraw.CreateEx(GUID: PGUID; DirectX7Mode: Boolean);
type
  TDirectDrawCreate = function(lpGUID: PGUID; out lplpDD: IDirectDraw;
    pUnkOuter: IUnknown): HRESULT; stdcall;

  TDirectDrawCreateEx = function(lpGUID: PGUID; out lplpDD: IDirectDraw7; const iid: TGUID;
    pUnkOuter: IUnknown): HRESULT; stdcall;
begin
  inherited Create;
  FClippers := TList.Create;
  FPalettes := TList.Create;
  FSurfaces := TList.Create;

  if DirectX7Mode then
  begin
    { DirectX 7 }
    if TDirectDrawCreateEx(DXLoadLibrary('DDraw.dll', 'DirectDrawCreateEx'))(GUID, FIDDraw7, IID_IDirectDraw7, nil) <> DD_OK then
      raise EDirectDrawError.CreateFmt(SCannotInitialized, [SDirectDraw]);
    try
      FIDDraw := FIDDraw7 as IDirectDraw;
      FIDDraw4 := FIDDraw7 as IDirectDraw4;
    except
      raise EDirectDrawError.Create(SSinceDirectX7);
    end;
  end else
  begin
    if TDirectDrawCreate(DXLoadLibrary('DDraw.dll', 'DirectDrawCreate'))(GUID, FIDDraw, nil) <> DD_OK then
      raise EDirectDrawError.CreateFmt(SCannotInitialized, [SDirectDraw]);
    try
      FIDDraw4 := FIDDraw as IDirectDraw4;
    except
      raise EDirectDrawError.Create(SSinceDirectX6);
    end;
  end;

  FDriverCaps.dwSize := SizeOf(FDriverCaps);
  FHELCaps.dwSize := SizeOf(FHELCaps);
  FIDDraw.GetCaps(@FDriverCaps, @FHELCaps);
end;

destructor TDirectDraw.Destroy;
begin
  while SurfaceCount > 0 do
    Surfaces[SurfaceCount - 1].Free;

  while PaletteCount > 0 do
    Palettes[PaletteCount - 1].Free;

  while ClipperCount > 0 do
    Clippers[ClipperCount - 1].Free;

  FSurfaces.Free;
  FPalettes.Free;
  FClippers.Free;
  inherited Destroy;
end;

class function TDirectDraw.Drivers: TDirectXDrivers;
begin
  Result := EnumDirectDrawDrivers;
end;

function TDirectDraw.GetClipper(Index: Integer): TDirectDrawClipper;
begin
  Result := FClippers[Index];
end;

function TDirectDraw.GetClipperCount: Integer;
begin
  Result := FClippers.Count;
end;

function TDirectDraw.GetDisplayMode: TDDSurfaceDesc;
begin
  Result.dwSize := SizeOf(Result);
  DXResult := IDraw.GetDisplayMode(Result);
  if DXResult <> DD_OK then
    FillChar(Result, SizeOf(Result), 0);
end;

function TDirectDraw.GetIDDraw: IDirectDraw;
begin
  if Self <> nil then
    Result := FIDDraw
  else
    Result := nil;
end;

function TDirectDraw.GetIDDraw4: IDirectDraw4;
begin
  if Self <> nil then
    Result := FIDDraw4
  else
    Result := nil;
end;

function TDirectDraw.GetIDDraw7: IDirectDraw7;
begin
  if Self <> nil then
    Result := FIDDraw7
  else
    Result := nil;
end;

function TDirectDraw.GetIDraw: IDirectDraw;
begin
  Result := IDDraw;
  if Result = nil then
    raise EDirectDrawError.CreateFmt(SNotMade, ['IDirectDraw']);
end;

function TDirectDraw.GetIDraw4: IDirectDraw4;
begin
  Result := IDDraw4;
  if Result = nil then
    raise EDirectDrawError.CreateFmt(SNotMade, ['IDirectDraw4']);
end;

function TDirectDraw.GetIDraw7: IDirectDraw7;
begin
  Result := IDDraw7;
  if Result = nil then
    raise EDirectDrawError.CreateFmt(SNotMade, ['IDirectDraw7']);
end;

function TDirectDraw.GetPalette(Index: Integer): TDirectDrawPalette;
begin
  Result := FPalettes[Index];
end;

function TDirectDraw.GetPaletteCount: Integer;
begin
  Result := FPalettes.Count;
end;

function TDirectDraw.GetSurface(Index: Integer): TDirectDrawSurface;
begin
  Result := FSurfaces[Index];
end;

function TDirectDraw.GetSurfaceCount: Integer;
begin
  Result := FSurfaces.Count;
end;

{  TDirectDrawPalette  }

constructor TDirectDrawPalette.Create(ADirectDraw: TDirectDraw);
begin
  inherited Create;
  FDDraw := ADirectDraw;
  FDDraw.FPalettes.Add(Self);
end;

destructor TDirectDrawPalette.Destroy;
begin
  FDDraw.FPalettes.Remove(Self);
  inherited Destroy;
end;

function TDirectDrawPalette.CreatePalette(Caps: DWORD; const Entries): Boolean;
var
  TempPalette: IDirectDrawPalette;
begin
  IDDPalette := nil;

  FDDraw.DXResult := FDDraw.IDraw.CreatePalette(Caps, @Entries, TempPalette, nil);
  FDXResult := FDDraw.DXResult;
  Result := FDDraw.DXResult = DD_OK;
  if Result then
    IDDPalette := TempPalette;
end;

procedure TDirectDrawPalette.LoadFromDIB(DIB: TDIB);
var
  Entries: TPaletteEntries;
begin
  Entries := RGBQuadsToPaletteEntries(DIB.ColorTable);
  CreatePalette(DDPCAPS_8BIT, Entries);
end;

procedure TDirectDrawPalette.LoadFromFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TDirectDrawPalette.LoadFromStream(Stream: TStream);
var
  DIB: TDIB;
begin
  DIB := TDIB.Create;
  try
    DIB.LoadFromStream(Stream);
    if DIB.Size > 0 then
      LoadFromDIB(DIB);
  finally
    DIB.Free;
  end;
end;

function TDirectDrawPalette.GetEntries(StartIndex, NumEntries: Integer;
  var Entries): Boolean;
begin
  if IDDPalette <> nil then
  begin
    DXResult := IPalette.GetEntries(0, StartIndex, NumEntries, @Entries);
    Result := DXResult = DD_OK;
  end else
    Result := False;
end;

function TDirectDrawPalette.GetEntry(Index: Integer): TPaletteEntry;
begin
  GetEntries(Index, 1, Result);
end;

function TDirectDrawPalette.GetIDDPalette: IDirectDrawPalette;
begin
  if Self <> nil then
    Result := FIDDPalette
  else
    Result := nil;
end;

function TDirectDrawPalette.GetIPalette: IDirectDrawPalette;
begin
  Result := IDDPalette;
  if Result = nil then
    raise EDirectDrawPaletteError.CreateFmt(SNotMade, ['IDirectDrawPalette']);
end;

function TDirectDrawPalette.SetEntries(StartIndex, NumEntries: Integer;
  const Entries): Boolean;
begin
  if IDDPalette <> nil then
  begin
    DXResult := IPalette.SetEntries(0, StartIndex, NumEntries, @Entries);
    Result := DXResult = DD_OK;
  end else
    Result := False;
end;

procedure TDirectDrawPalette.SetEntry(Index: Integer; Value: TPaletteEntry);
begin
  SetEntries(Index, 1, Value);
end;

procedure TDirectDrawPalette.SetIDDPalette(Value: IDirectDrawPalette);
begin
  if FIDDPalette = Value then Exit;
  FIDDPalette := Value;
end;

{  TDirectDrawClipper  }

constructor TDirectDrawClipper.Create(ADirectDraw: TDirectDraw);
begin
  inherited Create;
  FDDraw := ADirectDraw;
  FDDraw.FClippers.Add(Self);

  FDDraw.DXResult := FDDraw.IDraw.CreateClipper(0, FIDDClipper, nil);
  if FDDraw.DXResult <> DD_OK then
    raise EDirectDrawClipperError.CreateFmt(SCannotMade, [SDirectDrawClipper]);
end;

destructor TDirectDrawClipper.Destroy;
begin
  FDDraw.FClippers.Remove(Self);
  inherited Destroy;
end;

function TDirectDrawClipper.GetIDDClipper: IDirectDrawClipper;
begin
  if Self <> nil then
    Result := FIDDClipper
  else
    Result := nil;
end;

function TDirectDrawClipper.GetIClipper: IDirectDrawClipper;
begin
  Result := IDDClipper;
  if Result = nil then
    raise EDirectDrawClipperError.CreateFmt(SNotMade, ['IDirectDrawClipper']);
end;

procedure TDirectDrawClipper.SetClipRects(const Rects: array of TRect);
type
  PArrayRect = ^TArrayRect;
  TArrayRect = array[0..0] of TRect;
var
  RgnData: PRgnData;
  i: Integer;
  BoundsRect: TRect;
begin
  BoundsRect := Rect(MaxInt, MaxInt, -MaxInt, -MaxInt);
  for i := Low(Rects) to High(Rects) do
  begin
    with BoundsRect do
    begin
      Left := Min(Rects[i].Left, Left);
      Right := Max(Rects[i].Right, Right);
      Top := Min(Rects[i].Top, Top);
      Bottom := Max(Rects[i].Bottom, Bottom);
    end;
  end;

  GetMem(RgnData, SizeOf(TRgnDataHeader) + SizeOf(TRect) * (High(Rects) - Low(Rects) + 1));
  try
    with RgnData^.rdh do
    begin
      dwSize := SizeOf(TRgnDataHeader);
      iType := RDH_RECTANGLES;
      nCount := High(Rects) - Low(Rects) + 1;
      nRgnSize := nCount * SizeOf(TRect);
      rcBound := BoundsRect;
    end;
    for i := Low(Rects) to High(Rects) do
      PArrayRect(@RgnData^.Buffer)^[i - Low(Rects)] := Rects[i];
    DXResult := IClipper.SetClipList(RgnData, 0);
  finally
    FreeMem(RgnData);
  end;
end;

procedure TDirectDrawClipper.SetHandle(Value: THandle);
begin
  DXResult := IClipper.SetHWnd(0, Value);
end;

procedure TDirectDrawClipper.SetIDDClipper(Value: IDirectDrawClipper);
begin
  if FIDDClipper = Value then Exit;
  FIDDClipper := Value;
end;

{  TDirectDrawSurfaceCanvas  }

constructor TDirectDrawSurfaceCanvas.Create(ASurface: TDirectDrawSurface);
begin
  inherited Create;
  FSurface := ASurface;
end;

destructor TDirectDrawSurfaceCanvas.Destroy;
begin
  Release;
  FSurface.FCanvas := nil;
  inherited Destroy;
end;

procedure TDirectDrawSurfaceCanvas.CreateHandle;
begin
  FSurface.DXResult := FSurface.ISurface.GetDC(FDC);
  if FSurface.DXResult = DD_OK then
    Handle := FDC;
end;

procedure TDirectDrawSurfaceCanvas.Release;
begin
  if (FSurface.IDDSurface <> nil) and (FDC <> 0) then
  begin
    Handle := 0;
    FSurface.IDDSurface.ReleaseDC(FDC);
    FDC := 0;
  end;
end;

{  TDirectDrawSurface  }

constructor TDirectDrawSurface.Create(ADirectDraw: TDirectDraw);
begin
  inherited Create;
  FDDraw := ADirectDraw;
  FDDraw.FSurfaces.Add(Self);
end;

destructor TDirectDrawSurface.Destroy;
begin
  FCanvas.Free;
  IDDSurface := nil;
  FDDraw.FSurfaces.Remove(Self);
  inherited Destroy;
end;

function TDirectDrawSurface.GetIDDSurface: IDirectDrawSurface;
begin
  if Self <> nil then
    Result := FIDDSurface
  else
    Result := nil;
end;

function TDirectDrawSurface.GetIDDSurface4: IDirectDrawSurface4;
begin
  if Self <> nil then
    Result := FIDDSurface4
  else
    Result := nil;
end;

function TDirectDrawSurface.GetIDDSurface7: IDirectDrawSurface7;
begin
  if Self <> nil then
    Result := FIDDSurface7
  else
    Result := nil;
end;

function TDirectDrawSurface.GetISurface: IDirectDrawSurface;
begin
  Result := IDDSurface;
  if Result = nil then
    raise EDirectDrawSurfaceError.CreateFmt(SNotMade, ['IDirectDrawSurface']);
end;

function TDirectDrawSurface.GetISurface4: IDirectDrawSurface4;
begin
  Result := IDDSurface4;
  if Result = nil then
    raise EDirectDrawSurfaceError.CreateFmt(SNotMade, ['IDirectDrawSurface4']);
end;

function TDirectDrawSurface.GetISurface7: IDirectDrawSurface7;
begin
  Result := IDDSurface7;
  if Result = nil then
    raise EDirectDrawSurfaceError.CreateFmt(SNotMade, ['IDirectDrawSurface7']);
end;

procedure TDirectDrawSurface.SetIDDSurface(Value: IDirectDrawSurface);
var
  Clipper: IDirectDrawClipper;
begin
  if Value = nil then Exit;
  if Value as IDirectDrawSurface = FIDDSurface then Exit;

  FIDDSurface := nil;
  FIDDSurface4 := nil;
  FIDDSurface7 := nil;

  FStretchDrawClipper := nil;
  FGammaControl := nil;
  FHasClipper := False;
  FLockCount := 0;
  FillChar(FSurfaceDesc, SizeOf(FSurfaceDesc), 0);

  if Value <> nil then
  begin
    FIDDSurface := Value as IDirectDrawSurface;
    FIDDSurface4 := Value as IDirectDrawSurface4;
    if FDDraw.FIDDraw7 <> nil then FIDDSurface7 := Value as IDirectDrawSurface7;

    FHasClipper := (FIDDSurface.GetClipper(Clipper) = DD_OK) and (Clipper <> nil);

    FSurfaceDesc.dwSize := SizeOf(FSurfaceDesc);
    FIDDSurface.GetSurfaceDesc(FSurfaceDesc);

    if FDDraw.DriverCaps.dwCaps2 and DDCAPS2_PRIMARYGAMMA <> 0 then
      FIDDSurface.QueryInterface(IID_IDirectDrawGammaControl, FGammaControl);
  end;
end;

procedure TDirectDrawSurface.SetIDDSurface4(Value: IDirectDrawSurface4);
begin
  if Value = nil then
    SetIDDSurface(nil)
  else
    SetIDDSurface(Value as IDirectDrawSurface);
end;

procedure TDirectDrawSurface.SetIDDSurface7(Value: IDirectDrawSurface7);
begin
  if Value = nil then
    SetIDDSurface(nil)
  else
    SetIDDSurface(Value as IDirectDrawSurface);
end;

procedure TDirectDrawSurface.Assign(Source: TPersistent);
var
  TempSurface: IDirectDrawSurface;
begin
  if Source = nil then
    IDDSurface := nil
  else if Source is TGraphic then
    LoadFromGraphic(TGraphic(Source))
  else if Source is TPicture then
    LoadFromGraphic(TPicture(Source).Graphic)
  else if Source is TDirectDrawSurface then
  begin
    if TDirectDrawSurface(Source).IDDSurface = nil then
      IDDSurface := nil
    else begin
      FDDraw.DXResult := FDDraw.IDraw.DuplicateSurface(TDirectDrawSurface(Source).IDDSurface,
        TempSurface);
      if FDDraw.DXResult = 0 then
      begin
        IDDSurface := TempSurface;
      end;
    end;
  end else
    inherited Assign(Source);
end;

procedure TDirectDrawSurface.AssignTo(Dest: TPersistent);
begin
  if Dest is TDIB then
  begin
    try
      if BitCount >= 24 then {please accept the Alphachannel too}
        TDIB(Dest).SetSize(Width, Height, BitCount)
      else
        TDIB(Dest).SetSize(Width, Height, 24);
      TDIB(Dest).Canvas.CopyRect(Rect(0, 0, TDIB(Dest).Width, TDIB(Dest).Height), Canvas, ClientRect);
    finally
      Canvas.Release;
    end
  end else
    inherited AssignTo(Dest);
end;

function TDirectDrawSurface.Blt(const DestRect, SrcRect: TRect; Flags: DWORD;
  const DF: TDDBltFX; Source: TDirectDrawSurface): Boolean;
begin
  if IDDSurface <> nil then
  begin
    DXResult := ISurface.Blt(@DestRect, Source.IDDSurface, @SrcRect, DWORD(Flags), @DF);
    Result := DXResult = DD_OK;
  end else
    Result := False;
end;

function TDirectDrawSurface.BltFast(X, Y: Integer; const SrcRect: TRect;
  Flags: DWORD; Source: TDirectDrawSurface): Boolean;
begin
  if IDDSurface <> nil then
  begin
    DXResult := ISurface.BltFast(X, Y, Source.IDDSurface, @SrcRect, DWORD(Flags));
    Result := DXResult = DD_OK;
  end else
    Result := False;
end;

function TDirectDrawSurface.ColorMatch(Col: TColor): Integer;
var
  DIB: TDIB;
  i, oldc: Integer;
begin
  if IDDSurface <> nil then
  begin
    oldc := Pixels[0, 0];

    DIB := TDIB.Create;
    try
      i := ColorToRGB(Col);
      DIB.SetSize(1, 1, 8);
      DIB.ColorTable[0] := RGBQuad(GetRValue(i), GetGValue(i), GetBValue(i));
      DIB.UpdatePalette;
      DIB.Pixels[0, 0] := 0;

      with Canvas do
      try
        Draw(0, 0, DIB);
      finally
        Release;
      end;
    finally
      DIB.Free;
    end;
    Result := Pixels[0, 0];
    Pixels[0, 0] := oldc;
  end else
    Result := 0;
end;

function TDirectDrawSurface.CreateSurface(SurfaceDesc: TDDSurfaceDesc): Boolean;
var
  TempSurface: IDirectDrawSurface;
begin
  IDDSurface := nil;

  FDDraw.DXResult := FDDraw.IDraw.CreateSurface(SurfaceDesc, TempSurface, nil);
  FDXResult := FDDraw.DXResult;
  Result := FDDraw.DXResult = DD_OK;
  if Result then
  begin
    IDDSurface := TempSurface;
    TransparentColor := 0;
  end;
end;

{$IFDEF DelphiX_Spt4}

function TDirectDrawSurface.CreateSurface(SurfaceDesc: TDDSurfaceDesc2): Boolean;
var
  TempSurface4: IDirectDrawSurface4;
begin
  IDDSurface := nil;
  FDDraw.DXResult := FDDraw.IDraw4.CreateSurface(SurfaceDesc, TempSurface4, nil);
  FDXResult := FDDraw.DXResult;
  Result := FDDraw.DXResult = DD_OK;
  if Result then
  begin
    IDDSurface4 := TempSurface4;
    TransparentColor := 0;
  end;
end;
{$ENDIF}

procedure TDirectDrawSurface.Draw(X, Y: Integer; SrcRect: TRect; Source: TDirectDrawSurface;
  Transparent: Boolean);
const
  BltFastFlags: array[Boolean] of Integer =
  (DDBLTFAST_NOCOLORKEY or DDBLTFAST_WAIT, DDBLTFAST_SRCCOLORKEY or DDBLTFAST_WAIT);
  BltFlags: array[Boolean] of Integer =
  (DDBLT_WAIT, DDBLT_KEYSRC or DDBLT_WAIT);
var
  DestRect: TRect;
  DF: TDDBltFX;
  Clipper: IDirectDrawClipper;
  i: Integer;
begin
  if Source <> nil then
  begin
    if (X > Width) or (Y > Height) then Exit;
{$IFDEF DrawHWAcc}
    if AsSigned(D2D) then
      if D2D.CanUseD2D then
        if D2D.FDDraw.Surface = Self then begin
          {$IFDEF DelphiX_Delphi3}
          D2D.D2DRenderDDS(Source, Bounds(X, Y, SrcRect.Right - SrcRect.Left, SrcRect.Bottom - SrcRect.Top), Transparent, 0, rtDraw, $FF);
          {$ELSE}
          D2D.D2DRenderDrawDDSXY(Source, X, Y, SrcRect, Transparent, 0, rtDraw{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
          {$ENDIF}
          Exit;
        end;
{$ENDIF DrawHWAcc}
    if (SrcRect.Left > SrcRect.Right) or (SrcRect.Top > SrcRect.Bottom) then
    begin
      {  Mirror  }
      if ((X + Abs(SrcRect.Left - SrcRect.Right)) <= 0) or
        ((Y + Abs(SrcRect.Top - SrcRect.Bottom)) <= 0) then Exit;

      DF.dwsize := SizeOf(DF);
      DF.dwDDFX := 0;

      if SrcRect.Left > SrcRect.Right then
      begin
        i := SrcRect.Left; SrcRect.Left := SrcRect.Right; SrcRect.Right := i;
        DF.dwDDFX := DF.dwDDFX or DDBLTFX_MIRRORLEFTRIGHT;
      end;

      if SrcRect.Top > SrcRect.Bottom then
      begin
        i := SrcRect.Top; SrcRect.Top := SrcRect.Bottom; SrcRect.Bottom := i;
        DF.dwDDFX := DF.dwDDFX or DDBLTFX_MIRRORUPDOWN;
      end;

      with SrcRect do
        DestRect := Bounds(X, Y, Right - Left, Bottom - Top);

      if ClipRect2(DestRect, SrcRect, ClientRect, Source.ClientRect) then
      begin
        if DF.dwDDFX and DDBLTFX_MIRRORLEFTRIGHT <> 0 then
        begin
          i := SrcRect.Left;
          SrcRect.Left := Source.Width - SrcRect.Right;
          SrcRect.Right := Source.Width - i;
        end;

        if DF.dwDDFX and DDBLTFX_MIRRORUPDOWN <> 0 then
        begin
          i := SrcRect.Top;
          SrcRect.Top := Source.Height - SrcRect.Bottom;
          SrcRect.Bottom := Source.Height - i;
        end;

        Blt(DestRect, SrcRect, BltFlags[Transparent] or DDBLT_DDFX, df, Source);
      end;
    end else
    begin
      with SrcRect do
        DestRect := Bounds(X, Y, Right - Left, Bottom - Top);

      if ClipRect2(DestRect, SrcRect, ClientRect, Source.ClientRect) then
      begin
        if FHasClipper then
        begin
          DF.dwsize := SizeOf(DF);
          DF.dwDDFX := 0;
          Blt(DestRect, SrcRect, BltFlags[Transparent], df, Source);
        end else
        begin
          BltFast(DestRect.Left, DestRect.Top, SrcRect, BltFastFlags[Transparent], Source);
          if DXResult = DDERR_BLTFASTCANTCLIP then
          begin
            ISurface.GetClipper(Clipper);
            if Clipper <> nil then FHasClipper := True;

            DF.dwsize := SizeOf(DF);
            DF.dwDDFX := 0;
            Blt(DestRect, SrcRect, BltFlags[Transparent], df, Source);
          end;
        end;
      end;
    end;
  end;
end;

{$IFDEF DelphiX_Spt4}

procedure TDirectDrawSurface.Draw(X, Y: Integer; Source: TDirectDrawSurface; Transparent: Boolean);
const
  BltFastFlags: array[Boolean] of Integer =
  (DDBLTFAST_NOCOLORKEY or DDBLTFAST_WAIT, DDBLTFAST_SRCCOLORKEY or DDBLTFAST_WAIT);
  BltFlags: array[Boolean] of Integer =
  (DDBLT_WAIT, DDBLT_KEYSRC or DDBLT_WAIT);
var
  DestRect, SrcRect: TRect;
  DF: TDDBltFX;
  Clipper: IDirectDrawClipper;
begin
  if Source <> nil then
  begin
    SrcRect := Source.ClientRect;
    DestRect := Bounds(X, Y, Source.Width, Source.Height);
{$IFDEF DrawHWAcc}
    if AsSigned(D2D) then
      if D2D.CanUseD2D then
        if D2D.FDDraw.Surface = Self then begin
          D2D.D2DRenderDDS(Source, DestRect, Transparent, 0, rtDraw{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
          Exit;
        end;
{$ENDIF DrawHWAcc}
    if ClipRect2(DestRect, SrcRect, ClientRect, Source.ClientRect) then
    begin
      if FHasClipper then
      begin
        DF.dwsize := SizeOf(DF);
        DF.dwDDFX := 0;
        Blt(DestRect, SrcRect, BltFlags[Transparent], df, Source);
      end else
      begin
        BltFast(DestRect.Left, DestRect.Top, SrcRect, BltFastFlags[Transparent], Source);
        if DXResult = DDERR_BLTFASTCANTCLIP then
        begin
          ISurface.GetClipper(Clipper);
          if Clipper <> nil then FHasClipper := True;

          DF.dwsize := SizeOf(DF);
          DF.dwDDFX := 0;
          Blt(DestRect, SrcRect, BltFlags[Transparent], df, Source);
        end;
      end;
    end;
  end;
end;
{$ENDIF}

procedure TDirectDrawSurface.StretchDraw(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
  Transparent: Boolean);
const
  BltFlags: array[Boolean] of Integer =
  (DDBLT_WAIT, DDBLT_KEYSRC or DDBLT_WAIT);
var
  DF: TDDBltFX;
  OldClipper: IDirectDrawClipper;
  Clipper: TDirectDrawClipper;
begin
  if Source <> nil then
  begin
    if (DestRect.Bottom <= DestRect.Top) or (DestRect.Right <= DestRect.Left) then Exit;
    if (SrcRect.Bottom <= SrcRect.Top) or (SrcRect.Right <= SrcRect.Left) then Exit;
{$IFDEF DrawHWAcc}
    if AsSigned(D2D) then
      if D2D.CanUseD2D then
        if D2D.FDDraw.Surface = Self then begin
          D2D.D2DRenderDDS(Source, DestRect, Transparent, 0, rtDraw{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
          Exit;
        end;
{$ENDIF DrawHWAcc}
    if FHasClipper then
    begin
      DF.dwsize := SizeOf(DF);
      DF.dwDDFX := 0;
      Blt(DestRect, SrcRect, BltFlags[Transparent], df, Source);
    end else
    begin
      if FStretchDrawClipper = nil then
      begin
        Clipper := TDirectDrawClipper.Create(DDraw);
        try
          Clipper.SetClipRects([ClientRect]);
          FStretchDrawClipper := Clipper.IClipper;
        finally
          Clipper.Free;
        end;
      end;

      ISurface.GetClipper(OldClipper);
      ISurface.SetClipper(FStretchDrawClipper);
      DF.dwsize := SizeOf(DF);
      DF.dwDDFX := 0;
      Blt(DestRect, SrcRect, BltFlags[Transparent], df, Source);
      ISurface.SetClipper(nil);
    end;
  end;
end;

{$IFDEF DelphiX_Spt4}

procedure TDirectDrawSurface.StretchDraw(const DestRect: TRect; Source: TDirectDrawSurface;
  Transparent: Boolean);
const
  BltFlags: array[Boolean] of Integer =

  (DDBLT_WAIT, DDBLT_KEYSRC or DDBLT_WAIT);
var
  DF: TDDBltFX;
  OldClipper: IDirectDrawClipper;
  Clipper: TDirectDrawClipper;
  SrcRect: TRect;
begin
  if Source <> nil then
  begin
    if (DestRect.Bottom <= DestRect.Top) or (DestRect.Right <= DestRect.Left) then Exit;
    SrcRect := Source.ClientRect;

    if AsSigned(D2D) then
      if D2D.CanUseD2D then
        if D2D.FDDraw.Surface = Self then begin
          D2D.D2DRenderDDS(Source, DestRect, Transparent, 0, rtDraw{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
          Exit;
        end;

    if ISurface.GetClipper(OldClipper) = DD_OK then
    begin
      DF.dwsize := SizeOf(DF);
      DF.dwDDFX := 0;
      Blt(DestRect, SrcRect, BltFlags[Transparent], df, Source);
    end else
    begin
      if FStretchDrawClipper = nil then
      begin
        Clipper := TDirectDrawClipper.Create(DDraw);
        try
          Clipper.SetClipRects([ClientRect]);
          FStretchDrawClipper := Clipper.IClipper;
        finally
          Clipper.Free;
        end;
      end;

      ISurface.SetClipper(FStretchDrawClipper);
      try
        DF.dwsize := SizeOf(DF);
        DF.dwDDFX := 0;
        Blt(DestRect, SrcRect, BltFlags[Transparent], df, Source);
      finally
        ISurface.SetClipper(nil);
      end;
    end;
  end;
end;
{$ENDIF}

procedure TDirectDrawSurface.DrawAdd(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
  Transparent: Boolean; Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if Alpha <= 0 then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderDDS(Source, DestRect, Transparent, 0, rtAdd, Alpha);
        Exit;
      end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
            if Alpha >= 255 then
            begin
              Blend := DXR_BLEND_ONE1_ADD_ONE2;
            end else
            begin
              Blend := DXR_BLEND_SRCALPHA1_ADD_ONE2;
            end;

          dxrCopyRectBlend(DestSurface, SrcSurface,
            DestRect, SrcRect, Blend, Alpha, Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawAlpha(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
  Transparent: Boolean; Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if Alpha <= 0 then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderDDS(Source, DestRect, Transparent, 0, rtBlend, Alpha);
        Exit;
      end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
            if Alpha >= 255 then
            begin
              Blend := DXR_BLEND_ONE1;
            end else
            begin
              Blend := DXR_BLEND_SRCALPHA1_ADD_INVSRCALPHA2;
            end;

          dxrCopyRectBlend(DestSurface, SrcSurface,
            DestRect, SrcRect, Blend, Alpha, Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawSub(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
  Transparent: Boolean; Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if Alpha <= 0 then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderDDS(Source, DestRect, Transparent, 0, rtSub, Alpha);
        Exit;
      end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
            if Alpha >= 255 then
            begin
              Blend := DXR_BLEND_ONE2_SUB_ONE1;
            end else
            begin
              Blend := DXR_BLEND_ONE2_SUB_SRCALPHA1;
            end;

          dxrCopyRectBlend(DestSurface, SrcSurface,
            DestRect, SrcRect, Blend, Alpha, Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawAlphaCol(const DestRect, SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; Color, Alpha: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if Alpha <= 0 then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderColDDS(Source, DestRect, Transparent, 0, Color, rtBlend, Alpha);
        Exit;
      end;

  // If no hardware acceleration, falls back to non-color DrawAlpha
  Self.DrawAlpha(DestRect, SrcRect, Source, Transparent, Alpha);
end;

procedure TDirectDrawSurface.DrawSubCol(const DestRect, SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; Color, Alpha: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if Alpha <= 0 then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderColDDS(Source, DestRect, Transparent, 0, Color, rtSub, Alpha);
        Exit;
      end;

  // If no hardware acceleration, falls back to non-color DrawSub
  Self.DrawSub(DestRect, SrcRect, Source, Transparent, Alpha);
end;

procedure TDirectDrawSurface.DrawAddCol(const DestRect, SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; Color, Alpha: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if Alpha <= 0 then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderColDDS(Source, DestRect, Transparent, 0, Color, rtAdd, Alpha);
        Exit;
      end;

  // If no hardware acceleration, falls back to non-color DrawAdd
  Self.DrawAdd(DestRect, SrcRect, Source, Transparent, Alpha);

end;

procedure TDirectDrawSurface.DrawRotate(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
begin
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderRotateDDS(Source, X, Y, Width, Height, rtDraw, CenterX, CenterY, Angle, $FF, Transparent);
        Exit;
      end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          dxrDrawRotateBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, CenterX, CenterY, round(Angle), DXR_BLEND_ONE1, 0,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawRotateAdd(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single; Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha <= 0 then Exit;

  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderRotateDDS(Source, X, Y, Width, Height, rtAdd, CenterX, CenterY, Angle, Alpha, Transparent);
        Exit;
      end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
            if Alpha >= 255 then
            begin
              Blend := DXR_BLEND_ONE1_ADD_ONE2;
            end else
            begin
              Blend := DXR_BLEND_SRCALPHA1_ADD_ONE2;
            end;

          dxrDrawRotateBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, CenterX, CenterY, round(Angle), Blend, Alpha,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawRotateAlpha(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single; Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha <= 0 then Exit;

  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderRotateDDS(Source, X, Y, Width, Height, rtBlend, CenterX, CenterY, Angle, Alpha, Transparent);
        Exit;
      end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
            if Alpha >= 255 then
            begin
              Blend := DXR_BLEND_ONE1;
            end else
            begin
              Blend := DXR_BLEND_SRCALPHA1_ADD_INVSRCALPHA2;
            end;

          dxrDrawRotateBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, CenterX, CenterY, round(Angle), Blend, Alpha,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawRotateSub(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: single; Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha <= 0 then Exit;

  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderRotateDDS(Source, X, Y, Width, Height, rtSub, CenterX, CenterY, Angle, Alpha, Transparent);
        Exit;
      end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
            if Alpha >= 255 then
            begin
              Blend := DXR_BLEND_ONE2_SUB_ONE1;
            end else
            begin
              Blend := DXR_BLEND_ONE2_SUB_SRCALPHA1;
            end;

          dxrDrawRotateBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, CenterX, CenterY, round(Angle), Blend, Alpha,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawRotateCol(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: Single; Color: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderRotateModeColDDS(Source, X, Y, Width, Height, rtDraw, CenterX, CenterY, Angle, Color, $FF, Transparent);
        Exit;
      end;

  // If no hardware acceleration, falls back to non-color, moded DrawRotate
  Self.DrawRotate(X, Y, Width, Height, SrcRect, Source, CenterX, CenterY, Transparent, Angle);
end;

procedure TDirectDrawSurface.DrawRotateAlphaCol(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: Single; Color, Alpha: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderRotateModeColDDS(Source, X, Y, Width, Height, rtBlend, CenterX, CenterY, Angle, Color, Alpha, Transparent);
        Exit;
      end;

  // If no hardware acceleration, falls back to non-color, moded DrawRotate
  Self.DrawRotateAlpha(X, Y, Width, Height, SrcRect, Source, CenterX, CenterY, Transparent, Angle, Alpha);
end;

procedure TDirectDrawSurface.DrawRotateAddCol(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: Single; Color, Alpha: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderRotateModeColDDS(Source, X, Y, Width, Height, rtAdd, CenterX, CenterY, Angle, Color, Alpha, Transparent);
        Exit;
      end;

  // If no hardware acceleration, falls back to non-color, moded DrawRotate
  Self.DrawRotateAdd(X, Y, Width, Height, SrcRect, Source, CenterX, CenterY, Transparent, Angle, Alpha);
end;

procedure TDirectDrawSurface.DrawRotateSubCol(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: Single; Color, Alpha: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderRotateModeColDDS(Source, X, Y, Width, Height, rtSub, CenterX, CenterY, Angle, Color, Alpha, Transparent);
        Exit;
      end;

  // If no hardware acceleration, falls back to non-color, moded DrawRotate
  Self.DrawRotateSub(X, Y, Width, Height, SrcRect, Source, CenterX, CenterY, Transparent, Angle, Alpha);
end;

//waves

procedure TDirectDrawSurface.DrawWaveX(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
begin
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderWaveXDDS(Source, X, Y, Width, Height, rtDraw, Transparent, amp, Len, ph{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
        Exit;
      end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          dxrDrawWaveXBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, amp, Len, ph, DXR_BLEND_ONE1, 0,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawWaveXAdd(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph, Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha <= 0 then Exit;

  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderWaveXDDS(Source, X, Y, Width, Height, rtAdd, Transparent, amp, Len, ph, Alpha);
        Exit;
      end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
            if Alpha >= 255 then
            begin
              Blend := DXR_BLEND_ONE1_ADD_ONE2;
            end else
            begin
              Blend := DXR_BLEND_SRCALPHA1_ADD_ONE2;
            end;

          dxrDrawWaveXBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, amp, Len, ph, Blend, Alpha,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawWaveXAlpha(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph, Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha <= 0 then Exit;

  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderWaveXDDS(Source, X, Y, Width, Height, rtBlend, Transparent, amp, Len, ph, Alpha);
        Exit;
      end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
            if Alpha >= 255 then
            begin
              Blend := DXR_BLEND_ONE1;
            end else
            begin
              Blend := DXR_BLEND_SRCALPHA1_ADD_INVSRCALPHA2;
            end;

          dxrDrawWaveXBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, amp, Len, ph, Blend, Alpha,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawWaveXSub(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph, Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha <= 0 then Exit;

  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderWaveXDDS(Source, X, Y, Width, Height, rtSub, Transparent, amp, Len, ph, Alpha);
        Exit;
      end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType = DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
            if Alpha >= 255 then
            begin
              Blend := DXR_BLEND_ONE2_SUB_ONE1;
            end else
            begin
              Blend := DXR_BLEND_ONE2_SUB_SRCALPHA1;
            end;

          dxrDrawWaveXBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, amp, Len, ph, Blend, Alpha,
            Transparent, Src_ddsd.ddckCKSrcBlt.dwColorSpaceLowValue);
        finally
          dxrDDSurfaceUnLock(Source.ISurface, SrcSurface)
        end;
      end;
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.DrawWaveYSub(X, Y, Width, Height: Integer;
  const SrcRect: TRect; Source: TDirectDrawSurface; Transparent: Boolean; amp,
  Len, ph, Alpha: Integer);
begin
  if Alpha <= 0 then Exit;

  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderWaveYDDS(Source, X, Y, Width, Height, rtSub, Transparent, amp, Len, ph, Alpha);
        Exit;
      end;
end;

procedure TDirectDrawSurface.DrawWaveY(X, Y, Width, Height: Integer;
  const SrcRect: TRect; Source: TDirectDrawSurface; Transparent: Boolean; amp,
  Len, ph: Integer);
begin
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderWaveYDDS(Source, X, Y, Width, Height, rtDraw, Transparent, amp, Len, ph{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
        Exit;
      end;
end;

procedure TDirectDrawSurface.DrawWaveYAdd(X, Y, Width, Height: Integer;
  const SrcRect: TRect; Source: TDirectDrawSurface; Transparent: Boolean; amp,
  Len, ph, Alpha: Integer);
begin
  if Alpha <= 0 then Exit;

  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderWaveYDDS(Source, X, Y, Width, Height, rtAdd, Transparent, amp, Len, ph, Alpha);
        Exit;
      end;
end;

procedure TDirectDrawSurface.DrawWaveYAlpha(X, Y, Width, Height: Integer;
  const SrcRect: TRect; Source: TDirectDrawSurface; Transparent: Boolean; amp,
  Len, ph, Alpha: Integer);
begin
  if Alpha <= 0 then Exit;

  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if (Width = 0) or (Height = 0) then Exit;
  if Source = nil then Exit;
  if (Source.Width = 0) or (Source.Height = 0) then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderWaveYDDS(Source, X, Y, Width, Height, rtBlend, Transparent, amp, Len, ph, Alpha);
        Exit;
      end;
end;

procedure TDirectDrawSurface.Fill(DevColor: Longint);
var
  DBltEx: TDDBltFX;
begin
  DBltEx.dwSize := SizeOf(DBltEx);
  DBltEx.dwFillColor := DevColor;
  Blt(TRect(nil^), TRect(nil^), DDBLT_COLORFILL or DDBLT_WAIT, DBltEx, nil);
end;

procedure TDirectDrawSurface.FillRect(const Rect: TRect; DevColor: Longint);
var
  DBltEx: TDDBltFX;
  DestRect: TRect;
begin
  DBltEx.dwSize := SizeOf(DBltEx);
  DBltEx.dwFillColor := DevColor;
  DestRect := Rect;
  if ClipRect(DestRect, ClientRect) then
    Blt(DestRect, TRect(nil^), DDBLT_COLORFILL or DDBLT_WAIT, DBltEx, nil);
end;

procedure TDirectDrawSurface.FillRectAdd(const DestRect: TRect; Color: TColor; Alpha: Byte);
var
  DestSurface: TDXR_Surface;
begin
  if Color and $FFFFFF = 0 then Exit;
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if SurfaceDesc.ddpfPixelFormat.dwFlags and (DDPF_PALETTEINDEXED1 or DDPF_PALETTEINDEXED2 or
    DDPF_PALETTEINDEXED4 or DDPF_PALETTEINDEXED8) <> 0 then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderFillRect(DestRect, ColorToRGB(Color), rtAdd, Alpha);
        Exit;
      end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      dxrFillRectColorBlend(DestSurface, DestRect, DXR_BLEND_ONE1_ADD_ONE2, ColorToRGB(Color));
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.FillRectAlpha(const DestRect: TRect; Color: TColor;
  Alpha: Integer);
var
  DestSurface: TDXR_Surface;
begin
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if SurfaceDesc.ddpfPixelFormat.dwFlags and (DDPF_PALETTEINDEXED1 or DDPF_PALETTEINDEXED2 or
    DDPF_PALETTEINDEXED4 or DDPF_PALETTEINDEXED8) <> 0 then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderFillRect(DestRect, ColorToRGB(Color), rtBlend, Alpha);
        Exit;
      end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      dxrFillRectColorBlend(DestSurface, DestRect, DXR_BLEND_SRCALPHA1_ADD_INVSRCALPHA2, ColorToRGB(Color) or (Byte(Alpha) shl 24));
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.FillRectSub(const DestRect: TRect; Color: TColor; Alpha: Byte);
var
  DestSurface: TDXR_Surface;
begin
  if Color and $FFFFFF = 0 then Exit;
  if (Self.Width = 0) or (Self.Height = 0) then Exit;
  if SurfaceDesc.ddpfPixelFormat.dwFlags and (DDPF_PALETTEINDEXED1 or DDPF_PALETTEINDEXED2 or
    DDPF_PALETTEINDEXED4 or DDPF_PALETTEINDEXED8) <> 0 then Exit;

  if AsSigned(D2D) then
    if D2D.CanUseD2D then
      if D2D.FDDraw.Surface = Self then begin
        D2D.D2DRenderFillRect(DestRect, ColorToRGB(Color), rtSub, Alpha);
        Exit;
      end;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      dxrFillRectColorBlend(DestSurface, DestRect, DXR_BLEND_ONE2_SUB_ONE1, ColorToRGB(Color));
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

function TDirectDrawSurface.GetBitCount: Integer;
begin
  Result := SurfaceDesc.ddpfPixelFormat.dwRGBBitCount;
end;

function TDirectDrawSurface.GetCanvas: TDirectDrawSurfaceCanvas;
begin
  if FCanvas = nil then
    FCanvas := TDirectDrawSurfaceCanvas.Create(Self);
  Result := FCanvas;
end;

function TDirectDrawSurface.GetClientRect: TRect;
begin
  Result := Rect(0, 0, Width, Height);
end;

function TDirectDrawSurface.GetHeight: Integer;
begin
  Result := SurfaceDesc.dwHeight;
end;

type
  PRGB = ^TRGB;
  TRGB = packed record
    R, G, B: Byte;
  end;

function TDirectDrawSurface.GetPixel(X, Y: Integer): Longint;
var
  ddsd: TDDSurfaceDesc;
begin
  Result := 0;
  if (IDDSurface <> nil) and (X >= 0) and (X < Width) and (Y >= 0) and (Y < Height) then
    if Lock(PRect(nil)^, ddsd) then
    begin
      try
        case ddsd.ddpfPixelFormat.dwRGBBitCount of
          1: Result := Integer(PByte(Integer(ddsd.lpSurface) +
              Y * ddsd.lPitch + (X shr 3))^ and (1 shl (X and 7)) <> 0);
          4: begin
              if X and 1 = 0 then
                Result := PByte(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + (X shr 1))^ shr 4
              else
                Result := PByte(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + (X shr 1))^ and $0F;
            end;
          8: Result := PByte(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X)^;
          16: Result := PWord(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X * 2)^;
          24: with PRGB(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X * 3)^ do
              Result := R or (G shl 8) or (B shl 16);
          32: Result := PInteger(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X * 4)^;
        end;
      finally
        UnLock;
      end;
    end;
end;

function TDirectDrawSurface.GetWidth: Integer;
begin
  Result := SurfaceDesc.dwWidth;
end;

procedure TDirectDrawSurface.LoadFromDIB(DIB: TDIB);
begin
  LoadFromGraphic(DIB);
end;

procedure TDirectDrawSurface.LoadFromDIBRect(DIB: TDIB; AWidth, AHeight: Integer; const SrcRect: TRect);
begin
  LoadFromGraphicRect(DIB, AWidth, AHeight, SrcRect);
end;

procedure TDirectDrawSurface.LoadFromGraphic(Graphic: TGraphic);
begin
  LoadFromGraphicRect(Graphic, 0, 0, Bounds(0, 0, Graphic.Width, Graphic.Height));
end;

procedure TDirectDrawSurface.LoadFromGraphicRect(Graphic: TGraphic; AWidth, AHeight: Integer; const SrcRect: TRect);
var
  Temp: TDIB;
begin
  if AWidth = 0 then
    AWidth := SrcRect.Right - SrcRect.Left;
  if AHeight = 0 then
    AHeight := SrcRect.Bottom - SrcRect.Top;

  SetSize(AWidth, AHeight);

  with SrcRect do
    if Graphic is TDIB then
    begin
      with Canvas do
      try
        StretchBlt(Handle, 0, 0, AWidth, AHeight, TDIB(Graphic).Canvas.Handle,
          Left, Top, Right - Left, Bottom - Top, SRCCOPY);
      finally
        Release;
      end;
    end else if (Right - Left = AWidth) and (Bottom - Top = AHeight) then
    begin
      with Canvas do
      try
        Draw(-Left, -Top, Graphic);
      finally
        Release;
      end;
    end else
    begin
      Temp := TDIB.Create;
      try
        Temp.SetSize(Right - Left, Bottom - Top, 24);
        Temp.Canvas.Draw(-Left, -Top, Graphic);

        with Canvas do
        try
          StretchDraw(Bounds(0, 0, AWidth, AHeight), Temp);
        finally
          Release;
        end;
      finally
        Temp.Free;
      end;
    end;
end;

procedure TDirectDrawSurface.LoadFromFile(const FileName: string);
var
  Picture: TPicture;
begin
  Picture := TPicture.Create;
  try
    Picture.LoadFromFile(FileName);
    LoadFromGraphic(Picture.Graphic);
  finally
    Picture.Free;
  end;
end;

procedure TDirectDrawSurface.LoadFromStream(Stream: TStream);
var
  DIB: TDIB;
begin
  DIB := TDIB.Create;
  try
    DIB.LoadFromStream(Stream);
    if DIB.Size > 0 then
      LoadFromGraphic(DIB);
  finally
    DIB.Free;
  end;
end;

function TDirectDrawSurface.Lock(const Rect: TRect; var SurfaceDesc: TDDSurfaceDesc): Boolean;
begin
  Result := False;
  if IDDSurface = nil then Exit;

  if FLockCount > 0 then Exit;
  FIsLocked := False;
  FLockSurfaceDesc.dwSize := SizeOf(FLockSurfaceDesc);

  if (@Rect <> nil) and ((Rect.Left <> 0) or (Rect.Top <> 0) or (Rect.Right <> Width) or (Rect.Bottom <> Height)) then
    DXResult := ISurface.Lock(@Rect, FLockSurfaceDesc, DDLOCK_WAIT, 0)
  else
    DXResult := ISurface.Lock(nil, FLockSurfaceDesc, DDLOCK_WAIT, 0);
  if DXResult <> DD_OK then Exit;

  Inc(FLockCount);
  SurfaceDesc := FLockSurfaceDesc;
  FIsLocked := True;
  Result := True;
end;

{$IFDEF DelphiX_Spt4}

function TDirectDrawSurface.Lock(var SurfaceDesc: TDDSurfaceDesc): Boolean;
begin
  Result := False;
  FIsLocked := False;
  if IDDSurface = nil then Exit;

  if FLockCount = 0 then
  begin
    FLockSurfaceDesc.dwSize := SizeOf(FLockSurfaceDesc);
    DXResult := ISurface.Lock(nil, FLockSurfaceDesc, DDLOCK_WAIT, 0);
    if DXResult <> DD_OK then Exit;
  end;

  Inc(FLockCount);
  SurfaceDesc := FLockSurfaceDesc;
  FIsLocked := True;
  Result := True;
end;

function TDirectDrawSurface.Lock: Boolean;
var SurfaceDesc: TDDSurfaceDesc;
begin
  Result := Lock(SurfaceDesc);
end;
{$ELSE}

function TDirectDrawSurface.LockSurface: Boolean;
var SurfaceDesc: TDDSurfaceDesc; R: TRect;
begin
  Result := Lock(R, SurfaceDesc);
end;
{$ENDIF}

procedure TDirectDrawSurface.UnLock;
begin
  if IDDSurface = nil then Exit;

  if FLockCount > 0 then
  begin
    Dec(FLockCount);
    if FLockCount = 0 then begin
      DXResult := ISurface.UnLock(FLockSurfaceDesc.lpSurface);
      FIsLocked := False;
    end;
  end;
end;

function TDirectDrawSurface.Restore: Boolean;
begin
  if IDDSurface <> nil then
  begin
    DXResult := ISurface._Restore;
    Result := DXResult = DD_OK;
  end else
    Result := False;
end;

procedure TDirectDrawSurface.SetClipper(Value: TDirectDrawClipper);
begin
  if IDDSurface <> nil then
    DXResult := ISurface.SetClipper(Value.IDDClipper);
  FHasClipper := (Value <> nil) and (DXResult = DD_OK);
end;

procedure TDirectDrawSurface.SetColorKey(Flags: DWORD; const Value: TDDColorKey);
begin
  if IDDSurface <> nil then
    DXResult := ISurface.SetColorKey(Flags, @Value);
end;

procedure TDirectDrawSurface.SetPalette(Value: TDirectDrawPalette);
begin
  if IDDSurface <> nil then
    DXResult := ISurface.SetPalette(Value.IDDPalette);
end;

procedure TDirectDrawSurface.SetPixel(X, Y: Integer; Value: Longint);
var
  ddsd: TDDSurfaceDesc;
  P: PByte;
begin
  if (IDDSurface <> nil) and (X >= 0) and (X < Width) and (Y >= 0) and (Y < Height) then
    if Lock(PRect(nil)^, ddsd) then
    begin
      try
        case ddsd.ddpfPixelFormat.dwRGBBitCount of
          1: begin
              P := PByte(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + (X shr 3));
              if Value = 0 then
                P^ := P^ and (not (1 shl (7 - (X and 7))))
              else
                P^ := P^ or (1 shl (7 - (X and 7)));
            end;
          4: begin
              P := PByte(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + (X shr 1));
              if X and 1 = 0 then
                P^ := (P^ and $0F) or (Value shl 4)
              else
                P^ := (P^ and $F0) or (Value and $0F);
            end;
          8: PByte(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X)^ := Value;
          16: PWord(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X * 2)^ := Value;
          24: with PRGB(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X * 3)^ do
            begin
              R := Byte(Value);
              G := Byte(Value shr 8);
              B := Byte(Value shr 16);
            end;
          32: PInteger(Integer(ddsd.lpSurface) + Y * ddsd.lPitch + X * 4)^ := Value;
        end;
      finally
        UnLock;
      end;
    end;
end;

procedure TDirectDrawSurface.SetSize(AWidth, AHeight: Integer);
var
  ddsd: TDDSurfaceDesc;
begin
  if (AWidth <= 0) or (AHeight <= 0) then
  begin
    IDDSurface := nil;
    Exit;
  end;

  with ddsd do
  begin
    dwSize := SizeOf(ddsd);
    dwFlags := DDSD_CAPS or DDSD_WIDTH or DDSD_HEIGHT;
    ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN;
    if FSystemMemory then
      ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_SYSTEMMEMORY;
    dwHeight := AHeight;
    dwWidth := AWidth;
  end;

  if CreateSurface(ddsd) then Exit;

  {  When the Surface cannot be made,  making is attempted to the system memory.  }
  if ddsd.ddsCaps.dwCaps and DDSCAPS_SYSTEMMEMORY = 0 then
  begin
    ddsd.ddsCaps.dwCaps := (ddsd.ddsCaps.dwCaps and (not DDSCAPS_VIDEOMEMORY)) or DDSCAPS_SYSTEMMEMORY;
    if CreateSurface(ddsd) then
    begin
      FSystemMemory := True;
      Exit;
    end;
  end;

  raise EDirectDrawSurfaceError.CreateFmt(SCannotMade, [SDirectDrawSurface]);
end;

procedure TDirectDrawSurface.SetTransparentColor(Col: Longint);
var
  ddck: TDDColorKey;
begin
  ddck.dwColorSpaceLowValue := Col;
  ddck.dwColorSpaceHighValue := Col;
  ColorKey[DDCKEY_SRCBLT] := ddck;
end;

{additional pixel routines like turbopixels}

procedure TDirectDrawSurface.PutPixel8(x, y, color: integer); assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   color = ? }
asm
  push esi                              // must maintain esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface// set to surface
  add esi,edx                           // add x
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.dwwidth]  // eax = pitch
  mul ecx                               // eax = pitch * y
  add esi,eax                           // esi = pixel offset
  mov ecx, color
  mov ds:[esi],cl                       // set pixel (lo byte of ecx)
  pop esi                               // restore esi
  //ret                                   // return
end;

procedure TDirectDrawSurface.PutPixel16(x, y, color: integer); assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   color = ? }
asm
  push esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface
  shl edx,1
  add esi,edx
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.lpitch]
  mul ecx
  add esi,eax
  mov ecx, color
  mov ds:[esi],cx
  pop esi
  //ret
end;

procedure TDirectDrawSurface.PutPixel24(x, y, color: integer); assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   color = ? }
asm
  push esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface
  imul edx,3
  add esi,edx
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.lpitch]
  mul ecx
  add esi,eax
  mov eax,ds:[esi]
  and eax,$FF000000
  mov ecx, color
  or  ecx,eax
  mov ds:[esi+1],ecx
  pop esi
  //ret
end;

procedure TDirectDrawSurface.PutPixel32(x, y, color: integer); assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   color = ? }
asm
  push esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface
  shl edx,2
  add esi,edx
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.lpitch]
  mul ecx
  add esi,eax
  mov ecx, color
  mov ds:[esi],ecx
  pop esi
  //ret
end;

procedure TDirectDrawSurface.Poke(X, Y: Integer; const Value: LongInt); {$IFDEF VER9UP}inline; {$ENDIF}
begin
  if (X < 0) or (X > (Width - 1)) or
    (Y < 0) or (Y > (Height - 1)) or not FIsLocked then Exit;
  case Bitcount of
    8: PutPixel8(x, y, value);
    16: PutPixel16(x, y, value);
    24: PutPixel24(x, y, value);
    32: PutPixel32(x, y, value);
  end;
end;

function TDirectDrawSurface.GetPixel8(x, y: integer): integer; assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   result = eax }
asm
  push esi                              // myst maintain esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface        // set to surface
  add esi,edx                           // add x
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.lpitch]         // eax = pitch
  mul ecx                               // eax = pitch * y
  add esi,eax                           // esi = pixel offset
  mov eax,ds:[esi]                      // eax = color
  and eax,$FF                           // map into 8bit
  pop esi                               // restore esi
  //ret                                   // return
end;

function TDirectDrawSurface.GetPixel16(x, y: integer): integer; assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   result = eax }
asm
  push esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface
  shl edx,1
  add esi,edx
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.lpitch]
  mul ecx
  add esi,eax
  mov eax,ds:[esi]
  and eax,$FFFF                         // map into 16bit
  pop esi
  //ret
end;

function TDirectDrawSurface.GetPixel24(x, y: integer): integer; assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   result = eax }
asm
  push esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface
  imul edx,3
  add esi,edx
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.lpitch]
  mul ecx
  add esi,eax
  mov eax,ds:[esi]
  and eax,$FFFFFF                       // map into 24bit
  pop esi
  //ret
end;

function TDirectDrawSurface.GetPixel32(x, y: integer): integer; assembler;
{ on entry:  self = eax, x = edx,   y = ecx,   result = eax }
asm
  push esi
  mov esi,TDirectDrawSurface[eax].FLockSurfaceDesc.lpSurface
  shl edx,2
  add esi,edx
  mov eax,[TDirectDrawSurface[eax].FLockSurfaceDesc.lpitch]
  mul ecx
  add esi,eax
  mov eax,ds:[esi]
  pop esi
  //ret
end;

function TDirectDrawSurface.Peek(X, Y: Integer): LongInt; {$IFDEF VER9UP}inline; {$ENDIF}
begin
  Result := 0;
  if (X < 0) or (X > (Width - 1)) or
    (Y < 0) or (Y > (Height - 1)) or not FIsLocked then Exit;
  case Bitcount of
    8: Result := GetPixel8(x, y);
    16: Result := GetPixel16(x, y);
    24: Result := GetPixel24(x, y);
    32: Result := GetPixel32(x, y);
  end;
end;

procedure TDirectDrawSurface.PokeLine(X1, Y1, X2, Y2: Integer; Color: cardinal);
var
  i, deltax, deltay, numpixels,
    d, dinc1, dinc2,
    x, xinc1, xinc2,
    y, yinc1, yinc2: Integer;
begin
  if not FIsLocked then {$IFDEF DelphiX_Spt4}Lock{$ELSE}LockSurface{$ENDIF}; //force lock the surface
  { Calculate deltax and deltay for initialisation }
  deltax := abs(x2 - x1);
  deltay := abs(y2 - y1);

  { Initialise all vars based on which is the independent variable }
  if deltax >= deltay then
  begin
    { x is independent variable }
    numpixels := deltax + 1;
    d := (2 * deltay) - deltax;

    dinc1 := deltay shl 1;
    dinc2 := (deltay - deltax) shl 1;
    xinc1 := 1;
    xinc2 := 1;
    yinc1 := 0;
    yinc2 := 1;
  end
  else
  begin
    { y is independent variable }
    numpixels := deltay + 1;
    d := (2 * deltax) - deltay;
    dinc1 := deltax shl 1;
    dinc2 := (deltax - deltay) shl 1;
    xinc1 := 0;
    xinc2 := 1;
    yinc1 := 1;
    yinc2 := 1;
  end;
  { Make sure x and y move in the right directions }
  if x1 > x2 then
  begin
    xinc1 := -xinc1;
    xinc2 := -xinc2;
  end;
  if y1 > y2 then
  begin
    yinc1 := -yinc1;
    yinc2 := -yinc2;
  end;
  x := x1;
  y := y1;
  { Draw the pixels }
  for i := 1 to numpixels do
  begin
    if (x > 0) and (x < (Width - 1)) and (y > 0) and (y < (Height - 1)) then
      Pixel[x, y] := Color;
    if d < 0 then
    begin
      Inc(d, dinc1);
      Inc(x, xinc1);
      Inc(y, yinc1);
    end
    else
    begin
      Inc(d, dinc2);
      Inc(x, xinc2);
      Inc(y, yinc2);
    end;
  end;
end;

procedure TDirectDrawSurface.PokeLinePolar(x, y: integer; angle, length: extended; Color: cardinal);
var
  xp, yp: integer;
begin
  xp := round(sin(angle * pi / 180) * length) + x;
  yp := round(cos(angle * pi / 180) * length) + y;
  PokeLine(x, y, xp, yp, Color);
end;

procedure TDirectDrawSurface.PokeBox(xs, ys, xd, yd: Integer; Color: cardinal);
begin
  pokeline(xs, ys, xd, ys, color);
  pokeline(xs, ys, xs, yd, color);
  pokeline(xd, ys, xd, yd, color);
  pokeline(xs, yd, xd, yd, color);
end;

procedure TDirectDrawSurface.PokeBlendPixel(const X, Y: Integer; aColor: cardinal; Alpha: byte);
var
  cr, cg, cb: byte;
  ar, ag, ab: byte;
begin
  LoadRGB(aColor, ar, ag, ab);
  LoadRGB(Pixel[x, y], cr, cg, cb);
  Pixel[x, y] := SaveRGB((Alpha * (aR - cr) shr 8) + cr, // R alpha
    (Alpha * (aG - cg) shr 8) + cg, // G alpha
    (Alpha * (aB - cb) shr 8) + cb); // B alpha
end;

function Conv24to16(Color: Integer): Word; register;
asm
  mov ecx,eax
  shl eax,24
  shr eax,27
  shl eax,11
  mov edx,ecx
  shl edx,16
  shr edx,26
  shl edx,5
  or eax,edx
  mov edx,ecx
  shl edx,8
  shr edx,27
  or eax,edx
end;

procedure TDirectDrawSurface.PokeWuLine(X1, Y1, X2, Y2, aColor: Integer);
var DeltaX, DeltaY, Loop, Start, Finish: Integer;
  Dx, Dy, DyDx: Single; // fractional parts
  Color16: DWord;
begin
  DeltaX := Abs(X2 - X1); // Calculate DeltaX and DeltaY for initialization
  DeltaY := Abs(Y2 - Y1);
  if (DeltaX = 0) or (DeltaY = 0) then
  begin // straight lines
    PokeLine(X1, Y1, X2, Y2, aColor);
    Exit;
  end;
  if BitCount = 16 then
    Color16 := Conv24to16(aColor)
  else
    Color16 := aColor;
  if DeltaX > DeltaY then // horizontal or vertical
  begin
  { determine rise and run }
    if Y2 > Y1 then DyDx := -(DeltaY / DeltaX)
    else DyDx := DeltaY / DeltaX;
    if X2 < X1 then
    begin
      Start := X2; // right to left
      Finish := X1;
      Dy := Y2;
    end else
    begin
      Start := X1; // left to right
      Finish := X2;
      Dy := Y1;
      DyDx := -DyDx; // inverse slope
    end;
    for Loop := Start to Finish do
    begin
      PokeBlendPixel(Loop, Trunc(Dy), Color16, Trunc((1 - Frac(Dy)) * 255));
      PokeBlendPixel(Loop, Trunc(Dy) + 1, Color16, Trunc(Frac(Dy) * 255));
      Dy := Dy + DyDx; // next point
    end;
  end else
  begin
   { determine rise and run }
    if X2 > X1 then DyDx := -(DeltaX / DeltaY)
    else DyDx := DeltaX / DeltaY;
    if Y2 < Y1 then
    begin
      Start := Y2; // right to left
      Finish := Y1;
      Dx := X2;
    end else
    begin
      Start := Y1; // left to right
      Finish := Y2;
      Dx := X1;
      DyDx := -DyDx; // inverse slope
    end;
    for Loop := Start to Finish do
    begin
      PokeBlendPixel(Trunc(Dx), Loop, Color16, Trunc((1 - Frac(Dx)) * 255));
      PokeBlendPixel(Trunc(Dx), Loop, Color16, Trunc(Frac(Dx) * 255));
      Dx := Dx + DyDx; // next point
    end;
  end;
end;

procedure TDirectDrawSurface.Noise(Oblast: TRect; Density: Byte);
var
  dx, dy: integer;
  Dens: byte;
begin
  {noise}
  case Density of
    0..2: Dens := 3;
    255: Dens := 254;
  else
    Dens := Density;
  end;
  if Dens >= Oblast.Right then
    Dens := Oblast.Right div 3;
  dy := Oblast.Top;
  while dy <= Oblast.Bottom do begin
    dx := Oblast.Left;
    while dx <= Oblast.Right do begin
      inc(dx, random(dens));
      if dx <= Oblast.Right then
        Pixel[dx, dy] := not Pixel[dx, dy];
    end;
    inc(dy);
  end;
end;

function Conv16to24(Color: Word): Integer; register;
asm
 xor edx,edx
 mov dx,ax

 mov eax,edx
 shl eax,27
 shr eax,8

 mov ecx,edx
 shr ecx,5
 shl ecx,26
 shr ecx,16
 or eax,ecx

 mov ecx,edx
 shr ecx,11
 shl ecx,27
 shr ecx,24
 or eax,ecx
end;

procedure GetRGB(Color: cardinal; var R, G, B: Byte); {$IFDEF VER9UP}inline; {$ENDIF}
begin
  R := Color;
  G := Color shr 8;
  B := Color shr 16;
end;

procedure TDirectDrawSurface.LoadRGB(Color: cardinal; var R, G, B: Byte); {$IFDEF VER9UP}inline; {$ENDIF}
var grB: Byte;
begin
  grB := 1;
  if FLockSurfaceDesc.ddpfPixelFormat.dwGBitMask = 2016 then grB := 0; // 565
  case BitCount of
    15, 16: begin
        R := (color shr (11 - grB)) shl 3;
        if grB = 0 then
          G := ((color and 2016) shr 5) shl 2
        else
          G := ((color and 992) shr 5) shl 3;
        B := (color and 31) shl 3;
      end;
  else
    GetRGB(Color, R, G, B);
  end;
end;

function TDirectDrawSurface.SaveRGB(const R, G, B: Byte): cardinal; {$IFDEF VER9UP}inline; {$ENDIF}
begin
  case BitCount of
    15, 16: begin
        Result := Conv24to16(RGB(R, G, B));
      end;
  else
    Result := RGB(R, G, B);
  end;
end;

procedure TDirectDrawSurface.Blur;
var
  x, y, tr, tg, tb: integer;
  r, g, b: byte;
begin
  for y := 1 to GetHeight - 1 do
    for x := 1 to GetWidth - 1 do begin
      LoadRGB(peek(x, y), r, g, b);
      tr := r;
      tg := g;
      tb := b;
      LoadRGB(peek(x, y + 1), r, g, b);
      Inc(tr, r);
      Inc(tg, g);
      Inc(tb, b);
      LoadRGB(peek(x, y - 1), r, g, b);
      Inc(tr, r);
      Inc(tg, g);
      Inc(tb, b);
      LoadRGB(peek(x - 1, y), r, g, b);
      Inc(tr, r);
      Inc(tg, g);
      Inc(tb, b);
      LoadRGB(peek(x + 1, y), r, g, b);
      Inc(tr, r);
      Inc(tg, g);
      Inc(tb, b);
      tr := tr shr 2;
      tg := tg shr 2;
      tb := tb shr 2;
      Poke(x, y, savergb(tr, tg, tb));
    end;
end;

procedure TDirectDrawSurface.PokeCircle(X, Y, Radius, Color: integer);
var
  a, af, b, bf, c,
    target, r2: Integer;
begin
  Target := 0;
  A := Radius;
  B := 0;
  R2 := Sqr(Radius);

  while a >= B do
  begin
    b := Round(Sqrt(R2 - Sqr(A)));
    c := target; target := b; b := c;
    while B < Target do
    begin
      Af := (120 * a) div 100;
      Bf := (120 * b) div 100;
      pixel[x + af, y + b] := color;
      pixel[x + bf, y + a] := color;
      pixel[x - af, y + b] := color;
      pixel[x - bf, y + a] := color;
      pixel[x - af, y - b] := color;
      pixel[x - bf, y - a] := color;
      pixel[x + af, y - b] := color;
      pixel[x + bf, y - a] := color;
      B := B + 1;
    end;
    A := A - 1;
  end;
end;

function RGBToBGR(Color: cardinal): cardinal;
begin
  result := (LoByte(LoWord(Color)) shr 3 shl 11) or // Red
    (HiByte((Color)) shr 2 shl 5) or // Green
    (LoByte(HiWord(Color)) shr 3); // Blue
end;

procedure TDirectDrawSurface.PokeVLine(x, y1, y2: integer; Color: cardinal);
var
  y: integer;
  NColor: cardinal;
  r, g, b: byte;
begin
  if y1 < 0 then y1 := 0;
  if y2 >= Height then y2 := Height - 1;
  GetRGB(Color, r, g, b);
  NColor := RGBToBGR(rgb(r, g, b));
  for y := y1 to y2 do
  begin
    pixel[x, y] := NColor;
  end;
end;

procedure TDirectDrawSurface.PokeFilledEllipse(exc, eyc, ea, eb, color: integer);
var x, y: integer; aa, aa2, bb, bb2, d, dx, dy: longint;
begin
  x := 0;
  y := eb;
  aa := longint(ea) * ea;
  aa2 := 2 * aa;
  bb := longint(eb) * eb;
  bb2 := 2 * bb;
  d := bb - aa * eb + aa div 4;
  dx := 0;
  dy := aa2 * eb;
  PokevLine(exc, eyc - y, eyc + y, color);
  while (dx < dy) do begin
    if (d > 0) then begin
      dec(y); dec(dy, aa2); dec(d, dy);
    end;
    inc(x); inc(dx, bb2); inc(d, bb + dx);
    PokevLine(exc - x, eyc - y, eyc + y, color);
    PokevLine(exc + x, eyc - y, eyc + y, color);
  end;
  inc(d, (3 * (aa - bb) div 2 - (dx + dy)) div 2);
  while (y >= 0) do begin
    if (d < 0) then begin
      inc(x); inc(dx, bb2); inc(d, bb + dx);
      PokevLine(exc - x, eyc - y, eyc + y, color);
      PokevLine(exc + x, eyc - y, eyc + y, color);
    end;
    dec(y); dec(dy, aa2); inc(d, aa - dy);
  end;
end;

procedure TDirectDrawSurface.DoRotate(cent1, cent2, angle: Integer; coord1, coord2: Real; Color: word);
var coord1t, coord2t: Real;
  c1, c2: integer;
begin
  coord1t := coord1 - cent1;
  coord2t := coord2 - cent2;
  coord1 := coord1t * cos(angle * pi / 180) - coord2t * sin(angle * pi / 180);
  coord2 := coord1t * sin(angle * pi / 180) + coord2t * cos(angle * pi / 180);
  coord1 := coord1 + cent1;
  coord2 := coord2 + cent2;
  c1 := round(coord1);
  c2 := round(coord2);
  pixel[c1, c2] := Color;
end;

procedure TDirectDrawSurface.PokeEllipse(exc, eyc, ea, eb, angle, Color: Integer);
var
  elx, ely: Integer;
  aa, aa2, bb, bb2, d, dx, dy: LongInt;
  x, y: real;
begin
  elx := 0;
  ely := eb;
  aa := LongInt(ea) * ea;
  aa2 := 2 * aa;
  bb := LongInt(eb) * eb;
  bb2 := 2 * bb;
  d := bb - aa * eb + aa div 4;
  dx := 0;
  dy := aa2 * eb;
  x := exc;
  y := eyc - ely;
  dorotate(exc, eyc, angle, x, y, Color);
  x := exc;
  y := eyc + ely;
  dorotate(exc, eyc, angle, x, y, Color);
  x := exc - ea;
  y := eyc;
  dorotate(exc, eyc, angle, x, y, Color);
  x := exc + ea;
  y := eyc;
  dorotate(exc, eyc, angle, x, y, Color);
  while (dx < dy) do begin
    if (d > 0) then begin Dec(ely); Dec(dy, aa2); Dec(d, dy); end;
    Inc(elx); Inc(dx, bb2); Inc(d, bb + dx);
    x := exc + elx; y := eyc + ely;
    dorotate(exc, eyc, angle, x, y, Color);
    x := exc - elx; y := eyc + ely;
    dorotate(exc, eyc, angle, x, y, Color);
    x := exc + elx; y := eyc - ely;
    dorotate(exc, eyc, angle, x, y, Color);
    x := exc - elx; y := eyc - ely;
    dorotate(exc, eyc, angle, x, y, Color);
  end;
  Inc(d, (3 * (aa - bb) div 2 - (dx + dy)) div 2);
  while (ely > 0) do begin
    if (d < 0) then begin Inc(elx); Inc(dx, bb2); Inc(d, bb + dx); end;
    Dec(ely); Dec(dy, aa2); Inc(d, aa - dy);
    x := exc + elx; y := eyc + ely;
    dorotate(exc, eyc, angle, x, y, Color);
    x := exc - elx; y := eyc + ely;
    dorotate(exc, eyc, angle, x, y, Color);
    x := exc + elx; y := eyc - ely;
    dorotate(exc, eyc, angle, x, y, Color);
    x := exc - elx; y := eyc - ely;
    dorotate(exc, eyc, angle, x, y, Color);
  end;
end;

{  TDXDrawDisplayMode  }

function TDXDrawDisplayMode.GetBitCount: Integer;
begin
  Result := FSurfaceDesc.ddpfPixelFormat.dwRGBBitCount;
end;

function TDXDrawDisplayMode.GetHeight: Integer;
begin
  Result := FSurfaceDesc.dwHeight;
end;

function TDXDrawDisplayMode.GetWidth: Integer;
begin
  Result := FSurfaceDesc.dwWidth;
end;

{  TDXDrawDisplay  }

constructor TDXDrawDisplay.Create(ADXDraw: TCustomDXDraw);
begin
  inherited Create;
  FDXDraw := ADXDraw;
  FModes := TCollection.Create(TDXDrawDisplayMode);
  FWidth := 640;
  FHeight := 480;
  FBitCount := 16;
  FFixedBitCount := False; //True;
  FFixedRatio := True;
  FFixedSize := True; //False;
end;

destructor TDXDrawDisplay.Destroy;
begin
  FModes.Free;
  inherited Destroy;
end;

procedure TDXDrawDisplay.Assign(Source: TPersistent);
begin
  if Source is TDXDrawDisplay then
  begin
    if Source <> Self then
    begin
      FBitCount := TDXDrawDisplay(Source).BitCount;
      FHeight := TDXDrawDisplay(Source).Height;
      FWidth := TDXDrawDisplay(Source).Width;

      FFixedBitCount := TDXDrawDisplay(Source).FFixedBitCount;
      FFixedRatio := TDXDrawDisplay(Source).FFixedRatio;
      FFixedSize := TDXDrawDisplay(Source).FFixedSize;
    end;
  end else
    inherited Assign(Source);
end;

function TDXDrawDisplay.GetCount: Integer;
begin
  if FModes.Count = 0 then
    LoadDisplayModes;
  Result := FModes.Count;
end;

function TDXDrawDisplay.GetMode: TDXDrawDisplayMode;
var
  i: Integer;
  ddsd: TDDSurfaceDesc;
begin
  Result := nil;
  if FDXDraw.DDraw <> nil then
  begin
    ddsd := FDXDraw.DDraw.DisplayMode;
    with ddsd do
      i := IndexOf(dwWidth, dwHeight, ddpfPixelFormat.dwRGBBitCount);
    if i <> -1 then
      Result := Modes[i];
  end;
  if Result = nil then
    raise EDirectDrawError.Create(SDisplayModeCannotAcquired);
end;

function TDXDrawDisplay.GetMode2(Index: Integer): TDXDrawDisplayMode;
begin
  if FModes.Count = 0 then
    LoadDisplayModes;
  Result := TDXDrawDisplayMode(FModes.Items[Index]);
end;

function TDXDrawDisplay.IndexOf(Width, Height, BitCount: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if (Modes[i].Width = Width) and (Modes[i].Height = Height) and (Modes[i].BitCount = BitCount) then
    begin
      Result := i;
      Exit;
    end;
end;

procedure TDXDrawDisplay.LoadDisplayModes;

  function EnumDisplayModesProc(const lpTDDSurfaceDesc: TDDSurfaceDesc;
    lpContext: Pointer): HRESULT; stdcall;
  begin
    with TDXDrawDisplayMode.Create(TCollection(lpContext)) do
      FSurfaceDesc := lpTDDSurfaceDesc;
    Result := DDENUMRET_OK;
  end;

  function Compare(Item1, Item2: TDXDrawDisplayMode): Integer;
  begin
    if Item1.Width <> Item2.Width then
      Result := Item1.Width - Item2.Width
    else if Item1.Height <> Item2.Height then
      Result := Item1.Height - Item2.Height
    else
      Result := Item1.BitCount - Item2.BitCount;
  end;

var
  DDraw: TDirectDraw;
  TempList: TList;
  i: Integer;
begin
  FModes.Clear;

  if FDXDraw.DDraw <> nil then
  begin
    FDXDraw.DDraw.DXResult := FDXDraw.DDraw.IDraw.EnumDisplayModes(0, PDDSurfaceDesc(nil),
      FModes, @EnumDisplayModesProc);
  end else
  begin
    DDraw := TDirectDraw.Create(PGUID(FDXDraw.FDriver));
    try
      DDraw.IDraw.EnumDisplayModes(0, PDDSurfaceDesc(nil), FModes, @EnumDisplayModesProc);
    finally
      DDraw.Free;
    end;
  end;

  TempList := TList.Create;
  try
    for i := 0 to FModes.Count - 1 do
      TempList.Add(FModes.Items[i]);
    TempList.Sort(@Compare);

    for i := FModes.Count - 1 downto 0 do
      TDXDrawDisplayMode(TempList[i]).Index := i;
  finally
    TempList.Free;
  end;
end;

function TDXDrawDisplay.SetSize(AWidth, AHeight, ABitCount: Integer): Boolean;
begin
  Result := False;
  if FDXDraw.DDraw <> nil then
  begin
    FDXDraw.DDraw.DXResult := FDXDraw.DDraw.IDraw.SetDisplayMode(AWidth, AHeight, ABitCount);
    Result := FDXDraw.DDraw.DXResult = DD_OK;

    if Result then
    begin
      FWidth := AWidth;
      FHeight := AHeight;
      FBitCount := ABitCount;
    end;
  end;
end;

function TDXDrawDisplay.DynSetSize(AWidth, AHeight, ABitCount: Integer): Boolean;

  function TestBitCount(BitCount, ABitCount: Integer): Boolean;
  begin
    if (BitCount > 8) and (ABitCount > 8) then
    begin
      Result := True;
    end else
    begin
      Result := BitCount >= ABitCount;
    end;
  end;

  function SetSize2(Ratio: Boolean): Boolean;
  var
    DWidth, DHeight, DBitCount, i: Integer;
    Flag: Boolean;
  begin
    Result := False;

    DWidth := Maxint;
    DHeight := Maxint;
    DBitCount := ABitCount;

    Flag := False;
    for i := 0 to Count - 1 do
      with Modes[i] do
      begin
        if ((DWidth >= Width) and (DHeight >= Width) and
          ((not Ratio) or (Width / Height = AWidth / AHeight)) and
          ((FFixedSize and (Width = AWidth) and (Height = Height)) or
          ((not FFixedSize) and (Width >= AWidth) and (Height >= AHeight))) and

          ((FFixedBitCount and (BitCount = ABitCount)) or
          ((not FFixedBitCount) and TestBitCount(BitCount, ABitCount)))) then
        begin
          DWidth := Width;
          DHeight := Height;
          DBitCount := BitCount;
          Flag := True;
        end;
      end;

    if Flag then
    begin
      if (DBitCount <> ABitCount) then
      begin
        if IndexOf(DWidth, DHEight, ABitCount) <> -1 then
          DBitCount := ABitCount;
      end;

      Result := SetSize(DWidth, DHeight, DBitCount);
    end;
  end;

begin
  Result := False;

  if (AWidth <= 0) or (AHeight <= 0) or (not (ABitCount in [8, 16, 24, 32])) then Exit;

  {  The change is attempted by the size of default.  }
  if SetSize(AWidth, AHeight, ABitCount) then
  begin
    Result := True;
    Exit;
  end;

  {  The change is attempted by the screen ratio fixation.  }
  if FFixedRatio then
    if SetSize2(True) then
    begin
      Result := True;
      Exit;
    end;

  {  The change is unconditionally attempted.  }
  if SetSize2(False) then
  begin
    Result := True;
    Exit;
  end;
end;

procedure TDXDrawDisplay.SetBitCount(Value: Integer);
begin
  if not (Value in [8, 16, 24, 32]) then
    raise EDirectDrawError.Create(SInvalidDisplayBitCount);
  FBitCount := Value;
end;

procedure TDXDrawDisplay.SetHeight(Value: Integer);
begin
  FHeight := Max(Value, 0);
end;

procedure TDXDrawDisplay.SetWidth(Value: Integer);
begin
  FWidth := Max(Value, 0);
end;

{  TCustomDXDraw  }

function BPPToDDBD(BPP: DWORD): DWORD;
begin
  case BPP of
    1: Result := DDBD_1;
    2: Result := DDBD_2;
    4: Result := DDBD_4;
    8: Result := DDBD_8;
    16: Result := DDBD_16;
    24: Result := DDBD_24;
    32: Result := DDBD_32;
  else
    Result := 0;
  end;
end;

procedure FreeZBufferSurface(Surface: TDirectDrawSurface; var ZBuffer: TDirectDrawSurface);
begin
  if ZBuffer <> nil then
  begin
    if (Surface.IDDSurface <> nil) and (ZBuffer.IDDSurface <> nil) then
      Surface.ISurface.DeleteAttachedSurface(0, ZBuffer.IDDSurface);
    ZBuffer.Free; ZBuffer := nil;
  end;
end;

type
  TInitializeDirect3DOption = (idoSelectDriver, idoOptimizeDisplayMode,
    idoHardware, idoRetainedMode, idoZBuffer);

  TInitializeDirect3DOptions = set of TInitializeDirect3DOption;

procedure Direct3DInitializing(Options: TInitializeDirect3DOptions;
  var BitCount: Integer; var Driver: PGUID; var DriverGUID: TGUID);
type
  PDirect3DInitializingRecord = ^TDirect3DInitializingRecord;
  TDirect3DInitializingRecord = record
    Options: TInitializeDirect3DOptions;
    Driver: ^PGUID;
    DriverGUID: PGUID;
    BitCount: Integer;

    Flag: Boolean;
    DriverCaps: TDDCaps;
    HELCaps: TDDCaps;
    HWDeviceDesc: TD3DDeviceDesc;
    HELDeviceDesc: TD3DDeviceDesc;
    DeviceDesc: TD3DDeviceDesc;

    D3DFlag: Boolean;
    HWDeviceDesc2: TD3DDeviceDesc;
    HELDeviceDesc2: TD3DDeviceDesc;
    DeviceDesc2: TD3DDeviceDesc;
  end;

  function EnumDeviceCallBack(const lpGuid: TGUID; lpDeviceDescription, lpDeviceName: PChar;
    const lpD3DHWDeviceDesc, lpD3DHELDeviceDesc: TD3DDeviceDesc;
    rec: PDirect3DInitializingRecord): HRESULT; stdcall;

    procedure UseThisDevice;
    begin
      rec.D3DFlag := True;
      rec.HWDeviceDesc2 := lpD3DHWDeviceDesc;
      rec.HELDeviceDesc2 := lpD3DHELDeviceDesc;
      rec.DeviceDesc2 := lpD3DHWDeviceDesc;
    end;

  begin
    Result := D3DENUMRET_OK;

    if lpD3DHWDeviceDesc.dcmColorModel = 0 then Exit;

    if idoOptimizeDisplayMode in rec.Options then
    begin
      if (lpD3DHWDeviceDesc.dwDeviceRenderBitDepth and (DDBD_16 or DDBD_24 or DDBD_32)) = 0 then Exit;
    end else
    begin
      if (lpD3DHWDeviceDesc.dwDeviceRenderBitDepth and BPPToDDBD(rec.BitCount)) = 0 then Exit;
    end;

    UseThisDevice;
  end;

  function EnumDirectDrawDriverCallback(lpGUID: PGUID; lpDriverDescription: LPSTR;
    lpDriverName: LPSTR; rec: PDirect3DInitializingRecord): HRESULT; stdcall;
  var
    DDraw: TDirectDraw;
    Direct3D: IDirect3D;
    Direct3D7: IDirect3D7;

    function CountBitMask(i: DWORD; const Bits: array of DWORD): DWORD;
    var
      j: Integer;
    begin
      Result := 0;

      for j := Low(Bits) to High(Bits) do
      begin
        if i and Bits[j] <> 0 then
          Inc(Result);
      end;
    end;

    function CompareCountBitMask(i, i2: DWORD; const Bits: array of DWORD): Integer;
    var
      j, j2: DWORD;
    begin
      j := CountBitMask(i, Bits);
      j2 := CountBitMask(i2, Bits);

      if j < j2 then
        Result := -1
      else if i > j2 then
        Result := 1
      else
        Result := 0;
    end;

    function CountBit(i: DWORD): DWORD;
    var
      j: Integer;
    begin
      Result := 0;

      for j := 0 to 31 do
        if i and (1 shl j) <> 0 then
          Inc(Result);
    end;

    function CompareCountBit(i, i2: DWORD): Integer;
    begin
      Result := CountBit(i) - CountBit(i2);
      if Result < 0 then Result := -1;
      if Result > 0 then Result := 1;
    end;

    function FindDevice: Boolean;
    begin
      {  The Direct3D driver is examined.  }
      rec.D3DFlag := False;
      Direct3D.EnumDevices(@EnumDeviceCallBack, rec);
      Result := rec.D3DFlag;

      if not Result then Exit;

      {  Comparison of DirectDraw driver.  }
      if not rec.Flag then
      begin
        rec.HWDeviceDesc := rec.HWDeviceDesc2;
        rec.HELDeviceDesc := rec.HELDeviceDesc2;
        rec.DeviceDesc := rec.DeviceDesc2;
        rec.Flag := True;
      end else
      begin
        {  Comparison of hardware. (One with large number of functions to support is chosen.  }
        Result := False;

        if DDraw.DriverCaps.dwVidMemTotal < rec.DriverCaps.dwVidMemTotal then Exit;

        if CompareCountBitMask(DDraw.DriverCaps.ddscaps.dwCaps, rec.DriverCaps.ddscaps.dwCaps, [DDSCAPS_TEXTURE, DDSCAPS_ZBUFFER, DDSCAPS_MIPMAP]) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwMiscCaps, rec.HWDeviceDesc2.dpcLineCaps.dwMiscCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwRasterCaps, rec.HWDeviceDesc2.dpcLineCaps.dwRasterCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwAlphaCmpCaps, rec.HWDeviceDesc2.dpcLineCaps.dwAlphaCmpCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwSrcBlendCaps, rec.HWDeviceDesc2.dpcLineCaps.dwSrcBlendCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwDestBlendCaps, rec.HWDeviceDesc2.dpcLineCaps.dwDestBlendCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwShadeCaps, rec.HWDeviceDesc2.dpcLineCaps.dwShadeCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwTextureCaps, rec.HWDeviceDesc2.dpcLineCaps.dwTextureCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwTextureFilterCaps, rec.HWDeviceDesc2.dpcLineCaps.dwTextureFilterCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwTextureBlendCaps, rec.HWDeviceDesc2.dpcLineCaps.dwTextureBlendCaps) +
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwTextureAddressCaps, rec.HWDeviceDesc2.dpcLineCaps.dwTextureAddressCaps) < 0 then Exit;

        Result := True;
      end;
    end;

  begin
    Result := DDENUMRET_OK;

    DDraw := TDirectDraw.Create(lpGUID);
    try
      if (DDraw.DriverCaps.dwCaps and DDCAPS_3D <> 0) and
        (DDraw.DriverCaps.ddsCaps.dwCaps and DDSCAPS_TEXTURE <> 0) then
      begin
        if DDraw.IDDraw7 <> nil then
          Direct3D7 := DDraw.IDraw7 as IDirect3D7
        else
          Direct3D := DDraw.IDraw as IDirect3D;
        try
          if FindDevice then
          begin
            rec.DriverCaps := DDraw.DriverCaps;
            rec.HELCaps := DDraw.HELCaps;

            if lpGUID = nil then
              rec.Driver := nil
            else begin
              rec.DriverGUID^ := lpGUID^;
              rec.Driver^ := @rec.DriverGUID;
            end;
          end;
        finally
          Direct3D := nil;
          Direct3D7 := nil;
        end;
      end;
    finally
      DDraw.Free;
    end;
  end;

var
  rec: TDirect3DInitializingRecord;
  DDraw: TDirectDraw;
begin
  FillChar(rec, SizeOf(rec), 0);
  rec.BitCount := BitCount;
  rec.Options := Options;

  {  Driver selection   }
  if idoSelectDriver in Options then
  begin
    rec.Flag := False;
    rec.Options := Options;
    rec.Driver := @Driver;
    rec.DriverGUID := @DriverGUID;
    DXDirectDrawEnumerate(@EnumDirectDrawDriverCallback, @rec)
  end else
  begin
    DDraw := TDirectDraw.Create(Driver);
    try
      rec.DriverCaps := DDraw.DriverCaps;
      rec.HELCaps := DDraw.HELCaps;

      rec.D3DFlag := False;
      (DDraw.IDraw as IDirect3D).EnumDevices(@EnumDeviceCallBack, @rec);
      if rec.D3DFlag then
        rec.DeviceDesc := rec.DeviceDesc2;
    finally
      DDraw.Free;
    end;
    rec.Flag := True;
  end;

  {  Display mode optimization  }
  if rec.Flag and (idoOptimizeDisplayMode in Options) then
  begin
    if (rec.DeviceDesc.dwDeviceRenderBitDepth and BPPToDDBD(rec.BitCount)) = 0 then
    begin
      if rec.DeviceDesc.dwDeviceRenderBitDepth and DDBD_16 <> 0 then
        rec.BitCount := 16
      else if rec.DeviceDesc.dwDeviceRenderBitDepth and DDBD_24 <> 0 then
        rec.BitCount := 24
      else if rec.DeviceDesc.dwDeviceRenderBitDepth and DDBD_32 <> 0 then
        rec.BitCount := 32;
    end;
  end;

  BitCount := rec.BitCount;
end;

procedure Direct3DInitializing_DXDraw(Options: TInitializeDirect3DOptions;
  DXDraw: TCustomDXDraw);
var
  BitCount: Integer;
  Driver: PGUID;
  DriverGUID: TGUID;
begin
  BitCount := DXDraw.Display.BitCount;
  Driver := DXDraw.Driver;
  Direct3DInitializing(Options, BitCount, Driver, DriverGUID);
  DXDraw.Driver := Driver;
  DXDraw.Display.BitCount := BitCount;
end;

procedure InitializeDirect3D(Surface: TDirectDrawSurface;
  var ZBuffer: TDirectDrawSurface;
  out D3D: IDirect3D;
  out D3D2: IDirect3D2;
  out D3D3: IDirect3D3;
  out D3DDevice: IDirect3DDevice;
  out D3DDevice2: IDirect3DDevice2;
  out D3DDevice3: IDirect3DDevice3;
  var D3DRM: IDirect3DRM;
  var D3DRM2: IDirect3DRM2;
  var D3DRM3: IDirect3DRM3;
  out D3DRMDevice: IDirect3DRMDevice;
  out D3DRMDevice2: IDirect3DRMDevice2;
  out D3DRMDevice3: IDirect3DRMDevice3;
  out Viewport: IDirect3DRMViewport;
  var Scene: IDirect3DRMFrame;
  var Camera: IDirect3DRMFrame;
  var NowOptions: TInitializeDirect3DOptions);
type
  TInitializeDirect3DRecord = record
    Flag: Boolean;
    BitCount: Integer;
    HWDeviceDesc: TD3DDeviceDesc;
    HELDeviceDesc: TD3DDeviceDesc;
    DeviceDesc: TD3DDeviceDesc;
    Hardware: Boolean;
    Options: TInitializeDirect3DOptions;
    GUID: TGUID;
    SupportHardware: Boolean;
  end;

  function CreateZBufferSurface(Surface: TDirectDrawSurface; var ZBuffer: TDirectDrawSurface;
    const DeviceDesc: TD3DDeviceDesc; Hardware: Boolean): Boolean;
  const
    MemPosition: array[Boolean] of Integer = (DDSCAPS_SYSTEMMEMORY, DDSCAPS_VIDEOMEMORY);
  var
    ZBufferBitDepth: Integer;
    ddsd: TDDSurfaceDesc;
  begin
    Result := False;
    FreeZBufferSurface(Surface, ZBuffer);

    if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_16 <> 0 then
      ZBufferBitDepth := 16
    else if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_24 <> 0 then
      ZBufferBitDepth := 24
    else if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_32 <> 0 then
      ZBufferBitDepth := 32
    else
      ZBufferBitDepth := 0;

    if ZBufferBitDepth <> 0 then
    begin
      with ddsd do
      begin
        dwSize := SizeOf(ddsd);
        Surface.ISurface.GetSurfaceDesc(ddsd);
        dwFlags := DDSD_CAPS or DDSD_WIDTH or DDSD_HEIGHT or DDSD_ZBUFFERBITDEPTH;
        ddsCaps.dwCaps := DDSCAPS_ZBUFFER or MemPosition[Hardware];
        dwHeight := Surface.Height;
        dwWidth := Surface.Width;
        dwZBufferBitDepth := ZBufferBitDepth;
      end;

      ZBuffer := TDirectDrawSurface.Create(Surface.DDraw);
      if ZBuffer.CreateSurface(ddsd) then
      begin
        if Surface.ISurface.AddAttachedSurface(ZBuffer.ISurface) <> DD_OK then
        begin
          ZBuffer.Free; ZBuffer := nil;
          Exit;
        end;
        Result := True;
      end else
      begin
        ZBuffer.Free; ZBuffer := nil;
        Exit;
      end;
    end;
  end;


  function EnumDeviceCallBack(const lpGuid: TGUID; lpDeviceDescription, lpDeviceName: PChar;
    const lpD3DHWDeviceDesc, lpD3DHELDeviceDesc: TD3DDeviceDesc;
    lpUserArg: Pointer): HRESULT; stdcall;
  var
    dev: ^TD3DDeviceDesc;
    Hardware: Boolean;
    rec: ^TInitializeDirect3DRecord;

    procedure UseThisDevice;
    begin
      rec.Flag := True;
      rec.GUID := lpGUID;
      rec.HWDeviceDesc := lpD3DHWDeviceDesc;
      rec.HELDeviceDesc := lpD3DHELDeviceDesc;
      rec.DeviceDesc := dev^;
      rec.Hardware := Hardware;
    end;

  begin
    Result := D3DENUMRET_OK;
    rec := lpUserArg;

    Hardware := lpD3DHWDeviceDesc.dcmColorModel <> 0;
    if Hardware then
      dev := @lpD3DHWDeviceDesc
    else
      dev := @lpD3DHELDeviceDesc;

    if (Hardware) and (not rec.SupportHardware) then Exit;
    if dev.dcmColorModel <> D3DCOLOR_RGB then Exit;
    if CompareMem(@lpGUID, @IID_IDirect3DRefDevice, SizeOf(TGUID)) then Exit;

    {  Bit depth test.  }
    if (dev.dwDeviceRenderBitDepth and BPPToDDBD(rec.BitCount)) = 0 then Exit;

    if Hardware then
    begin
      {  Hardware  }
      UseThisDevice;
    end else
    begin
      {  Software  }
      if not rec.Hardware then
        UseThisDevice;
    end;
  end;

var
  Hardware: Boolean;
  SupportHardware: Boolean;
  D3DDeviceGUID: TGUID;
  Options: TInitializeDirect3DOptions;

  procedure InitDevice;
  var
    rec: TInitializeDirect3DRecord;
  begin
    {  Device search  }
    rec.Flag := False;
    rec.BitCount := Surface.BitCount;
    rec.Hardware := False;
    rec.Options := Options;
    rec.SupportHardware := SupportHardware;

    D3D3.EnumDevices(@EnumDeviceCallBack, @rec);
    if not rec.Flag then
      raise EDXDrawError.Create(S3DDeviceNotFound);

    Hardware := rec.Hardware;
    D3DDeviceGUID := rec.GUID;

    if Hardware then
      NowOptions := NowOptions + [idoHardware];

    {  Z buffer making  }
    NowOptions := NowOptions - [idoZBuffer];
    if idoZBuffer in Options then
    begin
      if CreateZBufferSurface(Surface, ZBuffer, rec.DeviceDesc, Hardware) then
        NowOptions := NowOptions + [idoZBuffer];
    end;
  end;

type
  TDirect3DRMCreate = function(out lplpDirect3DRM: IDirect3DRM): HRESULT; stdcall;
begin
  try
    Options := NowOptions;
    NowOptions := [];

    D3D3 := Surface.DDraw.IDraw as IDirect3D3;
    D3D2 := D3D3 as IDirect3D2;
    D3D := D3D3 as IDirect3D;

    {  Whether hardware can be used is tested.  }
    SupportHardware := (Surface.SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_VIDEOMEMORY <> 0) and
      (idoHardware in Options) and (Surface.DDraw.DriverCaps.dwCaps and DDCAPS_3D <> 0);

    if Surface.DDraw.DriverCaps.ddsCaps.dwCaps and DDSCAPS_TEXTURE = 0 then
      SupportHardware := False;

    {  Direct3D  }
    InitDevice;

    if D3D3.CreateDevice(D3DDeviceGUID, Surface.ISurface4, D3DDevice3, nil) <> D3D_OK then
    begin
      SupportHardware := False;
      InitDevice;
      if D3D3.CreateDevice(D3DDeviceGUID, Surface.ISurface4, D3DDevice3, nil) <> D3D_OK then
        raise EDXDrawError.CreateFmt(SCannotMade, ['IDirect3DDevice3']);
    end;

    if SupportHardware then NowOptions := NowOptions + [idoHardware];

    D3DDevice2 := D3DDevice3 as IDirect3DDevice2;
    D3DDevice := D3DDevice3 as IDirect3DDevice;

    with D3DDevice3 do
    begin
      SetRenderState(TD3DRenderStateType(D3DRENDERSTATE_DITHERENABLE), 1);
      SetRenderState(TD3DRenderStateType(D3DRENDERSTATE_ZENABLE), Ord(ZBuffer <> nil));
      SetRenderState(TD3DRenderStateType(D3DRENDERSTATE_ZWRITEENABLE), Ord(ZBuffer <> nil));
    end;

    {  Direct3D Retained Mode}
    if idoRetainedMode in Options then
    begin
      NowOptions := NowOptions + [idoRetainedMode];

      if D3DRM = nil then
      begin
        if TDirect3DRMCreate(DXLoadLibrary('D3DRM.dll', 'Direct3DRMCreate'))(D3DRM) <> D3DRM_OK then
          raise EDXDrawError.CreateFmt(SCannotInitialized, [SDirect3DRM]);
        D3DRM2 := D3DRM as IDirect3DRM2;
        D3DRM3 := D3DRM as IDirect3DRM3;
      end;

      if D3DRM3.CreateDeviceFromD3D(D3D2, D3DDevice2, D3DRMDevice3) <> D3DRM_OK then
        raise EDXDrawError.CreateFmt(SCannotMade, ['IDirect3DRMDevice2']);

      D3DRMDevice3.SetBufferCount(2);
      D3DRMDevice := D3DRMDevice3 as IDirect3DRMDevice;
      D3DRMDevice2 := D3DRMDevice3 as IDirect3DRMDevice2;

      {  Rendering state setting  }
      D3DRMDevice.SetQuality(D3DRMLIGHT_ON or D3DRMFILL_SOLID or D3DRMSHADE_GOURAUD);
      D3DRMDevice.SetTextureQuality(D3DRMTEXTURE_NEAREST);
      D3DRMDevice.SetDither(True);

      if Surface.BitCount = 8 then
      begin
        D3DRMDevice.SetShades(8);
        D3DRM.SetDefaultTextureColors(64);
        D3DRM.SetDefaultTextureShades(32);
      end else
      begin
        D3DRM.SetDefaultTextureColors(64);
        D3DRM.SetDefaultTextureShades(32);
      end;

      {  Frame making  }
      if Scene = nil then
      begin
        D3DRM.CreateFrame(nil, Scene);
        D3DRM.CreateFrame(Scene, Camera);
        Camera.SetPosition(Camera, 0, 0, 0);
      end;

      {  Viewport making  }
      D3DRM.CreateViewport(D3DRMDevice, Camera, 0, 0,
        Surface.Width, Surface.Height, Viewport);
      Viewport.SetBack(5000.0);
    end;
  except
    FreeZBufferSurface(Surface, ZBuffer);
    D3D := nil;
    D3D2 := nil;
    D3D3 := nil;
    D3DDevice := nil;
    D3DDevice2 := nil;
    D3DDevice3 := nil;
    D3DRM := nil;
    D3DRM2 := nil;
    D3DRMDevice := nil;
    D3DRMDevice2 := nil;
    Viewport := nil;
    Scene := nil;
    Camera := nil;
    raise;
  end;
end;

procedure InitializeDirect3D7(Surface: TDirectDrawSurface;
  var ZBuffer: TDirectDrawSurface;
  out D3D7: IDirect3D7;
  out D3DDevice7: IDirect3DDevice7;
  var NowOptions: TInitializeDirect3DOptions);
type
  TInitializeDirect3DRecord = record
    Flag: Boolean;
    BitCount: Integer;
    DeviceDesc: TD3DDeviceDesc7;
    Hardware: Boolean;
    Options: TInitializeDirect3DOptions;
    SupportHardware: Boolean;
  end;

  function CreateZBufferSurface(Surface: TDirectDrawSurface; var ZBuffer: TDirectDrawSurface;
    const DeviceDesc: TD3DDeviceDesc7; Hardware: Boolean): Boolean;
  const
    MemPosition: array[Boolean] of Integer = (DDSCAPS_SYSTEMMEMORY, DDSCAPS_VIDEOMEMORY);
  var
    ZBufferBitDepth: Integer;
    ddsd: TDDSurfaceDesc;
  begin
    Result := False;
    FreeZBufferSurface(Surface, ZBuffer);

    if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_16 <> 0 then
      ZBufferBitDepth := 16
    else if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_24 <> 0 then
      ZBufferBitDepth := 24
    else if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_32 <> 0 then
      ZBufferBitDepth := 32
    else
      ZBufferBitDepth := 0;

    if ZBufferBitDepth <> 0 then
    begin
      with ddsd do
      begin
        dwSize := SizeOf(ddsd);
        Surface.ISurface.GetSurfaceDesc(ddsd);
        dwFlags := DDSD_CAPS or DDSD_WIDTH or DDSD_HEIGHT or DDSD_ZBUFFERBITDEPTH;
        ddsCaps.dwCaps := DDSCAPS_ZBUFFER or MemPosition[Hardware];
        dwHeight := Surface.Height;
        dwWidth := Surface.Width;
        dwZBufferBitDepth := ZBufferBitDepth;
      end;

      ZBuffer := TDirectDrawSurface.Create(Surface.DDraw);
      if ZBuffer.CreateSurface(ddsd) then
      begin
        if Surface.ISurface.AddAttachedSurface(ZBuffer.ISurface) <> DD_OK then
        begin
          ZBuffer.Free; ZBuffer := nil;
          Exit;
        end;
        Result := True;
      end else
      begin
        ZBuffer.Free; ZBuffer := nil;
        Exit;
      end;
    end;
  end;

  function EnumDeviceCallBack(lpDeviceDescription, lpDeviceName: PChar;
    const lpTD3DDeviceDesc: TD3DDeviceDesc7; lpUserArg: Pointer): HRESULT; stdcall;
  var
    Hardware: Boolean;
    rec: ^TInitializeDirect3DRecord;

    procedure UseThisDevice;
    begin
      rec.Flag := True;
      rec.DeviceDesc := lpTD3DDeviceDesc;
      rec.Hardware := Hardware;
    end;

  begin
    Result := D3DENUMRET_OK;
    rec := lpUserArg;

    Hardware := lpTD3DDeviceDesc.dwDevCaps and D3DDEVCAPS_HWRASTERIZATION <> 0;

    if Hardware and (not rec.SupportHardware) then Exit;
    if CompareMem(@lpTD3DDeviceDesc.deviceGUID, @IID_IDirect3DRefDevice, SizeOf(TGUID)) then Exit;

    {  Bit depth test.  }
    if (lpTD3DDeviceDesc.dwDeviceRenderBitDepth and BPPToDDBD(rec.BitCount)) = 0 then Exit;

    if Hardware then
    begin
      {  Hardware  }
      UseThisDevice;
    end else
    begin
      {  Software  }
      if not rec.Hardware then
        UseThisDevice;
    end;
  end;

var
  Hardware: Boolean;
  SupportHardware: Boolean;
  D3DDeviceGUID: TGUID;
  Options: TInitializeDirect3DOptions;

  procedure InitDevice;
  var
    rec: TInitializeDirect3DRecord;
  begin
    {  Device search  }
    rec.Flag := False;
    rec.BitCount := Surface.BitCount;
    rec.Hardware := False;
    rec.Options := Options;
    rec.SupportHardware := SupportHardware;

    D3D7.EnumDevices(@EnumDeviceCallBack, @rec);
    if not rec.Flag then
      raise EDXDrawError.Create(S3DDeviceNotFound);

    Hardware := rec.Hardware;
    D3DDeviceGUID := rec.DeviceDesc.deviceGUID;

    if Hardware then
      NowOptions := NowOptions + [idoHardware];

    {  Z buffer making  }
    NowOptions := NowOptions - [idoZBuffer];
    if idoZBuffer in Options then
    begin
      if CreateZBufferSurface(Surface, ZBuffer, rec.DeviceDesc, Hardware) then
        NowOptions := NowOptions + [idoZBuffer];
    end;
  end;

begin

  try
    Options := NowOptions - [idoRetainedMode];
    NowOptions := [];

    D3D7 := Surface.DDraw.IDraw7 as IDirect3D7;

    {  Whether hardware can be used is tested.  }
    SupportHardware := (Surface.SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_VIDEOMEMORY <> 0) and
      (idoHardware in Options) and (Surface.DDraw.DriverCaps.dwCaps and DDCAPS_3D <> 0);

    if Surface.DDraw.DriverCaps.ddsCaps.dwCaps and DDSCAPS_TEXTURE = 0 then
      SupportHardware := False;

    {  Direct3D  }
    InitDevice;

    if D3D7.CreateDevice(D3DDeviceGUID, Surface.ISurface7, D3DDevice7) <> D3D_OK then
    begin
      SupportHardware := False;
      InitDevice;
      if D3D7.CreateDevice(D3DDeviceGUID, Surface.ISurface7, D3DDevice7) <> D3D_OK then
        raise EDXDrawError.CreateFmt(SCannotMade, ['IDirect3DDevice7']);
    end;

    if SupportHardware then NowOptions := NowOptions + [idoHardware];
  except
    FreeZBufferSurface(Surface, ZBuffer);
    D3D7 := nil;
    D3DDevice7 := nil;
    raise;
  end;
end;

type
  {  TDXDrawDriver  }

  TDXDrawDriver = class
  private
    FDXDraw: TCustomDXDraw;
    constructor Create(ADXDraw: TCustomDXDraw); virtual;
    destructor Destroy; override;
    procedure Finalize; virtual;
    procedure Flip; virtual; abstract;
    procedure Initialize; virtual; abstract;
    procedure Initialize3D;
    function SetSize(AWidth, AHeight: Integer): Boolean; virtual;
    function Restore: Boolean;
  end;

  TDXDrawDriverBlt = class(TDXDrawDriver)
  private
    procedure Flip; override;
    procedure Initialize; override;
    procedure InitializeSurface;
    function SetSize(AWidth, AHeight: Integer): Boolean; override;
  end;

  TDXDrawDriverFlip = class(TDXDrawDriver)
  private
    procedure Flip; override;
    procedure Initialize; override;
  end;

{  TDXDrawDriver  }

constructor TDXDrawDriver.Create(ADXDraw: TCustomDXDraw);
var
  AOptions: TInitializeDirect3DOptions;
begin
  inherited Create;
  FDXDraw := ADXDraw;

  {  Driver selection and Display mode optimizationn }
  if FDXDraw.FOptions * [doFullScreen, doSystemMemory, do3D, doHardware] =
    [doFullScreen, do3D, doHardware] then
  begin
    AOptions := [];
    with FDXDraw do
    begin
      if doSelectDriver in Options then AOptions := AOptions + [idoSelectDriver];
      if not FDXDraw.Display.FixedBitCount then AOptions := AOptions + [idoOptimizeDisplayMode];

      if doHardware in Options then AOptions := AOptions + [idoHardware];
      if doRetainedMode in Options then AOptions := AOptions + [idoRetainedMode];
      if doZBuffer in Options then AOptions := AOptions + [idoZBuffer];
    end;

    Direct3DInitializing_DXDraw(AOptions, FDXDraw);
  end;

  if FDXDraw.Options * [doFullScreen, doHardware, doSystemMemory] = [doFullScreen, doHardware] then
    FDXDraw.FDDraw := TDirectDraw.CreateEx(PGUID(FDXDraw.FDriver), doDirectX7Mode in FDXDraw.Options)
  else
    FDXDraw.FDDraw := TDirectDraw.CreateEx(nil, doDirectX7Mode in FDXDraw.Options);
end;

procedure TDXDrawDriver.Initialize3D;
const
  DXDrawOptions3D = [doHardware, doRetainedMode, doSelectDriver, doZBuffer];
var
  AOptions: TInitializeDirect3DOptions;
begin
  AOptions := [];
  with FDXDraw do
  begin
    if doHardware in FOptions then AOptions := AOptions + [idoHardware];
    if doRetainedMode in FNowOptions then AOptions := AOptions + [idoRetainedMode];
    if doSelectDriver in FOptions then AOptions := AOptions + [idoSelectDriver];
    if doZBuffer in FOptions then AOptions := AOptions + [idoZBuffer];

    if doDirectX7Mode in FOptions then
    begin
      InitializeDirect3D7(FSurface, FZBuffer, FD3D7, FD3DDevice7, AOptions);
    end else
    begin
      InitializeDirect3D(FSurface, FZBuffer, FD3D, FD3D2, FD3D3, FD3DDevice, FD3DDevice2, FD3DDevice3,
        FD3DRM, FD3DRM2, FD3DRM3, FD3DRMDevice, FD3DRMDevice2, FD3DRMDevice3, FViewport, FScene, FCamera, AOptions);
    end;

    FNowOptions := FNowOptions - DXDrawOptions3D;
    if idoHardware in AOptions then FNowOptions := FNowOptions + [doHardware];
    if idoRetainedMode in AOptions then FNowOptions := FNowOptions + [doRetainedMode];
    if idoSelectDriver in AOptions then FNowOptions := FNowOptions + [doSelectDriver];
    if idoZBuffer in AOptions then FNowOptions := FNowOptions + [doZBuffer];
  end;
end;

destructor TDXDrawDriver.Destroy;
begin
  Finalize;
  FDXDraw.FDDraw.Free;
  inherited Destroy;
end;

procedure TDXDrawDriver.Finalize;
begin
  with FDXDraw do
  begin
    FViewport := nil;
    FCamera := nil;
    FScene := nil;

    FD3DRMDevice := nil;
    FD3DRMDevice2 := nil;
    FD3DRMDevice3 := nil;
    FD3DDevice := nil;
    FD3DDevice2 := nil;
    FD3DDevice3 := nil;
    FD3DDevice7 := nil;
    FD3D := nil;
    FD3D2 := nil;
    FD3D3 := nil;
    FD3D7 := nil;

    FreeZBufferSurface(FSurface, FZBuffer);

    FClipper.Free; FClipper := nil;
    FPalette.Free; FPalette := nil;
    FSurface.Free; FSurface := nil;
    FPrimary.Free; FPrimary := nil;

    FD3DRM3 := nil;
    FD3DRM2 := nil;
    FD3DRM := nil;
  end;
end;

function TDXDrawDriver.Restore: Boolean;
begin
  Result := FDXDraw.FPrimary.Restore and FDXDraw.FSurface.Restore;
  if Result then
  begin
    FDXDraw.FPrimary.Fill(0);
    FDXDraw.FSurface.Fill(0);
  end;
end;

function TDXDrawDriver.SetSize(AWidth, AHeight: Integer): Boolean;
begin
  Result := False;
end;

{  TDXDrawDriverBlt  }

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads;
  AllowPalette256: Boolean): TPaletteEntries;
var
  Entries: TPaletteEntries;
  dc: THandle;
  i: Integer;
begin
  Result := RGBQuadsToPaletteEntries(RGBQuads);

  if not AllowPalette256 then
  begin
    dc := GetDC(0);
    try
      GetSystemPaletteEntries(dc, 0, 256, Entries);
    finally
      ReleaseDC(0, dc);
    end;

    for i := 0 to 9 do
      Result[i] := Entries[i];

    for i := 256 - 10 to 255 do
      Result[i] := Entries[i];
  end;

  for i := 0 to 255 do
    Result[i].peFlags := D3DPAL_READONLY;
end;

procedure TDXDrawDriverBlt.Flip;
var
  pt: TPoint;
  Dest: TRect;
  DF: TDDBltFX;
begin
  pt := FDXDraw.ClientToScreen(Point(0, 0));

  if doStretch in FDXDraw.NowOptions then
  begin
    Dest := Bounds(pt.x, pt.y, FDXDraw.Width, FDXDraw.Height);
  end else
  begin
    if doCenter in FDXDraw.NowOptions then
    begin
      Inc(pt.x, (FDXDraw.Width - FDXDraw.FSurface.Width) div 2);
      Inc(pt.y, (FDXDraw.Height - FDXDraw.FSurface.Height) div 2);
    end;

    Dest := Bounds(pt.x, pt.y, FDXDraw.FSurface.Width, FDXDraw.FSurface.Height);
  end;

  if doWaitVBlank in FDXDraw.NowOptions then
    FDXDraw.FDDraw.DXResult := FDXDraw.FDDraw.IDraw.WaitForVerticalBlank(DDWAITVB_BLOCKBEGIN, 0);

  DF.dwsize := SizeOf(DF);
  DF.dwDDFX := 0;

  FDXDraw.FPrimary.Blt(Dest, FDXDraw.FSurface.ClientRect, DDBLT_WAIT, df, FDXDraw.FSurface);
end;

procedure TDXDrawDriverBlt.Initialize;
const
  PrimaryDesc: TDDSurfaceDesc = (
    dwSize: SizeOf(PrimaryDesc);
    dwFlags: DDSD_CAPS;
    ddsCaps: (dwCaps: DDSCAPS_PRIMARYSURFACE)
    );
var
  Entries: TPaletteEntries;
  PaletteCaps: Integer;
begin
  {  Surface making  }
  FDXDraw.FPrimary := TDirectDrawSurface.Create(FDXDraw.FDDraw);
  if not FDXDraw.FPrimary.CreateSurface(PrimaryDesc) then
    raise EDXDrawError.CreateFmt(SCannotMade, [SDirectDrawPrimarySurface]);

  FDXDraw.FSurface := TDirectDrawSurface.Create(FDXDraw.FDDraw);

  {  Clipper making  }
  FDXDraw.FClipper := TDirectDrawClipper.Create(FDXDraw.FDDraw);
  FDXDraw.FClipper.Handle := FDXDraw.Handle;
  FDXDraw.FPrimary.Clipper := FDXDraw.FClipper;

  {  Palette making  }
  PaletteCaps := DDPCAPS_8BIT or DDPCAPS_INITIALIZE;
  if doAllowPalette256 in FDXDraw.NowOptions then
    PaletteCaps := PaletteCaps or DDPCAPS_ALLOW256;

  FDXDraw.FPalette := TDirectDrawPalette.Create(FDXDraw.FDDraw);
  Entries := TDXDrawRGBQuadsToPaletteEntries(FDXDraw.ColorTable,
    doAllowPalette256 in FDXDraw.NowOptions);
  FDXDraw.FPalette.CreatePalette(PaletteCaps, Entries);

  FDXDraw.FPrimary.Palette := FDXDraw.Palette;

  InitializeSurface;
end;

procedure TDXDrawDriverBlt.InitializeSurface;
var
  ddsd: TDDSurfaceDesc;
begin
  FDXDraw.FSurface.IDDSurface := nil;

  {  Surface making  }
  FDXDraw.FNowOptions := FDXDraw.FNowOptions - [doSystemMemory];

  FillChar(ddsd, SizeOf(ddsd), 0);
  with ddsd do
  begin
    dwSize := SizeOf(ddsd);
    dwFlags := DDSD_WIDTH or DDSD_HEIGHT or DDSD_CAPS;
    dwWidth := Max(FDXDraw.FSurfaceWidth, 1);
    dwHeight := Max(FDXDraw.FSurfaceHeight, 1);
    ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN;
    if doSystemMemory in FDXDraw.Options then
      ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_SYSTEMMEMORY;
    if do3D in FDXDraw.FNowOptions then
      ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_3DDEVICE;
  end;

  if not FDXDraw.FSurface.CreateSurface(ddsd) then
  begin
    ddsd.ddsCaps.dwCaps := ddsd.ddsCaps.dwCaps or DDSCAPS_SYSTEMMEMORY;
    if not FDXDraw.FSurface.CreateSurface(ddsd) then
      raise EDXDrawError.CreateFmt(SCannotMade, [SDirectDrawSurface]);
  end;

  if FDXDraw.FSurface.SurfaceDesc.ddscaps.dwCaps and DDSCAPS_VIDEOMEMORY = 0 then
    FDXDraw.FNowOptions := FDXDraw.FNowOptions + [doSystemMemory];

  FDXDraw.FSurface.Palette := FDXDraw.Palette;
  FDXDraw.FSurface.Fill(0);

  if do3D in FDXDraw.FNowOptions then
    Initialize3D;
end;

function TDXDrawDriverBlt.SetSize(AWidth, AHeight: Integer): Boolean;
begin
  Result := True;

  FDXDraw.FSurfaceWidth := Max(AWidth, 1);
  FDXDraw.FSurfaceHeight := Max(AHeight, 1);

  Inc(FDXDraw.FOffNotifyRestore);
  try
    FDXDraw.NotifyEventList(dxntFinalizeSurface);

    if FDXDraw.FCalledDoInitializeSurface then
    begin
      FDXDraw.FCalledDoInitializeSurface := False;
      FDXDraw.DoFinalizeSurface;
    end;

    InitializeSurface;

    FDXDraw.NotifyEventList(dxntInitializeSurface);
    FDXDraw.FCalledDoInitializeSurface := True; FDXDraw.DoInitializeSurface;
  finally
    Dec(FDXDraw.FOffNotifyRestore);
  end;
end;

{  TDXDrawDriverFlip  }

procedure TDXDrawDriverFlip.Flip;
begin
  if (FDXDraw.FForm <> nil) and (FDXDraw.FForm.Active) then
    FDXDraw.FPrimary.DXResult := FDXDraw.FPrimary.ISurface.Flip(nil, DDFLIP_WAIT)
  else
    FDXDraw.FPrimary.DXResult := 0;
end;

procedure TDXDrawDriverFlip.Initialize;
const
  DefPrimaryDesc: TDDSurfaceDesc = (
    dwSize: SizeOf(DefPrimaryDesc);
    dwFlags: DDSD_CAPS or DDSD_BACKBUFFERCOUNT;
    dwBackBufferCount: 1;
    ddsCaps: (dwCaps: DDSCAPS_PRIMARYSURFACE or DDSCAPS_FLIP or DDSCAPS_COMPLEX)
    );
  BackBufferCaps: TDDSCaps = (dwCaps: DDSCAPS_BACKBUFFER);
var
  PrimaryDesc: TDDSurfaceDesc;
  PaletteCaps: Integer;
  Entries: TPaletteEntries;
  DDSurface: IDirectDrawSurface;
begin
  {  Surface making  }
  PrimaryDesc := DefPrimaryDesc;

  if do3D in FDXDraw.FNowOptions then
    PrimaryDesc.ddsCaps.dwCaps := PrimaryDesc.ddsCaps.dwCaps or DDSCAPS_3DDEVICE;

  FDXDraw.FPrimary := TDirectDrawSurface.Create(FDXDraw.FDDraw);
  if not FDXDraw.FPrimary.CreateSurface(PrimaryDesc) then
    raise EDXDrawError.CreateFmt(SCannotMade, [SDirectDrawPrimarySurface]);

  FDXDraw.FSurface := TDirectDrawSurface.Create(FDXDraw.FDDraw);
  if FDXDraw.FPrimary.ISurface.GetAttachedSurface(BackBufferCaps, DDSurface) = DD_OK then
    FDXDraw.FSurface.IDDSurface := DDSurface;

  FDXDraw.FNowOptions := FDXDraw.FNowOptions - [doSystemMemory];
  if FDXDraw.FSurface.SurfaceDesc.ddscaps.dwCaps and DDSCAPS_SYSTEMMEMORY <> 0 then
    FDXDraw.FNowOptions := FDXDraw.FNowOptions + [doSystemMemory];

  {  Clipper making of dummy  }
  FDXDraw.FClipper := TDirectDrawClipper.Create(FDXDraw.FDDraw);

  {  Palette making  }
  PaletteCaps := DDPCAPS_8BIT;
  if doAllowPalette256 in FDXDraw.Options then
    PaletteCaps := PaletteCaps or DDPCAPS_ALLOW256;

  FDXDraw.FPalette := TDirectDrawPalette.Create(FDXDraw.FDDraw);
  Entries := TDXDrawRGBQuadsToPaletteEntries(FDXDraw.ColorTable,
    doAllowPalette256 in FDXDraw.NowOptions);
  FDXDraw.FPalette.CreatePalette(PaletteCaps, Entries);

  FDXDraw.FPrimary.Palette := FDXDraw.Palette;
  FDXDraw.FSurface.Palette := FDXDraw.Palette;

  if do3D in FDXDraw.FNowOptions then
    Initialize3D;

end;

constructor TCustomDXDraw.Create(AOwner: TComponent);
var
  Entries: TPaletteEntries;
  dc: THandle;
begin
  FNotifyEventList := TList.Create;
  inherited Create(AOwner);
  FAutoInitialize := True;
  FDisplay := TDXDrawDisplay.Create(Self);

  Options := [doAllowReboot, doWaitVBlank, doCenter, doDirectX7Mode, do3D, doHardware, doSelectDriver];

  FAutoSize := True;

  dc := GetDC(0);
  try
    GetSystemPaletteEntries(dc, 0, 256, Entries);
  finally
    ReleaseDC(0, dc);
  end;

  ColorTable := PaletteEntriesToRGBQuads(Entries);
  DefColorTable := ColorTable;

  Width := 100;
  Height := 100;
  ParentColor := False;
  Color := clBlack; //clBtnFace; // FIX

  FD2D := TD2D.Create(Self);
  D2D := FD2D; {as loopback}
end;

destructor TCustomDXDraw.Destroy;
begin
  Finalize;
  NotifyEventList(dxntDestroying);
  FDisplay.Free;
  FSubClass.Free; FSubClass := nil;
  FNotifyEventList.Free;
  FD2D.Free;
  FD2D := nil;
  D2D := nil;
  inherited Destroy;
end;

class function TCustomDXDraw.Drivers: TDirectXDrivers;
begin
  Result := EnumDirectDrawDrivers;
end;

type
  PDXDrawNotifyEvent = ^TDXDrawNotifyEvent;

procedure TCustomDXDraw.RegisterNotifyEvent(NotifyEvent: TDXDrawNotifyEvent);
var
  Event: PDXDrawNotifyEvent;
begin
  UnRegisterNotifyEvent(NotifyEvent);

  New(Event);
  Event^ := NotifyEvent;
  FNotifyEventList.Add(Event);

  NotifyEvent(Self, dxntSetSurfaceSize);

  if Initialized then
  begin
    NotifyEvent(Self, dxntInitialize);
    if FCalledDoInitializeSurface then
      NotifyEvent(Self, dxntInitializeSurface);
    if FOffNotifyRestore = 0 then
      NotifyEvent(Self, dxntRestore);
  end;
end;

procedure TCustomDXDraw.UnRegisterNotifyEvent(NotifyEvent: TDXDrawNotifyEvent);
var
  Event: PDXDrawNotifyEvent;
  i: Integer;
begin
  for i := 0 to FNotifyEventList.Count - 1 do
  begin
    Event := FNotifyEventList[i];
    if (TMethod(Event^).Code = TMethod(NotifyEvent).Code) and
      (TMethod(Event^).Data = TMethod(NotifyEvent).Data) then
    begin
      FreeMem(Event);
      FNotifyEventList.Delete(i);

      if FCalledDoInitializeSurface then
        NotifyEvent(Self, dxntFinalizeSurface);
      if Initialized then
        NotifyEvent(Self, dxntFinalize);

      Break;
    end;
  end;
end;

procedure TCustomDXDraw.NotifyEventList(NotifyType: TDXDrawNotifyType);
var
  i: Integer;
begin
  for i := FNotifyEventList.Count - 1 downto 0 do
    PDXDrawNotifyEvent(FNotifyEventList[i])^(Self, NotifyType);
end;

procedure TCustomDXDraw.FormWndProc(var Message: TMessage; DefWindowProc: TWndMethod);

  procedure FlipToGDISurface;
  begin
    if Initialized and (FNowOptions * [doFullScreen, doFlip] = [doFullScreen, doFlip]) then
      DDraw.IDraw.FlipToGDISurface;
  end;

begin
  case Message.Msg of
    {CM_ACTIVATE:
        begin
          DefWindowProc(Message);
          if AutoInitialize and (not FInitalized2) then
            Initialize;
          Exit;
        end;   }
    WM_WINDOWPOSCHANGED:
      begin
        if TWMWindowPosChanged(Message).WindowPos^.flags and SWP_SHOWWINDOW <> 0 then
        begin
          DefWindowProc(Message);
          if AutoInitialize and (not FInitialized2) then
            Initialize;
          Exit;
        end;
      end;
(*
    WM_ACTIVATEAPP:
      begin
        if TWMActivateApp(Message).Active then
        begin
          FActive := True;
          DoActivate;
//          PostMessage(FHandle, CM_ACTIVATE, 0, 0)
        end
        else
        begin
          FActive := False;
          DoDeactivate;
//          PostMessage(FHandle, CM_DEACTIVATE, 0, 0);
        end;
      end;
*)
    WM_ACTIVATE:
      begin
        if TWMActivate(Message).Active = WA_INACTIVE then
          FlipToGDISurface;
      end;
    WM_INITMENU:
      begin
        FlipToGDISurface;
      end;
    WM_DESTROY:
      begin
        Finalize;
      end;
    WM_ENTERSIZEMOVE:
      begin
        if not (csLoading in ComponentState) then
          Finalize;
      end;
    WM_EXITSIZEMOVE:
      begin
        if not (csLoading in ComponentState) then
          Initialize;
      end;
//    SW_RESTORE, SW_MAXIMIZE:
//        begin
//          {force finalize/initialize loop}
//          if not AutoInitialize or not (csLoading in ComponentState) then begin
//            Finalize;
//            Initialize;
//          end;
//        end;
  end;
  DefWindowProc(Message);
end;

procedure TCustomDXDraw.DoFinalize;
begin
  if Assigned(FOnFinalize) then FOnFinalize(Self);
end;

procedure TCustomDXDraw.DoFinalizeSurface;
begin
  if Assigned(FOnFinalizeSurface) then FOnFinalizeSurface(Self);
end;

procedure TCustomDXDraw.DoInitialize;
begin
  if Assigned(FOnInitialize) then FOnInitialize(Self);
end;

procedure TCustomDXDraw.DoInitializeSurface;
begin
  {.06 added for better initialization}
  if Assigned(FD2D) then
    RenderError := FD2D.D2DInitializeSurface;

  if Assigned(FOnInitializeSurface) then FOnInitializeSurface(Self);
end;

procedure TCustomDXDraw.DoInitializing;
begin
  if Assigned(FOnInitializing) then FOnInitializing(Self);
end;

procedure TCustomDXDraw.DoRestoreSurface;
begin
  if Assigned(FOnRestoreSurface) then FOnRestoreSurface(Self);
end;

procedure TCustomDXDraw.Finalize;
begin
  if FInternalInitialized then
  begin
    FSurfaceWidth := SurfaceWidth;
    FSurfaceHeight := SurfaceHeight;

    FDisplay.FModes.Clear;

    FUpdating := True;
    try
      try
        try
          if FCalledDoInitializeSurface then
          begin
            FCalledDoInitializeSurface := False;
            DoFinalizeSurface;
          end;
        finally
          NotifyEventList(dxntFinalizeSurface);
        end;
      finally
        try
          if FCalledDoInitialize then
          begin
            FCalledDoInitialize := False;
            DoFinalize;
          end;
        finally
          NotifyEventList(dxntFinalize);
        end;
      end;
    finally
      FInternalInitialized := False;
      FInitialized := False;

      SetOptions(FOptions);

      FDXDrawDriver.Free; FDXDrawDriver := nil;
      FUpdating := False;
    end;
  end;
  if AsSigned(FD2D) then
    FD2D.Free;
  FD2D := nil;
  D2D := nil
end;

procedure TCustomDXDraw.Flip;
begin
  if Initialized and (not FUpdating) then
  begin
    if TryRestore and (not RenderError) then
      TDXDrawDriver(FDXDrawDriver).Flip;
  end;
  RenderError := false;
end;

function TCustomDXDraw.GetCanDraw: Boolean;
begin
  Result := Initialized and (not FUpdating) and (Surface.IDDSurface <> nil) and
    TryRestore;
end;

function TCustomDXDraw.GetCanPaletteAnimation: Boolean;
begin
  Result := Initialized and (not FUpdating) and (doFullScreen in FNowOptions)
    and (DDraw.DisplayMode.ddpfPixelFormat.dwRGBBitCount <= 8);
end;

function TCustomDXDraw.GetSurfaceHeight: Integer;
begin
  if Surface.IDDSurface <> nil then
    Result := Surface.Height
  else
    Result := FSurfaceHeight;
end;

function TCustomDXDraw.GetSurfaceWidth: Integer;
begin
  if Surface.IDDSurface <> nil then
    Result := Surface.Width
  else
    Result := FSurfaceWidth;
end;

procedure TCustomDXDraw.Loaded;
begin
  inherited Loaded;

  if AutoSize then
  begin
    FSurfaceWidth := Width;
    FSurfaceHeight := Height;
  end;

  NotifyEventList(dxntSetSurfaceSize);

  if FAutoInitialize and (not (csDesigning in ComponentState)) then
  begin
    if {(not (doFullScreen in FOptions)) or }(FSubClass = nil) then
      Initialize;
  end;
end;

procedure TCustomDXDraw.Initialize;
begin
  FInitialized2 := True;

  Finalize;

  if FForm = nil then
    raise EDXDrawError.Create(SNoForm);

  try
    DoInitializing;

    {  Initialization.  }
    FUpdating := True;
    try
      FInternalInitialized := True;

      NotifyEventList(dxntInitializing);

      {  DirectDraw initialization.  }
      if doFlip in FNowOptions then
        FDXDrawDriver := TDXDrawDriverFlip.Create(Self)
      else
        FDXDrawDriver := TDXDrawDriverBlt.Create(Self);

      {  Window handle setting.  }
      SetCooperativeLevel;

      {  Set display mode.  }
      if doFullScreen in FNowOptions then
      begin
        if not Display.DynSetSize(Display.Width, Display.Height, Display.BitCount) then
          raise EDXDrawError.CreateFmt(SDisplaymodeChange, [Display.Width, Display.Height, Display.BitCount]);
      end;

      {  Resource initialization.  }
      if AutoSize then
      begin
        FSurfaceWidth := Width;
        FSurfaceHeight := Height;
      end;

      TDXDrawDriver(FDXDrawDriver).Initialize;
    finally
      FUpdating := False;
    end;
  except
    Finalize;
    raise;
  end;

  FInitialized := True;

  Inc(FOffNotifyRestore);
  try
    NotifyEventList(dxntSetSurfaceSize);
    NotifyEventList(dxntInitialize);
    FCalledDoInitialize := True; DoInitialize;

    NotifyEventList(dxntInitializeSurface);
    FCalledDoInitializeSurface := True; DoInitializeSurface;
  finally
    Dec(FOffNotifyRestore);
  end;

  if not Assigned(FD2D) then begin
    FD2D := TD2D.Create(Self);
    D2D := FD2D; {as loopback}
  end;

  Restore;
end;

procedure TCustomDXDraw.Paint;
var
  Old: TDXDrawOptions;
  w, h: Integer;
  s: string;
begin
  inherited Paint;
  if (csDesigning in ComponentState) then
  begin
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Style := psDash;
    Canvas.Rectangle(0, 0, Width, Height);

    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Color := clGray;
    Canvas.MoveTo(0, 0);
    Canvas.LineTo(Width, Height);

    Canvas.MoveTo(0, Height);
    Canvas.LineTo(Width, 0);

    s := Format('(%s)', [ClassName]);

    w := Canvas.TextWidth(s);
    h := Canvas.TextHeight(s);

    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := clBtnFace;
    Canvas.TextOut(Width div 2 - w div 2, Height div 2 - h div 2, s);
  end else
  begin
    Old := FNowOptions;
    try
      FNowOptions := FNowOptions - [doWaitVBlank];
      Flip;
    finally
      FNowOptions := Old;
    end;
    if (Parent <> nil) and (Initialized) and (Surface.SurfaceDesc.ddscaps.dwCaps and DDSCAPS_VIDEOMEMORY <> 0) then
      Parent.Invalidate;
  end;
end;

function TCustomDXDraw.PaletteChanged(Foreground: Boolean): Boolean;
begin
  if Foreground then
  begin
    Restore;
    Result := True;
  end else
    Result := False;
end;

procedure TCustomDXDraw.Render;
begin
  if FInitialized and (do3D in FNowOptions) and (doRetainedMode in FNowOptions) then
  begin
    asm FInit end;
    FViewport.Clear;
    FViewport.Render(FScene);
    FD3DRMDevice.Update;
    asm FInit end;
  end;
end;

procedure TCustomDXDraw.Restore;
begin
  if Initialized and (not FUpdating) then
  begin
    FUpdating := True;
    try
      if TDXDrawDriver(FDXDrawDriver).Restore then
      begin
        Primary.Palette := Palette;
        Surface.Palette := Palette;

        SetColorTable(DefColorTable);
        NotifyEventList(dxntRestore);
        DoRestoreSurface;
        SetColorTable(ColorTable);
      end;
    finally
      FUpdating := False;
    end;
  end;
end;

procedure TCustomDXDraw.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    if FAutoSize then
      SetSize(Width, Height);
  end;
end;

procedure TCustomDXDraw.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if FAutoSize and (not FUpdating) then
    SetSize(AWidth, AHeight);
end;

procedure TCustomDXDraw.BeginScene;
begin
  if (do3D in Options) and AsSigned(FD2D) then
    FD2D.BeginScene
end;

procedure TCustomDXDraw.EndScene;
begin
  if (do3D in Options) and AsSigned(FD2D) then
    FD2D.EndScene
end;

procedure TCustomDXDraw.ClearStack;
begin
  if (do3D in Options) and AsSigned(FD2D) then
    FD2D.D2DPruneAllTextures;
end;

procedure TCustomDXDraw.TextureFilter(Grade: Integer);
begin
  if (do3D in Options) and AsSigned(FD2D) then
    FD2D.TextureFilter := TD2DTextureFilter(Grade);
end;

// ***** fade effects
// do not use in dxtimer cycle

function TCustomDXDraw.Fade2Color(colorfrom, colorto: longint): longint;
var i, r1, r2, g1, g2, b1, b2: integer;
begin
  r1 := GetRValue(colorfrom);
  r2 := GetRValue(colorto);
  g1 := GetGValue(colorfrom);
  g2 := GetGValue(colorto);
  b1 := GetBValue(colorfrom);
  b2 := GetBValue(colorto);
  if r1 < r2 then
  begin
    for i := r1 to r2 do
    begin
      Surface.Fill(RGB(i, g1, b1));
      Flip;
    end;
  end
  else
  begin
    for i := r1 downto r2 do
    begin
      Surface.Fill(RGB(i, g1, b1));
      Flip;
    end;
  end;

  if g1 < g2 then
  begin
    for i := g1 to g2 do
    begin
      Surface.Fill(RGB(r2, i, b1));
      Flip;
    end;
  end
  else
  begin
    for i := g1 downto g2 do
    begin
      Surface.Fill(RGB(r2, i, b1));
      Flip;
    end;
  end;
  if b1 < b2 then
  begin
    for i := b1 to b2 do
    begin
      Surface.Fill(RGB(r2, g2, i));
      Flip;
    end;
  end
  else
  begin
    for i := b1 downto b2 do
    begin
      Surface.Fill(RGB(r2, g2, i));
      Flip;
    end;
  end;
  result := colorto;
end;

function TCustomDXDraw.Fade2Black(colorfrom: longint): longint;
var i, r, g, b: integer;
begin
  r := GetRValue(colorfrom);
  g := GetGValue(colorfrom);
  b := GetBValue(colorfrom);
  for i := r downto 0 do
  begin
    Surface.Fill(RGB(i, g, b));
    Flip;
  end;
  for i := g downto 0 do
  begin
    Surface.Fill(RGB(0, i, b));
    Flip;
  end;
  for i := g downto 0 do
  begin
    Surface.Fill(RGB(0, 0, i));
    Flip;
  end;
  result := 0;
end;

function TCustomDXDraw.Fade2White(colorfrom: longint): longint;
var i, r, g, b: integer;
begin
  r := GetRValue(colorfrom);
  g := GetGValue(colorfrom);
  b := GetBValue(colorfrom);
  for i := r to 255 do
  begin
    Surface.Fill(RGB(i, g, b));
    Flip;
  end;
  for i := g to 255 do
  begin
    Surface.Fill(RGB(255, i, b));
    Flip;
  end;
  for i := b to 255 do
  begin
    Surface.Fill(RGB(255, 255, i));
    Flip;
  end;
  Result := RGB(255, 255, 255);
end;

function TCustomDXDraw.Grey2Fade(shadefrom, shadeto: integer): integer;
var i: integer;
begin
  if shadefrom < shadeto then
  begin
    for i := shadefrom to shadeto do
    begin
      Surface.Fill(RGB(i, i, i));
      Flip;
    end;
  end
  else
  begin
    for i := shadefrom downto shadeto do
    begin
      Surface.Fill(RGB(i, i, i));
      Flip;
    end;
  end;
  result := shadeto;
end;

function TCustomDXDraw.Fade2Screen(oldcolor, newcolour: longint): longint;
begin
  result := Fade2Color(oldcolor, newcolour);
end;

function TCustomDXDraw.White2Screen(oldcolor: Integer): longint;
begin
  result := Fade2Color(oldcolor, RGB(255, 255, 255));
end;

function TCustomDXDraw.Black2Screen(oldcolor: Integer): longint;
begin
  result := Fade2Color(oldcolor, RGB(0, 0, 0));
end;

procedure TCustomDXDraw.GrabImage(x, y, width, height: integer; ddib: TDIB);
var ts, td: trect;
begin
  ddib.setsize(width, height, 24);
  ts.left := x;
  ts.top := y;
  ts.right := x + width - 1;
  ts.bottom := y + height - 1;
  td.left := 0;
  td.top := 0;
  td.right := width;
  td.bottom := height;
  with Surface.Canvas do
  begin
    ddib.canvas.CopyRect(td, surface.canvas, ts);
    release;
  end;
end;

procedure TCustomDXDraw.PasteImage(sdib: TDIB; x, y: integer);
var
  ts, td: trect;
  w, h: integer;
begin
  w := sdib.width - 1;
  h := sdib.height - 1;
  ts.left := 0;
  ts.top := 0;
  ts.right := w;
  ts.bottom := h;
  td.left := x;
  td.top := y;
  td.right := x + w;
  td.bottom := y + h;
  with Surface.Canvas do
  begin
    CopyRect(td, sdib.canvas, ts);
    release;
  end;
end;

// *****

procedure TCustomDXDraw.SetColorTable(const ColorTable: TRGBQuads);
var
  Entries: TPaletteEntries;
begin
  if Initialized and (Palette <> nil) then
  begin
    Entries := TDXDrawRGBQuadsToPaletteEntries(ColorTable,
      doAllowPalette256 in FNowOptions);
    Palette.SetEntries(0, 256, Entries);
  end;
end;

procedure TCustomDXDraw.SetCooperativeLevel;
var
  Flags: Integer;
  Control: TWinControl;
begin
  Control := FForm;
  if Control = nil then
    Control := Self;

  if doFullScreen in FNowOptions then
  begin
    Flags := DDSCL_FULLSCREEN or DDSCL_EXCLUSIVE or DDSCL_ALLOWMODEX;
    if doNoWindowChange in FNowOptions then
      Flags := Flags or DDSCL_NOWINDOWCHANGES;
    if doAllowReboot in FNowOptions then
      Flags := Flags or DDSCL_ALLOWREBOOT;
  end else
    Flags := DDSCL_NORMAL;

  DDraw.DXResult := DDraw.IDraw.SetCooperativeLevel(Control.Handle, Flags);
end;

procedure TCustomDXDraw.SetDisplay(Value: TDXDrawDisplay);
begin
  FDisplay.Assign(Value);
end;

procedure TCustomDXDraw.SetDriver(Value: PGUID);
begin
  if not IsBadHugeReadPtr(Value, SizeOf(TGUID)) then
  begin
    FDriverGUID := Value^;
    FDriver := @FDriverGUID;
  end else
    FDriver := Value;
end;

procedure TCustomDXDraw.SetOptions(Value: TDXDrawOptions);
const
  InitOptions = [doDirectX7Mode, doFullScreen, doNoWindowChange, doAllowReboot,
    doAllowPalette256, doSystemMemory, doFlip, do3D,
    doRetainedMode, doHardware, doSelectDriver, doZBuffer];
var
  OldOptions: TDXDrawOptions;
begin
  FOptions := Value;

  if Initialized then
  begin
    OldOptions := FNowOptions;
    FNowOptions := FNowOptions * InitOptions + (FOptions - InitOptions);

    if not (do3D in FNowOptions) then
      FNowOptions := FNowOptions - [doHardware, doRetainedMode, doSelectDriver, doZBuffer];
  end else
  begin
    FNowOptions := FOptions;

    if not (doFullScreen in FNowOptions) then
      FNowOptions := FNowOptions - [doNoWindowChange, doAllowReBoot, doAllowPalette256, doFlip];

    if not (do3D in FNowOptions) then
      FNowOptions := FNowOptions - [doDirectX7Mode, doRetainedMode, doHardware, doSelectDriver, doZBuffer];

    if doSystemMemory in FNowOptions then
      FNowOptions := FNowOptions - [doFlip];

    if doDirectX7Mode in FNowOptions then
      FNowOptions := FNowOptions - [doRetainedMode];

    FNowOptions := FNowOptions - [doHardware];
  end;
end;

procedure TCustomDXDraw.SetParent(AParent: TWinControl);
var
  Control: TWinControl;
begin
  inherited SetParent(AParent);

  FForm := nil;
  FSubClass.Free; FSubClass := nil;

  if not (csDesigning in ComponentState) then
  begin
    Control := Parent;
    while (Control <> nil) and (not (Control is TCustomForm)) do
      Control := Control.Parent;
    if Control <> nil then
    begin
      FForm := TCustomForm(Control);
      FSubClass := TControlSubClass.Create(Control, FormWndProc);
    end;
  end;
end;

procedure TCustomDXDraw.SetSize(ASurfaceWidth, ASurfaceHeight: Integer);
begin
  if ((ASurfaceWidth <> SurfaceWidth) or (ASurfaceHeight <> SurfaceHeight)) and
    (not FUpdating) then
  begin
    if Initialized then
    begin
      try
        if not TDXDrawDriver(FDXDrawDriver).SetSize(ASurfaceWidth, ASurfaceHeight) then
          Exit;
      except
        Finalize;
        raise;
      end;
    end else
    begin
      FSurfaceWidth := ASurfaceWidth;
      FSurfaceHeight := ASurfaceHeight;
    end;

    NotifyEventList(dxntSetSurfaceSize);
  end;
end;

procedure TCustomDXDraw.SetSurfaceHeight(Value: Integer);
begin
  if ComponentState * [csReading, csLoading] = [] then
    SetSize(SurfaceWidth, Value)
  else
    FSurfaceHeight := Value;
end;

procedure TCustomDXDraw.SetSurfaceWidth(Value: Integer);
begin
  if ComponentState * [csReading, csLoading] = [] then
    SetSize(Value, SurfaceHeight)
  else
    FSurfaceWidth := Value;
end;

function TCustomDXDraw.TryRestore: Boolean;
begin
  Result := False;

  if Initialized and (not FUpdating) and (Primary.IDDSurface <> nil) then
  begin
    if (Primary.ISurface.IsLost = DDERR_SURFACELOST) or
      (Surface.ISurface.IsLost = DDERR_SURFACELOST) then
    begin
      Restore;
      Result := (Primary.ISurface.IsLost = DD_OK) and (Surface.ISurface.IsLost = DD_OK);
    end else
      Result := True;
  end;
end;

procedure TCustomDXDraw.UpdatePalette;
begin
  if Initialized and (doWaitVBlank in FNowOptions) then
  begin
    if FDDraw.FDriverCaps.dwPalCaps and DDPCAPS_VSYNC = 0 then
      FDDraw.IDraw.WaitForVerticalBlank(DDWAITVB_BLOCKBEGIN, 0);
  end;

  SetColorTable(ColorTable);
end;

procedure TCustomDXDraw.WMCreate(var Message: TMessage);
begin
  inherited;
  if Initialized and (not FUpdating) then
  begin
    if Clipper <> nil then
      Clipper.Handle := Handle;
    SetCooperativeLevel;
  end;
end;

{$IFDEF DX3D_deprecated}

{  TCustomDX3D  }

constructor TCustomDX3D.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Options := [toHardware, toRetainedMode, toSelectDriver];
  FSurfaceWidth := 320;
  FSurfaceHeight := 240;
end;

destructor TCustomDX3D.Destroy;
begin
  DXDraw := nil;
  inherited Destroy;
end;

procedure TCustomDX3D.DoFinalize;
begin
  if Assigned(FOnFinalize) then FOnFinalize(Self);
end;

procedure TCustomDX3D.DoInitialize;
begin
  if Assigned(FOnInitialize) then FOnInitialize(Self);
end;

procedure TCustomDX3D.Finalize;
begin
  if FInitialized then
  begin
    try
      if FInitFlag then
      begin
        FInitFlag := False;
        DoFinalize;
      end;
    finally
      FInitialized := False;

      SetOptions(FOptions);

      FViewport := nil;
      FCamera := nil;
      FScene := nil;

      FD3DRMDevice := nil;
      FD3DRMDevice2 := nil;
      FD3DRMDevice3 := nil;
      FD3DDevice := nil;
      FD3DDevice2 := nil;
      FD3DDevice3 := nil;
      FD3DDevice7 := nil;
      FD3D := nil;
      FD3D2 := nil;
      FD3D3 := nil;
      FD3D7 := nil;

      FreeZBufferSurface(FSurface, FZBuffer);

      FSurface.Free; FSurface := nil;

      FD3DRM3 := nil;
      FD3DRM2 := nil;
      FD3DRM := nil;
    end;
  end;
end;

procedure TCustomDX3D.Initialize;
var
  ddsd: TDDSurfaceDesc;
  AOptions: TInitializeDirect3DOptions;
begin
  Finalize;
  try
    FInitialized := True;

    {  Make surface.  }
    FillChar(ddsd, SizeOf(ddsd), 0);
    ddsd.dwSize := SizeOf(ddsd);
    ddsd.dwFlags := DDSD_WIDTH or DDSD_HEIGHT or DDSD_CAPS;
    ddsd.dwWidth := Max(FSurfaceWidth, 1);
    ddsd.dwHeight := Max(FSurfaceHeight, 1);
    ddsd.ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN or DDSCAPS_3DDEVICE;
    if toSystemMemory in FNowOptions then
      ddsd.ddsCaps.dwCaps := ddsd.ddsCaps.dwCaps or DDSCAPS_SYSTEMMEMORY
    else
      ddsd.ddsCaps.dwCaps := ddsd.ddsCaps.dwCaps or DDSCAPS_VIDEOMEMORY;

    FSurface := TDirectDrawSurface.Create(FDXDraw.DDraw);
    if not FSurface.CreateSurface(ddsd) then
    begin
      ddsd.ddsCaps.dwCaps := ddsd.ddsCaps.dwCaps and (not DDSCAPS_VIDEOMEMORY) or DDSCAPS_SYSTEMMEMORY;
      if not FSurface.CreateSurface(ddsd) then
        raise EDX3DError.CreateFmt(SCannotMade, [SDirectDrawSurface]);
    end;

    AOptions := [];

    if toHardware in FNowOptions then AOptions := AOptions + [idoHardware];
    if toRetainedMode in FNowOptions then AOptions := AOptions + [idoRetainedMode];
    if toSelectDriver in FNowOptions then AOptions := AOptions + [idoSelectDriver];
    if toZBuffer in FNowOptions then AOptions := AOptions + [idoZBuffer];

    if doDirectX7Mode in FDXDraw.NowOptions then
    begin
      InitializeDirect3D7(FSurface, FZBuffer, FD3D7, FD3DDevice7, AOptions);
    end else
    begin
      InitializeDirect3D(FSurface, FZBuffer, FD3D, FD3D2, FD3D3, FD3DDevice, FD3DDevice2, FD3DDevice3,
        FD3DRM, FD3DRM2, FD3DRM3, FD3DRMDevice, FD3DRMDevice2, FD3DRMDevice3, FViewport, FScene, FCamera, AOptions);
    end;

    FNowOptions := [];

    if idoHardware in AOptions then FNowOptions := FNowOptions + [toHardware];
    if idoRetainedMode in AOptions then FNowOptions := FNowOptions + [toRetainedMode];
    if idoSelectDriver in AOptions then FNowOptions := FNowOptions + [toSelectDriver];
    if idoZBuffer in AOptions then FNowOptions := FNowOptions + [toZBuffer];
  except
    Finalize;
    raise;
  end;

  FInitFlag := True; DoInitialize;
end;

procedure TCustomDX3D.Render;
begin
  if FInitialized and (toRetainedMode in FNowOptions) then
  begin
    asm FInit end;
    FViewport.Clear;
    FViewport.Render(FScene);
    FD3DRMDevice.Update;
    asm FInit end;
  end;
end;

function TCustomDX3D.GetCanDraw: Boolean;
begin
  Result := Initialized and (Surface.IDDSurface <> nil) and
    (Surface.ISurface.IsLost = DD_OK);
end;

function TCustomDX3D.GetSurfaceHeight: Integer;
begin
  if FSurface.IDDSurface <> nil then
    Result := FSurface.Height
  else
    Result := FSurfaceHeight;
end;

function TCustomDX3D.GetSurfaceWidth: Integer;
begin
  if FSurface.IDDSurface <> nil then
    Result := FSurface.Width
  else
    Result := FSurfaceWidth;
end;

procedure TCustomDX3D.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    if FAutoSize and (DXDraw <> nil) then
      SetSize(DXDraw.SurfaceWidth, DXDraw.SurfaceHeight);
  end;
end;

procedure TCustomDX3D.SetOptions(Value: TDX3DOptions);
const
  DX3DOptions = [toRetainedMode, toSystemMemory, toHardware, toSelectDriver, toZBuffer];
  InitOptions = [toSystemMemory, toHardware, toSelectDriver, toZBuffer];
var
  OldOptions: TDX3DOptions;
begin
  FOptions := Value;

  if Initialized then
  begin
    OldOptions := FNowOptions;
    FNowOptions := FNowOptions * InitOptions + FOptions * (DX3DOptions - InitOptions);
  end else
  begin
    FNowOptions := FOptions;

    if (FDXDraw <> nil) and (doDirectX7Mode in FDXDraw.FNowOptions) then
      FNowOptions := FNowOptions - [toRetainedMode];
  end;
end;

procedure TCustomDX3D.SetSize(ASurfaceWidth, ASurfaceHeight: Integer);
begin
  if (ASurfaceWidth <> SurfaceWidth) or (ASurfaceHeight <> SurfaceHeight) then
  begin
    FSurfaceWidth := ASurfaceWidth;
    FSurfaceHeight := ASurfaceHeight;

    if Initialized then
      Initialize;
  end;
end;

procedure TCustomDX3D.SetSurfaceHeight(Value: Integer);
begin
  if ComponentState * [csReading, csLoading] = [] then
    SetSize(SurfaceWidth, Value)
  else
    FSurfaceHeight := Value;
end;

procedure TCustomDX3D.SetSurfaceWidth(Value: Integer);
begin
  if ComponentState * [csReading, csLoading] = [] then
    SetSize(Value, SurfaceHeight)
  else
    FSurfaceWidth := Value;
end;

procedure TCustomDX3D.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDXDraw = AComponent) then
    DXDraw := nil;
end;

procedure TCustomDX3D.DXDrawNotifyEvent(Sender: TCustomDXDraw;
  NotifyType: TDXDrawNotifyType);
var
  AOptions: TInitializeDirect3DOptions;
begin
  case NotifyType of
    dxntDestroying:
      begin
        DXDraw := nil;
      end;
    dxntInitializing:
      begin
        if (FDXDraw.FOptions * [do3D, doFullScreen] = [doFullScreen])
          and (FOptions * [toSystemMemory, toSelectDriver] = [toSelectDriver]) then
        begin
          AOptions := [];
          with FDXDraw do
          begin
            if doHardware in Options then AOptions := AOptions + [idoHardware];
            if doRetainedMode in Options then AOptions := AOptions + [idoRetainedMode];
            if doSelectDriver in Options then AOptions := AOptions + [idoSelectDriver];
            if doZBuffer in Options then AOptions := AOptions + [idoZBuffer];
          end;

          Direct3DInitializing_DXDraw(AOptions, FDXDraw);
        end;
      end;
    dxntInitialize:
      begin
        Initialize;
      end;
    dxntFinalize:
      begin
        Finalize;
      end;
    dxntRestore:
      begin
        FSurface.Restore;
        if FZBuffer <> nil then
          FZBuffer.Restore;
        FSurface.Palette := FDXDraw.Palette;
      end;
    dxntSetSurfaceSize:
      begin
        if AutoSize then
          SetSize(Sender.SurfaceWidth, Sender.SurfaceHeight);
      end;
  end;
end;

procedure TCustomDX3D.SetDXDraw(Value: TCustomDXDraw);
begin
  if FDXDraw <> Value then
  begin
    if FDXDraw <> nil then
      FDXDraw.UnRegisterNotifyEvent(DXDrawNotifyEvent);

    FDXDraw := Value;

    if FDXDraw <> nil then
      FDXDraw.RegisterNotifyEvent(DXDrawNotifyEvent);
  end;
end;

{$ENDIF}

{  TDirect3DTexture  }

constructor TDirect3DTexture.Create(Graphic: TGraphic; DXDraw: TComponent);
var
  i: Integer;
begin
  inherited Create;
  FDXDraw := DXDraw;
  FGraphic := Graphic;

  {  The palette is acquired.  }
  i := GetPaletteEntries(FGraphic.Palette, 0, 256, FPaletteEntries);
  case i of
    1..2: FBitCount := 1;
    3..16: FBitCount := 4;
    17..256: FBitCount := 8;
  else
    FBitCount := 24;
  end;

  if FDXDraw is TCustomDXDraw then
  begin
    with (FDXDraw as TCustomDXDraw) do
    begin
      if (not Initialized) or (not (do3D in NowOptions)) then
        raise EDirect3DTextureError.CreateFmt(SNotMade, [FDXDraw.ClassName]);
    end;
    FSurface := TDirectDrawSurface.Create((FDXDraw as TCustomDXDraw).Surface.DDraw);
    (FDXDraw as TCustomDXDraw).RegisterNotifyEvent(DXDrawNotifyEvent);
  end
  else
{$IFDEF DX3D_deprecated}
    if FDXDraw is TCustomDX3D then
    begin
      with (FDXDraw as TDX3D) do
      begin
        if not Initialized then
          raise EDirect3DTextureError.CreateFmt(SNotMade, [FDXDraw.ClassName]);
      end;

      FSurface := TDirectDrawSurface.Create((FDXDraw as TCustomDX3D).Surface.DDraw);
      (FDXDraw as TCustomDX3D).FDXDraw.RegisterNotifyEvent(DXDrawNotifyEvent);
    end else
{$ENDIF}
      raise EDirect3DTextureError.CreateFmt(SNotSupported, [FDXDraw.ClassName]);
end;

destructor TDirect3DTexture.Destroy;
begin
  if FDXDraw is TCustomDXDraw then
  begin
    (FDXDraw as TCustomDXDraw).UnRegisterNotifyEvent(DXDrawNotifyEvent);
  end
{$IFDEF DX3D_deprecated}
  else if FDXDraw is TCustomDX3D then
  begin
    (FDXDraw as TCustomDX3D).FDXDraw.UnRegisterNotifyEvent(DXDrawNotifyEvent);
  end
{$ENDIF};
  Clear;
  FSurface.Free;
  inherited Destroy;
end;

procedure TDirect3DTexture.Clear;
begin
  FHandle := 0;
  FTexture := nil;
  FSurface.IDDSurface := nil;
end;

function TDirect3DTexture.GetHandle: TD3DTextureHandle;
begin
  if FTexture = nil then
    Restore;
  Result := FHandle;
end;

function TDirect3DTexture.GetSurface: TDirectDrawSurface;
begin
  if FTexture = nil then
    Restore;
  Result := FSurface;
end;

function TDirect3DTexture.GetTexture: IDirect3DTexture;
begin
  if FTexture = nil then
    Restore;
  Result := FTexture;
end;

procedure TDirect3DTexture.SetTransparentColor(Value: TColor);
begin
  if FTransparentColor <> Value then
  begin
    FTransparentColor := Value;

    if FSurface <> nil then
      FSurface.TransparentColor := FSurface.ColorMatch(Value);
  end;
end;

procedure TDirect3DTexture.Restore;

  function EnumTextureFormatCallback(const ddsd: TDDSurfaceDesc;
    lParam: Pointer): HRESULT; stdcall;
  var
    tex: TDirect3DTexture;

    procedure UseThisFormat;
    begin
      tex.FFormat := ddsd;
      tex.FEnumFormatFlag := True;
    end;

  begin
    Result := DDENUMRET_OK;
    tex := lParam;

    if ddsd.ddpfPixelFormat.dwFlags and (DDPF_ALPHA or DDPF_ALPHAPIXELS) <> 0 then
      Exit;

    if not tex.FEnumFormatFlag then
    begin
      {  When called first,  this format is unconditionally selected.  }
      UseThisFormat;
    end else
    begin
      if (tex.FBitCount <= 8) and (ddsd.ddpfPixelFormat.dwRGBBitCount >= tex.FBitCount) and
        (ddsd.ddpfPixelFormat.dwRGBBitCount >= 8) and
        (ddsd.ddpfPixelFormat.dwFlags and DDPF_RGB <> 0) then
      begin
        if tex.FFormat.ddpfPixelFormat.dwRGBBitCount > ddsd.ddpfPixelFormat.dwRGBBitCount then
          UseThisFormat;
      end else
      begin
        if (tex.FFormat.ddpfPixelFormat.dwRGBBitCount > ddsd.ddpfPixelFormat.dwRGBBitCount) and
          (ddsd.ddpfPixelFormat.dwRGBBitCount > 8) and
          (ddsd.ddpfPixelFormat.dwFlags and DDPF_RGB <> 0) then
          UseThisFormat;
      end;
    end;
  end;

  function GetBitCount(i: Integer): Integer;
  var
    j: Integer;
  begin
    for j := 32 downto 1 do
      if (1 shl j) and i <> 0 then
      begin
        Result := j;
        if 1 shl j <> i then
          Dec(Result);
        Exit;
      end;
    Result := 0;
  end;

  function CreateHalftonePalette(R, G, B: Integer): TPaletteEntries;
  var
    i: Integer;
  begin
    for i := 0 to 255 do
      with Result[i] do
      begin
        peRed := ((i shr (G + B - 1)) and (1 shl R - 1)) * 255 div (1 shl R - 1);
        peGreen := ((i shr (B - 1)) and (1 shl G - 1)) * 255 div (1 shl G - 1);
        peBlue := ((i shr 0) and (1 shl B - 1)) * 255 div (1 shl B - 1);
        peFlags := 0;
      end;
  end;

var
  ddsd: TDDSurfaceDesc;
  Palette: TDirectDrawPalette;
  PaletteCaps: Integer;
  TempSurface: TDirectDrawSurface;
  Width2, Height2: Integer;
  D3DDevice: IDirect3DDevice;
  Hardware: Boolean;
  DDraw: TDirectDraw;
begin
  Clear;
  try
    DDraw := nil;
    Hardware := False;
    if FDXDraw is TCustomDXDraw then
    begin
      DDraw := (FDXDraw as TCustomDXDraw).DDraw;
      D3DDevice := (FDXDraw as TCustomDXDraw).D3DDevice;
      Hardware := doHardware in (FDXDraw as TCustomDXDraw).NowOptions;
    end
{$IFDEF DX3D_deprecated}
    else if FDXDraw is TCustomDX3D then
    begin
      DDraw := (FDXDraw as TCustomDX3D).Surface.DDraw;
      D3DDevice := (FDXDraw as TCustomDX3D).D3DDevice;
      Hardware := toHardware in (FDXDraw as TCustomDX3D).NowOptions;
    end
{$ENDIF};

    if (DDraw = nil) or (D3DDevice = nil) then Exit;

    {  The size of texture is arranged in the size of the square of two.  }
    Width2 := Max(1 shl GetBitCount(FGraphic.Width), 1);
    Height2 := Max(1 shl GetBitCount(FGraphic.Height), 1);

    {  Selection of format of texture.  }
    FEnumFormatFlag := False;
    D3DDevice.EnumTextureFormats(@EnumTextureFormatCallback, Self);

    TempSurface := TDirectDrawSurface.Create(FSurface.DDraw);
    try
      {  Make source surface.  }
      with ddsd do
      begin
        dwSize := SizeOf(ddsd);
        dwFlags := DDSD_CAPS or DDSD_HEIGHT or DDSD_WIDTH or DDSD_PIXELFORMAT;
        ddsCaps.dwCaps := DDSCAPS_TEXTURE or DDSCAPS_SYSTEMMEMORY;
        dwWidth := Width2;
        dwHeight := Height2;
        ddpfPixelFormat := FFormat.ddpfPixelFormat;
      end;

      if not TempSurface.CreateSurface(ddsd) then
        raise EDirect3DTextureError.CreateFmt(SCannotMade, [STexture]);

      {  Make surface.  }
      with ddsd do
      begin
        dwSize := SizeOf(ddsd);
        dwFlags := DDSD_CAPS or DDSD_HEIGHT or DDSD_WIDTH or DDSD_PIXELFORMAT;
        if Hardware then
          ddsCaps.dwCaps := DDSCAPS_TEXTURE or DDSCAPS_VIDEOMEMORY
        else
          ddsCaps.dwCaps := DDSCAPS_TEXTURE or DDSCAPS_SYSTEMMEMORY;
        ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_ALLOCONLOAD;
        dwWidth := Width2;
        dwHeight := Height2;
        ddpfPixelFormat := FFormat.ddpfPixelFormat;
      end;

      if not FSurface.CreateSurface(ddsd) then
        raise EDirect3DTextureError.CreateFmt(SCannotMade, [STexture]);

      {  Make palette.  }
      if ddsd.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED8 <> 0 then
      begin
        PaletteCaps := DDPCAPS_8BIT or DDPCAPS_ALLOW256;
        if FBitCount = 24 then
          CreateHalftonePalette(3, 3, 2);
      end else if ddsd.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED4 <> 0 then
      begin
        PaletteCaps := DDPCAPS_4BIT;
        if FBitCount = 24 then
          CreateHalftonePalette(1, 2, 1);
      end else if ddsd.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED1 <> 0 then
      begin
        PaletteCaps := DDPCAPS_1BIT;
        if FBitCount = 24 then
        begin
          FPaletteEntries[0] := RGBQuadToPaletteEntry(RGBQuad(0, 0, 0));
          FPaletteEntries[1] := RGBQuadToPaletteEntry(RGBQuad(255, 255, 255));
        end;
      end else
        PaletteCaps := 0;

      if PaletteCaps <> 0 then
      begin
        Palette := TDirectDrawPalette.Create(DDraw);
        try
          Palette.CreatePalette(PaletteCaps, FPaletteEntries);
          TempSurface.Palette := Palette;
          FSurface.Palette := Palette;
        finally
          Palette.Free;
        end;
      end;

      {  The image is loaded into source surface.  }
      with TempSurface.Canvas do
      begin
        StretchDraw(TempSurface.ClientRect, FGraphic);
        Release;
      end;

      {  Source surface is loaded into surface.  }
      FTexture := FSurface.ISurface as IDirect3DTexture;
      FTexture.Load(TempSurface.ISurface as IDirect3DTexture);
    finally
      TempSurface.Free;
    end;

    if FTexture.GetHandle(D3DDevice, FHandle) <> D3D_OK then
      raise EDirect3DTextureError.CreateFmt(SCannotMade, [STexture]);

    FSurface.TransparentColor := FSurface.ColorMatch(FTransparentColor);
  except
    Clear;
    raise;
  end;
end;

procedure TDirect3DTexture.DXDrawNotifyEvent(Sender: TCustomDXDraw;
  NotifyType: TDXDrawNotifyType);
begin
  case NotifyType of
    dxntInitializeSurface:
      begin
        Restore;
      end;
    dxntRestore:
      begin
        Restore;
      end;
  end;
end;

{  TDirect3DTexture2  }

constructor TDirect3DTexture2.Create(ADXDraw: TCustomDXDraw; Graphic: TObject;
  AutoFreeGraphic: Boolean);
begin
  inherited Create;
  FSrcImage := Graphic;
  FAutoFreeGraphic := AutoFreeGraphic;
  FNeedLoadTexture := True;

  if FSrcImage is TDXTextureImage then
    FImage := TDXTextureImage(FSrcImage)
  else if FSrcImage is TDIB then
    SetDIB(TDIB(FSrcImage))
  else if FSrcImage is TGraphic then
  begin
    FSrcImage := TDIB.Create;
    try
      TDIB(FSrcImage).Assign(TGraphic(Graphic));
      SetDIB(TDIB(FSrcImage));
    finally
      if FAutoFreeGraphic then
        Graphic.Free;
      FAutoFreeGraphic := True;
    end;
  end else
    if FSrcImage is TPicture then
    begin
      FSrcImage := TDIB.Create;
      try
        TDIB(FSrcImage).Assign(TPicture(Graphic).Graphic);
        SetDIB(TDIB(FSrcImage));
      finally
        if FAutoFreeGraphic then
          Graphic.Free;
        FAutoFreeGraphic := True;
      end;
    end else
      raise Exception.CreateFmt(SCannotLoadGraphic, [Graphic.ClassName]);

  FMipmap := FImage.SubGroupImageCount[DXTextureImageGroupType_Mipmap] > 0;

  FTransparent := FImage.Transparent;
  case FImage.ImageType of
    DXTextureImageType_PaletteIndexedColor:
      begin
        FTransparentColor := PaletteIndex(dxtDecodeChannel(FImage.idx_index, FImage.TransparentColor));
      end;
    DXTextureImageType_RGBColor:
      begin
        FTransparentColor := RGB(dxtDecodeChannel(FImage.rgb_red, FImage.TransparentColor),
          dxtDecodeChannel(FImage.rgb_green, FImage.TransparentColor),
          dxtDecodeChannel(FImage.rgb_blue, FImage.TransparentColor));
      end;
  end;

  SetDXDraw(ADXDraw);
end;

constructor TDirect3DTexture2.CreateFromFile(ADXDraw: TCustomDXDraw; const FileName: string);
var
  Image: TObject;
begin
  Image := nil;
  try
    {  TDXTextureImage  }
    Image := TDXTextureImage.Create;
    try
      TDXTextureImage(Image).LoadFromFile(FileName);
    except
      Image.Free;
      Image := nil;
    end;

    {  TDIB  }
    if Image = nil then
    begin
      Image := TDIB.Create;
      try
        TDIB(Image).LoadFromFile(FileName);
      except
        Image.Free;
        Image := nil;
      end;
    end;

    {  TPicture  }
    if Image = nil then
    begin
      Image := TPicture.Create;
      try
        TPicture(Image).LoadFromFile(FileName);
      except
        Image.Free;
        Image := nil;
        raise;
      end;
    end;
  except
    Image.Free;
    raise;
  end;

  Create(ADXDraw, Image, True);
end;

constructor TDirect3DTexture2.CreateVideoTexture(ADXDraw: TCustomDXDraw);
begin
  inherited Create;
  SetDXDraw(ADXDraw);
end;

destructor TDirect3DTexture2.Destroy;
begin
  Finalize;

  SetDXDraw(nil);

  if FAutoFreeGraphic then
    FSrcImage.Free;
  FImage2.Free;
  inherited Destroy;
end;

procedure TDirect3DTexture2.DXDrawNotifyEvent(Sender: TCustomDXDraw;
  NotifyType: TDXDrawNotifyType);
begin
  case NotifyType of
    dxntDestroying:
      begin
        SetDXDraw(nil);
      end;
    dxntInitializeSurface:
      begin
        Initialize;
      end;
    dxntFinalizeSurface:
      begin
        Finalize;
      end;
    dxntRestore:
      begin
        Load;
      end;
  end;
end;

procedure TDirect3DTexture2.SetDXDraw(ADXDraw: TCustomDXDraw);
begin
  if FDXDraw <> ADXDraw then
  begin
    if FDXDraw <> nil then
      FDXDraw.UnRegisterNotifyEvent(DXDrawNotifyEvent);

    FDXDraw := ADXDraw;

    if FDXDraw <> nil then
      FDXDraw.RegisterNotifyEvent(DXDrawNotifyEvent);
  end;
end;

procedure TDirect3DTexture2.DoRestoreSurface;
begin
  if Assigned(FOnRestoreSurface) then
    FOnRestoreSurface(Self);
end;

procedure TDirect3DTexture2.SetDIB(DIB: TDIB);
var
  i: Integer;
begin
  if FImage2 = nil then
    FImage2 := TDXTextureImage.Create;

  if DIB.BitCount <= 8 then
  begin
    FImage2.SetImage(DXTextureImageType_PaletteIndexedColor, DIB.Width, DIB.Height, DIB.BitCount,
      DIB.WidthBytes, DIB.NextLine, DIB.PBits, DIB.TopPBits, DIB.Size, False);

    FImage2.idx_index := dxtMakeChannel((1 shl DIB.BitCount) - 1, True);
    for i := 0 to 255 do
      FImage2.idx_palette[i] := RGBQuadToPaletteEntry(DIB.ColorTable[i]);
  end else
  begin
    FImage2.SetImage(DXTextureImageType_RGBColor, DIB.Width, DIB.Height, DIB.BitCount,
      DIB.WidthBytes, DIB.NextLine, DIB.PBits, DIB.TopPBits, DIB.Size, False);

    FImage2.rgb_red := dxtMakeChannel(DIB.NowPixelFormat.RBitMask, False);
    FImage2.rgb_green := dxtMakeChannel(DIB.NowPixelFormat.GBitMask, False);
    FImage2.rgb_blue := dxtMakeChannel(DIB.NowPixelFormat.BBitMask, False);

    i := DIB.NowPixelFormat.RBitCount + DIB.NowPixelFormat.GBitCount + DIB.NowPixelFormat.BBitCount;
    if i < DIB.BitCount then
      FImage2.rgb_alpha := dxtMakeChannel(((1 shl (DIB.BitCount - i)) - 1) shl i, False);
  end;

  FImage := FImage2;
end;

function TDirect3DTexture2.GetIsMipmap: Boolean;
begin
  if FSurface <> nil then
    Result := FUseMipmap
  else
    Result := FMipmap;
end;

function TDirect3DTexture2.GetSurface: TDirectDrawSurface;
begin
  Result := FSurface;
  if (Result <> nil) and FNeedLoadTexture then
    Load;
end;

function TDirect3DTexture2.GetTransparent: Boolean;
begin
  if FSurface <> nil then
    Result := FUseColorKey
  else
    Result := FTransparent;
end;

procedure TDirect3DTexture2.SetTransparent(Value: Boolean);
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    if FSurface <> nil then
      SetColorKey;
  end;
end;

procedure TDirect3DTexture2.SetTransparentColor(Value: TColorRef);
begin
  if FTransparentColor <> Value then
  begin
    FTransparentColor := Value;
    if (FSurface <> nil) and FTransparent then
      SetColorKey;
  end;
end;

procedure TDirect3DTexture2.Finalize;
begin
  FSurface.Free; FSurface := nil;

  FUseColorKey := False;
  FUseMipmap := False;
  FNeedLoadTexture := False;
end;

const
  DDPF_PALETTEINDEXED = DDPF_PALETTEINDEXED1 or DDPF_PALETTEINDEXED2 or
    DDPF_PALETTEINDEXED4 or DDPF_PALETTEINDEXED8;

procedure TDirect3DTexture2.Initialize;

  function GetBitCount(i: Integer): Integer;
  begin
    Result := 31;
    while (i >= 0) and (((1 shl Result) and i) = 0) do Dec(Result);
  end;

  function GetMaskBitCount(b: Integer): Integer;
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

  function GetPaletteBitCount(const ddpfPixelFormat: TDDPixelFormat): Integer;
  begin
    if ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED8 <> 0 then
      Result := 8
    else if ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED4 <> 0 then
      Result := 4
    else if ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED2 <> 0 then
      Result := 2
    else if ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED1 <> 0 then
      Result := 1
    else
      Result := 0;
  end;

  function EnumTextureFormatCallback(const lpDDPixFmt: TDDPixelFormat;
    lParam: Pointer): HRESULT; stdcall;
  var
    tex: TDirect3DTexture2;

    procedure UseThisFormat;
    begin
      tex.FTextureFormat.ddpfPixelFormat := lpDDPixFmt;
      tex.FEnumTextureFormatFlag := True;
    end;

  var
    rgb_red, rgb_green, rgb_blue, rgb_alpha, idx_index: Integer;
    sum1, sum2: Integer;
  begin
    Result := DDENUMRET_OK;
    tex := lParam;

    {  Form acquisition of source image  }
    rgb_red := 0;
    rgb_green := 0;
    rgb_blue := 0;
    rgb_alpha := 0;
    idx_index := 0;

    case tex.FImage.ImageType of
      DXTextureImageType_RGBColor:
        begin
          {  RGB Color  }
          rgb_red := tex.FImage.rgb_red.bitcount;
          rgb_green := tex.FImage.rgb_green.bitcount;
          rgb_blue := tex.FImage.rgb_blue.bitcount;
          rgb_alpha := tex.FImage.rgb_alpha.bitcount;
          idx_index := 8;
        end;
      DXTextureImageType_PaletteIndexedColor:
        begin
          {  Index Color  }
          rgb_red := 8;
          rgb_green := 8;
          rgb_blue := 8;
          rgb_alpha := tex.FImage.idx_alpha.bitcount;
          idx_index := tex.FImage.idx_index.bitcount;
        end;
    end;

    {  The texture examines whether this pixel format can be used.  }
    if lpDDPixFmt.dwFlags and DDPF_RGB = 0 then Exit;

    case tex.FImage.ImageType of
      DXTextureImageType_RGBColor:
        begin
          if lpDDPixFmt.dwFlags and DDPF_PALETTEINDEXED <> 0 then Exit;
        end;
      DXTextureImageType_PaletteIndexedColor:
        begin
          if (lpDDPixFmt.dwFlags and DDPF_PALETTEINDEXED <> 0) and
            (GetPaletteBitCount(lpDDPixFmt) < idx_index) then Exit;
        end;
    end;

    {  The pixel format which can be used is selected carefully.  }
    if tex.FEnumTextureFormatFlag then
    begin
      if lpDDPixFmt.dwFlags and DDPF_PALETTEINDEXED <> 0 then
      begin
        {  Bit count check  }
        if Abs(Integer(lpDDPixFmt.dwRGBBitCount) - idx_index) >
          Abs(Integer(tex.FTextureFormat.ddpfPixelFormat.dwRGBBitCount) - idx_index) then Exit;

        {  Alpha channel check  }
        if rgb_alpha > 0 then Exit;
      end else
        if lpDDPixFmt.dwFlags and DDPF_RGB <> 0 then
        begin
        {  The alpha channel is indispensable.  }
          if (rgb_alpha > 0) and (tex.FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_ALPHAPIXELS = 0) and
            (lpDDPixFmt.dwFlags and DDPF_ALPHAPIXELS <> 0) then
          begin
            UseThisFormat;
            Exit;
          end;

        {  Alpha channel check  }
          if (rgb_alpha > 0) and (tex.FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_ALPHAPIXELS <> 0) and
            (lpDDPixFmt.dwFlags and DDPF_ALPHAPIXELS = 0) then
          begin
            Exit;
          end;

        {  Bit count check  }
          if tex.FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED = 0 then
          begin
            sum1 := Sqr(GetMaskBitCount(lpDDPixFmt.dwRBitMask) - rgb_red) +
              Sqr(GetMaskBitCount(lpDDPixFmt.dwGBitMask) - rgb_green) +
              Sqr(GetMaskBitCount(lpDDPixFmt.dwBBitMask) - rgb_blue) +
              Sqr(GetMaskBitCount(lpDDPixFmt.dwRGBAlphaBitMask) - rgb_alpha);

            sum2 := Sqr(GetMaskBitCount(tex.FTextureFormat.ddpfPixelFormat.dwRBitMask) - rgb_red) +
              Sqr(GetMaskBitCount(tex.FTextureFormat.ddpfPixelFormat.dwGBitMask) - rgb_green) +
              Sqr(GetMaskBitCount(tex.FTextureFormat.ddpfPixelFormat.dwBBitMask) - rgb_blue) +
              Sqr(GetMaskBitCount(tex.FTextureFormat.ddpfPixelFormat.dwRGBAlphaBitMask) - rgb_alpha);

            if sum1 > sum2 then Exit;
          end;
        end;
    end;

    UseThisFormat;
  end;

var
  Width, Height: Integer;
  PaletteCaps: DWORD;
  Palette: IDirectDrawPalette;
  TempD3DDevDesc: TD3DDeviceDesc;
  D3DDevDesc7: TD3DDeviceDesc7;
  TempSurface: IDirectDrawSurface4;
begin
  Finalize;
  try
    if FDXDraw.D3DDevice7 <> nil then
    begin
      FDXDraw.D3DDevice7.GetCaps(D3DDevDesc7);
      FD3DDevDesc.dpcLineCaps.dwTextureCaps := D3DDevDesc7.dpcLineCaps.dwTextureCaps;
      FD3DDevDesc.dpcTriCaps.dwTextureCaps := D3DDevDesc7.dpcTriCaps.dwTextureCaps;
      FD3DDevDesc.dwMinTextureWidth := D3DDevDesc7.dwMinTextureWidth;
      FD3DDevDesc.dwMaxTextureWidth := D3DDevDesc7.dwMaxTextureWidth;
    end else
    begin
      FD3DDevDesc.dwSize := SizeOf(FD3DDevDesc);
      TempD3DDevDesc.dwSize := SizeOf(TempD3DDevDesc);
      FDXDraw.D3DDevice3.GetCaps(FD3DDevDesc, TempD3DDevDesc);
    end;

    if FImage <> nil then
    begin
      {  Size adjustment of texture  }
      if FD3DDevDesc.dpcTriCaps.dwTextureCaps and D3DPTEXTURECAPS_POW2 <> 0 then
      begin
        {  The size of the texture is only Sqr(n).  }
        Width := Max(1 shl GetBitCount(FImage.Width), 1);
        Height := Max(1 shl GetBitCount(FImage.Height), 1);
      end else
      begin
        Width := FImage.Width;
        Height := FImage.Height;
      end;

      if FD3DDevDesc.dpcTriCaps.dwTextureCaps and D3DPTEXTURECAPS_SQUAREONLY <> 0 then
      begin
        {  The size of the texture is only a square.  }
        if Width < Height then Width := Height;
        Height := Width;
      end;

      if FD3DDevDesc.dwMinTextureWidth > 0 then
        Width := Max(Width, FD3DDevDesc.dwMinTextureWidth);

      if FD3DDevDesc.dwMaxTextureWidth > 0 then
        Width := Min(Width, FD3DDevDesc.dwMaxTextureWidth);

      if FD3DDevDesc.dwMinTextureHeight > 0 then
        Height := Max(Height, FD3DDevDesc.dwMinTextureHeight);

      if FD3DDevDesc.dwMaxTextureHeight > 0 then
        Height := Min(Height, FD3DDevDesc.dwMaxTextureHeight);

      {  Pixel format selection  }
      FEnumTextureFormatFlag := False;
      if FDXDraw.D3DDevice7 <> nil then
        FDXDraw.D3DDevice7.EnumTextureFormats(@EnumTextureFormatCallback, Self)
      else
        FDXDraw.D3DDevice3.EnumTextureFormats(@EnumTextureFormatCallback, Self);

      if not FEnumTextureFormatFlag then
        raise EDirect3DTextureError.CreateFmt(SCannotInitialized, [STexture]);

      {  Is Mipmap surface used ?  }
      FUseMipmap := FMipmap and (FTextureFormat.ddpfPixelFormat.dwRGBBitCount > 8) and
        (FImage.SubGroupImageCount[DXTextureImageGroupType_Mipmap] > 0) and (FDXDraw.DDraw.DriverCaps.ddsCaps.dwCaps and DDSCAPS_MIPMAP <> 0);

      {  Surface form setting  }
      with FTextureFormat do
      begin
        dwSize := SizeOf(FTextureFormat);
        dwFlags := DDSD_CAPS or DDSD_HEIGHT or DDSD_WIDTH or DDSD_PIXELFORMAT;
        ddsCaps.dwCaps := DDSCAPS_TEXTURE;
        ddsCaps.dwCaps2 := 0;
        dwWidth := Width;
        dwHeight := Height;

        if doHardware in FDXDraw.NowOptions then
          ddsCaps.dwCaps2 := ddsCaps.dwCaps2 or DDSCAPS2_TEXTUREMANAGE
        else
          ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_SYSTEMMEMORY;

        if FUseMipmap then
        begin
          dwFlags := dwFlags or DDSD_MIPMAPCOUNT;
          ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_MIPMAP or DDSCAPS_COMPLEX;
          dwMipMapCount := FImage.SubGroupImageCount[DXTextureImageGroupType_Mipmap];
        end;
      end;
    end;

    FSurface := TDirectDrawSurface.Create(FDXDraw.DDraw);
    FSurface.DDraw.DXResult := FSurface.DDraw.IDraw4.CreateSurface(FTextureFormat, TempSurface, nil);
    if FSurface.DDraw.DXResult <> DD_OK then
      raise EDirect3DTextureError.CreateFmt(SCannotInitialized, [STexture]);
    FSurface.IDDSurface4 := TempSurface;

    {  Palette making  }
    if (FImage <> nil) and (FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED <> 0) then
    begin
      if FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED8 <> 0 then
        PaletteCaps := DDPCAPS_8BIT or DDPCAPS_ALLOW256
      else if FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED4 <> 0 then
        PaletteCaps := DDPCAPS_4BIT
      else if FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED2 <> 0 then
        PaletteCaps := DDPCAPS_2BIT
      else if FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED1 <> 0 then
        PaletteCaps := DDPCAPS_1BIT
      else
        PaletteCaps := 0;

      if PaletteCaps <> 0 then
      begin
        if FDXDraw.DDraw.IDraw.CreatePalette(PaletteCaps, @FImage.idx_palette, Palette, nil) <> 0 then
          Exit;

        FSurface.ISurface.SetPalette(Palette);
      end;
    end;

    FNeedLoadTexture := True;
  except
    Finalize;
    raise;
  end;
end;

procedure TDirect3DTexture2.Load;
const
  MipmapCaps: TDDSCaps2 = (dwCaps: DDSCAPS_TEXTURE or DDSCAPS_MIPMAP);
var
  CurSurface, NextSurface: IDirectDrawSurface4;
  Index: Integer;
  SrcImage: TDXTextureImage;
begin
  if FSurface = nil then
    Initialize;

  FNeedLoadTexture := False;
  if FSurface.ISurface.IsLost = DDERR_SURFACELOST then
    FSurface.Restore;

  {  Color key setting.  }
  SetColorKey;

  {  Image loading into surface.  }
  if FImage <> nil then
  begin
    if FSrcImage is TDIB then
      SetDIB(TDIB(FSrcImage));

    CurSurface := FSurface.ISurface4;
    Index := 0;
    while CurSurface <> nil do
    begin
      SrcImage := FImage;
      if Index > 0 then
      begin
        if Index - 1 >= FImage.SubGroupImageCount[DXTextureImageGroupType_Mipmap] then
          Break;
        SrcImage := FImage.SubGroupImages[DXTextureImageGroupType_Mipmap, Index - 1];
      end;

      LoadSubTexture(CurSurface, SrcImage);

      if CurSurface.GetAttachedSurface(MipmapCaps, NextSurface) = 0 then
        CurSurface := NextSurface
      else
        CurSurface := nil;

      Inc(Index);
    end;
  end else
    DoRestoreSurface;
end;

procedure TDirect3DTexture2.SetColorKey;
var
  ck: TDDColorKey;
begin
  FUseColorKey := False;

  if (FSurface <> nil) and FTransparent and (FD3DDevDesc.dpcTriCaps.dwTextureCaps and D3DPTEXTURECAPS_TRANSPARENCY <> 0) then
  begin
    FillChar(ck, SizeOf(ck), 0);
    if FSurface.SurfaceDesc.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED <> 0 then
    begin
      if FTransparentColor shr 24 = $01 then
      begin
        {  Palette index  }
        ck.dwColorSpaceLowValue := FTransparentColor and $FF;
      end else
        if FImage <> nil then
        begin
        {  RGB value  }
          ck.dwColorSpaceLowValue := FImage.PaletteIndex(GetRValue(FTransparentColor), GetGValue(FTransparentColor), GetBValue(FTransparentColor));
        end else
          Exit;
    end else
    begin
      if (FImage <> nil) and (FImage.ImageType = DXTextureImageType_PaletteIndexedColor) and (FTransparentColor shr 24 = $01) then
      begin
        {  Palette index  }
        ck.dwColorSpaceLowValue :=
          dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwRBitMask, False), FImage.idx_palette[FTransparentColor and $FF].peRed) or
          dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwGBitMask, False), FImage.idx_palette[FTransparentColor and $FF].peGreen) or
          dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwBBitMask, False), FImage.idx_palette[FTransparentColor and $FF].peBlue);
      end else
        if FTransparentColor shr 24 = $00 then
        begin
        {  RGB value  }
          ck.dwColorSpaceLowValue :=
            dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwRBitMask, False), GetRValue(FTransparentColor)) or
            dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwGBitMask, False), GetGValue(FTransparentColor)) or
            dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwBBitMask, False), GetBValue(FTransparentColor));
        end else
          Exit;
    end;

    ck.dwColorSpaceHighValue := ck.dwColorSpaceLowValue;
    FSurface.ISurface.SetColorKey(DDCKEY_SRCBLT, @ck);

    FUseColorKey := True;
  end;
end;

procedure TDirect3DTexture2.LoadSubTexture(Dest: IDirectDrawSurface4; SrcImage: TDXTextureImage);
const
  Mask1: array[0..7] of DWORD = (1, 2, 4, 8, 16, 32, 64, 128);
  Mask2: array[0..3] of DWORD = (3, 12, 48, 192);
  Mask4: array[0..1] of DWORD = ($0F, $F0);
  Shift1: array[0..7] of DWORD = (0, 1, 2, 3, 4, 5, 6, 7);
  Shift2: array[0..3] of DWORD = (0, 2, 4, 6);
  Shift4: array[0..1] of DWORD = (0, 4);

  procedure SetPixel(const ddsd: TDDSurfaceDesc2; x, y: Integer; c: DWORD);
  begin
    case ddsd.ddpfPixelFormat.dwRGBBitCount of
      1: PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * y + x div 8)^ :=
        (PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * y + x div 8)^ and (not Mask1[x mod 8])) or (c shl Shift1[x mod 8]);
      2: PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * y + x div 4)^ :=
        (PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * y + x div 4)^ and (not Mask2[x mod 4])) or (c shl Shift2[x mod 4]);
      4: PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * y + x div 2)^ :=
        (PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * y + x div 2)^ and (not Mask4[x mod 2])) or (c shl Shift4[x mod 2]);
      8: PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * y + x)^ := c;
      16: PWord(Integer(ddsd.lpSurface) + ddsd.lPitch * y + x * 2)^ := c;
      24: begin
          PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * y + x * 3)^ := c shr 0;
          PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * y + x * 3 + 1)^ := c shr 8;
          PByte(Integer(ddsd.lpSurface) + ddsd.lPitch * y + x * 3 + 2)^ := c shr 16;
        end;
      32: PDWORD(Integer(ddsd.lpSurface) + ddsd.lPitch * y + x * 4)^ := c;
    end;
  end;

  procedure LoadTexture_IndexToIndex;
  var
    ddsd: TDDSurfaceDesc2;
    x, y: Integer;
  begin
    ddsd.dwSize := SizeOf(ddsd);
    if Dest.Lock(nil, ddsd, DDLOCK_WAIT, 0) = 0 then
    begin
      try
        if (SrcImage.idx_index.Mask = DWORD(1 shl ddsd.ddpfPixelFormat.dwRGBBitCount) - 1) and (SrcImage.idx_alpha.Mask = 0) and
          (SrcImage.BitCount = Integer(ddsd.ddpfPixelFormat.dwRGBBitCount)) and (not SrcImage.PackedPixelOrder) then
        begin
          for y := 0 to ddsd.dwHeight - 1 do
            Move(SrcImage.ScanLine[y]^, Pointer(Integer(ddsd.lpSurface) + ddsd.lPitch * y)^, (Integer(ddsd.dwWidth) * SrcImage.BitCount + 7) div 8);
        end else
        begin
          for y := 0 to ddsd.dwHeight - 1 do
          begin
            for x := 0 to ddsd.dwWidth - 1 do
              SetPixel(ddsd, x, y, dxtDecodeChannel(SrcImage.idx_index, SrcImage.Pixels[x, y]));
          end;
        end;
      finally
        Dest.UnLock(ddsd.lpSurface);
      end;
    end;
  end;

  procedure LoadTexture_IndexToRGB;
  var
    ddsd: TDDSurfaceDesc2;
    x, y: Integer;
    c, cIdx, cA: DWORD;
    dest_red_fmt, dest_green_fmt, dest_blue_fmt, dest_alpha_fmt: TDXTextureImageChannel;
  begin
    ddsd.dwSize := SizeOf(ddsd);
    if Dest.Lock(nil, ddsd, DDLOCK_WAIT, 0) = 0 then
    begin
      try
        dest_red_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwRBitMask, False);
        dest_green_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwGBitMask, False);
        dest_blue_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwBBitMask, False);
        dest_alpha_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwRGBAlphaBitMask, False);

        if SrcImage.idx_alpha.mask <> 0 then
        begin
          for y := 0 to ddsd.dwHeight - 1 do
            for x := 0 to ddsd.dwWidth - 1 do
            begin
              c := SrcImage.Pixels[x, y];
              cIdx := dxtDecodeChannel(SrcImage.idx_index, c);

              c := dxtEncodeChannel(dest_red_fmt, SrcImage.idx_palette[cIdx].peRed) or
                dxtEncodeChannel(dest_green_fmt, SrcImage.idx_palette[cIdx].peGreen) or
                dxtEncodeChannel(dest_blue_fmt, SrcImage.idx_palette[cIdx].peBlue) or
                dxtEncodeChannel(dest_alpha_fmt, dxtDecodeChannel(SrcImage.idx_alpha, c));

              SetPixel(ddsd, x, y, c);
            end;
        end else
        begin
          cA := dxtEncodeChannel(dest_alpha_fmt, 255);

          for y := 0 to ddsd.dwHeight - 1 do
            for x := 0 to ddsd.dwWidth - 1 do
            begin
              c := SrcImage.Pixels[x, y];
              cIdx := dxtDecodeChannel(SrcImage.idx_index, c);

              c := dxtEncodeChannel(dest_red_fmt, SrcImage.idx_palette[cIdx].peRed) or
                dxtEncodeChannel(dest_green_fmt, SrcImage.idx_palette[cIdx].peGreen) or
                dxtEncodeChannel(dest_blue_fmt, SrcImage.idx_palette[cIdx].peBlue) or cA;

              SetPixel(ddsd, x, y, c);
            end;
        end;
      finally
        Dest.UnLock(ddsd.lpSurface);
      end;
    end;
  end;

  procedure LoadTexture_RGBToRGB;
  var
    ddsd: TDDSurfaceDesc2;
    x, y: Integer;
    c, cA: DWORD;
    dest_red_fmt, dest_green_fmt, dest_blue_fmt, dest_alpha_fmt: TDXTextureImageChannel;
  begin
    ddsd.dwSize := SizeOf(ddsd);
    if Dest.Lock(nil, ddsd, DDLOCK_WAIT, 0) = 0 then
    begin
      try
        dest_red_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwRBitMask, False);
        dest_green_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwGBitMask, False);
        dest_blue_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwBBitMask, False);
        dest_alpha_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwRGBAlphaBitMask, False);

        if (dest_red_fmt.Mask = SrcImage.rgb_red.Mask) and (dest_green_fmt.Mask = SrcImage.rgb_green.Mask) and
          (dest_blue_fmt.Mask = SrcImage.rgb_blue.Mask) and (dest_alpha_fmt.Mask = SrcImage.rgb_alpha.Mask) and
          (Integer(ddsd.ddpfPixelFormat.dwRGBBitCount) = SrcImage.BitCount) and (not SrcImage.PackedPixelOrder) then
        begin
          for y := 0 to ddsd.dwHeight - 1 do
            Move(SrcImage.ScanLine[y]^, Pointer(Integer(ddsd.lpSurface) + ddsd.lPitch * y)^, (Integer(ddsd.dwWidth) * SrcImage.BitCount + 7) div 8);
        end else
          if SrcImage.rgb_alpha.mask <> 0 then
          begin
            for y := 0 to ddsd.dwHeight - 1 do
              for x := 0 to ddsd.dwWidth - 1 do
              begin
                c := SrcImage.Pixels[x, y];

                c := dxtEncodeChannel(dest_red_fmt, dxtDecodeChannel(SrcImage.rgb_red, c)) or
                  dxtEncodeChannel(dest_green_fmt, dxtDecodeChannel(SrcImage.rgb_green, c)) or
                  dxtEncodeChannel(dest_blue_fmt, dxtDecodeChannel(SrcImage.rgb_blue, c)) or
                  dxtEncodeChannel(dest_alpha_fmt, dxtDecodeChannel(SrcImage.rgb_alpha, c));

                SetPixel(ddsd, x, y, c);
              end;
          end else
          begin
            cA := dxtEncodeChannel(dest_alpha_fmt, 255);

            for y := 0 to ddsd.dwHeight - 1 do
              for x := 0 to ddsd.dwWidth - 1 do
              begin
                c := SrcImage.Pixels[x, y];

                c := dxtEncodeChannel(dest_red_fmt, dxtDecodeChannel(SrcImage.rgb_red, c)) or
                  dxtEncodeChannel(dest_green_fmt, dxtDecodeChannel(SrcImage.rgb_green, c)) or
                  dxtEncodeChannel(dest_blue_fmt, dxtDecodeChannel(SrcImage.rgb_blue, c)) or cA;

                SetPixel(ddsd, x, y, c);
              end;
          end;
      finally
        Dest.UnLock(ddsd.lpSurface);
      end;
    end;
  end;

var
  SurfaceDesc: TDDSurfaceDesc2;
begin
  SurfaceDesc.dwSize := SizeOf(SurfaceDesc);
  Dest.GetSurfaceDesc(SurfaceDesc);

  if SurfaceDesc.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED <> 0 then
  begin
    case SrcImage.ImageType of
      DXTextureImageType_PaletteIndexedColor: LoadTexture_IndexToIndex;
      DXTextureImageType_RGBColor: ;
    end;
  end else if SurfaceDesc.ddpfPixelFormat.dwFlags and DDPF_RGB <> 0 then
  begin
    case SrcImage.ImageType of
      DXTextureImageType_PaletteIndexedColor: LoadTexture_IndexToRGB;
      DXTextureImageType_RGBColor: LoadTexture_RGBToRGB;
    end;
  end;
end;

{ Support function }

function GetWidthBytes(Width, BitCount: Integer): Integer;
begin
  Result := (((Width * BitCount) + 31) div 32) * 4;
end;

function dxtEncodeChannel(const Channel: TDXTextureImageChannel; c: DWORD): DWORD;
begin
  Result := ((c shl Channel._rshift) shr Channel._lshift) and Channel.Mask;
end;

function dxtDecodeChannel(const Channel: TDXTextureImageChannel; c: DWORD): DWORD;
begin
  Result := ((c and Channel.Mask) shr Channel._rshift) shl Channel._lshift;
  Result := Result or (Result shr Channel._BitCount2);
end;

function dxtMakeChannel(Mask: DWORD; indexed: Boolean): TDXTextureImageChannel;

  function GetMaskBitCount(b: Integer): Integer;
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

  function GetBitCount2(b: Integer): Integer;
  begin
    Result := 0;
    while (Result < 31) and (((1 shl Result) and b) = 0) do Inc(Result);
  end;

begin
  Result.BitCount := GetMaskBitCount(Mask);
  Result.Mask := Mask;

  if indexed then
  begin
    Result._rshift := GetBitCount2(Mask);
    Result._lshift := 0;
    Result._Mask2 := 1 shl Result.BitCount - 1;
    Result._BitCount2 := 0;
  end else
  begin
    Result._rshift := GetBitCount2(Mask) - (8 - Result.BitCount);
    if Result._rshift < 0 then
    begin
      Result._lshift := -Result._rshift;
      Result._rshift := 0;
    end else
      Result._lshift := 0;
    Result._Mask2 := (1 shl Result.BitCount - 1) shl (8 - Result.BitCount);
    Result._BitCount2 := 8 - Result.BitCount;
  end;
end;

{  TDXTextureImage  }

var
  _DXTextureImageLoadFuncList: TList;

procedure DXTextureImage_LoadDXTextureImageFunc(Stream: TStream; Image: TDXTextureImage); forward;
procedure DXTextureImage_LoadBitmapFunc(Stream: TStream; Image: TDXTextureImage); forward;

function DXTextureImageLoadFuncList: TList;
begin
  if _DXTextureImageLoadFuncList = nil then
  begin
    _DXTextureImageLoadFuncList := TList.Create;
    _DXTextureImageLoadFuncList.Add(@DXTextureImage_LoadDXTextureImageFunc);
    _DXTextureImageLoadFuncList.Add(@DXTextureImage_LoadBitmapFunc);
  end;
  Result := _DXTextureImageLoadFuncList;
end;

class procedure TDXTextureImage.RegisterLoadFunc(LoadFunc: TDXTextureImageLoadFunc);
begin
  if DXTextureImageLoadFuncList.IndexOf(@LoadFunc) = -1 then
    DXTextureImageLoadFuncList.Add(@LoadFunc);
end;

class procedure TDXTextureImage.UnRegisterLoadFunc(LoadFunc: TDXTextureImageLoadFunc);
begin
  DXTextureImageLoadFuncList.Remove(@LoadFunc);
end;

constructor TDXTextureImage.Create;
begin
  inherited Create;
  FSubImage := TList.Create;
end;

constructor TDXTextureImage.CreateSub(AOwner: TDXTextureImage);
begin
  Create;

  FOwner := AOwner;
  try
    FOwner.FSubImage.Add(Self);
  except
    FOwner := nil;
    raise;
  end;
end;

destructor TDXTextureImage.Destroy;
begin
  Clear;
  FSubImage.Free;
  if FOwner <> nil then
    FOwner.FSubImage.Remove(Self);
  inherited Destroy;
end;

procedure TDXTextureImage.DoSaveProgress(Progress, ProgressCount: Integer);
begin
  if Assigned(FOnSaveProgress) then
    FOnSaveProgress(Self, Progress, ProgressCount);
end;

procedure TDXTextureImage.Assign(Source: TDXTextureImage);
var
  y: Integer;
begin
  SetSize(Source.ImageType, Source.Width, Source.Height, Source.BitCount, Source.WidthBytes);

  idx_index := Source.idx_index;
  idx_alpha := Source.idx_alpha;
  idx_palette := Source.idx_palette;

  rgb_red := Source.rgb_red;
  rgb_green := Source.rgb_green;
  rgb_blue := Source.rgb_blue;
  rgb_alpha := Source.rgb_alpha;

  for y := 0 to Height - 1 do
    Move(Source.ScanLine[y]^, ScanLine[y]^, WidthBytes);

  Transparent := Source.Transparent;
  TransparentColor := Source.TransparentColor;
  ImageGroupType := Source.ImageGroupType;
  ImageID := Source.ImageID;
  ImageName := Source.ImageName;
end;

procedure TDXTextureImage.ClearImage;
begin
  if FAutoFreeImage then
    FreeMem(FPBits);

  FImageType := DXTextureImageType_PaletteIndexedColor;
  FWidth := 0;
  FHeight := 0;
  FBitCount := 0;
  FWidthBytes := 0;
  FNextLine := 0;
  FSize := 0;
  FPBits := nil;
  FTopPBits := nil;
  FAutoFreeImage := False;
end;

procedure TDXTextureImage.Clear;
begin
  ClearImage;

  while SubImageCount > 0 do
    SubImages[SubImageCount - 1].Free;

  FImageGroupType := 0;
  FImageID := 0;
  FImageName := '';

  FTransparent := False;
  FTransparentColor := 0;

  FillChar(idx_index, SizeOf(idx_index), 0);
  FillChar(idx_alpha, SizeOf(idx_alpha), 0);
  FillChar(idx_palette, SizeOf(idx_palette), 0);
  FillChar(rgb_red, SizeOf(rgb_red), 0);
  FillChar(rgb_green, SizeOf(rgb_green), 0);
  FillChar(rgb_blue, SizeOf(rgb_blue), 0);
  FillChar(rgb_alpha, SizeOf(rgb_alpha), 0);
end;

procedure TDXTextureImage.SetImage(ImageType: TDXTextureImageType; Width, Height, BitCount, WidthBytes, NextLine: Integer;
  PBits, TopPBits: Pointer; Size: Integer; AutoFree: Boolean);
begin
  ClearImage;

  FAutoFreeImage := AutoFree;
  FImageType := ImageType;
  FWidth := Width;
  FHeight := Height;
  FBitCount := BitCount;
  FWidthBytes := WidthBytes;
  FNextLine := NextLine;
  FSize := Size;
  FPBits := PBits;
  FTopPBits := TopPBits;
end;

procedure TDXTextureImage.SetSize(ImageType: TDXTextureImageType; Width, Height, BitCount, WidthBytes: Integer);
var
  APBits: Pointer;
begin
  ClearImage;

  if WidthBytes = 0 then
    WidthBytes := GetWidthBytes(Width, BitCount);

  GetMem(APBits, WidthBytes * Height);
  SetImage(ImageType, Width, Height, BitCount, WidthBytes, WidthBytes, APBits, APBits, WidthBytes * Height, True);
end;

function TDXTextureImage.GetScanLine(y: Integer): Pointer;
begin
  Result := Pointer(Integer(FTopPBits) + FNextLine * y);
end;

function TDXTextureImage.GetSubGroupImageCount(GroupTypeID: DWORD): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to SubImageCount - 1 do
    if SubImages[i].ImageGroupType = GroupTypeID then
      Inc(Result);
end;

function TDXTextureImage.GetSubGroupImage(GroupTypeID: DWORD; Index: Integer): TDXTextureImage;
var
  i, j: Integer;
begin
  j := 0;
  for i := 0 to SubImageCount - 1 do
    if SubImages[i].ImageGroupType = GroupTypeID then
    begin
      if j = Index then
      begin
        Result := SubImages[i];
        Exit;
      end;

      Inc(j);
    end;

  Result := nil;
  SubImages[-1];
end;

function TDXTextureImage.GetSubImageCount: Integer;
begin
  Result := FSubImage.Count;
end;

function TDXTextureImage.GetSubImage(Index: Integer): TDXTextureImage;
begin
  Result := FSubImage[Index];
end;

function TDXTextureImage.EncodeColor(R, G, B, A: Byte): DWORD;
begin
  if ImageType = DXTextureImageType_PaletteIndexedColor then
  begin
    Result := dxtEncodeChannel(idx_index, PaletteIndex(R, G, B)) or
      dxtEncodeChannel(idx_alpha, A);
  end else
  begin
    Result := dxtEncodeChannel(rgb_red, R) or
      dxtEncodeChannel(rgb_green, G) or
      dxtEncodeChannel(rgb_blue, B) or
      dxtEncodeChannel(rgb_alpha, A);
  end;
end;

function TDXTextureImage.PaletteIndex(R, G, B: Byte): DWORD;
var
  i, d, d2: Integer;
begin
  Result := 0;
  if ImageType = DXTextureImageType_PaletteIndexedColor then
  begin
    d := MaxInt;
    for i := 0 to (1 shl idx_index.BitCount) - 1 do
      with idx_palette[i] do
      begin
        d2 := Abs((peRed - R)) * Abs((peRed - R)) + Abs((peGreen - G)) * Abs((peGreen - G)) + Abs((peBlue - B)) * Abs((peBlue - B));
        if d > d2 then
        begin
          d := d2;
          Result := i;
        end;
      end;
  end;
end;

const
  Mask1: array[0..7] of DWORD = (1, 2, 4, 8, 16, 32, 64, 128);
  Mask2: array[0..3] of DWORD = (3, 12, 48, 192);
  Mask4: array[0..1] of DWORD = ($0F, $F0);

  Shift1: array[0..7] of DWORD = (0, 1, 2, 3, 4, 5, 6, 7);
  Shift2: array[0..3] of DWORD = (0, 2, 4, 6);
  Shift4: array[0..1] of DWORD = (0, 4);

type
  PByte3 = ^TByte3;
  TByte3 = array[0..2] of Byte;

function TDXTextureImage.GetPixel(x, y: Integer): DWORD;
begin
  Result := 0;
  if (x >= 0) and (x < FWidth) and (y >= 0) and (y < FHeight) then
  begin
    case FBitCount of
      1: begin
          if FPackedPixelOrder then
            Result := (PByte(Integer(FTopPBits) + FNextLine * y + x shr 3)^ and Mask1[7 - x and 7]) shr Shift1[7 - x and 7]
          else
            Result := (PByte(Integer(FTopPBits) + FNextLine * y + x shr 3)^ and Mask1[x and 7]) shr Shift1[x and 7];
        end;
      2: begin
          if FPackedPixelOrder then
            Result := (PByte(Integer(FTopPBits) + FNextLine * y + x shr 2)^ and Mask2[3 - x and 3]) shr Shift2[3 - x and 3]
          else
            Result := (PByte(Integer(FTopPBits) + FNextLine * y + x shr 2)^ and Mask2[x and 3]) shr Shift2[x and 3];
        end;
      4: begin
          if FPackedPixelOrder then
            Result := (PByte(Integer(FTopPBits) + FNextLine * y + x shr 1)^ and Mask4[1 - x and 1]) shr Shift4[1 - x and 1]
          else
            Result := (PByte(Integer(FTopPBits) + FNextLine * y + x shr 1)^ and Mask4[x and 1]) shr Shift4[x and 1];
        end;
      8: Result := PByte(Integer(FTopPBits) + FNextLine * y + x)^;
      16: Result := PWord(Integer(FTopPBits) + FNextLine * y + x * 2)^;
      24: PByte3(@Result)^ := PByte3(Integer(FTopPBits) + FNextLine * y + x * 3)^;
      32: Result := PDWORD(Integer(FTopPBits) + FNextLine * y + x * 4)^;
    end;
  end;
end;

procedure TDXTextureImage.SetPixel(x, y: Integer; c: DWORD);
var
  P: PByte;
begin
  if (x >= 0) and (x < FWidth) and (y >= 0) and (y < FHeight) then
  begin
    case FBitCount of
      1: begin
          P := Pointer(Integer(FTopPBits) + FNextLine * y + x shr 3);
          if FPackedPixelOrder then
            P^ := (P^ and (not Mask1[7 - x and 7])) or ((c and 1) shl Shift1[7 - x and 7])
          else
            P^ := (P^ and (not Mask1[x and 7])) or ((c and 1) shl Shift1[x and 7]);
        end;
      2: begin
          P := Pointer(Integer(FTopPBits) + FNextLine * y + x shr 2);
          if FPackedPixelOrder then
            P^ := (P^ and (not Mask2[3 - x and 3])) or ((c and 3) shl Shift2[3 - x and 3])
          else
            P^ := (P^ and (not Mask2[x and 3])) or ((c and 3) shl Shift2[x and 3]);
        end;
      4: begin
          P := Pointer(Integer(FTopPBits) + FNextLine * y + x shr 1);
          if FPackedPixelOrder then
            P^ := (P^ and (not Mask4[1 - x and 1])) or ((c and 7) shl Shift4[1 - x and 1])
          else
            P^ := (P^ and (not Mask4[x and 1])) or ((c and 7) shl Shift4[x and 1]);
        end;
      8: PByte(Integer(FTopPBits) + FNextLine * y + x)^ := c;
      16: PWord(Integer(FTopPBits) + FNextLine * y + x * 2)^ := c;
      24: PByte3(Integer(FTopPBits) + FNextLine * y + x * 3)^ := PByte3(@c)^;
      32: PDWORD(Integer(FTopPBits) + FNextLine * y + x * 4)^ := c;
    end;
  end;
end;

procedure TDXTextureImage.LoadFromFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TDXTextureImage.LoadFromStream(Stream: TStream);
var
  i, p: Integer;
begin
  Clear;

  p := Stream.Position;
  for i := 0 to DXTextureImageLoadFuncList.Count - 1 do
  begin
    Stream.Position := p;
    try
      TDXTextureImageLoadFunc(DXTextureImageLoadFuncList[i])(Stream, Self);
      Exit;
    except
      Clear;
    end;
  end;

  raise EDXTextureImageError.Create(SNotSupportGraphicFile);
end;

procedure TDXTextureImage.SaveToFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure DXTextureImage_SaveDXTextureImageFunc(Stream: TStream; Image: TDXTextureImage); forward;

procedure TDXTextureImage.SaveToStream(Stream: TStream);
begin
  DXTextureImage_SaveDXTextureImageFunc(Stream, Self);
end;

{  DXTextureImage_LoadDXTextureImageFunc  }

const
  DXTextureImageFile_Type = 'dxt:';
  DXTextureImageFile_Version = $100;

  DXTextureImageCompress_None = 0;
  DXTextureImageCompress_ZLIB = 1; // ZLIB enabled

  DXTextureImageFileCategoryType_Image = $100;

  DXTextureImageFileBlockID_EndFile = 0;
  DXTextureImageFileBlockID_EndGroup = 1;
  DXTextureImageFileBlockID_StartGroup = 2;
  DXTextureImageFileBlockID_Image_Format = DXTextureImageFileCategoryType_Image + 1;
  DXTextureImageFileBlockID_Image_PixelData = DXTextureImageFileCategoryType_Image + 2;
  DXTextureImageFileBlockID_Image_GroupInfo = DXTextureImageFileCategoryType_Image + 3;
  DXTextureImageFileBlockID_Image_Name = DXTextureImageFileCategoryType_Image + 4;
  DXTextureImageFileBlockID_Image_TransparentColor = DXTextureImageFileCategoryType_Image + 5;

type
  TDXTextureImageFileHeader = packed record
    FileType: array[0..4] of Char;
    ver: DWORD;
  end;

  TDXTextureImageFileBlockHeader = packed record
    ID: DWORD;
    Size: Integer;
  end;

  TDXTextureImageFileBlockHeader_StartGroup = packed record
    CategoryType: DWORD;
  end;

  TDXTextureImageHeader_Image_Format = packed record
    ImageType: TDXTextureImageType;
    Width: DWORD;
    Height: DWORD;
    BitCount: DWORD;
    WidthBytes: DWORD;
  end;

  TDXTextureImageHeader_Image_Format_Index = packed record
    idx_index_Mask: DWORD;
    idx_alpha_Mask: DWORD;
    idx_palette: array[0..255] of TPaletteEntry;
  end;

  TDXTextureImageHeader_Image_Format_RGB = packed record
    rgb_red_Mask: DWORD;
    rgb_green_Mask: DWORD;
    rgb_blue_Mask: DWORD;
    rgb_alpha_Mask: DWORD;
  end;

  TDXTextureImageHeader_Image_GroupInfo = packed record
    ImageGroupType: DWORD;
    ImageID: DWORD;
  end;

  TDXTextureImageHeader_Image_PixelData = packed record
    Compress: DWORD;
  end;

  TDXTextureImageHeader_Image_TransparentColor = packed record
    Transparent: Boolean;
    TransparentColor: DWORD;
  end;

procedure DXTextureImage_LoadDXTextureImageFunc(Stream: TStream; Image: TDXTextureImage);

  procedure ReadGroup_Image(Image: TDXTextureImage);
  var
    i: Integer;
    BlockHeader: TDXTextureImageFileBlockHeader;
    NextPos: Integer;
    SubImage: TDXTextureImage;
    Header_StartGroup: TDXTextureImageFileBlockHeader_StartGroup;
    Header_Image_Format: TDXTextureImageHeader_Image_Format;
    Header_Image_Format_Index: TDXTextureImageHeader_Image_Format_Index;
    Header_Image_Format_RGB: TDXTextureImageHeader_Image_Format_RGB;
    Header_Image_GroupInfo: TDXTextureImageHeader_Image_GroupInfo;
    Header_Image_TransparentColor: TDXTextureImageHeader_Image_TransparentColor;
    Header_Image_PixelData: TDXTextureImageHeader_Image_PixelData;
    ImageName: string;
  {$IFDEF DXTextureImage_UseZLIB}
    Decompression: TDecompressionStream;
  {$ENDIF}
  begin
    while True do
    begin
      Stream.ReadBuffer(BlockHeader, SizeOf(BlockHeader));
      NextPos := Stream.Position + BlockHeader.Size;

      case BlockHeader.ID of
        DXTextureImageFileBlockID_EndGroup:
          begin
            {  End of group  }
            Break;
          end;
        DXTextureImageFileBlockID_StartGroup:
          begin
            {  Beginning of group  }
            Stream.ReadBuffer(Header_StartGroup, SizeOf(Header_StartGroup));
            case Header_StartGroup.CategoryType of
              DXTextureImageFileCategoryType_Image:
                begin
                  {  Image group  }
                  SubImage := TDXTextureImage.CreateSub(Image);
                  try
                    ReadGroup_Image(SubImage);
                  except
                    SubImage.Free;
                    raise;
                  end;
                end;
            end;
          end;
        DXTextureImageFileBlockID_Image_Format:
          begin
            {  Image information reading (size etc.)  }
            Stream.ReadBuffer(Header_Image_Format, SizeOf(Header_Image_Format));

            if (Header_Image_Format.ImageType <> DXTextureImageType_PaletteIndexedColor) and
              (Header_Image_Format.ImageType <> DXTextureImageType_RGBColor) then
              raise EDXTextureImageError.Create(SInvalidDXTFile);

            Image.SetSize(Header_Image_Format.ImageType, Header_Image_Format.Width, Header_Image_Format.Height,
              Header_Image_Format.BitCount, Header_Image_Format.Widthbytes);

            if Header_Image_Format.ImageType = DXTextureImageType_PaletteIndexedColor then
            begin
              {  INDEX IMAGE  }
              Stream.ReadBuffer(Header_Image_Format_Index, SizeOf(Header_Image_Format_Index));

              Image.idx_index := dxtMakeChannel(Header_Image_Format_Index.idx_index_Mask, True);
              Image.idx_alpha := dxtMakeChannel(Header_Image_Format_Index.idx_alpha_Mask, False);

              for i := 0 to 255 do
                Image.idx_palette[i] := Header_Image_Format_Index.idx_palette[i];
            end else if Header_Image_Format.ImageType = DXTextureImageType_RGBColor then
            begin
              {  RGB IMAGE  }
              Stream.ReadBuffer(Header_Image_Format_RGB, SizeOf(Header_Image_Format_RGB));

              Image.rgb_red := dxtMakeChannel(Header_Image_Format_RGB.rgb_red_Mask, False);
              Image.rgb_green := dxtMakeChannel(Header_Image_Format_RGB.rgb_green_Mask, False);
              Image.rgb_blue := dxtMakeChannel(Header_Image_Format_RGB.rgb_blue_Mask, False);
              Image.rgb_alpha := dxtMakeChannel(Header_Image_Format_RGB.rgb_alpha_Mask, False);
            end;
          end;
        DXTextureImageFileBlockID_Image_Name:
          begin
            {  Name reading  }
            SetLength(ImageName, BlockHeader.Size);
            Stream.ReadBuffer(ImageName[1], BlockHeader.Size);

            Image.ImageName := ImageName;
          end;
        DXTextureImageFileBlockID_Image_GroupInfo:
          begin
            {  Image group information reading  }
            Stream.ReadBuffer(Header_Image_GroupInfo, SizeOf(Header_Image_GroupInfo));

            Image.ImageGroupType := Header_Image_GroupInfo.ImageGroupType;
            Image.ImageID := Header_Image_GroupInfo.ImageID;
          end;
        DXTextureImageFileBlockID_Image_TransparentColor:
          begin
            {  Transparent color information reading  }
            Stream.ReadBuffer(Header_Image_TransparentColor, SizeOf(Header_Image_TransparentColor));

            Image.Transparent := Header_Image_TransparentColor.Transparent;
            Image.TransparentColor := Header_Image_TransparentColor.TransparentColor;
          end;
        DXTextureImageFileBlockID_Image_PixelData:
          begin
            {  Pixel data reading  }
            Stream.ReadBuffer(Header_Image_PixelData, SizeOf(Header_Image_PixelData));

            case Header_Image_PixelData.Compress of
              DXTextureImageCompress_None:
                begin
                   {  NO compress  }
                  for i := 0 to Image.Height - 1 do
                    Stream.ReadBuffer(Image.ScanLine[i]^, Header_Image_Format.Widthbytes);
                end;
{$IFDEF DXTextureImage_UseZLIB}
              DXTextureImageCompress_ZLIB:
                begin
                   {  ZLIB compress enabled  }
                  Decompression := TDecompressionStream.Create(Stream);
                  try
                    for i := 0 to Image.Height - 1 do
                      Decompression.ReadBuffer(Image.ScanLine[i]^, Header_Image_Format.Widthbytes);
                  finally
                    Decompression.Free;
                  end;
                end;
{$ENDIF}
            else
              raise EDXTextureImageError.CreateFmt('Decompression error (%d)', [Header_Image_PixelData.Compress]);
            end;
          end;

      end;

      Stream.Seek(NextPos, soFromBeginning);
    end;
  end;

var
  FileHeader: TDXTextureImageFileHeader;
  BlockHeader: TDXTextureImageFileBlockHeader;
  Header_StartGroup: TDXTextureImageFileBlockHeader_StartGroup;
  NextPos: Integer;
begin
  {  File header reading  }
  Stream.ReadBuffer(FileHeader, SizeOf(FileHeader));

  if FileHeader.FileType <> DXTextureImageFile_Type then
    raise EDXTextureImageError.Create(SInvalidDXTFile);
  if FileHeader.ver <> DXTextureImageFile_Version then
    raise EDXTextureImageError.Create(SInvalidDXTFile);

  while True do
  begin
    Stream.ReadBuffer(BlockHeader, SizeOf(BlockHeader));
    NextPos := Stream.Position + BlockHeader.Size;

    case BlockHeader.ID of
      DXTextureImageFileBlockID_EndFile:
        begin
          {  End of file  }
          Break;
        end;
      DXTextureImageFileBlockID_StartGroup:
        begin
          {  Beginning of group  }
          Stream.ReadBuffer(Header_StartGroup, SizeOf(Header_StartGroup));
          case Header_StartGroup.CategoryType of
            DXTextureImageFileCategoryType_Image: ReadGroup_Image(Image);
          end;
        end;
    end;

    Stream.Seek(NextPos, soFromBeginning);
  end;
end;

type
  PDXTextureImageFileBlockHeaderWriter_BlockInfo = ^TDXTextureImageFileBlockHeaderWriter_BlockInfo;
  TDXTextureImageFileBlockHeaderWriter_BlockInfo = record
    BlockID: DWORD;
    StreamPos: Integer;
  end;

  TDXTextureImageFileBlockHeaderWriter = class
  private
    FStream: TStream;
    FList: TList;
  public
    constructor Create(Stream: TStream);
    destructor Destroy; override;
    procedure StartBlock(BlockID: DWORD);
    procedure EndBlock;
    procedure WriteBlock(BlockID: DWORD);
    procedure StartGroup(CategoryType: DWORD);
    procedure EndGroup;
  end;

constructor TDXTextureImageFileBlockHeaderWriter.Create(Stream: TStream);
begin
  inherited Create;
  FStream := Stream;
  FList := TList.Create;
end;

destructor TDXTextureImageFileBlockHeaderWriter.Destroy;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    Dispose(PDXTextureImageFileBlockHeaderWriter_BlockInfo(FList[i]));
  FList.Free;
  inherited Destroy;
end;

procedure TDXTextureImageFileBlockHeaderWriter.StartBlock(BlockID: DWORD);
var
  BlockInfo: PDXTextureImageFileBlockHeaderWriter_BlockInfo;
  BlockHeader: TDXTextureImageFileBlockHeader;
begin
  New(BlockInfo);
  BlockInfo.BlockID := BlockID;
  BlockInfo.StreamPos := FStream.Position;
  FList.Add(BlockInfo);

  BlockHeader.ID := BlockID;
  BlockHeader.Size := 0;
  FStream.WriteBuffer(BlockHeader, SizeOf(BlockHeader));
end;

procedure TDXTextureImageFileBlockHeaderWriter.EndBlock;
var
  BlockHeader: TDXTextureImageFileBlockHeader;
  BlockInfo: PDXTextureImageFileBlockHeaderWriter_BlockInfo;
  CurStreamPos: Integer;
begin
  CurStreamPos := FStream.Position;
  try
    BlockInfo := FList[FList.Count - 1];

    FStream.Position := BlockInfo.StreamPos;
    BlockHeader.ID := BlockInfo.BlockID;
    BlockHeader.Size := CurStreamPos - (BlockInfo.StreamPos + SizeOf(TDXTextureImageFileBlockHeader));
    FStream.WriteBuffer(BlockHeader, SizeOf(BlockHeader));
  finally
    FStream.Position := CurStreamPos;

    Dispose(FList[FList.Count - 1]);
    FList.Count := FList.Count - 1;
  end;
end;

procedure TDXTextureImageFileBlockHeaderWriter.WriteBlock(BlockID: DWORD);
var
  BlockHeader: TDXTextureImageFileBlockHeader;
begin
  BlockHeader.ID := BlockID;
  BlockHeader.Size := 0;
  FStream.WriteBuffer(BlockHeader, SizeOf(BlockHeader));
end;

procedure TDXTextureImageFileBlockHeaderWriter.StartGroup(CategoryType: DWORD);
var
  Header_StartGroup: TDXTextureImageFileBlockHeader_StartGroup;
begin
  StartBlock(DXTextureImageFileBlockID_StartGroup);

  Header_StartGroup.CategoryType := CategoryType;
  FStream.WriteBuffer(Header_StartGroup, SizeOf(Header_StartGroup));
end;

procedure TDXTextureImageFileBlockHeaderWriter.EndGroup;
begin
  WriteBlock(DXTextureImageFileBlockID_EndGroup);
  EndBlock;
end;

procedure DXTextureImage_SaveDXTextureImageFunc(Stream: TStream; Image: TDXTextureImage);
var
  Progress: Integer;
  ProgressCount: Integer;
  BlockHeaderWriter: TDXTextureImageFileBlockHeaderWriter;

  function CalcProgressCount(Image: TDXTextureImage): Integer;
  var
    i: Integer;
  begin
    Result := Image.WidthBytes * Image.Height;
    for i := 0 to Image.SubImageCount - 1 do
      Inc(Result, CalcProgressCount(Image.SubImages[i]));
  end;

  procedure AddProgress(Count: Integer);
  begin
    Inc(Progress, Count);
    Image.DoSaveProgress(Progress, ProgressCount);
  end;

  procedure WriteGroup_Image(Image: TDXTextureImage);
  var
    i: Integer;
    Header_Image_Format: TDXTextureImageHeader_Image_Format;
    Header_Image_Format_Index: TDXTextureImageHeader_Image_Format_Index;
    Header_Image_Format_RGB: TDXTextureImageHeader_Image_Format_RGB;
    Header_Image_GroupInfo: TDXTextureImageHeader_Image_GroupInfo;
    Header_Image_TransparentColor: TDXTextureImageHeader_Image_TransparentColor;
    Header_Image_PixelData: TDXTextureImageHeader_Image_PixelData;
  {$IFDEF DXTextureImage_UseZLIB}
    Compression: TCompressionStream;
  {$ENDIF}
  begin
    BlockHeaderWriter.StartGroup(DXTextureImageFileCategoryType_Image);
    try
      {  Image format writing  }
      if Image.Size > 0 then
      begin
        Header_Image_Format.ImageType := Image.ImageType;
        Header_Image_Format.Width := Image.Width;
        Header_Image_Format.Height := Image.Height;
        Header_Image_Format.BitCount := Image.BitCount;
        Header_Image_Format.WidthBytes := Image.WidthBytes;

        BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_Format);
        try
          Stream.WriteBuffer(Header_Image_Format, SizeOf(Header_Image_Format));

          case Image.ImageType of
            DXTextureImageType_PaletteIndexedColor:
              begin
                {  INDEX IMAGE  }
                Header_Image_Format_Index.idx_index_Mask := Image.idx_index.Mask;
                Header_Image_Format_Index.idx_alpha_Mask := Image.idx_alpha.Mask;
                for i := 0 to 255 do
                  Header_Image_Format_Index.idx_palette[i] := Image.idx_palette[i];

                Stream.WriteBuffer(Header_Image_Format_Index, SizeOf(Header_Image_Format_Index));
              end;
            DXTextureImageType_RGBColor:
              begin
                {  RGB IMAGE  }
                Header_Image_Format_RGB.rgb_red_Mask := Image.rgb_red.Mask;
                Header_Image_Format_RGB.rgb_green_Mask := Image.rgb_green.Mask;
                Header_Image_Format_RGB.rgb_blue_Mask := Image.rgb_blue.Mask;
                Header_Image_Format_RGB.rgb_alpha_Mask := Image.rgb_alpha.Mask;

                Stream.WriteBuffer(Header_Image_Format_RGB, SizeOf(Header_Image_Format_RGB));
              end;
          end;
        finally
          BlockHeaderWriter.EndBlock;
        end;
      end;

      {  Image group information writing  }
      BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_GroupInfo);
      try
        Header_Image_GroupInfo.ImageGroupType := Image.ImageGroupType;
        Header_Image_GroupInfo.ImageID := Image.ImageID;

        Stream.WriteBuffer(Header_Image_GroupInfo, SizeOf(Header_Image_GroupInfo));
      finally
        BlockHeaderWriter.EndBlock;
      end;

      {  Name writing  }
      BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_Name);
      try
        Stream.WriteBuffer(Image.ImageName[1], Length(Image.ImageName));
      finally
        BlockHeaderWriter.EndBlock;
      end;

      {  Transparent color writing  }
      BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_TransparentColor);
      try
        Header_Image_TransparentColor.Transparent := Image.Transparent;
        Header_Image_TransparentColor.TransparentColor := Image.TransparentColor;

        Stream.WriteBuffer(Header_Image_TransparentColor, SizeOf(Header_Image_TransparentColor));
      finally
        BlockHeaderWriter.EndBlock;
      end;

      {  Pixel data writing  }
      if Image.Size > 0 then
      begin
        {  Writing start  }
        BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_PixelData);
        try
          {  Scan compress type  }
          case Image.FileCompressType of
            DXTextureImageFileCompressType_None:
              begin
                Header_Image_PixelData.Compress := DXTextureImageCompress_None;
              end;
{$IFDEF DXTextureImage_UseZLIB}
            DXTextureImageFileCompressType_ZLIB:
              begin
                Header_Image_PixelData.Compress := DXTextureImageCompress_ZLIB;
              end;
{$ENDIF}
          else
            Header_Image_PixelData.Compress := DXTextureImageCompress_None;
          end;

          Stream.WriteBuffer(Header_Image_PixelData, SizeOf(Header_Image_PixelData));

          case Header_Image_PixelData.Compress of
            DXTextureImageCompress_None:
              begin
                for i := 0 to Image.Height - 1 do
                begin
                  Stream.WriteBuffer(Image.ScanLine[i]^, Image.Widthbytes);
                  AddProgress(Image.Widthbytes);
                end;
              end;
{$IFDEF DXTextureImage_UseZLIB}
            DXTextureImageCompress_ZLIB:
              begin
                Compression := TCompressionStream.Create(clMax, Stream);
                try
                  for i := 0 to Image.Height - 1 do
                  begin
                    Compression.WriteBuffer(Image.ScanLine[i]^, Image.WidthBytes);
                    AddProgress(Image.Widthbytes);
                  end;
                finally
                  Compression.Free;
                end;
              end;
{$ENDIF}
          end;
        finally
          BlockHeaderWriter.EndBlock;
        end;
      end;

      {  Sub-image writing  }
      for i := 0 to Image.SubImageCount - 1 do
        WriteGroup_Image(Image.SubImages[i]);
    finally
      BlockHeaderWriter.EndGroup;
    end;
  end;

var
  FileHeader: TDXTextureImageFileHeader;
begin
  Progress := 0;
  ProgressCount := CalcProgressCount(Image);

  {  File header writing  }
  FileHeader.FileType := DXTextureImageFile_Type;
  FileHeader.ver := DXTextureImageFile_Version;
  Stream.WriteBuffer(FileHeader, SizeOf(FileHeader));

  {  Image writing  }
  BlockHeaderWriter := TDXTextureImageFileBlockHeaderWriter.Create(Stream);
  try
    {  Image writing  }
    WriteGroup_Image(Image);

    {  End of file  }
    BlockHeaderWriter.WriteBlock(DXTextureImageFileBlockID_EndFile);
  finally
    BlockHeaderWriter.Free;
  end;
end;

{  DXTextureImage_LoadBitmapFunc  }

procedure DXTextureImage_LoadBitmapFunc(Stream: TStream; Image: TDXTextureImage);
type
  TDIBPixelFormat = packed record
    RBitMask, GBitMask, BBitMask: DWORD;
  end;
var
  TopDown: Boolean;
  BF: TBitmapFileHeader;
  BI: TBitmapInfoHeader;

  procedure DecodeRGB;
  var
    y: Integer;
  begin
    for y := 0 to Image.Height - 1 do
    begin
      if TopDown then
        Stream.ReadBuffer(Image.ScanLine[y]^, Image.WidthBytes)
      else
        Stream.ReadBuffer(Image.ScanLine[Image.Height - y - 1]^, Image.WidthBytes);
    end;
  end;

  procedure DecodeRLE4;
  var
    SrcDataP: Pointer;
    B1, B2, C: Byte;
    Dest, Src, P: PByte;
    X, Y, i: Integer;
  begin
    GetMem(SrcDataP, BI.biSizeImage);
    try
      Stream.ReadBuffer(SrcDataP^, BI.biSizeImage);

      Dest := Image.TopPBits;
      Src := SrcDataP;
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
                Dest := Image.ScanLine[Y];
              end;
            1: Break; {  End of bitmap  }
            2: begin {  Difference of coordinates  }
                Inc(X, B1); Inc(Y, B2); Inc(Src, 2);
                Dest := Image.ScanLine[Y];
              end;
          else
            {  Absolute mode  }
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
    finally
      FreeMem(SrcDataP);
    end;
  end;

  procedure DecodeRLE8;
  var
    SrcDataP: Pointer;
    B1, B2: Byte;
    Dest, Src: PByte;
    X, Y: Integer;
  begin
    GetMem(SrcDataP, BI.biSizeImage);
    try
      Stream.ReadBuffer(SrcDataP^, BI.biSizeImage);

      Dest := Image.TopPBits;
      Src := SrcDataP;
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
                Dest := Pointer(Longint(Image.TopPBits) + Y * Image.NextLine + X);
              end;
            1: Break; {  End of bitmap  }
            2: begin {  Difference of coordinates  }
                Inc(X, B1); Inc(Y, B2); Inc(Src, 2);
                Dest := Pointer(Longint(Image.TopPBits) + Y * Image.NextLine + X);
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
    finally
      FreeMem(SrcDataP);
    end;
  end;

var
  BC: TBitmapCoreHeader;
  RGBTriples: array[0..255] of TRGBTriple;
  RGBQuads: array[0..255] of TRGBQuad;
  i, PalCount, j: Integer;
  OS2: Boolean;
  PixelFormat: TDIBPixelFormat;
begin
  {  File header reading  }
  i := Stream.Read(BF, SizeOf(TBitmapFileHeader));
  if i = 0 then Exit;
  if i <> SizeOf(TBitmapFileHeader) then
    raise EDXTextureImageError.Create(SInvalidDIB);

  {  Is the head 'BM'?  }
  if BF.bfType <> Ord('B') + Ord('M') * $100 then
    raise EDXTextureImageError.Create(SInvalidDIB);

  {  Reading of size of header  }
  i := Stream.Read(BI.biSize, 4);
  if i <> 4 then
    raise EDXTextureImageError.Create(SInvalidDIB);

  {  Kind check of DIB  }
  OS2 := False;

  case BI.biSize of
    SizeOf(TBitmapCoreHeader):
      begin
        {  OS/2 type  }
        Stream.ReadBuffer(Pointer(Integer(@BC) + 4)^, SizeOf(TBitmapCoreHeader) - 4);

        FilLChar(BI, SizeOf(BI), 0);
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
    raise EDXTextureImageError.Create(SInvalidDIB);
  end;

  {  Bit mask reading  }
  if BI.biCompression = BI_BITFIELDS then
  begin
    Stream.ReadBuffer(PixelFormat, SizeOf(PixelFormat));
  end else
  begin
    if BI.biBitCount = 16 then
    begin
      PixelFormat.RBitMask := $7C00;
      PixelFormat.GBitMask := $03E0;
      PixelFormat.BBitMask := $001F;
    end else if (BI.biBitCount = 24) or (BI.biBitCount = 32) then
    begin
      PixelFormat.RBitMask := $00FF0000;
      PixelFormat.GBitMask := $0300FF00;
      PixelFormat.BBitMask := $000000FF;
    end;
  end;

  {  DIB making  }
  if BI.biHeight < 0 then
  begin
    BI.biHeight := -BI.biHeight;
    TopDown := True;
  end else
    TopDown := False;

  if BI.biBitCount in [1, 4, 8] then
  begin
    Image.SetSize(DXTextureImageType_PaletteIndexedColor, BI.biWidth, BI.biHeight, BI.biBitCount,
      (((BI.biWidth * BI.biBitCount) + 31) div 32) * 4);

    Image.idx_index := dxtMakeChannel(1 shl BI.biBitCount - 1, True);
    Image.PackedPixelOrder := True;
  end else
  begin
    Image.SetSize(DXTextureImageType_RGBColor, BI.biWidth, BI.biHeight, BI.biBitCount,
      (((BI.biWidth * BI.biBitCount) + 31) div 32) * 4);

    Image.rgb_red := dxtMakeChannel(PixelFormat.RBitMask, False);
    Image.rgb_green := dxtMakeChannel(PixelFormat.GBitMask, False);
    Image.rgb_blue := dxtMakeChannel(PixelFormat.BBitMask, False);

    j := Image.rgb_red.BitCount + Image.rgb_green.BitCount + Image.rgb_blue.BitCount;
    if j < BI.biBitCount then
      Image.rgb_alpha := dxtMakeChannel((1 shl (BI.biBitCount - j) - 1) shl j, False);

    Image.PackedPixelOrder := False;
  end;

  {  palette reading  }
  PalCount := BI.biClrUsed;
  if (PalCount = 0) and (BI.biBitCount <= 8) then
    PalCount := 1 shl BI.biBitCount;
  if PalCount > 256 then PalCount := 256;

  if OS2 then
  begin
    {  OS/2 type  }
    Stream.ReadBuffer(RGBTriples, SizeOf(TRGBTriple) * PalCount);
    for i := 0 to PalCount - 1 do
    begin
      Image.idx_palette[i].peRed := RGBTriples[i].rgbtRed;
      Image.idx_palette[i].peGreen := RGBTriples[i].rgbtGreen;
      Image.idx_palette[i].peBlue := RGBTriples[i].rgbtBlue;
    end;
  end else
  begin
    {  Windows type  }
    Stream.ReadBuffer(RGBQuads, SizeOf(TRGBQuad) * PalCount);
    for i := 0 to PalCount - 1 do
    begin
      Image.idx_palette[i].peRed := RGBQuads[i].rgbRed;
      Image.idx_palette[i].peGreen := RGBQuads[i].rgbGreen;
      Image.idx_palette[i].peBlue := RGBQuads[i].rgbBlue;
    end;
  end;

  {  Pixel data reading  }
  case BI.biCompression of
    BI_RGB: DecodeRGB;
    BI_BITFIELDS: DecodeRGB;
    BI_RLE4: DecodeRLE4;
    BI_RLE8: DecodeRLE8;
  else
    raise EDXTextureImageError.Create(SInvalidDIB);
  end;
end;

{ TDXTBase }

//Note by JB.
//This class is supplement of original Hori's code.
//For use alphablend you can have a bitmap 32 bit RGBA
//when isn't alphachannel present, it works like RGB 24bit

//functions required actualized DIB source for works with alphachannel

function TDXTBase.GetCompression: TDXTextureImageFileCompressType;
begin
  Result := FParamsFormat.Compress;
end;

procedure TDXTBase.SetCompression(const Value: TDXTextureImageFileCompressType);
begin
  FParamsFormat.Compress := Value;
end;

function TDXTBase.GetWidth: Integer;
begin
  Result := FParamsFormat.Width;
end;

procedure TDXTBase.SetWidth(const Value: Integer);
begin
  FParamsFormat.Width := Value;
end;

function TDXTBase.GetMipmap: Integer;
begin
  Result := FParamsFormat.MipmapCount;
end;

procedure TDXTBase.SetMipmap(const Value: Integer);
begin
  if Value = -1 then
    FParamsFormat.MipmapCount := MaxInt
  else
    FParamsFormat.MipmapCount := Value;
end;

function TDXTBase.GetTransparentColor: TColorRef;
begin
  Result := FParamsFormat.TransparentColor;
end;

procedure TDXTBase.SetTransparentColor(const Value: TColorRef);
begin
  FParamsFormat.Transparent := True;
  FParamsFormat.TransparentColor := RGB(Value shr 16, Value shr 8, Value);
end;

procedure TDXTBase.SetTransparentColorIndexed(const Value: TColorRef);
begin
  FParamsFormat.TransparentColor := PaletteIndex(Value);
end;

function TDXTBase.GetHeight: Integer;
begin
  Result := FParamsFormat.Height;
end;

procedure TDXTBase.SetHeight(const Value: Integer);
begin
  FParamsFormat.Height := Value;
end;

procedure TDXTBase.SetChannelY(T: TDIB);
begin

end;

procedure TDXTBase.LoadChannelRGBFromFile(const FileName: string);
begin
  FStrImageFileName := FileName;
  try
    EvaluateChannels([rgbRed, rgbGreen, rgbBlue], '', '');
  finally
    FStrImageFileName := '';
  end;
end;

procedure TDXTBase.LoadChannelAFromFile(const FileName: string);
begin
  FStrImageFileName := FileName;
  try
    EvaluateChannels([rgbAlpha], '', '');
  finally
    FStrImageFileName := '';
  end;
end;

constructor TDXTBase.Create;
var
  Channel: TDXTImageChannel;
begin
  FilLChar(FParamsFormat, SizeOf(FParamsFormat), 0);
  FParamsFormat.Compress := DXTextureImageFileCompressType_None;
  FHasImageList := TList.Create;
  for Channel := Low(Channel) to High(Channel) do
    FChannelChangeTable[Channel] := Channel;
  FChannelChangeTable[rgbAlpha] := yuvY;
  FDIB := nil;
  FStrImageFileName := '';
end;

procedure TDXTBase.SetChannelRGBA(T: TDIB);
begin
  FDIB := T;
  try
    EvaluateChannels([rgbRed, rgbGreen, rgbBlue, rgbAlpha], '', '');
  finally
    FDIB := nil;
  end;
end;

procedure TDXTBase.BuildImage(Image: TDXTextureImage);
type
  TOutputImageChannelInfo2 = record
    Image: TDXTextureImage;
    Channels: TDXTImageChannels;
  end;
var
  cR, cG, cB: Byte;

  function GetChannelVal(const Channel: TDXTextureImageChannel; SrcChannel: TDXTImageChannel): DWORD;
  begin
    case SrcChannel of
      rgbRed: Result := dxtEncodeChannel(Channel, cR);
      rgbGreen: Result := dxtEncodeChannel(Channel, cG);
      rgbBlue: Result := dxtEncodeChannel(Channel, cB);
      yuvY: Result := dxtEncodeChannel(Channel, (cR * 306 + cG * 602 + cB * 116) div 1024);
    else Result := 0;
    end;
  end;

var
  HasImageChannelList: array[0..Ord(High(TDXTImageChannel)) + 1] of TOutputImageChannelInfo2;
  HasImageChannelListCount: Integer;
  x, y, i: Integer;
  c, c2, c3: DWORD;
  Channel: TDXTImageChannel;
  Flag: Boolean;

  SrcImage: TDXTextureImage;
  UseChannels: TDXTImageChannels;
begin
  HasImageChannelListCount := 0;
  for Channel := Low(Channel) to High(Channel) do
    if Channel in FHasChannels then
    begin
      Flag := False;
      for i := 0 to HasImageChannelListCount - 1 do
        if HasImageChannelList[i].Image = FHasChannelImages[Channel].Image then
        begin
          HasImageChannelList[i].Channels := HasImageChannelList[i].Channels + [Channel];
          Flag := True;
          Break;
        end;
      if not Flag then
      begin
        HasImageChannelList[HasImageChannelListCount].Image := FHasChannelImages[Channel].Image;
        HasImageChannelList[HasImageChannelListCount].Channels := [Channel];
        Inc(HasImageChannelListCount);
      end;
    end;

  cR := 0;
  cG := 0;
  cB := 0;

  if Image.ImageType = DXTextureImageType_PaletteIndexedColor then
  begin
    {  Index color  }
    for y := 0 to Image.Height - 1 do
      for x := 0 to Image.Width - 1 do
      begin
        c := 0;

        for i := 0 to HasImageChannelListCount - 1 do
        begin
          SrcImage := HasImageChannelList[i].Image;
          UseChannels := HasImageChannelList[i].Channels;

          case SrcImage.ImageType of
            DXTextureImageType_PaletteIndexedColor:
              begin
                c2 := SrcImage.Pixels[x, y];
                c3 := dxtDecodeChannel(SrcImage.idx_index, c2);

                if rgbRed in UseChannels then
                  c := c or dxtEncodeChannel(Image.idx_index, c3);

                cR := SrcImage.idx_palette[c3].peRed;
                cG := SrcImage.idx_palette[c3].peGreen;
                cB := SrcImage.idx_palette[c3].peBlue;
              end;
            DXTextureImageType_RGBColor:
              begin
                c2 := SrcImage.Pixels[x, y];

                cR := dxtDecodeChannel(SrcImage.rgb_red, c2);
                cG := dxtDecodeChannel(SrcImage.rgb_green, c2);
                cB := dxtDecodeChannel(SrcImage.rgb_blue, c2);
              end;
          end;

          if rgbAlpha in UseChannels then
            c := c or GetChannelVal(Image.idx_alpha, FChannelChangeTable[rgbAlpha]);
        end;

        Image.Pixels[x, y] := c;
      end;
  end else
    if Image.ImageType = DXTextureImageType_RGBColor then
    begin
    {  RGB color  }
      for y := 0 to Image.Height - 1 do
        for x := 0 to Image.Width - 1 do
        begin
          c := 0;

          for i := 0 to HasImageChannelListCount - 1 do
          begin
            SrcImage := HasImageChannelList[i].Image;
            UseChannels := HasImageChannelList[i].Channels;

            case SrcImage.ImageType of
              DXTextureImageType_PaletteIndexedColor:
                begin
                  c2 := SrcImage.Pixels[x, y];
                  c3 := dxtDecodeChannel(SrcImage.idx_index, c2);

                  cR := SrcImage.idx_palette[c3].peRed;
                  cG := SrcImage.idx_palette[c3].peGreen;
                  cB := SrcImage.idx_palette[c3].peBlue;
                end;
              DXTextureImageType_RGBColor:
                begin
                  c2 := SrcImage.Pixels[x, y];

                  cR := dxtDecodeChannel(SrcImage.rgb_red, c2);
                  cG := dxtDecodeChannel(SrcImage.rgb_green, c2);
                  cB := dxtDecodeChannel(SrcImage.rgb_blue, c2);
                end;
            end;

            if rgbRed in UseChannels then
              c := c or GetChannelVal(Image.rgb_red, FChannelChangeTable[rgbRed]);
            if rgbGreen in UseChannels then
              c := c or GetChannelVal(Image.rgb_green, FChannelChangeTable[rgbGreen]);
            if rgbBlue in UseChannels then
              c := c or GetChannelVal(Image.rgb_Blue, FChannelChangeTable[rgbBlue]);
            if rgbAlpha in UseChannels then
              c := c or GetChannelVal(Image.rgb_alpha, FChannelChangeTable[rgbAlpha]);
          end;

          Image.Pixels[x, y] := c;
        end;
    end;
end;

procedure TDXTBase.SetChannelR(T: TDIB);
begin
  FDIB := T;
  try
    EvaluateChannels([rgbRed], '', '');
  finally
    FDIB := nil;
  end;
end;

function GetBitCount(b: Integer): Integer;
begin
  Result := 32;
  while (Result > 0) and (((1 shl (Result - 1)) and b) = 0) do Dec(Result);
end;

procedure TDXTBase.CalcOutputBitFormat;
var
  BitCount: DWORD;
  NewWidth, NewHeight, i, j: Integer;
  Channel: TDXTImageChannel;
begin
  {  Size calculation  }
  NewWidth := 1 shl GetBitCount(TDXTextureImage(FHasImageList[0]).Width);
  NewHeight := 1 shl GetBitCount(TDXTextureImage(FHasImageList[0]).Height);
  NewWidth := Max(NewWidth, NewHeight);
  NewHeight := NewWidth;
  if Abs(FParamsFormat.Width - NewWidth) > Abs(FParamsFormat.Width - NewWidth div 2) then
    NewWidth := NewWidth div 2;
  if Abs(FParamsFormat.Height - NewHeight) > Abs(FParamsFormat.Height - NewHeight div 2) then
    NewHeight := NewHeight div 2;

  if FParamsFormat.Width = 0 then FParamsFormat.Width := NewWidth;
  if FParamsFormat.Height = 0 then FParamsFormat.Height := NewHeight;

  {  Other several calculation  }
  i := Min(FParamsFormat.Width, FParamsFormat.Height);
  j := 0;
  while i > 1 do
  begin
    i := i div 2;
    Inc(j);
  end;

  FParamsFormat.MipmapCount := Min(j, FParamsFormat.MipmapCount);

  {  Output type calculation  }
  if (FHasChannelImages[rgbRed].Image = FHasChannelImages[rgbGreen].Image) and
    (FHasChannelImages[rgbRed].Image = FHasChannelImages[rgbBlue].Image) and
    (FHasChannelImages[rgbRed].Image <> nil) and (FHasChannelImages[rgbRed].Image.ImageType = DXTextureImageType_PaletteIndexedColor) and

  (FHasChannelImages[rgbRed].BitCount = 8) and
    (FHasChannelImages[rgbGreen].BitCount = 8) and
    (FHasChannelImages[rgbBlue].BitCount = 8) and

  (FChannelChangeTable[rgbRed] = rgbRed) and
    (FChannelChangeTable[rgbGreen] = rgbGreen) and
    (FChannelChangeTable[rgbBlue] = rgbBlue) and

  (FParamsFormat.Width = FHasChannelImages[rgbRed].Image.Width) and
    (FParamsFormat.Height = FHasChannelImages[rgbRed].Image.Height) and

  (FParamsFormat.MipmapCount = 0) then
  begin
    FParamsFormat.ImageType := DXTextureImageType_PaletteIndexedColor;
  end else
    FParamsFormat.ImageType := DXTextureImageType_RGBColor;

  {  Bit several calculations  }
  FParamsFormat.BitCount := 0;

  for Channel := Low(TDXTImageChannel) to High(TDXTImageChannel) do
    if (FHasChannelImages[Channel].Image <> nil) and (FHasChannelImages[Channel].Image.ImageType = DXTextureImageType_PaletteIndexedColor) then
    begin
      FParamsFormat.idx_palette := FHasChannelImages[Channel].Image.idx_palette;
      Break;
    end;

  if FParamsFormat.ImageType = DXTextureImageType_PaletteIndexedColor then
  begin
    {  Index channel }
    if rgbRed in FHasChannels then
    begin
      BitCount := FHasChannelImages[rgbRed].BitCount;
      FParamsFormat.idx_index := dxtMakeChannel(((1 shl BitCount) - 1) shl FParamsFormat.BitCount, True);
      Inc(FParamsFormat.BitCount, BitCount);
    end;

    {  Alpha channel  }
    if rgbAlpha in FHasChannels then
    begin
      BitCount := FHasChannelImages[rgbAlpha].BitCount;
      FParamsFormat.idx_alpha := dxtMakeChannel(((1 shl BitCount) - 1) shl FParamsFormat.BitCount, False);
      Inc(FParamsFormat.BitCount, BitCount);
    end;
  end else
  begin
    {  B channel }
    if rgbBlue in FHasChannels then
    begin
      BitCount := FHasChannelImages[rgbBlue].BitCount;
      FParamsFormat.rgb_blue := dxtMakeChannel(((1 shl BitCount) - 1) shl FParamsFormat.BitCount, False);
      Inc(FParamsFormat.BitCount, BitCount);
    end;

    {  G channel }
    if rgbGreen in FHasChannels then
    begin
      BitCount := FHasChannelImages[rgbGreen].BitCount;
      FParamsFormat.rgb_green := dxtMakeChannel(((1 shl BitCount) - 1) shl FParamsFormat.BitCount, False);
      Inc(FParamsFormat.BitCount, BitCount);
    end;

    {  R channel }
    if rgbRed in FHasChannels then
    begin
      BitCount := FHasChannelImages[rgbRed].BitCount;
      FParamsFormat.rgb_red := dxtMakeChannel(((1 shl BitCount) - 1) shl FParamsFormat.BitCount, False);
      Inc(FParamsFormat.BitCount, BitCount);
    end;

    {  Alpha channel }
    if rgbAlpha in FHasChannels then
    begin
      BitCount := FHasChannelImages[rgbAlpha].BitCount;
      FParamsFormat.rgb_alpha := dxtMakeChannel(((1 shl BitCount) - 1) shl FParamsFormat.BitCount, False);
      Inc(FParamsFormat.BitCount, BitCount);
    end;
  end;

  {  As for the number of bits only either of 1, 2, 4, 8, 16, 24, 32  }
  if FParamsFormat.BitCount in [3] then
    FParamsFormat.BitCount := 4
  else if FParamsFormat.BitCount in [5..7] then
    FParamsFormat.BitCount := 8
  else if FParamsFormat.BitCount in [9..15] then
    FParamsFormat.BitCount := 16
  else if FParamsFormat.BitCount in [17..23] then
    FParamsFormat.BitCount := 24
  else if FParamsFormat.BitCount in [25..31] then
    FParamsFormat.BitCount := 32;

  {  Transparent color  }
  if (FParamsFormat.ImageType = DXTextureImageType_RGBColor) and (FParamsFormat.TransparentColor shr 24 = $01) then
  begin
    FParamsFormat.TransparentColor := RGB(FParamsFormat.idx_palette[Byte(FParamsFormat.TransparentColor)].peRed,
      FParamsFormat.idx_palette[Byte(FParamsFormat.TransparentColor)].peGreen,
      FParamsFormat.idx_palette[Byte(FParamsFormat.TransparentColor)].peBlue);
  end;
end;

procedure TDXTBase.LoadChannelRGBAFromFile(const FileName: string);
begin
  FStrImageFileName := FileName;
  try
    EvaluateChannels([rgbRed, rgbGreen, rgbBlue, rgbAlpha], '', '');
  finally
    FStrImageFileName := '';
  end;
end;

procedure TDXTBase.SetChannelB(T: TDIB);
begin
  FDIB := T;
  try
    EvaluateChannels([rgbBlue], '', '');
  finally
    FDIB := nil;
  end;
end;

procedure TDXTBase.SetChannelRGB(T: TDIB);
begin
  FDIB := T;
  try
    EvaluateChannels([rgbRed, rgbGreen, rgbBlue], '', '');
  finally
    FDIB := nil;
  end;
end;

procedure TDXTBase.SetChannelA(T: TDIB);
begin
  FDIB := T;
  try
    EvaluateChannels([rgbAlpha], '', '');
  finally
    FDIB := nil;
  end;
end;

procedure TDXTBase.SetChannelG(T: TDIB);
begin
  FDIB := T;
  try
    EvaluateChannels([rgbGreen], '', '');
  finally
    FDIB := nil;
  end;
end;

destructor TDXTBase.Destroy;
var I: Integer;
begin
  for I := 0 to FHasImageList.Count - 1 do
    TDXTextureImage(FHasImageList[I]).Free;
  FHasImageList.Free;
  inherited Destroy;
end;

function TDXTBase.GetPicture: TDXTextureImage;
var
  MemoryStream: TMemoryStream;
begin
  Result := TDXTextureImage.Create;
  try
    if (FStrImageFileName <> '') and FileExists(FStrImageFileName) then begin
      Result.LoadFromFile(FStrImageFileName);
      Result.FImageName := ExtractFilename(FStrImageFileName);
    end
    else
      if Assigned(FDIB) then begin
        MemoryStream := TMemoryStream.Create;
        try
          FDIB.SaveToStream(MemoryStream);
          MemoryStream.Position := 0; //reading from 0
          Result.LoadFromStream(MemoryStream);
        finally
          MemoryStream.Free;
        end;
        Result.FImageName := Format('DIB%x', [Integer(Result)]); //supplement name
      end;
  except
    on E: Exception do begin
      EDXTBaseError.Create(E.Message);
    end;
  end
end;

procedure TDXTBase.Resize(Image: TDXTextureImage; NewWidth, NewHeight: Integer;
  FilterTypeResample: TFilterTypeResample);
  //resize used for Mipmap
var
  DIB: TDIB;
  x, y: Integer;
  c: DWORD;
  MemoryStream: TMemoryStream;
begin
  {  Exit when no resize  }
  if (Image.Width = NewWidth) and (Image.Height = NewHeight) then Exit;
  {  Supplement for image resizing  }
  //raise EDXTBaseError.Create('Invalid image size for texture.');
  {  No image at start  }
  DIB := TDIB.Create; //DIB accept
  try
    DIB.SetSize(Image.Width, Image.Height, Image.BitCount);
    {  of type  }
    for y := 0 to Image.Height - 1 do
      for x := 0 to Image.Width - 1 do
      begin
        if Image.ImageType = DXTextureImageType_PaletteIndexedColor then
        begin
          c := dxtDecodeChannel(Image.idx_index, Image.Pixels[x, y]);
          DIB.Pixels[x, y] := (Image.idx_palette[c].peRed shl 16) or
            (Image.idx_palette[c].peGreen shl 8) or
            Image.idx_palette[c].peBlue;
        end
        else begin
          c := Image.Pixels[x, y];
          DIB.Pixels[x, y] := (dxtDecodeChannel(Image.rgb_red, c) shl 16) or
            (dxtDecodeChannel(Image.rgb_green, c) shl 8) or
            dxtDecodeChannel(Image.rgb_blue, c);
        end;
      end;

    {  Resize for 24 bitcount deep }
    Image.SetSize(DXTextureImageType_RGBColor, Width, Height, Image.BitCount, 0);

    Image.rgb_red := dxtMakeChannel($FF0000, False);
    Image.rgb_green := dxtMakeChannel($00FF00, False);
    Image.rgb_blue := dxtMakeChannel($0000FF, False);
    Image.rgb_alpha := dxtMakeChannel(0, False);

    {  Resample routine DIB based there  }
    DIB.DoResample(Width, Height, FilterTypeResample);

    {Image returned through stream}
    Image.ClearImage;
    MemoryStream := TMemoryStream.Create;
    try
      DIB.SaveToStream(MemoryStream);
      MemoryStream.Position := 0; //from first byte
      Image.LoadFromStream(MemoryStream);
    finally
      MemoryStream.Free;
    end;
  finally
    DIB.Free;
  end;
end;

procedure TDXTBase.EvaluateChannels
  (const CheckChannelUsed: TDXTImageChannels;
  const CheckChannelChanged, CheckBitCountForChannel: string);
var J: Integer;
  Channel: TDXTImageChannel;
  ChannelBitCount: array[TDXTImageChannel] of Integer;
  ChannelParamName: TDXTImageChannels;
  Image: TDXTextureImage;
  Q: TDXTImageChannel;
begin
  Fillchar(ChannelBitCount, SizeOf(ChannelBitCount), 0);
  ChannelParamName := [];
  {  The channel which you use acquisition  }
  J := 0;
  for Q := rgbRed to rgbAlpha do
  begin
    if Q in CheckChannelUsed then begin
      Inc(J);
      Channel := Q;
      if not (Channel in FHasChannels) then
      begin
        if CheckBitCountForChannel <> '' then
          ChannelBitCount[Channel] := StrToInt(Copy(CheckBitCountForChannel, j, 1))
        else
          ChannelBitCount[Channel] := 8; {poke default value}
        if ChannelBitCount[Channel] <> 0 then
          ChannelParamName := ChannelParamName + [Channel];

        if CheckChannelChanged <> '' then
        begin
          case UpCase(CheckChannelChanged[j]) of
            'R': FChannelChangeTable[Channel] := rgbRed;
            'G': FChannelChangeTable[Channel] := rgbGreen;
            'B': FChannelChangeTable[Channel] := rgbBlue;
            'Y': FChannelChangeTable[Channel] := yuvY;
            'N': FChannelChangeTable[Channel] := rgbNone;
          else
            raise EDXTBaseError.CreateFmt('Invalid channel type(%s)', [CheckChannelChanged[j]]);
          end;
        end;
      end;
    end;
  end;
  {  Processing of each  }
  if ChannelParamName <> [] then
  begin
    {  Picture load  }
    Image := nil;
    {pokud je image uz nahrany tj. stejneho jmena, pokracuj dale}
    for j := 0 to FHasImageList.Count - 1 do
      if AnsiCompareFileName(TDXTextureImage(FHasImageList[j]).ImageName, FStrImageFileName) = 0 then
      begin
        Image := FHasImageList[j];
        Break;
      end;
    {obrazek neexistuje, musi se dotahnout bud z proudu, souboru nebo odjinut}
    if Image = nil then
    begin
      try
        Image := GetPicture;
      except
        if Assigned(Image) then begin
          {$IFNDEF DelphiX_Spt4}
          Image.Free; Image := nil;
          {$ELSE}
          FreeAndNil(Image);
          {$ENDIF}
        end;
        raise;
      end;
      FHasImageList.Add(Image);
    end;

    {  Each channel processing  }
    for Channel := Low(Channel) to High(Channel) do
      if Channel in ChannelParamName then
      begin
        if ChannelBitCount[Channel] >= 0 then
          FHasChannelImages[Channel].BitCount := ChannelBitCount[Channel]
        else
        begin
          case Image.ImageType of
            DXTextureImageType_PaletteIndexedColor:
              begin
                case Channel of
                  rgbRed: FHasChannelImages[Channel].BitCount := 8;
                  rgbGreen: FHasChannelImages[Channel].BitCount := 8;
                  rgbBlue: FHasChannelImages[Channel].BitCount := 8;
                  rgbAlpha: FHasChannelImages[Channel].BitCount := 8;
                end;
              end;
            DXTextureImageType_RGBColor:
              begin
                case Channel of
                  rgbRed: FHasChannelImages[Channel].BitCount := Image.rgb_red.BitCount;
                  rgbGreen: FHasChannelImages[Channel].BitCount := Image.rgb_green.BitCount;
                  rgbBlue: FHasChannelImages[Channel].BitCount := Image.rgb_blue.BitCount;
                  rgbAlpha: FHasChannelImages[Channel].BitCount := 8;
                end;
              end;
          end;
        end;
        if FHasChannelImages[Channel].BitCount = 0 then Continue;
        FHasChannels := FHasChannels + [Channel];
        FHasChannelImages[Channel].Image := Image;
      end;
  end;
end;

function TDXTBase.GetTexture: TDXTextureImage;
var
  i, j: Integer;
  SubImage: TDXTextureImage;
  CurWidth, CurHeight: Integer;
begin
  Result := nil;
  if FHasImageList.Count = 0 then
    raise EDXTBaseError.Create('No image found');

  {  Output format calculation  }
  CalcOutputBitFormat;
  Result := TDXTextureImage.Create;
  try
    Result.SetSize(FParamsFormat.ImageType, FParamsFormat.Width, FParamsFormat.Height, FParamsFormat.BitCount, 0);

    Result.idx_index := FParamsFormat.idx_index;
    Result.idx_alpha := FParamsFormat.idx_alpha;
    Result.idx_palette := FParamsFormat.idx_palette;

    Result.rgb_red := FParamsFormat.rgb_red;
    Result.rgb_green := FParamsFormat.rgb_green;
    Result.rgb_blue := FParamsFormat.rgb_blue;
    Result.rgb_alpha := FParamsFormat.rgb_alpha;

    Result.ImageName := FParamsFormat.Name;

    Result.Transparent := FParamsFormat.Transparent;
    if FParamsFormat.TransparentColor shr 24 = $01 then
      Result.TransparentColor := dxtEncodeChannel(Result.idx_index, PaletteIndex(Byte(FParamsFormat.TransparentColor)))
    else
      Result.TransparentColor := Result.EncodeColor(GetRValue(FParamsFormat.TransparentColor), GetGValue(FParamsFormat.TransparentColor), GetBValue(FParamsFormat.TransparentColor), 0);

    BuildImage(Result);

    if FParamsFormat.ImageType = DXTextureImageType_RGBColor then
    begin
      BuildImage(Result);
      {  Picture information store here  }
      CurWidth := FParamsFormat.Width;
      CurHeight := FParamsFormat.Height;
      for i := 0 to FParamsFormat.MipmapCount - 1 do
      begin
        CurWidth := CurWidth div 2;
        CurHeight := CurHeight div 2;
        if (CurWidth <= 0) or (CurHeight <= 0) then Break;
        {  Resize calc here }
        for j := 0 to FHasImageList.Count - 1 do
          Resize(FHasImageList[j], CurWidth, CurHeight, ftrTriangle);

        SubImage := TDXTextureImage.CreateSub(Result);
        SubImage.SetSize(FParamsFormat.ImageType, CurWidth, CurHeight, FParamsFormat.BitCount, 0);

        SubImage.idx_index := FParamsFormat.idx_index;
        SubImage.idx_alpha := FParamsFormat.idx_alpha;
        SubImage.idx_palette := FParamsFormat.idx_palette;

        SubImage.rgb_red := FParamsFormat.rgb_red;
        SubImage.rgb_green := FParamsFormat.rgb_green;
        SubImage.rgb_blue := FParamsFormat.rgb_blue;
        SubImage.rgb_alpha := FParamsFormat.rgb_alpha;

        SubImage.ImageGroupType := DXTextureImageGroupType_Normal;
        SubImage.ImageID := i;
        SubImage.ImageName := Format('%s - mimap #%d', [Result.ImageName, i + 1]);

        BuildImage(SubImage);
      end;
    end;
    Result.FileCompressType := FParamsFormat.Compress;
  except
    on E: Exception do begin
      {$IFNDEF DelphiX_Spt4}
      Result.Free;
      Result := nil;
      {$ELSE}
      FreeAndNil(Result);
      {$ENDIF}
      raise EDXTBaseError.Create(E.Message);
    end;
  end;
end;

{ DIB2DTX }

procedure dib2dxt(DIBImage: TDIB; out DXTImage: TDXTextureImage);
var
  TexImage: TDXTBase;
  DIB: TDIB;
begin
  TexImage := TDXTBase.Create;
  try
    //TexImage.Compression := DXTextureImageFileCompressType_ZLIB;
    //TexImage.Mipmap := 4;
    try
      TexImage.SetChannelRGB(DIBImage);
      if DIBImage.HasAlphaChannel then begin
        DIB := DIBImage.AlphaChannel;
        TexImage.SetChannelA(DIB);
      end;

      DXTImage := TexImage.Texture;
    except
      if Assigned(DXTImage) then
        DXTImage.Free;
      DXTImage := nil;
    end;
  finally
    TexImage.Free;
  end
end;

{  TDirect3DRMUserVisual  }

procedure TDirect3DRMUserVisual_D3DRMOBJECTCALLBACK(lpD3DRMobj: IDirect3DRMObject;
  lpArg: Pointer); cdecl;
begin
  TDirect3DRMUserVisual(lpArg).Free;
end;

function TDirect3DRMUserVisual_D3DRMUSERVISUALCALLBACK(lpD3DRMUV: IDirect3DRMUserVisual;
  lpArg: Pointer; lpD3DRMUVreason: TD3DRMUserVisualReason;
  lpD3DRMDev: IDirect3DRMDevice; lpD3DRMview: IDirect3DRMViewport): Integer; cdecl;
begin
  Result := TDirect3DRMUserVisual(lpArg).DoRender(lpD3DRMUVreason, lpD3DRMDev, lpD3DRMview);
end;

constructor TDirect3DRMUserVisual.Create(D3DRM: IDirect3DRM);
begin
  inherited Create;

  if D3DRM.CreateUserVisual(@TDirect3DRMUserVisual_D3DRMUSERVISUALCALLBACK,
    Self, FUserVisual) <> D3DRM_OK then
    raise EDirect3DRMUserVisualError.CreateFmt(SCannotMade, ['IDirect3DRMUserVisual']);

  FUserVisual.AddDestroyCallback(@TDirect3DRMUserVisual_D3DRMOBJECTCALLBACK, Self);
end;

destructor TDirect3DRMUserVisual.Destroy;
begin
  if FUserVisual <> nil then
    FUserVisual.DeleteDestroyCallback(@TDirect3DRMUserVisual_D3DRMOBJECTCALLBACK, Self);
  FUserVisual := nil;
  inherited Destroy;
end;

function TDirect3DRMUserVisual.DoRender(Reason: TD3DRMUserVisualReason;
  D3DRMDev: IDirect3DRMDevice; D3DRMView: IDirect3DRMViewport): HRESULT;
begin
  Result := 0;
end;

{  TPictureCollectionItem  }

const
  SurfaceDivWidth = maxVideoBlockSize;
  SurfaceDivHeight = maxVideoBlockSize;

type
  TPictureCollectionItemPattern = class(TCollectionItem)
  private
    FRect: TRect;
    FSurface: TDirectDrawSurface;
  end;

constructor TPictureCollectionItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FPicture := TPicture.Create;
  FPatterns := TCollection.Create(TPictureCollectionItemPattern);
  FSurfaceList := TList.Create;
  FTransparent := True;
end;

destructor TPictureCollectionItem.Destroy;
begin
  Finalize;
  FPicture.Free;
  FPatterns.Free;
  FSurfaceList.Free;
  inherited Destroy;
end;

procedure TPictureCollectionItem.Assign(Source: TPersistent);
var
  PrevInitialized: Boolean;
begin
  if Source is TPictureCollectionItem then
  begin
    PrevInitialized := Initialized;
    Finalize;

    FPatternHeight := TPictureCollectionItem(Source).FPatternHeight;
    FPatternWidth := TPictureCollectionItem(Source).FPatternWidth;
    FSkipHeight := TPictureCollectionItem(Source).FSkipHeight;
    FSkipWidth := TPictureCollectionItem(Source).FSkipWidth;
    FSystemMemory := TPictureCollectionItem(Source).FSystemMemory;
    FTransparent := TPictureCollectionItem(Source).FTransparent;
    FTransparentColor := TPictureCollectionItem(Source).FTransparentColor;

    FPicture.Assign(TPictureCollectionItem(Source).FPicture);

    if PrevInitialized then
      Restore;
  end else
    inherited Assign(Source);
end;

procedure TPictureCollectionItem.ClearSurface;
var
  i: Integer;
begin
  FPatterns.Clear;
  for i := 0 to FSurfaceList.Count - 1 do
    TDirectDrawSurface(FSurfaceList[i]).Free;
  FSurfaceList.Clear;
end;

function TPictureCollectionItem.GetHeight: Integer;
begin
  Result := FPatternHeight;
  if (Result <= 0) then
    Result := FPicture.Height;
end;

function TPictureCollectionItem.GetPictureCollection: TPictureCollection;
begin
  Result := Collection as TPictureCollection;
end;

function TPictureCollectionItem.GetPatternRect(Index: Integer): TRect;
begin
  if (Index >= 0) and (index < FPatterns.Count) then
    Result := TPictureCollectionItemPattern(FPatterns.Items[Index]).FRect
  else
    Result := Rect(0, 0, 0, 0);
end;

function TPictureCollectionItem.GetPatternSurface(Index: Integer): TDirectDrawSurface;
begin
  if (Index >= 0) and (index < FPatterns.Count) then
    Result := TPictureCollectionItemPattern(FPatterns.Items[Index]).FSurface
  else
    Result := nil;
end;

function TPictureCollectionItem.GetPatternCount: Integer;
var
  XCount, YCount: Integer;
begin
  if FSurfaceList.Count = 0 then
  begin
    XCount := FPicture.Width div (PatternWidth + SkipWidth);
    if FPicture.Width - XCount * (PatternWidth + SkipWidth) = PatternWidth then
      Inc(XCount);

    YCount := FPicture.Height div (PatternHeight + SkipHeight);
    if FPicture.Height - YCount * (PatternHeight + SkipHeight) = PatternHeight then
      Inc(YCount);

    Result := XCount * YCount;
  end else
    Result := FPatterns.Count;
end;

function TPictureCollectionItem.GetWidth: Integer;
begin
  Result := FPatternWidth;
  if (Result <= 0) then
    Result := FPicture.Width;
end;

procedure TPictureCollectionItem.Draw(Dest: TDirectDrawSurface; X, Y,
  PatternIndex: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
{$IFDEF DrawHWAcc}
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRender(Self, Bounds(X, Y, Width, Height), PatternIndex, rtDraw{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
      end
      else
{$ENDIF DrawHWAcc}
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.Draw(X, Y, FRect, FSurface, Transparent);
  end;
end;

procedure TPictureCollectionItem.DrawFlipHV(Dest: TDirectDrawSurface; X, Y,
  PatternIndex: Integer);
var
  flrc: trect;
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
    begin
      flrc.Left := frect.right; flrc.Right := frect.left;
      flrc.Top := fpicture.height - frect.top;
      flrc.Bottom := fpicture.height - frect.bottom;
      Dest.Draw(X, Y, Flrc, FSurface, Transparent);
    end;
end;

procedure TPictureCollectionItem.DrawFlipH(Dest: TDirectDrawSurface; X, Y,
  PatternIndex: Integer);
var
  flrc: trect;
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
    begin
      flrc.Left := fpicture.width - frect.left; flrc.Right := fpicture.width - frect.right;
      flrc.Top := frect.Top; flrc.Bottom := frect.Bottom;
      Dest.Draw(X, Y, Flrc, FSurface, Transparent);
    end;
end;

procedure TPictureCollectionItem.DrawFlipV(Dest: TDirectDrawSurface; X, Y,
  PatternIndex: Integer);
var
  flrc: trect;
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
    begin
      flrc.Left := frect.left; flrc.Right := frect.right;
      flrc.Top := fpicture.height - frect.top;
      flrc.Bottom := fpicture.height - frect.bottom;
      Dest.Draw(X, Y, Flrc, FSurface, Transparent);
    end;
end;

procedure TPictureCollectionItem.StretchDraw(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
{$IFDEF DrawHWAcc}
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRender(Self, DestRect, PatternIndex, rtDraw{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF})
      end
      else
{$ENDIF DrawHWAcc}
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.StretchDraw(DestRect, FRect, FSurface, Transparent);
  end;
end;

procedure TPictureCollectionItem.DrawAdd(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
  Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRender(Self, DestRect, PatternIndex, rtAdd, Alpha)
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawAdd(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawAddCol(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
  Color: Integer; Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderCol(Self, DestRect, PatternIndex, Color, rtAdd, Alpha)
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawAdd(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawAlpha(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
  Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRender(Self, DestRect, PatternIndex, rtBlend, Alpha)
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawAlpha(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawSub(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
  Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRender(Self, DestRect, PatternIndex, rtSub, Alpha)
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawSub(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawSubCol(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
  Color: Integer; Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderCol(Self, DestRect, PatternIndex, Color, rtSub, Alpha)
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawSub(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotate(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  CenterX, CenterY: Double; Angle: single);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.FD2D.FDDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
      //X,Y................ Center of rotation
      //Width,Height....... Picture
      //PatternIndex....... Piece of picture
      //CenterX,CenterY ... Center of rotation on picture
      //Angle.............. Angle of rotation
          FDXDraw.FD2D.D2DRenderRotate(Self, X, Y, Width, Height, PatternIndex, rtDraw, CenterX, CenterY, Angle{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawRotate(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle);
  end;
end;

procedure TPictureCollectionItem.DrawRotateAdd(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  CenterX, CenterY: Double; Angle: single; Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderRotate(Self, X, Y, Width, Height, PatternIndex, rtAdd, CenterX, CenterY, Angle, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawRotateAdd(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotateAlpha(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  CenterX, CenterY: Double; Angle: single; Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderRotate(Self, X, Y, Width, Height, PatternIndex, rtBlend, CenterX, CenterY, Angle, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawRotateAlpha(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotateSub(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  CenterX, CenterY: Double; Angle: single; Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderRotate(Self, X, Y, Width, Height, PatternIndex, rtSub, CenterX, CenterY, Angle, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawRotateSub(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawWaveX(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  amp, Len, ph: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderWaveX(Self, X, Y, Width, Height, PatternIndex, rtDraw,
            Transparent, amp, Len, ph{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawWaveX(X, Y, Width, Height, FRect, FSurface, Transparent, amp, Len, ph);
  end;
end;

procedure TPictureCollectionItem.DrawWaveXAdd(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderWaveX(Self, X, Y, Width, Height, PatternIndex, rtAdd,
            Transparent, amp, Len, ph, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawWaveXAdd(X, Y, Width, Height, FRect, FSurface, Transparent, amp, Len, ph, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawWaveXAlpha(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderWaveX(Self, X, Y, Width, Height, PatternIndex, rtBlend,
            Transparent, amp, Len, ph, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawWaveXAlpha(X, Y, Width, Height, FRect, FSurface, Transparent, amp, Len, ph, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawWaveXSub(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderWaveX(Self, X, Y, Width, Height, PatternIndex, rtSub,
            Transparent, amp, Len, ph, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawWaveXSub(X, Y, Width, Height, FRect, FSurface, Transparent, amp, Len, ph, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawWaveYSub(Dest: TDirectDrawSurface; X, Y,
  Width, Height, PatternIndex, amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderWaveY(Self, X, Y, Width, Height, PatternIndex, rtSub,
            Transparent, amp, Len, ph{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
      end
  end;
end;

procedure TPictureCollectionItem.DrawWaveY(Dest: TDirectDrawSurface; X, Y,
  Width, Height, PatternIndex, amp, Len, ph: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderWaveY(Self, X, Y, Width, Height, PatternIndex, rtDraw,
            Transparent, amp, Len, ph{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
      end
  end;
end;

procedure TPictureCollectionItem.DrawWaveYAdd(Dest: TDirectDrawSurface; X, Y,
  Width, Height, PatternIndex, amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderWaveY(Self, X, Y, Width, Height, PatternIndex, rtAdd,
            Transparent, amp, Len, ph{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
      end
  end;
end;

procedure TPictureCollectionItem.DrawWaveYAlpha(Dest: TDirectDrawSurface; X, Y,
  Width, Height, PatternIndex, amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderWaveY(Self, X, Y, Width, Height, PatternIndex, rtBlend,
            Transparent, amp, Len, ph{$IFNDEF DelphiX_Spt4}, $FF{$ENDIF});
      end
  end;
end;

procedure TPictureCollectionItem.Finalize;
begin
  if FInitialized then
  begin
    FInitialized := False;
    ClearSurface;
  end;
end;

procedure TPictureCollectionItem.Initialize;
begin
  Finalize;
  FInitialized := PictureCollection.Initialized;
end;

procedure TPictureCollectionItem.Restore;

  function AddSurface(const SrcRect: TRect): TDirectDrawSurface;
  begin
    Result := TDirectDrawSurface.Create(PictureCollection.DXDraw.DDraw);
    FSurfaceList.Add(Result);

    Result.SystemMemory := FSystemMemory;
    Result.LoadFromGraphicRect(FPicture.Graphic, 0, 0, SrcRect);
    Result.TransparentColor := Result.ColorMatch(FTransparentColor);
  end;

var
  x, y, x2, y2: Integer;
  BlockWidth, BlockHeight, BlockXCount, BlockYCount: Integer;
  Width2, Height2: Integer;
begin
  if FPicture.Graphic = nil then Exit;

  if not FInitialized then
  begin
    if PictureCollection.Initialized then
      Initialize;
    if not FInitialized then Exit;
  end;

  ClearSurface;

  Width2 := Width + SkipWidth;
  Height2 := Height + SkipHeight;

  if (Width = FPicture.Width) and (Height = FPicture.Height) then
  begin
    {  There is no necessity of division because the number of patterns is one.   }
    with TPictureCollectionItemPattern.Create(FPatterns) do
    begin
      FRect := Bounds(0, 0, FPicture.Width, FPicture.Height);
      FSurface := AddSurface(Bounds(0, 0, FPicture.Width, FPicture.Height));
    end;
  end else if FSystemMemory then
  begin
    {  Load to a system memory.  }
    AddSurface(Bounds(0, 0, FPicture.Width, FPicture.Height));

    for y := 0 to (FPicture.Height + SkipHeight) div Height2 - 1 do
      for x := 0 to (FPicture.Width + SkipWidth) div Width2 - 1 do
        with TPictureCollectionItemPattern.Create(FPatterns) do
        begin
          FRect := Bounds(x * Width2, y * Height2, Width, Height);
          FSurface := TDirectDrawSurface(FSurfaceList[0]);
        end;
  end else
  begin
    {  Load to a video memory with dividing the image.   }
    BlockWidth := Min(((SurfaceDivWidth + Width2 - 1) div Width2) * Width2,
      (FPicture.Width + SkipWidth) div Width2 * Width2);
    BlockHeight := Min(((SurfaceDivHeight + Height2 - 1) div Height2) * Height2,
      (FPicture.Height + SkipHeight) div Height2 * Height2);

    if (BlockWidth = 0) or (BlockHeight = 0) then Exit;

    BlockXCount := (FPicture.Width + BlockWidth - 1) div BlockWidth;
    BlockYCount := (FPicture.Height + BlockHeight - 1) div BlockHeight;

    for y := 0 to BlockYCount - 1 do
      for x := 0 to BlockXCount - 1 do
      begin
        x2 := Min(BlockWidth, Max(FPicture.Width - x * BlockWidth, 0));
        if x2 = 0 then x2 := BlockWidth;

        y2 := Min(BlockHeight, Max(FPicture.Height - y * BlockHeight, 0));
        if y2 = 0 then y2 := BlockHeight;

        AddSurface(Bounds(x * BlockWidth, y * BlockHeight, x2, y2));
      end;

    for y := 0 to (FPicture.Height + SkipHeight) div Height2 - 1 do
      for x := 0 to (FPicture.Width + SkipWidth) div Width2 - 1 do
      begin
        x2 := x * Width2;
        y2 := y * Height2;
        with TPictureCollectionItemPattern.Create(FPatterns) do
        begin
          FRect := Bounds(x2 - (x2 div BlockWidth * BlockWidth), y2 - (y2 div BlockHeight * BlockHeight), Width, Height);
          FSurface := TDirectDrawSurface(FSurfaceList[(x2 div BlockWidth) + ((y2 div BlockHeight) * BlockXCount)]);
        end;
      end;
  end;
  {Code added for better compatibility}
  {When is any picture changed, then all textures cleared and list have to reloaded}
  with PictureCollection do
    if (do3D in FDXDraw.Options) then
      if AsSigned(FDXDraw.FD2D) then
        FDXDraw.FD2D.D2DPruneAllTextures;
end;

procedure TPictureCollectionItem.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TPictureCollectionItem.SetTransparentColor(Value: TColor);
var
  i: Integer;
  Surface: TDirectDrawSurface;
begin
  if Value <> FTransparentColor then
  begin
    FTransparentColor := Value;
    for i := 0 to FSurfaceList.Count - 1 do
    begin
      try
        Surface := TDirectDrawSurface(FSurfaceList[i]);
        Surface.TransparentColor := Surface.ColorMatch(FTransparentColor);
      except
      end;
    end;
  end;
end;

procedure TPictureCollectionItem.DrawAlphaCol(Dest: TDirectDrawSurface;
  const DestRect: TRect; PatternIndex, Color, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderCol(Self, DestRect, PatternIndex, color, rtBlend, Alpha)
      end else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawAlpha(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotateAddCol(Dest: TDirectDrawSurface;
  X, Y, Width, Height, PatternIndex: Integer; CenterX, CenterY: Double;
  Angle: single; Color, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderRotateModeCol(Self, rtAdd, X, Y, Width,
            Height, PatternIndex, CenterX, CenterY, Angle, Color, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawRotateAdd(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotateAlphaCol(Dest: TDirectDrawSurface;
  X, Y, Width, Height, PatternIndex: Integer; CenterX, CenterY: Double;
  Angle: single; Color, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderRotateModeCol(Self, rtBlend, X, Y, Width,
            Height, PatternIndex, CenterX, CenterY, Angle, Color, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawRotateAlpha(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotateSubCol(Dest: TDirectDrawSurface;
  X, Y, Width, Height, PatternIndex: Integer; CenterX, CenterY: Double;
  Angle: single; Color, Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderRotateModeCol(Self, rtSub, X, Y, Width,
            Height, PatternIndex, CenterX, CenterY, Angle, Color, Alpha);
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawRotateSub(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawCol(Dest: TDirectDrawSurface;
  const DestRect, SourceRect: TRect; PatternIndex: Integer; Faded: Boolean;
  RenderType: TRenderType; Color, Specular: Integer; Alpha: Integer);
begin
  if FInitialized and (PatternIndex >= 0) and (PatternIndex < FPatterns.Count) then
  begin
    with TPictureCollection(Self.GetPictureCollection) do
      if (do3D in FDXDraw.Options) then begin
        if FDXDraw.FD2D.FDDraw.FSurface = Dest then
          FDXDraw.FD2D.D2DRenderColoredPartition(Self, DestRect, PatternIndex,
            Color, Specular, Faded, SourceRect, RenderType,
            Alpha)
      end
      else
        with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
          Dest.DrawAlpha(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;


{  TPictureCollection  }

constructor TPictureCollection.Create(AOwner: TPersistent);
begin
  inherited Create(TPictureCollectionItem);
  FOwner := AOwner;
end;

destructor TPictureCollection.Destroy;
begin
  Finalize;
  inherited Destroy;
end;

function TPictureCollection.GetItem(Index: Integer): TPictureCollectionItem;
begin
  Result := TPictureCollectionItem(inherited Items[Index]);
end;

function TPictureCollection.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TPictureCollection.Find(const Name: string): TPictureCollectionItem;
var
  i: Integer;
begin
  i := IndexOf(Name);
  if i = -1 then
    raise EPictureCollectionError.CreateFmt(SImageNotFound, [Name]);
  Result := Items[i];
end;

procedure TPictureCollection.Finalize;
var
  i: Integer;
begin
  try
    for i := 0 to Count - 1 do
      Items[i].Finalize;
  finally
    FDXDraw := nil;
  end;
end;

procedure TPictureCollection.Initialize(DXDraw: TCustomDXDraw);
var
  i: Integer;
begin
  Finalize;
  FDXDraw := DXDraw;

  if not Initialized then
    raise EPictureCollectionError.CreateFmt(SCannotInitialized, [ClassName]);

  for i := 0 to Count - 1 do
    Items[i].Initialize;
end;

function TPictureCollection.Initialized: Boolean;
begin
  Result := (FDXDraw <> nil) and (FDXDraw.Initialized);
end;

procedure TPictureCollection.Restore;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Restore;
end;

procedure TPictureCollection.MakeColorTable;
var
  UseColorTable: array[0..255] of Boolean;
  PaletteCount: Integer;

  procedure SetColor(Index: Integer; Col: TRGBQuad);
  begin
    UseColorTable[Index] := True;
    ColorTable[Index] := Col;
    Inc(PaletteCount);
  end;

  procedure AddColor(Col: TRGBQuad);
  var
    i: Integer;
  begin
    for i := 0 to 255 do
      if UseColorTable[i] then
        if DWORD(ColorTable[i]) = DWORD(Col) then
          Exit;
    for i := 0 to 255 do
      if not UseColorTable[i] then
      begin
        SetColor(i, Col);
        Exit;
      end;
  end;

  procedure AddDIB(DIB: TDIB);
  var
    i: Integer;
  begin
    if DIB.BitCount > 8 then Exit;

    for i := 0 to 255 do
      AddColor(DIB.ColorTable[i]);
  end;

  procedure AddGraphic(Graphic: TGraphic);
  var
    i, n: Integer;
    PaletteEntries: TPaletteEntries;
  begin
    if Graphic.Palette <> 0 then
    begin
      n := GetPaletteEntries(Graphic.Palette, 0, 256, PaletteEntries);
      for i := 0 to n - 1 do
        AddColor(PaletteEntryToRGBQuad(PaletteEntries[i]));
    end;
  end;

var
  i: Integer;
begin
  FillChar(UseColorTable, SizeOf(UseColorTable), 0);
  FillChar(ColorTable, SizeOf(ColorTable), 0);

  PaletteCount := 0;

  {  The system color is included.  }
  SetColor(0, RGBQuad(0, 0, 0));
  SetColor(1, RGBQuad(128, 0, 0));
  SetColor(2, RGBQuad(0, 128, 0));
  SetColor(3, RGBQuad(128, 128, 0));
  SetColor(4, RGBQuad(0, 0, 128));
  SetColor(5, RGBQuad(128, 0, 128));
  SetColor(6, RGBQuad(0, 128, 128));
  SetColor(7, RGBQuad(192, 192, 192));

  SetColor(248, RGBQuad(128, 128, 128));
  SetColor(249, RGBQuad(255, 0, 0));
  SetColor(250, RGBQuad(0, 255, 0));
  SetColor(251, RGBQuad(255, 255, 0));
  SetColor(252, RGBQuad(0, 0, 255));
  SetColor(253, RGBQuad(255, 0, 255));
  SetColor(254, RGBQuad(0, 255, 255));
  SetColor(255, RGBQuad(255, 255, 255));

  for i := 0 to Count - 1 do
    if Items[i].Picture.Graphic <> nil then
    begin
      if Items[i].Picture.Graphic is TDIB then
        AddDIB(TDIB(Items[i].Picture.Graphic))
      else
        AddGraphic(Items[i].Picture.Graphic);
      if PaletteCount = 256 then Break;
    end;
end;

procedure TPictureCollection.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('ColorTable', ReadColorTable, WriteColorTable, True);
end;

type
  TPictureCollectionComponent = class(TComponent)
  private
    FList: TPictureCollection;
  published
    property List: TPictureCollection read FList write FList;
  end;

procedure TPictureCollection.LoadFromFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TPictureCollection.LoadFromStream(Stream: TStream);
var
  Component: TPictureCollectionComponent;
begin
  Clear;
  Component := TPictureCollectionComponent.Create(nil);
  try
    Component.FList := Self;
    Stream.ReadComponentRes(Component);

    if Initialized then
    begin
      Initialize(FDXDraw);
      Restore;
    end;
  finally
    Component.Free;
  end;
end;

procedure TPictureCollection.SaveToFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TPictureCollection.SaveToStream(Stream: TStream);
var
  Component: TPictureCollectionComponent;
begin
  Component := TPictureCollectionComponent.Create(nil);
  try
    Component.FList := Self;
    Stream.WriteComponentRes('DelphiXPictureCollection', Component);
  finally
    Component.Free;
  end;
end;

procedure TPictureCollection.ReadColorTable(Stream: TStream);
begin
  Stream.ReadBuffer(ColorTable, SizeOf(ColorTable));
end;

procedure TPictureCollection.WriteColorTable(Stream: TStream);
begin
  Stream.WriteBuffer(ColorTable, SizeOf(ColorTable));
end;

{  TCustomDXImageList  }

constructor TCustomDXImageList.Create(AOnwer: TComponent);
begin
  inherited Create(AOnwer);
  FItems := TPictureCollection.Create(Self);
end;

destructor TCustomDXImageList.Destroy;
begin
  DXDraw := nil;
  FItems.Free;
  inherited Destroy;
end;

procedure TCustomDXImageList.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (DXDraw = AComponent) then
    DXDraw := nil;
end;

procedure TCustomDXImageList.DXDrawNotifyEvent(Sender: TCustomDXDraw;
  NotifyType: TDXDrawNotifyType);
begin
  case NotifyType of
    dxntDestroying: DXDraw := nil;
    dxntInitialize: FItems.Initialize(Sender);
    dxntFinalize: FItems.Finalize;
    dxntRestore: FItems.Restore;
  end;
end;

procedure TCustomDXImageList.SetDXDraw(Value: TCustomDXDraw);
begin
  if FDXDraw <> nil then
    FDXDraw.UnRegisterNotifyEvent(DXDrawNotifyEvent);

  FDXDraw := Value;

  if FDXDraw <> nil then
    FDXDraw.RegisterNotifyEvent(DXDrawNotifyEvent);
end;

procedure TCustomDXImageList.SetItems(Value: TPictureCollection);
begin
  FItems.Assign(Value);
end;

{  TDirectDrawOverlay  }

constructor TDirectDrawOverlay.Create(DDraw: TDirectDraw; TargetSurface: TDirectDrawSurface);
begin
  inherited Create;
  FDDraw := DDraw;
  FTargetSurface := TargetSurface;
  FVisible := True;
end;

constructor TDirectDrawOverlay.CreateWindowed(WindowHandle: HWND);
const
  PrimaryDesc: TDDSurfaceDesc = (
    dwSize: SizeOf(PrimaryDesc);
    dwFlags: DDSD_CAPS;
    ddsCaps: (dwCaps: DDSCAPS_PRIMARYSURFACE)
    );
begin
  FDDraw2 := TDirectDraw.CreateEx(nil, False);
  if FDDraw2.IDraw.SetCooperativeLevel(WindowHandle, DDSCL_NORMAL) <> DD_OK then
    raise EDirectDrawOverlayError.CreateFmt(SCannotInitialized, [SOverlay]);

  FTargetSurface2 := TDirectDrawSurface.Create(FDDraw2);
  if not FTargetSurface2.CreateSurface(PrimaryDesc) then
    raise EDirectDrawOverlayError.CreateFmt(SCannotInitialized, [SOverlay]);

  Create(FDDraw2, FTargetSurface2);
end;

destructor TDirectDrawOverlay.Destroy;
begin
  Finalize;
  FTargetSurface2.Free;
  FDDraw2.Free;
  inherited Destroy;
end;

procedure TDirectDrawOverlay.Finalize;
begin
  FBackSurface.Free; FBackSurface := nil;
  FSurface.Free; FSurface := nil;
end;

procedure TDirectDrawOverlay.Initialize(const SurfaceDesc: TDDSurfaceDesc);
const
  BackBufferCaps: TDDSCaps = (dwCaps: DDSCAPS_BACKBUFFER);
var
  DDSurface: IDirectDrawSurface;
begin
  Finalize;
  try
    FSurface := TDirectDrawSurface.Create(FDDraw);
    if not FSurface.CreateSurface(SurfaceDesc) then
      raise EDirectDrawOverlayError.CreateFmt(SCannotInitialized, [SOverlay]);

    FBackSurface := TDirectDrawSurface.Create(FDDraw);

    if SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_FLIP <> 0 then
    begin
      if FSurface.ISurface.GetAttachedSurface(BackBufferCaps, DDSurface) = DD_OK then
        FBackSurface.IDDSurface := DDSurface;
    end else
      FBackSurface.IDDSurface := FSurface.IDDSurface;

    if FVisible then
      SetOverlayRect(FOverlayRect)
    else
      FSurface.ISurface.UpdateOverlay(PRect(nil), FTargetSurface.ISurface, PRect(nil), DDOVER_HIDE, PDDOverlayFX(nil));
  except
    Finalize;
    raise;
  end;
end;

procedure TDirectDrawOverlay.Flip;
begin
  if FSurface = nil then Exit;

  if FSurface.SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_FLIP <> 0 then
    FSurface.ISurface.Flip(nil, DDFLIP_WAIT);
end;

procedure TDirectDrawOverlay.SetOverlayColorKey(Value: TColor);
begin
  FOverlayColorKey := Value;
  if FSurface <> nil then
    SetOverlayRect(FOverlayRect);
end;

procedure TDirectDrawOverlay.SetOverlayRect(const Value: TRect);
var
  DestRect, SrcRect: TRect;
  XScaleRatio, YScaleRatio: Integer;
  OverlayFX: TDDOverlayFX;
  OverlayFlags: DWORD;
begin
  FOverlayRect := Value;
  if (FSurface <> nil) and FVisible then
  begin
    DestRect := FOverlayRect;
    SrcRect.Left := 0;
    SrcRect.Top := 0;
    SrcRect.Right := FSurface.SurfaceDesc.dwWidth;
    SrcRect.Bottom := FSurface.SurfaceDesc.dwHeight;

    OverlayFlags := DDOVER_SHOW;

    FillChar(OverlayFX, SizeOf(OverlayFX), 0);
    OverlayFX.dwSize := SizeOf(OverlayFX);

    {  Scale rate limitation  }
    XScaleRatio := (DestRect.right - DestRect.left) * 1000 div (SrcRect.right - SrcRect.left);
    YScaleRatio := (DestRect.bottom - DestRect.top) * 1000 div (SrcRect.bottom - SrcRect.top);

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_OVERLAYSTRETCH <> 0) and
      (FDDraw.DriverCaps.dwMinOverlayStretch <> 0) and (XScaleRatio < Integer(FDDraw.DriverCaps.dwMinOverlayStretch)) then
    begin
      DestRect.Right := DestRect.Left + (Integer(FSurface.SurfaceDesc.dwWidth) * (Integer(FDDraw.DriverCaps.dwMinOverlayStretch) + 1)) div 1000;
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_OVERLAYSTRETCH <> 0) and
      (FDDraw.DriverCaps.dwMaxOverlayStretch <> 0) and (XScaleRatio > Integer(FDDraw.DriverCaps.dwMaxOverlayStretch)) then
    begin
      DestRect.Right := DestRect.Left + (Integer(FSurface.SurfaceDesc.dwWidth) * (Integer(FDDraw.DriverCaps.dwMaxOverlayStretch) + 999)) div 1000;
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_OVERLAYSTRETCH <> 0) and
      (FDDraw.DriverCaps.dwMinOverlayStretch <> 0) and (YScaleRatio < Integer(FDDraw.DriverCaps.dwMinOverlayStretch)) then
    begin
      DestRect.Bottom := DestRect.Top + (Integer(FSurface.SurfaceDesc.dwHeight) * (Integer(FDDraw.DriverCaps.dwMinOverlayStretch) + 1)) div 1000;
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_OVERLAYSTRETCH <> 0) and
      (FDDraw.DriverCaps.dwMaxOverlayStretch <> 0) and (YScaleRatio > Integer(FDDraw.DriverCaps.dwMaxOverlayStretch)) then
    begin
      DestRect.Bottom := DestRect.Top + (Integer(FSurface.SurfaceDesc.dwHeight) * (Integer(FDDraw.DriverCaps.dwMaxOverlayStretch) + 999)) div 1000;
    end;

    {  Clipping at forwarding destination  }
    XScaleRatio := (DestRect.Right - DestRect.Left) * 1000 div (SrcRect.Right - SrcRect.Left);
    YScaleRatio := (DestRect.Bottom - DestRect.Top) * 1000 div (SrcRect.Bottom - SrcRect.Top);

    if DestRect.Top < 0 then
    begin
      SrcRect.Top := -DestRect.Top * 1000 div YScaleRatio;
      DestRect.Top := 0;
    end;

    if DestRect.Left < 0 then
    begin
      SrcRect.Left := -DestRect.Left * 1000 div XScaleRatio;
      DestRect.Left := 0;
    end;

    if DestRect.Right > Integer(FTargetSurface.SurfaceDesc.dwWidth) then
    begin
      SrcRect.Right := Integer(FSurface.SurfaceDesc.dwWidth) - ((DestRect.Right - Integer(FTargetSurface.SurfaceDesc.dwWidth)) * 1000 div XScaleRatio);
      DestRect.Right := FTargetSurface.SurfaceDesc.dwWidth;
    end;

    if DestRect.Bottom > Integer(FTargetSurface.SurfaceDesc.dwHeight) then
    begin
      SrcRect.Bottom := Integer(FSurface.SurfaceDesc.dwHeight) - ((DestRect.Bottom - Integer(FTargetSurface.SurfaceDesc.dwHeight)) * 1000 div YScaleRatio);
      DestRect.Bottom := FTargetSurface.SurfaceDesc.dwHeight;
    end;

    {  Forwarding former arrangement  }
    if (FDDraw.DriverCaps.dwCaps and DDCAPS_ALIGNBOUNDARYSRC <> 0) and (FDDraw.DriverCaps.dwAlignBoundarySrc <> 0) then
    begin
      SrcRect.Left := (SrcRect.Left + Integer(FDDraw.DriverCaps.dwAlignBoundarySrc) div 2) div
        Integer(FDDraw.DriverCaps.dwAlignBoundarySrc) * Integer(FDDraw.DriverCaps.dwAlignBoundarySrc);
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_ALIGNSIZESRC <> 0) and (FDDraw.DriverCaps.dwAlignSizeSrc <> 0) then
    begin
      SrcRect.Right := SrcRect.Left + (SrcRect.Right - SrcRect.Left + Integer(FDDraw.DriverCaps.dwAlignSizeSrc) div 2) div
        Integer(FDDraw.DriverCaps.dwAlignSizeSrc) * Integer(FDDraw.DriverCaps.dwAlignSizeSrc);
    end;

    {  Forwarding destination arrangement  }
    if (FDDraw.DriverCaps.dwCaps and DDCAPS_ALIGNBOUNDARYDEST <> 0) and (FDDraw.DriverCaps.dwAlignBoundaryDest <> 0) then
    begin
      DestRect.Left := (DestRect.Left + Integer(FDDraw.DriverCaps.dwAlignBoundaryDest) div 2) div
        Integer(FDDraw.DriverCaps.dwAlignBoundaryDest) * Integer(FDDraw.DriverCaps.dwAlignBoundaryDest);
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_ALIGNSIZEDEST <> 0) and (FDDraw.DriverCaps.dwAlignSizeDest <> 0) then
    begin
      DestRect.Right := DestRect.Left + (DestRect.Right - DestRect.Left) div
        Integer(FDDraw.DriverCaps.dwAlignSizeDest) * Integer(FDDraw.DriverCaps.dwAlignSizeDest);
    end;

    {  Color key setting  }
    if FDDraw.DriverCaps.dwCKeyCaps and DDCKEYCAPS_DESTOVERLAY <> 0 then
    begin
      OverlayFX.dckDestColorkey.dwColorSpaceLowValue := FTargetSurface.ColorMatch(FOverlayColorKey);
      OverlayFX.dckDestColorkey.dwColorSpaceHighValue := OverlayFX.dckDestColorkey.dwColorSpaceLowValue;

      OverlayFlags := OverlayFlags or (DDOVER_KEYDESTOVERRIDE or DDOVER_DDFX);
    end;

    FSurface.ISurface.UpdateOverlay(@SrcRect, FTargetSurface.ISurface, @DestRect, OverlayFlags, @OverlayFX);
  end;
end;

procedure TDirectDrawOverlay.SetVisible(Value: Boolean);
begin
  FVisible := False;
  if FSurface <> nil then
  begin
    if FVisible then
      SetOverlayRect(FOverlayRect)
    else
      FSurface.ISurface.UpdateOverlay(PRect(nil), FTargetSurface.ISurface, PRect(nil), DDOVER_HIDE, PDDOverlayFX(nil));
  end;
end;

{ TDXFont }

constructor TDXFont.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TDXFont.Destroy;
begin
  inherited Destroy;
end;

procedure TDXFont.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDXImageList) then
  begin
    FDXImageList := nil;
  end;
end; {Notification}

procedure TDXFont.SetFont(const Value: string);
begin
  FFont := Value;
  if assigned(FDXImageList) then
  begin
    FFontIndex := FDXImageList.items.IndexOf(FFont); { find font once }
    fOffset := FDXImageList.Items[FFontIndex].PatternWidth;
  end;
end;

procedure TDXFont.SetFontIndex(const Value: Integer);
begin
  FFontIndex := Value;
  if assigned(FDXImageList) then
  begin
    FFont := FDXImageList.Items[FFontIndex].Name;
    fOffset := FDXImageList.Items[FFontIndex].PatternWidth;
  end;
end;

procedure TDXFont.TextOut(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string);
var
  loop, letter: integer;
  UpperText: string;
begin
  if not assigned(FDXImageList) then
    exit;
  Offset := FDXImageList.Items[FFontIndex].PatternWidth;
  UpperText := AnsiUppercase(text);
  for loop := 1 to Length(UpperText) do
  begin
    letter := AnsiPos(UpperText[loop], Alphabet) - 1;
    if letter < 0 then letter := 30;
    FDXImageList.items[FFontIndex].Draw(DirectDrawSurface, x + Offset * loop, y, letter);
  end; { loop }
end;

{ TDXPowerFontEffectsParameters }

procedure TDXPowerFontEffectsParameters.SetAlphaValue(
  const Value: Integer);
begin
  FAlphaValue := Value;
end;

procedure TDXPowerFontEffectsParameters.SetAngle(const Value: Integer);
begin
  FAngle := Value;
end;

procedure TDXPowerFontEffectsParameters.SetCenterX(const Value: Integer);
begin
  FCenterX := Value;
end;

procedure TDXPowerFontEffectsParameters.SetCenterY(const Value: Integer);
begin
  FCenterY := Value;
end;

procedure TDXPowerFontEffectsParameters.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TDXPowerFontEffectsParameters.SetWAmplitude(
  const Value: Integer);
begin
  FWAmplitude := Value;
end;

procedure TDXPowerFontEffectsParameters.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

procedure TDXPowerFontEffectsParameters.SetWLenght(const Value: Integer);
begin
  FWLenght := Value;
end;

procedure TDXPowerFontEffectsParameters.SetWPhase(const Value: Integer);
begin
  FWPhase := Value;
end;

{ TDXPowerFont }

constructor TDXPowerFont.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FUseEnterChar := True;
  FEnterCharacter := '|<';
  FAlphabets := PowerAlphaBet;
  FTextOutType := ttNormal;
  FTextOutEffect := teNormal;
  FEffectsParameters := TDXPowerFontEffectsParameters.Create;
end;

destructor TDXPowerFont.Destroy;
begin
  inherited Destroy;
end;

procedure TDXPowerFont.SetAlphabets(const Value: string);
begin
  if FDXImageList <> nil then
    if Length(Value) > FDXImageList.Items[FFontIndex].PatternCount - 1 then Exit;
  FAlphabets := Value;
end;

procedure TDXPowerFont.SetEnterCharacter(const Value: string);
begin
  if Length(Value) >= 2 then Exit;
  FEnterCharacter := Value;
end;

procedure TDXPowerFont.SetFont(const Value: string);
begin
  FFont := Value;
  if FDXImageList <> nil then
  begin
    FFontIndex := FDXImageList.Items.IndexOf(FFont); // Find font once...
    Offset := FDXImageList.Items[FFontIndex].PatternWidth;

    FEffectsParameters.Width := FDXImageList.Items[FFontIndex].PatternWidth;
    FEffectsParameters.Height := FDXImageList.Items[FFontIndex].PatternHeight;
  end;
end;

procedure TDXPowerFont.SetFontIndex(const Value: Integer);
begin
  FFontIndex := Value;
  if FDXImageList <> nil then
  begin
    FFont := FDXImageList.Items[FFontIndex].Name;
    Offset := FDXImageList.Items[FFontIndex].PatternWidth;

    FEffectsParameters.Width := FDXImageList.Items[FFontIndex].PatternWidth;
    FEffectsParameters.Height := FDXImageList.Items[FFontIndex].PatternHeight;
  end;
end;

procedure TDXPowerFont.SetEffectsParameters(const Value: TDXPowerFontEffectsParameters);
begin
  FEffectsParameters := Value;
end;

procedure TDXPowerFont.SetTextOutEffect(const Value: TDXPowerFontTextOutEffect);
begin
  FTextOutEffect := Value;
end;

procedure TDXPowerFont.SetTextOutType(const Value: TDXPowerFontTextOutType);
begin
  FTextOutType := Value;
end;

procedure TDXPowerFont.SetUseEnterChar(const Value: Boolean);
begin
  FUseEnterChar := Value;
end;

function TDXPowerFont.TextOutFast(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string): Boolean;
var
  Loop, Letter: Integer;
  txt: string;
begin
  Result := False;
  if FDXImageList = nil then Exit;
        // modified
  case FTextOutType of
    ttNormal: Txt := Text;
    ttUpperCase: Txt := AnsiUpperCase(Text);
    ttLowerCase: Txt := AnsiLowerCase(Text);
  end;
  Offset := FDXImageList.Items[FFontIndex].PatternWidth;
  Loop := 1;
  while (Loop <= Length(Text)) do
  begin
    Letter := AnsiPos(txt[Loop], FAlphabets); // modified
    if (Letter > 0) and (Letter < FDXImageList.Items[FFontIndex].PatternCount - 1) then
      FDXImageList.Items[FFontIndex].Draw(DirectDrawSurface, X + (Offset * Loop), Y, Letter - 1);
    Inc(Loop);
  end;
  Result := True;
end;

function TDXPowerFont.TextOut(DirectDrawSurface: TDirectDrawSurface; X, Y: Integer; const Text: string): Boolean;
var
  Loop, Letter: Integer;
  FCalculatedEnters, EnterHeghit, XLoop: Integer;
  DoTextOut: Boolean;
  Txt: string;
  Rect: TRect;
begin
  Result := False;
  if FDXImageList = nil then Exit;
  Txt := Text;
  DoTextOut := True;
  if Assigned(FBeforeTextOut) then FBeforeTextOut(Self, Txt, DoTextOut);
  if not DoTextOut then Exit;
  // modified
  case FTextOutType of
    ttNormal: Txt := Text;
    ttUpperCase: Txt := AnsiUpperCase(Text);
    ttLowerCase: Txt := AnsiLowerCase(Text);
  end;
  Offset := FDXImageList.Items[FFontIndex].PatternWidth;
  FCalculatedEnters := 0;
  EnterHeghit := FDXImageList.Items[FFontIndex].PatternHeight;
  XLoop := 0;
  Loop := 1;
  while (Loop <= Length(Txt)) do
  begin
    if FUseEnterChar then
    begin
      if Txt[Loop] = FEnterCharacter[1] then begin Inc(FCalculatedEnters); Inc(Loop); end;
      if Txt[Loop] = FEnterCharacter[2] then begin Inc(FCalculatedEnters); XLoop := 0; {-FCalculatedEnters;} Inc(Loop); end;
    end;
    Letter := AnsiPos(Txt[Loop], FAlphabets); // modified

    if (Letter > 0) and (Letter < FDXImageList.Items[FFontIndex].PatternCount - 1) then
      case FTextOutEffect of
        teNormal: FDXImageList.Items[FFontIndex].Draw(DirectDrawSurface, X + (Offset * XLoop), Y + (FCalculatedEnters * EnterHeghit), Letter - 1);
        teRotat: FDXImageList.Items[FFontIndex].DrawRotate(DirectDrawSurface, X + (Offset * XLoop), Y + (FCalculatedEnters * EnterHeghit), FEffectsParameters.Width, FEffectsParameters.Height, Letter - 1, FEffectsParameters.CenterX, FEffectsParameters.CenterY, FEffectsParameters.Angle);
        teAlphaBlend:
          begin
            Rect.Left := X + (Offset * XLoop);
            Rect.Top := Y + (FCalculatedEnters * EnterHeghit);
            Rect.Right := Rect.Left + FEffectsParameters.Width;
            Rect.Bottom := Rect.Top + FEffectsParameters.Height;

            FDXImageList.Items[FFontIndex].DrawAlpha(DirectDrawSurface, Rect, Letter - 1, FEffectsParameters.AlphaValue);
          end;
        teWaveX: FDXImageList.Items[FFontIndex].DrawWaveX(DirectDrawSurface, X + (Offset * XLoop), Y + (FCalculatedEnters * EnterHeghit), FEffectsParameters.Width, FEffectsParameters.Height, Letter - 1, FEffectsParameters.WAmplitude, FEffectsParameters.WLenght, FEffectsParameters.WPhase);
      end;
    Inc(Loop);
    Inc(XLoop);
  end;
  if Assigned(FAfterTextOut) then FAfterTextOut(Self, Txt);
  Result := True;
end;

//---------------------------------------------------------------------------
{
Main code supported hardware acceleration by videoadapteur
 *  Copyright (c) 2004-2006 Jaro Benes
 *  All Rights Reserved
 *  Version 1.07
 *  D2D Hardware module - main implementation part
 *  web site: www.micrel.cz/Dx
 *  e-mail: delphix_d2d@micrel.cz
}

constructor TD2DTextures.Create();
begin
  inherited;
{$IFNDEF DelphiX_Delphi3}
  SetLength(Texture, 0);
{$ELSE}
  TexLen := 0;
  Texture := nil;
{$ENDIF}
end;

function TD2DTextures.Find(byName: string): Integer;
var I: Integer;
begin
  Result := -1;
  if Texture <> nil then
{$IFNDEF DelphiX_Delphi3}
    if Length(Texture) > 0 then
      for I := Low(Texture) to High(Texture) do
        if AnsiUpperCase(Texture[I].Name) = AnsiUpperCase(byName) then begin
          Result := I;
          Exit;
        end;
{$ELSE}
    if TexLen > 0 then
      for I := 0 to TexLen - 1 do
        if AnsiUpperCase(Texture[I].Name) = AnsiUpperCase(byName) then begin
          Result := I;
          Exit;
        end;
{$ENDIF}
end;

//---------------------------------------------------------------------------

constructor TD2D.Create(DDraw: TCustomDXDraw);
begin
  inherited Create;
  //after inheritance
  FDDraw := DDraw;
  FD2DTextureFilter := D2D_LINEAR;
  InitVertex;
  {internal allocation of texture}
  CanUseD2D := (do3D in FDDraw.Options)
    and (doDirectX7Mode in FDDraw.Options)
    and (doHardware in FDDraw.Options);
end;

destructor TD2D.Destroy;
begin
  {freeing texture and stop using it}
  CanUseD2D := False;
  if AsSigned(FD2DTexture) then begin
    D2DFreeTextures; // FIX
  end;
  inherited Destroy;
end;

procedure TD2D.InitVertex;
var i: Integer;
begin
  Fillchar(FVertex, SizeOf(FVertex), 0);
  for i := 0 to 3 do begin
    FVertex[i].Specular := D3DRGB(1.0, 1.0, 1.0);
    FVertex[i].rhw := 1.0;
  end;
end;

function TD2D.GetD2DMaxTextures: Integer;
begin
  Result := {$IFNDEF DelphiX_Delphi3}Length(FD2DTexture.Texture){$ELSE}FD2DTexture.TexLen{$ENDIF};
end;

procedure TD2D.SetD2DMaxTextures(const Value: Integer);
begin
  if Value > 0 then
{$IFNDEF DelphiX_Delphi3}
    SetLength(FD2DTexture.Texture, Value)
{$ELSE}
    Inc(FD2DTexture.TexLen);
  if FD2DTexture.Texture = nil then
    FD2DTexture.Texture := AllocMem(SizeOf(TTextureRec))
  else begin
      {alokuj pamet}
    ReallocMem(FD2DTexture.Texture, FD2DTexture.TexLen * SizeOf(TTextureRec));
  end;
{$ENDIF}
end;

procedure TD2D.D2DFreeTextures;
var I: Integer;
begin
{$IFNDEF DelphiX_Delphi3}
  for I := Low(FD2DTexture.Texture) to High(FD2DTexture.Texture) do
{$ELSE}
  for I := 0 to FD2DTexture.TexLen - 1 do
{$ENDIF}
    FD2DTexture.Texture[I].D2DTexture.Free;
{$IFDEF DelphiX_Delphi3}
  FreeMem(FD2DTexture.Texture, FD2DTexture.TexLen * SizeOf(TTextureRec));
  FD2DTexture.Texture := nil;
{$ENDIF}
  FD2DTexture.Free; {add 29.5.2005 Takanori Kawasaki}
  FD2DTexture := nil;
end;

procedure TD2D.D2DPruneTextures;
begin
  if {$IFNDEF DelphiX_Delphi3}Length(FD2DTexture.Texture){$ELSE}FD2DTexture.TexLen{$ENDIF} > maxTexBlock then begin
    D2DPruneAllTextures
  end;
end;

procedure TD2D.D2DPruneAllTextures;
var I: Integer;
begin
{$IFNDEF DelphiX_Delphi3}
  for I := Low(FD2DTexture.Texture) to High(FD2DTexture.Texture) do
{$ELSE}
  for I := 0 to FD2DTexture.TexLen - 1 do
{$ENDIF}
    FD2DTexture.Texture[I].D2DTexture.Free;
{$IFNDEF DelphiX_Delphi3}
  SetLength(FD2DTexture.Texture, 0);
{$ELSE}
  FD2DTexture.TexLen := 0;
{$ENDIF}
end;

//---------------------------------------------------------------------------

procedure TD2D.BeginScene();
begin
  asm
    FINIT
  end;
  FDDraw.D3DDevice7.BeginScene();
  FDDraw.D3DDevice7.Clear(0, nil, D3DCLEAR_TARGET, 0, 0, 0);
end;

//---------------------------------------------------------------------------

procedure TD2D.EndScene();
begin
  FDDraw.D3DDevice7.EndScene();
  asm
    FINIT
  end;
end;

procedure TD2D.SizeAdjust(var DIB: TDIB; var FloatX1, FloatY1, FloatX2, FloatY2: Double);
var X, Y: Integer;
  tempDIB: TDIB;
begin {auto-adjust size n^2 for accelerator compatibility}
  X := 1;
  repeat
    X := X * 2;
  until DIB.Width <= X;
  Y := 1;
  repeat
    Y := Y * 2
  until DIB.Height <= Y;
  if (X = DIB.Width) and (Y = DIB.Height) then begin
    if DIB.BitCount = 32 then Exit; {do not touch}
    {code for correction a DIB.BitCount to 24 bit only}
    tempDIB := TDIB.Create;
    try
      tempDIB.SetSize(X, Y, 24);
      tempDIB.Canvas.Draw(0, 0, DIB);
      DIB.Assign(tempDIB);
    finally
      tempDIB.Free;
    end;
    Exit;
  end;
  tempDIB := TDIB.Create;
  try
    if DIB.BitCount = 32 then begin
      tempDIB.SetSize(X, Y, 32);
      tempDIB.Canvas.Brush.Color := clBlack;
      tempDIB.Canvas.FillRect(Bounds(0, 0, X, Y));
      tempDIB.Canvas.Draw(0, 0, DIB);
//      if DIB.HasAlphaChannel then
//        tempDIB.AssignAlphaChannel(DIB);
    end
    else begin
      tempDIB.SetSize(X, Y, 24 {DIB.BitCount}); {bad value for some 16}
      tempDIB.Canvas.Brush.Color := clBlack;
      tempDIB.Canvas.FillRect(Bounds(0, 0, X, Y));
      tempDIB.Canvas.Draw(0, 0, DIB);
    end;
    FloatX2 := (1 / tempDIB.Width) * DIB.Width;
    FloatY2 := (1 / tempDIB.Height) * DIB.Height;
    DIB.Assign(tempDIB);
  finally
    tempDIB.Free;
  end
end;

function TD2D.D2DTexturedOn(Image: TPictureCollectionItem; Pattern: Integer; SubPatternRect: TRect; RenderType: TRenderType): Boolean;
  function CanFindTexture(aImage: TPictureCollectionItem): Boolean;
  var I: Integer;
  begin
    Result := True;
{$IFNDEF DelphiX_Delphi3}
    if Length(FD2DTexture.Texture) > 0 then
{$ELSE}
    if FD2DTexture.TexLen > 0 then
{$ENDIF}
      for I := 0 to D2DMaxTextures - 1 do
        if FD2DTexture.Texture[I].Name = aImage.Name then Exit;
    Result := False;
  end;
  function LoadTextures(aImage: TPictureCollectionItem): Boolean;
  var
    DIB: TDIB;
    T: TDXTextureImage;
  begin
    Result := True;
    try
      D2DPruneTextures; {up to maxTexBlock textures only}
      D2DMaxTextures := D2DMaxTextures + 1;
      if aImage.Name = '' then // FIX: OPTIMIZED
        aImage.Name := aImage.GetNamePath; {this name is supplement name, when wasn't aImage.Name fill}
      DIB := TDIB.Create;
      try
        DIB.Assign(aImage.Picture.Graphic);
        DIB.Transparent := aImage.Transparent;
        with FD2DTexture.Texture[D2DMaxTextures - 1] do begin
          FloatX1 := 0; FloatY1 := 0; FloatX2 := 1; FloatY2 := 1;
          SizeAdjust(DIB, FloatX1, FloatY1, FloatX2, FloatY2);
          Name := aImage.Name;
          Width := DIB.Width;
          Height := DIB.Height;
          if DIB.HasAlphaChannel then begin
            DIB2DXT(DIB, T);
            T.ImageName := aImage.Name;
            T.Transparent := aImage.Transparent;
            D2DTexture := TDirect3DTexture2.Create(FDDraw, T, False);
            D2DTexture.Transparent := aImage.Transparent;
            AlphaChannel := True;
            T.Free;
          end
          else begin
            D2DTexture := TDirect3DTexture2.Create(FDDraw, DIB, False);
            D2DTexture.TransparentColor := DWORD(aImage.TransparentColor);
            D2DTexture.Surface.TransparentColor := DWORD(aImage.TransparentColor);
            D2DTexture.Transparent := aImage.Transparent;
            AlphaChannel := False;
          end;
        end;
      finally
        DIB.Free;
      end;
    except
      D2DMaxTextures := D2DMaxTextures - 1;
      Result := False;
    end;
  end;
var I: Integer;
  SrcX, SrcY: Double;
  R: TRect;
begin
  Result := False;
  FDDraw.D3DDevice7.SetTexture(0, nil);
  if not CanFindTexture(Image) then {when no texture in list try load it}
    if not LoadTextures(Image) then Exit; {on error occurr out}
  I := FD2DTexture.Find(Image.Name);
  if I = -1 then Exit;
  {set pattern as texture}
//  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MAGFILTER, DWord(Ord(FD2DTextureFilter)+1));
//  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MINFILTER, DWord(Ord(FD2DTextureFilter)+1));
  try
    FDDraw.D3DDevice7.SetTexture(0, FD2DTexture.Texture[I].D2DTexture.Surface.IDDSurface7);
  except
    RenderError := true;
    D2DPruneAllTextures;
    Image.Restore;
    SetD2DTextureFilter(D2D_LINEAR);
    exit;
  end;
  {set transparent part}
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_COLORKEYENABLE, Ord(FD2DTexture.Texture[I].D2DTexture.Transparent));
  //except for Draw when alphachannel exists
  //change for blend drawing but save transparent area still
  if FD2DTexture.Texture[I].AlphaChannel then
    {when is Draw selected then}
    if RenderType = rtDraw then begin
      D2DEffectBlend; D2DAlphaVertex($FF);
    end;
  {pokud je obrazek rozdeleny, nastav oka site}
  if (Image.PatternHeight <> 0) or (Image.PatternWidth <> 0) then begin
    {vezmi rect jenom dilku}
    R := Image.PatternRects[Pattern];
    SrcX := 1 / FD2DTexture.Texture[I].Width;
    SrcY := 1 / FD2DTexture.Texture[I].Height;
    //namapovani vertexu na texturu
    FD2DTexture.Texture[I].FloatX1 := SrcX * R.Left;
    FD2DTexture.Texture[I].FloatY1 := SrcY * R.Top;
    FD2DTexture.Texture[I].FloatX2 := SrcX * (R.Right - 0.5);
    FD2DTexture.Texture[I].FloatY2 := SrcY * (R.Bottom - 0.5);
    if not (
      (SubPatternRect.Left = Image.PatternRects[Pattern].Left) and
      (SubPatternRect.Top = Image.PatternRects[Pattern].Top) and
      (SubPatternRect.Right = Image.PatternRects[Pattern].Right) and
      (SubPatternRect.Bottom = Image.PatternRects[Pattern].Bottom)) then begin
      {remaping subtexture via subpattern}
      FVertex[0].tu := SrcX * SubPatternRect.Left;
      FVertex[0].tv := SrcY * SubPatternRect.Top;
      FVertex[1].tu := SrcX * (SubPatternRect.Right - 0.5);
      FVertex[1].tv := SrcY * SubPatternRect.Top;
      FVertex[2].tu := SrcX * SubPatternRect.Left;
      FVertex[2].tv := SrcY * (SubPatternRect.Bottom - 0.5);
      FVertex[3].tu := SrcX * (SubPatternRect.Right - 0.5);
      FVertex[3].tv := SrcY * (SubPatternRect.Bottom - 0.5);
      Result := True;
      Exit;
    end;
  end; {jinak celeho obrazku}
  {  X1,Y1             X2,Y1
  0  +-----------------+  1
     |                 |
     |                 |
     |                 |
     |                 |
  2  +-----------------+  3
     X1,Y2             X2,Y2  }
  FVertex[0].tu := FD2DTexture.Texture[I].FloatX1;
  FVertex[0].tv := FD2DTexture.Texture[I].FloatY1;
  FVertex[1].tu := FD2DTexture.Texture[I].FloatX2;
  FVertex[1].tv := FD2DTexture.Texture[I].FloatY1;
  FVertex[2].tu := FD2DTexture.Texture[I].FloatX1;
  FVertex[2].tv := FD2DTexture.Texture[I].FloatY2;
  FVertex[3].tu := FD2DTexture.Texture[I].FloatX2;
  FVertex[3].tv := FD2DTexture.Texture[I].FloatY2;
  Result := True;
end;

function TD2D.D2DTexturedOnDDS(dds: TDirectDrawSurface; SubPatternRect: TRect; Transparent: Boolean): Boolean;
{special version of map for TDirectDrawSurface only}
{set up transparent color from this surface}
  function CanFindTexture(const TexName: string): Boolean;
  var I: Integer;
  begin
    Result := True;
{$IFNDEF DelphiX_Delphi3}
    if Length(FD2DTexture.Texture) > 0 then
{$ELSE}
    if FD2DTexture.TexLen > 0 then
{$ENDIF}
      for I := 0 to D2DMaxTextures - 1 do
        if FD2DTexture.Texture[I].Name = TexName then Exit;
    Result := False;
  end;
  //---------------------------------------------------------------------------

  function LoadTextures(dds: TDirectDrawSurface; Transparent: Boolean; asTexName: string): Boolean;
  var
    DIB: TDIB; ddck: TDDColorKey;
    Col, CLL: Integer;
  begin
    Result := True;
    try
      D2DPruneTextures; {up to maxTexBlock textures only}
      D2DMaxTextures := D2DMaxTextures + 1;
      FD2DTexture.Texture[D2DMaxTextures - 1].Name := asTexName;
      DIB := TDIB.Create;
      try
        DIB.AsSign(dds);
        with FD2DTexture.Texture[D2DMaxTextures - 1] do begin
          FloatX1 := 0; FloatY1 := 0; FloatX2 := 1; FloatY2 := 1;
          SizeAdjust(DIB, FloatX1, FloatY1, FloatX2, FloatY2);
          Width := DIB.Width;
          Height := DIB.Height;
        end;
        DIB.Transparent := Transparent;
        Col := 0;
        if dds.IDDSurface <> nil then
          if dds.ISurface.GetColorKey(DDCKEY_SRCBLT, ddck) = DD_OK then
            COL := ddck.dwColorSpaceLowValue;
        {speculative transparent color for DDS}
        CLL := DIB.Pixels[0, 0]; //have to pick up color from 0,0 pix of DIB
        if Transparent then //and must be transparent
          if (CLL <> COL) then //when different
            COL := CLL; //use our TransparentColor
        with FD2DTexture.Texture[D2DMaxTextures - 1] do begin
          D2DTexture := TDirect3DTexture2.Create(FDDraw, DIB, False);
          D2DTexture.TransparentColor := COL;
          D2DTexture.Surface.TransparentColor := COL;
          D2DTexture.Transparent := Transparent;
        end;
      finally
        DIB.Free;
      end;
    except
      D2DMaxTextures := D2DMaxTextures - 1; //go back
      Result := False;
    end;
  end;
  function IsNotZero(Z: TRect): Boolean;
  begin
    Result := ((Z.Right - Z.Left) > 0) and ((Z.Bottom - Z.Top) > 0)
  end;
var I: Integer;
  TexName: string;
  SrcX, SrcY: Double;
begin
  Result := False;
  FDDraw.D3DDevice7.SetTexture(0, nil);
  {pokud je seznam prazdny, nahrej texturu}
  TexName := IntToStr(Integer(dds));
  if not CanFindTexture(TexName) then
    {nepovede-li se to, pak ven}
    if not LoadTextures(dds, Transparent, TexName) then Exit;
  I := FD2DTexture.Find(TexName);
  if I = -1 then Exit;
  {set pattern as texture}
//  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MAGFILTER, DWord(Ord(FD2DTextureFilter)+1));
//  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MINFILTER, DWord(Ord(FD2DTextureFilter)+1));
  try
    FDDraw.D3DDevice7.SetTexture(0, FD2DTexture.Texture[I].D2DTexture.Surface.IDDSurface7);
  except
    RenderError := true;
    D2DPruneAllTextures;
    exit;
  end;
  {set transparent area}
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_COLORKEYENABLE, Ord(FD2DTexture.Texture[I].D2DTexture.Transparent));
  if IsNotZero(SubPatternRect) then begin
    // Set Texture Coordinates
    SrcX := 1 / FD2DTexture.Texture[I].D2DTexture.FImage.Width;
    SrcY := 1 / FD2DTexture.Texture[I].D2DTexture.FImage.Height;
    //namapovani vertexu na texturu
    FD2DTexture.Texture[I].FloatX1 := SrcX * SubPatternRect.Left;
    FD2DTexture.Texture[I].FloatY1 := SrcY * SubPatternRect.Top;
    FD2DTexture.Texture[I].FloatX2 := SrcX * (SubPatternRect.Right - 0.5);
    FD2DTexture.Texture[I].FloatY2 := SrcY * (SubPatternRect.Bottom - 0.5);
  end;
  FVertex[0].tu := FD2DTexture.Texture[I].FloatX1;
  FVertex[0].tv := FD2DTexture.Texture[I].FloatY1;
  FVertex[1].tu := FD2DTexture.Texture[I].FloatX2;
  FVertex[1].tv := FD2DTexture.Texture[I].FloatY1;
  FVertex[2].tu := FD2DTexture.Texture[I].FloatX1;
  FVertex[2].tv := FD2DTexture.Texture[I].FloatY2;
  FVertex[3].tu := FD2DTexture.Texture[I].FloatX2;
  FVertex[3].tv := FD2DTexture.Texture[I].FloatY2;
  Result := True;
end;

//---------------------------------------------------------------------------

procedure TD2D.SetCanUseD2D(const Value: Boolean);
begin
  case Value of
    False: {prestava se uzivat}
      if AsSigned(FD2DTexture) and (Value <> FCanUseD2D) then begin
        //D2DFreeTextures; // FIX
      end;
    True:
      if Value <> FCanUseD2D then begin
        FD2DTexture := TD2DTextures.Create();
        TextureFilter := D2D_LINEAR;
      end
  end;
  FCanUseD2D := Value;
end;

function TD2D.GetCanUseD2D: Boolean;
begin
  {Mode has to do3D, doDirectX7Mode and doHardware}
  if (do3D in FDDraw.Options)
    and (doDirectX7Mode in FDDraw.Options)
    and (doHardware in FDDraw.Options) then
  begin
    if not FCanUseD2D then CanUseD2D := True;
  end
  else
    if not (do3D in FDDraw.Options)
      or not (doDirectX7Mode in FDDraw.Options)
      or not (doHardware in FDDraw.Options) then
      if FCanUseD2D then FCanUseD2D := False; // CanUseD2D -> FCanUseD2D
  FBitCount := FDDraw.Surface.SurfaceDesc.ddpfPixelFormat.dwRGBBitCount;
  {only 16 or 32 bitcount deepth}
  if not (FBitCount in [16, 32]) then FCanUseD2D := False;
  Result := FCanUseD2D;
end;

procedure TD2D.SetD2DTextureFilter(const Value: TD2DTextureFilter);
begin
  FD2DTextureFilter := Value;
  if (do3D in FDDraw.Options) and AsSigned(FDDraw.D3DDevice7) then begin
    FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MAGFILTER, DWord(Ord(FD2DTextureFilter) + 1));
    FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MINFILTER, DWord(Ord(FD2DTextureFilter) + 1));
  end;
end;

procedure TD2D.SetD2DAntialiasFilter(const Value: TD3DAntialiasMode);
begin
  FD2DAntialiasFilter := Value;
  if (do3D in FDDraw.Options) and AsSigned(FDDraw.D3DDevice7) then begin
    FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_ANTIALIAS, Ord(Value));
  end;
end;

procedure TD2D.D2DRect(R: TRect);
begin
  FVertex[0].sx := R.Left - 0.5;
  FVertex[0].sy := R.Top - 0.5;
  FVertex[1].sx := R.Right - 0.5;
  FVertex[1].sy := R.Top - 0.5;
  FVertex[2].sx := R.Left - 0.5;
  FVertex[2].sy := R.Bottom - 0.5;
  FVertex[3].sx := R.Right - 0.5;
  FVertex[3].sy := R.Bottom - 0.5;
end;

{Final public routines}

function TD2D.D2DRender(Image: TPictureCollectionItem; R: TRect;
  Pattern: Integer; RenderType: TRenderType; Alpha: Byte): Boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  case RenderType of
    rtDraw: begin D2DEffectSolid; D2DWhite; end;
    rtBlend: begin D2DEffectBlend; D2DAlphaVertex(Alpha); end;
    rtAdd: begin D2DEffectAdd; D2DFade(Alpha); end;
    rtSub: begin D2DEffectSub; D2DFade(Alpha); end;
  end;
  Result := D2DTexturedOn(Image, Pattern, Image.PatternRects[Pattern], RenderType);
  D2DRect(R);
  RenderQuad;
end;

function TD2D.D2DRenderDDS(Source: TDirectDrawSurface; R: TRect;
  Transparent: Boolean; Pattern: Integer; RenderType: TRenderType; Alpha: Byte): Boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  case RenderType of
    rtDraw: begin D2DEffectSolid; D2DWhite; end;
    rtBlend: begin D2DEffectBlend; D2DAlphaVertex(Alpha); end;
    rtAdd: begin D2DEffectAdd; D2DFade(Alpha); end;
    rtSub: begin D2DEffectSub; D2DFade(Alpha); end;
  end;
  Result := D2DTexturedOnDDS(Source, ZeroRect, Transparent);
  D2DRect(R);
  RenderQuad;
end;

function TD2D.D2DRenderCol(Image: TPictureCollectionItem; R: TRect;
  Pattern, Color: integer; RenderType: TRenderType; Alpha: Byte): Boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  case RenderType of
    rtDraw: begin D2DEffectSolid; D2DColoredVertex(Color); end;
    rtBlend: begin D2DEffectBlend; D2DColAlpha(Color, Alpha); end;
    rtAdd: begin D2DEffectAdd; D2DFadeColored(Color, Alpha); end;
    rtSub: begin D2DEffectSub; D2DFadeColored(Color, Alpha); end;
  end;
  Result := D2DTexturedOn(Image, Pattern, Image.PatternRects[Pattern], RenderType);
  D2DRect(R);
  RenderQuad;
end;

function TD2D.D2DRenderColDDS(Source: TDirectDrawSurface; R: TRect;
  Transparent: Boolean; Pattern, Color: Integer; RenderType: TRenderType; Alpha: Byte): Boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  {Add}
  case RenderType of
    rtDraw: begin D2DEffectSolid; D2DColoredVertex(Color); end;
    rtBlend: begin D2DEffectBlend; D2DColAlpha(Color, Alpha); end;
    rtAdd: begin D2DEffectAdd; D2DFadeColored(Color, Alpha); end;
    rtSub: begin D2DEffectSub; D2DFadeColored(Color, Alpha); end;
  end;
  Result := D2DTexturedOnDDS(Source, ZeroRect, Transparent);
  D2DRect(R);
  RenderQuad;
end;

function TD2D.D2DRenderDrawXY(Image: TPictureCollectionItem; X, Y: Integer;
  Pattern: Integer; RenderType: TRenderType; Alpha: Byte): Boolean;
var PWidth, PHeight: Integer;
begin
  Result := False; if not CanUseD2D then Exit;
  {Draw}
  case RenderType of
    rtDraw: begin D2DEffectSolid; D2DWhite; end;
    rtBlend: begin D2DEffectBlend; D2DAlphaVertex(Alpha); end;
    rtAdd: begin D2DEffectAdd; D2DFade(Alpha); end;
    rtSub: begin D2DEffectSub; D2DFade(Alpha); end;
  end;
  Result := D2DTexturedOn(Image, Pattern, Image.PatternRects[Pattern], RenderType);
  PWidth := Image.PatternWidth; if PWidth = 0 then PWidth := Image.Width;
  PHeight := Image.PatternHeight; if PHeight = 0 then PHeight := Image.Height;
  D2DRect(Bounds(X, Y, PWidth, PHeight));
  RenderQuad;
end;

function TD2D.D2DRenderDrawDDSXY(Source: TDirectDrawSurface; X, Y: Integer;
  Transparent: Boolean; Pattern: Integer; RenderType: TRenderType; Alpha: Byte): Boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  {Draw}
  case RenderType of
    rtDraw: begin D2DEffectSolid; D2DWhite; end;
    rtBlend: begin D2DEffectBlend; D2DAlphaVertex(Alpha); end;
    rtAdd: begin D2DEffectAdd; D2DFade(Alpha); end;
    rtSub: begin D2DEffectSub; D2DFade(Alpha); end;
  end;
  Result := D2DTexturedOnDDS(Source, ZeroRect, Transparent);
  D2DRect(Bounds(X, Y, Source.Width, Source.Height));
  RenderQuad;
end;

{$IFDEF DelphiX_Spt4}
function TD2D.D2DRenderDrawDDSXY(Source: TDirectDrawSurface; X, Y: Integer;
  SrcRect: TRect; Transparent: Boolean; Pattern: Integer; RenderType: TRenderType; Alpha: Byte): boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  {Draw}
  case RenderType of
    rtDraw: begin D2DEffectSolid; D2DWhite; end;
    rtBlend: begin D2DEffectBlend; D2DAlphaVertex(Alpha); end;
    rtAdd: begin D2DEffectAdd; D2DFade(Alpha); end;
    rtSub: begin D2DEffectSub; D2DFade(Alpha); end;
  end;
  Result := D2DTexturedOnDDS(Source, SrcRect, Transparent);
  D2DRect(Bounds(X, Y, SrcRect.Right - SrcRect.Left, SrcRect.Bottom - SrcRect.Top));
  RenderQuad;
end;
{$ENDIF}

{Rotate functions}

procedure TD2D.D2DRotate(X, Y, W, H: Integer; Px, Py: Double; Angle: single);
  procedure SinCosS(const Theta: Single; var Sin, Cos: Single); register;
  // EAX contains address of Sin
  // EDX contains address of Cos
  // Theta is passed over the stack
  asm
    FLD  Theta
    FSINCOS
    FSTP DWORD PTR [EDX]    // cosine
    FSTP DWORD PTR [EAX]    // sine
  end;
const PI256 = 2 * PI / 256;
var x1, y1, up, s_angle, c_angle, s_up, c_up: single;
begin
  angle := angle * PI256; up := angle + PI / 2;
  x1 := w * px; y1 := h * py;
  SinCosS(angle, s_angle, c_angle);
  SinCosS(up, s_up, c_up);
  FVertex[0].sx := X - x1 * c_angle - y1 * c_up;
  FVertex[0].sy := Y - x1 * s_angle - y1 * s_up;
  FVertex[1].sx := FVertex[0].sx + W * c_angle;
  FVertex[1].sy := FVertex[0].sy + W * s_angle;
  FVertex[2].sx := FVertex[0].sx + H * c_up;
  FVertex[2].sy := FVertex[0].sy + H * s_up;
  FVertex[3].sx := FVertex[2].sx + W * c_angle;
  FVertex[3].sy := FVertex[2].sy + W * s_angle;
end;

function TD2D.D2DRenderRotate(Image: TPictureCollectionItem; RotX, RotY,
  PictWidth, PictHeight, PatternIndex: Integer; RenderType: TRenderType;
  CenterX, CenterY: Double;
  Angle: single; Alpha: Byte): Boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  {set of effect}
  case RenderType of
    rtDraw: begin D2DEffectSolid; D2DWhite; end;
    rtBlend: begin D2DEffectBlend; D2DAlphaVertex(Alpha); end;
    rtAdd: begin D2DEffectAdd; D2DFade(Alpha); end;
    rtSub: begin D2DEffectSub; D2DFade(Alpha); end;
  end;
  {load textures and map it}
  Result := D2DTexturedOn(Image, PatternIndex, Image.PatternRects[PatternIndex], RenderType);
  {do rotate mesh}
  D2DRotate(RotX, RotY, PictWidth, PictHeight, CenterX, CenterY, Angle);
  {render it}
  RenderQuad;
end;

function TD2D.D2DRenderRotateDDS(Image: TDirectDrawSurface; RotX, RotY,
  PictWidth, PictHeight: Integer; RenderType: TRenderType;
  CenterX, CenterY: Double; Angle: single; Alpha: Byte;
  Transparent: Boolean): Boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  {set of effect}
  case RenderType of
    rtDraw: begin D2DEffectSolid; D2DWhite; end;
    rtBlend: begin D2DEffectBlend; D2DAlphaVertex(Alpha); end;
    rtAdd: begin D2DEffectAdd; D2DFade(Alpha); end;
    rtSub: begin D2DEffectSub; D2DFade(Alpha); end;
  end;
  {load textures and map it}
  Result := D2DTexturedOnDDS(Image, ZeroRect, Transparent);
  {do rotate mesh}
  D2DRotate(RotX, RotY, PictWidth, PictHeight, CenterX, CenterY, Angle);
  {render it}
  RenderQuad;
end;

{------------------------------------------------------------------------------}
{created 31.1.2005 JB.}
{replacement original Hori's functionality}
{24.4.2006 create WaveY as supplement like WaveX functions}
{14.5.2006 added functionality for tile drawing through PatternIndex}

function TD2D.D2DMeshMapToWave(dds: TDirectDrawSurface; Transparent: Boolean;
  TransparentColor: Integer; X, Y, iWidth, iHeight, PatternIndex: Integer;
  PatternRect: TRect;
  Amp, Len, Ph, Alpha: Integer; effect: TRenderType; DoY: boolean): Boolean;
  function D2DTexturedOn(dds: TDirectDrawSurface; Transparent: Boolean; var TexNo: Integer): Boolean;
  {special version of mapping for TDirectDrawSurface only}
  {set up transparent color from this surface}
    function CanFindTexture(const TexName: string): Boolean;
    var I: Integer;
    begin
      Result := True;
  {$IFNDEF DelphiX_Delphi3}
      if Length(FD2DTexture.Texture) > 0 then
  {$ELSE}
      if FD2DTexture.TexLen > 0 then
  {$ENDIF}
        for I := 0 to D2DMaxTextures - 1 do
          if FD2DTexture.Texture[I].Name = TexName then Exit;
      Result := False;
    end;
    //---------------------------------------------------------------------------
    function LoadTextures(dds: TDirectDrawSurface; Transparent: Boolean;
      TransparentColor: Integer; asTexName: string): Boolean;
      function getDDSTransparentColor(DIB: TDIB; dds: TDirectDrawSurface): Integer;
      var CLL: Integer; ddck: TDDColorKey;
      begin
        Result := 0;
        if dds.IDDSurface <> nil then
          if dds.ISurface.GetColorKey(DDCKEY_SRCBLT, ddck) = DD_OK then
            Result := ddck.dwColorSpaceLowValue;
        CLL := TransparentColor;
        if (CLL = -1) or (cardinal(CLL) <> DIB.Pixels[0, 0]) then //when is DDS
          CLL := DIB.Pixels[0, 0]; //have to pick up color from 0,0 pix of DIB
        if Transparent then //and must be transparent
          if CLL <> Result then //when different
            Result := CLL; //use TransparentColor
      end;
    var
      DIB: TDIB;
      Col: Integer;
      T: TDXTextureImage;
    begin
      Result := True;
      try
        D2DPruneTextures; {up to maxTexBlock textures only}
        D2DMaxTextures := D2DMaxTextures + 1;
        FD2DTexture.Texture[D2DMaxTextures - 1].Name := asTexName;
        DIB := TDIB.Create;
        try
          DIB.AsSign(dds);
          with FD2DTexture.Texture[D2DMaxTextures - 1] do begin
            FloatX1 := 0; FloatY1 := 0; FloatX2 := 1; FloatY2 := 1;
            SizeAdjust(DIB, FloatX1, FloatY1, FloatX2, FloatY2);
            Width := DIB.Width;
            Height := DIB.Height;
            DIB.Transparent := Transparent;
            if DIB.HasAlphaChannel then begin
              DIB2DXT(DIB, T);
              T.ImageName := asTexName;
              T.Transparent := Transparent;
              D2DTexture := TDirect3DTexture2.Create(FDDraw, T, False);
              D2DTexture.Transparent := Transparent;
              AlphaChannel := True;
              T.Free;
            end
            else begin
              col := getDDSTransparentColor(DIB, DDS);
              D2DTexture := TDirect3DTexture2.Create(FDDraw, DIB, False);
              D2DTexture.TransparentColor := COL;
              D2DTexture.Surface.TransparentColor := COL;
              D2DTexture.Transparent := Transparent;
            end;
          end
        finally
          DIB.Free;
        end;
      except
        D2DMaxTextures := D2DMaxTextures - 1;
        Result := False;
      end;
    end;
  var I: Integer;
    TexName: string;
  begin
    Result := False;
    TexNo := -1;
    FDDraw.D3DDevice7.SetTexture(0, nil);
    {pokud je seznam prazdny, nahrej texturu}
    TexName := IntToStr(Integer(dds));
    if not CanFindTexture(TexName) then
      {nepovede-li se to, pak ven}
      if not LoadTextures(dds, Transparent, TransparentColor, TexName) then Exit;
    I := FD2DTexture.Find(TexName);
    if I = -1 then Exit;
    TexNo := I;
    {set pattern as texture}
//    FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MAGFILTER, DWord(Ord(FD2DTextureFilter)+1));
//    FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MINFILTER, DWord(Ord(FD2DTextureFilter)+1));
    try
      FDDraw.D3DDevice7.SetTexture(0, FD2DTexture.Texture[I].D2DTexture.Surface.IDDSurface7);
    except
      RenderError := true;
      D2DPruneAllTextures;
      exit;
    end;
    {set transparent area}
    FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_COLORKEYENABLE, Ord(FD2DTexture.Texture[I].D2DTexture.Transparent));
    Result := True;
  end;
type
  TVertexArray = array{$IFDEF DelphiX_Delphi3} [0..0]{$ENDIF} of TD3DTLVERTEX;
{$IFDEF DelphiX_Delphi3}
  PVertexArray = ^TVertexArray;
{$ENDIF}
var
  SVertex: {$IFNDEF DelphiX_Delphi3}TVertexArray{$ELSE}PVertexArray{$ENDIF};
  I, maxVertex, maxPix, VStepVx, TexNo, Width, Height: Integer;
  VStep, VStepTo, D, Z, FX1, FX2, FY1, FY2, SX, SY: Extended;
  R: TRect;
begin
  Result := False;
  //zde uschovano maximum [0..1] po adjustaci textury, ktera nemela nektery rozmer 2^n
  //FD2DTexture.Texture[I].FloatX2;
  //FD2DTexture.Texture[I].FloatY2;
  //napr. pokud byl rozmer 0.7 pak je nutno prepocitat tento interval [0..0.7] na height
  if not D2DTexturedOn(dds, Transparent, TexNo) then Exit;
  {musi se prenastavit velikost pokud je PatternIndex <> -1}
  Width := iWidth;
  Height := iHeight;
  {remove into local variabled for multi-picture adjustation}
  FX1 := FD2DTexture.Texture[TexNo].FloatX1;
  FX2 := FD2DTexture.Texture[TexNo].FloatX2;
  FY1 := FD2DTexture.Texture[TexNo].FloatY1;
  FY2 := FD2DTexture.Texture[TexNo].FloatY2;
  {when pattertindex selected, get real value of subtexture}
  if PatternIndex <> -1 then begin
    R := PatternRect;
    Width := R.Right - R.Left;
    Height := R.Bottom - R.Top;
    {scale unit of full new width and height}
    SX := 1 / FD2DTexture.Texture[TexNo].Width;
    SY := 1 / FD2DTexture.Texture[TexNo].Height;
    {remap there}
    FX1 := R.Left * SX;
    FX2 := R.Right * SX;
    FY1 := R.Top * SY;
    FY2 := R.Bottom * SY;
  end;
  //nastavuje se tolik vertexu, kolik je potreba
  //speculative set up of rows for better look how needed
  if not DoY then begin
    maxVertex := 2 * Trunc(Height / Len * 8);
    if (maxVertex mod 2) > 0 then {top to limits}
      Inc(maxVertex, 2);
    if (maxVertex div 2) > Height then {correct to Height}
      maxVertex := 2 * Height;
  end
  else begin
    maxVertex := 2 * Trunc(Width / Len * 8);
    if (maxVertex mod 2) > 0 then {top to limits}
      Inc(maxVertex, 2);
    if (maxVertex div 2) > Width then {correct to Width}
      maxVertex := 2 * Width;
  end;

  //pocet pixlu mezi ploskami
  if not DoY then begin
    repeat
      if (Height mod (maxVertex div 2)) <> 0 then
        Inc(maxVertex, 2);
      maxPix := Height div (maxVertex div 2);
    until (Height mod (maxVertex div 2)) = 0;
    //krok k nastaveni vertexu
    VStep := (FY2-FY1) / (maxVertex div 2);
  end
  else begin
    repeat
      if (Width mod (maxVertex div 2)) <> 0 then
        Inc(maxVertex, 2);
      maxPix := Width div (maxVertex div 2);
    until (Width mod (maxVertex div 2)) = 0;
    //krok k nastaveni vertexu
    VStep := (FX2-FX1) / (maxVertex div 2);
  end;
  //prostor
{$IFNDEF DelphiX_Delphi3}
  SetLength(SVertex, maxVertex);
{$ELSE}
  SVertex := AllocMem(maxVertex * SizeOf(TD3DTLVERTEX));
  try
{$ENDIF}
    //inicializace
    VStepVx := 0;
    VStepTo := 0;
    D := ph / (128 / PI); {shift wave}
    Z := (Len / 2) / PI; {wave length to radians}
    {vlastni nastaveni vertexu v pasu vertexu}
    for I := 0 to maxVertex - 1 do begin
      SVertex[I].Specular := D3DRGB(1.0, 1.0, 1.0);
      SVertex[I].rhw := 1.0;
      case Effect of //effect cumulate to one param and four line of code
        rtDraw: SVertex[I].color := D2DWhite;
        rtBlend: SVertex[I].color := D2DAlphaVertex(Alpha);
        rtAdd: SVertex[I].color := D2DFade(Alpha);
        rtSub: SVertex[I].color := D2DFade(Alpha);
      end;
      if not DoY then
        case (I + 1) mod 2 of //triangle driver
          1: begin
              if I <> 0 then Inc(VStepVx, maxPix);
              SVertex[I].sx := X + Trunc(amp * Sin((Y + VStepVx) / Z + D)) - 0.5; //levy
              SVertex[I].sy := Y + VStepVx - 0.5;
              SVertex[I].tu := FX1;
              if I <> 0 then VStepTo := VStepTo + VStep;
              SVertex[I].tv := FY1 + VStepTo;
            end;
          0: begin
              SVertex[I].sx := X + Width + Trunc(amp * Sin((Y + VStepVx) / Z + D)) - 1; //pravy
              SVertex[I].sy := Y + VStepVx;
              SVertex[I].tu := FX2;
              SVertex[I].tv := FY1 + VStepTo;
            end;
        end {case}
      else
        case (I + 1) mod 2 of //triangle driver
          0: begin
              if I <> 0 then Inc(VStepVx, maxPix);
              SVertex[I].sy := Y + Trunc(amp * Sin((X + VStepVx) / Z + D)) - 0.5; //hore
              SVertex[I].sx := X + VStepVx - 0.5;
              SVertex[I].tv := FY1;
              if I <> 0 then VStepTo := VStepTo + VStep;
              SVertex[I].tu := FX1 + VStepTo;
            end;
          1: begin
              SVertex[I].sy := Y + Height + Trunc(amp * Sin((X + VStepVx) / Z + D)) - 1; //dole
              SVertex[I].sx := X + VStepVx;
              SVertex[I].tv := FY2;
              SVertex[I].tu := FX1 + VStepTo;
            end;
        end;
    end;
    {kreslime hned zde}//render now and here
    Result := FDDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_TLVERTEX, SVertex[0], maxVertex, D3DDP_WAIT) = DD_OK;
{$IFDEF DelphiX_Delphi3}
  finally
    FreeMem(SVertex, maxVertex * SizeOf(TD3DTLVERTEX));
  end;
{$ENDIF}
end;

function TD2D.D2DRenderWaveX(Image: TPictureCollectionItem; X, Y, Width,
  Height, PatternIndex: Integer; RenderType: TRenderType; transparent: Boolean;
  amp, Len, ph, Alpha: Integer): Boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  {set of effect}
  case RenderType of
    rtDraw: begin D2DEffectSolid; {D2DWhite;} end;
    rtBlend: begin D2DEffectBlend; {D2DAlphaVertex(Alpha);} end;
    rtAdd: begin D2DEffectAdd; {D2DFade(Alpha);} end;
    rtSub: begin D2DEffectSub; {D2DFade(Alpha);} end;
  end;
  {load textures and map, do make wave mesh and render it}
  Result := D2DMeshMapToWave(Image.PatternSurfaces[PatternIndex], transparent,
    Image.FTransparentColor, X, Y, Width, Height, PatternIndex,
    Image.PatternRects[PatternIndex],
    amp, Len, ph, Alpha, RenderType{$IFDEF DelphiX_Delphi3}, False{$ENDIF});
end;

function TD2D.D2DRenderWaveXDDS(Source: TDirectDrawSurface; X, Y, Width,
  Height: Integer; RenderType: TRenderType; Transparent: Boolean; Amp, Len, Ph, Alpha: Integer): Boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  {set of effect}
  case RenderType of
    rtDraw: begin D2DEffectSolid; D2DWhite; end;
    rtBlend: begin D2DEffectBlend; D2DAlphaVertex(Alpha); end;
    rtAdd: begin D2DEffectAdd; D2DFade(Alpha); end;
    rtSub: begin D2DEffectSub; D2DFade(Alpha); end;
  end;
  {load textures and map, do make wave mesh and render it}
  Result := D2DMeshMapToWave(Source, transparent, -1, X, Y, Width, Height, 0,
    ZeroRect,
    amp, Len, ph, Alpha, RenderType{$IFDEF DelphiX_Delphi3}, False{$ENDIF});
end;

function TD2D.D2DRenderWaveY(Image: TPictureCollectionItem; X, Y, Width,
  Height, PatternIndex: Integer; RenderType: TRenderType; Transparent: Boolean;
  Amp, Len, Ph, Alpha: Integer): Boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  {set of effect}
  case RenderType of
    rtDraw: begin D2DEffectSolid; D2DWhite; end;
    rtBlend: begin D2DEffectBlend; D2DAlphaVertex(Alpha); end;
    rtAdd: begin D2DEffectAdd; D2DFade(Alpha); end;
    rtSub: begin D2DEffectSub; D2DFade(Alpha); end;
  end;
  {load textures and map, do make wave mesh and render it}
  Result := D2DMeshMapToWave(Image.PatternSurfaces[PatternIndex], transparent,
    Image.FTransparentColor, X, Y, Width, Height, PatternIndex,
    Image.PatternRects[PatternIndex],
    amp, Len, ph, Alpha, RenderType, True);
end;

function TD2D.D2DRenderWaveYDDS(Source: TDirectDrawSurface; X, Y, Width,
  Height: Integer; RenderType: TRenderType; Transparent: Boolean;
  Amp, Len, Ph, Alpha: Integer): Boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  {set of effect}
  case RenderType of
    rtDraw: begin D2DEffectSolid; D2DWhite; end;
    rtBlend: begin D2DEffectBlend; D2DAlphaVertex(Alpha); end;
    rtAdd: begin D2DEffectAdd; D2DFade(Alpha); end;
    rtSub: begin D2DEffectSub; D2DFade(Alpha); end;
  end;
  {load textures and map, do make wave mesh and render it}
  Result := D2DMeshMapToWave(Source, transparent, -1, X, Y, Width, Height, 0,
    ZeroRect,
    amp, Len, ph, Alpha, RenderType, True);
end;

function TD2D.D2DTexturedOnRect(Rect: TRect; Color: LongInt): Boolean;
  function CanFindTexture(Color: LongInt): Boolean;
  var I: Integer;
  begin
    Result := True;
{$IFNDEF DelphiX_Delphi3}
    if Length(FD2DTexture.Texture) > 0 then
{$ELSE}
    if FD2DTexture.TexLen > 0 then
{$ENDIF}
      for I := 0 to D2DMaxTextures - 1 do
        if FD2DTexture.Texture[I].Name = '$' + IntToStr(Color) then Exit;
    Result := False;
  end;
  function LoadTextures(Color: LongInt): Boolean;
  var
    S: string;
    DIB: TDIB;
  begin
    Result := True;
    try
      D2DPruneTextures; {up to maxTexBlock textures only}
      D2DMaxTextures := D2DMaxTextures + 1;
      S := '$' + IntToStr(Color); {this name is supplement name}
      DIB := TDIB.Create;
      try
        DIB.SetSize(16, 16, 24); {16x16 good size}
        DIB.Canvas.Brush.Color := Color;
        DIB.Canvas.FillRect(Bounds(0, 0, 16, 16));
        with FD2DTexture.Texture[D2DMaxTextures - 1] do begin
          FloatX1 := 0;
          FloatY1 := 0;
          FloatX2 := 1;
          FloatY2 := 1;
          Name := S;
          D2DTexture := TDirect3DTexture2.Create(FDDraw, DIB, False);
          D2DTexture.Transparent := False; //cannot be transparent
        end;
      finally
        DIB.Free;
      end;
    except
      D2DMaxTextures := D2DMaxTextures - 1;
      Result := False;
    end;
  end;
var I: Integer;
begin
  Result := False;
  FDDraw.D3DDevice7.SetTexture(0, nil);
  if not CanFindTexture(Color) then {when no texture in list try load it}
    if not LoadTextures(Color) then Exit; {on error occurr go out}
  I := FD2DTexture.Find('$' + IntToStr(Color)); //simply .. but stupid
  if I = -1 then Exit;
  {set pattern as texture}
//  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MAGFILTER, DWord(Ord(FD2DTextureFilter)+1));
//  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_MINFILTER, DWord(Ord(FD2DTextureFilter)+1));
  try
    FDDraw.D3DDevice7.SetTexture(0, FD2DTexture.Texture[I].D2DTexture.Surface.IDDSurface7);
  except
    RenderError := true;
    D2DPruneAllTextures;
    exit;
  end;
  {set transparent part}
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_COLORKEYENABLE, 0); //no transparency
  FVertex[0].tu := FD2DTexture.Texture[I].FloatX1;
  FVertex[0].tv := FD2DTexture.Texture[I].FloatY1;
  FVertex[1].tu := FD2DTexture.Texture[I].FloatX2;
  FVertex[1].tv := FD2DTexture.Texture[I].FloatY1;
  FVertex[2].tu := FD2DTexture.Texture[I].FloatX1;
  FVertex[2].tv := FD2DTexture.Texture[I].FloatY2;
  FVertex[3].tu := FD2DTexture.Texture[I].FloatX2;
  FVertex[3].tv := FD2DTexture.Texture[I].FloatY2;
  Result := True;
end;

function TD2D.D2DRenderColoredPartition(Image: TPictureCollectionItem;
  DestRect: TRect;
  PatternIndex, Color, Specular: Integer;
  Faded: Boolean;
  SourceRect: TRect;
  RenderType: TRenderType;
  Alpha: Byte): Boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  {set of effect}
  case RenderType of
    rtDraw: D2DEffectSolid;
    rtBlend: D2DEffectBlend;
    rtAdd: D2DEffectAdd;
    rtSub: D2DEffectSub;
  end;
  if Faded then D2DFade(Alpha);

  D2DColoredVertex(Color);
  if Specular <> Round(D3DRGB(1.0, 1.0, 1.0)) then
    D2DSpecularVertex(Specular);
  {load textures and map it}
  Result := D2DTexturedOn(Image, PatternIndex, SourceRect, RenderType);

  D2DRect(DestRect);
  {render it}
  RenderQuad;
end;

function TD2D.D2DRenderFillRect(Rect: TRect; RGBColor: LongInt;
  RenderType: TRenderType; Alpha: Byte): Boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  case RenderType of
    rtDraw: begin D2DEffectSolid; D2DColoredVertex(RGBColor); end;
    rtBlend: begin D2DEffectBlend; D2DAlphaVertex(Alpha); end;
    rtAdd: begin D2DEffectAdd; D2DFade(Alpha); end;
    rtSub: begin D2DEffectSub; D2DFade(Alpha); end;
  end;
  Result := D2DTexturedOnRect(Rect, RGBColor);
  D2DRect(Rect);
  RenderQuad;
end;

function TD2D.D2DRenderRotateModeCol(Image: TPictureCollectionItem;
  RenderType: TRenderType;
  RotX, RotY, PictWidth, PictHeight, PatternIndex: Integer; CenterX,
  CenterY: Double; Angle: single; Color: integer; Alpha: Byte): boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  {set of effect}
  case RenderType of
    rtDraw: D2DEffectSolid;
    rtAdd: D2DEffectAdd;
    rtSub: D2DEffectSub;
    rtBlend: D2DEffectBlend;
  end;
  D2DFadeColored(Color, Alpha);
  {load textures and map it}
  Result := D2DTexturedOn(Image, PatternIndex, Image.PatternRects[PatternIndex], RenderType);
  {do rotate mesh}
  D2DRotate(RotX, RotY, PictWidth, PictHeight, CenterX, CenterY, Angle);
  {render it}
  RenderQuad;
end;

function TD2D.D2DRenderRotateModeColDDS(Image: TDirectDrawSurface;
  RotX, RotY, PictWidth, PictHeight: Integer; RenderType: TRenderType;
  CenterX, CenterY: Double; Angle: Single; Color: Integer; Alpha: Byte;
  Transparent: Boolean): Boolean;
begin
  Result := False; if not CanUseD2D then Exit;
  {set of effect}
  case RenderType of
    rtDraw: D2DEffectSolid;
    rtAdd: D2DEffectAdd;
    rtSub: D2DEffectSub;
    rtBlend: D2DEffectBlend;
  end;
  D2DFadeColored(Color, Alpha);
  {load textures and map it}
  Result := D2DTexturedOnDDS(Image, ZeroRect, Transparent);
  {do rotate mesh}
  D2DRotate(RotX, RotY, PictWidth, PictHeight, CenterX, CenterY, Angle);
  {render it}
  RenderQuad;
end;

procedure TD2D.D2DEffectSolid;
begin
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 0);
  //FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_FILLMODE, Integer(D3DFILL_SOLID));
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_COLORKEYENABLE, Integer(True));
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_SRCBLEND, Integer(D3DBLEND_ONE));
end;

procedure TD2D.D2DEffectBlend;
begin
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 1);
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_SRCBLEND, Integer(D3DBLEND_SRCALPHA));
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_DESTBLEND, Integer(D3DBLEND_INVSRCALPHA));
  FDDraw.D3DDevice7.SetTextureStageState(0, D3DTSS_ALPHAOP, Integer(D3DTOP_MODULATE));
end;

procedure TD2D.D2DEffectAdd;
begin
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 1);
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_SRCBLEND, Integer(D3DBLEND_ONE));
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_DESTBLEND, Integer(D3DBLEND_ONE));
end;

procedure TD2D.D2DEffectSub;
begin
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 1);
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_SRCBLEND, Integer(D3DBLEND_ZERO));
  FDDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_DESTBLEND, Integer(D3DBLEND_INVSRCCOLOR));
end;

function TD2D.D2DAlphaVertex(Alpha: Integer): Integer;
begin
  Result := RGBA_MAKE($FF, $FF, $FF, Alpha);
  FVertex[0].Color := Result;
  FVertex[1].Color := Result;
  FVertex[2].Color := Result;
  FVertex[3].Color := Result;
end;

procedure TD2D.D2DColoredVertex(C: Integer);
begin
  C := D3DRGB(C and $FF / 255, (C shr 8) and $FF / 255, (C shr 16) and $FF / 255);
  FVertex[0].Color := C;
  FVertex[1].Color := C;
  FVertex[2].Color := C;
  FVertex[3].Color := C;
end;

procedure TD2D.D2DColAlpha(C, Alpha: Integer);
begin
  C := D3DRGBA(C and $FF / 255, (C shr 8) and $FF / 255, (C shr 16) and $FF / 255, Alpha / 255);
  FVertex[0].Color := C;
  FVertex[1].Color := C;
  FVertex[2].Color := C;
  FVertex[3].Color := C;
end;

procedure TD2D.D2DSpecularVertex(C: Integer);
begin
  C := D3DRGB(C and $FF / 255, (C shr 8) and $FF / 255, (C shr 16) and $FF / 255);
  FVertex[0].Specular := C;
  FVertex[1].Specular := C;
  FVertex[2].Specular := C;
  FVertex[3].Specular := C;
end;

procedure TD2D.D2DCol4Alpha(C1, C2, C3, C4, Alpha: Integer);
begin
  FVertex[0].Color := D3DRGBA(C1 and $FF / 255, (C1 shr 8) and $FF / 255,
    (C1 shr 16) and $FF / 255, Alpha / 255);
  FVertex[1].Color := D3DRGBA(C2 and $FF / 255, (C2 shr 8) and $FF / 255,
    (C2 shr 16) and $FF / 255, Alpha / 255);
  FVertex[2].Color := D3DRGBA(C3 and $FF / 255, (C3 shr 8) and $FF / 255,
    (C3 shr 16) and $FF / 255, Alpha / 255);
  FVertex[3].Color := D3DRGBA(C4 and $FF / 255, (C4 shr 8) and $FF / 255,
    (C4 shr 16) and $FF / 255, Alpha / 255);
end;

function TD2D.D2DWhite: Integer;
begin
  Result := RGB_MAKE($FF, $FF, $FF);
  FVertex[0].Color := Result;
  FVertex[1].Color := Result;
  FVertex[2].Color := Result;
  FVertex[3].Color := Result;
end;

function TD2D.D2DFade(Alpha: integer): Integer;
begin
  Result := RGB_MAKE(Alpha, Alpha, Alpha);
  FVertex[0].Color := Result;
  FVertex[1].Color := Result;
  FVertex[2].Color := Result;
  FVertex[3].Color := Result;
end;

procedure TD2D.D2DFadeColored(C, Alpha: integer);
var mult: single;
begin
  mult := Alpha / 65025; //Alpha/255/255;
  C := D3DRGB((C and $FF) * mult, ((C shr 8) and $FF) * mult, ((C shr 16) and $FF) * mult);
  FVertex[0].Color := C;
  FVertex[1].Color := C;
  FVertex[2].Color := C;
  FVertex[3].Color := C;
end;

procedure TD2D.D2DFade4Colored(C1, C2, C3, C4, Alpha: integer);
var mult: single;
begin
  mult := Alpha / 65025; //Alpha/255/255;
  FVertex[0].Color := D3DRGB((C1 and $FF) * mult, ((C1 shr 8) and $FF) * mult,
    ((C1 shr 16) and $FF) * mult);
  FVertex[1].Color := D3DRGB((C2 and $FF) * mult, ((C2 shr 8) and $FF) * mult,
    ((C2 shr 16) and $FF) * mult);
  FVertex[2].Color := D3DRGB((C3 and $FF) * mult, ((C3 shr 8) and $FF) * mult,
    ((C3 shr 16) and $FF) * mult);
  FVertex[3].Color := D3DRGB((C4 and $FF) * mult, ((C4 shr 8) and $FF) * mult,
    ((C4 shr 16) and $FF) * mult);
end;

procedure TD2D.RenderQuad;
begin
  RenderError := FDDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_TLVERTEX, FVertex, 4, D3DDP_WAIT) <> DD_OK;
  InitVertex;
end;

procedure TD2D.RenderTri;
begin
  RenderError := FDDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_TLVERTEX, FVertex, 3, D3DDP_WAIT) <> DD_OK;
  InitVertex;
end;

procedure TD2D.D2DMeshMapToRect(R: TRect);
begin
  FVertex[0].sx := R.Left - 0.5;
  FVertex[0].sy := R.Top - 0.5;
  FVertex[1].sx := R.Right - 0.5;
  FVertex[1].sy := R.Top - 0.5;
  FVertex[2].sx := R.Left - 0.5;
  FVertex[2].sy := R.Bottom - 0.5;
  FVertex[3].sx := R.Right - 0.5;
  FVertex[3].sy := R.Bottom - 0.5;
end;

{added function for Bump-mapping}

function TD2D.D2DEffectEmbossBumpMap(const lpDDSBase, lpDDSBump: IDirectDrawSurface7): Boolean;
var C: TD3DColor;
begin
  C := D3DRGB(1.0, 1.0, 1.0);
  FVertex[0].Color := C;
  FVertex[1].Color := C;
  FVertex[2].Color := C;
  FVertex[3].Color := C;

  with FDDraw.D3DDevice7 do
  try
    { No Textures }
    SetTexture(0, nil);
    SetTextureStageState(0, 0, 0);
    SetTexture(1, nil);
    SetTextureStageState(1, 0, 0);

    //
    // Program stage 0 to modulate diffuse.rgb with tex0.rgb
    //

    // Use the same texture on both stages
    SetTexture(0, lpDDSBase);

    SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 0);
    SetTextureStageState(0, D3DTSS_COLOROP, Integer(D3DTOP_MODULATE)); // Can also MODULATE2X here
    SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
    SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);
    SetTextureStageState(0, D3DTSS_ALPHAOP, Integer(D3DTOP_SELECTARG1));
    SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);

    //
    // Program Stage 1 to pass through the RGB channels. The texture coordinates
    // associated with Stage 1 are the shifted ones. Invert the alpha channel
    // and do a signed add.
    //

    SetTexture(1, lpDDSBump);

    SetTextureStageState(1, D3DTSS_TEXCOORDINDEX, 1);
    SetTextureStageState(1, D3DTSS_COLOROP, Integer(D3DTOP_SELECTARG2));
    SetTextureStageState(1, D3DTSS_COLORARG1, D3DTA_TEXTURE);
    SetTextureStageState(1, D3DTSS_COLORARG2, D3DTA_CURRENT);
    SetTextureStageState(1, D3DTSS_ALPHAOP, Integer(D3DTOP_ADDSIGNED)); // Can also ADDSIGNED2X here
    SetTextureStageState(1, D3DTSS_ALPHAARG1, D3DTA_TEXTURE or D3DTA_COMPLEMENT);
    SetTextureStageState(1, D3DTSS_ALPHAARG2, D3DTA_CURRENT);

    //
    // Set up the alpha blender to multiply the alpha channel (monochrome emboss)
    // with the src color (lighted texture)
    //

    SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 1);
    SetRenderState(D3DRENDERSTATE_SRCBLEND, Integer(D3DBLEND_SRCALPHA));
    SetRenderState(D3DRENDERSTATE_DESTBLEND, Integer(D3DBLEND_ZERO));

    Result := DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_TLVERTEX, FVertex, 4, D3DDP_WAIT) = DD_OK;

    //
    // The result is (height - shifted_height) * tex.RGB * diffuse.RGB
    //
  finally
    SetTexture(0, nil);
    SetTextureStageState(0, 0, 0);
    SetTexture(1, nil);
    SetTextureStageState(1, 0, 0);
  end;
end;

function TD2D.D2DEffectEnvBumpMap(const lpDDSBase, lpDDSBump,
  lpDDSLightMap: IDirectDrawSurface7;
  ITypeBPE: Integer; Alpha: Byte): Boolean;
  {Environmental bump mapping -- Perturbed UV Bump Mapping}
  function F2DW(f: Single): DWORD;
  {convert a Single as DWORD}
  begin
    Result := PDWord(@f)^;
  end;
var
  ColorTemp: TD3DColor;
begin
  //ColorTemp := D3DRGB(1.0, 1.0, 1.0);
  ColorTemp := RGBA_MAKE($FF, $FF, $FF, Alpha);
  FVertex[0].Color := ColorTemp;
  FVertex[1].Color := ColorTemp;
  FVertex[2].Color := ColorTemp;
  FVertex[3].Color := ColorTemp;

  with FDDraw.D3DDevice7 do
  try
    { No Textures }
    SetTexture(0, nil);
    SetTextureStageState(0, 0, 0);
    SetTexture(1, nil);
    SetTextureStageState(1, 0, 0);
    SetTexture(2, nil);
    SetTextureStageState(2, 0, 0);

    { Layer 0 }

    SetTexture(0, lpDDSBase);
    SetTextureStageState(0, D3DTSS_COLOROP, Integer(D3DTOP_MODULATE));
    SetTextureStageState(0, D3DTSS_COLORARG1, Integer(D3DTA_TEXTURE));
    SetTextureStageState(0, D3DTSS_COLORARG2, Integer(D3DTA_DIFFUSE));
    SetTextureStageState(0, D3DTSS_ALPHAOP, Integer(D3DTOP_DISABLE));

    { Layer 1 }

    SetTexture(1, lpDDSBump);
    SetTextureStageState(1, D3DTSS_COLOROP, Integer(ITypeBPE {D3DTOP_BUMPENVMAP.D3DTOP_DOTPRODUCT3}));
    SetTextureStageState(1, D3DTSS_COLORARG1, Integer(D3DTA_TEXTURE));
    SetTextureStageState(1, D3DTSS_COLORARG2, Integer(D3DTA_CURRENT));
    {value matrix D3DTSS_BUMPENVMATxx has to <=-8 and <8}
    SetTextureStageState(1, D3DTSS_BUMPENVMAT00, F2DW(0.5));
    SetTextureStageState(1, D3DTSS_BUMPENVMAT01, F2DW(0.0));
    SetTextureStageState(1, D3DTSS_BUMPENVMAT10, F2DW(0.0));
    SetTextureStageState(1, D3DTSS_BUMPENVMAT11, F2DW(0.5));
    SetTextureStageState(1, D3DTSS_BUMPENVLSCALE, F2DW(1.0));
    SetTextureStageState(1, D3DTSS_BUMPENVLOFFSET, F2DW(0.0));
    SetTextureStageState(1, D3DTSS_TEXCOORDINDEX, 0);

    { Layer 2 }

    SetTexture(2, lpDDSLightMap);
    SetTextureStageState(2, D3DTSS_COLOROP, Integer(D3DTOP_ADD));
    SetTextureStageState(2, D3DTSS_COLORARG1, Integer(D3DTA_TEXTURE));
    SetTextureStageState(2, D3DTSS_COLORARG2, Integer(D3DTA_CURRENT));
    SetTextureStageState(2, D3DTSS_ADDRESS, Integer(D3DTADDRESS_CLAMP));
    SetTextureStageState(2, D3DTSS_TEXCOORDINDEX, 1);
    SetTextureStageState(3, D3DTSS_COLOROP, Integer(D3DTOP_DISABLE));

    { ...render object... }
    Result := DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_TLVERTEX, FVertex, 4, D3DDP_WAIT + D3DDP_DONOTLIGHT) = DD_OK;

  finally
    {fill out stage}
    SetTexture(0, nil);
    SetTextureStageState(0, 0, 0);
    SetTexture(1, nil);
    SetTextureStageState(1, 0, 0);
    SetTexture(2, nil);
    SetTextureStageState(2, 0, 0);
  end;
end;

function TD2D.D2DRenderEnvBumpMap(Image, Bump, Light: TPictureCollectionItem; R: TRect;
  ImagePattern, BumpPattern, LightPattern: Integer; Alpha: Byte): Boolean;

  function BumpTexturedOn(Image: TPictureCollectionItem; Pattern: Integer; var TexNo: Integer): Boolean;
    function CanFindTexture(Image: TPictureCollectionItem): Boolean;
    var I: Integer;
    begin
      Result := True;
  {$IFNDEF DelphiX_Delphi3}
      if Length(FD2DTexture.Texture) > 0 then
  {$ELSE}
      if FD2DTexture.TexLen > 0 then
  {$ENDIF}
        for I := 0 to D2DMaxTextures - 1 do
          if FD2DTexture.Texture[I].Name = Image.Name then Exit;
      Result := False;
    end;
    function LoadTextures(aImage: TPictureCollectionItem): Boolean;
    var
      S: string;
      DIB: TDIB;
      T: TDXTextureImage;
    begin
      Result := True;
      try
        D2DPruneTextures; {up to 2048 textures only}
        D2DMaxTextures := D2DMaxTextures + 1;
        S := aImage.GetNamePath; {this name is supplement name, when wasn't aImage.Name fill}
        if aImage.Name = '' then
          aImage.Name := S;
        DIB := TDIB.Create;
        try
          DIB.Assign(aImage.Picture.Graphic);
          DIB.Transparent := aImage.Transparent;
          with FD2DTexture.Texture[D2DMaxTextures - 1] do begin
            FloatX1 := 0; FloatY1 := 0; FloatX2 := 1; FloatY2 := 1;
            SizeAdjust(DIB, FloatX1, FloatY1, FloatX2, FloatY2);
            Name := aImage.Name;
            Width := DIB.Width;
            Height := DIB.Height;
            if DIB.HasAlphaChannel then begin
              DIB2DXT(DIB, T);
              T.ImageName := aImage.Name;
              T.Transparent := aImage.Transparent;
              D2DTexture := TDirect3DTexture2.Create(FDDraw, T, False);
              D2DTexture.Transparent := aImage.Transparent;
              AlphaChannel := True;
              T.Free;
            end
            else begin
              D2DTexture := TDirect3DTexture2.Create(FDDraw, DIB, False);
              D2DTexture.TransparentColor := aImage.TransparentColor;
              D2DTexture.Surface.TransparentColor := aImage.TransparentColor;
              D2DTexture.Transparent := aImage.Transparent;
            end;
          end;
        finally
          DIB.Free;
        end;
      except
        D2DMaxTextures := D2DMaxTextures - 1;
        Result := False;
      end;
    end;
  var I: Integer;
    SrcX, SrcY: Double;
    R: TRect;
  begin
    Result := False;
    if not CanFindTexture(Image) then {when no texture in list try load it}
      if not LoadTextures(Image) then Exit; {on error occurr out}
    I := FD2DTexture.Find(Image.Name);
    if I = -1 then Exit;
    TexNo := I;
    {pokud je obrazek rozdeleny, nastav oka site}
    if (Image.PatternHeight <> 0) or (Image.PatternWidth <> 0) then begin
      {vezmi rect jenom dilku}
      R := Image.PatternRects[Pattern];
      SrcX := 1 / FD2DTexture.Texture[I].Width;
      SrcY := 1 / FD2DTexture.Texture[I].Height;
      //namapovani vertexu na texturu
      FD2DTexture.Texture[I].FloatX1 := SrcX * R.Left;
      FD2DTexture.Texture[I].FloatY1 := SrcY * R.Top;
      FD2DTexture.Texture[I].FloatX2 := SrcX * (R.Right - 1);
      FD2DTexture.Texture[I].FloatY2 := SrcY * (R.Bottom - 1);
    end {jinak celeho obrazku}
    {Else
      R := Bounds(0,0,Image.Picture.Width,Image.Picture.Height)};
    {  X1,Y1             X2,Y1
    0  +-----------------+  1
       |                 |
       |                 |
       |                 |
       |                 |
    2  +-----------------+  3
       X1,Y2             X2,Y2  }
    FVertex[0].tu := FD2DTexture.Texture[I].FloatX1;
    FVertex[0].tv := FD2DTexture.Texture[I].FloatY1;
    FVertex[1].tu := FD2DTexture.Texture[I].FloatX2;
    FVertex[1].tv := FD2DTexture.Texture[I].FloatY1;
    FVertex[2].tu := FD2DTexture.Texture[I].FloatX1;
    FVertex[2].tv := FD2DTexture.Texture[I].FloatY2;
    FVertex[3].tu := FD2DTexture.Texture[I].FloatX2;
    FVertex[3].tv := FD2DTexture.Texture[I].FloatY2;
    Result := True;
  end;
var
  TexImage, TexBump, TexLight: Integer;
  //ImagePatternWidth, ImagePatternHeight: Integer;
begin
  Result := False; if not CanUseD2D then Exit;
//  ImagePatternWidth := Image.PatternWidth; If ImagePatternWidth = 0 Then ImagePatternWidth := Image.Width;
//  ImagePatternHeight := Image.PatternHeight; If ImagePatternWidth = 0 Then ImagePatternWidth := Image.Height;
  {The same size has to Light and Bump}
  D2DMeshMapToRect(R);
  {Bump}
  if BumpTexturedOn(Image, ImagePattern, TexImage)
    and BumpTexturedOn(Bump, BumpPattern, TexBump)
    and BumpTexturedOn(Light, LightPattern, TexLight) then begin
    Result := D2DEffectEnvBumpMap(
      FD2DTexture.Texture[TexImage].D2DTexture.Surface.IDDSurface7,
      FD2DTexture.Texture[TexBump].D2DTexture.Surface.IDDSurface7,
      FD2DTexture.Texture[TexLight].D2DTexture.Surface.IDDSurface7,
      Integer(D3DTOP_BUMPENVMAP), Alpha);
  end;
end;

function TD2D.D2DInitializeSurface: Boolean;
begin
  Result := False;
  if Assigned(FDDraw.D3DDevice7) then
    Result := FDDraw.D3DDevice7.SetRenderTarget(FDDraw.Surface.IDDSurface7, 0) = DD_OK;
end;

initialization
  _DXTextureImageLoadFuncList := TList.Create;
  TDXTextureImage.RegisterLoadFunc(DXTextureImage_LoadDXTextureImageFunc);
  TDXTextureImage.RegisterLoadFunc(DXTextureImage_LoadBitmapFunc);
finalization
  TDXTextureImage.UnRegisterLoadFunc(DXTextureImage_LoadDXTextureImageFunc);
  TDXTextureImage.UnRegisterLoadFunc(DXTextureImage_LoadBitmapFunc);
  _DXTextureImageLoadFuncList.Free;
  { driver free }
  DirectDrawDrivers.Free;
end.