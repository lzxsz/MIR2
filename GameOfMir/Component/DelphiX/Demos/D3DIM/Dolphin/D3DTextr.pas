//-------------------------------------------------------------
// File: D3DTextr.h, .cpp
// Delphi Translation by Arne Schäpers 05-MAR-00
//
// Functions to manage textures, including creating (loading from a
// file), restoring lost surfaces, invalidating, and destroying.
//
// Note: The implementation of these fucntions maintain an
// internal list of loaded textures. After creation, individual
// textures are referenced via their ASCII names.
//
// Copyright (c) 1997-1999 Microsoft Corporation.
// All rights reserved
//-------------------------------------------------------------
unit D3DTextr;
{$IFDEF VER100} {$DEFINE DELPHI3} {$ENDIF}
interface
uses Windows, Classes, SysUtils, Graphics, DirectX,
     D3DUtil, Dialogs;

//-------------------------------------------------------------
// Access functions for loaded textures. Note: these functions
// search an internal list of the textures, and use the texture
// associated with the ASCII name.
//---------------------------------------------------------------
function D3DTextr_GetSurface(strName: String): IDirectDrawSurface7;

//-------------------------------------------------------------
// Texture invalidation and restoration functions
//-------------------------------------------------------------
function D3DTextr_Invalidate(strName: String): HResult;
function D3DTextr_Restore(strName: String;
  pd3dDevice: IDirect3DDevice7): HResult;
function D3DTextr_InvalidateAllTextures: HResult;
function D3DTextr_RestoreAllTextures
 (pd3dDevice: IDirect3DDevice7): HResult;

//--------------------------------------------------------------
// Texture creation and deletion functions
//--------------------------------------------------------------
const
  D3DTEXTR_TRANSPARENTWHITE = $00000001;
  D3DTEXTR_TRANSPARENTBLACK = $00000002;
  D3DTEXTR_32BITSPERPIXEL   = $00000004;
  D3DTEXTR_16BITSPERPIXEL   = $00000008;
  D3DTEXTR_CREATEWITHALPHA  = $00000010;

function D3DTextr_CreateTextureFromFile(strName: String;
  dwStage {: DWord = 0}, dwFlags: DWord {= 0}): HResult;
function D3DTextr_CreateEmptyTexture(strName: String;
  dwWidth, dwHeight, dwStage, dwFlags: DWord): HResult;
function D3DTextr_DestroyTexture(strName: String): HResult;

// global directory to be searched for files
procedure D3DTextr_SetTexturePath(strTexturePath: String);


implementation

//--------------------------------------------------------------
// Macros, function prototypes and static variable
//--------------------------------------------------------------
var g_strTexturePath: String; // Path for files


//--------------------------------------------------------------
// Name: TextureContainer
// Desc: Linked list structure to hold info per texture
//--------------------------------------------------------------
type
  TTextureContainer = class;

  TTextureContainer = class(TObject)
    // m_pNext: TTextureContainer; // Linked list ptr

    m_strName: String;     // Name of texture (doubles as image filename)
    m_dwWidth, m_dwHeight: Cardinal;
    m_dwStage: Cardinal;   // Texture stage (for multitexture devices)
    m_dwBPP: Cardinal;
    m_dwFlags: Cardinal;
    m_bHasAlpha: Boolean;

    m_pddsSurface: IDirectDrawSurface7; // Surface of the texture
    m_hbmBitmap: HBitmap;       // Bitmap containing texture image
    m_pRGBAData: PDWord;

  public
    constructor Create(strName: String; dwStage, dwFlags: Cardinal);
    destructor Destroy; override;

    function LoadImageData: HResult;
    function LoadBitmapFile(strPathname: String): HResult;
    function LoadTargaFile(strPathname: String): HResult;
    function Restore(pd3dDevice: IDirect3DDevice7): HResult;
    function CopyBitmapToSurface: HResult;
    function CopyRGBADataToSurface: HResult;
end;

// Global instance (initialization, finalization)

// AS: No texture manager "class" here - I simply couldn't resist

var g_ptcTextureList: TStringList; // Local list of textures


//-----------------------------------------------------------------------------
// Name: D3DTextr_CreateTextureFromFile()
// Desc: Is passed a filename and creates a local Bitmap from that file.
//       The texture can not be used until it is restored, however.
//-----------------------------------------------------------------------------
function D3DTextr_CreateTextureFromFile(strName: String;
  dwStage, dwFlags: DWORD): HResult;
var NewTex: TTextureContainer;
    bm: {$IFDEF DELPHI3} Windows.TBitmap; {$ELSE} Windows.Bitmap; {$ENDIF}
