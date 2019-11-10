unit turbopixels;

// turboPixels 1.2
// for use with DelphiX DirectX Headers and Components

// (c) 2000 Michael Wilson -- no.2 games
// www.no2games.com & turbo.gamedev.net
// wilson@no2games.com

// 1.2 Features:
// DelphiX 7 support
// Powered by PixelCore release
// PixelCore ASM routines by Henri Hakl aka A-Lore
// Updated WinAmp font routine

// 1.1 Features:
// Incorporated ASM conversion by LifePower
// Incorporated ASM putpixels by JerK
// Added non-RGB versions of 8/16/24 PutPixels
// Faster clipping and no surface passing
// Auto 565 and 555 detection that works!!!
// Re-oganized demo for more speed and FPS counter

// 1.0 Inital release

// [ Credits and thanks... ]
// Based on FastPixels v0.2 for DelphiX -- but faster ;)
// 24-bit put loosely based on Erik Englund's Setpixel.pas
// Thanks to Tim Baumgarten for some bit shifting ideas
// Thanks to John Hebert for teaching me AlphaBlending
// Thanks to Hugo for introducing me to Wu
// ASM conversion routines by LifePower (faster...)
// ASM put routines by JerK (jdelauney@free.fr)
// PixelCore ASM routines by Henri Hakl aka A-Lore
// Font from a WinAmp skin
// Windows SDK help for confusing me about RGB values

// [ Legal ]
// THIS SOFTWARE AND THE ACCOMPANYING FILES
// ARE WITHOUT WARRANTIES AS TO PERFORMANCE
// OR MERCHANTABILITY OR ANY OTHER WARRANTIES
// WHETHER EXPRESSED OR IMPLIED.
// Because of the various hardware and software
// environments into which turboPixels may be put,
// NO WARRANTY OF FITNESS FOR A PARTICULAR
// PURPOSE IS OFFERED.


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  DXDraws, DXClass,
{$IfDef StandardDX}
   DirectDraw;
{$Else}
   DirectX;
{$EndIf}

const
  alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ"at  0123456789<>=()-''!_+\/{}^&%.=$#ежд?*';
  numbers = '0123456789-';

// *** locking functions ***

function turboLock(DxDrawSurface: TDirectDrawSurface): Boolean;
procedure turboUnlock;

// *** pixel manipulation ***

procedure turboSetPixel8(const X, Y: Integer; color: byte);
procedure turboSetPixel8A(const X, Y: Integer; color: Integer);
procedure turboSetPixel8PC(x, y, color: integer);
procedure turboSetPixel16RGB(const X, Y: Integer; R, G, B: byte);
procedure turboSetPixel24RGB(const X, Y: Integer; R, G, B: byte);
procedure turboSetPixel16(const X, Y: integer; color: cardinal);
procedure turboSetPixel16A(X, Y: Integer; color: cardinal);
procedure turboSetPixel16PC(x, y, color: integer);
procedure turboSetPixel32PC(x, y, color: integer);
procedure turboSetPixel24(const X, Y: integer; color: cardinal);
procedure turboSetPixel24A(X, Y: Integer; Color: cardinal);
procedure turboSetPixel24PC(x, y, color: integer);
function turboGetPixel8(const X, Y: Integer): byte;
function turboGetPixel8PC(x, y: integer): integer;
function turboGetPixel16(const x, y: Integer): cardinal;
function turboGetPixel16PC(x, y: integer): integer;
function r16(color: cardinal): byte;
function g16(color: cardinal): byte;
function b16(color: cardinal): byte;
function turboGetPixel24(const x, y: Integer): dword;
function turboGetPixel24PC(x, y: integer): integer;
function r24(color: cardinal): byte;
function g24(color: cardinal): byte;
function b24(color: cardinal): byte;
function turboGetPixel32PC(x, y: integer): integer;
procedure turboSetPixelAlpha16(const X, Y: Integer; color: cardinal; A: byte);
procedure turboSetPixelAlpha24(const X, Y: Integer; color: cardinal; A: byte);
procedure turboSetPixelAlpha16RGB(const X, Y: Integer; R, G, B, A: byte);
procedure turboSetPixelAlpha24RGB(const X, Y: Integer; R, G, B, A: byte);
function Conv15to24(Color: Word): Integer; register;
function Conv16to24(Color: Word): Integer; register;
function Conv24to15(Color: Integer): Word; register;
function Conv24to16(Color: Integer): Word; register;

