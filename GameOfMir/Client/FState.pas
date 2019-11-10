unit FState;
//本单元提供系统中的所有对话框显示
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DWinCtl, StdCtrls, DXDraws, Grids, Grobal2, clFunc, hUtil32, cliUtil,
  MapUnit, SoundUtil;

const
   BOTTOMBOARD800 = 1;//主操作介面图形号
   BOTTOMBOARD1024 = 2;//主操作介面图形号
   VIEWCHATLINE = 9;
   MAXSTATEPAGE = 4;
   LISTLINEHEIGHT = 13;
   MAXMENU = 10;

   AdjustAbilHints : array[0..8] of string = (
      '物理攻击力',
      '魔法力(法师)',
      '精神力(道士)',
      '防御力',
      '魔法防御力',
      '体力',
      '魔法',
      '准确度',
      '躲避率'
   );

type
  TSpotDlgMode = (dmSell, dmRepair, dmStorage);

  TClickPoint = record
     rc: TRect;
     RStr: string;
  end;
  pTClickPoint = ^TClickPoint;
  TDiceInfo = record
    nDicePoint :Integer;      //0x66C
    nPlayPoint :Integer;//0x670 当前骰子点数
    nX         :Integer;      //0x674
    nY         :Integer;      //0x678
    n67C       :Integer;      //0x67C
    n680       :Integer;      //0x680
    dwPlayTick :LongWord; //0x684
  end;
  pTDiceInfo = ^TDiceInfo;
  TFrmDlg = class(TForm)
    DStateWin: TDWindow;
    DBackground: TDWindow;
    DItemBag: TDWindow;
    DBottom: TDWindow;
    DMyState: TDButton;
    DMyBag: TDButton;
    DMyMagic: TDButton;
    DOption: TDButton;
    DGold: TDButton;
    DPrevState: TDButton;
    DRepairItem: TDButton;
    DCloseBag: TDButton;
    DCloseState: TDButton;
    DLogIn: TDWindow;
    DLoginNew: TDButton;
    DLoginOk: TDButton;
    DNewAccount: TDWindow;
    DNewAccountOk: TDButton;
    DLoginClose: TDButton;
    DNewAccountClose: TDButton;
    DSelectChr: TDWindow;
    DscSelect1: TDButton;
    DscSelect2: TDButton;
    DscStart: TDButton;
    DscNewChr: TDButton;
    DscEraseChr: TDButton;
    DscCredits: TDButton;
    DscExit: TDButton;
    DCreateChr: TDWindow;
    DccWarrior: TDButton;
    DccWizzard: TDButton;
    DccMonk: TDButton;
    DccReserved: TDButton;
    DccMale: TDButton;
    DccFemale: TDButton;
    DccLeftHair: TDButton;
    DccRightHair: TDButton;
    DccOk: TDButton;
    DccClose: TDButton;
    DItemGrid: TDGrid;
    DLoginChgPw: TDButton;
    DMsgDlg: TDWindow;
    DMsgDlgOk: TDButton;
    DMsgDlgYes: TDButton;
    DMsgDlgCancel: TDButton;
    DMsgDlgNo: TDButton;
    DNextState: TDButton;
    DSWNecklace: TDButton;
    DSWLight: TDButton;
    DSWArmRingR: TDButton;
    DSWArmRingL: TDButton;
    DSWRingR: TDButton;
    DSWRingL: TDButton;
    DSWWeapon: TDButton;
    DSWDress: TDButton;
    DSWHelmet: TDButton;
    DSWBujuk: TDButton;
    DSWBelt: TDButton;
    DSWBoots: TDButton;
    DSWCharm: TDButton;

    DBelt1: TDButton;
    DBelt2: TDButton;
    DBelt3: TDButton;
    DBelt4: TDButton;
    DBelt5: TDButton;
    DBelt6: TDButton;
    DChgPw: TDWindow;
    DChgpwOk: TDButton;
    DChgpwCancel: TDButton;
    DMerchantDlg: TDWindow;
    DMerchantDlgClose: TDButton;
    DMenuDlg: TDWindow;
    DMenuPrev: TDButton;
    DMenuNext: TDButton;
    DMenuBuy: TDButton;
    DMenuClose: TDButton;
    DSellDlg: TDWindow;
    DSellDlgOk: TDButton;
    DSellDlgClose: TDButton;
    DSellDlgSpot: TDButton;
    DStMag1: TDButton;
    DStMag2: TDButton;
    DStMag3: TDButton;
    DStMag4: TDButton;
    DStMag5: TDButton;
    DKeySelDlg: TDWindow;
    DKsIcon: TDButton;
    DKsF1: TDButton;
    DKsF2: TDButton;
    DKsF3: TDButton;
    DKsF4: TDButton;
    DKsNone: TDButton;
    DKsOk: TDButton;
    DBotGroup: TDButton;
    DBotTrade: TDButton;
    DBotMiniMap: TDButton;
    DBotFriend: TDButton;
    DGroupDlg: TDWindow;
    DGrpAllowGroup: TDButton;
    DGrpDlgClose: TDButton;
    DGrpCreate: TDButton;
    DGrpAddMem: TDButton;
    DGrpDelMem: TDButton;
    DBotLogout: TDButton;
    DBotExit: TDButton;
    DBotGuild: TDButton;
    DStPageUp: TDButton;
    DStPageDown: TDButton;
    DDealRemoteDlg: TDWindow;
    DDealDlg: TDWindow;
    DDRGrid: TDGrid;
    DDGrid: TDGrid;
    DDealOk: TDButton;
    DDealClose: TDButton;
    DDGold: TDButton;
    DDRGold: TDButton;
    DSelServerDlg: TDWindow;
    DSSrvClose: TDButton;
    DSServer1: TDButton;
    DSServer2: TDButton;
    DUserState1: TDWindow;
    DCloseUS1: TDButton;
    DWeaponUS1: TDButton;
    DHelmetUS1: TDButton;
    DNecklaceUS1: TDButton;
    DDressUS1: TDButton;
    DLightUS1: TDButton;
    DArmringRUS1: TDButton;
    DRingRUS1: TDButton;
    DArmringLUS1: TDButton;
    DRingLUS1: TDButton;

    DBujukUS1: TDButton;
    DBeltUS1: TDButton;
    DBootsUS1: TDButton;
    DCharmUS1: TDButton;

    DSServer3: TDButton;
    DSServer4: TDButton;
    DGuildDlg: TDWindow;
    DGDHome: TDButton;
    DGDList: TDButton;
    DGDChat: TDButton;
    DGDAddMem: TDButton;
    DGDDelMem: TDButton;
    DGDEditNotice: TDButton;
    DGDEditGrade: TDButton;
    DGDAlly: TDButton;
    DGDBreakAlly: TDButton;
    DGDWar: TDButton;
    DGDCancelWar: TDButton;
    DGDUp: TDButton;
    DGDDown: TDButton;
    DGDClose: TDButton;
    DGuildEditNotice: TDWindow;
    DGEClose: TDButton;
    DGEOk: TDButton;
    DSServer5: TDButton;
    DSServer6: TDButton;
    DNewAccountCancel: TDButton;
    DAdjustAbility: TDWindow;
    DPlusDC: TDButton;
    DPlusMC: TDButton;
    DPlusSC: TDButton;
    DPlusAC: TDButton;
    DPlusMAC: TDButton;
    DPlusHP: TDButton;
    DPlusMP: TDButton;
    DPlusHit: TDButton;
    DPlusSpeed: TDButton;
    DMinusDC: TDButton;
    DMinusMC: TDButton;
    DMinusSC: TDButton;
    DMinusAC: TDButton;
    DMinusMAC: TDButton;
    DMinusMP: TDButton;
    DMinusHP: TDButton;
    DMinusHit: TDButton;
    DMinusSpeed: TDButton;
    DAdjustAbilClose: TDButton;
    DAdjustAbilOk: TDButton;
    DBotPlusAbil: TDButton;
    DKsF5: TDButton;
    DKsF6: TDButton;
    DKsF7: TDButton;
    DKsF8: TDButton;
    DEngServer1: TDButton;
    DConfigDlg: TDWindow;
    DConfigDlgClose: TDButton;
    DConfigDlgOK: TDButton;
    DKsConF1: TDButton;
    DKsConF2: TDButton;
    DKsConF3: TDButton;
    DKsConF4: TDButton;
    DKsConF5: TDButton;
    DKsConF6: TDButton;
    DKsConF7: TDButton;
    DKsConF8: TDButton;
    DBotMemo: TDButton;
    DFriendDlg: TDWindow;
    DFrdFriend: TDButton;
    DFrdBlackList: TDButton;
    DFrdClose: TDButton;
    DFrdPgUp: TDButton;
    DFrdPgDn: TDButton;
    DFrdAdd: TDButton;
    DFrdDel: TDButton;
    DFrdMemo: TDButton;
    DFrdMail: TDButton;
    DFrdWhisper: TDButton;
    DMLReply: TDButton;
    DMLRead: TDButton;
    DMLLock: TDButton;
    DMLDel: TDButton;
    DMLBlock: TDButton;
    DBLDel: TDButton;
    DBLAdd: TDButton;
    DMemoB2: TDButton;
    DMemoB1: TDButton;
    DMailListDlg: TDWindow;
    DMailListClose: TDButton;
    DMailListPgUp: TDButton;
    DMailListPgDn: TDButton;
    DBlockListDlg: TDWindow;
    DBLPgUp: TDButton;
    DBLPgDn: TDButton;
    DBlockListClose: TDButton;
    DMemo: TDWindow;
    DMemoClose: TDButton;
    DButton1: TDButton;
    DButton2: TDButton;
    DChgGamePwd: TDWindow;
    DChgGamePwdClose: TDButton;
    DButtonHP: TDButton;
    DButtonMP: TDButton;

    procedure DBottomInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DBottomDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DMyStateDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DOptionClick();
    procedure DItemBagDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DRepairItemDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DRepairItemInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DStateWinDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure FormCreate(Sender: TObject);
    procedure DPrevStateDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DLoginNewDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DscSelect1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DccCloseDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DItemGridGridSelect(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DItemGridGridPaint(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
    procedure DItemGridDblClick(Sender: TObject);
    procedure DMsgDlgOkDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DMsgDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DMsgDlgKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DCloseBagDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBackgroundBackgroundClick(Sender: TObject);
    procedure DItemGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DBelt1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure FormDestroy(Sender: TObject);
    procedure DBelt1DblClick(Sender: TObject);
    procedure DLoginCloseClick(Sender: TObject; X, Y: Integer);
    procedure DLoginOkClick(Sender: TObject; X, Y: Integer);
    procedure DLoginNewClick(Sender: TObject; X, Y: Integer);
    procedure DLoginChgPwClick(Sender: TObject; X, Y: Integer);
    procedure DNewAccountOkClick(Sender: TObject; X, Y: Integer);
    procedure DNewAccountCloseClick(Sender: TObject; X, Y: Integer);
    procedure DccCloseClick(Sender: TObject; X, Y: Integer);
    procedure DChgpwOkClick(Sender: TObject; X, Y: Integer);
    procedure DscSelect1Click(Sender: TObject; X, Y: Integer);
    procedure DCloseStateClick(Sender: TObject; X, Y: Integer);
    procedure DPrevStateClick(Sender: TObject; X, Y: Integer);
    procedure DNextStateClick(Sender: TObject; X, Y: Integer);
    procedure DSWWeaponClick(Sender: TObject; X, Y: Integer);
    procedure DMsgDlgOkClick(Sender: TObject; X, Y: Integer);
    procedure DCloseBagClick(Sender: TObject; X, Y: Integer);
    procedure DBelt1Click(Sender: TObject; X, Y: Integer);
    procedure DMyStateClick(Sender: TObject; X, Y: Integer);
    procedure DStateWinClick(Sender: TObject; X, Y: Integer);
    procedure DSWWeaponMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DBelt1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DMerchantDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DMerchantDlgCloseClick(Sender: TObject; X, Y: Integer);
    procedure DMerchantDlgClick(Sender: TObject; X, Y: Integer);
    procedure DMerchantDlgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DMerchantDlgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DMenuCloseClick(Sender: TObject; X, Y: Integer);
    procedure DMenuDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DMenuDlgClick(Sender: TObject; X, Y: Integer);
    procedure DSellDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DSellDlgCloseClick(Sender: TObject; X, Y: Integer);
    procedure DSellDlgSpotClick(Sender: TObject; X, Y: Integer);
    procedure DSellDlgSpotDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DSellDlgSpotMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DSellDlgOkClick(Sender: TObject; X, Y: Integer);
    procedure DMenuBuyClick(Sender: TObject; X, Y: Integer);
    procedure DMenuPrevClick(Sender: TObject; X, Y: Integer);
    procedure DMenuNextClick(Sender: TObject; X, Y: Integer);
    procedure DGoldClick(Sender: TObject; X, Y: Integer);
    procedure DSWLightDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBackgroundMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DStateWinMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DLoginNewClickSound(Sender: TObject;
      Clicksound: TClickSound);
    procedure DStMag1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DStMag1Click(Sender: TObject; X, Y: Integer);
    procedure DKsIconDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DKsF1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DKsOkClick(Sender: TObject; X, Y: Integer);
    procedure DKsF1Click(Sender: TObject; X, Y: Integer);
    procedure DKeySelDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBotGroupDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DGrpAllowGroupDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DGrpDlgCloseClick(Sender: TObject; X, Y: Integer);
    procedure DBotGroupClick(Sender: TObject; X, Y: Integer);
    procedure DGrpAllowGroupClick(Sender: TObject; X, Y: Integer);
    procedure DGrpCreateClick(Sender: TObject; X, Y: Integer);
    procedure DGroupDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DGrpAddMemClick(Sender: TObject; X, Y: Integer);
    procedure DGrpDelMemClick(Sender: TObject; X, Y: Integer);
    procedure DBotLogoutClick(Sender: TObject; X, Y: Integer);
    procedure DBotExitClick(Sender: TObject; X, Y: Integer);
    procedure DStPageUpClick(Sender: TObject; X, Y: Integer);
    procedure DBottomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DDealOkClick(Sender: TObject; X, Y: Integer);
    procedure DDealCloseClick(Sender: TObject; X, Y: Integer);
    procedure DBotTradeClick(Sender: TObject; X, Y: Integer);
    procedure DDealRemoteDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DDealDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DDGridGridSelect(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DDGridGridPaint(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
    procedure DDGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DDRGridGridPaint(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
    procedure DDRGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DDGoldClick(Sender: TObject; X, Y: Integer);
    procedure DSServer1Click(Sender: TObject; X, Y: Integer);
    procedure DSSrvCloseClick(Sender: TObject; X, Y: Integer);
    procedure DBotMiniMapClick(Sender: TObject; X, Y: Integer);
    procedure DMenuDlgMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DUserState1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DUserState1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DWeaponUS1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DCloseUS1Click(Sender: TObject; X, Y: Integer);
    procedure DNecklaceUS1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBotGuildClick(Sender: TObject; X, Y: Integer);
    procedure DGuildDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DGDUpClick(Sender: TObject; X, Y: Integer);
    procedure DGDDownClick(Sender: TObject; X, Y: Integer);
    procedure DGDCloseClick(Sender: TObject; X, Y: Integer);
    procedure DGDHomeClick(Sender: TObject; X, Y: Integer);
    procedure DGDListClick(Sender: TObject; X, Y: Integer);
    procedure DGDAddMemClick(Sender: TObject; X, Y: Integer);
    procedure DGDDelMemClick(Sender: TObject; X, Y: Integer);
    procedure DGDEditNoticeClick(Sender: TObject; X, Y: Integer);
    procedure DGDEditGradeClick(Sender: TObject; X, Y: Integer);
    procedure DGECloseClick(Sender: TObject; X, Y: Integer);
    procedure DGEOkClick(Sender: TObject; X, Y: Integer);
    procedure DGuildEditNoticeDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DGDChatClick(Sender: TObject; X, Y: Integer);
    procedure DGoldDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DNewAccountDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DAdjustAbilCloseClick(Sender: TObject; X, Y: Integer);
    procedure DAdjustAbilityDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBotPlusAbilClick(Sender: TObject; X, Y: Integer);
    procedure DPlusDCClick(Sender: TObject; X, Y: Integer);
    procedure DMinusDCClick(Sender: TObject; X, Y: Integer);
    procedure DAdjustAbilOkClick(Sender: TObject; X, Y: Integer);
    procedure DBotPlusAbilDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DAdjustAbilityMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DUserState1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DEngServer1Click(Sender: TObject; X, Y: Integer);
    procedure DGDAllyClick(Sender: TObject; X, Y: Integer);
    procedure DGDBreakAllyClick(Sender: TObject; X, Y: Integer);
    procedure DSelServerDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBotMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DFrdFriendDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBotFriendClick(Sender: TObject; X, Y: Integer);
    procedure DFrdCloseClick(Sender: TObject; X, Y: Integer);
    procedure DChgGamePwdCloseClick(Sender: TObject; X, Y: Integer);
    procedure DChgGamePwdDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);

  private
    DlgTemp: TList;
    magcur, magtop: integer;
    EdDlgEdit: TEdit;
    Memo: TMemo;

    ViewDlgEdit: Boolean;
    msglx, msgly: integer;
    MenuTop: integer;

    MagKeyIcon, MagKeyCurKey: integer;
    MagKeyMagName: string;
    MagicPage: integer;

    BlinkTime: longword;
    BlinkCount: integer;  //0..9荤捞甫 馆汗

    procedure HideAllControls;
    procedure RestoreHideControls;
    procedure PageChanged;
    procedure DealItemReturnBag (mitem: TClientItem);
    procedure DealZeroGold;
    procedure OpenSoundOption;
  public
    StatePage: integer;
    MsgText: string;
    DialogSize: integer;
    {
    m_n66C:Integer;
    m_n688:Integer;
    m_n6A4:Integer;
    m_n6A8:Integer;
    }
//    m_Dicea:array[0..35] of Integer;

    m_nDiceCount:Integer;
    m_boPlayDice:Boolean;
    m_Dice:array[0..9] of TDiceInfo;

    MerchantName: string;
    MerchantFace: integer;
    MDlgStr: string;
    MDlgPoints: TList;
    RequireAddPoints: Boolean;
    SelectMenuStr: string;
    LastestClickTime: longword;
    SpotDlgMode: TSpotDlgMode;

    MenuList: TList; //list of PTClientGoods
    MenuIndex: integer;
    CurDetailItem: string;
    MenuTopLine: integer;
    BoDetailMenu: Boolean;
    BoStorageMenu: Boolean;
    BoNoDisplayMaxDura: Boolean;
    BoMakeDrugMenu: Boolean;
    NAHelps: TStringList;
    NewAccountTitle: string;

    DlgEditText: string;
    UserState1: TUserStateInfo;

    Guild: string;
    GuildFlag: string;
    GuildCommanderMode: Boolean;
    GuildStrs: TStringList;
    GuildStrs2: TStringList;
    GuildNotice: TStringList;
    GuildMembers: TStringList;
    GuildTopLine: integer;
    GuildEditHint: string;
    GuildChats: TStringList;
    BoGuildChat: Boolean;

    procedure Initialize;
    procedure OpenMyStatus;
    procedure OpenUserState (UserState: TUserStateInfo);
    procedure OpenItemBag;
    procedure ViewBottomBox (visible: Boolean);
    procedure CancelItemMoving;
    procedure DropMovingItem;
    procedure OpenAdjustAbility;

    procedure ShowSelectServerDlg;
    function  DMessageDlg (msgstr: string; DlgButtons: TMsgDlgButtons): TModalResult;
    procedure ShowMDlg (face: integer; mname, msgstr: string);
    procedure ShowGuildDlg;
    procedure ShowGuildEditNotice;
    procedure ShowGuildEditGrade;

    procedure ResetMenuDlg;
    procedure ShowShopMenuDlg;
    procedure ShowShopSellDlg;
    procedure CloseDSellDlg;
    procedure CloseMDlg;

    procedure ToggleShowGroupDlg;
    procedure OpenDealDlg;
    procedure CloseDealDlg;

    procedure OpenFriendDlg;

    procedure SoldOutGoods (itemserverindex: integer);
    procedure DelStorageItem (itemserverindex: integer);
    procedure GetMouseItemInfo (var iname, line1, line2, line3: string; var useable: boolean);
    procedure SetMagicKeyDlg (icon: integer; magname: string; var curkey: word);
    procedure AddGuildChat (str: string);
  end;

var
  FrmDlg: TFrmDlg;

implementation

uses
   ClMain, MShare, Share, SDK;

{$R *.DFM}

{
   ##  MovingItem.Index
      1~n : 啊规芒狼 酒捞袍 鉴辑
      -1~-8 : 厘馒芒俊辑狼 酒捞袍 鉴辑
      -97 : 背券芒狼 捣
      -98 : 捣
      -99 : 迫扁 芒俊辑狼 酒捞袍 鉴辑
      -20~29: 背券芒俊辑狼 酒捞袍 鉴辑
}

procedure TFrmDlg.FormCreate(Sender: TObject);
begin
   StatePage := 0;
   DlgTemp := TList.Create;
   DialogSize := 1; //扁夯 农扁
   m_nDiceCount:=0;
   m_boPlayDice:=False;
   magcur := 0;
   magtop := 0;
   MDlgPoints := TList.Create;
   SelectMenuStr := '';
   MenuList := TList.Create;
   MenuIndex := -1;
   MenuTopLine := 0;
   BoDetailMenu := FALSE;
   BoStorageMenu := FALSE;
   BoNoDisplayMaxDura := FALSE;
   BoMakeDrugMenu := FALSE;
   MagicPage := 0;
   NAHelps := TStringList.Create;
   BlinkTime := GetTickCount;
   BlinkCount := 0;

   g_SellDlgItem.S.Name := '';
   Guild := '';
   GuildFlag := '';
   GuildCommanderMode := FALSE;
   GuildStrs := TStringList.Create;
   GuildStrs2 := TStringList.Create; //归诀侩
   GuildNotice := TStringList.Create;
   GuildMembers := TStringList.Create;
   GuildChats := TStringList.Create;

   EdDlgEdit := TEdit.Create (FrmMain.Owner);
   with EdDlgEdit do begin
      Parent := FrmMain;
      Color := clBlack;
      Font.Color := clWhite;
      Font.Size := 10;
      MaxLength := 30;
      Height := 16;
      Ctl3d := FALSE;
      BorderStyle := bsSingle;  {OnKeyPress := EdDlgEditKeyPress;}
      Visible := FALSE;
   end;

   Memo := TMemo.Create (FrmMain.Owner);
   with Memo do begin
      Parent := FrmMain;
      Color := clBlack;
      Font.Color := clWhite;
      Font.Size := 10;
      Ctl3d := FALSE;
      BorderStyle := bsSingle;  {OnKeyPress := EdDlgEditKeyPress;}
      Visible := FALSE;
   end;

end;

procedure TFrmDlg.FormDestroy(Sender: TObject);
begin
   DlgTemp.Free;
   MDlgPoints.Free;  //埃窜洒..
   MenuList.Free;
   NAHelps.Free;
   GuildStrs.Free;
   GuildStrs2.Free;
   GuildNotice.Free;
   GuildMembers.Free;
   GuildChats.Free;
end;

procedure TFrmDlg.HideAllControls;
var
   i: integer;
   c: TControl;
begin
   DlgTemp.Clear;
   with FrmMain do
      for i:=0 to ControlCount-11 do begin
         c := Controls[i];
         if c is TEdit then
            if (c.Visible) and (c <> EdDlgEdit) then begin
               DlgTemp.Add (c);
               c.Visible := FALSE;
            end;
      end;
end;

procedure TFrmDlg.RestoreHideControls;
var
   i: integer;
   c: TControl;
begin
   for i:=0 to DlgTemp.Count-1 do begin
      TControl(DlgTemp[i]).Visible := TRUE;
   end;
end;

procedure TFrmDlg.Initialize;  //初始化所有对话框
var
   i: integer;
   d: TDirectDrawSurface;
begin
   g_DWinMan.ClearAll;

   DBackground.Left := 0;
   DBackground.Top := 0;
   DBackground.Width := SCREENWIDTH;
   DBackground.Height := SCREENHEIGHT;
   DBackground.Background := TRUE;
   g_DWinMan.AddDControl (DBackground, TRUE);

   {-----------------------------------------------------------}

   //通用对话框
   d := g_WMainImages.Images[360];
   if d <> nil then begin
      DMsgDlg.SetImgIndex (g_WMainImages, 360);
      DMsgDlg.Left := (SCREENWIDTH - d.Width) div 2;
      DMsgDlg.Top := (SCREENHEIGHT - d.Height) div 2;
   end;
   DMsgDlgOk.SetImgIndex (g_WMainImages, 361);
   DMsgDlgYes.SetImgIndex (g_WMainImages, 363);
   DMsgDlgCancel.SetImgIndex (g_WMainImages, 365);
   DMsgDlgNo.SetImgIndex (g_WMainImages, 367);
   DMsgDlgOk.Top := 126;
   DMsgDlgYes.Top := 126;
   DMsgDlgCancel.Top := 126;
   DMsgDlgNo.Top := 126;

   {-----------------------------------------------------------}

   //登录对话框
   d := g_WMainImages.Images[174];
   if d <> nil then begin
     // DLogIn.SetImgIndex (g_WMainImages, 174);
      DLogIn.Left := 0;
      DLogIn.Top := 0;
   end;
   DLoginNew.SetImgIndex (g_WMainImages, 61);
   DLoginNew.Left := 447;
   DLoginNew.Top  := 558;
   DLoginOk.SetImgIndex (g_WMainImages, 62);
   DLoginOk.Left := 90;
   DLoginOk.Top := 558;
   DLoginChgPw.SetImgIndex (g_WMainImages, 53);
   DLoginChgPw.Left := 268;
   DLoginChgPw.Top  := 558;
   DLoginClose.SetImgIndex (g_WMainImages, 64);
   DLoginClose.Left := 613;
   DLoginClose.Top := 558;

   {-----------------------------------------------------------}
   //服务器选择窗口    韩文对话框
   if not EnglishVersion then begin
      d := g_WMainImages.Images[160]; //81];
      if d <> nil then begin
         DSelServerDlg.SetImgIndex (g_WMainImages, 160);
         DSelServerDlg.Left := (SCREENWIDTH - d.Width) div 2;
         DSelServerDlg.Top := (SCREENHEIGHT - d.Height) div 2;
      end;
      DSSrvClose.SetImgIndex (g_WMainImages, 64);
      DSSrvClose.Left := 448;
      DSSrvClose.Top := 33;

      DSServer1.SetImgIndex (g_WMainImages, 161); //82);
      DSServer1.Left := 134;
      DSServer1.Top  := 102;
      DSServer2.SetImgIndex (g_WMainImages, 162); //83);
      DSServer2.Left := 236;
      DSServer2.Top  := 101;
      DSServer3.SetImgIndex (g_WMainImages, 163);
      DSServer3.Left := 87;
      DSServer3.Top  := 190;
      DSServer4.SetImgIndex (g_WMainImages, 164);
      DSServer4.Left := 280;
      DSServer4.Top  := 190;
      DSServer5.SetImgIndex (g_WMainImages, 165);
      DSServer5.Left := 134;
      DSServer5.Top  := 280;
      DSServer6.SetImgIndex (g_WMainImages, 166);
      DSServer6.Left := 236;
      DSServer6.Top  := 280;
      DEngServer1.Visible := FALSE;
   end else begin
   //英(中)文对话框：选择服务器
      d := g_WMainImages.Images[256]; //81];
      if d <> nil then begin
         DSelServerDlg.SetImgIndex (g_WMainImages, 256);
         DSelServerDlg.Left := (SCREENWIDTH - d.Width) div 2;
         DSelServerDlg.Top := (SCREENHEIGHT - d.Height) div 2;
      end;
      DSSrvClose.SetImgIndex (g_WMainImages, 83);
      DSSrvClose.Left := 245;
      DSSrvClose.Top := 31;
{
      DEngServer1.SetImgIndex (g_WMainImages, 257);
      DEngServer1.Left := 65;
      DEngServer1.Top  := 204;
}

      DSServer1.SetImgIndex (g_WMainImages, 79);
      DSServer1.Left := 65;
      DSServer1.Top  := 100;

      DSServer2.SetImgIndex (g_WMainImages, 79);
      DSServer2.Left := 65;
      DSServer2.Top  := 145;

      DSServer3.SetImgIndex (g_WMainImages, 79);
      DSServer3.Left := 65;
      DSServer3.Top  := 190;

      DSServer4.SetImgIndex (g_WMainImages, 79);
      DSServer4.Left := 65;
      DSServer4.Top  := 235;

      DSServer5.SetImgIndex (g_WMainImages, 79);
      DSServer5.Left := 65;
      DSServer5.Top  := 280;

      DSServer6.SetImgIndex (g_WMainImages, 79);
      DSServer6.Left := 65;
      DSServer6.Top  := 325;

      DEngServer1.Visible := FALSE;
      DSServer1.Visible := FALSE;
      DSServer2.Visible := FALSE;
      DSServer3.Visible := FALSE;
      DSServer4.Visible := FALSE;
      DSServer5.Visible := FALSE;
      DSServer6.Visible := FALSE;

   end;

   {-----------------------------------------------------------}

   //新用户对话框
   d := g_WMainImages.Images[63];
   if d <> nil then begin
      DNewAccount.SetImgIndex (g_WMainImages, 63);
      DNewAccount.Left := (SCREENWIDTH - d.Width) div 2;
      DNewAccount.Top := (SCREENHEIGHT - d.Height) div 2;
   end;
   DNewAccountOk.SetImgIndex (g_WMainImages, 51);
   DNewAccountOk.Left := 305;
   DNewAccountOk.Top := 530;
   DNewAccountCancel.SetImgIndex (g_WMainImages, 52);
   DNewAccountCancel.Left := 445;
   DNewAccountCancel.Top := 530;
   DNewAccountClose.SetImgIndex (g_WMainImages, 83);
   DNewAccountClose.Left := 587;
   DNewAccountClose.Top := 33;

   {-----------------------------------------------------------}

   //修改密码窗口
   d := g_WMainImages.Images[50];
   if d <> nil then begin
      DChgPw.SetImgIndex (g_WMainImages, 50);
      DChgPw.Left := (SCREENWIDTH - d.Width) div 2;
      DChgPw.Top  := (SCREENHEIGHT - d.Height) div 2;
   end;
   DChgpwOk.SetImgIndex (g_WMainImages, 361);
   DChgPwOk.Left := 81;
   DChgPwOk.Top := 141;
   DChgpwCancel.SetImgIndex (g_WMainImages, 365);
   DChgPwCancel.Left := 160;
   DChgPwCancel.Top := 141;




   {-----------------------------------------------------------}

   //选择角色窗口
   DSelectChr.Left := 0;
   DSelectChr.Top := 0;
   DSelectChr.Width := SCREENWIDTH;
   DSelectChr.Height := SCREENHEIGHT;
   DscSelect1.SetImgIndex (g_WMainImages, 66);
   DscSelect2.SetImgIndex (g_WMainImages, 67);
   DscStart.SetImgIndex (g_WMainImages, 68);
   DscNewChr.SetImgIndex (g_WMainImages, 69);
   DscEraseChr.SetImgIndex (g_WMainImages, 70);
   //DscCredits.SetImgIndex (g_WMainImages, 71);
   DscExit.SetImgIndex (g_WMainImages, 72);

      DscSelect1.Left := (SCREENWIDTH - 800) div 2 + 134{134};
      DscSelect1.Top := (SCREENHEIGHT - 600) div 2 + 424{454};
      DscSelect2.Left := (SCREENWIDTH - 800) div 2 + 602{685};
      DscSelect2.Top := (SCREENHEIGHT - 600) div 2 + 424{454};
      DscStart.Left := (SCREENWIDTH - 800) div 2 + 374{385};
      DscStart.Top := (SCREENHEIGHT - 600) div 2 + 427{456};
      DscNewChr.Left := (SCREENWIDTH - 800) div 2 + 349{348};
      DscNewChr.Top := (SCREENHEIGHT - 600) div 2 + 467{486};
      DscEraseChr.Left := (SCREENWIDTH - 800) div 2 + 349{347};
      DscEraseChr.Top := (SCREENHEIGHT - 600) div 2 + 505{506};
     // DscCredits.Left := (SCREENWIDTH - 800) div 2 + 362{362};
     // DscCredits.Top := (SCREENHEIGHT - 600) div 2 + 529{527};
      DscExit.Left := (SCREENWIDTH - 800) div 2 + 349{379};
      DscExit.Top := (SCREENHEIGHT - 600) div 2 + 543{547};

   {-----------------------------------------------------------}

   //创建角色窗口
   d := g_WMainImages.Images[73];
   if d <> nil then begin
      DCreateChr.SetImgIndex (g_WMainImages, 73);
      DCreateChr.Left := (SCREENWIDTH - d.Width) div 2;
      DCreateChr.Top := (SCREENHEIGHT - d.Height) div 2;
   end;
   DccWarrior.SetImgIndex (g_WMainImages, 74);
   DccWizzard.SetImgIndex (g_WMainImages, 75);
   DccMonk.SetImgIndex (g_WMainImages, 76);
   //DccReserved.SetImgIndex (g_WMainImages.Images[76], TRUE);
   DccMale.SetImgIndex (g_WMainImages, 77);
   DccFemale.SetImgIndex (g_WMainImages, 78);
   //DccLeftHair.SetImgIndex (g_WMainImages, 79);
  // DccRightHair.SetImgIndex (g_WMainImages, 80);
   DccOk.SetImgIndex (g_WMainImages, 51);
   DccClose.SetImgIndex (g_WMainImages, 52);
      DccWarrior.Left := 36;
      DccWarrior.Top := 139;
      DccWizzard.Left := 103;
      DccWizzard.Top := 139;
      DccMonk.Left := 168;
      DccMonk.Top := 139;
      //DccReserved.Left := 183;
      //DccReserved.Top := 157;
      DccMale.Left := 70;
      DccMale.Top := 211;
      DccFemale.Left := 137;
      DccFemale.Top := 211;
      //DccLeftHair.Left := 76;
     // DccLeftHair.Top := 308;
     //DccRightHair.Left := 170;
     // DccRightHair.Top := 308;
      DccOk.Left := 46;
      DccOk.Top := 273;
      DccClose.Left := 138;
      DccClose.Top := 273;


   {-----------------------------------------------------------}
   d := g_WMainImages.Images[81];
   if d <> nil then begin
      DChgGamePwd.SetImgIndex (g_WMainImages, 81);
      DChgGamePwd.Left := (SCREENWIDTH - d.Width) div 2;
      DChgGamePwd.Top  := (SCREENHEIGHT - d.Height) div 2;
   end;
   DChgGamePwdClose.Left := 291;// 399;
   DChgGamePwdClose.Top := 8;
   DChgGamePwdClose.SetImgIndex (g_WMainImages, 83);


   //人物状态窗口
   d := g_WMainImages.Images[370];  //惑怕
   if d <> nil then begin
      DStateWin.SetImgIndex (g_WMainImages, 370);
      DStateWin.Left := SCREENWIDTH - d.Width;
      DStateWin.Top := 0;
   end;
      DSWNecklace.Left := 38 + 144;
      DSWNecklace.Top  := 52 + 13;    //项链
      DSWNecklace.Width := 34;
      DSWNecklace.Height := 31;
      DSWHelmet.Left := 38 + 77;   //头亏
      DSWHelmet.Top  := 52 + 21;
      DSWHelmet.Width := 18;
      DSWHelmet.Height := 18;
      DSWLight.Left := 38 + 144;
      DSWLight.Top  := 52 + 53;   //火把
      DSWLight.Width := 34;
      DSWLight.Height := 31;
      DSWArmRingR.Left := 25 + 0;    //左手镯
      DSWArmRingR.Top  := 52 + 89;
      DSWArmRingR.Width := 34;
      DSWArmRingR.Height := 31;
      DSWArmRingL.Left := 38 + 144;
      DSWArmRingL.Top  := 52 + 89;  //右手镯
      DSWArmRingL.Width := 34;
      DSWArmRingL.Height := 31;
      DSWRingR.Left := 25 + 0;
      DSWRingR.Top  := 52 + 128;  //左戒指
      DSWRingR.Width := 34;
      DSWRingR.Height := 31;
      DSWRingL.Left := 38 + 144;
      DSWRingL.Top  := 52 + 128;  //右戒指
      DSWRingL.Width := 34;
      DSWRingL.Height := 31;
      DSWWeapon.Left := 38 + 9;
      DSWWeapon.Top  := 52 + 18;  //武器
      DSWWeapon.Width := 47;
      DSWWeapon.Height := 87;
      DSWDress.Left := 38 + 58;
      DSWDress.Top  := 52 + 70;  //衣服
      DSWDress.Width := 53;
      DSWDress.Height := 112;

      DSWBujuk.Left := 25;
      DSWBujuk.Top  := 232;   //毒
      DSWBujuk.Width := 34;
      DSWBujuk.Height := 31;

      DSWBelt.Left := 77;
      DSWBelt.Top  := 232;  //腰带
      DSWBelt.Width := 34;
      DSWBelt.Height := 31;

      DSWBoots.Left := 128;
      DSWBoots.Top  := 232;  //鞋子
      DSWBoots.Width := 34;
      DSWBoots.Height := 31;

      DSWCharm.Left := 182;
      DSWCharm.Top  := 232;    //宝石
      DSWCharm.Width := 34;
      DSWCharm.Height := 31;
      //下面是技能
      DStMag1.Left := 30 + 0;
      DStMag1.Top := 32 + 5;
      DStMag1.Width := 31;
      DStMag1.Height := 33;

      DStMag2.Left := 30 + 0;
      DStMag2.Top := 77 + 5;
      DStMag2.Width := 31;
      DStMag2.Height := 33;

      DStMag3.Left := 30 + 0;
      DStMag3.Top := 122 + 5;
      DStMag3.Width := 31;
      DStMag3.Height := 33;

      DStMag4.Left := 30 + 0;
      DStMag4.Top := 167 + 5;
      DStMag4.Width := 31;
      DStMag4.Height := 33;

      DStMag5.Left := 30 + 0;
      DStMag5.Top := 211 + 5;
      DStMag5.Width := 31;
      DStMag5.Height := 33;

      DStPageUp.SetImgIndex (g_WMainImages, 372);
      DStPageDown.SetImgIndex (g_WMainImages, 373);
      DStPageUp.Left := 202;
      DStPageUp.Top  := 52;
      DStPageDown.Left := 202;
      DStPageDown.Top  := 212;

   DCloseState.SetImgIndex (g_WMainImages, 371);
   DCloseState.Left := 223;
   DCloseState.Top := 20;
   DPrevState.SetImgIndex (g_WMainImages, 387);
   DNextState.SetImgIndex (g_WMainImages, 388);
   DPrevState.Left := 224;
   DPrevState.Top := 65;
   DNextState.Left := 224;
   DNextState.Top := 190;

   {-----------------------------------------------------------}

   //人物状态窗口(查看别人信息)
   d := g_WMainImages.Images[370];  //惑怕
   if d <> nil then begin
      DUserState1.SetImgIndex (g_WMainImages, 370);
      DUserState1.Left := SCREENWIDTH - d.Width - d.Width;
      DUserState1.Top := 0;
   end;
      DNecklaceUS1.Left := 38 + 130;
      DNecklaceUS1.Top  := 52 + 35;
      DNecklaceUS1.Width := 34;
      DNecklaceUS1.Height := 31;

      DHelmetUS1.Left := 38 + 77;
      DHelmetUS1.Top  := 52 + 41;
      DHelmetUS1.Width := 18;
      DHelmetUS1.Height := 18;

      DLightUS1.Left := 38 + 130;
      DLightUS1.Top  := 52 + 73;
      DLightUS1.Width := 34;
      DLightUS1.Height := 31;

      DArmRingRUS1.Left := 38 + 4;
      DArmRingRUS1.Top  := 52 + 124;
      DArmRingRUS1.Width := 34;
      DArmRingRUS1.Height := 31;

      DArmRingLUS1.Left := 38 + 130;
      DArmRingLUS1.Top  := 52 + 124;
      DArmRingLUS1.Width := 34;
      DArmRingLUS1.Height := 31;
      
      DRingRUS1.Left := 38 + 4;
      DRingRUS1.Top  := 52 + 163;
      DRingRUS1.Width := 34;
      DRingRUS1.Height := 31;

      DRingLUS1.Left := 38 + 130;
      DRingLUS1.Top  := 52 + 163;
      DRingLUS1.Width := 34;
      DRingLUS1.Height := 31;

      DWeaponUS1.Left := 38 + 9;
      DWeaponUS1.Top  := 52 + 28;
      DWeaponUS1.Width := 47;
      DWeaponUS1.Height := 87;

      DDressUS1.Left := 38 + 58;
      DDressUS1.Top  := 52 + 70;
      DDressUS1.Width := 53;
      DDressUS1.Height := 112;

      DBujukUS1.Left := 42;
      DBujukUS1.Top  := 254;
      DBujukUS1.Width := 34;
      DBujukUS1.Height := 31;

      DBeltUS1.Left := 84;
      DBeltUS1.Top  := 254;
      DBeltUS1.Width := 34;
      DBeltUS1.Height := 31;

      DBootsUS1.Left := 126;
      DBootsUS1.Top  := 254;
      DBootsUS1.Width := 34;
      DBootsUS1.Height := 31;

      DCharmUS1.Left := 168;
      DCharmUS1.Top  := 254;
      DCharmUS1.Width := 34;
      DCharmUS1.Height := 31;

   DCloseUS1.SetImgIndex (g_WMainImages, 371);
   DCloseUS1.Left := 20;
   DCloseUS1.Top := 223;

  {-------------------------------------------------------------}

   //背包物品窗口
   DItemBag.SetImgIndex (g_WMainImages, 3);
   DItemBag.Left := 0;
   DItemBag.Top := 0;

   DItemGrid.Left := 33;
   DItemGrid.Top  := 43;
   DItemGrid.Width := 286;
   DItemGrid.Height := 162;

   {-----------------------------------------------------------}

   //主控面板
{$IF SWH = SWH800}
   d := g_WMainImages.Images[BOTTOMBOARD800];
{$ELSEIF SWH = SWH1024}
   d := g_WMainImages.Images[BOTTOMBOARD1024];
{$IFEND}
   if d <> nil then begin
      DBottom.Left := 0;
      DBottom.Top  := SCREENHEIGHT - d.Height;
      DBottom.Width := d.Width;
      DBottom.Height := d.Height;
   end;

   {-----------------------------------------------------------}

   //功能按钮
   DMyState.SetImgIndex (g_WMainImages, 8);
   DMyState.Left := SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 243)){643};
   DMyState.Top := 61;
   DMyBag.SetImgIndex (g_WMainImages, 9);
   DMyBag.Left := SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 282)){682};
   DMyBag.Top := 41;
   DMyMagic.SetImgIndex (g_WMainImages, 10);
   DMyMagic.Left := SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 322)){722};
   DMyMagic.Top := 21;
   DOption.SetImgIndex (g_WMainImages, 11);
   DOption.Left := SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 364)){764};
   DOption.Top := 11;

   {-----------------------------------------------------------}

   //快捷按钮
   DBotMiniMap.SetImgIndex (g_WMainImages, DlgConf.DBotMiniMap.Image{130});
   DBotMiniMap.Left := DlgConf.DBotMiniMap.Left{219};
   DBotMiniMap.Top := DlgConf.DBotMiniMap.Top{104};
   DBotTrade.SetImgIndex (g_WMainImages,DlgConf.DBotTrade.Image{132});
   DBotTrade.Left :=DlgConf.DBotTrade.Left{219 + 30}; //560 - 30;
   DBotTrade.Top := DlgConf.DBotTrade.Top{104};
   DBotGuild.SetImgIndex (g_WMainImages,DlgConf.DBotGuild.Image{134});
   DBotGuild.Left := DlgConf.DBotGuild.Left{219 + 30*2};
   DBotGuild.Top := DlgConf.DBotGuild.Top{104};
   DBotGroup.SetImgIndex (g_WMainImages,DlgConf.DBotGroup.Image{128});
   DBotGroup.Left :=DlgConf.DBotGroup.Left{219 + 30*3};
   DBotGroup.Top :=DlgConf.DBotGroup.Top{104};
   DBotPlusAbil.SetImgIndex (g_WMainImages,DlgConf.DBotPlusAbil.Image{140});
   DBotPlusAbil.Left :=DlgConf.DBotPlusAbil.Left{219 + 30*4};
   DBotPlusAbil.Top :=DlgConf.DBotPlusAbil.Top{104};

   DBotFriend.SetImgIndex (g_WMainImages,DlgConf.DBotFriend.Image{530});
   DBotFriend.Left :=DlgConf.DBotFriend.Left{219 + 30*5};
   DBotFriend.Top :=DlgConf.DBotFriend.Top{104};

   DBotMemo.SetImgIndex (g_WMainImages,DlgConf.DBotMemo.Image{532});
   DBotMemo.Left :=DlgConf.DBotMemo.Left{753};
   DBotMemo.Top :=DlgConf.DBotMemo.Top{204};

   DBotExit.SetImgIndex (g_WMainImages,DlgConf.DBotExit.Image{138});
   DBotExit.Left :=DlgConf.DBotExit.Left{560};
   DBotExit.Top :=DlgConf.DBotExit.Top{104};
   DBotLogout.SetImgIndex (g_WMainImages,DlgConf.DBotLogout.Image{136});
   DBotLogout.Left :=DlgConf.DBotLogout.Left{560 - 30};
   DBotLogout.Top :=DlgConf.DBotLogout.Top{104};


   {-----------------------------------------------------------}

   //Belt 快捷栏
   DBelt1.Left := SCREENWIDTH div 2 - 115;//285;
   DBelt1.Width := 32;
   DBelt1.Top := 59;
   DBelt1.Height := 29;

   DBelt2.Left := DBelt1.Left + 43;//328;
   DBelt2.Width := 32;
   DBelt2.Top := 59;
   DBelt2.Height := 29;

   DBelt3.Left := DBelt2.Left + 43;//371;
   DBelt3.Width := 32;
   DBelt3.Top := 59;
   DBelt3.Height := 29;

   DBelt4.Left := DBelt3.Left + 43;//415;
   DBelt4.Width := 32;
   DBelt4.Top := 59;
   DBelt4.Height := 29;

   DBelt5.Left := DBelt4.Left + 43;//459;
   DBelt5.Width := 32;
   DBelt5.Top := 59;
   DBelt5.Height := 29;

   DBelt6.Left := DBelt5.Left + 43;//503;
   DBelt6.Width := 32;
   DBelt6.Top := 59;
   DBelt6.Height := 29;


   {-----------------------------------------------------------}

   //黄金、修理物品、关闭包裹按钮
   DGold.SetImgIndex (g_WMainImages, 29); //包裹金钱
   DGold.Left := 133;
   DGold.Top  := 231;

   DRepairItem.SetImgIndex (g_WMainImages, 64);
   DRepairItem.Left := 10;
   DRepairItem.Top := 10;
   DRepairItem.Width := 48;
   DRepairItem.Height := 22;
   DClosebag.SetImgIndex (g_WMainImages, 371); //包裹关闭
   DCloseBag.Left := 314;
   DCloseBag.Top := 20;
   DCloseBag.Width := 14;
   DCloseBag.Height := 20;

   {-----------------------------------------------------------}

   //商人对话框
   d := g_WMainImages.Images[384];
   if d <> nil then begin
      DMerchantDlg.Left := 0;
      DMerchantDlg.Top := 0;
      DMerchantDlg.SetImgIndex (g_WMainImages, 384);
   end;
   DMerchantDlgClose.Left := 372;
   DMerchantDlgClose.Top := 20;
   DMerchantDlgClose.SetImgIndex (g_WMainImages, 371);
   {-----------------------------------------------------------}
   //配置窗口
   d := g_WMainImages.Images[182];
   if d <> nil then begin
      DConfigDlg.SetImgIndex (g_WMainImages, 182);
      DConfigDlg.Left := (SCREENWIDTH - d.Width) div 2;
      DConfigDlg.Top := (SCREENHEIGHT - d.Height) div 2;
   end;
   DConfigDlgOk.SetImgIndex (g_WMainImages, 361);
   DConfigDlgOk.Left := 514;
   DConfigDlgOk.Top := 287;
   DConfigDlgClose.Left := 584;
   DConfigDlgClose.Top := 6;
   DConfigDlgClose.SetImgIndex (g_WMainImages, 64);

   {-----------------------------------------------------------}

   //菜单对话框
   d := g_WMainImages.Images[385];
   if d <> nil then begin
      DMenuDlg.Left := 132;
      DMenuDlg.Top  := 163;
      DMenuDlg.SetImgIndex (g_WMainImages, 385);
   end;
   DMenuPrev.Left := 328;
   DMenuPrev.Top := 42;
   DMenuPrev.SetImgIndex (g_WMainImages, 387);
   DMenuNext.Left := 328;
   DMenuNext.Top := 162;
   DMenuNext.SetImgIndex (g_WMainImages, 388);
   DMenuBuy.Left := 100;
   DMenuBuy.Top := 230;
   DMenuBuy.SetImgIndex (g_WMainImages, 362);
   DMenuClose.Left := 175;
   DMenuClose.Top := 230;
   DMenuClose.SetImgIndex (g_WMainImages, 366);

   {-----------------------------------------------------------}

   //出售
   d := g_WMainImages.Images[392];
   if d <> nil then begin
      DSellDlg.Left := 328;
      DSellDlg.Top  := 163;
      DSellDlg.SetImgIndex (g_WMainImages, 392);
   end;
   DSellDlgOk.Left := 28;
   DSellDlgOk.Top := 135;
   DSellDlgOk.SetImgIndex (g_WMainImages, 362);
   DSellDlgClose.Left := 81;
   DSellDlgClose.Top := 135;
   DSellDlgClose.SetImgIndex (g_WMainImages, 366);
   DSellDlgSpot.Left := 27;
   DSellDlgSpot.Top  := 67;
   DSellDlgSpot.Width := 61;
   DSellDlgSpot.Height := 52;

   {-----------------------------------------------------------}

   //设置魔法快捷对话框
   { }
   d := g_WMainImages.Images[229];
   if d <> nil then begin
      DKeySelDlg.Left := (SCREENWIDTH - d.Width) div 2;
      DKeySelDlg.Top  := (SCREENHEIGHT - d.Height) div 2;
      DKeySelDlg.SetImgIndex (g_WMainImages, 229);
   end;
   DKsIcon.Left := 51;
   DKsIcon.Top := 30;
   DKsF1.SetImgIndex (g_WMainImages, 232);
   DKsF1.Left := 57;
   DKsF1.Top  := 78;
   DKsF2.SetImgIndex (g_WMainImages, 234);
   DKsF2.Left := 89;
   DKsF2.Top  := 78;
   DKsF3.SetImgIndex (g_WMainImages, 236);
   DKsF3.Left := 121;
   DKsF3.Top  := 78;
   DKsF4.SetImgIndex (g_WMainImages, 238);
   DKsF4.Left := 153;
   DKsF4.Top  := 78;
   DKsF5.SetImgIndex (g_WMainImages, 240);
   DKsF5.Left := 192;
   DKsF5.Top  := 78;
   DKsF6.SetImgIndex (g_WMainImages, 242);
   DKsF6.Left := 224;
   DKsF6.Top  := 78;
   DKsF7.SetImgIndex (g_WMainImages, 244);
   DKsF7.Left := 256;
   DKsF7.Top  := 78;
   DKsF8.SetImgIndex (g_WMainImages, 246);
   DKsF8.Left := 288;
   DKsF8.Top := 78;
   DKsNone.SetImgIndex (g_WMainImages, 231);
   DKsNone.Left := 277;
   DKsNone.Top  := 121;
   DKsOk.SetImgIndex (g_WMainImages, 230);
   DKsOk.Left := 213;
   DKsOk.Top  := 121;

  {
   DKsConF1.SetImgIndex (g_WMainImages, 626);
   DKsConF1.Left := 25;
   DKsConF1.Top  := 120;
   DKsConF2.SetImgIndex (g_WMainImages, 628);
   DKsConF2.Left := 57;
   DKsConF2.Top  := 120;
   DKsConF3.SetImgIndex (g_WMainImages, 630);
   DKsConF3.Left := 89;
   DKsConF3.Top  := 120;
   DKsConF4.SetImgIndex (g_WMainImages, 632);
   DKsConF4.Left := 121;
   DKsConF4.Top  := 120;
   DKsConF5.SetImgIndex (g_WMainImages, 634);
   DKsConF5.Left := 160;
   DKsConF5.Top  := 120;
   DKsConF6.SetImgIndex (g_WMainImages, 636);
   DKsConF6.Left := 192;
   DKsConF6.Top  := 120;
   DKsConF7.SetImgIndex (g_WMainImages, 638);
   DKsConF7.Left := 224;
   DKsConF7.Top  := 120;
   DKsConF8.SetImgIndex (g_WMainImages, 640);
   DKsConF8.Left := 256;
   DKsConF8.Top := 120;
  }

   {-----------------------------------------------------------}
   //组对话框
   d := g_WMainImages.Images[120];
   if d <> nil then begin
      DGroupDlg.Left := (SCREENWIDTH - d.Width) div 2;
      DGroupDlg.Top  := (SCREENHEIGHT - d.Height) div 2;
      DGroupDlg.SetImgIndex (g_WMainImages, 120);
   end;
   DGrpDlgClose.SetImgIndex (g_WMainImages, 371);
   DGrpDlgClose.Left := 296;
   DGrpDlgClose.Top := 21;
   DGrpAllowGroup.SetImgIndex (g_WMainImages, 347);
   DGrpAllowGroup.Left := 147;
   DGrpAllowGroup.Top := 30;
   DGrpCreate.SetImgIndex (g_WMainImages, 123);
   DGrpCreate.Left := 45+1;
   DGrpCreate.Top := 254+1;
   DGrpAddMem.SetImgIndex (g_WMainImages, 125);
   DGrpAddMem.Left := 122+1;
   DGrpAddMem.Top := 254+1;
   DGrpDelMem.SetImgIndex (g_WMainImages, 124);
   DGrpDelMem.Left := 201+1;
   DGrpDelMem.Top := 254+1;

   {-----------------------------------------------------------}
   //交易对话框
   d := g_WMainImages.Images[389];  //卖出方
   if d <> nil then begin
      DDealDlg.Left := SCREENWIDTH - d.Width;
      DDealDlg.Top  := 0;
      DDealDlg.SetImgIndex (g_WMainImages, 389);
   end;
   DDGrid.Left := 21;
   DDGrid.Top  := 56;
   DDGrid.Width := 36 * 5;
   DDGrid.Height := 33 * 2;
   DDealOk.SetImgIndex (g_WMainImages, 391);
   DDealOk.Left := 155;
   DDealOk.Top := 193-65;
   DDealClose.SetImgIndex (g_WMainImages, 64);
   DDealClose.Left := 220;
   DDealClose.Top := 42;
   DDGold.SetImgIndex (g_WMainImages, 28);
   DDGold.Left := 11;
   DDGold.Top  := 202-65;

   d := g_WMainImages.Images[390];  //买进方
   if d <> nil then begin
      DDealRemoteDlg.Left := DDealDlg.Left - d.Width;
      DDealRemoteDlg.Top  := 0;
      DDealRemoteDlg.SetImgIndex (g_WMainImages, 390);
   end;
   DDRGrid.Left := 21;
   DDRGrid.Top  := 56;
   DDRGrid.Width := 36 * 5;
   DDRGrid.Height := 33 * 2;
   DDRGold.SetImgIndex (g_WMainImages, 28);
   DDRGold.Left := 11;
   DDRGold.Top  := 202-65;

   {-----------------------------------------------------------}
   //行会
   d := g_WMainImages.Images[180];
   if d <> nil then begin
      DGuildDlg.Left := 0;
      DGuildDlg.Top := 0;
      DGuildDlg.SetImgIndex (g_WMainImages, 180);
   end;
   DGDClose.Left := 568;
   DGDClose.Top  := 20;
   DGDClose.SetImgIndex (g_WMainImages, 371);
   DGDHome.Left := 27;
   DGDHome.Top  := 387;
   DGDHome.SetImgIndex (g_WMainImages, 198);
   DGDList.Left := 27;
   DGDList.Top  := 407;
   DGDList.SetImgIndex (g_WMainImages, 200);
   DGDChat.Left := 112;
   DGDChat.Top  := 407;
   DGDChat.SetImgIndex (g_WMainImages, 190);
   DGDAddMem.Left := 235;
   DGDAddMem.Top  := 387;
   DGDAddMem.SetImgIndex (g_WMainImages, 182);
   DGDDelMem.Left := 235;
   DGDDelMem.Top  := 407;
   DGDDelMem.SetImgIndex (g_WMainImages, 192);
   DGDEditNotice.Left := 320;
   DGDEditNotice.Top  := 387;
   DGDEditNotice.SetImgIndex (g_WMainImages, 196);
   DGDEditGrade.Left := 320;
   DGDEditGrade.Top  := 407;
   DGDEditGrade.SetImgIndex (g_WMainImages, 194);
   DGDAlly.Left := 404;
   DGDAlly.Top  := 387;
   DGDAlly.SetImgIndex (g_WMainImages, 184);
   DGDBreakAlly.Left := 404;
   DGDBreakAlly.Top  := 407;
   DGDBreakAlly.SetImgIndex (g_WMainImages, 186);
   DGDWar.Left := 488;
   DGDWar.Top  := 387;
   DGDWar.SetImgIndex (g_WMainImages, 202);
   DGDCancelWar.Left := 488;
   DGDCancelWar.Top  := 407;
   DGDCancelWar.SetImgIndex (g_WMainImages, 188);

   DGDUp.Left := 567;
   DGDUp.Top  := 110;
   DGDUp.SetImgIndex (g_WMainImages, 372);
   DGDDown.Left := 567;
   DGDDown.Top  := 364;
   DGDDown.SetImgIndex (g_WMainImages, 373);

    //行会通告编辑框
   DGuildEditNotice.SetImgIndex (g_WMainImages, 204);
   DGEOk.SetImgIndex (g_WMainImages, 361);
   DGEOk.Left := 514;
   DGEOk.Top := 287;
   DGEClose.SetImgIndex (g_WMainImages, 64);
   DGEClose.Left := 584;
   DGEClose.Top := 6;


   {-----------------------------------------------------------}
   //属性调整对话框
   DAdjustAbility.SetImgIndex (g_WMainImages, 226);
   DAdjustAbilClose.SetImgIndex (g_WMainImages, 371);
   DAdjustAbilClose.Left := 282;
   DAdjustAbilClose.Top := 19;
   DAdjustAbilOk.SetImgIndex (g_WMainImages, 230);
   DAdjustAbilOk.Left := 255;
   DAdjustAbilOk.Top := 301;

   DPlusDC.SetImgIndex (g_WMainImages, 224);
   DPlusDC.Left := 217;
   DPlusDC.Top := 101;
   DPlusMC.SetImgIndex (g_WMainImages, 224);
   DPlusMC.Left := 217;
   DPlusMC.Top := 121;
   DPlusSC.SetImgIndex (g_WMainImages, 224);
   DPlusSC.Left := 217;
   DPlusSC.Top := 140;
   DPlusAC.SetImgIndex (g_WMainImages, 224);
   DPlusAC.Left := 217;
   DPlusAC.Top := 160;
   DPlusMAC.SetImgIndex (g_WMainImages, 224);
   DPlusMAC.Left := 217;
   DPlusMAC.Top := 181;
   DPlusHP.SetImgIndex (g_WMainImages, 224);
   DPlusHP.Left := 217;
   DPlusHP.Top := 201;
   DPlusMP.SetImgIndex (g_WMainImages, 224);
   DPlusMP.Left := 217;
   DPlusMP.Top := 220;
   DPlusHit.SetImgIndex (g_WMainImages, 224);
   DPlusHit.Left := 217;
   DPlusHit.Top := 240;
   DPlusSpeed.SetImgIndex (g_WMainImages, 224);
   DPlusSpeed.Left := 217;
   DPlusSpeed.Top := 261;

   DMinusDC.SetImgIndex (g_WMainImages, 225);
   DMinusDC.Left := 227;
   DMinusDC.Top := 101;
   DMinusMC.SetImgIndex (g_WMainImages, 225);
   DMinusMC.Left := 227;
   DMinusMC.Top := 121;
   DMinusSC.SetImgIndex (g_WMainImages, 225);
   DMinusSC.Left := 227;
   DMinusSC.Top := 140;
   DMinusAC.SetImgIndex (g_WMainImages, 225);
   DMinusAC.Left := 227;
   DMinusAC.Top := 160;
   DMinusMAC.SetImgIndex (g_WMainImages, 225);
   DMinusMAC.Left := 227;
   DMinusMAC.Top := 181;
   DMinusHP.SetImgIndex (g_WMainImages, 225);
   DMinusHP.Left := 227;
   DMinusHP.Top := 201;
   DMinusMP.SetImgIndex (g_WMainImages, 225);
   DMinusMP.Left := 227;
   DMinusMP.Top := 220;
   DMinusHit.SetImgIndex (g_WMainImages, 225);
   DMinusHit.Left := 227;
   DMinusHit.Top := 240;
   DMinusSpeed.SetImgIndex (g_WMainImages, 225);
   DMinusSpeed.Left := 227;
   DMinusSpeed.Top := 261;

   d := g_WMainImages.Images[456]; //V字地方
   if d <> nil then begin
      DFriendDlg.SetImgIndex (g_WMainImages, 456);
      DFriendDlg.Left := 0;
      DFriendDlg.Top := 0;
   end;
   DFrdClose.SetImgIndex(g_WMainImages, 371);
   DFrdClose.Left:=247;
   DFrdClose.Top:=5;
   DFrdPgUp.SetImgIndex(g_WMainImages, 373);
   DFrdPgUp.Left:=259;
   DFrdPgUp.Top:=102;
   DFrdPgDn.SetImgIndex(g_WMainImages, 372);
   DFrdPgDn.Left:=259;
   DFrdPgDn.Top:=154;
   DFrdFriend.SetImgIndex(g_WMainImages, 540);
   DFrdFriend.Left:=15;
   DFrdFriend.Top:=35;
   DFrdBlackList.SetImgIndex(g_WMainImages, 573);
   DFrdBlackList.Left:=130;
   DFrdBlackList.Top:=35;
   DFrdAdd.SetImgIndex(g_WMainImages, 554);
   DFrdAdd.Left:=90;
   DFrdAdd.Top:=233;
   DFrdDel.SetImgIndex(g_WMainImages, 556);
   DFrdDel.Left:=124;
   DFrdDel.Top:=233;
   DFrdMemo.SetImgIndex(g_WMainImages, 558);
   DFrdMemo.Left:=158;
   DFrdMemo.Top:=233;
   DFrdMail.SetImgIndex(g_WMainImages, 560);
   DFrdMail.Left:=192;
   DFrdMail.Top:=233;
   DFrdWhisper.SetImgIndex(g_WMainImages, 562);
   DFrdWhisper.Left:=226;
   DFrdWhisper.Top:=233;

   d := g_WMainImages.Images[457];
   if d <> nil then begin
      DMailListDlg.SetImgIndex (g_WMainImages, 457);
      DMailListDlg.Left := 512;
      DMailListDlg.Top := 0;
   end;
   DMailListClose.SetImgIndex(g_WMainImages, 371);
   DMailListClose.Left:=247;
   DMailListClose.Top:=5;
   DMailListPgUp.SetImgIndex(g_WMainImages, 373);
   DMailListPgUp.Left:=259;
   DMailListPgUp.Top:=102;
   DMailListPgDn.SetImgIndex(g_WMainImages, 372);
   DMailListPgDn.Left:=259;
   DMailListPgDn.Top:=154;
   DMLReply.SetImgIndex(g_WMainImages, 564);
   DMLReply.Left:=90;
   DMLReply.Top:=233;
   DMLRead.SetImgIndex(g_WMainImages, 566);
   DMLRead.Left:=124;
   DMLRead.Top:=233;
   DMLDel.SetImgIndex(g_WMainImages, 556);
   DMLDel.Left:=158;
   DMLDel.Top:=233;
   DMLLock.SetImgIndex(g_WMainImages, 568);
   DMLLock.Left:=192;
   DMLLock.Top:=233;
   DMLBlock.SetImgIndex(g_WMainImages, 570);
   DMLBlock.Left:=226;
   DMLBlock.Top:=233;

   d := g_WMainImages.Images[458];
   if d <> nil then begin
      DBlockListDlg.SetImgIndex (g_WMainImages, 458);
      DBlockListDlg.Left := 512;
      DBlockListDlg.Top := 0;
   end;
   DBlockListClose.SetImgIndex(g_WMainImages, 371);
   DBlockListClose.Left:=247;
   DBlockListClose.Top:=5;
   DBLPgUp.SetImgIndex(g_WMainImages, 373);
   DBLPgUp.Left:=259;
   DBLPgUp.Top:=102;
   DBLPgDn.SetImgIndex(g_WMainImages, 372);
   DBLPgDn.Left:=259;
   DBLPgDn.Top:=154;
   DBLAdd.SetImgIndex(g_WMainImages, 554);
   DBLAdd.Left:=192;
   DBLAdd.Top:=233;
   DBLDel.SetImgIndex(g_WMainImages, 556);
   DBLDel.Left:=226;
   DBLDel.Top:=233;

   d := g_WMainImages.Images[459];
   if d <> nil then begin
      DMemo.SetImgIndex (g_WMainImages, 459);
      DMemo.Left := 290;
      DMemo.Top := 0;
   end;
   DMemoClose.SetImgIndex(g_WMainImages, 371);
   DMemoClose.Left:=205;
   DMemoClose.Top:=1;
   DMemoB1.SetImgIndex(g_WMainImages, 544);
   DMemoB1.Left:=58;
   DMemoB1.Top:=114;
   DMemoB2.SetImgIndex(g_WMainImages, 538);
   DMemoB2.Left:=126;
   DMemoB2.Top:=114;

   DButtonHP.Left   := 40;
   DButtonHP.Top    := 91;
   DButtonHP.Width  := 45;
   DButtonHP.Height := 90;

   DButtonMP.Left   := 40 + 47;
   DButtonMP.Top    := 91;
   DButtonMP.Width  := 45;
   DButtonMP.Height := 90;
   {
   //背包物品窗口
   DItemBag.SetImgIndex (g_WMain3Images, 6);
   DItemBag.Left := 0;
   DItemBag.Top := 0;

   DItemGrid.Left := 29;
   DItemGrid.Top  := 41;
   DItemGrid.Width := 286;
   DItemGrid.Height := 162;

   DClosebag.SetImgIndex (g_WMainImages, 372);
   DClosebag.Downed:=True;
   DCloseBag.Left := 336;
   DCloseBag.Top := 59;
   DCloseBag.Width := 14;
   DCloseBag.Height := 20;

   DGold.Left := 18;
   DGold.Top  := 218;

   d := g_WMain3Images.Images[207];  //惑怕
   if d <> nil then begin
      DStateWin.SetImgIndex (g_WMain3Images, 207);
      DStateWin.Left := SCREENWIDTH - d.Width;
      DStateWin.Top := 0;
   end;
     }
