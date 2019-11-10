unit DXClass;

interface

{$INCLUDE DelphiXcfg.inc}

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, MMSystem,
{$IfDef StandardDX}
  DirectDraw, DirectSound,
  {$IfDef DX81}
  D3DX8, DirectInput8;
  {$Else}
  Direct3D, DirectInput;
  {$EndIf}
{$Else}
  DirectX;
{$EndIf}

type

  {  EDirectDrawError  }

  EDirectXError = class(Exception);

  {  TDirectX  }

  TDirectX = class(TPersistent)
  private
    procedure SetDXResult(Value: HRESULT);
  protected
    FDXResult: HRESULT;
    procedure Check; virtual;
  public
    property DXResult: HRESULT read FDXResult write SetDXResult;
  end;

  {  TDirectXDriver  }

  TDirectXDriver = class(TCollectionItem)
  private
    FGUID: PGUID;
    FGUID2: TGUID;
    FDescription: string;
    FDriverName: string;
    procedure SetGUID(Value: PGUID);
  public
    property GUID: PGUID read FGUID write SetGUID;
    property Description: string read FDescription write FDescription;
    property DriverName: string read FDriverName write FDriverName;
  end;

  {  TDirectXDrivers  }

  TDirectXDrivers = class(TCollection)
  private
    function GetDriver(Index: Integer): TDirectXDriver;
  public
    constructor Create;
    property Drivers[Index: Integer]: TDirectXDriver read GetDriver; default;
  end;

  {  TDXForm  }

  TDXForm = class(TForm)
  private
    FStoreWindow: Boolean;
    FWindowPlacement: TWindowPlacement;
    procedure WMSYSCommand(var Msg: TWMSYSCommand); message WM_SYSCOMMAND;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOnwer: TComponent); override;
    destructor Destroy; override;
    procedure RestoreWindow;
    procedure StoreWindow;
  end;

  {  TCustomDXTimer  }

  TDXTimerEvent = procedure(Sender: TObject; LagCount: Integer) of object;

  TCustomDXTimer = class(TComponent)
  private
    FActiveOnly: Boolean;
    FEnabled: Boolean;
    FFrameRate: Integer;
    FInitialized: Boolean;
    FInterval: Cardinal;
    FInterval2: Cardinal;
    FNowFrameRate: Integer;
    FOldTime: DWORD;
    FOldTime2: DWORD;
    FOnActivate: TNotifyEvent;
    FOnDeactivate: TNotifyEvent;
    FOnTimer: TDXTimerEvent;
    procedure AppIdle(Sender: TObject; var Done: Boolean);
    function AppProc(var Message: TMessage): Boolean;
    procedure Finalize;
    procedure Initialize;
    procedure Resume;
    procedure SetActiveOnly(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: Cardinal);
    procedure Suspend;
  protected
    procedure DoActivate; virtual;
    procedure DoDeactivate; virtual;
    procedure DoTimer(LagCount: Integer); virtual;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ActiveOnly: Boolean read FActiveOnly write SetActiveOnly;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property FrameRate: Integer read FFrameRate;
    property Interval: Cardinal read FInterval write SetInterval;
    property OnActivate: TNotifyEvent read FOnActivate write FOnActivate;
    property OnDeactivate: TNotifyEvent read FOnDeactivate write FOnDeactivate;
    property OnTimer: TDXTimerEvent read FOnTimer write FOnTimer;
  end;

  {  TDXTimer  }

  TDXTimer = class(TCustomDXTimer)
  published
    property ActiveOnly;
    property Enabled;
    property Interval;
    property OnActivate;
    property OnDeactivate;
    property OnTimer;
  end;

  {  TControlSubClass  }

  TControlSubClassProc = procedure(var Message: TMessage; DefWindowProc: TWndMethod) of object;

  TControlSubClass = class
  private
    FControl: TControl;
    FDefWindowProc: TWndMethod;
    FWindowProc: TControlSubClassProc;
    procedure WndProc(var Message: TMessage);
  public
    constructor Create(Control: TControl; WindowProc: TControlSubClassProc);
    destructor Destroy; override;
  end;

  {  THashCollectionItem  }

  THashCollectionItem = class(TCollectionItem)
  private
    FHashCode: Integer;
    FIndex: Integer;
    FName: string;
    FLeft: THashCollectionItem;
    FRight: THashCollectionItem;
    procedure SetName(const Value: string);
    procedure AddHash;
    procedure DeleteHash;
  protected
    function GetDisplayName: string; override;
    procedure SetIndex(Value: Integer); override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Index: Integer read FIndex write SetIndex;
  published
    property Name: string read FName write SetName;
  end;

  {  THashCollection  }

  THashCollection = class(TCollection)
  private
    FHash: array[0..255] of THashCollectionItem;
  public
    function IndexOf(const Name: string): Integer;
  end;

