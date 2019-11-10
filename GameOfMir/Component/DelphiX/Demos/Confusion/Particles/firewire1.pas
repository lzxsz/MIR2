unit firewire1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, DXClass, DXDraws, DIB;

const
  FTotalLines=200;
  FTotColors=5;
  FColorRate=10;
  FColorRate2=100;

type T3dPoint = record
  X, Y, Z: real;
end;

type T3dLine = record
  First,Second:T3dPoint;
end;

type
  TForm1 = class(TDXForm)
    imgArea: TDXDraw;
    cbBlur: TCheckBox;
    cbAcc: TCheckBox;
    Button1: TButton;
    DXTimer1: TDXTimer;
    FDIB: TDXDIB;
    FTempDIB: TDXDIB;
    procedure FormCreate(Sender: TObject);
    procedure imgAreaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgAreaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure cbAccClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
  private
    { Private declarations }
    OX,OY:Integer;
    F3dCursor1,F3dCursor2:T3dPoint;
    FPerspMult: Integer;
    FPerspTran: Integer;
    FCounter: Integer;
    FColors:Array [0..FTotColors] of TColor;
    FOldX,FOldY: Integer;
    FCnt1,FCnt3: Integer;
    FAngleX, FAngleY, FAngleZ: real;
    F3dLine:Array [0..FTotalLines] of T3dLine;
    function MakeVox(X, Y, Z: Integer): T3DPoint;
    function Vox2Point(const P: T3DPoint): TPoint;
    function Limit(Value,Limit:integer): Integer;
    function Rotate3dPoint(var FPoint:T3dPoint;FAngleX,FAngleY,FAngleZ:real): T3dPoint;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

function TForm1.Vox2Point(const P: T3DPoint): TPoint;
begin
  with P do
  begin
    Result.X := Round((Width / 2) + FPerspMult * (X / (FPerspTran + Z)));
    Result.Y := Round((Height / 2) + FPerspMult * (Y / (FPerspTran + Z)));
  end;
end;

function TForm1.MakeVox(X, Y, Z: Integer): T3DPoint;
begin
  Result.X := X;
  Result.Y := Y;
  Result.Z := Z;
end;

function TForm1.Rotate3dPoint(var FPoint:T3dPoint;FAngleX,FAngleY,FAngleZ:real):T3dPoint;
var
  x,x1,x2,
  y,y1,y2,
  z,z1,z2:real;
begin
  x:=FPoint.X;  // ---- Init
  y:=FPoint.Y;
  z:=FPoint.Z;

  // ---- Rotate around X axis
  x1 := x;
  y1 := (cos (FAngleX/(180/PI)) * y) - (sin (FAngleX/(180/PI)) * z);
  z1 := (sin (FAngleX/(180/PI)) * y) + (cos (FAngleX/(180/PI)) * z);
  // ---- Rotate around Y axis
  x2 := (cos (FAngleY/(180/PI)) * x1) + (sin (FAngleY/(180/PI)) * z1);
  y2 := y1;
  z2 :=-(sin (FAngleY/(180/PI)) * x1) + (cos (FAngleY/(180/PI)) * z1);
  // ---- Rotate around Z axis
  FPoint.X  := (cos (FAngleZ/(180/PI)) * x2) - (sin (FAngleZ/(180/PI)) * y2);
  FPoint.Y  := (sin (FAngleZ/(180/PI)) * x2) + (cos (FAngleZ/(180/PI)) * y2);
  FPoint.Z  := z2;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  FColors[0]:=RGB(255,255,0);
  FColors[1]:=RGB(255,0,0);
  FColors[2]:=RGB(255,0,255);
  FColors[3]:=RGB(0,0,255);
  FColors[4]:=RGB(0,255,255);
  FColors[5]:=RGB(0,255,0);

  
  FPerspMult := 250;
  FPerspTran := 400;
  FAngleX := 0.2;
  FAngleY := 1;
  FAngleZ := 0.1;

  {create as simple DelphiX.TDIB}
  //FDIB:=TDIBUltra.Create(imgArea.Width,imgArea.Height,Dupf24,Nil);
  FDIB.DIB.SetSize(imgArea.Width,imgArea.Height,24);
  //FTempDIB:=TDIBUltra.Create(imgArea.Width,imgArea.Height,Dupf24,Nil);
  FTempDIB.DIB.SetSize(imgArea.Width,imgArea.Height,24);

  DXTimer1.Enabled := True;
end;

function TForm1.Limit(Value,Limit:integer):integer;
begin
  If Value>Limit then Value:=Limit;
  Result:=Value;
end;

procedure TForm1.imgAreaMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
  begin
    F3dCursor1.X:=X - imgArea.Width div 2;
    F3dCursor1.Y:=Y - imgArea.Height div 2;
    F3dCursor1.Z:=random(10)/10;
    Inc(FCounter);
    If FCounter>FTotalLines then FCounter:=0;
    F3dLine[FCounter].First.X:=F3dCursor2.X;
    F3dLine[FCounter].First.Y:=F3dCursor2.Y;
    F3dLine[FCounter].First.Z:=F3dCursor2.Z;
    F3dLine[FCounter].Second.X:=F3dCursor1.X;
    F3dLine[FCounter].Second.Y:=F3dCursor1.Y;
    F3dLine[FCounter].Second.Z:=F3dCursor1.Z;
    F3dCursor2.X:=F3dCursor1.X;
    F3dCursor2.Y:=F3dCursor1.Y;
    F3dCursor2.Z:=F3dCursor1.Z;
  end;
end;

