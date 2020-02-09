unit GameCommand;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, StdCtrls, Spin,SDK,grobal2;

type
  TfrmGameCmd = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    StringGridGameCmd: TStringGrid;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditUserCmdName: TEdit;
    EditUserCmdPerMission: TSpinEdit;
    Label6: TLabel;
    EditUserCmdOK: TButton;
    LabelUserCmdFunc: TLabel;
    LabelUserCmdParam: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditUserCmdSave: TButton;
    StringGridGameMasterCmd: TStringGrid;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    LabelGameMasterCmdFunc: TLabel;
    LabelGameMasterCmdParam: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EditGameMasterCmdName: TEdit;
    EditGameMasterCmdPerMission: TSpinEdit;
    EditGameMasterCmdOK: TButton;
    EditGameMasterCmdSave: TButton;
    StringGridGameDebugCmd: TStringGrid;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    LabelGameDebugCmdFunc: TLabel;
    LabelGameDebugCmdParam: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    EditGameDebugCmdName: TEdit;
    EditGameDebugCmdPerMission: TSpinEdit;
    EditGameDebugCmdOK: TButton;
    EditGameDebugCmdSave: TButton;
    procedure FormCreate(Sender: TObject);
    procedure StringGridGameCmdClick(Sender: TObject);
    procedure EditUserCmdNameChange(Sender: TObject);
    procedure EditUserCmdPerMissionChange(Sender: TObject);
    procedure EditUserCmdOKClick(Sender: TObject);
    procedure EditUserCmdSaveClick(Sender: TObject);
    procedure StringGridGameMasterCmdClick(Sender: TObject);
    procedure EditGameMasterCmdNameChange(Sender: TObject);
    procedure EditGameMasterCmdPerMissionChange(Sender: TObject);
    procedure EditGameMasterCmdOKClick(Sender: TObject);
    procedure StringGridGameDebugCmdClick(Sender: TObject);
    procedure EditGameDebugCmdNameChange(Sender: TObject);
    procedure EditGameDebugCmdPerMissionChange(Sender: TObject);
    procedure EditGameDebugCmdOKClick(Sender: TObject);
    procedure EditGameMasterCmdSaveClick(Sender: TObject);
    procedure EditGameDebugCmdSaveClick(Sender: TObject);
  private
    nRefGameUserIndex   :Integer;
    nRefGameMasterIndex :Integer;
    nRefGameDebugIndex  :Integer;
    procedure RefUserCommand();
    procedure RefGameMasterCommand();
    procedure RefGameMasterCmd(GameCmd:pTGameCmd;sCmdParam,sDesc:String);
    procedure RefDebugCommand();
    procedure RefGameDebugCmd(GameCmd: pTGameCmd; sCmdParam,
      sDesc: String);
    procedure RefGameUserCmd(GameCmd: pTGameCmd; sCmdParam, sDesc: String);
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmGameCmd: TfrmGameCmd;

implementation

uses M2Share;

{$R *.dfm}

procedure TfrmGameCmd.FormCreate(Sender: TObject);
begin
  PageControl.ActivePageIndex:=0;
  StringGridGameCmd.RowCount:=50;
  StringGridGameCmd.Cells[0,0]:='游戏命令';
  StringGridGameCmd.Cells[1,0]:='所需权限';
  StringGridGameCmd.Cells[2,0]:='命令格式';
  StringGridGameCmd.Cells[3,0]:='命令说明';

  StringGridGameMasterCmd.RowCount:=105;
  StringGridGameMasterCmd.Cells[0,0]:='游戏命令';
  StringGridGameMasterCmd.Cells[1,0]:='所需权限';
  StringGridGameMasterCmd.Cells[2,0]:='命令格式';
  StringGridGameMasterCmd.Cells[3,0]:='命令说明';

  StringGridGameDebugCmd.RowCount:=41;
  StringGridGameDebugCmd.Cells[0,0]:='游戏命令';
  StringGridGameDebugCmd.Cells[1,0]:='所需权限';
  StringGridGameDebugCmd.Cells[2,0]:='命令格式';
  StringGridGameDebugCmd.Cells[3,0]:='命令说明';


end;

procedure TfrmGameCmd.Open;
begin
  RefUserCommand();
  RefGameMasterCommand();
  RefDebugCommand();
  ShowModal;
end;
procedure TfrmGameCmd.RefGameUserCmd(GameCmd:pTGameCmd;sCmdParam,sDesc:String);
begin
  Inc(nRefGameUserIndex);
  if StringGridGameCmd.RowCount - 1 < nRefGameUserIndex then begin
    StringGridGameCmd.RowCount:=nRefGameUserIndex + 1;
  end;

  StringGridGameCmd.Cells[0,nRefGameUserIndex]:=GameCmd.sCmd;
  StringGridGameCmd.Cells[1,nRefGameUserIndex]:=IntToStr(GameCmd.nPermissionMin) + '/' + IntToStr(GameCmd.nPermissionMax);
  StringGridGameCmd.Cells[2,nRefGameUserIndex]:=sCmdParam;
  StringGridGameCmd.Cells[3,nRefGameUserIndex]:=sDesc;
  StringGridGameCmd.Objects[0,nRefGameUserIndex]:=TObject(GameCmd);
end;

//  StringGridGameCmd.Cells[3,12]:='未使用';
//  StringGridGameCmd.Cells[3,13]:='移动地图指定座标(需要戴传送装备)';
//  StringGridGameCmd.Cells[3,14]:='探测人物所在位置(需要戴传送装备)';
//  StringGridGameCmd.Cells[3,15]:='允许记忆传送';
//  StringGridGameCmd.Cells[3,16]:='将组队人员传送到身边(需要戴记忆全套装备)';
//  StringGridGameCmd.Cells[3,17]:='允许行会传送';
//  StringGridGameCmd.Cells[3,18]:='将行会成员传送身边(需要戴行会传送装备)';
//  StringGridGameCmd.Cells[3,19]:='开启仓库密码锁';
//  StringGridGameCmd.Cells[3,20]:='开启登录密码锁';
//  StringGridGameCmd.Cells[3,21]:='将仓库密码锁上';
//  StringGridGameCmd.Cells[3,22]:='设置仓库密码';
//  StringGridGameCmd.Cells[3,23]:='修改仓库密码';
//  StringGridGameCmd.Cells[3,24]:='清除密码(先开锁再清除密码)';
//  StringGridGameCmd.Cells[3,25]:='未使用';
//  StringGridGameCmd.Cells[3,26]:='查询夫妻位置';
//  StringGridGameCmd.Cells[3,27]:='允许夫妻传送';
//  StringGridGameCmd.Cells[3,28]:='夫妻将对方传送到身边';
//  StringGridGameCmd.Cells[3,29]:='查询师徒位置';
//  StringGridGameCmd.Cells[3,30]:='允许师徒传送';
//  StringGridGameCmd.Cells[3,31]:='师父将徒弟召唤到身边';
//  StringGridGameCmd.Cells[3,32]:='更换攻击模式(此命令不要修改)';
//  StringGridGameCmd.Cells[3,33]:='宝宝攻击状态(此命令不要修改)';
//  StringGridGameCmd.Cells[3,34]:='带马牌后骑上马';
//  StringGridGameCmd.Cells[3,35]:='从马上下来';
//  StringGridGameCmd.Cells[3,36]:='';
//  StringGridGameCmd.Cells[3,37]:='开启/关闭登录锁';

