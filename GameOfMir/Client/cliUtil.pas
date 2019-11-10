unit cliUtil;
//¹¤¾ß¿â:Ö÷ÒªÌá¹©Ò»Ð©Í¼ÐÎ²Ù×÷º¯Êý
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, WIL, Grobal2, StdCtrls, DirectX, DIB, HUtil32,
  wmutil; //, bmputil;


const
   MAXGRADE = 64;
   DIVUNIT = 4;


type
  TColorEffect = (ceNone, ceGrayScale, ceBright, ceBlack, ceWhite, ceRed, ceGreen, ceBlue, ceYellow, ceFuchsia);

  TNearestIndexHeader = record
    Title: string[30];
    IndexCount: integer;
    desc: array[0..10] of byte;
  end;

function  HasMMX: Boolean;
procedure BuildColorLevels (ctable: TRGBQuads);
procedure BuildNearestIndex (ctable: TRGBQuads);
procedure SaveNearestIndex (flname: string);
function  LoadNearestIndex (flname: string): Boolean;
procedure DrawFog (ssuf: TDirectDrawSurface; fogmask: PByte; fogwidth: integer);
procedure DrawFog2 (ssuf: TDirectDrawSurface; fogmask: PByte; fogwidth: integer);
procedure MakeDark (ssuf: TDirectDrawSurface; darklevel: integer);
procedure FogCopy (PSource: Pbyte; ssx, ssy, swidth, sheight: integer;
                   PDest: Pbyte; ddx, ddy, dwidth, dheight, maxfog: integer);
procedure DrawBlend (dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; blendmode: integer);
procedure DrawBlendEx (dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; ssufleft, ssuftop, ssufwidth, ssufheight, blendmode: integer);
procedure   SpriteCopy(DestX, DestY : integer;
                       SourX, SourY : integer;
                       Size         : TPoint;
                       Sour, Dest   : TDirectDrawSurface);
procedure MMXBlt (ssuf, dsuf: TDirectDrawSurface);
procedure DrawEffect (x, y, width, height: integer; ssuf: TDirectDrawSurface; eff: TColorEffect);
procedure DrawLine(Surface: TDirectDrawSurface);

var
   DarkLevel : integer;


implementation

uses Share;

var
  RgbIndexTable: array[0..MAXGRADE-1, 0..MAXGRADE-1, 0..MAXGRADE-1] of byte;
  Color256Mix: array[0..255, 0..255] of byte;
  Color256Anti: array[0..255, 0..255] of byte;
  HeavyDarkColorLevel: array[0..255, 0..255] of byte;
  LightDarkColorLevel: array[0..255, 0..255] of byte;
  DengunColorLevel: array[0..255, 0..255] of byte;
  BrightColorLevel: array[0..255] of byte;
  GrayScaleLevel: array[0..255] of byte;
  RedishColorLevel: array[0..255] of byte;
  BlackColorLevel: array[0..255] of byte;
  WhiteColorLevel: array[0..255] of byte;
  GreenColorLevel: array[0..255] of byte;
  YellowColorLevel: array[0..255] of byte;
  BlueColorLevel: array[0..255] of byte;
  FuchsiaColorLevel: array[0..255] of byte;

//ÅÐ¶Ï»úÆ÷ÊÇ·ñÓÐMMX¹¦ÄÜ
function  HasMMX: Boolean;
var
   n: byte;
begin
   asm
      mov   eax, 1
      db $0F,$A2               /// CPUID
      test  edx, 00800000H
      mov   n, 1
      jnz   @@Found
      mov   n, 0
   @@Found:
   end;
   if n = 1 then Result := TRUE
   else Result := FALSE;
end;

procedure BuildNearestIndex (ctable: TRGBQuads);
var
   r, g, b, rr, gg, bb, color, MinDif, ColDif: Integer;
   MatchColor: Byte;
   pal0, pal1, pal2: TRGBQuad;
   //µ÷É«°å»ìºÏ256X256
   procedure BuildMix;
   var
      i, j, n: integer;
   begin
      for i:=0 to 255 do begin
         pal0 := ctable[i];
         for j:=0 to 255 do begin
            pal1 := ctable[j];
            pal1.rgbRed := pal0.rgbRed div 2 + pal1.rgbRed div 2;
            pal1.rgbGreen := pal0.rgbGreen div 2 + pal1.rgbGreen div 2;
            pal1.rgbBlue := pal0.rgbBlue div 2 + pal1.rgbBlue div 2;
            MinDif := 768;
            MatchColor := 0;
            for n:=0 to 255 do begin
               pal2 := ctable[n];
               ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                         Abs(pal2.rgbGreen - pal1.rgbGreen) +
                         Abs(pal2.rgbBlue - pal1.rgbBlue);
               if ColDif < MinDif then begin
                  MinDif := ColDif;
                  MatchColor := n;
               end;
            end;
            Color256Mix[i, j] := MatchColor;
         end;
      end;
   end;
   //µ÷É«°å¶¯»­ÑÕÉ«±í256X256
   procedure BuildAnti;
   var
      i, j, n, ever: integer;
   begin
      for i:=0 to 255 do begin
         pal0 := ctable[i];
         for j:=0 to 255 do begin
            pal1 := ctable[j];
            ever := _MAX(pal0.rgbRed, pal0.rgbGreen);
            ever := _MAX(ever, pal0.rgbBlue);