// *** graphic primitives ***

procedure turboLine16(x1, y1, x2, y2: Integer; R, G, B: byte);
procedure turboLine24(x1, y1, x2, y2: Integer; R, G, B: byte);
procedure turboWuLine16(x1, y1, x2, y2: Integer; R, G, B: byte);
procedure turboWuLine24(x1, y1, x2, y2: Integer; R, G, B: byte);
procedure turboWrite(DxDrawSurface: TDirectDrawSurface; Imagelist: TDXImageList; font, text: string; x, y: integer);
procedure turboWriteD(DxDrawSurface: TDirectDrawSurface; Imagelist: TDXImageList; font, text: string; x, y: integer);

implementation

var
  LockedSurface: IDirectDrawSurface4;
  LockedSurfaceDesc: TDDSurfaceDesc2;
  LockedRect: TRect;
  bitfix: cardinal; // for 555 or 565
  xmax, ymax: integer; // clipping

function turboLock(DxDrawSurface: TDirectDrawSurface): Boolean;
begin
  LockedSurface := DxDrawSurface.ISurface4;
  LockedSurfaceDesc.dwSize := SizeOf(TDDSurfaceDesc);
  LockedRect := Rect(0, 0, LockedSurfaceDesc.dwWidth,
    LockedSurfaceDesc.dwHeight);
  if LockedSurface.Lock(@LockedRect, // do the lock
    LockedSurfaceDesc,
    DDLOCK_SURFACEMEMORYPTR + DDLOCK_WAIT,
    0) <> DD_OK
    then Result := False
  else Result := True;
  xmax := DxDrawSurface.Width - 1; // Max X clip
  ymax := DxDrawSurface.Height - 1; // Max Y clip
  if LockedSurfaceDesc.ddpfPixelFormat.dwGBitMask = 2016 // if there are 6 bits
    then bitfix := 0 else bitfix := 1; // of GREEN were looking at 565
end;

procedure turboUnlock;
begin
  LockedSurface.Unlock(@LockedRect);
  LockedSurface := nil; // free locked surface
end;

procedure turboSetPixel8(const X, Y: Integer; color: byte);
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  pbyte(integer(LockedSurfaceDesc.lpsurface) + // surface pointer
    y * LockedSurfaceDesc.lpitch + x)^ := color; // offset for 1 byte pixel
end;

procedure turboSetPixel8A(const X, Y: Integer; color: Integer); assembler;
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  asm
    push ebx  // ASM put routines by JerK (jdelauney@free.fr)
    push esi  // Don't seem much faster
    push edi
    mov esi,LockedSurfaceDesc.lpSurface
    mov eax,[LockedSurfaceDesc.lpitch]
    mul [Y]
    add esi,eax
    mov ebx,[X]
    add esi,ebx
    mov ebx,[Color]
    mov ds:[esi],ebx
    pop edi
    pop esi
    pop ebx
  end;
end;

procedure turboSetPixel16RGB(const X, Y: Integer; R, G, B: byte);
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  pword(integer(LockedSurfaceDesc.lpsurface) + // surface pointer
    y * LockedSurfaceDesc.lpitch + x * 2)^ := // offset for *2* byte pixel
    ((R shr 3) shl (11 - bitfix)) or // r value shifted
    ((G shr (2 + bitfix)) shl 5) or // g value shifted
    (B shr 3); // add blue
end;

procedure turboSetPixel24RGB(const X, Y: Integer; R, G, B: byte);
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  pdword(integer(LockedSurfaceDesc.lpsurface) + // surface pointer
    y * LockedSurfaceDesc.lpitch + x * 3)^ :=
    (r shl 16) or (g shl 8) or b; // Could use RGB(r,g,b)
