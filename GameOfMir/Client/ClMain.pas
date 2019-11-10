unit ClMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  JSocket, ExtCtrls, DXDraws, DirectX, DXClass, DrawScrn,
  IntroScn, PlayScn, MapUnit, WIL, Grobal2, SDK,
  Actor, DIB, StdCtrls, CliUtil, HUtil32, EdCode,
  DWinCtl, ClFunc, magiceff, SoundUtil, DXSounds, clEvent, Wave, IniFiles,
  Spin, ComCtrls, Grids, Mpeg, Menus, Mask, MShare, Share;

const
   BO_FOR_TEST = FALSE;
   EnglishVersion = True; //TRUE;
   BoNeedPatch = TRUE;

   NEARESTPALETTEINDEXFILE = 'Data\npal.idx';

   MonImageDir = '.\Graphics\Monster\';
   NpcImageDir = '.\Graphics\Npc\';
   ItemImageDir = '.\Graphics\Items\';
   WeaponImageDir = '.\Graphics\Weapon\';
   HumImageDir = '.\Graphics\Human\';

type
  TKornetWorld = record
    CPIPcode:  string;
    SVCcode:   string;
    LoginID:   string;
    CheckSum:  string;
  end;

  TOneClickMode = (toNone, toKornetWorld);



  TfrmMain = class(TDxForm)
    CSocket: TClientSocket;
    Timer1: TTimer;
    MouseTimer: TTimer;
    WaitMsgTimer: TTimer;
    SelChrWaitTimer: TTimer;
    CmdTimer: TTimer;
    MinTimer: TTimer;
    SpeedHackTimer: TTimer;
    DXDraw: TDXDraw;
    WMonImg: TWMImages;
    WMon2Img: TWMImages;
    WMon3Img: TWMImages;
    WMon4Img: TWMImages;
    WMon5Img: TWMImages;
    WMon6Img: TWMImages;
    WMon7Img: TWMImages;
    WMon8Img: TWMImages;
    WMon9Img: TWMImages;
    WMon10Img: TWMImages;
    WMon11Img: TWMImages;
    WMon12Img: TWMImages;
    WMon13Img: TWMImages;
    WMon14Img: TWMImages;
    WMon15Img: TWMImages;
    WMon16Img: TWMImages;
    WMon17Img: TWMImages;
    WMon18Img: TWMImages;
    WMon19Img: TWMImages;
    WMon20Img: TWMImages;
    WMon21Img: TWMImages;
    WMon22Img: TWMImages;
    WMon23Img: TWMImages;
    WMon24Img: TWMImages;
    WMon25Img: TWMImages;
    WMon26Img: TWMImages;
    WMon27Img: TWMImages;
    WMon28Img: TWMImages;
    WEffectImg: TWMImages;
    WDragonImg: TWMImages;
    


    procedure DXDrawInitialize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DXDrawFinalize(Sender: TObject);
    procedure CSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer1Timer(Sender: TObject);
    procedure DXDrawMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DXDrawDblClick(Sender: TObject);
    procedure WaitMsgTimerTimer(Sender: TObject);
    procedure SelChrWaitTimerTimer(Sender: TObject);
    procedure DXDrawClick(Sender: TObject);
    procedure CmdTimerTimer(Sender: TObject);
    procedure MinTimerTimer(Sender: TObject);
    procedure CheckHackTimerTimer(Sender: TObject);
    procedure SendTimeTimerTimer(Sender: TObject);
    procedure SpeedHackTimerTimer(Sender: TObject);

  private
    SocStr, BufferStr: string;
    WarningLevel: Integer;
    TimerCmd: TTimerCommand;
    MakeNewId: string;

    ActionLockTime: LongWord;
    LastHitTick: LongWord;
    ActionFailLock: Boolean;
    ActionFailLockTime:LongWord;
    FailAction, FailDir: integer;
    ActionKey: word;

    CursorSurface: TDirectDrawSurface;
    mousedowntime: longword;
    WaitingMsg: TDefaultMessage;
    WaitingStr: string;
    WhisperName: string;

    procedure AutoPickUpItem();
    procedure ProcessKeyMessages;
    procedure ProcessActionMessages;
    procedure CheckSpeedHack (rtime: Longword);
    procedure DecodeMessagePacket (datablock: string);
    procedure ActionFailed;
    function  GetMagicByKey (Key: char): PTClientMagic;
    procedure UseMagic (tx, ty: integer; pcm: PTClientMagic);
    procedure UseMagicSpell (who, effnum, targetx, targety, magic_id: integer);
    procedure UseMagicFire (who, efftype, effnum, targetx, targety, target: integer);
    procedure UseMagicFireFail (who: integer);
    procedure CloseAllWindows;
    procedure ClearDropItems;
    procedure ResetGameVariables;
    procedure ChangeServerClearGameVariables;
    procedure _DXDrawMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AttackTarget (target: TActor);

    function  CheckDoorAction (dx, dy: integer): Boolean;
    procedure ClientGetPasswdSuccess (body: string);
    procedure ClientGetNeedUpdateAccount (body: string);
    procedure ClientGetSelectServer;
    procedure ClientGetPasswordOK(Msg:TDefaultMessage;sBody:String);
    procedure ClientGetReceiveChrs (body: string);
    procedure ClientGetStartPlay (body: string);
    procedure ClientGetReconnect (body: string);
    procedure ClientGetServerConfig(Msg:TDefaultMessage;sBody:String);
    procedure ClientGetMapDescription (Msg:TDefaultMessage;sBody:String);
    procedure ClientGetGameGoldName (Msg:TDefaultMessage;sBody:String);

    procedure ClientGetAdjustBonus (bonus: integer; body: string);
    procedure ClientGetAddItem (body: string);
    procedure ClientGetUpdateItem (body: string);
    procedure ClientGetDelItem (body: string);
    procedure ClientGetDelItems (body: string);
    procedure ClientGetBagItmes (body: string);
    procedure ClientGetDropItemFail (iname: string; sindex: integer);
    procedure ClientGetShowItem (itemid, x, y, looks: integer; itmname: string);
    procedure ClientGetHideItem (itemid, x, y: integer);
    procedure ClientGetSenduseItems (body: string);
    procedure ClientGetSendAddUseItems (body: string);
    procedure ClientGetAddMagic (body: string);
    procedure ClientGetDelMagic (magid: integer);
    procedure ClientGetMyMagics (body: string);
    procedure ClientGetMagicLvExp (magid, maglv, magtrain: integer);
    procedure ClientGetDuraChange (uidx, newdura, newduramax: integer);
    procedure ClientGetMerchantSay (merchant, face: integer; saying: string);
    procedure ClientGetSendGoodsList (merchant, count: integer; body: string);
    procedure ClientGetSendMakeDrugList (merchant: integer; body: string);
    procedure ClientGetSendUserSell (merchant: integer);
    procedure ClientGetSendUserRepair (merchant: integer);
    procedure ClientGetSendUserStorage (merchant: integer);
    procedure ClientGetSaveItemList (merchant: integer; bodystr: string);
    procedure ClientGetSendDetailGoodsList (merchant, count, topline: integer; bodystr: string);
    procedure ClientGetSendNotice (body: string);
    procedure ClientGetGroupMembers (bodystr: string);
    procedure ClientGetOpenGuildDlg (bodystr: string);
    procedure ClientGetSendGuildMemberList (body: string);
    procedure ClientGetDealRemoteAddItem (body: string);
    procedure ClientGetDealRemoteDelItem (body: string);
    procedure ClientGetReadMiniMap (mapindex: integer);
    procedure ClientGetChangeGuildName (body: string);
    procedure ClientGetSendUserState (body: string);
    procedure DrawEffectHum(nType,nX,nY:Integer);
    procedure ClientGetNeedPassword(Body:String);
    procedure ClientGetPasswordStatus(Msg:pTDefaultMessage;Body:String);
    procedure ClientGetRegInfo(Msg:pTDefaultMessage;Body:String);

    procedure SetInputStatus();
    procedure CmdShowHumanMsg(sParam1, sParam2, sParam3, sParam4,
      sParam5: String);
    procedure ShowHumanMsg(Msg: pTDefaultMessage);
    procedure SendPowerBlock;

  public
    LoginId, LoginPasswd, CharName: string;
    Certification: integer;
    ActionLock: Boolean;
    //MainSurface: TDirectDrawSurface;
    NpcImageList:TList;
    ItemImageList:TList;
    WeaponImageList:TList;
    HumImageList:TList;

    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure ProcOnIdle;
    procedure AppOnIdle (Sender: TObject; var Done: Boolean);
    procedure AppLogout;
    procedure AppExit;
    procedure PrintScreenNow;
    procedure EatItem (idx: integer);

    procedure SendClientMessage (msg, Recog, param, tag, series: integer);
    procedure SendLogin (uid, passwd: string);
    procedure SendNewAccount (ue: TUserEntry; ua: TUserEntryAdd);
    procedure SendUpdateAccount (ue: TUserEntry; ua: TUserEntryAdd);
    procedure SendSelectServer (svname: string);
    procedure SendChgPw (id, passwd, newpasswd: string);
    procedure SendNewChr (uid, uname, shair, sjob, ssex: string);
    procedure SendQueryChr;
    procedure SendDelChr (chrname: string);
    procedure SendSelChr (chrname: string);
    procedure SendRunLogin;
    procedure SendSay (str: string);
    procedure SendActMsg (ident, x, y, dir: integer);
    procedure SendSpellMsg (ident, x, y, dir, target: integer);
    procedure SendQueryUserName (targetid, x, y: integer);
    procedure SendDropItem (name: string; itemserverindex: integer);
    procedure SendPickup;
    procedure SendTakeOnItem (where: byte; itmindex: integer; itmname: string);
    procedure SendTakeOffItem (where: byte; itmindex: integer; itmname: string);
    procedure SendEat (itmindex: integer; itmname: string);
    procedure SendButchAnimal (x, y, dir, actorid: integer);
    procedure SendMagicKeyChange (magid: integer; keych: char);
    procedure SendMerchantDlgSelect (merchant: integer; rstr: string);
    procedure SendQueryPrice (merchant, itemindex: integer; itemname: string);
    procedure SendQueryRepairCost (merchant, itemindex: integer; itemname: string);
    procedure SendSellItem (merchant, itemindex: integer; itemname: string);
    procedure SendRepairItem (merchant, itemindex: integer; itemname: string);
    procedure SendStorageItem (merchant, itemindex: integer; itemname: string);
    procedure SendGetDetailItem (merchant, menuindex: integer; itemname: string);
    procedure SendBuyItem (merchant, itemserverindex: integer; itemname: string);
    procedure SendTakeBackStorageItem (merchant, itemserverindex: integer; itemname: string);
    procedure SendMakeDrugItem (merchant: integer; itemname: string);
    procedure SendDropGold (dropgold: integer);
    procedure SendGroupMode (onoff: Boolean);
    procedure SendCreateGroup (withwho: string);
    procedure SendWantMiniMap;
    procedure SendDealTry; //菊俊 荤恩捞 乐绰瘤 八荤
    procedure SendGuildDlg;
    procedure SendCancelDeal;
    procedure SendAddDealItem (ci: TClientItem);
    procedure SendDelDealItem (ci: TClientItem);
    procedure SendChangeDealGold (gold: integer);
    procedure SendDealEnd;
    procedure SendAddGroupMember (withwho: string);
    procedure SendDelGroupMember (withwho: string);
    procedure SendGuildHome;
    procedure SendGuildMemberList;
    procedure SendGuildAddMem (who: string);
    procedure SendGuildDelMem (who: string);
    procedure SendGuildUpdateNotice (notices: string);
    procedure SendGuildUpdateGrade (rankinfo: string);
    procedure SendSpeedHackUser;  //SpeedHaker 荤侩磊甫 辑滚俊 烹焊茄促.
    procedure SendAdjustBonus (remain: integer; babil: TNakedAbility);
    procedure SendPassword(sPassword:String;nIdent:Integer);
    
    function  TargetInSwordLongAttackRange (ndir: integer): Boolean;
    function  TargetInSwordWideAttackRange (ndir: integer): Boolean;
    function  TargetInSwordCrsAttackRange(ndir: integer): Boolean;
    procedure OnProgramException (Sender: TObject; E: Exception);
    procedure SendSocket (sendstr: string);
    function  ServerAcceptNextAction: Boolean;
    function  CanNextAction: Boolean;
    function  CanNextHit: Boolean;
    function  IsUnLockAction (action, adir: integer): Boolean;
    procedure ActiveCmdTimer (cmd: TTimerCommand);
    function  IsGroupMember (uname: string): Boolean;
    procedure SelectChr(sChrName:String);

    function  GetNpcImg(wAppr: Word; var WMImage: TWMImages): Boolean;
    function  GetWStateImg(Idx:Integer): TDirectDrawSurface;overload;
    function  GetWStateImg(Idx:Integer;var ax,ay:integer): TDirectDrawSurface;overload;
    function  GetWWeaponImg(Weapon,m_btSex,nFrame:Integer;var ax,ay:integer): TDirectDrawSurface;
    function  GetWHumImg(Dress,m_btSex,nFrame:Integer;var ax,ay:integer): TDirectDrawSurface;
    procedure ProcessCommand(sData:String);
  end;
  function IsDebug():Boolean;
  function IsDebugA():Boolean;
  function  CheckMirProgram: Boolean;
  procedure PomiTextOut (dsurface: TDirectDrawSurface; x, y: integer; str: string);
  procedure WaitAndPass (msec: longword);
  function  GetRGB (c256: byte): integer;
  procedure DebugOutStr (msg: string);

var
  nLeft            :integer = 10;
  nTop             :integer = 10;
  nWidth           :integer;
  nHeight          :integer;
  g_boShowMemoLog  :Boolean = False;
  g_boShowRecog    :Integer = 0;
  frmMain          :TfrmMain;
  DScreen          :TDrawScreen;
  IntroScene       :TIntroScene;
  LoginScene       :TLoginScene;
  SelectChrScene   :TSelectChrScene;
  PlayScene        :TPlayScene;
  LoginNoticeScene :TLoginNotice;

  LocalLanguage    :TImeMode = imChinese;
  
  MP3              :TMPEG;
  TestServerAddr   :String = '127.0.0.1';
  BGMusicList      :TStringList;
  //DObjList: TList;  //官蹿俊 函版等 瘤屈狼 钎泅
  EventMan         :TClEventManager;
  KornetWorld      :TKornetWorld;
  Map              :TMap;
  BoOneClick       :Boolean;
  OneClickMode     :TOneClickMode;
  m_boPasswordIntputStatus:Boolean = False;
  
implementation

uses
  FState, DlgConfig, gShare;

{$R *.DFM}
var
  ShowMsgActor:TActor;


function  CheckMirProgram: Boolean;
var
   pstr, cstr: array[0..255] of char;
   mirapphandle: HWnd;
begin
   Result := FALSE;
   StrPCopy (pstr, 'legend of mir');
   mirapphandle := FindWindow (nil, pstr);
   if (mirapphandle <> 0) and (mirapphandle <> Application.Handle) then begin
{$IFNDEF COMPILE}
      SetActiveWindow(mirapphandle);
      Result := TRUE;
{$ENDIF}
      exit;
   end;
end;

procedure PomiTextOut (dsurface: TDirectDrawSurface; x, y: integer; str: string);
var
   i, n: integer;
   d: TDirectDrawSurface;
begin
   for i:=1 to Length(str) do begin
      n := byte(str[i]) - byte('0');
      if n in [0..9] then begin //箭磊父 凳
         d := g_WMainImages.Images[30 + n];
         if d <> nil then
            dsurface.Draw (x + i*8, y, d.ClientRect, d, TRUE);
      end else begin
         if str[i] = '-' then begin
            d := g_WMainImages.Images[40];
            if d <> nil then
               dsurface.Draw (x + i*8, y, d.ClientRect, d, TRUE);
         end;
      end;
   end;
end;

procedure WaitAndPass (msec: longword);
var
   start: longword;
begin
   start := GetTickCount;
   while GetTickCount - start < msec do begin
      Application.ProcessMessages;
   end;
end;

function  GetRGB (c256: byte): integer;
begin
  with frmMain.DxDraw do
    Result:=RGB(DefColorTable[c256].rgbRed,
                DefColorTable[c256].rgbGreen,
                DefColorTable[c256].rgbBlue);
end;

procedure DebugOutStr (msg: string);
var
   flname: string;
   fhandle: TextFile;
begin
//DScreen.AddChatBoardString(msg,clWhite, clBlack);
   exit;
   flname := '.\!debug.txt';
   if FileExists(flname) then begin
      AssignFile (fhandle, flname);
      Append (fhandle);
   end else begin
      AssignFile (fhandle, flname);
      Rewrite (fhandle);
   end;
   WriteLn (fhandle, TimeToStr(Time) + ' ' + msg);
   CloseFile (fhandle);
end;

function KeyboardHookProc (Code: Integer; WParam: Longint; var Msg: TMsg): Longint; stdcall;
begin
   Result:=0;//jacky
   if ((WParam = 9){ or (WParam = 13)}) and (g_nLastHookKey = 18) and (GetTickCount - g_dwLastHookKeyTime < 500) then begin
      if FrmMain.WindowState <> wsMinimized then begin
         FrmMain.WindowState := wsMinimized;
      end else
         Result := CallNextHookEx(g_ToolMenuHook, Code, WParam, Longint(@Msg));
      exit;
   end;
   g_nLastHookKey := WParam;
   g_dwLastHookKeyTime := GetTickCount;

   Result := CallNextHookEx(g_ToolMenuHook, Code, WParam, Longint(@Msg));
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  flname, str: string;
  ini: TIniFile;
  FtpConf:TIniFile;
begin
  ini := nil;
  FtpConf := nil;


  g_AutoPickupList :=TList.Create;
  g_ShowItemList   :=TGList.Create;

  g_DWinMan:=TDWinManager.Create(Self);
  //DelphiX
  g_DXDraw:=DXDraw;
  //初始化随机种子
   Randomize;
   //读取mir.ini配置文件
   ini := TIniFile.Create ('.\Lmir.ini');
   if ini <> nil then begin
      if EnglishVersion then begin
         g_sServerAddr := ini.ReadString ('Setup', 'ServerAddr', g_sServerAddr);
         g_nServerPort := ini.ReadInteger ('Setup', 'ServerPort', g_nServerPort);
         LocalLanguage := imOpen;
      end;

      g_boFullScreen := ini.ReadBool ('Setup', 'FullScreen', g_boFullScreen);
      g_sCurFontName := ini.ReadString ('Setup', 'FontName', g_sCurFontName);
      g_sMainParam1:=Ini.ReadString('Setup', 'Param1', '');
      g_sMainParam2:=Ini.ReadString('Setup', 'Param2', '');
      ini.Free;
   end;
   FtpConf:=TIniFile.Create('.\Lmir.ini');

