unit MessageFilterConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmMessageFilterConfig = class(TForm)
    ListBoxFilterText: TListBox;
    Label1: TLabel;
    ButtonAdd: TButton;
    ButtonDel: TButton;
    ButtonOK: TButton;
    ButtonMod: TButton;
    procedure ListBoxFilterTextClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonModClick(Sender: TObject);
    procedure ListBoxFilterTextDblClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMessageFilterConfig: TfrmMessageFilterConfig;

implementation

uses GateShare;

{$R *.dfm}

procedure TfrmMessageFilterConfig.ListBoxFilterTextClick(Sender: TObject);
begin
  if (ListBoxFilterText.ItemIndex >=0) and
     (ListBoxFilterText.ItemIndex < ListBoxFilterText.Items.Count) then begin
    ButtonDel.Enabled:=True;
    ButtonMod.Enabled:=True;
  end;
end;

procedure TfrmMessageFilterConfig.ButtonOKClick(Sender: TObject);
var
  i:Integer;
begin
  try
    CS_FilterMsg.Enter;
    AbuseList.Clear;
    for I := 0 to ListBoxFilterText.Items.Count - 1 do begin
      AbuseList.Add(ListBoxFilterText.Items.Strings[i]);
    end;
  finally
    CS_FilterMsg.Leave;
  end;
  AbuseList.SaveToFile('.\WordFilter.txt');
  Close;
end;

procedure TfrmMessageFilterConfig.ButtonModClick(Sender: TObject);
var
  sInputText:String;
begin
  if (ListBoxFilterText.ItemIndex >=0) and (ListBoxFilterText.ItemIndex < ListBoxFilterText.Items.Count) then begin
    sInputText:=ListBoxFilterText.Items[ListBoxFilterText.ItemIndex];
    if not InputQuery('修改信息', '请输入新的文字:', sInputText) then exit;
  end;
  if sInputText = '' then begin
     Application.MessageBox('请输入正确的文本!','错误信息', MB_OK + MB_ICONERROR );
     exit;
  end;
  ListBoxFilterText.Items[ListBoxFilterText.ItemIndex]:=sInputText;
end;

procedure TfrmMessageFilterConfig.ListBoxFilterTextDblClick(
  Sender: TObject);
begin
  ButtonModClick(Sender);
end;

procedure TfrmMessageFilterConfig.ButtonAddClick(Sender: TObject);
var
  sInputText:String;
begin
//  sInputText:= InputBox('增加过滤文字', '请输入新的文字:', '');
  if not InputQuery('增加过滤文字', '请输入新的文字:', sInputText) then exit;

  if sInputText = '' then begin
     Application.MessageBox('请输入正确的文本!','错误信息', MB_OK + MB_ICONERROR );
     exit;
  end;
  ListBoxFilterText.Items.Add(sInputText);
end;

procedure TfrmMessageFilterConfig.ButtonDelClick(Sender: TObject);
var
  nSelectIndex:Integer;
begin
  nSelectIndex:= ListBoxFilterText.ItemIndex;
  if ( nSelectIndex >= 0) and (nSelectIndex < ListBoxFilterText.Items.Count) then begin
    ListBoxFilterText.Items.Delete(nSelectIndex);
  end;
  if nSelectIndex >= ListBoxFilterText.Items.Count then
    ListBoxFilterText.ItemIndex:=nSelectIndex -1
  else  ListBoxFilterText.ItemIndex:=nSelectIndex;
  if ListBoxFilterText.ItemIndex < 0 then begin
    ButtonDel.Enabled:=False;
    ButtonMod.Enabled:=False;
  end;
end;

end.
