program SparkFire;

uses
  Forms,
  sparkfire1 in 'sparkfire1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
