unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, DXClass, DXDraws;

type
  TMainForm = class(TDXForm)
    DXDraw: TDXDraw;
    ImageList: TDXImageList;
    DXTimer: TDXTimer;
    DXFont: TDXFont;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure DXTimerActivate(Sender: TObject);
    procedure DXTimerDeactivate(Sender: TObject);
  private
    Scrolly: string;  // text to scroll
    scroll: integer;  // x value
  public

  end;

var
  MainForm: TMainForm;

implementation

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
begin
  ImageList.Items.MakeColorTable;
  DXDraw.ColorTable := ImageList.Items.ColorTable;
  DXDraw.DefColorTable := ImageList.Items.ColorTable;

  // Scroll Message

  scrolly := 'THIS IS A TEST OF BUILDING A VCL ADD-ON COMPONENT FOR DELPHIX.  ' +
    'HOPEFULLY THIS SOURCE WILL GIVE THE AVERAGE PROGRAMMER A JUMP START ' +
    'TO CREATING HIS OR HER OWN DELPHIX PLUG-INS.     ' +
    'FOR MORE INFORMATION PLEASE VISIT HTTP://TURBO.GAMEDEV.NET';

  // Uncomment to test DXFont without installing
  {
  DXFont := TDXFont.Create(Self); // Construct the component
  DXFont.DXImageList := ImageList; // Set Imagelist
  DXFont.Font := 'yellowtext'; // or DXFont.FontIndex:=0;
  }

  scroll := dxdraw.Width;
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
begin
  if not DXDraw.CanDraw then exit;

  DXDraw.Surface.Fill(0);

  // preform scroll

  DXFont.TextOut(DXDraw.surface, scroll, dxdraw.Height - 100, scrolly);
  dec(scroll);
  if scroll < (-length(scrolly) * DXFont.Offset) then scroll := dxdraw.Width;

  // end scroll

  with DXDraw.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clWhite;
    Font.Size := 12;
    Textout(0, 0, 'FPS: ' + inttostr(DXTimer.FrameRate));

    Release; {  Indispensability  }
  end;

  DXDraw.Flip;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {  Application end  }
  if Key = VK_ESCAPE then
    Close;

  {  Screen mode change  }
  if (ssAlt in Shift) and (Key = VK_RETURN) then
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