begin
  // Check parameters
  if strName = '' then begin Result := E_INVALIDARG; Exit; end;
  // Check first to see if the texture is already loaded
  if g_ptcTextureList.IndexOf(AnsiUpperCase(strName)) <> -1 then
  begin
    Result := S_OK; Exit;
  end;
  // Allocate, load, and add the texture to the [linked] list of textures;
  NewTex := TTextureContainer.Create(strName, dwStage, dwFlags);
  // Create a bitmap and load the texture file into it,
  if FAILED(NewTex.LoadImageData) then
  begin
    NewTex.Free; Result := E_FAIL; Exit;
  end;
  // add to list
  g_ptcTextureList.AddObject(AnsiUpperCase(strName),NewTex);
  with NewTex do
    if m_hbmBitmap <> 0 then
    begin  // Save the image's dimensions
      GetObject(m_hbmBitmap,SizeOf(bm), @bm);
      m_dwWidth  := bm.bmWidth;
      m_dwHeight := bm.bmHeight;
      m_dwBPP    := bm.bmBitsPixel;
    end;
  Result := S_OK;
end;

//-----------------------------------------------------------------------------
// Name: D3DTextr_CreateEmptyTexture()
// Desc: Creates an empty texture.
//-----------------------------------------------------------------------------
function D3DTextr_CreateEmptyTexture(strName: String;
  dwWidth, dwHeight, dwStage, dwFlags: DWord): HResult;
var NewTex: TTextureContainer;
begin
  // Check parameters
  if strName = '' then begin Result := E_INVALIDARG; Exit; end;
  // Check first to see if the texture is already loaded
  if g_ptcTextureList.IndexOf(AnsiUpperCase(strName)) <> -1 then
  begin
    Result := E_FAIL; Exit;
  end;
  // Allocate and add the texture to the [linked] list of textures;
  NewTex := TTextureContainer.Create(strName, dwStage, dwFlags);
  g_ptcTextureList.AddObject(AnsiUpperCase(strName),NewTex);
  with NewTex do
  begin
    m_dwWidth := dwWidth; m_dwHeight := dwHeight;
    if m_dwFlags and D3DTEXTR_32BITSPERPIXEL <> 0 then m_dwBPP := 32
      else m_dwBPP := 16;
    m_bHasAlpha := dwFlags and D3DTEXTR_CREATEWITHALPHA <> 0;
  end;
  Result := S_OK;
end;



//-----------------------------------------------------------------------------
// Name: D3DTextr_DestroyTexture()
// Desc: Frees the resources for the specified texture container
//-----------------------------------------------------------------------------
function D3DTextr_DestroyTexture(strName: String): HResult;
var x: Integer;
begin
  x := g_ptcTextureList.IndexOf(AnsiUpperCase(strName));
  if x <> -1 then
  begin
    TTextureContainer(g_ptcTextureList.Objects[x]).Free;
    g_ptcTextureList.Delete(x);
  end;
  Result := S_OK;
end;

procedure D3DTextr_SetTexturePath(strTexturePath: String);
begin
  g_strTexturePath := strTexturePath;
end;

//-----------------------------------------------------------------------------
// Name: D3DTextr_GetSurface()
// Desc: Returns a pointer to a d3dSurface from the name of the texture
//-----------------------------------------------------------------------------
function D3DTextr_GetSurface(strName: String): IDirectDrawSurface7;
var x: Integer;
begin
  x := g_ptcTextureList.IndexOf(AnsiUpperCase(strName));
  if x = -1 then Result := nil
   else Result := TTextureContainer(g_ptcTextureList.Objects[x]).m_pddsSurface;
end;

//-----------------------------------------------------------------------------
// Name: D3DTextr_Invalidate()
// Desc: Used to bump a texture out of (video) memory, this function
//       actually destroys the d3dtexture and ddsurface of the texture
//-----------------------------------------------------------------------------
function D3DTextr_Invalidate(strName: String): HResult;
var x: Integer;
begin
  x := g_ptcTextureList.IndexOf(AnsiUpperCase(strName));
  if x = -1 then Result := DDERR_NOTFOUND else
  begin
    TTextureContainer(g_ptcTextureList.Objects[x]).m_pddsSurface := nil;
    Result := S_OK;
  end;
end;


//-----------------------------------------------------------------------------
// Name: D3DTextr_Restore()
// Desc: Invalidates the current texture objects and rebuilds new ones
//       using the new device.
//-----------------------------------------------------------------------------
function D3DTextr_Restore(strName: String; pd3dDevice: IDirect3DDevice7): HResult;
var x: Integer;
begin
  x := g_ptcTextureList.IndexOf(AnsiUpperCase(strName));
  if x = -1 then Result := DDERR_NOTFOUND
    else Result := TTextureContainer(g_ptcTextureList.Objects[x]).Restore(pd3dDevice);