end;




{------------------------------------------------------------------------}



//声音 窗口
procedure TFrmDlg.OpenSoundOption;
begin
  g_boSound := not g_boSound;
  if g_boSound then begin
    DScreen.AddChatBoardString ('[音乐打开]',clWhite, clBlack);
  end else begin
    DScreen.AddChatBoardString ('[音乐关闭]',clWhite, clBlack);
  end;
end;
//打开/关闭我的属性对话框
procedure TFrmDlg.OpenMyStatus;
begin
   DStateWin.Visible := not DStateWin.Visible;
   PageChanged;
end;
//显示玩家信息对话框
procedure TFrmDlg.OpenUserState (UserState: TUserStateInfo);
begin
   UserState1 := UserState;
   DUserState1.Visible := TRUE;
end;

//显示/关闭物品对话框
procedure TFrmDlg.OpenItemBag;
begin
   DItemBag.Visible := not DItemBag.Visible;
   if DItemBag.Visible then
      ArrangeItemBag;
end;

//底部状态框
procedure TFrmDlg.ViewBottomBox (visible: Boolean);
begin
   DBottom.Visible := visible;
end;


// 取消物品移动
procedure TFrmDlg.CancelItemMoving;
var
   idx, n: integer;
begin
   if g_boItemMoving then begin
      g_boItemMoving := FALSE;
      idx := g_MovingItem.Index;
      if idx < 0 then begin
         if (idx <= -20) and (idx > -30) then begin
            AddDealItem (g_MovingItem.Item);
         end else begin
            n := -(idx+1);
            if n in [0..12] then begin
               g_UseItems[n] := g_MovingItem.Item;
            end;
         end;
      end else
         if idx in [0..MAXBAGITEM-1] then begin
            if g_ItemArr[idx].S.Name = '' then begin
               g_ItemArr[idx] := g_MovingItem.Item;
            end else begin
               AddItemBag (g_MovingItem.Item);
            end;
         end;
      g_MovingItem.Item.S.Name := '';
   end;
   ArrangeItemBag;