{$IF CLIENTTYPE = RMCLIENT} //检查如果客户端的标识不正确,则控制权限
    g_sLogoText:=RMCLIENTTITLE;
{$ELSE}
   if FtpConf <> nil then begin
     g_sLogoText:=FtpConf.ReadString('Server','Server1Caption',g_sLogoText);
     FtpConf.Free;
   end;
{$IFEND}
   //窗体标题
   Caption:=g_sLogoText;
   //全屏
   if g_boFullScreen then
     DXDraw.Options:=DXDraw.Options + [doFullScreen];

   LoadWMImagesLib(nil);
   NpcImageList:=TList.Create;
   ItemImageList:=TList.Create;
   WeaponImageList:=TList.Create;
   HumImageList:=TList.Create;
   //Delphi声音
   g_DXSound:=TDXSound.Create(Self);
   //初始化
   g_DXSound.Initialize;

   //设置Delphi的分辨率
   DXDraw.Display.Width:=SCREENWIDTH;
   DXDraw.Display.Height:=SCREENHEIGHT;
   //判断g_DXSound是否已經初始化完成
  if g_DXSound.Initialized then begin
  //聲音精靈
    g_Sound:= TSoundEngine.Create (g_DXSound.DSound);
  //TMPEG
    MP3:=TMPEG.Create(nil);
  end else begin
  //g_dxSound初始化失敗則置空
    g_Sound:= nil;
    MP3:=nil;
  end;
  //Hook  KeyBoard
   g_ToolMenuHook := SetWindowsHookEx(WH_KEYBOARD, @KeyboardHookProc, 0, GetCurrentThreadID);
   //Sound播放列表
   g_SoundList := TStringList.Create;
   //BGMusic播放列表
   BGMusicList:=TStringList.Create;

   flname := '.\wav\sound.lst';
   //读取声音文件
   LoadSoundList (flname);
   flname := '.\wav\sound.lst';
   LoadBGMusicList(flname);
   //if FileExists (flname) then
   //   SoundList.LoadFromFile (flname);
   //绘制屏幕
   DScreen := TDrawScreen.Create;
   //音乐场景
   IntroScene := TIntroScene.Create;
   //登录场景
   LoginScene := TLoginScene.Create;
   //
   SelectChrScene := TSelectChrScene.Create;
   //玩场景
   PlayScene := TPlayScene.Create;
   //登录布告
   LoginNoticeScene := TLoginNotice.Create;
   //地图
   Map              := TMap.Create;
   g_DropedItemList := TList.Create;
   g_MagicList        := TList.Create;
   g_FreeActorList    := TList.Create;
   //DObjList := TList.Create;
   //事件管理器
   EventMan := TClEventManager.Create;
   //更改
   g_ChangeFaceReadyList := TList.Create;
   //服务器列表
   g_ServerList:=TStringList.Create;
   g_MySelf := nil;
   //填充g_UseItems  使用项目
   FillChar (g_UseItems, sizeof(TClientItem)*13, #0);
//   FillChar (UseItems, sizeof(TClientItem)*9, #0);
   //
   FillChar (g_ItemArr, sizeof(TClientItem)*MAXBAGITEMCL, #0);
   FillChar (g_DealItems, sizeof(TClientItem)*10, #0);
   FillChar (g_DealRemoteItems, sizeof(TClientItem)*20, #0);

   g_SaveItemList := TList.Create;
   g_MenuItemList := TList.Create;
   g_WaitingUseItem.Item.S.Name := '';  //馒侩芒 辑滚客 烹脚埃俊 烙矫历厘
   g_EatingItem.S.Name := '';

   g_nTargetX := -1;
   g_nTargetY := -1;
   g_TargetCret := nil;
   g_FocusCret := nil;
   g_FocusItem := nil;
   g_MagicTarget := nil;
   g_nDebugCount := 0;
   g_nDebugCount1 := 0;
   g_nDebugCount2 := 0;
   g_nTestSendCount := 0;
   g_nTestReceiveCount := 0;
   g_boServerChanging := FALSE;
   g_boBagLoaded := FALSE;
   g_boAutoDig := FALSE;

   g_dwLatestClientTime2 := 0;
   g_dwFirstClientTime := 0;
   g_dwFirstServerTime := 0;
   g_dwFirstClientTimerTime := 0;
   g_dwLatestClientTimerTime := 0;
   g_dwFirstClientGetTime := 0;
   g_dwLatestClientGetTime := 0;

   g_nTimeFakeDetectCount := 0;
   g_nTimeFakeDetectTimer := 0;
   g_nTimeFakeDetectSum := 0;

   g_dwSHGetTime := 0;
   g_dwSHTimerTime := 0;
   g_nSHFakeCount := 0;


   g_nDayBright := 3; //广
   g_nAreaStateValue := 0;
   g_ConnectionStep := cnsLogin;
   g_boSendLogin:=False;
   g_boServerConnected := FALSE;
   SocStr := '';
   WarningLevel := 0;  //阂樊菩哦 荐脚 冉荐 (菩哦汗荤 啊瓷己 乐澜)
   ActionFailLock := FALSE;
   g_boMapMoving := FALSE;
   g_boMapMovingWait := FALSE;
   g_boCheckBadMapMode := FALSE;
   g_boCheckSpeedHackDisplay := FALSE;
   g_boViewMiniMap := FALSE;
   g_boShowGreenHint := FALSE;
   g_boShowWhiteHint := FALSE;
   FailDir := 0;
   FailAction := 0;
   g_nDupSelection := 0;


   g_dwLastAttackTick := GetTickCount;
   g_dwLastMoveTick := GetTickCount;
   g_dwLatestSpellTick := GetTickCount;

   g_dwAutoPickupTick := GetTickCount;
   g_boFirstTime := TRUE;
   g_boItemMoving := FALSE;
   g_boDoFadeIn := FALSE;
   g_boDoFadeOut := FALSE;
   g_boDoFastFadeOut := FALSE;
   g_boAttackSlow := FALSE;
   g_boMoveSlow := FALSE;
   g_boNextTimePowerHit := FALSE;
   g_boCanLongHit := FALSE;
   g_boCanWideHit := FALSE;
   g_boCanCrsHit   := False;
   g_boCanTwnHit   := False;

   g_boNextTimeFireHit := FALSE;

   g_boNoDarkness := FALSE;  //是否使用黑暗?
   g_SoftClosed := FALSE;
   g_boQueryPrice := FALSE;
   g_sSellPriceStr := '';

   g_boAllowGroup := FALSE;
   g_GroupMembers := TStringList.Create;
   //得到DxDraw句柄
   MainWinHandle := DxDraw.Handle;

   //盔努腐, 内齿岿靛 殿..
   BoOneClick := False;
   OneClickMode := toNone;

   g_boSound:=True;
   g_boBGSound:=True;

   if g_sMainParam1 = '' then begin
   //Socket连接地址和端口
     CSocket.Address:=g_sServerAddr;
     CSocket.Port:=g_nServerPort;
   end else begin
      if (g_sMainParam1 <> '') and (g_sMainParam2 = '') then
         CSocket.Address := g_sMainParam1;
      if (g_sMainParam2 <> '') and (g_sMainParam3 = '') then begin
         CSocket.Address := g_sMainParam1;
         CSocket.Port := Str_ToInt (g_sMainParam2, 0);
      end;
      if (g_sMainParam3 <> '') then begin
         if CompareText (g_sMainParam1, '/KWG') = 0 then begin
            {
            CSocket.Address := kornetworldaddress;  //game.megapass.net';
            CSocket.Port := 9000;
            BoOneClick := TRUE;
            OneClickMode := toKornetWorld;
            with KornetWorld do begin
               CPIPcode := MainParam2;
               SVCcode  := MainParam3;
               LoginID  := MainParam4;
               CheckSum := MainParam5; //'dkskxhdkslxlkdkdsaaaasa';
            end;
            }
         end else begin
            CSocket.Address := g_sMainParam2;
            CSocket.Port := Str_ToInt (g_sMainParam3, 0);
            BoOneClick := TRUE;
         end;
      end;
   end;
   if BO_FOR_TEST then
      CSocket.Address := TestServerAddr;
   //-----------Socket开始连接
   CSocket.Active:=True;

   //MainSurface := nil;
   //保存调试信息
   DebugOutStr ('----------------------- started ------------------------');
   //异常时调用的函数
   Application.OnException := OnProgramException;
   //当空闲时调用的函数
   Application.OnIdle := AppOnIdle;

end;

procedure TfrmMain.OnProgramException (Sender: TObject; E: Exception);
begin
   DebugOutStr (E.Message);
end;

procedure TfrmMain.WMSysCommand(var Message: TWMSysCommand);
begin
{   with Message do begin
      if (CmdType and $FFF0) = SC_KEYMENU then begin
         if (Key = VK_TAB) or (Key = VK_RETURN) then begin
            FrmMain.WindowState := wsMinimized;
         end else
            inherited;
      end else
         inherited;
   end;
}
   inherited;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  ClearShowItemList();
  g_ShowItemList.Free;
  g_ShowItemList:=nil;
  g_AutoPickupList.Free;
  g_AutoPickupList:=nil;
   if g_ToolMenuHook <> 0 then UnhookWindowsHookEx(g_ToolMenuHook);
   //SoundCloseProc;
   //DXTimer.Enabled := FALSE;
   Timer1.Enabled := FALSE;
   MinTimer.Enabled := FALSE;

   UnLoadWMImagesLib();
//   WTiles.Finalize;
   {
   WObjects1.Finalize;
   WObjects2.Finalize;
   WObjects3.Finalize;
   WObjects4.Finalize;
   WObjects5.Finalize;
   WObjects6.Finalize;
   WObjects7.Finalize;
   WObjects8.Finalize;
   WObjects9.Finalize;
   WObjects10.Finalize;
   }
//   WHumWing.Finalize;
   WDragonImg.Finalize;
//   WSmTiles.Finalize;
//   WHumImg.Finalize;
//   WHairImg.Finalize;
//   WWeapon.Finalize;
//   WMagic.Finalize;
//   WMagic2.Finalize;
//   WMagIcon.Finalize;
   WMonImg.Finalize;
   WMon2Img.Finalize;
   WMon3Img.Finalize;
   WMon4Img.Finalize;
   WMon5Img.Finalize;
   WMon6Img.Finalize;
   WMon7Img.Finalize;
   WMon8Img.Finalize;
   WMon9Img.Finalize;
   WMon10Img.Finalize;
   WMon11Img.Finalize;
   WMon12Img.Finalize;
   WMon13Img.Finalize;
   WMon14Img.Finalize;
   WMon15Img.Finalize;
   WMon16Img.Finalize;
   WMon17Img.Finalize;
   WMon18Img.Finalize;
   WMon19Img.Finalize;
   WMon20Img.Finalize;
   WMon21Img.Finalize;
   WMon22Img.Finalize;
   WMon23Img.Finalize;
   WMon24Img.Finalize;
   WMon25Img.Finalize;
   WMon26Img.Finalize;
   WMon27Img.Finalize;
   WMon28Img.Finalize;

      
//   WNpcImg.Finalize;
   WEffectImg.Finalize;
//   WChrSel.Finalize;
//   WMMap.Finalize;
//   WBagItem.Finalize;
//   WStateItem.Finalize;
//   WDnItem.Finalize;

   for I := 0 to NpcImageList.Count - 1 do begin
     TWMImages(NpcImageList.Items[I]).Finalize;
   end;
   for I := 0 to ItemImageList.Count - 1 do begin
     TWMImages(ItemImageList.Items[I]).Finalize;
   end;
   for I := 0 to WeaponImageList.Count - 1 do begin
     TWMImages(WeaponImageList.Items[I]).Finalize;
   end;
   for I := 0 to HumImageList.Count - 1 do begin
     TWMImages(HumImageList.Items[I]).Finalize;
   end;

   DScreen.Finalize;
   PlayScene.Finalize;
   LoginNoticeScene.Finalize;

   DScreen.Free;
   IntroScene.Free;
   LoginScene.Free;
   SelectChrScene.Free;
   PlayScene.Free;
   LoginNoticeScene.Free;
   g_SaveItemList.Free;
   g_MenuItemList.Free;

   DebugOutStr ('----------------------- closed -------------------------');
   Map.Free;
   g_DropedItemList.Free;
   g_MagicList.Free;
   g_FreeActorList.Free;
   g_ChangeFaceReadyList.Free;

   g_ServerList.Free;
   //if MainSurface <> nil then MainSurface.Free;

   g_Sound.Free;
   g_SoundList.Free;
   BGMusicList.Free;
   //DObjList.Free;
   EventMan.Free;
   NpcImageList.Free;
   ItemImageList.Free;
   WeaponImageList.Free;
   HumImageList.Free;

   g_DXSound.Free;
   g_DWinMan.Free;
end;

function ComposeColor(Dest, Src: TRGBQuad; Percent: Integer): TRGBQuad;
begin
  with Result do
  begin
    rgbRed := Src.rgbRed+((Dest.rgbRed-Src.rgbRed)*Percent div 256);
    rgbGreen := Src.rgbGreen+((Dest.rgbGreen-Src.rgbGreen)*Percent div 256);
    rgbBlue := Src.rgbBlue+((Dest.rgbBlue-Src.rgbBlue)*Percent div 256);
    rgbReserved := 0;
  end;
end;

procedure TfrmMain.DXDrawInitialize(Sender: TObject);
begin

   if g_boFirstTime then begin
      g_boFirstTime := FALSE;

      DxDraw.SurfaceWidth := SCREENWIDTH;
      DxDraw.SurfaceHeight := SCREENHEIGHT;

{$IF USECURSOR = DEFAULTCURSOR}
      DxDraw.Cursor:=crHourGlass;
{$ELSE}
      DxDraw.Cursor:=crNone;
{$IFEND}
      
      DxDraw.Surface.Canvas.Font.Assign (FrmMain.Font);

      FrmMain.Font.Name := g_sCurFontName;
      FrmMain.Canvas.Font.Name := g_sCurFontName;
      DxDraw.Surface.Canvas.Font.Name := g_sCurFontName;
      PlayScene.EdChat.Font.Name := g_sCurFontName;

      //MainSurface := TDirectDrawSurface.Create (frmMain.DxDraw.DDraw);
      //MainSurface.SystemMemory := TRUE;
      //MainSurface.SetSize (SCREENWIDTH, SCREENHEIGHT);

      InitWMImagesLib(DxDraw);
      
//      WTiles.DDraw := DxDraw.DDraw;
      {
      WObjects1.DDraw := DxDraw.DDraw;
      WObjects2.DDraw := DxDraw.DDraw;
      WObjects3.DDraw := DxDraw.DDraw;
      WObjects4.DDraw := DxDraw.DDraw;
      WObjects5.DDraw := DxDraw.DDraw;
      WObjects6.DDraw := DxDraw.DDraw;
      WObjects7.DDraw := DxDraw.DDraw;
      WObjects8.DDraw := DxDraw.DDraw;
      WObjects9.DDraw := DxDraw.DDraw;
      WObjects10.DDraw := DxDraw.DDraw;
      }
//      WHumWing.DDraw := DxDraw.DDraw;
      WDragonImg.DDraw := DxDraw.DDraw;
//      WSmTiles.DDraw := DxDraw.DDraw;
//      WChrSel.DDraw := DxDraw.DDraw;
//      WMMap.DDraw := DxDraw.DDraw;
//      WBagItem.DDraw := DxDraw.DDraw;
//      WStateItem.DDraw := DxDraw.DDraw;
//      WDnItem.DDraw := DxDraw.DDraw;
//      WHumImg.DDraw := DxDraw.DDraw;
//      WHairImg.DDraw := DxDraw.DDraw;
//      WWeapon.DDraw := DxDraw.DDraw;
//      WMagic.DDraw := DxDraw.DDraw;
//      WMagic2.DDraw := DxDraw.DDraw;
//      WMagIcon.DDraw := DxDraw.DDraw;
      WMonImg.DDraw := DxDraw.DDraw;
      WMon2Img.DDraw := DxDraw.DDraw;
      WMon3Img.DDraw := DxDraw.DDraw;
      WMon4Img.DDraw := DxDraw.DDraw;
      WMon5Img.DDraw := DxDraw.DDraw;
      WMon6Img.DDraw := DxDraw.DDraw;
      WMon7Img.DDraw := DxDraw.DDraw;
      WMon8Img.DDraw := DxDraw.DDraw;
      WMon9Img.DDraw := DxDraw.DDraw;
      WMon10Img.DDraw := DxDraw.DDraw;
      WMon11Img.DDraw := DxDraw.DDraw;
      WMon12Img.DDraw := DxDraw.DDraw;
      WMon13Img.DDraw := DxDraw.DDraw;
      WMon14Img.DDraw := DxDraw.DDraw;
      WMon15Img.DDraw := DxDraw.DDraw;
      WMon16Img.DDraw := DxDraw.DDraw;
      WMon17Img.DDraw := DxDraw.DDraw;
      WMon18Img.DDraw := DxDraw.DDraw;
      WMon19Img.DDraw := DxDraw.DDraw;
      WMon20Img.DDraw := DxDraw.DDraw;
      WMon21Img.DDraw := DxDraw.DDraw;
      WMon22Img.DDraw := DxDraw.DDraw;
      WMon23Img.DDraw := DxDraw.DDraw;
      WMon24Img.DDraw := DxDraw.DDraw;
      WMon25Img.DDraw := DxDraw.DDraw;
      WMon26Img.DDraw := DxDraw.DDraw;
      WMon27Img.DDraw := DxDraw.DDraw;
      WMon28Img.DDraw := DxDraw.DDraw;
//      WNpcImg.DDraw := DxDraw.DDraw;
      WEffectImg.DDraw := DxDraw.DDraw;
//      WTiles.Initialize;
      {
      WObjects1.Initialize;
      WObjects2.Initialize;
      WObjects3.Initialize;
      WObjects4.Initialize;
      WObjects5.Initialize;
      WObjects6.Initialize;
      WObjects7.Initialize;
      WObjects8.Initialize;
      WObjects9.Initialize;
      WObjects10.Initialize;
      }
//      WHumWing.Initialize;
      WDragonImg.Initialize;
//      WSmTiles.Initialize;
//      WChrSel.Initialize;
//      WMMap.Initialize;
//      WBagItem.Initialize;
//      WStateItem.Initialize;
//      WDnItem.Initialize;
//      WHumImg.Initialize;
//      WHairImg.Initialize;
//      WWeapon.Initialize;
//      WMagic.Initialize;
//      WMagic2.Initialize;
//      WMagIcon.Initialize;
      WMonImg.Initialize;
      WMon2Img.Initialize;
      WMon3Img.Initialize;
      WMon4Img.Initialize;
      WMon5Img.Initialize;
      WMon6Img.Initialize;
      WMon7Img.Initialize;
      WMon8Img.Initialize;
      WMon9Img.Initialize;
      WMon10Img.Initialize;
      WMon11Img.Initialize;
      WMon12Img.Initialize;
      WMon13Img.Initialize;
      WMon14Img.Initialize;
      WMon15Img.Initialize;
      WMon16Img.Initialize;
      WMon17Img.Initialize;
      WMon18Img.Initialize;
      WMon19Img.Initialize;
      WMon20Img.Initialize;
      WMon21Img.Initialize;
      WMon22Img.Initialize;
      WMon23Img.Initialize;
      WMon24Img.Initialize;
      WMon25Img.Initialize;
      WMon26Img.Initialize;
      WMon27Img.Initialize;
      WMon28Img.Initialize;
//      WNpcImg.Initialize;
      WEffectImg.Initialize;

      DxDraw.DefColorTable := g_WMainImages.MainPalette;
      DxDraw.ColorTable := DxDraw.DefColorTable;
      DxDraw.UpdatePalette;

      //256 Blend utility
      if not LoadNearestIndex (NEARESTPALETTEINDEXFILE) then begin
         BuildNearestIndex (DxDraw.ColorTable);
         SaveNearestIndex (NEARESTPALETTEINDEXFILE);
      end;
      BuildColorLevels (DxDraw.ColorTable);

      DScreen.Initialize;
      PlayScene.Initialize;
      FrmDlg.Initialize;



      if doFullScreen in DxDraw.Options then begin
         //Screen.Cursor := crNone;
      end else begin
         Left := 0;
         Top := 0;
         Width := SCREENWIDTH;
         Height := SCREENHEIGHT;
         g_boNoDarkness := TRUE;
         g_boUseDIBSurface := TRUE;
         //frmMain.BorderStyle := bsSingle;
      end;

      g_ImgMixSurface := TDirectDrawSurface.Create (frmMain.DxDraw.DDraw);
      g_ImgMixSurface.SystemMemory := TRUE;
      g_ImgMixSurface.SetSize (300, 350);
      g_MiniMapSurface := TDirectDrawSurface.Create (frmMain.DxDraw.DDraw);
      g_MiniMapSurface.SystemMemory := TRUE;
      g_MiniMapSurface.SetSize (540, 360);
      //DxDraw.Surface.SystemMemory := TRUE;
   end;

end;

procedure TfrmMain.DXDrawFinalize(Sender: TObject);
begin
   //DXTimer.Enabled := FALSE;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   //Savebags ('.\Data\' + ServerName + '.' + CharName + '.itm', @ItemArr);
   //DxTimer.Enabled := FALSE;
end;


{------------------------------------------------------------}

procedure TfrmMain.ProcOnIdle;
var
   done: Boolean;
begin
   AppOnIdle (self, done);
   //DXTimerTimer (self, 0);
end;

procedure TfrmMain.AppOnIdle (Sender: TObject; var Done: Boolean);
//procedure TFrmMain.DXTimerTimer(Sender: TObject; LagCount: Integer);
var
   i, j: integer;
   p: TPoint;
   DF: DDBLTFX;
   d: TDirectDrawSurface;
   nC:integer;
begin
   Done := TRUE;
   if not DxDraw.CanDraw then exit;

  // DxDraw.Surface.Fill(0);
  // BoldTextOut (DxDraw.Surface, 0, 0, clBlack, clBlack, 'test test ' + TimeToStr(Time));
  // DxDraw.Surface.Canvas.Release;

   ProcessKeyMessages;
   ProcessActionMessages;
   DScreen.DrawScreen (DxDraw.Surface);
   g_DWinMan.DirectPaint (DxDraw.Surface);
   DScreen.DrawScreenTop (DxDraw.Surface);
   DScreen.DrawHint (DxDraw.Surface);
   
{$IF USECURSOR = IMAGECURSOR}
   {Draw cursor}
   //=========================================
   //显示光标
   CursorSurface := g_WMainImages.Images[0];
   if CursorSurface <> nil then begin
      GetCursorPos (p);
      DxDraw.Surface.Draw (p.x, p.y, CursorSurface.ClientRect, CursorSurface, TRUE);
   end;
   //==========================
{$IFEND}

   if g_boItemMoving then begin
      if (g_MovingItem.Item.S.Name <> g_sGoldName{'金币'}) then
         d := g_WBagItemImages.Images[g_MovingItem.Item.S.Looks]
      else d := g_WBagItemImages.Images[115]; //金币外形
      if d <> nil then begin
         GetCursorPos (p);
         DxDraw.Surface.Draw (p.x-(d.ClientRect.Right div 2),
                              p.y-(d.ClientRect.Bottom div 2),
                              d.ClientRect,
                              d,
                              TRUE);
        //显示物品的ID号
        if (g_MovingItem.Item.S.Name <> g_sGoldName{'金币'}) then
          with DxDraw.Surface.Canvas do begin
            SetBkMode (Handle, TRANSPARENT);
            Font.Color := clYellow;
            TextOut (p.X + 9, p.Y + 3,g_MovingItem.Item.S.Name);
            Release;
          end;
      end;
   end;
   if g_boDoFadeOut then begin
      if g_nFadeIndex < 1 then g_nFadeIndex := 1;
      MakeDark (DxDraw.Surface, g_nFadeIndex);
      if g_nFadeIndex <= 1 then g_boDoFadeOut := FALSE
      else Dec (g_nFadeIndex, 2);
   end else
   if g_boDoFadeIn then begin
      if g_nFadeIndex > 29 then g_nFadeIndex := 29;
      MakeDark (DxDraw.Surface, g_nFadeIndex);
      if g_nFadeIndex >= 29 then g_boDoFadeIn := FALSE
      else Inc (g_nFadeIndex, 2);
   end else
   if g_boDoFastFadeOut then begin
      if g_nFadeIndex < 1 then g_nFadeIndex := 1;
      MakeDark (DxDraw.Surface, g_nFadeIndex);
      if g_nFadeIndex > 1 then Dec (g_nFadeIndex, 4);
   end;
   {
   for i:=0 to 15 do
      for j:=0 to 15 do begin
         DxDraw.Surface.FillRect(Rect (j*16, i*16, (j+1)*16, (i+1)*16), i*16 + j);
      end;

   for i:=0 to 15 do
      DxDraw.Surface.Canvas.TextOut (600, i*14,
                                    IntToStr(i) + ' ' +
                                    IntToStr(DxDraw.ColorTable[i].rgbRed) + ' ' +
                                    IntToStr(DxDraw.ColorTable[i].rgbGreen) + ' ' +
                                    IntToStr(DxDraw.ColorTable[i].rgbBlue));
   DxDraw.Surface.Canvas.Release;}

   //DxDraw.Flip;
   //登录的时候显示圆形LOGO
   if g_ConnectionStep = cnsLogin then begin
     with DxDraw.Surface.Canvas do begin
       Brush.Color:=clNavy;
       nC:=64;
       RoundRect(SCREENWIDTH - nC,0,SCREENWIDTH,nC,nC,nC);
      // RoundRect(800 - nC,0,SCREENWIDTH,nC,nC,nC);
       Font.Color := clBlack;
       SetBkMode (Handle, TRANSPARENT);
       TextOut ((SCREENWIDTH - nC) + ((nC - TextWidth(g_sLogoText)) div 2), (nC - TextHeight('W')) div 2,g_sLogoText);
      // TextOut ((800 - nC) + ((nC - TextWidth(sLogoText)) div 2), (nC - TextHeight('W')) div 2,sLogoText);
       Release;
     end;
   end;

   DxDraw.Primary.Draw (0, 0, DxDraw.Surface.ClientRect, DxDraw.Surface, FALSE);
   if g_MySelf <> nil then begin

   end;
end;

procedure TfrmMain.AppLogout;
begin
   if mrOk = FrmDlg.DMessageDlg ('是否重新选择人物 ?', [mbOk, mbCancel]) then begin
      SendClientMessage (CM_SOFTCLOSE, 0, 0, 0, 0);
      PlayScene.ClearActors;
      CloseAllWindows;
      if not BoOneClick then begin
//         PlayScene.MemoLog.Lines.Add('小退关闭');
         g_SoftClosed := TRUE;
         ActiveCmdTimer (tcSoftClose);
      end else begin
         ActiveCmdTimer (tcReSelConnect);
      end;
      if g_boBagLoaded then
         Savebags ('.\Data\' + g_sServerName + '.' + CharName + '.itm', @g_ItemArr);
      g_boBagLoaded := FALSE;

   end;
end;

procedure TfrmMain.AppExit;
begin
   if mrOk = FrmDlg.DMessageDlg ('你真的要退出游戏吗?', [mbOk, mbCancel]) then begin
      if g_boBagLoaded then  //保存装备
         Savebags ('.\Data\' + g_sServerName + '.' + CharName + '.itm', @g_ItemArr);
      g_boBagLoaded := FALSE;
      FrmMain.Close;
   end;
end;

procedure TfrmMain.PrintScreenNow;
   function IntToStr2(n: integer): string;
   begin
      if n < 10 then Result := '0' + IntToStr(n)
      else Result := IntToStr(n);
   end;
var
   i, k, n, checksum: integer;
   flname: string;
   dib: TDIB;
   ddsd: TDDSurfaceDesc;
   sptr, dptr: PByte;
begin
   if not DxDraw.CanDraw then exit;
   while TRUE do begin
      flname := 'Images' + IntToStr2(g_nCaptureSerial) + '.bmp';
      if not FileExists (flname) then break;
      Inc (g_nCaptureSerial);
   end;
   dib := TDIB.Create;
   dib.BitCount := 8;
   dib.Width := SCREENWIDTH;
   dib.Height := SCREENHEIGHT;
   dib.ColorTable := g_WMainImages.MainPalette;
   dib.UpdatePalette;

   ddsd.dwSize := SizeOf(ddsd);
   checksum := 0;   //盲农芥阑父电促.
   try
      DxDraw.Primary.Lock (TRect(nil^), ddsd);
      for i := (600-120) to SCREENHEIGHT-10 do begin
         sptr := PBYTE(integer(ddsd.lpSurface) + (SCREENHEIGHT - 1 - i)*ddsd.lPitch + 200);
         for k:=0 to 400-1 do begin
            checksum := checksum + byte(pbyte(integer(sptr) + k)^);
         end;
      end;
   finally
      DxDraw.Primary.Unlock();
   end;

   try
      SetBkMode (DxDraw.Primary.Canvas.Handle, TRANSPARENT);
      DxDraw.Primary.Canvas.Font.Color := clWhite;
      n := 0;
      if g_MySelf <> nil then begin
         DxDraw.Primary.Canvas.TextOut (0, 0, g_sServerName + ' ' + g_MySelf.m_sUserName);
         Inc (n, 1);
      end;
      DxDraw.Primary.Canvas.TextOut (0, (n)*12,   'CheckSum=' + IntToStr(checksum));
      DxDraw.Primary.Canvas.TextOut (0, (n+1)*12,  DateToStr(Date));
      DxDraw.Primary.Canvas.TextOut (0, (n+2)*12, TimeToStr(Time));
      DxDraw.Primary.Canvas.Release;
      DxDraw.Primary.Lock (TRect(nil^), ddsd);
      for i := 0 to dib.Height-1 do begin
         sptr := PBYTE(integer(ddsd.lpSurface) + (dib.Height - 1 - i)*ddsd.lPitch);
         dptr := PBYTE(integer(dib.PBits) + i * SCREENWIDTH);
//         dptr := PBYTE(integer(dib.PBits) + i * 800);
         Move (sptr^, dptr^, SCREENWIDTH);
//         Move (sptr^, dptr^, 800);         
      end;
   finally
      DxDraw.Primary.Unlock();
   end;
   dib.SaveToFile (flname);
   dib.Clear;
   dib.Free;
end;


{------------------------------------------------------------}

procedure TfrmMain.ProcessKeyMessages;
begin
   case ActionKey of
     VK_F1, VK_F2, VK_F3, VK_F4, VK_F5, VK_F6, VK_F7, VK_F8: begin
       UseMagic (g_nMouseX, g_nMouseY, GetMagicByKey (char ((ActionKey-VK_F1) + byte('1')) )); //胶农赴 谅钎
       //DScreen.AddSysMsg ('KEY' + IntToStr(Random(10000)));
       ActionKey := 0;
       g_nTargetX := -1;
       exit;
     end;
     12..19: begin
       UseMagic (g_nMouseX, g_nMouseY, GetMagicByKey (char ((ActionKey-12) + byte('1') + byte($14)) ));
       ActionKey := 0;
       g_nTargetX := -1;
       exit;
     end;
   end;
end;
{
 鼠标控制 左　键 控制基本的行动：行走、攻击拾取物品和其他东西
右　键 近处的点击能够看到物品使用方法，远处的点击能够在地图上跑动。
Shift + 左键 强制攻击
Ctrl + 左键 跑动
Ctrl + 右键 关于对手的信息，如同F10一样。
Alt + 右键 取得肉或者其他玩家因为死亡丢失的东西。
双　击 拾取在地上的物品或者使用自己包裹中的物品。
}
procedure TfrmMain.ProcessActionMessages;
var
   mx, my, dx, dy, crun: integer;
   ndir, adir, mdir: byte;
   bowalk, bostop: Boolean;
label
   LB_WALK,TTTT;
begin
   if g_MySelf = nil then exit;

   //Move
   if (g_nTargetX >= 0) and CanNextAction and ServerAcceptNextAction then begin //ActionLock捞 钱府搁, ActionLock篮 悼累捞 场唱扁 傈俊 钱赴促.
      if (g_nTargetX <> g_MySelf.m_nCurrX) or (g_nTargetY <> g_MySelf.m_nCurrY) then begin
         TTTT:
         mx := g_MySelf.m_nCurrX;
         my := g_MySelf.m_nCurrY;
         dx := g_nTargetX;
         dy := g_nTargetY;
         ndir := GetNextDirection (mx, my, dx, dy);
         case g_ChrAction of
            caWalk: begin
               LB_WALK:
               //Jacky 打开
               { 
               DScreen.AddSysMsg ('caWalk ' + IntToStr(Myself.XX) + ' ' +
                                              IntToStr(Myself.m_nCurrY) + ' ' +
                                              IntToStr(TargetX) + ' ' +
                                              IntToStr(TargetY));
                                           }
               crun := g_MySelf.CanWalk;
               if IsUnLockAction (CM_WALK, ndir) and (crun > 0) then begin
                  GetNextPosXY (ndir, mx, my);
                  bowalk := TRUE;
                  bostop := FALSE;
                  if not PlayScene.CanWalk (mx, my) then begin
                     bowalk := FALSE;
                     adir := 0;
                     if not bowalk then begin  //涝备 八荤
                        mx := g_MySelf.m_nCurrX;
                        my := g_MySelf.m_nCurrY;
                        GetNextPosXY (ndir, mx, my);
                        if CheckDoorAction (mx, my) then
                           bostop := TRUE;
                     end;
                     if not bostop and not PlayScene.CrashMan(mx,my) then begin //荤恩篮 磊悼栏肺 乔窍瘤 臼澜..
                        mx := g_MySelf.m_nCurrX;
                        my := g_MySelf.m_nCurrY;
                        adir := PrivDir(ndir);
                        GetNextPosXY (adir, mx, my);
                        if not Map.CanMove(mx,my) then begin
                           mx := g_MySelf.m_nCurrX;
                           my := g_MySelf.m_nCurrY;
                           adir := NextDir (ndir);
                           GetNextPosXY (adir, mx, my);
                           if Map.CanMove(mx,my) then
                              bowalk := TRUE;
                        end else
                           bowalk := TRUE;
                     end;
                     if bowalk then begin
                        g_MySelf.UpdateMsg (CM_WALK, mx, my, adir, 0, 0, '', 0);
                        g_dwLastMoveTick := GetTickCount;
                     end else begin
                        mdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, dx, dy);
                        if mdir <> g_MySelf.m_btDir then
                           g_MySelf.SendMsg (CM_TURN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, 0, 0, '', 0);
                        g_nTargetX := -1;
                     end;
                  end else begin
                     g_MySelf.UpdateMsg (CM_WALK, mx, my, ndir, 0, 0, '', 0);  //亲惑 付瘤阜 疙飞父 扁撅
                     g_dwLastMoveTick := GetTickCount;
                  end;
               end else begin
                  g_nTargetX := -1;
               end;
            end;
            caRun: begin
               //免助跑
               if g_boCanStartRun or (g_nRunReadyCount >= 1) then begin
                  crun := g_MySelf.CanRun;
//骑马开始

                  if (g_MySelf.m_btHorse <> 0)
                     and (GetDistance (mx, my, dx, dy) >= 3)
                     and (crun > 0)
                     and IsUnLockAction (CM_HORSERUN, ndir) then begin
                    GetNextHorseRunXY (ndir, mx, my);
                    if PlayScene.CanRun (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mx, my) then begin
                      g_MySelf.UpdateMsg (CM_HORSERUN, mx, my, ndir, 0, 0, '', 0);
                      g_dwLastMoveTick := GetTickCount;
                     end else begin  //如果跑失败则跳回去走
                        g_ChrAction:=caWalk;
                        goto TTTT;
                     end;
                  end else begin

//骑马结束
                  if (GetDistance (mx, my, dx, dy) >= 2) and (crun > 0) then begin
                     if IsUnLockAction (CM_RUN, ndir) then begin
                        GetNextRunXY (ndir, mx, my);
                        if PlayScene.CanRun (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mx, my) then begin
                           g_MySelf.UpdateMsg (CM_RUN, mx, my, ndir, 0, 0, '', 0);
                           g_dwLastMoveTick := GetTickCount;
                        end else begin  //如果跑失败则跳回去走
                          g_ChrAction:=caWalk;
                          goto TTTT;
                        end;
                     end else
                        g_nTargetX := -1;
                  end else begin
                    //Jacky
                    mdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, dx, dy);
                    if mdir <> g_MySelf.m_btDir then
                       g_MySelf.SendMsg (CM_TURN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, 0, 0, '', 0);
                    g_nTargetX := -1;
                    //Jacky
                     //if crun = -1 then begin
                        //DScreen.AddSysMsg ('瘤陛篮 钝 荐 绝嚼聪促.');
                        //TargetX := -1;
                     //end;
                     goto LB_WALK;
                     {if crun = -2 then begin
                        DScreen.AddSysMsg ('泪矫饶俊 钝 荐 乐嚼聪促.');
                        TargetX := -1;
                     end; }
                  end;
                  end;  //骑马结束
               end else begin
                  Inc (g_nRunReadyCount);
                  goto LB_WALK;
               end;
            end;
         end;
      end;
   end;
   g_nTargetX := -1; //茄锅俊 茄沫究..
   if g_MySelf.RealActionMsg.Ident > 0 then begin
      FailAction := g_MySelf.RealActionMsg.Ident; //角菩且锭 措厚
      FailDir := g_MySelf.RealActionMsg.Dir;
      if g_MySelf.RealActionMsg.Ident = CM_SPELL then begin
         SendSpellMsg (g_MySelf.RealActionMsg.Ident,
                       g_MySelf.RealActionMsg.X,
                       g_MySelf.RealActionMsg.Y,
                       g_MySelf.RealActionMsg.Dir,
                       g_MySelf.RealActionMsg.State);
      end else
         SendActMsg (g_MySelf.RealActionMsg.Ident,
                  g_MySelf.RealActionMsg.X,
                  g_MySelf.RealActionMsg.Y,
                  g_MySelf.RealActionMsg.Dir);
      g_MySelf.RealActionMsg.Ident := 0;

      //皋春甫 罐篮饶 10惯磊惫 捞惑 吧栏搁 磊悼栏肺 荤扼咙
      if g_nMDlgX <> -1 then
         if (abs(g_nMDlgX-g_MySelf.m_nCurrX) >= 8) or (abs(g_nMDlgY-g_MySelf.m_nCurrY) >= 8) then begin
            FrmDlg.CloseMDlg;
            g_nMDlgX := -1;
         end;
   end;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  msg, wc, dir, mx, my: integer;
  ini: TIniFile;
begin
  case Key of
    VK_PAUSE: begin
      Key:=0;
      PrintScreenNow();
    end;


  end;

  if g_DWinMan.KeyDown (Key, Shift) then exit;

  if (g_MySelf = nil) or (DScreen.CurrentScene <> PlayScene) then exit;
  mx:=g_MySelf.m_nCurrX;
  my:=g_MySelf.m_nCurrY;
  case Key of
    VK_F1, VK_F2, VK_F3, VK_F4,
    VK_F5, VK_F6, VK_F7, VK_F8: begin
      if (GetTickCount - g_dwLatestSpellTick > (g_dwSpellTime{500}{+200} + g_dwMagicDelayTime)) then begin
        if ssCtrl in Shift then begin
          ActionKey:=Key - 100;
        end else begin
          ActionKey:=Key;
        end;
      end;
      Key:=0;
    end;
    VK_F9: begin
      FrmDlg.OpenItemBag;
    end;
    VK_F10: begin
      FrmDlg.StatePage := 0;
      FrmDlg.OpenMyStatus;
    end;
    VK_F11: begin
      FrmDlg.StatePage := 3;
      FrmDlg.OpenMyStatus;
    end;
    VK_F12: begin
      if (ssCtrl in Shift) and (ssAlt in Shift) then begin
        frmDlgConfig.Top:= (SCREENHEIGHT - frmDlgConfig.Height) div 2;
        frmDlgConfig.Left:= (SCREENWIDTH - frmDlgConfig.Width) div 2;
        frmDlgConfig.Open;

      end else begin
        FrmDlg.DOptionClick;
      end;
    end;
{
Ctrl + H 选择自己喜欢的攻击模式
和平攻击模式：除了对暴民以外其他攻击都无效。
行会联盟攻击模式：对自己行会内的其他玩家攻击无效
编组攻击模式：处于同一小组的玩家攻击无效
全体攻击模式：对所有的玩家和暴民都具有攻击效果。
善恶攻击模式：PK红名专用攻击模式。
 }
    word('H'): begin
      if ssCtrl in Shift then begin
        SendSay ('@AttackMode');
      end;
    end;
    word('A'): begin
      if ssCtrl in Shift then begin
        SendSay ('@Rest');
      end;
    end;
    word('D'): begin
      if ssCtrl in Shift then begin
        SendPassword('',0);
        {
        SetInputStatus();

        if m_boPasswordIntputStatus then
          DScreen.AddChatBoardString ('请输入密码：', clBlue, clWhite);
         }
      end;
    end;
    {
    word('D'): begin
      if ssCtrl in Shift then begin
        FrmDlg.DChgGamePwd.Visible:=not FrmDlg.DChgGamePwd.Visible;
      end;
    end;
    }

//Ctrl + F 改版游戏的字体，你可以选择8种不同的字体
    word('F'): begin
      if ssCtrl in Shift then begin
        if g_nCurFont < MAXFONT-1 then Inc(g_nCurFont)
        else g_nCurFont := 0;
        g_sCurFontName := g_FontArr[g_nCurFont];
        FrmMain.Font.Name := g_sCurFontName;
        FrmMain.Canvas.Font.Name := g_sCurFontName;
        DxDraw.Surface.Canvas.Font.Name := g_sCurFontName;
        PlayScene.EdChat.Font.Name := g_sCurFontName;

        ini := TIniFile.Create ('.\Lmir.ini');
        if ini <> nil then begin
          ini.WriteString ('Setup', 'FontName', g_sCurFontName);
          ini.Free;
        end;
      end;
    end;
    word('Z'): begin
      if ssCtrl in Shift then begin
        g_boShowAllItem:=not g_boShowAllItem;
      end else
      if not PlayScene.EdChat.Visible then begin
        if CanNextAction and ServerAcceptNextAction then begin
          SendPickup; //捡物品
        end;
      end;
    end;
//Alt + X 重新开始游戏（当角色死亡后特别有用）
      word('X'):
         begin
            if g_MySelf = nil then exit;
            if ssAlt in Shift then begin
               //强行退出
               g_dwLatestStruckTick:=GetTickCount() + 10001;
               g_dwLatestMagicTick:=GetTickCount() + 10001;
               g_dwLatestHitTick:=GetTickCount() + 10001;
               //
               if (GetTickCount - g_dwLatestStruckTick > 10000) and
                  (GetTickCount - g_dwLatestMagicTick > 10000) and
                  (GetTickCount - g_dwLatestHitTick > 10000) or
                  (g_MySelf.m_boDeath) then
               begin
                  AppLogOut;
               end else
                  DScreen.AddChatBoardString ('正在战斗，不能退出..', clYellow, clRed);
            end;
         end;
      word('Q'):
         begin
            if g_MySelf = nil then exit;
            if ssAlt in Shift then begin
               //强行退出
               g_dwLatestStruckTick:=GetTickCount() + 10001;
               g_dwLatestMagicTick:=GetTickCount() + 10001;
               g_dwLatestHitTick:=GetTickCount() + 10001;
               //            
               if (GetTickCount - g_dwLatestStruckTick > 10000) and
                  (GetTickCount - g_dwLatestMagicTick > 10000) and
                  (GetTickCount - g_dwLatestHitTick > 10000) or
                  (g_MySelf.m_boDeath) then
               begin
                  AppExit;
               end else
                  DScreen.AddChatBoardString ('正在战斗，不能退出..', clYellow, clRed);
            end;
         end;
      word('M'): begin
        if not PlayScene.EdChat.Visible then begin
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
      end;
      word('W'): begin
        if not PlayScene.EdChat.Visible then begin
          if GetTickCount > g_dwQueryMsgTick then begin
            g_dwQueryMsgTick := GetTickCount + 3000;
            FrmMain.SendDealTry;
          end;
        end;
      end;
      word('G'): begin
         if ssCtrl in Shift then begin
           if g_FocusCret <> nil then
             if g_GroupMembers.Count = 0 then
               SendCreateGroup(g_FocusCret.m_sUserName)
             else SendAddGroupMember(g_FocusCret.m_sUserName);
             PlayScene.EdChat.Text:=g_FocusCret.m_sUserName;
         end else begin
           if ssAlt in Shift then begin
             if g_FocusCret <> nil then
               SendDelGroupMember(g_FocusCret.m_sUserName)
           end else begin
             if not PlayScene.EdChat.Visible then begin
               if FrmDlg.DGuildDlg.Visible then begin
                 FrmDlg.DGuildDlg.Visible := FALSE;
               end else
                if GetTickCount > g_dwQueryMsgTick then begin
                  g_dwQueryMsgTick := GetTickCount + 3000;
                  FrmMain.SendGuildDlg;
               end;
             end;
           end;
         end;

      end;

      word('S'): begin
        if not PlayScene.EdChat.Visible then
          FrmDlg.ToggleShowGroupDlg;
      end;

      word('C'): begin
        if not PlayScene.EdChat.Visible then begin
          FrmDlg.StatePage := 0;
          FrmDlg.OpenMyStatus;
        end;
      end;

      word('B'): begin
        if not PlayScene.EdChat.Visible then
          FrmDlg.OpenItemBag;
      end;

      word('E'): begin
        if not PlayScene.EdChat.Visible then begin
          FrmDlg.StatePage := 3;
          FrmDlg.OpenMyStatus;
        end;
      end;

      word('V'): begin
        if not PlayScene.EdChat.Visible then
          FrmDlg.OpenFriendDlg();
      end;

      word('N'): begin
        if not PlayScene.EdChat.Visible then
          FrmDlg.OpenAdjustAbility;
      end;
   end;

//键盘上下方向键  按上或者下键可查看过去的聊天信息
   case Key of
      VK_UP:
         with DScreen do begin
            if ChatBoardTop > 0 then Dec (ChatBoardTop);
         end;
      VK_DOWN:
         with DScreen do begin
            if ChatBoardTop < ChatStrs.Count-1 then
               Inc (ChatBoardTop);
         end;
      VK_PRIOR:
         with DScreen do begin
            if ChatBoardTop > VIEWCHATLINE then
               ChatBoardTop := ChatBoardTop - VIEWCHATLINE
            else ChatBoardTop := 0;
         end;
      VK_NEXT:
         with DScreen do begin
            if ChatBoardTop + VIEWCHATLINE < ChatStrs.Count-1 then
               ChatBoardTop := ChatBoardTop + VIEWCHATLINE
            else ChatBoardTop := ChatStrs.Count-1;
            if ChatBoardTop < 0 then ChatBoardTop := 0;
         end;
   end;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if g_DWinMan.KeyPress (Key) then exit;
   if DScreen.CurrentScene = PlayScene then begin
      if PlayScene.EdChat.Visible then begin
         //傍烹栏肺 贸府秦具 窍绰 版快父 酒贰肺 逞绢皑
         exit;
      end;
      case byte(key) of
         byte('1')..byte('6'):
            begin
               EatItem (byte(key) - byte('1')); //骇飘 酒捞袍阑 荤侩茄促.
            end;
         27: //ESC
            begin
            end;
         byte(' '), 13: //盲泼 冠胶
            begin
               PlayScene.EdChat.Visible := TRUE;
               PlayScene.EdChat.SetFocus;
               SetImeMode (PlayScene.EdChat.Handle, LocalLanguage);
               if FrmDlg.BoGuildChat then begin
                  PlayScene.EdChat.Text := '!~';
                  PlayScene.EdChat.SelStart := Length(PlayScene.EdChat.Text);
                  PlayScene.EdChat.SelLength := 0;
               end else begin
                  PlayScene.EdChat.Text := '';
               end;
            end;
{
　 特殊命令 /玩家名字 无距离限制的交流，你也可以用鼠标左键点击聊天窗口中角色的名字来使用这个功能。
!交流文字 向所有人发言（八级以上的玩家才能使用，所有公开发言的信息能够在游戏中保留10秒）
!!文字 如果你们创建了小组，你所发的信息将被组内的其他玩家看见
!~文字 这种广播功能治提供给同一行会的玩家
@拒绝私聊 拒绝所有的私人聊天的命令
@拒绝+人名  对特定的某一个人聊天文字进行屏蔽
@拒绝行会聊天 屏蔽行会聊天所有消息的命令
@退出门派 脱离行会

 }
         byte('@'),
         byte('!'),
         byte('/'):
            begin
               PlayScene.EdChat.Visible := TRUE;
               PlayScene.EdChat.SetFocus;
               SetImeMode (PlayScene.EdChat.Handle, LocalLanguage);
               if key = '/' then begin
                  if WhisperName = '' then PlayScene.EdChat.Text := key
                  else if Length(WhisperName) > 2 then PlayScene.EdChat.Text := '/' + WhisperName + ' '
                  else PlayScene.EdChat.Text := key;
                  PlayScene.EdChat.SelStart := Length(PlayScene.EdChat.Text);
                  PlayScene.EdChat.SelLength := 0;
               end else begin
                  PlayScene.EdChat.Text := key;
                  PlayScene.EdChat.SelStart := 1;
                  PlayScene.EdChat.SelLength := 0;
               end;
            end;
      end;
      key := #0;
   end;
end;

function  TfrmMain.GetMagicByKey (Key: char): PTClientMagic;
var
   i: integer;
   pm: PTClientMagic;
begin
   Result := nil;
   for i:=0 to g_MagicList.Count-1 do begin
      pm := PTClientMagic (g_MagicList[i]);
      if pm.Key = Key then begin
         Result := pm;
         break;
      end;
   end;
end;

procedure TfrmMain.UseMagic (tx, ty: integer; pcm: PTClientMagic); //tx, ty: 胶农赴 谅钎烙.
var
   tdir, targx, targy, targid: integer;
   pmag: PTUseMagicInfo;
begin
   if pcm = nil then exit;
   //是否可以使用魔法：需要的点数<当前点数，或者是魔法EffectType = 0
   if (pcm.Def.wSpell + pcm.Def.btDefSpell <= g_MySelf.m_Abil.MP) or (pcm.Def.btEffectType = 0) then begin
      if pcm.Def.btEffectType = 0 then begin //八过,瓤苞绝澜
         //if CanNextAction and ServerAcceptNextAction then begin

         //堪拳搬篮 茄锅 荤侩饶 9檬鳖瘤绰 促矫 喘妨瘤瘤 臼霸 茄促.
         if pcm.Def.wMagicId = 26 then begin //堪拳搬
            if GetTickCount - g_dwLatestFireHitTick < 10 * 1000 then begin
               exit;
            end;
         end;
         //公怕焊绰 茄锅 荤侩饶 3檬鳖瘤绰 促矫 喘妨瘤瘤 臼绰促.
         if pcm.Def.wMagicId = 27 then begin //公怕焊
            if GetTickCount - g_dwLatestRushRushTick < 3 * 1000 then begin
               exit;
            end;
         end;

         //八过篮 掉饭捞(500ms) 绝捞 喘妨柳促.
         if GetTickCount - g_dwLatestSpellTick > g_dwSpellTime{500} then begin
            g_dwLatestSpellTick := GetTickCount;
            g_dwMagicDelayTime := 0; //pcm.Def.DelayTime;
            SendSpellMsg (CM_SPELL, g_MySelf.m_btDir{x}, 0, pcm.Def.wMagicId, 0);
         end;
      end else begin
         tdir := GetFlyDirection (390, 175, tx, ty);
//         MagicTarget := FocusCret;
//魔法锁定
         if (pcm.Def.wMagicId = 2)
           or (pcm.Def.wMagicId = 14)
           or (pcm.Def.wMagicId = 15)
           or (pcm.Def.wMagicId = 19) then begin
           g_MagicTarget:=g_FocusCret;
         end else begin
           if not g_boMagicLock or (PlayScene.IsValidActor (g_FocusCret) and (not g_FocusCret.m_boDeath)) then begin
             g_MagicLockActor:=g_FocusCret;
           end;
           g_MagicTarget:=g_MagicLockActor;
         end;
         if not PlayScene.IsValidActor (g_MagicTarget) then
            g_MagicTarget := nil;

         if g_MagicTarget = nil then begin
            PlayScene.CXYfromMouseXY (tx, ty, targx, targy);
            targid := 0;
         end else begin
            targx := g_MagicTarget.m_nCurrX;
            targy := g_MagicTarget.m_nCurrY;
            targid := g_MagicTarget.m_nRecogId;
         end;
         if CanNextAction and ServerAcceptNextAction then begin
            g_dwLatestSpellTick := GetTickCount;  //付过 荤侩
            new (pmag);
            FillChar (pmag^, sizeof(TUseMagicInfo), #0);
            pmag.EffectNumber := pcm.Def.btEffect;
            pmag.MagicSerial := pcm.Def.wMagicId;
            pmag.ServerMagicCode := 0;
            g_dwMagicDelayTime := 200 + pcm.Def.dwDelayTime; //促澜 付过阑 荤侩且锭鳖瘤 浆绰 矫埃

            case pmag.MagicSerial of
               //0, 2, 11, 12, 15, 16, 17, 13, 23, 24, 26, 27, 28, 29: ;
               2, 14, 15, 16, 17, 18, 19, 21, //厚傍拜 付过 力寇
               12, 25, 26, 28, 29, 30, 31: ;
               else g_dwLatestMagicTick := GetTickCount;
            end;

            //荤恩阑 傍拜窍绰 版快狼 掉饭捞
            g_dwMagicPKDelayTime := 0;
            if g_MagicTarget <> nil then
               if g_MagicTarget.m_btRace = 0 then
                  g_dwMagicPKDelayTime := 300 + Random(1100); //(600+200 + MagicDelayTime div 5);

            g_MySelf.SendMsg (CM_SPELL, targx, targy, tdir, Integer(pmag), targid, '', 0);
         end;// else
            //Dscreen.AddSysMsg ('泪矫饶俊 荤侩且 荐 乐嚼聪促.');
         //Inc (SpellCount);
      end;
   end else
      Dscreen.AddSysMsg ('魔法点数不够，无法使用...');
      //Dscreen.AddSysMsg ('魔法值不够！！！' + IntToStr(pcm.Def.wSpell) + '+' + IntToStr(pcm.Def.btDefSpell) + '/' +IntToStr(g_MySelf.m_Abil.MP));
end;

procedure TfrmMain.UseMagicSpell (who, effnum, targetx, targety, magic_id: integer);
var
   actor: TActor;
   adir: integer;
   UseMagic: PTUseMagicInfo;
begin
   actor := PlayScene.FindActor (who);
   if actor <> nil then begin
      adir := GetFlyDirection (actor.m_nCurrX, actor.m_nCurrY, targetx, targety);
      new (UseMagic);
      FillChar (UseMagic^, sizeof(TUseMagicInfo), #0);
      UseMagic.EffectNumber := effnum; //magnum;
      UseMagic.ServerMagicCode := 0; //烙矫
      UseMagic.MagicSerial := magic_id;
      actor.SendMsg (SM_SPELL, 0, 0, adir, Integer(UseMagic), 0, '', 0);
      Inc (g_nSpellCount);
   end else
      Inc (g_nSpellFailCount);
end;

procedure TfrmMain.UseMagicFire (who, efftype, effnum, targetx, targety, target: integer);
var
   actor: TActor;
   adir, sound: integer;
   pmag: PTUseMagicInfo;
begin
   sound:=0;//jacky
   actor := PlayScene.FindActor (who);
   if actor <> nil then begin
      //
      actor.SendMsg (SM_MAGICFIRE, target{111magid}, efftype, effnum, targetx, targety, '', sound);
      //efftype = EffectType
      //effnum = Effect

      //if actor = Myself then Dec (SpellCount);
      if g_nFireCount < g_nSpellCount then
         Inc (g_nFireCount);
   end;
   g_MagicTarget := nil;
end;

procedure TfrmMain.UseMagicFireFail (who: integer);
var
   actor: TActor;
begin
   actor := PlayScene.FindActor (who);
   if actor <> nil then begin
      actor.SendMsg (SM_MAGICFIRE_FAIL, 0, 0, 0, 0, 0, '', 0);
   end;
   g_MagicTarget := nil;
end;

procedure TfrmMain.EatItem (idx: integer);
begin
   if idx in [0..MAXBAGITEMCL-1] then begin
      if (g_EatingItem.S.Name <> '') and (GetTickCount - g_dwEatTime > 5 * 1000) then begin
         g_EatingItem.S.Name := '';
      end;
      if (g_EatingItem.S.Name = '') and (g_ItemArr[idx].S.Name <> '') and (g_ItemArr[idx].S.StdMode <= 3) then begin
         g_EatingItem := g_ItemArr[idx];
         g_ItemArr[idx].S.Name := '';
         //氓阑 佬绰 巴... 劳鳃 巴牢 瘤 拱绢夯促.
         if (g_ItemArr[idx].S.StdMode = 4) and (g_ItemArr[idx].S.Shape < 100) then begin
            //shape > 100捞搁 弓澜 酒捞袍 烙..
            if g_ItemArr[idx].S.Shape < 50 then begin
               if mrYes <> FrmDlg.DMessageDlg ('确认开始练习 "' + g_ItemArr[idx].S.Name + '"?', [mbYes, mbNo]) then begin
                  g_ItemArr[idx] := g_EatingItem;
                  exit;
               end;
            end else begin
                //shape > 50捞搁 林巩 辑 辆幅...
               if mrYes <> FrmDlg.DMessageDlg ('你确认开始练习 "' + g_ItemArr[idx].S.Name + '"?', [mbYes, mbNo]) then begin
                  g_ItemArr[idx] := g_EatingItem;
                  exit;
               end;
            end;
         end;
         g_dwEatTime := GetTickCount;
         SendEat (g_ItemArr[idx].MakeIndex, g_ItemArr[idx].S.Name );
         ItemUseSound (g_ItemArr[idx].S.StdMode);
      end;
        //  if 自动放药 and( g_ItemArr[idx].S.StdMode) in [0,3]then
       // for I := 6 to 0..MAXBAGITEMCL-1 do
   end else begin
      if (idx = -1) and g_boItemMoving then begin
         g_boItemMoving := FALSE;
         g_EatingItem := g_MovingItem.Item;
         g_MovingItem.Item.S.Name := '';
         //氓阑 佬绰 巴... 劳鳃 巴牢 瘤 拱绢夯促.
         if (g_EatingItem.S.StdMode = 4) and (g_EatingItem.S.Shape < 100) then begin
            //shape > 100捞搁 弓澜 酒捞袍 烙..
            if g_EatingItem.S.Shape < 50 then begin
               if mrYes <> FrmDlg.DMessageDlg ('确认开始练习 "' + g_EatingItem.S.Name + '"?', [mbYes, mbNo]) then begin
                  AddItemBag (g_EatingItem);
                  exit;
               end;
            end else begin
                //shape > 50捞搁 林巩 辑 辆幅...
               if mrYes <> FrmDlg.DMessageDlg ('确认开始练习 "' + g_EatingItem.S.Name + '"?', [mbYes, mbNo]) then begin
                  AddItemBag (g_EatingItem);
                  exit;
               end;
            end;
         end;
         g_dwEatTime := GetTickCount;
         SendEat (g_EatingItem.MakeIndex, g_EatingItem.S.Name );
         ItemUseSound (g_EatingItem.S.StdMode);
      end;
   end;
end;

function  TfrmMain.TargetInSwordLongAttackRange (ndir: integer): Boolean;
var
   nx, ny: integer;
   actor: TActor;
begin
   Result := FALSE;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nx, ny);
   GetFrontPosition (nx, ny, ndir, nx, ny);
   if (abs(g_MySelf.m_nCurrX - nx) = 2) or (abs(g_MySelf.m_nCurrY-ny) = 2) then begin
      actor := PlayScene.FindActorXY (nx, ny);
      if actor <> nil then
         if not actor.m_boDeath then
            Result := TRUE;
   end;
end;

function  TfrmMain.TargetInSwordWideAttackRange (ndir: integer): Boolean;
var
   nx, ny, rx, ry, mdir: integer;
   actor, ractor: TActor;
begin
   Result := FALSE;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nx, ny);
   actor := PlayScene.FindActorXY (nx, ny);

   mdir := (ndir + 1) mod 8;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
   ractor := PlayScene.FindActorXY (rx, ry);
   if ractor = nil then begin
      mdir := (ndir + 2) mod 8;
      GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
      ractor := PlayScene.FindActorXY (rx, ry);
   end;
   if ractor = nil then begin
      mdir := (ndir + 7) mod 8;
      GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
      ractor := PlayScene.FindActorXY (rx, ry);
   end;

   if (actor <> nil) and (ractor <> nil) then
      if not actor.m_boDeath and not ractor.m_boDeath then
         Result := TRUE;
end;
function  TfrmMain.TargetInSwordCrsAttackRange (ndir: integer): Boolean;
var
   nx, ny, rx, ry, mdir: integer;
   actor, ractor: TActor;
begin
   Result := FALSE;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nx, ny);
   actor := PlayScene.FindActorXY (nx, ny);

   mdir := (ndir + 1) mod 8;
   GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
   ractor := PlayScene.FindActorXY (rx, ry);
   if ractor = nil then begin
      mdir := (ndir + 2) mod 8;
      GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
      ractor := PlayScene.FindActorXY (rx, ry);
   end;
   if ractor = nil then begin
      mdir := (ndir + 7) mod 8;
      GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
      ractor := PlayScene.FindActorXY (rx, ry);
   end;

   if (actor <> nil) and (ractor <> nil) then
      if not actor.m_boDeath and not ractor.m_boDeath then
         Result := TRUE;
end;

{--------------------- Mouse Interface ----------------------}

procedure TfrmMain.DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
   i, mx, my, msx, msy, sel: integer;
   target: TActor;
   itemnames: string;
begin
   if g_DWinMan.MouseMove (Shift, X, Y) then exit;
   if (g_MySelf = nil) or (DScreen.CurrentScene <> PlayScene) then exit;
   g_boSelectMyself := PlayScene.IsSelectMyself (X, Y);

   target := PlayScene.GetAttackFocusCharacter (X, Y, g_nDupSelection, sel, FALSE);
   if g_nDupSelection <> sel then g_nDupSelection := 0;
   if target <> nil then begin
      if (target.m_sUserName = '') and (GetTickCount - target.m_dwSendQueryUserNameTime > 10 * 1000) then begin
         target.m_dwSendQueryUserNameTime := GetTickCount;
         SendQueryUserName (target.m_nRecogId, target.m_nCurrX, target.m_nCurrY);
      end;
      g_FocusCret := target;
   end else
      g_FocusCret := nil;

   g_FocusItem := PlayScene.GetDropItems (X, Y, itemnames);
   if g_FocusItem <> nil then begin
      PlayScene.ScreenXYfromMCXY (g_FocusItem.X, g_FocusItem.Y, mx, my);
      DScreen.ShowHint (mx-20,
                        my-10,
                        itemnames, //PTDropItem(ilist[i]).Name,
                        clWhite,
                        TRUE);
   end else
      DScreen.ClearHint;

   PlayScene.CXYfromMouseXY (X, Y, g_nMouseCurrX, g_nMouseCurrY);
   g_nMouseX := X;
   g_nMouseY := Y;
   g_MouseItem.S.Name := '';
   g_MouseStateItem.S.Name := '';
   g_MouseUserStateItem.S.Name := '';
   if ((ssLeft in Shift) or (ssRight in Shift)) and (GetTickCount - mousedowntime > 300) then
      _DXDrawMouseDown(self, mbLeft, Shift, X, Y);

end;

procedure TfrmMain.DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   mousedowntime := GetTickCount;
   g_nRunReadyCount := 0;     //档框摧扁 秒家(顿扁 牢版快)
   _DXDrawMouseDown (Sender, Button, Shift, X, Y);
end;

procedure TfrmMain.AttackTarget (target: TActor);
var
   tdir, dx, dy, nHitMsg: integer;
begin
   nHitMsg := CM_HIT;
   if g_UseItems[U_WEAPON].S.StdMode = 6 then nHitMsg := CM_HEAVYHIT;

   tdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, target.m_nCurrX, target.m_nCurrY);
   if (abs(g_MySelf.m_nCurrX - target.m_nCurrX) <= 1) and (abs(g_MySelf.m_nCurrY-target.m_nCurrY) <= 1) and (not target.m_boDeath) then begin
      if CanNextAction and ServerAcceptNextAction and CanNextHit then begin

         if g_boNextTimeFireHit and (g_MySelf.m_Abil.MP >= 7) then begin
            g_boNextTimeFireHit := FALSE;
            nHitMsg := CM_FIREHIT;
         end else
         if g_boNextTimePowerHit then begin  //颇况 酒咆牢 版快, 抗档八过
            g_boNextTimePowerHit := FALSE;
            nHitMsg := CM_POWERHIT;
         end else
         if g_boCanTwnHit and (g_MySelf.m_Abil.MP >= 10) then begin
            g_boCanTwnHit := FALSE;
            nHitMsg := CM_TWINHIT;
         end else
         if g_boCanWideHit and (g_MySelf.m_Abil.MP >= 3) then begin //and (TargetInSwordWideAttackRange (tdir)) then begin  //氛 酒咆牢 版快, 馆岿八过
            nHitMsg := CM_WIDEHIT;
         end else
         if g_boCanCrsHit and (g_MySelf.m_Abil.MP >= 6) then begin
            nHitMsg := CM_CRSHIT;
         end else
         if g_boCanLongHit and (TargetInSwordLongAttackRange (tdir)) then begin  //氛 酒咆牢 版快, 绢八贱
            nHitMsg := CM_LONGHIT;
         end;

         //if ((target.m_btRace <> RCC_USERHUMAN) and (target.m_btRace <> RCC_GUARD)) or (ssShift in Shift) then //荤恩阑 角荐肺 傍拜窍绰 巴阑 阜澜
         g_MySelf.SendMsg (nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
         g_dwLatestHitTick := GetTickCount;
      end;
      g_dwLastAttackTick := GetTickCount;
   end else begin
      //厚档甫 甸绊 乐栏搁
      //if (UseItems[U_WEAPON].S.Shape = 6) and (target <> nil) then begin
      //   Myself.SendMsg (CM_THROW, Myself.XX, Myself.m_nCurrY, tdir, integer(target), 0, '', 0);
      //   TargetCret := nil;  //
      //end else begin
      if (abs(g_MySelf.m_nCurrX - target.m_nCurrX) <= 2) and (abs(g_MySelf.m_nCurrY-target.m_nCurrY) <= 2) and (not target.m_boDeath) then
         g_ChrAction := caWalk
      else g_ChrAction := caRun;//跑步砍
      GetBackPosition (target.m_nCurrX, target.m_nCurrY, tdir, dx, dy);
      g_nTargetX := dx;
      g_nTargetY := dy;
      //end;
   end;
end;

procedure TfrmMain._DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   tdir, nx, ny, nHitMsg, sel: integer;
   target: TActor;
begin
   ActionKey := 0;
   g_nMouseX := X;
   g_nMouseY := Y;
   g_boAutoDig := FALSE;

   if (Button = mbRight) and g_boItemMoving then begin      //是否当前在移动物品
      FrmDlg.CancelItemMoving;
      exit;
   end;
   if g_DWinMan.MouseDown (Button, Shift, X, Y) then exit; //鼠标移到窗口上了则跳过
   if (g_MySelf = nil) or (DScreen.CurrentScene <> PlayScene) then exit;  //如果人物退出则跳过

   if ssRight in Shift then begin       //鼠标右键
      if Shift = [ssRight] then Inc (g_nDupSelection);  //般闷阑 版快 急琶
      target := PlayScene.GetAttackFocusCharacter (X, Y, g_nDupSelection, sel, FALSE); //取指定坐标上的角色
      if g_nDupSelection <> sel then g_nDupSelection := 0;
      if target <> nil then begin
         if ssCtrl in Shift then begin //CTRL + 鼠标右键 = 显示角色的信息
            if GetTickCount - g_dwLastMoveTick > 1000 then begin
               if (target.m_btRace = 0) and (not target.m_boDeath) then begin
                  //取得人物信息
                  SendClientMessage (CM_QUERYUSERSTATE, target.m_nRecogId, target.m_nCurrX, target.m_nCurrY, 0);
                  exit;
               end;
            end;
         end;
      end else
         g_nDupSelection := 0;
      //按鼠标右键，并且鼠标指向空位置
      PlayScene.CXYfromMouseXY (X, Y, g_nMouseCurrX, g_nMouseCurrY);

      if (abs(g_MySelf.m_nCurrX - g_nMouseCurrX) <= 2) and (abs(g_MySelf.m_nCurrY - g_nMouseCurrY) <= 2) then begin //目标座标
         tdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
         if CanNextAction and ServerAcceptNextAction then begin
            g_MySelf.SendMsg (CM_TURN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
         end;
      end else begin //顿扁
         g_ChrAction := caRun;
         g_nTargetX := g_nMouseCurrX;
         g_nTargetY := g_nMouseCurrY;
         exit;
      end;

{
      if CanNextAction and ServerAcceptNextAction then begin
        //人物座标与目标座标之间是否小于2，小于则走操作
        if (abs(Myself.XX-MCX) <= 2) and (abs(Myself.m_nCurrY-MCY) <= 2) then begin
           ChrAction := caWalk;
        end else begin //跑操作
           ChrAction := caRun;
        end;
           TargetX := MCX;
           TargetY := MCY;
           exit;
      end;
 }
   end;

   if ssLeft in Shift {Button = mbLeft} then begin
      //傍拜... 承篮 裹困肺 急琶凳
      target := PlayScene.GetAttackFocusCharacter (X, Y, g_nDupSelection, sel, TRUE); //混酒乐绰 仇父..
      PlayScene.CXYfromMouseXY (X, Y, g_nMouseCurrX, g_nMouseCurrY);
      g_TargetCret := nil;

      if (g_UseItems[U_WEAPON].S.Name <> '') and (target = nil)
//骑马状态不可以操作
        and (g_MySelf.m_btHorse = 0) then begin
         //挖矿
         if g_UseItems[U_WEAPON].S.Shape = 19 then begin //鹤嘴锄
            tdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
            GetFrontPosition (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, nx, ny);
            if not Map.CanMove(nx, ny) or (ssShift in Shift) then begin  //不能移动或强行挖矿
               if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
                  g_MySelf.SendMsg (CM_HIT+1, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
               end;
               g_boAutoDig := TRUE;
               exit;
            end;
         end;
      end;

      if (ssAlt in Shift)
//骑马状态不可以操作
        and (g_MySelf.m_btHorse = 0) then begin
         //挖物品
         tdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
         if CanNextAction and ServerAcceptNextAction then begin
            target := PlayScene.ButchAnimal (g_nMouseCurrX, g_nMouseCurrY);
            if target <> nil then begin
               SendButchAnimal (g_nMouseCurrX, g_nMouseCurrY, tdir, target.m_nRecogId);
               g_MySelf.SendMsg (CM_SITDOWN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0); //磊技绰 鞍澜
               exit;
            end;
            g_MySelf.SendMsg (CM_SITDOWN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
         end;
         g_nTargetX := -1;
      end else begin
         if (target <> nil) or (ssShift in Shift) then begin
            //哭率付快胶 努腐 肚绰 鸥百捞 乐澜.
            g_nTargetX := -1;
            if target <> nil then begin
               //鸥百捞 乐澜.

               //叭促啊 惑牢 皋春啊 唱坷绰 巴阑 规瘤.
               if GetTickCount - g_dwLastMoveTick > 1500 then begin
                  //惑牢牢 版快,
                  if target.m_btRace = RCC_MERCHANT then begin
                     SendClientMessage (CM_CLICKNPC, target.m_nRecogId, 0, 0, 0);
                     exit;
                  end;
               end;

               if (not target.m_boDeath)
//骑马不允许操作
                 and (g_MySelf.m_btHorse = 0) then begin
                  g_TargetCret := target;
                  if ((target.m_btRace <> RCC_USERHUMAN) and
                      (target.m_btRace <> RCC_GUARD) and
                      (target.m_btRace <> RCC_MERCHANT) and
                      (pos('(', target.m_sUserName) = 0) //包括'('的角色名称为召唤的宝宝
                     )
                     or (ssShift in Shift) //SHIFT + 鼠标左键
                     or (target.m_nNameColor = ENEMYCOLOR)   //利篮 磊悼 傍拜捞 凳
                  then begin
                     AttackTarget (target);
                     g_dwLatestHitTick := GetTickCount;
                  end;
               end;
            end else begin
//骑马不允许操作
               if (g_MySelf.m_btHorse = 0) then begin
               tdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
               if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
                  nHitMsg := CM_HIT+Random(3);
                  if g_boCanLongHit and (TargetInSwordLongAttackRange (tdir)) then begin  //是否可以使用刺杀
                     nHitMsg := CM_LONGHIT;
                  end;
                  if g_boCanWideHit and (g_MySelf.m_Abil.MP >= 3) and (TargetInSwordWideAttackRange (tdir)) then begin  //是否可以使用半月
                     nHitMsg := CM_WIDEHIT;
                  end;
                  if g_boCanCrsHit and (g_MySelf.m_Abil.MP >= 6) and (TargetInSwordCrsAttackRange (tdir)) then begin  //是否可以使用半月
                     nHitMsg := CM_CRSHIT;
                  end;
                  g_MySelf.SendMsg (nHitMsg, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0, 0, '', 0);
               end;
               g_dwLastAttackTick := GetTickCount;
               end;
            end;
         end else begin
//            if (MCX = Myself.XX) and (MCY = Myself.m_nCurrY) then begin
            if (g_nMouseCurrX = (g_MySelf.m_nCurrX)) and (g_nMouseCurrY = (g_MySelf.m_nCurrY)) then begin
               tdir := GetNextDirection (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nMouseCurrX, g_nMouseCurrY);
               if CanNextAction and ServerAcceptNextAction then begin
                  SendPickup; //捡物品
               end;
            end else
               if GetTickCount - g_dwLastAttackTick > 1000 then begin //最后攻击操作停留指定时间才能移动
                  if ssCtrl in Shift then begin
                     g_ChrAction := caRun;
                  end else begin
                     g_ChrAction := caWalk;
                  end;
                  g_nTargetX := g_nMouseCurrX;
                  g_nTargetY := g_nMouseCurrY;
               end;
         end;
      end;
   end;
end;

procedure TfrmMain.DXDrawDblClick(Sender: TObject);
var
   pt: TPoint;
begin
   GetCursorPos (pt);
   if g_DWinMan.DblClick (pt.X, pt.Y) then exit;
end;

function  TfrmMain.CheckDoorAction (dx, dy: integer): Boolean;
var
   nx, ny, ndir, door: integer;
begin
   Result := FALSE;
   //if not Map.CanMove (dx, dy) then begin
      //if (Abs(dx-Myself.XX) <= 2) and (Abs(dy-Myself.m_nCurrY) <= 2) then begin
         door := Map.GetDoor (dx, dy);
         if door > 0 then begin
            if not Map.IsDoorOpen (dx, dy) then begin
               SendClientMessage (CM_OPENDOOR, door, dx, dy, 0);
               Result := TRUE;
            end;    
         end;
      //end;
   //end;
end;

procedure TfrmMain.DXDrawMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if g_DWinMan.MouseUp (Button, Shift, X, Y) then exit;
   g_nTargetX := -1;
end;

procedure TfrmMain.DXDrawClick(Sender: TObject);
var
   pt: TPoint;
begin
   GetCursorPos (pt);
   if g_DWinMan.Click (pt.X, pt.Y) then exit;
end;
//鼠标事件:当选择了魔法等攻击前，显示一个选择被攻击对象的鼠标
procedure TfrmMain.MouseTimerTimer(Sender: TObject);
var
  I: Integer;
   pt: TPoint;
   keyvalue: TKeyBoardState;
   shift: TShiftState;

begin
   GetCursorPos (pt);
   SetCursorPos (pt.X, pt.Y);

   if g_TargetCret <> nil then begin
      if ActionKey > 0 then begin
         ProcessKeyMessages;
      end else begin
         if not g_TargetCret.m_boDeath and PlayScene.IsValidActor(g_TargetCret) then begin
            FillChar(keyvalue, sizeof(TKeyboardState), #0);
            if GetKeyboardState (keyvalue) then begin
               shift := [];
               if ((keyvalue[VK_SHIFT] and $80) <> 0) then shift := shift + [ssShift];
               if ((g_TargetCret.m_btRace <> RCC_USERHUMAN) and
                   (g_TargetCret.m_btRace <> RCC_GUARD) and
                   (g_TargetCret.m_btRace <> RCC_MERCHANT) and
                   (pos('(', g_TargetCret.m_sUserName) = 0) //林牢乐绰 各(碍力傍拜 秦具窃)
                  )
                  or (g_TargetCret.m_nNameColor = ENEMYCOLOR)   //利篮 磊悼 傍拜捞 凳
                  or ((ssShift in Shift) and (not PlayScene.EdChat.Visible)) then begin //荤恩阑 角荐肺 傍拜窍绰 巴阑 阜澜
                  AttackTarget (g_TargetCret);
               end; //else begin
                  //TargetCret := nil;
               //end
            end;
         end else
            g_TargetCret := nil;
      end;
   end;
   if g_boAutoDig then begin
      if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
         g_MySelf.SendMsg (CM_HIT+1, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_MySelf.m_btDir, 0, 0, '', 0);
      end;
   end;
   //动自捡取
   if g_boAutoPuckUpItem and
      (g_MySelf <> nil) and
      ((GetTickCount() - g_dwAutoPickupTick) > g_dwAutoPickupTime) then begin

     g_dwAutoPickupTick:=GetTickCount();
     AutoPickUpItem();
   end;
end;
procedure TfrmMain.AutoPickUpItem;
var
  I: Integer;
  ItemList:TList;
  DropItem:pTDropItem;
  ShowItem:pTShowItem;
begin
  if CanNextAction and ServerAcceptNextAction then begin
    if g_AutoPickupList = nil then exit;
      
    g_AutoPickupList.Clear;
    PlayScene.GetXYDropItemsList(g_MySelf.m_nCurrX,g_MySelf.m_nCurrY,g_AutoPickupList);
    for I := 0 to g_AutoPickupList.Count - 1 do begin
      DropItem:=g_AutoPickupList.Items[I];
      ShowItem:=GetShowItem(DropItem.Name);
      if (ShowItem <> nil) and (ShowItem.boAutoPickup) then
        SendPickup;        
    end;
  end;
end;

procedure TfrmMain.WaitMsgTimerTimer(Sender: TObject);
begin
   if g_MySelf = nil then exit;
   if g_MySelf.ActionFinished then begin
      WaitMsgTimer.Enabled := FALSE;
//      PlayScene.MemoLog.Lines.Add('WaitingMsg: ' + IntToStr(WaitingMsg.Ident));
      case WaitingMsg.Ident of
         SM_CHANGEMAP:
            begin
               g_boMapMovingWait := FALSE;
               g_boMapMoving := FALSE;
               //
               if g_nMDlgX <> -1 then begin
                  FrmDlg.CloseMDlg;
                  g_nMDlgX := -1;
               end;
               ClearDropItems;
               PlayScene.CleanObjects;
               g_sMapTitle := '';
               g_MySelf.CleanCharMapSetting (WaitingMsg.Param, WaitingMsg.Tag);
               PlayScene.SendMsg (SM_CHANGEMAP, 0,
                                    WaitingMsg.Param{x},
                                    WaitingMsg.tag{y},
                                    WaitingMsg.Series{darkness},
                                    0, 0,
                                    WaitingStr{mapname});

               //DScreen.AddSysMsg (IntToStr(WaitingMsg.Param) + ' ' +
               //                   IntToStr(WaitingMsg.Tag) + ' : My ' +
               //                   IntToStr(Myself.XX) + ' ' +
               //                   IntToStr(Myself.m_nCurrY) + ' ' +
               //                   IntToStr(Myself.RX) + ' ' +
               //                   IntToStr(Myself.RY) + ' '
               //                  );
               g_nTargetX := -1;
               g_TargetCret := nil;
               g_FocusCret := nil;

            end;
      end;
   end;
end;



{----------------------- Socket -----------------------}
//在选择服务器后开启，等待一段时间后进入选择角色状态（等待“开门”的动画完成）
procedure TfrmMain.SelChrWaitTimerTimer(Sender: TObject);
begin
   SelChrWaitTimer.Enabled := FALSE;
   SendQueryChr;
end;

procedure TfrmMain.ActiveCmdTimer (cmd: TTimerCommand);
begin
   CmdTimer.Enabled := TRUE;
   TimerCmd := cmd;
end;
//处理跟网络连接有关的几个事件
procedure TfrmMain.CmdTimerTimer(Sender: TObject);
begin
   CmdTimer.Enabled := FALSE;
   CmdTimer.Interval := 2000;
//   PlayScene.MemoLog.Lines.Add('CmdTimerTimer -' + IntToStr(Integer(TimerCmd)));
   case TimerCmd of
      tcSoftClose:  //断开连接
         begin
//            PlayScene.MemoLog.Lines.Add('tcSoftClose');
            CmdTimer.Enabled := FALSE;
            CSocket.Socket.Close;
         end;
      tcReSelConnect:
         begin
           // try
//PlayScene.MemoLog.Lines.Add('ConnectionStep -1');
            //清除所有对象
            ResetGameVariables;
//PlayScene.MemoLog.Lines.Add('ConnectionStep -2');
            //返回到选择角色状态
            DScreen.ChangeScene (stSelectChr);
//PlayScene.MemoLog.Lines.Add('ConnectionStep -3');
           //重新连接服务器
            g_ConnectionStep := cnsReSelChr;
            {
            except
              on e: Exception do
              PlayScene.MemoLog.Lines.Add(e.Message);
            end;
            }
//            if ConnectionStep = cnsReSelChr then
//              PlayScene.MemoLog.Lines.Add('ConnectionStep -cnsReSelChr');
            if not BoOneClick then begin
//               PlayScene.MemoLog.Lines.Add('cnsReSelChr -' +  SelChrAddr + '/' + IntToStr(SelChrPort) );
               with CSocket do begin
                  Active := FALSE;
                  Address := g_sSelChrAddr;
                  Port := g_nSelChrPort;
                  Active := TRUE;
               end;

            end else begin
               if CSocket.Socket.Connected then
                  CSocket.Socket.SendText ('$S' + g_sSelChrAddr + '/' + IntToStr(g_nSelChrPort) + '%');
               CmdTimer.Interval := 1;
               ActiveCmdTimer (tcFastQueryChr);
            end;

         end;
      tcFastQueryChr: //查询角色
         begin
            SendQueryChr;
         end;
   end;
end;

procedure TfrmMain.CloseAllWindows;
begin
   with FrmDlg do begin
      DItemBag.Visible := FALSE;
      DMsgDlg.Visible := FALSE;
      DStateWin.Visible := FALSE;
      DMerchantDlg.Visible := FALSE;
      DSellDlg.Visible := FALSE;
      DMenuDlg.Visible := FALSE;
      DKeySelDlg.Visible := FALSE;
      DGroupDlg.Visible := FALSE;
      DDealDlg.Visible := FALSE;
      DDealRemoteDlg.Visible := FALSE;
      DGuildDlg.Visible := FALSE;
      DGuildEditNotice.Visible := FALSE;
      DUserState1.Visible := FALSE;
      DAdjustAbility.Visible := FALSE;
   end;
   if g_nMDlgX <> -1 then begin
      FrmDlg.CloseMDlg;
      g_nMDlgX := -1;
   end;
   g_boItemMoving := FALSE;  //
end;

procedure TfrmMain.ClearDropItems;
var
  I:Integer;
begin
  for I:=0 to g_DropedItemList.Count - 1 do begin
    Dispose (PTDropItem(g_DropedItemList[I]));
  end;
  g_DropedItemList.Clear;
end;

procedure TfrmMain.ResetGameVariables;
var
   i: integer;
   ClientMagic:pTClientMagic;
begin
try
   CloseAllWindows;
   ClearDropItems;
   ClearShowItemList();
   for i:=0 to g_MagicList.Count - 1  do begin
    Dispose(pTClientMagic(g_MagicList[i]));
   end;
   g_MagicList.Clear;



   g_boItemMoving := FALSE;
   g_WaitingUseItem.Item.S.Name := '';
   g_EatingItem.S.name := '';
   g_nTargetX := -1;
   g_TargetCret := nil;
   g_FocusCret := nil;
   g_MagicTarget := nil;
   ActionLock := FALSE;
   g_GroupMembers.Clear;
   g_sGuildRankName := '';
   g_sGuildName := '';

   g_boMapMoving := FALSE;
   WaitMsgTimer.Enabled := FALSE;
   g_boMapMovingWait := FALSE;
   DScreen.ChatBoardTop := 0;
   g_boNextTimePowerHit := FALSE;
   g_boCanLongHit := FALSE;
   g_boCanWideHit := FALSE;
   g_boCanCrsHit   := False;
   g_boCanTwnHit   := False;

   g_boNextTimeFireHit := FALSE;

   FillChar (g_UseItems, sizeof(TClientItem)*9, #0);
   FillChar (g_ItemArr, sizeof(TClientItem)*MAXBAGITEMCL, #0);

   with SelectChrScene do begin
      FillChar (ChrArr, sizeof(TSelChar)*2, #0);
      ChrArr[0].FreezeState := TRUE; //扁夯捞 倔绢 乐绰 惑怕
      ChrArr[1].FreezeState := TRUE;
   end;
   PlayScene.ClearActors;
   ClearDropItems;
   EventMan.ClearEvents;
   PlayScene.CleanObjects;
   //DxDrawRestoreSurface (self);
   g_MySelf := nil;

except
//  on e: Exception do
//    PlayScene.MemoLog.Lines.Add(e.Message);
end;
end;

procedure TfrmMain.ChangeServerClearGameVariables;
var
   i: integer;
begin
   CloseAllWindows;
   ClearDropItems;
   for i:=0 to g_MagicList.Count-1 do
      Dispose (PTClientMagic (g_MagicList[i]));
   g_MagicList.Clear;
   g_boItemMoving := FALSE;
   g_WaitingUseItem.Item.S.Name := '';
   g_EatingItem.S.name := '';
   g_nTargetX := -1;
   g_TargetCret := nil;
   g_FocusCret := nil;
   g_MagicTarget := nil;
   ActionLock := FALSE;
   g_GroupMembers.Clear;
   g_sGuildRankName := '';
   g_sGuildName := '';

   g_boMapMoving := FALSE;
   WaitMsgTimer.Enabled := FALSE;
   g_boMapMovingWait := FALSE;
   g_boNextTimePowerHit := FALSE;
   g_boCanLongHit := FALSE;
   g_boCanWideHit := FALSE;
   g_boCanCrsHit   := False;
   g_boCanTwnHit   := False;

   ClearDropItems;
   EventMan.ClearEvents;
   PlayScene.CleanObjects;
end;

procedure TfrmMain.CSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
   packet: array[0..255] of char;
   strbuf: array[0..255] of char;
   str: string;
begin
// FrmDlg.DMessageDlg (CSocket.Socket.RemoteAddress+':'+inttostr(CSocket.Socket.RemotePort)+'\连接', [mbOk]);
   g_boServerConnected := TRUE;
   if g_ConnectionStep = cnsLogin then begin
      if OneClickMode = toKornetWorld then begin  //内齿岿靛甫 版蜡秦辑 霸烙俊 立加
         FillChar (packet, 256, #0);
         str := 'KwGwMGS';             StrPCopy (strbuf, str);  Move (strbuf, (@packet[0])^, Length(str));
         str := 'CONNECT';             StrPCopy (strbuf, str);  Move (strbuf, (@packet[8])^, Length(str));
         str := KornetWorld.CPIPcode;  StrPCopy (strbuf, str);  Move (strbuf, (@packet[16])^, Length(str));
         str := KornetWorld.SVCcode;   StrPCopy (strbuf, str);  Move (strbuf, (@packet[32])^, Length(str));
         str := KornetWorld.LoginID;   StrPCopy (strbuf, str);  Move (strbuf, (@packet[48])^, Length(str));
         str := KornetWorld.CheckSum;  StrPCopy (strbuf, str);  Move (strbuf, (@packet[64])^, Length(str));
         Socket.SendBuf (packet, 256);
      end;
      DScreen.ChangeScene (stLogin);
{$IF USECURSOR = DEFAULTCURSOR}
      DxDraw.Cursor:=crDefault;
{$IFEND}
   end;
   if g_ConnectionStep = cnsSelChr then begin
      LoginScene.OpenLoginDoor;
      SelChrWaitTimer.Enabled := TRUE;
   end;
   if g_ConnectionStep = cnsReSelChr then begin
      CmdTimer.Interval := 1;
      ActiveCmdTimer (tcFastQueryChr);
   end;
   if g_ConnectionStep = cnsPlay then begin
      if not g_boServerChanging then begin
         ClearBag;  //啊规 檬扁拳
         DScreen.ClearChatBoard; //盲泼芒 檬扁拳
         DScreen.ChangeScene (stLoginNotice);
      end else begin
         ChangeServerClearGameVariables;
      end;
      SendRunLogin;
   end;
   SocStr := '';
   BufferStr := '';
end;

procedure TfrmMain.CSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   g_boServerConnected := FALSE;
   if (g_ConnectionStep = cnsLogin) and not g_boSendLogin then begin
     FrmDlg.DMessageDlg ('网络连接异常,程序将退出...', [mbOk]);
     Close;
   end;
   if g_SoftClosed then begin
//      PlayScene.MemoLog.Lines.Add('CSocketDisconnect - tcSoftClose');
      g_SoftClosed := FALSE;
      ActiveCmdTimer (tcReSelConnect);
   end;
end;

procedure TfrmMain.CSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
   ErrorCode := 0;
   Socket.Close;
end;

procedure TfrmMain.CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
   n: integer;
   data, data2: string;
begin
   data := Socket.ReceiveText;
   //if pos('GOOD', data) > 0 then DScreen.AddSysMsg (data);

   n := pos('*', data);
   if n > 0 then begin
      data2 := Copy (data, 1, n-1);
      data := data2 + Copy (data, n+1, Length(data));
      //SendSocket ('*');
      CSocket.Socket.SendText ('*');
   end;
   SocStr := SocStr + data;
end;

{-------------------------------------------------------------}

procedure TfrmMain.SendSocket (sendstr: string);
const
   code: byte = 1;
var
   sSendText:String;
begin
   if CSocket.Socket.Connected then begin
      CSocket.Socket.SendText ('#' + IntToStr(code) + sendstr + '!');
     Inc (code);
     if code >= 10 then code := 1;
   end;
end;


procedure TfrmMain.SendClientMessage (msg, Recog, param, tag, series: integer);
var
   dmsg: TDefaultMessage;
begin
   dmsg := MakeDefaultMsg (msg, Recog, param, tag, series);
   SendSocket (EncodeMessage (dmsg));
end;

procedure TfrmMain.SendLogin (uid, passwd: string);
var
   msg: TDefaultMessage;
begin
   LoginId := uid;
   LoginPasswd := passwd;
   msg := MakeDefaultMsg (CM_IDPASSWORD, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString(uid + '/' + passwd));
   g_boSendLogin:=True;
end;

procedure TfrmMain.SendNewAccount (ue: TUserEntry; ua: TUserEntryAdd);
var
   msg: TDefaultMessage;
begin
   MakeNewId := ue.sAccount;
   msg := MakeDefaultMsg (CM_ADDNEWUSER, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeBuffer(@ue, sizeof(TUserEntry)) + EncodeBuffer(@ua, sizeof(TUserEntryAdd)));
end;

procedure TfrmMain.SendUpdateAccount (ue: TUserEntry; ua: TUserEntryAdd);
var
   msg: TDefaultMessage;
begin
   MakeNewId := ue.sAccount;
   msg := MakeDefaultMsg (CM_UPDATEUSER, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeBuffer(@ue, sizeof(TUserEntry)) + EncodeBuffer(@ua, sizeof(TUserEntryAdd)));
end;

procedure TfrmMain.SendSelectServer (svname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_SELECTSERVER, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString(svname));
end;

procedure TfrmMain.SendChgPw (id, passwd, newpasswd: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_CHANGEPASSWORD, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString (id + #9 + passwd + #9 + newpasswd));
end;

procedure TfrmMain.SendNewChr (uid, uname, shair, sjob, ssex: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_NEWCHR, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString (uid + '/' + uname + '/' + shair + '/' + sjob + '/' + ssex));
end;

procedure TfrmMain.SendQueryChr;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_QUERYCHR, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString(LoginId + '/' + IntToStr(Certification)));
end;

procedure TfrmMain.SendDelChr (chrname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DELCHR, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString(chrname));
end;

procedure TfrmMain.SendSelChr (chrname: string);
var
   msg: TDefaultMessage;
begin
   CharName := chrname;
   msg := MakeDefaultMsg (CM_SELCHR, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString(LoginId + '/' + chrname));
   PlayScene.EdAccountt.Visible:=False;//2004/05/17
   PlayScene.EdChrNamet.Visible:=False;//2004/05/17
end;

procedure TfrmMain.SendRunLogin;
var
   msg: TDefaultMessage;
   str: string;
   sSendMsg:String;
begin
   //强行登录
   {
   str := '**' +
          PlayScene.EdAccountt.Text + '/' +
          PlayScene.EdChrNamet.Text + '/' +
          IntToStr(Certification) + '/' +
          IntToStr(VERSION_NUMBER) + '/';
  }

(*   str := '**' +
          LoginId + '/' +
          CharName + '/' +
          IntToStr(Certification) + '/' +
          IntToStr(VERSION_NUMBER) + '/';

//          IntToStr(VERSION_NUMBER_0522) + '/';

   //if NewGameStart then begin
   //   str := str + '0';
   //   NewGameStart := FALSE;
   //end else str := str + '1';
   str := str + '9';*)
   sSendMsg:=format('**%s/%s/%d/%d/%d',[LoginId,CharName,Certification,CLIENT_VERSION_NUMBER,RUNLOGINCODE]);
   SendSocket (EncodeString (sSendMsg));
   
end;

procedure TfrmMain.SendSay (str: string);
var
   msg: TDefaultMessage;
begin
   if str <> '' then begin
     if m_boPasswordIntputStatus then begin
       m_boPasswordIntputStatus      := False;
       PlayScene.EdChat.PasswordChar := #0;
       PlayScene.EdChat.Visible      := False;
       SendPassword(str,1);
       exit;
     end;
     if CompareLstr(str,'/cmd',length('/cmd')) then begin
       ProcessCommand(str);
       exit;
     end;
       
      if str = '/debug check' then begin
        g_boShowMemoLog:=not g_boShowMemoLog;
        PlayScene.MemoLog.Clear;
        PlayScene.MemoLog.Visible:=g_boShowMemoLog;
        exit;
      end;
      if str = '/debug powerblock' then begin
        SendPowerBlock();
        exit;
      end;

      if str = '/debug screen' then begin
         g_boCheckBadMapMode := not g_boCheckBadMapMode;
         if g_boCheckBadMapMode then DScreen.AddSysMsg ('On')
         else DScreen.AddSysMsg ('Off');
         exit;
      end;
      if str = '/check speedhack' then begin
         g_boCheckSpeedHackDisplay := not g_boCheckSpeedHackDisplay;
         exit;
      end;
      if str = '/hungry' then begin
         Inc(g_nMyHungryState);
         if g_nMyHungryState > 4 then g_nMyHungryState:=1;
           
         exit;
      end;
      if str = '/hint screen' then begin
         g_boShowGreenHint := not g_boShowGreenHint;
         g_boShowWhiteHint := not g_boShowWhiteHint;
         exit;
      end;

      if str = '@password' then begin
         if PlayScene.EdChat.PasswordChar = #0 then
            PlayScene.EdChat.PasswordChar := '*'
         else PlayScene.EdChat.PasswordChar := #0;
         exit;   
      end;
      if PlayScene.EdChat.PasswordChar = '*' then
        PlayScene.EdChat.PasswordChar:= #0;

      msg := MakeDefaultMsg (CM_SAY, 0, 0, 0, 0);
      SendSocket (EncodeMessage (msg) + EncodeString(str));
      if str[1] = '/' then begin
         DScreen.AddChatBoardString (str, GetRGB(180), clWhite);
         GetValidStr3 (Copy(str,2,Length(str)-1), WhisperName, [' ']);
      end;
   end;
end;

procedure TfrmMain.SendActMsg (ident, x, y, dir: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (ident, MakeLong(x,y), 0, dir, 0);
   SendSocket (EncodeMessage (msg));
   ActionLock := TRUE; //辑滚俊辑 #+FAIL! 捞唱 #+GOOD!捞 棵锭鳖瘤 扁促覆
   ActionLockTime := GetTickCount;
   Inc (g_nSendCount);
end;

procedure TfrmMain.SendSpellMsg (ident, x, y, dir, target: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (ident, MakeLong(x,y), Loword(target), dir, Hiword(target));
   SendSocket (EncodeMessage (msg));
   ActionLock := TRUE; //辑滚俊辑 #+FAIL! 捞唱 #+GOOD!捞 棵锭鳖瘤 扁促覆
   ActionLockTime := GetTickCount;
   Inc (g_nSendCount);
end;

procedure TfrmMain.SendQueryUserName (targetid, x, y: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_QUERYUSERNAME, targetid, x, y, 0);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendDropItem (name: string; itemserverindex: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DROPITEM, itemserverindex, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString (name));
end;

procedure TfrmMain.SendPickup;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_PICKUP, 0, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, 0);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendTakeOnItem (where: byte; itmindex: integer; itmname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_TAKEONITEM, itmindex, where, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString (itmname));
end;

procedure TfrmMain.SendTakeOffItem (where: byte; itmindex: integer; itmname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_TAKEOFFITEM, itmindex, where, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString (itmname));
end;
//吃东西
procedure TfrmMain.SendEat (itmindex: integer; itmname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_EAT, itmindex, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString (itmname));
end;
//宰杀动物
procedure TfrmMain.SendButchAnimal (x, y, dir, actorid: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_BUTCH, actorid, x, y, dir);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendMagicKeyChange (magid: integer; keych: char);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_MAGICKEYCHANGE, magid, byte(keych), 0, 0);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendMerchantDlgSelect (merchant: integer; rstr: string);
var
   msg: TDefaultMessage;
   param: string;
begin
   if Length(rstr) >= 2 then begin  //颇扼皋鸥啊 鞘夸茄 版快啊 乐澜.
      if (rstr[1] = '@') and (rstr[2] = '@') then begin
         if rstr = '@@buildguildnow' then
            FrmDlg.DMessageDlg ('创建行会，请输入行会名称.', [mbOk, mbAbort])
         else FrmDlg.DMessageDlg ('行会名称.', [mbOk, mbAbort]);
         param := Trim (FrmDlg.DlgEditText);
         rstr := rstr + #13 + param;
      end;
   end;
   msg := MakeDefaultMsg (CM_MERCHANTDLGSELECT, merchant, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString (rstr));
end;
//询问物品价格
procedure TfrmMain.SendQueryPrice (merchant, itemindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_MERCHANTQUERYSELLPRICE, merchant, Loword(itemindex), Hiword(itemindex), 0);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;
 //询问修理价格
procedure TfrmMain.SendQueryRepairCost (merchant, itemindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_MERCHANTQUERYREPAIRCOST, merchant, Loword(itemindex), Hiword(itemindex), 0);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;
//发送要出售的物品
procedure TfrmMain.SendSellItem (merchant, itemindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERSELLITEM, merchant, Loword(itemindex), Hiword(itemindex), 0);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;
 //发送要修理的物品
procedure TfrmMain.SendRepairItem (merchant, itemindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERREPAIRITEM, merchant, Loword(itemindex), Hiword(itemindex), 0);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;
//发送要存放的物品
procedure TfrmMain.SendStorageItem (merchant, itemindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERSTORAGEITEM, merchant, Loword(itemindex), Hiword(itemindex), 0);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;

procedure TfrmMain.SendGetDetailItem (merchant, menuindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERGETDETAILITEM, merchant, menuindex, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;

procedure TfrmMain.SendBuyItem (merchant, itemserverindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERBUYITEM, merchant, Loword(itemserverindex), Hiword(itemserverindex), 0);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;

procedure TfrmMain.SendTakeBackStorageItem (merchant, itemserverindex: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERTAKEBACKSTORAGEITEM, merchant, Loword(itemserverindex), Hiword(itemserverindex), 0);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;

procedure TfrmMain.SendMakeDrugItem (merchant: integer; itemname: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_USERMAKEDRUGITEM, merchant, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString (itemname));
end;

procedure TfrmMain.SendDropGold (dropgold: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DROPGOLD, dropgold, 0, 0, 0);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendGroupMode (onoff: Boolean);
var
   msg: TDefaultMessage;
begin
   if onoff then
      msg := MakeDefaultMsg (CM_GROUPMODE, 0, 1, 0, 0)   //on
   else msg := MakeDefaultMsg (CM_GROUPMODE, 0, 0, 0, 0);  //off
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendCreateGroup (withwho: string);
var
   msg: TDefaultMessage;
begin
   if withwho <> '' then begin
      msg := MakeDefaultMsg (CM_CREATEGROUP, 0, 0, 0, 0);
      SendSocket (EncodeMessage (msg) + EncodeString (withwho));
   end;
end;

procedure TfrmMain.SendWantMiniMap;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_WANTMINIMAP, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendDealTry;
var
   msg: TDefaultMessage;
   i, fx, fy: integer;
   actor: TActor;
   who: string;
   proper: Boolean;
begin
   (*proper := FALSE;
   GetFrontPosition (Myself.XX, Myself.m_nCurrY, Myself.Dir, fx, fy);
   with PlayScene do
      for i:=0 to ActorList.Count-1 do begin
         actor := TActor (ActorList[i]);
         if {(actor.m_btRace = 0) and} (actor.XX = fx) and (actor.m_nCurrY = fy) then begin
            proper := TRUE;
            who := actor.UserName;
            break;
         end;
      end;
   if proper then begin*)
      msg := MakeDefaultMsg (CM_DEALTRY, 0, 0, 0, 0);
      SendSocket (EncodeMessage (msg) + EncodeString (who));
   //end;
end;

procedure TfrmMain.SendGuildDlg;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_OPENGUILDDLG, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendCancelDeal;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DEALCANCEL, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendAddDealItem (ci: TClientItem);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DEALADDITEM, ci.MakeIndex, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString (ci.S.Name));
end;

procedure TfrmMain.SendDelDealItem (ci: TClientItem);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DEALDELITEM, ci.MakeIndex, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString (ci.S.Name));
end;

procedure TfrmMain.SendChangeDealGold (gold: integer);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DEALCHGGOLD, gold, 0, 0, 0);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendDealEnd;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_DEALEND, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendAddGroupMember (withwho: string);
var
   msg: TDefaultMessage;
begin
   if withwho <> '' then begin
      msg := MakeDefaultMsg (CM_ADDGROUPMEMBER, 0, 0, 0, 0);
      SendSocket (EncodeMessage (msg) + EncodeString (withwho));
   end;
end;

procedure TfrmMain.SendDelGroupMember (withwho: string);
var
   msg: TDefaultMessage;
begin
   if withwho <> '' then begin
      msg := MakeDefaultMsg (CM_DELGROUPMEMBER, 0, 0, 0, 0);
      SendSocket (EncodeMessage (msg) + EncodeString (withwho));
   end;
end;

procedure TfrmMain.SendGuildHome;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_GUILDHOME, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendGuildMemberList;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_GUILDMEMBERLIST, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendGuildAddMem (who: string);
var
   msg: TDefaultMessage;
begin
   if Trim(who) <> '' then begin
      msg := MakeDefaultMsg (CM_GUILDADDMEMBER, 0, 0, 0, 0);
      SendSocket (EncodeMessage (msg) + EncodeString (who));
   end;
end;

procedure TfrmMain.SendGuildDelMem (who: string);
var
   msg: TDefaultMessage;
begin
   if Trim(who) <> '' then begin
      msg := MakeDefaultMsg (CM_GUILDDELMEMBER, 0, 0, 0, 0);
      SendSocket (EncodeMessage (msg) + EncodeString (who));
   end;
end;

procedure TfrmMain.SendGuildUpdateNotice (notices: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_GUILDUPDATENOTICE, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString (notices));
end;

procedure TfrmMain.SendGuildUpdateGrade (rankinfo: string);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_GUILDUPDATERANKINFO, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeString (rankinfo));
end;

procedure TfrmMain.SendSpeedHackUser;
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_SPEEDHACKUSER, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg));
end;

procedure TfrmMain.SendAdjustBonus (remain: integer; babil: TNakedAbility);
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_ADJUST_BONUS, remain, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeBuffer (@babil, sizeof(TNakedAbility)));
end;

procedure TfrmMain.SendPowerBlock();
var
   msg: TDefaultMessage;
begin
   msg := MakeDefaultMsg (CM_POWERBLOCK, 0, 0, 0, 0);
   SendSocket (EncodeMessage (msg) + EncodeBuffer (@g_PowerBlock, sizeof(TPowerBlock)));
end;
{---------------------------------------------------------------}


function  TfrmMain.ServerAcceptNextAction: Boolean;
begin
   Result := TRUE;
    //若服务器未响应动作命令，则10秒后自动解锁
   if ActionLock then begin
      if GetTickCount - ActionLockTime > 10 * 1000 then begin
         ActionLock := FALSE;
         //Dec (WarningLevel);
      end;
      Result := FALSE;
   end;
end;

function  TfrmMain.CanNextAction: Boolean;
begin
   if (g_MySelf.IsIdle) and
      (g_MySelf.m_nState and $04000000 = 0) and
      (GetTickCount - g_dwDizzyDelayStart > g_dwDizzyDelayTime)
   then begin
      Result := TRUE;
   end else
      Result := FALSE;
end;
//是否可以攻击，控制攻击速度
function  TfrmMain.CanNextHit: Boolean;
var
   NextHitTime, LevelFastTime:Integer;
begin
   LevelFastTime:= _MIN (370, (g_MySelf.m_Abil.Level * 14));
   LevelFastTime:= _MIN (800, LevelFastTime + g_MySelf.m_nHitSpeed * g_nItemSpeed{60});

   if g_boAttackSlow then
      NextHitTime:= g_nHitTime{1400} - LevelFastTime + 1500 //腕力超过时，减慢攻击速度
   else NextHitTime:= g_nHitTime{1400} - LevelFastTime;

   if NextHitTime < 0 then NextHitTime:= 0;

   if GetTickCount - LastHitTick > LongWord(NextHitTime) then begin
      LastHitTick:=GetTickCount;
      Result:=True;
   end else Result:=False;
end;

procedure TfrmMain.ActionFailed;
begin
   g_nTargetX := -1;
   g_nTargetY := -1;
   ActionFailLock := TRUE; //鞍篮 规氢栏肺 楷加捞悼角菩甫 阜扁困秦辑, FailDir苞 窃膊 荤侩
   ActionFailLockTime :=GetTickCount();//Jacky
   g_MySelf.MoveFail;
end;

function  TfrmMain.IsUnLockAction (action, adir: integer): Boolean;
begin
   if ActionFailLock then begin //如果操作被锁定，则在指定时间后解锁
     if GetTickCount() - ActionFailLockTime > 1000 then ActionFailLock:=False;
   end;
   if (ActionFailLock) or (g_boMapMoving) or (g_boServerChanging) then begin
      Result := FALSE;
   end else Result := TRUE;

{
   if (ActionFailLock and (action = FailAction) and (adir = FailDir))
      or (MapMoving)
      or (BoServerChanging) then begin
      Result := FALSE;
   end else begin
      ActionFailLock := FALSE;
      Result := TRUE;
   end;
}
end;

function TfrmMain.IsGroupMember (uname: string): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   for i:=0 to g_GroupMembers.Count-1 do
      if g_GroupMembers[i] = uname then begin
         Result := TRUE;
         break;
      end;
end;

{-------------------------------------------------------------}

procedure TfrmMain.Timer1Timer(Sender: TObject);
var
   str, data: string;
   len, i, n, mcnt : integer;
const
   busy: Boolean = FALSE;
begin
   if busy then exit;
   //if ServerConnected then
   //   DxTimer.Enabled := TRUE
   //else
   //   DxTimer.Enabled := FALSE;

   busy := TRUE;
   try
      BufferStr := BufferStr + SocStr;
      SocStr := '';
      if BufferStr <> '' then begin
         mcnt := 0;
         while Length(BufferStr) >= 2 do begin
            if g_boMapMovingWait then break; // 措扁..
            if Pos('!', BufferStr) <= 0 then break;
            BufferStr := ArrestStringEx (BufferStr, '#', '!', data);
            if data = '' then break;
            DecodeMessagePacket (data);
            if Pos('!', BufferStr) <= 0 then break;
         end;
      end;
   finally
      busy := FALSE;
   end;

   if WarningLevel > 30 then
      FrmMain.Close;

   if g_boQueryPrice then begin
      if GetTickCount - g_dwQueryPriceTime > 500 then begin
         g_boQueryPrice := FALSE;
         case FrmDlg.SpotDlgMode of
            dmSell: SendQueryPrice (g_nCurMerchant, g_SellDlgItem.MakeIndex, g_SellDlgItem.S.Name);
            dmRepair: SendQueryRepairCost (g_nCurMerchant, g_SellDlgItem.MakeIndex, g_SellDlgItem.S.Name);
         end;
      end;
   end;

   if g_nBonusPoint > 0 then begin
      FrmDlg.DBotPlusAbil.Visible := TRUE;
   end else begin
      FrmDlg.DBotPlusAbil.Visible := FALSE;
   end;

end;
 //速度作弊检测时钟事件(每秒4次）
//主要是检查系统时钟和CPU之间之间的差别
//若在一秒内连续四次修改系统中间，将可能出现速度作弊嫌疑
procedure TfrmMain.SpeedHackTimerTimer(Sender: TObject);
var
   gcount, timer: longword;
   ahour, amin, asec, amsec: word;
begin
   DecodeTime (Time, ahour, amin, asec, amsec);
   timer := ahour * 1000 * 60 * 60 + amin * 1000 * 60 + asec * 1000 + amsec;
   gcount := GetTickCount;
   if g_dwSHGetTime > 0 then begin
      if abs((gcount - g_dwSHGetTime) - (timer - g_dwSHTimerTime)) > 70 then begin
         Inc (g_nSHFakeCount);
      end else
         g_nSHFakeCount := 0;
      if g_nSHFakeCount > 4 then begin
         FrmDlg.DMessageDlg ('你有作弊嫌疑. CODE=10001\' +
                             '请与管理员联系.',
                             [mbOk]);
         FrmMain.Close;
      end;
      if g_boCheckSpeedHackDisplay then begin
         DScreen.AddSysMsg ('->' + IntToStr(gcount - g_dwSHGetTime) + ' - ' +
                                   IntToStr(timer - g_dwSHTimerTime) + ' = ' +
                                   IntToStr(abs((gcount - g_dwSHGetTime) - (timer - g_dwSHTimerTime))) + ' (' +
                                   IntToStr(g_nSHFakeCount) + ')');
      end;
   end;
   g_dwSHGetTime := gcount;
   g_dwSHTimerTime := timer;
end;

procedure TfrmMain.CheckSpeedHack (rtime: Longword);
var
   cltime, svtime: integer;
   str: string;
begin
   if g_dwFirstServerTime > 0 then begin
      if (GetTickCount - g_dwFirstClientTime) > 1 * 60 * 60 * 1000 then begin  //1矫埃 付促 檬扁拳
         g_dwFirstServerTime := rtime; //檬扁拳
         g_dwFirstClientTime := GetTickCount;
         //ServerTimeGap := rtime - int64(GetTickCount);
      end;
      cltime := GetTickCount - g_dwFirstClientTime;
      svtime := rtime - g_dwFirstServerTime + 3000;

      if cltime > svtime then begin
         Inc (g_nTimeFakeDetectCount);
         if g_nTimeFakeDetectCount > 6 then begin
            //矫埃炼累...
            str := 'Bad';
            //SendSpeedHackUser;
            FrmDlg.DMessageDlg ('存在作弊嫌疑. CODE=10000\' +
                                '将关闭游戏.\' +
                                '若有争议请与管理员联系.',
                                [mbOk]);
            FrmMain.Close;
         end;
      end else begin
         str := 'Good';
         g_nTimeFakeDetectCount := 0;
      end;
      if g_boCheckSpeedHackDisplay then begin
         DScreen.AddSysMsg (IntToStr(svtime) + ' - ' +
                            IntToStr(cltime) + ' = ' +
                            IntToStr(svtime-cltime) +
                            ' ' + str);
      end;
   end else begin
      g_dwFirstServerTime := rtime;
      g_dwFirstClientTime := GetTickCount;
      //ServerTimeGap := int64(GetTickCount) - longword(msg.Recog);
   end;
end;

procedure TfrmMain.DecodeMessagePacket (datablock: string);
var
   head, body, body2, tagstr, data, rdstr, str: String;
   msg : TDefaultMessage;
   smsg: TShortMessage;
   mbw: TMessageBodyW;
   desc: TCharDesc;
   wl: TMessageBodyWL;
   featureEx: word;
   L, i, j, n, BLKSize, param, sound, cltime, svtime: integer;
   tempb: boolean;
   actor: TActor;
   event: TClEvent;
begin

   if datablock[1] = '+' then begin  //checkcode
      data := Copy (datablock, 2, Length(datablock)-1);
      data := GetValidStr3 (data, tagstr, ['/']);
      if tagstr = 'PWR'  then g_boNextTimePowerHit := True;  //打开攻杀
      if tagstr = 'LNG'  then g_boCanLongHit := True;        //打开刺杀
      if tagstr = 'ULNG' then g_boCanLongHit := False;       //关闭刺杀
      if tagstr = 'WID'  then g_boCanWideHit := True;        //打开半月
      if tagstr = 'UWID' then g_boCanWideHit := False;       //关闭半月
      if tagstr = 'CRS'  then g_boCanCrsHit := True;
      if tagstr = 'UCRS' then g_boCanCrsHit := False;
      if tagstr = 'TWN'  then g_boCanTwnHit := True;
      if tagstr = 'UTWN' then g_boCanTwnHit := False;
      if tagstr = 'STN'  then g_boCanStnHit := True;
      if tagstr = 'USTN' then g_boCanStnHit := False;
      if tagstr = 'FIR'  then begin
         g_boNextTimeFireHit := TRUE;  //打开烈火
         g_dwLatestFireHitTick := GetTickCount;
         //Myself.SendMsg (SM_READYFIREHIT, Myself.XX, Myself.m_nCurrY, Myself.Dir, 0, 0, '', 0);
      end;
      if tagstr = 'UFIR' then g_boNextTimeFireHit := False; //关闭烈火
      if tagstr = 'GOOD' then begin
         ActionLock := FALSE;
         Inc(g_nReceiveCount);
      end;
      if tagstr = 'FAIL' then begin
         ActionFailed;
         ActionLock := FALSE;
         Inc(g_nReceiveCount);
      end;
      //DScreen.AddSysmsg (data);
      if data <> '' then begin
         CheckSpeedHack (Str_ToInt(data, 0));
      end;
      exit;
   end;
   if Length(datablock) < DEFBLOCKSIZE then begin
      if datablock[1] = '=' then begin
         data := Copy (datablock, 2, Length(datablock)-1);
         if data = 'DIG' then begin
            g_MySelf.m_boDigFragment := TRUE;
         end;
      end;
      exit;
   end;

   head := Copy (datablock, 1, DEFBLOCKSIZE);
   body := Copy (datablock, DEFBLOCKSIZE+1, Length(datablock)-DEFBLOCKSIZE);
   msg  := DecodeMessage (head);

   //DScreen.AddSysMsg (IntToStr(msg.Ident));

   if (msg.Ident <> SM_HEALTHSPELLCHANGED) and
      (msg.Ident <> SM_HEALTHSPELLCHANGED)
      then begin

     if g_boShowMemoLog then begin
       ShowHumanMsg(@Msg);
       //PlayScene.MemoLog.Lines.Add('Ident: ' + IntToStr(msg.Recog) + '/' + IntToStr(msg.Ident));
     end;
   end;
//   PlayScene.MemoLog.Lines.Add('datablock: ' + datablock);
   if g_MySelf = nil then begin
      case msg.Ident of
         SM_NEWID_SUCCESS:
            begin
               FrmDlg.DMessageDlg ('你的帐号已经建立了.\' +
                                   '请妥善保护好你的帐户和密码.\' +
                                   '请不要因任何原因把帐号和密码告诉其他人.\' +
                                   '我们的官方地址：,\' +
                                   '(http://www.******.net)', [mbOk]);
            end;
         SM_NEWID_FAIL:
            begin
               case msg.Recog of
                  0: begin
                        FrmDlg.DMessageDlg ('"' + MakeNewId + '"这个帐号已经被其他玩家使用了.\'  +
                                            ' 请使用一个不同的名字.',
                                           [mbOk]);
                        LoginScene.NewIdRetry (FALSE);  //促矫 矫档
                     end;
                  -2: FrmDlg.DMessageDlg ('建立帐号失败，系统正忙.\有关信息请访问: http://www.******.com', [mbOk]);
                  else FrmDlg.DMessageDlg ('帐号创建失败，请确认帐号是否包括空格、及非法字符！Code: ' + IntToStr(msg.Recog), [mbOk]);
               end;
            end;
         SM_PASSWD_FAIL:
            begin
               case msg.Recog of
                  -1: FrmDlg.DMessageDlg ('密码错误！！', [mbOk]);
                  -2: FrmDlg.DMessageDlg ('密码输入错误超过3次，此帐号被暂时锁定，请稍候再登录！', [mbOk]);
                  -3: FrmDlg.DMessageDlg ('此帐号已经登录或被异常锁定，请稍候再登录！', [mbOk]);
                  -4: FrmDlg.DMessageDlg ('这个帐号访问失败！\请使用其他帐号登录，\或者申请付费注册。', [mbOk]);
                  -5: FrmDlg.DMessageDlg ('这个帐号被锁定！', [mbOk]);
                  else  FrmDlg.DMessageDlg ('ID不存在或未知错误.请稍后再试.', [mbOk]);
               end;
               LoginScene.PassWdFail;
            end;
         SM_NEEDUPDATE_ACCOUNT: //拌沥 沥焊甫 促矫 涝仿窍扼.
            begin
               ClientGetNeedUpdateAccount (body);
            end;
         SM_UPDATEID_SUCCESS:
            begin
               FrmDlg.DMessageDlg ('您的帐号信息更新成功。\' +
                                   '请妥善保管您的帐号和密码。\' +
                                   '并且不要因任何原因把帐号和密码告诉任何其他人。\\' +
                                   '如果您忘记您的密码，您能通过我们的主页找回它.\(http://www.******.net)', [mbOk]);
               ClientGetSelectServer;
            end;
         SM_UPDATEID_FAIL:
            begin
               FrmDlg.DMessageDlg ('更新帐号失败.', [mbOk]);
               ClientGetSelectServer;
            end;
         SM_PASSOK_SELECTSERVER: begin
           ClientGetPasswordOK(msg,body);
         end;
         SM_SELECTSERVER_OK: begin
           ClientGetPasswdSuccess (body);
         end;
         SM_QUERYCHR: begin
           ClientGetReceiveChrs (body);
         end;
         SM_QUERYCHR_FAIL: begin
           g_boDoFastFadeOut := FALSE;
           g_boDoFadeIn := FALSE;
           g_boDoFadeOut := FALSE;
           FrmDlg.DMessageDlg ('获取角色信息失败，游戏将结束.', [mbOk]);
           Close;
         end;
         SM_NEWCHR_SUCCESS: begin
           SendQueryChr;
         end;
         SM_NEWCHR_FAIL: begin
           case msg.Recog of
             0: FrmDlg.DMessageDlg ('[错误] 输入的角色名称包含非法字符!', [mbOk]);
             2: FrmDlg.DMessageDlg ('[错误] 创建角色名称已被其他人使用!', [mbOk]);
             3: FrmDlg.DMessageDlg ('[错误] 您只能创建二个游戏角色!', [mbOk]);
             4: FrmDlg.DMessageDlg ('[错误] 创建角色时出现错误！ 错误代码 = 4', [mbOk]);
             else FrmDlg.DMessageDlg ('[错误] 创建角色时出现未知错误！', [mbOk]);
           end;
         end;
         SM_CHGPASSWD_SUCCESS: begin
           FrmDlg.DMessageDlg ('当前密码更改成功.', [mbOk]);
         end;
         SM_CHGPASSWD_FAIL: begin
           case msg.Recog of
             -1: FrmDlg.DMessageDlg ('密码修改错误.请确认原密码在进行修改.', [mbOk]);
             -2: FrmDlg.DMessageDlg ('密码修改失败.新密码不一致.', [mbOk]);
             else FrmDlg.DMessageDlg ('密码修改错误.请稍后再试.', [mbOk]);
           end;
         end;
         SM_DELCHR_SUCCESS: begin
           SendQueryChr;
         end;
         SM_DELCHR_FAIL: begin
           FrmDlg.DMessageDlg ('[错误] 删除角色失败，请联系管理员. Email: 18382915@qq.com', [mbOk]);
         end;
         SM_STARTPLAY: begin
           ClientGetStartPlay (body);
           exit;
         end;
         SM_STARTFAIL: begin
           FrmDlg.DMessageDlg ('此服务器满员！', [mbOk]);
//               FrmMain.Close;
//               frmSelMain.Close;
           ClientGetSelectServer();
           exit;
         end;
         SM_VERSION_FAIL: begin
           FrmDlg.DMessageDlg ('游戏版本和服务器版本不一致，请及时更新，\详情请访问官方网站. (http://www.legendofmir.net)', [mbOk]);
//               FrmMain.Close;
//               frmSelMain.Close;
           exit;
         end;
         SM_OUTOFCONNECTION,
         SM_NEWMAP,
         SM_LOGON,
         SM_RECONNECT,
         SM_SENDNOTICE: ;  //酒贰俊辑 贸府
         else
            exit;
      end;
   end;
   if g_boMapMoving then begin
      if msg.Ident = SM_CHANGEMAP then begin
         WaitingMsg := msg;
         WaitingStr := DecodeString (body);
         g_boMapMovingWait := TRUE;
         WaitMsgTimer.Enabled := TRUE;
      end;
      exit;
   end;

  case msg.Ident of
    //Damian
    SM_VERSION_FAIL: begin
      i := MakeLong(msg.Param,msg.Tag);
      DecodeBuffer (body, @j, sizeof(Integer));
      if (msg.Recog <> g_nThisCRC) and
         (i <> g_nThisCRC) and
         (j <> g_nThisCRC) then begin
         //下面3行是登陆锁定
        //FrmDlg.DMessageDlg ('错误版本。 请下载最新的版本 .', [mbOk]);
        //DScreen.AddChatBoardString ('错误版本。 请下载最新的版本 .', clYellow, clRed);
        //CSocket.Close;

//        FrmMain.Close;
//        frmSelMain.Close;
        exit;
        {FrmDlg.DMessageDlg ('Wrong version. Please download latest version. (http://www.legendofmir.net)', [mbOk]);
        Close;
        exit;}
      end;
    end;
      SM_NEWMAP: begin
        g_sMapTitle := '';
        str := DecodeString (body); //mapname
//        PlayScene.MemoLog.Lines.Add('X: ' + IntToStr(msg.Param) + 'Y: ' + IntToStr(msg.tag) + ' Map: ' + str);
        PlayScene.SendMsg (SM_NEWMAP, 0,
                           msg.Param{x},
                           msg.tag{y},
                           msg.Series{darkness},
                           0, 0,
                           str{mapname});
      end;

      SM_LOGON: begin
        g_dwFirstServerTime := 0;
        g_dwFirstClientTime := 0;
        with msg do begin
          DecodeBuffer (body, @wl, sizeof(TMessageBodyWL));
          PlayScene.SendMsg (SM_LOGON, msg.Recog,
                             msg.Param{x},
                             msg.tag{y},
                             msg.Series{dir},
                             wl.lParam1, //desc.Feature,
                             wl.lParam2, //desc.Status,
                             '');
          DScreen.ChangeScene (stPlayGame);
          SendClientMessage (CM_QUERYBAGITEMS, 0, 0, 0, 0);
          if Lobyte(Loword(wl.lTag1)) = 1 then g_boAllowGroup := TRUE
          else g_boAllowGroup := FALSE;
          g_boServerChanging := FALSE;
        end;
        if g_wAvailIDDay > 0 then begin
          DScreen.AddChatBoardString ('您当前通过包月帐号充值', clGreen, clWhite)
        end else if g_wAvailIPDay > 0 then begin
          DScreen.AddChatBoardString ('您当前通过包月IP 充值。', clGreen, clWhite)
        end else if g_wAvailIPHour > 0 then begin
          DScreen.AddChatBoardString ('您当前通过计时IP 充值。', clGreen, clWhite)
        end else if g_wAvailIDHour > 0 then begin
          DScreen.AddChatBoardString ('您当前通过计时帐号充值。', clGreen, clWhite)
        end;
        LoadUserConfig(CharName);
        //DScreen.AddChatBoardString ('当前服务器信息: ' + g_sRunServerAddr + ':' + IntToStr(g_nRunServerPort), clGreen, clWhite)
      end;
      SM_SERVERCONFIG: ClientGetServerConfig(Msg,Body);

      SM_RECONNECT: begin
        ClientGetReconnect (body);
      end;
      SM_TIMECHECK_MSG:
         begin
            CheckSpeedHack (msg.Recog);
         end;

      SM_AREASTATE:
         begin
            g_nAreaStateValue := msg.Recog;
         end;

      SM_MAPDESCRIPTION: begin
        ClientGetMapDescription(Msg,body);
      end;
      SM_GAMEGOLDNAME: begin
        ClientGetGameGoldName(msg,body);
      end;
      SM_ADJUST_BONUS: begin
        ClientGetAdjustBonus (msg.Recog, body);
      end;
      SM_MYSTATUS: begin
        g_nMyHungryState:=msg.Param;
      end;

      SM_TURN:
         begin
            if Length(body) > GetCodeMsgSize(sizeof(TCharDesc)*4/3) then begin
               Body2 := Copy (Body, GetCodeMsgSize(sizeof(TCharDesc)*4/3)+1, Length(body));
               data := DecodeString (body2); //某腐 捞抚
               str := GetValidStr3 (data, data, ['/']);
               //data = 捞抚
               //str = 祸哎
            end else data := '';
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            PlayScene.SendMsg (SM_TURN, msg.Recog,
                                 msg.Param{x},
                                 msg.tag{y},
                                 msg.Series{dir + light},
                                 desc.Feature,
                                 desc.Status,
                                 ''); //捞抚
            if data <> '' then begin
               actor := PlayScene.FindActor (msg.Recog);
               if actor <> nil then begin
                  actor.m_sDescUserName := GetValidStr3(data, actor.m_sUserName, ['\']);
                  //actor.UserName := data;
                  actor.m_nNameColor := GetRGB(Str_ToInt(str, 0));
               end;
            end;
         end;

      SM_BACKSTEP:
         begin
            if Length(body) > GetCodeMsgSize(sizeof(TCharDesc)*4/3) then begin
               Body2 := Copy (Body, GetCodeMsgSize(sizeof(TCharDesc)*4/3)+1, Length(body));
               data := DecodeString (body2); //某腐 捞抚
               str := GetValidStr3 (data, data, ['/']);
               //data = 捞抚
               //str = 祸哎
            end else data := '';
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            PlayScene.SendMsg (SM_BACKSTEP, msg.Recog,
                                 msg.Param{x},
                                 msg.tag{y},
                                 msg.Series{dir + light},
                                 desc.Feature,
                                 desc.Status,
                                 ''); //捞抚
            if data <> '' then begin
               actor := PlayScene.FindActor (msg.Recog);
               if actor <> nil then begin
                  actor.m_sDescUserName := GetValidStr3(data, actor.m_sUserName, ['\']);
                  //actor.UserName := data;
                  actor.m_nNameColor := GetRGB(Str_ToInt(str, 0));
               end;
            end;
         end;

      SM_SPACEMOVE_HIDE,
      SM_SPACEMOVE_HIDE2:
         begin
            if msg.Recog <> g_MySelf.m_nRecogId then begin
               PlayScene.SendMsg (msg.Ident, msg.Recog, msg.Param{x}, msg.tag{y}, 0, 0, 0, '')
            end;
         end;

      SM_SPACEMOVE_SHOW,
      SM_SPACEMOVE_SHOW2:
         begin
            if Length(body) > GetCodeMsgSize(sizeof(TCharDesc)*4/3) then begin
               Body2 := Copy (Body, GetCodeMsgSize(sizeof(TCharDesc)*4/3)+1, Length(body));
               data := DecodeString (body2); //某腐 捞抚
               str := GetValidStr3 (data, data, ['/']);
               //data = 捞抚
               //str = 祸哎
            end else data := '';
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            if msg.Recog <> g_MySelf.m_nRecogId then begin //促弗 某腐磐牢 版快
              PlayScene.NewActor (msg.Recog, msg.Param, msg.tag, msg.Series, desc.feature, desc.Status);
            end;
            PlayScene.SendMsg (msg.Ident, msg.Recog,
                                 msg.Param{x},
                                 msg.tag{y},
                                 msg.Series{dir + light},
                                 desc.Feature,
                                 desc.Status,
                                 ''); //捞抚
            if data <> '' then begin
               actor := PlayScene.FindActor (msg.Recog);
               if actor <> nil then begin
                  actor.m_sDescUserName := GetValidStr3(data, actor.m_sUserName, ['\']);
                  //actor.UserName := data;
                  actor.m_nNameColor := GetRGB(Str_ToInt(str, 0));
               end;
            end;
         end;

      SM_WALK, SM_RUSH, SM_RUSHKUNG:
         begin
            //DScreen.AddSysMsg ('WALK ' + IntToStr(msg.Param) + ':' + IntToStr(msg.Tag));
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            if (msg.Recog <> g_MySelf.m_nRecogId) or (msg.Ident = SM_RUSH) or (msg.Ident = SM_RUSHKUNG) then
               PlayScene.SendMsg (msg.Ident, msg.Recog,
                                 msg.Param{x},
                                 msg.tag{y},
                                 msg.Series{dir+light},
                                 desc.Feature,
                                 desc.Status, '');
            if msg.Ident = SM_RUSH then
               g_dwLatestRushRushTick := GetTickCount;                      
         end;

      SM_RUN,SM_HORSERUN:
         begin
            //DScreen.AddSysMsg ('RUN ' + IntToStr(msg.Param) + ':' + IntToStr(msg.Tag));
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            if msg.Recog <> g_MySelf.m_nRecogId then
               PlayScene.SendMsg (msg.Ident, msg.Recog,
                                    msg.Param{x},
                                    msg.tag{y},
                                    msg.Series{dir+light},
                                    desc.Feature,
                                    desc.Status, '');
               (*
               PlayScene.SendMsg (SM_RUN, msg.Recog,
                                    msg.Param{x},
                                    msg.tag{y},
                                    msg.Series{dir+light},
                                    desc.Feature,
                                    desc.Status, '');
               *)
         end;

      SM_CHANGELIGHT://游戏亮度
         begin
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.m_nChrLight := msg.Param;
            end;
         end;

      SM_LAMPCHANGEDURA:
         begin
            if g_UseItems[U_RIGHTHAND].S.Name <> '' then begin
               g_UseItems[U_RIGHTHAND].Dura := msg.Recog;
            end;
         end;

      SM_MOVEFAIL: begin
        ActionFailed;
        DecodeBuffer (body, @desc, sizeof(TCharDesc));
        PlayScene.SendMsg (SM_TURN, msg.Recog,
                                 msg.Param{x},
                                 msg.tag{y},
                                 msg.Series{dir},
                                 desc.Feature,
                                 desc.Status, '');
      end;
      SM_BUTCH:
         begin
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            if msg.Recog <> g_MySelf.m_nRecogId then begin
               actor := PlayScene.FindActor (msg.Recog);
               if actor <> nil then
                  actor.SendMsg (SM_SITDOWN,
                                    msg.Param{x},
                                    msg.tag{y},
                                    msg.Series{dir},
                                    0, 0, '', 0);
            end;
         end;
      SM_SITDOWN:
         begin
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            if msg.Recog <> g_MySelf.m_nRecogId then begin
               actor := PlayScene.FindActor (msg.Recog);
               if actor <> nil then
                  actor.SendMsg (SM_SITDOWN,
                                    msg.Param{x},
                                    msg.tag{y},
                                    msg.Series{dir},
                                    0, 0, '', 0);
            end;
         end;

      SM_HIT,           //14
      SM_HEAVYHIT,      //15
      SM_POWERHIT,      //18
      SM_LONGHIT,       //19
      SM_WIDEHIT,       //24
      SM_BIGHIT,        //16
      SM_FIREHIT,       //8
      SM_CRSHIT,
      SM_TWINHIT:
         begin
            if msg.Recog <> g_MySelf.m_nRecogId then begin
               actor := PlayScene.FindActor (msg.Recog);
               if actor <> nil then begin
                  actor.SendMsg (msg.Ident,
                                    msg.Param{x},
                                    msg.tag{y},
                                    msg.Series{dir},
                                    0, 0, '',
                                    0);
                  if msg.ident = SM_HEAVYHIT then begin
                     if body <> '' then
                        actor.m_boDigFragment := TRUE;
                  end;
               end;
            end;
         end;
      SM_FLYAXE:
         begin
            DecodeBuffer (body, @mbw, sizeof(TMessageBodyW));
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.SendMsg (msg.Ident,
                                 msg.Param{x},
                                 msg.tag{y},
                                 msg.Series{dir},
                                 0, 0, '',
                                 0);
               actor.m_nTargetX := mbw.Param1;  //x 带瘤绰 格钎
               actor.m_nTargetY := mbw.Param2;    //y
               actor.m_nTargetRecog := MakeLong(mbw.Tag1, mbw.Tag2);
            end;
         end;

      SM_LIGHTING:
         begin
            DecodeBuffer (body, @wl, sizeof(TMessageBodyWL));
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.SendMsg (msg.Ident,
                                 msg.Param{x},
                                 msg.tag{y},
                                 msg.Series{dir},
                                 0, 0, '',
                                 0);
               actor.m_nTargetX := wl.lParam1;  //x 带瘤绰 格钎
               actor.m_nTargetY := wl.lParam2;    //y
               actor.m_nTargetRecog := wl.lTag1;
               actor.m_nMagicNum := wl.lTag2;   //付过 锅龋
            end;
         end;

      SM_SPELL: begin
        UseMagicSpell (msg.Recog{who}, msg.Series{effectnum}, msg.Param{tx}, msg.Tag{y}, Str_ToInt(body,0));
      end;
      SM_MAGICFIRE: begin
        DecodeBuffer (body, @param, sizeof(integer));
        UseMagicFire (msg.Recog{who}, Lobyte(msg.Series){efftype}, Hibyte(msg.Series){effnum}, msg.Param{tx}, msg.Tag{y}, param);
        //Lobyte(msg.Series) = EffectType
        //Hibyte(msg.Series) = Effect
      end;
      SM_MAGICFIRE_FAIL:
         begin
            UseMagicFireFail (msg.Recog{who});
         end;


      SM_OUTOFCONNECTION:
         begin
            g_boDoFastFadeOut := FALSE;
            g_boDoFadeIn := FALSE;
            g_boDoFadeOut := FALSE;
            FrmDlg.DMessageDlg ('超出服务器连接最大限制.\' +
                                '你不得不退出游戏，抱歉.', [mbOk]);
            Close;
         end;

      SM_DEATH,
      SM_NOWDEATH:
         begin
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.SendMsg (msg.Ident,
                              msg.param{x}, msg.Tag{y}, msg.Series{damage},
                              desc.Feature, desc.Status, '',
                              0);
               actor.m_Abil.HP := 0;
            end else begin
               PlayScene.SendMsg (SM_DEATH, msg.Recog, msg.param{x}, msg.Tag{y}, msg.Series{damage}, desc.Feature, desc.Status, '');
            end;
         end;
      SM_SKELETON:
         begin
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            PlayScene.SendMsg (SM_SKELETON, msg.Recog, msg.param{HP}, msg.Tag{maxHP}, msg.Series{damage}, desc.Feature, desc.Status, '');
         end;
      SM_ALIVE:
         begin
            DecodeBuffer (body, @desc, sizeof(TCharDesc));
            PlayScene.SendMsg (SM_ALIVE, msg.Recog, msg.param{HP}, msg.Tag{maxHP}, msg.Series{damage}, desc.Feature, desc.Status, '');
         end;

      SM_ABILITY:
         begin
            g_MySelf.m_nGold := msg.Recog;
            g_MySelf.m_btJob := msg.Param;
            g_MySelf.m_nGameGold:=MakeLong(msg.Tag,msg.Series);
            DecodeBuffer (body, @g_MySelf.m_Abil, sizeof(TAbility));
         end;

      SM_SUBABILITY: begin
        g_nMyHitPoint      := Lobyte(Msg.Param);
        g_nMySpeedPoint    := Hibyte(Msg.Param);
        g_nMyAntiPoison    := Lobyte(Msg.Tag);
        g_nMyPoisonRecover := Hibyte(Msg.Tag);
        g_nMyHealthRecover := Lobyte(Msg.Series);
        g_nMySpellRecover  := Hibyte(Msg.Series);
        g_nMyAntiMagic     := LoByte(LongWord(Msg.Recog));
      end;

      SM_DAYCHANGING:
         begin
            g_nDayBright := msg.Param;
            DarkLevel := msg.Tag;
            if DarkLevel = 0 then g_boViewFog := FALSE
            else g_boViewFog := TRUE;
         end;

      SM_WINEXP:
         begin
            g_MySelf.m_Abil.Exp := msg.Recog; //坷弗 版氰摹
//            DScreen.AddSysMsg ('已获得 ' + IntToStr(LongWord(MakeLong(msg.Param,msg.Tag))) + ' 点经验值。');
            DScreen.AddChatBoardString ('已获得 ' + IntToStr(LongWord(MakeLong(msg.Param,msg.Tag))) + ' 点经验值..',clWhite, clRed);
         end;

      SM_LEVELUP:
         begin
            g_MySelf.m_Abil.Level:=msg.Param;
            DScreen.AddSysMsg ('恭喜！你升级了!');
            DScreen.AddChatBoardString ('祝贺! 您的水平上升。 您的生命值， 魔法值全部增加。',clWhite, clPurple);
         end;

      SM_HEALTHSPELLCHANGED: begin
        Actor := PlayScene.FindActor (msg.Recog);
        if Actor <> nil then begin
          Actor.m_Abil.HP    := msg.Param;
          Actor.m_Abil.MP    := msg.Tag;
          Actor.m_Abil.MaxHP := msg.Series;
        end;
      end;

      SM_STRUCK:
         begin
            //wl: TMessageBodyWL;
            DecodeBuffer (body, @wl, sizeof(TMessageBodyWL));
            Actor := PlayScene.FindActor (msg.Recog);
            if Actor <> nil then begin
               if Actor = g_MySelf then begin
                  if g_MySelf.m_nNameColor = 249 then //弧盎捞绰 嘎栏搁 立加阑 给 谗绰促.
                     g_dwLatestStruckTick := GetTickCount;
               end else begin
                  if Actor.CanCancelAction then
                     Actor.CancelAction;
               end;
               Actor.UpdateMsg (SM_STRUCK, wl.lTag2, 0,
                           msg.Series{damage}, wl.lParam1, wl.lParam2,
                           '', wl.lTag1{锭赴仇酒捞叼});
               Actor.m_Abil.HP := msg.param;
               Actor.m_Abil.MaxHP := msg.Tag;
            end;
         end;

      SM_CHANGEFACE:
         begin
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               DecodeBuffer (body, @desc, sizeof(TCharDesc));
               actor.m_nWaitForRecogId := MakeLong(msg.Param, msg.Tag);
               actor.m_nWaitForFeature := desc.Feature;
               actor.m_nWaitForStatus := desc.Status;
               AddChangeFace (actor.m_nWaitForRecogId);
            end;
         end;
      SM_PASSWORD: begin
        //PlayScene.EdChat.PasswordChar:='*';
        SetInputStatus();
      end;
      SM_OPENHEALTH:
         begin
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               if actor <> g_MySelf then begin
                  actor.m_Abil.HP := msg.Param;
                  actor.m_Abil.MaxHP := msg.Tag;
               end;
               actor.m_boOpenHealth := TRUE;
               //actor.OpenHealthTime := 999999999;
               //actor.OpenHealthStart := GetTickCount;
            end;
         end;
      SM_CLOSEHEALTH:
         begin
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.m_boOpenHealth := FALSE;   
            end;
         end;
      SM_INSTANCEHEALGUAGE:
         begin
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.m_Abil.HP := msg.param;
               actor.m_Abil.MaxHP := msg.Tag;
               actor.m_noInstanceOpenHealth := TRUE;
               actor.m_dwOpenHealthTime := 2 * 1000;
               actor.m_dwOpenHealthStart := GetTickCount;
            end;
         end;

      SM_BREAKWEAPON:
         begin
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               if actor is THumActor then
                  THumActor(actor).DoWeaponBreakEffect;
            end;
         end;

      SM_CRY,
      SM_GROUPMESSAGE,//   弊缝 皋技瘤
      SM_GUILDMESSAGE,
      SM_WHISPER,
      SM_SYSMESSAGE:  //系统消息
         begin
            str := DecodeString (body);
            DScreen.AddChatBoardString (str, GetRGB(Lobyte(msg.Param)), GetRGB(Hibyte(msg.Param)));
            if msg.Ident = SM_GUILDMESSAGE then
               FrmDlg.AddGuildChat (str);
         end;

      SM_HEAR:
         begin
            str := DecodeString (body);
            DScreen.AddChatBoardString (str, GetRGB(Lobyte(msg.Param)), GetRGB(Hibyte(msg.Param)));
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then
               actor.Say (str);
         end;

      SM_USERNAME:
         begin
            str := DecodeString (body);
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.m_sDescUserName := GetValidStr3(str, actor.m_sUserName, ['\']);
               //actor.UserName := str;
               actor.m_nNameColor := GetRGB (msg.Param);
            end;
         end;
      SM_CHANGENAMECOLOR:
         begin
            actor := PlayScene.FindActor (msg.Recog);
            if actor <> nil then begin
               actor.m_nNameColor := GetRGB (msg.Param);
            end;
         end;

      SM_HIDE,
      SM_GHOST,  //儡惑..
      SM_DISAPPEAR:
         begin
            if g_MySelf.m_nRecogId <> msg.Recog then
               PlayScene.SendMsg (SM_HIDE, msg.Recog, msg.Param{x}, msg.tag{y}, 0, 0, 0, '');
         end;

      SM_DIGUP:
         begin
            DecodeBuffer (body, @wl, sizeof(TMessageBodyWL));
            actor := PlayScene.FindActor (msg.Recog);
            if actor = nil then
               actor := PlayScene.NewActor (msg.Recog, msg.Param, msg.tag, msg.Series, wl.lParam1, wl.lParam2);
            actor.m_nCurrentEvent := wl.lTag1;
            actor.SendMsg (SM_DIGUP,
                           msg.Param{x},
                           msg.tag{y},
                           msg.Series{dir + light},
                           wl.lParam1,
                           wl.lParam2, '', 0);
         end;
      SM_DIGDOWN:
         begin
            PlayScene.SendMsg (SM_DIGDOWN, msg.Recog, msg.Param{x}, msg.tag{y}, 0, 0, 0, '');
         end;
      SM_SHOWEVENT:
         begin
            DecodeBuffer (body, @smsg, sizeof(TShortMessage));
            event := TClEvent.Create (msg.Recog, Loword(msg.Tag){x}, msg.Series{y}, msg.Param{e-type});
            event.m_nDir := 0;
            event.m_nEventParam := smsg.Ident;
            EventMan.AddEvent (event);  //clvent啊 Free瞪 荐 乐澜
         end;
      SM_HIDEEVENT:
         begin
            EventMan.DelEventById (msg.Recog);
         end;

      //Item ??
      SM_ADDITEM:
         begin
            ClientGetAddItem (body);
         end;
      SM_BAGITEMS:
         begin
            ClientGetBagItmes (body);
         end;
      SM_UPDATEITEM:
         begin
            ClientGetUpdateItem (body);
         end;
      SM_DELITEM:
         begin
            ClientGetDelItem (body);
         end;
      SM_DELITEMS:
         begin
            ClientGetDelItems (body);
         end;

      SM_DROPITEM_SUCCESS:
         begin
            DelDropItem (DecodeString(body), msg.Recog);
         end;
      SM_DROPITEM_FAIL:
         begin
            ClientGetDropItemFail (DecodeString(body), msg.Recog);
         end;

      SM_ITEMSHOW       :ClientGetShowItem (msg.Recog, msg.param{x}, msg.Tag{y}, msg.Series{looks}, DecodeString(body));
      SM_ITEMHIDE       :ClientGetHideItem (msg.Recog, msg.param, msg.Tag);
      SM_OPENDOOR_OK    :Map.OpenDoor (msg.param, msg.tag);
      SM_OPENDOOR_LOCK  :DScreen.AddSysMsg ('门已经上了锁.');
      SM_CLOSEDOOR      :Map.CloseDoor (msg.param, msg.tag);

      SM_TAKEON_OK:
         begin
            g_MySelf.m_nFeature := msg.Recog;
            g_MySelf.FeatureChanged;
            if g_WaitingUseItem.Index in [0..12] then
               g_UseItems[g_WaitingUseItem.Index] := g_WaitingUseItem.Item;
            g_WaitingUseItem.Item.S.Name := '';
         end;
      SM_TAKEON_FAIL:
         begin
            AddItemBag (g_WaitingUseItem.Item);
            g_WaitingUseItem.Item.S.Name := '';
         end;
      SM_TAKEOFF_OK:
         begin
            g_MySelf.m_nFeature := msg.Recog;
            g_MySelf.FeatureChanged;
            g_WaitingUseItem.Item.S.Name := '';
         end;
      SM_TAKEOFF_FAIL:
         begin
            if g_WaitingUseItem.Index < 0 then begin
               n := -(g_WaitingUseItem.Index+1);
               g_UseItems[n] := g_WaitingUseItem.Item;
            end;
            g_WaitingUseItem.Item.S.Name := '';
         end;
      SM_EXCHGTAKEON_OK:       ;
      SM_EXCHGTAKEON_FAIL:     ;

      SM_SENDUSEITEMS:
         begin
            ClientGetSenduseItems (body);
         end;
      SM_WEIGHTCHANGED:
         begin
            g_MySelf.m_Abil.Weight := msg.Recog;
            g_MySelf.m_Abil.WearWeight := msg.Param;
            g_MySelf.m_Abil.HandWeight := msg.Tag;
         end;
      SM_GOLDCHANGED:
         begin
            SoundUtil.PlaySound (s_money);
            if msg.Recog > g_MySelf.m_nGold then begin
               DScreen.AddSysMsg (IntToStr(msg.Recog-g_MySelf.m_nGold) + ' ' + g_sGoldName + ' 金币.');
            end;
            g_MySelf.m_nGold := msg.Recog;
            g_MySelf.m_nGameGold:=MakeLong(msg.Param,msg.Tag);
         end;
      SM_FEATURECHANGED: begin
        PlayScene.SendMsg (msg.Ident, msg.Recog, 0, 0, 0, MakeLong(msg.Param, msg.Tag), MakeLong(msg.Series,0), '');
      end;
      SM_CHARSTATUSCHANGED: begin
        PlayScene.SendMsg (msg.Ident, msg.Recog, 0, 0, 0, MakeLong(msg.Param, msg.Tag), msg.Series, '');
      end;
      SM_CLEAROBJECTS:
         begin
            PlayScene.CleanObjects;
            g_boMapMoving := TRUE; //
         end;

      SM_EAT_OK:
         begin
            g_EatingItem.S.Name := '';
            ArrangeItembag;
         end;
      SM_EAT_FAIL:
         begin
            AddItemBag (g_EatingItem);
            g_EatingItem.S.Name := '';
         end;

      SM_ADDMAGIC:
         begin
            if body <> '' then
               ClientGetAddMagic (body);
         end;
      SM_SENDMYMAGIC: if body <> '' then ClientGetMyMagics (body);

      SM_DELMAGIC:
         begin
            ClientGetDelMagic (msg.Recog);
         end;
      SM_MAGIC_LVEXP:
         begin
            ClientGetMagicLvExp (msg.Recog{magid}, msg.Param{lv}, MakeLong(msg.Tag, msg.Series));
         end;
      SM_DURACHANGE:
         begin
            ClientGetDuraChange (msg.Param{useitem index}, msg.Recog, MakeLong(msg.Tag, msg.Series));
         end;

      SM_MERCHANTSAY:
         begin
            ClientGetMerchantSay (msg.Recog, msg.Param, DecodeString (body));
         end;
      SM_MERCHANTDLGCLOSE:
         begin
            FrmDlg.CloseMDlg;
         end;
      SM_SENDGOODSLIST:
         begin
            ClientGetSendGoodsList (msg.Recog, msg.Param, body);
         end;
      SM_SENDUSERMAKEDRUGITEMLIST:
         begin
            ClientGetSendMakeDrugList (msg.Recog, body);
         end;
      SM_SENDUSERSELL:
         begin
            ClientGetSendUserSell (msg.Recog);
         end;
      SM_SENDUSERREPAIR:
         begin
            ClientGetSendUserRepair (msg.Recog);
         end;
      SM_SENDBUYPRICE:
         begin
            if g_SellDlgItem.S.Name <> '' then begin
               if msg.Recog > 0 then
                  g_sSellPriceStr := IntToStr(msg.Recog) + ' ' + g_sGoldName{金币'}
               else g_sSellPriceStr := '???? ' + g_sGoldName{金币'};
            end;
         end;
      SM_USERSELLITEM_OK:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            g_MySelf.m_nGold := msg.Recog;
            g_SellDlgItemSellWait.S.Name := '';
         end;

      SM_USERSELLITEM_FAIL:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            AddItemBag (g_SellDlgItemSellWait);
            g_SellDlgItemSellWait.S.Name := '';
            FrmDlg.DMessageDlg ('你不能卖这个物品.', [mbOk]);
         end;

      SM_SENDREPAIRCOST:
         begin
            if g_SellDlgItem.S.Name <> '' then begin
               if msg.Recog >= 0 then
                  g_sSellPriceStr := IntToStr(msg.Recog) + ' ' + g_sGoldName{金币}
               else g_sSellPriceStr := '????' + g_sGoldName{金币};
            end;
         end;
      SM_USERREPAIRITEM_OK:
         begin
            if g_SellDlgItemSellWait.S.Name <> '' then begin
               FrmDlg.LastestClickTime := GetTickCount;
               g_MySelf.m_nGold := msg.Recog;
               g_SellDlgItemSellWait.Dura := msg.Param;
               g_SellDlgItemSellWait.DuraMax := msg.Tag;
               AddItemBag (g_SellDlgItemSellWait);
               g_SellDlgItemSellWait.S.Name := '';
            end;
         end;
      SM_USERREPAIRITEM_FAIL:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            AddItemBag (g_SellDlgItemSellWait);
            g_SellDlgItemSellWait.S.Name := '';
            FrmDlg.DMessageDlg ('你不能修理该物品.', [mbOk]);
         end;
      SM_STORAGE_OK,
      SM_STORAGE_FULL,
      SM_STORAGE_FAIL:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            if msg.Ident <> SM_STORAGE_OK then begin
               if msg.Ident = SM_STORAGE_FULL then
                  FrmDlg.DMessageDlg ('仓库已满.请取出在放..', [mbOk])
               else
                  FrmDlg.DMessageDlg ('保管失败.', [mbOk]);
               AddItemBag (g_SellDlgItemSellWait);
            end;
            g_SellDlgItemSellWait.S.Name := '';
         end;
      SM_SAVEITEMLIST:
         begin
            ClientGetSaveItemList (msg.Recog, body);
         end;
      SM_TAKEBACKSTORAGEITEM_OK,
      SM_TAKEBACKSTORAGEITEM_FAIL,
      SM_TAKEBACKSTORAGEITEM_FULLBAG:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            if msg.Ident <> SM_TAKEBACKSTORAGEITEM_OK then begin
               if msg.Ident = SM_TAKEBACKSTORAGEITEM_FULLBAG then
                  FrmDlg.DMessageDlg ('背包已满.', [mbOk])
               else
                  FrmDlg.DMessageDlg ('你不能取回.', [mbOk]);
            end else
               FrmDlg.DelStorageItem (msg.Recog); //itemserverindex
         end;

      SM_BUYITEM_SUCCESS:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            g_MySelf.m_nGold := msg.Recog;
            FrmDlg.SoldOutGoods (MakeLong(msg.Param, msg.Tag)); //迫赴 酒捞袍 皋春俊辑 画
         end;
      SM_BUYITEM_FAIL:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            case msg.Recog of
               1: FrmDlg.DMessageDlg ('金钱不足，购买失败.', [mbOk]);
               2: FrmDlg.DMessageDlg ('你不能携带更多的东西..', [mbOk]);
               3: FrmDlg.DMessageDlg ('你的出价太低了..', [mbOk]);
            end;
         end;
      SM_MAKEDRUG_SUCCESS:
         begin
            FrmDlg.LastestClickTime := GetTickCount;
            g_MySelf.m_nGold := msg.Recog;
            FrmDlg.DMessageDlg ('药品研制成功..', [mbOk]);
         end;
      SM_MAKEDRUG_FAIL: begin
        FrmDlg.LastestClickTime := GetTickCount;
        case msg.Recog of
          1: FrmDlg.DMessageDlg ('药品研制失败.', [mbOk]);
          2: FrmDlg.DMessageDlg ('发生了错误', [mbOk]);
          3: FrmDlg.DMessageDlg (g_sGoldName{'金币'} + '不足.', [mbOk]);
          4: FrmDlg.DMessageDlg ('你缺乏所必需的物品。', [mbOk]);
        end;
      end;
      SM_716: begin
        DrawEffectHum(Msg.Series{type},Msg.Param{x},Msg.Tag{y});
      end;
      SM_SENDDETAILGOODSLIST: begin
        ClientGetSendDetailGoodsList (msg.Recog, msg.Param, msg.Tag, body);
      end;
      SM_TEST:
         begin
            Inc (g_nTestReceiveCount);
         end;

      SM_SENDNOTICE: begin
        ClientGetSendNotice (body);
      end;
      SM_GROUPMODECHANGED: //辑滚俊辑 唱狼 弊缝 汲沥捞 函版登菌澜.
         begin
            if msg.Param > 0 then g_boAllowGroup := TRUE
            else g_boAllowGroup := FALSE;
            g_dwChangeGroupModeTick := GetTickCount;
         end;
      SM_CREATEGROUP_OK:
         begin
            g_dwChangeGroupModeTick := GetTickCount;
            g_boAllowGroup := TRUE;
            {GroupMembers.Add (Myself.UserName);
            GroupMembers.Add (DecodeString(body));}
         end;
      SM_CREATEGROUP_FAIL:
         begin
            g_dwChangeGroupModeTick := GetTickCount;
            case msg.Recog of
               -1: FrmDlg.DMessageDlg ('创建队伍失败，人数以到最大...', [mbOk]);
               -2: FrmDlg.DMessageDlg ('无法创建队伍，请重新创建......', [mbOk]);
               -3: FrmDlg.DMessageDlg ('队伍名称重复...', [mbOk]);
               -4: FrmDlg.DMessageDlg ('对方不允许组队或拒绝组队.', [mbOk]);
            end;
         end;
      SM_GROUPADDMEM_OK:
         begin
            g_dwChangeGroupModeTick := GetTickCount;
            //GroupMembers.Add (DecodeString(body));
         end;
      SM_GROUPADDMEM_FAIL:
         begin
            g_dwChangeGroupModeTick := GetTickCount;
            case msg.Recog of
               -1: FrmDlg.DMessageDlg ('加入队伍失败，人数以到最大.', [mbOk]);
               -2: FrmDlg.DMessageDlg ('添加队伍成员失败，对方不同意加入.', [mbOk]);
               -3: FrmDlg.DMessageDlg ('添加队伍成员失败，可以由于转生引起，请改用手动招收成员再试!', [mbOk]);
               -4: FrmDlg.DMessageDlg ('对方不允许组队.', [mbOk]);
               -5: FrmDlg.DMessageDlg ('添加队伍成员失败，请重新添加.......', [mbOk]);
            end;
         end;
      SM_GROUPDELMEM_OK:
         begin
            g_dwChangeGroupModeTick := GetTickCount;
            {data := DecodeString (body);
            for i:=0 to GroupMembers.Count-1 do begin
               if GroupMembers[i] = data then begin
                  GroupMembers.Delete (i);
                  break;
               end;
            end; }
         end;
      SM_GROUPDELMEM_FAIL:
         begin
            g_dwChangeGroupModeTick := GetTickCount;
            case msg.Recog of
               -1: FrmDlg.DMessageDlg ('编组还未成立或者您还不够等级创建。', [mbOk]);
               -2: FrmDlg.DMessageDlg ('输入的人物名称不正确！', [mbOk]);
               -3: FrmDlg.DMessageDlg ('此人不在本组中！', [mbOk]);
            end;
         end;
      SM_GROUPCANCEL: begin
        g_GroupMembers.Clear;
      end;
      SM_GROUPMEMBERS:
         begin
            ClientGetGroupMembers (DecodeString(Body));
         end;

      SM_OPENGUILDDLG:
         begin
            g_dwQueryMsgTick := GetTickCount;
            ClientGetOpenGuildDlg (body);
         end;

      SM_SENDGUILDMEMBERLIST:
         begin
            g_dwQueryMsgTick := GetTickCount;
            ClientGetSendGuildMemberList (body);
         end;

      SM_OPENGUILDDLG_FAIL:
         begin
            g_dwQueryMsgTick := GetTickCount;
            FrmDlg.DMessageDlg ('您还没有加入行会！', [mbOk]);
         end;

      SM_DEALTRY_FAIL: begin
        g_dwQueryMsgTick := GetTickCount;
        FrmDlg.DMessageDlg ('交易被取消.\要正确交易你必须和对方面对面.', [mbOk]);
      end;
      SM_DEALMENU:
         begin
            g_dwQueryMsgTick := GetTickCount;
            g_sDealWho := DecodeString (body);
            FrmDlg.OpenDealDlg;
         end;
      SM_DEALCANCEL: begin
        MoveDealItemToBag;
        if g_DealDlgItem.S.Name <> '' then begin
          AddItemBag (g_DealDlgItem);  //啊规俊 眠啊
          g_DealDlgItem.S.Name := '';
        end;
        if g_nDealGold > 0 then begin
          g_MySelf.m_nGold := g_MySelf.m_nGold + g_nDealGold;
          g_nDealGold := 0;
        end;
        FrmDlg.CloseDealDlg;
      end;
      SM_DEALADDITEM_OK:
         begin
            g_dwDealActionTick := GetTickCount;
            if g_DealDlgItem.S.Name <> '' then begin
               AddDealItem (g_DealDlgItem);  //Deal Dlg俊 眠啊
               g_DealDlgItem.S.Name := '';
            end;
         end;
      SM_DEALADDITEM_FAIL: begin
        g_dwDealActionTick:=GetTickCount;
        if g_DealDlgItem.S.Name <> '' then begin
          AddItemBag(g_DealDlgItem);  //啊规俊 眠啊
          g_DealDlgItem.S.Name:= '';
        end;
      end;
      SM_DEALDELITEM_OK: begin
        g_dwDealActionTick:=GetTickCount;
        if g_DealDlgItem.S.Name <> '' then begin
               //AddItemBag (DealDlgItem);  //啊规俊 眠啊
          g_DealDlgItem.S.Name := '';
        end;
      end;
      SM_DEALDELITEM_FAIL: begin
        g_dwDealActionTick := GetTickCount;
        if g_DealDlgItem.S.Name <> '' then begin
          DelItemBag (g_DealDlgItem.S.Name, g_DealDlgItem.MakeIndex);
          AddDealItem (g_DealDlgItem);
          g_DealDlgItem.S.Name := '';
        end;
      end;
      SM_DEALREMOTEADDITEM: ClientGetDealRemoteAddItem (body);
      SM_DEALREMOTEDELITEM: ClientGetDealRemoteDelItem (body);
      SM_DEALCHGGOLD_OK: begin
        g_nDealGold:=msg.Recog;
        g_MySelf.m_nGold:=MakeLong(msg.param, msg.tag);
        g_dwDealActionTick:=GetTickCount;
      end;
      SM_DEALCHGGOLD_FAIL: begin
        g_nDealGold:=msg.Recog;
        g_MySelf.m_nGold:=MakeLong(msg.param, msg.tag);
        g_dwDealActionTick:=GetTickCount;
      end;
      SM_DEALREMOTECHGGOLD: begin
        g_nDealRemoteGold:=msg.Recog;
        SoundUtil.PlaySound(s_money);  //惑措规捞 捣阑 函版茄 版快 家府啊 抄促.
      end;
      SM_DEALSUCCESS: begin
        FrmDlg.CloseDealDlg;
      end;
      SM_SENDUSERSTORAGEITEM: begin
        ClientGetSendUserStorage(msg.Recog);
      end;
      SM_READMINIMAP_OK: begin
        g_dwQueryMsgTick:=GetTickCount;
        ClientGetReadMiniMap(msg.Param);
      end;
      SM_READMINIMAP_FAIL: begin
        g_dwQueryMsgTick := GetTickCount;
        DScreen.AddChatBoardString ('没有可用的小地图.', clWhite, clRed);
        g_nMiniMapIndex:= -1;
      end;
      SM_CHANGEGUILDNAME: begin
        ClientGetChangeGuildName(DecodeString (body));
      end;
      SM_SENDUSERSTATE: begin
        ClientGetSendUserState(body);
      end;
      SM_GUILDADDMEMBER_OK: begin
        SendGuildMemberList;
      end;
      SM_GUILDADDMEMBER_FAIL: begin
        case msg.Recog of
          1: FrmDlg.DMessageDlg ('您没有命令秩序权利 .', [mbOk]);
          2: FrmDlg.DMessageDlg ('您要与要添加的行会成员面对而站.', [mbOk]);
          3: FrmDlg.DMessageDlg ('已经加入了我们的行会 .', [mbOk]);
          4: FrmDlg.DMessageDlg ('已经加入了另一个行会.', [mbOk]);
          5: FrmDlg.DMessageDlg ('对方不允许加入行会.', [mbOk]);
        end;
      end;
      SM_GUILDDELMEMBER_OK: begin
        SendGuildMemberList;
      end;
      SM_GUILDDELMEMBER_FAIL: begin
        case msg.Recog of
          1: FrmDlg.DMessageDlg('不能使用命令！', [mbOk]);
          2: FrmDlg.DMessageDlg('此人非本行会成员！', [mbOk]);
          3: FrmDlg.DMessageDlg('行会掌门人不能开除自己！', [mbOk]);
          4: FrmDlg.DMessageDlg('不能使用命令Z！', [mbOk]);
        end;
      end;
      SM_GUILDRANKUPDATE_FAIL: begin
        case msg.Recog of
          -2: FrmDlg.DMessageDlg('[提示信息] 掌门人位置不能为空。', [mbOk]);
          -3: FrmDlg.DMessageDlg('[提示信息] 新的行会掌门人已经被传位。', [mbOk]);
          -4: FrmDlg.DMessageDlg('[提示信息] 一个行会最多只能有二个掌门人。', [mbOk]);
          -5: FrmDlg.DMessageDlg('[提示信息] 掌门人位置不能为空。', [mbOk]);
          -6: FrmDlg.DMessageDlg('[提示信息] 不能添加成员/删除成员。', [mbOk]);
          -7: FrmDlg.DMessageDlg('[提示信息] 职位重复或者出错。', [mbOk]);
        end;
      end;
      SM_GUILDMAKEALLY_OK,
      SM_GUILDMAKEALLY_FAIL: begin
        case msg.Recog of
          -1: FrmDlg.DMessageDlg ('您无此权限！', [mbOk]);
          -2: FrmDlg.DMessageDlg ('结盟失败！', [mbOk]);
          -3: FrmDlg.DMessageDlg ('行会结盟必须双方掌门人面对面！', [mbOk]);
          -4: FrmDlg.DMessageDlg ('对方行会掌门人不允许结盟！', [mbOk]);
        end;
      end;
      SM_GUILDBREAKALLY_OK,
      SM_GUILDBREAKALLY_FAIL: begin
        case msg.Recog of
          -1: FrmDlg.DMessageDlg ('解除结盟！', [mbOk]);
          -2: FrmDlg.DMessageDlg ('此行会不是您行会的结盟行会！', [mbOk]);
          -3: FrmDlg.DMessageDlg ('没有此行会！', [mbOk]);
        end;
      end;
      SM_BUILDGUILD_OK: begin
        FrmDlg.LastestClickTime := GetTickCount;
        FrmDlg.DMessageDlg ('创建行会成功...', [mbOk]);
      end;
      SM_BUILDGUILD_FAIL: begin
        FrmDlg.LastestClickTime := GetTickCount;
        case msg.Recog of
          -1: FrmDlg.DMessageDlg('您已经加入其它行会。', [mbOk]);
          -2: FrmDlg.DMessageDlg('缺少创建费用。', [mbOk]);
          -3: FrmDlg.DMessageDlg('你没有准备好需要的全部物品。', [mbOk]);
          else FrmDlg.DMessageDlg('创建行会失败！！！', [mbOk]);
        end;
      end;
      SM_MENU_OK: begin
        FrmDlg.LastestClickTime:=GetTickCount;
        if body <> '' then
          FrmDlg.DMessageDlg(DecodeString(body), [mbOk]);
      end;
      SM_DLGMSG: begin
        if body <> '' then
          FrmDlg.DMessageDlg(DecodeString(body), [mbOk]);
      end;
      SM_DONATE_OK: begin
        FrmDlg.LastestClickTime:=GetTickCount;
      end;
      SM_DONATE_FAIL: begin
        FrmDlg.LastestClickTime:=GetTickCount;
      end;

      SM_PLAYDICE: begin
        Body2:=Copy(Body,GetCodeMsgSize(sizeof(TMessageBodyWL)*4/3) + 1, Length(body));
        DecodeBuffer(body,@wl,SizeOf(TMessageBodyWL));
        data:=DecodeString(Body2);
        FrmDlg.m_nDiceCount:=Msg.Param;       //QuestActionInfo.nParam1
        FrmDlg.m_Dice[0].nDicePoint:=LoByte(LoWord(Wl.lParam1)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[1].nDicePoint:=HiByte(LoWord(Wl.lParam1)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[2].nDicePoint:=LoByte(HiWord(Wl.lParam1)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[3].nDicePoint:=HiByte(HiWord(Wl.lParam1)); //UserHuman.m_DyVal[0]

        FrmDlg.m_Dice[4].nDicePoint:=LoByte(LoWord(Wl.lParam2)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[5].nDicePoint:=HiByte(LoWord(Wl.lParam2)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[6].nDicePoint:=LoByte(HiWord(Wl.lParam2)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[7].nDicePoint:=HiByte(HiWord(Wl.lParam2)); //UserHuman.m_DyVal[0]

        FrmDlg.m_Dice[8].nDicePoint:=LoByte(LoWord(Wl.lTag1)); //UserHuman.m_DyVal[0]
        FrmDlg.m_Dice[9].nDicePoint:=HiByte(LoWord(Wl.lTag1)); //UserHuman.m_DyVal[0]
        FrmDlg.DialogSize:=0;
        FrmDlg.DMessageDlg('',[]);
        SendMerchantDlgSelect(Msg.Recog,data);
      end;
      SM_NEEDPASSWORD: begin
        ClientGetNeedPassword(Body);
      end;
      SM_PASSWORDSTATUS: begin
        ClientGetPasswordStatus(@Msg,Body);
      end;
      SM_GETREGINFO: ClientGetRegInfo(@Msg,Body);
      else begin
        if g_MySelf = nil then exit;     //Jacky 在未进入游戏时不处理下面
//Jacky
//            DScreen.AddSysMsg (IntToStr(msg.Ident) + ' : ' + body);
        PlayScene.MemoLog.Lines.Add('Ident: ' + IntToStr(msg.Ident));
        PlayScene.MemoLog.Lines.Add('Recog: ' + IntToStr(msg.Recog));
        PlayScene.MemoLog.Lines.Add('Param: ' + IntToStr(msg.Param));
        PlayScene.MemoLog.Lines.Add('Tag: ' + IntToStr(msg.Tag));
        PlayScene.MemoLog.Lines.Add('Series: ' + IntToStr(msg.Series));
      end;
   end;

   if Pos('#', datablock) > 0 then
      DScreen.AddSysMsg (datablock);
end;


procedure TfrmMain.ClientGetPasswdSuccess (body: string);
var
   str, runaddr, runport, uid, certifystr: string;
begin
   str := DecodeString (body);
   str := GetValidStr3 (str, runaddr, ['/']);
   str := GetValidStr3 (str, runport, ['/']);
   str := GetValidStr3 (str, certifystr, ['/']);
   Certification := Str_ToInt(certifystr, 0);

   if not BoOneClick then begin
      CSocket.Active:=False;
      CSocket.Host:='';
      CSocket.Port:=0;
      FrmDlg.DSelServerDlg.Visible := FALSE;
      WaitAndPass (500); //0.5檬悼救 扁促覆
      g_ConnectionStep := cnsSelChr;
      with CSocket do begin
         g_sSelChrAddr := runaddr;
         g_nSelChrPort := Str_ToInt (runport, 0);
         Address := g_sSelChrAddr;
         Port := g_nSelChrPort;
         Active := TRUE;
      end;
   end else begin
      FrmDlg.DSelServerDlg.Visible := FALSE;
      g_sSelChrAddr := runaddr;
      g_nSelChrPort := Str_ToInt (runport, 0);
      if CSocket.Socket.Connected then
         CSocket.Socket.SendText ('$S' + runaddr + '/' + runport + '%');
      WaitAndPass (500); //0.5檬悼救 扁促覆
      g_ConnectionStep := cnsSelChr;
      LoginScene.OpenLoginDoor;
      SelChrWaitTimer.Enabled := TRUE;
   end;
end;
procedure TfrmMain.ClientGetPasswordOK(Msg: TDefaultMessage;
  sBody: String);
var
  I: Integer;
  sServerName:String;
  sServerStatus:String;
  nCount:Integer;
begin
  sBody:=DeCodeString(sBody);
//  FrmDlg.DMessageDlg (sBody + '/' + IntToStr(Msg.Series), [mbOk]);
  nCount:=_MIN(6,msg.Series);
  g_ServerList.Clear;
  for I := 0 to nCount - 1 do begin
    sBody:=GetValidStr3(sBody,sServerName,['/']);
    sBody:=GetValidStr3(sBody,sServerStatus,['/']);
    g_ServerList.AddObject(sServerName,TObject(Str_ToInt(sServerStatus,0)));
  end;
  //if g_ServerList.Count = 0 then begin
//    g_ServerList.InsertObject(0,'九月传奇',TObject(Str_ToInt(sServerStatus,0)));
//  end;
    


               g_wAvailIDDay := Loword(msg.Recog);
               g_wAvailIDHour := Hiword(msg.Recog);
               g_wAvailIPDay := msg.Param;
               g_wAvailIPHour := msg.Tag;

               if g_wAvailIDDay > 0 then begin
                  if g_wAvailIDDay = 1 then
                     FrmDlg.DMessageDlg ('您当前ID费用到今天为止。', [mbOk])
                  else if g_wAvailIDDay <= 3 then
                     FrmDlg.DMessageDlg ('您当前IP费用还剩 ' + IntToStr(g_wAvailIDDay) + ' 天。', [mbOk]);
               end else if g_wAvailIPDay > 0 then begin
                  if g_wAvailIPDay = 1 then
                     FrmDlg.DMessageDlg ('您当前IP费用到今天为止。', [mbOk])
                  else if g_wAvailIPDay <= 3 then
                     FrmDlg.DMessageDlg ('您当前IP费用还剩 ' + IntToStr(g_wAvailIPDay) + ' 天。', [mbOk]);
               end else if g_wAvailIPHour > 0 then begin
                  if g_wAvailIPHour <= 100 then
                     FrmDlg.DMessageDlg ('您当前IP费用还剩 ' + IntToStr(g_wAvailIPHour) + ' 小时。', [mbOk]);
               end else if g_wAvailIDHour > 0 then begin
                  FrmDlg.DMessageDlg ('您当前ID费用还剩 ' + IntToStr(g_wAvailIDHour) + ' 小时。', [mbOk]);;
               end;

               if not LoginScene.m_boUpdateAccountMode then
                  ClientGetSelectServer;
end;

procedure TfrmMain.ClientGetSelectServer;
var
  sname: string;
begin
  LoginScene.HideLoginBox;
  FrmDlg.ShowSelectServerDlg;
end;

procedure TfrmMain.ClientGetNeedUpdateAccount (body: string);
var
   ue: TUserEntry;
begin
   DecodeBuffer (body, @ue, sizeof(TUserEntry));
   LoginScene.UpdateAccountInfos (ue);
end;

procedure TfrmMain.ClientGetReceiveChrs (body: string);
var
   i, select: integer;
   str, uname, sjob, shair, slevel, ssex: string;
begin
   SelectChrScene.ClearChrs;
   str := DecodeString (body);
   for i:=0 to 1 do begin
      str := GetValidStr3 (str, uname, ['/']);
      str := GetValidStr3 (str, sjob, ['/']);
      str := GetValidStr3 (str, shair, ['/']);
      str := GetValidStr3 (str, slevel, ['/']);
      str := GetValidStr3 (str, ssex, ['/']);
      select := 0;
      if (uname <> '') and (slevel <> '') and (ssex <> '') then begin
         if uname[1] = '*' then begin
            select := i;
            uname := Copy (uname, 2, Length(uname)-1);
         end;
         SelectChrScene.AddChr (uname, Str_ToInt(sjob, 0), Str_ToInt(shair, 0), Str_ToInt(slevel, 0), Str_ToInt(ssex, 0));
      end;
      with SelectChrScene do begin
         if select = 0 then begin
            ChrArr[0].FreezeState := FALSE;
            ChrArr[0].Selected := TRUE;
            ChrArr[1].FreezeState := TRUE;
            ChrArr[1].Selected := FALSE;
         end else begin
            ChrArr[0].FreezeState := TRUE;
            ChrArr[0].Selected := FALSE;
            ChrArr[1].FreezeState := FALSE;
            ChrArr[1].Selected := TRUE;
         end;
      end;
   end;
   PlayScene.EdAccountt.Text:=LoginId;
   //2004/05/17  强行登录
   {
   if SelectChrScene.ChrArr[0].Valid and SelectChrScene.ChrArr[0].Selected then PlayScene.EdChrNamet.Text := SelectChrScene.ChrArr[0].UserChr.Name;
   if SelectChrScene.ChrArr[1].Valid and SelectChrScene.ChrArr[1].Selected then PlayScene.EdChrNamet.Text := SelectChrScene.ChrArr[1].UserChr.Name;
   PlayScene.EdAccountt.Visible:=True;
   PlayScene.EdChrNamet.Visible:=True;
     }
   //2004/05/17
end;

procedure TfrmMain.ClientGetStartPlay (body: string);
var
   str, addr, sport: string;
begin
   str := DecodeString (body);
   sport := GetValidStr3 (str, g_sRunServerAddr, ['/']);
   g_nRunServerPort:=Str_ToInt (sport, 0);

   if not BoOneClick then begin
      CSocket.Active := FALSE;  //肺弊牢俊 楷搬等 家南 摧澜
      CSocket.Host:='';
      CSocket.Port:=0;
      WaitAndPass (500); //0.5檬悼救 扁促覆

      g_ConnectionStep := cnsPlay;
      with CSocket do begin
         Address := g_sRunServerAddr;
         Port := g_nRunServerPort;
         Active := TRUE;
      end;
   end else begin
      SocStr := '';
      BufferStr := '';
      if CSocket.Socket.Connected then
         CSocket.Socket.SendText ('$R' + addr + '/' + sport + '%');

      g_ConnectionStep := cnsPlay;
      ClearBag;  //啊规 檬扁拳
      DScreen.ClearChatBoard; //盲泼芒 檬扁拳
      DScreen.ChangeScene (stLoginNotice);

      WaitAndPass (500); //0.5檬悼救 扁促覆
      SendRunLogin;
   end;
end;

procedure TfrmMain.ClientGetReconnect (body: string);
var
   str, addr, sport: string;
begin
   str := DecodeString (body);
   sport := GetValidStr3 (str, addr, ['/']);

   if not BoOneClick then begin
      if g_boBagLoaded then
         Savebags ('.\Data\' + g_sServerName + '.' + CharName + '.itm', @g_ItemArr);
      g_boBagLoaded := FALSE;

      g_boServerChanging := TRUE;
      CSocket.Active := FALSE;  //肺弊牢俊 楷搬等 家南 摧澜
      CSocket.Host:='';
      CSocket.Port:=0;

      WaitAndPass (500); //0.5檬悼救 扁促覆

      g_ConnectionStep := cnsPlay;
      with CSocket do begin
         Address := addr;
         Port := Str_ToInt (sport, 0);
         Active := TRUE;
      end;

   end else begin
      if g_boBagLoaded then
         Savebags ('.\Data\' + g_sServerName + '.' + CharName + '.itm', @g_ItemArr);
      g_boBagLoaded := FALSE;

      SocStr := '';
      BufferStr := '';
      g_boServerChanging := TRUE;

      if CSocket.Socket.Connected then   //立加 辆丰 脚龋 焊辰促.
         CSocket.Socket.SendText ('$C' + addr + '/' + sport + '%');

      WaitAndPass (500); //0.5檬悼救 扁促覆
      if CSocket.Socket.Connected then   //犁立..
         CSocket.Socket.SendText ('$R' + addr + '/' + sport + '%');

      g_ConnectionStep := cnsPlay;
      ClearBag;  //啊规 檬扁拳
      DScreen.ClearChatBoard; //盲泼芒 檬扁拳
      DScreen.ChangeScene (stLoginNotice);

      WaitAndPass (300); //0.5檬悼救 扁促覆
      ChangeServerClearGameVariables;

      SendRunLogin;
   end;
end;

procedure TfrmMain.ClientGetMapDescription(Msg:TDefaultMessage;sBody:String);
var
  sTitle:String;
begin
  sBody:=DecodeString(sBody);
  sBody:=GetValidStr3(sBody, sTitle, [#13]);
  g_sMapTitle:=sTitle;
  g_nMapMusic:=Msg.Recog;
  PlayMapMusic(True);
end;

procedure TfrmMain.ClientGetGameGoldName(Msg:TDefaultMessage;sBody: String);
var
  sData:String;
begin
  if sBody <> '' then begin
    sBody:=DecodeString(sBody);
    sBody:=GetValidStr3(sBody, sData, [#13]);
    g_sGameGoldName:=sData;
    g_sGamePointName:=sBody;
  end;
  g_MySelf.m_nGameGold:=Msg.Recog;
  g_MySelf.m_nGamePoint:=MakeLong(Msg.Param,Msg.Tag);
end;

procedure TfrmMain.ClientGetAdjustBonus (bonus: integer; body: string);
var
   str1, str2, str3: string;
begin
   g_nBonusPoint := bonus;
   body := GetValidStr3 (body, str1, ['/']);
   str3 := GetValidStr3 (body, str2, ['/']);
   DecodeBuffer (str1, @g_BonusTick, sizeof(TNakedAbility));
   DecodeBuffer (str2, @g_BonusAbil, sizeof(TNakedAbility));
   DecodeBuffer (str3, @g_NakedAbil, sizeof(TNakedAbility));
   FillChar (g_BonusAbilChg, sizeof(TNakedAbility), #0);
end;

procedure TfrmMain.ClientGetAddItem (body: string);
var
   cu: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @cu, sizeof(TClientItem));
      AddItemBag (cu);
      DScreen.AddSysMsg (cu.S.Name + ' 放到包囊.');
   end;
end;

procedure TfrmMain.ClientGetUpdateItem (body: string);
var
   i: integer;
   cu: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @cu, sizeof(TClientItem));
      UpdateItemBag (cu);
      for i:=0 to 12 do begin
         if (g_UseItems[i].S.Name = cu.S.Name) and (g_UseItems[i].MakeIndex = cu.MakeIndex) then begin
            g_UseItems[i] := cu;
         end;
      end;
   end;
end;

procedure TfrmMain.ClientGetDelItem (body: string);
var
   i: integer;
   cu: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @cu, sizeof(TClientItem));
      DelItemBag (cu.S.Name, cu.MakeIndex);
      for i:=0 to 12 do begin
         if (g_UseItems[i].S.Name = cu.S.Name) and (g_UseItems[i].MakeIndex = cu.MakeIndex) then begin
            g_UseItems[i].S.Name := '';
         end;
      end;
   end;
end;

procedure TfrmMain.ClientGetDelItems (body: string);
var
   i, iindex: integer;
   str, iname: string;
   cu: TClientItem;
begin
   body := DecodeString (body);
   while body <> '' do begin
      body := GetValidStr3 (body, iname, ['/']);
      body := GetValidStr3 (body, str, ['/']);
      if (iname <> '') and (str <> '') then begin
         iindex := Str_ToInt(str, 0);
         DelItemBag (iname, iindex);
         for i:=0 to 12 do begin
            if (g_UseItems[i].S.Name = iname) and (g_UseItems[i].MakeIndex = iindex) then begin
               g_UseItems[i].S.Name := '';
            end;
         end;
      end else
         break;
   end;
end;

procedure TfrmMain.ClientGetBagItmes (body: string);
var
   str: string;
   cu: TClientItem;
   ItemSaveArr: array[0..MAXBAGITEMCL-1] of TClientItem;

   function CompareItemArr: Boolean;
   var
      i, j: integer;
      flag: Boolean;
   begin
      flag := TRUE;
      for i:=0 to MAXBAGITEMCL-1 do begin
         if ItemSaveArr[i].S.Name <> '' then begin
            flag := FALSE;
            for j:=0 to MAXBAGITEMCL-1 do begin
               if (g_ItemArr[j].S.Name = ItemSaveArr[i].S.Name) and
                  (g_ItemArr[j].MakeIndex = ItemSaveArr[i].MakeIndex) then begin
                  if (g_ItemArr[j].Dura = ItemSaveArr[i].Dura) and
                     (g_ItemArr[j].DuraMax = ItemSaveArr[i].DuraMax) then begin
                     flag := TRUE;
                  end;
                  break;
               end;
            end;
            if not flag then break;
         end;
      end;
      if flag then begin
         for i:=0 to MAXBAGITEMCL-1 do begin
            if g_ItemArr[i].S.Name <> '' then begin
               flag := FALSE;
               for j:=0 to MAXBAGITEMCL-1 do begin
                  if (g_ItemArr[i].S.Name = ItemSaveArr[j].S.Name) and
                     (g_ItemArr[i].MakeIndex = ItemSaveArr[j].MakeIndex) then begin
                     if (g_ItemArr[i].Dura = ItemSaveArr[j].Dura) and
                        (g_ItemArr[i].DuraMax = ItemSaveArr[j].DuraMax) then begin
                        flag := TRUE;
                     end;
                     break;
                  end;
               end;
               if not flag then break;
            end;
         end;
      end;
      Result := flag;
   end;
begin
   //ClearBag;
   FillChar (g_ItemArr, sizeof(TClientItem)*MAXBAGITEMCL, #0);
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, str, ['/']);
      DecodeBuffer (str, @cu, sizeof(TClientItem));
      AddItemBag (cu);
   end;

   FillChar (ItemSaveArr, sizeof(TClientItem)*MAXBAGITEMCL, #0);
   Loadbags ('.\Data\' + g_sServerName + '.' + CharName + '.itm', @ItemSaveArr);
   if CompareItemArr then begin
      Move (ItemSaveArr, g_ItemArr, sizeof(TClientItem) * MAXBAGITEMCL);
   end;
   
   ArrangeItembag;
   g_boBagLoaded := TRUE;
end;

procedure TfrmMain.ClientGetDropItemFail (iname: string; sindex: integer);
var
   pc: PTClientItem;
begin
   pc := GetDropItem (iname, sindex);
   if pc <> nil then begin
      AddItemBag (pc^);
      DelDropItem (iname, sindex);
   end;
end;

procedure TfrmMain.ClientGetShowItem (itemid, x, y, looks: integer; itmname: string);
var
  I:Integer;
  DropItem:PTDropItem;
begin
  for i:=0 to g_DropedItemList.Count-1 do begin
    if PTDropItem(g_DropedItemList[i]).Id = itemid then
      exit;
  end;
  New(DropItem);
  DropItem.Id := itemid;
  DropItem.X := x;
  DropItem.Y := y;
  DropItem.Looks := looks;
  DropItem.Name := itmname;
  DropItem.FlashTime := GetTickCount - LongWord(Random(3000));
  DropItem.BoFlash := FALSE;
  g_DropedItemList.Add(DropItem);
end;

procedure TfrmMain.ClientGetHideItem (itemid, x, y: integer);
var
  I:Integer;
  DropItem:PTDropItem;
begin
  for I:=0 to g_DropedItemList.Count - 1 do begin
    DropItem:=g_DropedItemList[I];
    if DropItem.Id = itemid then begin
      Dispose (DropItem);
      g_DropedItemList.Delete(I);
      break;
    end;
  end;
end;
procedure TfrmMain.ClientGetSendAddUseItems (body: string);
var
   index: integer;
   str, data: string;
   cu: TClientItem;
begin
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, str, ['/']);
      body := GetValidStr3 (body, data, ['/']);
      index := Str_ToInt (str, -1);
      if index in [9..12] then begin
         DecodeBuffer (data, @cu, sizeof(TClientItem));
         g_UseItems[index] := cu;
      end;
   end;
end;
procedure TfrmMain.ClientGetSenduseItems (body: string);
var
   index: integer;
   str, data: string;
   cu: TClientItem;
begin
   FillChar (g_UseItems, sizeof(TClientItem)*13, #0);
//   FillChar (UseItems, sizeof(TClientItem)*9, #0);
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, str, ['/']);
      body := GetValidStr3 (body, data, ['/']);
      index := Str_ToInt (str, -1);
      if index in [0..12] then begin
         DecodeBuffer (data, @cu, sizeof(TClientItem));
         g_UseItems[index] := cu;
      end;
   end;
end;

procedure TfrmMain.ClientGetAddMagic (body: string);
var
   pcm: PTClientMagic;
begin
   new (pcm);
   DecodeBuffer (body, @(pcm^), sizeof(TClientMagic));
   g_MagicList.Add (pcm);
end;

procedure TfrmMain.ClientGetDelMagic (magid: integer);
var
   i: integer;
begin
   for i:=g_MagicList.Count-1 downto 0 do begin
      if PTClientMagic(g_MagicList[i]).Def.wMagicId = magid then begin
         Dispose (PTClientMagic(g_MagicList[i]));
         g_MagicList.Delete (i);
         break;
      end;
   end;
end;

procedure TfrmMain.ClientGetMyMagics (body: string);
var
   i: integer;
   data: string;
   pcm: PTClientMagic;
begin
   for i:=0 to g_MagicList.Count-1 do
      Dispose (PTClientMagic (g_MagicList[i]));
   g_MagicList.Clear;
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, data, ['/']);
      if data <> '' then begin
         new (pcm);
         DecodeBuffer (data, @(pcm^), sizeof(TClientMagic));
         g_MagicList.Add (pcm);

//    PlayScene.MemoLog.Lines.Add(pcm.Def.sMagicName + IntToStr(MagicList.Count));
      end else
         break;
   end;
end;

procedure TfrmMain.ClientGetMagicLvExp (magid, maglv, magtrain: integer);
var
   i: integer;
begin
   for i:=g_MagicList.Count-1 downto 0 do begin
      if PTClientMagic(g_MagicList[i]).Def.wMagicId = magid then begin
         PTClientMagic(g_MagicList[i]).Level := maglv;
         PTClientMagic(g_MagicList[i]).CurTrain := magtrain;
         break;
      end;
   end;
end;

procedure TfrmMain.ClientGetDuraChange (uidx, newdura, newduramax: integer);
begin
   if uidx in [0..12] then begin
      if g_UseItems[uidx].S.Name <> '' then begin
         g_UseItems[uidx].Dura := newdura;
         g_UseItems[uidx].DuraMax := newduramax;
      end;
   end;
end;

procedure TfrmMain.ClientGetMerchantSay (merchant, face: integer; saying: string);
var
   npcname: string;
begin
   g_nMDlgX := g_MySelf.m_nCurrX;
   g_nMDlgY := g_MySelf.m_nCurrY;
   if g_nCurMerchant <> merchant then begin
      g_nCurMerchant := merchant;
      FrmDlg.ResetMenuDlg;
      FrmDlg.CloseMDlg;
   end;
//   ShowMessage(saying);
   saying := GetValidStr3 (saying, npcname, ['/']);
   FrmDlg.ShowMDlg (face, npcname, saying);
end;

procedure TfrmMain.ClientGetSendGoodsList (merchant, count: integer; body: string);
var
   i: integer;
   data, gname, gsub, gprice, gstock: string;
   pcg: PTClientGoods;
begin
   FrmDlg.ResetMenuDlg;
   
   g_nCurMerchant := merchant;
   with FrmDlg do begin
      //deocde body received from server
      body := DecodeString (body);
      while body <> '' do begin
         body := GetValidStr3 (body, gname, ['/']);
         body := GetValidStr3 (body, gsub, ['/']);
         body := GetValidStr3 (body, gprice, ['/']);
         body := GetValidStr3 (body, gstock, ['/']);
         if (gname <> '') and (gprice <> '') and (gstock <> '') then begin
            new (pcg);
            pcg.Name := gname;
            pcg.SubMenu := Str_ToInt (gsub, 0);
            pcg.Price := Str_ToInt (gprice, 0);
            pcg.Stock := Str_ToInt (gstock, 0);
            pcg.Grade := -1;
            MenuList.Add (pcg);
         end else
            break;
      end;
      FrmDlg.ShowShopMenuDlg;
      FrmDlg.CurDetailItem := '';
   end;
end;

procedure TfrmMain.ClientGetSendMakeDrugList (merchant: integer; body: string);
var
   i: integer;
   data, gname, gsub, gprice, gstock: string;
   pcg: PTClientGoods;
begin
   FrmDlg.ResetMenuDlg;

   g_nCurMerchant := merchant;
   with FrmDlg do begin
      //clear shop menu list
      //deocde body received from server
      body := DecodeString (body);
      while body <> '' do begin
         body := GetValidStr3 (body, gname, ['/']);
         body := GetValidStr3 (body, gsub, ['/']);
         body := GetValidStr3 (body, gprice, ['/']);
         body := GetValidStr3 (body, gstock, ['/']);
         if (gname <> '') and (gprice <> '') and (gstock <> '') then begin
            new (pcg);
            pcg.Name := gname;
            pcg.SubMenu := Str_ToInt (gsub, 0);
            pcg.Price := Str_ToInt (gprice, 0);
            pcg.Stock := Str_ToInt (gstock, 0);
            pcg.Grade := -1;
            MenuList.Add (pcg);
         end else
            break;
      end;
      FrmDlg.ShowShopMenuDlg;
      FrmDlg.CurDetailItem := '';
      FrmDlg.BoMakeDrugMenu := TRUE;
   end;
end;


procedure TfrmMain.ClientGetSendUserSell (merchant: integer);
begin
   FrmDlg.CloseDSellDlg;
   g_nCurMerchant := merchant;
   FrmDlg.SpotDlgMode := dmSell;
   FrmDlg.ShowShopSellDlg;
end;

procedure TfrmMain.ClientGetSendUserRepair (merchant: integer);
begin
   FrmDlg.CloseDSellDlg;
   g_nCurMerchant := merchant;
   FrmDlg.SpotDlgMode := dmRepair;
   FrmDlg.ShowShopSellDlg;
end;

procedure TfrmMain.ClientGetSendUserStorage (merchant: integer);
begin
   FrmDlg.CloseDSellDlg;
   g_nCurMerchant := merchant;
   FrmDlg.SpotDlgMode := dmStorage;
   FrmDlg.ShowShopSellDlg;
end;

procedure TfrmMain.ClientGetRegInfo(Msg: pTDefaultMessage; Body: String);
begin
  DecodeBuffer(Body,@g_RegInfo,SizeOf(TRegInfo));
end;

procedure TfrmMain.ClientGetSaveItemList (merchant: integer; bodystr: string);
var
   i: integer;
   data: string;
   pc: PTClientItem;
   pcg: PTClientGoods;
begin
   FrmDlg.ResetMenuDlg;

   for i:=0 to g_SaveItemList.Count-1 do
      Dispose(PTClientItem(g_SaveItemList[i]));
   g_SaveItemList.Clear;

   while TRUE do begin
      if bodystr = '' then break;
      bodystr := GetValidStr3 (bodystr, data, ['/']);
      if data <> '' then begin
         new (pc);
         DecodeBuffer (data, @(pc^), sizeof(TClientItem));
         g_SaveItemList.Add (pc);
      end else
         break;
   end;

   g_nCurMerchant := merchant;
   with FrmDlg do begin
      //deocde body received from server
      for i:=0 to g_SaveItemList.Count-1 do begin
         new (pcg);
         pcg.Name := PTClientItem(g_SaveItemList[i]).S.Name;
         pcg.SubMenu := 0;
         pcg.Price := PTClientItem(g_SaveItemList[i]).MakeIndex;
         pcg.Stock := Round(PTClientItem(g_SaveItemList[i]).Dura / 1000);
         pcg.Grade := Round(PTClientItem(g_SaveItemList[i]).DuraMax / 1000);
         MenuList.Add (pcg);
      end;
      FrmDlg.ShowShopMenuDlg;
      FrmDlg.BoStorageMenu := TRUE;
   end;
end;

procedure TfrmMain.ClientGetSendDetailGoodsList (merchant, count, topline: integer; bodystr: string);
var
   i: integer;
   body, data, gname, gprice, gstock, ggrade: string;
   pcg: PTClientGoods;
   pc: PTClientItem;
begin
   FrmDlg.ResetMenuDlg;

   g_nCurMerchant := merchant;

   bodystr := DecodeString(bodystr);
   while TRUE do begin
      if bodystr = '' then break;
      bodystr := GetValidStr3 (bodystr, data, ['/']);
      if data <> '' then begin
         new (pc);
         DecodeBuffer (data, @(pc^), sizeof(TClientItem));
         g_MenuItemList.Add (pc);
      end else
         break;
   end;

   with FrmDlg do begin
      //clear shop menu list
      for i:=0 to g_MenuItemList.Count-1 do begin
         new (pcg);
         pcg.Name := PTClientItem(g_MenuItemList[i]).S.Name;
         pcg.SubMenu := 0;
         pcg.Price := PTClientItem(g_MenuItemList[i]).DuraMax;
         pcg.Stock := PTClientItem(g_MenuItemList[i]).MakeIndex;
         pcg.Grade := Round(PTClientItem(g_MenuItemList[i]).Dura/1000);
         MenuList.Add (pcg);
      end;
      FrmDlg.ShowShopMenuDlg;
      FrmDlg.BoDetailMenu := TRUE;
      FrmDlg.MenuTopLine := topline;
   end;
end;

procedure TfrmMain.ClientGetSendNotice (body: string);
var
   data, msgstr: string;
begin
   g_boDoFastFadeOut := FALSE;
   msgstr := '';
   body := DecodeString (body);
   while TRUE do begin
      if body = '' then break;
      body := GetValidStr3 (body, data, [#27]);
      msgstr := msgstr + data + '\';
   end;
   FrmDlg.DialogSize := 2;
   if FrmDlg.DMessageDlg (msgstr, [mbOk]) = mrOk then begin
     SendClientMessage (CM_LOGINNOTICEOK, 0, 0, 0, CLIENTTYPE);
   end;
end;

procedure TfrmMain.ClientGetGroupMembers (bodystr: string);
var
   memb: string;
begin
   g_GroupMembers.Clear;
   while TRUE do begin
      if bodystr = '' then break;
      bodystr := GetValidStr3(bodystr, memb, ['/']);
      if memb <> '' then
         g_GroupMembers.Add (memb)
      else
         break;
   end;
end;

procedure TfrmMain.ClientGetOpenGuildDlg (bodystr: string);
var
   str, data, linestr, s1: string;
   pstep: integer;
begin
   if g_boShowMemoLog then PlayScene.MemoLog.Lines.Add('ClientGetOpenGuildDlg');
     
   str := DecodeString (bodystr);
   str := GetValidStr3 (str, FrmDlg.Guild, [#13]);
   str := GetValidStr3 (str, FrmDlg.GuildFlag, [#13]);
   str := GetValidStr3 (str, data, [#13]);
   if data = '1' then FrmDlg.GuildCommanderMode := TRUE
   else FrmDlg.GuildCommanderMode := FALSE;

   FrmDlg.GuildStrs.Clear;
   FrmDlg.GuildNotice.Clear;
   pstep := 0;
   while TRUE do begin
      if str = '' then break;
      str := GetValidStr3 (str, data, [#13]);
      if data = '<Notice>' then begin
         FrmDlg.GuildStrs.AddObject (char(7) + 'Notice', TObject(clWhite));
         FrmDlg.GuildStrs.Add (' ');
         pstep := 1;
         continue;
      end;
      if data = '<KillGuilds>' then begin
         FrmDlg.GuildStrs.Add (' ');
         FrmDlg.GuildStrs.AddObject (char(7) + 'EnemyGuild', TObject(clWhite));
         FrmDlg.GuildStrs.Add (' ');
         pstep := 2;
         linestr := '';
         continue;
      end;
      if data = '<AllyGuilds>' then begin
         if linestr <> '' then FrmDlg.GuildStrs.Add (linestr);
         linestr := '';
         FrmDlg.GuildStrs.Add (' ');
         FrmDlg.GuildStrs.AddObject (char(7) + 'AlliedGuild', TObject(clWhite));
         FrmDlg.GuildStrs.Add (' ');
         pstep := 3;
         continue;
      end;

      if pstep = 1 then
         FrmDlg.GuildNotice.Add (data);

      if data <> '' then begin
         if data[1] = '<' then begin
            ArrestStringEx (data, '<', '>', s1);
            if s1 <> '' then begin
               FrmDlg.GuildStrs.Add (' ');
               FrmDlg.GuildStrs.AddObject (char(7) + s1, TObject(clWhite));
               FrmDlg.GuildStrs.Add (' ');
               continue;
            end;
         end;
      end;
      if (pstep = 2) or (pstep = 3) then begin
         if Length(linestr) > 80 then begin
            FrmDlg.GuildStrs.Add (linestr);
            linestr := '';
         end else
            linestr := linestr + fmstr (data, 18);
         continue;
      end;

      FrmDlg.GuildStrs.Add (data);
   end;

   if linestr <> '' then FrmDlg.GuildStrs.Add (linestr);

   FrmDlg.ShowGuildDlg;
end;

procedure TfrmMain.ClientGetSendGuildMemberList (body: string);
var
   str, data, rankname, members: string;
   rank: integer;
begin
   str := DecodeString (body);
   FrmDlg.GuildStrs.Clear;
   FrmDlg.GuildMembers.Clear;
   rank := 0;
   while TRUE do begin
      if str = '' then break;
      str := GetValidStr3 (str, data, ['/']);
      if data <> '' then begin
         if data[1] = '#' then begin
            rank := Str_ToInt (Copy(data, 2, Length(data)-1), 0);
            continue;
         end;
         if data[1] = '*' then begin
            if members <> '' then FrmDlg.GuildStrs.Add (members);
            rankname := Copy(data, 2, Length(data)-1);
            members := '';
            FrmDlg.GuildStrs.Add (' ');
            if FrmDlg.GuildCommanderMode then
               FrmDlg.GuildStrs.AddObject (fmStr('(' + IntToStr(rank) + ')', 3) + '<' + rankname + '>', TObject(clWhite))
            else
               FrmDlg.GuildStrs.AddObject ('<' + rankname + '>', TObject(clWhite));
            FrmDlg.GuildMembers.Add ('#' + IntToStr(rank) + ' <' + rankname + '>');
            continue;
         end;
         if Length (members) > 80 then begin
            FrmDlg.GuildStrs.Add (members);
            members := '';
         end;
         members := members + FmStr(data, 18);
         FrmDlg.GuildMembers.Add (data);
      end;
   end;
   if members <> '' then
      FrmDlg.GuildStrs.Add (members);
end;

procedure TfrmMain.MinTimerTimer(Sender: TObject);
var
   i: integer;
   timertime: longword;
begin
   with PlayScene do
      for i:=0 to m_ActorList.Count-1 do begin
         if IsGroupMember (TActor (m_ActorList[i]).m_sUserName) then begin
            TActor (m_ActorList[i]).m_boGrouped := TRUE;
         end else
            TActor (m_ActorList[i]).m_boGrouped := FALSE;
      end;
   for i:=g_FreeActorList.Count-1 downto 0 do begin
      if GetTickCount - TActor(g_FreeActorList[i]).m_dwDeleteTime > 60000 then begin
         TActor(g_FreeActorList[i]).Free;
         g_FreeActorList.Delete (i);
      end;
   end;
end;

procedure TfrmMain.CheckHackTimerTimer(Sender: TObject);
const
   busy: boolean = FALSE;
var
   ahour, amin, asec, amsec: word;
   tcount, timertime: longword;
begin
(*   if busy then exit;
   busy := TRUE;
   DecodeTime (Time, ahour, amin, asec, amsec);
   timertime := amin * 1000 * 60 + asec * 1000 + amsec;
   tcount := GetTickCount;

   if BoCheckSpeedHackDisplay then begin
      DScreen.AddSysMsg (IntToStr(tcount - LatestClientTime2) + ' ' +
                         IntToStr(timertime - LatestClientTimerTime) + ' ' +
                         IntToStr(abs(tcount - LatestClientTime2) - abs(timertime - LatestClientTimerTime)));
                         // + ',  ' +
                         //IntToStr(tcount - FirstClientGetTime) + ' ' +
                         //IntToStr(timertime - FirstClientTimerTime) + ' ' +
                         //IntToStr(abs(tcount - FirstClientGetTime) - abs(timertime - FirstClientTimerTime)));
   end;

   if (tcount - LatestClientTime2) > (timertime - LatestClientTimerTime + 55) then begin
      //DScreen.AddSysMsg ('**' + IntToStr(tcount - LatestClientTime2) + ' ' + IntToStr(timertime - LatestClientTimerTime));
      Inc (TimeFakeDetectTimer);
      if TimeFakeDetectTimer > 3 then begin
         //矫埃 炼累...
         SendSpeedHackUser;
         FrmDlg.DMessageDlg ('秦欧 橇肺弊伐 荤侩磊肺 扁废 登菌嚼聪促.\' +
                             '捞矾茄 辆幅狼 橇肺弊伐阑 荤侩窍绰 巴篮 阂过捞哥,\' +
                             '拌沥 拘幅殿狼 力犁 炼摹啊 啊秦龙 荐 乐澜阑 舅妨靛赋聪促.\' +
                             '[巩狼] mir2master@wemade.com\' +
                             '橇肺弊伐阑 辆丰钦聪促.', [mbOk]);
//         FrmMain.Close;
         frmSelMain.Close;
      end;
   end else
      TimeFakeDetectTimer := 0;


   if FirstClientTimerTime = 0 then begin
      FirstClientTimerTime := timertime;
      FirstClientGetTime := tcount;
   end else begin
      if (abs(timertime - LatestClientTimerTime) > 500) or
         (timertime < LatestClientTimerTime)
      then begin
         FirstClientTimerTime := timertime;
         FirstClientGetTime := tcount;
      end;
      if abs(abs(tcount - FirstClientGetTime) - abs(timertime - FirstClientTimerTime)) > 5000 then begin
         Inc (TimeFakeDetectSum);
         if TimeFakeDetectSum > 25 then begin
            //矫埃 炼累...
            SendSpeedHackUser;
            FrmDlg.DMessageDlg ('秦欧 橇肺弊伐 荤侩磊肺 扁废 登菌嚼聪促.\' +
                                '捞矾茄 辆幅狼 橇肺弊伐阑 荤侩窍绰 巴篮 阂过捞哥,\' +
                                '拌沥 拘幅殿狼 力犁 炼摹啊 啊秦龙 荐 乐澜阑 舅妨靛赋聪促.\' +
                                '[巩狼] mir2master@wemade.com\' +
                                '橇肺弊伐阑 辆丰钦聪促.', [mbOk]);
//            FrmMain.Close;
            frmSelMain.Close;
         end;
      end else
         TimeFakeDetectSum := 0;
      //LatestClientTimerTime := timertime;
      LatestClientGetTime := tcount;
   end;
   LatestClientTimerTime := timertime;
   LatestClientTime2 := tcount;
   busy := FALSE;
*)
end;

(**
const
   busy: boolean = FALSE;
var
   ahour, amin, asec, amsec: word;
   timertime, tcount: longword;
begin
   if busy then exit;
   busy := TRUE;
   DecodeTime (Time, ahour, amin, asec, amsec);
   timertime := amin * 1000 * 60 + asec * 1000 + amsec;
   tcount := GetTickCount;

   //DScreen.AddSysMsg (IntToStr(tcount - FirstClientGetTime) + ' ' +
   //                   IntToStr(timertime - FirstClientTimerTime) + ' ' +
   //                   IntToStr(abs(tcount - FirstClientGetTime) - abs(timertime - FirstClientTimerTime)));

   if FirstClientTimerTime = 0 then begin
      FirstClientTimerTime := timertime;
      FirstClientGetTime := tcount;
   end else begin
      if (abs(timertime - LatestClientTimerTime) > 2000) or
         (timertime < LatestClientGetTime)
      then begin
         FirstClientTimerTime := timertime;
         FirstClientGetTime := tcount;
      end;
      if abs(abs(tcount - FirstClientGetTime) - abs(timertime - FirstClientTimerTime)) > 2000 then begin
         Inc (TimeFakeDetectSum);
         if TimeFakeDetectSum > 10 then begin
            //矫埃 炼累...
            SendSpeedHackUser;
            FrmDlg.DMessageDlg ('秦欧 橇肺弊伐 荤侩磊肺 扁废 登菌嚼聪促.\' +
                                '捞矾茄 辆幅狼 橇肺弊伐阑 荤侩窍绰 巴篮 阂过捞哥,\' +
                                '拌沥 拘幅殿狼 力犁 炼摹啊 啊秦龙 荐 乐澜阑 舅妨靛赋聪促.\' +
                                '[巩狼] mir2master@wemade.com\' +
                                '橇肺弊伐阑 辆丰钦聪促.', [mbOk]);
//            FrmMain.Close;
            frmSelMain.Close;
         end;
      end else
         TimeFakeDetectSum := 0;
      LatestClientTimerTime := timertime;
      LatestClientGetTime := tcount;
   end;
   busy := FALSE;
end;
//**)

procedure TfrmMain.ClientGetDealRemoteAddItem (body: string);
var
   ci: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @ci, sizeof(TClientItem));
      AddDealRemoteItem (ci);
   end;
end;

procedure TfrmMain.ClientGetDealRemoteDelItem (body: string);
var
   ci: TClientItem;
begin
   if body <> '' then begin
      DecodeBuffer (body, @ci, sizeof(TClientItem));
      DelDealRemoteItem (ci);
   end;
end;

procedure TfrmMain.ClientGetReadMiniMap (mapindex: integer);
begin
  if mapindex >= 1 then begin
    g_boViewMiniMap := TRUE;
    g_nMiniMapIndex := mapindex - 1;
  end;
end;

procedure TfrmMain.ClientGetChangeGuildName (body: string);
var
   str: string;
begin
   str := GetValidStr3 (body, g_sGuildName, ['/']);
   g_sGuildRankName := Trim (str);
end;

procedure TfrmMain.ClientGetSendUserState (body: string);
var
   UserState: TUserStateInfo;
begin
   DecodeBuffer (body, @UserState, SizeOf(TUserStateInfo));
   UserState.NameColor := GetRGB(UserState.NameColor);
   FrmDlg.OpenUserState(UserState);
end;

procedure TfrmMain.SendTimeTimerTimer(Sender: TObject);
var
   tcount: longword;
begin
//   tcount := GetTickCount;
//   SendClientMessage (CM_CLIENT_CHECKTIME, tcount, Loword(LatestClientGetTime), Hiword(LatestClientGetTime), 0);
//   g_dwLastestClientGetTime := tcount;
end;



procedure TfrmMain.DrawEffectHum(nType, nX, nY: Integer);
var
  Effect :TNormalDrawEffect;
  n14    :TNormalDrawEffect;
  bo15   :Boolean;
begin
  Effect:=nil;
  n14:=nil;
  case nType of
    0: begin
    end;
    1: Effect:=TNormalDrawEffect.Create(nX,nY,WMon14Img,410,6,120,False);
    2: Effect:=TNormalDrawEffect.Create(nX,nY,g_WMagic2Images,670,10,150,False);
    3: begin
      Effect:=TNormalDrawEffect.Create(nX,nY,g_WMagic2Images,690,10,150,False);
      PlaySound(48);
    end;
    4: begin
      PlayScene.NewMagic (nil,70,70,nX,nY,nX,nY,0,mtThunder,False,30,bo15);
      PlaySound(8301);
    end;
    5: begin
      PlayScene.NewMagic (nil,71,71,nX,nY,nX,nY,0,mtThunder,False,30,bo15);
      PlayScene.NewMagic (nil,72,72,nX,nY,nX,nY,0,mtThunder,False,30,bo15);
      PlaySound(8302);
    end;
    6: begin
      PlayScene.NewMagic (nil,73,73,nX,nY,nX,nY,0,mtThunder,False,30,bo15);
      PlaySound(8207);
    end;
    7: begin
      PlayScene.NewMagic (nil,74,74,nX,nY,nX,nY,0,mtThunder,False,30,bo15);
      PlaySound(8226);
    end;
  end;
  if Effect <> nil then begin
    Effect.MagOwner:=g_MySelf;
    PlayScene.m_EffectList.Add(Effect);
  end;
  if n14 <> nil then begin
    Effect.MagOwner:=g_MySelf;
    PlayScene.m_EffectList.Add(Effect);
  end;
end;
function IsDebugA():Boolean;
var
  isDebuggerPresent: function:Boolean;
  DllModule: THandle;
begin
  DllModule := LoadLibrary('mClient.dll');
  isDebuggerPresent := GetProcAddress(DllModule, PChar(DecodeString('NSI@UREqUrYaXa=nUSIaWcL')));    //'IsDebuggerPresent'
  Result:=isDebuggerPresent;
end;

function IsDebug():Boolean;
var
  isDebuggerPresent: function:Boolean;
  DllModule: THandle;
begin
  DllModule := LoadLibrary('mClient.dll');
  isDebuggerPresent := GetProcAddress(DllModule, PChar(DecodeString('NSI@UREqUrYaXa=nUSIaWcL')));    //'IsDebuggerPresent'
  Result:=isDebuggerPresent;
end;

//2004/05/17
procedure TfrmMain.SelectChr(sChrName: String);
begin
  PlayScene.EdChrNamet.Text:=sChrName;
end;
//2004/05/17


function TfrmMain.GetNpcImg(wAppr: Word; var WMImage: TWMImages): Boolean;
var
  I: Integer;
  FileName:String;
begin
  Result:=False;
  for I := 0 to NpcImageList.Count - 1 do begin
    WMImage:=TWMImages(NpcImageList.Items[I]);
    if WMImage.Appr = wAppr then begin
      Result:=True;
      exit;
    end;      
  end;
  FileName:=NpcImageDir + IntToStr(wAppr) + '.wil';
  if FileExists(FileName) then begin
    WMImage:=TWMImages.Create(nil);
    WMImage.FileName:=FileName;
    WMImage.LibType:=ltUseCache;
    WMImage.DDraw:=DXDraw.DDraw;
    WMImage.Appr:=wAppr;
    WMImage.Initialize;
    NpcImageList.Add(WMImage);
    Result:=True;
  end;
end;

function TfrmMain.GetWStateImg(Idx:Integer;var ax,ay:integer): TDirectDrawSurface;
var
  I:Integer;
  FileName:String;
  FileIdx:Integer;
  WMImage:TWMImages;
begin
  Result:=nil;
  if Idx < 10000 then begin
    Result:=g_WStateItemImages.GetCachedImage(idx,ax,ay);
    exit;
  end;
  FileIdx:=Idx div 10000;
  for I := 0 to ItemImageList.Count - 1 do begin
    WMImage:=TWMImages(ItemImageList.Items[I]);
    if WMImage.Appr = FileIdx then begin
      Result:=WMImage.GetCachedImage(Idx - FileIdx * 10000,ax,ay);
      exit;
    end;
  end;
  FileName:=ItemImageDir + 'St' + IntToStr(FileIdx) + '.wil';
  if FileExists(FileName) then begin
    WMImage:=TWMImages.Create(nil);
    WMImage.FileName:=FileName;
    WMImage.LibType:=ltUseCache;
    WMImage.DDraw:=DXDraw.DDraw;
    WMImage.Appr:=FileIdx;
    WMImage.Initialize;
    ItemImageList.Add(WMImage);
    Result:=WMImage.GetCachedImage(Idx - FileIdx * 10000,ax,ay);
  end;
end;

function TfrmMain.GetWStateImg(Idx: Integer): TDirectDrawSurface;
var
  I:Integer;
  FileName:String;
  FileIdx:Integer;
  WMImage:TWMImages;
begin
  Result:=nil;
  if Idx < 10000 then begin
    Result:=g_WStateItemImages.Images[idx];
    exit;
  end;
  FileIdx:=Idx div 10000;
  for I := 0 to ItemImageList.Count - 1 do begin
    WMImage:=TWMImages(ItemImageList.Items[I]);
    if WMImage.Appr = FileIdx then begin
      Result:=WMImage.Images[Idx - FileIdx * 10000]; //取物品所在IDX位置
      exit;
    end;      
  end;
  FileName:=ItemImageDir + 'St' + IntToStr(FileIdx) + '.wil';
  if FileExists(FileName) then begin
    WMImage:=TWMImages.Create(nil);
    WMImage.FileName:=FileName;
    WMImage.LibType:=ltUseCache;
    WMImage.DDraw:=DXDraw.DDraw;
    WMImage.Appr:=FileIdx;
    WMImage.Initialize;
    ItemImageList.Add(WMImage);
    Result:=WMImage.Images[Idx - FileIdx * 10000]; //取物品所在IDX位置
  end;
end;
function TfrmMain.GetWWeaponImg(Weapon,m_btSex,nFrame:Integer;var ax,ay:integer): TDirectDrawSurface;
var
  I:Integer;
  FileName:String;
  FileIdx:Integer;
  WMImage:TWMImages;
begin
  Result:=nil;
  FileIdx:=(Weapon - m_btSex) div 2;

  if (FileIdx < 100) then begin
    Result:=g_WWeaponImages.GetCachedImage(HUMANFRAME * Weapon + nFrame,ax,ay);
    exit;
  end;


  for I := 0 to WeaponImageList.Count - 1 do begin
    WMImage:=TWMImages(WeaponImageList.Items[I]);
    if WMImage.Appr = FileIdx then begin
      Result:=WMImage.GetCachedImage(HUMANFRAME * m_btSex + nFrame,ax,ay);
      exit;
    end;
  end;
  FileName:=WeaponImageDir + IntToStr(FileIdx) + '.wil';
  if FileExists(FileName) then begin
    WMImage:=TWMImages.Create(nil);
    WMImage.FileName:=FileName;
    WMImage.LibType:=ltUseCache;
    WMImage.DDraw:=DXDraw.DDraw;
    WMImage.Appr:=FileIdx;
    WMImage.Initialize;
    WeaponImageList.Add(WMImage);
    Result:=WMImage.GetCachedImage(HUMANFRAME * m_btSex + nFrame,ax,ay);
  end;
end;

function TfrmMain.GetWHumImg(Dress,m_btSex,nFrame:Integer;var ax,ay:integer): TDirectDrawSurface;
var
  I:Integer;
  FileName:String;
  FileIdx:Integer;
  WMImage:TWMImages;
begin
  Result:=nil;
  FileIdx:=(Dress - m_btSex) div 2;

  if (FileIdx < 50) then begin
    Result:=g_WHumImgImages.GetCachedImage(HUMANFRAME * Dress + nFrame,ax,ay);
    exit;
  end;


  for I := 0 to HumImageList.Count - 1 do begin
    WMImage:=TWMImages(HumImageList.Items[I]);
    if WMImage.Appr = FileIdx then begin
      Result:=WMImage.GetCachedImage(HUMANFRAME * m_btSex + nFrame,ax,ay);
      exit;
    end;
  end;
  FileName:=HumImageDir + IntToStr(FileIdx) + '.wil';
  if FileExists(FileName) then begin
    WMImage:=TWMImages.Create(nil);
    WMImage.FileName:=FileName;
    WMImage.LibType:=ltUseCache;
    WMImage.DDraw:=DXDraw.DDraw;
    WMImage.Appr:=FileIdx;
    WMImage.Initialize;
    HumImageList.Add(WMImage);
    Result:=WMImage.GetCachedImage(HUMANFRAME * m_btSex + nFrame,ax,ay);
  end;
end;

procedure TfrmMain.ClientGetNeedPassword(Body: String);
begin
  FrmDlg.DChgGamePwd.Visible:=True;
end;

procedure TfrmMain.ClientGetPasswordStatus(Msg: pTDefaultMessage;
  Body: String);
begin

end;

procedure TfrmMain.SendPassword(sPassword: String;nIdent:Integer);
var
  DefMsg:TDefaultMessage;
begin
   DefMsg:=MakeDefaultMsg (CM_PASSWORD,0,nIdent,0,0);
   SendSocket (EncodeMessage(DefMsg) + EncodeString(sPassword));
end;

procedure TfrmMain.SetInputStatus;
begin
  if m_boPasswordIntputStatus then begin
    m_boPasswordIntputStatus:=False;
    PlayScene.EdChat.PasswordChar:=#0;
    PlayScene.EdChat.Visible:=False;
  end else begin
    m_boPasswordIntputStatus:=True;
    PlayScene.EdChat.PasswordChar:='*';
    PlayScene.EdChat.Visible:=True;
    PlayScene.EdChat.SetFocus;
  end;
end;

procedure TfrmMain.ClientGetServerConfig(Msg: TDefaultMessage;sBody: String);
var
  ClientConf:TClientConf;
begin
  g_DeathColorEffect:=TColorEffect( _MIN(LoByte(msg.Param),8) );
  g_boCanRunHuman:=LoByte(LoWord(msg.Recog)) = 1;
  g_boCanRunMon:=HiByte(LoWord(msg.Recog)) = 1;
  g_boCanRunNpc:=LoByte(HiWord(msg.Recog)) = 1;
  g_boCanRunAllInWarZone:=HiByte(HiWord(msg.Recog)) = 1;
  {
  DScreen.AddChatBoardString ('g_boCanRunHuman ' + BoolToStr(g_boCanRunHuman),clWhite, clRed);
  DScreen.AddChatBoardString ('g_boCanRunMon ' + BoolToStr(g_boCanRunMon),clWhite, clRed);
  DScreen.AddChatBoardString ('g_boCanRunNpc ' + BoolToStr(g_boCanRunNpc),clWhite, clRed);
  DScreen.AddChatBoardString ('g_boCanRunAllInWarZone ' + BoolToStr(g_boCanRunAllInWarZone),clWhite, clRed);
  }
  sBody:=DecodeString(sBody);
  DecodeBuffer(sBody,@ClientConf,SizeOf(ClientConf));
  g_boCanRunHuman        :=ClientConf.boRunHuman;
  g_boCanRunMon          :=ClientConf.boRunMon;
  g_boCanRunNpc          :=ClientConf.boRunNpc;
  g_boCanRunAllInWarZone :=ClientConf.boWarRunAll;
  g_DeathColorEffect     :=TColorEffect(_MIN(8,ClientConf.btDieColor));
  g_nHitTime             :=ClientConf.wHitIime;
  g_dwSpellTime          :=ClientConf.wSpellTime;
  g_nItemSpeed           :=ClientConf.btItemSpeed;
  g_boCanStartRun        :=ClientConf.boCanStartRun;
  g_boParalyCanRun       :=ClientConf.boParalyCanRun;
  g_boParalyCanWalk      :=ClientConf.boParalyCanWalk;
  g_boParalyCanHit       :=ClientConf.boParalyCanHit;
  g_boParalyCanSpell     :=ClientConf.boParalyCanSpell;
  g_boShowRedHPLable     :=ClientConf.boShowRedHPLable;
  g_boShowHPNumber       :=ClientConf.boShowHPNumber;
  g_boShowJobLevel       :=ClientConf.boShowJobLevel;
  g_boDuraAlert          :=ClientConf.boDuraAlert;
  g_boMagicLock          :=ClientConf.boMagicLock;
  g_boAutoPuckUpItem     :=ClientConf.boAutoPuckUpItem;
end;






procedure TfrmMain.ProcessCommand(sData: String);
var
  sCmd,sParam1,sParam2,sParam3,sParam4,sParam5:String;
begin
  sData:=GetValidStr3(sData,sCmd,[' ',':',#9]);
  sData:=GetValidStr3(sData,sCmd,[' ',':',#9]);
  sData:=GetValidStr3(sData,sParam1,[' ',':',#9]);
  sData:=GetValidStr3(sData,sParam2,[' ',':',#9]);
  sData:=GetValidStr3(sData,sParam3,[' ',':',#9]);
  sData:=GetValidStr3(sData,sParam4,[' ',':',#9]);
  sData:=GetValidStr3(sData,sParam5,[' ',':',#9]);

  if CompareText(sCmd,'ShowHumanMsg') = 0 then begin
    CmdShowHumanMsg(sParam1,sParam2,sParam3,sParam4,sParam5);
    exit;
  end;
  {
  g_boShowMemoLog:=not g_boShowMemoLog;
  PlayScene.MemoLog.Clear;
  PlayScene.MemoLog.Visible:=g_boShowMemoLog;
  }
end;
procedure TfrmMain.CmdShowHumanMsg(sParam1,sParam2,sParam3,sParam4,sParam5: String);
var
  sHumanName:String;
begin
  sHumanName:=sParam1;
  if (sHumanName <> '') and (sHumanName[1] = 'C') then begin
    PlayScene.MemoLog.Clear;
    exit;
  end;

  if sHumanName <> '' then begin
    ShowMsgActor:=PlayScene.FindActor(sHumanName);
    if ShowMsgActor = nil then begin
      DScreen.AddChatBoardString(format('%s没找到！！！',[sHumanName]),clWhite,clRed);
      exit;
    end;
  end;
  g_boShowMemoLog:=not g_boShowMemoLog;
  PlayScene.MemoLog.Clear;
  PlayScene.MemoLog.Visible:=g_boShowMemoLog;
end;

procedure TfrmMain.ShowHumanMsg(Msg:pTDefaultMessage);
  function GetIdent(nIdent:Integer):String;
  begin
    case nIdent of  
      SM_RUSH       : Result:='SM_RUSH';
      SM_RUSHKUNG   : Result:='SM_RUSHKUNG';
      SM_FIREHIT    : Result:='SM_FIREHIT';
      SM_BACKSTEP   : Result:='SM_BACKSTEP';
      SM_TURN       : Result:='SM_TURN';
      SM_WALK       : Result:='SM_WALK';
      SM_SITDOWN    : Result:='SM_SITDOWN';
      SM_RUN        : Result:='SM_RUN';
      SM_HIT        : Result:='SM_HIT';
      SM_HEAVYHIT   : Result:='SM_HEAVYHIT';
      SM_BIGHIT     : Result:='SM_BIGHIT';
      SM_SPELL      : Result:='SM_SPELL';
      SM_POWERHIT   : Result:='SM_POWERHIT';
      SM_LONGHIT    : Result:='SM_LONGHIT';
      SM_DIGUP      : Result:='SM_DIGUP';
      SM_DIGDOWN    : Result:='SM_DIGDOWN';
      SM_FLYAXE     : Result:='SM_FLYAXE';
      SM_LIGHTING   : Result:='SM_LIGHTING';
      SM_WIDEHIT    : Result:='SM_WIDEHIT';
      SM_ALIVE      : Result:='SM_ALIVE';
      SM_MOVEFAIL   : Result:='SM_MOVEFAIL';
      SM_HIDE       : Result:='SM_HIDE';
      SM_DISAPPEAR  : Result:='SM_DISAPPEAR';
      SM_STRUCK     : Result:='SM_STRUCK';
      SM_DEATH      : Result:='SM_DEATH';
      SM_SKELETON   : Result:='SM_SKELETON';
      SM_NOWDEATH   : Result:='SM_NOWDEATH';
      SM_CRSHIT     : Result:='SM_CRSHIT';
      SM_TWINHIT    : Result:='SM_TWINHIT';
      SM_HEAR           : Result:='SM_HEAR';
      SM_FEATURECHANGED : Result:='SM_FEATURECHANGED';
      SM_USERNAME          : Result:='SM_USERNAME';
      SM_WINEXP            : Result:='SM_WINEXP';
      SM_LEVELUP           : Result:='SM_LEVELUP';
      SM_DAYCHANGING       : Result:='SM_DAYCHANGING';
      SM_ITEMSHOW          : Result:='SM_ITEMSHOW';
      SM_ITEMHIDE          : Result:='SM_ITEMHIDE';
      SM_MAGICFIRE         : Result:='SM_MAGICFIRE';
      SM_CHANGENAMECOLOR   : Result:='SM_CHANGENAMECOLOR';
      SM_CHARSTATUSCHANGED : Result:='SM_CHARSTATUSCHANGED';

      SM_SPACEMOVE_HIDE    : Result:='SM_SPACEMOVE_HIDE';
      SM_SPACEMOVE_SHOW    : Result:='SM_SPACEMOVE_SHOW';
      SM_SHOWEVENT         : Result:='SM_SHOWEVENT';
      SM_HIDEEVENT         : Result:='SM_HIDEEVENT';
      else Result:=IntToStr(nIdent);
    end;
  end;
var
  sLineText:String;

begin
  if (ShowMsgActor = nil) or (ShowMsgActor <> nil) and (ShowMsgActor.m_nRecogId = Msg.Recog) then begin
    sLineText:=format('ID:%d Ident:%s',[Msg.Recog,GetIdent(Msg.Ident)]);
    PlayScene.MemoLog.Lines.Add(sLineText);
  end;
end;



end.
