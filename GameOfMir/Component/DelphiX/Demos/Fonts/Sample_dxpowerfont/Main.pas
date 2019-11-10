(*******************************************************************************
 * This is a sample progarmme about using TDXPowerFont VCL-Component/Add-On.
 * You have need to DelphiX components.
 * For more information read the header of "DXPowerFont.pas" Unit.
 *
 * Ramin.S.Zaghi (ramin_zaghi@yahoo.com)
 * (Based on wilson's code for TDXFont VCL-Component/Add-On)
 * (wilson@no2games.com)
 *
 * For more information visit:
 *  www.no2games.com
 *  turbo.gamedev.net
 ******************************************************************************)
unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXClass, DXDraws, StdCtrls;

type
	TMainForm = class(TDXForm)
		DXDraw: TDXDraw;
		ImageList: TDXImageList;
		DXTimer: TDXTimer;
		DXPowerFont: TDXPowerFont;
		RadioButton1: TRadioButton;
		RadioButton2: TRadioButton;
		RadioButton3: TRadioButton;
		RadioButton4: TRadioButton;
		RadioButton5: TRadioButton;
		Edit1: TEdit;
		procedure FormKeyDown(Sender: TObject; var Key: Word;
			Shift: TShiftState);
		procedure DXDrawFinalize(Sender: TObject);
		procedure DXDrawInitialize(Sender: TObject);
		procedure FormCreate(Sender: TObject);
		procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
		procedure DXTimerActivate(Sender: TObject);
		procedure DXTimerDeactivate(Sender: TObject);
		procedure RadioButton1Click(Sender: TObject);
		procedure RadioButton2Click(Sender: TObject);
		procedure RadioButton3Click(Sender: TObject);
		procedure RadioButton4Click(Sender: TObject);
		procedure DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
	private
		CPX,CPY: Integer;
		scroll_X,scroll_Y: integer;  // x value
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

	// Uncomment to test DXPowerFont without installing
	{
    DXPowerFont := TDXPowerFont.Create(Self); // Construct the component
	DXPowerFont.DXImageList := ImageList; // Set Imagelist
	DXPowerFont.Font := 'Courier_New'; // or DXPowerFont.FontIndex:= 0;
	}

	scroll_X := 0;
	scroll_Y := 65;
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

	if RadioButton5.Checked then
		DXPowerFont.TextOutFast(DXDraw.surface, scroll_X, scroll_Y, Edit1.Text)
	else
		DXPowerFont.TextOut(DXDraw.surface, scroll_X, scroll_Y, Edit1.Text);

	with DXDraw.Surface.Canvas do
	begin
		Brush.Style := bsClear;
		Font:= MainForm.Font;
		Textout(5, 55, 'FPS: ' + inttostr(DXTimer.FrameRate));
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

procedure TMainForm.RadioButton1Click(Sender: TObject);
begin
	DXPowerFont.TextOutEffect:= teNormal;
end;

procedure TMainForm.RadioButton2Click(Sender: TObject);
begin
	DXPowerFont.TextOutEffect:= teRotat;
end;

procedure TMainForm.RadioButton3Click(Sender: TObject);
begin
	DXPowerFont.TextOutEffect:= teAlphaBlend;
end;

procedure TMainForm.RadioButton4Click(Sender: TObject);
begin
	DXPowerFont.TextOutEffect:= teWaveX;
end;

procedure TMainForm.DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
	if ssLeft in Shift then
	begin
		if X>CPX then Inc(scroll_X, 6);
		if X<CPX then Dec(scroll_X, 6);
		if Y>CPY then Inc(scroll_Y, 2);
		if Y<CPY then Dec(scroll_Y, 2);
	end;
	
	CPX:= X; CPY:= Y;
end;

end.