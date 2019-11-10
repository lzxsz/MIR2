program HDRecder;

uses
  Forms,
  Main in 'Main.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'HD Recoder';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