//            pal1.rgbRed := _MIN(255, Round (pal0.rgbRed  + (255-ever)/255 * pal1.rgbRed));
//            pal1.rgbGreen := _MIN(255, Round (pal0.rgbGreen  + (255-ever)/255 * pal1.rgbGreen));
//         pal1.rgbBlue := _MIN(255, Round (pal0.rgbBlue  + (255-ever)/255 * pal1.rgbBlue));
            pal1.rgbRed := _MIN(255, Round (pal0.rgbRed  + (255-pal0.rgbRed)/255 * pal1.rgbRed));
            pal1.rgbGreen := _MIN(255, Round (pal0.rgbGreen  + (255-pal0.rgbGreen)/255 * pal1.rgbGreen));
            pal1.rgbBlue := _MIN(255, Round (pal0.rgbBlue  + (255-pal0.rgbBlue)/255 * pal1.rgbBlue));
            MinDif := 768;
            MatchColor := 0;
            for n:=0 to 255 do begin
               pal2 := ctable[n];
               ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                         Abs(pal2.rgbGreen - pal1.rgbGreen) +
                         Abs(pal2.rgbBlue - pal1.rgbBlue);
               if ColDif < MinDif then begin
                  MinDif := ColDif;
                  MatchColor := n;
               end;
            end;
            Color256Anti[i, j] := MatchColor;
         end;
      end;
   end;
   //»Ò½×ÑÕÉ«±í256X256
   procedure BuildColorLevels;
   var
      n, i, j, rr, gg, bb: integer;
   begin
      for n:=0 to 30 do begin
         for i:=0 to 255 do begin
            pal1 := ctable[i];
            rr := _MIN(Round(pal1.rgbRed * (n+1) / 31) - 5, 255);      //(n + (n-1)*3) / 121);
            gg := _MIN(Round(pal1.rgbGreen * (n+1) / 31) - 5, 255);  //(n + (n-1)*3) / 121);
            bb := _MIN(Round(pal1.rgbBlue * (n+1) / 31) - 5, 255);    //(n + (n-1)*3) / 121);
            pal1.rgbRed := _MAX(0, rr);
            pal1.rgbGreen := _MAX(0, gg);
            pal1.rgbBlue := _MAX(0, bb);
            MinDif := 768;
            MatchColor := 0;
            for j:=0 to 255 do begin
               pal2 := ctable[j];
               ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                         Abs(pal2.rgbGreen - pal1.rgbGreen) +
                         Abs(pal2.rgbBlue - pal1.rgbBlue);
               if ColDif < MinDif then begin
                  MinDif := ColDif;
                  MatchColor := j;
               end;
            end;
            HeavyDarkColorLevel[n, i] := MatchColor;
         end;
      end;
      for n:=0 to 30 do begin
         for i:=0 to 255 do begin
            pal1 := ctable[i];
            pal1.rgbRed := _MIN(Round(pal1.rgbRed * (n*3+47) / 140), 255);
            pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * (n*3+47) / 140), 255);
            pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * (n*3+47) / 140), 255);
            MinDif := 768;
            MatchColor := 0;
            for j:=0 to 255 do begin
               pal2 := ctable[j];
               ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                         Abs(pal2.rgbGreen - pal1.rgbGreen) +
                         Abs(pal2.rgbBlue - pal1.rgbBlue);
               if ColDif < MinDif then begin
                  MinDif := ColDif;
                  MatchColor := j;
               end;
            end;
            LightDarkColorLevel[n, i] := MatchColor;
         end;
      end;
      for n:=0 to 30 do begin
         for i:=0 to 255 do begin
            pal1 := ctable[i];
            pal1.rgbRed := _MIN(Round(pal1.rgbRed * (n*3+120) / 214), 255);
            pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * (n*3+120) / 214), 255);
            pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * (n*3+120) / 214), 255);
            MinDif := 768;
            MatchColor := 0;
            for j:=0 to 255 do begin
               pal2 := ctable[j];
               ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                         Abs(pal2.rgbGreen - pal1.rgbGreen) +
                         Abs(pal2.rgbBlue - pal1.rgbBlue);
               if ColDif < MinDif then begin
                  MinDif := ColDif;
                  MatchColor := j;
               end;
            end;
            DengunColorLevel[n, i] := MatchColor;
         end;
      end;

      {for i:=0 to 255 do begin
         HeavyDarkColorLevel[0, i] := HeavyDarkColorLevel[1, i];
         LightDarkColorLevel[0, i] := LightDarkColorLevel[1, i];
         DengunColorLevel[0, i] := DengunColorLevel[1, i];
      end;}
      for n:=31 to 255 do
         for i:=0 to 255 do begin
            HeavyDarkColorLevel[n, i] := HeavyDarkColorLevel[30, i];
            LightDarkColorLevel[n, i] := LightDarkColorLevel[30, i];
            DengunColorLevel[n, i] := DengunColorLevel[30, i];
         end;

   end;
begin
   BuildMix;
   BuildAnti;
   BuildColorLevels;
end;