function Max(Val1, Val2: Integer): Integer;
function Min(Val1, Val2: Integer): Integer;

function Cos256(i: Integer): Double;
function Sin256(i: Integer): Double;

function PointInRect(const Point: TPoint; const Rect: TRect): Boolean;
function RectInRect(const Rect1, Rect2: TRect): Boolean;
function OverlapRect(const Rect1, Rect2: TRect): Boolean;

function WideRect(ALeft, ATop, AWidth, AHeight: Integer): TRect;

{ Transformations routines}

const
  L_Curve = 0;//The left curve
  R_Curve = 1;//The right curve

  C_Add = 0;//Increase (BTC)
  C_Dec = 1;//Decrease (ETC)

Type
  TDblPoint = Record
    X,Y: Double;
  end;

  //Transformation matrix
  T2DRowCol = Array[1..3] of Array[1..3] of Double;
  T2DVector = Array[1..3] of Double;
  //Distance between 2 points
  function Get2PointRange(a,b: TDblPoint):Double;
  //From vector angular calculation
  function Get256(dX,dY: Double):Double;
  //The angular calculation of the A from B
  function GetARadFromB(A,B: TDblPoint):Double;

  //It calculates the TDblPoint
  function DblPoint(a,b:Double):TDblPoint;
  //It converts the TDboPoint to the TPoint
  function TruncDblPoint(DblPos: TDblPoint): TPoint;

  function GetPointFromRangeAndAngle(SP: TDblPoint; Range,Angle: Double): TDblPoint;

  function Ini2DRowCol: T2DRowCol;
  function Trans2DRowCol(x,y:double):T2DRowCol;
  function Scale2DRowCol(x,y:double):T2DRowCol;
  function Rotate2DRowCol(Theta:double):T2DRowCol;
  function RotateIntoX2DRowCol(x,y: double):T2DRowCol;
  function Multiply2DRowCol(A,B:T2DRowCol):T2DRowCol;
  function ScaleAt2DRowCol(x,y,Sx,Sy:double):T2DRowCol;
  function ReflectAcross2DRowCol(x,y,dx,dy:Double): T2DRowCol;
  function Apply2DVector(V:T2DVector; M:T2DRowCol): T2DVector;
  function RotateAround2DRowCol(x,y,Theta:Double): T2DRowCol;

  //Collision decision
  function PointInCircle(PPos,CPos: TPoint; R: integer): Boolean;
  function CircleInCircle(C1Pos,C2Pos: TPoint; R1,R2:Integer): Boolean;
  function SegmentInCircle(SPos,EPos,CPos: TPoint; R: Integer): Boolean;

  //If A is closer than B from starting point S, the True is  returned.
  function CheckNearAThanB(S,A,B: TDblPoint): Boolean;

  //The Angle of 256 period is returned
  function Angle256(Angle: Single): Single;

{ Support functions }

procedure ReleaseCom(out Com);
function DXLoadLibrary(const FileName, FuncName: string): TFarProc;

implementation

uses DXConsts;

function Max(Val1, Val2: Integer): Integer;
begin
  if Val1>=Val2 then Result := Val1 else Result := Val2;
end;

function Min(Val1, Val2: Integer): Integer;
begin
  if Val1<=Val2 then Result := Val1 else Result := Val2;
end;

function PointInRect(const Point: TPoint; const Rect: TRect): Boolean;
begin
  Result := (Point.X >= Rect.Left) and
            (Point.X <= Rect.Right) and
            (Point.Y >= Rect.Top) and
            (Point.Y <= Rect.Bottom);
end;

function RectInRect(const Rect1, Rect2: TRect): Boolean;
begin
  Result := (Rect1.Left >= Rect2.Left) and
            (Rect1.Right <= Rect2.Right) and
            (Rect1.Top >= Rect2.Top) and
            (Rect1.Bottom <= Rect2.Bottom);
