 unit DXDraws;

interface

{$INCLUDE DelphiXcfg.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  DXClass, DIB, DXTexImg, DirectX;

type

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
    function CreateSurface(const SurfaceDesc: TDDSurfaceDesc): Boolean; overload;
    function CreateSurface(const SurfaceDesc: TDDSurfaceDesc2): Boolean; overload;
{$ELSE}
    function CreateSurface(const SurfaceDesc: TDDSurfaceDesc): Boolean;
{$ENDIF}
{$IFDEF DelphiX_Spt4}
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDirectDrawSurface; Transparent: Boolean=True); overload;
    procedure Draw(X, Y: Integer; Source: TDirectDrawSurface; Transparent: Boolean=True); overload;
    procedure StretchDraw(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean=True); overload;
    procedure StretchDraw(const DestRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean=True); overload;
{$ELSE}
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean);
    procedure StretchDraw(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean);
{$ENDIF}
    procedure DrawAdd(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Alpha: Integer{$IFDEF DelphiX_Spt4}=255{$ENDIF});
    procedure DrawAlpha(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Alpha: Integer);
    procedure DrawSub(const DestRect, SrcRect: TRect; Source: TDirectDrawSurface;
      Transparent: Boolean; Alpha: Integer{$IFDEF DelphiX_Spt4}=255{$ENDIF});
    procedure DrawRotate(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: Integer);
    procedure DrawRotateAdd(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4}=255{$ENDIF});
    procedure DrawRotateAlpha(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: Integer;
      Alpha: Integer);
    procedure DrawRotateSub(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4}=255{$ENDIF});
    procedure DrawWaveX(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer);
    procedure DrawWaveXAdd(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4}=255{$ENDIF});
    procedure DrawWaveXAlpha(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer);
    procedure DrawWaveXSub(X, Y, Width, Height: Integer; const SrcRect: TRect;
      Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4}=255{$ENDIF});
    procedure Fill(DevColor: Longint);
    procedure FillRect(const Rect: TRect; DevColor: Longint);
    procedure FillRectAdd(const DestRect: TRect; Color: TColor);
    procedure FillRectAlpha(const DestRect: TRect; Color: TColor; Alpha: Integer);
    procedure FillRectSub(const DestRect: TRect; Color: TColor);
    procedure LoadFromDIB(DIB: TDIB);
    procedure LoadFromDIBRect(DIB: TDIB; AWidth, AHeight: Integer; const SrcRect: TRect);
    procedure LoadFromGraphic(Graphic: TGraphic);
    procedure LoadFromGraphicRect(Graphic: TGraphic; AWidth, AHeight: Integer; const SrcRect: TRect);
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
{$IFDEF DelphiX_Spt4}
    function Lock(const Rect: TRect; var SurfaceDesc: TDDSurfaceDesc): Boolean; overload;
    function Lock(var SurfaceDesc: TDDSurfaceDesc): Boolean; overload;
{$ELSE}
    function Lock(const Rect: TRect; var SurfaceDesc: TDDSurfaceDesc): Boolean;
{$ENDIF}
    procedure UnLock;
    function Restore: Boolean;
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
    property BitCount: Integer read FBitCount write SetBitCount default 8;
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
    procedure FormWndProc(var Message: TMessage; DefWindowProc: TWndMethod);
    function GetCanDraw: Boolean;
    function GetCanPaletteAnimation: Boolean;
    function GetSurfaceHeight: Integer;
    function GetSurfaceWidth: Integer;
    procedure NotifyEventList(NotifyType: TDXDrawNotifyType);
    procedure SetAutoSize(Value: Boolean);
    procedure SetColorTable(const ColorTable: TRGBQuads);
    procedure SetCooperativeLevel;
    procedure SetDisplay(Value: TDXDrawDisplay);
    procedure SetDriver(Value: PGUID);
    procedure SetOptions(Value: TDXDrawOptions);
    procedure SetSurfaceHeight(Value: Integer);
    procedure SetSurfaceWidth(Value: Integer);
    function TryRestore: Boolean;
    procedure WMCreate(var Message: TMessage); message WM_CREATE;
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
    {$IFDEF DelphiX_Spt4}property Anchors;{$ENDIF}
    {$IFDEF DelphiX_Spt4}property Constraints;{$ENDIF}
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
    {$IFDEF DelphiX_Spt4}property OnResize;{$ENDIF}
    property OnStartDrag;
  end;

  {  EDX3DError  }

  EDX3DError = class(Exception);

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
    procedure SetOptions(Value: TDX3DOptions);
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
    procedure StretchDraw(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer);
    procedure DrawAdd(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4}=255{$ENDIF});
    procedure DrawAlpha(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
      Alpha: Integer);
    procedure DrawSub(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4}=255{$ENDIF});
    procedure DrawRotate(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: Integer);
    procedure DrawRotateAdd(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4}=255{$ENDIF});
    procedure DrawRotateAlpha(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: Integer;
      Alpha: Integer);
    procedure DrawRotateSub(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      CenterX, CenterY: Double; Angle: Integer;
      Alpha: Integer{$IFDEF DelphiX_Spt4}=255{$ENDIF});
    procedure DrawWaveX(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer);
    procedure DrawWaveXAdd(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4}=255{$ENDIF});
    procedure DrawWaveXAlpha(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer);
    procedure DrawWaveXSub(Dest: TDirectDrawSurface; X, Y, Width, Height: Integer; PatternIndex: Integer;
      amp, Len, ph: Integer; Alpha: Integer{$IFDEF DelphiX_Spt4}=255{$ENDIF});
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
  if DirectDrawDrivers=nil then
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
    if TDirectDrawCreateEx(DXLoadLibrary('DDraw.dll', 'DirectDrawCreateEx')) (GUID, FIDDraw7, IID_IDirectDraw7, nil)<>DD_OK then
      raise EDirectDrawError.CreateFmt(SCannotInitialized, [SDirectDraw]);
    try
      FIDDraw := FIDDraw7 as IDirectDraw;
      FIDDraw4 := FIDDraw7 as IDirectDraw4;
    except
      raise EDirectDrawError.Create(SSinceDirectX7);
    end;
  end else
  begin
    if TDirectDrawCreate(DXLoadLibrary('DDraw.dll', 'DirectDrawCreate')) (GUID, FIDDraw, nil)<>DD_OK then
      raise EDirectDrawError.CreateFmt(SCannotInitialized, [SDirectDraw]);
    try
      FIDDraw4 := FIDDraw as IDirectDraw4;
    except
      raise EDirectDrawError.Create(SSinceDirectX6);
    end;
  end;

  FDriverCaps.dwSize := SizeOf(FDriverCaps);
  FHELCaps.dwSize := SizeOf(FHELCaps);
  FIDDraw.GetCaps(FDriverCaps, FHELCaps);
end;

destructor TDirectDraw.Destroy;
begin
  while SurfaceCount>0 do
    Surfaces[SurfaceCount-1].Free;

  while PaletteCount>0 do
    Palettes[PaletteCount-1].Free;

  while ClipperCount>0 do
    Clippers[ClipperCount-1].Free;

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
  if DXResult<>DD_OK then
    FillChar(Result, SizeOf(Result), 0);
end;

function TDirectDraw.GetIDDraw: IDirectDraw;
begin
  if Self<>nil then
    Result := FIDDraw
  else
    Result := nil;
end;

function TDirectDraw.GetIDDraw4: IDirectDraw4;
begin
  if Self<>nil then
    Result := FIDDraw4
  else
    Result := nil;
end;

function TDirectDraw.GetIDDraw7: IDirectDraw7;
begin
  if Self<>nil then
    Result := FIDDraw7
  else
    Result := nil;
end;

function TDirectDraw.GetIDraw: IDirectDraw;
begin
  Result := IDDraw;
  if Result=nil then
    raise EDirectDrawError.CreateFmt(SNotMade, ['IDirectDraw']);
end;

function TDirectDraw.GetIDraw4: IDirectDraw4;
begin
  Result := IDDraw4;
  if Result=nil then
    raise EDirectDrawError.CreateFmt(SNotMade, ['IDirectDraw4']);
end;

function TDirectDraw.GetIDraw7: IDirectDraw7;
begin
  Result := IDDraw7;
  if Result=nil then
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
  Result := FDDraw.DXResult=DD_OK;
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
    if DIB.Size>0 then
      LoadFromDIB(DIB);
  finally
    DIB.Free;
  end;
end;

function TDirectDrawPalette.GetEntries(StartIndex, NumEntries: Integer;
  var Entries): Boolean;
begin
  if IDDPalette<>nil then
  begin
    DXResult := IPalette.GetEntries(0, StartIndex, NumEntries, @Entries);
    Result := DXResult=DD_OK;
  end else
    Result := False;
end;

function TDirectDrawPalette.GetEntry(Index: Integer): TPaletteEntry;
begin
  GetEntries(Index, 1, Result);
end;

function TDirectDrawPalette.GetIDDPalette: IDirectDrawPalette;
begin
  if Self<>nil then
    Result := FIDDPalette
  else
    Result := nil;
end;

function TDirectDrawPalette.GetIPalette: IDirectDrawPalette;
begin
  Result := IDDPalette;
  if Result=nil then
    raise EDirectDrawPaletteError.CreateFmt(SNotMade, ['IDirectDrawPalette']);
end;

function TDirectDrawPalette.SetEntries(StartIndex, NumEntries: Integer;
  const Entries): Boolean;
begin
  if IDDPalette<>nil then
  begin
    DXResult := IPalette.SetEntries(0, StartIndex, NumEntries, @Entries);
    Result := DXResult=DD_OK;
  end else
    Result := False;
end;

procedure TDirectDrawPalette.SetEntry(Index: Integer; Value: TPaletteEntry);
begin
  SetEntries(Index, 1, Value);
end;

procedure TDirectDrawPalette.SetIDDPalette(Value: IDirectDrawPalette);
begin
  if FIDDPalette=Value then Exit;
  FIDDPalette := Value;
end;

{  TDirectDrawClipper  }

constructor TDirectDrawClipper.Create(ADirectDraw: TDirectDraw);
begin
  inherited Create;
  FDDraw := ADirectDraw;
  FDDraw.FClippers.Add(Self);

  FDDraw.DXResult := FDDraw.IDraw.CreateClipper(0, FIDDClipper, nil);
  if FDDraw.DXResult<>DD_OK then
    raise EDirectDrawClipperError.CreateFmt(SCannotMade, [SDirectDrawClipper]);
end;

destructor TDirectDrawClipper.Destroy;
begin
  FDDraw.FClippers.Remove(Self);
  inherited Destroy;
end;

function TDirectDrawClipper.GetIDDClipper: IDirectDrawClipper;
begin
  if Self<>nil then
    Result := FIDDClipper
  else
    Result := nil;
end;

function TDirectDrawClipper.GetIClipper: IDirectDrawClipper;
begin
  Result := IDDClipper;
  if Result=nil then
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
  for i:=Low(Rects) to High(Rects) do
  begin
    with BoundsRect do
    begin
      Left := Min(Rects[i].Left, Left);
      Right := Max(Rects[i].Right, Right);
      Top := Min(Rects[i].Top, Top);
      Bottom := Max(Rects[i].Bottom, Bottom);
    end;                           
  end;

  GetMem(RgnData, SizeOf(TRgnDataHeader)+SizeOf(TRect)*(High(Rects)-Low(Rects)+1));
  try
    with RgnData^.rdh do
    begin
      dwSize := SizeOf(TRgnDataHeader);
      iType := RDH_RECTANGLES;
      nCount := High(Rects)-Low(Rects)+1;
      nRgnSize := nCount*SizeOf(TRect);
      rcBound := BoundsRect;
    end;
    for i:=Low(Rects) to High(Rects) do
      PArrayRect(@RgnData^.Buffer)^[i-Low(Rects)] := Rects[i];
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
  if FIDDClipper=Value then Exit;
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
  if FSurface.DXResult=DD_OK then
    Handle := FDC;
end;

procedure TDirectDrawSurfaceCanvas.Release;
begin
  if (FSurface.IDDSurface<>nil) and (FDC<>0) then
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
  if Self<>nil then
    Result := FIDDSurface
  else
    Result := nil;
end;

function TDirectDrawSurface.GetIDDSurface4: IDirectDrawSurface4;
begin
  if Self<>nil then
    Result := FIDDSurface4
  else
    Result := nil;
end;

function TDirectDrawSurface.GetIDDSurface7: IDirectDrawSurface7;
begin
  if Self<>nil then
    Result := FIDDSurface7
  else
    Result := nil;
end;

function TDirectDrawSurface.GetISurface: IDirectDrawSurface;
begin
  Result := IDDSurface;
  if Result=nil then
    raise EDirectDrawSurfaceError.CreateFmt(SNotMade, ['IDirectDrawSurface']);
