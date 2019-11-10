program pooltest;

uses
  Forms,
  pooltestform in 'pooltestform.pas' {Form1},
  pool in 'pool.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
