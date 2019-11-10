unit DXInput;

interface

{$INCLUDE DelphiXcfg.inc}

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, MMSystem,
  DXClass, 
{$IfDef StandardDX}
  {$IfDef DX9}
  DirectInput9;
  {$Else}
  {$IfDef DX81}
  DirectInput8;
  {$Else}
  DirectInput;
  {$EndIf}
  {$EndIf}
{$Else}
  DirectX;
{$EndIf}

type

  {  EDXInputError  }

  EDXInputError = class(Exception);

  {  EForceFeedbackEffectError  }

  EForceFeedbackEffectError = class(Exception);


  {  TForceFeedbackEffect  }

  TForceFeedbackEffectType = (etNone, etConstantForce, etPeriodic, etCondition);

  TForceFeedbackEffect = class;
  TForceFeedbackEffects = class;

  TForceFeedbackEffectObject = class
  private
    FAxes: array[0..1] of DWORD;
    FAxesCount: Integer;
    Feff: TDIEffect;
    FDirections: array[0..1] of DWORD;
    FEnvelope: TDIEnvelope;
    FConstantForce: TDIConstantForce;
    FCondition: TDICondition;
    FPeriodic: TDIPeriodic;
    FEffect: IDirectInputEffect;
    procedure Clear;
    procedure Init(Effect: TForceFeedbackEffect);
    procedure Release;
  public
    destructor Destroy; override;
  end;

  TForceFeedbackEffect = class(TPersistent)
  private
    FRoot: TForceFeedbackEffects;                 
    FParent: TForceFeedbackEffect;
    FList: TList;
    FAttackLevel: Integer;
    FAttackTime: Integer;
    FCondition: TPoint;
    FConstant: TPoint;
    FEffectType: TForceFeedbackEffectType;
    FFadeLevel: Integer;
    FFadeTime: Integer;
    FName: string;
    FPeriod: Integer;
    FPlaying: Boolean;
    FPower: Integer;
    FTime: Integer;
    FStartDelayTime: Integer;
    FObject: TForceFeedbackEffectObject;
    FObject2: TForceFeedbackEffectObject;
    FFindEffectFlag: Boolean;
    FFindEffectGUID: TGUID;
    procedure Acquire;
    procedure Finalize;
    procedure Initialize;
    procedure ChangeEffect;
    procedure MakeEff;
    procedure CreateEffect;
    function GetCount: Integer;
    function GetEffect(Index: Integer): TForceFeedbackEffect;
    function GetIndex: Integer;
    function GetPlaying: Boolean;
    procedure SetAttackLevel(Value: Integer);
    procedure SetAttackTime(Value: Integer);
    procedure SetCondition(Value: TPoint);
    procedure SetConstant(Value: TPoint);
    procedure SetEffectType(Value: TForceFeedbackEffectType);
    procedure SetFadeLevel(Value: Integer);
    procedure SetFadeTime(Value: Integer);
    procedure SetIndex(Value: Integer);
    procedure SetPeriod(Value: Integer);
    procedure SetParent(Value: TForceFeedbackEffect);
    procedure SetPower(Value: Integer);
    procedure SetTime(Value: Integer);
    procedure SetStartDelayTime(Value: Integer);
    function HasInterface: Boolean;
  protected
    function GetOwner: TPersistent; override;
    property StartDelayTime: Integer read FStartDelayTime write SetStartDelayTime;
  public
    constructor Create(AParent: TForceFeedbackEffect);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    function Find(const Name: string): TForceFeedbackEffect;
    function IndexOf(const Name: string): Integer;
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: string);
    procedure SaveToStream(Stream: TStream);
    procedure Start;
    procedure Stop;
    procedure Unload(Recurse: Boolean);
    property Count: Integer read GetCount;
    property Effects[Index: Integer]: TForceFeedbackEffect read GetEffect; default;
    property Index: Integer read GetIndex write SetIndex;
    property Playing: Boolean read GetPlaying;
    property Parent: TForceFeedbackEffect read FParent write SetParent;
    property Name: string read FName write FName;
    property EffectType: TForceFeedbackEffectType read FEffectType write SetEffectType;
    property AttackLevel: Integer read FAttackLevel write SetAttackLevel;
    property AttackTime: Integer read FAttackTime write SetAttackTime;
    property Condition: TPoint read FCondition write SetCondition;
    property Constant: TPoint read FConstant write SetConstant;
    property FadeLevel: Integer read FFadeLevel write SetFadeLevel;
    property FadeTime: Integer read FFadeTime write SetFadeTime;
    property Period: Integer read FPeriod write SetPeriod;
    property Power: Integer read FPower write SetPower;
    property Time: Integer read FTime write SetTime;
  end;

  {  TForceFeedbackEffects  }

  TCustomInput = class;

  TForceFeedbackEffects = class(TForceFeedbackEffect)
  private
    FComponent: TComponent;
    FInput: TCustomInput;
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(Input: TCustomInput);
    destructor Destroy; override;
    property Input: TCustomInput read FInput;
  end;

  {  TCustomInput  }

  TDXInputState = (isUp, isDown, isLeft, isRight, isButton1, isButton2, isButton3,
    isButton4, isButton5, isButton6, isButton7, isButton8, isButton9, isButton10, isButton11,
    isButton12, isButton13, isButton14, isButton15, isButton16, isButton17, isButton18,
    isButton19, isButton20, isButton21, isButton22, isButton23, isButton24, isButton25,
    isButton26, isButton27, isButton28, isButton29, isButton30, isButton31, isButton32);

  TDXInputStates = set of TDXInputState;

  TCustomDXInput = class;

  TCustomInput = class(TPersistent)
  private          
    FBindInputStates: Boolean;
    FButtonCount: Integer;
    FDataFormat: TDIDataFormat;
    FDataFormatObjects: array[0..255] of TDIObjectDataFormat;
    FDataFormatGUIDs: array[0..255] of TGUID;
    FDevice: IDirectInputDevice;
    FDevice2: IDirectInputDevice2;
    FDXInput: TCustomDXInput;
    FEffects: TForceFeedbackEffects;
    FEnabled: Boolean;
    FForceFeedback: Boolean;
    FForceFeedbackDevice: Boolean;
    FInitialized: Boolean;
    FStates: TDXInputStates;
    procedure Acquire;
    procedure Finalize; virtual;
    procedure Initialize; virtual;
    function GetButton(Index: Integer): Boolean;
    function GetCooperativeLevel: Integer; virtual;
    function GetDeviceState(dwSize: Integer; var Data): Boolean;
    function SetDataFormat: Boolean;
    procedure SetEffects(Value: TForceFeedbackEffects);
    procedure SetEnabled(Value: Boolean);
    procedure SetForceFeedback(Value: Boolean);
    procedure SetWindowHandle(Value: Integer);
  public
    constructor Create(DXInput: TCustomDXInput); virtual;
    destructor Destroy; override;
    procedure Update; virtual; abstract;
    property ButtonCount: Integer read FButtonCount;
    property Buttons[Index: Integer]: Boolean read GetButton;
    property States: TDXInputStates read FStates;
  published
    property BindInputStates: Boolean read FBindInputStates write FBindInputStates;
    property Effects: TForceFeedbackEffects read FEffects write SetEffects;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property ForceFeedback: Boolean read FForceFeedback write SetForceFeedback;
  end;

  {  TKeyboard  }

  PKeyAssign = ^TKeyAssign;
  TKeyAssign = array[0..2] of Integer;

  TKeyAssignList = array[TDXInputState] of TKeyAssign;

  TKeyboard = class(TCustomInput)
  private
    FKeyStates: TKeyboardState;
    procedure Finalize; override;
    procedure Initialize; override;
    function GetKey(Key: Integer): Boolean;
    procedure ReadAssigns(Stream: TStream);
    procedure WriteAssigns(Stream: TStream);
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    KeyAssigns: TKeyAssignList;
    constructor Create(DXInput: TCustomDXInput); override;
    procedure Update; override;
    property Keys[Key: Integer]: Boolean read GetKey;
  end;

  {  TMouse  }

  TMouse = class(TCustomInput)
  private  
    Fdims: TDIMouseState;
    procedure Finalize; override;
    procedure Initialize; override;
    function GetX: Integer;
    function GetY: Integer;
    function GetZ: Integer;
  public
    constructor Create(DXInput: TCustomDXInput); override;
    procedure Update; override;
    property X: Integer read GetX;
    property Y: Integer read GetY;
    property Z: Integer read GetZ;
  end;

  {  TJoystick  }

  TJoystick = class(TCustomInput)
  private
    Fdijs: TDIJoyState2;
    FAutoCenter: Boolean;
    FDeviceGUID: TGUID;
    FEnumFlag: Boolean;
    FEnumIndex: Integer;
    FID: Integer;
    FID2: Integer;
    FJoyCaps: TJoyCaps;
    FDeadZone: array[0..SizeOf(TDIJoyState2)-1] of Integer;
    FRange: array[0..SizeOf(TDIJoyState2)-1] of Integer;
    procedure Finalize; override;
    procedure Initialize; override;
    function GetCooperativeLevel: Integer; override;
    function GetDeadZone(Obj: Integer): Integer;
    function GetRange(Obj: Integer): Integer;
    function GetX: Integer;
    function GetY: Integer;
    function GetZ: Integer;
    procedure SetDeadZone(Obj: Integer; Value: Integer);
    procedure SetRange(Obj: Integer; Value: Integer);
    procedure SetAutoCenter(Value: Boolean);
    procedure SetID(Value: Integer);
  public
    constructor Create(DXInput: TCustomDXInput); override;
    procedure Update; override;
    property DeadZone[Obj: Integer]: Integer read GetDeadZone write SetDeadZone;
    property Range[Obj: Integer]: Integer read GetRange write SetRange;
    property Joystate: TDIJoyState2 read Fdijs;
    property X: Integer read GetX;
    property Y: Integer read GetY;
    property Z: Integer read GetZ;
  published
    property AutoCenter: Boolean read FAutoCenter write SetAutoCenter;
    property DeadZoneX: Integer index DIJOFS_X read GetDeadZone write SetDeadZone;
    property DeadZoneY: Integer index DIJOFS_Y read GetDeadZone write SetDeadZone;
    property DeadZoneZ: Integer index DIJOFS_Z read GetDeadZone write SetDeadZone;
    property ID: Integer read FID write SetID;
    property RangeX: Integer index DIJOFS_X read GetRange write SetRange;
    property RangeY: Integer index DIJOFS_Y read GetRange write SetRange;
    property RangeZ: Integer index DIJOFS_Z read GetRange write SetRange;
  end;

  {  TCustomDXInput  }

  TCustomDXInput = class(TComponent)
  private
    FActiveOnly: Boolean;
    FDevice: TList;
    FDInput: IDirectInput;
    FForm: TCustomForm;
    FJoystick: TJoystick;
    FKeyboard: TKeyboard;
    FMouse: TMouse;
    FOldStates: TDXInputStates;
    FStates: TDXInputStates;
    FSubClass: TControlSubClass;
    FUseDirectInput: Boolean;
    procedure Finalize;
    procedure Initialize;
    procedure FormWndProc(var Message: TMessage; DefWindowProc: TWndMethod);
    procedure SetActiveOnly(Value: Boolean);
    procedure SetJoystick(Value: TJoystick);
    procedure SetKeyboard(Value: TKeyboard);
    procedure SetMouse(Value: TMouse);
    procedure SetWindowHandle;
    procedure SetUseDirectInput(Value: Boolean);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Update;
    property ActiveOnly: Boolean read FActiveOnly write SetActiveOnly;
    property Joystick: TJoystick read FJoystick write SetJoystick;
    property Keyboard: TKeyboard read FKeyboard write SetKeyboard;
    property Mouse: TMouse read FMouse write SetMouse;
    property States: TDXInputStates read FStates write FStates;
    property UseDirectInput: Boolean read FUseDirectInput write SetUseDirectInput;
  end;

  {  TDXInput  }

  TDXInput = class(TCustomDXInput)
  published
    property ActiveOnly;
    property Joystick;
    property Keyboard;
    property Mouse;
    property UseDirectInput;
  end;

