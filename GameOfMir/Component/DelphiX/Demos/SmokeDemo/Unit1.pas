{Smoke demo, background picture lost}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXClass, DXDraws, DIB;

type
  particle = record
    x: integer;
    y: integer;
    age: integer;
    xv: integer;
  end;
  TForm1 = class(TForm)
    DXDraw: TDXDraw;
    DXTimer1: TDXTimer;
    images: TDXImageList;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DXDrawInitialize(Sender: TObject);
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
  private
    { Private declarations }
    particles: array[0..800] of particle;
    Random_X: array[0..1300] of integer;
    xval: integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.DXDrawInitialize(Sender: TObject);
var res: integer;
begin
  for res := 0 to 800 do
  begin
    with particles[res] do
    begin
      x := -1;
      y := -30000;
      age := res;
      xv := 0;
    end;
  end;

  Randomize;
  for res := 0 to 1300 do
  begin
    Random_X[res] := random(5) - 2;
  end;

  Dxtimer1.Enabled := true;
end;

procedure TForm1.DXDrawFinalize(Sender: TObject);
begin
  Dxtimer1.Enabled := false;
end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
var res: integer;
  where: trect;
begin
  for res := 0 to 800 do
  begin
    if particles[res].age >= 800 then
    begin
      particles[res].age := 0;
      particles[res].x := 286;
      particles[res].y := 206;
    end
    else
    begin
      inc(particles[res].age);
      dec(particles[res].y);
      inc(xval);
      if xval > 1300 then xval := 0;
      particles[res].x := particles[res].x + random_x[xval];
    end;
  end;

  if not DXDraw.CanDraw then Exit;
  //image lost, sorry
  //Images.Items.Find('background').Draw(DXDraw.surface,0,0,0);
  DXDraw.Surface.Fill(0);

  for res := 0 to 800 do
  begin
    where.top := particles[res].y - 7;
    if (where.top > -14) and (where.top < 250) then
    begin
      where.Left := particles[res].x - 7;
      where.right := particles[res].x + 6;
      where.bottom := particles[res].y + 6;
      images.Items.Find('Dym').DrawAdd(DXDraw.Surface, where, 0, 220 - particles[res].age);
    end;
  end;
  { Draw FrameRate }
  with DXDraw.Surface.Canvas do
  begin
    try
      Brush.Style := bsClear;
      Font.Color := clWhite;
      Font.Size := 12;
      Textout(0, 0, 'FPS: ' + inttostr(DXTimer1.FrameRate));
      if doHardware in DXDraw.NowOptions then
        Textout(0, 14, 'Device: Hardware')
      else
        Textout(0, 14, 'Device: Software');
    finally
      Release; {  Indispensability  }
    end;
  end;
  dxdraw.Flip;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {  Application end  }
  if Key = VK_ESCAPE then
    Close;
end;

end.

