unit Castle;

interface
uses
  Windows, Classes, SysUtils, IniFiles, Grobal2, SDK, ObjBase, ObjMon2, Guild, Envir;
const
  MAXCASTLEARCHER = 12;
  MAXCALSTEGUARD = 4;
type
  TDefenseUnit = record
    nMainDoorX: Integer; //0x00
    nMainDoorY: Integer; //0x04
    sMainDoorName: string; //0x08
    boXXX: Boolean; //0x0C
    wMainDoorHP: Word; //0x10
    MainDoor: TBaseObject;
    LeftWall: TBaseObject;
    CenterWall: TBaseObject;
    RightWall: TBaseObject;
    Archer: TBaseObject;
  end;
  pTDefenseUnit = ^TDefenseUnit;
  TObjUnit = record
    nX: Integer; //0x0
    nY: Integer; //0x4
    sName: string; //0x8
    //  nStatus     :Integer;   //0x0C
    nStatus: Boolean; //0x0C
    nHP: Integer; //0x10
    BaseObject: TBaseObject; //0x14
  end;
  pTObjUnit = ^TObjUnit;
  TAttackerInfo = record
    AttackDate: TDateTime;
    sGuildName: string;
    Guild: TGUild;
  end;
  pTAttackerInfo = ^TAttackerInfo;
  TUserCastle = class
    m_MapCastle: TEnvirnoment;   //0x4    城堡所在地图
    m_MapPalace: TEnvirnoment;   //0x8    皇宫所在地图
    m_MapSecret: TEnvirnoment;   //0xC    密道所在地图
    m_DoorStatus: pTDoorStatus;  //0x10   皇宫门状态
    m_sMapName: string;          //0x14   城堡所在地图名
    m_sName: string;             //0x18   城堡名称
    m_sOwnGuild: string;         //0x1C   所属行会名称
    m_MasterGuild: TGUild;       //0x20   所属行会
    m_sHomeMap: string;          //0x24   行会回城点地图
    m_nHomeX: Integer;           //0x28   行会回城点X
    m_nHomeY: Integer;           //0x2C   行会回城点Y
    m_ChangeDate: TDateTime;     //0x30
    m_WarDate: TDateTime;        //0x38
    m_boStartWar: Boolean;       //0x40   是否开始攻城
    m_boUnderWar: Boolean;       //0x41   是否正在攻城
    m_boShowOverMsg: Boolean;    //0x42   是否已显示攻城结束信息
    m_dwStartCastleWarTick: LongWord; //0x44
    m_dwSaveTick: LongWord;      //0x48
    m_AttackWarList: TList;      //0x4C
    m_AttackGuildList: TList;    //0x50
    m_MainDoor: TObjUnit;        //0x54
    m_LeftWall: TObjUnit;        //0x6C
    m_CenterWall: TObjUnit;      //0x84
    m_RightWall: TObjUnit;       //0x9C
    m_Guard: array[0..MAXCALSTEGUARD - 1] of TObjUnit; //0xB4
    m_Archer: array[0..MAXCASTLEARCHER - 1] of TObjUnit; //0x114 0x264
    m_IncomeToday: TDateTime;  //0x238
    m_nTotalGold: Integer;     //0x240    资金总数
    m_nTodayIncome: Integer;   //0x244    当天收入
    m_nWarRangeX: Integer;     //攻城区域范围X
    m_nWarRangeY: Integer;     //攻城区域范围Y
    m_boStatus: Boolean;
    m_sPalaceMap: string;      //皇宫所在地图
    m_sSecretMap: string;      //密道所在地图
    m_nPalaceDoorX: Integer;   //皇宫座标X
    m_nPalaceDoorY: Integer;   //皇宫座标Y
    m_sConfigDir: string;
    m_EnvirList: TStringList;

    m_nTechLevel: Integer;      //技术等级
    m_nPower: Integer;          //能源
  private
    procedure LoadAttackSabukWall();
    //procedure SaveConfigFile();
    procedure LoadConfig();
    procedure SaveAttackSabukWall();
    function InAttackerList(Guild: TGUild): Boolean;
    procedure SetTechLevel(nLevel: Integer);
    procedure SetPower(nPower: Integer);
    function m_nChiefItemCount: Integer;
  public
    constructor Create(sCastleDir: string);
    destructor Destroy; override;
    procedure Initialize();
    procedure Run();

    procedure SaveConfigFile();
    procedure Save();
    function InCastleWarArea(Envir: TEnvirnoment; nX, nY: Integer): Boolean;
    function IsMember(Cert: TBaseObject): Boolean;
    function IsMasterGuild(Guild: TGUild): Boolean;
    function IsAttackGuild(Guild: TGUild): Boolean;
    function IsAttackAllyGuild(Guild: TGUild): Boolean;
    function IsDefenseGuild(Guild: TGUild): Boolean;
    function IsDefenseAllyGuild(Guild: TGUild): Boolean;

    function CanGetCastle(Guild: TGUild): Boolean;
    procedure GetCastle(Guild: TGUild);
    procedure StartWallconquestWar;
    procedure StopWallconquestWar();
    function InPalaceGuildCount(): Integer;
    function GetHomeX(): Integer;
    function GetHomeY(): Integer;
    function GetMapName(): string;
    function AddAttackerInfo(Guild: TGUild): Boolean;
    function CheckInPalace(nX, nY: Integer; Cert: TBaseObject): Boolean;
    function GetWarDate(): string;
    function GetAttackWarList(): string;
    procedure IncRateGold(nGold: Integer);
    function WithDrawalGolds(PlayObject: TPlayObject; nGold: Integer): Integer;
    function ReceiptGolds(PlayObject: TPlayObject; nGold: Integer): Integer;
    procedure MainDoorControl(boClose: Boolean);
    function RepairDoor(): Boolean;
    function RepairWall(nWallIndex: Integer): Boolean;
    property nTechLevel: Integer read m_nTechLevel write SetTechLevel;
    property nPower: Integer read m_nPower write SetPower;
  end;

  TCastleManager = class
  private

    CriticalSection: TRTLCriticalSection;
  protected

  public
    m_CastleList: TList;
    constructor Create();
    destructor Destroy; override;
    procedure LoadCastleList();
    procedure SaveCastleList();
    procedure Initialize();
    procedure Lock;
    procedure UnLock;
    procedure Run();
    procedure Save();
    function Find(sCASTLENAME: string): TUserCastle;
    function GetCastle(nIndex: Integer): TUserCastle;
    function InCastleWarArea(BaseObject: TBaseObject): TUserCastle; overload;
    function InCastleWarArea(Envir: TEnvirnoment; nX, nY: Integer): TUserCastle; overload;
    function IsCastleMember(BaseObject: TBaseObject): TUserCastle;
    function IsCastlePalaceEnvir(Envir: TEnvirnoment): TUserCastle;
    function IsCastleEnvir(Envir: TEnvirnoment): TUserCastle;
    procedure GetCastleGoldInfo(List: TStringList);
    procedure GetCastleNameList(List: TStringList);
    procedure IncRateGold(nGold: Integer);
  end;
implementation

uses UsrEngn, M2Share, HUtil32;

{ TUserCastle }
constructor TUserCastle.Create(sCastleDir: string); //0048E438
begin
  m_MasterGuild := nil;
  m_sHomeMap := g_Config.sCastleHomeMap {'3'};
  m_nHomeX := g_Config.nCastleHomeX {644};
  m_nHomeY := g_Config.nCastleHomeY {290};
  m_sName := g_Config.sCASTLENAME {'沙巴克'};

  m_sConfigDir := sCastleDir;
  m_sPalaceMap := '0150';
  m_sSecretMap := 'D701';
  m_MapCastle := nil;
  m_DoorStatus := nil;
  m_boStartWar := False;
  m_boUnderWar := False;
  m_boShowOverMsg := False;
  m_AttackWarList := TList.Create;
  m_AttackGuildList := TList.Create;
  m_dwSaveTick := 0;
  m_nWarRangeX := g_Config.nCastleWarRangeX;
  m_nWarRangeY := g_Config.nCastleWarRangeY;
  m_EnvirList := TStringList.Create;
