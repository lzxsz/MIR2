unit ObjMon3;

interface

uses
  Windows, Classes, Grobal2, ObjBase, ObjMon, ObjMon2;

type

  TRonObject = class(TMonster)
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure AroundAttack;
    procedure Run; override;
  end;

  TMinorNumaObject = class(TATMonster)
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TSandMobObject = class(TStickMonster)
  private
    m_dwAppearStart: LongWord;

  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TRockManObject = class(TATMonster)
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TMagicMonObject = class(TMonster)
  private
    m_boUseMagic: Boolean;

    procedure LightingAttack(nDir: Integer);

  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TBoneKingMonster = class(TMonster)
  private
    m_nDangerLevel: Integer;
    m_SlaveObjectList: TList; //0x55C

    procedure CallSlave;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override; //0FFED
    procedure Run; override;
  end;



  TPercentMonster = class(TAnimalObject)
    n54C: Integer;
    m_dwThinkTick: LongWord;
    bo554: Boolean;
    m_boDupMode: Boolean;
  private
    function Think: Boolean;
    function MakeClone(sMonName: string; OldMon: TBaseObject): TBaseObject;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    function AttackTarget(): Boolean; virtual;
    procedure Run; override;
  end;

  TMagicMonster = class(TAnimalObject)
    n54C: Integer;
    m_dwThinkTick: LongWord;
    m_dwSpellTick: LongWord;
    bo554: Boolean;
    m_boDupMode: Boolean;
  private
    function Think: Boolean;
    function MakeClone(sMonName: string; OldMon: TBaseObject): TBaseObject;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    function AttackTarget(): Boolean; virtual;
    procedure Run; override;
  end;

  TFireBallMonster = class(TMagicMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TFireMonster = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TFrostTiger = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TGreenMonster = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TRedMonster = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TKhazard = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TRunAway = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TTeleMonster = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TDefendMonster = class(TMonster)
  private
    m_GuardObjects: TList;

    procedure CallGuard(mapmap: string; xx, yy: Integer);
  public
    callguardrun: Boolean;
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TClone = class(TMonster)
  private
    procedure LightingAttack(nDir: Integer);

  public
    constructor Create(); override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Struck(hiter: TBaseObject); virtual;
    destructor Destroy; override;
    procedure Run; override;
  end;

implementation

uses
  UsrEngn, M2Share, Event, SysUtils;




constructor TRonObject.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TRonObject.Destroy;
begin
  inherited;
end;

procedure TRonObject.AroundAttack;
var
  xTargetList: TList;
  BaseObject: TBaseObject;
  wHitMode: Word;
  i: Integer;
begin
  wHitMode := 0;
  GetAttackDir(m_TargetCret, m_btDirection);

  xTargetList := TList.Create;
  GetMapBaseObjects(m_PEnvir, m_nCurrX, m_nCurrY, 1, xTargetList);

  if (xTargetList.Count > 0) then
  begin
    for i := xTargetList.Count - 1 downto 0 do
    begin
      BaseObject := TBaseObject(xTargetList.Items[i]);

      if (BaseObject <> nil) then
      begin
        _Attack(wHitMode, BaseObject); //CM_HIT

        xTargetList.Delete(i);
      end;
    end;
  end;
  xTargetList.Free;

  SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
end;

procedure TRonObject.Run;
begin
  if (not m_boDeath) and (not m_boGhost) and (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) then
  begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;

    if (m_TargetCret <> nil) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) < 6) and
      (abs(m_nCurrY - m_TargetCret.m_nCurrY) < 6) and
      (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
    begin

      m_dwHitTick := GetTickCount();
      AroundAttack;
    end;
  end;

  inherited;
end;

constructor TMinorNumaObject.Create;
begin
  inherited;
end;

destructor TMinorNumaObject.Destroy;
begin
  inherited;
end;

procedure TMinorNumaObject.Run;
begin
  if (not m_boDeath) then
  begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;

  inherited;
end;

constructor TSandMobObject.Create;
begin
  inherited;
  //m_boHideMode := TRUE;
  nComeOutValue := 8;
end;

destructor TSandMobObject.Destroy;
begin
  inherited;
end;

procedure TSandMobObject.Run;
begin
  if (not m_boDeath) and (not m_boGhost) then
  begin
    if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
    begin
      m_dwWalkTick := GetTickCount;

      if (m_boFixedHideMode) then
      begin
        if (((m_WAbil.HP > (m_WAbil.MaxHP / 20)) and CheckComeOut())) then
          m_dwAppearStart := GetTickCount;
      end else
      begin
        if ((m_WAbil.HP > 0) and (m_WAbil.HP < (m_WAbil.MaxHP / 20)) and (GetTickCount - m_dwAppearStart > 3000)) then
          ComeDown
        else if (m_TargetCret <> nil) then
        begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) > 15) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 15) then
          begin
            ComeDown;
            Exit;
          end;
        end;

        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
          SearchTarget();

        if (not m_boFixedHideMode) then
        begin
          if (AttackTarget) then
            inherited;
        end;
      end;
    end;
  end;

  inherited;
end;

constructor TRockManObject.Create;
begin
  inherited;
  //m_dwSearchTick := 2500 + Random(1500);
  //m_dwSearchTime := GetTickCount();

  m_boHideMode := True;
end;

destructor TRockManObject.Destroy;
begin
  inherited;
end;