function DefKeyAssign: TKeyAssignList;
function DefKeyAssign2_1: TKeyAssignList;
function DefKeyAssign2_2: TKeyAssignList;

implementation

uses DXConsts;

procedure AssignKey(var KeyAssignList: TKeyAssignList; State: TDXInputState;
  const Keys: array of Integer);
var
  i, i2: Integer;
  KeyAssign: PKeyAssign;
begin
  KeyAssign := @KeyAssignList[State];
  FillChar(KeyAssign^, SizeOf(TKeyAssign), 0);

  i2 := 0;
  for i:=LOW(Keys) to HIGH(Keys) do
  begin
    if i2<3 then
      KeyAssign^[i2] := Keys[i]
    else
      Exit;
    Inc(i2);
  end;
end;

function DefKeyAssign: TKeyAssignList;
begin
  FillChar(Result, SizeOf(Result), 0);

  AssignKey(Result, isUp,      [Ord('K'), VK_UP, VK_NUMPAD8]);
  AssignKey(Result, isDown,    [Ord('J'), VK_DOWN, VK_NUMPAD2]);
  AssignKey(Result, isLeft,    [Ord('H'), VK_LEFT, VK_NUMPAD4]);
  AssignKey(Result, isRight,   [Ord('L'), VK_RIGHT, VK_NUMPAD6]);
  AssignKey(Result, isButton1, [Ord('Z'), VK_SPACE]);
  AssignKey(Result, isButton2, [Ord('X'), VK_RETURN]);
  AssignKey(Result, isButton9, [VK_F2]);
end;

function DefKeyAssign2_1: TKeyAssignList;
begin
  FillChar(Result, SizeOf(Result), 0);

  AssignKey(Result, isUp,      [Ord('K'), VK_UP, VK_NUMPAD8]);
  AssignKey(Result, isDown,    [Ord('J'), VK_DOWN, VK_NUMPAD2]);
  AssignKey(Result, isLeft,    [Ord('H'), VK_LEFT, VK_NUMPAD4]);
  AssignKey(Result, isRight,   [Ord('L'), VK_RIGHT, VK_NUMPAD6]);
  AssignKey(Result, isButton1, [VK_SPACE , VK_NUMPAD0]);
  AssignKey(Result, isButton2, [VK_RETURN, VK_NUMPAD5]);
  AssignKey(Result, isButton9, [VK_F2]);
end;

function DefKeyAssign2_2: TKeyAssignList;
begin
  FillChar(Result, SizeOf(Result), 0);

  AssignKey(Result, isUp,      [Ord('E')]);
  AssignKey(Result, isDown,    [Ord('C')]);
  AssignKey(Result, isLeft,    [Ord('S')]);
  AssignKey(Result, isRight,   [Ord('F')]);
  AssignKey(Result, isButton1, [Ord('Z')]);
  AssignKey(Result, isButton2, [Ord('X')]);
  AssignKey(Result, isButton9, [VK_F2]);
end;

{  TForceFeedbackEffectObject  }

destructor TForceFeedbackEffectObject.Destroy;
begin
  Release;                      
  inherited Destroy;
end;

function ConvertTime(i: Integer): DWORD;
begin
  if i=-1 then Result := INFINITE else Result := i*1000;
end;

procedure TForceFeedbackEffectObject.Clear;
begin
  FillChar(Feff, SizeOf(Feff), 0);
end;

procedure TForceFeedbackEffectObject.Init(Effect: TForceFeedbackEffect);
begin
  with FEnvelope do
  begin
    dwSize := SizeOf(FEnvelope);

    dwAttackLevel := Effect.FAttackLevel;
    if Effect.FTime<0 then
      dwAttackTime := Effect.FAttackTime*1000
    else
      dwAttackTime := Min(Effect.FAttackTime, Effect.FTime)*1000;
                                              
    if Effect.FTime<0 then
    begin
      dwFadeLevel := 0;
      dwFadeTime := 0;
    end else
    begin
      dwFadeLevel := Effect.FFadeLevel;
      dwFadeTime := Min(Effect.FFadeTime, Effect.FTime)*1000;
    end;
  end;

  FillChar(Feff, SizeOf(Feff), 0);
  with Feff do
  begin
    dwSize := SizeOf(Feff);
    dwFlags := DIEFF_CARTESIAN or DIEFF_OBJECTOFFSETS;
    dwDuration := ConvertTime(Effect.FTime);
    dwSamplePeriod := 0;
    dwGain := Effect.FPower;
    dwTriggerButton := DIEB_NOTRIGGER;
    dwTriggerRepeatInterval := 0;
    cAxes := FAxesCount;
    rgdwAxes := @FAxes;
    rglDirection := @FDirections;
    lpEnvelope := @FEnvelope;
    //dwStartDelay := Effect.FStartDelayTime;
  end;
end;

procedure TForceFeedbackEffectObject.Release;
begin
  FEffect := nil;
end;

{  TForceFeedbackEffect  }

constructor TForceFeedbackEffect.Create(AParent: TForceFeedbackEffect);
begin
  inherited Create;
  FParent := AParent;
  FList := TList.Create;

  if FParent<>nil then
  begin
    FParent.FList.Add(Self);
    FRoot := FParent.FRoot;
  end else
  begin
    FName := 'Effects';
    FRoot := Self as TForceFeedbackEffects;
  end;

  FObject := TForceFeedbackEffectObject.Create;
  FObject2 := TForceFeedbackEffectObject.Create;

  AttackTime := 0;
  Constant := Point(0, 0);
  EffectType := etNone;
  FadeTime := 0;
  Period := 50;
  Power := 10000;
  Time := 1000;
end;

