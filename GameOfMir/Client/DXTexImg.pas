unit DXTexImg;

interface

uses
  Windows, SysUtils, Classes, DXConsts;

const
  DXTextureImageGroupType_Normal = 0; // Normal group
  DXTextureImageGroupType_Mipmap = 1; // Mipmap group

type
  EDXTextureImageError = class(Exception);

  TDXTextureImageChannel = record
    Mask: DWORD;
    BitCount: Integer;

    {  Internal use  }
    _Mask2: DWORD;
    _rshift: Integer;
    _lshift: Integer;
    _BitCount2: Integer;
  end;

  TDXTextureImage_PaletteEntries =  array[0..255] of TPaletteEntry;

  TDXTextureImageType = (
    DXTextureImageType_PaletteIndexedColor,
    DXTextureImageType_RGBColor
  );

  TDXTextureImage = class;

  TDXTextureImageLoadFunc = procedure(Stream: TStream; Image: TDXTextureImage);

  TDXTextureImage = class
  private
    FOwner: TDXTextureImage;
    FSubImage: TList;
    FImageType: TDXTextureImageType;
    FWidth: Integer;
    FHeight: Integer;
    FPBits: Pointer;
    FBitCount: Integer;
    FPackedPixelOrder: Boolean;
    FWidthBytes: Integer;
    FNextLine: Integer;
    FSize: Integer;
    FTopPBits: Pointer;
    FTransparent: Boolean;
    FTransparentColor: DWORD;
    FImageGroupType: DWORD;
    FImageID: DWORD;
    FImageName: string;
    FAutoFreeImage: Boolean;
    procedure ClearImage;
    function GetPixel(x, y: Integer): DWORD;
    procedure SetPixel(x, y: Integer; c: DWORD);
    function GetScanLine(y: Integer): Pointer;
    function GetSubGroupImageCount(GroupTypeID: DWORD): Integer;
    function GetSubGroupImage(GroupTypeID: DWORD; Index: Integer): TDXTextureImage;
    function GetSubImageCount: Integer;
    function GetSubImage(Index: Integer): TDXTextureImage;
  public
    idx_index: TDXTextureImageChannel;
    idx_alpha: TDXTextureImageChannel;
    idx_palette: TDXTextureImage_PaletteEntries;
    rgb_red: TDXTextureImageChannel;
    rgb_green: TDXTextureImageChannel;
    rgb_blue: TDXTextureImageChannel;
    rgb_alpha: TDXTextureImageChannel;
    constructor Create;
    constructor CreateSub(AOwner: TDXTextureImage);
    destructor Destroy; override;
    procedure Assign(Source: TDXTextureImage);
    procedure Clear;
    procedure SetImage(ImageType: TDXTextureImageType; Width, Height, BitCount, WidthBytes, NextLine: Integer;
      PBits, TopPBits: Pointer; Size: Integer; AutoFree: Boolean);
    procedure SetSize(ImageType: TDXTextureImageType; Width, Height, BitCount, WidthBytes: Integer);
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: string);
    procedure SaveToStream(Stream: TStream);
    function EncodeColor(R, G, B, A: Byte): DWORD;
    function PaletteIndex(R, G, B: Byte): DWORD;
    class procedure RegisterLoadFunc(LoadFunc: TDXTextureImageLoadFunc);
    class procedure UnRegisterLoadFunc(LoadFunc: TDXTextureImageLoadFunc);
    property BitCount: Integer read FBitCount;
    property PackedPixelOrder: Boolean read FPackedPixelOrder write FPackedPixelOrder;
    property Height: Integer read FHeight;
    property ImageType: TDXTextureImageType read FImageType;
    property ImageGroupType: DWORD read FImageGroupType write FImageGroupType;
    property ImageID: DWORD read FImageID write FImageID;
    property ImageName: string read FImageName write FImageName;
    property NextLine: Integer read FNextLine;
    property PBits: Pointer read FPBits;
    property Pixels[x, y: Integer]: DWORD read GetPixel write SetPixel;
    property ScanLine[y: Integer]: Pointer read GetScanLine;
    property Size: Integer read FSize;
    property SubGroupImageCount[GroupTypeID: DWORD]: Integer read GetSubGroupImageCount;
    property SubGroupImages[GroupTypeID: DWORD; Index: Integer]: TDXTextureImage read GetSubGroupImage;
    property SubImageCount: Integer read GetSubImageCount;
    property SubImages[Index: Integer]: TDXTextureImage read GetSubImage;
    property TopPBits: Pointer read FTopPBits;
    property Transparent: Boolean read FTransparent write FTransparent;
    property TransparentColor: DWORD read FTransparentColor write FTransparentColor;
    property Width: Integer read FWidth;
    property WidthBytes: Integer read FWidthBytes;
  end;

function dxtMakeChannel(Mask: DWORD; indexed: Boolean): TDXTextureImageChannel;
function dxtEncodeChannel(const Channel: TDXTextureImageChannel; c: DWORD): DWORD;
function dxtDecodeChannel(const Channel: TDXTextureImageChannel; c: DWORD): DWORD;

implementation

function GetWidthBytes(Width, BitCount: Integer): Integer;
begin
  Result := (((Width*BitCount)+31) div 32)*4;
end;

function dxtEncodeChannel(const Channel: TDXTextureImageChannel; c: DWORD): DWORD;
begin
  Result := ((c shl Channel._rshift) shr Channel._lshift) and Channel.Mask;
end;

function dxtDecodeChannel(const Channel: TDXTextureImageChannel; c: DWORD): DWORD;
begin
  Result := ((c  and Channel.Mask) shr Channel._rshift) shl Channel._lshift;
  Result := Result or (Result shr Channel._BitCount2);
end;

