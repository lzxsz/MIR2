unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXClass, ExtCtrls, DXDraws, StdCtrls, DIB;

type
  TForm1 = class(TDXForm)
    DXDraw1: TDXDraw;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    DXImageList1: TDXImageList;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DXDraw1InitializeSurface(Sender: TObject);
    procedure DXDraw1RestoreSurface(Sender: TObject);
  private
    procedure FadeIn(Time: Integer; Col: Integer);
    procedure FadeOut(Time: Integer; Col: Integer);
    procedure Flash(Time: Integer; Col: Integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

function ComposeColor(Dest, Src: TRGBQuad; Percent: Integer): TRGBQuad;
begin
  with Result do
  begin
    rgbRed := Src.rgbRed+((Dest.rgbRed-Src.rgbRed)*Percent div 256);
    rgbGreen := Src.rgbGreen+((Dest.rgbGreen-Src.rgbGreen)*Percent div 256);
    rgbBlue := Src.rgbBlue+((Dest.rgbBlue-Src.rgbBlue)*Percent div 256);
    rgbReserved := 0;
  end;
end;

procedure TForm1.FadeOut(Time: Integer; Col: Integer);
var
  t: DWORD;
  i, p, o: Integer;
begin
  if not DXDraw1.CanDraw then Exit;
  if not DXDraw1.CanPaletteAnimation then Exit;

  {  Fade out  }
  t := GetTickCount;
  o := 0;
  while Abs(GetTickCount-t)<Time do
  begin
    p := Min(Max(Abs(GetTickCount-t)*255 div Time, 0), 255);

    if p<>o then
    begin
      o := p;

      for i:=0 to 255 do
        DXDraw1.ColorTable[i] := ComposeColor(RGBQuad(GetRValue(Col), GetGValue(Col), GetBValue(Col)),
          DXDraw1.DefColorTable[i], p);

      DXDraw1.UpdatePalette;
    end;
  end;
end;

procedure TForm1.FadeIn(Time: Integer; Col: Integer);
var
  t: DWORD;
  i, p, o: Integer;
begin
  if not DXDraw1.CanDraw then Exit;
  if not DXDraw1.CanPaletteAnimation then Exit;

  {  Fade in  }
  t := GetTickCount;
  o := 0;
  while Abs(GetTickCount-t)<Time do
  begin
    p := 255-Min(Max(Abs(GetTickCount-t)*255 div Time, 0), 255);

    if p<>o then
    begin
      o := p;

      for i:=0 to 255 do
        DXDraw1.ColorTable[i] := ComposeColor(RGBQuad(GetRValue(Col), GetGValue(Col), GetBValue(Col)),
          DXDraw1.DefColorTable[i], p);

      DXDraw1.UpdatePalette;
    end;
  end;
end;

procedure TForm1.Flash(Time: Integer; Col: Integer);
begin
  {  Flash  }
  FadeOut(Time div 2, Col);
  FadeIn(Time div 2, Col);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  FadeOut(500, RGB(0, 0, 0));

  {  The palette is returned.  }
  DXDraw1.ColorTable := DXDraw1.DefColorTable;
  DXDraw1.UpdatePalette;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  FadeIn(500, RGB(0, 0, 0));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Flash(200, RGB(255, 255, 255));
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DXImageList1.Items.MakeColorTable;
  DXDraw1.DefColorTable := DXImageList1.Items.ColorTable;
  DXDraw1.ColorTable := DXImageList1.Items.ColorTable;
end;

procedure TForm1.DXDraw1InitializeSurface(Sender: TObject);
begin
  DXImageList1.Items[0].StretchDraw(DXDraw1.Surface, DXDraw1.Surface.ClientRect, 0);
end;

procedure TForm1.DXDraw1RestoreSurface(Sender: TObject);
begin
  DXImageList1.Items[0].StretchDraw(DXDraw1.Surface, DXDraw1.Surface.ClientRect, 0);
end;

end.

