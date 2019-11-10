unit FXGrafix;
{ FXGrafix v0.2a -

  Entity    entity@mythical.co.uk

  About this Library...   This library is based on my old 'FastPixels' lib.
                          which I coded because DelphiX was far too slow in
                          this area.  Now I have updated this lib with more
                          functionality than just plotting pixels fast.  I
                          have added Bmp Font routines, better handling of
                          different bit-depths, some old classic demo FX like
                          the CopperBar, WuLines (anti-aliased lines), etc.

                          I am hoping to implement most game dev stuff to
                          make it easier/faster to code a decent game.


  GREETZ (In no special order)

    Turbo - for helping out with the lib and having the best delphi site on
            the net.
    LifePower - again for helping with the lib (especially the 15bit stuff) and
                for letting me kick your ass on CyberSpace Wars ;o]
    Pexi - for giving me credit for my original lib in your particle engine
           contest entry.. this gave me the inspiration to start work on it
           again.
    And all the rest on the Turbo Message Board who contributed their ideas,
    code, etc.
    Kartal - Your game is looking cool... keep it up ;o]
    LEON Sébastien (DIBUltra Author) - for some of the pixel routines.
    Gordon Alex Cowie - For FastLib


    Other people who probably won't even see this lib.

    Darryl - for keeping the Pythian Project going full strength while I've
             been busy with my own things.
    Illka - for keeping me awake chatting into the small hours ;o]
    Dimo - we WILL get that game going :o]
    Frenzy - when are u gonna do a new demo?????????? ;o]
    Tom Hammersley - Great site... update it!!! ;o]

    And everyone else I know on #3dcoders, #delphi, #3dsmax, #coders



  Last update: 04.Apr.2000


  04.Apr.2000    Now implemented TextInputStr and TextInputInt which accept
                 input of text and integer respectively.
                 
  03.Apr.2000    I have implemented more functions for BMP Fonts.  There is now
                 a SinusScroller class which is a rendition of the old classic
                 Sinus Scoller in the old demos.

                 Now you can switch fonts at run-time,
                 with 'SetFont(FontNameInImageList)'

                 Updated the Font Writing with a FontTable.  The FontTable is
                 just a string type variable which contains the ordering of
                 the letters in the BMP which allows for custom ways of ordering
                 the letters in the BMP.


  TO DO:

     It is still an Alpha version so still has a long way to go for complete
     functionality in a game or whatever.

     Still to update the TextInput... functions for handling of special keys..
     ie. Delete, FunctionKeys, Etc.  Maybe even implement text wrapping, etc..

     It's still mostly aimed at 16bit, so all the other modes will be implemented
     in due time.

     Still to implement the missing bit-depth stuff.. I can't actually test it..
     so LifePower if you could do this for me and let me know, that'd be cool :o]
}

  
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  DXClass, DXDraws,
{$IfDef StandardDX}
  DirectDraw;
{$Else}
  DirectX;
{$EndIf}


const
  // FontTable just reflects the position of the letter/number/symbol in the BMP
  FontTable: string = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

type
  PRGB = ^TRGB;
  TRGB = packed record
    R, G, B: Byte;
  end;
  TBitDepth = (bd1, bd2, bd4, bd8, bd15, bd16, bd24, bd32);

  TPixelProc  = procedure (x, y: integer; Color: cardinal) of object;
  TGetPixelProc = function (x, y: integer): cardinal of object;

  { ****** TFXGrafix CLASS ****** }

  TFXGrafix = class(TObject)
  private
    FDXDraw: TDXDraw;
    FSurface: TDirectDrawSurface;
    FSurfaceDesc: TDDSurfaceDesc;
    FWidth,
    FHeight: integer;
    FLockRect: TRect;
    FBitDepth: TBitDepth;
    procedure PutPixel8(x, y: integer; Color: cardinal); // Done
    procedure PutPixel15(x, y: integer; Color: cardinal);
    procedure PutPixel16(x, y: integer; Color: cardinal); // Done
    procedure PutPixel24(x, y: integer; Color: cardinal); // Done - not tested
    procedure PutPixel32(x, y: integer; Color: cardinal); // Done - not tested
    function GetPixel8(x, y: integer): cardinal;   // Done - not tested
    function GetPixel15(x, y: Integer) : cardinal;
    function GetPixel16(x, y: Integer) : cardinal; // Done
    function GetPixel24(x, y: Integer) : cardinal;
    function GetPixel32(x, y: Integer) : cardinal;
    procedure InitBitDepthProcs(aBitDepth: byte);
  public
    PutPixel: TPixelProc;
    GetPixel: TGetPixelProc;
    constructor Create(aDXDraw: TDXDraw);
    destructor Destroy; override;
    function Lock(SurfaceToLock: TDirectDrawSurface): Boolean;
    procedure Unlock;
    // GFX Routines
    procedure PutPixelAlpha16(const X, Y: Integer; aColor: cardinal; A: byte);
    procedure Line(x1, y1, x2, y2: integer; Color: cardinal);
    procedure VLine(x,y1,y2: integer; Color: cardinal);
    procedure HLine(y,x1,x2: integer; Color: cardinal);
    procedure LinePolar(x, y: integer; angle, length: extended; Color: cardinal);
    procedure WuLine16(x1, y1, x2, y2: Integer; Color: cardinal);
    procedure CopperBar( const y, cbHeight: integer; TopColor, BottomColor: cardinal);
    // Pixel Format Routines
    function RGBToBGR(Color: cardinal): cardinal;
    procedure GetRGB16(Color: cardinal; var R, G, B: Byte);
    // To allow access to Private vars
    property Width: integer read FWidth;
    property Height: integer read FHeight;
    property SurfaceDesc: TDDSurfaceDesc read FSurfaceDesc;
    property BitDepth: TBitDepth read FBitDepth;
  end;


  { ****** TBMPFont CLASS ****** }

