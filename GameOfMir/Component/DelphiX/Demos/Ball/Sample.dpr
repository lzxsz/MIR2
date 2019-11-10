program Sample;

uses
  Windows,
  Forms,
  Main in 'Main.pas' {MainForm},
  DXBall in 'DXBall.pas',
  ShootBall in 'ShootBall.pas',
  About in 'About.pas' {FormAbout};
//  BallNumbers in 'BallNumbers.pas' {FormNumberOfBalls};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormAbout, FormAbout);
//  Application.CreateForm(TFormNumberOfBalls, FormNumberOfBalls);
  Application.Run;
end.
