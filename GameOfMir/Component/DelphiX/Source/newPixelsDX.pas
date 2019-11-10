{

 Last Pixel DX Version : 8/08/2000

 Is now compatible with GrafixDx Unit( see below)
 And i add some procedures

 WARNING : Some procedure, are only available in 16 bit mode

 --------------------------------------------------------------------------
 Thanks to : CreepingHost (ENTITY)'s original PixelDX version
 and his GrafixDX unit
 EMAIL: craigd@talk21.com

 Henri Hakl for his PixelCore unit
 EMAIL: 12949442@narga.sun.ac.za

 Michael Wilson no.2 game for his TurboPixel unit.
 URL http://www.no2games.com & http://www.no2games.com/turbo
 wilson@no2games.com

 Lifepower for his PowerDraw
 EMAIL: arcane@techie.com
 --------------------------------------------------------------------------

 If you make some change, please send me an e-mail.

 by J.DELAUNEY
 EMAIL : jdelauney@free.fr
 URL : http://www.multimania.com/jdelauney


 --------------------------------------------------------------------------
}

unit NewPixelsDX;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  DXDraws, Jpeg,
{$IfDef StandardDX}
  DirectDraw;
{$Else}
  DirectX;
{$EndIf}

const pgOk = 0;                // operation successful
      pgInvalidBitCount = 1;   // invalid bit count
      pgPatternOut = 2;        // specified pattern is out of image rectangle

Type
  TBitDepth = (bd8, bd15, bd16, bd24, bd32); // The bitdepths



  TGrafixSurface = class(TDirectDrawSurface)
  private
    FWidth,
    FHeight:    integer;
    FDXDraw:    TDXDraw;
    FImageList: TDXImageList;
    FSurface:   TDirectDrawSurface;
    FSurfaceDesc: TDDSurfaceDesc_DX6;//TDDSurfaceDesc2;
    FBitDepth:  TBitDepth;
    FRect:      TRect;
    FAspect:    extended; // Aspect ratio of surface
    FLockRect:  TRect;
    FTransColor: cardinal;
    FOpResult:Integer;
    FClipRect:TRect;
    SinTable,
    CosTable:Array[0..1023] of Integer;

    function GetCurrentSurface: TDirectDrawSurface;
    procedure SetCurrentSurface(aSurface: TDirectDrawSurface);
//    procedure SetPixelProc(NewPixelProc: Pointer);

//    procedure PutPixel8(x, y, color: Integer); virtual;
//    procedure PutPixel16(x, y, color: Integer); virtual;
//    procedure PutPixel24(x, y, color: Integer); virtual;
//    procedure PutPixel32(x, y, color: Integer); virtual;
//
//    function GetPixel8(x, y: Integer) : integer; virtual;
//    function GetPixel16(x, y: Integer) : integer; virtual;
//    function GetPixel24(x, y: Integer) : integer; virtual;
//    function GetPixel32(x, y: Integer) : integer; virtual;
//
    procedure Line8(X1, Y1, X2, Y2, color: Integer); virtual;
    procedure Line16(X1, Y1, X2, Y2, color: Integer); virtual;
    procedure Line24(X1, Y1, X2, Y2, color: Integer); virtual;
    procedure Line32(X1, Y1, X2, Y2, color: Integer); virtual;

    Procedure Rotate(cent1,cent2,angle:Integer;coord1,coord2:Real;clr:word); // For drawing circle
    
  public

    UseAspect: boolean;
    property SurfaceDesc: TDDSurfaceDesc_DX6 read FSurfaceDesc;


    // General surface routines
    constructor Create(ADraw: TDirectDraw);
    destructor Destroy; override;
    procedure Init( aDXDraw: TDXDraw; aImageList: TDXImageList;
                    aWidth, aHeight: integer;
                    TransColor: cardinal );

    // Utility routines
    procedure LoadFromJpeg(Filename: string; ResizeFromFile: boolean);
    procedure CopyFromSurface(var SrcSurface: TDirectDrawSurface);
    procedure DrawToDXDraw(xp, yp: integer; aTransparent: boolean); virtual;

    procedure DrawRotate(Image:TPictureCollectionItem;Xpos,Ypos,Pattern,Angle:Integer);
    procedure DrawRotateBlend(Image:TPictureCollectionItem;Xpos,Ypos,Pattern,Angle,Opacity:Integer);
    procedure DrawRotateAddBlend(Image:TPictureCollectionItem;Xpos,Ypos,Pattern,Angle,Opacity:Integer);
    procedure DrawRotateAdd(Image:TPictureCollectionItem;Xpos,Ypos,Pattern,Angle:Integer);

    procedure DrawAdd(Image:TPictureCollectionItem;Xpos,Ypos,Pattern:Integer);
    procedure DrawBlend(Image:TPictureCollectionItem;Xpos,Ypos,Pattern,Opacity:Integer);
    procedure DrawHalfBlend(Image:TPictureCollectionItem;Xpos,Ypos,Pattern:Integer);
    procedure DrawAddBlend(Image:TPictureCollectionItem;Xpos,Ypos,Pattern,Opacity:Integer);

    // Pixel Format routines
    function RGBToBGR(Color: cardinal): cardinal;
    procedure GetRGB(Color: cardinal; var R, G, B: Byte);



    // Gfx routines
    function Lock: Boolean;
    procedure Unlock;


    procedure PutPixel(x, y, color: Integer); virtual;

    procedure BlendPixel(X,Y,Color:Integer;Transparency:Integer);virtual;
    procedure BlendPixel16(X,Y:Integer;Color:Word;Transparency:Integer);virtual;
    procedure AddPixel(X,Y,Color:Integer);virtual; // Only in 16 bit mode
//    PutRGBPixel
//    BlendRGBPixel16


    function GetPixel(x, y: Integer) : integer; virtual;

    procedure Line(X1, Y1, X2, Y2, color: Integer); virtual;
    procedure VLine(x,y1,y2: integer; Color: cardinal);virtual;
    procedure WuLine(X1,Y1,X2,Y2,Color:Integer);virtual; // Only in 16 bit mode
    procedure LinePolar(x, y: integer; angle, length: extended; Color: cardinal); virtual;

    procedure Ellipse(exc, eyc, ea, eb, i, clr : Integer);virtual;
    procedure FillEllipse(xc,yc,a,b,color:integer);virtual;
    procedure Circle(X, Y, Radius,Color: integer);virtual;

    procedure Box(xs,ys,xd,yd,color:integer);virtual;
    procedure wuBox(xs,ys,xd,yd,color:integer);virtual; // Only in 16 bit mode
    procedure Fillbox(x1,y1,x2,y2,color:integer);virtual;

    // procedure Hline;
    // procedure LineMap
    // procedure Triangle
    // procedure Polygone
    // procedure Gouraud_Polygone;
    // procedure Texture_Polygone;
    // procedure GouraudTexture_Polygone



    // Collision routines
    function PointInCircle(xp, yp: integer; xCircle, yCircle, Radius: extended): boolean;

    // FX routines
    procedure FlipX; virtual;
    procedure FlipY; virtual;

    procedure CopperBar(y, cbHeight: integer; TopColor, MiddleColor, BottomColor: cardinal); virtual;
    Procedure Blur;virtual;
    // Procedure Fire;
    // Procedure Geiss;
    // Procedure Bump;
    // Procedure Light;
    // procedure Plasma;
    // Procedure Lens;
    // procedure StarField;
    // procedure Tourbillion;
    // Procedure Wave;
    // Procedure Flag;
    // Procedure Ripples;
    // Procedure Tunnel;
    // Procedure WormHole;
    // Procedure RotoZoom;
    // Procedure Zoom;
    // Procedure MetaBall;
    // Procedure FadeIn;
    // Procedure FadeOut;
    // Procedure CrossFade;

    procedure Noise(Oblast: TRect; Density: Byte);
    // Time savers
    property BitDepth: TBitDepth read FBitDepth;
    property Surface: TDirectDrawSurface read GetCurrentSurface write SetCurrentSurface;
 //   property PixelProc: TPixelProc write SetPixelProc; // Just testing..DO NOT USE!!!!
    property ClipRect:TRect read FClipRect write FClipRect;
    property OpResult:Integer read FOpResult;

  end;


    function Conv24to16(Color:Integer):Word;
    function Conv16to24(Color:Word):Integer;
    function Conv8to16(Color:Word):integer;
    function Conv24to32(Color:Word):integer;

implementation


Var ESurfaceDesc: TDDSurfaceDesc_DX6;

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

function Conv8to16(color:word):integer;
var col:integer;
begin
     col:=(LoByte(LoWord(color)) shr 3 shl 11) or   // Red
          (HiByte(LoWord(color)) shr 2 shl 5) or    // Green
          (LoByte(HiWord(color)) shr 3);            // Blue
  result:=col;
end;

function Conv24to32(color:word):integer;
var col:integer;
begin
     col:=(LoByte(LoWord(color)) shl 16) or   // Red
          (HiByte(LoWord(color)) shl 8) or    // Green
          (LoByte(HiWord(color)));            // Blue
  result:=col;
end;


procedure PutPixel8(x,y,color : integer);
{ on entry:  x = eax,   y = edx,   color = ecx }
asm
   push esi                              // must maintain esi

   mov esi,ESurfaceDesc.lpSurface        // set to surface
   add esi,eax                           // add x
   mov eax,[ESurfaceDesc.dwwidth]        // eax = pitch
   mul edx                               // eax = pitch * y
   add esi,eax                           // esi = pixel offset

   mov ds:[esi],cl                       // set pixel (lo byte of ecx)

   pop esi                               // restore esi
   ret                                   // return
end;

procedure PutPixel16(x,y,color : integer);register;
{ on entry:  x = eax,   y = edx,   color = ecx }
asm
   push esi

   mov esi,ESurfaceDesc.lpSurface
   shl eax,1
   add esi,eax                           // description similar to PutPixel8
   mov eax,[ESurfaceDesc.lpitch]
   mul edx
   add esi,eax


   mov ds:[esi],ecx

   pop esi
   ret
end;

procedure PutPixel24(x,y,color : integer);
{ on entry:  x = eax,   y = edx,   color = ecx }
asm
   push esi

   mov esi,ESurfaceDesc.lpSurface
   imul eax,3
   add esi,eax                           // description similar to PutPixel8
   mov eax,[ESurfaceDesc.lpitch]
   mul edx
   add esi,eax

   mov eax,ds:[esi]               // the idea is to get the current pixel
   and eax,$ff000000              // and the top 8 bits of next pixel (red component)
   or  ecx,eax                    // then bitwise OR that component to the current color
   mov ds:[esi+1],ecx             // to ensure the prior bitmap isn't incorrectly manipulated
                                  // can't test if it works... so hope and pray
   pop esi
   ret
end;

procedure PutPixel32(x,y,color : integer);
{ on entry:  x = eax,   y = edx,   color = ecx }
asm
   push esi

   mov esi,ESurfaceDesc.lpSurface
   shl eax,2
   add esi,eax                           // description similar to PutPixel8
   mov eax,[ESurfaceDesc.lpitch]
   mul edx
   add esi,eax

   mov ds:[esi],ecx

   pop esi
   ret
end;

function  GetPixel8(x,y : integer) : integer;
{ on entry:  x = eax,   y = edx }
asm
   push esi                              // myst maintain esi

   mov esi,ESurfaceDesc.lpSurface        // set to surface
   add esi,eax                           // add x
   mov eax,[ESurfaceDesc.lpitch]         // eax = pitch
   mul edx                               // eax = pitch * y
   add esi,eax                           // esi = pixel offset

   mov eax,ds:[esi]                      // eax = color
   and eax,$ff                           // map into 8bit

   pop esi                               // restore esi
   ret                                   // return
end;

function  GetPixel16(x,y : integer) : integer;
{ on entry:  x = eax,   y = edx }
asm
   push esi

   mov esi,ESurfaceDesc.lpSurface
   shl eax,1
   add esi,eax                           // description similar to GetPixel8
   mov eax,[ESurfaceDesc.lpitch]
   mul edx
   add esi,eax

   mov eax,esi
   and eax,$ffff                         // map into 16bit

   pop esi
   ret
end;

function  GetPixel24(x,y : integer) : integer;
{ on entry:  x = eax,   y = edx }
asm
   push esi

   mov esi,ESurfaceDesc.lpSurface
   imul eax,3
   add esi,ebx                           // description similar to GetPixel8
   mov eax,[ESurfaceDesc.lpitch]
   mul edx
   add esi,eax

   mov eax,ds:[esi]
   and eax,$ffffff                       // map into 24bit

   pop esi
   ret
end;

function  GetPixel32(x,y : integer) : integer;
{ on entry:  x = eax,   y = edx }
asm
   push esi

   mov esi,ESurfaceDesc.lpSurface
   shl eax,2
   add esi,eax                           // description similar to GetPixel8
   mov eax,[ESurfaceDesc.lpitch]
   mul edx
   add esi,eax

   mov eax,ds:[esi]

   pop esi
   ret
end;

