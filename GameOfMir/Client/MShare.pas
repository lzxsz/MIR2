unit MShare;

interface
uses
  Windows, Classes, SysUtils, cliutil, Forms, DXDraws, DWinCtl,
  WIL, Actor, Grobal2, SDK, DXSounds, IniFiles, Share, GShare;

type
  TTimerCommand = (tcSoftClose, tcReSelConnect, tcFastQueryChr, tcQueryItemPrice);
  TChrAction = (caWalk, caRun, caHorseRun, caHit, caSpell, caSitdown);
  TConnectionStep = (cnsLogin, cnsSelChr, cnsReSelChr, cnsPlay);
  TMovingItem = record
    Index: integer;
    Item: TClientItem;
  end;
  TPowerBlock = array[0..100-1] of Word;
  pTMovingItem = ^TMovingItem;
  TItemType = (i_HPDurg,i_MPDurg,i_HPMPDurg,i_OtherDurg,i_Weapon,i_Dress,i_Helmet,i_Necklace,i_Armring,i_Ring,i_Belt,i_Boots,i_Charm,i_Book,i_PosionDurg,i_UseItem,i_Scroll,i_Stone,i_Gold,i_Other);
//  [药品] [武器][衣服][头盔][项链][手镯][戒指][腰带][鞋子][宝石][技能书][毒药][消耗品][其它]
    {
    i_HPDurg    :Result:='金创药';
    i_MPDurg    :Result:='魔法药';
    i_HPMPDurg  :Result:='高级药';
    i_OtherDurg :Result:='其它药品';
    }
  TShowItem = record
    sItemName    :String;
    ItemType     :TItemType;
    boAutoPickup :Boolean;
    boShowName   :Boolean;
    nFColor      :Integer;
    nBColor      :Integer;
  end;
  pTShowItem = ^TShowItem;
  TControlInfo = record
    Image       :Integer;
    Left        :Integer;
    Top         :Integer;
    Width       :Integer;
    Height      :Integer;
    Obj         :TDControl;
  end;
  pTControlInfo = ^TControlInfo;
  TConfig = record
    DMsgDlg       :TControlInfo;
    DMsgDlgOk     :TControlInfo;
    DMsgDlgYes    :TControlInfo;
    DMsgDlgCancel :TControlInfo;
    DMsgDlgNo     :TControlInfo;
    DLogIn        :TControlInfo;
    DLoginNew     :TControlInfo;
    DLoginOk      :TControlInfo;
    DLoginChgPw   :TControlInfo;
    DLoginClose   :TControlInfo;
    DSelServerDlg :TControlInfo;
    DSSrvClose    :TControlInfo;
    DSServer1     :TControlInfo;
    DSServer2     :TControlInfo;
    DSServer3     :TControlInfo;
    DSServer4     :TControlInfo;
    DSServer5     :TControlInfo;
    DSServer6     :TControlInfo;
    DNewAccount   :TControlInfo;
    DNewAccountOk :TControlInfo;
    DNewAccountCancel :TControlInfo;
    DNewAccountClose  :TControlInfo;
    DChgPw        :TControlInfo;
    DChgpwOk      :TControlInfo;
    DChgpwCancel  :TControlInfo;
    DSelectChr    :TControlInfo;
    DBottom       :TControlInfo;
    DMyState      :TControlInfo;
    DMyBag        :TControlInfo;
    DMyMagic      :TControlInfo;
    DOption       :TControlInfo;
    DBotMiniMap   :TControlInfo;
    DBotTrade     :TControlInfo;
    DBotGuild     :TControlInfo;
    DBotGroup     :TControlInfo;
    DBotPlusAbil  :TControlInfo;
    DBotFriend    :TControlInfo;
    DBotMemo      :TControlInfo;
    DBotExit      :TControlInfo;
    DBotLogout    :TControlInfo;
    DBelt1        :TControlInfo;
    DBelt2        :TControlInfo;
    DBelt3        :TControlInfo;
    DBelt4        :TControlInfo;
    DBelt5        :TControlInfo;
    DBelt6        :TControlInfo;
    DGold         :TControlInfo;
    DRepairItem   :TControlInfo;
    DClosebag     :TControlInfo;
    DMerchantDlg  :TControlInfo;
    DMerchantDlgClose :TControlInfo;
    DConfigDlg        :TControlInfo;
    DConfigDlgOk      :TControlInfo;
    DConfigDlgClose   :TControlInfo;
    DMenuDlg          :TControlInfo;
    DMenuPrev         :TControlInfo;
    DMenuNext         :TControlInfo;
    DMenuBuy          :TControlInfo;
    DMenuClose        :TControlInfo;
    DSellDlg          :TControlInfo;
    DSellDlgOk        :TControlInfo;
    DSellDlgClose     :TControlInfo;
    DSellDlgSpot      :TControlInfo;
    DKeySelDlg        :TControlInfo;
    DKsIcon           :TControlInfo;
    DKsF1             :TControlInfo;
    DKsF2             :TControlInfo;
    DKsF3             :TControlInfo;
    DKsF4             :TControlInfo;
    DKsF5             :TControlInfo;
    DKsF6             :TControlInfo;
    DKsF7             :TControlInfo;
    DKsF8             :TControlInfo;
    DKsConF1          :TControlInfo;
    DKsConF2          :TControlInfo;
    DKsConF3          :TControlInfo;
    DKsConF4          :TControlInfo;
    DKsConF5          :TControlInfo;
    DKsConF6          :TControlInfo;
    DKsConF7          :TControlInfo;
    DKsConF8          :TControlInfo;
    DKsNone           :TControlInfo;
    DKsOk             :TControlInfo;
    DChgGamePwd       :TControlInfo;
    DChgGamePwdClose  :TControlInfo;
    DItemGrid         :TControlInfo;
  end;

var
  g_sLogoText       :String = '⒌L';
  g_sGoldName       :String = '金币';
  g_sGameGoldName   :String = '元宝';
  g_sGamePointName  :String = '游戏点';
  g_sWarriorName    :String = '战士';    //职业名称
  g_sWizardName     :String = '魔法师';  //职业名称
  g_sTaoistName     :String = '道士';    //职业名称
  g_sUnKnowName     :String = '未知';

  g_sMainParam1     :String; //读取设置参数
  g_sMainParam2     :String; //读取设置参数
  g_sMainParam3     :String; //读取设置参数
  g_sMainParam4     :String; //读取设置参数
  g_sMainParam5     :String; //读取设置参数
  g_sMainParam6     :String; //读取设置参数

  g_DXDraw           :TDXDraw;
  g_DWinMan          :TDWinManager;
  g_DXSound          :TDXSound;
  g_Sound            :TSoundEngine;

  g_WMainImages      :TWMImages;
  g_WMain2Images     :TWMImages;
  g_WMain3Images     :TWMImages;
  g_WChrSelImages    :TWMImages;
  g_WMMapImages      :TWMImages;
  g_WTilesImages     :TWMImages;
  g_WSmTilesImages   :TWMImages;
  g_WHumWingImages   :TWMImages;
  g_WBagItemImages   :TWMImages;
  g_WStateItemImages :TWMImages;
  g_WDnItemImages    :TWMImages;
  g_WHumImgImages    :TWMImages;
  g_WHairImgImages   :TWMImages;
  g_WWeaponImages    :TWMImages;
  g_WMagIconImages   :TWMImages;
  g_WNpcImgImages    :TWMImages;
  g_WMagicImages     :TWMImages;
  g_WMagic2Images    :TWMImages;
  g_WEventEffectImages:TWMImages;
  g_WObjectArr       :array[0..14] of TWMImages;
  g_WMonImagesArr    :array[0..9999] of TWMImages;
