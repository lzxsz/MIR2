unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, DXClass, DXDraws, DIB, DirectX
  {$IfDef newPixelsDXUnit}, newPixelsDX{$EndIf};

const
  m = 2000;
  mult = 500;
  typ = 0; // ' 0-slide show, 1-...n_t - show object
  n_t = 18;

type
  TMainForm = class(TDXForm)
    DXDraw: TDXDraw;
    DXTimer: TDXTimer;
    ImageList: TDXImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
  private
    FAngle, xi, yi, cc: Integer;
    x: array of array of single;
    y: array of array of single;
    z: array of array of single;
    b: array[1..70, 1..2] of single;
    xr: array of integer;
    yr: array of integer;
    zr: array of single;
    al: array[1..3, 1..4] of single; //1..3 - xyz, 1-mode 2-durat 3-angle 4-def_angle
    z0, y0, x0, zs, ax, ay, az, xmax, ymax: single;
    flag, n, st0, st, st1, t, t1, title, help, tt: integer;
    {$IfDef newPixelsDXUnit}
    GS:TGrafixSurface;
    {$EndIf}
    procedure LoopDraw;
    procedure Recalculate;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.DXDrawInitialize(Sender: TObject);
begin
  {$IfDef newPixelsDXUnit}
  GS:=TGrafixSurface.Create(DXDraw.DDraw);
  GS.Init(DXDraw,ImageList,0,0,0);
  {$EndIf}
  DXTimer.Enabled := True;
end;

procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
  DXTimer.Enabled := False;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {  Application end  }
  if Key = VK_ESCAPE then
    Close;

  {  Screen mode change  }
  if (ssAlt in Shift) and (Key = VK_RETURN) then
  begin
    DXDraw.Finalize;
    if doFullScreen in DXDraw.Options then
    begin
      RestoreWindow;
      DXDraw.Cursor := crDefault;
      BorderStyle := bsSizeable;
      DXDraw.Options := DXDraw.Options - [doFullScreen];
    end else
    begin
      StoreWindow;
      DXDraw.Cursor := crNone;
      BorderStyle := bsNone;
      DXDraw.Options := DXDraw.Options + [doFullScreen];
    end;

    DXDraw.Initialize;
  end;
  if key = VK_SPACE then st1 := st0;
  if key = VK_F2 then title := 1 - title;
  if key = VK_F1 then help := 1 - help;
  if key = VK_F5 then flag := 0;
  if key = VK_F6 then flag := 1;
end;

procedure TMainForm.Recalculate();
var
  cX, cY, cZ, wX: single;
  i: integer;
begin

  for i := 1 to n do
  begin

    if (typ = 0) then
    begin
      cX := x[i][t] + (x[i][t1] - x[i][t]) * st / st0;
      cY := y[i][t] + (y[i][t1] - y[i][t]) * st / st0;
      cZ := z[i][t] + (z[i][t1] - z[i][t]) * st / st0;
    end
    else begin
      cX := x[i][typ];
      cY := y[i][typ];
      cZ := z[i][typ];
    end;
    wX := cX * cos(ax) - cY * sin(ax);
    cY := cX * sin(ax) + cY * cos(ax);
    cX := wX;

    wX := cX * cos(ay) - cZ * sin(ay);
    cZ := cX * sin(ay) + cZ * cos(ay);
    cX := wX;

    wX := cZ * cos(az) - cY * sin(az);
    cY := cZ * sin(az) + cY * cos(az);
    cZ := wX;

    xr[i] := round((zs) * (cX - x0) / (cZ - z0) * mult + xmax / 2);
    yr[i] := round(ymax / 2 - (zs) * (cY - y0) / (cZ - z0) * mult);
    zr[i] := cZ - z0 - zs * 2;
  end;

  ax := ax + al[1, 3];
  ay := ay + al[2, 3];
  az := az + al[3, 3];
//alfa
  for i := 1 to 3 do
  begin
    if al[i, 1] = 1 then
    begin
      if (al[i, 4] - al[i, 3]) < 0 then al[i, 3] := al[i, 3] - 0.0001 else al[i, 3] := al[i, 3] + 0.00001;
      if abs(al[i, 3] - al[i, 4]) < 0.0002 then
      begin
        al[i, 1] := 2;
        al[i, 2] := random(100) + 100;
        al[i, 4] := random(100) / 5000; //-0.5;
      end;
    end;
    if al[i, 1] = 2 then
    begin
      al[i, 2] := al[i, 2] - 1;
      if al[i, 2] = 0 then al[i, 1] := 1;
    end;
  end;

  if (st < st0) then st := st + 1
  else if (st1 < st0) then
    st1 := st1 + 1
  else
  begin
    t := t1; t1 := round(random(n_t + 1)); st := 0;
    st1 := 0;
  end;
