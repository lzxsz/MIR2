program DXParticle_Spark;

uses
  Forms,
  DXSparkForm in 'DXSparkForm.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'DX RotoZoom';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
