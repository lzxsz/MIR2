program SCapture;

uses
  Forms,
  Main in 'Main.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Audio Stream Sample';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