end;
destructor TUserCastle.Destroy; //0048E51C
var
  i: Integer;
begin
  for i := 0 to m_AttackWarList.Count - 1 do
  begin
    Dispose(pTAttackerInfo(m_AttackWarList.Items[i]));
  end;
  m_AttackWarList.Free;
  m_AttackGuildList.Free;
  m_EnvirList.Free;
  inherited;
end;
procedure TUserCastle.Initialize; //0048E564
var
  i: Integer;
  ObjUnit: pTObjUnit;
  Door: pTDoorInfo;
begin
  LoadConfig();
  LoadAttackSabukWall();
  if g_MapManager.GetMapOfServerIndex(m_sMapName) = nServerIndex then
  begin
    //m_MapPalace:=EnvirList.FindMap('0150');
    m_MapPalace := g_MapManager.FindMap(m_sPalaceMap);
    if m_MapPalace = nil then
    begin
      MainOutMessage(Format('%s No map found. ( No inner wall map of wall conquest war )', [m_sPalaceMap]));
    end;
    m_MapSecret := g_MapManager.FindMap(m_sSecretMap);
    if m_MapSecret = nil then
    begin
      MainOutMessage(Format('%s - secret map not found !!', [m_sSecretMap]));
      //ShowMessage('0150 没有找到地图...');
    end;
    m_MapCastle := g_MapManager.FindMap(m_sMapName);
    if m_MapCastle <> nil then
    begin
      m_MainDoor.BaseObject := UserEngine.RegenMonsterByName(m_sMapName, m_MainDoor.nX, m_MainDoor.nY, m_MainDoor.sName);
      if m_MainDoor.BaseObject <> nil then
      begin
        m_MainDoor.BaseObject.m_WAbil.HP := m_MainDoor.nHP;
        m_MainDoor.BaseObject.m_Castle := Self;
//         if MainDoor.nStatus <> 0 then begin
        if m_MainDoor.nStatus then
        begin
          TCastleDoor(m_MainDoor.BaseObject).Open;
        end;
//         MainOutMessage(format('Name:%s Map:%s X:%d Y:%d HP:%d',[MainDoor.BaseObject.m_sCharName,MainDoor.BaseObject.m_sMapName,MainDoor.BaseObject.m_nCurrX,MainDoor.BaseObject.m_nCurrY,MainDoor.BaseObject.m_Wabil.HP]));
      end else
      begin
        MainOutMessage('[Error] UserCastle.Initialize MainDoor.UnitObj = nil');
      end;

      m_LeftWall.BaseObject := UserEngine.RegenMonsterByName(m_sMapName, m_LeftWall.nX, m_LeftWall.nY, m_LeftWall.sName);
      if m_LeftWall.BaseObject <> nil then
      begin
        m_LeftWall.BaseObject.m_WAbil.HP := m_LeftWall.nHP;
        m_LeftWall.BaseObject.m_Castle := Self;
//         MainOutMessage(format('Name:%s Map:%s X:%d Y:%d HP:%d',[LeftWall.BaseObject.m_sCharName,LeftWall.BaseObject.m_sMapName,LeftWall.BaseObject.m_nCurrX,LeftWall.BaseObject.m_nCurrY,LeftWall.BaseObject.m_Wabil.HP]));
      end else
      begin
        MainOutMessage('[Error] UserCastle.Initialize LeftWall.UnitObj = nil');
      end;

      m_CenterWall.BaseObject := UserEngine.RegenMonsterByName(m_sMapName, m_CenterWall.nX, m_CenterWall.nY, m_CenterWall.sName);
      if m_CenterWall.BaseObject <> nil then
      begin
        m_CenterWall.BaseObject.m_WAbil.HP := m_CenterWall.nHP;
        m_CenterWall.BaseObject.m_Castle := Self;
//         MainOutMessage(format('Name:%s Map:%s X:%d Y:%d HP:%d',[CenterWall.BaseObject.m_sCharName,CenterWall.BaseObject.m_sMapName,CenterWall.BaseObject.m_nCurrX,CenterWall.BaseObject.m_nCurrY,CenterWall.BaseObject.m_Wabil.HP]));
      end else
      begin
        MainOutMessage('[Error] UserCastle.Initialize CenterWall.UnitObj = nil');
      end;

      m_RightWall.BaseObject := UserEngine.RegenMonsterByName(m_sMapName, m_RightWall.nX, m_RightWall.nY, m_RightWall.sName);
      if m_RightWall.BaseObject <> nil then
      begin
        m_RightWall.BaseObject.m_WAbil.HP := m_RightWall.nHP;
        m_RightWall.BaseObject.m_Castle := Self;
//         MainOutMessage(format('Name:%s Map:%s X:%d Y:%d HP:%d',[RightWall.BaseObject.m_sCharName,RightWall.BaseObject.m_sMapName,RightWall.BaseObject.m_nCurrX,RightWall.BaseObject.m_nCurrY,RightWall.BaseObject.m_Wabil.HP]));
      end else
      begin
        MainOutMessage('[Error] UserCastle.Initialize RightWall.UnitObj = nil');
      end;
      for i := Low(m_Archer) to High(m_Archer) do
      begin
        ObjUnit := @m_Archer[i];
        if ObjUnit.nHP <= 0 then Continue;
        ObjUnit.BaseObject := UserEngine.RegenMonsterByName(m_sMapName, ObjUnit.nX, ObjUnit.nY, ObjUnit.sName);
        if ObjUnit.BaseObject <> nil then
        begin
          ObjUnit.BaseObject.m_WAbil.HP := m_Archer[i].nHP;
          ObjUnit.BaseObject.m_Castle := Self;
          TGuardUnit(ObjUnit.BaseObject).m_nX550 := ObjUnit.nX;
          TGuardUnit(ObjUnit.BaseObject).m_nY554 := ObjUnit.nY;
          TGuardUnit(ObjUnit.BaseObject).m_nDirection := 3;
        end else
        begin
          //MainOutMessage('[错误信息] UserCastle.Initialize Archer -> UnitObj = nil');
          MainOutMessage('[Error] UserCastle.Initialize Archer -> UnitObj = nil');
        end;
      end;
      for i := Low(m_Guard) to High(m_Guard) do
      begin
        ObjUnit := @m_Guard[i];
        if ObjUnit.nHP <= 0 then Continue;
        ObjUnit.BaseObject := UserEngine.RegenMonsterByName(m_sMapName, ObjUnit.nX, ObjUnit.nY, ObjUnit.sName);
        if ObjUnit.BaseObject <> nil then
        begin
          ObjUnit.BaseObject.m_WAbil.HP := m_Guard[i].nHP;
        end else
        begin
          MainOutMessage('[Error] UserCastle.Initialize Guard -> UnitObj = nil');
          //MainOutMessage('[错误信息] UserCastle.Initialize Guard -> UnitObj = nil');
        end;
      end;
      for i := 0 to m_MapCastle.m_DoorList.Count - 1 do
      begin
        Door := m_MapCastle.m_DoorList.Items[i];
        if (abs(Door.nX - m_nPalaceDoorX {631}) <= 3) and (abs(Door.nY - m_nPalaceDoorY {274}) <= 3) then
        begin
          m_DoorStatus := Door.Status;
        end;
      end;
    end else
    begin
      MainOutMessage(Format('<Critical Error> UserCastle : [Defense]->CastleMap is invalid value (%s)', [m_sMapName]));
      //MainOutMessage('[错误信息] TUserCastle.Initialize CastleMap -> nil');
    end;

    //CODE:0048E935
  end;
end;

//加载配置文件
procedure TUserCastle.LoadConfig(); //0048F5BC
var
  sFileName, sConfigFile: string;
  CastleConf: TIniFile;
  i: Integer;
  ObjUnit: pTObjUnit;
  sMapList, sMap: string;
