unit PixelCore;

{* PixelCore, fast routines for pixel manipulation. *}

{ by Henri Hakl,  aka A-Lore        e-mail: 12949442@narga.sun.ac.za
  adaptation of work done by CreepingGhost, JerK, and Michael Wilson }

{
  Includes procedures and functions to:
    - lock and unlock a surface
    - set pixels
    - get pixels
    - line drawing  (no clipping)
    - generalized PutPixel, GetPixel and Line routines

  this unit utilizes fast assembler routines and datastructures that support
  the creation of fast pixel based graphic effects.
}

{
  Disclaimer:
    - these functions and procedures have only been tested in Delphi 4 -
      to speed up assembler procedure calls, a number of shortcuts have been
      implemented, these may not be compatible with other versions of Delphi
    - procedures and functions for BitDepth 24 have not been tested, though I
      sincerely hope they function as they are supposed to
    - I don't take any responsibility for problems of any sort caused by the
      code in PixelCore. In turn you may use it as free source. Recognition of
      my work would be appreciated though.
}

interface

uses
   Windows, Classes,
{$IfDef StandardDX}
   DirectDraw;
{$Else}
   DirectX;
{$EndIf}

var
   TheSurfaceDesc : TDDSurfaceDesc2;
   LockRect       : TRect;

   pPutPixel : pointer;
   pGetPixel : pointer;
   pLine     : pointer;

function  DXSurfaceLock(Surface : IDirectDrawSurface4; BitsPixel : word) : boolean;
procedure DXSurfaceUnlock(Surface : IDirectDrawSurface4);

procedure SetToBitDepth(BitsPixel : word);

procedure PutPixel(x,y,color : integer);
function  GetPixel(x,y : integer) : integer;
procedure Line(x1,y1,x2,y2,color : integer);

procedure PutPixel8(x,y,color : integer);
procedure PutPixel16(x,y,color : integer);
procedure PutPixel24(x,y,color : integer);
procedure PutPixel32(x,y,color : integer);

function  GetPixel8(x,y : integer) : integer;
function  GetPixel16(x,y : integer) : integer;
function  GetPixel24(x,y : integer) : integer;
function  GetPixel32(x,y : integer) : integer;

procedure Line8(x1,y1,x2,y2,color : integer);
procedure Line16(x1,y1,x2,y2,color : integer);
procedure Line24(x1,y1,x2,y2,color : integer);
procedure Line32(x1,y1,x2,y2,color : integer);

implementation

function DXSurfaceLock(Surface : IDirectDrawSurface4; BitsPixel : word) : boolean;
begin
   Result:=True;
   TheSurfaceDesc.dwSize:=SizeOf(TDDSurfaceDesc);
   if Surface.Lock(nil,TheSurfaceDesc,DDLOCK_SURFACEMEMORYPTR+DDLOCK_WAIT,0)<>DD_OK then Result:=False;
   SetToBitDepth(BitsPixel);
end;

procedure SetToBitDepth(BitsPixel : word);
begin
   case BitsPixel of
      8 : begin pPutPixel:=@PutPixel8;  pGetPixel:=@GetPixel8;  pLine:=@Line8;  end;
     16 : begin pPutPixel:=@PutPixel16; pGetPixel:=@GetPixel16; pLine:=@Line16; end;
     24 : begin pPutPixel:=@PutPixel24; pGetPixel:=@GetPixel24; pLine:=@Line24; end;
     32 : begin pPutPixel:=@PutPixel32; pGetPixel:=@GetPixel32; pLine:=@Line32; end;
   end;
end;

procedure DXSurfaceUnlock(Surface : IDirectDrawSurface4);
begin
   Surface.Unlock(TheSurfaceDesc.lpSurface);
end;

procedure PutPixel(x,y,color : integer);
asm
   call pPutPixel
end;

function  GetPixel(x,y : integer) : integer;
asm
   call pGetPixel
end;

procedure Line(x1,y1,x2,y2,color : integer);
begin
   asm
      mov eax,[y2]                       // must maintain y2 and color across
      push eax                           // CALL operation; x1, y1 and x2 are 
      mov eax,[color]                    // present in eax, edx and ecx
      push eax
      mov eax,[x1]                       // restore x1 to eax
      call pLine                         // call Line procedure
   end;
end;

procedure PutPixel8(x,y,color : integer);
{ on entry:  x = eax,   y = edx,   color = ecx }
asm
   push esi                              // must maintain esi

   mov esi,TheSurfaceDesc.lpSurface      // set to surface
   add esi,eax                           // add x
   mov eax,[TheSurfaceDesc.lpitch]       // eax = pitch
   mul edx                               // eax = pitch * y
   add esi,eax                           // esi = pixel offset

   mov ds:[esi],cl                       // set pixel (lo byte of ecx)

   pop esi                               // restore esi
   ret                                   // return
