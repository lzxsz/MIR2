program Sample;

uses
  Windows,
  Forms,
  Main in 'Main.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Stars';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