begin
  if not DirectoryExists(g_Config.sCastleDir + m_sConfigDir) then
  begin
    CreateDir(g_Config.sCastleDir + m_sConfigDir);
  end;
  sConfigFile := 'SabukW.txt';
  sFileName := g_Config.sCastleDir + m_sConfigDir + '\' + sConfigFile;
  CastleConf := TIniFile.Create(sFileName);
  if CastleConf <> nil then
  begin
    m_sName := CastleConf.ReadString('Setup', 'CastleName', m_sName);      //城堡名
    m_sOwnGuild := CastleConf.ReadString('Setup', 'OwnGuild', '');         //所属行会
    m_ChangeDate := CastleConf.ReadDateTime('Setup', 'ChangeDate', Now);
    m_WarDate := CastleConf.ReadDateTime('Setup', 'WarDate', Now);
    m_IncomeToday := CastleConf.ReadDateTime('Setup', 'IncomeToday', Now);
    m_nTotalGold := CastleConf.ReadInteger('Setup', 'TotalGold', 0);
    m_nTodayIncome := CastleConf.ReadInteger('Setup', 'TodayIncome', 0);
    m_nTechLevel := CastleConf.ReadInteger('Setup', 'TechLevel', 0);
    m_nPower := CastleConf.ReadInteger('Setup', 'Power', 0);

    sMapList := CastleConf.ReadString('Defense', 'CastleMapList', '');
    if sMapList <> '' then
    begin
      while (sMapList <> '') do
      begin
        sMapList := GetValidStr3(sMapList, sMap, [',']);
        if sMap = '' then Break;
        m_EnvirList.Add(sMap);
      end;
    end;
    for i := 0 to m_EnvirList.Count - 1 do
    begin
      m_EnvirList.Objects[i] := g_MapManager.FindMap(m_EnvirList.Strings[i]);
    end;

    m_sMapName := CastleConf.ReadString('Defense', 'CastleMap', '3');              //城堡所在地图名
    m_sHomeMap := CastleConf.ReadString('Defense', 'CastleHomeMap', m_sHomeMap);  //行会回城点地图
    m_nHomeX := CastleConf.ReadInteger('Defense', 'CastleHomeX', m_nHomeX);
    m_nHomeY := CastleConf.ReadInteger('Defense', 'CastleHomeY', m_nHomeY);
    m_nWarRangeX := CastleConf.ReadInteger('Defense', 'CastleWarRangeX', m_nWarRangeX);
    m_nWarRangeY := CastleConf.ReadInteger('Defense', 'CastleWarRangeY', m_nWarRangeY);
    m_sPalaceMap := CastleConf.ReadString('Defense', 'CastlePlaceMap', m_sPalaceMap);     //皇宫所在地图
    m_sSecretMap := CastleConf.ReadString('Defense', 'CastleSecretMap', m_sSecretMap);
    m_nPalaceDoorX := CastleConf.ReadInteger('Defense', 'CastlePalaceDoorX', 631);
    m_nPalaceDoorY := CastleConf.ReadInteger('Defense', 'CastlePalaceDoorY', 274);

    m_MainDoor.nX := CastleConf.ReadInteger('Defense', 'MainDoorX', 672);
    m_MainDoor.nY := CastleConf.ReadInteger('Defense', 'MainDoorY', 330);
    m_MainDoor.sName := CastleConf.ReadString('Defense', 'MainDoorName', 'MainDoor');
    m_MainDoor.nStatus := CastleConf.ReadBool('Defense', 'MainDoorOpen', True);
    m_MainDoor.nHP := CastleConf.ReadInteger('Defense', 'MainDoorHP', 2000);
    m_MainDoor.BaseObject := nil;

    m_LeftWall.nX := CastleConf.ReadInteger('Defense', 'LeftWallX', 624);
    m_LeftWall.nY := CastleConf.ReadInteger('Defense', 'LeftWallY', 278);
    m_LeftWall.sName := CastleConf.ReadString('Defense', 'LeftWallName', 'LeftWall');
    m_LeftWall.nHP := CastleConf.ReadInteger('Defense', 'LeftWallHP', 2000);
    m_LeftWall.BaseObject := nil;

    m_CenterWall.nX := CastleConf.ReadInteger('Defense', 'CenterWallX', 627);
    m_CenterWall.nY := CastleConf.ReadInteger('Defense', 'CenterWallY', 278);
    m_CenterWall.sName := CastleConf.ReadString('Defense', 'CenterWallName', 'CenterWall');
    m_CenterWall.nHP := CastleConf.ReadInteger('Defense', 'CenterWallHP', 2000);
    m_CenterWall.BaseObject := nil;

    m_RightWall.nX := CastleConf.ReadInteger('Defense', 'RightWallX', 634);
    m_RightWall.nY := CastleConf.ReadInteger('Defense', 'RightWallY', 271);
    m_RightWall.sName := CastleConf.ReadString('Defense', 'RightWallName', 'RightWall');
    m_RightWall.nHP := CastleConf.ReadInteger('Defense', 'RightWallHP', 2000);
    m_RightWall.BaseObject := nil;

    for i := Low(m_Archer) to High(m_Archer) do
    begin
      ObjUnit := @m_Archer[i];
      ObjUnit.nX := CastleConf.ReadInteger('Defense', 'Archer_' + IntToStr(i + 1) + '_X', 0);
      ObjUnit.nY := CastleConf.ReadInteger('Defense', 'Archer_' + IntToStr(i + 1) + '_Y', 0);
      ObjUnit.sName := CastleConf.ReadString('Defense', 'Archer_' + IntToStr(i + 1) + '_Name', 'Archer');
      ObjUnit.nHP := CastleConf.ReadInteger('Defense', 'Archer_' + IntToStr(i + 1) + '_HP', 2000);
      ObjUnit.BaseObject := nil;
    end;

    for i := Low(m_Guard) to High(m_Guard) do
    begin
      ObjUnit := @m_Guard[i];
      ObjUnit.nX := CastleConf.ReadInteger('Defense', 'Guard_' + IntToStr(i + 1) + '_X', 0);
      ObjUnit.nY := CastleConf.ReadInteger('Defense', 'Guard_' + IntToStr(i + 1) + '_Y', 0);
      ObjUnit.sName := CastleConf.ReadString('Defense', 'Guard_' + IntToStr(i + 1) + '_Name', 'Guard');
      ObjUnit.nHP := CastleConf.ReadInteger('Defense', 'Guard_' + IntToStr(i + 1) + '_HP', 2000);
      ObjUnit.BaseObject := nil;
    end;
    CastleConf.Free;
  end;
  m_MasterGuild := g_GuildManager.FindGuild(m_sOwnGuild);
end;

//保存配置文件
procedure TUserCastle.SaveConfigFile(); //0048EFCC
var
  CastleConf: TIniFile;
  ObjUnit: pTObjUnit;
  sFileName, sConfigFile: string;
  sMapList: string;
  i: Integer;
