program wrProject;

uses
  Forms,
  wrunit in 'wrunit.pas' {frmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Confusion Demo';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
