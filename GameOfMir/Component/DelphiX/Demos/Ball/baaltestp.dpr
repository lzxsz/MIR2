program baaltestp;

uses
  Forms,
  balltest in 'balltest.pas' {Form1},
  pallo in 'pallo.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tbiljarditesti, biljarditesti);
  Application.Run;
end.
