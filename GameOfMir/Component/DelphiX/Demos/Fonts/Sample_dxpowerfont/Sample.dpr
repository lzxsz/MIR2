program Sample;

uses
  Windows,
  Forms,
  Main in 'Main.pas' {MainForm};

{$R *.RES}

begin
	Application.Initialize;
	Application.Title := 'DXPowerFont(DelphiX Add-On) Sample';
	Application.CreateForm(TMainForm, MainForm);
	Application.Run;
end.