end;

function OverlapRect(const Rect1, Rect2: TRect): Boolean;
begin
  Result := (Rect1.Left < Rect2.Right) and
            (Rect1.Right > Rect2.Left) and
            (Rect1.Top < Rect2.Bottom) and
            (Rect1.Bottom > Rect2.Top);
end;

function WideRect(ALeft, ATop, AWidth, AHeight: Integer): TRect;
begin
  with Result do
  begin
    Left := ALeft;
    Top := ATop;
    Right := ALeft+AWidth;
    Bottom := ATop+AHeight;
  end;
end;

var
  CosinTable: array[0..255] of Double;

procedure InitCosinTable;
var
  i: Integer;
begin
  for i:=0 to 255 do
    CosinTable[i] := Cos((i/256)*2*PI);
end;

function Cos256(i: Integer): Double;
begin
  Result := CosinTable[i and 255];
end;

function Sin256(i: Integer): Double;
begin
  Result := CosinTable[(i+192) and 255];
end;

procedure ReleaseCom(out Com);
begin
end;

var
  LibList: TStringList;

function DXLoadLibrary(const FileName, FuncName: string): Pointer;
var
  i: Integer;
  h: THandle;
begin
  if LibList=nil then
    LibList := TStringList.Create;

  i := LibList.IndexOf(AnsiLowerCase(FileName));
  if i=-1 then
  begin
    {  DLL is loaded.  }
    h := LoadLibrary(PChar(FileName));
    if h=0 then
      raise Exception.CreateFmt(SDLLNotLoaded, [FileName]);
    LibList.AddObject(AnsiLowerCase(FileName), Pointer(h));
  end else
  begin
    {  DLL has already been loaded.  }
    h := THandle(LibList.Objects[i]);
  end;

  Result := GetProcAddress(h, PChar(FuncName));
  if Result=nil then
    raise Exception.CreateFmt(SDLLNotLoaded, [FileName]);
end;

procedure FreeLibList;
var
  i: Integer;
begin
  if LibList<>nil then
  begin
    for i:=0 to LibList.Count-1 do
      FreeLibrary(THandle(LibList.Objects[i]));
    LibList.Free;
  end;
end;

{  TDirectX  }

procedure TDirectX.Check;
begin
end;

procedure TDirectX.SetDXResult(Value: HRESULT);
begin
  FDXResult := Value;
  if FDXResult<>0 then Check;
end;

{  TDirectXDriver  }

procedure TDirectXDriver.SetGUID(Value: PGUID);
begin
  if not IsBadHugeReadPtr(Value, SizeOf(TGUID)) then
  begin
    FGUID2 := Value^;
    FGUID := @FGUID2;
  end else
    FGUID := Value;
end;

{  TDirectXDrivers  }

constructor TDirectXDrivers.Create;
begin
  inherited Create(TDirectXDriver);
end;

function TDirectXDrivers.GetDriver(Index: Integer): TDirectXDriver;
begin
  Result := (inherited Items[Index]) as TDirectXDriver;
end;

{  TDXForm  }

var
  SetAppExStyleCount: Integer;

constructor TDXForm.Create(AOnwer: TComponent);
var
  ExStyle: Integer;
begin
  inherited Create(AOnwer);
  Inc(SetAppExStyleCount);
  ExStyle := GetWindowLong(Application.Handle, GWL_EXSTYLE);
  ExStyle := ExStyle or WS_EX_TOOLWINDOW;
  SetWindowLong(Application.Handle, GWL_EXSTYLE, ExStyle);
end;

destructor TDXForm.Destroy;
var
  ExStyle: Integer;
begin
  Dec(SetAppExStyleCount);
  if SetAppExStyleCount=0 then
  begin
    ExStyle := GetWindowLong(Application.Handle, GWL_EXSTYLE);
    ExStyle := ExStyle and (not WS_EX_TOOLWINDOW);
    SetWindowLong(Application.Handle, GWL_EXSTYLE, ExStyle);
  end;
  inherited Destroy;
end;

procedure TDXForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;

procedure TDXForm.RestoreWindow;
begin
  if FStoreWindow then
  begin
    SetWindowPlacement(Handle, @FWindowPlacement);
    FStoreWindow := False;
  end;
