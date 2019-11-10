program DXProject;

uses
  Forms,
  DXMainform in 'DXMainform.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'DX RotoZoom';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
