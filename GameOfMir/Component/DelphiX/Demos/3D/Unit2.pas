unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, D3DUtils, DirectX;

type
  TForm1 = class(TDXForm)
    DXDraw1: TDXDraw;
    DXTimer1: TDXTimer;
    DXImageList1: TDXImageList;
    procedure DXDraw1Initialize(Sender: TObject);
    procedure DXDraw1InitializeSurface(Sender: TObject);
    procedure DXDraw1Finalize(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    matView, matRotate, matProj, matE: TD3DMatrix;
      {Jednotlivé matice - poh¾adová, rotaèná, projekèná, jednotková}
    TriangleVertices: array[1..3] of TD3DVertex;
      {Pole vertexov trojuholníka}
    MyTexture: array[0..0] of TDirect3DTexture2;
      {Pole textúr}
    procedure MakeTriangle;
      {Vytvorí trojuholník - TriangleVertices}
    procedure FrameMovie;
      {Frame}
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{$I smatrix.inc}

procedure TForm1.MakeTriangle;
var
  n0: TD3DVector; {Normálový (kolmý) vektor}
begin

  n0 := MakeD3DVector( 0.0, 0.0,-1.0 ); // Front face

  {Jednotková matica}
  FilLChar(matE, SizeOf(matE), 0);
  matE._11 := 1;
  matE._22 := 1;
  matE._33 := 1;
  matE._44 := 1;

  {Nastavenie TriangleVertices}
  TriangleVertices [1] := MakeD3DVertex (
    MakeD3DVector (-1, -1, 0), n0, 0, 0);
  TriangleVertices [2] := MakeD3DVertex (
    MakeD3DVector (+1, -1, 0), n0, 1, 0);
  TriangleVertices [3] := MakeD3DVertex (
    MakeD3DVector ( 0, +1, 0), n0, 0.5, 1);
end;

procedure TForm1.FrameMovie;
begin
  D3DUtil_SetViewMatrix (matView,
    MakeD3DVector (0, 0, -5) {Odkia¾},
    MakeD3DVector (0, 0,  0) {Kam},
    MakeD3DVector (0, 1,  0) {UpVector});
  MatRotate := MatE;
end;

procedure TForm1.DXDraw1Initialize(Sender: TObject);
{Inicializácia DXDraw}
var
  i: Integer;
begin
  for i:=Low(MyTexture) to High(MyTexture) do
    MyTexture[i] := TDirect3DTexture2.Create(DXDraw1, DXImageList1.Items[i].Picture.Graphic, False);
end;

procedure TForm1.DXDraw1InitializeSurface(Sender: TObject);
{Inicializácia plochy DXDraw}
var
  vp: TD3DViewport7;
  mtrl: TD3DMaterial7;
  light: TD3DLight7;
begin
  DXDraw1.D3DDevice7.SetRenderTarget(DXDraw1.Surface.IDDSurface7, 0);

  { Viewport }
  FillChar(vp, SizeOf(vp), 0);
  vp.dwX := 0;
  vp.dwY := 0;
  vp.dwWidth := DXDraw1.SurfaceWidth;
  vp.dwHeight := DXDraw1.SurfaceHeight;
  vp.dvMinZ := 0.0;
  vp.dvMaxZ := 1.0;

  DXDraw1.D3DDevice7.SetViewport(vp);

  { Svetlo }
  FillChar(light, SizeOf(light), 0);
  light.dltType        := D3DLIGHT_SPOT;
  light.dcvDiffuse.r   := 1.0;
  light.dcvDiffuse.g   := 1.0;
  light.dcvDiffuse.b   := 1.0;
  light.dcvSpecular.r  := 1.0;
  light.dcvSpecular.g  := 1.0;
  light.dcvSpecular.b  := 1.0;
  light.dcvAmbient.r   := 1.0;
  light.dcvAmbient.g   := 1.0;
  light.dcvAmbient.b   := 1.0;
  light.dvPosition     := MakeD3DVector (0,1,-5);
  light.dvDirection    := MakeD3DVector (0,0,1);
  light.dvAttenuation0 := 0.0;
  light.dvAttenuation1 := 0.5;
  light.dvAttenuation2 := 0.0;
  light.dvFalloff      := 1;
  light.dvTheta        := 0.1;
  light.dvPhi          := 0.9;
  light.dvRange        := 10;
  DXDraw1.D3DDevice7.SetLight (0, light);
  DXDraw1.D3DDevice7.LightEnable (0, True);
  DXDraw1.D3DDevice7.SetRenderState(D3DRENDERSTATE_LIGHTING, $FFFFFFFF);

  {  Materiál  }
  FillChar(mtrl, SizeOf(mtrl), 0);
  mtrl.diffuse.r :=  1.0;
  mtrl.diffuse.g :=  1.0;
  mtrl.diffuse.b :=  0.0;
  mtrl.diffuse.a :=  1.0;
  mtrl.ambient.r :=  1.0;
  mtrl.ambient.g :=  1.0;
  mtrl.ambient.b :=  0.0;
  mtrl.ambient.a :=  1.0;
  mtrl.specular.r := 0.0;
  mtrl.specular.g := 0.0;
  mtrl.specular.b := 0.0;
  mtrl.emissive.r := 0.0;
  mtrl.emissive.g := 0.0;
  mtrl.emissive.b := 0.0;
  DXDraw1.D3DDevice7.SetMaterial(mtrl);
  DXDraw1.D3DDevice7.SetRenderState(D3DRENDERSTATE_AMBIENT, $00202020);

  // Set the projection matrix. Note that the view and world matrices are
  // set in the App_FrameMove() function, so they can be animated each
  // frame.
  FilLChar(matProj, SizeOf(matProj), 0);
  matProj._11 :=  2.0;
  matProj._22 :=  2.0;
  matProj._33 :=  1.0;
  matProj._34 :=  1.0;
  matProj._43 := -1.0;

  { Vytvorí Triangle }
  MakeTriangle;
end;

procedure TForm1.DXDraw1Finalize(Sender: TObject);
{Finalizácia DXDraw}
var
  i: Integer;
begin
  for i:=Low(MyTexture) to High(MyTexture) do
  begin
    MyTexture[i].Free;
    MyTexture[i] := nil;
  end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {  Application end  }
  if Key=VK_ESCAPE {ESC} then
    Close;

  {  Screen mode change  }
  if (ssAlt in Shift) and (Key=VK_RETURN) {ALT+ENTER} then
  begin
    DXDraw1.Finalize;

    if doFullScreen in DXDraw1.Options then
    begin
      RestoreWindow;

      DXDraw1.Cursor := crDefault;
      BorderStyle := bsSingle;
      DXDraw1.Options := DXDraw1.Options - [doFullScreen];
    end else
    begin
      StoreWindow;

      DXDraw1.Cursor := crNone;
      BorderStyle := bsNone;
      DXDraw1.Options := DXDraw1.Options + [doFullScreen];
    end;

    DXDraw1.Initialize;
  end;
end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
var
  r: TD3DRect;
begin
  if not DXDraw1.CanDraw then Exit;

  { Frame Movie }
  FrameMovie;

  {  Clear Screen  }
  r.x1 := 0;
  r.y1 := 0;
  r.x2 := DXDraw1.SurfaceWidth;
  r.y2 := DXDraw1.SurfaceHeight;
  if DXDraw1.ZBuffer<>nil then
    DXDraw1.D3DDevice7.Clear(1, @r, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, $000000, 1, 0)
  else
    DXDraw1.D3DDevice7.Clear(1, @r, D3DCLEAR_TARGET, $000000, 1, 0);

  { Draw Screen }
  DXDraw1.D3DDevice7.BeginScene;

  DXDraw1.D3DDevice7.SetRenderState(D3DRENDERSTATE_SHADEMODE, Integer(D3DSHADE_GOURAUD {Gouradovo tieòovanie}));
  DXDraw1.D3DDevice7.SetRenderState(D3DRENDERSTATE_CULLMODE, Ord(D3DCULL_NONE));

 // Draw the front and back faces of the cube using texture 1
  DXDraw1.D3DDevice7.SetTexture( 0, MyTexture[0].Surface.IDDSurface7 );

  DXDraw1.D3DDevice7.SetTransform( D3DTRANSFORMSTATE_WORLD,      matRotate);
  DXDraw1.D3DDevice7.SetTransform( D3DTRANSFORMSTATE_VIEW,       matView);
  DXDraw1.D3DDevice7.SetTransform( D3DTRANSFORMSTATE_PROJECTION, matProj);

  DXDraw1.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLELIST, D3DFVF_VERTEX, TriangleVertices[1], 3, 0);

  DXDraw1.D3DDevice7.EndScene;

  { Draw FrameRate }
  with DXDraw1.Surface.Canvas do
  begin
    try
      Brush.Style := bsClear;
      Font.Color := clWhite;
      Font.Size := 12;
      Textout(0, 0, 'FPS: '+inttostr(DXTimer1.FrameRate));
      if doHardware in DXDraw1.NowOptions then
        Textout(0, 14, 'Device: Hardware')
      else
        Textout(0, 14, 'Device: Software');
    finally
      Release; {  Indispensability  }
    end;
  end;

  DXDraw1.Flip;
end;

end.