procedure TRockManObject.Run;
begin
  {if (not m_fIsDead) and (not m_fIsGhost) then begin
  if (m_fHideMode) then begin
   if (CheckComeOut(8)) then
    ComeOut;

   m_dwWalkTime := GetTickCount + 1000;
  end else begin
   if ((GetTickCount - m_dwSearchEnemyTime > 8000) or ((GetTickCount - m_dwSearchEnemyTime > 1000) and (m_pTargetObject=nil))) then begin
    m_dwSearchEnemyTime := GetTickCount;
    MonsterNormalAttack;

    if (m_pTargetObject=nil) then
     ComeDown;
   end;
  end;
 end;}

  inherited;
end;


{ TMagicMonObject }

constructor TMagicMonObject.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_boUseMagic := False;
end;

destructor TMagicMonObject.Destroy;
begin

  inherited;
end;

procedure TMagicMonObject.LightingAttack(nDir: Integer);
begin

end;

procedure TMagicMonObject.Run;
var
  nAttackDir: Integer;
  nX, nY: Integer;
begin
  if (not m_boDeath) and
    (not bo554) and
    (not m_boGhost) and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) then
  begin

     //血量低于一半时开始用魔法攻击
    if m_WAbil.HP < m_WAbil.MaxHP div 2 then m_boUseMagic := True
    else m_boUseMagic := False;

    if ((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
    if m_Master = nil then Exit;

    nX := abs(m_nCurrX - m_Master.m_nCurrX);
    nY := abs(m_nCurrY - m_Master.m_nCurrY);

    if (nX <= 5) and (nY <= 5) then
    begin
      if m_boUseMagic or ((nX = 5) or (nY = 5)) then
      begin
        if (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
        begin
          m_dwHitTick := GetTickCount();
          nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_Master.m_nCurrX, m_Master.m_nCurrY);
          LightingAttack(nAttackDir);
        end;
      end;
    end;
  end;
  inherited Run;
end;


{ TBoneKingMonster }

constructor TBoneKingMonster.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_nViewRange := 8;
  m_btDirection := 5;
  m_nDangerLevel := 5;
  m_SlaveObjectList := TList.Create;
end;

destructor TBoneKingMonster.Destroy;
begin
  m_SlaveObjectList.Free;
  inherited;
end;

procedure TBoneKingMonster.CallSlave;
const
  sMonName: array[0..2] of string = ('BoneCaptain', 'BoneArcher', 'BoneSpearman');
var
  i: Integer;
  nC: Integer;
  n10, n14: Integer;
  BaseObject: TBaseObject;
begin
  nC := Random(6) + 6;
  GetFrontPosition(n10, n14);

  for i := 1 to nC do
  begin
    if m_SlaveObjectList.Count >= 30 then Break;
    BaseObject := UserEngine.RegenMonsterByName(m_sMapName, n10, n14, sMonName[Random(3)]);
    if BaseObject <> nil then
    begin
      m_SlaveObjectList.Add(BaseObject);
    end;
  end; // for
end;
procedure TBoneKingMonster.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
var
  WAbil: pTAbility;
  nPower: Integer;
begin
  WAbil := @m_WAbil;
  nPower := GetAttackPower(LoWord(WAbil.DC), SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)));
  HitMagAttackTarget(TargeTBaseObject, 0, nPower, True);
end;
procedure TBoneKingMonster.Run;
var
  i: Integer;
  n10: Integer;
  BaseObject: TBaseObject;
begin
  if (not m_boGhost) and
    (not m_boDeath) and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and
    (Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed) then
  begin
    n10 := 0;


    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();

      if (m_nDangerLevel > m_WAbil.HP / m_WAbil.MaxHP * 5) and (m_nDangerLevel > 0) then
      begin
        Dec(m_nDangerLevel);
        CallSlave();
      end;
      if m_WAbil.HP = m_WAbil.MaxHP then
        m_nDangerLevel := 5;
    end;

    for i := m_SlaveObjectList.Count - 1 downto 0 do
    begin
      BaseObject := TBaseObject(m_SlaveObjectList.Items[i]);
      if BaseObject.m_boDeath or BaseObject.m_boGhost then
        m_SlaveObjectList.Delete(i);
    end; // for
  end;
  inherited;
end;






constructor TPercentMonster.Create;
begin
  inherited;
  m_boDupMode := False;
  bo554 := False;
  m_dwThinkTick := GetTickCount();
  m_nViewRange := 5;
  m_nRunTime := 250;
  m_dwSearchTime := 3000 + Random(2000);
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := 80;
end;

destructor TPercentMonster.Destroy;
begin
  inherited;
end;
function TPercentMonster.MakeClone(sMonName: string; OldMon: TBaseObject): TBaseObject; //004A8C58
var
  ElfMon: TBaseObject;
begin
  Result := nil;
  ElfMon := UserEngine.RegenMonsterByName(m_PEnvir.sMapName, m_nCurrX, m_nCurrY, sMonName);
  if ElfMon <> nil then
  begin
    ElfMon.m_Master := OldMon.m_Master;
    ElfMon.m_dwMasterRoyaltyTick := OldMon.m_dwMasterRoyaltyTick;
    ElfMon.m_btSlaveMakeLevel := OldMon.m_btSlaveMakeLevel;
    ElfMon.m_btSlaveExpLevel := OldMon.m_btSlaveExpLevel;
    ElfMon.RecalcAbilitys;
    ElfMon.RefNameColor;
    if OldMon.m_Master <> nil then
      OldMon.m_Master.m_SlaveList.Add(ElfMon);
    ElfMon.m_WAbil := OldMon.m_WAbil;
    ElfMon.m_wStatusTimeArr := OldMon.m_wStatusTimeArr;
    ElfMon.m_TargetCret := OldMon.m_TargetCret;
    ElfMon.m_dwTargetFocusTick := OldMon.m_dwTargetFocusTick;
    ElfMon.m_LastHiter := OldMon.m_LastHiter;
    ElfMon.m_LastHiterTick := OldMon.m_LastHiterTick;
    ElfMon.m_btDirection := OldMon.m_btDirection;
    Result := ElfMon;
  end;
