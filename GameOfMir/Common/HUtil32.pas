unit HUtil32;

//============================================
// Latest Update date : 1998 1
// Add/Update Function and procedure :
// 		CaptureString
//       Str_PCopy          	(4/29)
//			Str_PCopyEx			 	(5/2)
//			memset					(6/3)
//       SpliteBitmap         (9/3)
//       ArrestString         (10/27)  {name changed}
//       IsStringNumber       (98'1/1)
//			GetDirList				(98'12/9)
//       GetFileDate          (98'12/9)
//       CatchString          (99'2/4)
//       DivString            (99'2/4)
//       DivTailString        (99'2/4)
//       SPos                 (99'2/9)
//============================================


interface

uses
	Classes, Math, SysUtils, StrUtils, WinTypes, WinProcs, Graphics, Messages, Dialogs;

type
	Str4096 = array [0..4096] of char;
   Str256 = array [0..256] of char;
   TyNameTable = record
   	Name: string;
      varl:	Longint;
   end;

   TLRect = record
   	Left, Top, Right, Bottom: Longint;
   end;

const
	MAXDEFCOLOR			= 16;
	ColorNames: array [1..MAXDEFCOLOR] of TyNameTable = (
   	(Name: 'BLACK'; 		varl: clBlack),
      (Name: 'BROWN';		varl: clMaroon),
      (Name: 'MARGENTA';	varl: clFuchsia),
      (Name: 'GREEN';		varl: clGreen),
      (Name: 'LTGREEN';		varl: clOlive),
      (Name: 'BLUE';			varl: clNavy),
      (Name: 'LTBLUE';		varl: clBlue),
      (Name: 'PURPLE';		varl: clPurple),
      (Name: 'CYAN';			varl: clTeal),
      (Name: 'LTCYAN';		varl: clAqua),
      (Name: 'GRAY';			varl: clGray),
      (Name: 'LTGRAY';		varl: clsilver),
      (Name: 'YELLOW';		varl: clYellow),
      (Name: 'LIME';			varl: clLime),
      (Name: 'WHITE';		varl: clWhite),
      (Name: 'RED';			varl: clRed)
   );

   MAXLISTMARKER    = 3;
   LiMarkerNames: array [1..MAXLISTMARKER] of TyNameTable = (
   	(Name: 'DISC';			varl: 0),
      (Name: 'CIRCLE';		varl: 1),
      (Name: 'SQUARE';		varl: 2)
   );

   MAXPREDEFINE    = 3;
   PreDefineNames: array [1..MAXPREDEFINE] of TyNameTable = (
   	(Name: 'LEFT';			varl: 0),
      (Name: 'RIGHT';		varl: 1),
      (Name: 'CENTER';		varl: 2)
   );




function CountGarbage (paper: TCanvas; Src: PChar; TargWidth: Longint): integer; {garbage}
{[ArrestString]
      Result = Remain string,
      RsltStr = captured string
}
function  ArrestString (Source, SearchAfter, ArrestBefore: string;
					  const DropTags: array of string; var RsltStr: string): string;
{*}
function  ArrestStringEx (Source, SearchAfter, ArrestBefore: string; var ArrestStr: string): string;
function  CaptureString (source: string; var rdstr: string): string;
procedure ClearWindow (aCanvas: TCanvas; aLeft, aTop, aRight, aBottom:Longint; aColor: TColor);
function  CombineDirFile (SrcDir, TargName: string): string;
function  TagCount(source: string; tag: char): integer;
{*}
function  CompareLStr (src, targ: string; compn: integer): Boolean;
function  CompareBackLStr (src, targ: string; compn: integer): Boolean;
function  CompareBuffer (p1, p2: PByte; len: integer): Boolean;
function  CreateMask (Src: PChar; TargPos: Integer): string;
procedure DrawTileImage (Canv: TCanvas; Rect: TRect; TileImage: TBitmap);
procedure DrawingGhost (Rc: TRect);
function  ExtractFileNameOnly (const fname: string): string;
function  FloatToString (F: Real): string;
function  FloatToStrFixFmt (fVal: Double; prec, digit: Integer): string;
function  FileSize (const FName: string): Longint;
{*}
function  FileCopy(source,dest: String): Boolean;
function  FileCopyEx(source,dest: String): Boolean;
function  GetSpaceCount (Str: string): Longint;
function  RemoveSpace (str: string): string;
function  GetFirstWord (Str: string; var sWord: string; var FrontSpace: Longint): string;
function  GetDefColorByName (Str: string): TColor;
function  GetULMarkerType (Str: string): Longint;
{*}
function  GetValidStr3 (Str: string; var Dest: string; const Divider: array of Char): string;
function  GetValidStr4 (Str: string; var Dest: string; const Divider: array of Char): string;
function  GetValidStrVal (Str: string; var Dest: string; const Divider: array of Char): string;
function  GetValidStrCap (Str: string; var Dest: string; const Divider: array of Char): string;
function  GetStrToCoords (Str: string): TRect;
function  GetDefines (Str: string): Longint;
function  GetValueFromMask (Src: PChar; Mask: string): string;
procedure GetDirList (path: string; fllist: TStringList);
function  GetFileDate (filename: string): integer; //DOS format file date..
function  HexToIntEx (shap_str: string): Longint;
function  HexToInt( str: string ): LongInt;
function  IntToStr2(n: integer): string;
function  IntToStrFill (num, len: integer; fill: char): string;
function  IsInB (Src: string; Pos: integer; Targ: string): Boolean;
function  IsInRect (X, Y: integer; Rect: TRect): Boolean;
function  IsEnglish (Ch: Char): Boolean;
function  IsEngNumeric (Ch: Char): Boolean;
function  IsEnglishStr (sEngStr:String): Boolean;
function  IsFloatNumeric (str: string): Boolean;
function  IsUniformStr (src: string; ch: char): Boolean;
function  IsStringNumber (str: string): boolean;
function  KillFirstSpace (var Str: string): Longint;
procedure KillGabageSpace (var Str: string);
function  LRect (l, t, r, b: Longint): TLRect;
procedure MemPCopy (Dest: PChar; Src: string);
procedure MemCpy (Dest, Src: PChar; Count: Longint);                {PChar type}
procedure memcpy2 (TargAddr, SrcAddr: Longint; count: integer);     {Longint type}
procedure memset (buffer: PChar; fillchar: char; count: integer);
procedure PCharSet (P: PChar; n: integer; ch: char);
function  ReplaceChar (src: string; srcchr, repchr: char): string;
function  Str_ToDate (str: string): TDateTime;
function  Str_ToTime (str: string): TDateTime;
function  Str_ToInt (Str: string; def: Longint): Longint;
function  Str_ToFloat (str: string): Real;
function  SkipStr (Src: string; const Skips: array of char): string;
procedure ShlStr (Source: PChar; count: integer);
procedure ShrStr (Source: PChar; count: integer);
procedure Str256PCopy (Dest: PChar; const Src: string);
function  _StrPas (dest: PChar): string;
function  Str_PCopy (dest: PChar; src: string): integer;
function  Str_PCopyEx (dest: PChar; const src: string; buflen: longint): integer;
procedure SpliteBitmap (DC: HDC; X, Y: integer; bitmap: TBitmap; transcolor: TColor);
procedure TiledImage (Canv: TCanvas; Rect: TLRect; TileImage: TBitmap);
function  Trim_R (const str: string): string;
function  IsEqualFont (SrcFont, TarFont: TFont): Boolean;
function  CutHalfCode (Str: string): string;
function  ConvertToShortName(Canvas : TCanvas; Source : string; WantWidth : integer) : string;
{*}
function  CatchString (source: string; cap: char; var catched: string): string;
function  DivString (source: string; cap: char; var sel: string): string;
function  DivTailString (source: string; cap: char; var sel: string): string;
function  SPos (substr, str: string): integer;
function  NumCopy (str: string): integer;
function  GetMonDay: string;
function  GetDayCount(MaxDate,MinDate:TDateTime):Integer;
function  BoolToStr(boo: Boolean): string;
function  BoolToIntStr(b:Boolean):string;
function  BoolToCStr(b:Boolean):String;

