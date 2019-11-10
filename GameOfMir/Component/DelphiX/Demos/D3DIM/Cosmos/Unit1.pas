unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXClass;

const MaxPoints = 2000;
      MinDist   = 20;
      PPerRing  = 50;
      Radius    = 100;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

  TPoint3D = record
     x, y, z, Size : Single;
  end;

  TPoint2D = record
     x, y, Size : Single;
  end;

  TDrawMode = (dmStars, dmRings);

var
   Form1 : TForm1;
   Bmp : TBitmap;
   n : Integer;
   Center : TPoint;
   Mode : TDrawMode;
   TimeKey : Single;
   Quit : Boolean;
   P : Array [0..MaxPoints - 1] of TPoint3D;

   function ConvTo2D(P : TPoint3D) : TPoint2D;

implementation

{$R *.DFM}

procedure Init;
begin
     Randomize;
     Mode := dmStars;
end;

function Point3D(x, y, z : Single) : TPoint3D;
begin
     Result.x := x;
     Result.y := y;
     Result.z := z;
end;

procedure DrawRings;
var
   S : TPoint2D;
   i, c : Integer;
begin
     Bmp.Canvas.Brush.Color := clBlack;
     Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));

     Center.x := Round(Radius / 2 * Sin(TimeKey / 2));
     Center.y := Round(Radius / 2 * Cos(TimeKey / 3));

     for i := 0 to MaxPoints - 1 do
     begin
          P[i].z := P[i].z - 10;
          if P[i].z < MinDist then
          begin
               P[i].x := Radius * Sin(n / PPerRing * 2 * PI);
               P[i].y := Radius * Cos(n / PPerRing * 2 * PI);
               P[i].z := Random(Bmp.Width) + Bmp.Width;
               Inc(n);
          end;
          if P[i].z < Bmp.Width then
          begin
               S := ConvTo2D(Point3D(P[i].x + Center.x, P[i].y + Center.y, P[i].z));
               c := Round(255 * (1 - P[i].z / Bmp.Width));
               Bmp.Canvas.Brush.Color := RGB(c, c, c);
               Bmp.Canvas.FillRect(Rect(Round(S.x - S.Size), Round(S.y - S.Size), Round(S.x + S.Size), Round(S.y + S.Size)));
          end;
     end;
     Form1.Canvas.Draw(0, 0, Bmp);
end;

procedure DrawStars;
var
   S : TPoint2D;
   i, c : Integer;
begin
     Bmp.Canvas.Brush.Color := clBlack;
     Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));
     for i := 0 to MaxPoints - 1 do
     begin
          P[i].z := P[i].z - 10;
          if P[i].z < MinDist then
          begin
               P[i].x := Random(2000) - 1000;
               P[i].y := Random(2000) - 1000;
               P[i].z := Random(Bmp.Width) + Bmp.Width;
          end;
          if P[i].z < Bmp.Width then
          begin
               S := ConvTo2D(P[i]);
               c := Round(255 * (1 - P[i].z / Bmp.Width));
               Bmp.Canvas.Brush.Color := RGB(c, c, c);
               Bmp.Canvas.FillRect(Rect(Round(S.x - S.Size), Round(S.y - S.Size), Round(S.x + S.Size), Round(S.y + S.Size)));
          end;
     end;
     Form1.Canvas.Draw(0, 0, Bmp);
end;

procedure Draw(M : TDrawMode);
begin
     case M of
        dmStars : DrawStars;
        dmRings : DrawRings;
     end;
end;

function ConvTo2D(P : TPoint3D) : TPoint2D;
begin
     Result.x := Round(P.x * Bmp.Width / 2 / P.z + Bmp.Width / 2);
     Result.y := Round(P.y * Bmp.Width / 2 / P.z + Bmp.Height / 2);
     Result.Size := Bmp.Width / 2 / P.z;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     Bmp := TBitmap.Create;
     Bmp.Width := ClientWidth;
     Bmp.Height := ClientHeight;
     Bmp.Canvas.Brush.Color := clBlack;
     Bmp.Canvas.Pen.Color := clWhite;
     Init;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     Bmp.Free;
     Bmp := nil;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
     Bmp.Width := ClientWidth;
     Bmp.Height := ClientHeight;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if Key = Ord('M') then if Mode = dmStars then Mode := dmRings else Mode := dmStars;

end;

procedure TForm1.FormPaint(Sender: TObject);
begin
     repeat
     begin
          Application.ProcessMessages;
          Draw(Mode);
          TimeKey := GetTickCount / 1000;
     end;
     until Quit;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Quit := True;
end;

end.
