unit DlgConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin,MShare,DWinCtl;

type
  TfrmDlgConfig = class(TForm)
    DlgList: TListBox;
    Label1: TLabel;
    GameWindowName: TGroupBox;
    EditTop: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    EditLeft: TSpinEdit;
    EditHeight: TSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    EditWidth: TSpinEdit;
    EditImage: TSpinEdit;
    Label6: TLabel;
    ButtonShow: TButton;
    GroupBox1: TGroupBox;
    EditTestX: TSpinEdit;
    Label7: TLabel;
    Label8: TLabel;
    EditTestY: TSpinEdit;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    EditSpellTime: TSpinEdit;
    EditHitTime: TSpinEdit;
    GroupBox3: TGroupBox;
    CheckBoxDrawTileMap: TCheckBox;
    CheckBoxDrawDropItem: TCheckBox;
    GroupBox4: TGroupBox;
    Label11: TLabel;
    EditKey: TEdit;
    Label12: TLabel;
    EditServerName: TEdit;
    Label13: TLabel;
    EditRegIPaddr: TEdit;
    Label14: TLabel;
    EditRegPort: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure DlgListClick(Sender: TObject);
    procedure EditTopChange(Sender: TObject);
    procedure EditLeftChange(Sender: TObject);
    procedure EditWidthChange(Sender: TObject);
    procedure EditHeightChange(Sender: TObject);
    procedure EditImageChange(Sender: TObject);
    procedure ButtonShowClick(Sender: TObject);
    procedure EditTestYChange(Sender: TObject);
    procedure EditTestXChange(Sender: TObject);
    procedure EditSpellTimeChange(Sender: TObject);
    procedure EditHitTimeChange(Sender: TObject);
    procedure CheckBoxDrawTileMapClick(Sender: TObject);
    procedure CheckBoxDrawDropItemClick(Sender: TObject);
  private
    GameControl:pTControlInfo;
    boChange:Boolean;
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmDlgConfig: TfrmDlgConfig;

implementation

uses FState, ClMain;

{$R *.dfm}

{ TfrmDlgConfig }

procedure TfrmDlgConfig.Open;
begin
  EditTestX.Value:=g_nTestX;
  EditTestY.Value:=g_nTestY;
  EditSpellTime.Value:=g_dwSpellTime;
  EditHitTime.Value:=g_nHitTime;

  CheckBoxDrawTileMap.Checked:=g_boDrawTileMap;
  CheckBoxDrawDropItem.Checked:=g_boDrawDropItem;
  EditKey.Text        :=g_RegInfo.sKey;
  EditServerName.Text :=g_RegInfo.sServerName;
  EditRegIPaddr.Text  :=g_RegInfo.sRegSrvIP;
  EditRegPort.Text    :=IntToStr(g_RegInfo.nRegPort);

  //ShowModal();
  Show;

end;

procedure TfrmDlgConfig.FormCreate(Sender: TObject);
begin
  GameControl:=nil;
  boChange:=False;
  DlgList.AddItem('游戏控制台',TObject(@DlgConf.DBottom));
  DlgList.AddItem('人物状态按钮',TObject(@DlgConf.DMyState));
  DlgList.AddItem('人物背包按钮',TObject(@DlgConf.DMyBag));
  DlgList.AddItem('人物技能按钮',TObject(@DlgConf.DMyMagic));
  DlgList.AddItem('游戏选项按钮',TObject(@DlgConf.DOption));
  DlgList.AddItem('小地图按钮',TObject(@DlgConf.DBotMiniMap));
  DlgList.AddItem('交易按钮',TObject(@DlgConf.DBotTrade));
  DlgList.AddItem('行会按钮',TObject(@DlgConf.DBotGuild));
  DlgList.AddItem('组队按钮',TObject(@DlgConf.DBotGroup));
  DlgList.AddItem('属性调整按钮',TObject(@DlgConf.DBotPlusAbil));
