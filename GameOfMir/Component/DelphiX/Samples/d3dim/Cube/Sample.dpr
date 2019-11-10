program sample;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  D3DUtils in '..\D3DUtils.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Direct3D Sample';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