end;

procedure TDXForm.StoreWindow;
begin
  FWindowPlacement.Length := SizeOf(FWindowPlacement);
  FStoreWindow := GetWindowPlacement(Handle, @FWindowPlacement);
end;

procedure TDXForm.WMSYSCommand(var Msg: TWMSYSCommand);
begin
  if Msg.CmdType = SC_MINIMIZE then
  begin
    DefaultHandler(Msg);
    WindowState := wsMinimized;
  end else
    inherited;
end;

{  TCustomDXTimer  }

constructor TCustomDXTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FActiveOnly := True;
  FEnabled := True;
  Interval := 1000;
  Application.HookMainWindow(AppProc);
end;

destructor TCustomDXTimer.Destroy;
begin
  Finalize;
  Application.UnHookMainWindow(AppProc);
  inherited Destroy;
end;

procedure TCustomDXTimer.AppIdle(Sender: TObject; var Done: Boolean);
var
  t, t2: DWORD;
  LagCount, i: Integer;
begin
  Done := False;

  t := TimeGetTime;
  t2 := t-FOldTime;
  if t2>=FInterval then
  begin
    FOldTime := t;

    LagCount := t2 div FInterval2;
    if LagCount<1 then LagCount := 1;

    Inc(FNowFrameRate);

    i := Max(t-FOldTime2, 1);
    if i>=1000 then
    begin
      FFrameRate := Round(FNowFrameRate*1000/i);
      FNowFrameRate := 0;
      FOldTime2 := t;
    end;

    DoTimer(LagCount);
  end;
end;

function TCustomDXTimer.AppProc(var Message: TMessage): Boolean;
begin
  Result := False;
  case Message.Msg of
    CM_ACTIVATE:
        begin
          DoActivate;
          if FInitialized and FActiveOnly then Resume;
        end;
    CM_DEACTIVATE:
        begin
          DoDeactivate;
          if FInitialized and FActiveOnly then Suspend;
        end;
  end;
end;

procedure TCustomDXTimer.DoActivate;
begin
  if Assigned(FOnActivate) then FOnActivate(Self);
end;

procedure TCustomDXTimer.DoDeactivate;
begin
  if Assigned(FOnDeactivate) then FOnDeactivate(Self);
end;

procedure TCustomDXTimer.DoTimer(LagCount: Integer);
begin
  if Assigned(FOnTimer) then FOnTimer(Self, LagCount);
end;

procedure TCustomDXTimer.Finalize;
begin
  if FInitialized then
  begin
    Suspend;
    FInitialized := False;
  end;
end;

procedure TCustomDXTimer.Initialize;
begin
  Finalize;

  if ActiveOnly then
  begin
    if Application.Active then
      Resume;
  end else
    Resume;
  FInitialized := True;
end;

procedure TCustomDXTimer.Loaded;
begin
  inherited Loaded;
  if (not (csDesigning in ComponentState)) and FEnabled then
    Initialize;
end;

procedure TCustomDXTimer.Resume;
begin
  FOldTime := TimeGetTime;
  FOldTime2 := TimeGetTime;
  Application.OnIdle := AppIdle;
end;

procedure TCustomDXTimer.SetActiveOnly(Value: Boolean);
begin
  if FActiveOnly<>Value then
  begin
    FActiveOnly := Value;

    if Application.Active and FActiveOnly then
      if FInitialized and FActiveOnly then Suspend;
  end;
end;

procedure TCustomDXTimer.SetEnabled(Value: Boolean);
begin
  if FEnabled<>Value then
  begin
    FEnabled := Value;
    if ComponentState*[csReading, csLoading]=[] then
      if FEnabled then Initialize else Finalize;
  end;
end;

procedure TCustomDXTimer.SetInterval(Value: Cardinal);
begin
  if FInterval<>Value then
  begin
    FInterval := Max(Value, 0);
    FInterval2 := Max(Value, 1);
  end;
end;

procedure TCustomDXTimer.Suspend;
begin
  Application.OnIdle := nil;
end;

{  TControlSubClass  }

constructor TControlSubClass.Create(Control: TControl;
  WindowProc: TControlSubClassProc);
begin
  inherited Create;
  FControl := Control;
  FDefWindowProc := FControl.WindowProc;
  FControl.WindowProc := WndProc;
  FWindowProc := WindowProc;
