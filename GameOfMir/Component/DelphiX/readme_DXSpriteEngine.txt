Examples by Events:

1a/ Initialize image of sprite

procedure TForm1.DXSpriteEngine1Items0GetImage(Sender: TObject;
  var Image: TPictureCollectionItem);
begin
  {initialize image is indispensable}
  {other way is TForm.OnCreate}
  Image := DXImageList1.Items.Find('SpriteToRight')
end;

1b/ Move event

procedure TForm1.DXSpriteEngine1Items0Move(Sender: TObject;
  var MoveCount: Integer);
begin
  {can be searched in multi move event}
  {or selected from a sender}
  With Sender as TImageSpriteEx Do Begin
    If isUp in DXInput1.States Then
      Y := Y - 10;
    If isDown in DXInput1.States  Then
      Y := Y + 10;

    If isLeft in Form1.DXInput1.States  Then
    begin
      If Image = DXImageList1.Items.Find('SpriteToRight') Then
        Image := DXImageList1.Items.Find('SpriteToLeft');
      Width := Image.Width;
      Height := Image.Height;

      X := X - 10; //move left
    end;

    If isRight in Form1.DXInput1.States  Then
    begin
      If Image = DXImageList1.Items.Find('BeeLeft') Then
        Image := DXImageList1.Items.Find('BeeRight');
      Width := Image.Width;
      Height := Image.Height;
      X := X + 10; //move right
    end;
    {reanimate() is move animation procedure from TImageSprite}
    {other way have to rewrite here youself}
    Reanimate(MoveCount) //indispensable
  End;
end;

2a/ How create multiple sprite

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  //Create 50 sprites here
  //MyEnemySprite - sprite have to exist and has all events
  For i := 1 To 50 do
  begin
    With DXSpriteEngine1.Items.Add Do Begin
      KindSprite := stImageSprite;
      Sprite.AsSign(DXSpriteEngine1.Items.Find('MyEnemySprite').Sprite);
      Sprite.X := Random(DXDraw1.SurfaceWidth); //Set the Position Randomly
      Sprite.Y := Random(DXDraw1.SurfaceHeight);
      Name := Format('EnemySprite%d',[I]); //simple name for sprite
      Sprite.Tag := 0; //for sprite you can use Tag property as well
    End;
  end;
end;

2b/ How detect collision

procedure TForm1.DXSpriteEngine1Items0Collision(Sender: TObject;
  var Done: Boolean);
begin
  //MySprite exists too once
  //For collision have to different sprite
  If Sender <> DXSpriteEngine1.Items.Find('MySprite') Then
  With (Sender as TImageSprite) Do
  begin
    Dead; //Kill MyEnemySprite here
    DXWaveList1.Items.Find('TaDa').Play(False); //Tada
  End;
end;

2c/ My sprite movement 

procedure TForm1.DXSpriteEngine1Items0Move(Sender: TObject;
  var MoveCount: Integer);
begin
  //movement
  With Sender as TImageSprite Do Begin
    If isUp in Form1.DXInput1.States Then
    Y := Y - 15;
    If isDown in Form1.DXInput1.States Then
    Y := Y + 15;
    If isLeft in Form1.DXInput1.States Then
    X := X - 15;
    If isRight in Form1.DXInput1.States Then
    X := X + 15;

    //detect limits of border
    If X > Form1.DXDraw1.SurfaceWidth Then X := 1;
    If Y > Form1.DXDraw1.SurfaceHeight Then Y := 1;
    If X <= 0 Then X := Form1.DXDraw1.SurfaceWidth - 1;
    If Y <= 0 Then Y := Form1.DXDraw1.SurfaceHeight - 1;

    //execute collision through sprites
    Collision;
  End;
end;

2d/ Chaotic move of EnemySprites

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

2d/ Images initialization

procedure TForm1.DXSpriteEngine1Items0GetImage(Sender: TObject;
  var Image: TPictureCollectionItem);
begin
  Image := DXImageList1.Items.Find('MyEnemySprite');
end;

procedure TForm1.DXSpriteEngine1Items1GetImage(Sender: TObject;
  var Image: TPictureCollectionItem);
begin
  Image := DXImageList1.Items.Find('MySprite');
end;


3a/ Backgroudsprite initialization of all

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
    //The lower the number, the deeper the layer 
    //(this can also be used with normal TImageSprite Sprites)
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


  //Sprites front of layers
  for i := 1 to 6 do
  begin
    //Now we create the first row of balls
    with DXSpriteEngine1.Items.Add do begin
      Name := Format('PlayerE%d', [I]);
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
      Name := Format('PlayerL%d', [I]);
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

3b/ Move od layers automatically

procedure TForm1.DXSpriteEngine1Items0Move(Sender: TObject;
  var MoveCount: Integer);
begin
  //Automatically move the 1st layer with a speed of 5 to the right
  with Sender as TBackgroundSprite do 
    X := X + 5;
end;

procedure TForm1.DXSpriteEngine1Items1Move(Sender: TObject;
  var MoveCount: Integer);
begin
  //Automatically move the 2nd layer with a speed of 1 to the right
  // this gives a nice parralax effect since the first layer goes faster than the second, now we get the illusion of depth...
  with Sender as TBackgroundSprite do 
    X := X + 1;
end;

3c/ Move a cluster of sprites

procedure TForm1.DXSpriteEngine1Items2Move(Sender: TObject;
  var MoveCount: Integer);
begin
  //Proccess Input
  with Sender as TImageSprite do begin
    if isLeft in DXInput1.States then
      Y := Y + 10;
    if isRight in DXInput1.States then
      Y := Y - 10;
    if isUp in DXInput1.States then
      X := X - 10;
    if isDown in DXInput1.States then
      X := X + 10;
  end;
end;

3d/

procedure TForm1.DXSpriteEngine1Items1Draw(Sender: TObject);
begin
  {enhacement for drawing tile, can be use blend or other techniques}
  {for drawing different to Draw() have to set HW turn on for better speed}
  With TBackgroundSprite(Sender) Do
    {there can be use DrawAlpha, DrawAdd or DrawSub }
    Image.DrawAlpha(DXDraw1.Surface,ChipsRect,ChipsPatternIndex,Blend);
end;

How move it in DXTimer
----------------------
  DXDraw1.BeginScene;

  DXDraw1.Surface.Fill(0);
  //Update DXInputcomponent so we can receive new input
  DXInput1.Update;
  //Now move the sprites, this method will execute the DoMove method of all it's sprites
  DXSpriteEngine1.Move(1);
  //Draw the sprites on the screen
  DXSpriteEngine1.Draw;

  DXDraw1.EndScene;

  //Flip the buffers so the player can actually see what's happening
  DXDraw1.Flip;