procedure TfrmGameCmd.RefUserCommand;
begin
  EditUserCmdOK.Enabled:=False;
  nRefGameUserIndex:=0;

  RefGameUserCmd(@g_GameCommand.DATA,
                   '@' + g_GameCommand.DATA.sCmd,
                   '查看当前服务器日期时间');
  RefGameUserCmd(@g_GameCommand.PRVMSG,
                   '@' + g_GameCommand.PRVMSG.sCmd,
                   '禁止指定人物发的私聊信息');
  RefGameUserCmd(@g_GameCommand.ALLOWMSG,
                   '@' + g_GameCommand.ALLOWMSG.sCmd,
                   '禁止别人向自己发私聊信息');
  RefGameUserCmd(@g_GameCommand.LETSHOUT,
                   '@' + g_GameCommand.LETSHOUT.sCmd,
                   '禁止接收组队聊天信息');
  RefGameUserCmd(@g_GameCommand.LETTRADE,
                   '@' + g_GameCommand.LETTRADE.sCmd,
                   '禁止交易交易物品');
  RefGameUserCmd(@g_GameCommand.LETGUILD,
                   '@' + g_GameCommand.LETGUILD.sCmd,
                   '允许加入行会');
  RefGameUserCmd(@g_GameCommand.ENDGUILD,
                   '@' + g_GameCommand.ENDGUILD.sCmd,
                   '退出当前所加入的行会');
  RefGameUserCmd(@g_GameCommand.BANGUILDCHAT,
                   '@' + g_GameCommand.BANGUILDCHAT.sCmd,
                   '禁止接收行会聊天信息');
  RefGameUserCmd(@g_GameCommand.AUTHALLY,
                   '@' + g_GameCommand.AUTHALLY.sCmd,
                   '许行会进入联盟');
  RefGameUserCmd(@g_GameCommand.AUTH,
                   '@' + g_GameCommand.AUTH.sCmd,
                   '开始进行行会联盟');
  RefGameUserCmd(@g_GameCommand.AUTHCANCEL,
                   '@' + g_GameCommand.AUTHCANCEL.sCmd,
                   '取消行会联盟关系');
  RefGameUserCmd(@g_GameCommand.DIARY,
                   '@' + g_GameCommand.DIARY.sCmd,
                   '未使用');
  RefGameUserCmd(@g_GameCommand.USERMOVE,
                   '@' + g_GameCommand.USERMOVE.sCmd,
                   '移动地图指定座标(需要戴传送装备)');
  RefGameUserCmd(@g_GameCommand.SEARCHING,
                   '@' + g_GameCommand.SEARCHING.sCmd,
                   '探测人物所在位置(需要戴传送装备)');
  RefGameUserCmd(@g_GameCommand.ALLOWGROUPCALL,
                   '@' + g_GameCommand.ALLOWGROUPCALL.sCmd,
                   '许记忆传送');
  RefGameUserCmd(@g_GameCommand.GROUPRECALLL,
                   '@' + g_GameCommand.GROUPRECALLL.sCmd,
                   '将组队人员传送到身边(需要戴记忆全套装备)');
  RefGameUserCmd(@g_GameCommand.ALLOWGUILDRECALL,
                   '@' + g_GameCommand.ALLOWGUILDRECALL.sCmd,
                   '允许行会传送');
  RefGameUserCmd(@g_GameCommand.GUILDRECALLL,
                   '@' + g_GameCommand.GUILDRECALLL.sCmd,
                   '将行会成员传送身边(需要戴行会传送装备)');
  RefGameUserCmd(@g_GameCommand.UNLOCKSTORAGE,
                   '@' + g_GameCommand.UNLOCKSTORAGE.sCmd,
                   '开启仓库密码锁');
  RefGameUserCmd(@g_GameCommand.UNLOCK,
                   '@' + g_GameCommand.UNLOCK.sCmd,
                   '开启登录密码锁');
  RefGameUserCmd(@g_GameCommand.LOCK,
                   '@' + g_GameCommand.LOCK.sCmd,
                   '将仓库密码锁上');
  RefGameUserCmd(@g_GameCommand.SETPASSWORD,
                   '@' + g_GameCommand.SETPASSWORD.sCmd,
                   '设置仓库密码');
  RefGameUserCmd(@g_GameCommand.CHGPASSWORD,
                   '@' + g_GameCommand.CHGPASSWORD.sCmd,
                   '修改仓库密码');
  RefGameUserCmd(@g_GameCommand.UNPASSWORD,
                   '@' + g_GameCommand.UNPASSWORD.sCmd,
                   '清除密码(先开锁再清除密码)');
  RefGameUserCmd(@g_GameCommand.MEMBERFUNCTION,
                   '@' + g_GameCommand.MEMBERFUNCTION.sCmd,
                   '未使用');
  RefGameUserCmd(@g_GameCommand.MEMBERFUNCTIONEX,
                   '@' + g_GameCommand.MEMBERFUNCTIONEX.sCmd,
                   '');
                   
//取消 结婚 与 师徒 的相关内容
{
  RefGameUserCmd(@g_GameCommand.DEAR,
                   '@' + g_GameCommand.DEAR.sCmd,
                   '查询夫妻位置');
  RefGameUserCmd(@g_GameCommand.ALLOWDEARRCALL,
                   '@' + g_GameCommand.ALLOWDEARRCALL.sCmd,
                   '允许夫妻传送');
  RefGameUserCmd(@g_GameCommand.DEARRECALL,
                   '@' + g_GameCommand.DEARRECALL.sCmd,
                   '夫妻将对方传送到身边');
  RefGameUserCmd(@g_GameCommand.MASTER,
                   '@' + g_GameCommand.MASTER.sCmd,
                   '查询师徒位置');
  RefGameUserCmd(@g_GameCommand.ALLOWMASTERRECALL,
                   '@' + g_GameCommand.ALLOWMASTERRECALL.sCmd,
                   '允许师徒传送');
  RefGameUserCmd(@g_GameCommand.MASTERECALL,
                   '@' + g_GameCommand.MASTERECALL.sCmd,
                   '师父将徒弟召唤到身边');
}
                   
  RefGameUserCmd(@g_GameCommand.TAKEONHORSE,
                   '@' + g_GameCommand.TAKEONHORSE.sCmd,
                   '带马牌后骑上马');
  RefGameUserCmd(@g_GameCommand.TAKEOFHORSE,
                   '@' + g_GameCommand.TAKEOFHORSE.sCmd,
                   '从马上下来');

  RefGameUserCmd(@g_GameCommand.LOCKLOGON,
                   '@' + g_GameCommand.LOCKLOGON.sCmd,
                   '开启/关闭登录锁');
  exit;

  StringGridGameCmd.Cells[0,12]:=g_GameCommand.DIARY.sCmd;
  StringGridGameCmd.Cells[1,12]:=IntToStr(g_GameCommand.DIARY.nPermissionMin);
  StringGridGameCmd.Cells[2,12]:='@' + g_GameCommand.DIARY.sCmd;
  StringGridGameCmd.Objects[0,12]:=TObject(@g_GameCommand.DIARY);

  StringGridGameCmd.Cells[0,13]:=g_GameCommand.USERMOVE.sCmd;
  StringGridGameCmd.Cells[1,13]:=IntToStr(g_GameCommand.USERMOVE.nPermissionMin);
  StringGridGameCmd.Cells[2,13]:='@' + g_GameCommand.USERMOVE.sCmd;
  StringGridGameCmd.Objects[0,13]:=TObject(@g_GameCommand.USERMOVE);

  StringGridGameCmd.Cells[0,14]:=g_GameCommand.SEARCHING.sCmd;
  StringGridGameCmd.Cells[1,14]:=IntToStr(g_GameCommand.SEARCHING.nPermissionMin);
  StringGridGameCmd.Cells[2,14]:='@' + g_GameCommand.SEARCHING.sCmd;
  StringGridGameCmd.Objects[0,14]:=TObject(@g_GameCommand.SEARCHING);

  StringGridGameCmd.Cells[0,15]:=g_GameCommand.ALLOWGROUPCALL.sCmd;
  StringGridGameCmd.Cells[1,15]:=IntToStr(g_GameCommand.ALLOWGROUPCALL.nPermissionMin);
  StringGridGameCmd.Cells[2,15]:='@' + g_GameCommand.ALLOWGROUPCALL.sCmd;
  StringGridGameCmd.Objects[0,15]:=TObject(@g_GameCommand.ALLOWGROUPCALL);

  StringGridGameCmd.Cells[0,16]:=g_GameCommand.GROUPRECALLL.sCmd;
  StringGridGameCmd.Cells[1,16]:=IntToStr(g_GameCommand.GROUPRECALLL.nPermissionMin);
  StringGridGameCmd.Cells[2,16]:='@' + g_GameCommand.GROUPRECALLL.sCmd;
  StringGridGameCmd.Objects[0,16]:=TObject(@g_GameCommand.GROUPRECALLL);

  StringGridGameCmd.Cells[0,17]:=g_GameCommand.ALLOWGUILDRECALL.sCmd;
  StringGridGameCmd.Cells[1,17]:=IntToStr(g_GameCommand.ALLOWGUILDRECALL.nPermissionMin);
  StringGridGameCmd.Cells[2,17]:='@' + g_GameCommand.ALLOWGUILDRECALL.sCmd;
  StringGridGameCmd.Objects[0,17]:=TObject(@g_GameCommand.ALLOWGUILDRECALL);

  StringGridGameCmd.Cells[0,18]:=g_GameCommand.GUILDRECALLL.sCmd;
  StringGridGameCmd.Cells[1,18]:=IntToStr(g_GameCommand.GUILDRECALLL.nPermissionMin);
  StringGridGameCmd.Cells[2,18]:='@' + g_GameCommand.GUILDRECALLL.sCmd;
  StringGridGameCmd.Objects[0,18]:=TObject(@g_GameCommand.GUILDRECALLL);

  StringGridGameCmd.Cells[0,19]:=g_GameCommand.UNLOCKSTORAGE.sCmd;
  StringGridGameCmd.Cells[1,19]:=IntToStr(g_GameCommand.UNLOCKSTORAGE.nPermissionMin);
  StringGridGameCmd.Cells[2,19]:='@' + g_GameCommand.UNLOCKSTORAGE.sCmd;
  StringGridGameCmd.Objects[0,19]:=TObject(@g_GameCommand.UNLOCKSTORAGE);

  StringGridGameCmd.Cells[0,20]:=g_GameCommand.UNLOCK.sCmd;
  StringGridGameCmd.Cells[1,20]:=IntToStr(g_GameCommand.UNLOCK.nPermissionMin);
  StringGridGameCmd.Cells[2,20]:='@' + g_GameCommand.UNLOCK.sCmd;
  StringGridGameCmd.Objects[0,20]:=TObject(@g_GameCommand.UNLOCK);

  StringGridGameCmd.Cells[0,21]:=g_GameCommand.LOCK.sCmd;
  StringGridGameCmd.Cells[1,21]:=IntToStr(g_GameCommand.LOCK.nPermissionMin);
  StringGridGameCmd.Cells[2,21]:='@' + g_GameCommand.LOCK.sCmd;
  StringGridGameCmd.Objects[0,21]:=TObject(@g_GameCommand.LOCK);

  StringGridGameCmd.Cells[0,22]:=g_GameCommand.SETPASSWORD.sCmd;
  StringGridGameCmd.Cells[1,22]:=IntToStr(g_GameCommand.SETPASSWORD.nPermissionMin);
  StringGridGameCmd.Cells[2,22]:='@' + g_GameCommand.SETPASSWORD.sCmd;
  StringGridGameCmd.Objects[0,22]:=TObject(@g_GameCommand.SETPASSWORD);

  StringGridGameCmd.Cells[0,23]:=g_GameCommand.CHGPASSWORD.sCmd;
  StringGridGameCmd.Cells[1,23]:=IntToStr(g_GameCommand.CHGPASSWORD.nPermissionMin);
  StringGridGameCmd.Cells[2,23]:='@' + g_GameCommand.CHGPASSWORD.sCmd;
  StringGridGameCmd.Objects[0,23]:=TObject(@g_GameCommand.CHGPASSWORD);

  StringGridGameCmd.Cells[0,24]:=g_GameCommand.UNPASSWORD.sCmd;
  StringGridGameCmd.Cells[1,24]:=IntToStr(g_GameCommand.UNPASSWORD.nPermissionMin);
  StringGridGameCmd.Cells[2,24]:='@' + g_GameCommand.UNPASSWORD.sCmd;
  StringGridGameCmd.Objects[0,24]:=TObject(@g_GameCommand.UNPASSWORD);

  StringGridGameCmd.Cells[0,25]:=g_GameCommand.MEMBERFUNCTION.sCmd;
  StringGridGameCmd.Cells[1,25]:=IntToStr(g_GameCommand.MEMBERFUNCTION.nPermissionMin);
  StringGridGameCmd.Cells[2,25]:='@' + g_GameCommand.MEMBERFUNCTION.sCmd;
  StringGridGameCmd.Objects[0,25]:=TObject(@g_GameCommand.MEMBERFUNCTION);