destructor TForceFeedbackEffect.Destroy;
begin
  Clear;
  FObject.Free;
  FObject2.Free;
  FList.Free;
  if FParent<>nil then
    FParent.FList.Remove(Self);
  inherited Destroy;
end;

function TForceFeedbackEffect.GetOwner: TPersistent;
begin
  Result := Parent;
end;

procedure TForceFeedbackEffect.Assign(Source: TPersistent);
var
  i: Integer;
begin
  if Source is TForceFeedbackEffect then
  begin
    if Source<>Self then
    begin
      Clear;

      EffectType := etNone;

      Name := TForceFeedbackEffect(Source).Name;

      AttackLevel := TForceFeedbackEffect(Source).AttackLevel;
      AttackTime := TForceFeedbackEffect(Source).AttackTime;
      Constant := TForceFeedbackEffect(Source).Constant;
      Condition := TForceFeedbackEffect(Source).Condition;
      EffectType := TForceFeedbackEffect(Source).EffectType;
      FadeLevel := TForceFeedbackEffect(Source).FadeLevel;
      FadeTime := TForceFeedbackEffect(Source).FadeTime;
      Period := TForceFeedbackEffect(Source).Period;
      Power := TForceFeedbackEffect(Source).Power;
      Time := TForceFeedbackEffect(Source).Time;
      StartDelayTime := TForceFeedbackEffect(Source).StartDelayTime;

      EffectType := TForceFeedbackEffect(Source).EffectType;

      for i:=0 to TForceFeedbackEffect(Source).Count-1 do
        TForceFeedbackEffect.Create(Self).Assign(TForceFeedbackEffect(Source)[i]);
    end;
  end else
    inherited Assign(Source);
end;

procedure TForceFeedbackEffect.Acquire;
var
  i: Integer;
begin
  if Playing and (Time=-1) then
    Start;

  for i:=0 to Count-1 do
    Effects[i].Initialize;
end;

procedure TForceFeedbackEffect.Clear;
begin
  while Count>0 do
    Effects[Count-1].Free;
end;

procedure TForceFeedbackEffect.Initialize;
var
  i: Integer;
begin
  CreateEffect;
  for i:=0 to Count-1 do
    Effects[i].Initialize;
end;

procedure TForceFeedbackEffect.Finalize;
var
  i: Integer;
begin
  try
    Stop;
    FObject.Release;
    FObject2.Release;
  finally
    for i:=0 to Count-1 do
      Effects[i].Finalize;
  end;
end;

function TForceFeedbackEffect.Find(const Name: string): TForceFeedbackEffect;
var
  i, p: Integer;
  Effect: TForceFeedbackEffect;
  AName: string;
begin
  AName := Name;
  Effect := Self;

  p := AnsiPos('.', AName);
  while p<>0 do
  begin
    i := Effect.IndexOf(AName);
    if i<>-1 then
    begin
      Result := Effect[i];
      Exit;
    end else
    begin
      i := Effect.IndexOf(Copy(Name, 1, p-1));
      if i=-1 then
        raise EForceFeedbackEffectError.CreateFmt(SEffectNotFound, [Name]);
      Effect := Effect[i];
      AName := Copy(Name, p+1, MaxInt);
      p := AnsiPos('.', AName);
    end;
  end;

  i := Effect.IndexOf(Name);
  if i=-1 then
    raise EForceFeedbackEffectError.CreateFmt(SEffectNotFound, [Name]);
  Result := Effect[i];
end;