procedure TGrafixSurface.Line8(x1,y1,x2,y2,color : integer);
{ no clipping is performed }
Var FSurfaceDesc: TDDSurfaceDesc_DX6;
begin
  FSurfaceDesc := SurfaceDesc;
   asm
      push ebx
      push ebp
      push edi
      push esi
      pusha
      mov esi,FSurfaceDesc.lpSurface
      mov eax,[x1]        // eax = x1
      mov ebx,[x2]        // ebx = x2
      sub ebx,eax         // ebx = x2-x1
      jns @rightOk        // if negative, then swap start/end point
      mov eax,[FSurfaceDesc.lpitch]    // width of surface
      mul [y2]            // multiply with end-point y
      add esi,eax         // add to surface start pointer
      mov ebx,[x2]        // add end-point x position
      add esi,ebx         // esi = starting position of first pixel
      mov eax,[x2]
      mov ebx,[x1]        // set initial values *}
      mov ecx,[y2]
      mov edx,[y1]        // line from (eax,ecx) to (ebx,edx) => (x2,y2) to (x1,y1) *}
      jmp @continue
      @rightOk:
      mov eax,[FSurfaceDesc.lpitch]    // width of surface
      mul [y1]            // multiply with start-point y
      add esi,eax         // add to surface start pointer
      mov ebx,[x1]        // add start-point x position
      add esi,ebx         // esi = starting position of first pixel
      mov eax,[x1]
      mov ebx,[x2]        // set initial values *}
      mov ecx,[y1]
      mov edx,[y2]        // line from (eax,ecx) to (ebx,edx) => (x1,y1) to (x2,y2) *}
      @continue:
      sub ebx,eax         // ebx = deltaX
      mov eax,[color]     // eax = color
      push ebp            // save ebp to abuse it
      mov ebp,[FSurfaceDesc.lpitch]    // ebp = pitch
      sub edx,ecx         // edx = deltaY
      js  @RightUp        // draw line right up
      cmp ebx,edx         // test gradient, below 1 or not
      jl  @RightDownSteep // line right-down-ward and steep
      mov ecx,ebx         // prepare spill-element ecx
      shr ecx,1
      neg ecx
      add ecx,edx         // ecx = -(deltaX)/2 + deltaY
      mov edi,ebx         // prepare counter edi (equal to deltaX)
      dec edi             // prevention of single dot crash
      mov ds:[esi],al     // set first pixel
      @loopRDSh:          // loop for Right Down Shallow
      or  ecx,ecx         // check spill-element
      js  @skipRDSh       // if signed skip
      sub ecx,ebx         // reset spill-element
      add esi,ebp         // calculate vertical step
      @skipRDSh:
      add ecx,edx         // increase spill-element by deltaY
      inc esi             // mov pixel onward
      mov ds:[esi],al     // set current pixel
      dec edi             // decrement counter
      jns @loopRDSh       // loop until signed
      jmp @ende           // terminate
      @RightDownSteep:
      mov ecx,edx         // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,ebx         // ecx = -(deltaY)/2 + deltaX
      mov edi,edx         // prepare counter edi (equal to deltaY)
      dec edi             // prevention of single dot crash
      mov ds:[esi],al     // set first pixel
      @loopRDSt:          // loop for Right Down Steep
      or  ecx,ecx         // check spill-element
      js  @skipRDSt       // if signed skip
      sub ecx,edx         // reset spill-element
      inc esi             // mov pixel onward
      @skipRDSt:
      add ecx,ebx         // increase spill-element by deltaX
      add esi,ebp         // calculate new pixel offset
      mov ds:[esi],al     // set current pixel
      dec edi             // decrement counter
      jns @loopRDSt       // loop until signed
      jmp @ende           // terminate
      @RightUp:
      neg edx             // reallign DX
      cmp ebx,edx         // test gradient, below 1 or not
      jl  @RightUpSteep   // line right-up-ward and steep
      mov ecx,ebx         // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,edx         // CX = -(deltaX)/2 + deltaY
      mov edi,ebx         // prepare counter edi (equal to deltaX)
      dec edi             // prevention of single dot crash
      mov ds:[esi],al     // set first pixel
      @loopRUSh:          // loop for Right Up Shallow
      or  ecx,ecx         // check spill-element
      js  @skipRUSh       // if signed skip
      sub ecx,ebx         // reset spill-element
      sub esi,ebp         // calculate vertical step
      @skipRUSh:
      add ecx,edx         // increase spill-element by deltaY
      inc esi             // next pixel
      mov ds:[esi],al     // set first pixel
      dec edi             // decrement counter
      jns @loopRUSh       // loop until signed
      jmp @ende           // terminate
      @RightUpSteep:
      mov ecx,edx           // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,ebx           // ecx = -(deltaY)/2 + deltaX
      mov edi,edx           // prepare counter edi (equal to deltaY)
      dec edi               // prevention of single dot crash
      mov ds:[esi],al       // set first pixel
      @loopRUSt:            // loop for Right Up Steep
      or  ecx,ecx           // check spill-element
      js  @skipRUSt         // if signed skip
      sub ecx,edx           // reset spill-element
      inc esi               // vertical step
      @skipRUSt:
      add ecx,ebx           // increase spill-element by deltaX
      sub esi,ebp           // calculate new pixel offset
      mov ds:[esi],al       // set current pixel
      dec edi               // decrement counter
      jns @loopRUSt         // loop until signed
      @ende:
      pop ebp
      popa
      pop esi
      pop edi
      pop ebp
      pop ebx
   end;
end;

procedure TGrafixSurface.Line16(x1,y1,x2,y2,color : integer);
{ no clipping is performed }
Var FSurfaceDesc: TDDSurfaceDesc_DX6;
begin
  FSurfaceDesc := SurfaceDesc;
  asm
      push ebx
      push ebp
      push edi
      push esi
      pusha
      mov esi,FSurfaceDesc.lpSurface
      mov eax,[x1]        // eax = x1
      mov ebx,[x2]        // ebx = x2
      sub ebx,eax         // ebx = x2-x1
      jns @rightOk        // if negative, then swap start/end point
      mov eax,[FSurfaceDesc.lpitch]    // width of surface
      mul [y2]            // multiply with end-point y
      add esi,eax         // add to surface start pointer
      mov ebx,[x2]        // add end-point x position
      shl ebx,1
      add esi,ebx         // esi = starting position of first pixel
      mov eax,[x2]
      mov ebx,[x1]        // set initial values *}
      mov ecx,[y2]
      mov edx,[y1]        // line from (eax,ecx) to (ebx,edx) => (x2,y2) to (x1,y1) *}
      jmp @continue
      @rightOk:
      mov eax,[FSurfaceDesc.lpitch]    // width of surface
      mul [y1]            // multiply with start-point y
      add esi,eax         // add to surface start pointer
      mov ebx,[x1]        // add start-point x position
      shl ebx,1
      add esi,ebx         // esi = starting position of first pixel
      mov eax,[x1]
      mov ebx,[x2]        // set initial values *}
      mov ecx,[y1]
      mov edx,[y2]        // line from (eax,ecx) to (ebx,edx) => (x1,y1) to (x2,y2) *}
      @continue:
      sub ebx,eax         // ebx = deltaX
      mov eax,[color]     // eax = color
      push ebp            // save ebp to abuse it
      mov ebp,[FSurfaceDesc.lpitch]    // ebp = pitch
      sub edx,ecx         // edx = deltaY
      js  @RightUp        // draw line right up
      cmp ebx,edx         // test gradient, below 1 or not
      jl  @RightDownSteep // line right-down-ward and steep
      mov ecx,ebx         // prepare spill-element ecx
      shr ecx,1
      neg ecx
      add ecx,edx         // ecx = -(deltaX)/2 + deltaY
      mov edi,ebx         // prepare counter edi (equal to deltaX)
      dec edi             // prevention of single dot crash
      mov ds:[esi],ax     // set first pixel
      @loopRDSh:          // loop for Right Down Shallow
      or  ecx,ecx         // check spill-element
      js  @skipRDSh       // if signed skip
      sub ecx,ebx         // reset spill-element
      add esi,ebp         // calculate vertical step
      @skipRDSh:
      add ecx,edx         // increase spill-element by deltaY
      add esi,2           // mov pixel onward
      mov ds:[esi],ax     // set current pixel
      dec edi             // decrement counter
      jns @loopRDSh       // loop until signed
      jmp @ende           // terminate
      @RightDownSteep:
      mov ecx,edx         // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,ebx         // ecx = -(deltaY)/2 + deltaX
      mov edi,edx         // prepare counter edi (equal to deltaY)
      dec edi             // prevention of single dot crash
      mov ds:[esi],ax     // set first pixel
      @loopRDSt:          // loop for Right Down Steep
      or  ecx,ecx         // check spill-element
      js  @skipRDSt       // if signed skip
      sub ecx,edx         // reset spill-element
      add esi,2           // mov pixel onward
      @skipRDSt:
      add ecx,ebx         // increase spill-element by deltaX
      add esi,ebp         // calculate new pixel offset
      mov ds:[esi],ax     // set current pixel
      dec edi             // decrement counter
      jns @loopRDSt       // loop until signed
      jmp @ende           // terminate
      @RightUp:
      neg edx             // reallign DX
      cmp ebx,edx         // test gradient, below 1 or not
      jl  @RightUpSteep   // line right-up-ward and steep
      mov ecx,ebx         // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,edx         // CX = -(deltaX)/2 + deltaY
      mov edi,ebx         // prepare counter edi (equal to deltaX)
      dec edi             // prevention of single dot crash
      mov ds:[esi],ax     // set first pixel
      @loopRUSh:          // loop for Right Up Shallow
      or  ecx,ecx         // check spill-element
      js  @skipRUSh       // if signed skip
      sub ecx,ebx         // reset spill-element
      sub esi,ebp         // calculate vertical step
      @skipRUSh:
      add ecx,edx         // increase spill-element by deltaY
      add esi,2           // next pixel
      mov ds:[esi],ax     // set first pixel
      dec edi             // decrement counter
      jns @loopRUSh       // loop until signed
      jmp @ende           // terminate
      @RightUpSteep:
      mov ecx,edx           // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,ebx           // ecx = -(deltaY)/2 + deltaX
      mov edi,edx           // prepare counter edi (equal to deltaY)
      dec edi               // prevention of single dot crash
      mov ds:[esi],ax       // set first pixel
      @loopRUSt:            // loop for Right Up Steep
      or  ecx,ecx           // check spill-element
      js  @skipRUSt         // if signed skip
      sub ecx,edx           // reset spill-element
      add esi,2             // vertical step
      @skipRUSt:
      add ecx,ebx           // increase spill-element by deltaX
      sub esi,ebp           // calculate new pixel offset
      mov ds:[esi],ax       // set current pixel
      dec edi               // decrement counter
      jns @loopRUSt         // loop until signed
      @ende:
      pop ebp
      popa
      pop esi
      pop edi
      pop ebp
      pop ebx
   end;
end;

procedure TGrafixSurface.Line24(x1,y1,x2,y2,color : integer);
{ no clipping is performed }
Var FSurfaceDesc: TDDSurfaceDesc_DX6;
begin
  FSurfaceDesc := SurfaceDesc;
   asm
      push ebx
      push ebp
      push edi
      push esi
      pusha
      mov esi,FSurfaceDesc.lpSurface
      mov eax,[x1]        // eax = x1
      mov ebx,[x2]        // ebx = x2
      sub ebx,eax         // ebx = x2-x1
      jns @rightOk        // if negative, then swap start/end point
      mov eax,[FSurfaceDesc.lpitch]    // width of surface
      mul [y2]            // multiply with end-point y
      add esi,eax         // add to surface start pointer
      mov ebx,[x2]        // add end-point x position
      imul ebx,3
      add esi,ebx         // esi = starting position of first pixel
      mov eax,[x2]
      mov ebx,[x1]        // set initial values *}
      mov ecx,[y2]
      mov edx,[y1]        // line from (eax,ecx) to (ebx,edx) => (x2,y2) to (x1,y1) *}
      jmp @continue
      @rightOk:
      mov eax,[FSurfaceDesc.lpitch]    // width of surface
      mul [y1]            // multiply with start-point y
      add esi,eax         // add to surface start pointer
      mov ebx,[x1]        // add start-point x position
      imul ebx,3
      add esi,ebx         // esi = starting position of first pixel
      mov eax,[x1]
      mov ebx,[x2]        // set initial values *}
      mov ecx,[y1]
      mov edx,[y2]        // line from (eax,ecx) to (ebx,edx) => (x1,y1) to (x2,y2) *}
      @continue:
      sub ebx,eax         // ebx = deltaX
      mov eax,[color]     // eax = color
      push ebp            // save ebp to abuse it
      mov ebp,[FSurfaceDesc.lpitch]    // ebp = pitch
      sub edx,ecx         // edx = deltaY
      js  @RightUp        // draw line right up
      cmp ebx,edx         // test gradient, below 1 or not
      jl  @RightDownSteep // line right-down-ward and steep
      mov ecx,ebx         // prepare spill-element ecx
      shr ecx,1
      neg ecx
      add ecx,edx         // ecx = -(deltaX)/2 + deltaY
      mov edi,ebx         // prepare counter edi (equal to deltaX)
      dec edi             // prevention of single dot crash
      mov ds:[esi],ax     // set first pixel
      ror eax,16
      mov ds:[esi+2],al
      @loopRDSh:          // loop for Right Down Shallow
      or  ecx,ecx         // check spill-element
      js  @skipRDSh       // if signed skip
      sub ecx,ebx         // reset spill-element
      add esi,ebp         // calculate vertical step
      @skipRDSh:
      add ecx,edx         // increase spill-element by deltaY
      add esi,3           // mov pixel onward
      mov ds:[esi],ax     // set pixel
      ror eax,16
      mov ds:[esi+2],al
      dec edi             // decrement counter
      jns @loopRDSh       // loop until signed
      jmp @ende           // terminate
      @RightDownSteep:
      mov ecx,edx         // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,ebx         // ecx = -(deltaY)/2 + deltaX
      mov edi,edx         // prepare counter edi (equal to deltaY)
      dec edi             // prevention of single dot crash
      mov ds:[esi],ax     // set pixel
      ror eax,16
      mov ds:[esi+2],al
      @loopRDSt:          // loop for Right Down Steep
      or  ecx,ecx         // check spill-element
      js  @skipRDSt       // if signed skip
      sub ecx,edx         // reset spill-element
      add esi,3           // mov pixel onward
      @skipRDSt:
      add ecx,ebx         // increase spill-element by deltaX
      add esi,ebp         // calculate new pixel offset
      mov ds:[esi],ax     // set pixel
      ror eax,16
      mov ds:[esi+2],al
      dec edi             // decrement counter
      jns @loopRDSt       // loop until signed
      jmp @ende           // terminate
      @RightUp:
      neg edx             // reallign DX
      cmp ebx,edx         // test gradient, below 1 or not
      jl  @RightUpSteep   // line right-up-ward and steep
      mov ecx,ebx         // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,edx         // CX = -(deltaX)/2 + deltaY
      mov edi,ebx         // prepare counter edi (equal to deltaX)
      dec edi             // prevention of single dot crash
      mov ds:[esi],ax     // set pixel
      ror eax,16
      mov ds:[esi+2],al
      @loopRUSh:          // loop for Right Up Shallow
      or  ecx,ecx         // check spill-element
      js  @skipRUSh       // if signed skip
      sub ecx,ebx         // reset spill-element
      sub esi,ebp         // calculate vertical step
      @skipRUSh:
      add ecx,edx         // increase spill-element by deltaY
      add esi,3           // next pixel
      mov ds:[esi],ax     // set pixel
      ror eax,16
      mov ds:[esi+2],al
      dec edi             // decrement counter
      jns @loopRUSh       // loop until signed
      jmp @ende           // terminate
      @RightUpSteep:
      mov ecx,edx           // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,ebx           // ecx = -(deltaY)/2 + deltaX
      mov edi,edx           // prepare counter edi (equal to deltaY)
      dec edi               // prevention of single dot crash
      mov ds:[esi],ax       // set pixel
      ror eax,16
      mov ds:[esi+2],al
      @loopRUSt:            // loop for Right Up Steep
      or  ecx,ecx           // check spill-element
      js  @skipRUSt         // if signed skip
      sub ecx,edx           // reset spill-element
      add esi,3             // vertical step
      @skipRUSt:
      add ecx,ebx           // increase spill-element by deltaX
      sub esi,ebp           // calculate new pixel offset
      mov ds:[esi],ax       // set pixel
      ror eax,16
      mov ds:[esi+2],al
      dec edi               // decrement counter
      jns @loopRUSt         // loop until signed
      @ende:
      pop ebp
      popa
      pop esi
      pop edi
      pop ebp
      pop ebx
   end;
