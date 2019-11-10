program Chat;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  Config in 'Config.pas' {ConfigForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