function dxtMakeChannel(Mask: DWORD; indexed: Boolean): TDXTextureImageChannel;

  function GetMaskBitCount(b: Integer): Integer;
  var
    i: Integer;
  begin
    i := 0;
    while (i<31) and (((1 shl i) and b)=0) do Inc(i);

    Result := 0;
    while ((1 shl i) and b)<>0 do
    begin
      Inc(i);
      Inc(Result);
    end;
  end;

  function GetBitCount2(b: Integer): Integer;
  begin
    Result := 0;
    while (Result<31) and (((1 shl Result) and b)=0) do Inc(Result);
  end;

begin
  Result.BitCount := GetMaskBitCount(Mask);
  Result.Mask := Mask;

  if indexed then
  begin
    Result._rshift := GetBitCount2(Mask);
    Result._lshift := 0;
    Result._Mask2 := 1 shl Result.BitCount-1;
    Result._BitCount2 := 0;
  end else
  begin
    Result._rshift := GetBitCount2(Mask)-(8-Result.BitCount);
    if Result._rshift<0 then
    begin
      Result._lshift := -Result._rshift;
      Result._rshift := 0;
    end else
      Result._lshift := 0;
    Result._Mask2 := (1 shl Result.BitCount-1) shl (8-Result.BitCount);
    Result._BitCount2 := 8-Result.BitCount;
  end;
end;

{  TDXTextureImage  }

var
  _DXTextureImageLoadFuncList: TList;

procedure DXTextureImage_LoadDXTextureImageFunc(Stream: TStream; Image: TDXTextureImage); forward;
procedure DXTextureImage_LoadBitmapFunc(Stream: TStream; Image: TDXTextureImage); forward;

function DXTextureImageLoadFuncList: TList;
begin
  if _DXTextureImageLoadFuncList=nil then
  begin
    _DXTextureImageLoadFuncList := TList.Create;
    _DXTextureImageLoadFuncList.Add(@DXTextureImage_LoadDXTextureImageFunc);
    _DXTextureImageLoadFuncList.Add(@DXTextureImage_LoadBitmapFunc);
  end;
  Result := _DXTextureImageLoadFuncList;
end;

class procedure TDXTextureImage.RegisterLoadFunc(LoadFunc: TDXTextureImageLoadFunc);
begin
  if DXTextureImageLoadFuncList.IndexOf(@LoadFunc)=-1 then
    DXTextureImageLoadFuncList.Add(@LoadFunc);
end;

class procedure TDXTextureImage.UnRegisterLoadFunc(LoadFunc: TDXTextureImageLoadFunc);
begin
  DXTextureImageLoadFuncList.Remove(@LoadFunc);
end;

constructor TDXTextureImage.Create;
begin
  inherited Create;
  FSubImage := TList.Create;
end;

constructor TDXTextureImage.CreateSub(AOwner: TDXTextureImage);
begin
  Create;

  FOwner := AOwner;
  try           
    FOwner.FSubImage.Add(Self);
  except
    FOwner := nil;
    raise;
  end;
end;

destructor TDXTextureImage.Destroy;
begin
  Clear;
  FSubImage.Free;
  if FOwner<>nil then
    FOwner.FSubImage.Remove(Self);
  inherited Destroy;
end;

procedure TDXTextureImage.Assign(Source: TDXTextureImage);
var
  y: Integer;
begin
  SetSize(Source.ImageType, Source.Width, Source.Height, Source.BitCount, Source.WidthBytes);

  idx_index := Source.idx_index;
  idx_alpha := Source.idx_alpha;
  idx_palette := Source.idx_palette;

  rgb_red := Source.rgb_red;
  rgb_green := Source.rgb_green;
  rgb_blue := Source.rgb_blue;
  rgb_alpha := Source.rgb_alpha;

  for y:=0 to Height-1 do
    Move(Source.ScanLine[y]^, ScanLine[y]^, WidthBytes);

  Transparent := Source.Transparent;
  TransparentColor := Source.TransparentColor;
  ImageGroupType := Source.ImageGroupType;
  ImageID := Source.ImageID;
  ImageName := Source.ImageName;
end;

procedure TDXTextureImage.ClearImage;
begin
  if FAutoFreeImage then
    FreeMem(FPBits);

  FImageType := DXTextureImageType_PaletteIndexedColor;
  FWidth := 0;
  FHeight := 0;
  FBitCount := 0;
  FWidthBytes := 0;
  FNextLine := 0;
  FSize := 0;
  FPBits := nil;
  FTopPBits := nil;
  FAutoFreeImage := False;
end;

procedure TDXTextureImage.Clear;
begin
  ClearImage;

  while SubImageCount>0 do
    SubImages[SubImageCount-1].Free;

  FImageGroupType := 0;
  FImageID := 0;
  FImageName := '';

  FTransparent := False;
  FTransparentColor := 0;

  FillChar(idx_index, SizeOf(idx_index), 0);
  FillChar(idx_alpha, SizeOf(idx_alpha), 0);
  FillChar(idx_palette, SizeOf(idx_palette), 0);
  FillChar(rgb_red, SizeOf(rgb_red), 0);
  FillChar(rgb_green, SizeOf(rgb_green), 0);
  FillChar(rgb_blue, SizeOf(rgb_blue), 0);
  FillChar(rgb_alpha, SizeOf(rgb_alpha), 0);
end;

procedure TDXTextureImage.SetImage(ImageType: TDXTextureImageType; Width, Height, BitCount, WidthBytes, NextLine: Integer;
  PBits, TopPBits: Pointer; Size: Integer; AutoFree: Boolean);
begin
  ClearImage;

  FAutoFreeImage := AutoFree;
  FImageType := ImageType;
  FWidth := Width;
  FHeight := Height;
  FBitCount := BitCount;
  FWidthBytes := WidthBytes;
  FNextLine := NextLine;
  FSize := Size;
  FPBits := PBits;
  FTopPBits := TopPBits;
end;

procedure TDXTextureImage.SetSize(ImageType: TDXTextureImageType; Width, Height, BitCount, WidthBytes: Integer);
var
  APBits: Pointer;