end;

//把移动的物品放下
procedure TFrmDlg.DropMovingItem;
var
   idx: integer;
begin
   if g_boItemMoving then begin
      g_boItemMoving := FALSE;
      if g_MovingItem.Item.S.Name <> '' then begin
         FrmMain.SendDropItem (g_MovingItem.Item.S.Name, g_MovingItem.Item.MakeIndex);
         AddDropItem (g_MovingItem.Item);
         g_MovingItem.Item.S.Name := '';
      end;
   end;
end;
//打开属性调整对话框
procedure TFrmDlg.OpenAdjustAbility;
begin
   DAdjustAbility.Left := 0;
   DAdjustAbility.Top := 0;
   g_nSaveBonusPoint := g_nBonusPoint;
   FillChar (g_BonusAbilChg, sizeof(TNakedAbility), #0);
   DAdjustAbility.Visible := TRUE;
end;

procedure TFrmDlg.DBackgroundBackgroundClick(Sender: TObject);
var
   dropgold: integer;
   valstr: string;
begin
   if g_boItemMoving then begin
      DBackground.WantReturn := TRUE;
      if g_MovingItem.Item.S.Name = g_sGoldName{'金币'} then begin
         g_boItemMoving := FALSE;
         g_MovingItem.Item.S.Name := '';
         //倔付甫 滚副 扒瘤 拱绢夯促.
         DialogSize := 1;
         DMessageDlg ('' +g_sGoldName+ ' 你想放下多少金币?', [mbOk, mbAbort]);
         GetValidStrVal (DlgEditText, valstr, [' ']);
         dropgold := Str_ToInt (valstr, 0);
         //
         FrmMain.SendDropGold (dropgold);
      end;
      if g_MovingItem.Index >= 0 then //酒捞袍 啊规俊辑 滚赴巴父..
         DropMovingItem;
   end;
end;

procedure TFrmDlg.DBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if g_boItemMoving then begin
      DBackground.WantReturn := TRUE;
   end;
end;

procedure TFrmDlg.DBottomMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
   function ExtractUserName (line: string): string;
   var
      uname: string;
   begin
      GetValidStr3 (line, line, ['(', '!', '*', '/', ')']);
      GetValidStr3 (line, uname, [' ', '=', ':']);
      if uname <> '' then
         if (uname[1] = '/') or (uname[1] = '(') or (uname[1] = ' ') or (uname[1] = '[') then
            uname := '';
      Result := uname;
   end;
var
   n: integer;
   str: string;
begin
   //当鼠标点在底部状态栏的消息上时
   if (X >= 208) and (X <= 308+374) and (Y >= SCREENHEIGHT-130) and (Y <= SCREENHEIGHT-130 + 12*9) then begin
      n := DScreen.ChatBoardTop + (Y - (SCREENHEIGHT-130)) div 12;
      if (n < DScreen.ChatStrs.Count) then begin
         if not PlayScene.EdChat.Visible then begin
            PlayScene.EdChat.Visible := TRUE;
            PlayScene.EdChat.SetFocus;
         end;
         PlayScene.EdChat.Text := '/' + ExtractUserName (DScreen.ChatStrs[n]) + ' ';
         PlayScene.EdChat.SelStart := Length(PlayScene.EdChat.Text);
         PlayScene.EdChat.SelLength := 0;
      end else
         PlayScene.EdChat.Text := ''; 
   end;
end;





{------------------------------------------------------------------------}

////显示通用对话框


function  TFrmDlg.DMessageDlg (msgstr: string; DlgButtons: TMsgDlgButtons): TModalResult;
const
   XBase = 324;
var
  I: Integer;
   lx, ly: integer;
   d: TDirectDrawSurface;
  procedure ShowDice();
  var
    I: Integer;
    bo05:Boolean;
  begin
    if m_nDiceCount = 1 then begin
      if m_Dice[0].n67C < 20 then begin
        if GetTickCount - m_Dice[0].dwPlayTick > 100 then begin
          if m_Dice[0].n67C div 5 = 4 then begin
            m_Dice[0].nPlayPoint:=Random(6) + 1;
          end else begin
            m_Dice[0].nPlayPoint:=m_Dice[0].n67C div 5 + 8;
          end;
          m_Dice[0].dwPlayTick:=GetTickCount();
          Inc(m_Dice[0].n67C);
        end;
        exit;
      end;//
      m_Dice[0].nPlayPoint:= m_Dice[0].nDicePoint;
      if GetTickCount - m_Dice[0].dwPlayTick > 1500 then begin
        DMsgDlg.Visible:=False;
      end;
      exit;
    end;//
    
    bo05:=True;
    for I := 0 to m_nDiceCount - 1 do begin
      if m_Dice[I].n67C < m_Dice[I].n680 then begin
        if GetTickCount - m_Dice[I].dwPlayTick > 100 then begin
          if m_Dice[I].n67C div 5 = 4 then begin
            m_Dice[I].nPlayPoint:=Random(6) + 1;
          end else begin
            m_Dice[I].nPlayPoint:=m_Dice[I].n67C div 5 + 8;
          end;
          m_Dice[I].dwPlayTick:=GetTickCount();
          Inc(m_Dice[I].n67C);
        end;
        bo05:=False;
      end else begin  //004915E4
        m_Dice[I].nPlayPoint:= m_Dice[I].nDicePoint;
        if GetTickCount - m_Dice[I].dwPlayTick < 2000 then begin
          bo05:=False;
        end;
      end;
    end; //for
    if bo05 then begin
      DMsgDlg.Visible:=False;
    end;
      
  end;
begin
   if DConfigDlg.Visible  then begin //打开提示框时关闭选项框
     DOptionClick();
   end;
     
   lx := XBase;
   ly := 126;
   case DialogSize of
      0:  //小对话框
         begin
            d := g_WMainImages.Images[381];
            if d <> nil then begin
               DMsgDlg.SetImgIndex (g_WMainImages, 381);
               DMsgDlg.Left := (SCREENWIDTH - d.Width) div 2;
               DMsgDlg.Top := (SCREENHEIGHT - d.Height) div 2;
               msglx := 39;
               msgly := 38;
               lx := 90;
               ly := 36;
            end;
         end;
      1:  //大对话框（横）
         begin
            d := g_WMainImages.Images[360];
            if d <> nil then begin
               DMsgDlg.SetImgIndex (g_WMainImages, 360);
               DMsgDlg.Left := (SCREENWIDTH - d.Width) div 2;
               DMsgDlg.Top := (SCREENHEIGHT - d.Height) div 2;
               msglx := 39;
               msgly := 38;
               lx := XBase;
               ly := 126;
            end;
         end;
      2:  //大对话框（竖）
         begin
            d := g_WMainImages.Images[380];
            if d <> nil then begin
               DMsgDlg.SetImgIndex (g_WMainImages, 380);
               DMsgDlg.Left := (SCREENWIDTH - d.Width) div 2;
               DMsgDlg.Top := (SCREENHEIGHT - d.Height) div 2;
               msglx := 23;
               msgly := 20;
               lx := 105;
               ly := 305;
            end;
         end;
   end;
   MsgText := msgstr;
   ViewDlgEdit := FALSE;       //编辑框不可见
   DMsgDlg.Floating := TRUE;   //允许鼠标移动
   DMsgDlgOk.Visible := FALSE;
   DMsgDlgYes.Visible := FALSE;
   DMsgDlgCancel.Visible := FALSE;
   DMsgDlgNo.Visible := FALSE;
   DMsgDlg.Left := (SCREENWIDTH - DMsgDlg.Width) div 2;
   DMsgDlg.Top := (SCREENHEIGHT - DMsgDlg.Height) div 2;
   //调整按钮
   for I := 0 to m_nDiceCount - 1 do begin
     m_Dice[I].n67C:=0;
     m_Dice[I].n680:=Random(m_nDiceCount + 2) * 5 + 10;
     m_Dice[I].nPlayPoint:=1;
     m_Dice[I].dwPlayTick:=GetTickCount();
   end;

   if mbCancel in DlgButtons then begin
      DMsgDlgCancel.Left := lx;
      DMsgDlgCancel.Top := ly;
      DMsgDlgCancel.Visible := TRUE;
      lx := lx - 110;
   end;
   if mbNo in DlgButtons then begin
      DMsgDlgNo.Left := lx;
      DMsgDlgNo.Top := ly;
      DMsgDlgNo.Visible := TRUE;
      lx := lx - 110;
   end;
   if mbYes in DlgButtons then begin
      DMsgDlgYes.Left := lx;
      DMsgDlgYes.Top := ly;
      DMsgDlgYes.Visible := TRUE;
      lx := lx - 110;
   end;
   if (mbOk in DlgButtons) or (lx = XBase) then begin
      DMsgDlgOk.Left := lx;
      DMsgDlgOk.Top := ly;
      DMsgDlgOk.Visible := TRUE;
      lx := lx - 110;
   end;
   HideAllControls;
   DMsgDlg.ShowModal;
   if mbAbort in DlgButtons then begin
      ViewDlgEdit := TRUE; //显示编辑框.
      DMsgDlg.Floating := FALSE;
      with EdDlgEdit do begin
         Text := '';
         Width := DMsgDlg.Width - 170;
         Left := (SCREENWIDTH - EdDlgEdit.Width) div 2;
         Top  := (SCREENHEIGHT - EdDlgEdit.Height) div 2 - 10;
      end;
   end;
   Result := mrOk;

   while TRUE do begin
      if not DMsgDlg.Visible then break;
      //FrmMain.DXTimerTimer (self, 0);
      FrmMain.ProcOnIdle;
      Application.ProcessMessages;

      if m_nDiceCount > 0 then begin
        m_boPlayDice:=True;

        for I := 0 to m_nDiceCount - 1 do begin
          m_Dice[I].nX:=((DMsgDlg.Width div 2 + 6) - ((m_nDiceCount * 32 + m_nDiceCount) div 2)) + (I * 32 + I);
          m_Dice[I].nY:=DMsgDlg.Height div 2 - 14;
        end;

        ShowDice();

      end;

      if Application.Terminated then exit;
   end;
   
   EdDlgEdit.Visible := FALSE;
   RestoreHideControls;
   DlgEditText := EdDlgEdit.Text;
   if PlayScene.EdChat.Visible then PlayScene.EdChat.SetFocus;
   ViewDlgEdit := FALSE;
   Result := DMsgDlg.DialogResult;
   DialogSize := 1; //扁夯惑怕
   m_nDiceCount:=0;
   m_boPlayDice:=False;
end;

procedure TFrmDlg.DMsgDlgOkClick(Sender: TObject; X, Y: Integer);
begin
   if Sender = DMsgDlgOk then DMsgDlg.DialogResult := mrOk;
   if Sender = DMsgDlgYes then DMsgDlg.DialogResult := mrYes;
   if Sender = DMsgDlgCancel then DMsgDlg.DialogResult := mrCancel;
   if Sender = DMsgDlgNo then DMsgDlg.DialogResult := mrNo;
   DMsgDlg.Visible := FALSE;   
end;

procedure TFrmDlg.DMsgDlgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = 13 then begin
      if DMsgDlgOk.Visible and not (DMsgDlgYes.Visible or DMsgDlgCancel.Visible or DMsgDlgNo.Visible) then begin
         DMsgDlg.DialogResult := mrOk;
         DMsgDlg.Visible := FALSE;
      end;
      if DMsgDlgYes.Visible and not (DMsgDlgOk.Visible or DMsgDlgCancel.Visible or DMsgDlgNo.Visible) then begin
         DMsgDlg.DialogResult := mrYes;
         DMsgDlg.Visible := FALSE;
      end;
   end;
   if Key = 27 then begin
      if DMsgDlgCancel.Visible then begin
         DMsgDlg.DialogResult := mrCancel;
         DMsgDlg.Visible := FALSE;
      end;
   end;
end;
{
procedure TFrmDlg.DMsgDlgOkDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  tGame:pGameInfo;
  tServer:pServerInfo;
  tStr:String;
begin
   with Sender as TDButton do begin
      if not Downed then
         d := WLib.Images[FaceIndex]
      else d := WLib.Images[FaceIndex+1];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);

      tGame:=GameList.Items[SelServerIndex];
      if (Name = 'DSServer1') and (tGame.ServerList.Count > 0) then begin
         tServer:=tGame.ServerList[0];
         tStr:=tServer.CaptionName;
      end;
      if (Name = 'DSServer2') and (tGame.ServerList.Count > 1) then begin
         tServer:=tGame.ServerList[1];
         tStr:=tServer.CaptionName;
      end;
      if (Name = 'DSServer3') and (tGame.ServerList.Count > 2) then begin
         tServer:=tGame.ServerList[2];
         tStr:=tServer.CaptionName;
      end;
      if (Name = 'DSServer4') and (tGame.ServerList.Count > 3) then begin
         tServer:=tGame.ServerList[3];
         tStr:=tServer.CaptionName;
      end;
      if (Name = 'DSServer5') and (tGame.ServerList.Count > 4) then begin
         tServer:=tGame.ServerList[4];
         tStr:=tServer.CaptionName;
      end;
      if (Name = 'DSServer6') and (tGame.ServerList.Count > 5) then begin
         tServer:=tGame.ServerList[5];
         tStr:=tServer.CaptionName;
      end;
          SetBkMode (dsurface.Canvas.Handle, TRANSPARENT);
          dsurface.Canvas.Font.Size :=12;
          BoldTextOut (dsurface, SurfaceX(Left + (d.Width - dsurface.Canvas.TextWidth(tStr)) div 2), SurfaceY(Top + (d.Height -dsurface.Canvas.TextHeight(tStr)) div 2), clYellow, clBlack, tStr);
          dsurface.Canvas.Font.Size :=9;          
//          dsurface.Canvas.Font:=oFont;
          dsurface.Canvas.Release;
   end;
end;
}
procedure TFrmDlg.DMsgDlgOkDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  tStr:String;
  Color:TColor;
  nStatus:Integer;
begin
try
   nStatus:=-1;
   with Sender as TDButton do begin
      if not Downed then
         d := WLib.Images[FaceIndex]
      else d := WLib.Images[FaceIndex+1];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);

      if (Name = 'DSServer1') and (g_ServerList.Count >= 1) then begin
        tStr:=g_ServerList.Strings[0];
        nStatus:=Integer(g_ServerList.Objects[0]);
      end;
      if (Name = 'DSServer2') and (g_ServerList.Count >= 2) then begin
        tStr:=g_ServerList.Strings[1];
        nStatus:=Integer(g_ServerList.Objects[1]);
      end;
      if (Name = 'DSServer3') and (g_ServerList.Count >= 3) then begin
        tStr:=g_ServerList.Strings[2];
        nStatus:=Integer(g_ServerList.Objects[2]);
      end;
      if (Name = 'DSServer4') and (g_ServerList.Count >= 4) then begin
        tStr:=g_ServerList.Strings[3];
        nStatus:=Integer(g_ServerList.Objects[3]);
      end;
      if (Name = 'DSServer5') and (g_ServerList.Count >= 5) then begin
        tStr:=g_ServerList.Strings[4];
        nStatus:=Integer(g_ServerList.Objects[4]);
      end;
      if (Name = 'DSServer6') and (g_ServerList.Count >= 6) then begin
        tStr:=g_ServerList.Strings[5];
        nStatus:=Integer(g_ServerList.Objects[5]);
      end;
      Color:=clYellow;
      case nStatus of
        0: begin
          tStr:=tStr + '(维护)';
          Color:=clDkGray;
        end;
        1: begin
          tStr:=tStr + '(空闲)';
          Color:=clLime;
        end;
        2: begin
          tStr:=tStr + '(良好)';
          Color:=clGreen;
        end;
        3: begin
          tStr:=tStr + '(繁忙)';
          Color:=clMaroon;
        end;
        4: begin
          tStr:=tStr + '(满员)';
          Color:=clRed;
        end;
      end;
          SetBkMode (dsurface.Canvas.Handle, TRANSPARENT);
          dsurface.Canvas.Font.Size :=11;
          dsurface.Canvas.Font.Style:=[fsBold];
          if TDButton(Sender).Downed then begin
            BoldTextOut (dsurface, SurfaceX(Left + (d.Width - dsurface.Canvas.TextWidth(tStr)) div 2) + 2, SurfaceY(Top + (d.Height -dsurface.Canvas.TextHeight(tStr)) div 2) + 2, Color{clYellow}, clBlack, tStr);
          end else begin //进门字体
            BoldTextOut (dsurface, SurfaceX(Left + (d.Width - dsurface.Canvas.TextWidth(tStr)) div 2), SurfaceY(Top + (d.Height -dsurface.Canvas.TextHeight(tStr)) div 2), Color{clYellow}, clBlack, tStr);
          end;
          dsurface.Canvas.Font.Style:=[];
          dsurface.Canvas.Font.Size :=9;
          dsurface.Canvas.Release;
   end;
except
  on e: Exception do begin
    ShowMessage(E.Message);
  end;
end;
end;
procedure TFrmDlg.DMsgDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  I: Integer;
  d: TDirectDrawSurface;
  ly: integer;
  str, data: string;
  nX,nY:Integer;