end;

//-----------------------------------------------------------------------------
// Name: D3DTextr_InvalidateAllTextures()
// Desc: This function is called when a mode is changed. It invalidates
//       all texture objects so their device can be safely released.
//-----------------------------------------------------------------------------
function D3DTextr_InvalidateAllTextures: HResult;
var x: Integer;
begin
  for x := 0 to g_ptcTextureList.Count-1 do
    TTextureContainer(g_ptcTextureList.Objects[x]).m_pddsSurface := nil;
  Result := S_OK
end;

//-----------------------------------------------------------------------------
// Name: D3DTextr_RestoreAllTextures()
// Desc: This function is called when a mode is changed. It updates all
//       texture objects to be valid with the new device.
//-----------------------------------------------------------------------------
function D3DTextr_RestoreAllTextures(pd3dDevice: IDirect3DDevice7): HResult;
var x: Integer;
begin
  for x := 0 to g_ptcTextureList.Count-1 do
    TTextureContainer(g_ptcTextureList.Objects[x]).Restore(pd3dDevice);
  Result := S_OK;
end;


// =================================================================

{ TTextureContainer }
//-----------------------------------------------------------------------------
// Name: CopyBitmapToSurface()
// Desc: Copies the image of a bitmap into a surface
//-----------------------------------------------------------------------------
function TTextureContainer.CopyBitmapToSurface: HResult;
var pDD: IDirectDraw7; ddsd: TDDSurfaceDesc2;
  bm: {$IFDEF DELPHI3} Windows.TBitmap; {$ELSE} Windows.Bitmap; {$ENDIF}
  pddsTempSurface: IDirectDrawSurface7; hdcBitmap, hdcSurface: HDC;
  // Palette stuff
  pPalette: IDirectDrawPalette; dwPaletteFlags: DWord;
  pe: Array[0..255] of DWord; wNumColors: Word; i: Integer;
  // Alpha stuff
  dwAlphaMask, dwRGBMask, dwColorKey: DWord; x, y: Integer;
  p16: PWord; p32: PDWord;