procedure BuildColorLevels (ctable: TRGBQuads);
var
   n, i, j, MinDif, ColDif: integer;
   pal1, pal2: TRGBQuad;
   MatchColor: byte;
begin
   BrightColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      pal1.rgbRed := _MIN(Round(pal1.rgbRed * 1.3), 255);
      pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * 1.3), 255);
      pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * 1.3), 255);
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      BrightColorLevel[i] := MatchColor;
   end;
   GrayScaleLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
      pal1.rgbRed := n; //Round(pal1.rgbRed * (n*3+25) / 118);
      pal1.rgbGreen := n; //Round(pal1.rgbGreen * (n*3+25) / 118);
      pal1.rgbBlue := n; //Round(pal1.rgbBlue * (n*3+25) / 118);
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      GrayScaleLevel[i] := MatchColor;
   end;
   BlackColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      n := Round ((pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) / 3 * 0.6);
      pal1.rgbRed := n; //_MAX(8, Round(pal1.rgbRed * 0.7));
      pal1.rgbGreen := n; //_MAX(8, Round(pal1.rgbGreen * 0.7));
      pal1.rgbBlue := n; //_MAX(8, Round(pal1.rgbBlue * 0.7));
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      BlackColorLevel[i] := MatchColor;
   end;
   WhiteColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      n := _MIN (Round ((pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) / 3 * 1.6), 255);
      pal1.rgbRed := n; //_MAX(8, Round(pal1.rgbRed * 0.7));
      pal1.rgbGreen := n; //_MAX(8, Round(pal1.rgbGreen * 0.7));
      pal1.rgbBlue := n; //_MAX(8, Round(pal1.rgbBlue * 0.7));
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      WhiteColorLevel[i] := MatchColor;
   end;
   RedishColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
      pal1.rgbRed := n;
      pal1.rgbGreen := 0;
      pal1.rgbBlue := 0;
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      RedishColorLevel[i] := MatchColor;
   end;
   GreenColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      //n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 5;
      //pal1.rgbRed := 0;//_MIN(Round(n / 2), 255);
      //pal1.rgbGreen := _MIN(Round(n), 255);
      //pal1.rgbBlue := 0;//_MIN(Round(n / 2), 255);
      n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
      pal1.rgbRed := 0;
      pal1.rgbGreen := n;
      pal1.rgbBlue := 0;
      //pal1.rgbRed := _MIN(Round (pal1.rgbRed / 3), 255);
      //pal1.rgbGreen := _MIN(Round (pal1.rgbGreen * 1.5), 255);
      //pal1.rgbBlue := _MIN(Round (pal1.rgbBlue / 3), 255);
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      GreenColorLevel[i] := MatchColor;
   end;
   YellowColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
      pal1.rgbRed := n;
      pal1.rgbGreen := n;
      pal1.rgbBlue := 0;
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      YellowColorLevel[i] := MatchColor;
   end;
   BlueColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      //n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 5;
      n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
      pal1.rgbRed := 0; //_MIN(Round(n*1.3), 255);
      pal1.rgbGreen := 0; //_MIN(Round(n), 255);
      pal1.rgbBlue := n; //_MIN(Round(n*1.3), 255);
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      BlueColorLevel[i] := MatchColor;
   end;
   FuchsiaColorLevel[0] := 0;
   for i:=1 to 255 do begin
      pal1 := ctable[i];
      n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
      pal1.rgbRed := n;
      pal1.rgbGreen := 0;
      pal1.rgbBlue := n;
      MinDif := 768;
      MatchColor := 0;
      for j:=1 to 255 do begin
         pal2 := ctable[j];
         ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
                   Abs(pal2.rgbGreen - pal1.rgbGreen) +
                   Abs(pal2.rgbBlue - pal1.rgbBlue);
         if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
         end;
      end;
      FuchsiaColorLevel[i] := MatchColor;
   end;
end;

//±£´æ¼¸¸öÑÕÉ«±íµ½ÎÄ¼þ
procedure SaveNearestIndex (flname: string);
var
   nih: TNearestIndexHeader;
   fhandle: integer;
begin
   nih.Title := 'WEMADE Entertainment Inc.';
   nih.IndexCount := Sizeof(Color256Mix);
   if FileExists (flname) then begin
      fhandle := FileOpen (flname, fmOpenWrite or fmShareDenyNone);
   end else
      fhandle := FileCreate (flname);
   if fhandle > 0 then begin
      FileWrite (fhandle, nih, sizeof(TNearestIndexHeader));
      FileWrite (fhandle, Color256Mix, sizeof(Color256Mix));
      FileWrite (fhandle, Color256Anti, sizeof(Color256Anti));
      FileWrite (fhandle, HeavyDarkColorLevel, sizeof(HeavyDarkColorLevel));
      FileWrite (fhandle, LightDarkColorLevel, sizeof(LightDarkColorLevel)); 
      FileWrite (fhandle, DengunColorLevel, sizeof(DengunColorLevel));
      FileClose (fhandle);
   end;
end;
//´ÓÎÄ¼þÖÐ¶ÁÈ¡¼¸¸öÑÕÉ«±í
function LoadNearestIndex (flname: string): Boolean;
var
   nih: TNearestIndexHeader;
   fhandle, rsize: integer;
