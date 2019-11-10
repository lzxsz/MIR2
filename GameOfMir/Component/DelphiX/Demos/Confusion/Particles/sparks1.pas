unit sparks1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXClass, DXDraws;

CONST
  SP_AMOUNT=1000;

type TSpark=record
  X,Y,SX,SY,Age,Aging:real;
  end;

type
  TForm1 = class(TDXForm)
    DXDraw1: TDXDraw;
    DXImageList1: TDXImageList;
    DXTimer1: TDXTimer;
    procedure FormCreate(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
  private
    { Private declarations }
    FSparks:array[0..SP_AMOUNT] of TSpark;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var i:Integer;
begin
  For i:=0 to SP_AMOUNT do
    With FSparks[i] do
    begin
      X:=random(Width-DXImageList1.Items.Find('Sparks').Height);
      Y:=random(DXImageList1.Items.Find('Title').Height)+(ClientHeight div 2-DXImageList1.Items.Find('Title').Height);
      SX:=(random(21)-10) / 5;
      SY:=(random(21)-10) / 5;
      Age:=random(100)/100;
      Aging:=(random(10)+3)/100;
    end;
end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
Var
  i,x,y: Integer;
  R: TRect;
begin
  If NOT DXDraw1.CanDraw Then Exit;
  DXDraw1.BeginScene;
  DXImageList1.Items.Find('Background').Draw(DXDraw1.Surface,0,0,0);

  x := 0;
  y := ClientHeight div 2 - DXImageList1.Items.Find('Light').Height div 2;
  R := Rect(x,y,x+DXImageList1.Items.Find('Light').Width,y+DXImageList1.Items.Find('Light').Height);
  DXImageList1.Items.Find('Light').DrawAdd(DXDraw1.Surface,R,0);

  x := (ClientWidth-DXImageList1.Items.Find('Title').Width) div 2;
  y := (ClientHeight-DXImageList1.Items.Find('Title').Height) div 2;
  R := Rect(x,y,x+DXImageList1.Items.Find('Title').Width,y+DXImageList1.Items.Find('Title').Height);
  DXImageList1.Items.Find('Title').DrawAdd(DXDraw1.Surface,R,0);

  For i:=0 to SP_AMOUNT do
  With FSparks[i] do
  begin
    Age:=Age+Aging;
    X:=X+SX;
    SY:=SY+(1/10);
    Y:=Y+SY;

    If (Age>1) or (X<0) or (X+DXImageList1.Items.Find('Sparks').Height>Width) or (Y<0) or (Y+DXImageList1.Items.Find('Sparks').Height>Height) then
    begin
      X:=random(Width-DXImageList1.Items.Find('Sparks').Height);
      Y:=ClientHeight div 2-DXImageList1.Items.Find('Title').Height+random(DXImageList1.Items.Find('Title').Height);
      SX:=(random(21)-10) / 5;
      SY:=(random(21)-10) / 5;
      Age:=0;
      Aging:=(random(10)+1)/50;
    end;

    R := Rect(round(X),round(Y),round(X)+DXImageList1.Items.Find('Sparks').Height,round(Y)+DXImageList1.Items.Find('Sparks').Height);
    DXImageList1.Items.Find('Sparks').DrawAdd(DXDraw1.Surface,R,ROUND(Age*4));

  end;
  DXDraw1.EndScene;

  with DXDraw1.Surface.Canvas do
  try
    Brush.Style := bsClear;
    Font.Color := clWhite;
    Font.Size := 12;
    Textout(0, 0, 'FPS: '+inttostr(DXTimer1.FrameRate));
    if doHardware in DXDraw1.NowOptions then
      Textout(0, 14, 'Device: Hardware')
    else
      Textout(0, 14, 'Device: Software');
  finally
    Release; {  Indispensability  }
  end;

  DXDraw1.Flip;
end;

end.