//  g_WWeaponImages    :array of TWMImages;

  g_PowerBlock:TPowerBlock = (   //10
	$55, $8B, $EC, $83, $C4, $E8, $89, $55, $F8, $89, $45, $FC, $C7, $45, $EC, $E8,
	$03, $00, $00, $C7, $45, $E8, $64, $00, $00, $00, $DB, $45, $EC, $DB, $45, $E8,
	$DE, $F9, $DB, $45, $FC, $DE, $C9, $DD, $5D, $F0, $9B, $8B, $45, $F8, $8B, $00,
	$8B, $55, $F8, $89, $02, $DD, $45, $F0, $8B, $E5, $5D, $C3,
	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, 
	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
	$00, $00, $00, $00, $00, $00, $00, $00
   );
  g_PowerBlock1:TPowerBlock = (
	$55, $8B, $EC, $83, $C4, $E8, $89, $55, $F8, $89, $45, $FC, $C7, $45, $EC, $64,
	$00, $00, $00, $C7, $45, $E8, $64, $00, $00, $00, $DB, $45, $EC, $DB, $45, $E8,
	$DE, $F9, $DB, $45, $FC, $DE, $C9, $DD, $5D, $F0, $9B, $8B, $45, $F8, $8B, $00,
	$8B, $55, $F8, $89, $02, $DD, $45, $F0, $8B, $E5, $5D, $C3,
	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, 
	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
	$00, $00, $00, $00, $00, $00, $00, $00
   );
  g_RegInfo          :TRegInfo;
  g_nThisCRC         :Integer;
  g_sServerName      :String; //服务器显示名称
  g_sServerMiniName  :String; //服务器名称
  g_sServerAddr      :String = '127.0.0.1';
  g_nServerPort      :Integer = 7000;
  g_sSelChrAddr      :String;
  g_nSelChrPort      :Integer;
  g_sRunServerAddr   :String;
  g_nRunServerPort   :Integer;

  g_boSendLogin      :Boolean; //是否发送登录消息
  g_boServerConnected:Boolean;
  g_SoftClosed       :Boolean; //小退游戏
  g_ChrAction        :TChrAction;
  g_ConnectionStep   :TConnectionStep;

  g_boSound          :Boolean; //开启声音
  g_boBGSound        :Boolean; //开启背景音乐

  g_FontArr          :array[0..MAXFONT-1] of string = (
                     '宋体',
                     '新宋体',
                     '仿宋',
                     '楷体',
                     'Courier New',
                     'Arial',
                     'MS Sans Serif',
                     'Microsoft Sans Serif'
                     );

  g_nCurFont         :Integer = 0;
  g_sCurFontName     :String = '宋体';
  g_boFullScreen     :Boolean = True;


  g_ImgMixSurface    :TDirectDrawSurface;
  g_MiniMapSurface   :TDirectDrawSurface;

  g_boFirstTime      :Boolean;
  g_sMapTitle        :String;
  g_nMapMusic        :Integer;

  g_ServerList           :TStringList;
  g_MagicList            :TList;       //技能列表
  g_GroupMembers         :TStringList; //组成员列表
  g_SaveItemList         :TList;
  g_MenuItemList         :TList;
  g_DropedItemList       :TList;       //地面物品列表
  g_ChangeFaceReadyList  :TList;       //
  g_FreeActorList        :TList;       //释放角色列表
  g_SoundList            :TStringList; //声音列表

  g_nBonusPoint          :Integer;
  g_nSaveBonusPoint      :Integer;
  g_BonusTick            :TNakedAbility;
  g_BonusAbil            :TNakedAbility;
  g_NakedAbil            :TNakedAbility;
  g_BonusAbilChg         :TNakedAbility;

  g_sGuildName           :String;      //行会名称
  g_sGuildRankName       :String;      //职位名称

  g_dwLastAttackTick     :LongWord;    //最后攻击时间(包括物理攻击及魔法攻击)
  g_dwLastMoveTick       :LongWord;    //最后移动时间
  g_dwLatestStruckTick   :LongWord;    //最后弯腰时间
  g_dwLatestSpellTick    :LongWord;    //最后魔法攻击时间
  g_dwLatestFireHitTick  :LongWord;    //最后列火攻击时间
  g_dwLatestRushRushTick :LongWord;    //最后被推动时间
  g_dwLatestHitTick      :LongWord;    //最后物理攻击时间(用来控制攻击状态不能退出游戏)
  g_dwLatestMagicTick    :LongWord;    //最后放魔法时间(用来控制攻击状态不能退出游戏)

  g_dwMagicDelayTime     :LongWord;
  g_dwMagicPKDelayTime   :LongWord;

  g_nMouseCurrX          :Integer;    //鼠标所在地图位置座标X
  g_nMouseCurrY          :Integer;    //鼠标所在地图位置座标Y
  g_nMouseX              :Integer;    //鼠标所在屏幕位置座标X
  g_nMouseY              :Integer;    //鼠标所在屏幕位置座标Y

  g_nTargetX             :Integer;    //目标座标
  g_nTargetY             :Integer;    //目标座标
  g_TargetCret           :TActor;
  g_FocusCret            :TActor;
  g_MagicTarget          :TActor;

  g_boAttackSlow         :Boolean;   //腕力不够时慢动作攻击.
  g_boMoveSlow           :Boolean;   //负重不够时慢动作跑
  g_nMoveSlowLevel       :Integer;
  g_boMapMoving          :Boolean;   //甘 捞悼吝, 钱副锭鳖瘤 捞悼 救凳
  g_boMapMovingWait         :Boolean;
  g_boCheckBadMapMode       :Boolean;   //是否显示相关检查地图信息(用于调试)
  g_boCheckSpeedHackDisplay :Boolean;   //是否显示机器速度数据
  g_boShowGreenHint         :Boolean;
  g_boShowWhiteHint         :Boolean;
  g_boViewMiniMap           :Boolean;   //是否显示小地图
  g_nViewMinMapLv           :Integer;   //Jacky 小地图显示模式(0为不显示，1为透明显示，2为清析显示)
  g_nMiniMapIndex           :Integer;   //小地图号

  //NPC 相关
  g_nCurMerchant            :Integer;   //弥辟俊 皋春甫 焊辰 惑牢
  g_nMDlgX                  :Integer;
  g_nMDlgY                  :Integer;   //皋春甫 罐篮 镑
  g_dwChangeGroupModeTick   :LongWord;
  g_dwDealActionTick        :LongWord;
  g_dwQueryMsgTick          :LongWord;
  g_nDupSelection           :Integer;

  g_boAllowGroup            :Boolean;

  //人物信息相关
  g_nMySpeedPoint           :Integer; //敏捷
  g_nMyHitPoint             :Integer; //准确
  g_nMyAntiPoison           :Integer; //魔法躲避
  g_nMyPoisonRecover        :Integer; //中毒恢复
  g_nMyHealthRecover        :Integer; //体力恢复
  g_nMySpellRecover         :Integer; //魔法恢复
  g_nMyAntiMagic            :Integer; //魔法躲避
  g_nMyHungryState          :Integer; //饥饿状态

  g_wAvailIDDay             :Word;
  g_wAvailIDHour            :Word;
  g_wAvailIPDay             :Word;
  g_wAvailIPHour            :Word;


  g_MySelf                  :THumActor;
  g_MyDrawActor             :THumActor; //未用
  g_UseItems                :array[0..12] of TClientItem;
  g_ItemArr                 :array[0..MAXBAGITEMCL-1] of TClientItem;
  g_boBagLoaded             :Boolean;
  g_boServerChanging        :Boolean;

  //键盘相关
  g_ToolMenuHook            :HHOOK;
  g_nLastHookKey            :Integer;
  g_dwLastHookKeyTime       :LongWord;

  g_nCaptureSerial          :Integer; //抓图文件名序号
  g_nSendCount              :Integer; //发送操作计数
  g_nReceiveCount           :Integer; //接改操作状态计数
  g_nTestSendCount          :Integer;
  g_nTestReceiveCount       :Integer;
  g_nSpellCount             :Integer; //使用魔法计数
  g_nSpellFailCount         :Integer; //使用魔法失败计数
  g_nFireCount              :Integer; //
  g_nDebugCount             :Integer;
  g_nDebugCount1            :Integer;
  g_nDebugCount2            :Integer;

  //买卖相关
  g_SellDlgItem             :TClientItem;
  g_SellDlgItemSellWait     :TClientItem;
  g_DealDlgItem             :TClientItem;
  g_boQueryPrice            :Boolean;
  g_dwQueryPriceTime        :LongWord;
  g_sSellPriceStr           :String;

  //交易相关
  g_DealItems               :array[0..9] of TClientItem;
  g_DealRemoteItems         :array[0..19] of TClientItem;
  g_nDealGold               :Integer;
  g_nDealRemoteGold         :Integer;
  g_boDealEnd               :Boolean;
  g_sDealWho                :String;  //交易对方名字
  g_MouseItem               :TClientItem;
  g_MouseStateItem          :TClientItem;  //本人光标信息
  g_MouseUserStateItem      :TClientItem;  //他人光标信息

  g_boItemMoving            :Boolean;  //正在移动物品
  g_MovingItem              :TMovingItem;
  g_WaitingUseItem          :TMovingItem;
  g_FocusItem               :pTDropItem;

  g_boViewFog               :Boolean;  //是否显示黑暗
  g_boForceNotViewFog       :Boolean = False;  //免蜡烛
  g_nDayBright              :Integer;
  g_nAreaStateValue         :Integer;  //显示当前所在地图状态(攻城区域、)

  g_boNoDarkness            :Boolean;
  g_nRunReadyCount          :Integer; //助跑就绪次数，在跑前必须走几步助跑




  g_EatingItem              :TClientItem;
  g_dwEatTime               :LongWord; //timeout...


  g_dwDizzyDelayStart       :LongWord;
  g_dwDizzyDelayTime        :LongWord;

  g_boDoFadeOut             :Boolean;
  g_boDoFadeIn              :Boolean;
  g_nFadeIndex              :Integer;
  g_boDoFastFadeOut         :Boolean;




  g_boAutoDig               :Boolean;  //自动锄矿
  g_boSelectMyself          :Boolean;  //鼠标是否指到自己


  //游戏速度检测相关变量
  g_dwFirstServerTime       :LongWord;
  g_dwFirstClientTime       :LongWord;
  //ServerTimeGap: int64;
  g_nTimeFakeDetectCount    :Integer;
  g_dwSHGetTime             :LongWord;
  g_dwSHTimerTime           :LongWord;
  g_nSHFakeCount            :Integer;   //检查机器速度异常次数，如果超过4次则提示速度不稳定

  g_dwLatestClientTime2     :LongWord;
  g_dwFirstClientTimerTime  :LongWord; //timer 矫埃
  g_dwLatestClientTimerTime :LongWord;
  g_dwFirstClientGetTime    :LongWord; //gettickcount 矫埃
  g_dwLatestClientGetTime   :LongWord;
  g_nTimeFakeDetectSum      :Integer;
  g_nTimeFakeDetectTimer    :Integer;

  g_dwLastestClientGetTime  :LongWord;

