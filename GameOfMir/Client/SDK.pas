unit SDK;

interface

uses
  Windows, Classes;

type

  TGList=Class(TList)
  private
    CriticalSection:TRTLCriticalSection;

  public
    Constructor Create;
    Destructor  Destroy;override;

    procedure Lock;
    Procedure UnLock;
  end;

  TGStringList=Class(TStringList)
  private
    CriticalSection:TRTLCriticalSection;

  public
    Constructor Create;
    Destructor  Destroy;override;
    
    procedure Lock;
    Procedure UnLock;
  end;

implementation


{ TGList }

constructor TGList.Create;
begin
  inherited;
  InitializeCriticalSection(CriticalSection);
end;

destructor TGList.Destroy;
begin
  DeleteCriticalSection(CriticalSection);
  inherited;
end;

procedure TGList.Lock;
begin
  EnterCriticalSection(CriticalSection);
end;

procedure TGList.UnLock;
begin
  LeaveCriticalSection(CriticalSection);
end;

{ TGStringList }

constructor TGStringList.Create;
begin
  inherited;
  InitializeCriticalSection(CriticalSection);
end;

destructor TGStringList.Destroy;
begin
  DeleteCriticalSection(CriticalSection);
  inherited;
end;

procedure TGStringList.Lock;
begin
  EnterCriticalSection(CriticalSection);
end;

procedure TGStringList.UnLock;
begin
  LeaveCriticalSection(CriticalSection);
end;

end.