begin
  // Get a DDraw object to create a temporary surface
  m_pddsSurface.GetDDInterface(IUnknown(pDD));

  // Get the bitmap structure (to extract width, height, and bpp)
  GetObject(m_hbmBitmap, SizeOf(bm), @bm);

  // Setup the new surface desc
  ddsd.dwSize := SizeOf(ddsd);
  m_pddsSurface.GetSurfaceDesc(ddsd);
  with ddsd do
  begin
    dwFlags := DDSD_CAPS or DDSD_HEIGHT or DDSD_WIDTH or
            DDSD_PIXELFORMAT or DDSD_TEXTURESTAGE;
    ddsCaps.dwCaps   := DDSCAPS_TEXTURE or DDSCAPS_SYSTEMMEMORY;
    ddsCaps.dwCaps2  := 0;
    dwWidth := bm.bmWidth; dwHeight := bm.bmHeight;
  end;

  // Create a new surface for the texture
  Result := pDD.CreateSurface(ddsd, pddsTempSurface, nil);
  if FAILED(Result) then Exit;

  // Get a DC for the bitmap
  hdcBitmap := CreateCompatibleDC(0);
  if hdcBitmap = 0 then Exit;
  SelectObject(hdcBitmap, m_hbmBitmap);

  // Handle palettized textures. Need to attach a palette
  if ddsd.ddpfPixelFormat.dwRGBBitCount = 8 then
  begin
    dwPaletteFlags := DDPCAPS_8BIT or DDPCAPS_ALLOW256;
    wNumColors := GetDIBColorTable( hdcBitmap, 0, 256, pe);

    // Create the color table
    for i := 0 to wNumColors-1 do
    begin
      pe[i] := RGB(GetBValue(pe[i]), GetGValue(pe[i]), GetRValue(pe[i]));

      // Handle textures with transparent pixels
      if m_dwFlags and (D3DTEXTR_TRANSPARENTWHITE or D3DTEXTR_TRANSPARENTBLACK) <> 0 then
      begin
        // Set alpha for opaque pixels
        if m_dwFlags and D3DTEXTR_TRANSPARENTBLACK <> 0 then
        begin
          if pe[i] <> 00000000 then pe[i] := pe[i] or $ff000000;
        end else if m_dwFlags and D3DTEXTR_TRANSPARENTWHITE <> 0 then
        begin
         if pe[i] <> $00ffffff then pe[i] := pe[i] or $ff000000;
        end;
      end;
    end;
    // Add DDPCAPS_ALPHA flag for textures with transparent pixels
    if m_dwFlags and (D3DTEXTR_TRANSPARENTWHITE or D3DTEXTR_TRANSPARENTBLACK) <> 0
        then dwPaletteFlags := dwPaletteFlags or DDPCAPS_ALPHA;

    // Create & attach a palette
    pDD.CreatePalette(dwPaletteFlags, @pe, pPalette, nil);
    pddsTempSurface.SetPalette(pPalette);
    m_pddsSurface.SetPalette(pPalette);

  end;  // bitCount = 8

  // Copy the bitmap image to the surface.
  if SUCCEEDED(pddsTempSurface.GetDC(hdcSurface)) then
  begin
    BitBlt(hdcSurface, 0, 0, bm.bmWidth, bm.bmHeight, hdcBitmap, 0, 0, SRCCOPY);
    pddsTempSurface.ReleaseDC(hdcSurface);
  end;
  DeleteDC( hdcBitmap );

  // Copy the temp surface to the real texture surface
  m_pddsSurface.Blt(nil, pddsTempSurface, nil, DDBLT_WAIT, nil );

  // Done with the temp surface
  pddsTempSurface := nil;

  // For textures with real alpha (not palettized), set transparent bits
  if ddsd.ddpfPixelFormat.dwRGBAlphaBitMask <> 0 then
    if  m_dwFlags and (D3DTEXTR_TRANSPARENTWHITE or D3DTEXTR_TRANSPARENTBLACK) <> 0 then
    begin
      // Lock the texture surface
      ddsd.dwSize := SizeOf(ddsd);
      while m_pddsSurface.Lock(nil, ddsd, 0, 0) = DDERR_WASSTILLDRAWING do
                 ;
      with ddsd.ddpfPixelFormat do
      begin
        dwAlphaMask := dwRGBAlphaBitMask;
        dwRGBMask   := dwRBitMask or dwGBitMask or dwBBitMask;
      end;
      if m_dwFlags and D3DTEXTR_TRANSPARENTWHITE  <> 0
        then dwColorKey := dwRGBMask // Colorkey on white
        else dwColorkey  := $00000000; // Colorkey on black

      // Add an opaque alpha value to each non-colorkeyed pixel
      for y := 0 to ddsd.dwHeight-1 do
        if ddsd.ddpfPixelFormat.dwRGBBitCount = 16 then
        begin
          p16 := Pointer(Integer(ddsd.lpSurface)+y*ddsd.lPitch);
          for x := 1 to ddsd.dwWidth do
          begin
            p16^ := p16^ and dwRGBMask;
            if p16^ <> dwColorkey then p16^ := p16^ or dwAlphaMask;
            Inc(p16);
          end;
        end else if ddsd.ddpfPixelFormat.dwRGBBitCount = 32 then
        begin
          p32 := Pointer(Integer(ddsd.lpSurface)+y*ddsd.lPitch);
          for x := 1 to ddsd.dwWidth do
          begin
            p32^ := p32^ and dwRGBMask;
            if p32^ <> dwColorkey then p32^ := p32^ or dwAlphaMask;
            Inc(p32);
          end;
        end;
      m_pddsSurface.Unlock(nil);
    end;
//  pDD := nil;
  Result := S_OK;
end;

//-----------------------------------------------------------------------------
// Name: CopyRGBADataToSurface()
// Desc: Copies RGBAData to a DirectDraw Surface
//-----------------------------------------------------------------------------
function TTextureContainer.CopyRGBADataToSurface: HResult;
var pDD: IDirectDraw7; ddsd: TDDSurfaceDesc2;
    pddsTempSurface: IDirectDrawSurface7;
    dwRMask, dwGMask, dwBMask, dwAMask,
    dwRShiftL, dwRShiftR, dwGShiftL, dwGShiftR,
    dwBShiftL, dwBShiftR, dwAShiftL, dwAShiftR: DWord;

    p16: PWord; p32: PDWord; x,y: Integer; pData: PDWord;
    dwPixel, dr, dg, db, da: DWord;

  procedure SetShifts(dwMask: DWord; var ShiftR, ShiftL: DWord);
  begin
    ShiftR := 0; ShiftL := 8;
    while (dwMask <> 0) and ((dwMask and 1) = 0) do
    begin
      dwMask := dwMask shr 1; Inc(ShiftR);
    end;
    while dwMask <> 0 do
    begin
      dwMask := dwMask shr 1; Dec(ShiftL);
    end;
  end;