end;
function TPercentMonster.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  Result := inherited Operate(ProcessMsg);

end;
function TPercentMonster.Think(): Boolean; //004A8E54
var
  nOldX, nOldY: Integer;
begin
  Result := False;
  if (GetTickCount - m_dwThinkTick) > 3 * 1000 then
  begin
    m_dwThinkTick := GetTickCount();
    if m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) >= 2 then m_boDupMode := True;
    if not IsProperTarget {FFFF4}(m_TargetCret) then m_TargetCret := nil;
  end; //004A8ED2
  if m_boDupMode then
  begin
    nOldX := m_nCurrX;
    nOldY := m_nCurrY;
    WalkTo(Random(8), False);
    if (nOldX <> m_nCurrX) or (nOldY <> m_nCurrY) then
    begin
      m_boDupMode := False;
      Result := True;
    end;
  end;
end;

function TPercentMonster.AttackTarget(): Boolean; //004A8F34
var
  btDir: Byte;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin
    if GetAttackDir(m_TargetCret, btDir) then
    begin
      if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
      begin
        m_dwHitTick := GetTickCount();
        m_dwTargetFocusTick := GetTickCount();
        Attack(m_TargetCret, btDir); //FFED
        BreakHolySeizeMode();
      end;
      Result := True;
    end else
    begin
      if m_TargetCret.m_PEnvir = m_PEnvir then
      begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY); {0FFF0h}
        //004A8FE3
      end else
      begin
        DelTargetCreat(); {0FFF1h}
        //004A9009
      end;
    end;
  end;
end;

procedure TPercentMonster.Run; //004A9020
var
  nX, nY: Integer;
begin
  if not m_boGhost and
    not m_boDeath and
    not m_boFixedHideMode and
    not m_boStoneMode and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) then
  begin
    if Think then
    begin
      inherited;
      Exit;
    end;
    if m_boWalkWaitLocked then
    begin
      if (GetTickCount - m_dwWalkWaitTick) > m_dwWalkWait then
      begin
        m_boWalkWaitLocked := False;
      end;
    end;
    if not m_boWalkWaitLocked and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
    begin
      m_dwWalkTick := GetTickCount();
      Inc(m_nWalkCount);
      if m_nWalkCount > m_nWalkStep then
      begin
        m_nWalkCount := 0;
        m_boWalkWaitLocked := True;
        m_dwWalkWaitTick := GetTickCount();
      end; //004A9151
      if not m_boRunAwayMode then
      begin
        if not m_boNoAttackMode then
        begin
          if m_TargetCret <> nil then
          begin
            if AttackTarget {FFEB} then
            begin
              inherited;
              Exit;
            end;
          end else
          begin
            m_nTargetX := -1;
            if m_boMission then
            begin
              m_nTargetX := m_nMissionX;
              m_nTargetY := m_nMissionY;
            end; //004A91D3
          end;
        end; //004A91D3  if not bo2C0 then begin
        if m_Master <> nil then
        begin
          if m_TargetCret = nil then
          begin
            m_Master.GetBackPosition(nX, nY);
            if (abs(m_nTargetX - nX) > 1) or (abs(m_nTargetY - nY {nX}) > 1) then
            begin //004A922D
              m_nTargetX := nX;
              m_nTargetY := nY;
              if (abs(m_nCurrX - nX) <= 2) and (abs(m_nCurrY - nY) <= 2) then
              begin
                if m_PEnvir.GetMovingObject(nX, nY, True) <> nil then
                begin
                  m_nTargetX := m_nCurrX;
                  m_nTargetY := m_nCurrY;
                end //004A92A5
              end;
            end; //004A92A5
          end; //004A92A5 if m_TargetCret = nil then begin
          if (not m_Master.m_boSlaveRelax) and
            ((m_PEnvir <> m_Master.m_PEnvir) or
            (abs(m_nCurrX - m_Master.m_nCurrX) > 20) or
            (abs(m_nCurrY - m_Master.m_nCurrY) > 20)) then
          begin
           //  sysmsg('recalling to my master',c_red,t_hint);
            SpaceMove(m_Master.m_PEnvir.sMapName, m_nTargetX, m_nTargetY, 1);  //瞬息移动
          end; // 004A937E
        end; // 004A937E if m_Master <> nil then begin
      end else
      begin //004A9344
        if (m_dwRunAwayTime > 0) and ((GetTickCount - m_dwRunAwayStart) > m_dwRunAwayTime) then
        begin
          m_boRunAwayMode := False;
          m_dwRunAwayTime := 0;
        end;
      end; //004A937E
      if (m_Master <> nil) and m_Master.m_boSlaveRelax then
      begin
        inherited;
        Exit;
      end; //004A93A6
      if m_nTargetX <> -1 then
      begin
        GotoTargetXY(); //004A93B5 0FFEF
      end else
      begin
        if m_TargetCret = nil then Wondering(); // FFEE   //Jacky
      end; //004A93D8
    end; //004A93D8  if not bo510 and ((GetTickCount - m_dwWalkTick) > n4FC) then begin
  end; //004A93D8

  inherited;