//外挂功能变量开始
  g_dwDropItemFlashTime  :LongWord = 5 * 1000; //地面物品闪时间间隔
  g_nHitTime             :Integer  = 1400;  //攻击间隔时间间隔
  g_nItemSpeed           :Integer  = 60;
  g_dwSpellTime          :LongWord = 500;  //魔法攻间隔时间

  g_DeathColorEffect     :TColorEffect = ceGrayScale;
  g_boClientCanSet       :Boolean  = True;
  g_boCanRunHuman        :Boolean  = False;
  g_boCanRunMon          :Boolean  = False;
  g_boCanRunNpc          :Boolean  = False;
  g_boCanRunAllInWarZone :Boolean  = False;
  g_boCanStartRun        :Boolean  = False; //是否允许免助跑
  g_boParalyCanRun       :Boolean  = False;//麻痹是否可以跑
  g_boParalyCanWalk      :Boolean  = False;//麻痹是否可以走
  g_boParalyCanHit       :Boolean  = False;//麻痹是否可以攻击
  g_boParalyCanSpell     :Boolean  = False;//麻痹是否可以魔法

  g_boShowRedHPLable     :Boolean  = True; //显示血条     saharah
  g_boShowHPNumber       :Boolean  = True; //显示血量数字
  g_boShowJobLevel       :Boolean  = True; //显示职业等级
  g_boDuraAlert          :Boolean  = True; //物品持久警告
  g_boMagicLock          :Boolean  = False; //魔法锁定
  g_boAutoPuckUpItem     :Boolean  = False;

  g_boShowHumanInfo      :Boolean  = True;
  g_boShowMonsterInfo    :Boolean  = False;
  g_boShowNpcInfo        :Boolean  = False;
