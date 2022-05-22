unit ObjNpc;

interface
uses
  Windows, Classes, SysUtils, StrUtils, ObjBase, Grobal2, SDK, IniFiles ;
type
  TUpgradeInfo = record //0x40
    sUserName: string[ActorNameLen]; //0x00
    UserItem: TUserItem; //0x10
    btDc: Byte; //0x28
    btSc: Byte; //0x29
    btMc: Byte; //0x2A
    btDura: Byte; //0x2B
    n2C: Integer;
    dtTime: TDateTime; //0x30
    dwGetBackTick: LongWord; //0x38
    n3C: Integer;
  end;
  pTUpgradeInfo = ^TUpgradeInfo;
  TItemPrice = record
    wIndex: Word;
    nPrice: Integer;
  end;
  pTItemPrice = ^TItemPrice;
  TGoods = record //0x1C
    sItemName: string[14];
    nCount: Integer;
    dwRefillTime: LongWord;
    dwRefillTick: LongWord;
  end;
  pTGoods = ^TGoods;
  TQuestActionInfo = record //0x1C
    nCMDCode: Integer; //0x00
    sParam1: string; //0x04
    nParam1: Integer; //0x08
    sParam2: string; //0x0C
    nParam2: Integer; //0x10
    sParam3: string; //0x14
    nParam3: Integer; //0x18
    sParam4: string;
    nParam4: Integer;
    sParam5: string;
    nParam5: Integer;
    sParam6: string;
    nParam6: Integer;
  end;
  pTQuestActionInfo = ^TQuestActionInfo;
  TQuestConditionInfo = record //0x14
    nCMDCode: Integer; //0x00
    sParam1: string; //0x04
    nParam1: Integer; //0x08
    sParam2: string; //0x0C
    nParam2: Integer; //0x10
    sParam3: string;
    nParam3: Integer;
    sParam4: string;
    nParam4: Integer;
    sParam5: string;
    nParam5: Integer;
    sParam6: string;
    nParam6: Integer;
  end;
  pTQuestConditionInfo = ^TQuestConditionInfo;
  TSayingProcedure = record //0x14
    ConditionList: TList; //0x00
    ActionList: TList; //0x04
    sSayMsg: string; //0x08
    ElseActionList: TList; //0x0C
    sElseSayMsg: string; //0x10
  end;
  pTSayingProcedure = ^TSayingProcedure;
  TSayingRecord = record //0x08
    sLabel: string;
    ProcedureList: TList; //0x04
    boExtJmp: Boolean; //是否允许外部跳转
  end;
  pTSayingRecord = ^TSayingRecord;
  TNormNpc = class(TAnimalObject) //0x564
    n54C: Integer; //0x54C
    m_nFlag: ShortInt; //0x550 //用于标识此NPC是否有效，用于重新加载NPC列表(-1 为无效)
    m_ScriptList: TList; //0x554
    m_sFilePath: string; //0x558 脚本文件所在目录
    m_boIsHide: Boolean; //0x55C 此NPC是否是隐藏的，不显示在地图中
    m_boIsQuest: Boolean; //0x55D NPC类型为地图任务型的，加载脚本时的脚本文件名为 角色名-地图号.txt
    m_sPath: string; //0x560

  private
    procedure ScriptActionError(PlayObject: TPlayObject; sErrMsg: string; QuestActionInfo: pTQuestActionInfo; sCmd: string);
    procedure ScriptConditionError(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo; sCmd: string);

    procedure ExeAction(PlayObject: TPlayObject; sParam1, sParam2, sParam3: string; nParam1, nParam2, nParam3: Integer);
    procedure ActionOfChangeLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

//取消 师徒 和 结婚 功能    
//    procedure ActionOfMarry(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
//    procedure ActionOfMaster(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
//    procedure ActionOfUnMarry(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
//    procedure ActionOfUnMaster(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
//    procedure ActionOfGetMarry(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
//    procedure ActionOfGetMaster(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
//    procedure ActionOfDelMarry(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
//    procedure ActionOfDelMaster(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfGiveItem(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelNoJobSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAddSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSkillLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangePkPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeExp(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeCreditPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeJob(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRecallGroupMembers(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearNameList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMapTing(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMission(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMobPlace(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo; nX, nY, nCount, nRange: Integer);
    procedure ActionOfSetMemberType(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSetMemberLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfGameGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGamePoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAutoAddGameGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo; nPoint, nTime: Integer);
    procedure ActionOfAutoSubGameGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo; nPoint, nTime: Integer);
    procedure ActionOfChangeHairStyle(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfLineMsg(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeNameColor(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearPassword(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfReNewLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeGender(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKillSlave(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKillMonExpRate(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfPowerRate(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeMode(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangePerMission(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKick(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfBonusPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRestReNewLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfClearNeedItems(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearMakeItems(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfUpgradeItems(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfUpgradeItemsEx(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMonGenEx(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearMapMon(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfSetMapMode(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfPkZone(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRestBonusPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfTakeCastleGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfHumanHP(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfHumanMP(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildBuildPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildAuraePoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildstabilityPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildFlourishPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfOpenMagicBox(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSetRankLevelName(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGmExecute(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildChiefItemCount(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAddNameDateList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelNameDateList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMobFireBurn(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMessageBox(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSetScriptFlag(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAutoGetExp(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRecallmob(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfLoadVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSaveVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfCalcVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfGuildRecall(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGroupAddList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGroupRecall(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGroupMoveMap(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    function ConditionOfCheckGroupCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseDir(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseGender(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckLevelEx(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckSlaveCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckBonusPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckAccountIPList(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckNameIPList(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

//取消 师徒 和 结婚 功能 
//    function ConditionOfCheckPoseMarry(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
//    function ConditionOfCheckMarry(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
//    function ConditionOfCheckMarryCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
//    function ConditionOfCheckMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
//    function ConditionOfHaveMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
//    function ConditionOfCheckPoseMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
//    function ConditionOfPoseHaveMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
//    function ConditionOfCheckIsMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
//    function ConditionOfCheckPoseIsMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function ConditionOfCheckHaveGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsGuildMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsCastleaGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsCastleMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMemberType(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMemBerLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGameGold(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGamePoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckNameListPostion(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGuildList(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckReNewLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckSlaveLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckSlaveName(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function ConditionOfCheckCreditPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckOfGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPayMent(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckUseItem(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckBagSize(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckListCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckDC(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMC(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckSC(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckHP(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMP(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckItemType(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckExp(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckCastleGold(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPasswordErrorCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfIsLockPassword(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfIsLockStorage(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGuildBuildPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGuildAuraePoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckStabilityPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckFlourishPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckContribution(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckRangeMonCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckItemAddValue(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckInMapRange(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsAttackGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsDefenseGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckCastleDoorStatus(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsAttackAllyGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsDefenseAllyGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckCastleChageDay(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckCastleWarDay(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckOnlineLongMin(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckChiefItemCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckNameDateList(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMapHumanCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMapMonCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckVar(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckServerName(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function ConditionOfCheckMap(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPos(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfReviveSlave(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMagicLvl(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGroupClass(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function GetDynamicVarList(PlayObject: TPlayObject; sType: string; var sName: string): TList;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Initialize(); override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override; //FFFC
    procedure Run; override; //FFFB
    procedure Click(PlayObject: TPlayObject); virtual; //FFEB
    procedure UserSelect(PlayObject: TPlayObject; sData: string); virtual; //FFEA
    procedure GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string); virtual; //FFE9
    function GetLineVariableText(PlayObject: TPlayObject; sMsg: string): string;
    procedure GotoLable(PlayObject: TPlayObject; sLabel: string; boExtJmp: Boolean);
    function sub_49ADB8(sMsg, sStr, sText: string): string;
    procedure LoadNpcScript();
    procedure ClearScript(); virtual;
    procedure SendMsgToUser(PlayObject: TPlayObject; sMsg: string);
    procedure SendCustemMsg(PlayObject: TPlayObject; sMsg: string); virtual;
  end;
  TMerchant = class(TNormNpc)    //0x594
    m_sScript: string;           //0x568
    n56C: Integer;
    m_nPriceRate: Integer;       //0x570   物品价格倍率 默认为 100%
    bo574: Boolean;
    m_boCastle: Boolean;         //0x575
    dwRefillGoodsTick: LongWord; //0x578
    dwClearExpreUpgradeTick: LongWord; //0x57C
    m_ItemTypeList: TList;       //0x580  NPC买卖物品类型列表，脚本中前面的 +1 +30 之类的

    m_RefillGoodsList: TList;    //0x584  销售架上的商品列表，包含：从NPC脚本中[goods]加载的设定的商品列表 和 从m_GoodsList中转入的商品
    m_GoodsList: TList;          //0x588  NPC临时商品列表，游戏中玩家卖给NPC的商品，这些商品是不可见的，需要定时转到销售上架列表m_RefillGoodsList中

    m_ItemPriceList: TList;      //0x58C
    m_UpgradeWeaponList: TList;
    m_boCanMove: Boolean;
    m_dwMoveTime: LongWord;
    m_dwMoveTick: LongWord;
    m_boBuy: Boolean;
    m_boSell: Boolean;
    m_boMakeDrug: Boolean;
    m_boPrices: Boolean;
    m_boStorage: Boolean;
    m_boGetback: Boolean;
    m_boUpgradenow: Boolean;
    m_boGetBackupgnow: Boolean;
    m_boRepair: Boolean;
    m_boS_repair: Boolean;
    m_boSendmsg: Boolean;
    
//取消 师徒 和 结婚 功能
//    m_boGetMarry: Boolean;
//    m_boGetMaster: Boolean;

    m_boUseItemName: Boolean;
    
  private
    procedure ClearExpreUpgradeListData();
    function GetItemPrice(nIndex: Integer): Integer;
    function GetUserPrice(PlayObject: TPlayObject; nPrice: Integer): Integer;
    function CheckItemType(nStdMode: Integer): Boolean;
    procedure CheckItemPrice(nIndex: Integer);
    function GetRefillList(nIndex: Integer): TList;  //获取客户销售给NPC的商品列表
    procedure AddItemPrice(nIndex, nPrice: Integer);
    function GetUserItemPrice(UserItem: pTUserItem): Integer;
    function GetSellItemPrice(nPrice: Integer): Integer;
    function AddItemToGoodsList(UserItem: pTUserItem): Boolean;
    procedure GetBackupgWeapon(User: TPlayObject);
    procedure UpgradeWapon(User: TPlayObject);
    procedure ChangeUseItemName(PlayObject: TPlayObject; sLabel, sItemName: string);
    procedure SaveUpgradingList;

//取消 结婚 与 师徒 的相关内容
//    procedure GetMarry(PlayObject: TPlayObject; sDearName: string);
//    procedure GetMaster(PlayObject: TPlayObject; sMasterName: string);

  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Run; override;
    procedure UserSelect(PlayObject: TPlayObject; sData: string); override;
    procedure LoadNPCData();
    procedure SaveNPCData();
    procedure LoadUpgradeList();
    procedure RefillGoods();
    procedure LoadNpcScript();
    procedure Click(PlayObject: TPlayObject); override;
    procedure ClearScript(); override;
    procedure ClearData();
    procedure GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string); override; //FFE9
    procedure ClientBuyItem(PlayObject: TPlayObject; sItemName: string; nInt: Integer);   //买物品
    procedure ClientGetDetailGoodsList(PlayObject: TPlayObject; sItemName: string; nInt: Integer);
    procedure ClientQuerySellPrice(PlayObject: TPlayObject; UserItem: pTUserItem);
    function ClientSellItem(PlayObject: TPlayObject; UserItem: pTUserItem): Boolean;   //卖物品
    procedure ClientMakeDrugItem(PlayObject: TPlayObject; sItemName: string);
    procedure ClientQueryRepairCost(PlayObject: TPlayObject; UserItem: pTUserItem);
    function ClientRepairItem(PlayObject: TPlayObject; UserItem: pTUserItem): Boolean;
    procedure SendCustemMsg(PlayObject: TPlayObject; sMsg: string); override;
  end;
  TGuildOfficial = class(TNormNpc) //0x568
  private
    function ReQuestBuildGuild(PlayObject: TPlayObject;
      sGuildName: string): Integer;
    function ReQuestGuildWar(PlayObject: TPlayObject;
      sGuildName: string): Integer;
    procedure DoNate(PlayObject: TPlayObject);
    procedure ReQuestCastleWar(PlayObject: TPlayObject; sIndex: string);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string); override; //FFE9
    procedure Run; override; //FFFB
    procedure Click(PlayObject: TPlayObject); override; //FFEB
    procedure UserSelect(PlayObject: TPlayObject; sData: string); override; //FFEA
    procedure SendCustemMsg(PlayObject: TPlayObject; sMsg: string); override;
  end;
  TTrainer = class(TNormNpc) //0x574
    n564: Integer;
    m_dw568: LongWord;
    n56C: Integer;
    n570: Integer;
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override; //FFFC
    procedure Run; override;
  end;
//  TCastleManager = class(TMerchant)
  TCastleOfficial = class(TMerchant)
  private
    procedure HireArcher(sIndex: string; PlayObject: TPlayObject);
    procedure HireGuard(sIndex: string; PlayObject: TPlayObject);
    procedure RepairDoor(PlayObject: TPlayObject);
    procedure RepairWallNow(nWallIndex: Integer; PlayObject: TPlayObject);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Click(PlayObject: TPlayObject); override; //FFEB
    procedure UserSelect(PlayObject: TPlayObject; sData: string); override; //FFEA
    procedure GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string); override; //FFE9
    procedure SendCustemMsg(PlayObject: TPlayObject; sMsg: string); override;
  end;
implementation

uses Castle, M2Share, HUtil32, LocalDB, Envir, Guild, EDcode, ObjMon2,
  Event, ItmUnit;

procedure TCastleOfficial.Click(PlayObject: TPlayObject); //004A4588
begin
  if m_Castle = nil then
  begin
    PlayObject.SysMsg('NPC不属于城堡！！！', c_Red, t_Hint);
    Exit;
  end;
  if TUserCastle(m_Castle).IsMasterGuild(TGUild(PlayObject.m_MyGuild)) or (PlayObject.m_btPermission >= 3) then
    inherited;
end;

procedure TCastleOfficial.GetVariableText(PlayObject: TPlayObject;
  var sMsg: string; sVariable: string);
var
  i: Integer;
  sText: string;
  CastleDoor: TCastleDoor;
  List: TStringList;
begin
  inherited;
  if m_Castle = nil then
  begin
    sMsg := '????';
    Exit;
  end;
  if sVariable = '$CASTLEGOLD' then
  begin
    sText := IntToStr(TUserCastle(m_Castle).m_nTotalGold);
    sMsg := sub_49ADB8(sMsg, '<$CASTLEGOLD>', sText);
  end else
    if sVariable = '$TODAYINCOME' then
    begin
      sText := IntToStr(TUserCastle(m_Castle).m_nTodayIncome);
      sMsg := sub_49ADB8(sMsg, '<$TODAYINCOME>', sText);
    end else
      if sVariable = '$CASTLEDOORSTATE' then
      begin
        //城堡大门的状态
        CastleDoor := TCastleDoor(TUserCastle(m_Castle).m_MainDoor.BaseObject);

        if CastleDoor.m_boDeath then
             sText := '毁坏'   //'destroyed'    毁坏
        else if CastleDoor.m_boOpened then
             sText := '打开'   //'opened'      打开
        else
             sText := '关闭';  //'closed';     关闭

        sMsg := sub_49ADB8(sMsg, '<$CASTLEDOORSTATE>', sText);
      end else
        if sVariable = '$REPAIRDOORGOLD' then
        begin
          sText := IntToStr(g_Config.nRepairDoorPrice);
          sMsg := sub_49ADB8(sMsg, '<$REPAIRDOORGOLD>', sText);
        end else
          if sVariable = '$REPAIRWALLGOLD' then
          begin
            sText := IntToStr(g_Config.nRepairWallPrice);
            sMsg := sub_49ADB8(sMsg, '<$REPAIRWALLGOLD>', sText);
          end else
            if sVariable = '$GUARDFEE' then
            begin
              sText := IntToStr(g_Config.nHireGuardPrice);
              sMsg := sub_49ADB8(sMsg, '<$GUARDFEE>', sText);
            end else
              if sVariable = '$ARCHERFEE' then
              begin
                sText := IntToStr(g_Config.nHireArcherPrice);
                sMsg := sub_49ADB8(sMsg, '<$ARCHERFEE>', sText);
              end else
                if sVariable = '$GUARDRULE' then
                begin
                  sText := '无效';
                  sMsg := sub_49ADB8(sMsg, '<$GUARDRULE>', sText);
                end;

end;
procedure TCastleOfficial.UserSelect(PlayObject: TPlayObject; sData: string);
var
  s18, s20, sMsg, sLabel: string;
  boCanJmp: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TCastleManager::UserSelect... ';
begin
  inherited;
  try
//    PlayObject.m_nScriptGotoCount:=0;
    if m_Castle = nil then
    begin
      PlayObject.SysMsg('NPC不属于城堡！！！', c_Red, t_Hint);
      Exit;
    end;
    if (sData <> '') and (sData[1] = '@') then
    begin
      sMsg := GetValidStr3(sData, sLabel, [#13]);
      s18 := '';
      PlayObject.m_sScriptLable := sData;
      if TUserCastle(m_Castle).IsMasterGuild(TGUild(PlayObject.m_MyGuild)) and (PlayObject.IsGuildMaster) then
      begin
        boCanJmp := PlayObject.LableIsCanJmp(sLabel);
        if CompareText(sLabel, sSL_SENDMSG) = 0 then
        begin
          if sMsg = '' then Exit;
        end;
        GotoLable(PlayObject, sLabel, not boCanJmp);
        //GotoLable(PlayObject,sLabel,not PlayObject.LableIsCanJmp(sLabel));
        if not boCanJmp then Exit;
        if CompareText(sLabel, sSL_SENDMSG) = 0 then
        begin
          SendCustemMsg(PlayObject, sMsg);
          PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
        end else
          if CompareText(sLabel, sCASTLENAME) = 0 then
          begin
            sMsg := Trim(sMsg);
            if sMsg <> '' then
            begin
              TUserCastle(m_Castle).m_sName := sMsg;
              TUserCastle(m_Castle).Save;
              TUserCastle(m_Castle).m_MasterGuild.RefMemberName;
              s18 := '城堡名称更改成功...';
            end else
            begin
              s18 := '城堡名称更改失败！！！';
            end;
            PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
          end else
            if CompareText(sLabel, sWITHDRAWAL) = 0 then
            begin
              case TUserCastle(m_Castle).WithDrawalGolds(PlayObject, Str_ToInt(sMsg, 0)) of    //收回现金
                -4: s18 := '输入的金币数不正确！！！';
                -3: s18 := '您无法携带更多的东西了。';
                -2: s18 := '该城内没有这么多金币.';
                -1: s18 := '只有行会 ' + TUserCastle(m_Castle).m_sOwnGuild + ' 的掌门人才能使用！！！';
                1: GotoLable(PlayObject, sMAIN, False);
              end;
              PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
            end else
              if CompareText(sLabel, sRECEIPTS) = 0 then
              begin
                case TUserCastle(m_Castle).ReceiptGolds(PlayObject, Str_ToInt(sMsg, 0)) of
                  -4: s18 := '输入的金币数不正确！！！';
                  -3: s18 := '你已经达到在城内存放货物的限制了。';
                  -2: s18 := '你没有那么多金币.';
                  -1: s18 := '只有行会 ' + TUserCastle(m_Castle).m_sOwnGuild + ' 的掌门人才能使用！！！';
                  1: GotoLable(PlayObject, sMAIN, False);
                end;
                PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
              end else
                if CompareText(sLabel, sOPENMAINDOOR) = 0 then
                begin
                  TUserCastle(m_Castle).MainDoorControl(False);
                end else
                  if CompareText(sLabel, sCLOSEMAINDOOR) = 0 then
                  begin
                    TUserCastle(m_Castle).MainDoorControl(True);
                  end else
                    if CompareText(sLabel, sREPAIRDOORNOW) = 0 then
                    begin
                      RepairDoor(PlayObject);
                      GotoLable(PlayObject, sMAIN, False);
                    end else
                      if CompareText(sLabel, sREPAIRWALLNOW1) = 0 then
                      begin
                        RepairWallNow(1, PlayObject);
                        GotoLable(PlayObject, sMAIN, False);
                      end else
                        if CompareText(sLabel, sREPAIRWALLNOW2) = 0 then
                        begin
                          RepairWallNow(2, PlayObject);
                          GotoLable(PlayObject, sMAIN, False);
                        end else
                          if CompareText(sLabel, sREPAIRWALLNOW3) = 0 then
                          begin
                            RepairWallNow(3, PlayObject);
                            GotoLable(PlayObject, sMAIN, False);
                          end else
                            if CompareLStr(sLabel, sHIREGUARDNOW, Length(sHIREGUARDNOW)) then
                            begin
                              s20 := Copy(sLabel, Length(sHIREGUARDNOW) + 1, Length(sLabel));
                              HireGuard(s20, PlayObject);
                              PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, '');
                             //GotoLable(PlayObject,sHIREGUARDOK,False);
                            end else
                              if CompareLStr(sLabel, sHIREARCHERNOW, Length(sHIREARCHERNOW)) then
                              begin
                                s20 := Copy(sLabel, Length(sHIREARCHERNOW) + 1, Length(sLabel));
                                HireArcher(s20, PlayObject);
                                PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, '');
                              end else
                                if CompareText(sLabel, sEXIT) = 0 then
                                begin
                                  PlayObject.SendMsg(Self, RM_MERCHANTDLGCLOSE, 0, Integer(Self), 0, 0, '');
                                end else
                                  if CompareText(sLabel, sBACK) = 0 then
                                  begin
                                    if PlayObject.m_sScriptGoBackLable = '' then PlayObject.m_sScriptGoBackLable := sMAIN;
                                    GotoLable(PlayObject, PlayObject.m_sScriptGoBackLable, False);
                                  end;
      end else
      begin
        s18 := '你没有权利使用...';
        PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
      end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
//  inherited;

end;
procedure TCastleOfficial.HireGuard(sIndex: string; PlayObject: TPlayObject); //004A413C
var
  n10: Integer;
  ObjUnit: pTObjUnit;
begin
  if m_Castle = nil then
  begin
    PlayObject.SysMsg('NPC不属于城堡！！！', c_Red, t_Hint);
    Exit;
  end;
  if TUserCastle(m_Castle).m_nTotalGold >= g_Config.nHireGuardPrice then
  begin
    n10 := Str_ToInt(sIndex, 0) - 1;
    if n10 <= MAXCALSTEGUARD then
    begin
      if TUserCastle(m_Castle).m_Guard[n10].BaseObject = nil then
      begin
        if not TUserCastle(m_Castle).m_boUnderWar then
        begin
          ObjUnit := @TUserCastle(m_Castle).m_Guard[n10];
          ObjUnit.BaseObject := UserEngine.RegenMonsterByName(TUserCastle(m_Castle).m_sMapName,
            ObjUnit.nX,
            ObjUnit.nY,
            ObjUnit.sName);
          if ObjUnit.BaseObject <> nil then
          begin
            Dec(TUserCastle(m_Castle).m_nTotalGold, g_Config.nHireGuardPrice);
            ObjUnit.BaseObject.m_Castle := TUserCastle(m_Castle);
            TGuardUnit(ObjUnit.BaseObject).m_nX550 := ObjUnit.nX;
            TGuardUnit(ObjUnit.BaseObject).m_nY554 := ObjUnit.nY;
            TGuardUnit(ObjUnit.BaseObject).m_nDirection := 3;
            PlayObject.SysMsg('雇佣成功.', c_Green, t_Hint);
          end;

        end else
        begin
          PlayObject.SysMsg('现在无法雇佣！！！', c_Red, t_Hint);
        end;
      end else
      begin
        PlayObject.SysMsg('早已雇佣！！！', c_Red, t_Hint);
      end;
    end else
    begin
      PlayObject.SysMsg('指令错误！！！', c_Red, t_Hint);
    end;
  end else
  begin
    PlayObject.SysMsg('城内资金不足！！！', c_Red, t_Hint);
  end;
  {
  if UserCastle.m_nTotalGold >= g_Config.nHireGuardPrice then begin
    n10:=Str_ToInt(sIndex,0) - 1;
    if n10 <= MAXCALSTEGUARD then begin
      if UserCastle.m_Guard[n10].BaseObject = nil then begin
        if not UserCastle.m_boUnderWar then begin
          ObjUnit:=@UserCastle.m_Guard[n10];
          ObjUnit.BaseObject:=UserEngine.RegenMonsterByName(UserCastle.m_sMapName,
                                                          ObjUnit.nX,
                                                          ObjUnit.nY,
                                                          ObjUnit.sName);
          if ObjUnit.BaseObject <> nil then begin
            Dec(UserCastle.m_nTotalGold,g_Config.nHireGuardPrice);
            ObjUnit.BaseObject.m_Castle:=UserCastle;
            TGuardUnit(ObjUnit.BaseObject).m_nX550:=ObjUnit.nX;
            TGuardUnit(ObjUnit.BaseObject).m_nY554:=ObjUnit.nY;
            TGuardUnit(ObjUnit.BaseObject).m_n558:=3;
            PlayObject.SysMsg('雇佣成功.',c_Green,t_Hint);
          end;

        end else begin
          PlayObject.SysMsg('现在无法雇佣！！！',c_Red,t_Hint);
        end;
      end
    end else begin
      PlayObject.SysMsg('指令错误！！！',c_Red,t_Hint);
    end;
  end else begin
    PlayObject.SysMsg('城内资金不足！！！',c_Red,t_Hint);
  end;
  }
end;
procedure TCastleOfficial.HireArcher(sIndex: string; PlayObject: TPlayObject); //004A433C
var
  n10: Integer;
  ObjUnit: pTObjUnit;
begin
  if m_Castle = nil then
  begin
    PlayObject.SysMsg('NPC不属于城堡！！！', c_Red, t_Hint);
    Exit;
  end;

  if TUserCastle(m_Castle).m_nTotalGold >= g_Config.nHireArcherPrice then
  begin
    n10 := Str_ToInt(sIndex, 0) - 1;
    if n10 <= MAXCASTLEARCHER then
    begin
      if TUserCastle(m_Castle).m_Archer[n10].BaseObject = nil then
      begin
        if not TUserCastle(m_Castle).m_boUnderWar then
        begin
          ObjUnit := @TUserCastle(m_Castle).m_Archer[n10];
          ObjUnit.BaseObject := UserEngine.RegenMonsterByName(TUserCastle(m_Castle).m_sMapName,
            ObjUnit.nX,
            ObjUnit.nY,
            ObjUnit.sName);
          if ObjUnit.BaseObject <> nil then
          begin
            Dec(TUserCastle(m_Castle).m_nTotalGold, g_Config.nHireArcherPrice);
            ObjUnit.BaseObject.m_Castle := TUserCastle(m_Castle);
            TGuardUnit(ObjUnit.BaseObject).m_nX550 := ObjUnit.nX;
            TGuardUnit(ObjUnit.BaseObject).m_nY554 := ObjUnit.nY;
            TGuardUnit(ObjUnit.BaseObject).m_nDirection := 3;
            PlayObject.SysMsg('雇佣成功...', c_Green, t_Hint);
          end;

        end else
        begin
          PlayObject.SysMsg('现在无法雇佣！！！', c_Red, t_Hint);
        end;
      end else
      begin
        PlayObject.SysMsg('早已雇佣！！！', c_Red, t_Hint);
      end;
    end else
    begin
      PlayObject.SysMsg('指令错误！！！', c_Red, t_Hint);
    end;
  end else
  begin
    PlayObject.SysMsg('城内资金不足！！！', c_Red, t_Hint);
  end;
  {
  if UserCastle.m_nTotalGold >= g_Config.nHireArcherPrice then begin
    n10:=Str_ToInt(sIndex,0) - 1;
    if n10 <= MAXCASTLEARCHER then begin
      if UserCastle.m_Archer[n10].BaseObject = nil then begin
        if not UserCastle.m_boUnderWar then begin
          ObjUnit:=@UserCastle.m_Archer[n10];
          ObjUnit.BaseObject:=UserEngine.RegenMonsterByName(UserCastle.m_sMapName,
                                                          ObjUnit.nX,
                                                          ObjUnit.nY,
                                                          ObjUnit.sName);
          if ObjUnit.BaseObject <> nil then begin
            Dec(UserCastle.m_nTotalGold,g_Config.nHireArcherPrice);
            ObjUnit.BaseObject.m_Castle:=UserCastle;
            TGuardUnit(ObjUnit.BaseObject).m_nX550:=ObjUnit.nX;
            TGuardUnit(ObjUnit.BaseObject).m_nY554:=ObjUnit.nY;
            TGuardUnit(ObjUnit.BaseObject).m_n558:=3;
            PlayObject.SysMsg('雇佣成功.',c_Green,t_Hint);
          end;

        end else begin
          PlayObject.SysMsg('现在无法雇佣！！！',c_Red,t_Hint);
        end;
      end else begin
        PlayObject.SysMsg('早已雇佣！！！',c_Red,t_Hint);
      end;
    end else begin
      PlayObject.SysMsg('指令错误！！！',c_Red,t_Hint);
    end;
  end else begin
    PlayObject.SysMsg('城内资金不足！！！',c_Red,t_Hint);
  end;
  }
end;
{ TMerchant }

procedure TMerchant.AddItemPrice(nIndex: Integer; nPrice: Integer); //0049F2AC
var
  ItemPrice: pTItemPrice;
begin
  New(ItemPrice);
  ItemPrice.wIndex := nIndex;
  ItemPrice.nPrice := nPrice;
  m_ItemPriceList.Add(ItemPrice);
  FrmDB.SaveGoodPriceRecord(Self, m_sScript + '-' + m_sMapName);
end;
procedure TMerchant.CheckItemPrice(nIndex: Integer); //0049F1BC
var
  i: Integer;
  ItemPrice: pTItemPrice;
  n10: Integer;
  StdItem: TItem;
begin
  for i := 0 to m_ItemPriceList.Count - 1 do
  begin
    ItemPrice := m_ItemPriceList.Items[i];
    if ItemPrice.wIndex = nIndex then
    begin
      n10 := ItemPrice.nPrice;
      if Round(n10 * 1.1) > n10 then
      begin
        n10 := Round(n10 * 1.1);
      end else Inc(n10);
      Exit;
    end;
  end;
  StdItem := UserEngine.GetStdItem(nIndex);
  if StdItem <> nil then
  begin
    AddItemPrice(nIndex, Round(StdItem.Price * 1.1));
  end;
end;

//获取客户销售给NPC的商品列表
function TMerchant.GetRefillList(nIndex: Integer): TList; //0049F118
var
  i: Integer;
  List: TList;
begin
  Result := nil;
  if nIndex <= 0 then Exit;
  
  for i := 0 to m_GoodsList.Count - 1 do
  begin
    List := TList(m_GoodsList.Items[i]);
    if List.Count > 0 then
    begin
      if pTUserItem(List.Items[0]).wIndex = nIndex then
      begin
        Result := List;
        Break;
      end;
    end;
  end;
end;


//重新装满物品 （刷新商品列表）
procedure TMerchant.RefillGoods; //0049F950

  //将m_RefillGoodsList中的商品加到m_GoodsList中。参数：目标商品列表，商品名，数量
  procedure RefillItems(var List: TList; sItemName: string; nInt: Integer); //0049F824  重装商品条目
  var
    i: Integer;
    UserItem: pTUserItem;
  begin
    if List = nil then
    begin
      List := TList.Create;
      m_GoodsList.Add(List);    //List是来自m_RefillGoodsList有的商品
    end;
    for i := 0 to nInt - 1 do
    begin
      New(UserItem);    //New分配内存
      if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then
      begin
        List.Insert(0, UserItem);
      end else Dispose(UserItem);   //Dispose释放内存
    end;
  end;

  procedure DelReFillItem(var List: TList; nInt: Integer); //0049F8F8
  var
    i: Integer;
  begin
    for i := List.Count - 1 downto 0 do
    begin
      if nInt <= 0 then Break;
      Dispose(pTUserItem(List.Items[i]));
      List.Delete(i);
      Dec(nInt);
    end;
  end;

var
  i, ii: Integer;
  Goods: pTGoods;
  nIndex, nRefillCount: Integer;
  RefillList, RefillList20: TList;
  bo21: Boolean;

//  UserItem: pTUserItem; //debug_lzx20200208

resourcestring
  sExceptionMsg = '[Exception] TMerchant::RefillGoods %s/%d:%d [%s] Code:%d';
begin //0049F950
  try

    //将m_RefillGoodsList脚本中[goods]字段预先设定的商品加入到m_GoodsList中。m_GoodsList是销售可见的商品列表
    for i := 0 to m_RefillGoodsList.Count - 1 do
    begin
      Goods := m_RefillGoodsList.Items[i];

      if (GetTickCount - Goods.dwRefillTick) > Goods.dwRefillTime * 60 * 1000 then
      begin
        Goods.dwRefillTick := GetTickCount();
        nIndex := UserEngine.GetStdItemIdx(Goods.sItemName);
        if nIndex >= 0 then
        begin
          //memo.Lines.Add('test');
          RefillList := GetRefillList(nIndex);
          nRefillCount := 0;
          if RefillList <> nil then nRefillCount := RefillList.Count;
          if Goods.nCount > nRefillCount then
          begin
            CheckItemPrice(nIndex);
            RefillItems(RefillList, Goods.sItemName, Goods.nCount - nRefillCount);  //将RefillList加到m_GoodsList中
            FrmDB.SaveGoodRecord(Self, m_sScript + '-' + m_sMapName);
            FrmDB.SaveGoodPriceRecord(Self, m_sScript + '-' + m_sMapName);
          end;
          if Goods.nCount < nRefillCount then
          begin
            DelReFillItem(RefillList, nRefillCount - Goods.nCount);
            FrmDB.SaveGoodRecord(Self, m_sScript + '-' + m_sMapName);
            FrmDB.SaveGoodPriceRecord(Self, m_sScript + '-' + m_sMapName);
          end;
        end; //0049FB83
      end;
    end;

   //debug view
   {
     if m_GoodsList.Count > 0 then  begin

      MainOutMessage(Format('TMerchant.RefillGoods: ---- m_GoodsList.Count: %d ------', [m_GoodsList.Count]));   //debug_lzx20200208

      for i := 0 to m_GoodsList.Count - 1 do           //debug_lzx20200208
      begin
        RefillList20 := TList(m_GoodsList.Items[i]);
        UserItem := RefillList20.Items[0];

        MainOutMessage(Format('%d  %s',[UserItem.wIndex-1 ,UserEngine.GetStdItemName(UserItem.wIndex)]));    //debug_lzx20200208
      end;

       MainOutMessage('---------------------------------');
    end;
    }

   //如果某个商品的库存量大于1000个，则删除超出的数量
    for i := 0 to m_GoodsList.Count - 1 do
    begin
      RefillList20 := TList(m_GoodsList.Items[i]);
      if RefillList20.Count > 1000 then               //商品的库存量是否超过1000
      begin
        bo21 := False;
        for ii := 0 to m_RefillGoodsList.Count - 1 do
        begin
          Goods := m_RefillGoodsList.Items[ii];

          nIndex := UserEngine.GetStdItemIdx(Goods.sItemName);
          if pTItemPrice(RefillList20.Items[0]).wIndex = nIndex then
          begin
            bo21 := True;
            Break;
          end;
        end;
        if not bo21 then
        begin
          DelReFillItem(RefillList20, RefillList20.Count - 1000);
        end else
        begin
          DelReFillItem(RefillList20, RefillList20.Count - 5000);
        end;
      end; //0049FC79
    end;

  except
    on E: Exception do
      MainOutMessage(Format(sExceptionMsg, [m_sCharName, m_nCurrX, m_nCurrY,
        E.Message, nCHECK]));
  end;  
end;    //TMerchant.RefillGoods end.

function TMerchant.CheckItemType(nStdMode: Integer): Boolean; //0049F374
var
  i: Integer;
begin
  Result := False;
  for i := 0 to m_ItemTypeList.Count - 1 do
  begin
    if Integer(m_ItemTypeList.Items[i]) = nStdMode then
    begin
      Result := True;
      Break;
    end;
  end;
end;
function TMerchant.GetItemPrice(nIndex: Integer): Integer; //0049F374
var
  i: Integer;
  ItemPrice: pTItemPrice;
  StdItem: TItem;
begin
  Result := -1;
  for i := 0 to m_ItemPriceList.Count - 1 do
  begin
    ItemPrice := m_ItemPriceList.Items[i];
    if ItemPrice.wIndex = nIndex then
    begin
      Result := ItemPrice.nPrice;
      Break;
    end;
  end; // for
  if Result < 0 then
  begin
    StdItem := UserEngine.GetStdItem(nIndex);
    if StdItem <> nil then
    begin
      if CheckItemType(StdItem.StdMode) then
        Result := StdItem.Price;
    end;
  end;
end;
procedure TMerchant.SaveUpgradingList(); //0049FF84
begin
  try
    //FrmDB.SaveUpgradeWeaponRecord(m_sCharName,m_UpgradeWeaponList);
    FrmDB.SaveUpgradeWeaponRecord(m_sScript + '-' + m_sMapName, m_UpgradeWeaponList);
  except
    MainOutMessage('Failure in saving upgradinglist - ' + m_sCharName);
  end;
end;
procedure TMerchant.UpgradeWapon(User: TPlayObject); //004A0920
  procedure sub_4A0218(ItemList: TList; var btDc: Byte; var btSc: Byte; var btMc: Byte; var btDura: Byte);
  var
    i, ii: Integer;
    DuraList: TList;
    UserItem: pTUserItem;
    StdItem: TItem;
    StdItem80: TStdItem;
    DelItemList: TStringList;
    nDc, nSc, nMc, nDcMin, nDcMax, nScMin, nScMax, nMcMin, nMcMax, nDura, nItemCount: Integer;
  begin
    nDcMin := 0;
    nDcMax := 0;
    nScMin := 0;
    nScMax := 0;
    nMcMin := 0;
    nMcMax := 0;
    nDura := 0;
    nItemCount := 0;
    DelItemList := nil;
    DuraList := TList.Create;
    for i := ItemList.Count - 1 downto 0 do
    begin
      UserItem := ItemList.Items[i];
      if UserEngine.GetStdItemName(UserItem.wIndex) = g_Config.sBlackStone then
      begin
        DuraList.Add(Pointer(Round(UserItem.Dura / 1.0E3)));
        if DelItemList = nil then DelItemList := TStringList.Create;
        DelItemList.AddObject(g_Config.sBlackStone, TObject(UserItem.MakeIndex));
        Dispose(UserItem);
        ItemList.Delete(i);
      end else
      begin
        if IsAccessory(UserItem.wIndex) then
        begin
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if StdItem <> nil then
          begin
            StdItem.GetStandardItem(StdItem80);
            StdItem.GetItemAddValue(UserItem, StdItem80);
            nDc := 0;
            nSc := 0;
            nMc := 0;
            case StdItem80.StdMode of
              19, 20, 21:
                begin //004A0421
                  nDc := HiWord(StdItem80.DC) + LoWord(StdItem80.DC);
                  nSc := HiWord(StdItem80.SC) + LoWord(StdItem80.SC);
                  nMc := HiWord(StdItem80.MC) + LoWord(StdItem80.MC);
                end;
              22, 23:
                begin //004A046E
                  nDc := HiWord(StdItem80.DC) + LoWord(StdItem80.DC);
                  nSc := HiWord(StdItem80.SC) + LoWord(StdItem80.SC);
                  nMc := HiWord(StdItem80.MC) + LoWord(StdItem80.MC);
                end;
              24, 26:
                begin
                  nDc := HiWord(StdItem80.DC) + LoWord(StdItem80.DC) + 1;
                  nSc := HiWord(StdItem80.SC) + LoWord(StdItem80.SC) + 1;
                  nMc := HiWord(StdItem80.MC) + LoWord(StdItem80.MC) + 1;
                end;
            end;
            if nDcMin < nDc then
            begin
              nDcMax := nDcMin;
              nDcMin := nDc;
            end else
            begin
              if nDcMax < nDc then nDcMax := nDc;
            end;
            if nScMin < nSc then
            begin
              nScMax := nScMin;
              nScMin := nSc;
            end else
            begin
              if nScMax < nSc then nScMax := nSc;
            end;
            if nMcMin < nMc then
            begin
              nMcMax := nMcMin;
              nMcMin := nMc;
            end else
            begin
              if nMcMax < nMc then nMcMax := nMc;
            end;
            if DelItemList = nil then DelItemList := TStringList.Create;
            DelItemList.AddObject(StdItem.Name, TObject(UserItem.MakeIndex));
            //004A06DB
            if StdItem.NeedIdentify = 1 then
              AddGameDataLog('26' + #9 +
                User.m_sMapName + #9 +
                IntToStr(User.m_nCurrX) + #9 +
                IntToStr(User.m_nCurrY) + #9 +
                User.m_sCharName + #9 +
                           //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
                StdItem.Name + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                '1' + #9 +
                '0');
            Dispose(UserItem);
            ItemList.Delete(i);
          end;
        end;
      end;
    end; // for
    for i := 0 to DuraList.Count - 1 do
    begin
      for ii := DuraList.Count - 1 downto i + 1 do
      begin
        if Integer(DuraList.Items[ii]) > Integer(DuraList.Items[ii - 1]) then
          DuraList.Exchange(ii, ii - 1);
      end; // for
    end; // for
    for i := 0 to DuraList.Count - 1 do
    begin
      nDura := nDura + Integer(DuraList.Items[i]);
      Inc(nItemCount);
      if nItemCount >= 5 then Break;
    end;
    btDura := Round(_MIN(5, nItemCount) + _MIN(5, nItemCount) * ((nDura / nItemCount) / 5.0));
    btDc := nDcMin div 5 + nDcMax div 3;
    btSc := nScMin div 5 + nScMax div 3;
    btMc := nMcMin div 5 + nMcMax div 3;
    if DelItemList <> nil then
      User.SendMsg(Self, RM_SENDDELITEMLIST, 0, Integer(DelItemList), 0, 0, '');

    if DuraList <> nil then DuraList.Free;

  end;
var
  i: Integer;
  bo0D: Boolean;
  UpgradeInfo: pTUpgradeInfo;
  StdItem: TItem;
begin
  bo0D := False;
  for i := 0 to m_UpgradeWeaponList.Count - 1 do
  begin
    UpgradeInfo := m_UpgradeWeaponList.Items[i];
    if UpgradeInfo.sUserName = User.m_sCharName then
    begin
      GotoLable(User, sUPGRADEING, False);
      Exit;
    end;
  end;
  if (User.m_UseItems[U_WEAPON].wIndex <> 0) and (User.m_nGold >= g_Config.nUpgradeWeaponPrice) and
    (User.CheckItems(g_Config.sBlackStone) <> nil) then
  begin
    User.DecGold(g_Config.nUpgradeWeaponPrice);
//    if m_boCastle or g_Config.boGetAllNpcTax then UserCastle.IncRateGold(g_Config.nUpgradeWeaponPrice);
    if m_boCastle or g_Config.boGetAllNpcTax then
    begin
      if m_Castle <> nil then
      begin
        TUserCastle(m_Castle).IncRateGold(g_Config.nUpgradeWeaponPrice);
      end else
        if g_Config.boGetAllNpcTax then
        begin
          g_CastleManager.IncRateGold(g_Config.nUpgradeWeaponPrice);
        end;
    end;
    User.GoldChanged();
    New(UpgradeInfo);
    UpgradeInfo.sUserName := User.m_sCharName;
    UpgradeInfo.UserItem := User.m_UseItems[U_WEAPON];
    StdItem := UserEngine.GetStdItem(User.m_UseItems[U_WEAPON].wIndex);

    //004A0B2F
    if StdItem.NeedIdentify = 1 then
      AddGameDataLog('25' + #9 +
        User.m_sMapName + #9 +
        IntToStr(User.m_nCurrX) + #9 +
        IntToStr(User.m_nCurrY) + #9 +
        User.m_sCharName + #9 +
                   //UserEngine.GetStdItemName(User.m_UseItems[U_WEAPON].wIndex) + #9 +
        StdItem.Name + #9 +
        IntToStr(User.m_UseItems[U_WEAPON].MakeIndex) + #9 +
        '1' + #9 +
        '0');
    User.SendDelItems(@User.m_UseItems[U_WEAPON]);
    User.m_UseItems[U_WEAPON].wIndex := 0;
    User.RecalcAbilitys();
    User.FeatureChanged();
    User.SendMsg(User, RM_ABILITY, 0, 0, 0, 0, '');
    sub_4A0218(User.m_ItemList, UpgradeInfo.btDc, UpgradeInfo.btSc, UpgradeInfo.btMc, UpgradeInfo.btDura);
    UpgradeInfo.dtTime := Now();
    UpgradeInfo.dwGetBackTick := GetTickCount();
    m_UpgradeWeaponList.Add(UpgradeInfo);
    SaveUpgradingList();
    bo0D := True;
  end;
  if bo0D then GotoLable(User, sUPGRADEOK, False)
  else GotoLable(User, sUPGRADEFAIL, False);
end;
procedure TMerchant.GetBackupgWeapon(User: TPlayObject); //004A0CB8
var
  i: Integer;
  UpgradeInfo: pTUpgradeInfo;
  n10, n14, n18, n1C, n90: Integer;
  UserItem: pTUserItem;
  StdItem: TItem;
begin
  n18 := 0;
  UpgradeInfo := nil;
  if not User.IsEnoughBag then
  begin
//    User.SysMsg('你的背包已经满了，无法再携带任何物品了！！！',0);
    GotoLable(User, sGETBACKUPGFULL, False);
    Exit;
  end;
  for i := 0 to m_UpgradeWeaponList.Count - 1 do
  begin
    if pTUpgradeInfo(m_UpgradeWeaponList.Items[i]).sUserName = User.m_sCharName then
    begin
      n18 := 1;
      if ((GetTickCount - pTUpgradeInfo(m_UpgradeWeaponList.Items[i]).dwGetBackTick) > g_Config.dwUPgradeWeaponGetBackTime) or (User.m_btPermission >= 4) then
      begin
        UpgradeInfo := m_UpgradeWeaponList.Items[i];
        m_UpgradeWeaponList.Delete(i);
        SaveUpgradingList();
        n18 := 2;
        Break;
      end;
    end;
  end;
  //004A0DC2
  if UpgradeInfo <> nil then
  begin
    case UpgradeInfo.btDura of //
      0..8:
        begin //004A0DE5
//       n14:=_MAX(3000,UpgradeInfo.UserItem.DuraMax shr 1);
          if UpgradeInfo.UserItem.DuraMax > 3000 then
          begin
            Dec(UpgradeInfo.UserItem.DuraMax, 3000);
          end else
          begin
            UpgradeInfo.UserItem.DuraMax := UpgradeInfo.UserItem.DuraMax shr 1;
          end;
          if UpgradeInfo.UserItem.Dura > UpgradeInfo.UserItem.DuraMax then
            UpgradeInfo.UserItem.Dura := UpgradeInfo.UserItem.DuraMax;
        end;
      9..15:
        begin //004A0E41
          if Random(UpgradeInfo.btDura) < 6 then
          begin
            if UpgradeInfo.UserItem.DuraMax > 1000 then
              Dec(UpgradeInfo.UserItem.DuraMax, 1000);
            if UpgradeInfo.UserItem.Dura > UpgradeInfo.UserItem.DuraMax then
              UpgradeInfo.UserItem.Dura := UpgradeInfo.UserItem.DuraMax;
          end;

        end;
      18..255:
        begin
          case Random(UpgradeInfo.btDura - 18) of
            1..4: Inc(UpgradeInfo.UserItem.DuraMax, 1000);
            5..7: Inc(UpgradeInfo.UserItem.DuraMax, 2000);
            8..255: Inc(UpgradeInfo.UserItem.DuraMax, 4000)
          end;
        end;
    end; // case
    if (UpgradeInfo.btDc = UpgradeInfo.btMc) and (UpgradeInfo.btMc = UpgradeInfo.btSc) then
    begin
      n1C := Random(3);
    end else
    begin
      n1C := -1;
    end;
    if ((UpgradeInfo.btDc >= UpgradeInfo.btMc) and (UpgradeInfo.btDc >= UpgradeInfo.btSc)) or
      (n1C = 0) then
    begin
      n90 := _MIN(11, UpgradeInfo.btDc);
      n10 := _MIN(85, n90 shl 3 - n90 + 10 + UpgradeInfo.UserItem.btValue[3] - UpgradeInfo.UserItem.btValue[4] + User.m_nBodyLuckLevel);
//      n10:=_MIN(85,n90 * 8 - n90 + 10 + UpgradeInfo.UserItem.btValue[3] - UpgradeInfo.UserItem.btValue[4] + User.m_nBodyLuckLevel);

      if Random(g_Config.nUpgradeWeaponDCRate) < n10 then
      begin //if Random(100) < n10 then begin
        UpgradeInfo.UserItem.btValue[10] := 10;

        if (n10 > 63) and (Random(g_Config.nUpgradeWeaponDCTwoPointRate) = 0) then //if (n10 > 63) and (Random(30) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 11;

        if (n10 > 79) and (Random(g_Config.nUpgradeWeaponDCThreePointRate) = 0) then //if (n10 > 79) and (Random(200) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 12;
      end else UpgradeInfo.UserItem.btValue[10] := 1; //004A0F89
    end;

    if ((UpgradeInfo.btMc >= UpgradeInfo.btDc) and (UpgradeInfo.btMc >= UpgradeInfo.btSc)) or
      (n1C = 1) then
    begin
      n90 := _MIN(11, UpgradeInfo.btMc);
      n10 := _MIN(85, n90 shl 3 - n90 + 10 + UpgradeInfo.UserItem.btValue[3] - UpgradeInfo.UserItem.btValue[4] + User.m_nBodyLuckLevel);

      if Random(g_Config.nUpgradeWeaponMCRate) < n10 then
      begin //if Random(100) < n10 then begin
        UpgradeInfo.UserItem.btValue[10] := 20;

        if (n10 > 63) and (Random(g_Config.nUpgradeWeaponMCTwoPointRate) = 0) then //if (n10 > 63) and (Random(30) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 21;

        if (n10 > 79) and (Random(g_Config.nUpgradeWeaponMCThreePointRate) = 0) then //if (n10 > 79) and (Random(200) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 22;
      end else UpgradeInfo.UserItem.btValue[10] := 1;
    end;

    if ((UpgradeInfo.btSc >= UpgradeInfo.btMc) and (UpgradeInfo.btSc >= UpgradeInfo.btDc)) or
      (n1C = 2) then
    begin
      n90 := _MIN(11, UpgradeInfo.btMc);
      n10 := _MIN(85, n90 shl 3 - n90 + 10 + UpgradeInfo.UserItem.btValue[3] - UpgradeInfo.UserItem.btValue[4] + User.m_nBodyLuckLevel);

      if Random(g_Config.nUpgradeWeaponSCRate) < n10 then
      begin //if Random(100) < n10 then begin
        UpgradeInfo.UserItem.btValue[10] := 30;

        if (n10 > 63) and (Random(g_Config.nUpgradeWeaponSCTwoPointRate) = 0) then //if (n10 > 63) and (Random(30) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 31;

        if (n10 > 79) and (Random(g_Config.nUpgradeWeaponSCThreePointRate) = 0) then //if (n10 > 79) and (Random(200) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 32;
      end else UpgradeInfo.UserItem.btValue[10] := 1;
    end;
    New(UserItem);
    UserItem^ := UpgradeInfo.UserItem;
    Dispose(UpgradeInfo);
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    //004A120E
    if StdItem.NeedIdentify = 1 then
      AddGameDataLog('24' + #9 +
        User.m_sMapName + #9 +
        IntToStr(User.m_nCurrX) + #9 +
        IntToStr(User.m_nCurrY) + #9 +
        User.m_sCharName + #9 +
                   //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
        StdItem.Name + #9 +
        IntToStr(UserItem.MakeIndex) + #9 +
        '1' + #9 +
        '0');
    User.AddItemToBag(UserItem);
    User.SendAddItem(UserItem);
  end;
  case n18 of //
    0: GotoLable(User, sGETBACKUPGFAIL, False);
    1: GotoLable(User, sGETBACKUPGING, False);
    2: GotoLable(User, sGETBACKUPGOK, False);
  end; // case

end;
function TMerchant.GetUserPrice(PlayObject: TPlayObject; nPrice: Integer): Integer; //0049F6E0
var
  n14: Integer;
begin
  {
  if m_boCastle then begin
    if UserCastle.IsMasterGuild(TGuild(PlayObject.m_MyGuild)) then begin
      n14:=_MAX(60,ROUND(m_nPriceRate * 8.0000000000000000001e-1));//80%
      Result:=ROUND(nPrice / 1.0e2 * n14); //100
    end else begin
      Result:=ROUND(nPrice / 1.0e2 * m_nPriceRate);
    end;
  end else begin
    Result:=ROUND(nPrice / 1.0e2 * m_nPriceRate);
  end;
  }
  if m_boCastle then
  begin
//    if UserCastle.IsMasterGuild(TGuild(PlayObject.m_MyGuild)) then begin
    if (m_Castle <> nil) and TUserCastle(m_Castle).IsMasterGuild(TGUild(PlayObject.m_MyGuild)) then
    begin
      n14 := _MAX(60, Round(m_nPriceRate * (g_Config.nCastleMemberPriceRate / 100))); //80%
      Result := Round(nPrice / 100 * n14); //100
    end else
    begin
      Result := Round(nPrice / 100 * m_nPriceRate);
    end;
  end else
  begin
    Result := Round(nPrice / 100 * m_nPriceRate);
  end;
end;

//用户选择
procedure TMerchant.UserSelect(PlayObject: TPlayObject; sData: string); //004A1820
  procedure SuperRepairItem(User: TPlayObject); //004A159C
  begin
    User.SendMsg(Self, RM_SENDUSERSREPAIR, 0, Integer(Self), 0, 0, '');
  end;
  procedure BuyItem(User: TPlayObject; nInt: Integer); //004A1378
  var
    i, n10, nStock, nPrice: Integer;
    nSubMenu: ShortInt;
    sSENDMSG, sName: string;
    UserItem: pTUserItem;
    StdItem: TItem;
    List14: TList;
    sUserItemName: string;
  begin
    sSENDMSG := '';
    n10 := 0;
    for i := 0 to m_GoodsList.Count - 1 do
    begin
      List14 := TList(m_GoodsList.Items[i]);
      UserItem := List14.Items[0];
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then
      begin
        //取自定义物品名称
        sName := GetItemName(UserItem);

        nPrice := GetUserPrice(User, GetItemPrice(UserItem.wIndex));
        nStock := List14.Count;
        if (StdItem.StdMode <= 4) or
          (StdItem.StdMode = 42) or
          (StdItem.StdMode = 31) then nSubMenu := 0
        else nSubMenu := 1;
        sSENDMSG := sSENDMSG + sName + '/' + IntToStr(nSubMenu) + '/' + IntToStr(nPrice) + '/' + IntToStr(nStock) + '/';
        Inc(n10);
      end;
    end; // for
    User.SendMsg(Self, RM_SENDGOODSLIST, 0, Integer(Self), n10, 0, sSENDMSG);
  end;
  procedure SellItem(User: TPlayObject); //004A1544
  begin
    User.SendMsg(Self, RM_SENDUSERSELL, 0, Integer(Self), 0, 0, '');
  end;
  procedure RepairItem(User: TPlayObject); //004A1570
  begin
    User.SendMsg(Self, RM_SENDUSERREPAIR, 0, Integer(Self), 0, 0, '');
  end;
  
  procedure MakeDurg(User: TPlayObject); //004A16A0
  var
    i: Integer;
    List14: TList;
    UserItem: pTUserItem;
    StdItem: TItem;
    sSENDMSG: string;
    nSubMenu: Integer;
    nPrice: Integer;
    nStock: Integer;
  begin
    sSENDMSG := '';
    for i := 0 to m_GoodsList.Count - 1 do
    begin
      List14 := TList(m_GoodsList.Items[i]);
      //if List14.Count <= 0 then Continue; //0807 增加，防止在制药物品列表为空时出错
      UserItem := List14.Items[0];
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then
      begin
        sSENDMSG := sSENDMSG + StdItem.Name + '/' + IntToStr(0) + '/' + IntToStr(g_Config.nMakeDurgPrice) + '/' + IntToStr(1) + '/';
      end;
    end;
    if sSENDMSG <> '' then
      User.SendMsg(Self, RM_USERMAKEDRUGITEMLIST, 0, Integer(Self), 0, 0, sSENDMSG);
  end;
  procedure ItemPrices(User: TPlayObject); //
  begin

  end;
  procedure Storage(User: TPlayObject); //004A1648
  begin
    User.SendMsg(Self, RM_USERSTORAGEITEM, 0, Integer(Self), 0, 0, '');
  end;
  procedure GetBack(User: TPlayObject); //004A1674
  begin
    User.SendMsg(Self, RM_USERGETBACKITEM, 0, Integer(Self), 0, 0, '');
  end;
var
  sLabel, s18, sMsg: string;
  boCanJmp: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TMerchant::UserSelect... Data: %s';
begin //004A1820
  inherited;
  if not (ClassNameIs(TMerchant.ClassName)) then Exit; //如果类名不是 TMerchant 则不执行以下处理函数

  try
//    PlayObject.m_nScriptGotoCount:=0;
//    if not m_boCastle or not UserCastle.m_boUnderWar then begin
    if not m_boCastle or not ((m_Castle <> nil) and TUserCastle(m_Castle).m_boUnderWar) then
    begin
      if not PlayObject.m_boDeath and (sData <> '') and (sData[1] = '@') then
      begin
        sMsg := GetValidStr3(sData, sLabel, [#13]);
        s18 := '';
        PlayObject.m_sScriptLable := sData;
        boCanJmp := PlayObject.LableIsCanJmp(sLabel);
        if CompareText(sLabel, sSL_SENDMSG) = 0 then
        begin
          if sMsg = '' then Exit;
        end;
        GotoLable(PlayObject, sLabel, not boCanJmp);
        if not boCanJmp then Exit;

        if CompareText(sLabel, sSL_SENDMSG) = 0 then
        begin
          if m_boSendmsg then SendCustemMsg(PlayObject, sMsg);
        end else
          if CompareText(sLabel, sSUPERREPAIR) = 0 then
          begin
            if m_boS_repair then SuperRepairItem(PlayObject);
          end else
            if CompareText(sLabel, sBUY) = 0 then
            begin
              if m_boBuy then BuyItem(PlayObject, 0);
            end else
              if CompareText(sLabel, sSELL) = 0 then
              begin
                if m_boSell then SellItem(PlayObject);
              end else
                if CompareText(sLabel, sREPAIR) = 0 then
                begin
                  if m_boRepair then RepairItem(PlayObject);
                end else
                  if CompareText(sLabel, sMAKEDURG) = 0 then
                  begin
                    if m_boMakeDrug then MakeDurg(PlayObject);
                  end else
                    if CompareText(sLabel, sPRICES) = 0 then
                    begin
                      if m_boPrices then ItemPrices(PlayObject);
                    end else
                      if CompareText(sLabel, sSTORAGE) = 0 then
                      begin
                        if m_boStorage then Storage(PlayObject);
                      end else
                        if CompareText(sLabel, sGETBACK) = 0 then
                        begin
                          if m_boGetback then GetBack(PlayObject);
                        end else
                          if CompareText(sLabel, sUPGRADENOW) = 0 then
                          begin
                            if m_boUpgradenow then UpgradeWapon(PlayObject);
                          end else
                            if CompareText(sLabel, sGETBACKUPGNOW) = 0 then
                            begin
                              if m_boGetBackupgnow then GetBackupgWeapon(PlayObject);
                            end else

//取消脚本中对 结婚 和 师徒 的命令处理
{
                              if CompareText(sLabel, sGETMARRY) = 0 then
                              begin
                                if m_boGetMarry then GetBackupgWeapon(PlayObject);
                              end else
                                if CompareText(sLabel, sGETMASTER) = 0 then
                                begin
                                  if m_boGetMaster then GetBackupgWeapon(PlayObject);
                                end else
}
                                  if CompareLStr(sLabel, sUSEITEMNAME, Length(sUSEITEMNAME)) then
                                  begin

                                    if m_boUseItemName then ChangeUseItemName(PlayObject, sLabel, sMsg);
                                  end else
                                    if CompareText(sLabel, sEXIT) = 0 then
                                    begin
                                      PlayObject.SendMsg(Self, RM_MERCHANTDLGCLOSE, 0, Integer(Self), 0, 0, '');
                                    end else
                                      if CompareText(sLabel, sBACK) = 0 then
                                      begin
                                        if PlayObject.m_sScriptGoBackLable = '' then PlayObject.m_sScriptGoBackLable := sMAIN;
                                        GotoLable(PlayObject, PlayObject.m_sScriptGoBackLable, False);
                                      end;
      end; //004A1A3E
    end; //004A187E
  except
    MainOutMessage(Format(sExceptionMsg, [sData]));
  end;
end;   //TMerchant.UserSelect end.

procedure TMerchant.Run(); //004A2ECC
var
  nCheckCode: Integer;
resourcestring
  sExceptionMsg1 = '[Exception] TMerchant::Run... Code = %d';
  sExceptionMsg2 = '[Exception] TMerchant::Run -> Move Code = %d';
begin
  nCheckCode := 0;
  try
    //30000 毫秒(30秒) 刷新一次商品列表
    if (GetTickCount - dwRefillGoodsTick) > 30000 then
    begin
    //if (GetTickCount - dwTick578) > 3000 then begin
      dwRefillGoodsTick := GetTickCount();
      RefillGoods();    //重新装满商品    debug viewpoint.   debug viewpoint. lzx 2020/02/08
    end;

    nCheckCode := 1;
    if (GetTickCount - dwClearExpreUpgradeTick) > 10 * 60 * 1000 then
    begin
      dwClearExpreUpgradeTick := GetTickCount();
      ClearExpreUpgradeListData();
    end;
    nCheckCode := 2;
    if Random(50) = 0 then
    begin
      TurnTo(Random(8));
    end else
    begin
      if Random(50) = 0 then
        SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    end;
    nCheckCode := 3;
//    if m_boCastle and (UserCastle.m_boUnderWar)then begin
    if m_boCastle and (m_Castle <> nil) and TUserCastle(m_Castle).m_boUnderWar then
    begin
      if not m_boFixedHideMode then
      begin
        SendRefMsg(RM_DISAPPEAR, 0, 0, 0, 0, '');
        m_boFixedHideMode := True;
      end;
    end else
    begin
      if m_boFixedHideMode then
      begin
        m_boFixedHideMode := False;
        SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
      end;
    end;
    nCheckCode := 4;
  except
    on E: Exception do
    begin
      MainOutMessage(Format(sExceptionMsg1, [nCheckCode]));
      MainOutMessage(E.Message);
    end;
  end;
  try
    if m_boCanMove and (GetTickCount - m_dwMoveTick > m_dwMoveTime * 1000) then
    begin
      m_dwMoveTick := GetTickCount();
      SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
      MapRandomMove(m_sMapName, 0);
    end;
  except
    on E: Exception do
    begin
      MainOutMessage(Format(sExceptionMsg2, [nCheckCode]));
      MainOutMessage(E.Message);
    end;
  end;
  inherited;
end;
function TMerchant.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  Result := inherited Operate(ProcessMsg);

end;

procedure TMerchant.LoadNPCData; //0049F044
var
  sFile: string;
begin
  sFile := m_sScript + '-' + m_sMapName;
  FrmDB.LoadGoodRecord(Self, sFile);
  FrmDB.LoadGoodPriceRecord(Self, sFile);
  LoadUpgradeList();
end;

procedure TMerchant.SaveNPCData;
var
  sFile: string;
begin
  sFile := m_sScript + '-' + m_sMapName;
  FrmDB.SaveGoodRecord(Self, sFile);
  FrmDB.SaveGoodPriceRecord(Self, sFile);
end;

constructor TMerchant.Create; //0049EC70
begin
  inherited;
  m_btRaceImg := RCC_MERCHANT;
  m_wAppr := 0;
  m_nPriceRate := 100;
  m_boCastle := False;
  m_ItemTypeList := TList.Create;
  m_RefillGoodsList := TList.Create;
  m_GoodsList := TList.Create;
  m_ItemPriceList := TList.Create;
  m_UpgradeWeaponList := TList.Create;
  dwRefillGoodsTick := GetTickCount();
  dwClearExpreUpgradeTick := GetTickCount();
  m_boBuy := False;
  m_boSell := False;
  m_boMakeDrug := False;
  m_boPrices := False;
  m_boStorage := False;
  m_boGetback := False;
  m_boUpgradenow := False;
  m_boGetBackupgnow := False;
  m_boRepair := False;
  m_boS_repair := False;
//  m_boGetMarry := False;
//  m_boGetMaster := False;
  m_boUseItemName := False;
  m_dwMoveTick := GetTickCount();
end;

destructor TMerchant.Destroy; //0049ED70
var
  i: Integer;
  ii: Integer;
  List: TList;
begin
  m_ItemTypeList.Free;
  for i := 0 to m_RefillGoodsList.Count - 1 do
  begin
    Dispose(pTGoods(m_RefillGoodsList.Items[i]));
  end;
  m_RefillGoodsList.Free;
  for i := 0 to m_GoodsList.Count - 1 do
  begin
    List := TList(m_GoodsList.Items[i]);
    for ii := 0 to List.Count - 1 do
    begin
      Dispose(pTUserItem(List.Items[ii]));
    end;
    List.Free;
  end;
  m_GoodsList.Free;

  for i := 0 to m_ItemPriceList.Count - 1 do
  begin
    Dispose(pTItemPrice(m_ItemPriceList.Items[i]));
  end;
  m_ItemPriceList.Free;
  for i := 0 to m_UpgradeWeaponList.Count - 1 do
  begin
    Dispose(pTUpgradeInfo(m_UpgradeWeaponList.Items[i]));
  end;
  m_UpgradeWeaponList.Free;
  inherited;
end;

procedure TMerchant.ClearExpreUpgradeListData; //004A01A0
var
  i: Integer;
  UpgradeInfo: pTUpgradeInfo;
begin
  for i := m_UpgradeWeaponList.Count - 1 downto 0 do
  begin
    UpgradeInfo := m_UpgradeWeaponList.Items[i];
    if Integer(Round(Now - UpgradeInfo.dtTime)) >= g_Config.nClearExpireUpgradeWeaponDays then
    begin
      Dispose(UpgradeInfo);
      m_UpgradeWeaponList.Delete(i);
    end;
  end;
end;

procedure TMerchant.LoadNpcScript; //0049EF7C
var
  SC: string;
begin
  m_ItemTypeList.Clear;
  m_sPath := sMarket_Def;
  SC := m_sScript + '-' + m_sMapName;
  FrmDB.LoadScriptFile(Self, sMarket_Def, SC, True);
//  call    sub_49ABE0
end;

procedure TMerchant.Click(PlayObject: TPlayObject); //0049FF24
begin
//  GotoLable(PlayObject,'@main');
  inherited;
end;

procedure TMerchant.GetVariableText(PlayObject: TPlayObject;
  var sMsg: string; sVariable: string); //0049FD04
var
  sText, s14: string;
  n18: Integer;
begin
  inherited;
  if sVariable = '$PRICERATE' then
  begin
    sText := IntToStr(m_nPriceRate);
    sMsg := sub_49ADB8(sMsg, '<$PRICERATE>', sText);
  end;
  if sVariable = '$UPGRADEWEAPONFEE' then
  begin
    sText := IntToStr(g_Config.nUpgradeWeaponPrice);
    sMsg := sub_49ADB8(sMsg, '<$UPGRADEWEAPONFEE>', sText);
  end;
  if sVariable = '$USERWEAPON' then
  begin
    if PlayObject.m_UseItems[U_WEAPON].wIndex <> 0 then
    begin
      sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_WEAPON].wIndex);
    end else
    begin
      sText := 'Weapon';
    end;
    sMsg := sub_49ADB8(sMsg, '<$USERWEAPON>', sText);
  end;

end;

//获取物品价格
function TMerchant.GetUserItemPrice(UserItem: pTUserItem): Integer; //0049F428
var
  n10: Integer;
  StdItem: TItem;
  n20: Real;
  nC: Integer;
  n14: Integer;
begin
  n10 := GetItemPrice(UserItem.wIndex);
  if n10 > 0 then
  begin
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (StdItem <> nil) and
      (StdItem.StdMode > 4) and
      (StdItem.DuraMax > 0) and
      (UserItem.DuraMax > 0) then
    begin
      if StdItem.StdMode = 40 then
      begin //40肉
        if UserItem.Dura <= UserItem.DuraMax then
        begin
          n20 := (n10 / 2.0 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura));
          n10 := _MAX(2, Round(n10 - n20));
        end else
        begin
          n10 := n10 + Round(n10 / UserItem.DuraMax * 2.0 * (UserItem.DuraMax - UserItem.Dura));
        end;
      end; //0049F528

      if (StdItem.StdMode = 43) then
      begin //43矿石
        if UserItem.DuraMax < 10000 then UserItem.DuraMax := 10000;
        if UserItem.Dura <= UserItem.DuraMax then
        begin
          n20 := (n10 / 2.0 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura));
          n10 := _MAX(2, Round(n10 - n20));
        end else
        begin
          n10 := n10 + Round(n10 / UserItem.DuraMax * 1.3 * (UserItem.DuraMax - UserItem.Dura));
        end;
      end; //0049F5C5

      if StdItem.StdMode > 4 then
      begin
        n14 := 0;
        nC := 0;
        while (True) do
        begin
          if (StdItem.StdMode = 5) or (StdItem.StdMode = 6) then    //5,6武器
          begin
            if (nC <> 4) or (nC <> 9) then
            begin
              if nC = 6 then
              begin
                if UserItem.btValue[nC] > 10 then
                begin
                  n14 := n14 + (UserItem.btValue[nC] - 10) * 2;
                end;
              end else
              begin
                n14 := n14 + UserItem.btValue[nC];
              end;
            end;
          end else
          begin
            Inc(n14, UserItem.btValue[nC]);
          end;
          Inc(nC);
          if nC >= 8 then Break;
        end; // while
        if n14 > 0 then
        begin
          n10 := n10 div 5 * n14;
        end;
        n10 := Round(n10 / StdItem.DuraMax * UserItem.DuraMax);
        n20 := (n10 / 2.0 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura));
        n10 := _MAX(2, Round(n10 - n20));
      end; //0049F6BF
    end; //0049F6BF
  end;
  Result := n10;
end;

//客户端购买物品
procedure TMerchant.ClientBuyItem(PlayObject: TPlayObject; sItemName: string;
  nInt: Integer); //004A2334
var
  i, ii: Integer;
  bo29: Boolean;
  List20: TList;
  ItemPrice: pTItemPrice;
  UserItem: pTUserItem;
  StdItem: TItem;
  n1C, nPrice: Integer;
  sUserItemName: string;
begin
  bo29 := False;
  n1C := 1;

  //MainOutMessage(Format('ClientBuyItem：------ %d ------', [m_GoodsList.Count]));    //debug_lzx20200208

  for i := 0 to m_GoodsList.Count - 1 do
  begin
    if bo29 or (bo574) then Break;
    List20 := TList(m_GoodsList.Items[i]);
    //if List20.Count <= 0 then Continue;
    UserItem := List20.Items[0];

    StdItem := UserEngine.GetStdItem(UserItem.wIndex);

    if StdItem <> nil then
    begin
      //取自定义物品名称
      sUserItemName := GetItemName(UserItem);

      //MainOutMessage(Format('%d %s',[UserItem.wIndex-1,sUserItemName]));    //debug_lzx20200208

      if PlayObject.IsAddWeightAvailable(StdItem.Weight) then
      begin
        if sUserItemName = sItemName then
        begin
          for ii := 0 to List20.Count - 1 do
          begin
            UserItem := List20.Items[ii];
            if (StdItem.StdMode <= 4) or
              (StdItem.StdMode = 42) or
              (StdItem.StdMode = 31) or
              (UserItem.MakeIndex = nInt) then
            begin

              nPrice := GetUserPrice(PlayObject, GetUserItemPrice(UserItem));
              if (PlayObject.m_nGold >= nPrice) and (nPrice > 0) then
              begin
                if PlayObject.AddItemToBag(UserItem) then
                begin
                  Dec(PlayObject.m_nGold, nPrice);
                  if m_boCastle or g_Config.boGetAllNpcTax then
                  begin
                    if m_Castle <> nil then
                    begin
                      TUserCastle(m_Castle).IncRateGold(nPrice);
                    end else
                      if g_Config.boGetAllNpcTax then
                      begin
                        g_CastleManager.IncRateGold(g_Config.nUpgradeWeaponPrice);
                      end;
                  end;
                  {
                  if m_boCastle or g_Config.boGetAllNpcTax then
                    UserCastle.IncRateGold(nPrice);
                  }
                  PlayObject.SendAddItem(UserItem);
                  //004A25DC
                  if StdItem.NeedIdentify = 1 then
                    AddGameDataLog('9' + #9 +
                      PlayObject.m_sMapName + #9 +
                      IntToStr(PlayObject.m_nCurrX) + #9 +
                      IntToStr(PlayObject.m_nCurrY) + #9 +
                      PlayObject.m_sCharName + #9 +
                                 //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
                      StdItem.Name + #9 +
                      IntToStr(UserItem.MakeIndex) + #9 +
                      '1' + #9 +
                      m_sCharName);

                  List20.Delete(ii);
                  if List20.Count <= 0 then
                  begin
                    List20.Free;
                    m_GoodsList.Delete(i);
                  end;
                  n1C := 0;
                end else n1C := 2;
              end else n1C := 3;
              bo29 := True;
              Break;
            end;
          end;
        end;
      end else n1C := 2; //004A2639
    end;
  end; // for
  if n1C = 0 then
  begin
    PlayObject.SendMsg(Self, RM_BUYITEM_SUCCESS, 0, PlayObject.m_nGold, nInt, 0, '');
  end else
  begin
    PlayObject.SendMsg(Self, RM_BUYITEM_FAIL, 0, n1C, 0, 0, '');
  end;

end;

//获取商品列表
procedure TMerchant.ClientGetDetailGoodsList(PlayObject: TPlayObject; sItemName: string; nInt: Integer); //004A26F0
var
  i, ii, n18: Integer;
  List20: TList;
  UserItem: pTUserItem;
  Item: TItem;
  StdItem: TStdItem;
  ClientItem: TClientItem;
  OClientItem: TOClientItem;
  s1C: string;

begin
  if PlayObject.m_nSoftVersionDateEx = 0 then
  begin
    n18 := 0;
    for i := 0 to m_GoodsList.Count - 1 do
    begin
      List20 := TList(m_GoodsList.Items[i]);
    //if List20.Count <= 0 then Continue;
      UserItem := List20.Items[0];

      Item := UserEngine.GetStdItem(UserItem.wIndex);
      if (Item <> nil) and (Item.Name = sItemName) then
      begin
        if (List20.Count - 1) < nInt then
        begin
          nInt := _MAX(0, List20.Count - 10);
        end;
        for ii := List20.Count - 1 downto 0 do
        begin
          UserItem := List20.Items[ii];
          Item.GetStandardItem(StdItem);
          Item.GetItemAddValue(UserItem, StdItem);
          CopyStdItemToOStdItem(@StdItem, @OClientItem.s);

          OClientItem.Dura := UserItem.Dura;
          OClientItem.DuraMax := GetUserPrice(PlayObject, GetUserItemPrice(UserItem));
          OClientItem.MakeIndex := UserItem.MakeIndex;
          s1C := s1C + EncodeBuffer(@OClientItem, SizeOf(TOClientItem)) + '/';
          Inc(n18);
          if n18 >= 10 then Break;
        end;
        Break;
      end;
    end;
    PlayObject.SendMsg(Self, RM_SENDDETAILGOODSLIST, 0, Integer(Self), n18, nInt, s1C);
  end else
  begin
    n18 := 0;
    for i := 0 to m_GoodsList.Count - 1 do
    begin
      List20 := TList(m_GoodsList.Items[i]);
      if List20.Count <= 0 then Continue;
      UserItem := List20.Items[0];

      Item := UserEngine.GetStdItem(UserItem.wIndex);
      if (Item <> nil) and (Item.Name = sItemName) then
      begin
        if (List20.Count - 1) < nInt then
        begin
          nInt := _MAX(0, List20.Count - 10);
        end;
        for ii := List20.Count - 1 downto 0 do
        begin
          UserItem := List20.Items[ii];
          Item.GetStandardItem(ClientItem.s);
          Item.GetItemAddValue(UserItem, ClientItem.s);
          ClientItem.Dura := UserItem.Dura;
          ClientItem.DuraMax := GetUserPrice(PlayObject, GetUserItemPrice(UserItem));
          ClientItem.MakeIndex := UserItem.MakeIndex;
          s1C := s1C + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
          Inc(n18);
          if n18 >= 10 then Break;
        end;
        Break;
      end;
    end;
    PlayObject.SendMsg(Self, RM_SENDDETAILGOODSLIST, 0, Integer(Self), n18, nInt, s1C);
  end;
end;

procedure TMerchant.ClientQuerySellPrice(PlayObject: TPlayObject;
  UserItem: pTUserItem); //004A1B84
var
  nC: Integer;
begin
  nC := GetSellItemPrice(GetUserItemPrice(UserItem));
  if (nC >= 0) then
  begin
    PlayObject.SendMsg(Self, RM_SENDBUYPRICE, 0, nC, 0, 0, '');
  end else
  begin
    PlayObject.SendMsg(Self, RM_SENDBUYPRICE, 0, 0, 0, 0, '');
  end;
end;

function TMerchant.GetSellItemPrice(nPrice: Integer): Integer; //0049F7A4
begin
  Result := Round(nPrice / 2.0);
end;

//客户端销售物品
function TMerchant.ClientSellItem(PlayObject: TPlayObject; UserItem: pTUserItem): Boolean; //004A1CD8
  function sub_4A1C84(UserItem: pTUserItem): Boolean;
  var
    StdItem: TItem;
  begin
    Result := True;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    //25黄色药粉(少量) 5000, 30火把 20000
    if (StdItem <> nil) and ((StdItem.StdMode = 25) or (StdItem.StdMode = 30)) then
    begin
      if UserItem.Dura < 4000 then Result := False;   //Dura is durable
    end;
  end;
var
  nPrice: Integer;
  StdItem: TItem;

//  UserItem20: pTUserItem;   //debug_lzx20200208
//  RefillList20: TList;      //debug_lzx20200208
//  i: Integer;               //debug_lzx20200208

begin //004A1CD8
  Result := False;
  nPrice := GetSellItemPrice(GetUserItemPrice(UserItem));  //价格
  if (nPrice > 0) and (not bo574) and
    sub_4A1C84(UserItem) then
  begin
    if PlayObject.IncGold(nPrice) then
    begin
      {
      if m_boCastle or g_Config.boGetAllNpcTax then
        UserCastle.IncRateGold(nPrice);
      }


      if m_boCastle or g_Config.boGetAllNpcTax then
      begin
        if m_Castle <> nil then
        begin
          TUserCastle(m_Castle).IncRateGold(nPrice);
        end else
          if g_Config.boGetAllNpcTax then
          begin
            g_CastleManager.IncRateGold(g_Config.nUpgradeWeaponPrice);
          end;
      end;

       PlayObject.SendMsg(Self, RM_USERSELLITEM_OK, 0, PlayObject.m_nGold, 0, 0, '');
       AddItemToGoodsList(UserItem);

      //debug_lzx20200208
      {
        //---------------------------------------------------------
        MainOutMessage(Format('ClientSellItem: ---- m_GoodsList.Count: %d ------', [m_GoodsList.Count]));   //debug_lzx20200208

        for i := 0 to m_GoodsList.Count - 1 do           //debug_lzx20200208
        begin
          RefillList20 := TList(m_GoodsList.Items[i]);
          UserItem20 := RefillList20.Items[0];

          MainOutMessage(Format('%d  %s',[UserItem20.wIndex-1 ,UserEngine.GetStdItemName(UserItem20.wIndex)]));    //debug_lzx20200208
        end;

        //RefillGoods();    //调试用          debug_lzx20200208

       //---------------------------------------------------------
      }


      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      //004A1E95
      if StdItem.NeedIdentify = 1 then
        AddGameDataLog('10' + #9 +
          PlayObject.m_sMapName + #9 +
          IntToStr(PlayObject.m_nCurrX) + #9 +
          IntToStr(PlayObject.m_nCurrY) + #9 +
          PlayObject.m_sCharName + #9 +
                     //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
          StdItem.Name + #9 +
          IntToStr(UserItem.MakeIndex) + #9 +
          '1' + #9 +
          m_sCharName);

      Result := True;
    end else
    begin //004A1EA0
      PlayObject.SendMsg(Self, RM_USERSELLITEM_FAIL, 0, 0, 0, 0, '');
    end;
  end else
  begin
    PlayObject.SendMsg(Self, RM_USERSELLITEM_FAIL, 0, 0, 0, 0, '');
  end;

end;

//将销售的商品加入到商品列表中
//
//注意：该函原来的做有错误，当用户向NPC销售商品时，加入到商品列表的销售商品的信息会错误，并且出现负的价格(-1)，
//原因是程序代码中 ItemList.add(UserItem); 语句的做法有问题。
//
function TMerchant.AddItemToGoodsList(UserItem: pTUserItem): Boolean; //004A1BF8
var
  n10: Integer;
  ItemList: TList;

  SellItem: pTUserItem; //lzx add 2020/02/08
  sItemName: string;    //lzx add 2020/02/08

//  RefillList20: TList;  //debug_lzx20200208
//  i: Integer;           //debug_lzx20200208

begin
  Result := False;
  if UserItem.Dura <= 0 then Exit;

  //检查新加的商品是否为已经上架的商品
  ItemList := GetRefillList(UserItem.wIndex);   //获取重装满的商品列表
  if ItemList = nil then
  begin
    ItemList := TList.Create;
    m_GoodsList.Add(ItemList);    //在商品列表中加入商品名细
  end;

   //MainOutMessage(Format('------ AddItemToGoodsList :%d %s',[UserItem.wIndex-1,  GetItemName(UserItem)]));    //debug_lzx20200208

   //-----------------------------------------------------------
   //修正销售商品加信列表信息错误的问题
   //原来错误的做法
   //该语句直接向列表中增加函数传入的对象指针UserItem，这个指针指向和是客户背包上的物品，当交易成功后该物品会从人物背包中删除，
   //于是UserItem就变成了野指针，从而造成加入到商品列表的物品信息错误。正确的方法重新生成一个物品的实例对象，然后加入到商品列表中。
   //
   //  ItemList.add(UserItem);  //加入商品的错误问题所在！！！             //Modified by lzx 2020/02/08 

   //修正后的做法。注意：这里必需要New一个pTUserItem实例对象，然后复制入信息，才能入到ItemList列表中
   New(SellItem);
   sItemName := UserEngine.GetStdItemName(UserItem.wIndex);
   UserEngine.CopyToUserItemFromName(sItemName, SellItem);
   ItemList.add(SellItem);
   //-----------------------------------------------------------

  Result := True;
end;

procedure TMerchant.ClientMakeDrugItem(PlayObject: TPlayObject;
  sItemName: string); //004A2B6C
  function sub_4A28FC(PlayObject: TPlayObject; sItemName: string): Boolean; //004A28FC
  var
    i, ii, n1C: Integer;
    List10: TStringList;
    s20: string;
    List28: TStringList;
    UserItem: pTUserItem;
  begin
    Result := False;
    List10 := GetMakeItemInfo(sItemName);
    if List10 = nil then Exit;
    Result := True;
    for i := 0 to List10.Count - 1 do
    begin
      s20 := List10.Strings[i];
      n1C := Integer(List10.Objects[i]);
      for ii := 0 to PlayObject.m_ItemList.Count - 1 do
      begin
        if UserEngine.GetStdItemName(pTUserItem(PlayObject.m_ItemList.Items[ii]).wIndex) = s20 then
          Dec(n1C);
      end;
      if n1C > 0 then
      begin
        Result := False;
        Break;
      end;
    end; // for
    if Result then
    begin
      List28 := nil;
      for i := 0 to List10.Count - 1 do
      begin
        s20 := List10.Strings[i];
        n1C := Integer(List10.Objects[i]);
        for ii := PlayObject.m_ItemList.Count - 1 downto 0 do
        begin
          if n1C <= 0 then Break;
          UserItem := PlayObject.m_ItemList.Items[ii];
          if UserEngine.GetStdItemName(UserItem.wIndex) = s20 then
          begin
            if List28 = nil then List28 := TStringList.Create;
            List28.AddObject(s20, TObject(UserItem.MakeIndex));
            Dispose(UserItem);
            PlayObject.m_ItemList.Delete(ii);
            Dec(n1C);
          end;
        end;
      end;
      if List28 <> nil then
      begin
        PlayObject.SendMsg(Self, RM_SENDDELITEMLIST, 0, Integer(List28), 0, 0, '');
      end;
    end;
  end;
var
  i: Integer;
  List1C: TList;
  MakeItem, UserItem: pTUserItem;
  StdItem: TItem;
  n14: Integer;
begin
  n14 := 1;
  for i := 0 to m_GoodsList.Count - 1 do
  begin
    List1C := TList(m_GoodsList.Items[i]);
    //if List1C.Count <= 0 then Continue;
    MakeItem := List1C.Items[0];
    StdItem := UserEngine.GetStdItem(MakeItem.wIndex);
    if (StdItem <> nil) and (StdItem.Name = sItemName) then
    begin
      if PlayObject.m_nGold >= g_Config.nMakeDurgPrice then
      begin
        if sub_4A28FC(PlayObject, sItemName) then
        begin
          New(UserItem);
          UserEngine.CopyToUserItemFromName(sItemName, UserItem);
          if PlayObject.AddItemToBag(UserItem) then
          begin
            Dec(PlayObject.m_nGold, g_Config.nMakeDurgPrice);
            PlayObject.SendAddItem(UserItem);
            StdItem := UserEngine.GetStdItem(UserItem.wIndex);
            //004A2D89
            if StdItem.NeedIdentify = 1 then
              AddGameDataLog('2' + #9 +
                PlayObject.m_sMapName + #9 +
                IntToStr(PlayObject.m_nCurrX) + #9 +
                IntToStr(PlayObject.m_nCurrY) + #9 +
                PlayObject.m_sCharName + #9 +
                     //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
                StdItem.Name + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                '1' + #9 +
                m_sCharName);
            n14 := 0;
            Break;
          end else
          begin
            Dispose(UserItem);
            n14 := 2;
          end;
        end else n14 := 4;
      end else n14 := 3; //004A2DB4
    end;
  end; // for
  if n14 = 0 then
  begin
    PlayObject.SendMsg(Self, RM_MAKEDRUG_SUCCESS, 0, PlayObject.m_nGold, 0, 0, '');
  end else
  begin
    PlayObject.SendMsg(Self, RM_MAKEDRUG_FAIL, 0, n14, 0, 0, '');
  end;

end;

procedure TMerchant.ClientQueryRepairCost(PlayObject: TPlayObject;
  UserItem: pTUserItem); //004A1F30
var
  nPrice, nRepairPrice: Integer;
begin
  nPrice := GetUserPrice(PlayObject, GetUserItemPrice(UserItem));
  if (nPrice > 0) and (UserItem.DuraMax > UserItem.Dura) then
  begin
    if UserItem.DuraMax > 0 then
    begin
      nRepairPrice := Round(nPrice div 3 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura));
    end else
    begin
      nRepairPrice := nPrice;
    end;
    if (PlayObject.m_sScriptLable = sSUPERREPAIR) then
    begin
      if m_boS_repair then nRepairPrice := nRepairPrice * g_Config.nSuperRepairPriceRate {3}
      else nRepairPrice := -1;
    end else
    begin
      if not m_boRepair then nRepairPrice := -1;
    end;
    PlayObject.SendMsg(Self, RM_SENDREPAIRCOST, 0, nRepairPrice, 0, 0, '');
  end else
  begin
    PlayObject.SendMsg(Self, RM_SENDREPAIRCOST, 0, -1, 0, 0, '');
  end;
end;

function TMerchant.ClientRepairItem(PlayObject: TPlayObject;
  UserItem: pTUserItem): Boolean; //004A2024
var
  nPrice, nRepairPrice: Integer;
  StdItem: TItem;
  boCanRepair: Boolean;
begin
  Result := False;
  boCanRepair := True;
  if (PlayObject.m_sScriptLable = sSUPERREPAIR) and not m_boS_repair then
  begin
    boCanRepair := False;
  end;
  if (PlayObject.m_sScriptLable <> sSUPERREPAIR) and not m_boRepair then
  begin
    boCanRepair := False;
  end;
  if PlayObject.m_sScriptLable = '@fail_s_repair' then
  begin
    SendMsgToUser(PlayObject, 'Sorry, I cant special repair this item\ \ \<Main/@main>');
    PlayObject.SendMsg(Self, RM_USERREPAIRITEM_FAIL, 0, 0, 0, 0, '');
    Exit;
  end;
  nPrice := GetUserPrice(PlayObject, GetUserItemPrice(UserItem));
  if PlayObject.m_sScriptLable = sSUPERREPAIR then
  begin
    nPrice := nPrice * g_Config.nSuperRepairPriceRate {3};
  end;
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if StdItem <> nil then
  begin
    if boCanRepair and (nPrice > 0) and (UserItem.DuraMax > UserItem.Dura) and (StdItem.StdMode <> 43) then
    begin
      if UserItem.DuraMax > 0 then
      begin
        nRepairPrice := Round(nPrice div 3 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura));
      end else
      begin
        nRepairPrice := nPrice;
      end;
      if PlayObject.DecGold(nRepairPrice) then
      begin
//        if m_boCastle or g_Config.boGetAllNpcTax then UserCastle.IncRateGold(nRepairPrice);
        if m_boCastle or g_Config.boGetAllNpcTax then
        begin
          if m_Castle <> nil then
          begin
            TUserCastle(m_Castle).IncRateGold(nRepairPrice);
          end else
            if g_Config.boGetAllNpcTax then
            begin
              g_CastleManager.IncRateGold(g_Config.nUpgradeWeaponPrice);
            end;
        end;
        if PlayObject.m_sScriptLable = sSUPERREPAIR then
        begin
          UserItem.Dura := UserItem.DuraMax;
          PlayObject.SendMsg(Self, RM_USERREPAIRITEM_OK, 0, PlayObject.m_nGold, UserItem.Dura, UserItem.DuraMax, '');
          GotoLable(PlayObject, sSUPERREPAIROK, False);
        end else
        begin
          Dec(UserItem.DuraMax, (UserItem.DuraMax - UserItem.Dura) div g_Config.nRepairItemDecDura {30});
          UserItem.Dura := UserItem.DuraMax;
          PlayObject.SendMsg(Self, RM_USERREPAIRITEM_OK, 0, PlayObject.m_nGold, UserItem.Dura, UserItem.DuraMax, '');
          GotoLable(PlayObject, sREPAIROK, False);
        end;
        Result := True;
      end else PlayObject.SendMsg(Self, RM_USERREPAIRITEM_FAIL, 0, 0, 0, 0, ''); //004A2238
    end else PlayObject.SendMsg(Self, RM_USERREPAIRITEM_FAIL, 0, 0, 0, 0, ''); //004A2253
  end;

end;

procedure TMerchant.ClearScript;
begin
  m_boBuy := False;
  m_boSell := False;
  m_boMakeDrug := False;
  m_boPrices := False;
  m_boStorage := False;
  m_boGetback := False;
  m_boUpgradenow := False;
  m_boGetBackupgnow := False;
  m_boRepair := False;
  m_boS_repair := False;
  
//  m_boGetMarry := False;
//  m_boGetMaster := False;

  m_boUseItemName := False;
  inherited;
end;

procedure TMerchant.LoadUpgradeList; //004A006C
var
  i: Integer;
begin
  for i := 0 to m_UpgradeWeaponList.Count - 1 do
  begin
    Dispose(pTUpgradeInfo(m_UpgradeWeaponList.Items[i]));
  end; // for
  m_UpgradeWeaponList.Clear;
  try
    //FrmDB.LoadUpgradeWeaponRecord(m_sCharName,m_UpgradeWeaponList);
    FrmDB.LoadUpgradeWeaponRecord(m_sScript + '-' + m_sMapName, m_UpgradeWeaponList);
  except
    MainOutMessage('Failure in loading upgradinglist - ' + m_sCharName);
  end;
end;

procedure TMerchant.SendCustemMsg(PlayObject: TPlayObject; sMsg: string);
begin
  inherited;

end;

//清除临时文件，包括交易库存，价格表
procedure TMerchant.ClearData;
var
  i, ii: Integer;
  UserItem: pTUserItem;
  ItemList: TList;
  ItemPrice: pTItemPrice;
resourcestring
  sExceptionMsg = '[Exception] TMerchant::ClearData';
begin
  try
    for i := 0 to m_GoodsList.Count - 1 do
    begin
      ItemList := TList(m_GoodsList.Items[i]);
      for ii := 0 to ItemList.Count - 1 do
      begin
        UserItem := ItemList.Items[ii];
        Dispose(UserItem);
      end;
      ItemList.Free;
    end;
    m_GoodsList.Clear;
    for i := 0 to m_ItemPriceList.Count - 1 do
    begin
      ItemPrice := m_ItemPriceList.Items[i];
      Dispose(ItemPrice);
    end;
    m_ItemPriceList.Clear;
    SaveNPCData();
  except
    on E: Exception do
    begin
      MainOutMessage(sExceptionMsg);
      MainOutMessage(E.Message);
    end;
  end;
end;


procedure TMerchant.ChangeUseItemName(PlayObject: TPlayObject;
  sLabel, sItemName: string);
var
  sWhere: string;
  btWhere: Byte;
  UserItem: pTUserItem;
  nLabelLen: Integer;
  sMsg: string;
  sItemNewName: string;
  StdItem: pTStdItem;
begin
  if not PlayObject.m_boChangeItemNameFlag then
  begin
    Exit;
  end;
  PlayObject.m_boChangeItemNameFlag := False;

  sWhere := Copy(sLabel, Length(sUSEITEMNAME) + 1, Length(sLabel) - Length(sUSEITEMNAME));
  btWhere := Str_ToInt(sWhere, -1);
  if btWhere in [Low(THumanUseItems)..High(THumanUseItems)] then
  begin
    UserItem := @PlayObject.m_UseItems[btWhere];
    if UserItem.wIndex = 0 then
    begin
      sMsg := Format(g_sYourUseItemIsNul, [GetUseItemName(btWhere)]);
      PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, sMsg);
      Exit;
    end;

    if UserItem.btValue[13] = 1 then
    begin
      ItemUnit.DelCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
    end;

    if sItemName <> '' then
    begin
      ItemUnit.AddCustomItemName(UserItem.MakeIndex, UserItem.wIndex, sItemName);
      UserItem.btValue[13] := 1;
    end else
    begin
      ItemUnit.DelCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      UserItem.btValue[13] := 0;
    end;
    ItemUnit.SaveCustomItemName();
    PlayObject.SendMsg(PlayObject, RM_SENDUSEITEMS, 0, 0, 0, 0, '');
    PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '');
  end;
end;

{ TTrainer }

constructor TTrainer.Create; //004A385C
begin
  inherited;
  m_dw568 := GetTickCount();
  n56C := 0;
  n570 := 0;
end;

destructor TTrainer.Destroy;
begin

  inherited;
end;

function TTrainer.Operate(ProcessMsg: pTProcessMessage): Boolean; //004A38C4
begin
  Result := False;
  if (ProcessMsg.wIdent = RM_STRUCK) or (ProcessMsg.wIdent = RM_MAGSTRUCK) then
  begin
//  if (ProcessMsg.wIdent = RM_10101) or (ProcessMsg.wIdent = RM_MAGSTRUCK) then begin

    if (ProcessMsg.BaseObject = Self) { and (ProcessMsg.nParam3 <> 0)} then
    begin
      Inc(n56C, ProcessMsg.wParam);
      m_dw568 := GetTickCount();
      Inc(n570);

      //ProcessSayMsg('Destructive power is ' + IntToStr(ProcessMsg.wParam) + ', Average  is ' + IntToStr(n56C div n570));
      ProcessSayMsg('破坏力' + Format('%2d',[ProcessMsg.wParam]) + ', 平均值' + Format('%2d',[n56C div n570]));
    end;
  end;
  if ProcessMsg.wIdent = RM_MAGSTRUCK then
    Result := inherited Operate(ProcessMsg);
end;

procedure TTrainer.Run; //004A3A18
begin
  if n570 > 0 then
  begin
    if (GetTickCount - m_dw568) > 3 * 1000 then
    begin
        //ProcessSayMsg('Total destructive power is ' + IntToStr(n56C) + ', Average destructive power is ' + IntToStr(n56C div n570));
        ProcessSayMsg('总破坏力' + Format('%2d',[n56C]) + ', 平均破坏力' + Format('%2d',[n56C div n570]));
      n570 := 0;
      n56C := 0;
    end;
  end;
  inherited;
end;


{ TNormNpc }

procedure TNormNpc.ActionOfAddNameDateList(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  LoadList: TStringList;
  boFound: Boolean;
  sListFileName, sLineText, sHumName, sDate: string;
begin
  sListFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;
  LoadList := TStringList.Create;
  if FileExists(sListFileName) then
  begin
    try
      LoadList.LoadFromFile(sListFileName);
    except
      MainOutMessage('loading fail.... => ' + sListFileName);
    end;
  end;
  boFound := False;
  for i := 0 to LoadList.Count - 1 do
  begin
    sLineText := Trim(LoadList.Strings[i]);
    sLineText := GetValidStr3(sLineText, sHumName, [' ', #9]);
    sLineText := GetValidStr3(sLineText, sDate, [' ', #9]);
    if CompareText(sHumName, PlayObject.m_sCharName) = 0 then
    begin
      LoadList.Strings[i] := PlayObject.m_sCharName + #9 + DateToStr(Date);
      boFound := True;
      Break;
    end;
  end;
  if not boFound then
    LoadList.Add(PlayObject.m_sCharName + #9 + DateToStr(Date));

  try
    LoadList.SaveToFile(sListFileName);
  except
    MainOutMessage('saving fail.... => ' + sListFileName);
  end;
  LoadList.Free;
end;

procedure TNormNpc.ActionOfDelNameDateList(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  LoadList: TStringList;
  sLineText, sListFileName, sHumName, sDate: string;
  boFound: Boolean;
begin
  sListFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;
  LoadList := TStringList.Create;
  if FileExists(sListFileName) then
  begin
    try
      LoadList.LoadFromFile(sListFileName);
    except
      MainOutMessage('loading fail.... => ' + sListFileName);
    end;
  end;
  boFound := False;
  for i := 0 to LoadList.Count - 1 do
  begin
    sLineText := Trim(LoadList.Strings[i]);
    sLineText := GetValidStr3(sLineText, sHumName, [' ', #9]);
    sLineText := GetValidStr3(sLineText, sDate, [' ', #9]);
    if CompareText(sHumName, PlayObject.m_sCharName) = 0 then
    begin
      LoadList.Delete(i);
      boFound := True;
      Break;
    end;
  end;
  if boFound then
  begin
    try
      LoadList.SaveToFile(sListFileName);
    except
      MainOutMessage('saving fail.... => ' + sListFileName);
    end;
  end;
  LoadList.Free;
end;

procedure TNormNpc.ActionOfAddSkill(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  Magic: pTMagic;
  UserMagic: pTUserMagic;
  nLevel: Integer;
begin
  nLevel := _MIN(3, Str_ToInt(QuestActionInfo.sParam2, 0));
  Magic := UserEngine.FindMagic(QuestActionInfo.sParam1);
  if Magic <> nil then
  begin
    if not PlayObject.IsTrainingSkill(Magic.wMagicId) then
    begin
      New(UserMagic);
      UserMagic.MagicInfo := Magic;
      UserMagic.wMagIdx := Magic.wMagicId;
      UserMagic.btKey := 0;
      UserMagic.btLevel := nLevel;
      UserMagic.nTranPoint := 0;
      PlayObject.m_MagicList.Add(UserMagic);
      PlayObject.SendAddMagic(UserMagic);
      PlayObject.RecalcAbilitys();
      if g_Config.boShowScriptActionMsg then
      begin
        PlayObject.SysMsg(Magic.sMagicName + '练习成功。', c_Green, t_Hint);
      end;

    end;
  end else
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_ADDSKILL);
  end;


end;

procedure TNormNpc.ActionOfAutoAddGameGold(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo; nPoint, nTime: Integer);
var
  sMsg: string;
begin
  if CompareText(QuestActionInfo.sParam1, 'START') = 0 then
  begin
    if (nPoint > 0) and (nTime > 0) then
    begin
      PlayObject.m_nIncGameGold := nPoint;
      PlayObject.m_dwIncGameGoldTime := LongWord(nTime * 1000);
      PlayObject.m_dwIncGameGoldTick := GetTickCount();
      PlayObject.m_boIncGameGold := True;
      Exit;
    end;
  end;
  if CompareText(QuestActionInfo.sParam1, 'STOP') = 0 then
  begin
    PlayObject.m_boIncGameGold := False;
    Exit;
  end;
  ScriptActionError(PlayObject, '', QuestActionInfo, sSC_AUTOADDGAMEGOLD);
end;

//SETAUTOGETEXP 时间 点数 是否安全区 地图号
procedure TNormNpc.ActionOfAutoGetExp(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nTime, nPoint: Integer;
  boIsSafeZone: Boolean;
  sMap: string;
  Envir: TEnvirnoment;
begin
  Envir := nil;
  nTime := Str_ToInt(QuestActionInfo.sParam1, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  boIsSafeZone := QuestActionInfo.sParam3[1] = '1';
  sMap := QuestActionInfo.sParam4;
  if sMap <> '' then
  begin
    Envir := g_MapManager.FindMap(sMap);
  end;


  if (nTime <= 0) or (nPoint <= 0) or ((sMap <> '') and (Envir = nil)) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETAUTOGETEXP);
    Exit;
  end;
  PlayObject.m_boAutoGetExpInSafeZone := boIsSafeZone;
  PlayObject.m_AutoGetExpEnvir := Envir;
  PlayObject.m_nAutoGetExpTime := nTime * 1000;
  PlayObject.m_nAutoGetExpPoint := nPoint;
end;

procedure TNormNpc.ActionOfAutoSubGameGold(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo; nPoint, nTime: Integer);
var
  sMsg: string;
begin
  if CompareText(QuestActionInfo.sParam1, 'START') = 0 then
  begin
    if (nPoint > 0) and (nTime > 0) then
    begin
      PlayObject.m_nDecGameGold := nPoint;
      PlayObject.m_dwDecGameGoldTime := LongWord(nTime * 1000);
      PlayObject.m_dwDecGameGoldTick := 0;
      PlayObject.m_boDecGameGold := True;
      Exit;
    end;
  end;
  if CompareText(QuestActionInfo.sParam1, 'STOP') = 0 then
  begin
    PlayObject.m_boDecGameGold := False;
    Exit;
  end;
  ScriptActionError(PlayObject, '', QuestActionInfo, sSC_AUTOSUBGAMEGOLD);

end;

procedure TNormNpc.ActionOfChangeCreditPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  boChgOK: Boolean;
  nCreditPoint: Integer;
  nLv: Integer;
  nOldLevel: Integer;
  cMethod: Char;
  dwInt: LongWord;
begin
  boChgOK := False;
  nCreditPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nCreditPoint < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CREDITPOINT);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if nCreditPoint >= 0 then
        begin
          if nCreditPoint > High(Byte) then
          begin
            PlayObject.m_btCreditPoint := High(Byte);
          end else
          begin
            PlayObject.m_btCreditPoint := nCreditPoint;
          end;
        end;
      end;
    '-':
      begin
        if PlayObject.m_btCreditPoint > Byte(nCreditPoint) then
        begin
          Dec(PlayObject.m_btCreditPoint, Byte(nCreditPoint));
        end else
        begin
          PlayObject.m_btCreditPoint := 0;
        end;
      end;
    '+':
      begin
        if PlayObject.m_btCreditPoint + Byte(nCreditPoint) > High(Byte) then
        begin
          PlayObject.m_btCreditPoint := High(Byte);
        end else
        begin
          Inc(PlayObject.m_btCreditPoint, Byte(nCreditPoint));
        end;
      end;
  else
    begin
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CREDITPOINT);
      Exit;
    end;
  end;
end;

procedure TNormNpc.ActionOfChangeExp(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  boChgOK: Boolean;
  nExp: Integer;
  nLv: Integer;
  nOldLevel: Integer;
  cMethod: Char;
  dwInt: LongWord;
begin
  boChgOK := False;
  nExp := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nExp < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEEXP);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if nExp >= 0 then
        begin
          PlayObject.m_Abil.Exp := LongWord(nExp);
          dwInt := LongWord(nExp);
        end;
      end;
    '-':
      begin
        if PlayObject.m_Abil.Exp > LongWord(nExp) then
        begin
          Dec(PlayObject.m_Abil.Exp, LongWord(nExp));
        end else
        begin
          PlayObject.m_Abil.Exp := 0;
        end;
      end;
    '+':
      begin
        if PlayObject.m_Abil.Exp >= LongWord(nExp) then
        begin
          if (PlayObject.m_Abil.Exp - LongWord(nExp)) > (High(LongWord) - PlayObject.m_Abil.Exp) then
          begin
            dwInt := High(LongWord) - PlayObject.m_Abil.Exp;
          end else
          begin
            dwInt := LongWord(nExp);
          end;
        end else
        begin
          if (LongWord(nExp) - PlayObject.m_Abil.Exp) > (High(LongWord) - LongWord(nExp)) then
          begin
            dwInt := High(LongWord) - LongWord(nExp);
          end else
          begin
            dwInt := LongWord(nExp);
          end;
        end;
        Inc(PlayObject.m_Abil.Exp, dwInt);
      //PlayObject.GetExp(dwInt);
        PlayObject.SendMsg(PlayObject, RM_WINEXP, 0, dwInt, 0, 0, '');
      end;
  end;

end;

procedure TNormNpc.ActionOfChangeHairStyle(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nHair: Integer;
begin
  nHair := Str_ToInt(QuestActionInfo.sParam1, -1);
  if (QuestActionInfo.sParam1 <> '') and (nHair >= 0) then
  begin
    PlayObject.m_btHair := nHair;
    PlayObject.FeatureChanged;
  end else
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_HAIRSTYLE);
  end;
end;

procedure TNormNpc.ActionOfChangeJob(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nJob: Integer;
begin
  nJob := -1;
  if CompareLStr(QuestActionInfo.sParam1, sWarrior, Length(sWarrior)) then nJob := jWarr;
  if CompareLStr(QuestActionInfo.sParam1, sWizard, Length(sWizard)) then nJob := jWizard;
  if CompareLStr(QuestActionInfo.sParam1, sTaos, Length(sTaos)) then nJob := jTaos;

  if nJob < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEJOB);
    Exit;
  end;

  if PlayObject.m_btJob <> nJob then
  begin
    PlayObject.m_btJob := nJob;
    {
    PlayObject.RecalcLevelAbilitys();
    PlayObject.RecalcAbilitys();
    }
    PlayObject.HasLevelUp(0);
  end;
end;

procedure TNormNpc.ActionOfChangeLevel(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  boChgOK: Boolean;
  nLevel: Integer;
  nLv: Integer;
  nOldLevel: Integer;
  cMethod: Char;
begin
  boChgOK := False;
  nOldLevel := PlayObject.m_Abil.Level;
  nLevel := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGELEVEL);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if (nLevel > 0) and (nLevel <= MAXLEVEL) then
        begin
          PlayObject.m_Abil.Level := nLevel;
          boChgOK := True;
        end;
      end;
    '-':
      begin
        nLv := _MAX(0, PlayObject.m_Abil.Level - nLevel);
        nLv := _MIN(MAXLEVEL, nLv);
        PlayObject.m_Abil.Level := nLv;
        boChgOK := True;
      end;
    '+':
      begin
        nLv := _MAX(0, PlayObject.m_Abil.Level + nLevel);
        nLv := _MIN(MAXLEVEL, nLv);
        PlayObject.m_Abil.Level := nLv;
        boChgOK := True;
      end;
  end;
  if boChgOK then
    PlayObject.HasLevelUp(nOldLevel);

end;

procedure TNormNpc.ActionOfChangePkPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nPKPOINT: Integer;
  nPoint: Integer;
  nOldPKLevel: Integer;
  cMethod: Char;
begin
  nOldPKLevel := PlayObject.PKLevel;
  nPKPOINT := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nPKPOINT < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEPKPOINT);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if (nPKPOINT >= 0) then
        begin
          PlayObject.m_nPkPoint := nPKPOINT;
        end;
      end;
    '-':
      begin
        nPoint := _MAX(0, PlayObject.m_nPkPoint - nPKPOINT);
        PlayObject.m_nPkPoint := nPoint;
      end;
    '+':
      begin
        nPoint := _MAX(0, PlayObject.m_nPkPoint + nPKPOINT);
        PlayObject.m_nPkPoint := nPoint;
      end;
  end;
  if nOldPKLevel <> PlayObject.PKLevel then
    PlayObject.RefNameColor;
end;

procedure TNormNpc.ActionOfClearMapMon(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  MonList: TList;
  mon: TBaseObject;
  ii: Integer;
begin
  MonList := TList.Create;
  UserEngine.GetMapMonster(g_MapManager.FindMap(QuestActionInfo.sParam1), MonList);
  for ii := 0 to MonList.Count - 1 do
  begin
    mon := TBaseObject(MonList.Items[ii]);
    if mon.m_Master <> nil then Continue;
    if GetNoClearMonList(mon.m_sCharName) then Continue;

    mon.m_boNoItem := True;
    mon.MakeGhost;
  end;
  MonList.Free;
end;

procedure TNormNpc.ActionOfClearNameList(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  LoadList: TStringList;
  sListFileName: string;
begin
  sListFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;
  LoadList := TStringList.Create;
  {
  if FileExists(sListFileName) then begin
    try
      LoadList.LoadFromFile(sListFileName);
    except
      MainOutMessage('loading fail.... => ' + sListFileName);
    end;
  end;
  }
  LoadList.Clear;
  try
    LoadList.SaveToFile(sListFileName);
  except
    MainOutMessage('saving fail.... => ' + sListFileName);
  end;
  LoadList.Free;
end;

procedure TNormNpc.ActionOfClearSkill(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  UserMagic: pTUserMagic;
begin
  for i := PlayObject.m_MagicList.Count - 1 downto 0 do
  begin
    UserMagic := PlayObject.m_MagicList.Items[i];
    PlayObject.SendDelMagic(UserMagic);
    Dispose(UserMagic);
    PlayObject.m_MagicList.Delete(i);
  end;
  PlayObject.RecalcAbilitys();
end;

procedure TNormNpc.ActionOfDelNoJobSkill(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  UserMagic: pTUserMagic;
begin
  for i := PlayObject.m_MagicList.Count - 1 downto 0 do
  begin
    UserMagic := PlayObject.m_MagicList.Items[i];
    if UserMagic.MagicInfo.btJob <> PlayObject.m_btJob then
    begin
      PlayObject.SendDelMagic(UserMagic);
      Dispose(UserMagic);
      PlayObject.m_MagicList.Delete(i);
    end;
  end;
end;

procedure TNormNpc.ActionOfDelSkill(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sMagicName: string;
  Magic: pTMagic;
  UserMagic: pTUserMagic;
begin
  sMagicName := QuestActionInfo.sParam1;
  Magic := UserEngine.FindMagic(sMagicName);
  if Magic = nil then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_DELSKILL);
    Exit;
  end;
  for i := 0 to PlayObject.m_MagicList.Count - 1 do
  begin
    UserMagic := PlayObject.m_MagicList.Items[i];
    if UserMagic.MagicInfo = Magic then
    begin
      PlayObject.m_MagicList.Delete(i);
      PlayObject.SendDelMagic(UserMagic);
      Dispose(UserMagic);
      PlayObject.RecalcAbilitys();
      Break;
    end;
  end;

end;

procedure TNormNpc.ActionOfGameGold(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nGameGold: Integer;
  nOldGameGold: Integer;
  cMethod: Char;
begin
  nOldGameGold := PlayObject.m_nGameGold;
  nGameGold := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nGameGold < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GAMEGOLD);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if (nGameGold >= 0) then
        begin
          PlayObject.m_nGameGold := nGameGold;
        end;
      end;
    '-':
      begin
        nGameGold := _MAX(0, PlayObject.m_nGameGold - nGameGold);
        PlayObject.m_nGameGold := nGameGold;
      end;
    '+':
      begin
        nGameGold := _MAX(0, PlayObject.m_nGameGold + nGameGold);
        PlayObject.m_nGameGold := nGameGold;
      end;
  end;
  //'%d'#9'%s'#9'%d'#9'%d'#9'%s'#9'%s'#9'%d'#9'%s'#9'%s'
  if g_boGameLogGameGold then
  begin
    AddGameDataLog(Format(g_sGameLogMsg1, [LOG_GAMEGOLD,
      PlayObject.m_sMapName,
        PlayObject.m_nCurrX,
        PlayObject.m_nCurrY,
        PlayObject.m_sCharName,
        g_Config.sGameGoldName,
        nGameGold,
        cMethod,
        m_sCharName]));
  end;
  if nOldGameGold <> PlayObject.m_nGameGold then
    PlayObject.GameGoldChanged;
end;

procedure TNormNpc.ActionOfGamePoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nGamePoint: Integer;
  nOldGamePoint: Integer;
  cMethod: Char;
begin
  nOldGamePoint := PlayObject.m_nGamePoint;
  nGamePoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nGamePoint < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GAMEPOINT);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        if (nGamePoint >= 0) then
        begin
          PlayObject.m_nGamePoint := nGamePoint;
        end;
      end;
    '-':
      begin
        nGamePoint := _MAX(0, PlayObject.m_nGamePoint - nGamePoint);
        PlayObject.m_nGamePoint := nGamePoint;
      end;
    '+':
      begin
        nGamePoint := _MAX(0, PlayObject.m_nGamePoint + nGamePoint);
        PlayObject.m_nGamePoint := nGamePoint;
      end;
  end;
  //'%d'#9'%s'#9'%d'#9'%d'#9'%s'#9'%s'#9'%d'#9'%s'#9'%s'
  if g_boGameLogGamePoint then
  begin
    AddGameDataLog(Format(g_sGameLogMsg1, [LOG_GAMEPOINT,
      PlayObject.m_sMapName,
        PlayObject.m_nCurrX,
        PlayObject.m_nCurrY,
        PlayObject.m_sCharName,
        g_Config.sGamePointName,
        nGamePoint,
        cMethod,
        m_sCharName]));
  end;
  if nOldGamePoint <> PlayObject.m_nGamePoint then
    PlayObject.GameGoldChanged;
end;

procedure TNormNpc.ActionOfLineMsg(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  sMsg: string;
begin
  sMsg := GetLineVariableText(PlayObject, QuestActionInfo.sParam2);
  sMsg := AnsiReplaceText(sMsg, '%s', PlayObject.m_sCharName);
  sMsg := AnsiReplaceText(sMsg, '%d', m_sCharName);
  case QuestActionInfo.nParam1 of
    0: UserEngine.SendBroadCastMsg(sMsg, t_System);
    1: UserEngine.SendBroadCastMsg('(*) ' + sMsg, t_System);
    2: UserEngine.SendBroadCastMsg('[' + m_sCharName + ']' + sMsg, t_System);
    3: UserEngine.SendBroadCastMsg('[' + PlayObject.m_sCharName + ']' + sMsg, t_System);
    4: ProcessSayMsg(sMsg);
    5: PlayObject.SysMsg(sMsg, c_Red, t_Say);
    6: PlayObject.SysMsg(sMsg, c_Green, t_Say);
    7: PlayObject.SysMsg(sMsg, c_Blue, t_Say);
    8: PlayObject.SendGroupText(sMsg);
    9:
      begin
        if PlayObject.m_MyGuild <> nil then
        begin
          TGUild(PlayObject.m_MyGuild).SendGuildMsg(sMsg);
          UserEngine.SendServerGroupMsg(SS_208, nServerIndex, TGUild(PlayObject.m_MyGuild).sGuildName + '/' + PlayObject.m_sCharName + '/' + sMsg);
        end;
      end;
  else
    begin
      ScriptActionError(PlayObject, '', QuestActionInfo, sSENDMSG);
    end;
  end;
end;

procedure TNormNpc.ActionOfMapTing(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin

end;


//取消 师徒 和 结婚系统 的相关功能
{
procedure TMerchant.GetMarry(PlayObject: TPlayObject; sDearName: string);
var
  MarryHuman: TPlayObject;
begin
  MarryHuman := UserEngine.GetPlayObject(sDearName);
  if (MarryHuman <> nil) and
    (MarryHuman.m_PEnvir = PlayObject.m_PEnvir) and
    (abs(PlayObject.m_nCurrX - MarryHuman.m_nCurrX) < 5) and
    (abs(PlayObject.m_nCurrY - MarryHuman.m_nCurrY) < 5) then
  begin
    SendMsgToUser(MarryHuman, PlayObject.m_sCharName + ' 向你求婚，你是否愿意嫁给他为妻？');
  end else
  begin
    Self.SendMsgToUser(PlayObject, sDearName + ' 没有在你身边，你的请求无效！！！');
  end;

end;

procedure TMerchant.GetMaster(PlayObject: TPlayObject; sMasterName: string);
begin

end;
}


//取消 结婚 和 师徒 功能
{


procedure TNormNpc.ActionOfMarry(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  PoseHuman: TPlayObject;
  sSayMsg: string;
begin
  if PlayObject.m_sDearName <> '' then Exit;
  PoseHuman := TPlayObject(PlayObject.GetPoseCreate());
  if PoseHuman = nil then
  begin
    GotoLable(PlayObject, '@MarryCheckDir', False);
    Exit;
  end;
  if QuestActionInfo.sParam1 = '' then
  begin
    if PoseHuman.m_btRaceServer <> RC_PLAYOBJECT then
    begin
      GotoLable(PlayObject, '@HumanTypeErr', False);
      Exit;
    end;
    if PoseHuman.GetPoseCreate = PlayObject then
    begin
      if PlayObject.m_btGender <> PoseHuman.m_btGender then
      begin
        GotoLable(PlayObject, '@StartMarry', False);
        GotoLable(PoseHuman, '@StartMarry', False);
        if (PlayObject.m_btGender = gMan) and (PoseHuman.m_btGender = gWoMan) then
        begin
          sSayMsg := AnsiReplaceText(g_sStartMarryManMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          sSayMsg := AnsiReplaceText(g_sStartMarryManAskQuestionMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        end else if (PlayObject.m_btGender = gWoMan) and (PoseHuman.m_btGender = gMan) then
        begin
          sSayMsg := AnsiReplaceText(g_sStartMarryWoManMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          sSayMsg := AnsiReplaceText(g_sStartMarryWoManAskQuestionMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        end;
        PlayObject.m_boStartMarry := True;
        PoseHuman.m_boStartMarry := True;
      end else
      begin
        GotoLable(PoseHuman, '@MarrySexErr', False);
        GotoLable(PlayObject, '@MarrySexErr', False);
      end;
    end else
    begin
      GotoLable(PlayObject, '@MarryDirErr', False);
      GotoLable(PoseHuman, '@MarryCheckDir', False);
    end;
    Exit;
  end;
  if CompareText(QuestActionInfo.sParam1, 'REQUESTMARRY') = 0 then   //sREQUESTMARRY
  begin
    if PlayObject.m_boStartMarry and PoseHuman.m_boStartMarry then
    begin
      if (PlayObject.m_btGender = gMan) and (PoseHuman.m_btGender = gWoMan) then
      begin
        sSayMsg := AnsiReplaceText(g_sMarryManAnswerQuestionMsg, '%n', m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
        UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        sSayMsg := AnsiReplaceText(g_sMarryManAskQuestionMsg, '%n', m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
        UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        GotoLable(PlayObject, '@WateMarry', False);
        GotoLable(PoseHuman, '@RevMarry', False);
      end;
    end;
    Exit;
  end;
  if CompareText(QuestActionInfo.sParam1, 'RESPONSEMARRY' ) = 0 then   //sRESPONSEMARRY
  begin
    if (PlayObject.m_btGender = gWoMan) and (PoseHuman.m_btGender = gMan) then
    begin
      if CompareText(QuestActionInfo.sParam2, 'OK') = 0 then
      begin
        if PlayObject.m_boStartMarry and PoseHuman.m_boStartMarry then
        begin
          sSayMsg := AnsiReplaceText(g_sMarryWoManAnswerQuestionMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          sSayMsg := AnsiReplaceText(g_sMarryWoManGetMarryMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          GotoLable(PlayObject, '@EndMarry', False);
          GotoLable(PoseHuman, '@EndMarry', False);
          PlayObject.m_boStartMarry := False;
          PoseHuman.m_boStartMarry := False;
          PlayObject.m_sDearName := PoseHuman.m_sCharName;
          PlayObject.m_DearHuman := PoseHuman;
          PoseHuman.m_sDearName := PlayObject.m_sCharName;
          PoseHuman.m_DearHuman := PlayObject;
          PlayObject.RefShowName;
          PoseHuman.RefShowName;
        end;
      end else
      begin
        if PlayObject.m_boStartMarry and PoseHuman.m_boStartMarry then
        begin
          GotoLable(PlayObject, '@EndMarryFail', False);
          GotoLable(PoseHuman, '@EndMarryFail', False);
          PlayObject.m_boStartMarry := False;
          PoseHuman.m_boStartMarry := False;
          sSayMsg := AnsiReplaceText(g_sMarryWoManDenyMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          sSayMsg := AnsiReplaceText(g_sMarryWoManCancelMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        end;
      end;
    end;
    Exit;
  end;
end;
procedure TNormNpc.ActionOfMaster(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  PoseHuman: TPlayObject;
  sSayMsg: string;
begin
  if PlayObject.m_sMasterName <> '' then Exit;
  PoseHuman := TPlayObject(PlayObject.GetPoseCreate());
  if PoseHuman = nil then
  begin
    GotoLable(PlayObject, '@MasterCheckDir', False);
    Exit;
  end;
  if QuestActionInfo.sParam1 = '' then
  begin
    if PoseHuman.m_btRaceServer <> RC_PLAYOBJECT then
    begin
      GotoLable(PlayObject, '@HumanTypeErr', False);
      Exit;
    end;
    if PoseHuman.GetPoseCreate = PlayObject then
    begin
      GotoLable(PlayObject, '@StartGetMaster', False);
      GotoLable(PoseHuman, '@StartMaster', False);
      PlayObject.m_boStartMaster := True;
      PoseHuman.m_boStartMaster := True;
    end else
    begin
      GotoLable(PlayObject, '@MasterDirErr', False);
      GotoLable(PoseHuman, '@MasterCheckDir', False);
    end;
    Exit;
  end;
  if CompareText(QuestActionInfo.sParam1, 'REQUESTMASTER') = 0 then
  begin
    if PlayObject.m_boStartMaster and PoseHuman.m_boStartMaster then
    begin
      PlayObject.m_PoseBaseObject := PoseHuman;
      PoseHuman.m_PoseBaseObject := PlayObject;
      GotoLable(PlayObject, '@WateMaster', False);
      GotoLable(PoseHuman, '@RevMaster', False);
    end;
    Exit;
  end;
  if CompareText(QuestActionInfo.sParam1, 'RESPONSEMASTER') = 0 then
  begin
    if CompareText(QuestActionInfo.sParam2, 'OK') = 0 then
    begin
      if (PlayObject.m_PoseBaseObject = PoseHuman) and (PoseHuman.m_PoseBaseObject = PlayObject) then
      begin
        if PlayObject.m_boStartMaster and PoseHuman.m_boStartMaster then
        begin
          GotoLable(PlayObject, '@EndMaster', False);
          GotoLable(PoseHuman, '@EndMaster', False);
          PlayObject.m_boStartMaster := False;
          PoseHuman.m_boStartMaster := False;
          if PlayObject.m_sMasterName = '' then
          begin
            PlayObject.m_sMasterName := PoseHuman.m_sCharName;
            PlayObject.m_boMaster := True;
          end;
          PlayObject.m_MasterList.Add(PoseHuman);
          PoseHuman.m_sMasterName := PlayObject.m_sCharName;
          PoseHuman.m_boMaster := False;
          PlayObject.RefShowName;
          PoseHuman.RefShowName;
        end;
      end;
    end else
    begin
      if PlayObject.m_boStartMaster and PoseHuman.m_boStartMaster then
      begin
        GotoLable(PlayObject, '@EndMasterFail', False);
        GotoLable(PoseHuman, '@EndMasterFail', False);
        PlayObject.m_boStartMaster := False;
        PoseHuman.m_boStartMaster := False;
      end;
    end;
    Exit;
  end;

end;

}

//取消 师徒和 结婚 的相关功能
{
procedure TNormNpc.ActionOfUnMarry(PlayObject: TPlayObject;    //离婚
  QuestActionInfo: pTQuestActionInfo);
var
  PoseHuman: TPlayObject;
  LoadList: TStringList;
  sUnMarryFileName: string;
begin
  if PlayObject.m_sDearName = '' then
  begin
    GotoLable(PlayObject, '@ExeMarryFail', False);
    Exit;
  end;
  PoseHuman := TPlayObject(PlayObject.GetPoseCreate);
  if PoseHuman = nil then
  begin
    GotoLable(PlayObject, '@UnMarryCheckDir', False);
  end;
  if PoseHuman <> nil then
  begin
    if QuestActionInfo.sParam1 = '' then
    begin
      if PoseHuman.m_btRaceServer <> RC_PLAYOBJECT then
      begin
        GotoLable(PlayObject, '@UnMarryTypeErr', False);
        Exit;
      end;
      if PoseHuman.GetPoseCreate = PlayObject then
      begin
        if (PlayObject.m_sDearName = PoseHuman.m_sCharName)  then   // and (PosHum.AddInfo.sDearName = Hum.sName)
        begin
          GotoLable(PlayObject, '@StartUnMarry', False);
          GotoLable(PoseHuman, '@StartUnMarry', False);
          Exit;
        end;
      end;
    end;
  end;
  if (CompareText(QuestActionInfo.sParam1, 'REQUESTUNMARRY' ) = 0) then  //sREQUESTUNMARRY
  begin
    if (QuestActionInfo.sParam2 = '') then
    begin
      if PoseHuman <> nil then
      begin
        PlayObject.m_boStartUnMarry := True;
        if PlayObject.m_boStartUnMarry and PoseHuman.m_boStartUnMarry then
        begin
          UserEngine.SendBroadCastMsg('[' + m_sCharName + ']: ' + '我宣布' + PoseHuman.m_sCharName + ' ' + '与' + PlayObject.m_sCharName + ' ' + ' ' + '正式脱离夫妻关系。' , t_Say);
          PlayObject.m_sDearName := '';
          PoseHuman.m_sDearName := '';
          Inc(PlayObject.m_btMarryCount);
          Inc(PoseHuman.m_btMarryCount);
          PlayObject.m_boStartUnMarry := False;
          PoseHuman.m_boStartUnMarry := False;
          PlayObject.RefShowName;
          PoseHuman.RefShowName;
          GotoLable(PlayObject, '@UnMarryEnd', False);
          GotoLable(PoseHuman, '@UnMarryEnd', False);
        end else
        begin
          GotoLable(PlayObject, '@WateUnMarry', False);
//          GotoLable(PoseHuman,'@RevUnMarry',False);
        end;
      end;
      Exit;
    end else
    begin
      //强行离婚
      if (CompareText(QuestActionInfo.sParam2, 'FORCE') = 0) then
      begin
        UserEngine.SendBroadCastMsg('[' + m_sCharName + ']: ' + '我宣布'  + PlayObject.m_sCharName + ' ' + '与'  + PlayObject.m_sDearName + ' ' + ' ' + '已经正式脱离夫妻关系！！！' , t_Say);
        PoseHuman := UserEngine.GetPlayObject(PlayObject.m_sDearName);
        if PoseHuman <> nil then
        begin
          PoseHuman.m_sDearName := '';
          Inc(PoseHuman.m_btMarryCount);
          PoseHuman.RefShowName;
        end else
        begin
          sUnMarryFileName := g_Config.sEnvirDir + 'UnMarry.txt';
          LoadList := TStringList.Create;
          if FileExists(sUnMarryFileName) then
          begin
            LoadList.LoadFromFile(sUnMarryFileName);
          end;
          LoadList.Add(PlayObject.m_sDearName);
          LoadList.SaveToFile(sUnMarryFileName);
          LoadList.Free;
        end;
        PlayObject.m_sDearName := '';
        Inc(PlayObject.m_btMarryCount);
        GotoLable(PlayObject, '@UnMarryEnd', False);
        PlayObject.RefShowName;
      end;
      Exit;
    end;
  end;
end;


procedure TNormNpc.ActionOfUnMaster(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  PoseHuman: TPlayObject;
  LoadList: TStringList;
  sUnMarryFileName: string;
  sMsg: string;
begin
  if PlayObject.m_sMasterName = '' then
  begin
    GotoLable(PlayObject, '@ExeMasterFail', False);
    Exit;
  end;
  PoseHuman := TPlayObject(PlayObject.GetPoseCreate);
  if PoseHuman = nil then
  begin
    GotoLable(PlayObject, '@UnMasterCheckDir', False);
  end;
  if PoseHuman <> nil then
  begin
    if QuestActionInfo.sParam1 = '' then
    begin
      if PoseHuman.m_btRaceServer <> RC_PLAYOBJECT then
      begin
        GotoLable(PlayObject, '@UnMasterTypeErr', False);
        Exit;
      end;
      if PoseHuman.GetPoseCreate = PlayObject then
      begin
        if (PlayObject.m_sMasterName = PoseHuman.m_sCharName) then
        begin
          if PlayObject.m_boMaster then
          begin
            GotoLable(PlayObject, '@UnIsMaster', False);
            Exit;
          end;
          if PlayObject.m_sMasterName <> PoseHuman.m_sCharName then
          begin
            GotoLable(PlayObject, '@UnMasterError', False);
            Exit;
          end;

          GotoLable(PlayObject, '@StartUnMaster', False);
          GotoLable(PoseHuman, '@WateUnMaster', False);
          Exit;
        end;
      end;
    end;
  end;
  if (CompareText(QuestActionInfo.sParam1, 'REQUESTUNMASTER' ) = 0) then   //sREQUESTUNMARRY
  begin
    if (QuestActionInfo.sParam2 = '') then
    begin
      if PoseHuman <> nil then
      begin
        PlayObject.m_boStartUnMaster := True;
        if PlayObject.m_boStartUnMaster and PoseHuman.m_boStartUnMaster then
        begin
          sMsg := AnsiReplaceText(g_sNPCSayUnMasterOKMsg, '%n', m_sCharName);
          sMsg := AnsiReplaceText(sMsg, '%s', PlayObject.m_sCharName);
          sMsg := AnsiReplaceText(sMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sMsg, t_Say);
          PlayObject.m_sMasterName := '';
          PoseHuman.m_sMasterName := '';
          PlayObject.m_boStartUnMaster := False;
          PoseHuman.m_boStartUnMaster := False;
          PlayObject.RefShowName;
          PoseHuman.RefShowName;
          GotoLable(PlayObject, '@UnMasterEnd', False);
          GotoLable(PoseHuman, '@UnMasterEnd', False);
        end else
        begin
          GotoLable(PlayObject, '@WateUnMaster', False);
          GotoLable(PoseHuman, '@RevUnMaster', False);
        end;
      end;
      Exit;
    end else
    begin
      //强行出师
      if (CompareText(QuestActionInfo.sParam2, 'FORCE') = 0) then
      begin
        sMsg := AnsiReplaceText(g_sNPCSayForceUnMasterMsg, '%n', m_sCharName);
        sMsg := AnsiReplaceText(sMsg, '%s', PlayObject.m_sCharName);
        sMsg := AnsiReplaceText(sMsg, '%d', PlayObject.m_sMasterName);
        UserEngine.SendBroadCastMsg(sMsg, t_Say);

        PoseHuman := UserEngine.GetPlayObject(PlayObject.m_sMasterName);
        if PoseHuman <> nil then
        begin
          PoseHuman.m_sMasterName := '';
          PoseHuman.RefShowName;
        end else
        begin
          g_UnForceMasterList.Lock;
          try
            g_UnForceMasterList.Add(PlayObject.m_sMasterName);
            SaveUnForceMasterList();
          finally
            g_UnForceMasterList.UnLock;
          end;
        end;
        PlayObject.m_sMasterName := '';
        GotoLable(PlayObject, '@UnMasterEnd', False);
        PlayObject.RefShowName;
      end;
      Exit;
    end;
  end;
end;


procedure TNormNpc.ActionOfGetMarry(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  PoseBaseObject: TBaseObject;
begin
  PoseBaseObject := PlayObject.GetPoseCreate();
  if (PoseBaseObject <> nil) and (PoseBaseObject.m_btRaceServer = RC_PLAYOBJECT) and (PoseBaseObject.m_btGender <> PlayObject.m_btGender) then
  begin
    PlayObject.m_sDearName := PoseBaseObject.m_sCharName;
    PlayObject.RefShowName;
    PoseBaseObject.RefShowName;
  end else
  begin
    GotoLable(PlayObject, '@MarryError', False);
  end;
end;

procedure TNormNpc.ActionOfGetMaster(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  PoseBaseObject: TBaseObject;
begin
  PoseBaseObject := PlayObject.GetPoseCreate();
  if (PoseBaseObject <> nil) and (PoseBaseObject.m_btRaceServer = RC_PLAYOBJECT) and (PoseBaseObject.m_btGender <> PlayObject.m_btGender) then
  begin
    PlayObject.m_sMasterName := PoseBaseObject.m_sCharName;
    PlayObject.RefShowName;
    PoseBaseObject.RefShowName;
  end else
  begin
    GotoLable(PlayObject, '@MasterError', False);
  end;
end;

procedure TNormNpc.ActionOfDelMarry(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.m_sDearName := '';
  PlayObject.RefShowName;
end;

procedure TNormNpc.ActionOfDelMaster(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.m_sMasterName := '';
  PlayObject.RefShowName;
end;


}

procedure TNormNpc.ActionOfMessageBox(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, GetLineVariableText(PlayObject, QuestActionInfo.sParam1));
end;

procedure TNormNpc.ActionOfMission(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  if (QuestActionInfo.sParam1 <> '') and (QuestActionInfo.nParam2 > 0) and (QuestActionInfo.nParam3 > 0) then
  begin
    g_sMissionMap := QuestActionInfo.sParam1;
    g_nMissionX := QuestActionInfo.nParam2;
    g_nMissionY := QuestActionInfo.nParam3;
  end else
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MISSION);
  end;
end;

//MOBFIREBURN MAP X Y TYPE TIME POINT
procedure TNormNpc.ActionOfMobFireBurn(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  sMap: string;
  nX, nY, nType, nTime, nPoint: Integer;
  FireBurnEvent: TFireBurnEvent;
  Envir: TEnvirnoment;
  OldEnvir: TEnvirnoment;
begin
  sMap := QuestActionInfo.sParam1;
  nX := Str_ToInt(QuestActionInfo.sParam2, -1);
  nY := Str_ToInt(QuestActionInfo.sParam3, -1);
  nType := Str_ToInt(QuestActionInfo.sParam4, -1);
  nTime := Str_ToInt(QuestActionInfo.sParam5, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam6, -1);
  if (sMap = '') or (nX < 0) or (nY < 0) or (nType < 0) or (nTime < 0) or (nPoint < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MOBFIREBURN);
    Exit;
  end;
  Envir := g_MapManager.FindMap(sMap);
  if Envir <> nil then
  begin
    OldEnvir := PlayObject.m_PEnvir;
    PlayObject.m_PEnvir := Envir;
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY, nType, nTime * 1000, nPoint);
    g_EventManager.AddEvent(FireBurnEvent);
    PlayObject.m_PEnvir := OldEnvir;
    Exit;
  end;
  ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MOBFIREBURN);

end;

procedure TNormNpc.ActionOfMobPlace(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo; nX, nY, nCount, nRange: Integer);
var
  i: Integer;
  nRandX, nRandY: Integer;
  mon: TBaseObject;
begin
  for i := 0 to nCount - 1 do
  begin
    nRandX := Random(nRange * 2 + 1) + (nX - nRange);
    nRandY := Random(nRange * 2 + 1) + (nY - nRange);
    mon := UserEngine.RegenMonsterByName(g_sMissionMap, nRandX, nRandY, QuestActionInfo.sParam1);
    if mon <> nil then
    begin
      mon.m_boMission := True;
      mon.m_nMissionX := g_nMissionX;
      mon.m_nMissionY := g_nMissionY;
    end else
    begin
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MOBPLACE);
      Break;
    end;
  end;
end;

procedure TNormNpc.ActionOfRecallGroupMembers(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin

end;


procedure TNormNpc.ActionOfSetRankLevelName(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  sRankLevelName: string;
begin
  sRankLevelName := QuestActionInfo.sParam1;
  if sRankLevelName = '' then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SKILLLEVEL);
    Exit;
  end;
  PlayObject.m_sRankLevelName := sRankLevelName;
  PlayObject.RefShowName;
end;

procedure TNormNpc.ActionOfSetScriptFlag(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  boFlag: Boolean;
  nWhere: Integer;
begin
  nWhere := Str_ToInt(QuestActionInfo.sParam1, -1);
  boFlag := Str_ToInt(QuestActionInfo.sParam2, -1) = 1;
  case nWhere of //
    0:
      begin
        PlayObject.m_boSendMsgFlag := boFlag;
      end;
    1:
      begin
        PlayObject.m_boChangeItemNameFlag := boFlag;
      end;
  else
    begin
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETSCRIPTFLAG);
    end;
  end;
end;

procedure TNormNpc.ActionOfSkillLevel(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  Magic: pTMagic;
  UserMagic: pTUserMagic;
  nLevel: Integer;
  cMethod: Char;
begin
  nLevel := Str_ToInt(QuestActionInfo.sParam3, 0);
  if nLevel < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SKILLLEVEL);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam2[1];
  Magic := UserEngine.FindMagic(QuestActionInfo.sParam1);
  if Magic <> nil then
  begin
    for i := 0 to PlayObject.m_MagicList.Count - 1 do
    begin
      UserMagic := PlayObject.m_MagicList.Items[i];
      if UserMagic.MagicInfo = Magic then
      begin
        case cMethod of
          '=':
            begin
              if nLevel >= 0 then
              begin
                nLevel := _MAX(3, nLevel);
                UserMagic.btLevel := nLevel;
              end;
            end;
          '-':
            begin
              if UserMagic.btLevel >= nLevel then
              begin
                Dec(UserMagic.btLevel, nLevel);
              end else
              begin
                UserMagic.btLevel := 0;
              end;
            end;
          '+':
            begin
              if UserMagic.btLevel + nLevel <= 3 then
              begin
                Inc(UserMagic.btLevel, nLevel);
              end else
              begin
                UserMagic.btLevel := 3;
              end;
            end;
        end;
        PlayObject.SendDelayMsg(PlayObject, RM_MAGIC_LVEXP, 0, UserMagic.MagicInfo.wMagicId, UserMagic.btLevel, UserMagic.nTranPoint, '', 100);
        Break;
      end;
    end;
  end;
end;


procedure TNormNpc.ActionOfTakeCastleGold(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nGold: Integer;
begin
  nGold := Str_ToInt(QuestActionInfo.sParam1, -1);
  if (nGold < 0) or (m_Castle = nil) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_TAKECASTLEGOLD);
    Exit;
  end;

  if nGold <= TUserCastle(m_Castle).m_nTotalGold then
  begin
    Dec(TUserCastle(m_Castle).m_nTotalGold, nGold);
  end else
  begin
    TUserCastle(m_Castle).m_nTotalGold := 0;
  end;
end;


procedure TNormNpc.ClearScript; //0049E914
var
  III, IIII: Integer;
  i, ii: Integer;
  Script: pTScript;
  SayingRecord: pTSayingRecord;
  SayingProcedure: pTSayingProcedure;
begin
  for i := 0 to m_ScriptList.Count - 1 do
  begin
    Script := m_ScriptList.Items[i];
    for ii := 0 to Script.RecordList.Count - 1 do
    begin
      SayingRecord := Script.RecordList.Items[ii];
      for III := 0 to SayingRecord.ProcedureList.Count - 1 do
      begin
        SayingProcedure := SayingRecord.ProcedureList.Items[III];
        for IIII := 0 to SayingProcedure.ConditionList.Count - 1 do
        begin
          Dispose(pTQuestConditionInfo(SayingProcedure.ConditionList.Items[IIII]));
        end;
        for IIII := 0 to SayingProcedure.ActionList.Count - 1 do
        begin
          Dispose(pTQuestActionInfo(SayingProcedure.ActionList.Items[IIII]));
        end;
        for IIII := 0 to SayingProcedure.ElseActionList.Count - 1 do
        begin
          Dispose(pTQuestActionInfo(SayingProcedure.ElseActionList.Items[IIII]));
        end;
        SayingProcedure.ConditionList.Free;
        SayingProcedure.ActionList.Free;
        SayingProcedure.ElseActionList.Free;
        Dispose(SayingProcedure);
      end; // for
      SayingRecord.ProcedureList.Free;
      Dispose(SayingRecord);
    end; // for
    Script.RecordList.Free;
    Dispose(Script);
  end; // for
  m_ScriptList.Clear;
end;

procedure TNormNpc.Click(PlayObject: TPlayObject); //0049EC18
begin
  PlayObject.m_nScriptGotoCount := 0;
  PlayObject.m_sScriptGoBackLable := '';
  PlayObject.m_sScriptCurrLable := '';
  GotoLable(PlayObject, '@main', False);
end;

function TNormNpc.ConditionOfCheckAccountIPList(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sCharName: string;
  sCharAccount: string;
  sCharIPaddr: string;
  sLine: string;
  sName: string;
  sIPaddr: string;
begin
  Result := False;
  try
    sCharName := PlayObject.m_sCharName;
    sCharAccount := PlayObject.m_sUserID;
    sCharIPaddr := PlayObject.m_sIPaddr;
    LoadList := TStringList.Create;
    if FileExists(g_Config.sEnvirDir + QuestConditionInfo.sParam1) then
    begin
      LoadList.LoadFromFile(g_Config.sEnvirDir + QuestConditionInfo.sParam1);
      for i := 0 to LoadList.Count - 1 do
      begin
        sLine := LoadList.Strings[i];
        if sLine[1] = ';' then Continue;
        sIPaddr := GetValidStr3(sLine, sName, [' ', '/', #9]);
        sIPaddr := Trim(sIPaddr);
        if (sName = sCharAccount) and (sIPaddr = sCharIPaddr) then
        begin
          Result := True;
          Break;
        end;
      end;
    end else
    begin
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKACCOUNTIPLIST);
    end;
  finally
    LoadList.Free
  end;
end;

function TNormNpc.ConditionOfCheckBagSize(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nSize: Integer;
begin
  Result := False;
  nSize := QuestConditionInfo.nParam1;
  if (nSize <= 0) or (nSize > MAXBAGITEM) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKBAGSIZE);
    Exit;
  end;
  if PlayObject.m_ItemList.Count + nSize <= MAXBAGITEM then
    Result := True;
end;

function TNormNpc.ConditionOfCheckBonusPoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nTotlePoint: Integer;
  cMethod: Char;
begin
  Result := False;
  nTotlePoint := m_BonusAbil.DC +
    m_BonusAbil.MC +
    m_BonusAbil.SC +
    m_BonusAbil.AC +
    m_BonusAbil.MAC +
    m_BonusAbil.HP +
    m_BonusAbil.MP +
    m_BonusAbil.Hit +
    m_BonusAbil.Speed +
    m_BonusAbil.X2;

  nTotlePoint := nTotlePoint + m_nBonusPoint;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nTotlePoint = QuestConditionInfo.nParam2 then Result := True;
    '>': if nTotlePoint > QuestConditionInfo.nParam2 then Result := True;
    '<': if nTotlePoint < QuestConditionInfo.nParam2 then Result := True;
  else if nTotlePoint >= QuestConditionInfo.nParam2 then Result := True;
  end;
end;


function TNormNpc.ConditionOfCheckHP(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;
  function CheckHigh(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=':
        begin
          if PlayObject.m_WAbil.MaxHP = nMax then
          begin
            Result := True;
          end;
        end;
      '>':
        begin
          if PlayObject.m_WAbil.MaxHP > nMax then
          begin
            Result := True;
          end;
        end;
      '<':
        begin
          if PlayObject.m_WAbil.MaxHP < nMax then
          begin
            Result := True;
          end;
        end;
    else
      begin
        if PlayObject.m_WAbil.MaxHP >= nMax then
        begin
          Result := True;
        end;
      end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam1[3];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if (nMIN < 0) or (nMax < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKHP);
    Exit;
  end;

  case cMethodMin of
    '=':
      begin
        if (m_WAbil.HP = nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
    '>':
      begin
        if (PlayObject.m_WAbil.HP > nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
    '<':
      begin
        if (PlayObject.m_WAbil.HP < nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
  else
    begin
      if (PlayObject.m_WAbil.HP >= nMIN) then
      begin
        Result := CheckHigh;
      end;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckMP(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;
  function CheckHigh(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=':
        begin
          if PlayObject.m_WAbil.MaxMP = nMax then
          begin
            Result := True;
          end;
        end;
      '>':
        begin
          if PlayObject.m_WAbil.MaxMP > nMax then
          begin
            Result := True;
          end;
        end;
      '<':
        begin
          if PlayObject.m_WAbil.MaxMP < nMax then
          begin
            Result := True;
          end;
        end;
    else
      begin
        if PlayObject.m_WAbil.MaxMP >= nMax then
        begin
          Result := True;
        end;
      end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam1[3];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if (nMIN < 0) or (nMax < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMP);
    Exit;
  end;

  case cMethodMin of
    '=':
      begin
        if (m_WAbil.MP = nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
    '>':
      begin
        if (PlayObject.m_WAbil.MP > nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
    '<':
      begin
        if (PlayObject.m_WAbil.MP < nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
  else
    begin
      if (PlayObject.m_WAbil.MP >= nMIN) then
      begin
        Result := CheckHigh;
      end;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckDC(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;
  function CheckHigh(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=':
        begin
          if HiWord(PlayObject.m_WAbil.DC) = nMax then
          begin
            Result := True;
          end;
        end;
      '>':
        begin
          if HiWord(PlayObject.m_WAbil.DC) > nMax then
          begin
            Result := True;
          end;
        end;
      '<':
        begin
          if HiWord(PlayObject.m_WAbil.DC) < nMax then
          begin
            Result := True;
          end;
        end;
    else
      begin
        if HiWord(PlayObject.m_WAbil.DC) >= nMax then
        begin
          Result := True;
        end;
      end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam1[3];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if (nMIN < 0) or (nMax < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKDC);
    Exit;
  end;

  case cMethodMin of
    '=':
      begin
        if (LoWord(PlayObject.m_WAbil.DC) = nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
    '>':
      begin
        if (LoWord(PlayObject.m_WAbil.DC) > nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
    '<':
      begin
        if (LoWord(PlayObject.m_WAbil.DC) < nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
  else
    begin
      if (LoWord(PlayObject.m_WAbil.DC) >= nMIN) then
      begin
        Result := CheckHigh;
      end;
    end;
  end;

  Result := False;
end;

function TNormNpc.ConditionOfCheckMC(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;
  function CheckHigh(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=':
        begin
          if HiWord(PlayObject.m_WAbil.MC) = nMax then
          begin
            Result := True;
          end;
        end;
      '>':
        begin
          if HiWord(PlayObject.m_WAbil.MC) > nMax then
          begin
            Result := True;
          end;
        end;
      '<':
        begin
          if HiWord(PlayObject.m_WAbil.MC) < nMax then
          begin
            Result := True;
          end;
        end;
    else
      begin
        if HiWord(PlayObject.m_WAbil.MC) >= nMax then
        begin
          Result := True;
        end;
      end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam1[3];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if (nMIN < 0) or (nMax < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMC);
    Exit;
  end;

  case cMethodMin of
    '=':
      begin
        if (LoWord(PlayObject.m_WAbil.MC) = nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
    '>':
      begin
        if (LoWord(PlayObject.m_WAbil.MC) > nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
    '<':
      begin
        if (LoWord(PlayObject.m_WAbil.MC) < nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
  else
    begin
      if (LoWord(PlayObject.m_WAbil.MC) >= nMIN) then
      begin
        Result := CheckHigh;
      end;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckSC(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;
  function CheckHigh(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=':
        begin
          if HiWord(PlayObject.m_WAbil.SC) = nMax then
          begin
            Result := True;
          end;
        end;
      '>':
        begin
          if HiWord(PlayObject.m_WAbil.SC) > nMax then
          begin
            Result := True;
          end;
        end;
      '<':
        begin
          if HiWord(PlayObject.m_WAbil.SC) < nMax then
          begin
            Result := True;
          end;
        end;
    else
      begin
        if HiWord(PlayObject.m_WAbil.SC) >= nMax then
        begin
          Result := True;
        end;
      end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam1[3];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if (nMIN < 0) or (nMax < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKSC);
    Exit;
  end;

  case cMethodMin of
    '=':
      begin
        if (LoWord(PlayObject.m_WAbil.SC) = nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
    '>':
      begin
        if (LoWord(PlayObject.m_WAbil.SC) > nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
    '<':
      begin
        if (LoWord(PlayObject.m_WAbil.SC) < nMIN) then
        begin
          Result := CheckHigh;
        end;
      end;
  else
    begin
      if (LoWord(PlayObject.m_WAbil.SC) >= nMIN) then
      begin
        Result := CheckHigh;
      end;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckExp(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  dwExp: LongWord;
begin
  Result := False;
  dwExp := Str_ToInt(QuestConditionInfo.sParam2, 0);
  if dwExp = 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKEXP);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_Abil.Exp = dwExp then Result := True;
    '>': if PlayObject.m_Abil.Exp > dwExp then Result := True;
    '<': if PlayObject.m_Abil.Exp < dwExp then Result := True;
  else if PlayObject.m_Abil.Exp >= dwExp then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckFlourishPoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nPoint: Integer;
  Guild: TGUild;
begin
  Result := False;
  nPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nPoint < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKFLOURISHPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nFlourishing = nPoint then Result := True;
    '>': if Guild.nFlourishing > nPoint then Result := True;
    '<': if Guild.nFlourishing < nPoint then Result := True;
  else if Guild.nFlourishing >= nPoint then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckChiefItemCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nCount: Integer;
  Guild: TGUild;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKFLOURISHPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nChiefItemCount = nCount then Result := True;
    '>': if Guild.nChiefItemCount > nCount then Result := True;
    '<': if Guild.nChiefItemCount < nCount then Result := True;
  else if Guild.nChiefItemCount >= nCount then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckGuildAuraePoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nPoint: Integer;
  Guild: TGUild;
begin
  Result := False;
  nPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nPoint < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKAURAEPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nAurae = nPoint then Result := True;
    '>': if Guild.nAurae > nPoint then Result := True;
    '<': if Guild.nAurae < nPoint then Result := True;
  else if Guild.nAurae >= nPoint then Result := True;
  end;

end;

function TNormNpc.ConditionOfCheckGuildBuildPoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nPoint: Integer;
  Guild: TGUild;
begin
  Result := False;
  nPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nPoint < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKBUILDPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nBuildPoint = nPoint then Result := True;
    '>': if Guild.nBuildPoint > nPoint then Result := True;
    '<': if Guild.nBuildPoint < nPoint then Result := True;
  else if Guild.nBuildPoint >= nPoint then Result := True;
  end;

end;

function TNormNpc.ConditionOfCheckStabilityPoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nPoint: Integer;
  Guild: TGUild;
begin
  Result := False;
  nPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nPoint < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKSTABILITYPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nStability = nPoint then Result := True;
    '>': if Guild.nStability > nPoint then Result := True;
    '<': if Guild.nStability < nPoint then Result := True;
  else if Guild.nStability >= nPoint then Result := True;
  end;

end;

function TNormNpc.ConditionOfCheckGameGold(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nGameGold: Integer;
begin
  Result := False;
  nGameGold := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nGameGold < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKGAMEGOLD);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nGameGold = nGameGold then Result := True;
    '>': if PlayObject.m_nGameGold > nGameGold then Result := True;
    '<': if PlayObject.m_nGameGold < nGameGold then Result := True;
  else if PlayObject.m_nGameGold >= nGameGold then Result := True;
  end;
end;
function TNormNpc.ConditionOfCheckGamePoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nGamePoint: Integer;
begin
  Result := False;
  nGamePoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nGamePoint < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKGAMEPOINT);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nGamePoint = nGamePoint then Result := True;
    '>': if PlayObject.m_nGamePoint > nGamePoint then Result := True;
    '<': if PlayObject.m_nGamePoint < nGamePoint then Result := True;
  else if PlayObject.m_nGamePoint >= nGamePoint then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckGroupCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nCount: Integer;
begin
  Result := False;
  if PlayObject.m_GroupOwner = nil then Exit;
  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKGROUPCOUNT);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_GroupOwner.m_GroupMembers.Count = nCount then Result := True;
    '>': if PlayObject.m_GroupOwner.m_GroupMembers.Count > nCount then Result := True;
    '<': if PlayObject.m_GroupOwner.m_GroupMembers.Count < nCount then Result := True;
  else if PlayObject.m_GroupOwner.m_GroupMembers.Count >= nCount then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckHaveGuild(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
//  Result:=PlayObject.m_MyGuild = nil;
  Result := PlayObject.m_MyGuild <> nil; // 01-16 更正检查结果反了
end;

function TNormNpc.ConditionOfCheckInMapRange(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  sMapName: string;
  nX, nY, nRange: Integer;
begin
  Result := False;
  sMapName := QuestConditionInfo.sParam1;
  nX := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nY := Str_ToInt(QuestConditionInfo.sParam3, -1);
  nRange := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if (sMapName = '') or (nX < 0) or (nY < 0) or (nRange < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKINMAPRANGE);
    Exit;
  end;
  if CompareText(PlayObject.m_sMapName, sMapName) <> 0 then Exit;
  if (abs(PlayObject.m_nCurrX - nX) <= nRange) and (abs(PlayObject.m_nCurrY - nY) <= nRange) then
    Result := True;
end;

function TNormNpc.ConditionOfCheckIsAttackGuild(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if m_Castle = nil then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ISATTACKGUILD);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then Exit;
  Result := TUserCastle(m_Castle).IsAttackGuild(TGUild(PlayObject.m_MyGuild));
end;

function TNormNpc.ConditionOfCheckCastleChageDay(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nDay: Integer;
  cMethod: Char;
  nChangeDay: Integer;
begin
  Result := False;
  nDay := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if (nDay < 0) or (m_Castle = nil) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CASTLECHANGEDAY);
    Exit;
  end;
  nChangeDay := GetDayCount(Now, TUserCastle(m_Castle).m_ChangeDate);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nChangeDay = nDay then Result := True;
    '>': if nChangeDay > nDay then Result := True;
    '<': if nChangeDay < nDay then Result := True;
  else if nChangeDay >= nDay then Result := True;
  end;

end;

function TNormNpc.ConditionOfCheckCastleWarDay(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nDay: Integer;
  cMethod: Char;
  nWarDay: Integer;
begin
  Result := False;
  nDay := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if (nDay < 0) or (m_Castle = nil) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CASTLEWARDAY);
    Exit;
  end;
  nWarDay := GetDayCount(Now, TUserCastle(m_Castle).m_WarDate);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nWarDay = nDay then Result := True;
    '>': if nWarDay > nDay then Result := True;
    '<': if nWarDay < nDay then Result := True;
  else if nWarDay >= nDay then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckCastleDoorStatus(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nDay: Integer;
  cMethod: Char;
  nDoorStatus: Integer;
  CastleDoor: TCastleDoor;
begin
  Result := False;
  nDay := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nDoorStatus := -1;
  if CompareText(QuestConditionInfo.sParam1, '损坏') = 0 then nDoorStatus := 0;
  if CompareText(QuestConditionInfo.sParam1, '开启') = 0 then nDoorStatus := 1;
  if CompareText(QuestConditionInfo.sParam1, '关闭') = 0 then nDoorStatus := 2;

  if (nDay < 0) or (m_Castle = nil) or (nDoorStatus < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKCASTLEDOOR);
    Exit;
  end;
  CastleDoor := TCastleDoor(TUserCastle(m_Castle).m_MainDoor.BaseObject);

  case nDoorStatus of
    0: if CastleDoor.m_boDeath then Result := True;
    1: if CastleDoor.m_boOpened then Result := True;
    2: if not CastleDoor.m_boOpened then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckIsAttackAllyGuild(
  PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if m_Castle = nil then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ISATTACKALLYGUILD);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then Exit;
  Result := TUserCastle(m_Castle).IsAttackAllyGuild(TGUild(PlayObject.m_MyGuild));
end;

function TNormNpc.ConditionOfCheckIsDefenseAllyGuild(
  PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if m_Castle = nil then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ISDEFENSEALLYGUILD);
    Exit;
  end;

  if PlayObject.m_MyGuild = nil then Exit;
  Result := TUserCastle(m_Castle).IsDefenseAllyGuild(TGUild(PlayObject.m_MyGuild));
end;

function TNormNpc.ConditionOfCheckIsDefenseGuild(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if m_Castle = nil then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ISDEFENSEGUILD);
    Exit;
  end;

  if PlayObject.m_MyGuild = nil then Exit;
  Result := TUserCastle(m_Castle).IsDefenseGuild(TGUild(PlayObject.m_MyGuild));
end;

function TNormNpc.ConditionOfCheckIsCastleaGuild(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
//  if (PlayObject.m_MyGuild <> nil) and (UserCastle.m_MasterGuild = PlayObject.m_MyGuild) then
  if g_CastleManager.IsCastleMember(PlayObject) <> nil then
    Result := True;
end;

function TNormNpc.ConditionOfCheckIsCastleMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  //if PlayObject.IsGuildMaster and (UserCastle.m_MasterGuild = PlayObject.m_MyGuild) then
  if PlayObject.IsGuildMaster and (g_CastleManager.IsCastleMember(PlayObject) <> nil) then
    Result := True;
end;

function TNormNpc.ConditionOfCheckIsGuildMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := PlayObject.IsGuildMaster;
end;

{
function TNormNpc.ConditionOfCheckIsMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if (PlayObject.m_sMasterName <> '') and (PlayObject.m_boMaster) then
    Result := True;
end;

}

function TNormNpc.ConditionOfCheckListCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin

end;


function TNormNpc.ConditionOfCheckItemAddValue(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  nWhere: Integer;
  nAddAllValue, nAddValue: Integer;
  UserItem: pTUserItem;
  cMethod: Char;
begin
  Result := False;
  nWhere := Str_ToInt(QuestConditionInfo.sParam1, -1);
  cMethod := QuestConditionInfo.sParam2[1];
  nAddValue := Str_ToInt(QuestConditionInfo.sParam3, -1);
  if not (nWhere in [Low(THumanUseItems)..High(THumanUseItems)]) or (nAddValue < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKITEMADDVALUE);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nWhere];
  if UserItem.wIndex = 0 then
  begin
    Exit;
  end;
  nAddAllValue := 0;
  for i := Low(UserItem.btValue) to High(UserItem.btValue) do
  begin
    Inc(nAddAllValue, UserItem.btValue[i]);
  end;

  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nAddAllValue = nAddValue then Result := True;
    '>': if nAddAllValue > nAddValue then Result := True;
    '<': if nAddAllValue < nAddValue then Result := True;
  else if nAddAllValue >= nAddValue then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckItemType(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nWhere: Integer;
  nType: Integer;
  UserItem: pTUserItem;
  StdItem: TItem;
begin
  Result := False;
  nWhere := Str_ToInt(QuestConditionInfo.sParam1, -1);
  nType := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if not (nWhere in [Low(THumanUseItems)..High(THumanUseItems)]) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKITEMTYPE);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nWhere];
  if UserItem.wIndex = 0 then Exit;
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if (StdItem <> nil) and (StdItem.StdMode = nType) then
  begin
    Result := True;
  end;

end;

function TNormNpc.ConditionOfCheckLevelEx(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nLevel: Integer;
  cMethod: Char;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKLEVELEX);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_Abil.Level = nLevel then Result := True;
    '>': if PlayObject.m_Abil.Level > nLevel then Result := True;
    '<': if PlayObject.m_Abil.Level < nLevel then Result := True;
  else if PlayObject.m_Abil.Level >= nLevel then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckNameListPostion(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sCharName: string;
  nNamePostion, nPostion: Integer;
  sLine: string;
begin
  Result := False;
  nNamePostion := -1;
  try
    sCharName := PlayObject.m_sCharName;
    LoadList := TStringList.Create;
    if FileExists(g_Config.sEnvirDir + QuestConditionInfo.sParam1) then
    begin
      LoadList.LoadFromFile(g_Config.sEnvirDir + QuestConditionInfo.sParam1);
      for i := 0 to LoadList.Count - 1 do
      begin
        sLine := Trim(LoadList.Strings[i]);
        if sLine[1] = ';' then Continue;
        if CompareText(sLine, sCharName) = 0 then
        begin
          nNamePostion := i;
          Break;
        end;
      end;
    end else
    begin
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKNAMELISTPOSITION);
    end;
  finally
    LoadList.Free
  end;
  nPostion := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nPostion < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKNAMELISTPOSITION);
    Exit;
  end;
  if nNamePostion >= nPostion then
    Result := True;
end;


//取消 结婚 和 师徒系统 的相关功能
{
function TNormNpc.ConditionOfCheckMarry(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if PlayObject.m_sDearName <> '' then Result := True;
end;

function TNormNpc.ConditionOfCheckMarryCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount: Integer;
  cMethod: Char;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMARRYCOUNT);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_btMarryCount = nCount then Result := True;
    '>': if PlayObject.m_btMarryCount > nCount then Result := True;
    '<': if PlayObject.m_btMarryCount < nCount then Result := True;
  else if PlayObject.m_btMarryCount >= nCount then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if (PlayObject.m_sMasterName <> '') and (not PlayObject.m_boMaster) then
    Result := True;
end;

function TNormNpc.ConditionOfCheckPoseIsMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    if (TPlayObject(PoseHuman).m_sMasterName <> '') and (TPlayObject(PoseHuman).m_boMaster) then
      Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckPoseMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    if (TPlayObject(PoseHuman).m_sMasterName <> '') and not (TPlayObject(PoseHuman).m_boMaster) then
      Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckPoseMarry(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    if TPlayObject(PoseHuman).m_sDearName <> '' then
      Result := True;
  end;
end;

}



function TNormNpc.ConditionOfCheckMemBerLevel(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nLevel: Integer;
  cMethod: Char;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMEMBERLEVEL);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nMemberLevel = nLevel then Result := True;
    '>': if PlayObject.m_nMemberLevel > nLevel then Result := True;
    '<': if PlayObject.m_nMemberLevel < nLevel then Result := True;
  else if PlayObject.m_nMemberLevel >= nLevel then Result := True;
  end;
end;


function TNormNpc.ConditionOfCheckMemberType(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nType: Integer;
  cMethod: Char;
begin
  Result := False;
  nType := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nType < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMEMBERTYPE);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nMemberType = nType then Result := True;
    '>': if PlayObject.m_nMemberType > nType then Result := True;
    '<': if PlayObject.m_nMemberType < nType then Result := True;
  else if PlayObject.m_nMemberType >= nType then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckNameIPList(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sCharName: string;
  sCharAccount: string;
  sCharIPaddr: string;
  sLine: string;
  sName: string;
  sIPaddr: string;
begin
  Result := False;
  try
    sCharName := PlayObject.m_sCharName;
    sCharAccount := PlayObject.m_sUserID;
    sCharIPaddr := PlayObject.m_sIPaddr;
    LoadList := TStringList.Create;
    if FileExists(g_Config.sEnvirDir + QuestConditionInfo.sParam1) then
    begin
      LoadList.LoadFromFile(g_Config.sEnvirDir + QuestConditionInfo.sParam1);
      for i := 0 to LoadList.Count - 1 do
      begin
        sLine := LoadList.Strings[i];
        if sLine[1] = ';' then Continue;
        sIPaddr := GetValidStr3(sLine, sName, [' ', '/', #9]);
        sIPaddr := Trim(sIPaddr);
        if (sName = sCharName) and (sIPaddr = sCharIPaddr) then
        begin
          Result := True;
          Break;
        end;
      end;
    end else
    begin
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKNAMEIPLIST);
    end;
  finally
    LoadList.Free
  end;
end;

function TNormNpc.ConditionOfCheckPoseDir(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.GetPoseCreate = PlayObject) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    case QuestConditionInfo.nParam1 of
      1: if PoseHuman.m_btGender = PlayObject.m_btGender then Result := True; //要求相同性别
      2: if PoseHuman.m_btGender <> PlayObject.m_btGender then Result := True; //要求不同性别
    else Result := True; //无参数时不判别性别
    end;
  end;
end;

function TNormNpc.ConditionOfCheckPoseGender(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
  btSex: Byte;
begin
  Result := False;
  btSex := 0;
  if CompareText(QuestConditionInfo.sParam1, 'MAN') = 0 then
  begin
    btSex := 0;
  end else
    if CompareText(QuestConditionInfo.sParam1, '男') = 0 then
    begin
      btSex := 0;
    end else
      if CompareText(QuestConditionInfo.sParam1, 'WOMAN') = 0 then
      begin
        btSex := 1;
      end else
        if CompareText(QuestConditionInfo.sParam1, '女') = 0 then
        begin
          btSex := 1;
        end;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    if PoseHuman.m_btGender = btSex then Result := True;
  end;
end;


function TNormNpc.ConditionOfCheckPoseLevel(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nLevel: Integer;
  PoseHuman: TBaseObject;
  cMethod: Char;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKPOSELEVEL);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    case cMethod of
      '=': if PoseHuman.m_Abil.Level = nLevel then Result := True;
      '>': if PoseHuman.m_Abil.Level > nLevel then Result := True;
      '<': if PoseHuman.m_Abil.Level < nLevel then Result := True;
    else if PoseHuman.m_Abil.Level >= nLevel then Result := True;
    end;
  end;

end;


function TNormNpc.ConditionOfCheckServerName(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  sServerName: string;
begin
  Result := False;
  if QuestConditionInfo.sParam1 = g_Config.sServerName then Result := True;
end;

function TNormNpc.ConditionOfCheckSlaveCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount: Integer;
  cMethod: Char;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKSLAVECOUNT);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_SlaveList.Count = nCount then Result := True;
    '>': if PlayObject.m_SlaveList.Count > nCount then Result := True;
    '<': if PlayObject.m_SlaveList.Count < nCount then Result := True;
  else if PlayObject.m_SlaveList.Count >= nCount then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckMap(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  if QuestConditionInfo.sParam1 = PlayObject.m_sMapName then
    Result := True
  else
    Result := False;
end;

function TNormNpc.ConditionOfCheckPos(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nX, nY: Integer;
begin
  nX := QuestConditionInfo.nParam2;
  nY := QuestConditionInfo.nParam3;

  if (QuestConditionInfo.sParam1 = PlayObject.m_sMapName) and (nX = PlayObject.m_nCurrX) and (nY = PlayObject.m_nCurrY) then
    Result := True
  else
    Result := False;
end;

function TNormNpc.ConditionOfReviveSlave(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i, n14, resultc, nSlaveCount: Integer;
  s18, s20, s24: string;
  myFile: TextFile;
  LoadList, templist: TStringList;
  sFileName, sLineText, Petname, lvl, lvlexp: string;
begin
  resultc := -1;
  sFileName := g_Config.sEnvirDir + 'PetData\' + PlayObject.m_sCharName + '.txt';

  if FileExists(sFileName) then
  begin
    LoadList := TStringList.Create;
  //  Templist:=TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    if PlayObject.m_btJob = jTaos then
    begin
      nSlaveCount := 1;
    end else
    begin
      nSlaveCount := 5;
    end;
    for i := 0 to LoadList.Count - 1 do
    begin
      s18 := Trim(LoadList.Strings[i]);
      if (s18 <> '') and (s18[1] <> ';') then
      begin
        s18 := GetValidStr3(s18, Petname, ['/']);
        s18 := GetValidStr3(s18, lvl, ['/']);
        s18 := GetValidStr3(s18, lvlexp, ['/']);
     //PlayObject.ReviveSlave(PetName,str_ToInt(lvl,0),str_ToInt(lvlexp,0),nslavecount,10 * 24 * 60 * 60);
        resultc := i;
      end;
    end;
    if LoadList.Count > 0 then
    begin
      Result := True;
      AssignFile(myFile, sFileName);
      Rewrite(myFile);
      CloseFile(myFile);
    end;
  end;
end;

function TNormNpc.ConditionOfCheckMagicLvl(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  UserMagic: pTUserMagic;
begin
  Result := False;
  for i := 0 to PlayObject.m_MagicList.Count - 1 do
  begin
    UserMagic := PlayObject.m_MagicList.Items[i];
    if CompareText(UserMagic.MagicInfo.sMagicName, QuestConditionInfo.sParam1) = 0 then
    begin
      if (UserMagic.btLevel = QuestConditionInfo.nParam2) then
        Result := True;

      Break;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckGroupClass(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i, nCount, nJob: Integer;
  cMethod: Char;
  PlayObjectEx: TPlayObject;
begin
  Result := False;
  nJob := -1;
  nCount := 0;

  if CompareLStr(QuestConditionInfo.sParam1, sWarrior, Length(sWarrior)) then nJob := jWarr;
  if CompareLStr(QuestConditionInfo.sParam1, sWizard, Length(sWizard)) then nJob := jWizard;
  if CompareLStr(QuestConditionInfo.sParam1, sTaos, Length(sTaos)) then nJob := jTaos;

  if nJob < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHANGEJOB);
    Exit;
  end;

  if PlayObject.m_GroupOwner <> nil then
  begin
    for i := 0 to PlayObject.m_GroupMembers.Count - 1 do
    begin
      PlayObjectEx := TPlayObject(PlayObject.m_GroupMembers.Objects[i]);

      if PlayObjectEx.m_btJob = nJob then
        Inc(nCount);

    end;
  end;

  cMethod := QuestConditionInfo.sParam2[1];
  case cMethod of
    '=': if nCount = QuestConditionInfo.nParam3 then Result := True;
    '>': if nCount > QuestConditionInfo.nParam3 then Result := True;
    '<': if nCount < QuestConditionInfo.nParam3 then Result := True;
  else if nCount >= QuestConditionInfo.nParam3 then Result := True;
  end;
end;




constructor TNormNpc.Create; //0049AA38
begin
  inherited;
  m_boSuperMan := True;
  m_btRaceServer := RC_NPC;
  m_nLight := 2;
  m_btAntiPoison := 99;
  m_ScriptList := TList.Create;
  m_boStickMode := True;
  m_sFilePath := '';
  m_boIsHide := False;
  m_boIsQuest := True;
end;

destructor TNormNpc.Destroy; //0049AAE4
var
  i: Integer;
begin
  ClearScript();
  {
  for I := 0 to ScriptList.Count - 1 do begin
    Dispose(pTScript(ScriptList.Items[I]));
  end;
  }
  m_ScriptList.Free;
  inherited;
end;

procedure TNormNpc.ExeAction(PlayObject: TPlayObject; sParam1, sParam2,
  sParam3: string; nParam1, nParam2, nParam3: Integer);
var
  nInt1, nInt2, nInt3: Integer;
  dwInt: LongWord;
  BaseObject: TBaseObject;
begin
  //================================================
  //更改人物当前经验值
  //EXEACTION CHANGEEXP 0 经验数  设置为指定经验值
  //EXEACTION CHANGEEXP 1 经验数  增加指定经验
  //EXEACTION CHANGEEXP 2 经验数  减少指定经验
  //================================================
  if CompareText(sParam1, 'CHANGEEXP') = 0 then
  begin
    nInt1 := Str_ToInt(sParam2, -1);
    case nInt1 of //
      0:
        begin
          if nParam3 >= 0 then
          begin
            PlayObject.m_Abil.Exp := LongWord(nParam3);
            PlayObject.HasLevelUp(PlayObject.m_Abil.Level - 1);
          end;
        end;
      1:
        begin
          if PlayObject.m_Abil.Exp >= LongWord(nParam3) then
          begin
            if (PlayObject.m_Abil.Exp - LongWord(nParam3)) > (High(LongWord) - PlayObject.m_Abil.Exp) then
            begin
              dwInt := High(LongWord) - PlayObject.m_Abil.Exp;
            end else
            begin
              dwInt := LongWord(nParam3);
            end;
          end else
          begin
            if (LongWord(nParam3) - PlayObject.m_Abil.Exp) > (High(LongWord) - LongWord(nParam3)) then
            begin
              dwInt := High(LongWord) - LongWord(nParam3);
            end else
            begin
              dwInt := LongWord(nParam3);
            end;
          end;
          Inc(PlayObject.m_Abil.Exp, dwInt);
          PlayObject.HasLevelUp(PlayObject.m_Abil.Level - 1);
        end;
      2:
        begin
          if PlayObject.m_Abil.Exp > LongWord(nParam3) then
          begin
            Dec(PlayObject.m_Abil.Exp, LongWord(nParam3));
          end else
          begin
            PlayObject.m_Abil.Exp := 0;
          end;
          PlayObject.HasLevelUp(PlayObject.m_Abil.Level - 1);
        end;
    end;
    PlayObject.SysMsg('您当前经验点数为: ' + IntToStr(PlayObject.m_Abil.Exp) + '/' + IntToStr(PlayObject.m_Abil.MaxExp), c_Green, t_Hint);
    Exit;
  end;

  //================================================
  //更改人物当前等级
  //EXEACTION CHANGELEVEL 0 等级数  设置为指定等级
  //EXEACTION CHANGELEVEL 1 等级数  增加指定等级
  //EXEACTION CHANGELEVEL 2 等级数  减少指定等级
  //================================================
  if CompareText(sParam1, 'CHANGELEVEL') = 0 then
  begin
    nInt1 := Str_ToInt(sParam2, -1);
    case nInt1 of //
      0:
        begin
          if nParam3 >= 0 then
          begin
            PlayObject.m_Abil.Level := LongWord(nParam3);
            PlayObject.HasLevelUp(PlayObject.m_Abil.Level - 1);
          end;
        end;
      1:
        begin
          if PlayObject.m_Abil.Level >= LongWord(nParam3) then
          begin
            if (PlayObject.m_Abil.Level - LongWord(nParam3)) > (High(Word) - PlayObject.m_Abil.Level) then
            begin
              dwInt := High(Word) - PlayObject.m_Abil.Level;
            end else
            begin
              dwInt := LongWord(nParam3);
            end;
          end else
          begin
            if (LongWord(nParam3) - PlayObject.m_Abil.Level) > (High(Word) - LongWord(nParam3)) then
            begin
              dwInt := High(LongWord) - LongWord(nParam3);
            end else
            begin
              dwInt := LongWord(nParam3);
            end;
          end;
          Inc(PlayObject.m_Abil.Level, dwInt);
          PlayObject.HasLevelUp(PlayObject.m_Abil.Level - 1);
        end;
      2:
        begin
          if PlayObject.m_Abil.Level > LongWord(nParam3) then
          begin
            Dec(PlayObject.m_Abil.Level, LongWord(nParam3));
          end else
          begin
            PlayObject.m_Abil.Level := 0;
          end;
          PlayObject.HasLevelUp(PlayObject.m_Abil.Level - 1);
        end;
    end;
    PlayObject.SysMsg('您当前等级为: ' + IntToStr(PlayObject.m_Abil.Level), c_Green, t_Hint);
    Exit;
  end;

  //================================================
  //杀死人物
  //EXEACTION KILL 0 人物死亡,不显示凶手信息
  //EXEACTION KILL 1 人物死亡不掉物品,不显示凶手信息
  //EXEACTION KILL 2 人物死亡,显示凶手信息为NPC
  //EXEACTION KILL 3 人物死亡不掉物品,显示凶手信息为NPC
  //================================================
  if CompareText(sParam1, 'KILL') = 0 then
  begin
    nInt1 := Str_ToInt(sParam2, -1);
    case nInt1 of //
      1:
        begin
          PlayObject.m_boNoItem := True;
          PlayObject.Die;
        end;
      2:
        begin
          PlayObject.SetLastHiter(Self);
          PlayObject.Die;
        end;
      3:
        begin
          PlayObject.m_boNoItem := True;
          PlayObject.SetLastHiter(Self);
          PlayObject.Die;
        end;
    else
      begin
        PlayObject.Die;
      end;
    end;
    Exit;
  end;

  //================================================
  //踢人物下线
  //EXEACTION KICK
  //================================================
  if CompareText(sParam1, 'KICK') = 0 then
  begin
    PlayObject.m_boKickFlag := True;
    Exit;
  end;


  //==============================================================================
end;

function TNormNpc.GetLineVariableText(PlayObject: TPlayObject;
  sMsg: string): string;
var
  nC: Integer;
  s10: string;
begin
  nC := 0;
  while (True) do
  begin
    if TagCount(sMsg, '>') < 1 then Break;
    ArrestStringEx(sMsg, '<', '>', s10);
    GetVariableText(PlayObject, sMsg, s10);
    Inc(nC);
    if nC >= 101 then Break;
  end;
  Result := sMsg;
end;

procedure TNormNpc.GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string); //0049AEA4
var
  sText, s14: string;
  i: Integer;
  n18: Integer;
  wHour: Word;
  wMinute: Word;
  wSecond: Word;
  nSecond: Integer;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
begin
//全局信息
  if sVariable = '$SERVERNAME' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$SERVERNAME>', g_Config.sServerName);
    Exit;
  end;
  if sVariable = '$SERVERIP' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$SERVERIP>', g_Config.sServerIPaddr);
    Exit;
  end;
  if sVariable = '$WEBSITE' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$WEBSITE>', g_Config.sWebSite);
    Exit;
  end;
  if sVariable = '$BBSSITE' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$BBSSITE>', g_Config.sBbsSite);
    Exit;
  end;
  if sVariable = '$CLIENTDOWNLOAD' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CLIENTDOWNLOAD>', g_Config.sClientDownload);
    Exit;
  end;
  if sVariable = '$QQ' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$QQ>', g_Config.sQQ);
    Exit;
  end;
  if sVariable = '$PHONE' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$PHONE>', g_Config.sPhone);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT0' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT0>', g_Config.sBankAccount0);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT1' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT1>', g_Config.sBankAccount1);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT2' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT2>', g_Config.sBankAccount2);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT3' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT3>', g_Config.sBankAccount3);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT4' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT4>', g_Config.sBankAccount4);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT5' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT5>', g_Config.sBankAccount5);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT6' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT6>', g_Config.sBankAccount6);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT7' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT7>', g_Config.sBankAccount7);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT8' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT8>', g_Config.sBankAccount8);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT9' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT9>', g_Config.sBankAccount9);
    Exit;
  end;
  if sVariable = '$GAMEGOLDNAME' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$GAMEGOLDNAME>', g_Config.sGameGoldName);
    Exit;
  end;
  if sVariable = '$GAMEPOINTNAME' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$GAMEPOINTNAME>', g_Config.sGamePointName);
    Exit;
  end;
  if sVariable = '$USERCOUNT' then
  begin
    sText := IntToStr(UserEngine.PlayObjectCount);
    sMsg := sub_49ADB8(sMsg, '<$USERCOUNT>', sText);
    Exit;
  end;
  if sVariable = '$MACRUNTIME' then
  begin
    sText := CurrToStr(GetTickCount / (24 * 60 * 60 * 1000));
    sMsg := sub_49ADB8(sMsg, '<$MACRUNTIME>', sText);
    Exit;
  end;
  if sVariable = '$SERVERRUNTIME' then
  begin
    nSecond := (GetTickCount() - g_dwStartTick) div 1000;
    wHour := nSecond div 3600;
    wMinute := (nSecond div 60) mod 60;
    wSecond := nSecond mod 60;
    sText := Format('%d:%d:%d', [wHour, wMinute, wSecond]);
    sMsg := sub_49ADB8(sMsg, '<$SERVERRUNTIME>', sText);
    Exit;
  end;
  if sVariable = '$DATETIME' then
  begin
//    sText:=DateTimeToStr(Now);
    sText := FormatDateTime('dddddd,dddd,hh:mm:nn', Now);
    sMsg := sub_49ADB8(sMsg, '<$DATETIME>', sText);
    Exit;
  end;

  if sVariable = '$HIGHLEVELINFO' then
  begin
    if g_HighLevelHuman <> nil then
    begin
      sText := TPlayObject(g_HighLevelHuman).GetMyInfo;
    end else sText := '????';
    sMsg := sub_49ADB8(sMsg, '<$HIGHLEVELINFO>', sText);
    Exit;
  end;
  if sVariable = '$HIGHPKINFO' then
  begin
    if g_HighPKPointHuman <> nil then
    begin
      sText := TPlayObject(g_HighPKPointHuman).GetMyInfo;
    end else sText := '????';
    sMsg := sub_49ADB8(sMsg, '<$HIGHPKINFO>', sText);
    Exit;
  end;
  if sVariable = '$HIGHDCINFO' then
  begin
    if g_HighDCHuman <> nil then
    begin
      sText := TPlayObject(g_HighDCHuman).GetMyInfo;
    end else sText := '????';
    sMsg := sub_49ADB8(sMsg, '<$HIGHDCINFO>', sText);
    Exit;
  end;
  if sVariable = '$HIGHMCINFO' then
  begin
    if g_HighMCHuman <> nil then
    begin
      sText := TPlayObject(g_HighMCHuman).GetMyInfo;
    end else sText := '????';
    sMsg := sub_49ADB8(sMsg, '<$HIGHMCINFO>', sText);
    Exit;
  end;
  if sVariable = '$HIGHSCINFO' then
  begin
    if g_HighSCHuman <> nil then
    begin
      sText := TPlayObject(g_HighSCHuman).GetMyInfo;
    end else sText := '????';
    sMsg := sub_49ADB8(sMsg, '<$HIGHSCINFO>', sText);
    Exit;
  end;
  if sVariable = '$HIGHONLINEINFO' then
  begin
    if g_HighOnlineHuman <> nil then
    begin
      sText := TPlayObject(g_HighOnlineHuman).GetMyInfo;
    end else sText := '????';
    sMsg := sub_49ADB8(sMsg, '<$HIGHONLINEINFO>', sText);
    Exit;
  end;



//个人信息
  if sVariable = '$USERNAME' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$USERNAME>', PlayObject.m_sCharName);
    Exit;
  end;
  if sVariable = '$GUILDNAME' then
  begin
    if PlayObject.m_MyGuild <> nil then
    begin
      sMsg := sub_49ADB8(sMsg, '<$GUILDNAME>', TGUild(PlayObject.m_MyGuild).sGuildName);
    end else
    begin
      sMsg := '无';
    end;
    Exit;
  end;
  if sVariable = '$RANKNAME' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$RANKNAME>', PlayObject.m_sGuildRankName);
    Exit;
  end;

  if sVariable = '$LEVEL' then
  begin
    sText := IntToStr(PlayObject.m_Abil.Level);
    sMsg := sub_49ADB8(sMsg, '<$LEVEL>', sText);
    Exit;
  end;

  if sVariable = '$HP' then
  begin
    sText := IntToStr(PlayObject.m_WAbil.HP);
    sMsg := sub_49ADB8(sMsg, '<$HP>', sText);
    Exit;
  end;
  if sVariable = '$MAXHP' then
  begin
    sText := IntToStr(PlayObject.m_WAbil.MaxHP);
    sMsg := sub_49ADB8(sMsg, '<$MAXHP>', sText);
    Exit;
  end;

  if sVariable = '$MP' then
  begin
    sText := IntToStr(PlayObject.m_WAbil.MP);
    sMsg := sub_49ADB8(sMsg, '<$MP>', sText);
    Exit;
  end;
  if sVariable = '$MAXMP' then
  begin
    sText := IntToStr(PlayObject.m_WAbil.MaxMP);
    sMsg := sub_49ADB8(sMsg, '<$MAXMP>', sText);
    Exit;
  end;

  if sVariable = '$AC' then
  begin
    sText := IntToStr(LoWord(PlayObject.m_WAbil.AC));
    sMsg := sub_49ADB8(sMsg, '<$AC>', sText);
    Exit;
  end;
  if sVariable = '$MAXAC' then
  begin
    sText := IntToStr(HiWord(PlayObject.m_WAbil.AC));
    sMsg := sub_49ADB8(sMsg, '<$MAXAC>', sText);
    Exit;
  end;
  if sVariable = '$MAC' then
  begin
    sText := IntToStr(LoWord(PlayObject.m_WAbil.MAC));
    sMsg := sub_49ADB8(sMsg, '<$MAC>', sText);
    Exit;
  end;
  if sVariable = '$MAXMAC' then
  begin
    sText := IntToStr(HiWord(PlayObject.m_WAbil.MAC));
    sMsg := sub_49ADB8(sMsg, '<$MAXMAC>', sText);
    Exit;
  end;

  if sVariable = '$DC' then
  begin
    sText := IntToStr(LoWord(PlayObject.m_WAbil.DC));
    sMsg := sub_49ADB8(sMsg, '<$DC>', sText);
    Exit;
  end;
  if sVariable = '$MAXDC' then
  begin
    sText := IntToStr(HiWord(PlayObject.m_WAbil.DC));
    sMsg := sub_49ADB8(sMsg, '<$MAXDC>', sText);
    Exit;
  end;

  if sVariable = '$MC' then
  begin
    sText := IntToStr(LoWord(PlayObject.m_WAbil.MC));
    sMsg := sub_49ADB8(sMsg, '<$MC>', sText);
    Exit;
  end;
  if sVariable = '$MAXMC' then
  begin
    sText := IntToStr(HiWord(PlayObject.m_WAbil.MC));
    sMsg := sub_49ADB8(sMsg, '<$MAXMC>', sText);
    Exit;
  end;

  if sVariable = '$SC' then
  begin
    sText := IntToStr(LoWord(PlayObject.m_WAbil.SC));
    sMsg := sub_49ADB8(sMsg, '<$SC>', sText);
    Exit;
  end;
  if sVariable = '$MAXSC' then
  begin
    sText := IntToStr(HiWord(PlayObject.m_WAbil.SC));
    sMsg := sub_49ADB8(sMsg, '<$MAXSC>', sText);
    Exit;
  end;

  if sVariable = '$EXP' then
  begin
    sText := IntToStr(PlayObject.m_Abil.Exp);
    sMsg := sub_49ADB8(sMsg, '<$EXP>', sText);
    Exit;
  end;
  if sVariable = '$MAXEXP' then
  begin
    sText := IntToStr(PlayObject.m_Abil.MaxExp);
    sMsg := sub_49ADB8(sMsg, '<$MAXEXP>', sText);
    Exit;
  end;

  if sVariable = '$PKPOINT' then
  begin
    sText := IntToStr(PlayObject.m_nPkPoint);
    sMsg := sub_49ADB8(sMsg, '<$PKPOINT>', sText);
    Exit;
  end;
  if sVariable = '$CREDITPOINT' then
  begin
    sText := IntToStr(PlayObject.m_btCreditPoint);
    sMsg := sub_49ADB8(sMsg, '<$CREDITPOINT>', sText);
    Exit;
  end;

  if sVariable = '$HW' then
  begin
    sText := IntToStr(PlayObject.m_WAbil.HandWeight);
    sMsg := sub_49ADB8(sMsg, '<$HW>', sText);
    Exit;
  end;
  if sVariable = '$MAXHW' then
  begin
    sText := IntToStr(PlayObject.m_WAbil.MaxHandWeight);
    sMsg := sub_49ADB8(sMsg, '<$MAXHW>', sText);
    Exit;
  end;

  if sVariable = '$BW' then
  begin
    sText := IntToStr(PlayObject.m_WAbil.Weight);
    sMsg := sub_49ADB8(sMsg, '<$BW>', sText);
    Exit;
  end;
  if sVariable = '$MAXBW' then
  begin
    sText := IntToStr(PlayObject.m_WAbil.MaxWeight);
    sMsg := sub_49ADB8(sMsg, '<$MAXBW>', sText);
    Exit;
  end;

  if sVariable = '$WW' then
  begin
    sText := IntToStr(PlayObject.m_WAbil.WearWeight);
    sMsg := sub_49ADB8(sMsg, '<$WW>', sText);
    Exit;
  end;
  if sVariable = '$MAXWW' then
  begin
    sText := IntToStr(PlayObject.m_WAbil.MaxWearWeight);
    sMsg := sub_49ADB8(sMsg, '<$MAXWW>', sText);
    Exit;
  end;

  if sVariable = '$GOLDCOUNT' then
  begin
    sText := IntToStr(PlayObject.m_nGold) + '/' + IntToStr(PlayObject.m_nGoldMax);
    sMsg := sub_49ADB8(sMsg, '<$GOLDCOUNT>', sText);
    Exit;
  end;
  if sVariable = '$GAMEGOLD' then
  begin
    sText := IntToStr(PlayObject.m_nGameGold);
    sMsg := sub_49ADB8(sMsg, '<$GAMEGOLD>', sText);
    Exit;
  end;
  if sVariable = '$GAMEPOINT' then
  begin
    sText := IntToStr(PlayObject.m_nGamePoint);
    sMsg := sub_49ADB8(sMsg, '<$GAMEPOINT>', sText);
    Exit;
  end;
  if sVariable = '$HUNGER' then
  begin
    sText := IntToStr(PlayObject.GetMyStatus);
    sMsg := sub_49ADB8(sMsg, '<$HUNGER>', sText);
    Exit;
  end;
  if sVariable = '$LOGINTIME' then
  begin
    sText := DateTimeToStr(PlayObject.m_dLogonTime);
    sMsg := sub_49ADB8(sMsg, '<$LOGINTIME>', sText);
    Exit;
  end;
  if sVariable = '$LOGINLONG' then
  begin
    sText := IntToStr((GetTickCount - PlayObject.m_dwLogonTick) div 60000) + '分钟';
    sMsg := sub_49ADB8(sMsg, '<$LOGINLONG>', sText);
    Exit;
  end;
  if sVariable = '$DRESS' then
  begin
    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_DRESS].wIndex);
    sMsg := sub_49ADB8(sMsg, '<$DRESS>', sText);
    Exit;
  end else
    if sVariable = '$WEAPON' then
    begin
      sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_WEAPON].wIndex);
      sMsg := sub_49ADB8(sMsg, '<$WEAPON>', sText);
      Exit;
    end else
      if sVariable = '$RIGHTHAND' then
      begin
        sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RIGHTHAND].wIndex);
        sMsg := sub_49ADB8(sMsg, '<$RIGHTHAND>', sText);
        Exit;
      end else
        if sVariable = '$HELMET' then
        begin
          sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_HELMET].wIndex);
          sMsg := sub_49ADB8(sMsg, '<$HELMET>', sText);
          Exit;
        end else
          if sVariable = '$NECKLACE' then
          begin
            sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_NECKLACE].wIndex);
            sMsg := sub_49ADB8(sMsg, '<$NECKLACE>', sText);
            Exit;
          end else
            if sVariable = '$RING_R' then
            begin
              sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RINGR].wIndex);
              sMsg := sub_49ADB8(sMsg, '<$RING_R>', sText);
              Exit;
            end else
              if sVariable = '$RING_L' then
              begin
                sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RINGL].wIndex);
                sMsg := sub_49ADB8(sMsg, '<$RING_L>', sText);
                Exit;
              end else
                if sVariable = '$ARMRING_R' then
                begin
                  sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_ARMRINGR].wIndex);
                  sMsg := sub_49ADB8(sMsg, '<$ARMRING_R>', sText);
                  Exit;
                end else
                  if sVariable = '$ARMRING_L' then
                  begin
                    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_ARMRINGL].wIndex);
                    sMsg := sub_49ADB8(sMsg, '<$ARMRING_L>', sText);
                    Exit;
                  end else
                    if sVariable = '$BUJUK' then
                    begin
                      sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BUJUK].wIndex);
                      sMsg := sub_49ADB8(sMsg, '<$BUJUK>', sText);
                      Exit;
                    end else
                    
//取消1.70版增加的3个物品
{
                      if sVariable = '$BELT' then
                      begin
                        sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BELT].wIndex);
                        sMsg := sub_49ADB8(sMsg, '<$BELT>', sText);
                        Exit;
                      end else
                        if sVariable = '$BOOTS' then
                        begin
                          sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BOOTS].wIndex);
                          sMsg := sub_49ADB8(sMsg, '<$BOOTS>', sText);
                          Exit;
                        end else
                          if sVariable = '$CHARM' then
                          begin
                            sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_CHARM].wIndex);
                            sMsg := sub_49ADB8(sMsg, '<$CHARM>', sText);
                            Exit;
                          end else
}                          
                            if sVariable = '$IPADDR' then
                            begin
                              sText := PlayObject.m_sIPaddr;
                              sMsg := sub_49ADB8(sMsg, '<$IPADDR>', sText);
                              Exit;
                            end else
                              if sVariable = '$IPLOCAL' then
                              begin
                                sText := PlayObject.m_sIPLocal; // GetIPLocal(PlayObject.m_sIPaddr);
                                sMsg := sub_49ADB8(sMsg, '<$IPLOCAL>', sText);
                                Exit;
                              end else
                                if sVariable = '$GUILDBUILDPOINT' then
                                begin
                                  if PlayObject.m_MyGuild = nil then
                                  begin
                                    sText := '无';
                                  end else
                                  begin
                                    sText := IntToStr(TGUild(PlayObject.m_MyGuild).nBuildPoint);
                                  end;
                                  sMsg := sub_49ADB8(sMsg, '<$GUILDBUILDPOINT>', sText);
                                  Exit;
                                end else
                                  if sVariable = '$GUILDAURAEPOINT' then
                                  begin
                                    if PlayObject.m_MyGuild = nil then
                                    begin
                                      sText := '无';
                                    end else
                                    begin
                                      sText := IntToStr(TGUild(PlayObject.m_MyGuild).nAurae);
                                    end;
                                    sMsg := sub_49ADB8(sMsg, '<$GUILDAURAEPOINT>', sText);
                                    Exit;
                                  end else
                                    if sVariable = '$GUILDSTABILITYPOINT' then
                                    begin
                                      if PlayObject.m_MyGuild = nil then
                                      begin
                                        sText := '无';
                                      end else
                                      begin
                                        sText := IntToStr(TGUild(PlayObject.m_MyGuild).nStability);
                                      end;
                                      sMsg := sub_49ADB8(sMsg, '<$GUILDSTABILITYPOINT>', sText);
                                      Exit;
                                    end;
  if sVariable = '$GUILDFLOURISHPOINT' then
  begin
    if PlayObject.m_MyGuild = nil then
    begin
      sText := '无';
    end else
    begin
      sText := IntToStr(TGUild(PlayObject.m_MyGuild).nFlourishing);
    end;
    sMsg := sub_49ADB8(sMsg, '<$GUILDFLOURISHPOINT>', sText);
    Exit;
  end;

//其它信息
  if sVariable = '$REQUESTCASTLEWARITEM' then
  begin
    sText := g_Config.sZumaPiece;
    sMsg := sub_49ADB8(sMsg, '<$REQUESTCASTLEWARITEM>', sText);
    Exit;
  end;
  if sVariable = '$REQUESTCASTLEWARDAY' then
  begin
    sText := g_Config.sZumaPiece;
    sMsg := sub_49ADB8(sMsg, '<$REQUESTCASTLEWARDAY>', sText);
    Exit;
  end;
  if sVariable = '$REQUESTBUILDGUILDITEM' then
  begin
    sText := g_Config.sWomaHorn;
    sMsg := sub_49ADB8(sMsg, '<$REQUESTBUILDGUILDITEM>', sText);
    Exit;
  end;
  if sVariable = '$OWNERGUILD' then
  begin
    if m_Castle <> nil then
    begin
      sText := TUserCastle(m_Castle).m_sOwnGuild;
      if sText = '' then sText := '游戏管理';
    end else
    begin
      sText := '????';
    end;
    sMsg := sub_49ADB8(sMsg, '<$OWNERGUILD>', sText);
    Exit;
  end; //0049AF32

  if sVariable = '$CASTLENAME' then
  begin
    if m_Castle <> nil then
    begin
      sText := TUserCastle(m_Castle).m_sName;
    end else
    begin
      sText := '????';
    end;
    sMsg := sub_49ADB8(sMsg, '<$CASTLENAME>', sText);
    Exit;
  end;
  if sVariable = '$LORD' then
  begin
    if m_Castle <> nil then
    begin
      if TUserCastle(m_Castle).m_MasterGuild <> nil then
      begin
        sText := TUserCastle(m_Castle).m_MasterGuild.GetChiefName();
      end else sText := '管理员';
    end else
    begin
      sText := '????';
    end;
    sMsg := sub_49ADB8(sMsg, '<$LORD>', sText);
    Exit;
  end; //0049AF32

  if sVariable = '$GUILDWARFEE' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$GUILDWARFEE>', IntToStr(g_Config.nGuildWarPrice));
    Exit;
  end;
  if sVariable = '$BUILDGUILDFEE' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$BUILDGUILDFEE>', IntToStr(g_Config.nBuildGuildPrice));
    Exit;
  end;

  if sVariable = '$CASTLEWARDATE' then
  begin
    if m_Castle = nil then
    begin
      m_Castle := g_CastleManager.GetCastle(0);
    end;
    if m_Castle <> nil then
    begin
      if not TUserCastle(m_Castle).m_boUnderWar then
      begin
        sText := TUserCastle(m_Castle).GetWarDate();
        if sText <> '' then
        begin
          sMsg := sub_49ADB8(sMsg, '<$CASTLEWARDATE>', sText);
        end else sMsg := '暂时没有行会攻城！！！\ \<返回/@main>';
      end else sMsg := '现正在攻城中！！！\ \<返回/@main>';
    end else
    begin
      sText := '????';
    end;
    Exit;
  end;

  if sVariable = '$LISTOFWAR' then
  begin
    if m_Castle <> nil then
    begin
      sText := TUserCastle(m_Castle).GetAttackWarList();
    end else
    begin
      sText := '????';
    end;
    if sText <> '' then
    begin
      sMsg := sub_49ADB8(sMsg, '<$LISTOFWAR>', sText);
    end else sMsg := '现在没有行会申请攻城战...\ \<返回/@main>';
    Exit;
  end;

  if sVariable = '$CASTLECHANGEDATE' then
  begin
    if m_Castle <> nil then
    begin
      sText := DateTimeToStr(TUserCastle(m_Castle).m_ChangeDate);
    end else
    begin
      sText := '????';
    end;
    sMsg := sub_49ADB8(sMsg, '<$CASTLECHANGEDATE>', sText);
    Exit;
  end;

  if sVariable = '$CASTLEWARLASTDATE' then
  begin
    if m_Castle <> nil then
    begin
      sText := DateTimeToStr(TUserCastle(m_Castle).m_WarDate);
    end else
    begin
      sText := '????';
    end;
    sMsg := sub_49ADB8(sMsg, '<$CASTLEWARLASTDATE>', sText);
    Exit;
  end;
  if sVariable = '$CASTLEGETDAYS' then
  begin
    if m_Castle <> nil then
    begin
      sText := IntToStr(GetDayCount(Now, TUserCastle(m_Castle).m_ChangeDate));
    end else
    begin
      sText := '????';
    end;
    sMsg := sub_49ADB8(sMsg, '<$CASTLEGETDAYS>', sText);
    Exit;
  end;

  if sVariable = '$CMD_DATE' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_DATE>', g_GameCommand.Data.sCmd);
    Exit;
  end;
  if sVariable = '$CMD_ALLOWMSG' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_ALLOWMSG>', g_GameCommand.ALLOWMSG.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_LETSHOUT' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_LETSHOUT>', g_GameCommand.LETSHOUT.sCmd);
    Exit;
  end;
  if sVariable = '$CMD_LETTRADE' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_LETTRADE>', g_GameCommand.LETTRADE.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_LETGUILD' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_LETGUILD>', g_GameCommand.LETGUILD.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_ENDGUILD' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_ENDGUILD>', g_GameCommand.ENDGUILD.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_BANGUILDCHAT' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_BANGUILDCHAT>', g_GameCommand.BANGUILDCHAT.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_AUTHALLY' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_AUTHALLY>', g_GameCommand.AUTHALLY.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_AUTH' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_AUTH>', g_GameCommand.AUTH.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_AUTHCANCEL' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_AUTHCANCEL>', g_GameCommand.AUTHCANCEL.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_USERMOVE' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_USERMOVE>', g_GameCommand.USERMOVE.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_SEARCHING' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_SEARCHING>', g_GameCommand.SEARCHING.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_ALLOWGROUPCALL' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_ALLOWGROUPCALL>', g_GameCommand.ALLOWGROUPCALL.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_GROUPRECALLL' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_GROUPRECALLL>', g_GameCommand.GROUPRECALLL.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_ATTACKMODE' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_ATTACKMODE>', g_GameCommand.ATTACKMODE.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_REST' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_REST>', g_GameCommand.REST.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_STORAGESETPASSWORD' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_STORAGESETPASSWORD>', g_GameCommand.SETPASSWORD.sCmd);
    Exit;
  end;
  if sVariable = '$CMD_STORAGECHGPASSWORD' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_STORAGECHGPASSWORD>', g_GameCommand.CHGPASSWORD.sCmd);
    Exit;
  end;
  if sVariable = '$CMD_STORAGELOCK' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_STORAGELOCK>', g_GameCommand.Lock.sCmd);
    Exit;
  end;
  if sVariable = '$CMD_STORAGEUNLOCK' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_STORAGEUNLOCK>', g_GameCommand.UNLOCKSTORAGE.sCmd);
    Exit;
  end;
  if sVariable = '$CMD_UNLOCK' then
  begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_UNLOCK>', g_GameCommand.UnLock.sCmd);
    Exit;
  end;
  if CompareLStr(sVariable, '$HUMAN(', Length('$HUMAN(')) then
  begin
    ArrestStringEx(sVariable, '(', ')', s14);
    boFoundVar := False;
    for i := 0 to PlayObject.m_DynamicVarList.Count - 1 do
    begin
      DynamicVar := PlayObject.m_DynamicVarList.Items[i];
      if CompareText(DynamicVar.sName, s14) = 0 then
      begin
        case DynamicVar.VarType of
          vInteger:
            begin
              sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(DynamicVar.nInternet));
              boFoundVar := True;
            end;
          vString:
            begin
              sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', DynamicVar.sString);
              boFoundVar := True;
            end;
        end;
        Break;
      end;
    end;
    if not boFoundVar then sMsg := '??';

    Exit;
  end;
  if CompareLStr(sVariable, '$GUILD(', Length('$GUILD(')) then
  begin
    if PlayObject.m_MyGuild = nil then Exit;
    ArrestStringEx(sVariable, '(', ')', s14);
    boFoundVar := False;
    for i := 0 to TGUild(PlayObject.m_MyGuild).m_DynamicVarList.Count - 1 do
    begin
      DynamicVar := TGUild(PlayObject.m_MyGuild).m_DynamicVarList.Items[i];
      if CompareText(DynamicVar.sName, s14) = 0 then
      begin
        case DynamicVar.VarType of
          vInteger:
            begin
              sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(DynamicVar.nInternet));
              boFoundVar := True;
            end;
          vString:
            begin
              sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', DynamicVar.sString);
              boFoundVar := True;
            end;
        end;
        Break;
      end;
    end;
    if not boFoundVar then sMsg := '??';
    Exit;
  end;
  if CompareLStr(sVariable, '$GLOBAL(', Length('$GLOBAL(')) then
  begin
    ArrestStringEx(sVariable, '(', ')', s14);
    boFoundVar := False;
    for i := 0 to g_DynamicVarList.Count - 1 do
    begin
      DynamicVar := g_DynamicVarList.Items[i];
      if CompareText(DynamicVar.sName, s14) = 0 then
      begin
        case DynamicVar.VarType of
          vInteger:
            begin
              sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(DynamicVar.nInternet));
              boFoundVar := True;
            end;
          vString:
            begin
              sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', DynamicVar.sString);
              boFoundVar := True;
            end;
        end;
        Break;
      end;
    end;
    if not boFoundVar then sMsg := '??';
    Exit;
  end;
  if CompareLStr(sVariable, '$STR(', Length('$STR(')) then
  begin
    ArrestStringEx(sVariable, '(', ')', s14);
    n18 := GetValNameNo(s14);
    if n18 >= 0 then
    begin
      case n18 of
        0..9:
          begin
            sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(PlayObject.m_nVal[n18]));
          end;
        100..119:
          begin
            sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(g_Config.GlobalVal[n18 - 100]));
          end;
        200..209:
          begin
            sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(PlayObject.m_DyVal[n18 - 200]));
          end;
        300..399:
          begin
            sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(PlayObject.m_nMval[n18 - 300]));
          end;
        400..499:
          begin
            sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(g_Config.GlobaDyMval[n18 - 400]));
          end;
      end;
    end;
  end;
end;

procedure TNormNpc.GotoLable(PlayObject: TPlayObject; sLabel: string; boExtJmp: Boolean); //0049E584
var
  i, ii, III: Integer;
  List1C: TStringList;
  bo11: Boolean;
  n18: Integer;
  n20: Integer;
  sSENDMSG: string;
  Script: pTScript;
  Script3C: pTScript;
  SayingRecord: pTSayingRecord;
  SayingProcedure: pTSayingProcedure;
  UserItem: pTUserItem;
  SC: string;
  function CheckQuestStatus(ScriptInfo: pTScript): Boolean; //0049BA00
  var
    i: Integer;
  begin
    Result := True;
    if not ScriptInfo.boQuest then Exit;
    i := 0;
    while (True) do
    begin
      if (ScriptInfo.QuestInfo[i].nRandRage > 0) and (Random(ScriptInfo.QuestInfo[i].nRandRage) <> 0) then
      begin
        Result := False;
        Break;
      end;
      if PlayObject.GetQuestFalgStatus(ScriptInfo.QuestInfo[i].wFlag) <> ScriptInfo.QuestInfo[i].btValue then
      begin
        Result := False;
        Break;
      end;
      Inc(i);
      if i >= 10 then Break;
    end; // while
  end;

  function CheckItemW(sItemType: string; nParam: Integer): pTUserItem; //0049BA7C
  var
    nCount: Integer;
  begin
    Result := nil;
    if CompareLStr(sItemType, '[NECKLACE]', 4) then
    begin
      if PlayObject.m_UseItems[U_NECKLACE].wIndex > 0 then
      begin
        Result := @PlayObject.m_UseItems[U_NECKLACE];
      end;
      Exit;
    end;
    if CompareLStr(sItemType, '[RING]', 4) then
    begin
      if PlayObject.m_UseItems[U_RINGL].wIndex > 0 then
      begin
        Result := @PlayObject.m_UseItems[U_RINGL];
      end;
      if PlayObject.m_UseItems[U_RINGR].wIndex > 0 then
      begin
        Result := @PlayObject.m_UseItems[U_RINGR];
      end;
      Exit;
    end;
    if CompareLStr(sItemType, '[ARMRING]', 4) then
    begin
      if PlayObject.m_UseItems[U_ARMRINGL].wIndex > 0 then
      begin
        Result := @PlayObject.m_UseItems[U_ARMRINGL];
      end;
      if PlayObject.m_UseItems[U_ARMRINGR].wIndex > 0 then
      begin
        Result := @PlayObject.m_UseItems[U_ARMRINGR];
      end;
      Exit;
    end;
    if CompareLStr(sItemType, '[WEAPON]', 4) then
    begin
      if PlayObject.m_UseItems[U_WEAPON].wIndex > 0 then
      begin
        Result := @PlayObject.m_UseItems[U_WEAPON];
      end;
      Exit;
    end;
    if CompareLStr(sItemType, '[HELMET]', 4) then
    begin
      if PlayObject.m_UseItems[U_HELMET].wIndex > 0 then
      begin
        Result := @PlayObject.m_UseItems[U_HELMET];
      end;
      Exit;
    end;

    if CompareLStr(sItemType, '[BUJUK]', 4) then
    begin
      if PlayObject.m_UseItems[U_BUJUK].wIndex > 0 then
      begin
        Result := @PlayObject.m_UseItems[U_BUJUK];
      end;
      Exit;
    end;

//取消1.70版增加的3个物品
{
    if CompareLStr(sItemType, '[BELT]', 4) then
    begin
      if PlayObject.m_UseItems[U_BELT].wIndex > 0 then
      begin
        Result := @PlayObject.m_UseItems[U_BELT];
      end;
      Exit;
    end;
    if CompareLStr(sItemType, '[BOOTS]', 4) then
    begin
      if PlayObject.m_UseItems[U_BOOTS].wIndex > 0 then
      begin
        Result := @PlayObject.m_UseItems[U_BOOTS];
      end;
      Exit;
    end;
    if CompareLStr(sItemType, '[CHARM]', 4) then
    begin
      if PlayObject.m_UseItems[U_CHARM].wIndex > 0 then
      begin
        Result := @PlayObject.m_UseItems[U_CHARM];
      end;
      Exit;
    end;

}

    Result := PlayObject.sub_4C4CD4(sItemType, nCount);
    if nCount < nParam then
      Result := nil;
  end;
  function CheckStringList(sHumName, sListFileName: string): Boolean; //0049B47C
  var
    i: Integer;
    LoadList: TStringList;
  begin
    Result := False;
    sListFileName := g_Config.sEnvirDir + sListFileName;
    if FileExists(sListFileName) then
    begin
      LoadList := TStringList.Create;
      try
        LoadList.LoadFromFile(sListFileName);
      except
        MainOutMessage('loading fail.... => ' + sListFileName);
      end;
      for i := 0 to LoadList.Count - 1 do
      begin
        if CompareText(Trim(LoadList.Strings[i]), sHumName) = 0 then
        begin
          Result := True;
          Break;
        end;
      end;
      LoadList.Free;
    end else
    begin
      MainOutMessage('file not found => ' + sListFileName);
    end;
  end;
  function QuestCheckCondition(ConditionList: TList): Boolean; //0049BCA8
  var
    i: Integer;
    QuestConditionInfo: pTQuestConditionInfo;
    n10, n14, n18, n1C, nMaxDura, nDura: Integer;
    Hour, Min, Sec, MSec: Word;
    Envir: TEnvirnoment;
    StdItem: TItem;
  begin
    Result := True;
    for i := 0 to ConditionList.Count - 1 do
    begin
      QuestConditionInfo := ConditionList.Items[i];
      case QuestConditionInfo.nCMDCode of //
        nCHECK:
          begin
            n14 := Str_ToInt(QuestConditionInfo.sParam1, 0);
            n18 := Str_ToInt(QuestConditionInfo.sParam2, 0);
            n10 := PlayObject.GetQuestFalgStatus(n14);
            if n10 = 0 then
            begin
              if n18 <> 0 then Result := False;
            end else
            begin
              if n18 = 0 then Result := False;
            end;
          end;
        nRANDOM:
          begin
            if Random(QuestConditionInfo.nParam1) <> 0 then
              Result := False;
          end;
        nGENDER:
          begin
            if CompareText(QuestConditionInfo.sParam1, sMAN) = 0 then
            begin
              if PlayObject.m_btGender <> gMan then Result := False;
            end else
            begin
              if PlayObject.m_btGender <> gWoMan then Result := False;
            end;
          end;
        nDAYTIME:
          begin
            if CompareText(QuestConditionInfo.sParam1, sSUNRAISE) = 0 then
            begin
              if g_nGameTime <> 0 then Result := False;
            end;
            if CompareText(QuestConditionInfo.sParam1, sDAY) = 0 then
            begin
              if g_nGameTime <> 1 then Result := False;
            end;
            if CompareText(QuestConditionInfo.sParam1, sSUNSET) = 0 then
            begin
              if g_nGameTime <> 2 then Result := False;
            end;
            if CompareText(QuestConditionInfo.sParam1, sNIGHT) = 0 then
            begin
              if g_nGameTime <> 3 then Result := False;
            end;
          end;
        nCHECKOPEN:
          begin
            n14 := Str_ToInt(QuestConditionInfo.sParam1, 0);
            n18 := Str_ToInt(QuestConditionInfo.sParam2, 0);
            n10 := PlayObject.GetQuestUnitOpenStatus(n14);
            if n10 = 0 then
            begin
              if n18 <> 0 then Result := False;
            end else
            begin
              if n18 = 0 then Result := False;
            end;
          end;
        nCHECKUNIT:
          begin
            n14 := Str_ToInt(QuestConditionInfo.sParam1, 0);
            n18 := Str_ToInt(QuestConditionInfo.sParam2, 0);
            n10 := PlayObject.GetQuestUnitStatus(n14);
            if n10 = 0 then
            begin
              if n18 <> 0 then Result := False;
            end else
            begin
              if n18 = 0 then Result := False;
            end;
          end;
        nCHECKLEVEL: if PlayObject.m_Abil.Level < QuestConditionInfo.nParam1 then Result := False;
        nCHECKJOB:
          begin
            if CompareLStr(QuestConditionInfo.sParam1, sWarrior, Length(sWarrior)) then
            begin
              if PlayObject.m_btJob <> jWarr then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sWizard, Length(sWizard)) then
            begin
              if PlayObject.m_btJob <> jWizard then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sTaos, Length(sTaos)) then
            begin
              if PlayObject.m_btJob <> jTaos then Result := False;
            end;
          end;
        nCHECKBBCOUNT: if PlayObject.m_SlaveList.Count < QuestConditionInfo.nParam1 then Result := False;
        nCHECKCREDITPOINT: ;
        nCHECKITEM:
          begin
            UserItem := PlayObject.QuestCheckItem(QuestConditionInfo.sParam1, n1C, nMaxDura, nDura);
            if n1C < QuestConditionInfo.nParam2 then
              Result := False;
          end;
        nCHECKITEMW:
          begin
            UserItem := CheckItemW(QuestConditionInfo.sParam1, QuestConditionInfo.nParam2);
            if UserItem = nil then
              Result := False;
          end;
        nCHECKGOLD: if PlayObject.m_nGold < QuestConditionInfo.nParam1 then Result := False;
        nISTAKEITEM: if SC <> QuestConditionInfo.sParam1 then Result := False;
        nCHECKDURA:
          begin
            UserItem := PlayObject.QuestCheckItem(QuestConditionInfo.sParam1, n1C, nMaxDura, nDura);
            if Round(nDura / 1000) < QuestConditionInfo.nParam2 then
              Result := False;
          end;
        nCHECKDURAEVA:
          begin
            UserItem := PlayObject.QuestCheckItem(QuestConditionInfo.sParam1, n1C, nMaxDura, nDura);
            if n1C > 0 then
            begin
              if Round(nMaxDura / n1C / 1000) < QuestConditionInfo.nParam2 then
                Result := False;
            end else Result := False;
          end;
        nDAYOFWEEK:
          begin
            if CompareLStr(QuestConditionInfo.sParam1, sSUN, Length(sSUN)) then
            begin
              if DayOfWeek(Now) <> 1 then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sMON, Length(sMON)) then
            begin
              if DayOfWeek(Now) <> 2 then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sTUE, Length(sTUE)) then
            begin
              if DayOfWeek(Now) <> 3 then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sWED, Length(sWED)) then
            begin
              if DayOfWeek(Now) <> 4 then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sTHU, Length(sTHU)) then
            begin
              if DayOfWeek(Now) <> 5 then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sFRI, Length(sFRI)) then
            begin
              if DayOfWeek(Now) <> 6 then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sSAT, Length(sSAT)) then
            begin
              if DayOfWeek(Now) <> 7 then Result := False;
            end;
          end;
        nHOUR:
          begin
            if (QuestConditionInfo.nParam1 <> 0) and (QuestConditionInfo.nParam2 = 0) then
              QuestConditionInfo.nParam2 := QuestConditionInfo.nParam1;
            DecodeTime(Time, Hour, Min, Sec, MSec);
            if (Hour < QuestConditionInfo.nParam1) or (Hour > QuestConditionInfo.nParam2) then
              Result := False;
          end;
        nMIN:
          begin
            if (QuestConditionInfo.nParam1 <> 0) and (QuestConditionInfo.nParam2 = 0) then
              QuestConditionInfo.nParam2 := QuestConditionInfo.nParam1;
            DecodeTime(Time, Hour, Min, Sec, MSec);
            if (Min < QuestConditionInfo.nParam1) or (Min > QuestConditionInfo.nParam2) then
              Result := False;
          end;
        nCHECKPKPOINT: if PlayObject.PKLevel < QuestConditionInfo.nParam1 then Result := False;

        nCHECKLUCKYPOINT: if PlayObject.m_nBodyLuckLevel < QuestConditionInfo.nParam1 then Result := False;
        nCHECKMONMAP:
          begin
            Envir := g_MapManager.FindMap(QuestConditionInfo.sParam1);
            if Envir <> nil then
            begin
              if UserEngine.GetMapMonster(Envir, nil) < QuestConditionInfo.nParam2 then Result := False;
            end;

          end;
        nCHECKMONAREA: ;
        nCHECKHUM:
          begin //0049C4CB
            if UserEngine.GetMapHuman(QuestConditionInfo.sParam1) < QuestConditionInfo.nParam2 then Result := False;
          end;

        nCHECKBAGGAGE:
          begin
            if PlayObject.IsEnoughBag then
            begin
              if QuestConditionInfo.sParam1 <> '' then
              begin
                Result := False;
                StdItem := UserEngine.GetStdItem(QuestConditionInfo.sParam1);
                if StdItem <> nil then
                begin
                  if PlayObject.IsAddWeightAvailable(StdItem.Weight) then
                    Result := True;
                end;
              end;
            end else Result := False;
          end;
        nCHECKNAMELIST: if not CheckStringList(PlayObject.m_sCharName, m_sPath + QuestConditionInfo.sParam1) then Result := False;
        nCHECKACCOUNTLIST: if not CheckStringList(PlayObject.m_sUserID, m_sPath + QuestConditionInfo.sParam1) then Result := False;
        nCHECKIPLIST: if not CheckStringList(PlayObject.m_sIPaddr, m_sPath + QuestConditionInfo.sParam1) then Result := False;
        nEQUAL:
          begin //0049C5AC
            n10 := GetValNameNo(QuestConditionInfo.sParam1);
            if n10 >= 0 then
            begin
              case n10 of //
                0..9:
                  begin
                    if PlayObject.m_nVal[n10] <> QuestConditionInfo.nParam2 then Result := False;
                  end;
                100..119:
                  begin
                    if g_Config.GlobalVal[n10 - 100] <> QuestConditionInfo.nParam2 then Result := False;
                  end;
                200..209:
                  begin
                    if PlayObject.m_DyVal[n10 - 200] <> QuestConditionInfo.nParam2 then Result := False;
                  end;
                300..399:
                  begin
                    if PlayObject.m_nMval[n10 - 300] <> QuestConditionInfo.nParam2 then Result := False;
                  end;
                400..499:
                  begin
                    if g_Config.GlobaDyMval[n10 - 400] <> QuestConditionInfo.nParam2 then Result := False;
                  end;
              end; // case
            end else Result := False;
          end;
        nLARGE:
          begin //0049C658
            n10 := GetValNameNo(QuestConditionInfo.sParam1);
            if n10 >= 0 then
            begin
              case n10 of //
                0..9:
                  begin
                    if PlayObject.m_nVal[n10] <= QuestConditionInfo.nParam2 then Result := False;
                  end;
                100..119:
                  begin
                    if g_Config.GlobalVal[n10 - 100] <= QuestConditionInfo.nParam2 then Result := False;
                  end;
                200..209:
                  begin
                    if PlayObject.m_DyVal[n10 - 200] <= QuestConditionInfo.nParam2 then Result := False;
                  end;
                300..399:
                  begin
                    if PlayObject.m_nMval[n10 - 300] <= QuestConditionInfo.nParam2 then Result := False;
                  end;
                400..499:
                  begin
                    if g_Config.GlobaDyMval[n10 - 400] <= QuestConditionInfo.nParam2 then Result := False;
                  end;
              end; // case
            end else Result := False;
          end;

        nSMALL:
          begin //0049C704
            n10 := GetValNameNo(QuestConditionInfo.sParam1);
            if n10 >= 0 then
            begin
              case n10 of //
                0..9:
                  begin
                    if PlayObject.m_nVal[n10] >= QuestConditionInfo.nParam2 then Result := False;
                  end;
                100..119:
                  begin
                    if g_Config.GlobalVal[n10 - 100] >= QuestConditionInfo.nParam2 then Result := False;
                  end;
                200..209:
                  begin
                    if PlayObject.m_DyVal[n10 - 200] >= QuestConditionInfo.nParam2 then Result := False;
                  end;
                300..399:
                  begin
                    if PlayObject.m_nMval[n10 - 300] >= QuestConditionInfo.nParam2 then Result := False;
                  end;
                400..499:
                  begin
                    if g_Config.GlobaDyMval[n10 - 400] >= QuestConditionInfo.nParam2 then Result := False;
                  end;
              end;
            end else Result := False;
          end;
        nSC_ISSYSOP: if not (PlayObject.m_btPermission >= 4) then Result := False;
        nSC_ISADMIN: if not (PlayObject.m_btPermission >= 6) then Result := False;
        nSC_CHECKGROUPCOUNT: if not ConditionOfCheckGroupCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKPOSEDIR: if not ConditionOfCheckPoseDir(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKPOSELEVEL: if not ConditionOfCheckPoseLevel(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKPOSEGENDER: if not ConditionOfCheckPoseGender(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKLEVELEX: if not ConditionOfCheckLevelEx(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKBONUSPOINT: if not ConditionOfCheckBonusPoint(PlayObject, QuestConditionInfo) then Result := False;

//        nSC_CHECKMARRY: if not ConditionOfCheckMarry(PlayObject, QuestConditionInfo) then Result := False;
//        nSC_CHECKPOSEMARRY: if not ConditionOfCheckPoseMarry(PlayObject, QuestConditionInfo) then Result := False;  //检查对方是否结婚
//        nSC_CHECKMARRYCOUNT: if not ConditionOfCheckMarryCount(PlayObject, QuestConditionInfo) then Result := False;
//        nSC_CHECKMASTER: if not ConditionOfCheckMaster(PlayObject, QuestConditionInfo) then Result := False;
//        nSC_HAVEMASTER: if not ConditionOfHaveMaster(PlayObject, QuestConditionInfo) then Result := False;
//        nSC_CHECKPOSEMASTER: if not ConditionOfCheckPoseMaster(PlayObject, QuestConditionInfo) then Result := False;
//        nSC_POSEHAVEMASTER: if not ConditionOfPoseHaveMaster(PlayObject, QuestConditionInfo) then Result := False;
//        nSC_CHECKISMASTER: if not ConditionOfCheckIsMaster(PlayObject, QuestConditionInfo) then Result := False;

        nSC_HASGUILD: if not ConditionOfCheckHaveGuild(PlayObject, QuestConditionInfo) then Result := False;

        nSC_ISGUILDMASTER: if not ConditionOfCheckIsGuildMaster(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKCASTLEMASTER: if not ConditionOfCheckIsCastleMaster(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISCASTLEGUILD: if not ConditionOfCheckIsCastleaGuild(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISATTACKGUILD: if not ConditionOfCheckIsAttackGuild(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISDEFENSEGUILD: if not ConditionOfCheckIsDefenseGuild(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKCASTLEDOOR: if not ConditionOfCheckCastleDoorStatus(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISATTACKALLYGUILD: if not ConditionOfCheckIsAttackAllyGuild(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISDEFENSEALLYGUILD: if not ConditionOfCheckIsDefenseAllyGuild(PlayObject, QuestConditionInfo) then Result := False;

//        nSC_CHECKPOSEISMASTER: if not ConditionOfCheckPoseIsMaster(PlayObject, QuestConditionInfo) then Result := False;

        nSC_CHECKNAMEIPLIST: if not ConditionOfCheckNameIPList(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKACCOUNTIPLIST: if not ConditionOfCheckAccountIPList(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKSLAVECOUNT: if not ConditionOfCheckSlaveCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISNEWHUMAN: if not PlayObject.m_boNewHuman then Result := False;
        nSC_CHECKMEMBERTYPE: if not ConditionOfCheckMemberType(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKMEMBERLEVEL: if not ConditionOfCheckMemBerLevel(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKGAMEGOLD: if not ConditionOfCheckGameGold(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKGAMEPOINT: if not ConditionOfCheckGamePoint(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKNAMELISTPOSITION: if not ConditionOfCheckNameListPostion(PlayObject, QuestConditionInfo) then Result := False;
        //nSC_CHECKGUILDLIST:     if not ConditionOfCheckGuildList(PlayObject,QuestConditionInfo) then Result:=False;
        nSC_CHECKGUILDLIST:
          begin
            if PlayObject.m_MyGuild <> nil then
            begin
              if not CheckStringList(TGUild(PlayObject.m_MyGuild).sGuildName, m_sPath + QuestConditionInfo.sParam1) then Result := False;
            end else Result := False;
          end;
        nSC_CHECKRENEWLEVEL: if not ConditionOfCheckReNewLevel(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKSLAVELEVEL: if not ConditionOfCheckSlaveLevel(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKSLAVENAME: if not ConditionOfCheckSlaveName(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKCREDITPOINT: if not ConditionOfCheckCreditPoint(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKOFGUILD: if not ConditionOfCheckOfGuild(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKPAYMENT: if not ConditionOfCheckPayMent(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKUSEITEM: if not ConditionOfCheckUseItem(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKBAGSIZE: if not ConditionOfCheckBagSize(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKLISTCOUNT: if not ConditionOfCheckListCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKDC: if not ConditionOfCheckDC(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKMC: if not ConditionOfCheckMC(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKSC: if not ConditionOfCheckSC(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKHP: if not ConditionOfCheckHP(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKMP: if not ConditionOfCheckMP(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKITEMTYPE: if not ConditionOfCheckItemType(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKEXP: if not ConditionOfCheckExp(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKCASTLEGOLD: if not ConditionOfCheckCastleGold(PlayObject, QuestConditionInfo) then Result := False;
        nSC_PASSWORDERRORCOUNT: if not ConditionOfCheckPasswordErrorCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISLOCKPASSWORD: if not ConditionOfIsLockPassword(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISLOCKSTORAGE: if not ConditionOfIsLockStorage(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKBUILDPOINT: if not ConditionOfCheckGuildBuildPoint(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKAURAEPOINT: if not ConditionOfCheckGuildAuraePoint(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKSTABILITYPOINT: if not ConditionOfCheckStabilityPoint(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKFLOURISHPOINT: if not ConditionOfCheckFlourishPoint(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKCONTRIBUTION: if not ConditionOfCheckContribution(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKRANGEMONCOUNT: if not ConditionOfCheckRangeMonCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKITEMADDVALUE: if not ConditionOfCheckItemAddValue(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKINMAPRANGE: if not ConditionOfCheckInMapRange(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CASTLECHANGEDAY: if not ConditionOfCheckCastleChageDay(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CASTLEWARDAY: if not ConditionOfCheckCastleWarDay(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ONLINELONGMIN: if not ConditionOfCheckOnlineLongMin(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKGUILDCHIEFITEMCOUNT: if not ConditionOfCheckChiefItemCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKNAMEDATELIST: if not ConditionOfCheckNameDateList(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKMAPHUMANCOUNT: if not ConditionOfCheckMapHumanCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKMAPMONCOUNT: if not ConditionOfCheckMapMonCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKVAR: if not ConditionOfCheckVar(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKSERVERNAME: if not ConditionOfCheckServerName(PlayObject, QuestConditionInfo) then Result := False;

        nSC_CHECKMAP: if not ConditionOfCheckMap(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKPOS: if not ConditionOfCheckPos(PlayObject, QuestConditionInfo) then Result := False;
        nSC_REVIVESLAVE: if not ConditionOfReviveSlave(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKMAGICLVL: if not ConditionOfCheckMagicLvl(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKGROUPCLASS: if not ConditionOfCheckGroupClass(PlayObject, QuestConditionInfo) then Result := False;
      end;
      if not Result then Break;
    end;
  end;
  function JmpToLable(sLabel: string): Boolean;
  begin
    Result := False;
    Inc(PlayObject.m_nScriptGotoCount);
    if PlayObject.m_nScriptGotoCount > g_Config.nScriptGotoCountLimit {10} then Exit;
    GotoLable(PlayObject, sLabel, False);
    Result := True;
  end;
  procedure GoToQuest(nQuest: Integer); //0049C898
  var
    i: Integer;
    Script: pTScript;
  begin
    for i := 0 to m_ScriptList.Count - 1 do
    begin
      Script := m_ScriptList.Items[i];
      if Script.nQuest = nQuest then
      begin
        PlayObject.m_Script := Script;
        PlayObject.m_NPC := Self;
        GotoLable(PlayObject, sMAIN, False);
        Break;
      end;
    end;
  end;

  procedure AddList(sHumName, sListFileName: string); //0049B620
  var
    i: Integer;
    LoadList: TStringList;
    s10: string;
    bo15: Boolean;
  begin
    sListFileName := g_Config.sEnvirDir + sListFileName;
    LoadList := TStringList.Create;
    if FileExists(sListFileName) then
    begin
      try
        LoadList.LoadFromFile(sListFileName);
      except
        MainOutMessage('loading fail.... => ' + sListFileName);
      end;
    end;
    bo15 := False;
    for i := 0 to LoadList.Count - 1 do
    begin
      s10 := Trim(LoadList.Strings[i]);
      if CompareText(sHumName, s10) = 0 then
      begin
        bo15 := True;
        Break;
      end;
    end;
    if not bo15 then
    begin
      LoadList.Add(sHumName);
      try
        LoadList.SaveToFile(sListFileName);
      except
        MainOutMessage('saving fail.... => ' + sListFileName);
      end;
    end;

    LoadList.Free;
  end;
  procedure DelList(sHumName, sListFileName: string); //0049B7F8
  var
    i: Integer;
    LoadList: TStringList;
    s10: string;
    bo15: Boolean;
  begin
    sListFileName := g_Config.sEnvirDir + sListFileName;
    LoadList := TStringList.Create;
    if FileExists(sListFileName) then
    begin
      try
        LoadList.LoadFromFile(sListFileName);
      except
        MainOutMessage('loading fail.... => ' + sListFileName);
      end;
    end;
    bo15 := False;
    for i := 0 to LoadList.Count - 1 do
    begin
      s10 := Trim(LoadList.Strings[i]);
      if CompareText(sHumName, s10) = 0 then
      begin
        LoadList.Delete(i);
        bo15 := True;
        Break;
      end;
    end;
    if bo15 then
    begin
      try
        LoadList.SaveToFile(sListFileName);
      except
        MainOutMessage('saving fail.... => ' + sListFileName);
      end;
    end;
    LoadList.Free;
  end;
  procedure TakeItem(sItemName: string; nItemCount: Integer); //0049C998
  var
    i: Integer;
    UserItem: pTUserItem;
    StdItem: TItem;
  begin
    if CompareText(sItemName, sSTRING_GOLDNAME) = 0 then
    begin
      PlayObject.DecGold(nItemCount);
      PlayObject.GoldChanged();
      //0049CADB
      if g_boGameLogGold then
        AddGameDataLog('10' + #9 +
          PlayObject.m_sMapName + #9 +
          IntToStr(PlayObject.m_nCurrX) + #9 +
          IntToStr(PlayObject.m_nCurrY) + #9 +
          PlayObject.m_sCharName + #9 +
          sSTRING_GOLDNAME + #9 +
          IntToStr(nItemCount) + #9 +
          '1' + #9 +
          m_sCharName);
      Exit;
    end;
    for i := PlayObject.m_ItemList.Count - 1 downto 0 do
    begin
      if nItemCount <= 0 then Break;
      UserItem := PlayObject.m_ItemList.Items[i];
      if CompareText(UserEngine.GetStdItemName(UserItem.wIndex), sItemName) = 0 then
      begin
        //0049CC24
        StdItem := UserEngine.GetStdItem(UserItem.wIndex);
        if StdItem.NeedIdentify = 1 then
          AddGameDataLog('10' + #9 +
            PlayObject.m_sMapName + #9 +
            IntToStr(PlayObject.m_nCurrX) + #9 +
            IntToStr(PlayObject.m_nCurrY) + #9 +
            PlayObject.m_sCharName + #9 +
            sItemName + #9 +
            IntToStr(UserItem.MakeIndex) + #9 +
            '1' + #9 +
            m_sCharName);
        PlayObject.SendDelItems(UserItem);
        SC := UserEngine.GetStdItemName(UserItem.wIndex);
        Dispose(UserItem);
        PlayObject.m_ItemList.Delete(i);
        Dec(nItemCount);
      end;
    end;
  end;
  procedure GiveItem(sItemName: string; nItemCount: Integer); //0049D1D0
  var
    i: Integer;
    UserItem: pTUserItem;
    StdItem: TItem;
  begin

    if CompareText(sItemName, sSTRING_GOLDNAME) = 0 then
    begin
      PlayObject.IncGold(nItemCount);
      PlayObject.GoldChanged();
      //0049D2FE
      if g_boGameLogGold then
        AddGameDataLog('9' + #9 +
          PlayObject.m_sMapName + #9 +
          IntToStr(PlayObject.m_nCurrX) + #9 +
          IntToStr(PlayObject.m_nCurrY) + #9 +
          PlayObject.m_sCharName + #9 +
          sSTRING_GOLDNAME + #9 +
          IntToStr(nItemCount) + #9 +
          '1' + #9 +
          m_sCharName);
      Exit;
    end;
    if UserEngine.GetStdItemIdx(sItemName) > 0 then
    begin
//      if nItemCount > 50 then nItemCount:=50;//11.22 限制数量大小
      if not (nItemCount in [1..50]) then nItemCount := 1; //12.28 改上一条


      for i := 0 to nItemCount - 1 do
      begin //nItemCount 为0时出死循环
        if PlayObject.IsEnoughBag then
        begin
          New(UserItem);
          if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then
          begin
            PlayObject.m_ItemList.Add((UserItem));
            PlayObject.SendAddItem(UserItem);
            StdItem := UserEngine.GetStdItem(UserItem.wIndex);
            //0049D46B
            if StdItem.NeedIdentify = 1 then
              AddGameDataLog('9' + #9 +
                PlayObject.m_sMapName + #9 +
                IntToStr(PlayObject.m_nCurrX) + #9 +
                IntToStr(PlayObject.m_nCurrY) + #9 +
                PlayObject.m_sCharName + #9 +
                sItemName + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                '1' + #9 +
                m_sCharName);
          end else Dispose(UserItem);
        end else
        begin
          New(UserItem);
          if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then
          begin
            StdItem := UserEngine.GetStdItem(UserItem.wIndex);
            //0049D5A5
            if StdItem.NeedIdentify = 1 then
              AddGameDataLog('9' + #9 +
                PlayObject.m_sMapName + #9 +
                IntToStr(PlayObject.m_nCurrX) + #9 +
                IntToStr(PlayObject.m_nCurrY) + #9 +
                PlayObject.m_sCharName + #9 +
                sItemName + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                '1' + #9 +
                m_sCharName);
            PlayObject.DropItemDown(UserItem, 3, False, PlayObject, nil);
          end;
          Dispose(UserItem);
        end;
      end;
    end;
  end;
  
  procedure TakeWItem(sItemName: string; nItemCount: Integer); //0049CCF8
  var
    i: Integer;
    sName: string;
  begin
    if CompareLStr(sItemName, '[NECKLACE]', 4) then
    begin
      if PlayObject.m_UseItems[U_NECKLACE].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_NECKLACE]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_NECKLACE].wIndex);
        PlayObject.m_UseItems[U_NECKLACE].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[RING]', 4) then
    begin
      if PlayObject.m_UseItems[U_RINGL].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_RINGL]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RINGL].wIndex);
        PlayObject.m_UseItems[U_RINGL].wIndex := 0;
        Exit;
      end;
      if PlayObject.m_UseItems[U_RINGR].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_RINGR]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RINGR].wIndex);
        PlayObject.m_UseItems[U_RINGR].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[ARMRING]', 4) then
    begin
      if PlayObject.m_UseItems[U_ARMRINGL].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_ARMRINGL]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_ARMRINGL].wIndex);
        PlayObject.m_UseItems[U_ARMRINGL].wIndex := 0;
        Exit;
      end;
      if PlayObject.m_UseItems[U_ARMRINGR].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_ARMRINGR]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_ARMRINGR].wIndex);
        PlayObject.m_UseItems[U_ARMRINGR].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[WEAPON]', 4) then
    begin
      if PlayObject.m_UseItems[U_WEAPON].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_WEAPON]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_WEAPON].wIndex);
        PlayObject.m_UseItems[U_WEAPON].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[HELMET]', 4) then
    begin
      if PlayObject.m_UseItems[U_HELMET].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_HELMET]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_HELMET].wIndex);
        PlayObject.m_UseItems[U_HELMET].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[DRESS]', 4) then
    begin
      if PlayObject.m_UseItems[U_DRESS].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_DRESS]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_DRESS].wIndex);
        PlayObject.m_UseItems[U_DRESS].wIndex := 0;
        Exit;
      end;
    end;

    if CompareLStr(sItemName, '[U_BUJUK]', 4) then
    begin
      if PlayObject.m_UseItems[U_BUJUK].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_BUJUK]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BUJUK].wIndex);
        PlayObject.m_UseItems[U_BUJUK].wIndex := 0;
        Exit;
      end;
    end;

//取消1.70版增加的3个物品
{
    if CompareLStr(sItemName, '[U_BELT]', 4) then
    begin
      if PlayObject.m_UseItems[U_BELT].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_BELT]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BELT].wIndex);
        PlayObject.m_UseItems[U_BELT].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[U_BOOTS]', 4) then
    begin
      if PlayObject.m_UseItems[U_BOOTS].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_BOOTS]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BOOTS].wIndex);
        PlayObject.m_UseItems[U_BOOTS].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[U_CHARM]', 4) then
    begin
      if PlayObject.m_UseItems[U_CHARM].wIndex > 0 then
      begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_CHARM]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_CHARM].wIndex);
        PlayObject.m_UseItems[U_CHARM].wIndex := 0;
        Exit;
      end;
    end;
}

    for i := Low(THumanUseItems) to High(THumanUseItems) do
    begin
      if nItemCount <= 0 then Exit;
      if PlayObject.m_UseItems[i].wIndex > 0 then
      begin
        sName := UserEngine.GetStdItemName(PlayObject.m_UseItems[i].wIndex);
        if CompareText(sName, sItemName) = 0 then
        begin
          PlayObject.SendDelItems(@PlayObject.m_UseItems[i]);
          PlayObject.m_UseItems[i].wIndex := 0;
          Dec(nItemCount);
        end;
      end;
    end;
  end;

  function QuestActionProcess(ActionList: TList): Boolean; //0049D660
  var
    i, ii: Integer;
    QuestActionInfo: pTQuestActionInfo;
    n14, n18, n1C, n28, n2C: Integer;
    n20X, n24Y, n34, n38, n3C, n40: Integer;
    s4C, s50: string;
    s34, s44, s48: string;
    Envir: TEnvirnoment;
    List58: TList;
    User: TPlayObject;
  begin
    Result := True;
    n18 := 0;
    n34 := 0;
    n38 := 0;
    n3C := 0;
    n40 := 0;
    for i := 0 to ActionList.Count - 1 do
    begin
      QuestActionInfo := ActionList.Items[i];
      case QuestActionInfo.nCMDCode of //
        nSET:
          begin
            n28 := Str_ToInt(QuestActionInfo.sParam1, 0);
            n2C := Str_ToInt(QuestActionInfo.sParam2, 0);
            PlayObject.SetQuestFlagStatus(n28, n2C);
          end;
        nTAKE: TakeItem(QuestActionInfo.sParam1, QuestActionInfo.nParam2);
        //nGIVE: GiveItem(QuestActionInfo.sParam1,QuestActionInfo.nParam2);
        nSC_GIVE: ActionOfGiveItem(PlayObject, QuestActionInfo);
        nTAKEW: TakeWItem(QuestActionInfo.sParam1, QuestActionInfo.nParam2);
        nCLOSE: PlayObject.SendMsg(Self, RM_MERCHANTDLGCLOSE, 0, Integer(Self), 0, 0, '');
        nRESET:
          begin
            for ii := 0 to QuestActionInfo.nParam2 - 1 do
            begin
              PlayObject.SetQuestFlagStatus(QuestActionInfo.nParam1 + ii, 0);
            end;
          end;
        nSETOPEN:
          begin
            n28 := Str_ToInt(QuestActionInfo.sParam1, 0);
            n2C := Str_ToInt(QuestActionInfo.sParam2, 0);
            PlayObject.SetQuestUnitOpenStatus(n28, n2C);
          end;
        nSETUNIT:
          begin
            n28 := Str_ToInt(QuestActionInfo.sParam1, 0);
            n2C := Str_ToInt(QuestActionInfo.sParam2, 0);
            PlayObject.SetQuestUnitStatus(n28, n2C);
          end;
        nRESETUNIT:
          begin
            for ii := 0 to QuestActionInfo.nParam2 - 1 do
            begin
              PlayObject.SetQuestUnitStatus(QuestActionInfo.nParam1 + ii, 0);
            end;
          end;
        nBREAK: Result := False;
        nTIMERECALL:
          begin
            PlayObject.m_boTimeRecall := True;
            PlayObject.m_sMoveMap := PlayObject.m_sMapName;
            PlayObject.m_nMoveX := PlayObject.m_nCurrX;
            PlayObject.m_nMoveY := PlayObject.m_nCurrY;
            PlayObject.m_dwTimeRecallTick := GetTickCount + LongWord(QuestActionInfo.nParam1 * 60 * 1000);
          end;
        nSC_PARAM1:
          begin
            n34 := QuestActionInfo.nParam1;
            s44 := QuestActionInfo.sParam1;
          end;
        nSC_PARAM2:
          begin
            n38 := QuestActionInfo.nParam1;
            s48 := QuestActionInfo.sParam1;
          end;
        nSC_PARAM3:
          begin
            n3C := QuestActionInfo.nParam1;
            s4C := QuestActionInfo.sParam1;
          end;
        nSC_PARAM4:
          begin
            n40 := QuestActionInfo.nParam1;
            s50 := QuestActionInfo.sParam1;
          end;
        nSC_EXEACTION:
          begin
            n40 := QuestActionInfo.nParam1;
            s50 := QuestActionInfo.sParam1;
            ExeAction(PlayObject, QuestActionInfo.sParam1, QuestActionInfo.sParam2, QuestActionInfo.sParam3, QuestActionInfo.nParam1, QuestActionInfo.nParam2, QuestActionInfo.nParam3);
          end;
        nMAPMOVE:
          begin
            PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
            PlayObject.SpaceMove(QuestActionInfo.sParam1, QuestActionInfo.nParam2, QuestActionInfo.nParam3, 0);
            bo11 := True;
          end;
        nMAP:
          begin
            PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
            PlayObject.MapRandomMove(QuestActionInfo.sParam1, 0);
            bo11 := True;
          end;
        nTAKECHECKITEM:
          begin
            if UserItem <> nil then
            begin
              PlayObject.QuestTakeCheckItem(UserItem);
            end else
            begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sTAKECHECKITEM);
            end;
          end;
        nMONGEN:
          begin
            for ii := 0 to QuestActionInfo.nParam2 - 1 do
            begin
              n20X := Random(QuestActionInfo.nParam3 * 2 + 1) + (n38 - QuestActionInfo.nParam3);
              n24Y := Random(QuestActionInfo.nParam3 * 2 + 1) + (n3C - QuestActionInfo.nParam3);
              UserEngine.RegenMonsterByName(s44, n20X, n24Y, QuestActionInfo.sParam1);
            end;
          end;
        nMONCLEAR:
          begin
            List58 := TList.Create;
            UserEngine.GetMapMonster(g_MapManager.FindMap(QuestActionInfo.sParam1), List58);
            for ii := 0 to List58.Count - 1 do
            begin
              TBaseObject(List58.Items[ii]).m_boNoItem := True;
              TBaseObject(List58.Items[ii]).m_WAbil.HP := 0;
            end; // for
            List58.Free;
          end;
        nMOV:
          begin
            n14 := GetValNameNo(QuestActionInfo.sParam1);
            if n14 >= 0 then
            begin
              case n14 of //
                0..9:
                  begin
                    PlayObject.m_nVal[n14] := QuestActionInfo.nParam2;
                  end;
                100..119:
                  begin
                    g_Config.GlobalVal[n14 - 100] := QuestActionInfo.nParam2;
                  end;
                200..209:
                  begin
                    PlayObject.m_DyVal[n14 - 200] := QuestActionInfo.nParam2;
                  end;
                300..399:
                  begin
                    PlayObject.m_nMval[n14 - 300] := QuestActionInfo.nParam2;
                  end;
                400..499:
                  begin
                    g_Config.GlobaDyMval[n14 - 400] := QuestActionInfo.nParam2;
                  end;
              else
                begin
                  ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
                end;
              end;
            end else
            begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
            end;
          end;
        nINC:
          begin
            n14 := GetValNameNo(QuestActionInfo.sParam1);
            if n14 >= 0 then
            begin
              case n14 of //
                0..9:
                  begin
                    if QuestActionInfo.nParam2 > 1 then
                    begin
                      Inc(PlayObject.m_nVal[n14], QuestActionInfo.nParam2);
                    end else
                    begin
                      Inc(PlayObject.m_nVal[n14]);
                    end;
                  end;
                100..119:
                  begin
                    if QuestActionInfo.nParam2 > 1 then
                    begin
                      Inc(g_Config.GlobalVal[n14 - 100], QuestActionInfo.nParam2);
                    end else
                    begin
                      Inc(g_Config.GlobalVal[n14 - 100]);
                    end;
                  end;
                200..209:
                  begin
                    if QuestActionInfo.nParam2 > 1 then
                    begin
                      Inc(PlayObject.m_DyVal[n14 - 200], QuestActionInfo.nParam2);
                    end else
                    begin
                      Inc(PlayObject.m_DyVal[n14 - 200]);
                    end;
                  end;
                300..399:
                  begin
                    if QuestActionInfo.nParam2 > 1 then
                    begin
                      Inc(PlayObject.m_nMval[n14 - 300], QuestActionInfo.nParam2);
                    end else
                    begin
                      Inc(PlayObject.m_nMval[n14 - 300]);
                    end;
                  end;
                400..499:
                  begin
                    if QuestActionInfo.nParam2 > 1 then
                    begin
                      Inc(g_Config.GlobaDyMval[n14 - 400], QuestActionInfo.nParam2);
                    end else
                    begin
                      Inc(g_Config.GlobaDyMval[n14 - 400]);
                    end;
                  end;
              else
                begin
                  ScriptActionError(PlayObject, '', QuestActionInfo, sINC);
                end;
              end; // case
            end else
            begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sINC);
            end;
          end;
        nDEC:
          begin
            n14 := GetValNameNo(QuestActionInfo.sParam1);
            if n14 >= 0 then
            begin
              case n14 of //
                0..9:
                  begin
                    if QuestActionInfo.nParam2 > 1 then
                    begin
                      Dec(PlayObject.m_nVal[n14], QuestActionInfo.nParam2);
                    end else
                    begin
                      Dec(PlayObject.m_nVal[n14]);
                    end;
                  end;
                100..119:
                  begin
                    if QuestActionInfo.nParam2 > 1 then
                    begin
                      Dec(g_Config.GlobalVal[n14 - 100], QuestActionInfo.nParam2);
                    end else
                    begin
                      Dec(g_Config.GlobalVal[n14 - 100]);
                    end;
                  end;
                200..209:
                  begin
                    if QuestActionInfo.nParam2 > 1 then
                    begin
                      Dec(PlayObject.m_DyVal[n14 - 200], QuestActionInfo.nParam2);
                    end else
                    begin
                      Dec(PlayObject.m_DyVal[n14 - 200]);
                    end;
                  end;
                300..399:
                  begin
                    if QuestActionInfo.nParam2 > 1 then
                    begin
                      Dec(PlayObject.m_nMval[n14 - 300], QuestActionInfo.nParam2);
                    end else
                    begin
                      Dec(PlayObject.m_nMval[n14 - 300]);
                    end;
                  end;
                400..499:
                  begin
                    if QuestActionInfo.nParam2 > 1 then
                    begin
                      Dec(g_Config.GlobaDyMval[n14 - 400], QuestActionInfo.nParam2);
                    end else
                    begin
                      Dec(g_Config.GlobaDyMval[n14 - 400]);
                    end;
                  end;
              else
                begin
                  ScriptActionError(PlayObject, '', QuestActionInfo, sDEC);
                end;
              end;
            end else
            begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sDEC);
            end;
          end;
        nSUM:
          begin
            n18 := 0;
            n14 := GetValNameNo(QuestActionInfo.sParam1);
            if n14 >= 0 then
            begin
              case n14 of //
                0..9:
                  begin
                    n18 := PlayObject.m_nVal[n14];
                  end;
                100..119:
                  begin
                    n18 := g_Config.GlobalVal[n14 - 100];
                  end;
                200..209:
                  begin
                    n18 := PlayObject.m_DyVal[n14 - 200];
                  end;
                300..399:
                  begin
                    n18 := PlayObject.m_nMval[n14 - 300];
                  end;
                400..499:
                  begin
                    n18 := g_Config.GlobaDyMval[n14 - 400];
                  end;
              else
                begin
                  ScriptActionError(PlayObject, '', QuestActionInfo, sSUM);
                end;
              end; // case
            end else
            begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sSUM);
            end;
            n1C := 0;
            n14 := GetValNameNo(QuestActionInfo.sParam2);
            if n14 >= 0 then
            begin
              case n14 of //
                0..9:
                  begin
                    n1C := PlayObject.m_nVal[n14];
                  end;
                100..119:
                  begin
                    n1C := g_Config.GlobalVal[n14 - 100];
                  end;
                200..209:
                  begin
                    n1C := PlayObject.m_DyVal[n14 - 200];
                  end;
                300..399:
                  begin
                    n1C := PlayObject.m_nMval[n14 - 300];
                  end;
                400..499:
                  begin
                    n1C := g_Config.GlobaDyMval[n14 - 400];
                  end;
              else
                begin
                  ScriptActionError(PlayObject, '', QuestActionInfo, sSUM);
                end;
              end;
            end else
            begin
            //ScriptActionError(PlayObject,'',QuestActionInfo,sSUM);
            end;
            n14 := GetValNameNo(QuestActionInfo.sParam1);
            if n14 >= 0 then
            begin
              case n14 of //
                0..9:
                  begin
                    PlayObject.m_nVal[9] := PlayObject.m_nVal[9] + n18 + n1C;
                  end;
                100..119:
                  begin
                    g_Config.GlobalVal[9] := g_Config.GlobalVal[9] + n18 + n1C;
                  end;
                200..209:
                  begin
                    PlayObject.m_DyVal[9] := PlayObject.m_DyVal[9] + n18 + n1C;
                  end;
                300..399:
                  begin
                    PlayObject.m_nMval[99] := PlayObject.m_nMval[99] + n18 + n1C;
                  end;
                400..499:
                  begin
                    g_Config.GlobaDyMval[99] := g_Config.GlobaDyMval[99] + n18 + n1C;
                  end;
              end;
            end;
          end;
        nBREAKTIMERECALL: PlayObject.m_boTimeRecall := False;

        nCHANGEMODE:
          begin
            case QuestActionInfo.nParam1 of
              1: PlayObject.CmdChangeAdminMode('', 10, '', Str_ToInt(QuestActionInfo.sParam2, 0) = 1);
              2: PlayObject.CmdChangeSuperManMode('', 10, '', Str_ToInt(QuestActionInfo.sParam2, 0) = 1);
              3: PlayObject.CmdChangeObMode('', 10, '', Str_ToInt(QuestActionInfo.sParam2, 0) = 1);
            else
              begin
                ScriptActionError(PlayObject, '', QuestActionInfo, sCHANGEMODE);
              end;
            end;
          end;
        nPKPOINT:
          begin
            if QuestActionInfo.nParam1 = 0 then
            begin
              PlayObject.m_nPkPoint := 0;
            end else
            begin
              if QuestActionInfo.nParam1 < 0 then
              begin
                if (PlayObject.m_nPkPoint + QuestActionInfo.nParam1) >= 0 then
                begin
                  Inc(PlayObject.m_nPkPoint, QuestActionInfo.nParam1);
                end else PlayObject.m_nPkPoint := 0;
              end else
              begin
                if (PlayObject.m_nPkPoint + QuestActionInfo.nParam1) > 10000 then
                begin
                  PlayObject.m_nPkPoint := 10000;
                end else
                begin
                  Inc(PlayObject.m_nPkPoint, QuestActionInfo.nParam1);
                end;
              end;
            end;
            PlayObject.RefNameColor();
          end;
        nCHANGEXP:
          begin

          end;
        nSC_RECALLMOB: ActionOfRecallmob(PlayObject, QuestActionInfo);
        {
        nSC_RECALLMOB: begin
          if QuestActionInfo.nParam3 <= 1 then begin
            PlayObject.MakeSlave(QuestActionInfo.sParam1,3,Str_ToInt(QuestActionInfo.sParam2,0),100,10 * 24 * 60 * 60);
          end else begin
            PlayObject.MakeSlave(QuestActionInfo.sParam1,3,Str_ToInt(QuestActionInfo.sParam2,0),100,QuestActionInfo.nParam3 * 60)
          end;
        end;
        }
        nKICK:
          begin
            PlayObject.m_boReconnection := True;
            PlayObject.m_boSoftClose := True;
          end;
        nMOVR:
          begin
            n14 := GetValNameNo(QuestActionInfo.sParam1);
            if n14 >= 0 then
            begin
              case n14 of //
                0..9:
                  begin
                    PlayObject.m_nVal[n14] := Random(QuestActionInfo.nParam2);
                  end;
                100..119:
                  begin
                    g_Config.GlobalVal[n14 - 100] := Random(QuestActionInfo.nParam2);
                  end;
                200..209:
                  begin
                    PlayObject.m_DyVal[n14 - 200] := Random(QuestActionInfo.nParam2);
                  end;
                300..399:
                  begin
                    PlayObject.m_nMval[n14 - 300] := Random(QuestActionInfo.nParam2);
                  end;
                400..499:
                  begin
                    g_Config.GlobaDyMval[n14 - 400] := Random(QuestActionInfo.nParam2);
                  end;
              else
                begin
                  ScriptActionError(PlayObject, '', QuestActionInfo, sMOVR);
                end;
              end; // case
            end else
            begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sMOVR);
            end;
          end;
        nEXCHANGEMAP:
          begin
            Envir := g_MapManager.FindMap(QuestActionInfo.sParam1);
            if Envir <> nil then
            begin
              List58 := TList.Create;
              UserEngine.GetMapRageHuman(Envir, 0, 0, 1000, List58);
              if List58.Count > 0 then
              begin
                User := TPlayObject(List58.Items[0]);
                User.MapRandomMove(Self.m_sMapName, 0);
              end;
              List58.Free;
              PlayObject.MapRandomMove(QuestActionInfo.sParam1, 0);
            end else
            begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sEXCHANGEMAP);
            end;

          end;
        nRECALLMAP:
          begin
            Envir := g_MapManager.FindMap(QuestActionInfo.sParam1);
            if Envir <> nil then
            begin
              List58 := TList.Create;
              UserEngine.GetMapRageHuman(Envir, 0, 0, 1000, List58);
              for ii := 0 to List58.Count - 1 do
              begin
                User := TPlayObject(List58.Items[ii]);
                User.MapRandomMove(Self.m_sMapName, 0);
                if ii > 20 then Break;
              end;
              List58.Free;
            end else
            begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sRECALLMAP);
            end;
          end;
        nADDBATCH: List1C.AddObject(QuestActionInfo.sParam1, TObject(n18));
        nBATCHDELAY: n18 := QuestActionInfo.nParam1 * 1000;
        nBATCHMOVE:
          begin
            for ii := 0 to List1C.Count - 1 do
            begin
              PlayObject.SendDelayMsg(Self, RM_10155, 0, 0, 0, 0, List1C.Strings[ii], Integer(List1C.Objects[ii]) + n20);
              Inc(n20, Integer(List1C.Objects[ii]));
            end;
          end;
        nPLAYDICE:
          begin //0049E209
            PlayObject.m_sPlayDiceLabel := QuestActionInfo.sParam2;
            PlayObject.SendMsg(Self,
              RM_PLAYDICE,
              QuestActionInfo.nParam1,
              MakeLong(MakeWord(PlayObject.m_DyVal[0], PlayObject.m_DyVal[1]), MakeWord(PlayObject.m_DyVal[2], PlayObject.m_DyVal[3])),
              MakeLong(MakeWord(PlayObject.m_DyVal[4], PlayObject.m_DyVal[5]), MakeWord(PlayObject.m_DyVal[6], PlayObject.m_DyVal[7])),
              MakeLong(MakeWord(PlayObject.m_DyVal[8], PlayObject.m_DyVal[9]), 0),
              QuestActionInfo.sParam2);
            bo11 := True;
          end;
        nADDNAMELIST: AddList(PlayObject.m_sCharName, m_sPath + QuestActionInfo.sParam1);
        nDELNAMELIST: DelList(PlayObject.m_sCharName, m_sPath + QuestActionInfo.sParam1);
        nADDGUILDLIST: if PlayObject.m_MyGuild <> nil then AddList(TGUild(PlayObject.m_MyGuild).sGuildName, m_sPath + QuestActionInfo.sParam1);
        nDELGUILDLIST: if PlayObject.m_MyGuild <> nil then DelList(TGUild(PlayObject.m_MyGuild).sGuildName, m_sPath + QuestActionInfo.sParam1);
        nSC_LINEMSG, nSENDMSG: ActionOfLineMsg(PlayObject, QuestActionInfo);

        nADDACCOUNTLIST: AddList(PlayObject.m_sUserID, m_sPath + QuestActionInfo.sParam1);
        nDELACCOUNTLIST: DelList(PlayObject.m_sUserID, m_sPath + QuestActionInfo.sParam1);
        nADDIPLIST: AddList(PlayObject.m_sIPaddr, m_sPath + QuestActionInfo.sParam1);
        nDELIPLIST: DelList(PlayObject.m_sIPaddr, m_sPath + QuestActionInfo.sParam1);
        nGOQUEST: GoToQuest(QuestActionInfo.nParam1);
        nENDQUEST: PlayObject.m_Script := nil;
        nGOTO:
          begin
            if not JmpToLable(QuestActionInfo.sParam1) then
            begin
            //ScriptActionError(PlayObject,'',QuestActionInfo,sGOTO);
              MainOutMessage('[脚本死循环] NPC:' + m_sCharName +
                ' 位置:' + m_sMapName + '(' + IntToStr(m_nCurrX) + ':' + IntToStr(m_nCurrY) + ')' +
                ' 命令:' + sGOTO + ' ' + QuestActionInfo.sParam1);
              Result := False;
              Exit;
            end;
          end;

        nSC_HAIRCOLOR: ;
        nSC_WEARCOLOR: ;
        nSC_HAIRSTYLE: ActionOfChangeHairStyle(PlayObject, QuestActionInfo);
        nSC_MONRECALL: ;
        nSC_HORSECALL: ;
        nSC_HAIRRNDCOL: ;
        nSC_KILLHORSE: ;
        nSC_RANDSETDAILYQUEST: ;

        nSC_RECALLGROUPMEMBERS: ActionOfRecallGroupMembers(PlayObject, QuestActionInfo);
        nSC_CLEARNAMELIST: ActionOfClearNameList(PlayObject, QuestActionInfo);
        nSC_MAPTING: ActionOfMapTing(PlayObject, QuestActionInfo);
        nSC_CHANGELEVEL: ActionOfChangeLevel(PlayObject, QuestActionInfo);

//取消 [师徒] 和 [结婚] 系统相关的功能 
//        nSC_MARRY: ActionOfMarry(PlayObject, QuestActionInfo);
//        nSC_MASTER: ActionOfMaster(PlayObject, QuestActionInfo);
//        nSC_UNMASTER: ActionOfUnMaster(PlayObject, QuestActionInfo);
//        nSC_UNMARRY: ActionOfUnMarry(PlayObject, QuestActionInfo);
//        nSC_GETMARRY: ActionOfGetMarry(PlayObject, QuestActionInfo);
//        nSC_GETMASTER: ActionOfGetMaster(PlayObject, QuestActionInfo);
//        nSC_DELMARRY: ActionOfDelMarry(PlayObject, QuestActionInfo);
//        nSC_DELMASTER: ActionOfDelMaster(PlayObject, QuestActionInfo);

        nSC_CLEARSKILL: ActionOfClearSkill(PlayObject, QuestActionInfo);
        nSC_DELNOJOBSKILL: ActionOfDelNoJobSkill(PlayObject, QuestActionInfo);
        nSC_DELSKILL: ActionOfDelSkill(PlayObject, QuestActionInfo);
        nSC_ADDSKILL: ActionOfAddSkill(PlayObject, QuestActionInfo);
        nSC_SKILLLEVEL: ActionOfSkillLevel(PlayObject, QuestActionInfo);
        nSC_CHANGEPKPOINT: ActionOfChangePkPoint(PlayObject, QuestActionInfo);
        nSC_CHANGEEXP: ActionOfChangeExp(PlayObject, QuestActionInfo);
        nSC_CHANGEJOB: ActionOfChangeJob(PlayObject, QuestActionInfo);
        nSC_MISSION: ActionOfMission(PlayObject, QuestActionInfo);
        nSC_MOBPLACE: ActionOfMobPlace(PlayObject, QuestActionInfo, n34, n38, n3C, n40);
        nSC_SETMEMBERTYPE: ActionOfSetMemberType(PlayObject, QuestActionInfo);
        nSC_SETMEMBERLEVEL: ActionOfSetMemberLevel(PlayObject, QuestActionInfo);
//        nSC_SETMEMBERTYPE:   PlayObject.m_nMemberType:=Str_ToInt(QuestActionInfo.sParam1,0);
//        nSC_SETMEMBERLEVEL:  PlayObject.m_nMemberType:=Str_ToInt(QuestActionInfo.sParam1,0);
        nSC_GAMEGOLD: ActionOfGameGold(PlayObject, QuestActionInfo);
        nSC_GAMEPOINT: ActionOfGamePoint(PlayObject, QuestActionInfo);
        nSC_AUTOADDGAMEGOLD: ActionOfAutoAddGameGold(PlayObject, QuestActionInfo, n34, n38);
        nSC_AUTOSUBGAMEGOLD: ActionOfAutoSubGameGold(PlayObject, QuestActionInfo, n34, n38);
        nSC_CHANGENAMECOLOR: ActionOfChangeNameColor(PlayObject, QuestActionInfo);
        nSC_CLEARPASSWORD: ActionOfClearPassword(PlayObject, QuestActionInfo);
        nSC_RENEWLEVEL: ActionOfReNewLevel(PlayObject, QuestActionInfo);
        nSC_KILLSLAVE: ActionOfKillSlave(PlayObject, QuestActionInfo);
        nSC_CHANGEGENDER: ActionOfChangeGender(PlayObject, QuestActionInfo);
        nSC_KILLMONEXPRATE: ActionOfKillMonExpRate(PlayObject, QuestActionInfo);
        nSC_POWERRATE: ActionOfPowerRate(PlayObject, QuestActionInfo);
        nSC_CHANGEMODE: ActionOfChangeMode(PlayObject, QuestActionInfo);
        nSC_CHANGEPERMISSION: ActionOfChangePerMission(PlayObject, QuestActionInfo);
        nSC_KILL: ActionOfKill(PlayObject, QuestActionInfo);
        nSC_KICK: ActionOfKick(PlayObject, QuestActionInfo);
        nSC_BONUSPOINT: ActionOfBonusPoint(PlayObject, QuestActionInfo);
        nSC_RESTRENEWLEVEL: ActionOfRestReNewLevel(PlayObject, QuestActionInfo);

        nSC_CREDITPOINT: ActionOfChangeCreditPoint(PlayObject, QuestActionInfo);
        nSC_CLEARNEEDITEMS: ActionOfClearNeedItems(PlayObject, QuestActionInfo);
        nSC_CLEARMAEKITEMS: ActionOfClearMakeItems(PlayObject, QuestActionInfo);
        nSC_SETSENDMSGFLAG: PlayObject.m_boSendMsgFlag := True;
        nSC_UPGRADEITEMS: ActionOfUpgradeItems(PlayObject, QuestActionInfo);
        nSC_UPGRADEITEMSEX: ActionOfUpgradeItemsEx(PlayObject, QuestActionInfo);
        nSC_MONGENEX: ActionOfMonGenEx(PlayObject, QuestActionInfo);
        nSC_CLEARMAPMON: ActionOfClearMapMon(PlayObject, QuestActionInfo);
        nSC_SETMAPMODE: ActionOfSetMapMode(PlayObject, QuestActionInfo);
        nSC_PKZONE: ActionOfPkZone(PlayObject, QuestActionInfo);
        nSC_RESTBONUSPOINT: ActionOfRestBonusPoint(PlayObject, QuestActionInfo);
        nSC_TAKECASTLEGOLD: ActionOfTakeCastleGold(PlayObject, QuestActionInfo);
        nSC_HUMANHP: ActionOfHumanHP(PlayObject, QuestActionInfo);
        nSC_HUMANMP: ActionOfHumanMP(PlayObject, QuestActionInfo);
        nSC_BUILDPOINT: ActionOfGuildBuildPoint(PlayObject, QuestActionInfo);
        nSC_AURAEPOINT: ActionOfGuildAuraePoint(PlayObject, QuestActionInfo);
        nSC_STABILITYPOINT: ActionOfGuildstabilityPoint(PlayObject, QuestActionInfo);
        nSC_FLOURISHPOINT: ActionOfGuildFlourishPoint(PlayObject, QuestActionInfo);
        nSC_OPENMAGICBOX: ActionOfOpenMagicBox(PlayObject, QuestActionInfo);
        nSC_SETRANKLEVELNAME: ActionOfSetRankLevelName(PlayObject, QuestActionInfo);
        nSC_GMEXECUTE: ActionOfGmExecute(PlayObject, QuestActionInfo);
        nSC_GUILDCHIEFITEMCOUNT: ActionOfGuildChiefItemCount(PlayObject, QuestActionInfo);
        nSC_ADDNAMEDATELIST: ActionOfAddNameDateList(PlayObject, QuestActionInfo);
        nSC_DELNAMEDATELIST: ActionOfDelNameDateList(PlayObject, QuestActionInfo);
        nSC_MOBFIREBURN: ActionOfMobFireBurn(PlayObject, QuestActionInfo);
        nSC_MESSAGEBOX: ActionOfMessageBox(PlayObject, QuestActionInfo);
        nSC_SETSCRIPTFLAG: ActionOfSetScriptFlag(PlayObject, QuestActionInfo);
        nSC_SETAUTOGETEXP: ActionOfAutoGetExp(PlayObject, QuestActionInfo);
        nSC_VAR: ActionOfVar(PlayObject, QuestActionInfo);
        nSC_LOADVAR: ActionOfLoadVar(PlayObject, QuestActionInfo);
        nSC_SAVEVAR: ActionOfSaveVar(PlayObject, QuestActionInfo);
        nSC_CALCVAR: ActionOfCalcVar(PlayObject, QuestActionInfo);

        nSC_GUILDRECALL: ActionOfGuildRecall(PlayObject, QuestActionInfo);
        nSC_GROUPADDLIST: ActionOfGroupAddList(PlayObject, QuestActionInfo);
        nSC_CLEARLIST: ActionOfClearList(PlayObject, QuestActionInfo);
        nSC_GROUPRECALL: ActionOfGroupRecall(PlayObject, QuestActionInfo);
        nSC_GROUPMOVEMAP: ActionOfGroupMoveMap(PlayObject, QuestActionInfo);
      end;
    end;
  end;
  procedure SendMerChantSayMsg(sMsg: string; boFlag: Boolean); //0049E3E0
  var
    s10, s14: string;
    nC: Integer;
  begin
    s14 := sMsg;
    nC := 0;
    while (True) do
    begin
      if TagCount(s14, '>') < 1 then Break;
      s14 := ArrestStringEx(s14, '<', '>', s10);
      GetVariableText(PlayObject, sMsg, s10);
      Inc(nC);
      if nC >= 101 then Break;
    end;
    PlayObject.GetScriptLabel(sMsg);
    if boFlag then
    begin
      PlayObject.SendFirstMsg(Self, RM_MERCHANTSAY, 0, 0, 0, 0, m_sCharName + '/' + sMsg);
    end else
    begin
      PlayObject.SendMsg(Self, RM_MERCHANTSAY, 0, 0, 0, 0, m_sCharName + '/' + sMsg);
    end;
  end;
begin //0049E584
  Script := nil;
  List1C := TStringList.Create;
  n18 := 1000;
  n20 := 0;
  if PlayObject.m_NPC <> Self then
  begin
    PlayObject.m_NPC := nil;
    PlayObject.m_Script := nil;
    FillChar(PlayObject.m_nVal, SizeOf(PlayObject.m_nVal), #0);
  end;
  if CompareText(sLabel, '@main') = 0 then
  begin
    for i := 0 to m_ScriptList.Count - 1 do
    begin
      Script3C := m_ScriptList.Items[i];
      for ii := 0 to Script3C.RecordList.Count - 1 do
      begin
        SayingRecord := Script3C.RecordList.Items[ii];
        if CompareText(sLabel, SayingRecord.sLabel) = 0 then
        begin
          Script := Script3C;
          PlayObject.m_Script := Script;
          PlayObject.m_NPC := Self;
          Break;
        end;
        if Script <> nil then Break;
      end;
    end;
  end; //0049E6CB
  if (Script = nil) then
  begin
    if (PlayObject.m_Script <> nil) then
    begin
      for i := m_ScriptList.Count - 1 downto 0 do
      begin
        if m_ScriptList.Items[i] = PlayObject.m_Script then
        begin
          Script := m_ScriptList.Items[i];
        end;
      end;
    end; //0049E72F
    if (Script = nil) then
    begin
      for i := m_ScriptList.Count - 1 downto 0 do
      begin
        if CheckQuestStatus(pTScript(m_ScriptList.Items[i])) then
        begin
          Script := m_ScriptList.Items[i];
          PlayObject.m_Script := Script;
          PlayObject.m_NPC := Self;
        end;
      end;
    end;
  end; //0049E79B

  //跳转到指定示签，执行
  if (Script <> nil) then
  begin
    for ii := 0 to Script.RecordList.Count - 1 do
    begin
      SayingRecord := Script.RecordList.Items[ii];
      if CompareText(sLabel, SayingRecord.sLabel) = 0 then
      begin
        if boExtJmp and not SayingRecord.boExtJmp then Break;
        sSENDMSG := '';
        for III := 0 to SayingRecord.ProcedureList.Count - 1 do
        begin
          SayingProcedure := SayingRecord.ProcedureList.Items[III];
          bo11 := False;
          if QuestCheckCondition(SayingProcedure.ConditionList) then
          begin
            sSENDMSG := sSENDMSG + SayingProcedure.sSayMsg;
            if not QuestActionProcess(SayingProcedure.ActionList) then Break;
            if bo11 then SendMerChantSayMsg(sSENDMSG, True);
          end else
          begin //0049E865
            sSENDMSG := sSENDMSG + SayingProcedure.sElseSayMsg;
            if not QuestActionProcess(SayingProcedure.ElseActionList) then Break;
            if bo11 then SendMerChantSayMsg(sSENDMSG, True);
          end; //0049E8A2
        end; //for III := 0 to SayingRecord.List04.Count - 1 do begin
        if sSENDMSG <> '' then SendMerChantSayMsg(sSENDMSG, False);
        Break;
      end; //if CompareText(sLabel,SayingRecord.s00) = 0 then begin
    end; //for II := 0 to XXXInfo.List58.Count - 1 do begin
  end; //if (XXXInfo <> nil) then begin
  List1C.Free;
end;

procedure TNormNpc.LoadNpcScript; //0049EAF0
var
  s08: string;
begin
  if m_boIsQuest then
  begin
    m_sPath := sNpc_def;
    s08 := m_sCharName + '-' + m_sMapName;
    FrmDB.LoadNpcScript(Self, m_sFilePath, s08);
  end else
  begin //0049EB8E
    m_sPath := m_sFilePath;
    FrmDB.LoadNpcScript(Self, m_sFilePath, m_sCharName);
  end;
end;
function TNormNpc.Operate(ProcessMsg: pTProcessMessage): Boolean; //0049AB64
begin
  Result := inherited Operate(ProcessMsg);
end;

procedure TNormNpc.Run; //0049ABCC
begin
  if m_Master <> nil then m_Master := nil; //不允许召唤为宝宝

  inherited;
end;

procedure TNormNpc.ScriptActionError(PlayObject: TPlayObject; sErrMsg: string;
  QuestActionInfo: pTQuestActionInfo; sCmd: string);
var
  sMsg: string;
resourcestring
  sOutMessage = '[脚本错误] %s 脚本命令:%s NPC名称:%s 地图:%s(%d:%d) 参数1:%s 参数2:%s 参数3:%s 参数4:%s 参数5:%s 参数6:%s';
begin
  sMsg := Format(sOutMessage, [sErrMsg,
    sCmd,
      m_sCharName,
      m_sMapName,
      m_nCurrX,
      m_nCurrY,
      QuestActionInfo.sParam1,
      QuestActionInfo.sParam2,
      QuestActionInfo.sParam3,
      QuestActionInfo.sParam4,
      QuestActionInfo.sParam5,
      QuestActionInfo.sParam6]);
  {
  sMsg:='脚本命令:' + sCmd +
        ' NPC名称:' + m_sCharName +
        ' 地图:' + m_sMapName +
        ' 座标:' + IntToStr(m_nCurrX) + ':' + IntToStr(m_nCurrY) +
        ' 参数1:' + QuestActionInfo.sParam1 +
        ' 参数2:' + QuestActionInfo.sParam2 +
        ' 参数3:' + QuestActionInfo.sParam3 +
        ' 参数4:' + QuestActionInfo.sParam4 +
        ' 参数5:' + QuestActionInfo.sParam5 +
        ' 参数6:' + QuestActionInfo.sParam6;
  }
  MainOutMessage(sMsg);
end;

procedure TNormNpc.ScriptConditionError(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo; sCmd: string);
var
  sMsg: string;
begin
  sMsg := 'Cmd:' + sCmd +
    ' NPC名称:' + m_sCharName +
    ' 地图:' + m_sMapName +
    ' 座标:' + IntToStr(m_nCurrX) + ':' + IntToStr(m_nCurrY) +
    ' 参数1:' + QuestConditionInfo.sParam1 +
    ' 参数2:' + QuestConditionInfo.sParam2 +
    ' 参数3:' + QuestConditionInfo.sParam3 +
    ' 参数4:' + QuestConditionInfo.sParam4 +
    ' 参数5:' + QuestConditionInfo.sParam5;
  MainOutMessage('[脚本参数不正确] ' + sMsg);
end;

procedure TNormNpc.SendMsgToUser(PlayObject: TPlayObject; sMsg: string); //0049AD14
begin
  PlayObject.SendMsg(Self, RM_MERCHANTSAY, 0, 0, 0, 0, m_sCharName + '/' + sMsg);
end;

function TNormNpc.sub_49ADB8(sMsg, sStr, sText: string): string; //0049ADB8
var
  n10: Integer;
  s14, s18: string;
begin
  n10 := Pos(sStr, sMsg);
  if n10 > 0 then
  begin
    s14 := Copy(sMsg, 1, n10 - 1);
    s18 := Copy(sMsg, Length(sStr) + n10, Length(sMsg));
    Result := s14 + sText + s18;
  end else Result := sMsg;
end;

procedure TNormNpc.UserSelect(PlayObject: TPlayObject; sData: string); //0049EC28
var
  sMsg, sLabel: string;
begin
  PlayObject.m_nScriptGotoCount := 0;

//==============================================
//处理脚本命令 @back 返回上级标签内容
  if (sData <> '') and (sData[1] = '@') then
  begin
    sMsg := GetValidStr3(sData, sLabel, [#13]);
    if (PlayObject.m_sScriptCurrLable <> sLabel) then
    begin
      if (sLabel <> sBACK) then
      begin
        PlayObject.m_sScriptGoBackLable := PlayObject.m_sScriptCurrLable;
        PlayObject.m_sScriptCurrLable := sLabel;
      end else
      begin
        if PlayObject.m_sScriptCurrLable <> '' then
        begin
          PlayObject.m_sScriptCurrLable := '';
        end else
        begin
          PlayObject.m_sScriptGoBackLable := '';
        end;
      end;
    end;
  end;
//==============================================
end;

procedure TNormNpc.ActionOfChangeNameColor(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nColor: Integer;
begin
  nColor := QuestActionInfo.nParam1;
  if (nColor < 0) or (nColor > 255) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGENAMECOLOR);
    Exit;
  end;
  PlayObject.m_btNameColor := nColor;
  PlayObject.RefNameColor();
end;

procedure TNormNpc.ActionOfClearPassword(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.m_sStoragePwd := '';
  PlayObject.m_boPasswordLocked := False;
end;
//RECALLMOB 怪物名称 等级 叛变时间 变色(0,1) 固定颜色(1 - 7)
//变色为0 时固定颜色才起作用
procedure TNormNpc.ActionOfRecallmob(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  boAutoChangeColor: Boolean;
  mon: TBaseObject;
begin
  if QuestActionInfo.nParam3 <= 1 then
  begin
    mon := PlayObject.MakeSlave(QuestActionInfo.sParam1, 3, Str_ToInt(QuestActionInfo.sParam2, 0), 100, 10 * 24 * 60 * 60);
  end else
  begin
    mon := PlayObject.MakeSlave(QuestActionInfo.sParam1, 3, Str_ToInt(QuestActionInfo.sParam2, 0), 100, QuestActionInfo.nParam3 * 60)
  end;
  if mon <> nil then
  begin
    if (QuestActionInfo.sParam4 <> '') and (QuestActionInfo.sParam4[1] = '1') then
    begin
      mon.m_boAutoChangeColor := True;
    end else
      if QuestActionInfo.nParam5 > 0 then
      begin
        mon.m_boFixColor := True;
        mon.m_nFixColorIdx := QuestActionInfo.nParam5 - 1;
      end;
  end;
end;

procedure TNormNpc.ActionOfReNewLevel(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nReLevel, nLevel: Integer;
  nBounsuPoint: Integer;
begin
  nReLevel := Str_ToInt(QuestActionInfo.sParam1, -1);
  nLevel := Str_ToInt(QuestActionInfo.sParam2, -1);
  nBounsuPoint := Str_ToInt(QuestActionInfo.sParam3, -1);
  if (nReLevel < 0) or (nLevel < 0) or (nBounsuPoint < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_RENEWLEVEL);
    Exit;
  end;

  if (PlayObject.m_btReLevel + nReLevel) <= 255 then
  begin
    Inc(PlayObject.m_btReLevel, nReLevel);
    if nLevel > 0 then PlayObject.m_Abil.Level := nLevel;
    if g_Config.boReNewLevelClearExp then PlayObject.m_Abil.Exp := 0;
    Inc(PlayObject.m_nBonusPoint, nBounsuPoint);
    PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
    PlayObject.HasLevelUp(0);
    PlayObject.RefShowName();
  end;
end;

procedure TNormNpc.ActionOfChangeGender(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nGENDER: Integer;
begin
  nGENDER := Str_ToInt(QuestActionInfo.sParam1, -1);
  if not (nGENDER in [0, 1]) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEGENDER);
    Exit;
  end;

  PlayObject.m_btGender := nGENDER;
  PlayObject.FeatureChanged;
end;

procedure TNormNpc.ActionOfKillSlave(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  Slave: TBaseObject;
begin
  for i := 0 to PlayObject.m_SlaveList.Count - 1 do
  begin
    Slave := TBaseObject(PlayObject.m_SlaveList.Items[i]);
    Slave.m_WAbil.HP := 0;
  end;
end;

procedure TNormNpc.ActionOfKillMonExpRate(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nRate: Integer;
  nTime: Integer;
begin
  nRate := Str_ToInt(QuestActionInfo.sParam1, -1);
  nTime := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nRate < 0) or (nTime < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_KILLMONEXPRATE);
    Exit;
  end;

  PlayObject.m_nKillMonExpRate := nRate;
  //PlayObject.m_dwKillMonExpRateTime:=_MIN(High(Word),nTime);
  PlayObject.m_dwKillMonExpRateTime := LongWord(nTime);
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sChangeKillMonExpRateMsg, [PlayObject.m_nKillMonExpRate / 100, PlayObject.m_dwKillMonExpRateTime]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfMonGenEx(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sMapName, sMonName: string;
  nMapX, nMapY, nRange, nCount: Integer;
  nRandX, nRandY: Integer;
begin
  sMapName := QuestActionInfo.sParam1;
  nMapX := Str_ToInt(QuestActionInfo.sParam2, -1);
  nMapY := Str_ToInt(QuestActionInfo.sParam3, -1);
  sMonName := QuestActionInfo.sParam4;
  nRange := QuestActionInfo.nParam5;
  nCount := QuestActionInfo.nParam6;
  if (sMapName = '') or (nMapX <= 0) or (nMapY <= 0) or (sMapName = '') or (nRange <= 0) or (nCount <= 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MONGENEX);
    Exit;
  end;
  for i := 0 to nCount - 1 do
  begin
    nRandX := Random(nRange * 2 + 1) + (nMapX - nRange);
    nRandY := Random(nRange * 2 + 1) + (nMapY - nRange);
    if UserEngine.RegenMonsterByName(sMapName, nRandX, nRandY, sMonName) = nil then
    begin
      //ScriptActionError(PlayObject,'',QuestActionInfo,sSC_MONGENEX);
      Break;
    end;
  end;
end;



procedure TNormNpc.ActionOfOpenMagicBox(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  Monster: TBaseObject;
  sMonName: string;
  nX, nY: Integer;
begin
  sMonName := QuestActionInfo.sParam1;
  if sMonName = '' then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_OPENMAGICBOX);
    Exit;
  end;
  PlayObject.GetFrontPosition(nX, nY);
  Monster := UserEngine.RegenMonsterByName(PlayObject.m_PEnvir.sMapName, nX, nY, sMonName);
  if Monster = nil then
  begin
    Exit;
  end;
  Monster.Die;

end;

procedure TNormNpc.ActionOfPkZone(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nX, nY: Integer;
  FireBurnEvent: TFireBurnEvent;
  nMinX, nMaxX, nMinY, nMaxY: Integer;
  nRange, nType, nTime, nPoint: Integer;
begin


  nRange := Str_ToInt(QuestActionInfo.sParam1, -1);
  nType := Str_ToInt(QuestActionInfo.sParam2, -1);
  nTime := Str_ToInt(QuestActionInfo.sParam3, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam4, -1);
  if (nRange < 0) or (nType < 0) or (nTime < 0) or (nPoint < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_PKZONE);
    Exit;
  end;
  {
  nMinX:=PlayObject.m_nCurrX - nRange;
  nMaxX:=PlayObject.m_nCurrX + nRange;
  nMinY:=PlayObject.m_nCurrY - nRange;
  nMaxY:=PlayObject.m_nCurrY + nRange;
  }
  nMinX := m_nCurrX - nRange;
  nMaxX := m_nCurrX + nRange;
  nMinY := m_nCurrY - nRange;
  nMaxY := m_nCurrY + nRange;
  for nX := nMinX to nMaxX do
  begin
    for nY := nMinY to nMaxY do
    begin
      if ((nX < nMaxX) and (nY = nMinY)) or
        ((nY < nMaxY) and (nX = nMinX)) or
        (nX = nMaxX) or (nY = nMaxY) then
      begin
        FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY, nType, nTime * 1000, nPoint);
        g_EventManager.AddEvent(FireBurnEvent);
      end;
    end;
  end;

end;

procedure TNormNpc.ActionOfPowerRate(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nRate: Integer;
  nTime: Integer;
begin
  nRate := Str_ToInt(QuestActionInfo.sParam1, -1);
  nTime := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nRate < 0) or (nTime < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_POWERRATE);
    Exit;
  end;

  PlayObject.m_nPowerRate := nRate;
  //PlayObject.m_dwPowerRateTime:=_MIN(High(Word),nTime);
  PlayObject.m_dwPowerRateTime := LongWord(nTime);
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sChangePowerRateMsg, [PlayObject.m_nPowerRate / 100, PlayObject.m_dwPowerRateTime]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfChangeMode(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nMode: Integer;
  boOpen: Boolean;
begin
  nMode := QuestActionInfo.nParam1;
  boOpen := Str_ToInt(QuestActionInfo.sParam2, -1) = 1;
  if nMode in [1..3] then
  begin
    case nMode of //
      1:
        begin
          PlayObject.m_boAdminMode := boOpen;
          if PlayObject.m_boAdminMode then PlayObject.SysMsg(sGameMasterMode, c_Green, t_Hint)
          else PlayObject.SysMsg(sReleaseGameMasterMode, c_Green, t_Hint);
        end;
      2:
        begin
          PlayObject.m_boSuperMan := boOpen;
          if PlayObject.m_boSuperMan then PlayObject.SysMsg(sSupermanMode, c_Green, t_Hint)
          else PlayObject.SysMsg(sReleaseSupermanMode, c_Green, t_Hint);
        end;
      3:
        begin
          PlayObject.m_boObMode := boOpen;
          if PlayObject.m_boObMode then PlayObject.SysMsg(sObserverMode, c_Green, t_Hint)
          else PlayObject.SysMsg(g_sReleaseObserverMode, c_Green, t_Hint);
        end;
    end;
  end else
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEMODE);
  end;

end;

procedure TNormNpc.ActionOfChangePerMission(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nPermission: Integer;
begin
  nPermission := Str_ToInt(QuestActionInfo.sParam1, -1);
  if nPermission in [0..10] then
  begin
    PlayObject.m_btPermission := nPermission;
  end else
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEPERMISSION);
    Exit;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sChangePermissionMsg, [PlayObject.m_btPermission]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfGiveItem(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  UserItem: pTUserItem;
  StdItem: TItem;
  sItemName: string;
  nItemCount: Integer;
begin
  sItemName := QuestActionInfo.sParam1;
  nItemCount := QuestActionInfo.nParam2;
  if (sItemName = '') or (nItemCount <= 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GIVE);
    Exit;
  end;

  if CompareText(sItemName, sSTRING_GOLDNAME) = 0 then
  begin
    PlayObject.IncGold(nItemCount);
    PlayObject.GoldChanged();
      //0049D2FE
    if g_boGameLogGold then
      AddGameDataLog('9' + #9 +
        PlayObject.m_sMapName + #9 +
        IntToStr(PlayObject.m_nCurrX) + #9 +
        IntToStr(PlayObject.m_nCurrY) + #9 +
        PlayObject.m_sCharName + #9 +
        sSTRING_GOLDNAME + #9 +
        IntToStr(nItemCount) + #9 +
        '1' + #9 +
        m_sCharName);
    Exit;
  end;

  if UserEngine.GetStdItemIdx(sItemName) > 0 then
  begin
//    if nItemCount > 50 then nItemCount:=50;//11.22 限制数量大小
    if not (nItemCount in [1..50]) then nItemCount := 1; //12.28 改上一条
    for i := 0 to nItemCount - 1 do
    begin //nItemCount 为0时出死循环
      if PlayObject.IsEnoughBag then
      begin
        New(UserItem);
        if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then
        begin
          PlayObject.m_ItemList.Add((UserItem));
          PlayObject.SendAddItem(UserItem);
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          //0049D46B
          if StdItem.NeedIdentify = 1 then
            AddGameDataLog('9' + #9 +
              PlayObject.m_sMapName + #9 +
              IntToStr(PlayObject.m_nCurrX) + #9 +
              IntToStr(PlayObject.m_nCurrY) + #9 +
              PlayObject.m_sCharName + #9 +
              sItemName + #9 +
              IntToStr(UserItem.MakeIndex) + #9 +
              '1' + #9 +
              m_sCharName);
        end else Dispose(UserItem);
      end else
      begin
        New(UserItem);
        if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then
        begin
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          //0049D5A5
          if StdItem.NeedIdentify = 1 then
            AddGameDataLog('9' + #9 +
              PlayObject.m_sMapName + #9 +
              IntToStr(PlayObject.m_nCurrX) + #9 +
              IntToStr(PlayObject.m_nCurrY) + #9 +
              PlayObject.m_sCharName + #9 +
              sItemName + #9 +
              IntToStr(UserItem.MakeIndex) + #9 +
              '1' + #9 +
              m_sCharName);
          PlayObject.DropItemDown(UserItem, 3, False, PlayObject, nil);
        end;
        Dispose(UserItem);
      end;
    end;
  end;
end;


procedure TNormNpc.ActionOfGmExecute(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  sData: string;
  btOldPermission: Byte;
  sParam1, sParam2, sParam3, sParam4, sParam5, sParam6: string;
begin
  sParam1 := QuestActionInfo.sParam1;
  sParam2 := QuestActionInfo.sParam2;
  sParam3 := QuestActionInfo.sParam3;
  sParam4 := QuestActionInfo.sParam4;
  sParam5 := QuestActionInfo.sParam5;
  sParam6 := QuestActionInfo.sParam6;
  if CompareText(sParam2, 'Self') = 0 then sParam2 := PlayObject.m_sCharName;

  sData := Format('@%s %s %s %s %s %s', [sParam1,
    sParam2,
      sParam3,
      sParam4,
      sParam5,
      sParam6]);
  btOldPermission := PlayObject.m_btPermission;
  try
    PlayObject.m_btPermission := 10;
    PlayObject.ProcessUserLineMsg(sData);
  finally
    PlayObject.m_btPermission := btOldPermission;
  end;
end;

procedure TNormNpc.ActionOfGuildAuraePoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nAuraePoint: Integer;
  cMethod: Char;
  Guild: TGUild;
begin
  nAuraePoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nAuraePoint < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_AURAEPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    PlayObject.SysMsg(g_sScriptGuildAuraePointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        Guild.nAurae := nAuraePoint;
      end;
    '-':
      begin
        if Guild.nAurae >= nAuraePoint then
        begin
          Guild.nAurae := Guild.nAurae - nAuraePoint;
        end else
        begin
          Guild.nAurae := 0;
        end;
      end;
    '+':
      begin
        if (High(Integer) - Guild.nAurae) >= nAuraePoint then
        begin
          Guild.nAurae := Guild.nAurae + nAuraePoint;
        end else
        begin
          Guild.nAurae := High(Integer);
        end;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sScriptGuildAuraePointMsg, [Guild.nAurae]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfGuildBuildPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);

var
  nBuildPoint: Integer;
  cMethod: Char;
  Guild: TGUild;
begin
  nBuildPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nBuildPoint < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_BUILDPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    PlayObject.SysMsg(g_sScriptGuildBuildPointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        Guild.nBuildPoint := nBuildPoint;
      end;
    '-':
      begin
        if Guild.nBuildPoint >= nBuildPoint then
        begin
          Guild.nBuildPoint := Guild.nBuildPoint - nBuildPoint;
        end else
        begin
          Guild.nBuildPoint := 0;
        end;
      end;
    '+':
      begin
        if (High(Integer) - Guild.nBuildPoint) >= nBuildPoint then
        begin
          Guild.nBuildPoint := Guild.nBuildPoint + nBuildPoint;
        end else
        begin
          Guild.nBuildPoint := High(Integer);
        end;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sScriptGuildBuildPointMsg, [Guild.nBuildPoint]), c_Green, t_Hint);
  end;

end;

procedure TNormNpc.ActionOfGuildChiefItemCount(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nItemCount: Integer;
  cMethod: Char;
  Guild: TGUild;
begin
  nItemCount := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nItemCount < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GUILDCHIEFITEMCOUNT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    PlayObject.SysMsg(g_sScriptGuildFlourishPointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        Guild.nChiefItemCount := nItemCount;
      end;
    '-':
      begin
        if Guild.nChiefItemCount >= nItemCount then
        begin
          Guild.nChiefItemCount := Guild.nChiefItemCount - nItemCount;
        end else
        begin
          Guild.nChiefItemCount := 0;
        end;
      end;
    '+':
      begin
        if (High(Integer) - Guild.nChiefItemCount) >= nItemCount then
        begin
          Guild.nChiefItemCount := Guild.nChiefItemCount + nItemCount;
        end else
        begin
          Guild.nChiefItemCount := High(Integer);
        end;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sScriptChiefItemCountMsg, [Guild.nChiefItemCount]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfGuildFlourishPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);

var
  nFlourishPoint: Integer;
  cMethod: Char;
  Guild: TGUild;
begin
  nFlourishPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nFlourishPoint < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_FLOURISHPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    PlayObject.SysMsg(g_sScriptGuildFlourishPointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        Guild.nFlourishing := nFlourishPoint;
      end;
    '-':
      begin
        if Guild.nFlourishing >= nFlourishPoint then
        begin
          Guild.nFlourishing := Guild.nFlourishing - nFlourishPoint;
        end else
        begin
          Guild.nFlourishing := 0;
        end;
      end;
    '+':
      begin
        if (High(Integer) - Guild.nFlourishing) >= nFlourishPoint then
        begin
          Guild.nFlourishing := Guild.nFlourishing + nFlourishPoint;
        end else
        begin
          Guild.nFlourishing := High(Integer);
        end;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sScriptGuildFlourishPointMsg, [Guild.nFlourishing]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfGuildstabilityPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);

var
  nStabilityPoint: Integer;
  cMethod: Char;
  Guild: TGUild;
begin
  nStabilityPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nStabilityPoint < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_STABILITYPOINT);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    PlayObject.SysMsg(g_sScriptGuildStabilityPointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        Guild.nStability := nStabilityPoint;
      end;
    '-':
      begin
        if Guild.nStability >= nStabilityPoint then
        begin
          Guild.nStability := Guild.nStability - nStabilityPoint;
        end else
        begin
          Guild.nStability := 0;
        end;
      end;
    '+':
      begin
        if (High(Integer) - Guild.nStability) >= nStabilityPoint then
        begin
          Guild.nStability := Guild.nStability + nStabilityPoint;
        end else
        begin
          Guild.nStability := High(Integer);
        end;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sScriptGuildStabilityPointMsg, [Guild.nStability]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfHumanHP(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nHP: Integer;
  cMethod: Char;
begin
  nHP := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nHP < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_HUMANHP);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        PlayObject.m_WAbil.HP := nHP;
      end;
    '-':
      begin
        if PlayObject.m_WAbil.HP >= nHP then
        begin
          Dec(PlayObject.m_WAbil.HP, nHP);
        end else
        begin
          PlayObject.m_WAbil.HP := 0;
        end;
      end;
    '+':
      begin
        Inc(PlayObject.m_WAbil.HP, nHP);
        if PlayObject.m_WAbil.HP > PlayObject.m_WAbil.MaxHP then PlayObject.m_WAbil.HP := PlayObject.m_WAbil.MaxHP;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sScriptChangeHumanHPMsg, [PlayObject.m_WAbil.MaxHP]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfHumanMP(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nMP: Integer;
  cMethod: Char;
begin
  nMP := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nMP < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_HUMANMP);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        PlayObject.m_WAbil.MP := nMP;
      end;
    '-':
      begin
        if PlayObject.m_WAbil.MP >= nMP then
        begin
          Dec(PlayObject.m_WAbil.MP, nMP);
        end else
        begin
          PlayObject.m_WAbil.MP := 0;
        end;
      end;
    '+':
      begin
        Inc(PlayObject.m_WAbil.MP, nMP);
        if PlayObject.m_WAbil.MP > PlayObject.m_WAbil.MaxMP then PlayObject.m_WAbil.MP := PlayObject.m_WAbil.MaxMP;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sScriptChangeHumanMPMsg, [PlayObject.m_WAbil.MaxMP]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfKick(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.m_boKickFlag := True;
end;

procedure TNormNpc.ActionOfKill(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nMode: Integer;
begin
  nMode := Str_ToInt(QuestActionInfo.sParam1, -1);
  if nMode in [0..3] then
  begin
    case nMode of //
      1:
        begin
          PlayObject.m_boNoItem := True;
          PlayObject.Die;
        end;
      2:
        begin
          PlayObject.SetLastHiter(Self);
          PlayObject.Die;
        end;
      3:
        begin
          PlayObject.m_boNoItem := True;
          PlayObject.SetLastHiter(Self);
          PlayObject.Die;
        end;
    else
      begin
        PlayObject.Die;
      end;
    end;
  end else
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_KILL);
  end;

end;

procedure TNormNpc.ActionOfBonusPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nBonusPoint: Integer;
  nPoint: Integer;
  nOldPKLevel: Integer;
  cMethod: Char;
begin
  nBonusPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nBonusPoint < 0) or (nBonusPoint > 10000) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_BONUSPOINT);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        FillChar(PlayObject.m_BonusAbil, SizeOf(TNakedAbility), #0);
        PlayObject.HasLevelUp(0);
        PlayObject.m_nBonusPoint := nBonusPoint;
        PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
      end;
    '-':
      begin

      end;
    '+':
      begin
        Inc(PlayObject.m_nBonusPoint, nBonusPoint);
        PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
      end;
  end;
end;


procedure TNormNpc.ActionOfRestBonusPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nTotleUsePoint: Integer;
begin
  nTotleUsePoint := PlayObject.m_BonusAbil.DC +
    PlayObject.m_BonusAbil.MC +
    PlayObject.m_BonusAbil.SC +
    PlayObject.m_BonusAbil.AC +
    PlayObject.m_BonusAbil.MAC +
    PlayObject.m_BonusAbil.HP +
    PlayObject.m_BonusAbil.MP +
    PlayObject.m_BonusAbil.Hit +
    PlayObject.m_BonusAbil.Speed +
    PlayObject.m_BonusAbil.X2;
  FillChar(PlayObject.m_BonusAbil, SizeOf(TNakedAbility), #0);


  Inc(PlayObject.m_nBonusPoint, nTotleUsePoint);
  PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
  PlayObject.HasLevelUp(0);
  PlayObject.SysMsg('分配点数已复位！！！', c_Red, t_Hint);
end;

procedure TNormNpc.ActionOfRestReNewLevel(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.m_btReLevel := 0;
  PlayObject.HasLevelUp(0);
end;

procedure TNormNpc.ActionOfSetMapMode(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  Envir: TEnvirnoment;
  sMapName: string;
  sMapMode, sParam1, sParam2 {,sParam3,sParam4}: string;
begin
  sMapName := QuestActionInfo.sParam1;
  sMapMode := QuestActionInfo.sParam2;
  sParam1 := QuestActionInfo.sParam3;
  sParam2 := QuestActionInfo.sParam4;
//  sParam3:=QuestActionInfo.sParam5;
//  sParam4:=QuestActionInfo.sParam6;

  Envir := g_MapManager.FindMap(sMapName);
  if (Envir = nil) or (sMapMode = '') then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETMAPMODE);
    Exit;
  end;
  if CompareText(sMapMode, 'SAFE') = 0 then
  begin
    if (sParam1 <> '') then
    begin
      Envir.Flag.boSAFE := True;
    end else
    begin
      Envir.Flag.boSAFE := False;
    end;
  end else
    if CompareText(sMapMode, 'DARK') = 0 then
    begin
      if (sParam1 <> '') then
      begin
        Envir.Flag.boDARKness := True;
      end else
      begin
        Envir.Flag.boDARKness := False;
      end;
    end else
      if CompareText(sMapMode, 'FIGHT') = 0 then
      begin
        if (sParam1 <> '') then
        begin
          Envir.Flag.boFIGHTZone := True;
        end else
        begin
          Envir.Flag.boFIGHTZone := False;
        end;
      end else
        if CompareText(sMapMode, 'FIGHT3') = 0 then
        begin
          if (sParam1 <> '') then
          begin
            Envir.Flag.boFIGHT3Zone := True;
          end else
          begin
            Envir.Flag.boFIGHT3Zone := False;
          end;
        end else
          if CompareText(sMapMode, 'DAY') = 0 then
          begin
            if (sParam1 <> '') then
            begin
              Envir.Flag.boDAYLIGHT := True;
            end else
            begin
              Envir.Flag.boDAYLIGHT := False;
            end;
          end else
            if CompareText(sMapMode, 'QUIZ') = 0 then
            begin
              if (sParam1 <> '') then
              begin
                Envir.Flag.boQUIZ := True;
              end else
              begin
                Envir.Flag.boQUIZ := False;
              end;
            end else
              if CompareText(sMapMode, 'NORECONNECT') = 0 then
              begin
                if (sParam1 <> '') then
                begin
                  Envir.Flag.boNORECONNECT := True;
                  Envir.Flag.sNOReConnectMap := sParam1;
                end else
                begin
                  Envir.Flag.boNORECONNECT := False;
                end;
              end else
                if CompareText(sMapMode, 'MUSIC') = 0 then
                begin
                  if (sParam1 <> '') then
                  begin
                    Envir.Flag.boMUSIC := True;
                    Envir.Flag.nMUSICID := Str_ToInt(sParam1, -1);
                  end else
                  begin
                    Envir.Flag.boMUSIC := False;
                  end;
                end else
                  if CompareText(sMapMode, 'EXPRATE') = 0 then
                  begin
                    if (sParam1 <> '') then
                    begin
                      Envir.Flag.boEXPRATE := True;
                      Envir.Flag.nEXPRATE := Str_ToInt(sParam1, -1);
                    end else
                    begin
                      Envir.Flag.boEXPRATE := False;
                    end;
                  end else
                    if CompareText(sMapMode, 'PKWINLEVEL') = 0 then
                    begin
                      if (sParam1 <> '') then
                      begin
                        Envir.Flag.boPKWINLEVEL := True;
                        Envir.Flag.nPKWINLEVEL := Str_ToInt(sParam1, -1);
                      end else
                      begin
                        Envir.Flag.boPKWINLEVEL := False;
                      end;
                    end else
                      if CompareText(sMapMode, 'PKWINEXP') = 0 then
                      begin
                        if (sParam1 <> '') then
                        begin
                          Envir.Flag.boPKWINEXP := True;
                          Envir.Flag.nPKWINEXP := Str_ToInt(sParam1, -1);
                        end else
                        begin
                          Envir.Flag.boPKWINEXP := False;
                        end;
                      end else
                        if CompareText(sMapMode, 'PKLOSTLEVEL') = 0 then
                        begin
                          if (sParam1 <> '') then
                          begin
                            Envir.Flag.boPKLOSTLEVEL := True;
                            Envir.Flag.nPKLOSTLEVEL := Str_ToInt(sParam1, -1);
                          end else
                          begin
                            Envir.Flag.boPKLOSTLEVEL := False;
                          end;
                        end else
                          if CompareText(sMapMode, 'PKLOSTEXP') = 0 then
                          begin
                            if (sParam1 <> '') then
                            begin
                              Envir.Flag.boPKLOSTEXP := True;
                              Envir.Flag.nPKLOSTEXP := Str_ToInt(sParam1, -1);
                            end else
                            begin
                              Envir.Flag.boPKLOSTEXP := False;
                            end;
                          end else
                            if CompareText(sMapMode, 'DECHP') = 0 then
                            begin
                              if (sParam1 <> '') and (sParam2 <> '') then
                              begin
                                Envir.Flag.boDECHP := True;
                                Envir.Flag.nDECHPTIME := Str_ToInt(sParam1, -1);
                                Envir.Flag.nDECHPPOINT := Str_ToInt(sParam2, -1);
                              end else
                              begin
                                Envir.Flag.boDECHP := False;
                              end;
                            end else
                              if CompareText(sMapMode, 'DECGAMEGOLD') = 0 then
                              begin
                                if (sParam1 <> '') and (sParam2 <> '') then
                                begin
                                  Envir.Flag.boDECGAMEGOLD := True;
                                  Envir.Flag.nDECGAMEGOLDTIME := Str_ToInt(sParam1, -1);
                                  Envir.Flag.nDECGAMEGOLD := Str_ToInt(sParam2, -1);
                                end else
                                begin
                                  Envir.Flag.boDECGAMEGOLD := False;
                                end;
                              end else
                                if CompareText(sMapMode, 'RUNHUMAN') = 0 then
                                begin
                                  if (sParam1 <> '') then
                                  begin
                                    Envir.Flag.boRUNHUMAN := True;
                                  end else
                                  begin
                                    Envir.Flag.boRUNHUMAN := False;
                                  end;
                                end else
                                  if CompareText(sMapMode, 'RUNMON') = 0 then
                                  begin
                                    if (sParam1 <> '') then
                                    begin
                                      Envir.Flag.boRUNMON := True;
                                    end else
                                    begin
                                      Envir.Flag.boRUNMON := False;
                                    end;
                                  end else
                                    if CompareText(sMapMode, 'NEEDHOLE') = 0 then
                                    begin
                                      if (sParam1 <> '') then
                                      begin
                                        Envir.Flag.boNEEDHOLE := True;
                                      end else
                                      begin
                                        Envir.Flag.boNEEDHOLE := False;
                                      end;
                                    end else
                                      if CompareText(sMapMode, 'NORECALL') = 0 then
                                      begin
                                        if (sParam1 <> '') then
                                        begin
                                          Envir.Flag.boNORECALL := True;
                                        end else
                                        begin
                                          Envir.Flag.boNORECALL := False;
                                        end;
                                      end else
                                        if CompareText(sMapMode, 'NOGUILDRECALL') = 0 then
                                        begin
                                          if (sParam1 <> '') then
                                          begin
                                            Envir.Flag.boNOGUILDRECALL := True;
                                          end else
                                          begin
                                            Envir.Flag.boNOGUILDRECALL := False;
                                          end;
                                        end else
                                        
//取消 结婚 与 师徒 的相关内容
{
                                          if CompareText(sMapMode, 'NODEARRECALL') = 0 then
                                          begin
                                            if (sParam1 <> '') then
                                            begin
                                              Envir.Flag.boNODEARRECALL := True;
                                            end else
                                            begin
                                              Envir.Flag.boNODEARRECALL := False;
                                            end;
                                          end else
                                            if CompareText(sMapMode, 'NOMASTERRECALL') = 0 then
                                            begin
                                              if (sParam1 <> '') then
                                              begin
                                                Envir.Flag.boNOMASTERRECALL := True;
                                              end else
                                              begin
                                                Envir.Flag.boNOMASTERRECALL := False;
                                              end;
                                            end else
}

                                              if CompareText(sMapMode, 'NORANDOMMOVE') = 0 then
                                              begin
                                                if (sParam1 <> '') then
                                                begin
                                                  Envir.Flag.boNORANDOMMOVE := True;
                                                end else
                                                begin
                                                  Envir.Flag.boNORANDOMMOVE := False;
                                                end;
                                              end else
                                                if CompareText(sMapMode, 'NODRUG') = 0 then
                                                begin
                                                  if (sParam1 <> '') then
                                                  begin
                                                    Envir.Flag.boNODRUG := True;
                                                  end else
                                                  begin
                                                    Envir.Flag.boNODRUG := False;
                                                  end;
                                                end else
                                                  if CompareText(sMapMode, 'MINE') = 0 then
                                                  begin
                                                    if (sParam1 <> '') then
                                                    begin
                                                      Envir.Flag.boMINE := True;
                                                    end else
                                                    begin
                                                      Envir.Flag.boMINE := False;
                                                    end;
                                                  end else
                                                    if CompareText(sMapMode, 'MINE2') = 0 then
                                                    begin
                                                      if (sParam1 <> '') then
                                                      begin
                                                        Envir.Flag.boMINE2 := True;
                                                      end else
                                                      begin
                                                        Envir.Flag.boMINE2 := False;
                                                      end;
                                                    end else
                                                      if CompareText(sMapMode, 'NOTHROWITEM') = 0 then
                                                      begin
                                                        if (sParam1 <> '') then
                                                        begin
                                                          Envir.Flag.boNOTHROWITEM := True;
                                                        end else
                                                        begin
                                                          Envir.Flag.boNOTHROWITEM := False;
                                                        end;
                                                      end else
                                                        if CompareText(sMapMode, 'NODROPITEM') = 0 then
                                                        begin
                                                          if (sParam1 <> '') then
                                                          begin
                                                            Envir.Flag.boNODROPITEM := True;
                                                          end else
                                                          begin
                                                            Envir.Flag.boNODROPITEM := False;
                                                          end;
                                                        end else
                                                          if CompareText(sMapMode, 'NOPOSITIONMOVE') = 0 then
                                                          begin
                                                            if (sParam1 <> '') then
                                                            begin
                                                              Envir.Flag.boNOPOSITIONMOVE := True;
                                                            end else
                                                            begin
                                                              Envir.Flag.boNOPOSITIONMOVE := False;
                                                            end;
                                                          end else
                                                            if CompareText(sMapMode, 'NOHORSE') = 0 then
                                                            begin
                                                              if (sParam1 <> '') then
                                                              begin
                                                                Envir.Flag.boNOHORSE := True;
                                                              end else
                                                              begin
                                                                Envir.Flag.boNOHORSE := False;
                                                              end;
                                                            end else
                                                              if CompareText(sMapMode, 'NOCHAT') = 0 then
                                                              begin
                                                                if (sParam1 <> '') then
                                                                begin
                                                                  Envir.Flag.boNOCHAT := True;
                                                                end else
                                                                begin
                                                                  Envir.Flag.boNOCHAT := False;
                                                                end;
                                                              end;
end;

procedure TNormNpc.ActionOfSetMemberLevel(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nLevel: Integer;
  cMethod: Char;
begin
  nLevel := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETMEMBERLEVEL);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        PlayObject.m_nMemberLevel := nLevel;
      end;
    '-':
      begin
        Dec(PlayObject.m_nMemberLevel, nLevel);
        if PlayObject.m_nMemberLevel < 0 then PlayObject.m_nMemberLevel := 0;
      end;
    '+':
      begin
        Inc(PlayObject.m_nMemberLevel, nLevel);
        if PlayObject.m_nMemberLevel > 65535 then PlayObject.m_nMemberLevel := 65535;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sChangeMemberLevelMsg, [PlayObject.m_nMemberLevel]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfSetMemberType(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nType: Integer;
  cMethod: Char;
begin
  nType := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nType < 0 then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETMEMBERTYPE);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=':
      begin
        PlayObject.m_nMemberType := nType;
      end;
    '-':
      begin
        Dec(PlayObject.m_nMemberType, nType);
        if PlayObject.m_nMemberType < 0 then PlayObject.m_nMemberType := 0;
      end;
    '+':
      begin
        Inc(PlayObject.m_nMemberType, nType);
        if PlayObject.m_nMemberType > 65535 then PlayObject.m_nMemberType := 65535;
      end;
  end;
  if g_Config.boShowScriptActionMsg then
  begin
    PlayObject.SysMsg(Format(g_sChangeMemberTypeMsg, [PlayObject.m_nMemberType]), c_Green, t_Hint);
  end;
end;

function TNormNpc.ConditionOfCheckGuildList(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
end;


function TNormNpc.ConditionOfCheckRangeMonCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  sMapName: string;
  nX, nY, nRange, nCount: Integer;
  cMethod: Char;
  nMapRangeCount: Integer;
  Envir: TEnvirnoment;
  MonList: TList;
  BaseObject: TBaseObject;
begin
  Result := False;
  sMapName := QuestConditionInfo.sParam1;
  nX := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nY := Str_ToInt(QuestConditionInfo.sParam3, -1);
  nRange := Str_ToInt(QuestConditionInfo.sParam4, -1);
  cMethod := QuestConditionInfo.sParam5[1];
  nCount := Str_ToInt(QuestConditionInfo.sParam6, -1);
  Envir := g_MapManager.FindMap(sMapName);
  if (Envir = nil) or (nX < 0) or (nY < 0) or (nRange < 0) or (nCount < 0) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKRANGEMONCOUNT);
    Exit;
  end;
  MonList := TList.Create;
  nMapRangeCount := Envir.GetRangeBaseObject(nX, nY, nRange, True, MonList);
  for i := MonList.Count - 1 downto 0 do
  begin
    BaseObject := TBaseObject(MonList.Items[i]);
    if (BaseObject.m_btRaceServer < RC_ANIMAL) or (BaseObject.m_btRaceServer = RC_ARCHERGUARD) or (BaseObject.m_Master <> nil) then
      MonList.Delete(i);
  end;
  nMapRangeCount := MonList.Count;
  case cMethod of
    '=': if nMapRangeCount = nCount then Result := True;
    '>': if nMapRangeCount > nCount then Result := True;
    '<': if nMapRangeCount < nCount then Result := True;
  else if nMapRangeCount >= nCount then Result := True;
  end;
  MonList.Free;
end;

function TNormNpc.ConditionOfCheckReNewLevel(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nLevel: Integer;
  cMethod: Char;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKLEVELEX);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_btReLevel = nLevel then Result := True;
    '>': if PlayObject.m_btReLevel > nLevel then Result := True;
    '<': if PlayObject.m_btReLevel < nLevel then Result := True;
  else if PlayObject.m_btReLevel >= nLevel then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckSlaveLevel(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  nLevel: Integer;
  cMethod: Char;
  BaseObject: TBaseObject;
  nSlaveLevel: Integer;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKLEVELEX);
    Exit;
  end;
  nSlaveLevel := -1;
  for i := 0 to PlayObject.m_SlaveList.Count - 1 do
  begin
    BaseObject := TBaseObject(PlayObject.m_SlaveList.Items[i]);
    if BaseObject.m_Abil.Level > nSlaveLevel then nSlaveLevel := BaseObject.m_Abil.Level;
  end;
  if nSlaveLevel < 0 then Exit;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nSlaveLevel = nLevel then Result := True;
    '>': if nSlaveLevel > nLevel then Result := True;
    '<': if nSlaveLevel < nLevel then Result := True;
  else if nSlaveLevel >= nLevel then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckUseItem(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nWhere: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := False;
  nWhere := Str_ToInt(QuestConditionInfo.sParam1, -1);
  if (nWhere < 0) or (nWhere > High(THumanUseItems)) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKUSEITEM);
    Exit;
  end;
  if PlayObject.m_UseItems[nWhere].wIndex > 0 then
    Result := True;

end;

function TNormNpc.ConditionOfCheckVar(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  sType: string;
  VarType: TVarType;
  sVarName: string;
  sVarValue: string;
  nVarValue: Integer;
  sName: string;
  sMethod: string;
  cMethod: Char;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
resourcestring
  sVarFound = '变量%s已存在，变量类型:%s';
  sVarTypeError = '变量类型错误，错误类型:%s 当前支持类型(HUMAN、GUILD、GLOBAL)';
begin
  Result := False;
  sType := QuestConditionInfo.sParam1;
  sVarName := QuestConditionInfo.sParam2;
  sMethod := QuestConditionInfo.sParam3;
  nVarValue := Str_ToInt(QuestConditionInfo.sParam4, 0);
  sVarValue := QuestConditionInfo.sParam4;

  if (sType = '') or (sVarName = '') or (sMethod = '') then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKVAR);
    Exit;
  end;
  cMethod := sMethod[1];
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then
  begin
    ScriptConditionError(PlayObject {,format(sVarTypeError,[sType])}, QuestConditionInfo, sSC_CHECKVAR);
    Exit;
  end;
  for i := 0 to DynamicVarList.Count - 1 do
  begin
    DynamicVar := DynamicVarList.Items[i];
    if CompareText(DynamicVar.sName, sVarName) = 0 then
    begin
      case DynamicVar.VarType of
        vInteger:
          begin
            case cMethod of
              '=': if DynamicVar.nInternet = nVarValue then Result := True;
              '>': if DynamicVar.nInternet > nVarValue then Result := True;
              '<': if DynamicVar.nInternet < nVarValue then Result := True;
            else if DynamicVar.nInternet >= nVarValue then Result := True;
            end;
          end;
        vString: ;
      end;

      boFoundVar := True;
      Break;
    end;
  end;
  if not boFoundVar then
    ScriptConditionError(PlayObject, {format(sVarFound,[sVarName,sType]),} QuestConditionInfo, sSC_CHECKVAR);

end;

{
function TNormNpc.ConditionOfHaveMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if PlayObject.m_sMasterName <> '' then
    Result := True;
end;

function TNormNpc.ConditionOfPoseHaveMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then
  begin
    if (TPlayObject(PoseHuman).m_sMasterName <> '') then
      Result := True;
  end;
end;

}

function TNormNpc.ConditionOfCheckCastleGold(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nGold: Integer;
begin
  Result := False;
  nGold := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if (nGold < 0) or (m_Castle = nil) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKCASTLEGOLD);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if TUserCastle(m_Castle).m_nTotalGold = nGold then Result := True;
    '>': if TUserCastle(m_Castle).m_nTotalGold > nGold then Result := True;
    '<': if TUserCastle(m_Castle).m_nTotalGold < nGold then Result := True;
  else if TUserCastle(m_Castle).m_nTotalGold >= nGold then Result := True;
  end;
  {
  Result:=False;
  nGold:=Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nGold < 0 then begin
    ScriptConditionError(PlayObject,QuestConditionInfo,sSC_CHECKCASTLEGOLD);
    exit;
  end;
  cMethod:=QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if UserCastle.m_nTotalGold = nGold then Result:=True;
    '>': if UserCastle.m_nTotalGold > nGold then Result:=True;
    '<': if UserCastle.m_nTotalGold < nGold then Result:=True;
    else if UserCastle.m_nTotalGold >= nGold then Result:=True;
  end;
  }
end;


function TNormNpc.ConditionOfCheckContribution(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nContribution: Integer;
  cMethod: Char;
begin
  Result := False;
  nContribution := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nContribution < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKCONTRIBUTION);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_wContribution = nContribution then Result := True;
    '>': if PlayObject.m_wContribution > nContribution then Result := True;
    '<': if PlayObject.m_wContribution < nContribution then Result := True;
  else if PlayObject.m_wContribution >= nContribution then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckCreditPoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCreditPoint: Integer;
  cMethod: Char;
begin
  Result := False;
  nCreditPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCreditPoint < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKCREDITPOINT);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_btCreditPoint = nCreditPoint then Result := True;
    '>': if PlayObject.m_btCreditPoint > nCreditPoint then Result := True;
    '<': if PlayObject.m_btCreditPoint < nCreditPoint then Result := True;
  else if PlayObject.m_btCreditPoint >= nCreditPoint then Result := True;
  end;
end;




procedure TNormNpc.ActionOfClearNeedItems(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  nNeed: Integer;
  UserItem: pTUserItem;
  StdItem: TItem;
begin
  nNeed := Str_ToInt(QuestActionInfo.sParam1, -1);
  if (nNeed < 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CLEARNEEDITEMS);
    Exit;
  end;
  for i := PlayObject.m_ItemList.Count - 1 downto 0 do
  begin
    UserItem := PlayObject.m_ItemList.Items[i];
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (StdItem <> nil) and (StdItem.Need = nNeed) then
    begin
      PlayObject.SendDelItems(UserItem);
      Dispose(UserItem);
      PlayObject.m_ItemList.Delete(i);
    end;
  end;

  for i := PlayObject.m_StorageItemList.Count - 1 downto 0 do
  begin
    UserItem := PlayObject.m_StorageItemList.Items[i];
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (StdItem <> nil) and (StdItem.Need = nNeed) then
    begin
      Dispose(UserItem);
      PlayObject.m_StorageItemList.Delete(i);
    end;
  end;
end;

procedure TNormNpc.ActionOfClearMakeItems(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  nMakeIndex: Integer;
  sItemName: string;
  UserItem: pTUserItem;
  StdItem: TItem;
  boMatchName: Boolean;
begin
  sItemName := QuestActionInfo.sParam1;
  nMakeIndex := QuestActionInfo.nParam2;
  boMatchName := QuestActionInfo.sParam3 = '1';
  if (sItemName = '') or (nMakeIndex <= 0) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CLEARMAKEITEMS);
    Exit;
  end;
  for i := PlayObject.m_ItemList.Count - 1 downto 0 do
  begin
    UserItem := PlayObject.m_ItemList.Items[i];
    if UserItem.MakeIndex <> nMakeIndex then Continue;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if not boMatchName or ((StdItem <> nil) and (CompareText(StdItem.Name, sItemName) = 0)) then
    begin
      PlayObject.SendDelItems(UserItem);
      Dispose(UserItem);
      PlayObject.m_ItemList.Delete(i);
    end;
  end;

  for i := PlayObject.m_StorageItemList.Count - 1 downto 0 do
  begin
    UserItem := PlayObject.m_ItemList.Items[i];
    if UserItem.MakeIndex <> nMakeIndex then Continue;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if not boMatchName or ((StdItem <> nil) and (CompareText(StdItem.Name, sItemName) = 0)) then
    begin
      Dispose(UserItem);
      PlayObject.m_StorageItemList.Delete(i);
    end;
  end;

  for i := Low(PlayObject.m_UseItems) to High(PlayObject.m_UseItems) do
  begin
    UserItem := @PlayObject.m_UseItems[i];
    if UserItem.MakeIndex <> nMakeIndex then Continue;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if not boMatchName or ((StdItem <> nil) and (CompareText(StdItem.Name, sItemName) = 0)) then
    begin
      UserItem.wIndex := 0;
    end;
  end;
end;

procedure TNormNpc.SendCustemMsg(PlayObject: TPlayObject; sMsg: string);
begin
  if not g_Config.boSendCustemMsg then
  begin
    PlayObject.SysMsg(g_sSendCustMsgCanNotUseNowMsg, c_Red, t_Hint);
    Exit;
  end;
  if PlayObject.m_boSendMsgFlag then
  begin
    PlayObject.m_boSendMsgFlag := False;
    UserEngine.SendBroadCastMsg(PlayObject.m_sCharName + ': ' + sMsg, t_Cust);
  end else
  begin

  end;
end;

function TNormNpc.ConditionOfCheckOfGuild(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if QuestConditionInfo.sParam1 = '' then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKOFGUILD);
    Exit;
  end;
  if (PlayObject.m_MyGuild <> nil) then
  begin
    if CompareText(TGUild(PlayObject.m_MyGuild).sGuildName, QuestConditionInfo.sParam1) = 0 then
    begin
      Result := True;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckOnlineLongMin(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nOnlineMin: Integer;
  nOnlineTime: Integer;
begin
  Result := False;
  nOnlineMin := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nOnlineMin < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ONLINELONGMIN);
    Exit;
  end;
  nOnlineTime := (GetTickCount - PlayObject.m_dwLogonTick) div 60000;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nOnlineTime = nOnlineMin then Result := True;
    '>': if nOnlineTime > nOnlineMin then Result := True;
    '<': if nOnlineTime < nOnlineMin then Result := True;
  else if nOnlineTime >= nOnlineMin then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckPasswordErrorCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nErrorCount: Integer;
  cMethod: Char;
begin
  Result := False;
  nErrorCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nErrorCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_PASSWORDERRORCOUNT);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_btPwdFailCount = nErrorCount then Result := True;
    '>': if PlayObject.m_btPwdFailCount > nErrorCount then Result := True;
    '<': if PlayObject.m_btPwdFailCount < nErrorCount then Result := True;
  else if PlayObject.m_btPwdFailCount >= nErrorCount then Result := True;
  end;
end;

function TNormNpc.ConditionOfIsLockPassword(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := PlayObject.m_boPasswordLocked;
end;

function TNormNpc.ConditionOfIsLockStorage(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := not PlayObject.m_boCanGetBackItem;
end;

function TNormNpc.ConditionOfCheckPayMent(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nPayMent: Integer;
begin
  Result := False;
  nPayMent := Str_ToInt(QuestConditionInfo.sParam1, -1);
  if nPayMent < 1 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKPAYMENT);
    Exit;
  end;

  if PlayObject.m_nPayMent = nPayMent then Result := True;

end;

function TNormNpc.ConditionOfCheckSlaveName(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  sSlaveName: string;
  BaseObject: TBaseObject;
begin
  Result := False;
  sSlaveName := QuestConditionInfo.sParam1;
  if sSlaveName = '' then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKSLAVENAME);
    Exit;
  end;

  for i := 0 to PlayObject.m_SlaveList.Count - 1 do
  begin
    BaseObject := TBaseObject(PlayObject.m_SlaveList.Items[i]);
    if CompareText(sSlaveName, BaseObject.m_sCharName) = 0 then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TNormNpc.ActionOfUpgradeItems(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nRate, nWhere, nValType, nPoint, nAddPoint: Integer;
  UserItem: pTUserItem;
  StdItem: TItem;
begin
  nWhere := Str_ToInt(QuestActionInfo.sParam1, -1);
  nRate := Str_ToInt(QuestActionInfo.sParam2, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam3, -1);
  if (nWhere < 0) or (nWhere > High(THumanUseItems)) or (nRate < 0) or (nPoint < 0) or (nPoint > 255) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_UPGRADEITEMS);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nWhere];
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if (UserItem.wIndex <= 0) or (StdItem = nil) then
  begin
    PlayObject.SysMsg('你身上没有戴指定物品！！！', c_Red, t_Hint);
    Exit;
  end;
  nRate := Random(nRate);
  nPoint := Random(nPoint);
  nValType := Random(14);
  if nRate <> 0 then
  begin
    PlayObject.SysMsg('装备升级失败！！！', c_Red, t_Hint);
    Exit;
  end;
  if nValType = 14 then
  begin
    nAddPoint := (nPoint * 1000);
    if UserItem.DuraMax + nAddPoint > High(Word) then
    begin
      nAddPoint := High(Word) - UserItem.DuraMax;
    end;


    UserItem.DuraMax := UserItem.DuraMax + nAddPoint;
  end else
  begin
    nAddPoint := nPoint;
    if UserItem.btValue[nValType] + nAddPoint > High(Byte) then
    begin
      nAddPoint := High(Byte) - UserItem.btValue[nValType];
    end;

    UserItem.btValue[nValType] := UserItem.btValue[nValType] + nAddPoint;
  end;
  PlayObject.SendUpdateItem(UserItem);
  PlayObject.SysMsg('装备升级成功', c_Green, t_Hint);
  PlayObject.SysMsg(StdItem.Name + ': ' +
    IntToStr(UserItem.Dura) + '/' +
    IntToStr(UserItem.DuraMax) + '/' +
    IntToStr(UserItem.btValue[0]) + '/' +
    IntToStr(UserItem.btValue[1]) + '/' +
    IntToStr(UserItem.btValue[2]) + '/' +

    IntToStr(UserItem.btValue[3]) + '/' +
    IntToStr(UserItem.btValue[4]) + '/' +
    IntToStr(UserItem.btValue[5]) + '/' +
    IntToStr(UserItem.btValue[6]) + '/' +
    IntToStr(UserItem.btValue[7]) + '/' +
    IntToStr(UserItem.btValue[8]) + '/' +
    IntToStr(UserItem.btValue[9]) + '/' +
    IntToStr(UserItem.btValue[10]) + '/' +
    IntToStr(UserItem.btValue[11]) + '/' +
    IntToStr(UserItem.btValue[12]) + '/' +
    IntToStr(UserItem.btValue[13])
    , c_Blue, t_Hint);

end;

procedure TNormNpc.ActionOfUpgradeItemsEx(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nRate, nWhere, nValType, nPoint, nAddPoint: Integer;
  UserItem: pTUserItem;
  StdItem: TItem;
  nUpgradeItemStatus: Integer;
  nRatePoint: Integer;
begin
  nWhere := Str_ToInt(QuestActionInfo.sParam1, -1);
  nValType := Str_ToInt(QuestActionInfo.sParam2, -1);
  nRate := Str_ToInt(QuestActionInfo.sParam3, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam4, -1);
  nUpgradeItemStatus := Str_ToInt(QuestActionInfo.sParam5, -1);
  if (nValType < 0) or (nValType > 14) or (nWhere < 0) or (nWhere > High(THumanUseItems)) or (nRate < 0) or (nPoint < 0) or (nPoint > 255) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_UPGRADEITEMSEX);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nWhere];
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if (UserItem.wIndex <= 0) or (StdItem = nil) then
  begin
    PlayObject.SysMsg('你身上没有戴指定物品！！！', c_Red, t_Hint);
    Exit;
  end;
  nRatePoint := Random(nRate * 10);
  nPoint := _MAX(1, Random(nPoint));

  if not (nRatePoint in [0..10]) then
  begin
    case nUpgradeItemStatus of //
      0:
        begin
          PlayObject.SysMsg('装备升级未成功！！！', c_Red, t_Hint);
        end;
      1:
        begin
          PlayObject.SendDelItems(UserItem);
          UserItem.wIndex := 0;
          PlayObject.SysMsg('装备破碎！！！', c_Red, t_Hint);
        end;
      2:
        begin
          PlayObject.SysMsg('装备升级失败，装备属性恢复默认！！！', c_Red, t_Hint);
          if nValType <> 14 then
            UserItem.btValue[nValType] := 0;
        end;
    end;
    Exit;
  end;
  if nValType = 14 then
  begin
    nAddPoint := (nPoint * 1000);
    if UserItem.DuraMax + nAddPoint > High(Word) then
    begin
      nAddPoint := High(Word) - UserItem.DuraMax;
    end;


    UserItem.DuraMax := UserItem.DuraMax + nAddPoint;
  end else
  begin
    nAddPoint := nPoint;
    if UserItem.btValue[nValType] + nAddPoint > High(Byte) then
    begin
      nAddPoint := High(Byte) - UserItem.btValue[nValType];
    end;

    UserItem.btValue[nValType] := UserItem.btValue[nValType] + nAddPoint;
  end;
  PlayObject.SendUpdateItem(UserItem);
  PlayObject.SysMsg('装备升级成功', c_Green, t_Hint);
  PlayObject.SysMsg(StdItem.Name + ': ' +
    IntToStr(UserItem.Dura) + '/' +
    IntToStr(UserItem.DuraMax) + '-' +
    IntToStr(UserItem.btValue[0]) + '/' +
    IntToStr(UserItem.btValue[1]) + '/' +
    IntToStr(UserItem.btValue[2]) + '/' +
    IntToStr(UserItem.btValue[3]) + '/' +
    IntToStr(UserItem.btValue[4]) + '/' +
    IntToStr(UserItem.btValue[5]) + '/' +
    IntToStr(UserItem.btValue[6]) + '/' +
    IntToStr(UserItem.btValue[7]) + '/' +
    IntToStr(UserItem.btValue[8]) + '/' +
    IntToStr(UserItem.btValue[9]) + '/' +
    IntToStr(UserItem.btValue[10]) + '/' +
    IntToStr(UserItem.btValue[11]) + '/' +
    IntToStr(UserItem.btValue[12]) + '/' +
    IntToStr(UserItem.btValue[13])
    , c_Blue, t_Hint);

end;
//声明变量
//VAR 数据类型(Integer String) 类型(HUMAN GUILD GLOBAL) 变量值
procedure TNormNpc.ActionOfVar(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sType: string;
  VarType: TVarType;
  sVarName: string;
  sVarValue: string;
  nVarValue: Integer;
  sName: string;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
resourcestring
  sVarFound = '变量%s已存在，变量类型:%s';
  sVarTypeError = '变量类型错误，错误类型:%s 当前支持类型(HUMAN、GUILD、GLOBAL)';
begin
  sType := QuestActionInfo.sParam2;
  sVarName := QuestActionInfo.sParam3;
  sVarValue := QuestActionInfo.sParam4;
  nVarValue := Str_ToInt(QuestActionInfo.sParam4, 0);
  VarType := vNone;
  if CompareText(QuestActionInfo.sParam1, 'Integer') = 0 then VarType := vInteger;
  if CompareText(QuestActionInfo.sParam1, 'String') = 0 then VarType := vString;

  if (sType = '') or (sVarName = '') or (VarType = vNone) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_VAR);
    Exit;
  end;
  New(DynamicVar);
  DynamicVar.sName := sVarName;
  DynamicVar.VarType := VarType;
  DynamicVar.nInternet := nVarValue;
  DynamicVar.sString := sVarValue;
  boFoundVar := False;
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then
  begin
    Dispose(DynamicVar);
    ScriptActionError(PlayObject, Format(sVarTypeError, [sType]), QuestActionInfo, sSC_VAR);
    Exit;
  end;
  for i := 0 to DynamicVarList.Count - 1 do
  begin
    if CompareText(pTDynamicVar(DynamicVarList.Items[i]).sName, sVarName) = 0 then
    begin
      boFoundVar := True;
      Break;
    end;
  end;
  if not boFoundVar then
  begin
    DynamicVarList.Add(DynamicVar);
  end else
  begin
    ScriptActionError(PlayObject, Format(sVarFound, [sVarName, sType]), QuestActionInfo, sSC_VAR);
  end;

end;
//读取变量值
//LOADVAR 变量类型 变量名 文件名
procedure TNormNpc.ActionOfLoadVar(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sType: string;
  sVarName: string;
  sFileName: string;
  sName: string;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
  IniFile: TIniFile;
resourcestring
  sVarFound = '变量%s不存在，变量类型:%s';
  sVarTypeError = '变量类型错误，错误类型:%s 当前支持类型(HUMAN、GUILD、GLOBAL)';
begin
  sType := QuestActionInfo.sParam1;
  sVarName := QuestActionInfo.sParam2;
  sFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam3;
  if (sType = '') or (sVarName = '') or not FileExists(sFileName) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_LOADVAR);
    Exit;
  end;
  boFoundVar := False;
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then
  begin
    Dispose(DynamicVar);
    ScriptActionError(PlayObject, Format(sVarTypeError, [sType]), QuestActionInfo, sSC_VAR);
    Exit;
  end;
  IniFile := TIniFile.Create(sFileName);
  for i := 0 to DynamicVarList.Count - 1 do
  begin
    DynamicVar := DynamicVarList.Items[i];
    if CompareText(DynamicVar.sName, sVarName) = 0 then
    begin
      case DynamicVar.VarType of
        vInteger: DynamicVar.nInternet := IniFile.ReadInteger(sName, DynamicVar.sName, 0);
        vString: DynamicVar.sString := IniFile.ReadString(sName, DynamicVar.sName, '');
      end;
      boFoundVar := True;
      Break;
    end;
  end;

  if not boFoundVar then
    ScriptActionError(PlayObject, Format(sVarFound, [sVarName, sType]), QuestActionInfo, sSC_LOADVAR);
  IniFile.Free;
end;

//保存变量值
//SAVEVAR 变量类型 变量名 文件名
procedure TNormNpc.ActionOfSaveVar(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sType: string;
  sVarName: string;
  sFileName: string;
  sName: string;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
  IniFile: TIniFile;
resourcestring
  sVarFound = '变量%s不存在，变量类型:%s';
  sVarTypeError = '变量类型错误，错误类型:%s 当前支持类型(HUMAN、GUILD、GLOBAL)';
begin
  sType := QuestActionInfo.sParam1;
  sVarName := QuestActionInfo.sParam2;
  sFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam3;
  if (sType = '') or (sVarName = '') or not FileExists(sFileName) then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SAVEVAR);
    Exit;
  end;
  boFoundVar := False;
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then
  begin
    Dispose(DynamicVar);
    ScriptActionError(PlayObject, Format(sVarTypeError, [sType]), QuestActionInfo, sSC_VAR);
    Exit;
  end;
  IniFile := TIniFile.Create(sFileName);
  for i := 0 to DynamicVarList.Count - 1 do
  begin
    DynamicVar := DynamicVarList.Items[i];
    if CompareText(DynamicVar.sName, sVarName) = 0 then
    begin
      case DynamicVar.VarType of
        vInteger: IniFile.WriteInteger(sName, DynamicVar.sName, DynamicVar.nInternet);
        vString: IniFile.WriteString(sName, DynamicVar.sName, DynamicVar.sString);
      end;
      boFoundVar := True;
      Break;
    end;
  end;

  if not boFoundVar then
    ScriptActionError(PlayObject, Format(sVarFound, [sVarName, sType]), QuestActionInfo, sSC_SAVEVAR);
  IniFile.Free;
end;
//对变量进行运算(+、-、*、/)
procedure TNormNpc.ActionOfCalcVar(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sType: string;
  sVarName: string;
  sName: string;
  sVarValue: string;
  nVarValue: Integer;
  sMethod: string;
  cMethod: Char;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
resourcestring
  sVarFound = '变量%s不存在，变量类型:%s';
  sVarTypeError = '变量类型错误，错误类型:%s 当前支持类型(HUMAN、GUILD、GLOBAL)';
begin
  sType := QuestActionInfo.sParam1;
  sVarName := QuestActionInfo.sParam2;
  sMethod := QuestActionInfo.sParam3;
  sVarValue := QuestActionInfo.sParam4;
  nVarValue := Str_ToInt(QuestActionInfo.sParam4, 0);

  if (sType = '') or (sVarName = '') or (sMethod = '') then
  begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CALCVAR);
    Exit;
  end;
  boFoundVar := False;
  cMethod := sMethod[1];
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then
  begin
    Dispose(DynamicVar);
    ScriptActionError(PlayObject, Format(sVarTypeError, [sType]), QuestActionInfo, sSC_CALCVAR);
    Exit;
  end;
  for i := 0 to DynamicVarList.Count - 1 do
  begin
    DynamicVar := DynamicVarList.Items[i];
    if CompareText(DynamicVar.sName, sVarName) = 0 then
    begin
      case DynamicVar.VarType of
        vInteger:
          begin
            case cMethod of
              '=': DynamicVar.nInternet := nVarValue;
              '+': DynamicVar.nInternet := DynamicVar.nInternet + nVarValue;
              '-': DynamicVar.nInternet := DynamicVar.nInternet - nVarValue;
              '*': DynamicVar.nInternet := DynamicVar.nInternet * nVarValue;
              '/': DynamicVar.nInternet := DynamicVar.nInternet div nVarValue;
            end;
          end;
        vString:
          begin

          end;
      end;
      boFoundVar := True;
      Break;
    end;
  end;

  if not boFoundVar then
    ScriptActionError(PlayObject, Format(sVarFound, [sVarName, sType]), QuestActionInfo, sSC_CALCVAR);

end;


procedure TNormNpc.ActionOfGuildRecall(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  if PlayObject.m_MyGuild <> nil then
  begin
    //PlayObject.GuildRecall('GuildRecall','');
  end;
end;

procedure TNormNpc.ActionOfGroupAddList(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  ffile: string;
  i: Integer;
begin
  ffile := QuestActionInfo.sParam1;
  if PlayObject.m_GroupOwner <> nil then
  begin
    for i := 0 to PlayObject.m_GroupMembers.Count - 1 do
    begin
      PlayObject := TPlayObject(PlayObject.m_GroupMembers.Objects[i]);
      //AddListEx(PlayObject.m_sCharName,ffile);
    end;
  end;
end;

//if DeleteFile(fileName)
procedure TNormNpc.ActionOfClearList(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  ffile: string;
  myFile: TextFile;
begin

  ffile := g_Config.sEnvirDir + QuestActionInfo.sParam1;
  if FileExists(ffile) then
  begin
    AssignFile(myFile, ffile);
    Rewrite(myFile);
    CloseFile(myFile);
  end;
end;

procedure TNormNpc.ActionOfGroupRecall(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  if PlayObject.m_GroupOwner <> nil then
  begin
    //PlayObject.GroupRecall('GroupRecall');
  end;
end;

procedure TNormNpc.ActionOfGroupMoveMap(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  PlayObjectEx: TPlayObject;
  Envir: TEnvirnoment;
  boFlag: Boolean;
begin
  boFlag := False;
  if PlayObject.m_GroupOwner <> nil then
  begin
    Envir := g_MapManager.FindMap(QuestActionInfo.sParam1);
    if Envir <> nil then
    begin
      if Envir.CanWalk(QuestActionInfo.nParam2, QuestActionInfo.nParam3, True) then
      begin
        for i := 0 to PlayObject.m_GroupMembers.Count - 1 do
        begin
          PlayObjectEx := TPlayObject(PlayObject.m_GroupMembers.Objects[i]);

          //PlayObjectEx.SendRefMsg(RM_SPACEMOVE_FIRE,0,0,0,0,'');
          PlayObjectEx.SpaceMove(QuestActionInfo.sParam1, QuestActionInfo.nParam2, QuestActionInfo.nParam3, 0);
        end;
        boFlag := True;
      end;
    end;
  end;

  if not boFlag then
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GROUPMOVEMAP);
end;















procedure TNormNpc.Initialize;
begin
  inherited;
  m_Castle := g_CastleManager.InCastleWarArea(Self);
end;

function TNormNpc.ConditionOfCheckNameDateList(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sListFileName, sLineText, sHumName, sDate: string;
  boDeleteExprie, boNoCompareHumanName: Boolean;
  dOldDate: TDateTime;
  cMethod: Char;
  nValNo, nValNoDay, nDayCount, nDay: Integer;
begin
  Result := False;
  nDayCount := Str_ToInt(QuestConditionInfo.sParam3, -1);
  nValNo := GetValNameNo(QuestConditionInfo.sParam4);
  nValNoDay := GetValNameNo(QuestConditionInfo.sParam5);
  boDeleteExprie := CompareText(QuestConditionInfo.sParam6, '清理') = 0;
  boNoCompareHumanName := CompareText(QuestConditionInfo.sParam6, '1') = 0;
  cMethod := QuestConditionInfo.sParam2[1];
  if nDayCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKNAMEDATELIST);
    Exit;
  end;
  sListFileName := g_Config.sEnvirDir + m_sPath + QuestConditionInfo.sParam1;
  if FileExists(sListFileName) then
  begin
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(sListFileName);
    except
      MainOutMessage('loading fail.... => ' + sListFileName);
    end;
    for i := 0 to LoadList.Count - 1 do
    begin
      sLineText := Trim(LoadList.Strings[i]);
      sLineText := GetValidStr3(sLineText, sHumName, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sDate, [' ', #9]);
      if (CompareText(sHumName, PlayObject.m_sCharName) = 0) or boNoCompareHumanName then
      begin
        nDay := High(Integer);
        if TryStrToDateTime(sDate, dOldDate) then
          nDay := GetDayCount(Now, dOldDate);
        case cMethod of
          '=': if nDay = nDayCount then Result := True;
          '>': if nDay > nDayCount then Result := True;
          '<': if nDay < nDayCount then Result := True;
        else if nDay >= nDayCount then Result := True;
        end;
        if nValNo >= 0 then
        begin
          case nValNo of
            0..9:
              begin
                PlayObject.m_nVal[nValNo] := nDay;
              end;
            100..119:
              begin
                g_Config.GlobalVal[nValNo - 100] := nDay;
              end;
            200..209:
              begin
                PlayObject.m_DyVal[nValNo - 200] := nDay;
              end;
            300..399:
              begin
                PlayObject.m_nMval[nValNo - 300] := nDay;
              end;
            400..499:
              begin
                g_Config.GlobaDyMval[nValNo - 400] := nDay;
              end;
          end;
        end;

        if nValNoDay >= 0 then
        begin
          case nValNoDay of
            0..9:
              begin
                PlayObject.m_nVal[nValNoDay] := nDayCount - nDay;
              end;
            100..119:
              begin
                g_Config.GlobalVal[nValNoDay - 100] := nDayCount - nDay;
              end;
            200..209:
              begin
                PlayObject.m_DyVal[nValNoDay - 200] := nDayCount - nDay;
              end;
            300..399:
              begin
                PlayObject.m_nMval[nValNoDay - 300] := nDayCount - nDay;
              end;
          end;
        end;
        if not Result then
        begin
          if boDeleteExprie then
          begin
            LoadList.Delete(i);
            try
              LoadList.SaveToFile(sListFileName);
            except
              MainOutMessage('Save fail.... => ' + sListFileName);
            end;
          end;
        end;
        Break;
      end;
    end;
    LoadList.Free;
  end else
  begin
    MainOutMessage('file not found => ' + sListFileName);
  end;
end;
//CHECKMAPHUMANCOUNT MAP = COUNT
function TNormNpc.ConditionOfCheckMapHumanCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount, nHumanCount: Integer;
  cMethod: Char;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam3, -1);
  if nCount < 0 then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMAPHUMANCOUNT);
    Exit;
  end;
  nHumanCount := UserEngine.GetMapHuman(QuestConditionInfo.sParam1);

  cMethod := QuestConditionInfo.sParam2[1];
  case cMethod of
    '=': if nHumanCount = nCount then Result := True;
    '>': if nHumanCount > nCount then Result := True;
    '<': if nHumanCount < nCount then Result := True;
  else if nHumanCount >= nCount then Result := True;
  end;
end;



function TNormNpc.ConditionOfCheckMapMonCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount, nMonCount: Integer;
  cMethod: Char;
  Envir: TEnvirnoment;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam3, -1);
  Envir := g_MapManager.FindMap(QuestConditionInfo.sParam1);
  if (nCount < 0) or (Envir = nil) then
  begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMAPMONCOUNT);
    Exit;
  end;

  nMonCount := UserEngine.GetMapMonster(Envir, nil);

  cMethod := QuestConditionInfo.sParam2[1];
  case cMethod of
    '=': if nMonCount = nCount then Result := True;
    '>': if nMonCount > nCount then Result := True;
    '<': if nMonCount < nCount then Result := True;
  else if nMonCount >= nCount then Result := True;
  end;
end;





function TNormNpc.GetDynamicVarList(PlayObject: TPlayObject;
  sType: string; var sName: string): TList;
begin
  Result := nil;
  if CompareLStr(sType, 'HUMAN', Length('HUMAN')) then
  begin
    Result := PlayObject.m_DynamicVarList;
    sName := PlayObject.m_sCharName;
  end else
    if CompareLStr(sType, 'GUILD', Length('GUILD')) then
    begin
      if PlayObject.m_MyGuild = nil then Exit;
      Result := TGUild(PlayObject.m_MyGuild).m_DynamicVarList;
      sName := TGUild(PlayObject.m_MyGuild).sGuildName;
    end else
      if CompareLStr(sType, 'GLOBAL', Length('GLOBAL')) then
      begin
        Result := g_DynamicVarList;
        sName := 'GLOBAL';
      end;
end;



{ TGuildOfficial }

procedure TGuildOfficial.Click(PlayObject: TPlayObject); //004A30F4
begin
//  GotoLable(PlayObject,'@main');
  inherited;
end;

procedure TGuildOfficial.GetVariableText(PlayObject: TPlayObject;
  var sMsg: string; sVariable: string);
var
  i, ii: Integer;
  sText: string;
  List: TStringList;
  sStr: string;
begin
  inherited;
  if sVariable = '$REQUESTCASTLELIST' then
  begin
    sText := '';
    List := TStringList.Create;
    g_CastleManager.GetCastleNameList(List);
    for i := 0 to List.Count - 1 do
    begin
      ii := i + 1;
      if ((ii div 2) * 2 = ii) then sStr := '\'
      else sStr := '';

      sText := sText + Format('<%s/@requestcastlewarnow%d> %s', [List.Strings[i], i, sStr]);
    end;
    sText := sText + '\ \';
    List.Free;
    sMsg := sub_49ADB8(sMsg, '<$REQUESTCASTLELIST>', sText);
  end;
end;

procedure TGuildOfficial.Run; //004A37F0
begin
  if Random(40) = 0 then
  begin
    TurnTo(Random(8));
  end else
  begin
    if Random(30) = 0 then
      SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  end;
  inherited;
end;

procedure TGuildOfficial.UserSelect(PlayObject: TPlayObject; sData: string);
var
  sMsg, sLabel: string;
  boCanJmp: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TGuildOfficial::UserSelect... ';
begin
  inherited;
  try
//    PlayObject.m_nScriptGotoCount:=0;
    if (sData <> '') and (sData[1] = '@') then
    begin
      sMsg := GetValidStr3(sData, sLabel, [#13]);

      boCanJmp := PlayObject.LableIsCanJmp(sLabel);

      GotoLable(PlayObject, sLabel, not boCanJmp);

      //GotoLable(PlayObject,sLabel,not PlayObject.LableIsCanJmp(sLabel));
      if not boCanJmp then Exit;
      if CompareText(sLabel, sBUILDGUILDNOW) = 0 then
      begin
        ReQuestBuildGuild(PlayObject, sMsg);
      end else
        if CompareText(sLabel, sSCL_GUILDWAR) = 0 then
        begin
          ReQuestGuildWar(PlayObject, sMsg);
        end else
          if CompareText(sLabel, sDONATE) = 0 then
          begin
            DoNate(PlayObject);
          end else
      {
      if CompareText(sLabel,sREQUESTCASTLEWAR) = 0 then begin
        ReQuestCastleWar(PlayObject,sMsg);
      end else
      }
            if CompareLStr(sLabel, sREQUESTCASTLEWAR, Length(sREQUESTCASTLEWAR)) then
            begin
              ReQuestCastleWar(PlayObject, Copy(sLabel, Length(sREQUESTCASTLEWAR) + 1, Length(sLabel) - Length(sREQUESTCASTLEWAR)));
            end else
              if CompareText(sLabel, sEXIT) = 0 then
              begin
                PlayObject.SendMsg(Self, RM_MERCHANTDLGCLOSE, 0, Integer(Self), 0, 0, '');
              end else
                if CompareText(sLabel, sBACK) = 0 then
                begin
                  if PlayObject.m_sScriptGoBackLable = '' then PlayObject.m_sScriptGoBackLable := sMAIN;
                  GotoLable(PlayObject, PlayObject.m_sScriptGoBackLable, False);
                end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
//  inherited;
end;
function TGuildOfficial.ReQuestBuildGuild(PlayObject: TPlayObject; sGuildName: string): Integer; //004A3124
var
  UserItem: pTUserItem;
  sKey: string;
begin
  Result := 0;
  sGuildName := Trim(sGuildName);
  UserItem := nil;
  if sGuildName = '' then
  begin
    Result := -4;
  end;
  if PlayObject.m_MyGuild = nil then
  begin
    if PlayObject.m_nGold >= g_Config.nBuildGuildPrice then
    begin
      UserItem := PlayObject.CheckItems(g_Config.sWomaHorn);
      if UserItem = nil then
      begin
        Result := -3; //'你没有准备好需要的全部物品。'
      end;
    end else Result := -2; //'缺少创建费用。'
  end else Result := -1; //'您已经加入其它行会。'
  if Result = 0 then
  begin
    if g_GuildManager.AddGuild(sGuildName, PlayObject.m_sCharName) then
    begin
      UserEngine.SendServerGroupMsg(SS_205, nServerIndex, sGuildName + '/' + PlayObject.m_sCharName);
      PlayObject.SendDelItems(UserItem);
      PlayObject.DelBagItem(UserItem.MakeIndex, g_Config.sWomaHorn);
      PlayObject.DecGold(g_Config.nBuildGuildPrice);
      PlayObject.GoldChanged();
      PlayObject.m_MyGuild := g_GuildManager.MemberOfGuild(PlayObject.m_sCharName);
      if PlayObject.m_MyGuild <> nil then
      begin
        PlayObject.m_sGuildRankName := TGUild(PlayObject.m_MyGuild).GetRankName(PlayObject, PlayObject.m_nGuildRankNo);
        RefShowName();
      end;
    end else Result := -4;
  end;
  if Result >= 0 then
  begin
    PlayObject.SendMsg(Self, RM_BUILDGUILD_OK, 0, 0, 0, 0, '');
  end else
  begin
    PlayObject.SendMsg(Self, RM_BUILDGUILD_FAIL, 0, Result, 0, 0, '');
  end;
end;
function TGuildOfficial.ReQuestGuildWar(PlayObject: TPlayObject; sGuildName: string): Integer; //004A3368
begin
  if g_GuildManager.FindGuild(sGuildName) <> nil then
  begin
    if PlayObject.m_nGold >= g_Config.nGuildWarPrice then
    begin
      PlayObject.DecGold(g_Config.nGuildWarPrice);
      PlayObject.GoldChanged();
      PlayObject.ReQuestGuildWar(sGuildName);
    end else
    begin
      PlayObject.SysMsg('你没有足够的金币！！！', c_Red, t_Hint);
    end;
  end else
  begin
    PlayObject.SysMsg('行会 ' + sGuildName + ' 不存在！！！', c_Red, t_Hint);
  end;
  Result := 1;
end;
procedure TGuildOfficial.DoNate(PlayObject: TPlayObject); //004A346C
begin
  PlayObject.SendMsg(Self, RM_DONATE_OK, 0, 0, 0, 0, '');
end;
procedure TGuildOfficial.ReQuestCastleWar(PlayObject: TPlayObject; sIndex: string); //004A3498
var
  UserItem: pTUserItem;
  Castle: TUserCastle;
  nIndex: Integer;
begin
//  if PlayObject.IsGuildMaster and
//     (not UserCastle.IsMasterGuild(TGuild(PlayObject.m_MyGuild))) then begin
  nIndex := Str_ToInt(sIndex, -1);
  if nIndex < 0 then nIndex := 0;

  Castle := g_CastleManager.GetCastle(nIndex);
  if PlayObject.IsGuildMaster and
    not Castle.IsMember(PlayObject) then
  begin

    UserItem := PlayObject.CheckItems(g_Config.sZumaPiece);
    if UserItem <> nil then
    begin
(*
{$IF SoftVersion = VERDEMO}
      PlayObject.SysMsg('演示版本不支持此功能！！！',c_Red,t_Hint);
{$ELSE}
*)
      if Castle.AddAttackerInfo(TGUild(PlayObject.m_MyGuild)) then
      begin
        PlayObject.SendDelItems(UserItem);
        PlayObject.DelBagItem(UserItem.MakeIndex, g_Config.sZumaPiece);
        GotoLable(PlayObject, '~@request_ok', False);
      end else
      begin
        PlayObject.SysMsg('你现在无法请求攻城！！！', c_Red, t_Hint);
      end;
(*{$IFEND}*)

    end else
    begin
      PlayObject.SysMsg('你没有' + g_Config.sZumaPiece + '！！！', c_Red, t_Hint);
    end;
  end else
  begin
    PlayObject.SysMsg('你的请求被取消..', c_Red, t_Hint);
  end;
end;


procedure TCastleOfficial.RepairDoor(PlayObject: TPlayObject); //004A3FB8
begin
  if m_Castle = nil then
  begin
    PlayObject.SysMsg('NPC不属于城堡！！！', c_Red, t_Hint);
    Exit;
  end;
  if TUserCastle(m_Castle).m_nTotalGold >= g_Config.nRepairDoorPrice then
  begin
    if TUserCastle(m_Castle).RepairDoor then
    begin
      Dec(TUserCastle(m_Castle).m_nTotalGold, g_Config.nRepairDoorPrice);
      PlayObject.SysMsg('修理成功..', c_Green, t_Hint);
    end else
    begin
      PlayObject.SysMsg('城门不需要修理...', c_Green, t_Hint);
    end;
  end else
  begin
    PlayObject.SysMsg('城内资金不足...', c_Red, t_Hint);
  end;
  {
  if UserCastle.m_nTotalGold >= g_Config.nRepairDoorPrice then begin
    if UserCastle.RepairDoor then begin
      Dec(UserCastle.m_nTotalGold,g_Config.nRepairDoorPrice);
      PlayObject.SysMsg('修理成功。',c_Green,t_Hint);
    end else begin
      PlayObject.SysMsg('城门不需要修理！！！',c_Green,t_Hint);
    end;
  end else begin
    PlayObject.SysMsg('城内资金不足！！！',c_Red,t_Hint);
  end;
  }
end;

procedure TCastleOfficial.RepairWallNow(nWallIndex: Integer;
  PlayObject: TPlayObject); //004A4074
begin
  if m_Castle = nil then
  begin
    PlayObject.SysMsg('NPC不属于城堡！！！', c_Red, t_Hint);
    Exit;
  end;

  if TUserCastle(m_Castle).m_nTotalGold >= g_Config.nRepairWallPrice then
  begin
    if TUserCastle(m_Castle).RepairWall(nWallIndex) then
    begin
      Dec(TUserCastle(m_Castle).m_nTotalGold, g_Config.nRepairWallPrice);
      PlayObject.SysMsg('修理成功..', c_Green, t_Hint);
    end else
    begin
      PlayObject.SysMsg('城门不需要修理...', c_Green, t_Hint);
    end;
  end else
  begin
    PlayObject.SysMsg('城内资金不足...', c_Red, t_Hint);
  end;
  {
  if UserCastle.m_nTotalGold >= g_Config.nRepairWallPrice then begin
    if UserCastle.RepairWall(nWallIndex) then begin
      Dec(UserCastle.m_nTotalGold,g_Config.nRepairWallPrice);
      PlayObject.SysMsg('修理成功。',c_Green,t_Hint);
    end else begin
      PlayObject.SysMsg('城门不需要修理！！！',c_Green,t_Hint);
    end;
  end else begin
    PlayObject.SysMsg('城内资金不足！！！',c_Red,t_Hint);
  end;
  }
end;

constructor TCastleOfficial.Create;
begin
  inherited;

end;

destructor TCastleOfficial.Destroy;
begin

  inherited;
end;

constructor TGuildOfficial.Create;
begin
  inherited;
  m_btRaceImg := RCC_MERCHANT;
  m_wAppr := 8;
end;

destructor TGuildOfficial.Destroy;
begin

  inherited;
end;

procedure TGuildOfficial.SendCustemMsg(PlayObject: TPlayObject;
  sMsg: string);
begin
  inherited;

end;

procedure TCastleOfficial.SendCustemMsg(PlayObject: TPlayObject;
  sMsg: string);
begin
  if not g_Config.boSubkMasterSendMsg then
  begin
    PlayObject.SysMsg(g_sSubkMasterMsgCanNotUseNowMsg, c_Red, t_Hint);
    Exit;
  end;
  if PlayObject.m_boSendMsgFlag then
  begin
    PlayObject.m_boSendMsgFlag := False;
    UserEngine.SendBroadCastMsg(PlayObject.m_sCharName + ': ' + sMsg, t_Castle);
  end else
  begin

  end;
end;

end.
