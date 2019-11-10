unit DXSprite;

interface

{$INCLUDE DelphiXcfg.inc}

uses
  Windows, SysUtils, Classes, DXClass, DXDraws,
{$IfDef StandardDX}
  DirectDraw;
{$Else}
  DirectX;
{$EndIf}


type
  {  BlendMode type  }
  
  TBlendMode = (bmDraw, bmBlend, bmAdd, bmSub);

  {  ESpriteError  }

  ESpriteError = class(Exception);

  {  TSprite  }

  TSpriteEngine = class;

  TSprite = class;
  TCollisionEvent = procedure(Sender: TObject; var Done: Boolean) of object;
  TMoveEvent = procedure(Sender: TObject; var MoveCount: Integer) of object;
  TDrawEvent = procedure(Sender: TObject) of object;
  TGetImage = procedure(Sender: TObject; var Image: TPictureCollectionItem) of object;

  TSprite = class(TPersistent)
  private
    FEngine: TSpriteEngine;
    FParent: TSprite;
    FList: TList;
    FDeaded: boolean;
    FDrawList: TList;
    FCollisioned: boolean;
    FMoved: boolean;
    FVisible: boolean;
    FX: double;
    FY: double;
    FZ: integer;
    FWidth: integer;
    FHeight: integer;
{$IFDEF Ver4Up}
    FSelected: boolean;
    FGroupNumber: integer;
{$ENDIF}
    FCaption: string;
    FTag: Integer;
    FOnDraw: TDrawEvent;
    FOnMove: TMoveEvent;
    FOnCollision: TCollisionEvent;
    FOnGetImage: TGetImage;
    procedure Add(Sprite: TSprite);
    procedure Remove(Sprite: TSprite);
    procedure AddDrawList(Sprite: TSprite);
    procedure Collision2;
    procedure Draw;
    function GetClientRect: TRect;
    function GetCount: integer;
    function GetItem(Index: integer): TSprite;
    function GetWorldX: double;
    function GetWorldY: double;
    procedure SetZ(Value: integer);
  protected
    procedure DoCollision(Sprite: TSprite; var Done: boolean); virtual;
    procedure DoDraw; virtual;
    procedure DoMove(MoveCount: integer); virtual;
    function GetBoundsRect: TRect; virtual;
    function TestCollision(Sprite: TSprite): boolean; virtual;
{$IFDEF Ver4Up}
    procedure SetGroupNumber(AGroupNumber: integer); virtual;
    procedure SetSelected(ASelected: Boolean); virtual;
{$ENDIF}
  public
    constructor Create(AParent: TSprite); virtual;
    destructor Destroy; override;
    procedure Clear;
    function Collision: integer;
    procedure Dead;
    procedure Move(MoveCount: integer);
    function GetSpriteAt(X, Y: integer): TSprite;
    property BoundsRect: TRect read GetBoundsRect;
    property ClientRect: TRect read GetClientRect;
    property Count: integer read GetCount;
    property Engine: TSpriteEngine read FEngine;
    property Items[Index: integer]: TSprite read GetItem; default;
    property Deaded: boolean read FDeaded;
    property Parent: TSprite read FParent;
    property WorldX: double read GetWorldX;
    property WorldY: double read GetWorldY;
    // Group handling support
{$IFDEF Ver4Up}
    // if GroupNumber < 0 then no group is assigned
    property GroupNumber: Integer read FGroupNumber write SetGroupNumber;
    property Selected: boolean read FSelected write SetSelected;
{$ENDIF}
    procedure Assign(Source: TPersistent); override;
  published
    property Height: integer read FHeight write FHeight;
    property Moved: boolean read FMoved write FMoved;
    property Visible: boolean read FVisible write FVisible;
    property Width: integer read FWidth write FWidth;
    property X: double read FX write FX;
    property Y: double read FY write FY;
    property Z: integer read FZ write SetZ;
    property Collisioned: boolean read FCollisioned write FCollisioned;
    property Tag: Integer read FTag write FTag;
    property Caption: string read FCaption write FCaption;
    property OnDraw: TDrawEvent read FOnDraw write FOnDraw;
    property OnMove: TMoveEvent read FOnMove write FOnMove;
    property OnCollision: TCollisionEvent read FOnCollision write FOnCollision;
    property OnGetImage: TGetImage read FOnGetImage write FOnGetImage;
  end;

  TSpriteClass = class of TSprite;

  {  TImageSprite  }

  TImageSprite = class(TSprite)
  private
    FAnimCount: integer;
    FAnimLooped: boolean;
    FAnimPos: double;
    FAnimSpeed: double;
    FAnimStart: integer;
    FImage: TPictureCollectionItem;
    FPixelCheck: boolean;
    FTile: boolean;
    FTransparent: boolean;
    function GetDrawImageIndex: integer;
    function GetDrawRect: TRect;
    function ImageCollisionTest(suf1, suf2: TDirectDrawSurface;
      const rect1, rect2: TRect; x1, y1, x2, y2: integer;
      DoPixelCheck: boolean): boolean;
  protected
    procedure DoDraw; override;
    procedure DoMove(MoveCount: integer); override;
    function GetBoundsRect: TRect; override;
    function TestCollision(Sprite: TSprite): boolean; override;
    procedure SetImage(AImage: TPictureCollectionItem); virtual;
  public
    constructor Create(AParent: TSprite); override;
    procedure Assign(Source: TPersistent); override;
    procedure ReAnimate(MoveCount: integer);
    property Image: TPictureCollectionItem read FImage write SetImage;
  published
    property AnimCount: integer read FAnimCount write FAnimCount;
    property AnimLooped: boolean read FAnimLooped write FAnimLooped;
    property AnimPos: double read FAnimPos write FAnimPos;
    property AnimSpeed: double read FAnimSpeed write FAnimSpeed;
    property AnimStart: integer read FAnimStart write FAnimStart;
    property PixelCheck: boolean read FPixelCheck write FPixelCheck;
    property Tile: boolean read FTile write FTile;
    property OnDraw;
    property OnMove;
    property OnCollision;
    property OnGetImage;
  end;

  {  TImageSpriteEx  }

  TImageSpriteEx = class(TImageSprite)
  private
    FAngle: integer;
    FAlpha: integer;
    FBlendMode: TBlendMode;
  protected
    procedure DoDraw; override;
    function GetBoundsRect: TRect; override;
    function TestCollision(Sprite: TSprite): boolean; override;
  public
    constructor Create(AParent: TSprite); override;
    procedure Assign(Source: TPersistent); override;
  published
    property BlendMode: TBlendMode read FBlendMode write FBlendMode default bmDraw;
    property Angle: integer read FAngle write FAngle;
    property Alpha: integer read FAlpha write FAlpha;
    property AnimCount;
    property AnimLooped;
    property AnimPos;
    property AnimSpeed;
    property AnimStart;
    property PixelCheck;
    property Tile;
    property OnDraw;
    property OnMove;
    property OnCollision;
    property OnGetImage;
  end;

  {  TBackgroundSprite  }

  TBackgroundSprite = class(TSprite)
  private
    FImage: TPictureCollectionItem;
    FCollisionMap: Pointer;
    FMap: Pointer;
    FMapWidth: integer;
    FMapHeight: integer;
    FTile: boolean;
    FChipsRect: TRect;
    FChipsPatternIndex: Integer;
    function GetCollisionMapItem(X, Y: integer): boolean;
    function GetChip(X, Y: integer): integer;
    procedure SetChip(X, Y: integer; Value: integer);
    procedure SetCollisionMapItem(X, Y: integer; Value: boolean);
    procedure SetMapHeight(Value: integer);
    procedure SetMapWidth(Value: integer);
    procedure SetImage(Img: TPictureCollectionItem);
    procedure ChipsDraw(Image: TPictureCollectionItem; X, Y,
      PatternIndex: Integer);
  protected
    procedure DoDraw; override;
    function GetBoundsRect: TRect; override;
    function TestCollision(Sprite: TSprite): boolean; override;
  public
    constructor Create(AParent: TSprite); override;
    destructor Destroy; override;
    procedure SetMapSize(AMapWidth, AMapHeight: integer);
    property Chips[X, Y: integer]: integer read GetChip write SetChip;
    property CollisionMap[X, Y: integer]: boolean
    read GetCollisionMapItem write SetCollisionMapItem;
    procedure Assign(Source: TPersistent); override;
    Property ChipsRect: TRect read FChipsRect write FChipsRect;
    Property ChipsPatternIndex: Integer read FChipsPatternIndex write FChipsPatternIndex;
    property Image: TPictureCollectionItem read FImage write SetImage;
  published
    property MapHeight: integer read FMapHeight write SetMapHeight;
    property MapWidth: integer read FMapWidth write SetMapWidth;
    property Tile: boolean read FTile write FTile;
    property OnDraw;
    property OnMove;
    property OnCollision;
    property OnGetImage;
  end;

  {  TSpriteEngine  }

  TSpriteEngine = class(TSprite)
  private
    FAllCount: integer;
    FCollisionCount: integer;
    FCollisionDone: boolean;
    FCollisionRect: TRect;
    FCollisionSprite: TSprite;
    FDeadList: TList;
    FDrawCount: integer;
    FSurface: TDirectDrawSurface;
    FSurfaceRect: TRect;
{$IFDEF Ver4Up}
    FObjectsSelected: Boolean;
    FGroupCount: integer;
    FGroups: array of Tlist;
    FCurrentSelected: Tlist;
{$ENDIF}
  protected
    procedure SetSurface(Value: TDirectDrawSurface); virtual;
{$IFDEF Ver4Up}
    procedure SetGroupCount(AGroupCount: integer); virtual;
    function GetGroup(Index: integer): Tlist; virtual;
{$ENDIF}
  public
    constructor Create(AParent: TSprite); override;
    destructor Destroy; override;
    procedure Dead;
    procedure Draw;
    property AllCount: integer read FAllCount;
    property DrawCount: integer read FDrawCount;
    property Surface: TDirectDrawSurface read FSurface write SetSurface;
    property SurfaceRect: TRect read FSurfaceRect;

    // Extended Sprite Engine
    procedure Collisions;

    // Group handling support
{$IFDEF Ver4Up}
    procedure ClearCurrent;
    procedure ClearGroup(GroupNumber: integer);
    procedure GroupToCurrent(GroupNumber: integer; Add: Boolean = false);
    procedure CurrentToGroup(GroupNumber: integer; Add: Boolean = false);
    procedure GroupSelect(const Area: TRect; Filter: array of TSpriteClass; Add: Boolean = false); overload;
    procedure GroupSelect(const Area: TRect; Add: Boolean = false); overload;
    function Select(Point: TPoint; Filter: array of TSpriteClass; Add: Boolean = false): Tsprite; overload;
    function Select(Point: TPoint; Add: Boolean = false): Tsprite; overload;

    property CurrentSelected: TList read fCurrentSelected;
    property ObjectsSelected: Boolean read fObjectsSelected;
    property Groups[Index: integer]: Tlist read GetGroup;
    property GroupCount: integer read fGroupCount write SetGroupCount;
{$ENDIF}
  end;

  {  EDXSpriteEngineError  }

  EDXSpriteEngineError = class(Exception);

  TSpriteCollection = class;

  {  TSpriteType  }

  TSpriteType = (stSprite, stImageSprite, stImageSpriteEx, stBackgroundSprite);

  {  TSpriteCollectionItem  }

  TSpriteCollectionItem = class(THashCollectionItem)
  private
    FOwner: TPersistent;
    FOwnerItem: TSpriteEngine;
    FSpriteType: TSpriteType;
    FSprite: TSprite;
    procedure Finalize;
    procedure Initialize;
    function GetSpriteCollection: TSpriteCollection;
    procedure SetSprite(const Value: TSprite);
    procedure SetOnCollision(const Value: TCollisionEvent);
    procedure SetOnDraw(const Value: TDrawEvent);
    procedure SetOnMove(const Value: TMoveEvent);
    function GetSpriteType: TSpriteType;
    procedure SetSpriteType(const Value: TSpriteType);
    function GetOnCollision: TCollisionEvent;
    function GetOnDraw: TDrawEvent;
    function GetOnMove: TMoveEvent;
    function GetOnGetImage: TGetImage;
    procedure SetOnGetImage(const Value: TGetImage);
  protected
    function GetDisplayName: string; override;
    procedure SetDisplayName(const Value: string); override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property SpriteCollection: TSpriteCollection read GetSpriteCollection;
  published
    {published property of sprite}
    property KindSprite: TSpriteType read GetSpriteType write SetSpriteType;
    property Sprite: TSprite read FSprite write SetSprite;
    {published events of sprite}
    property OnDraw: TDrawEvent read GetOnDraw write SetOnDraw;
    property OnMove: TMoveEvent read GetOnMove write SetOnMove;
    property OnCollision: TCollisionEvent read GetOnCollision write SetOnCollision;
    property OnGetImage: TGetImage read GetOnGetImage write SetOnGetImage;
  end;

  {  ESpriteCollectionError  }

  ESpriteCollectionError = class(Exception);

  {  TSpriteCollection  }

  TSCInitialize = procedure(Owner: TSpriteEngine) of object;
  TSCFinalize = procedure(Owner: TSpriteEngine) of object;

  TSpriteCollection = class(THashCollection)
  private
    FOwner: TPersistent;
    FOwnerItem: TSpriteEngine;
    FOnInitialize: TSCInitialize;
    FOnFinalize: TSCFinalize;
    function GetItem(Index: Integer): TSpriteCollectionItem;
    function Initialized: Boolean;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent);
    function Find(const Name: string): TSpriteCollectionItem;
    function Add: TSpriteCollectionItem;
    procedure Finalize;
    function Initialize(DXSpriteEngine: TSpriteEngine): Boolean;
    property Items[Index: Integer]: TSpriteCollectionItem read GetItem; default;
  published
    property OnInitialize: TSCInitialize read FOnInitialize write FOnInitialize;
    property OnFinalize: TSCFinalize read FOnFinalize write FOnFinalize;
  end;

  {  TCustomDXSpriteEngine  }

  TCustomDXSpriteEngine = class(TComponent)
  private
    FDXDraw: TCustomDXDraw;
    FEngine: TSpriteEngine;
    FItems: TSpriteCollection;
    procedure DXDrawNotifyEvent(Sender: TCustomDXDraw; NotifyType: TDXDrawNotifyType);
    procedure SetDXDraw(Value: TCustomDXDraw);
    procedure SetItems(const Value: TSpriteCollection);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Dead;
    procedure Draw;
    procedure Move(MoveCount: integer);
    property DXDraw: TCustomDXDraw read FDXDraw write SetDXDraw;
    property Engine: TSpriteEngine read FEngine;
    property Items: TSpriteCollection read FItems write SetItems;
  end;

  {  TDXSpriteEngine  }

  TDXSpriteEngine = class(TCustomDXSpriteEngine)
    property Items;
  published
    property DXDraw;
  end;