end;

function TDirectDrawSurface.GetISurface4: IDirectDrawSurface4;
begin
  Result := IDDSurface4;
  if Result=nil then
    raise EDirectDrawSurfaceError.CreateFmt(SNotMade, ['IDirectDrawSurface4']);
end;

function TDirectDrawSurface.GetISurface7: IDirectDrawSurface7;
begin
  Result := IDDSurface7;
  if Result=nil then
    raise EDirectDrawSurfaceError.CreateFmt(SNotMade, ['IDirectDrawSurface7']);
end;

procedure TDirectDrawSurface.SetIDDSurface(Value: IDirectDrawSurface);
var
  Clipper: IDirectDrawClipper;
begin
  if Value=nil then Exit;
  if Value as IDirectDrawSurface=FIDDSurface then Exit;

  FIDDSurface := nil;
  FIDDSurface4 := nil;
  FIDDSurface7 := nil;

  FStretchDrawClipper := nil;
  FGammaControl := nil;
  FHasClipper := False;
  FLockCount := 0;
  FillChar(FSurfaceDesc, SizeOf(FSurfaceDesc), 0);

  if Value<>nil then
  begin
    FIDDSurface := Value as IDirectDrawSurface;
    FIDDSurface4 := Value as IDirectDrawSurface4;
    if FDDraw.FIDDraw7<>nil then FIDDSurface7 := Value as IDirectDrawSurface7;

    FHasClipper := (FIDDSurface.GetClipper(Clipper)=DD_OK) and (Clipper<>nil);

    FSurfaceDesc.dwSize := SizeOf(FSurfaceDesc);
    FIDDSurface.GetSurfaceDesc(FSurfaceDesc);

    if FDDraw.DriverCaps.dwCaps2 and DDCAPS2_PRIMARYGAMMA<>0 then
      FIDDSurface.QueryInterface(IID_IDirectDrawGammaControl, FGammaControl);
  end;
end;

procedure TDirectDrawSurface.SetIDDSurface4(Value: IDirectDrawSurface4);
begin
  if Value=nil then
    SetIDDSurface(nil)
  else
    SetIDDSurface(Value as IDirectDrawSurface);
end;

procedure TDirectDrawSurface.SetIDDSurface7(Value: IDirectDrawSurface7);
begin
  if Value=nil then
    SetIDDSurface(nil)
  else
    SetIDDSurface(Value as IDirectDrawSurface);
end;

procedure TDirectDrawSurface.Assign(Source: TPersistent);
var
  TempSurface: IDirectDrawSurface;
begin
  if Source=nil then
    IDDSurface := nil
  else if Source is TGraphic then
    LoadFromGraphic(TGraphic(Source))
  else if Source is TPicture then
    LoadFromGraphic(TPicture(Source).Graphic)
  else if Source is TDirectDrawSurface then
  begin
    if TDirectDrawSurface(Source).IDDSurface=nil then
      IDDSurface := nil
    else begin
      FDDraw.DXResult := FDDraw.IDraw.DuplicateSurface(TDirectDrawSurface(Source).IDDSurface,
        TempSurface);
      if FDDraw.DXResult=0 then
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
    TDIB(Dest).SetSize(Width, Height, 24);
    TDIB(Dest).Canvas.CopyRect(Rect(0, 0, TDIB(Dest).Width, TDIB(Dest).Height), Canvas, ClientRect);
    Canvas.Release;
  end else
    inherited AssignTo(Dest);
end;

function TDirectDrawSurface.Blt(const DestRect, SrcRect: TRect; Flags: DWORD;
  const DF: TDDBltFX; Source: TDirectDrawSurface): Boolean;
begin
  if IDDSurface<>nil then
  begin
    DXResult := ISurface.Blt(DestRect, Source.IDDSurface, SrcRect, DWORD(Flags), DF);
    Result := DXResult=DD_OK;
  end else
    Result := False;
end;

function TDirectDrawSurface.BltFast(X, Y: Integer; const SrcRect: TRect;
  Flags: DWORD; Source: TDirectDrawSurface): Boolean;
begin
  if IDDSurface<>nil then
  begin
    DXResult := ISurface.BltFast(X, Y, Source.IDDSurface, SrcRect, DWORD(Flags));
    Result := DXResult=DD_OK;
  end else
    Result := False;
end;

function TDirectDrawSurface.ColorMatch(Col: TColor): Integer;
var
  DIB: TDIB;
  i, oldc: Integer;
begin
  if IDDSurface<>nil then
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
      begin
        Draw(0, 0, DIB);
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

function TDirectDrawSurface.CreateSurface(const SurfaceDesc: TDDSurfaceDesc): Boolean;
var
  TempSurface: IDirectDrawSurface;
begin
  IDDSurface := nil;

  FDDraw.DXResult := FDDraw.IDraw.CreateSurface(SurfaceDesc, TempSurface, nil);
  FDXResult := FDDraw.DXResult;
  Result := FDDraw.DXResult=DD_OK;
  if Result then
  begin
    IDDSurface := TempSurface;
    TransparentColor := 0;
  end;
end;

{$IFDEF DelphiX_Spt4}
function TDirectDrawSurface.CreateSurface(const SurfaceDesc: TDDSurfaceDesc2): Boolean;
var
  TempSurface4: IDirectDrawSurface4;
begin
  IDDSurface := nil;
  FDDraw.DXResult := FDDraw.IDraw4.CreateSurface(SurfaceDesc, TempSurface4, nil);
  FDXResult := FDDraw.DXResult;
  Result := FDDraw.DXResult=DD_OK;
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
  if Source<>nil then
  begin
    if (X>Width) or (Y>Height) then Exit;

    if (SrcRect.Left>SrcRect.Right) or (SrcRect.Top>SrcRect.Bottom) then
    begin
      {  Mirror  }
      if ((X+Abs(SrcRect.Left-SrcRect.Right))<=0) or
        ((Y+Abs(SrcRect.Top-SrcRect.Bottom))<=0) then Exit;

      DF.dwsize := SizeOf(DF);
      DF.dwDDFX := 0;

      if SrcRect.Left>SrcRect.Right then
      begin
        i := SrcRect.Left; SrcRect.Left := SrcRect.Right; SrcRect.Right := i;
        DF.dwDDFX := DF.dwDDFX or DDBLTFX_MIRRORLEFTRIGHT;
      end;

      if SrcRect.Top>SrcRect.Bottom then
      begin
        i := SrcRect.Top; SrcRect.Top := SrcRect.Bottom; SrcRect.Bottom := i;
        DF.dwDDFX := DF.dwDDFX or DDBLTFX_MIRRORUPDOWN;
      end;

      with SrcRect do
        DestRect := Bounds(X, Y, Right-Left, Bottom-Top);

      if ClipRect2(DestRect, SrcRect, ClientRect, Source.ClientRect) then
      begin
        if DF.dwDDFX and DDBLTFX_MIRRORLEFTRIGHT<>0 then
        begin
          i := SrcRect.Left;
          SrcRect.Left := Source.Width-SrcRect.Right;
          SrcRect.Right := Source.Width-i;
        end;

        if DF.dwDDFX and DDBLTFX_MIRRORUPDOWN<>0 then
        begin
          i := SrcRect.Top;
          SrcRect.Top := Source.Height-SrcRect.Bottom;
          SrcRect.Bottom := Source.Height-i;
        end;
                                                   
        Blt(DestRect, SrcRect, BltFlags[Transparent] or DDBLT_DDFX, df, Source);
      end;
    end else
    begin
      with SrcRect do
        DestRect := Bounds(X, Y, Right-Left, Bottom-Top);

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
          if DXResult=DDERR_BLTFASTCANTCLIP then
          begin
            ISurface.GetClipper(Clipper);
            if Clipper<>nil then FHasClipper := True;

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
  if Source<>nil then
  begin
    SrcRect := Source.ClientRect;
    DestRect := Bounds(X, Y, Source.Width, Source.Height);

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
        if DXResult=DDERR_BLTFASTCANTCLIP then
        begin
          ISurface.GetClipper(Clipper);
          if Clipper<>nil then FHasClipper := True;

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
  if Source<>nil then
  begin
    if (DestRect.Bottom<=DestRect.Top) or (DestRect.Right<=DestRect.Left) then Exit;
    if (SrcRect.Bottom<=SrcRect.Top) or (SrcRect.Right<=SrcRect.Left) then Exit;

    if FHasClipper then
    begin
      DF.dwsize := SizeOf(DF);
      DF.dwDDFX := 0;
      Blt(DestRect, SrcRect, BltFlags[Transparent], df, Source);
    end else
    begin
      if FStretchDrawClipper=nil then
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
  if Source<>nil then
  begin
    if (DestRect.Bottom<=DestRect.Top) or (DestRect.Right<=DestRect.Left) then Exit;
    SrcRect := Source.ClientRect;

    if ISurface.GetClipper(OldClipper)=DD_OK then
    begin
      DF.dwsize := SizeOf(DF);
      DF.dwDDFX := 0;
      Blt(DestRect, SrcRect, BltFlags[Transparent], df, Source);
    end else
    begin
      if FStretchDrawClipper=nil then
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
  if (Self.Width=0) or (Self.Height=0) then Exit;
  if (Width=0) or (Height=0) then Exit;
  if Source=nil then Exit;
  if (Source.Width=0) or (Source.Height=0) then Exit;

  if Alpha<=0 then Exit;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType=DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
          if Alpha>=255 then
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
  if (Self.Width=0) or (Self.Height=0) then Exit;
  if (Width=0) or (Height=0) then Exit;
  if Source=nil then Exit;
  if (Source.Width=0) or (Source.Height=0) then Exit;

  if Alpha<=0 then Exit;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType=DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
          if Alpha>=255 then
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
  if (Self.Width=0) or (Self.Height=0) then Exit;
  if (Width=0) or (Height=0) then Exit;
  if Source=nil then Exit;
  if (Source.Width=0) or (Source.Height=0) then Exit;

  if Alpha<=0 then Exit;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType=DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
          if Alpha>=255 then
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

