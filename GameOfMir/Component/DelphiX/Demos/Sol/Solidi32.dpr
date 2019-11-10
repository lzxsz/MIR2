program solidi32;

uses
  Forms,
  u_sol32 in 'u_sol32.pas' {Form1},
  u_list in 'u_list.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Generatore solidi ';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
