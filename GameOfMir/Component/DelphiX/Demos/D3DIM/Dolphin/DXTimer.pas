unit DXTimer;  // 22-OCT-98 as (Arne Schäpers)
{ Timer mit theoretischer Auflösung von einer Millisekunde
  (praktisch nutzbar: ca. 5 msec). Verwendet pro Komponente
  einen eigenen Thread. Sichtbare Unterschiede gegenüber
  TTimer:
  1. höhere zeitliche Auflösung
  2. absoluter Zeitrahmen
  3. OnAsyncTimer wird - falls besetzt - vor OnTimer im Kontext
     des Hintergrund-Threads aufgerufen, macht die sinnvolle
     Auslastung von Mehrprozessorsystemen möglich.

  Overhead:                       P-166 Win95
    1 Timer, 20 msec (50 Events)      4%      
    5 Timer, 20 msec (250 Events)    13%
    25 Timer, 100 msec (250 Events)  16%
    25 Timer, 20 msec (1000 Events)  37%
    1 Timer, 1 msec (1000 Events)    35%

  Grenze für Win95: 3000 Events/sec sync, 15000 Events async
  Bei 1000 Events/sec benötigt Synchronize rund 15%

  MODs 06-MAR-99: Typecasts von MaxWait, NextTick wg. Delphi 4.
  Vernünftig unter einen Hut bringen läßt sich das nicht, weil
  D3 auch bei Cardinal gnadenlos ein Vorzeichen reinhaut...  
}
interface
uses Windows, SysUtils, Classes, MMSystem;

type
  TDXTimer = class(TComponent)
  private
    FInterval: Cardinal;  // echte Millisekunden
    FOnTimer, FOnAsyncTimer: TNotifyEvent;
    FEnabled: Boolean;
    StartTickTime, NextTick: Integer;  // Zeitrahmen
    TimerThread: TThread;  // TDXTimerThread (implementation)
    procedure UpdateTimer;  // XRef: Set..., Destroy
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: Cardinal);
    procedure SetOnTimer(Value: TNotifyEvent);
    procedure SetOnAsyncTimer(Value: TNotifyEvent);
  protected
    procedure Timer;  // per Synchronize
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Enabled: Boolean read FEnabled
      write SetEnabled default True;
    property Interval: Cardinal read FInterval
      write SetInterval default 20;
    property OnTimer: TNotifyEvent  // synchron
        read FOnTimer write SetOnTimer;
    property OnAsyncTimer: TNotifyEvent  // asynchron
        read FOnAsyncTimer write SetOnAsyncTimer;
  end;

implementation

type  // intern verwendeter Thread
  TDXTimerThread = class(TThread)
    private
      Owner: TDXTimer;
      TimerEvent: THandle;  // zum Warten und für Updates
    public
      constructor Create(AOwner: TDXTimer);
      destructor Destroy; override;
      procedure Execute; override;
      procedure Terminate;
  end;

constructor TDXTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := True; FInterval := 20;
  TimerThread := TDXTimerThread.Create(Self);
end;

destructor TDXTimer.Destroy;
begin
  FEnabled := False; UpdateTimer;  // Timer aus
  TimerThread.Terminate;
  inherited Destroy;
end;

procedure TDXTimer.UpdateTimer;
begin
  StartTickTime := timeGetTime;
  NextTick := StartTickTime+Integer(Interval);
  SetEvent(TDXTimerThread(TimerThread).TimerEvent);
end;

procedure TDXTimer.SetEnabled(Value: Boolean);
begin
  if Value = FEnabled then Exit;
  FEnabled := Value; UpdateTimer;
end;

procedure TDXTimer.SetInterval(Value: Cardinal);
begin
  if Value = FInterval then Exit;
  FInterval := Value; UpdateTimer;
end;

procedure TDXTimer.SetOnTimer(Value: TNotifyEvent);
begin
  FOnTimer := Value; UpdateTimer;
end;

procedure TDXTimer.SetOnAsyncTimer(Value: TNotifyEvent);
begin
  FOnAsyncTimer := Value; UpdateTimer;
end;

procedure TDXTimer.Timer;
begin
  if Assigned(FOnTimer) then FOnTimer(Self);
end;


// ------------- TDXTimerThread -----------------
constructor TDXTimerThread.Create(AOwner: TDXTimer);
begin
  inherited Create(False);
  Owner := AOwner;
  TimerEvent := CreateEvent(nil, False, False, nil);
  FreeOnTerminate := True;
end;

procedure TDXTimerThread.Terminate;
begin
  inherited Terminate;
  SetEvent(TimerEvent);  // sonst wartet der ewig...
end;

destructor TDXTimerThread.Destroy;
begin
  CloseHandle(TimerEvent);
  inherited Destroy;
end;

procedure TDXTimerThread.Execute;
var MaxWait, WaitResult: Integer;
begin
  while not Terminated do
  begin
    with Owner do
      if Enabled and (Assigned(FOnTimer) or
        Assigned(FOnAsyncTimer)) then
      begin
        MaxWait := Cardinal(NextTick)-timeGetTime;
        if MaxWait <= 0 then
        begin  // Breakpoints bei der Entwicklung erzeugen sonst
          if -MaxWait > 10*Integer(Interval)  // *sehr* eilige Timer..
             then NextTick := timeGetTime;
          MaxWait := 0;
        end;
      end
       else MaxWait := Integer(INFINITE);
    if MaxWait = 0 then WaitResult := WAIT_TIMEOUT
     else WaitResult := WaitForSingleObject(TimerEvent,MaxWait);
    case WaitResult of
      WAIT_OBJECT_0:  ; // neue Werte
      WAIT_TIMEOUT:
       with Owner do
       begin
         Inc(NextTick,Interval);
         // zuerst ein eventueller asynchroner, dann ein
         // synchronisierter Aufruf
         if Assigned(FOnASyncTimer) then OnASyncTimer(Owner);
         if Assigned(FOnTimer) then Synchronize(Timer)
       end;
    else
      raise Exception.Create
        (Format('DXTimer: WaitResult = %d?',[WaitResult]));
    end;
  end;
end;

end.
