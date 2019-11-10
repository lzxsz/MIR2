unit FAccountView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls;
type
  TFrmAccountView=class(TForm)
    EdFindID: TEdit;
    EdFindIP: TEdit;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure EdFindIDKeyPress(Sender: TObject; var Key: Char);
    procedure EdFindIPKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end ;

var
  FrmAccountView: TFrmAccountView;

implementation

{$R *.DFM}

procedure TFrmAccountView.EdFindIDKeyPress(Sender: TObject; var Key: Char);
var
  I: Integer;
begin
  if Key <> #13 then exit;
  for I := 0 to ListBox1.Items.Count - 1 do begin
    if EdFindID.Text = ListBox1.Items.Strings[i] then
      ListBox1.ItemIndex:=i;

  end;
end;

procedure TFrmAccountView.EdFindIPKeyPress(Sender: TObject; var Key: Char);
var
  I: Integer;
begin
  if Key <> #13 then exit;
  for I := 0 to ListBox2.Items.Count - 1 do begin
    if EdFindIP.Text = ListBox2.Items.Strings[i] then
      ListBox2.ItemIndex:=i;
  end;
end;

end.