end;

procedure turboSetPixel16(const X, Y: integer; color: cardinal);
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  if bitfix = 0 then
    pword(integer(LockedSurfaceDesc.lpsurface) + // surface pointer
      y * LockedSurfaceDesc.lpitch + x * 2)^ := // offset for *2* byte pixel
      Conv24to16(color)
  else
    pword(integer(LockedSurfaceDesc.lpsurface) + // surface pointer
      y * LockedSurfaceDesc.lpitch + x * 2)^ := // offset for *2* byte pixel
      Conv24to15(color);
//    ((R16(color) shr 3) shl (11 - bitfix)) or // r value shifted
//    ((G16(color) shr (2 + bitfix)) shl 5) or // g value shifted
//    (B16(color) shr 3); // add blue
end;

procedure turboSetPixel16A(X, Y: Integer; Color: cardinal); assembler;
var
  convertedcolor: integer;
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  if bitfix = 0 then
    convertedcolor := Conv24to16(color)
  else
    convertedcolor := Conv24to15(color);
  asm
    push ebx  // ASM put routines by JerK (jdelauney@free.fr)
    push esi
    push edi
    mov esi,LockedSurfaceDesc.lpSurface
    mov eax,[LockedSurfaceDesc.lpitch]
    mul [Y]
    add esi,eax
    mov ebx,[X]
    shl ebx,1
    add esi,ebx
    mov ebx,[convertedcolor]
    mov ds:[esi],ebx
    pop edi
    pop esi
    pop ebx
  end;
end;

procedure turboSetPixel24(const X, Y: Integer; color: cardinal);
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  pdword(integer(LockedSurfaceDesc.lpsurface) + // surface pointer
    y * LockedSurfaceDesc.lpitch + x * 3)^ :=
    color;
end;

procedure turboSetPixel24A(X, Y: Integer; Color: cardinal); assembler;
begin
  asm
    push ebx  // ASM put routines by JerK (jdelauney@free.fr)
    push esi
    push edi
    mov esi,LockedSurfaceDesc.lpSurface
    mov eax,[LockedSurfaceDesc.lpitch]
    mul [Y]
    add esi,eax
    mov ebx,[X]
    imul ebx,3
    add esi,ebx
    mov ebx,[Color]
    mov ds:[esi],ebx
    pop edi
    pop esi
    pop ebx
  end;
end;

function turboGetPixel8(const X, Y: Integer): byte;
begin
  result := 0;
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  result := pbyte(integer(LockedSurfaceDesc.lpsurface) + // surface pointer
    y * LockedSurfaceDesc.lpitch + x)^; // offset for 1 byte pixel
end;

function turboGetPixel16(const x, y: Integer): cardinal;
begin
  result := 0;
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  result := pword(integer(LockedSurfaceDesc.lpsurface) + // surface pointer
    y * LockedSurfaceDesc.lpitch + x * 2)^;
end;

function r16(color: cardinal): byte;
begin;
  result := (color shr (11 - bitfix)) shl 3;
end;

function g16(color: cardinal): byte;
begin;
  if bitfix = 0 then
    result := ((color and 2016) shr 5) shl 2
  else
    result := ((color and 992) shr 5) shl 3;
end;

function b16(color: cardinal): byte;
begin;
  result := (color and 31) shl 3;
end;

function turboGetPixel24(const x, y: Integer): dword;
begin
  result := 0;
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  result := pdword(integer(LockedSurfaceDesc.lpsurface) + // surface pointer
    y * LockedSurfaceDesc.lpitch + x * 3)^;
end;

function r24(color: cardinal): byte;
begin;
  result := (color shr 16) and 255; // or GetRValue(color);
end;

function g24(color: cardinal): byte;
begin;
  result := (color shr 8) and 255; // or GetGValue(color);
end;

function b24(color: cardinal): byte;
begin;
// Some video boards may return a blue value in the first byte
// i.e. result := color and 255;
  result := (color shr 24) and 255; // or GetBValue(color);
