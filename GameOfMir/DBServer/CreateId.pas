unit CreateId;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Buttons;
type
  TFrmCreateId=class(TForm)
    EdId: TEdit;
    EdPasswd: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormShow(Sender : TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end ;

var
  FrmCreateId: TFrmCreateId;

implementation

{$R *.DFM}

procedure TFrmCreateId.FormShow(Sender : TObject);
begin
  EdId.SetFocus;
end;

end.
