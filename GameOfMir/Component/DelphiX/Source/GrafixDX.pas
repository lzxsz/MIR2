unit GrafixDX;

{ GrafixDX v0.1a   Started 19.March.2000

  Only 16Bit mode fully supported for now.  Other modes will be added when they're
  written ;o]

  This lib is basically an extension to delphix.  Various effects where
  delphix lacks or is just too slow.  I would like for this lib to be
  continually added to ;-]

  This unit is the merging of my other units.. FontPrintDX, PixelsDX, etc..
  which I started in 1999 with a whole host of new bits.

  There is going to be 3 main people working on this lib... LifePower, Turbo
  and of course, myself - Entity.  Thanks u guyz.. this is gonna make delphix
  the ultimate for game coding :-]

  But we do urge anyone to contribute their 'cool' bits of code/ideas ;-]
  Also any bug fixes or optimizations would be most welcome :-D
  Please send any new versions to :

   NICK           EMAIL                         ICQ #

   Entity         craigd@talk21.com             42406817
   LifePower      
   Turbo

  This way we can keep track so there isn't multiple versions :o]


[ UPDATES ]

  25.Mar.2000     Copperbar -- now 4x faster than line() !!!!!  :oD



[ IT'D BE NICE IF IT HAD... ]
     These are just things I can think of for now, and I will implement when
     I have time/patience or maybe even better u WILL ;-]

  GFX FX
   Fast AlphaBlending  - kinda essential for a game, depends on the game really
   2D Lighting         - very useful for lighting on tiles - prolly be too slow though?!?!
   AntiAliased stuff   - looks cool
   Wu Pixels/Lines     - looks even better than AA
   Bump Mapping        - very cool effect
   Tunnel              - the infamous tunnel effect
   Copper bars         - from the glorious C64/Amiga dayz

  GAME STUFF
   HiScore Table - definitely useful for games
   Line Of Sight - for dungeon games
   Simple Pathfinding - must be simple to be useful (I'm currently researching this)

  COLLISION
   Sector testing - tests if object is within a certain sector
   Bounding box   - checks if bounding boxes of objects intersect
   Point in Box/Line/Circle/Triangle/Etc - tests if a point is inside a shape

  FONT STUFF
   Proper Sinus Scroller where fonts 'rotate' as it moves through the Sinus ;-]

  MISC STUFF
   Menu capabilities          - useful allrounder
   Windowing     - maybe using skins
   Buttons stuff - well...kinda essential for windowing ;-]


   

[ THE FEATURES LIST ]

 ((Most recent first))

 NOTE: A '*' next to the Proc name denotes an update - not an addition

*** TGrafixSurface ***

   PROC NAME              TYPE        AUTHOR        DATE ADDED

   VLine                  GFX         Entity        26.Mar.2000
   RGBToBGR               UTIL        Entity        24.Mar.2000
   CopperBar              GFX         Entity        23.Mar.2000
   FlipX                  FX          Entity        23.Mar.2000
   FlipY                  FX          Entity        23.Mar.2000
   PointInCircle          COLLISION   Entity        22.Mar.2000
   GetRGB                 GFX         Entity        21.Mar.2000
   LinePolar              GFX         Entity        21.Mar.2000
   LoadFromJpeg           UTIL        Entity        20.Mar.2000
   CopyFromSurface        UTIL        Entity        20.Mar.2000
   DrawToDXDraw           UTIL        Entity        20.Mar.2000
   SetPixel               GFX         Entity        20.Mar.2000
   GetPixel               GFX         Entity        20.Mar.2000
   Line                   GFX         Entity        20.Mar.2000

*** TBmpFont ***

   PROC NAME              TYPE        AUTHOR        DATE ADDED

   TextOut                GENERAL     Entity        22.Mar.2000
   PrintChar              GENERAL     Entity        22.Mar.2000



