unit main;

//  example for TDXScroll unit
//  Copyright by Pawel Sulkowski '2000
//  http://coders.shnet.pl/klub/
//  Code: Sulek       sulek@shnet.pl
//  Last changes 29.12.2000
//  Please leave information about the author even if you change something

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, dxscroll, DXClass, DIB, ScreenShoot;

const
  SCROLL_TEXT = 'scroll_text.txt';
  SCROLL_IMAGE = 'image.bmp';

type
  TmainForm = class(TDXForm)
    DXDraw: TDXDraw;
    DXTimer: TDXTimer;
    DXImageList: TDXImageList;
    procedure DXDrawInitialize(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure DXDrawFinalize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    Speed: integer;
    Scroll: TDXScroll;
    Warp: boolean;
    sens, freq: integer;
    FAngle, RotateSpeed: integer;
    Rotate, Alpha, Cursor: boolean;
    LastSpeed: integer;
    Sulek_logo: boolean;
  public
    { Public declarations }
  end;

var
  mainForm: TmainForm;

implementation

uses gfx;

{$R *.DFM}

procedure TmainForm.DXDrawInitialize(Sender: TObject);
begin
  // demo options
  Speed:= -1;
  Warp:= false;
  sens:= 3;
  freq:= 30;
  FAngle:= 0;
  RotateSpeed:= 4;
  Rotate:= true;
  Alpha:= true;
  Cursor:= false;
  Sulek_logo:= true;
  DXDraw.Cursor:= crNone;

  // TDXSCROLL INITIALIZE
  Scroll:= TDXScroll.Create(DXDraw, 7, 50, 100);
  with Scroll do
  begin
//    UpMargin:= 100;
    AddBitmap(SCROLL_IMAGE);
    if not LoadTextFromFile(SCROLL_TEXT) then
    begin
      MessageBox(Handle, 'Error while reading text scroll file', '[ERROR]', 0);
      Close;
    end;
    AddBitmap(SCROLL_IMAGE);
  end;
  DXTimer.Enabled:= True;
end;

procedure TmainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
var
  FAlpha: integer;
begin
  if Warp then
    Scroll.Warp(sens, freq);

  // call scrolling function
  Scroll.Scroll(0, Speed);

  // clear screen
  ClearScreen(DXDraw);

  if Sulek_logo then
  begin
   DXImageList.Items[1].Draw(DXDraw.Surface,
        DXDraw.Surface.Width - 200, DXDraw.Surface.Height-100,0);
  end;


  // rotate bitmap
  if Rotate then
  begin
    if Alpha then
    begin
      FAlpha:= Trunc(cos256(FAngle)*126+127);
      DXImageList.Items[0].DrawRotateAlpha(
         DXDraw.Surface, DXDraw.Surface.Width div 2, DXDraw.Surface.Height div 2,
         320, 90, 0, 0.5, 0.5, FAngle, FAlpha);
    end else
      DXImageList.Items[0].DrawRotate(
         DXDraw.Surface, DXDraw.Surface.Width div 2, DXDraw.Surface.Height div 2,
         320, 90, 0, 0.5, 0.5, FAngle);

   end;

  Inc(FAngle,RotateSpeed);

  // draw scroll
  Scroll.Draw;

  // information window
  PutText(DXDraw, DXDraw.Width - 150, 10, 'Information: ');
  PutText(DXDraw, DXDraw.Width - 150, 20, 'FPS ' + IntToStr(DXTimer.FrameRate));
  PutText(DXDraw, DXDraw.Width - 150, 30, 'Scroll speed ' + IntToStr(Speed));
  if Warp then
  begin
    PutText(DXDraw, DXDraw.Width - 150, 50, 'Warp effect is ON');
    PutText(DXDraw, DXDraw.Width - 150, 60, 'Warp sensitivity ' + IntToStr(sens));
    PutText(DXDraw, DXDraw.Width - 150, 70, 'Warp frequency ' + IntToStr(freq));
  end else
    PutText(DXDraw, DXDraw.Width - 150, 50, 'Warp effect is OFF');

  if Rotate then
  begin
    PutText(DXDraw, DXDraw.Width - 150, 80,  'Rotate effect is ON');
    PutText(DXDraw, DXDraw.Width - 150, 90,  'Rotate speed ' + IntToStr(RotateSpeed));
    if Alpha then
    begin
      PutText(DXDraw, DXDraw.Width - 150, 100, 'Alpha is ON');
      PutText(DXDraw, DXDraw.Width - 150, 110, 'Alpha is ' + IntToStr(FAlpha));
    end else
      PutText(DXDraw, DXDraw.Width - 150, 100, 'Alpha is OFF');
  end else
    PutText(DXDraw, DXDraw.Width - 150, 80, 'Rotate effect is OFF');


  PutText(DXDraw, DXDraw.Width - 150, 120, 'X ' + IntToStr(Scroll.X) +  ' Y '+ IntToStr(Scroll.Y));

  if Sulek_logo then
    PutText(DXDraw, DXDraw.Width - 150, 140,  'SULEK logo is ON')
  else
    PutText(DXDraw, DXDraw.Width - 150, 140, 'SULEK logo is OFF');


  PutText(DXDraw, DXDraw.Width - 150, 160, 'Date ' + DateToStr(Date));
  PutText(DXDraw, DXDraw.Width - 150, 170, 'Time ' + TimeToStr(Time));

  PutText(DXDraw, DXDraw.Width - 150, 220, 'Copyright by Pawel Sulkowski');
  PutText(DXDraw, DXDraw.Width - 150, 230, 'Sulek Software 2000 [r]');
  PutText(DXDraw, DXDraw.Width - 150, 240, 'sulek@shnet.pl');
  PutText(DXDraw, DXDraw.Width - 150, 250, 'http://coders.shnet.pl/klub/');
  PutText(DXDraw, DXDraw.Width - 150, 260, 'http://coders.shnet.pl/delphix/');

  // release surface
  ReleaseToScreen(DXDraw);
end;

procedure TmainForm.DXDrawFinalize(Sender: TObject);
begin
  DXTimer.Enabled:= false;
end;

procedure TmainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ScreenS: TScreenShoot;  
begin
  //  Rotate options
  if Key= ord('R') then
    Rotate:= not Rotate;

  if Key= ord('E') then
    Inc(RotateSpeed);

  if Key= ord('T') then
    Dec(RotateSpeed);

  if Key= ord('F') then
    Alpha:= not Alpha;


  //  Warp options
  if Key= ord('W') then
    Warp:= not Warp;

  if Key= ord('A') then
    Inc(sens);

  if Key= ord('Z') then
    Dec(sens);

  if Key= ord('S') then
    Inc(sens);

  if Key= ord('X') then
    Dec(sens);

  //  Speed options
  if Key=VK_UP then
    Dec(Speed);

  if Key=VK_DOWN then
    Inc(Speed);

  if Key=VK_SPACE then
  begin
    if Speed = 0 then
      Speed:= LastSpeed
    else begin
      LastSpeed:= Speed;
      Speed:= 0;
    end;
  end;

  // SULEK LOGO
  if Key= Ord('L') then
    Sulek_Logo:= not Sulek_logo;

  // X position
  if Key=VK_LEFT then
    Dec(Scroll.X, 2);

  if Key=VK_RIGHT then
    Inc(Scroll.X, 2);

  // Cursor
  if Key= Ord('C') then
  begin
    Cursor:= not Cursor;
    if Cursor then
      DXDraw.Cursor:= crDefault
    else
      DXDraw.Cursor:= crNone;
  end;

  //  Application end
  if Key=VK_ESCAPE then
    Close;

  // Screen mode change
  if (ssAlt in Shift) and (Key=VK_RETURN) then
  begin
    DXDraw.Finalize;

    if doFullScreen in DXDraw.Options then
    begin
      DXDraw.Cursor := crDefault;
      BorderStyle := bsSizeable;
      DXDraw.Options := DXDraw.Options - [doFullScreen];
    end else
    begin
      DXDraw.Cursor := crNone;
      BorderStyle := bsNone;
      DXDraw.Options := DXDraw.Options + [doFullScreen];
    end;

    DXDraw.Initialize;
  end;

  // SCREENSHOTS
  if Key = VK_F2 then
  try
    ScreenS:= TScreenShoot.Create('screen', 0, '.jpg');
    ScreenS.Make(DXDraw);
  finally
    ScreenS.Free;
  end;

end;

end.
