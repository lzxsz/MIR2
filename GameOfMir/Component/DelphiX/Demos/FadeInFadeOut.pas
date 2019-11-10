//fade in, fade out

procedure DX_SYNC(var displaydriver: TDXDraw);
//put in other frame display stuff before screen flip
begin
  displaydriver.Flip;
end;


function DXColorFade(colfrom, colto: longint; var displaydriver: TDXDraw): longint;
var t, tred1, tred2, tgreen1, tgreen2, tblue1, tblue2: integer;
begin
  tred1 := dxred(colfrom);
  tred2 := dxred(colto);
  tgreen1 := dxgreen(colfrom);
  tgreen2 := dxgreen(colto);
  tblue1 := dxblue(colfrom);
  tblue2 := dxblue(colto);
  if tred1 < tred2 then
  begin
    for t := tred1 to tred2 do
    begin
      displaydriver.Surface.Fill(dxRGB(t, tgreen1, tblue1));
      dx_sync(displaydriver);

    end;
  end
  else
  begin
    for t := tred1 downto tred2 do
    begin
      displaydriver.Surface.Fill(dxRGB(t, tgreen1, tblue1));
      dx_sync(displaydriver);

    end;
  end;

  if tgreen1 < tgreen2 then
  begin
    for t := tgreen1 to tgreen2 do
    begin
      displaydriver.Surface.Fill(dxRGB(tred2, t, tblue1));
      dx_sync(displaydriver);

    end;
  end
  else
  begin
    for t := tgreen1 downto tgreen2 do
    begin
      displaydriver.Surface.Fill(dxrgb(tred2, t, tblue1));
      dx_sync(displaydriver);

    end;
  end;
  if tblue1 < tblue2 then
  begin
    for t := tblue1 to tblue2 do
    begin
      displaydriver.Surface.Fill(dxrgb(tred2, tgreen2, t));
      dx_sync(displaydriver);

    end;
  end
  else
  begin
    for t := tblue1 downto tblue2 do
    begin

      displaydriver.Surface.Fill(dxrgb(tred2, tgreen2, t));
      dx_sync(displaydriver);
    end;
  end;
  thisDXcolour := colto;
  result := colto;
end;

function DXFadeToBlack(colfrom: longint; var displaydriver: TDXDraw): longint;
var t, tred1, tgreen1, tblue1: integer;

begin
  tred1 := dxred(colfrom);
  tgreen1 := dxgreen(colfrom);
  tblue1 := dxblue(colfrom);
  for t := tred1 downto 0 do
  begin
    displaydriver.Surface.Fill(dxrgb(t, tgreen1, tblue1));
    dx_sync(displaydriver);
  end;
  for t := tgreen1 downto 0 do
  begin
    displaydriver.Surface.Fill(dxrgb(0, t, tblue1));
    dx_sync(displaydriver);
  end;
  for t := tblue1 downto 0 do
  begin
    displaydriver.Surface.Fill(dxrgb(0, 0, t));
    dx_sync(displaydriver);
  end;
  thisDXColour := 0;
  result := 0;
end;

function DXFadeToWhite(colfrom: longint; var displaydriver: TDXDraw): longint;
var t, tred1, tgreen1, tblue1: integer;
begin
  tred1 := dxred(colfrom);
  tgreen1 := dxgreen(colfrom);
  tblue1 := dxblue(colfrom);
  for t := tred1 to 255 do
  begin
    displaydriver.Surface.Fill(dxrgb(t, tgreen1, tblue1));
    dx_sync(displaydriver);
  end;
  for t := tgreen1 to 255 do
  begin
    displaydriver.Surface.Fill(dxrgb(255, t, tblue1));
    dx_sync(displaydriver);
  end;
  for t := tblue1 to 255 do
  begin
    displaydriver.Surface.Fill(dxrgb(255, 255, t));
    dx_sync(displaydriver);
  end;
  thisDXColour := DXrgb(255, 255, 255);
  result := thisDXColour;
end;

function DXGreyFade(shadefrom, shadeto: integer; var displaydriver: TDXDraw): integer;
var t: integer;
begin
  if shadefrom < shadeto then
  begin
    for t := shadefrom to shadeto do
    begin
      displaydriver.Surface.Fill(dxrgb(t, t, t));
      dx_sync(displaydriver);

    end;
  end
  else
  begin
    for t := shadefrom downto shadeto do
    begin
      displaydriver.Surface.Fill(dxrgb(t, t, t));
      dx_sync(displaydriver);

    end;
  end;
  thisDXColour := shadeto;
  result := shadeto;
end;

procedure FadeDXScreen(var displaydriver: TDXDraw; newcolour: longint);
begin
  thisDXColour := DXColorFade(thisDXColour, newcolour, displaydriver);
end;

procedure WhiteDXScreen(var displaydriver: TDXDraw);
begin
  thisDXColour := DXColorFade(thisDXColour, dxRGB(255, 255, 255), displaydriver);
end;

procedure BlackDXScreen(var displaydriver: TDXDraw);
begin
  thisDXColour := DXColorFade(thisDXColour, dxRGB(0, 0, 0), displaydriver);
end;


procedure DX_grabimage(var displaydriver: TDXDraw; x, y, width, height: integer; ddib: TDIB);
var ts, td: trect;
begin
  ddib.setsize(width, height, 24);
  ts.left := x;
  ts.top := y;
  ts.right := x + width - 1;
  ts.bottom := y + height - 1;
  td.left := 0;
  td.top := 0;
  td.right := width;
  td.bottom := height;
  with displaydriver.surface.canvas do
  begin
    ddib.canvas.CopyRect(td, displaydriver.surface.canvas, ts);
    release;
  end;
end;

procedure DXPasteImage(var displaydriver: TDXDraw; var sdib: TDIB; x, y: integer);
var
  ts, td: trect;
  w, h: integer;
begin
  w := sdib.width - 1;
  h := sdib.height - 1;
  ts.left := 0;
  ts.top := 0;
  ts.right := w;
  ts.bottom := h;
  td.left := x;
  td.top := y;
  td.right := x + w;
  td.bottom := y + h;
  with displaydriver.surface.canvas do
  begin
    CopyRect(td, sdib.canvas, ts);
    release;
  end;
end;