begin
  if not DirectoryExists(g_Config.sCastleDir + m_sConfigDir) then
  begin
    CreateDir(g_Config.sCastleDir + m_sConfigDir);
  end;
  if g_MapManager.GetMapOfServerIndex(m_sMapName) <> nServerIndex then Exit;
  sConfigFile := 'SabukW.txt';
  sFileName := g_Config.sCastleDir + m_sConfigDir + '\' + sConfigFile;
  CastleConf := TIniFile.Create(sFileName);
  if CastleConf <> nil then
  begin
    if m_sName <> '' then CastleConf.WriteString('Setup', 'CastleName', m_sName);              //城堡名
    if m_sOwnGuild <> '' then CastleConf.WriteString('Setup', 'OwnGuild', m_sOwnGuild);        //所属行会

    CastleConf.WriteDateTime('Setup', 'ChangeDate', m_ChangeDate);
    CastleConf.WriteDateTime('Setup', 'WarDate', m_WarDate);
    CastleConf.WriteDateTime('Setup', 'IncomeToday', m_IncomeToday);
    
    if m_nTotalGold <> 0 then CastleConf.WriteInteger('Setup', 'TotalGold', m_nTotalGold);        //总资金
    if m_nTodayIncome <> 0 then CastleConf.WriteInteger('Setup', 'TodayIncome', m_nTodayIncome);  //当天收入
    if m_nTechLevel <> 0 then CastleConf.WriteInteger('Setup', 'TechLevel', m_nTechLevel);        //等级
    if m_nPower <> 0 then CastleConf.WriteInteger('Setup', 'Power', m_nPower);                    //资源

    for i := 0 to m_EnvirList.Count - 1 do
    begin
      sMapList := sMapList + m_EnvirList.Strings[i] + ',';
    end;
    if sMapList <> '' then CastleConf.WriteString('Defense', 'CastleMapList', sMapList);

    if m_sMapName <> '' then CastleConf.WriteString('Defense', 'CastleMap', m_sMapName);
    if m_sHomeMap <> '' then CastleConf.WriteString('Defense', 'CastleHomeMap', m_sHomeMap);
    if m_nHomeX <> 0 then CastleConf.WriteInteger('Defense', 'CastleHomeX', m_nHomeX);
    if m_nHomeY <> 0 then CastleConf.WriteInteger('Defense', 'CastleHomeY', m_nHomeY);
    if m_nWarRangeX <> 0 then CastleConf.WriteInteger('Defense', 'CastleWarRangeX', m_nWarRangeX);
    if m_nWarRangeY <> 0 then CastleConf.WriteInteger('Defense', 'CastleWarRangeY', m_nWarRangeY);

    if m_sPalaceMap <> '' then CastleConf.WriteString('Defense', 'CastlePlaceMap', m_sPalaceMap);
    if m_sSecretMap <> '' then CastleConf.WriteString('Defense', 'CastleSecretMap', m_sSecretMap);
    if m_nPalaceDoorX <> 0 then CastleConf.WriteInteger('Defense', 'CastlePalaceDoorX', m_nPalaceDoorX);
    if m_nPalaceDoorY <> 0 then CastleConf.WriteInteger('Defense', 'CastlePalaceDoorY', m_nPalaceDoorY);

    if m_MainDoor.nX <> 0 then CastleConf.WriteInteger('Defense', 'MainDoorX', m_MainDoor.nX);
    if m_MainDoor.nY <> 0 then CastleConf.WriteInteger('Defense', 'MainDoorY', m_MainDoor.nY);
    if m_MainDoor.sName <> '' then CastleConf.WriteString('Defense', 'MainDoorName', m_MainDoor.sName);

    if m_MainDoor.BaseObject <> nil then
    begin
      CastleConf.WriteBool('Defense', 'MainDoorOpen', m_MainDoor.nStatus);
      CastleConf.WriteInteger('Defense', 'MainDoorHP', m_MainDoor.BaseObject.m_WAbil.HP);
    end;

    if m_LeftWall.nX <> 0 then CastleConf.WriteInteger('Defense', 'LeftWallX', m_LeftWall.nX);
    if m_LeftWall.nY <> 0 then CastleConf.WriteInteger('Defense', 'LeftWallY', m_LeftWall.nY);
    if m_LeftWall.sName <> '' then CastleConf.WriteString('Defense', 'LeftWallName', m_LeftWall.sName);

    if m_LeftWall.BaseObject <> nil then
    begin
      CastleConf.WriteInteger('Defense', 'LeftWallHP', m_LeftWall.BaseObject.m_WAbil.HP);
    end;

    if m_CenterWall.nX <> 0 then CastleConf.WriteInteger('Defense', 'CenterWallX', m_CenterWall.nX);
    if m_CenterWall.nY <> 0 then CastleConf.WriteInteger('Defense', 'CenterWallY', m_CenterWall.nY);
    if m_CenterWall.sName <> '' then CastleConf.WriteString('Defense', 'CenterWallName', m_CenterWall.sName);

    if m_CenterWall.BaseObject <> nil then
    begin
      CastleConf.WriteInteger('Defense', 'CenterWallHP', m_CenterWall.BaseObject.m_WAbil.HP);
    end;

    if m_RightWall.nX <> 0 then CastleConf.WriteInteger('Defense', 'RightWallX', m_RightWall.nX);
    if m_RightWall.nY <> 0 then CastleConf.WriteInteger('Defense', 'RightWallY', m_RightWall.nY);
    if m_RightWall.sName <> '' then CastleConf.WriteString('Defense', 'RightWallName', m_RightWall.sName);
    if m_RightWall.BaseObject <> nil then
    begin
      CastleConf.WriteInteger('Defense', 'RightWallHP', m_RightWall.BaseObject.m_WAbil.HP);
    end;
    for i := Low(m_Archer) to High(m_Archer) do
    begin
      ObjUnit := @m_Archer[i];
      if ObjUnit.nX <> 0 then CastleConf.WriteInteger('Defense', 'Archer_' + IntToStr(i + 1) + '_X', ObjUnit.nX);
      if ObjUnit.nY <> 0 then CastleConf.WriteInteger('Defense', 'Archer_' + IntToStr(i + 1) + '_Y', ObjUnit.nY);
      if ObjUnit.sName <> '' then CastleConf.WriteString('Defense', 'Archer_' + IntToStr(i + 1) + '_Name', ObjUnit.sName);
      if ObjUnit.BaseObject <> nil then
      begin
        CastleConf.WriteInteger('Defense', 'Archer_' + IntToStr(i + 1) + '_HP', ObjUnit.BaseObject.m_WAbil.HP);
      end else
      begin
        CastleConf.WriteInteger('Defense', 'Archer_' + IntToStr(i + 1) + '_HP', 0);
      end;
    end;

    for i := Low(m_Guard) to High(m_Guard) do
    begin
      ObjUnit := @m_Guard[i];
      if ObjUnit.nX <> 0 then CastleConf.WriteInteger('Defense', 'Guard_' + IntToStr(i + 1) + '_X', ObjUnit.nX);
      if ObjUnit.nY <> 0 then CastleConf.WriteInteger('Defense', 'Guard_' + IntToStr(i + 1) + '_Y', ObjUnit.nY);
      if ObjUnit.sName <> '' then CastleConf.WriteString('Defense', 'Guard_' + IntToStr(i + 1) + '_Name', ObjUnit.sName);
      if ObjUnit.BaseObject <> nil then
      begin
        CastleConf.WriteInteger('Defense', 'Guard_' + IntToStr(i + 1) + '_HP', ObjUnit.BaseObject.m_WAbil.HP);
      end else
      begin
        CastleConf.WriteInteger('Defense', 'Guard_' + IntToStr(i + 1) + '_HP', 0);
      end;
    end;
    CastleConf.Free;
  end;

end;
procedure TUserCastle.LoadAttackSabukWall(); //0048ED60
var
  i: Integer;
  sFileName, sConfigFile: string;
  LoadList: TStringList;
  sData: string;
  s20, sGuildName: string;
  Guild: TGUild;
  AttackerInfo: pTAttackerInfo;