begin
  // Get a DDraw object to create a temporary surface
  m_pddsSurface.GetDDInterface(IUnknown(pDD));

  // Setup the new surface desc
  ddsd.dwSize := SizeOf(ddsd);
  m_pddsSurface.GetSurfaceDesc(ddsd);
  with ddsd do
  begin
    dwFlags := DDSD_CAPS or DDSD_HEIGHT or DDSD_WIDTH or
            DDSD_PIXELFORMAT or DDSD_TEXTURESTAGE;
    ddsCaps.dwCaps   := DDSCAPS_TEXTURE or DDSCAPS_SYSTEMMEMORY;
    ddsCaps.dwCaps2  := 0;
    dwWidth := m_dwWidth; dwHeight := m_dwHeight;
  end;

  // Create a new surface for the texture
  Result := pDD.CreateSurface(ddsd, pddsTempSurface, nil);
  if FAILED(Result) then Exit;

  while pddsTempSurface.Lock(nil, ddsd, 0, 0)  = DDERR_WASSTILLDRAWING do
                    ;
  with ddsd.ddpfPixelFormat do
  begin
    dwRMask := dwRBitMask; dwGMask := dwGBitMask;
    dwBMask := dwBBitMask; dwAMask := dwRGBAlphaBitMask;
  end;

  SetShifts(dwRMask, dwRShiftR, dwRShiftL);
  SetShifts(dwGMask, dwGShiftR, dwGShiftL);
  SetShifts(dwBMask, dwBShiftR, dwBShiftL);
  SetShifts(dwAMask, dwAShiftR, dwAShiftL);



  for y := 0 to Integer(ddsd.dwHeight)-1 do
  begin
    pData := m_pRGBAData; Inc(pData, y * Integer(ddsd.dwWidth));
    // scan line in surface data
    p16 := ddsd.lpSurface; Inc(PByte(p16),y * Integer(ddsd.lPitch));
    p32 := Pointer(p16);

    for x := 0 to ddsd.dwWidth-1 do
    begin
      dwPixel := pData^; Inc(pData);

      dr := ((((dwPixel shr 24) and $FF) shr dwRShiftL) shl dwRShiftR) and dwRMask;
      dg := ((((dwPixel shr 16) and $FF) shr dwGShiftL) shl dwGShiftR) and dwGMask;
      db := ((((dwPixel shr 8 ) and $FF) shr dwBShiftL) shl dwBShiftR) and dwBMask;
      da := ((((dwPixel       ) and $FF) shr dwAShiftL) shl dwAShiftR) and dwAMask;

      if ddsd.ddpfPixelFormat.dwRGBBitCount = 32 then
      begin
        p32^ := dr+dg+db+da; Inc(p32);
      end else
      begin
        p16^ := dr+dg+db+da; Inc(p16);
      end;
    end;
  end;  // for y

  pddsTempSurface.Unlock(nil);

  // Copy the temp surface to the real texture surface
  m_pddsSurface.Blt(nil, pddsTempSurface, nil, DDBLT_WAIT, nil );

  Result := S_OK;
end;


//-----------------------------------------------------------------------------
// Name: TextureContainer()
// Desc: Constructor for a texture object
//-----------------------------------------------------------------------------
constructor TTextureContainer.Create(strName: String; dwStage,
  dwFlags: Cardinal);
begin
  m_strName := AnsiUpperCase(strName);
  m_dwWidth := 0; m_dwHeight := 0;
  m_dwStage := dwStage; m_dwBPP  := 0;
  m_dwFlags := dwFlags;
  m_bHasAlpha := False;

  m_pddsSurface := nil; m_hbmBitmap := 0; m_pRGBAData   := nil;

  // Add the texture to the head of the global texture list
  //  m_pNext := g_ptcTextureList; g_ptcTextureList := this;
end;

//-----------------------------------------------------------------------------
// Name: ~TextureContainer()
// Desc: Destructs the contents of the texture container
//-----------------------------------------------------------------------------
destructor TTextureContainer.Destroy;
begin
  m_pddsSurface := nil;
  if m_pRGBAData <> nil then FreeMem(m_pRGBAData);
  DeleteObject(m_hbmBitmap);
  // Remove the texture container from the global list
  // done by caller!
  inherited;
end;

//-----------------------------------------------------------------------------
// Name: LoadBitmapFile()
// Desc: Loads data from a .bmp file, and stores it in a bitmap structure.
//-----------------------------------------------------------------------------
function TTextureContainer.LoadBitmapFile(strPathname: String): HResult;
begin
  if m_hbmBitmap <> 0 then DeleteObject(m_hbmBitmap);
  m_hbmBitmap := LoadImage(0, PChar(strPathname), IMAGE_BITMAP, 0, 0,
                 LR_LOADFROMFILE or LR_CREATEDIBSECTION );
  if m_hbmBitmap <> 0 then Result := S_OK
   else Result := DDERR_NOTFOUND;
