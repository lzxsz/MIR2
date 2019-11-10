program baseproject;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  isoMath in 'isoMath.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'no.2 games intro';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