function _MIN (n1, n2: integer): integer;
function _MAX (n1, n2: integer): integer;

procedure CenterDialog(hParentWnd, hWnd: HWnd);
function  IsIPaddr(IP: string):boolean;

function  CalcFileCRC(FileName:String):Integer;
function  CalcBufferCRC(Buffer:PChar;nSize:Integer):Integer;

//Damian - These 2 functions are same, so use either
function  GetCodeMsgSize(X: Double):Integer;
function  UpInt(i:double):integer;

implementation

//var
//	CSUtilLock: TRTLCriticalSection;

{ capture "double quote streams" }

function  CaptureString (source: string; var rdstr: string): string;
var
	st, et, c, len, i: integer;
begin
   if source = '' then begin
   	rdstr := ''; Result := '';
      exit;
   end;
	c := 1;
   //et := 0;
   len := Length (source);
	while source[c] = ' ' do
      if c < len then Inc (c)
      else break;

   if (source[c] = '"') and (c < len) then begin

      st := c+1;
      et := len;
    	for i:=c+1 to len do
      	if source[i] = '"' then begin
            et := i-1;
         	break;
         end;

   end else begin
   	st := c;
      et := len;
      for i:=c to len do
      	if source[i] = ' ' then begin
         	et := i-1;
            break;
         end;

   end;

   rdstr := Copy (source, st, (et-st+1));
   if len >= (et+2) then
   	Result := Copy (source, et+2, len-(et+1)) else
      Result := '';

end;


function CountUglyWhiteChar (sPtr: PChar): Longint;
var
   Cnt, Killw: Longint;
begin
   Killw := 0;
   for Cnt := (StrLen(sPtr)-1) downto 0 do begin
      if sPtr[Cnt] = ' ' then begin
         Inc (KillW);
         {sPtr[Cnt] := #0;}
      end else break;
   end;
   Result := Killw;
end;


function CountGarbage (paper: TCanvas; Src: PChar; TargWidth: Longint): integer; {garbage}
var
	gab, destWidth: integer;
begin

   gab := CountUglyWhiteChar (Src);
   destWidth := paper.TextWidth(StrPas (Src)) - gab;
   Result := TargWidth - DestWidth + (gab * paper.TextWidth(' '));

end;


function GetSpaceCount (Str: string): Longint;
var
	Cnt, Len, SpaceCount: Longint;
begin
	SpaceCount := 0;
	Len := Length (Str);
   for Cnt := 1 to Len do
     	if Str[Cnt] = ' ' then SpaceCount := SpaceCount + 1;
   Result := SpaceCount;
end;

function  RemoveSpace (str: string): string;
var
   i: integer;
begin
   Result := '';
   for i:=1 to Length(str) do
      if str[i] <> ' ' then
         Result := Result + str[i];
end;

function KillFirstSpace (var Str: string): Longint;
var
	Cnt, Len: Longint;
begin
   Result := 0;
   Len := Length (Str);
	for Cnt := 1 to Len do
   	if Str[Cnt] <> ' ' then begin
         Str := Copy (Str, Cnt, Len-Cnt+1);
         Result := Cnt-1;
         break;
      end;
end;

procedure KillGabageSpace (var Str: string);
var
	Cnt, Len: Longint;
begin
   Len := Length (Str);
	for Cnt := Len downto 1 do
   	if Str[Cnt] <> ' ' then begin
         Str := Copy (Str, 1, Cnt);
         KillFirstSpace (Str);
         break;
      end;
end;

function GetFirstWord (Str: string; var sWord: string; var FrontSpace: Longint): string;
var
   Cnt, Len, N: Longint;
   DestBuf: Str4096;
begin
   Len := Length (Str);
   if Len <= 0 then
   	Result := ''
   else begin
   	FrontSpace := 0;
      for Cnt := 1 to Len do begin
         if Str[Cnt] = ' ' then Inc (FrontSpace)
         else break;
      end;
      N := 0;
      for Cnt := Cnt to Len do begin
         if Str[Cnt] <> ' ' then
            DestBuf[N] := Str[Cnt]
         else begin
            DestBuf[N] := #0;
            sWord := StrPas (DestBuf);
            Result := Copy (Str, Cnt, Len-Cnt+1);
            exit;
         end;
         Inc (N);
      end;
      DestBuf[N] := #0;
      sWord := StrPas (DestBuf);
      Result := '';
   end;
end;

function HexToIntEx (shap_str: string): Longint;
begin
   Result := HexToInt (Copy (Shap_str, 2, Length(Shap_str)-1));
end;

function HexToInt( str: string ): LongInt;
var
   digit: Char;
   count, i: Integer;
   Cur, Val: LongInt;
begin
   Val := 0;
   count := Length(str);
   for i := 1 to count do begin
      digit := str[i];
           if (digit >= '0') and (digit <= '9') then Cur := Ord(digit) - Ord('0')
      else if (digit >= 'A') and (digit <= 'F') then Cur := Ord(digit) - Ord('A') + 10
      else if (digit >= 'a') and (digit <= 'f') then Cur := Ord(digit) - Ord('a') + 10
      else Cur := 0;
      Val := Val + (Cur shl (4*(count-i)));
   end;
   Result := Val;
//   Result := (Val and $0000FF00) or ((Val shl 16) and $00FF0000) or ((Val shr 16) and $000000FF);
end;

function Str_ToInt (Str: string; def: Longint): Longint;
begin
   Result := def;
   if Str <> '' then begin
      if ((word(Str[1]) >= word('0')) and (word(str[1]) <= word('9'))) or
         (str[1] = '+') or (str[1] = '-') then
         try
            Result := StrToInt64 (Str);
         except
         end;
   end;
end;

function Str_ToDate (Str: string): TDateTime;
begin
   if Trim(Str) = '' then Result := Date
   else
      Result := StrToDate (str);
end;

function Str_ToTime (Str: string): TDateTime;
begin
   if Trim(Str) = '' then Result := Time
   else
      Result := StrToTime (str);
end;

function Str_ToFloat (str: string): Real;
begin
   if str <> '' then
      try
         Result := StrToFloat (str);
         exit;
      except
      end;
	Result := 0;
end;

procedure DrawingGhost (Rc: TRect);
var
	DC: HDC;
begin
   DC := GetDC (0);
   DrawFocusRect (DC, Rc);
   ReleaseDC (0, DC);
end;

function  ExtractFileNameOnly (const fname: string): string;
var
   extpos: integer;
   ext, fn: string;
begin
   ext := ExtractFileExt (fname);
   fn := ExtractFileName (fname);
   if ext <> '' then begin
      extpos := pos (ext, fn);
      Result := Copy (fn, 1, extpos-1);
   end else
      Result := fn;
end;

function FloatToString (F: Real): string;
begin
	Result := FloatToStrFixFmt (F, 5, 2);
end;

function FloatToStrFixFmt (fVal: Double; prec, digit: Integer): string;
var
   cnt, dest, Len, I, j: Integer;
   fstr: string;
   Buf: array[0..255] of char;
label end_conv;
begin
   cnt := 0;  dest := 0;
   fstr := FloatToStrF ( fVal, ffGeneral, 15, 3 );
   Len  := Length (fstr);
   for i:=1 to Len do begin
      if fstr[i]='.' then begin
         Buf[dest] := '.'; Inc(dest);
         cnt := 0;
         for j:=i+1 to Len do begin
            if cnt < digit then begin
               Buf[dest] := fstr[j]; Inc(dest);
            end
            else begin
               goto end_conv;
            end;
            Inc(cnt);
         end;
         goto end_conv;
      end;
      if cnt < prec then begin
         Buf[dest] := fstr[i]; Inc(dest);
      end;
      Inc(cnt);
   end;
   end_conv:
   Buf[dest] := char(0);
   Result := strPas(Buf);
end;


function  FileSize (const FName: string): Longint;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(FName), faAnyFile, SearchRec) = 0 then
    Result := SearchRec.Size
  else Result := -1;
