unit tb;
{
Additional DelphiX Samples: Sprite Collision

By:                     Maarten van Gompel (Proycon)
                        THEMA Corporation
Email:                  themacorp@usa.net
Homepage:               http://thema.cjb.net
Date:                   February 15, 1999

Description:

This DelphiX Sample will show you how to work with
multiple background layers and it also shows the player
can control several sprites at once. No collisions or enemies this time
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, DXSounds, DXSprite, DXClass, DXInput, DXDraws;

type
  TForm1 = class(TForm)
    DXDraw1: TDXDraw;
    DXImageList1: TDXImageList;
    DXInput1: TDXInput;
    DXTimer1: TDXTimer;
    DXSpriteEngine1: TDXSpriteEngine;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DXDraw1Initialize(Sender: TObject);
    procedure DXDraw1Finalize(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure FormCreate(Sender: TObject);
    procedure DXSpriteEngine1Items0Move(Sender: TObject;
      var MoveCount: Integer);
    procedure DXSpriteEngine1Items1Move(Sender: TObject;
      var MoveCount: Integer);
    procedure DXSpriteEngine1Items2Move(Sender: TObject;
      var MoveCount: Integer);
    procedure DXSpriteEngine1Items1Draw(Sender: TObject);
  private
    { Private declarations }
    Blend: Byte;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = 27 then Form1.Close;
  if UpperCase(Key) = 'Q' then if Blend > 15 Then Dec(Blend,16);
  if UpperCase(Key) = 'A' then if Blend <= 239 Then Inc(Blend,16);
end;

procedure TForm1.DXDraw1Initialize(Sender: TObject);
begin
//Activate Timer
  DXTimer1.Enabled := True;
end;

procedure TForm1.DXDraw1Finalize(Sender: TObject);
begin
//Deactivate Timer
  DXTimer1.Enabled := False;

end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
begin
  DXDraw1.BeginScene;
  DXDraw1.Surface.Fill(0);
//Update DXInputcomponent so we can receive new input
  DXInput1.Update;

//This time it's not required to erase the background because our deepest background layer is a non-transparent one..So it will overwrite everything automatically


//Now move the sprites, this method will execute the DoMove method of all it's sprites
  DXSpriteEngine1.Move(1);

//Draw the sprites on the screen
  DXSpriteEngine1.Draw;

  DXDraw1.EndScene;

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
      Textout(0, 28, Format('Blend: %d', [Blend]));  
    finally
      Release; {  Indispensability  }
    end;
  end;

//Flip the buffers so the player can actually see what's happening
  DXDraw1.Flip;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  Blend := 128;
//Create background layer 1
  with DXSpriteEngine1.Items.Find('Back').Sprite as TBackgroundSprite do begin
//Since we use only one tile we set the map to 1 x 1
    SetMapSize(1, 1);
//Now we set the image
    Image := DXImageList1.Items.Find('Back');
//And now the depth, this is indicated by the Z property
//The lower the number, the deeper the layer (this can also be used with normal TImageSprite Sprites)
    Z := -2;
//We say the map has to be tiled, The image has to repeat over and over
    Tile := True;
  end;

//Now we create layer 2
  with DXSpriteEngine1.Items.Find('Back2').Sprite as TBackgroundSprite do begin
    SetMapSize(1, 1);
    Image := DXImageList1.Items.Find('Back2');
    Z := -5; //A lower Z number 'cos Layer 2 has to be under Layer 1
    Tile := True;
  end;


  for i := 1 to 6 do
  begin
    //Now we create the first row of ships
    with DXSpriteEngine1.Items.Add do begin
      Name := Format('PalyerE%d', [I]);
      KindSprite := stImageSprite;
      with Sprite as TImageSprite do begin
        Image := DXImageList1.Items.Find('Player');
        Width := Image.Width;
        Height := Image.Height;
        X := 160;
        Y := i * 80;
        Tag := 1;
        OnMove := DXSpriteEngine1Items2Move
      end;
    end;
    //And we create the 2nd row of ships
    with DXSpriteEngine1.Items.Add do begin
      Name := Format('PalyerL%d', [I]);
      KindSprite := stImageSprite;
      with Sprite as TImageSprite do begin
        Image := DXImageList1.Items.Find('Player');
        Width := Image.Width;
        Height := Image.Height;
        X := 240;
        Y := i * 80;
        Tag := 1;
        OnMove := DXSpriteEngine1Items2Move
      end;
    end;
    //And the third and last row of ships
    with DXSpriteEngine1.Items.Add do begin
      Name := Format('PalyerR%d', [I]);
      KindSprite := stImageSprite;
      with Sprite as TImageSprite do begin
        Image := DXImageList1.Items.Find('Player');
        Width := Image.Width;
        Height := Image.Height;
        X := 320;
        Y := i * 80;
        Tag := 1;
        OnMove := DXSpriteEngine1Items2Move
      end;
    end;
  end;

end;

procedure TForm1.DXSpriteEngine1Items0Move(Sender: TObject;
  var MoveCount: Integer);
begin
  //Automatically move the 1st layer with a speed of 5 to the right
  with Sender as TBackgroundSprite do X := X + 5;
end;

procedure TForm1.DXSpriteEngine1Items1Move(Sender: TObject;
  var MoveCount: Integer);
begin
 //Automatically move the 2nd layer with a speed of 1 to the right, this gives a nice parralax effect since the first layer goes faster than the second, now we get the illusion of depth...
  with Sender as TBackgroundSprite do X := X + 1;
end;

procedure TForm1.DXSpriteEngine1Items2Move(Sender: TObject;
  var MoveCount: Integer);
begin
//Proccess Input
  with Sender as TImageSprite do begin
    if isLeft in Form1.DXInput1.States then
      Y := Y + 10;
    if isRight in Form1.DXInput1.States then
      Y := Y - 10;
    if isUp in Form1.DXInput1.States then
      X := X - 10;
    if isDown in Form1.DXInput1.States then
      X := X + 10;
  end;
end;

procedure TForm1.DXSpriteEngine1Items1Draw(Sender: TObject);
begin
  {enhacement for drawing tile, can be use blend or other techniques}
  {for drawing different to Draw() have to set HW turn on for better speed}
  With TBackgroundSprite(Sender) Do
    Image.DrawAlpha(DXDraw1.Surface,ChipsRect,ChipsPatternIndex,Blend);
end;

end.

