unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  { Dialogs,} ExtCtrls, StdCtrls, // Delphi
  DXClass, DXDraws, DXSounds, DIB, // DelphiX
  isoMath, turboPixels; // My stuff

const
  maxsparks = 64;
  maxsmoke = 8;
  gravity = 0.32;

type TParticle = record
    x, y: single; // co-ords
    ox, oy: single; // previous co-ords (good for streaking)
    a, life: byte; // life
    v: single; // velocity
  end;

type
  TMainForm = class(TDXForm)
    DXTimer: TDXTimer;
    DXDraw: TDXDraw;
    DXImageList: TDXImageList; // the images are loaded in the resource
    image: TImage;
    Label1: TLabel;
    res: TComboBox;
    bevel: TBevel;
    nfo: TMemo;
    go: TButton;
    url: TLabel;
    flip: TCheckBox;
    DXSound: TDXSound;
    DXWaveList: TDXWaveList;
    Particle: TComboBox;
    Label2: TLabel; // used to be a TURLLabel
    procedure FormCreate(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure goClick(Sender: TObject);
    procedure DXDrawFinalize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DXDrawMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    mx, my: integer; // mouse co-ords
    click: boolean; // click
    sparks: array[0..maxsparks] of TParticle;
    smoke: array[0..maxsparks] of TParticle;
    ispark, ismoke: byte;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  res.ItemIndex := 0; // set default resolution
  particle.ItemIndex := 0; // set particle
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
  i, AWidth, AHeight, ABitCount: Integer;
begin
  nfo.Hide; // hide everything else on the form
  image.hide; // should have put everything on a
  label1.hide; // panel and hid that
  label2.hide; // panel and hid that
  res.hide;
  particle.hide;
  go.hide;
  url.hide;
  bevel.hide;
  flip.Hide;
  mainform.BorderStyle := bsNone; // use this to go from launch form
  Dxdraw.Align := alClient; // to full screen
  if flip.Checked then
  begin
    Dxdraw.Options := Dxdraw.Options + [doFlip]; // flip page
    Dxdraw.Options := Dxdraw.Options + [doWaitVBlank]; // wait retrace
  end;

  // *** Set Screen Mode ***

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

  // reset our particle types

  for i := 0 to maxsparks do begin
    sparks[i].x := -255;
    sparks[i].y := -255;
    sparks[i].a := 0;
    sparks[i].v := 0;
    sparks[i].life := 0;
  end;

  for i := 0 to maxsmoke do begin
    smoke[i].x := -255;
    smoke[i].y := -255;
    smoke[i].a := 0;
    smoke[i].v := 0;
    smoke[i].life := 0;
  end;

  ispark := 0; ismoke := 0;

  Dxdraw.Initialize; //  set all that up yourself then INIT
  DXsound.Initialize;
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
end;

procedure TMainForm.DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DxWaveList.Items.Find('spark').Play(false);
  click := true;
end;

procedure TMainForm.DXDrawMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DxWaveList.Items.Find('spark').Stop;
  click := false;
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
var i: integer;
  dx, dy: single;
begin
  if not DXDraw.CanDraw then Exit; //  DXDraw.surface.Fill(0);

  mx := Mouse.CursorPos.x;
  my := Mouse.CursorPos.y;

  // *** spawn a spark every now and again ***

  if (random(45) = 0) then
    with sparks[ispark] do
    begin
      x := mx - 4;
      y := my - 4;
      a := random(256);
      v := random(125) / 100;
      inc(ispark);
      if ispark > maxsparks then ispark := 0; // loop record
    end;

  // *** spawn smoke all the time ***

  if (random(5) = 0) then
    with smoke[ismoke] do
    begin
      x := mx - 8;
      y := my - 12;
      a := 192;
      v := random(125) / 100;
      life := 0;
      inc(life);
      if life >= DXImageList.items.find('smoke').PatternCount then life := 0;
      inc(ismoke);
      if ismoke > maxsmoke then ismoke := 0;
    end;

  // *** spawn many sparks when a user clicks ***

  if click then
    for i := 0 to 2 do
      with sparks[ispark] do
      begin
        x := mx + 2 - random(6);
        y := my + 2 - random(6);
        a := random(256);
        v := 5 + (random(100) / 100);
        inc(ispark);
        if ispark > maxsparks then ispark := 0;

  // *** DrawSub the mouse pointer on the background ***
  // *** This gives you that "burn" effect, and yes it's ***
  // *** Only one line ;) ***

        DXImageList.items.find('mouse').drawSub(DXImageList.items.find('metal').PatternSurfaces[0],
          bounds(mx + 5 - random(15), my + 5 - random(15), 8, 8), 0, 16);
      end;

  // *** render scene ***

  if LagCount > 1 then exit; // DelphiX's built in lag tester

  // *** draw background ***

  DXImageList.items.find('metal').draw(DXDraw.Surface, 0, 0, 0);

  // *** render sparks 0 ***

  if particle.ItemIndex = 0 then
    for i := 0 to maxsparks do
      if (sparks[i].x <> -255) then
        with sparks[i] do begin
          dx := cos256(a) * v;
          dy := (sin256(a) * v) + gravity;
          x := x + dx;
          y := y + dy;
          DXImageList.items.find('spark').DrawAdd(DXDraw.Surface,
            bounds(trunc(x), trunc(y), trunc(8 - (v / 5)), trunc(8 - (v / 5))), random(8), 192 - trunc(v * 10));
          a := normArcTan256(dy, dx);
          v := sqrt((dx * dx) + (dy * dy));
        end;

  // *** render sparks 1 ***

  if particle.ItemIndex = 1 then
  begin
    turbolock(DxDraw.Surface);
    for i := 0 to maxsparks do
      if (sparks[i].x <> -255) then
        with sparks[i] do begin
          dx := cos256(a) * v;
          dy := (sin256(a) * v) + gravity;
          ox := x; // old values
          oy := y;
          x := x + dx;
          y := y + dy;
          turboWuLine16(trunc(x), trunc(y), trunc(ox), trunc(oy), 255, 192, 128);
            a := normArcTan256(dy, dx);
          v := sqrt((dx * dx) + (dy * dy));
        end;
    turbounlock;
  end;

  // *** render smoke ***

  for i := 0 to maxsmoke do
    if (smoke[i].x <> -255) then
      with smoke[i] do begin
        dx := cos256(a) * v - (gravity / 8);
        dy := (sin256(a) * v) - (gravity / 8);
        x := x + dx;
        y := y + dy;
        DXImageList.items.find('smoke').drawadd(DXDraw.Surface,
          bounds(trunc(x), trunc(y), trunc(v * 4) + 15, trunc(v * 8) + 15),
          life, trunc(255 - (255 * (life / DXImageList.items.find('smoke').PatternCount))));
        inc(life);
        if life >= DXImageList.items.find('smoke').PatternCount then begin
          life := 0;
          x := -255;
        end;
        a := normArcTan256(dy, dx);
        v := sqrt((dx * dx) + (dy * dy));
      end;

  // *** dump out framerate / mouse / flip ***

  turbowrite(DXDraw.Surface, DXImageList, 'font', 'FPS: ' + inttostr(dxtimer.framerate), 10, 10);
  DXImageList.items.find('spark').drawadd(DXDraw.Surface, bounds(mx - 4, my - 4, 8, 8), random(8), 128);
  DXDraw.Flip; // show screen
end;


end.

