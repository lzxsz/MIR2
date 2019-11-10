unit GameConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Spin, Grids;

type
  TLevelExpScheme = (s_OldLevelExp,s_StdLevelExp,s_2Mult,s_5Mult,s_8Mult,s_10Mult,s_20Mult,s_30Mult,s_40Mult,s_50Mult,s_60Mult,s_70Mult,s_80Mult,s_90Mult,s_100Mult,s_150Mult,s_200Mult,s_250Mult,s_300Mult);
  TfrmGameConfig = class(TForm)
    GameConfigControl: TPageControl;
    GameSpeedSheet: TTabSheet;
    GroupBox1: TGroupBox;
    EditHitIntervalTime: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    EditMagicHitIntervalTime: TSpinEdit;
    EditRunIntervalTime: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    EditWalkIntervalTime: TSpinEdit;
    Label5: TLabel;
    EditTurnIntervalTime: TSpinEdit;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    EditMaxHitMsgCount: TSpinEdit;
    EditMaxSpellMsgCount: TSpinEdit;
    EditMaxRunMsgCount: TSpinEdit;
    EditMaxWalkMsgCount: TSpinEdit;
    EditMaxTurnMsgCount: TSpinEdit;
    EditMaxDigUpMsgCount: TSpinEdit;
    GroupBox3: TGroupBox;
    Label13: TLabel;
    EditItemSpeedTime: TSpinEdit;
    ButtonGameSpeedSave: TButton;
    ExpSheet: TTabSheet;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    EditDigUpIntervalTime: TSpinEdit;
    GeneralSheet: TTabSheet;
    GroupBoxInfo: TGroupBox;
    Label16: TLabel;
    EditSoftVersionDate: TEdit;
    GroupBox5: TGroupBox;
    Label17: TLabel;
    EditConsoleShowUserCountTime: TSpinEdit;
    GroupBox6: TGroupBox;
    Label18: TLabel;
    EditShowLineNoticeTime: TSpinEdit;
    ComboBoxLineNoticeColor: TComboBox;
    Label19: TLabel;
    ButtonGeneralSave: TButton;
    Label21: TLabel;
    EditLineNoticePreFix: TEdit;
    GroupBox7: TGroupBox;
    Label22: TLabel;
    EditStruckTime: TSpinEdit;
    CheckBoxDisableStruck: TCheckBox;
    GroupBox8: TGroupBox;
    Label23: TLabel;
    EditKillMonExpMultiple: TSpinEdit;
    CheckBoxHighLevelKillMonFixExp: TCheckBox;
    ButtonExpSave: TButton;
    CastleSheet: TTabSheet;
    GroupBox9: TGroupBox;
    Label24: TLabel;
    EditRepairDoorPrice: TSpinEdit;
    Label25: TLabel;
    EditRepairWallPrice: TSpinEdit;
    Label26: TLabel;
    EditHireArcherPrice: TSpinEdit;
    Label27: TLabel;
    EditHireGuardPrice: TSpinEdit;
    GroupBox10: TGroupBox;
    Label31: TLabel;
    Label32: TLabel;
    EditCastleGoldMax: TSpinEdit;
    EditCastleOneDayGold: TSpinEdit;
    GroupBox11: TGroupBox;
    Label28: TLabel;
    Label29: TLabel;
    EditCastleHomeX: TSpinEdit;
    Label30: TLabel;
    EditCastleHomeY: TSpinEdit;
    EditCastleHomeMap: TEdit;
    GroupBox12: TGroupBox;
    Label34: TLabel;
    Label35: TLabel;
    EditWarRangeX: TSpinEdit;
    EditWarRangeY: TSpinEdit;
    ButtonCastleSave: TButton;
    GroupBox13: TGroupBox;
    Label36: TLabel;
    EditTaxRate: TSpinEdit;
    CheckBoxGetAllNpcTax: TCheckBox;
    GroupBox14: TGroupBox;
    Label33: TLabel;
    EditCastleName: TEdit;
    GroupBoxLevelExp: TGroupBox;
    ComboBoxLevelExp: TComboBox;
    GridLevelExp: TStringGrid;
    Label37: TLabel;
    GroupBox15: TGroupBox;
    Label38: TLabel;
    EditOverSpeedKickCount: TSpinEdit;
    CheckBoxboKickOverSpeed: TCheckBox;
    TabSheet1: TTabSheet;
    ButtonOptionSave: TButton;
    GroupBox16: TGroupBox;
    EditSafeZoneSize: TSpinEdit;
    Label39: TLabel;
    GroupBox18: TGroupBox;
    Label40: TLabel;
    EditStartPointSize: TSpinEdit;
    GroupBox20: TGroupBox;
    EditRedHomeX: TSpinEdit;
    Label42: TLabel;
    Label43: TLabel;
    EditRedHomeY: TSpinEdit;
    Label44: TLabel;
    EditRedHomeMap: TEdit;
    GroupBox21: TGroupBox;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    EditRedDieHomeX: TSpinEdit;
    EditRedDieHomeY: TSpinEdit;
    EditRedDieHomeMap: TEdit;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox17: TGroupBox;
    CheckBoxDisHumRun: TCheckBox;
    CheckBoxRunHum: TCheckBox;
    CheckBoxRunMon: TCheckBox;
    CheckBoxWarDisHumRun: TCheckBox;
    CheckBoxRunNpc: TCheckBox;
    ButtonOptionSave3: TButton;
    GroupBox22: TGroupBox;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    EditHomeX: TSpinEdit;
    EditHomeY: TSpinEdit;
    EditHomeMap: TEdit;
    ButtonOptionSave2: TButton;
    GroupBox23: TGroupBox;
    Label51: TLabel;
    Label52: TLabel;
    EditDecPkPointTime: TSpinEdit;
    EditDecPkPointCount: TSpinEdit;
    Label53: TLabel;
    GroupBox24: TGroupBox;
    Label54: TLabel;
    EditPKFlagTime: TSpinEdit;
    GroupBox25: TGroupBox;
    Label55: TLabel;
    EditKillHumanAddPKPoint: TSpinEdit;
    TabSheet4: TTabSheet;
    GroupBox28: TGroupBox;
    CheckBoxTestServer: TCheckBox;
    CheckBoxServiceMode: TCheckBox;
    CheckBoxVentureMode: TCheckBox;
    CheckBoxNonPKMode: TCheckBox;
    GroupBox29: TGroupBox;
    GroupBox30: TGroupBox;
    Label60: TLabel;
    EditStartPermission: TSpinEdit;
    ButtonOptionSave0: TButton;
    EditTestLevel: TSpinEdit;
    Label61: TLabel;
    EditTestGold: TSpinEdit;
    Label62: TLabel;
    EditTestUserLimit: TSpinEdit;
    Label63: TLabel;
    GroupBox31: TGroupBox;
    Label64: TLabel;
    EditUserFull: TSpinEdit;
    GroupBox32: TGroupBox;
    CheckBoxKillHumanWinLevel: TCheckBox;
    CheckBoxKilledLostLevel: TCheckBox;
    CheckBoxKilledLostExp: TCheckBox;
    CheckBoxKillHumanWinExp: TCheckBox;
    Label58: TLabel;
    EditKillHumanWinLevel: TSpinEdit;
    Label65: TLabel;
    EditKilledLostLevel: TSpinEdit;
    Label66: TLabel;
    EditKillHumanWinExp: TSpinEdit;
    EditKillHumanLostExp: TSpinEdit;
    Label56: TLabel;
    Label67: TLabel;
    EditHumanLevelDiffer: TSpinEdit;
    GroupBox33: TGroupBox;
    Label68: TLabel;
    EditHumanMaxGold: TSpinEdit;
    EditHumanTryModeMaxGold: TSpinEdit;
    Label69: TLabel;
    GroupBox34: TGroupBox;
    Label70: TLabel;
    EditTryModeLevel: TSpinEdit;
    CheckBoxTryModeUseStorage: TCheckBox;
    GroupBox35: TGroupBox;
    CheckBoxShowMakeItemMsg: TCheckBox;
    CbViewHack: TCheckBox;
    CkViewAdmfail: TCheckBox;
    TabSheet5: TTabSheet;
    GroupBox36: TGroupBox;
    Label71: TLabel;
    EditSayMsgMaxLen: TSpinEdit;
    Label72: TLabel;
    EditSayRedMsgMaxLen: TSpinEdit;
    GroupBox37: TGroupBox;
    Label73: TLabel;
    EditCanShoutMsgLevel: TSpinEdit;
    GroupBox38: TGroupBox;
    Label75: TLabel;
    CheckBoxShutRedMsgShowGMName: TCheckBox;
    EditGMRedMsgCmd: TEdit;
    ButtonMsgSave: TButton;
    TabSheet6: TTabSheet;
    GroupBox39: TGroupBox;
    Label74: TLabel;
    EditStartCastleWarDays: TSpinEdit;
    GroupBox40: TGroupBox;
    Label76: TLabel;
    EditStartCastlewarTime: TSpinEdit;
    Label77: TLabel;
    Label78: TLabel;
    GroupBox41: TGroupBox;
    Label79: TLabel;
    EditShowCastleWarEndMsgTime: TSpinEdit;
    Label80: TLabel;
    GroupBox42: TGroupBox;
    Label81: TLabel;
    Label82: TLabel;
    EditCastleWarTime: TSpinEdit;
    GroupBox43: TGroupBox;
    Label83: TLabel;
    Label84: TLabel;
    EditGetCastleTime: TSpinEdit;
    GroupBox44: TGroupBox;
    Label85: TLabel;
    Label86: TLabel;
    EditSaveHumanRcdTime: TSpinEdit;
    GroupBox45: TGroupBox;
    Label87: TLabel;
    Label88: TLabel;
    EditHumanFreeDelayTime: TSpinEdit;
    GroupBox46: TGroupBox;
    Label89: TLabel;
    Label90: TLabel;
    EditMakeGhostTime: TSpinEdit;
    Label91: TLabel;
    EditClearDropOnFloorItemTime: TSpinEdit;
    Label92: TLabel;
    GroupBox47: TGroupBox;
    Label93: TLabel;
    Label94: TLabel;
    EditFloorItemCanPickUpTime: TSpinEdit;
    ButtonTimeSave: TButton;
    TabSheet7: TTabSheet;
    GroupBox48: TGroupBox;
    Label95: TLabel;
    EditBuildGuildPrice: TSpinEdit;
    GroupBox49: TGroupBox;
    Label96: TLabel;
    EditGuildWarPrice: TSpinEdit;
    GroupBox50: TGroupBox;
    Label97: TLabel;
    EditMakeDurgPrice: TSpinEdit;
    ButtonPriceSave: TButton;
    GroupBox51: TGroupBox;
    Label98: TLabel;
    EditSendOnlineCountRate: TSpinEdit;
    Label99: TLabel;
    EditSendOnlineTime: TSpinEdit;
    CheckBoxSendOnlineCount: TCheckBox;
    Label100: TLabel;
    GroupBox52: TGroupBox;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    EditMonsterPowerRate: TSpinEdit;
    EditEditItemsPowerRate: TSpinEdit;
    EditItemsACPowerRate: TSpinEdit;
    GroupBox53: TGroupBox;
    Label20: TLabel;
    Label104: TLabel;
    EditTryDealTime: TSpinEdit;
    EditDealOKTime: TSpinEdit;
    Label105: TLabel;
    Label106: TLabel;
    GroupBox54: TGroupBox;
    Label107: TLabel;
    EditCastleMemberPriceRate: TSpinEdit;
    TabSheet8: TTabSheet;
    ButtonMsgColorSave: TButton;
    GroupBox55: TGroupBox;
    Label108: TLabel;
    Label109: TLabel;
    EditHearMsgFColor: TSpinEdit;
    EdittHearMsgBColor: TSpinEdit;
    LabeltHearMsgFColor: TLabel;
    LabelHearMsgBColor: TLabel;
    GroupBox56: TGroupBox;
    Label110: TLabel;
    Label111: TLabel;
    LabelWhisperMsgFColor: TLabel;
    LabelWhisperMsgBColor: TLabel;
    EditWhisperMsgFColor: TSpinEdit;
    EditWhisperMsgBColor: TSpinEdit;
    GroupBox57: TGroupBox;
    Label112: TLabel;
    Label113: TLabel;
    LabelGMWhisperMsgFColor: TLabel;
    LabelGMWhisperMsgBColor: TLabel;
    EditGMWhisperMsgFColor: TSpinEdit;
    EditGMWhisperMsgBColor: TSpinEdit;
    GroupBox58: TGroupBox;
    Label116: TLabel;
    Label117: TLabel;
    LabelRedMsgFColor: TLabel;
    LabelRedMsgBColor: TLabel;
    EditRedMsgFColor: TSpinEdit;
    EditRedMsgBColor: TSpinEdit;
    GroupBox59: TGroupBox;
    Label120: TLabel;
    Label121: TLabel;
    LabelGreenMsgFColor: TLabel;
    LabelGreenMsgBColor: TLabel;
    EditGreenMsgFColor: TSpinEdit;
    EditGreenMsgBColor: TSpinEdit;
    GroupBox60: TGroupBox;
    Label124: TLabel;
    Label125: TLabel;
    LabelBlueMsgFColor: TLabel;
    LabelBlueMsgBColor: TLabel;
    EditBlueMsgFColor: TSpinEdit;
    EditBlueMsgBColor: TSpinEdit;
    GroupBox61: TGroupBox;
    Label128: TLabel;
    Label129: TLabel;
    LabelCryMsgFColor: TLabel;
    LabelCryMsgBColor: TLabel;
    EditCryMsgFColor: TSpinEdit;
    EditCryMsgBColor: TSpinEdit;
    GroupBox62: TGroupBox;
    Label132: TLabel;
    Label133: TLabel;
    LabelGuildMsgFColor: TLabel;
    LabelGuildMsgBColor: TLabel;
    EditGuildMsgFColor: TSpinEdit;
    EditGuildMsgBColor: TSpinEdit;
    GroupBox63: TGroupBox;
    Label136: TLabel;
    Label137: TLabel;
    LabelGroupMsgFColor: TLabel;
    LabelGroupMsgBColor: TLabel;
    EditGroupMsgFColor: TSpinEdit;
    EditGroupMsgBColor: TSpinEdit;
    CheckBoxPKLevelProtect: TCheckBox;
    Label114: TLabel;
    EditPKProtectLevel: TSpinEdit;
    GroupBox26: TGroupBox;
    Label57: TLabel;
    EditPosionDecHealthTime: TSpinEdit;
    GroupBox27: TGroupBox;
    Label59: TLabel;
    EditPosionDamagarmor: TSpinEdit;
    Label115: TLabel;
    EditRedPKProtectLevel: TSpinEdit;
    GroupBox19: TGroupBox;
    Label41: TLabel;
    EditGroupMembersMax: TSpinEdit;
    CheckBoxDisableSelfStruck: TCheckBox;
    CheckBoxCanNotGetBackDeal: TCheckBox;
    CheckBoxDisableDeal: TCheckBox;
    GroupBox64: TGroupBox;
    Label118: TLabel;
    EditCanDropPrice: TSpinEdit;
    CheckBoxControlDropItem: TCheckBox;
    Label119: TLabel;
    EditCanDropGold: TSpinEdit;
    CheckBoxIsSafeDisableDrop: TCheckBox;
    GroupBox65: TGroupBox;
    Label122: TLabel;
    Label123: TLabel;
    LabelCustMsgFColor: TLabel;
    LabelCustMsgBColor: TLabel;
    EditCustMsgFColor: TSpinEdit;
    EditCustMsgBColor: TSpinEdit;
    GroupBox66: TGroupBox;
    Label126: TLabel;
    EditSuperRepairPriceRate: TSpinEdit;
    Label127: TLabel;
    EditRepairItemDecDura: TSpinEdit;
    TabSheet9: TTabSheet;
    ButtonHumanDieSave: TButton;
    GroupBox67: TGroupBox;
    CheckBoxKillByMonstDropUseItem: TCheckBox;
    CheckBoxKillByHumanDropUseItem: TCheckBox;
    CheckBoxDieScatterBag: TCheckBox;
    CheckBoxDieDropGold: TCheckBox;
    CheckBoxDieRedScatterBagAll: TCheckBox;
    GroupBox69: TGroupBox;
    Label130: TLabel;
    Label131: TLabel;
    Label134: TLabel;
    ScrollBarDieDropUseItemRate: TScrollBar;
    EditDieDropUseItemRate: TEdit;
    ScrollBarDieRedDropUseItemRate: TScrollBar;
    EditDieRedDropUseItemRate: TEdit;
    ScrollBarDieScatterBagRate: TScrollBar;
    EditDieScatterBagRate: TEdit;
    CheckBoxGMRunAll: TCheckBox;
    GroupBox68: TGroupBox;
    Label135: TLabel;
    Label138: TLabel;
    EditSayMsgTime: TSpinEdit;
    EditSayMsgCount: TSpinEdit;
    Label139: TLabel;
    EditDisableSayMsgTime: TSpinEdit;
    Label140: TLabel;
    Label141: TLabel;
    Label142: TLabel;
    EditDropOverSpeed: TSpinEdit;
    GroupBox70: TGroupBox;
    Label143: TLabel;
    Label144: TLabel;
    EditGuildWarTime: TSpinEdit;
    GroupBox71: TGroupBox;
    CheckBoxShowPreFixMsg: TCheckBox;
    CheckBoxShowExceptionMsg: TCheckBox;
    TabSheet10: TTabSheet;
    ButtonCharStatusSave: TButton;
    GroupBox72: TGroupBox;
    CheckBoxParalyCanRun: TCheckBox;
    CheckBoxParalyCanWalk: TCheckBox;
    CheckBoxParalyCanHit: TCheckBox;
    CheckBoxParalyCanSpell: TCheckBox;
    ButtonGameSpeedDefault: TButton;
    GroupBox73: TGroupBox;
    CheckBoxCanOldClientLogon: TCheckBox;
    CheckBoxSpellSendUpdateMsg: TCheckBox;
    CheckBoxActionSendActionMsg: TCheckBox;
    RadioButtonDelyMode: TRadioButton;
    RadioButtonFilterMode: TRadioButton;
    ButtonActionSpeedConfig: TButton;
    CheckBoxRunGuard: TCheckBox;
    CheckBoxSZRunAll: TCheckBox;
    procedure EditHitIntervalTimeChange(Sender: TObject);
    procedure EditMagicHitIntervalTimeChange(Sender: TObject);
    procedure EditRunIntervalTimeChange(Sender: TObject);
    procedure EditWalkIntervalTimeChange(Sender: TObject);
    procedure EditTurnIntervalTimeChange(Sender: TObject);
    procedure EditMaxHitMsgCountChange(Sender: TObject);
    procedure EditMaxSpellMsgCountChange(Sender: TObject);
    procedure EditMaxRunMsgCountChange(Sender: TObject);
    procedure EditMaxWalkMsgCountChange(Sender: TObject);
    procedure EditMaxTurnMsgCountChange(Sender: TObject);
    procedure EditMaxDigUpMsgCountChange(Sender: TObject);
    procedure EditItemSpeedTimeChange(Sender: TObject);
    procedure ButtonGameSpeedSaveClick(Sender: TObject);
    procedure GameConfigControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure EditConsoleShowUserCountTimeChange(Sender: TObject);
    procedure EditShowLineNoticeTimeChange(Sender: TObject);
    procedure ComboBoxLineNoticeColorChange(Sender: TObject);
    procedure EditSoftVersionDateChange(Sender: TObject);
    procedure ButtonGeneralSaveClick(Sender: TObject);
    procedure EditLineNoticePreFixChange(Sender: TObject);
    procedure CheckBoxDisableStruckClick(Sender: TObject);
    procedure EditStruckTimeChange(Sender: TObject);
    procedure EditKillMonExpMultipleChange(Sender: TObject);
    procedure CheckBoxHighLevelKillMonFixExpClick(Sender: TObject);
    procedure ButtonExpSaveClick(Sender: TObject);
    procedure EditRepairDoorPriceChange(Sender: TObject);
    procedure EditRepairWallPriceChange(Sender: TObject);
    procedure EditHireArcherPriceChange(Sender: TObject);
    procedure EditHireGuardPriceChange(Sender: TObject);
    procedure EditCastleGoldMaxChange(Sender: TObject);
    procedure EditCastleOneDayGoldChange(Sender: TObject);
    procedure EditCastleHomeMapChange(Sender: TObject);
    procedure EditCastleHomeXChange(Sender: TObject);
    procedure EditCastleHomeYChange(Sender: TObject);
    procedure EditCastleNameChange(Sender: TObject);
    procedure EditWarRangeXChange(Sender: TObject);
    procedure EditWarRangeYChange(Sender: TObject);
    procedure CheckBoxGetAllNpcTaxClick(Sender: TObject);
    procedure EditTaxRateChange(Sender: TObject);
    procedure ButtonCastleSaveClick(Sender: TObject);
    procedure GridLevelExpSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure ComboBoxLevelExpClick(Sender: TObject);
    procedure EditOverSpeedKickCountChange(Sender: TObject);
    procedure CheckBoxboKickOverSpeedClick(Sender: TObject);
    procedure CheckBoxDisHumRunClick(Sender: TObject);
    procedure ButtonOptionSaveClick(Sender: TObject);
    procedure CheckBoxRunHumClick(Sender: TObject);
    procedure CheckBoxRunMonClick(Sender: TObject);
    procedure CheckBoxWarDisHumRunClick(Sender: TObject);
    procedure CheckBoxRunNpcClick(Sender: TObject);
    procedure EditSafeZoneSizeChange(Sender: TObject);
    procedure EditStartPointSizeChange(Sender: TObject);
    procedure EditGroupMembersMaxChange(Sender: TObject);
    procedure EditRedHomeXChange(Sender: TObject);
    procedure EditRedHomeYChange(Sender: TObject);
    procedure EditRedHomeMapChange(Sender: TObject);
    procedure EditRedDieHomeMapChange(Sender: TObject);
    procedure EditRedDieHomeXChange(Sender: TObject);
    procedure EditRedDieHomeYChange(Sender: TObject);
    procedure ButtonOptionSave3Click(Sender: TObject);
    procedure EditHomeMapChange(Sender: TObject);
    procedure EditHomeXChange(Sender: TObject);
    procedure EditHomeYChange(Sender: TObject);
    procedure EditDecPkPointTimeChange(Sender: TObject);
    procedure EditDecPkPointCountChange(Sender: TObject);
    procedure EditPKFlagTimeChange(Sender: TObject);
    procedure EditKillHumanAddPKPointChange(Sender: TObject);
    procedure ButtonOptionSave2Click(Sender: TObject);
    procedure EditPosionDecHealthTimeChange(Sender: TObject);
    procedure EditPosionDamagarmorChange(Sender: TObject);
    procedure CheckBoxTestServerClick(Sender: TObject);
    procedure CheckBoxServiceModeClick(Sender: TObject);
    procedure CheckBoxVentureModeClick(Sender: TObject);
    procedure CheckBoxNonPKModeClick(Sender: TObject);
    procedure EditTestLevelChange(Sender: TObject);
    procedure EditTestGoldChange(Sender: TObject);
    procedure EditTestUserLimitChange(Sender: TObject);
    procedure EditStartPermissionChange(Sender: TObject);
    procedure EditUserFullChange(Sender: TObject);
    procedure ButtonOptionSave0Click(Sender: TObject);
    procedure CheckBoxKillHumanWinLevelClick(Sender: TObject);
    procedure CheckBoxKilledLostLevelClick(Sender: TObject);
    procedure CheckBoxKillHumanWinExpClick(Sender: TObject);
    procedure CheckBoxKilledLostExpClick(Sender: TObject);
    procedure EditKillHumanWinLevelChange(Sender: TObject);
    procedure EditKilledLostLevelChange(Sender: TObject);
    procedure EditKillHumanWinExpChange(Sender: TObject);
    procedure EditKillHumanLostExpChange(Sender: TObject);
    procedure EditHumanLevelDifferChange(Sender: TObject);
    procedure EditHumanMaxGoldChange(Sender: TObject);
    procedure EditHumanTryModeMaxGoldChange(Sender: TObject);
    procedure EditTryModeLevelChange(Sender: TObject);
    procedure CheckBoxTryModeUseStorageClick(Sender: TObject);
    procedure CheckBoxShowMakeItemMsgClick(Sender: TObject);
    procedure CbViewHackClick(Sender: TObject);
    procedure CkViewAdmfailClick(Sender: TObject);
    procedure EditSayMsgMaxLenChange(Sender: TObject);
    procedure EditSayRedMsgMaxLenChange(Sender: TObject);
    procedure EditCanShoutMsgLevelChange(Sender: TObject);
    procedure CheckBoxShutRedMsgShowGMNameClick(Sender: TObject);
    procedure EditGMRedMsgCmdChange(Sender: TObject);
    procedure ButtonMsgSaveClick(Sender: TObject);
    procedure EditStartCastleWarDaysChange(Sender: TObject);
    procedure EditStartCastlewarTimeChange(Sender: TObject);
    procedure EditShowCastleWarEndMsgTimeChange(Sender: TObject);
    procedure EditCastleWarTimeChange(Sender: TObject);
    procedure EditGetCastleTimeChange(Sender: TObject);
    procedure EditMakeGhostTimeChange(Sender: TObject);
    procedure EditClearDropOnFloorItemTimeChange(Sender: TObject);
    procedure EditSaveHumanRcdTimeChange(Sender: TObject);
    procedure EditHumanFreeDelayTimeChange(Sender: TObject);
    procedure EditFloorItemCanPickUpTimeChange(Sender: TObject);
    procedure ButtonTimeSaveClick(Sender: TObject);
    procedure EditBuildGuildPriceChange(Sender: TObject);
    procedure EditGuildWarPriceChange(Sender: TObject);
    procedure EditMakeDurgPriceChange(Sender: TObject);
    procedure ButtonPriceSaveClick(Sender: TObject);
    procedure CheckBoxSendOnlineCountClick(Sender: TObject);
    procedure EditSendOnlineCountRateChange(Sender: TObject);
    procedure EditSendOnlineTimeChange(Sender: TObject);
    procedure EditMonsterPowerRateChange(Sender: TObject);
    procedure EditEditItemsPowerRateChange(Sender: TObject);
    procedure EditItemsACPowerRateChange(Sender: TObject);
    procedure EditTryDealTimeChange(Sender: TObject);
    procedure EditDealOKTimeChange(Sender: TObject);
    procedure EditCastleMemberPriceRateChange(Sender: TObject);
    procedure EditHearMsgFColorChange(Sender: TObject);
    procedure EdittHearMsgBColorChange(Sender: TObject);
    procedure EditWhisperMsgFColorChange(Sender: TObject);
    procedure EditWhisperMsgBColorChange(Sender: TObject);
    procedure EditGMWhisperMsgFColorChange(Sender: TObject);
    procedure EditGMWhisperMsgBColorChange(Sender: TObject);
    procedure EditRedMsgFColorChange(Sender: TObject);
    procedure EditRedMsgBColorChange(Sender: TObject);
    procedure EditGreenMsgFColorChange(Sender: TObject);
    procedure EditGreenMsgBColorChange(Sender: TObject);
    procedure EditBlueMsgFColorChange(Sender: TObject);
    procedure EditBlueMsgBColorChange(Sender: TObject);
    procedure EditCryMsgFColorChange(Sender: TObject);
    procedure EditCryMsgBColorChange(Sender: TObject);
    procedure EditGuildMsgFColorChange(Sender: TObject);
    procedure EditGuildMsgBColorChange(Sender: TObject);
    procedure EditGroupMsgFColorChange(Sender: TObject);
    procedure EditGroupMsgBColorChange(Sender: TObject);
    procedure ButtonMsgColorSaveClick(Sender: TObject);
    procedure CheckBoxPKLevelProtectClick(Sender: TObject);
    procedure EditPKProtectLevelChange(Sender: TObject);
    procedure EditRedPKProtectLevelChange(Sender: TObject);
    procedure CheckBoxDisableSelfStruckClick(Sender: TObject);
    procedure CheckBoxCanNotGetBackDealClick(Sender: TObject);
    procedure CheckBoxDisableDealClick(Sender: TObject);
    procedure CheckBoxControlDropItemClick(Sender: TObject);
    procedure EditCanDropPriceChange(Sender: TObject);
    procedure EditCanDropGoldChange(Sender: TObject);
    procedure CheckBoxIsSafeDisableDropClick(Sender: TObject);
    procedure EditCustMsgFColorChange(Sender: TObject);
    procedure EditCustMsgBColorChange(Sender: TObject);
    procedure EditSuperRepairPriceRateChange(Sender: TObject);
    procedure EditRepairItemDecDuraChange(Sender: TObject);
    procedure ButtonHumanDieSaveClick(Sender: TObject);
    procedure ScrollBarDieDropUseItemRateChange(Sender: TObject);
    procedure ScrollBarDieRedDropUseItemRateChange(Sender: TObject);
    procedure ScrollBarDieScatterBagRateChange(Sender: TObject);
    procedure CheckBoxKillByMonstDropUseItemClick(Sender: TObject);
    procedure CheckBoxKillByHumanDropUseItemClick(Sender: TObject);
    procedure CheckBoxDieScatterBagClick(Sender: TObject);
    procedure CheckBoxDieDropGoldClick(Sender: TObject);
    procedure CheckBoxDieRedScatterBagAllClick(Sender: TObject);
    procedure CheckBoxGMRunAllClick(Sender: TObject);
    procedure EditSayMsgTimeChange(Sender: TObject);
    procedure EditSayMsgCountChange(Sender: TObject);
    procedure EditDisableSayMsgTimeChange(Sender: TObject);
    procedure EditDropOverSpeedChange(Sender: TObject);
    procedure EditGuildWarTimeChange(Sender: TObject);
    procedure CheckBoxShowPreFixMsgClick(Sender: TObject);
    procedure CheckBoxShowExceptionMsgClick(Sender: TObject);
    procedure CheckBoxParalyCanRunClick(Sender: TObject);
    procedure CheckBoxParalyCanWalkClick(Sender: TObject);
    procedure CheckBoxParalyCanHitClick(Sender: TObject);
    procedure CheckBoxParalyCanSpellClick(Sender: TObject);
    procedure ButtonCharStatusSaveClick(Sender: TObject);
    procedure ButtonGameSpeedDefaultClick(Sender: TObject);
    procedure CheckBoxCanOldClientLogonClick(Sender: TObject);
    procedure CheckBoxSpellSendUpdateMsgClick(Sender: TObject);
    procedure CheckBoxActionSendActionMsgClick(Sender: TObject);
    procedure RadioButtonDelyModeClick(Sender: TObject);
    procedure RadioButtonFilterModeClick(Sender: TObject);
    procedure EditTestLevelKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonActionSpeedConfigClick(Sender: TObject);
    procedure CheckBoxRunGuardClick(Sender: TObject);
    procedure CheckBoxSZRunAllClick(Sender: TObject);
  private
    boOpened:Boolean;
    boModValued:Boolean;
    procedure ModValue();
    procedure uModValue();
    procedure RefGameSpeedConf();
    procedure RefCharStatusConf();
    procedure RefGameVarConf();
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmGameConfig: TfrmGameConfig;