end;

procedure TGrafixSurface.Line32(x1,y1,x2,y2,color : integer);
{ no clipping is performed }
Var FSurfaceDesc: TDDSurfaceDesc_DX6;
begin
  FSurfaceDesc := SurfaceDesc;
   asm
      push ebx
      push ebp
      push edi
      push esi
      pusha
      mov esi,FSurfaceDesc.lpSurface
      mov eax,[x1]        // eax = x1
      mov ebx,[x2]        // ebx = x2
      sub ebx,eax         // ebx = x2-x1
      jns @rightOk        // if negative, then swap start/end point
      mov eax,[FSurfaceDesc.lpitch]    // width of surface
      mul [y2]            // multiply with end-point y
      add esi,eax         // add to surface start pointer
      mov ebx,[x2]        // add end-point x position
      shl ebx,2
      add esi,ebx         // esi = starting position of first pixel
      mov eax,[x2]
      mov ebx,[x1]        // set initial values *}
      mov ecx,[y2]
      mov edx,[y1]        // line from (eax,ecx) to (ebx,edx) => (x2,y2) to (x1,y1) *}
      jmp @continue
      @rightOk:
      mov eax,[FSurfaceDesc.lpitch]    // width of surface
      mul [y1]            // multiply with start-point y
      add esi,eax         // add to surface start pointer
      mov ebx,[x1]        // add start-point x position
      shl ebx,2
      add esi,ebx         // esi = starting position of first pixel
      mov eax,[x1]
      mov ebx,[x2]        // set initial values *}
      mov ecx,[y1]
      mov edx,[y2]        // line from (eax,ecx) to (ebx,edx) => (x1,y1) to (x2,y2) *}
      @continue:
      sub ebx,eax         // ebx = deltaX
      mov eax,[color]     // eax = color
      push ebp            // save ebp to abuse it
      mov ebp,[FSurfaceDesc.lpitch]    // ebp = pitch
      sub edx,ecx         // edx = deltaY
      js  @RightUp        // draw line right up
      cmp ebx,edx         // test gradient, below 1 or not
      jl  @RightDownSteep // line right-down-ward and steep
      mov ecx,ebx         // prepare spill-element ecx
      shr ecx,1
      neg ecx
      add ecx,edx         // ecx = -(deltaX)/2 + deltaY
      mov edi,ebx         // prepare counter edi (equal to deltaX)
      dec edi             // prevention of single dot crash
      mov ds:[esi],eax    // set pixel
      @loopRDSh:          // loop for Right Down Shallow
      or  ecx,ecx         // check spill-element
      js  @skipRDSh       // if signed skip
      sub ecx,ebx         // reset spill-element
      add esi,ebp         // calculate vertical step
      @skipRDSh:
      add ecx,edx         // increase spill-element by deltaY
      add esi,4           // mov pixel onward
      mov ds:[esi],eax    // set pixel
      dec edi             // decrement counter
      jns @loopRDSh       // loop until signed
      jmp @ende           // terminate
      @RightDownSteep:
      mov ecx,edx         // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,ebx         // ecx = -(deltaY)/2 + deltaX
      mov edi,edx         // prepare counter edi (equal to deltaY)
      dec edi             // prevention of single dot crash
      mov ds:[esi],eax    // set pixel
      @loopRDSt:          // loop for Right Down Steep
      or  ecx,ecx         // check spill-element
      js  @skipRDSt       // if signed skip
      sub ecx,edx         // reset spill-element
      add esi,4           // mov pixel onward
      @skipRDSt:
      add ecx,ebx         // increase spill-element by deltaX
      add esi,ebp         // calculate new pixel offset
      mov ds:[esi],eax     // set pixel
      dec edi             // decrement counter
      jns @loopRDSt       // loop until signed
      jmp @ende           // terminate
      @RightUp:
      neg edx             // reallign DX
      cmp ebx,edx         // test gradient, below 1 or not
      jl  @RightUpSteep   // line right-up-ward and steep
      mov ecx,ebx         // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,edx         // CX = -(deltaX)/2 + deltaY
      mov edi,ebx         // prepare counter edi (equal to deltaX)
      dec edi             // prevention of single dot crash
      mov ds:[esi],eax    // set first pixel
      @loopRUSh:          // loop for Right Up Shallow
      or  ecx,ecx         // check spill-element
      js  @skipRUSh       // if signed skip
      sub ecx,ebx         // reset spill-element
      sub esi,ebp         // calculate vertical step
      @skipRUSh:
      add ecx,edx         // increase spill-element by deltaY
      add esi,4           // next pixel
      mov ds:[esi],eax    // set first pixel
      dec edi             // decrement counter
      jns @loopRUSh       // loop until signed
      jmp @ende           // terminate
      @RightUpSteep:
      mov ecx,edx           // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,ebx           // ecx = -(deltaY)/2 + deltaX
      mov edi,edx           // prepare counter edi (equal to deltaY)
      dec edi               // prevention of single dot crash
      mov ds:[esi],eax      // set first pixel
      @loopRUSt:            // loop for Right Up Steep
      or  ecx,ecx           // check spill-element
      js  @skipRUSt         // if signed skip
      sub ecx,edx           // reset spill-element
      add esi,4             // vertical step
      @skipRUSt:
      add ecx,ebx           // increase spill-element by deltaX
      sub esi,ebp           // calculate new pixel offset
      mov ds:[esi],eax      // set current pixel
      dec edi               // decrement counter
      jns @loopRUSt         // loop until signed
      @ende:
      pop ebp
      popa
      pop esi
      pop edi
      pop ebp
      pop ebx
   end;
end;


// ==========================================
// ==        GRAFIXSURFACE PROCS           ==
// ==========================================


constructor TGrafixSurface.Create(ADraw: TDirectDraw);
var i:integer;
begin
  inherited Create(ADraw);
 for I:=0 to 1023 do
  begin
   SinTable[I]:=Round(Sin((I*Pi)/512)*65356);
   CosTable[I]:=Round(Cos((I*Pi)/512)*65356);
  end;
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
  FSurface:=aDXDraw.Surface;
  FTransColor:=TransColor;
  FSurface.TransparentColor:=FTransColor;
  FillChar(FSurfaceDesc,SizeOf(FSurfaceDesc),0);

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
  FLockRect:=Rect(0,0,FSurface.Width,FSurface.Height);
  //FLockRect:=Rect(0,0,FSurfaceDesc.dwWidth,FSurfaceDesc.dwHeight);

  FClipRect := Bounds(0,0,Surface.Width,Surface.Height);
//  FClipRect.Left:=0;
//  FClipRect.Top:=0;
//  FClipRect.Right:=Surface.Width-1;
//  FClipRect.Bottom:=Surface.Height-1;
//

  { The following 2 lines were the cause of a really annoying/hard to track bug }
  //  FWidth:=FSurfaceDesc.dwWidth;
  //  FHeight:=FSurfaceDesc.dwHeight;
  FSurface := FDXDraw.Surface;
  //if FDXDraw.Surface.ISurface4.Lock( @FLockRect, FSurfaceDesc, DDLOCK_SURFACEMEMORYPTR+DDLOCK_WAIT, 0 )<>DD_OK then
  //if FSurface.ISurface4.Lock( @FLockRect, FSurfaceDesc, DDLOCK_SURFACEMEMORYPTR+DDLOCK_WAIT, 0 )<>DD_OK then
  if NOT FSurface.Lock(FLockRect,FSurfaceDesc) Then
    Result:=False
//  Else
//    SurfaceDesc:=FSurfaceDesc;


end;

{ UNLOCK SURFACE }
procedure TGrafixSurface.Unlock;
begin
  //FSurface.ISurface4.Unlock( @FLockRect );
  FSurface.UnLock;
  FillChar(FSurfaceDesc,SizeOf(FSurfaceDesc),0);
  //SurfaceDesc:=FSurfaceDesc;
end;


{ WRITE A PIXEL ON SURFACE }
procedure TGrafixSurface.PutPixel(x,y,color : integer);
begin
   ESurfaceDesc := SurfaceDesc;
   if (X < 0) or (X > (SurfaceDesc.dwWidth-1)) or
    (Y < 0) or (Y > (SurfaceDesc.dwHeight-1)) then Exit;
   case FBitDepth of
     bd8  :  PutPixel8(x,y,color);
     bd16 :  PutPixel16(x,y,color);
     bd24 :  PutPixel24(x,y,color);
     bd32 :  PutPixel32(x,y,color);
   end;
end;

function TGrafixSurface.GetPixel(x, y: Integer) : integer;
begin
   ESurfaceDesc := SurfaceDesc;
   result:=0;
   case FBitDepth of
     bd8  :  result:=GetPixel8(x,y);
     bd16 :  result:=GetPixel16(x,y);
     bd24 :  result:=GetPixel24(x,y);
     bd32 :  result:=GetPixel32(x,y);
   end;
end;

{ DRAW A NORMAL LINE }
procedure TGrafixSurface.Line(x1,y1,x2,y2,color : integer);
begin
   case FBitDepth of
     bd8  :  Line8(x1,y1,x2,y2,color);
     bd16 :  Line16(x1,y1,x2,y2,color);
     bd24 :  Line24(x1,y1,x2,y2,color);
     bd32 :  Line32(x1,y1,x2,y2,color);
   end;
end;

procedure TGrafixSurface.VLine(x,y1,y2: integer; Color: cardinal);
var
  y:integer;
  NColor: cardinal;
  r,g,b: byte;
begin
  if y1<0 then y1:=0;
  if y2>=FHeight then y2:=FHeight-1;

//  for y:=y1 to y2 do  VoxSurface.PutPixel( x,y,rgb(Pal[c].peRed,Pal[c].peGreen,Pal[c].peBlue));
  // The following is 2x faster than the above line of code
  GetRGB(Color, r,g,b);
  NColor:=RGBToBGR(rgb(r,g,b));
  for y:=y1 to y2 do
  begin
    putpixel(x,y,Ncolor);
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

//procedure TGrafixSurface.SetPixelProc(NewPixelProc: Pointer);
//begin
////  FPixelProc:=NewPixelProc;
//end;

