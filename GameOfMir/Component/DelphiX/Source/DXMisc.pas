unit DXmisc;
// Contains miscellaneous code
interface
uses classes,controls;
type
   // This obtains the co-ords for the mouse relative to a control
  TMousePos = class(Tobject)
   Private
     { Private declarations }
     // Data
     fControl : TControl;

     fMouseX : integer;
     fMouseY : integer;
     fXDelta : integer;
     fYDelta : integer;
     // used to scale the mouse input
     fSensitivity : Single;
     // Options
     fClipToControl : boolean;
   Protected
     { Protected declarations }
     Procedure SetClipState(Value : boolean);
   Public
     { Public declarations }
     Constructor Create(Control : TControl);
     Destructor Destroy; Override;
     // Sets the control to use
     Procedure SetControl(AControl : TControl);
     // Grabs the latest mouse co-ords
     Procedure Update;
     // Relative to the parent control
     Property MouseX : integer read fMouseX;
     Property MouseY : integer read fMouseY;
     Property XDelta : integer read fXDelta;
     Property YDelta : integer read fYDelta;
     // The sensitivity of the mouse
     property Sensitivity : Single read fSensitivity write fSensitivity;
     Property ClipToControl : Boolean read fClipToControl write SetClipState;

     Property Control : TControl read fControl write SetControl;
   Published
     { Published declarations }
   end;

 // This is an example of how to cap the frame rate
 // this has NOT been optimized and is just to hide the relatively
 // mess code needed to properly calc the time delta for a frame
 // and the time delta since the last render
 TTiming = class(Tobject)
  Protected
    { Protected declarations }
    // Used to implement frame capping
    fGraphicsTimeDelta : longword;
    LastTimeFrame      : longword;
    // the number of ms each frame has in its budget
    FrameRateBudget    : longword; // this is just for the graphics system
    // see the properties section
    fTimeDelta         : longword;

    TimeFrame          : longword;
    fFrameRate         : longword;
    fFrameRateGoal     : longword;

    fNoGraphics : boolean;
    // sets up various timing stuff
    Procedure InitTiming(FrameRate : longword);
  public
    { Public declarations }
    Constructor Create(AFrameRateGoal : longword);
    // Calculates the time delta from the last frame
    Procedure CalcNewTimeDelta;
    // Checks if the designated time till the next render has passed
    Function TimeToRender : boolean;
    // Prepares internal info for the next frame
    Procedure UpdateGraphicsTimeDelta;
    Procedure CalcFrameRate;

    Property GraphicsTimeDelta : longword read fGraphicsTimeDelta;
    // used to determine how much time has elapsed from the last frame in ms
    Property TimeDelta : longword read fTimeDelta;
    // The timestamp for the current frame
    property FrameStamp : longword read TimeFrame;
    // The frame rate that is being achieved
    Property FrameRate  : longword read fFrameRate;
    // The goal frame rate for the frame skipping mechanism
    // This also Limits the frame rate to this to
    Property FrameRateGoal : longword read fFrameRateGoal write InitTiming;

    // TimeTorender always returns false, used to disable graphics stuff
    Property NoGraphics : boolean read fNoGraphics write fNoGraphics;
  end;

  TStateMachine = class;
  
  TState = class(Tobject) // a state aware class
   Private
    fStateIndex : integer;
    fStateMachine : TStateMachine;
   Public
    Constructor Create; virtual;

    Procedure Execute; virtual; abstract;
    Property StateIndex : integer read fStateIndex;
    Property StateMachine : TStateMachine read fStateMachine;
   end;
   
  // This is a state machine which removes the need for large case statements when executing the current state
  TStateMachine = class(Tobject)
   Private
     { Private declarations }
   Protected
     { Protected declarations }
     // Holds a list of the valid states
     fStatesList : Tlist;
     // the number of states
     fStates : integer;
     // The max number of allowed states
     fMaxStates : integer; 
     // The current state
     fCurrentState : TState;     
