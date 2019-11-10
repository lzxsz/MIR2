program Sprite1;

uses
  Windows,
  Forms,
  Main in 'Main.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'DelphiX Sample';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