type
  TFXBmpFont = class
  private
    FDXDraw: TDXDraw;
    FSurface: TDirectDrawSurface; //
    FImageList: TDXImageList;     // The DXImageList
    FWidth,               //
    FHeight: integer;     //
    FNameInList: string;  // The name of the font in the DXImageList
    FFontTable: string;   // Contains the font table
    FScale:     extended; // The scaling for the fonts
    FAspect:    extended; // Aspect ratio of surface
  public
    InputChar: char;
    constructor Create(aImageList: TDXImageList; NameInList: string);
    destructor Destroy; override;
    procedure SetFont(NewNameInList: string);
    // The writing routines
    procedure Textout( dxDrawSurface: TDirectDrawSurface;
                       xp, yp: integer; mess: string; xCentred: boolean);
    function TextInputStr( DxDrawSurface: TDirectDrawSurface;
                           xp, yp: integer; InputMess: string;
                           var aKey: char): string;
    function TextInputInt( DxDrawSurface: TDirectDrawSurface;
                           xp, yp: integer; InputMess: string;
                           var aKey: char): cardinal;
    procedure PrintChar( dxDrawSurface: TDirectDrawSurface; xp, yp: integer; aChar: char);
    procedure DisplayCursor(DxDrawSurface: TDirectDrawSurface; xp, yp: integer);
  end;


  // == THE FXSinusScroller CLASS ==
  TFXSinusScroller = class(TObject)
  private
    FImageList: TDXImageList;
    FNameInList: string;
    xp: integer;
  public
    SinText: string;
    StartOver: boolean;
    constructor Create(aImageList: TDXImageList; NameInList: string);
    procedure Scroll( dxDrawSurface: TDirectDrawSurface;
                      yp: integer; xAmp, yAmp, Angle: extended;
                      Speed: integer; yCentred, Loop: boolean);
    procedure PrintChar(dxDrawSurface: TDirectDrawSurface; xp, yp: integer; aChar: char);
    destructor Free;
  end;

{ Thanks to LifePower for the following **FAST** Pixel Format Conversion Routines }
function Conv24to15(Color:Integer):Word;register; forward;
function Conv24to16(Color:Integer):Word;register; forward;
function Conv16to24(Color:Word):Integer;register; forward;
function Conv15to24(Color:Word):Integer;register; forward;

// Custom surface creation
function CreateSurface(ADraw: TDXDraw; var ANewSurface: TDirectDrawSurface;
                       Width, Height: integer): boolean; forward;

implementation

{ For creating your own custom TDirectDrawSurface }
function CreateSurface(ADraw: TDXDraw; var ANewSurface: TDirectDrawSurface;
                       Width, Height: integer): boolean;
begin
  try
  begin
    ANewSurface:=TDirectDrawSurface.Create(ADraw.DDraw);
    ANewSurface.SetSize(Width,Height);
    ANewSurface.Fill(0);
    ANewSurface.TransparentColor:=clBlack;
    result:=true;
  end;
  finally
    result:=false;
  end;
end;


