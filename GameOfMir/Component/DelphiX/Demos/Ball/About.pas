unit About;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFormAbout = class(TForm)
    LabelAbout: TLabel;
    LabelAuthor: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.DFM}

procedure TFormAbout.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
