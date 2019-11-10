unit ViewOnlineHuman;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls, MudUtil;

type
  TfrmViewOnlineHuman = class(TForm)
    PanelStatus: TPanel;
    GridHuman: TStringGrid;
    ButtonRefGrid: TButton;
    ComboBoxSort: TComboBox;
    Label1: TLabel;
    Timer: TTimer;
    EditSearchName: TEdit;
    ButtonSearch: TButton;
    ButtonView: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonRefGridClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBoxSortClick(Sender: TObject);
    procedure GridHumanDblClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ButtonSearchClick(Sender: TObject);
    procedure ButtonViewClick(Sender: TObject);
  private
    ViewList: TStringList;
    dwTimeOutTick: LongWord;
    procedure RefGridSession();
    procedure GetOnlineList();
    procedure SortOnlineList(nSort: Integer);
    procedure ShowHumanInfo();
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmViewOnlineHuman: TfrmViewOnlineHuman;

implementation

uses UsrEngn, M2Share, ObjBase, HUtil32, HumanInfo;

{$R *.dfm}

{ TfrmViewOnlineHuman }



procedure TfrmViewOnlineHuman.Open;
begin
  frmHumanInfo := TfrmHumanInfo.Create(Owner);
  dwTimeOutTick := GetTickCount();
  GetOnlineList();
  RefGridSession();
  Timer.Enabled := True;
  ShowModal;
  Timer.Enabled := False;
  frmHumanInfo.Free;
end;
procedure TfrmViewOnlineHuman.GetOnlineList;
var
  i: Integer;
begin
  ViewList.Clear;
  try
    EnterCriticalSection(ProcessHumanCriticalSection);
    for i := 0 to UserEngine.m_PlayObjectList.Count - 1 do
    begin
      ViewList.AddObject(UserEngine.m_PlayObjectList.Strings[i], UserEngine.m_PlayObjectList.Objects[i]);
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;
procedure TfrmViewOnlineHuman.RefGridSession;
var
  i: Integer;
  PlayObject: TPlayObject;
begin
  PanelStatus.Caption := 'Refreshing Grid...';
  GridHuman.Visible := False;
  GridHuman.Cells[0, 1] := '';
  GridHuman.Cells[1, 1] := '';
  GridHuman.Cells[2, 1] := '';
  GridHuman.Cells[3, 1] := '';
  GridHuman.Cells[4, 1] := '';
  GridHuman.Cells[5, 1] := '';
  GridHuman.Cells[6, 1] := '';
  GridHuman.Cells[7, 1] := '';
  GridHuman.Cells[8, 1] := '';
  GridHuman.Cells[9, 1] := '';
  GridHuman.Cells[10, 1] := '';
  GridHuman.Cells[11, 1] := '';
  GridHuman.Cells[12, 1] := '';
  GridHuman.Cells[13, 1] := '';

  if ViewList.Count <= 0 then
  begin
    GridHuman.RowCount := 2;
    GridHuman.FixedRows := 1;
  end else
  begin
    GridHuman.RowCount := ViewList.Count + 1;
  end;
  for i := 0 to ViewList.Count - 1 do
  begin
    PlayObject := TPlayObject(ViewList.Objects[i]);
    GridHuman.Cells[0, i + 1] := IntToStr(i);
    GridHuman.Cells[1, i + 1] := PlayObject.m_sCharName;
    GridHuman.Cells[2, i + 1] := IntToStr(PlayObject.m_btGender);
    GridHuman.Cells[3, i + 1] := IntToStr(PlayObject.m_btJob);
    GridHuman.Cells[4, i + 1] := IntToStr(PlayObject.m_Abil.Level);
    GridHuman.Cells[5, i + 1] := PlayObject.m_sMapName;
    GridHuman.Cells[6, i + 1] := IntToStr(PlayObject.m_nCurrX) + ':' + IntToStr(PlayObject.m_nCurrY);
    GridHuman.Cells[7, i + 1] := PlayObject.m_sUserID;
    GridHuman.Cells[8, i + 1] := PlayObject.m_sIPaddr;
    GridHuman.Cells[9, i + 1] := IntToStr(PlayObject.m_btPermission);
    GridHuman.Cells[10, i + 1] := PlayObject.m_sIPLocal; // GetIPLocal(PlayObject.m_sIPaddr);
    GridHuman.Cells[11, i + 1] := IntToStr(PlayObject.m_nGameGold);
    GridHuman.Cells[12, i + 1] := IntToStr(PlayObject.m_nGamePoint);
    GridHuman.Cells[13, i + 1] := IntToStr(PlayObject.m_nPayMentPoint);
  end;
  GridHuman.Visible := True;
end;

procedure TfrmViewOnlineHuman.FormCreate(Sender: TObject);
begin
  ViewList := TStringList.Create;
  GridHuman.Cells[0, 0] := '序号';
  GridHuman.Cells[1, 0] := '人物名称';
  GridHuman.Cells[2, 0] := '性别';
  GridHuman.Cells[3, 0] := '职业';
  GridHuman.Cells[4, 0] := '等级';
  GridHuman.Cells[5, 0] := '地图';
  GridHuman.Cells[6, 0] := '座标';
  GridHuman.Cells[7, 0] := '登录帐号';
  GridHuman.Cells[8, 0] := '登录IP';
  GridHuman.Cells[9, 0] := '权限';
  GridHuman.Cells[10, 0] := '所在地区';
  GridHuman.Cells[11, 0] := g_Config.sGameGoldName;
  GridHuman.Cells[12, 0] := g_Config.sGamePointName;
  GridHuman.Cells[13, 0] := g_Config.sPayMentPointName;