end;

destructor TControlSubClass.Destroy;
begin
  FControl.WindowProc := FDefWindowProc;
  inherited Destroy;
end;

procedure TControlSubClass.WndProc(var Message: TMessage);
begin
  FWindowProc(Message, FDefWindowProc);
end;

{  THashCollectionItem  }

function MakeHashCode(const Str: string): Integer;
var
  s: string;
begin
  s := AnsiLowerCase(Str);
  Result := Length(s)*16;
  if Length(s)>=2 then
    Result := Result + (Ord(s[1]) + Ord(s[Length(s)-1]));
  Result := Result and 255;
end;
               
constructor THashCollectionItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FIndex := inherited Index;
  AddHash;
end;

destructor THashCollectionItem.Destroy;
var
  i: Integer;
begin
  for i:=FIndex+1 to Collection.Count-1 do
    Dec(THashCollectionItem(Collection.Items[i]).FIndex);
  DeleteHash;
  inherited Destroy;
end;

procedure THashCollectionItem.Assign(Source: TPersistent);
begin
  if Source is THashCollectionItem then
  begin
    Name := THashCollectionItem(Source).Name;
  end else
    inherited Assign(Source);
end;

procedure THashCollectionItem.AddHash;
var
  Item: THashCollectionItem;
begin
  FHashCode := MakeHashCode(FName);

  Item := THashCollection(Collection).FHash[FHashCode];
  if Item<>nil then
  begin
    Item.FLeft := Self;
    Self.FRight := Item;
  end;

  THashCollection(Collection).FHash[FHashCode] := Self;
end;

procedure THashCollectionItem.DeleteHash;
begin
  if FLeft<>nil then
  begin
    FLeft.FRight := FRight;
    if FRight<>nil then
      FRight.FLeft := FLeft;
  end else
  begin
    if FHashCode<>-1 then
    begin
      THashCollection(Collection).FHash[FHashCode] := FRight;
      if FRight<>nil then
        FRight.FLeft := nil;
    end;
  end;
  FLeft := nil;
  FRight := nil;
end;

function THashCollectionItem.GetDisplayName: string;
begin
  Result := Name;
  if Result='' then Result := inherited GetDisplayName;
end;

procedure THashCollectionItem.SetIndex(Value: Integer);
begin
  if FIndex<>Value then
  begin
    FIndex := Value;
    inherited SetIndex(Value);
  end;
end;

procedure THashCollectionItem.SetName(const Value: string);
begin
  if FName<>Value then
  begin
    FName := Value;
    DeleteHash;
    AddHash;
  end;
end;

{  THashCollection  }

function THashCollection.IndexOf(const Name: string): Integer;
var
  Item: THashCollectionItem;
begin
  Item := FHash[MakeHashCode(Name)];
  while Item<>nil do
  begin
    if AnsiCompareText(Item.Name, Name)=0 then
    begin
      Result := Item.FIndex;
      Exit;
    end;
    Item := Item.FRight;
  end;
  Result := -1;
end;

{ Transformations routines }
{ Authorisation: Mr. Takanori Kawasaki}

//Distance between 2 points is calculated
function Get2PointRange(a,b: TDblPoint):Double;
var
  x,y: Double;
begin
  x := a.X - b.X;
  y := a.Y - b.Y;
  Result := Sqrt(x*x+y*y);
end;

//Direction angle in the coordinate A which was seen from  coordinate B is calculated
function GetARadFromB(A,B: TDblPoint):Double;
var
  dX,dY: Double;
begin
  dX := A.X - B.X;
  dY := A.Y - B.Y;
  Result := Get256(dX,dY);
end;

//Direction angle is returned with 0 - 255.
function Get256(dX,dY:Double):Double;
begin
  Result := 0;
  if dX > 0 then
  begin//0-63
    if dY > 0 then Result := ArcTan(dY / dX)          // 0 < Res < 90
    else//0
    if dY = 0 then Result := 0                        // 0
    else//192-255
    if dY < 0 then Result := 2*Pi + ArcTan(dY / dX)   // 270 < Res < 360
  end else
  if dX = 0 then
  begin//64
    if dY > 0 then Result := 1 / 2 * Pi               // 90
    else//0
    if dY = 0 then Result := 0                        // 0
    else//192
    if dY < 0 then Result := 3 / 2 * Pi               // 270
  end else
  if dX < 0 then
  begin//64-127
    if dY > 0 then Result := Pi + ArcTan(dY / dX)     // 90 < Res < 180
    else//128
    if dY = 0 then Result := Pi                       // 180
    else//128-191
    if dY < 0 then Result := Pi + ArcTan(dY / dX)     // 180 < Res < 270
  end;
  Result := 256 * Result / (2*Pi);