function Conv24to15(Color:Integer):Word;register;
asm
 mov ecx,eax
 shl eax,24
 shr eax,27
 shl eax,10
 mov edx,ecx
 shl edx,16
 shr edx,27
 shl edx,5
 or eax,edx
 mov edx,ecx
 shl edx,8
 shr edx,27
 or eax,edx
end;

function Conv24to16(Color:Integer):Word;register;
asm
 mov ecx,eax
 shl eax,24
 shr eax,27
 shl eax,11
 mov edx,ecx
 shl edx,16
 shr edx,26
 shl edx,5
 or eax,edx
 mov edx,ecx
 shl edx,8
 shr edx,27
 or eax,edx
end;

function Conv16to24(Color:Word):Integer;register;
asm
 xor edx,edx
 mov dx,ax
 mov eax,edx
 shl eax,27
 shr eax,8
 mov ecx,edx
 shr ecx,5
 shl ecx,26
 shr ecx,16
 or eax,ecx
 mov ecx,edx
 shr ecx,11
 shl ecx,27
 shr ecx,24
 or eax,ecx
end;

function Conv15to24(Color:Word):Integer;register;
asm
 xor edx,edx
 mov dx,ax
 mov eax,edx
 shl eax,27
 shr eax,8
 mov ecx,edx
 shr ecx,5
 shl ecx,27
 shr ecx,16
 or eax,ecx
 mov ecx,edx
 shr ecx,10
 shl ecx,27
 shr ecx,24
 or eax,ecx
end;




                  // PRIVATE //