begin
  ClearImage;

  if WidthBytes=0 then
    WidthBytes := GetWidthBytes(Width, BitCount);

  GetMem(APBits, WidthBytes*Height);
  SetImage(ImageType, Width, Height, BitCount, WidthBytes, WidthBytes, APBits, APBits, WidthBytes*Height, True);
end;

function TDXTextureImage.GetScanLine(y: Integer): Pointer;
begin
  Result := Pointer(Integer(FTopPBits)+FNextLine*y);
end;

function TDXTextureImage.GetSubGroupImageCount(GroupTypeID: DWORD): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i:=0 to SubImageCount-1 do
    if SubImages[i].ImageGroupType=GroupTypeID then
      Inc(Result);
end;

function TDXTextureImage.GetSubGroupImage(GroupTypeID: DWORD; Index: Integer): TDXTextureImage;
var
  i, j: Integer;
begin
  j := 0;
  for i:=0 to SubImageCount-1 do
    if SubImages[i].ImageGroupType=GroupTypeID then
    begin
      if j=Index then
      begin
        Result := SubImages[i];
        Exit;
      end;

      Inc(j);
    end;

  Result := nil;
  SubImages[-1];
end;

function TDXTextureImage.GetSubImageCount: Integer;
begin
  Result := FSubImage.Count;
end;

function TDXTextureImage.GetSubImage(Index: Integer): TDXTextureImage;
begin
  Result := FSubImage[Index];
end;

function TDXTextureImage.EncodeColor(R, G, B, A: Byte): DWORD;
begin
  if ImageType=DXTextureImageType_PaletteIndexedColor then
  begin
    Result := dxtEncodeChannel(idx_index, PaletteIndex(R, G, B)) or
      dxtEncodeChannel(idx_alpha, A);
  end else
  begin
    Result := dxtEncodeChannel(rgb_red, R) or
      dxtEncodeChannel(rgb_green, G) or
      dxtEncodeChannel(rgb_blue, B) or
      dxtEncodeChannel(rgb_alpha, A);
 end;
end;

function TDXTextureImage.PaletteIndex(R, G, B: Byte): DWORD;
var
  i, d, d2: Integer;
begin
  Result := 0;
  if ImageType=DXTextureImageType_PaletteIndexedColor then
  begin
    d := MaxInt;
    for i:=0 to (1 shl idx_index.BitCount)-1 do
      with idx_palette[i] do
      begin
        d2 := Abs((peRed-R))*Abs((peRed-R)) + Abs((peGreen-G))*Abs((peGreen-G)) + Abs((peBlue-B))*Abs((peBlue-B));
        if d>d2 then
        begin
          d := d2;
          Result := i;
        end;
      end;
  end;
end;

const
  Mask1: array[0..7] of DWORD= (1, 2, 4, 8, 16, 32, 64, 128);
  Mask2: array[0..3] of DWORD= (3, 12, 48, 192);
  Mask4: array[0..1] of DWORD= ($0F, $F0);

  Shift1: array[0..7] of DWORD= (0, 1, 2, 3, 4, 5, 6, 7);
  Shift2: array[0..3] of DWORD= (0, 2, 4, 6);
  Shift4: array[0..1] of DWORD= (0, 4);

type
  PByte3 = ^TByte3;
  TByte3 = array[0..2] of Byte;

function TDXTextureImage.GetPixel(x, y: Integer): DWORD;
begin
  Result := 0;
  if (x>=0) and (x<FWidth) and (y>=0) and (y<FHeight) then
  begin
    case FBitCount of
      1 : begin
            if FPackedPixelOrder then
              Result := (PByte(Integer(FTopPBits)+FNextLine*y+x shr 3)^ and Mask1[7-x and 7]) shr Shift1[7-x and 7]
            else
              Result := (PByte(Integer(FTopPBits)+FNextLine*y+x shr 3)^ and Mask1[x and 7]) shr Shift1[x and 7];
          end;
      2 : begin
            if FPackedPixelOrder then
              Result := (PByte(Integer(FTopPBits)+FNextLine*y+x shr 2)^ and Mask2[3-x and 3]) shr Shift2[3-x and 3]
            else
              Result := (PByte(Integer(FTopPBits)+FNextLine*y+x shr 2)^ and Mask2[x and 3]) shr Shift2[x and 3];
          end;
      4 : begin
            if FPackedPixelOrder then
              Result := (PByte(Integer(FTopPBits)+FNextLine*y+x shr 1)^ and Mask4[1-x and 1]) shr Shift4[1-x and 1]
            else
              Result := (PByte(Integer(FTopPBits)+FNextLine*y+x shr 1)^ and Mask4[x and 1]) shr Shift4[x and 1];
          end;
      8 : Result := PByte(Integer(FTopPBits)+FNextLine*y+x)^;
      16: Result := PWord(Integer(FTopPBits)+FNextLine*y+x*2)^;
      24: PByte3(@Result)^ := PByte3(Integer(FTopPBits)+FNextLine*y+x*3)^;
      32: Result := PDWORD(Integer(FTopPBits)+FNextLine*y+x*4)^;
    end;
  end;
end;

procedure TDXTextureImage.SetPixel(x, y: Integer; c: DWORD);
var
  P: PByte;