//外挂功能变量结束
  g_dwAutoPickupTick     :LongWord;
  g_dwAutoPickupTime     :LongWord = 50; //自动捡物品间隔
  g_AutoPickupList       :TList;
  g_MagicLockActor       :TActor;
  g_boNextTimePowerHit   :Boolean;
  g_boCanLongHit         :Boolean;
  g_boCanWideHit         :Boolean;
  g_boCanCrsHit          :Boolean;
  g_boCanTwnHit          :Boolean;
  g_boCanStnHit          :Boolean;
  g_boNextTimeFireHit    :Boolean;

  g_ShowItemList         :TGList;
  g_boShowAllItem        :Boolean = False;//显示地面所有物品名称

  g_boDrawTileMap        :Boolean = True;
  g_boDrawDropItem       :Boolean = True;

  g_nTestX:Integer = 71;
  g_nTestY:Integer = 212;
  DlgConf        :TConfig = (
                            DBottom     :(Image:1;Left:0;Top:0;Width:0;Height:0);
                            DMyState    :(Image:8;Left:643;Top:61;Width:0;Height:0);
                            DMyBag      :(Image:9;Left:682;Top:41;Width:0;Height:0);
                            DMyMagic    :(Image:10;Left:722;Top:21;Width:0;Height:0);
                            DOption     :(Image:11;Left:764;Top:11;Width:0;Height:0);
                            DBotMiniMap :(Image:130;Left:219;Top:104;Width:0;Height:0);
                            DBotTrade   :(Image:132;Left:219 + 30; Top:104;Width:0;Height:0);
                            DBotGuild   :(Image:134;Left:219 + 30*2; Top:104;Width:0;Height:0);
                            DBotGroup   :(Image:128;Left:219 + 30*3; Top:104;Width:0;Height:0);
                            DBotPlusAbil:(Image:140;Left:219 + 30*4; Top:104;Width:0;Height:0);
                            DBotFriend  :(Image:530;Left:219 + 30*5; Top:104;Width:0;Height:0);
                            DBotMemo    :(Image:532;
                                          Left:SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 353)){753};
                                          Top:204;
                                          Width:0;
                                          Height:0);
                            DBotExit    :(Image:138;
                                          Left:SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 160)){560};
                                          Top:104;
                                          Width:0;
                                          Height:0);
                            DBotLogout  :(Image:136;
                                          Left:SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 160)) - 30{560};//Left:560 - 30;
                                          Top:104;
                                          Width:0;
                                          Height:0);
                            DBelt1      :(Image:0;Left:285;Top:59;Width:32;Height:29);
                            DBelt2      :(Image:0;Left:328;Top:59;Width:32;Height:29);
                            DBelt3      :(Image:0;Left:371;Top:59;Width:32;Height:29);
                            DBelt4      :(Image:0;Left:415;Top:59;Width:32;Height:29);
                            DBelt5      :(Image:0;Left:459;Top:59;Width:32;Height:29);
                            DBelt6      :(Image:0;Left:503;Top:59;Width:32;Height:29);
                            DGold       :(Image:29;Left:10;Top:190;Width:0;Height:0);
                            DRepairItem :(Image:26;Left:254;Top:183;Width:48;Height:22);
                            DClosebag   :(Image:371;Left:309;Top:203;Width:14;Height:20);
                            DMerchantDlg      :(Image:384;Left:0;Top:0;Width:0;Height:0);
                            DMerchantDlgClose :(Image:64;Left:399;Top:1;Width:0;Height:0);
                            DConfigDlg        :(Image:204;Left:0;Top:0;Width:0;Height:0);
                            DConfigDlgOk      :(Image:361;Left:514;Top:287;Width:0;Height:0);
                            DConfigDlgClose   :(Image:64;Left:584;Top:6;Width:0;Height:0);
                            DMenuDlg          :(Image:385;Left:138;Top:163;Width:0;Height:0);
                            DMenuPrev         :(Image:388;Left:43;Top:175;Width:0;Height:0);
                            DMenuNext         :(Image:387;Left:90;Top:175;Width:0;Height:0);
                            DMenuBuy          :(Image:386;Left:215;Top:171;Width:0;Height:0);
                            DMenuClose        :(Image:64;Left:291;Top:0;Width:0;Height:0);
                            DSellDlg          :(Image:392;Left:328;Top:163;Width:0;Height:0);
                            DSellDlgOk        :(Image:393;Left:85;Top:150;Width:0;Height:0);
                            DSellDlgClose     :(Image:64;Left:115;Top:0;Width:0;Height:0);
                            DSellDlgSpot      :(Image:0;Left:27;Top:67;Width:0;Height:0);
                            DKeySelDlg        :(Image:620;Left:0;Top:0;Width:0;Height:0);
                            DKsIcon           :(Image:0;Left:51;Top:31;Width:0;Height:0);
                            DKsF1             :(Image:232;Left:25;Top:78;Width:0;Height:0);
                            DKsF2             :(Image:234;Left:57;Top:78;Width:0;Height:0);
                            DKsF3             :(Image:236;Left:89;Top:78;Width:0;Height:0);
                            DKsF4             :(Image:238;Left:121;Top:78;Width:0;Height:0);
                            DKsF5             :(Image:240;Left:160;Top:78;Width:0;Height:0);
                            DKsF6             :(Image:242;Left:192;Top:78;Width:0;Height:0);
                            DKsF7             :(Image:244;Left:224;Top:78;Width:0;Height:0);
                            DKsF8             :(Image:246;Left:256;Top:78;Width:0;Height:0);
                            DKsConF1          :(Image:626;Left:25;Top:120;Width:0;Height:0);
                            DKsConF2          :(Image:628;Left:57;Top:120;Width:0;Height:0);
                            DKsConF3          :(Image:630;Left:89;Top:120;Width:0;Height:0);
                            DKsConF4          :(Image:632;Left:121;Top:120;Width:0;Height:0);
                            DKsConF5          :(Image:633;Left:160;Top:120;Width:0;Height:0);
                            DKsConF6          :(Image:634;Left:192;Top:120;Width:0;Height:0);
                            DKsConF7          :(Image:638;Left:224;Top:120;Width:0;Height:0);
                            DKsConF8          :(Image:640;Left:256;Top:120;Width:0;Height:0);
                            DKsNone           :(Image:623;Left:296;Top:78;Width:0;Height:0);
                            DKsOk             :(Image:621;Left:296;Top:120;Width:0;Height:0);
                            DChgGamePwd       :(Image:621;Left:296;Top:120;Width:0;Height:0);
                            DChgGamePwdClose  :(Image:64;Left:312;Top:1;Width:0;Height:0);
                            DItemGrid         :(Image:0;Left:29;Top:41;Width:286;Height:162);
                           );
  procedure InitObj();
  procedure LoadWMImagesLib(AOwner: TComponent);
  procedure InitWMImagesLib(DDxDraw: TDxDraw);
  procedure UnLoadWMImagesLib();
  function  GetObjs (nUnit,nIdx:Integer):TDirectDrawSurface;
  function  GetObjsEx (nUnit,nIdx:Integer; var px, py: integer): TDirectDrawSurface;
  function  GetMonImg (nAppr:Integer):TWMImages;
  function  GetMonAction (nAppr:Integer):pTMonsterAction;
  function  GetJobName (nJob:Integer):String;
  procedure ClearShowItemList();
  function  GetItemType(ItemType:TItemType):String;
  function  GetShowItem(sItemName:String):pTShowItem;
  procedure LoadUserConfig(sUserName:String);
  procedure SaveUserConfig(sUserName:String);
