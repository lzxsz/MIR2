// Panu Niva 3.12.2000
// Biljardi-pelin komponetti

// T‰m‰ on laitettu l‰hinn‰ malliksi ett‰ osataan tehd‰
// "Perinteinen" komponentti
// TDXDraw piirtopinnalle Canvasilla piirt‰ess‰ ei voi k‰ytt‰‰
// TransParent := True:ta jolloin bitmap taustana olisi piirtopinnan
// tausta.
// Ts. valkoinen tms. tausta tulee pakostakin n‰kyviin.
// T‰ll‰ komponentilla piirret‰‰n ruudun
// yl‰laitaan TDXDraw piirtopinnan ulkopuolelle
// pussitetut pallot paint:lla.
// ja lasketaan niiden lukum‰‰r‰t.

unit ShootBall;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TOnChange = procedure(sender:TObject;num:real) of object;

type
  TShootBall = class(TPaintBox)
  private
  protected
    FX:integer;                         // x-koordinaatti
    FY:integer;                         // y-koordinaatti
    Imagelist:TImagelist;
  public
    constructor Create(AOwner:TComponent);      override;
    destructor Destroy;                         override;
    procedure SetX(const Value:integer);        virtual;
    procedure SetY(const Value:integer);        virtual;
    procedure LoadBitmap(filename:string);      virtual;
    procedure Paint; override;
  published
    property X:integer read FX write SetX;
    property Y:integer read FY write SetY;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Pool', [TShootBall]);
end;

Constructor TShootBall.Create(AOwner:TComponent);
begin
  inherited;
  X := 0;
  Y := 0;
  Imagelist := TImagelist.Create(self);
end;

destructor TShootBall.Destroy;
begin
  Imagelist.Free;
  inherited;
end;

procedure TShootBall.SetX(const Value:integer);
begin
  FX := Value;
end;

procedure TShootBall.SetY(Const Value:integer);
begin
  FY := Value;
end;

procedure TShootBall.LoadBitmap(filename:string);
var
  bmp:TBitmap;
begin
  bmp:=TBitmap.Create;
  Imagelist.Clear;
  Imagelist.Height := 20;
  Imagelist.Width := 20;
  bmp.LoadFromFile(filename);
  imagelist.AddMasked(bmp,bmp.Transparentcolor);
  bmp.free;
end;

procedure TShootBall.Paint;
begin
  Imagelist.Draw(Canvas,X,Y,0);
  inherited;
end;

end.