end;

procedure TMainForm.LoopDraw;
  procedure body;
  var
    a: single;
    i, j, l: integer;
  begin
    for i := 1 to 60 do
    begin
      l := round(abs(b[i][1]) * abs(b[i][1]) * 5 + 1);
      a := 0;
      for j := 1 to l do
      begin
        a := a + 6.28 / l;
        x[n][t] := b[i][1] * cos(a);
        y[n][t] := b[i][2];
        z[n][t] := b[i][1] * sin(a);
        if (n < m) then n := n + 1;
      end;
    end;
  end;
  procedure pset_line(x1: real; y1: real; x2: real; y2: real; stt: integer; mm: real);
  var
    k: integer;
  begin
    for k := 0 to stt do
    begin
      x[n][t] := (x1 + (x2 - x1) * k / stt) * mm;
      y[n][t] := (y1 + (y2 - y1) * k / stt) * mm;
      z[n][t] := 0;
      n := n + 1; if n > m then exit;
    end;
  end;
var
  i, j, mm: integer;
  a: real;
begin
//xmax:= dxdraw.Width ;
//ymax:= dxdraw.Height;
  SetLength(xr, m + 1);
  setlength(yr, m + 1);
  setlength(zr, m + 1);

  SetLength(x, m + 1);
  SetLength(y, m + 1);
  SetLength(z, m + 1);
  for I := Low(x) to High(x) do
  begin
    SetLength(x[I], n_t + 1);
    SetLength(y[I], n_t + 1);
    SetLength(z[I], n_t + 1);
  end;

  xmax := 800;
  ymax := 600;
  randomize;
  n := 1; t := 0; t1 := 0;
  x0 := 1; y0 := 0; z0 := -25;
  zs := 2;
  ax := 0; ay := 0; az := 0;
  st0 := 200;
  st := 0;
  for i := 1 to 3 do al[i, 1] := 1;
//''''''''''''''''''''''''''''''''''''''''eshik
  t := 1;
  n := 1;
  for i := -50 to 50 do //i+=0.15)
  begin
    x[n][t] := i / 10; y[n][t] := i / 10; z[n][t] := i / 10;
    n := n + 1;
    x[n][t] := i / 10; y[n][t] := i / 10; z[n][t] := -i / 10;
    n := n + 1;
    x[n][t] := i / 10; y[n][t] := -i / 10; z[n][t] := i / 10;
    n := n + 1;
    x[n][t] := i / 10; y[n][t] := -i / 10; z[n][t] := -i / 10;
    n := n + 1;
    x[n][t] := 0; y[n][t] := 0; z[n][t] := i / 10;
    n := n + 1;
    x[n][t] := 0; y[n][t] := i / 10; z[n][t] := 0;
    n := n + 1;
    x[n][t] := i / 10; y[n][t] := 0; z[n][t] := 0;
    n := n + 1;
  end;

//'''''''''''''''''''''''''''''''''''''''stars
  t := 2;
  for i := 1 to m do
  begin
    x[i][t] := round(random(20)) - 10;
    y[i][t] := round(random(20)) - 10;
    z[i][t] := round(random(20)) - 10;
  end;

  t := 3;
  n := 1;
  for i := -50 to 50 do
  begin
    x[n, t] := i / 10; y[n, t] := -5; z[n, t] := 5;
    n := n + 1;
    x[n, t] := i / 10; y[n, t] := -5; z[n, t] := -5;
    n := n + 1;
    x[n, t] := i / 10; y[n, t] := 5; z[n, t] := 5;
    n := n + 1;
    x[n, t] := i / 10; y[n, t] := 5; z[n, t] := -5;
    n := n + 1;
    x[n, t] := 5; y[n, t] := i / 10; z[n, t] := 5;
    n := n + 1;
    x[n, t] := 5; y[n, t] := i / 10; z[n, t] := -5;
    n := n + 1;
    x[n, t] := -5; y[n, t] := i / 10; z[n, t] := 5;
    n := n + 1;
    x[n, t] := -5; y[n, t] := i / 10; z[n, t] := -5;
    n := n + 1;
    x[n, t] := 5; y[n, t] := 5; z[n, t] := i / 10;
    n := n + 1;
    x[n, t] := -5; y[n, t] := 5; z[n, t] := i / 10;
    n := n + 1;
    x[n, t] := 5; y[n, t] := -5; z[n, t] := i / 10;
    n := n + 1;
    x[n, t] := -5; y[n, t] := -5; z[n, t] := i / 10;
    n := n + 1;
  end;
