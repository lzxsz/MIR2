program BackOut;

uses
  Forms,
  unit_Backout in 'unit_Backout.pas' {GameForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TGameForm, GameForm);
  Application.Run;
end.