//     Function GetState(index :integer) : TState; virtual;
   Public
     { Public declarations }
    Constructor Create;
    Destructor Destroy; override;
    // This registers a state, if the state exists then it is updated
    // Dont pass < 0 as the state constant
    Procedure AddState(State : TState); virtual;
    // This removes a registerd state
    Procedure RemoveState(State : TState);virtual;
    // This clears all the states
    Procedure ClearStates; virtual;

    // allows easy state changes
    Procedure ActivateNextState; virtual;
    // The current state's id
    Property CurrentState : TState read fCurrentState write fCurrentState;

    // The Number of valid states                   
    Property States : integer read fStates;
    Property MaxStates : integer read fMaxStates write fMaxStates;
    {
    // Allows direct access to the states of an object
    Property StateList[index :integer] : TState read GetState;
    }
    Property StateList : Tlist read fStatesList;
   end;
const
 // This is the default strating number of states the TStateMachine will allocate
 StartStates = 16; // This is also what it allocates when it tries to add a new state
 MaxNumStates = 255;  // this is the max number of states allowed. Why would you want more :)
 
// Scans a Component and the components owned by the Component for a Component of the class type 'Classtype'
function FindComponentType(Aowner : TComponent; Classtype: TComponentClass) : TComponent;
implementation
uses windows,Sysutils,mmsystem;

function FindComponentType(Aowner : TComponent; Classtype: TComponentClass) : TComponent;
var
 index : integer;
begin
if not assigned(AOwner) then
  begin
  result := nil;
  exit;
  end;
if AOwner is Classtype then
  begin
  result := AOwner;
  end
else
  begin
  // For some reason, when in the designer AOwner.ComponentIndex = -1!
  // thus this search algo would failed in designer mode
  for index := 0 to AOwner.ComponentCount - 1 do
    begin
    if AOwner.Components[index] is Classtype then
      begin
      result := AOwner.Components[index];
      exit;
      end;
    end;
  result := nil;
  end;
end;

// -----------------------------------------------------------------------------
// TTiming
// -----------------------------------------------------------------------------

Constructor TTiming.Create(AFrameRateGoal : longword);
begin
Inherited create;
FrameRateGoal := AFrameRateGoal;
InitTiming(FrameRateGoal);
end; {TTiming}

Procedure TTiming.InitTiming(FrameRate : longword);
begin
fFrameRateGoal     := FrameRate;
FrameRateBudget    := 1000 div fFrameRateGoal;
fGraphicsTimeDelta := 0;
fTimeDelta         := 0;
TimeFrame          := timegettime;
LastTimeFrame      := TimeFrame;
end; {InitTiming}

Procedure TTiming.CalcNewTimeDelta;
var
  NewTimeFrame : Longword;
begin
// update the time delta & time frame stamps
NewTimeFrame := TimeGetTime ;
fTimeDelta := NewTimeFrame - TimeFrame;
TimeFrame := NewTimeFrame;
end; {CalcNewTimeDelta}

Procedure TTiming.UpdateGraphicsTimeDelta;
begin
// get how long it took to render the frame
LastTimeFrame :=timegettime;
fGraphicsTimeDelta := 0;
end;

Procedure TTiming.CalcFrameRate;
begin
if GraphicsTimeDelta <> 0 then
  fFrameRate := 1000 div GraphicsTimeDelta
else
  fFrameRate := 0;
end; {CalcFrameRate}

Function TTiming.TimeToRender : boolean;
begin
// Check to see if we can update the screen
fGraphicsTimeDelta := Timegettime - LastTimeFrame;
result := (GraphicsTimeDelta >= FrameRateBudget) and (not fNoGraphics);
end; {TimeToRender}

// -----------------------------------------------------------------------------
// TMousePos
// -----------------------------------------------------------------------------