//'''''''''''''''''''''''''''''''''''''''''penta
  n := 1;
  t := 4;
  for i := 0 to 8 - 1 do for j := 0 to 8 do pset_line(Cos(i * 6.28 / 8), Sin(i * 6.28 / 8), Cos(j * 6.28 / 8), Sin(j * 6.28 / 8), 25, 5);

//'''''''''''''''''''''''''''''''''''''''''
  n := 1;
  t := 6;
  for i := 0 to 100 do
  begin
    x[n, t] := i / 10 - 5; y[n, t] := -5; z[n, t] := -5;
    n := n + 1;
    x[n, t] := i / 10 - 5; y[n, t] := -5; z[n, t] := 5;
    n := n + 1;
    x[n, t] := 5; y[n, t] := -5; z[n, t] := i / 10 - 5;
    n := n + 1;
    x[n, t] := -5; y[n, t] := -5; z[n, t] := i / 10 - 5;
    n := n + 1;
    x[n, t] := 5 - i / 10 / 2; y[n, t] := i / 10 - 5; z[n, t] := i / 10 / 2 - 5;
    n := n + 1;
    x[n, t] := -5 + i / 20; y[n, t] := i / 10 - 5; z[n, t] := i / 20 - 5;
    n := n + 1;
    x[n, t] := -5 + i / 20; y[n, t] := i / 10 - 5; z[n, t] := -i / 20 + 5;
    n := n + 1;
    x[n, t] := 5 - i / 20; y[n, t] := i / 10 - 5; z[n, t] := -i / 20 + 5;
    n := n + 1;
  end;
//''''''''''''''''''''''''''''''''''''''''''''
  n := 1;
  t := 7;
  mm := 2;
  pset_line(-5, -2, -5, 2, 200, mm); // 'n
  pset_line(-5, 2, -1, -2, 200, mm);
  pset_line(-1, -2, -1, 2, 200, mm);
  pset_line(0, -2, 0, 2, 200, mm); //'i
  pset_line(1, -2, 1, 2, 200, mm); //'c
  pset_line(1, -2, 4, -2, 200, mm); //'c
  pset_line(1, 2, 4, 2, 200, mm); //'c
//'''''''''''''''''''''''''''''''''''''''''''''''
  n := 1;
  t := 8;
  for j := -9 to 9 do
    for i := 0 to 100 do
    begin
      x[n, t] := Cos(i * 6.28 / 100) * Abs(j / 2);
      z[n, t] := Sin(i * 6.28 / 100) * Abs(j / 2);
      y[n, t] := j / 2;
      n := n + 1;
    end;
//'''''''''''''''''''''''''''''''''''''''''''''''
  n := 1;
  t := 9;
  for j := -9 to 9 do
    for i := 0 to 100 do
    begin
      x[n, t] := Cos(i * 6.28 / 100) * Abs(Sin((5 + j / 2) * 6.28 / 16) * 5);
      z[n, t] := Sin(i * 6.28 / 100) * Abs(Sin((5 + j / 2) * 6.28 / 18) * 5);
      y[n, t] := j / 2;
      n := n + 1;
    end;
//'''''''''''''''''''''''''''''''''''''''''''''''''''
  n := 1;
  t := 10;
  for j := -9 to 9 do
    for i := 0 to 100 do
    begin
      x[n, t] := Cos(i * 6.28 / 100) * i / 30;
      z[n, t] := Sin(i * 6.28 / 100) * i / 30;
      y[n, t] := j / 2;
      n := n + 1;
    end;
//''''''''''''''''''''''''''''''''''''''''''''''''''''
  n := 1;
  t := 11;
  for j := -9 to 9 do
    for i := 0 to 100 do
    begin
      x[n, t] := Cos(i * 6.28 / 100) * 5;
      z[n, t] := Sin(i * 6.28 / 100) * j;
      y[n, t] := Cos((j / 2 + 5) * 6.28 / 20);
      n := n + 1;
    end;
//'''''''''''''''''''''''''''''''''''''''''''''''''''''''spiral
  n := 1;
  t := 12;
  for i := 0 to 1999 do
  begin
    x[n, t] := Cos(i * 6.28 / 100) * 2;
    z[n, t] := Sin(i * 6.28 / 100) * 2;
    y[n, t] := i / 150 - 6;
    n := n + 1;
  end;