implementation
uses FState, HUtil32;

procedure LoadWMImagesLib(AOwner: TComponent);
var
  I:Integer;
begin
  g_WMainImages        := TWMImages.Create(AOwner);
  g_WMain2Images       := TWMImages.Create(AOwner);
  g_WMain3Images       := TWMImages.Create(AOwner);
  g_WChrSelImages      := TWMImages.Create(AOwner);
  g_WMMapImages        := TWMImages.Create(AOwner);
  g_WTilesImages       := TWMImages.Create(AOwner);
  g_WSmTilesImages     := TWMImages.Create(AOwner);
  g_WHumWingImages     := TWMImages.Create(AOwner);
  g_WBagItemImages     := TWMImages.Create(AOwner);
  g_WStateItemImages   := TWMImages.Create(AOwner);
  g_WDnItemImages      := TWMImages.Create(AOwner);
  g_WHumImgImages      := TWMImages.Create(AOwner);
  g_WHairImgImages     := TWMImages.Create(AOwner);
  g_WWeaponImages      := TWMImages.Create(AOwner);
  g_WMagIconImages     := TWMImages.Create(AOwner);
  g_WNpcImgImages      := TWMImages.Create(AOwner);
  g_WMagicImages       := TWMImages.Create(AOwner);
  g_WMagic2Images      := TWMImages.Create(AOwner);
{$IF CUSTOMLIBFILE = 1}
//效果
  g_WEventEffectImages := TWMImages.Create(AOwner);
{$IFEND}
//用0填充缓冲区
  FillChar(g_WObjectArr,SizeOf(g_WObjectArr),0);
  FillChar(g_WMonImagesArr,SizeOf(g_WMonImagesArr),0);

end;
procedure InitWMImagesLib(DDxDraw: TDxDraw);
var
  sFileName:String;
  I:Integer;
begin

  g_WMainImages.DxDraw    := DDxDraw;
  g_WMainImages.DDraw     := DDxDraw.DDraw;
  g_WMainImages.FileName  := MAINIMAGEFILE;
  g_WMainImages.LibType   := ltUseCache;
  g_WMainImages.Initialize;

  g_WMain2Images.DxDraw   := DDxDraw;
  g_WMain2Images.DDraw    := DDxDraw.DDraw;
  g_WMain2Images.FileName := MAINIMAGEFILE2;
  g_WMain2Images.LibType  := ltUseCache;
  g_WMain2Images.Initialize;

  g_WMain3Images.DxDraw   := DDxDraw;
  g_WMain3Images.DDraw    := DDxDraw.DDraw;
  g_WMain3Images.FileName := MAINIMAGEFILE3;
  g_WMain3Images.LibType  := ltUseCache;
  g_WMain3Images.Initialize;



  g_WChrSelImages.DxDraw   := DDxDraw;
  g_WChrSelImages.DDraw    := DDxDraw.DDraw;
  g_WChrSelImages.FileName := CHRSELIMAGEFILE;
  g_WChrSelImages.LibType  := ltUseCache;
  g_WChrSelImages.Initialize;

  g_WMMapImages.DxDraw     := DDxDraw;
  g_WMMapImages.DDraw      := DDxDraw.DDraw;
  g_WMMapImages.FileName   := MINMAPIMAGEFILE;
  g_WMMapImages.LibType    := ltUseCache;
  g_WMMapImages.Initialize;

  g_WTilesImages.DxDraw    := DDxDraw;
  g_WTilesImages.DDraw     := DDxDraw.DDraw;
  g_WTilesImages.FileName  := TITLESIMAGEFILE;
  g_WTilesImages.LibType   := ltUseCache;
  g_WTilesImages.Initialize;

  g_WSmTilesImages.DxDraw   := DDxDraw;
  g_WSmTilesImages.DDraw    := DDxDraw.DDraw;
  g_WSmTilesImages.FileName := SMLTITLESIMAGEFILE;
  g_WSmTilesImages.LibType  := ltUseCache;
  g_WSmTilesImages.Initialize;

  g_WHumWingImages.DxDraw   := DDxDraw;
  g_WHumWingImages.DDraw    := DDxDraw.DDraw;
  g_WHumWingImages.FileName := HUMWINGIMAGESFILE;
  g_WHumWingImages.LibType  := ltUseCache;
  g_WHumWingImages.Initialize;

  g_WBagItemImages.DxDraw   := DDxDraw;
  g_WBagItemImages.DDraw    := DDxDraw.DDraw;
  g_WBagItemImages.FileName := BAGITEMIMAGESFILE;
  g_WBagItemImages.LibType  := ltUseCache;
  g_WBagItemImages.Initialize;

  g_WStateItemImages.DxDraw   := DDxDraw;
  g_WStateItemImages.DDraw    := DDxDraw.DDraw;
  g_WStateItemImages.FileName := STATEITEMIMAGESFILE;
  g_WStateItemImages.LibType  := ltUseCache;
  g_WStateItemImages.Initialize;

  g_WDnItemImages.DxDraw:=DDxDraw;
  g_WDnItemImages.DDraw:=DDxDraw.DDraw;
  g_WDnItemImages.FileName:=DNITEMIMAGESFILE;
  g_WDnItemImages.LibType:=ltUseCache;
  g_WDnItemImages.Initialize;

  g_WHumImgImages.DxDraw:=DDxDraw;
  g_WHumImgImages.DDraw:=DDxDraw.DDraw;
  g_WHumImgImages.FileName:=HUMIMGIMAGESFILE;
  g_WHumImgImages.LibType:=ltUseCache;
  g_WHumImgImages.Initialize;

  g_WHairImgImages.DxDraw:=DDxDraw;
  g_WHairImgImages.DDraw:=DDxDraw.DDraw;
  g_WHairImgImages.FileName:=HAIRIMGIMAGESFILE;
  g_WHairImgImages.LibType:=ltUseCache;
  g_WHairImgImages.Initialize;

  g_WWeaponImages.DxDraw:=DDxDraw;
  g_WWeaponImages.DDraw:=DDxDraw.DDraw;
  g_WWeaponImages.FileName:=WEAPONIMAGESFILE;
  g_WWeaponImages.LibType:=ltUseCache;
  g_WWeaponImages.Initialize;

  g_WMagIconImages.DxDraw:=DDxDraw;
  g_WMagIconImages.DDraw:=DDxDraw.DDraw;
  g_WMagIconImages.FileName:=MAGICONIMAGESFILE;
  g_WMagIconImages.LibType:=ltUseCache;
  g_WMagIconImages.Initialize;

  g_WNpcImgImages.DxDraw:=DDxDraw;
  g_WNpcImgImages.DDraw:=DDxDraw.DDraw;
  g_WNpcImgImages.FileName:=NPCIMAGESFILE;
  g_WNpcImgImages.LibType:=ltUseCache;
  g_WNpcImgImages.Initialize;

  g_WMagicImages.DxDraw:=DDxDraw;
  g_WMagicImages.DDraw:=DDxDraw.DDraw;
  g_WMagicImages.FileName:=MAGICIMAGESFILE;
  g_WMagicImages.LibType:=ltUseCache;
  g_WMagicImages.Initialize;

  g_WMagic2Images.DxDraw:=DDxDraw;
  g_WMagic2Images.DDraw:=DDxDraw.DDraw;
  g_WMagic2Images.FileName:=MAGIC2IMAGESFILE;
  g_WMagic2Images.LibType:=ltUseCache;
  g_WMagic2Images.Initialize;
{$IF CUSTOMLIBFILE = 1}
  g_WEventEffectImages.DxDraw:=DDxDraw;
  g_WEventEffectImages.DDraw:=DDxDraw.DDraw;
  g_WEventEffectImages.FileName:=EVENTEFFECTIMAGESFILE;
  g_WEventEffectImages.LibType:=ltUseCache;
  g_WEventEffectImages.Initialize;
{$IFEND}