end;

//From the coordinate SP the Range it calculates the point  which leaves with the angular Angle
function GetPointFromRangeAndAngle(SP: TDblPoint; Range,Angle: Double): TDblPoint;
begin
  Result.X := SP.X + Range * Cos(Angle);
  Result.Y := SP.Y + Range * Sin(Angle);
end;

//* As for coordinate transformation coordinate for mathematics is used
//Identity matrix for the 2d is returned.
function Ini2DRowCol: T2DRowCol;
var
  i,ii:integer;
begin
  for i := 1 to 3 do
    for ii := 1 to 3 do
      if i = ii then Result[i,ii] := 1 else Result[i,ii] := 0;
end;

//Transformation matrix of the portable quantity
//where the one  for 2d is appointed is returned.
function Trans2DRowCol(x,y:double):T2DRowCol;
begin
  Result := Ini2DRowCol;
  Result[3,1] := x;
  Result[3,2] := y;
end;

//Conversion coordinate of the expansion and contraction
//quantity where the one for 2d is appointed is returned.
function Scale2DRowCol(x,y:double):T2DRowCol;
begin
  Result := Ini2DRowCol;
  Result[1,1] := x;
  Result[2,2] := y;
end;

//Coordinate transformation of the rotary quantity
//where the  one for 2d is appointed is returned.
function Rotate2DRowCol(Theta:double):T2DRowCol;
begin
  Result := Ini2DRowCol;
  Result[1,1] := Cos256(Trunc(Theta));
  Result[1,2] := Sin256(Trunc(Theta));
  Result[2,1] := -1 * Result[1,2];
  Result[2,2] := Result[1,1];
end;

//You apply two conversion coordinates and adjust.
function Multiply2DRowCol(A,B:T2DRowCol):T2DRowCol;
begin
  Result[1,1] := A[1,1] * B[1,1] + A[1,2] * B[2,1];
  Result[1,2] := A[1,1] * B[1,2] + A[1,2] * B[2,2];
  Result[1,3] := 0;
  Result[2,1] := A[2,1] * B[1,1] + A[2,2] * B[2,1];
  Result[2,2] := A[2,1] * B[1,2] + A[2,2] * B[2,2];
  Result[2,3] := 0;
  Result[3,1] := A[3,1] * B[1,1] + A[3,2] * B[2,1] + B[3,1];
  Result[3,2] := A[3,1] * B[1,2] + A[3,2] * B[2,2] + B[3,2];
  Result[3,3] := 1;
end;

//Until coordinate (the X and the Y) comes on the X axis,
//the  conversion coordinate which turns the position
//of the point is  returned.
function RotateIntoX2DRowCol(x,y: double):T2DRowCol;
var
  d: double;
begin
  Result := Ini2DRowCol;
  d := sqrt(x*x+y*y);
  Result[1,1] := x / d;
  Result[1,2] := y / d;
  Result[2,1] := -1 * Result[1,2];
  Result[2,2] := Result[1,1];
end;

//Coordinate (the X and the Y) as a center, the conversion
//coordinate which does the scaling of the magnification ratio
//which is  appointed with the Sx and the Sy is returned.
function ScaleAt2DRowCol(x,y,Sx,Sy:double):T2DRowCol;
var
  T,S,TInv,M:T2DRowCol;
begin
  T := Trans2DRowCol(-x,-y);
  TInv := Trans2DRowCol(x,y);
  S := Scale2DRowCol(Sx,Sy);
  M := Multiply2DRowCol(T,S);
  Result := Multiply2DRowCol(M,T);
end;

//Coordinate (the X and the Y) it passes, comes hard and
//(DX and the dy) with the direction which is shown it
//returns the  transformation matrix which does the reflected
//image conversion which  centers the line which faces.
function ReflectAcross2DRowCol(x,y,dx,dy:Double): T2DRowCol;
var
  T,R,S,RInv,TInv,M1,M2,M3: T2DRowCol;
