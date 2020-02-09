unit FunctionConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Spin, Grids,grobal2;

type
  TfrmFunctionConfig = class(TForm)
    FunctionConfigControl: TPageControl;
    TabSheetGeneral: TTabSheet;
    GroupBox7: TGroupBox;
    CheckBoxHungerSystem: TCheckBox;
    GroupBoxHunger: TGroupBox;
    CheckBoxHungerDecPower: TCheckBox;
    CheckBoxHungerDecHP: TCheckBox;
    ButtonGeneralSave: TButton;
    GroupBox34: TGroupBox;
    Label85: TLabel;
    LabelPKFlagNameColor: TLabel;
    Label87: TLabel;
    LabelPKLevel1NameColor: TLabel;
    Label89: TLabel;
    LabelPKLevel2NameColor: TLabel;
    Label91: TLabel;
    LabelAllyAndGuildNameColor: TLabel;
    Label93: TLabel;
    LabelWarGuildNameColor: TLabel;
    Label95: TLabel;
    LabelInFreePKAreaNameColor: TLabel;
    EditPKFlagNameColor: TSpinEdit;
    EditPKLevel1NameColor: TSpinEdit;
    EditPKLevel2NameColor: TSpinEdit;
    EditAllyAndGuildNameColor: TSpinEdit;
    EditWarGuildNameColor: TSpinEdit;
    EditInFreePKAreaNameColor: TSpinEdit;
    GroupBox51: TGroupBox;
    CheckBox1: TCheckBox;
    PasswordSheet: TTabSheet;
    GroupBox1: TGroupBox;
    CheckBoxEnablePasswordLock: TCheckBox;
    GroupBox2: TGroupBox;
    CheckBoxLockGetBackItem: TCheckBox;
    GroupBox4: TGroupBox;
    CheckBoxLockWalk: TCheckBox;
    CheckBoxLockRun: TCheckBox;
    CheckBoxLockHit: TCheckBox;
    CheckBoxLockSpell: TCheckBox;
    CheckBoxLockSendMsg: TCheckBox;
    CheckBoxLockInObMode: TCheckBox;
    CheckBoxLockLogin: TCheckBox;
    CheckBoxLockUseItem: TCheckBox;
    CheckBoxLockDropItem: TCheckBox;
    CheckBoxLockDealItem: TCheckBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    EditErrorPasswordCount: TSpinEdit;
    CheckBoxErrorCountKick: TCheckBox;
    ButtonPasswordLockSave: TButton;
    TabSheet38: TTabSheet;
    GroupBox29: TGroupBox;
    Label56: TLabel;
    LabelReNewNameColor1: TLabel;
    Label58: TLabel;
    LabelReNewNameColor2: TLabel;
    Label60: TLabel;
    LabelReNewNameColor3: TLabel;
    Label62: TLabel;
    LabelReNewNameColor4: TLabel;
    Label64: TLabel;
    LabelReNewNameColor5: TLabel;
    Label66: TLabel;
    LabelReNewNameColor6: TLabel;
    Label68: TLabel;
    LabelReNewNameColor7: TLabel;
    Label70: TLabel;
    LabelReNewNameColor8: TLabel;
    Label72: TLabel;
    LabelReNewNameColor9: TLabel;
    Label74: TLabel;
    LabelReNewNameColor10: TLabel;
    EditReNewNameColor1: TSpinEdit;
    EditReNewNameColor2: TSpinEdit;
    EditReNewNameColor3: TSpinEdit;
    EditReNewNameColor4: TSpinEdit;
    EditReNewNameColor5: TSpinEdit;
    EditReNewNameColor6: TSpinEdit;
    EditReNewNameColor7: TSpinEdit;
    EditReNewNameColor8: TSpinEdit;
    EditReNewNameColor9: TSpinEdit;
    EditReNewNameColor10: TSpinEdit;
    ButtonReNewLevelSave: TButton;
    GroupBox30: TGroupBox;
    Label57: TLabel;
    Label59: TLabel;
    EditReNewNameColorTime: TSpinEdit;
    CheckBoxReNewChangeColor: TCheckBox;
    GroupBox33: TGroupBox;
    CheckBoxReNewLevelClearExp: TCheckBox;
    TabSheet39: TTabSheet;
    ButtonMonUpgradeSave: TButton;
    GroupBox32: TGroupBox;
    Label65: TLabel;
    LabelMonUpgradeColor1: TLabel;
    Label67: TLabel;
    LabelMonUpgradeColor2: TLabel;
    Label69: TLabel;
    LabelMonUpgradeColor3: TLabel;
    Label71: TLabel;
    LabelMonUpgradeColor4: TLabel;
    Label73: TLabel;
    LabelMonUpgradeColor5: TLabel;
    Label75: TLabel;
    LabelMonUpgradeColor6: TLabel;
    Label76: TLabel;
    LabelMonUpgradeColor7: TLabel;
    Label77: TLabel;
    LabelMonUpgradeColor8: TLabel;
    Label86: TLabel;
    LabelMonUpgradeColor9: TLabel;
    EditMonUpgradeColor1: TSpinEdit;
    EditMonUpgradeColor2: TSpinEdit;
    EditMonUpgradeColor3: TSpinEdit;
    EditMonUpgradeColor4: TSpinEdit;
    EditMonUpgradeColor5: TSpinEdit;
    EditMonUpgradeColor6: TSpinEdit;
    EditMonUpgradeColor7: TSpinEdit;
    EditMonUpgradeColor8: TSpinEdit;
    EditMonUpgradeColor9: TSpinEdit;
    GroupBox31: TGroupBox;
    Label61: TLabel;
    Label63: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    EditMonUpgradeKillCount1: TSpinEdit;
    EditMonUpgradeKillCount2: TSpinEdit;
    EditMonUpgradeKillCount3: TSpinEdit;
    EditMonUpgradeKillCount4: TSpinEdit;
    EditMonUpgradeKillCount5: TSpinEdit;
    EditMonUpgradeKillCount6: TSpinEdit;
    EditMonUpgradeKillCount7: TSpinEdit;
    EditMonUpLvNeedKillBase: TSpinEdit;
    EditMonUpLvRate: TSpinEdit;
    GroupBox35: TGroupBox;
    Label88: TLabel;
    Label90: TLabel;
    Label92: TLabel;
    CheckBoxMasterDieMutiny: TCheckBox;
    EditMasterDieMutinyRate: TSpinEdit;
    EditMasterDieMutinyPower: TSpinEdit;
    EditMasterDieMutinySpeed: TSpinEdit;
    GroupBox47: TGroupBox;
    Label112: TLabel;
    CheckBoxBBMonAutoChangeColor: TCheckBox;
    EditBBMonAutoChangeColorTime: TSpinEdit;
    MonSaySheet: TTabSheet;
    GroupBox40: TGroupBox;
    CheckBoxMonSayMsg: TCheckBox;
    ButtonMonSayMsgSave: TButton;
    TabSheet1: TTabSheet;
    MagicPageControl: TPageControl;
    TabSheet36: TTabSheet;
    GroupBox17: TGroupBox;
    Label12: TLabel;
    EditMagicAttackRage: TSpinEdit;
    TabSheet30: TTabSheet;
    TabSheet11: TTabSheet;
    GroupBox9: TGroupBox;
    CheckBoxLimitSwordLong: TCheckBox;
    GroupBox10: TGroupBox;
    Label4: TLabel;
    Label10: TLabel;
    EditSwordLongPowerRate: TSpinEdit;
    TabSheet23: TTabSheet;
    FiresWordTab: TTabSheet;
    TabSheet24: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    TabSheet10: TTabSheet;
    TabSheet18: TTabSheet;
    GroupBox38: TGroupBox;
    Label98: TLabel;
    EditMagTammingLevel: TSpinEdit;
    GroupBox39: TGroupBox;
    Label99: TLabel;
    Label100: TLabel;
    EditMagTammingTargetLevel: TSpinEdit;
    EditMagTammingHPRate: TSpinEdit;
    GroupBox45: TGroupBox;
    Label111: TLabel;
    EditTammingCount: TSpinEdit;
    TabSheet19: TTabSheet;
    TabSheet20: TTabSheet;
    GroupBox46: TGroupBox;
    CheckBoxFireCrossInSafeZone: TCheckBox;
    TabSheet27: TTabSheet;
    TabSheet28: TTabSheet;
    GroupBox37: TGroupBox;
    Label97: TLabel;
    EditMagTurnUndeadLevel: TSpinEdit;
    TabSheet22: TTabSheet;
    GroupBox15: TGroupBox;
    Label9: TLabel;
    EditElecBlizzardRange: TSpinEdit;
    TabSheet21: TTabSheet;
    GroupBox13: TGroupBox;
    Label7: TLabel;
    EditFireBoomRage: TSpinEdit;
    TabSheet29: TTabSheet;
    GroupBox14: TGroupBox;
    Label8: TLabel;
    EditSnowWindRange: TSpinEdit;
    TabSheet5: TTabSheet;
    TabSheet26: TTabSheet;
    TabSheet6: TTabSheet;
    GroupBox16: TGroupBox;
    Label11: TLabel;
    EditAmyOunsulPoint: TSpinEdit;
    TabSheet31: TTabSheet;
    TabSheet12: TTabSheet;
    TabSheet13: TTabSheet;
    TabSheet14: TTabSheet;
    TabSheet15: TTabSheet;
    TabSheet16: TTabSheet;
    TabSheet17: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox5: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    EditBoneFammName: TEdit;
    EditBoneFammCount: TSpinEdit;
    GroupBox6: TGroupBox;
    GridBoneFamm: TStringGrid;
    TabSheet4: TTabSheet;
    GroupBox11: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    EditDogzName: TEdit;
    EditDogzCount: TSpinEdit;
    GroupBox12: TGroupBox;
    GridDogz: TStringGrid;
    TabSheet25: TTabSheet;
    TabSheet41: TTabSheet;
    GroupBox41: TGroupBox;
    Label101: TLabel;
    Label102: TLabel;
    EditMabMabeHitRandRate: TSpinEdit;
    EditMabMabeHitMinLvLimit: TSpinEdit;
    GroupBox42: TGroupBox;
    Label103: TLabel;
    EditMabMabeHitSucessRate: TSpinEdit;
    GroupBox43: TGroupBox;
    Label104: TLabel;
    EditMabMabeHitMabeTimeRate: TSpinEdit;
    TabSheet43: TTabSheet;
    GroupBox48: TGroupBox;
    Label118: TLabel;
    CheckBoxGroupMbAttackPlayObject: TCheckBox;
    CheckBoxGroupMbAttackbaobao: TCheckBox;
    ButtonSkillSave: TButton;
    TabSheet34: TTabSheet;
    GroupBox8: TGroupBox;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    EditUpgradeWeaponMaxPoint: TSpinEdit;
    EditUpgradeWeaponPrice: TSpinEdit;
    EditUPgradeWeaponGetBackTime: TSpinEdit;
    EditClearExpireUpgradeWeaponDays: TSpinEdit;
    GroupBox18: TGroupBox;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    ScrollBarUpgradeWeaponDCRate: TScrollBar;
    EditUpgradeWeaponDCRate: TEdit;
    ScrollBarUpgradeWeaponDCTwoPointRate: TScrollBar;
    EditUpgradeWeaponDCTwoPointRate: TEdit;
    ScrollBarUpgradeWeaponDCThreePointRate: TScrollBar;
    EditUpgradeWeaponDCThreePointRate: TEdit;
    GroupBox19: TGroupBox;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    ScrollBarUpgradeWeaponSCRate: TScrollBar;
    EditUpgradeWeaponSCRate: TEdit;
    ScrollBarUpgradeWeaponSCTwoPointRate: TScrollBar;
    EditUpgradeWeaponSCTwoPointRate: TEdit;
    ScrollBarUpgradeWeaponSCThreePointRate: TScrollBar;
    EditUpgradeWeaponSCThreePointRate: TEdit;
    GroupBox20: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    ScrollBarUpgradeWeaponMCRate: TScrollBar;
    EditUpgradeWeaponMCRate: TEdit;
    ScrollBarUpgradeWeaponMCTwoPointRate: TScrollBar;
    EditUpgradeWeaponMCTwoPointRate: TEdit;
    ScrollBarUpgradeWeaponMCThreePointRate: TScrollBar;
    EditUpgradeWeaponMCThreePointRate: TEdit;
    ButtonUpgradeWeaponSave: TButton;
    ButtonUpgradeWeaponDefaulf: TButton;
    TabSheet35: TTabSheet;
    GroupBox24: TGroupBox;
    Label32: TLabel;
    Label33: TLabel;
    ScrollBarMakeMineHitRate: TScrollBar;
    EditMakeMineHitRate: TEdit;
    ScrollBarMakeMineRate: TScrollBar;
    EditMakeMineRate: TEdit;
    GroupBox25: TGroupBox;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    ScrollBarStoneTypeRate: TScrollBar;
    EditStoneTypeRate: TEdit;
    ScrollBarGoldStoneMax: TScrollBar;
    EditGoldStoneMax: TEdit;
    ScrollBarSilverStoneMax: TScrollBar;
    EditSilverStoneMax: TEdit;
    ScrollBarSteelStoneMax: TScrollBar;
    EditSteelStoneMax: TEdit;
    EditBlackStoneMax: TEdit;
    ScrollBarBlackStoneMax: TScrollBar;
    ButtonMakeMineSave: TButton;
    GroupBox26: TGroupBox;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    EditStoneMinDura: TSpinEdit;
    EditStoneGeneralDuraRate: TSpinEdit;
    EditStoneAddDuraRate: TSpinEdit;
    EditStoneAddDuraMax: TSpinEdit;
    ButtonMakeMineDefault: TButton;
    TabSheet42: TTabSheet;
    GroupBox44: TGroupBox;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label110: TLabel;
    ScrollBarWeaponMakeUnLuckRate: TScrollBar;
    EditWeaponMakeUnLuckRate: TEdit;
    ScrollBarWeaponMakeLuckPoint1: TScrollBar;
    EditWeaponMakeLuckPoint1: TEdit;
    ScrollBarWeaponMakeLuckPoint2: TScrollBar;
    EditWeaponMakeLuckPoint2: TEdit;
    ScrollBarWeaponMakeLuckPoint2Rate: TScrollBar;
    EditWeaponMakeLuckPoint2Rate: TEdit;
    EditWeaponMakeLuckPoint3: TEdit;
    ScrollBarWeaponMakeLuckPoint3: TScrollBar;
    ScrollBarWeaponMakeLuckPoint3Rate: TScrollBar;
    EditWeaponMakeLuckPoint3Rate: TEdit;
    ButtonWeaponMakeLuckDefault: TButton;
    ButtonWeaponMakeLuckSave: TButton;
    TabSheet40: TTabSheet;
    GroupBox36: TGroupBox;
    Label94: TLabel;
    Label96: TLabel;
    CheckBoxSpiritMutiny: TCheckBox;
    EditSpiritMutinyTime: TSpinEdit;
    EditSpiritPowerRate: TSpinEdit;
    ButtonSpiritMutinySave: TButton;
    procedure CheckBoxEnablePasswordLockClick(Sender: TObject);
    procedure CheckBoxLockGetBackItemClick(Sender: TObject);
    procedure CheckBoxLockDealItemClick(Sender: TObject);
    procedure CheckBoxLockDropItemClick(Sender: TObject);
    procedure CheckBoxLockWalkClick(Sender: TObject);
    procedure CheckBoxLockRunClick(Sender: TObject);
    procedure CheckBoxLockHitClick(Sender: TObject);
    procedure CheckBoxLockSpellClick(Sender: TObject);
    procedure CheckBoxLockSendMsgClick(Sender: TObject);
    procedure CheckBoxLockInObModeClick(Sender: TObject);
    procedure EditErrorPasswordCountChange(Sender: TObject);
    procedure ButtonPasswordLockSaveClick(Sender: TObject);
    procedure CheckBoxErrorCountKickClick(Sender: TObject);
    procedure CheckBoxLockLoginClick(Sender: TObject);
    procedure CheckBoxLockUseItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxHungerSystemClick(Sender: TObject);
    procedure CheckBoxHungerDecHPClick(Sender: TObject);
    procedure CheckBoxHungerDecPowerClick(Sender: TObject);
    procedure ButtonGeneralSaveClick(Sender: TObject);
    procedure CheckBoxLimitSwordLongClick(Sender: TObject);
    procedure ButtonSkillSaveClick(Sender: TObject);
    procedure EditBoneFammNameChange(Sender: TObject);
    procedure EditBoneFammCountChange(Sender: TObject);
    procedure EditSwordLongPowerRateChange(Sender: TObject);
    procedure EditFireBoomRageChange(Sender: TObject);
    procedure EditSnowWindRangeChange(Sender: TObject);
    procedure EditElecBlizzardRangeChange(Sender: TObject);
    procedure EditDogzCountChange(Sender: TObject);
    procedure EditDogzNameChange(Sender: TObject);
    procedure GridBoneFammSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure EditAmyOunsulPointChange(Sender: TObject);
    procedure EditMagicAttackRageChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponDCRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponDCTwoPointRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponDCThreePointRateChange(
      Sender: TObject);
    procedure ScrollBarUpgradeWeaponSCRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponSCTwoPointRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponSCThreePointRateChange(
      Sender: TObject);
    procedure ScrollBarUpgradeWeaponMCRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponMCTwoPointRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponMCThreePointRateChange(
      Sender: TObject);
    procedure EditUpgradeWeaponMaxPointChange(Sender: TObject);
    procedure EditUpgradeWeaponPriceChange(Sender: TObject);
    procedure EditUPgradeWeaponGetBackTimeChange(Sender: TObject);
    procedure EditClearExpireUpgradeWeaponDaysChange(Sender: TObject);
    procedure ButtonUpgradeWeaponSaveClick(Sender: TObject);
    procedure ScrollBarMakeMineHitRateChange(Sender: TObject);
    procedure ScrollBarMakeMineRateChange(Sender: TObject);
    procedure ScrollBarStoneTypeRateChange(Sender: TObject);
    procedure ScrollBarGoldStoneMaxChange(Sender: TObject);
    procedure ScrollBarSilverStoneMaxChange(Sender: TObject);
    procedure ScrollBarSteelStoneMaxChange(Sender: TObject);
    procedure ScrollBarBlackStoneMaxChange(Sender: TObject);
    procedure ButtonMakeMineSaveClick(Sender: TObject);
    procedure EditStoneMinDuraChange(Sender: TObject);
    procedure EditStoneGeneralDuraRateChange(Sender: TObject);
    procedure EditStoneAddDuraRateChange(Sender: TObject);
    procedure EditStoneAddDuraMaxChange(Sender: TObject);