end;

//-----------------------------------------------------------------------------
// Name: LoadImageData()
// Desc: Loads the texture map's image data
//-----------------------------------------------------------------------------
function TTextureContainer.LoadImageData: HResult;
var FName: String;
begin
  // Check the executable's resource. If it's there, we're done!
  m_hbmBitmap := LoadImage(GetModuleHandle(nil), PChar(m_strName),
             IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION);
  if m_hbmBitmap <> 0 then
  begin
    Result := S_OK; Exit;
  end;

  // First check if the file exists in the global texture path
  FName := g_strTexturePath+m_strName;
  if not FileExists(FName) then
  begin
    FName := D3DUtil_GetDXSDKMediaPath+m_strName;
    if not FileExists(FName) then
    begin
      Result := DDERR_NOTFOUND; Exit;
    end;
  end;

  if Pos('.BMP', FName) <> 0 then Result := LoadbitmapFile(FName)
   else if Pos('.TGA',FName) <> 0 then Result := LoadTargaFile(FName)
   else Result := DDERR_UNSUPPORTED;
end;



//-----------------------------------------------------------------------------
// Name: LoadTargaFile()
// Desc: Loads RGBA data from a .tga file, and stores it in allocated memory
//       for the specified texture container
// Comment from as: I did NOT invent this stuff ;-(
//-----------------------------------------------------------------------------
function TTextureContainer.LoadTargaFile(strPathname: String): HResult;
var F: TFileStream; x: DWord; y, z, dwOffset: Integer;
   r,g,b,a: DWord; pData: PDWord;
   PacketInfo, PacketType, PixelCount: DWord;

  TargaHeader: packed record
    IDLength, ColormapType, ImageType: Byte;
    ColormapSpecification: Array[0..4] of Byte;
    XOrigin, YOrigin, ImageWidth, ImageHeight: Word;
    PixelDepth, ImageDescriptor: Byte;
  end;

  function ReadByte: Byte;
  var b: Byte;
  begin F.Read(b,1); Result := b; end;

begin
  Result := E_FAIL;
  try
    F := TFileStream.Create(strPathName, fmOpenRead or fmShareDenyWrite);
  except
    Exit;
  end;
  F.Read(TargaHeader, SizeOf(TargaHeader));

  with TargaHeader do
  begin   // Only true color, non-mapped images are supported
    if (ColormapType <> 0) or ((ImageType <> 10) and (ImageType <> 2)) then
    begin
      F.Free; Exit;
    end;

     // Skip the ID field. The first byte of the header is the length of this field
    if IDLength > 0 then F.Position := F.Position + IDLength;

     m_dwWidth := ImageWidth; m_dwHeight := ImageHeight;
     m_dwBPP   := PixelDepth;
  end;
  if m_pRGBAData <> nil then FreeMem(m_pRGBAData);
  GetMem(m_pRGBAData, m_dwWidth*m_dwHeight*SizeOf(DWord));

  if m_pRGBAData = nil then
  begin
   F.Free; Exit;
  end;

  for y := 0 to m_dwHeight-1 do
  begin
    if TargaHeader.ImageDescriptor and $0010 = 0
      then dwOffset := (m_dwHeight-DWord(y)-1)*m_dwWidth
      else dwOffset := DWord(y) * m_dwWidth;
    // start of line
    pData := m_pRGBAData; Inc(pData,dwOffset);
    x := 0;
    while x < m_dwWidth do
    begin
      if TargaHeader.ImageType = 10 then
      begin
        PacketInfo := ReadByte;
        PacketType := PacketInfo and $80;
        PixelCount := (PacketInfo and $7F)+1;
        if PacketType <> 0 then
        begin
          b := ReadByte; g := ReadByte; r := ReadByte;
          if m_dwBPP = 32 then a := ReadByte
            else a := $FF;
          for z := 1 to PixelCount do
          begin
            pData^ := r shl 24 + g shl 16 + b shl 8 + a;
            Inc(pData);
            Inc(x);
          end;
        end else
        begin  // PacketType = 0
          for z := 1 to PixelCount do
          begin
            b := ReadByte; g := ReadByte; r := ReadByte;
            if m_dwBPP = 32 then a := ReadByte
              else a := $FF;
            pData^ := r shl 24 + g shl 16 + b shl 8 + a;
            Inc(pData);
            Inc(x);
          end;
        end;
      end else
      begin  // ImageType <> 10
        b := ReadByte; g := ReadByte; r := ReadByte;
        if m_dwBPP = 32 then a := ReadByte
          else a := $FF;
        pData^ := r shl 24 + g shl 16 + b shl 8 + a;
        Inc(pData);
        Inc(x);
      end;
    end;  // while x
  end;  // for y

  F.Free;

  // Check for alpha content
  pData := m_pRGBAData;
  for x := 0 to m_dwWidth*m_dwHeight-1 do
    if pData^ and $000000FF <> $FF then
    begin
      m_bHasAlpha := True; Break;
    end
      else Inc(pData);

  Result := S_OK;
