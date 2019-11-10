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
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawClick(Sender: TObject);
    procedure DXDrawInitializeSurface(Sender: TObject);
  private
    FileName: string;
    Mesh: IDirect3DRMMesh;
    MeshFrame: IDirect3DRMFrame;
    WrapType: TD3DRMWRAPTYPE;
    wrap: IDirect3DRMWrap;
    procedure CreateWarp;
    procedure ApplyWarp;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.CreateWarp;
var
  miny, maxy, height: TD3DVALUE;
  box: TD3DRMBOX;
  ov, sv: Double;
begin
  Mesh.GetBox(box);

  maxy := box.max.y;
  miny := box.min.y;

  height := maxy - miny;
  if height=0 then height := 0.00001;

  ov := D3DDivide(miny, height);
  sv := D3DDivide(-1.0, height);

  if WrapType=D3DRMWRAP_SPHERE then
  begin
    DXDraw.D3DRM.CreateWrap(D3DRMWRAP_SPHERE, nil,
      0, 0, 0,
      0, 0, 1,
      0, 1, 0,
      0, 0,
      1, 1,
      Wrap
    );
    wrap.Apply(Mesh);
  end else
  if WrapType=D3DRMWRAP_CHROME then
  begin
    DXDraw.D3DRM.CreateWrap(D3DRMWRAP_CHROME, DXDraw.Camera,
      0, 0, 0,
      0, 0, 1,
      0, 1, 0,
      0, ov,
      1, sv,
      Wrap
    );
    wrap.ApplyRelative(MeshFrame, Mesh);
  end else
  begin
    DXDraw.D3DRM.CreateWrap
    (WrapType, nil,
      0, 0, 0,
      0, 0, 1,
      0, 1, 0,
      0, ov,
      1, sv,
      Wrap
    );
    wrap.Apply(Mesh);
  end;
end;

procedure TMainForm.ApplyWarp;
begin
  if WrapType=D3DRMWRAP_CHROME then
    wrap.ApplyRelative(MeshFrame, Mesh);
end;

procedure TMainForm.DXDrawInitialize(Sender: TObject);
var
  LightFrame: IDirect3DRMFrame;
  Light, AmbientLight: IDirect3DRMLight;
  MeshBuilder: IDirect3DRMMeshBuilder;
  image: IDirect3DRMTexture;
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
    FileName := ExtractFilePath(Application.ExeName)+'Egg.x';
  ChDir(ExtractFilePath(FileName));
  MeshBuilder.Load(PChar(FileName), nil, D3DRMLOAD_FROMFILE, nil, nil);
  MeshBuilder.Scale(3, 3, 3);
  //MeshBuilder.SetColor(D3DRGB(1, 1, 1));

  DXDraw.D3DRM.LoadTexture(PChar(ExtractFilePath(Application.ExeName)+'lake.bmp'), image);
  MeshBuilder.SetTexture(image);

  meshBuilder.CreateMesh(mesh);
  MeshFrame.AddVisual(mesh);


  CreateWarp;

  DXTimer.Enabled := True;
end;

procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
  Wrap := nil;
  Mesh := nil;
  MeshFrame := nil;

  DXTimer.Enabled := False;
end;

procedure TMainForm.DXDrawInitializeSurface(Sender: TObject);
begin
  if doHardware in DXDraw.NowOptions then
  begin
    {  Bi-linear filtering  }
    DXDraw.D3DRMDevice.SetTextureQuality(D3DRMTEXTURE_LINEAR);
  end;

  {  Alpha blending  }
  DXDraw.D3DRMDevice2.SetRenderMode(D3DRMRENDERMODE_BLENDEDTRANSPARENCY or
    D3DRMRENDERMODE_SORTEDTRANSPARENCY);
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
const
  DeviceText: array[Boolean] of string =
    ('Software', 'Hardware');
  WrapText: array[D3DRMWRAP_FLAT..D3DRMWRAP_CHROME] of string =
    ('Wrap is flat', 'Wrap is cylindrical', 'Wrap is spherical', 'Wrap is chrome');
var
  s: string;
  r: TRect;
begin
  if not DXDraw.CanDraw then exit;

  MeshFrame.Move(1.0);

  ApplyWarp;

  DXDraw.Viewport.ForceUpdate(0, 0, DXDraw.SurfaceWidth, DXDraw.SurfaceHeight);
  DXDraw.Render;


  s := Format('FPS: %d', [DXTimer.FrameRate])+#13+
       Format('Device: %s', [DeviceText[doHardware in DXDraw.NowOptions]])+#13+
       #13+
       Format('%s', [WrapText[WrapType]]);

  r := DXDraw.Surface.ClientRect;
  with DXDraw.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clWhite;
    Font.Size := 12;
    DrawText(Handle, PChar(s), Length(s), r, DT_LEFT or DT_NOCLIP);

    Release; {  Indispensability  }
  end;

  DXDraw.Flip;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  WrapChangeList: array[D3DRMWRAP_FLAT..D3DRMWRAP_CHROME] of TD3DRMWRAPTYPE =
    (D3DRMWRAP_CYLINDER, D3DRMWRAP_SPHERE, D3DRMWRAP_CHROME, D3DRMWRAP_FLAT);
begin
  {  Wrap method change  }
  if Key=VK_SPACE then
  begin
    WrapType := WrapChangeList[WrapType];
    CreateWarp;
  end;

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