//取消彩票功能
//    procedure ButtonWinLotterySaveClick(Sender: TObject);
//    procedure EditWinLottery1GoldChange(Sender: TObject);
//    procedure EditWinLottery2GoldChange(Sender: TObject);
//    procedure EditWinLottery3GoldChange(Sender: TObject);
//    procedure EditWinLottery4GoldChange(Sender: TObject);
//    procedure EditWinLottery5GoldChange(Sender: TObject);
//    procedure EditWinLottery6GoldChange(Sender: TObject);
//    procedure ScrollBarWinLottery1MaxChange(Sender: TObject);
//    procedure ScrollBarWinLottery2MaxChange(Sender: TObject);
//    procedure ScrollBarWinLottery3MaxChange(Sender: TObject);
//    procedure ScrollBarWinLottery4MaxChange(Sender: TObject);
//    procedure ScrollBarWinLottery5MaxChange(Sender: TObject);
//    procedure ScrollBarWinLottery6MaxChange(Sender: TObject);
//    procedure ScrollBarWinLotteryRateChange(Sender: TObject);

    procedure ButtonReNewLevelSaveClick(Sender: TObject);
    procedure EditReNewNameColor1Change(Sender: TObject);
    procedure EditReNewNameColor2Change(Sender: TObject);
    procedure EditReNewNameColor3Change(Sender: TObject);
    procedure EditReNewNameColor4Change(Sender: TObject);
    procedure EditReNewNameColor5Change(Sender: TObject);
    procedure EditReNewNameColor6Change(Sender: TObject);
    procedure EditReNewNameColor7Change(Sender: TObject);
    procedure EditReNewNameColor8Change(Sender: TObject);
    procedure EditReNewNameColor9Change(Sender: TObject);
    procedure EditReNewNameColor10Change(Sender: TObject);
    procedure EditReNewNameColorTimeChange(Sender: TObject);
    procedure FunctionConfigControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure ButtonMonUpgradeSaveClick(Sender: TObject);
    procedure EditMonUpgradeColor1Change(Sender: TObject);
    procedure EditMonUpgradeColor2Change(Sender: TObject);
    procedure EditMonUpgradeColor3Change(Sender: TObject);
    procedure EditMonUpgradeColor4Change(Sender: TObject);
    procedure EditMonUpgradeColor5Change(Sender: TObject);
    procedure EditMonUpgradeColor6Change(Sender: TObject);
    procedure EditMonUpgradeColor7Change(Sender: TObject);
    procedure EditMonUpgradeColor8Change(Sender: TObject);
    procedure EditMonUpgradeColor9Change(Sender: TObject);
    procedure CheckBoxReNewChangeColorClick(Sender: TObject);
    procedure CheckBoxReNewLevelClearExpClick(Sender: TObject);
    procedure EditPKFlagNameColorChange(Sender: TObject);
    procedure EditPKLevel1NameColorChange(Sender: TObject);
    procedure EditPKLevel2NameColorChange(Sender: TObject);
    procedure EditAllyAndGuildNameColorChange(Sender: TObject);
    procedure EditWarGuildNameColorChange(Sender: TObject);
    procedure EditInFreePKAreaNameColorChange(Sender: TObject);
    procedure EditMonUpgradeKillCount1Change(Sender: TObject);
    procedure EditMonUpgradeKillCount2Change(Sender: TObject);
    procedure EditMonUpgradeKillCount3Change(Sender: TObject);
    procedure EditMonUpgradeKillCount4Change(Sender: TObject);
    procedure EditMonUpgradeKillCount5Change(Sender: TObject);
    procedure EditMonUpgradeKillCount6Change(Sender: TObject);
    procedure EditMonUpgradeKillCount7Change(Sender: TObject);
    procedure EditMonUpLvNeedKillBaseChange(Sender: TObject);
    procedure EditMonUpLvRateChange(Sender: TObject);
    procedure CheckBoxMasterDieMutinyClick(Sender: TObject);
    procedure EditMasterDieMutinyRateChange(Sender: TObject);
    procedure EditMasterDieMutinyPowerChange(Sender: TObject);
    procedure EditMasterDieMutinySpeedChange(Sender: TObject);
    procedure ButtonSpiritMutinySaveClick(Sender: TObject);
    procedure CheckBoxSpiritMutinyClick(Sender: TObject);
    procedure EditSpiritMutinyTimeChange(Sender: TObject);
    procedure EditSpiritPowerRateChange(Sender: TObject);
    procedure EditMagTurnUndeadLevelChange(Sender: TObject);
    procedure EditMagTammingLevelChange(Sender: TObject);
    procedure EditMagTammingTargetLevelChange(Sender: TObject);
    procedure EditMagTammingHPRateChange(Sender: TObject);
    procedure ButtonMonSayMsgSaveClick(Sender: TObject);
    procedure CheckBoxMonSayMsgClick(Sender: TObject);
    procedure ButtonUpgradeWeaponDefaulfClick(Sender: TObject);
    procedure ButtonMakeMineDefaultClick(Sender: TObject);
    