function Mod2(i, i2: integer): integer;
function Mod2f(i: double; i2: integer): double;

implementation

uses DXConsts;

const
  SSpriteNotFound = 'Sprite not found';
  SSpriteDuplicateName = 'Item duplicate name "%s" error';

function Mod2(i, i2: integer): integer;
begin
  Result := i mod i2;
  if Result < 0 then
    Result := i2 + Result;
end;

function Mod2f(i: double; i2: integer): double;
begin
  if i2 = 0 then
    Result := i
  else
  begin
    Result := i - Round(i / i2) * i2;
    if Result < 0 then
      Result := i2 + Result;
  end;
end;

{  TSprite  }

constructor TSprite.Create(AParent: TSprite);
begin
  inherited Create;
{$IFDEF Ver4Up}
  fGroupnumber := -1;
{$ENDIF}
  FParent := AParent;
  if FParent <> nil then
  begin
    FParent.Add(Self);
    if FParent is TSpriteEngine then
      FEngine := TSpriteEngine(FParent)
    else
      FEngine := FParent.Engine;
    Inc(FEngine.FAllCount);
  end;

  FCollisioned := True;
  FMoved := True;
  FVisible := True;
end;

destructor TSprite.Destroy;
begin
{$IFDEF Ver4Up}
  GroupNumber := -1;
  Selected := false;
{$ENDIF}
  Clear;
  if FParent <> nil then
  begin
    Dec(FEngine.FAllCount);
    FParent.Remove(Self);
    FEngine.FDeadList.Remove(Self);
  end;
  FList.Free;
  FDrawList.Free;
  inherited Destroy;