procedure TDirectDrawSurface.DrawRotate(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
begin
  if (Self.Width=0) or (Self.Height=0) then Exit;
  if (Width=0) or (Height=0) then Exit;
  if Source=nil then Exit;
  if (Source.Width=0) or (Source.Height=0) then Exit;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          dxrDrawRotateBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, CenterX, CenterY, Angle, DXR_BLEND_ONE1, 0,
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
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle, Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha<=0 then Exit;

  if (Self.Width=0) or (Self.Height=0) then Exit;
  if (Width=0) or (Height=0) then Exit;
  if Source=nil then Exit;
  if (Source.Width=0) or (Source.Height=0) then Exit;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType=DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
          if Alpha>=255 then
          begin
            Blend := DXR_BLEND_ONE1_ADD_ONE2;
          end else
          begin
            Blend := DXR_BLEND_SRCALPHA1_ADD_ONE2;
          end;

          dxrDrawRotateBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, CenterX, CenterY, Angle, Blend, Alpha,
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
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle, Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha<=0 then Exit;

  if (Self.Width=0) or (Self.Height=0) then Exit;
  if (Width=0) or (Height=0) then Exit;
  if Source=nil then Exit;
  if (Source.Width=0) or (Source.Height=0) then Exit;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType=DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
          if Alpha>=255 then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
          begin
            Blend := DXR_BLEND_SRCALPHA1_ADD_INVSRCALPHA2;
          end;

          dxrDrawRotateBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, CenterX, CenterY, Angle, Blend, Alpha,
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
  Source: TDirectDrawSurface; CenterX, CenterY: Double; Transparent: Boolean; Angle, Alpha: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
  Blend: TDXR_Blend;
begin
  if Alpha<=0 then Exit;

  if (Self.Width=0) or (Self.Height=0) then Exit;
  if (Width=0) or (Height=0) then Exit;
  if Source=nil then Exit;
  if (Source.Width=0) or (Source.Height=0) then Exit;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType=DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
          if Alpha>=255 then
          begin
            Blend := DXR_BLEND_ONE2_SUB_ONE1;
          end else
          begin
            Blend := DXR_BLEND_ONE2_SUB_SRCALPHA1;
          end;

          dxrDrawRotateBlend(DestSurface, SrcSurface,
            X, Y, Width, Height, SrcRect, CenterX, CenterY, Angle, Blend, Alpha,
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

procedure TDirectDrawSurface.DrawWaveX(X, Y, Width, Height: Integer; const SrcRect: TRect;
  Source: TDirectDrawSurface; Transparent: Boolean; amp, Len, ph: Integer);
var
  Src_ddsd: TDDSurfaceDesc;
  DestSurface, SrcSurface: TDXR_Surface;
begin
  if (Self.Width=0) or (Self.Height=0) then Exit;
  if (Width=0) or (Height=0) then Exit;
  if Source=nil then Exit;
  if (Source.Width=0) or (Source.Height=0) then Exit;

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
  if Alpha<=0 then Exit;

  if (Self.Width=0) or (Self.Height=0) then Exit;
  if (Width=0) or (Height=0) then Exit;
  if Source=nil then Exit;
  if (Source.Width=0) or (Source.Height=0) then Exit;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType=DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
          if Alpha>=255 then
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
  if Alpha<=0 then Exit;

  if (Self.Width=0) or (Self.Height=0) then Exit;
  if (Width=0) or (Height=0) then Exit;
  if Source=nil then Exit;
  if (Source.Width=0) or (Source.Height=0) then Exit;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType=DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
          if Alpha>=255 then
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
  if Alpha<=0 then Exit;

  if (Self.Width=0) or (Self.Height=0) then Exit;
  if (Width=0) or (Height=0) then Exit;
  if Source=nil then Exit;
  if (Source.Width=0) or (Source.Height=0) then Exit;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      if dxrDDSurfaceLock2(Source.ISurface, Src_ddsd, SrcSurface) then
      begin
        try
          if DestSurface.ColorType=DXR_COLORTYPE_INDEXED then
          begin
            Blend := DXR_BLEND_ONE1;
          end else
          if Alpha>=255 then
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

procedure TDirectDrawSurface.FillRectAdd(const DestRect: TRect; Color: TColor);
var
  DestSurface: TDXR_Surface;
begin
  if Color and $FFFFFF=0 then Exit;
  if (Self.Width=0) or (Self.Height=0) then Exit;
  if SurfaceDesc.ddpfPixelFormat.dwFlags and (DDPF_PALETTEINDEXED1 or DDPF_PALETTEINDEXED2 or
    DDPF_PALETTEINDEXED4 or DDPF_PALETTEINDEXED8)<>0 then Exit;

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
  if (Self.Width=0) or (Self.Height=0) then Exit;
  if SurfaceDesc.ddpfPixelFormat.dwFlags and (DDPF_PALETTEINDEXED1 or DDPF_PALETTEINDEXED2 or
    DDPF_PALETTEINDEXED4 or DDPF_PALETTEINDEXED8)<>0 then Exit;

  if dxrDDSurfaceLock(ISurface, DestSurface) then
  begin
    try
      dxrFillRectColorBlend(DestSurface, DestRect, DXR_BLEND_SRCALPHA1_ADD_INVSRCALPHA2, ColorToRGB(Color) or (Byte(Alpha) shl 24));
    finally
      dxrDDSurfaceUnLock(ISurface, DestSurface)
    end;
  end;
end;

procedure TDirectDrawSurface.FillRectSub(const DestRect: TRect; Color: TColor);
var
  DestSurface: TDXR_Surface;
begin
  if Color and $FFFFFF=0 then Exit;
  if (Self.Width=0) or (Self.Height=0) then Exit;
  if SurfaceDesc.ddpfPixelFormat.dwFlags and (DDPF_PALETTEINDEXED1 or DDPF_PALETTEINDEXED2 or
    DDPF_PALETTEINDEXED4 or DDPF_PALETTEINDEXED8)<>0 then Exit;

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
  if FCanvas=nil then
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
  if (IDDSurface<>nil) and (X>=0) and (X<Width) and (Y>=0) and (Y<Height) then
    if Lock(PRect(nil)^, ddsd) then
    begin
      try
        case ddsd.ddpfPixelFormat.dwRGBBitCount of
          1 : Result := Integer(PByte(Integer(ddsd.lpSurface)+
                Y*ddsd.lPitch+(X shr 3))^ and (1 shl (X and 7))<>0);
          4 : begin
                if X and 1=0 then
                  Result := PByte(Integer(ddsd.lpSurface)+Y*ddsd.lPitch+(X shr 1))^ shr 4
                else
                  Result := PByte(Integer(ddsd.lpSurface)+Y*ddsd.lPitch+(X shr 1))^ and $0F;
              end;
          8 : Result := PByte(Integer(ddsd.lpSurface)+Y*ddsd.lPitch+X)^;
          16: Result := PWord(Integer(ddsd.lpSurface)+Y*ddsd.lPitch+X*2)^;
          24: with PRGB(Integer(ddsd.lpSurface)+Y*ddsd.lPitch+X*3)^ do
                Result := R or (G shl 8) or (B shl 16);
          32: Result := PInteger(Integer(ddsd.lpSurface)+Y*ddsd.lPitch+X*4)^;
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
  if AWidth=0 then
    AWidth := SrcRect.Right-SrcRect.Left;
  if AHeight=0 then
    AHeight := SrcRect.Bottom-SrcRect.Top;

  SetSize(AWidth, AHeight);

  with SrcRect do
    if Graphic is TDIB then
    begin
      with Canvas do
      begin
        StretchBlt(Handle, 0, 0, AWidth, AHeight, TDIB(Graphic).Canvas.Handle,
          Left, Top, Right-Left, Bottom-Top,SRCCOPY);
        Release;
      end;
    end else if (Right-Left=AWidth) and (Bottom-Top=AHeight) then
    begin
      with Canvas do
      begin
        Draw(-Left, -Top, Graphic);
        Release;
      end;
    end else
    begin
      Temp := TDIB.Create;
      try
        Temp.SetSize(Right-Left, Bottom-Top, 24);
        Temp.Canvas.Draw(-Left, -Top, Graphic);

        with Canvas do
        begin
          StretchDraw(Bounds(0, 0, AWidth, AHeight), Temp);
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
    if DIB.Size>0 then
      LoadFromGraphic(DIB);
  finally
    DIB.Free;                
  end;
end;

function TDirectDrawSurface.Lock(const Rect: TRect; var SurfaceDesc: TDDSurfaceDesc): Boolean;
begin
  Result := False;
  if IDDSurface=nil then Exit;

  if FLockCount>0 then Exit;

  FLockSurfaceDesc.dwSize := SizeOf(FLockSurfaceDesc);

  if (@Rect<>nil) and ((Rect.Left<>0) or (Rect.Top<>0) or (Rect.Right<>Width) or (Rect.Bottom<>Height)) then
    DXResult := ISurface.Lock(@Rect, FLockSurfaceDesc, DDLOCK_WAIT, 0)
  else                                                                
    DXResult := ISurface.Lock(nil, FLockSurfaceDesc, DDLOCK_WAIT, 0);
  if DXResult<>DD_OK then Exit;

  Inc(FLockCount);
  SurfaceDesc := FLockSurfaceDesc;

  Result := True;
end;
                    
{$IFDEF DelphiX_Spt4}
function TDirectDrawSurface.Lock(var SurfaceDesc: TDDSurfaceDesc): Boolean;
begin
  Result := False;
  if IDDSurface=nil then Exit;

  if FLockCount=0 then
  begin
    FLockSurfaceDesc.dwSize := SizeOf(FLockSurfaceDesc);
    DXResult := ISurface.Lock(nil, FLockSurfaceDesc, DDLOCK_WAIT, 0);
    if DXResult<>DD_OK then Exit;
  end;

  Inc(FLockCount);
  SurfaceDesc := FLockSurfaceDesc;
  Result := True;
end;
{$ENDIF}

procedure TDirectDrawSurface.UnLock;
begin
  if IDDSurface=nil then Exit;

  if FLockCount>0 then
  begin
    Dec(FLockCount);
    if FLockCount=0 then
      DXResult := ISurface.UnLock(FLockSurfaceDesc.lpSurface);
  end;
end;

function TDirectDrawSurface.Restore: Boolean;
begin
  if IDDSurface<>nil then
  begin
    DXResult := ISurface.Restore;
    Result := DXResult=DD_OK;
  end else
    Result := False;
end;

procedure TDirectDrawSurface.SetClipper(Value: TDirectDrawClipper);
begin
  if IDDSurface<>nil then
    DXResult := ISurface.SetClipper(Value.IDDClipper);
  FHasClipper := (Value<>nil) and (DXResult=DD_OK);
end;

procedure TDirectDrawSurface.SetColorKey(Flags: DWORD; const Value: TDDColorKey);
begin
  if IDDSurface<>nil then
    DXResult := ISurface.SetColorKey(Flags, Value);
end;

procedure TDirectDrawSurface.SetPalette(Value: TDirectDrawPalette);
begin
  if IDDSurface<>nil then
    DXResult := ISurface.SetPalette(Value.IDDPalette);
end;

procedure TDirectDrawSurface.SetPixel(X, Y: Integer; Value: Longint);
var
  ddsd: TDDSurfaceDesc;
  P: PByte;
begin
  if (IDDSurface<>nil) and (X>=0) and (X<Width) and (Y>=0) and (Y<Height) then
    if Lock(PRect(nil)^, ddsd) then
    begin
      try
        case ddsd.ddpfPixelFormat.dwRGBBitCount of
          1 : begin
                P := PByte(Integer(ddsd.lpSurface)+Y*ddsd.lPitch+(X shr 3));
                if Value=0 then
                  P^ := P^ and (not (1 shl (7-(X and 7))))
                else
                  P^ := P^ or (1 shl (7-(X and 7)));
              end;
          4 : begin
                P := PByte(Integer(ddsd.lpSurface)+Y*ddsd.lPitch+(X shr 1));
                if X and 1=0 then
                  P^ := (P^ and $0F) or (Value shl 4)
                else
                  P^ := (P^ and $F0) or (Value and $0F);
              end;
          8 : PByte(Integer(ddsd.lpSurface)+Y*ddsd.lPitch+X)^ := Value;
          16: PWord(Integer(ddsd.lpSurface)+Y*ddsd.lPitch+X*2)^ := Value;
          24: with PRGB(Integer(ddsd.lpSurface)+Y*ddsd.lPitch+X*3)^ do
              begin
                R := Byte(Value);
                G := Byte(Value shr 8);
                B := Byte(Value shr 16);
              end;
          32: PInteger(Integer(ddsd.lpSurface)+Y*ddsd.lPitch+X*4)^ := Value;
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
  if (AWidth<=0) or (AHeight<=0) then
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
  if ddsd.ddsCaps.dwCaps and DDSCAPS_SYSTEMMEMORY=0 then
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
  FBitCount := 8;
  FFixedBitCount := True;
  FFixedRatio := True;
  FFixedSize := False;
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
    if Source<>Self then
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
  if FModes.Count=0 then
    LoadDisplayModes;
  Result := FModes.Count;
end;

function TDXDrawDisplay.GetMode: TDXDrawDisplayMode;
var
  i: Integer;
  ddsd: TDDSurfaceDesc;
begin
  Result := nil;
  if FDXDraw.DDraw<>nil then
  begin
    ddsd := FDXDraw.DDraw.DisplayMode;
    with ddsd do
      i := IndexOf(dwWidth, dwHeight, ddpfPixelFormat.dwRGBBitCount);
    if i<>-1 then
      Result := Modes[i];
  end;
  if Result=nil then
    raise EDirectDrawError.Create(SDisplayModeCannotAcquired);
end;

function TDXDrawDisplay.GetMode2(Index: Integer): TDXDrawDisplayMode;
begin
  if FModes.Count=0 then
    LoadDisplayModes;
  Result := TDXDrawDisplayMode(FModes.Items[Index]);
end;

function TDXDrawDisplay.IndexOf(Width, Height, BitCount: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i:=0 to Count-1 do
    if (Modes[i].Width=Width) and (Modes[i].Height=Height) and (Modes[i].BitCount=BitCount) then
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
    if Item1.Width<>Item2.Width then
      Result := Item1.Width-Item2.Width
    else if Item1.Height<>Item2.Height then
      Result := Item1.Height-Item2.Height
    else
      Result := Item1.BitCount-Item2.BitCount;
  end;

var
  DDraw: TDirectDraw;
  TempList: TList;
  i: Integer;
begin
  FModes.Clear;

  if FDXDraw.DDraw<>nil then
  begin
    FDXDraw.DDraw.DXResult := FDXDraw.DDraw.IDraw.EnumDisplayModes(0, PDDSurfaceDesc(nil)^,
      FModes, @EnumDisplayModesProc);
  end else
  begin
    DDraw := TDirectDraw.Create(PGUID(FDXDraw.FDriver));
    try
      DDraw.IDraw.EnumDisplayModes(0, PDDSurfaceDesc(nil)^, FModes, @EnumDisplayModesProc);
    finally
      DDraw.Free;
    end;
  end;
                
  TempList := TList.Create;
  try
    for i:=0 to FModes.Count-1 do
      TempList.Add(FModes.Items[i]);
    TempList.Sort(@Compare);
                              
    for i:=FModes.Count-1 downto 0 do
      TDXDrawDisplayMode(TempList[i]).Index := i;
  finally
    TempList.Free;
  end;
end;

function TDXDrawDisplay.SetSize(AWidth, AHeight, ABitCount: Integer): Boolean;
begin
  Result := False;
  if FDXDraw.DDraw<>nil then
  begin
    FDXDraw.DDraw.DXResult := FDXDraw.DDraw.IDraw.SetDisplayMode(AWidth, AHeight, ABitCount);
    Result := FDXDraw.DDraw.DXResult=DD_OK;

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
    if (BitCount>8) and (ABitCount>8) then
    begin
      Result := True;
    end else
    begin
      Result := BitCount>=ABitCount;
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
    for i:=0 to Count-1 do
      with Modes[i] do
      begin
        if ((DWidth>=Width) and (DHeight>=Width) and
          ((not Ratio) or (Width/Height=AWidth/AHeight)) and
          ((FFixedSize and (Width=AWidth) and (Height=Height)) or
          ((not FFixedSize) and (Width>=AWidth) and (Height>=AHeight))) and

          ((FFixedBitCount and (BitCount=ABitCount)) or
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
      if (DBitCount<>ABitCount) then
      begin
        if IndexOf(DWidth, DHEight, ABitCount)<>-1 then
          DBitCount := ABitCount;
      end;

      Result := SetSize(DWidth, DHeight, DBitCount);
    end;
  end;

begin
  Result := False;

  if (AWidth<=0) or (AHeight<=0) or (not (ABitCount in [8, 16, 24, 32])) then Exit;

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
  if ZBuffer<>nil then
  begin
    if (Surface.IDDSurface<>nil) and (ZBuffer.IDDSurface<>nil) then
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

    if lpD3DHWDeviceDesc.dcmColorModel=0 then Exit;

    if idoOptimizeDisplayMode in rec.Options then
    begin
      if (lpD3DHWDeviceDesc.dwDeviceRenderBitDepth and (DDBD_16 or DDBD_24 or DDBD_32))=0 then Exit;
    end else
    begin
      if (lpD3DHWDeviceDesc.dwDeviceRenderBitDepth and BPPToDDBD(rec.BitCount))=0 then Exit;
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

      for j:=Low(Bits) to High(Bits) do
      begin
        if i and Bits[j]<>0 then
          Inc(Result);
      end;
    end;

    function CompareCountBitMask(i, i2: DWORD; const Bits: array of DWORD): Integer;
    var
      j, j2: DWORD;
    begin
      j := CountBitMask(i, Bits);
      j2 := CountBitMask(i2, Bits);

      if j<j2 then
        Result := -1
      else if i>j2 then
        Result := 1
      else
        Result := 0;
    end;

    function CountBit(i: DWORD): DWORD;
    var
      j: Integer;
    begin
      Result := 0;

      for j:=0 to 31 do
        if i and (1 shl j)<>0 then
          Inc(Result);
    end;

    function CompareCountBit(i, i2: DWORD): Integer;
    begin
      Result := CountBit(i)-CountBit(i2);
      if Result<0 then Result := -1;
      if Result>0 then Result := 1;
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

        if DDraw.DriverCaps.dwVidMemTotal<rec.DriverCaps.dwVidMemTotal then Exit;

        if CompareCountBitMask(DDraw.DriverCaps.ddscaps.dwCaps, rec.DriverCaps.ddscaps.dwCaps, [DDSCAPS_TEXTURE, DDSCAPS_ZBUFFER, DDSCAPS_MIPMAP])+
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwMiscCaps, rec.HWDeviceDesc2.dpcLineCaps.dwMiscCaps)+
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwRasterCaps, rec.HWDeviceDesc2.dpcLineCaps.dwRasterCaps)+
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwAlphaCmpCaps, rec.HWDeviceDesc2.dpcLineCaps.dwAlphaCmpCaps)+
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwSrcBlendCaps, rec.HWDeviceDesc2.dpcLineCaps.dwSrcBlendCaps)+
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwDestBlendCaps, rec.HWDeviceDesc2.dpcLineCaps.dwDestBlendCaps)+
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwShadeCaps, rec.HWDeviceDesc2.dpcLineCaps.dwShadeCaps)+
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwTextureCaps, rec.HWDeviceDesc2.dpcLineCaps.dwTextureCaps)+
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwTextureFilterCaps, rec.HWDeviceDesc2.dpcLineCaps.dwTextureFilterCaps)+
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwTextureBlendCaps, rec.HWDeviceDesc2.dpcLineCaps.dwTextureBlendCaps)+
          CompareCountBit(rec.HWDeviceDesc.dpcLineCaps.dwTextureAddressCaps, rec.HWDeviceDesc2.dpcLineCaps.dwTextureAddressCaps)<0 then Exit;

        Result := True;
      end;
    end;

  begin
    Result := DDENUMRET_OK;

    DDraw := TDirectDraw.Create(lpGUID);
    try
      if (DDraw.DriverCaps.dwCaps and DDCAPS_3D<>0) and
        (DDraw.DriverCaps.ddsCaps.dwCaps and DDSCAPS_TEXTURE<>0) then
      begin
        if DDraw.IDDraw7<>nil then
          Direct3D7 := DDraw.IDraw7 as IDirect3D7
        else
          Direct3D := DDraw.IDraw as IDirect3D;
        try
          if FindDevice then
          begin
            rec.DriverCaps := DDraw.DriverCaps;
            rec.HELCaps := DDraw.HELCaps;

            if lpGUID=nil then
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
    if (rec.DeviceDesc.dwDeviceRenderBitDepth and BPPToDDBD(rec.BitCount))=0 then
    begin
      if rec.DeviceDesc.dwDeviceRenderBitDepth and DDBD_16<>0 then
        rec.BitCount := 16
      else if rec.DeviceDesc.dwDeviceRenderBitDepth and DDBD_24<>0 then
        rec.BitCount := 24
      else if rec.DeviceDesc.dwDeviceRenderBitDepth and DDBD_32<>0 then
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

    if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_16<>0 then
      ZBufferBitDepth := 16
    else if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_24<>0 then
      ZBufferBitDepth := 24
    else if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_32<>0 then
      ZBufferBitDepth := 32
    else
      ZBufferBitDepth := 0;

    if ZBufferBitDepth<>0 then
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
        if Surface.ISurface.AddAttachedSurface(ZBuffer.ISurface)<>DD_OK then
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

    Hardware := lpD3DHWDeviceDesc.dcmColorModel<>0;
    if Hardware then
      dev := @lpD3DHWDeviceDesc
    else
      dev := @lpD3DHELDeviceDesc;

    if (Hardware) and (not rec.SupportHardware) then Exit;
    if dev.dcmColorModel<>D3DCOLOR_RGB then Exit;
    if CompareMem(@lpGUID, @IID_IDirect3DRefDevice, SizeOf(TGUID)) then Exit;

    {  Bit depth test.  }
    if (dev.dwDeviceRenderBitDepth and BPPToDDBD(rec.BitCount))=0 then Exit;

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
  TDirect3DRMCreate= function(out lplpDirect3DRM: IDirect3DRM): HRESULT; stdcall;
