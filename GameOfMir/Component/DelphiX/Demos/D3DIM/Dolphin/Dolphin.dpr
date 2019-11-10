program Dolphin;

uses
  Forms,
  DolphinU in 'DolphinU.pas' {DolphinForm},
  D3DEnum in 'D3DEnum.pas' {ChangeDeviceForm},
  D3DFrame in 'D3DFrame.pas',
  D3DApp in 'D3DApp.pas' {D3DApplication};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDolphinForm, DolphinForm);
  Application.Run;
end.
