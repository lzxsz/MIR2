unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DXClass, DXDraws, DirectX;

type
  TMainForm = class(TDXForm)
    DXDraw: TDXDraw;
    DXTimer: TDXTimer;
    OpenDialog: TOpenDialog;
    procedure DXDrawInitialize(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawClick(Sender: TObject);
    procedure DXDrawInitializeSurface(Sender: TObject);
    procedure DXDrawInitializing(Sender: TObject);
  private
    FileName: string;
    FConfig: Boolean;
  end;

var
  MainForm: TMainForm;

implementation

uses Config;

{$R *.DFM}

procedure TMainForm.DXDrawInitialize(Sender: TObject);
var
  LightFrame, MeshFrame: IDirect3DRMFrame;
  Light, AmbientLight: IDirect3DRMLight;
  MeshBuilder: IDirect3DRMMeshBuilder;
begin
  {  Frame making  }
  DXDraw.D3DRM.CreateFrame(DXDraw.Scene, LightFrame);
  DXDraw.D3DRM.CreateFrame(DXDraw.Scene, MeshFrame);

  {  Light setting  }
  DXDraw.D3DRM.CreateLightRGB(D3DRMLIGHT_DIRECTIONAL, 0.9, 0.9, 0.9, Light);
  LightFrame.AddLight(Light);

  DXDraw.D3DRM.CreateLightRGB(D3DRMLIGHT_AMBIENT, 0.1, 0.1, 0.1, AmbientLight);
  DXDraw.Scene.AddLight(AmbientLight);

  {  Frame position and posture setting  }
  LightFrame.SetPosition(DXDraw.Scene, 2, 0.0, 22);
  DXDraw.Camera.SetPosition(DXDraw.Scene, -5.0, 10.0, 0.0);
  DXDraw.Camera.SetOrientation(DXDraw.Scene, 0.35, -0.65, 1.0, -0.15, 1.0, 0.5);

  MeshFrame.SetPosition(DXDraw.Scene, 0.0, 0.0, 15);
  MeshFrame.SetOrientation(DXDraw.Scene, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0);
  MeshFrame.SetRotation(DXDraw.Scene, 0.0, 1.0, 0.0, 0.05);

  {  Mesh making  }
  DXDraw.D3DRM.CreateMeshBuilder(MeshBuilder);

  if FileName='' then
    FileName := ExtractFilePath(Application.ExeName)+'cube.x';
  ChDir(ExtractFilePath(FileName));
  MeshBuilder.Load(PChar(FileName), nil, D3DRMLOAD_FROMFILE, nil, nil);
  MeshBuilder.Scale(3, 3, 3);
  MeshFrame.AddVisual(MeshBuilder);

  DXTimer.Enabled := True;
end;

procedure TMainForm.DXDrawInitializing(Sender: TObject);
var
  ConfigForm: TConfigForm;
begin
  if FConfig then Exit;
  FConfig := True;
  try
    ConfigForm := TConfigForm.Create(Self);
    try
      ConfigForm.DXDraw := DXDraw;
      ConfigForm.ShowModal;
      if ConfigForm.Tag=0 then Abort;
    finally
      ConfigForm.Free;
    end;    
  except
    on E: Exception do
    begin
      Application.ShowMainForm := False;
      Application.HandleException(E);
      Application.Terminate;
    end;
  end;
end;

procedure TMainForm.DXDrawInitializeSurface(Sender: TObject);
begin
  if doHardware in DXDraw.NowOptions then
  begin
    {  Bi-linear filtering  }
    DXDraw.D3DRMDevice.SetTextureQuality(D3DRMTEXTURE_LINEAR);
  end;

  {  Alpha-blending  }
  DXDraw.D3DRMDevice2.SetRenderMode(D3DRMRENDERMODE_BLENDEDTRANSPARENCY or
    D3DRMRENDERMODE_SORTEDTRANSPARENCY);
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
begin
  if not DXDraw.CanDraw then exit;

  DXDraw.Viewport.ForceUpdate(0, 0, DXDraw.SurfaceWidth, DXDraw.SurfaceHeight);

  DXDraw.Scene.Move(1.0);
  DXDraw.Render;

  with DXDraw.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clWhite;
    Font.Size := 12;
    Textout(0, 0, 'FPS: '+inttostr(DXTimer.FrameRate));
    if doHardware in DXDraw.NowOptions then
      Textout(0, 14, 'Device: Hardware')
    else
      Textout(0, 14, 'Device: Software');

    Release; {  Indispensability  }
  end;

  DXDraw.Flip;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {  Application end  }
  if Key=VK_ESCAPE then
    Close;

  {  Screen mode change  }
  if (ssAlt in Shift) and (Key=VK_RETURN) then
  begin
    DXDraw.Finalize;

    if doFullScreen in DXDraw.Options then
    begin
      RestoreWindow;

      DXDraw.Cursor := crDefault;
      BorderStyle := bsSizeable;
      DXDraw.Options := DXDraw.Options - [doFullScreen];
    end else
    begin
      StoreWindow;

      DXDraw.Cursor := crNone;
      BorderStyle := bsNone;
      DXDraw.Options := DXDraw.Options + [doFullScreen];
    end;

    DXDraw.Initialize;
  end;
end;

procedure TMainForm.DXDrawClick(Sender: TObject);
var
  w: Word;
begin
  w := VK_RETURN;
  if doFullScreen in DXDraw.Options then
    FormKeyDown(nil, w, [ssAlt]);

  if OpenDialog.Execute then
  begin
    FileName := OpenDialog.FileName;
    DXDraw.Initialize;
  end;
end;

end.