end;


function FileCopy(source,dest: String): Boolean;
var
  fSrc,fDst,len: Integer;
  size: Longint;
  buffer: packed array [0..2047] of Byte;
begin
  Result := False; { Assume that it WONT work }
  if source <> dest then begin
    fSrc := FileOpen(source,fmOpenRead);
    if fSrc >= 0 then begin
      size := FileSeek(fSrc,0,2);
      FileSeek(fSrc,0,0);
      fDst := FileCreate(dest);
      if fDst >= 0 then begin
        while size > 0 do begin
          len := FileRead(fSrc,buffer,sizeof(buffer));
          FileWrite(fDst,buffer,len);
          size := size - len;
        end;
        FileSetDate(fDst,FileGetDate(fSrc));
        FileClose(fDst);
        FileSetAttr(dest,FileGetAttr(source));
        Result := True;
      end;
      FileClose(fSrc);
    end;
  end;
end;

function FileCopyEX(source,dest: String): Boolean;
var
  fSrc,fDst,len: Integer;
  size: Longint;
  buffer: array [0..512000] of Byte;
begin
  Result := False; { Assume that it WONT work }
  if source <> dest then begin
    fSrc := FileOpen(source,fmOpenRead or fmShareDenyNone);
    if fSrc >= 0 then begin
      size := FileSeek(fSrc,0,2);
      FileSeek(fSrc,0,0);
      fDst := FileCreate(dest);
      if fDst >= 0 then begin
        while size > 0 do begin
          len := FileRead(fSrc,buffer,sizeof(buffer));
          FileWrite(fDst,buffer,len);
          size := size - len;
        end;
        FileSetDate(fDst,FileGetDate(fSrc));
        FileClose(fDst);
        FileSetAttr(dest,FileGetAttr(source));
        Result := True;
      end;
      FileClose(fSrc);
    end;
  end;
end;


function GetDefColorByName (Str: string): TColor;
var
	Cnt: Integer;
   COmpStr: string;
begin
	compStr := UpperCase (str);
	for Cnt := 1 to MAXDEFCOLOR do begin
   	if CompStr = ColorNames[Cnt].Name then begin
      	Result := TColor (ColorNames[Cnt].varl);
         exit;
      end;
   end;
   result := $0;
end;

function GetULMarkerType (Str: string): Longint;
var
	Cnt: Integer;
   COmpStr: string;
begin
	compStr := UpperCase (str);
	for Cnt := 1 to MAXLISTMARKER do begin
   	if CompStr = LiMarkerNames[Cnt].Name then begin
      	Result := LiMarkerNames[Cnt].varl;
         exit;
      end;
   end;
   result := 1;
end;

function GetDefines (Str: string): Longint;
var
	Cnt: Integer;
   COmpStr: string;
begin
	compStr := UpperCase (str);
	for Cnt := 1 to MAXPREDEFINE do begin
   	if CompStr = PreDefineNames[Cnt].Name then begin
      	Result := PreDefineNames[Cnt].varl;
         exit;
      end;
   end;
   result := -1;
end;

procedure ClearWindow (aCanvas: TCanvas; aLeft, aTop, aRight, aBottom:Longint; aColor: TColor);
begin
   with aCanvas do begin
      Brush.Color := aColor;
      Pen.Color 	:= aColor;
   	Rectangle (0, 0, aRight-aLeft, aBottom-aTop);
   end;
end;


procedure DrawTileImage (Canv: TCanvas; Rect: TRect; TileImage: TBitmap);
var
   I, J, ICnt, JCnt, BmWidth, BmHeight: Integer;