begin
  try
    Options := NowOptions;
    NowOptions := [];

    D3D3 := Surface.DDraw.IDraw as IDirect3D3;
    D3D2 := D3D3 as IDirect3D2;
    D3D := D3D3 as IDirect3D;

    {  Whether hardware can be used is tested.  }
    SupportHardware := (Surface.SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_VIDEOMEMORY<>0) and
      (idoHardware in Options) and (Surface.DDraw.DriverCaps.dwCaps and DDCAPS_3D<>0);

    if Surface.DDraw.DriverCaps.ddsCaps.dwCaps and DDSCAPS_TEXTURE=0 then
      SupportHardware := False;

    {  Direct3D  }
    InitDevice;

    if D3D3.CreateDevice(D3DDeviceGUID, Surface.ISurface4, D3DDevice3, nil)<>D3D_OK then
    begin
      SupportHardware := False;
      InitDevice;
      if D3D3.CreateDevice(D3DDeviceGUID, Surface.ISurface4, D3DDevice3, nil)<>D3D_OK then
        raise EDXDrawError.CreateFmt(SCannotMade, ['IDirect3DDevice3']);
    end;

    if SupportHardware then NowOptions := NowOptions + [idoHardware];

    D3DDevice2 := D3DDevice3 as IDirect3DDevice2;
    D3DDevice := D3DDevice3 as IDirect3DDevice;

    with D3DDevice3 do
    begin
      SetRenderState(TD3DRenderStateType(D3DRENDERSTATE_DITHERENABLE), 1);
      SetRenderState(TD3DRenderStateType(D3DRENDERSTATE_ZENABLE), Ord(ZBuffer<>nil));
      SetRenderState(TD3DRenderStateType(D3DRENDERSTATE_ZWRITEENABLE), Ord(ZBuffer<>nil));
    end;

    {  Direct3D Retained Mode}
    if idoRetainedMode in Options then
    begin
      NowOptions := NowOptions + [idoRetainedMode];

      if D3DRM=nil then
      begin
        if TDirect3DRMCreate(DXLoadLibrary('D3DRM.dll', 'Direct3DRMCreate'))(D3DRM)<>D3DRM_OK then
          raise EDXDrawError.CreateFmt(SCannotInitialized, [SDirect3DRM]);
        D3DRM2 := D3DRM as IDirect3DRM2;
        D3DRM3 := D3DRM as IDirect3DRM3;
      end;

      if D3DRM3.CreateDeviceFromD3D(D3D2, D3DDevice2, D3DRMDevice3)<>D3DRM_OK then
        raise EDXDrawError.CreateFmt(SCannotMade, ['IDirect3DRMDevice2']);

      D3DRMDevice3.SetBufferCount(2);
      D3DRMDevice := D3DRMDevice3 as IDirect3DRMDevice;
      D3DRMDevice2 := D3DRMDevice3 as IDirect3DRMDevice2;

      {  Rendering state setting  }
      D3DRMDevice.SetQuality(D3DRMLIGHT_ON or D3DRMFILL_SOLID or D3DRMSHADE_GOURAUD);
      D3DRMDevice.SetTextureQuality(D3DRMTEXTURE_NEAREST);
      D3DRMDevice.SetDither(True);

      if Surface.BitCount=8 then
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
      if Scene=nil then
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

    if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_16<>0 then
      ZBufferBitDepth := 16
    else if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_24<>0 then
      ZBufferBitDepth := 24
    else if DeviceDesc.dwDeviceZBufferBitDepth and DDBD_32<>0 then
      ZBufferBitDepth := 32
    else
      ZBufferBitDepth := 0;

    if ZBufferBitDepth<>0 then
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
        if Surface.ISurface.AddAttachedSurface(ZBuffer.ISurface)<>DD_OK then
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

    Hardware := lpTD3DDeviceDesc.dwDevCaps and D3DDEVCAPS_HWRASTERIZATION<>0;

    if Hardware and (not rec.SupportHardware) then Exit;
    if CompareMem(@lpTD3DDeviceDesc.deviceGUID, @IID_IDirect3DRefDevice, SizeOf(TGUID)) then Exit;

    {  Bit depth test.  }
    if (lpTD3DDeviceDesc.dwDeviceRenderBitDepth and BPPToDDBD(rec.BitCount))=0 then Exit;

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
    SupportHardware := (Surface.SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_VIDEOMEMORY<>0) and
      (idoHardware in Options) and (Surface.DDraw.DriverCaps.dwCaps and DDCAPS_3D<>0);

    if Surface.DDraw.DriverCaps.ddsCaps.dwCaps and DDSCAPS_TEXTURE=0 then
      SupportHardware := False;

    {  Direct3D  }
    InitDevice;

    if D3D7.CreateDevice(D3DDeviceGUID, Surface.ISurface7, D3DDevice7)<>D3D_OK then
    begin
      SupportHardware := False;
      InitDevice;
      if D3D7.CreateDevice(D3DDeviceGUID, Surface.ISurface7, D3DDevice7)<>D3D_OK then
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
  if FDXDraw.FOptions*[doFullScreen, doSystemMemory, do3D, doHardware]=
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

  if FDXDraw.Options*[doFullScreen, doHardware, doSystemMemory]=[doFullScreen, doHardware] then
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

    FClipper.Free;  FClipper := nil;
    FPalette.Free;  FPalette := nil;
    FSurface.Free;  FSurface := nil;
    FPrimary.Free;  FPrimary := nil;

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
    GetSystemPaletteEntries(dc, 0, 256, Entries);
    ReleaseDC(0, dc);

    for i:=0 to 9 do
      Result[i] := Entries[i];

    for i:=256-10 to 255 do
      Result[i] := Entries[i];
  end;

  for i:=0 to 255 do
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
      Inc(pt.x, (FDXDraw.Width-FDXDraw.FSurface.Width) div 2);
      Inc(pt.y, (FDXDraw.Height-FDXDraw.FSurface.Height) div 2);
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

  if FDXDraw.FSurface.SurfaceDesc.ddscaps.dwCaps and DDSCAPS_VIDEOMEMORY=0 then
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
  if (FDXDraw.FForm<>nil) and (FDXDraw.FForm.Active) then
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
  if FDXDraw.FPrimary.ISurface.GetAttachedSurface(BackBufferCaps, DDSurface)=DD_OK then
    FDXDraw.FSurface.IDDSurface := DDSurface;

  FDXDraw.FNowOptions := FDXDraw.FNowOptions - [doSystemMemory];
  if FDXDraw.FSurface.SurfaceDesc.ddscaps.dwCaps and DDSCAPS_SYSTEMMEMORY<>0 then
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

  Options := [doAllowReboot, doWaitVBlank, doCenter, doDirectX7Mode, doHardware, doSelectDriver];

  FAutoSize := True;

  dc := GetDC(0);
  GetSystemPaletteEntries(dc, 0, 256, Entries);
  ReleaseDC(0, dc);

  ColorTable := PaletteEntriesToRGBQuads(Entries);
  DefColorTable := ColorTable;

  Width := 100;
  Height := 100;
  ParentColor := False;
  Color := clBtnFace;