implementation

uses M2Share, HUtil32, SDK, ActionSpeedConfig;

{$R *.dfm}

{ TfrmGameConfig }

procedure TfrmGameConfig.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  ComboBoxLineNoticeColor.Items.Add('红色');
  ComboBoxLineNoticeColor.Items.Add('绿色');
  ComboBoxLineNoticeColor.Items.Add('蓝色');
  GridLevelExp.ColWidths[0]:=30;
  GridLevelExp.ColWidths[1]:=100;
  GridLevelExp.Cells[0,0]:='等级';
  GridLevelExp.Cells[1,0]:='经验值';
  for I := 1 to GridLevelExp.RowCount - 1 do begin
    GridLevelExp.Cells[0,I]:=IntToStr(I);
  end;

  ComboBoxLevelExp.AddItem('原始经验值',TObject(s_OldLevelExp));
  ComboBoxLevelExp.AddItem('标准经验值',TObject(s_StdLevelExp));
  ComboBoxLevelExp.AddItem('当前1/2倍经验',TObject(s_2Mult));
  ComboBoxLevelExp.AddItem('当前1/5倍经验',TObject(s_5Mult));
  ComboBoxLevelExp.AddItem('当前1/8倍经验',TObject(s_8Mult));
  ComboBoxLevelExp.AddItem('当前1/10倍经验',TObject(s_10Mult));
  ComboBoxLevelExp.AddItem('当前1/20倍经验',TObject(s_20Mult));
  ComboBoxLevelExp.AddItem('当前1/30倍经验',TObject(s_30Mult));
  ComboBoxLevelExp.AddItem('当前1/40倍经验',TObject(s_40Mult));
  ComboBoxLevelExp.AddItem('当前1/50倍经验',TObject(s_50Mult));
  ComboBoxLevelExp.AddItem('当前1/60倍经验',TObject(s_60Mult));
  ComboBoxLevelExp.AddItem('当前1/70倍经验',TObject(s_70Mult));
  ComboBoxLevelExp.AddItem('当前1/80倍经验',TObject(s_80Mult));
  ComboBoxLevelExp.AddItem('当前1/90倍经验',TObject(s_90Mult));
  ComboBoxLevelExp.AddItem('当前1/100倍经验',TObject(s_100Mult));
  ComboBoxLevelExp.AddItem('当前1/150倍经验',TObject(s_150Mult));
  ComboBoxLevelExp.AddItem('当前1/200倍经验',TObject(s_200Mult));
  ComboBoxLevelExp.AddItem('当前1/250倍经验',TObject(s_250Mult));
  ComboBoxLevelExp.AddItem('当前1/300倍经验',TObject(s_300Mult));


  EditSoftVersionDate.Hint:='客户端版本日期设置，此参数默认为 20020522，此版本日期必须与客户端相匹配，否则在进入游戏时将提示版本不正确';
  EditConsoleShowUserCountTime.Hint:='程序控制台上显示当前在线人数间隔时间，此参数默认为 10分钟。';
  EditShowLineNoticeTime.Hint:='游戏中显示公告信息的间隔时间，此参数默认为 300秒。';
  ComboBoxLineNoticeColor.Hint:='游戏中显示公告信息的文字颜色，此参数默认为 蓝色。';
  EditLineNoticePreFix.Hint:='游戏中显示公告信息的文字行前缀文字。';
  EditHitIntervalTime.Hint:='游戏中人物二次攻击间隔时间，此参数默认为 900毫秒。';
  EditMagicHitIntervalTime.Hint:='游戏中人物二次魔法攻击间隔时间，此参数默认为 800毫秒。';
  EditRunIntervalTime.Hint:='游戏中人物二次跑动间隔时间，此参数默认为 600毫秒。';
  EditWalkIntervalTime.Hint:='游戏中人物二次走动间隔时间，此参数默认为 600毫秒。';
  EditTurnIntervalTime.Hint:='游戏中人物二次变方向间隔时间，此参数默认为 600毫秒。';
  EditItemSpeedTime.Hint:='装备加速属性速度控制，数字越小控制越严，此参数默认为 50毫秒。';

  EditStruckTime.Hint:='人物被攻击后弯腰停留时间控制，此参数默认为 100毫秒。';
  CheckBoxDisableStruck.Hint:='人物在被攻击后是否显示弯腰动作。';

  GridLevelExp.Hint:='修改的经验在点击保存按钮后生效。';
  ComboBoxLevelExp.Hint:='选择的经验计划，立即生效。';
  EditKillMonExpMultiple.Hint:='人物杀怪物所得经验值倍，此参数默认为 1，此经验值以怪物数据库里的经验值为基准。';
  CheckBoxHighLevelKillMonFixExp.Hint:='高等级人物杀怪经验是否保持不变，此参数默认为关闭(不打钩)。';
  EditRepairDoorPrice.Hint:='维修城门所需费用，此参数默认为 2000000金币。';
  EditRepairWallPrice.Hint:='维修城墙所需费用，此参数默认为 500000金币。';
  EditHireArcherPrice.Hint:='雇用弓箭手所需费用，此参数默认为 300000金币。';
  EditHireGuardPrice.Hint:='维修守卫所需费用，此参数默认为 300000金币。';
  EditCastleGoldMax.Hint:='城堡内最高可存金币数量，此参数默认为 10000000金币。';
  EditCastleOneDayGold.Hint:='城堡一天内最高收入上限，此参数默认为 2000000金币。';
  EditCastleHomeMap.Hint:='行会回城点默认所在地图号，此参数默认地图号为 3，以城堡配置文件中的参数为准';
  EditCastleHomeX.Hint:='行会回城点默认所在地图座标X，此参数默认座标为 644，以城堡配置文件中的参数为准';
  EditCastleHomeY.Hint:='行会回城点默认所在地图座标Y，此参数默认座标为 290，以城堡配置文件中的参数为准';
  EditCastleName.Hint:='城堡默认的名称，以城堡配置文件中的参数为准。';
  EditWarRangeX.Hint:='攻城区域默认座标X范围大小，此参数默认为 100，以城堡配置文件中的参数为准';
  EditWarRangeY.Hint:='攻城区域默认座标Y范围大小，此参数默认为 100，以城堡配置文件中的参数为准';
  CheckBoxGetAllNpcTax.Hint:='是否收取所有交易NPC的交易税，此参数默认为关闭(不打钩)。';
  EditTaxRate.Hint:='交易税率，此参为默认为 5，也就是 0.05%。';
{$IF SoftVersion = VERDEMO}
  Caption:='游戏参数[演示版本，所有设置调整有效，但不能保存]'
{$IFEND}