end;


//-----------------------------------------------------------------------------
// Name: struct TEXTURESEARCHINFO
// Desc: Structure used to search for texture formats
//-----------------------------------------------------------------------------
type
  TTextureSearchInfo = record
    dwDesiredBPP: Cardinal; // Input for texture format search
    bUseAlpha, bUsePalette,
    bFoundGoodFormat: Boolean;
    pddpf: PDDPixelFormat;  // Output of texture format search
  end;
  PTextureSearchInfo = ^TTextureSearchInfo;


//-----------------------------------------------------------------------------
// Name: TextureSearchCallback()
// Desc: Enumeration callback routine to find a best-matching texture format.
//       The param data is the DDPIXELFORMAT of the best-so-far matching
//       texture. Note: the desired BPP is passed in the dwSize field, and the
//       default BPP is passed in the dwFlags field.
//-----------------------------------------------------------------------------
function TextureSearchCallback(var PixelFmt: TDDPixelFormat; param: Pointer): HResult; stdcall;
begin
  Result := DDENUMRET_OK;  // continue enumeration
  if not Assigned(@PixelFmt) or (param = nil) then Exit;
  // Skip any funky modes
  if PixelFmt.dwFlags and (DDPF_LUMINANCE or DDPF_BUMPLUMINANCE or DDPF_BUMPDUDV) <> 0
    then Exit;

  with PTextureSearchInfo(param)^ do  // Check for palettized formats
    if bUsePalette then
    begin
      if PixelFmt.dwFlags and DDPF_PALETTEINDEXED8 = 0 then Exit;

      // Accept the first 8-bit palettized format we get
      Move(PixelFmt, pddpf^, SizeOf(TDDPixelFormat));
      bFoundGoodFormat := True;
      Result := DDENUMRET_CANCEL;
      Exit;
    end;

  // Else, skip any paletized formats (all modes under 16bpp)
  if PixelFmt.dwRGBBitCount < 16  then Exit;

  // Skip any FourCC formats
  if PixelFmt.dwFourCC <> 0 then Exit;

  // Skip any ARGB 4444 formats (which are best used for pre-authored
  // content designed specifically for an ARGB 4444 format).
  if PixelFmt.dwRGBAlphaBitMask = $0000f000  then Exit;

  // Make sure current alpha format agrees with requested format type
  with PTextureSearchInfo(param)^ do
   if (bUseAlpha and (PixelFmt.dwFlags and DDPF_ALPHAPIXELS = 0)) or
    (not bUseAlpha and (PixelFmt.dwFlags and DDPF_ALPHAPIXELS <> 0)) then Exit;

  // Check if we found a good match
  with PTextureSearchInfo(param)^ do
   if dwDesiredBPP = PixelFmt.dwRGBBitCount then
   begin
     Move(PixelFmt, pddpf^, SizeOf(TDDPixelFormat));
     bFoundGoodFormat := True;
     Result := DDENUMRET_CANCEL;
     Exit;
   end;
end;

//-----------------------------------------------------------------------------
// Name: Restore()
// Desc: Rebuilds the texture surface using the new device.
//-----------------------------------------------------------------------------
function TTextureContainer.Restore(pd3dDevice: IDirect3DDevice7): HResult;
var ddDesc: TD3DDeviceDesc7; ddsd: TDDSurfaceDesc2; MaxWH: Cardinal;
    tsi: TTextureSearchInfo;
    pDD: IDirectDraw7; pddsRender: IDirectDrawSurface7;