begin
  if (x>=0) and (x<FWidth) and (y>=0) and (y<FHeight) then
  begin
    case FBitCount of
      1 : begin
            P := Pointer(Integer(FTopPBits)+FNextLine*y+x shr 3);
            if FPackedPixelOrder then
              P^ := (P^ and (not Mask1[7-x and 7])) or ((c and 1) shl Shift1[7-x and 7])
            else
              P^ := (P^ and (not Mask1[x and 7])) or ((c and 1) shl Shift1[x and 7]);
          end;
      2 : begin
            P := Pointer(Integer(FTopPBits)+FNextLine*y+x shr 2);
            if FPackedPixelOrder then
              P^ := (P^ and (not Mask2[3-x and 3])) or ((c and 3) shl Shift2[3-x and 3])
            else
              P^ := (P^ and (not Mask2[x and 3])) or ((c and 3) shl Shift2[x and 3]);
          end;
      4 : begin
            P := Pointer(Integer(FTopPBits)+FNextLine*y+x shr 1);
            if FPackedPixelOrder then
              P^ := (P^ and (not Mask4[1-x and 1])) or ((c and 7) shl Shift4[1-x and 1])
            else
              P^ := (P^ and (not Mask4[x and 1])) or ((c and 7) shl Shift4[x and 1]);
          end;
      8 : PByte(Integer(FTopPBits)+FNextLine*y+x)^ := c;
      16: PWord(Integer(FTopPBits)+FNextLine*y+x*2)^ := c;
      24: PByte3(Integer(FTopPBits)+FNextLine*y+x*3)^ := PByte3(@c)^;
      32: PDWORD(Integer(FTopPBits)+FNextLine*y+x*4)^ := c;
    end;
  end;
end;

procedure TDXTextureImage.LoadFromFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TDXTextureImage.LoadFromStream(Stream: TStream);
var
  i, p: Integer;
begin
  Clear;

  p := Stream.Position;
  for i:=0 to DXTextureImageLoadFuncList.Count-1 do
  begin
    Stream.Position := p;
    try
      TDXTextureImageLoadFunc(DXTextureImageLoadFuncList[i])(Stream, Self);
      Exit;
    except
      Clear;
    end;
  end;

  raise EDXTextureImageError.Create(SNotSupportGraphicFile);
end;

procedure TDXTextureImage.SaveToFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure DXTextureImage_SaveDXTextureImageFunc(Stream: TStream; Image: TDXTextureImage); forward;

procedure TDXTextureImage.SaveToStream(Stream: TStream);
begin
  DXTextureImage_SaveDXTextureImageFunc(Stream, Self);
end;

{  DXTextureImage_LoadDXTextureImageFunc  }

const
  DXTextureImageFile_Type     = 'dxt:';
  DXTextureImageFile_Version  = $100;

  DXTextureImageCompress_None = 0;

  DXTextureImageFileCategoryType_Image             = $100;

  DXTextureImageFileBlockID_EndFile                = 0;
  DXTextureImageFileBlockID_EndGroup               = 1;
  DXTextureImageFileBlockID_StartGroup             = 2;
  DXTextureImageFileBlockID_Image_Format           = DXTextureImageFileCategoryType_Image + 1;
  DXTextureImageFileBlockID_Image_PixelData        = DXTextureImageFileCategoryType_Image + 2;
  DXTextureImageFileBlockID_Image_GroupInfo        = DXTextureImageFileCategoryType_Image + 3;
  DXTextureImageFileBlockID_Image_Name             = DXTextureImageFileCategoryType_Image + 4;
  DXTextureImageFileBlockID_Image_TransparentColor = DXTextureImageFileCategoryType_Image + 5;

type
  TDXTextureImageFileHeader = packed record
    FileType: array[0..4] of Char;
    ver: DWORD;
  end;

  TDXTextureImageFileBlockHeader = packed record
    ID: DWORD;
    Size: Integer;
  end;

  TDXTextureImageFileBlockHeader_StartGroup = packed record
    CategoryType: DWORD;
  end;

  TDXTextureImageHeader_Image_Format = packed record
    ImageType: TDXTextureImageType;
    Width: DWORD;
    Height: DWORD;
    BitCount: DWORD;
    WidthBytes: DWORD;
  end;

  TDXTextureImageHeader_Image_Format_Index = packed record
    idx_index_Mask: DWORD;
    idx_alpha_Mask: DWORD;
    idx_palette: array[0..255] of TPaletteEntry;
  end;

  TDXTextureImageHeader_Image_Format_RGB = packed record
    rgb_red_Mask: DWORD;
    rgb_green_Mask: DWORD;
    rgb_blue_Mask: DWORD;
    rgb_alpha_Mask: DWORD;
  end;

  TDXTextureImageHeader_Image_GroupInfo = packed record
    ImageGroupType: DWORD;
    ImageID: DWORD;
  end;

  TDXTextureImageHeader_Image_TransparentColor = packed record
    Transparent: Boolean;
    TransparentColor: DWORD;
  end;