begin
   Result := FALSE;
   if FileExists (flname) then begin
      fhandle := FileOpen (flname, fmOpenRead or fmShareDenyNone);
      if fhandle > 0 then begin
         FileRead (fhandle, nih, sizeof(TNearestIndexHeader));
         if nih.IndexCount = Sizeof(Color256Mix) then begin
            Result := TRUE;
            rsize := 256*256;
            if rsize <> FileRead (fhandle, Color256Mix, sizeof(Color256Mix)) then Result := FALSE;
            if rsize <> FileRead (fhandle, Color256Anti, sizeof(Color256Anti)) then Result := FALSE;
            if rsize <> FileRead (fhandle, HeavyDarkColorLevel, sizeof(HeavyDarkColorLevel)) then Result := FALSE;
            if rsize <> FileRead (fhandle, LightDarkColorLevel, sizeof(LightDarkColorLevel)) then Result := FALSE;
            if rsize <> FileRead (fhandle, DengunColorLevel, sizeof(DengunColorLevel)) then Result := FALSE;
         end;
         FileClose (fhandle);
      end;
   end;
end;
//Éú³ÉÎíµÄÐ§¹û
procedure FogCopy (PSource: Pbyte; ssx, ssy, swidth, sheight: integer;
                   PDest: Pbyte; ddx, ddy, dwidth, dheight, maxfog: integer);
var
   i, j, n, k, row, srclen, scount, si, di, srcheight, spitch, dpitch: integer;
   sptr, dptr: PByte;
begin
   if (PSource = nil) or (pDest = nil) then exit; 
   spitch := swidth;
   dpitch := dwidth;
   if ddx < 0 then begin
      ssx := ssx - ddx;
      swidth := swidth + ddx;
      //dwidth := dwidth + ddx;
      ddx := 0;
   end;
   if ddy < 0 then begin
      ssy := ssy - ddy;
      sheight := sheight + ddy;
      //dheight := dheight + ddy;
      ddy := 0;
   end;
   //if ssx+swidth > dwidth then swidth := dwidth - ssx;
   //if ssy+sheight > dheight then sheight := dheight - ssy;
   srclen := _MIN(swidth, dwidth-ddx);
   srcheight := _MIN(sheight, dheight-ddy);
   if (srclen <= 0) or (srcheight <= 0) then exit;

   asm
         mov   row, 0
      @@NextRow:
         mov   eax, row
         cmp   eax, srcheight
         jae   @@Finish

         mov   esi, psource
         mov   eax, ssy
         add   eax, row
         mov   ebx, spitch
         imul  eax, ebx
         add   eax, ssx
         add   esi, eax          //sptr

         mov   edi, pdest
         mov   eax, ddy
         add   eax, row
         mov   ebx, dpitch
         imul  eax, ebx
         add   eax, ddx
         add   edi, eax          //dptr

         mov   ebx, srclen
      @@FogNext:
         cmp   ebx, 0
         jbe   @@FinOne
         cmp   ebx, 8
         jb    @@FinOne   //@@EageNext

         db $0F,$6F,$06           /// movq  mm0, [esi]
         db $0F,$6F,$0F           /// movq  mm1, [edi]
         db $0F,$FE,$C8           /// paddd mm1, mm0
         db $0F,$7F,$0F           /// movq [edi], mm1

         sub   ebx, 8
         add   esi, 8
         add   edi, 8
         jmp   @@FogNext
      {@@EageNext:
         movzx eax, [esi].byte
         movzx ecx, [edi].byte
         add   eax, ecx
         mov   [edi].byte, al

         dec   ebx
         inc   esi
         inc   edi
         jmp   @@FogNext }
      @@FinOne:
         inc   row
         jmp   @@NextRow

      @@Finish:
         db $0F,$77               /// emms
   end;
end;
//ÏÔÊ¾ÎíÐ§¹û
procedure DrawFog (ssuf: TDirectDrawSurface; fogmask: PByte; fogwidth: integer);
var
   i, j, idx, row, n, count: integer;
   ddsd: TDDSurfaceDesc;
   sptr, mptr, pmix: PByte;
   //source: array[0..910] of byte;
   bitindex, scount, dcount, srclen, destlen, srcheight: integer;
   lpitch: integer;
   src, msk: array[0..7] of byte;
   pSrc, psource, pColorLevel: Pbyte;
begin
   if ssuf.Width > SCREENWIDTH + 100 then exit;
