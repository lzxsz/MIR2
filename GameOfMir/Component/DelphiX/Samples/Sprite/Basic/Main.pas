unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, DXClass, DXSprite, DXInput, DXDraws,
  DXSounds, MMSystem, DXWave;

type
  TMainForm = class(TDXForm)
    DXTimer: TDXTimer;
    DXDraw: TDXDraw;
    DXSpriteEngine: TDXSpriteEngine;
    DXInput: TDXInput;
    ImageList: TDXImageList;
    DXWaveList: TDXWaveList;
    DXSound: TDXSound;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure DXTimerActivate(Sender: TObject);
    procedure DXTimerDeactivate(Sender: TObject);
    procedure DXDrawClick(Sender: TObject);
  private
    FMoveMode: Boolean;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

type
  TMonoSprite = class(TImageSprite)
  private
    FCounter: Double;
    FS: Integer;
    procedure Hit;
  public
    procedure DoMove(MoveCount: Integer); override;
  end;

  TPlayerSprite = class(TImageSprite)
  protected
    procedure DoCollision(Sprite: TSprite; var Done: Boolean); override;
    procedure DoMove(MoveCount: Integer); override;
  end;

procedure TMonoSprite.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);
  PixelCheck := True;
  FCounter := FCounter + (100/1000)*MoveCount;
  X := X+Sin256(Trunc(FCounter))*(200/1000)*MoveCount;
  Y := Y+Cos256(Trunc(FCounter))*(200/1000)*MoveCount;

  if not Collisioned then
  begin
    Inc(FS, MoveCount);
    if FS>200 then Dead;
  end;
end;

procedure TMonoSprite.Hit;
begin
  Collisioned := False;

  Image := MainForm.ImageList.Items.Find('img1-2');
  MainForm.DXWaveList.Items.Find('snd').Play(False);
  MainForm.DXInput.Joystick.Effects.Find('eff1').Start;
end;

procedure TPlayerSprite.DoCollision(Sprite: TSprite; var Done: Boolean);
begin
  if Sprite is TMonoSprite then
    TMonoSprite(Sprite).Hit;
  Done := False;
end;

procedure TPlayerSprite.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);

  if (MainForm.DXInput.Joystick.X<>0) or (MainForm.DXInput.Joystick.Y<>0) then
  begin
    X := X + (MainForm.DXInput.Joystick.X/1000)*MoveCount;
    Y := Y + (MainForm.DXInput.Joystick.Y/1000)*MoveCount;
  end else
  begin
    if isUp in MainForm.DXInput.States then
      Y := Y - (300/1000)*MoveCount;

    if isDown in MainForm.DXInput.States then
      Y := Y + (300/1000)*MoveCount;

    if isLeft in MainForm.DXInput.States then
      X := X - (300/1000)*MoveCount;

    if isRight in MainForm.DXInput.States then
      X := X + (300/1000)*MoveCount;
  end;

  Collision;

  Engine.X := -X+Engine.Width div 2-Width div 2;
  Engine.Y := -Y+Engine.Height div 2-Height div 2;
end;

procedure TMainForm.DXTimerActivate(Sender: TObject);
begin
  Caption := Application.Title;
end;

procedure TMainForm.DXTimerDeactivate(Sender: TObject);
begin
  Caption := Application.Title + ' [Pause]';
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
begin
  if not DXDraw.CanDraw then exit;

  DXInput.Update;

  if FMoveMode then
    LagCount := 1000 div 60;

  DXSpriteEngine.Move(LagCount); 
  DXSpriteEngine.Dead;

  {  Description  }
  DXDraw.Surface.Fill(0);
  DXSpriteEngine.Draw;

  {  Frame rate display  }
  with DXDraw.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clWhite;
    Font.Size := 12;
    Textout(0, 0, 'FPS: '+inttostr(DXTimer.FrameRate));
    Textout(0, 24, 'Sprite: '+inttostr(DXSpriteEngine.Engine.AllCount));
    Textout(0, 48, 'Draw: '+inttostr(DXSpriteEngine.Engine.DrawCount));
    if FMoveMode then                  
      Textout(0, 72, 'Time mode: 60 FPS')
    else
      Textout(0, 72, 'Time mode: Real time');

    Release;
  end;

  DXDraw.Flip;
end;

procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
  DXTimer.Enabled := False;
end;

procedure TMainForm.DXDrawInitialize(Sender: TObject);
begin
  DXTimer.Enabled := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: Integer;
  PlayerSprite: TSprite;
begin
  Randomize;

  ImageList.Items.MakeColorTable;

  DXDraw.ColorTable := ImageList.Items.ColorTable;
  DXDraw.DefColorTable := ImageList.Items.ColorTable;
  DXDraw.UpdatePalette;

  with TBackgroundSprite.Create(DXSpriteEngine.Engine) do
  begin
    SetMapSize(1, 1);
    Image := ImageList.Items.Find('background');
    Z := -2;
    Tile := True;
  end;

  for i:=0 to 200 do
    with TMonoSprite.Create(DXSpriteEngine.Engine) do
    begin
      Image := ImageList.Items.Find('img1');
      X := Random(5000)-2500;
      Y := Random(5000)-2500;
      Z := 2;
      Width := Image.Width;
      Height := Image.Height;
      FCounter := Random(MaxInt);
    end;

  PlayerSprite := TPlayerSprite.Create(DXSpriteEngine.Engine);
  with TPlayerSprite(PlayerSprite) do
  begin
    Image := ImageList.Items.Find('img2');
    Z := 2;
    Width := Image.Width;
    Height := Image.Height;
  end;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {  Application end  }
  if Key=VK_ESCAPE then
    Close;

  {  Screen mode change  }
  if (ssAlt in Shift) and (Key=VK_RETURN) then
  begin
    DXDraw.Finalize;

    if doFullScreen in DXDraw.Options then
    begin
      RestoreWindow;

      DXDraw.Cursor := crDefault;
      BorderStyle := bsSizeable;
      DXDraw.Options := DXDraw.Options - [doFullScreen];
    end else
    begin
      StoreWindow;

      DXDraw.Cursor := crNone;
      BorderStyle := bsNone;
      DXDraw.Options := DXDraw.Options + [doFullScreen];
    end;

    DXDraw.Initialize;
  end;
end;

procedure TMainForm.DXDrawClick(Sender: TObject);
begin
  FMoveMode := not FMoveMode;
  if FMoveMode then
  begin
    DXTimer.Interval := 1000 div 60;
  end else
  begin
    DXTimer.Interval := 0;
  end;
end;

end.