//取消 结婚 与 师徒 的相关内容
//  StringGridGameCmd.Cells[0,26]:=g_GameCommand.DEAR.sCmd;
//  StringGridGameCmd.Cells[1,26]:=IntToStr(g_GameCommand.DEAR.nPermissionMin);
//  StringGridGameCmd.Cells[2,26]:='@' + g_GameCommand.DEAR.sCmd;
//  StringGridGameCmd.Objects[0,26]:=TObject(@g_GameCommand.DEAR);

//  StringGridGameCmd.Cells[0,27]:=g_GameCommand.ALLOWDEARRCALL.sCmd;
//  StringGridGameCmd.Cells[1,27]:=IntToStr(g_GameCommand.ALLOWDEARRCALL.nPermissionMin);
//  StringGridGameCmd.Cells[2,27]:='@' + g_GameCommand.ALLOWDEARRCALL.sCmd;
//  StringGridGameCmd.Objects[0,27]:=TObject(@g_GameCommand.ALLOWDEARRCALL);

//  StringGridGameCmd.Cells[0,28]:=g_GameCommand.DEARRECALL.sCmd;
//  StringGridGameCmd.Cells[1,28]:=IntToStr(g_GameCommand.DEARRECALL.nPermissionMin);
//  StringGridGameCmd.Cells[2,28]:='@' + g_GameCommand.DEARRECALL.sCmd;
//  StringGridGameCmd.Objects[0,28]:=TObject(@g_GameCommand.DEARRECALL);

//  StringGridGameCmd.Cells[0,29]:=g_GameCommand.MASTER.sCmd;
//  StringGridGameCmd.Cells[1,29]:=IntToStr(g_GameCommand.MASTER.nPermissionMin);
//  StringGridGameCmd.Cells[2,29]:='@' + g_GameCommand.MASTER.sCmd;
//  StringGridGameCmd.Objects[0,29]:=TObject(@g_GameCommand.MASTER);

//  StringGridGameCmd.Cells[0,30]:=g_GameCommand.ALLOWMASTERRECALL.sCmd;
//  StringGridGameCmd.Cells[1,30]:=IntToStr(g_GameCommand.ALLOWMASTERRECALL.nPermissionMin);
//  StringGridGameCmd.Cells[2,30]:='@' + g_GameCommand.ALLOWMASTERRECALL.sCmd;
//  StringGridGameCmd.Objects[0,30]:=TObject(@g_GameCommand.ALLOWMASTERRECALL);

//  StringGridGameCmd.Cells[0,31]:=g_GameCommand.MASTERECALL.sCmd;
//  StringGridGameCmd.Cells[1,31]:=IntToStr(g_GameCommand.MASTERECALL.nPermissionMin);
//  StringGridGameCmd.Cells[2,31]:='@' + g_GameCommand.MASTERECALL.sCmd;
//  StringGridGameCmd.Objects[0,31]:=TObject(@g_GameCommand.MASTERECALL);

  StringGridGameCmd.Cells[0,32]:=g_GameCommand.ATTACKMODE.sCmd;
  StringGridGameCmd.Cells[1,32]:=IntToStr(g_GameCommand.ATTACKMODE.nPermissionMin);
  StringGridGameCmd.Cells[2,32]:='@' + g_GameCommand.ATTACKMODE.sCmd;
  StringGridGameCmd.Objects[0,32]:=TObject(@g_GameCommand.ATTACKMODE);

  StringGridGameCmd.Cells[0,33]:=g_GameCommand.REST.sCmd;
  StringGridGameCmd.Cells[1,33]:=IntToStr(g_GameCommand.REST.nPermissionMin);
  StringGridGameCmd.Cells[2,33]:='@' + g_GameCommand.REST.sCmd;
  StringGridGameCmd.Objects[0,33]:=TObject(@g_GameCommand.REST);

  StringGridGameCmd.Cells[0,34]:=g_GameCommand.TAKEONHORSE.sCmd;
  StringGridGameCmd.Cells[1,34]:=IntToStr(g_GameCommand.TAKEONHORSE.nPermissionMin);
  StringGridGameCmd.Cells[2,34]:='@' + g_GameCommand.TAKEONHORSE.sCmd;
  StringGridGameCmd.Objects[0,34]:=TObject(@g_GameCommand.TAKEONHORSE);

  StringGridGameCmd.Cells[0,35]:=g_GameCommand.TAKEOFHORSE.sCmd;
  StringGridGameCmd.Cells[1,35]:=IntToStr(g_GameCommand.TAKEOFHORSE.nPermissionMin);
  StringGridGameCmd.Cells[2,35]:='@' + g_GameCommand.TAKEOFHORSE.sCmd;
  StringGridGameCmd.Objects[0,35]:=TObject(@g_GameCommand.TAKEOFHORSE);

  StringGridGameCmd.Cells[0,36]:=g_GameCommand.MEMBERFUNCTIONEX.sCmd;
  StringGridGameCmd.Cells[1,36]:=IntToStr(g_GameCommand.MEMBERFUNCTIONEX.nPermissionMin);
  StringGridGameCmd.Cells[2,36]:='@' + g_GameCommand.MEMBERFUNCTIONEX.sCmd;
  StringGridGameCmd.Objects[0,36]:=TObject(@g_GameCommand.MEMBERFUNCTIONEX);

  StringGridGameCmd.Cells[0,37]:=g_GameCommand.LOCKLOGON.sCmd;
  StringGridGameCmd.Cells[1,37]:=IntToStr(g_GameCommand.LOCKLOGON.nPermissionMin);
  StringGridGameCmd.Cells[2,37]:='@' + g_GameCommand.LOCKLOGON.sCmd;
  StringGridGameCmd.Objects[0,37]:=TObject(@g_GameCommand.LOCKLOGON);
end;

procedure TfrmGameCmd.StringGridGameCmdClick(Sender: TObject);
var
  nIndex:Integer;
  GameCmd:pTGameCmd;
begin
  nIndex:=StringGridGameCmd.Row;
  GameCmd:=pTGameCmd(StringGridGameCmd.Objects[0,nIndex]);
  if GameCmd <> nil then begin
    EditUserCmdName.Text:=GameCmd.sCmd;
    EditUserCmdPerMission.Value:=GameCmd.nPermissionMin;
    LabelUserCmdParam.Caption:=StringGridGameCmd.Cells[2,nIndex];
    LabelUserCmdFunc.Caption:=StringGridGameCmd.Cells[3,nIndex];
  end;
  EditUserCmdOK.Enabled:=False;
end;

procedure TfrmGameCmd.EditUserCmdNameChange(Sender: TObject);
begin
  EditUserCmdOK.Enabled:=True;
  EditUserCmdSave.Enabled:=True;
end;

procedure TfrmGameCmd.EditUserCmdPerMissionChange(Sender: TObject);
begin
  EditUserCmdOK.Enabled:=True;
  EditUserCmdSave.Enabled:=True;
end;

procedure TfrmGameCmd.EditUserCmdOKClick(Sender: TObject);
var
  nIndex:Integer;
  GameCmd:pTGameCmd;
  sCmd:String;
  nPerMission:Integer;
begin
  sCmd:=Trim(EditUserCmdName.Text);
  nPermission:=EditUserCmdPerMission.Value;
  if sCmd = '' then begin
    Application.MessageBox('命令名称不能为空！！！','提示信息',MB_OK + MB_ICONERROR);
    EditUserCmdName.SetFocus;
    exit;
  end;

  nIndex:=StringGridGameCmd.Row;
  GameCmd:=pTGameCmd(StringGridGameCmd.Objects[0,nIndex]);
  if GameCmd <> nil then begin
    GameCmd.sCmd:=sCmd;
    GameCmd.nPermissionMin:=nPermission;
  end;
  RefUserCommand();
