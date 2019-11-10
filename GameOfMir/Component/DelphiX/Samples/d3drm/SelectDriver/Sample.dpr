program sample;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  Config in '..\selectdriver\Config.pas' {ConfigForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Direct3D Sample';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