[ DESCRIPTIONS OF THE PROCS ]

    ** UTILITY ROUTINES
    procedure LoadFromJpeg(Filename: string; ResizeFromFile: boolean);
     Load a Jpeg to the surface

    procedure CopyFromSurface(var SrcSurface: TDirectDrawSurface);
     Copy from source surface

    procedure DrawToDXDraw(xp, yp: integer; aTransparent: boolean); virtual;
     Draw the surface to DXDraw surface

    ** PIXEL FORMAT ROUTINES
    function RGBToBGR(Color: cardinal): cardinal;
     Converts Color in RGB format to Color in BGR format
     Returns Color in BGR format

    procedure GetRGB(Color: cardinal; var R, G, B: Byte);
     Returns the RGB components of a Color

    ** GFX ROUTINES
    function Lock: Boolean;
     Lock the surface ready for writing
     Returns true if successful

    procedure Unlock;
     Unlock the surface

    procedure PutPixel(x, y: Integer; Color: cardinal); virtual;
     Writes a pixel to the surface

    function GetPixel(x, y: Integer) : cardinal; virtual;
     Returns the color stored at x,y on the surface

    procedure Line(X1, Y1, X2, Y2: Integer; Color: cardinal); virtual;
     Draws a normal line

    procedure LinePolar(x, y: integer; angle, length: extended; Color: cardinal); virtual;
     Draws a line according to position, angle and length

    procedure CopperBar(y, cbHeight: integer; TopColor, MiddleColor, BottomColor: cardinal); virtual;
     Draws a copperbar - infamous from the C64/Amiga dayz :oD

    ** COLLISION ROUTINES
    function PointInCircle(xp, yp: integer; xCircle, yCircle, Radius: extended): boolean;
     Tests if a point(xp,yp) is inside a circle(xCircle, yCircle, Radius)

    ** FX ROUTINES
    procedure FlipX; virtual;
     Flip the surface horizontally

    procedure FlipY; virtual;
     Flip the surface vertically


}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, JPeg,
  DXClass, DXDraws,
{$IfDef StandardDX}
  DirectDraw;
{$Else}
  DirectX;
{$EndIf}

type
  TBitDepth = (bd8, bd15, bd16, bd24, bd32); // The bitdepths

  TPixelProc = procedure (x, y: Integer; Color: cardinal) of object;


  TBmpFont = class
  private
    FDXDraw: TDXDraw;
    FSurface: TDirectDrawSurface;
    FImageList: TDXImageList;
    FWidth,
    FHeight: integer;
    FNameSet,
    FNameSet2: string;
    FScale:     extended; // The scaling for the fonts
    FAspect:    extended; // Aspect ratio of surface
    procedure SetDrawSurface(aSurface: TDirectDrawsurface);
  public
    constructor Create(DestSurface: TDirectDrawSurface);
    destructor Destroy;
    procedure Init(aDXDraw: TDXDraw; aImageList: TDXImageList;
                   aNameSet, aNameSet2: string);
    // The writing routines
    procedure Textout(xp, yp: integer; mess: string; xCentred: boolean);
    procedure PrintChar(xp, yp: integer; aChar: char);
    // Time savers
    property FontName: string read FNameSet write FNameSet;
    property Surface: TDirectDrawSurface read FSurface write SetDrawSurface;
  end;


  TGrafixSurface = class(TDirectDrawSurface)
  private
    FWidth,
    FHeight:    integer;
    FDXDraw:    TDXDraw;
    FImageList: TDXImageList;
    FSurface:   TDirectDrawSurface;
//    FSurface: TGrafixSurface;
    FPixelProc: TPixelProc;
    FSurfaceDesc: TDDSurfaceDesc2;
    FBitDepth:  TBitDepth;
    FRect:      TRect;
    FAspect:    extended; // Aspect ratio of surface
    FLockRect:  TRect;
    FTransColor: cardinal;
    function GetCurrentSurface: TDirectDrawSurface;
    procedure SetCurrentSurface(aSurface: TDirectDrawSurface);
    procedure SetPixelProc(NewPixelProc: TPixelProc);
  public
    UseAspect: boolean;
    SurfaceDesc: TDDSurfaceDesc2;
    // General surface routines
    constructor Create(ADraw: TDirectDraw);
    destructor Destroy;
    procedure Init( aDXDraw: TDXDraw; aImageList: TDXImageList;
                    aWidth, aHeight: integer;
                    TransColor: cardinal );
    // Utility routines
    procedure LoadFromJpeg(Filename: string; ResizeFromFile: boolean);
    procedure CopyFromSurface(var SrcSurface: TDirectDrawSurface);
    procedure DrawToDXDraw(xp, yp: integer; aTransparent: boolean); virtual;
    // Pixel Format routines
    function RGBToBGR(Color: cardinal): cardinal;
    procedure GetRGB(Color: cardinal; var R, G, B: Byte);
    // Gfx routines
    function Lock: Boolean;
    procedure Unlock;
    procedure PutPixel(x, y: Integer; Color: cardinal); virtual;
    function GetPixel(x, y: Integer) : cardinal; virtual;
    procedure Line(X1, Y1, X2, Y2: Integer; Color: cardinal); virtual;
    procedure VLine(x,y1,y2: integer; Color: cardinal);
    procedure LinePolar(x, y: integer; angle, length: extended; Color: cardinal); virtual;
    procedure CopperBar(y, cbHeight: integer; TopColor, MiddleColor, BottomColor: cardinal); virtual;
    // Collision routines
    function PointInCircle(xp, yp: integer; xCircle, yCircle, Radius: extended): boolean;
    // FX routines
    procedure FlipX; virtual;
    procedure FlipY; virtual;
    // Time savers
    property BitDepth: TBitDepth read FBitDepth;
    property Surface: TDirectDrawSurface read GetCurrentSurface write SetCurrentSurface;
    property PixelProc: TPixelProc write SetPixelProc; // Just testing..DO NOT USE!!!!
  end;


