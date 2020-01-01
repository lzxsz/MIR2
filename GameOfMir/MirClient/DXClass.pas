unit DXClass;

interface

{$INCLUDE DelphiXcfg.inc}

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, MMSystem, DirectX;

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

initialization
  InitCosinTable;
finalization
  FreeLibList;
end.