//   if ssuf.Width > 900 then exit;
   case DarkLevel of
      1: pColorLevel := @HeavyDarkColorLevel; //ÉîÒ¹
      2: pColorLevel := @LightDarkColorLevel;  //ÖÐµÈÁÁ¶È
      3: pColorLevel := @DengunColorLevel;     //ÖÐÎç
      else exit;
   end;

   try
      ddsd.dwSize := SizeOf(ddsd);
      ssuf.Lock (TRect(nil^), ddsd);
      srclen := _MIN(ssuf.Width, fogwidth);
      pSrc := @src;
      srcheight := ssuf.Height;
      lpitch := ddsd.lPitch;
      psource := ddsd.lpSurface;

      asm
            mov   row, 0
         @@NextRow:
            mov   ebx, row
            mov   eax, srcheight
            cmp   ebx, eax
            jae   @@DrawFogFin

            mov   esi, psource      //esi = ddsd.lpSurface;
            mov   eax, lpitch
            mov   ebx, row
            imul  eax, ebx
            add   esi, eax

            mov   edi, fogmask      //edi = fogmask
            mov   eax, fogwidth
            mov   ebx, row
            imul  eax, ebx
            add   edi, eax

            mov   ecx, srclen
            mov   edx, pColorLevel

         @@NextByte:
            cmp   ecx, 0
            jbe   @@Finish

            movzx eax, [edi].byte   //fogmask
            ///cmp   eax, 30
            ///ja    @@SkipByte
            imul  eax, 256
            movzx ebx, [esi].byte   //¼Ò½º ddsd.lpSurface;
            add   eax, ebx
            mov   al, [edx+eax].byte //pColorLevel
            mov   [esi].byte, al
         ///@@SkipByte:
            dec   ecx
            inc   esi
            inc   edi
            jmp   @@NextByte

         @@Finish:
            inc   row
            jmp   @@NextRow

         @@DrawFogFin:
            db $0F,$77               /// emms
      end;
   finally
      ssuf.UnLock();
   end;
end;

procedure DrawFog2 (ssuf: TDirectDrawSurface; fogmask: PByte; fogwidth: integer);
var
   i, j, n, scount, srclen, offsvalue: integer;
   sddsd: TDDSurfaceDesc;
   sptr, fptr, pColorLevel: Pbyte;
   source: array[0..810] of byte;
begin
   if ssuf.Width > SCREENWIDTH then exit;
//   if ssuf.Width > 800 then exit;
   try
      sddsd.dwSize := SizeOf(sddsd);
      ssuf.Lock (TRect(nil^), sddsd);
      srclen := _MIN(ssuf.Width, fogwidth);
      case DarkLevel of
         0: pColorLevel := @HeavyDarkColorLevel;
         1: pColorLevel := @LightDarkColorLevel;
         2: pColorLevel := @DengunColorLevel;
      end;
      for i:=0 to ssuf.height-1 do begin
         sptr := PBYTE(integer(sddsd.lpSurface) + i*sddsd.lPitch);
         fptr := PBYTE(integer(fogmask) + i*fogwidth);
         asm
               mov   scount, 0
               mov   esi, sptr
               lea   edi, source
            @@CopySource:
               mov   ebx, scount        //ebx = scount
               cmp   ebx, srclen
               jae   @@EndSourceCopy
               db $0F,$6F,$04,$1E       /// movq  mm0, [esi+ebx]
               db $0F,$7F,$07           /// movq  [edi], mm0

               xor   ebx, ebx
            @@Loop8:
               cmp   ebx, 8
               jz    @@EndLoop8
               mov   ecx, fptr
               add   ecx, scount
               add   ecx, ebx
               movzx eax, [ecx].byte
               cmp   eax, 30
               jae   @@Skip
               imul  eax, 256
               mov   ecx, eax


               movzx eax, [edi+ebx].byte
               mov   edx, pColorLevel
               add   edx, ecx
               movzx eax, [edx+eax].byte     //
               mov   [edi+ebx], al
            @@Skip:
               inc   ebx
               jmp   @@Loop8
            @@EndLoop8:

               mov   ebx, scount
               db $0F,$6F,$07           /// movq  mm0, [edi]
               db $0F,$7F,$04,$1E       /// movq  [esi+ebx], mm0

               add   edi, 8
               add   scount, 8
               jmp   @@CopySource
            @@EndSourceCopy:
               db $0F,$77               /// emms

         end;
      end;
   finally
      ssuf.UnLock();
   end;

end;


procedure MakeDark (ssuf: TDirectDrawSurface; darklevel: integer);
var
   i, j, idx, row, n, count: integer;
   ddsd: TDDSurfaceDesc;
   sptr, mptr, pmix: PByte;
   //source: array[0..910] of byte;
   bitindex, scount, dcount, srclen, destlen, srcheight: integer;
   lpitch: integer;
   src, msk: array[0..7] of byte;
   pSrc, psource, pColorLevel: Pbyte;
begin
   if not darklevel in [1..30] then exit;
   if ssuf.Width > SCREENWIDTH + 100 then exit;