//  DlgList.AddItem('好友按钮',TObject(@DlgConf.DBotFriend));    //lzx 2019-11-10
  DlgList.AddItem('人物能量按钮',TObject(@DlgConf.DBotMemo));
  DlgList.AddItem('退出游戏按钮',TObject(@DlgConf.DBotExit));
  DlgList.AddItem('小退游戏按钮',TObject(@DlgConf.DBotLogout));
  DlgList.AddItem('快捷物品按钮一',TObject(@DlgConf.DBotLogout));
  DlgList.AddItem('快捷物品按钮二',TObject(@DlgConf.DBelt1));
  DlgList.AddItem('快捷物品按钮三',TObject(@DlgConf.DBelt2));
  DlgList.AddItem('快捷物品按钮四',TObject(@DlgConf.DBelt3));
  DlgList.AddItem('快捷物品按钮五',TObject(@DlgConf.DBelt4));
  DlgList.AddItem('快捷物品按钮六',TObject(@DlgConf.DBelt5));
  DlgList.AddItem('快捷物品按钮七',TObject(@DlgConf.DBelt6));

  DlgList.AddItem('技能快捷键设置窗口',TObject(@DlgConf.DKeySelDlg));
  DlgList.AddItem('快捷键设置窗口图标',TObject(@DlgConf.DKsIcon));
  DlgList.AddItem('快捷键设置窗口F1',TObject(@DlgConf.DKsF1));
  DlgList.AddItem('快捷键设置窗口F2',TObject(@DlgConf.DKsF2));
  DlgList.AddItem('快捷键设置窗口F3',TObject(@DlgConf.DKsF3));
  DlgList.AddItem('快捷键设置窗口F4',TObject(@DlgConf.DKsF4));
  DlgList.AddItem('快捷键设置窗口F5',TObject(@DlgConf.DKsF5));
  DlgList.AddItem('快捷键设置窗口F6',TObject(@DlgConf.DKsF6));
  DlgList.AddItem('快捷键设置窗口F7',TObject(@DlgConf.DKsF7));
  DlgList.AddItem('快捷键设置窗口F8',TObject(@DlgConf.DKsF8));
  DlgList.AddItem('快捷键设置窗口Ctrl+F1',TObject(@DlgConf.DKsConF1));
  DlgList.AddItem('快捷键设置窗口Ctrl+F2',TObject(@DlgConf.DKsConF2));
  DlgList.AddItem('快捷键设置窗口Ctrl+F3',TObject(@DlgConf.DKsConF3));
  DlgList.AddItem('快捷键设置窗口Ctrl+F4',TObject(@DlgConf.DKsConF4));
  DlgList.AddItem('快捷键设置窗口Ctrl+F5',TObject(@DlgConf.DKsConF5));
  DlgList.AddItem('快捷键设置窗口Ctrl+F6',TObject(@DlgConf.DKsConF6));
  DlgList.AddItem('快捷键设置窗口Ctrl+F7',TObject(@DlgConf.DKsConF7));
  DlgList.AddItem('快捷键设置窗口Ctrl+F8',TObject(@DlgConf.DKsConF8));
  DlgList.AddItem('快捷键设置窗口清除按钮',TObject(@DlgConf.DKsNone));
  DlgList.AddItem('快捷键设置窗口确定按钮',TObject(@DlgConf.DKsOk));

  DlgList.AddItem('自定义窗口关闭按钮',TObject(@DlgConf.DChgGamePwdClose));

  DlgList.AddItem('信箱按钮',TObject(@DlgConf.DBotMemo));
  DlgList.AddItem('物品栏',TObject(@DlgConf.DItemGrid));
  DlgList.AddItem('物品栏关闭按钮',TObject(@DlgConf.DClosebag));
  DlgList.AddItem('物品栏金币',TObject(@DlgConf.DGold));

  Self.ParentWindow:=FrmMain.Handle;
end;

procedure TfrmDlgConfig.DlgListClick(Sender: TObject);
begin
  boChange:=False;
  GameWindowName.Caption:=DlgList.Items.Strings[DlgList.ItemIndex];
  GameControl:=pTControlInfo(DlgList.Items.Objects[DlgList.ItemIndex]);
  EditTop.Value:=GameControl.Top;
  EditLeft.Value:=GameControl.Left;
  EditWidth.Value:=GameControl.Width;
  EditHeight.Value:=GameControl.Height;
  EditImage.Value:=GameControl.Image;
  if GameControl <> nil then GameWindowName.Enabled:=True;
    
  boChange:=True;
end;

procedure TfrmDlgConfig.EditTopChange(Sender: TObject);
begin
  if not boChange then exit;
  GameControl.Top:=EditTop.Value;
  GameControl.Obj.Top:=GameControl.Top;
end;

procedure TfrmDlgConfig.EditLeftChange(Sender: TObject);
begin
  if not boChange then exit;
  GameControl.Left:=EditLeft.Value;
  GameControl.Obj.Left:=GameControl.Left;

end;

procedure TfrmDlgConfig.EditWidthChange(Sender: TObject);
begin
  if not boChange then exit;
  GameControl.Width:=EditWidth.Value;
  GameControl.Obj.Width:=GameControl.Width;
end;

procedure TfrmDlgConfig.EditHeightChange(Sender: TObject);
begin
  if not boChange then exit;
  GameControl.Height:=EditHeight.Value;
  GameControl.Obj.Height:=GameControl.Height;
end;

procedure TfrmDlgConfig.EditImageChange(Sender: TObject);
begin
  if not boChange then exit;
  GameControl.Image:=EditImage.Value;
  GameControl.Obj.SetImgIndex(g_WMainImages,GameControl.Image);
end;

procedure TfrmDlgConfig.ButtonShowClick(Sender: TObject);
begin
  if GameControl <> nil then begin
    GameControl.Obj.Visible:= not GameControl.Obj.Visible;
  end;
    
end;

procedure TfrmDlgConfig.EditTestYChange(Sender: TObject);
begin
  g_nTestY:=EditTestY.Value;
end;

procedure TfrmDlgConfig.EditTestXChange(Sender: TObject);
begin
  g_nTestX:=EditTestX.Value;
end;

procedure TfrmDlgConfig.EditSpellTimeChange(Sender: TObject);
begin
  g_dwSpellTime:=EditSpellTime.Value;
end;

procedure TfrmDlgConfig.EditHitTimeChange(Sender: TObject);
begin
  g_nHitTime:=EditHitTime.Value;
end;

procedure TfrmDlgConfig.CheckBoxDrawTileMapClick(Sender: TObject);
begin
  g_boDrawTileMap:=CheckBoxDrawTileMap.Checked;
end;

procedure TfrmDlgConfig.CheckBoxDrawDropItemClick(Sender: TObject);
begin
  g_boDrawDropItem:=CheckBoxDrawDropItem.Checked;
end;

end.