procedure DXTextureImage_LoadDXTextureImageFunc(Stream: TStream; Image: TDXTextureImage);

  procedure ReadGroup_Image(Image: TDXTextureImage);
  var
    i: Integer;
    BlockHeader: TDXTextureImageFileBlockHeader;
    NextPos: Integer;
    SubImage: TDXTextureImage;
    Header_StartGroup: TDXTextureImageFileBlockHeader_StartGroup;
    Header_Image_Format: TDXTextureImageHeader_Image_Format;
    Header_Image_Format_Index: TDXTextureImageHeader_Image_Format_Index;
    Header_Image_Format_RGB: TDXTextureImageHeader_Image_Format_RGB;
    Header_Image_GroupInfo: TDXTextureImageHeader_Image_GroupInfo;
    Header_Image_TransparentColor: TDXTextureImageHeader_Image_TransparentColor;
    ImageName: string;
  begin
    while True do
    begin
      Stream.ReadBuffer(BlockHeader, SizeOf(BlockHeader));
      NextPos := Stream.Position + BlockHeader.Size;

      case BlockHeader.ID of
        DXTextureImageFileBlockID_EndGroup:
          begin
            {  End of group  }
            Break;
          end;
        DXTextureImageFileBlockID_StartGroup:
          begin
            {  Beginning of group  }
            Stream.ReadBuffer(Header_StartGroup, SizeOf(Header_StartGroup));
            case Header_StartGroup.CategoryType of
              DXTextureImageFileCategoryType_Image:
                begin
                  {  Image group  }
                  SubImage := TDXTextureImage.CreateSub(Image);
                  try
                    ReadGroup_Image(SubImage);
                  except
                    SubImage.Free;
                    raise;
                  end;
                end;
            end;
          end;
        DXTextureImageFileBlockID_Image_Format:
          begin
            {  Image information reading (size etc.)  }
            Stream.ReadBuffer(Header_Image_Format, SizeOf(Header_Image_Format));

            if (Header_Image_Format.ImageType<>DXTextureImageType_PaletteIndexedColor) and
              (Header_Image_Format.ImageType<>DXTextureImageType_RGBColor) then
              raise EDXTextureImageError.Create(SInvalidDXTFile);

            Image.SetSize(Header_Image_Format.ImageType, Header_Image_Format.Width, Header_Image_Format.Height,
              Header_Image_Format.BitCount, Header_Image_Format.Widthbytes);

            if Header_Image_Format.ImageType=DXTextureImageType_PaletteIndexedColor then
            begin
              {  INDEX IMAGE  }
              Stream.ReadBuffer(Header_Image_Format_Index, SizeOf(Header_Image_Format_Index));

              Image.idx_index := dxtMakeChannel(Header_Image_Format_Index.idx_index_Mask, True);
              Image.idx_alpha := dxtMakeChannel(Header_Image_Format_Index.idx_alpha_Mask, False);

              for i:=0 to 255 do
                Image.idx_palette[i] := Header_Image_Format_Index.idx_palette[i];
            end else if Header_Image_Format.ImageType=DXTextureImageType_RGBColor then
            begin
              {  RGB IMAGE  }
              Stream.ReadBuffer(Header_Image_Format_RGB, SizeOf(Header_Image_Format_RGB));

              Image.rgb_red := dxtMakeChannel(Header_Image_Format_RGB.rgb_red_Mask, False);
              Image.rgb_green := dxtMakeChannel(Header_Image_Format_RGB.rgb_green_Mask, False);
              Image.rgb_blue := dxtMakeChannel(Header_Image_Format_RGB.rgb_blue_Mask, False);
              Image.rgb_alpha := dxtMakeChannel(Header_Image_Format_RGB.rgb_alpha_Mask, False);
            end;
          end;
        DXTextureImageFileBlockID_Image_Name:
          begin
            {  Name reading  }
            SetLength(ImageName, BlockHeader.Size);
            Stream.ReadBuffer(ImageName[1], BlockHeader.Size);

            Image.ImageName := ImageName;
          end;
        DXTextureImageFileBlockID_Image_GroupInfo:
          begin
            {  Image group information reading  }
            Stream.ReadBuffer(Header_Image_GroupInfo, SizeOf(Header_Image_GroupInfo));

            Image.ImageGroupType := Header_Image_GroupInfo.ImageGroupType;
            Image.ImageID := Header_Image_GroupInfo.ImageID;
          end;
        DXTextureImageFileBlockID_Image_TransparentColor:
          begin
            {  Transparent color information reading  }
            Stream.ReadBuffer(Header_Image_TransparentColor, SizeOf(Header_Image_TransparentColor));

            Image.Transparent := Header_Image_TransparentColor.Transparent;
            Image.TransparentColor := Header_Image_TransparentColor.TransparentColor;
          end;
        DXTextureImageFileBlockID_Image_PixelData:
          begin
            {  Pixel data reading  }
            for i:=0 to Image.Height-1 do
              Stream.ReadBuffer(Image.ScanLine[i]^, Header_Image_Format.Widthbytes);
          end;
      end;

      Stream.Seek(NextPos, soFromBeginning);
    end;
  end;

var
  FileHeader: TDXTextureImageFileHeader;
  BlockHeader: TDXTextureImageFileBlockHeader;
  Header_StartGroup: TDXTextureImageFileBlockHeader_StartGroup;
  NextPos: Integer;
begin
  {  File header reading  }
  Stream.ReadBuffer(FileHeader, SizeOf(FileHeader));

  if FileHeader.FileType<>DXTextureImageFile_Type then
    raise EDXTextureImageError.Create(SInvalidDXTFile);
  if FileHeader.ver<>DXTextureImageFile_Version then
    raise EDXTextureImageError.Create(SInvalidDXTFile);

  while True do
  begin
    Stream.ReadBuffer(BlockHeader, SizeOf(BlockHeader));
    NextPos := Stream.Position + BlockHeader.Size;

    case BlockHeader.ID of
      DXTextureImageFileBlockID_EndFile:
        begin
          {  End of file  }
          Break;
        end;
      DXTextureImageFileBlockID_StartGroup:
        begin
          {  Beginning of group  }
          Stream.ReadBuffer(Header_StartGroup, SizeOf(Header_StartGroup));
          case Header_StartGroup.CategoryType of
            DXTextureImageFileCategoryType_Image: ReadGroup_Image(Image);
          end;
        end;
    end;
    
    Stream.Seek(NextPos, soFromBeginning);
  end;
end;

type
  PDXTextureImageFileBlockHeaderWriter_BlockInfo = ^TDXTextureImageFileBlockHeaderWriter_BlockInfo;
  TDXTextureImageFileBlockHeaderWriter_BlockInfo = record
    BlockID: DWORD;
    StreamPos: Integer;
  end;

  TDXTextureImageFileBlockHeaderWriter = class
  private
    FStream: TStream;
    FList: TList;
  public
    constructor Create(Stream: TStream);
    destructor Destroy; override;
    procedure StartBlock(BlockID: DWORD);
    procedure EndBlock;
    procedure WriteBlock(BlockID: DWORD);
    procedure StartGroup(CategoryType: DWORD);
    procedure EndGroup;
  end;

constructor TDXTextureImageFileBlockHeaderWriter.Create(Stream: TStream);
begin
  inherited Create;
  FStream := Stream;
  FList := TList.Create;
end;

destructor TDXTextureImageFileBlockHeaderWriter.Destroy;
var
  i: Integer;