end;

procedure TfrmGameCmd.EditUserCmdSaveClick(Sender: TObject);
begin
  EditUserCmdSave.Enabled:=False;
{$IF SoftVersion <> VERDEMO}
  CommandConf.WriteString('Command','Date',g_GameCommand.DATA.sCmd);
  CommandConf.WriteString('Command','PrvMsg',g_GameCommand.PRVMSG.sCmd);
  CommandConf.WriteString('Command','AllowMsg',g_GameCommand.ALLOWMSG.sCmd);
  CommandConf.WriteString('Command','LetShout',g_GameCommand.LETSHOUT.sCmd);
  CommandConf.WriteString('Command','LetTrade',g_GameCommand.LETTRADE.sCmd);
  CommandConf.WriteString('Command','LetGuild',g_GameCommand.LETGUILD.sCmd);
  CommandConf.WriteString('Command','EndGuild',g_GameCommand.ENDGUILD.sCmd);
  CommandConf.WriteString('Command','BanGuildChat',g_GameCommand.BANGUILDCHAT.sCmd);
  CommandConf.WriteString('Command','AuthAlly',g_GameCommand.AUTHALLY.sCmd);
  CommandConf.WriteString('Command','Auth',g_GameCommand.AUTH.sCmd);
  CommandConf.WriteString('Command','AuthCancel',g_GameCommand.AUTHCANCEL.sCmd);
  CommandConf.WriteString('Command','ViewDiary',g_GameCommand.DIARY.sCmd);
  CommandConf.WriteString('Command','UserMove',g_GameCommand.USERMOVE.sCmd);
  CommandConf.WriteString('Command','Searching',g_GameCommand.SEARCHING.sCmd);
  CommandConf.WriteString('Command','AllowGroupCall',g_GameCommand.ALLOWGROUPCALL.sCmd);
  CommandConf.WriteString('Command','GroupCall',g_GameCommand.GROUPRECALLL.sCmd);
  CommandConf.WriteString('Command','AllowGuildReCall',g_GameCommand.ALLOWGUILDRECALL.sCmd);
  CommandConf.WriteString('Command','GuildReCall',g_GameCommand.GUILDRECALLL.sCmd);
  CommandConf.WriteString('Command','StorageUnLock',g_GameCommand.UNLOCKSTORAGE.sCmd);
  CommandConf.WriteString('Command','PasswordUnLock',g_GameCommand.UNLOCK.sCmd);
  CommandConf.WriteString('Command','StorageLock',g_GameCommand.LOCK.sCmd);
  CommandConf.WriteString('Command','StorageSetPassword',g_GameCommand.SETPASSWORD.sCmd);
  CommandConf.WriteString('Command','StorageChgPassword',g_GameCommand.CHGPASSWORD.sCmd);

//  CommandConf.WriteString('Command','StorageClearPassword',g_GameCommand.CLRPASSWORD.sCmd)
//  CommandConf.WriteInteger('Permission','StorageClearPassword', g_GameCommand.CLRPASSWORD.nPermissionMin)

  CommandConf.WriteString('Command','StorageUserClearPassword',g_GameCommand.UNPASSWORD.sCmd);
  CommandConf.WriteString('Command','MemberFunc',g_GameCommand.MEMBERFUNCTION.sCmd);

//  CommandConf.WriteString('Command','Dear',g_GameCommand.DEAR.sCmd);
//  CommandConf.WriteString('Command','Master',g_GameCommand.MASTER.sCmd);
//  CommandConf.WriteString('Command','DearRecall',g_GameCommand.DEARRECALL.sCmd);
//  CommandConf.WriteString('Command','MasterRecall',g_GameCommand.MASTERECALL.sCmd);
//  CommandConf.WriteString('Command','AllowDearRecall',g_GameCommand.ALLOWDEARRCALL.sCmd);
//  CommandConf.WriteString('Command','AllowMasterRecall',g_GameCommand.ALLOWMASTERRECALL.sCmd);

//  CommandConf.WriteString('Command','AttackMode',g_GameCommand.ATTACKMODE.sCmd);
//  CommandConf.WriteString('Command','Rest',g_GameCommand.REST.sCmd);
//  CommandConf.WriteString('Command','TakeOnHorse',g_GameCommand.TAKEONHORSE.sCmd);
//  CommandConf.WriteString('Command','TakeOffHorse',g_GameCommand.TAKEOFHORSE.sCmd);

  CommandConf.WriteInteger('Permission','Date', g_GameCommand.DATA.nPermissionMin);
  CommandConf.WriteInteger('Permission','PrvMsg', g_GameCommand.PRVMSG.nPermissionMin);
  CommandConf.WriteInteger('Permission','AllowMsg', g_GameCommand.ALLOWMSG.nPermissionMin);
{$IFEND}  
end;
procedure TfrmGameCmd.RefGameMasterCmd(GameCmd:pTGameCmd;sCmdParam,sDesc:String);
begin
  Inc(nRefGameMasterIndex);
  if StringGridGameMasterCmd.RowCount - 1 < nRefGameMasterIndex then begin
    StringGridGameMasterCmd.RowCount:=nRefGameMasterIndex + 1;
  end;
    
  StringGridGameMasterCmd.Cells[0,nRefGameMasterIndex]:=GameCmd.sCmd;
  StringGridGameMasterCmd.Cells[1,nRefGameMasterIndex]:=IntToStr(GameCmd.nPermissionMin) + '/' + IntToStr(GameCmd.nPermissionMax);
  StringGridGameMasterCmd.Cells[2,nRefGameMasterIndex]:=sCmdParam;
  StringGridGameMasterCmd.Cells[3,nRefGameMasterIndex]:=sDesc;
  StringGridGameMasterCmd.Objects[0,nRefGameMasterIndex]:=TObject(GameCmd);
end;

procedure TfrmGameCmd.RefGameMasterCommand;
var
  GameCmd:pTGameCmd;
  sDesc:String;
  sCmdParam:String;
