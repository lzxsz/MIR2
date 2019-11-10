{ GrafixDX Demo4 - CopperBar.  By Entity }
unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DXClass, DXDraws, DirectX, DXSounds, GrafixDX;

type
  TForm1 = class(TForm)
    DXDraw1: TDXDraw;
    DXTimer1: TDXTimer;
    DXImageList1: TDXImageList;
    procedure DXDraw1Initialize(Sender: TObject);
    procedure DXDraw1Finalize(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form1: TForm1;
  MySurface: TGrafixSurface; // The surface

implementation

{$R *.DFM}


procedure TForm1.DXDraw1Initialize(Sender: TObject);
begin
  // Create the surface
  MySurface:=TGrafixSurface.Create(DXDraw1.Surface.DDraw);
  // The first 2 0's inititialize the surface to be the same Width+Height
  // as DXDraw
  MySurface.Init(DXDraw1, DXImageList1, 0, 100, 0);
  // Set the destination surface for write operations
  MySurface.Surface:=MySurface;
  // Clear the surface to Black
  MySurface.Fill(0);

  // Lock the surface ready for writing to
  MySurface.Lock;

  // Draw copperbar at top of surface with a height of 100
  // The 3 RGB()'s are the TopColor, MiddleColor and BottomColor of the bar
  // respectively
  MySurface.CopperBar(0, 100, rgb(0, 0, 128), rgb(0, 128, 255), rgb(0, 0, 128));

  // Unlock the surface now that we're done
  MySurface.Unlock;

  // No mouse pointer
  DXDraw1.Cursor:=crNone;

  DXTimer1.Enabled:=true;
end;

procedure TForm1.DXDraw1Finalize(Sender: TObject);
begin
  DXTimer1.Enabled:=false;

  DXDraw1.Cursor:=crDefault;

  // Free the surface
  MySurface.Free;
end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
const
  ang: extended = 0.0;
var
  ctr: integer;
begin
  // Vital for entering FullScreen mode at runtime
  if not(DXDraw1.CanDraw) then exit;

  DXDraw1.Surface.Fill(0);

  { PUT ANY DRAWING CODE/PROCS HERE }

  // Draw 8 copperbars moving up and down in a nice smooth sine motion :o]
  for ctr:=0 to 7 do
    MySurface.DrawToDXDraw(0,round(sin((ang+(20*ctr))*pi/180)*150+200),True);

  ang:=ang+1;

  DXDraw1.Flip;

  // Display the framerate
  Form1.Caption:='FPS:  '+inttostr(DXTimer1.FrameRate);
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then Application.Terminate;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {  Screen mode change  }
  if (ssAlt in Shift) and (Key=VK_RETURN) then
  begin
    DXDraw1.Finalize;

    if doFullScreen in DXDraw1.Options then
    begin
//      RestoreWindow;

      DXDraw1.Cursor := crDefault;
      BorderStyle := bsSizeable;
      DXDraw1.Options := DXDraw1.Options - [doFullScreen];
    end else
    begin
//      StoreWindow;

      DXDraw1.Cursor := crNone;
      BorderStyle := bsNone;
      DXDraw1.Options := DXDraw1.Options + [doFullScreen];
    end;

    DXDraw1.Initialize;
  end;
end;

end.
