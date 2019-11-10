(*============================================================================*)
(* This source code is provided as-is and without warranty. You may use it as *)
(* you see fit, but it would be appreciated if you kept my name in the source *)
(*                                                                            *)
(* I AM NOT LIABLE IN ANY WAY FOR ANY DAMAGE DONE TO ANYBODY ANYWHERE IN THE  *)
(* KNOWN GALAXY BY USE OF THIS SOFTWARE OR ANYTHING RELATED (LIKE TRYING TO   *)
(* UNDERSTAND IT). THIS IS OFCOURSE WACKO BUT THEY SAY I SHOULD PUT IT IN     *)
(* ANYWAY. SO THERE.                                                          *)
(*                                                                            *)
(* DelphiX: Copyright (c) Hori (http://www.ingjapan.ne.jp/hori/index-e.html)  *)
(* This: Copyright (c) 1999 Roy Willemse, Dynamind (http://www.dynamind.nl)   *)
(*                                                                            *)
(* This program requires DelphiX release 990210, DirectX 6.x (available from  *)
(* Microsoft) and Delphi 4. It should work in Delphi 3 but you would have to  *)
(* convert the DFM file and create a new DPR file I think. Just try it and    *)
(* e-mail me if you can't get it done.                                        *)
(*                                                                            *)
(* Good luck, and have fun!                                                   *)
(*                                                                            *)
(* Roy Willemse (r.willemse@dynamind.nl)                                      *)
(*                                                                            *)
(*============================================================================*)

unit udelphix1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DXDraws, DIB, DXSounds, ExtCtrls, Math;

const
  MAXX = 276;
  MAXY = 185;
  DAMP = 4;
  rIndex = 4.0;

type
  TfrmDxEffect = class(TForm)
    DXDraw1: TDXDraw;
    DXDIB1: TDXDIB;
    Background: TDXDIB;
    Panel1: TPanel;
    Distort2: TButton;
    Distort: TButton;
    Rotate: TButton;
    Fade3: TButton;
    Fade2: TButton;
    Fade1: TButton;
    Ink: TButton;
    Reset: TButton;
    Water: TButton;
    Rain: TButton;
    PlayWater: TButton;
    DXDIB2: TDXDIB;
    procedure Fade1Click(Sender: TObject);
    procedure Fade2Click(Sender: TObject);
    procedure Fade3Click(Sender: TObject);
    procedure RotateClick(Sender: TObject);
    procedure DistortClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Distort2Click(Sender: TObject);
    procedure InkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ResetClick(Sender: TObject);
    procedure WaterClick(Sender: TObject);
    procedure DXDraw1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RainClick(Sender: TObject);
    procedure PlayWaterClick(Sender: TObject);
    procedure MiscClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   procedure FadeIn(DIB1,DIB2: TDIB; Step: Byte);
   procedure FadeOut(DIB1,DIB2: TDIB; Step: Byte);
   procedure Zoom(DIB1,DIB2: TDIB; ZoomRatio: Real);
   procedure Blur(DIB1,DIB2: TDIB);
   procedure FillDIB8(DIB: TDIB; Color: Byte);
   procedure WaveMapDrop(x,y,w,MulFactor: integer);
   procedure UpdateWaveMap;
   procedure Initialize;
   procedure RenderWaveToDIB(DIB: TDIB);
   procedure InitWaveMap;
  end;

  TWaveMap = array[0..1,0..MAXX,0..MAXY] of Smallint;

var
  frmDxEffect: TfrmDxEffect;
  tsin,tcos: Array[0..511] of Single;
  Closing: Boolean;
  WaveMap: TWaveMap;
  CT,NW: byte;

  dispLut: Array[0..511] of byte;

implementation

{$R *.DFM}

procedure TfrmDxEffect.FadeOut(DIB1,DIB2: TDIB; Step: Byte);
var
  P1,P2: PByteArray;
  W,H: Integer;
begin
  P1 := DIB1.ScanLine[DIB2.Height-1];
  P2 := DIB2.ScanLine[DIB2.Height-1];
  W := DIB1.WidthBytes;
  H := DIB1.Height;
  asm
    PUSH ESI
    PUSH EDI
    MOV ESI, P1
    MOV EDI, P2
    MOV EDX, W
    MOV EAX, H
    IMUL EDX
    MOV ECX, EAX
    @@1:
    MOV AL, Step
    MOV AH, [ESI]
    CMP AL, AH
    JA @@2
    MOV AL, AH
@@2:
    MOV [EDI], AL
    INC ESI
    INC EDI
    DEC ECX
    JNZ @@1
    POP EDI
    POP ESI
  end;
end;

procedure TfrmDxEffect.Zoom(DIB1,DIB2: TDIB; ZoomRatio: Real);
var
  P1,P2: PByteArray;
  W,H: Integer;
  x,y: Integer;
  xr,yr,xstep,ystep: real;
  xstart: real;
begin
  W := DIB1.WidthBytes;
  H := DIB1.Height;
  xstart := (W - (W * ZoomRatio)) / 2;

  xr := xstart;
  yr := (H - (H * ZoomRatio)) / 2;
  xstep := ZoomRatio;
  ystep := ZoomRatio;

  for y := 1 to DIB1.Height-1 do begin
    P2 := DIB2.ScanLine[y];
    if (yr>=0) and (yr<=H) then begin
      P1 := DIB1.ScanLine[Trunc(yr)];
      for x := 1 to DIB1.Width-1 do begin
        if (xr>=0) and (xr<=W) then begin
          P2[x] := P1[Trunc(xr)];
        end else begin
          P2[x] := 0;
        end;
        xr := xr + xstep;
      end;
    end else begin
      for x := 1 to DIB1.Width-1 do begin
        P2[x] := 0;
      end;
    end;
    xr := xstart;
    yr := yr + ystep;
  end;
  sleep(250);
end;

procedure TfrmDxEffect.Blur(DIB1,DIB2: TDIB);
var
  P1,P2: PByteArray;
  W {,H}: Integer;
  x,y: Integer;
begin
  W := DIB1.WidthBytes;
  // H := DIB1.Height;

  for y := 1 to DIB1.Height-1 do begin
    P1 := DIB1.ScanLine[y];
    P2 := DIB2.ScanLine[y];
    for x := 1 to DIB1.Width-1 do begin
      P2[x] := (P1[x] + P1[x-1] + P1[x+1] + P1[x+W] + P1[x-W]) div 5;
    end;
  end;

end;


procedure TfrmDxEffect.FadeIn(DIB1,DIB2: TDIB; Step: Byte);
var
  P1,P2: PByteArray;
  W,H: Integer;
begin
  P1 := DIB1.ScanLine[DIB2.Height-1];
  P2 := DIB2.ScanLine[DIB2.Height-1];
  W := DIB1.WidthBytes;
  H := DIB1.Height;
  asm
    PUSH ESI
    PUSH EDI
    MOV ESI, P1
    MOV EDI, P2
    MOV EDX, W
    MOV EAX, H
    IMUL EDX
    MOV ECX, EAX
    @@1:
    MOV AL, Step
    MOV AH, [ESI]
    CMP AL, AH
    JB @@2
    MOV AL, AH
@@2:
    MOV [EDI], AL
    INC ESI
    INC EDI
    DEC ECX
    JNZ @@1
    POP EDI
    POP ESI
  end;
end;

procedure TfrmDxEffect.FillDIB8(DIB: TDIB; Color: Byte);
var
  P: PByteArray;
  W,H: Integer;
begin
  P := DIB.ScanLine[DIB.Height-1];
  W := DIB.WidthBytes;
  H := DIB.Height;
  asm
    PUSH ESI
    MOV ESI, P
    MOV EDX, W
    MOV EAX, H
    IMUL EDX
    MOV ECX, EAX
    MOV AL, Color
    @@1:
    MOV [ESI], AL
    INC ESI
    DEC ECX
    JNZ @@1
    POP ESI
  end;
end;

procedure TfrmDxEffect.Fade1Click(Sender: TObject);
var
  st1,st2: TSystemTime;
  c:Integer;
begin
  Closing := True;
  Application.ProcessMessages;
  Closing := False;

  GetLocalTime(st1);
  DXDIB1.DIB.SetSize(276,185,8);
  c:=0;
  while c<255 do begin
    FillDIB8(DXDIB1.DIB,Byte(c));
    if DXDraw1.CanDraw then begin
      DXDraw1.Surface.Assign(DXDIB1.DIB);
      DXDraw1.Flip;
    end;
    c:=c+4;
    Application.ProcessMessages;
    if Closing then Exit;
  end;
  GetLocalTime(st2);
end;

procedure TfrmDxEffect.Fade2Click(Sender: TObject);
var
  c: Integer;
begin
  Closing := True;
  Application.ProcessMessages;
  Closing := False;

  DXDIB1.DIB.SetSize(Background.DIB.Width,Background.DIB.Height,Background.DIB.BitCount);
  FillDIB8(DXDIB1.DIB,0);
  for c:=0 to 255 do begin
    FadeIn(BackGround.DIB,DXDIB1.DIB,c);
    if DXDraw1.CanDraw then begin
      DXDraw1.Surface.Assign(DXDIB1.DIB);
      DXDraw1.Flip;
    end;
    Application.ProcessMessages;
    if Closing then Exit;
  end;
end;

procedure TfrmDxEffect.Fade3Click(Sender: TObject);
var
  c: Integer;
begin
  Closing := True;
  Application.ProcessMessages;
  Closing := False;

  DXDIB1.DIB.SetSize(Background.DIB.Width,Background.DIB.Height,Background.DIB.BitCount);
  FillDIB8(DXDIB1.DIB,255);
  for c:=255 downto 0 do begin
    FadeOut(BackGround.DIB,DXDIB1.DIB,c);
    if DXDraw1.CanDraw then begin
      DXDraw1.Surface.Assign(DXDIB1.DIB);
      DXDraw1.Flip;
    end;
    Application.ProcessMessages;
    if Closing then Exit;
  end;
end;

procedure TfrmDxEffect.RotateClick(Sender: TObject);
var
  p,p2: PByteArray;
  x,y,x2,y2,xc,yc,a,angle: Integer;
  cosy,siny:real;
begin
  Closing := True;
  Application.ProcessMessages;
  Closing := False;

  DXDIB1.DIB.SetSize(Background.DIB.Width,Background.DIB.Height,Background.DIB.BitCount);
  xc := Background.DIB.Width div 2;
  yc := Background.DIB.Height div 2;

  for a := 0 to 64 do begin
    angle := 384+(a*8);
    for y:=0 to BackGround.DIB.Height -1 do begin
      p := DXDIB1.DIB.ScanLine[y];
      cosy := (y-yc) * tcos[angle and $1ff];
      siny := (y-yc) * tsin[angle and $1ff];
      for x:=0 to Background.DIB.Width-1 do begin
        x2 := Trunc((x-xc) * tsin[angle and $1ff] + cosy)+xc;
        y2 := Trunc((x-xc) * tcos[angle and $1ff] - siny)+yc;
        if (y2 >= 0) and (y2 < Background.DIB.Height) and (x2 >= 0) and (x2 < Background.DIB.Width) then begin
          p2 := Background.DIB.ScanLine[y2];
          p[x] := p2[MAXX-x2];
        end else begin
        if p[x] > 4 then
          p[x] := p[x]-4
        else
          p[x] := 0;
        end;
      end;
    end;
    if DXDraw1.CanDraw then begin
      DXDraw1.Surface.Assign(DXDIB1.DIB);
      DXDraw1.Flip;
    end;
    Application.ProcessMessages;
    if Closing then Exit;
  end;
  ResetClick(Sender);
end;

procedure TfrmDxEffect.DistortClick(Sender: TObject);
var
  p,p2: PByteArray;
  x,y,x2,y2,xc,yc,a,b,angle,ysqr: Integer;
  actdist,dist,cosy,siny:real;
begin
  Closing := True;
  Application.ProcessMessages;
  Closing := False;

  DXDIB1.DIB.SetSize(Background.DIB.Width,Background.DIB.Height,Background.DIB.BitCount);
  xc := Background.DIB.Width div 2;
  yc := Background.DIB.Height div 2;
  dist := sqrt(sqr(xc)+sqr(yc));

  for a := 0 to 16 do begin
    b:=a*8;
  for y:=0 to DXDIB1.DIB.Height-1 do begin
    p := DXDIB1.DIB.ScanLine[y];
    ysqr := sqr(y-yc);
    for x:=0 to (DXDIB1.DIB.Width)-1 do begin
      actdist := (sqrt((sqr(x-xc)+ysqr))/dist);

      actdist := tsin[ (Trunc(actdist*1024)) and $1ff ];
      angle := 384 + Trunc( (actdist)* b );

      cosy := (y-yc) * tcos[angle and $1ff];
      siny := (y-yc) * tsin[angle and $1ff];

      x2 := Trunc((x-xc) * tsin[angle and $1ff] + cosy)+xc;
      y2 := Trunc((x-xc) * tcos[angle and $1ff] - siny)+yc;
      if (y2 >= 0) and (y2 < Background.DIB.Height) and (x2 >= 0) and (x2 < Background.DIB.Width) then begin
        p2 := Background.DIB.ScanLine[y2];
        p[x] := p2[MAXX-x2];
      end else begin
        if p[x] > 2 then
          p[x] := p[x]-2
        else
          p[x] := 0;
      end;
    end;
  end;
  if DXDraw1.CanDraw then begin
    DXDraw1.Surface.Assign(DXDIB1.DIB);
    DXDraw1.Flip;
  end;
  Application.ProcessMessages;
  if Closing then Exit;
  end;

  for a := 16 downto 0 do begin
    b:=a*8;
  for y:=0 to DXDIB1.DIB.Height-1 do begin
    p := DXDIB1.DIB.ScanLine[y];
    ysqr := sqr(y-yc);
    for x:=0 to (DXDIB1.DIB.Width)-1 do begin
      actdist := (sqrt((sqr(x-xc)+ysqr))/dist);

      actdist := tsin[ (Trunc(actdist*1024)) and $1ff ];
      angle := 384 + Trunc( (actdist)* b );

      cosy := (y-yc) * tcos[angle and $1ff];
      siny := (y-yc) * tsin[angle and $1ff];

      x2 := Trunc((x-xc) * tsin[angle and $1ff] + cosy)+xc;
      y2 := Trunc((x-xc) * tcos[angle and $1ff] - siny)+yc;
      if (y2 >= 0) and (y2 < Background.DIB.Height) and (x2 >= 0) and (x2 < Background.DIB.Width) then begin
        p2 := Background.DIB.ScanLine[y2];
        p[x] := p2[MAXX-x2];
      end else begin
        if p[x] > 2 then
          p[x] := p[x]-2
        else
          p[x] := 0;
      end;
    end;
  end;
  if DXDraw1.CanDraw then begin
    DXDraw1.Surface.Assign(DXDIB1.DIB);
    DXDraw1.Flip;
  end;
  Application.ProcessMessages;
  if Closing then Exit;
  end;
  ResetClick(Sender);
end;

procedure TfrmDxEffect.Distort2Click(Sender: TObject);
var
  p,p2: PByteArray;
  x,y,x2,y2,xc,yc,a,b,angle,ysqr: Integer;
  actdist,dist,cosy,siny:real;
begin
  Closing := True;
  Application.ProcessMessages;
  Closing := False;

  DXDIB1.DIB.SetSize(Background.DIB.Width,Background.DIB.Height,Background.DIB.BitCount);
  xc := Background.DIB.Width div 2;
  yc := Background.DIB.Height div 2;
  dist := sqrt(sqr(xc)+sqr(yc)) * 0.75;

  for a := 0 to 63 do begin
    b:=a*8;
  for y:=0 to DXDIB1.DIB.Height-1 do begin
    p := DXDIB1.DIB.ScanLine[y];
    ysqr := sqr(y-yc);
    for x:=0 to (DXDIB1.DIB.Width)-1 do begin
      actdist := 1-(sqrt((sqr(x-xc)+ysqr))/dist);

      angle := 384 + Trunc( (actdist)* b );

      cosy := (y-yc) * tcos[angle and $1ff];
      siny := (y-yc) * tsin[angle and $1ff];

      x2 := Trunc((x-xc) * tsin[angle and $1ff] + cosy)+xc;
      y2 := Trunc((x-xc) * tcos[angle and $1ff] - siny)+yc;
      if (y2 >= 0) and (y2 < Background.DIB.Height) and (x2 >= 0) and (x2 < Background.DIB.Width) then begin
        p2 := Background.DIB.ScanLine[y2];
        p[x] := p2[MAXX-x2];
      end else begin
        if p[x] > 2 then
          p[x] := p[x]-2
        else
          p[x] := 0;
      end;
    end;
  end;
  if DXDraw1.CanDraw then begin
    DXDraw1.Surface.Assign(DXDIB1.DIB);
    DXDraw1.Flip;
  end;
  Application.ProcessMessages;
  if Closing then Exit;
  end;

  for a := 64 downto 0 do begin
    b:=a*8;
  for y:=0 to DXDIB1.DIB.Height-1 do begin
    p := DXDIB1.DIB.ScanLine[y];
    ysqr := sqr(y-yc);
    for x:=0 to (DXDIB1.DIB.Width)-1 do begin
      actdist := 1-(sqrt((sqr(x-xc)+ysqr))/dist);

      angle := 384 + Trunc( (actdist)* b );

      cosy := (y-yc) * tcos[angle and $1ff];
      siny := (y-yc) * tsin[angle and $1ff];

      x2 := Trunc((x-xc) * tsin[angle and $1ff] + cosy)+xc;
      y2 := Trunc((x-xc) * tcos[angle and $1ff] - siny)+yc;
      if (y2 >= 0) and (y2 < Background.DIB.Height) and (x2 >= 0) and (x2 < Background.DIB.Width) then begin
        p2 := Background.DIB.ScanLine[y2];
        p[x] := p2[MAXX-x2];
      end else begin
        if p[x] > 2 then
          p[x] := p[x]-2
        else
          p[x] := 0;
      end;
    end;
  end;
  if DXDraw1.CanDraw then begin
    DXDraw1.Surface.Assign(DXDIB1.DIB);
    DXDraw1.Flip;
  end;
  Application.ProcessMessages;
  if Closing then Exit;
  end;
  ResetClick(Sender);
end;

procedure TfrmDxEffect.InkClick(Sender: TObject);
var
  p0,p,p2: PByteArray;
  x,y,c: Integer;
  AllBlack: Boolean;
begin
  Closing := True;
  Application.ProcessMessages;
  Closing := False;

  DXDIB1.DIB.SetSize(Background.DIB.Width,Background.DIB.Height,Background.DIB.BitCount);

  // Spray seeds
  for c:=0 to 500 do begin
    DXDIB1.DIB.Pixels[ random(Background.DIB.Width-1),
                       random(Background.DIB.Height-1)] :=0;
  end;

  repeat
    AllBlack := True;
    for y:=0 to DXDIB1.DIB.Height -1 do begin
      p := DXDIB1.DIB.ScanLine[y];
      for x:=0 to DXDIB1.DIB.Width-1 do begin
        if p[x] < 16 then begin
          if p[x] > 0 then AllBlack := False;
          if y>0 then begin
            p0 := DXDIB1.DIB.ScanLine[y-1];
            if p0[x] > 4 then p0[x] := p0[x] - 4 else p0[x] := 0;
            if x>0 then if p0[x-1] > 2 then p0[x-1] := p0[x-1] - 2 else p0[x-1] := 0;
            if x<(DXDIB1.DIB.Width-1) then if p0[x+1] > 2 then p0[x+1] := p0[x+1] - 2 else p0[x+1] := 0;
          end;
          if y<(DXDIB1.DIB.Height-1) then begin
            p2 := DXDIB1.DIB.ScanLine[y+1];
            if p2[x] > 4 then p2[x] := p2[x] - 4 else p2[x] := 0;
            if x>0 then if p2[x-1] > 2 then p2[x-1] := p2[x-1] - 2 else p2[x-1] := 0;
            if x<(DXDIB1.DIB.Width-1) then if p2[x+1] > 2 then p2[x+1] := p2[x+1] - 2 else p2[x+1] := 0;
          end;
          if p[x] > 8 then p[x] := p[x] - 8 else p[x] := 0;
          if x>0 then if p[x-1] > 4 then p[x-1] := p[x-1] - 4 else p[x-1] := 0;
          if x<(DXDIB1.DIB.Width-1) then if p[x+1] > 4 then p[x+1] := p[x+1] - 4 else p[x+1] := 0;
        end;
      end;
    end;
    if DXDraw1.CanDraw then begin
      DXDraw1.Surface.Assign(DXDIB1.DIB);
      DXDraw1.Flip;
    end;
    Application.ProcessMessages;
  until (AllBlack or Closing);
end;

procedure TfrmDxEffect.WaterClick(Sender: TObject);
var
  Tmp: Byte;
begin
  Closing := True;
  Application.ProcessMessages;
  Closing := False;

  DXDIB1.DIB.SetSize(DXDraw1.Width,DXDraw1.Height,8);

  CT:=0; // Current
  NW:=1; // New

  repeat
    UpdateWaveMap;
    RenderWaveToDIB(DXDIB1.DIB);

    // Swap maps
    Tmp:=CT;
    CT:=NW;
    NW:=Tmp;

    if DXDraw1.CanDraw then begin
      DXDraw1.Surface.Assign(DXDIB1.DIB);
      DXDraw1.Flip;
    end;
    Application.ProcessMessages;
  until (Closing);
end;

procedure TfrmDxEffect.RainClick(Sender: TObject);
var
  x,y: Smallint;
  Tmp: Byte;
begin
  Closing := True;
  Application.ProcessMessages;
  Closing := False;

  DXDIB1.DIB.SetSize(DXDraw1.Width,DXDraw1.Height,8);

  CT:=0; // Current
  NW:=1; // New

  repeat
    // Draw random droplet.. :)
    x := 40 + random(MAXX-40);
    y := 40 + random(MAXY-40);
    WaveMapDrop(x,y,10,25);

    UpdateWaveMap;
    RenderWaveToDIB(DXDIB1.DIB);

    // Swap wavemaps
    Tmp:=CT;
    CT:=NW;
    NW:=Tmp;

    if DXDraw1.CanDraw then begin
      DXDraw1.Surface.Assign(DXDIB1.DIB);
      DXDraw1.Flip;
    end;
    Application.ProcessMessages;
  until (Closing);
end;

procedure TfrmDxEffect.PlayWaterClick(Sender: TObject);
var
  x,y,x2,y2,xi,yi,xc,yc,angle: Smallint;
  cosy,siny:real;
  Tmp: Byte;
const
  sx = 80;
  sy = 80;
begin
  Closing := True;
  Application.ProcessMessages;
  Closing := False;

  DXDIB1.DIB.SetSize(DXDraw1.Width,DXDraw1.Height,8);
  xc := Background.DIB.Width div 2;
  yc := Background.DIB.Height div 2;

  CT:=0; // Current
  NW:=1; // New

  angle:=0;
  x2:=4; xi:=4;
  y2:=4; yi:=3;

  WaveMapDrop(xc,yc,40,-100);
  repeat
    cosy := (sy-yc) * tcos[angle and $1ff];
    siny := (sy-yc) * tsin[angle and $1ff];
    x := Trunc((sx-xc) * tsin[angle and $1ff] + cosy)+xc;
    y := Trunc((sx-xc) * tcos[angle and $1ff] - siny)+yc;
    angle:=angle+8;

    WaveMapDrop(x,y,4,-500);
    WaveMapDrop(x2,y2,4,-500);

    x2:=x2+xi;
    y2:=y2+yi;
    if (x2<4) or (x2>MAXX-4) then xi:=-xi;
    if (y2<4) or (y2>MAXY-4) then yi:=-yi;

    UpdateWaveMap;
    RenderWaveToDIB(DXDIB1.DIB);

    // Swap wavemaps
    Tmp:=CT;
    CT:=NW;
    NW:=Tmp;

    if DXDraw1.CanDraw then begin
      DXDraw1.Surface.Assign(DXDIB1.DIB);
      DXDraw1.Flip;
    end;
    Application.ProcessMessages;
  until (Closing);
end;

procedure TfrmDxEffect.ResetClick(Sender: TObject);
begin
  DXDIB1.DIB.SetSize(Background.DIB.Width,Background.DIB.Height,Background.DIB.BitCount);
  DXDIB1.DIB.Assign(Background.DIB);
  if DXDraw1.CanDraw then begin
    DXDraw1.Surface.Assign(DXDIB1.DIB);
    DXDraw1.Flip;
  end;
end;

(* ========================================================================== *)
(* Miscellaneous routines                                                     *)
(* ========================================================================== *)

procedure TfrmDxEffect.Initialize;
var
  c,d: SmallInt;
begin
  (* ------------------------------------------------------------------------ *)
  (* Generate a look-up table for displacement. You put in the delta-height   *)
  (* and you can read out the relative position where a ray of light hits the *)
  (* surface.                                                                 *)
  (*                                                                          *)
  (* First we need to determine the surface normal. We do this                *)
  (* by calculating ArcTan(Y / X), or ArcTan(height_difference), because X    *)
  (* equals one:                                                              *)
  (*                                                                          *)
  (*   angle = ARCTAN(height_difference);                                     *)
  (*                                                                          *)
  (* Then, we calculate the refraction. If you remember your physics, you     *)
  (* know that:                                                               *)
  (*                                                                          *)
  (*   refraction_index = SIN(light_beam) / SIN(refracted_beam)               *)
  (*                                                                          *)
  (* So that the angle of the refracted beam can be calculated like this:     *)
  (*                                                                          *)
  (*   refracted_beam = ARCSIN( SIN(light_beam) / refraction_index )          *)
  (*                                                                          *)
  (* The refraction index for plain water is 2.0.                             *)
  (*                                                                          *)
  (* Third, we need to calculate where the beam hits the surface, which       *)
  (* is done by doing the following:                                          *)
  (*                                                                          *)
  (*   displacement = TAN(refracted_beam) * height_difference);               *)
  (* ------------------------------------------------------------------------ *)
  for c:=-256 to 255 do begin
    d:=c div 4;
    dispLut[c+256] := Byte(Trunc(Tan(ArcSin((Sin(ArcTan(d))/rIndex)))*d));
  end;

  (* ------------------------------------------------------------------------ *)
  (* Generate look-up tables for sine and cosine. The wave is stretched to    *)
  (* fill 512 (0..511) positions, so that position 255 is about 180 degrees.  *)
  (* This give us greater accuracy and speed, since the index can be          *)
  (* ANDed with 512. No explicit range checking is necessary:                 *)
  (*                                                                          *)
  (*   sin_of_some_angle := tsin[some_angle AND $1ff];                        *)
  (* ------------------------------------------------------------------------ *)
  for c:=0 to 511 do begin
    tsin[c] := sin( ((c*360)/511) * Pi/180 );
    tcos[c] := cos( ((c*360)/511) * Pi/180 );
  end;

  InitWaveMap;
end;

procedure TfrmDxEffect.UpdateWaveMap;
var
  x,y,n: Smallint;
begin
  (* ------------------------------------------------------------------------ *)
  (* Calculate the next frame of our waterwaves at time t                     *)
  (*                                                                          *)
  (* The height of the wave at (x, y) is determined by adding the heights of  *)
  (* the waves located above, below, to the left and to the right of (x, y).  *)
  (* The sum is then divided by two, giving us a waveheight roughly twice     *)
  (* as high as the rest.                                                     *)
  (*                                                                          *)
  (* Here comes the key to wave animation: from our total, we subtract the    *)
  (* height of the wave at (x, y) at time t-1.                                *)
  (*                                                                          *)
  (* If the previous wave was higher than average, the wave will drop.        *)
  (* And if the previous wave was lower than average, the wave will rise.     *)
  (*                                                                          *)
  (* Check out these sketches:                                                *)
  (*                                                                          *)
  (*   ****                        ****                                       *)
  (*   ----*** -----------------***----------- average height;                *)
  (*          ****          ****               the wave will rise             *)
  (*              **********                                                  *)
  (*                                                                          *)
  (*                                                                          *)
  (*              **********                                                  *)
  (*   -------****----------****-------------- average height;                *)
  (*       ***                  ***            the wave will drop             *)
  (*   ****                         ****                                      *)
  (*                                                                          *)
  (* While moving up and down, the wave loses energy. This is simulated by    *)
  (* using a damping factor. This factor depends on the height of the wave,   *)
  (* so that high waves lose energy fast, and low waves lose energy slowly:   *)
  (*                                                                          *)
  (*   wave_height = wave_height - (wave_height / damp_factor)                *)
  (* ------------------------------------------------------------------------ *)
  for y:=2 to MAXY-2 do begin
    for x:=2 to MAXX-2 do begin
      n:=( WaveMap[CT,x-1,y] +
           WaveMap[CT,x-2,y] +
           WaveMap[CT,x+1,y] +
           WaveMap[CT,x+2,y] +
           WaveMap[CT,x,y-1] +
           WaveMap[CT,x,y-2] +
           WaveMap[CT,x,y+1] +
           WaveMap[CT,x,y+2] +
           WaveMap[CT,x-1,y-1] +
           WaveMap[CT,x+1,y-1] +
           WaveMap[CT,x-1,y+1] +
           WaveMap[CT,x+1,y+1]
           ) div 6 - WaveMap[NW,x,y];
      asm
        push bx
        mov bx, n
        sar bx, DAMP
        sub n, bx
        pop bx
      end;
      WaveMap[NW,x,y] := n;  // Store result
    end;
  end;
end;

procedure TfrmDxEffect.RenderWaveToDIB(DIB: TDIB);
var
  x,y,newcolor,xDiff,yDiff,xDisp,yDisp: Smallint;
begin
  for y:=0 to MAXY do begin
    for x:=0 to MAXX do begin
      xDiff := WaveMap[NW,x+1,y] - WaveMap[NW,x,y];
      yDiff := WaveMap[NW,x,y+1] - WaveMap[NW,x,y];
      xDisp := dispLut[xDiff+256];
      yDisp := dispLut[yDiff+256];

      if xDiff<0 then begin
        // Current position is higher - Clockwise rotation
        if (yDiff<0) then
          newcolor := Background.DIB.Pixels[x-xDisp,y-yDisp]
        else
          newcolor := Background.DIB.Pixels[x-xDisp,y+yDisp]
      end else begin
        if (yDiff<0) then
          newcolor := Background.DIB.Pixels[x+xDisp,y-yDisp]
        else
          newcolor := Background.DIB.Pixels[x+xDisp,y+yDisp]
      end;
      DIB.Pixels[x,y] := newcolor;
    end;
  end;
end;

procedure TfrmDxEffect.InitWaveMap;
var x,y: SmallInt;
begin
  for y:=0 to MAXY do begin
    for x:=0 to MAXX do begin
      WaveMap[CT,x,y] := 0;
      WaveMap[NW,x,y] := 0;
    end;
  end;
end;

procedure TfrmDxEffect.WaveMapDrop(x,y,w,MulFactor: integer);
var
  u,v:integer;
  sqrx,sqry,sqrw: integer;
begin
  (* ------------------------------------------------------------------------ *)
  (* Use this function to create 'waterdrops' of different sizes.             *)
  (* (x, y) is the location, w is the size, and MulFactor the splash strength *)
  (* ------------------------------------------------------------------------ *)

  sqrw := sqr(w);
  if (x>w) and (x<MAXX-w) and (y>w) and (y<MAXY-w) then begin
    for v:=y-w to y+w do begin
      sqry := sqr(v-y);
      for u:=x-w to x+w do begin
        sqrx := sqr(u-x);
        if (sqrx+sqry)<=sqrw then begin
          WaveMap[CT,u,v] := MulFactor*Trunc(w-sqrt(sqrx+sqry));
        end;
      end;
    end;
  end;
end;

(* ========================================================================== *)
(* Event code                                                                 *)
(* ========================================================================== *)

procedure TfrmDxEffect.FormCreate(Sender: TObject);
begin
  (* Initialize look-up tables *)
  Initialize;
end;

procedure TfrmDxEffect.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  (* Indicate that we're closing - terminates all loops *)
  Closing := True;
end;

procedure TfrmDxEffect.DXDraw1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (* Create a wave at the click location *)
  WaveMapDrop(x,y,15,-4);
end;

procedure TfrmDxEffect.DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  (* Create a wave at the mouse location *)
  if (x>0) and (x<MAXX) and (y>0) and (y<MAXY) then begin
    WaveMapDrop(x,y,8,-64);
  end;
end;

procedure TfrmDxEffect.MiscClick(Sender: TObject);
var
  c: Integer;
  zr: real;
begin
  Closing := True;
  Application.ProcessMessages;
  Closing := False;

  DXDIB1.DIB.SetSize(Background.DIB.Width,Background.DIB.Height,Background.DIB.BitCount);
  DXDIB2.DIB.SetSize(Background.DIB.Width,Background.DIB.Height,Background.DIB.BitCount);
  DXDIB1.DIB.Assign(Background.DIB);

  zr := 2;

  for c:=0 to 255 do begin
    {for n := 0 to 10 do begin
      DXDIB1.DIB.Pixels[random(DXDIB1.DIB.Width),random(DXDIB1.DIB.Height)] := 255;
    end;}
    Zoom(DXDIB1.DIB,DXDIB2.DIB, zr);
    //Blur(DXDIB2.DIB,DXDIB1.DIB);
    if DXDraw1.CanDraw then begin
      DXDraw1.Surface.Assign(DXDIB2.DIB);
      DXDraw1.Flip;
    end;
    //DXDIB1.DIB.Assign(DXDIB2.DIB);
    Application.ProcessMessages;
    if Closing then Exit;
    zr := zr - 0.05;
  end;
end;

end.
