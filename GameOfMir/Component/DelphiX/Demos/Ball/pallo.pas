unit pallo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Math;

type
  TPallo = class(TPaintBox)
  private
  protected
    FAngle:integer;                  // 0-kulma = oikealle
    FSpeed:integer;                  // Liikkuvan pallon nopeus
                                     // Tarvitaan poyta-ohjelmassa
    dx:real;                         // x:n arvo yksikköympyrässä
    dy:real;                         // y:n arvo yksikköympyrässä
    x:real;                          // Pallon x-koordinaatti
    y:real;                          // Pallon y-koordinaatti
    bmp:TBitmap;
    imagelist:TImagelist;
    procedure paint;                          override;
  public
    constructor Create(AOwner:TComponent);    override;
    destructor Destroy;                       override;
    procedure loadbitmaps(filename:string);
    procedure DrawBall;                       virtual;
    procedure Move;                           virtual;
    procedure SetAngle(const Value:integer);  virtual;
    procedure SetSpeed(Value:integer);        virtual;
  published
    property Angle:integer read FAngle write Setangle;
    property Speed:integer read FSpeed write SetSpeed;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('biljardi', [TPallo]);
end;

constructor TPallo.Create(AOwner:TComponent);
begin
  inherited;
  bmp := TBitmap.Create;
  imagelist := TImagelist.Create(self);
  Speed := 0;
  Angle := 0;
  x := 0;
  y := 0;
  Left := 0;
  Top  := 0;
end;

destructor TPallo.Destroy;
begin
  inherited;
end;

procedure TPallo.SetSpeed(Value:integer);
begin
  if (Value < 0)   then Value := abs(Value);
  if (Value > 100) then Value := 100;
  FSpeed := Value;
end;

procedure TPallo.SetAngle(const Value:integer);
begin
  FAngle := Value;
end;

procedure TPallo.Move;
begin
  dx := cos(degtorad(Angle));
  dy := sin(degtorad(Angle));
  x := x + dx;
  y := y + dy;

  Left := round(x);
  Top := round(y);
end;

procedure TPallo.Paint;
begin
  inherited;
  Imagelist.Draw(Canvas,0,0,0);
end;

procedure TPallo.loadbitmaps(filename:string);
begin
  Imagelist.Width :=20;
  Imagelist.Height :=20 ;
  Imagelist.Clear;

  bmp.Width := Imagelist.Width;
  bmp.Height := Imagelist.Height;

  bmp.LoadFromFile(filename);
  Imagelist.AddMasked(bmp,bmp.Transparentcolor);
end;

procedure TPallo.DrawBall;
begin
  paint;
end;


end.