end;




constructor TMagicMonster.Create; //004A8B74
begin
  inherited;
  m_boDupMode := False;
  bo554 := False;
  m_dwThinkTick := GetTickCount();
  m_nViewRange := 8;
  m_nRunTime := 250;
  m_dwSearchTime := 3000 + Random(2000);
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := 215;
end;

destructor TMagicMonster.Destroy; //004A8C24
begin
  inherited;
end;
function TMagicMonster.MakeClone(sMonName: string; OldMon: TBaseObject): TBaseObject; //004A8C58
var
  ElfMon: TBaseObject;
begin
  Result := nil;
  ElfMon := UserEngine.RegenMonsterByName(m_PEnvir.sMapName, m_nCurrX, m_nCurrY, sMonName);
  if ElfMon <> nil then
  begin
    ElfMon.m_Master := OldMon.m_Master;
    ElfMon.m_dwMasterRoyaltyTick := OldMon.m_dwMasterRoyaltyTick;
    ElfMon.m_btSlaveMakeLevel := OldMon.m_btSlaveMakeLevel;
    ElfMon.m_btSlaveExpLevel := OldMon.m_btSlaveExpLevel;
    ElfMon.RecalcAbilitys;
    ElfMon.RefNameColor;
    if OldMon.m_Master <> nil then
      OldMon.m_Master.m_SlaveList.Add(ElfMon);
    ElfMon.m_WAbil := OldMon.m_WAbil;
    ElfMon.m_wStatusTimeArr := OldMon.m_wStatusTimeArr;
    ElfMon.m_TargetCret := OldMon.m_TargetCret;
    ElfMon.m_dwTargetFocusTick := OldMon.m_dwTargetFocusTick;
    ElfMon.m_LastHiter := OldMon.m_LastHiter;
    ElfMon.m_LastHiterTick := OldMon.m_LastHiterTick;
    ElfMon.m_btDirection := OldMon.m_btDirection;
    Result := ElfMon;
  end;
end;
function TMagicMonster.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  Result := inherited Operate(ProcessMsg);

end;
function TMagicMonster.Think(): Boolean; //004A8E54
var
  nOldX, nOldY: Integer;
begin
  Result := False;
  if (GetTickCount - m_dwThinkTick) > 3 * 1000 then
  begin
    m_dwThinkTick := GetTickCount();
    if m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) >= 2 then m_boDupMode := True;
    if not IsProperTarget {FFFF4}(m_TargetCret) then m_TargetCret := nil;
  end; //004A8ED2
  if m_boDupMode then
  begin
    nOldX := m_nCurrX;
    nOldY := m_nCurrY;
    WalkTo(Random(8), False);
    if (nOldX <> m_nCurrX) or (nOldY <> m_nCurrY) then
    begin
      m_boDupMode := False;
      Result := True;
    end;
  end;
end;

function TMagicMonster.AttackTarget(): Boolean; //004A8F34
var
  bt06: Byte;
  PlayObject: TPlayObject;
  nPower: Integer;
  UserMagic: pTUserMagic;
begin
  Result := False;
  if m_TargetCret <> nil then
  begin
    if m_TargetCret = m_Master then
    begin //nicky
      m_TargetCret := nil;
    end else
    begin
      if GetAttackDir(m_TargetCret, bt06) then
      begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then
        begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();
  // Attack(m_TargetCret,bt06);  //FFED
        end;
        Result := True;
      end else
      begin
        if m_TargetCret.m_PEnvir = m_PEnvir then
        begin
          SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY); {0FFF0h}
        //004A8FE3
        end else
        begin
          DelTargetCreat(); {0FFF1h}
        //004A9009
        end;
      end;
    end;
  end;
end;
procedure TMagicMonster.Run; //004A9020
var
  nX, nY: Integer;
