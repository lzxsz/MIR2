program baseproject;

uses
  Forms,
  Main in 'Main.pas' {LaunchForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TLaunchForm, LaunchForm);
  Application.Run;
end.
