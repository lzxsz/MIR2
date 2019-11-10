{

 Pixel DX original version by CreepingHost
       EMAIL: craigd@talk21.com
 Modified by JerK EMAIL : jdelauney@free.fr
 URL : http://www.multimania.fr/jdelauney

}

unit PixelsDX;

interface

uses   
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  DXClass, DXDraws,
{$IfDef StandardDX}
   DirectDraw;
{$Else}
   DirectX;
{$EndIf}


function dxSurfaceLock( Surface: IDirectDrawSurface4; BitsPixel: word ): Boolean;
procedure dxSurfaceUnlock;

function ConvertColor816(idx:integer;dxdraw:tdxdraw):integer;
function ConvertColor2432(idx:integer;dxdraw:tdxdraw):integer;

procedure BlendPixel16(X,Y:Integer;Color:Word;Transparency:Integer);

procedure dxASMPixeloffs16( X: Integer; Color: Integer);

procedure dxASMPixel8( X, Y: Integer; Color: Integer);
procedure dxASMPixel16( X, Y: Integer; Color: Integer);
procedure dxASMPixel24( X, Y: Integer; Color: Integer);
procedure dxASMPixel32( X, Y: Integer; Color: Integer);

procedure dxSetPixel( X, Y: Integer; Color: integer );
function dxGetPixel(x, y: Integer) : integer;
function GetdxPixel(x, y: Integer) : integer;

procedure Fondu(col0, col1, col2 : word; Coeff: byte; Taille: Cardinal);

procedure DXLine(X1,Y1,X2,Y2,color,epaisseur:integer);
PROCEDURE DXCircle(X, Y, Radius,Color: integer);

type
  PRGB = ^TRGB;
  TRGB = packed record
    R, G, B: Byte;
  end;

implementation

var
   TheSurface: IDirectDrawSurface4;
   TheSurfaceDesc: TDDSurfaceDesc2;
   LockRect: TRect;
   xMax, yMax: Integer; // For crude clipping
   BitsPerPixel: word;


function dxSurfaceLock( Surface: IDirectDrawSurface4; BitsPixel: word ): Boolean;
begin
     Result:=True;
     TheSurface:=Surface;
     TheSurfaceDesc.dwSize:=SizeOf( TDDSurfaceDesc );
     LockRect:=Rect(0,0,TheSurfaceDesc.dwWidth,TheSurfaceDesc.dwHeight);

     xMax:=TheSurfaceDesc.dwWidth;
     yMax:=TheSurfaceDesc.dwHeight;

     if TheSurface.Lock(@LockRect, TheSurfaceDesc,
                         DDLOCK_SURFACEMEMORYPTR+DDLOCK_WAIT, 0 )<>DD_OK then Result:=False;

     BitsPerPixel := BitsPixel;
end;

procedure dxSurfaceUnlock;
begin
     TheSurface.Unlock( @LockRect );
     TheSurface:=nil;  // This wasn't in v0.1 and is the reason for the RT Error
end;

function ConvertColor816(idx:integer;dxdraw:tdxdraw):integer;
var tmp,col:integer;
begin
     tmp:=rgb(dxdraw.colortable[idx].rgbred,dxdraw.colortable[idx].rgbgreen,dxdraw.colortable[idx].rgbblue);
     col:=(LoByte(LoWord(tmp)) shr 3 shl 11) or   // Red
          (HiByte(LoWord(tmp)) shr 2 shl 5) or    // Green
          (LoByte(HiWord(tmp)) shr 3);            // Blue
  result:=col;
end;

function ConvertColor2432(idx:integer;dxdraw:tdxdraw):integer;
var tmp,col:integer;
begin
     tmp:=rgb(dxdraw.colortable[idx].rgbred,dxdraw.colortable[idx].rgbgreen,dxdraw.colortable[idx].rgbblue);
     col:=(LoByte(LoWord(tmp)) shl 16) or   // Red
          (HiByte(LoWord(tmp)) shl 8) or    // Green
          (LoByte(HiWord(tmp)));            // Blue
  result:=col;
end;


procedure BlendPixel16(X,Y:Integer;Color:Word;Transparency:Integer);
Var Offs,Mul1,Mul2:Integer;
begin
 Offs:=Integer(TheSurfaceDesc.lpSurface)+TheSurfaceDesc.lpitch*Y+(X shl 1);
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

