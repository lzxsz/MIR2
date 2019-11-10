unit ConfigGameShop;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ComCtrls;

type
  TfrmConfigGameShop = class(TForm)
    GroupBox1: TGroupBox;
    ListViewItemList: TListView;
    GroupBox2: TGroupBox;
    ListBoxItemList: TListBox;
    Label1: TLabel;
    EditShopItemName: TEdit;
    SpinEditPrice: TSpinEdit;
    Label3: TLabel;
    Memo1: TMemo;
    ButtonDelShopItem: TButton;
    ButtonChgShopItem: TButton;
    ButtonAddShopItem: TButton;
    ButtonSaveShopItemList: TButton;
    ButtonLoadShopItemList: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
  private
    { Private declarations }
  public
   procedure Open();
    { Public declarations }
  end;

var
  frmConfigGameShop: TfrmConfigGameShop;

implementation

uses UsrEngn, M2Share, Grobal2, LocalDB;

{$R *.dfm}

procedure TfrmConfigGameShop.Open;
var
  I: Integer;
  MonGen:pTMonGenInfo;
begin
{  for I := 0 to UserEngine.m_MonGenList.Count - 1 do begin
    MonGen:=UserEngine.m_MonGenList.Items[I];
    ListBoxItemList.Items.AddObject(MonGen.sMapName + '(' + IntToStr(MonGen.nX) + ':' + IntToStr(MonGen.nY) + ')' + ' - ' + MonGen.sMonName,TObject(MonGen));
  end; }
  Self.ShowModal;
end;

end.
