program directx1;

uses
  Forms,
  udelphix1 in 'udelphix1.pas' {frmDxEffect};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmDxEffect, frmDxEffect);
  Application.Run;
end.
