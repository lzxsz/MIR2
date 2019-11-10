unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, DXInput, DXClass, DXDraws;

const
  MaxSprite = 10;
  MaxSpeed = 5;

type
  TSprite = record
    X, Y, IncX, IncY: Longint;
  end;

  TMainForm = class(TDXForm)
    DXDraw: TDXDraw;
    ImageList: TDXImageList;
    DXTimer: TDXTimer;
    DXInput: TDXInput;
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
begin
  ImageList.Items.LoadFromFile(ExtractFilePath(Application.ExeName)+'Sample.dxg');

  ImageList.Items.MakeColorTable;
  DXDraw.ColorTable := ImageList.Items.ColorTable;
  DXDraw.DefColorTable := ImageList.Items.ColorTable;

  with Sprite[0] do
  begin
    X := DXDraw.Width div 2-ImageList.Items[0].Width div 2;
    Y := DXDraw.Height div 2-ImageList.Items[0].Height div 2;
  end;

  for i:=1 to MaxSprite do
    with Sprite[i] do
    begin
      X := Random(DXDraw.Width-ImageList.Items[0].Width);
      Y := Random(DXDraw.Height-ImageList.Items[0].Height);
      IncX := Random(MaxSpeed)+1;
      IncY := Random(MaxSpeed)+1;
    end;
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
  i: Integer;
begin
  if not DXDraw.CanDraw then exit;

  DXDraw.Surface.Fill(0);

  {  Movement of sprite  }
  DXInput.Update;

  with Sprite[0] do
  begin
    if isLeft in DXInput.States then Dec(X, 4);
    if isRight in DXInput.States then Inc(X, 4);
    if isUp in DXInput.States then Dec(Y, 4);
    if isDown in DXInput.States then Inc(Y, 4);

    if X<0 then X := 0;
    if X>DXDraw.Surface.Width-ImageList.Items[0].Width then X := DXDraw.Surface.Width-ImageList.Items[0].Width;

    if Y<0 then Y := 0;
    if Y>DXDraw.Surface.Height-ImageList.Items[0].Height then Y := DXDraw.Surface.Height-ImageList.Items[0].Height;
  end;                                                                                                             

  for i:=1 to MaxSprite do
  begin
    with Sprite[i] do
    begin
      Inc(X, IncX); Inc(Y, IncY);

      if X<0 then IncX := Random(MaxSpeed)+1;
      if X>DXDraw.Surface.Width-ImageList.Items[0].Width then IncX := -Random(MaxSpeed)-1;

      if Y<0 then IncY := Random(MaxSpeed)+1;
      if Y>DXDraw.Surface.Height-ImageList.Items[0].Height then IncY := -Random(MaxSpeed)-1;
      ImageList.Items[0].Draw(DXDraw.Surface, X, Y, 0);
    end;
  end;

  {  Description  }
  for i:=MaxSprite downto 0 do
  begin
    with Sprite[i] do
      ImageList.Items[0].Draw(DXDraw.Surface, X, Y, 0);
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
