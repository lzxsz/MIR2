unit Sht;
{
Additional DelphiX Samples: Shooting

By:                     Maarten van Gompel (Proycon)
                        THEMA Corporation
Email:                  themacorp@usa.net
Homepage:               http://thema.cjb.net
Date:                   February 15, 1999

Description:

This DelphiX Sample will show you how to work with
shooting, it also makes use of Animation and Collision.
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, DXSounds, DXSprite, DXClass, DXInput, DXDraws;

type
  TForm1 = class(TDXForm)
    DXDraw1: TDXDraw;
    DXImageList1: TDXImageList;
    DXInput1: TDXInput;
    DXTimer1: TDXTimer;
    DXSpriteEngine1: TDXSpriteEngine;
    DXWaveList1: TDXWaveList;
    DXSound1: TDXSound;
    Timer1: TTimer;
    procedure DXDraw1KeyPress(Sender: TObject; var Key: Char);
    procedure DXDraw1Initialize(Sender: TObject);
    procedure DXDraw1Finalize(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  //This is the player class
  TPlayer = class(TImageSprite)
  private
    Fired: Integer; //This variable determines howmany bullets have been fired, you can only fire 5 bullets a second.
  public
    procedure DoMove(MoveCount: Integer); override;
  end;

  //This is the Bee class
  TBee = class(TImageSprite)
  private
    Movement: Integer; //This self-made variable determines the direction the Bee goes
    Speed: Integer; //This self-made variable determines the speed of the Bee
  public
    procedure DoMove(MoveCount: Integer); override;
  end;

  //This is the bullet class
  TBullet = class(TImageSprite)
  public
    procedure DoMove(MoveCount: Integer); override;
    procedure DoCollision(Sprite: TSprite; var Done: Boolean); override;
  end;




var
  Form1: TForm1;
  Player: TPlayer;
  Seconds: Integer;
  Bees: Integer;

implementation

{$R *.DFM}

procedure TForm1.DXDraw1KeyPress(Sender: TObject; var Key: Char);
begin
//Quit when ESCAPE (ASCII 27) is pressed
  if Ord(key) = 27 then Form1.Close;
end;

procedure TForm1.DXDraw1Initialize(Sender: TObject);
var
  i: Integer;
begin
  randomize; //Make sure all numbers are totally random

 //Create the player
  Player := TPlayer.Create(DXSpriteEngine1.Engine);
  Player.Image := DXImageList1.Items.Find('Player'); //Set it's image
  Player.X := 320; //Set the Position
  Player.Y := 420;
  Player.Width := Player.Image.Width; //And set the size
  Player.Height := Player.Image.Height;

  Bees := 30; //This variable indicates howmany Bees there are
  for i := 1 to Bees do
  begin
      //Here we create a Bee and set some of it's properties, the result is not stored 'cos we won't need it anymore after initialization...
    with TBee.Create(DXSpriteEngine1.Engine) do
    begin
      Image := DXImageList1.Items.Find('BeeRight'); //Set the Image, we let the Bee look right at startup
      X := Random(640 * 3) - 640; //Set the position Randomly
      Y := Random(300);
      Speed := Random(25) + 5; //This is a self-made variable determines the Speed of the Bee
      Width := Image.Width; //Set the width
      Height := Image.Height;
      PixelCheck := True; //By setting this variable to true we say that collisioned have to be detected exactly by matching the pixels, not using an invisible box around the sprite
      AnimCount := 2; //We have two animation frames (wings up, wings down)
      AnimLooped := True; //the animation has to play looped
      AnimSpeed := 1; //The speed of the animation has to be as fast as possible
      AnimStart := 0; //The first frame in the animation is frame 0, frames always go from 0 to AnimCount - 1
    end;
  end;


//Enable the Timer
  DXTimer1.Enabled := True;
end;

procedure TForm1.DXDraw1Finalize(Sender: TObject);
begin
//Disable the Timer
  DXTimer1.Enabled := False;
end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
begin
//Update the DXinputComponent so we can receive new input
  DXInput1.Update;

//Move the sprites, this method executes the DoMove method of all it's sprites..
  DXSpriteEngine1.Move(1);

//Erase the background, make it black again
  DXDraw1.Surface.Fill(0);

//Process Dead Sprites, dead sprites will be destroyed
  DXSpriteEngine1.Dead;

//Draw all sprites onto the screen
  DXSpriteEngine1.Draw;

//Display the time
  with DXDraw1.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Size := 12;
    Font.Color := clRed;
    TextOut(0, 0, 'Time: ' + IntToStr(Seconds) + ', Bees left: ' + IntToStr(Bees));
  //Check whether all Bees are dead
    if Bees = 0 then
    begin
  //If so, display final score
      DXTimer1.Enabled := False;
      Timer1.Enabled := False;
      DXWaveList1.Items.Find('Tada').Play(False);
      Font.Size := 26;
      Font.Color := clYellow;
      TextOut(290, 220, 'Your time: ' + IntToStr(Seconds));
    end;
    Release;
  end;

//Now we're gonna flip the buffers and make everything visible for the user
  DXDraw1.Flip;
end;

procedure TPlayer.DoMove(MoveCount: Integer);
var
  MyX: Double; //We'll need this one to store the value of X temporary
begin
//Proccess input, note that our little machine is only allowed to go left and right, not up and down
  if isLeft in Form1.DXInput1.States then
    X := X - 15;

  if isRight in Form1.DXInput1.States then
    X := X + 15;


  MyX := X; //Set Temporary variable

//Check whether button1 is pressed (SPACEBAR)
  if isButton1 in Form1.DXInput1.States then
  begin
    if Fired <= 5 then //Check whether the maximum number of bullets hasn't been fired yet
    begin
      Inc(Fired); //Increase number of fired bullets 'cos we're firing one right now

  //Create a bullet, we won't store the result 'cos we won't need it later
      with TBullet.Create(Form1.DXSpriteEngine1.Engine) do
      begin
        Image := Form1.DXImageList1.Items.Find('Bullet'); //Select the image
        X := MyX; //Set it's X pos to our current X pos
        Y := 420; //Set it's Y pos
        Width := Image.Width; //Set it's size
        Height := Image.Height;
      end;
    end;
  end;

end;

procedure TBullet.DoMove(MoveCount: Integer);
begin
//Move the bullet, always straight up with a constant speed
  Y := Y - 25;

  Collision; //This method check for collisions and if one is found the TBullet.DoCollision method is executed

//If our Bullet is out of the screen then we request the SpriteEngine to kill it...
  if Y < 0 then Dead;
end;

procedure TBullet.DoCollision(Sprite: TSprite; var Done: Boolean);
begin
//If the bullet has collided with a Bee Then...
  if (Sprite is TBee) then
  begin
//Set the Collisioned property to false so this Bee won't be able to collide again with another Bullet before all Dead sprites are proccessed by the SpriteEngine.
    Sprite.Collisioned := False;

    Sprite.Dead; //Kill the Sprite
    Bees := Bees - 1; //Decrease Bee Count number
    Dead; //Kill the bullet, it wouldn't be fair to let the bullet travel on...
    Form1.DXWaveList1.Items.Find('hit').Play(False); //Play a nice sound effect
  end;

end;

procedure TBee.DoMove(MoveCount: Integer);
begin
//Set a random direction at a random time
  if (Movement = 0) or (Random(50) = 25) then
    Movement := Random(3);

//Don't allow the Bee to go to far out of the screen
  if X > 640 * 2 then Movement := 1;
  if X < -640 then Movement := 2;

//Update Animation, this is really weird, usually it goes automatically but it didn't this time, that's why I inserted this code, if you know why it won't animate without this code then please mail me at themacorp@usa.net
  AnimPos := AnimPos + 1;
  if AnimPos = AnimCount then AnimPos := 0;

//Do the movement
  case Movement of
    1:
      begin
       //Verify the right image is active
        if Image = Form1.DXImageList1.Items.Find('BeeRight') then
          Image := Form1.DXImageList1.Items.Find('BeeLeft');
        X := X - Speed
      end;
    2:
      begin
       //Verify the right image is active
        if Image = Form1.DXImageList1.Items.Find('BeeLeft') then
          Image := Form1.DXImageList1.Items.Find('BeeRight');
        X := X + Speed
      end;
  end;

end;


procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
//Quit when Escape (ASCII 27) is pressed....
  if Ord(Key) = 27 then Form1.Close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
//Reset the Fired count so the player can fire again a salvo of 5 bullets
  Player.Fired := 0;
//Increase the time
  Inc(Seconds);
end;

end.
