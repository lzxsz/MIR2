unit Main;

interface
{ TODO -oJB. -ccritical : Bad function in fullscreen mode and bad with DirectX7Mode turn on. }
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DXClass, DXDraws, MMSystem, DirectX;
{Minimum changes in Hori's code, this was designed for DX6, no adapt to DX7}
{Only as demo...}
type
  TMainForm = class(TDXForm)
    DXDraw: TDXDraw;
    DXTimer: TDXTimer;
    DXImageList1: TDXImageList;
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawInitializeSurface(Sender: TObject);
    procedure DXDrawInitializing(Sender: TObject);
    procedure DXDrawFinalizeSurface(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure DXDrawFinalize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FConfig: Boolean;
    FD3DViewport: IDirect3DViewport3;
    FBackTexture: TDirect3DTexture2;
    FAlphaTexture: TDirect3DTexture2;
    procedure InitViewport;
    procedure FinViewport;
  end;

var
  MainForm: TMainForm;

implementation

uses Config;

{$R *.DFM}

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

procedure TMainForm.InitViewport;
var
  vp: TD3DVIEWPORT7;
begin
  DXDraw.D3DDevice7.SetRenderTarget(DXDraw.Surface.IDDSurface7, 0);

  FillChar(vp, SizeOf(vp), 0);
  vp.dwX := 0;
  vp.dwY := 0;
  vp.dwWidth := DXDraw.SurfaceWidth;
  vp.dwHeight := DXDraw.SurfaceHeight;
  vp.dvMinZ := 0.0;
  vp.dvMaxZ := 1.0;
  DXDraw.D3DDevice7.SetViewport(vp);
end;

procedure TMainForm.FinViewport;
begin
end;

procedure TMainForm.DXDrawInitializeSurface(Sender: TObject);
begin
  // main init procedure
  InitViewport;

  // hw only
  if doHardware in DXDraw.NowOptions then with DXDraw.D3DDevice7 do
  begin
    // set textures quality
    SetRenderState(D3DRENDERSTATE_TEXTUREMAG, Integer(D3DFILTER_MIPLINEAR));
    SetRenderState(D3DRENDERSTATE_TEXTUREMIN, Integer(D3DFILTER_MIPLINEAR));
  end;
end;

procedure TMainForm.DXDrawFinalizeSurface(Sender: TObject);
begin
  //  main fin procedure
//  FinViewport;
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
var
  r: TD3DRECT;
  tlv: array[0..128] of TD3DTLVERTEX;
  j: Integer;

  Size, BaseSize: Integer;
  p, p2: array[0..3] of TPoint;
  i: Integer;
  c, s: Double;
begin
  if not DXDraw.CanDraw then Exit;

  // clear viewport
  r.x1 := 0;
  r.y1 := 0;
  r.x2 := DXDraw.SurfaceWidth;
  r.y2 := DXDraw.SurfaceHeight;
  if DXDraw.ZBuffer<>nil then
    DXDraw.D3DDevice7.Clear(1, @r, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, $000000, 1, 0)
  else
    DXDraw.D3DDevice7.Clear(1, @r, D3DCLEAR_TARGET, $000000, 1, 0);

  // main begin scene
  asm
  FINIT
  end;
  DXDraw.D3DDevice7.BeginScene;

  // light texture text back
  if FBackTexture<>nil then
  begin
    with DXDraw.D3DDevice7 do
    begin
      SetTexture(0, FBackTexture.Surface.IDDSurface7);
      SetRenderState(D3DRENDERSTATE_COLORKEYENABLE, Ord(FBackTexture.Transparent));
      SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 0);
      SetRenderState(D3DRENDERSTATE_SRCBLEND, Ord(D3DBLEND_ONE));
      SetRenderState(D3DRENDERSTATE_DESTBLEND, Ord(D3DBLEND_ZERO));
    end;

    FillChar(tlv, SizeOf(tlv), 0);
    for j:=0 to 3 do
    begin
      with tlv[j] do
      begin
        sx := (Ord(j in [1, 3])*Max(DXDraw.SurfaceWidth, DXDraw.SurfaceHeight));
        sy := (Ord(j in [2, 3])*Max(DXDraw.SurfaceWidth, DXDraw.SurfaceHeight));
        sz := 0;
        rhw := 1;
        color := RGBA_MAKE(255, 255, 255, 255);
        specular := 0;
        tu := Ord(j in [1, 3])*2 + (GetTickCount mod 10000)/10000;
        tv := Ord(j in [2, 3])*2 + (GetTickCount mod 10000)/10000;
      end;
    end;

    DXDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_TLVERTEX, tlv[0], 4, D3DDP_WAIT);
  end;

  // search alpha layer in texture
  if FAlphaTexture<>nil then
  begin
    BaseSize := Max(DXDraw.Surface.Width, DXDraw.Surface.Height);
    Size := Trunc(Cos((TimeGetTime/2000)*2*PI)*BaseSize*1.5+BaseSize*2.6);

    p2[0] := Point(-Size div 2, -Size div 2);
    p2[1] := Point(+Size div 2, -Size div 2);
    p2[2] := Point(-Size div 2, +Size div 2);
    p2[3] := Point(+Size div 2, +Size div 2);

    c := Cos((TimeGetTime/4000)*2*PI);
    s := Sin((TimeGetTime/4000)*2*PI);
    for i:=0 to 3 do
    begin
      p[i].x := Trunc(p2[i].x * c - p2[i].y * s) + DXDraw.Surface.Width div 2;
      p[i].y := Trunc(p2[i].x * s + p2[i].y * c) + DXDraw.Surface.Height div 2;
    end;

    with DXDraw.D3DDevice7 do
    begin
      SetTexture(0, FAlphaTexture.Surface.IDDSurface7);
      SetRenderState(D3DRENDERSTATE_COLORKEYENABLE, Ord(FAlphaTexture.Transparent));
      SetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, 1);
      SetRenderState(D3DRENDERSTATE_SRCBLEND, Integer(D3DBLEND_SRCALPHA));
      SetRenderState(D3DRENDERSTATE_DESTBLEND, Integer(D3DBLEND_INVSRCALPHA));
    end;

    for j:=0 to 3 do
    begin
      with tlv[j] do
      begin
        sx := p[j].x;
        sy := p[j].y;
        sz := 0;
        rhw := 1;
        color := RGBA_MAKE(255, 255, 255, 255);
        specular := 0;
        tu := Ord(j in [1, 3]);
        tv := Ord(j in [2, 3]);
      end;
    end;

    DXDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_TLVERTEX, tlv[0], 4, D3DDP_WAIT);
  end;

  // fin scene
  DXDraw.D3DDevice7.EndScene;
  asm
  FINIT
  end;

  // and FPS write to canvas
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
      Release; {  must be released  }
    end;
  end;

  DXDraw.Flip;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {  ESC for exit  }
  if Key=VK_ESCAPE then
    Close;

  {  ALT+ENTER for switch screen resolution  }
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
      if not (doSelectDriver in DXDraw.Options) then
      DXDraw.Options := DXDraw.Options + [doSelectDriver];
    end;

    DXDraw.Initialize;
  end;
end;

procedure TMainForm.DXDrawInitialize(Sender: TObject);
begin
  {  dxt file load  }
  FBackTexture := TDirect3DTexture2.CreateFromFile(DXDraw, 'back.dxt');
  FAlphaTexture := TDirect3DTexture2.CreateFromFile(DXDraw, 'rt.dxt');
end;

procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
  {  freeing structures  }
  FBackTexture.Free;
  FAlphaTexture.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if NOT (doDirectX7Mode in DXDraw.Options) then
    DXDraw.Options := DXDraw.Options + [doDirectX7Mode];
end;

end.