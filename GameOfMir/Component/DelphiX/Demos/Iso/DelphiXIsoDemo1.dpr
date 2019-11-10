program DelphiXIsoDemo1;

uses
  Windows,
  Forms,
  Main2 in 'Main2.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'DelphiX Isometric Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
