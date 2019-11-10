unit SpriteAnim;
{
Additional DelphiX Samples: Sprite Animation

By:                     Maarten van Gompel (Proycon)
                        THEMA Corporation
Email:                  themacorp@usa.net
Homepage:               http://thema.cjb.net
Date:                   February 14, 1999

Description:

This DelphiX Sample will show you how to work with
sprites and animation.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXSprite, DXClass, DXInput;

type
  TForm1 = class(TDXForm)
    DXDraw2: TDXDraw;
    DXInput1: TDXInput;
    DXTimer1: TDXTimer;
    DXSpriteEngine1: TDXSpriteEngine;
    DXImageList1: TDXImageList;
    procedure DXDraw2Initialize(Sender: TObject);
    procedure DXDraw2Finalize(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DXSpriteEngine1Items0Move(Sender: TObject;
      var MoveCount: Integer);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure DXSpriteEngine1Items0GetImage(Sender: TObject;
      var Image: TPictureCollectionItem);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.DXDraw2Initialize(Sender: TObject);
begin
  //When the DXDraw Component Initializes we start our timer
  DXTimer1.Enabled := True;
end;

procedure TForm1.DXDraw2Finalize(Sender: TObject);
begin
  //When the DXDraw Component Quits we stop our timer
  DXTimer1.Enabled := False;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  //When ESCAPE (ASCII 27) is pressed, we will quit our program
  If Ord(Key) = 27 Then Form1.Close;
End;

procedure TForm1.DXSpriteEngine1Items0Move(Sender: TObject;
  var MoveCount: Integer);
begin
  {can be searched in multi move event}
//  With DXSpriteEngine1.Items.Find('Boo').Sprite as TImageSpriteEx Do Begin
  {or selected from a sender}
  With Sender as TImageSpriteEx Do Begin
    If isUp in DXInput1.States Then
      Y := Y -10;
    If isDown in DXInput1.States  Then
      Y := Y + 10;

    If isLeft in Form1.DXInput1.States  Then
    begin
      If Image = DXImageList1.Items.Find('BeeRight') Then
        Image := DXImageList1.Items.Find('BeeLeft');
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
    Reanimate(MoveCount)

  End;
end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
begin

  //First we update the DXInput Component so we can receive new keys
  DXInput1.Update;

  {Then we are going to move all sprites in the SpriteEngine, this
   Action will execute all 'DoMove' methods of it's sprites}
  DXSpriteEngine1.Move(1);

  //We erase the background and set it to black (0)
  DXDraw2.Surface.Fill(0);

  //Then we draw all sprites to the DXDraw1 component (make sure the DXDraw property of the SpriteEngine is set to the right DXDraw component!)
  DXSpriteEngine1.Draw;

  //And then we make everything visible to the user by flipping the buffers
  DXDraw2.Flip;

end;

procedure TForm1.DXSpriteEngine1Items0GetImage(Sender: TObject;
  var Image: TPictureCollectionItem);
begin
  {initialize image is indispensable}
  {other way is TForm.OnCreate}
  Image := DXImageList1.Items.Find('BeeRight')
end;

end.
