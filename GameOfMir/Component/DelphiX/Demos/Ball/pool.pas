unit pool;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TPool = class(TPaintBox)
  private
    Fimagelist:TImagelist;
  protected
    procedure paint;   override;
  public
    constructor Create(AOwner:TComponent);  override;
    procedure loadbitmap;
  published
  end;


implementation

constructor TPool.Create(AOwner:TComponent); 
begin
  inherited;
  Fimagelist := TImagelist.Create(self);
end;

procedure TPool.Paint;
var
  bmp2:TBitmap;
begin
  FImagelist.Draw(Canvas,0,0,0);
 
  {NÄILLÄ PIIRTO KAATAA OHJELMAN} 

  bmp2:=TBitmap.Create;
  FImagelist.GetBitmap(0,bmp2);
  Canvas.Draw(0,0,bmp2);
  bmp2.Free;
  inherited;

end;

procedure TPool.loadbitmap;
var
  bmp:TBitmap;
begin
  FImagelist.Width :=20;
  FImagelist.Height := 20;
  FImagelist.Clear;

  bmp:=TBitmap.Create;
  bmp.Transparent:=True;
  bmp.Width := FImagelist.Width;
  bmp.Height := FImagelist.Height;
  bmp.LoadFromFile('hauto.bmp');

  FImagelist.Add(bmp,nil);

  paint;

  bmp.Free;
end;

end.
