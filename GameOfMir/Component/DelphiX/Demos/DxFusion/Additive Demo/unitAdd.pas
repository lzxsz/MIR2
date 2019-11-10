unit unitAdd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, DIB, DXClass, DXDraws;

CONST
  SP_AMOUNT=1000;

type TSpark=record
  X,Y,SX,SY,Age,Aging:real;
  end;

type
  TfrmMain = class(TDXForm)
    DXDraw1: TDXDraw;
    DXImageList1: TDXImageList;
    DXTimer1: TDXTimer;
    FBackBuffer: TDXDIB;
    DXDIB1: TDXDIB;
    procedure FormCreate(Sender: TObject);
    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure DXTimer2Timer(Sender: TObject; LagCount: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    HardwareSwitch: Boolean;
    { Private declarations }
    //FBackground,FSpark,FBackBuffer,FLogo,FLight:TDIBUltra;
    FSparks:array[0..SP_AMOUNT] of TSpark;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

procedure TfrmMain.WMEraseBkgnd(var m : TWMEraseBkgnd);
begin
  m.Result := LRESULT(False);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var i:integer;
begin
  HardwareSwitch := False;
  For i:=0 to SP_AMOUNT do
    With FSparks[i] do
    begin
      X:=random(Width-DXImageList1.Items.Find('Sparks').Height);
      Y:=random(DXImageList1.Items.Find('Title').Height)+(DXDraw1.Height div 2-DXImageList1.Items.Find('Title').Height);
      SX:=(random(21)-10) / 5;
      SY:=(random(21)-10) / 5;
      Age:=random(100)/100;
      Aging:=(random(10)+3)/100;
    end;
end;

procedure TfrmMain.DXTimer1Timer(Sender: TObject; LagCount: Integer);
{version in DXFusion}
var i:integer;
begin
  If NOT DXDraw1.CanDraw Then Exit;

  FBackbuffer.DIB.Assign(DXImageList1.Items.Find('Background').Picture);

  DXDIB1.DIB.Assign(DXImageList1.Items.Find('Light').Picture);
  FBackbuffer.DIB.DrawAdditive(DXDIB1.DIB,0,DXDraw1.Height div 2-DXImageList1.Items.Find('Light').Height div 2,DXImageList1.Items.Find('Light').Width,DXImageList1.Items.Find('Light').Height,255,0);
  DXDIB1.DIB.Assign(DXImageList1.Items.Find('Title').Picture);
  FBackbuffer.DIB.DrawAdditive(DXDIB1.DIB,(DXDraw1.Width-DXImageList1.Items.Find('Title').Width) div 2,(DXDraw1.Height-DXImageList1.Items.Find('Title').Height) div 2,DXImageList1.Items.Find('Title').Width,DXImageList1.Items.Find('Title').Height,255,0);

  DXDIB1.DIB.Assign(DXImageList1.Items.Find('Sparks').Picture);
  For i:=0 to SP_AMOUNT do With FSparks[i] do
    begin
      Age:=Age+Aging;
      X:=X+SX;
      SY:=SY+(1/10);
      Y:=Y+SY;

      If (Age>1) or (X<0) or (X+DXDIB1.DIB.Height>DXDRaw1.Width) or (Y<0) or (Y+DXDIB1.DIB.Height>DXDraw1.Height) then
      begin
        X:=random(DXDraw1.Width-DXDIB1.DIB.Height);
        Y:=DXDraw1.Height div 2-DXImageList1.Items.Find('Title').Height+random(DXImageList1.Items.Find('Title').Height);
        SX:=(random(21)-10) / 5;
        SY:=(random(21)-10) / 5;
        Age:=0;
        Aging:=(random(10)+1)/50;
      end;

      FBackBuffer.DIB.DrawAdditive(DXDIB1.DIB,round(X),round(Y),DXDIB1.DIB.Height,DXDIB1.DIB.Height,255,ROUND(Age*4));
    end;

  FBackBuffer.DIB.DrawOn(FBackBuffer.DIB.Canvas, DXDraw1.ClientRect,DXDraw1.Surface.Canvas,0,0);
  { Draw FrameRate }
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

procedure TfrmMain.DXTimer2Timer(Sender: TObject; LagCount: Integer);
{version in pure DelphiX}
Var
  i,x,y, lw, lh, _tw, _th, _sw, _sh: Integer;
  R: TRect;
  T: TPictureCollectionItem;
begin
  If NOT DXDraw1.CanDraw Then Exit;
  DXDraw1.Surface.Fill(clBlack);
  DXImageList1.Items.Find('Background').Draw(DXDraw1.Surface,0,0,0);

  With DXImageList1.Items.Find('Light') Do
  Begin
    lh := Height;
    lw := Width;
    x := 0;
    y := DXDraw1.Height div 2 - lh div 2;
    R := Rect(x,y,x+lw,y+lh);
    DrawAdd(DXDraw1.Surface,R,0)
  End;

  With DXImageList1.Items.Find('Title') Do
  Begin
    _tw := Width;
    _th := Height;
    x := (DXDraw1.Width-_tw) div 2;
    y := (DXDraw1.Height-_th) div 2;
    R := Rect(x,y,x+_tw,y+_th);
    DrawAdd(DXDraw1.Surface,R,0);
  End;

  T := DXImageList1.Items.Find('Sparks');

  _sw := T.Width;
  _sh := T.Height;
  For i:=0 to SP_AMOUNT do
  With FSparks[i] do
  begin
    Age:=Age+Aging;
    X:=X+SX;
    SY:=SY+(1/10);
    Y:=Y+SY;

    If (Age>1) or (X<0) or (X+_sw>Width) or (Y<0) or (Y+_sh>Height) then
    begin
      X:=random(Width-_sh);
      Y:=DXDraw1.Height div 2-_th+random(_th);
      SX:=(random(21)-10) / 5;
      SY:=(random(21)-10) / 5;
      Age:=0;
      Aging:=(random(10)+1)/50;
    end;

    R := Rect(round(X),round(Y),round(X)+_sh,round(Y)+_sh);

    T.DrawAdd(DXDraw1.Surface,R,ROUND(Age*4));
  end;

    { Draw FrameRate }
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
End;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {  Application end  }
  if Key=VK_ESCAPE {ESC} then
    Close;
  if Key=VK_SPACE {mezernik} then Begin
    DXDraw1.Finalize;
    HardwareSwitch := NOT HardwareSwitch;
    If NOT HardwareSwitch Then
    {hardware}
    Begin
      If NOT (doDirectX7Mode in DXDraw1.Options) Then
        DXDraw1.Options := DXDraw1.Options + [doDirectX7Mode];
      if NOT (doHardware in DXDraw1.Options) then
        DXDraw1.Options := DXDraw1.Options + [doHardware];
      if NOT (do3D in DXDraw1.Options) then
        DXDraw1.Options := DXDraw1.Options + [do3D];
      if doSystemMemory in DXDraw1.Options then
        DXDraw1.Options := DXDraw1.Options - [doSystemMemory];
    End
    Else
    {software}
    Begin
      if do3D in DXDraw1.Options then
        DXDraw1.Options := DXDraw1.Options - [do3D];
      if doHardware in DXDraw1.Options then
        DXDraw1.Options := DXDraw1.Options - [doHardware];
      if NOT (doSystemMemory in DXDraw1.Options) then
        DXDraw1.Options := DXDraw1.Options + [doSystemMemory];
      If doDirectX7Mode in DXDraw1.Options Then
        DXDraw1.Options := DXDraw1.Options - [doDirectX7Mode];
    End;

    DXDraw1.Initialize;

    Exit;
  End;
  {  Screen mode change  }
  if (ssAlt in Shift) and (Key=VK_RETURN) {ALT+ENTER} then
  begin
    DXDraw1.Finalize;

    if doFullScreen in DXDraw1.Options then
    begin
      RestoreWindow;

      DXDraw1.Cursor := crDefault;
      BorderStyle := bsSingle;
      DXDraw1.Options := DXDraw1.Options - [doFullScreen];
      DXDraw1.Options := DXDraw1.Options + [doFlip];
    end else
    begin
      StoreWindow;

      DXDraw1.Cursor := crNone;
      BorderStyle := bsNone;
      DXDraw1.Options := DXDraw1.Options + [doFullScreen];
      DXDraw1.Options := DXDraw1.Options - [doFlip];
    end;

    DXDraw1.Initialize;
  end;
end;

end.
