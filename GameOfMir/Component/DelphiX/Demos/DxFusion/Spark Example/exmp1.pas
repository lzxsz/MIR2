Unit exmp1;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, DIB, ExtCtrls, StdCtrls, DXClass, DXDraws;

Const
  SP_AMOUNT = 1000;

Type
  TSpark = Record
    X, Y, SX, SY, Age, Aging: real;
  End;

Type
  TfrmSpark = Class(TDXForm)
    DXImageList1: TDXImageList;
    DXDraw1: TDXDraw;
    DXTimer1: TDXTimer;
    FBackBuffer: TDXDIB;
    DXDIB1: TDXDIB;
    Procedure FormCreate(Sender: TObject);
    Procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer); /// To avoid flicker when repaint
    procedure DXTimer2Timer(Sender: TObject; LagCount: Integer);
  Private
    { Private declarations }
    FSparks: Array[0..SP_AMOUNT] Of TSpark;
    FX, FY: integer;
  Public
    { Public declarations }
  End;

Var
  frmSpark: TfrmSpark;

Implementation

{$R *.DFM}

Procedure TfrmSpark.FormCreate(Sender: TObject);
Var
  i: integer;
Begin
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
End;

Procedure TfrmSpark.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
Begin
  FX := X;
  FY := Y;
End;

procedure TfrmSpark.DXTimer1Timer(Sender: TObject; LagCount: Integer);
Var
  i: integer;
Begin
  If NOT DXDraw1.CanDraw Then Exit;


  FBackBuffer.DIB.Assign(DXImageList1.Items.Find('Background').Picture);


  DXDIB1.DIB.Assign(DXImageList1.Items.Find('Sparks').Picture);
  For i := 0 To SP_AMOUNT Do
    With FSparks[i] Do
    Begin
      Age := Age + Aging;
      X := X + SX;
      Y := Y + SY;

      If (Age > 1) Or (X < 0) Or (X + DXImageList1.Items.Find('Sparks').Height > DXDraw1.Width) Or (Y < 0) Or (Y + DXImageList1.Items.Find('Sparks').Height > DXDraw1.Height) Then
      Begin
        X := FX;
        Y := FY;
        SX := (random(21) - 10) / 5;
        SY := (random(21) - 10) / 5;
        Age := 0;
        Aging := (random(10) + 3) / 100;
      End;

      FBackBuffer.DIB.DrawAdditive(DXDIB1.DIB, round(X), round(Y), DXImageList1.Items.Find('Sparks').Height, DXImageList1.Items.Find('Sparks').Height, 255,ROUND(Age * 4));
    End;
    
  FBackBuffer.DIB.DrawOn(FBackBuffer.DIB.Canvas,DXDraw1.ClientRect, DXDraw1.Surface.Canvas, 0, 0);
  with DXDraw1.Surface.Canvas do
  begin
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
  end;

  DXDraw1.Flip;
end;

procedure TfrmSpark.DXTimer2Timer(Sender: TObject; LagCount: Integer);
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

  with DXDraw1.Surface.Canvas do
  begin
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
  end;

  DXDraw1.Flip;
end;

End.