procedure TGrafixSurface.AddPixel(X,Y,Color:Integer);
Var Offs:Integer;
begin
 Offs:=integer(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*Y+(X shl 1);
 asm
  push edx
  push ebx
  push esi
  push edi

  mov esi, Offs
  xor edx, edx
  mov dx, [esi]
  mov edi, Color
  and edi, 0FFFFh
  xor ecx, ecx
  mov eax, edx
  mov ebx, edi
  and eax, 01Fh
  and ebx, 01Fh
  add eax, ebx
  cmp eax, 01Fh
  jbe @Skip1
  mov eax, 01Fh
 @Skip1:
  mov ecx,eax

  mov eax, edx
  mov ebx, edi
  shr eax, 5
  shr ebx, 5
  and eax, 03Fh
  and ebx, 03Fh
  add eax, ebx
  cmp eax, 03Fh
  jbe @Skip2
  mov eax, 03Fh
 @Skip2:
  shl eax, 5
  add ecx, eax

  mov eax, edx
  mov ebx, edi
  shr eax, 11
  shr ebx, 11
  and eax, 01Fh
  and ebx, 01Fh
  add eax,ebx
  cmp eax, 01Fh
  jbe @Skip3
  mov eax, 01Fh
 @Skip3:
  shl eax, 11
  add ecx,eax

  mov [esi],cx

  pop edi
  pop esi
  pop ebx
  pop edx
 end;
end;

procedure TGrafixSurface.BlendPixel(X,Y,Color:Integer;Transparency:Integer);
Var Offs,Trans:Integer;
begin
 Offs:=integer(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*Y+(X shl 1);
 Trans:=$3F-(Transparency shr 2);
 asm
  push edx
  push ebx
  push esi
  push edi

  mov esi, Offs
  xor edx, edx
  mov dx, [esi]
  mov edi, Color
  and edi, 0FFFFh

  xor ecx, ecx

  // BLENDING RED VALUE

  mov eax, edi
  and eax, 01Fh
  mov ebx, 03Fh
  sub ebx, Trans
  mul ebx
  shr eax,6
  mov ebx,eax

  mov eax, edx
  and eax, 01Fh
  mul Trans
  shr eax,6
  add eax, ebx

  mov ecx,eax

  // BLENDING GREEN VALUE

  mov eax, edi
  shr eax, 5
  and eax, 03Fh
  mov ebx, 03Fh
  sub ebx, Trans
  mul ebx
  shr eax,6
  mov ebx,eax

  mov eax, edx
  shr eax, 5
  and eax, 03Fh
  mul Trans
  shr eax,6
  add eax, ebx
  shl eax, 5

  add ecx,eax

  // BLENDING BLUE VALUE

  mov eax, edi
  shr eax, 11
  and eax, 01Fh
  mov ebx, 03Fh
  sub ebx, Trans
  mul ebx
  shr eax,6
  mov ebx,eax

  mov eax, edx
  shr eax, 11
  and eax, 01Fh
  mul Trans
  shr eax,6
  add eax, ebx
  shl eax, 11

  add ecx,eax

  // WRITING RESULT COLOR

  mov [esi],cx

  pop edi
  pop esi
  pop ebx
  pop edx
 end;
end;

procedure TGrafixSurface.BlendPixel16(X,Y:Integer;Color:Word;Transparency:Integer);
Var Offs,Mul1,Mul2:Integer;
begin
 Offs:=Integer(FSurfaceDesc.lpSurface)+FSurfaceDesc.lpitch*Y+(X shl 1);
 Mul1:=(Transparency shr 2) and $3F;
 Mul2:=$3F-Mul2;
 asm
  push edx
  push ebx
  push esi
  push edi

  mov esi, Offs
  xor edx, edx
  mov dx, [esi]
  xor eax,eax
  mov ax, Color
  mov edi, eax

  and ax,001Fh
  imul Mul1
  shr ax,6
  mov bx,dx
  and bx,001Fh
  xchg ax,bx
  imul Mul2
  shr ax,6
  add ax,bx
  mov cx,ax

  mov eax,edi
  shr ax,5
  and ax,003Fh
  imul Mul1
  shr ax,6
  mov bx,dx
  shr bx,5
  and bx,003Fh
  xchg ax,bx
  imul Mul2
  shr ax,6
  add ax,bx
  or cx,ax

  mov eax,edi
  shr ax,11
  and ax,001Fh
  imul Mul1
  shr ax,6
  mov bx,dx
  shr bx,11
  and bx,001Fh
  xchg ax,bx
  imul Mul2
  shr ax,6
  add ax,bx
  or cx,ax

  mov [esi],cx

  pop edi
  pop esi
  pop ebx
  pop edx
 end;
end;

procedure TGrafixSurface.WuLine(X1,Y1,X2,Y2,Color:Integer);
var DeltaX,DeltaY,Loop,Start,Finish:Integer;
    Dx,Dy,DyDx:Single; // fractional parts
    Color16:Word;
begin
 DeltaX:=Abs(X2-X1); // Calculate DeltaX and DeltaY for initialization
 DeltaY:=Abs(Y2-Y1);
 if (DeltaX=0)or(DeltaY=0) then
  begin // straight lines
   Line(X1,Y1,X2,Y2,Color);
   Exit;
  end;
 Color16:=Conv24to16(Color);
 if DeltaX>DeltaY then // horizontal or vertical
  begin
  { determine rise and run }
   if Y2>Y1 then DyDx:=-(DeltaY/DeltaX)
    else DyDx:=DeltaY/DeltaX;
   if X2<X1 then
    begin
     Start:=X2; // right to left
     Finish:=X1;
     Dy:=Y2;
    end else
    begin
     Start:=X1; // left to right
     Finish:=X2;
     Dy:=Y1;
     DyDx:=-DyDx; // inverse slope
    end;
   for Loop:=Start to Finish do
    begin
     BlendPixel16(Loop,Trunc(Dy),Color16,Trunc((1-Frac(Dy))*255));
     BlendPixel16(Loop,Trunc(Dy)+1,Color16,Trunc(Frac(Dy)*255));
     Dy:=Dy+DyDx; // next point
    end;
  end else
  begin
   { determine rise and run }
   if X2>X1 then DyDx:=-(DeltaX/DeltaY)
    else DyDx:=DeltaX/DeltaY;
   if Y2<Y1 then
    begin
     Start:=Y2; // right to left
     Finish:=Y1;
     Dx:=X2;
    end else
    begin
     Start:=Y1; // left to right
     Finish:=Y2;
     Dx:=X1;
     DyDx:=-DyDx; // inverse slope
    end;
   for Loop:=Start to Finish do
    begin
     BlendPixel16(Trunc(Dx),Loop,Color16,Trunc((1-Frac(Dx))*255));
     BlendPixel16(Trunc(Dx),Loop,Color16,Trunc(Frac(Dx)*255));
     Dx:=Dx+DyDx; // next point
    end;
  end;
end;

procedure TGrafixSurface.DrawAdd(Image:TPictureCollectionItem;Xpos,Ypos,Pattern:Integer);
Var StartX,StartY,LengthX,LengthY:Integer;
    SrcOfs,SrcAdd,DstOfs,DstAdd,WorkX,WorkY:Integer;
    SrcLockRect:TRect;
    Surface:TDirectDrawSurface;
    Trans:Word;
    _ebx,_esi,_edi,_esp:Integer;
  TheSurfaceDesc:TDDSurfaceDesc_DX6;
begin
 Surface:=Image.PatternSurfaces[Pattern];
 if Surface=nil then
  begin
   FOpResult:=pgPatternOut;
   Exit;
  end;
 if Surface.SurfaceDesc.ddpfPixelFormat.dwRGBBitCount<>16 then
  begin
   FOpResult:=pgInvalidBitCount;
   Exit;
  end;
 StartX:=Image.PatternRects[Pattern].Left;
 StartY:=Image.PatternRects[Pattern].Top;
 LengthX:=Image.PatternRects[Pattern].Right-StartX;
 LengthY:=Image.PatternRects[Pattern].Bottom-StartY;

 if Xpos<ClipRect.Left then
  begin
   StartX:=StartX+(ClipRect.Left-Xpos);
   LengthX:=LengthX-(ClipRect.Left-Xpos);
   Xpos:=ClipRect.Left;
   if LengthX<1 then Exit;
  end;
 if Ypos<ClipRect.Top then
  begin
   StartY:=StartY+(ClipRect.Top-Ypos);
   LengthY:=LengthY-(ClipRect.Top-Ypos);
   Ypos:=ClipRect.Top;
   if LengthY<1 then Exit;
  end;
 if Xpos+LengthX>ClipRect.Right-1 then
  begin
   LengthX:=ClipRect.Right-Xpos-1;
   if LengthX<1 then Exit;
  end;
 if Ypos+LengthY>ClipRect.Bottom-1 then
  begin
   LengthY:=ClipRect.Bottom-Ypos-1;
   if LengthY<1 then Exit;
  end;

 Trans:=Conv24to16(Image.TransparentColor);

 SrcLockRect:=Rect(0,0,Surface.SurfaceDesc.dwWidth,Surface.SurfaceDesc.dwHeight);

 //if Surface.ISurface4.Lock(@SrcLockRect,Surface.SurfaceDesc,DDLOCK_SURFACEMEMORYPTR+DDLOCK_WAIT,0)<>DD_OK then Exit;

 If NOT Surface.Lock(SrcLockRect, TheSurfaceDesc) Then Exit;
 SrcOfs:=Integer({Surface.SurfaceDesc}TheSurfaceDesc.lpSurface)+({Surface.SurfaceDesc}TheSurfaceDesc.lPitch*StartY)+(StartX shl 1);
 SrcAdd:={Surface.SurfaceDesc}TheSurfaceDesc.lPitch-(LengthX shl 1);

 DstOfs:=Integer(FSurfaceDesc.lpSurface)+(FSurfaceDesc.lPitch*Ypos)+(Xpos shl 1);
 DstAdd:=FSurfacedesc.lPitch-(LengthX shl 1);

 WorkY:=LengthY;
 asm
  mov _ebx, ebx
  mov _esi, esi
  mov _edi, edi
  mov _esp, esp

  mov esi, SrcOfs       // ESI - Source Offset
  mov edi, DstOfs       // EDI - Destination Offset

  xor eax, eax          // clearing all registers
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx

 @LoopY:

  mov eax, LengthX
  mov WorkX, eax        // WorkX := LengthX
 @LoopX:
  mov ax, [esi]
  cmp ax, Trans
  je @SkipColor         // if transparent color - skip everything

  mov esp, eax          // ESP - source color
  mov bx, [edi]
  mov dx, bx            // EDX - destination color

  and ax, 001Fh         // Adding RED
  and bx, 001Fh
  add ax, bx

  cmp ax, 001Fh
  jb @Skip1
  mov ax, 001Fh
 @Skip1:
  mov cx, ax

  mov eax, esp          // Adding GREEN
  mov bx, dx
  shr ax, 5
  shr bx, 5
  and ax, 003Fh
  and bx, 003Fh
  add ax,bx

  cmp ax, 003Fh
  jb @Skip2
  mov ax, 003Fh
 @Skip2:
  shl ax,5
  or cx, ax

  mov eax, esp          // Adding BLUE
  mov bx, dx
  shr ax, 11
  shr bx, 11
  and ax, 001Fh
  and bx, 001Fh
  add ax,bx

  cmp ax, 001Fh
  jb @Skip3
  mov ax, 001Fh
 @Skip3:
  shl ax,11
  or cx, ax

  mov [edi],cx

 @SkipColor:
  add esi,2
  add edi,2

  dec WorkX
  jnz @LoopX

  add esi,SrcAdd
  add edi,DstAdd

  dec WorkY
  jnz @LoopY

  mov esp,_esp
  mov edi,_edi
  mov esi,_esi
  mov ebx,_ebx
 end;
 Surface.UnLock;
 //Surface.ISurface4.Unlock(@SrcLockRect);
 FOpResult:= pgOk;
end;

procedure TGrafixSurface.DrawAddBlend(Image:TPictureCollectionItem;Xpos,Ypos,Pattern,Opacity:Integer);
Var StartX,StartY,LengthX,LengthY:Integer;
    SrcOfs,SrcAdd,DstOfs,DstAdd,WorkX,WorkY:Integer;
    SrcLockRect:TRect;
    Surface:TDirectDrawSurface;
    Trans:Word;
    Multiply:Byte;
    _ebx,_esi,_edi,_esp:Integer;
  TheSurfaceDesc: TDDSurfaceDesc_DX6;
begin
 Surface:=Image.PatternSurfaces[Pattern];
 if Surface=nil then
  begin
   FOpResult:=pgPatternOut;
   Exit;
  end;
 if Surface.SurfaceDesc.ddpfPixelFormat.dwRGBBitCount<>16 then
  begin
   FOpResult:=pgInvalidBitCount;
   Exit;
  end;
 StartX:=Image.PatternRects[Pattern].Left;
 StartY:=Image.PatternRects[Pattern].Top;
 LengthX:=Image.PatternRects[Pattern].Right-StartX;
 LengthY:=Image.PatternRects[Pattern].Bottom-StartY;

 if Xpos<ClipRect.Left then
  begin
   StartX:=StartX+(ClipRect.Left-Xpos);
   LengthX:=LengthX-(ClipRect.Left-Xpos);
   Xpos:=ClipRect.Left;
   if LengthX<1 then Exit;
  end;
 if Ypos<ClipRect.Top then
  begin
   StartY:=StartY+(ClipRect.Top-Ypos);
   LengthY:=LengthY-(ClipRect.Top-Ypos);
   Ypos:=ClipRect.Top;
   if LengthY<1 then Exit;
  end;
 if Xpos+LengthX>ClipRect.Right-1 then
  begin
   LengthX:=ClipRect.Right-Xpos-1;
   if LengthX<1 then Exit;
  end;
 if Ypos+LengthY>ClipRect.Bottom-1 then
  begin
   LengthY:=ClipRect.Bottom-Ypos-1;
   if LengthY<1 then Exit;
  end;

 Trans:=Conv24to16(Image.TransparentColor);
 Multiply:=(Opacity shr 2) and $FF;

 SrcLockRect:=Rect(0,0,Surface.SurfaceDesc.dwWidth,Surface.SurfaceDesc.dwHeight);

 //if Surface.ISurface4.Lock(@SrcLockRect,Surface.SurfaceDesc,DDLOCK_SURFACEMEMORYPTR+DDLOCK_WAIT,0)<>DD_OK then Exit;
 if NOT Surface.Lock(SrcLockRect, TheSurfaceDesc) then Exit;

 SrcOfs:=Integer({Surface.SurfaceDesc}TheSurfaceDesc.lpSurface)+({Surface.SurfaceDesc}TheSurfaceDesc.lPitch*StartY)+(StartX shl 1);
 SrcAdd:={Surface.SurfaceDesc}TheSurfaceDesc.lPitch-(LengthX shl 1);

 DstOfs:=Integer(FSurfaceDesc.lpSurface)+(FSurfaceDesc.lPitch*Ypos)+(Xpos shl 1);
 DstAdd:=FSurfacedesc.lPitch-(LengthX shl 1);

 WorkY:=LengthY;
 asm
  mov _ebx, ebx
  mov _esi, esi
  mov _edi, edi
  mov _esp, esp

  mov esi, SrcOfs       // ESI - Source Offset
  mov edi, DstOfs       // EDI - Destination Offset

  xor eax, eax          // clearing all registers
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx

 @LoopY:

  mov eax, LengthX
  mov WorkX, eax        // WorkX := LengthX
 @LoopX:
  mov ax, [esi]
  cmp ax, Trans
  je @SkipColor         // if transparent color - skip everything

  mov esp, eax          // ESP - source color
  mov bx, [edi]
  mov dx, bx            // EDX - destination color

  and ax, 001Fh         // Adding RED
  imul Multiply
  shr ax, 6
  and bx, 001Fh
  add ax, bx

  cmp ax, 001Fh
  jb @Skip1
  mov ax, 001Fh
 @Skip1:
  mov cx, ax

  mov eax, esp          // Adding GREEN
  mov bx, dx
  shr ax, 5
  shr bx, 5
  and ax, 003Fh
  imul Multiply
  shr ax, 6
  and bx, 003Fh
  add ax,bx

  cmp ax, 003Fh
  jb @Skip2
  mov ax, 003Fh
 @Skip2:
  shl ax,5
  or cx, ax

  mov eax, esp          // Adding BLUE
  mov bx, dx
  shr ax, 11
  shr bx, 11
  and ax, 001Fh
  imul Multiply
  shr ax, 6
  and bx, 001Fh
  add ax,bx

  cmp ax, 001Fh
  jb @Skip3
  mov ax, 001Fh
 @Skip3:
  shl ax,11
  or cx, ax

  mov [edi],cx

 @SkipColor:
  add esi,2
  add edi,2

  dec WorkX
  jnz @LoopX

  add esi,SrcAdd
  add edi,DstAdd

  dec WorkY
  jnz @LoopY

  mov esp,_esp
  mov edi,_edi
  mov esi,_esi
  mov ebx,_ebx
 end;
 Surface.UnLock;
 //Surface.ISurface4.Unlock(@SrcLockRect);
 FOpResult:= pgOk;
end;

procedure TGrafixSurface.DrawHalfBlend(Image:TPictureCollectionItem;Xpos,Ypos,Pattern:Integer);
Var StartX,StartY,LengthX,LengthY:Integer;
    SrcOfs,SrcAdd,DstOfs,DstAdd,WorkX,WorkY:Integer;
    SrcLockRect:TRect;
    Surface:TDirectDrawSurface;
    Trans:Word;
    _ebx,_esi,_edi,_esp:Integer;
  TheSurfaceDesc: TDDSurfaceDesc_DX6;
begin
 Surface:=Image.PatternSurfaces[Pattern];
 if Surface=nil then
  begin
   FOpResult:=pgPatternOut;
   Exit;
  end;
 if Surface.SurfaceDesc.ddpfPixelFormat.dwRGBBitCount<>16 then
  begin
   FOpResult:=pgInvalidBitCount;
   Exit;
  end;
 StartX:=Image.PatternRects[Pattern].Left;
 StartY:=Image.PatternRects[Pattern].Top;
 LengthX:=Image.PatternRects[Pattern].Right-StartX;
 LengthY:=Image.PatternRects[Pattern].Bottom-StartY;

 if Xpos<ClipRect.Left then
  begin
   StartX:=StartX+(ClipRect.Left-Xpos);
   LengthX:=LengthX-(ClipRect.Left-Xpos);
   Xpos:=ClipRect.Left;
   if LengthX<1 then Exit;
  end;
 if Ypos<ClipRect.Top then
  begin
   StartY:=StartY+(ClipRect.Top-Ypos);
   LengthY:=LengthY-(ClipRect.Top-Ypos);
   Ypos:=ClipRect.Top;
   if LengthY<1 then Exit;
  end;
 if Xpos+LengthX>ClipRect.Right-1 then
  begin
   LengthX:=ClipRect.Right-Xpos-1;
   if LengthX<1 then Exit;
  end;
 if Ypos+LengthY>ClipRect.Bottom-1 then
  begin
   LengthY:=ClipRect.Bottom-Ypos-1;
   if LengthY<1 then Exit;
  end;

 Trans:=Conv24to16(Image.TransparentColor);

 SrcLockRect:=Rect(0,0,Surface.SurfaceDesc.dwWidth,Surface.SurfaceDesc.dwHeight);

 //if Surface.ISurface4.Lock(@SrcLockRect,Surface.SurfaceDesc,DDLOCK_SURFACEMEMORYPTR+DDLOCK_WAIT,0)<>DD_OK then Exit;

 if NOT Surface.Lock(SrcLockRect, TheSurfaceDesc) Then Exit;
 SrcOfs:=Integer({Surface.SurfaceDesc}TheSurfaceDesc.lpSurface)+({Surface.SurfaceDesc}TheSurfaceDesc.lPitch*StartY)+(StartX shl 1);
 SrcAdd:={Surface.SurfaceDesc}TheSurfaceDesc.lPitch-(LengthX shl 1);

 DstOfs:=Integer(FSurfaceDesc.lpSurface)+(FSurfaceDesc.lPitch*Ypos)+(Xpos shl 1);
 DstAdd:=FSurfacedesc.lPitch-(LengthX shl 1);

 WorkY:=LengthY;
 asm
  mov _ebx, ebx
  mov _esi, esi
  mov _edi, edi
  mov _esp, esp

  mov esi, SrcOfs       // ESI - Source Offset
  mov edi, DstOfs       // EDI - Destination Offset

  xor eax, eax          // clearing all registers
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx

 @LoopY:

  mov eax, LengthX
  mov WorkX, eax        // WorkX := LengthX
 @LoopX:
  mov ax, [esi]
  cmp ax, Trans
  je @SkipColor         // if transparent color - skip everything

  mov esp, eax          // ESP - source color
  mov bx, [edi]
  mov dx, bx            // EDX - destination color

  and ax, 001Fh         // Adding RED
  and bx, 001Fh
  shr ax,1
  shr bx,1
  add ax, bx
  mov cx, ax

  mov eax, esp          // Adding GREEN
  mov bx, dx
  shr ax, 5
  shr bx, 5
  and ax, 003Fh
  and bx, 003Fh
  shr ax,1
  shr bx,1
  add ax,bx
  shl ax,5
  or cx, ax

  mov eax, esp          // Adding BLUE
  mov bx, dx
  shr ax, 11
  shr bx, 11
  and ax, 001Fh
  and bx, 001Fh
  shr ax,1
  shr bx,1
  add ax,bx
  shl ax,11
  or cx, ax

  mov [edi],cx

 @SkipColor:
  add esi,2
  add edi,2

  dec WorkX
  jnz @LoopX

  add esi,SrcAdd
  add edi,DstAdd

  dec WorkY
  jnz @LoopY

  mov esp,_esp
  mov edi,_edi
  mov esi,_esi
  mov ebx,_ebx
 end;
 Surface.UnLock;
 //Surface.ISurface4.Unlock(@SrcLockRect);
 FOpResult:= pgOk;
end;

procedure TGrafixSurface.DrawBlend(Image:TPictureCollectionItem;Xpos,Ypos,Pattern,Opacity:Integer);
Var StartX,StartY,LengthX,LengthY:Integer;
    SrcOfs,SrcAdd,DstOfs,DstAdd,WorkX,WorkY:Integer;
    SrcLockRect:TRect;
    Surface:TDirectDrawSurface;
    Trans:Word;
    _ebx,_esi,_edi,_esp:Integer;
    Mul1,Mul2:Byte;
  TheSurfaceDesc: TDDSurfaceDesc_DX6;
begin
 Surface:=Image.PatternSurfaces[Pattern];
 if Surface=nil then
  begin
   FOpResult:=pgPatternOut;
   Exit;
  end;
 if Surface.SurfaceDesc.ddpfPixelFormat.dwRGBBitCount<>16 then
  begin
   FOpResult:=pgInvalidBitCount;
   Exit;
  end;
 StartX:=Image.PatternRects[Pattern].Left;
 StartY:=Image.PatternRects[Pattern].Top;
 LengthX:=Image.PatternRects[Pattern].Right-StartX;
 LengthY:=Image.PatternRects[Pattern].Bottom-StartY;

 if Xpos<ClipRect.Left then
  begin
   StartX:=StartX+(ClipRect.Left-Xpos);
   LengthX:=LengthX-(ClipRect.Left-Xpos);
   Xpos:=ClipRect.Left;
   if LengthX<1 then Exit;
  end;
 if Ypos<ClipRect.Top then
  begin
   StartY:=StartY+(ClipRect.Top-Ypos);
   LengthY:=LengthY-(ClipRect.Top-Ypos);
   Ypos:=ClipRect.Top;
   if LengthY<1 then Exit;
  end;
 if Xpos+LengthX>ClipRect.Right-1 then
  begin
   LengthX:=ClipRect.Right-Xpos-1;
   if LengthX<1 then Exit;
  end;
 if Ypos+LengthY>ClipRect.Bottom-1 then
  begin
   LengthY:=ClipRect.Bottom-Ypos-1;
   if LengthY<1 then Exit;
  end;

 Trans:=Conv24to16(Image.TransparentColor);
 Mul1:=(Opacity shr 2) and $3F;
 Mul2:=$3F-Mul1;

 SrcLockRect:=Rect(0,0,Surface.SurfaceDesc.dwWidth,Surface.SurfaceDesc.dwHeight);

 //if Surface.ISurface4.Lock(@SrcLockRect,Surface.SurfaceDesc,DDLOCK_SURFACEMEMORYPTR+DDLOCK_WAIT,0)<>DD_OK then Exit;
 if NOT Surface.Lock(SrcLockRect, TheSurfaceDesc) Then Exit;

 SrcOfs:=Integer({Surface.SurfaceDesc}TheSurfaceDesc.lpSurface)+({Surface.SurfaceDesc}TheSurfaceDesc.lPitch*StartY)+(StartX shl 1);
 SrcAdd:={Surface.SurfaceDesc}TheSurfaceDesc.lPitch-(LengthX shl 1);

 DstOfs:=Integer(FSurfaceDesc.lpSurface)+(FSurfaceDesc.lPitch*Ypos)+(Xpos shl 1);
 DstAdd:=FSurfacedesc.lPitch-(LengthX shl 1);

 WorkY:=LengthY;
 asm
  mov _ebx, ebx
  mov _esi, esi
  mov _edi, edi
  mov _esp, esp

  mov esi, SrcOfs       // ESI - Source Offset
  mov edi, DstOfs       // EDI - Destination Offset

  xor eax, eax          // clearing all registers
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx

 @LoopY:

  mov eax, LengthX
  mov WorkX, eax        // WorkX := LengthX
 @LoopX:
  mov ax, [esi]
  cmp ax, Trans
  je @SkipColor         // if transparent color - skip everything

  mov esp, eax          // ESP - source color
  mov bx, [edi]
  mov dx, bx            // EDX - destination color

  and ax, 001Fh         // Adding RED
  and bx, 001Fh
  mul Mul1
  xchg ax,bx
  mul Mul2
  shr ax,6
  shr bx,6
  add ax, bx
  mov cx, ax

  mov eax, esp          // Adding GREEN
  mov bx, dx
  shr ax, 5
  shr bx, 5
  and ax, 003Fh
  and bx, 003Fh
  mul Mul1
  xchg ax,bx
  mul Mul2
  shr ax,6
  shr bx,6
  add ax,bx
  shl ax,5
  or cx, ax

  mov eax, esp          // Adding BLUE
  mov bx, dx
  shr ax, 11
  shr bx, 11
  and ax, 001Fh
  and bx, 001Fh
  mul Mul1
  xchg ax,bx
  mul Mul2
  shr ax,6
  shr bx,6
  add ax,bx
  shl ax,11
  or cx, ax

  mov [edi],cx

 @SkipColor:
  add esi,2
  add edi,2

  dec WorkX
  jnz @LoopX

  add esi,SrcAdd
  add edi,DstAdd

  dec WorkY
  jnz @LoopY

  mov esp,_esp
  mov edi,_edi
  mov esi,_esi
  mov ebx,_ebx
 end;
 Surface.UnLock;
 //Surface.ISurface4.Unlock(@SrcLockRect);
 FOpResult:= pgOk;
end;

procedure TGrafixSurface.DrawRotate(Image:TPictureCollectionItem;Xpos,Ypos,Pattern,Angle:Integer);
Const Sqrt3=1.732050808;
Var HiLength,ImgX,ImgY,ImgW,ImgH:Integer;
    SrcOfs,SrcBWidth,DstOfs,DstAdd,J,I,SinVal,CosVal,xDiff,yDiff:Integer;
    SrcX,SrcY,StartX,StartY,SrcWidth,SrcHeight,DestWidth,DestHeight:Integer;
    Xfloat,Yfloat,Xint,Yint,Xadd,Yadd,Xfrac,Yfrac,CenterX,CenterY:Integer;
    SrcLockRect:TRect;
    Surface:TDirectDrawSurface;
    Trans:Word;
    _esp:Integer;
  TheSurfaceDesc: TDDSurfaceDesc_DX6;
begin
 Surface:=Image.PatternSurfaces[Pattern];
 if Surface=nil then
  begin
   FOpResult:=pgPatternOut;
   Exit;
  end;
 if Surface.SurfaceDesc.ddpfPixelFormat.dwRGBBitCount<>16 then
  begin
   FOpResult:=pgInvalidBitCount;
   Exit;
  end;
 { getting source rectangle }
 SrcX:=Image.PatternRects[Pattern].Left;
 SrcY:=Image.PatternRects[Pattern].Top;
 SrcWidth:=Image.PatternRects[Pattern].Right-SrcX;
 SrcHeight:=Image.PatternRects[Pattern].Bottom-SrcY;
 CenterX:=SrcWidth shr 1;
 CenterY:=SrcHeight shr 1;
 { calculating destination area size }
 HiLength:=SrcWidth;
 if SrcHeight>HiLength then HiLength:=SrcHeight;
 HiLength:=HiLength+Round((Sqrt3*HiLength)/4);
 { destination width & height }
 DestWidth:=HiLength;
 DestHeight:=HiLength;
 { centering rotating image inside destination }
 xDiff:=DestWidth shr 1;
 yDiff:=DestHeight shr 1;
 { centering destination image }
 Xpos:=Xpos-(DestWidth shr 1);
 Ypos:=Ypos-(DestHeight shr 1);
 { starting offsets in source image }
 StartX:=0;StartY:=0;
 { performing clipping }
 if Xpos<ClipRect.Left then
  begin
   StartX:=StartX+(ClipRect.Left-Xpos);
   DestWidth:=DestWidth-(ClipRect.Left-Xpos);
   Xpos:=ClipRect.Left;
   if DestWidth<1 then Exit;
  end;
 if Ypos<ClipRect.Top then
  begin
   StartY:=StartY+(ClipRect.Top-Ypos);
   DestHeight:=DestHeight-(ClipRect.Top-Ypos);
   Ypos:=ClipRect.Top;
   if DestHeight<1 then Exit;
  end;
 if Xpos+DestWidth>ClipRect.Right-1 then
  begin
   DestWidth:=ClipRect.Right-Xpos-1;
   if DestWidth<1 then Exit;
  end;
 if Ypos+DestHeight>ClipRect.Bottom-1 then
  begin
   DestHeight:=ClipRect.Bottom-Ypos-1;
   if DestHeight<1 then Exit;
  end;

 Trans:=Conv24to16(Image.TransparentColor);

 SrcLockRect:=Rect(0,0,Surface.SurfaceDesc.dwWidth,Surface.SurfaceDesc.dwHeight);

 //if Surface.ISurface4.Lock(@SrcLockRect,Surface.SurfaceDesc,DDLOCK_SURFACEMEMORYPTR+DDLOCK_WAIT,0)<>DD_OK then Exit;
 if NOT Surface.Lock(SrcLockRect, TheSurfaceDesc) Then Exit;
 SrcOfs:=Integer({Surface.SurfaceDesc}TheSurfaceDesc.lpSurface)+({Surface.SurfaceDesc}TheSurfaceDesc.lPitch*SrcY)+(SrcX shl 1);
 SrcBWidth:={Surface.SurfaceDesc}TheSurfaceDesc.lPitch;

 DstOfs:=Integer(FSurfaceDesc.lpSurface)+(FSurfaceDesc.lPitch*Ypos)+(Xpos shl 1);
 DstAdd:=FSurfacedesc.lPitch-(DestWidth shl 1);

 SinVal:=SinTable[Angle and $3FF];
 CosVal:=CosTable[Angle and $3FF];
 Xadd:=(CenterX shl 16)-(SinVal*(StartY-yDiff))+(CosVal*(StartX-xDiff));
 Yadd:=(CenterY shl 16)+(CosVal*(StartY-yDiff))+(SinVal*(StartX-xDiff));

 for J:=0 to DestHeight-1 do
  begin
   Xfloat:=Xadd-(SinVal*J);
   Yfloat:=Yadd+(CosVal*J);
   for I:=0 to DestWidth-1 do
    begin
     Xint:=SmallInt(Xfloat shr 16);
     Yint:=SmallInt(Yfloat shr 16);
     if (Xint>=0)and(Yint>=0)and(Xint<SrcWidth-1)and(Yint<SrcHeight-1) then
      begin
       Xfrac:=Xfloat and $FFFF;
       Yfrac:=Yfloat and $FFFF;
       asm
        push ebx
        push esi
        push edi
        mov _esp, esp

        mov esi, SrcOfs
        mov eax, Yint
        mov ebx, SrcBWidth
        imul eax, ebx
        add esi, eax
        mov eax, Xint
        shl eax, 1
        add esi, eax
        mov edi, esi
        add edi, SrcBWidth
        { ESI - Top pixel, EDI - Bottom pixel }

        xor eax, eax
        xor ebx, ebx
        xor ecx, ecx
        xor edx, edx
        { BLUE }
        mov bx, [esi]
        and bx, 001Fh
        mov edx, ebx
        mov ax, [esi+2]
        and ax, 001Fh
        sub eax, ebx
        mov ebx, Xfrac
        imul eax, ebx
        sar eax, 16
        add eax, edx

        mov ecx,eax

        mov bx, [edi]
        and bx, 001Fh
        mov edx, ebx
        mov ax, [edi+2]
        and ax, 001Fh
        sub eax, ebx
        mov ebx, Xfrac
        imul eax, ebx
        sar eax, 16
        add eax, edx

        sub eax, ecx
        mov ebx, Yfrac
        imul eax, ebx
        sar eax, 16
        add eax, ecx
        mov esp, eax

        { GREEN }
        mov bx, [esi]
        shr bx, 5
        and bx, 003Fh
        mov edx, ebx
        mov ax, [esi+2]
        shr ax, 5
        and ax, 003Fh
        sub eax, ebx
        mov ebx, Xfrac
        imul eax, ebx
        sar eax, 16
        add eax, edx

        mov ecx, eax

        mov bx, [edi]
        shr bx, 5
        and bx, 003Fh
        mov edx, ebx
        mov ax, [edi+2]
        shr ax, 5
        and ax, 003Fh
        sub eax, ebx
        mov ebx, Xfrac
        imul eax, ebx
        sar eax, 16
        add eax, edx

        sub eax, ecx
        mov ebx, Yfrac
        imul eax, ebx
        sar eax, 16
        add eax, ecx
        shl eax, 5
        or esp, eax

        { RED }
        mov bx, [esi]
        shr bx, 11
        and bx, 001Fh
        mov edx, ebx
        mov ax, [esi+2]
        shr ax, 11
        and ax, 001Fh
        sub eax, ebx
        mov ebx, Xfrac
        imul eax, ebx
        sar eax, 16
        add eax, edx

        mov ecx, eax

        mov bx, [edi]
        shr bx, 11
        and bx, 001Fh
        mov edx, ebx
        mov ax, [edi+2]
        shr ax, 11
        and ax, 001Fh
        sub eax, ebx
        mov ebx, Xfrac
        imul eax, ebx
        sar eax, 16
        add eax, edx

        sub eax, ecx
        mov ebx, Yfrac
        imul eax, ebx
        sar eax, 16
        add eax, ecx
        shl eax, 11
        or eax, esp

        cmp ax, Trans
        je @SkipSet

        mov edi, DstOfs
        mov [edi], ax

       @SkipSet:

        mov esp, _esp
        pop edi
        pop esi
        pop ebx
       end;
      end;
     Inc(DstOfs,2);
     Inc(Xfloat,CosVal);
     Inc(Yfloat,SinVal);
    end;
   Inc(DstOfs,DstAdd);
  end;
 Surface.UnLock;
 //Surface.ISurface4.Unlock(@SrcLockRect);
 FOpResult:= pgOk;
end;

procedure TGrafixSurface.DrawRotateAdd(Image:TPictureCollectionItem;Xpos,Ypos,Pattern,Angle:Integer);
Const Sqrt3=1.732050808;
Var HiLength,ImgX,ImgY,ImgW,ImgH:Integer;
    SrcOfs,SrcBWidth,DstOfs,DstAdd,J,I,SinVal,CosVal,xDiff,yDiff:Integer;
    SrcX,SrcY,StartX,StartY,SrcWidth,SrcHeight,DestWidth,DestHeight:Integer;
    Xfloat,Yfloat,Xint,Yint,Xadd,Yadd,Xfrac,Yfrac,CenterX,CenterY:Integer;
    SrcLockRect:TRect;
    Surface:TDirectDrawSurface;
    Trans:Word;
    _esp:Integer;
  TheSurfaceDesc: TDDSurfaceDesc_DX6;
begin
 Surface:=Image.PatternSurfaces[Pattern];
 if Surface=nil then
  begin
   FOpResult:=pgPatternOut;
   Exit;
  end;
 if Surface.SurfaceDesc.ddpfPixelFormat.dwRGBBitCount<>16 then
  begin
   FOpResult:=pgInvalidBitCount;
   Exit;
  end;
 { getting source rectangle }
 SrcX:=Image.PatternRects[Pattern].Left;
 SrcY:=Image.PatternRects[Pattern].Top;
 SrcWidth:=Image.PatternRects[Pattern].Right-SrcX;
 SrcHeight:=Image.PatternRects[Pattern].Bottom-SrcY;
 CenterX:=SrcWidth shr 1;
 CenterY:=SrcHeight shr 1;
 { calculating destination area size }
 HiLength:=SrcWidth;
 if SrcHeight>HiLength then HiLength:=SrcHeight;
 HiLength:=HiLength+Round((Sqrt3*HiLength)/4);
 { destination width & height }
 DestWidth:=HiLength;
 DestHeight:=HiLength;
 { centering rotating image inside destination }
 xDiff:=DestWidth shr 1;
 yDiff:=DestHeight shr 1;
 { centering destination image }
 Xpos:=Xpos-(DestWidth shr 1);
 Ypos:=Ypos-(DestHeight shr 1);
 { starting offsets in source image }
 StartX:=0;StartY:=0;
 { performing clipping }
 if Xpos<ClipRect.Left then
  begin
   StartX:=StartX+(ClipRect.Left-Xpos);
   DestWidth:=DestWidth-(ClipRect.Left-Xpos);
   Xpos:=ClipRect.Left;
   if DestWidth<1 then Exit;
  end;
 if Ypos<ClipRect.Top then
  begin
   StartY:=StartY+(ClipRect.Top-Ypos);
   DestHeight:=DestHeight-(ClipRect.Top-Ypos);
   Ypos:=ClipRect.Top;
   if DestHeight<1 then Exit;
  end;
 if Xpos+DestWidth>ClipRect.Right-1 then
  begin
   DestWidth:=ClipRect.Right-Xpos-1;
   if DestWidth<1 then Exit;
  end;
 if Ypos+DestHeight>ClipRect.Bottom-1 then
  begin
   DestHeight:=ClipRect.Bottom-Ypos-1;
   if DestHeight<1 then Exit;
  end;

 Trans:=Conv24to16(Image.TransparentColor);

 SrcLockRect:=Rect(0,0,Surface.SurfaceDesc.dwWidth,Surface.SurfaceDesc.dwHeight);

 //if Surface.ISurface4.Lock(@SrcLockRect,Surface.SurfaceDesc,DDLOCK_SURFACEMEMORYPTR+DDLOCK_WAIT,0)<>DD_OK then Exit;

 if NOT Surface.Lock(SrcLockRect, TheSurfaceDesc) Then Exit;
 SrcOfs:=Integer({Surface.SurfaceDesc}TheSurfaceDesc.lpSurface)+({Surface.SurfaceDesc}TheSurfaceDesc.lPitch*SrcY)+(SrcX shl 1);
 SrcBWidth:={Surface.SurfaceDesc}TheSurfaceDesc.lPitch;

 DstOfs:=Integer(FSurfaceDesc.lpSurface)+(FSurfaceDesc.lPitch*Ypos)+(Xpos shl 1);
 DstAdd:=FSurfacedesc.lPitch-(DestWidth shl 1);

 SinVal:=SinTable[Angle and $3FF];
 CosVal:=CosTable[Angle and $3FF];
 Xadd:=(CenterX shl 16)-(SinVal*(StartY-yDiff))+(CosVal*(StartX-xDiff));
 Yadd:=(CenterY shl 16)+(CosVal*(StartY-yDiff))+(SinVal*(StartX-xDiff));

 for J:=0 to DestHeight-1 do
  begin
   Xfloat:=Xadd-(SinVal*J);
   Yfloat:=Yadd+(CosVal*J);
   for I:=0 to DestWidth-1 do
    begin
     Xint:=SmallInt(Xfloat shr 16);
     Yint:=SmallInt(Yfloat shr 16);
     if (Xint>=0)and(Yint>=0)and(Xint<SrcWidth-1)and(Yint<SrcHeight-1) then
      begin
       Xfrac:=Xfloat and $FFFF;
       Yfrac:=Yfloat and $FFFF;
       asm
        push ebx
        push esi
        push edi
        mov _esp,esp

        mov esi, SrcOfs
        mov eax, Yint
        mov ebx, SrcBWidth
        imul eax, ebx
        add esi, eax
        mov eax, Xint
        shl eax, 1
        add esi, eax
        mov edi, esi
        add edi, SrcBWidth
        { ESI - Top pixel, EDI - Bottom pixel }

        xor eax,eax
        xor ebx,ebx
        xor ecx,ecx
        xor edx,edx
        { BLUE }
        mov bx,[esi]
        and bx,001Fh
        mov edx,ebx
        mov ax,[esi+2]
        and ax,001Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        mov ecx,eax

        mov bx,[edi]
        and bx,001Fh
        mov edx,ebx
        mov ax,[edi+2]
        and ax,001Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        sub eax,ecx
        mov ebx, Yfrac
        imul eax,ebx
        sar eax,16
        add eax,ecx
        mov esp,eax

        { GREEN }
        mov bx,[esi]
        shr bx,5
        and bx,003Fh
        mov edx,ebx
        mov ax,[esi+2]
        shr ax,5
        and ax,003Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        mov ecx,eax

        mov bx,[edi]
        shr bx,5
        and bx,003Fh
        mov edx,ebx
        mov ax,[edi+2]
        shr ax,5
        and ax,003Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        sub eax,ecx
        mov ebx, Yfrac
        imul eax,ebx
        sar eax,16
        add eax,ecx
        shl eax,5
        or esp,eax

        { RED }
        mov bx,[esi]
        shr bx,11
        and bx,001Fh
        mov edx,ebx
        mov ax,[esi+2]
        shr ax,11
        and ax,001Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        mov ecx,eax

        mov bx,[edi]
        shr bx,11
        and bx,001Fh
        mov edx,ebx
        mov ax,[edi+2]
        shr ax,11
        and ax,001Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        sub eax,ecx
        mov ebx, Yfrac
        imul eax,ebx
        sar eax,16
        add eax,ecx
        shl eax,11
        or eax,esp

        cmp ax,Trans
        je @SkipSet

        mov edi, DstOfs

        mov esp, eax          // ESP - source color
        mov bx, [edi]
        mov dx, bx            // EDX - destination color

        and ax, 001Fh         // Adding RED
        and bx, 001Fh
        add ax, bx

        cmp ax, 001Fh
        jb @Skip1
        mov ax, 001Fh
       @Skip1:
        mov cx, ax

        mov eax, esp          // Adding GREEN
        mov bx, dx
        shr ax, 5
        shr bx, 5
        and ax, 003Fh
        and bx, 003Fh
        add ax,bx

        cmp ax, 003Fh
        jb @Skip2
        mov ax, 003Fh
       @Skip2:
        shl ax,5
        or cx, ax

        mov eax, esp          // Adding BLUE
        mov bx, dx
        shr ax, 11
        shr bx, 11
        and ax, 001Fh
        and bx, 001Fh
        add ax,bx

        cmp ax, 001Fh
        jb @Skip3
        mov ax, 001Fh
       @Skip3:
        shl ax,11
        or cx, ax

        mov [edi],cx
       @SkipSet:

        mov esp,_esp
        pop edi
        pop esi
        pop ebx
       end;
      end;
     Inc(DstOfs,2);
     Inc(Xfloat,CosVal);
     Inc(Yfloat,SinVal);
    end;
   Inc(DstOfs,DstAdd);
  end;
 Surface.UnLock;
 //Surface.ISurface4.Unlock(@SrcLockRect);
 FOpResult:= pgOk;
end;

procedure TGrafixSurface.DrawRotateAddBlend(Image:TPictureCollectionItem;Xpos,Ypos,Pattern,Angle,Opacity:Integer);
Const Sqrt3=1.732050808;
Var HiLength,ImgX,ImgY,ImgW,ImgH:Integer;
    SrcOfs,SrcBWidth,DstOfs,DstAdd,J,I,SinVal,CosVal,xDiff,yDiff:Integer;
    SrcX,SrcY,StartX,StartY,SrcWidth,SrcHeight,DestWidth,DestHeight:Integer;
    Xfloat,Yfloat,Xint,Yint,Xadd,Yadd,Xfrac,Yfrac,CenterX,CenterY:Integer;
    SrcLockRect:TRect;
    Surface:TDirectDrawSurface;
    Trans:Word;
    Multiply:Byte;
    _esp:Integer;
  TheSurfaceDesc: TDDSurfaceDesc_DX6;
begin
 Surface:=Image.PatternSurfaces[Pattern];
 if Surface=nil then
  begin
   FOpResult:=pgPatternOut;
   Exit;
  end;
 if Surface.SurfaceDesc.ddpfPixelFormat.dwRGBBitCount<>16 then
  begin
   FOpResult:=pgInvalidBitCount;
   Exit;
  end;
 { getting source rectangle }
 SrcX:=Image.PatternRects[Pattern].Left;
 SrcY:=Image.PatternRects[Pattern].Top;
 SrcWidth:=Image.PatternRects[Pattern].Right-SrcX;
 SrcHeight:=Image.PatternRects[Pattern].Bottom-SrcY;
 CenterX:=SrcWidth shr 1;
 CenterY:=SrcHeight shr 1;
 { calculating destination area size }
 HiLength:=SrcWidth;
 if SrcHeight>HiLength then HiLength:=SrcHeight;
 HiLength:=HiLength+Round((Sqrt3*HiLength)/4);
 { destination width & height }
 DestWidth:=HiLength;
 DestHeight:=HiLength;
 { centering rotating image inside destination }
 xDiff:=DestWidth shr 1;
 yDiff:=DestHeight shr 1;
 { centering destination image }
 Xpos:=Xpos-(DestWidth shr 1);
 Ypos:=Ypos-(DestHeight shr 1);
 { starting offsets in source image }
 StartX:=0;StartY:=0;
 { performing clipping }
 if Xpos<ClipRect.Left then
  begin
   StartX:=StartX+(ClipRect.Left-Xpos);
   DestWidth:=DestWidth-(ClipRect.Left-Xpos);
   Xpos:=ClipRect.Left;
   if DestWidth<1 then Exit;
  end;
 if Ypos<ClipRect.Top then
  begin
   StartY:=StartY+(ClipRect.Top-Ypos);
   DestHeight:=DestHeight-(ClipRect.Top-Ypos);
   Ypos:=ClipRect.Top;
   if DestHeight<1 then Exit;
  end;
 if Xpos+DestWidth>ClipRect.Right-1 then
  begin
   DestWidth:=ClipRect.Right-Xpos-1;
   if DestWidth<1 then Exit;
  end;
 if Ypos+DestHeight>ClipRect.Bottom-1 then
  begin
   DestHeight:=ClipRect.Bottom-Ypos-1;
   if DestHeight<1 then Exit;
  end;

 Trans:=Conv24to16(Image.TransparentColor);
 Multiply:=(Opacity shr 2) and $FF;

 SrcLockRect:=Rect(0,0,Surface.SurfaceDesc.dwWidth,Surface.SurfaceDesc.dwHeight);

 //if Surface.ISurface4.Lock(@SrcLockRect,Surface.SurfaceDesc,DDLOCK_SURFACEMEMORYPTR+DDLOCK_WAIT,0)<>DD_OK then Exit;

 if NOT Surface.Lock(SrcLockRect, TheSurfaceDesc) Then Exit;
 SrcOfs:=Integer({Surface.SurfaceDesc}TheSurfaceDesc.lpSurface)+({Surface.SurfaceDesc}TheSurfaceDesc.lPitch*SrcY)+(SrcX shl 1);
 SrcBWidth:={Surface.SurfaceDesc}TheSurfaceDesc.lPitch;

 DstOfs:=Integer(FSurfaceDesc.lpSurface)+(FSurfaceDesc.lPitch*Ypos)+(Xpos shl 1);
 DstAdd:=FSurfacedesc.lPitch-(DestWidth shl 1);

 SinVal:=SinTable[Angle and $3FF];
 CosVal:=CosTable[Angle and $3FF];
 Xadd:=(CenterX shl 16)-(SinVal*(StartY-yDiff))+(CosVal*(StartX-xDiff));
 Yadd:=(CenterY shl 16)+(CosVal*(StartY-yDiff))+(SinVal*(StartX-xDiff));

 for J:=0 to DestHeight-1 do
  begin
   Xfloat:=Xadd-(SinVal*J);
   Yfloat:=Yadd+(CosVal*J);
   for I:=0 to DestWidth-1 do
    begin
     Xint:=SmallInt(Xfloat shr 16);
     Yint:=SmallInt(Yfloat shr 16);
     if (Xint>=0)and(Yint>=0)and(Xint<SrcWidth-1)and(Yint<SrcHeight-1) then
      begin
       Xfrac:=Xfloat and $FFFF;
       Yfrac:=Yfloat and $FFFF;
       asm
        push ebx
        push esi
        push edi
        mov _esp,esp

        mov esi, SrcOfs
        mov eax, Yint
        mov ebx, SrcBWidth
        imul eax, ebx
        add esi, eax
        mov eax, Xint
        shl eax, 1
        add esi, eax
        mov edi, esi
        add edi, SrcBWidth
        { ESI - Top pixel, EDI - Bottom pixel }

        xor eax,eax
        xor ebx,ebx
        xor ecx,ecx
        xor edx,edx
        { BLUE }
        mov bx,[esi]
        and bx,001Fh
        mov edx,ebx
        mov ax,[esi+2]
        and ax,001Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        mov ecx,eax

        mov bx,[edi]
        and bx,001Fh
        mov edx,ebx
        mov ax,[edi+2]
        and ax,001Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        sub eax,ecx
        mov ebx, Yfrac
        imul eax,ebx
        sar eax,16
        add eax,ecx
        mov esp,eax

        { GREEN }
        mov bx,[esi]
        shr bx,5
        and bx,003Fh
        mov edx,ebx
        mov ax,[esi+2]
        shr ax,5
        and ax,003Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        mov ecx,eax

        mov bx,[edi]
        shr bx,5
        and bx,003Fh
        mov edx,ebx
        mov ax,[edi+2]
        shr ax,5
        and ax,003Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        sub eax,ecx
        mov ebx, Yfrac
        imul eax,ebx
        sar eax,16
        add eax,ecx
        shl eax,5
        or esp,eax

        { RED }
        mov bx,[esi]
        shr bx,11
        and bx,001Fh
        mov edx,ebx
        mov ax,[esi+2]
        shr ax,11
        and ax,001Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        mov ecx,eax

        mov bx,[edi]
        shr bx,11
        and bx,001Fh
        mov edx,ebx
        mov ax,[edi+2]
        shr ax,11
        and ax,001Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        sub eax,ecx
        mov ebx, Yfrac
        imul eax,ebx
        sar eax,16
        add eax,ecx
        shl eax,11
        or eax,esp

        cmp ax,Trans
        je @SkipSet

        mov edi, DstOfs

        mov esp, eax          // ESP - source color
        mov bx, [edi]
        mov dx, bx            // EDX - destination color

        and ax, 001Fh         // Adding RED
        imul Multiply
        shr ax, 6
        and bx, 001Fh
        add ax, bx

        cmp ax, 001Fh
        jb @Skip1
        mov ax, 001Fh
       @Skip1:
        mov cx, ax

        mov eax, esp          // Adding GREEN
        mov bx, dx
        shr ax, 5
        shr bx, 5
        and ax, 003Fh
        imul Multiply
        shr ax, 6
        and bx, 003Fh
        add ax,bx

        cmp ax, 003Fh
        jb @Skip2
        mov ax, 003Fh
       @Skip2:
        shl ax,5
        or cx, ax

        mov eax, esp          // Adding BLUE
        mov bx, dx
        shr ax, 11
        shr bx, 11
        and ax, 001Fh
        imul Multiply
        shr ax, 6
        and bx, 001Fh
        add ax, bx

        cmp ax, 001Fh
        jb @Skip3
        mov ax, 001Fh
       @Skip3:
        shl ax,11
        or cx, ax

        mov [edi],cx
       @SkipSet:

        mov esp,_esp
        pop edi
        pop esi
        pop ebx
       end;
      end;
     Inc(DstOfs,2);
     Inc(Xfloat,CosVal);
     Inc(Yfloat,SinVal);
    end;
   Inc(DstOfs,DstAdd);
  end;
 Surface.UnLock;
 //Surface.ISurface4.Unlock(@SrcLockRect);
 FOpResult:= pgOk;
end;

procedure TGrafixSurface.DrawRotateBlend(Image:TPictureCollectionItem;Xpos,Ypos,Pattern,Angle,Opacity:Integer);
Const Sqrt3=1.732050808;
Var HiLength,ImgX,ImgY,ImgW,ImgH:Integer;
    SrcOfs,SrcBWidth,DstOfs,DstAdd,J,I,SinVal,CosVal,xDiff,yDiff:Integer;
    SrcX,SrcY,StartX,StartY,SrcWidth,SrcHeight,DestWidth,DestHeight:Integer;
    Xfloat,Yfloat,Xint,Yint,Xadd,Yadd,Xfrac,Yfrac,CenterX,CenterY:Integer;
    SrcLockRect:TRect;
    Surface:TDirectDrawSurface;
    Trans:Word;
    Mul1,Mul2:Byte;
    _esp:Integer;
  TheSurfaceDesc: TDDSurfaceDesc_DX6;
begin
 Surface:=Image.PatternSurfaces[Pattern];
 if Surface=nil then
  begin
   FOpResult:=pgPatternOut;
   Exit;
  end;
 if Surface.SurfaceDesc.ddpfPixelFormat.dwRGBBitCount<>16 then
  begin
   FOpResult:=pgInvalidBitCount;
   Exit;
  end;
 { getting source rectangle }
 SrcX:=Image.PatternRects[Pattern].Left;
 SrcY:=Image.PatternRects[Pattern].Top;
 SrcWidth:=Image.PatternRects[Pattern].Right-SrcX;
 SrcHeight:=Image.PatternRects[Pattern].Bottom-SrcY;
 CenterX:=SrcWidth shr 1;
 CenterY:=SrcHeight shr 1;
 { calculating destination area size }
 HiLength:=SrcWidth;
 if SrcHeight>HiLength then HiLength:=SrcHeight;
 HiLength:=HiLength+Round((Sqrt3*HiLength)/4);
 { destination width & height }
 DestWidth:=HiLength;
 DestHeight:=HiLength;
 { centering rotating image inside destination }
 xDiff:=DestWidth shr 1;
 yDiff:=DestHeight shr 1;
 { centering destination image }
 Xpos:=Xpos-(DestWidth shr 1);
 Ypos:=Ypos-(DestHeight shr 1);
 { starting offsets in source image }
 StartX:=0;StartY:=0;
 { performing clipping }
 if Xpos<ClipRect.Left then
  begin
   StartX:=StartX+(ClipRect.Left-Xpos);
   DestWidth:=DestWidth-(ClipRect.Left-Xpos);
   Xpos:=ClipRect.Left;
   if DestWidth<1 then Exit;
  end;
 if Ypos<ClipRect.Top then
  begin
   StartY:=StartY+(ClipRect.Top-Ypos);
   DestHeight:=DestHeight-(ClipRect.Top-Ypos);
   Ypos:=ClipRect.Top;
   if DestHeight<1 then Exit;
  end;
 if Xpos+DestWidth>ClipRect.Right-1 then
  begin
   DestWidth:=ClipRect.Right-Xpos-1;
   if DestWidth<1 then Exit;
  end;
 if Ypos+DestHeight>ClipRect.Bottom-1 then
  begin
   DestHeight:=ClipRect.Bottom-Ypos-1;
   if DestHeight<1 then Exit;
  end;

 Trans:=Conv24to16(Image.TransparentColor);
 Mul1:=(Opacity shr 2) and $3F;
 Mul2:=$3F-Mul1;

 SrcLockRect:=Rect(0,0,Surface.SurfaceDesc.dwWidth,Surface.SurfaceDesc.dwHeight);

 //if Surface.ISurface4.Lock(@SrcLockRect,Surface.SurfaceDesc,DDLOCK_SURFACEMEMORYPTR+DDLOCK_WAIT,0)<>DD_OK then Exit;

 if NOT Surface.Lock(SrcLockRect, TheSurfaceDesc) Then Exit;
 SrcOfs:=Integer({Surface.SurfaceDesc}TheSurfaceDesc.lpSurface)+({Surface.SurfaceDesc}TheSurfaceDesc.lPitch*SrcY)+(SrcX shl 1);
 SrcBWidth:={Surface.SurfaceDesc}TheSurfaceDesc.lPitch;

 DstOfs:=Integer(FSurfaceDesc.lpSurface)+(FSurfaceDesc.lPitch*Ypos)+(Xpos shl 1);
 DstAdd:=FSurfacedesc.lPitch-(DestWidth shl 1);

 SinVal:=SinTable[Angle and $3FF];
 CosVal:=CosTable[Angle and $3FF];
 Xadd:=(CenterX shl 16)-(SinVal*(StartY-yDiff))+(CosVal*(StartX-xDiff));
 Yadd:=(CenterY shl 16)+(CosVal*(StartY-yDiff))+(SinVal*(StartX-xDiff));

 for J:=0 to DestHeight-1 do
  begin
   Xfloat:=Xadd-(SinVal*J);
   Yfloat:=Yadd+(CosVal*J);
   for I:=0 to DestWidth-1 do
    begin
     Xint:=SmallInt(Xfloat shr 16);
     Yint:=SmallInt(Yfloat shr 16);
     if (Xint>=0)and(Yint>=0)and(Xint<SrcWidth-1)and(Yint<SrcHeight-1) then
      begin
       Xfrac:=Xfloat and $FFFF;
       Yfrac:=Yfloat and $FFFF;
       asm
        push ebx
        push esi
        push edi
        mov _esp,esp

        mov esi, SrcOfs
        mov eax, Yint
        mov ebx, SrcBWidth
        imul eax, ebx
        add esi, eax
        mov eax, Xint
        shl eax, 1
        add esi, eax
        mov edi, esi
        add edi, SrcBWidth
        { ESI - Top pixel, EDI - Bottom pixel }

        xor eax,eax
        xor ebx,ebx
        xor ecx,ecx
        xor edx,edx
        { BLUE }
        mov bx,[esi]
        and bx,001Fh
        mov edx,ebx
        mov ax,[esi+2]
        and ax,001Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        mov ecx,eax

        mov bx,[edi]
        and bx,001Fh
        mov edx,ebx
        mov ax,[edi+2]
        and ax,001Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        sub eax,ecx
        mov ebx, Yfrac
        imul eax,ebx
        sar eax,16
        add eax,ecx
        mov esp,eax

        { GREEN }
        mov bx,[esi]
        shr bx,5
        and bx,003Fh
        mov edx,ebx
        mov ax,[esi+2]
        shr ax,5
        and ax,003Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        mov ecx,eax

        mov bx,[edi]
        shr bx,5
        and bx,003Fh
        mov edx,ebx
        mov ax,[edi+2]
        shr ax,5
        and ax,003Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        sub eax,ecx
        mov ebx, Yfrac
        imul eax,ebx
        sar eax,16
        add eax,ecx
        shl eax,5
        or esp,eax

        { RED }
        mov bx,[esi]
        shr bx,11
        and bx,001Fh
        mov edx,ebx
        mov ax,[esi+2]
        shr ax,11
        and ax,001Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        mov ecx,eax

        mov bx,[edi]
        shr bx,11
        and bx,001Fh
        mov edx,ebx
        mov ax,[edi+2]
        shr ax,11
        and ax,001Fh
        sub eax,ebx
        mov ebx,Xfrac
        imul eax,ebx
        sar eax,16
        add eax,edx

        sub eax,ecx
        mov ebx, Yfrac
        imul eax,ebx
        sar eax,16
        add eax,ecx
        shl eax,11
        or eax,esp

        cmp ax,Trans
        je @SkipSet

        mov edi,DstOfs

        mov esp, eax          // ESP - source color
        mov bx, [edi]
        mov dx, bx            // EDX - destination color

        and ax, 001Fh         // Adding RED
        and bx, 001Fh
        mul Mul1
        xchg ax,bx
        mul Mul2
        shr ax,6
        shr bx,6
        add ax, bx
        mov cx, ax

        mov eax, esp          // Adding GREEN
        mov bx, dx
        shr ax, 5
        shr bx, 5
        and ax, 003Fh
        and bx, 003Fh
        mul Mul1
        xchg ax,bx
        mul Mul2
        shr ax,6
        shr bx,6
        add ax,bx
        shl ax,5
        or cx, ax

        mov eax, esp          // Adding BLUE
        mov bx, dx
        shr ax, 11
        shr bx, 11
        and ax, 001Fh
        and bx, 001Fh
        mul Mul1
        xchg ax,bx
        mul Mul2
        shr ax,6
        shr bx,6
        add ax,bx
        shl ax,11
        or cx, ax

        mov [edi],cx

       @SkipSet:

        mov esp,_esp
        pop edi
        pop esi
        pop ebx
       end;
      end;
     Inc(DstOfs,2);
     Inc(Xfloat,CosVal);
     Inc(Yfloat,SinVal);
    end;
   Inc(DstOfs,DstAdd);
  end;
 Surface.UnLock;
 //Surface.ISurface4.Unlock(@SrcLockRect);
 FOpResult:= pgOk;
end;

PROCEDURE SWAP(VAR A, B : Integer);
Var
  X : Integer;
Begin
  X := A;
  A := B;
  B := X;
End;

PROCEDURE TGrafixSurface.Circle(X, Y, Radius,Color: integer);
VAR
  a, af, b, bf,
  target, r2   : Integer;
Begin
  Target := 0;
  A  := Radius;
  B  := 0;
  R2 := Sqr(Radius);

  While a >= B DO
  Begin
    b:= Round(Sqrt(R2 - Sqr(A)));
    Swap(Target, B);
    While B < Target Do
    Begin
      Af := (120 * a) Div 100;
      Bf := (120 * b) Div 100;
      putpixel(x+af,y+b,color);
      putpixel(x+bf,y+a,color);
      putpixel(x-af,y+b,color);
      putpixel(x-bf,y+a,color);
      putpixel(x-af,y-b,color);
      putpixel(x-bf,y-a,color);
      putpixel(x+af,y-b,color);
      putpixel(x+bf,y-a,color);
      B := B + 1;
    End;
    A := A - 1;
  End;
End;

{filled ellipse}
procedure TGrafixSurface.FillEllipse(xc,yc,a,b,color:integer);
 var x,y:integer; aa,aa2,bb,bb2,d,dx,dy:longint; begin
 x:=0;y:=b;
 aa:=longint(a)*a; aa2:=2*aa;
 bb:=longint(b)*b; bb2:=2*bb;
 d:=bb-aa*b+aa div 4;
 dx:=0;dy:=aa2*b;
 vLine(xc,yc-y,yc+y,color);
 while(dx<dy)do begin
  if(d>0)then begin dec(y); dec(dy,aa2); dec(d,dy); end;
  inc(x); inc(dx,bb2); inc(d,bb+dx);
  vLine(xc-x,yc-y,yc+y,color);vLine(xc+x,yc-y,yc+y,color);
  end;
 inc(d,(3*(aa-bb)div 2-(dx+dy))div 2);
 while(y>=0)do begin
  if(d<0)then begin
   inc(x); inc(dx,bb2); inc(d,bb+dx);
   vLine(xc-x,yc-y,yc+y,color);vLine(xc+x,yc-y,yc+y,color);
   end;
  dec(y); dec(dy,aa2); inc(d,aa-dy);
  end;
 end;



 {original 'Procedure Ellipse2' by Bernie Pallek. Original code by Sean Palmer}
{original 'Procedure Rotate' by Mike Brennan}
Procedure TGrafixSurface.Rotate(cent1,cent2,angle:Integer;coord1,coord2:Real;clr:word);
Var coord1t, coord2t : Real;
    c1, c2 : integer;
begin
  coord1t := coord1 - cent1;
  coord2t := coord2 - cent2;
  coord1 := coord1t * cos(angle * pi / 180) - coord2t * sin(angle * pi / 180);
  coord2 := coord1t * sin(angle * pi / 180) + coord2t * cos(angle * pi / 180);
  coord1 := coord1 + cent1;
  coord2 := coord2 + cent2;
  c1 := round(coord1);
  c2 := round(coord2);
  putpixel(c1,c2,clr);
end;

 {but, and I quote, Bernie 'mangled it'}
PROCEDURE TGrafixSurface.Ellipse(exc, eyc, ea, eb, i, clr : Integer);
VAR
  elx, ely : Integer;
  aa, aa2, bb, bb2, d, dx, dy : LongInt;
  x,y : real;
BEGIN
  elx := 0; ely := eb; aa := LongInt(ea) * ea; aa2 := 2 * aa;
  bb := LongInt(eb) * eb; bb2 := 2 * bb;
  d := bb - aa * eb + aa DIV 4; dx := 0; dy := aa2 * eb;
  x := exc; y := eyc - ely;
  rotate(exc,eyc,i,x,y,clr);
  x := exc; y := eyc + ely;
  rotate(exc,eyc,i,x,y,clr);
  x := exc - ea; y := eyc;
  rotate(exc,eyc,i,x,y,clr);
  x := exc + ea; y := eyc;
  rotate(exc,eyc,i,x,y,clr);
  WHILE (dx < dy) DO BEGIN
    IF (d > 0) THEN BEGIN Dec(ely); Dec(dy, aa2); Dec(d, dy); END;
    Inc(elx); Inc(dx, bb2); Inc(d, bb + dx);
    x := exc + elx; y := eyc + ely;
    rotate(exc,eyc,i,x,y,clr);
    x := exc - elx; y := eyc + ely;
    rotate(exc,eyc,i,x,y,clr);
    x := exc + elx; y := eyc - ely;
    rotate(exc,eyc,i,x,y,clr);
    x := exc - elx; y := eyc - ely;
    rotate(exc,eyc,i,x,y,clr);
  END;
  Inc(d, (3 * (aa - bb) DIV 2 - (dx + dy)) DIV 2);
  WHILE (ely > 0) DO BEGIN
    IF (d < 0) THEN BEGIN Inc(elx); Inc(dx, bb2); Inc(d, bb + dx); END;
    Dec(ely); Dec(dy, aa2); Inc(d, aa - dy);
    x := exc + elx; y := eyc + ely;
    rotate(exc,eyc,i,x,y,clr);
    x := exc - elx; y := eyc + ely;
    rotate(exc,eyc,i,x,y,clr);
    x := exc + elx; y := eyc - ely;
    rotate(exc,eyc,i,x,y,clr);
    x := exc - elx; y := eyc - ely;
    rotate(exc,eyc,i,x,y,clr);
  END;
END;


procedure Tgrafixsurface.box(xs,ys,xd,yd,color:integer);
begin
     line(xs,ys,xd,ys,color);
     line(xs,ys,xs,yd,color);
     line(xd,ys,xd,yd,color);
     line(xs,yd,xd,yd,color);
end;

procedure Tgrafixsurface.wubox(xs,ys,xd,yd,color:integer);
begin
     wuline(xs,ys,xd,ys,color);
     wuline(xs,ys,xs,yd,color);
     wuline(xd,ys,xd,yd,color);
     wuline(xs,yd,xd,yd,color);
end;

procedure TGrafixSurface.FillBox(x1,y1,x2,y2,color:integer);
var i : integer;
begin
     for i:=y1 to y2 do
         line(x1,i,x2,i,color);
end;

procedure TGrafixSurface.Blur;
var
  x,y,tr,tg,tb:integer;
  r,g,b : byte;
begin
 for y:=1 to  FHeight-1 do
   for x:=1 to FWidth-1 do
   begin
     getrgb(getpixel(x,y+1),r,g,b);
     tr:=r;
     tg:=g;
     tb:=b;
     getrgb(getpixel(x,y-1),r,g,b);
     tr:=tr+r;
     tg:=tg+g;
     tb:=tb+b;
     getrgb(getpixel(x-1,y),r,g,b);
     tr:=tr+r;
     tg:=tg+g;
     tb:=tb+b;
     getrgb(getpixel(x+1,y),r,g,b);
     tr:=tr+r shr 2;
     tg:=tg+g shr 2;
     tb:=tb+b shr 2;
     putpixel(x,y,rgb(tr,tg,tb));
   end;
end;

procedure TGrafixSurface.Noise(Oblast: TRect; Density: Byte);
var
  dx,dy: integer;
  Dens : byte;
begin
  {noise}
  case Density of
    0..2: Dens := 3;
    255: Dens := 254;
  else
    Dens := Density;
  end;
  if Dens >= Oblast.Right then
    Dens := Oblast.Right div 3;
  dy := Oblast.Top;
  while dy <= Oblast.Bottom do begin
    dx := Oblast.Left;
    while dx <= Oblast.Right do begin
      inc(dx,random(dens));
      if dx <= Oblast.Right then
        PutPixel(dx,dy,NOT GetPixel(dx,dy));
    end;
    inc(dy);
  end;
end;

end.
