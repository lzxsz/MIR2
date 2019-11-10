unit ms;
{
Additional DelphiX Samples: Moving Screen

By:                     Maarten van Gompel (Proycon)
                        THEMA Corporation
Email:                  themacorp@usa.net
Homepage:               http://thema.cjb.net
Date:                   February 15, 1999

Description:

This DelphiX Sample will show you how to work with
sprites,animation, collision and a moving screen, meaning that
the player will always stay in the center and the world will move
around that center. The goal of this little game is to avoid being hit
by the red balls and to capture the four green balls that are hidden
in the field.
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXSounds, DXSprite, DXClass, DXInput, DXDraws, ExtCtrls;

type
  TForm1 = class(TForm)
    DXDraw1: TDXDraw;
    DXImageList1: TDXImageList;
    DXInput1: TDXInput;
    DXTimer1: TDXTimer;
    DXSpriteEngine1: TDXSpriteEngine;
    DXWaveList1: TDXWaveList;
    DXSound1: TDXSound;
    Timer1: TTimer;
    procedure DXDraw1Initialize(Sender: TObject);
    procedure DXDraw1Finalize(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
    procedure DXSpriteEngine1Items0Move(Sender: TObject;
      var MoveCount: Integer);
    procedure DXSpriteEngine1Items0Collision(Sender: TObject;
      var Done: Boolean);
    procedure DXSpriteEngine1Items1Move(Sender: TObject;
      var MoveCount: Integer);
  private
    { Private declarations }
    Found: Integer;
    Seconds: Integer;
    Died: Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Const
  ccPlayer = 32;
  ccTarget = 16;
  ccObstacle = 0;

procedure TForm1.DXDraw1Initialize(Sender: TObject);
begin
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
  //Update the DXInputComponent so we can receive new input
  DXInput1.Update;

  //Erase the background and make it black again
  DXDraw1.Surface.Fill(0);

  //Move all sprites, this method will call all DoMove methods of the SpriteEngine's sprites
  DXSpriteEngine1.Move(1);

  //Process all dead sprites
  DXSpriteEngine1.Dead;

  //Draw all sprites onto the screen
  DXSpriteEngine1.Draw;

  //Keep track of the time
  with DXDraw1.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Size := 12;
    Font.Color := clRed;
    TextOut(0,0,'Time: ' + IntToStr(Seconds));
    //Display message when you're dead
    If Died Then
    begin
      DXTimer1.Enabled := False;
      Timer1.Enabled := False;
      Font.Size := 26;
      Font.Color := clYellow;
      TextOut(320,240,'You lost');
    end;
    //Display message when you've won (found all four green balls)
    If Found = 4 Then
    begin
      DXTimer1.Enabled := False;
      Timer1.Enabled := False;
      Font.Size := 26;
      Font.Color := clYellow;
      TextOut(320,240,'You won!');
    end;
    Release;
  end;

  //Flip buffers so the result becomes visible to the user
  DXDraw1.Flip;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  //Randomize so we get real random numbers
  Randomize;
  //Create the player with the DXSpriteEngineComponent
  With DXSpriteEngine1.Items.Find('Player').Sprite as TImageSprite Do Begin
    Image := DXImageList1.Items.Find('GreenBall'); //Set the image to the Green Ball in our ImageList
    Width := Image.Width; //Set the size to the size of the image
    Height := Image.Height;
    X := DXDraw1.SurfaceWidth Div 2; //Set the position to the center of the screen
    Y := DXDraw1.SurfaceHeight Div 2;
    Tag := ccPlayer;
  End;
  //And now let's create 300 red balls, the obstacles...
  for i := 1 To 300 do
  begin
   with DXSpriteEngine1.Items.Add do begin
     Name := Format('Obstacle%d',[I]);
     KindSprite := stImageSprite;
     With Sprite as TImageSprite Do Begin
       Image := DXImageList1.Items.Find('RedBall');
       Width := Image.Width;
       Height := Image.Height;
       X := Random(4000) - 2000;
       Y := Random(4000) - 2000;
       Tag := ccObstacle;
       OnMove := DXSpriteEngine1Items1Move
     End;
   end;
  end;

  //And finally we create the 4 Green target's we've gotta find
  for i := 1 To 4 do
  begin
    with DXSpriteEngine1.Items.Add do begin
      Name := Format('Target%d',[I]);
      KindSprite := stImageSprite;
      With Sprite as TImageSprite Do Begin
        Image := DXImageList1.Items.Find('GreenBall');
        Width := Image.Width;
        Height := Image.Height;
        X := Random(4000) - 2000;
        Y := Random(4000) - 2000;
        Tag := ccTarget;
      End;
    end;
  end;

end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  //Quit when ESCAPE (ASCII 27) is pressed
  If Ord(Key) = 27 Then Form1.Close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  //Increase time
  Inc(Seconds);
end;

procedure TForm1.DXSpriteEngine1Items0Move(Sender: TObject;
  var MoveCount: Integer);
begin
  With Sender As TImageSprite Do Begin
    //Process Input
    If isUp in Form1.DXInput1.States Then
     Y := Y - 10;
    If isDown in Form1.DXInput1.States Then
     Y := Y + 10;
    If isLeft in Form1.DXInput1.States Then
     X := X - 10;
    If isRight in Form1.DXInput1.States Then
     X := X + 10;

    //Check for collision, when a collision is detected the TPlayer.DoCollision method will be executed
    Collision;

    //Now we're going to make sure we always stay in the center of the screen and we make the world move around us.
    //The Engine.X and Engine.Y properties are the Top-Left coordinates of the screen...
    DXSpriteEngine1.Engine.X := -X + Engine.Width div 2 - Width div 2;
    DXSpriteEngine1.Engine.Y := -Y + Engine.Height div 2 - Height div 2;

  End;
end;

procedure TForm1.DXSpriteEngine1Items0Collision(Sender: TObject;
  var Done: Boolean);
begin
  //We've collided!

  //Check whether we've collided with an obstacle (the red balls)
  With (Sender as TImageSprite) do Begin
    If tag = ccObstacle Then
    begin
      //We have, play some sound effect and kill the player sprite
      Form1.DXWaveList1.Items.Find('Destroyed').Play(False);
      Died := True; //This is our self-made Died variable which indicated whether we're dead or alive
      Dead; //This action tells the SpriteEngineComponent we are dead and that our Sprite has to be removed
    end;

    //Check wheter we've collided with one of the 4 green balls (the target)
    If Tag = ccTarget Then
    begin
      //Yeah, we have! Increase the Found variable now
      Inc(Found);
      Form1.DXWaveList1.Items.Find('Score').Play(False); //Play some happy sound effect
      Dead; //And kill the other green sprite 'cos we've just found it
    end;
  End;
end;

procedure TForm1.DXSpriteEngine1Items1Move(Sender: TObject;
  var MoveCount: Integer);
begin
  With Sender As TImageSprite Do Begin
    //We randomly choose a direction and go that way with a random speed
    Case Random(5) of
     1: X := X + Random(20);
     2: X := X - Random(20);
     3: Y := Y + Random(20);
     4: Y := Y - Random(20);
    end;
  End;
end;

end.