end;

destructor TCustomDXDraw.Destroy;
begin
  Finalize;
  NotifyEventList(dxntDestroying);
  FDisplay.Free;
  FSubClass.Free; FSubClass := nil;
  FNotifyEventList.Free;
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
    if FOffNotifyRestore=0 then
      NotifyEvent(Self, dxntRestore);
  end;
end;

procedure TCustomDXDraw.UnRegisterNotifyEvent(NotifyEvent: TDXDrawNotifyEvent);
var
  Event: PDXDrawNotifyEvent;
  i: Integer;
begin
  for i:=0 to FNotifyEventList.Count-1 do
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
  for i:=FNotifyEventList.Count-1 downto 0 do
    PDXDrawNotifyEvent(FNotifyEventList[i])^(Self, NotifyType);
end;

procedure TCustomDXDraw.FormWndProc(var Message: TMessage; DefWindowProc: TWndMethod);

  procedure FlipToGDISurface;
  begin
    if Initialized and (FNowOptions*[doFullScreen, doFlip]=[doFullScreen, doFlip]) then
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
          if TWMWindowPosChanged(Message).WindowPos^.flags and SWP_SHOWWINDOW<>0 then
          begin
            DefWindowProc(Message);
            if AutoInitialize and (not FInitialized2) then
              Initialize;
            Exit;
          end;
        end;
    WM_ACTIVATE:
        begin
          if TWMActivate(Message).Active=WA_INACTIVE then
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
end;

procedure TCustomDXDraw.Flip;
begin
  if Initialized and (not FUpdating) then
  begin
    if TryRestore then
      TDXDrawDriver(FDXDrawDriver).Flip;
  end;
end;

function TCustomDXDraw.GetCanDraw: Boolean;
begin
  Result := Initialized and (not FUpdating) and (Surface.IDDSurface<>nil) and
    TryRestore;
end;

function TCustomDXDraw.GetCanPaletteAnimation: Boolean;
begin
  Result := Initialized and (not FUpdating) and (doFullScreen in FNowOptions)
    and (DDraw.DisplayMode.ddpfPixelFormat.dwRGBBitCount<=8);
end;

function TCustomDXDraw.GetSurfaceHeight: Integer;
begin
  if Surface.IDDSurface<>nil then
    Result := Surface.Height
  else
    Result := FSurfaceHeight;
end;

function TCustomDXDraw.GetSurfaceWidth: Integer;
begin
  if Surface.IDDSurface<>nil then
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
    if {(not (doFullScreen in FOptions)) or }(FSubClass=nil) then
      Initialize;
  end;
end;

procedure TCustomDXDraw.Initialize;
begin
  FInitialized2 := True;

  Finalize;

  if FForm=nil then
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
    Canvas.TextOut(Width div 2-w div 2, Height div 2-h div 2, s);
  end else
  begin
    Old := FNowOptions;
    try
      FNowOptions := FNowOptions - [doWaitVBlank];
      Flip;
    finally         
      FNowOptions := Old;
    end;    
    if (Parent<>nil) and (Initialized) and (Surface.SurfaceDesc.ddscaps.dwCaps and DDSCAPS_VIDEOMEMORY<>0) then
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
  if FAutoSize<>Value then
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

procedure TCustomDXDraw.SetColorTable(const ColorTable: TRGBQuads);
var
  Entries: TPaletteEntries;
begin
  if Initialized and (Palette<>nil) then
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
  if Control=nil then
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
    FNowOptions := FNowOptions*InitOptions+(FOptions-InitOptions);

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
    while (Control<>nil) and (not (Control is TCustomForm)) do
      Control := Control.Parent;
    if Control<>nil then
    begin
      FForm := TCustomForm(Control);
      FSubClass := TControlSubClass.Create(Control, FormWndProc);
    end;
  end;
end;

procedure TCustomDXDraw.SetSize(ASurfaceWidth, ASurfaceHeight: Integer);
begin
  if ((ASurfaceWidth<>SurfaceWidth) or (ASurfaceHeight<>SurfaceHeight)) and
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
  if ComponentState*[csReading, csLoading]=[] then
    SetSize(SurfaceWidth, Value)
  else
    FSurfaceHeight := Value;
end;

procedure TCustomDXDraw.SetSurfaceWidth(Value: Integer);
begin
  if ComponentState*[csReading, csLoading]=[] then
    SetSize(Value, SurfaceHeight)
  else
    FSurfaceWidth := Value;
end;

function TCustomDXDraw.TryRestore: Boolean;
begin
  Result := False;

  if Initialized and (not FUpdating) and (Primary.IDDSurface<>nil) then
  begin
    if (Primary.ISurface.IsLost=DDERR_SURFACELOST) or
      (Surface.ISurface.IsLost=DDERR_SURFACELOST) then
    begin
      Restore;
      Result := (Primary.ISurface.IsLost=DD_OK) and (Surface.ISurface.IsLost=DD_OK);
    end else
      Result := True;
  end;
end;

procedure TCustomDXDraw.UpdatePalette;
begin
  if Initialized and (doWaitVBlank in FNowOptions) then
  begin
    if FDDraw.FDriverCaps.dwPalCaps and DDPCAPS_VSYNC=0 then
      FDDraw.IDraw.WaitForVerticalBlank(DDWAITVB_BLOCKBEGIN, 0);
  end; 

  SetColorTable(ColorTable);
end;

procedure TCustomDXDraw.WMCreate(var Message: TMessage);
begin
  inherited;
  if Initialized and (not FUpdating) then
  begin
    if Clipper<>nil then
      Clipper.Handle := Handle;
    SetCooperativeLevel;
  end;
end;

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

      FSurface.Free;   FSurface := nil;

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
  Result := Initialized and (Surface.IDDSurface<>nil) and
    (Surface.ISurface.IsLost=DD_OK);
end;

function TCustomDX3D.GetSurfaceHeight: Integer;
begin
  if FSurface.IDDSurface<>nil then
    Result := FSurface.Height
  else
    Result := FSurfaceHeight;
end;

function TCustomDX3D.GetSurfaceWidth: Integer;
begin
  if FSurface.IDDSurface<>nil then
    Result := FSurface.Width
  else
    Result := FSurfaceWidth;
end;

procedure TCustomDX3D.SetAutoSize(Value: Boolean);
begin
  if FAutoSize<>Value then
  begin
    FAutoSize := Value;
    if FAutoSize and (DXDraw<>nil) then
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
    FNowOptions := FNowOptions*InitOptions+FOptions*(DX3DOptions - InitOptions);
  end else
  begin
    FNowOptions := FOptions;

    if (FDXDraw<>nil) and (doDirectX7Mode in FDXDraw.FNowOptions) then
      FNowOptions := FNowOptions - [toRetainedMode];
  end;
end;

procedure TCustomDX3D.SetSize(ASurfaceWidth, ASurfaceHeight: Integer);
begin
  if (ASurfaceWidth<>SurfaceWidth) or (ASurfaceHeight<>SurfaceHeight) then
  begin
    FSurfaceWidth := ASurfaceWidth;
    FSurfaceHeight := ASurfaceHeight;

    if Initialized then
      Initialize;
  end;
end;

procedure TCustomDX3D.SetSurfaceHeight(Value: Integer);
begin
  if ComponentState*[csReading, csLoading]=[] then
    SetSize(SurfaceWidth, Value)
  else
    FSurfaceHeight := Value;
end;

procedure TCustomDX3D.SetSurfaceWidth(Value: Integer);
begin
  if ComponentState*[csReading, csLoading]=[] then
    SetSize(Value, SurfaceHeight)
  else
    FSurfaceWidth := Value;
end;

procedure TCustomDX3D.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation=opRemove) and (FDXDraw=AComponent) then
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
          if (FDXDraw.FOptions*[do3D, doFullScreen]=[doFullScreen])
            and (FOptions*[toSystemMemory, toSelectDriver]=[toSelectDriver]) then
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
          if FZBuffer<>nil then
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
  if FDXDraw<>Value then
  begin
    if FDXDraw<>nil then
      FDXDraw.UnRegisterNotifyEvent(DXDrawNotifyEvent);

    FDXDraw := Value;

    if FDXDraw<>nil then
      FDXDraw.RegisterNotifyEvent(DXDrawNotifyEvent);
  end;
end;

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
    1..2   : FBitCount := 1;
    3..16  : FBitCount := 4;
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
  end else if FDXDraw is TCustomDX3D then
  begin
    with (FDXDraw as TDX3D) do
    begin
      if not Initialized then
        raise EDirect3DTextureError.CreateFmt(SNotMade, [FDXDraw.ClassName]);
    end;

    FSurface := TDirectDrawSurface.Create((FDXDraw as TCustomDX3D).Surface.DDraw);
    (FDXDraw as TCustomDX3D).FDXDraw.RegisterNotifyEvent(DXDrawNotifyEvent);
  end else
    raise EDirect3DTextureError.CreateFmt(SNotSupported, [FDXDraw.ClassName]);
end;

destructor TDirect3DTexture.Destroy;
begin
  if FDXDraw is TCustomDXDraw then
  begin
    (FDXDraw as TCustomDXDraw).UnRegisterNotifyEvent(DXDrawNotifyEvent);
  end else if FDXDraw is TCustomDX3D then
  begin
    (FDXDraw as TCustomDX3D).FDXDraw.UnRegisterNotifyEvent(DXDrawNotifyEvent);
  end;

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
  if FTexture=nil then
    Restore;
  Result := FHandle;
end;

function TDirect3DTexture.GetSurface: TDirectDrawSurface;
begin
  if FTexture=nil then
    Restore;
  Result := FSurface;
end;

function TDirect3DTexture.GetTexture: IDirect3DTexture;
begin
  if FTexture=nil then
    Restore;
  Result := FTexture;
end;

