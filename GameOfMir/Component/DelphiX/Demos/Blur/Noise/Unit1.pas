{---<              Perlin Noise Demo                 >---}{
  This example shows how to render cloud/fog alike
  images("perlin noise"). The example isn´t the
  most memory friendly way to code the routine, but
  this way enables the user in a fast way, to see how
  the individual layers look before mixing them.
  Another thing to have in mind with this ex. is
  that the standard Random function is used - and not
  a special function which always returns the same value
  given the same input - Procedural rendering is therefore
  not possible.

  Instead of 'div' and/or 'sqr', 'shr' has been used whenever
  possible (to gain speed). x shr 2 is equal to i.e. x div 2^2.

  Copyright (C) 2000 Michael Hansen. All Rights Reserved.
  Questions & bad code manner complaints:
  EMail: Dyster_tid@hotmail.com}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  ComCtrls;

type
  TForm1 = class(TForm)
    Draw: TButton;
    NoiseGen: TButton;
    NoiseRadio: TRadioGroup;
    SmoothRadio: TRadioGroup;
    Bevel1: TBevel;
    ViewCombo: TComboBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    UpDown1: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure DrawClick(Sender: TObject);
    procedure NoiseGenClick(Sender: TObject);
    procedure Mix;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NoiseRadioClick(Sender: TObject);
    procedure SmoothRadioClick(Sender: TObject);
    procedure ViewComboChange(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
type
   TRGBTripleArray = array [0..32767] of TRGBTriple;
var
   Bitmap : TBitmap;
   YLine  : ^TRGBTripleArray;
   Noise  : array of array of array of byte;
   Layers : array of array of array of byte;
   InitDone : boolean=false;

   {Max shr CLayer MUST be > 1 else program exits.
    In other words:  if Max div CLayer*2^CLayer > 1 then close}
   CLayer: byte = 7;  {Actual Layers = CLayer+1}
   Max   : word = 255;{Actual Size = (Max+1)*(Max+1) }

   {Grain or MixDown Factor, thats like a layers opasity
   in photoshop,127=50% Opaque and 255=100% Opaque.
   Change the grainess with this value. > 127 = more grain. }
   Grain : byte = 127;

{$R *.DFM}

function freq(xy,layer : word):word;
begin
 Result:= xy shr layer;
end;

procedure TForm1.Mix;
var x,y : word; c, l : byte;
begin
l:=ViewCombo.ItemIndex;
if l=0 then
 for y:=0 to Max do
  begin
   YLine:=Bitmap.Scanline[y];
   for x:=0 to Max do
    begin
     c:=Layers[0,x,y];
     for l:=1 to CLayer do c:=((c*Grain)+(Layers[l,x,y]*not Grain))shr 8;
     fillchar(YLine[x],3,c);
    end;
  end
 else
   for y:=0 to Max do
   begin
    YLine:=Bitmap.Scanline[y];
    for x:=0 to Max do
     begin
      c:=Layers[l-1,x,y];
      fillchar(YLine[x],3,c);
     end;
   end;
 Canvas.Draw(7,7,Bitmap);
end;

procedure Init(NumberOFLayers : byte);
var
 xy,y : word;
 l   : byte;
begin
 SetLength(Noise ,NumberOFLayers+1);
 SetLength(Layers,NumberOFLayers+1);
 for l:=0 to NumberOFLayers do
  begin
   xy:=freq(Max,l);
   SetLength(Noise[l] ,xy+1);
   SetLength(Layers[l],Max+1);
   for y:=0 to xy  do SetLength(Noise[l,y] ,xy);
   for y:=0 to Max do SetLength(Layers[l,y],Max+1);
  end;
end;

procedure InterpolateRect(Rect : TRect; v1,v2,v3,v4 : byte; Layer : byte);
var
 c,x,y,
 dx,dy,
 dxy,dxX,dyY
 : word;
begin
{Interpolation between the values v1..v4 in the size of rect}
with Rect do
 begin
  dx:=Right-Left; dy:=Bottom-Top;
  dxy:=dx*dy;
  for y:=0 to dy do
  begin
   dyY:=dy-y;
   for x:=0 to dx do
    begin
     dxX:=dx-x;
     c:=  (v1*dyY*dxX)div dxy + (v2*dyY*x)div dxy+
          (v3*  y*dxX)div dxy + (v4*  y*x)div dxy;
     Layers[Layer,left+x,top+y]:=c;
    end;
  end;
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var x : byte;
begin
 if Max shr Clayer < 1 then exit; {see introduction}
 Bitmap:=TBitmap.Create;
 Bitmap.PixelFormat:=pf24bit;
 Bitmap.Width :=Max+1;
 Bitmap.Height:=Max+1;
 Init(CLayer);
 ViewCombo.Items.Add('Mixed Layers');
 for x:=0 to CLayer do ViewCombo.Items.Add('Layer '+IntToStr(x+1));
 NoiseRadio.ItemIndex :=0;
 SmoothRadio.ItemIndex:=0;
 ViewCombo.ItemIndex  :=0;
 InitDone:=true;
 NoiseGen.Click;
end;

procedure TForm1.DrawClick(Sender: TObject);
var
 x,y : word;
 l,cl: byte;
 sc  : single;
begin
 Screen.Cursor := crHourGlass;
 {No Interpolation and layer[0] fill}
 for l:=0 to CLayer do
 for x:=0 to Max do
 for y:=0 to Max do
 Layers[l,x,y]:=Noise[l,freq(x,l),freq(y,l)];
 {Interpolation}
 if SmoothRadio.ItemIndex=0 then
  for l:=1 to CLayer do
    begin
     y:=0;
     cl:=freq(Max,l);
     sc:=Max/cl;
     repeat begin
       x:=0;
       repeat begin
         InterPolateRect(Rect(Round(x*sc),Round(y*sc),Round((x*sc)+sc),Round((y*sc)+sc)),Noise[l,x,y],Noise[l,x+1,y],Noise[l,x,y+1],Noise[l,x+1,y+1],l);
         Inc(x);
       end; until x=cl;
       inc(y);
      end; until y=cl;
   end;
 Mix;
 Screen.Cursor := crDefault;
end;

procedure TForm1.NoiseGenClick(Sender: TObject);
var x,y,l : word;
begin
 Randomize;
 {Grayscale noise}
 if NoiseRadio.ItemIndex=0 then
  for l:=0 to CLAyer do
  for x:=0 to freq(Max,l) do
  for y:=0 to freq(Max,l) do
  Noise[l,x,y]:=Random(32768);
 {Monochrome noise}
 if NoiseRadio.ItemIndex=1 then
  for l:=0 to CLAyer do
  for x:=0 to freq(Max,l) do
  for y:=0 to freq(Max,l) do
  if random(32768)>16384 then Noise[l,x,y]:=255 else Noise[l,x,y]:=0;
 Draw.Click;
 ViewCombo.ItemIndex:=0
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 {Release memory used}
 Finalize(Layers);
 Finalize(Noise);
 YLine:=nil;
 Bitmap.Free
end;

procedure TForm1.NoiseRadioClick(Sender: TObject);
begin
 if InitDone then NoiseGen.Click
end;

procedure TForm1.SmoothRadioClick(Sender: TObject);
begin
 if InitDone then Draw.Click
end;

procedure TForm1.ViewComboChange(Sender: TObject);
begin
 if InitDone then Mix
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
 if InitDone=false then close;
 Canvas.Draw(7,7,Bitmap);
end;

procedure TForm1.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
 Grain:=UpDown1.Position;
 Mix;
end;

end.