procedure TForm1.imgAreaMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then
  begin
    F3dCursor1.X:=X - imgArea.Width div 2;
    F3dCursor1.Y:=Y - imgArea.Height div 2;
    F3dCursor1.Z:=0.1;
    Inc(FCounter);
    If FCounter>FTotalLines then FCounter:=0;
    F3dLine[FCounter].First.X:=F3dCursor2.X;
    F3dLine[FCounter].First.Y:=F3dCursor2.Y;
    F3dLine[FCounter].First.Z:=F3dCursor2.Z;
    F3dLine[FCounter].Second.X:=F3dCursor1.X;
    F3dLine[FCounter].Second.Y:=F3dCursor1.Y;
    F3dLine[FCounter].Second.Z:=F3dCursor1.Z;
    F3dCursor2.X:=F3dCursor1.X;
    F3dCursor2.Y:=F3dCursor1.Y;
    F3dCursor2.Z:=F3dCursor1.Z;
  end else
  begin
    F3dCursor1.X:=X - imgArea.Width div 2;
    F3dCursor1.Y:=Y - imgArea.Height div 2;
    F3dCursor1.Z:=0.1;
    F3dCursor2.X:=F3dCursor1.X;
    F3dCursor2.Y:=F3dCursor1.Y;
    F3dCursor2.Z:=F3dCursor1.Z;
  end;

  If ssRight in Shift then
  begin
    FAngleX:=FAngleX+(Y-FOldY)/10;
    FAngleY:=FAngleY+(FOldX-X)/10;
    FAngleZ:=0;
  end;
  FOldX:=X;
  FOldY:=Y;
end;

procedure TForm1.cbAccClick(Sender: TObject);
begin
  If cbAcc.Checked then
  begin
    FAngleX:=FAngleX*10;
    FAngleY:=FAngleY*10;
    FAngleZ:=FAngleZ*10;
  end else
  begin
    FAngleX:=FAngleX/10;
    FAngleY:=FAngleY/10;
    FAngleZ:=FAngleZ/10;
  end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Application.MessageBox('3d demo using confusion 3x3 matrix and some DIBUltra magic. Draw with left mousebutton on the black area to draw 3d lines and right button to affect rotation. Developed in a pentium2 450mhz. More info at http://www.back.mine.nu/confusion/','',0);
end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
var FPoint1,FPoint2:TPoint;
   k:integer;
   t:integer;
   t1,t2,t3:integer;
   FCol1,FCol2:integer;
   FCnt2:integer;
   P:PByteArray;
   R1, R2: TRect;
begin
  If NOT imgArea.CanDraw Then Exit;

  imgArea.Surface.Fill(clBlack);
  If cbBlur.Checked then
  begin
    FTempDIB.DIB.Draw3x3Matrix(FDIB.DIB,msBlur);
    FTempDIB.DIB.DrawOn(FTempDIB.DIB.Canvas,Bounds(0,0,FDIB.DIB.Width,FDIB.DIB.Height),FDIB.DIB.Canvas,0,1);
  end else
  begin
    FDIB.DIB.Canvas.Brush.Color := clBlack;
    FDIB.DIB.Canvas.FillRect(FDIB.DIB.Canvas.ClipRect);
  end;
  Rotate3dPoint(F3dCursor2,FAngleX,FAngleY,FAngleZ);
  Inc(FCnt3,1);
  If FCnt3>(FTotColors*FColorRate2) then FCnt3:=0;
  FCnt1:=FCnt3*FColorRate div FColorRate2;
  For k:=0 to FTotalLines do
    begin
      Inc(FCnt1,1);
      If FCnt1>(FTotColors*FColorRate) then FCnt1:=0;

      FCol1:=trunc(FCnt1/FColorRate);
      FCnt2:=FCnt1-(FCol1*FColorRate);
      FCol2:=FCol1+1;
      If FCol2>5 then FCol2:=0;

      t1:=(GetRValue(FColors[FCol2])*FCnt2+GetRValue(FColors[FCol1])*(FColorRate-FCnt2)) div FColorRate;
      t2:=(GetGValue(FColors[FCol2])*FCnt2+GetGValue(FColors[FCol1])*(FColorRate-FCnt2)) div FColorRate;
      t3:=(GetBValue(FColors[FCol2])*FCnt2+GetBValue(FColors[FCol1])*(FColorRate-FCnt2)) div FColorRate;

      Rotate3dPoint(F3dLine[k].First,FAngleX,FAngleY,FAngleZ);
      Rotate3dPoint(F3dLine[k].Second,FAngleX,FAngleY,FAngleZ);
      FPoint1:=Vox2Point(F3dLine[k].First);
      FPoint2:=Vox2Point(F3dLine[k].Second);
      If (FPoint1.X>0) and (FPoint1.X<imgArea.Width) and
         (FPoint1.Y>0) and (FPoint1.Y<imgArea.Height) and
         (FPoint2.X>0) and (FPoint2.X<imgArea.Width) and
         (FPoint2.Y>0) and (FPoint2.Y<imgArea.Height) then
         FDIB.DIB.FilterLine(FPoint1.X,FPoint1.Y,FPoint2.X,FPoint2.Y,RGB(t1, t2,t3),fmNormal);
    end;

  FDIB.DIB.DrawOn(FDIB.DIB.Canvas,imgArea.ClientRect,imgArea.Surface.Canvas,0,0);
  imgArea.Surface.Canvas.Release;

  with imgArea.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clWhite;
    Font.Size := 12;
    Textout(0, 0, 'FPS: '+inttostr(DXTimer1.FrameRate));
    if doHardware in imgArea.NowOptions then
      Textout(0, 14, 'Device: Hardware')
    else
      Textout(0, 14, 'Device: Software');

    Release; {  Indispensability  }
  end;
  imgArea.Flip;
end;

end.