begin
  if not m_boGhost and
    not m_boDeath and
    not m_boFixedHideMode and
    not m_boStoneMode and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) then
  begin
    if Think then
    begin
      inherited;
      Exit;
    end;
    if m_boWalkWaitLocked then
    begin
      if (GetTickCount - m_dwWalkWaitTick) > m_dwWalkWait then
      begin
        m_boWalkWaitLocked := False;
      end;
    end;
    if not m_boWalkWaitLocked and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then
    begin
      m_dwWalkTick := GetTickCount();
      Inc(m_nWalkCount);
      if m_nWalkCount > m_nWalkStep then
      begin
        m_nWalkCount := 0;
        m_boWalkWaitLocked := True;
        m_dwWalkWaitTick := GetTickCount();
      end; //004A9151
      if not m_boRunAwayMode then
      begin
        if not m_boNoAttackMode then
        begin
          if m_TargetCret <> nil then
          begin
            if AttackTarget {FFEB} then
            begin
              inherited;
              Exit;
            end;
          end else
          begin
            m_nTargetX := -1;
            if m_boMission then
            begin
              m_nTargetX := m_nMissionX;
              m_nTargetY := m_nMissionY;
            end; //004A91D3
          end;
        end; //004A91D3  if not bo2C0 then begin
        if m_Master <> nil then
        begin
          if m_TargetCret = nil then
          begin
            m_Master.GetBackPosition(nX, nY);
            if (abs(m_nTargetX - nX) > 1) or (abs(m_nTargetY - nY {nX}) > 1) then
            begin //004A922D
              m_nTargetX := nX;
              m_nTargetY := nY;
              if (abs(m_nCurrX - nX) <= 2) and (abs(m_nCurrY - nY) <= 2) then
              begin
                if m_PEnvir.GetMovingObject(nX, nY, True) <> nil then
                begin
                  m_nTargetX := m_nCurrX;
                  m_nTargetY := m_nCurrY;
                end //004A92A5
              end;
            end; //004A92A5
          end; //004A92A5 if m_TargetCret = nil then begin
          if (not m_Master.m_boSlaveRelax) and
            ((m_PEnvir <> m_Master.m_PEnvir) or
            (abs(m_nCurrX - m_Master.m_nCurrX) > 20) or
            (abs(m_nCurrY - m_Master.m_nCurrY) > 20)) then
          begin
           //  sysmsg('recalling to my master',c_red,t_hint);
            SpaceMove(m_Master.m_PEnvir.sMapName, m_nTargetX, m_nTargetY, 1);
          end; // 004A937E
        end; // 004A937E if m_Master <> nil then begin
      end else
      begin //004A9344
        if (m_dwRunAwayTime > 0) and ((GetTickCount - m_dwRunAwayStart) > m_dwRunAwayTime) then
        begin
          m_boRunAwayMode := False;
          m_dwRunAwayTime := 0;
        end;
      end; //004A937E
      if (m_Master <> nil) and m_Master.m_boSlaveRelax then
      begin
        inherited;
        Exit;
      end; //004A93A6
      if m_nTargetX <> -1 then
      begin
        GotoTargetXY(); //004A93B5 0FFEF
      end else
      begin
        if m_TargetCret = nil then Wondering(); // FFEE   //Jacky
      end; //004A93D8
    end; //004A93D8  if not bo510 and ((GetTickCount - m_dwWalkTick) > n4FC) then begin
  end; //004A93D8

  inherited;

end;
{ end }


{TFireballMonster}

constructor TFireBallMonster.Create; //004A9690
begin
  inherited;
  m_dwSpellTick := GetTickCount();
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TFireBallMonster.Destroy;
begin
  inherited;
end;

procedure TFireBallMonster.Run; //004A9720
var
  BaseObject: TBaseObject;
  PlayObject: TPlayObject;
  nPower: Integer;
  //UserMagic: pTUserMagic;
  m_DefMsg: TDefaultMessage;
  n08, nAttackDir: Integer;
begin
  if not m_boDeath and
    not bo554 and
    not m_boGhost then
  begin
    if m_TargetCret <> nil then
    begin
      if Self.MagCanHitTarget(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret) then
      begin
        if Self.IsProperTarget(m_TargetCret) then
        begin
          if (abs(m_nTargetX - m_nCurrX) <= 8) and (abs(m_nTargetY - m_nCurrY) <= 8) then
          begin
            nPower := Random(SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1) + LoWord(m_WAbil.MC);
            if nPower > 0 then
            begin
              BaseObject := GetPoseCreate();
              if (BaseObject <> nil) and
                IsProperTarget(BaseObject) and
                (m_nAntiMagic >= 0) then
              begin
                nPower := BaseObject.GetMagStruckDamage(Self, nPower);
                if nPower > 0 then
                begin
                  BaseObject.StruckDamage(nPower);
                  if (GetTickCount - m_dwSpellTick) > Self.m_nNextHitTime then
                  begin
                    m_dwSpellTick := GetTickCount();
                    Self.SendRefMsg(RM_SPELL, 48, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 48, '');
                    Self.SendRefMsg(RM_MAGICFIRE, 0,
                      MakeWord(2, 48),
                      MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY),
                      Integer(m_TargetCret),
                      '');

                    Self.SendDelayMsg(TBaseObject(RM_STRUCK), RM_DELAYMAGIC, nPower, MakeLong(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), 2, Integer(m_TargetCret), '', 600);
                  end; //if npower
                end; //if wait
              end;
            end;
          end;
        end;
      end;
      BreakHolySeizeMode();
    end else
      m_TargetCret := nil;
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;





constructor TFireMonster.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TFireMonster.Destroy;
begin

  inherited;
end;

procedure TFireMonster.Run; //004A9720
var
  FireBurnEvent: TFireBurnEvent;
  nX, nY, nDamage, nTime: Integer;
begin
  if not m_boDeath and
    not bo554 and
    not m_boGhost and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) then
  begin
// do sqaure around boss
    nTime := 20;
    nDamage := 10;
    nX := m_nCurrX;
    nY := m_nCurrY;
 //bx:=bx+1;
