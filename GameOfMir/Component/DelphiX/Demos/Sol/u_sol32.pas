unit u_sol32;
//**********************************************************************
//* Feel free to use or give away this software as you see fit.        *
//* Please leave the credits in place if you alter the source.         *
//*                                                                    *
//* This software is delivered to you "as is",                         *
//* no guarantees of any kind.                                         *
//*                                                                    *
//* If you find any bugs, please let me know, I will try to fix them.  *
//* If you modify the source code, please send me a copy               *
//* Marco Caselli                                                      *
//* Web site : http://i.am/pkc				               *
//* E-mail   : mcaselli@iname.com                                      *
//**********************************************************************
//*** Sorry for my bad english ...............
// Properties : none !
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ComCtrls, ExtCtrls, Menus, DIB;

var
  signature: string[6] = 'C' + 'p' + 'f' + chr($1) + chr($01) + chr($255);
type
  TCasHeader = record
    magic: string[6];
    numero: byte;
    xval: integer;
    yval: integer;
    zval: integer;
    fval: integer;
    lval: integer;
  end;


  TForm1 = class(TForm)
    b_set: TButton;
    bar: TStatusBar;
    c: TPanel;
    b: TPaintBox;
    Label5: TLabel;
    factor: TSpinEdit;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N2: TMenuItem;
    Save1: TMenuItem;
    PaintBox1: TPaintBox;
    list_b: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    assex: TSpinEdit;
    assey: TSpinEdit;
    assez: TSpinEdit;
    linee: TSpinEdit;
    b_redr: TButton;
    SaveD: TSaveDialog;
    opend: TOpenDialog;
    Open1: TMenuItem;
    procedure bMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure b_setClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure b_redrClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure list_bClick(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    surface: TDIB;
  public
    halfx: integer;
    halfy: integer;
    halfz: integer;
    put_mode: boolean;
    ip: integer;

    { Public declarations }
  end;

  total = record
    xs: array[1..50, 1..100] of real;
    ys: array[1..50, 1..100] of real;
  end;
const
  zoom: real = 0.7;

var
  Form1: TForm1;
  punt1: ^total;
  xp: array[1..100] of integer;
  yp: array[1..100] of integer;
  oldx, oldy: integer;
  num: longint;

implementation

uses U_list;

{$R *.DFM}

procedure TForm1.bMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with bar.panels do begin
    items[1].text := 'Points : ' + inttostr(ip);
    items[2].text := 'X -> ' + inttostr(x - halfx);
    items[3].text := 'Y -> ' + inttostr(halfy - y);
  end;

  if (ip > 1) and put_mode then
    with surface.Canvas do
    begin
      Brush.Color := clblack;
      Brush.Style := bsSolid; //penmode:=Dupmnot;
      moveto(xp[ip - 1] + halfx, yp[ip - 1] + halfy);
      lineto(oldx, oldy);
      oldx := x; oldy := y;
      //pencolor:=clwhite;
      Brush.Color := clwhite;
      moveto(xp[ip - 1] + halfx, yp[ip - 1] + halfy);
      lineto(x, y);
      surface.drawon(surface.Canvas, b.BoundsRect, b.canvas, 0, 0);
      //penmode:=Dupmcopy;
      Brush.Style := bsClear
    end;

end;

procedure TForm1.b_setClick(Sender: TObject);
begin
  with surface.Canvas do
  begin
    brush.color := clblack;
    FillRect(bounds(0, 0, surface.Width, surface.Height));
    pen.color := clwhite;
    moveto(0, halfy);
    lineto(b.width, halfy);
    moveto(halfx, 0);
    lineto(halfx, b.height);
    surface.DrawOn(surface.Canvas, b.BoundsRect, b.canvas, 0, 0);
  end;
  put_mode := true;
  ip := 1;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  halfx := b.width div 2;
  halfy := b.height div 2;
  halfz := halfy;
  put_mode := false;
  new(punt1);
  surface := Tdib.create;
  surface.SetSize(b.width, b.height, 8);
end;

procedure TForm1.bMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  if (button = mbleft) and put_mode then
    if ip > 99 then begin
      application.messagebox('Max number of point reached (100)', ' ', mb_ok);
      exit;
    end
    else
    begin
      xp[ip] := x - halfx; yp[ip] := y - halfy;
      oldx := x; oldy := y;
      inc(ip);
    end;

end;

procedure TForm1.b_redrClick(Sender: TObject);
var w, i: integer;
  z, mem, num, s, k, qwq, rotaz: longint;
  inq, rot: real;
  a1, b1, c1, d, e, f, g, h, j, cox, coy, coz, six, siy, siz,
    xt, yt, zt, zwis, rx, ry, rz: real;

begin
  put_mode := false;
  with surface.Canvas do begin
    brush.color := clblack;
    pen.color := clwhite;
    FillRect(bounds(0, 0, surface.Width, surface.Height));
  end;
  zoom := 0.5;
  rz := assez.value * pi / 180;
  rx := (assex.value + 180) * pi / 180;
  ry := assey.value * pi / 180;
  num := linee.value;
  inq := (360 / num) * pi / 180;
  for w := 1 to num do
  begin
    six := sin(rx); siy := sin(ry); siz := sin(rz);
    cox := cos(rx); coy := cos(ry); coz := cos(rz);
    a1 := coy * coz;
    b1 := coy * siz;
    c1 := -siy;
    d := six * siy * coz - cox * siz;
    e := six * siy * siz + cox * coz;
    g := cox * siy * coz - six * siz;
    h := cox * siy * siz + six * coz;

    with punt1^ do begin
      for i := 1 to (ip - 1) do begin
        xt := xp[i] * a1 + yp[i] * b1 * zoom;
        yt := xp[i] * d + yp[i] * e * zoom;
        zt := xp[i] * g + yp[i] * h * zoom;
        zwis := zt - (factor.value * 50000);

        xs[w, i] := halfx + ((-500000 * xt) / zwis);
        ys[w, i] := halfy - ((-500000 * yt) / zwis);
      end;
    end;
    ry := ry - inq;
  end;

  with punt1^ do begin
    for w := 1 to num do begin
      for i := 1 to (ip - 2) do
        with surface.Canvas do begin
          moveto(trunc(xs[w, i]), trunc(ys[w, i]));
          lineto(trunc(xs[w, i + 1]), trunc(ys[w, i + 1]));
        end;
    end;
    qwq := 1;
    for w := 1 to num do begin
      for i := 1 to (ip - 1) do begin
        if w = num then qwq := -num + 1;
        with surface.Canvas do begin
          moveto(trunc(xs[w, i]), trunc(ys[w, i]));
          lineto(trunc(xs[w + qwq, i]), trunc(ys[w + qwq, i]));
        end;
      end;
    end;
  end;
  surface.drawon(surface.Canvas, b.BoundsRect, b.canvas, 0, 0);
end;

procedure TForm1.Button1Click(Sender: TObject);
var w, i: integer;
begin
  with punt1^ do
    with surface.Canvas do
      repeat
        for w := 1 to num - 1 do begin
          for i := 1 to ip do begin
            MOVETO(trunc(xs[w + 1, i]), trunc(ys[w + 1, i]));
            LINETO(trunc(xs[w, i + 1]), trunc(ys[w, i + 1]));
          end;
        end;
        surface.drawon(surface.canvas, b.BoundsRect, b.canvas, 0, 0);
      until put_mode = true;
end;

procedure TForm1.list_bClick(Sender: TObject);
begin
  form2.show;
end;

procedure TForm1.Save1Click(Sender: TObject);
var xfile: file;
  head: tcasheader;
  res: integer;
begin
  if saved.execute then
  begin
    assignfile(xfile, saved.filename);
    rewrite(xfile, 1);
    head.magic := signature;
    head.numero := ip;
    blockwrite(xfile, head, sizeof(head), res);
    blockwrite(xfile, xp, sizeof(integer) * 100);
    blockwrite(xfile, yp, sizeof(integer) * 100);
    closefile(xfile);
  end;

end;

procedure TForm1.Open1Click(Sender: TObject);

var xfile: file;
  head: tcasheader;
  res: integer;
begin
  if opend.execute then
  begin
    assignfile(xfile, opend.filename);
    reset(xfile, 1);
    blockread(xfile, head, sizeof(head), res);
    if (res < sizeof(head)) or
      (head.magic <> signature) then
    begin
      application.messagebox('Invalid file format !', 'Error', mb_iconstop + mb_ok);
      exit;
    end;
    blockread(xfile, xp, sizeof(integer) * 100);
    blockread(xfile, yp, sizeof(integer) * 100);
    ip := head.numero;
    closefile(xfile);
  end;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  surface.free;
end;

end.

