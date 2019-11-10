program sample;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  typer3D in 'typer3D.pas',
  terrain in 'terrain.pas',
  feld_1 in 'feld_1.pas',
  HWCounter in 'HWCounter.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Direct3D Sample';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