function TForceFeedbackEffect.IndexOf(const Name: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i:=0 to Count-1 do
    if Effects[i].Name=Name then
    begin
      Result := i;
      Break;
    end;
end;

function TForceFeedbackEffect.HasInterface: Boolean;
begin
  Result := (FEffectType<>etNone) and ((FObject.FEffect<>nil) or (FObject2.FEffect<>nil));
end;

procedure TForceFeedbackEffect.MakeEff;
var
  Constant2: TPoint;
begin
  FObject.Clear;
  FObject2.Clear;

  with Constant2 do
  begin
    X := -FConstant.X;
    Y := -FConstant.Y;
  end;

  case FEffectType of
    etConstantForce:  { etConstantForce }
        begin
          with FObject do
          begin
            FDirections[0] := Constant2.X;
            FDirections[1] := Constant2.Y;

            FAxesCount := 2;
            FAxes[0] := DIJOFS_X;
            FAxes[1] := DIJOFS_Y;

            with Constant2 do
              FConstantForce.lMagnitude := Trunc(Sqrt(X*X+Y*Y));

            Init(Self);
            with Feff do
            begin
              cbTypeSpecificParams := SizeOf(FConstantForce);
              lpvTypeSpecificParams := @FConstantForce;
            end;
          end;
        end;
    etPeriodic:       { etPeriodic }
        begin
          with FObject do
          begin
            FDirections[0] := Constant2.X;
            FDirections[1] := Constant2.Y;

            FAxesCount := 2;
            FAxes[0] := DIJOFS_X;
            FAxes[1] := DIJOFS_Y;

            with FPeriodic do
            begin
              with Constant2 do
                dwMagnitude := Trunc(Sqrt(X*X+Y*Y));
              lOffset := 0;
              dwPhase := 0;
              dwPeriod := ConvertTime(FPeriod);
            end;

            Init(Self);
            with Feff do
            begin
              cbTypeSpecificParams := SizeOf(FPeriodic);
              lpvTypeSpecificParams := @FPeriodic;
            end;
          end;
        end;
    etCondition:      { etCondition }
        begin
          with FObject do
          begin
            FillChar(FDirections, SizeOf(FDirections), 0);

            FAxesCount := 1;
            FAxes[0] := DIJOFS_X;
                    
            with FCondition do
            begin
              lOffset := -Constant2.X;
              lPositiveCoefficient := Self.FCondition.X;
              lNegativeCoefficient := -Self.FCondition.X;
              dwPositiveSaturation := 0;
              dwNegativeSaturation := 0;
              lDeadBand := 0;
            end;

            Init(Self);
            with Feff do
            begin
              cbTypeSpecificParams := SizeOf(FCondition);
              lpvTypeSpecificParams := @FCondition;
            end;
          end;

          with FObject2 do
          begin
            FillChar(FDirections, SizeOf(FDirections), 0);

            FAxesCount := 1;
            FAxes[0] := DIJOFS_Y;

            with FCondition do
            begin
              lOffset := -Constant2.Y;
              lPositiveCoefficient := Self.FCondition.Y;
              lNegativeCoefficient := -Self.FCondition.Y;
              dwPositiveSaturation := 0;
              dwNegativeSaturation := 0;
              lDeadBand := 0;
            end;

            Init(Self);
            with Feff do
            begin
              cbTypeSpecificParams := SizeOf(FCondition);
              lpvTypeSpecificParams := @FCondition;
            end;
          end;
        end;
  end;
end;

procedure TForceFeedbackEffect.CreateEffect;
                                            
  function FindEffectCallBack(const pdei: TDIEffectInfoA;
    pvRef: Pointer): HRESULT; stdcall;
  begin
    with TForceFeedbackEffect(pvRef) do
    begin
      FFindEffectFlag := True;
      FFindEffectGUID := pdei.guid;
    end;

    Result := Integer(DIENUM_STOP);
  end;

  procedure CreateIEffectGuid(const GUID: TGUID;
    EffectObject: TForceFeedbackEffectObject);
  begin
    if EffectObject.Feff.dwSize=0 then Exit;

    if FRoot.FInput.FDevice2<>nil then
      FRoot.FInput.FDevice2.CreateEffect(GUID, @EffectObject.Feff, EffectObject.FEffect, nil);
  end;

  procedure CreateIEffect(dwFlags: DWORD;
    EffectObject: TForceFeedbackEffectObject);
  begin
    if EffectObject.Feff.dwSize=0 then Exit;

    if FRoot.FInput.FDevice2<>nil then
    begin
      FFindEffectFlag := False;
      FRoot.FInput.FDevice2.EnumEffects(@FindEffectCallBack,
        Self, dwFlags);
      if FFindEffectFlag then
        CreateIEffectGuid(FFindEffectGUID, EffectObject);
    end;
  end;

begin
  FObject.Release;
  FObject2.Release;

  if (FRoot.FInput=nil) or (FRoot.FInput.FDevice2=nil) or
    (not FRoot.FInput.FForceFeedbackDevice) or
    (not FRoot.FInput.FForceFeedback) then Exit;

  if FEffectType=etNone then Exit;

  MakeEff;
  case FEffectType of
    etConstantForce:
        begin
          CreateIEffectGUID(GUID_ConstantForce, FObject);
        end;
    etPeriodic:
        begin
          CreateIEffect(DIEFT_PERIODIC, FObject);
        end;
    etCondition:
        begin
          CreateIEffect(DIEFT_CONDITION, FObject);
          CreateIEffect(DIEFT_CONDITION, FObject2);
        end;
  end;

  if Playing and (Time=-1) then
    Start;
end;

procedure TForceFeedbackEffect.ChangeEffect;
var
  dwFlags: DWORD;
begin
  if HasInterface then
  begin
    MakeEff;

    dwFlags := DIEP_DIRECTION or DIEP_DURATION or DIEP_ENVELOPE or
      DIEP_GAIN or DIEP_SAMPLEPERIOD or DIEP_TRIGGERBUTTON or
      DIEP_TRIGGERREPEATINTERVAL or DIEP_TYPESPECIFICPARAMS;

    if Playing then
      dwFlags := dwFlags or DIEP_START;

    if FObject.FEffect<>nil then FObject.FEffect.SetParameters(FObject.Feff, dwFlags);
    if FObject2.FEffect<>nil then FObject2.FEffect.SetParameters(FObject2.Feff, dwFlags);
  end;
end;

function TForceFeedbackEffect.GetPlaying: Boolean;
var
  dwFlags: DWORD;
begin
  Result := False;

  if not FPlaying then Exit;

  if FPlaying and (FTime=-1) then
  begin
    Result := True;
    Exit;
  end;

  if FObject.FEffect<>nil then
  begin
    dwFlags := 0;
    FObject.FEffect.GetEffectStatus(dwFlags);
    if dwFlags and DIEGES_PLAYING<>0 then
    begin
      Result := True;
      Exit;
    end;
  end;

  if FObject2.FEffect<>nil then
  begin
    dwFlags := 0;
    FObject2.FEffect.GetEffectStatus(dwFlags);
    if dwFlags and DIEGES_PLAYING<>0 then
    begin
      Result := True;
      Exit;
    end;
  end;

  if not Result then
    FPlaying := False;
end;

function TForceFeedbackEffect.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TForceFeedbackEffect.GetEffect(Index: Integer): TForceFeedbackEffect;
begin
  Result :=FList[Index];
end;

function TForceFeedbackEffect.GetIndex: Integer;
begin
  if FParent<>nil then
    Result := FParent.FList.IndexOf(Self)
  else
    Result := 0;
end;

procedure TForceFeedbackEffect.SetIndex(Value: Integer);
begin
  if FParent<>nil then
  begin
    FParent.FList.Remove(Self);
    FParent.FList.Insert(Value, Self);
  end;
end;

procedure TForceFeedbackEffect.SetParent(Value: TForceFeedbackEffect);
begin
  if Parent<>Value then
  begin
    if (Value=nil) or (FRoot<>Value.FRoot) then
      raise EForceFeedbackEffectError.CreateFmt(SCannotChanged, ['Parent']);

    FParent.FList.Remove(Self);
    FParent := Value;
    FParent.FList.Add(Self);
  end;
end;

procedure TForceFeedbackEffect.SetAttackLevel(Value: Integer);
begin
  if Value<0 then Value := 0;
  if Value>10000 then Value := 10000;

  if FAttackLevel<>Value then
  begin
    FAttackLevel := Value;
    ChangeEffect;
  end;
end;

procedure TForceFeedbackEffect.SetAttackTime(Value: Integer);
begin
  if Value<0 then Value := 0;

  if FAttackTime<>Value then
  begin
    FAttackTime := Value;
    ChangeEffect;
  end;
end;

procedure TForceFeedbackEffect.SetCondition(Value: TPoint);
begin
  with Value do
  begin
    if X<-10000 then X := -10000;
    if X>+10000 then X := +10000;

    if Y<-10000 then Y := -10000;
    if Y>+10000 then Y := +10000;
  end;

  if not CompareMem(@FCondition, @Value, SizeOf(FCondition)) then
  begin
    FCondition := Value;

    if HasInterface then
      ChangeEffect;
  end;
end;

procedure TForceFeedbackEffect.SetConstant(Value: TPoint);
begin
  with Value do
  begin
    if X<-10000 then X := -10000;
    if X>+10000 then X := +10000;

    if Y<-10000 then Y := -10000;
    if Y>+10000 then Y := +10000;
  end;

  if not CompareMem(@FConstant, @Value, SizeOf(FConstant)) then
  begin
    FConstant := Value;

    if HasInterface then
      ChangeEffect;
  end;
end;

procedure TForceFeedbackEffect.SetEffectType(Value: TForceFeedbackEffectType);
begin
  if FEffectType<>Value then
  begin
    FEffectType := Value;
    Stop;
    CreateEffect;
  end;
end;

procedure TForceFeedbackEffect.SetFadeLevel(Value: Integer);
begin
  if Value<0 then Value := 0;
  if Value>10000 then Value := 10000;

  if FFadeLevel<>Value then
  begin
    FFadeLevel := Value;
    ChangeEffect;
  end;
end;

procedure TForceFeedbackEffect.SetFadeTime(Value: Integer);
begin
  if Value<0 then Value := 0;

  if FFadeTime<>Value then
  begin
    FFadeTime := Value;
    ChangeEffect;
  end;
end;

procedure TForceFeedbackEffect.SetPeriod(Value: Integer);
begin
  if Value<0 then Value := 0;

  if FPeriod<>Value then
  begin
    FPeriod := Value;
    ChangeEffect;
  end;
end;

procedure TForceFeedbackEffect.SetPower(Value: Integer);
begin
  if Value<0 then Value := 0;
  if Value>10000 then Value := 10000;

  if FPower<>Value then
  begin
    FPower := Value;
    ChangeEffect;
  end;
end;

procedure TForceFeedbackEffect.SetTime(Value: Integer);
begin
  if (Value<>-1) and (Value<0) then Value := 0;

  if FTime<>Value then
  begin
    FTime := Value;
    Stop;
    ChangeEffect;
  end;
end;

procedure TForceFeedbackEffect.SetStartDelayTime(Value: Integer);
begin
  if Value<0 then Value := 0;

  if FStartDelayTime<>Value then
  begin
    FStartDelayTime := Value;
    Stop;
    ChangeEffect;
  end;
end;

procedure TForceFeedbackEffect.Start;

  procedure StartEffect(Effect: IDirectInputEffect);
  var
    hr: HRESULT;
  begin
    if Effect<>nil then
    begin
      hr := Effect.Start(1, 0);
      if (hr=DIERR_INPUTLOST) or (hr=DIERR_NOTACQUIRED) then
      begin
        FRoot.FInput.Acquire;
        Effect.Start(1, 0);
      end;
    end;
  end;

var
  i: Integer;
begin
  for i:=0 to Count-1 do
    Effects[i].Start;

  if not HasInterface then
  begin
    CreateEffect;
    if not HasInterface then Exit;
  end;

  StartEffect(FObject.FEffect);
  StartEffect(FObject2.FEffect);

  FPlaying := True;
end;

procedure TForceFeedbackEffect.Stop;
var
  i: Integer;
begin
  if Playing then
  begin
    FPlaying := False;
    if FObject.FEffect<>nil then FObject.FEffect.Stop;
    if FObject2.FEffect<>nil then FObject2.FEffect.Stop;
  end;

  for i:=0 to Count-1 do
    Effects[i].Stop;
end;

procedure TForceFeedbackEffect.Unload(Recurse: Boolean);
var
  i: Integer;
begin
  if Playing then
  begin
    if FObject.FEffect<>nil then FObject.FEffect.Stop;
    if FObject2.FEffect<>nil then FObject2.FEffect.Stop;
  end;

  if FObject.FEffect<>nil then FObject.FEffect.Unload;
  if FObject2.FEffect<>nil then FObject2.FEffect.Unload;

  if Recurse then
  begin
    for i:=0 to Count-1 do
      Effects[i].Unload(True);
  end;
end;

type
  TForceFeedbackEffectItem = class(TCollectionItem)
  private
    FName: string;
    FEffectType: TForceFeedbackEffectType;
    FAttackLevel: Integer;
    FAttackTime: Integer;
    FConditionX: Integer;
    FConditionY: Integer;
    FConstantX: Integer;
    FConstantY: Integer;
    FFadeLevel: Integer;
    FFadeTime: Integer;
    FPeriod: Integer;
    FPower: Integer;
    FTime: Integer;
    FStartDelayTime: Integer;
    FEffects: TCollection;
    function GetStoredEffects: Boolean;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignTo(Dest: TPersistent); override;
  published
    property Name: string read FName write FName;
    property EffectType: TForceFeedbackEffectType read FEffectType write FEffectType;
    property AttackLevel: Integer read FAttackLevel write FAttackLevel default 0;
    property AttackTime: Integer read FAttackTime write FAttackTime default 0;
    property ConditionX: Integer read FConditionX write FConditionX default 0;
    property ConditionY: Integer read FConditionY write FConditionY default 0;
    property ConstantX: Integer read FConstantX write FConstantX default 0;
    property ConstantY: Integer read FConstantY write FConstantY default 0;
    property FadeLevel: Integer read FFadeLevel write FFadeLevel default 0;
    property FadeTime: Integer read FFadeTime write FFadeTime default 0;
    property Period: Integer read FPeriod write FPeriod;
    property Power: Integer read FPower write FPower;
    property Time: Integer read FTime write FTime;
    property StartDelayTime: Integer read FStartDelayTime write FStartDelayTime;
    property Effects: TCollection read FEffects write FEffects stored GetStoredEffects;
  end;

  TForceFeedbackEffectComponent = class(TComponent)
  private
    FEffects: TCollection;
  published
    property Effects: TCollection read FEffects write FEffects;
  end;

constructor TForceFeedbackEffectItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FEffects := TCollection.Create(TForceFeedbackEffectItem);
end;

destructor TForceFeedbackEffectItem.Destroy;
begin
  FEffects.Free;
  inherited Destroy;
end;

procedure TForceFeedbackEffectItem.Assign(Source: TPersistent);
var
  Effect: TForceFeedbackEffect;
  i: Integer;
begin
  Effect := Source as TForceFeedbackEffect;

  FName := Effect.Name;
  FEffectType := Effect.EffectType;
  FAttackLevel := Effect.AttackLevel;
  FAttackTime := Effect.AttackTime;
  FConditionX := Effect.Condition.X;
  FConditionY := Effect.Condition.Y;
  FConstantX := Effect.Constant.X;
  FConstantY := Effect.Constant.Y;
  FFadeLevel := Effect.FadeLevel;
  FFadeTime := Effect.FadeTime;
  FPeriod := Effect.Period;
  FPower := Effect.Power;
  FTime := Effect.Time;
  FStartDelayTime := Effect.StartDelayTime;

  for i:=0 to Effect.Count-1 do
    TForceFeedbackEffectItem.Create(FEffects).Assign(Effect[i]);
end;

procedure TForceFeedbackEffectItem.AssignTo(Dest: TPersistent);
var
  Effect: TForceFeedbackEffect;
  i: Integer;
begin
  Effect := Dest as TForceFeedbackEffect;

  Effect.EffectType := etNone;

  Effect.Name := FName;
  Effect.AttackLevel := FAttackLevel;
  Effect.AttackTime := FAttackTime;
  Effect.Condition := Point(FConditionX, FConditionY);
  Effect.Constant := Point(FConstantX, FConstantY);
  Effect.FadeLevel := FFadeLevel;
  Effect.FadeTime := FFadeTime;
  Effect.Period := FPeriod;
  Effect.Power := FPower;
  Effect.Time := FTime;
  Effect.StartDelayTime := FStartDelayTime;

  Effect.EffectType := FEffectType;

  for i:=0 to FEffects.Count-1 do
    TForceFeedbackEffectItem(FEffects.Items[i]).AssignTo(TForceFeedbackEffect.Create(Effect));
end;

function TForceFeedbackEffectItem.GetStoredEffects: Boolean;
begin
  Result := FEffects.Count>0;
end;

procedure TForceFeedbackEffect.LoadFromFile(const FileName: string);
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

procedure TForceFeedbackEffect.LoadFromStream(Stream: TStream);
var
  Component: TForceFeedbackEffectComponent;
begin
  Clear;

  Component := TForceFeedbackEffectComponent(FRoot.FComponent);
  try
    Component.FEffects := TCollection.Create(TForceFeedbackEffectItem);
    Stream.ReadComponentRes(Component);
    TForceFeedbackEffectItem(Component.FEffects.Items[0]).AssignTo(Self);
  finally
    Component.FEffects.Free;
    Component.FEffects := nil;
  end;
end;

procedure TForceFeedbackEffect.SaveToFile(const FileName: string);
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

procedure TForceFeedbackEffect.SaveToStream(Stream: TStream);
var
  Component: TForceFeedbackEffectComponent;
begin
  Component := TForceFeedbackEffectComponent(FRoot.FComponent);
  try
    Component.FEffects := TCollection.Create(TForceFeedbackEffectItem);
    TForceFeedbackEffectItem.Create(Component.FEffects).Assign(Self);
    Stream.WriteComponentRes('DelphiXForceFeedbackEffect', Component);
  finally
    Component.FEffects.Free;
    Component.FEffects := nil;
  end;
end;

{  TForceFeedbackEffects  }

constructor TForceFeedbackEffects.Create(Input: TCustomInput);
begin
  inherited Create(nil);
  FInput := Input;
  FComponent := TForceFeedbackEffectComponent.Create(nil);
end;

destructor TForceFeedbackEffects.Destroy;
begin
  FComponent.Free;
  inherited Destroy;
end;

procedure TForceFeedbackEffects.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Effects', LoadFromStream, SaveToStream, True);
end;

{  TCustomInput  }

constructor TCustomInput.Create(DXInput: TCustomDXInput);
begin
  inherited Create;
  FDXInput := DXInput;
  FDXInput.FDevice.Add(Self);
  FEffects := TForceFeedbackEffects.Create(Self);
  FEnabled := True;
  FBindInputStates := True;
end;

destructor TCustomInput.Destroy;
begin
  Finalize;
  FEffects.Free;
  FDXInput.FDevice.Remove(Self);
  inherited Destroy;
end;

procedure TCustomInput.Acquire;
begin
  if FDXInput.FActiveOnly and (GetForegroundWindow<>FDXInput.FForm.Handle) then
    Exit;

  if FDevice<>nil then
    FDevice.Acquire;

  FEffects.Acquire;
end;

procedure TCustomInput.Finalize;
begin
  if FDevice<>nil then FDevice.Unacquire;
  FInitialized := False;
  FButtonCount := 0;
  FEffects.Finalize;
  FDevice := nil;
  FDevice2 := nil;
  FForceFeedbackDevice := False;
  FStates := [];
end;

procedure TCustomInput.Initialize;
begin
  FInitialized := True;
  FEffects.Initialize;
end;

function TCustomInput.GetButton(Index: Integer): Boolean;
begin
  if Index in [0..31] then
    Result := TDXInputState(Integer(isButton1)+Index) in FStates
  else
    Result := False;
end;

function TCustomInput.GetCooperativeLevel: Integer;
const
  Levels: array[Boolean] of Integer = (DISCL_NONEXCLUSIVE, DISCL_EXCLUSIVE);
  Levels2: array[Boolean] of Integer = (DISCL_BACKGROUND, DISCL_FOREGROUND);
begin
  Result := Levels[FForceFeedbackDevice and FForceFeedback] or Levels2[FDXInput.ActiveOnly];
end;

function TCustomInput.GetDeviceState(dwSize: Integer; var Data): Boolean;
var
  hr: HRESULT;
begin
  FillChar(Data, dwSize, 0);

  if FDevice<>nil then
  begin
    hr := FDevice.GetDeviceState(dwSize, @Data);
    if (hr=DIERR_INPUTLOST) or (hr=DIERR_NOTACQUIRED) then
    begin
      FDevice.Acquire;
      hr := FDevice.GetDeviceState(dwSize, @Data);
    end;
    Result := hr=DI_OK;
  end else
    Result := False;
end;

function TCustomInput.SetDataFormat: Boolean;

  function DIEnumDeviceObjectsProc(const peff: TDIDeviceObjectInstanceA;
    pvRef: Pointer): HRESULT; stdcall;
  begin
    Result := Integer(DIENUM_CONTINUE);

    if CompareMem(@peff.guidType, @GUID_Unknown, SizeOf(TGUID)) then Exit;

    with TCustomInput(pvRef) do
    begin
      if peff.dwOfs<FDataFormat.dwDataSize then
      begin
        FDataFormatGUIDs[FDataFormat.dwNumObjs] := peff.guidType;

        with FDataFormatObjects[FDataFormat.dwNumObjs] do
        begin
          pguid := @FDataFormatGUIDs[FDataFormat.dwNumObjs];
          dwOfs := peff.dwOfs;
          dwType := peff.dwType;
          dwFlags := 0;
        end;
        Inc(FDataFormat.dwNumObjs);
      end;
    end;
  end;

begin
  Result := False;
  if FDevice<>nil then
  begin
    with FDataFormat do
    begin
      dwSize := SizeOf(FDataFormat);
      dwObjSize := SizeOf(TDIObjectDataFormat);
      dwNumObjs := 0;
      rgodf := @FDataFormatObjects;
    end;

    FDevice.EnumObjects(@DIEnumDeviceObjectsProc, Self, DIDFT_ALL);
    if FDevice.SetDataFormat(FDataFormat)<>DI_OK then Exit;
  end;
  Result := True;
end;

procedure TCustomInput.SetEffects(Value: TForceFeedbackEffects);
begin
  FEffects.Assign(Value);
end;

procedure TCustomInput.SetEnabled(Value: Boolean);
begin
  if FEnabled<>Value then
  begin
    FEnabled := Value;
    if FDXInput.ComponentState*[csLoading, csReading]=[] then
      Initialize;
  end;
end;

procedure TCustomInput.SetForceFeedback(Value: Boolean);
begin
  if FForceFeedback<>Value then
  begin
    FForceFeedback := Value;
    if FDXInput.ComponentState*[csLoading, csReading]=[] then
      Initialize;
  end;
end;

procedure TCustomInput.SetWindowHandle(Value: Integer);
begin
  if FDevice<>nil then
    FDevice.SetCooperativeLevel(Value, GetCooperativeLevel);
end;

{  TKeyboard  }

constructor TKeyboard.Create(DXInput: TCustomDXInput);
begin
  inherited Create(DXInput);
  KeyAssigns := DefKeyAssign;
end;

procedure TKeyboard.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Aissgns', ReadAssigns, WriteAssigns, False);
  Filer.DefineBinaryProperty('Assigns', ReadAssigns, WriteAssigns, True);
end;

function TKeyboard.GetKey(Key: Integer): Boolean;
begin
  if Key in [1..255] then
    Result := FKeyStates[Key] and $80<>0
  else
    Result := False;
end;

procedure TKeyboard.Finalize;
begin
  FillChar(FKeyStates, SizeOf(FKeyStates), 0);
  inherited Finalize;
end;

procedure TKeyboard.Initialize;
begin
  Finalize;

  if (not FEnabled) or (csDesigning in FDXInput.ComponentState) then Exit;

  if FDXInput.FDInput<>nil then
  begin
    if FDXInput.FDInput.CreateDevice(GUID_SysKeyboard, FDevice, nil)<>DI_OK then Exit;
    FDevice.SetDataFormat(c_dfDIKeyboard);
  end;

  FButtonCount := 32;

  inherited Initialize;
end;

procedure TKeyboard.Update;

  function DIKEYtoVK(Key: Byte): Integer;
  begin
    Result := 0;
    case Key of
      DIK_ESCAPE       : Result := VK_ESCAPE;
      DIK_1            : Result := Ord('1');
      DIK_2            : Result := Ord('2');
      DIK_3            : Result := Ord('3');
      DIK_4            : Result := Ord('4');
      DIK_5            : Result := Ord('5');
      DIK_6            : Result := Ord('6');
      DIK_7            : Result := Ord('7');
      DIK_8            : Result := Ord('8');
      DIK_9            : Result := Ord('9');
      DIK_0            : Result := Ord('0');
      DIK_EQUALS       : Result := Ord('=');
      DIK_BACK         : Result := VK_BACK;
      DIK_TAB          : Result := VK_TAB;
      DIK_Q            : Result := Ord('Q');
      DIK_W            : Result := Ord('W');
      DIK_E            : Result := Ord('E');
      DIK_R            : Result := Ord('R');
      DIK_T            : Result := Ord('T');
      DIK_Y            : Result := Ord('Y');
      DIK_U            : Result := Ord('U');
      DIK_I            : Result := Ord('I');
      DIK_O            : Result := Ord('O');
      DIK_P            : Result := Ord('P');
      DIK_LBRACKET     : Result := Ord('[');
      DIK_RBRACKET     : Result := Ord(']');
      DIK_RETURN       : Result := VK_RETURN;
      DIK_LCONTROL     : Result := VK_CONTROL;
      DIK_A            : Result := Ord('A');
      DIK_S            : Result := Ord('S');
      DIK_D            : Result := Ord('D');
      DIK_F            : Result := Ord('F');
      DIK_G            : Result := Ord('G');
      DIK_H            : Result := Ord('H');
      DIK_J            : Result := Ord('J');
      DIK_K            : Result := Ord('K');
      DIK_L            : Result := Ord('L');
      DIK_SEMICOLON    : Result := Ord(';');
      DIK_APOSTROPHE   : Result := Ord('''');
      DIK_LSHIFT       : Result := VK_SHIFT;
      DIK_BACKSLASH    : Result := Ord('\');
      DIK_Z            : Result := Ord('Z');
      DIK_X            : Result := Ord('X');
      DIK_C            : Result := Ord('C');
      DIK_V            : Result := Ord('V');
      DIK_B            : Result := Ord('B');
      DIK_N            : Result := Ord('N');
      DIK_M            : Result := Ord('M');
      DIK_COMMA        : Result := Ord(',');
      DIK_PERIOD       : Result := Ord('.');
      DIK_SLASH        : Result := Ord('/');
      DIK_RSHIFT       : Result := VK_SHIFT;
      DIK_MULTIPLY     : Result := Ord('*');
      DIK_LMENU        : Result := VK_MENU;
      DIK_SPACE        : Result := VK_SPACE;
      DIK_CAPITAL      : Result := VK_CAPITAL;
      DIK_F1           : Result := VK_F1;
      DIK_F2           : Result := VK_F2;
      DIK_F3           : Result := VK_F3;
      DIK_F4           : Result := VK_F4;
      DIK_F5           : Result := VK_F5;
      DIK_F6           : Result := VK_F6;
      DIK_F7           : Result := VK_F7;
      DIK_F8           : Result := VK_F8;
      DIK_F9           : Result := VK_F9;
      DIK_F10          : Result := VK_F10;
      DIK_NUMLOCK      : Result := VK_NUMLOCK;
      DIK_SCROLL       : Result := VK_SCROLL;
      DIK_NUMPAD7      : Result := VK_NUMPAD7;
      DIK_NUMPAD8      : Result := VK_NUMPAD8;
      DIK_NUMPAD9      : Result := VK_NUMPAD9;
      DIK_SUBTRACT     : Result := VK_SUBTRACT;
      DIK_NUMPAD4      : Result := VK_NUMPAD4;
      DIK_NUMPAD5      : Result := VK_NUMPAD5;
      DIK_NUMPAD6      : Result := VK_NUMPAD6;
      DIK_ADD          : Result := VK_ADD;
      DIK_NUMPAD1      : Result := VK_NUMPAD1;
      DIK_NUMPAD2      : Result := VK_NUMPAD2;
      DIK_NUMPAD3      : Result := VK_NUMPAD3;
      DIK_NUMPAD0      : Result := VK_NUMPAD0;
      DIK_DECIMAL      : Result := VK_DECIMAL;
      DIK_F11          : Result := VK_F11;
      DIK_F12          : Result := VK_F12;
      DIK_NUMPADENTER  : Result := VK_RETURN;
      DIK_RCONTROL     : Result := VK_CONTROL;
      DIK_DIVIDE       : Result := VK_DIVIDE;
      DIK_RMENU        : Result := VK_MENU;
      DIK_HOME         : Result := VK_HOME;
      DIK_UP           : Result := VK_UP;
      DIK_PRIOR        : Result := VK_PRIOR;
      DIK_LEFT         : Result := VK_LEFT;
      DIK_RIGHT        : Result := VK_RIGHT;
      DIK_END          : Result := VK_END;
      DIK_DOWN         : Result := VK_DOWN;
      DIK_NEXT         : Result := VK_NEXT;
      DIK_INSERT       : Result := VK_INSERT;
      DIK_DELETE       : Result := VK_DELETE;
      DIK_LWIN         : Result := VK_LWIN;
      DIK_RWIN         : Result := VK_RWIN;
      DIK_APPS         : Result := VK_APPS;
    end;
  end;
{$IfDef DX9}
type
  TDIKeyboardState = array[0..255] of Byte;
{$EndIf}
var
  j: Integer;
  i: TDXInputState;
  dikb: TDIKeyboardState;
begin
  FillChar(FKeyStates, SizeOf(FKeyStates), 0);
  FStates := [];

  if (not FInitialized) or FDXInput.FActiveOnly and (GetForegroundWindow<>FDXInput.FForm.Handle) then
    Exit;

  if FDevice<>nil then
  begin
    FillChar(dikb, SizeOf(dikb), 0);

    if GetDeviceState(SizeOf(dikb), dikb) then
    begin
      {  The DirectInput key code is converted into the Windows virtual key code.  }
      for j:=Low(dikb) to High(dikb) do
        if dikb[j] and $80<>0 then
          FKeyStates[Byte(DIKEYtoVK(j))] := $80;
    end;
  end else
  begin           
    GetKeyboardState(FKeyStates);
  end;

  for i:=LOW(TDXInputState) to HIGH(TDXInputState) do
  begin
    for j:=0 to 2 do
      if Keys[KeyAssigns[i, j]] then
      begin
        FStates := FStates + [i];
        Break;
      end;
  end;
end;

procedure TKeyboard.ReadAssigns(Stream: TStream);
begin
  Stream.ReadBuffer(KeyAssigns, SizeOf(KeyAssigns));
end;

procedure TKeyboard.WriteAssigns(Stream: TStream);
begin
  Stream.WriteBuffer(KeyAssigns, SizeOf(KeyAssigns));
end;

{  TMouse  }

constructor TMouse.Create(DXInput: TCustomDXInput);
begin
  inherited Create(DXInput);
  BindInputStates := False;
  Enabled := False;
end;               

function TMouse.GetX: Integer;
begin
  Result := Fdims.lX;
end;

function TMouse.GetY: Integer;
begin
  Result := Fdims.lY;
end;

function TMouse.GetZ: Integer;
begin
  Result := Fdims.lZ;
end;

procedure TMouse.Finalize;
begin
  FillChar(Fdims, SizeOf(Fdims), 0);
  inherited Finalize;
end;

procedure TMouse.Initialize;
begin
  Finalize;

  if (not FEnabled) or (csDesigning in FDXInput.ComponentState) then Exit;

  if FDXInput.FDInput<>nil then
  begin
    if FDXInput.FDInput.CreateDevice(GUID_SysMouse, FDevice, nil)<>DI_OK then Exit;
    FDevice.SetDataFormat(c_dfDIMouse);
  end else
    raise EDXInputError.Create(SNecessaryDirectInputUseMouse);

  FButtonCount := 3;

  inherited Initialize;
end;

procedure TMouse.Update;
begin
  FillChar(Fdims, SizeOf(Fdims), 0);
  FStates := [];

  if (not FInitialized) or FDXInput.FActiveOnly and (GetForegroundWindow<>FDXInput.FForm.Handle) then
    Exit;

  if FDevice<>nil then
  begin
    FillChar(Fdims, SizeOf(Fdims), 0);
    GetDeviceState(SizeOf(Fdims), Fdims);
  end;

  if Fdims.lX<0 then FStates := FStates + [isLeft];
  if Fdims.lX>0 then FStates := FStates + [isRight];
  if Fdims.lY<0 then FStates := FStates + [isUp];
  if Fdims.lY>0 then FStates := FStates + [isDown];

  if Fdims.rgbButtons[0] and $80<>0 then FStates := FStates + [isButton1];
  if Fdims.rgbButtons[1] and $80<>0 then FStates := FStates + [isButton2];
  if Fdims.rgbButtons[2] and $80<>0 then FStates := FStates + [isButton3];
end;

{  TJoystick  }

function SetDWORDProperty(pdev: IDirectInputDevice; guidProperty: PGUID;
  dwObject, dwHow, dwValue: DWORD): HResult;
var
  dipdw: TDIPropDWORD;
begin
  dipdw.diph.dwSize       := SizeOf(dipdw);
  dipdw.diph.dwHeaderSize := SizeOf(dipdw.diph);
  dipdw.diph.dwObj        := dwObject;
  dipdw.diph.dwHow        := dwHow;
  dipdw.dwData            := dwValue;

  Result := pdev.SetProperty(guidProperty, dipdw.diph);
end;

function SetRangeProperty(pdev: IDirectInputDevice; guidProperty: PGUID;
  dwObject, dwHow, Value: DWORD): HResult;
var
  diprg: TDIPropRange;
begin
  diprg.diph.dwSize       := SizeOf(diprg);
  diprg.diph.dwHeaderSize := SizeOf(diprg.diph);
  diprg.diph.dwObj        := dwObject;
  diprg.diph.dwHow        := dwHow;
  diprg.lMin              := -Value;
  diprg.lMax              := +Value;

  Result := pdev.SetProperty(guidProperty, diprg.diph);
end;

constructor TJoystick.Create(DXInput: TCustomDXInput);
begin
  inherited Create(DXInput);
  FAutoCenter := True;

  FID := 0;

  DeadZoneX := 50;
  DeadZoneY := 50;
  DeadZoneZ := 50;

  RangeX := 1000;
  RangeY := 1000;
  RangeZ := 1000;
end;

function TJoystick.GetX: Integer;
begin
  Result := Fdijs.lX;
end;

function TJoystick.GetY: Integer;
begin
  Result := Fdijs.lY;
end;

function TJoystick.GetZ: Integer;
begin
  Result := Fdijs.lZ;
end;

procedure TJoystick.Finalize;
begin
  FID2 := -1;
  FillChar(Fdijs, SizeOf(Fdijs), 0);
  FillChar(FJoyCaps, SizeOf(FJoyCaps), 0);
  inherited Finalize;
end;

function TJoystick.GetCooperativeLevel: Integer;
begin
  if not FAutoCenter then
    Result := DISCL_EXCLUSIVE or DISCL_FOREGROUND
  else
    Result := inherited GetCooperativeLevel;
end;
                                                        
function TJoystick_EnumJoysticksCallback(const lpddi: TDIDeviceInstanceA;
  pvRef: Pointer): HRESULT; stdcall;
begin
  Result := Integer(DIENUM_CONTINUE);

  with TJoystick(pvRef) do
  begin
    if FEnumIndex=FID then
    begin
      FDeviceGUID := lpddi.guidInstance;
      FEnumFlag := True;
      Result := Integer(DIENUM_STOP);
      Exit;
    end;
    Inc(FEnumIndex);
  end;
end;

procedure TJoystick.Initialize;
var
  i, j: Integer;
  devcaps: TDIDevCaps;
begin        
  Finalize;

  if (not FEnabled) or (FID<0) or (csDesigning in FDXInput.ComponentState) then Exit;

  try
    try
      if FDXInput.FDInput<>nil then
      begin
        {  Device search.  }
        FEnumFlag := False;
        FEnumIndex := 0;

        FDXInput.FDInput.EnumDevices({DIDEVTYPE_JOYSTICK}4, @TJoystick_EnumJoysticksCallback,
          Self, DIEDFL_ATTACHEDONLY);

        if not FEnumFlag then Exit;

        {  Device making.  }
        if FDXInput.FDInput.CreateDevice(FDeviceGUID, FDevice, nil)<>DI_OK then Exit;

        devcaps.dwSize := SizeOf(devcaps);
        if FDevice.GetCapabilities(devcaps)=DI_OK then
        begin
          FButtonCount := devcaps.dwButtons;
          if devcaps.dwFlags and DIDC_FORCEFEEDBACK<>0 then
            FForceFeedbackDevice := True;
        end;

        //if FDXInput.FDInput.CreateDevice(GUID_Joystick, FDevice, nil)<>DI_OK then Exit;   get out by Paul van Dinther

        {  Device data format (TDIDataFormat) making.  }

        with FDataFormat do
        begin
          dwFlags := DIDF_ABSAXIS;
          dwDataSize := SizeOf(Fdijs);
        end;            

        if not SetDataFormat then
        begin
          FDevice := nil;
          Exit;
        end;
         
        AutoCenter := FAutoCenter;

        for i:=Low(FDeadZone) to High(FDeadZone) do
          SetDeadZone(i, FDeadZone[i]);

        for i:=Low(FRange) to High(FRange) do
          SetRange(i, FRange[i]);

        FDevice2 := FDevice as IDirectInputDevice2;
      end;
    except
      Finalize;
      raise;
    end;
  finally
    if FDevice=nil then
    begin
      {  Because DirectInput cannot be used,  the GetJoyPosEx function is used.  }
      FID2 := -1;

      j := 0;
      for i:=0 to 255 do
      begin
        FillChar(FJoyCaps, SizeOf(FJoyCaps), 0);
        if joyGetDevCaps(i, @FJoyCaps, SizeOf(FJoyCaps))=JOYERR_NOERROR then
        begin
          if FID=j then
          begin
            FID2 := i;
            Break;
          end;
          Inc(j);
        end;
      end;

      if FID2<>-1 then
      begin
        if joyGetDevCaps(FID2, @FJoyCaps, SizeOf(FJoyCaps))=JOYERR_NOERROR then
        begin
          FButtonCount := FJoyCaps.wNumButtons;
        end else
        begin
          FID2 := -1;
        end;
      end;
    end;
  end;

  inherited Initialize;
end;

procedure TJoystick.SetAutoCenter(Value: Boolean);
begin
  FAutoCenter := Value;

  if FDevice<>nil then
    SetDWORDProperty(FDevice, DIPROP_AUTOCENTER, 0, DIPH_DEVICE, Ord(Value));
end;

procedure TJoystick.SetID(Value: Integer);
begin
  if Value<>FID then
  begin
    FID := Value;
    Initialize;
  end;
end;

function TJoystick.GetDeadZone(Obj: Integer): Integer;
begin
  Result := 0;
  if (Obj>=Low(FDeadZone)) and (Obj<High(FDeadZone)) then
    Result := FDeadZone[Obj];
end;

function TJoystick.GetRange(Obj: Integer): Integer;
begin
  Result := 0;
  if (Obj>=Low(FRange)) and (Obj<High(FRange)) then
    Result := FRange[Obj];
end;

procedure TJoystick.SetDeadZone(Obj: Integer; Value: Integer);
begin
  if (Obj<Low(FDeadZone)) or (Obj>=High(FDeadZone)) then Exit;

  if Value<0 then Value := 0;
  if Value>100 then Value := 100;

  if Obj=Integer(@PDIJoyState2(nil).rgdwPOV[0]) then
  begin
    FDeadZone[Obj] := -1;
    Exit;
  end;

  FDeadZone[Obj] := Value;

  if FDevice<>nil then
  begin
    if SetDWORDProperty(FDevice, DIPROP_DEADZONE, Obj, DIPH_BYOFFSET, Value*100)<>DI_OK then
      FDeadZone[Obj] := -1;
  end;
end;

procedure TJoystick.SetRange(Obj: Integer; Value: Integer);
begin
  if (Obj<Low(FRange)) or (Obj>=High(FRange)) then Exit;

  if Value<0 then Value := 0;

  if Obj=Integer(@PDIJoyState2(nil).rgdwPOV[0]) then
  begin
    FRange[Obj] := -1;
    Exit;
  end;

  FRange[Obj] := Value;

  if FDevice<>nil then
  begin
    if SetRangeProperty(FDevice, DIPROP_RANGE, Obj, DIPH_BYOFFSET, Value)<>DI_OK then
      FRange[Obj] := -1;
  end;
end;

procedure TJoystick.Update;

  function ConvertValue(Value, wXmax, wXmin, DeadZone, Range: Integer): Integer;
  var
    c, w: Integer;
  begin
    Result := 0;

    c := (wXmax - wXmin) div 2;
    Value := Value-c;

    w := c*DeadZone div 100;
    c := c - w;

    if c=0 then Exit;

    if Abs(Value)>w then
    begin
      if Value>0 then
        Result := MulDiv(Value-w, Range, c)
      else
        Result := MulDiv(Value+w, Range, c);
    end;
  end;

var
  i: Integer;
  JoyInfo: TJoyInfoEx;
begin
  FillChar(Fdijs, SizeOf(Fdijs), 0);
  FStates := [];

  if (not FInitialized) or FDXInput.FActiveOnly and (GetForegroundWindow<>FDXInput.FForm.Handle) then
    Exit;

  if FDevice<>nil then
  begin
    FDevice2.Poll;
    GetDeviceState(SizeOf(Fdijs), Fdijs);
  end else
  begin
    if FID2<>-1 then
    begin
      JoyInfo.dwSize := SizeOf(JoyInfo);
      JoyInfo.dwFlags := JOY_RETURNX or JOY_RETURNY or JOY_RETURNZ or JOY_RETURNPOV or
        JOY_RETURNBUTTONS or JOY_RETURNCENTERED;

      joyGetPosEx(FID2, @JoyInfo);

      with FJoyCaps do
        Fdijs.lX := ConvertValue(JoyInfo.wXpos, wXmax, wXmin, FDeadZone[DIJOFS_X], FRange[DIJOFS_X]);

      with FJoyCaps do
        Fdijs.lY := ConvertValue(JoyInfo.wYpos, wYmax, wYmin, FDeadZone[DIJOFS_Y], FRange[DIJOFS_Y]);

      with FJoyCaps do
        Fdijs.lZ := ConvertValue(JoyInfo.wZpos, wZmax, wZmin, FDeadZone[DIJOFS_Z], FRange[DIJOFS_Z]);

      Fdijs.rgdwPOV[0] := JoyInfo.dwPOV;

      for i:=0 to FJoyCaps.wNumButtons-1 do
        if JoyInfo.wButtons and (1 shl i)<>0 then
          Fdijs.rgbButtons[i] := $80;
    end;
  end;

  for i:=0 to 31 do
    if Fdijs.rgbButtons[i] and $80<>0 then
      FStates := FStates + [TDXInputState(Ord(isButton1)+i)];

  if Fdijs.lX<0 then FStates := FStates + [isLeft];
  if Fdijs.lX>0 then FStates := FStates + [isRight];
  if Fdijs.lY<0 then FStates := FStates + [isUp];
  if Fdijs.lY>0 then FStates := FStates + [isDown];
end;

{  TCustomDXInput  }

var
  FDirectInput: IDirectInput;
  FDirectInputCount: Integer;

procedure InitDirectInput(out DI: IDirectInput);
type
  TDirectInputCreate = function(hinst: THandle; dwVersion: DWORD;
    out ppDI: IDirectInputA; punkOuter: IUnknown): HRESULT; stdcall;
begin
  if FDirectInput=nil then
  begin
    try
      TDirectInputCreate(DXLoadLibrary('DInput.dll', 'DirectInputCreateA'))
        (HInstance, DIRECTINPUT_VERSION, FDirectInput, nil);
    except
      FDirectInput := nil;
    end;
  end;

  DI := FDirectInput;
  if FDirectInput<>nil then
    Inc(FDirectInputCount);
end;

procedure FinDirectInput(var DI: IDirectInput);
begin
  if DI<>nil then
  begin
    DI := nil;
    Dec(FDirectInputCount);
    if FDirectInputCount<=0 then
    begin
      FDirectInputCount := 0;
      FDirectInput := nil;
    end;
  end;
end;

constructor TCustomDXInput.Create(AOwner: TComponent);
var
  Component: TComponent;
begin
  inherited Create(AOwner);

  FDevice := TList.Create;

  FActiveOnly := True;
  FJoystick := TJoystick.Create(Self);
  FKeyboard := TKeyboard.Create(Self);
  FMouse := TMouse.Create(Self);
  FUseDirectInput := True;

  Component := Owner;
  while (Component<>nil) and (not (Component is TCustomForm)) do
    Component := Component.Owner;
  if Component=nil then
    raise EDXInputError.CreateFmt(SNoForm, ['Owner']);
  FForm := TCustomForm(Component);

  FSubClass := TControlSubClass.Create(FForm, FormWndProc);
end;

destructor TCustomDXInput.Destroy;
begin
  Finalize;
  FJoystick.Free;
  FKeyboard.Free;
  FMouse.Free;
  FSubClass.Free;
  while FDevice.Count>0 do
    TCustomInput(FDevice[FDevice.Count-1]).Free;
  FDevice.Free;
  inherited Destroy;
end;

procedure TCustomDXInput.FormWndProc(var Message: TMessage; DefWindowProc: TWndMethod);

  procedure AcquireDevice;
  var
    i: Integer;
  begin
    for i:=0 to FDevice.Count-1 do
      TCustomInput(FDevice[i]).Acquire;
  end;

begin
  case Message.Msg of
    WM_CREATE:
        begin
          {  Window handle of Form changed.  }
          DefWindowProc(Message);
          SetWindowHandle;
          Exit;
        end;
    WM_ACTIVATEAPP:
        begin
          DefWindowProc(Message);
          if TWMActivateApp(Message).Active then
            AcquireDevice;
          Exit;
        end;
    WM_ACTIVATE:
        begin
          DefWindowProc(Message);
          if TWMActivate(Message).Active<>WA_INACTIVE then
            AcquireDevice;
          Exit;
        end;
  end;
  DefWindowProc(Message);
end;

procedure TCustomDXInput.Finalize;
var
  i: Integer;
begin
  for i:=0 to FDevice.Count-1 do
    TCustomInput(FDevice[i]).Finalize;
  FinDirectInput(FDInput);
end;

procedure TCustomDXInput.Loaded;
begin
  Initialize;
end;

procedure TCustomDXInput.Initialize;
var
  i: Integer;
begin
  Finalize;
  if not (csDesigning in ComponentState) then
  begin
    if FUseDirectInput then InitDirectInput(FDInput);

    for i:=0 to FDevice.Count-1 do
      TCustomInput(FDevice[i]).Initialize;

    SetWindowHandle;

    Update;
  end;
end;

procedure TCustomDXInput.SetActiveOnly(Value: Boolean);
begin
  if Value<>FActiveOnly then
  begin
    FActiveOnly := Value;
    if [csLoading, csReading]*ComponentState=[] then SetWindowHandle;
  end;
end;

procedure TCustomDXInput.SetJoystick(Value: TJoystick);
begin
  FJoystick.Assign(Value);
end;

procedure TCustomDXInput.SetKeyboard(Value: TKeyboard);
begin
  FKeyboard.Assign(Value);
end;

procedure TCustomDXInput.SetMouse(Value: TMouse);
begin
  FMouse.Assign(Value);
end;

procedure TCustomDXInput.SetUseDirectInput(Value: Boolean);
begin
  if FUseDirectInput<>Value then
  begin
    FUseDirectInput := Value;
    Initialize;
  end;
end;

procedure TCustomDXInput.SetWindowHandle;
var
  i: Integer;
begin
  for i:=0 to FDevice.Count-1 do
    TCustomInput(FDevice[i]).SetWindowHandle(FForm.Handle);
end;

procedure TCustomDXInput.Update;
var
  j: Integer;
  i: TDXInputState;
  s: TDXInputStates;
begin
  s := [];

  for j:=0 to FDevice.Count-1 do
  begin
    TCustomInput(FDevice[j]).Update;
    if TCustomInput(FDevice[j]).FBindInputStates then
      s := s + TCustomInput(FDevice[j]).States;
  end;

  for i:=Low(TDXInputState) to High(TDXInputState) do
  begin
    if (i in s) and (not (i in FOldStates)) then
      FStates := FStates + [i];
    if (not (i in s)) and (i in FOldStates) then
      FStates := FStates - [i];
  end;

  FOldStates := s;
end;

end.