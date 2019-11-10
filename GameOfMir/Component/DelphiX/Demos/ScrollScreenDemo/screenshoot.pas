unit screenshoot;

//  Unit ScreenShoot for Elephant Eye Engine
//  Copyright by Coders Group '2000
//  Code: Sulek       sulek@shnet.pl
//  http://coders.shnet.pl/klub/
//  wanna join ? ==>> sulek@shnet.pl
//  Last changes: 25.09.2000
//  Please leave information about the author even if you change something



interface

uses DXDraws, Graphics, JPEG, SysUtils;

type
  TScreenShoot = class
    constructor Create(ADir: string; Anumber: word; AExt: string);
    procedure Make(Ekran: TDXDraw);
    private
      number: word;
      Dir: string;
      Ext: string;
      function NoFiles: word;
  end;

implementation

{ TScreenShoot }

constructor TScreenShoot.Create(ADir: string; Anumber: word; AExt: string);
var
  SR: TSearchRec;

begin
  inherited Create;
  Dir:= ADir;
  if Dir[Length(Dir)] <> '\' then
    Dir:= Dir + '\';
  {$I-}
  MkDir(Dir);
  {$I+}
  Ext:= AExt;
  number:= ANumber;
end;

procedure TScreenShoot.Make(Ekran: TDXDraw);
var
  B: TBitmap;
  JPG: TJPEGImage;
  x, y: integer;
begin
  number:= NoFiles;
  try
    B:= TBitmap.Create;
    B.Width:= Ekran.SurfaceWidth;
    B.height:= Ekran.SurfaceHeight;
    for x:= 0 to B.Width do
      for y:= 0 to B.Height do
        B.Canvas.Pixels[x,y]:= Ekran.Surface.Canvas.Pixels[x,y];
  finally
    try
      JPG:= TJPEGImage.Create;
      JPG.Assign(B);
      JPG.SaveToFile(dir + IntToStr(number) + Ext);
    finally
      JPG.Free;
    end;
    B.Free;
  end;
end;

function TScreenShoot.NoFiles: word;
var
  SR: TSearchRec;
  SearchResult: integer;
  count: word;
begin
  count:= 0;
  SearchResult:= FindFirst(Dir + '*' + Ext, faAnyFile, SR);
  if SearchResult = 0 then
    while SearchResult = 0 do
    begin
      inc(count);
      SearchResult:= FindNext(SR);
    end;

  FindClose(sr);
  Result:= count;
end;

end.