begin
  for i:=0 to FList.Count-1 do
    Dispose(PDXTextureImageFileBlockHeaderWriter_BlockInfo(FList[i]));
  FList.Free;
  inherited Destroy;
end;

procedure TDXTextureImageFileBlockHeaderWriter.StartBlock(BlockID: DWORD);
var
  BlockInfo: PDXTextureImageFileBlockHeaderWriter_BlockInfo;
  BlockHeader: TDXTextureImageFileBlockHeader;
begin
  New(BlockInfo);
  BlockInfo.BlockID := BlockID;
  BlockInfo.StreamPos := FStream.Position;
  FList.Add(BlockInfo);

  BlockHeader.ID := BlockID;
  BlockHeader.Size := 0;
  FStream.WriteBuffer(BlockHeader, SizeOf(BlockHeader));
end;

procedure TDXTextureImageFileBlockHeaderWriter.EndBlock;
var
  BlockHeader: TDXTextureImageFileBlockHeader;
  BlockInfo: PDXTextureImageFileBlockHeaderWriter_BlockInfo;
  CurStreamPos: Integer;
begin
  CurStreamPos := FStream.Position;
  try
    BlockInfo := FList[FList.Count-1];

    FStream.Position := BlockInfo.StreamPos;
    BlockHeader.ID := BlockInfo.BlockID;
    BlockHeader.Size := CurStreamPos-(BlockInfo.StreamPos+SizeOf(TDXTextureImageFileBlockHeader));
    FStream.WriteBuffer(BlockHeader, SizeOf(BlockHeader));
  finally
    FStream.Position := CurStreamPos;

    Dispose(FList[FList.Count-1]);
    FList.Count := FList.Count-1;
  end;
end;

procedure TDXTextureImageFileBlockHeaderWriter.WriteBlock(BlockID: DWORD);
var
  BlockHeader: TDXTextureImageFileBlockHeader;
begin
  BlockHeader.ID := BlockID;
  BlockHeader.Size := 0;
  FStream.WriteBuffer(BlockHeader, SizeOf(BlockHeader));
end;

procedure TDXTextureImageFileBlockHeaderWriter.StartGroup(CategoryType: DWORD);
var
  Header_StartGroup: TDXTextureImageFileBlockHeader_StartGroup;
begin
  StartBlock(DXTextureImageFileBlockID_StartGroup);

  Header_StartGroup.CategoryType := CategoryType;
  FStream.WriteBuffer(Header_StartGroup, SizeOf(Header_StartGroup));
end;

procedure TDXTextureImageFileBlockHeaderWriter.EndGroup;
begin
  WriteBlock(DXTextureImageFileBlockID_EndGroup);
  EndBlock;
end;

procedure DXTextureImage_SaveDXTextureImageFunc(Stream: TStream; Image: TDXTextureImage);
var
  BlockHeaderWriter: TDXTextureImageFileBlockHeaderWriter;

  function CalcProgressCount(Image: TDXTextureImage): Integer;
  var
    i: Integer;
  begin
    Result := Image.WidthBytes*Image.Height;
    for i:=0 to Image.SubImageCount-1 do
      Inc(Result, CalcProgressCount(Image.SubImages[i]));
  end;

  procedure WriteGroup_Image(Image: TDXTextureImage);
  var
    i: Integer;
    Header_Image_Format: TDXTextureImageHeader_Image_Format;
    Header_Image_Format_Index: TDXTextureImageHeader_Image_Format_Index;
    Header_Image_Format_RGB: TDXTextureImageHeader_Image_Format_RGB;
    Header_Image_GroupInfo: TDXTextureImageHeader_Image_GroupInfo;
    Header_Image_TransparentColor: TDXTextureImageHeader_Image_TransparentColor;
  begin
    BlockHeaderWriter.StartGroup(DXTextureImageFileCategoryType_Image);
    try
      {  Image format writing  }
      if Image.Size>0 then
      begin
        Header_Image_Format.ImageType := Image.ImageType;
        Header_Image_Format.Width := Image.Width;
        Header_Image_Format.Height := Image.Height;
        Header_Image_Format.BitCount := Image.BitCount;
        Header_Image_Format.WidthBytes := Image.WidthBytes;

        BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_Format);
        try
          Stream.WriteBuffer(Header_Image_Format, SizeOf(Header_Image_Format));

          case Image.ImageType of
            DXTextureImageType_PaletteIndexedColor:
              begin
                {  INDEX IMAGE  }
                Header_Image_Format_Index.idx_index_Mask := Image.idx_index.Mask;
                Header_Image_Format_Index.idx_alpha_Mask := Image.idx_alpha.Mask;
                for i:=0 to 255 do
                  Header_Image_Format_Index.idx_palette[i] := Image.idx_palette[i];

                Stream.WriteBuffer(Header_Image_Format_Index, SizeOf(Header_Image_Format_Index));
              end;
            DXTextureImageType_RGBColor:
              begin
                {  RGB IMAGE  }
                Header_Image_Format_RGB.rgb_red_Mask := Image.rgb_red.Mask;
                Header_Image_Format_RGB.rgb_green_Mask := Image.rgb_green.Mask;
                Header_Image_Format_RGB.rgb_blue_Mask := Image.rgb_blue.Mask;
                Header_Image_Format_RGB.rgb_alpha_Mask := Image.rgb_alpha.Mask;

                Stream.WriteBuffer(Header_Image_Format_RGB, SizeOf(Header_Image_Format_RGB));
              end;
          end;
        finally
          BlockHeaderWriter.EndBlock;
        end;
      end;

      {  Image group information writing  }
      BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_GroupInfo);
      try
        Header_Image_GroupInfo.ImageGroupType := Image.ImageGroupType;
        Header_Image_GroupInfo.ImageID := Image.ImageID;

        Stream.WriteBuffer(Header_Image_GroupInfo, SizeOf(Header_Image_GroupInfo));
      finally
        BlockHeaderWriter.EndBlock;
      end;

      {  Name writing  }
      BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_Name);
      try
        Stream.WriteBuffer(Image.ImageName[1], Length(Image.ImageName));
      finally
        BlockHeaderWriter.EndBlock;
      end;

      {  Transparent color writing  }
      BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_TransparentColor);
      try
        Header_Image_TransparentColor.Transparent := Image.Transparent;
        Header_Image_TransparentColor.TransparentColor := Image.TransparentColor;

        Stream.WriteBuffer(Header_Image_TransparentColor, SizeOf(Header_Image_TransparentColor));
      finally
        BlockHeaderWriter.EndBlock;
      end;

      {  Pixel data writing  }
      if Image.Size>0 then
      begin
        BlockHeaderWriter.StartBlock(DXTextureImageFileBlockID_Image_PixelData);
        try
         for i:=0 to Image.Height-1 do
           Stream.WriteBuffer(Image.ScanLine[i]^, Image.Widthbytes);
        finally
          BlockHeaderWriter.EndBlock;
        end;
      end;

      {  Sub-image writing  }
      for i:=0 to Image.SubImageCount-1 do
        WriteGroup_Image(Image.SubImages[i]);
    finally
      BlockHeaderWriter.EndGroup;
    end;
  end;