end;
procedure UnLoadWMImagesLib();
var
  I:Integer;
begin
  for I := Low(g_WObjectArr) to High(g_WObjectArr) do begin
    if g_WObjectArr[I] <> nil then begin
      g_WObjectArr[I].Finalize;
      g_WObjectArr[I].Free;
    end;
  end;
  for I := Low(g_WMonImagesArr) to High(g_WMonImagesArr) do begin
    if g_WMonImagesArr[I] <> nil then begin
      g_WMonImagesArr[I].Finalize;
      g_WMonImagesArr[I].Free;
    end;
  end;

  g_WMainImages.Finalize;
  g_WMainImages.Free;

  g_WMain2Images.Finalize;
  g_WMain2Images.Free;

  g_WMain3Images.Finalize;
  g_WMain3Images.Free;
  
  g_WChrSelImages.Finalize;
  g_WChrSelImages.Free;

  g_WMMapImages.Finalize;
  g_WMMapImages.Free;

  g_WTilesImages.Finalize;
  g_WTilesImages.Free;

  g_WSmTilesImages.Finalize;
  g_WSmTilesImages.Free;

  g_WHumWingImages.Finalize;
  g_WHumWingImages.Free;

  g_WBagItemImages.Finalize;
  g_WBagItemImages.Free;

  g_WStateItemImages.Finalize;
  g_WStateItemImages.Free;

  g_WDnItemImages.Finalize;
  g_WDnItemImages.Free;

  g_WHumImgImages.Finalize;
  g_WHumImgImages.Free;

  g_WHairImgImages.Finalize;
  g_WHairImgImages.Free;

  g_WWeaponImages.Finalize;
  g_WWeaponImages.Free;

  g_WMagIconImages.Finalize;
  g_WMagIconImages.Free;

  g_WNpcImgImages.Finalize;
  g_WNpcImgImages.Free;

  g_WMagicImages.Finalize;
  g_WMagicImages.Free;

  g_WMagic2Images.Finalize;;
  g_WMagic2Images.Free;
{$IF CUSTOMLIBFILE = 1}
  g_WEventEffectImages.Finalize;
  g_WEventEffectImages.Free;
{$IFEND}  
end;
//取地图图库
function GetObjs (nUnit,nIdx:Integer):TDirectDrawSurface;
var
  sFileName:String;
begin
  Result:=nil;
  if not (nUnit in [Low(g_WObjectArr) .. High(g_WObjectArr)]) then nUnit:=0;
  if g_WObjectArr[nUnit] = nil then begin
    if nUnit = 0 then sFileName:=OBJECTIMAGEFILE
    else sFileName:=format(OBJECTIMAGEFILE1,[nUnit+1]);
    if not FileExists(sFileName) then exit;
    g_WObjectArr[nUnit]:=TWMImages.Create(nil);
    g_WObjectArr[nUnit].DxDraw:=g_DxDraw;
    g_WObjectArr[nUnit].DDraw:=g_DxDraw.DDraw;
    g_WObjectArr[nUnit].FileName:=sFileName;
    g_WObjectArr[nUnit].LibType:=ltUseCache;
    g_WObjectArr[nUnit].Initialize;
  end;
  Result:=g_WObjectArr[nUnit].Images[nIdx];
end;
//取地图图库
function  GetObjsEx (nUnit,nIdx:Integer; var px, py: integer): TDirectDrawSurface;
var
  sFileName:String;
begin
  Result:=nil;
  if not (nUnit in [Low(g_WObjectArr) .. High(g_WObjectArr)]) then nUnit:=0;
  if g_WObjectArr[nUnit] = nil then begin

    if nUnit = 0 then sFileName:=OBJECTIMAGEFILE
    else sFileName:=format(OBJECTIMAGEFILE1,[nUnit+1]);

    if not FileExists(sFileName) then exit;
    g_WObjectArr[nUnit]:=TWMImages.Create(nil);
    g_WObjectArr[nUnit].DxDraw:=g_DxDraw;
    g_WObjectArr[nUnit].DDraw:=g_DxDraw.DDraw;
    g_WObjectArr[nUnit].FileName:=sFileName;
    g_WObjectArr[nUnit].LibType:=ltUseCache;
    g_WObjectArr[nUnit].Initialize;
  end;
  Result:=g_WObjectArr[nUnit].GetCachedImage(nIdx,px,py);
end;
function GetMonImg (nAppr:Integer):TWMImages;
var
  sFileName:String;
  nUnit:Integer;
begin
  Result:=nil;
  if nAppr < 1000 then nUnit:=nAppr div 10
  else nUnit:=nAppr;
  
  if (nUnit < Low(g_WMonImagesArr)) or (nUnit > High(g_WMonImagesArr)) then nUnit:=0;
  if g_WMonImagesArr[nUnit] = nil then begin

    sFileName:=format(MONIMAGEFILE,[nUnit+1]);
    if nUnit = 80 then sFileName:=DRAGONIMAGEFILE;
    if nUnit = 90 then sFileName:=EFFECTIMAGEFILE;
    if nUnit >= 1000 then sFileName:=format(MONIMAGEFILEEX,[nUnit]); //超过1000序号的怪物取新的怪物文件
                                  
    g_WMonImagesArr[nUnit]:=TWMImages.Create(nil);
    g_WMonImagesArr[nUnit].DxDraw:=g_DxDraw;
    g_WMonImagesArr[nUnit].DDraw:=g_DxDraw.DDraw;
    g_WMonImagesArr[nUnit].FileName:=sFileName;
    g_WMonImagesArr[nUnit].LibType:=ltUseCache;
    g_WMonImagesArr[nUnit].Initialize;
  end;
  Result:=g_WMonImagesArr[nUnit];