{ *** PIXEL PROCEDURES *** }
procedure TFXGrafix.PutPixel8(x, y: Integer; Color: cardinal);
begin
  if (x<0) or (x>FWidth-1) or (y<0) or (y>FHeight-1) then
    Exit
  else
    PByte(integer(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*Y+X)^:=Color;
end;

procedure TFXGrafix.PutPixel15(x, y: Integer; Color: cardinal);
begin
end;

procedure TFXGrafix.PutPixel16(x, y: Integer; Color: cardinal);
begin
  Color:=RGBToBGR(Color);

  if (x<0) or (x>FWidth-1) or (y<0) or (y>FHeight-1) then
    Exit
  else
    PWord(integer(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*Y+(X shl 1))^:=Color;
end;

procedure TFXGrafix.PutPixel24(x, y: Integer; Color: cardinal);
begin
  with PRGB(integer(FSurfaceDesc.lpsurface)+FSurfaceDesc.lpitch*Y+(X*3))^ do
  begin
    r := byte(Color);
    g := byte(Color shr 8);
    b := byte(Color shr 16);
  end;
end;

procedure TFXGrafix.PutPixel32(x, y: Integer; Color: cardinal);
begin
  PInteger(integer(FSurfaceDesc.lpsurface)+FSurfaceDesc.lpitch*Y+(X shl 2))^ := Color;
end;

// NOW WORKS!!!   - 11.Feb.2000  THANKS TO THE DIBULTRA AUTHOR :)
{ GET PIXEL COLOUR FROM SURFACE }
function TFXGrafix.GetPixel8(x, y: Integer) : cardinal;
begin
   result:=PByte(integer(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*Y+X)^;
end;

function TFXGrafix.GetPixel15(x, y: Integer) : cardinal;
begin
  result:=0;
end;

// NOW WORKS!!!   - 11.Feb.2000  THANKS TO THE DIBULTRA AUTHOR :)
{ GET PIXEL COLOUR FROM SURFACE }
function TFXGrafix.GetPixel16(x, y: Integer) : cardinal;
var
  res: cardinal;
begin
   Result:=PWord(integer(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*Y + (X shl 1))^;
   res:=((Result and $001F) shl 19) + ((Result and $07E0) shl 5) + (Result and $F800) shr 8;
   result:=res;
end;

function TFXGrafix.GetPixel24(x, y: Integer) : cardinal;
begin
  result:=0;
end;

function TFXGrafix.GetPixel32(x, y: Integer) : cardinal;
begin
  result:=0;
end;


procedure TFXGrafix.InitBitDepthProcs(aBitDepth: byte);
begin
  // Looked messy inside TFXGrafix.Lock()
  case aBitDepth of
    8: begin
         PutPixel:=PutPixel8;
         GetPixel:=GetPixel8;
         FBitDepth:=bd8;
       end;
    15: begin // For older cards that use 555 format (ie. Rush)
          PutPixel:=PutPixel15;
          GetPixel:=GetPixel15;
          FBitDepth:=bd15;
        end;
    16: begin
          PutPixel:=PutPixel16;
          GetPixel:=GetPixel16;
          FBitDepth:=bd16;
        end;
    24: begin
          PutPixel:=PutPixel24;
          GetPixel:=GetPixel24;
          FBitDepth:=bd24;
        end;
    32: begin
          PutPixel:=PutPixel32;
          GetPixel:=GetPixel32;
          FBitDepth:=bd32;
        end;
  end; // case of...
end;



              // PUBLIC //


{ *** GENERAL *** }
constructor TFXGrafix.Create(aDXDraw: TDXDraw);
begin
  inherited Create;
  FDXDraw:=aDXDraw;
  FSurface:=aDXDraw.Surface;
  FWidth:=aDXDraw.SurfaceWidth;
  FHeight:=aDXDraw.SurfaceHeight;
  InitBitDepthProcs(FDXDraw.Surface.BitCount);
end;

destructor TFXGrafix.Destroy;
begin
  inherited Destroy;
end;


function TFXGrafix.Lock(SurfaceToLock: TDirectDrawSurface): Boolean;
begin
  FSurface:=SurfaceToLock;
  Result:=True;
  FSurfaceDesc.dwSize:=SizeOf( TDDSurfaceDesc );
  FLockRect:=Rect(0,0,FSurfaceDesc.dwWidth,FSurfaceDesc.dwHeight);

  if FSurface.ISurface4.Lock( @FLockRect, FSurfaceDesc, DDLOCK_SURFACEMEMORYPTR+DDLOCK_WAIT, 0 )<>DD_OK then Result:=False;

  // Setup the gfx procedure according to the surface BitDepth
  InitBitDepthProcs(FSurfaceDesc.ddpfPixelFormat.dwRGBBitCount);
end;

procedure TFXGrafix.Unlock;
begin
  FSurface.ISurface4.Unlock( @FLockRect );
end;



{ *** GFX PROCEDURES *** }


procedure TFXGrafix.PutPixelAlpha16(const X, Y: Integer; aColor: cardinal; A: byte);
var
  color: integer;
  cr, cg, cb: byte;
  ar, ag, ab: byte;
begin
  getrgb16(aColor, ar,ag,ab);
// This function could use a lot of speed work, but it's faster than
// alpha blending Canvas.Pixels ;) but Hori's FillRectAdd is faster
// for large areas
  if (X < 0) or (X > FSurface.Width - 1) or // Clip to DelphiX Surface
    (Y < 0) or (Y > FSurface.Height - 1) then Exit;
  color := getpixel(x, y); // get "color"
  getrgb16(Color, cr,cg,cb);
  PutPixel(X, Y,
    rgb((A * (aR - cr) shr 8) + cr, // R alpha
        (A * (aG - cg) shr 8) + cg, // G alpha
        (A * (aB - cb) shr 8) + cb)); // B alpha
end;



{ DRAW A NORMAL LINE - From a cool Denthor tut}
{ MUST BE WITHIN A LOCK/UNLOCK AS YOU WOULD USE PUTPIXEL }
procedure TFXGrafix.Line(x1, y1, x2, y2: integer; Color: cardinal);
var
  i, deltax, deltay, numpixels,
  d, dinc1, dinc2,
  x, xinc1, xinc2,
  y, yinc1, yinc2: Integer;
  SurfPtr: ^word;
  SurfPtrColor: cardinal;
begin
  SurfPtrColor:=0;
  // OPTIMIZED - 27.Mar.2000 Entity
  // We only need to calculate the colour once as it's the same colour used
  // for all points in the line.. this is what speeds up this routine by at
  // least 2x.
  // Slows down if in the loop with the pixel plotting.
  case FBitDepth of
    bd8: begin
         end;
    bd16: begin
            //getRGB16(Color, r,g,b);
            SurfPtrColor:=RGBToBGR(Color);
          end;
  end;

  { Calculate deltax and deltay for initialisation }
  deltax := abs(x2 - x1);
  deltay := abs(y2 - y1);

  { Initialise all vars based on which is the independent variable }
  if deltax>=deltay then
  begin
    { x is independent variable }
    numpixels:=deltax+1;
    d:=(deltay shl 1)-deltax;

    dinc1:=deltay shl 1;
    dinc2:=(deltay-deltax) shl 1;
    xinc1:=1;
    xinc2:=1;
    yinc1:=0;
    yinc2:=1;
  end
  else
  begin
    { y is independent variable }
    numpixels:=deltay+1;
    d:=(deltax shl 1)-deltay;
    dinc1:=deltax shl 1;
    dinc2:=(deltax-deltay) shl 1;
    xinc1:=0;
    xinc2:=1;
    yinc1:=1;
    yinc2:=1;
  end;
  { Make sure x and y move in the right directions }
  if x1>x2 then
  begin
    xinc1:=-xinc1;
    xinc2:=-xinc2;
  end;
  if y1>y2 then
  begin
    yinc1:=-yinc1;
    yinc2:=-yinc2;
  end;
  x:=x1;
  y:=y1;


     { Draw the pixels }
  for i:=1 to numpixels do
  begin
    if (x>0) and (x<FWidth-1) and (y>0) and (y<FHeight-1) then
    begin
      //FPixelProc( x,y, Color );
      { This is faster than calling PutPixel }
      case FBitDepth of
        bd8: begin
               PByte(integer(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*Y+X)^:=Color;
             end;
        bd16: begin
               SurfPtr:=pointer(longint(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*y+(x shl 1));
               SurfPtr^:=SurfPtrColor;
              end;
      end;
    end;
    if d<0 then
    begin
      d:=d+dinc1;
      x:=x+xinc1;
      y:=y+yinc1;
    end
    else
    begin
      d:=d+dinc2;
      x:=x+xinc2;
      y:=y+yinc2;
    end;
  end;
end;


{ DRAW A VERTICAL LINE -- FAST }

procedure TFXGrafix.VLine(x,y1,y2: integer; Color: cardinal);
var
  y:integer;
  SurfPtr: ^word;
  SurfPtrColor: cardinal;
begin
  SurfPtrColor:=0;
  if y1<0 then y1:=0;
  if y2>=FHeight then y2:=FHeight-1;

//  for y:=y1 to y2 do  VoxSurface.PutPixel( x,y,rgb(Pal[c].peRed,Pal[c].peGreen,Pal[c].peBlue));
  // The following is 2x faster than the above line of code
//  GetRGB16(Color, r,g,b);
  Case FBitDepth of
    bd8: begin
         end;
    bd16: begin
            SurfPtrColor:=RGBToBGR(Color);
          end;
  end; // case...
  for y:=y1 to y2 do
  begin
    case FBitDepth of
      bd8: begin
             PByte(integer(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*Y+X)^:=Color;
           end;
      bd16: begin
              SurfPtr:=pointer(longint(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*y+(x shl 1));
              SurfPtr^:=SurfPtrColor;
            end;
    end; // case...
  end;
end;

{ DRAW A HORIZONTAL LINE -- FAST }
procedure TFXGrafix.HLine(y,x1,x2: integer; Color: cardinal);
var
  x:integer;
  SurfPtr: ^word;
  SurfPtrColor: cardinal;
begin
  SurfPtrColor:=0;
  if x1<0 then x1:=0;
  if x2>=FWidth then x2:=FWidth-1;

//  for y:=y1 to y2 do  VoxSurface.PutPixel( x,y,rgb(Pal[c].peRed,Pal[c].peGreen,Pal[c].peBlue));
  // The following is 2x faster than the above line of code
//  GetRGB16(Color, r,g,b);
  Case FBitDepth of
    bd8: begin
         end;
    bd16: begin
            SurfPtrColor:=RGBToBGR(Color);
          end;
  end; // case...
  for x:=x1 to x2 do
  begin
    case FBitDepth of
      bd8: begin
           end;
      bd16: begin
              SurfPtr:=pointer(longint(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*y+(x shl 1));
              SurfPtr^:=SurfPtrColor;
            end;
    end; // case...
  end;
end;

{ MUST BE WITHIN A LOCK/UNLOCK AS YOU WOULD USE PUTPIXEL }
procedure TFXGrafix.LinePolar(x, y: integer; angle, length: extended; Color: cardinal);
var
  xp, yp: integer;
begin
  xp:=round(sin(angle*pi/180)*length)+x;
  yp:=round(cos(angle*pi/180)*length)+y;
  Line(x, y, xp, yp, Color);
end;

{ MUST BE WITHIN A LOCK/UNLOCK AS YOU WOULD USE PUTPIXEL }
{ Thanks to Turbo for this proc }
procedure TFXGrafix.WuLine16(x1, y1, x2, y2: Integer; Color: cardinal);
var
  deltax, deltay, loop, start, finish: integer;
  dx, dy, dydx: single; // fractional parts
begin
  deltax := abs(x2 - x1); // Calculate deltax and deltay for initialisation
  deltay := abs(y2 - y1);
  if (deltax = 0) or (deltay = 0) then
  begin // straight lines
    Line(x1, y1, x2, y2, Color);
    exit;
  end;
  if deltax > deltay then // horizontal or vertical
  begin
    if y2 > y1 then // determine rise and run
      dydx := -(deltay / deltax)
    else
      dydx := deltay / deltax;
    if x2 < x1 then
    begin
      start := x2; // right to left
      finish := x1;
      dy := y2;
    end
    else
    begin
      start := x1; // left to right
      finish := x2;
      dy := y1;
      dydx := -dydx; // inverse slope
    end;
    for loop := start to finish do
    begin
      // plot main point
      PutPixelAlpha16(loop, trunc(dy), Color, trunc((1 - frac(dy)) * 255));
      // plot fractional difference
      PutPixelAlpha16(loop, trunc(dy) + 1, Color, trunc(frac(dy) * 255));
      dy := dy + dydx; // next point
    end;
  end
  else
  begin
    if x2 > x1 then // determine rise and run
      dydx := -(deltax / deltay)
    else
      dydx := deltax / deltay;
    if y2 < y1 then
    begin
      start := y2; // right to left
      finish := y1;
      dx := x2;
    end
    else
    begin
      start := y1; // left to right
      finish := y2;
      dx := x1;
      dydx := -dydx; // inverse slope
    end;
    for loop := start to finish do
    begin
      // plot main point
      PutPixelAlpha16(trunc(dx), loop, Color, trunc((1 - frac(dx)) * 255));
      // plot fractional difference
      PutPixelAlpha16(trunc(dx) + 1, loop, Color, trunc(frac(dx) * 255));
      dx := dx + dydx; // next point
    end;
  end;
end;



{ MUST BE WITHIN A LOCK/UNLOCK AS YOU WOULD USE PUTPIXEL }
// I know that the blending of the colours are wrong for the copper bar.
// 27.Mar.2000 Entity - Sort of fixed it... but the 2 halves don't blend into each other
procedure TFXGrafix.CopperBar( const y, cbHeight: integer; TopColor, BottomColor: cardinal);
var
  ColorTop, ColorBot: TRGBQuad;
  rStep, gStep, bStep: extended;
  r,g,b: extended;
  ctr: integer;
begin
  // Extract the Red, Green and Blue values
  with ColorTop do
    GetRGB16(TopColor, rgbRed, rgbGreen, rgbBlue);
  with ColorBot do
    GetRGB16(BottomColor, rgbRed, rgbGreen, rgbBlue);

  { TOP TO BOTTOM }
  { RED }
  if ColorBot.rgbRed=ColorTop.rgbRed then
    rStep:=0
  else
    rStep:=abs((ColorBot.rgbRed-ColorTop.rgbRed) / cbHeight);
  { GREEN }
  if ColorBot.rgbGreen=ColorTop.rgbGreen then
    gStep:=0
  else
    gStep:=abs((ColorBot.rgbGreen-ColorTop.rgbGreen) / cbHeight);
  { BLUE }
  if ColorBot.rgbBlue=ColorTop.rgbBlue then
    bStep:=0
  else
    bStep:=abs((ColorBot.rgbBlue-ColorTop.rgbBlue) / cbHeight);

  r:=ColorTop.rgbRed;
  g:=ColorTop.rgbGreen;
  b:=ColorTop.rgbBlue;
  if ColorBot.rgbRed<=ColorTop.rgbRed then rStep:=-rStep;
  if ColorBot.rgbGreen<=ColorTop.rgbGreen then gStep:=-gStep;
  if ColorBot.rgbBlue<=ColorTop.rgbBlue then bStep:=-bStep;


  // Draw from Top to Middle
  for ctr:=y to y+cbHeight do
    begin
    if (ctr>=0) and (ctr<FHeight-1) then
      HLine(ctr, 0, SurfaceDesc.lPitch div sizeof(word), rgb(round(r),round(g),round(b)));
      r:=r+rStep;
      g:=g+gStep;
      b:=b+bStep;
    end;
end;





{ *** PIXEL FORMAT PROCS *** }
function TFXGrafix.RGBToBGR(Color: cardinal): cardinal;
begin
  result:=(LoByte(LoWord(Color)) shr 3 shl 11) or   // Red
          (HiByte((Color)) shr 2 shl 5) or         // Green
          (LoByte(HiWord(Color)) shr 3);           // Blue

end;

procedure TFXGrafix.GetRGB16(Color: cardinal; var R, G, B: Byte);
begin
  R:=Color;
  G:=Color shr 8;
  B:=Color shr 16;
end;





{ *********************************************************************** }
{ *********************************************************************** }
{ *********************************************************************** }

{ ******* TFXBmpFont procs ******* }

constructor TFXBmpFont.Create(aImageList: TDXImageList; NameInList: string);
begin
  FImageList:=aImageList;
  FNameInList:=NameInList;
  InputChar:='*';
end;

destructor TFXBmpFont.Destroy;
begin
  inherited Destroy;
end;

procedure TFXBmpFont.SetFont(NewNameInList: string);
begin
  FNameInList:=NewNameInList;
end;

{ PRINTS OUT THE TEXT USING BMP FONT }
procedure TFXBmpFont.TextOut( dxDrawSurface: TDirectDrawSurface;
                               xp, yp: integer; mess: string; xCentred: boolean);
var
  ctr: integer;
begin
  if xCentred then
    xp:=(dxDrawSurface.Width div 2) - ((Length(mess)*FImageList.Items.Find(FNameInList).PatternWidth) div 2);
  With FImageList.Items do
    for ctr:=1 to Length(mess) do
      PrintChar(dxDrawSurface, xp+((ctr-1)*Find(FNameInList).PatternWidth), yp, mess[ctr]);
end;

function TFXBmpFont.TextInputStr( DxDrawSurface: TDirectDrawSurface;
                                   xp, yp: integer; InputMess: string;
                                   var aKey: char): string;
const
  LetterCtr: integer = 0;
  FirstTime: boolean = true;
  aString:   string  = '';
var
  x,y : integer;
  cx, cy: integer;
  xc: integer;
begin
  if FirstTime then
  begin
    SetLength(aString, 1);
    aString:='';
    FirstTime:=false;
  end;

  Textout(DxDrawSurface, xp, yp, InputMess, false);
  y:=yp;
  x:=xp+((Length(InputMess)+2)*FImageList.Items.Find(FNameInList).PatternWidth);
  cy:=y;
  cx:=x;
  Textout(DxDrawSurface, x, y, aString, false);

  if aKey=#13 then
  begin
    result:=aString;
    aString:='';
    LetterCtr:=0;
    x:=-100;
    y:=-100;
    FirstTime:=true;
  end
  else
  // Only allows characters that are in the FontTable
  if (pos(aKey, FontTable)>0) or (aKey in [' ']) then
  begin
    LetterCtr:=LetterCtr+1;
    SetLength(aString, LetterCtr);
    aString[LetterCtr]:=aKey;
  end;
  aKey:='*';
  cy:=y;
  cx:=x+((LetterCtr)*FImageList.Items.Find(FNameInList).PatternWidth);
  DisplayCursor(DxDrawSurface, cx, cy);
end;

function TFXBmpFont.TextInputInt( DxDrawSurface: TDirectDrawSurface;
                                   xp, yp: integer; InputMess: string;
                                   var aKey: char): cardinal;
const
  MaxLetters: byte = 8;
  LetterCtr: integer = 0;
  FirstTime: boolean = true;
  aString:   string  = '';
var
  x,y : integer;
  cx, cy: integer;
  xc: integer;
begin
  if FirstTime then
  begin
    SetLength(aString, 1);
    aString:='';
    FirstTime:=false;
  end;

  Textout(DxDrawSurface, xp, yp, InputMess, false);
  y:=yp;
  x:=xp+((Length(InputMess)+2)*FImageList.Items.Find(FNameInList).PatternWidth);
  cy:=y;
  cx:=x;
  Textout(DxDrawSurface, x, y, aString, false);

  if aKey=#13 then
  begin
    result:=strtoint(aString);
    aString:='';
    LetterCtr:=0;
    x:=-100;
    y:=-100;
    FirstTime:=true;
  end
  else
  if aKey in ['0'..'9'] then
  begin
    LetterCtr:=LetterCtr+1;
    if LetterCtr>MaxLetters then LetterCtr:=MaxLetters;
    SetLength(aString, LetterCtr);
    aString[LetterCtr]:=aKey;
  end;
  aKey:='*';
  cy:=y;
  cx:=x+((LetterCtr)*FImageList.Items.Find(FNameInList).PatternWidth);
  DisplayCursor(DxDrawSurface, cx, cy);
end;

{ PRINTS OUT A CHARACTER USING BMP FONT }
procedure TFXBmpFont.PrintChar(dxDrawSurface: TDirectDrawSurface; xp, yp: integer; aChar: char);
begin
  with FImageList.Items do
  begin
      // Searches the FontTable string to find where the letters/numbers/symbols
      // are in the BMP.
      if pos(aChar,FontTable)-1<Find(FNameInList).PatternCount then
      if aChar in ['0'..'9','A'..'Z', 'a'..'z'] then
//        if aChar in ['g','j','p','q','y'] then  // Increase pos by 5 to take tail into account
//          Find(FNameInList).Draw(dxDrawSurface, xp, yp+5, pos(aChar,FontTable)-1)
//        else
          Find(FNameInList).Draw(dxDrawSurface, xp, yp, pos(aChar,FontTable)-1);
  end;
end;

procedure TFXBmpFont.DisplayCursor(DxDrawSurface: TDirectDrawSurface; xp, yp: integer);
const
  ShowCursor: boolean = true;
  BlinkTimer: integer = 0;
  MaxBlinkTime = 20;
begin
  inc(BlinkTimer);
  if BlinkTimer>MaxBlinkTime then
  begin
    ShowCursor:=not(ShowCursor);
    BlinkTimer:=0;
  end;
  if ShowCursor then
  begin
    with DxDrawSurface.Canvas do
    begin
      Brush.Color:=clRed;
      Pen.Color:=Brush.Color;
      Rectangle(xp, yp+((FImageList.Items.Find(FNameInList).PatternHeight)-(FImageList.Items.Find(FNameInList).PatternHeight) div 4),
                xp+FImageList.Items.Find(FNameInList).PatternWidth,
                yp+FImageList.Items.Find(FNameInList).PatternHeight);
      Release;
    end;
  end;
end;




// ===========================================
// == FXSinusScroller CLASS PROCS
// ===========================================

constructor TFXSinusScroller.Create(aImageList: TDXImageList; NameInList: string);
begin
  inherited Create;
  StartOver:=true;
  FImageList:=aImageList;
  FNameInList:=NameInList;
end;

destructor TFXSinusScroller.Free;
begin
  inherited Destroy;
end;

procedure TFXSinusScroller.Scroll( dxDrawSurface: TDirectDrawSurface;
                                   yp: integer; xAmp, yAmp, Angle: extended;
                                   Speed: integer; yCentred, Loop: boolean);
var
  xSin, ySin: extended;
  WidthOffset: integer;
  ctr: integer;
  mess: string;
begin
  if StartOver then
  begin
    xp:=dxDrawSurface.Width+100;
    StartOver:=false;
  end;

  mess:=SinText;
  if yCentred then
    yp:=(dxDrawSurface.Height div 2) - (FImageList.Items.Find(FNameInList).PatternHeight div 2)-(FImageList.Items.Find(FNameInList).PatternHeight div 2);
  With FImageList.Items do
    for ctr:=1 to Length(mess) do
    begin
      WidthOffset:=Find(FNameInList).PatternWidth div 2; // Writes letters a little closer together
      xSin:=cos((ctr+angle)*pi/180)+sin((ctr+angle)*pi/180)*xAmp+(ctr*WidthOffset)+xp;
      ySin:=sin((((ctr*WidthOffset)+ctr*5)+angle)*pi/180)*yAmp+yp;
      PrintChar(dxDrawSurface, round(xSin)+((ctr-1)*Find(FNameInList).PatternWidth), round(ySin), mess[ctr]);
    end;
    // Start over
    if Loop then
      if xp+((length(mess)*(FImageList.Items.Find(FNameInList).PatternWidth+(WidthOffset))))<0 then
      begin
        xp:=dxDrawSurface.Width+100;
        StartOver:=true;
      end;
    xp:=xp-Speed;
end;

procedure TFXSinusScroller.PrintChar(dxDrawSurface: TDirectDrawSurface; xp, yp: integer; aChar: char);
begin
  with FImageList.Items do
  begin
      // Searches the FontTable string to find where the letters/numbers/symbols
      // are in the BMP.
      if pos(aChar,FontTable)-1<Find(FNameInList).PatternCount then
      if aChar in ['0'..'9','A'..'Z', 'a'..'z'] then
//        if aChar in ['g','j','p','q','y'] then  // Increase pos by 5 to take tail into account
//          Find(FNameInList).Draw(dxDrawSurface, xp, yp+5, pos(aChar,FontTable)-1)
//        else
          Find(FNameInList).Draw(dxDrawSurface, xp, yp, pos(aChar,FontTable)-1);
  end;
end;





end.