begin
  EditGameMasterCmdOK.Enabled:=False;
  nRefGameMasterIndex:=0;

  RefGameMasterCmd(@g_GameCommand.CLRPASSWORD,
                   '@' + g_GameCommand.CLRPASSWORD.sCmd + ' 人物名称',
                   '清除人物仓库/登录密码(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.WHO,
                   '@' + g_GameCommand.WHO.sCmd,
                   '查看当前服务器在线人数(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.TOTAL,
                   '@' + g_GameCommand.TOTAL.sCmd,
                   '查看所有服务器在线人数(支持权限分配)');


  RefGameMasterCmd(@g_GameCommand.GAMEMASTER,
                   '@' + g_GameCommand.GAMEMASTER.sCmd,
                   '进入/退出管理员模式(进入模式后不会受到任何角色攻击)(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.OBSERVER,
                   '@' + g_GameCommand.OBSERVER.sCmd,
                   '进入/退出隐身模式(进入模式后别人看不到自己)(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SUEPRMAN,
                   '@' + g_GameCommand.SUEPRMAN.sCmd,
                   '进入/退出无敌模式(进入模式后人物不会死亡)(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.MAKE,
                   '@' + g_GameCommand.MAKE.sCmd + ' 物品名称 数量',
                   '制造指定物品(支持权限分配，小于最大权限受允许、禁止制造列表限制)');

  RefGameMasterCmd(@g_GameCommand.SMAKE,
                   '@' + g_GameCommand.SMAKE.sCmd + ' 参数详见使用说明',
                   '调整自己身上的物品属性(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.MOVE,
                   '@' + g_GameCommand.MOVE.sCmd + ' 地图号',
                   '移动到指定地图(支持权限分配，小于最大权限受受禁止传送地图列表限制)');

  RefGameMasterCmd(@g_GameCommand.POSITIONMOVE,
                   '@' + g_GameCommand.POSITIONMOVE.sCmd + ' 地图号 X Y',
                   '移动到指定地图(支持权限分配，小于最大权限受受禁止传送地图列表限制)');

  RefGameMasterCmd(@g_GameCommand.RECALL,
                   '@' + g_GameCommand.RECALL.sCmd + ' 人物名称',
                   '将指定人物召唤到身边(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.REGOTO,
                   '@' + g_GameCommand.REGOTO.sCmd + ' 人物名称',
                   '跟踪指定人物(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.TING,
                   '@' + g_GameCommand.TING.sCmd + ' 人物名称',
                   '将指定人物随机传送(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SUPERTING,
                   '@' + g_GameCommand.SUPERTING.sCmd + ' 人物名称 范围大小',
                   '将指定人物身边指定范围内的人物随机传送(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.MAPMOVE,
                   '@' + g_GameCommand.MAPMOVE.sCmd + ' 源地图号 目标地图号',
                   '将整个地图中的人物移动到其它地图中(支持权限分配)');
                   
  RefGameMasterCmd(@g_GameCommand.INFO,
                   '@' + g_GameCommand.INFO.sCmd + ' 人物名称',
                   '看人物信息(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.HUMANLOCAL,
                   '@' + g_GameCommand.HUMANLOCAL.sCmd + ' 地图号',
                   '查询人物IP所在地区(需加载IP地区查询插件)(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.VIEWWHISPER,
                   '@' + g_GameCommand.VIEWWHISPER.sCmd + ' 人物名称',
                   '查看指定人物的私聊信息(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.MOBLEVEL,
                   '@' + g_GameCommand.MOBLEVEL.sCmd,
                   '查看身边角色信息(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.MOBCOUNT,
                   '@' + g_GameCommand.MOBCOUNT.sCmd + ' 地图号',
                   '查看地图中怪物数量(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.HUMANCOUNT,
                   '@' + g_GameCommand.HUMANCOUNT.sCmd,
                   '查看身边人数(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.MAP,
                   '@' + g_GameCommand.MAP.sCmd,
                   '显示当前所在地图相关信息(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.LEVEL,
                   '@' + g_GameCommand.LEVEL.sCmd,
                   '调整自己的等级(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.KICK,
                   '@' + g_GameCommand.KICK.sCmd + ' 人物名称',
                   '将指定人物踢下线(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.REALIVE,
                   '@' + g_GameCommand.REALIVE.sCmd + ' 人物名称',
                   '将指定人物复活(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.KILL,
                   '@' + g_GameCommand.KILL.sCmd + '人物名称',
                   '将指定人物或怪物杀死(杀怪物时需面对怪物)(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.CHANGEJOB,
                   '@' + g_GameCommand.CHANGEJOB.sCmd + ' 人物名称 职业类型(Warr Wizard Taos)',
                   '调整人物的职业(支持权限分配)');


  RefGameMasterCmd(@g_GameCommand.FREEPENALTY,
                   '@' + g_GameCommand.FREEPENALTY.sCmd + ' 人物名称',
                   '清除指定人物的PK值(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.PKPOINT,
                   '@' + g_GameCommand.PKPOINT.sCmd + ' 人物名称',
                   '查看指定人物的PK值(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.INCPKPOINT,
                   '@' + g_GameCommand.INCPKPOINT.sCmd + ' 人物名称 点数',
                   '增加指定人物的PK值(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.CHANGEGENDER,
                   '@' + g_GameCommand.CHANGEGENDER.sCmd + ' 人物名称 性别(男、女)',
                   '调整人物的性别(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.HAIR,
                   '@' + g_GameCommand.HAIR.sCmd + ' 类型值',
                   '更改指定人物的头发类型(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.BONUSPOINT,
                   '@' + g_GameCommand.BONUSPOINT.sCmd + ' 人物名称 属性点数',
                   '调整人物的属性点数(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELBONUSPOINT,
                   '@' + g_GameCommand.DELBONUSPOINT.sCmd + ' 人物名称',
                   '删除人物的属性点数(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.RESTBONUSPOINT,
                   '@' + g_GameCommand.RESTBONUSPOINT.sCmd + ' 人物名称',
                   '将人物的属性点数重新分配(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SETPERMISSION,
                   '@' + g_GameCommand.SETPERMISSION.sCmd + ' 人物名称 权限等级(0 - 10)',
                   '调整人物的权限等级，可以将普通人物升为GM权限(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.RENEWLEVEL,
                   '@' + g_GameCommand.RENEWLEVEL.sCmd + ' 人物名称 点数(为空则查看)',
                   '调整查看人物的转生等级(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELGOLD,
                   '@' + g_GameCommand.DELGOLD.sCmd + ' 人物名称 数量',
                   '删除人物指定数量的金币(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.ADDGOLD,
                   '@' + g_GameCommand.ADDGOLD.sCmd + ' 人物名称 数量',
                   '增加人物指定数量的金币(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.GAMEGOLD,
                   '@' + g_GameCommand.GAMEGOLD.sCmd + ' 人物名称 控制符(+ - =) 数量',
                   '调整人物的翎风币数量(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.GAMEPOINT,
                   '@' + g_GameCommand.GAMEPOINT.sCmd + ' 人物名称 控制符(+ - =) 数量',
                   '调整人物的游戏点数量(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.CREDITPOINT,
                   '@' + g_GameCommand.CREDITPOINT.sCmd + ' 人物名称 控制符(+ - =) 点数',
                   '调整人物的声望点数(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.REFINEWEAPON,
                   '@' + g_GameCommand.REFINEWEAPON.sCmd + ' 攻击力 魔法力 道术 准确度',
                   '调整身上武器属性(支持权限分配)');


  RefGameMasterCmd(@g_GameCommand.ADJUESTLEVEL,
                   '@' + g_GameCommand.ADJUESTLEVEL.sCmd + ' 人物名称 等级',
                   '调整指定人物的等级(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.ADJUESTEXP,
                   '@' + g_GameCommand.ADJUESTEXP.sCmd + ' 人物名称 经验值',
                   '调整指定人物的经验值(支持权限分配)');

//取消 结婚 与 师徒 的相关内容
{
  RefGameMasterCmd(@g_GameCommand.CHANGEDEARNAME,
                   '@' + g_GameCommand.CHANGEDEARNAME.sCmd + ' 人物名称 配偶名称(如果为 无 则清除)',
                   '更改指定人物的配偶名称(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.CHANGEMASTERNAME,
                   '@' + g_GameCommand.CHANGEMASTERNAME.sCmd + ' 人物名称 师徒名称(如果为 无 则清除)',
                   '更改指定人物的师徒名称(支持权限分配)');
}

  RefGameMasterCmd(@g_GameCommand.RECALLMOB,
                   '@' + g_GameCommand.RECALLMOB.sCmd + ' 怪物名称 数量 召唤等级',
                   '召唤指定怪物为宝宝(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.TRAINING,
                   '@' + g_GameCommand.TRAINING.sCmd + ' 人物名称  技能名称 修炼等级(0-3)',
                   '调整人物的技能修炼等级(支持权限分配)');


  RefGameMasterCmd(@g_GameCommand.TRAININGSKILL,
                   '@' + g_GameCommand.TRAININGSKILL.sCmd  + ' 人物名称  技能名称 修炼等级(0-3)',
                   '给指定人物增加技能(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELETESKILL,
                   '@' + g_GameCommand.DELETESKILL.sCmd + ' 人物名称 技能名称(All)',
                   '删除人物的技能，All代表删除全部技能(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELETEITEM,
                   '@' + g_GameCommand.DELETEITEM.sCmd + ' 人物名称 物品名称 数量',
                   '删除人物身上指定的物品(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.CLEARMISSION,
                   '@' + g_GameCommand.CLEARMISSION.sCmd + ' 人物名称',
                   '清除人物的任务标志(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.ADDGUILD,
                   '@' + g_GameCommand.ADDGUILD.sCmd + ' 行会名称 掌门人',
                   '新建一个行会(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELGUILD,
                   '@' + g_GameCommand.DELGUILD.sCmd + ' 行会名称',
                   '删除一个行会(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.CHANGESABUKLORD,
                   '@' + g_GameCommand.CHANGESABUKLORD.sCmd + ' 行会名称',
                   '更改城堡所属行会(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.FORCEDWALLCONQUESTWAR,
                   '@' + g_GameCommand.FORCEDWALLCONQUESTWAR.sCmd,
                   '强行开始/停止攻城战(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.CONTESTPOINT,
                   '@' + g_GameCommand.CONTESTPOINT.sCmd + ' 行会名称',
                   '查看行会争霸赛得分情况(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.STARTCONTEST,
                   '@' + g_GameCommand.STARTCONTEST.sCmd,
                   '开始行会争霸赛(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.ENDCONTEST,
                   '@' + g_GameCommand.ENDCONTEST.sCmd,
                   '结束行会争霸赛(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.ANNOUNCEMENT,
                   '@' + g_GameCommand.ANNOUNCEMENT.sCmd,
                   '(支持权限分配)');


  RefGameMasterCmd(@g_GameCommand.MOB,
                   '@' + g_GameCommand.MOB.sCmd + ' 怪物名称 数量',
                   '在身边放置指定类型数量的怪物(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.MISSION,
                   '@' + g_GameCommand.MISSION.sCmd + ' X  Y',
                   '设置怪物的集中点(举行怪物攻城用)(支持权限分配');

  RefGameMasterCmd(@g_GameCommand.MOBPLACE,
                   '@' + g_GameCommand.MOBPLACE.sCmd + ' X  Y 怪物名称 怪物数量',
                   '在当前地图指定XY放置怪物(支持权限分配(先必须设置怪物的集中点)，放置的怪物大刀守卫不会攻击这些怪物');

  RefGameMasterCmd(@g_GameCommand.CLEARMON,
                   '@' + g_GameCommand.CLEARMON.sCmd + ' 地图号(* 为所有) 怪物名称(* 为所有) 掉物品(0,1)',
                   '清除地图中的怪物(支持权限分配'')');

  RefGameMasterCmd(@g_GameCommand.DISABLESENDMSG,
                   '@' + g_GameCommand.DISABLESENDMSG.sCmd + ' 人物名称',
                   '将指定人物加入发言过滤列表，加入列表后自己发的文字自己可以看到，其他人看不到(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.ENABLESENDMSG,
                   '@' + g_GameCommand.ENABLESENDMSG.sCmd,
                   '将指定人物从发言过滤列表中删除(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DISABLESENDMSGLIST,
                   '@' + g_GameCommand.DISABLESENDMSGLIST.sCmd,
                   '查看发言过滤列表中的内容(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SHUTUP,
                   '@' + g_GameCommand.SHUTUP.sCmd + ' 人物名称',
                   '将指定人物禁言(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.RELEASESHUTUP,
                   '@' + g_GameCommand.RELEASESHUTUP.sCmd  + ' 人物名称',
                   '将指定人物从禁言列表中删除(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SHUTUPLIST,
                   '@' + g_GameCommand.SHUTUPLIST.sCmd,
                   '查看禁言列表中的内容(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SABUKWALLGOLD,
                   '@' + g_GameCommand.SABUKWALLGOLD.sCmd,
                   '查看城堡金币数(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.STARTQUEST,
                   '@' + g_GameCommand.STARTQUEST.sCmd,
                   '开始提问功能，游戏中所有人同时跳出问题窗口(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DENYIPLOGON,
                   '@' + g_GameCommand.DENYIPLOGON.sCmd + ' IP地址 是否永久封(0,1)',
                   '将指定IP地址加入禁止登录列表，以这些IP登录的用户将无法进入游戏(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DENYACCOUNTLOGON,
                   '@' + g_GameCommand.DENYACCOUNTLOGON.sCmd + ' 登录帐号 是否永久封(0,1)',
                   '将指定登录帐号加入禁止登录列表，以此帐号登录的用户将无法进入游戏(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DENYCHARNAMELOGON,
                   '@' + g_GameCommand.DENYCHARNAMELOGON.sCmd + ' 人物名称 是否永久封(0,1)',
                   '将指定人物名称加入禁止登录列表，此人物将无法进入游戏(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELDENYIPLOGON,
                   '@' + g_GameCommand.DELDENYIPLOGON.sCmd,
                   '将指定IP地址从禁止登录列表中删除(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELDENYACCOUNTLOGON,
                   '@' + g_GameCommand.DELDENYACCOUNTLOGON.sCmd,
                   '将指定登录帐号从禁止登录列表中删除(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELDENYCHARNAMELOGON,
                   '@' + g_GameCommand.DELDENYCHARNAMELOGON.sCmd,
                   '将指定人物名称从禁止登录列表中删除(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SHOWDENYIPLOGON,
                   '@' + g_GameCommand.SHOWDENYIPLOGON.sCmd,
                   '显示禁止列表中的IP(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SHOWDENYACCOUNTLOGON,
                   '@' + g_GameCommand.SHOWDENYACCOUNTLOGON.sCmd,
                   '显示禁止列表中的登录帐号(支持权限分配)');


  RefGameMasterCmd(@g_GameCommand.SHOWDENYCHARNAMELOGON,
                   '@' + g_GameCommand.SHOWDENYCHARNAMELOGON.sCmd,
                   '显示禁止列表中的人物名称(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SETMAPMODE,
                   '@' + g_GameCommand.SETMAPMODE.sCmd,
                   '设置地图模式');

  RefGameMasterCmd(@g_GameCommand.SHOWMAPMODE,
                   '@' + g_GameCommand.SHOWMAPMODE.sCmd,
                   '显示地图模式');

  RefGameMasterCmd(@g_GameCommand.ATTACK,
                   '@' + g_GameCommand.ATTACK.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.LUCKYPOINT,
                   '@' + g_GameCommand.LUCKYPOINT.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.CHANGELUCK,
                   '@' + g_GameCommand.CHANGELUCK.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.HUNGER,
                   '@' + g_GameCommand.HUNGER.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.NAMECOLOR,
                   '@' + g_GameCommand.NAMECOLOR.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.TRANSPARECY,
                   '@' + g_GameCommand.TRANSPARECY.sCmd,
                   '');


  RefGameMasterCmd(@g_GameCommand.LEVEL0,
                   '@' + g_GameCommand.LEVEL0.sCmd,
                   '');


  RefGameMasterCmd(@g_GameCommand.CHANGEITEMNAME,
                   '@' + g_GameCommand.CHANGEITEMNAME.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.ADDTOITEMEVENT,
                   '@' + g_GameCommand.ADDTOITEMEVENT.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.ADDTOITEMEVENTASPIECES,
                   '@' + g_GameCommand.ADDTOITEMEVENTASPIECES.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.ITEMEVENTLIST,
                   '@' + g_GameCommand.ITEMEVENTLIST.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.STARTINGGIFTNO,
                   '@' + g_GameCommand.STARTINGGIFTNO.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.DELETEALLITEMEVENT,
                   '@' + g_GameCommand.DELETEALLITEMEVENT.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.STARTITEMEVENT,
                   '@' + g_GameCommand.STARTITEMEVENT.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.ITEMEVENTTERM,
                   '@' + g_GameCommand.ITEMEVENTTERM.sCmd,
                   '');


  RefGameMasterCmd(@g_GameCommand.OPDELETESKILL,
                   '@' + g_GameCommand.OPDELETESKILL.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.CHANGEWEAPONDURA,
                   '@' + g_GameCommand.CHANGEWEAPONDURA.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.SBKDOOR,
                   '@' + g_GameCommand.SBKDOOR.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.SPIRIT,
                   '@' + g_GameCommand.SPIRIT.sCmd,
                   '');

  RefGameMasterCmd(@g_GameCommand.SPIRITSTOP,
                   '@' + g_GameCommand.SPIRITSTOP.sCmd,
                   '');