end;

procedure PutPixel16(x,y,color : integer);
{ on entry:  x = eax,   y = edx,   color = ecx }
asm
   push esi

   mov esi,TheSurfaceDesc.lpSurface
   shl eax,1
   add esi,eax                           // description similar to PutPixel8
   mov eax,[TheSurfaceDesc.lpitch]
   mul edx
   add esi,eax

   mov ds:[esi],cx

   pop esi
   ret
end;

procedure PutPixel24(x,y,color : integer);
{ on entry:  x = eax,   y = edx,   color = ecx }
asm
   push esi

   mov esi,TheSurfaceDesc.lpSurface
   imul eax,3
   add esi,eax                           // description similar to PutPixel8
   mov eax,[TheSurfaceDesc.lpitch]
   mul edx
   add esi,eax

   mov eax,ds:[esi]       // the idea is to get the current pixel
   and eax,$ff000000      // and the top 8 bits of next pixel (red component)
   or  ecx,eax            // then bitwise OR that component to the current color
   mov ds:[esi+1],ecx     // to ensure the prior bitmap isn't incorrectly manipulated
                          // can't test if it works... so hope and pray
   pop esi
   ret
end;

procedure PutPixel32(x,y,color : integer);
{ on entry:  x = eax,   y = edx,   color = ecx }
asm
   push esi

   mov esi,TheSurfaceDesc.lpSurface
   shl eax,2
   add esi,eax                           // description similar to PutPixel8
   mov eax,[TheSurfaceDesc.lpitch]
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

   mov esi,TheSurfaceDesc.lpSurface      // set to surface
   add esi,eax                           // add x
   mov eax,[TheSurfaceDesc.lpitch]       // eax = pitch
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

   mov esi,TheSurfaceDesc.lpSurface
   shl eax,1
   add esi,eax                           // description similar to GetPixel8
   mov eax,[TheSurfaceDesc.lpitch]
   mul edx
   add esi,eax

   mov eax,ds:[esi]
   and eax,$ffff                         // map into 16bit

   pop esi
   ret
end;

function  GetPixel24(x,y : integer) : integer;
{ on entry:  x = eax,   y = edx }
asm
   push esi

   mov esi,TheSurfaceDesc.lpSurface
   imul eax,3
   add esi,ebx                           // description similar to GetPixel8
   mov eax,[TheSurfaceDesc.lpitch]
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

   mov esi,TheSurfaceDesc.lpSurface
   shl eax,2
   add esi,eax                           // description similar to GetPixel8
   mov eax,[TheSurfaceDesc.lpitch]
   mul edx
   add esi,eax

   mov eax,ds:[esi]

   pop esi
   ret
end;

procedure Line8(x1,y1,x2,y2,color : integer);
{ no clipping is performed }
begin
   asm
      push ebx
      push ebp
      push edi
      push esi
      pusha
      mov esi,TheSurfaceDesc.lpSurface
      mov eax,[x1]        // eax = x1
      mov ebx,[x2]        // ebx = x2
      sub ebx,eax         // ebx = x2-x1
      jns @rightOk        // if negative, then swap start/end point
      mov eax,[TheSurfaceDesc.lpitch]    // width of surface
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
      mov eax,[TheSurfaceDesc.lpitch]    // width of surface
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
      mov ebp,[TheSurfaceDesc.lpitch]    // ebp = pitch
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
      mov ecx,edx         // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,ebx         // ecx = -(deltaY)/2 + deltaX
      mov edi,edx         // prepare counter edi (equal to deltaY)
      dec edi             // prevention of single dot crash
      mov ds:[esi],al     // set first pixel
      @loopRUSt:          // loop for Right Up Steep
      or  ecx,ecx         // check spill-element
      js  @skipRUSt       // if signed skip
      sub ecx,edx         // reset spill-element
      inc esi             // vertical step
      @skipRUSt:
      add ecx,ebx         // increase spill-element by deltaX
      sub esi,ebp         // calculate new pixel offset
      mov ds:[esi],al     // set current pixel
      dec edi             // decrement counter
      jns @loopRUSt       // loop until signed
      @ende:
      pop ebp
      popa
      pop esi
      pop edi
      pop ebp
      pop ebx
   end;
end;