end;

{$IFDEF Ver4Up}

procedure TSprite.SetGroupNumber(AGroupNumber: integer);
begin
  if (AGroupNumber <> GroupNumber) and
    (Engine <> nil) then
  begin
    if Groupnumber >= 0 then
      Engine.Groups[GroupNumber].Remove(self);
    if AGroupNumber >= 0 then
      Engine.Groups[AGroupNumber].Add(self);
  end;
end; {SetGroupNumber}

procedure TSprite.SetSelected(ASelected: Boolean);
begin
  if (ASelected <> fSelected) and
    (Engine <> nil) then
  begin
    fSelected := ASelected;
    if Selected then
      Engine.CurrentSelected.Add(self)
    else
      Engine.CurrentSelected.Remove(self);
    Engine.fObjectsSelected := Engine.CurrentSelected.count <> 0;
  end;
end;
{$ENDIF}

procedure TSprite.Add(Sprite: TSprite);
begin
  if FList = nil then
  begin
    FList := TList.Create;
    FDrawList := TList.Create;
  end;
  FList.Add(Sprite);
  AddDrawList(Sprite);
end;

procedure TSprite.Remove(Sprite: TSprite);
begin
  FList.Remove(Sprite);
  FDrawList.Remove(Sprite);
  if FList.Count = 0 then
  begin
    FList.Free;
    FList := nil;
    FDrawList.Free;
    FDrawList := nil;
  end;
end;

procedure TSprite.AddDrawList(Sprite: TSprite);
var
  L, H, I, C: integer;
begin
  L := 0;
  H := FDrawList.Count - 1;
  while L <= H do
  begin
    I := (L + H) div 2;
    C := TSprite(FDrawList[I]).Z - Sprite.Z;
    if C < 0 then
      L := I + 1
    else
      H := I - 1;
  end;
  FDrawList.Insert(L, Sprite);
end;

procedure TSprite.Clear;
begin
  while Count > 0 do
    Items[Count - 1].Free;
end;

function TSprite.Collision: integer;
var
  i: integer;
begin
  Result := 0;
  if (FEngine <> nil) and (not FDeaded) and (Collisioned) then
  begin
    with FEngine do
    begin
      FCollisionCount := 0;
      FCollisionDone := False;
      FCollisionRect := Self.BoundsRect;
      FCollisionSprite := Self;

      for i := 0 to Count - 1 do
        Items[i].Collision2;

      Result := FCollisionCount;
    end;
  end;
end;

procedure TSprite.Collision2;
var
  i: integer;
begin
  if Collisioned then
  begin
    if (Self <> FEngine.FCollisionSprite) and OverlapRect(BoundsRect,
      FEngine.FCollisionRect) and FEngine.FCollisionSprite.TestCollision(Self) and
      TestCollision(FEngine.FCollisionSprite) then
    begin
      Inc(FEngine.FCollisionCount);
      FEngine.FCollisionSprite.DoCollision(Self, FEngine.FCollisionDone);
      if (not FEngine.FCollisionSprite.Collisioned) or
        (FEngine.FCollisionSprite.FDeaded) then
      begin
        FEngine.FCollisionDone := True;
      end;
    end;
    if FEngine.FCollisionDone then
      Exit;
    for i := 0 to Count - 1 do
      Items[i].Collision2;
  end;
end;

procedure TSprite.Dead;
begin
  if (FEngine <> nil) and (not FDeaded) then
  begin
    FDeaded := True;
    FEngine.FDeadList.Add(Self);
  end;
end;

procedure TSprite.DoMove(MoveCount: integer);
begin
  if AsSigned(FOnMove) then
    FOnMove(Self, MoveCount);
end;

procedure TSprite.DoDraw;
begin
  if AsSigned(FOnDraw) then
    FOnDraw(Self);
end;

procedure TSprite.DoCollision(Sprite: TSprite; var Done: boolean);
begin
  if AsSigned(FOnCollision) then
    FOnCollision(Sprite, Done);
end;

function TSprite.TestCollision(Sprite: TSprite): boolean;
begin
  Result := True;
end;

procedure TSprite.Move(MoveCount: integer);
var
  i: integer;
begin
  if FMoved then
  begin
    DoMove(MoveCount);
    for i := 0 to Count - 1 do
      Items[i].Move(MoveCount);
  end;
end;

procedure TSprite.Draw;
var
  i: integer;
begin
  if FVisible then
  begin
    if FEngine <> nil then
    begin
      if OverlapRect(FEngine.FSurfaceRect, BoundsRect) then
      begin
        DoDraw;
        Inc(FEngine.FDrawCount);
      end;
    end;

    if FDrawList <> nil then
    begin
      for i := 0 to FDrawList.Count - 1 do
        TSprite(FDrawList[i]).Draw;
    end;
  end;
end;

function TSprite.GetSpriteAt(X, Y: integer): TSprite;

  procedure Collision_GetSpriteAt(X, Y: double; Sprite: TSprite);
  var
    i: integer;
    X2, Y2: double;
  begin
    if Sprite.Visible and PointInRect(Point(Round(X), Round(Y)),
      Bounds(Round(Sprite.X), Round(Sprite.Y), Sprite.Width, Sprite.Width)) then
    begin
      if (Result = nil) or (Sprite.Z > Result.Z) then
        Result := Sprite;
    end;

    X2 := X - Sprite.X;
    Y2 := Y - Sprite.Y;
    for i := 0 to Sprite.Count - 1 do
      Collision_GetSpriteAt(X2, Y2, Sprite.Items[i]);
  end;

var
  i: integer;
  X2, Y2: double;
begin
  Result := nil;

  X2 := X - Self.X;
  Y2 := Y - Self.Y;
  for i := 0 to Count - 1 do
    Collision_GetSpriteAt(X2, Y2, Items[i]);
end;

