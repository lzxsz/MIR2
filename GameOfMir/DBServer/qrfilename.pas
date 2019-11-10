unit qrfilename;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Buttons;
type
  TFrmQueryFileName=class(TForm)
    EdFileName: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end ;

var
  FrmQueryFileName: TFrmQueryFileName;

implementation

{$R *.DFM}

end.