end;

procedure TfrmGameConfig.GameConfigControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if boModValued then begin
    if Application.MessageBox('参数设置已经被修改，是否确认不保存修改的设置？','确认信息',MB_YESNO + MB_ICONQUESTION) = IDYES then begin
      uModValue
    end else AllowChange:=False;
  end;
end;
procedure TfrmGameConfig.ModValue;
begin
  boModValued:=True;
  ButtonGameSpeedSave.Enabled:=True;
  ButtonGeneralSave.Enabled:=True;
  ButtonExpSave.Enabled:=True;
  ButtonCastleSave.Enabled:=True;
  ButtonOptionSave0.Enabled:=True;
  ButtonOptionSave.Enabled:=True;
  ButtonOptionSave2.Enabled:=True;
  ButtonOptionSave3.Enabled:=True;
  ButtonTimeSave.Enabled:=True;
  ButtonPriceSave.Enabled:=True;
  ButtonMsgSave.Enabled:=True;
  ButtonMsgColorSave.Enabled:=True;
  ButtonHumanDieSave.Enabled:=True;
  ButtonCharStatusSave.Enabled:=True;
end;

procedure TfrmGameConfig.uModValue;
begin
  boModValued:=False;
  ButtonGameSpeedSave.Enabled:=False;
  ButtonGeneralSave.Enabled:=False;
  ButtonExpSave.Enabled:=False;
  ButtonCastleSave.Enabled:=False;
  ButtonOptionSave0.Enabled:=False;
  ButtonOptionSave.Enabled:=False;
  ButtonOptionSave2.Enabled:=False;
  ButtonOptionSave3.Enabled:=False;
  ButtonTimeSave.Enabled:=False;
  ButtonPriceSave.Enabled:=False;
  ButtonMsgSave.Enabled:=False;
  ButtonMsgColorSave.Enabled:=False;
  ButtonHumanDieSave.Enabled:=False;
  ButtonCharStatusSave.Enabled:=False;
end;

procedure TfrmGameConfig.Open;
var
  I: Integer;