end;

procedure turboSetPixelAlpha16RGB(const X, Y: Integer; R, G, B, A: byte);
var color: integer;
begin
// This function could use a lot of speed work, but it's faster than
// alpha blending Canvas.Pixels ;) but Hori's FillRectAdd is faster
// for large areas
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  color := turboGetPixel16(x, y); // get "color"
  turboSetPixel16RGB(X, Y, // set new pixel
    (A * (R - r16(color)) shr 8) + r16(color), // R alpha
    (A * (G - g16(color)) shr 8) + g16(color), // G alpha
    (A * (B - b16(color)) shr 8) + b16(color)); // B alpha
end;

procedure turboSetPixelAlpha24RGB(const X, Y: Integer; R, G, B, A: byte);
var color: dword;
begin
// This function could use a lot of speed work, but it's faster than
// alpha blending Canvas.Pixels ;) but Hori's FillRectAdd is faster
// for large areas
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  color := turboGetPixel24(x, y); // get "color"
  turboSetPixel24RGB(X, Y, // set new pixel
    (A * (R - r24(color)) shr 8) + r24(color), // R alpha
    (A * (G - g24(color)) shr 8) + g24(color), // G alpha
    (A * (B - b24(color)) shr 8) + b24(color)); // B alpha
end;


procedure turboSetPixelAlpha16(const X, Y: Integer; color: cardinal; A: byte);
var oldcolor: integer;
begin
// This function could use a lot of speed work, but it's faster than
// alpha blending Canvas.Pixels ;) but Hori's FillRectAdd is faster
// for large areas
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  oldcolor := turboGetPixel16(x, y); // get old color
  turboSetPixel16RGB(X, Y, // set new pixel
    (A * (r16(color) - r16(oldcolor)) shr 8) + r16(oldcolor), // R alpha
    (A * (g16(color) - g16(oldcolor)) shr 8) + g16(oldcolor), // G alpha
    (A * (b16(color) - b16(oldcolor)) shr 8) + b16(oldcolor)); // B alpha
end;

procedure turboSetPixelAlpha24(const X, Y: Integer; color: cardinal; A: byte);
var oldcolor: dword;
begin
// This function could use a lot of speed work, but it's faster than
// alpha blending Canvas.Pixels ;) but Hori's FillRectAdd is faster
// for large areas
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  oldcolor := turboGetPixel24(x, y); // get "color"
  turboSetPixel24RGB(X, Y, // set new pixel
    (A * (r24(color) - r24(oldcolor)) shr 8) + r24(oldcolor), // R alpha
    (A * (g24(color) - g24(oldcolor)) shr 8) + g24(oldcolor), // G alpha
    (A * (b24(color) - b24(oldcolor)) shr 8) + b24(oldcolor)); // B alpha
end;

// *** ASM pixel routines straight from PixelCore by Henri Hakl aka A-Lore ***
// *** Surface clipping added by Michael Wilson 09/07/2000

procedure turboSetPixel8PC(x, y, color: integer);
{ on entry:  x = eax,   y = edx,   color = ecx }
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  asm
   push esi                              // must maintain esi
   mov esi,LockedSurfaceDesc.lpSurface      // set to surface
   add esi,eax                           // add x
   mov eax,[LockedSurfaceDesc.lpitch]       // eax = pitch
   mul edx                               // eax = pitch * y
   add esi,eax                           // esi = pixel offset
   mov ds:[esi],cl                       // set pixel (lo byte of ecx)
   pop esi                               // restore esi
   ret                                   // return
  end;
end;

procedure turboSetPixel16PC(x, y, color: integer);
{ on entry:  x = eax,   y = edx,   color = ecx }
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  asm
   push esi
   mov esi,LockedSurfaceDesc.lpSurface
   shl eax,1
   add esi,eax                           // description similar to PutPixel8
   mov eax,[LockedSurfaceDesc.lpitch]
   mul edx
   add esi,eax
   mov ds:[esi],cx
   pop esi
   ret
  end;