//取消彩票功能
//    procedure ButtonWinLotteryDefaultClick(Sender: TObject);

    procedure EditMabMabeHitRandRateChange(Sender: TObject);
    procedure EditMabMabeHitMinLvLimitChange(Sender: TObject);
    procedure EditMabMabeHitSucessRateChange(Sender: TObject);
    procedure EditMabMabeHitMabeTimeRateChange(Sender: TObject);
    procedure ButtonWeaponMakeLuckDefaultClick(Sender: TObject);
    procedure ButtonWeaponMakeLuckSaveClick(Sender: TObject);
    procedure ScrollBarWeaponMakeUnLuckRateChange(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint1Change(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint2Change(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint2RateChange(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint3Change(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint3RateChange(Sender: TObject);
    procedure EditTammingCountChange(Sender: TObject);
    procedure CheckBoxFireCrossInSafeZoneClick(Sender: TObject);
    procedure CheckBoxBBMonAutoChangeColorClick(Sender: TObject);
    procedure EditBBMonAutoChangeColorTimeChange(Sender: TObject);
    procedure CheckBoxGroupMbAttackPlayObjectClick(Sender: TObject);
    procedure CheckBoxGroupMbAttackbaobaoClick(Sender: TObject);

  private
    boOpened:Boolean;
    boModValued:Boolean;
    procedure ModValue();
    procedure uModValue();
    procedure RefReNewLevelConf;
    procedure RefUpgradeWeapon;
    procedure RefMakeMine;
    
//取消彩票功能
//    procedure RefWinLottery;

    procedure RefMonUpgrade;
    procedure RefGeneral;
    procedure RefSpiritMutiny;
    procedure RefMagicSkill;
    procedure RefMonSayMsg;
    procedure RefWeaponMakeLuck();
    { Private declarations }
  public
    procedure Open;
    { Public declarations }
  end;

var
  frmFunctionConfig: TfrmFunctionConfig;

implementation

uses M2Share, HUtil32, SDK;

{$R *.dfm}

{ TfrmFunctionConfig }

procedure TfrmFunctionConfig.ModValue;
begin
  boModValued:=True;
  ButtonPasswordLockSave.Enabled:=True;
  ButtonGeneralSave.Enabled:=True;
  ButtonSkillSave.Enabled:=True;
  ButtonUpgradeWeaponSave.Enabled:=True;
//  ButtonMasterSave.Enabled:=True;
  ButtonMakeMineSave.Enabled:=True;
//  ButtonWinLotterySave.Enabled:=True;
  ButtonReNewLevelSave.Enabled:=True;
  ButtonMonUpgradeSave.Enabled:=True;
  ButtonSpiritMutinySave.Enabled:=True;
  ButtonMonSayMsgSave.Enabled:=True;
end;

procedure TfrmFunctionConfig.uModValue;
begin
  boModValued:=False;
  ButtonPasswordLockSave.Enabled:=False;
  ButtonGeneralSave.Enabled:=False;
  ButtonSkillSave.Enabled:=False;
  ButtonUpgradeWeaponSave.Enabled:=False;
//  ButtonMasterSave.Enabled:=False;
  ButtonMakeMineSave.Enabled:=False;
//  ButtonWinLotterySave.Enabled:=False;
  ButtonReNewLevelSave.Enabled:=False;
  ButtonMonUpgradeSave.Enabled:=False;
  ButtonSpiritMutinySave.Enabled:=False;
  ButtonMonSayMsgSave.Enabled:=False;
end;
procedure TfrmFunctionConfig.FunctionConfigControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if boModValued then begin
    if Application.MessageBox('参数设置已经被修改，是否确认不保存修改的设置？','确认信息',MB_YESNO + MB_ICONQUESTION) = IDYES then begin
      uModValue
    end else AllowChange:=False;
  end;
end;
procedure TfrmFunctionConfig.Open;
var
  I:Integer;
begin
  boOpened:=False;
  uModValue();

  RefGeneral();
  CheckBoxHungerSystem.Checked:=g_Config.boHungerSystem;
  CheckBoxHungerDecHP.Checked:=g_Config.boHungerDecHP;
  CheckBoxHungerDecPower.Checked:=g_Config.boHungerDecPower;

  CheckBoxHungerSystemClick(CheckBoxHungerSystem);
    

  CheckBoxEnablePasswordLock.Checked:=g_Config.boPasswordLockSystem;
  CheckBoxLockGetBackItem.Checked:=g_Config.boLockGetBackItemAction;
  CheckBoxLockDealItem.Checked:=g_Config.boLockDealAction;
  CheckBoxLockDropItem.Checked:=g_Config.boLockDropAction;
  CheckBoxLockWalk.Checked:=g_Config.boLockWalkAction;
  CheckBoxLockRun.Checked:=g_Config.boLockRunAction;
  CheckBoxLockHit.Checked:=g_Config.boLockHitAction;
  CheckBoxLockSpell.Checked:=g_Config.boLockSpellAction;
  CheckBoxLockSendMsg.Checked:=g_Config.boLockSendMsgAction;
  CheckBoxLockInObMode.Checked:=g_Config.boLockInObModeAction;

  CheckBoxLockLogin.Checked:=g_Config.boLockHumanLogin;
  CheckBoxLockUseItem.Checked:=g_Config.boLockUserItemAction;

  CheckBoxEnablePasswordLockClick(CheckBoxEnablePasswordLock);
  CheckBoxLockLoginClick(CheckBoxLockLogin);

  EditErrorPasswordCount.Value:=g_Config.nPasswordErrorCountLock;


  EditBoneFammName.Text:=g_Config.sSkeleton;
  EditBoneFammCount.Value:=g_Config.nSkeletonCount;

  for I := Low(g_Config.SkeletonArray) to High(g_Config.SkeletonArray) do begin
    if g_Config.SkeletonArray[I].nHumLevel <= 0 then break;

    GridBoneFamm.Cells[0,I + 1]:=IntToStr(g_Config.SkeletonArray[I].nHumLevel);
    GridBoneFamm.Cells[1,I + 1]:=g_Config.SkeletonArray[I].sMonName;
    GridBoneFamm.Cells[2,I + 1]:=IntToStr(g_Config.SkeletonArray[I].nCount);
    GridBoneFamm.Cells[3,I + 1]:=IntToStr(g_Config.SkeletonArray[I].nLevel);
  end;

  EditDogzName.Text:=g_Config.sDragon;
  EditDogzCount.Value:=g_Config.nDragonCount;
  for I := Low(g_Config.DragonArray) to High(g_Config.DragonArray) do begin
    if g_Config.DragonArray[I].nHumLevel <= 0 then break;
    GridDogz.Cells[0,I + 1]:=IntToStr(g_Config.DragonArray[I].nHumLevel);
    GridDogz.Cells[1,I + 1]:=g_Config.DragonArray[I].sMonName;
    GridDogz.Cells[2,I + 1]:=IntToStr(g_Config.DragonArray[I].nCount);
    GridDogz.Cells[3,I + 1]:=IntToStr(g_Config.DragonArray[I].nLevel);
  end;

  RefMagicSkill();

  RefUpgradeWeapon();
  RefMakeMine();

//取消彩票功能  
//  RefWinLottery();

  RefReNewLevelConf();
  RefMonUpgrade();
  RefSpiritMutiny();
  RefMonSayMsg();
  RefWeaponMakeLuck();
  boOpened:=True;
  FunctionConfigControl.ActivePageIndex:=0;
  ShowModal;
end;

procedure TfrmFunctionConfig.FormCreate(Sender: TObject);
begin
  GridBoneFamm.Cells[0,0]:='人物等级';
  GridBoneFamm.Cells[1,0]:='怪物名称';
  GridBoneFamm.Cells[2,0]:='数量';
  GridBoneFamm.Cells[3,0]:='等级';

  GridDogz.Cells[0,0]:='人物等级';
  GridDogz.Cells[1,0]:='怪物名称';
  GridDogz.Cells[2,0]:='数量';
  GridDogz.Cells[3,0]:='等级';
  FunctionConfigControl.ActivePageIndex:=0;
  MagicPageControl.ActivePageIndex:=0;
{$IF (SoftVersion = VERPRO) or (SoftVersion = VERENT)}
  CheckBoxHungerDecPower.Visible:=True;
{$ELSE}
  CheckBoxHungerDecPower.Visible:=False;
{$IFEND}

{$IF SoftVersion = VERDEMO}
  Caption:='功能设置[演示版本，所有设置调整有效，但不能保存]'
{$IFEND}
end;

procedure TfrmFunctionConfig.CheckBoxEnablePasswordLockClick(
  Sender: TObject);
begin
  case CheckBoxEnablePasswordLock.Checked of
    True: begin
      CheckBoxLockGetBackItem.Enabled:=True;
      CheckBoxLockLogin.Enabled:=True;
    end;
    False: begin
      CheckBoxLockGetBackItem.Checked:=False;
      CheckBoxLockLogin.Checked:=False;

      CheckBoxLockGetBackItem.Enabled:=False;
      CheckBoxLockLogin.Enabled:=False;
    end;
  end;
  if not boOpened then exit;
  g_Config.boPasswordLockSystem:=CheckBoxEnablePasswordLock.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockGetBackItemClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boLockGetBackItemAction:=CheckBoxLockGetBackItem.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockDealItemClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boLockDealAction:=CheckBoxLockDealItem.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockDropItemClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boLockDropAction:=CheckBoxLockDropItem.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockUseItemClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boLockUserItemAction:=CheckBoxLockUseItem.Checked;
  ModValue();

end;

procedure TfrmFunctionConfig.CheckBoxLockLoginClick(Sender: TObject);
begin
  case CheckBoxLockLogin.Checked of    //
    True: begin
      CheckBoxLockWalk.Enabled:=True;
      CheckBoxLockRun.Enabled:=True;
      CheckBoxLockHit.Enabled:=True;
      CheckBoxLockSpell.Enabled:=True;
      CheckBoxLockInObMode.Enabled:=True;
      CheckBoxLockSendMsg.Enabled:=True;
      CheckBoxLockDealItem.Enabled:=True;
      CheckBoxLockDropItem.Enabled:=True;
      CheckBoxLockUseItem.Enabled:=True;
    end;
    False: begin
      CheckBoxLockWalk.Checked:=False;
      CheckBoxLockRun.Checked:=False;
      CheckBoxLockHit.Checked:=False;
      CheckBoxLockSpell.Checked:=False;
      CheckBoxLockInObMode.Checked:=False;
      CheckBoxLockSendMsg.Checked:=False;
      CheckBoxLockDealItem.Checked:=False;
      CheckBoxLockDropItem.Checked:=False;
      CheckBoxLockUseItem.Checked:=False;

      CheckBoxLockWalk.Enabled:=False;
      CheckBoxLockRun.Enabled:=False;
      CheckBoxLockHit.Enabled:=False;
      CheckBoxLockSpell.Enabled:=False;
      CheckBoxLockInObMode.Enabled:=False;
      CheckBoxLockSendMsg.Enabled:=False;
      CheckBoxLockDealItem.Enabled:=False;
      CheckBoxLockDropItem.Enabled:=False;
      CheckBoxLockUseItem.Enabled:=False;
    end;
  end;
  if not boOpened then exit;
  g_Config.boLockHumanLogin:=CheckBoxLockLogin.Checked;
  ModValue();

end;

procedure TfrmFunctionConfig.CheckBoxLockWalkClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boLockWalkAction:=CheckBoxLockWalk.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockRunClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boLockRunAction:=CheckBoxLockRun.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockHitClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boLockHitAction:=CheckBoxLockHit.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockSpellClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boLockSpellAction:=CheckBoxLockSpell.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockSendMsgClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boLockSendMsgAction:=CheckBoxLockSendMsg.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLockInObModeClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boLockInObModeAction:=CheckBoxLockInObMode.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditErrorPasswordCountChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nPasswordErrorCountLock:=EditErrorPasswordCount.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxErrorCountKickClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nPasswordErrorCountLock:=EditErrorPasswordCount.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.ButtonPasswordLockSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup','PasswordLockSystem',g_Config.boPasswordLockSystem);
  Config.WriteBool('Setup','PasswordLockDealAction',g_Config.boLockDealAction);
  Config.WriteBool('Setup','PasswordLockDropAction',g_Config.boLockDropAction);
  Config.WriteBool('Setup','PasswordLockGetBackItemAction',g_Config.boLockGetBackItemAction);
  Config.WriteBool('Setup','PasswordLockWalkAction',g_Config.boLockWalkAction);
  Config.WriteBool('Setup','PasswordLockRunAction',g_Config.boLockRunAction);
  Config.WriteBool('Setup','PasswordLockHitAction',g_Config.boLockHitAction);
  Config.WriteBool('Setup','PasswordLockSpellAction',g_Config.boLockSpellAction);
  Config.WriteBool('Setup','PasswordLockSendMsgAction',g_Config.boLockSendMsgAction);
  Config.WriteBool('Setup','PasswordLockInObModeAction',g_Config.boLockInObModeAction);
  Config.WriteBool('Setup','PasswordLockUserItemAction',g_Config.boLockUserItemAction);

  Config.WriteBool('Setup','PasswordLockHumanLogin',g_Config.boLockHumanLogin);
  Config.WriteInteger('Setup','PasswordErrorCountLock',g_Config.nPasswordErrorCountLock);

{$IFEND}
  uModValue();
end;


procedure TfrmFunctionConfig.RefGeneral();
begin
  EditPKFlagNameColor.Value:=g_Config.btPKFlagNameColor;
  EditPKLevel1NameColor.Value:=g_Config.btPKLevel1NameColor;
  EditPKLevel2NameColor.Value:=g_Config.btPKLevel2NameColor;
  EditAllyAndGuildNameColor.Value:=g_Config.btAllyAndGuildNameColor;
  EditWarGuildNameColor.Value:=g_Config.btWarGuildNameColor;
  EditInFreePKAreaNameColor.Value:=g_Config.btInFreePKAreaNameColor;
end;

procedure TfrmFunctionConfig.CheckBoxHungerSystemClick(Sender: TObject);
begin
  if CheckBoxHungerSystem.Checked then begin
    CheckBoxHungerDecHP.Enabled:=True;
    CheckBoxHungerDecPower.Enabled:=True;
  end else begin
    CheckBoxHungerDecHP.Checked:=False;
    CheckBoxHungerDecPower.Checked:=False;
    CheckBoxHungerDecHP.Enabled:=False;
    CheckBoxHungerDecPower.Enabled:=False;
  end;
    
  if not boOpened then exit;
  g_Config.boHungerSystem:=CheckBoxHungerSystem.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxHungerDecHPClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boHungerDecHP:=CheckBoxHungerDecHP.Checked;
  ModValue();

end;

procedure TfrmFunctionConfig.CheckBoxHungerDecPowerClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boHungerDecPower:=CheckBoxHungerDecPower.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.ButtonGeneralSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup','HungerSystem',g_Config.boHungerSystem);
  Config.WriteBool('Setup','HungerDecHP',g_Config.boHungerDecHP);
  Config.WriteBool('Setup','HungerDecPower',g_Config.boHungerDecPower);

  Config.WriteInteger('Setup','PKFlagNameColor',g_Config.btPKFlagNameColor);
  Config.WriteInteger('Setup','AllyAndGuildNameColor',g_Config.btAllyAndGuildNameColor);
  Config.WriteInteger('Setup','WarGuildNameColor',g_Config.btWarGuildNameColor);
  Config.WriteInteger('Setup','InFreePKAreaNameColor',g_Config.btInFreePKAreaNameColor);
  Config.WriteInteger('Setup','PKLevel1NameColor',g_Config.btPKLevel1NameColor);
  Config.WriteInteger('Setup','PKLevel2NameColor',g_Config.btPKLevel2NameColor);
{$IFEND}  
  uModValue();
end;

procedure TfrmFunctionConfig.EditMagicAttackRageChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMagicAttackRage:=EditMagicAttackRage.Value;
  ModValue();

end;
procedure TfrmFunctionConfig.RefMagicSkill;
begin
  EditSwordLongPowerRate.Value:=g_Config.nSwordLongPowerRate;
  CheckBoxLimitSwordLong.Checked:=g_Config.boLimitSwordLong;
  EditFireBoomRage.Value:=g_Config.nFireBoomRage;
  EditSnowWindRange.Value:=g_Config.nSnowWindRange;
  EditElecBlizzardRange.Value:=g_Config.nElecBlizzardRange;
  EditMagicAttackRage.Value:=g_Config.nMagicAttackRage;
  EditAmyOunsulPoint.Value:=g_Config.nAmyOunsulPoint;
  EditMagTurnUndeadLevel.Value:=g_Config.nMagTurnUndeadLevel;
  EditMagTammingLevel.Value:=g_Config.nMagTammingLevel;
  EditMagTammingTargetLevel.Value:=g_Config.nMagTammingTargetLevel;
  EditMagTammingHPRate.Value:=g_Config.nMagTammingHPRate;
  EditTammingCount.Value:=g_Config.nMagTammingCount;
  EditMabMabeHitRandRate.Value:=g_Config.nMabMabeHitRandRate;
  EditMabMabeHitMinLvLimit.Value:=g_Config.nMabMabeHitMinLvLimit;
  EditMabMabeHitSucessRate.Value:=g_Config.nMabMabeHitSucessRate;
  EditMabMabeHitMabeTimeRate.Value:=g_Config.nMabMabeHitMabeTimeRate;
  CheckBoxFireCrossInSafeZone.Checked:=g_Config.boDisableInSafeZoneFireCross;
  CheckBoxGroupMbAttackPlayObject.Checked:=g_Config.boGroupMbAttackPlayObject;
end;

procedure TfrmFunctionConfig.EditBoneFammCountChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nSkeletonCount:=EditBoneFammCount.Value;
  ModValue();
end;
procedure TfrmFunctionConfig.EditDogzCountChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nDragonCount:=EditDogzCount.Value;
  ModValue();
end;
procedure TfrmFunctionConfig.CheckBoxLimitSwordLongClick(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boLimitSwordLong:=CheckBoxLimitSwordLong.Checked;
  ModValue();
end;
procedure TfrmFunctionConfig.EditSwordLongPowerRateChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nSwordLongPowerRate:=EditSwordLongPowerRate.Value;
  ModValue()
end;
procedure TfrmFunctionConfig.EditBoneFammNameChange(Sender: TObject);
begin
  if not boOpened then exit;
  ModValue();
end;
procedure TfrmFunctionConfig.EditDogzNameChange(Sender: TObject);
begin
  if not boOpened then exit;
  ModValue();
end;
procedure TfrmFunctionConfig.EditFireBoomRageChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nFireBoomRage:=EditFireBoomRage.Value;
  ModValue();
end;
procedure TfrmFunctionConfig.EditSnowWindRangeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nSnowWindRange:=EditSnowWindRange.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditElecBlizzardRangeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nElecBlizzardRange:=EditElecBlizzardRange.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMagTurnUndeadLevelChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMagTurnUndeadLevel:=EditMagTurnUndeadLevel.Value;
  ModValue();
end;
procedure TfrmFunctionConfig.GridBoneFammSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  if not boOpened then exit;
  ModValue();
end;
procedure TfrmFunctionConfig.EditAmyOunsulPointChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nAmyOunsulPoint:=EditAmyOunsulPoint.Value;
  ModValue();
end;


procedure TfrmFunctionConfig.CheckBoxFireCrossInSafeZoneClick(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boDisableInSafeZoneFireCross:=CheckBoxFireCrossInSafeZone.Checked;
  ModValue();
end;


procedure TfrmFunctionConfig.CheckBoxGroupMbAttackPlayObjectClick(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boGroupMbAttackPlayObject:=CheckBoxGroupMbAttackPlayObject.Checked;
  ModValue();
end;
procedure TfrmFunctionConfig.ButtonSkillSaveClick(Sender: TObject);
var
  I: Integer;
  RecallArray  :array[0..9] of TRecallMigic;
  Rect: TGridRect;
begin
  FillChar(RecallArray,SizeOf(RecallArray),#0);

  g_Config.sSkeleton:=Trim(EditBoneFammName.Text);

  for I := Low(RecallArray) to High(RecallArray) do begin
    RecallArray[I].nHumLevel:=Str_ToInt(GridBoneFamm.Cells[0,I + 1],-1);
    RecallArray[I].sMonName:=Trim(GridBoneFamm.Cells[1,I + 1]);
    RecallArray[I].nCount:=Str_ToInt(GridBoneFamm.Cells[2,I + 1],-1);
    RecallArray[I].nLevel:=Str_ToInt(GridBoneFamm.Cells[3,I + 1],-1);
    if GridBoneFamm.Cells[0,I + 1] = '' then break;
    if (RecallArray[I].nHumLevel <= 0) then begin
      Application.MessageBox('人物等级设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
      Rect.Left := 0;
      Rect.Top := I + 1;
      Rect.Right := 0;
      Rect.Bottom := I + 1;
      GridBoneFamm.Selection:=Rect;
      exit;
    end;
    if UserEngine.GetMonRace(RecallArray[I].sMonName) <= 0 then begin
      Application.MessageBox('怪物名称设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
      Rect.Left := 1;
      Rect.Top := I + 1;
      Rect.Right := 1;
      Rect.Bottom := I + 1;
      GridBoneFamm.Selection:=Rect;
      exit;
    end;
    if RecallArray[I].nCount <= 0 then begin
      Application.MessageBox('召唤数量设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
      Rect.Left := 2;
      Rect.Top := I + 1;
      Rect.Right := 2;
      Rect.Bottom := I + 1;
      GridBoneFamm.Selection:=Rect;
      exit;
    end;
    if RecallArray[I].nLevel < 0 then begin
      Application.MessageBox('召唤等级设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
      Rect.Left := 3;
      Rect.Top := I + 1;
      Rect.Right := 3;
      Rect.Bottom := I + 1;
      GridBoneFamm.Selection:=Rect;
      exit;
    end;
  end;

  for I := Low(RecallArray) to High(RecallArray) do begin
    RecallArray[I].nHumLevel:=Str_ToInt(GridDogz.Cells[0,I + 1],-1);
    RecallArray[I].sMonName:=Trim(GridDogz.Cells[1,I + 1]);
    RecallArray[I].nCount:=Str_ToInt(GridDogz.Cells[2,I + 1],-1);
    RecallArray[I].nLevel:=Str_ToInt(GridDogz.Cells[3,I + 1],-1);
    if GridDogz.Cells[0,I + 1] = '' then break;
    if (RecallArray[I].nHumLevel <= 0) then begin
      Application.MessageBox('人物等级设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
      Rect.Left := 0;
      Rect.Top := I + 1;
      Rect.Right := 0;
      Rect.Bottom := I + 1;
      GridDogz.Selection:=Rect;
      exit;
    end;
    if UserEngine.GetMonRace(RecallArray[I].sMonName) <= 0 then begin
      Application.MessageBox('怪物名称设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
      Rect.Left := 1;
      Rect.Top := I + 1;
      Rect.Right := 1;
      Rect.Bottom := I + 1;
      GridDogz.Selection:=Rect;
      exit;
    end;
    if RecallArray[I].nCount <= 0 then begin
      Application.MessageBox('召唤数量设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
      Rect.Left := 2;
      Rect.Top := I + 1;
      Rect.Right := 2;
      Rect.Bottom := I + 1;
      GridDogz.Selection:=Rect;
      exit;
    end;
    if RecallArray[I].nLevel < 0 then begin
      Application.MessageBox('召唤等级设置错误！！！','错误信息',MB_OK + MB_ICONERROR);
      Rect.Left := 3;
      Rect.Top := I + 1;
      Rect.Right := 3;
      Rect.Bottom := I + 1;
      GridDogz.Selection:=Rect;
      exit;
    end;
  end;
  FillChar(g_Config.SkeletonArray,SizeOf(g_Config.SkeletonArray),#0);
  for I := Low(g_Config.SkeletonArray) to High(g_Config.SkeletonArray) do begin
    Config.WriteInteger('Setup','SkeletonHumLevel' + IntToStr(I),0);
    Config.WriteString('Names','Skeleton' + IntToStr(I),'');
    Config.WriteInteger('Setup','SkeletonCount' + IntToStr(I),0);
    Config.WriteInteger('Setup','SkeletonLevel' + IntToStr(I),0);
  end;
  for I := Low(g_Config.SkeletonArray) to High(g_Config.SkeletonArray) do begin
    if GridBoneFamm.Cells[0,I + 1] = '' then break;
    g_Config.SkeletonArray[I].nHumLevel:=Str_ToInt(GridBoneFamm.Cells[0,I + 1],-1);
    g_Config.SkeletonArray[I].sMonName:=Trim(GridBoneFamm.Cells[1,I + 1]);
    g_Config.SkeletonArray[I].nCount:=Str_ToInt(GridBoneFamm.Cells[2,I + 1],-1);
    g_Config.SkeletonArray[I].nLevel:=Str_ToInt(GridBoneFamm.Cells[3,I + 1],-1);

    Config.WriteInteger('Setup','SkeletonHumLevel' + IntToStr(I),g_Config.SkeletonArray[I].nHumLevel);
    Config.WriteString('Names','Skeleton' + IntToStr(I),g_Config.SkeletonArray[I].sMonName);
    Config.WriteInteger('Setup','SkeletonCount' + IntToStr(I),g_Config.SkeletonArray[I].nCount);
    Config.WriteInteger('Setup','SkeletonLevel' + IntToStr(I),g_Config.SkeletonArray[I].nLevel);
  end;

  FillChar(g_Config.DragonArray,SizeOf(g_Config.DragonArray),#0);
  for I := Low(g_Config.DragonArray) to High(g_Config.DragonArray) do begin
    Config.WriteInteger('Setup','DragonHumLevel' + IntToStr(I),0);
    Config.WriteString('Names','Dragon' + IntToStr(I),'');
    Config.WriteInteger('Setup','DragonCount' + IntToStr(I),0);
    Config.WriteInteger('Setup','DragonLevel' + IntToStr(I),0);
  end;
  for I := Low(g_Config.DragonArray) to High(g_Config.DragonArray) do begin
    if GridDogz.Cells[0,I + 1] = '' then break;

    g_Config.DragonArray[I].nHumLevel:=Str_ToInt(GridDogz.Cells[0,I + 1],-1);
    g_Config.DragonArray[I].sMonName:=Trim(GridDogz.Cells[1,I + 1]);
    g_Config.DragonArray[I].nCount:=Str_ToInt(GridDogz.Cells[2,I + 1],-1);
    g_Config.DragonArray[I].nLevel:=Str_ToInt(GridDogz.Cells[3,I + 1],-1);

    Config.WriteInteger('Setup','DragonHumLevel' + IntToStr(I),g_Config.DragonArray[I].nHumLevel);
    Config.WriteString('Names','Dragon' + IntToStr(I),g_Config.DragonArray[I].sMonName);
    Config.WriteInteger('Setup','DragonCount' + IntToStr(I),g_Config.DragonArray[I].nCount);
    Config.WriteInteger('Setup','DragonLevel' + IntToStr(I),g_Config.DragonArray[I].nLevel);
  end;

{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup','LimitSwordLong',g_Config.boLimitSwordLong);
  Config.WriteInteger('Setup','SwordLongPowerRate',g_Config.nSwordLongPowerRate);
  Config.WriteInteger('Setup','SkeletonCount',g_Config.nSkeletonCount);
  Config.WriteString('Names','Skeleton',g_Config.sSkeleton);
  Config.WriteInteger('Setup','DragonCount',g_Config.nDragonCount);
  Config.WriteString('Names','Dragon',g_Config.sDragon);
  Config.WriteInteger('Setup','FireBoomRage',g_Config.nFireBoomRage);
  Config.WriteInteger('Setup','SnowWindRange',g_Config.nSnowWindRange);
  Config.WriteInteger('Setup','ElecBlizzardRange',g_Config.nElecBlizzardRange);
  Config.WriteInteger('Setup','AmyOunsulPoint',g_Config.nAmyOunsulPoint);

  Config.WriteInteger('Setup','MagicAttackRage',g_Config.nMagicAttackRage);
  Config.WriteInteger('Setup','MagTurnUndeadLevel',g_Config.nMagTurnUndeadLevel);
  Config.WriteInteger('Setup','MagTammingLevel',g_Config.nMagTammingLevel);
  Config.WriteInteger('Setup','MagTammingTargetLevel',g_Config.nMagTammingTargetLevel);
  Config.WriteInteger('Setup','MagTammingTargetHPRate',g_Config.nMagTammingHPRate);
  Config.WriteInteger('Setup','MagTammingCount',g_Config.nMagTammingCount);

  Config.WriteInteger('Setup','MabMabeHitRandRate',g_Config.nMabMabeHitRandRate);
  Config.WriteInteger('Setup','MabMabeHitMinLvLimit',g_Config.nMabMabeHitMinLvLimit);
  Config.WriteInteger('Setup','MabMabeHitSucessRate',g_Config.nMabMabeHitSucessRate);
  Config.WriteInteger('Setup','MabMabeHitMabeTimeRate',g_Config.nMabMabeHitMabeTimeRate);

  Config.WriteBool('Setup','DisableInSafeZoneFireCross',g_Config.boDisableInSafeZoneFireCross);
  Config.WriteBool('Setup','GroupMbAttackPlayObject',g_Config.boGroupMbAttackPlayObject);
{$IFEND}
  uModValue();
end;
procedure TfrmFunctionConfig.RefUpgradeWeapon();
begin
  ScrollBarUpgradeWeaponDCRate.Position:=g_Config.nUpgradeWeaponDCRate;
  ScrollBarUpgradeWeaponDCTwoPointRate.Position:=g_Config.nUpgradeWeaponDCTwoPointRate;
  ScrollBarUpgradeWeaponDCThreePointRate.Position:=g_Config.nUpgradeWeaponDCThreePointRate;

  ScrollBarUpgradeWeaponMCRate.Position:=g_Config.nUpgradeWeaponMCRate;
  ScrollBarUpgradeWeaponMCTwoPointRate.Position:=g_Config.nUpgradeWeaponMCTwoPointRate;
  ScrollBarUpgradeWeaponMCThreePointRate.Position:=g_Config.nUpgradeWeaponMCThreePointRate;

  ScrollBarUpgradeWeaponSCRate.Position:=g_Config.nUpgradeWeaponSCRate;
  ScrollBarUpgradeWeaponSCTwoPointRate.Position:=g_Config.nUpgradeWeaponSCTwoPointRate;
  ScrollBarUpgradeWeaponSCThreePointRate.Position:=g_Config.nUpgradeWeaponSCThreePointRate;

  EditUpgradeWeaponMaxPoint.Value:=g_Config.nUpgradeWeaponMaxPoint;
  EditUpgradeWeaponPrice.Value:=g_Config.nUpgradeWeaponPrice;
  EditUPgradeWeaponGetBackTime.Value:=g_Config.dwUPgradeWeaponGetBackTime div 1000;
  EditClearExpireUpgradeWeaponDays.Value:=g_Config.nClearExpireUpgradeWeaponDays;
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponDCRateChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarUpgradeWeaponDCRate.Position;
  EditUpgradeWeaponDCRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  g_Config.nUpgradeWeaponDCRate:=nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponDCTwoPointRateChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarUpgradeWeaponDCTwoPointRate.Position;
  EditUpgradeWeaponDCTwoPointRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  g_Config.nUpgradeWeaponDCTwoPointRate:=nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponDCThreePointRateChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarUpgradeWeaponDCThreePointRate.Position;
  EditUpgradeWeaponDCThreePointRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  g_Config.nUpgradeWeaponDCThreePointRate:=nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponSCRateChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarUpgradeWeaponSCRate.Position;
  EditUpgradeWeaponSCRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  g_Config.nUpgradeWeaponSCRate:=nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponSCTwoPointRateChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarUpgradeWeaponSCTwoPointRate.Position;
  EditUpgradeWeaponSCTwoPointRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  g_Config.nUpgradeWeaponSCTwoPointRate:=nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponSCThreePointRateChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarUpgradeWeaponSCThreePointRate.Position;
  EditUpgradeWeaponSCThreePointRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  g_Config.nUpgradeWeaponSCThreePointRate:=nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponMCRateChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarUpgradeWeaponMCRate.Position;
  EditUpgradeWeaponMCRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  g_Config.nUpgradeWeaponMCRate:=nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponMCTwoPointRateChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarUpgradeWeaponMCTwoPointRate.Position;
  EditUpgradeWeaponMCTwoPointRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  g_Config.nUpgradeWeaponMCTwoPointRate:=nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponMCThreePointRateChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarUpgradeWeaponMCThreePointRate.Position;
  EditUpgradeWeaponMCThreePointRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  g_Config.nUpgradeWeaponMCThreePointRate:=nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.EditUpgradeWeaponMaxPointChange(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nUpgradeWeaponMaxPoint:=EditUpgradeWeaponMaxPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditUpgradeWeaponPriceChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nUpgradeWeaponPrice:=EditUpgradeWeaponPrice.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditUPgradeWeaponGetBackTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwUPgradeWeaponGetBackTime:=EditUPgradeWeaponGetBackTime.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.EditClearExpireUpgradeWeaponDaysChange(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nClearExpireUpgradeWeaponDays:=EditClearExpireUpgradeWeaponDays.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.ButtonUpgradeWeaponSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup','UpgradeWeaponMaxPoint',g_Config.nUpgradeWeaponMaxPoint);
  Config.WriteInteger('Setup','UpgradeWeaponPrice',g_Config.nUpgradeWeaponPrice);
  Config.WriteInteger('Setup','ClearExpireUpgradeWeaponDays',g_Config.nClearExpireUpgradeWeaponDays);
  Config.WriteInteger('Setup','UPgradeWeaponGetBackTime',g_Config.dwUPgradeWeaponGetBackTime);

  Config.WriteInteger('Setup','UpgradeWeaponDCRate',g_Config.nUpgradeWeaponDCRate);
  Config.WriteInteger('Setup','UpgradeWeaponDCTwoPointRate',g_Config.nUpgradeWeaponDCTwoPointRate);
  Config.WriteInteger('Setup','UpgradeWeaponDCThreePointRate',g_Config.nUpgradeWeaponDCThreePointRate);

  Config.WriteInteger('Setup','UpgradeWeaponMCRate',g_Config.nUpgradeWeaponMCRate);
  Config.WriteInteger('Setup','UpgradeWeaponMCTwoPointRate',g_Config.nUpgradeWeaponMCTwoPointRate);
  Config.WriteInteger('Setup','UpgradeWeaponMCThreePointRate',g_Config.nUpgradeWeaponMCThreePointRate);

  Config.WriteInteger('Setup','UpgradeWeaponSCRate',g_Config.nUpgradeWeaponSCRate);
  Config.WriteInteger('Setup','UpgradeWeaponSCTwoPointRate',g_Config.nUpgradeWeaponSCTwoPointRate);
  Config.WriteInteger('Setup','UpgradeWeaponSCThreePointRate',g_Config.nUpgradeWeaponSCThreePointRate);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.ButtonUpgradeWeaponDefaulfClick(
  Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置？', '确认信息', MB_YESNO + MB_ICONQUESTION) <> IDYES then begin
    exit;
  end;
  g_Config.nUpgradeWeaponMaxPoint:=20;
  g_Config.nUpgradeWeaponPrice:=10000;
  g_Config.nClearExpireUpgradeWeaponDays:=8;
  g_Config.dwUPgradeWeaponGetBackTime:=60 * 60 * 1000;

  g_Config.nUpgradeWeaponDCRate:=100;
  g_Config.nUpgradeWeaponDCTwoPointRate:=30;
  g_Config.nUpgradeWeaponDCThreePointRate:=200;

  g_Config.nUpgradeWeaponMCRate:=100;
  g_Config.nUpgradeWeaponMCTwoPointRate:=30;
  g_Config.nUpgradeWeaponMCThreePointRate:=200;

  g_Config.nUpgradeWeaponSCRate:=100;
  g_Config.nUpgradeWeaponSCTwoPointRate:=30;
  g_Config.nUpgradeWeaponSCThreePointRate:=200;
  RefUpgradeWeapon();
end;


procedure TfrmFunctionConfig.ButtonMakeMineSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup','MakeMineHitRate', g_Config.nMakeMineHitRate);
  Config.WriteInteger('Setup','MakeMineRate', g_Config.nMakeMineRate);
  Config.WriteInteger('Setup','StoneTypeRate', g_Config.nStoneTypeRate);
  Config.WriteInteger('Setup','StoneTypeRateMin', g_Config.nStoneTypeRateMin);
  Config.WriteInteger('Setup','GoldStoneMin', g_Config.nGoldStoneMin);
  Config.WriteInteger('Setup','GoldStoneMax', g_Config.nGoldStoneMax);
  Config.WriteInteger('Setup','SilverStoneMin', g_Config.nSilverStoneMin);
  Config.WriteInteger('Setup','SilverStoneMax', g_Config.nSilverStoneMax);
  Config.WriteInteger('Setup','SteelStoneMin', g_Config.nSteelStoneMin);
  Config.WriteInteger('Setup','SteelStoneMax', g_Config.nSteelStoneMax);
  Config.WriteInteger('Setup','BlackStoneMin', g_Config.nBlackStoneMin);
  Config.WriteInteger('Setup','BlackStoneMax', g_Config.nBlackStoneMax);
  Config.WriteInteger('Setup','StoneMinDura', g_Config.nStoneMinDura);
  Config.WriteInteger('Setup','StoneGeneralDuraRate', g_Config.nStoneGeneralDuraRate);
  Config.WriteInteger('Setup','StoneAddDuraRate', g_Config.nStoneAddDuraRate);
  Config.WriteInteger('Setup','StoneAddDuraMax', g_Config.nStoneAddDuraMax);
{$IFEND}
  uModValue();
end;


procedure TfrmFunctionConfig.ButtonMakeMineDefaultClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置？', '确认信息', MB_YESNO + MB_ICONQUESTION) <> IDYES then begin
    exit;
  end;
  g_Config.nMakeMineHitRate:=4;
  g_Config.nMakeMineRate:=12;
  g_Config.nStoneTypeRate:=120;
  g_Config.nStoneTypeRateMin:=56;
  g_Config.nGoldStoneMin:=1;
  g_Config.nGoldStoneMax:=2;
  g_Config.nSilverStoneMin:=3;
  g_Config.nSilverStoneMax:=20;
  g_Config.nSteelStoneMin:=21;
  g_Config.nSteelStoneMax:=45;
  g_Config.nBlackStoneMin:=46;
  g_Config.nBlackStoneMax:=56;
  g_Config.nStoneMinDura:=3000;
  g_Config.nStoneGeneralDuraRate:=13000;
  g_Config.nStoneAddDuraRate:=20;
  g_Config.nStoneAddDuraMax:=10000;
  RefMakeMine();
end;

procedure TfrmFunctionConfig.RefMakeMine();
begin
  ScrollBarMakeMineHitRate.Position:=g_Config.nMakeMineHitRate;
  ScrollBarMakeMineHitRate.Min:=0;
  ScrollBarMakeMineHitRate.Max:=10;

  ScrollBarMakeMineRate.Position:=g_Config.nMakeMineRate;
  ScrollBarMakeMineRate.Min:=0;
  ScrollBarMakeMineRate.Max:=50;

  ScrollBarStoneTypeRate.Position:=g_Config.nStoneTypeRate;
  ScrollBarStoneTypeRate.Min:=g_Config.nStoneTypeRateMin;
  ScrollBarStoneTypeRate.Max:=500;

  ScrollBarGoldStoneMax.Min:=1;
  ScrollBarGoldStoneMax.Max:=g_Config.nSilverStoneMax;

  ScrollBarSilverStoneMax.Min:=g_Config.nGoldStoneMax;
  ScrollBarSilverStoneMax.Max:=g_Config.nSteelStoneMax;

  ScrollBarSteelStoneMax.Min:=g_Config.nSilverStoneMax;
  ScrollBarSteelStoneMax.Max:=g_Config.nBlackStoneMax;

  ScrollBarBlackStoneMax.Min:=g_Config.nSteelStoneMax;
  ScrollBarBlackStoneMax.Max:=g_Config.nStoneTypeRate;

  ScrollBarGoldStoneMax.Position:=g_Config.nGoldStoneMax;
  ScrollBarSilverStoneMax.Position:=g_Config.nSilverStoneMax;
  ScrollBarSteelStoneMax.Position:=g_Config.nSteelStoneMax;
  ScrollBarBlackStoneMax.Position:=g_Config.nBlackStoneMax;

  EditStoneMinDura.Value:=g_Config.nStoneMinDura div 1000;
  EditStoneGeneralDuraRate.Value:=g_Config.nStoneGeneralDuraRate div 1000;
  EditStoneAddDuraRate.Value:=g_Config.nStoneAddDuraRate;
  EditStoneAddDuraMax.Value:=g_Config.nStoneAddDuraMax div 1000;  
end;

procedure TfrmFunctionConfig.ScrollBarMakeMineHitRateChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarMakeMineHitRate.Position;
  EditMakeMineHitRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  g_Config.nMakeMineHitRate:=nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarMakeMineRateChange(Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarMakeMineRate.Position;
  EditMakeMineRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  g_Config.nMakeMineRate:=nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarStoneTypeRateChange(Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarStoneTypeRate.Position;
  EditStoneTypeRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  ScrollBarBlackStoneMax.Max:=nPostion;
  g_Config.nStoneTypeRate:=nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarGoldStoneMaxChange(Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarGoldStoneMax.Position;
  EditGoldStoneMax.Text:=IntToStr(g_Config.nGoldStoneMin) + '-' + IntToStr(g_Config.nGoldStoneMax);
  if not boOpened then exit;
  g_Config.nSilverStoneMin:=nPostion + 1;
  ScrollBarSilverStoneMax.Min:=nPostion + 1;
  g_Config.nGoldStoneMax:=nPostion;
  EditSilverStoneMax.Text:=IntToStr(g_Config.nSilverStoneMin) + '-' + IntToStr(g_Config.nSilverStoneMax);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarSilverStoneMaxChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarSilverStoneMax.Position;
  EditSilverStoneMax.Text:=IntToStr(g_Config.nSilverStoneMin) + '-' + IntToStr(g_Config.nSilverStoneMax);
  if not boOpened then exit;
  ScrollBarGoldStoneMax.Max:=nPostion - 1;
  g_Config.nSteelStoneMin:=nPostion + 1;
  ScrollBarSteelStoneMax.Min:=nPostion + 1;
  g_Config.nSilverStoneMax:=nPostion;
  EditGoldStoneMax.Text:=IntToStr(g_Config.nGoldStoneMin) + '-' + IntToStr(g_Config.nGoldStoneMax);
  EditSteelStoneMax.Text:=IntToStr(g_Config.nSteelStoneMin) + '-' + IntToStr(g_Config.nSteelStoneMax);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarSteelStoneMaxChange(Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarSteelStoneMax.Position;
  EditSteelStoneMax.Text:=IntToStr(g_Config.nSteelStoneMin) + '-' + IntToStr(g_Config.nSteelStoneMax);
  if not boOpened then exit;
  ScrollBarSilverStoneMax.Max:=nPostion - 1;
  g_Config.nBlackStoneMin:=nPostion + 1;
  ScrollBarBlackStoneMax.Min:=nPostion + 1;
  g_Config.nSteelStoneMax:=nPostion;
  EditSilverStoneMax.Text:=IntToStr(g_Config.nSilverStoneMin) + '-' + IntToStr(g_Config.nSilverStoneMax);
  EditBlackStoneMax.Text:=IntToStr(g_Config.nBlackStoneMin) + '-' + IntToStr(g_Config.nBlackStoneMax);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarBlackStoneMaxChange(Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarBlackStoneMax.Position;
  EditBlackStoneMax.Text:=IntToStr(g_Config.nBlackStoneMin) + '-' + IntToStr(g_Config.nBlackStoneMax);
  if not boOpened then exit;
  ScrollBarSteelStoneMax.Max:=nPostion - 1;
  ScrollBarStoneTypeRate.Min:=nPostion;
  g_Config.nBlackStoneMax:=nPostion;
  EditSteelStoneMax.Text:=IntToStr(g_Config.nSteelStoneMin) + '-' + IntToStr(g_Config.nSteelStoneMax);
  ModValue();
end;

procedure TfrmFunctionConfig.EditStoneMinDuraChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nStoneMinDura:=EditStoneMinDura.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.EditStoneGeneralDuraRateChange(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nStoneGeneralDuraRate:=EditStoneGeneralDuraRate.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.EditStoneAddDuraRateChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nStoneAddDuraRate:=EditStoneAddDuraRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditStoneAddDuraMaxChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nStoneAddDuraMax:=EditStoneAddDuraMax.Value * 1000;
  ModValue();
end;

//取消彩票功能
{
procedure TfrmFunctionConfig.RefWinLottery;
begin
  ScrollBarWinLotteryRate.Max:=100000;
  ScrollBarWinLotteryRate.Position:=g_Config.nWinLotteryRate;
  ScrollBarWinLottery1Max.Max:=g_Config.nWinLotteryRate;
  ScrollBarWinLottery1Max.Min:=g_Config.nWinLottery1Min;
  ScrollBarWinLottery2Max.Max:=g_Config.nWinLottery1Max;
  ScrollBarWinLottery2Max.Min:=g_Config.nWinLottery2Min;
  ScrollBarWinLottery3Max.Max:=g_Config.nWinLottery2Max;
  ScrollBarWinLottery3Max.Min:=g_Config.nWinLottery3Min;
  ScrollBarWinLottery4Max.Max:=g_Config.nWinLottery3Max;
  ScrollBarWinLottery4Max.Min:=g_Config.nWinLottery4Min;
  ScrollBarWinLottery5Max.Max:=g_Config.nWinLottery4Max;
  ScrollBarWinLottery5Max.Min:=g_Config.nWinLottery5Min;
  ScrollBarWinLottery6Max.Max:=g_Config.nWinLottery5Max;
  ScrollBarWinLottery6Max.Min:=g_Config.nWinLottery6Min;
  ScrollBarWinLotteryRate.Min:=g_Config.nWinLottery1Max;

  ScrollBarWinLottery1Max.Position:=g_Config.nWinLottery1Max;
  ScrollBarWinLottery2Max.Position:=g_Config.nWinLottery2Max;
  ScrollBarWinLottery3Max.Position:=g_Config.nWinLottery3Max;
  ScrollBarWinLottery4Max.Position:=g_Config.nWinLottery4Max;
  ScrollBarWinLottery5Max.Position:=g_Config.nWinLottery5Max;
  ScrollBarWinLottery6Max.Position:=g_Config.nWinLottery6Max;

  EditWinLottery1Gold.Value:=g_Config.nWinLottery1Gold;
  EditWinLottery2Gold.Value:=g_Config.nWinLottery2Gold;
  EditWinLottery3Gold.Value:=g_Config.nWinLottery3Gold;
  EditWinLottery4Gold.Value:=g_Config.nWinLottery4Gold;
  EditWinLottery5Gold.Value:=g_Config.nWinLottery5Gold;
  EditWinLottery6Gold.Value:=g_Config.nWinLottery6Gold;  
end;
}

//procedure TfrmFunctionConfig.ButtonWinLotterySaveClick(Sender: TObject);
//begin
//{$IF SoftVersion <> VERDEMO}
//  Config.WriteInteger('Setup','WinLottery1Gold', g_Config.nWinLottery1Gold);
//  Config.WriteInteger('Setup','WinLottery2Gold', g_Config.nWinLottery2Gold);
//  Config.WriteInteger('Setup','WinLottery3Gold', g_Config.nWinLottery3Gold);
//  Config.WriteInteger('Setup','WinLottery4Gold', g_Config.nWinLottery4Gold);
//  Config.WriteInteger('Setup','WinLottery5Gold', g_Config.nWinLottery5Gold);
//  Config.WriteInteger('Setup','WinLottery6Gold', g_Config.nWinLottery6Gold);
//  Config.WriteInteger('Setup','WinLottery1Min', g_Config.nWinLottery1Min);
//  Config.WriteInteger('Setup','WinLottery1Max', g_Config.nWinLottery1Max);
//  Config.WriteInteger('Setup','WinLottery2Min', g_Config.nWinLottery2Min);
//  Config.WriteInteger('Setup','WinLottery2Max', g_Config.nWinLottery2Max);
//  Config.WriteInteger('Setup','WinLottery3Min', g_Config.nWinLottery3Min);
//  Config.WriteInteger('Setup','WinLottery3Max', g_Config.nWinLottery3Max);
//  Config.WriteInteger('Setup','WinLottery4Min', g_Config.nWinLottery4Min);
//  Config.WriteInteger('Setup','WinLottery4Max', g_Config.nWinLottery4Max);
//  Config.WriteInteger('Setup','WinLottery5Min', g_Config.nWinLottery5Min);
//  Config.WriteInteger('Setup','WinLottery5Max', g_Config.nWinLottery5Max);
//  Config.WriteInteger('Setup','WinLottery6Min', g_Config.nWinLottery6Min);
//  Config.WriteInteger('Setup','WinLottery6Max', g_Config.nWinLottery6Max);
//  Config.WriteInteger('Setup','WinLotteryRate', g_Config.nWinLotteryRate);
//{$IFEND}
//  uModValue();
//end;

{
procedure TfrmFunctionConfig.ButtonWinLotteryDefaultClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置？', '确认信息', MB_YESNO + MB_ICONQUESTION) <> IDYES then begin
    exit;
  end;


  g_Config.nWinLottery1Gold:=1000000;
  g_Config.nWinLottery2Gold:=200000;
  g_Config.nWinLottery3Gold:=100000;
  g_Config.nWinLottery4Gold:=10000;
  g_Config.nWinLottery5Gold:=1000;
  g_Config.nWinLottery6Gold:=500;
  g_Config.nWinLottery6Min:=1;
  g_Config.nWinLottery6Max:=4999;
  g_Config.nWinLottery5Min:=14000;
  g_Config.nWinLottery5Max:=15999;
  g_Config.nWinLottery4Min:=16000;
  g_Config.nWinLottery4Max:=16149;
  g_Config.nWinLottery3Min:=16150;
  g_Config.nWinLottery3Max:=16169;
  g_Config.nWinLottery2Min:=16170;
  g_Config.nWinLottery2Max:=16179;
  g_Config.nWinLottery1Min:=16180;
  g_Config.nWinLottery1Max:=16185;
  g_Config.nWinLotteryRate:=30000;
  RefWinLottery();
end;

procedure TfrmFunctionConfig.EditWinLottery1GoldChange(Sender: TObject);
begin
  if EditWinLottery1Gold.Text = '' then begin
    EditWinLottery1Gold.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nWinLottery1Gold:=EditWinLottery1Gold.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditWinLottery2GoldChange(Sender: TObject);
begin
  if EditWinLottery2Gold.Text = '' then begin
    EditWinLottery2Gold.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nWinLottery2Gold:=EditWinLottery2Gold.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditWinLottery3GoldChange(Sender: TObject);
begin
  if EditWinLottery3Gold.Text = '' then begin
    EditWinLottery3Gold.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nWinLottery3Gold:=EditWinLottery3Gold.Value;
  ModValue();

end;

procedure TfrmFunctionConfig.EditWinLottery4GoldChange(Sender: TObject);
begin
  if EditWinLottery4Gold.Text = '' then begin
    EditWinLottery4Gold.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nWinLottery4Gold:=EditWinLottery4Gold.Value;
  ModValue();

end;

procedure TfrmFunctionConfig.EditWinLottery5GoldChange(Sender: TObject);
begin
  if EditWinLottery5Gold.Text = '' then begin
    EditWinLottery5Gold.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nWinLottery5Gold:=EditWinLottery5Gold.Value;
  ModValue();

end;

procedure TfrmFunctionConfig.EditWinLottery6GoldChange(Sender: TObject);
begin
  if EditWinLottery6Gold.Text = '' then begin
    EditWinLottery6Gold.Text:='0';
    exit;
  end;
  if not boOpened then exit;
  g_Config.nWinLottery6Gold:=EditWinLottery6Gold.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery1MaxChange(Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarWinLottery1Max.Position;
  EditWinLottery1Max.Text:=IntToStr(g_Config.nWinLottery1Min) + '-' + IntToStr(g_Config.nWinLottery1Max);
  if not boOpened then exit;
  g_Config.nWinLottery1Max:=nPostion;
  ScrollBarWinLottery2Max.Max:=nPostion - 1;
  ScrollBarWinLotteryRate.Min:=nPostion;
  EditWinLottery1Max.Text:=IntToStr(g_Config.nWinLottery1Min) + '-' + IntToStr(g_Config.nWinLottery1Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery2MaxChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarWinLottery2Max.Position;
  EditWinLottery2Max.Text:=IntToStr(g_Config.nWinLottery2Min) + '-' + IntToStr(g_Config.nWinLottery2Max);
  if not boOpened then exit;
  g_Config.nWinLottery1Min:=nPostion + 1;
  ScrollBarWinLottery1Max.Min:=nPostion + 1;
  g_Config.nWinLottery2Max:=nPostion;
  EditWinLottery2Max.Text:=IntToStr(g_Config.nWinLottery2Min) + '-' + IntToStr(g_Config.nWinLottery2Max);
  EditWinLottery1Max.Text:=IntToStr(g_Config.nWinLottery1Min) + '-' + IntToStr(g_Config.nWinLottery1Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery3MaxChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarWinLottery3Max.Position;
  EditWinLottery3Max.Text:=IntToStr(g_Config.nWinLottery3Min) + '-' + IntToStr(g_Config.nWinLottery3Max);
  if not boOpened then exit;
  g_Config.nWinLottery2Min:=nPostion + 1;
  ScrollBarWinLottery2Max.Min:=nPostion + 1;
  g_Config.nWinLottery3Max:=nPostion;
  EditWinLottery3Max.Text:=IntToStr(g_Config.nWinLottery3Min) + '-' + IntToStr(g_Config.nWinLottery3Max);
  EditWinLottery2Max.Text:=IntToStr(g_Config.nWinLottery2Min) + '-' + IntToStr(g_Config.nWinLottery2Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery4MaxChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarWinLottery4Max.Position;
  EditWinLottery4Max.Text:=IntToStr(g_Config.nWinLottery4Min) + '-' + IntToStr(g_Config.nWinLottery4Max);
  if not boOpened then exit;
  g_Config.nWinLottery3Min:=nPostion + 1;
  ScrollBarWinLottery3Max.Min:=nPostion + 1;
  g_Config.nWinLottery4Max:=nPostion;
  EditWinLottery4Max.Text:=IntToStr(g_Config.nWinLottery4Min) + '-' + IntToStr(g_Config.nWinLottery4Max);
  EditWinLottery3Max.Text:=IntToStr(g_Config.nWinLottery3Min) + '-' + IntToStr(g_Config.nWinLottery3Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery5MaxChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarWinLottery5Max.Position;
  EditWinLottery5Max.Text:=IntToStr(g_Config.nWinLottery5Min) + '-' + IntToStr(g_Config.nWinLottery5Max);
  if not boOpened then exit;
  g_Config.nWinLottery4Min:=nPostion + 1;
  ScrollBarWinLottery4Max.Min:=nPostion + 1;
  g_Config.nWinLottery5Max:=nPostion;
  EditWinLottery5Max.Text:=IntToStr(g_Config.nWinLottery5Min) + '-' + IntToStr(g_Config.nWinLottery5Max);
  EditWinLottery4Max.Text:=IntToStr(g_Config.nWinLottery4Min) + '-' + IntToStr(g_Config.nWinLottery4Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery6MaxChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarWinLottery6Max.Position;
  EditWinLottery6Max.Text:=IntToStr(g_Config.nWinLottery6Min) + '-' + IntToStr(g_Config.nWinLottery6Max);
  if not boOpened then exit;
  g_Config.nWinLottery5Min:=nPostion + 1;
  ScrollBarWinLottery5Max.Min:=nPostion + 1;
  g_Config.nWinLottery6Max:=nPostion;
  EditWinLottery6Max.Text:=IntToStr(g_Config.nWinLottery6Min) + '-' + IntToStr(g_Config.nWinLottery6Max);
  EditWinLottery5Max.Text:=IntToStr(g_Config.nWinLottery5Min) + '-' + IntToStr(g_Config.nWinLottery5Max);
  ModValue();

end;

procedure TfrmFunctionConfig.ScrollBarWinLotteryRateChange(
  Sender: TObject);
var
  nPostion:Integer;
begin
  nPostion:=ScrollBarWinLotteryRate.Position;
  EditWinLotteryRate.Text:=IntToStr(nPostion);
  if not boOpened then exit;
  ScrollBarWinLottery1Max.Max:=nPostion;
  g_Config.nWinLotteryRate:=nPostion;
  ModValue();
end;
}

procedure TfrmFunctionConfig.RefReNewLevelConf();
begin
  EditReNewNameColor1.Value:=g_Config.ReNewNameColor[0];
  EditReNewNameColor2.Value:=g_Config.ReNewNameColor[1];
  EditReNewNameColor3.Value:=g_Config.ReNewNameColor[2];
  EditReNewNameColor4.Value:=g_Config.ReNewNameColor[3];
  EditReNewNameColor5.Value:=g_Config.ReNewNameColor[4];
  EditReNewNameColor6.Value:=g_Config.ReNewNameColor[5];
  EditReNewNameColor7.Value:=g_Config.ReNewNameColor[6];
  EditReNewNameColor8.Value:=g_Config.ReNewNameColor[7];
  EditReNewNameColor9.Value:=g_Config.ReNewNameColor[8];
  EditReNewNameColor10.Value:=g_Config.ReNewNameColor[9];
  EditReNewNameColorTime.Value:=g_Config.dwReNewNameColorTime div 1000;
  CheckBoxReNewChangeColor.Checked:=g_Config.boReNewChangeColor;
  CheckBoxReNewLevelClearExp.Checked:=g_Config.boReNewLevelClearExp;
end;

procedure TfrmFunctionConfig.ButtonReNewLevelSaveClick(Sender: TObject);
{$IF SoftVersion <> VERDEMO}
var
  I:Integer;
{$IFEND}
begin
{$IF SoftVersion <> VERDEMO}
  for I := Low(g_Config.ReNewNameColor) to High(g_Config.ReNewNameColor) do begin
    Config.WriteInteger('Setup','ReNewNameColor' + IntToStr(I),g_Config.ReNewNameColor[I]);
  end;
  Config.WriteInteger('Setup','ReNewNameColorTime',g_Config.dwReNewNameColorTime);
  Config.WriteBool('Setup','ReNewChangeColor',g_Config.boReNewChangeColor);
  Config.WriteBool('Setup','ReNewLevelClearExp',g_Config.boReNewLevelClearExp);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor1Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditReNewNameColor1.Value;
  LabelReNewNameColor1.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.ReNewNameColor[0]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor2Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditReNewNameColor2.Value;
  LabelReNewNameColor2.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.ReNewNameColor[1]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor3Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditReNewNameColor3.Value;
  LabelReNewNameColor3.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.ReNewNameColor[2]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor4Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditReNewNameColor4.Value;
  LabelReNewNameColor4.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.ReNewNameColor[3]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor5Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditReNewNameColor5.Value;
  LabelReNewNameColor5.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.ReNewNameColor[4]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor6Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditReNewNameColor6.Value;
  LabelReNewNameColor6.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.ReNewNameColor[5]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor7Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditReNewNameColor7.Value;
  LabelReNewNameColor7.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.ReNewNameColor[6]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor8Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditReNewNameColor8.Value;
  LabelReNewNameColor8.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.ReNewNameColor[7]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor9Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditReNewNameColor9.Value;
  LabelReNewNameColor9.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.ReNewNameColor[8]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor10Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditReNewNameColor10.Value;
  LabelReNewNameColor10.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.ReNewNameColor[9]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColorTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwReNewNameColorTime:=EditReNewNameColorTime.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.RefMonUpgrade();
begin
  EditMonUpgradeColor1.Value:=g_Config.SlaveColor[0];
  EditMonUpgradeColor2.Value:=g_Config.SlaveColor[1];
  EditMonUpgradeColor3.Value:=g_Config.SlaveColor[2];
  EditMonUpgradeColor4.Value:=g_Config.SlaveColor[3];
  EditMonUpgradeColor5.Value:=g_Config.SlaveColor[4];
  EditMonUpgradeColor6.Value:=g_Config.SlaveColor[5];
  EditMonUpgradeColor7.Value:=g_Config.SlaveColor[6];
  EditMonUpgradeColor8.Value:=g_Config.SlaveColor[7];
  EditMonUpgradeColor9.Value:=g_Config.SlaveColor[8];
  EditMonUpgradeKillCount1.Value:=g_Config.MonUpLvNeedKillCount[0];
  EditMonUpgradeKillCount2.Value:=g_Config.MonUpLvNeedKillCount[1];
  EditMonUpgradeKillCount3.Value:=g_Config.MonUpLvNeedKillCount[2];
  EditMonUpgradeKillCount4.Value:=g_Config.MonUpLvNeedKillCount[3];
  EditMonUpgradeKillCount5.Value:=g_Config.MonUpLvNeedKillCount[4];
  EditMonUpgradeKillCount6.Value:=g_Config.MonUpLvNeedKillCount[5];
  EditMonUpgradeKillCount7.Value:=g_Config.MonUpLvNeedKillCount[6];
  EditMonUpLvNeedKillBase.Value:=g_Config.nMonUpLvNeedKillBase;
  EditMonUpLvRate.Value:=g_Config.nMonUpLvRate;

  CheckBoxMasterDieMutiny.Checked:=g_Config.boMasterDieMutiny;
  EditMasterDieMutinyRate.Value:=g_Config.nMasterDieMutinyRate;
  EditMasterDieMutinyPower.Value:=g_Config.nMasterDieMutinyPower;
  EditMasterDieMutinySpeed.Value:=g_Config.nMasterDieMutinySpeed;

  CheckBoxMasterDieMutinyClick(CheckBoxMasterDieMutiny);

  CheckBoxBBMonAutoChangeColor.Checked:=g_Config.boBBMonAutoChangeColor;
  EditBBMonAutoChangeColorTime.Value:=g_Config.dwBBMonAutoChangeColorTime div 1000;
end;

procedure TfrmFunctionConfig.ButtonMonUpgradeSaveClick(Sender: TObject);
{$IF SoftVersion <> VERDEMO}
var
  I:Integer;
{$IFEND}   
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup','MonUpLvNeedKillBase',g_Config.nMonUpLvNeedKillBase);
  Config.WriteInteger('Setup','MonUpLvRate',g_Config.nMonUpLvRate);
  for I := Low(g_Config.MonUpLvNeedKillCount) to High(g_Config.MonUpLvNeedKillCount) do begin
    Config.WriteInteger('Setup','MonUpLvNeedKillCount' + IntToStr(I),g_Config.MonUpLvNeedKillCount[I]);
  end;

  for I := Low(g_Config.SlaveColor) to High(g_Config.SlaveColor) do begin
    Config.WriteInteger('Setup','SlaveColor' + IntToStr(I),g_Config.SlaveColor[I]);
  end;
  Config.WriteBool('Setup','MasterDieMutiny',g_Config.boMasterDieMutiny);
  Config.WriteInteger('Setup','MasterDieMutinyRate',g_Config.nMasterDieMutinyRate);
  Config.WriteInteger('Setup','MasterDieMutinyPower',g_Config.nMasterDieMutinyPower);
  Config.WriteInteger('Setup','MasterDieMutinyPower',g_Config.nMasterDieMutinySpeed);

  Config.WriteBool('Setup','BBMonAutoChangeColor',g_Config.boBBMonAutoChangeColor);
  Config.WriteInteger('Setup','BBMonAutoChangeColorTime',g_Config.dwBBMonAutoChangeColorTime);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor1Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditMonUpgradeColor1.Value;
  LabelMonUpgradeColor1.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.SlaveColor[0]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor2Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditMonUpgradeColor2.Value;
  LabelMonUpgradeColor2.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.SlaveColor[1]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor3Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditMonUpgradeColor3.Value;
  LabelMonUpgradeColor3.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.SlaveColor[2]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor4Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditMonUpgradeColor4.Value;
  LabelMonUpgradeColor4.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.SlaveColor[3]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor5Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditMonUpgradeColor5.Value;
  LabelMonUpgradeColor5.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.SlaveColor[4]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor6Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditMonUpgradeColor6.Value;
  LabelMonUpgradeColor6.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.SlaveColor[5]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor7Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditMonUpgradeColor7.Value;
  LabelMonUpgradeColor7.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.SlaveColor[6]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor8Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditMonUpgradeColor8.Value;
  LabelMonUpgradeColor8.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.SlaveColor[7]:=btColor;
  ModValue();
end;
procedure TfrmFunctionConfig.EditMonUpgradeColor9Change(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditMonUpgradeColor9.Value;
  LabelMonUpgradeColor9.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.SlaveColor[8]:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxReNewChangeColorClick(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boReNewChangeColor:=CheckBoxReNewChangeColor.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxReNewLevelClearExpClick(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boReNewLevelClearExp:=CheckBoxReNewLevelClearExp.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditPKFlagNameColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditPKFlagNameColor.Value;
  LabelPKFlagNameColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btPKFlagNameColor:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditPKLevel1NameColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditPKLevel1NameColor.Value;
  LabelPKLevel1NameColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btPKLevel1NameColor:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditPKLevel2NameColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditPKLevel2NameColor.Value;
  LabelPKLevel2NameColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btPKLevel2NameColor:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditAllyAndGuildNameColorChange(
  Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditAllyAndGuildNameColor.Value;
  LabelAllyAndGuildNameColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btAllyAndGuildNameColor:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditWarGuildNameColorChange(Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditWarGuildNameColor.Value;
  LabelWarGuildNameColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btWarGuildNameColor:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditInFreePKAreaNameColorChange(
  Sender: TObject);
var
  btColor:Byte;
begin
  btColor:=EditInFreePKAreaNameColor.Value;
  LabelInFreePKAreaNameColor.Color:=GetRGB(btColor);
  if not boOpened then exit;
  g_Config.btInFreePKAreaNameColor:=btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount1Change(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.MonUpLvNeedKillCount[0]:=EditMonUpgradeKillCount1.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount2Change(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.MonUpLvNeedKillCount[1]:=EditMonUpgradeKillCount2.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount3Change(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.MonUpLvNeedKillCount[2]:=EditMonUpgradeKillCount3.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount4Change(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.MonUpLvNeedKillCount[3]:=EditMonUpgradeKillCount4.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount5Change(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.MonUpLvNeedKillCount[4]:=EditMonUpgradeKillCount5.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount6Change(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.MonUpLvNeedKillCount[5]:=EditMonUpgradeKillCount6.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount7Change(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.MonUpLvNeedKillCount[6]:=EditMonUpgradeKillCount7.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpLvNeedKillBaseChange(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMonUpLvNeedKillBase:=EditMonUpLvNeedKillBase.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpLvRateChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMonUpLvRate:=EditMonUpLvRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxMasterDieMutinyClick(Sender: TObject);
begin
  if CheckBoxMasterDieMutiny.Checked then begin
    EditMasterDieMutinyRate.Enabled:=True;
    EditMasterDieMutinyPower.Enabled:=True;
    EditMasterDieMutinySpeed.Enabled:=True;
  end else begin
    EditMasterDieMutinyRate.Enabled:=False;
    EditMasterDieMutinyPower.Enabled:=False;
    EditMasterDieMutinySpeed.Enabled:=False;
  end;
  if not boOpened then exit;
  g_Config.boMasterDieMutiny:=CheckBoxMasterDieMutiny.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMasterDieMutinyRateChange(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMasterDieMutinyRate:=EditMasterDieMutinyRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMasterDieMutinyPowerChange(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMasterDieMutinyPower:=EditMasterDieMutinyPower.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMasterDieMutinySpeedChange(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMasterDieMutinySpeed:=EditMasterDieMutinySpeed.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxBBMonAutoChangeColorClick(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boBBMonAutoChangeColor:=CheckBoxBBMonAutoChangeColor.Checked;
  ModValue();
end;


procedure TfrmFunctionConfig.EditBBMonAutoChangeColorTimeChange(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwBBMonAutoChangeColorTime:=EditBBMonAutoChangeColorTime.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.RefSpiritMutiny();
begin
  CheckBoxSpiritMutiny.Checked:=g_Config.boSpiritMutiny;
  EditSpiritMutinyTime.Value:=g_Config.dwSpiritMutinyTime div (60 * 1000);
  EditSpiritPowerRate.Value:=g_Config.nSpiritPowerRate;
  CheckBoxSpiritMutinyClick(CheckBoxSpiritMutiny);
end;
procedure TfrmFunctionConfig.ButtonSpiritMutinySaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup','SpiritMutiny',g_Config.boSpiritMutiny);
  Config.WriteInteger('Setup','SpiritMutinyTime',g_Config.dwSpiritMutinyTime);
  Config.WriteInteger('Setup','SpiritPowerRate',g_Config.nSpiritPowerRate);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSpiritMutinyClick(Sender: TObject);
begin
  if CheckBoxSpiritMutiny.Checked then begin
    EditSpiritMutinyTime.Enabled:=True;
//    EditSpiritPowerRate.Enabled:=True;
  end else begin
    EditSpiritMutinyTime.Enabled:=False;
    EditSpiritPowerRate.Enabled:=False;
  end;
  if not boOpened then exit;
  g_Config.boSpiritMutiny:=CheckBoxSpiritMutiny.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditSpiritMutinyTimeChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.dwSpiritMutinyTime:=EditSpiritMutinyTime.Value * 60 * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.EditSpiritPowerRateChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nSpiritPowerRate:=EditSpiritPowerRate.Value;
  ModValue();
end;




procedure TfrmFunctionConfig.EditMagTammingLevelChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMagTammingLevel:=EditMagTammingLevel.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMagTammingTargetLevelChange(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMagTammingTargetLevel:=EditMagTammingTargetLevel.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMagTammingHPRateChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMagTammingHPRate:=EditMagTammingHPRate.Value;
  ModValue();
end;


procedure TfrmFunctionConfig.EditTammingCountChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMagTammingCount:=EditTammingCount.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMabMabeHitRandRateChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMabMabeHitRandRate:=EditMabMabeHitRandRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMabMabeHitMinLvLimitChange(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMabMabeHitMinLvLimit:=EditMabMabeHitMinLvLimit.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMabMabeHitSucessRateChange(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMabMabeHitSucessRate:=EditMabMabeHitSucessRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMabMabeHitMabeTimeRateChange(
  Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nMabMabeHitMabeTimeRate:=EditMabMabeHitMabeTimeRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.RefMonSayMsg;
begin
  CheckBoxMonSayMsg.Checked:=g_Config.boMonSayMsg;
end;

procedure TfrmFunctionConfig.ButtonMonSayMsgSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup','MonSayMsg',g_Config.boMonSayMsg);
{$IFEND}
  uModValue();
end;


procedure TfrmFunctionConfig.CheckBoxMonSayMsgClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boMonSayMsg:=CheckBoxMonSayMsg.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.RefWeaponMakeLuck;
begin
  ScrollBarWeaponMakeUnLuckRate.Min:=1;
  ScrollBarWeaponMakeUnLuckRate.Max:=50;
  ScrollBarWeaponMakeUnLuckRate.Position:=g_Config.nWeaponMakeUnLuckRate;

  ScrollBarWeaponMakeLuckPoint1.Min:=1;
  ScrollBarWeaponMakeLuckPoint1.Max:=10;
  ScrollBarWeaponMakeLuckPoint1.Position:=g_Config.nWeaponMakeLuckPoint1;

  ScrollBarWeaponMakeLuckPoint2.Min:=1;
  ScrollBarWeaponMakeLuckPoint2.Max:=10;
  ScrollBarWeaponMakeLuckPoint2.Position:=g_Config.nWeaponMakeLuckPoint2;

  ScrollBarWeaponMakeLuckPoint3.Min:=1;
  ScrollBarWeaponMakeLuckPoint3.Max:=10;
  ScrollBarWeaponMakeLuckPoint3.Position:=g_Config.nWeaponMakeLuckPoint3;

  ScrollBarWeaponMakeLuckPoint2Rate.Min:=1;
  ScrollBarWeaponMakeLuckPoint2Rate.Max:=50;
  ScrollBarWeaponMakeLuckPoint2Rate.Position:=g_Config.nWeaponMakeLuckPoint2Rate;

  ScrollBarWeaponMakeLuckPoint3Rate.Min:=1;
  ScrollBarWeaponMakeLuckPoint3Rate.Max:=50;
  ScrollBarWeaponMakeLuckPoint3Rate.Position:=g_Config.nWeaponMakeLuckPoint3Rate;
end;

procedure TfrmFunctionConfig.ButtonWeaponMakeLuckDefaultClick(
  Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置？', '确认信息', MB_YESNO + MB_ICONQUESTION) <> IDYES then begin
    exit;
  end;
  g_Config.nWeaponMakeUnLuckRate:=20;
  g_Config.nWeaponMakeLuckPoint1:=1;
  g_Config.nWeaponMakeLuckPoint2:=3;
  g_Config.nWeaponMakeLuckPoint3:=7;
  g_Config.nWeaponMakeLuckPoint2Rate:=6;
  g_Config.nWeaponMakeLuckPoint3Rate:=40;
  RefWeaponMakeLuck();
end;

procedure TfrmFunctionConfig.ButtonWeaponMakeLuckSaveClick(
  Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup','WeaponMakeUnLuckRate',g_Config.nWeaponMakeUnLuckRate);
  Config.WriteInteger('Setup','WeaponMakeLuckPoint1',g_Config.nWeaponMakeLuckPoint1);
  Config.WriteInteger('Setup','WeaponMakeLuckPoint2',g_Config.nWeaponMakeLuckPoint2);
  Config.WriteInteger('Setup','WeaponMakeLuckPoint3',g_Config.nWeaponMakeLuckPoint3);
  Config.WriteInteger('Setup','WeaponMakeLuckPoint2Rate',g_Config.nWeaponMakeLuckPoint2Rate);
  Config.WriteInteger('Setup','WeaponMakeLuckPoint3Rate',g_Config.nWeaponMakeLuckPoint3Rate);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeUnLuckRateChange(
  Sender: TObject);
var
  nInteger:Integer;
begin
  nInteger:=ScrollBarWeaponMakeUnLuckRate.Position;
  EditWeaponMakeUnLuckRate.Text:=IntToStr(nInteger);
  if not boOpened then exit;
  g_Config.nWeaponMakeUnLuckRate:=nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint1Change(
  Sender: TObject);
var
  nInteger:Integer;
begin
  nInteger:=ScrollBarWeaponMakeLuckPoint1.Position;
  EditWeaponMakeLuckPoint1.Text:=IntToStr(nInteger);
  if not boOpened then exit;
  g_Config.nWeaponMakeLuckPoint1:=nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint2Change(
  Sender: TObject);
var
  nInteger:Integer;
begin
  nInteger:=ScrollBarWeaponMakeLuckPoint2.Position;
  EditWeaponMakeLuckPoint2.Text:=IntToStr(nInteger);
  if not boOpened then exit;
  g_Config.nWeaponMakeLuckPoint2:=nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint2RateChange(
  Sender: TObject);
var
  nInteger:Integer;
begin
  nInteger:=ScrollBarWeaponMakeLuckPoint2Rate.Position;
  EditWeaponMakeLuckPoint2Rate.Text:=IntToStr(nInteger);
  if not boOpened then exit;
  g_Config.nWeaponMakeLuckPoint2Rate:=nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint3Change(
  Sender: TObject);
var
  nInteger:Integer;
begin
  nInteger:=ScrollBarWeaponMakeLuckPoint3.Position;
  EditWeaponMakeLuckPoint3.Text:=IntToStr(nInteger);
  if not boOpened then exit;
  g_Config.nWeaponMakeLuckPoint3:=nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint3RateChange(
  Sender: TObject);
var
  nInteger:Integer;
begin
  nInteger:=ScrollBarWeaponMakeLuckPoint3Rate.Position;
  EditWeaponMakeLuckPoint3Rate.Text:=IntToStr(nInteger);
  if not boOpened then exit;
  g_Config.nWeaponMakeLuckPoint3Rate:=nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxGroupMbAttackbaobaoClick(
  Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boGroupMbAttackBaoBao := CheckBoxGroupMbAttackbaobao.Checked;
  ModValue();
end;

end.