end;

procedure TfrmGameCmd.RefGameDebugCmd(GameCmd:pTGameCmd;sCmdParam,sDesc:String);
begin
  Inc(nRefGameDebugIndex);
  if StringGridGameMasterCmd.RowCount - 1 < nRefGameDebugIndex then begin
    StringGridGameDebugCmd.RowCount:=nRefGameDebugIndex + 1;
  end;
    
  StringGridGameDebugCmd.Cells[0,nRefGameDebugIndex]:=GameCmd.sCmd;
  StringGridGameDebugCmd.Cells[1,nRefGameDebugIndex]:=IntToStr(GameCmd.nPermissionMin) + '/' + IntToStr(GameCmd.nPermissionMax);
  StringGridGameDebugCmd.Cells[2,nRefGameDebugIndex]:=sCmdParam;
  StringGridGameDebugCmd.Cells[3,nRefGameDebugIndex]:=sDesc;
  StringGridGameDebugCmd.Objects[0,nRefGameDebugIndex]:=TObject(GameCmd);
end;

procedure TfrmGameCmd.RefDebugCommand;
var
  GameCmd:pTGameCmd;
begin
  EditGameDebugCmdOK.Enabled:=False;
//  StringGridGameDebugCmd.RowCount:=41;

  GameCmd:=@g_GameCommand.SHOWFLAG;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.SETFLAG;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.SHOWOPEN;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.SETOPEN;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.SHOWUNIT;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.SETUNIT;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');
                   
  GameCmd:=@g_GameCommand.MOBNPC;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.DELNPC;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');
                   
//取消彩票功能
//  GameCmd:=@g_GameCommand.LOTTERYTICKET;
//  RefGameDebugCmd(GameCmd,
//                   '@' + GameCmd.sCmd,
//                   '');

  GameCmd:=@g_GameCommand.RELOADADMIN;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '重新加载管理员列表');

  GameCmd:=@g_GameCommand.RELOADNPC;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '重新加载NPC脚本');

  GameCmd:=@g_GameCommand.RELOADMANAGE;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '重新加载登录脚本');

  GameCmd:=@g_GameCommand.RELOADROBOTMANAGE;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '重新加载机器人配置');

  GameCmd:=@g_GameCommand.RELOADROBOT;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '重新加载机器人脚本');

  GameCmd:=@g_GameCommand.RELOADMONITEMS;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '重新加载怪物爆率配置');

  GameCmd:=@g_GameCommand.RELOADDIARY;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '未使用');

  GameCmd:=@g_GameCommand.RELOADITEMDB;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '重新加载物品数据库');

  GameCmd:=@g_GameCommand.RELOADMAGICDB;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '未使用');

  GameCmd:=@g_GameCommand.RELOADMONSTERDB;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '重新加载怪物数据库');

  GameCmd:=@g_GameCommand.RELOADMINMAP;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '重新加载小地图配置');

  GameCmd:=@g_GameCommand.RELOADGUILD;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.RELOADGUILDALL;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.RELOADLINENOTICE;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '重新加载游戏公告信息');

  GameCmd:=@g_GameCommand.RELOADABUSE;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '重新加载脏话过滤配置');

  GameCmd:=@g_GameCommand.BACKSTEP;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.RECONNECTION;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '将指定人物重新切换网络连接');

  GameCmd:=@g_GameCommand.DISABLEFILTER;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '禁用脏话过滤功能');

  GameCmd:=@g_GameCommand.CHGUSERFULL;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.CHGZENFASTSTEP;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.OXQUIZROOM;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.BALL;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.FIREBURN;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.TESTFIRE;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.TESTSTATUS;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.TESTGOLDCHANGE;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.GSA;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.TESTGA;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '');

  GameCmd:=@g_GameCommand.MAPINFO;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '显示地图信息');

  GameCmd:=@g_GameCommand.CLEARBAG;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd,
                   '清除背包全部物品');

end;

procedure TfrmGameCmd.StringGridGameMasterCmdClick(Sender: TObject);
var
  nIndex:Integer;
  GameCmd:pTGameCmd;
begin
  nIndex:=StringGridGameMasterCmd.Row;
  GameCmd:=pTGameCmd(StringGridGameMasterCmd.Objects[0,nIndex]);
  if GameCmd <> nil then begin
    EditGameMasterCmdName.Text:=GameCmd.sCmd;
    EditGameMasterCmdPerMission.Value:=GameCmd.nPermissionMin;
    LabelGameMasterCmdParam.Caption:=StringGridGameMasterCmd.Cells[2,nIndex];
    LabelGameMasterCmdFunc.Caption:=StringGridGameMasterCmd.Cells[3,nIndex];
  end;
  EditGameMasterCmdOK.Enabled:=False;
