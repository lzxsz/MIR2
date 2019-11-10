unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DIB;

type
  TAutomaticSurface = class
  private
    FDXDraw: TCustomDXDraw;
    FGraphic: TGraphic;
    FSurface: TDirectDrawSurface;
    procedure DXDrawNotifyEvent(Sender: TCustomDXDraw; NotifyType: TDXDrawNotifyType);
  public
    constructor Create(DXDraw: TCustomDXDraw; Graphic: TGraphic);
    destructor Destroy; override;
    property Surface: TDirectDrawSurface read FSurface;
  end;

  TForm1 = class(TForm)
    DXDraw1: TDXDraw;
    DXDIB1: TDXDIB;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    FSurface: TAutomaticSurface;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}          

{  TAutomaticSurface  }

constructor TAutomaticSurface.Create(DXDraw: TCustomDXDraw; Graphic: TGraphic);
begin
  inherited Create;
  FDXDraw := DXDraw;
  FGraphic := Graphic;

  FDXDraw.RegisterNotifyEvent(DXDrawNotifyEvent);
end;

destructor TAutomaticSurface.Destroy;
begin
  if FDXDraw<>nil then
    FDXDraw.UnRegisterNotifyEvent(DXDrawNotifyEvent);
  inherited Destroy;
end;

procedure TAutomaticSurface.DXDrawNotifyEvent(Sender: TCustomDXDraw;
  NotifyType: TDXDrawNotifyType);
begin
  case NotifyType of
    dxntInitialize:
        begin
          FSurface := TDirectDrawSurface.Create(FDXDraw.DDraw);
        end;
    dxntFinalize:
        begin
          FSurface.Free;
          FSurface := nil;
        end;
    dxntRestore:
        begin
          FSurface.LoadFromGraphic(FGraphic);
          FSurface.TransparentColor := FSurface.Pixels[0, 0];
        end;
    dxntDestroying:
        begin
          FDXDraw := nil;
        end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FSurface := TAutomaticSurface.Create(DXDraw1, DXDIB1.DIB);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FSurface.Free;
end;

procedure TForm1.DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if not DXDraw1.CanDraw then Exit;

  DXDraw1.Surface.Draw(X-FSurface.Surface.Width div 2, Y-FSurface.Surface.Height div 2,
    FSurface.Surface.ClientRect, FSurface.Surface, True);

  DXDraw1.Flip;
end;

end.