procedure TDirect3DTexture.SetTransparentColor(Value: TColor);
begin
  if FTransparentColor<>Value then
  begin
    FTransparentColor := Value;

    if FSurface<>nil then
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

    if ddsd.ddpfPixelFormat.dwFlags and (DDPF_ALPHA or DDPF_ALPHAPIXELS)<>0 then
      Exit;

    if not tex.FEnumFormatFlag then
    begin
      {  When called first,  this format is unconditionally selected.  }
      UseThisFormat;
    end else
    begin
      if (tex.FBitCount<=8) and (ddsd.ddpfPixelFormat.dwRGBBitCount>=tex.FBitCount) and
        (ddsd.ddpfPixelFormat.dwRGBBitCount>=8) and
        (ddsd.ddpfPixelFormat.dwFlags and DDPF_RGB<>0) then
      begin
        if tex.FFormat.ddpfPixelFormat.dwRGBBitCount>ddsd.ddpfPixelFormat.dwRGBBitCount then
          UseThisFormat;
      end else
      begin
        if (tex.FFormat.ddpfPixelFormat.dwRGBBitCount>ddsd.ddpfPixelFormat.dwRGBBitCount) and
          (ddsd.ddpfPixelFormat.dwRGBBitCount>8) and
          (ddsd.ddpfPixelFormat.dwFlags and DDPF_RGB<>0) then
          UseThisFormat;
      end;
    end;
  end;

  function GetBitCount(i: Integer): Integer;
  var
    j: Integer;
  begin
    for j:=32 downto 1 do
      if (1 shl j) and i<>0 then
      begin
        Result := j;
        if 1 shl j<>i then
          Dec(Result);
        Exit;
      end;
    Result := 0;
  end;

  function CreateHalftonePalette(R, G, B: Integer): TPaletteEntries;
  var
    i: Integer;
  begin
    for i:=0 to 255 do
      with Result[i] do
      begin
        peRed   := ((i shr (G+B-1)) and (1 shl R-1)) * 255 div (1 shl R-1);
        peGreen := ((i shr (B-1)) and (1 shl G-1)) * 255 div (1 shl G-1);
        peBlue  := ((i shr 0) and (1 shl B-1)) * 255 div (1 shl B-1);
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
    end else if FDXDraw is TCustomDX3D then
    begin
      DDraw := (FDXDraw as TCustomDX3D).Surface.DDraw;
      D3DDevice := (FDXDraw as TCustomDX3D).D3DDevice;
      Hardware := toHardware in (FDXDraw as TCustomDX3D).NowOptions;
    end;

    if (DDraw=nil) or (D3DDevice=nil) then Exit;

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
      if ddsd.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED8<>0 then
      begin
        PaletteCaps := DDPCAPS_8BIT or DDPCAPS_ALLOW256;
        if FBitCount=24 then
          CreateHalftonePalette(3, 3, 2);
      end else if ddsd.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED4<>0 then
      begin
        PaletteCaps := DDPCAPS_4BIT;
        if FBitCount=24 then
          CreateHalftonePalette(1, 2, 1);
      end else if ddsd.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED1<>0 then
      begin
        PaletteCaps := DDPCAPS_1BIT;
        if FBitCount=24 then
        begin
          FPaletteEntries[0] := RGBQuadToPaletteEntry(RGBQuad(0, 0, 0));
          FPaletteEntries[1] := RGBQuadToPaletteEntry(RGBQuad(255, 255, 255));
        end;
      end else
        PaletteCaps := 0;

      if PaletteCaps<>0 then
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

    if FTexture.GetHandle(D3DDevice, FHandle)<>D3D_OK then
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

  FMipmap := FImage.SubGroupImageCount[DXTextureImageGroupType_Mipmap]>0;

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
    if Image=nil then
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
    if Image=nil then
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
  if FDXDraw<>ADXDraw then
  begin
    if FDXDraw<>nil then
      FDXDraw.UnRegisterNotifyEvent(DXDrawNotifyEvent);

    FDXDraw := ADXDraw;

    if FDXDraw<>nil then
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
  if FImage2=nil then
    FImage2 := TDXTextureImage.Create;
  
  if DIB.BitCount<=8 then
  begin
    FImage2.SetImage(DXTextureImageType_PaletteIndexedColor, DIB.Width, DIB.Height, DIB.BitCount,
      DIB.WidthBytes, DIB.NextLine, DIB.PBits, DIB.TopPBits, DIB.Size, False);

    FImage2.idx_index := dxtMakeChannel((1 shl DIB.BitCount)-1, True);
    for i:=0 to 255 do
      FImage2.idx_palette[i] := RGBQuadToPaletteEntry(DIB.ColorTable[i]);
  end else
  begin
    FImage2.SetImage(DXTextureImageType_RGBColor, DIB.Width, DIB.Height, DIB.BitCount,
      DIB.WidthBytes, DIB.NextLine, DIB.PBits, DIB.TopPBits, DIB.Size, False);

    FImage2.rgb_red := dxtMakeChannel(DIB.NowPixelFormat.RBitMask, False);
    FImage2.rgb_green := dxtMakeChannel(DIB.NowPixelFormat.GBitMask, False);
    FImage2.rgb_blue := dxtMakeChannel(DIB.NowPixelFormat.BBitMask, False);

    i := DIB.NowPixelFormat.RBitCount+DIB.NowPixelFormat.GBitCount+DIB.NowPixelFormat.BBitCount;
    if i<DIB.BitCount then
      FImage2.rgb_alpha := dxtMakeChannel(((1 shl (DIB.BitCount-i))-1) shl i, False);
  end;

  FImage := FImage2;
end;

function TDirect3DTexture2.GetIsMipmap: Boolean;
begin
  if FSurface<>nil then
    Result := FUseMipmap
  else
    Result := FMipmap;
end;

function TDirect3DTexture2.GetSurface: TDirectDrawSurface;
begin
  Result := FSurface;
  if (Result<>nil) and FNeedLoadTexture then
    Load;
end;

function TDirect3DTexture2.GetTransparent: Boolean;
begin
  if FSurface<>nil then
    Result := FUseColorKey
  else
    Result := FTransparent;
end;

procedure TDirect3DTexture2.SetTransparent(Value: Boolean);
begin
  if FTransparent<>Value then
  begin
    FTransparent := Value;
    if FSurface<>nil then
      SetColorKey;
  end;
end;

procedure TDirect3DTexture2.SetTransparentColor(Value: TColorRef);
begin
  if FTransparentColor<>Value then
  begin
    FTransparentColor := Value;
    if (FSurface<>nil) and FTransparent then
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
    while (i>=0) and (((1 shl Result) and i)=0) do Dec(Result);
  end;

  function GetMaskBitCount(b: Integer): Integer;
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

  function GetPaletteBitCount(const ddpfPixelFormat: TDDPixelFormat): Integer;
  begin
    if ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED8<>0 then
      Result := 8
    else if ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED4<>0 then
      Result := 4
    else if ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED2<>0 then
      Result := 2
    else if ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED1<>0 then
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
    if lpDDPixFmt.dwFlags and DDPF_RGB=0 then Exit;

    case tex.FImage.ImageType of
      DXTextureImageType_RGBColor:
        begin
          if lpDDPixFmt.dwFlags and DDPF_PALETTEINDEXED<>0 then Exit;
        end;
      DXTextureImageType_PaletteIndexedColor:
        begin
          if (lpDDPixFmt.dwFlags and DDPF_PALETTEINDEXED<>0) and
            (GetPaletteBitCount(lpDDPixFmt)<idx_index) then Exit;
        end;
    end;

    {  The pixel format which can be used is selected carefully.  }
    if tex.FEnumTextureFormatFlag then
    begin
      if lpDDPixFmt.dwFlags and DDPF_PALETTEINDEXED<>0 then
      begin
        {  Bit count check  }
        if Abs(Integer(lpDDPixFmt.dwRGBBitCount)-idx_index)>
          Abs(Integer(tex.FTextureFormat.ddpfPixelFormat.dwRGBBitCount)-idx_index) then Exit;

        {  Alpha channel check  }
        if rgb_alpha>0 then Exit;
      end else
      if lpDDPixFmt.dwFlags and DDPF_RGB<>0 then
      begin
        {  The alpha channel is indispensable.  }
        if (rgb_alpha>0) and (tex.FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_ALPHAPIXELS=0) and
          (lpDDPixFmt.dwFlags and DDPF_ALPHAPIXELS<>0) then
        begin
          UseThisFormat;
          Exit;
        end;

        {  Alpha channel check  }
        if (rgb_alpha>0) and (tex.FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_ALPHAPIXELS<>0) and
          (lpDDPixFmt.dwFlags and DDPF_ALPHAPIXELS=0) then
        begin
          Exit;
        end;

        {  Bit count check  }
        if tex.FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED=0 then
        begin
          sum1 := Sqr(GetMaskBitCount(lpDDPixFmt.dwRBitMask)-rgb_red)+
            Sqr(GetMaskBitCount(lpDDPixFmt.dwGBitMask)-rgb_green)+
            Sqr(GetMaskBitCount(lpDDPixFmt.dwBBitMask)-rgb_blue)+
            Sqr(GetMaskBitCount(lpDDPixFmt.dwRGBAlphaBitMask)-rgb_alpha);

          sum2 := Sqr(GetMaskBitCount(tex.FTextureFormat.ddpfPixelFormat.dwRBitMask)-rgb_red)+
            Sqr(GetMaskBitCount(tex.FTextureFormat.ddpfPixelFormat.dwGBitMask)-rgb_green)+
            Sqr(GetMaskBitCount(tex.FTextureFormat.ddpfPixelFormat.dwBBitMask)-rgb_blue)+
            Sqr(GetMaskBitCount(tex.FTextureFormat.ddpfPixelFormat.dwRGBAlphaBitMask)-rgb_alpha);

          if sum1>sum2 then Exit;
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
    if FDXDraw.D3DDevice7<>nil then
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

    if FImage<>nil then
    begin
      {  Size adjustment of texture  }
      if FD3DDevDesc.dpcTriCaps.dwTextureCaps and D3DPTEXTURECAPS_POW2<>0 then
      begin
        {  The size of the texture is only Sqr(n).  }
        Width := Max(1 shl GetBitCount(FImage.Width), 1);
        Height := Max(1 shl GetBitCount(FImage.Height), 1);
      end else
      begin
        Width := FImage.Width;
        Height := FImage.Height;
      end;

      if FD3DDevDesc.dpcTriCaps.dwTextureCaps and D3DPTEXTURECAPS_SQUAREONLY<>0 then
      begin
        {  The size of the texture is only a square.  }
        if Width<Height then Width := Height;
        Height := Width;
      end;

      if FD3DDevDesc.dwMinTextureWidth>0 then
        Width := Max(Width, FD3DDevDesc.dwMinTextureWidth);

      if FD3DDevDesc.dwMaxTextureWidth>0 then
        Width := Min(Width, FD3DDevDesc.dwMaxTextureWidth);

      if FD3DDevDesc.dwMinTextureHeight>0 then
        Height := Max(Height, FD3DDevDesc.dwMinTextureHeight);

      if FD3DDevDesc.dwMaxTextureHeight>0 then
        Height := Min(Height, FD3DDevDesc.dwMaxTextureHeight);

      {  Pixel format selection  }
      FEnumTextureFormatFlag := False;
      if FDXDraw.D3DDevice7<>nil then
        FDXDraw.D3DDevice7.EnumTextureFormats(@EnumTextureFormatCallback, Self)
      else
        FDXDraw.D3DDevice3.EnumTextureFormats(@EnumTextureFormatCallback, Self);

      if not FEnumTextureFormatFlag then
        raise EDirect3DTextureError.CreateFmt(SCannotInitialized, [STexture]);

      {  Is Mipmap surface used ?  }
      FUseMipmap := FMipmap and (FTextureFormat.ddpfPixelFormat.dwRGBBitCount>8) and
        (FImage.SubGroupImageCount[DXTextureImageGroupType_Mipmap]>0) and (FDXDraw.DDraw.DriverCaps.ddsCaps.dwCaps and DDSCAPS_MIPMAP<>0);

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
    if FSurface.DDraw.DXResult<>DD_OK then
      raise EDirect3DTextureError.CreateFmt(SCannotInitialized, [STexture]);
    FSurface.IDDSurface4 := TempSurface;

    {  Palette making  }
    if (FImage<>nil) and (FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED<>0) then
    begin
      if FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED8<>0 then
        PaletteCaps := DDPCAPS_8BIT or DDPCAPS_ALLOW256
      else if FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED4<>0 then
        PaletteCaps := DDPCAPS_4BIT
      else if FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED2<>0 then
        PaletteCaps := DDPCAPS_2BIT
      else if FTextureFormat.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED1<>0 then
        PaletteCaps := DDPCAPS_1BIT
      else
        PaletteCaps := 0;

      if PaletteCaps<>0 then
      begin
        if FDXDraw.DDraw.IDraw.CreatePalette(PaletteCaps, @FImage.idx_palette, Palette, nil)<>0 then
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
  if FSurface=nil then
    Initialize;

  FNeedLoadTexture := False;
  if FSurface.ISurface.IsLost=DDERR_SURFACELOST then
    FSurface.Restore;

  {  Color key setting.  }
  SetColorKey;

  {  Image loading into surface.  }
  if FImage<>nil then
  begin
    if FSrcImage is TDIB then
      SetDIB(TDIB(FSrcImage));

    CurSurface := FSurface.ISurface4;
    Index := 0;
    while CurSurface<>nil do
    begin
      SrcImage := FImage;
      if Index>0 then
      begin
        if Index-1>=FImage.SubGroupImageCount[DXTextureImageGroupType_Mipmap] then
          Break;
        SrcImage := FImage.SubGroupImages[DXTextureImageGroupType_Mipmap, Index-1];
      end;

      LoadSubTexture(CurSurface, SrcImage);

      if CurSurface.GetAttachedSurface(MipmapCaps, NextSurface)=0 then
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

  if (FSurface<>nil) and FTransparent and (FD3DDevDesc.dpcTriCaps.dwTextureCaps and D3DPTEXTURECAPS_TRANSPARENCY<>0) then
  begin
    FillChar(ck, SizeOf(ck), 0);
    if FSurface.SurfaceDesc.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED<>0 then
    begin
      if FTransparentColor shr 24=$01 then
      begin
        {  Palette index  }
        ck.dwColorSpaceLowValue := FTransparentColor and $FF;
      end else
      if FImage<>nil then
      begin
        {  RGB value  }
        ck.dwColorSpaceLowValue := FImage.PaletteIndex(GetRValue(FTransparentColor), GetGValue(FTransparentColor), GetBValue(FTransparentColor));
      end else
        Exit;
    end else
    begin
      if (FImage<>nil) and (FImage.ImageType=DXTextureImageType_PaletteIndexedColor) and (FTransparentColor shr 24=$01) then
      begin
        {  Palette index  }
        ck.dwColorSpaceLowValue :=
          dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwRBitMask, False), FImage.idx_palette[FTransparentColor and $FF].peRed) or
          dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwGBitMask, False), FImage.idx_palette[FTransparentColor and $FF].peGreen) or
          dxtEncodeChannel(dxtMakeChannel(FSurface.SurfaceDesc.ddpfPixelFormat.dwBBitMask, False), FImage.idx_palette[FTransparentColor and $FF].peBlue);
      end else
      if FTransparentColor shr 24=$00 then
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
    FSurface.ISurface.SetColorKey(DDCKEY_SRCBLT, ck);

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
      1 : PByte(Integer(ddsd.lpSurface)+ddsd.lPitch*y+x div 8)^ :=
            (PByte(Integer(ddsd.lpSurface)+ddsd.lPitch*y+x div 8)^ and (not Mask1[x mod 8])) or (c shl Shift1[x mod 8]);
      2 : PByte(Integer(ddsd.lpSurface)+ddsd.lPitch*y+x div 4)^ :=
            (PByte(Integer(ddsd.lpSurface)+ddsd.lPitch*y+x div 4)^ and (not Mask2[x mod 4])) or (c shl Shift2[x mod 4]);
      4 : PByte(Integer(ddsd.lpSurface)+ddsd.lPitch*y+x div 2)^ :=
            (PByte(Integer(ddsd.lpSurface)+ddsd.lPitch*y+x div 2)^ and (not Mask4[x mod 2])) or (c shl Shift4[x mod 2]);
      8 : PByte(Integer(ddsd.lpSurface)+ddsd.lPitch*y+x)^ := c;
      16: PWord(Integer(ddsd.lpSurface)+ddsd.lPitch*y+x*2)^ := c;
      24: begin
            PByte(Integer(ddsd.lpSurface)+ddsd.lPitch*y+x*3)^ := c shr 0;
            PByte(Integer(ddsd.lpSurface)+ddsd.lPitch*y+x*3+1)^ := c shr 8;
            PByte(Integer(ddsd.lpSurface)+ddsd.lPitch*y+x*3+2)^ := c shr 16;
          end;   
      32: PDWORD(Integer(ddsd.lpSurface)+ddsd.lPitch*y+x*4)^ := c;
    end;
  end;

  procedure LoadTexture_IndexToIndex;
  var
    ddsd: TDDSurfaceDesc2;
    x, y: Integer;
  begin
    ddsd.dwSize := SizeOf(ddsd);
    if Dest.Lock(nil, ddsd, DDLOCK_WAIT, 0)=0 then
    begin
      try
        if (SrcImage.idx_index.Mask=DWORD(1 shl ddsd.ddpfPixelFormat.dwRGBBitCount)-1) and (SrcImage.idx_alpha.Mask=0) and
          (SrcImage.BitCount=Integer(ddsd.ddpfPixelFormat.dwRGBBitCount)) and (not SrcImage.PackedPixelOrder) then
        begin
          for y:=0 to ddsd.dwHeight-1 do
            Move(SrcImage.ScanLine[y]^, Pointer(Integer(ddsd.lpSurface)+ddsd.lPitch*y)^, (Integer(ddsd.dwWidth)*SrcImage.BitCount+7) div 8);
        end else
        begin
          for y:=0 to ddsd.dwHeight-1 do
          begin
            for x:=0 to ddsd.dwWidth-1 do
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
    if Dest.Lock(nil, ddsd, DDLOCK_WAIT, 0)=0 then
    begin
      try
        dest_red_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwRBitMask, False);
        dest_green_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwGBitMask, False);
        dest_blue_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwBBitMask, False);
        dest_alpha_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwRGBAlphaBitMask, False);

        if SrcImage.idx_alpha.mask<>0 then
        begin
          for y:=0 to ddsd.dwHeight-1 do
            for x:=0 to ddsd.dwWidth-1 do
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

          for y:=0 to ddsd.dwHeight-1 do
            for x:=0 to ddsd.dwWidth-1 do
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
    if Dest.Lock(nil, ddsd, DDLOCK_WAIT, 0)=0 then
    begin
      try
        dest_red_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwRBitMask, False);
        dest_green_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwGBitMask, False);
        dest_blue_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwBBitMask, False);
        dest_alpha_fmt := dxtMakeChannel(ddsd.ddpfPixelFormat.dwRGBAlphaBitMask, False);

        if (dest_red_fmt.Mask=SrcImage.rgb_red.Mask) and (dest_green_fmt.Mask=SrcImage.rgb_green.Mask) and
          (dest_blue_fmt.Mask=SrcImage.rgb_blue.Mask) and (dest_alpha_fmt.Mask=SrcImage.rgb_alpha.Mask) and
          (Integer(ddsd.ddpfPixelFormat.dwRGBBitCount)=SrcImage.BitCount) and (not SrcImage.PackedPixelOrder) then
        begin                
          for y:=0 to ddsd.dwHeight-1 do
            Move(SrcImage.ScanLine[y]^, Pointer(Integer(ddsd.lpSurface)+ddsd.lPitch*y)^, (Integer(ddsd.dwWidth)*SrcImage.BitCount+7) div 8);
        end else
        if SrcImage.rgb_alpha.mask<>0 then
        begin
          for y:=0 to ddsd.dwHeight-1 do
            for x:=0 to ddsd.dwWidth-1 do
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

          for y:=0 to ddsd.dwHeight-1 do
            for x:=0 to ddsd.dwWidth-1 do
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

  if SurfaceDesc.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED<>0 then
  begin
    case SrcImage.ImageType of
      DXTextureImageType_PaletteIndexedColor: LoadTexture_IndexToIndex;
      DXTextureImageType_RGBColor           : ;
    end;
  end else if SurfaceDesc.ddpfPixelFormat.dwFlags and DDPF_RGB<>0 then
  begin
    case SrcImage.ImageType of
      DXTextureImageType_PaletteIndexedColor: LoadTexture_IndexToRGB;
      DXTextureImageType_RGBColor           : LoadTexture_RGBToRGB;
    end;
  end;