end;

procedure turboSetPixel24PC(x, y, color: integer);
{ on entry:  x = eax,   y = edx,   color = ecx }
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  asm
   push esi
   mov esi,LockedSurfaceDesc.lpSurface
   imul eax,3
   add esi,eax                           // description similar to PutPixel8
   mov eax,[LockedSurfaceDesc.lpitch]
   mul edx
   add esi,eax
   mov eax,ds:[esi]       // the idea is to get the current pixel
   and eax,$ff000000      // and the top 8 bits of next pixel (red component)
   or  ecx,eax            // then bitwise OR that component to the current color
   mov ds:[esi+1],ecx     // to ensure the prior bitmap isn't incorrectly manipulated
   pop esi                // can't test if it works... so hope and pray
   ret
  end;
end;

procedure turboSetPixel32PC(x, y, color: integer);
{ on entry:  x = eax,   y = edx,   color = ecx }
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  asm
   push esi
   mov esi,LockedSurfaceDesc.lpSurface
   shl eax,2
   add esi,eax                           // description similar to PutPixel8
   mov eax,[LockedSurfaceDesc.lpitch]
   mul edx
   add esi,eax
   mov ds:[esi],ecx
   pop esi
   ret
  end;
end;

function turboGetPixel8PC(x, y: integer): integer;
{ on entry:  x = eax,   y = edx }
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  asm
   push esi                              // myst maintain esi
   mov esi,LockedSurfaceDesc.lpSurface      // set to surface
   add esi,eax                           // add x
   mov eax,[LockedSurfaceDesc.lpitch]       // eax = pitch
   mul edx                               // eax = pitch * y
   add esi,eax                           // esi = pixel offset
   mov eax,ds:[esi]                      // eax = color
   and eax,$ff                           // map into 8bit
   pop esi                               // restore esi
   ret                                   // return
  end;
end;

function turboGetPixel16PC(x, y: integer): integer;
{ on entry:  x = eax,   y = edx }
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  asm
   push esi
   mov esi,LockedSurfaceDesc.lpSurface
   shl eax,1
   add esi,eax                           // description similar to GetPixel8
   mov eax,[LockedSurfaceDesc.lpitch]
   mul edx
   add esi,eax
   mov eax,ds:[esi]
   and eax,$ffff                         // map into 16bit
   pop esi
   ret
  end;
end;

function turboGetPixel24PC(x, y: integer): integer;
{ on entry:  x = eax,   y = edx }
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  asm
   push esi
   mov esi,LockedSurfaceDesc.lpSurface
   imul eax,3
   add esi,ebx                           // description similar to GetPixel8
   mov eax,[LockedSurfaceDesc.lpitch]
   mul edx
   add esi,eax
   mov eax,ds:[esi]
   and eax,$ffffff                       // map into 24bit
   pop esi
   ret
  end;
end;

function turboGetPixel32PC(x, y: integer): integer;
{ on entry:  x = eax,   y = edx }
begin
  if (X < 0) or (X > xmax) or // Clip to DelphiX Surface
    (Y < 0) or (Y > ymax) then Exit;
  asm
   push esi
   mov esi,LockedSurfaceDesc.lpSurface
   shl eax,2
   add esi,eax                           // description similar to GetPixel8
   mov eax,[LockedSurfaceDesc.lpitch]
   mul edx
   add esi,eax
   mov eax,ds:[esi]
   pop esi
   ret
  end;
end;

// *** end of Pixel Core routines

procedure turboLine16(x1, y1, x2, y2: Integer; R, G, B: byte);
var
  i, deltax, deltay, numpixels,
    d, dinc1, dinc2, x, xinc1, xinc2,
    y, yinc1, yinc2: integer;