procedure dxASMPixel8( X, Y: Integer; Color: Integer);assembler;
begin
         asm
            push ebx
            push esi
            push edi

            mov esi,TheSurfaceDesc.lpSurface
            mov eax,[TheSurfaceDesc.lpitch]
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
procedure dxASMPixel16( X, Y: Integer; Color: Integer);assembler;
begin
         asm
            push ebx
            push esi
            push edi

            mov esi,TheSurfaceDesc.lpSurface
            mov eax,[TheSurfaceDesc.lpitch]
            mul [Y]
            add esi,eax
            mov ebx,[X]
            shl ebx,1
            add esi,ebx

            mov ebx,[Color]

            mov ds:[esi],ebx

            pop edi
            pop esi
            pop ebx

         end;
end;

procedure dxASMPixeloffs16( X: Integer; Color: Integer);assembler;
begin
         asm
            push ebx
            push esi
            push edi

            mov esi,TheSurfaceDesc.lpSurface
//            mov eax,[TheSurfaceDesc.lpitch]
//            mul [Y]
//            add esi,eax
            mov ebx,[X]
            shl ebx,1
//            add esi,ebx
            add esi,ebx
            mov ebx,[Color]

            mov ds:[esi],ebx

            pop edi
            pop esi
            pop ebx

         end;
end;
procedure dxASMPixel24( X, Y: Integer; Color: Integer);assembler;
begin
         asm
            push ebx
            push esi
            push edi

            mov esi,TheSurfaceDesc.lpSurface
            mov eax,[TheSurfaceDesc.lpitch]
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

procedure dxASMPixel32( X, Y: Integer; Color: Integer);assembler;
begin
         asm
            push ebx
            push esi
            push edi

            mov esi,TheSurfaceDesc.lpSurface
            mov eax,[TheSurfaceDesc.lpitch]
            mul [Y]
            add esi,eax
            mov ebx,[X]
            shl ebx,2
            add esi,ebx

            mov ebx,[Color]

            mov ds:[esi],ebx

            pop edi
            pop esi
            pop ebx

         end;
end;

Function dxASMGPixel8( X, Y: Integer):integer;assembler;
begin
         asm
            push ebx
            push esi
            push edi

            mov esi,TheSurfaceDesc.lpSurface
            mov eax,[TheSurfaceDesc.lpitch]
            mul [Y]
            add esi,eax
            mov ebx,[X]
            add esi,ebx

            mov eax,ds:[esi]
            ret

            pop edi
            pop esi
            pop ebx

         end;
end;

Function dxASMGPixel16( X, Y: Integer):integer;assembler;
begin
         asm
            push ebx
            push esi
            push edi

            mov esi,TheSurfaceDesc.lpSurface
            mov eax,[TheSurfaceDesc.lpitch]
            mul [Y]
            add esi,eax
            mov ebx,[X]
            shl ebx,1
            add esi,ebx

            mov eax,ds:[esi]
            ret

            pop edi
            pop esi
            pop ebx

         end;
end;

Function dxASMGPixel24( X, Y: Integer):integer;assembler;
begin
         asm
            push ebx
            push esi
            push edi

            mov esi,TheSurfaceDesc.lpSurface
            mov eax,[TheSurfaceDesc.lpitch]
            mul [Y]
            add esi,eax
            mov ebx,[X]
            imul ebx,3
            add esi,ebx

            mov eax,ds:[esi]
            ret

            pop edi
            pop esi
            pop ebx

         end;
end;

Function dxASMGPixel32( X, Y: Integer):integer;assembler;
begin
         asm
            push ebx
            push esi
            push edi

            mov esi,TheSurfaceDesc.lpSurface
            mov eax,[TheSurfaceDesc.lpitch]
            mul [Y]
            add esi,eax
            mov ebx,[X]
            shl ebx,2
            add esi,ebx

            mov eax,ds:[esi]
            ret

            pop edi
            pop esi
            pop ebx

         end;
end;

procedure dxsetpixel(x,y,color:integer);
begin
     case bitsperpixel of
          8:dxasmpixel8(x,y,color);
          16:dxasmpixel16(x,y,color);
          24:dxasmpixel24(x,y,color);
          32:dxasmpixel32(x,y,color);
     end;
end;

function dxGetPixel(x, y: Integer) : integer;
begin
   Result := 0;
     case bitsperpixel of
          8:result:=dxasmgpixel8(x,y);
          16:result:=dxasmgpixel16(x,y);
          24:result:=dxasmgpixel24(x,y);
          32:result:=dxasmgpixel32(x,y);
     end;

end;

