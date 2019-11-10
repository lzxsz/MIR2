program gendxt;

{$APPTYPE CONSOLE}

{NOTE.JB.}
{Changes in image resizing - image has to size n^2 for texture}
{Original Hori's functions was get out, no source code there for it}
{DXTex.pas synchronized with older version}
uses
  Windows,
  Classes,
  SysUtils,
  Math,
  DXDraws;

type
  TResizeFilterInfo = Integer;{TFilterTypeResample;}
Const
  ResizeFilterInfo_Triangle = 1{ftrTriangle};
  ResizeFilterInfo_Box = 0{ftrBox};
type
  TOutputImageChannel = (rgbNone, rgbRed, rgbGreen, rgbBlue, rgbAlpha, yuvY);
  TOutputImageChannels = set of TOutputImageChannel;

  TOutputImageChannelInfo = record
    Image: TDXTextureImage;
    BitCount: Integer;
  end;

  TOutputImageFormat = record
    ImageType: TDXTextureImageType;
    Width: Integer;
    Height: Integer;
    Bits: Pointer;
    BitCount: Integer;
    WidthBytes: Integer;

    Transparent: Boolean;
    TransparentColor: TColorRef;

    idx_index: TDXTextureImageChannel;
    idx_alpha: TDXTextureImageChannel;
    idx_palette: TDXTextureImage_PaletteEntries;
    rgb_red: TDXTextureImageChannel;
    rgb_green: TDXTextureImageChannel;
    rgb_blue: TDXTextureImageChannel;
    rgb_alpha: TDXTextureImageChannel;

    Compress: TDXTextureImageFileCompressType;
    MipmapCount: Integer;
    Name: string;
  end;

var
  HasChannels: TOutputImageChannels;
  HasChannelImages: array[TOutputImageChannel] of TOutputImageChannelInfo;
  ChannelChangeTable: array[TOutputImageChannel] of TOutputImageChannel;

  HasImageList: TList;

  OutputFormat: TOutputImageFormat;

function PosRight(c: Char; const Text: string): Integer;
var
  i: Integer;
begin
  for i:=Length(Text) downto 1 do
    if Text[i]=c then
    begin
      Result := i;
      Exit;
    end;
  Result := 0;
end;

procedure ProcessImageParam;
var
  i, j: Integer;
  s, ParamName, ParamValue: string;
  Channel: TOutputImageChannel;
  ChannelParamName: TOutputImageChannels;
  ChannelBitCount: array[TOutputImageChannel] of Integer;
  Image: TDXTextureImage;
  UseChannelText, BitCountText, ChannelChangeText, ImageFileNameText: string;
begin
  for i:=2 to ParamCount do
  begin
    s := ParamStr(i);

    j := Pos('=', s);
    if j<>0 then
    begin
      ParamName := Trim(Copy(s, 1, j-1));
      ParamValue := Trim(Copy(s, j+1, MaxInt));
    end else
    begin
      ParamName := s;
      ParamValue := '';
    end;

    if AnsiCompareText(ParamName, 'TC')=0 then
    begin
      OutputFormat.Transparent := True;
      if Copy(ParamValue, 1, 1)='#' then
        OutputFormat.TransparentColor := PaletteIndex(StrToInt(Trim(Copy(ParamValue, 2, MaxInt))))
      else
        OutputFormat.TransparentColor := RGB(StrToInt(ParamValue) shr 16, StrToInt(ParamValue) shr 8, StrToInt(ParamValue));
    end else
    if AnsiCompareText(ParamName, 'w')=0 then
    begin
      OutputFormat.Width := StrToInt(ParamValue);
    end else
    if AnsiCompareText(ParamName, 'h')=0 then
    begin
      OutputFormat.Height := StrToInt(ParamValue);
    end else
    if AnsiCompareText(ParamName, 'Compress')=0 then
    begin
      if AnsiCompareText(ParamValue, 'Max')=0 then
        OutputFormat.Compress := DXTextureImageFileCompressType_ZLIB
      else if AnsiCompareText(ParamValue, 'ZLIB')=0 then
        OutputFormat.Compress := DXTextureImageFileCompressType_ZLIB
      else if AnsiCompareText(ParamValue, 'None')=0 then
        OutputFormat.Compress := DXTextureImageFileCompressType_None
    end else
    if AnsiCompareText(ParamName, 'Mipmap')=0 then
    begin
      if (ParamValue='') or (AnsiCompareText(ParamValue, 'Max')=0) then
        OutputFormat.MipmapCount := MaxInt
      else
        OutputFormat.MipmapCount := StrToInt(ParamValue);
    end else
    if AnsiCompareText(ParamName, 'Name')=0 then
    begin
      OutputFormat.Name := ParamValue;
    end else
    begin
      for Channel:=Low(Channel) to High(Channel) do
        ChannelBitCount[Channel] := -1;
      ChannelParamName := [];

      UseChannelText := '';
      BitCountText := '';
      ImageFileNameText := ParamValue;
      ChannelChangeText := '';

      j := PosRight(';', ParamName);
      if j<>0 then
      begin
        ChannelChangeText := Trim(Copy(ParamName, j+1, MaxInt));
        ParamName := Trim(Copy(ParamName, 1, j-1));
      end else
        ImageFileNameText := Trim(ParamValue);

      j := Pos(':', ParamName);
      if j<>0 then
      begin
        UseChannelText := Trim(Copy(ParamName, 1, j-1));
        BitCountText := Trim(Copy(ParamName, j+1, MaxInt));
      end else
        UseChannelText := Trim(ParamName);

      if (ChannelChangeText<>'') and (Length(UseChannelText)<>Length(ChannelChangeText)) then
        raise Exception.Create('Invalid channel');
      if (BitCountText<>'') and (Length(UseChannelText)<>Length(BitCountText)) then
        raise Exception.Create('Invalid bitcount');

      {  The channel which you use acquisition  }
      for j:=1 to Length(UseChannelText) do
      begin
        case UseChannelText[j] of
          'R','r': Channel := rgbRed;
          'G','g': Channel := rgbGreen;
          'B','b': Channel := rgbBlue;
          'A','a': Channel := rgbAlpha;
        else
          raise Exception.CreateFmt('Invalid channel type (%s)', [UseChannelText[j]]);
        end;

        if not (Channel in HasChannels) then
        begin
          if BitCountText<>'' then
            ChannelBitCount[Channel] := StrToInt(Copy(BitCountText, j, 1));
          if ChannelBitCount[Channel]<>0 then
            ChannelParamName := ChannelParamName + [Channel];

          if ChannelChangeText<>'' then
          begin
            case ChannelChangeText[j] of
              'R','r': ChannelChangeTable[Channel] := rgbRed;
              'G','g': ChannelChangeTable[Channel] := rgbGreen;
              'B','b': ChannelChangeTable[Channel] := rgbBlue;
              'Y','y': ChannelChangeTable[Channel] := yuvY;
              'N','n': ChannelChangeTable[Channel] := rgbNone;
            else
              raise Exception.CreateFmt('Invalid channel type(%s)', [ChannelChangeText[j]]);
            end;
          end;
        end;
      end;

      {  Processing of each  }
      if ChannelParamName<>[] then
      begin
        {  Picture load  }
        Image := nil;
        for j:=0 to HasImageList.Count-1 do
          if AnsiCompareFileName(TDXTextureImage(HasImageList[j]).ImageName, ImageFileNameText)=0 then
          begin
            Image := HasImageList[j];
            Break;
          end;

        if Image=nil then
        begin
          Image := TDXTextureImage.Create;
          try
            Image.ImageName := ImageFileNameText;
            Image.LoadFromFile(ImageFileNameText);
          except
            Image.Free;
            raise;
          end;

          HasImageList.Add(Image);
        end;

        {  Each channel processing  }
        for Channel:=Low(Channel) to High(Channel) do
          if Channel in ChannelParamName then
          begin
            if ChannelBitCount[Channel]>=0 then
              HasChannelImages[Channel].BitCount := ChannelBitCount[Channel]
            else
            begin
              case Image.ImageType of
                DXTextureImageType_PaletteIndexedColor:
                  begin
                    case Channel of
                      rgbRed  : HasChannelImages[Channel].BitCount := 8;
                      rgbGreen: HasChannelImages[Channel].BitCount := 8;
                      rgbBlue : HasChannelImages[Channel].BitCount := 8;
                      rgbAlpha: HasChannelImages[Channel].BitCount := 8;
                    end;
                  end;
                DXTextureImageType_RGBColor:
                  begin
                    case Channel of
                      rgbRed  : HasChannelImages[Channel].BitCount := Image.rgb_red.BitCount;
                      rgbGreen: HasChannelImages[Channel].BitCount := Image.rgb_green.BitCount;
                      rgbBlue : HasChannelImages[Channel].BitCount := Image.rgb_blue.BitCount;
                      rgbAlpha: HasChannelImages[Channel].BitCount := 8;
                    end;
                  end;
              end;
            end;

            if HasChannelImages[Channel].BitCount=0 then Continue;

            HasChannels := HasChannels + [Channel];
            HasChannelImages[Channel].Image := Image;
          end;
      end;
    end;
  end;
end;

{  Output format calculation  }
function GetBitCount(b: Integer): Integer;
begin
  Result := 32;
  while (Result>0) and (((1 shl (Result-1)) and b)=0) do Dec(Result);
end;

procedure CalcOutputBitFormat;
var
  BitCount: DWORD;
  NewWidth, NewHeight, i, j: Integer;
  Channel: TOutputImageChannel;
begin
  if OutputFormat.Name='' then OutputFormat.Name := ExtractFileName(ParamStr(1));

  {  Size calculation  }
  NewWidth := 1 shl GetBitCount(TDXTextureImage(HasImageList[0]).Width);
  NewHeight := 1 shl GetBitCount(TDXTextureImage(HasImageList[0]).Height);
  NewWidth := Max(NewWidth, NewHeight);
  NewHeight := NewWidth;
  if Abs(OutputFormat.Width-NewWidth)>Abs(OutputFormat.Width-NewWidth div 2) then
    NewWidth := NewWidth div 2;
  if Abs(OutputFormat.Height-NewHeight)>Abs(OutputFormat.Height-NewHeight div 2) then
    NewHeight := NewHeight div 2;

  if OutputFormat.Width=0 then OutputFormat.Width := NewWidth;
  if OutputFormat.Height=0 then OutputFormat.Height := NewHeight;

  {  Other several calculation  }
  i := Min(OutputFormat.Width, OutputFormat.Height);
  j := 0;
  while i>1 do
  begin
    i := i div 2;
    Inc(j);
  end;

  OutputFormat.MipmapCount := Min(j, OutputFormat.MipmapCount);

  {  Output type calculation  }
  if (HasChannelImages[rgbRed].Image=HasChannelImages[rgbGreen].Image) and
     (HasChannelImages[rgbRed].Image=HasChannelImages[rgbBlue].Image) and
     (HasChannelImages[rgbRed].Image<>nil) and (HasChannelImages[rgbRed].Image.ImageType=DXTextureImageType_PaletteIndexedColor) and

     (HasChannelImages[rgbRed].BitCount=8) and
     (HasChannelImages[rgbGreen].BitCount=8) and
     (HasChannelImages[rgbBlue].BitCount=8) and

     (ChannelChangeTable[rgbRed]=rgbRed) and
     (ChannelChangeTable[rgbGreen]=rgbGreen) and
     (ChannelChangeTable[rgbBlue]=rgbBlue) and

     (OutputFormat.Width=HasChannelImages[rgbRed].Image.Width) and
     (OutputFormat.Height=HasChannelImages[rgbRed].Image.Height) and

     (OutputFormat.MipmapCount=0) then
  begin
    OutputFormat.ImageType := DXTextureImageType_PaletteIndexedColor;
  end else
    OutputFormat.ImageType := DXTextureImageType_RGBColor;

  {  Bit several calculations  }
  OutputFormat.BitCount := 0;

  for Channel:=Low(Channel) to High(Channel) do
    if (HasChannelImages[Channel].Image<>nil) and (HasChannelImages[Channel].Image.ImageType=DXTextureImageType_PaletteIndexedColor) then
    begin
      OutputFormat.idx_palette := HasChannelImages[Channel].Image.idx_palette;
      Break;
    end;

  if OutputFormat.ImageType=DXTextureImageType_PaletteIndexedColor then
  begin
    {  Index channel }
    if rgbRed in HasChannels then
    begin
      BitCount := HasChannelImages[rgbRed].BitCount;
      OutputFormat.idx_index := dxtMakeChannel(((1 shl BitCount)-1) shl OutputFormat.BitCount, True);
      Inc(OutputFormat.BitCount, BitCount);
    end;

    {  Alpha channel  }
    if rgbAlpha in HasChannels then
    begin
      BitCount :=  HasChannelImages[rgbAlpha].BitCount;
      OutputFormat.idx_alpha := dxtMakeChannel(((1 shl BitCount)-1) shl OutputFormat.BitCount, False);
      Inc(OutputFormat.BitCount, BitCount);
    end;
  end else
  begin
    {  B channel }
    if rgbBlue in HasChannels then
    begin
      BitCount := HasChannelImages[rgbBlue].BitCount;
      OutputFormat.rgb_blue := dxtMakeChannel(((1 shl BitCount)-1) shl OutputFormat.BitCount, False);
      Inc(OutputFormat.BitCount, BitCount);
    end;

    {  G channel }
    if rgbGreen in HasChannels then
    begin
      BitCount := HasChannelImages[rgbGreen].BitCount;
      OutputFormat.rgb_green := dxtMakeChannel(((1 shl BitCount)-1) shl OutputFormat.BitCount, False);
      Inc(OutputFormat.BitCount, BitCount);
    end;

    {  R channel }
    if rgbRed in HasChannels then
    begin
      BitCount := HasChannelImages[rgbRed].BitCount;
      OutputFormat.rgb_red := dxtMakeChannel(((1 shl BitCount)-1) shl OutputFormat.BitCount, False);
      Inc(OutputFormat.BitCount, BitCount);
    end;

    {  Alpha channel }
    if rgbAlpha in HasChannels then
    begin
      BitCount :=  HasChannelImages[rgbAlpha].BitCount;
      OutputFormat.rgb_alpha := dxtMakeChannel(((1 shl BitCount)-1) shl OutputFormat.BitCount, False);
      Inc(OutputFormat.BitCount, BitCount);
    end;
  end;

  {  As for the number of bits only either of 1, 2, 4, 8, 16, 24, 32  }
  if OutputFormat.BitCount in [3] then
    OutputFormat.BitCount := 4
  else if OutputFormat.BitCount in [5..7] then
    OutputFormat.BitCount := 8
  else if OutputFormat.BitCount in [9..15] then
    OutputFormat.BitCount := 16
  else if OutputFormat.BitCount in [17..23] then
    OutputFormat.BitCount := 24
  else if OutputFormat.BitCount in [25..31] then
    OutputFormat.BitCount := 32;

  {  Transparent color  }
  if (OutputFormat.ImageType=DXTextureImageType_RGBColor) and (OutputFormat.TransparentColor shr 24=$01) then
  begin
    OutputFormat.TransparentColor := RGB(OutputFormat.idx_palette[Byte(OutputFormat.TransparentColor)].peRed,
      OutputFormat.idx_palette[Byte(OutputFormat.TransparentColor)].peGreen,
      OutputFormat.idx_palette[Byte(OutputFormat.TransparentColor)].peBlue);
  end;
end;

procedure DXTextureImageResize(Image: TDXTextureImage; Width, Height: Integer;
  const ResizeFilter: TResizeFilterInfo);
//var
//  Image2: TDXTextureImage;
//  x, y: Integer;
//  c: DWORD;
begin
  if (Image.Width=Width) and (Image.Height=Height) then Exit;
  {supplement for image resizing}
  raise Exception.Create('Invalid image size for texture.');
//  Image2 := nil;
//  try
//    if (Image.ImageType<>DXTextureImageType_RGBColor) or (Image.rgb_red.Mask<>$FF0000) or
//      (Image.rgb_green.Mask<>$00FF00) or (Image.rgb_blue.Mask<>$0000FF) then
//    begin
//      {  RGB conversion  }
//      Image2 := TDXTextureImage.Create;
//      Image2.SetSize(DXTextureImageType_RGBColor, Image.Width, Image.Height, 24, 0);
//
//      Image2.rgb_red := dxtMakeChannel($FF0000, False);
//      Image2.rgb_green := dxtMakeChannel($00FF00, False);
//      Image2.rgb_blue := dxtMakeChannel($0000FF, False);
//      Image2.rgb_alpha := dxtMakeChannel(0, False);
//
//      for y:=0 to Image.Height-1 do
//        for x:=0 to Image.Width-1 do
//        begin
//          if Image.ImageType=DXTextureImageType_PaletteIndexedColor then
//          begin
//            c := dxtDecodeChannel(Image.idx_index, Image.Pixels[x, y]);
//            Image2.Pixels[x, y] := (Image.idx_palette[c].peRed shl 16) or
//              (Image.idx_palette[c].peGreen shl 8) or
//              Image.idx_palette[c].peBlue;
//          end else
//          begin
//            c := Image.Pixels[x, y];
//            Image2.Pixels[x, y] := (dxtDecodeChannel(Image.rgb_red, c) shl 16) or
//              (dxtDecodeChannel(Image.rgb_green, c) shl 8) or
//              dxtDecodeChannel(Image.rgb_blue, c);
//          end;
//        end;
//    end else
//    begin
//      Image2 := TDXTextureImage.Create;
//      Image2.Assign(Image);
//    end;
//
//    {  Resize  }
//    Image.SetSize(DXTextureImageType_RGBColor, Width, Height, 24, 0);
//
//    Image.rgb_red := dxtMakeChannel($FF0000, False);
//    Image.rgb_green := dxtMakeChannel($00FF00, False);
//    Image.rgb_blue := dxtMakeChannel($0000FF, False);
//    Image.rgb_alpha := dxtMakeChannel(0, False);
//
////    ResizeImage1.Width := Image.Width;
////    ResizeImage1.Height := Image.Height;
////    ResizeImage1.PBits := Image.TopPBits;
////    ResizeImage1.Pitch := Image.NextLine;
//
////    ResizeImage2.Width := Image2.Width;
////    ResizeImage2.Height := Image2.Height;
////    ResizeImage2.PBits := Image2.TopPBits;
////    ResizeImage2.Pitch := Image2.NextLine;
//    //doplnit assign( image )
//    ResizeImage1.Effect_Resample(Width,Height, ResizeFilter);
////    ImageResize(ResizeImage1, ResizeImage2, ResizeFilter, ResizeFilter);
//  finally
//    Image2.Free;
//  end;
end;

procedure BuildImage(Image: TDXTextureImage);
type
  TOutputImageChannelInfo2 = record
    Image: TDXTextureImage;
    Channels: TOutputImageChannels;
  end;
var
  cR, cG, cB: Byte;

  function GetChannelVal(const Channel: TDXTextureImageChannel; SrcChannel: TOutputImageChannel): DWORD;
  begin
    case SrcChannel of
      rgbRed  : Result := dxtEncodeChannel(Channel, cR);
      rgbGreen: Result := dxtEncodeChannel(Channel, cG);
      rgbBlue : Result := dxtEncodeChannel(Channel, cB);
      yuvY    : Result := dxtEncodeChannel(Channel, (cR*306+cG*602+cB*116) div 1024);
    else        Result := 0;
    end;
  end;

var
  HasImageChannelList: array[0..Ord(High(TOutputImageChannel))+1] of TOutputImageChannelInfo2;
  HasImageChannelListCount: Integer;
  x, y, i: Integer;
  c, c2, c3: DWORD;
  Channel: TOutputImageChannel;
  Flag: Boolean;

  SrcImage: TDXTextureImage;
  UseChannels: TOutputImageChannels;
begin
  HasImageChannelListCount := 0;
  for Channel:=Low(Channel) to High(Channel) do
    if Channel in HasChannels then
    begin
      Flag := False;
      for i:=0 to HasImageChannelListCount-1 do
        if HasImageChannelList[i].Image=HasChannelImages[Channel].Image then
        begin
          HasImageChannelList[i].Channels := HasImageChannelList[i].Channels + [Channel];
          Flag := True;
          Break;
        end;
      if not Flag then
      begin                                                    
        HasImageChannelList[HasImageChannelListCount].Image := HasChannelImages[Channel].Image;
        HasImageChannelList[HasImageChannelListCount].Channels := [Channel];
        Inc(HasImageChannelListCount);
      end;
    end;

  cR := 0;
  cG := 0;
  cB := 0;

  if Image.ImageType=DXTextureImageType_PaletteIndexedColor then
  begin
    {  Index color  }
    for y:=0 to Image.Height-1 do
      for x:=0 to Image.Width-1 do
      begin
        c := 0;

        for i:=0 to HasImageChannelListCount-1 do
        begin
          SrcImage := HasImageChannelList[i].Image;
          UseChannels := HasImageChannelList[i].Channels;

          case SrcImage.ImageType of
            DXTextureImageType_PaletteIndexedColor:
              begin
                c2 := SrcImage.Pixels[x, y];
                c3 := dxtDecodeChannel(SrcImage.idx_index, c2);

                if rgbRed in UseChannels then
                  c := c or dxtEncodeChannel(Image.idx_index, c3);

                cR := SrcImage.idx_palette[c3].peRed;
                cG := SrcImage.idx_palette[c3].peGreen;
                cB := SrcImage.idx_palette[c3].peBlue;
              end;
            DXTextureImageType_RGBColor:
              begin
                c2 := SrcImage.Pixels[x, y];

                cR := dxtDecodeChannel(SrcImage.rgb_red, c2);
                cG := dxtDecodeChannel(SrcImage.rgb_green, c2);
                cB := dxtDecodeChannel(SrcImage.rgb_blue, c2);
              end;
          end;
                             
          if rgbAlpha in UseChannels then
            c := c or GetChannelVal(Image.idx_alpha, ChannelChangeTable[rgbAlpha]);
        end;

        Image.Pixels[x, y] := c;
      end;
  end else
  if Image.ImageType=DXTextureImageType_RGBColor then
  begin
    {  RGB color  }
    for y:=0 to Image.Height-1 do
      for x:=0 to Image.Width-1 do
      begin
        c := 0;

        for i:=0 to HasImageChannelListCount-1 do
        begin
          SrcImage := HasImageChannelList[i].Image;
          UseChannels := HasImageChannelList[i].Channels;

          case SrcImage.ImageType of
            DXTextureImageType_PaletteIndexedColor:
              begin
                c2 := SrcImage.Pixels[x, y];
                c3 := dxtDecodeChannel(SrcImage.idx_index, c2);
                
                cR := SrcImage.idx_palette[c3].peRed;
                cG := SrcImage.idx_palette[c3].peGreen;
                cB := SrcImage.idx_palette[c3].peBlue;
              end;
            DXTextureImageType_RGBColor:
              begin
                c2 := SrcImage.Pixels[x, y];

                cR := dxtDecodeChannel(SrcImage.rgb_red, c2);
                cG := dxtDecodeChannel(SrcImage.rgb_green, c2);
                cB := dxtDecodeChannel(SrcImage.rgb_blue, c2);
              end;
          end;

          if rgbRed in UseChannels then
            c := c or GetChannelVal(Image.rgb_red, ChannelChangeTable[rgbRed]);
          if rgbGreen in UseChannels then
            c := c or GetChannelVal(Image.rgb_green, ChannelChangeTable[rgbGreen]);
          if rgbBlue in UseChannels then
            c := c or GetChannelVal(Image.rgb_Blue, ChannelChangeTable[rgbBlue]);
          if rgbAlpha in UseChannels then
            c := c or GetChannelVal(Image.rgb_alpha, ChannelChangeTable[rgbAlpha]);
        end;

        Image.Pixels[x, y] := c;
      end;
  end;
end;

type
  TSaveProgress = class
  public
    procedure DoProgress(Sender: TObject; Progress, ProgressCount: Integer);
  end;

procedure TSaveProgress.DoProgress(Sender: TObject; Progress, ProgressCount: Integer);
const
  ProgressTime: DWORD = 0;
begin
   if (Abs(GetTickCount-ProgressTime)>100) or (Progress=ProgressCount) then
   begin
     ProgressTime := GetTickCount;
     Write(#13, Format('In progress... %d%%', [Progress*100 div ProgressCount]));
   end;
end;

const
  DXTextureImageTypeText: array[TDXTextureImageType] of string =
    ('index color', 'RGB color');

  CompressTypeText: array[TDXTextureImageFileCompressType] of string =
    ('None', 'ZLIB');
var
  i, j: Integer;
  Image, SubImage: TDXTextureImage;
  CurWidth, CurHeight: Integer;
  Channel: TOutputImageChannel;
begin
  Writeln;

  try
    HasImageList := TList.Create;
    try
      FilLChar(OutputFormat, SizeOf(OutputFormat), 0);
      OutputFormat.Compress := DXTextureImageFileCompressType_None;

      for Channel:=Low(Channel) to High(Channel) do
        ChannelChangeTable[Channel] := Channel;
      ChannelChangeTable[rgbAlpha] := yuvY;

      {  Input file processing  }
      ProcessImageParam;

      if HasImageList.Count=0 then
        raise Exception.Create('No image found');

      {  Output format calculation  }
      CalcOutputBitFormat;

      {  Image information indication  }
      Writeln(Format('[%dx%d pixels %d bit %s]', [OutputFormat.Width, OutputFormat.Height, OutputFormat.BitCount, DXTextureImageTypeText[OutputFormat.ImageType]]));

      if OutputFormat.ImageType=DXTextureImageType_PaletteIndexedColor then
      begin
        if OutputFormat.idx_index.mask<>0 then
          Writeln(Format('  Index channel=%.8x %dbit', [OutputFormat.idx_index.mask, OutputFormat.idx_index.BitCount]));
        if OutputFormat.idx_alpha.mask<>0 then
          Writeln(Format('  Alpha channel=%.8x %dbit', [OutputFormat.idx_alpha.mask, OutputFormat.idx_alpha.BitCount]));
      end else
      begin
        if OutputFormat.rgb_red.mask<>0 then
          Writeln(Format('  Red channel=%.8x %dbit', [OutputFormat.rgb_red.mask, OutputFormat.rgb_red.BitCount]));
        if OutputFormat.rgb_green.mask<>0 then
          Writeln(Format('  Green channel=%.8x %dbit', [OutputFormat.rgb_green.mask, OutputFormat.rgb_green.BitCount]));
        if OutputFormat.rgb_blue.mask<>0 then
          Writeln(Format('  Blue channel=%.8x %dbit', [OutputFormat.rgb_blue.mask, OutputFormat.rgb_blue.BitCount]));
        if OutputFormat.rgb_alpha.mask<>0 then
          Writeln(Format('  Alpha channel=%.8x %dbit', [OutputFormat.rgb_alpha.mask, OutputFormat.rgb_alpha.BitCount]));
      end;

      if OutputFormat.Name<>'' then
        Writeln(Format('  Name=%s', [OutputFormat.Name]));

      if OutputFormat.MipmapCount>0 then
        Writeln(Format('  Mipmap count=%d', [OutputFormat.MipmapCount]));

      if OutputFormat.Transparent then
      begin
        if OutputFormat.TransparentColor shr 24=$01 then
          Writeln(Format('  Transparent color=#%d', [Byte(OutputFormat.TransparentColor)]))
        else
          Writeln(Format('  Transparent color=$%.2x%.2x%.2x', [GetRValue(OutputFormat.TransparentColor), GetGValue(OutputFormat.TransparentColor), GetBValue(OutputFormat.TransparentColor)]));
      end;

      Writeln(Format('  Compress=%s', [CompressTypeText[OutputFormat.Compress]]));

      {  Resize  }
      Write('Images...');
      for i:=0 to HasImageList.Count-1 do
      begin
        DXTextureImageResize(HasImageList[i], OutputFormat.Width, OutputFormat.Height, ResizeFilterInfo_Triangle);
        Write('.');
      end;

      {  Connection  }
      Image := TDXTextureImage.Create;
      try
        Image.SetSize(OutputFormat.ImageType, OutputFormat.Width, OutputFormat.Height, OutputFormat.BitCount, 0);

        Image.idx_index := OutputFormat.idx_index;
        Image.idx_alpha := OutputFormat.idx_alpha;
        Image.idx_palette := OutputFormat.idx_palette;

        Image.rgb_red := OutputFormat.rgb_red;
        Image.rgb_green := OutputFormat.rgb_green;
        Image.rgb_blue := OutputFormat.rgb_blue;
        Image.rgb_alpha := OutputFormat.rgb_alpha;

        Image.ImageName := OutputFormat.Name;

        Image.Transparent := OutputFormat.Transparent;
        if OutputFormat.TransparentColor shr 24=$01 then
          Image.TransparentColor := dxtEncodeChannel(Image.idx_index, PaletteIndex(Byte(OutputFormat.TransparentColor)))
        else
          Image.TransparentColor := Image.EncodeColor(GetRValue(OutputFormat.TransparentColor), GetGValue(OutputFormat.TransparentColor), GetBValue(OutputFormat.TransparentColor), 0);

        BuildImage(Image);

        if OutputFormat.ImageType=DXTextureImageType_RGBColor then
        begin
          BuildImage(Image);
          Write('.');

          (*  Picture information store here  *)
          CurWidth := OutputFormat.Width;
          CurHeight := OutputFormat.Height;
          for i:=0 to OutputFormat.MipmapCount-1 do
          begin
            CurWidth := CurWidth div 2;
            CurHeight := CurHeight div 2;
            if (CurWidth<=0) or (CurHeight<=0) then Break;

            for j:=0 to HasImageList.Count-1 do
              DXTextureImageResize(HasImageList[j], CurWidth, CurHeight, ResizeFilterInfo_Box);

            SubImage := TDXTextureImage.CreateSub(Image);
            SubImage.SetSize(OutputFormat.ImageType, CurWidth, CurHeight, OutputFormat.BitCount, 0);

            SubImage.idx_index := OutputFormat.idx_index;
            SubImage.idx_alpha := OutputFormat.idx_alpha;
            SubImage.idx_palette := OutputFormat.idx_palette;

            SubImage.rgb_red := OutputFormat.rgb_red;
            SubImage.rgb_green := OutputFormat.rgb_green;
            SubImage.rgb_blue := OutputFormat.rgb_blue;
            SubImage.rgb_alpha := OutputFormat.rgb_alpha;

            SubImage.ImageGroupType := DXTextureImageGroupType_Normal;
            SubImage.ImageID := i;
            SubImage.ImageName := Format('%s - mimap #%d', [Image.ImageName, i+1]);

            BuildImage(SubImage);

            Write('.');
          end;
        end;
        Writeln;

        {  Saving  }
        Image.FileCompressType := OutputFormat.Compress;
        Image.OnSaveProgress := TSaveProgress(nil).DoProgress;

        Image.SaveToFile(ParamStr(1));
        Writeln;
      finally
        Image.Free;
      end;
    finally
      for i:=0 to HasImageList.Count-1 do
        TDXTextureImage(HasImageList[i]).Free;
      HasImageList.Free;
    end;
  except
    on E: Exception do
      begin
        Writeln(E.Message);
      end;
  end;
end.