begin
   with Sender as TDWindow do begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);

      if m_boPlayDice then begin
        for I := 0 to m_nDiceCount - 1 do begin
          d:=g_WBagItemImages.GetCachedImage(m_Dice[I].nPlayPoint + 376 - 1,nX,nY);
          if d <> nil then begin
            dsurface.Draw (SurfaceX(Left) + m_Dice[I].nX + nX - 14, SurfaceY(Top) + m_Dice[I].nY + nY + 38, d.ClientRect, d, TRUE);
          end;
        end;
      end;
      
      SetBkMode (dsurface.Canvas.Handle, TRANSPARENT);
      ly := msgly;
      str := MsgText;
      while TRUE do begin
         if str = '' then break;
         str := GetValidStr3 (str, data, ['\']);
         if data <> '' then
            BoldTextOut (dsurface, SurfaceX(Left+msglx), SurfaceY(Top+ly), clWhite, clBlack, data);
         ly := ly + 14;
      end;
      dsurface.Canvas.Release;
   end;
   if ViewDlgEdit then begin
      if not EdDlgEdit.Visible then begin
         EdDlgEdit.Visible := TRUE;
         EdDlgEdit.SetFocus;
      end;
   end;
end;




{------------------------------------------------------------------------}

//新帐号


procedure TFrmDlg.DLoginNewDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   with Sender as TDButton do begin
      if TDButton(Sender).Downed then begin
         d := WLib.Images[FaceIndex];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end;
   end;
end;

procedure TFrmDlg.DLoginNewClick(Sender: TObject; X, Y: Integer);
begin
   LoginScene.NewClick;
end;

procedure TFrmDlg.DLoginOkClick(Sender: TObject; X, Y: Integer);
begin
   LoginScene.OkClick;
end;

procedure TFrmDlg.DLoginCloseClick(Sender: TObject; X, Y: Integer);
begin
   FrmMain.Close;
end;

procedure TFrmDlg.DLoginChgPwClick(Sender: TObject; X, Y: Integer);
begin
   LoginScene.ChgPwClick;
end;

procedure TFrmDlg.DLoginNewClickSound(Sender: TObject;
  Clicksound: TClickSound);
begin
   case Clicksound of
      csNorm:  PlaySound (s_norm_button_click);
      csStone: PlaySound (s_rock_button_click);
      csGlass: PlaySound (s_glass_button_click);
   end;
end;



{------------------------------------------------------------------------}
//辑滚 急琶 芒
{
procedure TFrmDlg.ShowSelectServerDlg;
var
  tGame:pGameInfo;
  tServer:pServerInfo;
begin
  tGame:=GameList.Items[SelServerIndex];
   case tGame.ServerList.Count of
     1:begin
         DSServer1.Visible:=True;
         DSServer1.Top:=204;
         DSServer2.Visible:=False;
         DSServer3.Visible:=False;
         DSServer4.Visible:=False;
         DSServer5.Visible:=False;
         DSServer6.Visible:=False;
       end;
     2:begin
         DSServer1.Visible:=True;
         DSServer1.Top:=200;
         DSServer2.Visible:=True;
         DSServer2.Top:=250;
         DSServer3.Visible:=False;
         DSServer4.Visible:=False;
         DSServer5.Visible:=False;
         DSServer6.Visible:=False;
       end;
     3:begin
         DSServer1.Visible:=True;
         DSServer2.Visible:=True;
         DSServer3.Visible:=True;
         DSServer4.Visible:=False;
         DSServer5.Visible:=False;
         DSServer6.Visible:=False;
       end;
     4:begin
         DSServer1.Visible:=True;
         DSServer2.Visible:=True;
         DSServer3.Visible:=True;
         DSServer4.Visible:=True;
         DSServer5.Visible:=False;
         DSServer6.Visible:=False;
       end;
     5:begin
         DSServer1.Visible:=True;
         DSServer2.Visible:=True;
         DSServer3.Visible:=True;
         DSServer4.Visible:=True;
         DSServer5.Visible:=True;
         DSServer6.Visible:=False;
       end;
     6:begin
         DSServer1.Visible:=True;
         DSServer2.Visible:=True;
         DSServer3.Visible:=True;
         DSServer4.Visible:=True;
         DSServer5.Visible:=True;
         DSServer6.Visible:=True;
       end;
   end;
   DSelServerDlg.Visible := TRUE;
end;
}
procedure TFrmDlg.ShowSelectServerDlg;
begin
   case g_ServerList.Count of
     1:begin
         DSServer1.Visible:=True;
         DSServer1.Top:=204;
         DSServer2.Visible:=False;
         DSServer3.Visible:=False;
         DSServer4.Visible:=False;
         DSServer5.Visible:=False;
         DSServer6.Visible:=False;
       end;
     2:begin
         DSServer1.Visible:=True;
         DSServer1.Top:=190;
         DSServer2.Visible:=True;
         DSServer2.Top:=235;
         DSServer3.Visible:=False;
         DSServer4.Visible:=False;
         DSServer5.Visible:=False;
         DSServer6.Visible:=False;
       end;
     3:begin
         DSServer1.Visible:=True;
         DSServer2.Visible:=True;
         DSServer3.Visible:=True;
         DSServer4.Visible:=False;
         DSServer5.Visible:=False;
         DSServer6.Visible:=False;
       end;
     4:begin
         DSServer1.Visible:=True;
         DSServer2.Visible:=True;
         DSServer3.Visible:=True;
         DSServer4.Visible:=True;
         DSServer5.Visible:=False;
         DSServer6.Visible:=False;
       end;
     5:begin
         DSServer1.Visible:=True;
         DSServer2.Visible:=True;
         DSServer3.Visible:=True;
         DSServer4.Visible:=True;
         DSServer5.Visible:=True;
         DSServer6.Visible:=False;
       end;
     6:begin
         DSServer1.Visible:=True;
         DSServer2.Visible:=True;
         DSServer3.Visible:=True;
         DSServer4.Visible:=True;
         DSServer5.Visible:=True;
         DSServer6.Visible:=True;
       end;
     else begin
         DSServer1.Visible:=True;
         DSServer2.Visible:=True;
         DSServer3.Visible:=True;
         DSServer4.Visible:=True;
         DSServer5.Visible:=True;
         DSServer6.Visible:=True;
       end;
   end;
   DSelServerDlg.Visible:=TRUE;
end;
procedure TFrmDlg.DSelServerDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var  
   d: TDirectDrawSurface;
begin

end;
{
procedure TFrmDlg.DSServer1Click(Sender: TObject; X, Y: Integer);
var
  svname: string;
  tGame:pGameInfo;
  tServer:pServerInfo;
begin
   svname := '';
   tGame:=GameList.Items[SelServerIndex];
   if Sender = DSServer1 then begin
     tServer:=tGame.ServerList.Items[0];
      svname :=tServer.ServerName;
      ServerMiniName :=tServer.ServerName;
   end;
   if Sender = DSServer2 then begin //辑滚 4锅..
     tServer:=tGame.ServerList.Items[1];
      svname :=tServer.ServerName;
      ServerMiniName :=tServer.ServerName;
   end;
   if Sender = DSServer3 then begin //辑滚 1锅..
     tServer:=tGame.ServerList.Items[2];
      svname :=tServer.ServerName;
      ServerMiniName :=tServer.ServerName;
   end;
   if Sender = DSServer4 then begin //辑滚 2锅..
     tServer:=tGame.ServerList.Items[3];
      svname :=tServer.ServerName;
      ServerMiniName :=tServer.ServerName;
   end;
   if Sender = DSServer5 then begin //辑滚 3锅..
     tServer:=tGame.ServerList.Items[4];
      svname :=tServer.ServerName;
      ServerMiniName :=tServer.ServerName;
   end;
   if Sender = DSServer6 then begin //辑滚 4锅..
     tServer:=tGame.ServerList.Items[5];
      svname :=tServer.ServerName;
      ServerMiniName :=tServer.ServerName;
   end;
   if svname <> '' then begin
      if BO_FOR_TEST then begin
         svname := '泅公辑滚';
         ServerMiniName := '泅公';
      end;
      FrmMain.SendSelectServer (svname);
      DSelServerDlg.Visible := FALSE;
      ServerName := svname;
   end;
end;
}
procedure TFrmDlg.DSServer1Click(Sender: TObject; X, Y: Integer);
var
  svname: string;
begin
   svname := '';
   if Sender = DSServer1 then begin
     svname:=g_ServerList.Strings[0];
     g_sServerMiniName:=svname;
   end;
   if Sender = DSServer2 then begin //辑滚 4锅..
     svname:=g_ServerList.Strings[1];
     g_sServerMiniName:=svname;
   end;
   if Sender = DSServer3 then begin //辑滚 1锅..
     svname:=g_ServerList.Strings[2];
     g_sServerMiniName:=svname;
   end;
   if Sender = DSServer4 then begin //辑滚 2锅..
     svname:=g_ServerList.Strings[3];
     g_sServerMiniName:=svname;
   end;
   if Sender = DSServer5 then begin //辑滚 3锅..
     svname:=g_ServerList.Strings[4];
     g_sServerMiniName:=svname;
   end;
   if Sender = DSServer6 then begin //辑滚 4锅..
     svname:=g_ServerList.Strings[5];
     g_sServerMiniName:=svname;
   end;
   if svname <> '' then begin
      if BO_FOR_TEST then begin
         svname := '传奇体验区';
         g_sServerMiniName := '传奇';
      end;
      FrmMain.SendSelectServer (svname);
      DSelServerDlg.Visible := FALSE;
      g_sServerName := svname;
   end;
end;
procedure TFrmDlg.DEngServer1Click(Sender: TObject; X, Y: Integer);
var
   svname: string;
begin
   svname := 'DragonServer';
   g_sServerMiniName := svname;

   if svname <> '' then begin
      FrmMain.SendSelectServer (svname);
      DSelServerDlg.Visible := FALSE;
      g_sServerName := svname;
   end;
end;


procedure TFrmDlg.DSSrvCloseClick(Sender: TObject; X, Y: Integer);
begin
   DSelServerDlg.Visible := FALSE;
   FrmMain.Close;
end;


{------------------------------------------------------------------------}
//创建帐号相关


procedure TFrmDlg.DNewAccountOkClick(Sender: TObject; X, Y: Integer);
begin
   LoginScene.NewAccountOk;
end;

procedure TFrmDlg.DNewAccountCloseClick(Sender: TObject; X, Y: Integer);
begin
   LoginScene.NewAccountClose;
end;

procedure TFrmDlg.DNewAccountDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
   i: integer;
begin
   with dsurface.Canvas do begin
      with DNewAccount do begin
         d := DMenuDlg.WLib.Images[FaceIndex];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end;

      SetBkMode (Handle, TRANSPARENT);
      Font.Color := clSilver;
      for i:=0 to NAHelps.Count-1 do begin
         //TextOut (79 + 386 + 10, 64 + 119 + 5 + i*14, NAHelps[i]);
         TextOut ((SCREENWIDTH div 2 - 289) + 386 + 10, (SCREENHEIGHT div 2 - 300) + 119 + 5 + i*14, NAHelps[i]);
      end;         //上问题提示
      BoldTextOut (dsurface, 79+283, 64 + 57, clWhite, clBlack, NewAccountTitle);
      Release;
   end;
end;



{------------------------------------------------------------------------}
////Chg pw 冠胶


procedure TFrmDlg.DChgpwOkClick(Sender: TObject; X, Y: Integer);
begin
   if Sender = DChgpwOk then LoginScene.ChgpwOk;
   if Sender = DChgpwCancel then LoginScene.ChgpwCancel;
end;




{------------------------------------------------------------------------}
//某腐磐 急琶


procedure TFrmDlg.DscSelect1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   with Sender as TDButton do begin
      if Downed then begin
         d := WLib.Images[FaceIndex];
         if d <> nil then
            dsurface.Draw (Left, Top, d.ClientRect, d, TRUE);
      end;
   end;
end;

procedure TFrmDlg.DscSelect1Click(Sender: TObject; X, Y: Integer);
begin
   if Sender = DscSelect1 then SelectChrScene.SelChrSelect1Click;
   if Sender = DscSelect2 then SelectChrScene.SelChrSelect2Click;
   if Sender = DscStart then SelectChrScene.SelChrStartClick;
   if Sender = DscNewChr then SelectChrScene.SelChrNewChrClick;
   if Sender = DscEraseChr then SelectChrScene.SelChrEraseChrClick;
   if Sender = DscCredits then SelectChrScene.SelChrCreditsClick;
   if Sender = DscExit then SelectChrScene.SelChrExitClick;
end;




{------------------------------------------------------------------------}
//人物选择相关


procedure TFrmDlg.DccCloseDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   with Sender as TDButton do begin
      if Downed then begin
         d := WLib.Images[FaceIndex];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
   end else begin
         d := nil;
         if Sender = DccWarrior then begin
            with SelectChrScene do
               if ChrArr[NewIndex].UserChr.Job = 0 then d := WLib.Images[55];
         end;
         if Sender = DccWizzard then begin
            with SelectChrScene do
               if ChrArr[NewIndex].UserChr.Job = 1 then d := WLib.Images[56];
         end;
         if Sender = DccMonk then begin
            with SelectChrScene do
               if ChrArr[NewIndex].UserChr.Job = 2 then d := WLib.Images[57];
         end;
         if Sender = DccMale then begin
            with SelectChrScene do
               if ChrArr[NewIndex].UserChr.Sex = 0 then d := WLib.Images[58];
         end;
         if Sender = DccFemale then begin
            with SelectChrScene do
               if ChrArr[NewIndex].UserChr.Sex = 1 then d := WLib.Images[59];
         end;
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end;
   end;
end;

procedure TFrmDlg.DccCloseClick(Sender: TObject; X, Y: Integer);
begin
   if Sender = DccClose then SelectChrScene.SelChrNewClose;
   if Sender = DccWarrior then SelectChrScene.SelChrNewJob (0);
   if Sender = DccWizzard then SelectChrScene.SelChrNewJob (1);
   if Sender = DccMonk then SelectChrScene.SelChrNewJob (2);
   if Sender = DccReserved then SelectChrScene.SelChrNewJob (3);
   if Sender = DccMale then SelectChrScene.SelChrNewm_btSex (0);
   if Sender = DccFemale then SelectChrScene.SelChrNewm_btSex (1);
   if Sender = DccLeftHair then SelectChrScene.SelChrNewPrevHair;
   if Sender = DccRightHair then SelectChrScene.SelChrNewNextHair;
   if Sender = DccOk then SelectChrScene.SelChrNewOk;
end;





{------------------------------------------------------------------------}

//人物相关...

{------------------------------------------------------------------------}


procedure TFrmDlg.DStateWinDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   i, l, m, pgidx, magline, bbx, bby, mmx, idx, ax, ay, trainlv: integer;
   pm: PTClientMagic;
   d: TDirectDrawSurface;
   hcolor, old, keyimg: integer;
   iname, d1, d2, d3: string;
   useable: Boolean;
begin
   if g_MySelf = nil then exit;
   with DStateWin do begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);

      case StatePage of
         0: begin //男//装备
            pgidx := 376;
            if g_MySelf <> nil then
               if g_MySelf.m_btSex = 1 then pgidx := 377; //女
            bbx := Left + 0;
            bby := Top + 0;
            d := g_WMainImages.Images[pgidx];
            if d <> nil then
               dsurface.Draw (SurfaceX(bbx), SurfaceY(bby), d.ClientRect, d, FALSE);
            bbx := bbx + 29;
            bby := bby + 74; //人物头发
            //发型
            idx := 440 + g_MySelf.m_btHair div 2; //人物头发选择
            if g_MySelf.m_btSex = 1 then idx := 441 + g_MySelf.m_btHair div 2;
            if idx > 0 then begin
               d := g_WMainImages.GetCachedImage (idx, ax, ay);
               if d <> nil then
                  dsurface.Draw (SurfaceX(bbx+ax), SurfaceY(bby+ay), d.ClientRect, d, TRUE);
            end;
            //服装
            if g_UseItems[U_DRESS].S.Name <> '' then begin
               idx := g_UseItems[U_DRESS].S.Looks; //渴 if Myself.m_btSex = 1 then idx := 80; //咯磊渴
               if idx >= 0 then begin
                  //d := FrmMain.WStateItem.GetCachedImage (idx, ax, ay);
                  d := FrmMain.GetWStateImg(idx,ax,ay);
                  if d <> nil then
                     dsurface.Draw (SurfaceX(bbx+ax), SurfaceY(bby+ay), d.ClientRect, d, TRUE);
               end;
            end;
            //武器
            if g_UseItems[U_WEAPON].S.Name <> '' then begin
               idx := g_UseItems[U_WEAPON].S.Looks;
               if idx >= 0 then begin
                  //d := FrmMain.WStateItem.GetCachedImage (idx, ax, ay);
                  d := FrmMain.GetWStateImg(idx,ax,ay);
                  if d <> nil then
                     dsurface.Draw (SurfaceX(bbx+ax), SurfaceY(bby+ay), d.ClientRect, d, TRUE);
               end;
            end;
            //头盔
            if g_UseItems[U_HELMET].S.Name <> '' then begin
               idx := g_UseItems[U_HELMET].S.Looks;
               if idx >= 0 then begin
                  //d := FrmMain.WStateItem.GetCachedImage (idx, ax, ay);
                  d := FrmMain.GetWStateImg(idx,ax,ay);
                  if d <> nil then
                     dsurface.Draw (SurfaceX(bbx+ax), SurfaceY(bby+ay), d.ClientRect, d, TRUE);
               end;
            end;
         end;
         1: begin //攻击属性地方
            l := Left + 137; //66;
            m := Top + 99;
            with dsurface.Canvas do begin
               SetBkMode (Handle, TRANSPARENT);
               Font.Color := clWhite;
               TextOut (SurfaceX(l+0), SurfaceY(m-22), IntToStr(LoWord(g_MySelf.m_Abil.AC)) + '-' + IntToStr(HiWord(g_MySelf.m_Abil.AC)));
               TextOut (SurfaceX(l+0), SurfaceY(m+5), IntToStr(LoWord(g_MySelf.m_Abil.MAC)) + '-' + IntToStr(HiWord(g_MySelf.m_Abil.MAC)));
               TextOut (SurfaceX(l+0), SurfaceY(m+34), IntToStr(LoWord(g_MySelf.m_Abil.DC)) + '-' + IntToStr(HiWord(g_MySelf.m_Abil.DC)));
               TextOut (SurfaceX(l+0), SurfaceY(m+60), IntToStr(LoWord(g_MySelf.m_Abil.MC)) + '-' + IntToStr(HiWord(g_MySelf.m_Abil.MC)));
               TextOut (SurfaceX(l+0), SurfaceY(m+88), IntToStr(LoWord(g_MySelf.m_Abil.SC)) + '-' + IntToStr(HiWord(g_MySelf.m_Abil.SC)));
               TextOut (SurfaceX(l+0), SurfaceY(m+116), IntToStr(g_MySelf.m_Abil.HP) + '/' + IntToStr(g_MySelf.m_Abil.MaxHP));
               TextOut (SurfaceX(l+0), SurfaceY(m+144), IntToStr(g_MySelf.m_Abil.MP) + '/' + IntToStr(g_MySelf.m_Abil.MaxMP));
               Release;
            end;
         end;
         2: begin //经验 筐 移动
            bbx := Left + 0;
            bby := Top + 0;
            d := g_WMainImages.Images[382];
            if d <> nil then
               dsurface.Draw (SurfaceX(bbx), SurfaceY(bby), d.ClientRect, d, FALSE);
             //经验全部移动
            bbx := bbx + 60;
            bby := bby + 70;
            with dsurface.Canvas do begin
               SetBkMode (Handle, TRANSPARENT);
               mmx := bbx + 85;
               Font.Color := clSilver;
               TextOut (bbx, bby, '经验值');
               TextOut (mmx, bby, FloatToStrFixFmt (100 * g_MySelf.m_Abil.Exp / g_MySelf.m_Abil.MaxExp, 3, 2) + '%');
               //TextOut (bbx, bby+14*1, '弥措版氰');
               //TextOut (mmx, bby+14*1, IntToStr(Myself.Abil.MaxExp));

               TextOut (bbx, bby+14*1, '背包负重');
               if g_MySelf.m_Abil.Weight > g_MySelf.m_Abil.MaxWeight then
                  Font.Color := clRed;
               TextOut (mmx, bby+14*1, IntToStr(g_MySelf.m_Abil.Weight) + '/' + IntToStr(g_MySelf.m_Abil.MaxWeight));

               Font.Color := clSilver;
               TextOut (bbx, bby+14*2, '装备负重');
               if g_MySelf.m_Abil.WearWeight > g_MySelf.m_Abil.MaxWearWeight then
                  Font.Color := clRed;
               TextOut (mmx, bby+14*2, IntToStr(g_MySelf.m_Abil.WearWeight) + '/' + IntToStr(g_MySelf.m_Abil.MaxWearWeight));

               Font.Color := clSilver;
               TextOut (bbx, bby+14*3, '手执负重');
               if g_MySelf.m_Abil.HandWeight > g_MySelf.m_Abil.MaxHandWeight then
                  Font.Color := clRed;
               TextOut (mmx, bby+14*3, IntToStr(g_MySelf.m_Abil.HandWeight) + '/' + IntToStr(g_MySelf.m_Abil.MaxHandWeight));

               Font.Color := clSilver;
               TextOut (bbx, bby+14*4, '精确度');
               TextOut (mmx, bby+14*4, IntToStr(g_nMyHitPoint));

               TextOut (bbx, bby+14*5, '敏捷度');
               TextOut (mmx, bby+14*5, IntToStr(g_nMySpeedPoint));

               TextOut (bbx, bby+14*6, '魔法防御');
               TextOut (mmx, bby+14*6, '+' + IntToStr(g_nMyAntiMagic * 10) + '%');

               TextOut (bbx, bby+14*7, '中毒防御');
               TextOut (mmx, bby+14*7, '+' + IntToStr(g_nMyAntiPoison * 10) + '%');

               TextOut (bbx, bby+14*8, '中毒恢复');
               TextOut (mmx, bby+14*8, '+' + IntToStr(g_nMyPoisonRecover * 10) + '%');

               TextOut (bbx, bby+14*9, '体力恢复');
               TextOut (mmx, bby+14*9, '+' + IntToStr(g_nMyHealthRecover * 10) + '%');

               TextOut (bbx, bby+14*10, '魔法恢复');
               TextOut (mmx, bby+14*10, '+' + IntToStr(g_nMySpellRecover * 10) + '%');

               Release;
            end;
         end;
         3: begin //魔法相关地方
            bbx := Left + 0;
            bby := Top + 0;
            d := g_WMainImages.Images[383];
            if d <> nil then
               dsurface.Draw (SurfaceX(bbx), SurfaceY(bby), d.ClientRect, d, FALSE);

            //功能键, lv, exp
            magtop := MagicPage * 5;
            magline := _MIN(MagicPage*5+5, g_MagicList.Count);
            for i:=magtop to magline-1 do begin
               pm := PTClientMagic (g_MagicList[i]);
               m := i - magtop;
               keyimg := 0;
               case byte(pm.Key) of

                  byte('1'): keyimg := 248;
                  byte('2'): keyimg := 249;
                  byte('3'): keyimg := 250;
                  byte('4'): keyimg := 251;
                  byte('5'): keyimg := 252;
                  byte('6'): keyimg := 253;
                  byte('7'): keyimg := 254;
                  byte('8'): keyimg := 255;
                  {
                  byte('E'): keyimg := 642;
                  byte('F'): keyimg := 643;
                  byte('G'): keyimg := 644;
                  byte('H'): keyimg := 645;
                  byte('I'): keyimg := 646;
                  byte('J'): keyimg := 647;
                  byte('K'): keyimg := 648;
                  byte('L'): keyimg := 649; }
               end;
               if keyimg > 0 then begin
                  d := g_WMainImages.Images[keyimg];
                  if d <> nil then
                     dsurface.Draw (bbx + 169, bby+52+m*44, d.ClientRect, d, TRUE);
               end;
               d := g_WMainImages.Images[23]; //lv
               if d <> nil then
                  dsurface.Draw (bbx + 68, bby+42+15+m*44, d.ClientRect, d, TRUE);
               d := g_WMainImages.Images[22]; //exp
               if d <> nil then
                  dsurface.Draw (bbx + 68 + 26, bby+42+15+m*44, d.ClientRect, d, TRUE);
            end;

            with dsurface.Canvas do begin
               SetBkMode (Handle, TRANSPARENT);
               Font.Color := clSilver;
               for i:=magtop to magline-1 do begin
                  pm := PTClientMagic (g_MagicList[i]);
                  m := i - magtop;
                  if not (pm.Level in [0..3]) then pm.Level := 0; //魔法最多3级
                  TextOut (bbx + 68, bby + 42 + m*44,
                              pm.Def.sMagicName);
                  if pm.Level in [0..3] then trainlv := pm.Level
                  else trainlv := 0;
                  TextOut (bbx + 68 + 16, bby + 42 + 15 + m*44, IntToStr(pm.Level));
                  if pm.Def.MaxTrain[trainlv] > 0 then begin
                     if trainlv < 3 then
                        TextOut (bbx + 68 + 46, bby + 42 + 15 + m*44, IntToStr(pm.CurTrain) + '/' + IntToStr(pm.Def.MaxTrain[trainlv]))
                     else TextOut (bbx + 68 + 46, bby + 42 + 15 + m*44, '-');
                  end;
               end;
               Release;
            end;
         end;
      end;
      {原为打开，本代码为显示人物身上所带物品信息，显示位置为人物下方
      if g_MouseStateItem.S.Name <> '' then begin
         g_MouseItem := g_MouseStateItem;
         GetMouseItemInfo (iname, d1, d2, d3, useable);
         if iname <> '' then begin
            if g_MouseItem.Dura = 0 then hcolor := clRed
            else hcolor := clWhite;
            with dsurface.Canvas do begin
               SetBkMode (Handle, TRANSPARENT);
               old := Font.Size;
               Font.Size := 8;
               Font.Color := clYellow;
               TextOut (SurfaceX(Left+37), SurfaceY(Top+272), iname);
               Font.Color := hcolor;
               TextOut (SurfaceX(Left+37+TextWidth(iname)), SurfaceY(Top+272), d1);
               TextOut (SurfaceX(Left+37), SurfaceY(Top+272+TextHeight('A')+2), d2);
               TextOut (SurfaceX(Left+37), SurfaceY(Top+272+(TextHeight('A')+2)*2), d3);
               Font.Size := old;
               Release;
            end;
         end;
         g_MouseItem.S.Name := '';
      end;
      }

      //人物筐玩家名称、行会
      with dsurface.Canvas do begin
         SetBkMode (Handle, TRANSPARENT);
         Font.Color := g_MySelf.m_nNameColor;
         TextOut (SurfaceX(Left + 122 - TextWidth(FrmMain.CharName) div 2),
                  SurfaceY(Top + 23), g_MySelf.m_sUserName);
         if StatePage = 0 then begin
            Font.Color := clSilver;
            TextOut (SurfaceX(Left + 65), SurfaceY(Top + 45),
                     g_sGuildName + ' ' + g_sGuildRankName);
         end;
         Release;
      end;
   end;
end;

procedure TFrmDlg.DSWLightDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   idx: integer;
   d: TDirectDrawSurface;
   tidx:integer;
begin
   if StatePage = 0 then begin
      if Sender = DSWNecklace then begin
         if g_UseItems[U_NECKLACE].S.Name <> '' then begin
            idx := g_UseItems[U_NECKLACE].S.Looks;
            if idx >= 0 then begin
               //d := FrmMain.WStateItem.Images[idx];
               d := FrmMain.GetWStateImg(idx);
               if d <> nil then
                  dsurface.Draw (DSWNecklace.SurfaceX(DSWNecklace.Left + (DSWNecklace.Width - d.Width) div 2),
                                 DSWNecklace.SurfaceY(DSWNecklace.Top + (DSWNecklace.Height - d.Height) div 2),
                                 d.ClientRect, d, TRUE);
            end;
         end;
      end;
      if Sender = DSWLight then begin
         if g_UseItems[U_RIGHTHAND].S.Name <> '' then begin
            idx := g_UseItems[U_RIGHTHAND].S.Looks;
            if idx >= 0 then begin
               //d := FrmMain.WStateItem.Images[idx];
               d := FrmMain.GetWStateImg(idx);
               if d <> nil then
                  dsurface.Draw (DSWLight.SurfaceX(DSWLight.Left + (DSWLight.Width - d.Width) div 2),
                                 DSWLight.SurfaceY(DSWLight.Top + (DSWLight.Height - d.Height) div 2),
                                 d.ClientRect, d, TRUE);
            end;
         end;
      end;
      if Sender = DSWArmRingR then begin
         if g_UseItems[U_ARMRINGR].S.Name <> '' then begin
            idx := g_UseItems[U_ARMRINGR].S.Looks;
            if idx >= 0 then begin
               //d := FrmMain.WStateItem.Images[idx];
               d := FrmMain.GetWStateImg(idx);
               if d <> nil then
                  dsurface.Draw (DSWArmRingR.SurfaceX(DSWArmRingR.Left + (DSWArmRingR.Width - d.Width) div 2),
                                 DSWArmRingR.SurfaceY(DSWArmRingR.Top + (DSWArmRingR.Height - d.Height) div 2),
                                 d.ClientRect, d, TRUE);
            end;
         end;
      end;
      if Sender = DSWArmRingL then begin
         if g_UseItems[U_ARMRINGL].S.Name <> '' then begin
            idx := g_UseItems[U_ARMRINGL].S.Looks;
            if idx >= 0 then begin
               //d := FrmMain.WStateItem.Images[idx];
               d := FrmMain.GetWStateImg(idx);
               if d <> nil then
                  dsurface.Draw (DSWArmRingL.SurfaceX(DSWArmRingL.Left + (DSWArmRingL.Width - d.Width) div 2),
                                 DSWArmRingL.SurfaceY(DSWArmRingL.Top + (DSWArmRingL.Height - d.Height) div 2),
                                 d.ClientRect, d, TRUE);
            end;
         end;
      end;
      if Sender = DSWRingR then begin
         if g_UseItems[U_RINGR].S.Name <> '' then begin
            idx := g_UseItems[U_RINGR].S.Looks;
            if idx >= 0 then begin
               //d := FrmMain.WStateItem.Images[idx];
               d := FrmMain.GetWStateImg(idx);
               if d <> nil then
                  dsurface.Draw (DSWRingR.SurfaceX(DSWRingR.Left + (DSWRingR.Width - d.Width) div 2),
                                 DSWRingR.SurfaceY(DSWRingR.Top + (DSWRingR.Height - d.Height) div 2),
                                 d.ClientRect, d, TRUE);
            end;
         end;
      end;
      if Sender = DSWRingL then begin
         if g_UseItems[U_RINGL].S.Name <> '' then begin
            idx := g_UseItems[U_RINGL].S.Looks;
            if idx >= 0 then begin
               //d := FrmMain.WStateItem.Images[idx];
               d := FrmMain.GetWStateImg(idx);
               if d <> nil then
                  dsurface.Draw (DSWRingL.SurfaceX(DSWRingL.Left + (DSWRingL.Width - d.Width) div 2),
                                 DSWRingL.SurfaceY(DSWRingL.Top + (DSWRingL.Height - d.Height) div 2),
                                 d.ClientRect, d, TRUE);
            end;
         end;
      end;

      if Sender = DSWBujuk then begin
         if g_UseItems[U_BUJUK].S.Name <> '' then begin
            idx := g_UseItems[U_BUJUK].S.Looks;
            if idx >= 0 then begin
               //d := FrmMain.WStateItem.Images[idx];
               d := FrmMain.GetWStateImg(idx);
               if d <> nil then
                  dsurface.Draw (DSWBujuk.SurfaceX(DSWBujuk.Left + (DSWBujuk.Width - d.Width) div 2),
                                 DSWBujuk.SurfaceY(DSWBujuk.Top + (DSWBujuk.Height - d.Height) div 2),
                                 d.ClientRect, d, TRUE);
            end;
         end;
      end;

      if Sender = DSWBelt then begin
         if g_UseItems[U_BELT].S.Name <> '' then begin
            idx := g_UseItems[U_BELT].S.Looks;
            if idx >= 0 then begin
               //d := FrmMain.WStateItem.Images[idx];
               d := FrmMain.GetWStateImg(idx);
               if d <> nil then
                  dsurface.Draw (DSWBelt.SurfaceX(DSWBelt.Left + (DSWBelt.Width - d.Width) div 2),
                                 DSWBelt.SurfaceY(DSWBelt.Top + (DSWBelt.Height - d.Height) div 2),
                                 d.ClientRect, d, TRUE);
            end;
         end;
      end;

      if Sender = DSWBoots then begin
         if g_UseItems[U_BOOTS].S.Name <> '' then begin
            idx := g_UseItems[U_BOOTS].S.Looks;
            if idx >= 0 then begin
               //d := FrmMain.WStateItem.Images[idx];
               d := FrmMain.GetWStateImg(idx);
               if d <> nil then
                  dsurface.Draw (DSWBoots.SurfaceX(DSWBoots.Left + (DSWBoots.Width - d.Width) div 2),
                                 DSWBoots.SurfaceY(DSWBoots.Top + (DSWBoots.Height - d.Height) div 2),
                                 d.ClientRect, d, TRUE);
            end;
         end;
      end;

      if Sender = DSWCharm then begin
         if g_UseItems[U_CHARM].S.Name <> '' then begin
            idx := g_UseItems[U_CHARM].S.Looks;
            if idx >= 0 then begin
               //d := FrmMain.WStateItem.Images[idx];
               d := FrmMain.GetWStateImg(idx);
               if d <> nil then
                  dsurface.Draw (DSWCharm.SurfaceX(DSWCharm.Left + (DSWCharm.Width - d.Width) div 2),
                                 DSWCharm.SurfaceY(DSWCharm.Top + (DSWCharm.Height - d.Height) div 2),
                                 d.ClientRect, d, TRUE);
            end;
         end;
      end;

   end;
end;

procedure TFrmDlg.DStateWinClick(Sender: TObject; X, Y: Integer);
begin
   if StatePage = 3 then begin
      X := DStateWin.LocalX (X) - DStateWin.Left;
      Y := DStateWin.LocalY (Y) - DStateWin.Top;
      if (X >= 33) and (X <= 33+166) and (Y >= 55) and (Y <= 55+37*5) then begin
         magcur := (Y-55) div 37;
         if (magcur+magtop) >= g_MagicList.Count then
            magcur := (g_MagicList.Count-1) - magtop;
      end;
   end;
end;

procedure TFrmDlg.DCloseStateClick(Sender: TObject; X, Y: Integer);
begin
   DStateWin.Visible := FALSE;
end;

procedure TFrmDlg.DPrevStateDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   with Sender as TDButton do begin
      if TDButton(Sender).Downed then begin
         d := WLib.Images[FaceIndex];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end;
   end;
end;

procedure TFrmDlg.PageChanged;
begin
   DScreen.ClearHint;
   case StatePage of
      3: begin //魔法 惑怕芒
         DStMag1.Visible := TRUE;  DStMag2.Visible := TRUE;
         DStMag3.Visible := TRUE;  DStMag4.Visible := TRUE;
         DStMag5.Visible := TRUE;
         DStPageUp.Visible := TRUE;
         DStPageDown.Visible := TRUE;
         MagicPage := 0;
      end;
      else begin
         DStMag1.Visible := FALSE;  DStMag2.Visible := FALSE;
         DStMag3.Visible := FALSE;  DStMag4.Visible := FALSE;
         DStMag5.Visible := FALSE;
         DStPageUp.Visible := FALSE;
         DStPageDown.Visible := FALSE;
      end;
   end;
end;

procedure TFrmDlg.DPrevStateClick(Sender: TObject; X, Y: Integer);
begin
   Dec (StatePage);
   if StatePage < 0 then
      StatePage := MAXSTATEPAGE-1;
   PageChanged;
end;

procedure TFrmDlg.DNextStateClick(Sender: TObject; X, Y: Integer);
begin
   Inc (StatePage);
   if StatePage > MAXSTATEPAGE-1 then
      StatePage := 0;
   PageChanged;
end;
//点击武器、衣服等装备
procedure TFrmDlg.DSWWeaponClick(Sender: TObject; X, Y: Integer);
var
   where, n, sel: integer;
   flag, movcancel: Boolean;
begin
   if g_MySelf = nil then exit;
   if StatePage <> 0 then exit;
   if g_boItemMoving then begin
      flag := FALSE;
      movcancel := FALSE;
      if (g_MovingItem.Index = -97) or (g_MovingItem.Index = -98) then exit;
      if (g_MovingItem.Item.S.Name = '') or (g_WaitingUseItem.Item.S.Name <> '') then exit;
      where := GetTakeOnPosition (g_MovingItem.Item.S.StdMode);
      if g_MovingItem.Index >= 0 then begin
         case where of
            U_DRESS: begin
               if Sender = DSWDress then begin
                  if g_MySelf.m_btSex = 0 then //男的
                     if g_MovingItem.Item.S.StdMode <> 10 then //巢磊渴
                        exit;
                  if g_MySelf.m_btSex = 1 then //女的
                     if g_MovingItem.Item.S.StdMode <> 11 then //咯磊渴
                        exit;
                  flag := TRUE;
               end;
            end;
            U_WEAPON: begin
               if Sender = DSWWEAPON then begin
                  flag := TRUE;
               end;
            end;
            U_NECKLACE: begin
               if Sender = DSWNecklace then
                  flag := TRUE;
            end;
            U_RIGHTHAND: begin
               if Sender = DSWLight then
                  flag := TRUE;
            end;
            U_HELMET: begin
               if Sender = DSWHelmet then
                  flag := TRUE;
            end;
            U_RINGR, U_RINGL: begin
               if Sender = DSWRingL then begin
                  where := U_RINGL;
                  flag := TRUE;
               end;
               if Sender = DSWRingR then begin
                  where := U_RINGR;
                  flag := TRUE;
               end;
            end;
            U_ARMRINGR: begin  //迫骂
               if Sender = DSWArmRingL then begin
                  where := U_ARMRINGL;
                  flag := TRUE;
               end;
               if Sender = DSWArmRingR then begin
                  where := U_ARMRINGR;
                  flag := TRUE;
               end;
            end;
            U_ARMRINGL: begin  //25,  刀啊风,迫骂
               if Sender = DSWArmRingL then begin
                  where := U_ARMRINGL;
                  flag := TRUE;
               end;
            end;
            U_BUJUK: begin
               if Sender = DSWBujuk then begin
                  where := U_BUJUK;
                  flag := TRUE;
               end;
               if Sender = DSWArmRingL then begin
                  where := U_ARMRINGL;
                  flag := TRUE;
               end;               
            end;
            U_BELT: begin
               if Sender = DSWBelt then begin
                  where := U_BELT;
                  flag := TRUE;
               end;
            end;
            U_BOOTS: begin
               if Sender = DSWBoots then begin
                  where := U_BOOTS;
                  flag := TRUE;
               end;
            end;
            U_CHARM: begin
               if Sender = DSWCharm then begin
                  where := U_CHARM;
                  flag := TRUE;
               end;
            end;
         end;
      end else begin
         n := -(g_MovingItem.Index+1);
         if n in [0..12] then begin
            ItemClickSound (g_MovingItem.Item.S);
            g_UseItems[n] := g_MovingItem.Item;
            g_MovingItem.Item.S.Name := '';
            g_boItemMoving := FALSE;
         end;
      end;
      if flag then begin
         ItemClickSound (g_MovingItem.Item.S);
         g_WaitingUseItem := g_MovingItem;
         g_WaitingUseItem.Index := where;

         FrmMain.SendTakeOnItem (where, g_MovingItem.Item.MakeIndex, g_MovingItem.Item.S.Name);
         g_MovingItem.Item.S.Name := '';
         g_boItemMoving := FALSE;
      end;
   end else begin
      flag := FALSE;
      if (g_MovingItem.Item.S.Name <> '') or (g_WaitingUseItem.Item.S.Name <> '') then exit;
      sel := -1;
      if Sender = DSWDress then sel := U_DRESS;
      if Sender = DSWWeapon then sel := U_WEAPON;
      if Sender = DSWHelmet then sel := U_HELMET;
      if Sender = DSWNecklace then sel := U_NECKLACE;
      if Sender = DSWLight then sel := U_RIGHTHAND;
      if Sender = DSWRingL then sel := U_RINGL;
      if Sender = DSWRingR then sel := U_RINGR;
      if Sender = DSWArmRingL then sel := U_ARMRINGL;
      if Sender = DSWArmRingR then sel := U_ARMRINGR;

      if Sender = DSWBujuk then sel := U_BUJUK;
      if Sender = DSWBelt then sel := U_BELT;  //
      if Sender = DSWBoots then sel := U_BOOTS;
      if Sender = DSWCharm then sel := U_CHARM;

      if sel >= 0 then begin
         if g_UseItems[sel].S.Name <> '' then begin
            ItemClickSound (g_UseItems[sel].S);
            g_MovingItem.Index := -(sel+1);
            g_MovingItem.Item := g_UseItems[sel];
            g_UseItems[sel].S.Name := '';
            g_boItemMoving := TRUE;
         end;
      end;
   end;
end;

procedure TFrmDlg.DSWWeaponMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  nLocalX,nLocalY:Integer;
  nHintX,nHintY:Integer;
  sel: integer;
  iname, d1, d2, d3: string;
  useable: Boolean;
  hcolor: TColor;
  Butt:TDButton;
begin
   if StatePage <> 0 then exit;
   //DScreen.ClearHint;
   sel := -1;
   Butt:=TDButton(Sender);
   if Sender = DSWDress then sel := U_DRESS;
   if Sender = DSWWeapon then sel := U_WEAPON;
   if Sender = DSWHelmet then sel := U_HELMET;
   if Sender = DSWNecklace then sel := U_NECKLACE;
   if Sender = DSWLight then sel := U_RIGHTHAND;
   if Sender = DSWRingL then sel := U_RINGL;
   if Sender = DSWRingR then sel := U_RINGR;
   if Sender = DSWArmRingL then sel := U_ARMRINGL;
   if Sender = DSWArmRingR then sel := U_ARMRINGR;
   {
   if Sender = DSWBujuk then sel := U_RINGL;
   if Sender = DSWBelt then sel := U_RINGR;
   if Sender = DSWBoots then sel := U_ARMRINGL;
   if Sender = DSWCharm then sel := U_ARMRINGR;
   }

   if Sender = DSWBujuk then sel := U_BUJUK;
   if Sender = DSWBelt then sel := U_BELT;
   if Sender = DSWBoots then sel := U_BOOTS;
   if Sender = DSWCharm then sel := U_CHARM;
   
   if sel >= 0 then begin
      g_MouseStateItem := g_UseItems[sel];
      //原为注释掉 显示人物身上带的物品信息
      g_MouseItem := g_UseItems[sel];
      GetMouseItemInfo (iname, d1, d2, d3, useable);
      if iname <> '' then begin
         if g_UseItems[sel].Dura = 0 then hcolor := clRed
         else hcolor := clWhite;

         nLocalX:=Butt.LocalX(X - Butt.Left);
         nLocalY:=Butt.LocalY(Y - Butt.Top);
         nHintX:=Butt.SurfaceX(Butt.Left) + DStateWin.SurfaceX(DStateWin.Left) + nLocalX;
         nHintY:=Butt.SurfaceY(Butt.Top) + DStateWin.SurfaceY(DStateWin.Top) + nLocalY;

         {with Sender as TDButton do
            DScreen.ShowHint (SurfaceX(Left - 30),
                              SurfaceY(Top + 50),
                              iname + d1 + '\' + d2 + '\' + d3, hcolor, FALSE); }

         with Butt as TDButton do
          DScreen.ShowHint(nHintX,nHintY,
                             iname + d1 + '\' + d2 + '\' + d3, hcolor, FALSE);
      end;
      g_MouseItem.S.Name := '';
      //

   end;
end;

procedure TFrmDlg.DStateWinMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
   //DScreen.ClearHint;
   g_MouseStateItem.S.Name := '';
end;


//惑怕芒 : 魔法 其捞瘤

procedure TFrmDlg.DStMag1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   idx, icon: integer;
   d: TDirectDrawSurface;
   pm: PTClientMagic;
begin
   with Sender as TDButton do begin
      idx := _Max(Tag + MagicPage * 5, 0);
      if idx < g_MagicList.Count then begin
         pm := PTClientMagic (g_MagicList[idx]);
         icon := pm.Def.btEffect * 2;
         if icon >= 0 then begin //酒捞能捞 绝绰芭..
            if not Downed then begin
               d := g_WMagIconImages.Images[icon];
               if d <> nil then
                  dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
            end else begin
               d := g_WMagIconImages.Images[icon+1];
               if d <> nil then
                  dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
            end;
         end;
      end;
   end;
end;

procedure TFrmDlg.DStMag1Click(Sender: TObject; X, Y: Integer);
var
   i, idx: integer;
   selkey: word;
   keych: char;
   pm: PTClientMagic;
begin
   if StatePage = 3 then begin
      idx := TDButton(Sender).Tag + magtop;
      if (idx >= 0) and (idx < g_MagicList.Count) then begin

         pm := PTClientMagic (g_MagicList[idx]);
         selkey := word(pm.Key);
         SetMagicKeyDlg (pm.Def.btEffect * 2, pm.Def.sMagicName, selkey);
         keych := char(selkey);

         for i:=0 to g_MagicList.Count-1 do begin
            pm := PTClientMagic (g_MagicList[i]);
            if pm.Key = keych then begin
               pm.Key := #0;
               FrmMain.SendMagicKeyChange (pm.Def.wMagicId, #0);
            end;
         end;
         pm := PTClientMagic (g_MagicList[idx]);
         //if pm.Def.EffectType <> 0 then begin //八过篮 虐汲沥阑 给窃.
         pm.Key := keych;
         FrmMain.SendMagicKeyChange (pm.Def.wMagicId, keych);
         //end;
      end;
   end;
end;

procedure TFrmDlg.DStPageUpClick(Sender: TObject; X, Y: Integer);
begin
   if Sender = DStPageUp then begin
      if MagicPage > 0 then
         Dec (MagicPage);
   end else begin
      if MagicPage < (g_MagicList.Count+4) div 5 - 1 then
         Inc (MagicPage);
   end;
end;





{------------------------------------------------------------------------}

//底部相关

{------------------------------------------------------------------------}


procedure TFrmDlg.DBottomDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d:TDirectDrawSurface;
  rc:TRect;
  btop, sx, sy, i, fcolor, bcolor: integer;
  r: Real;
  str: string;
begin

{$IF SWH = SWH800}
  d:=g_WMainImages.Images[BOTTOMBOARD800];
{$ELSEIF SWH = SWH1024}
  d:=g_WMainImages.Images[BOTTOMBOARD1024];
{$IFEND}
  if d <> nil then
    dsurface.Draw (DBottom.Left, DBottom.Top, d.ClientRect, d, TRUE);
  btop := 0;
  if d <> nil then begin
    with d.ClientRect do
       rc := Rect (Left, Top, Right, Top+120);
    btop := SCREENHEIGHT - d.height;
    //上半部透明
    dsurface.Draw (0,
                   btop,
                   rc,
                   d, TRUE);
    with d.ClientRect do
      rc := Rect (Left, Top+120, Right, Bottom);
      //下半部不透明
    dsurface.Draw (0,
                   btop + 120,
                   rc,
                   d, FALSE);
  end;
   //时间周期显示
   d := nil;
   case g_nDayBright of
      0: d := g_WMainImages.Images[15];  //早上
      1: d := g_WMainImages.Images[12];  //白天
      2: d := g_WMainImages.Images[13];  //傍晚
      3: d := g_WMainImages.Images[14];  //晚上
   end;
   if d <> nil then
     dsurface.Draw (SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 348)){748}, 79+DBottom.Top, d.ClientRect, d, FALSE);

   if g_MySelf <> nil then begin
      //显示HP及MP 图形
      if (g_MySelf.m_Abil.MaxHP > 0) and (g_MySelf.m_Abil.MaxMP > 0) then begin
         if (g_MySelf.m_btJob = 0) and (g_MySelf.m_Abil.Level < 28) then begin //武士
            d := g_WMainImages.Images[5];
            if d <> nil then begin
               rc := d.ClientRect;
               rc.Right := d.ClientRect.Right - 2;
               dsurface.Draw (38, btop+90, rc, d, FALSE);
            end;
            d := g_WMainImages.Images[6];
            if d <> nil then begin
               rc := d.ClientRect;
               rc.Right := d.ClientRect.Right - 2;
               rc.Top := Round(rc.Bottom / g_MySelf.m_Abil.MaxHP * (g_MySelf.m_Abil.MaxHP - g_MySelf.m_Abil.HP));
               dsurface.Draw (38, btop+90+rc.Top, rc, d, FALSE);
            end;
         end else begin
            d := g_WMainImages.Images[4];
            if d <> nil then begin
               //HP 图形
               rc := d.ClientRect;
               rc.Right := d.ClientRect.Right div 2 - 1;
               rc.Top := Round(rc.Bottom / g_MySelf.m_Abil.MaxHP * (g_MySelf.m_Abil.MaxHP - g_MySelf.m_Abil.HP));
               dsurface.Draw (40, btop+91+rc.Top, rc, d, FALSE);
               //MP 图形
               rc := d.ClientRect;
               rc.Left := d.ClientRect.Right div 2 + 1;
               rc.Right := d.ClientRect.Right - 1;
               rc.Top := Round(rc.Bottom / g_MySelf.m_Abil.MaxMP * (g_MySelf.m_Abil.MaxMP - g_MySelf.m_Abil.MP));
               dsurface.Draw (40 + rc.Left, btop+91+rc.Top, rc, d, FALSE);
            end;
         end;
      end;

      //等级
      with dsurface.Canvas do begin
        PomiTextOut (dsurface, SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 260)){660}, SCREENHEIGHT - 104, IntToStr(g_MySelf.m_Abil.Level));
      end;
      //
      if (g_MySelf.m_Abil.MaxExp > 0) and (g_MySelf.m_Abil.MaxWeight > 0) then begin
         d := g_WMainImages.Images[7];
         if d <> nil then begin
            //经验条
            rc := d.ClientRect;
            if g_MySelf.m_Abil.Exp > 0 then r := g_MySelf.m_Abil.MaxExp / g_MySelf.m_Abil.Exp
            else r := 0;
            if r > 0 then rc.Right := Round (rc.Right / r)
            else rc.Right := 0;
            {
            dsurface.Draw (666, 527, rc, d, FALSE);
            PomiTextOut (dsurface, 660, 528, IntToStr(Myself.Abil.Exp));
            }
            dsurface.Draw (SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 266)){666}, SCREENHEIGHT - 73, rc, d, FALSE);
            //PomiTextOut (dsurface, SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 260)){660}, SCREENHEIGHT - 72, FloatToStrFixFmt (100 * g_MySelf.m_Abil.Exp / g_MySelf.m_Abil.MaxExp, 3, 2) + '%');
            //PomiTextOut (dsurface, SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 260)){660}, SCREENHEIGHT - 57, IntToStr(g_MySelf.m_Abil.MaxExp));

            //背包重量条
            rc := d.ClientRect;
            if g_MySelf.m_Abil.Weight > 0 then r := g_MySelf.m_Abil.MaxWeight / g_MySelf.m_Abil.Weight
            else r := 0;
            if r > 0 then rc.Right := Round (rc.Right / r)
            else rc.Right := 0;
            {
            dsurface.Draw (666, 560, rc, d, FALSE);
            PomiTextOut (dsurface, 660, 561, IntToStr(Myself.Abil.Weight));
            }
            dsurface.Draw (SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 266)){666}, SCREENHEIGHT - 40, rc, d, FALSE);
            //PomiTextOut (dsurface, SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 260)){660}, SCREENHEIGHT - 39, IntToStr(g_MySelf.m_Abil.Weight) + '/' + IntToStr(g_MySelf.m_Abil.MaxWeight));
            //PomiTextOut (dsurface, SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 260)){660}, SCREENHEIGHT - 24, IntToStr(g_MySelf.m_Abil.MaxWeight));
         end;
      end;
      //PomiTextOut (dsurface, SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 355)){755}, SCREENHEIGHT - 15, IntToStr(g_nMyHungryState));
      //饥饿程度
      if g_nMyHungryState in [1..4] then begin
        d := g_WMainImages.Images[16 + g_nMyHungryState-1];
        if d <> nil then begin
          dsurface.Draw (SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 354)){754}, 553, d.ClientRect, d, TRUE);
        end;

      end;

   end;

   //显示聊天框文字
   sx := 208;
   sy := SCREENHEIGHT - 130;
   with DScreen do begin
      SetBkMode (dsurface.Canvas.Handle, OPAQUE);
      for i := ChatBoardTop to ChatBoardTop + VIEWCHATLINE-1 do begin
         if i > ChatStrs.Count-1 then break;
         fcolor := integer(ChatStrs.Objects[i]);
         bcolor := integer(ChatBks[i]);
         dsurface.Canvas.Font.Color := fcolor;
         dsurface.Canvas.Brush.Color := bcolor;
         dsurface.Canvas.TextOut (sx, sy+(i-ChatBoardTop)*12, ChatStrs.Strings[i]);
      end;
   end;
   dsurface.Canvas.Release;