end;

{  TDirect3DRMUserVisual  }

procedure TDirect3DRMUserVisual_D3DRMOBJECTCALLBACK(lpD3DRMobj: IDirect3DRMObject;
  lpArg: Pointer); CDECL;
begin
  TDirect3DRMUserVisual(lpArg).Free;
end;

function TDirect3DRMUserVisual_D3DRMUSERVISUALCALLBACK(lpD3DRMUV: IDirect3DRMUserVisual;
  lpArg: Pointer; lpD3DRMUVreason: TD3DRMUserVisualReason;
  lpD3DRMDev: IDirect3DRMDevice; lpD3DRMview: IDirect3DRMViewport): Integer; CDECL;
begin
  Result := TDirect3DRMUserVisual(lpArg).DoRender(lpD3DRMUVreason, lpD3DRMDev, lpD3DRMview);
end;

constructor TDirect3DRMUserVisual.Create(D3DRM: IDirect3DRM);
begin
  inherited Create;

  if D3DRM.CreateUserVisual(@TDirect3DRMUserVisual_D3DRMUSERVISUALCALLBACK,
    Self, FUserVisual)<>D3DRM_OK then
    raise EDirect3DRMUserVisualError.CreateFmt(SCannotMade, ['IDirect3DRMUserVisual']);

  FUserVisual.AddDestroyCallback(@TDirect3DRMUserVisual_D3DRMOBJECTCALLBACK, Self);
end;

destructor TDirect3DRMUserVisual.Destroy;
begin
  if FUserVisual<>nil then
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
  SurfaceDivWidth = 512;
  SurfaceDivHeight = 512;

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
  for i:=0 to FSurfaceList.Count-1 do
    TDirectDrawSurface(FSurfaceList[i]).Free;
  FSurfaceList.Clear;
end;

function TPictureCollectionItem.GetHeight: Integer;
begin
  Result := FPatternHeight;
  if (Result<=0) then
    Result := FPicture.Height;
end;

function TPictureCollectionItem.GetPictureCollection: TPictureCollection;
begin
  Result := Collection as TPictureCollection;
end;

function TPictureCollectionItem.GetPatternRect(Index: Integer): TRect;
begin
  if (Index>=0) and (index<FPatterns.Count) then
    Result := TPictureCollectionItemPattern(FPatterns.Items[Index]).FRect
  else
    Result := Rect(0, 0, 0, 0);
end;

function TPictureCollectionItem.GetPatternSurface(Index: Integer): TDirectDrawSurface;
begin
  if (Index>=0) and (index<FPatterns.Count) then
    Result := TPictureCollectionItemPattern(FPatterns.Items[Index]).FSurface
  else
    Result := nil;
end;

function TPictureCollectionItem.GetPatternCount: Integer;
var
  XCount, YCount: Integer;
begin
  if FSurfaceList.Count=0 then
  begin
    XCount := FPicture.Width div (PatternWidth+SkipWidth);
    if FPicture.Width-XCount*(PatternWidth+SkipWidth)=PatternWidth then
     Inc(XCount);

    YCount := FPicture.Height div (PatternHeight+SkipHeight);
    if FPicture.Height-YCount*(PatternHeight+SkipHeight)=PatternHeight then
     Inc(YCount);

    Result := XCount*YCount;
  end else
    Result := FPatterns.Count;
end;

function TPictureCollectionItem.GetWidth: Integer;
begin
  Result := FPatternWidth;
  if (Result<=0) then
    Result := FPicture.Width;
end;
                                       
procedure TPictureCollectionItem.Draw(Dest: TDirectDrawSurface; X, Y,
  PatternIndex: Integer);            
begin
  if FInitialized and (PatternIndex>=0) and (PatternIndex<FPatterns.Count) then
  begin
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
      Dest.Draw(X, Y, FRect, FSurface, Transparent);
  end;
end;

procedure TPictureCollectionItem.StretchDraw(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer);
begin
  if FInitialized and (PatternIndex>=0) and (PatternIndex<FPatterns.Count) then
  begin
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
      Dest.StretchDraw(DestRect, FRect, FSurface, Transparent);
  end;
end;

procedure TPictureCollectionItem.DrawAdd(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
  Alpha: Integer);
