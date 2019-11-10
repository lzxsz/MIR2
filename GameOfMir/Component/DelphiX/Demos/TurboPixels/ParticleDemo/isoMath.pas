unit isoMath;

// *****************************************
// *  isoMath - 256 cycle trig functions   *
// *  and vector equations that are        *
// *  useful in isometric perspective      *
// *  games.  All functions are skewed     *
// *  to reflect a 2:1 orthoginal          *
// *  perspective. (c)1999 Michael Wilson  *
// *****************************************

interface


const

  isoPi = 3.14159; //                    (192)
  isoNorth = 192; // screen up            n        Clock-wise
  isoSouth = 64; // screen down   (128) w + e (0)   rotation
  isoWest = 128; // screen left           s
  isoEast = 0; // screen right          (64)

type
  isoPolar = record
    a {ngle}: integer; // 256 cycle angle [0..255] is more than enough
    v {elocity}: single; // pixel movements as small as 0.00000001
  end;

  isoVector = record
    x, y: single; // pixel movements as small as 0.00000001
  end;

function isoSin(a {ngle}: integer): single;
function isoCos(a {ngle}: integer): single;
// function isoArcTanAsm(Y, X: extended): extended;
function normArcTan(dy, dx: single): byte;
function normArcTan256(dy, dx: single): byte;
function isoArcTan(dy, dx: single): byte;
function normFindAngle(x, y, x1, y1: integer): byte;
function isoFindAngle(x, y, x1, y1: integer): byte;
function isoIsLeft(a {ngle}, t {est}: byte): boolean;
function isoNormAngle(angle: integer): byte;
function isoDistance(x, y, x1, y1: integer): integer;
function isoPointInQuad(x0, y0, x1, y1, x2, y2, x3, y3, x, y: integer): boolean;

implementation

function isoSin(a {ngle}: integer): single; // integer allows for negative angles
begin
  result := sin(((a and 255) / 256) * 2 * isoPi) / 2 // one-half of the y vector
end; {function}

function isoCos(a {ngle}: integer): single;
begin
  result := cos(((a and 255) / 256) * 2 * isoPi)
end; {function}

{function isoArcTanAsm(Y, X: extended): extended;
asm
  FLD    Y
  FLD    X
  FPATAN
  FWAIT
end;}

function normArcTan(dy, dx: single): byte;
begin
  result := abs(round(ArcTan(dy / dx) * (128 / isoPi))); // one-half of the y vector
end; {function}

function normArcTan256(dy, dx: single): byte;
begin
  if (dx = 0) then
    begin {check special cases}
      if (dy > 0) then
        result := 64
      else
        result := 192;
      exit;
    end; {special cases}

  if (dx < 0) and (dy > 0) then { 2nd quad }
    result := 128 - normarctan(dy, dx)
  else
    if (dx < 0) and (dy <= 0) then { 3rd quad }
      result := 128 + normarctan(dy, dx)
    else
      if (dx > 0) and (dy < 0) then { 4th quad }
        result := 256 - normarctan(dy, dx)
      else { 1st quad }
        result := normarctan(dy, dx)
end; {function}

function isoArcTan(dy, dx: single): byte;
begin
  result := abs(round(ArcTan((dy / 2) / dx) * (128 / isoPi))); // one-half of the y vector
end; {function}

function normFindAngle(x, y, x1, y1: integer): byte;
var
  dx, dy: integer;
begin
  dx := (x - x1); {get dx dy}
  dy := (y - y1);

  if (dx = 0) then
    begin {check special cases}
      if (dy > 0) then
        result := 64
      else
        result := 192;
      exit;
    end; {special cases}

  if (dx < 0) and (dy > 0) then { 2nd quad }
    result := 128 - normarctan(dy, dx)
  else
    if (dx < 0) and (dy <= 0) then { 3rd quad }
      result := 128 + normarctan(dy, dx)
    else
      if (dx > 0) and (dy < 0) then { 4th quad }
        result := 256 - normarctan(dy, dx)
      else { 1st quad }
        result := normarctan(dy, dx)
end; {function}

function isoFindAngle(x, y, x1, y1: integer): byte;
var
  dx, dy: integer;
begin
  dx := (x - x1); {get dx dy}
  dy := (y - y1);

  if (dx = 0) then
    begin {check special cases}
      if (dy > 0) then
        result := 64
      else
        result := 192;
      exit;
    end; {special cases}

  if (dx < 0) and (dy > 0) then { 2nd quad }
    result := 128 - isoarctan(dy, dx)
  else
    if (dx < 0) and (dy <= 0) then { 3rd quad }
      result := 128 + isoarctan(dy, dx)
    else
      if (dx > 0) and (dy < 0) then { 4th quad }
        result := 256 - isoarctan(dy, dx)
      else { 1st quad }
        result := isoarctan(dy, dx)
end; {function}

function isoIsLeft(a {ngle}, t {est}: byte): boolean;
var loop: integer; // loop
begin
  loop:=0;
  repeat
    inc(loop)
  until (isonormangle(a + loop) = t) or (isonormangle(a - loop) = t);
  if (isonormangle(a - loop) = t) then result := true
  else
    result := false;
end;

function isoNormAngle(angle: integer): byte;
begin
  result := angle and 255;
end; {function}

function isoDistance(x, y, x1, y1: integer): integer;
begin
  result := round(sqrt((x - x1) * (x - x1) + ((y - y1) * 2) * ((y - y1) * 2)));
end; {function}

function isoPointInQuad(x0, y0, x1, y1, x2, y2, x3, y3, x, y: integer): boolean;
begin
  result := false;
  if ((y0 - y1) * (x - x1) + (x1 - x0) * (y - y1) > -1) and
    ((y1 - y2) * (x - x2) + (x2 - x1) * (y - y2) > -1) and
    ((y2 - y3) * (x - x3) + (x3 - x2) * (y - y3) > -1) and
    ((y3 - y0) * (x - x0) + (x0 - x3) * (y - y0) > -1) then
    result := true;
  if ((y0 - y1) * (x - x1) + (x1 - x0) * (y - y1) < 1) and
    ((y1 - y2) * (x - x2) + (x2 - x1) * (y - y2) < 1) and
    ((y2 - y3) * (x - x3) + (x3 - x2) * (y - y3) < 1) and
    ((y3 - y0) * (x - x0) + (x0 - x3) * (y - y0) < 1) then
    result := true;
end; { function }

end.