end;




{--------------------------------------------------------------}
//判断底部面板上的一点是否透明


procedure TFrmDlg.DBottomInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
var
   d: TDirectDrawSurface;
begin
{$IF SWH = SWH800}
   d := g_WMainImages.Images[BOTTOMBOARD800];
{$ELSEIF SWH = SWH1024}
   d := g_WMainImages.Images[BOTTOMBOARD1024];
{$IFEND}
   if d <> nil then begin
      if d.Pixels[X, Y] > 0 then IsRealArea := TRUE
      else IsRealArea := FALSE;
   end;
end;

procedure TFrmDlg.DMyStateDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDButton;
   dd: TDirectDrawSurface;
begin
   if Sender is TDButton then begin
      d := TDButton(Sender);
      if d.Downed then begin
         dd := d.WLib.Images[d.FaceIndex];
         if dd <> nil then
            dsurface.Draw (d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, TRUE);
      end;
   end;
end;

//弊缝, 背券, 甘 滚瓢
procedure TFrmDlg.DBotGroupDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDButton;
   dd: TDirectDrawSurface;
begin
   if Sender is TDButton then begin
      d := TDButton(Sender);
      if not d.Downed then begin
         dd := d.WLib.Images[d.FaceIndex];
         if dd <> nil then
            dsurface.Draw (d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, TRUE);
      end else begin
         dd := d.WLib.Images[d.FaceIndex+1];
         if dd <> nil then
            dsurface.Draw (d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, TRUE);
      end;
   end;
end;

procedure TFrmDlg.DBotPlusAbilDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDButton;
   dd: TDirectDrawSurface;
begin
   if Sender is TDButton then begin
      d := TDButton(Sender);
      if not d.Downed then begin
         if (BlinkCount mod 2 = 0) and (not DAdjustAbility.Visible) then dd := d.WLib.Images[d.FaceIndex]
         else dd := d.WLib.Images[d.FaceIndex + 2];
         if dd <> nil then
            dsurface.Draw (d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, TRUE);
      end else begin
         dd := d.WLib.Images[d.FaceIndex+1];
         if dd <> nil then
            dsurface.Draw (d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, TRUE);
      end;

      if GetTickCount - BlinkTime >= 500 then begin
         BlinkTime := GetTickCount;
         Inc (BlinkCount);
         if BlinkCount >= 10 then BlinkCount := 0;
      end;
   end;
end;



procedure TFrmDlg.DMyStateClick(Sender: TObject; X, Y: Integer);
begin
   if Sender = DMyState then begin
      StatePage := 0;
      OpenMyStatus;
   end;
   if Sender = DMyBag then OpenItemBag;
   if Sender = DMyMagic then begin
      StatePage := 3;
      OpenMyStatus;
   end;
   if Sender = DOption then DOptionClick;
end;

procedure TFrmDlg.DOptionClick();
begin
  g_boSound := not g_boSound;
  if g_boSound then begin
    DScreen.AddChatBoardString ('[音乐打开]',clWhite, clBlack);
  end else begin
    DScreen.AddChatBoardString ('[音乐关闭]',clWhite, clBlack);
  end;
end;







{------------------------------------------------------------------------}

// 骇飘

{------------------------------------------------------------------------}


procedure TFrmDlg.DBelt1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   idx: integer;
   d: TDirectDrawSurface;
begin
   with Sender as TDButton do begin
      idx := Tag;
      if idx in [0..5] then begin
         if g_ItemArr[idx].S.Name <> '' then begin
            d := g_WBagItemImages.Images[g_ItemArr[idx].S.Looks];
            if d <> nil then
               dsurface.Draw (SurfaceX(Left+(Width-d.Width) div 2), SurfaceY(Top+(Height-d.Height) div 2), d.ClientRect, d, TRUE);
         end;
      end;
      PomiTextOut (dsurface, SurfaceX(Left+13), SurfaceY(Top+19), IntToStr(idx+1));
   end;
end;

procedure TFrmDlg.DBelt1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
   idx: integer;  
begin
   idx := TDButton(Sender).Tag;
   if idx in [0..5] then begin
      if g_ItemArr[idx].S.Name <> '' then begin
         g_MouseItem := g_ItemArr[idx];
      end;
   end;
end;

procedure TFrmDlg.DBelt1Click(Sender: TObject; X, Y: Integer);
var
   idx: integer;
   temp: TClientItem;
begin
   idx := TDButton(Sender).Tag;
   if idx in [0..5] then begin
      if not g_boItemMoving then begin
         if g_ItemArr[idx].S.Name <> '' then begin
            ItemClickSound (g_ItemArr[idx].S);
            g_boItemMoving := TRUE;
            g_MovingItem.Index := idx;
            g_MovingItem.Item := g_ItemArr[idx];
            g_ItemArr[idx].S.Name := '';
         end;
      end else begin
         if (g_MovingItem.Index = -97) or (g_MovingItem.Index = -98) then exit;
         if g_MovingItem.Item.S.StdMode <= 3 then begin //器记,澜侥,胶农费
            //ItemClickSound (MovingItem.Item.S.StdMode);
            if g_ItemArr[idx].S.Name <> '' then begin
               temp := g_ItemArr[idx];
               g_ItemArr[idx] := g_MovingItem.Item;
               g_MovingItem.Index := idx;
               g_MovingItem.Item := temp
            end else begin
               g_ItemArr[idx] := g_MovingItem.Item;
               g_MovingItem.Item.S.name := '';
               g_boItemMoving := FALSE;
            end;
         end;
      end;
   end;
end;

procedure TFrmDlg.DBelt1DblClick(Sender: TObject);
var
   idx: integer;
begin
   idx := TDButton(Sender).Tag;
   if idx in [0..5] then begin
      if g_ItemArr[idx].S.Name <> '' then begin
         if (g_ItemArr[idx].S.StdMode <= 4) or (g_ItemArr[idx].S.StdMode = 31) then begin //荤侩且 荐 乐绰 酒捞袍
            FrmMain.EatItem (idx);
         end;
      end else begin
         if g_boItemMoving and (g_MovingItem.Index = idx) and
           (g_MovingItem.Item.S.StdMode <= 4) or (g_MovingItem.Item.S.StdMode = 31)
         then begin
            FrmMain.EatItem (-1);
         end;
      end;
   end;
end;






{----------------------------------------------------------}

//DB相关名字

{----------------------------------------------------------}



procedure TFrmDlg.GetMouseItemInfo (var iname, line1, line2, line3: string; var useable: boolean);
   function GetDuraStr (dura, maxdura: integer): string;
   begin
      if not BoNoDisplayMaxDura then
         Result := IntToStr(Round(dura/1000)) + '/' + IntToStr(Round(maxdura/1000))
      else
         Result := IntToStr(Round(dura/1000));
   end;
   function GetDura100Str (dura, maxdura: integer): string;
   begin
      if not BoNoDisplayMaxDura then
         Result := IntToStr(Round(dura/100)) + '/' + IntToStr(Round(maxdura/100))
      else
         Result := IntToStr(Round(dura/100));
   end;
var
  sWgt:String;
begin
   if g_MySelf = nil then exit;
   iname := ''; line1 := ''; line2 := ''; line3 := '';
   useable := TRUE;

   if g_MouseItem.S.Name <> '' then begin
      iname := g_MouseItem.S.Name + ' ';
      sWgt := ' 重量:';
      case g_MouseItem.S.StdMode of
         {0: begin //药品

               if g_MouseItem.S.AC > 0 then
                  line1 := '+' + IntToStr(g_MouseItem.S.AC) + '生命值';
               if g_MouseItem.S.MAC > 0 then
                  line1 := line1 + '+' + IntToStr(g_MouseItem.S.MAC) + '魔法值';
               line1 := line1 + sWgt + IntToStr(g_MouseItem.S.Weight);
            end;
         1..3:
            begin
               line1 := line1 + sWgt +  IntToStr(g_MouseItem.S.Weight);
            end;  }
                     0: begin
              line1 := line1 + sWgt + IntToStr(g_MouseItem.S.Weight);

              case g_MouseItem.S.Shape of
              0: begin
                if (g_MouseItem.S.AC > 0) and (g_MouseItem.S.MAC = 0) then
                  line2 := '恢复 ' + IntToStr(g_MouseItem.S.AC) + '生命值'
                else if (g_MouseItem.S.MAC > 0) and (g_MouseItem.S.AC = 0) then
                  line2 := '恢复 ' + IntToStr(g_MouseItem.S.MAC) + '魔法值'
                else
                  line2 := '恢复 ' + IntToStr(g_MouseItem.S.AC) + '生命值 和 ' + IntToStr(g_MouseItem.S.MAC) + '魔法值';
              end;
              1: begin
                if (g_MouseItem.S.AC > 0) and (g_MouseItem.S.MAC = 0) then
                  line2 := '立即恢复 ' + IntToStr(g_MouseItem.S.AC) + '生命值'
                else if (g_MouseItem.S.MAC > 0) and (g_MouseItem.S.AC = 0) then
                  line2 := '立即恢复' + IntToStr(g_MouseItem.S.MAC) + '魔法值'
                else
                  line2 := '立即恢复 ' + IntToStr(g_MouseItem.S.AC) + '生命值 和 ' + IntToStr(g_MouseItem.S.MAC) + '魔法值';
              end;
              3: begin
                if (g_MouseItem.S.AC > 0) and (g_MouseItem.S.MAC = 0) then
                  line2 := '立即恢复 ' + IntToStr(g_MouseItem.S.AC) + '%生命值'
                else if (g_MouseItem.S.MAC > 0) and (g_MouseItem.S.AC = 0) then
                  line2 := '立即恢复 ' + IntToStr(g_MouseItem.S.MAC) + '%魔法值'
                else
                  line2 := '立即恢复 ' + IntToStr(g_MouseItem.S.AC) + '%生命值 和 ' + IntToStr(g_MouseItem.S.MAC) + '%魔法值';
              end;
              end;
            end;
         1..3:
            begin
               line1 := line1 + '重量' +  IntToStr(g_MouseItem.S.Weight);
               if (g_MouseItem.S.Shape = 7) and (g_MouseItem.S.StdMode = 3) then begin
             //   line2:= '到期: ' + DateTimeToStr(UnixToDateTime(MakeLong(g_MouseItem.DuraMax,g_MouseItem.dura)));
               end;

               if (g_MouseItem.S.Shape = 13) and (g_MouseItem.S.StdMode = 3) then
                 line2 := '授予用户 ' +inttostr(g_MouseItem.S.DuraMax) +' 点经验值'
            end;
         4:
            begin
               line1 := line1 + sWgt +  IntToStr(g_MouseItem.S.Weight);
               line3 := '需要等级: ' + IntToStr(g_MouseItem.S.DuraMax);
               useable := FALSE;
               case g_MouseItem.S.Shape of
                  0: begin
                        line2 := '武士秘籍';
                        if (g_MySelf.m_btJob = 0) and (g_MySelf.m_Abil.Level >= g_MouseItem.S.DuraMax) then
                           useable := TRUE;
                     end;
                  1: begin
                        line2 := '法师秘籍';
                        if (g_MySelf.m_btJob = 1) and (g_MySelf.m_Abil.Level >= g_MouseItem.S.DuraMax) then
                           useable := TRUE;
                     end;
                  2: begin
                        line2 := '道士秘籍';
                        if (g_MySelf.m_btJob = 2) and (g_MySelf.m_Abil.Level >= g_MouseItem.S.DuraMax) then
                           useable := TRUE;
                     end;
               end;
            end;
         5..6: //武器
            begin
               useable := FALSE;
               if g_MouseItem.S.Reserved and $01 <> 0 then
                  iname := '(*)' + iname;

               line1 := line1 + sWgt + IntToStr(g_MouseItem.S.Weight) +
                        ' 持久力:'+ GetDuraStr(g_MouseItem.Dura, g_MouseItem.DuraMax);
               if g_MouseItem.S.DC > 0 then
                  line2 := '攻击:' + IntToStr(LoWord(g_MouseItem.S.DC)) + '-' + IntToStr(HiWord(g_MouseItem.S.DC)) + ' ';
               if g_MouseItem.S.MC > 0 then
                  line2 := line2 + '魔法:' + IntToStr(LoWord(g_MouseItem.S.MC)) + '-' + IntToStr(HiWord(g_MouseItem.S.MC)) + ' ';
               if g_MouseItem.S.SC > 0 then
                  line2 := line2 + '道术:' + IntToStr(LoWord(g_MouseItem.S.SC)) + '-' + IntToStr(HiWord(g_MouseItem.S.SC)) + ' ';

               if (g_MouseItem.S.Source <= -1) and (g_MouseItem.S.Source >= -50) then
                  line2 := line2 + '强度:+' + IntToStr(-g_MouseItem.S.Source) + ' ';
               if (g_MouseItem.S.Source <= -51) and (g_MouseItem.S.Source >= -100) then
                  line2 := line2 + '神圣:-' + IntToStr(-g_MouseItem.S.Source - 50) + ' ';

               if HiWord(g_MouseItem.S.AC) > 0 then
                  line3 := line3 + '准确:+' + IntToStr(HiWord(g_MouseItem.S.AC)) + ' ';
               if HiWord(g_MouseItem.S.MAC) > 0 then begin
                  if HiWord(g_MouseItem.S.MAC) > 10 then
                     line3 := line3 + '攻击速度:+' + IntToStr(HiWord(g_MouseItem.S.MAC)-10) + ' '
                  else
                     line3 := line3 + '攻击速度:-' + IntToStr(HiWord(g_MouseItem.S.MAC)) + ' ';
               end;
               if LoWord(g_MouseItem.S.AC) > 0 then
                  line3 := line3 + '幸运:+' + IntToStr(LoWord(g_MouseItem.S.AC)) + ' ';
               if LoWord(g_MouseItem.S.MAC) > 0 then
                  line3 := line3 + '诅咒:+' + IntToStr(LoWord(g_MouseItem.S.MAC)) + ' ';
               case g_MouseItem.S.Need of
                 {
(10)Stock 是否为库存品
(11)Need表示限制种类：
0  为等级限制
1  为攻击限制
2  为魔法限制
3  为道术限制
               }
                  0: begin
                        if g_MySelf.m_Abil.Level >= g_MouseItem.S.NeedLevel then
                           useable := TRUE;
                        line3 := line3 + '需要等级: ' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  1: begin
                        if HiWord (g_MySelf.m_Abil.DC) >= g_MouseItem.S.NeedLevel then
                           useable := TRUE;
                        line3 := line3 + '需要攻击力: ' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  2: begin
                        if HiWord(g_MySelf.m_Abil.MC) >= g_MouseItem.S.NeedLevel then
                           useable := TRUE;
                        line3 := line3 + '需要魔法力: ' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  3: begin
                        if HiWord (g_MySelf.m_Abil.SC) >= g_MouseItem.S.NeedLevel then
                           useable := TRUE;
                        line3 := line3 + '需要精神力: ' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  4: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生等级' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  40: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&等级' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  41: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&攻击力' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  42: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&魔法力' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  43: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&道术' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  44: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&声望点' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  5: begin
                        useable := TRUE;
                        line3 := line3 + '所需声望点' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  6: begin
                        useable := TRUE;
                        line3 := line3 + '行会成员专用';
                     end;
                  60: begin
                        useable := TRUE;
                        line3 := line3 + '行会掌门专用';
                     end;
                  7: begin
                        useable := TRUE;
                        line3 := line3 + '沙城成员专用';
                     end;
                  70: begin
                        useable := TRUE;
                        line3 := line3 + '沙城城主专用';
                     end;
                  8: begin
                        useable := TRUE;
                        line3 := line3 + '会员专用';
                     end;
                  81: begin
                        useable := TRUE;
                        line3 := line3 + '会员类型 =' + IntToStr(LoWord(g_MouseItem.S.NeedLevel)) + '会员等级 >=' + IntToStr(HiWord(g_MouseItem.S.NeedLevel));
                     end;
                  82: begin
                        useable := TRUE;
                        line3 := line3 + '会员类型 >=' + IntToStr(LoWord(g_MouseItem.S.NeedLevel)) + '会员等级 >=' + IntToStr(HiWord(g_MouseItem.S.NeedLevel));
                     end;
               end;
            end;
         10, 11:  //男衣服, 女衣服
            begin
               useable := FALSE;
               line1 := line1 + sWgt + IntToStr(g_MouseItem.S.Weight) +
                        ' 持久力:'+ GetDuraStr(g_MouseItem.Dura, g_MouseItem.DuraMax);
               //line1 := line1 + '重量' + IntToStr(MouseItem.S.Weight) +
               //      ' 持久'+ IntToStr(Round(MouseItem.Dura/1000)) + '/' + IntToStr(Round(MouseItem.DuraMax/1000));
               if g_MouseItem.S.AC > 0 then
                  line2 := '防御:' + IntToStr(LoWord(g_MouseItem.S.AC)) + '-' + IntToStr(HiWord(g_MouseItem.S.AC)) + ' ';
               if g_MouseItem.S.MAC > 0 then
                  line2 := line2 + '魔御:' + IntToStr(LoWord(g_MouseItem.S.MAC)) + '-' + IntToStr(HiWord(g_MouseItem.S.MAC)) + ' ';
               if g_MouseItem.S.DC > 0 then
                  line2 := line2 + '攻击:' + IntToStr(LoWord(g_MouseItem.S.DC)) + '-' + IntToStr(HiWord(g_MouseItem.S.DC)) + ' ';
               if g_MouseItem.S.MC > 0 then
                  line2 := line2 + '魔法:' + IntToStr(LoWord(g_MouseItem.S.MC)) + '-' + IntToStr(HiWord(g_MouseItem.S.MC)) + ' ';
               if g_MouseItem.S.SC > 0 then
                  line2 := line2 + '道术:' + IntToStr(LoWord(g_MouseItem.S.SC)) + '-' + IntToStr(HiWord(g_MouseItem.S.SC));

               if LoByte(g_MouseItem.S.Source) > 0 then
                  line3 := line3 + '幸运:+' + IntToStr(LoByte(g_MouseItem.S.Source)) + ' ';
               if HiByte(g_MouseItem.S.Source) > 0 then
                  line3 := line3 + '诅咒:+' + IntToStr(HiByte(g_MouseItem.S.Source)) + ' ';

               case g_MouseItem.S.Need of
                  0: begin
                        if g_MySelf.m_Abil.Level >= g_MouseItem.S.NeedLevel then
                           useable := TRUE;
                        line3 := line3 + '需要等级: ' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  1: begin
                        if HiWord (g_MySelf.m_Abil.DC) >= g_MouseItem.S.NeedLevel then
                           useable := TRUE;
                        line3 := line3 + '需要攻击力: ' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  2: begin
                        if HiWord (g_MySelf.m_Abil.MC) >= g_MouseItem.S.NeedLevel then
                           useable := TRUE;
                        line3 := line3 + '需要魔法力: ' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  3: begin
                        if HiWord (g_MySelf.m_Abil.SC) >= g_MouseItem.S.NeedLevel then
                           useable := TRUE;
                        line3 := line3 + '需要精神力: ' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  4: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生等级' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  40: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&等级' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  41: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&攻击力' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  42: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&魔法力' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  43: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&道术' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  44: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&声望点' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  5: begin
                        useable := TRUE;
                        line3 := line3 + '所需声望点' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  6: begin
                        useable := TRUE;
                        line3 := line3 + '行会成员专用';
                     end;
                  60: begin
                        useable := TRUE;
                        line3 := line3 + '行会掌门专用';
                     end;
                  7: begin
                        useable := TRUE;
                        line3 := line3 + '沙城成员专用';
                     end;
                  70: begin
                        useable := TRUE;
                        line3 := line3 + '沙城城主专用';
                     end;
                  8: begin
                        useable := TRUE;
                        line3 := line3 + '会员专用';
                     end;
                  81: begin
                        useable := TRUE;
                        line3 := line3 + '会员类型 =' + IntToStr(LoWord(g_MouseItem.S.NeedLevel)) + '会员等级 >=' + IntToStr(HiWord(g_MouseItem.S.NeedLevel));
                     end;
                  82: begin
                        useable := TRUE;
                        line3 := line3 + '会员类型 >=' + IntToStr(LoWord(g_MouseItem.S.NeedLevel)) + '会员等级 >=' + IntToStr(HiWord(g_MouseItem.S.NeedLevel));
                     end;
               end;
            end;
         15,     //头盔,捧备
         19,20,21,  //项链
         22,23,  //戒指
         24,26, //手镯
         51,
         52,62,   //鞋
         53,63,
         54,64:   //腰带
            begin
               useable := FALSE;
               line1 := line1 + sWgt + IntToStr(g_MouseItem.S.Weight) +
                        ' 持久:'+ GetDuraStr(g_MouseItem.Dura, g_MouseItem.DuraMax);

               case g_MouseItem.S.StdMode of
                  19,53: //项链
                     begin
                        if g_MouseItem.S.AC > 0 then
                           line2 := line2 + '魔法躲避:+' + IntToStr(HiWord(g_MouseItem.S.AC)) + '0% ';
                        if LoWord(g_MouseItem.S.MAC) > 0 then line2 := line2 + '诅咒:+' + IntToStr(LoWord(g_MouseItem.S.MAC)) + ' ';
                        if HiWord(g_MouseItem.S.MAC) > 0 then line2 := line2 + '幸运:+' + IntToStr(HiWord(g_MouseItem.S.MAC)) + ' ';
                           //箭磊 钎矫救凳 + IntToStr(Hibyte(MouseItem.S.MAC)) + ' ';
                     end;
                  20, 24,52: //项链 及 手镯: MaxAC -> Hit,  MaxMac -> Speed
                     begin
                        if g_MouseItem.S.AC > 0 then
                           line2 := line2 + '准确:+' + IntToStr(HiWord(g_MouseItem.S.AC)) + ' ';
                        if g_MouseItem.S.MAC > 0 then
                           line2 := line2 + '敏捷:+' + IntToStr(HiWord(g_MouseItem.S.MAC)) + ' ';
                     end;
                  21,54:  //项链
                     begin
                        if HiWord(g_MouseItem.S.AC) > 0 then
                           line2 := line2 + '体力恢复:+' + IntToStr(HiWord(g_MouseItem.S.AC)) + '0% ';
                        if HiWord(g_MouseItem.S.MAC) > 0 then
                           line2 := line2 + '魔法恢复:+' + IntToStr(HiWord(g_MouseItem.S.MAC)) + '0% ';
                        if LoWord(g_MouseItem.S.AC) > 0 then
                           line2 := line2 + '攻击速度:+' + IntToStr(LoWord(g_MouseItem.S.AC)) + ' ';
                        if LoWord(g_MouseItem.S.MAC) > 0 then
                           line2 := line2 + '攻击速度:-' + IntToStr(LoWord(g_MouseItem.S.MAC)) + ' ';
                     end;
                  23:  //戒指
                     begin
                        if HiWord(g_MouseItem.S.AC) > 0 then
                           line2 := line2 + '毒物躲避:+' + IntToStr(HiWord(g_MouseItem.S.AC)) + '0% ';
                        if HiWord(g_MouseItem.S.MAC) > 0 then
                           line2 := line2 + '中毒恢复:+' + IntToStr(HiWord(g_MouseItem.S.MAC)) + '0% ';
                        if LoWord(g_MouseItem.S.AC) > 0 then
                           line2 := line2 + '攻击速度:+' + IntToStr(LoWord(g_MouseItem.S.AC)) + ' ';
                        if LoWord(g_MouseItem.S.MAC) > 0 then
                           line2 := line2 + '攻击速度:-' + IntToStr(LoWord(g_MouseItem.S.MAC)) + ' ';
                     end;
                  62:  //Boots
                     begin
                        if HiWord(g_MouseItem.S.AC) > 0 then
                           line2 := line2 + '手执负重:+' + IntToStr(HiWord(g_MouseItem.S.AC)) + ' ';
                        if HiWord(g_MouseItem.S.MAC) > 0 then
                           line2 := line2 + '装备负重:+' + IntToStr(HiWord(g_MouseItem.S.MAC)) + ' ';
                        if LoWord(g_MouseItem.S.MAC) > 0 then
                           line2 := line2 + '背包负重:+' + IntToStr(LoWord(g_MouseItem.S.MAC)) + ' ';
                     end;
                  63: //Charm
                     begin
                        if LoWord(g_MouseItem.S.AC) > 0 then line2 := line2 + '体力恢复:+' + IntToStr(LoWord(g_MouseItem.S.AC)) + ' ';
                        if HiWord(g_MouseItem.S.AC) > 0 then line2 := line2 + '魔法恢复:+' + IntToStr(HiWord(g_MouseItem.S.AC)) + ' ';
                        if LoWord(g_MouseItem.S.MAC) > 0 then line2 := line2 + '诅咒:+' + IntToStr(LoWord(g_MouseItem.S.MAC)) + ' ';
                        if HiWord(g_MouseItem.S.MAC) > 0 then line2 := line2 + '运气:+' + IntToStr(HiWord(g_MouseItem.S.MAC)) + ' ';
                     end;
                  else
                     begin
                        if g_MouseItem.S.AC > 0 then
                           line2 := line2 + '防御:' + IntToStr(LoWord(g_MouseItem.S.AC)) + '-' + IntToStr(HiWord(g_MouseItem.S.AC)) + ' ';
                        if g_MouseItem.S.MAC > 0 then
                           line2 := line2 + '魔御:' + IntToStr(LoWord(g_MouseItem.S.MAC)) + '-' + IntToStr(HiWord(g_MouseItem.S.MAC)) + ' ';
                     end;
               end;
               if g_MouseItem.S.DC > 0 then
                  line2 := line2 + '攻击:' + IntToStr(LoWord(g_MouseItem.S.DC)) + '-' + IntToStr(HiWord(g_MouseItem.S.DC)) + ' ';
               if g_MouseItem.S.MC > 0 then
                  line2 := line2 + '魔法:' + IntToStr(LoWord(g_MouseItem.S.MC)) + '-' + IntToStr(HiWord(g_MouseItem.S.MC)) + ' ';
               if g_MouseItem.S.SC > 0 then
                  line2 := line2 + '道术:' + IntToStr(LoWord(g_MouseItem.S.SC)) + '-' + IntToStr(HiWord(g_MouseItem.S.SC)) + ' ';

               if (g_MouseItem.S.Source <= -1) and (g_MouseItem.S.Source >= -50) then
                  line2 := line2 + '幸运:+' + IntToStr(-g_MouseItem.S.Source);
               if (g_MouseItem.S.Source <= -51) and (g_MouseItem.S.Source >= -100) then
                  line2 := line2 + '诅咒1:-' + IntToStr(-g_MouseItem.S.Source - 50);

               case g_MouseItem.S.Need of
                  0: begin
                        if g_MySelf.m_Abil.Level >= g_MouseItem.S.NeedLevel then useable := TRUE;
                        line3 := line3 + '需要等级: ' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  1: begin
                        if HiWord(g_MySelf.m_Abil.DC) >= g_MouseItem.S.NeedLevel then
                           useable := TRUE;
                        line3 := line3 + '需要攻击力: ' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  2: begin
                        if HiWord(g_MySelf.m_Abil.MC) >= g_MouseItem.S.NeedLevel then
                           useable := TRUE;
                        line3 := line3 + '需要魔法力: ' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  3: begin
                        if HiWord(g_MySelf.m_Abil.SC) >= g_MouseItem.S.NeedLevel then
                           useable := TRUE;
                        line3 := line3 + '需要精神力: ' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  4: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生等级' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  40: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&等级' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  41: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&攻击力' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  42: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&魔法力' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  43: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&道术' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  44: begin
                        useable := TRUE;
                        line3 := line3 + '所需转生&声望点' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  5: begin
                        useable := TRUE;
                        line3 := line3 + '所需声望点' + IntToStr(g_MouseItem.S.NeedLevel);
                     end;
                  6: begin
                        useable := TRUE;
                        line3 := line3 + '行会成员专用';
                     end;
                  60: begin
                        useable := TRUE;
                        line3 := line3 + '行会掌门专用';
                     end;
                  7: begin
                        useable := TRUE;
                        line3 := line3 + '沙城成员专用';
                     end;
                  70: begin
                        useable := TRUE;
                        line3 := line3 + '沙城城主专用';
                     end;
                  8: begin
                        useable := TRUE;
                        line3 := line3 + '会员专用';
                     end;
                  81: begin
                        useable := TRUE;
                        line3 := line3 + '会员类型 =' + IntToStr(LoWord(g_MouseItem.S.NeedLevel)) + '会员等级 >=' + IntToStr(HiWord(g_MouseItem.S.NeedLevel));
                     end;
                  82: begin
                        useable := TRUE;
                        line3 := line3 + '会员类型 >=' + IntToStr(LoWord(g_MouseItem.S.NeedLevel)) + '会员等级 >=' + IntToStr(HiWord(g_MouseItem.S.NeedLevel));
                     end;
               end;
            end;
         25: //护身符及毒药
            begin
               line1 := line1 + sWgt +  IntToStr(g_MouseItem.S.Weight);
               line2 := '数量:'+ GetDura100Str(g_MouseItem.Dura, g_MouseItem.DuraMax);
            end;
         30: //照明物
            begin
               line1 := line1 + sWgt +  IntToStr(g_MouseItem.S.Weight) + ' 持久:'+ GetDuraStr(g_MouseItem.Dura, g_MouseItem.DuraMax);
            end;
         40: //肉
            begin
               line1 := line1 + sWgt +  IntToStr(g_MouseItem.S.Weight) + ' 品质:'+ GetDuraStr(g_MouseItem.Dura, g_MouseItem.DuraMax);
            end;
         42: //药材
            begin
               line1 := line1 + sWgt +  IntToStr(g_MouseItem.S.Weight) + ' 合成物品';
            end;
         43: //矿石
            begin
               line1 := line1 + sWgt +  IntToStr(g_MouseItem.S.Weight) + ' 纯度:'+ IntToStr(Round(g_MouseItem.Dura/1000));
            end;
         else begin
               line1 := line1 + sWgt +  IntToStr(g_MouseItem.S.Weight);
            end;
      end;
   end;