begin
  boOpened:=False;
  uModValue();
  RefGameSpeedConf();


  EditKillMonExpMultiple.Value:=g_Config.dwKillMonExpMultiple;
  CheckBoxHighLevelKillMonFixExp.Checked:=g_Config.boHighLevelKillMonFixExp;

  EditRepairDoorPrice.Value:=g_Config.nRepairDoorPrice;
  EditRepairWallPrice.Value:=g_Config.nRepairWallPrice;
  EditHireArcherPrice.Value:=g_Config.nHireArcherPrice;
  EditHireGuardPrice.Value:=g_Config.nHireGuardPrice;

  EditCastleGoldMax.Value:=g_Config.nCastleGoldMax;
  EditCastleOneDayGold.Value:=g_Config.nCastleOneDayGold;
  EditCastleHomeMap.Text:=g_Config.sCastleHomeMap;
  EditCastleHomeX.Value:=g_Config.nCastleHomeX;
  EditCastleHomeY.Value:=g_Config.nCastleHomeY;
  EditCastleName.Text:=g_Config.sCastleName;
  EditWarRangeX.Value:=g_Config.nCastleWarRangeX;
  EditWarRangeY.Value:=g_Config.nCastleWarRangeY;
  CheckBoxGetAllNpcTax.Checked:=g_Config.boGetAllNpcTax;
  EditTaxRate.Value:=g_Config.nCastleTaxRate;

  for I := 1 to GridLevelExp.RowCount - 1 do begin
    GridLevelExp.Cells[1,I]:=IntToStr(g_Config.dwNeedExps[I]);
  end;
  GroupBoxLevelExp.Caption:=format('升级经验(最高有效等级%d)',[MAXUPLEVEL]);

  CheckBoxDisHumRun.Checked:= not g_Config.boDiableHumanRun;


  CheckBoxRunHum.Checked:=g_Config.boRunHuman;
  CheckBoxRunMon.Checked:=g_Config.boRunMon;
  CheckBoxRunNpc.Checked:=g_Config.boRunNpc;
  CheckBoxRunGuard.Checked:=g_Config.boRunGuard;
  CheckBoxWarDisHumRun.Checked:=g_Config.boWarDisHumRun;
  CheckBoxGMRunAll.Checked:=g_Config.boGMRunAll;
  CheckBoxDisHumRunClick(CheckBoxDisHumRun);

  EditSafeZoneSize.Value:=g_Config.nSafeZoneSize;
  EditStartPointSize.Value:=g_Config.nStartPointSize;
  EditGroupMembersMax.Value:=g_Config.nGroupMembersMax;

  EditRedHomeMap.Text:=g_Config.sRedHomeMap;
  EditRedHomeX.Value:=g_Config.nRedHomeX;
  EditRedHomeY.Value:=g_Config.nRedHomeY;

  EditRedDieHomeMap.Text:=g_Config.sRedDieHomeMap;
  EditRedDieHomeX.Value:=g_Config.nRedDieHomeX;
  EditRedDieHomeY.Value:=g_Config.nRedDieHomeY;

  EditHomeMap.Text:=g_Config.sHomeMap;
  EditHomeX.Value:=g_Config.nHomeX;
  EditHomeY.Value:=g_Config.nHomeY;

  EditDecPkPointTime.Value:=g_Config.dwDecPkPointTime div 1000;
  EditDecPkPointCount.Value:=g_Config.nDecPkPointCount;
  EditPKFlagTime.Value:=g_Config.dwPKFlagTime div 1000;
  EditKillHumanAddPKPoint.Value:=g_Config.nKillHumanAddPKPoint;

  EditPosionDecHealthTime.Value:=g_Config.dwPosionDecHealthTime;
  EditPosionDamagarmor.Value:=g_Config.nPosionDamagarmor;

  CheckBoxTestServer.Checked:=g_Config.boTestServer;
  CheckBoxServiceMode.Checked:=g_Config.boServiceMode;
  CheckBoxVentureMode.Checked:=g_Config.boVentureServer;
  CheckBoxNonPKMode.Checked:=g_Config.boNonPKServer;

  EditStartPermission.Value:=g_Config.nStartPermission;
  EditTestLevel.Value:=g_Config.nTestLevel;
  EditTestGold.Value:=g_Config.nTestGold;
  EditTestUserLimit.Value:=g_Config.nTestUserLimit;
  EditUserFull.Value:=g_Config.nUserFull;

  CheckBoxTestServerClick(CheckBoxTestServer);

  CheckBoxKillHumanWinLevel.Checked:=g_Config.boKillHumanWinLevel;
  CheckBoxKilledLostLevel.Checked:=g_Config.boKilledLostLevel;
  CheckBoxKillHumanWinExp.Checked:=g_Config.boKillHumanWinExp;
  CheckBoxKilledLostExp.Checked:=g_Config.boKilledLostExp;
  EditKillHumanWinLevel.Value:=g_Config.nKillHumanWinLevel;
  EditKilledLostLevel.Value:=g_Config.nKilledLostLevel;
  EditKillHumanWinExp.Value:=g_Config.nKillHumanWinExp;
  EditKillHumanLostExp.Value:=g_Config.nKillHumanLostExp;
  EditHumanLevelDiffer.Value:=g_Config.nHumanLevelDiffer;

  CheckBoxKillHumanWinLevelClick(CheckBoxKillHumanWinLevel);
  CheckBoxKilledLostLevelClick(CheckBoxKilledLostLevel);
  CheckBoxKillHumanWinExpClick(CheckBoxKillHumanWinExp);
  CheckBoxKilledLostExpClick(CheckBoxKilledLostExp);

  EditHumanMaxGold.Value:=g_Config.nHumanMaxGold;
  EditHumanTryModeMaxGold.Value:=g_Config.nHumanTryModeMaxGold;
  EditTryModeLevel.Value:=g_Config.nTryModeLevel;
  CheckBoxTryModeUseStorage.Checked:=g_Config.boTryModeUseStorage;


  EditSayMsgMaxLen.Value:=g_Config.nSayMsgMaxLen;
  EditSayRedMsgMaxLen.Value:=g_Config.nSayRedMsgMaxLen;
  EditCanShoutMsgLevel.Value:=g_Config.nCanShoutMsgLevel;
  CheckBoxShutRedMsgShowGMName.Checked:=g_Config.boShutRedMsgShowGMName;
  CheckBoxShowPreFixMsg.Checked:=g_Config.boShowPreFixMsg;
  EditGMRedMsgCmd.Text:=g_GMRedMsgCmd;

  EditStartCastleWarDays.Value:=g_Config.nStartCastleWarDays;
  EditStartCastlewarTime.Value:=g_Config.nStartCastlewarTime;
  EditShowCastleWarEndMsgTime.Value:=g_Config.dwShowCastleWarEndMsgTime div (60 * 1000);
  EditCastleWarTime.Value:=g_Config.dwCastleWarTime div (60 * 1000);
  EditGetCastleTime.Value:=g_Config.dwGetCastleTime div (60 * 1000);
  EditGuildWarTime.Value:=g_Config.dwGuildWarTime div (60 * 1000);
  EditMakeGhostTime.Value:=g_Config.dwMakeGhostTime div 1000;
  EditClearDropOnFloorItemTime.Value:=g_Config.dwClearDropOnFloorItemTime div 1000;
  EditSaveHumanRcdTime.Value:=g_Config.dwSaveHumanRcdTime div (60 * 1000);
  EditHumanFreeDelayTime.Value:=g_Config.dwHumanFreeDelayTime div (60 * 1000);
  EditFloorItemCanPickUpTime.Value:=g_Config.dwFloorItemCanPickUpTime div 1000;

  EditBuildGuildPrice.Value:=g_Config.nBuildGuildPrice;
  EditGuildWarPrice.Value:=g_Config.nGuildWarPrice;
  EditMakeDurgPrice.Value:=g_Config.nMakeDurgPrice;



  EditTryDealTime.Value:=g_Config.dwTryDealTime div 1000;
  EditDealOKTime.Value:=g_Config.dwDealOKTime div 1000;

  EditCastleMemberPriceRate.Value:=g_Config.nCastleMemberPriceRate;

  EditHearMsgFColor.Value:=g_Config.btHearMsgFColor;
  EdittHearMsgBColor.Value:=g_Config.btHearMsgBColor;
  EditWhisperMsgFColor.Value:=g_Config.btWhisperMsgFColor;
  EditWhisperMsgBColor.Value:=g_Config.btWhisperMsgBColor;
  EditGMWhisperMsgFColor.Value:=g_Config.btGMWhisperMsgFColor;
  EditGMWhisperMsgBColor.Value:=g_Config.btGMWhisperMsgBColor;
  EditRedMsgFColor.Value:=g_Config.btRedMsgFColor;
  EditRedMsgBColor.Value:=g_Config.btRedMsgBColor;
  EditGreenMsgFColor.Value:=g_Config.btGreenMsgFColor;
  EditGreenMsgBColor.Value:=g_Config.btGreenMsgBColor;
  EditBlueMsgFColor.Value:=g_Config.btBlueMsgFColor;
  EditBlueMsgBColor.Value:=g_Config.btBlueMsgBColor;
  EditCryMsgFColor.Value:=g_Config.btCryMsgFColor;
  EditCryMsgBColor.Value:=g_Config.btCryMsgBColor;
  EditGuildMsgFColor.Value:=g_Config.btGuildMsgFColor;
  EditGuildMsgBColor.Value:=g_Config.btGuildMsgBColor;
  EditGroupMsgFColor.Value:=g_Config.btGroupMsgFColor;
  EditGroupMsgBColor.Value:=g_Config.btGroupMsgBColor;
  EditCustMsgFColor.Value:=g_Config.btCustMsgFColor;
  EditCustMsgBColor.Value:=g_Config.btCustMsgBColor;

  CheckBoxPKLevelProtect.Checked:=g_Config.boPKLevelProtect;
  EditPKProtectLevel.Value:=g_Config.nPKProtectLevel;
  EditRedPKProtectLevel.Value:=g_Config.nRedPKProtectLevel;
  CheckBoxPKLevelProtectClick(CheckBoxPKLevelProtect);

  CheckBoxCanNotGetBackDeal.Checked:=g_Config.boCanNotGetBackDeal;
  CheckBoxDisableDeal.Checked:=g_Config.boDisableDeal;
  CheckBoxControlDropItem.Checked:=g_Config.boControlDropItem;
  CheckBoxIsSafeDisableDrop.Checked:=g_Config.boInSafeDisableDrop;
  EditCanDropPrice.Value:=g_Config.nCanDropPrice;
  EditCanDropGold.Value:=g_Config.nCanDropGold;
  EditSuperRepairPriceRate.Value:=g_Config.nSuperRepairPriceRate;
  EditRepairItemDecDura.Value:=g_Config.nRepairItemDecDura;

  CheckBoxKillByMonstDropUseItem.Checked:=g_Config.boKillByMonstDropUseItem;
  CheckBoxKillByHumanDropUseItem.Checked:=g_Config.boKillByHumanDropUseItem;
  CheckBoxDieScatterBag.Checked:=g_Config.boDieScatterBag;
  CheckBoxDieDropGold.Checked:=g_Config.boDieDropGold;
  CheckBoxDieRedScatterBagAll.Checked:=g_Config.boDieRedScatterBagAll;

  ScrollBarDieDropUseItemRate.Min:=1;
  ScrollBarDieDropUseItemRate.Max:=200;
  ScrollBarDieDropUseItemRate.Position:=g_Config.nDieDropUseItemRate;
  ScrollBarDieRedDropUseItemRate.Min:=1;
  ScrollBarDieRedDropUseItemRate.Max:=200;
  ScrollBarDieRedDropUseItemRate.Position:=g_Config.nDieRedDropUseItemRate;
  ScrollBarDieScatterBagRate.Min:=1;
  ScrollBarDieScatterBagRate.Max:=200;
  ScrollBarDieScatterBagRate.Position:=g_Config.nDieScatterBagRate;

  EditSayMsgTime.Value:=g_Config.dwSayMsgTime div 1000;
  EditSayMsgCount.Value:=g_Config.nSayMsgCount;
  EditDisableSayMsgTime.Value:=g_Config.dwDisableSayMsgTime div 1000;

  RefGameVarConf();
  RefCharStatusConf();

  boOpened:=True;
  GameConfigControl.ActivePageIndex:=0;
  ShowModal;
end;
procedure TfrmGameConfig.RefGameSpeedConf;
begin
  EditHitIntervalTime.Value:=g_Config.dwHitIntervalTime;
  EditMagicHitIntervalTime.Value:=g_Config.dwMagicHitIntervalTime;
  EditRunIntervalTime.Value:=g_Config.dwRunIntervalTime;
  EditWalkIntervalTime.Value:=g_Config.dwWalkIntervalTime;
  EditTurnIntervalTime.Value:=g_Config.dwTurnIntervalTime;

  EditItemSpeedTime.Value:=g_Config.ClientConf.btItemSpeed;
  EditMaxHitMsgCount.Value:=g_Config.nMaxHitMsgCount;
  EditMaxSpellMsgCount.Value:=g_Config.nMaxSpellMsgCount;
  EditMaxRunMsgCount.Value:=g_Config.nMaxRunMsgCount;
  EditMaxWalkMsgCount.Value:=g_Config.nMaxWalkMsgCount;
  EditMaxTurnMsgCount.Value:=g_Config.nMaxTurnMsgCount;
  EditMaxDigUpMsgCount.Value:=g_Config.nMaxDigUpMsgCount;
  CheckBoxboKickOverSpeed.Checked:=g_Config.boKickOverSpeed;
  EditOverSpeedKickCount.Value:=g_Config.nOverSpeedKickCount;
  EditDropOverSpeed.Value:=g_Config.dwDropOverSpeed;
  CheckBoxboKickOverSpeedClick(CheckBoxboKickOverSpeed);

  CheckBoxSpellSendUpdateMsg.Checked:=g_Config.boSpellSendUpdateMsg;
  CheckBoxActionSendActionMsg.Checked:=g_Config.boActionSendActionMsg;

  if g_Config.btSpeedControlMode = 0 then begin
    RadioButtonDelyMode.Checked:=True;
    RadioButtonFilterMode.Checked:=False;
  end else begin
    RadioButtonDelyMode.Checked:=False;
    RadioButtonFilterMode.Checked:=True;
  end;

  CheckBoxDisableStruck.Checked:=g_Config.boDisableStruck;
  CheckBoxDisableSelfStruck.Checked:=g_Config.boDisableSelfStruck;
  EditStruckTime.Value:=g_Config.dwStruckTime;

end;


procedure TfrmGameConfig.ButtonGameSpeedDefaultClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置？', '确认信息', MB_YESNO + MB_ICONQUESTION) <> IDYES then begin
    exit;
  end;
  g_Config.dwHitIntervalTime:=850;
  g_Config.dwMagicHitIntervalTime:=1350;
  g_Config.dwRunIntervalTime:=600;
  g_Config.dwWalkIntervalTime:=600;
  g_Config.dwTurnIntervalTime:=600;

  g_Config.nMaxHitMsgCount:=1;
  g_Config.nMaxSpellMsgCount:=1;
  g_Config.nMaxRunMsgCount:=1;
  g_Config.nMaxWalkMsgCount:=1;
  g_Config.nMaxTurnMsgCount:=1;
  g_Config.nMaxDigUpMsgCount:=1;
  g_Config.nOverSpeedKickCount:=2;
  g_Config.dwDropOverSpeed:=200;
  g_Config.boKickOverSpeed:=True;
  g_Config.ClientConf.btItemSpeed:=25;
  g_Config.boDisableStruck:=False;
  g_Config.boDisableSelfStruck:=False;
  g_Config.dwStruckTime:=300;
  g_Config.boSpellSendUpdateMsg:=True;
  g_Config.boActionSendActionMsg:=True;
  g_Config.btSpeedControlMode:=0;
  RefGameSpeedConf();
  ModValue();
end;