begin
  deltax := abs(x2 - x1); // Calculate deltax and deltay for initialisation
  deltay := abs(y2 - y1);
  if deltax >= deltay then // Initialize all vars based on which is the independent variable
  begin
    numpixels := deltax + 1; // x is independent variable
    d := (2 * deltay) - deltax;
    dinc1 := deltay shl 1;
    dinc2 := (deltay - deltax) shl 1;
    xinc1 := 1;
    xinc2 := 1;
    yinc1 := 0;
    yinc2 := 1;
  end
  else
  begin
    numpixels := deltay + 1; // y is independent variable
    d := (2 * deltax) - deltay;
    dinc1 := deltax shl 1;
    dinc2 := (deltax - deltay) shl 1;
    xinc1 := 0;
    xinc2 := 1;
    yinc1 := 1;
    yinc2 := 1;
  end;
  if x1 > x2 then // Make sure x and y move in the right directions
  begin
    xinc1 := -xinc1;
    xinc2 := -xinc2;
  end;
  if y1 > y2 then
  begin
    yinc1 := -yinc1;
    yinc2 := -yinc2;
  end;
  x := x1; // Start drawing at <x1, y1>
  y := y1;
  for i := 1 to numpixels do // Draw the pixels
  begin
    turboSetPixel16RGB(X, Y, R, G, B);
    if d < 0 then
    begin
      d := d + dinc1;
      x := x + xinc1;
      y := y + yinc1;
    end
    else
    begin
      d := d + dinc2;
      x := x + xinc2;
      y := y + yinc2;
    end;
  end;
end;

procedure turboLine24(x1, y1, x2, y2: Integer; R, G, B: byte);
var
  i, deltax, deltay, numpixels,
    d, dinc1, dinc2, x, xinc1, xinc2,
    y, yinc1, yinc2: integer;
begin
  deltax := abs(x2 - x1); // Calculate deltax and deltay for initialisation
  deltay := abs(y2 - y1);
  if deltax >= deltay then // Initialize all vars based on which is the independent variable
  begin
    numpixels := deltax + 1; // x is independent variable
    d := (2 * deltay) - deltax;
    dinc1 := deltay shl 1;
    dinc2 := (deltay - deltax) shl 1;
    xinc1 := 1;
    xinc2 := 1;
    yinc1 := 0;
    yinc2 := 1;
  end
  else
  begin
    numpixels := deltay + 1; // y is independent variable
    d := (2 * deltax) - deltay;
    dinc1 := deltax shl 1;
    dinc2 := (deltax - deltay) shl 1;
    xinc1 := 0;
    xinc2 := 1;
    yinc1 := 1;
    yinc2 := 1;
  end;
  if x1 > x2 then // Make sure x and y move in the right directions
  begin
    xinc1 := -xinc1;
    xinc2 := -xinc2;
  end;
  if y1 > y2 then
  begin
    yinc1 := -yinc1;
    yinc2 := -yinc2;
  end;
  x := x1; // Start drawing at <x1, y1>
  y := y1;
  for i := 1 to numpixels do // Draw the pixels
  begin
    turboSetPixel24RGB(X, Y, R, G, B);
    if d < 0 then
    begin
      d := d + dinc1;
      x := x + xinc1;
      y := y + yinc1;
    end
    else
    begin
      d := d + dinc2;
      x := x + xinc2;
      y := y + yinc2;
    end;
  end;
end;

procedure turboWuLine16(x1, y1, x2, y2: Integer; R, G, B: byte);
var
  deltax, deltay, loop, start, finish: integer;
  dx, dy, dydx: single; // fractional parts
begin
  deltax := abs(x2 - x1); // Calculate deltax and deltay for initialisation
  deltay := abs(y2 - y1);
  if (deltax = 0) or (deltay = 0) then begin // straight lines
    turboLine16(x1, y1, x2, y2, R, G, B);
    exit;
  end;
  if deltax > deltay then // horizontal or verticle
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
    for loop := start to finish do begin
      turboSetPixelAlpha16RGB(loop, trunc(dy), R, G, B,
        trunc((1 - frac(dy)) * 255)); // plot main point
      turboSetPixelAlpha16RGB(loop, trunc(dy) + 1, R, G, B,
        trunc(frac(dy) * 255)); // plot fractional difference
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
    for loop := start to finish do begin
      turboSetPixelAlpha16RGB(trunc(dx), loop, R, G, B,
        trunc((1 - frac(dx)) * 255)); // plot main point
      turboSetPixelAlpha16RGB(trunc(dx) + 1, loop, R, G, B,
        trunc(frac(dx) * 255)); // plot fractional difference
      dx := dx + dydx; // next point
    end;
  end;