Constructor TMousePos.Create(Control : TControl);
begin
Inherited Create;
if not assigned(Control) then
  Raise Exception.Create('Parent can''''t = nil');
fSensitivity := 1.0;
fClipToControl := true;
SetControl(Control);
end; {Create}

Destructor TMousePos.Destroy;
begin
SetControl(nil);
Inherited;
end; {Destroy}

Procedure TMousePos.SetControl(AControl : TControl);
begin
assert(self <> nil);
if assigned(AControl) then
  begin
  fControl := AControl;
  // This gets the intitial value
  Update;
  // This gets the correct mouse X,Y deltas
  Update;
  end
else
  begin
  fControl := nil;
  end;
end; {SetControl}

Procedure TMousePos.SetClipState(Value : boolean);
begin
if fClipToControl <> value then
  begin
  fClipToControl := Value;
  // Re-obtain the co-ords with the correct option
  Update;
  end;
end; {SetClipState}

Procedure TMousePos.Update;
var
  pos : TPoint;
begin
// Get the latest mouse info
pos := mouse.CursorPos;
// Convert them to relative to the Control
pos := fControl.ScreenToClient(pos);
if fClipToControl then
  begin
  if pos.x >= fControl.width then
    pos.x := fControl.width - 1
  else if pos.x < 0 then
    pos.x := 0;
  if pos.Y >= fControl.Height then
    pos.Y := fControl.Height - 1
  else if pos.Y < 0 then
    pos.Y := 0;
  end;
// Update the mouse delta's
// fmouse? = old mouse pos
// pos.? = new mouse pos
fXDelta := pos.X - fMouseX;
fYDelta := pos.Y - fMouseY;
// Scale the mouse co-ords
if fSensitivity - 1.0 > 0.00001  then
  begin
  fMouseX := fMouseX + Trunc(fXDelta * fSensitivity);
  fMouseY := fMouseY + Trunc(fYDelta * fSensitivity);
  end
else
  begin
  fMouseX := pos.X;
  fMouseY := pos.Y;
  end;
end; {Update}

// -----------------------------------------------------------------------------
// TStateMachine
// -----------------------------------------------------------------------------
Constructor TStateMachine.Create;
begin
inherited;
fMaxStates := MaxNumStates;
fStatesList := Tlist.create;
end; {Create}

Destructor TStateMachine.Destroy;
begin
ClearStates;
fStatesList.free;
inherited;
end; {Destroy}

Procedure TStateMachine.AddState(State : TState);
begin
if (fStatesList.IndexOf(State) = -1) and
   (fStates < MaxStates) then
  begin
  State.fStateIndex := fStatesList.add(State);
  State.fStateMachine := self;
  if fCurrentState = nil then
   fCurrentState := state;
  inc(fStates);
  end;
end; {AddState}

Procedure TStateMachine.RemoveState(State : TState);
var
 index : integer;
begin
index := fStatesList.IndexOf(State);
if (index <> -1) then
  begin
  if fCurrentState = state then
   fCurrentState := nil;
  fStatesList.Delete(index);
  Dec(fStates);
  end;
end; {RemoveState}

Procedure TStateMachine.ClearStates;
var
 state : Tstate;
begin
while fStatesList.count <> 0 do
  begin
  state := fStatesList.Items[fStatesList.count - 1];
  state.free;
  fStatesList.Delete(fStatesList.count - 1);
  end;
end; {ClearStates}

Procedure TStateMachine.ActivateNextState;
var
 index : integer;
begin
if fStatesList.count = 0 then
  exit;
if fCurrentState = nil then
  fCurrentState:= fStatesList[0];
index := fCurrentState.StateIndex;
inc(index);
if index >= fStatesList.count - 1 then
  index := 0;
fCurrentState := Tstate(fStatesList[index]);
end; {ActivateNextState}

Constructor Tstate.Create;
begin
Inherited Create;
end; {Create}

end.