//   if ssuf.Width > 900 then exit;
   try
      ddsd.dwSize := SizeOf(ddsd);
      ssuf.Lock (TRect(nil^), ddsd);
      srclen := ssuf.Width;
      srcheight := ssuf.Height;
      pSrc := @src;
      //if HeavyDark then pColorLevel := @HeavyDarkColorLevel
      //else pColorLevel := @LightDarkColorLevel;
      pColorLevel := @HeavyDarkColorLevel;
      lpitch := ddsd.lPitch;
      psource := ddsd.lpSurface;

      asm
            mov   row, 0
         @@NextRow:
            mov   ebx, row
            mov   eax, srcheight
            cmp   ebx, eax
            jae   @@DrawFogFin

            mov   esi, psource      //sptr
            mov   eax, lpitch
            mov   ebx, row
            imul  eax, ebx
            add   esi, eax

            mov   eax, srclen
            mov   scount, eax
         @@FogNext:
            mov   edx, pSrc     //pSrc = array[0..7]
            mov   ebx, scount
            cmp   ebx, 0
            jbe   @@Finish
            cmp   ebx, 8
            jb    @@FogSmall

            db $0F,$6F,$06           /// movq  mm0, [esi]       //8¹ÙÀÌÆ® ÀÐÀ½ sptr
            db $0F,$7F,$02           /// movq  [edx], mm0
            mov   count, 8

          @@LevelChange:
            mov   eax, darklevel
            imul  eax, 256
            movzx ebx, [edx].byte   //8¹ÙÀÌÆ® ¹­À½À¸·Î ÀÐÀº µ¥ÀÌÅÍ
            add   eax, ebx
            mov   ebx, pColorLevel
            mov   al, [ebx+eax].byte
            mov   [edx].byte, al

         @@Skip1:
            dec   count
            inc   edx
            inc   edi
            cmp   count, 0
            ja    @@LevelChange
            sub   edx, 8

            db $0F,$6F,$02           /// movq  mm0, [edx]
            db $0F,$7F,$06           /// movq  [esi], mm0
         @@Skip_8Byte:
            sub   scount, 8
            add   esi, 8
            jmp   @@FogNext

         @@FogSmall:
            mov   eax, darklevel
            imul  eax, 256
            movzx ebx, [edx].byte
            add   eax, ebx
            mov   ebx, pColorLevel
            mov   al, [ebx+eax].byte
            mov   [esi].byte, al

         @@Skip2:
            inc   edi
            inc   esi
            dec   scount
            jmp   @@FogNext

         @@Finish:
            inc   row
            jmp   @@NextRow

         @@DrawFogFin:
            db $0F,$77               /// emms
      end;
   finally
      ssuf.UnLock();
   end;
end;

//ssuf(system memory) -> dsuf(video memory)  : ÀÌ¶§¸¸ »ç¿ëÇÒ °Í
//³ÐÀÌ´Â 8ÀÇ ¹è¼ö
procedure MMXBlt (ssuf, dsuf: TDirectDrawSurface);
var
   n, m, aheight, awidth, spitch, dpitch: integer;
   sddsd, dddsd: TDDSurfaceDesc;
   sptr, dptr: PByte;
begin
   try
      sddsd.dwSize := SizeOf(sddsd);
      ssuf.Lock (TRect(nil^), sddsd);
      dddsd.dwSize := Sizeof(dddsd);
      dsuf.Lock (TRect(nil^), dddsd);
      aheight := ssuf.Height-1;
      awidth := ssuf.Width-1;
      spitch := sddsd.lPitch;
      dpitch := dddsd.lPitch;
      sptr := sddsd.lpSurface; //esi
      dptr := dddsd.lpSurface; //edi
      m := -1; //height
      asm
       @@NextLine:
         inc   m
         mov   eax, m
         cmp   eax, aheight
         jae   @@End
         //sptr
         mov   esi, sptr
         mov   ebx, spitch
         imul  eax, ebx
         add   esi, eax
         //dptr
         mov   eax, m
         mov   edi, dptr
         mov   ebx, dpitch
         imul  eax, ebx
         add   edi, eax

         xor   eax, eax
       @@CopyNext:
         cmp   eax, awidth
         jae   @@NextLine

         db $0F,$6F,$04,$06       /// movq  mm0, [esi+eax]
         db $0F,$7F,$04,$07       /// movq  [edi+eax], mm0

         add   eax, 8
         jmp   @@CopyNext

       @@End:
         db $0F,$77               /// emms
      end;
   finally
      ssuf.UnLock();
      dsuf.UnLock();
   end;
end;

//ssurface + dsurface => dsurface
procedure DrawBlend (dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; blendmode: integer);
begin
   DrawBlendEx (dsuf, x, y, ssuf, 0, 0, ssuf.Width, ssuf.Height, blendmode);
end;

//ssurface + dsurface => dsurface
procedure DrawBlendEx (dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; ssufleft, ssuftop, ssufwidth, ssufheight, blendmode: integer);
var
   i, j, srcleft, srctop, srcwidth, srcbottom, sidx, didx: integer;
   sddsd, dddsd: TDDSurfaceDesc;
   sptr, dptr, pmix: PByte;
   source, dest: array[0..910] of byte;
   bitindex, scount, dcount, srclen, destlen, wcount, awidth, bwidth: integer;
begin
   if (dsuf.canvas = nil) or (ssuf.canvas = nil) then exit;
   if x >= dsuf.Width then exit;
   if y >= dsuf.Height then exit;
   if x < 0 then begin
      srcleft := -x;
      srcwidth := ssufwidth + x;
      x := 0;
   end else begin
      srcleft := ssufleft;
      srcwidth := ssufwidth;
   end;
   if y < 0 then begin
      srctop := -y;
      srcbottom := ssufheight;
      y := 0;
   end else begin
      srctop := ssuftop;
      srcbottom := srctop + ssufheight;
   end;
   if srcleft + srcwidth > ssuf.Width then srcwidth := ssuf.Width-srcleft;
   if srcbottom > ssuf.Height then
      srcbottom := ssuf.Height;//-srcheight;
   if x + srcwidth > dsuf.Width then srcwidth := (dsuf.Width-x) div 4 * 4;
   if y + srcbottom - srctop > dsuf.Height then
      srcbottom := dsuf.Height-y+srctop;
   if (x+srcwidth) * (y+srcbottom-srctop) > dsuf.Width * dsuf.Height then //ÀÓ½Ã..
      srcbottom := srctop + (srcbottom-srctop) div 2;

   if (srcwidth <= 0) or (srcbottom <= 0) or (srcleft >= ssuf.Width) or (srctop >= ssuf.Height) then exit;
