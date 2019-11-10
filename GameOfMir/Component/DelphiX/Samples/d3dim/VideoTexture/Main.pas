unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DXClass, DXDraws, MMSystem, D3DUtils, DIB, DirectX;

type
  TMainForm = class(TDXForm)
    DXDraw: TDXDraw;
    DXTimer: TDXTimer;
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawInitializeSurface(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure DXDrawFinalize(Sender: TObject);
  private
    g_pCubeVertices: array[0..4*6-1] of TD3DVertex;
    FTexture: TDirect3DTexture2;
    FTextureImage: TDIB;
    FPrevTextureImageText: string;
    procedure MakeCube;
    procedure FrameMovie(Time: Double);
    procedure UpdateTexture;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.DXDrawInitialize(Sender: TObject);
begin
  FTextureImage := TDIB.Create;
  FTextureImage.PixelFormat := MakeDIBPixelFormat(5, 5, 5);
  FTextureImage.SetSize(256, 256, 16);

  FTexture := TDirect3DTexture2.Create(DXDraw, FTextureImage, False);
end;

procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
  FTexture.Free; FTexture := nil;
  FTextureImage.Free; FTextureImage := nil;
end;

procedure TMainForm.MakeCube;
var
  n0, n1, n2, n3, n4, n5: TD3DVector;
begin
  // Define the normals for the cube
  n0 := MakeD3DVector( 0.0, 0.0,-1.0 ); // Front face
  n1 := MakeD3DVector( 0.0, 0.0, 1.0 ); // Back face
  n2 := MakeD3DVector( 0.0, 1.0, 0.0 ); // Top face
  n3 := MakeD3DVector( 0.0,-1.0, 0.0 ); // Bottom face
  n4 := MakeD3DVector( 1.0, 0.0, 0.0 ); // Right face
  n5 := MakeD3DVector(-1.0, 0.0, 0.0 ); // Left face

  // Front face
  g_pCubeVertices[0] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0, 1.0,-1.0), n0, 0.0, 0.0 );
  g_pCubeVertices[1] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0, 1.0,-1.0), n0, 1.0, 0.0 );
  g_pCubeVertices[2] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0,-1.0,-1.0), n0, 0.0, 1.0 );
  g_pCubeVertices[3] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0,-1.0,-1.0), n0, 1.0, 1.0 );

  // Back face
  g_pCubeVertices[4] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0, 1.0, 1.0), n1, 1.0, 0.0 );
  g_pCubeVertices[5] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0,-1.0, 1.0), n1, 1.0, 1.0 );
  g_pCubeVertices[6] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0, 1.0, 1.0), n1, 0.0, 0.0 );
  g_pCubeVertices[7] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0,-1.0, 1.0), n1, 0.0, 1.0 );

  // Top face
  g_pCubeVertices[8] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0, 1.0, 1.0), n2, 0.0, 0.0 );
  g_pCubeVertices[9] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0, 1.0, 1.0), n2, 1.0, 0.0 );
  g_pCubeVertices[10] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0, 1.0,-1.0), n2, 0.0, 1.0 );
  g_pCubeVertices[11] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0, 1.0,-1.0), n2, 1.0, 1.0 );

  // Bottom face
  g_pCubeVertices[12] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0,-1.0, 1.0), n3, 0.0, 0.0 );
  g_pCubeVertices[13] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0,-1.0,-1.0), n3, 0.0, 1.0 );
  g_pCubeVertices[14] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0,-1.0, 1.0), n3, 1.0, 0.0 );
  g_pCubeVertices[15] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0,-1.0,-1.0), n3, 1.0, 1.0 );

  // Right face
  g_pCubeVertices[16] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0, 1.0,-1.0), n4, 0.0, 0.0 );
  g_pCubeVertices[17] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0, 1.0, 1.0), n4, 1.0, 0.0 );
  g_pCubeVertices[18] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0,-1.0,-1.0), n4, 0.0, 1.0 );
  g_pCubeVertices[19] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0,-1.0, 1.0), n4, 1.0, 1.0 );

  // Left face
  g_pCubeVertices[20] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0, 1.0,-1.0), n5, 1.0, 0.0 );
  g_pCubeVertices[21] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0,-1.0,-1.0), n5, 1.0, 1.0 );
  g_pCubeVertices[22] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0, 1.0, 1.0), n5, 0.0, 0.0 );
  g_pCubeVertices[23] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0,-1.0, 1.0), n5, 0.0, 1.0 );
end;

procedure TMainForm.FrameMovie(Time: Double);
var
  matView, matRotate: TD3DMatrix;
begin
  // Set the view matrix so that the camera is backed out along the z-axis,
  // and looks down on the cube (rotating along the x-axis by -0.5 radians).
  FilLChar(matView, SizeOf(matView), 0);
  matView._11 := 1.0;
  matView._22 :=  cos(-0.5);
  matView._23 :=  sin(-0.5);
  matView._32 := -sin(-0.5);
  matView._33 :=  cos(-0.5);
  matView._43 := 5.0;
  matView._44 := 1.0;
  DXDraw.D3DDevice7.SetTransform( D3DTRANSFORMSTATE_VIEW, matView);

  // Set the world matrix to rotate along the y-axis, in sync with the
  // timekey
  FilLChar(matRotate, SizeOf(matRotate), 0);
  matRotate._11 :=  cos(-Time);
  matRotate._13 :=  sin(Time);
  matRotate._22 :=  1.0;
  matRotate._31 := -sin(Time);
  matRotate._33 :=  cos(Time);
  matRotate._44 :=  1.0;
  DXDraw.D3DDevice7.SetTransform( D3DTRANSFORMSTATE_WORLD, matRotate);