implementation


// ==========================================
// ==           BMPFONT PROCS              ==
// ==========================================

constructor TBmpFont.Create(DestSurface: TDirectDrawSurface);
begin
  inherited Create;
  FSurface:=DestSurface;
  FAspect:=FSurface.Width div FSurface.Height;
end;

destructor TBmpFont.Destroy;
begin
  inherited Destroy;
end;


procedure TBmpFont.Init(aDXDraw: TDXDraw; aImageList: TDXImageList;
                   aNameSet, aNameSet2: string);
begin
  FDXDraw:=aDXDraw;
  FImageList:=aImageList;
  FNameSet:=aNameSet;
  FNameSet2:=aNameSet2;
end;

procedure TBmpFont.TextOut(xp, yp: integer; mess: string; xCentred: boolean);
var
  ctr: integer;
begin
  if xCentred then
    xp:=(FSurface.Width div 2) - ((Length(mess)*FImageList.Items.Find(FNameSet).PatternWidth) div 2);
  With FImageList.Items do
    for ctr:=1 to Length(mess) do
    begin
      if upcase(mess[ctr]) in ['A'..'Z'] then
        Find(FNameSet).Draw(FSurface, xp+((ctr-1)*Find(FNameSet).PatternWidth), yp, ord(upcase(mess[ctr]))-65);
      if mess[ctr] in ['0'..'9'] then
        Find(FNameSet).Draw(FSurface, xp+((ctr-1)*Find(FNameSet).PatternWidth), yp, ord(mess[ctr])-22);
    end;
end;

procedure TBmpFont.PrintChar(xp, yp: integer; aChar: char);
begin
  with FImageList.Items do
  begin
    if upcase(aChar) in ['A'..'Z'] then
      Find(FNameSet).Draw(FSurface, xp, yp, ord(upcase(aChar))-65);
    if aChar in ['0'..'9'] then
      Find(FNameSet).Draw(FSurface, xp, yp, ord(aChar)-22);
  end;
end;

procedure TBmpFont.SetDrawSurface(aSurface: TDirectDrawsurface);
begin
  FSurface:=aSurface;
end;





// ==========================================
// ==        GRAFIXSURFACE PROCS           ==
// ==========================================


constructor TGrafixSurface.Create(ADraw: TDirectDraw);
begin
  inherited Create(ADraw);
end;

destructor TGrafixSurface.Destroy;
begin
  inherited Destroy;
end;


{ INIT THE SURFACE }
procedure TGrafixSurface.Init( aDXDraw: TDXDraw;
                               aImageList: TDXImageList;
                               aWidth,
                               aHeight: integer;
                               TransColor: cardinal );
begin
  FDXDraw:=aDXDraw;
  FImageList:=aImageList;
  FWidth:=aWidth;
  FHeight:=aHeight;
  FSurface:=TGrafixSurface(self);

  FPixelProc:=PutPixel;

  FTransColor:=TransColor;
  FSurface.TransparentColor:=FTransColor;

  if aWidth=0 then FWidth:=FDXDraw.SurfaceWidth;
  if aHeight=0 then FHeight:=FDXDraw.SurfaceHeight;

  setsize(FWidth, FHeight);
  FAspect:=FWidth div FHeight;

  // Determines which mode DXDraw is in
  case FDXDraw.Surface.BitCount of
    8: FBitDepth:=bd8;
    15: FBitDepth:=bd15; // For older cards that use 555 format (Rush)
    16: FBitDepth:=bd16;
    24: FBitDepth:=bd24;
    32: FBitDepth:=bd32;
  end;