end;


procedure TFrmDlg.DItemBagDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d0, d1, d2, d3: string;
   n: integer;
   useable: Boolean;
   d: TDirectDrawSurface;
begin
   if g_MySelf = nil then exit;
   with DItemBag do begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);

      GetMouseItemInfo (d0, d1, d2, d3, useable);
      with dsurface.Canvas do begin
         SetBkMode (Handle, TRANSPARENT);
         Font.Color := clWhite;
         TextOut (SurfaceX(Left+50), SurfaceY(Top+232), GetGoldStr(g_MySelf.m_nGold)); //钱数字位子
         if d0 <> '' then begin
            n := TextWidth (d0);
            Font.Color := clYellow;
            TextOut (SurfaceX(Left+70{70}), SurfaceY(Top+215{215}), d0);
            Font.Color := clWhite;
            TextOut (SurfaceX(Left+70{70}) + n, SurfaceY(Top+215{215}), d1);
            TextOut (SurfaceX(Left+70{70}), SurfaceY(Top+215{215}+14), d2);
            if not useable then
               Font.Color := clRed;
            TextOut (SurfaceX(Left+70{70}), SurfaceY(Top+215{215}+14*2), d3);
         end;
         Release;
      end;
   end;
end;


procedure TFrmDlg.DRepairItemInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
begin
   if (X >= 0) and (Y >= 0) and (X <= DRepairItem.Width) and
      (Y <= DRepairItem.Height) then
         IsRealArea := TRUE
   else IsRealArea := FALSE;
end;

procedure TFrmDlg.DRepairItemDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   with DRepairItem do begin
      d := WLib.Images[FaceIndex];
      if DRepairItem.Downed and (d <> nil) then
         dsurface.Draw (SurfaceX(254), SurfaceY(183), d.ClientRect, d, TRUE);
   end;
end;

procedure TFrmDlg.DCloseBagDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   with DCloseBag do begin
      if DCloseBag.Downed then begin
         d := WLib.Images[FaceIndex];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end;
   end;
end;

procedure TFrmDlg.DCloseBagClick(Sender: TObject; X, Y: Integer);
begin
   DItemBag.Visible := FALSE;
end;

procedure TFrmDlg.DItemGridGridMouseMove(Sender: TObject; ACol,
  ARow: Integer; Shift: TShiftState);
var
   idx: integer;
   temp: TClientItem;
   iname, d1, d2, d3: string;
   useable: Boolean;
   hcolor: TColor;