function TSprite.GetBoundsRect: TRect;
begin
  Result := Bounds(Round(WorldX), Round(WorldY), Width, Height);
end;

function TSprite.GetClientRect: TRect;
begin
  Result := Bounds(0, 0, Width, Height);
end;

function TSprite.GetCount: integer;
begin
  if FList <> nil then
    Result := FList.Count
  else
    Result := 0;
end;

function TSprite.GetItem(Index: integer): TSprite;
begin
  if FList <> nil then
    Result := FList[Index]
  else
    raise ESpriteError.CreateFmt(SListIndexError, [Index]);
end;

function TSprite.GetWorldX: double;
begin
  if Parent <> nil then
    Result := Parent.WorldX + FX
  else
    Result := FX;
end;

function TSprite.GetWorldY: double;
begin
  if Parent <> nil then
    Result := Parent.WorldY + FY
  else
    Result := FY;
end;

procedure TSprite.SetZ(Value: integer);
begin
  if FZ <> Value then
  begin
    FZ := Value;
    if Parent <> nil then
    begin
      Parent.FDrawList.Remove(Self);
      Parent.AddDrawList(Self);
    end;
  end;
end;

procedure TSprite.Assign(Source: TPersistent);
begin
  if Source is TSprite then begin
    FCollisioned := TSprite(Source).FCollisioned;
    FMoved := TSprite(Source).FMoved;
    FVisible := TSprite(Source).FVisible;
    FHeight := TSprite(Source).FHeight;
    FWidth := TSprite(Source).FWidth;
    FX := TSprite(Source).FX;
    FY := TSprite(Source).FY;
    FZ := TSprite(Source).FZ;
{$IFDEF Ver4Up}
    FSelected := TSprite(Source).FSelected;
    FGroupNumber := TSprite(Source).FGroupNumber;
{$ENDIF}
    FOnDraw := TSprite(Source).FOnDraw;
    FOnMove := TSprite(Source).FOnMove;
    FOnCollision := TSprite(Source).FOnCollision;
    FOnGetImage := TSprite(Source).FOnGetImage;
  end
  else
    inherited;
end;

{  TImageSprite  }

constructor TImageSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  FTransparent := True;
end;

procedure TImageSprite.SetImage(AImage: TPictureCollectionItem);
begin
  fImage := AImage;
  if AImage <> nil then
  begin
    Width := AImage.Width;
    Height := AImage.Height;
  end
  else
  begin
    Width := 0;
    Height := 0;
  end;
end; {SetImage}

function TImageSprite.GetBoundsRect: TRect;
var
  dx, dy: integer;
begin
  dx := Round(WorldX);
  dy := Round(WorldY);
  if FTile then
  begin
    dx := Mod2(dx, FEngine.SurfaceRect.Right + Width);
    dy := Mod2(dy, FEngine.SurfaceRect.Bottom + Height);

    if dx > FEngine.SurfaceRect.Right then
      dx := (dx - FEngine.SurfaceRect.Right) - Width;

    if dy > FEngine.SurfaceRect.Bottom then
      dy := (dy - FEngine.SurfaceRect.Bottom) - Height;
  end;

  Result := Bounds(dx, dy, Width, Height);
end;

procedure TImageSprite.DoMove(MoveCount: integer);
begin
  if AsSigned(FOnMove) then
    FOnMove(Self, MoveCount)
  else begin

    ReAnimate(MoveCount);
  end;
end;

function TImageSprite.GetDrawImageIndex: integer;
begin
  Result := FAnimStart + Round(FAnimPos);
end;

function TImageSprite.GetDrawRect: TRect;
begin
  Result := BoundsRect;
  OffsetRect(Result, (Width - Image.Width) div 2, (Height - Image.Height) div 2);
end;

procedure TImageSprite.DoDraw;
var
  ImageIndex: integer;
  r: TRect;
  vImage: TPictureCollectionItem;
begin
  if Image = nil then
    if AsSigned(FOnGetImage) then begin
      vImage := nil;
      FOnGetImage(Self, vImage);
      if vImage <> FImage then
        Image := vImage;
    end;
  if AsSigned(FOnDraw) then
    FOnDraw(Self)
  else
  begin
    ImageIndex := GetDrawImageIndex;
    r := GetDrawRect;
    Image.Draw(FEngine.Surface, r.Left, r.Top, ImageIndex);
  end;
end;

{$WARNINGS OFF}
{$HINTS OFF}

function TImageSprite.ImageCollisionTest(suf1, suf2: TDirectDrawSurface;
  const rect1, rect2: TRect; x1, y1, x2, y2: integer; DoPixelCheck: boolean): boolean;

  function ClipRect(var DestRect: TRect; const DestRect2: TRect): boolean;
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

type
  PRGB = ^TRGB;

  TRGB = packed record
    R, G, B: byte;
  end;
var
  ddsd1, ddsd2: TDDSURFACEDESC;
  r1, r2, r1a, r2a: TRect;
  tc1, tc2: DWORD;
  x, y, w, h: integer;
  P1, P2: Pointer;