procedure dxLine(X1,Y1,X2,Y2,color,epaisseur:integer);
var
 i, deltax, deltay, numpixels,j,k,
 d, dinc1, dinc2,
 x, xinc1, xinc2,
 y, yinc1, yinc2               : Integer;
begin
 { Calculate deltax and deltay for initialisation  }
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
  { y is independent variable     }
  numpixels:=deltay+1;
  d:=(2*deltax)-deltay;
  dinc1:=deltax shl 1;
  dinc2:=(deltax-deltay) shl 1;
  xinc1:=0;
  xinc2:=1;
  yinc1:=1;
  yinc2:=1;
 end;
 { Make sure x and y move in the right directions  }
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
  if (((x>=0) and (x<xMax)) and ((y>=0) and (y<yMax))) then
   for j:=0 to Epaisseur-1 do
    for k:=0 to Epaisseur-1 do
     dxSetPixel(x+j,y+k,Color);
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

PROCEDURE SWAP(VAR A, B : Integer);
Var
  X : Integer;
Begin
  X := A;
  A := B;
  B := X;
End;
// Original from swag by Mike Burns
PROCEDURE DXCircle(X, Y, Radius,Color: integer);
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
      dxsetpixel(x+af,y+b,color);
      dxsetpixel(x+bf,y+a,color);
      dxsetpixel(x-af,y+b,color);
      dxsetpixel(x-bf,y+a,color);
      dxsetpixel(x-af,y-b,color);
      dxsetpixel(x-bf,y-a,color);
      dxsetpixel(x+af,y-b,color);
      dxsetpixel(x+bf,y-a,color);
      B := B + 1;
    End;
    A := A - 1;
  End;
End;

function GetdxPixel(x, y: Integer) : integer;
var
  res: integer;
begin
   Result := 0;
   case Bitsperpixel of
     8:
       result:=PByte(integer(TheSurfaceDesc.lpSurface)+TheSurfaceDesc.lpitch*Y+X)^;
     16:
      begin
       Result:=PWord(integer(TheSurfaceDesc.lpSurface)+TheSurfaceDesc.lpitch*Y + (X shl 1))^;
       res:=((Result and $001F) shl 19) + ((Result and $07E0) shl 5) + (Result and $F800) shr 8;
       result:=res;
      end;
   end;
end;

{
* surface : tu lui transmet la surface a traiter
* col0, col1, col2 : composant Bleu Vert Rouge (respectivement)
                     sachant ke 31 est une intensité maximal et 0 minimal
                    exemple: 31,31,31: blanc
                              0,0,0  : noir
                              31,0,0 : bleu
                              0,31,0 : Vert
                              0,0,31 : Rouge
                              31,31,0: Turkoise
                              0,31,31: Jaune
                              31,0,31: Rose
                              15,15,15: gris ......... etc
* Coeff: Valeur de 0 a 255 ki represente le coefficiant affecté a la couleur
  choisit: 255 = toutes la surface devient de la couleur chosiit
            0  = la surface reste telle kelle

* Taille: Taille de la surface en octet ...
          par exemple, si cet surface est le BackBuffer, ca fait 800*600*2
          si c une image (obligatoirement 16 bits), de taille X=10 et Y=10
          alors on transmet une taille de 10*10*2=200 ......

}


procedure Fondu(col0, col1, col2 : word; Coeff: byte; Taille: Cardinal);
begin
//  TheSurfacedesc.dwSize := SizeOf(TDDSurfaceDesc);
  col0:=coeff*Col0;
  col1:=coeff*Col1;
  col2:=coeff*Col2;

  asm
   push esi
   push edi
   push ebx

   mov edi,TheSurfacedesc.lpSurface
 //  mov esi,[TheSurfaceDesc.lpitch]
   mov esi,taille
   mov cl,255
   sub cl,coeff
   @Boucle:
   xor bx,bx
   mov dx,edi[esi]
///////////////////
   mov ax,dx
   and ax,31
   mul cl
   add ax,col0
   mov bl,ah
///////////////////
   mov ax,dx
   shr ax,5
   and ax,31
   mul cl
   add ax,col1
   shr ax,8
   shl ax,5
   add bx,ax
///////////////////
   mov ax,dx
   shr ax,10
   and ax,31
   mul cl
   add ax,col2
   shr ax,8
   shl ax,10
   add bx,ax
///////////////////
   mov edi[esi],bx
   sub esi,2
   jnz @Boucle

   pop ebx
   pop edi
   pop esi

  end;
end;

end.
