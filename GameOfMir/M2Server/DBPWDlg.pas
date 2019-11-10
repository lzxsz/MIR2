unit DBPWDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TPasswordDialog = class(TForm)
    OKButton: TButton;
    CancelButton: TButton;
    GroupBox1: TGroupBox;
    Edit: TEdit;
    AddButton: TButton;
    RemoveButton: TButton;
    RemoveAllButton: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PasswordDialog: TPasswordDialog;

implementation

{$R *.dfm}

end.