begin
//  sFileName:=g_Config.sCastleDir + 'AttackSabukWall.txt';
  if not DirectoryExists(g_Config.sCastleDir + m_sConfigDir) then
  begin
    CreateDir(g_Config.sCastleDir + m_sConfigDir);
  end;
  sConfigFile := 'AttackSabukWall.txt';
  sFileName := g_Config.sCastleDir + m_sConfigDir + '\' + sConfigFile;
  if FileExists(sFileName) then
  begin
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(sFileName);
      for i := 0 to m_AttackWarList.Count - 1 do
      begin
        Dispose(pTAttackerInfo(m_AttackWarList.Items[i]));
      end;
      m_AttackWarList.Clear;
      for i := 0 to LoadList.Count - 1 do
      begin
        sData := LoadList.Strings[i];
        s20 := GetValidStr3(sData, sGuildName, [' ', #9]);
        Guild := g_GuildManager.FindGuild(sGuildName);
        if Guild <> nil then
        begin
          New(AttackerInfo);
          ArrestStringEx(s20, '"', '"', s20);
          try
            AttackerInfo.AttackDate := StrToDate(s20);
          except
            AttackerInfo.AttackDate := Now();
          end;
          AttackerInfo.sGuildName := sGuildName;
          AttackerInfo.Guild := Guild;
          m_AttackWarList.Add(AttackerInfo);
        end;

      end;
    except
      MainOutMessage('[Error] UserCastle.LoadAttackSabukWall');
    end;
    LoadList.Free;
  end;
end;
procedure TUserCastle.SaveAttackSabukWall(); //0048EBD0
var
  i: Integer;
  sFileName, sConfigFile: string;
  LoadLis: TStringList;
  AttackerInfo: pTAttackerInfo;
begin
  if not DirectoryExists(g_Config.sCastleDir + m_sConfigDir) then
  begin
    CreateDir(g_Config.sCastleDir + m_sConfigDir);
  end;
  sConfigFile := 'AttackSabukWall.txt';
  sFileName := g_Config.sCastleDir + m_sConfigDir + '\' + sConfigFile;
  LoadLis := TStringList.Create;
  for i := 0 to m_AttackWarList.Count - 1 do
  begin
    AttackerInfo := m_AttackWarList.Items[i];
    LoadLis.Add(AttackerInfo.sGuildName + '       "' + DateToStr(AttackerInfo.AttackDate) + '"');
  end;
  try
    LoadLis.SaveToFile(sFileName);
  except
    MainOutMessage('保存攻城信息失败: ' + sFileName);
  end;
  LoadLis.Free;
end;
procedure TUserCastle.Run; //0048FE4C
{$IF SoftVersion <> VERDEMO}
var
  i: Integer;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  wYear, wMonth, wDay: Word;
  AttackerInfo: pTAttackerInfo;
  s20: string;
{$IFEND}
resourcestring
  sWarStartMsg = '[%s 攻城战已经开始]';
  sWarStopTimeMsg = '[%s 攻城战离结束还有%d分钟]';
  sExceptionMsg = '[Exception] TUserCastle::Run';
begin
  try
    if nServerIndex <> g_MapManager.GetMapOfServerIndex(m_sMapName) then Exit;
{$IF SoftVersion <> VERDEMO}
    DecodeDate(Now, Year, Month, Day);
    DecodeDate(m_IncomeToday, wYear, wMonth, wDay);
    if (Year <> wYear) or (Month <> wMonth) or (Day <> wDay) then
    begin
      m_nTodayIncome := 0;
      m_IncomeToday := Now();
      m_boStartWar := False;
    end;
    if not m_boStartWar and (not m_boUnderWar) then
    begin
      DecodeTime(Time, Hour, Min, Sec, MSec);
      if Hour = g_Config.nStartCastlewarTime {20} then
      begin
        m_boStartWar := True; ;
        m_AttackGuildList.Clear;
        for i := m_AttackWarList.Count - 1 downto 0 do
        begin
          AttackerInfo := m_AttackWarList.Items[i];
          DecodeDate(AttackerInfo.AttackDate, wYear, wMonth, wDay);
          if (Year = wYear) and (Month = wMonth) and (Day = wDay) then
          begin
            m_boUnderWar := True;
            m_boShowOverMsg := False;
            m_WarDate := Now();
            m_dwStartCastleWarTick := GetTickCount();
            m_AttackGuildList.Add(AttackerInfo.Guild);
            Dispose(AttackerInfo);
            m_AttackWarList.Delete(i);
          end;
        end;
        if m_boUnderWar then
        begin
          m_AttackGuildList.Add(m_MasterGuild);
          StartWallconquestWar();
          SaveAttackSabukWall();
          UserEngine.SendServerGroupMsg(SS_212, nServerIndex, '');
          s20 := Format(sWarStartMsg, [m_sName]);
          UserEngine.SendBroadCastMsgExt(s20, t_System);
          UserEngine.SendServerGroupMsg(SS_204, nServerIndex, s20);
          MainOutMessage(s20);
          MainDoorControl(True);
        end;
      end;
    end;
    for i := Low(m_Guard) to High(m_Guard) do
    begin
      if (m_Guard[i].BaseObject <> nil) and (m_Guard[i].BaseObject.m_boGhost) then
      begin
        m_Guard[i].BaseObject := nil;
      end;
    end;
    for i := Low(m_Archer) to High(m_Archer) do
    begin
      if (m_Archer[i].BaseObject <> nil) and (m_Archer[i].BaseObject.m_boGhost) then
      begin
        m_Archer[i].BaseObject := nil;
      end;
    end;
    if m_boUnderWar then
    begin
      if m_LeftWall.BaseObject <> nil then m_LeftWall.BaseObject.m_boStoneMode := False;
      if m_CenterWall.BaseObject <> nil then m_CenterWall.BaseObject.m_boStoneMode := False;
      if m_RightWall.BaseObject <> nil then m_RightWall.BaseObject.m_boStoneMode := False;
      if not m_boShowOverMsg then
      begin //00490181
        if (GetTickCount - m_dwStartCastleWarTick) > (g_Config.dwCastleWarTime - g_Config.dwShowCastleWarEndMsgTime) {3 * 60 * 60 * 1000 - 10 * 60 * 1000} then
        begin
          m_boShowOverMsg := True;
          s20 := Format(sWarStopTimeMsg, [m_sName, g_Config.dwShowCastleWarEndMsgTime div (60 * 1000)]);

          UserEngine.SendBroadCastMsgExt(s20, t_System);
          UserEngine.SendServerGroupMsg(SS_204, nServerIndex, s20);
          MainOutMessage(s20);
        end;
      end;
      if (GetTickCount - m_dwStartCastleWarTick) > g_Config.dwCastleWarTime {3 * 60 * 60 * 1000} then
      begin
        StopWallconquestWar();
      end;

    end else
    begin
      if m_LeftWall.BaseObject <> nil then m_LeftWall.BaseObject.m_boStoneMode := True;
      if m_CenterWall.BaseObject <> nil then m_CenterWall.BaseObject.m_boStoneMode := True;
      if m_RightWall.BaseObject <> nil then m_RightWall.BaseObject.m_boStoneMode := True;
    end;
{$IFEND}
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

procedure TUserCastle.Save; //0048EBA4
begin
  SaveConfigFile();
  SaveAttackSabukWall();
end;

function TUserCastle.InCastleWarArea(Envir: TEnvirnoment; nX, nY: Integer): Boolean; //004910F4
var
  i: Integer;
begin
  Result := False;
  if (Envir = m_MapCastle) and
    (abs(m_nHomeX - nX) < m_nWarRangeX {100}) and
    (abs(m_nHomeY - nY) < m_nWarRangeY {100}) then
  begin
    Result := True;
    Exit;
  end;
  if (Envir = m_MapPalace) or (Envir = m_MapSecret) then
  begin
    Result := True;
    Exit;
  end;
  //增加取得城堡所有地图列表
  for i := 0 to m_EnvirList.Count - 1 do
  begin
    if m_EnvirList.Objects[i] = Envir then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TUserCastle.IsMember(Cert: TBaseObject): Boolean; //00490438
begin
  Result := IsMasterGuild(TGUild(Cert.m_MyGuild));
end;

//检查是否为攻城方行会的联盟行会
function TUserCastle.IsAttackAllyGuild(Guild: TGUild): Boolean;
var
  i: Integer;
  AttackGuild: TGUild;
begin
  Result := False;
  for i := 0 to m_AttackGuildList.Count - 1 do
  begin
    AttackGuild := TGUild(m_AttackGuildList.Items[i]);
    if (AttackGuild <> m_MasterGuild) and AttackGuild.IsAllyGuild(Guild) then
    begin
      Result := True;
      Break;
    end;
  end;
end;
//检查是否为攻城方行会
function TUserCastle.IsAttackGuild(Guild: TGUild): Boolean; //00491160
var
  i: Integer;
  AttackGuild: TGUild;
begin
  Result := False;
  for i := 0 to m_AttackGuildList.Count - 1 do
  begin
    AttackGuild := TGUild(m_AttackGuildList.Items[i]);
    if (AttackGuild <> m_MasterGuild) and (AttackGuild = Guild) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TUserCastle.CanGetCastle(Guild: TGUild): Boolean; //004911D0
var
  i: Integer;
  List14: TList;
  PlayObject: TPlayObject;
begin
  Result := False;
  if (GetTickCount - m_dwStartCastleWarTick) > g_Config.dwGetCastleTime {10 * 60 * 1000} then
  begin
    List14 := TList.Create;
    UserEngine.GetMapRageHuman(m_MapPalace, 0, 0, 1000, List14);
    Result := True;
    for i := 0 to List14.Count - 1 do
    begin
      PlayObject := TPlayObject(List14.Items[i]);
      if not PlayObject.m_boDeath and (PlayObject.m_MyGuild <> Guild) then
      begin
        Result := False;
        Break;
      end;
    end;
    List14.Free;
  end;

end;

procedure TUserCastle.GetCastle(Guild: TGUild); //00491290
var
  OldGuild: TGUild;
  s10: string;
resourcestring
  sGetCastleMsg = '[%s 已被 %s 占领]';
begin
  OldGuild := m_MasterGuild;
  m_MasterGuild := Guild;
  m_sOwnGuild := Guild.sGuildName;
  m_ChangeDate := Now();
  SaveConfigFile();
  if OldGuild <> nil then OldGuild.RefMemberName;
  if m_MasterGuild <> nil then m_MasterGuild.RefMemberName;
  s10 := Format(sGetCastleMsg, [m_sName, m_sOwnGuild]);
  UserEngine.SendBroadCastMsgExt(s10, t_System);
  UserEngine.SendServerGroupMsg(SS_204, nServerIndex, s10);
  MainOutMessage(s10);
end;

procedure TUserCastle.StartWallconquestWar; //00491074
var
  ListC: TList;
  i: Integer;
  PlayObject: TPlayObject;
begin
  ListC := TList.Create;
  UserEngine.GetMapRageHuman(m_MapPalace, m_nHomeX, m_nHomeY, 100, ListC);
  for i := 0 to ListC.Count - 1 do
  begin
    PlayObject := TPlayObject(ListC.Items[i]);
    PlayObject.RefShowName();
  end;
  ListC.Free;
end;

procedure TUserCastle.StopWallconquestWar; //00491408
var
  i: Integer;
  ListC: TList;
  PlayObject: TPlayObject;
  s14: string;
resourcestring
  sWallWarStop = '[%s 攻城战已经结束]';
begin
  m_boUnderWar := False;
  m_AttackGuildList.Clear;
  ListC := TList.Create;
  UserEngine.GetMapOfRangeHumanCount(m_MapCastle, m_nHomeX, m_nHomeY, 100);
  for i := 0 to ListC.Count - 1 do
  begin
    PlayObject := TPlayObject(ListC.Items[i]);
    PlayObject.ChangePKStatus(False);
    if PlayObject.m_MyGuild <> m_MasterGuild then
      PlayObject.MapRandomMove(PlayObject.m_sHomeMap, 0);
  end;
  ListC.Free;
  s14 := Format(sWallWarStop, [m_sName]);
  UserEngine.SendBroadCastMsgExt(s14, t_System);
  UserEngine.SendServerGroupMsg(SS_204, nServerIndex, s14);
  MainOutMessage(s14);
end;

function TUserCastle.InPalaceGuildCount: Integer; //004911B4
begin
  Result := m_AttackGuildList.Count;
end;

function TUserCastle.IsDefenseAllyGuild(Guild: TGUild): Boolean;
begin
  Result := False;
  if not m_boUnderWar then Exit; //如果未开始攻城，则无效
  if m_MasterGuild <> nil then
    Result := m_MasterGuild.IsAllyGuild(Guild);
end;

//检查是否为守城方行会
function TUserCastle.IsDefenseGuild(Guild: TGUild): Boolean;
begin
  Result := False;
  if not m_boUnderWar then Exit; //如果未开始攻城，则无效
  if Guild = m_MasterGuild then Result := True;
end;

function TUserCastle.IsMasterGuild(Guild: TGUild): Boolean; //00490400
begin
  Result := False;
  if (m_MasterGuild <> nil) and (m_MasterGuild = Guild) then
    Result := True;
end;



function TUserCastle.GetHomeX: Integer; //004902B0
begin
  Result := (m_nHomeX - 4) + Random(9);
end;

function TUserCastle.GetHomeY: Integer; //004902D8
begin
  Result := (m_nHomeY - 4) + Random(9);
end;

function TUserCastle.GetMapName: string; //00490290
begin
  Result := m_sMapName;
end;

function TUserCastle.CheckInPalace(nX, nY: Integer; Cert: TBaseObject): Boolean; //490300
var
  ObjUnit: pTObjUnit;
begin
  Result := IsMasterGuild(TGUild(Cert.m_MyGuild));
  if Result then Exit;
  ObjUnit := @m_LeftWall;
  if (ObjUnit.BaseObject <> nil) and
    (ObjUnit.BaseObject.m_boDeath) and
    (ObjUnit.BaseObject.m_nCurrX = nX) and
    (ObjUnit.BaseObject.m_nCurrY = nY) then
  begin
    Result := True;
  end;
  ObjUnit := @m_CenterWall;
  if (ObjUnit.BaseObject <> nil) and
    (ObjUnit.BaseObject.m_boDeath) and
    (ObjUnit.BaseObject.m_nCurrX = nX) and
    (ObjUnit.BaseObject.m_nCurrY = nY) then
  begin
    Result := True;
  end;
  ObjUnit := @m_RightWall;
  if (ObjUnit.BaseObject <> nil) and
    (ObjUnit.BaseObject.m_boDeath) and
    (ObjUnit.BaseObject.m_nCurrX = nX) and
    (ObjUnit.BaseObject.m_nCurrY = nY) then
  begin
    Result := True;
  end;
end;

function TUserCastle.GetWarDate: string; //00490D7C
var
  AttackerInfo: pTAttackerInfo;
  Year: Word;
  Month: Word;
  Day: Word;
resourcestring
  sMsg = '%d年%d月%d日';
begin
  Result := '';
  if m_AttackWarList.Count <= 0 then Exit;
  AttackerInfo := m_AttackWarList.Items[0];
  DecodeDate(AttackerInfo.AttackDate, Year, Month, Day);
  Result := Format(sMsg, [Year, Month, Day]);
end;

function TUserCastle.GetAttackWarList: string; //00490E68
var
  i, n10: Integer;
  AttackerInfo: pTAttackerInfo;
  Year, Month, Day: Word;
  wYear, wMonth, wDay: Word;
  s20: string;
begin
  Result := '';
  wYear := 0;
  wMonth := 0;
  wDay := 0;
  n10 := 0;
  for i := 0 to m_AttackWarList.Count - 1 do
  begin
    AttackerInfo := m_AttackWarList.Items[i];
    DecodeDate(AttackerInfo.AttackDate, Year, Month, Day);
    if (Year <> wYear) or (Month <> wMonth) or (Day <> wDay) then
    begin
      wYear := Year;
      wMonth := Month;
      wDay := Day;
      if Result <> '' then
        Result := Result + '\';
      Result := Result + IntToStr(wYear) + '年' + IntToStr(wMonth) + '月' + IntToStr(wDay) + '日\';
      n10 := 0;
    end;
    if n10 > 40 then
    begin
      Result := Result + '\';
      n10 := 0;
    end;
    s20 := '"' + AttackerInfo.sGuildName + '"';
    Inc(n10, Length(s20));
    Result := Result + s20;
  end; // for
end;

procedure TUserCastle.IncRateGold(nGold: Integer); //004904C4
var
  nInGold: Integer;
begin
  nInGold := Round(nGold * (g_Config.nCastleTaxRate / 100) {0.05});
  if (m_nTodayIncome + nInGold) <= g_Config.nCastleOneDayGold then
  begin
    Inc(m_nTodayIncome, nInGold);
  end else
  begin
    if m_nTodayIncome >= g_Config.nCastleOneDayGold then
    begin
      nInGold := 0;
    end else
    begin
      nInGold := g_Config.nCastleOneDayGold - m_nTodayIncome;
      m_nTodayIncome := g_Config.nCastleOneDayGold;
    end;
  end;
  if nInGold > 0 then
  begin
    if (m_nTotalGold + nInGold) < g_Config.nCastleGoldMax then
    begin
      Inc(m_nTotalGold, nInGold);
    end else
    begin
      m_nTotalGold := g_Config.nCastleGoldMax;
    end;
  end;
  if (GetTickCount - m_dwSaveTick) > 10 * 60 * 1000 then
  begin
    m_dwSaveTick := GetTickCount();
    if g_boGameLogGold then
      AddGameDataLog('23' + #9 +
        '0' + #9 +
        '0' + #9 +
        '0' + #9 +
        'autosave' + #9 +
        sSTRING_GOLDNAME + #9 +
        IntToStr(m_nTotalGold) + #9 +
        '1' + #9 +
        '0');
  end;

end;

//收回现金
function TUserCastle.WithDrawalGolds(PlayObject: TPlayObject; nGold: Integer): Integer; //0049066C
begin
  Result := -1;
  if nGold <= 0 then
  begin
    Result := -4;
    Exit;
  end;
  if (m_MasterGuild = PlayObject.m_MyGuild) and (PlayObject.m_nGuildRankNo = 1) and (nGold > 0) then
  begin
    if (nGold > 0) and (nGold <= m_nTotalGold) then
    begin
      if (PlayObject.m_nGold + nGold) <= PlayObject.m_nGoldMax then
      begin
        Dec(m_nTotalGold, nGold);
        PlayObject.IncGold(nGold);
               //004907C8
        if g_boGameLogGold then
          AddGameDataLog('22' + #9 +
            PlayObject.m_sMapName + #9 +
            IntToStr(PlayObject.m_nCurrX) + #9 +
            IntToStr(PlayObject.m_nCurrY) + #9 +
            PlayObject.m_sCharName + #9 +
            sSTRING_GOLDNAME + #9 +
            IntToStr(nGold) + #9 +
            '1' + #9 +
            '0');
        PlayObject.GoldChanged; //金币兑换
        Result := 1;
      end else Result := -3;
    end else Result := -2;
  end;
end;

function TUserCastle.ReceiptGolds(PlayObject: TPlayObject; nGold: Integer): Integer; //00490864
begin
  Result := -1;
  if nGold <= 0 then
  begin
    Result := -4;
    Exit;
  end;
  if (m_MasterGuild = PlayObject.m_MyGuild) and (PlayObject.m_nGuildRankNo = 1) and (nGold > 0) then
  begin
    if (nGold <= PlayObject.m_nGold) then
    begin
      if (m_nTotalGold + nGold) <= g_Config.nCastleGoldMax then
      begin
        Dec(PlayObject.m_nGold, nGold);
        Inc(m_nTotalGold, nGold);
        if g_boGameLogGold then
          AddGameDataLog('23' + #9 +
            PlayObject.m_sMapName + #9 +
            IntToStr(PlayObject.m_nCurrX) + #9 +
            IntToStr(PlayObject.m_nCurrY) + #9 +
            PlayObject.m_sCharName + #9 +
            sSTRING_GOLDNAME + #9 +
            IntToStr(nGold) + #9 +
            '1' + #9 +
            '0');
        PlayObject.GoldChanged;
        Result := 1;
      end else Result := -3;
    end else Result := -2;
  end;
end;

procedure TUserCastle.MainDoorControl(boClose: Boolean); //00490460
begin
  if (m_MainDoor.BaseObject <> nil) and not m_MainDoor.BaseObject.m_boGhost then
  begin
    if boClose then
    begin
      if TCastleDoor(m_MainDoor.BaseObject).m_boOpened then TCastleDoor(m_MainDoor.BaseObject).Close;
    end else
    begin
      if not TCastleDoor(m_MainDoor.BaseObject).m_boOpened then TCastleDoor(m_MainDoor.BaseObject).Open;
    end;
  end;
end;

function TUserCastle.RepairDoor(): Boolean; //00490A70
var
  CastleDoor: pTObjUnit;
begin
  Result := False;
  CastleDoor := @m_MainDoor;
  if (CastleDoor.BaseObject = nil) or
    (m_boUnderWar) or
    (CastleDoor.BaseObject.m_WAbil.HP >= CastleDoor.BaseObject.m_WAbil.MaxHP) then
  begin
    Exit;
  end;
  if not CastleDoor.BaseObject.m_boDeath then
  begin
    if (GetTickCount - CastleDoor.BaseObject.m_dwStruckTick) > 60 * 1000 then
    begin
      CastleDoor.BaseObject.m_WAbil.HP := CastleDoor.BaseObject.m_WAbil.MaxHP;
      TCastleDoor(CastleDoor.BaseObject).RefStatus();
      Result := True;
    end;
  end else
  begin
    if (GetTickCount - CastleDoor.BaseObject.m_dwStruckTick) > 60 * 1000 then
    begin
      CastleDoor.BaseObject.m_WAbil.HP := CastleDoor.BaseObject.m_WAbil.MaxHP;
      CastleDoor.BaseObject.m_boDeath := False;
      TCastleDoor(CastleDoor.BaseObject).m_boOpened := False;
      TCastleDoor(CastleDoor.BaseObject).RefStatus();
      Result := True;
    end;
  end;

end;

function TUserCastle.RepairWall(nWallIndex: Integer): Boolean; //00490B78
var
  Wall: TBaseObject;
begin
  Result := False;
  Wall := nil;
  case nWallIndex of
    1: Wall := m_LeftWall.BaseObject;
    2: Wall := m_CenterWall.BaseObject;
    3: Wall := m_RightWall.BaseObject;
  end;
  if (Wall = nil) or
    (m_boUnderWar) or
    (Wall.m_WAbil.HP >= Wall.m_WAbil.MaxHP) then
  begin
    Exit;
  end;
  if not Wall.m_boDeath then
  begin
    if (GetTickCount - Wall.m_dwStruckTick) > 60 * 1000 then
    begin
      Wall.m_WAbil.HP := Wall.m_WAbil.MaxHP;
      TWallStructure(Wall).RefStatus();
      Result := True;
    end;
  end else
  begin
    if (GetTickCount - Wall.m_dwStruckTick) > 60 * 1000 then
    begin
      Wall.m_WAbil.HP := Wall.m_WAbil.MaxHP;
      Wall.m_boDeath := False;
      TWallStructure(Wall).RefStatus();
      Result := True;
    end;
  end;
end;
function TUserCastle.AddAttackerInfo(Guild: TGUild): Boolean; //00490CD8
var
  AttackerInfo: pTAttackerInfo;
begin
  Result := False;
  if InAttackerList(Guild) then Exit;
  New(AttackerInfo);
  AttackerInfo.AttackDate := AddDateTimeOfDay(Now, g_Config.nStartCastleWarDays);
  AttackerInfo.sGuildName := Guild.sGuildName;
  AttackerInfo.Guild := Guild;
  m_AttackWarList.Add(AttackerInfo);
  SaveAttackSabukWall();
  UserEngine.SendServerGroupMsg(SS_212, nServerIndex, '');
  Result := True;
end;

function TUserCastle.InAttackerList(Guild: TGUild): Boolean; //00490C84
var
  i: Integer;
begin
  Result := False;
  for i := 0 to m_AttackWarList.Count - 1 do
  begin
    if pTAttackerInfo(m_AttackWarList.Items[i]).Guild = Guild then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TUserCastle.m_nChiefItemCount: Integer;
begin

end;

procedure TUserCastle.SetPower(nPower: Integer);
begin
  m_nPower := nPower;
end;

procedure TUserCastle.SetTechLevel(nLevel: Integer);
begin
  m_nTechLevel := nLevel;
end;

{ TCastleManager }

constructor TCastleManager.Create;
begin
  m_CastleList := TList.Create;
  InitializeCriticalSection(CriticalSection);
end;


destructor TCastleManager.Destroy;
var
  i: Integer;
  UserCastle: TUserCastle;
begin
  for i := 0 to m_CastleList.Count - 1 do
  begin
    UserCastle := TUserCastle(m_CastleList.Items[i]);
    UserCastle.Save;
    UserCastle.Free;
  end;
  m_CastleList.Free;
  DeleteCriticalSection(CriticalSection);
  inherited;
end;


function TCastleManager.Find(sCASTLENAME: string): TUserCastle;
var
  i: Integer;
  Castle: TUserCastle;
begin
  Result := nil;
  for i := 0 to m_CastleList.Count - 1 do
  begin
    Castle := TUserCastle(m_CastleList.Items[i]);
    if CompareText(Castle.m_sName, sCASTLENAME) = 0 then
    begin
      Result := Castle;
      Break;
    end;
  end;
end;

//取得角色所在座标的城堡
function TCastleManager.InCastleWarArea(
  BaseObject: TBaseObject): TUserCastle;
var
  i: Integer;
  Castle: TUserCastle;
begin
  Result := nil;
  for i := 0 to m_CastleList.Count - 1 do
  begin
    Castle := TUserCastle(m_CastleList.Items[i]);
    if Castle.InCastleWarArea(BaseObject.m_PEnvir, BaseObject.m_nCurrX, BaseObject.m_nCurrY) then
    begin
      Result := Castle;
      Break;
    end;
  end;
end;
function TCastleManager.InCastleWarArea(Envir: TEnvirnoment; nX,
  nY: Integer): TUserCastle;
var
  i: Integer;
  Castle: TUserCastle;
begin
  Result := nil;
  for i := 0 to m_CastleList.Count - 1 do
  begin
    Castle := TUserCastle(m_CastleList.Items[i]);
    if Castle.InCastleWarArea(Envir, nX, nY) then
    begin
      Result := Castle;
      Break;
    end;
  end;
end;
procedure TCastleManager.Initialize;
var
  i: Integer;
  Castle: TUserCastle;
begin
  if m_CastleList.Count <= 0 then
  begin
    Castle := TUserCastle.Create(g_Config.sCastleDir);
    m_CastleList.Add(Castle);
    Castle.Initialize;
    Castle.m_sConfigDir := '0';
    Castle.m_EnvirList.Add('0151');
    Castle.m_EnvirList.Add('0152');
    Castle.m_EnvirList.Add('0153');
    Castle.m_EnvirList.Add('0154');
    Castle.m_EnvirList.Add('0155');
    Castle.m_EnvirList.Add('0156');
    for i := 0 to Castle.m_EnvirList.Count - 1 do
    begin
      Castle.m_EnvirList.Objects[i] := g_MapManager.FindMap(Castle.m_EnvirList.Strings[i]);
    end;
    Save();
    Exit;
  end;

  for i := 0 to m_CastleList.Count - 1 do
  begin
    Castle := TUserCastle(m_CastleList.Items[i]);
    Castle.Initialize;
  end;
end;
//城堡皇宫所在地图
function TCastleManager.IsCastlePalaceEnvir(Envir: TEnvirnoment): TUserCastle;
var
  i: Integer;
  Castle: TUserCastle;
begin
  Result := nil;
  for i := 0 to m_CastleList.Count - 1 do
  begin
    Castle := TUserCastle(m_CastleList.Items[i]);
    if Castle.m_MapPalace = Envir then
    begin
      Result := Castle;
      Break;
    end;
  end;
end;
//城堡所在地图
function TCastleManager.IsCastleEnvir(Envir: TEnvirnoment): TUserCastle;
var
  i: Integer;
  Castle: TUserCastle;
begin
  Result := nil;
  for i := 0 to m_CastleList.Count - 1 do
  begin
    Castle := TUserCastle(m_CastleList.Items[i]);
    if Castle.m_MapCastle = Envir then
    begin
      Result := Castle;
      Break;
    end;
  end;
end;

function TCastleManager.IsCastleMember(
  BaseObject: TBaseObject): TUserCastle;
var
  i: Integer;
  Castle: TUserCastle;
begin
  Result := nil;
  for i := 0 to m_CastleList.Count - 1 do
  begin
    Castle := TUserCastle(m_CastleList.Items[i]);
    if Castle.IsMember(BaseObject) then
    begin
      Result := Castle;
      Break;
    end;
  end;
end;

procedure TCastleManager.Run;
var
  i: Integer;
  UserCastle: TUserCastle;
begin
  Lock;
  try
    for i := 0 to m_CastleList.Count - 1 do
    begin
      UserCastle := TUserCastle(m_CastleList.Items[i]);
      UserCastle.Run;
    end;
  finally
    UnLock;
  end;
end;

procedure TCastleManager.GetCastleGoldInfo(List: TStringList);
var
  i: Integer;
  Castle: TUserCastle;
begin
  for i := 0 to m_CastleList.Count - 1 do
  begin
    Castle := TUserCastle(m_CastleList.Items[i]);
    List.Add(Format(g_sGameCommandSbkGoldShowMsg, [Castle.m_sName, Castle.m_nTotalGold, Castle.m_nTodayIncome]));
  end;
end;

procedure TCastleManager.Save;
var
  i: Integer;
  Castle: TUserCastle;
begin
  SaveCastleList();
  for i := 0 to m_CastleList.Count - 1 do
  begin
    Castle := TUserCastle(m_CastleList.Items[i]);
    Castle.Save;
  end;
end;

procedure TCastleManager.LoadCastleList;
var
  LoadList: TStringList;
  Castle: TUserCastle;
  sCastleDir: string;
  i: Integer;
begin
  if FileExists(g_Config.sCastleFile) then
  begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(g_Config.sCastleFile);
    for i := 0 to LoadList.Count - 1 do
    begin
      sCastleDir := Trim(LoadList.Strings[i]);
      if sCastleDir <> '' then
      begin
        Castle := TUserCastle.Create(sCastleDir);
        m_CastleList.Add(Castle);
      end;
    end;
    LoadList.Free;
    MainOutMessage('已读取 ' + IntToStr(m_CastleList.Count) + '个城堡信息...');
  end else
  begin
    MainOutMessage('城堡信息读取失败!!');
  end;
end;

procedure TCastleManager.SaveCastleList;
var
  i: Integer;
  LoadList: TStringList;
begin
  if not DirectoryExists(g_Config.sCastleDir) then
  begin
    CreateDir(g_Config.sCastleDir);
  end;
  LoadList := TStringList.Create;
  for i := 0 to m_CastleList.Count - 1 do
  begin
    LoadList.Add(IntToStr(i));
  end;
  LoadList.SaveToFile(g_Config.sCastleFile);
  LoadList.Free;
end;

function TCastleManager.GetCastle(nIndex: Integer): TUserCastle;
begin
  Result := nil;
  if (nIndex >= 0) and (nIndex < m_CastleList.Count) then
    Result := TUserCastle(m_CastleList.Items[nIndex]);
end;

procedure TCastleManager.GetCastleNameList(List: TStringList);
var
  i: Integer;
  Castle: TUserCastle;
begin
  for i := 0 to m_CastleList.Count - 1 do
  begin
    Castle := TUserCastle(m_CastleList.Items[i]);
    List.Add(Castle.m_sName);
  end;
end;

procedure TCastleManager.IncRateGold(nGold: Integer);
var
  i: Integer;
  Castle: TUserCastle;
begin
  Lock;
  try
    for i := 0 to m_CastleList.Count - 1 do
    begin
      Castle := TUserCastle(m_CastleList.Items[i]);
      Castle.IncRateGold(nGold);
    end;
  finally
    UnLock;
  end;
end;

procedure TCastleManager.Lock;
begin
  EnterCriticalSection(CriticalSection);
end;

procedure TCastleManager.UnLock;
begin
  LeaveCriticalSection(CriticalSection);
end;

end.

