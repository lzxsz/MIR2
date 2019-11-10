unit dxscroll;

//  TDXScroll unit (addone for DelphiX)
//  Copyright by Pawel Sulkowski '2000
//  http://coders.shnet.pl/klub/
//  Code: Sulek       sulek@shnet.pl
//  Last changes 29.12.2000
//  Please leave information about the author even if you change something


interface

uses
  DXDraws, Graphics;

type
  TItemsType = (itText, itBitmap);

  TItems = record
      Kind: TItemsType;
      Text: string;
      BitmapPath: string;
  end;

  TDXScroll = class
    X, Y: integer;
    constructor Create(var AScreen: TDXDraw; AFontSize: byte; AX, AY: integer);
    procedure AddText(AText: string);
    procedure AddBitmap(PathToBitmap: string);
    procedure Scroll(DX, DY: integer);
    procedure Warp(sensitivity: integer; frequency: integer);
    procedure Draw;
    function LoadTextFromFile(FileName: string): boolean;
  private
    FontHeight: byte;
    Screen: TDXDraw;
    Items: array of TItems;
    bitmapsHeights: integer;
  end;

implementation

uses gfx;
  /////////////////
 ///  TDXScroll //
/////////////////

procedure TDXScroll.AddBitmap(PathToBitmap: string);
begin
  SetLength(Items, Length(Items) + 1);
  Items[High(Items)].Kind:= itBitmap;
  Items[High(Items)].BitmapPath:= PathToBitmap;
end;

procedure TDXScroll.AddText(AText: string);
begin
  SetLength(Items, Length(Items) + 1);
  Items[High(Items)].Kind:= itText;
  Items[High(Items)].Text:= AText;;
end;

constructor TDXScroll.Create(var AScreen: TDXDraw; AFontSize: byte; AX, AY: integer);
begin
  Screen:=  AScreen;
  FontHeight:= Round(AFontSize*1.5);
  X:= AX;
  Y:= AY;
  SetText(Screen, bsClear, clWhite, AFontSize);
end;

procedure TDXScroll.Draw;
var
  i: integer;
  B: TBitmap;
begin
  bitmapsHeights:= 0;
  for i:= 0 to High(Items) do
  begin
    if Items[i].Kind = itText then
      PutText(Screen, X, Y+i*FontHeight+bitmapsHeights, Items[i].Text)
    else
    begin
      B:= TBitmap.Create;
      B.LoadFromFile(Items[i].BitmapPath);
      Screen.Surface.Canvas.Draw(X, Y+i*FontHeight+bitmapsHeights, B);
      Inc(bitmapsHeights, B.Height);
      B.Free;
    end;
  end;
end;

function TDXScroll.LoadTextFromFile(FileName: string): boolean;
var
  F: TextFile;
  line: string;
begin
  AssignFile(F, FileName);
  {$I-}
  Reset(F);
  {$I+}
  if IOResult = 0 then
  begin
    while not Eof(F) do
    begin
      ReadLn(F, line);
      AddText(Line);
    end;
    CloseFile(F);
    Result:= true;
  end else
    Result:= false;
end;

procedure TDXScroll.Scroll(DX, DY: integer);
begin
  Inc(X, DX);
  Inc(Y, DY);
  // checking
  if Y < - (High(Items) *FontHeight) -   bitmapsHeights then
    Y:= Screen.Height
  else
  if Y > (High(Items) *FontHeight) +   bitmapsHeights then
    Y:= 0;
end;

procedure TDXScroll.Warp(sensitivity: integer; frequency: integer);
var
  z: integer;
begin
  z:= Random(frequency)+5;
  if z=5 then
    Scroll(-sensitivity, 0)
  else if z = 6 then
    Scroll(sensitivity, 0);
end;

end.
