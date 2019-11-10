unit ball1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass;

Const
  EXP_LIFE = 10;
  SPARK_AMOUNT = 200;
  SPARK_LIFE = 100;

Type
  TBall = Record
    X, Y, SX, SY: real;
  End;

Type
  TExplosion = Record
    X, Y, Age: integer;
  End;

Type
  TSpark = Record
    X, Y, SX, SY: real;
    Age: integer;
  End;

type
  TForm1 = class(TForm)
    DXDraw1: TDXDraw;
    DXImageList1: TDXImageList;
    DXTimer1: TDXTimer;
    procedure FormCreate(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
  private
    { Private declarations }
    Procedure CalcBall;
    Procedure CheckCollision;
  public
    { Public declarations }
    BrickMap: Array[0..10, 0..10] Of Integer;
    Spark: Array[0..SPARK_AMOUNT] Of TSpark;
    Explosion: TExplosion;
    //DBackDIB, DBrick, DBall, DExplosion, DSpark: TDIBUltra;
    Ball: TBall;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Procedure TForm1.CalcBall;
Begin
  Ball.X := Ball.X + Ball.SX;
  Ball.Y := Ball.Y + Ball.SY;
  If (Ball.X < 0) Then
  Begin
    Ball.SX := -Ball.SX;
    Ball.X := 0;
  End;
  If (Ball.X + 10 > 300) Then
  Begin
    Ball.SX := -Ball.SX;
    Ball.X := 290;
  End;
  If (Ball.Y < 0) Then
  Begin
    Ball.SY := -Ball.SY;
    Ball.Y := 0;
  End;
  If (Ball.Y + 10 > 200) Then
  Begin
    Ball.SY := -Ball.SY;
    Ball.Y := 190;
  End;

  // Spark Trail
  With Spark[random(SPARK_AMOUNT)] Do
  Begin
    X := Ball.X + 5;
    Y := Ball.Y + 5;
    SX := (random(20) - 10) / 20;
    SY := (random(20) - 10) / 20;
    Age := random(SPARK_LIFE);
  End;
End;

Procedure TForm1.CheckCollision;
Var
  BallX, BallY, i: integer;
Begin
  BallX := Round(Ball.X - 5);
  BallY := Round(Ball.Y - 5);
  If ((BallY + 10) < 100) Then
    If BrickMap[Round(BallX / 30), Round(BallY / 10)] > 0 Then
    Begin
      Ball.SY := -Ball.SY;
      BrickMap[Round(BallX / 30), Round(BallY / 10)] := BrickMap[Round(BallX / 30), Round(BallY / 10)] - 1;

      Explosion.Age := EXP_LIFE;
      Explosion.X := BallX;
      Explosion.Y := BallY;
      If (Explosion.X < 0) Or (Explosion.X + 30 > 300) Or
        (Explosion.Y < 0) Or (Explosion.Y + 30 > 200) Then Explosion.Age := 0;

      If BrickMap[Round(BallX / 30), Round(BallY / 10)] = 0 Then
        For i := 0 To SPARK_AMOUNT Do
          If Spark[i].Age < 1 Then
            With Spark[i] Do
            Begin
              Age := random(SPARK_LIFE);
              X := (Round(BallX / 30) * 30) + Random(30);
              Y := (Round(BallY / 10) * 10) + Random(10);
              SX := (random(20) - 10) / 20;
              SY := (random(20) - 10) / 20;
            End;
    End;
End;

procedure TForm1.FormCreate(Sender: TObject);
Var
  i, j: integer;
begin
  //Init Ball
  Ball.X := 200;
  Ball.Y := 100;
  Ball.SX := (random(200) - 100) / 50;
  Ball.SY := (random(200) - 100) / 50;
  //Init Level
  For i := 0 To 9 Do
    For j := 0 To 9 Do
      BrickMap[i, j] := random(3) + 1;
end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
var
  i, j: integer;
  R: TRect;
begin
  CalcBall;
  CheckCollision;

  If NOT DXDraw1.CanDraw Then Exit;

  DXDraw1.Surface.Fill(0);

  For i := 0 To 9 Do
    For j := 0 To 9 Do
      If BrickMap[i, j] > 0 Then
        DXImageList1.Items.Find('Brick').Draw(DXDraw1.Surface,i*30,j*10,BrickMap[i, j]-1);

  For i := 0 To SPARK_AMOUNT Do
    If Spark[i].Age > 0 Then
      With Spark[i] Do
      Begin
        X := X + SX;
        Y := Y + SY;
        SY := SY + 0.01;
        Age := Age - 1;
        If (X < 0) Or (X + 3 > 300) Or (Y < 0) Or (Y + 3 > 200) Then
          Age := 0
        Else
        Begin
          R := Rect(ROUND(Spark[i].X),ROUND(Spark[i].Y),ROUND(Spark[i].X)+DXImageList1.Items.Find('Spark').Width,ROUND(Spark[i].Y)+DXImageList1.Items.Find('Spark').Height);
          DXImageList1.Items.Find('Spark').DrawAlpha(DXDraw1.Surface,
           R,0,Spark[i].Age * 255 Div SPARK_LIFE);
        End;
      End;

  If Explosion.Age > 0 Then
  Begin
    R := Rect(Explosion.X, Explosion.Y,Explosion.X+DXImageList1.Items.Find('BlueExplosion').Width, Explosion.Y+DXImageList1.Items.Find('BlueExplosion').Height);
    DXImageList1.Items.Find('BlueExplosion').DrawAdd(DXDraw1.Surface,R,0,Trunc(255/EXP_LIFE*Explosion.Age));
    Dec(Explosion.Age);
  End;
  DXImageList1.Items.Find('Ball').Draw(DXDraw1.Surface,round(Ball.X), round(Ball.Y),0);

  DXDraw1.Flip;
end;

end.
