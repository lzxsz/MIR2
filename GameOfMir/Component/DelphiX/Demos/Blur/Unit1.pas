unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtDlgs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    Edit1: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses GaussianBlur;

procedure TForm1.Button1Click(Sender: TObject);
  var b: TBitmap;
begin
  if not openpictureDialog1.Execute then exit;

  b:= TBitmap.Create;
  b.LoadFromFile(OpenPictureDialog1.Filename);
  b.PixelFormat:= pf24Bit;
  Canvas.Draw(0, 0, b);
  GBlur(b, StrToFloat(Edit1.text));
  Canvas.Draw(b.Width, 0, b);
  b.Free;
end;

end.
