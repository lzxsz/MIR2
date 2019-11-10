unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXClass, ExtCtrls, DXDraws, StdCtrls;

type
  TMainForm = class(TDXForm)
    DXDraw: TDXDraw;
    DXTimer: TDXTimer;
    ImageList: TDXImageList;
    procedure DXDrawInitialize(Sender: TObject);
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    FAngle: Integer;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.DXDrawInitialize(Sender: TObject);
begin
  DXTimer.Enabled := True;
end;
                                        
procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
  DXTimer.Enabled := False;
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
begin
  if not DXDraw.CanDraw then Exit;

  DXDraw.Surface.Fill(0);
                                                          
  ImageList.Items[0].DrawWaveX(DXDraw.Surface, 50, 30, 320, 90, 0, 2, 80, FAngle*4);

  ImageList.Items[0].DrawAdd(DXDraw.Surface, Bounds(80, 20, 128, 32),
    0, Trunc(Cos256(FAngle)*126+127));
                            
  ImageList.Items[0].DrawAdd(DXDraw.Surface, Bounds(90, 30, 128, 32),
    0, Trunc(Cos256(FAngle+128)*126+127));

  ImageList.Items[0].DrawRotateAlpha(DXDraw.Surface, DXDraw.Surface.Width div 2,
    DXDraw.Surface.Height div 2, 320, 90, 0, 0.5, 0.5, FAngle, Trunc(Cos256(FAngle)*126+127));

  Inc(FAngle);

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

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ImageList.Items.MakeColorTable;
  DXDraw.ColorTable := ImageList.Items.ColorTable;
  DXDraw.DefColorTable := ImageList.Items.ColorTable;
  DXDraw.UpdatePalette;
end;

end.
