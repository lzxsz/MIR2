unit ScreenColorLines;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Spin, DIB;

type
  TFormColorLines = class(TForm)
    RadioGroupPixelGeometry: TRadioGroup;
    SpinEditRadius: TSpinEdit;
    LabelRadius: TLabel;
    Image: TDXPaintBox;
    RadioGroupColorStyle: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure RadioGroupPixelGeometryClick(Sender: TObject);
  private
     PROCEDURE UpdateImage;
  public
    { Public declarations }
  end;

var
  FormColorLines: TFormColorLines;

implementation
{$R *.DFM}

PROCEDURE TFormColorLines.UpdateImage;
  VAR
    DIB   :  TDIB;
BEGIN
  DIB := TDIB.Create;
  TRY
    DIB.SetSize(Image.Width,Image.Height,24);
    DIB.FillDIB8(0);
    DIB.ColoredLine(
       Point(20, 20),
       Point(DIB.Width-20, DIB.Height-20),
       TColorLineStyle(RadioGroupColorStyle.ItemIndex),
       clRed,
       clRed,
       TColorLinePixelGeometry(RadioGroupPixelGeometry.ItemIndex),
       SpinEditRadius.Value);
    DIB.ColoredLine(
       Point(20, DIB.Height-20),
       Point(DIB.Width-20, 20),
       TColorLineStyle(RadioGroupColorStyle.ItemIndex),
       clBlack,
       clSilver,
       TColorLinePixelGeometry(RadioGroupPixelGeometry.ItemIndex),
       SpinEditRadius.Value);
    DIB.ColoredLine(
       Point(DIB.Width DIV 2, 20),
       Point(20, DIB.Height DIV 2),
       TColorLineStyle(RadioGroupColorStyle.ItemIndex),
       clYellow,
       clGreen,
       TColorLinePixelGeometry(RadioGroupPixelGeometry.ItemIndex),
       SpinEditRadius.Value);
    DIB.ColoredLine(
       Point(DIB.Width DIV 4, DIB.Height - 20),
       Point(DIB.Width - 20, 40),
       TColorLineStyle(RadioGroupColorStyle.ItemIndex),
       clWhite,
       clRed,
       TColorLinePixelGeometry(RadioGroupPixelGeometry.ItemIndex),
       SpinEditRadius.Value);
    DIB.AntialiasedLine(15, DIB.Height DIV 3, DIB.Width div 3, DIB.Height div 2,clWhite);
    
  FINALLY
    Image.DIB.Clear;
    Image.DIB.Assign(DIB);
    Invalidate;
    DIB.Free
  END
END {UpdateImage};

procedure TFormColorLines.FormCreate(Sender: TObject);
begin
  UpdateImage
end;

procedure TFormColorLines.RadioGroupPixelGeometryClick(Sender: TObject);
begin
  SpinEditRadius.Visible := (RadioGroupPixelGeometry.ItemIndex > 0);
  LabelRadius.Visible := SpinEditRadius.Visible;
  UpdateImage
end;

end.