procedure TfrmGameConfig.ButtonGameSpeedSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup','HitIntervalTime',g_Config.dwHitIntervalTime);
  Config.WriteInteger('Setup','MagicHitIntervalTime',  g_Config.dwMagicHitIntervalTime);
  Config.WriteInteger('Setup','RunIntervalTime',  g_Config.dwRunIntervalTime);
  Config.WriteInteger('Setup','WalkIntervalTime',  g_Config.dwWalkIntervalTime);
  Config.WriteInteger('Setup','TurnIntervalTime',  g_Config.dwTurnIntervalTime);

  Config.WriteInteger('Setup','ItemSpeedTime',g_Config.ClientConf.btItemSpeed);
  Config.WriteInteger('Setup','MaxHitMsgCount',g_Config.nMaxHitMsgCount);
  Config.WriteInteger('Setup','MaxSpellMsgCount',g_Config.nMaxSpellMsgCount);
  Config.WriteInteger('Setup','MaxRunMsgCount',g_Config.nMaxRunMsgCount);
  Config.WriteInteger('Setup','MaxWalkMsgCount',g_Config.nMaxWalkMsgCount);
  Config.WriteInteger('Setup','MaxTurnMsgCount',g_Config.nMaxTurnMsgCount);
  Config.WriteInteger('Setup','MaxSitDonwMsgCount',  g_Config.nMaxSitDonwMsgCount);
  Config.WriteInteger('Setup','MaxDigUpMsgCount',  g_Config.nMaxDigUpMsgCount);
  Config.WriteInteger('Setup','OverSpeedKickCount',  g_Config.nOverSpeedKickCount);
  Config.WriteBool('Setup','KickOverSpeed',  g_Config.boKickOverSpeed);
  Config.WriteBool('Setup','SpellSendUpdateMsg',  g_Config.boSpellSendUpdateMsg);
  Config.WriteBool('Setup','ActionSendActionMsg',  g_Config.boActionSendActionMsg);
  Config.WriteInteger('Setup','DropOverSpeed',  g_Config.dwDropOverSpeed);
  Config.WriteBool('Setup','DisableStruck',  g_Config.boDisableStruck);
  Config.WriteBool('Setup','DisableSelfStruck',  g_Config.boDisableSelfStruck);
  Config.WriteInteger('Setup','StruckTime',  g_Config.dwStruckTime);
  Config.WriteInteger('Setup','SpeedControlMode',g_Config.btSpeedControlMode);
{$IFEND}
  uModValue();
end;

procedure TfrmGameConfig.EditHitIntervalTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwHitIntervalTime:=EditHitIntervalTime.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditMagicHitIntervalTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwMagicHitIntervalTime:=EditMagicHitIntervalTime.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditRunIntervalTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwRunIntervalTime:=EditRunIntervalTime.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditWalkIntervalTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwWalkIntervalTime:=EditWalkIntervalTime.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditTurnIntervalTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwTurnIntervalTime:=EditTurnIntervalTime.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditMaxHitMsgCountChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMaxHitMsgCount:=EditMaxHitMsgCount.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditMaxSpellMsgCountChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMaxSpellMsgCount:=EditMaxSpellMsgCount.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditMaxRunMsgCountChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMaxRunMsgCount:=EditMaxRunMsgCount.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditMaxWalkMsgCountChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMaxWalkMsgCount:=EditMaxWalkMsgCount.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditMaxTurnMsgCountChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMaxTurnMsgCount:=EditMaxTurnMsgCount.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditMaxDigUpMsgCountChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMaxDigUpMsgCount:=EditMaxDigUpMsgCount.Value;
  ModValue();
end;
procedure TfrmGameConfig.EditOverSpeedKickCountChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nOverSpeedKickCount:=EditOverSpeedKickCount.Value;
  ModValue();

end;
procedure TfrmGameConfig.EditDropOverSpeedChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwDropOverSpeed:=EditDropOverSpeed.Value;
  ModValue();
end;


procedure TfrmGameConfig.CheckBoxSpellSendUpdateMsgClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boSpellSendUpdateMsg:=CheckBoxSpellSendUpdateMsg.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxActionSendActionMsgClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boActionSendActionMsg:=CheckBoxActionSendActionMsg.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxboKickOverSpeedClick(Sender: TObject);
begin
  EditOverSpeedKickCount.Enabled:=CheckBoxboKickOverSpeed.Checked;
  if not boOpened then exit;
  g_Config.boKickOverSpeed:=CheckBoxboKickOverSpeed.Checked;
  ModValue();
end;


procedure TfrmGameConfig.RadioButtonDelyModeClick(Sender: TObject);
var
  boFalg:Boolean;
begin
  if not boOpened then exit;
  boFalg:=RadioButtonDelyMode.Checked;
  if boFalg then begin
    g_Config.btSpeedControlMode:=0;
  end else begin
    g_Config.btSpeedControlMode:=1;
  end;
  ModValue();
end;

procedure TfrmGameConfig.RadioButtonFilterModeClick(Sender: TObject);
var
  boFalg:Boolean;
begin
  if not boOpened then exit;
  boFalg:=RadioButtonFilterMode.Checked;
  if boFalg then begin
    g_Config.btSpeedControlMode:=1;
  end else begin
    g_Config.btSpeedControlMode:=0;
  end;
  ModValue();
end;