end;
function  GetMonAction (nAppr:Integer):pTMonsterAction;
var
  FileStream:TFileStream;
  sFileName:String;
  MonsterAction:TMonsterAction;
begin
  Result:=nil;
  sFileName:=format(MONPMFILE,[nAppr]);
  if FileExists (sFileName) then begin
    FileStream:=TFileStream.Create(sFileName,fmOpenRead or fmShareDenyNone);
    FileStream.Read (MonsterAction, SizeOf(MonsterAction));
    New(Result);
    Result^:=MonsterAction;
    FileStream.Free;
  end;
end;

//取得职业名称
//0 武士
//1 魔法师
//2 道士
function  GetJobName (nJob:Integer):String;
begin
  Result:= '';
  case nJob of
    0:Result:=g_sWarriorName;
    1:Result:=g_sWizardName;
    2:Result:=g_sTaoistName;
    else begin
      Result:=g_sUnKnowName;
    end;
  end;
end;
function GetItemType(ItemType:TItemType):String;
begin
  case ItemType of    //
    i_HPDurg    :Result:='金创药';
    i_MPDurg    :Result:='魔法药';
    i_HPMPDurg  :Result:='高级药';
    i_OtherDurg :Result:='其它药品';
    i_Weapon  :Result:='武器';
    i_Dress   :Result:='衣服';
    i_Helmet  :Result:='头盔';
    i_Necklace:Result:='项链';
    i_Armring :Result:='手镯';
    i_Ring    :Result:='戒指';
    i_Belt    :Result:='腰带';
    i_Boots   :Result:='鞋子';
    i_Charm   :Result:='宝石';
    i_Book    :Result:='技能书';
    i_PosionDurg :Result:='毒药';
    i_UseItem :Result:='消耗品';
    i_Scroll  :Result:='卷类';
    i_Stone   :Result:='矿石';
    i_Gold    :Result:='金币';
    i_Other   :Result:='其它';
  end;    // case    [药品] [武器][衣服][头盔][项链][手镯][戒指][消耗品][其它]
//  [药品] [武器][衣服][头盔][项链][手镯][戒指][腰带][鞋子][宝石][毒药][消耗品][其它]
end;
function GetShowItem(sItemName:String):pTShowItem;
var
  I:Integer;
begin
  Result:=nil;
  g_ShowItemList.Lock;
  try
    for I := 0 to g_ShowItemList.Count - 1 do begin
      if CompareText(pTShowItem(g_ShowItemList.Items[I]).sItemName,sItemName) = 0 then begin
        Result:=g_ShowItemList.Items[I];
        break;
      end;
    end;
  finally
    g_ShowItemList.UnLock;
  end;
end;
procedure ClearShowItemList();
var
  ShowItem:pTShowItem;
  I:Integer;
begin
  g_ShowItemList.Lock;
  try
    for I := 0 to g_ShowItemList.Count - 1 do begin
      ShowItem:=g_ShowItemList.Items[I];
      Dispose(ShowItem);
    end;
    g_ShowItemList.Clear;
  finally
    g_ShowItemList.UnLock;
  end;
end;
procedure SaveUserConfig(sUserName:String);
var
  ShowItem:pTShowItem;
  Ini:TIniFile;
  sFileName:String;
  I:Integer;
  sItemName,sLineText:String;
  sType,sPickup,sShow,sFColor,sBColor:String;
begin
  if sUserName <> '' then sFileName := format(CONFIGFILE,[sUserName])
  else sFileName:=format(CONFIGFILE,['Config']);
  Ini:=TIniFile.Create(sFileName);
  g_ShowItemList.Lock;
  try
    for I := 0 to g_ShowItemList.Count - 1 do begin
      ShowItem:=g_ShowItemList.Items[I];
      sType:=IntToStr(Integer(ShowItem.ItemType));
      if ShowItem.boAutoPickup then sPickup:='1'
      else sPickup:='0';
      if ShowItem.boShowName then sShow:='1'
      else sShow:='0';
      Ini.WriteString('Items',ShowItem.sItemName,format('%s,%s,%s,%d,%d',[sType,sPickup,sShow,ShowItem.nFColor,ShowItem.nBColor]));
    end;
  finally
    g_ShowItemList.UnLock;
  end;
  Ini.Free;
end;
procedure LoadUserConfig(sUserName:String);
var
  ShowItem:pTShowItem;
  Ini:TIniFile;
  sFileName:String;
  Strings: TStringList;
  I:Integer;
  sItemName,sLineText:String;
  sType,sPickup,sShow,sFColor,sBColor:String;
begin
  sFileName:=format(CONFIGFILE,[sUserName]);
  if not FileExists(sFileName) then begin
    sFileName:=format(CONFIGFILE,['Config']);
  end;
  if FileExists(sFileName) then begin
    Ini:=TIniFile.Create(sFileName);
    Strings:=TStringList.Create;
    g_ShowItemList.Lock;
    try
      Ini.ReadSection('Items',Strings);
      for I := 0 to Strings.Count - 1 do begin
        sItemName:=Strings.Strings[I];
        if sItemName = '' then Continue;
        sLineText:=Ini.ReadString('Items',sItemName,'');
        sLineText:=GetValidStr3(sLineText,sType,[',']);
        sLineText:=GetValidStr3(sLineText,sPickup,[',']);
        sLineText:=GetValidStr3(sLineText,sShow,[',']);
        sLineText:=GetValidStr3(sLineText,sFColor,[',']);
        sLineText:=GetValidStr3(sLineText,sBColor,[',']);
        if (sType <> '') and (sPickup <> '') and (sShow <> '') and (sFColor <> '') and (sBColor <> '') then begin
          New(ShowItem);
          ShowItem.sItemName:=sItemName;
          ShowItem.ItemType:=TItemType(Str_ToInt(sType,0));
          ShowItem.boAutoPickup:= sPickup = '1';
          ShowItem.boShowName:= sShow = '1';
          ShowItem.nFColor:=Str_ToInt(sFColor,0);
          ShowItem.nBColor:=Str_ToInt(sBColor,0);
          g_ShowItemList.Add(ShowItem);
        end;
      end;
    finally
      g_ShowItemList.UnLock;
    end;
    Strings.Free;
    Ini.Free;
    exit;
  end;

