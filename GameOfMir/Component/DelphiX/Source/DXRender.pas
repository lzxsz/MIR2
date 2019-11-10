unit DXRender;

interface

{$INCLUDE DelphiXcfg.inc}

uses
  Windows,
{$IfDef StandardDX}
  DirectDraw,
  {from DX7} Direct3D,
  {$IfDef DX9}
  Direct3D9, Direct3D, D3DX9, {Direct3D8,} DX7toDX8;
  {$Else}
  {$IfDef DX81}
  D3DX8, DirectXGraphics, DX7toDX8;
  {$Else}
   Direct3DRM;
  {$EndIf}
  {$EndIf}
{$Else}
  DirectX;
{$EndIf}

const
  DXR_MAXTEXTURE = 4;

type
  TDXR_Value = Double;

  TDXR_Color = DWORD;
  TDXR_SurfaceColor = DWORD;

  {  TDXR_Option  }

  PDXR_Option = ^TDXR_Option;
  TDXR_Option = (
    DXR_OPTION_VERSION,
    DXR_OPTION_MMXENABLE,
    DXR_OPTION_RENDERPRIMITIVES
  );                            

  {  TDXR_ShadeMode  }

  TDXR_ShadeMode = (
    DXR_SHADEMODE_FLAT,
    DXR_SHADEMODE_GOURAUD
  );

  {  TDXR_Blend  }

  TDXR_Blend = (
    // for blending
    DXR_BLEND_ZERO,                        // r=0
    DXR_BLEND_ONE1,                        // r=c1
    DXR_BLEND_ONE2,                        // r=c2
    DXR_BLEND_ONE1_ADD_ONE2,               // r=c1+c2
    DXR_BLEND_ONE1_SUB_ONE2,               // r=c1-c2
    DXR_BLEND_ONE2_SUB_ONE1,               // r=c2-c1
    DXR_BLEND_ONE1_MUL_ONE2,               // r=c1*c2
    DXR_BLEND_SRCALPHA1,                   // r=c1*a1
    DXR_BLEND_SRCALPHA1_ADD_ONE2,          // r=c1*a1+c2
    DXR_BLEND_ONE2_SUB_SRCALPHA1,          // r=c2-c1*a1
    DXR_BLEND_SRCALPHA1_ADD_INVSRCALPHA2,  // r=c1*a1+c2*(1-a2)
    DXR_BLEND_INVSRCALPHA1_ADD_SRCALPHA2,  // r=c1*(1-a1)+c2*a2
    // for lighting
    DXR_BLEND_DECAL,                       // r=c1
    DXR_BLEND_DECALALPHA,                  // r=c1    ra=a2
    DXR_BLEND_MODULATE,                    // r=c1*c2 ra=a2
    DXR_BLEND_MODULATEALPHA,               // r=c1*c2
    DXR_BLEND_ADD                          // r=c1+c2 ra=a2
  );

  {  TDXR_TextureFilter  }

  TDXR_TextureFilter = (
    DXR_TEXTUREFILTER_NEAREST,
    DXR_TEXTUREFILTER_LINEAR,
    DXR_TEXTUREFILTER_MIPMAP_NEAREST,
    DXR_TEXTUREFILTER_MIPMAP_LINEAR
  );

  {  TDXR_TextureAddress  }

  TDXR_TextureAddress = (
    DXR_TEXTUREADDRESS_TILE,           // tx=tx and WidthMask ty=ty and HeightMask
    DXR_TEXTUREADDRESS_DONOTCLIP       // tx=tx               ty=ty
  );

  {  TDXR_CmpFunc  }

  TDXR_CmpFunc = (
    DXR_CMPFUNC_NEVER,
    DXR_CMPFUNC_LESS,
    DXR_CMPFUNC_EQUAL,
    DXR_CMPFUNC_LESSEQUAL,
    DXR_CMPFUNC_GREATER,
    DXR_CMPFUNC_NOTEQUAL,
    DXR_CMPFUNC_GREATEREQUAL,
    DXR_CMPFUNC_ALWAYS
  );

  {  TDXR_ColorType  }

  TDXR_ColorType = (
    DXR_COLORTYPE_INDEXED,     // Palette indexed color
    DXR_COLORTYPE_RGB          // RGB color
  );

  {  TDXR_ColorChannel  }

  TDXR_ColorChannel = record
    Mask: DWORD;                // Bit Mask
    BitCount: DWORD;            // Number of bit
    rshift: DWORD;
    lshift: DWORD;
  end;

  {  TDXR_Surface  }

  PDXR_Surface = ^TDXR_Surface;
  TDXR_Surface = record
    ColorType: TDXR_ColorType;   // Color type
    Width, Height: DWORD;        // Size of surface
    WidthBit, HeightBit: DWORD;  // Size of surface (Number of bit)
    Width2, Height2: DWORD;      // 1 shl WidthBit, 1 shl HeightBit
    WidthMask, HeightMask: DWORD;// Bit Mask of size of surface
    BitCount: DWORD;             // BitCount per Pixel(1, 2, 4, 8, 16, 24, 32 only)
    Bits: Pointer;               // Pointer to pixeldata(x:0 y:0)
    Pitch: Integer;              // Offset of next scanline
    PitchBit: Integer;           // Offset of next scanline (Number of bit)
    MipmapChain: PDXR_Surface;
    case Integer of
      0: (
        { Indexed color }
        idx_index: TDXR_ColorChannel;  // Index channel
        idx_alpha: TDXR_ColorChannel;  // Alpha channel
        idx_palette: array[0..255] of TPaletteEntry;
                                       // Palette
      );
      1: (
        { RGB color }
        rgb_red: TDXR_ColorChannel;    // Red channel
        rgb_green: TDXR_ColorChannel;  // Green channel
        rgb_blue: TDXR_ColorChannel;   // Blue channel
        rgb_alpha: TDXR_ColorChannel;  // Alpha channel
      );
  end;

  {  TDXR_Vertex  }

  PDXR_Vertex = ^TDXR_Vertex;
  TDXR_Vertex = record
    sx: TDXR_Value;            // Screen coordinates
    sy: TDXR_Value;
    sz: TDXR_Value;
    rhw: TDXR_Value;           // 1/sz
    color: TDXR_Color;
    specular: TDXR_Color;
    tu, tv: array[0..DXR_MAXTEXTURE-1] of TDXR_Value;
  end;

  PPDXR_Vertex = ^PDXR_Vertex;

  {  TDXR_PrimitiveType  }

  TDXR_PrimitiveType = (
    DXR_PRIMITIVETYPE_TRIANGLELIST,
    DXR_PRIMITIVETYPE_TRIANGLESTRIP
  );

  {  TDXR_TextureLayerBlend  }

  TDXR_TextureLayerBlend = (
    DXR_TEXTURELAYERBLEND_TEXTURE,
    DXR_TEXTURELAYERBLEND_LAST,
    DXR_TEXTURELAYERBLEND_NOBLEND
  );

  {  TDXR_TextureLayer  }

  PDXR_TextureLayer = ^TDXR_TextureLayer;
  TDXR_TextureLayer = record
    Surface: PDXR_Surface;
    LayerBlend: TDXR_TextureLayerBlend;
    Blend: TDXR_Blend;
    ColorKeyEnable: Boolean;
    ColorKey: TDXR_SurfaceColor;
    TextureAddress: TDXR_TextureAddress;
    BumpTexture: Integer;
  end;

  {  TDXR_Cull  }

  TDXR_Cull = (
    DXR_CULL_NONE,
    DXR_CULL_CW,
    DXR_CULL_CCW
  );

  {  TDXR_RenderStates  }

  TDXR_RenderStates = record
    DitherEnable: Boolean;
    SpecularEnable: Boolean;
    CullMode: TDXR_Cull;
    Shade: TDXR_ShadeMode;
    TexBlend: TDXR_Blend;
    Blend: TDXR_Blend;
    TextureEnable: Boolean;
    TextureList: array[0..DXR_MAXTEXTURE-1] of TDXR_TextureLayer;
    TextureFilter: TDXR_TextureFilter;
    ZBuffer: PDXR_Surface;
    ZFunc: TDXR_CmpFunc;
    ZWriteEnable: Boolean;
    EnableDrawLine: Integer;
  end;

function dxrGetOption(Option: TDXR_Option): DWORD;
procedure dxrSetOption(Option: TDXR_Option; Value: DWORD);

procedure dxrMakeIndexedSurface(var Surface: TDXR_Surface; Width, Height, BitCount: DWORD;
  Bits: Pointer; pitch: Integer; idx_index, idx_alpha: DWORD);
procedure dxrMakeRGBSurface(var Surface: TDXR_Surface; Width, Height, BitCount: DWORD;
  Bits: Pointer; pitch: Integer; rgb_red, rgb_green, rgb_blue, rgb_alpha: DWORD);
function dxrScanLine(const Surface: TDXR_Surface; y: DWORD): Pointer;
procedure dxrZBufferClear(const Surface: TDXR_Surface);

function dxrDDSurfaceLock(DDSurface: IDirectDrawSurface; var Surface: TDXR_Surface): Boolean;
function dxrDDSurfaceLock2(DDSurface: IDirectDrawSurface; var ddsd: TDDSurfaceDesc;
  var Surface: TDXR_Surface): Boolean;
procedure dxrDDSurfaceUnLock(DDSurface: IDirectDrawSurface; const Surface: TDXR_Surface);

procedure dxrDefRenderStates(var States: TDXR_RenderStates);

procedure dxrDrawPrimitive(const Dest: TDXR_Surface; const States: TDXR_RenderStates; PrimitiveType: TDXR_PrimitiveType;
  VertexList: PDXR_Vertex; VertexCount: DWORD);
procedure dxrDrawPointeredPrimitive(const Dest: TDXR_Surface; const States: TDXR_RenderStates; PrimitiveType: TDXR_PrimitiveType;
  VertexList: PPDXR_Vertex; VertexCount: DWORD);
procedure dxrDrawIndexedPrimitive(const Dest: TDXR_Surface; const States: TDXR_RenderStates; PrimitiveType: TDXR_PrimitiveType;
  VertexList: PDXR_Vertex; VertexCount: DWORD; IndexList: PDWORD; IndexCount: DWORD);

procedure dxrCopyRectBlend(const Dest, Src: TDXR_Surface;
  const DestRect, SrcRect: TRect; Blend: TDXR_Blend; Alpha: Integer;
  ColorKeyEnable: Boolean; ColorKey: DWORD);

procedure dxrFillRectColorBlend(const Dest: TDXR_Surface;
  const DestRect: TRect; Blend: TDXR_Blend; Col: COLORREF);

procedure dxrDrawWaveXBlend(const Dest, Src: TDXR_Surface;
  X, Y, Width, Height: Integer; const SrcRect: TRect; amp, Len, ph: Integer;
  Blend: TDXR_Blend; Alpha: Integer;
  ColorKeyEnable: Boolean; ColorKey: DWORD);

procedure dxrDrawRotateBlend(const Dest, Src: TDXR_Surface;
  X, Y, Width, Height: Integer; const SrcRect: TRect; CenterX, CenterY: Double;
  Angle: Integer; Blend: TDXR_Blend; Alpha: Integer;
  ColorKeyEnable: Boolean; ColorKey: DWORD);

implementation

const
  TextureAxisFloatBit = 16;
  TextureAxisFloat = 1 shl TextureAxisFloatBit;

  ColorFloatBit = 8;
  ColorFloat = 1 shl ColorFloatBit;
               
type

  PInteger = ^Integer;

//  {  TDXR_CmpFunc  }
//
//  TDXR_CmpFunc = (
//    DXR_CMPFUNC_NEVER,
//    DXR_CMPFUNC_LESS,
//    DXR_CMPFUNC_EQUAL,
//    DXR_CMPFUNC_LESSEQUAL,
//    DXR_CMPFUNC_GREATER,
//    DXR_CMPFUNC_NOTEQUAL,
//    DXR_CMPFUNC_GREATEREQUAL,
//    DXR_CMPFUNC_ALWAYS
//  );

  {  TDXRMachine  }

  TDXRMachine_TreeType = (
    DXR_TREETYPE_LOADBLACK,      // Load black color
    DXR_TREETYPE_LOADCOLOR,      // Load vertex color
    DXR_TREETYPE_LOADCONSTCOLOR, // Load constant color
    DXR_TREETYPE_LOADTEXTURE,    // Load texel
    DXR_TREETYPE_LOADBUMPTEXTURE,// Load texel with Bump mapping
                                 //   dx := nx + (BumpTexture[nx-1, ny]-BumpTexture[nx+1, ny]);
                                 //   dy := ny + (BumpTexture[nx, ny-1]-BumpTexture[nx, ny+1]);
    DXR_TREETYPE_LOADDESTPIXEL,  // Load dest pixel
    DXR_TREETYPE_BLEND           // Blend color
  );

  TDXRColorChannel = (chRed, chGreen, chBlue, chAlpha);
  TDXRColorChannels = set of TDXRColorChannel;

  PDXRMachine_Color = ^TDXRMachine_Color;
  TDXRMachine_Color = packed record
    R, G, B, A: WORD;
  end;

  PDXRMachine_Axis = ^TDXRMachine_Axis;
  TDXRMachine_Axis = packed record
    X, Y: Integer;
  end;

  PDXRMachine_Int64 = ^TDXRMachine_Int64;
  TDXRMachine_Int64 = Comp;

  PDXRMachine_Reg_Color = ^TDXRMachine_Reg_Color;
  TDXRMachine_Reg_Color = record
    Enable: Boolean;
    nColor: TDXRMachine_Color;
    iColor: TDXRMachine_Color;
    Gouraud: Boolean;
    Channels: TDXRColorChannels;
  end;

  PDXRMachine_Reg_Texture = ^TDXRMachine_Reg_Texture;
  TDXRMachine_Reg_Texture = record
    Enable: Boolean;
    Surface: PDXR_Surface;
    nAxis: TDXRMachine_Axis;
    iAxis: TDXRMachine_Axis;
    iAxisConstant: Boolean;
    Filter: TDXR_TextureFilter;
    ColorKeyEnable: Boolean;
    ColorKey: TDXR_SurfaceColor;
    EnableChannels: TDXRColorChannels;
    TextureAddress: TDXR_TextureAddress;
    DefaultColor: TDXRMachine_Color;
  end;

  TDXRMachine_Reg_RHW = record
    Enable: Boolean;
    nRHW: TDXRMachine_Int64;
    iRHW: TDXRMachine_Int64;
  end;

  TDXRMachine_Reg_Dither = record
    Enable: Boolean;
  end;

  TDXRMachine_Reg_ZBuffer = record
    Enable: Boolean;
    Surface: PDXR_Surface;
    CmpFunc: TDXR_CmpFunc;
    WriteEnable: Boolean;
  end;

  TDXRMachine_Reg_Axis = record
    Axis: TDXRMachine_Axis;
    IncEnable: Boolean;
  end;

  PDXRMachine_Tree = ^TDXRMachine_Tree;
  TDXRMachine_Tree = record
    Typ: TDXRMachine_TreeType;
    Channels: TDXRColorChannels;
    case TDXRMachine_TreeType of
      DXR_TREETYPE_LOADBLACK: (
        );
      DXR_TREETYPE_LOADCOLOR: (
        Color: Integer
        );
      DXR_TREETYPE_LOADCONSTCOLOR: (
        ConstColor: TDXRMachine_Color;
        );
      DXR_TREETYPE_LOADTEXTURE: (
        Texture: Integer
        );
      DXR_TREETYPE_LOADBUMPTEXTURE: (
        _Texture: Integer;
        BumpTexture: Integer;
        );
      DXR_TREETYPE_LOADDESTPIXEL: (
        );
      DXR_TREETYPE_BLEND: (
        Blend: TDXR_Blend;
        BlendTree1: PDXRMachine_Tree;
        BlendTree2: PDXRMachine_Tree;
        );
  end;

  TDXRMachine = class
  private
    FBuf: Pointer;
    FCall: Pointer;
    FCompiled: Boolean;
    FTreeCount: Integer;
    FTreeList: array[0..127] of TDXRMachine_Tree;
    FMMXUsed: Boolean;
    F_ZBuf: Pointer;
    F_BiLinearAxis: TDXRMachine_Axis;
    F_BiLinearCol1: TDXRMachine_Color;
    F_BiLinearCol2: TDXRMachine_Color;
    F_BiLinearCol3: TDXRMachine_Color;
    F_BiLinearCol4: TDXRMachine_Color;
    F_BumpAxis: TDXRMachine_Axis;
    F_BumpAxis2: TDXRMachine_Axis;
    F_BumpTempCol: DWORD;
    FStack: array[0..255] of TDXRMachine_Color;
    procedure GenerateCode(var Code: Pointer; Tree: PDXRMachine_Tree);
  public
    Dest: PDXR_Surface;
    ColorList: array[0..7] of TDXRMachine_Reg_Color;
    ColorIndex: array[0..7] of Integer;
    ColorIndexCount: Integer;
    TextureList: array[0..7] of TDXRMachine_Reg_Texture;
    TextureIndex: array[0..7] of Integer;
    TextureIndexCount: Integer;
    Dither: TDXRMachine_Reg_Dither;
    ZBuffer: TDXRMachine_Reg_ZBuffer;
    Axis: TDXRMachine_Reg_Axis;
    RHW: TDXRMachine_Reg_RHW;
    constructor Create;
    destructor Destroy; override;
    function CreateTree: PDXRMachine_Tree;
    function CreateTree2(Typ: TDXRMachine_TreeType): PDXRMachine_Tree;
    function CreateTree_LoadColor(Color: DWORD): PDXRMachine_Tree;
    function CreateTree_LoadConstColor(R, G, B, A: Byte): PDXRMachine_Tree;
    function CreateTree_LoadTexture(Texture: DWORD): PDXRMachine_Tree;
    function CreateTree_LoadBumpTexture(Texture, BumpTexture: DWORD): PDXRMachine_Tree;
    function CreateTree_Blend(Blend: TDXR_Blend; BlendTree1, BlendTree2: PDXRMachine_Tree): PDXRMachine_Tree;
    procedure Initialize;
    procedure Compile(Tree: PDXRMachine_Tree);
    procedure Run(Count: Integer);
    property Compiled: Boolean read FCompiled write FCompiled;
  end;

const
  CPUIDF_FPU  = 1 shl 0;  {  Floating-point unit on-chip  }
  CPUIDF_VME  = 1 shl 1;  {  Virtual Mode Extension  }
  CPUIDF_DE   = 1 shl 2;  {  Debugging Extension  }
  CPUIDF_PSE  = 1 shl 3;  {  Page Size Extension  }
  CPUIDF_TSC  = 1 shl 4;  {  Time Stamp Counter  }
  CPUIDF_MSR  = 1 shl 5;  {  Mode Spacific Registers  }
  CPUIDF_PAE  = 1 shl 6;  {  Physical Address Extension  }
  CPUIDF_MCE  = 1 shl 7;  {  Machine Check Exception  }
  CPUIDF_CX8  = 1 shl 8;  {  CMPXCHG8 Instruction Supported  }
  CPUIDF_APIC = 1 shl 9;  {  On-chip APIC Hardware Supported }
  CPUIDF_MTRR = 1 shl 12; {  Memory Type Range Registers  }
  CPUIDF_PGE  = 1 shl 13; {  Page Global Enable  }
  CPUIDF_MCA  = 1 shl 14; {  Machine Check Architecture  }
  CPUIDF_CMOV = 1 shl 15; {  Conditional Move Instruction Supported  }
  CPUIDF_MMX  = 1 shl 23; {  Intel Architecture MMX Technology supported  }

var
  CPUIDVendor: array[0..11] of Char;
  CPUIDSignature: Integer;
  CPUIDFeatures: Integer;
  UseMMX: Boolean;

  RenderPrimitiveCount: Integer;

procedure ReadCPUID; 
begin
  asm
    push ebx

    pushfd
    pop eax
    mov ecx,eax
    xor eax,$200000
    push eax
    popfd
    pushfd
    pop eax
    xor eax,ecx
    jz @@exit

    mov eax,0
    db $0F,$A2                  ///cpuid
    cmp eax,1
    jl @@exit

    {  Vendor ID  }
    mov eax,0
    db $0F,$A2                  ///cpuid
    mov dword ptr [CPUIDVendor], ebx
    mov dword ptr [CPUIDVendor+4], edx
    mov dword ptr [CPUIDVendor+8], ecx

    {  Features, Signature  }
    mov eax,1
    db $0F,$A2                  ///cpuid
    mov CPUIDSignature,eax
    mov CPUIDFeatures,edx
  @@exit:
    pop ebx
  end;
  UseMMX := CPUIDFeatures and CPUIDF_MMX<>0;
end;

function dxrGetOption(Option: TDXR_Option): DWORD;
begin
  Result := 0;
  case Option of
    DXR_OPTION_VERSION:
        begin
          Result := 1*100 + 0;
        end;
    DXR_OPTION_MMXENABLE:
        begin
          Result := DWORD(LongBool(UseMMX));
        end;
    DXR_OPTION_RENDERPRIMITIVES:
        begin
          Result := RenderPrimitiveCount;
        end;
  end;
end;

procedure dxrSetOption(Option: TDXR_Option; Value: DWORD);
begin
  case Option of
    DXR_OPTION_MMXENABLE:
        begin
          UseMMX := LongBool(Value) and (CPUIDFeatures and CPUIDF_MMX<>0);
        end;
    DXR_OPTION_RENDERPRIMITIVES:
        begin
          RenderPrimitiveCount := Value;
        end;
  end;
end;

function GetBitCount(B: Integer): DWORD;
begin
  Result := 31;
  while (Result>0) and (((1 shl Result) and B)=0) do Dec(Result);
end;

function GetFirstZeroBitCount(B: Integer): DWORD;
begin
  Result := 0;
  while (Result<31) and (((1 shl Result) and B)=0) do Inc(Result);
end;

function GetOneBitCount(B: Integer): DWORD;
var
  i: Integer;
begin
  Result := 0;
  for i:=0 to 31 do
    Inc(Result, Ord(b and (1 shl i)<>0));
end;

function dxrMakeColorChannel(Mask: DWORD; indexed: Boolean): TDXR_ColorChannel;
var
  i: Integer;
begin
  Result.BitCount := GetOneBitCount(Mask shr (GetFirstZeroBitCount(Mask)));
  Result.Mask := Mask;

  if indexed then
  begin
    Result.rshift := GetFirstZeroBitCount(Mask);
    Result.lshift := 0;
  end else
  begin
    i :=  GetFirstZeroBitCount(Mask)-(8-Result.BitCount);

    if i<0 then
    begin
      Result.lshift := -i;
      Result.rshift := 0;
    end else
    begin
      Result.lshift := 0;
      Result.rshift := DWORD(i);
    end;
  end;
end;

procedure dxrMakeIndexedSurface(var Surface: TDXR_Surface; Width, Height, BitCount: DWORD;
  Bits: Pointer; pitch: Integer; idx_index, idx_alpha: DWORD);
begin
  FillChar(Surface, SizeOf(Surface), 0);

  Surface.ColorType := DXR_COLORTYPE_INDEXED;
  Surface.Width := Width;
  Surface.Height := Height;
  Surface.WidthBit := GetBitCount(Width);
  Surface.HeightBit := GetBitCount(Height);
  Surface.Width2 := 1 shl Surface.WidthBit;
  Surface.Height2 := 1 shl Surface.HeightBit;
  Surface.WidthMask := Surface.Width-1;
  Surface.HeightMask := Surface.Height2-1;

  Surface.BitCount := BitCount;
  Surface.Bits := Bits;
  Surface.Pitch := Pitch;
  Surface.PitchBit := GetBitCount(Abs(Pitch));

  Surface.idx_index := dxrMakeColorChannel(idx_index, True);
  Surface.idx_alpha := dxrMakeColorChannel(idx_alpha, False);
end;

procedure dxrMakeRGBSurface(var Surface: TDXR_Surface; Width, Height, BitCount: DWORD;
  Bits: Pointer; pitch: Integer; rgb_red, rgb_green, rgb_blue, rgb_alpha: DWORD);
begin
  FillChar(Surface, SizeOf(Surface), 0);

  Surface.ColorType := DXR_COLORTYPE_RGB;
  Surface.Width := Width;
  Surface.Height := Height;
  Surface.WidthBit := GetBitCount(Width);
  Surface.HeightBit := GetBitCount(Height);
  Surface.Width2 := 1 shl Surface.WidthBit;
  Surface.Height2 := 1 shl Surface.HeightBit;
  Surface.WidthMask := Surface.Width-1;
  Surface.HeightMask := Surface.Height2-1;

  Surface.BitCount := BitCount;
  Surface.Bits := Bits;
  Surface.Pitch := Pitch;
  Surface.PitchBit := GetBitCount(Abs(Pitch));

  Surface.rgb_red := dxrMakeColorChannel(rgb_red, False);
  Surface.rgb_green := dxrMakeColorChannel(rgb_green, False);
  Surface.rgb_blue := dxrMakeColorChannel(rgb_blue, False);
  Surface.rgb_alpha := dxrMakeColorChannel(rgb_alpha, False);
end;

function dxrCompareSurface(const Surface1, Surface2: TDXR_Surface): Boolean;
begin
  if Surface1.ColorType=DXR_COLORTYPE_INDEXED then
  begin
    Result := (Surface2.ColorType=DXR_COLORTYPE_INDEXED) and
      (Surface1.idx_index.Mask=Surface2.idx_index.Mask) and
      (Surface1.idx_alpha.Mask=Surface2.idx_alpha.Mask);
  end else if Surface1.ColorType=DXR_COLORTYPE_RGB then
  begin
    Result := (Surface2.ColorType=DXR_COLORTYPE_RGB) and
      (Surface1.rgb_red.Mask=Surface2.rgb_red.Mask) and
      (Surface1.rgb_green.Mask=Surface2.rgb_green.Mask) and
      (Surface1.rgb_blue.Mask=Surface2.rgb_blue.Mask) and
      (Surface1.rgb_alpha.Mask=Surface2.rgb_alpha.Mask);
  end else
    Result := False;
end;

function dxrDDSurfaceLock(DDSurface: IDirectDrawSurface; var Surface: TDXR_Surface): Boolean;
var
  ddsd: TDDSurfaceDesc;
begin
  Result := dxrDDSurfaceLock2(DDSurface, ddsd, Surface);
end;

function dxrDDSurfaceLock2(DDSurface: IDirectDrawSurface; var ddsd: TDDSurfaceDesc;
  var Surface: TDXR_Surface): Boolean;
const
  DDPF_PALETTEINDEXED = DDPF_PALETTEINDEXED1 or DDPF_PALETTEINDEXED2 or
    DDPF_PALETTEINDEXED4 or DDPF_PALETTEINDEXED8;
begin
  ddsd.dwSize := SizeOf(ddsd);
  Result := DDSurface.Lock(nil, ddsd, DDLOCK_WAIT, 0)=DD_OK;
  if Result then
  begin
    FillChar(Surface, SizeOf(Surface), 0);
    if ddsd.ddpfPixelFormat.dwFlags and DDPF_PALETTEINDEXED<>0 then
    begin
      dxrMakeIndexedSurface(Surface, ddsd.dwWidth, ddsd.dwHeight, ddsd.ddpfPixelFormat.dwRGBBitCount,
        ddsd.lpSurface, ddsd.lPitch, (1 shl ddsd.ddpfPixelFormat.dwRGBBitCount)-1, 0);
    end else
    begin
      if ddsd.ddpfPixelFormat.dwFlags and DDPF_ALPHAPIXELS<>0 then
      begin
        dxrMakeRGBSurface(Surface, ddsd.dwWidth, ddsd.dwHeight, ddsd.ddpfPixelFormat.dwRGBBitCount,
          ddsd.lpSurface, ddsd.lPitch, ddsd.ddpfPixelFormat.dwRBitMask, ddsd.ddpfPixelFormat.dwGBitMask,
          ddsd.ddpfPixelFormat.dwBBitMask, ddsd.ddpfPixelFormat.dwRGBAlphaBitMask);
      end else
      begin
        dxrMakeRGBSurface(Surface, ddsd.dwWidth, ddsd.dwHeight, ddsd.ddpfPixelFormat.dwRGBBitCount,
          ddsd.lpSurface, ddsd.lPitch, ddsd.ddpfPixelFormat.dwRBitMask, ddsd.ddpfPixelFormat.dwGBitMask,
          ddsd.ddpfPixelFormat.dwBBitMask, 0);
      end;                          
    end;
  end;
end;

procedure dxrDDSurfaceUnLock(DDSurface: IDirectDrawSurface; const Surface: TDXR_Surface);
begin
  DDSurface.Unlock(Surface.Bits);
end;

function dxrScanLine(const Surface: TDXR_Surface; y: DWORD): Pointer;
begin
  Result := Pointer(Integer(Surface.Bits)+Surface.Pitch*Integer(y));
end;

procedure dxrZBufferClear(const Surface: TDXR_Surface);
var
  i: Integer;
begin
  for i:=0 to Surface.Height-1 do
    FillChar(dxrScanLine(Surface, i)^, Abs(Surface.Pitch), $FF);
end;

{  TDXRMachine  }