var
  FileHeader: TDXTextureImageFileHeader;
begin
  {  File header writing  }
  FileHeader.FileType := DXTextureImageFile_Type;
  FileHeader.ver := DXTextureImageFile_Version;
  Stream.WriteBuffer(FileHeader, SizeOf(FileHeader));

  {  Image writing  }
  BlockHeaderWriter := TDXTextureImageFileBlockHeaderWriter.Create(Stream);
  try
    {  Image writing  }
    WriteGroup_Image(Image);

    {  End of file  }
    BlockHeaderWriter.WriteBlock(DXTextureImageFileBlockID_EndFile);
  finally
    BlockHeaderWriter.Free;
  end;
end;

{  DXTextureImage_LoadBitmapFunc  }

procedure DXTextureImage_LoadBitmapFunc(Stream: TStream; Image: TDXTextureImage);
type
  TDIBPixelFormat = packed record
    RBitMask, GBitMask, BBitMask: DWORD;
  end;
var
  TopDown: Boolean;
  BF: TBitmapFileHeader;
  BI: TBitmapInfoHeader;

  procedure DecodeRGB;
  var
    y: Integer;
  begin
    for y:=0 to Image.Height-1 do
    begin
      if TopDown then
        Stream.ReadBuffer(Image.ScanLine[y]^, Image.WidthBytes)
      else
        Stream.ReadBuffer(Image.ScanLine[Image.Height-y-1]^, Image.WidthBytes);
    end;
  end;

  procedure DecodeRLE4;
  var
    SrcDataP: Pointer;
    B1, B2, C: Byte;
    Dest, Src, P: PByte;
    X, Y, i: Integer;
  begin
    GetMem(SrcDataP, BI.biSizeImage);
    try
      Stream.ReadBuffer(SrcDataP^, BI.biSizeImage);

      Dest := Image.TopPBits;
      Src := SrcDataP;
      X := 0;
      Y := 0;

      while True do
      begin
        B1 := Src^; Inc(Src);
        B2 := Src^; Inc(Src);

        if B1=0 then
        begin
          case B2 of
            0: begin  {  End of line  }
                 X := 0; Inc(Y);
                 Dest := Image.ScanLine[Y];
               end;
            1: Break; {  End of bitmap  }
            2: begin  {  Difference of coordinates  }
                 Inc(X, B1); Inc(Y, B2); Inc(Src, 2);
                 Dest := Image.ScanLine[Y];
               end;
          else
            {  Absolute mode  }
            C := 0;
            for i:=0 to B2-1 do
            begin
              if i and 1=0 then
              begin
                C := Src^; Inc(Src);
              end else
              begin
                C := C shl 4;
              end;

              P := Pointer(Integer(Dest)+X shr 1);
              if X and 1=0 then
                P^ := (P^ and $0F) or (C and $F0)
              else
                P^ := (P^ and $F0) or ((C and $F0) shr 4);

              Inc(X);
            end;
          end;
        end else
        begin
          {  Encoding mode  }
          for i:=0 to B1-1 do
          begin
            P := Pointer(Integer(Dest)+X shr 1);
            if X and 1=0 then
              P^ := (P^ and $0F) or (B2 and $F0)
            else
              P^ := (P^ and $F0) or ((B2 and $F0) shr 4);

            Inc(X);

            // Swap nibble
            B2 := (B2 shr 4) or (B2 shl 4);
          end;
        end;

        {  Word arrangement  }
        Inc(Src, Longint(Src) and 1);
      end;
    finally
      FreeMem(SrcDataP);
    end;
  end;

  procedure DecodeRLE8;
  var
    SrcDataP: Pointer;
    B1, B2: Byte;
    Dest, Src: PByte;
    X, Y: Integer;
  begin
    GetMem(SrcDataP, BI.biSizeImage);
    try
      Stream.ReadBuffer(SrcDataP^, BI.biSizeImage);

      Dest := Image.TopPBits;
      Src := SrcDataP;
      X := 0;
      Y := 0;

      while True do
      begin
        B1 := Src^; Inc(Src);
        B2 := Src^; Inc(Src);

        if B1=0 then
        begin
          case B2 of
            0: begin  {  End of line  }
                 X := 0; Inc(Y);
                 Dest := Pointer(Longint(Image.TopPBits)+Y*Image.NextLine+X);
               end;
            1: Break; {  End of bitmap  }
            2: begin  {  Difference of coordinates  }
                 Inc(X, B1); Inc(Y, B2); Inc(Src, 2);
                 Dest := Pointer(Longint(Image.TopPBits)+Y*Image.NextLine+X);
               end;
          else
            {  Absolute mode  }
            Move(Src^, Dest^, B2); Inc(Dest, B2); Inc(Src, B2);
          end;
        end else
        begin
          {  Encoding mode  }
          FillChar(Dest^, B1, B2); Inc(Dest, B1);
        end;

        {  Word arrangement  }
        Inc(Src, Longint(Src) and 1);
      end;
    finally
      FreeMem(SrcDataP);
    end;
  end;