end;

procedure turboWuLine24(x1, y1, x2, y2: Integer; R, G, B: byte);
var
  deltax, deltay, loop, start, finish: integer;
  dx, dy, dydx: single; // fractional parts
begin
  deltax := abs(x2 - x1); // Calculate deltax and deltay for initialisation
  deltay := abs(y2 - y1);
  if (deltax = 0) or (deltay = 0) then begin // straight lines
    turboLine24(x1, y1, x2, y2, R, G, B);
    exit;
  end;
  if deltax > deltay then // horizontal or verticle
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
    for loop := start to finish do begin
      turboSetPixelAlpha24RGB(loop, trunc(dy), R, G, B,
        trunc((1 - frac(dy)) * 255)); // plot main point
      turboSetPixelAlpha24RGB(loop, trunc(dy) + 1, R, G, B,
        trunc(frac(dy) * 255)); // plot fractional difference
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
    for loop := start to finish do begin
      turboSetPixelAlpha24RGB(trunc(dx), loop, R, G, B,
        trunc((1 - frac(dx)) * 255)); // plot main point
      turboSetPixelAlpha24RGB(trunc(dx) + 1, loop, R, G, B,
        trunc(frac(dx) * 255)); // plot fractional difference
      dx := dx + dydx; // next point
    end;
  end;
end;

// *** ASM conversion routines by LifePower ***

function Conv15to24(Color: Word): Integer; register;
asm
 xor edx,edx   // not used in LIB
 mov dx,ax     // ASM code by LifePower
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

function Conv16to24(Color: Word): Integer; register;
asm
 xor edx,edx   // not used in LIB
 mov dx,ax     // ASM code by LifePower
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

function Conv24to15(Color: Integer): Word; register;
asm
 mov ecx,eax   // ASM code by LifePower
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

function Conv24to16(Color: Integer): Word; register;
asm
 mov ecx,eax   // ASM code by LifePower
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

procedure turboWrite(DxDrawSurface: TDirectDrawSurface; Imagelist: TDXImageList; font, text: string; x, y: integer);
var
  loop, line, letter, offset, i: integer;
begin
  i := Imagelist.items.IndexOf(font); // find font once
  offset := Imagelist.items[i].patternwidth;
  line := 1;
  for loop := 1 to Length(text) do
  begin { each letter }
    if text[loop] = '|' then // fake a <P>
    begin
      inc(y, Imagelist.items[i].patternheight + 1);
      line := 1;
    end
    else begin
      letter := pos(uppercase(text[loop]), alphabet) - 1;
      if letter < 0 then letter := 30;
      Imagelist.items[i].draw(DxDrawSurface, x + (offset * line), y, letter);
      inc(line);
    end;
  end; { loop }
end; { graphics write }

procedure turboWriteD(DxDrawSurface: TDirectDrawSurface; Imagelist: TDXImageList; font, text: string; x, y: integer);
var
  loop, line, letter, offset, i: integer;
begin
  i := Imagelist.items.IndexOf(font); // find font once
  offset := Imagelist.items[i].patternwidth;
  line := 1;
  for loop := 1 to Length(text) do
  begin { each letter }
    if text[loop] = '|' then // fake a <P>
    begin
      inc(y, Imagelist.items[i].patternheight + 1);
      line := 1;
    end
    else begin
      letter := pos(uppercase(text[loop]), numbers) - 1;
      if letter < 0 then letter := 30;
      Imagelist.items[i].draw(DxDrawSurface, x + (offset * line), y, letter);
      inc(line);
    end;
  end; { loop }
end; { graphics write digits }

end.

