{ GrafixDX Demo3 - Line and LinePolar.  By Entity }
unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DXClass, DXDraws, Directx, DXSounds, GrafixDX;

type
  TForm1 = class(TForm)
    DXDraw1: TDXDraw;
    DXTimer1: TDXTimer;
    DXImageList1: TDXImageList;
    procedure DXDraw1Initialize(Sender: TObject);
    procedure DXDraw1Finalize(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form1: TForm1;
  MySurface: TGrafixSurface;

implementation

{$R *.DFM}


{ VARS for the BouncyLine }
var
  x1, y1, x2, y2: integer;
  dx1, dy1, dx2, dy2: integer;
  LineColor: cardinal;
  OldLineColor: cardinal;
  FlashColor: cardinal;
  rStep, gStep, bStep: extended;
  red, green, blue: byte;

procedure DrawBouncyLine;
const
  DoInit: boolean = true;
  DoFlash: boolean = false;
  FlashCtr: integer = 0;
  ctr: integer = 0;
var
  speed: integer;
  r,g,b: byte;
  rr, gg, bb: byte;
begin
  // Only have to initialise line once
  if DoInit then
  begin
    LineColor:=rgb(105,140,50);
    OldLineColor:=LineColor;
    speed:=4;
    x1:=MySurface.Width div 4;
    y1:=MySurface.Height div 4;
    x2:=MySurface.Width div 2;
    y2:=MySurface.Height div 2;
    dx1:=-speed;
    dy1:=speed;
    dx2:=speed;
    dy1:=-speed;
    FlashColor:=rgb(255,255,255);
    MySurface.GetRGB(LineColor, r,g,b);
    MySurface.GetRGB(FlashColor, rr, gg, bb);
    MySurface.GetRGB(FlashColor, red, green, blue);
    rStep:=(rr - r) div 10;
    gStep:=(gg - g) div 10;
    bStep:=(bb - b) div 10;
    DoInit:=false; // Set to false so it doesn't Init again
  end;

  // Move the line
  x1:=x1+dx1;
  y1:=y1+dy1;
  x2:=x2+dx2;
  y2:=y2+dy2;
  // If the line is out of the 'playfield' then bounce it
  if (x1<=0) or (x1>=MySurface.Width) then
  begin
    dx1:=-dx1;
    DoFlash:=true;
  end;
  if (y1<=0) or (y1>=MySurface.Height) then
  begin
    dy1:=-dy1;
    DoFlash:=true;
  end;
  if (x2<=0) or (x2>=MySurface.Width) then
  begin
    dx2:=-dx2;
    DoFlash:=True;
  end;
  if (y2<=0) or (y2>=MySurface.Height) then
  begin
    dy2:=-dy2;
    DoFlash:=true;
  end;

  if DoFlash then
  begin
    LineColor:=rgb(red, green, blue);
    FlashCtr:=FlashCtr+1;
    if FlashCtr>=3 then
    begin
      ctr:=ctr+1;
      if ctr>10 then
      begin
        LineColor:=OldLineColor;
        MySurface.GetRGB(FlashColor, red, green, blue);
        ctr:=0;
        DoFlash:=false;
      end;
      FlashCtr:=0;
      red:=red-round(rStep);
      green:=green-round(gStep);
      blue:=blue-round(bStep);
    end;
  end;

  // Draw the line
  MySurface.Line(x1,y1,x2,y2,LineColor);
end;

procedure TForm1.DXDraw1Initialize(Sender: TObject);
begin
  // Create a GrafixDX surface
  MySurface:=TGrafixSurface.Create(DXDraw1.Surface.DDraw);
  // Initialize the surface
  MySurface.Init(DXDraw1, DXImageList1, 0, 0, 0);
  MySurface.Surface:=DXDraw1.Surface;

  DXDraw1.Cursor:=crNone;

  DXTimer1.Enabled:=true;
end;

procedure TForm1.DXDraw1Finalize(Sender: TObject);
begin
  DXTimer1.Enabled:=false;

  DXDraw1.Cursor:=crDefault;

  MySurface.Free;
end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
const
  ang: extended = 0;
var
  ctr: integer;
  BlurLength: integer;
begin
  // Vital for entering FullScreen mode at runtime
  if not(DXDraw1.CanDraw) then exit;

  DXDraw1.Surface.Fill(0);

  // Clear the surface
//  MySurface.Fill(0);

  // To plot straight to the DXDraw surface (or any other surface), you can use
  // MySurface.Surface:=DXDraw1.Surface;
  // But remember to comment out 'MySurface.DrawToDXDraw()' below

  // The max it can be
  BlurLength:=255;

  // Lock the surface ready for writing
  MySurface.Lock;


  // Draw a crappy radar effect :o]
  // Replace the '100' param (length of line) below with..
  // sin((ang+ctr)*pi/180)*100+100
  // ..for a weird FX
  for ctr:=0 to BlurLength do
    MySurface.LinePolar(200, 200, ang-ctr, 100,
                        rgb(255-(ctr*(255 div BlurLength)),255-(ctr*(255 div BlurLength)),255-(ctr*(255 div BlurLength))));

  // Draw the bouncing line
  DrawBouncyLine;

  // Unlock the surface -- DO NOT FORGET TO DO THIS!!
  MySurface.Unlock;

  ang:=ang+1;

  DXDraw1.Flip;

  // Display the framerate
  Form1.Caption:='FPS:  '+inttostr(DXTimer1.FrameRate);
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then Application.Terminate;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {  Screen mode change  }
  if (ssAlt in Shift) and (Key=VK_RETURN) then
  begin
    DXDraw1.Finalize;

    if doFullScreen in DXDraw1.Options then
    begin
//      RestoreWindow;

      DXDraw1.Cursor := crDefault;
      BorderStyle := bsSizeable;
      DXDraw1.Options := DXDraw1.Options - [doFullScreen];
    end else
    begin
//      StoreWindow;

      DXDraw1.Cursor := crNone;
      BorderStyle := bsNone;
      DXDraw1.Options := DXDraw1.Options + [doFullScreen];
    end;

    DXDraw1.Initialize;
  end;
end;

end.