begin
  if FInitialized and (PatternIndex>=0) and (PatternIndex<FPatterns.Count) then
  begin
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
      Dest.DrawAdd(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawAlpha(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
  Alpha: Integer);
begin
  if FInitialized and (PatternIndex>=0) and (PatternIndex<FPatterns.Count) then
  begin
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
      Dest.DrawAlpha(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawSub(Dest: TDirectDrawSurface; const DestRect: TRect; PatternIndex: Integer;
  Alpha: Integer);
begin
  if FInitialized and (PatternIndex>=0) and (PatternIndex<FPatterns.Count) then
  begin
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
      Dest.DrawSub(DestRect, FRect, FSurface, Transparent, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotate(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  CenterX, CenterY: Double; Angle: Integer);
begin
  if FInitialized and (PatternIndex>=0) and (PatternIndex<FPatterns.Count) then
  begin
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
      Dest.DrawRotate(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle);
  end;
end;

procedure TPictureCollectionItem.DrawRotateAdd(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  CenterX, CenterY: Double; Angle, Alpha: Integer);
begin
  if FInitialized and (PatternIndex>=0) and (PatternIndex<FPatterns.Count) then
  begin
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
      Dest.DrawRotateAdd(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotateAlpha(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  CenterX, CenterY: Double; Angle, Alpha: Integer);
begin
  if FInitialized and (PatternIndex>=0) and (PatternIndex<FPatterns.Count) then
  begin
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
      Dest.DrawRotateAlpha(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawRotateSub(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  CenterX, CenterY: Double; Angle, Alpha: Integer);
begin
  if FInitialized and (PatternIndex>=0) and (PatternIndex<FPatterns.Count) then
  begin
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
      Dest.DrawRotateSub(X, Y, Width, Height, FRect, FSurface, CenterX, CenterY, Transparent, Angle, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawWaveX(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  amp, Len, ph: Integer);
begin
  if FInitialized and (PatternIndex>=0) and (PatternIndex<FPatterns.Count) then
  begin
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
      Dest.DrawWaveX(X, Y, Width, Height, FRect, FSurface, Transparent, amp, Len, ph);
  end;
end;

procedure TPictureCollectionItem.DrawWaveXAdd(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex>=0) and (PatternIndex<FPatterns.Count) then
  begin
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
      Dest.DrawWaveXAdd(X, Y, Width, Height, FRect, FSurface, Transparent, amp, Len, ph, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawWaveXAlpha(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex>=0) and (PatternIndex<FPatterns.Count) then
  begin
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
      Dest.DrawWaveXAlpha(X, Y, Width, Height, FRect, FSurface, Transparent, amp, Len, ph, Alpha);
  end;
end;

procedure TPictureCollectionItem.DrawWaveXSub(Dest: TDirectDrawSurface; X, Y, Width, Height, PatternIndex: Integer;
  amp, Len, ph, Alpha: Integer);
begin
  if FInitialized and (PatternIndex>=0) and (PatternIndex<FPatterns.Count) then
  begin
    with TPictureCollectionItemPattern(FPatterns.Items[PatternIndex]) do
      Dest.DrawWaveXSub(X, Y, Width, Height, FRect, FSurface, Transparent, amp, Len, ph, Alpha);
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
  if FPicture.Graphic=nil then Exit;

  if not FInitialized then
  begin
    if PictureCollection.Initialized then
      Initialize;
    if not FInitialized then Exit;
  end;

  ClearSurface;

  Width2 := Width+SkipWidth;
  Height2 := Height+SkipHeight;

  if (Width=FPicture.Width) and (Height=FPicture.Height) then
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

    for y:=0 to (FPicture.Height+SkipHeight) div Height2-1 do
      for x:=0 to (FPicture.Width+SkipWidth) div Width2-1 do
        with TPictureCollectionItemPattern.Create(FPatterns) do
        begin
          FRect := Bounds(x * Width2, y * Height2, Width, Height);
          FSurface := TDirectDrawSurface(FSurfaceList[0]);
        end;
  end else
  begin
    {  Load to a video memory with dividing the image.   }
    BlockWidth := Min(((SurfaceDivWidth+Width2-1) div Width2)*Width2,
      (FPicture.Width+SkipWidth) div Width2*Width2);
    BlockHeight := Min(((SurfaceDivHeight+Height2-1) div Height2)*Height2,
      (FPicture.Height+SkipHeight) div Height2*Height2);

    if (BlockWidth=0) or (BlockHeight=0) then Exit;

    BlockXCount := (FPicture.Width+BlockWidth-1) div BlockWidth;
    BlockYCount := (FPicture.Height+BlockHeight-1) div BlockHeight;

    for y:=0 to BlockYCount-1 do
      for x:=0 to BlockXCount-1 do
      begin
        x2 := Min(BlockWidth, Max(FPicture.Width-x*BlockWidth, 0));
        if x2=0 then x2 := BlockWidth;
        
        y2 := Min(BlockHeight, Max(FPicture.Height-y*BlockHeight, 0));
        if y2=0 then y2 := BlockHeight;
             
        AddSurface(Bounds(x*BlockWidth, y*BlockHeight, x2, y2));
      end;

    for y:=0 to (FPicture.Height+SkipHeight) div Height2-1 do
      for x:=0 to (FPicture.Width+SkipWidth) div Width2-1 do
      begin
        x2 := x * Width2;
        y2 := y * Height2;
        with TPictureCollectionItemPattern.Create(FPatterns) do
        begin
          FRect := Bounds(x2-(x2 div BlockWidth*BlockWidth), y2-(y2 div BlockHeight*BlockHeight), Width, Height);
          FSurface := TDirectDrawSurface(FSurfaceList[(x2 div BlockWidth)+((y2 div BlockHeight)*BlockXCount)]);
        end;
      end;
  end;
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
  if Value<>FTransparentColor then
  begin
    FTransparentColor := Value;
    for i:=0 to FSurfaceList.Count-1 do
    begin
      try
        Surface := TDirectDrawSurface(FSurfaceList[i]);
        Surface.TransparentColor := Surface.ColorMatch(FTransparentColor);
      except
      end;
    end;
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
  if i=-1 then
    raise EPictureCollectionError.CreateFmt(SImageNotFound, [Name]);
  Result := Items[i];
end;

procedure TPictureCollection.Finalize;
var
  i: Integer;
begin
  try
    for i:=0 to Count-1 do
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

  for i:=0 to Count-1 do
    Items[i].Initialize;
end;

function TPictureCollection.Initialized: Boolean;
begin
  Result := (FDXDraw<>nil) and (FDXDraw.Initialized);
end;

procedure TPictureCollection.Restore;
var
  i: Integer;
begin
  for i:=0 to Count-1 do
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
    for i:=0 to 255 do
      if UseColorTable[i] then
        if DWORD(ColorTable[i])=DWORD(Col) then
          Exit;
    for i:=0 to 255 do
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
    if DIB.BitCount>8 then Exit;

    for i:=0 to 255 do
      AddColor(DIB.ColorTable[i]);
  end;

  procedure AddGraphic(Graphic: TGraphic);
  var
    i, n: Integer;
    PaletteEntries: TPaletteEntries;
  begin
    if Graphic.Palette<>0 then
    begin
      n := GetPaletteEntries(Graphic.Palette, 0, 256, PaletteEntries);
      for i:=0 to n-1 do
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

  for i:=0 to Count-1 do
    if Items[i].Picture.Graphic<>nil then
    begin
      if Items[i].Picture.Graphic is TDIB then
        AddDIB(TDIB(Items[i].Picture.Graphic))
      else
        AddGraphic(Items[i].Picture.Graphic);
      if PaletteCount=256 then Break;
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
  if (Operation=opRemove) and (DXDraw=AComponent) then
    DXDraw := nil;
end;

procedure TCustomDXImageList.DXDrawNotifyEvent(Sender: TCustomDXDraw;
  NotifyType: TDXDrawNotifyType);
begin
  case NotifyType of
    dxntDestroying: DXDraw := nil;
    dxntInitialize: FItems.Initialize(Sender);
    dxntFinalize  : FItems.Finalize;
    dxntRestore   : FItems.Restore;
  end;
end;

procedure TCustomDXImageList.SetDXDraw(Value: TCustomDXDraw);
begin
  if FDXDraw<>nil then
    FDXDraw.UnRegisterNotifyEvent(DXDrawNotifyEvent);

  FDXDraw := Value;

  if FDXDraw<>nil then
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
  if FDDraw2.IDraw.SetCooperativeLevel(WindowHandle, DDSCL_NORMAL)<>DD_OK then
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
                                                        
    if SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_FLIP<>0 then
    begin
      if FSurface.ISurface.GetAttachedSurface(BackBufferCaps, DDSurface)=DD_OK then
        FBackSurface.IDDSurface := DDSurface;
    end else
      FBackSurface.IDDSurface := FSurface.IDDSurface;

    if FVisible then
      SetOverlayRect(FOverlayRect)
    else
      FSurface.ISurface.UpdateOverlay(PRect(nil)^, FTargetSurface.ISurface, PRect(nil)^, DDOVER_HIDE, PDDOverlayFX(nil)^);
  except
    Finalize;
    raise;
  end;
end;

procedure TDirectDrawOverlay.Flip;
begin
  if FSurface=nil then Exit;

  if FSurface.SurfaceDesc.ddsCaps.dwCaps and DDSCAPS_FLIP<>0 then
    FSurface.ISurface.Flip(nil, DDFLIP_WAIT);
end;

procedure TDirectDrawOverlay.SetOverlayColorKey(Value: TColor);
begin
  FOverlayColorKey := Value;
  if FSurface<>nil then
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
  if (FSurface<>nil) and FVisible then
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

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_OVERLAYSTRETCH<>0) and
      (FDDraw.DriverCaps.dwMinOverlayStretch<>0) and (XScaleRatio<Integer(FDDraw.DriverCaps.dwMinOverlayStretch)) then
    begin
      DestRect.Right := DestRect.Left + (Integer(FSurface.SurfaceDesc.dwWidth) * (Integer(FDDraw.DriverCaps.dwMinOverlayStretch) + 1)) div 1000;
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_OVERLAYSTRETCH<>0) and
      (FDDraw.DriverCaps.dwMaxOverlayStretch<>0) and (XScaleRatio>Integer(FDDraw.DriverCaps.dwMaxOverlayStretch)) then
    begin
      DestRect.Right := DestRect.Left + (Integer(FSurface.SurfaceDesc.dwWidth) * (Integer(FDDraw.DriverCaps.dwMaxOverlayStretch) + 999)) div 1000;
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_OVERLAYSTRETCH<>0) and
      (FDDraw.DriverCaps.dwMinOverlayStretch<>0) and (YScaleRatio<Integer(FDDraw.DriverCaps.dwMinOverlayStretch)) then
    begin
      DestRect.Bottom := DestRect.Top + (Integer(FSurface.SurfaceDesc.dwHeight) * (Integer(FDDraw.DriverCaps.dwMinOverlayStretch) + 1)) div 1000;
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_OVERLAYSTRETCH<>0) and
      (FDDraw.DriverCaps.dwMaxOverlayStretch<>0) and (YScaleRatio>Integer(FDDraw.DriverCaps.dwMaxOverlayStretch)) then
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
    if (FDDraw.DriverCaps.dwCaps and DDCAPS_ALIGNBOUNDARYSRC<>0) and (FDDraw.DriverCaps.dwAlignBoundarySrc<>0) then
    begin
      SrcRect.Left := (SrcRect.Left + Integer(FDDraw.DriverCaps.dwAlignBoundarySrc) div 2) div
        Integer(FDDraw.DriverCaps.dwAlignBoundarySrc)*Integer(FDDraw.DriverCaps.dwAlignBoundarySrc);
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_ALIGNSIZESRC<>0) and (FDDraw.DriverCaps.dwAlignSizeSrc<>0) then
    begin
      SrcRect.Right := SrcRect.Left + (SrcRect.Right - SrcRect.Left + Integer(FDDraw.DriverCaps.dwAlignSizeSrc) div 2) div
        Integer(FDDraw.DriverCaps.dwAlignSizeSrc)*Integer(FDDraw.DriverCaps.dwAlignSizeSrc);
    end;

    {  Forwarding destination arrangement  }
    if (FDDraw.DriverCaps.dwCaps and DDCAPS_ALIGNBOUNDARYDEST<>0) and (FDDraw.DriverCaps.dwAlignBoundaryDest<>0) then
    begin
      DestRect.Left := (DestRect.Left + Integer(FDDraw.DriverCaps.dwAlignBoundaryDest) div 2) div
        Integer(FDDraw.DriverCaps.dwAlignBoundaryDest)*Integer(FDDraw.DriverCaps.dwAlignBoundaryDest);
    end;

    if (FDDraw.DriverCaps.dwCaps and DDCAPS_ALIGNSIZEDEST<>0) and (FDDraw.DriverCaps.dwAlignSizeDest<>0) then
    begin
      DestRect.Right := DestRect.Left + (DestRect.Right - DestRect.Left) div
        Integer(FDDraw.DriverCaps.dwAlignSizeDest)*Integer(FDDraw.DriverCaps.dwAlignSizeDest);
    end;

    {  Color key setting  }
    if FDDraw.DriverCaps.dwCKeyCaps and DDCKEYCAPS_DESTOVERLAY<>0 then
    begin
      OverlayFX.dckDestColorkey.dwColorSpaceLowValue := FTargetSurface.ColorMatch(FOverlayColorKey);
      OverlayFX.dckDestColorkey.dwColorSpaceHighValue := OverlayFX.dckDestColorkey.dwColorSpaceLowValue;

      OverlayFlags := OverlayFlags or (DDOVER_KEYDESTOVERRIDE or DDOVER_DDFX);
    end;

    FSurface.ISurface.UpdateOverlay(SrcRect, FTargetSurface.ISurface, DestRect, OverlayFlags, OverlayFX);
  end;
end;

procedure TDirectDrawOverlay.SetVisible(Value: Boolean);
begin
  FVisible := False;
  if FSurface<>nil then
  begin
    if FVisible then
      SetOverlayRect(FOverlayRect)
    else
      FSurface.ISurface.UpdateOverlay(PRect(nil)^, FTargetSurface.ISurface, PRect(nil)^, DDOVER_HIDE, PDDOverlayFX(nil)^);
  end;
end;

initialization
finalization
  DirectDrawDrivers.Free;
end.