begin

   BmWidth  := TileImage.Width;
   BmHeight := TileImage.Height;
   ICnt 		:= ((Rect.Right-Rect.Left) + BmWidth - 1) div BmWidth;
   JCnt 		:= ((Rect.Bottom-Rect.Top) + BmHeight - 1) div BmHeight;

   UnrealizeObject (Canv.Handle);
   SelectPalette (Canv.Handle, TileImage.Palette, FALSE);
   RealizePalette (Canv.Handle);

   for J:=0 to JCnt do begin
      for I:=0 to ICnt do begin

        { if (I * BmWidth) < (Rect.Right-Rect.Left) then
          	BmWidth := TileImage.Width else
            BmWidth := (Rect.Right - Rect.Left) - ((I-1) * BmWidth);

         if (
         BmWidth := TileImage.Width;
         BmHeight := TileImage.Height;  }

         BitBlt (Canv.Handle,
                 Rect.Left + I * BmWidth,
                 Rect.Top + (J * BmHeight),
                 BmWidth,
                 BmHeight,
                 TileImage.Canvas.Handle,
                 0,
                 0,
                 SRCCOPY);

      end;
   end;

end;


procedure TiledImage (Canv: TCanvas; Rect: TLRect; TileImage: TBitmap);
var
   I, J, ICnt, JCnt, BmWidth, BmHeight: Integer;
   Rleft, RTop, RWidth, RHeight, BLeft, BTop: longint;
begin

	if Assigned (TileImage) then
   	if TileImage.Handle <> 0 then begin

         BmWidth  := TileImage.Width;
         BmHeight := TileImage.Height;
         ICnt 		:= (Rect.Right + BmWidth - 1) div BmWidth  -  (Rect.Left div BmWidth);
         JCnt 		:= (Rect.Bottom + BmHeight - 1) div BmHeight -  (Rect.Top div BmHeight);

         UnrealizeObject (Canv.Handle);
         SelectPalette (Canv.Handle, TileImage.Palette, FALSE);
         RealizePalette (Canv.Handle);

         for J:=0 to JCnt do begin
            for I:=0 to ICnt do begin

               if I = 0 then begin
                  BLeft := Rect.Left - ((Rect.Left div BmWidth) * BmWidth);
                  RLeft := Rect.Left;
                  RWidth := BmWidth;
               end else begin
                  if I = ICnt then
                     RWidth := Rect.Right - ((Rect.Right div BmWidth) * BmWidth) else
                     RWidth := BmWidth;
                  BLeft := 0;
                  RLeft := (Rect.Left div BmWidth) + (I * BmWidth);
               end;


               if J = 0 then begin
                  BTop := Rect.Top - ((Rect.Top div BmHeight) * BmHeight);
                  RTop := Rect.Top;
                  RHeight := BmHeight;
               end else begin
                  if J = JCnt then
                     RHeight := Rect.Bottom - ((Rect.Bottom div BmHeight) * BmHeight) else
                     RHeight := BmHeight;
                  BTop := 0;
                  RTop := (Rect.Top div BmHeight) + (J * BmHeight);
               end;

               BitBlt (Canv.Handle,
                       RLeft,
                       RTop,
                       RWidth,
                       RHeight,
                       TileImage.Canvas.Handle,
                       BLeft,
                       BTop,
                       SRCCOPY);

            end;
         end;

   	end;
end;


function GetValidStr3 (Str: string; var Dest: string; const Divider: array of Char): string;
const
   BUF_SIZE = 20480; //$7FFF;
var
	Buf: array[0..BUF_SIZE] of char;
   BufCount, Count, SrcLen, I, ArrCount: Longint;
   Ch: char;
label
	CATCH_DIV;
begin
  Ch:=#0;//Jacky
   try
      SrcLen := Length(Str);
      BufCount := 0;
      Count := 1;

      if SrcLen >= BUF_SIZE-1 then begin
         Result := '';
         Dest := '';
         exit;
      end;

      if Str = '' then begin
         Dest := '';
         Result := Str;
         exit;
      end;
      ArrCount := sizeof(Divider) div sizeof(char);

      while TRUE do begin
         if Count <= SrcLen then begin
            Ch := Str[Count];
            for I:=0 to ArrCount- 1 do
               if Ch = Divider[I] then
                  goto CATCH_DIV;
         end;
         if (Count > SrcLen) then begin
            CATCH_DIV:
            if (BufCount > 0) then begin
               if BufCount < BUF_SIZE-1 then begin
                  Buf[BufCount] := #0;
                  Dest := string (Buf);
                  Result := Copy (Str, Count+1, SrcLen-Count);
               end;
               break;
            end else begin
               if (Count > SrcLen) then begin
                  Dest := '';
                  Result := Copy (Str, Count+2, SrcLen-1);
                  break;
               end;
            end;
         end else begin
            if BufCount < BUF_SIZE-1 then begin
               Buf[BufCount] := Ch;
               Inc (BufCount);
            end;// else
               //ShowMessage ('BUF_SIZE overflow !');
         end;
         Inc (Count);
      end;
   except
      Dest := '';
      Result := '';
   end;
end;


// 구분문자가 나머지(Result)에 포함 된다.
function GetValidStr4 (Str: string; var Dest: string; const Divider: array of Char): string;
const
   BUF_SIZE = 18200; //$7FFF;
var
	Buf: array[0..BUF_SIZE] of char;
   BufCount, Count, SrcLen, I, ArrCount: Longint;
   Ch: char;
label
	CATCH_DIV;
begin
  Ch:=#0;//Jacky
	try
   	//EnterCriticalSection (CSUtilLock);
      SrcLen := Length(Str);
      BufCount := 0;
      Count := 1;

      if Str = '' then begin
         Dest := '';
         Result := Str;
         exit;
      end;
      ArrCount := sizeof(Divider) div sizeof(char);

      while TRUE do begin
         if Count <= SrcLen then begin
            Ch := Str[Count];
            for I:=0 to ArrCount- 1 do
               if Ch = Divider[I] then
                  goto CATCH_DIV;
         end;
         if (Count > SrcLen) then begin
            CATCH_DIV:
            if (BufCount > 0) or (Ch <> ' ') then begin
               if BufCount <= 0 then begin
                  Buf[0] := Ch; Buf[1] := #0; Ch := ' ';
               end else
                  Buf[BufCount] := #0;
               Dest := string (Buf);
               if Ch <> ' ' then
                  Result := Copy (Str, Count, SrcLen-Count+1)        //remain divider in rest-string,
               else Result := Copy (Str, Count+1, SrcLen-Count);   //exclude whitespace
               break;
            end else begin
               if (Count > SrcLen) then begin
                  Dest := '';
                  Result := Copy (Str, Count+2, SrcLen-1);
                  break;
               end;
            end;
         end else begin
            if BufCount < BUF_SIZE-1 then begin
               Buf[BufCount] := Ch;
               Inc (BufCount);
            end else
               ShowMessage ('BUF_SIZE overflow !');     
         end;
         Inc (Count);
      end;
	finally
      //LeaveCriticalSection (CSUtilLock);
	end;      
end;


function GetValidStrVal (Str: string; var Dest: string; const Divider: array of Char): string;
//숫자를 분리해냄 ex) 12.30mV
const
	BUF_SIZE = 15600;
var
	Buf: array[0..BUF_SIZE] of char;
   BufCount, Count, SrcLen, I, ArrCount: Longint;
   Ch: char;
   currentNumeric: Boolean;
   hexmode: Boolean;
label
	CATCH_DIV;
begin
  Ch:=#0;//Jacky
	try
   	//EnterCriticalSection (CSUtilLock);
      hexmode := FALSE;
      SrcLen := Length(Str);
      BufCount := 0;
      Count := 1;
      currentNumeric := FALSE;

      if Str = '' then begin
         Dest := '';
         Result := Str;
         exit;
      end;
      ArrCount := sizeof(Divider) div sizeof(char);

      while TRUE do begin
         if Count <= SrcLen then begin
            Ch := Str[Count];
            for I:=0 to ArrCount- 1 do
               if Ch = Divider[I] then
                  goto CATCH_DIV;
         end;
         if not currentNumeric then begin
            if (Count+1) < SrcLen then begin
               if (Str[Count] = '0') and (UpCase(Str[Count+1]) = 'X') then begin
                  Buf[BufCount] := Str[Count];
                  Buf[BufCount+1] := Str[Count+1];
                  Inc (BufCount, 2);
                  Inc (Count, 2);
                  hexmode := TRUE;
                  currentNumeric := TRUE;
                  continue;
               end;
               if (Ch = '-') and (Str[Count+1] >= '0') and (Str[Count+1] <= '9') then begin
                  currentNumeric := TRUE;
               end;
            end;
            if (Ch >= '0') and (Ch <= '9') then begin
               currentNumeric := TRUE;
            end;
         end else begin
            if hexmode then begin
               if not (((Ch >= '0') and (Ch <= '9')) or
                       ((Ch >= 'A') and (Ch <= 'F')) or
                       ((Ch >= 'a') and (Ch <= 'f'))) then begin
                     Dec (Count);
                     goto CATCH_DIV;
               end;
            end else
               if ((Ch < '0') or (Ch > '9')) and (Ch <> '.') then begin
                  Dec (Count);
                  goto CATCH_DIV;
               end;
         end;
         if (Count > SrcLen) then begin
            CATCH_DIV:
            if (BufCount > 0) then begin
               Buf[BufCount] := #0;
               Dest := string (Buf);
               Result := Copy (Str, Count+1, SrcLen-Count);
               break;
            end else begin
               if (Count > SrcLen) then begin
                  Dest := '';
                  Result := Copy (Str, Count+2, SrcLen-1);
                  break;
               end;
            end;
         end else begin
            if BufCount < BUF_SIZE-1 then begin
               Buf[BufCount] := Ch;
               Inc (BufCount);
            end else
               ShowMessage ('BUF_SIZE overflow !');
         end;
         Inc (Count);
      end;
	finally
   	//LeaveCriticalSection (CSUtilLock);
	end;
end;

{" " capture => CaptureString (source: string; var rdstr: string): string;
 ** 처음에 " 는 항상 맨 처음에 있다고 가정
}
function GetValidStrCap (Str: string; var Dest: string; const Divider: array of Char): string;
begin
   str := TrimLeft (str);
   if str <> '' then begin
      if str[1] = '"' then
         Result := CaptureString (str, dest)
      else begin
         Result := GetValidStr3 (str, dest, divider);
      end;
   end else begin
      Result := '';
      Dest := '';
   end;
end;
function IntToStr2(n: integer): string;
begin
  if n < 10 then Result := '0' + IntToStr(n)
  else Result := IntToStr(n);
end;

function  IntToStrFill (num, len: integer; fill: char): string;
var
	i: integer;
   str: string;
begin
	Result := '';
   str := IntToStr (num);
   for i:=1 to len - Length(str) do
    	Result := Result + fill;
   Result := Result + str;
end;

function IsInB (Src: string; Pos: integer; Targ: string): Boolean;
var
   TLen, I: Integer;
begin
   Result := FALSE;
   TLen := Length (Targ);
   if Length(Src) < Pos + TLen then exit;
   for I:=0 to TLen-1 do
      if UpCase(Src [Pos+I]) <> UpCase(Targ [I+1]) then exit;

   Result := TRUE;
end;

function  IsInRect (X, Y: integer; Rect: TRect): Boolean;
begin
	if (X >= Rect.Left) and (X <= Rect.Right) and (Y >= Rect.Top) and (Y <= Rect.Bottom) then
   	Result := TRUE else
      Result := FALSE;
end;

function IsStringNumber (str: string): boolean;
var i: integer;
begin
   Result := TRUE;
   for i:=1 to Length(str) do
      if (byte(str[i]) < byte('0')) or (byte(str[i]) > byte('9')) then begin
         Result := FALSE;
         break;
      end;
end;


{Return : remain string}

function ArrestString (Source, SearchAfter, ArrestBefore: string;
					  const DropTags: array of string; var RsltStr: string): string;
const
   BUF_SIZE = $7FFF;
var
	Buf: array [0..BUF_SIZE] of char;
   BufCount, SrcCount, SrcLen, {AfterLen, BeforeLen,} DropCount, I: integer;
   ArrestNow: Boolean;
begin
	try
      //EnterCriticalSection (CSUtilLock);
      RsltStr := ''; {result string}
      SrcLen := Length (Source);

      if SrcLen > BUF_SIZE then begin
         Result := '';
      	exit;
  		end;

      BufCount := 0;
      SrcCount := 1;
      ArrestNow := FALSE;
      DropCount := sizeof(DropTags) div sizeof(string);

      if (SearchAfter = '') then ArrestNow := TRUE;

      //GetMem (Buf, BUF_SIZE);

      while TRUE do begin
         if SrcCount > SrcLen then break;

         if not ArrestNow then begin
            if IsInB (Source, SrcCount, SearchAfter) then ArrestNow := TRUE;
         end else begin
            Buf [BufCount] := Source[SrcCount];
            if IsInB (Source, SrcCount, ArrestBefore) or (BufCount >= BUF_SIZE-2) then begin
               BufCount := BufCount - Length (ArrestBefore);
               Buf[BufCount+1] := #0;
               RsltStr := string (Buf);
               BufCount := 0;
               break;
            end;

            for I:=0 to DropCount-1 do begin
               if IsInB (Source, SrcCount, DropTags[I]) then begin
                  BufCount := BufCount - Length(DropTags[I]);
                  break;
               end;
            end;

            Inc (BufCount);
         end;
         Inc (SrcCount);
      end;

      if (ArrestNow) and (BufCount <> 0) then begin
         Buf [BufCount] := #0;
         RsltStr := string (Buf);
      end;

      Result := Copy (Source, SrcCount+1, SrcLen-SrcCount); {result is remain string}
	finally
   	//LeaveCriticalSection (CSUtilLock);
	end;
end;


function ArrestStringEx (Source, SearchAfter, ArrestBefore: string; var ArrestStr: string): string;
var
   BufCount, SrcCount, SrcLen: integer;
   GoodData, Fin: Boolean;
   i, n: integer;
begin
   ArrestStr := ''; {result string}
   if Source = '' then begin
      Result := '';
      exit;
   end;

   try
      SrcLen := Length (Source);
      GoodData := FALSE;
      if SrcLen >= 2 then
         if Source[1] = SearchAfter then begin
            Source := Copy (Source, 2, SrcLen-1);
            SrcLen := Length (Source);
            GoodData := TRUE;
         end else begin
            n := Pos (SearchAfter, Source);
            if n > 0 then begin
               Source := Copy (Source, n+1, SrcLen-(n));
               SrcLen := Length(Source);
               GoodData := TRUE;
            end;
         end;
      Fin := FALSE;
      if GoodData then begin
         n := Pos (ArrestBefore, Source);
         if n > 0 then begin
            ArrestStr := Copy (Source, 1, n-1);
            Result := Copy (Source, n+1, SrcLen-n);
         end else begin
            Result := SearchAfter + Source;
         end;
      end else begin
         for i:=1 to SrcLen do begin
            if Source[i] = SearchAfter then begin
               Result := Copy (Source, i, SrcLen-i+1);
               break;
            end;
         end;
      end;
   except
      ArrestStr := '';
      Result := '';
   end;
end;

function SkipStr (Src: string; const Skips: array of char): string;
var
	I, Len, C: integer;
   NowSkip: Boolean;
begin
	Len := Length (Src);
//   Count := sizeof(Skips) div sizeof (Char);

   for I:=1 to Len do begin
   	NowSkip := FALSE;
     	for C:=Low(Skips) to High(Skips) do
      	if Src[I] = Skips[C] then begin
         	NowSkip := TRUE;
            break;
         end;
      if not NowSkip then break;
   end;

   Result := Copy (Src, I, Len-I+1);

end;


function GetStrToCoords (Str: string): TRect;
var
	Temp: string;
begin

   Str := GetValidStr3 (Str, Temp, [',', ' ']); Result.Left   := Str_ToInt (Temp, 0);
   Str := GetValidStr3 (Str, Temp, [',', ' ']); Result.Top    := Str_ToInt (Temp, 0);
   Str := GetValidStr3 (Str, Temp, [',', ' ']); Result.Right  := Str_ToInt (Temp, 0);
          GetValidStr3 (Str, Temp, [',', ' ']); Result.Bottom := Str_ToInt (Temp, 0);

end;

function CombineDirFile (SrcDir, TargName: string): string;
begin
	if (SrcDir = '') or (TargName = '') then begin
   	Result := SrcDir + TargName;
      exit;
   end;
   if SrcDir [Length(SrcDir)] = '\' then
   	Result := SrcDir + TargName
   else Result := SrcDir + '\' + TargName;
end;

function  CompareLStr (src, targ: string; compn: integer): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   if compn <= 0 then exit;
   if Length(src) < compn then exit;
   if Length(targ) < compn then exit;
   Result := TRUE;
   for i:=1 to compn do
      if UpCase(src[i]) <> UpCase(targ[i]) then begin
         Result := FALSE;
         break;
      end;
end;

function  CompareBuffer (p1, p2: PByte; len: integer): Boolean;
var
   i: integer;
begin
   Result := TRUE;
   for i:=0 to len-1 do
      if PByte(integer(p1)+i)^ <> PByte(integer(p2)+i)^ then begin
         Result := FALSE;
         break;
      end;
end;

function  CompareBackLStr (src, targ: string; compn: integer): Boolean;
var
   i, slen, tlen: integer;
begin
   Result := FALSE;
   if compn <= 0 then exit;
   if Length(src) < compn then exit;
   if Length(targ) < compn then exit;
   slen := Length(src);
   tlen := Length(targ);
   Result := TRUE;
   for i:=0 to compn-1 do
      if UpCase(src[slen-i]) <> UpCase(targ[tlen-i]) then begin
         Result := FALSE;
         break;
      end;
end;


function IsEnglish (Ch: Char): Boolean;
begin
	Result := FALSE;
	if ((Ch >= 'A') and (Ch <= 'Z')) or ((Ch >= 'a') and (Ch <= 'z')) then
   	Result := TRUE;
end;

function IsEngNumeric (Ch: Char): Boolean;
begin
	Result := FALSE;
	if IsEnglish (Ch) or ((Ch >= '0') and (Ch <= '9')) then
    	Result := TRUE;
end;

function IsEnglishStr (sEngStr:String): Boolean;
var
  i:Integer;
begin
	Result := FALSE;

  for i:= 1 to length(sEngStr) do begin
    Result := IsEnglish(sEngStr[i]);
    if Result then break;
  end;
end;

function  IsFloatNumeric (str: string): Boolean;
begin
   if Trim(str) = '' then begin
   	Result := FALSE;
      exit;
   end;
   try
      StrToFloat (str);
      Result := TRUE;
   except
      Result := FALSE;
   end;
end;

procedure PCharSet (P: PChar; n: integer; ch: char);
var
	I: integer;
begin
	for I:=0 to n-1 do
   	(P + I)^ := ch;
end;

function ReplaceChar (src: string; srcchr, repchr: char): string;
var
	i, len: integer;
begin
	if src <> '' then begin
      len := Length (src);
      for i:=0 to len-1 do
      	if src[i] = srcchr then src[i] := repchr;
   end;
   Result := src;
end;


function IsUniformStr (src: string; ch: char): Boolean;
var
	i, len: integer;
begin
   Result := TRUE;
	if src <> '' then begin
      len := Length (src);
      for i:=0 to len-1 do
      	if src[i] = ch then begin
         	Result := FALSE;
            break;
         end;
   end;
end;


function CreateMask (Src: PChar; TargPos: Integer): string;
	function IsNumber (chr: Char): Boolean;
   begin
    	if (Chr >= '0') AND (Chr <= '9') then
      	Result := TRUE
      else Result := FALSE;
   end;
var
	intFlag, Loop: Boolean;
   Cnt, IntCnt, SrcLen: Integer;
   Ch, Ch2: Char;
begin
   intFlag 	:= FALSE;
   Loop 		:= TRUE;
   Cnt := 0;
   IntCnt := 0;
   SrcLen := StrLen (Src);

   while Loop do begin
      Ch := PChar(Longint(Src) + Cnt)^;
      Case Ch of
         #0: begin
            Result := '';
         	break;
         end;
         ' ': begin
         end;
         else begin

            if not intFlag then begin { Now Reading char }
               if IsNumber (Ch) then begin
                  intFlag := TRUE;
                  Inc (IntCnt);
               end;
            end else begin { If, now reading integer }
               if not IsNumber (Ch) then begin  { XXE+3 }
                  case UpCase(Ch) of
                     'E':
                        begin
                           if (Cnt >= 1) AND (Cnt+2 < SrcLen) then begin
                              Ch := PChar(Longint(Src) + Cnt - 1)^;
                              if IsNumber (Ch) then begin
                                 Ch  := PChar(Longint(Src) + Cnt + 1)^;
                                 Ch2 := PChar(Longint(Src) + Cnt + 2)^;
                                 if not ((Ch = '+') AND (IsNumber (Ch2))) then begin
                                    intFlag := FALSE;
                                 end;
                              end;
                           end;
                        end;
                     '+':
                        begin
                           if (Cnt >= 1) AND (Cnt+1 < SrcLen) then begin
                              Ch  := PChar(Longint(Src) + Cnt - 1)^;
                              Ch2 := PChar(Longint(Src) + Cnt + 1)^;
                              if not ((UpCase(Ch) = 'E') AND (IsNumber (Ch2))) then begin
                                 intFlag := FALSE;
                              end;
                           end;
                        end;
                     '.':
                        begin
                           if (Cnt >= 1) AND (Cnt+1 < SrcLen) then begin
                              Ch  := PChar(Longint(Src) + Cnt - 1)^;
                              Ch2 := PChar(Longint(Src) + Cnt + 1)^;
                              if not ((IsNumber(Ch)) AND (IsNumber (Ch2))) then begin
                                 intFlag := FALSE;
                              end;
                           end;
                        end;

                     else
                        intFlag := FALSE;
                  end;
               end;
         end; {end of case else}
      end; {end of Case}
      end;
    	if (IntFlag) and (Cnt >= TargPos) then begin
        	Result := '%' + Format ('%d', [IntCnt]);
         exit;
      end;
      Inc (Cnt);
   end;
end;

function GetValueFromMask (Src: PChar; Mask: string): string;
	function Positon (str: string): Integer;
   var
   	str2: string;
	begin
   	str2 := Copy (str, 2, Length(str)-1);
		Result := StrToIntDef (str2, 0);
		if Result <= 0 then Result := 1;
	end;
	function IsNumber (ch: char): Boolean;
	begin
		case ch of
			'0'..'9': Result := TRUE;
			else Result := FALSE;
		end;
	end;
var
	IntFlag, Loop, Sign: Boolean;
	Buf: Str256;
	BufCount, Pos, LocCount, TargLoc, SrcLen: Integer;
	Ch, Ch2: Char;
begin
	SrcLen := StrLen (Src);
	LocCount := 0;
   BufCount := 0;
	Pos := 0;
	IntFlag := FALSE;
	Loop := TRUE;
	Sign := FALSE;

   if Mask = '' then Mask := '%1';
	TargLoc := Positon (Mask);

	while Loop do begin
		if Pos >= SrcLen then break;
		Ch := PChar (Src + Pos)^;
		if not IntFlag then begin {now reading chars}
			if LocCount < TargLoc then begin
				if IsNumber (Ch) then begin
					IntFlag := TRUE;
					BufCount := 0;
					Inc (LocCount);
				end else begin
					if not Sign then begin {default '+'}
						if Ch = '-' then Sign := TRUE;
					end else begin
						if Ch <> ' ' then Sign := FALSE;
					end;
				end;
			end else begin
				break;
			end;
		end;
		if IntFlag then begin {now reading numbers}
			Buf[BufCount] := Ch;
			Inc (BufCount);
			if not IsNumber (Ch) then begin
				case Ch of
					'E','e':
						begin
							if (Pos >= 1) AND (Pos+2 < SrcLen) then begin
								Ch := PChar(Src + Pos - 1)^;
								if IsNumber (Ch) then begin
									Ch  := PChar(Src + Pos + 1)^;
									Ch2 := PChar(Src + Pos + 2)^;
									if not ((Ch = '+') or (Ch = '-') AND (IsNumber (Ch2))) then begin
										Dec (BufCount);
										IntFlag := FALSE;
									end;
								end;
							end;
						end;
					'+','-':
						begin
							if (Pos >= 1) AND (Pos+1 < SrcLen) then begin
								Ch  := PChar(Src + Pos - 1)^;
								Ch2 := PChar(Src + Pos + 1)^;
								if not ((UpCase(Ch) = 'E') AND (IsNumber (Ch2))) then begin
									Dec (BufCount);
									IntFlag := FALSE;
								end;
							end;
						end;
					'.':
						begin
							if (Pos >= 1) AND (Pos+1 < SrcLen) then begin
								Ch  := PChar(Src + Pos - 1)^;
								Ch2 := PChar(Src + Pos + 1)^;
								if not ((IsNumber(Ch)) AND (IsNumber (Ch2))) then begin
									Dec (BufCount);
									IntFlag := FALSE;
								end;
							end;
						end;
					else
						begin
							IntFlag := FALSE;
							Dec (BufCount);
						end;
				end;
			end;
		end;
		Inc (Pos);
	end;
	if LocCount = TargLoc then begin
		Buf[BufCount] := #0;
		if Sign then
			Result := '-' + StrPas (Buf)
		else Result := StrPas (Buf);
	end else Result := '';
end;

procedure GetDirList (path: string; fllist: TStringList);
var
	SearchRec: TSearchRec;
begin
	if FindFirst (path, faAnyFile, SearchRec) = 0 then begin
      fllist.AddObject (SearchRec.Name, TObject(SearchRec.Time));
    	while TRUE do begin
      	if FindNext (SearchRec) = 0 then begin
            fllist.AddObject (SearchRec.Name, TObject(SearchRec.Time));
         end else begin
            SysUtils.FindClose (SearchRec);
            break;
         end;
		end;
   end;
end;

function  GetFileDate (filename: string): integer; //DOS format file date..
var
	SearchRec: TSearchRec;
begin
  Result:=0;//jacky
	if FindFirst (filename, faAnyFile, SearchRec) = 0 then begin
   	Result := SearchRec.Time;
      SysUtils.FindClose (SearchRec); 
   end;
end;




procedure ShlStr (Source: PChar; count: integer);
var
	I, Len: integer;
begin
	Len := StrLen (Source);
	while (count > 0) do begin
		for I:=0 to Len-2 do
      	Source[I] := Source[I+1];
      Source [Len-1] := #0;

   	Dec (count);
   end;
end;

procedure ShrStr (Source: PChar; count: integer);
var
	I, Len: integer;
begin
	Len := StrLen (Source);
	while (count > 0) do begin
		for I:=Len-1 downto 0 do
      	Source[I+1] := Source[I];
      Source [Len+1] := #0;

   	Dec (count);
   end;
end;

function  LRect (l, t, r, b: Longint): TLRect;
begin
	Result.Left := l;
   Result.Top  := t;
   Result.Right := r;
   Result.Bottom := b;
end;

procedure MemPCopy (Dest: PChar; Src: string);
var i: integer;
begin
	for i:=0 to Length(Src)-1 do Dest[i] := Src[i+1];
end;

procedure MemCpy (Dest, Src: PChar; Count: Longint);
var
	I: Longint;
begin
	for I := 0 to Count-1 do begin
   	PChar(Longint(Dest)+I)^ := PChar(Longint(Src)+I)^;
   end;
end;

procedure memcpy2 (TargAddr, SrcAddr: Longint; count: integer);
var
	I: Integer;
begin
	for I:=0 to Count-1 do
   	PChar(TargAddr + I)^ := PChar(SrcAddr + I)^;
end;

procedure memset (buffer: PChar; fillchar: char; count: integer);
var i: integer;
begin
	for i:=0 to count-1 do
   	buffer[i] := fillchar;
end;

procedure Str256PCopy (Dest: PChar; const Src: string);
begin
	StrPLCopy (Dest, Src, 255);
end;

function _StrPas (dest: PChar): string;
var
   i: integer;
begin
   Result := '';
   for i:=0 to length(dest)-1 do
      if dest[i] <> chr(0) then
         Result := Result + dest[i]
      else
         break;
end;

function Str_PCopy (dest: PChar; src: string): integer;
var
	len, i: integer;
begin
	len := Length (src);
	for i:=1 to len do dest[i-1] := src[i];
   dest[len] := #0;
   Result := len;
end;

function Str_PCopyEx (dest: PChar; const src: string; buflen: longint): integer;
var
	len, i: integer;
begin
	len := _MIN (Length (src), buflen);
	for i:=1 to len do dest[i-1] := src[i];
   dest[len] := #0;
   Result := len;
end;

function Str_Catch (src, dest: string; len: integer): string; //Result is rests..
begin

end;

function  Trim_R (const str: string): string;
var
	I, Len, tr: integer;
begin
	tr := 0;
	Len := Length (str);
   for I:=Len downto 1 do
   	if str[I] = ' ' then Inc (tr)
      else break;
   Result := Copy (str, 1, Len - tr);
end;

function IsEqualFont (SrcFont, TarFont: TFont): Boolean;
begin
	Result := TRUE;
	if SrcFont.Name <> TarFont.Name then Result := FALSE;
   if SrcFont.Color <> TarFont.Color then Result := FALSE;
   if SrcFont.Style <> TarFont.Style then Result := FALSE;
   if SrcFont.Size <> TarFont.Size then Result := FALSE;
end;


function CutHalfCode (Str: string): string;
var
	pos, Len: integer;
begin

	Result := '';
	pos := 1;
   Len := Length (Str);

	while TRUE do begin

   	if pos > Len then break;

      if (Str[pos] > #127) then begin

      	if ((pos+1) <= Len) and (Str[pos+1] > #127) then begin
      		Result := Result + Str[pos] + Str[pos+1];
         	Inc (pos);
         end;

      end else
      	Result := Result + Str[pos];

      Inc (pos);

   end;
end;


function ConvertToShortName(Canvas : TCanvas; Source : string; WantWidth : integer) : string;
var
   I, Len: integer;
   Str: string;
begin
	if Length(Source) > 3 then
      if Canvas.TextWidth (Source) > WantWidth then begin

 			Len := Length (Source);
         for I:=1 to Len do begin

            Str := Copy (Source, 1, (Len-I));
            Str := Str + '..';

            if Canvas.TextWidth (Str) < (WantWidth-4) then begin
               Result := CutHalfCode (Str);
               exit;
            end;

         end;

         Result := CutHalfCode (Copy (Source, 1, 2)) + '..';
         exit;

      end;

   Result := Source;

end;


function DuplicateBitmap (bitmap: TBitmap): HBitmap;
var
	hbmpOldSrc, hbmpOldDest, hbmpNew : HBitmap;
   hdcSrc, hdcDest						: HDC;

begin
   hdcSrc := CreateCompatibleDC (0);
   hdcDest := CreateCompatibleDC (hdcSrc);

   hbmpOldSrc := SelectObject(hdcSrc, bitmap.Handle);

   hbmpNew := CreateCompatibleBitmap(hdcSrc, bitmap.Width, bitmap.Height);

   hbmpOldDest := SelectObject(hdcDest, hbmpNew);

   BitBlt(hdcDest, 0, 0, bitmap.Width, bitmap.Height, hdcSrc, 0, 0,
     SRCCOPY);

   SelectObject(hdcDest, hbmpOldDest);
   SelectObject(hdcSrc, hbmpOldSrc);

   DeleteDC(hdcDest);
   DeleteDC(hdcSrc);

   Result := hbmpNew;
end;


procedure SpliteBitmap (DC: HDC; X, Y: integer; bitmap: TBitmap; transcolor: TColor);
var
   hdcMixBuffer, hdcBackMask, hdcForeMask, hdcCopy 			: HDC;
   hOld, hbmCopy, hbmMixBuffer, hbmBackMask, hbmForeMask 	: HBitmap;
   oldColor: TColor;
begin

   {UnrealizeObject (DC);}
(*   SelectPalette (DC, bitmap.Palette, FALSE);
   RealizePalette (DC);
  *)

	hbmCopy := DuplicateBitmap (bitmap);
	hdcCopy := CreateCompatibleDC (DC);
   hOld := SelectObject (hdcCopy, hbmCopy);

   hdcBackMask := CreateCompatibleDC (DC);
	hdcForeMask := CreateCompatibleDC (DC);
	hdcMixBuffer:= CreateCompatibleDC (DC);

	hbmBackMask := CreateBitmap (bitmap.Width, bitmap.Height, 1, 1, nil);
	hbmForeMask := CreateBitmap (bitmap.Width, bitmap.Height, 1, 1, nil);
	hbmMixBuffer:= CreateCompatibleBitmap (DC, bitmap.Width, bitmap.Height);

   SelectObject (hdcBackMask, hbmBackMask);
	SelectObject (hdcForeMask, hbmForeMask);
	SelectObject (hdcMixBuffer, hbmMixBuffer);

	oldColor := SetBkColor (hdcCopy, transcolor); //clWhite);

	BitBlt (hdcForeMask, 0, 0, bitmap.Width, bitmap.Height, hdcCopy, 0, 0, SRCCOPY);

	SetBkColor (hdcCopy, oldColor);

	BitBlt( hdcBackMask, 0, 0, bitmap.Width, bitmap.Height, hdcForeMask, 0, 0, NOTSRCCOPY );

	BitBlt( hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, DC, X, Y, SRCCOPY );

	BitBlt( hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, hdcForeMask, 0, 0, SRCAND );

	BitBlt( hdcCopy, 0, 0, bitmap.Width, bitmap.Height, hdcBackMask, 0, 0, SRCAND );

	BitBlt( hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, hdcCopy, 0, 0, SRCPAINT );

	BitBlt( DC, X, Y, bitmap.Width, bitmap.Height, hdcMixBuffer, 0, 0, SRCCOPY );

   {DeleteObject (hbmCopy);}
   DeleteObject( SelectObject( hdcCopy, hOld ) );
	DeleteObject( SelectObject( hdcForeMask, hOld ) );
	DeleteObject( SelectObject( hdcBackMask, hOld ) );
	DeleteObject( SelectObject( hdcMixBuffer, hOld ) );

	DeleteDC( hdcCopy );
	DeleteDC( hdcForeMask );
	DeleteDC( hdcBackMask );
   DeleteDC( hdcMixBuffer );

end;

function TagCount(source: string; tag: char): integer;
var
   i, tcount: integer;
begin
   tcount := 0;
   for i:=1 to Length(source) do
      if source[i] = tag then Inc (tcount);
   Result := tcount;
end;

{ "xxxxxx" => xxxxxx }
function TakeOffTag (src: string; tag: char; var rstr: string): string;
var
   i, n2: integer;
begin
   n2 := Pos (tag, Copy (src, 2, Length(src)));
   rstr := Copy (src, 2, n2-1);
   Result := Copy (src, n2+2, length(src)-n2);
end;

function CatchString (source: string; cap: char; var catched: string): string;
var
   n: integer;
begin
   Result := '';
   catched := '';
   if source = '' then exit;
   if Length(source) < 2 then begin
      Result := source;
      exit;
   end;
   if source[1] = cap then begin
      if source[2] = cap then   //##abc#
         source := Copy (source, 2, Length(source));
      if TagCount (source, cap) >= 2 then begin
         Result := TakeOffTag (source, cap, catched);
      end else
         Result := source;
   end else begin
      if TagCount (source, cap) >= 2 then begin
         n := Pos (cap, source);
         source := Copy (source, n, Length(source));
         Result := TakeOffTag (source, cap, catched);
      end else
         Result := source;
   end;
end;

{ GetValidStr3와 달리 식별자가 연속으로 나올경우 처리 안됨 }
{ 식별자가 없을 경우, nil 리턴.. }
function DivString (source: string; cap: char; var sel: string): string;
var
   n: integer;
begin
   if source = '' then begin
      sel := '';
      Result := '';
      exit;
   end;
   n := Pos (cap, source);
   if n > 0 then begin
      sel := Copy (source, 1, n-1);
      Result := Copy (source, n+1, Length(source));
   end else begin
      sel := source;
      Result := '';
   end;
end;

function DivTailString (source: string; cap: char; var sel: string): string;
var
   i, n: integer;
begin
   if source = '' then begin
      sel := '';
      Result := '';
      exit;
   end;
   n := 0;
   for i:=Length(source) downto 1 do
      if source[i] = cap then begin
         n := i;
         break;
      end;
   if n > 0 then begin
      sel := Copy (source, n+1, Length(source));
      Result := Copy (source, 1, n-1);
   end else begin
      sel := '';
      Result := source;
   end;
end;


function SPos (substr, str: string): integer;
var
   i, j, len, slen: integer;
   flag : Boolean;
begin
   Result := -1;
   len  := Length(str);
   slen := Length(substr);
   for i:=0 to len-slen do begin
      flag := TRUE;
      for j:=1 to slen do begin
         if byte(str[i + j]) >= $B0 then begin
            if (j < slen) and (i+j < len) then begin
               if substr[j] <> str[i + j] then begin
                  flag := FALSE;
                  break;
               end;
               if substr[j+1] <> str[i + j + 1] then begin
                  flag := FALSE;
                  break;
               end;
            end else
               flag := FALSE;
         end else
            if substr[j] <> str[i + j] then begin
               flag := FALSE;
               break;
            end;
      end;
      if flag then begin
         Result := i + 1;
         break;
      end;
   end;
end;

function NumCopy (str: string): integer;
var
   i: integer;
   data: string;
begin
   data := '';
   for i:=1 to Length(str) do begin
      if (Word('0') <= Word(str[i])) and (Word('9') >= Word(str[i])) then begin
         data := data + str[i];
      end else
         break;
   end;
   Result := Str_ToInt (data, 0);
end;

function  GetMonDay: string;
var
   year, mon, day: word;
   str: string;
begin
   DecodeDate (Date, year, mon, day);
   str := IntToStr(year);
   if mon < 10 then str := str + '0' + IntToStr(mon)
   else str := IntToStr(mon);
   if day < 10 then str := str + '0' + IntToStr(day)
   else str := IntToStr(day);
   Result := str;
end;

function  BoolToStr(boo: Boolean): string;
begin
   if boo then Result := 'TRUE'
   else Result := 'FALSE';
end;

function _MIN (n1, n2: integer): integer;
begin
	if n1 < n2 then Result := n1
   else Result := n2;
end;

function _MAX (n1, n2: integer): integer;
begin
	if n1 > n2 then Result := n1
   else Result := n2;
end;


procedure CenterDialog(hParentWnd, hWnd: HWnd);
var
  rcMainWnd, rcDlg: TRect;
begin
	GetWindowRect(hParentWnd, rcMainWnd);
	GetWindowRect(hWnd, rcDlg);
	
	MoveWindow(hWnd, rcMainWnd.left + (((rcMainWnd.right - rcMainWnd.left) - (rcDlg.right - rcDlg.left)) div 2),
				rcMainWnd.top + (((rcMainWnd.bottom - rcMainWnd.top) - (rcDlg.bottom - rcDlg.top)) div 2), 
				(rcDlg.right - rcDlg.left), (rcDlg.bottom - rcDlg.top), FALSE);
end;


function IsIPaddr(IP: string):boolean;
var
  Node:array [0..3] of integer;
  tIP:String;
  tNode:String;
  tPos:Integer;
  tLen:Integer;
begin
 Result:=False;
 tIP:=IP;
 tLen:=Length(tIP);
 tPos:=Pos('.',tIP);
 tNode:=MidStr(tIP,1,tPos -1);
 tIP:=MidStr(tIP,tPos +1 ,tLen - tPos);
 if not TryStrToInt(tNode,Node[0]) then exit;

 tLen:=Length(tIP);
 tPos:=Pos('.',tIP);
 tNode:=MidStr(tIP,1,tPos -1);
 tIP:=MidStr(tIP,tPos +1 ,tLen - tPos);
 if not TryStrToInt(tNode,Node[1]) then exit;

 tLen:=Length(tIP);
 tPos:=Pos('.',tIP);
 tNode:=MidStr(tIP,1,tPos -1);
 tIP:=MidStr(tIP,tPos +1 ,tLen - tPos);
 if not TryStrToInt(tNode,Node[2]) then exit;

 if not TryStrToInt(tIP,Node[3]) then exit;
 for tLen:=Low(Node) to High(Node) do begin
   if(Node[tLen] < 0) or (Node[tLen] > 255) then exit;
 end;
 Result:=True;
end;

function BoolToCStr(b:Boolean):String;
begin
  if b then result:='角' else result:='뤠';
end;

function BoolToIntStr(b:Boolean):string;
begin
  if b then result:='1' else result:='0';
end;


function CalcFileCRC(FileName:String):Integer;
var
  I: Integer;
  nFileHandle:Integer;
  nFileSize,nBuffSize:Integer;
  Buffer:PChar;
  Int:^Integer;
  nCrc:Integer;
begin
  Result:=0;
  if not FileExists(FileName) then begin
    exit;
  end;
  nFileHandle:=FileOpen(FileName,fmOpenRead or fmShareDenyNone);
  if nFileHandle = 0 then exit;
  nFileSize:=FileSeek(nFileHandle,0,2);
  nBuffSize:=(nFileSize div 4) * 4;
  GetMem(Buffer,nBuffSize);
  FillChar(Buffer^,nBuffSize,0);
  FileSeek(nFileHandle,0,0);
  FileRead(nFileHandle,Buffer^,nBuffSize);
  FileClose(nFileHandle);
  Int:=Pointer(Buffer);
  nCrc:=0;
    Exception.Create(IntToStr(SizeOf(Integer)));  
  for I := 0 to nBuffSize div 4 - 1 do begin
    nCrc:=nCrc xor Int^;
    Int:=Pointer(Integer(Int) + 4);
  end;
  FreeMem(Buffer);
  Result:=nCrc;
end;

function CalcBufferCRC(Buffer:PChar;nSize:Integer):Integer;
var
  I:Integer;
  Int:^Integer;
  nCrc:Integer;
begin
  Int:=Pointer(Buffer);
  nCrc:=0;
  for I := 0 to nSize div 4 - 1 do begin
    nCrc:=nCrc xor Int^;
    Int:=Pointer(Integer(Int) + 4);
  end;
  Result:=nCrc;
end;

function GetDayCount(MaxDate,MinDate:TDateTime):Integer;
var
  YearMax, MonthMax, DayMax: Word;
  YearMin, MonthMin, DayMin: Word;
begin
  Result:=0;
  if MaxDate < MinDate then exit;
  DecodeDate(MaxDate, YearMax, MonthMax, DayMax);
  DecodeDate(MinDate, YearMin, MonthMin, DayMin);
  Dec(YearMax,YearMin);
  YearMin:=0;
  Result:=(YearMax * 12 * 30 + MonthMax * 30 + DayMax) - (YearMin * 12 * 30 + MonthMin * 30 + DayMin);
end;

function GetCodeMsgSize(X: Double):Integer;
begin
  if INT(X) < X then Result:=TRUNC(X) + 1
  else Result:=TRUNC(X)
end;

function UpInt(i:double):integer;
begin
  result:=Ceil(i);
end;



end.
