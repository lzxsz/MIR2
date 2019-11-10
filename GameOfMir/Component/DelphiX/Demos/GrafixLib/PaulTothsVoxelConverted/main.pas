unit main;

interface
{****************************************************************************
** Demonstration of displaying a voxel heightscape                         **
**  by Steven H Don                                                        **
**                                                                         **
** For questions, feel free to e-mail me.                                  **
**                                                                         **
**    shd@earthling.net                                                    **
**    http://shd.home.ml.org                                               **
**                                                                         **
****************************************************************************}

{ Delphi version by Paul TOTH <tothpaul@multimania.com>
  Delphi-X version by Entity <craigd@talk21.com > - using my TGrafixSurface }

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, DXClass, DXDraws, DirectX, DXInput, GrafixDX;

type
  TForm1 = class(TForm)
    DXDraw1: TDXDraw;
    DXTimer1: TDXTimer;
    DXImageList1: TDXImageList;
    DXInput1: TDXInput;
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DXDraw1Initialize(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure FormCreate(Sender: TObject);
    procedure DXDraw1Finalize(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
//    DIB:TDIB256;
    x,y,angle:word;
    cx,cy:integer;
    procedure initmap;
    procedure drawmap;
    procedure VLine(x,y1,y2,c:integer);
  end;

var
  Form1: TForm1;
  pal: array[0..255] of TPaletteEntry;
  VoxSurface: TGrafixSurface;
  bmpFont: TBmpFont;

//  maxx, maxy: integer;

implementation

{$R *.DFM}
const
 {This controls the maximum distance displayed. If you increase this,
  you will see more of the landscape, but it will also be slower}
 Depth = 200;
 maxx = 320;
 maxy = 240;

Var
 {Cosine and Sine tables}
 CosT, SinT : Array [0..2047] of Integer;
 {Distance compensation table}
 DComp : Array [1..Depth + 1] of Integer;

 iMap:array[0..$FFFF] of byte;
 hMap:array[0..$FFFF] of byte;


procedure TForm1.InitMap;
var
  DAC: Byte;
  f : File;
  colors:array[0..255,0..3] of byte;
begin
  {Load in the file "GROUND.BMP"}
  AssignFile(f, 'GROUND.BMP');
  Reset(f, 1);
  Seek (f, 54);
  blockread(f,colors,sizeof(colors));
  for DAC:=0 to 255 do
  begin
    pal[DAC].peRed:=Colors[DAC,2];
    pal[DAC].peGreen:=Colors[DAC,1];
    pal[DAC].peBlue:=Colors[DAC,0];
  end;
{  DXDraw1.Palette.Create( DXDraw1.DDraw );
  DXDraw1.Palette.SetEntries( 0, 256, pal );
{  for DAC:=0 to 255 do DIB.Color[DAC]:=RGB(Colors[DAC,2],Colors[DAC,1],Colors[DAC,0]);
  DIB.UpdateColors;
}  blockread(f,imap,SizeOf(imap));
  CloseFile(f);

  {Load in the file "HEIGHT.BMP"}
  AssignFile(f, 'HEIGHT.BMP');
  Reset(f, 1);
  Seek (f, $36);
  blockread(f,hmap,sizeof(hmap));
  CloseFile(f);

  VoxSurface:=TGrafixSurface.Create(DXDraw1.DDraw);
  VoxSurface.Init(DXDraw1, DXImageList1, 0, 0, clBlack);
  VoxSurface.Surface:=VoxSurface;
  VoxSurface.Fill(0);

  bmpFont:=TBmpFont.Create(DXDraw1.Surface);
  bmpFont.Init(DXDraw1, DXImageList1, 'Font', '');
end;

procedure TForm1.DrawMap;
const
  tmp: integer = 128+32+16;
 var
  height:integer;
  i:integer;
  a:word;
  px,py,c:integer;
  deltax,deltay:integer;
  miny,maxy:integer;
  d:integer;
  h:integer;
  y1:integer;
 begin
  height:=hmap[y and $FF00+hi(x)];
  for i:=0 to maxx-1 do begin
   a:=(angle+i+1888) and 2047;
   px:=x;
   py:=y;
   deltax := CosT [a];
   deltay := SinT [a];
   minY := maxy;
   for d:=1 to Depth do begin
    inc (px, deltax);
    inc (py, deltay);
    h := hmap[py and $FF00+hi(px)]-height;
    c := imap[py and $FF00+hi(px)];
    y1 := DComp [d] - (h shl 5) div d;
    if y1 < minY then begin
     VLine (i, y1, minY,c);
     minY := y1;
     if miny=0 then break;
    end;
   end;
   if MinY>0 then VLine(i,0,minY,tmp);
  end;
end;

procedure TForm1.VLine(x,y1,y2,c:integer);
var
  y:integer;
  SurfPtr: ^word;
  SurfPtrColor: cardinal;
begin
  if y1<0 then y1:=0;
  if y2>=maxy then y2:=maxy-1;

//  for y:=y1 to y2 do  VoxSurface.PutPixel( x,y,rgb(Pal[c].peRed,Pal[c].peGreen,Pal[c].peBlue));
  // The following code Added 26.March.2000 by Entity..
  // 2x Faster than the above line of code
  SurfPtrColor:=VoxSurface.RGBToBGR(rgb(Pal[c].peRed,Pal[c].peGreen,Pal[c].peBlue));
  for y:=y1 to y2 do
  begin
    SurfPtr:=pointer(longint(VoxSurface.SurfaceDesc.lpSurface)+VoxSurface.SurfaceDesc.lpitch*y+(x shl 1));
    SurfPtr^:=SurfPtrColor;
  end;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
// drawmap;
// DIB.DrawXY(Canvas.Handle,cx,cy);
end;




procedure TForm1.FormResize(Sender: TObject);
begin
 cx:=(DXDraw1.Display.Width-maxx)div 2;
 cy:=(DXDraw1.Display.Height-maxy) div 2;
// invalidate;
end;

procedure TForm1.DXDraw1Initialize(Sender: TObject);
begin
  {Create the map}
  InitMap;

  DXDraw1.Cursor:=crNone;

  DXTimer1.Enabled:=True;
end;

procedure CheckMovement;
const
  k = 1;
begin
 with Form1 do
 begin
   if isLeft in DXInput1.States then
   begin
     Angle := (Angle + 2032) and 2047;
   end;
   if isRight in DXInput1.States then
   begin
     Angle := (Angle + 16) and 2047;
   end;
   if isUp in DXInput1.States then
   begin
     inc (x, k*CosT [Angle]);
     inc (y, k*SinT [Angle]);
   end;
   if isDown in DXInput1.States then
   begin
     dec (x, k*CosT [Angle]);
     dec (y, k*SinT [Angle]);
   end;
 end;
end;

(*
 * MAIN LOOP
 *)
procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
const
 rotate:integer=0;
var
 key:word;
begin
 DXDraw1.Surface.Fill( clBlack );

 DXInput1.Update;

 CheckMovement;

 VoxSurface.Lock;
 DrawMap;
 VoxSurface.Unlock;

 VoxSurface.DrawToDXDraw(0,0,false);
 bmpFont.Textout(0, DXDraw1.Height-20, 'FPS   '+inttostr(DXTimer1.Framerate), true);
 bmpFont.Textout(0, DXDraw1.Height-50, 'ANGLE   '+inttostr(angle), true);

 DXDraw1.Flip;
end;

procedure TForm1.FormCreate(Sender: TObject);
const
  k=256;
var
  a:integer;
begin
//  maxx:=DXDraw1.Display.Width;
//  maxy:=DXDraw1.Display.Height;

 { calculates some lookup table}
  for a := 0 to 2047 do begin
  {Precalculate cosine}
   CosT [a] := trunc(Cos (a * pi / 1024) * k);
  {and sine}
   SinT [a] := trunc(Sin (a * pi / 1024) * k);
  end;
 {Precalculate distance compensation table}
  for a := 1 to Depth + 1 do DComp [a] := 1000 div longint(a) + maxy div 2;

 {Set up player}
  x := $8000;
  y := $8000;
  Angle := 600;
end;

procedure TForm1.DXDraw1Finalize(Sender: TObject);
begin
  DXTimer1.Enabled:=false;

  DXDraw1.Cursor:=crDefault;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then Close;
end;

end.