end;


{ LOAD A JPG IMAGE TO THE SURFACE }
procedure TGrafixSurface.LoadFromJpeg(Filename: string; ResizeFromFile: boolean);
var
  MyBmp: TBitmap;
  MyJpeg: TJpegImage;
begin
  MyBmp:=TBitmap.Create;
  MyJpeg:=TJpegImage.Create;
  MyJpeg.LoadFromFile(Filename);
  MyJpeg.DIBNeeded;
  MyBmp.Assign(MyJpeg); // Copy the Jpeg Image to Bmp

  // Resize surface to the original file width/height
  if ResizeFromFile then
  begin
    FWidth:=MyBmp.Width;
    FHeight:=MyBmp.Height;
    SetSize(FWidth, FHeight);
  end;

  // Store the rect of the surface
  FRect:=rect(0,0,FWidth,FHeight);
  FSurface.Canvas.StretchDraw(FRect, MyBmp); // Stretch image to size of surface
  FSurface.Canvas.Release; // This is so vital otherwise it'll crash

  MyJpeg.Free;
  MyBmp.Free;
end;

{ COPY FROM ANOTHER SURFACE }
procedure TGrafixSurface.CopyFromSurface(var SrcSurface: TDirectDrawSurface);
begin
  Assign(TGrafixSurface(SrcSurface));
end;

procedure TGrafixSurface.DrawToDXDraw(xp, yp: integer; aTransparent: boolean);
begin
  // Draw the GrafixSurface to DXDraw surface
  FSurface.TransparentColor:=FTransColor;
  FDXDraw.Surface.Draw(xp, yp, rect(0,0,FWidth, FHeight), FSurface, aTransparent);
end;

{ *********** THE PIXEL FORMAT ROUTINES ************ }

function TGrafixSurface.RGBToBGR(Color: cardinal): cardinal;
begin
  result:=(LoByte(LoWord(Color)) shr 3 shl 11) or   // Red
          (HiByte((Color)) shr 2 shl 5) or    // Green
          (LoByte(HiWord(Color)) shr 3);           // Blue
end;

procedure TGrafixSurface.GetRGB(Color: cardinal; var R, G, B: Byte);
begin
  R:=Color;
  G:=Color shr 8;
  B:=Color shr 16;
end;


{ *********** THE GFX ROUTINES ************ }

{ LOCK THE SURFACE }
function TGrafixSurface.Lock: Boolean;
begin
  Result:=True;
  FSurfaceDesc.dwSize:=SizeOf( TDDSurfaceDesc2 );
  FLockRect:=Rect(0,0,FSurfaceDesc.dwWidth,FSurfaceDesc.dwHeight);

{ The following 2 lines were the cause of a really annoying/hard to track bug }
//  FWidth:=FSurfaceDesc.dwWidth;
//  FHeight:=FSurfaceDesc.dwHeight;

  if FSurface.ISurface4.Lock( @FLockRect, FSurfaceDesc, DDLOCK_SURFACEMEMORYPTR+DDLOCK_WAIT, 0 )<>DD_OK then Result:=False;
  SurfaceDesc:=FSurfaceDesc;
end;

{ UNLOCK SURFACE }
procedure TGrafixSurface.Unlock;
begin
  FSurface.ISurface4.Unlock( @FLockRect );
end;


{ WRITE A PIXEL ON SURFACE }
procedure TGrafixSurface.PutPixel( X, Y: Integer; Color: cardinal);
var
   xp, yp: Integer;
   r,g,b: byte;