//''''''''''''''''''''''''''''''''''''''''''''''''''''''''grid
  n := 1;
  t := 13;
  for i := -8 to 8 do
    for j := -8 to 8 do
    begin
      x[n, t] := j / 2; y[n, t] := -5; z[n, t] := i / 2;
      n := n + 1;
      x[n, t] := j / 2; y[n, t] := 5; z[n, t] := i / 2;
      n := n + 1;
    end;

  for i := -8 to 8 do
    for j := -8 to 8 do
    begin
      x[n, t] := j / 2; y[n, t] := i / 2; z[n, t] := -5;
      n := n + 1;
      x[n, t] := j / 2; y[n, t] := i / 2; z[n, t] := 5;
      n := n + 1;
    end;

  for i := -8 to 8 do
    for j := -8 to 8 do
    begin
      x[n, t] := -5; y[n, t] := i / 2; z[n, t] := j / 2;
      n := n + 1;
      x[n, t] := 5; y[n, t] := i / 2; z[n, t] := j / 2;
      n := n + 1;
    end;
//'''''''''''''''''''''''''''''''''''''''''''''''''''''''
  n := 1;
  t := 14;
  for j := 20 downto 0 do
    for i := 0 to 80 do
    begin
      x[n, t] := Cos(i * 6.28 / 80) * j / 2;
      z[n, t] := Sin(i * 6.28 / 80) * j / 2;
      y[n, t] := j / 10 * Cos(j * 6.28 / 20);
      n := n + 1;
    end;
//''''''''''''''''''''''''''''''''''''''''''''''''''''' body
  n := 1;
  t := 15;
  for i := -12 to 9 do
  begin
    b[n, 1] := i / 6 + 2;
    b[n, 2] := i / 3;
    n := n + 1;
  end;
  for i := 12 downto 0 do
  begin
    b[n, 1] := i / 4;
    b[n, 2] := 3;
    n := n + 1;
  end;
  n := 1;
  body;
//''''''''''''''''''''''''''''''''''''''''''''''''''''' body
  n := 1;
  t := 16;
  a := 0;
  for i := 0 to 60 do
  begin
    a := a + 6.28 / 25;
    b[n, 1] := Cos(a) * 1 - 4;
    b[n, 2] := Sin(a) * 1;
    n := n + 1;
  end;
  n := 1;
  body;
//''''''''''''''''''''''''''''''''''''''''''''''''''''' body
  n := 1;
  t := 17;
  a := 3.14 + 1.57;
  for i := 0 to 25 do
  begin
    a := a + 3.14 / 25;
    b[n, 1] := Cos(a) * 2 - 5;
    b[n, 2] := Sin(a) * 2;
    n := n + 1;
  end;
  n := 1;
  body;
//-------------------------------------------------------

  n := 1;
  t := 18;
  a := 10;
  for i := 1 to round(a) do
  begin
    pset_line(i / a, 0, 0, (a + 1 - i) / a, 50, 8);
    pset_line(0, (a + 1 - i) / a, -i / a, 0, 50, 8);
    pset_line(-i / a, 0, 0, -(a + 1 - i) / a, 45, 8);
    pset_line(0, -(a + 1 - i) / a, i / a, 0, 45, 8);
  end;
  for i := 1 to n - 1 do
    z[i, t] := abs(x[i, t]) * abs(y[i, t]) - 2;

