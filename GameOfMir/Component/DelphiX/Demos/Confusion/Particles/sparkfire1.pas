unit sparkfire1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXClass, DXDraws, StdCtrls, Buttons;

Const
  SP_AMOUNT = 100;

Type
  TSpark = Record
    X, Y, SX, SY, Age, Aging: real;
  End;

type
  TForm1 = class(TDXForm)
    DXDraw1: TDXDraw;
    DXImageList1: TDXImageList;
    DXTimer1: TDXTimer;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    FSparks: Array[0..SP_AMOUNT] Of TSpark;
    FX, FY: integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
Var
  i: integer;
Begin
  //ShowCursor(False);
  DXDraw1.Cursor := crNone;

  For i := 0 To SP_AMOUNT Do
    With FSparks[i] Do
    Begin
      X := Width / 2;
      Y := Width / 2;
      SX := (random(11) - 5) / 5;
      SY := (random(11) - 5) / 5;
      Age := 0;
      Aging := (random(15) + 2) / 150;
    End;
end;

procedure TForm1.DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  FX := X;
  FY := Y;
end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
Var
  i: integer;
  R: TRect;
Begin
  If NOT DXDraw1.CanDraw Then Exit;

  DXDraw1.Surface.Fill(0);

  For i := 0 To SP_AMOUNT Do
    With FSparks[i] Do
    Begin
      Age := Age + Aging;
      X := X + SX;
      Y := Y + SY;

      If (Age > 1) Or (X < 0) Or (X + DXImageList1.Items.Find('Sparks').Height > Width) Or (Y < 0) Or (Y + DXImageList1.Items.Find('Sparks').Height > Height) Then
      Begin
        X := FX;
        Y := FY;
        SX := (random(21) - 10) / 5;
        SY := (random(21) - 10) / 5;
        Age := 0;
        Aging := (random(10) + 3) / 100;
      End;
      //jako Rect() ale zadava se sirka,vyska
      R := Bounds(round(X), round(Y), DXImageList1.Items.Find('Sparks').Height, DXImageList1.Items.Find('Sparks').Height);
      DXImageList1.Items.Find('Sparks').DrawAdd(DXDraw1.Surface,R,ROUND(Age * 4))
    End;

  DXDraw1.Flip;
end;

end.
