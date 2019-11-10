unit DXSparkForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,DXClass, DXDraws, DIB, DXInput,pixelsdx;

type
  TForm1 = class(TDXForm)
    DXDraw1: TDXDraw;
    DXTimer1: TDXTimer;
    fond: TDXDIB;
    DXInput1: TDXInput;
    DXImageList1: TDXImageList;
    procedure FormCreate(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure DXDraw1Initialize(Sender: TObject);
    procedure DXDraw1Finalize(Sender: TObject);
    procedure DXPutString(x,y:integer;text:string);
  private
    { Déclarations privées }
    procedure DXWriteFrameRate;
  public
    { Déclarations publiques }
    ctable:array[0..255] of integer;
    sinus,cosinus: Array[0..1023] of integer; // Tableaux précalculés de cosinus et sinus
    procedure ConvertTable;
    procedure Init_CoSine;
    procedure DxDibFillColors(i1,i2:Byte;c1,c2:Trgbquad);
  end;

type TParticle=record
  X,Y,
  SpeedX,SpeedY,
  Age,DeltaAge,Max_Age,
  gravx,gravy:real;
end;

const
  PARTICLE_AMOUNT=400;     /// Number of particles

var
  Form1: TForm1;
  Particle:Array[0..PARTICLE_AMOUNT] of TParticle;
  SCREEN_WIDTH,SCREEN_HEIGHT:integer;
  X1,Y1:Integer;

implementation

{$R *.DFM}

procedure Tform1.DxDibFillColors(i1,i2:Byte;c1,c2:Trgbquad);
var
  ir,ig,ib,
  r,g,b:    Integer;
  i,x:      Byte;
begin
  x:=i2-i1;
  r:=c1.rgbred shl 16; ir:=((c2.rgbred-c1.rgbred)shl 16)div x;
  g:=c1.rgbgreen shl 16; ig:=((c2.rgbgreen-c1.rgbgreen)shl 16)div x;
  b:=c1.rgbblue shl 16; ib:=((c2.rgbblue-c1.rgbblue)shl 16)div x;
  for i:=0 to x do
  begin
    dxdraw1.ColorTable[i1+i].rgbRed:=r shr 16; Inc(r,ir);
    dxdraw1.ColorTable[i1+i].rgbgreen :=g shr 16; Inc(g,ig);
    dxdraw1.ColorTable[i1+i].rgbblue:=b shr 16; Inc(b,ib);
    dxdraw1.ColorTable[i1+i].rgbReserved:=0;
  end;
end;

procedure Tform1.ConvertTable;
var i:integer;
begin
	For i:=0 to 255 do
  begin
  	CTable[i]:=convertcolor816(i,dxdraw1);
  end;
end;

procedure TForm1.init_CoSine;
var i:integer;
begin
	FOR i:= 0 TO 1023 do
	begin
    cosinus[i]:=round(cos(i*pi*2/1024)*1024);
    sinus[i]:=round(sin(i*pi*2/1024)*1024);
  end;
end;


procedure tform1.DXPutString(x,y:integer;text:string);
begin
 with DXDraw1.Surface.Canvas do
  begin
    Brush.Style := bsSolid;
    Font.Color := 255;
    Font.Size := 12;
    Textout( x, y, text ); // Affiche du text

    Release;
  end;
end;

procedure tform1.DXWriteFrameRate;
begin
 with dxdraw1.surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clred;
    Font.Size := 12;
    Textout( 0, 0, 'FPS : '+inttostr( dxtimer1.FrameRate ) ); { Display the FrameRate }

    Release;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    val1,val2: TRGBQuad;
begin

  RANDOMIZE;
  SCREEN_WIDTH:=dxdraw1.Width-1;
  SCREEN_Height:=dxdraw1.Height-1;
  X1:=SCREEN_WIDTH div 2;
  Y1:=SCREEN_Height div 2;

  init_cosine;


  DXDraw1.Initialize;
  dximagelist1.items.MakeColorTable;
  DXDraw1.ColorTable := dximagelist1.items.ColorTable;  // Assigne la palette
  DXDraw1.DefColorTable := dximagelist1.items.ColorTable;
  DXDraw1.UpdatePalette;

 { FillChar(dxdraw1.ColorTable,255,0);
  val1.rgbBlue:=0;
  val1.rgbGreen:=24;
  val1.rgbRed:=0;
  val1.rgbReserved:=0;
  val2.rgbBlue:=0;
  val2.rgbGreen:=128;
  val2.rgbRed:=0;
  val2.rgbReserved:=0;
  dxdibFillColors(1,64,val1,val2);

  val1.rgbBlue:=0;
  val1.rgbGreen:=128;
  val1.rgbRed:=0;
  val1.rgbReserved:=0;
  val2.rgbBlue:=0;
  val2.rgbGreen:=160;
  val2.rgbRed:=0;
  val2.rgbReserved:=0;
  dxdibFillColors(64,127,val1,val2);

  val1.rgbBlue:=0;
  val1.rgbGreen:=160;
  val1.rgbRed:=0;
  val1.rgbReserved:=0;
  val2.rgbBlue:=0;
  val2.rgbGreen:=192;
  val2.rgbRed:=0;
  val2.rgbReserved:=0;
  dxdibFillColors(128,192,val1,val2);

  val1.rgbBlue:=0;
  val1.rgbGreen:=192;
  val1.rgbRed:=0;
  val1.rgbReserved:=0;
  val2.rgbBlue:=0;
  val2.rgbGreen:=255;
  val2.rgbRed:=0;
  val2.rgbReserved:=0;
  dxdibFillColors(192,232,val1,val2);

  val1.rgbBlue:=0;
  val1.rgbGreen:=255;
  val1.rgbRed:=0;
  val1.rgbReserved:=0;
  val2.rgbBlue:=255;
  val2.rgbGreen:=255;
  val2.rgbRed:=255;
  val2.rgbReserved:=0;
  dxdibFillColors(232,255,val1,val2);

  dxdraw1.UpdatePalette; }
  ConvertTable;

  DXDraw1.Cursor := crNone;   // On cache le curseur

end;


procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
var xx,yy,i:integer;
begin
   if not(DXDraw1.CanDraw) then exit;
   dxinput1.Update; // met à jour les données
     if dxinput1.Keyboard.Keys[27] then close; // est-ce que la touche ESC a été appuyée ? si oui on quitte
   dxdraw1.surface.Fill(0);

  // dxsurfacelock(dxdraw1.surface.ISurface4,16);
   xx:=random(screen_width);
   yy:=random(screen_height);
   For i:=0 to PARTICLE_AMOUNT do
   begin
     With Particle[i] do
     begin
       Age:=Age+DeltaAge;
       X:=X+SpeedX-gravx;
       Y:=Y+SpeedY+gravy;
       If (Age>Max_Age) or (X<0) or (X+16>Screen_Width) or (Y<0) or (Y+16>Screen_Height) then
       begin
        X:=xx;
        Y:=yy;
        SpeedX:=(random(21)-10) / 5;
        SpeedY:=(random(21)-10) / 5;
        gravX:=(random(2)+4) / 10;
        gravY:=(random(5)+4) / 5;
        Age:=0;
        Max_Age:=random(10)+2;
        deltaage:=(random(10)+3)/100;
      end;
      dximagelist1.Items[0].DrawAdd(dxdraw1.surface,bounds(round(x),round(y),16,16),0,255-ROUND(age*120));
//     dximagelist1.Items[0].Draw(dxdraw1.surface,round(x),round(y),0);
//      dxasmpixel16(round(x),round(y),ctable[255]);
    end;
   end;
//   dxsurfaceunlock;

   dxwriteframerate;
   DXDraw1.FLip; // on affiche le buffer
end;


procedure TForm1.DXDraw1Initialize(Sender: TObject);
var i:integer;
begin
   dxtimer1.Enabled:=true;
  For i:=0 to PARTICLE_AMOUNT do
   begin
     With Particle[i] do
     begin
        X:=X1;
        Y:=Y1;
        SpeedX:=(random(21)-10) / 5;
        SpeedY:=(random(21)-10) / 5;
        gravX:=(random(5)+4) / 10;
        gravY:=(random(5)+4) / 5;
        Age:=0;
        Max_Age:=random(10)+2;
        deltaage:=(random(10)+3)/100;
      end;
   end;
end;

procedure TForm1.DXDraw1Finalize(Sender: TObject);
begin
 dxtimer1.Enabled:=false;
end;

end.