end;

procedure TMainForm.DXDrawInitializeSurface(Sender: TObject);
var
  vp: TD3DViewport7;
  mtrl: TD3DMaterial7;
  matProj: TD3DMatrix;
begin
  { Viewport }
  FillChar(vp, SizeOf(vp), 0);
  vp.dwX := 0;
  vp.dwY := 0;
  vp.dwWidth := DXDraw.SurfaceWidth;
  vp.dwHeight := DXDraw.SurfaceHeight;
  vp.dvMinZ := 0.0;
  vp.dvMaxZ := 1.0;

  DXDraw.D3DDevice7.SetViewport(vp);

  {  Material  }
  FillChar(mtrl, SizeOf(mtrl), 0);
  mtrl.ambient.r := 1.0;
  mtrl.ambient.g := 1.0;
  mtrl.ambient.b := 1.0;
  mtrl.diffuse.r := 1.0;
  mtrl.diffuse.g := 1.0;
  mtrl.diffuse.b := 1.0;
  DXDraw.D3DDevice7.SetMaterial( mtrl );
  DXDraw.D3DDevice7.SetRenderState( D3DRENDERSTATE_AMBIENT, $ffffffff);

  // Set the projection matrix. Note that the view and world matrices are
  // set in the App_FrameMove() function, so they can be animated each
  // frame.
  FilLChar(matProj, SizeOf(matProj), 0);
  matProj._11 :=  2.0;
  matProj._22 :=  2.0;
  matProj._33 :=  1.0;
  matProj._34 :=  1.0;
  matProj._43 := -1.0;
  DXDraw.D3DDevice7.SetTransform( D3DTRANSFORMSTATE_PROJECTION, matProj );

  { Make CUBE }
  MakeCUBE;
end;

procedure TMainForm.UpdateTexture;
var
  s: string;
begin
  //s := TimeToStr(Time);
  s:='Áº½¡âù';
  if s=FPrevTextureImageText then Exit;
  FPrevTextureImageText := s;
  
  FTextureImage.Canvas.Brush.Style := bsSolid;
  FTextureImage.Canvas.Brush.Color := RGB(64, 64, 64);
  FTextureImage.Canvas.FillRect(Rect(0, 0, FTextureImage.Width, FTextureImage.Height));
  FTextureImage.Canvas.Font.Color := RGB(64, 64, 128);
  FTextureImage.Canvas.Font.Size := 48;
  FTextureImage.Canvas.Brush.Style := bsClear;
  FTextureImage.Canvas.TextOut(10, 10, s);
  FTextureImage.Canvas.TextOut(10, 80, s);
  FTextureImage.Canvas.TextOut(10, 150, s);
  FTexture.Load;
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
var
  r: TD3DRect;
begin
  if not DXDraw.CanDraw then Exit;

  { Update Texture }
  UpdateTexture;

  { Frame Movie }
  FrameMovie(GetTickCount/1000);

  {  Clear Screen  }
  r.x1 := 0;
  r.y1 := 0;
  r.x2 := DXDraw.SurfaceWidth;
  r.y2 := DXDraw.SurfaceHeight;
  if DXDraw.ZBuffer<>nil then
    DXDraw.D3DDevice7.Clear(1, @r, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, $000000, 1, 0)
  else
    DXDraw.D3DDevice7.Clear(1, @r, D3DCLEAR_TARGET, $000000, 1, 0);

  { Draw Screen }
  asm FINIT end;
  DXDraw.D3DDevice7.BeginScene;

  DXDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 1);
  DXDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_SRCBLEND, Integer(D3DBLEND_ONE));
  DXDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_DESTBLEND, Integer(D3DBLEND_ONE));
  DXDraw.D3DDevice7.SetRenderState(D3DRENDERSTATE_CULLMODE, Ord(D3DCULL_NONE));

  // Draw the front and back faces of the cube using texture 1
  DXDraw.D3DDevice7.SetTexture( 0, FTexture.Surface.IDDSurface7);

  DXDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_pCubeVertices[0], 4, 0);
  DXDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_pCubeVertices[4], 4, 0);
  DXDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_pCubeVertices[8], 4, 0);
  DXDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_pCubeVertices[12], 4, 0);
  DXDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_pCubeVertices[16], 4, 0);
  DXDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_pCubeVertices[20], 4, 0);

  DXDraw.D3DDevice7.EndScene;
  asm FINIT end;

  { Draw FrameRate }
  with DXDraw.Surface.Canvas do
  begin
    try
      Brush.Style := bsClear;
      Font.Color := clWhite;
      Font.Size := 12;
      Textout(0, 0, 'FPS: '+inttostr(DXTimer.FrameRate));
      if doHardware in DXDraw.NowOptions then
        Textout(0, 14, 'Device: Hardware')
      else
        Textout(0, 14, 'Device: Software');
    finally
      Release; {  Indispensability  }
    end;
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

end.
