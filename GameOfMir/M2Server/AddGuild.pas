unit AddGuild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TFromAddGuild = class(TForm)
    GroupBox1: TGroupBox;
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    DateTimePicker1: TDateTimePicker;
    Button1: TButton;
  private
    { Private declarations }
  public
  procedure
  Open();
    { Public declarations }
  end;

var
 FromAddGuild:TFromAddGuild;
implementation

{$R *.dfm}
procedure TFromAddGuild.Open;

begin
  TFromAddGuild.Create(Owner);
  ShowModal;
end;

end.