begin
   if ssRight in Shift then begin
      if g_boItemMoving then
         DItemGridGridSelect (self, ACol, ARow, Shift);
   end else begin
      idx := ACol + ARow * DItemGrid.ColCount + 6{骇飘傍埃};
      if idx in [6..MAXBAGITEM-1] then begin
         g_MouseItem := g_ItemArr[idx];
    { }    GetMouseItemInfo (iname, d1, d2, d3, useable);
         if iname <> '' then begin
            if useable then hcolor := clWhite
            else hcolor := clRed;
            with DItemGrid do
               DScreen.ShowHint (SurfaceX(Left + ACol*ColWidth),
                                 SurfaceY(Top + (ARow+1)*RowHeight),
                                 iname + d1 + '\' + d2 + '\' + d3, hcolor, FALSE);
         end;
         g_MouseItem.S.Name := ''; //本代码是包嚷显示字体的
      end;
   end;
end;

procedure TFrmDlg.DItemGridGridSelect(Sender: TObject; ACol, ARow: Integer;
  Shift: TShiftState);
var
   idx, mi: integer;
   temp: TClientItem;
begin
   idx := ACol + ARow * DItemGrid.ColCount + 6{骇飘傍埃};
   if idx in [6..MAXBAGITEM-1] then begin
      if not g_boItemMoving then begin
         if g_ItemArr[idx].S.Name <> '' then begin
            g_boItemMoving := TRUE;
            g_MovingItem.Index := idx;
            g_MovingItem.Item := g_ItemArr[idx];
            g_ItemArr[idx].S.Name := '';
            ItemClickSound (g_ItemArr[idx].S);
         end;
      end else begin
        // ItemClickSound (MovingItem.Item.S.StdMode);
         mi := g_MovingItem.Index;
         if (mi = -97) or (mi = -98) then exit; //捣...
         if (mi < 0) and (mi >= -13 {-9}) then begin  //-99: Sell芒俊辑 啊规栏肺
            //惑怕芒俊辑 啊规栏肺
            g_WaitingUseItem := g_MovingItem;
            FrmMain.SendTakeOffItem (-(g_MovingItem.Index+1), g_MovingItem.Item.MakeIndex, g_MovingItem.Item.S.Name);
            g_MovingItem.Item.S.name := '';
            g_boItemMoving := FALSE;
         end else begin
            if (mi <= -20) and (mi > -30) then
               DealItemReturnBag (g_MovingItem.Item);
            if g_ItemArr[idx].S.Name <> '' then begin
               temp := g_ItemArr[idx];
               g_ItemArr[idx] := g_MovingItem.Item;
               g_MovingItem.Index := idx;
               g_MovingItem.Item := temp
            end else begin
               g_ItemArr[idx] := g_MovingItem.Item;
               g_MovingItem.Item.S.name := '';
               g_boItemMoving := FALSE;
            end;
         end;
      end;
   end;
   ArrangeItemBag;
end;

procedure TFrmDlg.DItemGridDblClick(Sender: TObject);
var
   idx, i: integer;
   keyvalue: TKeyBoardState;
   cu: TClientItem;
begin
   idx := DItemGrid.Col + DItemGrid.Row * DItemGrid.ColCount + 6;
   if idx in [6..MAXBAGITEM-1] then begin
      if g_ItemArr[idx].S.Name <> '' then begin
         FillChar(keyvalue, sizeof(TKeyboardState), #0);
         GetKeyboardState (keyvalue);
         if keyvalue[VK_CONTROL] = $80 then begin
            //骇飘芒栏肺 颗辫
            cu := g_ItemArr[idx];
            g_ItemArr[idx].S.Name := '';
            AddItemBag (cu);
         end else
            if (g_ItemArr[idx].S.StdMode <= 4) or (g_ItemArr[idx].S.StdMode = 31) then begin //数量且 荐 乐绰 酒捞袍
               FrmMain.EatItem (idx);
            end;
      end else begin
         if g_boItemMoving and (g_MovingItem.Item.S.Name <> '') then begin
            FillChar(keyvalue, sizeof(TKeyboardState), #0);
            GetKeyboardState (keyvalue);
            if keyvalue[VK_CONTROL] = $80 then begin
               //骇飘芒栏肺 颗辫
               cu := g_MovingItem.Item;
               g_MovingItem.Item.S.Name := '';
               g_boItemMoving := FALSE;
               AddItemBag (cu);
            end else
               if (g_MovingItem.Index = idx) and
                  (g_MovingItem.Item.S.StdMode <= 4) or (g_ItemArr[idx].S.StdMode = 31)
               then begin
                  FrmMain.EatItem (-1);
               end;
         end;
      end;
   end;
end;

procedure TFrmDlg.DItemGridGridPaint(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
var
   idx: integer;
   d: TDirectDrawSurface;
begin
   idx := ACol + ARow * DItemGrid.ColCount + 6;
   if idx in [6..MAXBAGITEM-1] then begin
      if g_ItemArr[idx].S.Name <> '' then begin
         d := g_WBagItemImages.Images[g_ItemArr[idx].S.Looks];
         if d <> nil then
            with DItemGrid do
               dsurface.Draw (SurfaceX(Rect.Left + (ColWidth - d.Width) div 2 - 1),
                              SurfaceY(Rect.Top + (RowHeight - d.Height) div 2 + 1),
                              d.ClientRect,
                              d, TRUE);
      end;
   end;
end;

procedure TFrmDlg.DGoldClick(Sender: TObject; X, Y: Integer);
begin
   if g_MySelf = nil then exit;
   if not g_boItemMoving then begin
      if g_MySelf.m_nGold > 0 then begin
         PlaySound (s_money);
         g_boItemMoving := TRUE;
         g_MovingItem.Index := -98; //捣
         g_MovingItem.Item.S.Name := g_sGoldName{'金币'};
      end;
   end else begin
      if (g_MovingItem.Index = -97) or (g_MovingItem.Index = -98) then begin //捣父..
         g_boItemMoving := FALSE;
         g_MovingItem.Item.S.Name := '';
         if g_MovingItem.Index = -97 then begin //背券芒俊辑 颗
            DealZeroGold;
         end;
      end;
   end;
   ;
end;






{------------------------------------------------------------------------}

//人物筐相关

{------------------------------------------------------------------------}


procedure TFrmDlg.ShowMDlg (face: integer; mname, msgstr: string);
var
   i: integer;
begin
   DMerchantDlg.Left := 0;  //筐体位置
   DMerchantDlg.Top := 0;
   MerchantFace := face;
   MerchantName := mname;
   MDlgStr := msgstr;
   DMerchantDlg.Visible := TRUE;
   DItemBag.Left := 475;  //包嚷位置
   DItemBag.Top := 0;
   for i:=0 to MDlgPoints.Count-1 do
      Dispose (pTClickPoint (MDlgPoints[i]));
   MDlgPoints.Clear;
   RequireAddPoints := TRUE;
   LastestClickTime := GetTickCount;
end;


procedure TFrmDlg.ResetMenuDlg;
var
   i: integer;
begin
   CloseDSellDlg;
   for i:=0 to g_MenuItemList.Count-1 do  //技何 皋春档 努府绢 窃.
      Dispose(PTClientItem(g_MenuItemList[i]));
   g_MenuItemList.Clear;

   for i:=0 to MenuList.Count-1 do
      Dispose (PTClientGoods(MenuList[i]));
   MenuList.Clear;

   //CurDetailItem := '';
   MenuIndex := -1;
   MenuTopLine := 0;
   BoDetailMenu := FALSE;
   BoStorageMenu := FALSE;
   BoMakeDrugMenu := FALSE;

   DSellDlg.Visible := FALSE;
   DMenuDlg.Visible := FALSE;
end;

procedure TFrmDlg.ShowShopMenuDlg;
begin
   MenuIndex := -1;

   DMerchantDlg.Left := 0;  //扁夯 困摹
   DMerchantDlg.Top := 0;
   DMerchantDlg.Visible := TRUE;

   DSellDlg.Visible := FALSE;

   DMenuDlg.Left := 0;
   DMenuDlg.Top  := 170;     //买 位置
   DMenuDlg.Visible := TRUE;
   MenuTop := 0;

   DItemBag.Left := 475;
   DItemBag.Top := 0;
   DItemBag.Visible := TRUE;

   LastestClickTime := GetTickCount;
end;

procedure TFrmDlg.ShowShopSellDlg;
begin
   DSellDlg.Left := 260;
   DSellDlg.Top := 170;
   DSellDlg.Visible := TRUE; //卖 位置

   DMenuDlg.Visible := FALSE;

   DItemBag.Left := 475;
   DItemBag.Top := 0;
   DItemBag.Visible := TRUE;

   LastestClickTime := GetTickCount;
   g_sSellPriceStr := '';
end;

procedure TFrmDlg.CloseMDlg;
var
   i: integer;
begin
   MDlgStr := '';
   DMerchantDlg.Visible := FALSE;
   for i:=0 to MDlgPoints.Count-1 do
      Dispose (PTClickPoint (MDlgPoints[i]));
   MDlgPoints.Clear;
   //包嚷位置
   DItemBag.Left := 0;
   DItemBag.Top := 0;
   DMenuDlg.Visible := FALSE;
   CloseDSellDlg;
end;

procedure TFrmDlg.CloseDSellDlg;
begin
   DSellDlg.Visible := FALSE;
   if g_SellDlgItem.S.Name <> '' then
      AddItemBag (g_SellDlgItem);
   g_SellDlgItem.S.Name := '';
end;


//筐体相关

procedure TFrmDlg.DMerchantDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
   str, data, fdata, cmdstr, cmdmsg, cmdparam: string;
   lx, ly, sx: integer;
   drawcenter: Boolean;
   pcp: PTClickPoint;
begin
   with Sender as TDWindow do begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      SetBkMode (dsurface.Canvas.Handle, TRANSPARENT);
      lx := 30;    //对话筐字体位置
      ly := 30;
      str := MDlgStr;
      drawcenter := FALSE;
      while TRUE do begin
         if str = '' then break;
         str := GetValidStr3 (str, data, ['\']);
         if data <> '' then begin
            sx := 0;
            fdata := '';
            while (pos('<', data) > 0) and (pos('>', data) > 0) and (data <> '') do begin
               if data[1] <> '<' then begin
                  data := '<' + GetValidStr3 (data, fdata, ['<']);
               end;
               data := ArrestStringEx (data, '<', '>', cmdstr);

               //fdata + cmdstr + data
               if cmdstr <> '' then begin
                  if Uppercase(cmdstr) = 'C' then begin
                     drawcenter := TRUE;
                     continue;
                  end;
                  if UpperCase(cmdstr) = '/C' then begin
                     drawcenter := FALSE;
                     continue;
                  end;
                  cmdparam := GetValidStr3 (cmdstr, cmdstr, ['/']); //cmdparam : 努腐 登菌阑 锭 静烙
               end else begin
                  DMenuDlg.Visible := FALSE;
                  DSellDlg.Visible := FALSE;
               end;

               if fdata <> '' then begin
                  BoldTextOut (dsurface, SurfaceX(Left+lx+sx), SurfaceY(Top+ly), clWhite, clBlack, fdata);
                  sx := sx + dsurface.Canvas.TextWidth(fdata);
               end;
               if cmdstr <> '' then begin
                  if RequireAddPoints then begin
                     new (pcp);
                     pcp.rc := Rect (lx+sx, ly, lx+sx + dsurface.Canvas.TextWidth(cmdstr), ly + 14);
                     pcp.RStr := cmdparam;
                     MDlgPoints.Add (pcp);
                  end;
                  dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style + [fsUnderline];
                  if SelectMenuStr = cmdparam then
                     BoldTextOut (dsurface, SurfaceX(Left+lx+sx), SurfaceY(Top+ly), clRed, clBlack, cmdstr)
                  else BoldTextOut (dsurface, SurfaceX(Left+lx+sx), SurfaceY(Top+ly), clYellow, clBlack, cmdstr);
                  sx := sx + dsurface.Canvas.TextWidth(cmdstr);
                  dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style - [fsUnderline];
               end;
            end;
            if data <> '' then
               BoldTextOut (dsurface, SurfaceX(Left+lx+sx), SurfaceY(Top+ly), clWhite, clBlack, data);
         end;
         ly := ly + 16;  //数值各开地方
      end;
      dsurface.Canvas.Release;
      RequireAddPoints := FALSE;
   end;

end;

procedure TFrmDlg.DMerchantDlgCloseClick(Sender: TObject; X, Y: Integer);
begin
   CloseMDlg;
end;

procedure TFrmDlg.DMenuDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
  function SX(x: integer): integer;
  begin
      Result := DMenuDlg.SurfaceX (DMenuDlg.Left + x);
  end;
  function SY(y: integer): integer;
  begin
      Result := DMenuDlg.SurfaceY (DMenuDlg.Top + y);
  end;
var
   i, lh, k, m, menuline: integer;
   d: TDirectDrawSurface;
   pg: PTClientGoods;
   str: string;
begin
   with dsurface.Canvas do begin
      with DMenuDlg do begin
         d := DMenuDlg.WLib.Images[FaceIndex];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end;

      SetBkMode (dsurface.Canvas.Handle, TRANSPARENT);
      SetBkMode (Handle, TRANSPARENT);
      //title
      Font.Color := clWhite;
      if not BoStorageMenu then begin
         TextOut (SX(27),  SY(31), '物品列表');
         TextOut (SX(164), SY(31), '价格');
         TextOut (SX(262), SY(31), '持久力');
         lh := LISTLINEHEIGHT;
         menuline := _MIN(MAXMENU, MenuList.Count-MenuTop);
         //惑前 府胶飘
         for i:=MenuTop to MenuTop+menuline-1 do begin
            m := i-MenuTop;
            if i = MenuIndex then begin
               Font.Color := clRed;
               TextOut (SX(25),  SY(50 + m*lh), char(7));
            end else Font.Color := clWhite;
            pg := PTClientGoods (MenuList[i]);
            TextOut (SX(38),  SY(50 + m*lh), pg.Name);
            if pg.SubMenu >= 1 then
               TextOut (SX(137), SY(50 + m*lh), #31);
            TextOut (SX(170), SY(50 + m*lh), IntToStr(pg.Price) + ' ' + g_sGoldName{金币'});
            str := '';
            if pg.Grade = -1 then str := '-'
            else TextOut (SX(265), SY(50 + m*lh), IntToStr(pg.Grade));
           { else for k:=0 to pg.Grade-1 do
               str := str + '*';
            if Length(str) >= 4 then begin
               Font.Color := clYellow;
               TextOut (SX(245), SY(32 + m*lh), str);
            end else
               TextOut (SX(245), SY(32 + m*lh), str);}
         end;
      end else begin
         TextOut (SX(27),  SY(31), '保管物品');
         TextOut (SX(164), SY(31), '持久力.');
         TextOut (SX(262), SY(31), '');
         lh := LISTLINEHEIGHT;
         menuline := _MIN(MAXMENU, MenuList.Count-MenuTop);
         //==
         for i:=MenuTop to MenuTop+menuline-1 do begin
            m := i-MenuTop;
            if i = MenuIndex then begin
               Font.Color := clRed;
               TextOut (SX(25),  SY(50 + m*lh), char(7));//方
            end else Font.Color := clWhite;
            pg := PTClientGoods (MenuList[i]);
            TextOut (SX(38),  SY(50 + m*lh), pg.Name);  //物品
            if pg.SubMenu >= 1 then
               TextOut (SX(137), SY(50 + m*lh), #31);
            TextOut (SX(170), SY(50 + m*lh), IntToStr(pg.Stock) + '/' + IntToStr(pg.Grade));   //持久
         end;
      end;
      //TextOut (0, 0, IntToStr(MenuTopLine));

      Release;
   end;
end;

procedure TFrmDlg.DMenuDlgClick(Sender: TObject; X, Y: Integer);
var
   lx, ly, idx: integer;
   iname, d1, d2, d3: string;
   useable: Boolean;
begin
   DScreen.ClearHint;
   lx := DMenuDlg.LocalX (X) - DMenuDlg.Left;
   ly := DMenuDlg.LocalY (Y) - DMenuDlg.Top;
   if (lx >= 14) and (lx <= 279) and (ly >= 32) then begin
      idx := (ly-32) div LISTLINEHEIGHT + MenuTop;
      if idx < MenuList.Count then begin
         PlaySound (s_glass_button_click);
         MenuIndex := idx;
      end;
   end;

   if BoStorageMenu then begin
      if (MenuIndex >= 0) and (MenuIndex < g_SaveItemList.Count) then begin
         g_MouseItem := PTClientItem(g_SaveItemList[MenuIndex])^;
         GetMouseItemInfo (iname, d1, d2, d3, useable);
         if iname <> '' then begin
            lx := 240;
            ly := 32+(MenuIndex-MenuTop) * LISTLINEHEIGHT;
            with Sender as TDButton do
               DScreen.ShowHint (DMenuDlg.SurfaceX(Left + lx),
                                 DMenuDlg.SurfaceY(Top + ly),
                                 iname + d1 + '\' + d2 + '\' + d3, clYellow, FALSE);
         end;
         g_MouseItem.S.Name := '';
      end;
   end else begin
      if (MenuIndex >= 0) and (MenuIndex < g_MenuItemList.Count) and (PTClientGoods (MenuList[MenuIndex]).SubMenu = 0) then begin
         g_MouseItem := PTClientItem(g_MenuItemList[MenuIndex])^;
         BoNoDisplayMaxDura := TRUE;
         GetMouseItemInfo (iname, d1, d2, d3, useable);
         BoNoDisplayMaxDura := FALSE;
         if iname <> '' then begin
            lx := 240;
            ly := 32+(MenuIndex-MenuTop) * LISTLINEHEIGHT;
            with Sender as TDButton do
               DScreen.ShowHint (DMenuDlg.SurfaceX(Left + lx),
                                 DMenuDlg.SurfaceY(Top + ly),
                                 iname + d1 + '\' + d2 + '\' + d3, clYellow, FALSE);
         end;
         g_MouseItem.S.Name := '';
      end;
   end;
end;

procedure TFrmDlg.DMenuDlgMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   with DMenuDlg do
      if (X < SurfaceX(Left+10)) or (X > SurfaceX(Left+Width-20)) or (Y < SurfaceY(Top+30)) or (Y > SurfaceY(Top+Height-50)) then begin
         DScreen.ClearHint;
      end;
end;

procedure TFrmDlg.DMenuBuyClick(Sender: TObject; X, Y: Integer);
var
   pg: PTClientGoods;
begin
   if GetTickCount < LastestClickTime then exit; //努腐阑 磊林 给窍霸 力茄
   if (MenuIndex >= 0) and (MenuIndex < MenuList.Count) then begin
      pg := PTClientGoods (MenuList[MenuIndex]);
      LastestClickTime := GetTickCount + 5000;
      if pg.SubMenu > 0 then begin
         FrmMain.SendGetDetailItem (g_nCurMerchant, 0, pg.Name);
         MenuTopLine := 0;
         CurDetailItem := pg.Name;
      end else begin
         if BoStorageMenu then begin
            FrmMain.SendTakeBackStorageItem (g_nCurMerchant, pg.Price{MakeIndex}, pg.Name);
            exit;
         end;
         if BoMakeDrugMenu then begin
            FrmMain.SendMakeDrugItem (g_nCurMerchant, pg.Name);
            exit;
         end;
         FrmMain.SendBuyItem (g_nCurMerchant, pg.Stock, pg.Name)
      end;
   end;
end;

procedure TFrmDlg.DMenuPrevClick(Sender: TObject; X, Y: Integer);
begin
   if not BoDetailMenu then begin
      if MenuTop > 0 then Dec (MenuTop, MAXMENU-1);
      if MenuTop < 0 then MenuTop := 0;
   end else begin
      if MenuTopLine > 0 then begin
         MenuTopLine := _MAX(0, MenuTopLine-10);
         FrmMain.SendGetDetailItem (g_nCurMerchant, MenuTopLine, CurDetailItem);
      end;
   end;
end;

procedure TFrmDlg.DMenuNextClick(Sender: TObject; X, Y: Integer);
begin
   if not BoDetailMenu then begin
      if MenuTop + MAXMENU < MenuList.Count then Inc (MenuTop, MAXMENU-1);
   end else begin
      MenuTopLine := MenuTopLine + 10;
      FrmMain.SendGetDetailItem (g_nCurMerchant, MenuTopLine, CurDetailItem);
   end;      
end;

procedure TFrmDlg.SoldOutGoods (itemserverindex: integer);
var
   i: integer;
   pg: PTClientGoods;
begin
   for i:=0 to MenuList.Count-1 do begin
      pg := PTClientGoods (MenuList[i]);
      if (pg.Grade >= 0) and (pg.Stock = itemserverindex) then begin
         Dispose (pg);
         MenuList.Delete (i);
         if i < g_MenuItemList.Count then g_MenuItemList.Delete (i);
         if MenuIndex > MenuList.Count-1 then MenuIndex := MenuList.Count-1;
         break;
      end;
   end;
end;

procedure TFrmDlg.DelStorageItem (itemserverindex: integer);
var
   i: integer;
   pg: PTClientGoods;
begin
   for i:=0 to MenuList.Count-1 do begin
      pg := PTClientGoods (MenuList[i]);
      if (pg.Price = itemserverindex) then begin //焊包格废牢版款 Price = ItemServerIndex烙.
         Dispose (pg);
         MenuList.Delete (i);
         if i < g_SaveItemList.Count then g_SaveItemList.Delete (i);
         if MenuIndex > MenuList.Count-1 then MenuIndex := MenuList.Count-1;
         break;
      end;
   end;
end;

procedure TFrmDlg.DMenuCloseClick(Sender: TObject; X, Y: Integer);
begin
   DMenuDlg.Visible := FALSE;
end;

procedure TFrmDlg.DMerchantDlgClick(Sender: TObject; X, Y: Integer);
var
   i, L, T: integer;
   p: PTClickPoint;
begin
   if GetTickCount < LastestClickTime then exit; //努腐阑 磊林 给窍霸 力茄
   L := DMerchantDlg.Left;
   T := DMerchantDlg.Top;
   with DMerchantDlg do
      for i:=0 to MDlgPoints.Count-1 do begin
         p := PTClickPoint (MDlgPoints[i]);
         if (X >= SurfaceX(L + p.rc.Left)) and (X <= SurfaceX(L + p.rc.Right)) and
            (Y >= SurfaceY(T + p.rc.Top)) and (Y <= SurfaceY(T + p.rc.Bottom)) then begin
            PlaySound (s_glass_button_click);
            FrmMain.SendMerchantDlgSelect (g_nCurMerchant, p.RStr);
            LastestClickTime := GetTickCount + 5000; //5檬饶俊 数量 啊瓷
            break;
         end;
      end;
end;

procedure TFrmDlg.DMerchantDlgMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   i, L, T: integer;
   p: PTClickPoint;
begin
   if GetTickCount < LastestClickTime then exit; //努腐阑 磊林 给窍霸 力茄
   SelectMenuStr := '';
   L := DMerchantDlg.Left;
   T := DMerchantDlg.Top;
   with DMerchantDlg do
      for i:=0 to MDlgPoints.Count-1 do begin
         p := PTClickPoint (MDlgPoints[i]);
         if (X >= SurfaceX(L + p.rc.Left)) and (X <= SurfaceX(L + p.rc.Right)) and
            (Y >= SurfaceY(T + p.rc.Top)) and (Y <= SurfaceY(T + p.rc.Bottom)) then begin
            SelectMenuStr := p.RStr;
            break;
         end;
      end;
end;

procedure TFrmDlg.DMerchantDlgMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   SelectMenuStr := '';
end;

procedure TFrmDlg.DSellDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
   actionname: string;
begin
   with DSellDlg do begin
      d := DMenuDlg.WLib.Images[FaceIndex];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);

      with dsurface.Canvas do begin
         SetBkMode (Handle, TRANSPARENT);
         Font.Color := clWhite;
         actionname := '';
         case SpotDlgMode of
            dmSell:   actionname := '价格: ';
            dmRepair: actionname := '修理: ';
            dmStorage: actionname := '保管物品:';
         end;
         TextOut (SurfaceX(Left+28), SurfaceY(Top+31), actionname + g_sSellPriceStr);
         Release;
      end;
   end;
end;

procedure TFrmDlg.DSellDlgCloseClick(Sender: TObject; X, Y: Integer);
begin
   CloseDSellDlg;
end;

procedure TFrmDlg.DSellDlgSpotClick(Sender: TObject; X, Y: Integer);
var
   temp: TClientItem;
begin
   g_sSellPriceStr := '';
   if not g_boItemMoving then begin
      if g_SellDlgItem.S.Name <> '' then begin
         ItemClickSound (g_SellDlgItem.S);
         g_boItemMoving := TRUE;
         g_MovingItem.Index := -99; //sell 芒俊辑 唱咳..
         g_MovingItem.Item := g_SellDlgItem;
         g_SellDlgItem.S.Name := '';
      end;
   end else begin
      if (g_MovingItem.Index = -97) or (g_MovingItem.Index = -98) then exit;
      if (g_MovingItem.Index >= 0) or (g_MovingItem.Index = -99) then begin //啊规,骇飘俊辑 柯巴父
         ItemClickSound (g_MovingItem.Item.S);
         if g_SellDlgItem.S.Name <> '' then begin //磊府俊 乐栏搁
            temp := g_SellDlgItem;
            g_SellDlgItem := g_MovingItem.Item;
            g_MovingItem.Index := -99; //sell 芒俊辑 唱咳..
            g_MovingItem.Item := temp
         end else begin
            g_SellDlgItem := g_MovingItem.Item;
            g_MovingItem.Item.S.name := '';
            g_boItemMoving := FALSE;
         end;
         g_boQueryPrice := TRUE;
         g_dwQueryPriceTime := GetTickCount;
      end;
   end;

end;

procedure TFrmDlg.DSellDlgSpotDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   if g_SellDlgItem.S.Name <> '' then begin
      d := g_WBagItemImages.Images[g_SellDlgItem.S.Looks];
      if d <> nil then
         with DSellDlgSpot do
            dsurface.Draw (SurfaceX(Left + (Width - d.Width) div 2),
                           SurfaceY(Top + (Height - d.Height) div 2),
                           d.ClientRect,
                           d, TRUE);
   end;
end;

procedure TFrmDlg.DSellDlgSpotMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
   g_MouseItem := g_SellDlgItem;
end;

procedure TFrmDlg.DSellDlgOkClick(Sender: TObject; X, Y: Integer);
begin
   if (g_SellDlgItem.S.Name = '') and (g_SellDlgItemSellWait.S.Name = '') then exit;
   if GetTickCount < LastestClickTime then exit; //努腐阑 磊林 给窍霸 力茄
   case SpotDlgMode of
      dmSell: FrmMain.SendSellItem (g_nCurMerchant, g_SellDlgItem.MakeIndex, g_SellDlgItem.S.Name);
      dmRepair: FrmMain.SendRepairItem (g_nCurMerchant, g_SellDlgItem.MakeIndex, g_SellDlgItem.S.Name);
      dmStorage: FrmMain.SendStorageItem (g_nCurMerchant, g_SellDlgItem.MakeIndex, g_SellDlgItem.S.Name);
   end;
   g_SellDlgItemSellWait := g_SellDlgItem;
   g_SellDlgItem.S.Name := '';
   LastestClickTime := GetTickCount + 5000;
   g_sSellPriceStr := '';
end;





{------------------------------------------------------------------------}

//魔法 虐 汲沥 芒 (促捞倔 肺弊)

{------------------------------------------------------------------------}


procedure TFrmDlg.SetMagicKeyDlg (icon: integer; magname: string; var curkey: word);
begin
   MagKeyIcon := icon;
   MagKeyMagName := magname;
   MagKeyCurKey := curkey;


   DKeySelDlg.Left := (SCREENWIDTH - DKeySelDlg.Width) div 2;
   DKeySelDlg.Top  := (SCREENHEIGHT - DKeySelDlg.Height) div 2;
   HideAllControls;
   DKeySelDlg.ShowModal;

   while TRUE do begin
      if not DKeySelDlg.Visible then break;
      //FrmMain.DXTimerTimer (self, 0);
      FrmMain.ProcOnIdle;
      Application.ProcessMessages;
      if Application.Terminated then exit;
   end;

   RestoreHideControls;
   curkey := MagKeyCurKey;
end;

procedure TFrmDlg.DKeySelDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   with DKeySelDlg do begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      //魔法快捷键
      with dsurface.Canvas do begin
         SetBkMode (Handle, TRANSPARENT);
         Font.Color := clSilver;
         TextOut (SurfaceX(Left + 95), SurfaceY(Top + 38), MagKeyMagName + ' 快捷键盘设置为.');
         Release;
      end;
   end;
end;

procedure TFrmDlg.DKsIconDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   with DksIcon do begin
      d := g_WMagIconImages.Images[MagKeyIcon];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
   end;
end;

procedure TFrmDlg.DKsF1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   b: TDButton;
   d: TDirectDrawSurface;
begin
   b := nil;
   case MagKeyCurKey of
      word('1'): b := DKsF1;
      word('2'): b := DKsF2;
      word('3'): b := DKsF3;
      word('4'): b := DKsF4;
      word('5'): b := DKsF5;
      word('6'): b := DKsF6;
      word('7'): b := DKsF7;
      word('8'): b := DKsF8;
     { word('E'): b := DKsConF1;
      word('F'): b := DKsConF2;
      word('G'): b := DKsConF3;
      word('H'): b := DKsConF4;
      word('I'): b := DKsConF5;
      word('J'): b := DKsConF6;
      word('K'): b := DKsConF7;
      word('L'): b := DKsConF8;}
      else b := DKsNone;
   end;
   if b = Sender then begin
      with b do begin
         d := WLib.Images[FaceIndex{+1}];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end;
   end;
   with Sender as TDButton do begin
      if Downed then begin
         d := WLib.Images[FaceIndex];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end;
   end;
end;

procedure TFrmDlg.DKsOkClick(Sender: TObject; X, Y: Integer);
begin
   DKeySelDlg.Visible := FALSE;
end;

procedure TFrmDlg.DKsF1Click(Sender: TObject; X, Y: Integer);
begin
   if Sender = DKsF1 then MagKeyCurKey := integer('1');
   if Sender = DKsF2 then MagKeyCurKey := integer('2');
   if Sender = DKsF3 then MagKeyCurKey := integer('3');
   if Sender = DKsF4 then MagKeyCurKey := integer('4');
   if Sender = DKsF5 then MagKeyCurKey := integer('5');
   if Sender = DKsF6 then MagKeyCurKey := integer('6');
   if Sender = DKsF7 then MagKeyCurKey := integer('7');
   if Sender = DKsF8 then MagKeyCurKey := integer('8');
   {if Sender = DKsConF1 then MagKeyCurKey := integer('E');
   if Sender = DKsConF2 then MagKeyCurKey := integer('F');
   if Sender = DKsConF3 then MagKeyCurKey := integer('G');
   if Sender = DKsConF4 then MagKeyCurKey := integer('H');
   if Sender = DKsConF5 then MagKeyCurKey := integer('I');
   if Sender = DKsConF6 then MagKeyCurKey := integer('J');
   if Sender = DKsConF7 then MagKeyCurKey := integer('K');
   if Sender = DKsConF8 then MagKeyCurKey := integer('L'); }
   if Sender = DKsNone then MagKeyCurKey := 0;
end;



{------------------------------------------------------------------------}

//扁夯芒狼 固聪 滚瓢

{------------------------------------------------------------------------}


procedure TFrmDlg.DBotMiniMapClick(Sender: TObject; X, Y: Integer);
begin
   if not g_boViewMiniMap then begin
      if GetTickCount > g_dwQueryMsgTick then begin
         g_dwQueryMsgTick := GetTickCount + 3000;
         FrmMain.SendWantMiniMap;
         g_nViewMinMapLv:=1;
      end;
   end else begin
     if g_nViewMinMapLv >= 2 then begin
       g_nViewMinMapLv:=0;
       g_boViewMiniMap := FALSE;
     end else Inc(g_nViewMinMapLv);
   end;
end;

procedure TFrmDlg.DBotTradeClick(Sender: TObject; X, Y: Integer);
begin
   if GetTickCount > g_dwQueryMsgTick then begin
      g_dwQueryMsgTick := GetTickCount + 3000;
      FrmMain.SendDealTry;
   end;
end;

procedure TFrmDlg.DBotGuildClick(Sender: TObject; X, Y: Integer);
begin
   if DGuildDlg.Visible then begin
      DGuildDlg.Visible := FALSE;
   end else
      if GetTickCount > g_dwQueryMsgTick then begin
         g_dwQueryMsgTick := GetTickCount + 3000;
         FrmMain.SendGuildDlg;
      end;
end;

procedure TFrmDlg.DBotGroupClick(Sender: TObject; X, Y: Integer);
begin
   ToggleShowGroupDlg;
end;


{------------------------------------------------------------------------}

//弊缝 促捞倔肺弊

{------------------------------------------------------------------------}

procedure TFrmDlg.ToggleShowGroupDlg;
begin
   DGroupDlg.Visible := not DGroupDlg.Visible;
end;

procedure TFrmDlg.DGroupDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
   lx, ly, n: integer;
begin
   with DGroupDlg do begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      if g_GroupMembers.Count > 0 then begin
         with dsurface.Canvas do begin
            SetBkMode (Handle, TRANSPARENT);
            Font.Color := clSilver;
            lx := SurfaceX(28) + Left;
            ly := SurfaceY(80) + Top;
            TextOut (lx, ly, g_GroupMembers[0]);
            for n:=1 to g_GroupMembers.Count-1 do begin
               lx := SurfaceX(28) + Left + ((n-1) mod 2) * 100;
               ly := SurfaceY(80 + 16) + Top + ((n-1) div 2) * 16;
               TextOut (lx, ly, g_GroupMembers[n]);
            end;
            Release;
         end;
      end;
   end;
end;

procedure TFrmDlg.DGrpDlgCloseClick(Sender: TObject; X, Y: Integer);
begin
   DGroupDlg.Visible := FALSE;
end;

procedure TFrmDlg.DGrpAllowGroupDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;  
begin
   with Sender as TDButton do begin
      if Downed then begin
         d := WLib.Images[FaceIndex-1];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end else begin
         if g_boAllowGroup then begin
            d := WLib.Images[FaceIndex];
            if d <> nil then
               dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
         end;
      end;
   end;
end;

procedure TFrmDlg.DGrpAllowGroupClick(Sender: TObject; X, Y: Integer);
begin
   if GetTickCount > g_dwChangeGroupModeTick then begin
      g_boAllowGroup := not g_boAllowGroup;
      g_dwChangeGroupModeTick := GetTickCount + 5000; //timeout 5檬
      FrmMain.SendGroupMode (g_boAllowGroup);
   end;
end;

procedure TFrmDlg.DGrpCreateClick(Sender: TObject; X, Y: Integer);
var
   who: string;
begin
   if (GetTickCount > g_dwChangeGroupModeTick) and (g_GroupMembers.Count = 0) then begin
      DialogSize := 1;
      DMessageDlg ('请输入邀请加入小组的玩家名.', [mbOk, mbAbort]);
      who := Trim (DlgEditText);
      if who <> '' then begin
         g_dwChangeGroupModeTick := GetTickCount + 5000; //timeout 5檬
         FrmMain.SendCreateGroup (Trim (DlgEditText));
      end;
   end;
end;

procedure TFrmDlg.DGrpAddMemClick(Sender: TObject; X, Y: Integer);
var
   who: string;
begin
   if (GetTickCount > g_dwChangeGroupModeTick) and (g_GroupMembers.Count > 0) then begin
      DialogSize := 1;
      DMessageDlg ('键入您想要参加小组的名字 .', [mbOk, mbAbort]);
      who := Trim (DlgEditText);
      if who <> '' then begin
         g_dwChangeGroupModeTick := GetTickCount + 5000; //timeout 5檬
         FrmMain.SendAddGroupMember (Trim (DlgEditText));
      end;
   end;
end;

procedure TFrmDlg.DGrpDelMemClick(Sender: TObject; X, Y: Integer);
var
   who: string;
begin
   if (GetTickCount > g_dwChangeGroupModeTick) and (g_GroupMembers.Count > 0) then begin
      DialogSize := 1;
      DMessageDlg ('键入您想要从小组被删除的名字.', [mbOk, mbAbort]);
      who := Trim (DlgEditText);
      if who <> '' then begin
         g_dwChangeGroupModeTick := GetTickCount + 5000; //timeout 5檬
         FrmMain.SendDelGroupMember (Trim (DlgEditText));
      end;
   end;
end;

procedure TFrmDlg.DBotLogoutClick(Sender: TObject; X, Y: Integer);
begin
               //强行退出
               g_dwLatestStruckTick:=GetTickCount() + 10001;
               g_dwLatestMagicTick:=GetTickCount() + 10001;
               g_dwLatestHitTick:=GetTickCount() + 10001;
               //
   if (GetTickCount - g_dwLatestStruckTick > 10000) and
      (GetTickCount - g_dwLatestMagicTick > 10000) and
      (GetTickCount - g_dwLatestHitTick > 10000) or
      (g_MySelf.m_boDeath) then begin
      FrmMain.AppLogOut;
   end else
      DScreen.AddChatBoardString ('战斗中不能退出游戏..', clYellow, clRed);
end;

procedure TFrmDlg.DBotExitClick(Sender: TObject; X, Y: Integer);
begin
               //强行退出
               g_dwLatestStruckTick:=GetTickCount() + 10001;
               g_dwLatestMagicTick:=GetTickCount() + 10001;
               g_dwLatestHitTick:=GetTickCount() + 10001;
               //
   if (GetTickCount - g_dwLatestStruckTick > 10000) and
      (GetTickCount - g_dwLatestMagicTick > 10000) and
      (GetTickCount - g_dwLatestHitTick > 10000) or
      (g_MySelf.m_boDeath) then begin
      FrmMain.AppExit;
   end else
      DScreen.AddChatBoardString ('战斗中不能退出游戏..', clYellow, clRed);
end;

procedure TFrmDlg.DBotPlusAbilClick(Sender: TObject; X, Y: Integer);
begin
   FrmDlg.OpenAdjustAbility;
end;


{------------------------------------------------------------------------}

//背券 促捞倔肺弊

{------------------------------------------------------------------------}


procedure TFrmDlg.OpenDealDlg;
var
   d: TDirectDrawSurface;
begin
   DDealRemoteDlg.Left := SCREENWIDTH-236-100;
   DDealRemoteDlg.Top := 0;
   DDealDlg.Left := SCREENWIDTH-236-100;
   DDealDlg.Top  := DDealRemoteDlg.Height-15;
   DItemBag.Left := 0; //475;
   DItemBag.Top := 0;
   DItemBag.Visible := TRUE;
   DDealDlg.Visible := TRUE;
   DDealRemoteDlg.Visible := TRUE;

   FillCHar (g_DealItems, sizeof(TClientItem)*10, #0);
   FillCHar (g_DealRemoteItems, sizeof(TClientItem)*20, #0);
   g_nDealGold := 0;
   g_nDealRemoteGold := 0;
   g_boDealEnd := FALSE;

   //酒捞袍 啊规俊 儡惑捞 乐绰瘤 八荤
   ArrangeItembag;
end;

procedure TFrmDlg.CloseDealDlg;
begin
   DDealDlg.Visible := FALSE;
   DDealRemoteDlg.Visible := FALSE;

   //酒捞袍 啊规俊 儡惑捞 乐绰瘤 八荤
   ArrangeItembag;
end;

procedure TFrmDlg.DDealOkClick(Sender: TObject; X, Y: Integer);
var
   mi: integer;
begin
   if GetTickCount > g_dwDealActionTick then begin
      //CloseDealDlg;
      FrmMain.SendDealEnd;
      g_dwDealActionTick := GetTickCount + 4000;
      g_boDealEnd := TRUE;
      //掉 芒俊辑 付快胶肺 缠绊 乐绰 巴阑 掉芒栏肺 持绰促. 付快胶俊 巢绰 儡惑(汗荤)阑 绝矩促.
      if g_boItemMoving then begin
         mi := g_MovingItem.Index;
         if (mi <= -20) and (mi > -30) then begin //掉 芒俊辑 柯巴父
            AddDealItem (g_MovingItem.Item);
            g_boItemMoving := FALSE;
            g_MovingItem.Item.S.name := '';
         end;
      end;
   end;
end;

procedure TFrmDlg.DDealCloseClick(Sender: TObject; X, Y: Integer);
begin
   if GetTickCount > g_dwDealActionTick then begin
      CloseDealDlg;
      FrmMain.SendCancelDeal;
   end;
end;

procedure TFrmDlg.DDealRemoteDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
   with DDealRemoteDlg do begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      with dsurface.Canvas do begin
         SetBkMode (Handle, TRANSPARENT);
         Font.Color := clWhite;
         TextOut (SurfaceX(Left+64), SurfaceY(Top+196-65), GetGoldStr(g_nDealRemoteGold));
         TextOut (SurfaceX(Left+59 + (106-TextWidth(g_sDealWho)) div 2), SurfaceY(Top+3)+3, g_sDealWho);
         Release;
      end;
   end;
end;

procedure TFrmDlg.DDealDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
   with DDealDlg do begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      with dsurface.Canvas do begin
         SetBkMode (Handle, TRANSPARENT);
         Font.Color := clWhite;
         TextOut (SurfaceX(Left+64), SurfaceY(Top+196-65), GetGoldStr(g_nDealGold));
         TextOut (SurfaceX(Left+59 + (106-TextWidth(FrmMain.CharName)) div 2), SurfaceY(Top+3)+3, FrmMain.CharName);
         Release;
      end;
   end;
end;

procedure TFrmDlg.DealItemReturnBag (mitem: TClientItem);
begin
   if not g_boDealEnd then begin
      g_DealDlgItem := mitem;
      FrmMain.SendDelDealItem (g_DealDlgItem);
      g_dwDealActionTick := GetTickCount + 4000;
   end;
end;

procedure TFrmDlg.DDGridGridSelect(Sender: TObject; ACol, ARow: Integer;
  Shift: TShiftState);
var
   temp: TClientItem;
   mi, idx: integer;
begin
   if not g_boDealEnd and (GetTickCount > g_dwDealActionTick) then begin
      if not g_boItemMoving then begin
         idx := ACol + ARow * DDGrid.ColCount;
         if idx in [0..9] then
            if g_DealItems[idx].S.Name <> '' then begin
               g_boItemMoving := TRUE;
               g_MovingItem.Index := -idx - 20;
               g_MovingItem.Item := g_DealItems[idx];
               g_DealItems[idx].S.Name := '';
               ItemClickSound (g_MovingItem.Item.S);
            end;
      end else begin
         mi := g_MovingItem.Index;
         if (mi >= 0) or (mi <= -20) and (mi > -30) then begin //啊规,俊辑 柯巴父
            ItemClickSound (g_MovingItem.Item.S);
            g_boItemMoving := FALSE;
            if mi >= 0 then begin
               g_DealDlgItem := g_MovingItem.Item; //辑滚俊 搬苞甫 扁促府绰悼救 焊包
               FrmMain.SendAddDealItem (g_DealDlgItem);
               g_dwDealActionTick := GetTickCount + 4000;
            end else
               AddDealItem (g_MovingItem.Item);
            g_MovingItem.Item.S.name := '';
         end;
         if mi = -98 then DDGoldClick (self, 0, 0);
      end;
      ArrangeItemBag;
   end;
end;

procedure TFrmDlg.DDGridGridPaint(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
var
   idx: integer;
   d: TDirectDrawSurface;
begin
   idx := ACol + ARow * DDGrid.ColCount;
   if idx in [0..9] then begin
      if g_DealItems[idx].S.Name <> '' then begin
         d := g_WBagItemImages.Images[g_DealItems[idx].S.Looks];
         if d <> nil then
            with DDGrid do
               dsurface.Draw (SurfaceX(Rect.Left + (ColWidth - d.Width) div 2 - 1),
                              SurfaceY(Rect.Top + (RowHeight - d.Height) div 2 + 1),
                              d.ClientRect,
                              d, TRUE);
      end;
   end;
end;

procedure TFrmDlg.DDGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
  Shift: TShiftState);
var
   idx: integer;
begin
   idx := ACol + ARow * DDGrid.ColCount;
   if idx in [0..9] then begin
      g_MouseItem := g_DealItems[idx];
   end;
end;

procedure TFrmDlg.DDRGridGridPaint(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
var
   idx: integer;
   d: TDirectDrawSurface;
begin
   idx := ACol + ARow * DDRGrid.ColCount;
   if idx in [0..19] then begin
      if g_DealRemoteItems[idx].S.Name <> '' then begin
         d := g_WBagItemImages.Images[g_DealRemoteItems[idx].S.Looks];
         if d <> nil then
            with DDRGrid do
               dsurface.Draw (SurfaceX(Rect.Left + (ColWidth - d.Width) div 2 - 1),
                              SurfaceY(Rect.Top + (RowHeight - d.Height) div 2 + 1),
                              d.ClientRect,
                              d, TRUE);
      end;
   end;
end;

procedure TFrmDlg.DDRGridGridMouseMove(Sender: TObject; ACol,
  ARow: Integer; Shift: TShiftState);
var
   idx: integer;
begin
   idx := ACol + ARow * DDRGrid.ColCount;
   if idx in [0..19] then begin
      g_MouseItem := g_DealRemoteItems[idx];
   end;
end;

procedure TFrmDlg.DealZeroGold;
begin
   if not g_boDealEnd and (g_nDealGold > 0) then begin
      g_dwDealActionTick := GetTickCount + 4000;
      FrmMain.SendChangeDealGold (0);
   end;
end;

procedure TFrmDlg.DDGoldClick(Sender: TObject; X, Y: Integer);
var
   dgold: integer;
   valstr: string;
begin
   if g_MySelf = nil then exit;
   if not g_boDealEnd and (GetTickCount > g_dwDealActionTick) then begin
      if not g_boItemMoving then begin
         if g_nDealGold > 0 then begin
            PlaySound (s_money);
            g_boItemMoving := TRUE;
            g_MovingItem.Index := -97; //背券 芒俊辑狼 捣
            g_MovingItem.Item.S.Name := g_sGoldName{'金币'};
         end;
      end else begin
         if (g_MovingItem.Index = -97) or (g_MovingItem.Index = -98) then begin //捣父..
            if (g_MovingItem.Index = -98) then begin //啊规芒俊辑 柯 捣
               if g_MovingItem.Item.S.Name = g_sGoldName{'金币'} then begin
                  //倔付甫 滚副 扒瘤 拱绢夯促.
                  DialogSize := 1;
                  g_boItemMoving := FALSE;
                  g_MovingItem.Item.S.Name := '';
                  DMessageDlg ('请输入' +g_sGoldName+ '数量：', [mbOk, mbAbort]);
                  GetValidStrVal (DlgEditText, valstr, [' ']);
                  dgold := Str_ToInt (valstr, 0);
                  if (dgold <= (g_nDealGold+g_MySelf.m_nGold)) and (dgold > 0) then begin
                     FrmMain.SendChangeDealGold (dgold);
                     g_dwDealActionTick := GetTickCount + 4000;
                  end else
                     dgold := 0;
               end;
            end;
            g_boItemMoving := FALSE;
            g_MovingItem.Item.S.Name := '';
         end;
      end;
   end;
end;



{--------------------------------------------------------------}


procedure TFrmDlg.DUserState1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   i, l, m, pgidx, bbx, bby, idx, ax, ay, sex, hair: integer;
   d: TDirectDrawSurface;
   hcolor, keyimg: integer;
   iname, d1, d2, d3: string;
   useable: Boolean;
begin
   with DUserState1 do begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);

      //人物相关
      sex := DRESSfeature (UserState1.Feature) mod 2;
      hair := HAIRfeature (UserState1.Feature);
      if sex = 1 then pgidx := 377   //女
      else pgidx := 376;     //男
      bbx := Left + 38;
      bby := Top + 52;
      d := g_WMainImages.Images[pgidx];
      if d <> nil then
         dsurface.Draw (SurfaceX(bbx), SurfaceY(bby), d.ClientRect, d, FALSE);
      bbx := bbx - 7;
      bby := bby + 44;
      //渴, 公扁, 赣府 胶鸥老
      idx := 440 + hair div 2; //赣府 胶鸥老
      if sex = 1 then idx := 480 + hair div 2;
      if idx > 0 then begin
         d := g_WMainImages.GetCachedImage (idx, ax, ay);
         if d <> nil then
            dsurface.Draw (SurfaceX(bbx+ax), SurfaceY(bby+ay), d.ClientRect, d, TRUE);
      end;
      if UserState1.UseItems[U_DRESS].S.Name <> '' then begin
         idx := UserState1.UseItems[U_DRESS].S.Looks; //渴 if m_btSex = 1 then idx := 80; //咯磊渴
         if idx >= 0 then begin
            //d := FrmMain.WStateItem.GetCachedImage (idx, ax, ay);
            d := FrmMain.GetWStateImg(idx,ax,ay);
            if d <> nil then
               dsurface.Draw (SurfaceX(bbx+ax), SurfaceY(bby+ay), d.ClientRect, d, TRUE);
         end;
      end;
      if UserState1.UseItems[U_WEAPON].S.Name <> '' then begin
         idx := UserState1.UseItems[U_WEAPON].S.Looks;
         if idx >= 0 then begin
            //d := FrmMain.WStateItem.GetCachedImage (idx, ax, ay);
            d := FrmMain.GetWStateImg(idx,ax,ay);
            if d <> nil then
               dsurface.Draw (SurfaceX(bbx+ax), SurfaceY(bby+ay), d.ClientRect, d, TRUE);
         end;
      end;
      if UserState1.UseItems[U_HELMET].S.Name <> '' then begin
         idx := UserState1.UseItems[U_HELMET].S.Looks;
         if idx >= 0 then begin
            //d := FrmMain.WStateItem.GetCachedImage (idx, ax, ay);
            d := FrmMain.GetWStateImg(idx,ax,ay);
            if d <> nil then
               dsurface.Draw (SurfaceX(bbx+ax), SurfaceY(bby+ay), d.ClientRect, d, TRUE);
         end;
      end;


     { //原为打开，显示其它人物信息里的装备信息，显示在人物下方
      if MouseUserStateItem.S.Name <> '' then begin
         MouseItem := MouseUserStateItem;
         GetMouseItemInfo (iname, d1, d2, d3, useable);
         if iname <> '' then begin
            if MouseItem.Dura = 0 then hcolor := clRed
            else hcolor := clWhite;
            with dsurface.Canvas do begin
               SetBkMode (Handle, TRANSPARENT);
               Font.Color := clYellow;
               TextOut (SurfaceX(Left+37), SurfaceY(Top+272), iname);
               Font.Color := hcolor;
               TextOut (SurfaceX(Left+37+TextWidth(iname)), SurfaceY(Top+272), d1);
               TextOut (SurfaceX(Left+37), SurfaceY(Top+272+TextHeight('A')+2), d2);
               TextOut (SurfaceX(Left+37), SurfaceY(Top+272+(TextHeight('A')+2)*2), d3);
               Release;
            end;
         end;
         MouseItem.S.Name := '';
      end;      }

      //捞抚
      with dsurface.Canvas do begin
         SetBkMode (Handle, TRANSPARENT);
         Font.Color := UserState1.NameColor;
         TextOut (SurfaceX(Left + 122 - TextWidth(UserState1.UserName) div 2),
                  SurfaceY(Top + 23), UserState1.UserName);
         Font.Color := clSilver;
         TextOut (SurfaceX(Left + 45), SurfaceY(Top + 58),
                  UserState1.GuildName + ' ' + UserState1.GuildRankName);
         Release;
      end;

   end;
end;

procedure TFrmDlg.DUserState1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   X := DUserState1.LocalX (X) - DUserState1.Left;
   Y := DUserState1.LocalY (Y) - DUserState1.Top;
   if (X > 42) and (X < 201) and (Y > 54) and (Y < 71) then begin
      //DScreen.AddSysMsg (IntToStr(X) + ' ' + IntToStr(Y) + ' ' + UserState1.GuildName);
      if UserState1.GuildName <> '' then begin
         PlayScene.EdChat.Visible := TRUE;
         PlayScene.EdChat.SetFocus;
         SetImeMode (PlayScene.EdChat.Handle, LocalLanguage);
         PlayScene.EdChat.Text := UserState1.GuildName;
         PlayScene.EdChat.SelStart := Length(PlayScene.EdChat.Text);
         PlayScene.EdChat.SelLength := 0;
      end;
   end;
end;

procedure TFrmDlg.DUserState1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  g_MouseUserStateItem.S.Name := '';
end;

procedure TFrmDlg.DWeaponUS1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
   sel: integer;
   iname, d1, d2, d3: string;
   useable: Boolean;
   hcolor: TColor;   
begin
   sel := -1;
   if Sender = DDressUS1 then sel := U_DRESS;
   if Sender = DWeaponUS1 then sel := U_WEAPON;
   if Sender = DHelmetUS1 then sel := U_HELMET;
   if Sender = DNecklaceUS1 then sel := U_NECKLACE;
   if Sender = DLightUS1 then sel := U_RIGHTHAND;
   if Sender = DRingLUS1 then sel := U_RINGL;
   if Sender = DRingRUS1 then sel := U_RINGR;
   if Sender = DArmRingLUS1 then sel := U_ARMRINGL;
   if Sender = DArmRingRUS1 then sel := U_ARMRINGR;

   if Sender = DBujukUS1 then sel := U_BUJUK;
   if Sender = DBeltUS1 then sel := U_BELT;
   if Sender = DBootsUS1 then sel := U_BOOTS;
   if Sender = DCharmUS1 then sel := U_CHARM;

   if sel >= 0 then begin
      g_MouseUserStateItem := UserState1.UseItems[sel];
      //原为注释掉 显示人物身上带的物品信息
      g_MouseItem := UserState1.UseItems[sel];
      GetMouseItemInfo (iname, d1, d2, d3, useable);
      if iname <> '' then begin
         if UserState1.UseItems[sel].Dura = 0 then hcolor := clRed
         else hcolor := clWhite;
         with Sender as TDButton do
            DScreen.ShowHint (SurfaceX(Left - 30),
                              SurfaceY(Top + 50),
                              iname + d1 + '\' + d2 + '\' + d3, hcolor, FALSE);
      end;
      g_MouseItem.S.Name := '';
      //      
   end;

end;

procedure TFrmDlg.DCloseUS1Click(Sender: TObject; X, Y: Integer);
begin
   DUserState1.Visible := FALSE;
end;

procedure TFrmDlg.DNecklaceUS1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   idx: integer;
   d: TDirectDrawSurface;
begin
   if Sender = DNecklaceUS1 then begin
      if UserState1.UseItems[U_NECKLACE].S.Name <> '' then begin
         idx := UserState1.UseItems[U_NECKLACE].S.Looks;
         if idx >= 0 then begin
            //d := FrmMain.WStateItem.Images[idx];
            d := FrmMain.GetWStateImg(idx);
            if d <> nil then
               dsurface.Draw (DNecklaceUS1.SurfaceX(DNecklaceUS1.Left + (DNecklaceUS1.Width - d.Width) div 2),
                              DNecklaceUS1.SurfaceY(DNecklaceUS1.Top + (DNecklaceUS1.Height - d.Height) div 2),
                              d.ClientRect, d, TRUE);
         end;
      end;
   end;
   if Sender = DLightUS1 then begin
      if UserState1.UseItems[U_RIGHTHAND].S.Name <> '' then begin
         idx := UserState1.UseItems[U_RIGHTHAND].S.Looks;
         if idx >= 0 then begin
            //d := FrmMain.WStateItem.Images[idx];
            d := FrmMain.GetWStateImg(idx);
            if d <> nil then
               dsurface.Draw (DLightUS1.SurfaceX(DLightUS1.Left + (DLightUS1.Width - d.Width) div 2),
                              DLightUS1.SurfaceY(DLightUS1.Top + (DLightUS1.Height - d.Height) div 2),
                              d.ClientRect, d, TRUE);
         end;
      end;
   end;
   if Sender = DArmRingRUS1 then begin
      if UserState1.UseItems[U_ARMRINGR].S.Name <> '' then begin
         idx := UserState1.UseItems[U_ARMRINGR].S.Looks;
         if idx >= 0 then begin
            //d := FrmMain.WStateItem.Images[idx];
            d := FrmMain.GetWStateImg(idx);
            if d <> nil then
               dsurface.Draw (DArmRingRUS1.SurfaceX(DArmRingRUS1.Left + (DArmRingRUS1.Width - d.Width) div 2),
                              DArmRingRUS1.SurfaceY(DArmRingRUS1.Top + (DArmRingRUS1.Height - d.Height) div 2),
                              d.ClientRect, d, TRUE);
         end;
      end;
   end;
   if Sender = DArmRingLUS1 then begin
      if UserState1.UseItems[U_ARMRINGL].S.Name <> '' then begin
         idx := UserState1.UseItems[U_ARMRINGL].S.Looks;
         if idx >= 0 then begin
            //d := FrmMain.WStateItem.Images[idx];
            d := FrmMain.GetWStateImg(idx);
            if d <> nil then
               dsurface.Draw (DArmRingLUS1.SurfaceX(DArmRingLUS1.Left + (DArmRingLUS1.Width - d.Width) div 2),
                              DArmRingLUS1.SurfaceY(DArmRingLUS1.Top + (DArmRingLUS1.Height - d.Height) div 2),
                              d.ClientRect, d, TRUE);
         end;
      end;
   end;
   if Sender = DRingRUS1 then begin
      if UserState1.UseItems[U_RINGR].S.Name <> '' then begin
         idx := UserState1.UseItems[U_RINGR].S.Looks;
         if idx >= 0 then begin
            //d := FrmMain.WStateItem.Images[idx];
            d := FrmMain.GetWStateImg(idx);
            if d <> nil then
               dsurface.Draw (DRingRUS1.SurfaceX(DRingRUS1.Left + (DRingRUS1.Width - d.Width) div 2),
                              DRingRUS1.SurfaceY(DRingRUS1.Top + (DRingRUS1.Height - d.Height) div 2),
                              d.ClientRect, d, TRUE);
         end;
      end;
   end;
   if Sender = DRingLUS1 then begin
      if UserState1.UseItems[U_RINGL].S.Name <> '' then begin
         idx := UserState1.UseItems[U_RINGL].S.Looks;
         if idx >= 0 then begin
            //d := FrmMain.WStateItem.Images[idx];
            d := FrmMain.GetWStateImg(idx);
            if d <> nil then
               dsurface.Draw (DRingLUS1.SurfaceX(DRingLUS1.Left + (DRingLUS1.Width - d.Width) div 2),
                              DRingLUS1.SurfaceY(DRingLUS1.Top + (DRingLUS1.Height - d.Height) div 2),
                              d.ClientRect, d, TRUE);
         end;
      end;
   end;


   if Sender = DBujukUS1 then begin
      if UserState1.UseItems[U_BUJUK].S.Name <> '' then begin
         idx := UserState1.UseItems[U_BUJUK].S.Looks;
         if idx >= 0 then begin
            //d := FrmMain.WStateItem.Images[idx];
            d := FrmMain.GetWStateImg(idx);
            if d <> nil then
               dsurface.Draw (DBujukUS1.SurfaceX(DBujukUS1.Left + (DBujukUS1.Width - d.Width) div 2),
                              DBujukUS1.SurfaceY(DBujukUS1.Top + (DBujukUS1.Height - d.Height) div 2),
                              d.ClientRect, d, TRUE);
         end;
      end;
   end;

   if Sender = DBeltUS1 then begin
      if UserState1.UseItems[U_BELT].S.Name <> '' then begin
         idx := UserState1.UseItems[U_BELT].S.Looks;
         if idx >= 0 then begin
            //d := FrmMain.WStateItem.Images[idx];
            d := FrmMain.GetWStateImg(idx);
            if d <> nil then
               dsurface.Draw (DBeltUS1.SurfaceX(DBeltUS1.Left + (DBeltUS1.Width - d.Width) div 2),
                              DBeltUS1.SurfaceY(DBeltUS1.Top + (DBeltUS1.Height - d.Height) div 2),
                              d.ClientRect, d, TRUE);
         end;
      end;
   end;

   if Sender = DBootsUS1 then begin
      if UserState1.UseItems[U_BOOTS].S.Name <> '' then begin
         idx := UserState1.UseItems[U_BOOTS].S.Looks;
         if idx >= 0 then begin
            //d := FrmMain.WStateItem.Images[idx];
            d := FrmMain.GetWStateImg(idx);
            if d <> nil then
               dsurface.Draw (DBootsUS1.SurfaceX(DBootsUS1.Left + (DBootsUS1.Width - d.Width) div 2),
                              DBootsUS1.SurfaceY(DBootsUS1.Top + (DBootsUS1.Height - d.Height) div 2),
                              d.ClientRect, d, TRUE);
         end;
      end;
   end;

   if Sender = DCharmUS1 then begin
      if UserState1.UseItems[U_CHARM].S.Name <> '' then begin
         idx := UserState1.UseItems[U_CHARM].S.Looks;
         if idx >= 0 then begin
            //d := FrmMain.WStateItem.Images[idx];
            d := FrmMain.GetWStateImg(idx);
            if d <> nil then
               dsurface.Draw (DCharmUS1.SurfaceX(DCharmUS1.Left + (DCharmUS1.Width - d.Width) div 2),
                              DCharmUS1.SurfaceY(DCharmUS1.Top + (DCharmUS1.Height - d.Height) div 2),
                              d.ClientRect, d, TRUE);
         end;
      end;
   end;
end;


procedure TFrmDlg.ShowGuildDlg;
begin
   DGuildDlg.Visible := TRUE;  //not DGuildDlg.Visible;
   DGuildDlg.Top := -3;
   DGuildDlg.Left := 0;
   if DGuildDlg.Visible then begin
      if GuildCommanderMode then begin
         DGDAddMem.Visible := TRUE;
         DGDDelMem.Visible := TRUE;
         DGDEditNotice.Visible := TRUE;
         DGDEditGrade.Visible := TRUE;
         DGDAlly.Visible := TRUE;
         DGDBreakAlly.Visible := TRUE;
         DGDWar.Visible := TRUE;
         DGDCancelWar.Visible := TRUE;
      end else begin
         DGDAddMem.Visible := FALSE;
         DGDDelMem.Visible := FALSE;
         DGDEditNotice.Visible := FALSE;
         DGDEditGrade.Visible := FALSE;
         DGDAlly.Visible := FALSE;
         DGDBreakAlly.Visible := FALSE;
         DGDWar.Visible := FALSE;
         DGDCancelWar.Visible := FALSE;
      end;

   end;
   GuildTopLine := 0;
end;

procedure TFrmDlg.ShowGuildEditNotice;
var
   d: TDirectDrawSurface;
   i: integer;
   data: string;
begin
   with DGuildEditNotice do begin
      d := WLib.Images[FaceIndex];
      if d <> nil then begin
         Left := (SCREENWIDTH - d.Width) div 2;
         Top := (SCREENHEIGHT - d.Height) div 2;
      end;
      HideAllControls;
      DGuildEditNotice.ShowModal;

      Memo.Left := SurfaceX(Left+16);
      Memo.Top  := SurfaceY(Top+36);
      Memo.Width := 571;
      Memo.Height := 246;
      Memo.Lines.Assign (GuildNotice);
      Memo.Visible := TRUE;

      while TRUE do begin
         if not DGuildEditNotice.Visible then break;
         FrmMain.ProcOnIdle;
         Application.ProcessMessages;
         if Application.Terminated then exit;
      end;

      DGuildEditNotice.Visible := FALSE;
      RestoreHideControls;

      if DMsgDlg.DialogResult = mrOk then begin
         data := '';
         for i:=0 to Memo.Lines.Count-1 do begin
            if Memo.Lines[i] = '' then
               data := data + Memo.Lines[i] + ' '#13
            else data := data + Memo.Lines[i] + #13;
         end;
         if Length(data) > 4000 then begin
            data := Copy (data, 1, 4000);
            DMessageDlg ('公告文字最多只能输入4000个字符，多余部分将被截断。', [mbOk]);
         end;
         FrmMain.SendGuildUpdateNotice (data);
      end;
   end;
end;

procedure TFrmDlg.ShowGuildEditGrade;
var
   d: TDirectDrawSurface;
   data: string;
   i: integer;
begin
   if GuildMembers.Count <= 0 then begin
      DMessageDlg ('请按【成员列表】按钮，来调出行会成员列表！', [mbOk]);
      exit;
   end;

   with DGuildEditNotice do begin
      d := WLib.Images[FaceIndex];
      if d <> nil then begin
         Left := (SCREENWIDTH - d.Width) div 2;
         Top := (SCREENHEIGHT - d.Height) div 2;
      end;
      HideAllControls;
      DGuildEditNotice.ShowModal;

      Memo.Left := SurfaceX(Left+16);
      Memo.Top  := SurfaceY(Top+36);
      Memo.Width := 571;
      Memo.Height := 246;
      Memo.Lines.Assign (GuildMembers);
      Memo.Visible := TRUE;

      while TRUE do begin
         if not DGuildEditNotice.Visible then break;
         FrmMain.ProcOnIdle;
         Application.ProcessMessages;
         if Application.Terminated then exit;
      end;

      DGuildEditNotice.Visible := FALSE;
      RestoreHideControls;

      if DMsgDlg.DialogResult = mrOk then begin
         //GuildMembers.Assign (Memo.Lines);
         //搬苞... 巩颇殿鞭阑 诀单捞飘 茄促.
         data := '';
         for i:=0 to Memo.Lines.Count-1 do begin
            data := data + Memo.Lines[i] + #13;  //辑滚俊辑 颇教窃.
         end;
         if Length(data) > 5000 then begin
            data := Copy (data, 1, 5000);
            DMessageDlg ('内容过多..', [mbOk]);
         end;
         FrmMain.SendGuildUpdateGrade (data);
      end;
   end;
end;

procedure TFrmDlg.DGuildDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  i, n, bx, by: integer;
begin
   with DGuildDlg do begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);

      with dsurface.Canvas do begin
         SetBkMode (Handle, TRANSPARENT);
         Font.Color := clWhite;
         TextOut (Left+320, Top+13, Guild);

         bx := Left + 24;
         by := Top + 41;
         for i:=GuildTopLine to GuildStrs.Count-1 do begin
            n := i-GuildTopLine;
            if n*14 > 356 then break;
            if Integer(GuildStrs.Objects[i]) <> 0 then Font.Color := TColor(GuildStrs.Objects[i])
            else begin
               if BoGuildChat then Font.Color := GetRGB (2)
               else Font.Color := clSilver;
            end;
            TextOut (bx, by + n*14, GuildStrs[i]);
         end;

         Release;
      end;

   end;
end;

procedure TFrmDlg.DGDUpClick(Sender: TObject; X, Y: Integer);
begin
   if GuildTopLine > 0 then Dec (GuildTopLine, 3);
   if GuildTopLine < 0 then GuildTopLine := 0;
end;

procedure TFrmDlg.DGDDownClick(Sender: TObject; X, Y: Integer);
begin
   if GuildTopLine+12 < GuildStrs.Count then Inc (GuildTopLine, 3);
end;

procedure TFrmDlg.DGDCloseClick(Sender: TObject; X, Y: Integer);
begin
   DGuildDlg.Visible := FALSE;
   BoGuildChat := FALSE;
end;

procedure TFrmDlg.DGDHomeClick(Sender: TObject; X, Y: Integer);
begin
   if GetTickCount > g_dwQueryMsgTick then begin
      g_dwQueryMsgTick := GetTickCount + 3000;
      FrmMain.SendGuildHome;
      BoGuildChat := FALSE;
   end;
end;

procedure TFrmDlg.DGDListClick(Sender: TObject; X, Y: Integer);
begin
   if GetTickCount > g_dwQueryMsgTick then begin
      g_dwQueryMsgTick := GetTickCount + 3000;
      FrmMain.SendGuildMemberList;
      BoGuildChat := FALSE;
   end;
end;

procedure TFrmDlg.DGDAddMemClick(Sender: TObject; X, Y: Integer);
begin
   DMessageDlg ('请输入您想要让加入行会的玩家姓名： ' + Guild + '.', [mbOk, mbAbort]);
   if DlgEditText <> '' then
      FrmMain.SendGuildAddMem (DlgEditText);
end;

procedure TFrmDlg.DGDDelMemClick(Sender: TObject; X, Y: Integer);
begin
   DMessageDlg ('请输入您想从行会删除的玩家姓名：', [mbOk, mbAbort]);
   if DlgEditText <> '' then
      FrmMain.SendGuildDelMem (DlgEditText);
end;

procedure TFrmDlg.DGDEditNoticeClick(Sender: TObject; X, Y: Integer);
begin
   GuildEditHint := '[修改行会公告内容]';
   ShowGuildEditNotice;
end;

procedure TFrmDlg.DGDEditGradeClick(Sender: TObject; X, Y: Integer);
begin
   GuildEditHint := '[修改行会成员的等级和职位]';
   ShowGuildEditGrade;
end;

procedure TFrmDlg.DGDAllyClick(Sender: TObject; X, Y: Integer);
begin
   if mrOk = DMessageDlg ('与对方行会联盟应在双方都同意的状态下，\' +
                  '而且您应该面对要联盟的行会掌门面前，\' +
                  '您想联盟吗?', [mbOk, mbCancel])
   then
      FrmMain.SendSay ('@联盟');
end;

procedure TFrmDlg.DGDBreakAllyClick(Sender: TObject; X, Y: Integer);
begin
   DMessageDlg ('请输入您想要取消联盟的行会名称。', [mbOk, mbAbort]);
   if DlgEditText <> '' then
      FrmMain.SendSay ('@取消联盟 ' + DlgEditText);
end;



procedure TFrmDlg.DGuildEditNoticeDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   with DGuildEditNotice do begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);

      with dsurface.Canvas do begin
         SetBkMode (Handle, TRANSPARENT);
         Font.Color := clSilver;

         TextOut (Left+18, Top+291, GuildEditHint);
         Release;
      end;
   end;
end;

procedure TFrmDlg.DGECloseClick(Sender: TObject; X, Y: Integer);
begin
   DGuildEditNotice.Visible := FALSE;
   Memo.Visible := FALSE;
   DMsgDlg.DialogResult := mrCancel;
end;

procedure TFrmDlg.DGEOkClick(Sender: TObject; X, Y: Integer);
begin
   DGECloseClick (self, 0, 0);
   DMsgDlg.DialogResult := mrOk;
end;

procedure TFrmDlg.AddGuildChat (str: string);
var
   i: integer;
begin
   GuildChats.Add (str);
   if GuildChats.Count > 500 then begin
      for i:=0 to 100 do GuildChats.Delete(0);
   end;
   if BoGuildChat then
      GuildStrs.Assign (GuildChats);
end;

procedure TFrmDlg.DGDChatClick(Sender: TObject; X, Y: Integer);
begin
   BoGuildChat := not BoGuildChat;
   if BoGuildChat then begin
      GuildStrs2.Assign (GuildStrs);
      GuildStrs.Assign (GuildChats);
   end else
      GuildStrs.Assign (GuildStrs2);
end;

procedure TFrmDlg.DGoldDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
   if g_MySelf = nil then exit;
   with DGold do begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
         dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
   end;
end;


{--------------------------------------------------------------}
//瓷仿摹 炼沥 芒

procedure TFrmDlg.DAdjustAbilCloseClick(Sender: TObject; X, Y: Integer);
begin
   DAdjustAbility.Visible := FALSE;
   g_nBonusPoint := g_nSaveBonusPoint;
end;

procedure TFrmDlg.DAdjustAbilityDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
   procedure AdjustAb (abil: byte; val: word; var lov, hiv: Word);
   var
      lo, hi: byte;
      i: integer;
   begin
      lo := Lobyte(abil);
      hi := Hibyte(abil);
      lov := 0; hiv := 0;
      for i:=1 to val do begin
         if lo+1 < hi then begin Inc(lo); Inc(lov);
         end else begin Inc(hi); Inc(hiv); end;
      end;
   end;
var
   d: TDirectDrawSurface;
   l, m, adc, amc, asc, aac, amac: integer;
   ldc, lmc, lsc, lac, lmac, hdc, hmc, hsc, hac, hmac: Word;
begin
   if g_MySelf = nil then exit;
   with dsurface.Canvas do begin
      with DAdjustAbility do begin
         d := DMenuDlg.WLib.Images[FaceIndex];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end;

      SetBkMode (Handle, TRANSPARENT);
      Font.Color := clSilver;

      l := DAdjustAbility.SurfaceX(DAdjustAbility.Left) + 36;
      m := DAdjustAbility.SurfaceY(DAdjustAbility.Top) + 22;

      TextOut (l, m,      '恭喜你已经到了下一个等级...!');
      TextOut (l, m+14,   '选择你想提高的能力...');
      TextOut (l, m+14*2, '这样的选择你只可以做一次,最好能很小心地选择.');
      TextOut (l, m+14*3, '.');

      Font.Color := clWhite;
      //属性调整筐
      l := DAdjustAbility.SurfaceX(DAdjustAbility.Left) + 100; //66;
      m := DAdjustAbility.SurfaceY(DAdjustAbility.Top) + 101;

     {
      adc := (g_BonusAbil.DC + g_BonusAbilChg.DC) div g_BonusTick.DC;
      amc := (g_BonusAbil.MC + g_BonusAbilChg.MC) div g_BonusTick.MC;
      asc := (g_BonusAbil.SC + g_BonusAbilChg.SC) div g_BonusTick.SC;
      aac := (g_BonusAbil.AC + g_BonusAbilChg.AC) div g_BonusTick.AC;
      amac := (g_BonusAbil.MAC + g_BonusAbilChg.MAC) div g_BonusTick.MAC;}

      adc := (g_BonusAbilChg.DC) div g_BonusTick.DC;
      amc := (g_BonusAbilChg.MC) div g_BonusTick.MC;
      asc := (g_BonusAbilChg.SC) div g_BonusTick.SC;
      aac := (g_BonusAbilChg.AC) div g_BonusTick.AC;
      amac := (g_BonusAbilChg.MAC) div g_BonusTick.MAC;

      AdjustAb (g_NakedAbil.DC, adc, ldc, hdc);
      AdjustAb (g_NakedAbil.MC, amc, lmc, hmc);
      AdjustAb (g_NakedAbil.SC, asc, lsc, hsc);
      AdjustAb (g_NakedAbil.AC, aac, lac, hac);
      AdjustAb (g_NakedAbil.MAC, amac, lmac, hmac);
      // lac  := 0;  hac := aac;
     // lmac := 0;  hmac := amac;

      TextOut (l+0, m-4, IntToStr(LoWord(g_MySelf.m_Abil.DC)+ldc) + '-' + IntToStr(HiWord(g_MySelf.m_Abil.DC) + hdc));
      TextOut (l+0, m+16, IntToStr(LoWord(g_MySelf.m_Abil.MC)+lmc) + '-' + IntToStr(HiWord(g_MySelf.m_Abil.MC) + hmc));
      TextOut (l+0, m+36, IntToStr(LoWord(g_MySelf.m_Abil.SC)+lsc) + '-' + IntToStr(HiWord(g_MySelf.m_Abil.SC) + hsc));
      TextOut (l+0, m+56, IntToStr(LoWord(g_MySelf.m_Abil.AC)+lac) + '-' + IntToStr(HiWord(g_MySelf.m_Abil.AC) + hac));
      TextOut (l+0, m+76, IntToStr(LoWord(g_MySelf.m_Abil.MAC)+lmac) + '-' + IntToStr(HiWord(g_MySelf.m_Abil.MAC) + hmac));
      TextOut (l+0, m+96, IntToStr(g_MySelf.m_Abil.MaxHP + (g_BonusAbil.HP + g_BonusAbilChg.HP) div g_BonusTick.HP));
      TextOut (l+0, m+116, IntToStr(g_MySelf.m_Abil.MaxMP + (g_BonusAbil.MP + g_BonusAbilChg.MP) div g_BonusTick.MP));
      TextOut (l+0, m+136, IntToStr(g_nMyHitPoint + (g_BonusAbil.Hit + g_BonusAbilChg.Hit) div g_BonusTick.Hit));
      TextOut (l+0, m+156, IntToStr(g_nMySpeedPoint + (g_BonusAbil.Speed + g_BonusAbilChg.Speed) div g_BonusTick.Speed));

      Font.Color := clYellow;
      TextOut (l+0, m+177, IntToStr(g_nBonusPoint));

      Font.Color := clWhite;
      l := DAdjustAbility.SurfaceX(DAdjustAbility.Left) + 195; //66;
      m := DAdjustAbility.SurfaceY(DAdjustAbility.Top) + 101;

      if g_BonusAbilChg.DC > 0 then Font.Color := clWhite
      else Font.Color := clSilver;
      TextOut (l+0, m-4, IntToStr(g_BonusAbilChg.DC + g_BonusAbil.DC) + '/' + IntToStr(g_BonusTick.DC));

      if g_BonusAbilChg.MC > 0 then Font.Color := clWhite
      else Font.Color := clSilver;
      TextOut (l+0, m+16, IntToStr(g_BonusAbilChg.MC + g_BonusAbil.MC) + '/' + IntToStr(g_BonusTick.MC));

      if g_BonusAbilChg.SC > 0 then Font.Color := clWhite
      else Font.Color := clSilver;
      TextOut (l+0, m+36, IntToStr(g_BonusAbilChg.SC + g_BonusAbil.SC) + '/' + IntToStr(g_BonusTick.SC));

      if g_BonusAbilChg.AC > 0 then Font.Color := clWhite
      else Font.Color := clSilver;
      TextOut (l+0, m+56, IntToStr(g_BonusAbilChg.AC + g_BonusAbil.AC) + '/' + IntToStr(g_BonusTick.AC));

      if g_BonusAbilChg.MAC > 0 then Font.Color := clWhite
      else Font.Color := clSilver;
      TextOut (l+0, m+76, IntToStr(g_BonusAbilChg.MAC + g_BonusAbil.MAC) + '/' + IntToStr(g_BonusTick.MAC));

      if g_BonusAbilChg.HP > 0 then Font.Color := clWhite
      else Font.Color := clSilver;
      TextOut (l+0, m+96, IntToStr(g_BonusAbilChg.HP + g_BonusAbil.HP) + '/' + IntToStr(g_BonusTick.HP));

      if g_BonusAbilChg.MP > 0 then Font.Color := clWhite
      else Font.Color := clSilver;
      TextOut (l+0, m+116, IntToStr(g_BonusAbilChg.MP + g_BonusAbil.MP) + '/' + IntToStr(g_BonusTick.MP));

      if g_BonusAbilChg.Hit > 0 then Font.Color := clWhite
      else Font.Color := clSilver;
      TextOut (l+0, m+136, IntToStr(g_BonusAbilChg.Hit + g_BonusAbil.Hit) + '/' + IntToStr(g_BonusTick.Hit));

      if g_BonusAbilChg.Speed > 0 then Font.Color := clWhite
      else Font.Color := clSilver;
      TextOut (l+0, m+156, IntToStr(g_BonusAbilChg.Speed + g_BonusAbil.Speed) + '/' + IntToStr(g_BonusTick.Speed));

      Release;
   end;

end;

procedure TFrmDlg.DPlusDCClick(Sender: TObject; X, Y: Integer);
var
   incp: integer;
begin
   if g_nBonusPoint > 0 then begin
      if IsKeyPressed (VK_CONTROL) and (g_nBonusPoint > 10) then incp := 10
      else incp := 1;
      Dec(g_nBonusPoint, incp);
      if Sender = DPlusDC then Inc (g_BonusAbilChg.DC, incp);
      if Sender = DPlusMC then Inc (g_BonusAbilChg.MC, incp);
      if Sender = DPlusSC then Inc (g_BonusAbilChg.SC, incp);
      if Sender = DPlusAC then Inc (g_BonusAbilChg.AC, incp);
      if Sender = DPlusMAC then Inc (g_BonusAbilChg.MAC, incp);
      if Sender = DPlusHP then Inc (g_BonusAbilChg.HP, incp);
      if Sender = DPlusMP then Inc (g_BonusAbilChg.MP, incp);
      if Sender = DPlusHit then Inc (g_BonusAbilChg.Hit, incp);
      if Sender = DPlusSpeed then Inc (g_BonusAbilChg.Speed, incp);
   end;
end;

procedure TFrmDlg.DMinusDCClick(Sender: TObject; X, Y: Integer);
var
   decp: integer;
begin
   if IsKeyPressed (VK_CONTROL) and (g_nBonusPoint-10 > 0) then decp := 10
   else decp := 1;
   if Sender = DMinusDC then
      if g_BonusAbilChg.DC >= decp then begin
         Dec(g_BonusAbilChg.DC, decp);
         Inc (g_nBonusPoint, decp);
      end;
   if Sender = DMinusMC then
      if g_BonusAbilChg.MC >= decp then begin
         Dec(g_BonusAbilChg.MC, decp);
         Inc (g_nBonusPoint, decp);
      end;
   if Sender = DMinusSC then
      if g_BonusAbilChg.SC >= decp then begin
         Dec(g_BonusAbilChg.SC, decp);
         Inc (g_nBonusPoint, decp);
      end;
   if Sender = DMinusAC then
      if g_BonusAbilChg.AC >= decp then begin
         Dec(g_BonusAbilChg.AC, decp);
         Inc (g_nBonusPoint, decp);
      end;
   if Sender = DMinusMAC then
      if g_BonusAbilChg.MAC >= decp then begin
         Dec(g_BonusAbilChg.MAC, decp);
         Inc (g_nBonusPoint, decp);
      end;
   if Sender = DMinusHP then
      if g_BonusAbilChg.HP >= decp then begin
         Dec(g_BonusAbilChg.HP, decp);
         Inc (g_nBonusPoint, decp);
      end;
   if Sender = DMinusMP then
      if g_BonusAbilChg.MP >= decp then begin
         Dec(g_BonusAbilChg.MP, decp);
         Inc (g_nBonusPoint, decp);
      end;
   if Sender = DMinusHit then
      if g_BonusAbilChg.Hit >= decp then begin
         Dec(g_BonusAbilChg.Hit, decp);
         Inc (g_nBonusPoint, decp);
      end;
   if Sender = DMinusSpeed then
      if g_BonusAbilChg.Speed >= decp then begin
         Dec(g_BonusAbilChg.Speed, decp);
         Inc (g_nBonusPoint, decp);
      end;
end;

procedure TFrmDlg.DAdjustAbilOkClick(Sender: TObject; X, Y: Integer);
begin
   FrmMain.SendAdjustBonus(g_nBonusPoint, g_BonusAbilChg);
   DAdjustAbility.Visible := FALSE;
end;

procedure TFrmDlg.DAdjustAbilityMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
   i, lx, ly: integer;
   flag: Boolean;
begin
   with DAdjustAbility do begin
      lx := LocalX (X - Left);
      ly := LocalY (Y - Top);
      flag := FALSE;
      if (lx >= 50) and (lx < 150) then
         for i:=0 to 8 do begin  //DC,MC,SC..狼 腮飘啊 唱坷霸 茄促.
            if (ly >= 98 + i*20) and (ly < 98 + (i+1)*20) then begin
               DScreen.ShowHint (SurfaceX(Left) + lx + 10,
                                 SurfaceY(Top) + ly + 5,
                                 AdjustAbilHints[i],
                                 clWhite,
                                 FALSE);
               flag := TRUE;
               break;
            end;
         end;
      if not flag then
         DScreen.ClearHint;
   end;
end;

procedure TFrmDlg.DBotMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  nLocalX,nLocalY:Integer;
  nHintX,nHintY:Integer;
  Butt:TDButton;
  sMsg:String;
begin
  Butt:=TDButton(Sender);
  if Sender = DBotMiniMap then sMsg:= '小地图(M)';
  if Sender = DBotTrade then sMsg:= '交易(W)';
  if Sender = DBotGuild then sMsg:= '行会(G)';
  if Sender = DBotGroup then sMsg:= '组队(S)';
  if Sender = DBotPlusAbil then sMsg:= '技能点(N)';
  if Sender = DBotFriend then sMsg:= '好友(V)';
  if Sender = DBotLogout then sMsg:= '选择人物\Alt-X';
  if Sender = DBotExit then sMsg:= '退出游戏\Alt-Q';

  if Sender = DMyState then sMsg:= '装备(F10,C)';
  if Sender = DMyBag then sMsg:= '物品(F9,B)';
  if Sender = DMyMagic then sMsg:= '技能(F11,E)';
  if Sender = DOption then sMsg:= '声音(F12)';
  if Sender = DButtonHP then sMsg:= format('生命值(%d/%d)',[g_MySelf.m_Abil.HP,g_MySelf.m_Abil.MaxHP]);
  if Sender = DButtonMP then sMsg:= format('魔法值(%d/%d)',[g_MySelf.m_Abil.MP,g_MySelf.m_Abil.MaxMP]);


  nLocalX:=Butt.LocalX(X - Butt.Left);
  nLocalY:=Butt.LocalY(Y - Butt.Top);
  nHintX:=Butt.SurfaceX(Butt.Left) + DBottom.SurfaceX(DBottom.Left) + nLocalX;
  nHintY:=Butt.SurfaceY(Butt.Top) + DBottom.SurfaceY(DBottom.Top) + nLocalY;
  DScreen.ShowHint(nHintX,nHintY,sMsg, clYellow, FALSE);
end;


procedure TFrmDlg.DFrdFriendDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   with Sender as TDButton do begin
      if not TDButton(Sender).Downed then begin
         d := WLib.Images[FaceIndex];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end else begin
         d := WLib.Images[FaceIndex + 1];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end;
   end;
end;

procedure TFrmDlg.DBotFriendClick(Sender: TObject; X, Y: Integer);
begin
  OpenFriendDlg();
end;
procedure TFrmDlg.OpenFriendDlg();
begin
  DFriendDlg.Visible:=not DFriendDlg.Visible;
end;

procedure TFrmDlg.DFrdCloseClick(Sender: TObject; X, Y: Integer);
begin
  OpenFriendDlg();
end;

procedure TFrmDlg.DChgGamePwdCloseClick(Sender: TObject; X, Y: Integer);
begin
  DChgGamePwd.Visible:=False;
end;

procedure TFrmDlg.DChgGamePwdDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d:TDirectDrawSurface;
  lx, ly, sx: integer;
begin
  with Sender as TDWindow do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);

    SetBkMode (dsurface.Canvas.Handle, TRANSPARENT);
    BoldTextOut (dsurface, SurfaceX(Left+151), SurfaceY(Top+131), clWhite, clBlack, 'GamePoint');

    dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style + [fsUnderline];
    BoldTextOut (dsurface, SurfaceX(Left+121), SurfaceY(Top+190), clYellow, clBlack, 'GameGold');
    dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style - [fsUnderline];
    dsurface.Canvas.Release;
  end;
end;

end.
