unit Unit1;
{Simple prototype demo project for using new fearures in DelphiX}
{Can be modify for your project}
{(c)2005 Jaro Benes}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtDlgs,
  DXDraws, DXClass, DIB; {DelphiX units...}

type
  TForm1 = class(TDXForm)
    DXDraw: TDXDraw;
    DXImageList: TDXImageList;
    DXTimer: TDXTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DXDrawInitialize(Sender: TObject);
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
  private
    { Private declarations }
    HardwareSwitch:Boolean; {simple variables}
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  {for mouse move as pointing - code here}
end;

procedure TForm1.DXDrawInitialize(Sender: TObject);
begin
  Dxtimer.Enabled := true;
end;

procedure TForm1.DXDrawFinalize(Sender: TObject);
begin
  Dxtimer.Enabled := false;
end;

procedure TForm1.DXTimerTimer(Sender: TObject; LagCount: Integer);
begin
  if not DXDraw.CanDraw then Exit;

  DXDraw.BeginScene;
  try
    {clear surface with predefined windows color}
    DXDraw.Surface.Fill(DXDraw.Surface.ColorMatch(clBlack));

    //----------------------------------------------------------------------------
    {All drawing here like}
    //DXImageList.Items[0].Draw(DXDraw.surface,0,0,0);
    //----------------------------------------------------------------------------
  finally
    DXDraw.EndScene;
  end;

  { Draw FrameRate }
  with DXDraw.Surface.Canvas do
  try
    Brush.Style := bsClear;
    Font.Color := clWhite;
    Font.Size := 10;
    Textout(3, 3, 'FPS: '+inttostr(DXTimer.FrameRate));
    if doHardware in DXDraw.NowOptions then begin
      Textout(3, 14, 'Device: Hardware');
      Textout(3, DXDraw.Height-16-14, 'Change device mode to software press SPACE.')
    end
    else begin
      Textout(3, 14, 'Device: Software');
      Textout(3, DXDraw.Height-16-14, 'Change device mode to hardware press SPACE.')
    end;
    if doFullScreen in DXDraw.NowOptions then
      TextOut(3,DXDraw.Height-16,'For windowed mode press ALT+Enter.')
    else
      TextOut(3,DXDraw.Height-16,'For fullscreen press ALT+Enter.');
  finally
    Release; {  Indispensability  }
  end;

  DXDraw.Flip;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  { Application end }
  if Key=VK_ESCAPE {ESC} then
    Close;
  { Switch hardware-software mode }
  if Key=VK_SPACE {mezernik} then Begin
    DXDraw.Finalize;	
    HardwareSwitch := NOT HardwareSwitch;
    If HardwareSwitch Then
    {hardware}
    Begin
      If NOT (doDirectX7Mode in DXDraw.Options) Then
        DXDraw.Options := DXDraw.Options + [doDirectX7Mode];
      if NOT (doHardware in DXDraw.Options) then
        DXDraw.Options := DXDraw.Options + [doHardware];
      if NOT (do3D in DXDraw.Options) then
        DXDraw.Options := DXDraw.Options + [do3D];
      if doSystemMemory in DXDraw.Options then
        DXDraw.Options := DXDraw.Options - [doSystemMemory];
    End
    Else
    {software}
    Begin
      if do3D in DXDraw.Options then
        DXDraw.Options := DXDraw.Options - [do3D];
      if doHardware in DXDraw.Options then
        DXDraw.Options := DXDraw.Options - [doHardware];
      if NOT (doSystemMemory in DXDraw.Options) then
        DXDraw.Options := DXDraw.Options + [doSystemMemory];
      If doDirectX7Mode in DXDraw.Options Then
        DXDraw.Options := DXDraw.Options - [doDirectX7Mode];
    End;

    DXDraw.Initialize;

    Exit;
  End;

  {  Screen mode change  }
  if (ssAlt in Shift) and (Key=VK_RETURN) {ALT+ENTER} then
  begin
    DXDraw.Finalize;

    if doFullScreen in DXDraw.Options then
    begin
      RestoreWindow;

      DXDraw.Cursor := crDefault;
      BorderStyle := bsSingle;
      DXDraw.Options := DXDraw.Options - [doFullScreen];
      DXDraw.Options := DXDraw.Options + [doFlip];
    end else
    begin
      StoreWindow;

      DXDraw.Cursor := crNone;
      BorderStyle := bsNone;
      DXDraw.Options := DXDraw.Options + [doFullScreen];
      DXDraw.Options := DXDraw.Options - [doFlip];
    end;

    DXDraw.Initialize;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  {be sure color table}
  DXImageList.Items.MakeColorTable;
  DXDraw.ColorTable := DXImageList.Items.ColorTable;
  DXDraw.DefColorTable := DXImageList.Items.ColorTable;
  DXDraw.UpdatePalette;
  {switch for easy change mode}
  HardwareSwitch := False; {initialize, start in software mode}
  {when changed can be call FormKeyDown with 'space' parameter}
end;

end.