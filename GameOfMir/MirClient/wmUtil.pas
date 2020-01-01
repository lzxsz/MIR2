unit wmutil;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, DIB,
  DXDraws, DXClass;

type

   TWMImageHeader = record
      Title: String[40];        //'WEMADE Entertainment inc.'
      ImageCount: integer;
      ColorCount: integer;
      PaletteSize: integer;
      VerFlag:integer;
   end;

{
   TWMImageHeader = record
      Title: string[40];        //'WEMADE Entertainment inc.'
      ImageCount: integer;
      ColorCount: integer;
      PaletteSize: integer;
   end;
}
   PTWMImageHeader = ^TWMImageHeader;

   TWMImageInfo = record
     nWidth    :SmallInt;
     nHeight   :SmallInt;
      px: smallint;
      py: smallint;
      bits: PByte;
   end;
   PTWMImageInfo = ^TWMImageInfo;

   TWMIndexHeader = record
      Title: string[40];        //'WEMADE Entertainment inc.'
      IndexCount: integer;
      VerFlag:integer;
   end;
{
   TWMIndexHeader = record
      Title: string[40];        //'WEMADE Entertainment inc.'
      IndexCount: integer;
   end;
}
   PTWMIndexHeader = ^TWMIndexHeader;

   TWMIndexInfo = record
      Position: integer;
      Size: integer;
   end;
   PTWMIndexInfo = ^TWMIndexInfo;


   TDXImage = record
     nPx          :SmallInt;
     nPy          :SmallInt;
     Surface      :TDirectDrawSurface;
     dwLatestTime :LongWord;
   end;
   pTDxImage = ^TDXImage;


function WidthBytes(w: Integer): Integer;
function PaletteFromBmpInfo(BmpInfo: PBitmapInfo): HPalette;
function  MakeBmp (w, h: integer; bits: Pointer; pal: TRGBQuads): TBitmap;
procedure DrawBits(Canvas: TCanvas; XDest, YDest: integer; PSource: PByte; Width, Height: integer);

implementation


function WidthBytes(w: Integer): Integer;
begin
  Result := (((w * 8) + 31) div 32) * 4;
end;

function PaletteFromBmpInfo(BmpInfo: PBitmapInfo): HPalette;
var
   PalSize, n: Integer;
   Palette: PLogPalette;
begin
     //Allocate Memory for Palette
     PalSize := SizeOf(TLogPalette) + (256 * SizeOf(TPaletteEntry));
     Palette := AllocMem(PalSize);

     //Fill in structure
     with Palette^ do
     begin
          palVersion := $300;
          palNumEntries := 256;
          for n := 0 to 255 do
          begin
               palPalEntry[n].peRed := BmpInfo^.bmiColors[n].rgbRed;
               palPalEntry[n].peGreen := BmpInfo^.bmiColors[n].rgbGreen;
               palPalEntry[n].peBlue := BmpInfo^.bmiColors[n].rgbBlue;
               palPalEntry[n].peFlags := 0;
          end;
     end;
     Result := CreatePalette(Palette^);
     FreeMem(Palette, PalSize);
end;

procedure CreateDIB256(var Bmp: TBitmap; BmpInfo: PBitmapInfo; Bits: PByte);
var
   dc, MemDc: HDC;
   OldPal: HPalette;
begin
   dc:=0;
   MemDc:=0;//jacky
   //First Release Handle and Palette from BMP
   DeleteObject(Bmp.ReleaseHandle);
   DeleteObject(Bmp.ReleasePalette);

   try
      dc := GetDC(0);
      try
         MemDC := CreateCompatibleDC(DC);
         DeleteObject(SelectObject(MemDC, CreateCompatibleBitmap(dc, 1, 1)));

         OldPal := 0;
         Bmp.Palette := PaletteFromBmpInfo(BmpInfo);
         OldPal := SelectPalette(MemDc, Bmp.Palette, False);
         RealizePalette(MemDc);
         try
            Bmp.Handle := CreateDIBitmap(MemDc, BmpInfo^.bmiHeader, CBM_INIT,
                     Pointer(Bits), BmpInfo^, DIB_RGB_COLORS);
         finally
            if OldPal <> 0 then
               SelectPalette(MemDc, OldPal, True);
         end;
      finally
         if MemDC <> 0 then
            DeleteDC(MemDC);
      end;
   finally
      if dc <> 0 then
         ReleaseDC(0, DC);
   end;
   if Bmp.Handle = 0 then
      Exception.Create('CreateDIBitmap failed');
end;

function  MakeBmp (w, h: integer; bits: Pointer; pal: TRGBQuads): TBitmap;
var
   i, k: integer;
   BmpInfo: PBitmapInfo;
   HeaderSize: Integer;
   bmp: TBitmap;
begin
   HeaderSize := SizeOf(TBitmapInfo) + (256 * SizeOf(TRGBQuad));
   GetMem (BmpInfo, HeaderSize);
   for i:=0 to 255 do begin
      BmpInfo.bmiColors[i] := pal[i];
   end;
   with BmpInfo^.bmiHeader do begin
      biSize := SizeOf(TBitmapInfoHeader);
      biWidth := w;
      biHeight := h;
      biPlanes := 1;
      biBitCount := 8; //8bit
      biCompression := BI_RGB;
      biClrUsed := 0;
      biClrImportant := 0;
   end;
   Bmp := TBitmap.Create;
   CreateDIB256 (Bmp, BmpInfo, bits);
   FreeMem (BmpInfo);
   Result := Bmp;
end;

procedure DrawBits(Canvas: TCanvas; XDest, YDest: integer; PSource: PByte; Width, Height: integer);
var
  HeaderSize : integer;
  bmpInfo : PBitmapInfo;
begin
  if PSource = nil then exit;

  HeaderSize := Sizeof(TBitmapInfo) + (256 * Sizeof(TRGBQuad));
  BmpInfo := AllocMem(HeaderSize);
  if BmpInfo = nil then raise Exception.Create('TNoryImg: Failed to allocate a DIB');
  with BmpInfo^.bmiHeader do begin
    biSize        := SizeOf(TBitmapInfoHeader);
    biWidth       := Width;
    biHeight      := -Height;
    biPlanes      := 1;
    biBitCount    := 8;
    biCompression := BI_RGB;
    biClrUsed     := 0;
    biClrImportant:= 0;
  end;
  SetDIBitsToDevice(Canvas.Handle, XDest, YDest, Width, Height, 0, 0, 0, Height,
                    PSource, BmpInfo^, DIB_RGB_COLORS);
  FreeMem(BmpInfo, HeaderSize);
end;

end.