//''''''''''''''''''''''''''''''''''''''''''''''''''''''main cikl

  n := m; t := 0;
  t1 := round(random(n_t)) + 1;
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
var i, j: integer;
begin
  if not DXDraw.CanDraw then exit;
  Recalculate;
  DXDraw.BeginScene;
  try
    DXDraw.Surface.Fill(DXDraw.Surface.ColorMatch(clBlack));
    if title = 1 then
    begin
      ImageList.Items[cc].DrawAdd(DXDraw.Surface, Bounds(xi, yi, 300, 100), 0, Trunc(Cos256(FAngle) * 126 + 127));
      Inc(FAngle);
      if fangle > (128 + 256) then
      begin
        xi := random(500);
        yi := random(500);
        inc(cc);
        fangle := 128;
        if cc > 4 then cc := 0;
      end;
    end;
  finally
    DXDraw.EndScene;
  end;
  with DXDraw.Surface.Canvas do
  try
    if DXDraw.Surface.Lock then
    {$IfDef newPixelsDXUnit}
    if GS.Lock then
    {$EndIf}
    if flag = 0 then
      for i := 1 to n do
      begin
        if i mod 40 = tt then j := $FFFFFF
        else if i mod 80 = tt then j := $FFFF00
        else if i mod 20 = tt then j := $00FF00 else j := round(xr[i] / 4) * 256 + round(yr[i] / 3) + round(zr[i] - 15) * round(zr[i] - 15) * 65536;

        DXDraw.Surface.pixel[xr[i], yr[i]] := j;
        DXDraw.Surface.pixel[xr[i] + 1, yr[i]] := j;

        {$IfDef newPixelsDXUnit}
        GS.PutPixel(xr[i], yr[i], j);
        GS.PutPixel(xr[i] + 1, yr[i], j);
        {$EndIf}
      end;
    if flag = 1 then
      for i := 1 to n do
      begin

        DXDraw.Surface.pixel[xr[i], yr[i]] := ($FFFFFF - (round(zr[i]) - 10) * (256 + 65536 + 1) * 10);
        DXDraw.Surface.pixel[xr[i] + 1, yr[i]] := ($FFFFFF - (round(zr[i]) - 10) * (256 + 65536 + 1) * 10);

        {$IfDef newPixelsDXUnit}
        GS.PutPixel(xr[i], yr[i], ($FFFFFF - (round(zr[i]) - 10) * (256 + 65536 + 1) * 10));
        GS.PutPixel(xr[i] + 1, yr[i], ($FFFFFF - (round(zr[i]) - 10) * (256 + 65536 + 1) * 10));
        {$EndIf}
      end;
    DXDraw.Surface.UnLock;
    {$IfDef newPixelsDXUnit}
    GS.Unlock;
    {$EndIf}
    Brush.Style := bsClear;
    Font.Color := clWhite;
    Font.Size := 10;
    Textout(0, 0, 'FPS: ' + inttostr(DXTimer.FrameRate));
    if help = 1 then begin
      Textout(0, 100, 'F1-help');
      Textout(0, 120, 'F2-titles');
      Textout(0, 140, 'F5-color(default)');
      Textout(0, 160, 'F6-black&white');
      Textout(0, 180, 'SPACE-next figure');
      Textout(0, 200, 'ESQ-exit');
    end;
    inc(tt);
    if tt > 40 then tt := 0;
  finally
    Release; {  Indispensability  }
  end;
  DXDraw.Flip;
end;

procedure TMainForm.FormCreate(Sender: TObject);
const
  AA: Array [0..4] of String = (
  'Welcome in DelphiX worlds',
  'Screensaver demo',
  'DirectX application under Delphi',
  'Borland Delphi compiler used',
  'Good work in DelphiX');

  function MakeDibText(const text:String; size:Integer):TDIB;
  var DIB: TDIB;
    cW,cH:Integer;
  begin
    Result := TDIB.Create;
    DIB := TDIB.Create;
    DIB.SetSize(256,256,24);
    with DIB.Canvas do begin
      Brush.Color := clBlack;
      FillRect(Bounds(0,0,DIB.Width,DIB.Height));
      Brush.Style := bsClear;
      Font.Color := clBlue;
      Font.Name := 'Times New Roman';
      Font.Size := size;
      Font.Style := [fsBold, fsItalic];
      cW := TextWidth(text);
      cH := TextHeight(text);
      TextOut(5,5,text);
      Release;
    end;
    DIB.Free;
    Result.SetSize(10+cW,10+ch,24);
    with Result.Canvas do begin
      Brush.Color := clBlack;
      FillRect(Bounds(0,0,Result.Width,Result.Height));
      Brush.Style := bsClear;
      Font.Color := clBlue;
      Font.Name := 'Times New Roman';
      Font.Size := size;
      Font.Style := [fsBold,fsItalic];
      TextOut(5,5,text);
      Release;
    end;
    Result.Blur(24,1);
  end;
var
  i: Integer;
  DIB: TDIB;
begin
  showcursor(false);
  flag := 0;
  cc := 0;
  fangle := 128;
// -by JB
//  ImageList.Items.MakeColorTable;
//  DXDraw.ColorTable := ImageList.Items.ColorTable;
//  DXDraw.DefColorTable := ImageList.Items.ColorTable;
//  DXDraw.UpdatePalette;
//  for i := 0 to 4 do begin
//    DIB := MakeDibText(AA[i],19+Random(5));
//    try
//      ImageList.Items.Add;
//      with ImageList.Items[ImageList.Items.Count-1] do begin
//        Picture.Assign(DIB);
//        Restore;
//      end;
//    finally
//      DIB.Free;
//    end
//  end;
//  ImageList.Items.SaveToFile('c:\cccc.dxg');
  title := 1;
  mainform.Cursor := crNone;
  LoopDraw;
end;

end.