begin
  T := Trans2DRowCol(-x,-y);
  TInv := Trans2DRowCol(x,y);
  R := RotateIntoX2DRowCol(dx,dy);
  RInv := RotateIntoX2DRowCol(dx,-dy);
  S := Scale2DRowCol(1,-1);
  M1 := Multiply2DRowCol(T,R);
  M2 := Multiply2DRowCol(S,RInv);
  M3 := Multiply2DRowCol(M1,M2);
  Result := Multiply2DRowCol(M3,TInv);
end;

//Coordinate focusing on (the X and the Y) the transformation
//matrix which turns the position of the point with angle Theta is  returned.
function RotateAround2DRowCol(x,y,Theta:Double): T2DRowCol;
var
  T,R,TInv,M: T2DRowCol;
begin
  T := Trans2DRowCol(-x,-y);
  TInv := Trans2DRowCol(x,y);
  R := Rotate2DRowCol(Theta);
  M := Multiply2DRowCol(T,R);
  Result := Multiply2DRowCol(M,TInv);
end;

//Transformation matrix is applied to the point.
function Apply2DVector(V:T2DVector; M:T2DRowCol): T2DVector;
begin
  Result[1] := V[1] * M[1,1] + V[2] * M[2,1] + M[3,1];
  Result[2] := V[1] * M[1,2] + V[2] * M[2,2] + M[3,2];
  Result[3] := 1;
end;

//The TDblPoint is returned
function DblPoint(a,b:Double):TDblPoint;
begin
  Result.X := a;
  Result.Y := b;
end;

function TruncDblPoint(DblPos: TDblPoint): TPoint;
begin
  Result.X := Trunc(DblPos.X);
  Result.Y := Trunc(DblPos.Y);
end;
{
+-----------------------------------------------------------------------------+
|Collision decision                                                           |
+-----------------------------------------------------------------------------+}

//Point and circle
function PointInCircle(PPos,CPos: TPoint; R: integer): Boolean;
begin
  Result := (PPos.X - CPos.X)*(PPos.X - CPos.X)+(PPos.Y - CPos.Y)*(PPos.Y - CPos.Y)<= R*R;
end;

//Circle and circle
function CircleInCircle(C1Pos,C2Pos: TPoint; R1,R2:Integer): Boolean;
begin
  Result := (C1Pos.X - C2Pos.X)*(C1Pos.X - C2Pos.X)+(C1Pos.Y - C2Pos.Y)*(C1Pos.Y - C2Pos.Y) <= (R1+R2)*(R1+R2);
end;

//Circle and line segment
function SegmentInCircle(SPos,EPos,CPos: TPoint; R: Integer): Boolean;
var
  V,C: TPoint;
  VC,VV,CC:integer;
begin
  Result := False;
  V.X := EPos.X - SPos.X; V.Y := EPos.Y - SPos.Y;
  C.X := CPos.X - SPos.X; C.Y := CPos.Y - SPos.Y;
  VC := V.X * C.X + V.Y * C.Y;
  if VC < 0 then
  begin
    Result := (C.X * C.X + C.Y * C.Y) <= R*R;
  end
  else
  begin
    VV := V.X * V.X + V.Y * V.Y;
    if VC >= VV then
    begin
      Result := (EPos.X - CPos.X)*(EPos.X - CPos.X)+(EPos.Y - CPos.Y)*(EPos.Y - CPos.Y) <= R * R;
    end
    else
      if VC < VV then
      begin
        CC := C.X * C.X + C.Y * C.Y;
        Result := CC - (VC div VV)* VC <= R*R;
      end;
  end;
end;

//Angle recalc
function Angle256(Angle: Single): Single;
begin
  Result := Angle;
  While Result < 0 do Result := Result + 256;
  While Result >= 256 do Result := Result -256;
end;

//If A is closer than B from starting point S, the True is  returned.
function CheckNearAThanB(S,A,B: TDblPoint): Boolean;
begin
  Result := (S.X-A.X)*(S.X-A.X)+(S.Y-A.Y)*(S.Y-A.Y) <= (S.X-B.X)*(S.X-B.X)+(S.Y-B.Y)*(S.Y-B.Y);
end;

initialization
  InitCosinTable;
finalization
  FreeLibList;
end.