var
  BC: TBitmapCoreHeader;
  RGBTriples: array[0..255] of TRGBTriple;
  RGBQuads: array[0..255] of TRGBQuad;
  i, PalCount, j: Integer;
  OS2: Boolean;
  PixelFormat: TDIBPixelFormat;
begin
  {  File header reading  }
  i := Stream.Read(BF, SizeOf(TBitmapFileHeader));
  if i=0 then Exit;
  if i<>SizeOf(TBitmapFileHeader) then
    raise EDXTextureImageError.Create(SInvalidDIB);

  {  Is the head 'BM'?  }
  if BF.bfType<>Ord('B') + Ord('M')*$100 then
    raise EDXTextureImageError.Create(SInvalidDIB);

  {  Reading of size of header  }
  i := Stream.Read(BI.biSize, 4);
  if i<>4 then
    raise EDXTextureImageError.Create(SInvalidDIB);

  {  Kind check of DIB  }
  OS2 := False;

  case BI.biSize of
    SizeOf(TBitmapCoreHeader):
      begin
        {  OS/2 type  }
        Stream.ReadBuffer(Pointer(Integer(@BC)+4)^, SizeOf(TBitmapCoreHeader)-4);

        FilLChar(BI, SizeOf(BI), 0);
        with BI do
        begin
          biClrUsed := 0;
          biCompression := BI_RGB;
          biBitCount := BC.bcBitCount;
          biHeight := BC.bcHeight;
          biWidth := BC.bcWidth;
        end;

        OS2 := True;
      end;
    SizeOf(TBitmapInfoHeader):
      begin
        {  Windows type  }
        Stream.ReadBuffer(Pointer(Integer(@BI)+4)^, SizeOf(TBitmapInfoHeader)-4);
      end;
  else
    raise EDXTextureImageError.Create(SInvalidDIB);
  end;

  {  Bit mask reading  }
  if BI.biCompression = BI_BITFIELDS then
  begin
    Stream.ReadBuffer(PixelFormat, SizeOf(PixelFormat));
  end else
  begin
    if BI.biBitCount=16 then
    begin
      PixelFormat.RBitMask := $7C00;
      PixelFormat.GBitMask := $03E0;
      PixelFormat.BBitMask := $001F;
    end else if (BI.biBitCount=24) or (BI.biBitCount=32) then
    begin
      PixelFormat.RBitMask := $00FF0000;
      PixelFormat.GBitMask := $0300FF00;
      PixelFormat.BBitMask := $000000FF;
    end;
  end;

  {  DIB making  }
  if BI.biHeight<0 then
  begin
    BI.biHeight := -BI.biHeight;
    TopDown := True;
  end else
    TopDown := False;

  if BI.biBitCount in [1, 4, 8] then
  begin
    Image.SetSize(DXTextureImageType_PaletteIndexedColor, BI.biWidth, BI.biHeight, BI.biBitCount,
      (((BI.biWidth*BI.biBitCount)+31) div 32)*4);

    Image.idx_index := dxtMakeChannel(1 shl BI.biBitCount-1, True);
    Image.PackedPixelOrder := True;
  end else
  begin          
    Image.SetSize(DXTextureImageType_RGBColor, BI.biWidth, BI.biHeight, BI.biBitCount,
      (((BI.biWidth*BI.biBitCount)+31) div 32)*4);

    Image.rgb_red := dxtMakeChannel(PixelFormat.RBitMask, False);
    Image.rgb_green := dxtMakeChannel(PixelFormat.GBitMask, False);
    Image.rgb_blue := dxtMakeChannel(PixelFormat.BBitMask, False);

    j := Image.rgb_red.BitCount+Image.rgb_green.BitCount+Image.rgb_blue.BitCount;
    if j<BI.biBitCount then
      Image.rgb_alpha := dxtMakeChannel((1 shl (BI.biBitCount-j)-1) shl j, False);

    Image.PackedPixelOrder := False;
  end;

  {  palette reading  }
  PalCount := BI.biClrUsed;
  if (PalCount=0) and (BI.biBitCount<=8) then
    PalCount := 1 shl BI.biBitCount;
  if PalCount>256 then PalCount := 256;

  if OS2 then
  begin
    {  OS/2 type  }
    Stream.ReadBuffer(RGBTriples, SizeOf(TRGBTriple)*PalCount);
    for i:=0 to PalCount-1 do
    begin
      Image.idx_palette[i].peRed := RGBTriples[i].rgbtRed;
      Image.idx_palette[i].peGreen := RGBTriples[i].rgbtGreen;
      Image.idx_palette[i].peBlue := RGBTriples[i].rgbtBlue;
    end;
  end else
  begin
    {  Windows type  }
    Stream.ReadBuffer(RGBQuads, SizeOf(TRGBQuad)*PalCount);
    for i:=0 to PalCount-1 do
    begin
      Image.idx_palette[i].peRed := RGBQuads[i].rgbRed;
      Image.idx_palette[i].peGreen := RGBQuads[i].rgbGreen;
      Image.idx_palette[i].peBlue := RGBQuads[i].rgbBlue;
    end;
  end;

  {  Pixel data reading  }
  case BI.biCompression of
    BI_RGB      : DecodeRGB;
    BI_BITFIELDS: DecodeRGB;
    BI_RLE4     : DecodeRLE4;
    BI_RLE8     : DecodeRLE8;
  else
    raise EDXTextureImageError.Create(SInvalidDIB);
  end;
end;

initialization
finalization
  _DXTextureImageLoadFuncList.Free;
end.
