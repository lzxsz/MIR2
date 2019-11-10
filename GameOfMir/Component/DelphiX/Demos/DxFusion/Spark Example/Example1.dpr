program Example1;

uses
  Forms,
  exmp1 in 'exmp1.pas' {frmSpark};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSpark, frmSpark);
  Application.Run;
end.
