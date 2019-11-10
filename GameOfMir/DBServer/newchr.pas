unit newchr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls;
type
  TFrmNewChr=class(TForm)
    EdName: TEdit;
    Button1: TButton;
    Label1: TLabel;
  private
    { Private declarations }
  public
    function sub_49BD60(var sChrName:String):Boolean;
    { Public declarations }
  end ;

var
  FrmNewChr: TFrmNewChr;

implementation

{$R *.DFM}

function TFrmNewChr.sub_49BD60(var sChrName:String): Boolean;
//0x0049BD60
begin
  Result:=False;
  EdName.Text:='';
  Self.ShowModal;
  sChrName:=Trim(EdName.Text);
  if sChrName <> '' then Result:=True;    
end;

end.