begin
  // Release any previously created objects
  m_pddsSurface := nil;

  // Check params
  if not Assigned(pd3dDevice) then
  begin
    Result := DDERR_INVALIDPARAMS; Exit;
  end;

  // Get the device caps
  if FAILED(pd3dDevice.GetCaps(ddDesc)) then
  begin
    Result := E_FAIL; Exit;
  end;

  // Setup the new surface desc
  D3DUtil_InitSurfaceDesc(ddsd, DDSD_CAPS or DDSD_HEIGHT or DDSD_WIDTH or
                         DDSD_PIXELFORMAT or DDSD_TEXTURESTAGE, DDSCAPS_TEXTURE);
  with ddsd do
  begin
    dwTextureStage  := m_dwStage;
    dwWidth         := m_dwWidth;
    dwHeight        := m_dwHeight;
  end;

  // Turn on texture management for hardware devices
  with ddsd.ddsCaps do
    if EqualGUID(ddDesc.deviceGUID, IID_IDirect3DHALDevice)
        then dwCaps2 := DDSCAPS2_TEXTUREMANAGE
     else if EqualGUID(ddDesc.deviceGUID, IID_IDirect3DTnLHalDevice)
        then dwCaps2 := DDSCAPS2_TEXTUREMANAGE
    else dwCaps := dwCaps or DDSCAPS_SYSTEMMEMORY;

  // Adjust width and height to be powers of 2, if the device requires it
  if  ddDesc.dpcTriCaps.dwTextureCaps and D3DPTEXTURECAPS_POW2 <> 0 then
  with ddsd do
  begin
    dwWidth := 1; while m_dwWidth > dwWidth do dwWidth := dwWidth shl 1;
    dwHeight :=1; while m_dwHeight> dwHeight do dwHeight := dwHeight shl 1;
  end;

  // Limit max texture sizes, if the driver can't handle large textures
  MaxWH := ddDesc.dwMaxTextureWidth; if MaxWH = 0 then MaxWH := 256;
  if MaxWH < ddsd.dwWidth then ddsd.dwWidth := MaxWH;
  MaxWH := ddDesc.dwMaxTextureHeight; if MaxWH = 0 then MaxWH := 256;
  if MaxWH < ddsd.dwHeight then ddsd.dwHeight := MaxWH;

  // Make the texture square, if the driver requires it
  if ddDesc.dpcTriCaps.dwTextureCaps and D3DPTEXTURECAPS_SQUAREONLY <> 0 then
  with ddsd do
    if dwWidth > dwHeight then dwHeight := dwWidth
     else dwWidth := dwHeight;

  // Setup the structure to be used for texture enumration.
  with tsi do
  begin
    bFoundGoodFormat := FALSE;
    pddpf := @ddsd.ddpfPixelFormat;
    dwDesiredBPP     := m_dwBPP;
    bUsePalette      := m_dwBPP <= 8;
    bUseAlpha        := m_bHasAlpha;
    if  m_dwFlags and D3DTEXTR_16BITSPERPIXEL <> 0 then dwDesiredBPP := 16
      else if m_dwFlags and D3DTEXTR_32BITSPERPIXEL <> 0 then dwDesiredBPP := 32;

    if m_dwFlags and (D3DTEXTR_TRANSPARENTWHITE or D3DTEXTR_TRANSPARENTBLACK) <> 0 then
      if bUsePalette then
        if ddDesc.dpcTriCaps.dwTextureCaps and D3DPTEXTURECAPS_ALPHAPALETTE <> 0 then
        begin
          bUseAlpha := True; bUsePalette := True;
        end else
        begin
          bUseAlpha := True; bUsePalette := False;
        end;
  end;  // with tsi

  // Enumerate the texture formats, and find the closest device-supported
  // texture pixel format
  pd3dDevice.EnumTextureFormats(TextureSearchCallback, @tsi);

  // If we couldn't find a format, let's try a default format
  if not tsi.bFoundGoodFormat then
  begin
    tsi.bUsePalette  := False; tsi.dwDesiredBPP := 16;
    pd3dDevice.EnumTextureFormats( TextureSearchCallback, @tsi );

    // If we still fail, we cannot create this texture
    if not tsi.bFoundGoodFormat then
    begin
      Result := E_FAIL; Exit;
    end;
  end;

  // Get the DirectDraw interface for creating surfaces
  pd3dDevice.GetRenderTarget(pddsRender);
  pddsRender.GetDDInterface(IUnknown(pDD));
//  pddsRender := nil;

  // Create a new surface for the texture
  Result := pDD.CreateSurface(ddsd, m_pddsSurface, nil);

  if FAILED(Result) then Exit;

  // For bitmap-based textures, copy the bitmap image.
  if m_hbmBitmap <> 0 then Result := CopyBitmapToSurface
    else if m_pRGBAData <> nil then Result := CopyRGBADataToSurface
    // At this point, code can be added to handle other file formats (such as
    // .dds files, .jpg files, etc.).
    else Result := S_OK;
end;

procedure DeleteTextureList;  // finalization
var x: Integer;
begin
  for x := 0 to g_ptcTextureList.Count-1 do
    TTextureContainer(g_ptcTextureList.Objects[x]).Free;
  g_ptcTextureList.Free;
end;

initialization
  g_ptcTextureList := TStringList.Create;
  g_ptcTextureList.Sorted := True;
finalization
  DeleteTextureList;
end.