begin
  with rect1 do
    r1 := Bounds(0, 0, Right - Left, Bottom - Top);
  r1a := r1;
  with rect2 do
    r2 := Bounds(0, 0, Right - Left, Bottom - Top);
  r2a := r2;

  with rect2 do
    r2 := Bounds(x2 - x1, y2 - y1, Right - Left, Bottom - Top);

  Result := OverlapRect(r1, r2);

  if (suf1 = nil) or (suf2 = nil) then
    Exit;

  if DoPixelCheck and Result then
  begin
    {  Get Overlapping rectangle  }
    with r1 do
      r1 := Bounds(Max(x2 - x1, 0), Max(y2 - y1, 0), Right - Left, Bottom - Top);
    with r2 do
      r2 := Bounds(Max(x1 - x2, 0), Max(y1 - y2, 0), Right - Left, Bottom - Top);

    ClipRect(r1, r1a);
    ClipRect(r2, r2a);

    w := Min(r1.Right - r1.Left, r2.Right - r2.Left);
    h := Min(r1.Bottom - r1.Top, r2.Bottom - r2.Top);

    ClipRect(r1, bounds(r1.Left, r1.Top, w, h));
    ClipRect(r2, bounds(r2.Left, r2.Top, w, h));

    {  Pixel check !!!  }
    ddsd1.dwSize := SizeOf(ddsd1);

    with rect1 do
      r1 := Bounds(r1.Left + left, r1.Top + top, w, h);
    with rect2 do
      r2 := Bounds(r2.Left + left, r2.Top + top, w, h);

    if suf1 = suf2 then
    begin
      suf2.Lock(r2, ddsd2);
      suf2.unlock;
    end;

    if suf1.Lock(r1, ddsd1) then
    begin
      try
        ddsd2.dwSize := SizeOf(ddsd2);
        if (suf1 = suf2) or suf2.Lock(r2, ddsd2) then
        begin
          try
            {this line out: don't test pixel but rect only, its wrong}
            {if suf1=suf2 then ddsd2 := ddsd1;}
            if ddsd1.ddpfPixelFormat.dwRGBBitCount <> ddsd2.ddpfPixelFormat.dwRGBBitCount
              then
              Exit;

            {  Get transparent color  }
            tc1 := ddsd1.ddckCKSrcBlt.dwColorSpaceLowValue;
            tc2 := ddsd2.ddckCKSrcBlt.dwColorSpaceLowValue;

            case ddsd1.ddpfPixelFormat.dwRGBBitCount of
              8:
                begin
                  for y := 0 to h - 1 do
                  begin
                    P1 := Pointer(integer(ddsd1.lpSurface) + y * ddsd1.lPitch);
                    P2 := Pointer(integer(ddsd2.lpSurface) + y * ddsd2.lPitch);
                    for x := 0 to w - 1 do
                    begin
                      if (PByte(P1)^ <> tc1) and (PByte(P2)^ <> tc2) then
                        Exit;
                      Inc(PByte(P1));
                      Inc(PByte(P2));
                    end;
                  end;
                end;
              16:
                begin
                  for y := 0 to h - 1 do
                  begin
                    P1 := Pointer(integer(ddsd1.lpSurface) + y * ddsd1.lPitch);
                    P2 := Pointer(integer(ddsd2.lpSurface) + y * ddsd2.lPitch);
                    for x := 0 to w - 1 do
                    begin
                      if (PWord(P1)^ <> tc1) and (PWord(P2)^ <> tc2) then
                        Exit;
                      Inc(PWord(P1));
                      Inc(PWord(P2));
                    end;
                  end;
                end;
              24:
                begin
                  for y := 0 to h - 1 do
                  begin
                    P1 := Pointer(integer(ddsd1.lpSurface) + y * ddsd1.lPitch);
                    P2 := Pointer(integer(ddsd2.lpSurface) + y * ddsd2.lPitch);
                    for x := 0 to w - 1 do
                    begin
                      with PRGB(P1)^ do
                        if (R shl 16) or (G shl 8) or B <> tc1 then
                          Exit;
                      with PRGB(P2)^ do
                        if (R shl 16) or (G shl 8) or B <> tc2 then
                          Exit;
                      Inc(PRGB(P1));
                      Inc(PRGB(P2));
                    end;
                  end;
                end;
              32:
                begin
                  for y := 0 to h - 1 do
                  begin
                    P1 := Pointer(integer(ddsd1.lpSurface) + y * ddsd1.lPitch);
                    P2 := Pointer(integer(ddsd2.lpSurface) + y * ddsd2.lPitch);
                    for x := 0 to w - 1 do
                    begin
                      if (PDWORD(P1)^ <> tc1) and (PDWORD(P2)^ <> tc2) then
                        Exit;
                      Inc(PDWORD(P1));
                      Inc(PDWORD(P2));
                    end;
                  end;
                end;
            end;
          finally
            if suf1 <> suf2 then
              suf2.UnLock;
          end;
        end;
      finally
        suf1.UnLock;
      end;
    end;

    Result := False;
  end;
end;

{$HINTS ON}
{$WARNINGS ON}

function TImageSprite.TestCollision(Sprite: TSprite): boolean;
var
  img1, img2: integer;
  box1, box2: TRect;
begin
  if (Sprite is TImageSprite) and FPixelCheck then
  begin
    box1 := GetDrawRect;
    box2 := TImageSprite(Sprite).GetDrawRect;

    img1 := GetDrawImageIndex;
    img2 := TImageSprite(Sprite).GetDrawImageIndex;

    Result := ImageCollisionTest(Image.PatternSurfaces[img1],
      TImageSprite(Sprite).Image.PatternSurfaces[img2], Image.PatternRects[img1],
      TImageSprite(Sprite).Image.PatternRects[img2], box1.Left, box1.Top,
      box2.Left, box2.Top, True);
  end
  else
    Result := inherited TestCollision(Sprite);
end;

procedure TImageSprite.Assign(Source: TPersistent);
begin
  if Source is TImageSprite then begin
    FAnimCount := TImageSprite(Source).FAnimCount;
    FAnimLooped := TImageSprite(Source).FAnimLooped;
    FAnimPos := TImageSprite(Source).FAnimPos;
    FAnimSpeed := TImageSprite(Source).FAnimSpeed;
    FAnimStart := TImageSprite(Source).FAnimStart;
    FImage := TImageSprite(Source).FImage;
    FPixelCheck := TImageSprite(Source).FPixelCheck;
    FTile := TImageSprite(Source).FTile;
    FTransparent := TImageSprite(Source).FTransparent;
  end;
  inherited;
end;

procedure TImageSprite.ReAnimate(MoveCount: integer);
begin
  FAnimPos := FAnimPos + FAnimSpeed * MoveCount;

  if FAnimLooped then
  begin
    if FAnimCount > 0 then
      FAnimPos := Mod2f(FAnimPos, FAnimCount)
    else
      FAnimPos := 0;
  end
  else
  begin
    if Round(FAnimPos) >= FAnimCount then
    begin
      FAnimPos := FAnimCount - 1;
      FAnimSpeed := 0;
    end;
    if FAnimPos < 0 then
    begin
      FAnimPos := 0;
      FAnimSpeed := 0;
    end;
  end;
end;

{  TImageSpriteEx  }

procedure TImageSpriteEx.Assign(Source: TPersistent);
begin
  if Source is TImageSpriteEx then begin
    FAngle := TImageSpriteEx(Source).FAngle;
    FAlpha := TImageSpriteEx(Source).FAlpha;
    FBlendMode := TImageSpriteEx(Source).FBlendMode;
  end;
  inherited;
end;

constructor TImageSpriteEx.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  FAlpha := 255;
  FAngle := 0;
  FBlendMode := bmDraw;
end;

procedure TImageSpriteEx.DoDraw;
var
  r: TRect;
  vImage: TPictureCollectionItem;
begin
  {init image when object come from form}
  if Image = nil then
    if AsSigned(FOnGetImage) then begin
      vImage := nil;
      FOnGetImage(Self, vImage);
      if vImage <> FImage then
        Image := vImage;
    end;
  {owner draw called here}
  if AsSigned(FOnDraw) then
    FOnDraw(Self)
  else
  {when is not owner draw then go here}
  begin
    r := Bounds(Round(WorldX), Round(WorldY), Width, Height);
    Case FBlendMode of
     bmDraw: Begin  // FAlpha is ignored there
       if FAngle = 0 then
         Image.StretchDraw(FEngine.FSurface, r, GetDrawImageIndex)
       Else
         Image.DrawRotate(FEngine.FSurface, (r.Left + r.Right) div 2,
          (r.Top + r.Bottom) div 2,
          Width, Height, GetDrawImageIndex, 0.5, 0.5, FAngle);
      End;
     bmBlend: Begin
       if FAngle = 0 then
         Image.DrawAlpha(FEngine.FSurface, r, GetDrawImageIndex, FAlpha)
       Else
         Image.DrawRotateAlpha(FEngine.FSurface, (r.Left + r.Right) div 2,
          (r.Top + r.Bottom) div 2,
          Width, Height, GetDrawImageIndex, 0.5, 0.5, FAngle, FAlpha);
      End;
     bmAdd: Begin
       if FAngle = 0 then
         Image.DrawAdd(FEngine.FSurface, r, GetDrawImageIndex, FAlpha)
       Else
         Image.DrawRotateAdd(FEngine.FSurface, (r.Left + r.Right) div 2,
          (r.Top + r.Bottom) div 2,
          Width, Height, GetDrawImageIndex, 0.5, 0.5, FAngle, FAlpha);
      End;
     bmSub: Begin
       if FAngle = 0 then
         Image.DrawSub(FEngine.FSurface, r, GetDrawImageIndex, FAlpha)
       Else
         Image.DrawRotateSub(FEngine.FSurface, (r.Left + r.Right) div 2,
          (r.Top + r.Bottom) div 2,
          Width, Height, GetDrawImageIndex, 0.5, 0.5, FAngle, FAlpha);
      End;
    End;{case}
  end;
end;

function TImageSpriteEx.GetBoundsRect: TRect;
begin
  Result := FEngine.SurfaceRect;
end;

function TImageSpriteEx.TestCollision(Sprite: TSprite): boolean;
begin
  if Sprite is TImageSpriteEx then
  begin
    Result := OverlapRect(Bounds(Round(Sprite.WorldX), Round(Sprite.WorldY),
      Sprite.Width, Sprite.Height), Bounds(Round(WorldX), Round(WorldY), Width, Height));
  end
  else
  begin
    Result := OverlapRect(Sprite.BoundsRect, Bounds(Round(WorldX),
      Round(WorldY), Width, Height));
  end;
end;

{  TBackgroundSprite  }

constructor TBackgroundSprite.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  Collisioned := False;
end;

destructor TBackgroundSprite.Destroy;
begin
  SetMapSize(0, 0);
  inherited Destroy;
end;

procedure TBackgroundSprite.ChipsDraw(Image: TPictureCollectionItem; X, Y: Integer; PatternIndex: Integer);
Begin
  If AsSigned(FOnDraw) Then
    FOnDraw(Self)
  Else
    Image.Draw(FEngine.Surface, X, Y, PatternIndex);
End;

procedure TBackgroundSprite.DoDraw;
var
  TmpX, TmpY, cx, cy, cx2, cy2, PatternIndex, ChipWidth, ChipHeight: integer;
  StartX, StartY, EndX, EndY, StartX_, StartY_, OfsX, OfsY, dWidth, dHeight: integer;
  r: TRect;
  vImage: TPictureCollectionItem;
begin
  if Image = nil then
    if AsSigned(FOnGetImage) then begin
      vImage := nil;
      FOnGetImage(Self, vImage);
      if vImage <> FImage then
        Image := vImage;
    end;
  if Image = nil then
    Exit;

  if (FMapWidth <= 0) or (FMapHeight <= 0) then
    Exit;

  r := Image.PatternRects[0];
  ChipWidth := r.Right - r.Left;
  ChipHeight := r.Bottom - r.Top;

  dWidth := (FEngine.SurfaceRect.Right + ChipWidth) div ChipWidth + 1;
  dHeight := (FEngine.SurfaceRect.Bottom + ChipHeight) div ChipHeight + 1;

  TmpX := Round(WorldX);
  TmpY := Round(WorldY);

  OfsX := TmpX mod ChipWidth;
  OfsY := TmpY mod ChipHeight;

  StartX := TmpX div ChipWidth;
  StartX_ := 0;

  if StartX < 0 then
  begin
    StartX_ := -StartX;
    StartX := 0;
  end;

  StartY := TmpY div ChipHeight;
  StartY_ := 0;

  if StartY < 0 then
  begin
    StartY_ := -StartY;
    StartY := 0;
  end;

  EndX := Min(StartX + FMapWidth - StartX_, dWidth);
  EndY := Min(StartY + FMapHeight - StartY_, dHeight);

  if FTile then
  begin
    for cy := -1 to dHeight do
    begin
      cy2 := Mod2((cy - StartY + StartY_), FMapHeight);
      for cx := -1 to dWidth do
      begin
        cx2 := Mod2((cx - StartX + StartX_), FMapWidth);
        PatternIndex := Chips[cx2, cy2];
        ChipsPatternIndex := PatternIndex;
        ChipsRect := Bounds(cx * ChipWidth + OfsX,cy * ChipHeight + OfsY,ChipWidth,ChipHeight);
        if PatternIndex >= 0 then
          ChipsDraw(Image,cx * ChipWidth + OfsX, cy * ChipHeight + OfsY, PatternIndex);
          //Image.Draw(FEngine.Surface, cx * ChipWidth + OfsX, cy * ChipHeight + OfsY, PatternIndex);
      end;
    end;
  end
  else
  begin
    for cy := StartY to EndY - 1 do
      for cx := StartX to EndX - 1 do
      begin
        PatternIndex := Chips[cx - StartX + StartX_, cy - StartY + StartY_];
        ChipsPatternIndex := PatternIndex;
        ChipsRect := Bounds(cx * ChipWidth + OfsX,cy * ChipHeight + OfsY,ChipWidth,ChipHeight);
        if PatternIndex >= 0 then
          ChipsDraw(Image,cx * ChipWidth + OfsX, cy * ChipHeight + OfsY, PatternIndex);
          //Image.Draw(FEngine.Surface, cx * ChipWidth + OfsX, cy * ChipHeight + OfsY, PatternIndex);
      end;
  end;
end;

function TBackgroundSprite.TestCollision(Sprite: TSprite): boolean;
var
  box0, box1, box2: TRect;
  cx, cy, ChipWidth, ChipHeight: integer;
  r: TRect;
begin
  Result := True;
  if Image = nil then
    Exit;
  if (FMapWidth <= 0) or (FMapHeight <= 0) then
    Exit;

  r := Image.PatternRects[0];
  ChipWidth := r.Right - r.Left;
  ChipHeight := r.Bottom - r.Top;

  box1 := Sprite.BoundsRect;
  box2 := BoundsRect;

  IntersectRect(box0, box1, box2);

  OffsetRect(box0, -Round(WorldX), -Round(WorldY));
  OffsetRect(box1, -Round(WorldX), -Round(WorldY));

  for cy := (box0.Top - ChipHeight + 1) div ChipHeight to box0.Bottom div ChipHeight do
    for cx := (box0.Left - ChipWidth + 1) div ChipWidth to box0.Right div ChipWidth do
      if CollisionMap[Mod2(cx, MapWidth), Mod2(cy, MapHeight)] then
      begin
        if OverlapRect(Bounds(cx * ChipWidth, cy * ChipHeight, ChipWidth,
          ChipHeight), box1) then
          Exit;
      end;

  Result := False;
end;

function TBackgroundSprite.GetChip(X, Y: integer): integer;
begin
  if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
    Result := PInteger(integer(FMap) + (Y * FMapWidth + X) * SizeOf(integer))^
  else
    Result := -1;
end;

type
  PBoolean = ^boolean;

function TBackgroundSprite.GetCollisionMapItem(X, Y: integer): boolean;
begin
  if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
    Result := PBoolean(integer(FCollisionMap) + (Y * FMapWidth + X) * SizeOf(boolean))^
  else
    Result := False;
end;

function TBackgroundSprite.GetBoundsRect: TRect;
begin
  if FTile then
    Result := FEngine.SurfaceRect
  else
  begin
    if Image <> nil then
      Result := Bounds(Round(WorldX), Round(WorldY), Image.Width * FMapWidth,
        Image.Height * FMapHeight)
    else
      Result := Rect(0, 0, 0, 0);
  end;
end;

procedure TBackgroundSprite.SetChip(X, Y: integer; Value: integer);
begin
  if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
    PInteger(integer(FMap) + (Y * FMapWidth + X) * SizeOf(integer))^ := Value;
end;

procedure TBackgroundSprite.SetCollisionMapItem(X, Y: integer; Value: boolean);
begin
  if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
    PBoolean(integer(FCollisionMap) + (Y * FMapWidth + X) * SizeOf(boolean))^ := Value;
end;

procedure TBackgroundSprite.SetMapHeight(Value: integer);
begin
  SetMapSize(FMapWidth, Value);
end;

procedure TBackgroundSprite.SetMapWidth(Value: integer);
begin
  SetMapSize(Value, FMapHeight);
end;

procedure TBackgroundSprite.SetImage(Img: TPictureCollectionItem);
begin
  FImage := Img;
  FWidth := FMapWidth * Img.Width;
  FHeight := FMapHeight * Img.Height;
end;

procedure TBackgroundSprite.SetMapSize(AMapWidth, AMapHeight: integer);
begin
  if (FMapWidth <> AMapWidth) or (FMapHeight <> AMapHeight) then
  begin
    if (AMapWidth <= 0) or (AMapHeight <= 0) then
    begin
      AMapWidth := 0;
      AMapHeight := 0;
    end;
    FMapWidth := AMapWidth;
    FMapHeight := AMapHeight;
    ReAllocMem(FMap, FMapWidth * FMapHeight * SizeOf(integer));
    FillChar(FMap^, FMapWidth * FMapHeight * SizeOf(integer), 0);

    ReAllocMem(FCollisionMap, FMapWidth * FMapHeight * SizeOf(boolean));
    FillChar(FCollisionMap^, FMapWidth * FMapHeight * SizeOf(boolean), 1);
  end;
end;

procedure TBackgroundSprite.Assign(Source: TPersistent);
begin
  if Source is TBackgroundSprite then begin
    FImage := TBackgroundSprite(Source).FImage;
    FMapWidth := TBackgroundSprite(Source).FMapWidth;
    FMapHeight := TBackgroundSprite(Source).FMapHeight;
    FTile := TBackgroundSprite(Source).FTile;
  end;
  inherited;
end;

{  TSpriteEngine  }

constructor TSpriteEngine.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  FDeadList := TList.Create;
  // group handling
{$IFDEF Ver4Up}
  fCurrentSelected := Tlist.create;
  GroupCount := 10;
{$ENDIF}
end;

destructor TSpriteEngine.Destroy;
begin
  // cleanup Group handling
{$IFDEF Ver4Up}
  ClearCurrent;
  GroupCount := 0;
{$ENDIF}
  FDeadList.Free;
  inherited Destroy;
{$IFDEF Ver4Up}
  fCurrentSelected.free;
{$ENDIF}
end;

procedure TSpriteEngine.Collisions;
var
  index: integer;
begin
  for index := 0 to Count - 1 do
    Items[index].Collision;
end;
{Collisions}
{$IFDEF Ver4Up}

procedure TSpriteEngine.GroupSelect(const Area: TRect; Add: Boolean = false);
begin
  GroupSelect(Area, [Tsprite], Add);
end; {GroupSelect}

procedure TSpriteEngine.GroupSelect(const Area: TRect; Filter: array of TSpriteClass; Add: Boolean = false);
var
  index, index2: integer;
  sprite: TSprite;
begin
  Assert(length(Filter) <> 0, 'Filter = []');
  if not Add then
    ClearCurrent;
  if length(Filter) = 1 then
  begin
    for Index := 0 to Count - 1 do
    begin
      sprite := Items[Index];
      if (sprite is Filter[0]) and
        OverlapRect(sprite.GetBoundsRect, Area) then
        sprite.Selected := true;
    end
  end
  else
  begin
    for Index := 0 to Count - 1 do
    begin
      sprite := Items[index];
      for index2 := 0 to high(Filter) do
        if (sprite is Filter[index2]) and
          OverlapRect(sprite.GetBoundsRect, Area) then
        begin
          sprite.Selected := true;
          break;
        end;
    end
  end;
  fObjectsSelected := CurrentSelected.count <> 0;
end; {GroupSelect}

function TSpriteEngine.Select(Point: TPoint; Filter: array of TSpriteClass; Add: Boolean = false): Tsprite;
var
  index, index2: integer;
begin
  Assert(length(Filter) <> 0, 'Filter = []');
  if not Add then
    ClearCurrent;
  // By searching the Drawlist in reverse
  // we select the highest sprite if the sprit is under the point
  assert(FDrawList <> nil, 'FDrawList = nil');
  if length(Filter) = 1 then
  begin
    for Index := FDrawList.Count - 1 downto 0 do
    begin
      result := FDrawList[Index];
      if (result is Filter[0]) and PointInRect(Point, result.GetBoundsRect) then
      begin
        result.Selected := true;
        fObjectsSelected := CurrentSelected.count <> 0;
        exit;
      end;
    end
  end
  else
  begin
    for Index := FDrawList.Count - 1 downto 0 do
    begin
      result := FDrawList[index];
      for index2 := 0 to high(Filter) do
        if (result is Filter[index2]) and PointInRect(Point, result.GetBoundsRect) then
        begin
          result.Selected := true;
          fObjectsSelected := CurrentSelected.count <> 0;
          exit;
        end;
    end
  end;
  result := nil;
end; {Select}

function TSpriteEngine.Select(Point: TPoint; Add: Boolean = false): TSprite;
begin
  result := Select(Point, [Tsprite], Add);
end; {Select}

procedure TSpriteEngine.ClearCurrent;
begin
  while CurrentSelected.count <> 0 do
    TSprite(CurrentSelected[CurrentSelected.count - 1]).Selected := false;
  fObjectsSelected := false;
end; {ClearCurrent}

procedure TSpriteEngine.ClearGroup(GroupNumber: integer);
var
  index: integer;
  Group: Tlist;
begin
  Group := Groups[GroupNumber];
  if Group <> nil then
    for index := 0 to Group.count - 1 do
      TSprite(Group[index]).Selected := false;
end; {ClearGroup}

procedure TSpriteEngine.CurrentToGroup(GroupNumber: integer; Add: Boolean = false);
var
  Group: Tlist;
  index: integer;
begin
  Group := Groups[GroupNumber];
  if Group = nil then
    exit;
  if not Add then
    ClearGroup(GroupNumber);
  for index := 0 to Group.count - 1 do
    TSprite(Group[index]).GroupNumber := GroupNumber;
end; {CurrentToGroup}

procedure TSpriteEngine.GroupToCurrent(GroupNumber: integer; Add: Boolean = false);
var
  Group: Tlist;
  index: integer;
begin
  if not Add then
    ClearCurrent;
  Group := Groups[GroupNumber];
  if Group <> nil then
    for index := 0 to Group.count - 1 do
      TSprite(Group[index]).Selected := true;
end; {GroupToCurrent}

function TSpriteEngine.GetGroup(Index: integer): Tlist;
begin
  if (index >= 0) or (index < fGroupCount) then
    result := fGroups[index]
  else
    result := nil;
end; {GetGroup}

procedure TSpriteEngine.SetGroupCount(AGroupCount: integer);
var
  index: integer;
begin
  if (AGroupCount <> FGroupCount) and (AGroupCount >= 0) then
  begin
    if FGroupCount > AGroupCount then
    begin // remove groups
      for index := AGroupCount to FGroupCount - 1 do
      begin
        ClearGroup(index);
        FGroups[index].Free;
      end;
      SetLength(FGroups, AGroupCount);
    end
    else
    begin // add groups
      SetLength(FGroups, AGroupCount);
      for index := FGroupCount to AGroupCount - 1 do
        FGroups[index] := Tlist.Create;
    end;
    FGroupCount := Length(FGroups);
  end;
end; {SetGroupCount}
{$ENDIF}

procedure TSpriteEngine.Dead;
begin
  while FDeadList.Count > 0 do
    TSprite(FDeadList[FDeadList.Count - 1]).Free;
end;

procedure TSpriteEngine.Draw;
begin
  FDrawCount := 0;
  inherited Draw;
end;

procedure TSpriteEngine.SetSurface(Value: TDirectDrawSurface);
begin
  FSurface := Value;
  if FSurface <> nil then
  begin
    FSurfaceRect := Surface.ClientRect;
    Width := FSurfaceRect.Right - FSurfaceRect.Left;
    Height := FSurfaceRect.Bottom - FSurfaceRect.Top;
  end;
end;

{  TCustomDXSpriteEngine  }

constructor TCustomDXSpriteEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEngine := TSpriteEngine.Create(nil);
  FItems := TSpriteCollection.Create(Self);
  FItems.FOwner := Self;
  FItems.FOwnerItem := FEngine;
  FItems.Initialize(FEngine);
end;

destructor TCustomDXSpriteEngine.Destroy;
begin
  FEngine.Free;
  inherited Destroy;
end;

procedure TCustomDXSpriteEngine.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (DXDraw = AComponent) then
    DXDraw := nil;
end;

procedure TCustomDXSpriteEngine.Dead;
begin
  FEngine.Dead;
end;

procedure TCustomDXSpriteEngine.Draw;
begin
  if (FDXDraw <> nil) and (FDXDraw.Initialized) then
    FEngine.Draw;
end;

procedure TCustomDXSpriteEngine.Move(MoveCount: integer);
begin
  FEngine.Move(MoveCount);
end;

procedure TCustomDXSpriteEngine.DXDrawNotifyEvent(Sender: TCustomDXDraw;
  NotifyType: TDXDrawNotifyType);
begin
  case NotifyType of
    dxntDestroying: DXDraw := nil;
    dxntInitialize: FEngine.Surface := Sender.Surface;
    dxntFinalize: FEngine.Surface := nil;
  end;
end;

procedure TCustomDXSpriteEngine.SetDXDraw(Value: TCustomDXDraw);
begin
  if FDXDraw <> nil then
    FDXDraw.UnRegisterNotifyEvent(DXDrawNotifyEvent);

  FDXDraw := Value;

  if FDXDraw <> nil then
    FDXDraw.RegisterNotifyEvent(DXDrawNotifyEvent);
end;

procedure TCustomDXSpriteEngine.SetItems(const Value: TSpriteCollection);
begin
  FItems.Assign(Value);
end;

{ TSpriteCollectionItem }

function TSpriteCollectionItem.GetSpriteCollection: TSpriteCollection;
begin
  Result := Collection as TSpriteCollection;
end;

procedure TSpriteCollectionItem.SetSprite(const Value: TSprite);
begin
  FSprite.Assign(Value);
end;

constructor TSpriteCollectionItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FOwner := Collection;
  FOwnerItem := (Collection as TSpriteCollection).FOwnerItem;
  FSpriteType := stSprite;
  FSprite := TSprite.Create(FOwnerItem);
end;

procedure TSpriteCollectionItem.Assign(Source: TPersistent);
begin
  if Source is TSpriteCollectionItem then begin
    Finalize;
    FSprite.Assign(TSpriteCollectionItem(Source).FSprite);
    inherited Assign(Source);
    Initialize;
  end
  else
    inherited;

end;

procedure TSpriteCollectionItem.Initialize;
begin

end;

destructor TSpriteCollectionItem.Destroy;
begin
  FSprite.Destroy;
  inherited;
end;

procedure TSpriteCollectionItem.Finalize;
begin

end;

procedure TSpriteCollectionItem.SetOnCollision(
  const Value: TCollisionEvent);
begin
  FSprite.FOnCollision := Value;
end;

procedure TSpriteCollectionItem.SetOnDraw(const Value: TDrawEvent);
begin
  FSprite.FOnDraw := Value;
end;

procedure TSpriteCollectionItem.SetOnMove(const Value: TMoveEvent);
begin
  FSprite.FOnMove := Value
end;

function TSpriteCollectionItem.GetDisplayName: string;
begin
  Result := inherited GetDisplayName
end;

procedure TSpriteCollectionItem.SetDisplayName(const Value: string);
begin
  if (Value <> '') and (AnsiCompareText(Value, GetDisplayName) <> 0) and
    (Collection is TSpriteCollection) and (TSpriteCollection(Collection).IndexOf(Value) >= 0) then
    raise Exception.Create(Format(SSpriteDuplicateName, [Value]));
  inherited SetDisplayName(Value);
end;

function TSpriteCollectionItem.GetSpriteType: TSpriteType;
begin
  Result := FSpriteType;
end;

procedure TSpriteCollectionItem.SetSpriteType(const Value: TSpriteType);
var
  tmpSprite: TSprite;
begin
  if Value <> FSpriteType then begin
    case Value of
      stSprite: tmpSprite := TSprite.Create(TSpriteEngine(FOwnerItem));
      stImageSprite: TImageSprite(tmpSprite) := TImageSprite.Create(TSpriteEngine(FOwnerItem));
      stImageSpriteEx: TImageSpriteEx(tmpSprite) := TImageSpriteEx.Create(TSpriteEngine(FOwnerItem));
      stBackgroundSprite: TBackgroundSprite(tmpSprite) := TBackgroundSprite.Create(TSpriteEngine(FOwnerItem));
    else
      tmpSprite := nil
    end;
    if Assigned(FSprite) then begin
      tmpSprite.Assign(FSprite);
      tmpSprite.FOnDraw := FSprite.FOnDraw;
      tmpSprite.FOnMove := FSprite.FOnMove;
      tmpSprite.FOnCollision := FSprite.FOnCollision;
      FSprite.Free;
    end;
    FSprite := tmpSprite;
    FSpriteType := Value;
  end;
end;

function TSpriteCollectionItem.GetOnCollision: TCollisionEvent;
begin
  Result := FSprite.FOnCollision
end;

function TSpriteCollectionItem.GetOnDraw: TDrawEvent;
begin
  Result := FSprite.FOnDraw
end;

function TSpriteCollectionItem.GetOnMove: TMoveEvent;
begin
  Result := FSprite.FOnMove
end;

function TSpriteCollectionItem.GetOnGetImage: TGetImage;
begin
  Result := FSprite.FOnGetImage;
end;

procedure TSpriteCollectionItem.SetOnGetImage(const Value: TGetImage);
begin
  FSprite.FOnGetImage := Value;
end;

{ TSpriteCollection }

function TSpriteCollection.Initialized: Boolean;
begin
  Result := True
end;

constructor TSpriteCollection.Create(AOwner: TPersistent);
begin
  inherited Create(TSpriteCollectionItem);
  FOwner := AOwner;
end;

function TSpriteCollection.GetItem(Index: Integer): TSpriteCollectionItem;
begin
  Result := TSpriteCollectionItem(inherited Items[Index]);
end;

function TSpriteCollection.Initialize(DXSpriteEngine: TSpriteEngine): Boolean;
begin
  Result := True;
  try
    if AsSigned(FOnInitialize) then
      FOnInitialize(DXSpriteEngine);
  except
    Result := False;
  end
end;

function TSpriteCollection.Find(const Name: string): TSpriteCollectionItem;
var
  i: Integer;
begin
  i := IndexOf(Name);
  if i = -1 then
    raise ESpriteCollectionError.CreateFmt(SSpriteNotFound, [Name]);
  Result := Items[i];
end;

procedure TSpriteCollection.Finalize;
begin
  if AsSigned(FOnFinalize) then
    FOnFinalize(FOwnerItem);
end;

function TSpriteCollection.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSpriteCollection.Add: TSpriteCollectionItem;
begin
  Result := TSpriteCollectionItem(inherited Add);
  Result.FOwner := FOwner;
  Result.FOwnerItem := FOwnerItem;
end;

end.