// by:=by+1;

    if m_PEnvir.GetEvent(nX, nY - 1) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(Self, nX, nY - 1, ET_FIRE, nTime * 1000, nDamage);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //0492CFC   x //
    if m_PEnvir.GetEvent(nX, nY - 2) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(Self, nX, nY - 2, ET_FIRE, nTime * 1000, nDamage);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //0492CFC   x

    if m_PEnvir.GetEvent(nX - 1, nY) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(Self, nX - 1, nY, ET_FIRE, nTime * 1000, nDamage);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //0492D4D //
    if m_PEnvir.GetEvent(nX - 2, nY) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(Self, nX - 2, nY, ET_FIRE, nTime * 1000, nDamage);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //0492D4D

    if m_PEnvir.GetEvent(nX, nY) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(Self, nX, nY, ET_FIRE, nTime * 1000, nDamage);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //00492D9C


    if m_PEnvir.GetEvent(nX + 1, nY) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(Self, nX + 1, nY, ET_FIRE, nTime * 1000, nDamage);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //00492DED
    if m_PEnvir.GetEvent(nX + 2, nY) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(Self, nX + 2, nY, ET_FIRE, nTime * 1000, nDamage);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //00492DED

    if m_PEnvir.GetEvent(nX, nY + 1) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(Self, nX, nY + 1, ET_FIRE, nTime * 1000, nDamage);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //00492E3E
    if m_PEnvir.GetEvent(nX, nY + 2) = nil then
    begin
      FireBurnEvent := TFireBurnEvent.Create(Self, nX, nY + 2, ET_FIRE, nTime * 1000, nDamage);
      g_EventManager.AddEvent(FireBurnEvent);
    end; //00492E3E


 {do flames behind}
{if m_PEnvir.GetEvent(bx,by) = nil then begin  //behind
    FireBurnEvent:=TFireBurnEvent.Create(Self,bx,by,ET_FIRE,ntime * 1000 ,ndamage);
    g_EventManager.AddEvent(FireBurnEvent);
end;
if m_PEnvir.GetEvent(bx+1,by+1) = nil then begin  //behind
    FireBurnEvent:=TFireBurnEvent.Create(Self,bx+1,by+1,ET_FIRE,ntime * 1000 ,ndamage);
    g_EventManager.AddEvent(FireBurnEvent);
end;
if m_PEnvir.GetEvent(fx,fy) = nil then begin  //behind
    FireBurnEvent:=TFireBurnEvent.Create(Self,fx,fy,ET_FIRE,ntime * 1000 ,ndamage);
    g_EventManager.AddEvent(FireBurnEvent);
end;
if m_PEnvir.GetEvent(fx+1,fy+1) = nil then begin  //behind
    FireBurnEvent:=TFireBurnEvent.Create(Self,fx+1,fy+1,ET_FIRE,ntime * 1000 ,ndamage);
    g_EventManager.AddEvent(FireBurnEvent);
end;    }

{if m_PEnvir.GetEvent(bx-1,by) = nil then begin  //behind
    FireBurnEvent:=TFireBurnEvent.Create(Self,bx-1,by,ET_FIRE,ntime * 1000 ,ndamage);
    g_EventManager.AddEvent(FireBurnEvent);
end;
if m_PEnvir.GetEvent(bx-2,by) = nil then begin  //behind
    FireBurnEvent:=TFireBurnEvent.Create(Self,bx-2,by,ET_FIRE,ntime * 1000 ,ndamage);
    g_EventManager.AddEvent(FireBurnEvent);
end;
if m_PEnvir.GetEvent(bx-2,by+1) = nil then begin  //down left
    FireBurnEvent:=TFireBurnEvent.Create(Self,bx-2,by+1,ET_FIRE,ntime * 1000 ,ndamage);
    g_EventManager.AddEvent(FireBurnEvent);
end;
if m_PEnvir.GetEvent(bx-2,by+2) = nil then begin  //down left
    FireBurnEvent:=TFireBurnEvent.Create(Self,bx-2,by+2,ET_FIRE,ntime * 1000 ,ndamage);
    g_EventManager.AddEvent(FireBurnEvent);
end;
if m_PEnvir.GetEvent(fx,fy) = nil then begin  //front
    FireBurnEvent:=TFireBurnEvent.Create(Self,fx,fy,ET_FIRE,ntime * 1000 ,ndamage);
    g_EventManager.AddEvent(FireBurnEvent);
end;
if m_PEnvir.GetEvent(fx-1,fy) = nil then begin  //front
    FireBurnEvent:=TFireBurnEvent.Create(Self,fx-1,fy,ET_FIRE,ntime * 1000 ,ndamage);
    g_EventManager.AddEvent(FireBurnEvent);
end;
if m_PEnvir.GetEvent(fx+1,fy) = nil then begin  //front
    FireBurnEvent:=TFireBurnEvent.Create(Self,fx+1,fy,ET_FIRE,ntime * 1000 ,ndamage);
    g_EventManager.AddEvent(FireBurnEvent);
end;
if m_PEnvir.GetEvent(fx+2,fy) = nil then begin  //front
    FireBurnEvent:=TFireBurnEvent.Create(Self,fx+2,fy,ET_FIRE,ntime * 1000 ,ndamage);
    g_EventManager.AddEvent(FireBurnEvent);
end;
if m_PEnvir.GetEvent(fx+2,fy-1) = nil then begin  //front
    FireBurnEvent:=TFireBurnEvent.Create(Self,fx+2,fy-1,ET_FIRE,ntime * 1000 ,ndamage);
    g_EventManager.AddEvent(FireBurnEvent);
end;
if m_PEnvir.GetEvent(fx+2,fy-2) = nil then begin  //front
    FireBurnEvent:=TFireBurnEvent.Create(Self,fx+2,fy-2,ET_FIRE,ntime * 1000 ,ndamage);
    g_EventManager.AddEvent(FireBurnEvent);
end;  }


    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;



{ TFrostTigerMonster }

constructor TFrostTiger.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TFrostTiger.Destroy;
begin

  inherited;
end;

procedure TFrostTiger.Run; //004A9720
var
  BaseObject: TBaseObject;
  dosay: Boolean;