procedure Line16(x1,y1,x2,y2,color : integer);
{ no clipping is performed }
begin
   asm
      push ebx
      push ebp
      push edi
      push esi
      pusha
      mov esi,TheSurfaceDesc.lpSurface
      mov eax,[x1]        // eax = x1
      mov ebx,[x2]        // ebx = x2
      sub ebx,eax         // ebx = x2-x1
      jns @rightOk        // if negative, then swap start/end point
      mov eax,[TheSurfaceDesc.lpitch]    // width of surface
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
      mov eax,[TheSurfaceDesc.lpitch]    // width of surface
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
      mov ebp,[TheSurfaceDesc.lpitch]    // ebp = pitch
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
      mov ecx,edx         // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,ebx         // ecx = -(deltaY)/2 + deltaX
      mov edi,edx         // prepare counter edi (equal to deltaY)
      dec edi             // prevention of single dot crash
      mov ds:[esi],ax     // set first pixel
      @loopRUSt:          // loop for Right Up Steep
      or  ecx,ecx         // check spill-element
      js  @skipRUSt       // if signed skip
      sub ecx,edx         // reset spill-element
      add esi,2           // vertical step
      @skipRUSt:
      add ecx,ebx         // increase spill-element by deltaX
      sub esi,ebp         // calculate new pixel offset
      mov ds:[esi],ax     // set current pixel
      dec edi             // decrement counter
      jns @loopRUSt       // loop until signed
      @ende:
      pop ebp
      popa
      pop esi
      pop edi
      pop ebp
      pop ebx
   end;
end;

procedure Line24(x1,y1,x2,y2,color : integer);
{ no clipping is performed }
begin
   asm
      push ebx
      push ebp
      push edi
      push esi
      pusha
      mov esi,TheSurfaceDesc.lpSurface
      mov eax,[x1]        // eax = x1
      mov ebx,[x2]        // ebx = x2
      sub ebx,eax         // ebx = x2-x1
      jns @rightOk        // if negative, then swap start/end point
      mov eax,[TheSurfaceDesc.lpitch]    // width of surface
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
      mov eax,[TheSurfaceDesc.lpitch]    // width of surface
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
      mov ebp,[TheSurfaceDesc.lpitch]    // ebp = pitch
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
      mov ecx,edx         // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,ebx         // ecx = -(deltaY)/2 + deltaX
      mov edi,edx         // prepare counter edi (equal to deltaY)
      dec edi             // prevention of single dot crash
      mov ds:[esi],ax     // set pixel
      ror eax,16
      mov ds:[esi+2],al
      @loopRUSt:          // loop for Right Up Steep
      or  ecx,ecx         // check spill-element
      js  @skipRUSt       // if signed skip
      sub ecx,edx         // reset spill-element
      add esi,3           // vertical step
      @skipRUSt:
      add ecx,ebx         // increase spill-element by deltaX
      sub esi,ebp         // calculate new pixel offset
      mov ds:[esi],ax     // set pixel
      ror eax,16
      mov ds:[esi+2],al
      dec edi             // decrement counter
      jns @loopRUSt       // loop until signed
      @ende:
      pop ebp
      popa
      pop esi
      pop edi
      pop ebp
      pop ebx
   end;
end;

procedure Line32(x1,y1,x2,y2,color : integer);
{ no clipping is performed }
begin
   asm
      push ebx
      push ebp
      push edi
      push esi
      pusha
      mov esi,TheSurfaceDesc.lpSurface
      mov eax,[x1]        // eax = x1
      mov ebx,[x2]        // ebx = x2
      sub ebx,eax         // ebx = x2-x1
      jns @rightOk        // if negative, then swap start/end point
      mov eax,[TheSurfaceDesc.lpitch]    // width of surface
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
      mov eax,[TheSurfaceDesc.lpitch]    // width of surface
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
      mov ebp,[TheSurfaceDesc.lpitch]    // ebp = pitch
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
      mov ecx,edx         // prepare spill-element CX
      shr ecx,1
      neg ecx
      add ecx,ebx         // ecx = -(deltaY)/2 + deltaX
      mov edi,edx         // prepare counter edi (equal to deltaY)
      dec edi             // prevention of single dot crash
      mov ds:[esi],eax    // set first pixel
      @loopRUSt:          // loop for Right Up Steep
      or  ecx,ecx         // check spill-element
      js  @skipRUSt       // if signed skip
      sub ecx,edx         // reset spill-element
      add esi,4           // vertical step
      @skipRUSt:
      add ecx,ebx         // increase spill-element by deltaX
      sub esi,ebp         // calculate new pixel offset
      mov ds:[esi],eax    // set current pixel
      dec edi             // decrement counter
      jns @loopRUSt       // loop until signed
      @ende:
      pop ebp
      popa
      pop esi
      pop edi
      pop ebp
      pop ebx
   end;
end;

end.