procedure TfrmGameConfig.EditItemSpeedTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.ClientConf.btItemSpeed:=EditItemSpeedTime.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditConsoleShowUserCountTimeChange(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwConsoleShowUserCountTime:=EditConsoleShowUserCountTime.Value * 1000;
  ModValue();
end;

procedure TfrmGameConfig.EditShowLineNoticeTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwShowLineNoticeTime:=EditShowLineNoticeTime.Value * 1000;
  ModValue();
end;

procedure TfrmGameConfig.ComboBoxLineNoticeColorChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nLineNoticeColor:=ComboBoxLineNoticeColor.ItemIndex;
  ModValue();
end;

procedure TfrmGameConfig.EditSoftVersionDateChange(Sender: TObject);
begin
  if not boOpened then exit;
  ModValue();
end;
procedure TfrmGameConfig.EditLineNoticePreFixChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.sLineNoticePreFix:=Trim(EditLineNoticePreFix.Text);
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxShowMakeItemMsgClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boShowMakeItemMsg:=CheckBoxShowMakeItemMsg.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CbViewHackClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boViewHackMessage:=CbViewHack.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CkViewAdmfailClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boViewAdmissionFailure:=CkViewAdmfail.Checked;
  ModValue();
end;


procedure TfrmGameConfig.CheckBoxShowExceptionMsgClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boShowExceptionMsg:=CheckBoxShowExceptionMsg.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxCanOldClientLogonClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boCanOldClientLogon:=CheckBoxCanOldClientLogon.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxSendOnlineCountClick(Sender: TObject);
var
  boStatus:Boolean;
begin
  boStatus:=CheckBoxSendOnlineCount.Checked;
  EditSendOnlineCountRate.Enabled:=boStatus;
  EditSendOnlineTime.Enabled:=boStatus;
  if not boOpened then exit;
  g_Config.boSendOnlineCount:=boStatus;
  ModValue();
end;

procedure TfrmGameConfig.EditSendOnlineCountRateChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nSendOnlineCountRate:=EditSendOnlineCountRate.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditSendOnlineTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwSendOnlineTime:=EditSendOnlineTime.Value * 1000;
  ModValue();
end;
procedure TfrmGameConfig.EditMonsterPowerRateChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMonsterPowerRate:=EditMonsterPowerRate.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditEditItemsPowerRateChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nItemsPowerRate:=EditEditItemsPowerRate.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditItemsACPowerRateChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nItemsACPowerRate:=EditItemsACPowerRate.Value;
  ModValue();
end;
procedure TfrmGameConfig.CheckBoxDisableStruckClick(Sender: TObject);
begin
  EditStruckTime.Enabled:=not CheckBoxDisableStruck.Checked;
  if not boOpened then exit;
  g_Config.boDisableStruck:=CheckBoxDisableStruck.Checked;
  ModValue();
end;
procedure TfrmGameConfig.CheckBoxDisableSelfStruckClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boDisableSelfStruck:=CheckBoxDisableSelfStruck.Checked;
  ModValue();
end;
procedure TfrmGameConfig.EditStruckTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwStruckTime:=EditStruckTime.Value;
  ModValue();
end;

procedure TfrmGameConfig.RefGameVarConf;
begin
  EditSoftVersionDate.Text:=IntToStr(g_Config.nSoftVersionDate);
  EditConsoleShowUserCountTime.Value:=g_Config.dwConsoleShowUserCountTime div 1000;
  EditShowLineNoticeTime.Value:=g_Config.dwShowLineNoticeTime div 1000;
  ComboBoxLineNoticeColor.ItemIndex:=_MAX(0,_MIN(3,g_Config.nLineNoticeColor));
  EditLineNoticePreFix.Text:=g_Config.sLineNoticePreFix;

  CheckBoxShowMakeItemMsg.Checked:=g_Config.boShowMakeItemMsg;
  CbViewHack.Checked:=g_Config.boViewHackMessage;
  CkViewAdmfail.Checked:=g_Config.boViewAdmissionFailure;
  CheckBoxShowExceptionMsg.Checked:=g_Config.boShowExceptionMsg;  

  CheckBoxSendOnlineCount.Checked:=g_Config.boSendOnlineCount;
  EditSendOnlineCountRate.Value:=g_Config.nSendOnlineCountRate;
  EditSendOnlineTime.Value:=g_Config.dwSendOnlineTime div 1000;
  CheckBoxSendOnlineCountClick(CheckBoxSendOnlineCount);

  EditMonsterPowerRate.Value:=g_Config.nMonsterPowerRate;
  EditEditItemsPowerRate.Value:=g_Config.nItemsPowerRate;
  EditItemsACPowerRate.Value:=g_Config.nItemsACPowerRate;
  CheckBoxCanOldClientLogon.Checked:=g_Config.boCanOldClientLogon;
end;

procedure TfrmGameConfig.ButtonGeneralSaveClick(Sender: TObject);
var
  SoftVersionDate:Integer;
begin
  SoftVersionDate:=Str_ToInt(Trim(EditSoftVersionDate.Text),-1);
  if (SoftVersionDate < 0) or (SoftVersionDate > High(Integer)) then begin
    Application.MessageBox('客户端版号设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditSoftVersionDate.SetFocus;
    exit;
  end;
  g_Config.nSoftVersionDate:=SoftVersionDate;
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup','SoftVersionDate',g_Config.nSoftVersionDate);
  Config.WriteInteger('Setup','ConsoleShowUserCountTime',g_Config.dwConsoleShowUserCountTime);
  Config.WriteInteger('Setup','ShowLineNoticeTime',g_Config.dwShowLineNoticeTime);
  Config.WriteInteger('Setup','LineNoticeColor',g_Config.nLineNoticeColor);
  StringConf.WriteString('String','LineNoticePreFix',g_Config.sLineNoticePreFix);
  Config.WriteBool('Setup','ShowMakeItemMsg',g_Config.boShowMakeItemMsg);
  Config.WriteString('Server','ViewHackMessage',BoolToStr(g_Config.boViewHackMessage));
  Config.WriteString('Server','ViewAdmissionFailure',BoolToStr(g_Config.boViewAdmissionFailure));
  Config.WriteBool('Setup','ShowExceptionMsg',g_Config.boShowExceptionMsg);

  Config.WriteBool('Setup','SendOnlineCount',g_Config.boSendOnlineCount);
  Config.WriteInteger('Setup','SendOnlineCountRate',g_Config.nSendOnlineCountRate);
  Config.WriteInteger('Setup','SendOnlineTime',g_Config.dwSendOnlineTime);

  Config.WriteInteger('Setup','MonsterPowerRate',g_Config.nMonsterPowerRate);
  Config.WriteInteger('Setup','ItemsPowerRate',g_Config.nItemsPowerRate);
  Config.WriteInteger('Setup','ItemsACPowerRate',g_Config.nItemsACPowerRate);
  Config.WriteBool('Setup','CanOldClientLogon',g_Config.boCanOldClientLogon);
{$IFEND}
  uModValue();
end;





procedure TfrmGameConfig.EditKillMonExpMultipleChange(Sender: TObject);
begin
  if EditKillMonExpMultiple.Text = '' then begin
    EditKillMonExpMultiple.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.dwKillMonExpMultiple:=EditKillMonExpMultiple.Value;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxHighLevelKillMonFixExpClick(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boHighLevelKillMonFixExp:=CheckBoxHighLevelKillMonFixExp.Checked;
  ModValue();
end;

procedure TfrmGameConfig.GridLevelExpSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  if not boOpened then exit;
  ModValue();
end;
procedure TfrmGameConfig.ComboBoxLevelExpClick(Sender: TObject);
var
  I: Integer;
  LevelExpScheme:TLevelExpScheme;
  dwOneLevelExp:LongWord;
  dwExp:LongWord;
begin
  if not boOpened then exit;
  if Application.MessageBox('升级经验计划设置的经验将立即生效，是否确认使用此经验计划？','确认信息',MB_YESNO + MB_ICONQUESTION) = IDNO then begin
    exit;
  end;
    
  LevelExpScheme:=TLevelExpScheme(ComboBoxLevelExp.Items.Objects[ComboBoxLevelExp.ItemIndex]);
  case LevelExpScheme of    //
    s_OldLevelExp: g_Config.dwNeedExps:=g_dwOldNeedExps;
    s_StdLevelExp: begin
      g_Config.dwNeedExps:=g_dwOldNeedExps;
      dwOneLevelExp:=4000000000 div High(g_Config.dwNeedExps);
      for I := 1 to High(g_Config.dwNeedExps) do begin
        if (26 + I) > High(g_Config.dwNeedExps) then break;
        dwExp:=dwOneLevelExp * LongWord(I);
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[26 + I]:=dwExp;
      end;
    end;
    s_2Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 2;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_5Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 5;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_8Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 8;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_10Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 10;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_20Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 20;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_30Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 30;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_40Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 40;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_50Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 50;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_60Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 60;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_70Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 70;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_80Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 80;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_90Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 90;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_100Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 100;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_150Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 150;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_200Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 200;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_250Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 250;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
    s_300Mult: begin
      for I := 1 to High(g_Config.dwNeedExps) do begin
        dwExp:=g_Config.dwNeedExps[I] div 300;
        if dwExp = 0 then dwExp:=1;
        g_Config.dwNeedExps[I]:=dwExp;
      end;
    end;
  end;
  for I := 1 to GridLevelExp.RowCount - 1 do begin
    GridLevelExp.Cells[1,I]:=IntToStr(g_Config.dwNeedExps[I]);
  end;
  ModValue();
end;
procedure TfrmGameConfig.ButtonExpSaveClick(Sender: TObject);
var
  I:Integer;
  dwExp:LongWord;
 // NeedExps:TLevelNeedExp;    //nicky
begin
  for I := 1 to GridLevelExp.RowCount - 1 do begin
    dwExp:=Str_ToInt(GridLevelExp.Cells[1,I],0);
    if (dwExp <= 0) or (dwExp > High(LongWord)) then begin
      Application.MessageBox(PChar('等级 ' + IntToStr(I) + ' 升级经验设置错误！！！'),'错误信息',MB_OK + MB_ICONERROR);
      GridLevelExp.Row:=I;
      GridLevelExp.SetFocus;
      exit;
    end;
   // NeedExps[I]:=dwExp;
  end;
 // g_Config.dwNeedExps:=NeedExps;

  ExpConf.WriteInteger('Exp','KillMonExpMultiple',g_Config.dwKillMonExpMultiple);
  ExpConf.WriteBool('Exp','HighLevelKillMonFixExp',g_Config.boHighLevelKillMonFixExp);
  for I := 1 to high(g_Config.dwNeedExps) do begin
    ExpConf.WriteString('Exp','Level' + IntToStr(I),IntToStr(g_Config.dwNeedExps[I]));
  end;
  uModValue();
end;

procedure TfrmGameConfig.EditRepairDoorPriceChange(Sender: TObject);
begin
  if EditRepairDoorPrice.Text = '' then begin
    EditRepairDoorPrice.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nRepairDoorPrice:=EditRepairDoorPrice.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditRepairWallPriceChange(Sender: TObject);
begin
  if EditRepairWallPrice.Text = '' then begin
    EditRepairWallPrice.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nRepairWallPrice:=EditRepairWallPrice.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditHireArcherPriceChange(Sender: TObject);
begin
  if EditHireArcherPrice.Text = '' then begin
    EditHireArcherPrice.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nHireArcherPrice:=EditHireArcherPrice.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditHireGuardPriceChange(Sender: TObject);
begin
  if EditHireGuardPrice.Text = '' then begin
    EditHireGuardPrice.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nHireGuardPrice:=EditHireGuardPrice.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditCastleGoldMaxChange(Sender: TObject);
begin
  if EditCastleGoldMax.Text = '' then begin
    EditCastleGoldMax.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nCastleGoldMax:=EditCastleGoldMax.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditCastleOneDayGoldChange(Sender: TObject);
begin
  if EditCastleOneDayGold.Text = '' then begin
    EditCastleOneDayGold.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nCastleOneDayGold:=EditCastleOneDayGold.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditCastleHomeMapChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.sCastleHomeMap:=Trim(EditCastleHomeMap.Text);
  ModValue();
end;

procedure TfrmGameConfig.EditCastleHomeXChange(Sender: TObject);
begin
  if EditCastleHomeX.Text = '' then begin
    EditCastleHomeX.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nCastleHomeX:=EditCastleHomeX.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditCastleHomeYChange(Sender: TObject);
begin
  if EditCastleHomeY.Text = '' then begin
    EditCastleHomeY.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nCastleHomeY:=EditCastleHomeY.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditCastleNameChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.sCastleName:=Trim(EditCastleName.Text);
  ModValue();
end;

procedure TfrmGameConfig.EditWarRangeXChange(Sender: TObject);
begin
  if EditWarRangeX.Text = '' then begin
    EditWarRangeX.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nCastleWarRangeX:=EditWarRangeX.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditWarRangeYChange(Sender: TObject);
begin
  if EditWarRangeY.Text = '' then begin
    EditWarRangeY.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nCastleWarRangeY:=EditWarRangeY.Value;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxGetAllNpcTaxClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boGetAllNpcTax:=CheckBoxGetAllNpcTax.Checked;
  ModValue();
end;

procedure TfrmGameConfig.EditTaxRateChange(Sender: TObject);
begin
  if EditTaxRate.Text = '' then begin
    EditTaxRate.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nCastleTaxRate:=EditTaxRate.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditCastleMemberPriceRateChange(Sender: TObject);
begin
  if EditCastleMemberPriceRate.Text = '' then begin
    EditCastleMemberPriceRate.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nCastleMemberPriceRate:=EditCastleMemberPriceRate.Value;
  ModValue();
end;

procedure TfrmGameConfig.ButtonCastleSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup','RepairDoor',g_Config.nRepairDoorPrice);
  Config.WriteInteger('Setup','RepairWall',g_Config.nRepairWallPrice);
  Config.WriteInteger('Setup','HireArcher',g_Config.nHireArcherPrice);
  Config.WriteInteger('Setup','HireGuard',g_Config.nHireGuardPrice);
  Config.WriteInteger('Setup','CastleGoldMax',g_Config.nCastleGoldMax);
  Config.WriteInteger('Setup','CastleOneDayGold',g_Config.nCastleOneDayGold);
  Config.WriteString('Setup','CastleName',g_Config.sCastleName);
  Config.WriteString('Setup','CastleHomeMap',g_Config.sCastleHomeMap);
  Config.WriteInteger('Setup','CastleHomeX',g_Config.nCastleHomeX);
  Config.WriteInteger('Setup','CastleHomeY',g_Config.nCastleHomeY);
  Config.WriteInteger('Setup','CastleWarRangeX',g_Config.nCastleWarRangeX);
  Config.WriteInteger('Setup','CastleWarRangeY',g_Config.nCastleWarRangeY);
  Config.WriteInteger('Setup','CastleTaxRate',g_Config.nCastleTaxRate);
  Config.WriteBool('Setup','CastleGetAllNpcTax',g_Config.boGetAllNpcTax);
  Config.WriteInteger('Setup','CastleMemberPriceRate',g_Config.nCastleMemberPriceRate);
{$IFEND}
  uModValue();
end;

procedure TfrmGameConfig.CheckBoxDisHumRunClick(Sender: TObject);
var
  boChecked:Boolean;
begin
  boChecked:=not CheckBoxDisHumRun.Checked;
  if boChecked then begin
    CheckBoxRunHum.Checked:=False;
    CheckBoxRunHum.Enabled:=False;
    CheckBoxRunMon.Checked:=False;
    CheckBoxRunMon.Enabled:=False;
    CheckBoxWarDisHumRun.Checked:=False;
    CheckBoxWarDisHumRun.Enabled:=False;
    CheckBoxRunNpc.Checked:=False;
    CheckBoxRunGuard.Checked:=False;
    CheckBoxRunNpc.Enabled:=False;
    CheckBoxRunGuard.Enabled:=False;
    CheckBoxGMRunAll.Checked:=False;
    CheckBoxGMRunAll.Enabled:=False;
  end else begin
    CheckBoxRunHum.Enabled:=True;
    CheckBoxRunMon.Enabled:=True;
    CheckBoxWarDisHumRun.Enabled:=True;
    CheckBoxRunNpc.Enabled:=True;
    CheckBoxRunGuard.Enabled:=True;
    CheckBoxGMRunAll.Enabled:=True;
  end;

  if not boOpened then exit;
  g_Config.boDiableHumanRun:= boChecked;

  ModValue();
end;
procedure TfrmGameConfig.CheckBoxRunHumClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boRunHuman:=CheckBoxRunHum.Checked;
  ModValue();
end;
procedure TfrmGameConfig.CheckBoxRunMonClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boRunMon:=CheckBoxRunMon.Checked;
  ModValue();
end;
procedure TfrmGameConfig.CheckBoxRunNpcClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boRunNpc:=CheckBoxRunNpc.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxRunGuardClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boRunGuard:=CheckBoxRunGuard.Checked;
  ModValue();
end;
procedure TfrmGameConfig.CheckBoxWarDisHumRunClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boWarDisHumRun:=CheckBoxWarDisHumRun.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxGMRunAllClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boGMRunAll:=CheckBoxGMRunAll.Checked;
  ModValue();
end;

procedure TfrmGameConfig.EditTryDealTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwTryDealTime:=EditTryDealTime.Value * 1000;
  ModValue();
end;
             
procedure TfrmGameConfig.EditDealOKTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwDealOKTime:=EditDealOKTime.Value * 1000;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxCanNotGetBackDealClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boCanNotGetBackDeal:=CheckBoxCanNotGetBackDeal.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxDisableDealClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boDisableDeal:=CheckBoxDisableDeal.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxControlDropItemClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boControlDropItem:=CheckBoxControlDropItem.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxIsSafeDisableDropClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boInSafeDisableDrop:=CheckBoxIsSafeDisableDrop.Checked;
  ModValue();
end;

procedure TfrmGameConfig.EditCanDropPriceChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nCanDropPrice:=EditCanDropPrice.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditCanDropGoldChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nCanDropGold:=EditCanDropGold.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditSafeZoneSizeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nSafeZoneSize:=EditSafeZoneSize.Value;
  ModValue();
end;
procedure TfrmGameConfig.EditStartPointSizeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nStartPointSize:=EditStartPointSize.Value;
  ModValue();
end;
procedure TfrmGameConfig.EditGroupMembersMaxChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nGroupMembersMax:=EditGroupMembersMax.Value;
  ModValue();
end;
procedure TfrmGameConfig.EditRedHomeXChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nRedHomeX:=EditRedHomeX.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditRedHomeYChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nRedHomeY:=EditRedHomeY.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditRedHomeMapChange(Sender: TObject);
begin
  if not boOpened then exit;
  ModValue();
end;
procedure TfrmGameConfig.EditRedDieHomeMapChange(Sender: TObject);
begin
  if not boOpened then exit;
  ModValue();
end;

procedure TfrmGameConfig.EditRedDieHomeXChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nRedDieHomeX:=EditRedDieHomeX.Value;
  ModValue();
end;
procedure TfrmGameConfig.EditHomeMapChange(Sender: TObject);
begin
  if not boOpened then exit;
  ModValue();
end;

procedure TfrmGameConfig.EditHomeXChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nHomeX:=EditHomeX.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditHomeYChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nHomeY:=EditHomeY.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditRedDieHomeYChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nRedDieHomeY:=EditRedDieHomeY.Value;
  ModValue();
end;
procedure TfrmGameConfig.ButtonOptionSaveClick(Sender: TObject);
begin
  if EditRedHomeMap.Text = '' then begin
    Application.MessageBox('红名村地图设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditRedHomeMap.SetFocus;
    exit;
  end;
  g_Config.sRedHomeMap:=Trim(EditRedHomeMap.Text);

  if EditRedDieHomeMap.Text = '' then begin
    Application.MessageBox('红名村地图设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditRedDieHomeMap.SetFocus;
    exit;
  end;
  g_Config.sRedDieHomeMap:=Trim(EditRedDieHomeMap.Text);

  if EditHomeMap.Text = '' then begin
    Application.MessageBox('应急回城地图设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditHomeMap.SetFocus;
    exit;
  end;
  g_Config.sHomeMap:=Trim(EditHomeMap.Text);

{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup','SafeZoneSize',g_Config.nSafeZoneSize);
  Config.WriteInteger('Setup','StartPointSize',g_Config.nStartPointSize);

  Config.WriteString('Setup','RedHomeMap',g_Config.sRedHomeMap);
  Config.WriteInteger('Setup','RedHomeX',g_Config.nRedHomeX);
  Config.WriteInteger('Setup','RedHomeY',g_Config.nRedHomeY);

  Config.WriteString('Setup','RedDieHomeMap',g_Config.sRedDieHomeMap);
  Config.WriteInteger('Setup','RedDieHomeX',g_Config.nRedDieHomeX);
  Config.WriteInteger('Setup','RedDieHomeY',g_Config.nRedDieHomeY);

  Config.WriteString('Setup','HomeMap',g_Config.sHomeMap);
  Config.WriteInteger('Setup','HomeX',g_Config.nHomeX);
  Config.WriteInteger('Setup','HomeY',g_Config.nHomeY);
{$IFEND}
  uModValue();
end;



procedure TfrmGameConfig.ButtonOptionSave3Click(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup','DiableHumanRun',g_Config.boDiableHumanRun);
  Config.WriteBool('Setup','RunHuman',g_Config.boRunHuman);
  Config.WriteBool('Setup','RunMon',g_Config.boRunMon);
  Config.WriteBool('Setup','RunNpc',g_Config.boRunNpc);
  Config.WriteBool('Setup','RunGuard', g_Config.boRunGuard);
  Config.WriteBool('Setup','WarDisableHumanRun',g_Config.boWarDisHumRun);
  Config.WriteBool('Setup','GMRunAll',g_Config.boGMRunAll);

  Config.WriteInteger('Setup','TryDealTime',g_Config.dwTryDealTime);
  Config.WriteInteger('Setup','DealOKTime',g_Config.dwDealOKTime);
  Config.WriteBool('Setup','CanNotGetBackDeal',g_Config.boCanNotGetBackDeal);
  Config.WriteBool('Setup','DisableDeal',g_Config.boDisableDeal);
  Config.WriteBool('Setup','ControlDropItem', g_Config.boControlDropItem);
  Config.WriteBool('Setup','InSafeDisableDrop', g_Config.boInSafeDisableDrop);
  Config.WriteInteger('Setup','CanDropGold', g_Config.nCanDropGold);
  Config.WriteInteger('Setup','CanDropPrice', g_Config.nCanDropPrice);

  Config.WriteInteger('Setup','DecLightItemDrugTime',g_Config.dwDecLightItemDrugTime);
  Config.WriteInteger('Setup','PosionDecHealthTime',g_Config.dwPosionDecHealthTime);
  Config.WriteInteger('Setup','PosionDamagarmor',g_Config.nPosionDamagarmor);
{$IFEND}
  uModValue();
end;



procedure TfrmGameConfig.EditDecPkPointTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwDecPkPointTime:=EditDecPkPointTime.Value * 1000;
  ModValue();
end;

procedure TfrmGameConfig.EditDecPkPointCountChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nDecPkPointCount:=EditDecPkPointCount.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditPKFlagTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwPKFlagTime:=EditPKFlagTime.Value * 1000;
  ModValue();
end;

procedure TfrmGameConfig.EditKillHumanAddPKPointChange(Sender: TObject);
begin
  if EditKillHumanAddPKPoint.Text = '' then begin
    EditKillHumanAddPKPoint.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nKillHumanAddPKPoint:=EditKillHumanAddPKPoint.Value;
  ModValue();
end;
procedure TfrmGameConfig.EditPosionDecHealthTimeChange(Sender: TObject);
begin
  if EditPosionDecHealthTime.Text = '' then begin
    EditPosionDecHealthTime.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.dwPosionDecHealthTime:=EditPosionDecHealthTime.Value;
  ModValue();
end;
procedure TfrmGameConfig.EditPosionDamagarmorChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nPosionDamagarmor:=EditPosionDamagarmor.Value;
  ModValue();
end;
procedure TfrmGameConfig.CheckBoxKillHumanWinLevelClick(Sender: TObject);
var
  boStatus:Boolean;
begin
  boStatus:=CheckBoxKillHumanWinLevel.Checked;
  CheckBoxKilledLostLevel.Enabled:=boStatus;
  EditKillHumanWinLevel.Enabled:=boStatus;
  EditKilledLostLevel.Enabled:=boStatus;
  if not boStatus then begin
    CheckBoxKilledLostLevel.Checked:=False;
    if not CheckBoxKillHumanWinExp.Checked then
      EditHumanLevelDiffer.Enabled:=False;
  end else begin
    EditHumanLevelDiffer.Enabled:=True;
  end;
  if not boOpened then exit;
  g_Config.boKillHumanWinLevel:=boStatus;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxKilledLostLevelClick(Sender: TObject);
var
  boStatus:Boolean;
begin
  boStatus:=CheckBoxKilledLostLevel.Checked;
  EditKilledLostLevel.Enabled:=boStatus;
  if not boOpened then exit;
  g_Config.boKilledLostLevel:=boStatus;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxKillHumanWinExpClick(Sender: TObject);
var
  boStatus:Boolean;
begin
  boStatus:=CheckBoxKillHumanWinExp.Checked;
  CheckBoxKilledLostExp.Enabled:=boStatus;
  EditKillHumanWinExp.Enabled:=boStatus;
  EditKillHumanLostExp.Enabled:=boStatus;
  if not boStatus then begin
    CheckBoxKilledLostExp.Checked:=False;
    if not CheckBoxKillHumanWinLevel.Checked then
      EditHumanLevelDiffer.Enabled:=False;
  end else begin
    EditHumanLevelDiffer.Enabled:=True;
  end;
  if not boOpened then exit;
  g_Config.boKillHumanWinExp:=boStatus;
  ModValue();

end;

procedure TfrmGameConfig.CheckBoxKilledLostExpClick(Sender: TObject);
var
  boStatus:Boolean;
begin
  boStatus:=CheckBoxKilledLostExp.Checked;
  EditKillHumanLostExp.Enabled:=boStatus;
  if not boOpened then exit;
  g_Config.boKilledLostExp:=boStatus;
  ModValue();

end;

procedure TfrmGameConfig.EditKillHumanWinLevelChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nKillHumanWinLevel:=EditKillHumanWinLevel.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditKilledLostLevelChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nKilledLostLevel:=EditKilledLostLevel.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditKillHumanWinExpChange(Sender: TObject);
begin
  if EditKillHumanWinExp.Text = '' then begin
    EditKillHumanWinExp.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nKillHumanWinExp:=EditKillHumanWinExp.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditKillHumanLostExpChange(Sender: TObject);
begin
  if EditKillHumanLostExp.Text = '' then begin
    EditKillHumanLostExp.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nKillHumanLostExp:=EditKillHumanLostExp.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditHumanLevelDifferChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nHumanLevelDiffer:=EditHumanLevelDiffer.Value;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxPKLevelProtectClick(Sender: TObject);
var
  boStatus:Boolean;
begin
  boStatus:=CheckBoxPKLevelProtect.Checked;
  EditPKProtectLevel.Enabled:=boStatus;
  if not boOpened then exit;
  g_Config.boPKLevelProtect:=boStatus;
  ModValue();
end;

procedure TfrmGameConfig.EditPKProtectLevelChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nPKProtectLevel:=EditPKProtectLevel.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditRedPKProtectLevelChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nRedPKProtectLevel:=EditRedPKProtectLevel.Value;
  ModValue();
end;

procedure TfrmGameConfig.ButtonOptionSave2Click(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup','DecPkPointTime',g_Config.dwDecPkPointTime);
  Config.WriteInteger('Setup','DecPkPointCount',g_Config.nDecPkPointCount);
  Config.WriteInteger('Setup','PKFlagTime',g_Config.dwPKFlagTime);
  Config.WriteInteger('Setup','KillHumanAddPKPoint',g_Config.nKillHumanAddPKPoint);
  Config.WriteInteger('Setup','KillHumanDecLuckPoint',g_Config.nKillHumanDecLuckPoint);


  Config.WriteBool('Setup','KillHumanWinLevel',g_Config.boKillHumanWinLevel);
  Config.WriteBool('Setup','KilledLostLevel',g_Config.boKilledLostLevel);
  Config.WriteInteger('Setup','KillHumanWinLevelPoint',g_Config.nKillHumanWinLevel);
  Config.WriteInteger('Setup','KilledLostLevelPoint',g_Config.nKilledLostLevel);
  Config.WriteBool('Setup','KillHumanWinExp',g_Config.boKillHumanWinExp);
  Config.WriteBool('Setup','KilledLostExp',g_Config.boKilledLostExp);
  Config.WriteInteger('Setup','KillHumanWinExpPoint',g_Config.nKillHumanWinExp);
  Config.WriteInteger('Setup','KillHumanLostExpPoint',g_Config.nKillHumanLostExp);
  Config.WriteInteger('Setup','HumanLevelDiffer',g_Config.nHumanLevelDiffer);

  Config.WriteBool('Setup','PKProtect',g_Config.boPKLevelProtect);
  Config.WriteInteger('Setup','PKProtectLevel',g_Config.nPKProtectLevel);
  Config.WriteInteger('Setup','RedPKProtectLevel',g_Config.nRedPKProtectLevel);
{$IFEND}  
  uModValue();
end;





procedure TfrmGameConfig.CheckBoxTestServerClick(Sender: TObject);
var
  boStatue:Boolean;
begin
  boStatue:=CheckBoxTestServer.Checked;
  EditTestLevel.Enabled:=boStatue;
  EditTestGold.Enabled:=boStatue;
  EditTestUserLimit.Enabled:=boStatue;
  if not boOpened then exit;
  g_Config.boTestServer:=boStatue;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxServiceModeClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boServiceMode:=CheckBoxServiceMode.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxVentureModeClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boVentureServer:=CheckBoxVentureMode.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxNonPKModeClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boNonPKServer:=CheckBoxNonPKMode.Checked;
  ModValue();
end;

procedure TfrmGameConfig.EditTestLevelKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  EditTestLevel.Tag:=EditTestLevel.Value;
end;

procedure TfrmGameConfig.EditTestLevelChange(Sender: TObject);
begin
  
  if EditTestLevel.Text = '' then begin
    EditTestLevel.Tag:=1;
    EditTestLevel.Text:='0';
    exit;
  end;
  if (EditTestLevel.Tag = 1) and (EditTestLevel.Value <> 0) then begin
    EditTestLevel.Tag:=0;
    EditTestLevel.Value:=EditTestLevel.Value div 10;
  end;
    
  if not boOpened then exit;
  g_Config.nTestLevel:=EditTestLevel.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditTestGoldChange(Sender: TObject);
begin
  if EditTestGold.Text = '' then begin
    EditTestGold.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nTestGold:=EditTestGold.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditTestUserLimitChange(Sender: TObject);
begin
  if EditTestUserLimit.Text = '' then begin
    EditTestUserLimit.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nTestUserLimit:=EditTestUserLimit.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditStartPermissionChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nStartPermission:=EditStartPermission.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditUserFullChange(Sender: TObject);
begin
  if EditUserFull.Text = '' then begin
    EditUserFull.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nUserFull:=EditUserFull.Value;
  ModValue();
end;


procedure TfrmGameConfig.EditHumanMaxGoldChange(Sender: TObject);
begin
  if EditHumanMaxGold.Text = '' then begin
    EditHumanMaxGold.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nHumanMaxGold:=EditHumanMaxGold.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditHumanTryModeMaxGoldChange(Sender: TObject);
begin
  if EditHumanTryModeMaxGold.Text = '' then begin
    EditHumanTryModeMaxGold.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nHumanTryModeMaxGold:=EditHumanTryModeMaxGold.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditTryModeLevelChange(Sender: TObject);
begin
  if EditTryModeLevel.Text = '' then begin
    EditTryModeLevel.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nTryModeLevel:=EditTryModeLevel.Value;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxTryModeUseStorageClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boTryModeUseStorage:=CheckBoxTryModeUseStorage.Checked;
  ModValue();
end;

procedure TfrmGameConfig.ButtonOptionSave0Click(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteString('Server','TestServer',BoolToStr(g_Config.boTestServer));
  Config.WriteInteger('Server','TestLevel',g_Config.nTestLevel);
  Config.WriteInteger('Server','TestGold',g_Config.nTestGold);
  Config.WriteInteger('Server','TestServerUserLimit',g_Config.nTestUserLimit);
  Config.WriteString('Server','ServiceMode',BoolToStr(g_Config.boServiceMode));
  Config.WriteString('Server','NonPKServer',BoolToStr(g_Config.boNonPKServer));
  Config.WriteString('Server','VentureServer',BoolToStr(g_Config.boVentureServer));
  Config.WriteInteger('Setup','StartPermission',g_Config.nStartPermission);
  Config.WriteInteger('Server','UserFull',g_Config.nUserFull);

  Config.WriteInteger('Setup','HumanMaxGold',g_Config.nHumanMaxGold);
  Config.WriteInteger('Setup','HumanTryModeMaxGold',g_Config.nHumanTryModeMaxGold);
  Config.WriteInteger('Setup','TryModeLevel',g_Config.nTryModeLevel);
  Config.WriteBool('Setup','TryModeUseStorage',g_Config.boTryModeUseStorage);
  Config.WriteInteger('Setup','GroupMembersMax',g_Config.nGroupMembersMax);
{$IFEND}  
  uModValue();
end;



procedure TfrmGameConfig.EditSayMsgMaxLenChange(Sender: TObject);
begin
  if EditSayMsgMaxLen.Text = '' then begin
    EditSayMsgMaxLen.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nSayMsgMaxLen:=EditSayMsgMaxLen.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditSayRedMsgMaxLenChange(Sender: TObject);
begin
  if EditSayRedMsgMaxLen.Text = '' then begin
    EditSayRedMsgMaxLen.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nSayRedMsgMaxLen:=EditSayRedMsgMaxLen.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditCanShoutMsgLevelChange(Sender: TObject);
begin
  if EditCanShoutMsgLevel.Text = '' then begin
    EditCanShoutMsgLevel.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nCanShoutMsgLevel:=EditCanShoutMsgLevel.Value;
  ModValue();
end;




procedure TfrmGameConfig.EditSayMsgTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwSayMsgTime:=EditSayMsgTime.Value * 1000;
  ModValue();
end;

procedure TfrmGameConfig.EditSayMsgCountChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nSayMsgCount:=EditSayMsgCount.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditDisableSayMsgTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwDisableSayMsgTime:=EditDisableSayMsgTime.Value * 1000;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxShutRedMsgShowGMNameClick(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boShutRedMsgShowGMName:=CheckBoxShutRedMsgShowGMName.Checked;
  ModValue();
end;


procedure TfrmGameConfig.CheckBoxShowPreFixMsgClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boShowPreFixMsg:=CheckBoxShowPreFixMsg.Checked;
  ModValue();
end;

procedure TfrmGameConfig.EditGMRedMsgCmdChange(Sender: TObject);
var
  sCmd:String;
begin
  if not boOpened then exit;
  sCmd:=EditGMRedMsgCmd.Text;
  g_GMRedMsgCmd:=sCmd[1];
  ModValue();
end;

procedure TfrmGameConfig.ButtonMsgSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup','SayMsgMaxLen',g_Config.nSayMsgMaxLen);
  Config.WriteInteger('Setup','SayMsgTime',g_Config.dwSayMsgTime);
  Config.WriteInteger('Setup','SayMsgCount',g_Config.nSayMsgCount);
  Config.WriteInteger('Setup','SayRedMsgMaxLen',g_Config.nSayRedMsgMaxLen);
  Config.WriteBool('Setup','ShutRedMsgShowGMName',g_Config.boShutRedMsgShowGMName);
  Config.WriteInteger('Setup','CanShoutMsgLevel',g_Config.nCanShoutMsgLevel);
  CommandConf.WriteString('Command','GMRedMsgCmd',g_GMRedMsgCmd);
  Config.WriteBool('Setup','ShowPreFixMsg',g_Config.boShowPreFixMsg);
{$IFEND}
  uModValue();
end;

procedure TfrmGameConfig.EditStartCastleWarDaysChange(Sender: TObject);
begin
  if EditStartCastleWarDays.Text = '' then begin
    EditStartCastleWarDays.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nStartCastleWarDays:=EditStartCastleWarDays.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditStartCastlewarTimeChange(Sender: TObject);
begin
  if EditStartCastlewarTime.Text = '' then begin
    EditStartCastlewarTime.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nStartCastlewarTime:=EditStartCastlewarTime.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditShowCastleWarEndMsgTimeChange(
  Sender: TObject);
begin
  if EditShowCastleWarEndMsgTime.Text = '' then begin
    EditShowCastleWarEndMsgTime.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.dwShowCastleWarEndMsgTime:=EditShowCastleWarEndMsgTime.Value * (60 * 1000);
  ModValue();
end;

procedure TfrmGameConfig.EditCastleWarTimeChange(Sender: TObject);
begin
  if EditCastleWarTime.Text = '' then begin
    EditCastleWarTime.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.dwCastleWarTime:=EditCastleWarTime.Value * (60 * 1000);
  ModValue();
end;

procedure TfrmGameConfig.EditGetCastleTimeChange(Sender: TObject);
begin
  if EditGetCastleTime.Text = '' then begin
    EditGetCastleTime.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.dwGetCastleTime:=EditGetCastleTime.Value * (60 * 1000);
  ModValue();
end;

procedure TfrmGameConfig.EditGuildWarTimeChange(Sender: TObject);
begin
  if EditGuildWarTime.Text = '' then begin
    EditGuildWarTime.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.dwGuildWarTime:=EditGuildWarTime.Value * (60 * 1000);
  ModValue();
end;

procedure TfrmGameConfig.EditMakeGhostTimeChange(Sender: TObject);
begin
  if EditMakeGhostTime.Text = '' then begin
    EditMakeGhostTime.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.dwMakeGhostTime:=EditMakeGhostTime.Value * 1000;
  ModValue();
end;

procedure TfrmGameConfig.EditClearDropOnFloorItemTimeChange(
  Sender: TObject);
begin
  if EditClearDropOnFloorItemTime.Text = '' then begin
    EditClearDropOnFloorItemTime.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.dwClearDropOnFloorItemTime:=EditClearDropOnFloorItemTime.Value * 1000;
  ModValue();
end;

procedure TfrmGameConfig.EditSaveHumanRcdTimeChange(Sender: TObject);
begin
  if EditSaveHumanRcdTime.Text = '' then begin
    EditSaveHumanRcdTime.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.dwSaveHumanRcdTime:=EditSaveHumanRcdTime.Value * (60 * 1000);
  ModValue();
end;

procedure TfrmGameConfig.EditHumanFreeDelayTimeChange(Sender: TObject);
begin
  if EditHumanFreeDelayTime.Text = '' then begin
    EditHumanFreeDelayTime.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.dwHumanFreeDelayTime:=EditHumanFreeDelayTime.Value * (60 * 1000);
  ModValue();
end;

procedure TfrmGameConfig.EditFloorItemCanPickUpTimeChange(Sender: TObject);
begin
  if EditFloorItemCanPickUpTime.Text = '' then begin
    EditFloorItemCanPickUpTime.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.dwFloorItemCanPickUpTime:=EditFloorItemCanPickUpTime.Value * 1000;
  ModValue();
end;

procedure TfrmGameConfig.ButtonTimeSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
 Config.WriteInteger('Setup','StartCastleWarDays',  g_Config.nStartCastleWarDays);
 Config.WriteInteger('Setup','StartCastlewarTime',  g_Config.nStartCastlewarTime);
 Config.WriteInteger('Setup','ShowCastleWarEndMsgTime',  g_Config.dwShowCastleWarEndMsgTime);
 Config.WriteInteger('Setup','CastleWarTime',  g_Config.dwCastleWarTime);
 Config.WriteInteger('Setup','GetCastleTime',  g_Config.dwGetCastleTime);
 Config.WriteInteger('Setup','GuildWarTime',  g_Config.dwGuildWarTime);
 Config.WriteInteger('Setup','SaveHumanRcdTime',g_Config.dwSaveHumanRcdTime);
 Config.WriteInteger('Setup','HumanFreeDelayTime',g_Config.dwHumanFreeDelayTime);
 Config.WriteInteger('Setup','MakeGhostTime',g_Config.dwMakeGhostTime);
 Config.WriteInteger('Setup','ClearDropOnFloorItemTime',g_Config.dwClearDropOnFloorItemTime);
 Config.WriteInteger('Setup','FloorItemCanPickUpTime',g_Config.dwFloorItemCanPickUpTime);
{$IFEND} 
 uModValue();
end;

procedure TfrmGameConfig.EditBuildGuildPriceChange(Sender: TObject);
begin
  if EditBuildGuildPrice.Text = '' then begin
    EditBuildGuildPrice.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nBuildGuildPrice:=EditBuildGuildPrice.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditGuildWarPriceChange(Sender: TObject);
begin
  if EditGuildWarPrice.Text = '' then begin
    EditGuildWarPrice.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nGuildWarPrice:=EditGuildWarPrice.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditMakeDurgPriceChange(Sender: TObject);
begin
  if EditMakeDurgPrice.Text = '' then begin
    EditMakeDurgPrice.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nMakeDurgPrice:=EditMakeDurgPrice.Value;
  ModValue();
end;


procedure TfrmGameConfig.EditSuperRepairPriceRateChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nSuperRepairPriceRate:=EditSuperRepairPriceRate.Value;
  ModValue();
end;

procedure TfrmGameConfig.EditRepairItemDecDuraChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nRepairItemDecDura:=EditRepairItemDecDura.Value;
  ModValue();
end;

procedure TfrmGameConfig.ButtonPriceSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
 Config.WriteInteger('Setup','BuildGuild',g_Config.nBuildGuildPrice);
 Config.WriteInteger('Setup','MakeDurg',g_Config.nMakeDurgPrice);
 Config.WriteInteger('Setup','GuildWarFee',g_Config.nGuildWarPrice);
 Config.WriteInteger('Setup','SuperRepairPriceRate',g_Config.nSuperRepairPriceRate);
 Config.WriteInteger('Setup','RepairItemDecDura',g_Config.nRepairItemDecDura);
{$IFEND} 
 uModValue();
end;


procedure TfrmGameConfig.EditHearMsgFColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditHearMsgFColor.Value;
  LabeltHearMsgFColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btHearMsgFColor:=btColor;
  ModValue();

end;

procedure TfrmGameConfig.EdittHearMsgBColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EdittHearMsgBColor.Value;
  LabelHearMsgBColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btHearMsgBColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditWhisperMsgFColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditWhisperMsgFColor.Value;
  LabelWhisperMsgFColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btWhisperMsgFColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditWhisperMsgBColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditWhisperMsgBColor.Value;
  LabelWhisperMsgBColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btWhisperMsgBColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditGMWhisperMsgFColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditGMWhisperMsgFColor.Value;
  LabelGMWhisperMsgFColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btGMWhisperMsgFColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditGMWhisperMsgBColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditGMWhisperMsgBColor.Value;
  LabelGMWhisperMsgBColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btGMWhisperMsgBColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditRedMsgFColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditRedMsgFColor.Value;
  LabelRedMsgFColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btRedMsgFColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditRedMsgBColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditRedMsgBColor.Value;
  LabelRedMsgBColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btRedMsgBColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditGreenMsgFColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditGreenMsgFColor.Value;
  LabelGreenMsgFColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btGreenMsgFColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditGreenMsgBColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditGreenMsgBColor.Value;
  LabelGreenMsgBColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btGreenMsgBColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditBlueMsgFColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditBlueMsgFColor.Value;
  LabelBlueMsgFColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btBlueMsgFColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditBlueMsgBColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditBlueMsgBColor.Value;
  LabelBlueMsgBColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btBlueMsgBColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditCryMsgFColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditCryMsgFColor.Value;
  LabelCryMsgFColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btCryMsgFColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditCryMsgBColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditCryMsgBColor.Value;
  LabelCryMsgBColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btCryMsgBColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditGuildMsgFColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditGuildMsgFColor.Value;
  LabelGuildMsgFColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btGuildMsgFColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditGuildMsgBColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditGuildMsgBColor.Value;
  LabelGuildMsgBColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btGuildMsgBColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditGroupMsgFColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditGroupMsgFColor.Value;
  LabelGroupMsgFColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btGroupMsgFColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditGroupMsgBColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditGroupMsgBColor.Value;
  LabelGroupMsgBColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btGroupMsgBColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditCustMsgFColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditCustMsgFColor.Value;
  LabelCustMsgFColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btCustMsgFColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.EditCustMsgBColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditCustMsgBColor.Value;
  LabelCustMsgBColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btCustMsgBColor:=btColor;
  ModValue();
end;

procedure TfrmGameConfig.ButtonMsgColorSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
 Config.WriteInteger('Setup','HearMsgFColor',g_Config.btHearMsgFColor);
 Config.WriteInteger('Setup','HearMsgBColor', g_Config.btHearMsgBColor);
 Config.WriteInteger('Setup','WhisperMsgFColor', g_Config.btWhisperMsgFColor);
 Config.WriteInteger('Setup','WhisperMsgBColor', g_Config.btWhisperMsgBColor);
 Config.WriteInteger('Setup','GMWhisperMsgFColor', g_Config.btGMWhisperMsgFColor);
 Config.WriteInteger('Setup','GMWhisperMsgBColor', g_Config.btGMWhisperMsgBColor);
 Config.WriteInteger('Setup','CryMsgFColor', g_Config.btCryMsgFColor);
 Config.WriteInteger('Setup','CryMsgBColor', g_Config.btCryMsgBColor);
 Config.WriteInteger('Setup','GreenMsgFColor', g_Config.btGreenMsgFColor);
 Config.WriteInteger('Setup','GreenMsgBColor', g_Config.btGreenMsgBColor);
 Config.WriteInteger('Setup','BlueMsgFColor', g_Config.btBlueMsgFColor);
 Config.WriteInteger('Setup','BlueMsgBColor', g_Config.btBlueMsgBColor);
 Config.WriteInteger('Setup','RedMsgFColor', g_Config.btRedMsgFColor);
 Config.WriteInteger('Setup','RedMsgBColor', g_Config.btRedMsgBColor);
 Config.WriteInteger('Setup','GuildMsgFColor', g_Config.btGuildMsgFColor);
 Config.WriteInteger('Setup','GuildMsgBColor', g_Config.btGuildMsgBColor);
 Config.WriteInteger('Setup','GroupMsgFColor', g_Config.btGroupMsgFColor);
 Config.WriteInteger('Setup','GroupMsgBColor', g_Config.btGroupMsgBColor);
 Config.WriteInteger('Setup','CustMsgFColor', g_Config.btCustMsgFColor);
 Config.WriteInteger('Setup','CustMsgBColor', g_Config.btCustMsgBColor);
{$IFEND}
 uModValue();
end;

procedure TfrmGameConfig.ButtonHumanDieSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
 Config.WriteBool('Setup','DieScatterBag', g_Config.boDieScatterBag);
 Config.WriteInteger('Setup','DieScatterBagRate',g_Config.nDieScatterBagRate);
 Config.WriteBool('Setup','DieRedScatterBagAll',g_Config.boDieRedScatterBagAll);
 Config.WriteInteger('Setup','DieDropUseItemRate',g_Config.nDieDropUseItemRate);
 Config.WriteInteger('Setup','DieRedDropUseItemRate',g_Config.nDieRedDropUseItemRate);
 Config.WriteBool('Setup','DieDropGold',g_Config.boDieDropGold);
 Config.WriteBool('Setup','KillByHumanDropUseItem',g_Config.boKillByHumanDropUseItem);
 Config.WriteBool('Setup','KillByMonstDropUseItem',g_Config.boKillByMonstDropUseItem);
{$IFEND}
 uModValue();
end;

procedure TfrmGameConfig.ScrollBarDieDropUseItemRateChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarDieDropUseItemRate.Position;
  EditDieDropUseItemRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  g_Config.nDieDropUseItemRate:=nPostion;
  ModValue();
end;

procedure TfrmGameConfig.ScrollBarDieRedDropUseItemRateChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarDieRedDropUseItemRate.Position;
  EditDieRedDropUseItemRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  g_Config.nDieRedDropUseItemRate:=nPostion;
  ModValue();
end;

procedure TfrmGameConfig.ScrollBarDieScatterBagRateChange(Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarDieScatterBagRate.Position;
  EditDieScatterBagRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  g_Config.nDieScatterBagRate:=nPostion;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxKillByMonstDropUseItemClick(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boKillByMonstDropUseItem:=CheckBoxKillByMonstDropUseItem.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxKillByHumanDropUseItemClick(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boKillByHumanDropUseItem:=CheckBoxKillByHumanDropUseItem.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxDieScatterBagClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boDieScatterBag:=CheckBoxDieScatterBag.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxDieDropGoldClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boDieDropGold:=CheckBoxDieDropGold.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxDieRedScatterBagAllClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boDieRedScatterBagAll:=CheckBoxDieRedScatterBagAll.Checked;
  ModValue();
end;

procedure TfrmGameConfig.RefCharStatusConf;
begin
  CheckBoxParalyCanRun.Checked:=g_Config.ClientConf.boParalyCanRun;
  CheckBoxParalyCanWalk.Checked:=g_Config.ClientConf.boParalyCanWalk;
  CheckBoxParalyCanHit.Checked:=g_Config.ClientConf.boParalyCanHit;
  CheckBoxParalyCanSpell.Checked:=g_Config.ClientConf.boParalyCanSpell;
end;

procedure TfrmGameConfig.ButtonCharStatusSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup','ParalyCanRun',g_Config.ClientConf.boParalyCanRun);
  Config.WriteBool('Setup','ParalyCanWalk',g_Config.ClientConf.boParalyCanWalk);
  Config.WriteBool('Setup','ParalyCanHit',g_Config.ClientConf.boParalyCanHit);
  Config.WriteBool('Setup','ParalyCanSpell',g_Config.ClientConf.boParalyCanSpell);
{$IFEND}
  uModValue();
end;

procedure TfrmGameConfig.CheckBoxParalyCanRunClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.ClientConf.boParalyCanRun:=CheckBoxParalyCanRun.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxParalyCanWalkClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.ClientConf.boParalyCanWalk:=CheckBoxParalyCanWalk.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxParalyCanHitClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.ClientConf.boParalyCanHit:=CheckBoxParalyCanHit.Checked;
  ModValue();
end;

procedure TfrmGameConfig.CheckBoxParalyCanSpellClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.ClientConf.boParalyCanSpell:=CheckBoxParalyCanSpell.Checked;
  ModValue();
end;




procedure TfrmGameConfig.ButtonActionSpeedConfigClick(Sender: TObject);
begin
  frmActionSpeed:=TfrmActionSpeed.Create(Owner);
  frmActionSpeed.Top:=Top + 20;
  frmActionSpeed.Left:=Left;
  frmActionSpeed.Open;
  frmActionSpeed.Free;
end;


procedure TfrmGameConfig.CheckBoxSZRunAllClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSafeZoneRunAll := CheckBoxSZRunAll.Checked;
  ModValue();
end;

end.
