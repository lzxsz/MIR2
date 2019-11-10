unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXClass, DXDraws, DIB, StdCtrls, ComCtrls;

type
  TForm1 = class(TDXForm)
    DXDraw1: TDXDraw;
    DXTimer1: TDXTimer;
    EffectsList: TListBox;
    TrackBar: TTrackBar;
    Button_APPLY: TButton;
    AutoMatic: TCheckBox;
    DXDIB1: TDXDIB;
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure Button_APPLYClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure EffectsListClick(Sender: TObject);
  private
    { Private declarations }
    TT: TDIB;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
begin
  if not DXDraw1.CanDraw then Exit;

  DXDRAW1.Surface.Fill(0);

  DXDRAW1.Surface.LoadFromDIB(TT);

  DXDraw1.Flip;
end;

procedure TForm1.Button_APPLYClick(Sender: TObject);
var
  I, dX, dY: Integer;
begin
  Screen.Cursor := crHourGlass;
  try
    TT.AsSign(DXDIB1.DIB); {refresh image}
    Button_APPLY.Enabled := False;
    dX := TT.Width;
    dY := TT.Height;
    if TrackBar.Position > 5 then
    begin
      dX := Trunc(TrackBar.Position / 100 * TT.Width);
      dY := Trunc(TrackBar.Position / 100 * TT.Height);
    end;
    { E F F E C T S }
    with TT do
      case EffectsList.ItemIndex of
        0: DoGaussianBlur(TrackBar.Position);
        1: DoSplitBlur(TrackBar.Position);
        2: DoAddColorNoise(TrackBar.Position * 3);
        3: DoAddMonoNoise(TrackBar.Position * 3);
        4: for i := 1 to TrackBar.Position do
            DoAntiAlias;
        5: DoContrast(TrackBar.Position * 3);
        6: DoFishEye(TrackBar.Position div 10 + 1);
        7: DoLightness(TrackBar.Position * 2);
        8: DoDarkness(TrackBar.Position * 2);
        9: DoSaturation(255 - ((TrackBar.Position * 255) div 100));
        10: DoMosaic(TrackBar.Position div 2);
        11: DoTwist(200 - (TrackBar.Position * 2) + 1);
        12: DoSplitlight(TrackBar.Position div 20);
        13: DoTile(TrackBar.Position div 10);
        14: DoSpotLight(TrackBar.Position,
            Rect(TrackBar.Position,
            TrackBar.Position,
            TrackBar.Position + TrackBar.Position * 2,
            TrackBar.Position + TrackBar.Position * 2));
        15: DoTrace(TrackBar.Position div 10);
        16: for i := 1 to TrackBar.Position do
            DoEmboss;
        17: DoSolorize(255 - ((TrackBar.Position * 255) div 100));
        18: DoPosterize(((TrackBar.Position * 255) div 100) + 1);
        19: DoGrayscale;
        20: DoInvert;
        21: DoBrightness(TrackBar.Position);
          {onne function}

        22: DoResample(dX, dY, ftrBox);
        23: DoResample(dX, dY, ftrTriangle);
        24: DoResample(dX, dY, ftrHermite);
        25: DoResample(dX, dY, ftrBell);
        26: DoResample(dX, dY, ftrBSpline);
        27: DoResample(dX, dY, ftrLanczos3);
        28: DoResample(dX, dY, ftrMitchell);
        29: DoColorize(clRed, clBlue);
      end; {Case}
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TT := TDIB.Create;
  TT.AsSign(DXDIB1.DIB);
  DXTimer1.Enabled := True;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  TT.Free;
end;

procedure TForm1.TrackBarChange(Sender: TObject);
begin
  if not Button_APPLY.Enabled then Button_APPLY.Enabled := True;
  if AutoMatic.Checked then Button_APPLY.Click;
end;

procedure TForm1.EffectsListClick(Sender: TObject);
begin
  TT.AsSign(DXDIB1.DIB);
  Button_APPLY.Enabled := True;
  TrackBar.Enabled := True;
  TrackBar.Position := 1;
end;

end.