begin
  GetRGB(Color,r,g,b);

  if (x<0) or (x>FWidth-1) or (y<0) or (y>FHeight-1) then
    Exit
  else
    case FBitDepth of
      bd8:
        PByte(integer(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*Y+X)^:=Color;
      bd16:
       begin
         Color:=RGBToBGR(rgb(r,g,b));
         PWord(integer(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*Y + (X shl 1))^ :=
           Color;
{               (LoByte(LoWord(Color)) shr 3 shl 11) or   // Red
               (HiByte((Color)) shr 2 shl 5) or    // Green
               (LoByte(HiWord(Color)) shr 3);            // Blue
}       end;
    end;
end;


// NOW WORKS!!!   - 11.Feb.2000  THANKS TO THE DIBULTRA AUTHOR :)
{ GET PIXEL COLOUR FROM SURFACE }
function TGrafixSurface.GetPixel(x, y: Integer) : cardinal;
var
  res: cardinal;
begin
   Result := 0;

   case FBitDepth of
     bd8:
       result:=PByte(integer(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*Y+X)^;
     bd16:
      begin
       Result:=PWord(integer(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*Y + (X shl 1))^;
       res:=((Result and $001F) shl 19) + ((Result and $07E0) shl 5) + (Result and $F800) shr 8;
       result:=res;
      end;
   end;
end;


{ DRAW A NORMAL LINE }
procedure TGrafixSurface.Line(X1, Y1, X2, Y2: Integer; Color: cardinal);
var
  i, deltax, deltay, numpixels,
  d, dinc1, dinc2,
  x, xinc1, xinc2,
  y, yinc1, yinc2: Integer;
begin
  { Calculate deltax and deltay for initialisation }
  deltax := abs(x2 - x1);
  deltay := abs(y2 - y1);

  { Initialise all vars based on which is the independent variable }
  if deltax>=deltay then
  begin
    { x is independent variable }
    numpixels:=deltax+1;
    d:=(2*deltay)-deltax;

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
    d:=(2*deltax)-deltay;
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
    if (x>0) and (x<FWidth) and (y>0) and (y<FHeight-1) then
      FPixelProc( x,y, Color );
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

procedure TGrafixSurface.VLine(x,y1,y2: integer; Color: cardinal);
var
  y:integer;
  SurfPtr: ^word;
  SurfPtrColor: cardinal;
  r,g,b: byte;
begin
  if y1<0 then y1:=0;
  if y2>=FHeight then y2:=FHeight-1;

//  for y:=y1 to y2 do  VoxSurface.PutPixel( x,y,rgb(Pal[c].peRed,Pal[c].peGreen,Pal[c].peBlue));
  // The following is 2x faster than the above line of code
  GetRGB(Color, r,g,b);
  SurfPtrColor:=RGBToBGR(rgb(r,g,b));
  for y:=y1 to y2 do
  begin
    SurfPtr:=pointer(longint(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*y+(x shl 1));
    SurfPtr^:=SurfPtrColor;
  end;
end;


{ MUST BE WITHIN A LOCK/UNLOCK AS YOU WOULD USE SETPIXEL }
procedure TGrafixSurface.LinePolar(x, y: integer; angle, length: extended; Color: cardinal);
var
  xp, yp: integer;
begin
  xp:=round(sin(angle*pi/180)*length)+x;
  yp:=round(cos(angle*pi/180)*length)+y;
  Line(x, y, xp, yp, Color);
end;


{ MUST BE WITHIN A LOCK/UNLOCK AS YOU WOULD USE SETPIXEL }
// I know that the blending of the colours are wrong for the copper bar but
// they'll soon be fixed!!
procedure TGrafixSurface.CopperBar( y, cbHeight: integer; TopColor, MiddleColor,
                                    BottomColor: cardinal);
var
  ColorTop, ColorMid, ColorBot: TRGBQuad;
  rStep, gStep, bStep: integer;
  r,g,b: byte;
  MidPos: integer;
  ctr: integer;
  SurfPtr: ^word;  // This is the pointer to the surface
  SurfPtrColor: cardinal; // The color to plot
  ctrx: integer;
begin
  MidPos:=cbHeight shr 1; // Get the centre of the copperbar

  // Extract the Red, Green and Blue values
  with ColorTop do
    GetRGB(TopColor, rgbRed, rgbGreen, rgbBlue);
  with ColorMid do
    GetRGB(MiddleColor, rgbRed, rgbGreen, rgbBlue);
  with ColorBot do
    GetRGB(BottomColor, rgbRed, rgbGreen, rgbBlue);

  { TOP TO MIDDLE }
  rStep:=(ColorMid.rgbRed-ColorTop.rgbRed) div MidPos;
  gStep:=(ColorMid.rgbGreen-ColorTop.rgbGreen) div MidPos;
  bStep:=(ColorMid.rgbBlue-ColorTop.rgbBlue) div MidPos;
  r:=ColorTop.rgbRed;
  g:=ColorTop.rgbGreen;
  b:=ColorTop.rgbBlue;
{  if ColorMid.rgbRed-ColorTop.rgbRed<0 then rStep:=-rStep;
  if ColorMid.rgbGreen-ColorTop.rgbGreen<0 then gStep:=-gStep;
  if ColorMid.rgbBlue-ColorTop.rgbBlue<0 then bStep:=-bStep;
}

  // Draw from Top to Middle
  for ctr:=y to y+MidPos do
    if (ctr<FHeight-1) and (ctr>=0) then
    begin
      // A HELLUVA LOT FASTER THAN DRAWING WITH THE LINE() PROC - 2x Faster than with Line()
      // 25.Mar.2000 - Now 4x Faster!!!!
      SurfPtr:=pointer(longint(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*ctr);
      SurfPtrColor:=rgbtobgr(rgb(r,g,b));
      // Draw the line across the screen
      for ctrx:=0 to FSurfaceDesc.lpitch div sizeof(word) do
      begin
        SurfPtr^:=SurfPtrColor;
        inc(SurfPtr);
      end;
//    Line(0, ctr, FWidth, ctr, rgb(r,g,b));
      r:=r+rStep;
      g:=g+gStep;
      b:=b+bStep;
    end;

  { MIDDLE TO BOTTOM }
  rStep:=(ColorBot.rgbRed-ColorMid.rgbRed) div MidPos;
  gStep:=(ColorBot.rgbGreen-ColorMid.rgbGreen) div MidPos;
  bStep:=(ColorBot.rgbBlue-ColorMid.rgbBlue) div MidPos;
  r:=ColorMid.rgbRed;
  g:=ColorMid.rgbGreen;
  b:=ColorMid.rgbBlue;
{  if ColorBot.rgbRed-ColorMid.rgbRed<0 then rStep:=-rStep;
  if ColorBot.rgbGreen-ColorMid.rgbGreen<0 then gStep:=-gStep;
  if ColorBot.rgbBlue-ColorMid.rgbBlue<0 then bStep:=-bStep;
}
  for ctr:=y+MidPos+1 to y+cbHeight do
    if (ctr<FHeight-1) and (ctr>=0) then
    begin
      // A HELLUVA LOT FASTER THAN DRAWING WITH THE LINE() PROC - 2x Faster than with Line()
      // 25.Mar.2000 - Now 4x Faster!!!!
      SurfPtr:=pointer(longint(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*ctr);
      SurfPtrColor:=rgbtobgr(rgb(r,g,b));
      for ctrx:=0 to FSurfaceDesc.lpitch div sizeof(word) do
      begin
        SurfPtr^:=SurfPtrColor;
        inc(SurfPtr);
      end;
//    Line(0, ctr, FWidth, ctr, rgb(r,g,b));
      r:=r+rStep;
      g:=g+gStep;
      b:=b+bStep;
    end;

  SurfPtr:=nil;
end;



function TGrafixSurface.PointInCircle(xp, yp: integer; xCircle, yCircle, Radius: extended): boolean;
begin
  Result:=false;
  Result:=sqr(xCircle-xp)+sqr(yCircle-yp)<sqr(Radius);
end;

procedure TGrafixSurface.FlipX;
begin
  FSurface.Draw(0, 0, rect(FWidth, 0, 0, FHeight), FSurface, false);
//  FSurface.Blt(rect(150,0,0,150), rect(0,0,FWidth,FHeight), DDBLTFX_MIRRORLEFTRIGHT, df, FSurface);
//  FSurface.StretchDraw( rect(0, 0, 150, 150), rect(FWidth, 0,0,FHeight), FSurface, true);
end;

procedure TGrafixSurface.FlipY;
begin
  FSurface.Draw(0, 0, rect(0, FHeight,FWidth,0), FSurface, false);
end;


function TGrafixSurface.GetCurrentSurface: TDirectDrawSurface;
begin
  result:=FSurface;
end;

procedure TGrafixSurface.SetCurrentSurface(aSurface: TDirectDrawSurface);
begin
  FSurface:=aSurface;
  FWidth:=aSurface.Width;
  FHeight:=aSurface.Height;
end;

procedure TGrafixSurface.SetPixelProc(NewPixelProc: TPixelProc);
begin
  FPixelProc:=NewPixelProc;
end;


end.