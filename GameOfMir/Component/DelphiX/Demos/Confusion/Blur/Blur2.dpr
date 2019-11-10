program Blur2;

uses
  Forms,
  blurunit2 in 'blurunit2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Blur demo';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