//   if srcWidth > 900 then exit;
   if srcWidth > SCREENWIDTH + 100 then exit;
   try
      sddsd.dwSize := SizeOf(sddsd);
      dddsd.dwSize := SizeOf(dddsd);
      ssuf.Lock (TRect(nil^), sddsd);
      dsuf.Lock (TRect(nil^), dddsd);
      awidth := srcwidth div 4; //ssuf.Width div 4;
      bwidth := srcwidth; //ssuf.Width;
      srclen := srcwidth; //ssuf.Width;
      destlen := srcwidth; //ssuf.Width;
      case blendmode of
         0: pmix := @Color256Mix[0,0];
         else pmix := @Color256Anti[0,0];
      end;
      for i:=srctop to srcbottom-1 do begin
         sptr := PBYTE(integer(sddsd.lpSurface) + sddsd.lPitch * i + srcleft);
         dptr := PBYTE(integer(dddsd.lpSurface) + (y+i-srctop) * dddsd.lPitch + x);
         asm
               mov   scount, 0
               mov   esi, sptr
               lea   edi, source
               mov   ebx, scount        //ebx = scount
            @@CopySource:
               cmp   ebx, srclen
               jae    @@EndSourceCopy
               db $0F,$6F,$04,$1E       /// movq  mm0, [esi+ebx]
               db $0F,$7F,$04,$1F       /// movq  [edi+ebx], mm0
               add   ebx, 8
               jmp   @@CopySource
            @@EndSourceCopy:

               mov   dcount, 0
               mov   esi, dptr
               lea   edi, dest
               mov   ebx, dcount
            @@CopyDest:
               cmp   ebx, destlen
               jae    @@EndDestCopy
               db $0F,$6F,$04,$1E       /// movq  mm0, [esi+ebx]
               db $0F,$7F,$04,$1F       /// movq  [edi+ebx], mm0
               add   ebx, 8
               jmp   @@CopyDest
            @@EndDestCopy:

               lea   esi, source
               lea   edi, dest
               mov   wcount, 0

            @@BlendNext:
               mov   ebx, wcount
               cmp   [esi+ebx].byte, 0     //if _src[bitindex] > 0
               jz    @@EndBlend

               movzx eax, [esi+ebx].byte     //sidx := _src[bitindex]
               shl   eax, 8                  //sidx * 256
               mov   sidx, eax

               movzx eax, [edi+ebx].byte     //didx := _dest[bitindex]
               add   sidx, eax

               mov   edx, pmix
               mov   ecx, sidx
               movzx eax, [edx+ecx].byte     //
               mov   [edi+ebx], al

            @@EndBlend:
               inc   wcount
               mov   eax, bwidth
               cmp   wcount, eax
               jb    @@BlendNext

               lea   esi, dest               //Move (_src, dptr^, 4)
               mov   edi, dptr
               mov   ecx, awidth
               cld
               rep movsd

         end;
      end;
      asm
         db $0F,$77               /// emms
      end;

   finally
      ssuf.UnLock();
      dsuf.UnLock();
   end;
end;

procedure   SpriteCopy(DestX, DestY : integer;
                       SourX, SourY : integer;
                       Size         : TPoint;
                       Sour, Dest   : TDirectDrawSurface);
const
   TRANSPARENCY_VALUE  = 0; // Í¸Ã÷É«£¬ÕâÀï×ÜÊÇÓÃºÚÉ«.
var
   SourDesc, DestDesc  : TDDSurfaceDesc;
   pSour, pDest, pMask : PByte;
   Transparency        : array[1..8] of byte;
begin
   FillChar(Transparency,8,TRANSPARENCY_VALUE);

   SourDesc.dwSize := SizeOf(SourDesc);
   Sour.Lock (TRect(nil^), SourDesc);
   DestDesc.dwSize := SizeOf(DestDesc);
   Dest.Lock (TRect(nil^), DestDesc);