end;

procedure TfrmGameCmd.EditGameMasterCmdNameChange(Sender: TObject);
begin
  EditGameMasterCmdOK.Enabled:=True;
  EditGameMasterCmdSave.Enabled:=True;
end;

procedure TfrmGameCmd.EditGameMasterCmdPerMissionChange(Sender: TObject);
begin
  EditGameMasterCmdOK.Enabled:=True;
  EditGameMasterCmdSave.Enabled:=True;
end;

procedure TfrmGameCmd.EditGameMasterCmdOKClick(Sender: TObject);
var
  nIndex:Integer;
  GameCmd:pTGameCmd;
  sCmd:String;
  nPerMission:Integer;
begin

  sCmd:=Trim(EditGameMasterCmdName.Text);
  nPermission:=EditGameMasterCmdPerMission.Value;
  if sCmd = '' then begin
    Application.MessageBox('命令名称不能为空！！！','提示信息',MB_OK + MB_ICONERROR);
    EditGameMasterCmdName.SetFocus;
    exit;
  end;

  nIndex:=StringGridGameMasterCmd.Row;
  GameCmd:=pTGameCmd(StringGridGameMasterCmd.Objects[0,nIndex]);
  if GameCmd <> nil then begin
    GameCmd.sCmd:=sCmd;
    GameCmd.nPermissionMin:=nPermission;
  end;
  RefGameMasterCommand();
end;

procedure TfrmGameCmd.EditGameMasterCmdSaveClick(Sender: TObject);
begin
  EditGameMasterCmdSave.Enabled:=False;
{$IF SoftVersion <> VERDEMO}
  CommandConf.WriteString('Command','ObServer',g_GameCommand.OBSERVER.sCmd);
  CommandConf.WriteString('Command','GameMaster',g_GameCommand.GAMEMASTER.sCmd);
  CommandConf.WriteString('Command','SuperMan',g_GameCommand.SUEPRMAN.sCmd);
  CommandConf.WriteString('Command','StorageClearPassword',g_GameCommand.CLRPASSWORD.sCmd);
  CommandConf.WriteString('Command','Who',g_GameCommand.WHO.sCmd);
  CommandConf.WriteString('Command','Total',g_GameCommand.TOTAL.sCmd);
  CommandConf.WriteString('Command','Make',g_GameCommand.MAKE.sCmd);
  CommandConf.WriteString('Command','PositionMove',g_GameCommand.POSITIONMOVE.sCmd);
  CommandConf.WriteString('Command','Move',g_GameCommand.MOVE.sCmd);
  CommandConf.WriteString('Command','Recall',g_GameCommand.RECALL.sCmd);
  CommandConf.WriteString('Command','ReGoto',g_GameCommand.REGOTO.sCmd);
  CommandConf.WriteString('Command','Ting',g_GameCommand.TING.sCmd);
  CommandConf.WriteString('Command','SuperTing',g_GameCommand.SUPERTING.sCmd);
  CommandConf.WriteString('Command','MapMove',g_GameCommand.MAPMOVE.sCmd);
  CommandConf.WriteString('Command','Info',g_GameCommand.INFO.sCmd);
  CommandConf.WriteString('Command','HumanLocal',g_GameCommand.HUMANLOCAL.sCmd);
  CommandConf.WriteString('Command','ViewWhisper',g_GameCommand.VIEWWHISPER.sCmd);
  CommandConf.WriteString('Command','MobLevel',g_GameCommand.MOBLEVEL.sCmd);
  CommandConf.WriteString('Command','MobCount',g_GameCommand.MOBCOUNT.sCmd);
  CommandConf.WriteString('Command','HumanCount',g_GameCommand.HUMANCOUNT.sCmd);
  CommandConf.WriteString('Command','Map',g_GameCommand.MAP.sCmd);
  CommandConf.WriteString('Command','Level',g_GameCommand.LEVEL.sCmd);
  CommandConf.WriteString('Command','Kick',g_GameCommand.KICK.sCmd);
  CommandConf.WriteString('Command','ReAlive',g_GameCommand.REALIVE.sCmd);
  CommandConf.WriteString('Command','Kill',g_GameCommand.KILL.sCmd);
  CommandConf.WriteString('Command','ChangeJob',g_GameCommand.CHANGEJOB.sCmd);
  CommandConf.WriteString('Command','FreePenalty',g_GameCommand.FREEPENALTY.sCmd);
  CommandConf.WriteString('Command','PkPoint',g_GameCommand.PKPOINT.sCmd);
  CommandConf.WriteString('Command','IncPkPoint',g_GameCommand.INCPKPOINT.sCmd);
  CommandConf.WriteString('Command','ChangeGender',g_GameCommand.CHANGEGENDER.sCmd);
  CommandConf.WriteString('Command','Hair',g_GameCommand.HAIR.sCmd);
  CommandConf.WriteString('Command','BonusPoint',g_GameCommand.BONUSPOINT.sCmd);
  CommandConf.WriteString('Command','DelBonuPoint',g_GameCommand.DELBONUSPOINT.sCmd);
  CommandConf.WriteString('Command','RestBonuPoint',g_GameCommand.RESTBONUSPOINT.sCmd);
  CommandConf.WriteString('Command','SetPermission',g_GameCommand.SETPERMISSION.sCmd);
  CommandConf.WriteString('Command','ReNewLevel',g_GameCommand.RENEWLEVEL.sCmd);
  CommandConf.WriteString('Command','DelGold',g_GameCommand.DELGOLD.sCmd);
  CommandConf.WriteString('Command','AddGold',g_GameCommand.ADDGOLD.sCmd);
  CommandConf.WriteString('Command','GameGold',g_GameCommand.GAMEGOLD.sCmd);
  CommandConf.WriteString('Command','GamePoint',g_GameCommand.GAMEPOINT.sCmd);
  CommandConf.WriteString('Command','CreditPoint',g_GameCommand.CREDITPOINT.sCmd);
  CommandConf.WriteString('Command','RefineWeapon',g_GameCommand.REFINEWEAPON.sCmd);
  CommandConf.WriteString('Command','AdjuestTLevel',g_GameCommand.ADJUESTLEVEL.sCmd);
  CommandConf.WriteString('Command','AdjuestExp',g_GameCommand.ADJUESTEXP.sCmd);

