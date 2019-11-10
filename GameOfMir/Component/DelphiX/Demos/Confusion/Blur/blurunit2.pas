/// .------------------------------------------------------.
/// |                 B L U R / F I R E , (v1.3)           |
/// .------------------------------------------------------.
/// |  Yet another "fire"/"blur" thingy, but atleast this  |
/// |  one is my OWN! ;) Feel free to use the code in any  |
/// |  way...
/// |  Btw, when I wrote this coding I hadn't yet heard of |
/// |  any guidelines.. the coding might be messy, sorry   |
/// |  about that.                                         |
/// |                                                      |
/// |  Thanks to Brandon Moro for getting rid of that..    |
/// |  *ahum* memory leak and PLogPalette misuse ;)        |
/// |                                                      |
/// .------------------------------------------------------.
/// |   Joakim Back, email: n98joab@tycho.helsingborg.se   |
/// '------------------------------------------------------'
/// Disclaimer: This

unit blurunit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, DXClass, DIB, StdCtrls, Menus, DXDraws;

type
  TForm1 = class(TForm)
    pal1: TImage;
    pal2: TImage;
    pal3: TImage;
    pal4: TImage;
    pal5: TImage;
    Memo1: TMemo;
    pal6: TImage;
    pal7: TImage;
    timer: TTimer;
    menu: TPopupMenu;
    About1: TMenuItem;
    Exit1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure timerTimer(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
    procedure AppIdle(Sender: TObject; var Done: Boolean);
    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND; /// To avoid flicker when repaint
  public
    { Public declarations }
  end;

type TParticle = record
    X, Y, SpeedX, SpeedY: real;
  end;

const
  PARTICLE_AMOUNT = 1500; /// Number of particles
  DARK_PARTICLES = 50;
  FONT_SIZE = 36; /// Size of marquee text
  Text_Message = 'Whoopie.. look, I have actually made that blur thingy work.. So, press H to get some help how to control this beast.. Well atleast its eating CPU power ;)';

var
  Form1: TForm1;
  Bitmap1, Bitmap2: TDIB;
  Particle: array[0..PARTICLE_AMOUNT] of TParticle;
  Direction: integer;
  ThePalette: PLogPalette;
  TextOffset: integer;
  SHOW_TEXT: Boolean;
  BLUR_DECAY, BLUR_SPREAD: integer;
  PARTICLE_EFFECT: integer;
  SCREEN_WIDTH, SCREEN_HEIGHT: integer;
  X1, Y1: Integer;
  SHOW_HELP: Boolean;
  CenterRect: TRECT;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var j: integer;
  pal: integer;
  k: TColor;
begin
/// ----- Initzialise stuff -----
  RANDOMIZE;
  SCREEN_WIDTH := Width;
  SCREEN_Height := Height;
  X1 := SCREEN_WIDTH div 2;
  Y1 := SCREEN_Height div 2;
  SHOW_TEXT := true;
  SHOW_HELP := false;
  BLUR_DECAY := 2; /// Fadeout speed
  BLUR_SPREAD := 4; /// Blur value, the larger the less spread
  PARTICLE_EFFECT := 0; /// Begin with first effect
  ShowCursor(False);
  TextOffset := 400;
/// ----- The Palette... ------
  try
    GetMem(ThePalette, SizeOf(ThePalette) + 256 * SizeOf(TPaletteEntry));
    ThePalette.palNumEntries := 255;
    ThePalette.palVersion := $0300;
/// Setting palette colors to one of the pal images
    pal := random(7);
    for j := 0 to 255 do begin
      case pal of
        0: k := pal1.Canvas.pixels[0, j];
        1: k := pal2.Canvas.pixels[0, j];
        2: k := pal3.Canvas.pixels[0, j];
        3: k := pal4.Canvas.pixels[0, j];
        4: k := pal5.Canvas.pixels[0, j];
        5: k := pal6.Canvas.pixels[0, j];
        6: k := pal7.Canvas.pixels[0, j];
      end;
      ThePalette.palPalEntry[j].peRed := GetRValue(k);
      ThePalette.palPalEntry[j].peGreen := GetGValue(k);
      ThePalette.palPalEntry[j].peBlue := GetBValue(k);
      ThePalette.palPalEntry[j].peFlags := PC_RESERVED;
    end;

/// ----- The DIBbies... ------
    Bitmap1 := TDIB.Create;
    Bitmap1.SetSize(SCREEN.Width, SCREEN.Height, 8);
    Bitmap2 := TDIB.Create;
    Bitmap2.SetSize(SCREEN.Width, SCREEN.Height, 8);
  finally
    FreeMem(ThePalette, SizeOf(ThePalette) + 256 * SizeOf(TPaletteEntry));
  end;
  Bitmap1.Canvas.Pen.Color := 0;
  Bitmap1.Canvas.Pen.Width := 4;
  Bitmap1.Canvas.Brush.Style := bsClear;
  Bitmap1.Canvas.Font.Color := 192;
  Bitmap1.Canvas.Font.Size := FONT_SIZE;
  Bitmap2.Canvas.Pen.Color := 0;
  Bitmap2.Canvas.Brush.Style := bsClear;
  Bitmap2.Canvas.Pen.Width := 4;

  timer.tag := 0;
  Application.OnIdle := AppIdle;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Bitmap1.Free;
  Bitmap2.Free;

  Form1.WindowState := wsMinimized;
end;

procedure TForm1.AppIdle(Sender: TObject; var Done: Boolean);
var rx, ry, j, k, CurrentColor: integer;
  Row1, Row2A, Row2B, Row2C: PByteArray;
begin
  Done := FALSE;
  if SHOW_TEXT and (Bitmap1.Canvas.TextWidth(TEXT_MESSAGE) < TextOffset) then SHOW_TEXT := false;
  if SHOW_TEXT then begin
    Dec(TextOffset, 2);
    Bitmap1.Canvas.Font.Size := FONT_SIZE;
    Bitmap1.Canvas.Font.Color := clWhite; /// Text outline, blured later - "Glow"
    Bitmap1.Canvas.Textout(TextOffset, (240 - FONT_SIZE) div 2, TEXT_MESSAGE);
  end;
/// ----- Particles... -----
  for j := 0 to PARTICLE_AMOUNT do begin
    with Particle[j] do begin
      X := X + SpeedX;
      Y := Y + SpeedY;
      case PARTICLE_EFFECT of
        0: begin /// Weird "twirl" effect
            SpeedX := SpeedX + (SpeedY / 50);
            SpeedY := SpeedY - (SpeedX / 160);
          end;
        1: begin /// Water bubbles
            if random(100) < 20 then begin
              SpeedX := (X - X1) / 10;
              SpeedY := (Y - Y1) / 10;
            end;
            if random(100) < 10 then begin
              X := random(SCREEN_WIDTH);
              Y := random(SCREEN_HEIGHT);
              SpeedX := (X - X1) / 10;
              SpeedY := (Y - Y1) / 10;
            end;
          end;
        2: begin /// Followers
            if X > X1 then SpeedX := SpeedX - (1 / 10) * ABS(X - X1) / (ABS(X - X1) + ABS(Y - Y1));
            if X < X1 then SpeedX := SpeedX + (1 / 10) * ABS(X - X1) / (ABS(X - X1) + ABS(Y - Y1));
            if Y > Y1 then SpeedY := SpeedY - (1 / 10) * ABS(Y - Y1) / (ABS(X - X1) + ABS(Y - Y1));
            if Y < Y1 then SpeedY := SpeedY + (1 / 10) * ABS(Y - Y1) / (ABS(X - X1) + ABS(Y - Y1));
          end;
        3: begin /// Distorted Flight
            X := X + sin((45 * Y) / (180 / PI));
            Y := Y + cos((45 * X) / (180 / PI));
            SpeedX := ((X - (SCREEN_WIDTH / 2)) / 40) + ((random(401) - 200) / 50);
            SpeedY := ((Y - (SCREEN_HEIGHT / 2)) / 40) + ((random(401) - 200) / 50);
          end;
        4: begin /// Rotating
            X := X + sin((5 * Y) / (180 / PI));
            Y := Y + cos((5 * X) / (180 / PI));
          end;
        5: begin /// Christmas powder
            if random(100) < 1 then SpeedX := (SpeedX / 8);
            if random(100) < 1 then SpeedY := (SpeedY / 8);
          end;
        6: begin /// Random walk
            if random(100) < 1 then SpeedX := -SpeedX;
            if random(100) < 1 then SpeedY := -SpeedY;
          end;
        7: begin /// Nova blast
            SpeedX := SpeedX + (SpeedX / 150);
            SpeedY := SpeedY + (1 / 150);
          end;
      end;
      if (X < 1) or (X > SCREEN_WIDTH) or (Y < 0) or (Y > SCREEN_HEIGHT) or (RANDOM(200) < 1) then begin /// Outside screen? ReInit particle!
        X := X1;
        Y := Y1;
        SpeedX := (random(100) / 100) + 0.01;
        if random(101) < 50 then SpeedX := -SpeedX;
        SpeedY := (random(100) / 100) + 0.01;
        if random(101) < 50 then SpeedY := -SpeedY;
      end;
      Bitmap1.Pixels[ROUND(X), ROUND(Y)] := 255;
    end;
  end;

///----- random darknenings.. -----
  for j := 0 to DARK_PARTICLES do begin
    Rx := random(SCREEN_WIDTH);
    Ry := random(SCREEN_HEIGHT);
    CurrentColor := Bitmap1.Pixels[Rx, Ry];
    CurrentColor := CurrentColor - random(40);
    if CurrentColor < 0 then CurrentColor := 0;
    Bitmap1.Pixels[Rx, Ry] := CurrentColor;
  end;

/// ----- The Wonderfull Blur... -----
  Bitmap1.DrawOn(Bitmap1.Canvas,Clientrect, Bitmap2.canvas, 0, 0); /// Copy Bitmap1 to Bitmap2 (backbuffer)
  Bitmap1.Canvas.Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  Bitmap2.Canvas.Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  for j := 1 to SCREEN_HEIGHT - 2 do begin
    Row1 := Bitmap1.Scanline[j + Direction];
    Row2A := Bitmap2.Scanline[j - 1];
    Row2B := Bitmap2.Scanline[j];
    Row2C := Bitmap2.Scanline[j + 1];
    for k := 1 to (SCREEN_WIDTH - 2) do begin /// 3x3 Matrix Blur, BLUR_SPREAD is a multiplier of original pixel
      CurrentColor := ROUND((Row2A[k - 1] + Row2A[k] + Row2A[k + 1]
        + Row2B[k - 1] + (BLUR_SPREAD * Row2B[k]) + Row2B[k + 1]
        + Row2C[k - 1] + Row2C[k] + Row2C[k + 1]) / (8 + BLUR_SPREAD));
      if CurrentColor > BLUR_DECAY then Dec(CurrentColor, BLUR_DECAY) else CurrentColor := 0; /// Fade out pixel
      Row1[k] := CurrentColor; /// ----- Assign result to pixel -----
    end;
  end;

  if SHOW_TEXT then begin
    Bitmap1.Canvas.Font.Color := clBlack; /// Black Text on top, not blured
    Bitmap1.Canvas.Textout(TextOffset, (240 - FONT_SIZE) div 2, TEXT_MESSAGE);
  end;
  RePaint;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  Bitmap1.Canvas.Font.Color := clWhite;
  Bitmap1.Canvas.Font.Size := 12;
  if SHOW_HELP then with Bitmap1.Canvas do begin
      TextOut(20, 20, 'H - Show help');
      TextOut(20, 34, 'Q,A - Fadeout speed');
      TextOut(20, 48, 'W,S - Blur spread');
      TextOut(20, 62, 'T - Rolling text');
      TextOut(20, 76, 'E - Particle motion');
      TextOut(20, 90, 'D - Blur direction');
      TextOut(20, 108, 'Space - Random settings');
    end;
  Bitmap1.DrawOn(Bitmap1.Canvas,ClientRect, Canvas, 0, 0);
  timer.tag := timer.tag + 1;
end;

procedure TForm1.WMEraseBkgnd(var m: TWMEraseBkgnd);
begin
  m.Result := LRESULT(False);
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    chr(27): Close;
    'H', 'h': SHOW_HELP := not SHOW_HELP;
    'Q', 'q': Inc(BLUR_DECAY, 1);
    'A', 'a': Dec(BLUR_DECAY, 1);
    'W', 'w': Inc(BLUR_SPREAD, 1);
    'S', 's': Dec(BLUR_SPREAD, 1);
    'E', 'e': inc(PARTICLE_EFFECT);
    'D', 'd': inc(Direction);
    'T', 't': SHOW_TEXT := not SHOW_TEXT;
    ' ': begin /// Space - random
        BLUR_DECAY := random(10) + 1;
        BLUR_SPREAD := random(10) + 1;
        PARTICLE_EFFECT := random(5);
        DIRECTION := random(3) - 1;
      end;

  end;

/// ----- Limit checking... -----
  if DIrection > 1 then Direction := -1;
  if PARTICLE_EFFECT > 7 then PARTICLE_EFFECT := 0;
  if BLUR_DECAY < 1 then BLUR_DECAY := 1;
  if BLUR_DECAY > 10 then BLUR_DECAY := 10;
  if BLUR_SPREAD < 1 then BLUR_SPREAD := 1;
  if BLUR_SPREAD > 10 then BLUR_SPREAD := 10;

end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  X1 := X;
  Y1 := Y;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  SCREEN_WIDTH := Width;
  SCREEN_HEIGHT := Height;
end;

procedure TForm1.timerTimer(Sender: TObject);
begin
  Form1.Caption := 'Blur demo. FPS:' + IntToStr(timer.tag);
  timer.tag := 0;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  Application.MessageBox('Blur Demo 1.3 by Joakim Back.' + chr(13) + chr(13) + 'Comments and questions to n98joab@tycho.helsingborg.se', 'About', MB_OK);
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.

