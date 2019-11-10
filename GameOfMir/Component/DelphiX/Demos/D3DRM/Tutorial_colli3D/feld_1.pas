// The content of this unit was derived from the C++ code in the book
// "The Awesome Power of Direct3D/DirectX by Peter Kovach".
// Thanks to Peter Kovach at directx.xoom.com for allowing me to include the
// translated code with this program.
//
// Henrik Fabricius, Delphi3DX, august 1999

unit feld_1;

interface

uses
  windows, math, typer3D;


procedure initgauss;


function f3(x0, x1, x2 : real): real;
function f4(x0, x1, x2, x3 : real): real;
function gauss(): real;
procedure feld(maxlevel : integer; var x: transvekt);



implementation


var
  nrand : word; //unsigned;
  delta, gaussadd, gaussfac : real;



function f3(x0, x1, x2 : real): real;
begin
  result := ((x0+x1+x2)/3+ delta * gauss());
end;



function f4(x0, x1, x2, x3: real): real;
begin
  result := ((x0+x1+x2+x3)/4 + delta * gauss());
end;


procedure initgauss;
begin
  nrand := 4;
  gaussadd := sqrt(12);
  gaussfac := 2 * gaussadd/131068;
  RandSeed := 111;  //init random number generator   Srand(111) in C++
end;


function gauss(): real;
var
  sum : real;
  i : integer;
begin

  sum := 0;

  for i := 0 to (nrand - 1) do
  sum := sum + random;  //  rand() in C++

  result := (gaussfac * sum - gaussadd);
end;



procedure feld(maxlevel : integer; var x : transvekt);
var
  addition, D, d_ny, stage : integer;
  h : real;
  max, min, d_m : real;
  i, j , k, n, xx, yy, zz, yA, nn : integer;

begin
  addition := 1;
  h := 0.7;

  initgauss; //initialisation of gauss

  delta := 1.0;

  n := round(power(2, maxlevel));    // 2 lifted with a power of maxlevel
  x[0, 0] := gauss();
  x[0, n] := gauss();
  x[n, 0] := gauss();
  x[n, n] := gauss();
  D := n;
  d_ny := n div 2;

  for stage :=0 to (maxlevel - 1) do
  begin
    delta := delta * power(0.5, (0.5 * h));   //pow translated to power

    xx := d_ny;
    while xx < (n - d_ny + 1) do
    begin
      yy := d_ny;
      while yy < (n - d_ny + 1) do
      begin
        x[xx, yy] := f4(x[(xx+d_ny), (yy+d_ny)],
                        x[(xx+d_ny), (yy-d_ny)],
                        x[(xx-d_ny), (yy+d_ny)],
                        x[(xx-d_ny), (yy-d_ny)]);
        yy := yy + D;
      end; //end while yy
      xx := xx + D;
    end; //end while xx


    if (addition <> 0)  //if (addition) in c++
    then
    begin
      xx := 0;
      while xx < (n + 1) do
      begin
        yy := 0;
        while yy < (n + 1) do
        begin
          x[xx, yy] := x[xx, yy] + delta * gauss();   //notice call of gauss()
          yy := yy + D;
        end; //end while yy
        xx := xx + D;
      end;  //end while xx
    end;


    delta := delta * power(0.5, (0.5 * h));


    xx := d_ny;
    while xx < (n - d_ny + 1) do
    begin
      x[xx, 0] := f3(x[(xx+d_ny), 0],
                     x[(xx-d_ny), 0],
                     x[xx, d_ny]);
      x[xx, n] := f3(x[(xx+d_ny), n],
                     x[(xx-d_ny), n],
                     x[xx, (n-d_ny)]);
      x[0, xx] := f3(x[0, (xx+d_ny)],
                     x[0, (xx-d_ny)],
                     x[d_ny, xx]);
      x[n, xx] := f3(x[n, (xx+d_ny)],
                     x[n, (xx-d_ny)],
                     x[(n-d_ny), xx]);

      xx := xx + D;
    end; //end while xx


    xx := d_ny;
    while xx < (n - d_ny + 1) do
    begin
      yy := D;
      while yy < (n - d_ny + 1) do
      begin
        x[xx, yy] := f4(x[xx, (yy+d_ny)],
                        x[xx, (yy-d_ny)],
                        x[(xx+d_ny), yy],
                        x[(xx-d_ny), yy]);
        yy := yy + D;
      end; //end while yy
      xx := xx + D;
    end;  //end while xx



    xx := D;
    while xx < (n - d_ny + 1) do
    begin
      yy := d_ny;
      while yy < (n + d_ny + 1) do
      begin
        x[xx, yy] := f4(x[xx, (yy+d_ny)],
                        x[xx, (yy-d_ny)],
                        x[(xx+d_ny), yy],
                        x[(xx-d_ny), yy]);
        yy := yy + D;
      end; //end while yy
      xx := xx + D;
    end; //end while xx


    if(addition <> 0) //if (addition) in C++
    then
    begin

      xx := 0;
      while xx < n do
      begin
        yy := 0;
        while yy < n do
        begin
          x[xx, yy] := x[xx, yy] + delta * gauss(); //calling gauss()
          yy := yy + D;
        end; //end while yy
        xx := xx + D;
      end;  //end while xx


      xx := d_ny;
      while xx < (n - d_ny + 1) do
      begin
        yy := d_ny;
        while yy < (n - d_ny + 1) do
        begin
          x[xx, yy] := x[xx, yy] + delta * gauss(); //calling gauss()
          yy := yy + D;
        end;  //end while yy
        xx := xx + D;
      end; //end while xx

    end; //end if addition


    D := D div 2;
    d_ny := d_ny div 2;

  end;  // end of stage loop


  //Find the minimal and the maximal number
  min := x[30, 30];
  max := min;

  for i := 0 to n do
  begin
    for xx := 0 to n do
    begin
      x[i, xx] := x[i, xx] * x[i, xx];  //squared xx
      if (min > x[i, xx])
      then
        min := x[i, xx];

      if (max < x[i, xx])
      then
        max := x[i, xx];
    end;
  end;


  d_m := max - min;  //difference between the largest and the smallest value

  //the resulting X values are distributed between 0 and MAXHOEHE
  for i := 0 to n do
  begin
    for xx:=0 to n do
    begin
      x[i, xx] := (MAXHOEHE * (x[i, xx] - min) )/d_m;
    end;
  end;


end;







end.
