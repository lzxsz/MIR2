unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, DXClass, DXDraws, DIB;

const
  MaxSprite = 10;
  MaxSpeed = 3;

type
  TSprite = record
    X, Y, IncX, IncY: Longint;
    ImageIndex: Integer;
  end;

  TMainForm = class(TDXForm)
    DXDraw: TDXDraw;
    ImageList: TDXImageList;
    DXTimer: TDXTimer;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure DXTimerActivate(Sender: TObject);
    procedure DXTimerDeactivate(Sender: TObject);
  private
    Sprite: array[0..MaxSprite] of TSprite;
  end;

var
  MainForm: TMainForm;

implementation

uses MMSystem;

{$R *.DFM}

procedure TMainForm.DXTimerActivate(Sender: TObject);
begin
  Caption := Application.Title;
end;

procedure TMainForm.DXTimerDeactivate(Sender: TObject);
begin
  Caption := Application.Title + ' [Pause]';
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: Integer;
  Item: TPictureCollectionItem;
  NewGraphic: TDIB;
begin
  {  The image is dynamically added to TDXImageList.  }
  NewGraphic := TDIB.Create;
  try
    NewGraphic.Assign(ImageList.Items[0].Picture);

    for i:=0 to 20 do
    begin
      NewGraphic.Blur(24, 2+i div 5);

      Item := TPictureCollectionItem.Create(ImageList.Items);
      Item.Picture.Graphic := NewGraphic;
    end;
  finally
    NewGraphic.Free;
  end;

  ImageList.Items.MakeColorTable;
  DXDraw.ColorTable := ImageList.Items.ColorTable;
  DXDraw.DefColorTable := ImageList.Items.ColorTable;

  for i:=0 to MaxSprite do
    with Sprite[i] do
    begin
      X := Random(DXDraw.Width-ImageList.Items[0].Width);
      Y := Random(DXDraw.Height-ImageList.Items[0].Height);
      IncX := Random(MaxSpeed)+1;
      IncY := Random(MaxSpeed)+1;
      ImageIndex := Random(255);
    end;

  Sprite[0].X := 20;
  Sprite[0].Y := 20;
end;

procedure TMainForm.DXDrawInitialize(Sender: TObject);
begin
  DXTimer.Enabled := True;
end;

procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
  DXTimer.Enabled := False;
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
var
  i, j: Integer;
begin
  if not DXDraw.CanDraw then exit;

  DXDraw.Surface.Fill(0);

  {  Movement of sprite  }
  for i := 0 to MaxSprite do
  begin
    with Sprite[i] do
    begin
      j := ImageList.Items.Count-Abs(Trunc(Cos256(Integer(GetTickCount) div 25+ImageIndex*50)*(ImageList.Items.Count-1)))-1;

      Inc(X, IncX); Inc(Y, IncY);

      if X<0 then IncX := Random(MaxSpeed)+1;
      if X>DXDraw.Surface.Width-ImageList.Items[j].Width then IncX := -Random(MaxSpeed)-1;

      if Y<0 then IncY := Random(MaxSpeed)+1;
      if Y>DXDraw.Surface.Height-ImageList.Items[j].Height then IncY := -Random(MaxSpeed)-1;

      {  Description  }
      ImageList.Items[j].Draw(DXDraw.Surface, X, Y, 0);
    end;
  end;

  with DXDraw.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clWhite;
    Font.Size := 12;
    Textout(0, 0, 'FPS: '+inttostr(DXTimer.FrameRate));

    Release; {  Indispensability  }
  end;

  DXDraw.Flip;
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

end.

