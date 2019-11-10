{ Preview screen saver window is 153x113 }
program DLights;

uses
  Forms,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  SSaver_config in 'SSaver_config.pas' {SConfig},
  SSaver_main in 'SSaver_main.pas' {MainForm},
  Global_func in 'Global_func.pas';

{$E scr}
{$R *.RES}
{$R lights.res}

var
  Sem: THandle;
  PrevBitmap: TBitmap;

begin
  if TestSaverMode = ssSetPwd then ChangePassword;

  Sem := CreateSemaphore(nil,0,1,'Dancing Lights Semaphore');
  if ((Sem <> 0) and (GetLastError = ERROR_ALREADY_EXISTS)) then
    begin
    CloseHandle(Sem);
    Halt;
    end;

  Application.Initialize;

  if TestSaverMode = ssPreview then
    begin
    PrevBitmap := TBitmap.Create;
    PrevBitmap.LoadFromResourceName(HInstance,'PREVBMP');
    PreviewBitmap(PrevBitmap, Sem);
    PrevBitmap.Free;
    end;


  if TestSaverMode = ssConfig then
    Application.CreateForm(TSConfig, SConfig);

  if TestSaverMode = ssRun then
    Application.CreateForm(TMainForm, MainForm);

  Application.Title := 'Dancing Lights Screen Saver';

  Application.Run;

  CloseHandle(Sem);
end.

