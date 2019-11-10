unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, DXDraws, DXClass, DirectX;

type
  TForm1 = class(TForm)
    DXDraw: TDXDraw;
    Button1: TButton;
    Button2: TButton;
    DXImageList: TDXImageList;
    Button3: TButton;
    Button4: TButton;
    procedure DXDrawInitializeSurface(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DXDrawRestoreSurface(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private êÈåæ }
    FDefaultGammaRamp: TDDGammaRamp;
  public
    { Public êÈåæ }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.DXDrawInitializeSurface(Sender: TObject);
begin
  if DXDraw.Primary.GammaControl=nil then
  begin                         
    try
      raise Exception.Create('Gamma control not supported');
    except
      on E: Exception do
      begin
        Application.HandleException(E);
        Application.Terminate;
        Exit;
      end;
    end;
  end;

  DXDraw.Primary.GammaControl.GetGammaRamp(0, FDefaultGammaRamp);
end;

procedure TForm1.DXDrawRestoreSurface(Sender: TObject);
begin
  DXImageList.Items[0].StretchDraw(DXDraw.Surface, DXDraw.Surface.ClientRect, 0);

  with DXDraw.Surface.Canvas do
  begin
    try
      TextOut(0, 0, Format('%dx%d %d bit color',
        [DXDraw.Display.Width, DXDraw.Display.Height, DXDraw.Display.BitCount]));
    finally
      Release;
    end;
  end;
  DXDraw.Flip;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  DXDraw.Primary.GammaControl.SetGammaRamp(0, FDefaultGammaRamp);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  GammaRamp: TDDGammaRamp;
  i: Integer;
begin
  for i:=0 to 255 do
  begin
    GammaRamp.Red[i] := 65535-FDefaultGammaRamp.Red[i];
    GammaRamp.Green[i] := 65535-FDefaultGammaRamp.Green[i];
    GammaRamp.Blue[i] := 65535-FDefaultGammaRamp.Blue[i];
  end;

  DXDraw.Primary.GammaControl.SetGammaRamp(0, GammaRamp);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  GammaRamp: TDDGammaRamp;
  i: Integer;
begin
  for i:=0 to 255 do
  begin
    GammaRamp.Red[i] := Min(65535, FDefaultGammaRamp.Red[i]+32768);
    GammaRamp.Green[i] := Min(65535, FDefaultGammaRamp.Green[i]+32768);
    GammaRamp.Blue[i] := Min(65535, FDefaultGammaRamp.Blue[i]+32768);
  end;

  DXDraw.Primary.GammaControl.SetGammaRamp(0, GammaRamp);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  GammaRamp: TDDGammaRamp;
  i: Integer;
begin
  for i:=0 to 255 do
  begin
    GammaRamp.Red[i] := Max(0, FDefaultGammaRamp.Red[i]-32768);
    GammaRamp.Green[i] := Max(0, FDefaultGammaRamp.Green[i]-32768);
    GammaRamp.Blue[i] := Max(0, FDefaultGammaRamp.Blue[i]-32768);
  end;                        

  DXDraw.Primary.GammaControl.SetGammaRamp(0, GammaRamp);
end;

end.