end;
procedure InitObj();
begin
  DlgConf.DMsgDlg.Obj       :=FrmDlg.DMsgDlg;
  DlgConf.DMsgDlgOk.Obj     :=FrmDlg.DMsgDlgOk;
  DlgConf.DMsgDlgYes.Obj    :=FrmDlg.DMsgDlgYes;
  DlgConf.DMsgDlgCancel.Obj :=FrmDlg.DMsgDlgCancel;
  DlgConf.DMsgDlgNo.Obj     :=FrmDlg.DMsgDlgNo;
  DlgConf.DLogIn.Obj        :=FrmDlg.DLogIn;
  DlgConf.DLoginNew.Obj     :=FrmDlg.DLoginNew;
  DlgConf.DLoginOk.Obj      :=FrmDlg.DLoginOk;
  DlgConf.DLoginChgPw.Obj   :=FrmDlg.DLoginChgPw;
  DlgConf.DLoginClose.Obj   :=FrmDlg.DLoginClose;
  DlgConf.DSelServerDlg.Obj :=FrmDlg.DSelServerDlg;
  DlgConf.DSSrvClose.Obj    :=FrmDlg.DSSrvClose;
  DlgConf.DSServer1.Obj     :=FrmDlg.DSServer1;
  DlgConf.DSServer2.Obj     :=FrmDlg.DSServer2;
  DlgConf.DSServer3.Obj     :=FrmDlg.DSServer3;
  DlgConf.DSServer4.Obj     :=FrmDlg.DSServer4;
  DlgConf.DSServer5.Obj     :=FrmDlg.DSServer5;
  DlgConf.DSServer6.Obj     :=FrmDlg.DSServer6;
  DlgConf.DNewAccount.Obj   :=FrmDlg.DNewAccount;
  DlgConf.DNewAccountOk.Obj :=FrmDlg.DNewAccountOk;
  DlgConf.DNewAccountCancel.Obj :=FrmDlg.DNewAccountCancel;
  DlgConf.DNewAccountClose.Obj  :=FrmDlg.DNewAccountClose;
  DlgConf.DChgPw.Obj        :=FrmDlg.DChgPw;
  DlgConf.DChgpwOk.Obj      :=FrmDlg.DChgpwOk;
  DlgConf.DChgpwCancel.Obj  :=FrmDlg.DChgpwCancel;
  DlgConf.DSelectChr.Obj    :=FrmDlg.DSelectChr;
  DlgConf.DBottom.Obj       :=FrmDlg.DBottom;
  DlgConf.DMyState.Obj      :=FrmDlg.DMyState;
  DlgConf.DMyBag.Obj        :=FrmDlg.DMyBag;
  DlgConf.DMyMagic.Obj      :=FrmDlg.DMyMagic;
  DlgConf.DOption.Obj       :=FrmDlg.DOption;
  DlgConf.DBotMiniMap.Obj   :=FrmDlg.DBotMiniMap;
  DlgConf.DBotTrade.Obj     :=FrmDlg.DBotTrade;
  DlgConf.DBotGuild.Obj    :=FrmDlg.DBotGuild;
  DlgConf.DBotGroup.Obj     :=FrmDlg.DBotGroup;
  DlgConf.DBotPlusAbil.Obj  :=FrmDlg.DBotPlusAbil;
  DlgConf.DBotFriend.Obj    :=FrmDlg.DBotFriend;
  DlgConf.DBotMemo.Obj      :=FrmDlg.DBotMemo;
  DlgConf.DBotExit.Obj      :=FrmDlg.DBotExit;
  DlgConf.DBotLogout.Obj    :=FrmDlg.DBotLogout;
  DlgConf.DBelt1.Obj        :=FrmDlg.DBelt1;
  DlgConf.DBelt2.Obj        :=FrmDlg.DBelt2;
  DlgConf.DBelt3.Obj        :=FrmDlg.DBelt3;
  DlgConf.DBelt4.Obj        :=FrmDlg.DBelt4;
  DlgConf.DBelt5.Obj        :=FrmDlg.DBelt5;
  DlgConf.DBelt6.Obj        :=FrmDlg.DBelt6;
  DlgConf.DGold.Obj         :=FrmDlg.DGold;
  DlgConf.DRepairItem.Obj   :=FrmDlg.DRepairItem;
  DlgConf.DClosebag.Obj     :=FrmDlg.DClosebag;
  DlgConf.DMerchantDlg.Obj  :=FrmDlg.DMerchantDlg;
  DlgConf.DMerchantDlgClose.Obj :=FrmDlg.DMerchantDlgClose;
  DlgConf.DConfigDlg.Obj        :=FrmDlg.DConfigDlg;
  DlgConf.DConfigDlgOk.Obj      :=FrmDlg.DConfigDlgOk;
  DlgConf.DConfigDlgClose.Obj   :=FrmDlg.DConfigDlgClose;
  DlgConf.DMenuDlg.Obj         :=FrmDlg.DMenuDlg;
  DlgConf.DMenuPrev.Obj         :=FrmDlg.DMenuPrev;
  DlgConf.DMenuNext.Obj         :=FrmDlg.DMenuNext;
  DlgConf.DMenuBuy.Obj          :=FrmDlg.DMenuBuy;
  DlgConf.DMenuClose.Obj        :=FrmDlg.DMenuClose;
  DlgConf.DSellDlg.Obj          :=FrmDlg.DSellDlg;
  DlgConf.DSellDlgOk.Obj        :=FrmDlg.DSellDlgOk;
  DlgConf.DSellDlgClose.Obj     :=FrmDlg.DSellDlgClose;
  DlgConf.DSellDlgSpot.Obj      :=FrmDlg.DSellDlgSpot;
  DlgConf.DKeySelDlg.Obj        :=FrmDlg.DKeySelDlg;
  DlgConf.DKsIcon.Obj           :=FrmDlg.DKsIcon;
  DlgConf.DKsF1.Obj             :=FrmDlg.DKsF1;
  DlgConf.DKsF2.Obj             :=FrmDlg.DKsF2;
  DlgConf.DKsF3.Obj             :=FrmDlg.DKsF3;
  DlgConf.DKsF4.Obj             :=FrmDlg.DKsF4;
  DlgConf.DKsF5.Obj             :=FrmDlg.DKsF5;
  DlgConf.DKsF6.Obj             :=FrmDlg.DKsF6;
  DlgConf.DKsF7.Obj             :=FrmDlg.DKsF7;
  DlgConf.DKsF8.Obj             :=FrmDlg.DKsF8;
  DlgConf.DKsConF1.Obj          :=FrmDlg.DKsConF1;
  DlgConf.DKsConF2.Obj          :=FrmDlg.DKsConF2;
  DlgConf.DKsConF3.Obj          :=FrmDlg.DKsConF3;
  DlgConf.DKsConF4.Obj          :=FrmDlg.DKsConF4;
  DlgConf.DKsConF5.Obj          :=FrmDlg.DKsConF5;
  DlgConf.DKsConF6.Obj          :=FrmDlg.DKsConF6;
  DlgConf.DKsConF7.Obj          :=FrmDlg.DKsConF7;
  DlgConf.DKsConF8.Obj          :=FrmDlg.DKsConF8;
  DlgConf.DKsNone.Obj           :=FrmDlg.DKsNone;
  DlgConf.DKsOk.Obj             :=FrmDlg.DKsOk;
  DlgConf.DItemGrid.Obj         :=FrmDlg.DItemGrid;
end;
initialization
begin
end;
end.
