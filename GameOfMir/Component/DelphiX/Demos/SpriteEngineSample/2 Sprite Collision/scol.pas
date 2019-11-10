unit scol;
{
Additional DelphiX Samples: Sprite Collision

By:                     Maarten van Gompel (Proycon)
                        THEMA Corporation
Email:                  themacorp@usa.net
Homepage:               http://thema.cjb.net
Date:                   February 15, 1999

Description:

This DelphiX Sample will show you how to work with
sprites and collisions. It also demonstrates the use of the DXWaveList Component
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXClass, DXInput, DXDraws, DXSprite, DXSounds, ExtCtrls;

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
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DXDraw1Initialize(Sender: TObject);
    procedure DXDraw1Finalize(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure DXSpriteEngine1Items0Collision(Sender: TObject;
      var Done: Boolean);
    procedure DXSpriteEngine1Items0Move(Sender: TObject;
      var MoveCount: Integer);
    procedure DXSpriteEngine1Items0GetImage(Sender: TObject;
      var Image: TPictureCollectionItem);
    procedure DXSpriteEngine1Items1GetImage(Sender: TObject;
      var Image: TPictureCollectionItem);
    procedure DXSpriteEngine1Items1Move(Sender: TObject;
      var MoveCount: Integer);
  private
    { Private declarations }
    //This variable keeps track of the time
    Seconds: Integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  
implementation

{$R *.DFM}

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  //When ESCAPE (ASCII 27) is pressed we'll quit
  If Ord(Key) = 27 Then Form1.Close;
end;

procedure TForm1.DXDraw1Initialize(Sender: TObject);
begin
  //Enable Timer on startup
  DXTimer1.Enabled := True;
end;

procedure TForm1.DXDraw1Finalize(Sender: TObject);
begin
  //Disable Timer on exit
  DXTimer1.Enabled := False;

end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
begin
  //First we update the DXInputComponent so we can receive new input
  DXInput1.Update;

  //Then we erase the background and make it black again
  DXDraw1.Surface.Fill(0);

  //Move the sprites, this call exexutes the DoMove method of it's sprites
  DXSpriteEngine1.Move(1);

  //Now we will process all dead sprites
  DXSpriteEngine1.Dead;

  //And we draw the other sprites on the screen
  DXSpriteEngine1.Draw;

  //Now we display the time that has passed
  with DXDraw1.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clRed;
    Font.Size := 12;
    TextOut(0,0, 'Time: ' + IntToStr(Seconds));
    Release;
  end;

  //And if all enemies are dead and the player is the only one left then we display the final time and we disable the Timers
  If DXSpriteEngine1.Engine.AllCount = 1 Then
  begin
    Timer1.Enabled := False;
    DXTimer1.Enabled := False;
    with DXDraw1.Surface.Canvas do
    begin
      Form1.DXWaveList1.Items.Find('Tada').Play(False);
      Brush.Style := bsClear;
      Font.Color := clYellow;
      Font.Size := 26;
      TextOut(160,220, 'Your time: ' + IntToStr(Seconds) + ' seconds');
      Release;
    end;
  end;

  //At last we flip the buffers to make the final result visible to the user
  DXDraw1.Flip;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  //Reset the time counter
  Seconds := 0;
  //Now we're gonna create the enemy, the red balls, We'll create 50 of them
  For i := 1 To 50 do
  begin
    With DXSpriteEngine1.Items.Add Do Begin
      KindSprite := stImageSprite;
      Sprite.AsSign(DXSpriteEngine1.Items.Find('EnemySprite').Sprite);
      Sprite.X := Random(DXDraw1.SurfaceWidth); //Set the Position Randomly
      Sprite.Y := Random(DXDraw1.SurfaceHeight);
      Name := Format('EnemySprite%d',[I]);
      Sprite.Tag := 0;
    End;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  //Increase the time in seconds
  Inc(Seconds);
end;

procedure TForm1.DXSpriteEngine1Items0Collision(Sender: TObject;
  var Done: Boolean);
begin
  //We're hit! If the enemy is a red ball then kill it!
  If Sender <> DXSpriteEngine1.Items.Find('MySprite') Then
  With (Sender as TImageSprite) Do
  begin
    Dead; //Kill the one who hit us!
    DXWaveList1.Items.Find('Hit').Play(False); //And play a nice wave sound
  End;
end;

procedure TForm1.DXSpriteEngine1Items0Move(Sender: TObject;
  var MoveCount: Integer);
begin
  //Look at the keys that are pressed and move to the right direction
  With Sender as TImageSprite Do Begin
    If isUp in Form1.DXInput1.States Then
    Y := Y - 15;
    If isDown in Form1.DXInput1.States Then
    Y := Y + 15;
    If isLeft in Form1.DXInput1.States Then
    X := X - 15;
    If isRight in Form1.DXInput1.States Then
    X := X + 15;

    //When we're out of the screen we pop up on the other side again
    If X > Form1.DXDraw1.SurfaceWidth Then X := 1;
    If Y > Form1.DXDraw1.SurfaceHeight Then Y := 1;
    If X <= 0 Then X := Form1.DXDraw1.SurfaceWidth - 1;
    If Y <= 0 Then Y := Form1.DXDraw1.SurfaceHeight - 1;

    //Now we're gonna check for collisions with our Green Ball, this procedure results in the execution of one or more TMySprite.DoCollision procedures...
    Collision;
  End;
end;

procedure TForm1.DXSpriteEngine1Items0GetImage(Sender: TObject;
  var Image: TPictureCollectionItem);
begin
  Image := DXImageList1.Items.Find('GreenBall');
end;

procedure TForm1.DXSpriteEngine1Items1GetImage(Sender: TObject;
  var Image: TPictureCollectionItem);
begin
  Image := DXImageList1.Items.Find('RedBall');
end;

procedure TForm1.DXSpriteEngine1Items1Move(Sender: TObject;
  var MoveCount: Integer);
begin
  If Sender <> DXSpriteEngine1.Items.Find('MySprite') Then
  With  Sender as TImageSprite do
  Begin
    //Choose a random new direction at a random time
    If (Random(30) = 15) Or (Tag = 0) Then
       Tag := Random(5);

    //Do the movement
    Case Tag of
     1: X := X + 15;
     2: X := X - 15;
     3: Y := Y + 15;
     4: Y := Y - 15;
    end;

    //If we're out of the screen we want to pop up at the other side again
    If X > Form1.DXDraw1.SurfaceWidth Then X := 1;
    If Y > Form1.DXDraw1.SurfaceHeight Then Y := 1;
    If X <= 0 Then X := Form1.DXDraw1.SurfaceWidth - 1;
    If Y <= 0 Then Y := Form1.DXDraw1.SurfaceHeight - 1;
  End
end;

end.