//   pSour := PByte(DWORD(SourDesc.lpSurface)+SourY*SourDesc.lPitch+SourX);
//   pDest := PByte(DWORD(DestDesc.lpSurface)+DestY*DestDesc.lPitch+DestX);
//Jacky
   pSour := PByte(DWORD(SourDesc.lpSurface)+Byte(SourY*SourDesc.lPitch+SourX));
   pDest := PByte(DWORD(DestDesc.lpSurface)+Byte(DestY*DestDesc.lPitch+DestX));
   pMask := Pointer(@Transparency);

   asm
         push  esi
         push  edi

         mov   esi, pMask
         db $0F,$6F,$26       /// movq  mm4, [esi]
                              //  mm4 ¿¡ Åõ¸í»ö ¹øÈ£¸¦ ³Ö´Â´Ù
         mov   esi, pSour
         mov   edi, pDest

         mov   ecx, Size.Y

   @@LOOP_Y:

         push  ecx

         mov   ecx, Size.X
         shr   ecx, 3         // µ¿½Ã¿¡ 8°³ÀÇ Á¡À» ¿¬»êÇÏ¹Ç·Î


   @@LOOP_X:

         db $0F,$6F,$07       /// movq  mm0, [edi]
                              //  mm0 Àº Destination
         db $0F,$6F,$0E       /// movq  mm1, [esi]
                              //  mm1 Àº Source
         db $0F,$6F,$D1       /// movq  mm2, mm1
                              //  mm2 ¿¡ Source µ¥ÀÌÅÍ¸¦ º¹»ç
         db $0F,$74,$D4       /// pcmpeqb mm2, mm4
                              //  mm2 ¿¡ Åõ¸í»ö¿¡ µû¸¥ ¸¶½ºÅ©¸¦ »ý¼º
         db $0F,$6F,$DA       /// movq  mm3, mm2
                              //  mm3 ¿¡ ¸¶½ºÅ©¸¦ ÇÏ³ª ´õ º¹»ç
         db $0F,$DF,$D1       /// pandn mm2, mm1
                              //  Source ½ºÇÁ¶óÀÌÆ® ºÎºÐ¸¸À» ³²±è
         db $0F,$DB,$D8       /// pand  mm3, mm0
                              //  Destination ÀÇ °»½ÅµÉ ºÎºÐ¸¸ Á¦°Å
         db $0F,$EB,$D3       /// por   mm2, mm3
                              //  Source ¿Í Destination À» °áÇÕ
         db $0F,$7F,$17       /// movq  [edi], mm2
                              //  Destination ¿¡ °á°ú¸¦ ¾¸

         add   esi, 8
                              //  ÇÑ¹ø¿¡ 8 bytes ¸¦ µ¿½Ã¿¡ Ã³¸®ÇßÀ¸¹Ç·Î
         add   edi, 8

         loop  @@LOOP_X

         add   esi, SourDesc.lPitch
         sub   esi, Size.X
         add   edi, DestDesc.lPitch
         sub   edi, Size.X

         pop   ecx
         loop  @@LOOP_Y

         db $0F,$77              /// emms

         pop   edi
         pop   esi

   end;

   Sour.UnLock();
   Dest.UnLock();

end;
//»­Ð§¹û
procedure DrawEffect (x, y, width, height: integer; ssuf: TDirectDrawSurface; eff: TColorEffect);
var
   i, j, n, scount, srclen: integer;
   sddsd: TDDSurfaceDesc;
   sptr, peff: PByte;
   //source: array[0..810] of byte;
   source: array[0..SCREENWIDTH + 10] of byte;
begin
   if Width > SCREENWIDTH then exit;
//   if Width > 800 then exit;
   if eff = ceNone then exit;
   peff := nil;
   case eff of
      ceGrayScale: peff := @GrayScaleLevel;
      ceBright: peff := @BrightColorLevel;
      ceBlack: peff := @BlackColorLevel;
      ceWhite: peff := @WhiteColorLevel;
      ceRed: peff := @RedishColorLevel;
      ceGreen: peff := @GreenColorLevel;
      ceBlue:  peff := @BlueColorLevel;
      ceYellow:  peff := @YellowColorLevel;
      ceFuchsia: peff := @FuchsiaColorLevel;
      //else exit;
   end;
   if peff = nil then begin
      peff := nil;
      exit;
   end;
   try
      sddsd.dwSize := SizeOf(sddsd);
      ssuf.Lock (TRect(nil^), sddsd);
      srclen := width;
      for i:=0 to height-1 do begin
         sptr := PBYTE(integer(sddsd.lpSurface) + (y+i) * sddsd.lPitch + x);
         asm
               mov   scount, 0
               mov   esi, sptr
               lea   edi, source
            @@CopySource:
               mov   ebx, scount        //ebx = scount
               cmp   ebx, srclen
               jae   @@EndSourceCopy
               db $0F,$6F,$04,$1E       /// movq  mm0, [esi+ebx]
               db $0F,$7F,$07           /// movq  [edi], mm0

               mov   ebx, 0
            @@Loop8:
               cmp   ebx, 8
               jz    @@EndLoop8
               movzx eax, [edi+ebx].byte
               mov   edx, peff
               movzx eax, [edx+eax].byte     //
               mov   [edi+ebx], al
               inc   ebx
               jmp   @@Loop8
            @@EndLoop8:

               mov   ebx, scount
               db $0F,$6F,$07           /// movq  mm0, [edi]
               db $0F,$7F,$04,$1E       /// movq  [esi+ebx], mm0

               add   edi, 8
               add   scount, 8
               jmp   @@CopySource
            @@EndSourceCopy:
               db $0F,$77               /// emms

         end;
      end;
   finally
      ssuf.UnLock();
   end;
end;
procedure DrawLine(Surface: TDirectDrawSurface);
var
  I: Integer;
  nX,nY:Integer;
begin
  for nX := 0 to Surface.Width - 1 do begin
    Surface.Pixels[nX,0]:=255;
  end;
  for nY := 0 to Surface.Height - 1 do begin
    Surface.Pixels[0,nY]:=255;
  end;
  Surface.Height
end;

end.
