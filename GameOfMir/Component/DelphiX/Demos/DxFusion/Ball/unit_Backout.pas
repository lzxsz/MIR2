Unit unit_Backout;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, DIB, ExtCtrls, DXClass, DXDraws;

Const
  EXP_LIFE = 25;
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

Type
  TGameForm = Class(TDXForm)
    DXImageList1: TDXImageList;
    DXDraw1: TDXDraw;
    DXTimer1: TDXTimer;
    DBackDIB: TDXDIB;
    TempDIB: TDXDIB;
    Procedure FormCreate(Sender: TObject);
    Procedure CalcBall;
    Procedure CheckCollision;
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure DXTimer2Timer(Sender: TObject; LagCount: Integer);
  Private
    { Private declarations }
    BrickMap: Array[0..10, 0..10] Of Integer;
    Spark: Array[0..SPARK_AMOUNT] Of TSpark;
    Explosion: TExplosion;
    Ball: TBall;
  Public
    { Public declarations }
  End;

Var
  GameForm: TGameForm;

Implementation

{$R *.DFM}

Procedure TGameForm.CalcBall;
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

Procedure TGameForm.CheckCollision;
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

Procedure TGameForm.FormCreate(Sender: TObject);
Var
  i, j: integer;
Begin
  DBackDIB.DIB.SetSize(300,200,24);
  //Init Ball
  Ball.X := 200;
  Ball.Y := 100;
  Ball.SX := (random(200) - 100) / 50;
  Ball.SY := (random(200) - 100) / 50;

  //Init Level
  For i := 0 To 9 Do
    For j := 0 To 9 Do
      BrickMap[i, j] := random(3) + 1;
End;

procedure TGameForm.DXTimer1Timer(Sender: TObject; LagCount: Integer);
{With DXFusion}
Var
  i, j: integer;
Begin
  CalcBall;
  CheckCollision;

  If NOT DXDraw1.CanDraw Then Exit;
  //Draw Map
  DBackDIB.DIB.Canvas.Brush.Color := clBlack;
  DBackDIB.DIB.Canvas.FillRect(Bounds(0,0,300,200));

  TempDIB.DIB.Assign(DXImageList1.Items.Find('Brick').Picture);
  For i := 0 To 9 Do
    For j := 0 To 9 Do
      If BrickMap[i, j] > 0 Then
        DBackDIB.DIB.DrawTo(TempDIB.DIB, i * 30, j * 10, 30, 10, 0, 30 - (BrickMap[i, j] * 10));


  TempDIB.DIB.Assign(DXImageList1.Items.Find('Spark').Picture);
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
          DBackDIB.DIB.DrawAlpha(TempDIB.DIB, ROUND(Spark[i].X), ROUND(Spark[i].Y), 3, 3, 0, 0, Spark[i].Age * 255 Div SPARK_LIFE, clBlack);
      End;

  TempDIB.DIB.Assign(DXImageList1.Items.Find('Ball').Picture);
  DBackDIB.DIB.DrawTransparent(TempDIB.DIB, round(Ball.X), round(Ball.Y), 10, 10, 0, 0, clBlack);

  TempDIB.DIB.Assign(DXImageList1.Items.Find('BlueExplosion').Picture);
  If Explosion.Age > 0 Then
  Begin
    DBackDIB.DIB.DrawAdditive(TempDIB.DIB, Explosion.X, Explosion.Y, 30, 30, Explosion.Age * 255 Div EXP_LIFE, 0);
    Explosion.Age := Explosion.Age - 1;
  End;
  {Draw canvas}
  DBackDIB.DIB.DrawOn(DBackDIB.DIB.Canvas,DXDraw1.ClientRect, DXDraw1.Surface.Canvas, 0, 0);
  with DXDraw1.Surface.Canvas do
  begin
    try
      Brush.Style := bsClear;
      Font.Color := clWhite;
      Font.Size := 9;
      Textout(0, DXDraw1.Height-2*TextHeight('M'), 'FPS: '+IntToStr(DXTimer1.FrameRate));
      if doHardware in DXDraw1.NowOptions then
        Textout(0, DXDraw1.Height-TextHeight('M'), 'Device: Hardware')
      else
        Textout(0, DXDraw1.Height-TextHeight('M'), 'Device: Software');
    finally
      Release; {  Indispensability  }
    end;
  end;

  DXDraw1.Flip;
end;

procedure TGameForm.DXTimer2Timer(Sender: TObject; LagCount: Integer);
{Pure DelphiX}
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

  with DXDraw1.Surface.Canvas do
  begin
    try
      Brush.Style := bsClear;
      Font.Color := clWhite;
      Font.Size := 9;
      Textout(0, DXDraw1.Height-2*TextHeight('M'), 'FPS: '+IntToStr(DXTimer1.FrameRate));
      if doHardware in DXDraw1.NowOptions then
        Textout(0, DXDraw1.Height-TextHeight('M'), 'Device: Hardware')
      else
        Textout(0, DXDraw1.Height-TextHeight('M'), 'Device: Software');
    finally
      Release; {  Indispensability  }
    end;
  end;


  DXDraw1.Flip;
end;

End.