end;

procedure TfrmViewOnlineHuman.ButtonRefGridClick(Sender: TObject);
begin
  dwTimeOutTick := GetTickCount();
  GetOnlineList();
  RefGridSession();
end;

procedure TfrmViewOnlineHuman.FormDestroy(Sender: TObject);
begin
  ViewList.Free;
end;



procedure TfrmViewOnlineHuman.ComboBoxSortClick(Sender: TObject);
begin
  if ComboBoxSort.ItemIndex < 0 then Exit;
  dwTimeOutTick := GetTickCount();
  GetOnlineList();
  SortOnlineList(ComboBoxSort.ItemIndex);
  RefGridSession();
end;

procedure TfrmViewOnlineHuman.SortOnlineList(nSort: Integer);
var
  i: Integer;
  SortList: TStringList;
begin
  SortList := TStringList.Create;
  case nSort of
    0:
      begin
        ViewList.Sort;
        Exit;
      end;
    1:
      begin
        for i := 0 to ViewList.Count - 1 do
        begin
          SortList.AddObject(IntToStr(TPlayObject(ViewList.Objects[i]).m_btGender), ViewList.Objects[i]);
        end;
      end;
    2:
      begin
        for i := 0 to ViewList.Count - 1 do
        begin
          SortList.AddObject(IntToStr(TPlayObject(ViewList.Objects[i]).m_btJob), ViewList.Objects[i]);
        end;
      end;
    3:
      begin
        for i := 0 to ViewList.Count - 1 do
        begin
          SortList.AddObject(IntToStr(TPlayObject(ViewList.Objects[i]).m_Abil.Level), ViewList.Objects[i]);
        end;
      end;
    4:
      begin
        for i := 0 to ViewList.Count - 1 do
        begin
          SortList.AddObject(TPlayObject(ViewList.Objects[i]).m_sMapName, ViewList.Objects[i]);
        end;
      end;
    5:
      begin
        for i := 0 to ViewList.Count - 1 do
        begin
          SortList.AddObject(TPlayObject(ViewList.Objects[i]).m_sIPaddr, ViewList.Objects[i]);
        end;
      end;
    6:
      begin
        for i := 0 to ViewList.Count - 1 do
        begin
          SortList.AddObject(IntToStr(TPlayObject(ViewList.Objects[i]).m_btPermission), ViewList.Objects[i]);
        end;
      end;
    7:
      begin
        for i := 0 to ViewList.Count - 1 do
        begin
          SortList.AddObject(TPlayObject(ViewList.Objects[i]).m_sIPLocal, ViewList.Objects[i]);
        end;
      end;
  end;
  ViewList.Free;
  ViewList := SortList;
  ViewList.Sort;
end;

procedure TfrmViewOnlineHuman.GridHumanDblClick(Sender: TObject);
begin
  ShowHumanInfo();
end;

procedure TfrmViewOnlineHuman.TimerTimer(Sender: TObject);
begin
  if (GetTickCount - dwTimeOutTick > 30000) and (ViewList.Count > 0) then
  begin
    ViewList.Clear;
    RefGridSession();
  end;
end;

procedure TfrmViewOnlineHuman.ButtonSearchClick(Sender: TObject);
var
  i: Integer;
  sHumanName: string;
  PlayObject: TPlayObject;
begin
  sHumanName := Trim(EditSearchName.Text);
  if sHumanName = '' then
  begin
    Application.MessageBox('请选择一个排序条件!', '错误信息', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;
  for i := 0 to ViewList.Count - 1 do
  begin
    PlayObject := TPlayObject(ViewList.Objects[i]);
    if CompareText(PlayObject.m_sCharName, sHumanName) = 0 then
    begin
      GridHuman.Row := i + 1;
      Exit;
    end;
  end;
  Application.MessageBox('此人物无法找到..', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmViewOnlineHuman.ButtonViewClick(Sender: TObject);
begin
  ShowHumanInfo();
end;

procedure TfrmViewOnlineHuman.ShowHumanInfo;
var
  nSelIndex: Integer;
  sPlayObjectName: string;
  PlayObject: TPlayObject;
begin
  nSelIndex := GridHuman.Row;
  Dec(nSelIndex);
  if (nSelIndex < 0) or (ViewList.Count <= nSelIndex) then
  begin
    Application.MessageBox('请先选择一个要查看的人物！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  sPlayObjectName := GridHuman.Cells[1, nSelIndex + 1];
  PlayObject := UserEngine.GetPlayObject(sPlayObjectName);
  if PlayObject = nil then
  begin
    Application.MessageBox('此人物已经不在线！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;

  frmHumanInfo.PlayObject := TPlayObject(ViewList.Objects[nSelIndex]);
  frmHumanInfo.Top := Self.Top + 20;
  frmHumanInfo.Left := Self.Left;
  frmHumanInfo.Open();
end;

end.
