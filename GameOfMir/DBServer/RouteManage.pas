unit RouteManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmRouteManage = class(TForm)
    GroupBox1: TGroupBox;
    ListViewRoute: TListView;
    ButtonEdit: TButton;
    ButtonDelete: TButton;
    ButtonOK: TButton;
    ButtonAddRoute: TButton;
    Label1: TLabel;
    procedure ButtonDeleteClick(Sender: TObject);
  private
    procedure RefShowRoute();
    procedure ProcessListViewDelete();
    procedure ProcessListViewSelect();
    procedure ProcessAddRoute();
    procedure ProcessEditRoute();

    { Private declarations }
  public
    procedure Open;
    { Public declarations }
  end;

var
  frmRouteManage: TfrmRouteManage;

implementation

uses DBShare, RouteEdit;

{$R *.dfm}

{ TfrmRouteManage }

procedure TfrmRouteManage.Open;
begin
  RefShowRoute();

  ShowModal;
end;

procedure TfrmRouteManage.RefShowRoute;
var
  I,II: Integer;
  ListItem:TListItem;
  RouteInfo:pTRouteInfo;
  sGameGate:String;
begin
  ListViewRoute.Clear;
  ButtonEdit.Enabled:=False;
  ButtonDelete.Enabled:=False;  
  for I := Low(g_RouteInfo) to High(g_RouteInfo) do begin
    RouteInfo:=@g_RouteInfo[I];
    if RouteInfo.nGateCount = 0 then break;
    sGameGate:='';  
    ListItem:=ListViewRoute.Items.Add;
    ListItem.Data:=RouteInfo;
    ListItem.Caption:=IntToStr(I);
    ListItem.SubItems.Add(RouteInfo.sSelGateIP);
    ListItem.SubItems.Add(IntToStr(RouteInfo.nGateCount));
    for II := 0 to RouteInfo.nGateCount - 1 do begin
      sGameGate:=format('%s %s:%d ',[sGameGate,RouteInfo.sGameGateIP[II],RouteInfo.nGameGatePort[II]]);
    end;
    ListItem.SubItems.Add(sGameGate);
  end;

end;

procedure TfrmRouteManage.ButtonDeleteClick(Sender: TObject);
begin
  if Sender = ButtonDelete then begin
    ProcessListViewDelete();
  end else
  if Sender = ListViewRoute then begin
    ProcessListViewSelect();
  end else
  if Sender = ButtonAddRoute then begin
    ProcessAddRoute();
  end else
  if Sender = ButtonEdit then begin
    ProcessEditRoute();
  end else
  if Sender = ButtonOK then begin
    Close();
  end;
end;

procedure TfrmRouteManage.ProcessListViewSelect;
var
  ListItem:TListItem;
begin
  ListItem:=ListViewRoute.Selected;
  if ListItem = nil then exit;
  ButtonEdit.Enabled:=True;
  ButtonDelete.Enabled:=True;
end;

procedure TfrmRouteManage.ProcessListViewDelete;
var
  II:Integer;
  ListItem:TListItem;
  RouteInfo:pTRouteInfo;
begin
  ListItem:=ListViewRoute.Selected;
  if ListItem = nil then exit;
  RouteInfo:=ListItem.Data;
  RouteInfo.nGateCount:=0;
  RouteInfo.sSelGateIP:='';

  for II := Low(RouteInfo.sGameGateIP) to High(RouteInfo.sGameGateIP) do begin
    RouteInfo.sGameGateIP[II]:='';
    RouteInfo.nGameGatePort[II]:=0;
  end;
  RefShowRoute();

end;

procedure TfrmRouteManage.ProcessAddRoute;
var
  ListItem:TListItem;
  RouteInfo:pTRouteInfo;
  nNulIdx:Integer;
  AddRoute:TRouteInfo;
begin
  nNulIdx:=ListViewRoute.Items.Count;
  if nNulIdx >= 20 then begin
    MessageBox(Handle,'路由条数已经达到指定数量,不能再增加路由...','提示信息',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  RouteInfo:=@g_RouteInfo[nNulIdx];
  frmRouteEdit.m_RouteInfo:=RouteInfo^;
  frmRouteEdit.Caption:='增加网关路由';
  AddRoute:=frmRouteEdit.Open;
  if AddRoute.nGateCount >= 1 then begin
    RouteInfo^:=AddRoute;
  end;
  RefShowRoute();
end;

procedure TfrmRouteManage.ProcessEditRoute;
var
  ListItem:TListItem;
  RouteInfo:pTRouteInfo;
  EditRoute:TRouteInfo;
begin
  ListItem:=ListViewRoute.Selected;
  if ListItem = nil then exit;
  RouteInfo:=ListItem.Data;
  frmRouteEdit.m_RouteInfo:=RouteInfo^;
  frmRouteEdit.Caption:='增加网关路由';
  EditRoute:=frmRouteEdit.Open;
  if EditRoute.nGateCount >= 1 then begin
    RouteInfo^:=EditRoute;
  end;
  RefShowRoute();

end;

end.
