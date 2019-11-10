unit GaussianBlur;

interface

uses Windows, Graphics;

type
    PRGBTriple = ^TRGBTriple;
    TRGBTriple = packed record
     b: byte; //easier to type than rgbtBlue...
     g: byte;
     r: byte;
    end;

    PRow = ^TRow;
    TRow = array[0..1000000] of TRGBTriple;

    PPRows = ^TPRows;
    TPRows = array[0..1000000] of PRow;


const MaxKernelSize = 100;

type

    TKernelSize = 1..MaxKernelSize;

    TKernel = record
     Size: TKernelSize;
     Weights: array[-MaxKernelSize..MaxKernelSize] of single;
    end;
//the idea is that when using a TKernel you ignore the Weights
//except for Weights in the range -Size..Size.

procedure GBlur(theBitmap: TBitmap; radius: double);

implementation

uses SysUtils;

procedure MakeGaussianKernel(var K: TKernel; radius: double;
                            MaxData, DataGranularity: double);
//makes K into a gaussian kernel with standard deviation = radius.
//for the current application you set MaxData = 255,
//DataGranularity = 1. Now the procedure sets the value of
//K.Size so that when we use K we will ignore the Weights
//that are so small they can't possibly matter. (Small Size
//is good because the execution time is going to be
//propertional to K.Size.)
var j: integer; temp, delta: double; KernelSize: TKernelSize;
begin
  for j:= Low(K.Weights) to High(K.Weights) do
  begin
    temp:= j/radius;
    K.Weights[j]:= exp(- temp*temp/2);
  end;

//now divide by constant so sum(Weights) = 1:

  temp:= 0;
  for j:= Low(K.Weights) to High(K.Weights) do
     temp:= temp + K.Weights[j];
  for j:= Low(K.Weights) to High(K.Weights) do
     K.Weights[j]:= K.Weights[j] / temp;


//now discard (or rather mark as ignorable by setting Size)
//the entries that are too small to matter -
//this is important, otherwise a blur with a small radius
//will take as long as with a large radius...
  KernelSize:= MaxKernelSize;
  delta:= DataGranularity / (2*MaxData);
  temp:= 0;
  while (temp < delta) and (KernelSize > 1) do
   begin
     temp:= temp + 2 * K.Weights[KernelSize];
     dec(KernelSize);
   end;

  K.Size:= KernelSize;

//now just to be correct go back and jiggle again so the
//sum of the entries we'll be using is exactly 1:

  temp:= 0;
  for j:= -K.Size to K.Size do
     temp:= temp + K.Weights[j];
  for j:= -K.Size to K.Size do
     K.Weights[j]:= K.Weights[j] / temp;

end;

function TrimInt(Lower, Upper, theInteger: integer): integer;
begin
 if (theInteger <= Upper) and (theInteger >= Lower) then
  result:= theInteger
 else
  if theInteger > Upper then
   result:= Upper
    else
     result:= Lower;
end;

function TrimReal(Lower, Upper: integer; x: double): integer;
begin
 if (x < upper) and (x >= lower) then
  result:= trunc(x)
 else
  if x > Upper then
   result:= Upper
    else
     result:= Lower;
end;

procedure BlurRow(var theRow: array of TRGBTriple; K: TKernel; P: PRow);
var j, n, LocalRow: integer; tr, tg, tb: double; //tempRed, etc
       w: double;
begin

for j:= 0 to High(theRow) do
  begin
    tb:= 0;
    tg:= 0;
    tr:= 0;
    for n:= -K.Size to K.Size do
    begin
      w:= K.Weights[n];

//the TrimInt keeps us from running off the edge of the row...
      with theRow[TrimInt(0, High(theRow), j - n)] do
      begin
        tb:= tb + w * b;
        tg:= tg + w * g;
        tr:= tr + w * r;
      end;
    end;
    with P[j] do
    begin
      b:= TrimReal(0, 255, tb);
      g:= TrimReal(0, 255, tg);
      r:= TrimReal(0, 255, tr);
    end;
  end;

Move(P[0], theRow[0], (High(theRow) + 1) * Sizeof(TRGBTriple));
end;

procedure GBlur(theBitmap: TBitmap; radius: double);
var Row, Col: integer; theRows: PPRows; K: TKernel; ACol: PRow; P:PRow;
begin
if (theBitmap.HandleType <> bmDIB) or (theBitmap.PixelFormat <> pf24Bit) then
 raise exception.Create('GBlur only works for 24-bit bitmaps');


MakeGaussianKernel(K, radius, 255, 1);
GetMem(theRows, theBitmap.Height * SizeOf(PRow));
GetMem(ACol, theBitmap.Height * SizeOf(TRGBTriple));

//record the location of the bitmap data:
for Row:= 0 to theBitmap.Height - 1 do
  theRows[Row]:= theBitmap.Scanline[Row];

//blur each row:
P:= AllocMem(theBitmap.Width*SizeOf(TRGBTriple));
for Row:= 0 to theBitmap.Height - 1 do
  BlurRow(Slice(theRows[Row]^, theBitmap.Width), K, P);

//now blur each column
ReAllocMem(P, theBitmap.Height*SizeOf(TRGBTriple));
for Col:= 0 to theBitmap.Width - 1 do
begin
//- first read the column into a TRow:
  for Row:= 0 to theBitmap.Height - 1 do
     ACol[Row]:= theRows[Row][Col];


  BlurRow(Slice(ACol^, theBitmap.Height), K, P);

//now put that row, um, column back into the data:
  for Row:= 0 to theBitmap.Height - 1 do
     theRows[Row][Col]:= ACol[Row];
end;

FreeMem(theRows);
FreeMem(ACol);
ReAllocMem(P, 0);
end;

end.
(*
------------------------------------
Should work unless some code got deleted along with irrelevant comments. For example: 
------------------------------------

procedure TForm1.Button1Click(Sender: TObject);
var b: TBitmap;
begin
  if not openDialog1.Execute then exit;

  b:= TBitmap.Create;
  b.LoadFromFile(OpenDialog1.Filename);
  b.PixelFormat:= pf24Bit;
  Canvas.Draw(0, 0, b);
  GBlur(b, StrToFloat(Edit1.text));
  Canvas.Draw(b.Width, 0, b);
  b.Free;
end;

*)