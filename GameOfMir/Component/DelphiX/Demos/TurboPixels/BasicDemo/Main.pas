unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, { Dialogs,}
  DXClass, ExtCtrls, DXDraws, StdCtrls, Dib, turbopixels;

const
  frameskip = 1;

type
  TMainForm = class(TDXForm)
    DXDraw: TDXDraw;
    DXTimer: TDXTimer;
    DXImageList: TDXImageList; // the images are loaded in the resource
    image: TImage;
    Label1: TLabel;
    res: TComboBox;
    bevel: TBevel;
    nfo: TMemo;
    go: TButton;
    url: TLabel;
    flip: TCheckBox;
    Label2: TLabel;
    demo: TComboBox; // used to be a TURLLabel
    procedure FormCreate(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure goClick(Sender: TObject);
    procedure DXDrawFinalize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
  private
    color: integer;
    alpha: byte;
    mx, my: integer; // mouse co-ords
    kup, kdown, kleft, kright: boolean; // basic keyboard input
    AWidth, AHeight, ABitCount: Integer;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DXImageList.Items.MakeColorTable; // if you use 256 color images for everything
  DXDraw.ColorTable := DXImageList.Items.ColorTable; // use this for a glogal palette
  DXDraw.DefColorTable := DXImageList.Items.ColorTable;
  DXDraw.UpdatePalette;
  res.ItemIndex := 7; // set default resolution
  demo.ItemIndex := 0; // default demo
  randomize;
end;

procedure TMainForm.DXDrawInitialize(Sender: TObject);
begin
  DXTimer.Enabled := True; // start game thread
  DxDraw.Cursor := crnone;
end;

procedure TMainForm.goClick(Sender: TObject);
var
  s: string;
  i: Integer;
begin
  nfo.Hide; // hide everything else on the form
  image.hide; // should have put everything on a
  label1.hide; // panel and hid that
  res.hide;
  go.hide;
  url.hide;
  bevel.hide;
  flip.Hide;
  demo.hide;
  mainform.BorderStyle := bsNone; // use this to go from launch form
  Dxdraw.Align := alClient; // to full screen
  if flip.Checked then
  begin
    Dxdraw.Options := Dxdraw.Options + [doFlip]; // flip page
    Dxdraw.Options := Dxdraw.Options + [doWaitVBlank]; // wait retrace
  end;

  s := res.Items.Strings[res.Itemindex];
  i := Pos('x', s);
  AWidth := StrToInt(Copy(s, 1, i - 1)); // get width
  s := Copy(s, i + 1, Length(s));
  i := Pos('x', s);
  AHeight := StrToInt(Copy(s, 1, i - 1)); // get height
  s := Copy(s, i + 1, Length(s));
  ABitCount := StrToInt(s); // and bit count
  DXDraw.Display.Width := AWidth;
  DXDraw.Display.Height := AHeight;
  DXDraw.Display.BitCount := ABitCount;

  Dxdraw.Initialize; //  set all that up yourself then INIT
end;

procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
  DXTimer.Enabled := False;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then // or you could go back to the launch pad
    Close;

  if (ssAlt in Shift) and (Key = VK_RETURN) then //  Screen mode change
  begin
    DXDraw.Finalize; // basic ALT-ENTER stuff
    if doFullScreen in DXDraw.Options then
    begin
      RestoreWindow;
      DXDraw.Cursor := crDefault;
      BorderStyle := bsSizeable;
      DXDraw.Options := DXDraw.Options - [doFullScreen];
    end
    else
    begin
      StoreWindow;
      DXDraw.Cursor := crNone;
      BorderStyle := bsNone;
      DXDraw.Options := DXDraw.Options + [doFullScreen];
    end;
    DXDraw.Initialize;
  end;
  if Key = VK_up then kup := true; // *** scroll up ***
  if Key = VK_down then kdown := true; // *** scroll down ***
  if Key = VK_right then kright := true; // *** scroll right ***
  if Key = VK_left then kleft := true; // *** scroll left ***
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_up then kup := false; // *** scroll up ***
  if Key = VK_down then kdown := false; // *** scroll down ***
  if Key = VK_right then kright := false; // *** scroll right ***
  if Key = VK_left then kleft := false; // *** scroll left ***
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
var x, y: integer;
begin
  if not DXDraw.CanDraw then Exit;
  mx := Mouse.CursorPos.x;
  my := Mouse.CursorPos.y;

  case demo.ItemIndex of

    0: begin // put pixel
        DXDraw.Surface.Fill(0); // clear screen
        turboLock(DXDraw.Surface);
        case dxdraw.Surface.BitCount of
          8: for x := 0 to (aWidth - 1) do
              for y := (aHeight div 2) - 50 to (aHeight div 2) + 50 do // letter boxed
                turboSetPixel8A(x, y, random(255));
          16: for x := 0 to (aWidth - 1) do
              for y := (aHeight div 2) - 50 to (aHeight div 2) + 50 do // letter boxed
                turboSetPixel16A(x, y, rgb(random(255), random(255), random(255)));
//                turboSetPixel16A(x, y, $ffffff);  // true fill speed without RGB API function
          24: for x := 0 to (aWidth - 1) do
              for y := (aHeight div 2) - 50 to (aHeight div 2) + 50 do // letter boxed
                turboSetPixel24A(x, y, rgb(random(255), random(255), random(255)));
//                turboSetPixel24A(x, y, $ffffff);  // true fill speed without RGB API function
        end; // case
        turboUnlock;
      end;

    1: begin // put and get
        DXDraw.Surface.Fill(0); // clear screen
        with DXImageList.items.find('turbologo') do
          draw(DXDraw.Surface, (awidth - width) div 2, (aheight - height) div 2, 0);
        turboLock(DXDraw.Surface);
        case dxdraw.Surface.BitCount of
          8: for x := 0 to (aWidth - 1) do
              for y := (aHeight div 2) - 50 to (aHeight div 2) + 50 do // letter boxed
                turboSetPixel8(x, y,
                  turboGetPixel8(x + random(2) - 1, y + random(2) - 1));
          16: for x := 0 to (aWidth - 1) do
              for y := (aHeight div 2) - 50 to (aHeight div 2) + 50 do // letter boxed
              begin
                color := turboGetPixel16(x, y);
                turboSetPixel16RGB(x + random(2) - 1, y + random(2) - 1,
                  r16(color), g16(color), b16(color));
              end;
          24: for x := 0 to (aWidth - 1) do
              for y := (aHeight div 2) - 50 to (aHeight div 2) + 50 do // letter boxed
              begin
                color := turboGetPixel24(x, y);
                turboSetPixel24RGB(x + random(2) - 1, y + random(2) - 1,
                  r24(color), g24(color), b24(color));
              end;
        end; // case
        turboUnlock;
      end;

    2: begin // put alpha
        DXDraw.Surface.Fill(0); // clear screen
        with DXImageList.items.find('turbologo') do
          draw(DXDraw.Surface, (awidth - width) div 2, (aheight - height) div 2, 0);
        turboLock(DXDraw.Surface);
        case dxdraw.Surface.BitCount of
          16: for x := 0 to (aWidth - 1) do
              for y := (aHeight div 2) - 50 to (aHeight div 2) + 50 do // letter boxed
                turboSetPixelAlpha16(x, y, RGB(random(255), random(255), random(255)), alpha);
          24: for x := 0 to (aWidth - 1) do
              for y := (aHeight div 2) - 50 to (aHeight div 2) + 50 do // letter boxed
                turboSetPixelAlpha24(x, y, RGB(random(255), random(255), random(255)), alpha);
        end; // case
        inc(alpha, 8);
        turboUnlock;
      end;

    3: begin // Wu Lines
        DXDraw.Surface.Fill(0); // clear screen
        with DXImageList.items.find('turbologo') do
          draw(DXDraw.Surface, (awidth - width) div 2, (aheight - height) div 2, 0);
        turboLock(DXDraw.Surface);
        case dxdraw.Surface.BitCount of
          16: begin
              turboWuLine16(mx, my,
                (aWidth div 2), (aheight div 2),
                192, 192, 192);
              turboWuLine16(mx, my + 8,
                (aWidth div 2), (aheight div 2),
                192, 192, 192);
              turboWuLine16(mx, my - 8,
                (aWidth div 2), (aheight div 2),
                192, 192, 192);
            end;
          24: begin
              turboWuLine24(mx, my,
                (aWidth div 2), (aHeight div 2),
                192, 192, 192);
              turboWuLine24(mx, my + 8,
                (aWidth div 2), (aHeight div 2),
                192, 192, 192);
              turboWuLine24(mx, my - 8,
                (aWidth div 2), (aHeight div 2),
                192, 192, 192);
            end;
        end; // case
        inc(alpha);
        turboUnlock;
      end;
  end; // case

  turbowrite(dxdraw.Surface, DXImageList, 'font',
    'FPS: ' + inttostr(dxtimer.FrameRate), 10, 10);
  DXImageList.items.find('mouse').draw(DXDraw.Surface, mx, my, 0);
  DXDraw.Flip; // show screen
end;

end.