//  CommandConf.WriteString('Command','ChangeDearName',g_GameCommand.CHANGEDEARNAME.sCmd);
//  CommandConf.WriteString('Command','ChangeMasterrName',g_GameCommand.CHANGEMASTERNAME.sCmd);

  CommandConf.WriteString('Command','RecallMob',g_GameCommand.RECALLMOB.sCmd);
  CommandConf.WriteString('Command','Training',g_GameCommand.TRAINING.sCmd);
  CommandConf.WriteString('Command','OpTraining',g_GameCommand.TRAININGSKILL.sCmd);
  CommandConf.WriteString('Command','DeleteSkill',g_GameCommand.DELETESKILL.sCmd);
  CommandConf.WriteString('Command','DeleteItem',g_GameCommand.DELETEITEM.sCmd);
  CommandConf.WriteString('Command','ClearMission',g_GameCommand.CLEARMISSION.sCmd);
  CommandConf.WriteString('Command','AddGuild',g_GameCommand.ADDGUILD.sCmd);
  CommandConf.WriteString('Command','DelGuild',g_GameCommand.DELGUILD.sCmd);
  CommandConf.WriteString('Command','ChangeSabukLord',g_GameCommand.CHANGESABUKLORD.sCmd);
  CommandConf.WriteString('Command','ForcedWallConQuestWar',g_GameCommand.FORCEDWALLCONQUESTWAR.sCmd);
  CommandConf.WriteString('Command','ContestPoint',g_GameCommand.CONTESTPOINT.sCmd);
  CommandConf.WriteString('Command','StartContest',g_GameCommand.STARTCONTEST.sCmd);
  CommandConf.WriteString('Command','EndContest',g_GameCommand.ENDCONTEST.sCmd);
  CommandConf.WriteString('Command','Announcement',g_GameCommand.ANNOUNCEMENT.sCmd);
  CommandConf.WriteString('Command','MobLevel',g_GameCommand.MOBLEVEL.sCmd);
  CommandConf.WriteString('Command','Mission',g_GameCommand.MISSION.sCmd);
  CommandConf.WriteString('Command','MobPlace',g_GameCommand.MOBPLACE.sCmd);

  CommandConf.WriteInteger('Permission','GameMaster', g_GameCommand.GAMEMASTER.nPermissionMin);
  CommandConf.WriteInteger('Permission','ObServer', g_GameCommand.OBSERVER.nPermissionMin);
  CommandConf.WriteInteger('Permission','SuperMan', g_GameCommand.SUEPRMAN.nPermissionMin);
  CommandConf.WriteInteger('Permission','StorageClearPassword', g_GameCommand.CLRPASSWORD.nPermissionMin);
  CommandConf.WriteInteger('Permission','Who', g_GameCommand.WHO.nPermissionMin);
  CommandConf.WriteInteger('Permission','Total', g_GameCommand.TOTAL.nPermissionMin);
  CommandConf.WriteInteger('Permission','MakeMin', g_GameCommand.MAKE.nPermissionMin);
  CommandConf.WriteInteger('Permission','MakeMax', g_GameCommand.MAKE.nPermissionMax);
  CommandConf.WriteInteger('Permission','PositionMoveMin', g_GameCommand.POSITIONMOVE.nPermissionMin);
  CommandConf.WriteInteger('Permission','PositionMoveMax', g_GameCommand.POSITIONMOVE.nPermissionMax);
  CommandConf.WriteInteger('Permission','MoveMin', g_GameCommand.MOVE.nPermissionMin);
  CommandConf.WriteInteger('Permission','MoveMax', g_GameCommand.MOVE.nPermissionMax);
  CommandConf.WriteInteger('Permission','Recall', g_GameCommand.RECALL.nPermissionMin);
  CommandConf.WriteInteger('Permission','ReGoto', g_GameCommand.REGOTO.nPermissionMin);
  CommandConf.WriteInteger('Permission','Ting', g_GameCommand.TING.nPermissionMin);
  CommandConf.WriteInteger('Permission','SuperTing', g_GameCommand.SUPERTING.nPermissionMin);
  CommandConf.WriteInteger('Permission','MapMove', g_GameCommand.MAPMOVE.nPermissionMin);
  CommandConf.WriteInteger('Permission','Info', g_GameCommand.INFO.nPermissionMin);
  CommandConf.WriteInteger('Permission','HumanLocal', g_GameCommand.HUMANLOCAL.nPermissionMin);
  CommandConf.WriteInteger('Permission','ViewWhisper', g_GameCommand.VIEWWHISPER.nPermissionMin);
  CommandConf.WriteInteger('Permission','MobLevel', g_GameCommand.MOBLEVEL.nPermissionMin);
  CommandConf.WriteInteger('Permission','MobCount', g_GameCommand.MOBCOUNT.nPermissionMin);
  CommandConf.WriteInteger('Permission','HumanCount', g_GameCommand.HUMANCOUNT.nPermissionMin);
  CommandConf.WriteInteger('Permission','Map', g_GameCommand.MAP.nPermissionMin);
  CommandConf.WriteInteger('Permission','Level', g_GameCommand.LEVEL.nPermissionMin);
  CommandConf.WriteInteger('Permission','Kick', g_GameCommand.KICK.nPermissionMin);
  CommandConf.WriteInteger('Permission','ReAlive', g_GameCommand.REALIVE.nPermissionMin);
  CommandConf.WriteInteger('Permission','Kill', g_GameCommand.KILL.nPermissionMin);
  CommandConf.WriteInteger('Permission','ChangeJob', g_GameCommand.CHANGEJOB.nPermissionMin);
  CommandConf.WriteInteger('Permission','FreePenalty', g_GameCommand.FREEPENALTY.nPermissionMin);
  CommandConf.WriteInteger('Permission','PkPoint', g_GameCommand.PKPOINT.nPermissionMin);
  CommandConf.WriteInteger('Permission','IncPkPoint', g_GameCommand.INCPKPOINT.nPermissionMin);
  CommandConf.WriteInteger('Permission','ChangeGender', g_GameCommand.CHANGEGENDER.nPermissionMin);
  CommandConf.WriteInteger('Permission','Hair', g_GameCommand.HAIR.nPermissionMin);
  CommandConf.WriteInteger('Permission','BonusPoint', g_GameCommand.BONUSPOINT.nPermissionMin);
  CommandConf.WriteInteger('Permission','DelBonuPoint', g_GameCommand.DELBONUSPOINT.nPermissionMin);
  CommandConf.WriteInteger('Permission','RestBonuPoint', g_GameCommand.RESTBONUSPOINT.nPermissionMin);
  CommandConf.WriteInteger('Permission','SetPermission', g_GameCommand.SETPERMISSION.nPermissionMin);
  CommandConf.WriteInteger('Permission','ReNewLevel', g_GameCommand.RENEWLEVEL.nPermissionMin);
  CommandConf.WriteInteger('Permission','DelGold', g_GameCommand.DELGOLD.nPermissionMin);
  CommandConf.WriteInteger('Permission','AddGold', g_GameCommand.ADDGOLD.nPermissionMin);
  CommandConf.WriteInteger('Permission','GameGold', g_GameCommand.GAMEGOLD.nPermissionMin);
  CommandConf.WriteInteger('Permission','GamePoint', g_GameCommand.GAMEPOINT.nPermissionMin);
  CommandConf.WriteInteger('Permission','CreditPoint', g_GameCommand.CREDITPOINT.nPermissionMin);
  CommandConf.WriteInteger('Permission','RefineWeapon', g_GameCommand.REFINEWEAPON.nPermissionMin);
  CommandConf.WriteInteger('Permission','AdjuestTLevel', g_GameCommand.ADJUESTLEVEL.nPermissionMin);
  CommandConf.WriteInteger('Permission','AdjuestExp', g_GameCommand.ADJUESTEXP.nPermissionMin);

//  CommandConf.WriteInteger('Permission','ChangeDearName', g_GameCommand.CHANGEDEARNAME.nPermissionMin);
//  CommandConf.WriteInteger('Permission','ChangeMasterName', g_GameCommand.CHANGEMASTERNAME.nPermissionMin);

  CommandConf.WriteInteger('Permission','RecallMob', g_GameCommand.RECALLMOB.nPermissionMin);
  CommandConf.WriteInteger('Permission','Training', g_GameCommand.TRAINING.nPermissionMin);
  CommandConf.WriteInteger('Permission','OpTraining', g_GameCommand.TRAININGSKILL.nPermissionMin);
  CommandConf.WriteInteger('Permission','DeleteSkill', g_GameCommand.DELETESKILL.nPermissionMin);
  CommandConf.WriteInteger('Permission','DeleteItem', g_GameCommand.DELETEITEM.nPermissionMin);
  CommandConf.WriteInteger('Permission','ClearMission', g_GameCommand.CLEARMISSION.nPermissionMin);
  CommandConf.WriteInteger('Permission','AddGuild', g_GameCommand.ADDGUILD.nPermissionMin);
  CommandConf.WriteInteger('Permission','DelGuild', g_GameCommand.DELGUILD.nPermissionMin);
  CommandConf.WriteInteger('Permission','ChangeSabukLord', g_GameCommand.CHANGESABUKLORD.nPermissionMin);
  CommandConf.WriteInteger('Permission','ForcedWallConQuestWar', g_GameCommand.FORCEDWALLCONQUESTWAR.nPermissionMin);
  CommandConf.WriteInteger('Permission','ContestPoint', g_GameCommand.CONTESTPOINT.nPermissionMin);
  CommandConf.WriteInteger('Permission','StartContest', g_GameCommand.STARTCONTEST.nPermissionMin);
  CommandConf.WriteInteger('Permission','EndContest', g_GameCommand.ENDCONTEST.nPermissionMin);
  CommandConf.WriteInteger('Permission','Announcement', g_GameCommand.ANNOUNCEMENT.nPermissionMin);
  CommandConf.WriteInteger('Permission','MobLevel', g_GameCommand.MOBLEVEL.nPermissionMin);
  CommandConf.WriteInteger('Permission','Mission', g_GameCommand.MISSION.nPermissionMin);
  CommandConf.WriteInteger('Permission','MobPlace', g_GameCommand.MOBPLACE.nPermissionMin);
{$IFEND}
end;

procedure TfrmGameCmd.StringGridGameDebugCmdClick(Sender: TObject);
var
  nIndex:Integer;
  GameCmd:pTGameCmd;
begin
  nIndex:=StringGridGameDebugCmd.Row;
  GameCmd:=pTGameCmd(StringGridGameDebugCmd.Objects[0,nIndex]);
  if GameCmd <> nil then begin
    EditGameDebugCmdName.Text:=GameCmd.sCmd;
    EditGameDebugCmdPerMission.Value:=GameCmd.nPermissionMin;
    LabelGameDebugCmdParam.Caption:=StringGridGameDebugCmd.Cells[2,nIndex];
    LabelGameDebugCmdFunc.Caption:=StringGridGameDebugCmd.Cells[3,nIndex];
  end;
  EditGameDebugCmdOK.Enabled:=False;
end;

procedure TfrmGameCmd.EditGameDebugCmdNameChange(Sender: TObject);
begin
  EditGameDebugCmdOK.Enabled:=True;
  EditGameDebugCmdSave.Enabled:=True;
end;

procedure TfrmGameCmd.EditGameDebugCmdPerMissionChange(Sender: TObject);
begin
  EditGameDebugCmdOK.Enabled:=True;
  EditGameDebugCmdSave.Enabled:=True;
end;

procedure TfrmGameCmd.EditGameDebugCmdOKClick(Sender: TObject);
var
  nIndex:Integer;
  GameCmd:pTGameCmd;
  sCmd:String;
  nPerMission:Integer;
begin
  sCmd:=Trim(EditGameDebugCmdName.Text);
  nPermission:=EditGameDebugCmdPerMission.Value;
  if sCmd = '' then begin
    Application.MessageBox('命令名称不能为空！！！','提示信息',MB_OK + MB_ICONERROR);
    EditGameDebugCmdName.SetFocus;
    exit;
  end;

  nIndex:=StringGridGameDebugCmd.Row;
  GameCmd:=pTGameCmd(StringGridGameDebugCmd.Objects[0,nIndex]);
  if GameCmd <> nil then begin
    GameCmd.sCmd:=sCmd;
    GameCmd.nPermissionMin:=nPermission;
  end;
  RefDebugCommand();
end;


procedure TfrmGameCmd.EditGameDebugCmdSaveClick(Sender: TObject);
begin
  EditGameDebugCmdSave.Enabled:=False;
end;

end.


