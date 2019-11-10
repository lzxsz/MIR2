unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXClass, ExtCtrls, DXDraws, StdCtrls, DIB;

type
  TForm1 = class(TDXForm)
    DXDraw1: TDXDraw;
    DXDIB1: TDXDIB;
    procedure DXDraw1RestoreSurface(Sender: TObject);
    procedure DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DXDraw1InitializeSurface(Sender: TObject);
    procedure DXDraw1FinalizeSurface(Sender: TObject);
  private
    FSurface: TDirectDrawSurface;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.DXDraw1InitializeSurface(Sender: TObject);
begin
  FSurface := TDirectDrawSurface.Create(DXDraw1.DDraw);
end;

procedure TForm1.DXDraw1FinalizeSurface(Sender: TObject);
begin
  FSurface.Free; FSurface := nil;
end;             

procedure TForm1.DXDraw1RestoreSurface(Sender: TObject);
begin
  FSurface.LoadFromGraphic(DXDIB1.DIB);
end;

procedure TForm1.DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if not DXDraw1.CanDraw then Exit;

  DXDraw1.Surface.Draw(X-FSurface.Width div 2, Y-FSurface.Height div 2,
    FSurface.ClientRect, FSurface, True);

  DXDraw1.Flip;
end;

end.
