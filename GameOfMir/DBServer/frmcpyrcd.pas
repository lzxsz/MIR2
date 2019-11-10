unit frmcpyrcd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Buttons;
type
  TFrmCopyRcd=class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EdWithID: TEdit;
    procedure FormShow(Sender : TObject);
  private
    { Private declarations }
  public
    s2F0,s2F4,s2F8:String;
    function  sub_49C09C():Boolean;
    { Public declarations }
  end ;

var
  FrmCopyRcd: TFrmCopyRcd;

implementation

{$R *.DFM}

procedure TFrmCopyRcd.FormShow(Sender : TObject);
begin
  Edit1.SetFocus;
end;

function TFrmCopyRcd.sub_49C09C: Boolean;
//0x0049C09C
begin
  s2F0:='';
  s2F4:='';
  s2F8:='';
  Edit1.Text:=s2F0;
  Edit2.Text:=s2F4;
  if Self.ShowModal = mrOK then begin
    s2F0:=Trim(Edit1.Text);
    s2F4:=Trim(Edit2.Text);
    s2F8:=Trim(EdWithID.Text);
    Result:=True;
  end else Result:=False;
end;
end.