begin
  if not m_boDeath and
    not bo554 and
    not m_boGhost and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) then
  begin

    if m_TargetCret = nil then
    begin
      if m_wStatusTimeArr[STATE_TRANSPARENT {0x70}] = 0 then
      begin
        MagicManager.MagMakePrivateTransparent(Self, 180);
      end;
    end else
    begin
 //mainoutmessage('process say');
  // ProcessSayMsg('I see you ' + m_TargetCret.m_sCharName + ', you will be sorry!');
 //  dosay:=true;
      m_wStatusTimeArr[STATE_TRANSPARENT {0x70}] := 0;
    end;

    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;

{ TGreenMonster }

constructor TGreenMonster.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TGreenMonster.Destroy;
begin

  inherited;
end;

procedure TGreenMonster.Run; //004A9720
begin
  if not m_boDeath and
    not bo554 and
    not m_boGhost and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) then
  begin
    if m_TargetCret <> nil then
    begin
      m_nTargetX := m_TargetCret.m_nCurrX;
      m_nTargetY := m_TargetCret.m_nCurrY;
      if (abs(m_nTargetX - m_nCurrX) = 1) and (abs(m_nTargetY - m_nCurrY) = 1) then
      begin
        if (Random(m_TargetCret.m_btAntiPoison + 7) <= 6) and (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] = 0) then
        begin
          m_TargetCret.MakePosion(POISON_DECHEALTH, 30, 1);
        end;
      end;
    end;
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;

{ TRedMonster }

constructor TRedMonster.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TRedMonster.Destroy;
begin

  inherited;
end;

procedure TRedMonster.Run; //004A9720
begin
  if not m_boDeath and
    not bo554 and
    not m_boGhost and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) then
  begin
    if m_TargetCret <> nil then
    begin
      m_nTargetX := m_TargetCret.m_nCurrX;
      m_nTargetY := m_TargetCret.m_nCurrY;
      if (abs(m_nTargetX - m_nCurrX) = 1) and (abs(m_nTargetY - m_nCurrY) = 1) then
      begin
        if (Random(m_TargetCret.m_btAntiPoison + 7) <= 6) and (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] = 0) then
        begin
          m_TargetCret.MakePosion(POISON_DAMAGEARMOR, 30, 1);
        end;
      end;
    end;
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;

{ khazard }
constructor TKhazard.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TKhazard.Destroy;
begin

  inherited;
end;

procedure TKhazard.Run; //004A9720
var
  time1, nX, nY: Integer;
begin
  time1 := -1;
  if not m_boDeath and
    not bo554 and
    not m_boGhost and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) then
  begin
    time1 := Random(2);
    if m_TargetCret <> nil then
    begin
      m_nTargetX := m_TargetCret.m_nCurrX;
      m_nTargetY := m_TargetCret.m_nCurrY;
      if (abs(m_nTargetX - m_nCurrX) = 2) and (abs(m_nTargetY - m_nCurrY) = 2) then
      begin
        if time1 = 0 then
        begin //do drag back on random
          GetFrontPosition(nX, nY);
          m_TargetCret.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
          m_TargetCret.SpaceMove(m_sMapName, nX, nY, 0);
          if (Random(1) = 0) and (Random(m_TargetCret.m_btAntiPoison + 7) <= 6) then
          begin
            m_TargetCret.MakePosion(POISON_DECHEALTH, 35, 2);
            Exit;
          end;
        end else
        begin
          if m_TargetCret.m_WAbil.HP <= m_TargetCret.m_WAbil.MaxHP div 2 then //if target below half hp
            GetFrontPosition(nX, nY);
          m_TargetCret.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
          m_TargetCret.SpaceMove(m_sMapName, nX, nY, 0);
          if (Random(1) = 0) and (Random(m_TargetCret.m_btAntiPoison + 7) <= 6) then
          begin
            m_TargetCret.MakePosion(POISON_DECHEALTH, 35, 2);
            Exit;
          end;
        end;
      end;
    end;
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;
{ end }

{ runaway }
constructor TRunAway.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TRunAway.Destroy;
begin

  inherited;
end;

procedure TRunAway.Run; //004A9720
var
  time1, nX, nY: Integer;
  borunaway: Boolean;
begin
  if not m_boDeath and
    not bo554 and
    not m_boGhost then
  begin
    if m_TargetCret <> nil then
    begin
      m_nTargetX := m_TargetCret.m_nCurrX;
      m_nTargetY := m_TargetCret.m_nCurrY;
      if (m_WAbil.HP <= Round(m_WAbil.MaxHP div 2)) and (borunaway = False) then
      begin //if health less then 1/2
        GetFrontPosition(nX, nY);
        SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
        SpaceMove(m_sMapName, nX - 2, nY - 2, 0); //move backwards 3 spaces
        borunaway := True;
      end else
      begin
        if m_WAbil.HP >= Round(m_WAbil.MaxHP div 2) then
        begin
          borunaway := False;
        end;
      end;
      if borunaway then
      begin
        if Integer(GetTickCount - time1) > 5000 then
        begin
          if (abs(m_nTargetX - m_nCurrX) = 1) and (abs(m_nTargetY - m_nCurrY) = 1) then
          begin
            WalkTo(Random(4), True);
          end else
          begin
            WalkTo(Random(7), True);
          end;
        end else
        begin
          time1 := GetTickCount();
        end;
      end;
    end;
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;
{ end }

{ Tele mob }
constructor TTeleMonster.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TTeleMonster.Destroy;
begin

  inherited;
end;