constructor TDXRMachine.Create;
begin
  inherited Create;
  FBuf := VirtualAlloc(nil, 2048, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
end;

destructor TDXRMachine.Destroy;
begin
  VirtualFree(FBuf, 0, MEM_RELEASE);
  inherited Destroy;
end;

procedure TDXRMachine.Initialize;
begin
  FCall := nil;
  ColorIndexCount := 0;
  TextureIndexCount := 0;

  FTreeCount := 0;

  Dest := nil;
  FCompiled := False;
  FMMXUsed := False;

  FillChar(ColorList, SizeOf(ColorList), 0);
  FillChar(TextureList, SizeOf(TextureList), 0);
  FillChar(Dither, SizeOf(Dither), 0);
  FillChar(ZBuffer, SizeOf(ZBuffer), 0);
  FillChar(Axis, SizeOf(Axis), 0);
  FillChar(RHW, SizeOf(RHW), 0);
end;

function TDXRMachine.CreateTree: PDXRMachine_Tree;
begin
  Result := @FTreeList[FTreeCount];
  FillChar(Result^, SizeOf(Result^), 0);
  Inc(FTreeCount);
end;

function TDXRMachine.CreateTree2(Typ: TDXRMachine_TreeType): PDXRMachine_Tree;
begin
  Result := CreateTree;
  Result.Typ := Typ;
end;

function TDXRMachine.CreateTree_LoadColor(Color: DWORD): PDXRMachine_Tree;
begin
  Result := CreateTree;
  Result.Typ := DXR_TREETYPE_LOADCOLOR;
  Result.Color := Color;
end;

function TDXRMachine.CreateTree_LoadConstColor(R, G, B, A: Byte): PDXRMachine_Tree;
begin
  Result := CreateTree;
  Result.Typ := DXR_TREETYPE_LOADCONSTCOLOR;
  Result.ConstColor.R := R shl 8;
  Result.ConstColor.G := G shl 8;
  Result.ConstColor.B := B shl 8;
  Result.ConstColor.A := A shl 8;
end;

function TDXRMachine.CreateTree_LoadTexture(Texture: DWORD): PDXRMachine_Tree;
begin
  Result := CreateTree;
  Result.Typ := DXR_TREETYPE_LOADTEXTURE;
  Result.Texture := Texture;
end;

function TDXRMachine.CreateTree_LoadBumpTexture(Texture, BumpTexture: DWORD): PDXRMachine_Tree;
begin
  Result := CreateTree;
  Result.Typ := DXR_TREETYPE_LOADBUMPTEXTURE;
  Result.Texture := Texture;
  Result.BumpTexture := BumpTexture;
end;

function TDXRMachine.CreateTree_Blend(Blend: TDXR_Blend; BlendTree1, BlendTree2: PDXRMachine_Tree): PDXRMachine_Tree;
begin
  Result := CreateTree;
  Result.Typ := DXR_TREETYPE_BLEND;
  Result.Blend := Blend;
  Result.BlendTree1 := BlendTree1;
  Result.BlendTree2 := BlendTree2;
end;

procedure TDXRMachine.Compile;

  function GetSurfaceChannels(const Surface: TDXR_Surface): TDXRColorChannels;
  begin
    Result := [];

    if Surface.ColorType=DXR_COLORTYPE_INDEXED then
    begin
      if Surface.idx_index.Mask<>0 then Result := Result + [chRed, chGreen, chBlue];
      if Surface.idx_alpha.Mask<>0 then Result := Result + [chAlpha];
    end else
    begin
      if Surface.rgb_red.Mask<>0 then Result := Result + [chRed];
      if Surface.rgb_green.Mask<>0 then Result := Result + [chGreen];
      if Surface.rgb_blue.Mask<>0 then Result := Result + [chBlue];
      if Surface.rgb_alpha.Mask<>0 then Result := Result + [chAlpha];
    end;
  end;

  procedure OptimizeTree(var Tree: PDXRMachine_Tree);

    procedure GetBlendChannels(Blend: TDXR_Blend; var Col1_1, Col1_2, Col2_1, Col2_2: TDXRColorChannels);
    begin
      case Blend of
        DXR_BLEND_ZERO:
          begin
            Col1_1 := [];
            Col1_2 := [];
            Col2_1 := [];
            Col2_2 := [];
          end;
        DXR_BLEND_ONE1:
          begin
            Col1_1 := [chRed, chGreen, chBlue, chAlpha];
            Col1_2 := [];
            Col2_1 := [];
            Col2_2 := [];
          end;
        DXR_BLEND_ONE2:
          begin
            Col1_1 := [];
            Col1_2 := [];
            Col2_1 := [chRed, chGreen, chBlue, chAlpha];
            Col2_2 := [];
          end;
        DXR_BLEND_ONE1_ADD_ONE2, DXR_BLEND_ONE1_SUB_ONE2:
          begin
            Col1_1 := [chRed, chGreen, chBlue, chAlpha];
            Col1_2 := [];
            Col2_1 := [chRed, chGreen, chBlue, chAlpha];
            Col2_2 := [];
          end;
        DXR_BLEND_ONE2_SUB_ONE1, DXR_BLEND_ONE1_MUL_ONE2:
          begin
            Col1_1 := [chRed, chGreen, chBlue, chAlpha];
            Col1_2 := [];
            Col2_1 := [chRed, chGreen, chBlue, chAlpha];
            Col2_2 := [];
          end;
        DXR_BLEND_SRCALPHA1:
          begin
            Col1_1 := [chRed, chGreen, chBlue];
            Col1_2 := [chAlpha];
            Col2_1 := [];
            Col2_2 := [];
          end;
        DXR_BLEND_SRCALPHA1_ADD_ONE2:
          begin
            Col1_1 := [chRed, chGreen, chBlue];
            Col1_2 := [chAlpha];
            Col2_1 := [chRed, chGreen, chBlue, chAlpha];
            Col2_2 := [];
          end;
        DXR_BLEND_ONE2_SUB_SRCALPHA1:
          begin
            Col1_1 := [chRed, chGreen, chBlue];
            Col1_2 := [chAlpha];
            Col2_1 := [chRed, chGreen, chBlue, chAlpha];
            Col2_2 := [];
          end;
        DXR_BLEND_SRCALPHA1_ADD_INVSRCALPHA2:
          begin
            Col1_1 := [chRed, chGreen, chBlue];
            Col1_2 := [chAlpha];
            Col2_1 := [chRed, chGreen, chBlue, chAlpha];
            Col2_2 := [];
          end;
        DXR_BLEND_INVSRCALPHA1_ADD_SRCALPHA2:
          begin
            Col1_1 := [chRed, chGreen, chBlue];
            Col1_2 := [chAlpha];
            Col2_1 := [chRed, chGreen, chBlue, chAlpha];
            Col2_2 := [];
          end;

        DXR_BLEND_DECAL:
          begin
            Col1_1 := [chRed, chGreen, chBlue, chAlpha];
            Col1_2 := [];
            Col2_1 := [];
            Col2_2 := [];
          end;
        DXR_BLEND_DECALALPHA:
          begin
            Col1_1 := [chRed, chGreen, chBlue];
            Col1_2 := [];
            Col2_1 := [];
            Col2_2 := [chAlpha];
          end;
        DXR_BLEND_MODULATE:
          begin
            Col1_1 := [chRed, chGreen, chBlue, chAlpha];
            Col1_2 := [];
            Col2_1 := [chRed, chGreen, chBlue, chAlpha];
            Col2_2 := [];
          end;
        DXR_BLEND_MODULATEALPHA:
          begin
            Col1_1 := [chRed, chGreen, chBlue];
            Col1_2 := [chAlpha];
            Col2_1 := [chRed, chGreen, chBlue];
            Col2_2 := [chAlpha];
          end;
        DXR_BLEND_ADD:
          begin
            Col1_1 := [chRed, chGreen, chBlue, chAlpha];
            Col1_2 := [];
            Col2_1 := [chRed, chGreen, chBlue, chAlpha];
            Col2_2 := [];
          end;
      end;
    end;

  var
    c: TDXRColorChannels;
    Col1_1, Col1_2, Col2_1, Col2_2: TDXRColorChannels;
  begin
    case Tree.Typ of
      DXR_TREETYPE_LOADBLACK:
          begin
            // Load black color
          end;
      DXR_TREETYPE_LOADCOLOR:
          begin
            // Load color
          end;
      DXR_TREETYPE_LOADTEXTURE:
          begin
            // Load texel
          end;
      DXR_TREETYPE_LOADBUMPTEXTURE:
          begin
            // Load texel with Bump mapping
          end;
      DXR_TREETYPE_LOADDESTPIXEL:
          begin
            // Load dest pixel
          end;
      DXR_TREETYPE_BLEND:
          begin
            // Blend color
            GetBlendChannels(Tree.Blend, Col1_1, Col1_2, Col2_1, Col2_2);

            Tree.BlendTree1.Channels := Tree.Channels*Col1_1+Col1_2;
            Tree.BlendTree2.Channels := Tree.Channels*Col2_1+Col2_2;

            OptimizeTree(Tree.BlendTree1);
            OptimizeTree(Tree.BlendTree2);

            if (Tree.Blend=DXR_BLEND_ZERO) then
            begin
              c := Tree.Channels; Tree^.Typ := DXR_TREETYPE_LOADBLACK; Tree.Channels := c;
            end else
            if (Tree.Blend in [DXR_BLEND_ONE1, DXR_BLEND_DECAL]) then
            begin
              c := Tree.Channels; Tree := Tree.BlendTree1; Tree.Channels := c;
            end else
            if (Tree.Blend=DXR_BLEND_ONE2) then
            begin
              c := Tree.Channels; Tree := Tree.BlendTree2; Tree.Channels := c;
            end else
            if (Tree.Blend in [DXR_BLEND_ONE1_ADD_ONE2, DXR_BLEND_ONE2_SUB_ONE1]) and
              (Tree.BlendTree2.Typ=DXR_TREETYPE_LOADBLACK) then
            begin
              c := Tree.Channels; Tree := Tree.BlendTree1; Tree.Channels := c;
            end else
            if (Tree.Blend in [DXR_BLEND_ONE1_ADD_ONE2, DXR_BLEND_ONE2_SUB_ONE1]) and
              (Tree.BlendTree1.Typ=DXR_TREETYPE_LOADBLACK) then
            begin
              c := Tree.Channels; Tree := Tree.BlendTree2; Tree.Channels := c;
            end else
            begin
              if (Col1_1=[]) and (Col1_2=[]) then Tree.BlendTree1 := nil;
              if (Col2_1=[]) and (Col2_2=[]) then Tree.BlendTree2 := nil;
            end;
          end;
    end;
  end;

  procedure GetEnableChannels(Tree: PDXRMachine_Tree);
  begin
    case Tree.Typ of
      DXR_TREETYPE_LOADBLACK:
          begin
            // Load black color
          end;
      DXR_TREETYPE_LOADCOLOR:
          begin
            // Load color
            ColorList[Tree.Color].Channels := ColorList[Tree.Color].Channels + Tree.Channels;
            ColorList[Tree.Color].Enable := ColorList[Tree.Color].Channels<>[];
          end;
      DXR_TREETYPE_LOADTEXTURE:
          begin
            // Load texel
            TextureList[Tree.Texture].EnableChannels := TextureList[Tree.Texture].EnableChannels +
              Tree.Channels*GetSurfaceChannels(TextureList[Tree.Texture].Surface^);
            TextureList[Tree.Texture].Enable := TextureList[Tree.Texture].EnableChannels<>[];
          end;
      DXR_TREETYPE_LOADBUMPTEXTURE:
          begin
            // Load texel with Bump mapping
            TextureList[Tree.Texture].EnableChannels := TextureList[Tree.Texture].EnableChannels +
              Tree.Channels*GetSurfaceChannels(TextureList[Tree.Texture].Surface^);
            TextureList[Tree.Texture].Enable := TextureList[Tree.Texture].EnableChannels<>[];
            TextureList[Tree.BumpTexture].Enable := True;
          end;
      DXR_TREETYPE_LOADDESTPIXEL:
          begin
            // Load dest pixel
          end;
      DXR_TREETYPE_BLEND:
          begin
            // Blend color
            if Tree.BlendTree1<>nil then GetEnableChannels(Tree.BlendTree1);
            if Tree.BlendTree2<>nil then GetEnableChannels(Tree.BlendTree2);
          end;
    end;
  end;

var
  Code: Pointer;
  i: Integer;
begin
  {  Optimize tree  }
  Tree.Channels := GetSurfaceChannels(Dest^);
  OptimizeTree(Tree);

  {  Get enable channels  }
  GetEnableChannels(Tree);

  for i:=Low(ColorList) to High(ColorList) do
    if ColorList[i].Enable then
    begin
      ColorIndex[ColorIndexCount] := i;
      Inc(ColorIndexCount);
    end;

  for i:=Low(TextureList) to High(TextureList) do
    if TextureList[i].Enable then
    begin
      TextureIndex[TextureIndexCount] := i;
      Inc(TextureIndexCount);
    end;

  ZBuffer.Enable := ZBuffer.Surface<>nil;

  RHW.Enable := ZBuffer.Enable;
  Axis.IncEnable := Dither.Enable;

  {  Generate X86 code  }
  Code := FBuf; GenerateCode(Code, Tree);

  FCompiled := True;
end;

const
  Mask1: array[0..7] of DWORD= ($80, $40, $20, $10, $08, $04, $02, $01);
  Mask2: array[0..3] of DWORD= ($C0, $30, $0C, $03);
  Mask4: array[0..1] of DWORD= ($F0, $0F);

  Shift1: array[0..7] of DWORD= (7, 6, 5, 4, 3, 2, 1, 0);
  Shift2: array[0..3] of DWORD= (6, 4, 2, 0);
  Shift4: array[0..1] of DWORD= (4, 0);

var
  _null: Byte;

  // Saturation addition table
  //   Result := Min(n+j, 255)
  _AddTable: array[0..256*2-1] of Byte;
  _SubTable: array[-255..255] of Byte;

  // Byte to QWORD convert table
  //   Result := (n shl 56)+(n shl 48)+(n shl 32)+(n shl 24)+(n shl 16)+(n shl 8)+n
  _ByteToQWORDTable: array[0..255, 0..3] of WORD;

  _BlackColor: TDXRMachine_Color = (R: 0; G: 0; B: 0; A: 0);

procedure Init;
var
  i: Integer;
begin
  for i:=Low(_AddTable) to High(_AddTable) do
  begin
    if i>255 then
      _AddTable[i] := 255
    else
      _AddTable[i] := i;
  end;

  for i:=Low(_SubTable) to High(_SubTable) do
  begin
    if i<0 then
      _SubTable[i] := 0
    else
      _SubTable[i] := i;
  end;

  for i:=0 to 255 do
  begin
    _ByteToQWORDTable[i, 0] := i;
    _ByteToQWORDTable[i, 1] := i;
    _ByteToQWORDTable[i, 2] := i;
    _ByteToQWORDTable[i, 3] := i;
  end;
end;

procedure TDXRMachine.GenerateCode(var Code: Pointer; Tree: PDXRMachine_Tree);
var
  SkipAddress: Pointer;

  procedure genCmpFunc(var Code: Pointer; Func: TDXR_CmpFunc; JmpAdress: Pointer);

    procedure genShortJmp(var Code: Pointer; JmpCode: Pointer; sC: Byte);
    type
      PShortJmp = ^TShortJmp;
      TShortJmp = packed record
        c: Byte;
        A: ShortInt;
      end;
    begin
      with PShortJmp(Code)^ do
      begin
        c := sC;
        A := Integer(JmpCode)-(Integer(Code)+2);
      end;
      Inc(Integer(Code), 2);
    end;

    procedure genNearJmp(var Code: Pointer; JmpCode: Pointer; nC: Byte);
    type
      PNearJmp = ^TNearJmp;
      TNearJmp = packed record
        c: Byte;
        A: Integer;
      end;
    begin
      with PNearJmp(Code)^ do
      begin
        c := nC;
        A := Integer(JmpCode)-(Integer(Code)+5);
      end;
      Inc(Integer(Code), 5);
    end;

    procedure genNearJmp2(var Code: Pointer; JmpCode: Pointer; nC1, nC2: Byte);
    type
      PNearJmp2 = ^TNearJmp2;
      TNearJmp2 = packed record
        c1, c2: Byte;
        A: Integer;
      end;
    begin
      with PNearJmp2(Code)^ do
      begin
        c1 := nC1;
        c2 := nC2;
        A := Integer(JmpCode)-(Integer(Code)+6);
      end;
      Inc(Integer(Code), 6);
    end;

    procedure genFlagJmp(var Code: Pointer; JmpCode: Pointer; sC, nC1, nC2: Byte);
    var
      i: Integer;
    begin
      i := Integer(JmpCode)-(Integer(Code)+2);
      if abs(i)<128 then
        genShortJmp(Code, JmpCode, sC)
      else
        genNearJmp2(Code, JmpCode, nC1, nC2);
    end;

    procedure genJmp(var Code: Pointer; JmpCode: Pointer);
    var
      i: Integer;
    begin
      i := Integer(JmpCode)-(Integer(Code)+2);
      if abs(i)<128 then
        genShortJmp(Code, JmpCode, $EB)
      else
        genNearJmp(Code, JmpCode, $E9);
    end;

  begin
    case Func of
      DXR_CMPFUNC_NEVER:
          begin
            {  if (False) then Jump }
          end;
      DXR_CMPFUNC_LESS:
          begin
            {  if (New<Old) then Jump  }
            genFlagJmp(Code, JmpAdress, $7C, $0F, $8C);
          end;
      DXR_CMPFUNC_EQUAL:
          begin
            {  if (New=Old) then Jump  }
            genFlagJmp(Code, JmpAdress, $74, $0F, $84);
          end;
      DXR_CMPFUNC_LESSEQUAL:
          begin
            {  if (New<=Old) then Jump  }
            genFlagJmp(Code, JmpAdress, $7E, $0F, $8E);
          end;
      DXR_CMPFUNC_GREATER:
          begin
            {  if (New>Old) then Jump  }
            genFlagJmp(Code, JmpAdress, $7F, $0F, $8F);
          end;
      DXR_CMPFUNC_NOTEQUAL:
          begin
            {  if (New<>Old) then Jump  }
            genFlagJmp(Code, JmpAdress, $75, $0F, $85);
          end;
      DXR_CMPFUNC_GREATEREQUAL:
          begin
            {  if (New>=Old) then Jump  }
            genFlagJmp(Code, JmpAdress, $7D, $0F, $8D);
          end;
      DXR_CMPFUNC_ALWAYS:
          begin
            {  if (True) then Break }
            genJmp(Code, JmpAdress);
          end;
    end;
  end;

  procedure genInitDestAddress(var Code: Pointer);
  var
    _Axis: Pointer;
    ByteCount, Pitch: DWORD;
    Bits: Pointer;
  begin
    _Axis := @Axis.Axis;

    ByteCount := Dest.BitCount shr 3;
    Pitch := Dest.pitch;
    Bits := Dest.Bits;

    asm
      jmp @@EndCode
    @@StartCode:
      mov eax,dword ptr [offset _null]{}@@AxisX:
      imul eax,$11{}        @@ByteCount: // Dest.BitCount div 8
      mov edi,dword ptr [offset _null]{}@@AxisY:
      imul edi,$11111111{}  @@Pitch: // Dest.pitch
      add edi,$11111111{}   @@Bits:  // Dest.Bits
      add edi,eax
    @@EndCode:
      {$I DXRender.inc}
      {  @@AxisX  }
      mov eax,_Axis; add eax,TDXRMachine_Axis.X
      mov edx,offset @@AxisX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@AxisY  }
      mov eax,_Axis; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@AxisY-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@ByteCount  }
      mov eax,ByteCount
      mov edx,offset @@ByteCount-1
      sub edx,offset @@StartCode
      mov byte ptr [ecx+edx],al

      {  @@Pitch  }
      mov eax,Pitch
      mov edx,offset @@Pitch-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@Bits  }
      mov eax,Bits
      mov edx,offset @@Bits-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;
  end;

  procedure genInitZBuffer(var Code: Pointer);
  var
    _Axis: Pointer;
    ByteCount, Pitch: DWORD;
    Bits, _ZBuf: Pointer;
  begin
    if not ZBuffer.Enable then Exit;

    _Axis := @Axis.Axis;

    ByteCount := ZBuffer.Surface.BitCount div 8;
    Pitch := ZBuffer.Surface.Pitch;
    Bits := ZBuffer.Surface.Bits;

    _ZBuf := @F_ZBuf;

    asm
      jmp @@EndCode
    @@StartCode:
      mov edx,dword ptr [offset _null]{}@@AxisX:
      imul edx,$11{}        @@ByteCount: // States.ZBuffer.BitCount div 8
      mov eax,dword ptr [offset _null]{}@@AxisY:
      imul eax,$11111111{}  @@Pitch: // States.ZBuffer.pitch
      add eax,$11111111{}   @@Bits:  // States.ZBuffer.Bits
      add eax,edx
      mov dword ptr [offset _null],eax{}@@_ZBuf:
    @@EndCode:
      {$I DXRender.inc}
      {  @@AxisX  }
      mov eax,_Axis; add eax,TDXRMachine_Axis.X
      mov edx,offset @@AxisX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@AxisY  }
      mov eax,_Axis; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@AxisY-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@ByteCount  }
      mov eax,ByteCount
      mov edx,offset @@ByteCount-1
      sub edx,offset @@StartCode
      mov byte ptr [ecx+edx],al

      {  @@Pitch  }
      mov eax,Pitch
      mov edx,offset @@Pitch-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@Bits  }
      mov eax,Bits
      mov edx,offset @@Bits-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@_ZBuf  }
      mov eax,_ZBuf
      mov edx,offset @@_ZBuf-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;
  end;

  procedure genZBufferTest(var Code: Pointer);
  var
    _ZBuf, _RHW: Pointer;
  begin
    if not ZBuffer.Enable then Exit;

    _ZBuf := @F_ZBuf;
    _RHW := @RHW.nRHW;

    asm
      jmp @@EndCode
    @@StartCode:
      mov edx,dword ptr [offset _null]{}@@_ZBuf:
      mov ebx,dword ptr [offset _null]{}@@_RHW:
    @@EndCode:
      {$I DXRender.inc}
      {  @@_ZBuf  }
      mov eax,_ZBuf
      mov edx,offset @@_ZBuf-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@_RHW  }
      mov eax,_RHW; add eax,4
      mov edx,offset @@_RHW-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;

    if ZBuffer.CmpFunc<>DXR_CMPFUNC_ALWAYS then
    begin
      case ZBuffer.Surface.BitCount of
        8: begin
             asm
               jmp @@EndCode
             @@StartCode:
               movzx eax,byte ptr [edx]
             @@EndCode:
               {$I DXRender.inc}
             end;
           end;
       16: begin
             asm
               jmp @@EndCode
             @@StartCode:
               movzx eax,word ptr [edx]
             @@EndCode:
               {$I DXRender.inc}
             end;
           end;
       24: begin
             asm
               jmp @@EndCode
             @@StartCode:
               movzx ax,byte ptr [edx+2]
               shl eax,16
               mov ax,word ptr [edx]
             @@EndCode:
               {$I DXRender.inc}
             end;
           end;
       32: begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov eax,dword ptr [edx]
             @@EndCode:
               {$I DXRender.inc}
             end;
           end;
      end;

      asm
        jmp @@EndCode
      @@StartCode:
        cmp eax,ebx
      @@EndCode:
        {$I DXRender.inc}
      end;
      genCmpFunc(Code, ZBuffer.CmpFunc, SkipAddress);
    end;

    if ZBuffer.WriteEnable then
    begin
      case ZBuffer.Surface.BitCount of
        8: begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov byte ptr [edx],bl
             @@EndCode:
               {$I DXRender.inc}
             end;
           end;
       16: begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov word ptr [edx],bx
             @@EndCode:
               {$I DXRender.inc}
             end;
           end;
       24: begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov word ptr [edx],bx
               bswap ebx
               mov byte ptr [edx+2],bh
             @@EndCode:
               {$I DXRender.inc}
             end;
           end;
       32: begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov dword ptr [edx],ebx
             @@EndCode:
               {$I DXRender.inc}
             end;
           end;
      end;
    end;
  end;

  procedure genUpdateZBufferAddress(var Code: Pointer);
  var
    ByteCount: DWORD;
    _ZBuf: Pointer;
  begin
    if not ZBuffer.Enable then Exit;

    ByteCount := ZBuffer.Surface.BitCount shr 3;

    _ZBuf := @F_ZBuf;

    asm
      jmp @@EndCode
    @@StartCode:
      add dword ptr [offset _null],$11{}@@_ZBuf:
    @@EndCode:
      {$I DXRender.inc}
      {  @@_ZBuf  }
      mov eax,ByteCount
      mov edx,offset @@_ZBuf-1
      sub edx,offset @@StartCode
      mov byte ptr [ecx+edx],al

      {  @@_ZBuf  }
      mov eax,_ZBuf
      mov edx,offset @@_ZBuf-5
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;
  end;

  procedure genReadDestPixel(var Code: Pointer);
  begin
    case Dest.BitCount of
      8: begin
           asm
             jmp @@EndCode
           @@StartCode:
             movzx eax,byte ptr [edi]
           @@EndCode:
             {$I DXRender.inc}
           end;
         end;
     16: begin
           asm
             jmp @@EndCode
           @@StartCode:
             movzx eax,word ptr [edi]
           @@EndCode:
             {$I DXRender.inc}
           end;
         end;
     24: begin
           asm
             jmp @@EndCode
           @@StartCode:
             movzx eax,byte ptr [edi+2]
             shl eax,16
             mov ax,word ptr [edi]
           @@EndCode:
             {$I DXRender.inc}
           end;
         end;
     32: begin
           asm
             jmp @@EndCode
           @@StartCode:
             mov eax,dword ptr [edi]
           @@EndCode:
             {$I DXRender.inc}
           end;
         end;
    end;
  end;

  procedure genWriteDestPixel(var Code: Pointer);
  begin
    case Dest.BitCount of
      8: begin
           asm
             jmp @@EndCode
           @@StartCode:
             mov byte ptr [edi],al
           @@EndCode:
             {$I DXRender.inc}
           end;
         end;
     16: begin
           asm
             jmp @@EndCode
           @@StartCode:
             mov word ptr [edi],ax
           @@EndCode:
             {$I DXRender.inc}
           end;
         end;
     24: begin
           asm
             jmp @@EndCode
           @@StartCode:
             mov word ptr [edi],ax
             bswap eax
             mov byte ptr [edi+2],ah
           @@EndCode:
             {$I DXRender.inc}
           end;
         end;
     32: begin
           asm
             jmp @@EndCode
           @@StartCode:
             mov dword ptr [edi],eax
           @@EndCode:
             {$I DXRender.inc}
           end;
         end;
    end;
  end;

  procedure genUpdateDestAddress(var Code: Pointer);
  var
    ByteCount: DWORD;
  begin
    ByteCount := Dest.BitCount shr 3;

    if ByteCount=1 then
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        inc edi
      @@EndCode:
        {$I DXRender.inc}
      end;
    end else
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        add edi,$11{}@@ByteCount:    // Dest.BitCount div 8;
      @@EndCode:
        {$I DXRender.inc}
        {  @@ByteCount  }
        mov eax,ByteCount
        mov edx,offset @@ByteCount-1
        sub edx,offset @@StartCode
        mov byte ptr [ecx+edx],al
      end;
    end;
  end;

  procedure genReadSurfacePixel_Tile(var Code: Pointer; const Source: TDXR_Surface; Axis: PDXRMachine_Axis);
  begin
    case Source.BitCount of
      1: begin
           asm
             jmp @@EndCode
           @@StartCode:
             mov esi,dword ptr [offset _null]{}//TexY
                                 @@TexY:
             shr esi,16
             and esi,$11111111{} @@MaskY:   // Source.HeightMask
             imul esi,$11111111{}@@Pitch:   // Source.pitch
             mov edx,dword ptr [offset _null]{}//TexX
                                 @@TexX:
             shr edx,16
             and edx,$11111111{} @@MaskX:   // Source.WidthMask
             mov ebx,edx
             shr edx,3
             and ebx,7
             movzx eax,byte ptr [esi+edx+$11111111]
                                 @@Bits:   // Source.Bits
             and eax,dword ptr [offset Mask1+ebx*4]
             push ecx
             mov ecx,dword ptr [offset Shift1+ebx*4]
             shr eax,cl
             pop ecx
           @@EndCode:
             {$I DXRender.inc}
             {  @@TexX  }
             mov eax,Axis; add eax,TDXRMachine_Axis.X
             mov edx,offset @@TexX-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@TexY  }
             mov eax,Axis; add eax,TDXRMachine_Axis.Y
             mov edx,offset @@TexY-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@MaskY  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.HeightMask]
             mov edx,offset @@MaskY-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Pitch  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Pitch]
             mov edx,offset @@Pitch-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@MaskX  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.WidthMask]
             mov edx,offset @@MaskX-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Bits  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
             mov edx,offset @@Bits-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax
           end;
         end;
      2: begin
           asm
             jmp @@EndCode
           @@StartCode:
             mov esi,dword ptr [offset _null]{}//TexY
                                 @@TexY:
             shr esi,16
             and esi,$11111111{} @@MaskY:  // Source.HeightMask
             imul esi,$11111111{}@@Pitch:  // Source.pitch
             mov edx,dword ptr [offset _null]{}//TexX
                                 @@TexX:
             shr edx,16
             and edx,$11111111{} @@MaskX:  // Source.WidthMask
             mov ebx,edx
             shr edx,2
             and ebx,3
             movzx eax,byte ptr [esi+edx+$11111111]
                                 @@Bits:   // Source.Bits
             and eax,dword ptr [offset Mask2+ebx*4]
             push ecx
             mov ecx,dword ptr [offset Shift2+ebx*4]
             shr eax,cl
             pop ecx
           @@EndCode:
             {$I DXRender.inc}
             {  @@TexX  }
             mov eax,Axis; add eax,TDXRMachine_Axis.X
             mov edx,offset @@TexX-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@TexY  }
             mov eax,Axis; add eax,TDXRMachine_Axis.Y
             mov edx,offset @@TexY-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@MaskY  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.HeightMask]
             mov edx,offset @@MaskY-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Pitch  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Pitch]
             mov edx,offset @@Pitch-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@MaskX  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.WidthMask]
             mov edx,offset @@MaskX-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax
             {  @@Bits  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
             mov edx,offset @@Bits-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax
           end;
         end;
      4: begin
           asm
             jmp @@EndCode
           @@StartCode:
             mov esi,dword ptr [offset _null]{}//TexY
                                 @@TexY:
             shr esi,16
             and esi,$11111111{} @@MaskY:  // Source.HeightMask
             imul esi,$11111111{}@@Pitch:  // Source.pitch
             mov edx,dword ptr [offset _null]{}//TexX
                                 @@TexX:
             shr edx,16
             and edx,$11111111{} @@MaskX:  // Source.WidthMask
             mov ebx,edx
             shr edx,1
             and ebx,1
             movzx eax,byte ptr [esi+edx+$11111111]
                                 @@Bits:   // Source.Bits
             and eax,dword ptr [offset Mask4+ebx*4]
             push ecx
             mov ecx,dword ptr [offset Shift4+ebx*4]
             shr eax,cl
             pop ecx
           @@EndCode:
             {$I DXRender.inc}
             {  @@TexX  }
             mov eax,Axis; add eax,TDXRMachine_Axis.X
             mov edx,offset @@TexX-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@TexY  }
             mov eax,Axis; add eax,TDXRMachine_Axis.Y
             mov edx,offset @@TexY-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@MaskY  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.HeightMask]
             mov edx,offset @@MaskY-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Pitch  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Pitch]
             mov edx,offset @@Pitch-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@MaskX  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.WidthMask]
             mov edx,offset @@MaskX-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Bits  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
             mov edx,offset @@Bits-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax
           end;
         end;
      8: begin
           if Source.pitch=(1 shl Source.PitchBit) then
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,$11{}       @@YShift: // 16-Source.PitchBit
               shr edx,16
               and esi,$11111111{} @@MaskY:  // Source.HeightMask shl Source.PitchBit
               and edx,$11111111{} @@MaskX:  // Source.WidthMask
               movzx eax,byte ptr [$11111111+esi+edx]
                                   @@Bits:   // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@YShift  }
               push ebx
               mov eax,16
               mov ebx,Source; sub eax,[ebx + TDXR_Surface.PitchBit]
               pop ebx
               mov edx,offset @@YShift-1
               sub edx,offset @@StartCode
               mov byte ptr [ecx+edx],al

               {  @@MaskY  }
               push ecx
               mov ecx,Source; mov ecx,[ecx + TDXR_Surface.PitchBit]
               mov eax,Source; mov eax,[eax + TDXR_Surface.HeightMask]
               shl eax,cl
               pop ecx
               mov edx,offset @@MaskY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@MaskX  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.WidthMask]
               mov edx,offset @@MaskX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end else
           if -Source.pitch=(1 shl Source.PitchBit) then
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,$11{}       @@YShift: // 16-Source.PitchBit
               shr edx,16
               and esi,$11111111{} @@MaskY:  // Source.HeightMask shl Source.PitchBit
               and edx,$11111111{} @@MaskX:  // Source.WidthMask
               neg esi
               movzx eax,byte ptr [$11111111+esi+edx]
                                   @@Bits:   // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@YShift  }
               push ebx
               mov eax,16
               mov ebx,Source; sub eax,[ebx + TDXR_Surface.PitchBit]
               pop ebx
               mov edx,offset @@YShift-1
               sub edx,offset @@StartCode
               mov byte ptr [ecx+edx],al

               {  @@MaskY  }
               push ecx
               mov ecx,Source; mov ecx,[ecx + TDXR_Surface.PitchBit]
               mov eax,Source; mov eax,[eax + TDXR_Surface.HeightMask]
               shl eax,cl
               pop ecx
               mov edx,offset @@MaskY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@MaskX  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.WidthMask]
               mov edx,offset @@MaskX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end else
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,16
               shr edx,16
               and esi,$11111111{} @@MaskY:  // Source.HeightMask
               and edx,$11111111{} @@MaskX:  // Source.WidthMask
               imul esi,$11111111{}@@Pitch:  // Source.pitch
               movzx eax,byte ptr [esi+edx+$11111111]
                                   @@Bits:   // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@MaskY  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.HeightMask]
               mov edx,offset @@MaskY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Pitch  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Pitch]
               mov edx,offset @@Pitch-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@MaskX  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.WidthMask]
               mov edx,offset @@MaskX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end;
         end;
     16: begin
           if Source.pitch=(1 shl Source.PitchBit) then
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,$11{}       @@YShift: // 16-Source.PitchBit
               shr edx,16
               and esi,$11111111{} @@MaskY:  // Source.HeightMask shl Source.PitchBit
               and edx,$11111111{} @@MaskX:  // Source.WidthMask
               movzx eax,word ptr [$11111111+esi+edx*2]
                                   @@Bits:   // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@YShift  }
               push ebx
               mov eax,16
               mov ebx,Source; sub eax,[ebx + TDXR_Surface.PitchBit]
               pop ebx
               mov edx,offset @@YShift-1
               sub edx,offset @@StartCode
               mov byte ptr [ecx+edx],al

               {  @@MaskY  }
               push ecx
               mov ecx,Source; mov ecx,[ecx + TDXR_Surface.PitchBit]
               mov eax,Source; mov eax,[eax + TDXR_Surface.HeightMask]
               shl eax,cl
               pop ecx
               mov edx,offset @@MaskY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@MaskX  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.WidthMask]
               mov edx,offset @@MaskX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end else
           if -Source.pitch=(1 shl Source.PitchBit) then
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,$11{}       @@YShift: // 16-Source.PitchBit
               shr edx,16
               and esi,$11111111{} @@MaskY:  // Source.HeightMask shl Source.PitchBit
               and edx,$11111111{} @@MaskX:  // Source.WidthMask
               neg esi
               movzx eax,word ptr [$11111111+esi+edx*2]
                                   @@Bits:   // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@YShift  }
               push ebx
               mov eax,16
               mov ebx,Source; sub eax,[ebx + TDXR_Surface.PitchBit]
               pop ebx
               mov edx,offset @@YShift-1
               sub edx,offset @@StartCode
               mov byte ptr [ecx+edx],al

               {  @@MaskY  }
               push ecx
               mov ecx,Source; mov ecx,[ecx + TDXR_Surface.PitchBit]
               mov eax,Source; mov eax,[eax + TDXR_Surface.HeightMask]
               shl eax,cl
               pop ecx
               mov edx,offset @@MaskY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@MaskX  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.WidthMask]
               mov edx,offset @@MaskX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end else
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,16
               shr edx,16
               and esi,$11111111{} @@MaskY:  // Source.HeightMask
               and edx,$11111111{} @@MaskX:  // Source.WidthMask
               imul esi,$11111111{}@@Pitch:  // Source.pitch
               movzx eax,word ptr [esi+edx*2+$11111111]
                                   @@Bits:   // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@MaskY  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.HeightMask]
               mov edx,offset @@MaskY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Pitch  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Pitch]
               mov edx,offset @@Pitch-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@MaskX  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.WidthMask]
               mov edx,offset @@MaskX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end;
         end;
     24: begin
           asm
             jmp @@EndCode
           @@StartCode:
             mov esi,dword ptr [offset _null]{}//TexY
                                 @@TexY:
             mov edx,dword ptr [offset _null]{}//TexX
                                 @@TexX:
             shr esi,16
             shr edx,16
             and esi,$11111111{} @@MaskY:  // Source.HeightMask
             and edx,$11111111{} @@MaskX:  // Source.WidthMask
             imul esi,$11111111{}@@Pitch:  // Source.pitch
             lea edx,[edx+edx*2+$11111111] // Source.Bits
                                 @@Bits:
             movzx eax,byte ptr [esi+edx+2]
             shl eax,16
             mov ax,word ptr [esi+edx]
           @@EndCode:
             {$I DXRender.inc}
             {  @@TexX  }
             mov eax,Axis; add eax,TDXRMachine_Axis.X
             mov edx,offset @@TexX-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@TexY  }
             mov eax,Axis; add eax,TDXRMachine_Axis.Y
             mov edx,offset @@TexY-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@MaskY  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.HeightMask]
             mov edx,offset @@MaskY-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Pitch  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Pitch]
             mov edx,offset @@Pitch-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@MaskX  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.WidthMask]
             mov edx,offset @@MaskX-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Bits  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
             mov edx,offset @@Bits-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax
           end;
         end;
     32: begin
           if Source.pitch=(1 shl Source.PitchBit) then
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,$11{}       @@YShift: // 16-Source.PitchBit
               shr edx,16
               and esi,$11111111{} @@MaskY:  // Source.HeightMask shl Source.PitchBit
               and edx,$11111111{} @@MaskX:  // Source.WidthMask
               mov eax,dword ptr [$11111111+esi+edx*4]
                                   @@Bits:   // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@YShift  }
               push ebx
               mov eax,16
               mov ebx,Source; sub eax,[ebx + TDXR_Surface.PitchBit]
               pop ebx
               mov edx,offset @@YShift-1
               sub edx,offset @@StartCode
               mov byte ptr [ecx+edx],al

               {  @@MaskY  }
               push ecx
               mov ecx,Source; mov ecx,[ecx + TDXR_Surface.PitchBit]
               mov eax,Source; mov eax,[eax + TDXR_Surface.HeightMask]
               shl eax,cl
               pop ecx
               mov edx,offset @@MaskY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@MaskX  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.WidthMask]
               mov edx,offset @@MaskX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end else
           if -Source.pitch=(1 shl Source.PitchBit) then
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,$11{}       @@YShift: // 16-Source.PitchBit
               shr edx,16
               and esi,$11111111{} @@MaskY:  // Source.HeightMask shl Source.PitchBit
               and edx,$11111111{} @@MaskX:  // Source.WidthMask
               neg esi
               mov eax,dword ptr [$11111111+esi+edx*4]
                                   @@Bits:   // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@YShift  }
               push ebx
               mov eax,16
               mov ebx,Source; sub eax,[ebx + TDXR_Surface.PitchBit]
               pop ebx
               mov edx,offset @@YShift-1
               sub edx,offset @@StartCode
               mov byte ptr [ecx+edx],al

               {  @@MaskY  }
               push ecx
               mov ecx,Source; mov ecx,[ecx + TDXR_Surface.PitchBit]
               mov eax,Source; mov eax,[eax + TDXR_Surface.HeightMask]
               shl eax,cl
               pop ecx
               mov edx,offset @@MaskY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@MaskX  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.WidthMask]
               mov edx,offset @@MaskX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end else
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,16
               shr edx,16
               and esi,$11111111{} @@MaskY:  // Source.HeightMask
               and edx,$11111111{} @@MaskX:  // Source.WidthMask
               imul esi,$11111111{}@@Pitch:  // Source.pitch
               mov eax,dword ptr [esi+edx*4+$11111111]
                                   @@Bits:   // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@MaskY  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.HeightMask]
               mov edx,offset @@MaskY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Pitch  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Pitch]
               mov edx,offset @@Pitch-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@MaskX  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.WidthMask]
               mov edx,offset @@MaskX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end;
         end;
    end;
  end;

  procedure genReadSurfacePixel_DoNotClip(var Code: Pointer; const Source: TDXR_Surface; Axis: PDXRMachine_Axis);
  begin
    case Source.BitCount of
      1: begin
           asm
             jmp @@EndCode
           @@StartCode:
             mov esi,dword ptr [offset _null]{}//TexY
                                 @@TexY:
             shr esi,16
             imul esi,$11111111{}@@Pitch:   // Source.pitch
             mov edx,dword ptr [offset _null]{}//TexX
                                 @@TexX:
             shr edx,16
             mov ebx,edx
             shr edx,3
             and ebx,7
             movzx eax,byte ptr [esi+edx+$11111111]
                                 @@Bits:   // Source.Bits
             and eax,dword ptr [offset Mask1+ebx*4]
             push ecx
             mov ecx,dword ptr [offset Shift1+ebx*4]
             shr eax,cl
             pop ecx
           @@EndCode:
             {$I DXRender.inc}
             {  @@TexX  }
             mov eax,Axis; add eax,TDXRMachine_Axis.X
             mov edx,offset @@TexX-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@TexY  }
             mov eax,Axis; add eax,TDXRMachine_Axis.Y
             mov edx,offset @@TexY-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Pitch  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Pitch]
             mov edx,offset @@Pitch-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Bits  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
             mov edx,offset @@Bits-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax
           end;
         end;
      2: begin
           asm
             jmp @@EndCode
           @@StartCode:
             mov esi,dword ptr [offset _null]{}//TexY
                                 @@TexY:
             shr esi,16
             imul esi,$11111111{}@@Pitch:  // Source.pitch
             mov edx,dword ptr [offset _null]{}//TexX
                                 @@TexX:
             shr edx,16
             mov ebx,edx
             shr edx,2
             and ebx,3
             movzx eax,byte ptr [esi+edx+$11111111]
                                 @@Bits:   // Source.Bits
             and eax,dword ptr [offset Mask2+ebx*4]
             push ecx
             mov ecx,dword ptr [offset Shift2+ebx*4]
             shr eax,cl
             pop ecx
           @@EndCode:
             {$I DXRender.inc}
             {  @@TexX  }
             mov eax,Axis; add eax,TDXRMachine_Axis.X
             mov edx,offset @@TexX-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@TexY  }
             mov eax,Axis; add eax,TDXRMachine_Axis.Y
             mov edx,offset @@TexY-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Pitch  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Pitch]
             mov edx,offset @@Pitch-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Bits  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
             mov edx,offset @@Bits-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax
           end;
         end;
      4: begin
           asm
             jmp @@EndCode
           @@StartCode:
             mov esi,dword ptr [offset _null]{}//TexY
                                 @@TexY:
             shr esi,16
             imul esi,$11111111{}@@Pitch:  // Source.pitch
             mov edx,dword ptr [offset _null]{}//TexX
                                 @@TexX:
             shr edx,16
             mov ebx,edx
             shr edx,1
             and ebx,1
             movzx eax,byte ptr [esi+edx+$11111111]
                                 @@Bits:   // Source.Bits
             and eax,dword ptr [offset Mask4+ebx*4]
             push ecx
             mov ecx,dword ptr [offset Shift4+ebx*4]
             shr eax,cl
             pop ecx
           @@EndCode:
             {$I DXRender.inc}
             {  @@TexX  }
             mov eax,Axis; add eax,TDXRMachine_Axis.X
             mov edx,offset @@TexX-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@TexY  }
             mov eax,Axis; add eax,TDXRMachine_Axis.Y
             mov edx,offset @@TexY-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Pitch  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Pitch]
             mov edx,offset @@Pitch-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Bits  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
             mov edx,offset @@Bits-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax
           end;
         end;
      8: begin
           if Source.pitch=(1 shl Source.PitchBit) then
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,16
               shr edx,16
               shl esi,$11{}       @@PitchBit: // Source.PitchBit
               movzx eax,byte ptr [$11111111+esi+edx]
                                   @@Bits:     // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@PitchBit  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.PitchBit]
               mov edx,offset @@PitchBit-1
               sub edx,offset @@StartCode
               mov byte ptr [ecx+edx],al

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end else
           if -Source.pitch=(1 shl Source.PitchBit) then
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,16
               shr edx,16
               shl esi,$11{}       @@PitchBit: // Source.PitchBit
               neg esi
               movzx eax,byte ptr [$11111111+esi+edx]
                                   @@Bits:     // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@PitchBit  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.PitchBit]
               mov edx,offset @@PitchBit-1
               sub edx,offset @@StartCode
               mov byte ptr [ecx+edx],al

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end else
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,16
               shr edx,16
               imul esi,$11111111{}@@Pitch:  // Source.pitch
               movzx eax,byte ptr [esi+edx+$11111111]
                                   @@Bits:   // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Pitch  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Pitch]
               mov edx,offset @@Pitch-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end;
         end;
     16: begin
           if Source.pitch=(1 shl Source.PitchBit) then
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,16
               shr edx,16
               shl esi,$11{}       @@PitchBit: // Source.PitchBit
               movzx eax,word ptr [$11111111+esi+edx*2]
                                   @@Bits:     // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@PitchBit  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.PitchBit]
               mov edx,offset @@PitchBit-1
               sub edx,offset @@StartCode
               mov byte ptr [ecx+edx],al

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end else
           if -Source.pitch=(1 shl Source.PitchBit) then
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,16
               shr edx,16
               shl esi,$11{}       @@PitchBit: // Source.PitchBit
               neg esi
               movzx eax,word ptr [$11111111+esi+edx*2]
                                   @@Bits:     // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@PitchBit  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.PitchBit]
               mov edx,offset @@PitchBit-1
               sub edx,offset @@StartCode
               mov byte ptr [ecx+edx],al

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end else
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,16
               shr edx,16
               imul esi,$11111111{}@@Pitch:  // Source.pitch
               movzx eax,word ptr [esi+edx*2+$11111111]
                                   @@Bits:   // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Pitch  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Pitch]
               mov edx,offset @@Pitch-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end;
         end;
     24: begin
           asm
             jmp @@EndCode
           @@StartCode:
             mov esi,dword ptr [offset _null]{}//TexY
                                 @@TexY:
             mov edx,dword ptr [offset _null]{}//TexX
                                 @@TexX:
             shr esi,16
             shr edx,16
             imul esi,$11111111{}@@Pitch:  // Source.pitch
             lea edx,[edx+edx*2+$11111111] // Source.Bits
                                 @@Bits:
             movzx eax,byte ptr [esi+edx+2]
             shl eax,16
             mov ax,word ptr [esi+edx]
           @@EndCode:
             {$I DXRender.inc}
             {  @@TexX  }
             mov eax,Axis; add eax,TDXRMachine_Axis.X
             mov edx,offset @@TexX-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@TexY  }
             mov eax,Axis; add eax,TDXRMachine_Axis.Y
             mov edx,offset @@TexY-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Pitch  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Pitch]
             mov edx,offset @@Pitch-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax

             {  @@Bits  }
             mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
             mov edx,offset @@Bits-4
             sub edx,offset @@StartCode
             mov dword ptr [ecx+edx],eax
           end;
         end;
     32: begin
           if Source.pitch=(1 shl Source.PitchBit) then
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,16
               shr edx,16
               shl esi,$11{}       @@PitchBit: // Source.PitchBit
               mov eax,dword ptr [$11111111+esi+edx*4]
                                   @@Bits:     // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@PitchBit  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.PitchBit]
               mov edx,offset @@PitchBit-1
               sub edx,offset @@StartCode
               mov byte ptr [ecx+edx],al

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end else
           if -Source.pitch=(1 shl Source.PitchBit) then
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,16
               shr edx,16
               shl esi,$11{}       @@PitchBit: // Source.PitchBit
               neg esi
               mov eax,dword ptr [$11111111+esi+edx*4]
                                   @@Bits:     // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@PitchBit  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.PitchBit]
               mov edx,offset @@PitchBit-1
               sub edx,offset @@StartCode
               mov byte ptr [ecx+edx],al

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end else
           begin
             asm
               jmp @@EndCode
             @@StartCode:
               mov esi,dword ptr [offset _null]{}@@TexY: //TexY
               mov edx,dword ptr [offset _null]{}@@TexX: //TexX
               shr esi,16
               shr edx,16
               imul esi,$11111111{}@@Pitch:  // Source.pitch
               mov eax,dword ptr [esi+edx*4+$11111111]
                                   @@Bits:   // Source.Bits
             @@EndCode:
               {$I DXRender.inc}
               {  @@TexX  }
               mov eax,Axis; add eax,TDXRMachine_Axis.X
               mov edx,offset @@TexX-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@TexY  }
               mov eax,Axis; add eax,TDXRMachine_Axis.Y
               mov edx,offset @@TexY-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Pitch  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Pitch]
               mov edx,offset @@Pitch-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax

               {  @@Bits  }
               mov eax,Source; mov eax,[eax + TDXR_Surface.Bits]
               mov edx,offset @@Bits-4
               sub edx,offset @@StartCode
               mov dword ptr [ecx+edx],eax
             end;
           end;
         end;
    end;
  end;

  procedure genReadSurfacePixel(var Code: Pointer; const Texture: TDXRMachine_Reg_Texture; Axis: PDXRMachine_Axis);
  begin
    case Texture.TextureAddress of
      DXR_TEXTUREADDRESS_TILE     : genReadSurfacePixel_Tile(Code, Texture.Surface^, Axis);
      DXR_TEXTUREADDRESS_DONOTCLIP: genReadSurfacePixel_DoNotClip(Code, Texture.Surface^, Axis);
    end;
  end;

  procedure genDecodeColor(var Code: Pointer; const Surface: TDXR_Surface; Dest: PDXRMachine_Color;
    EnableChannels: TDXRColorChannels; DefaultColor: TDXRMachine_Color);
  var
    dcR, dcG, dcB, dcA: Word;
  begin
    if EnableChannels=[] then Exit;

    dcR := DefaultColor.R;
    dcG := DefaultColor.G;
    dcB := DefaultColor.B;
    dcA := DefaultColor.A;

    if Surface.ColorType=DXR_COLORTYPE_INDEXED then
    begin
      {  Index Channel  }
      if EnableChannels*[chRed, chGreen, chBlue]<>[] then
      begin
        if Surface.idx_index.Mask<>0 then
        begin
          if (Surface.idx_index.rshift=0) and (Surface.idx_index.lshift=0) and
            (Surface.idx_index.Mask=DWORD((1 shl Surface.BitCount)-1)) and (Surface.idx_alpha.Mask=0) then
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              {  Index channel  }
              mov edx,dword ptr [eax*4+$11111111]
                                  {}@@idx_indexPal:// @Surface.idx_palette

              mov byte ptr [offset _null],dl{}@@DestR:// @Dest.R
              mov byte ptr [offset _null],dh{}@@DestG:// @Dest.G
              bswap edx
              mov byte ptr [offset _null],dh{}@@DestB:// @Dest.B
            @@EndCode:
              {$I DXRender.inc}
              {  @@idx_indexPal  }
              mov eax,Surface; lea eax,dword ptr [eax + TDXR_Surface.idx_palette]
              mov edx,offset @@idx_indexPal-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@DestR  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
              mov edx,offset @@DestR-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@DestG  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.G+1)
              mov edx,offset @@DestG-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@DestB  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.B+1)
              mov edx,offset @@DestB-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end else
          if Surface.idx_index.rshift<>0 then
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              {  Index channel  }
              mov edx,eax
              and edx,$11111111{}@@idx_indexMask:   // Surface.idx_index.Mask
              shr edx,$11      {}@@idx_indexRShift: // Surface.idx_index.rshift
              mov edx,dword ptr [edx*4+$11111111]
                               {}@@idx_indexPal:    // @Surface.idx_palette

              mov byte ptr [offset _null],dl{}@@DestR:// @Dest.R
              mov byte ptr [offset _null],dh{}@@DestG:// @Dest.G
              bswap edx
              mov byte ptr [offset _null],dh{}@@DestB:// @Dest.B
            @@EndCode:
              {$I DXRender.inc}
              {  @@idx_indexMask  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.idx_index.Mask]
              mov edx,offset @@idx_indexMask-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@idx_indexRShift  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.idx_index.rshift]
              mov edx,offset @@idx_indexRShift-1
              sub edx,offset @@StartCode
              mov byte ptr [ecx+edx],al

              {  @@idx_indexPal  }
              mov eax,Surface; lea eax,dword ptr [eax + TDXR_Surface.idx_palette]
              mov edx,offset @@idx_indexPal-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@DestR  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
              mov edx,offset @@DestR-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@DestG  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.G+1)
              mov edx,offset @@DestG-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@DestB  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.B+1)
              mov edx,offset @@DestB-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end else
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              {  Index channel  }
              mov edx,eax
              and edx,$11111111{}@@idx_indexMask:   // Surface.idx_index.Mask
              shl edx,$11      {}@@idx_indexLShift: // Surface.idx_index.lshift
              mov edx,dword ptr [edx*4+$11111111]
                               {}@@idx_indexPal:    // @Surface.idx_palette

              mov byte ptr [offset _null],dl{}@@DestR:// @Dest.R
              mov byte ptr [offset _null],dh{}@@DestG:// @Dest.G
              bswap edx
              mov byte ptr [offset _null],dh{}@@DestB:// @Dest.B
            @@EndCode:
              {$I DXRender.inc}
              {  @@idx_indexMask  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.idx_index.Mask]
              mov edx,offset @@idx_indexMask-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@idx_indexLShift  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.idx_index.lshift]
              mov edx,offset @@idx_indexLShift-1
              sub edx,offset @@StartCode
              mov byte ptr [ecx+edx],al

              {  @@idx_indexPal  }
              mov eax,Surface; lea eax,dword ptr [eax + TDXR_Surface.idx_palette]
              mov edx,offset @@idx_indexPal-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@DestR  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
              mov edx,offset @@DestR-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@DestG  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.G+1)
              mov edx,offset @@DestG-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@DestB  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.B+1)
              mov edx,offset @@DestB-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end;
        end else
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov word ptr [offset _null],$1111{}@@DestR:// @Dest.R
            mov word ptr [offset _null],$1111{}@@DestG:// @Dest.G
            mov word ptr [offset _null],$1111{}@@DestB:// @Dest.B
          @@EndCode:
            {$I DXRender.inc}
            {  @@DestR  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.R)
            mov edx,offset @@DestR-6
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            mov ax,dcR
            mov edx,offset @@DestR-2
            sub edx,offset @@StartCode
            mov word ptr [ecx+edx],ax

            {  @@DestG  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.G)
            mov edx,offset @@DestG-6
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            mov ax,dcG
            mov edx,offset @@DestG-2
            sub edx,offset @@StartCode
            mov word ptr [ecx+edx],ax

            {  @@DestB  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.B)
            mov edx,offset @@DestB-6
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            mov ax,dcB
            mov edx,offset @@DestB-2
            sub edx,offset @@StartCode
            mov word ptr [ecx+edx],ax
          end;
        end;
      end;

      {  Alpha Channel  }
      if chAlpha in EnableChannels then
      begin
        if Surface.idx_alpha.Mask<>0 then
        begin
          if Surface.idx_alpha.rshift<>0 then
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              mov edx,eax
              and edx,$11111111{}@@idx_alphaMask:   // Surface.idx_alpha.Mask
              shr edx,$11      {}@@idx_alphaRShift: // Surface.idx_alpha.rshift
              mov byte ptr [offset _null],dl{}@@Dest:// @Dest.A
            @@EndCode:
              {$I DXRender.inc}
              {  @@idx_alphaMask  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.idx_alpha.Mask]
              mov edx,offset @@idx_alphaMask-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@idx_alphaRShift  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.idx_alpha.rshift]
              mov edx,offset @@idx_alphaRShift-1
              sub edx,offset @@StartCode
              mov byte ptr [ecx+edx],al

              {  @@Dest  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
              mov edx,offset @@Dest-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end else
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              mov edx,eax
              and edx,$11111111{}@@idx_alphaMask:   // Surface.idx_alpha.Mask
              shl edx,$11      {}@@idx_alphaLShift: // Surface.idx_alpha.lshift
              mov byte ptr [offset _null],dl{}@@Dest:// @Dest.A
            @@EndCode:
              {$I DXRender.inc}
              {  @@idx_alphaMask  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.idx_alpha.Mask]
              mov edx,offset @@idx_alphaMask-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@idx_alphaLShift  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.idx_alpha.lshift]
              mov edx,offset @@idx_alphaLShift-1
              sub edx,offset @@StartCode
              mov byte ptr [ecx+edx],al

              {  @@Dest  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
              mov edx,offset @@Dest-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end;
        end else
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov word ptr [offset _null],$1111{}@@Dest:// @Dest.A
          @@EndCode:
            {$I DXRender.inc}
            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.A)
            mov edx,offset @@Dest-6
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            mov ax,dcA
            mov edx,offset @@Dest-2
            sub edx,offset @@StartCode
            mov word ptr [ecx+edx],ax
          end;
        end;
      end;
    end else if Surface.ColorType=DXR_COLORTYPE_RGB then
    begin
      {  Red Channel  }
      if chRed in EnableChannels then
      begin
        if Surface.rgb_red.Mask<>0 then
        begin
          if Surface.rgb_red.rshift<>0 then
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              mov edx,eax
              and edx,$11111111{}@@Mask:    // Surface.rgb_red.Mask
              shr edx,$11      {}@@RShift:  // Surface.rgb_red.rshift
              mov byte ptr [offset _null],dl{}@@Dest:// @Dest.R
            @@EndCode:
              {$I DXRender.inc}
              {  @@Mask  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_red.Mask]
              mov edx,offset @@Mask-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@RShift  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_red.rshift]
              mov edx,offset @@RShift-1
              sub edx,offset @@StartCode
              mov byte ptr [ecx+edx],al

              {  @@Dest  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
              mov edx,offset @@Dest-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end else
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              mov edx,eax
              and edx,$11111111{}@@Mask:    // Surface.rgb_red.Mask
              shl edx,$11      {}@@LShift:  // Surface.rgb_red.lshift
              mov byte ptr [offset _null],dl{}@@Dest:// @Dest.R
            @@EndCode:
              {$I DXRender.inc}
              {  @@Mask  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_red.Mask]
              mov edx,offset @@Mask-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@LShift  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_red.lshift]
              mov edx,offset @@LShift-1
              sub edx,offset @@StartCode
              mov byte ptr [ecx+edx],al

              {  @@Dest  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
              mov edx,offset @@Dest-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end;
        end else
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov word ptr [offset _null],$1111{}@@Dest:// @Dest.R
          @@EndCode:
            {$I DXRender.inc}
            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.R)
            mov edx,offset @@Dest-6
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            mov ax,dcR
            mov edx,offset @@Dest-2
            sub edx,offset @@StartCode
            mov word ptr [ecx+edx],ax
          end;
        end;
      end;

      {  Green Channel  }
      if chGreen in EnableChannels then
      begin
        if Surface.rgb_green.Mask<>0 then
        begin
          if Surface.rgb_green.rshift<>0 then
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              mov edx,eax
              and edx,$11111111{}@@Mask:    // Surface.rgb_green.Mask
              shr edx,$11      {}@@RShift:  // Surface.rgb_green.rshift
              mov byte ptr [offset _null],dl{}@@Dest:// @Dest.G
            @@EndCode:
              {$I DXRender.inc}
              {  @@Mask  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_green.Mask]
              mov edx,offset @@Mask-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@RShift  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_green.rshift]
              mov edx,offset @@RShift-1
              sub edx,offset @@StartCode
              mov byte ptr [ecx+edx],al

              {  @@Dest  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.G+1)
              mov edx,offset @@Dest-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end else
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              mov edx,eax
              and edx,$11111111{}@@Mask:    // Surface.rgb_green.Mask
              shl edx,$11      {}@@LShift:  // Surface.rgb_green.lshift
              mov byte ptr [offset _null],dl{}@@Dest:// @Dest.G
            @@EndCode:
              {$I DXRender.inc}
              {  @@Mask  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_green.Mask]
              mov edx,offset @@Mask-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@LShift  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_green.lshift]
              mov edx,offset @@LShift-1
              sub edx,offset @@StartCode
              mov byte ptr [ecx+edx],al

              {  @@Dest  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.G+1)
              mov edx,offset @@Dest-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end;
        end else
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov word ptr [offset _null],$1111{}@@Dest:// @Dest.G
          @@EndCode:
            {$I DXRender.inc}
            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.G)
            mov edx,offset @@Dest-6
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            mov ax,dcG
            mov edx,offset @@Dest-2
            sub edx,offset @@StartCode
            mov word ptr [ecx+edx],ax
          end;
        end;
      end;

      {  Blue Channel  }
      if chBlue in EnableChannels then
      begin
        if Surface.rgb_blue.Mask<>0 then
        begin
          if Surface.rgb_blue.rshift<>0 then
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              mov edx,eax
              and edx,$11111111{}@@Mask:    // Surface.rgb_blue.Mask
              shr edx,$11      {}@@RShift:  // Surface.rgb_blue.rshift
              mov byte ptr [offset _null],dl{}@@Dest:// @Dest.B
            @@EndCode:
              {$I DXRender.inc}
              {  @@Mask  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_blue.Mask]
              mov edx,offset @@Mask-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@RShift  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_blue.rshift]
              mov edx,offset @@RShift-1
              sub edx,offset @@StartCode
              mov byte ptr [ecx+edx],al

              {  @@Dest  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.B+1)
              mov edx,offset @@Dest-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end else
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              mov edx,eax
              and edx,$11111111{}@@Mask:    // Surface.rgb_blue.Mask
              shl edx,$11      {}@@LShift:  // Surface.rgb_blue.lshift
              mov byte ptr [offset _null],dl{}@@Dest:// @Dest.B
            @@EndCode:
              {$I DXRender.inc}
              {  @@Mask  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_blue.Mask]
              mov edx,offset @@Mask-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@LShift  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_blue.lshift]
              mov edx,offset @@LShift-1
              sub edx,offset @@StartCode
              mov byte ptr [ecx+edx],al

              {  @@Dest  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.B+1)
              mov edx,offset @@Dest-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end;
        end else
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov word ptr [offset _null],$1111{}@@Dest:// @Dest.B
          @@EndCode:
            {$I DXRender.inc}
            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.B)
            mov edx,offset @@Dest-6
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            mov ax,dcB
            mov edx,offset @@Dest-2
            sub edx,offset @@StartCode
            mov word ptr [ecx+edx],ax
          end;
        end;
      end;

      {  Alpha Channel  }
      if chAlpha in EnableChannels then
      begin
        if Surface.rgb_alpha.Mask<>0 then
        begin
          if Surface.rgb_alpha.rshift<>0 then
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              mov edx,eax
              and edx,$11111111{}@@Mask:    // Surface.rgb_alpha.Mask
              shr edx,$11      {}@@RShift:  // Surface.rgb_alpha.rshift
              mov byte ptr [offset _null],dl{}@@Dest:// @Dest.A
            @@EndCode:
              {$I DXRender.inc}
              {  @@Mask  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_alpha.Mask]
              mov edx,offset @@Mask-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@RShift  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_alpha.rshift]
              mov edx,offset @@RShift-1
              sub edx,offset @@StartCode
              mov byte ptr [ecx+edx],al

              {  @@Dest  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
              mov edx,offset @@Dest-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end else
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              mov edx,eax
              and edx,$11111111{}@@Mask:    // Surface.rgb_alpha.Mask
              shl edx,$11      {}@@LShift:  // Surface.rgb_alpha.lshift
              mov byte ptr [offset _null],dl{}@@Dest:// @Dest.A
            @@EndCode:
              {$I DXRender.inc}
              {  @@Mask  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_alpha.Mask]
              mov edx,offset @@Mask-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              {  @@LShift  }
              mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_alpha.lshift]
              mov edx,offset @@LShift-1
              sub edx,offset @@StartCode
              mov byte ptr [ecx+edx],al

              {  @@Dest  }
              mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
              mov edx,offset @@Dest-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end;
        end else
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov word ptr [offset _null],$1111{}@@Dest:// @Dest.A
          @@EndCode:
            {$I DXRender.inc}
            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.A)
            mov edx,offset @@Dest-6
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            mov ax,dcA
            mov edx,offset @@Dest-2
            sub edx,offset @@StartCode
            mov word ptr [ecx+edx],ax
          end;
        end;
      end;
    end;
  end;

  procedure genEncodeColor(var Code: Pointer; const Surface: TDXR_Surface; Src: PDXRMachine_Color; EnableChannels: TDXRColorChannels);
  begin
    asm
      jmp @@EndCode
    @@StartCode:
      xor eax,eax
    @@EndCode:
      {$I DXRender.inc}
    end;

    {  Red channel  }
    if chRed in EnableChannels then
    begin
      if Surface.rgb_red.rshift<>0 then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx edx,byte ptr [offset _null]{}@@Src:// @Src.R
          shl edx,$11      {}@@rgb_redRShift:  // Surface.rgb_red.rshift
          and edx,$11111111{}@@rgb_redMask:    // Surface.rgb_red.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@Src  }
          mov eax,Src; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@Src-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_redMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_red.Mask]
          mov edx,offset @@rgb_redMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_redRShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_red.rshift]
          mov edx,offset @@rgb_redRShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end else
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx edx,byte ptr [offset _null]{}@@Src:// @Src.R
          shr edx,$11      {}@@rgb_redLShift:  // Surface.rgb_red.lshift
          and edx,$11111111{}@@rgb_redMask:    // Surface.rgb_red.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@Src  }
          mov eax,Src; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@Src-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_redMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_red.Mask]
          mov edx,offset @@rgb_redMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_redLShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_red.lshift]
          mov edx,offset @@rgb_redLShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end;
    end;

    {  Green channel  }
    if chGreen in EnableChannels then
    begin
      if Surface.rgb_green.rshift<>0 then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx edx,byte ptr [offset _null]{}@@Src:// @Src.G
          shl edx,$11      {}@@rgb_greenRShift:  // Surface.rgb_green.rshift
          and edx,$11111111{}@@rgb_greenMask:    // Surface.rgb_green.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@Src  }
          mov eax,Src; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@Src-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_greenMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_green.Mask]
          mov edx,offset @@rgb_greenMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_greenRShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_green.rshift]
          mov edx,offset @@rgb_greenRShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end else
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx edx,byte ptr [offset _null]{}@@Src:// @Src.G
          shr edx,$11      {}@@rgb_greenLShift:  // Surface.rgb_green.lshift
          and edx,$11111111{}@@rgb_greenMask:    // Surface.rgb_green.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@Src  }
          mov eax,Src; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@Src-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_greenMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_green.Mask]
          mov edx,offset @@rgb_greenMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_greenLShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_green.lshift]
          mov edx,offset @@rgb_greenLShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end;
    end;

    {  Blue channel  }
    if chBlue in EnableChannels then
    begin
      if Surface.rgb_blue.rshift<>0 then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx edx,byte ptr [offset _null]{}@@Src:// @Src.B
          shl edx,$11      {}@@rgb_blueRShift:  // Surface.rgb_blue.rshift
          and edx,$11111111{}@@rgb_blueMask:    // Surface.rgb_blue.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@Src  }
          mov eax,Src; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@Src-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_blueMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_blue.Mask]
          mov edx,offset @@rgb_blueMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_blueRShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_blue.rshift]
          mov edx,offset @@rgb_blueRShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end else
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx edx,byte ptr [offset _null]{}@@Src:// @Src.B
          shr edx,$11      {}@@rgb_blueLShift:  // Surface.rgb_blue.lshift
          and edx,$11111111{}@@rgb_blueMask:    // Surface.rgb_blue.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@Src  }
          mov eax,Src; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@Src-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_blueMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_blue.Mask]
          mov edx,offset @@rgb_blueMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_blueLShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_blue.lshift]
          mov edx,offset @@rgb_blueLShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end;
    end;

    {  Alpha channel  }
    if chAlpha in EnableChannels then
    begin
      if Surface.rgb_alpha.rshift<>0 then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx edx,byte ptr [offset _null]{}@@Src:// @Src.A
          shl edx,$11      {}@@rgb_alphaRShift: // Surface.rgb_alpha.rshift
          and edx,$11111111{}@@rgb_alphaMask:   // Surface.rgb_alpha.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@Src  }
          mov eax,Src; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@Src-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_alphaMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_alpha.Mask]
          mov edx,offset @@rgb_alphaMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_alphaRShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_alpha.rshift]
          mov edx,offset @@rgb_alphaRShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end else
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx edx,byte ptr [offset _null]{}@@Src:// @Src.A
          shr edx,$11      {}@@rgb_alphaLShift: // Surface.rgb_alpha.lshift
          and edx,$11111111{}@@rgb_alphaMask:   // Surface.rgb_alpha.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@Src  }
          mov eax,Src; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@Src-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_alphaMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_alpha.Mask]
          mov edx,offset @@rgb_alphaMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_alphaLShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_alpha.lshift]
          mov edx,offset @@rgb_alphaLShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end;
    end;
  end;

  procedure genEncodeColor_with_Dither(var Code: Pointer; const Surface: TDXR_Surface; Src: PDXRMachine_Color;
    Axis: PDXRMachine_Axis; EnableChannels: TDXRColorChannels);
  const
    m: array[0..3, 0..3] of Byte = ((0, 0, 0, 0), (1, 0, 0, 0), (1, 0, 0, 1), (1, 1, 1, 0));
  begin
    asm
      jmp @@EndCode
    @@StartCode:
      xor eax,eax
      movzx ebp,byte ptr [offset _null]{}@@AxisX:
      movzx edx,byte ptr [offset _null]{}@@AxisY:
      and ebp,1
      and edx,1
      lea ebp,[offset m+ebp*2+edx]
    @@EndCode:
      {$I DXRender.inc}
      {  @@AxisX  }
      mov eax,Axis; add eax,TDXRMachine_Axis.X
      mov edx,offset @@AxisX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@AxisY  }
      mov eax,Axis; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@AxisY-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;

    {  Red channel  }
    if chRed in EnableChannels then
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        movzx edx,byte ptr [offset _null]{}@@Src:// @Src.R
      @@EndCode:
        {$I DXRender.inc}
        {  @@Src  }
        mov eax,Src; add eax,Byte(TDXRMachine_Color.R+1)
        mov edx,offset @@Src-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;

      if Surface.rgb_red.Bitcount<7 then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          mov ebx,edx
          shr ebx,$11       {}@@BitCount:  // 6-bitcount
          and ebx,3
          movzx ebx,byte ptr [ebp+ebx*4]
          shl ebx,$11       {}@@BitCount2: // 8-bitcount
          movzx edx,byte [offset (_AddTable+edx+ebx)]
        @@EndCode:
          {$I DXRender.inc}
          {  @@BitCount  }
          mov eax,6; mov edx,Surface; sub eax,[edx + TDXR_Surface.rgb_red.Bitcount]
          mov edx,offset @@BitCount-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al

          {  @@BitCount2  }
          mov eax,8; mov edx,Surface; sub eax,[edx + TDXR_Surface.rgb_red.Bitcount]
          mov edx,offset @@BitCount2-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end;

      if Surface.rgb_red.rshift<>0 then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          shl edx,$11      {}@@rgb_redRShift:  // Surface.rgb_red.rshift
          and edx,$11111111{}@@rgb_redMask:    // Surface.rgb_red.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@rgb_redMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_red.Mask]
          mov edx,offset @@rgb_redMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_redRShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_red.rshift]
          mov edx,offset @@rgb_redRShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end else
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          shr edx,$11      {}@@rgb_redLShift:  // Surface.rgb_red.lshift
          and edx,$11111111{}@@rgb_redMask:    // Surface.rgb_red.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@rgb_redMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_red.Mask]
          mov edx,offset @@rgb_redMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_redLShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_red.lshift]
          mov edx,offset @@rgb_redLShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end;
    end;

    {  Green channel  }
    if chGreen in EnableChannels then
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        movzx edx,byte ptr [offset _null]{}@@Src:// @Src.G
      @@EndCode:
        {$I DXRender.inc}
        {  @@Src  }
        mov eax,Src; add eax,Byte(TDXRMachine_Color.G+1)
        mov edx,offset @@Src-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;

      if Surface.rgb_green.Bitcount<7 then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          mov ebx,edx
          shr ebx,$11       {}@@BitCount:  // 6-bitcount
          and ebx,3
          movzx ebx,byte ptr [ebp+ebx*4]
          shl ebx,$11       {}@@BitCount2: // 8-bitcount
          movzx edx,byte [offset (_AddTable+edx+ebx)]
        @@EndCode:
          {$I DXRender.inc}
          {  @@BitCount  }
          mov eax,6; mov edx,Surface; sub eax,[edx + TDXR_Surface.rgb_green.Bitcount]
          mov edx,offset @@BitCount-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al

          {  @@BitCount2  }
          mov eax,8; mov edx,Surface; sub eax,[edx + TDXR_Surface.rgb_green.Bitcount]
          mov edx,offset @@BitCount2-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end;

      if Surface.rgb_green.rshift<>0 then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          shl edx,$11      {}@@rgb_greenRShift:  // Surface.rgb_green.rshift
          and edx,$11111111{}@@rgb_greenMask:    // Surface.rgb_green.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@rgb_greenMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_green.Mask]
          mov edx,offset @@rgb_greenMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_greenRShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_green.rshift]
          mov edx,offset @@rgb_greenRShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end else
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          shr edx,$11      {}@@rgb_greenLShift:  // Surface.rgb_green.lshift
          and edx,$11111111{}@@rgb_greenMask:    // Surface.rgb_green.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@rgb_greenMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_green.Mask]
          mov edx,offset @@rgb_greenMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_greenLShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_green.lshift]
          mov edx,offset @@rgb_greenLShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end;
    end;

    {  Blue channel  }
    if chBlue in EnableChannels then
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        movzx edx,byte ptr [offset _null]{}@@Src:// @Src.B
      @@EndCode:
        {$I DXRender.inc}
        {  @@Src  }
        mov eax,Src; add eax,Byte(TDXRMachine_Color.B+1)
        mov edx,offset @@Src-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;

      if Surface.rgb_blue.Bitcount<7 then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          mov ebx,edx
          shr ebx,$11       {}@@BitCount:  // 6-bitcount
          and ebx,3
          movzx ebx,byte ptr [ebp+ebx*4]
          shl ebx,$11       {}@@BitCount2: // 8-bitcount
          movzx edx,byte [offset (_AddTable+edx+ebx)]
        @@EndCode:
          {$I DXRender.inc}
          {  @@BitCount  }
          mov eax,6; mov edx,Surface; sub eax,[edx + TDXR_Surface.rgb_blue.Bitcount]
          mov edx,offset @@BitCount-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al

          {  @@BitCount2  }
          mov eax,8; mov edx,Surface; sub eax,[edx + TDXR_Surface.rgb_blue.Bitcount]
          mov edx,offset @@BitCount2-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end;

      if Surface.rgb_blue.rshift<>0 then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          shl edx,$11      {}@@rgb_blueRShift:  // Surface.rgb_blue.rshift
          and edx,$11111111{}@@rgb_blueMask:    // Surface.rgb_blue.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@rgb_blueMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_blue.Mask]
          mov edx,offset @@rgb_blueMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_blueRShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_blue.rshift]
          mov edx,offset @@rgb_blueRShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end else
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          shr edx,$11      {}@@rgb_blueLShift:  // Surface.rgb_blue.lshift
          and edx,$11111111{}@@rgb_blueMask:    // Surface.rgb_blue.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@rgb_blueMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_blue.Mask]
          mov edx,offset @@rgb_blueMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_blueLShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_blue.lshift]
          mov edx,offset @@rgb_blueLShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end;
    end;

    {  Alpha channel  }
    if chAlpha in EnableChannels then
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        movzx edx,byte ptr [offset _null]{}@@Src:// @Src.R
      @@EndCode:
        {$I DXRender.inc}
        {  @@Src  }
        mov eax,Src; add eax,Byte(TDXRMachine_Color.A+1)
        mov edx,offset @@Src-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;

      if Surface.rgb_alpha.Bitcount<7 then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          mov ebx,edx
          shr ebx,$11       {}@@BitCount:  // 6-bitcount
          and ebx,3
          movzx ebx,byte ptr [ebp+ebx]
          shl ebx,$11       {}@@BitCount2: // 8-bitcount
          movzx edx,byte [offset (_AddTable+edx+ebx)]
        @@EndCode:
          {$I DXRender.inc}
          {  @@BitCount  }
          mov eax,6; mov edx,Surface; sub eax,[edx + TDXR_Surface.rgb_alpha.Bitcount]
          mov edx,offset @@BitCount-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al

          {  @@BitCount2  }
          mov eax,8; mov edx,Surface; sub eax,[edx + TDXR_Surface.rgb_alpha.Bitcount]
          mov edx,offset @@BitCount2-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end;

      if Surface.rgb_alpha.rshift<>0 then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          shl edx,$11      {}@@rgb_alphaRShift:  // Surface.rgb_alpha.rshift
          and edx,$11111111{}@@rgb_alphaMask:    // Surface.rgb_alpha.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@rgb_alphaMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_alpha.Mask]
          mov edx,offset @@rgb_alphaMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_alphaRShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_alpha.rshift]
          mov edx,offset @@rgb_alphaRShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end else
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          shr edx,$11      {}@@rgb_alphaLShift:  // Surface.rgb_alpha.lshift
          and edx,$11111111{}@@rgb_alphaMask:    // Surface.rgb_alpha.Mask
          or eax,edx
        @@EndCode:
          {$I DXRender.inc}
          {  @@rgb_alphaMask  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_alpha.Mask]
          mov edx,offset @@rgb_alphaMask-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@rgb_alphaLShift  }
          mov eax,Surface; mov eax,[eax + TDXR_Surface.rgb_alpha.lshift]
          mov edx,offset @@rgb_alphaLShift-1
          sub edx,offset @@StartCode
          mov byte ptr [ecx+edx],al
        end;
      end;
    end;
  end;

  procedure genEncodeColor2(var Code: Pointer; const Surface: TDXR_Surface; Src: PDXRMachine_Color; EnableChannels: TDXRColorChannels);
  begin
    if Dither.Enable then
    begin
      genEncodeColor_with_Dither(Code, Surface, Src, @Axis.Axis, EnableChannels)
    end else
    begin
      genEncodeColor(Code, Surface, Src, EnableChannels);
    end;
  end;

  procedure genColorKey(var Code: Pointer; const Texture: TDXRMachine_Reg_Texture);
  var
    TransparentMask, TransparentColor: DWORD;
  begin
    if not Texture.ColorKeyEnable then Exit;

    if Texture.Surface.ColorType=DXR_COLORTYPE_INDEXED then
    begin
      TransparentMask := not Texture.Surface.idx_alpha.Mask;
    end else if Texture.Surface.ColorType=DXR_COLORTYPE_RGB then
    begin
      TransparentMask := not Texture.Surface.rgb_alpha.Mask;
    end;

    TransparentColor := Texture.ColorKey;

    if TransparentMask=$FFFFFFFF then
    begin
      if Texture.Surface.BitCount=32 then
      begin
        if TransparentColor=0 then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            and eax,$FFFFFF
          @@EndCode:
            {$I DXRender.inc}
          end;
        end else
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            and eax,$FFFFFF
            cmp eax,$11111111{}@@TransColor: // Process.Texture.TransparentColor
          @@EndCode:
            {$I DXRender.inc}
            {  @@TransColor  }
            mov eax,TransparentColor
            mov edx,offset @@TransColor-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end else
      begin
        if TransparentColor=0 then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            test eax,eax
          @@EndCode:
            {$I DXRender.inc}
          end;
        end else
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            cmp eax,$11111111{}@@TransColor: // Process.Texture.TransparentColor
          @@EndCode:
            {$I DXRender.inc}
            {  @@TransColor  }
            mov eax,TransparentColor
            mov edx,offset @@TransColor-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end;
    end else
    begin
      if Texture.Surface.BitCount=32 then
        TransparentMask := TransparentMask and $FFFFFF;

      asm
        jmp @@EndCode
      @@StartCode:
        mov edx,eax
        and edx,$11111111{}@@TransMask:  // TransparentMask
        cmp edx,$11111111{}@@TransColor: // Process.Texture.TransparentColor
      @@EndCode:
        {$I DXRender.inc}
        {  @@TransMask  }
        mov eax,TransparentMask
        mov edx,offset @@TransMask-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@TransColor  }
        mov eax,TransparentColor
        mov edx,offset @@TransColor-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;
    end;

    genCmpFunc(Code, DXR_CMPFUNC_EQUAL, SkipAddress);
  end;

  procedure genReadTexture_Nearest(var Code: Pointer; Dest: PDXRMachine_Color;
    const Texture: TDXRMachine_Reg_Texture; const Axis: TDXRMachine_Axis; EnableChannels: TDXRColorChannels);
  begin
    if EnableChannels=[] then Exit;

    genReadSurfacePixel(Code, Texture, @Axis);
    genColorKey(Code, Texture);
    genDecodeColor(Code, Texture.Surface^, Dest, EnableChannels, Texture.DefaultColor);
  end;

  procedure genReadTexture_BiLinear(var Code: Pointer; Dest: PDXRMachine_Color;
    const Texture: TDXRMachine_Reg_Texture; const Axis: TDXRMachine_Axis; EnableChannels: TDXRColorChannels);
  var
    _Axis, _BiLinearAxis, _BiLinearCol1, _BiLinearCol2, _BiLinearCol3, _BiLinearCol4: Pointer;
  begin
    if EnableChannels=[] then Exit;

    _Axis := @Axis;
    _BiLinearAxis := @F_BiLinearAxis;
    _BiLinearCol1 := @F_BiLinearCol1;
    _BiLinearCol2 := @F_BiLinearCol2;
    _BiLinearCol3 := @F_BiLinearCol3;
    _BiLinearCol4 := @F_BiLinearCol4;

    genReadSurfacePixel(Code, Texture, _Axis);
    genColorKey(Code, Texture);
    genDecodeColor(Code, Texture.Surface^, _BiLinearCol1, EnableChannels, Texture.DefaultColor);

    asm
      jmp @@EndCode
    @@StartCode:
      mov eax,dword ptr [offset _null]{}@@TexX:
      mov edx,dword ptr [offset _null]{}@@TexY:
      add eax,65536
      mov dword ptr [offset _null],edx{}@@AxisY:
      mov dword ptr [offset _null],eax{}@@AxisX:
    @@EndCode:
      {$I DXRender.inc}
      {  @@TexX  }
      mov eax,_Axis; add eax,TDXRMachine_Axis.X
      mov edx,offset @@TexX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@TexY  }
      mov eax,_Axis; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@TexY-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@AxisX  }
      mov eax,_BiLinearAxis; add eax,TDXRMachine_Axis.X
      mov edx,offset @@AxisX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@AxisY  }
      mov eax,_BiLinearAxis; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@AxisY-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;
    genReadSurfacePixel(Code, Texture, _BiLinearAxis);
    genDecodeColor(Code, Texture.Surface^, _BiLinearCol2, EnableChannels, Texture.DefaultColor);

    asm
      jmp @@EndCode
    @@StartCode:
      add dword ptr [offset _null],65536{}@@AxisY:
    @@EndCode:
      {$I DXRender.inc}
      {  @@AxisY  }
      mov eax,_BiLinearAxis; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@AxisY-8
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;
    genReadSurfacePixel(Code, Texture, _BiLinearAxis);
    genDecodeColor(Code, Texture.Surface^, _BiLinearCol4, EnableChannels, Texture.DefaultColor);

    asm
      jmp @@EndCode
    @@StartCode:
      sub dword ptr [offset _null],65536{}@@AxisX:
    @@EndCode:
      {$I DXRender.inc}
      {  @@AxisX  }
      mov eax,_BiLinearAxis; add eax,TDXRMachine_Axis.X
      mov edx,offset @@AxisX-8
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;
    genReadSurfacePixel(Code, Texture, _BiLinearAxis);
    genDecodeColor(Code, Texture.Surface^, _BiLinearCol3, EnableChannels, Texture.DefaultColor);
                 (*
    if UseMMX then
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        movzx eax,byte ptr [offset _null]{}@@TexX:
        movzx edx,byte ptr [offset _null]{}@@TexY:

        db $0F,$6F,$1C,$C5,$11,$11,$11,$11///movq mm3,qword ptr [$11111111+eax*8]
                               @@_ByteToQWORDTable1:
        xor eax,$FF
        db $0F,$6F,$24,$C5,$11,$11,$11,$11///movq mm4,qword ptr [$11111111+eax*8]
                               @@_ByteToQWORDTable2:

        db $0F,$6F,$05,$11,$11,$11,$11///movq mm0,qword ptr [$11111111]
                               @@_BiLinearCol1:
        db $0F,$6F,$0D,$11,$11,$11,$11///movq mm1,qword ptr [$11111111]
                               @@_BiLinearCol2:

        db $0F,$D5,$C3        ///pmullw mm0,mm3
        db $0F,$D5,$CC        ///pmullw mm1,mm4
        db $0F,$FD,$C1        ///paddw mm0,mm1
        db $0F,$71,$D0,$08    ///psrlw mm0,8

        db $0F,$6F,$0D,$11,$11,$11,$11///movq mm1,qword ptr [$11111111]
                               @@_BiLinearCol3:
        db $0F,$6F,$15,$11,$11,$11,$11///movq mm2,qword ptr [$11111111]
                               @@_BiLinearCol4:

        db $0F,$D5,$CB        ///pmullw mm1,mm3
        db $0F,$D5,$D4        ///pmullw mm2,mm4
        db $0F,$FD,$CA        ///paddw mm1,mm2
        db $0F,$71,$D1,$08    ///psrlw mm1,8

        db $0F,$D5,$04,$D5,$11,$11,$11,$11///pmullw mm0,qword ptr [$11111111+edx*8]
                               @@_ByteToQWORDTable3:
        xor edx,$FF
        db $0F,$D5,$0C,$D5,$11,$11,$11,$11///pmullw mm1,qword ptr [$11111111+edx*8]
                               @@_ByteToQWORDTable4:
        db $0F,$FD,$C1        ///paddw mm0,mm1
        db $0F,$71,$D0,$08    ///psrlw mm0,8

        db $0F,$7F,$05,$11,$11,$11,$11///movq qword ptr [$11111111],mm0
                               @@Dest:
      @@EndCode:
        {$I DXRender.inc}
        {  @@TexX  }
        mov eax,_Axis; add eax,TDXRMachine_Axis.X+1
        mov edx,offset @@TexX-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@TexY  }
        mov eax,_Axis; add eax,TDXRMachine_Axis.Y+1
        mov edx,offset @@TexY-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@_ByteToQWORDTable1  }
        mov eax,offset _ByteToQWORDTable
        mov edx,offset @@_ByteToQWORDTable1-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@_ByteToQWORDTable2  }
        mov eax,offset _ByteToQWORDTable
        mov edx,offset @@_ByteToQWORDTable2-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@_ByteToQWORDTable3  }
        mov eax,offset _ByteToQWORDTable
        mov edx,offset @@_ByteToQWORDTable3-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@_ByteToQWORDTable4  }
        mov eax,offset _ByteToQWORDTable
        mov edx,offset @@_ByteToQWORDTable4-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@_BiLinearCol1  }
        mov eax,_BiLinearCol1
        mov edx,offset @@_BiLinearCol1-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@_BiLinearCol2  }
        mov eax,_BiLinearCol2
        mov edx,offset @@_BiLinearCol2-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@_BiLinearCol3  }
        mov eax,_BiLinearCol3
        mov edx,offset @@_BiLinearCol3-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@_BiLinearCol4  }
        mov eax,_BiLinearCol4
        mov edx,offset @@_BiLinearCol4-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@Dest  }
        mov eax,Dest
        mov edx,offset @@Dest-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;
    end else       *)
    begin
      {  Red Channel  }
      if chRed in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx eax,byte ptr [offset _null]{}@@_BiLinearCol2:
          movzx edx,byte ptr [offset _null]{}@@TexX:
          imul eax,edx
          movzx ebx,byte ptr [offset _null]{}@@_BiLinearCol1:
          xor edx,$FF
          imul ebx,edx
          add ebx,eax
          xor edx,$FF

          movzx eax,byte ptr [offset _null]{}@@_BiLinearCol4:
          imul eax,edx
          movzx ebp,byte ptr [offset _null]{}@@_BiLinearCol3:
          xor edx,$FF
          imul ebp,edx
          add eax,ebp

          movzx edx,byte ptr [offset _Null]{}@@TexY:
          imul eax,edx
          xor edx,$FF
          imul ebx,edx
          add eax,ebx
          shr eax,16

          mov byte ptr [offset _Null],al{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@_BiLinearCol1  }
          mov eax,_BiLinearCol1; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@_BiLinearCol1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@_BiLinearCol2  }
          mov eax,_BiLinearCol2; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@_BiLinearCol2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@_BiLinearCol3  }
          mov eax,_BiLinearCol3; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@_BiLinearCol3-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@_BiLinearCol4  }
          mov eax,_BiLinearCol4; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@_BiLinearCol4-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@TexX  }
          mov eax,_Axis; add eax,TDXRMachine_Axis.X+1
          mov edx,offset @@TexX-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@TexY  }
          mov eax,_Axis; add eax,TDXRMachine_Axis.Y+1
          mov edx,offset @@TexY-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;

      {  Green Channel  }
      if chGreen in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx eax,byte ptr [offset _null]{}@@_BiLinearCol2:
          movzx edx,byte ptr [offset _null]{}@@TexX:
          imul eax,edx
          movzx ebx,byte ptr [offset _null]{}@@_BiLinearCol1:
          xor edx,$FF
          imul ebx,edx
          add ebx,eax
          xor edx,$FF

          movzx eax,byte ptr [offset _null]{}@@_BiLinearCol4:
          imul eax,edx
          movzx ebp,byte ptr [offset _null]{}@@_BiLinearCol3:
          xor edx,$FF
          imul ebp,edx
          add eax,ebp

          movzx edx,byte ptr [offset _Null]{}@@TexY:
          imul eax,edx
          xor edx,$FF
          imul ebx,edx
          add eax,ebx
          shr eax,16

          mov byte ptr [offset _Null],al{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@_BiLinearCol1  }
          mov eax,_BiLinearCol1; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@_BiLinearCol1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@_BiLinearCol2  }
          mov eax,_BiLinearCol2; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@_BiLinearCol2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@_BiLinearCol3  }
          mov eax,_BiLinearCol3; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@_BiLinearCol3-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@_BiLinearCol4  }
          mov eax,_BiLinearCol4; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@_BiLinearCol4-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@TexX  }
          mov eax,_Axis; add eax,TDXRMachine_Axis.X+1
          mov edx,offset @@TexX-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@TexY  }
          mov eax,_Axis; add eax,TDXRMachine_Axis.Y+1
          mov edx,offset @@TexY-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;

      {  Blue Channel  }
      if chBlue in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx eax,byte ptr [offset _null]{}@@_BiLinearCol2:
          movzx edx,byte ptr [offset _null]{}@@TexX:
          imul eax,edx
          movzx ebx,byte ptr [offset _null]{}@@_BiLinearCol1:
          xor edx,$FF
          imul ebx,edx
          add ebx,eax
          xor edx,$FF

          movzx eax,byte ptr [offset _null]{}@@_BiLinearCol4:
          imul eax,edx
          movzx ebp,byte ptr [offset _null]{}@@_BiLinearCol3:
          xor edx,$FF
          imul ebp,edx
          add eax,ebp

          movzx edx,byte ptr [offset _Null]{}@@TexY:
          imul eax,edx
          xor edx,$FF
          imul ebx,edx
          add eax,ebx
          shr eax,16

          mov byte ptr [offset _Null],al{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@_BiLinearCol1  }
          mov eax,_BiLinearCol1; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@_BiLinearCol1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@_BiLinearCol2  }
          mov eax,_BiLinearCol2; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@_BiLinearCol2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@_BiLinearCol3  }
          mov eax,_BiLinearCol3; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@_BiLinearCol3-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@_BiLinearCol4  }
          mov eax,_BiLinearCol4; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@_BiLinearCol4-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@TexX  }
          mov eax,_Axis; add eax,TDXRMachine_Axis.X+1
          mov edx,offset @@TexX-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@TexY  }
          mov eax,_Axis; add eax,TDXRMachine_Axis.Y+1
          mov edx,offset @@TexY-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;

      {  Alpha Channel  }
      if chAlpha in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx eax,byte ptr [offset _null]{}@@_BiLinearCol2:
          movzx edx,byte ptr [offset _null]{}@@TexX:
          imul eax,edx
          movzx ebx,byte ptr [offset _null]{}@@_BiLinearCol1:
          xor edx,$FF
          imul ebx,edx
          add ebx,eax
          xor edx,$FF

          movzx eax,byte ptr [offset _null]{}@@_BiLinearCol4:
          imul eax,edx
          movzx ebp,byte ptr [offset _null]{}@@_BiLinearCol3:
          xor edx,$FF
          imul ebp,edx
          add eax,ebp

          movzx edx,byte ptr [offset _Null]{}@@TexY:
          imul eax,edx
          xor edx,$FF
          imul ebx,edx
          add eax,ebx
          shr eax,16

          mov byte ptr [offset _Null],al{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@_BiLinearCol1  }
          mov eax,_BiLinearCol1; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@_BiLinearCol1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@_BiLinearCol2  }
          mov eax,_BiLinearCol2; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@_BiLinearCol2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@_BiLinearCol3  }
          mov eax,_BiLinearCol3; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@_BiLinearCol3-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@_BiLinearCol4  }
          mov eax,_BiLinearCol4; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@_BiLinearCol4-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@TexX  }
          mov eax,_Axis; add eax,TDXRMachine_Axis.X+1
          mov edx,offset @@TexX-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@TexY  }
          mov eax,_Axis; add eax,TDXRMachine_Axis.Y+1
          mov edx,offset @@TexY-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;
    end;
  end;

  procedure genReadTexture(var Code: Pointer; Dest: PDXRMachine_Color;
    const Texture: TDXRMachine_Reg_Texture; EnableChannels: TDXRColorChannels);
  begin
    if Texture.Filter in [DXR_TEXTUREFILTER_LINEAR, DXR_TEXTUREFILTER_MIPMAP_LINEAR] then
      genReadTexture_BiLinear(Code, Dest, Texture, Texture.nAxis, EnableChannels)
    else
      genReadTexture_Nearest(Code, Dest, Texture, Texture.nAxis, EnableChannels);
  end;

  procedure genReadBumpTexture_Nearest(var Code: Pointer; Dest: PDXRMachine_Color;
    const Texture, BumpTexture: TDXRMachine_Reg_Texture; EnableChannels: TDXRColorChannels);
  var
    _Axis, _Axis2, _iAxis, _BumpAxis, _BumpAxis2: PDXRMachine_Axis;
    _BumpTempCol: Pointer;
  begin
    if EnableChannels=[] then Exit;

    _Axis := @BumpTexture.nAxis;
    _Axis2 := @Texture.nAxis;
    _iAxis := @BumpTexture.iAxis;
    _BumpAxis := @F_BumpAxis;
    _BumpAxis2 := @F_BumpAxis2;
    _BumpTempCol := @F_BumpTempCol;

    {  X  } 
    asm
      jmp @@EndCode
    @@StartCode:
      mov eax,dword ptr [offset _null]{}@@TexX:
      mov edx,dword ptr [offset _null]{}@@TexY:
      sub eax,dword ptr [offset _null]{}@@iTexX:
      mov dword ptr [offset _null],edx{}@@AxisY:
      mov dword ptr [offset _null],eax{}@@AxisX:
    @@EndCode:
      {$I DXRender.inc}
      {  @@TexX  }
      mov eax,_Axis; add eax,TDXRMachine_Axis.X
      mov edx,offset @@TexX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@TexY  }
      mov eax,_Axis; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@TexY-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@iTexX  }
      mov eax,_iAxis; add eax,TDXRMachine_Axis.X
      mov edx,offset @@iTexX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@AxisX  }
      mov eax,_BumpAxis; add eax,TDXRMachine_Axis.X
      mov edx,offset @@AxisX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@AxisY  }
      mov eax,_BumpAxis; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@AxisY-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;
    genReadSurfacePixel(Code, BumpTexture, _BumpAxis);

    asm
      jmp @@EndCode
    @@StartCode:
      mov dword ptr [offset _null],eax{}@@BumpTempCol:
    @@EndCode:
      {$I DXRender.inc}
      {  @@BumpTempCol  }
      mov eax,_BumpTempCol
      mov edx,offset @@BumpTempCol-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;

    asm
      jmp @@EndCode
    @@StartCode:
      mov edx,dword ptr [offset _null]{}@@iAxisX:
      add dword ptr [offset _null],edx{}@@AxisX:
    @@EndCode:
      {$I DXRender.inc}
      {  @@iAxisX  }
      mov eax,_iAxis; add eax,TDXRMachine_Axis.X
      mov edx,offset @@iAxisX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@AxisX  }
      mov eax,_BumpAxis; add eax,TDXRMachine_Axis.X
      mov edx,offset @@AxisX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;

    genReadSurfacePixel(Code, BumpTexture, _BumpAxis);

    asm
      jmp @@EndCode
    @@StartCode:
      sub eax,dword ptr [offset _null]{}@@BumpTempCol:
      sal eax,16
      add eax,dword ptr [offset _null]{}@@TexX:
      mov dword ptr [offset _null],eax{}@@AxisX:
    @@EndCode:
      {$I DXRender.inc}
      {  @@BumpTempCol  }
      mov eax,_BumpTempCol
      mov edx,offset @@BumpTempCol-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@TexX  }
      mov eax,_Axis2; add eax,TDXRMachine_Axis.X
      mov edx,offset @@TexX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@AxisX  }
      mov eax,_BumpAxis2; add eax,TDXRMachine_Axis.X
      mov edx,offset @@AxisX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;

    {  Y  }
    asm
      jmp @@EndCode
    @@StartCode:
      mov eax,dword ptr [offset _null]{}@@TexX:
      mov edx,dword ptr [offset _null]{}@@TexY:
      sub edx,dword ptr [offset _null]{}@@iTexY:
      mov dword ptr [offset _null],eax{}@@AxisX:
      mov dword ptr [offset _null],edx{}@@AxisY:
    @@EndCode:
      {$I DXRender.inc}
      {  @@TexX  }
      mov eax,_Axis; add eax,TDXRMachine_Axis.X
      mov edx,offset @@TexX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@TexY  }
      mov eax,_Axis; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@TexY-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@iTexY  }
      mov eax,_iAxis; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@iTexY-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@AxisX  }
      mov eax,_BumpAxis; add eax,TDXRMachine_Axis.X
      mov edx,offset @@AxisX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@AxisY  }
      mov eax,_BumpAxis; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@AxisY-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;
    genReadSurfacePixel(Code, BumpTexture, _BumpTempCol);

    asm
      jmp @@EndCode
    @@StartCode:
      mov dword ptr [offset _null],eax{}@@BumpTempCol:
    @@EndCode:
      {$I DXRender.inc}
      {  @@BumpTempCol  }
      mov eax,_BumpTempCol
      mov edx,offset @@BumpTempCol-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;

    asm
      jmp @@EndCode
    @@StartCode:
      mov edx,dword ptr [offset _null]{}@@iAxisY:
      sal edx,1
      sub dword ptr [offset _null],edx{}@@AxisY:
    @@EndCode:
      {$I DXRender.inc}
      {  @@iAxisY  }
      mov eax,_iAxis; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@iAxisY-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@AxisY  }
      mov eax,_BumpAxis; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@AxisY-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;

    genReadSurfacePixel(Code, BumpTexture, _BumpAxis);

    asm
      jmp @@EndCode
    @@StartCode:
      sub eax,dword ptr [offset _null]{}@@BumpTempCol:
      sal eax,16
      add eax,dword ptr [offset _null]{}@@TexY:
      mov dword ptr [offset _null],eax{}@@AxisY:
    @@EndCode:
      {$I DXRender.inc}
      {  @@BumpTempCol  }
      mov eax,_BumpTempCol
      mov edx,offset @@BumpTempCol-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@TexX  }
      mov eax,_Axis2; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@TexY-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@AxisX  }
      mov eax,_BumpAxis2; add eax,TDXRMachine_Axis.Y
      mov edx,offset @@AxisY-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;

    genReadTexture_Nearest(Code, Dest, Texture, _BumpAxis2^, EnableChannels);
  end;

  procedure genReadBumpTexture(var Code: Pointer; Dest: PDXRMachine_Color;
    const Texture, BumpTexture: TDXRMachine_Reg_Texture; EnableChannels: TDXRColorChannels);
  begin
    {if Texture.Filter in [DXR_TEXTUREFILTER_LINEAR, DXR_TEXTUREFILTER_MIPMAP_LINEAR] then
      genReadBumpTexture_BiLinear(Code, Dest, Texture, BumpTexture, EnableChannels)
    else }
      genReadBumpTexture_Nearest(Code, Dest, Texture, BumpTexture, EnableChannels);
  end;

  procedure genUpdateAxis(var Code: Pointer);
  var
    _Axis: Pointer;
  begin
    if not Axis.IncEnable then Exit;

    _Axis := @Axis.Axis;

    asm
      jmp @@EndCode
    @@StartCode:
      inc dword ptr [offset _null]{}@@AxisX:
    @@EndCode:
      {$I DXRender.inc}
      {  @@AxisX  }
      mov eax,_Axis; add eax,TDXRMachine_Axis.X
      mov edx,offset @@AxisX-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;
  end;

  procedure genUpdateColor(var Code: Pointer);
  var
    i: Integer;
    Color: PDXRMachine_Reg_Color;
    nColor, iColor: Pointer;
  begin
    for i:=0 to ColorIndexCount-1 do
    begin
      Color := @ColorList[ColorIndex[i]];
      if Color.Gouraud then
      begin
        nColor := @Color.nColor;
        iColor := @Color.iColor;

        if UseMMX then
        begin
          FMMXUsed := True;
          asm
            jmp @@EndCode
          @@StartCode:
            db $0F,$6F,$05,$11,$11,$11,$11///movq mm0,qword ptr [$11111111]
                                   @@_nColor:
            db $0F,$FD,$05,$11,$11,$11,$11///paddw mm0,qword ptr [$11111111]
                                   @@_iColor:
            db $0F,$7F,$05,$11,$11,$11,$11///movq qword ptr [$11111111],mm0
                                   @@_nColor2:
          @@EndCode:
            {$I DXRender.inc}
            {  @@_nColor  }
            mov eax,nColor
            mov edx,offset @@_nColor-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@_iColor  }
            mov eax,iColor
            mov edx,offset @@_iColor-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@_nColor2  }
            mov eax,nColor
            mov edx,offset @@_nColor2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end else
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov eax,dword ptr [offset _null]{}@@nColor11:
            mov edx,dword ptr [offset _null]{}@@nColor12:
            add eax,dword ptr [offset _null]{}@@iColor1:
            add edx,dword ptr [offset _null]{}@@iColor2:
            mov dword ptr [offset _null],eax{}@@nColor21:
            mov dword ptr [offset _null],edx{}@@nColor22:
          @@EndCode:
            {$I DXRender.inc}

            {  @@nColor11  }
            mov eax,nColor
            mov edx,offset @@nColor11-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@nColor12  }
            mov eax,nColor; add eax,4
            mov edx,offset @@nColor12-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@iColor1  }
            mov eax,iColor
            mov edx,offset @@iColor1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@iColor2  }
            mov eax,iColor; add eax,4
            mov edx,offset @@iColor2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@nColor21  }
            mov eax,nColor
            mov edx,offset @@nColor21-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@nColor22  }
            mov eax,nColor; add eax,4
            mov edx,offset @@nColor22-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end;
    end;
  end;

  procedure genUpdateTextureAxis(var Code: Pointer);
  var
    i: Integer;
    Texture: PDXRMachine_Reg_Texture;
    nTex, iTex: Pointer;
  begin
    for i:=0 to TextureIndexCount-1 do
    begin
      Texture := @TextureList[TextureIndex[i]];

      nTex := @Texture.nAxis;
      iTex := @Texture.iAxis;

      if UseMMX then
      begin
        FMMXUsed := True;
        asm
          jmp @@EndCode
        @@StartCode:
          db $0F,$6F,$05,$11,$11,$11,$11///movq mm0,qword ptr [$11111111]
                                 @@nTex:
          db $0F,$FE,$05,$11,$11,$11,$11///paddd mm0,qword ptr [$11111111]
                                 @@iTex:
          db $0F,$7F,$05,$11,$11,$11,$11///movq qword ptr [$11111111],mm0
                                 @@nTex2:
        @@EndCode:
          {$I DXRender.inc}
          {  @@nTex  }
          mov eax,nTex
          mov edx,offset @@nTex-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@nTex2  }
          mov eax,nTex
          mov edx,offset @@nTex2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@iTex  }
          mov eax,iTex
          mov edx,offset @@iTex-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end else
      begin
        if Texture.iAxisConstant then
        begin
          if Texture.iAxis.X<>0 then
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              add dword ptr [offset _Null],$11111111{}@@nTexX:
            @@EndCode:
              {$I DXRender.inc}
              {  @@nTexX  }
              mov eax,iTex; add eax,TDXRMachine_Axis.X; mov eax,dword ptr [eax]
              mov edx,offset @@nTexX-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax

              mov eax,nTex; add eax,TDXRMachine_Axis.X
              mov edx,offset @@nTexX-8
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end;

          if Texture.iAxis.Y<>0 then
          begin
            asm
              jmp @@EndCode
            @@StartCode:
              add dword ptr [offset _Null],$11111111{}@@nTexY:
            @@EndCode:
              {$I DXRender.inc}
              {  @@nTexY  }
              mov eax,iTex; add eax,TDXRMachine_Axis.Y; mov eax,dword ptr [eax]
              mov edx,offset @@nTexY-4
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
                                         
              mov eax,nTex; add eax,TDXRMachine_Axis.Y
              mov edx,offset @@nTexY-8
              sub edx,offset @@StartCode
              mov dword ptr [ecx+edx],eax
            end;
          end;
        end else
        //begin
         if UseMMX then
         begin
          FMMXUsed := True;
          asm
            jmp @@EndCode
          @@StartCode:
            db $0F,$6F,$05,$11,$11,$11,$11///movq mm0,qword ptr [$11111111]
                                   @@nTex:
            db $0F,$FE,$05,$11,$11,$11,$11///paddd mm0,qword ptr [$11111111]
                                   @@iTex:
            db $0F,$7F,$05,$11,$11,$11,$11///movq qword ptr [$11111111],mm0
                                   @@nTex2:
          @@EndCode:
            {$I DXRender.inc}
            {  @@nTex  }
            mov eax,nTex
            mov edx,offset @@nTex-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@nTex2  }
            mov eax,nTex
            mov edx,offset @@nTex2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@iTex  }
            mov eax,iTex
            mov edx,offset @@iTex-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
         end else
         begin

          asm
            jmp @@EndCode
          @@StartCode:
            mov eax,dword ptr [offset _Null]{}@@iTexX:
            mov edx,dword ptr [offset _Null]{}@@iTexY:
            add dword ptr [offset _Null],eax{}@@nTexX:
            add dword ptr [offset _Null],edx{}@@nTexY:
          @@EndCode:
            {$I DXRender.inc}
            {  @@iTexX  }
            mov eax,iTex; add eax,TDXRMachine_Axis.X
            mov edx,offset @@iTexX-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@iTexY  }
            mov eax,iTex; add eax,TDXRMachine_Axis.Y
            mov edx,offset @@iTexY-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@nTexX  }
            mov eax,nTex; add eax,TDXRMachine_Axis.X
            mov edx,offset @@nTexX-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@nTexY  }
            mov eax,nTex; add eax,TDXRMachine_Axis.Y
            mov edx,offset @@nTexY-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end;
    end;
  end;

  procedure genUpdateRHW(var Code: Pointer);
  var
    nRHW, iRHW: Pointer;
  begin
    if not RHW.Enable then Exit;

    nRHW := @RHW.nRHW;
    iRHW := @RHW.iRHW;

    asm
      jmp @@EndCode
    @@StartCode:
      // 64 bit addition
      mov eax,dword ptr [offset _null]{}@@iRHW:
      mov edx,dword ptr [offset _null]{}@@iRHW2:
      add dword ptr [offset _null],eax{}@@nRHW:
      adc dword ptr [offset _null],edx{}@@nRHW2:
    @@EndCode:
      {$I DXRender.inc}
      {  @@nRHW  }
      mov eax,nRHW
      mov edx,offset @@nRHW-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@nRHW2  }
      mov eax,nRHW; add eax,4
      mov edx,offset @@nRHW2-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@iRHW  }
      mov eax,iRHW
      mov edx,offset @@iRHW-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax

      {  @@iRHW  }
      mov eax,iRHW; add eax,4
      mov edx,offset @@iRHW2-4
      sub edx,offset @@StartCode
      mov dword ptr [ecx+edx],eax
    end;
  end;

  procedure genBlend(var Code: Pointer; Blend: TDXR_Blend;
    Dest, Col1, Col2: PDXRMachine_Color; EnableChannels: TDXRColorChannels;
    ConstChannels1, ConstChannels2: TDXRColorChannels);

    procedure Func_col1_Add_col2(var Code: Pointer; Dest, col1, col2: PWord);
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        movzx eax,byte ptr [offset _null]{}@@Col1:
        movzx edx,byte ptr [offset _null]{}@@Col2:
        mov al,byte ptr [offset (_AddTable + eax + edx)]
        mov byte ptr [offset _null],al{}@@Dest:
      @@EndCode:
        {$I DXRender.inc}
        {  @@Col1  }
        mov eax,Col1; inc eax
        mov edx,offset @@Col1-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@Col2  }
        mov eax,Col2; inc eax
        mov edx,offset @@Col2-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@Dest  }
        mov eax,Dest; inc eax
        mov edx,offset @@Dest-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;
    end;

    procedure Func_col1_Add_const2(var Code: Pointer; Dest, col1, col2: PWord);
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        movzx eax,byte ptr [offset _null]{}@@Col1:
        mov al,byte ptr [$11111111 + eax]{}@@Col2:
        mov byte ptr [offset _null],al{}@@Dest:
      @@EndCode:
        {$I DXRender.inc}
        {  @@Col1  }
        mov eax,Col1; inc eax
        mov edx,offset @@Col1-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@Col2  }
        mov eax,Col2; inc eax; movzx eax,byte ptr [eax]
        add eax,offset _AddTable

        mov edx,offset @@Col2-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@Dest  }
        mov eax,Dest; inc eax
        mov edx,offset @@Dest-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;
    end;

    procedure Func_col1_Sub_col2(var Code: Pointer; Dest, col1, col2: PWord);
    begin
      asm
        jmp @@EndCode
      @@StartCode:    
        movzx eax,byte ptr [offset _null]{}@@Col1:
        movzx edx,byte ptr [offset _null]{}@@Col2:
        sub eax,edx
        mov al,byte ptr [offset (_SubTable + 255 + eax)]
        mov byte ptr [offset _null],al{}@@Dest:
      @@EndCode:
        {$I DXRender.inc}
        {  @@Col1  }
        mov eax,Col1; inc eax
        mov edx,offset @@Col1-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@Col2  }
        mov eax,Col2; inc eax
        mov edx,offset @@Col2-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@Dest  }
        mov eax,Dest; inc eax
        mov edx,offset @@Dest-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;
    end;

    procedure Func_const1_Sub_col2(var Code: Pointer; Dest, col1, col2: PWord);
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        mov eax,$11111111{}@@Col1:
        movzx edx,byte ptr [offset _null]{}@@Col2:
        sub eax,edx
        mov al,byte ptr [offset (_SubTable + 255 + eax)]
        mov byte ptr [offset _null],al{}@@Dest:
      @@EndCode:
        {$I DXRender.inc}
        {  @@Col1  }
        mov eax,Col1; inc eax; movzx eax,byte ptr [eax]
        mov edx,offset @@Col1-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@Col2  }
        mov eax,Col2; inc eax
        mov edx,offset @@Col2-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@Dest  }
        mov eax,Dest; inc eax
        mov edx,offset @@Dest-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;
    end;

    procedure Func_col1_Sub_const2(var Code: Pointer; Dest, col1, col2: PWord);
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        movzx eax,byte ptr [offset _null]{}@@Col1:
        mov al,byte ptr [$11111111 + eax]{}@@Col2:
        mov byte ptr [offset _null],al{}@@Dest:
      @@EndCode:
        {$I DXRender.inc}
        {  @@Col1  }
        mov eax,Col1; inc eax
        mov edx,offset @@Col1-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@Col2  }
        mov eax,Col2; inc eax; movzx eax,byte ptr [eax]; neg eax
        add eax,offset _SubTable+255

        mov edx,offset @@Col2-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@Dest  }
        mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
        mov edx,offset @@Dest-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;
    end;

    procedure genBlend_ZERO(var Code: Pointer; Dest: PDXRMachine_Color);
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        mov dword ptr [offset _null],0{}@@Dest:
        mov dword ptr [offset _null],0{}@@Dest2:
      @@EndCode:
        {$I DXRender.inc}
        {  @@Dest  }
        mov eax,Dest
        mov edx,offset @@Dest-8
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax

        {  @@Dest2  }
        mov eax,Dest; add eax,4
        mov edx,offset @@Dest2-8
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;
    end;

    procedure genBlend_ONE1(var Code: Pointer; Dest, Col1: PDXRMachine_Color;
      ConstChannels1: TDXRColorChannels);
    begin
      if Dest=Col1 then Exit;

      if UseMMX then //False then//UseMMX then
      begin
        FMMXUsed := True;
        asm
          jmp @@EndCode
        @@StartCode:
          db $0F,$6F,$05,$11,$11,$11,$11///movq mm0,qword ptr [$11111111]
                                 @@Col:
          db $0F,$7F,$05,$11,$11,$11,$11///movq qword ptr [$11111111],mm0
                                 @@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col  }
          mov eax,Col1
          mov edx,offset @@Col-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end else
      begin
        if ConstChannels1=[chRed, chGreen, chBlue, chAlpha] then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov dword ptr [offset _null],$11111111{}@@Dest:
            mov dword ptr [offset _null],$11111111{}@@Dest2:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Dest  }
            mov eax,Col1
            mov eax,dword ptr [eax]
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            mov eax,Dest
            mov edx,offset @@Dest-8
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest2  }
            mov eax,Col1; add eax,4
            mov eax,dword ptr [eax]
            mov edx,offset @@Dest2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            mov eax,Dest; add eax,8
            mov edx,offset @@Dest2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end else
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov eax,dword ptr [offset _null]{}@@Col:
            mov edx,dword ptr [offset _null]{}@@Col2:
            mov dword ptr [offset _null],eax{}@@Dest:
            mov dword ptr [offset _null],edx{}@@Dest2:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col  }
            mov eax,Col1
            mov edx,offset @@Col-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col1; add eax,4
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest2  }
            mov eax,Dest; add eax,4
            mov edx,offset @@Dest2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end;
    end;

    procedure genBlend_ONE1_ADD_ONE2(var Code: Pointer; Dest, Col1, Col2: PDXRMachine_Color;
      ConstChannels1, ConstChannels12: TDXRColorChannels);
    begin
      if UseMMX then
      begin
        FMMXUsed := True;
        asm
          jmp @@EndCode
        @@StartCode:
          db $0F,$6F,$05,$11,$11,$11,$11///movq mm0,qword ptr [$11111111]
                                 @@Col1:
          db $0F,$6F,$0D,$11,$11,$11,$11///movq mm1,qword ptr [$11111111]
                                 @@Col2:
          db $0F,$DD,$C1      ///paddusw mm0,mm1
          db $0F,$7F,$05,$11,$11,$11,$11///movq qword ptr [$11111111],mm0
                                 @@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end else
      begin
        { Red Channel }
        if chRed in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Add_const2(Code, @Dest.R, @Col2.R, @Col1.R);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_col1_Add_const2(Code, @Dest.R, @Col1.R, @Col2.R);
          end else
            Func_col1_Add_col2(Code, @Dest.R, @Col1.R, @Col2.R);
        end;

        { Green Channel }
        if chGreen in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Add_const2(Code, @Dest.G, @Col2.G, @Col1.G);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_col1_Add_const2(Code, @Dest.G, @Col1.G, @Col2.G);
          end else
            Func_col1_Add_col2(Code, @Dest.G, @Col1.G, @Col2.G);
        end;

        { Blue Channel }
        if chBlue in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Add_const2(Code, @Dest.B, @Col2.B, @Col1.B);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_col1_Add_const2(Code, @Dest.B, @Col1.B, @Col2.B);
          end else
            Func_col1_Add_col2(Code, @Dest.B, @Col1.B, @Col2.B);
        end;

        { Alpha Channel }
        if chAlpha in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Add_const2(Code, @Dest.A, @Col2.A, @Col1.A);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_col1_Add_const2(Code, @Dest.A, @Col1.A, @Col2.A);
          end else
            Func_col1_Add_col2(Code, @Dest.A, @Col1.A, @Col2.A);
        end;
      end;
    end;

    procedure genBlend_ONE2_SUB_ONE1(var Code: Pointer; Dest, Col1, Col2: PDXRMachine_Color;
      ConstChannels1, ConstChannels12: TDXRColorChannels);
    begin
      if UseMMX then
      begin
        FMMXUsed := True;
        asm
          jmp @@EndCode
        @@StartCode:
          db $0F,$6F,$05,$11,$11,$11,$11///movq mm0,qword ptr [$11111111]
                                 @@Col1:
          db $0F,$6F,$0D,$11,$11,$11,$11///movq mm1,qword ptr [$11111111]
                                 @@Col2:
          db $0F,$D9,$C8      ///psubusw mm1,mm0
          db $0F,$7F,$0D,$11,$11,$11,$11///movq qword ptr [$11111111],mm1
                                 @@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end else
      begin
        { Red Channel }
        if chRed in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Sub_const2(Code, @Dest.R, @Col2.R, @Col1.R);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_const1_Sub_col2(Code, @Dest.R, @Col1.R, @Col2.R);
          end else
            Func_col1_Sub_col2(Code, @Dest.R, @Col2.R, @Col1.R);
        end;

        { Green Channel }
        if chRed in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Sub_const2(Code, @Dest.G, @Col2.G, @Col1.G);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_const1_Sub_col2(Code, @Dest.G, @Col1.G, @Col2.G);
          end else
            Func_col1_Sub_col2(Code, @Dest.G, @Col2.G, @Col1.G);
        end;

        { Blue Channel }
        if chRed in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Sub_const2(Code, @Dest.B, @Col2.B, @Col1.B);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_const1_Sub_col2(Code, @Dest.B, @Col1.B, @Col2.B);
          end else
            Func_col1_Sub_col2(Code, @Dest.B, @Col2.B, @Col1.B);
        end;

        { Alpha Channel }
        if chRed in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Sub_const2(Code, @Dest.A, @Col2.A, @Col1.A);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_const1_Sub_col2(Code, @Dest.A, @Col1.A, @Col2.A);
          end else
            Func_col1_Sub_col2(Code, @Dest.A, @Col2.A, @Col1.A);
        end;
      end;
    end;

    procedure genBlend_ONE1_SUB_ONE2(var Code: Pointer; Dest, Col1, Col2: PDXRMachine_Color;
      ConstChannels1, ConstChannels12: TDXRColorChannels);
    begin
      if UseMMX then
      begin
        FMMXUsed := True;
        asm
          jmp @@EndCode
        @@StartCode:
          db $0F,$6F,$05,$11,$11,$11,$11/// movq mm0,qword ptr [$11111111]
                                 @@Col1:
          db $0F,$D9,$05,$11,$11,$11,$11/// psubusw mm0,qword ptr [$11111111]
                                 @@Col2:
          db $0F,$7F,$05,$11,$11,$11,$11/// movq qword ptr [$11111111],mm0
                                 @@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end else
      begin
        { Red Channel }
        if chRed in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Sub_const2(Code, @Dest.R, @Col1.R, @Col2.R);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_const1_Sub_col2(Code, @Dest.R, @Col2.R, @Col1.R);
          end else
            Func_col1_Sub_col2(Code, @Dest.R, @Col1.R, @Col2.R);
        end;

        { Green Channel }
        if chRed in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Sub_const2(Code, @Dest.G, @Col1.G, @Col2.G);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_const1_Sub_col2(Code, @Dest.G, @Col2.G, @Col1.G);
          end else
            Func_col1_Sub_col2(Code, @Dest.G, @Col1.G, @Col2.G);
        end;

        { Blue Channel }
        if chRed in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Sub_const2(Code, @Dest.B, @Col1.B, @Col2.B);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_const1_Sub_col2(Code, @Dest.B, @Col2.B, @Col1.B);
          end else
            Func_col1_Sub_col2(Code, @Dest.B, @Col1.B, @Col2.B);
        end;

        { Alpha Channel }
        if chRed in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Sub_const2(Code, @Dest.A, @Col1.A, @Col2.A);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_const1_Sub_col2(Code, @Dest.A, @Col2.A, @Col1.A);
          end else
            Func_col1_Sub_col2(Code, @Dest.A, @Col1.A, @Col2.A);
        end;
      end;
    end;

    procedure genBlend_ONE1_MUL_ONE2(var Code: Pointer; Dest, Col1, Col2: PDXRMachine_Color;
      ConstChannels1, ConstChannels12: TDXRColorChannels);
    begin
      if UseMMX then
      begin
        FMMXUsed := True;
        asm
          jmp @@EndCode
        @@StartCode:
          db $0F,$6F,$05,$11,$11,$11,$11/// movq mm0,qword ptr [$11111111]
                                 @@Col1:
          db $0F,$6F,$0D,$11,$11,$11,$11/// movq mm1,qword ptr [$11111111]
                                 @@Col2:
          db $0F,$71,$D0,$01       /// psrlw mm0,1
          db $0F,$71,$D1,$01       /// psrlw mm1,1
          db $0F,$E5,$C1           /// pmulhw mm0,mm1
          db $0F,$71,$F0,$02       /// psllw mm0,2
          db $0F,$7F,$05,$11,$11,$11,$11/// movq qword ptr [$11111111],mm0
                                 @@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end else
      begin
        if chRed in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov al,byte ptr [offset offset _null]{}@@Col1:
            mul byte ptr [offset offset _null]   {}@@Col2:
            mov byte ptr [offset offset _null],ah{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.R+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.R+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;

        if chGreen in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov al,byte ptr [offset offset _null]{}@@Col1:
            mul byte ptr [offset offset _null]   {}@@Col2:
            mov byte ptr [offset offset _null],ah{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.G+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.G+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.G+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;

        if chBlue in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov al,byte ptr [offset offset _null]{}@@Col1:
            mul byte ptr [offset offset _null]   {}@@Col2:
            mov byte ptr [offset offset _null],ah{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.B+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.B+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.B+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;

        if chAlpha in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov al,byte ptr [offset offset _null]{}@@Col1:
            mul byte ptr [offset offset _null]   {}@@Col2:
            mov byte ptr [offset offset _null],ah{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end;
    end;

    procedure genBlend_SRCALPHA1(var Code: Pointer; Dest, Col1: PDXRMachine_Color;
      ConstChannels1: TDXRColorChannels);
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        movzx ebx,byte ptr [offset _null]{}@@Col1:
      @@EndCode:
        {$I DXRender.inc}
        {  @@Col1  }
        mov eax,Col1; add eax,Byte(TDXRMachine_Color.A+1)
        mov edx,offset @@Col1-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;

      if [chRed, chGreen]<=EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          mov eax,dword ptr [offset _null]{}@@Col1:
          shr eax,8
          and eax,$00FF00FF
          imul eax,ebx
          mov dword ptr [offset _null],eax{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end else
      begin
        if chRed in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            movzx eax,byte ptr [offset _null]{}@@Col1:
            imul eax,ebx
            mov byte ptr [offset _null],ah{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.R+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;

        if chGreen in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            movzx eax,byte ptr [offset _null]{}@@Col1:
            imul eax,ebx
            mov byte ptr [offset _null],ah{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.G+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.G+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end;

      if [chBlue, chAlpha]<=EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          mov eax,dword ptr [offset _null]{}@@Col1:
          shr eax,8
          and eax,$00FF00FF
          imul eax,ebx
          mov dword ptr [offset _null],eax{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,4
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,4
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end else
      begin
        if chBlue in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            movzx eax,byte ptr [offset _null]{}@@Col1:
            imul eax,ebx
            mov byte ptr [offset _null],ah{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.B+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.B+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;

        if chAlpha in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            movzx eax,byte ptr [offset _null]{}@@Col1:
            imul eax,ebx
            mov byte ptr [offset _null],ah{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end;
    end;

    procedure genBlend_SRCALPHA1_ADD_ONE2(var Code: Pointer; Dest, Col1, Col2: PDXRMachine_Color;
      ConstChannels1, ConstChannels12: TDXRColorChannels);
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        movzx ebx,byte ptr [offset _null]{}@@Col1:
      @@EndCode:
        {$I DXRender.inc}
        {  @@Col1  }
        mov eax,Col1; add eax,Byte(TDXRMachine_Color.A+1)
        mov edx,offset @@Col1-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;

      if chRed in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx eax,byte ptr [offset _null]{}@@Col1:
          movzx edx,byte ptr [offset _null]{}@@Col2:
          imul eax,ebx
          shr eax,8
          mov al,byte ptr [offset (_AddTable + eax + edx)]
          mov byte ptr [offset _null],al{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;

      if chGreen in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx eax,byte ptr [offset _null]{}@@Col1:
          movzx edx,byte ptr [offset _null]{}@@Col2:
          imul eax,ebx
          shr eax,8
          mov al,byte ptr [offset (_AddTable + eax + edx)]
          mov byte ptr [offset _null],al{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;

      if chBlue in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx eax,byte ptr [offset _null]{}@@Col1:
          movzx edx,byte ptr [offset _null]{}@@Col2:
          imul eax,ebx
          shr eax,8
          mov al,byte ptr [offset (_AddTable + eax + edx)]
          mov byte ptr [offset _null],al{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;

      if chAlpha in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx eax,byte ptr [offset _null]{}@@Col1:
          movzx edx,byte ptr [offset _null]{}@@Col2:
          imul eax,ebx
          shr eax,8
          mov al,byte ptr [offset (_AddTable + eax + edx)]
          mov byte ptr [offset _null],al{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;
    end;

    procedure genBlend_ONE2_SUB_SRCALPHA1(var Code: Pointer; Dest, Col1, Col2: PDXRMachine_Color;
      ConstChannels1, ConstChannels12: TDXRColorChannels);
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        movzx ebx,byte ptr [offset _null]{}@@Col1:
      @@EndCode:
        {$I DXRender.inc}
        {  @@Col1  }
        mov eax,Col1; add eax,Byte(TDXRMachine_Color.A+1)
        mov edx,offset @@Col1-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;

      if chRed in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx eax,byte ptr [offset _null]{}@@Col1:
          movzx edx,byte ptr [offset _null]{}@@Col2:
          imul eax,ebx
          shr eax,8
          sub edx,eax
          mov al,byte ptr [offset (_SubTable + 255 + edx)]
          mov byte ptr [offset _null],al{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;

      if chGreen in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx eax,byte ptr [offset _null]{}@@Col1:
          movzx edx,byte ptr [offset _null]{}@@Col2:
          imul eax,ebx
          shr eax,8
          sub edx,eax
          mov al,byte ptr [offset (_SubTable + 255 + edx)]
          mov byte ptr [offset _null],al{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;

      if chBlue in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx eax,byte ptr [offset _null]{}@@Col1:
          movzx edx,byte ptr [offset _null]{}@@Col2:
          imul eax,ebx
          shr eax,8
          sub edx,eax
          mov al,byte ptr [offset (_SubTable + 255 + edx)]
          mov byte ptr [offset _null],al{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;

      if chAlpha in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          movzx eax,byte ptr [offset _null]{}@@Col1:
          movzx edx,byte ptr [offset _null]{}@@Col2:
          imul eax,ebx
          shr eax,8
          sub edx,eax
          mov al,byte ptr [offset (_SubTable + 255 + edx)]
          mov byte ptr [offset _null],al{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;
    end;

    procedure genBlend_SRCALPHA1_ADD_INVSRCALPHA2(var Code: Pointer; Dest, Col1, Col2: PDXRMachine_Color;
      ConstChannels1, ConstChannels12: TDXRColorChannels);
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        movzx ebx,byte ptr [offset _null]{}@@Col1:
        mov ebp,ebx
        xor ebp,$FF
      @@EndCode:
        {$I DXRender.inc}
        {  @@Col1  }
        mov eax,Col1; add eax,Byte(TDXRMachine_Color.A+1)
        mov edx,offset @@Col1-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;
                        
      if [chRed, chGreen]<=EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:    
          mov eax,dword ptr [offset _null]{}@@Col1:
          mov edx,dword ptr [offset _null]{}@@Col2:
          shr eax,8
          shr edx,8
          and eax,$00FF00FF
          and edx,$00FF00FF
          imul eax,ebx
          imul edx,ebp
          add eax,edx
          mov dword ptr [offset _null],eax{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end else
      begin
        if chRed in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            movzx eax,byte ptr [offset _null]{}@@Col1:
            movzx edx,byte ptr [offset _null]{}@@Col2:
            sub eax,edx
            imul eax,ebx
            shr eax,8
            add eax,edx
            mov byte ptr [offset _null],al{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.R+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.R+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;

        if chGreen in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            movzx eax,byte ptr [offset _null]{}@@Col1:
            movzx edx,byte ptr [offset _null]{}@@Col2:
            sub eax,edx
            imul eax,ebx
            shr eax,8
            add eax,edx
            mov byte ptr [offset _null],al{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.G+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.G+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.G+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end;

      if [chBlue, chAlpha]<=EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          mov eax,dword ptr [offset _null]{}@@Col1:
          mov edx,dword ptr [offset _null]{}@@Col2:
          shr eax,8
          shr edx,8
          and eax,$00FF00FF
          and edx,$00FF00FF
          imul eax,ebx
          imul edx,ebp
          add eax,edx
          mov dword ptr [offset _null],eax{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,4
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2; add eax,4
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,4
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end else
      begin
        if chBlue in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            movzx eax,byte ptr [offset _null]{}@@Col1:
            movzx edx,byte ptr [offset _null]{}@@Col2:
            sub eax,edx
            imul eax,ebx
            shr eax,8
            add eax,edx
            mov byte ptr [offset _null],al{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.B+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.B+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.B+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;

        if chAlpha in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            movzx eax,byte ptr [offset _null]{}@@Col1:
            movzx edx,byte ptr [offset _null]{}@@Col2:
            sub eax,edx
            imul eax,ebx
            shr eax,8
            add eax,edx
            mov byte ptr [offset _null],al{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end;
    end;

    procedure genBlend_INVSRCALPHA1_ADD_SRCALPHA2(var Code: Pointer; Dest, Col1, Col2: PDXRMachine_Color;
      ConstChannels1, ConstChannels12: TDXRColorChannels);
    begin
      asm
        jmp @@EndCode
      @@StartCode:
        movzx ebp,byte ptr [offset _null]{}@@Col1A:
        mov ebx,ebp
        xor ebx,$FF
      @@EndCode:
        {$I DXRender.inc}
        {  @@Col1A  }
        mov eax,Col1; add eax,Byte(TDXRMachine_Color.A+1)
        mov edx,offset @@Col1A-4
        sub edx,offset @@StartCode
        mov dword ptr [ecx+edx],eax
      end;

      if [chRed, chGreen]<=EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          mov eax,dword ptr [offset _null]{}@@Col1:
          mov edx,dword ptr [offset _null]{}@@Col2:
          shr eax,8
          shr edx,8
          and eax,$00FF00FF
          and edx,$00FF00FF
          imul eax,ebx
          imul edx,ebp
          add eax,edx
          mov dword ptr [offset _null],eax{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end else
      begin
        if chRed in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            movzx eax,byte ptr [offset _null]{}@@Col1:
            movzx edx,byte ptr [offset _null]{}@@Col2:
            sub eax,edx
            imul eax,ebx
            shr eax,8
            add eax,edx
            mov byte ptr [offset _null],al{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.R+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.R+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;

        if chGreen in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            movzx eax,byte ptr [offset _null]{}@@Col1:
            movzx edx,byte ptr [offset _null]{}@@Col2:
            sub eax,edx
            imul eax,ebx
            shr eax,8
            add eax,edx
            mov byte ptr [offset _null],al{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.G+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.G+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.G+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end;

      if [chBlue, chAlpha]<=EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          mov eax,dword ptr [offset _null]{}@@Col1:
          mov edx,dword ptr [offset _null]{}@@Col2:
          shr eax,8
          shr edx,8
          and eax,$00FF00FF
          and edx,$00FF00FF
          imul eax,ebx
          imul edx,ebp
          add eax,edx
          mov dword ptr [offset _null],eax{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,4
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2; add eax,4
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,4
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end else
      begin
        if chBlue in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            movzx eax,byte ptr [offset _null]{}@@Col1:
            movzx edx,byte ptr [offset _null]{}@@Col2:
            sub eax,edx
            imul eax,ebx
            shr eax,8
            add eax,edx
            mov byte ptr [offset _null],al{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.B+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.B+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.B+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;

        if chAlpha in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            movzx eax,byte ptr [offset _null]{}@@Col1:
            movzx edx,byte ptr [offset _null]{}@@Col2:
            sub eax,edx
            imul eax,ebx
            shr eax,8
            add eax,edx
            mov byte ptr [offset _null],al{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end;
    end;

    procedure genBlend_DECALALPHA(var Code: Pointer; Dest, Col1, Col2: PDXRMachine_Color;
      ConstChannels1, ConstChannels12: TDXRColorChannels);
    begin
      if ([chRed, chGreen, chBlue]<=EnableChannels) and (Dest<>Col1) then
      begin
        if UseMMX then
        begin
          FMMXUsed := True;
          asm
            jmp @@EndCode
          @@StartCode:
            db $0F,$6F,$05,$11,$11,$11,$11///movq mm0,qword ptr [$11111111]
                                   @@Col1:
            db $0F,$7F,$05,$11,$11,$11,$11///movq qword ptr [$11111111],mm0
                                   @@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end else
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov eax,dword ptr [offset _null]{}@@Col1:
            mov edx,dword ptr [offset _null]{}@@Col1_2:
            mov dword ptr [offset _null],eax{}@@Dest:
            mov dword ptr [offset _null],edx{}@@Dest2:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col1_2  }
            mov eax,Col1; add eax,4
            mov edx,offset @@Col1_2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest2  }
            mov eax,Dest; add eax,4
            mov edx,offset @@Dest2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end;

      if chAlpha in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          mov al,byte ptr [offset _null]{}@@Col2:
          mov byte ptr [offset _null],al{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col2  }
          mov eax,Col2; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;
    end;

    procedure genBlend_MODULATE(var Code: Pointer; Dest, Col1, Col2: PDXRMachine_Color;
      ConstChannels1, ConstChannels12: TDXRColorChannels);
    begin
      if chRed in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          mov al,byte ptr [offset offset _null]{}@@Col1:
          mul byte ptr [offset offset _null]   {}@@Col2:
          mov byte ptr [offset offset _null],ah{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;

      if chGreen in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          mov al,byte ptr [offset offset _null]{}@@Col1:
          mul byte ptr [offset offset _null]   {}@@Col2:
          mov byte ptr [offset offset _null],ah{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.G+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;

      if chBlue in EnableChannels then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          mov al,byte ptr [offset offset _null]{}@@Col1:
          mul byte ptr [offset offset _null]   {}@@Col2:
          mov byte ptr [offset offset _null],ah{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.B+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;

      if (chAlpha in EnableChannels) or (Dest<>Col1) then
      begin
        asm
          jmp @@EndCode
        @@StartCode:
          mov al,byte ptr [offset _null]{}@@Col1:
          mov byte ptr [offset _null],al{}@@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end;
    end;

    procedure genBlend_MODULATEALPHA(var Code: Pointer; Dest, Col1, Col2: PDXRMachine_Color;
      ConstChannels1, ConstChannels12: TDXRColorChannels);
    begin
      if UseMMX then
      begin
        FMMXUsed := True;
        asm
          jmp @@EndCode
        @@StartCode:
          db $0F,$6F,$05,$11,$11,$11,$11///movq mm0,qword ptr [$11111111]
                                 @@Col1:
          db $0F,$6F,$0D,$11,$11,$11,$11///movq mm1,qword ptr [$11111111]
                                 @@Col2:
          db $0F,$E5,$C1      ///pmulhw mm0,mm1
          db $0F,$7F,$05,$11,$11,$11,$11///movq qword ptr [$11111111],mm0
                                 @@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,offset Dest
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;
      end else
      begin
        if chRed in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov al,byte ptr [offset offset _null]{}@@Col1:
            mul byte ptr [offset offset _null]   {}@@Col2:
            mov byte ptr [offset offset _null],ah{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.R+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.R+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.R+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;

        if chGreen in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov al,byte ptr [offset offset _null]{}@@Col1:
            mul byte ptr [offset offset _null]   {}@@Col2:
            mov byte ptr [offset offset _null],ah{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.G+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.G+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.G+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;

        if chBlue in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov al,byte ptr [offset offset _null]{}@@Col1:
            mul byte ptr [offset offset _null]   {}@@Col2:
            mov byte ptr [offset offset _null],ah{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.B+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.B+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.B+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;

        if chAlpha in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov al,byte ptr [offset offset _null]{}@@Col1:
            mul byte ptr [offset offset _null]   {}@@Col2:
            mov byte ptr [offset offset _null],ah{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col1  }
            mov eax,Col1; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Col1-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end;
    end;

    procedure genBlend_ADD(var Code: Pointer; Dest, Col1, Col2: PDXRMachine_Color;
      ConstChannels1, ConstChannels12: TDXRColorChannels);
    begin
      if UseMMX then
      begin
        FMMXUsed := True;
        asm
          jmp @@EndCode
        @@StartCode:
          db $0F,$6F,$05,$11,$11,$11,$11///movq mm0,qword ptr [$11111111]
                                 @@Col1:
          db $0F,$6F,$0D,$11,$11,$11,$11///movq mm1,qword ptr [$11111111]
                                 @@Col2:
          db $0F,$DD,$C1      ///paddusw mm0,mm1
          db $0F,$7F,$05,$11,$11,$11,$11///movq qword ptr [$11111111],mm0
                                 @@Dest:
        @@EndCode:
          {$I DXRender.inc}
          {  @@Col1  }
          mov eax,Col1
          mov edx,offset @@Col1-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Col2  }
          mov eax,Col2
          mov edx,offset @@Col2-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax

          {  @@Dest  }
          mov eax,Dest
          mov edx,offset @@Dest-4
          sub edx,offset @@StartCode
          mov dword ptr [ecx+edx],eax
        end;

        {  Alpha Channel  }
        if chAlpha in EnableChannels then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov al,byte ptr [offset _null]{}@@Col2:
            mov byte ptr [offset _null],al{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end else
      begin
        { Red Channel }
        if chRed in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Add_const2(Code, @Dest.R, @Col2.R, @Col1.R);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_col1_Add_const2(Code, @Dest.R, @Col1.R, @Col2.R);
          end else
            Func_col1_Add_col2(Code, @Dest.R, @Col1.R, @Col2.R);
        end;

        { Green Channel }
        if chGreen in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Add_const2(Code, @Dest.G, @Col2.G, @Col1.G);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_col1_Add_const2(Code, @Dest.G, @Col1.G, @Col2.G);
          end else
            Func_col1_Add_col2(Code, @Dest.G, @Col1.G, @Col2.G);
        end;

        { Blue Channel }
        if chBlue in EnableChannels then
        begin
          if chRed in ConstChannels1 then
          begin
            Func_col1_Add_const2(Code, @Dest.B, @Col2.B, @Col1.B);
          end else
          if chRed in ConstChannels2 then
          begin
            Func_col1_Add_const2(Code, @Dest.B, @Col1.B, @Col2.B);
          end else
            Func_col1_Add_col2(Code, @Dest.B, @Col1.B, @Col2.B);
        end;

        {  Alpha Channel  }
        if (chAlpha in EnableChannels) and (Col2<>Dest) then
        begin
          asm
            jmp @@EndCode
          @@StartCode:
            mov al,byte ptr [offset _null]{}@@Col2:
            mov byte ptr [offset _null],al{}@@Dest:
          @@EndCode:
            {$I DXRender.inc}
            {  @@Col2  }
            mov eax,Col2; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Col2-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax

            {  @@Dest  }
            mov eax,Dest; add eax,Byte(TDXRMachine_Color.A+1)
            mov edx,offset @@Dest-4
            sub edx,offset @@StartCode
            mov dword ptr [ecx+edx],eax
          end;
        end;
      end;
    end;

  begin
    if EnableChannels=[] then Exit;
                              
    case Blend of
      DXR_BLEND_ZERO                      : genBlend_ZERO(Code, Dest);
      DXR_BLEND_ONE1                      : genBlend_ONE1(Code, Dest, Col1, ConstChannels1);
      DXR_BLEND_ONE2                      : genBlend_ONE1(Code, Dest, Col2, ConstChannels2);
      DXR_BLEND_ONE1_ADD_ONE2             : genBlend_ONE1_ADD_ONE2(Code, Dest, Col1, Col2, ConstChannels1, ConstChannels2);
      DXR_BLEND_ONE1_SUB_ONE2             : genBlend_ONE1_SUB_ONE2(Code, Dest, Col1, Col2, ConstChannels1, ConstChannels2);
      DXR_BLEND_ONE2_SUB_ONE1             : genBlend_ONE2_SUB_ONE1(Code, Dest, Col1, Col2, ConstChannels1, ConstChannels2);
      DXR_BLEND_ONE1_MUL_ONE2             : genBlend_ONE1_MUL_ONE2(Code, Dest, Col1, Col2, ConstChannels1, ConstChannels2);
      DXR_BLEND_SRCALPHA1                 : genBlend_SRCALPHA1(Code, Dest, Col1, ConstChannels1);
      DXR_BLEND_SRCALPHA1_ADD_ONE2        : genBlend_SRCALPHA1_ADD_ONE2(Code, Dest, Col1, Col2, ConstChannels1, ConstChannels2);
      DXR_BLEND_ONE2_SUB_SRCALPHA1        : genBlend_ONE2_SUB_SRCALPHA1(Code, Dest, Col1, Col2, ConstChannels1, ConstChannels2);
      DXR_BLEND_SRCALPHA1_ADD_INVSRCALPHA2: genBlend_SRCALPHA1_ADD_INVSRCALPHA2(Code, Dest, Col1, Col2, ConstChannels1, ConstChannels2);
      DXR_BLEND_INVSRCALPHA1_ADD_SRCALPHA2: genBlend_INVSRCALPHA1_ADD_SRCALPHA2(Code, Dest, Col1, Col2, ConstChannels1, ConstChannels2);
      DXR_BLEND_DECAL                     : genBlend_ONE1(Code, Dest, Col1, ConstChannels1);
      DXR_BLEND_DECALALPHA                : genBlend_DECALALPHA(Code, Dest, Col1, Col2, ConstChannels1, ConstChannels2);
      DXR_BLEND_MODULATE                  : genBlend_MODULATE(Code, Dest, Col1, Col2, ConstChannels1, ConstChannels2);
      DXR_BLEND_MODULATEALPHA             : genBlend_MODULATEALPHA(Code, Dest, Col1, Col2, ConstChannels1, ConstChannels2);
      DXR_BLEND_ADD                       : genBlend_ADD(Code, Dest, Col1, Col2, ConstChannels1, ConstChannels2);
    end;                                                                                                       
  end;

var
  StackPoint: Integer;

  function NewWorkColor: PDXRMachine_Color;
  begin
    Result := @FStack[StackPoint]; Inc(StackPoint);
  end;

  function GenerateCode2(var Code: Pointer; Tree: PDXRMachine_Tree): PDXRMachine_Color;
  var
    Col1, Col2: PDXRMachine_Color;
    ConstChannels1, ConstChannels2: TDXRColorChannels;
    ch: TDXRColorChannels;
  begin
    Result := NewWorkColor;
    case Tree.Typ of
      DXR_TREETYPE_LOADBLACK:
          begin
            genBlend(Code, DXR_BLEND_ZERO, Result, nil, nil, Tree.Channels, [], []);
          end;
      DXR_TREETYPE_LOADCOLOR:
          begin
            genBlend(Code, DXR_BLEND_ONE1, Result, @ColorList[Tree.Color].nColor, nil, Tree.Channels, [], []);
          end;
      DXR_TREETYPE_LOADCONSTCOLOR:
          begin
            genBlend(Code, DXR_BLEND_ONE1, Result, @Tree.ConstColor, nil, Tree.Channels,
              [chRed, chGreen, chBlue, chAlpha], []);
          end;
      DXR_TREETYPE_LOADTEXTURE:
          begin
            genReadTexture(Code, Result, TextureList[Tree.Texture], Tree.Channels);
          end;
      DXR_TREETYPE_LOADBUMPTEXTURE:
          begin
            genReadBumpTexture(Code, Result, TextureList[Tree.Texture], TextureList[Tree.BumpTexture], Tree.Channels);
          end;
      DXR_TREETYPE_LOADDESTPIXEL:
          begin
            genReadDestPixel(Code);
            genDecodeColor(Code, Dest^, Result, Tree.Channels, _BlackColor);
          end;
      DXR_TREETYPE_BLEND:
          begin
            // Blend color
            Col1 := nil;
            Col2 := nil;

            ConstChannels1 := [];
            ConstChannels2 := [];

            if (Tree.BlendTree1<>nil) and (Tree.BlendTree1.Typ=DXR_TREETYPE_LOADBLACK) then
            begin
              Col1 := @_BlackColor;
            end else
            if (Tree.BlendTree1<>nil) and (Tree.BlendTree1.Typ=DXR_TREETYPE_LOADCOLOR) then
            begin
              Col1 := @ColorList[Tree.BlendTree1.Color].nColor;
            end else
            if (Tree.BlendTree1<>nil) and (Tree.BlendTree1.Typ=DXR_TREETYPE_LOADCONSTCOLOR) then
            begin
              Col1 := @Tree.BlendTree1.ConstColor;
              ConstChannels1 := [chRed, chGreen, chBlue, chAlpha];
            end else
            if (Tree.BlendTree1<>nil) and (Tree.BlendTree1.Typ=DXR_TREETYPE_LOADTEXTURE) then
            begin
              ch := TextureList[Tree.BlendTree1.Texture].EnableChannels;

              if (chRed in Tree.BlendTree1.Channels) and (not (chRed in ch)) then
              begin
                ConstChannels1 := ConstChannels1 + [chRed];
                Tree.BlendTree1.Channels := Tree.BlendTree1.Channels - [chRed];
              end;

              if (chGreen in Tree.BlendTree1.Channels) and (not (chGreen in ch)) then
              begin
                ConstChannels1 := ConstChannels1 + [chGreen];
                Tree.BlendTree1.Channels := Tree.BlendTree1.Channels - [chGreen];
              end;

              if (chBlue in Tree.BlendTree1.Channels) and (not (chBlue in ch)) then
              begin
                ConstChannels1 := ConstChannels1 + [chBlue];
                Tree.BlendTree1.Channels := Tree.BlendTree1.Channels - [chBlue];
              end;

              if (chAlpha in Tree.BlendTree1.Channels) and (not (chAlpha in ch)) then
              begin
                ConstChannels1 := ConstChannels1 + [chAlpha];
                Tree.BlendTree1.Channels := Tree.BlendTree1.Channels - [chAlpha];
              end;

              Col1 := GenerateCode2(Code, Tree.BlendTree1);

              if chRed in ConstChannels1 then
                Col1.R := TextureList[Tree.BlendTree1.Texture].DefaultColor.R;

              if chGreen in ConstChannels1 then
                Col1.G := TextureList[Tree.BlendTree1.Texture].DefaultColor.G;

              if chBlue in ConstChannels1 then
                Col1.B := TextureList[Tree.BlendTree1.Texture].DefaultColor.B;
                
              if chAlpha in ConstChannels1 then
                Col1.A := TextureList[Tree.BlendTree1.Texture].DefaultColor.A;
            end else
            if Tree.BlendTree1<>nil then
            begin
              Col1 := GenerateCode2(Code, Tree.BlendTree1);
            end;

            if (Tree.BlendTree2<>nil) and (Tree.BlendTree2.Typ=DXR_TREETYPE_LOADBLACK) then
            begin
              Col2 := @_BlackColor;
            end else
            if (Tree.BlendTree2<>nil) and (Tree.BlendTree2.Typ=DXR_TREETYPE_LOADCOLOR) then
            begin
              Col2 := @ColorList[Tree.BlendTree2.Color].nColor;
            end else
            if (Tree.BlendTree2<>nil) and (Tree.BlendTree2.Typ=DXR_TREETYPE_LOADCONSTCOLOR) then
            begin
              Col2 := @Tree.BlendTree2.ConstColor;
              ConstChannels2 := [chRed, chGreen, chBlue, chAlpha];
            end else
            if (Tree.BlendTree2<>nil) and (Tree.BlendTree2.Typ=DXR_TREETYPE_LOADTEXTURE) then
            begin
              ch := TextureList[Tree.BlendTree2.Texture].EnableChannels;
              
              if (chRed in Tree.BlendTree2.Channels) and (not (chRed in ch)) then
              begin
                ConstChannels2 := ConstChannels2 + [chRed];
                Tree.BlendTree2.Channels := Tree.BlendTree2.Channels - [chRed];
              end;

              if (chGreen in Tree.BlendTree2.Channels) and (not (chGreen in ch)) then
              begin
                ConstChannels2 := ConstChannels2 + [chGreen];
                Tree.BlendTree2.Channels := Tree.BlendTree2.Channels - [chGreen];
              end;

              if (chBlue in Tree.BlendTree2.Channels) and (not (chBlue in ch)) then
              begin
                ConstChannels2 := ConstChannels2 + [chBlue];
                Tree.BlendTree2.Channels := Tree.BlendTree2.Channels - [chBlue];
              end;

              if (chAlpha in Tree.BlendTree2.Channels) and (not (chAlpha in ch)) then
              begin
                ConstChannels2 := ConstChannels2 + [chAlpha];
                Tree.BlendTree2.Channels := Tree.BlendTree2.Channels - [chAlpha];
              end;

              Col2 := GenerateCode2(Code, Tree.BlendTree2);

              if chRed in ConstChannels2 then
                Col2.R := TextureList[Tree.BlendTree2.Texture].DefaultColor.R;

              if chGreen in ConstChannels2 then
                Col2.G := TextureList[Tree.BlendTree2.Texture].DefaultColor.G;

              if chBlue in ConstChannels2 then
                Col2.B := TextureList[Tree.BlendTree2.Texture].DefaultColor.B;

              if chAlpha in ConstChannels2 then
                Col2.A := TextureList[Tree.BlendTree2.Texture].DefaultColor.A;
            end else
            if Tree.BlendTree2<>nil then
            begin
              Col2 := GenerateCode2(Code, Tree.BlendTree2);
            end;

            genBlend(Code, Tree.Blend, Result, Col1, Col2, Tree.Channels,
              ConstChannels1, ConstChannels2);
          end;
    end;
  end;

var
  ExitAddress, MainCode: Pointer;
  Col: PDXRMachine_Color;
begin
  if (Tree.Typ=DXR_TREETYPE_LOADCOLOR) and (not ColorList[Tree.Color].Gouraud) and
    (not ZBuffer.Enable) and (not Dither.Enable) and (Dest.BitCount in [16, 32]) then
  begin
    FCall := Code;
    genInitDestAddress(Code);
    genEncodeColor(Code, Dest^, @ColorList[Tree.Color].nColor, Tree.Channels);

    case Dest.BitCount of
      16: begin
            asm
              jmp @@EndCode
            @@StartCode:
              mov edx,eax
              rol eax,16
              mov ax,dx

              {  DWORD arrangement  }
              mov edx,edi
              and edx,3
              shr edx,1
              jz @@dwordarray_skip

            @@dwordarray_loop:
              mov word ptr [edi],ax
              add edi,2
              dec ecx
              jz @@Exit
              dec edx
              jmp @@dwordarray_loop
            @@dwordarray_skip:

              {  DWORD  }
              mov edx,ecx
              shr edx,1
              jz @@dword_skip
            @@dword_loop:
              mov dword ptr [edi],eax
              add edi,4
              dec edx
              jnz @@dword_loop

              and ecx,1
              jz @@Exit
            @@dword_skip:

              {  WORD  }
              mov word ptr [edi],ax
            @@Exit:
              ret
            @@EndCode:
              {$I DXRender.inc}
            end;
          end;
      32: begin
            asm
              jmp @@EndCode
            @@StartCode:
              {  DWORD  }
              dec ecx
            @@loop:
              mov dword ptr [edi+ecx*4],eax
              dec ecx
              jnl @@loop
              ret
            @@EndCode:
              {$I DXRender.inc}
            end;
          end;
    end;

    Exit;
  end;

  {  -----------  Exit  -----------  }
  ExitAddress := Code;

  asm
    jmp @@EndCode
  @@StartCode:
    ret
  @@EndCode:
    {$I DXRender.inc}
  end;

  {  -----------  Loop  -----------  }
  SkipAddress := Code;

  genUpdateAxis(Code);
  genUpdateColor(Code);
  genUpdateTextureAxis(Code);
  genUpdateRHW(Code);
  genUpdateDestAddress(Code);
  genUpdateZBufferAddress(Code);

  asm
    jmp @@EndCode
  @@StartCode:
    dec ecx
  @@EndCode:
    {$I DXRender.inc}
  end;
  genCmpFunc(Code, DXR_CMPFUNC_LESSEQUAL, ExitAddress);

  {  -----------  Main  -----------  }
  MainCode := Code;

  genZBufferTest(Code);

  if Tree.Typ=DXR_TREETYPE_LOADCOLOR then
  begin
    genEncodeColor2(Code, Dest^, @ColorList[Tree.Color].nColor, Tree.Channels);
    genWriteDestPixel(Code);
  end else
  if (Tree.Typ=DXR_TREETYPE_LOADTEXTURE) and (not Dither.Enable) and
    (TextureList[Tree.Texture].Filter in [DXR_TEXTUREFILTER_NEAREST, DXR_TEXTUREFILTER_MIPMAP_NEAREST]) and
    (dxrCompareSurface(Dest^, TextureList[Tree.Texture].Surface^)) then
  begin
    genReadSurfacePixel(Code, TextureList[Tree.Texture], @TextureList[Tree.Texture].nAxis);
    genColorKey(Code, TextureList[Tree.Texture]);
    genWriteDestPixel(Code);
  end else
  begin
    StackPoint := 0; Col := GenerateCode2(Code, Tree);
    genEncodeColor2(Code, Dest^, Col, Tree.Channels);
    genWriteDestPixel(Code);
  end;

  genCmpFunc(Code, DXR_CMPFUNC_ALWAYS, SkipAddress);

  {  -----------  Initialize  -----------  }
  FCall := Code;

  genInitDestAddress(Code);
  genInitZBuffer(Code);

  genCmpFunc(Code, DXR_CMPFUNC_ALWAYS, MainCode);
end;

procedure TDXRMachine.Run(Count: Integer);
var
  P: Pointer;
begin
  if Count<=0 then Exit;
  if FCall=nil then Exit;

  P := FCall;

  asm
    push edi
    push esi
    push ebx
    push ebp
    push eax
    push edx
    mov ecx,Count
    mov eax,P
    call eax
    pop edx
    pop eax
    pop ebp
    pop ebx
    pop esi
    pop edi
  end;

  if FMMXUsed then
  begin
    asm
      db $0F,$77                    ///emms
    end;
  end;
end;

var
  FDXRMachine: TDXRMachine;

function DXRMachine: TDXRMachine;
begin
  if FDXRMachine=nil then
    FDXRMachine := TDXRMachine.Create;
  Result := FDXRMachine;
end;

procedure dxrDefRenderStates(var States: TDXR_RenderStates);
var
  i: Integer;
begin
  FillChar(States, SizeOf(States), 0);

  with States do
  begin
    DitherEnable := False;
    SpecularEnable := True;
    CullMode := DXR_CULL_CCW;
    Shade := DXR_SHADEMODE_GOURAUD;
    TexBlend := DXR_BLEND_MODULATE;
    Blend := DXR_BLEND_ONE1;
    TextureFilter := DXR_TEXTUREFILTER_NEAREST;
    ZBuffer := nil;
    ZFunc := DXR_CMPFUNC_LESSEQUAL;
    ZWriteEnable := True;
    EnableDrawLine := 0;
  end;

  for i:=0 to DXR_MAXTEXTURE-1 do
    with States.TextureList[i] do
    begin
      LayerBlend := DXR_TEXTURELAYERBLEND_TEXTURE;
      Blend := DXR_BLEND_ONE1;
      Surface := nil;
      ColorKeyEnable := False;
      ColorKey := 0;
      TextureAddress := DXR_TEXTUREADDRESS_TILE;
      BumpTexture := -1;
    end;
end;

{  Draw primitive  }

type
  PArrayDXR_Vertex = ^TArrayDXR_Vertex;
  TArrayDXR_Vertex = array[0..0] of TDXR_Vertex;

  PArrayPDXR_Vertex = ^TArrayPDXR_Vertex;
  TArrayPDXR_Vertex = array[0..0] of PDXR_Vertex;

  TDXR_Triangle = array[0..2] of PDXR_Vertex;

  PArrayDWORD = ^TArrayDWORD;
  TArrayDWORD = array[0..2] of DWORD;

procedure dxrDrawTriangle(const Dest: TDXR_Surface; const States: TDXR_RenderStates; const Tri: TDXR_Triangle);

  function InitGenerator_MakeTree_LoadTexture(Texture: Integer): PDXRMachine_Tree;
  begin
    if States.TextureList[Texture].BumpTexture>=0 then
      Result := DXRMachine.CreateTree_LoadBumpTexture(Texture, States.TextureList[Texture].BumpTexture)
    else
      Result := DXRMachine.CreateTree_LoadTexture(Texture);
  end;

  function InitGenerator_MakeTree: PDXRMachine_Tree;
  var
    i: Integer;
    Layer: PDXR_TextureLayer;
  begin
    if States.TextureEnable then
    begin
      {  Load texel  }
      Result := DXRMachine.CreateTree2(DXR_TREETYPE_LOADBLACK);

      if States.TextureEnable then
        for i:=Low(States.TextureList) to High(States.TextureList) do
        begin
          Layer := @States.TextureList[i];
          if (Layer.Surface<>nil) and (Layer.LayerBlend=DXR_TEXTURELAYERBLEND_TEXTURE) then
          begin
            Result := DXRMachine.CreateTree_Blend(Layer.Blend, InitGenerator_MakeTree_LoadTexture(i), Result);
          end;
        end;

      {  Lighting  }
      Result := DXRMachine.CreateTree_Blend(States.TexBlend, Result, DXRMachine.CreateTree_LoadColor(0));

      {  Blend after lighting is given  }
      for i:=Low(States.TextureList) to High(States.TextureList) do
      begin
        Layer := @States.TextureList[i];
        if (Layer.Surface<>nil) and (Layer.LayerBlend=DXR_TEXTURELAYERBLEND_LAST) then
        begin
          Result := DXRMachine.CreateTree_Blend(Layer.Blend, InitGenerator_MakeTree_LoadTexture(i), Result);
        end;
      end;
    end else
    begin
      Result := DXRMachine.CreateTree_LoadColor(0);
    end;

    {  Blend with Dest pixel   }
    Result := DXRMachine.CreateTree_Blend(States.Blend, Result, DXRMachine.CreateTree2(DXR_TREETYPE_LOADDESTPIXEL));

    {  Specular generation  }
    if States.SpecularEnable then
    begin
      Result := DXRMachine.CreateTree_Blend(DXR_BLEND_ONE1_ADD_ONE2, Result, DXRMachine.CreateTree_LoadColor(1));
    end;
  end;

  procedure InitGenerator;

    function Hypot(X, Y: Extended): Extended;
    begin
      Result := Sqrt(X*X + Y*Y);
    end;

  var
    i: Integer;
    Layer: PDXR_TextureLayer;
    Mipmap1, Mipmap2, Mipmap3: Integer;
    TmpSurface2: PDXR_Surface;
  begin
    DXRMachine.Initialize;

    {  Parameter setting  }
    DXRMachine.Dest := @Dest;
    DXRMachine.ZBuffer.Enable := States.ZBuffer<>nil;
    DXRMachine.ZBuffer.Surface := States.ZBuffer;
    DXRMachine.ZBuffer.CmpFunc := States.ZFunc;
    DXRMachine.ZBuffer.WriteEnable := States.ZWriteEnable;
    DXRMachine.Dither.Enable := States.DitherEnable;

    DXRMachine.ColorList[0].Gouraud := States.Shade=DXR_SHADEMODE_GOURAUD;
    DXRMachine.ColorList[1].Gouraud := States.Shade=DXR_SHADEMODE_GOURAUD;

    if States.TextureEnable then
      for i:=Low(States.TextureList) to High(States.TextureList) do
      begin
        Layer := @States.TextureList[i];

        if States.TextureList[i].Surface<>nil then
        begin
          with DXRMachine.TextureList[i] do
          begin
            ColorKeyEnable := Layer.ColorKeyEnable;
            ColorKey := Layer.ColorKey;
            Surface := Layer.Surface;
            Filter := States.TextureFilter;
            TextureAddress := Layer.TextureAddress;

            if (Filter in [DXR_TEXTUREFILTER_MIPMAP_NEAREST, DXR_TEXTUREFILTER_MIPMAP_LINEAR]) and
              (Surface.MipmapChain<>nil) then
            begin
              {  Mipmap  }
              Mipmap1 := MaxInt;
              Mipmap3 := Trunc(Abs(Hypot(Tri[2].sx-Tri[1].sx, Tri[2].sy-Tri[1].sy))*
                Abs(Hypot(Tri[1].sx-Tri[0].sx, Tri[1].sy-Tri[0].sy))*
                Abs(Hypot(Tri[2].sx-Tri[0].sx, Tri[2].sy-Tri[0].sy))/9);

              TmpSurface2 := Surface;

              while TmpSurface2<>nil do
              begin
                Mipmap2 := TmpSurface2.Width2*TmpSurface2.Height2;

                if (Abs(Mipmap3-Mipmap2)<Abs(Mipmap3-Mipmap1)) then
                begin
                  Surface := TmpSurface2;
                  Mipmap1 := Mipmap2;
                end;

                TmpSurface2 := TmpSurface2.MipmapChain;
              end;
            end;
          end;
        end;
      end;

    {  Tree making  }
    DXRMachine.Compile(InitGenerator_MakeTree);
  end;

type
  TCol64Array = array[0..1] of TDXRMachine_Color;
  T2DAxis64Array = array[0..DXR_MAXTEXTURE-1] of TDXRMachine_Axis;

const
  Int32Value = 65536.0*65536.0;

var
  TexXFloat, TexYFloat: array[0..DXR_MAXTEXTURE-1] of DWORD;

  function Comp2DWORD(c: Comp): DWORD;
  begin
    Result := PDWORD(@c)^;
  end;

  function FloatToIntFloat(d: Extended): Comp;
  begin
    Result := d*Int32Value;
  end;

  function FloatToColorFloat(d: Extended): Word;
  begin
    Result := Trunc(d*255);
  end;

  function FloatToTextureFloatX(i: Integer; d: Extended): DWORD;
  begin
    Result := Comp2DWORD(d*TexXFloat[i]);
  end;

  function FloatToTextureFloatY(i: Integer; d: Double): DWORD;
  begin
    Result := Comp2DWORD(d*TexYFloat[i]);
  end;

  function FloatToRHWFloat(d: Extended): Comp;
  begin
    Result := d*Int32Value;
  end;

  procedure drawline(x1, x2, y: Integer;
    const x_ntex1, x_ntex2: T2DAxis64Array;
    const x_nc1, x_nc2: TCol64Array;
    const x_nRHW1, x_nRHW2: Comp);
  var
    i, xcount, xcount2, ofs: Integer;
  begin
    xcount := x2-x1;
    xcount2 := xcount;

    {  Clipping  }
    ofs := 0;

    if x1<0 then
    begin
      i := -x1;
      Inc(ofs, i);
      Inc(x1, i);
      Dec(xcount2, i);
    end;

    if x1+xcount2>=Integer(Dest.Width) then
    begin
      i := (x1+xcount2)-Integer(Dest.Width);
      Dec(xcount2, i);
    end;

    if xcount2<=0 then Exit;

    DXRMachine.Axis.Axis.X := x1;
    DXRMachine.Axis.Axis.Y := y;

    for i:=0 to DXRMachine.TextureIndexCount-1 do
      with DXRMachine.TextureList[DXRMachine.TextureIndex[i]] do
      begin
        nAxis := x_ntex1[i];
        iAxis.X := Integer(x_ntex2[i].X-x_ntex1[i].X) div xcount;
        iAxis.Y := Integer(x_ntex2[i].Y-x_ntex1[i].Y) div xcount;

        if TextureAddress=DXR_TEXTUREADDRESS_DONOTCLIP then
        begin
          if (DWORD(nAxis.X) shr 16>DXRMachine.TextureList[DXRMachine.TextureIndex[i]].Surface.Width) or
            (DWORD(nAxis.Y) shr 16>DXRMachine.TextureList[DXRMachine.TextureIndex[i]].Surface.Height) then Exit;

          if ((DWORD(nAxis.X+iAxis.X*(xcount)-1)) shr 16>DXRMachine.TextureList[DXRMachine.TextureIndex[i]].Surface.Width) or
            ((DWORD(nAxis.Y+iAxis.Y*(xcount)-1)) shr 16>DXRMachine.TextureList[DXRMachine.TextureIndex[i]].Surface.Height) then Exit;
        end;

        if ofs<>0 then
        begin
          nAxis.X := nAxis.X + iAxis.X*ofs;
          nAxis.Y := nAxis.Y + iAxis.Y*ofs;
        end;
      end;

    for i:=0 to DXRMachine.ColorIndexCount-1 do
      with DXRMachine.ColorList[DXRMachine.ColorIndex[i]] do
      begin
        if Gouraud then
        begin
          nColor := x_nc1[i];

          iColor.R := Integer(x_nc2[i].R-x_nc1[i].R) div xcount;
          iColor.G := Integer(x_nc2[i].G-x_nc1[i].G) div xcount;
          iColor.B := Integer(x_nc2[i].B-x_nc1[i].B) div xcount;
          iColor.A := Integer(x_nc2[i].A-x_nc1[i].A) div xcount;

          if ofs<>0 then
          begin
            nColor.R := nColor.R + iColor.R*ofs;
            nColor.G := nColor.G + iColor.G*ofs;
            nColor.B := nColor.B + iColor.B*ofs;
            nColor.A := nColor.A + iColor.A*ofs;
          end;
        end;
      end;

    with DXRMachine.RHW do
    begin
      if Enable then
      begin
        nRHW := x_nRHW1;
        iRHW := (x_nRHW2-x_nRHW1) / xcount;
        if ofs<>0 then
          nRHW := nRHW + iRHW*ofs;
      end;
    end;

    DXRMachine.Run(xcount2);
  end;

  procedure draw(p1, pt1, p2, pt2: PDXR_Vertex; starty, ycount, y1, y2, ofs1, ofs2: Integer);
  var
    i, j, y: Integer;
    c1, c2, c2_1, c2_2: TDXR_Color;
    y_nx1, y_nx2, y_ix1, y_ix2: Comp;
    y_ntex1, y_ntex2, y_itex1, y_itex2: T2DAxis64Array;
    y_nc1, y_nc2, y_ic1, y_ic2: TCol64Array;
    y_nRHW1, y_nRHW2, y_iRHW1, y_iRHW2: Comp;
  begin
    if ycount<=0 then Exit;
    if y1=0 then Exit;
    if y2=0 then Exit;

    {  Clipping  }
    if starty<0 then
    begin
      i := -starty;

      Inc(ofs1, i);
      Inc(ofs2, i);

      Inc(starty, i);
      Dec(ycount, i);
    end;

    if starty+ycount>=Integer(Dest.Height) then
    begin
      i := (starty+ycount)-Integer(Dest.Height);
      Dec(ycount, i);
    end;

    if ycount<=0 then Exit;

    y_nx1 := FloatToIntFloat(Trunc(p1.sx));
    y_nx2 := FloatToIntFloat(Trunc(p2.sx));
    y_ix1 := FloatToIntFloat((Trunc(pt1.sx)-Trunc(p1.sx))/y1);
    y_ix2 := FloatToIntFloat((Trunc(pt2.sx)-Trunc(p2.sx))/y2);

    if ofs1<>0 then
      y_nx1 := y_nx1 + y_ix1*ofs1;

    if ofs2<>0 then
      y_nx2 := y_nx2 + y_ix2*ofs2;

    for i:=0 to DXRMachine.TextureIndexCount-1 do
    begin
      j := DXRMachine.TextureIndex[i];

      y_itex1[i].X := FloatToTextureFloatX(i, (pt1.tu[j]-p1.tu[j])/y1);
      y_itex1[i].Y := FloatToTextureFloatY(i, (pt1.tv[j]-p1.tv[j])/y1);
      y_itex2[i].X := FloatToTextureFloatX(i, (pt2.tu[j]-p2.tu[j])/y2);
      y_itex2[i].Y := FloatToTextureFloatY(i, (pt2.tv[j]-p2.tv[j])/y2);

      y_ntex1[i].X := FloatToTextureFloatX(i, p1.tu[j]);
      y_ntex1[i].Y := FloatToTextureFloatY(i, p1.tv[j]);
      y_ntex2[i].X := FloatToTextureFloatX(i, p2.tu[j]);
      y_ntex2[i].Y := FloatToTextureFloatY(i, p2.tv[j]);

      if ofs1<>0 then
      begin
        y_ntex1[i].X := y_ntex1[i].X + y_itex1[i].X*ofs1;
        y_ntex1[i].Y := y_ntex1[i].Y + y_itex1[i].Y*ofs1;
      end;

      if ofs2<>0 then
      begin
        y_ntex2[i].X := y_ntex2[i].X + y_itex2[i].X*ofs2;
        y_ntex2[i].Y := y_ntex2[i].Y + y_itex2[i].Y*ofs2;
      end;
    end;

    for i:=0 to DXRMachine.ColorIndexCount-1 do
      if DXRMachine.ColorList[i].Gouraud then
      begin
        if DXRMachine.ColorIndex[i]=0 then
        begin
          c1 := p1.color;
          c2 := p2.color;
          c2_1 := pt1.color;
          c2_2 := pt2.color;
        end else
        begin
          c1 := p1.specular;
          c2 := p2.specular;
          c2_1 := pt1.specular;
          c2_2 := pt2.specular;
        end;

        y_nc1[i].R := FloatToColorFloat(RGBA_GETRED(c1));
        y_nc1[i].G := FloatToColorFloat(RGBA_GETGREEN(c1));
        y_nc1[i].B := FloatToColorFloat(RGBA_GETBLUE(c1));
        y_nc1[i].A := FloatToColorFloat(RGBA_GETALPHA(c1));
        y_nc2[i].R := FloatToColorFloat(RGBA_GETRED(c2));
        y_nc2[i].G := FloatToColorFloat(RGBA_GETGREEN(c2));
        y_nc2[i].B := FloatToColorFloat(RGBA_GETBLUE(c2));
        y_nc2[i].A := FloatToColorFloat(RGBA_GETALPHA(c2));

        y_ic1[i].R := FloatToColorFloat((RGBA_GETRED(c2_1)-RGBA_GETRED(c1))/y1);
        y_ic1[i].G := FloatToColorFloat((RGBA_GETGREEN(c2_1)-RGBA_GETGREEN(c1))/y1);
        y_ic1[i].B := FloatToColorFloat((RGBA_GETBLUE(c2_1)-RGBA_GETBLUE(c1))/y1);
        y_ic1[i].A := FloatToColorFloat((RGBA_GETALPHA(c2_1)-RGBA_GETALPHA(c1))/y1);
        y_ic2[i].R := FloatToColorFloat((RGBA_GETRED(c2_2)-RGBA_GETRED(c2))/y2);
        y_ic2[i].G := FloatToColorFloat((RGBA_GETGREEN(c2_2)-RGBA_GETGREEN(c2))/y2);
        y_ic2[i].B := FloatToColorFloat((RGBA_GETBLUE(c2_2)-RGBA_GETBLUE(c2))/y2);
        y_ic2[i].A := FloatToColorFloat((RGBA_GETALPHA(c2_2)-RGBA_GETALPHA(c2))/y2);

        if ofs1<>0 then
        begin
          y_nc1[i].R := y_nc1[i].R + y_ic1[i].R*ofs1;
          y_nc1[i].G := y_nc1[i].G + y_ic1[i].G*ofs1;
          y_nc1[i].B := y_nc1[i].B + y_ic1[i].B*ofs1;
          y_nc1[i].A := y_nc1[i].A + y_ic1[i].A*ofs1;
        end;

        if ofs2<>0 then
        begin
          y_nc2[i].R := y_nc2[i].R + y_ic2[i].R*ofs2;
          y_nc2[i].G := y_nc2[i].G + y_ic2[i].G*ofs2;
          y_nc2[i].B := y_nc2[i].B + y_ic2[i].B*ofs2;
          y_nc2[i].A := y_nc2[i].A + y_ic2[i].A*ofs2;
        end;
      end;

    if DXRMachine.RHW.Enable then
    begin
      y_nRHW1 := FloatToRHWFloat(p1.rhw);
      y_nRHW2 := FloatToRHWFloat(p2.rhw);
      y_iRHW1 := FloatToRHWFloat((pt1.rhw-p1.rhw)/y1);
      y_iRHW2 := FloatToRHWFloat((pt2.rhw-p2.rhw)/y2);

      if ofs1<>0 then
      begin
        y_nRHW1 := y_nRHW1 + y_iRHW1*ofs1;
      end;

      if ofs2<>0 then
      begin
        y_nRHW2 := y_nRHW2 + y_iRHW2*ofs2;
      end;
    end else
    begin
      y_nRHW1 := 0;
      y_nRHW2 := 0;
      y_iRHW1 := 0;
      y_iRHW2 := 0;
    end;

    for y:=starty to starty+ycount-1 do
    begin
      if (States.EnableDrawLine=0) or ((States.EnableDrawLine-1)=y mod 2) then
        if PInteger(Integer(@y_nx1)+4)^<PInteger(Integer(@y_nx2)+4)^ then
        begin
          drawline(
            PInteger(Integer(@y_nx1)+4)^, PInteger(Integer(@y_nx2)+4)^, y,
            y_ntex1, y_ntex2,
            y_nc1, y_nc2,
            y_nRHW1, y_nRHW2
          );
        end else if PInteger(Integer(@y_nx1)+4)^>PInteger(Integer(@y_nx2)+4)^ then
        begin
          drawline(
            PInteger(Integer(@y_nx2)+4)^, PInteger(Integer(@y_nx1)+4)^, y,
            y_ntex2, y_ntex1,
            y_nc2, y_nc1,
            y_nRHW2, y_nRHW1
          );
        end;

      y_nx1 := y_nx1 + y_ix1;
      y_nx2 := y_nx2 + y_ix2;

      for i:=0 to DXRMachine.TextureIndexCount-1 do
        with DXRMachine.TextureList[DXRMachine.TextureIndex[i]] do
        begin
          y_ntex1[i].X := y_ntex1[i].X + y_itex1[i].X;
          y_ntex1[i].Y := y_ntex1[i].Y + y_itex1[i].Y;
          y_ntex2[i].X := y_ntex2[i].X + y_itex2[i].X;
          y_ntex2[i].Y := y_ntex2[i].Y + y_itex2[i].Y;
        end;

      for i:=0 to DXRMachine.ColorIndexCount-1 do
        with DXRMachine.ColorList[DXRMachine.ColorIndex[i]] do
        begin
          if Gouraud then
          begin
            y_nc1[i].R := y_nc1[i].R + y_ic1[i].R;
            y_nc1[i].G := y_nc1[i].G + y_ic1[i].G;
            y_nc1[i].B := y_nc1[i].B + y_ic1[i].B;
            y_nc1[i].A := y_nc1[i].A + y_ic1[i].A;
            y_nc2[i].R := y_nc2[i].R + y_ic2[i].R;
            y_nc2[i].G := y_nc2[i].G + y_ic2[i].G;
            y_nc2[i].B := y_nc2[i].B + y_ic2[i].B;
            y_nc2[i].A := y_nc2[i].A + y_ic2[i].A;
          end;
        end;

      if DXRMachine.RHW.Enable then
      begin
        y_nRHW1 := y_nRHW1 + y_iRHW1;
        y_nRHW2 := y_nRHW2 + y_iRHW2;
      end;
    end;
  end;

var
  p: array[0..2] of PDXR_Vertex;
  tmp: Pointer;
  y1, y2, y3, i: Integer;
begin
  {  Cull  }
  case States.CullMode of
    DXR_CULL_NONE:
        begin
        end;
    DXR_CULL_CW:
        begin
          if (Tri[1].sx-Tri[0].sx)*(Tri[2].sy-Tri[0].sy)-(Tri[1].sy-Tri[0].sy)*(Tri[2].sx-Tri[0].sx)>0 then Exit;
        end;
    DXR_CULL_CCW:
        begin
          if (Tri[1].sx-Tri[0].sx)*(Tri[2].sy-Tri[0].sy)-(Tri[1].sy-Tri[0].sy)*(Tri[2].sx-Tri[0].sx)<0 then Exit;
        end;
  end;

  Inc(RenderPrimitiveCount);

  { p[0]=Top vertex of Y axis }
  { p[1]=Center vertex of Y axis }
  { p[2]=Bottom vertex of Y axis }
  p[0]:=Tri[0]; p[1]:=Tri[1]; p[2]:=Tri[2];
  if p[0].sy>p[1].sy then begin tmp:=p[0]; p[0]:=p[1]; p[1]:=tmp end;
  if p[0].sy>p[2].sy then begin tmp:=p[0]; p[0]:=p[2]; p[2]:=tmp end;
  if p[1].sy>p[2].sy then begin tmp:=p[1]; p[1]:=p[2]; p[2]:=tmp end;

  if (p[2].sy<=p[0].sy) then Exit;
  if (p[2].sy<=0) or (p[0].sy>=Dest.Height) then Exit;
  if (p[0].sx<0) and (p[1].sx<0) and (p[2].sx<0) then Exit;
  if (p[0].sx>=Dest.Width) and (p[1].sx>=Dest.Width) and (p[2].sx>=Dest.Width) then Exit;

  {  Generate code  }
  if States.TextureFilter in [DXR_TEXTUREFILTER_MIPMAP_NEAREST, DXR_TEXTUREFILTER_MIPMAP_LINEAR] then
    DXRMachine.Compiled := False;

  if not DXRMachine.Compiled then
    InitGenerator;

  y1 := Trunc(p[1].sy)-Trunc(p[0].sy);
  y2 := Trunc(p[2].sy)-Trunc(p[1].sy);
  y3 := Trunc(p[2].sy)-Trunc(p[0].sy);

  for i:=0 to DXRMachine.TextureIndexCount-1 do
    with DXRMachine.TextureList[DXRMachine.TextureIndex[i]] do
    begin
      case TextureAddress of
        DXR_TEXTUREADDRESS_TILE:
            begin
              TexXFloat[i] := Surface.Width2 * TextureAxisFloat;
              TexYFloat[i] := Surface.Height2 * TextureAxisFloat;
            end;
        DXR_TEXTUREADDRESS_DONOTCLIP:
            begin
              TexXFloat[i] := (Surface.Width-1) * TextureAxisFloat;
              TexYFloat[i] := (Surface.Height-1) * TextureAxisFloat;
            end;
      end;
    end;

  with DXRMachine.ColorList[0] do
    if Enable and (not Gouraud) then
    begin
      nColor.R := RGBA_GETRED(Tri[0].color)*ColorFloat;
      nColor.G := RGBA_GETGREEN(Tri[0].color)*ColorFloat;
      nColor.B := RGBA_GETBLUE(Tri[0].color)*ColorFloat;
      nColor.A := RGBA_GETALPHA(Tri[0].color)*ColorFloat;
    end;

  with DXRMachine.ColorList[1] do
    if Enable and (not Gouraud) then
    begin
      nColor.R := RGBA_GETRED(Tri[0].specular)*ColorFloat;
      nColor.G := RGBA_GETGREEN(Tri[0].specular)*ColorFloat;
      nColor.B := RGBA_GETBLUE(Tri[0].specular)*ColorFloat;
      nColor.A := RGBA_GETALPHA(Tri[0].specular)*ColorFloat;
    end;

  { p[0] - p[1] }
  draw(p[0], p[1], p[0], p[2], Trunc(p[0].sy), y1, y1, y3, 0, 0);

  { p[1] - p[2] }
  draw(p[1], p[2], p[0], p[2], Trunc(p[1].sy), y2, y2, y3, 0, y1);
end;

procedure dxrDrawPrimitive(const Dest: TDXR_Surface; const States: TDXR_RenderStates; PrimitiveType: TDXR_PrimitiveType;
  VertexList: PDXR_Vertex; VertexCount: DWORD);
var
  i: Integer;
  Tri: TDXR_Triangle;
begin
  if not (PrimitiveType in [DXR_PRIMITIVETYPE_TRIANGLELIST, DXR_PRIMITIVETYPE_TRIANGLESTRIP]) then Exit;

  DXRMachine.Compiled := False;

  case PrimitiveType of
    DXR_PRIMITIVETYPE_TRIANGLELIST:
        begin
          for i:=0 to VertexCount div 3-1 do
          begin
            Tri[0] := @PArrayDXR_Vertex(VertexList)[i*3];
            Tri[1] := @PArrayDXR_Vertex(VertexList)[i*3+1];
            Tri[2] := @PArrayDXR_Vertex(VertexList)[i*3+2];
            dxrDrawTriangle(Dest, States, Tri);
          end;
        end;
    DXR_PRIMITIVETYPE_TRIANGLESTRIP:
        begin
          for i:=2 to VertexCount-1 do
          begin
            Tri[0] := @PArrayDXR_Vertex(VertexList)[i-2];
            Tri[1] := @PArrayDXR_Vertex(VertexList)[i-1];
            Tri[2] := @PArrayDXR_Vertex(VertexList)[i];
            dxrDrawTriangle(Dest, States, Tri);
          end;
        end;
  end;
end;

procedure dxrDrawPointeredPrimitive(const Dest: TDXR_Surface; const States: TDXR_RenderStates; PrimitiveType: TDXR_PrimitiveType;
  VertexList: PPDXR_Vertex; VertexCount: DWORD);
var
  i: Integer;
  Tri: TDXR_Triangle;
begin
  if not (PrimitiveType in [DXR_PRIMITIVETYPE_TRIANGLELIST, DXR_PRIMITIVETYPE_TRIANGLESTRIP]) then Exit;

  DXRMachine.Compiled := False;

  case PrimitiveType of
    DXR_PRIMITIVETYPE_TRIANGLELIST:
        begin
          for i:=0 to VertexCount div 3-1 do
          begin
            Tri[0] := PArrayPDXR_Vertex(VertexList)[i*3];
            Tri[1] := PArrayPDXR_Vertex(VertexList)[i*3+1];
            Tri[2] := PArrayPDXR_Vertex(VertexList)[i*3+2];
            dxrDrawTriangle(Dest, States, Tri);
          end;
        end;
    DXR_PRIMITIVETYPE_TRIANGLESTRIP:
        begin
          for i:=2 to VertexCount-1 do
          begin
            Tri[0] := PArrayPDXR_Vertex(VertexList)[i-2];
            Tri[1] := PArrayPDXR_Vertex(VertexList)[i-1];
            Tri[2] := PArrayPDXR_Vertex(VertexList)[i];
            dxrDrawTriangle(Dest, States, Tri);
          end;
        end;
  end;
end;

procedure dxrDrawIndexedPrimitive(const Dest: TDXR_Surface; const States: TDXR_RenderStates; PrimitiveType: TDXR_PrimitiveType;
  VertexList: PDXR_Vertex; VertexCount: DWORD; IndexList: PDWORD; IndexCount: DWORD);
var
  i: Integer;
  Tri: TDXR_Triangle;
begin
  if not (PrimitiveType in [DXR_PRIMITIVETYPE_TRIANGLELIST, DXR_PRIMITIVETYPE_TRIANGLESTRIP]) then Exit;

  DXRMachine.Compiled := False;

  case PrimitiveType of
    DXR_PRIMITIVETYPE_TRIANGLELIST:
        begin
          for i:=0 to IndexCount div 3-1 do
          begin
            Tri[0] := @PArrayDXR_Vertex(VertexList)[PArrayDWORD(IndexList)[i*3]];
            Tri[1] := @PArrayDXR_Vertex(VertexList)[PArrayDWORD(IndexList)[i*3+1]];
            Tri[2] := @PArrayDXR_Vertex(VertexList)[PArrayDWORD(IndexList)[i*3+2]];
            dxrDrawTriangle(Dest, States, Tri);
          end;
        end;
    DXR_PRIMITIVETYPE_TRIANGLESTRIP:
        begin
          for i:=2 to IndexCount-1 do
          begin
            Tri[0] := @PArrayDXR_Vertex(VertexList)[PArrayDWORD(IndexList)[i-2]];
            Tri[1] := @PArrayDXR_Vertex(VertexList)[PArrayDWORD(IndexList)[i-1]];
            Tri[2] := @PArrayDXR_Vertex(VertexList)[PArrayDWORD(IndexList)[i]];
            dxrDrawTriangle(Dest, States, Tri);
          end;
        end;
  end;
end;

function MulDiv64(a, b, c: Integer): Integer; assembler;
asm
  mov eax, a
  imul b
  idiv c
end;

function Max(B1, B2: Integer): Integer;
begin
  if B1>=B2 then Result := B1 else Result := B2;
end;

function Min(B1, B2: Integer): Integer;
begin
  if B1<=B2 then Result := B1 else Result := B2;
end;

function BltClipX(const Dest, Src: TDXR_Surface;
  var StartX, EndX, StartSrcX: Integer): Boolean;
begin
  if StartX<0 then
  begin
    StartSrcX := StartSrcX-StartX;
    StartX := 0;
  end;

  EndX := Min(EndX, Dest.Width);

  Result := (EndX>0) and (EndX-StartX>0);
end;

function BltClipY(const Dest, Src: TDXR_Surface;
  var StartY, EndY, StartSrcY: Integer): Boolean;
begin
  if StartY<0 then
  begin
    StartSrcY := StartSrcY-StartY;
    StartY := 0;
  end;

  EndY := Min(EndY, Dest.Height);

  Result := (EndY>0) and (EndY-StartY>0);
end;

function BltClip(const Dest, Src: TDXR_Surface;
  var StartX, StartY, EndX, EndY, StartSrcX, StartSrcY: Integer): Boolean;
begin
  Result := BltClipX(Dest, Src, StartX, EndX, StartSrcX) and
    BltClipY(Dest, Src, StartY, EndY, StartSrcY);
end;

function FillClip(const Dest: TDXR_Surface;
  var StartX, StartY, EndX, EndY: Integer): Boolean;
begin
  StartX := Max(StartX, 0);
  StartY := Max(StartY, 0);
  EndX := Min(EndX, Dest.Width);
  EndY := Min(EndY, Dest.Height);

  Result := (StartX<EndX) and (StartY<EndY);
end;

var
  CosinTable: array[0..255] of Double;

procedure InitCosinTable;
var
  i: Integer;
begin
  for i:=Low(CosinTable) to High(CosinTable) do
    CosinTable[i] := Cos((i/256)*2*PI);
end;

function Cos256(i: Integer): Double;
begin
  Result := CosinTable[i and 255];
end;

function Sin256(i: Integer): Double;
begin
  Result := CosinTable[(i+192) and 255];
end;

function RotationClip(const Dest, Src: TDXR_Surface;
  X, Y, Width, Height: Integer; CenterX, CenterY: Double; Angle: Integer;
  var StartX, StartY, EndX, EndY: Integer): Boolean;

  function RotatePoint(ax, ay: Integer): TPoint;
  var
    c, s: Double;
  begin
    ax := Trunc(ax - Width*CenterX);
    ay := Trunc(ay - Height*CenterY);
    c := Cos256(Angle);
    s := Sin256(Angle);
    Result.X := X+Trunc(ax * c - ay * s);
    Result.Y := Y+Trunc(ax * s + ay * c);
  end;
                     
var
  i: Integer;
  Points: array[0..3] of TPoint;
begin                      
  Points[0] := RotatePoint(0, 0);
  Points[1] := RotatePoint(Width, 0);
  Points[2] := RotatePoint(0, Height);
  Points[3] := RotatePoint(Width, Height);

  StartX := Points[0].X;
  StartY := Points[0].Y;
  EndX := StartX;
  EndY := StartY;

  for i:=1 to 3 do
    with Points[i] do
    begin
      StartX := Min(StartX, X);
      StartY := Min(StartY, Y);
      EndX := Max(EndX, X);
      EndY := Max(EndY, Y);
    end;

  StartX := Max(StartX, 0);
  StartY := Max(StartY, 0);
  EndX := Min(EndX, Dest.Width);
  EndY := Min(EndY, Dest.Height);

  Result := (StartX<=Integer(Dest.Width)) and (EndX>0) and (EndX-StartX>0) and
    (StartY<=Integer(Dest.Height)) and (EndY>0) and (EndY-StartY>0);
end;

procedure CopyXLineInitialize(const Dest, Src: TDXR_Surface;
  const Blend: TDXR_Blend; Alpha: Integer;
  IncX, IncY: Integer;
  ColorKeyEnable: Boolean; ColorKey: DWORD);
var
  Tree: PDXRMachine_Tree;
begin
  DXRMachine.Initialize;

  {  Parameter setting  }
  DXRMachine.Dest := @Dest;
  DXRMachine.TextureList[0].ColorKeyEnable := ColorKeyEnable;
  DXRMachine.TextureList[0].ColorKey := ColorKey;
  DXRMachine.TextureList[0].Surface := @Src;
  DXRMachine.TextureList[0].TextureAddress := DXR_TEXTUREADDRESS_DONOTCLIP;
  DXRMachine.TextureList[0].iAxis.X := IncX;
  DXRMachine.TextureList[0].iAxis.Y := IncY;
  DXRMachine.TextureList[0].iAxisConstant := True;
  DXRMachine.TextureList[0].DefaultColor.R := Alpha*ColorFloat;
  DXRMachine.TextureList[0].DefaultColor.G := Alpha*ColorFloat;
  DXRMachine.TextureList[0].DefaultColor.B := Alpha*ColorFloat;
  DXRMachine.TextureList[0].DefaultColor.A := Alpha*ColorFloat;

  {  Tree making  }
  Tree := DXRMachine.CreateTree_Blend(Blend, DXRMachine.CreateTree_LoadTexture(0), DXRMachine.CreateTree2(DXR_TREETYPE_LOADDESTPIXEL));

  DXRMachine.Compile(Tree);
end;

procedure dxrCopyRectBlend(const Dest, Src: TDXR_Surface;
  const DestRect, SrcRect: TRect; Blend: TDXR_Blend; Alpha: Integer;
  ColorKeyEnable: Boolean; ColorKey: DWORD);
var
  StartX, StartY, EndX, EndY, StartSrcX, StartSrcY: Integer;
  dy, sx, sy: Integer;
  IncX, IncY: Integer;
begin
  {  Clipping  }
  if (DestRect.Left>=DestRect.Right) or (DestRect.Top>=DestRect.Bottom) then Exit;

  if (SrcRect.Left<0) or (SrcRect.Top<0) or
    (SrcRect.Right>Integer(Src.Width)) or (SrcRect.Bottom>Integer(Src.Height)) or
    (SrcRect.Left>=SrcRect.Right) or (SrcRect.Top>=SrcRect.Bottom) then Exit;

  StartX := DestRect.Left;
  StartY := DestRect.Top;
  EndX := DestRect.Right;
  EndY := DestRect.Bottom;
  StartSrcX := 0;
  StartSrcY := 0;
  if not BltClip(Dest, Src, StartX, StartY, EndX, EndY, StartSrcX, StartSrcY) then Exit;

  IncX := MulDiv64(SrcRect.Right-SrcRect.Left, TextureAxisFloat, DestRect.Right-DestRect.Left);
  IncY := MulDiv64(SrcRect.Bottom-SrcRect.Top, TextureAxisFloat, DestRect.Bottom-DestRect.Top);
                                                        
  sx := StartSrcX * IncX + SrcRect.Left*TextureAxisFloat;
  sy := StartSrcY * IncY + SrcRect.Top*TextureAxisFloat;

  if (sx<0) or (sy<0) or ((sx+(EndX-StartX)*IncX) shr 16>Integer(Src.Width)) or
    ((sy+(EndY-StartY)*IncY) shr 16>Integer(Src.Height)) then Exit;

  {  Compile  }
  CopyXLineInitialize(Dest, Src, Blend, Alpha, IncX, 0, ColorKeyEnable, ColorKey);

  {  Run  }
  for dy:=StartY to EndY-1 do
  begin
    DXRMachine.Axis.Axis.X := StartX;
    DXRMachine.Axis.Axis.Y := dy;
    DXRMachine.TextureList[0].nAxis.X := sx;
    DXRMachine.TextureList[0].nAxis.Y := sy;
    DXRMachine.Run(EndX-StartX);
    Inc(sy, IncY);
  end;
end;

procedure dxrFillRectColorBlend(const Dest: TDXR_Surface;
  const DestRect: TRect; Blend: TDXR_Blend; Col: COLORREF);
var
  dy, StartX, StartY, EndX, EndY: Integer;
  Tree: PDXRMachine_Tree;
begin
  {  Clipping  }
  if (DestRect.Left>=DestRect.Right) or (DestRect.Top>=DestRect.Bottom) then Exit;

  StartX := DestRect.Left;
  StartY := DestRect.Top;
  EndX := DestRect.Right;
  EndY := DestRect.Bottom;
  if not FillClip(Dest, StartX, StartY, EndX, EndY) then Exit;

  {  Compile  }
  DXRMachine.Initialize;
  DXRMachine.Dest := @Dest;
  Tree := DXRMachine.CreateTree_Blend(Blend,
    DXRMachine.CreateTree_LoadConstColor(Byte(Col), Byte(Col shr 8), Byte(Col shr 16), Byte(Col shr 24)),
    DXRMachine.CreateTree2(DXR_TREETYPE_LOADDESTPIXEL));
  DXRMachine.Compile(Tree);     
    
  {  Run  }
  for dy:=StartY to EndY-1 do
  begin
    DXRMachine.Axis.Axis.X := StartX;
    DXRMachine.Axis.Axis.Y := dy;
    DXRMachine.Run(EndX-StartX);
  end;
end;

procedure dxrDrawWaveXBlend(const Dest, Src: TDXR_Surface;
  X, Y, Width, Height: Integer; const SrcRect: TRect; amp, Len, ph: Integer;
  Blend: TDXR_Blend; Alpha: Integer;
  ColorKeyEnable: Boolean; ColorKey: DWORD);
var
  StartX, StartY, EndX, EndY, StartSrcX, StartSrcY: Integer;
  sx, sy: Integer;
  dy, IncX, IncY, i, IncPh: Integer;
begin
  {  Clipping  }
  if (Width=0) or (Height=0) then Exit;

  if (SrcRect.Left<0) or (SrcRect.Top<0) or
    (SrcRect.Right>Integer(Src.Width)) or (SrcRect.Bottom>Integer(Src.Height)) or
    (SrcRect.Left>=SrcRect.Right) or (SrcRect.Top>=SrcRect.Bottom) then Exit;

  StartY := Y;
  EndY := Y+Height;
  StartSrcY := 0;
  if not BltClipY(Dest, Src, StartY, EndY, StartSrcY) then Exit;

  IncX := MulDiv64(SrcRect.Right-SrcRect.Left, TextureAxisFloat, Width);
  IncY := MulDiv64(SrcRect.Bottom-SrcRect.Top, TextureAxisFloat, Height);

  if Len=0 then
  begin
    IncPh := 0;
  end else
    IncPh := MulDiv64(256, 65536, Len);
  i := ph*65536+StartSrcY*IncPh;
             
  sy := StartSrcY * IncY + SrcRect.Top*TextureAxisFloat;

  if ((sy+(EndY-StartY)*IncY) shr 16>Integer(Src.Height)) then Exit;

  {  Compile  }
  CopyXLineInitialize(Dest, Src, Blend, Alpha, IncX, 0, ColorKeyEnable, ColorKey);

  {  Run  }
  for dy:=StartY to EndY-1 do
  begin
    {  X clipping  }
    StartX := X+Round(Sin256(i div 65536)*amp);
    EndX := StartX+Width;
    StartSrcX := 0;

    if BltClipX(Dest, Src, StartX, EndX, StartSrcX) then
    begin
      sx := StartSrcX * IncX + SrcRect.Left*TextureAxisFloat;
      if (sx<0) or (sy<0) or ((sx+(EndX-StartX)*IncX) shr 16>Integer(Src.Width)) then Exit;
      DXRMachine.Axis.Axis.X := StartX;
      DXRMachine.Axis.Axis.Y := dy;
      DXRMachine.TextureList[0].nAxis.X := sx;
      DXRMachine.TextureList[0].nAxis.Y := sy;
      DXRMachine.Run(EndX-StartX);
    end;

    Inc(i, IncPh);
    Inc(sy, IncY);
  end;
end;

procedure dxrDrawRotateBlend(const Dest, Src: TDXR_Surface;
  X, Y, Width, Height: Integer; const SrcRect: TRect; CenterX, CenterY: Double;
  Angle: Integer; Blend: TDXR_Blend; Alpha: Integer;
  ColorKeyEnable: Boolean; ColorKey: DWORD);
var
  StartX, EndX, StartY, EndY: Integer;
  dy, sx, sy: Integer;
  c, s, xIncX, xIncY, yIncX, yIncY: Integer;
  pSkip, pCount: Integer;
  gStartX, gStartY: Integer;
begin
  {  Clipping  }
  if (Width=0) or (Height=0) then Exit;

  if (SrcRect.Left<0) or (SrcRect.Top<0) or
    (SrcRect.Right>Integer(Src.Width)) or (SrcRect.Bottom>Integer(Src.Height)) or
    (SrcRect.Left>=SrcRect.Right) or (SrcRect.Top>=SrcRect.Bottom) then Exit;

  if not RotationClip(Dest, Src, X, Y, Width, Height, CenterX, CenterY, Angle,
    StartX, StartY, EndX, EndY) then Exit;

  c := Trunc(Cos256(-Angle)*TextureAxisFloat);
  s := Trunc(Sin256(-Angle)*TextureAxisFloat);

  xIncX := MulDiv64(SrcRect.Right-SrcRect.Left, c, Width);
  xIncY := MulDiv64(SrcRect.Bottom-SrcRect.Top, s, Height);

  yIncX := MulDiv64(SrcRect.Right-SrcRect.Left, s, Width);
  yIncY := MulDiv64(SrcRect.Bottom-SrcRect.Top, c, Height);

  sx := (-X+StartX) * xIncX + (Y-StartY) * yIncX + Trunc((SrcRect.Right-SrcRect.Left)*CenterX*TextureAxisFloat) + SrcRect.Left*TextureAxisFloat;
  sy := (-X+StartX) * xIncY - (Y-StartY) * yIncY + Trunc((SrcRect.Bottom-SrcRect.Top)*CenterY*TextureAxisFloat) + SrcRect.Top*TextureAxisFloat;

  {  Compile  }
  CopyXLineInitialize(Dest, Src, Blend, Alpha, xIncX, xIncY, ColorKeyEnable, ColorKey);

  {  Run  }
  for dy := StartY to EndY-1 do
  begin
    gStartX := sx;
    gStartY := sy;

    {  X clipping  }
    pSkip := 0;
    if xIncX>0 then
    begin
      if gStartX<SrcRect.Left*TextureAxisFloat then
        pSkip := (SrcRect.Left*TextureAxisFloat-gStartX+xIncX-1) div xIncX;
    end else if xIncX<0 then
    begin
      if gStartX>=SrcRect.Right*TextureAxisFloat then
        pSkip := (SrcRect.Right*TextureAxisFloat-gStartX+xIncX) div xIncX;
    end;

    if xIncY>0 then
    begin
      if gStartY<SrcRect.Top*TextureAxisFloat then
        pSkip := Max((SrcRect.Top*TextureAxisFloat-gStartY+xIncY-1) div xIncY, pSkip);
    end else if xIncY<0 then
    begin
      if gStartY>=SrcRect.Bottom*TextureAxisFloat then
        pSkip := Max((SrcRect.Bottom*TextureAxisFloat-gStartY+xIncY) div xIncY, pSkip);
    end;

    gStartX := gStartX + pSkip*xIncX;
    gStartY := gStartY + pSkip*xIncY;

    {  X clipping  }
    if xIncX>=0 then
    begin
      pCount := (SrcRect.Right*TextureAxisFloat-gStartX) div Max(xIncX, 1);
    end else
    begin
      pCount := (gStartX-SrcRect.Left*TextureAxisFloat) div (-xIncX);
    end;

    if xIncY>=0 then
    begin
      pCount := Min((SrcRect.Bottom*TextureAxisFloat-gStartY) div Max(xIncY, 1), pCount);
    end else
    begin
      pCount := Min((gStartY-SrcRect.Top*TextureAxisFloat) div (-xIncY), pCount);
    end;

    pCount := Min(Integer(Dest.Width)-(StartX+pSkip), pCount);

    {  Run  }
    DXRMachine.Axis.Axis.X := StartX + pSkip;
    DXRMachine.Axis.Axis.Y := dy;
    DXRMachine.TextureList[0].nAxis.X := gStartX;
    DXRMachine.TextureList[0].nAxis.Y := gStartY;
    DXRMachine.Run(pCount);

    sx := sx - yIncX;
    sy := sy + yIncY;
  end;
end;

initialization
  ReadCPUID;
  Init;
  InitCosinTable;

  dxrSetOption(DXR_OPTION_MMXENABLE, 1);
finalization
  FDXRMachine.Free;
end.