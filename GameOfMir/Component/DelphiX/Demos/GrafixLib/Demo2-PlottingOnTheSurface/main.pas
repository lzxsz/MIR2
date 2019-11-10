{ GrafixDX Demo2 - Plotting on the Surface.  By Entity }
unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DXClass, DXDraws, Directx, DXSounds, GrafixDX;

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
  MySurface: TGrafixSurface;

implementation

{$R *.DFM}




procedure TForm1.DXDraw1Initialize(Sender: TObject);
begin
  // Create a GrafixDX surface
  MySurface:=TGrafixSurface.Create(DXDraw1.Surface.DDraw);
  // Initialize the surface
  MySurface.Init(DXDraw1, DXImageList1, 100, 100, 0);
  MySurface.Surface:=MySurface;

  randomize;

  DXDraw1.Cursor:=crNone;

  DXTimer1.Enabled:=true;
end;

procedure TForm1.DXDraw1Finalize(Sender: TObject);
begin
  DXTimer1.Enabled:=false;

  DXDraw1.Cursor:=crDefault;

  MySurface.Free;
end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
const
  ang: extended = 0;
var
  xctr, yctr: integer;
  xSurf, ySurf: integer;
begin
  // Vital for entering FullScreen mode at runtime
  if not(DXDraw1.CanDraw) then exit;

  DXDraw1.Surface.Fill(0);

  // Clear the surface
  MySurface.Fill(0);

  // To plot straight to the DXDraw surface (or any other surface), you can use
  // MySurface.Surface:=DXDraw1.Surface;
  // But remember to comment out 'MySurface.DrawToDXDraw()' below

  // Lock the surface ready for writing
  MySurface.Lock;

  // Plot 10000 random pixels with random colour
  for yctr:=0 to MySurface.Height do
    for xctr:=0 to MySurface.Width do
      MySurface.PutPixel(random(MySurface.Width),random(Mysurface.Height),
                         rgb(random(255),random(255),random(255)));

  // Unlock the surface -- DO NOT FORGET TO DO THIS!!
  MySurface.Unlock;

  ang:=ang+2;

  // Move the surface around in a circle
  xSurf:=round(sin(ang*pi/180)*100+100);
  ySurf:=round(cos(ang*pi/180)*100+100);
  
  // Draw the surface to the backbuffer of DXDraw before flipping
  MySurface.DrawToDXDraw(xSurf,ySurf,False);


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