procedure TTeleMonster.Run; //004A9720
begin
  if not m_boDeath and
    not bo554 and
    not m_boGhost and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) then
  begin
  //if it finds a target tele to him!
    if m_TargetCret <> nil then
    begin
      if (abs(m_nCurrX - m_nTargetX) > 5) or
        (abs(m_nCurrY - m_nTargetY) > 5) then
      begin
           // if 5 spaces away teleport to the enemy!
        SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
        SpaceMove(m_TargetCret.m_sMapName, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 0);
      end;
    end;
  //end
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
    end;
  end;
  inherited;
end;
{ end }

{ Defend Monster }
constructor TDefendMonster.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TDefendMonster.Destroy;
begin

  inherited;
end;

procedure TDefendMonster.Run; //004A9720
begin
  {if not m_boDeath and
     not bo554 and
     not m_boGhost then begin
  //if it finds a target 15 spaces away start sequence
  if (m_TargetCret <> nil) and (callguardrun=false) then begin

           // call guards!
           mainoutmessage('CALL GUARD' + inttostr(m_nCurrX) + ' ' + inttostr(m_nCurrY));
           callguard(m_sMapName,m_nCurrX,m_nCurrY);
          end;

    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
       (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then begin
      m_dwSearchEnemyTick:=GetTickCount();
      SearchTarget();
    end;
  end;   }
  inherited;
end;

procedure TDefendMonster.CallGuard(mapmap: string; xx, yy: Integer);
var
  i: Integer;
  nC: Integer;
  nX, nY: Integer;
  sMonName: array[0..3] of string;
  BaseObject: TBaseObject;
begin
  nC := 7; //how many areas around the boss
 // GetFrontPosition(nx,ny);
  sMonName[0] := 'Hen';
 // sMonName[1]:=sZuma2;
 // sMonName[2]:=sZuma3;
 // sMonName[3]:=sZuma4;
  nX := xx;
  nY := yy;

  for i := 0 to nC do
  begin
  { case i of
    0: begin
    Dec(nY);
    end;
    1: begin
       Inc(nX);
       Dec(nY);
      end;
    2: begin
     Inc(nX)
     end;
    3: begin
    Inc(nX);
       Inc(nY);
       end;
    4: begin
     Inc(nY);
     end;
    5: begin
             Dec(nX);
       Inc(nY);
       end;
    6: begin
     Dec(nX);
     end;
    7: begin
             Dec(nX);
        Dec(nY);
        end;
    end;}
   // if m_GuardObjects.Count >= 5 then break;
    BaseObject := UserEngine.RegenMonsterByName(mapmap, nX, nY, sMonName[0]);
    if BaseObject <> nil then
    begin
      m_GuardObjects.Add(BaseObject);
    end;
  end; // for
  callguardrun := True; //tell it its already been run!
end;




constructor TClone.Create; //004AA4B4
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TClone.Destroy;
begin

  inherited;
end;

function TClone.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  if (ProcessMsg.wIdent = RM_STRUCK) or (ProcessMsg.wIdent = RM_MAGSTRUCK) or (ProcessMsg.wIdent = RM_SPELL) then
  begin
    if m_Master <> nil then
    begin
      if m_Master.m_WAbil.MP <= 0 then m_WAbil.HP := 0; //kill slave if your mp is 0
      if (ProcessMsg.wIdent = RM_SPELL) then
      begin
        MainOutMessage('rmSpell: ' + IntToStr(ProcessMsg.nParam3));
        Dec(m_Master.m_WAbil.MP, ProcessMsg.nParam3);
      end else
      begin
        MainOutMessage('rmHit: ' + IntToStr(ProcessMsg.wParam));
        Dec(m_Master.m_WAbil.MP, ProcessMsg.wParam);
      end;
    end;
  end;
end;

procedure TClone.LightingAttack(nDir: Integer);
var
  nSX, nSY, nTX, nTY, nPwr: Integer;
  WAbil: pTAbility;
begin
  m_btDirection := nDir;
  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
  if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, nDir, 1, nSX, nSY) then
  begin
    m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, nDir, 9, nTX, nTY);
    WAbil := @m_WAbil;
    nPwr := (Random(SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
    MagPassThroughMagic(nSX, nSY, nTX, nTY, nDir, nPwr, True);
  end;
  BreakHolySeizeMode();
end;


procedure TClone.Struck(hiter: TBaseObject);
begin
  if hiter = nil then Exit;
  {m_btDirection:=hiter.m_btDirection;
  n550:=Random(4) + (n550 + 4);
  n550:=_MIN(20,n550);
  m_PEnvir.GetNextPosition(m_nCurrX,m_nCurrY,m_btDirection,n550,m_nTargetX,m_nTargetY);}
end;


procedure TClone.Run; //004AA604
var
  n08, nAttackDir: Integer;
begin
  n08 := 9999;
  if (not m_boDeath) and
    (not bo554) and
    (not m_boGhost) and
    (m_wStatusTimeArr[POISON_STONE {5 0x6A}] = 0) and
    ((GetTickCount - m_dwSearchEnemyTick) > 8000) then
  begin

    if ((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil) then
    begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();
      //nicky
      //SearchMobF;
    end;
    if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) and
      (m_TargetCret <> nil) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 4) and
      (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 4) then
    begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and
        (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) and
        (Random(3) <> 0) then
      begin
        inherited;
        Exit;
      end;
      GetBackPosition(m_nTargetX, m_nTargetY);
    end;
    if (m_TargetCret <> nil) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) < 6) and
      (abs(m_nCurrY - m_TargetCret.m_nCurrY) < 6) and
      (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then
    begin

      m_dwHitTick := GetTickCount();
      nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      LightingAttack(nAttackDir);
    end;
  end;
  inherited;
end;







end.

