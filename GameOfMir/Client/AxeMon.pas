unit AxeMon;

interface

uses
  Windows, Messages, SysUtils, Classes, ExtCtrls, Graphics, Controls, Forms, Dialogs,
  Grobal2, DxDraws, CliUtil, ClFunc, magiceff, Actor, ClEvent;


const
   DEATHEFFECTBASE = 340;
   DEATHFIREEFFECTBASE = 2860;
   AXEMONATTACKFRAME = 6;
   KUDEGIGASBASE = 1445;
   COWMONFIREBASE = 1800;
   COWMONLIGHTBASE = 1900;
   ZOMBILIGHTINGBASE = 350;
   ZOMBIDIEBASE = 340;
   ZOMBILIGHTINGEXPBASE = 520;
   SCULPTUREFIREBASE = 1680;
   MOTHPOISONGASBASE = 3590;
   DUNGPOISONGASBASE = 3590;
   WARRIORELFFIREBASE = 820;
   //Jacky
   SUPERIORGUARDBASE = 760;

type
   TSkeletonOma = class (TActor) //Size:25C
   private
   protected
      EffectSurface: TDirectDrawSurface;    //0x240
      ax:Integer;                           //0x244
      ay: integer;                          //0x248
   public
      constructor Create; override;
      //destructor Destroy; override;
      procedure CalcActorFrame; override;
      function  GetDefaultFrame (wmode: Boolean): integer; override;
      procedure LoadSurface; override;
      procedure Run; override;
      procedure DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean); override;
   end;

   TDualAxeOma = class (TSkeletonOma)  //도끼던지는 몹
   private
   public
      procedure Run; override;
   end;

   TCatMon = class (TSkeletonOma)
   private
   public
      procedure DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean); override;
   end;

   TArcherMon = class (TCatMon)//Size: 0x25C Address: 0x00461A90
   public
      procedure Run; override;
   end;

   TScorpionMon = class (TCatMon)
   public
   end;

   THuSuABi = class (TSkeletonOma)
   public
      procedure LoadSurface; override;
   end;

   TZombiDigOut = class (TSkeletonOma)
   public
      procedure RunFrameAction (frame: integer); override;
   end;

   TZombiZilkin = class (TSkeletonOma)
   public
   end;

   TWhiteSkeleton = class (TSkeletonOma)
   public
   end;


   TGasKuDeGi = class (TActor)//Size 0x274
   protected
      AttackEffectSurface :TDirectDrawSurface;    //0x250
      DieEffectSurface    :TDirectDrawSurface;    //0x254
      BoUseDieEffect      :Boolean;    //0x258
      firedir             :integer;    //0x25C
      fire16dir           :integer;    //0c260
      ax                  :integer;    //0x264
      ay                  :integer;    //0x268
      bx                  :integer;
      by                  :integer;
   public
      constructor Create; override;
      procedure CalcActorFrame; override;
      function  GetDefaultFrame (wmode: Boolean): integer; override;
      procedure LoadSurface; override;
      procedure Run; override;
      procedure DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean); override;
      procedure DrawEff (dsurface: TDirectDrawSurface; dx, dy: integer); override;
   end;

   TFireCowFaceMon = class (TGasKuDeGi)
   public
      function   Light: integer; override;
   end;

   TCowFaceKing = class (TGasKuDeGi)
   public
      function   Light: integer; override;
   end;

   TZombiLighting = class (TGasKuDeGi)
   protected
   public
   end;
   TSuperiorGuard = class (TGasKuDeGi)
   protected
   public
   end;
   TExplosionSpider = class (TGasKuDeGi)
   protected
   public
      procedure CalcActorFrame; override;
      procedure LoadSurface; override;   
   end;
   TFlyingSpider = class (TSkeletonOma)//Size: 0x25C Address: 0x00461F38
   protected
   public
     procedure CalcActorFrame; override;
   end;
   TSculptureMon = class (TSkeletonOma)
   private
      AttackEffectSurface: TDirectDrawSurface;
      ax, ay, firedir: integer;
   public
      procedure CalcActorFrame; override;
      procedure LoadSurface; override;
      function  GetDefaultFrame (wmode: Boolean): integer; override;
      procedure DrawEff (dsurface: TDirectDrawSurface; dx, dy: integer); override;
      procedure Run; override;
   end;

   TSculptureKingMon = class (TSculptureMon)
   public
   end;

   TSmallElfMonster = class (TSkeletonOma)
   public
   end;

   TWarriorElfMonster = class (TSkeletonOma)
   private
      oldframe: integer;
   public
      procedure  RunFrameAction (frame: integer); override;  //프래임마다 독특하게 해야할일
   end;
   //댕秦誌
   TElectronicScolpionMon = class (TGasKuDeGi)//Size 0x274 0x3c
   protected
   public
      procedure CalcActorFrame; override;
      procedure LoadSurface; override;
   end;
   TBossPigMon = class (TGasKuDeGi)//0x3d
   protected
   public
      procedure LoadSurface; override;   
   end;
   TKingOfSculpureKingMon = class (TGasKuDeGi)//0x3e
   protected
   public
      procedure CalcActorFrame; override;
      procedure LoadSurface; override;   
   end;
   TSkeletonKingMon = class (TGasKuDeGi)//0x3f
   protected
   public
      procedure CalcActorFrame; override;
      procedure LoadSurface; override;
      procedure Run; override;   
   end;
   TSamuraiMon = class (TGasKuDeGi)//0x41
   protected
   public
   end;
   TSkeletonSoldierMon = class (TGasKuDeGi)//0x42 0x43 0x44
   protected
   public
   end;
   TSkeletonArcherMon = class (TArcherMon)//Size: 0x26C Address: 0x004623B4 //0x45
      AttackEffectSurface :TDirectDrawSurface;//0x25C
      bo260:Boolean;
      n264:integer;
      n268:integer;
   protected
   public
      procedure CalcActorFrame; override;
      procedure LoadSurface; override;
      procedure Run; override;
      procedure DrawEff (dsurface: TDirectDrawSurface; dx, dy: integer); override;
   end;
   TBanyaGuardMon = class (TSkeletonArcherMon)//Size: 0x270 Address: 0x00462430 0x46 0x47 0x48 0x4e
     n26C:TDirectDrawSurface;
   protected
   public
      constructor Create; override;
      procedure CalcActorFrame; override;
      procedure LoadSurface; override;
      procedure Run; override;
      procedure DrawEff (dsurface: TDirectDrawSurface; dx, dy: integer); override;
   end;
   TStoneMonster = class (TSkeletonArcherMon)//Size: 0x270 0x4d 0x4b
     n26C:TDirectDrawSurface;
   protected
   public
      constructor Create; override;
      procedure CalcActorFrame; override;
      procedure LoadSurface; override;
      procedure Run; override;
      procedure DrawEff (dsurface: TDirectDrawSurface; dx, dy: integer); override;   
   end;
   TPBOMA1Mon = class (TCatMon)//0x49
   protected
   public
      procedure Run; override;   
   end;
   TPBOMA6Mon = class (TCatMon)//0x4f
   protected
   public
      procedure Run; override;
   end;
   TAngel = class (TBanyaGuardMon)//Size: 0x27C 0x51
     n270:Integer;
     n274:Integer;
     n278:TDirectDrawSurface;
   protected
   public
      procedure  LoadSurface; override;
      procedure  DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean); override;
   end;
   TFireDragon = class (TSkeletonArcherMon)//0x53
     n270:TDirectDrawSurface;
   private
      procedure AttackEff;   
   protected
   public
      constructor Create; override;
      procedure CalcActorFrame; override;
      procedure LoadSurface; override;
      procedure Run; override;
      procedure DrawEff (dsurface: TDirectDrawSurface; dx, dy: integer); override;   
   end;
   TDragonStatue = class (TSkeletonArcherMon)//Size: 0x270 0x54
     n26C:TDirectDrawSurface;
   protected
   public
      constructor Create; override;
      procedure CalcActorFrame; override;
      procedure LoadSurface; override;
      procedure Run; override;
      procedure DrawEff (dsurface: TDirectDrawSurface; dx, dy: integer); override;   
   end;
implementation

uses
   ClMain, SoundUtil, WIL, MShare;


{============================== TSkeletonOma =============================}

//      해골 오마(해골, 큰도끼해골, 해골전사)

{--------------------------}


constructor TSkeletonOma.Create;
begin
   inherited Create;
   EffectSurface := nil;
   m_boUseEffect := FALSE;
end;

procedure TSkeletonOma.CalcActorFrame;
var
   pm: PTMonsterAction;
   haircount: integer;
begin
   m_nCurrentFrame := -1;
   m_boReverseFrame := FALSE;
   m_boUseEffect := FALSE;

   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;

   case m_nCurrentAction of
      SM_TURN:
         begin
            m_nStartFrame := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
            m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
            m_dwFrameTime := pm.ActStand.ftime;
            m_dwStartTime := GetTickCount;
            m_nDefFrameCount := pm.ActStand.frame;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_WALK, SM_BACKSTEP:
         begin
            m_nStartFrame := pm.ActWalk.start + m_btDir * (pm.ActWalk.frame + pm.ActWalk.skip);
            m_nEndFrame := m_nStartFrame + pm.ActWalk.frame - 1;
            m_dwFrameTime := pm.ActWalk.ftime;
            m_dwStartTime := GetTickCount;
            m_nMaxTick := pm.ActWalk.UseTick;
            m_nCurTick := 0;
            //WarMode := FALSE;
            m_nMoveStep := 1;
            if m_nCurrentAction = SM_WALK then
               Shift (m_btDir, m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1)
            else  //sm_backstep
               Shift (GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1);
         end;
      SM_DIGUP: //걷기 없음, SM_DIGUP, 방향 없음.
         begin
            if (m_btRace = 23) then begin //or (m_btRace = 54) or (m_btRace = 55) then begin
               //백골
               m_nStartFrame := pm.ActDeath.start;
            end else begin
               m_nStartFrame := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip);
            end;
            m_nEndFrame := m_nStartFrame + pm.ActDeath.frame - 1;
            m_dwFrameTime := pm.ActDeath.ftime;
            m_dwStartTime := GetTickCount;
            //WarMode := FALSE;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_DIGDOWN:
         begin
            if m_btRace = 55 then begin
               //신수1 인 경우 역변신
               m_nStartFrame := pm.ActCritical.start + m_btDir * (pm.ActCritical.frame + pm.ActCritical.skip);
               m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
               m_dwFrameTime := pm.ActCritical.ftime;
               m_dwStartTime := GetTickCount;
               m_boReverseFrame := TRUE;
               //WarMode := FALSE;
               Shift (m_btDir, 0, 0, 1);
            end;
         end;
      SM_HIT,
      SM_FLYAXE,
      SM_LIGHTING:
         begin
            m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
            m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
            m_dwFrameTime := pm.ActAttack.ftime;
            m_dwStartTime := GetTickCount;
            //WarMode := TRUE;
            m_dwWarModeTime := GetTickCount;
            if (m_btRace = 16) or (m_btRace = 54) then
               m_boUseEffect := TRUE;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_STRUCK:
         begin
            m_nStartFrame := pm.ActStruck.start + m_btDir * (pm.ActStruck.frame + pm.ActStruck.skip);
            m_nEndFrame := m_nStartFrame + pm.ActStruck.frame - 1;
            m_dwFrameTime := m_dwStruckFrameTime; //pm.ActStruck.ftime;
            m_dwStartTime := GetTickCount;
         end;
      SM_DEATH:
         begin
            m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
            m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
            m_nStartFrame := m_nEndFrame; //
            m_dwFrameTime := pm.ActDie.ftime;
            m_dwStartTime := GetTickCount;
         end;
      SM_NOWDEATH:
         begin
            m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
            m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
            m_dwFrameTime := pm.ActDie.ftime;
            m_dwStartTime := GetTickCount;
            if m_btRace <> 22 then
               m_boUseEffect := TRUE;
         end;
      SM_SKELETON:
         begin
            m_nStartFrame := pm.ActDeath.start;
            m_nEndFrame := m_nStartFrame + pm.ActDeath.frame - 1;
            m_dwFrameTime := pm.ActDeath.ftime;
            m_dwStartTime := GetTickCount;
         end;
      SM_ALIVE:
         begin
            m_nStartFrame := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip);
            m_nEndFrame := m_nStartFrame + pm.ActDeath.frame - 1;
            m_dwFrameTime := pm.ActDeath.ftime;
            m_dwStartTime := GetTickCount;
         end;
   end;
end;

function  TSkeletonOma.GetDefaultFrame (wmode: Boolean): integer;
var
   cf, dr: integer;
   pm: PTMonsterAction;
begin
   Result:=0;//jacky
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;

   if m_boDeath then begin
      //우면귀일 경우
      if m_wAppearance in [30..34, 151] then //우면귀인 경우 시체가 사람을 덮는 것을 막기 위해
         m_nDownDrawLevel := 1;

      if m_boSkeleton then
         Result := pm.ActDeath.start
      else Result := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip) + (pm.ActDie.frame - 1);
   end else begin
      m_nDefFrameCount := pm.ActStand.frame;
      if m_nCurrentDefFrame < 0 then cf := 0
      else if m_nCurrentDefFrame >= pm.ActStand.frame then cf := 0
      else cf := m_nCurrentDefFrame;
      Result := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
   end;
end;

procedure  TSkeletonOma.LoadSurface;
begin
   inherited LoadSurface;
   case m_btRace of
      //몬스터
      14, 15, 17, 22, 53:
         begin
            if m_boUseEffect then
               EffectSurface := FrmMain.WMon3Img.GetCachedImage (DEATHEFFECTBASE + m_nCurrentFrame-m_nStartFrame, ax, ay);
         end;
      23:
         begin
            if m_nCurrentAction = SM_DIGUP then begin
               m_BodySurface := nil;
               EffectSurface := FrmMain.WMon4Img.GetCachedImage (m_nBodyOffset + m_nCurrentFrame, ax, ay);
               m_boUseEffect := TRUE;
            end else
               m_boUseEffect := FALSE;
         end;
   end;
end;

procedure  TSkeletonOma.Run;
var
   prv: integer;
   m_dwFrameTimetime: longword;
begin
   if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then exit;

   m_boMsgMuch := FALSE;
   if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;

   //사운드 효과
   RunActSound (m_nCurrentFrame - m_nStartFrame);
   RunFrameAction (m_nCurrentFrame - m_nStartFrame);

   prv := m_nCurrentFrame;
   if m_nCurrentAction <> 0 then begin
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
         m_nCurrentFrame := m_nStartFrame;

      if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else m_dwFrameTimetime := m_dwFrameTime;

      if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
         if m_nCurrentFrame < m_nEndFrame then begin
            Inc (m_nCurrentFrame);
            m_dwStartTime := GetTickCount;
         end else begin
            //동작이 끝남.
            m_nCurrentAction := 0; //동작 완료
            m_boUseEffect := FALSE;
         end;
      end;
      m_nCurrentDefFrame := 0;
      m_dwDefFrameTime := GetTickCount;
   end else begin
      if GetTickCount - m_dwSmoothMoveTime > 200 then begin
         if GetTickCount - m_dwDefFrameTime > 500 then begin
            m_dwDefFrameTime := GetTickCount;
            Inc (m_nCurrentDefFrame);
            if m_nCurrentDefFrame >= m_nDefFrameCount then
               m_nCurrentDefFrame := 0;
         end;
         DefaultMotion;
      end;
   end;

   if prv <> m_nCurrentFrame then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface;
   end;

end;


procedure TSkeletonOma.DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean);
var
   idx: integer;
   d: TDirectDrawSurface;
   ceff: TColorEffect;
begin
   if not (m_btDir in [0..7]) then exit;
   if GetTickCount - m_dwLoadSurfaceTime > 60 * 1000 then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface; //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
   end;

   ceff := GetDrawEffectValue;

   if m_BodySurface <> nil then begin
      DrawEffSurface (dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);
   end;

   if m_boUseEffect then
      if EffectSurface <> nil then begin
         DrawBlend (dsurface,
                    dx + ax + m_nShiftX,
                    dy + ay + m_nShiftY,
                    EffectSurface, 1);
      end;
end;




{============================== TSkeletonOma =============================}

//      해골 오마(해골, 큰도끼해골, 해골전사)

{--------------------------}


procedure  TDualAxeOma.Run;
var
   prv: integer;
   m_dwFrameTimetime: longword;
   meff: TFlyingAxe;
begin
   if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then exit;

   m_boMsgMuch := FALSE;
   if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;

   //사운드 효과
   RunActSound (m_nCurrentFrame - m_nStartFrame);
   //프래임마다 해야 할일
   RunFrameAction (m_nCurrentFrame - m_nStartFrame);

   prv := m_nCurrentFrame;
   if m_nCurrentAction <> 0 then begin
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
         m_nCurrentFrame := m_nStartFrame;

      if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else m_dwFrameTimetime := m_dwFrameTime;

      if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
         if m_nCurrentFrame < m_nEndFrame then begin
            Inc (m_nCurrentFrame);
            m_dwStartTime := GetTickCount;
         end else begin
            //동작이 끝남.
            m_nCurrentAction := 0; //동작 완료
            m_boUseEffect := FALSE;
         end;
         if (m_nCurrentAction = SM_FLYAXE) and (m_nCurrentFrame-m_nStartFrame = AXEMONATTACKFRAME-4) then begin
            //마법 발사
            meff := TFlyingAxe (PlayScene.NewFlyObject (self,
                             m_nCurrX,
                             m_nCurrY,
                             m_nTargetX,
                             m_nTargetY,
                             m_nTargetRecog,
                             mtFlyAxe));
            if meff <> nil then begin
               meff.ImgLib := FrmMain.WMon3Img;
               case m_btRace of
                  15: meff.FlyImageBase := FLYOMAAXEBASE;
                  22: meff.FlyImageBase := THORNBASE;
               end;
            end;      
         end;
      end;
      m_nCurrentDefFrame := 0;
      m_dwDefFrameTime := GetTickCount;
   end else begin
      if GetTickCount - m_dwSmoothMoveTime > 200 then begin
         if GetTickCount - m_dwDefFrameTime > 500 then begin
            m_dwDefFrameTime := GetTickCount;
            Inc (m_nCurrentDefFrame);
            if m_nCurrentDefFrame >= m_nDefFrameCount then
               m_nCurrentDefFrame := 0;
         end;
         DefaultMotion;
      end;
   end;

   if prv <> m_nCurrentFrame then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface;
   end;

end;


{============================== TGasKuDeGi =============================}

//         TCatMon : 괭이,  프래임은 해골이랑 같고, 터지는 애니가 없음.


procedure  TWarriorElfMonster.RunFrameAction (frame: integer); //프래임마다 독특하게 해야할일
var
   meff: TMapEffect;
   event: TClEvent;
begin
   if m_nCurrentAction = SM_HIT then begin
      if (frame = 5) and (oldframe <> frame) then begin
         meff := TMapEffect.Create (WARRIORELFFIREBASE + 10 * m_btDir + 1, 5, m_nCurrX, m_nCurrY);
         meff.ImgLib := FrmMain.WMon18Img;
         meff.NextFrameTime := 100;
         PlayScene.m_EffectList.Add (meff);
      end;
      oldframe := frame;
   end;
end;

{============================== TGasKuDeGi =============================}

//         TCatMon : 괭이,  프래임은 해골이랑 같고, 터지는 애니가 없음.

{--------------------------}


procedure TCatMon.DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean);
var
   idx: integer;
   d: TDirectDrawSurface;
   ceff: TColorEffect;
begin
   if not (m_btDir in [0..7]) then exit;
   if GetTickCount - m_dwLoadSurfaceTime > 60 * 1000 then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface; //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
   end;

   ceff := GetDrawEffectValue;

   if m_BodySurface <> nil then
      DrawEffSurface (dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);

end;


{============================= TArcherMon =============================}


procedure TArcherMon.Run;
var
   prv: integer;
   m_dwFrameTimetime: longword;
   meff: TFlyingAxe;
begin
   if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then exit;

   m_boMsgMuch := FALSE;
   if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;

   //사운드 효과
   RunActSound (m_nCurrentFrame - m_nStartFrame);
   //프래임마다 해야 할일
   RunFrameAction (m_nCurrentFrame - m_nStartFrame);

   prv := m_nCurrentFrame;
   if m_nCurrentAction <> 0 then begin
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
         m_nCurrentFrame := m_nStartFrame;

      if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else m_dwFrameTimetime := m_dwFrameTime;

      if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
         if m_nCurrentFrame < m_nEndFrame then begin
            Inc (m_nCurrentFrame);
            m_dwStartTime := GetTickCount;
         end else begin
            //동작이 끝남.
            m_nCurrentAction := 0; //동작 완료
            m_boUseEffect := FALSE;
         end;
         if (m_nCurrentAction = SM_FLYAXE) and (m_nCurrentFrame-m_nStartFrame = 4) then begin
            //화살 나감
//(** 6월패치

            meff := TFlyingArrow (PlayScene.NewFlyObject (self,
                             m_nCurrX,
                             m_nCurrY,
                             m_nTargetX,
                             m_nTargetY,
                             m_nTargetRecog,
                             mtFlyArrow));
            if meff <> nil then begin
               meff.ImgLib := FrmMain.WEffectImg; //WMon5Img;
               meff.NextFrameTime := 30;
               meff.FlyImageBase := ARCHERBASE2;
            end;
//**)
(** 이전
            meff := TFlyingArrow (PlayScene.NewFlyObject (self,
                             XX,
                             YY,
                             TargetX,
                             TargetY,
                             TargetRecog,
                             mtFlyAxe));
            if meff <> nil then begin
               meff.ImgLib := FrmMain.WMon5Img;
               meff.NextFrameTime := 30;
               meff.FlyImageBase := ARCHERBASE;
            end;
//**)
         end;
      end;
      m_nCurrentDefFrame := 0;
      m_dwDefFrameTime := GetTickCount;
   end else begin
      if GetTickCount - m_dwSmoothMoveTime > 200 then begin
         if GetTickCount - m_dwDefFrameTime > 500 then begin
            m_dwDefFrameTime := GetTickCount;
            Inc (m_nCurrentDefFrame);
            if m_nCurrentDefFrame >= m_nDefFrameCount then
               m_nCurrentDefFrame := 0;
         end;
         DefaultMotion;
      end;
   end;

   if prv <> m_nCurrentFrame then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface;
   end;

end;


{============================= TZombiDigOut =============================}


procedure TZombiDigOut.RunFrameAction (frame: integer);
var
   clevent: TClEvent;
begin
   if m_nCurrentAction = SM_DIGUP then begin
      if frame = 6 then begin
         clevent := TClEvent.Create (m_nCurrentEvent, m_nCurrX, m_nCurrY, ET_DIGOUTZOMBI);
         clevent.m_nDir := m_btDir;
         EventMan.AddEvent (clevent);
         //pdo.DSurface := FrmMain.WMon6Img.GetCachedImage (ZOMBIDIGUPDUSTBASE+Dir, pdo.px, pdo.py);
      end;
   end;
end;


{============================== THuSuABi =============================}

//      허수아비

{--------------------------}


procedure  THuSuABi.LoadSurface;
begin
   inherited LoadSurface;
   if m_boUseEffect then
      EffectSurface := FrmMain.WMon3Img.GetCachedImage (DEATHFIREEFFECTBASE + m_nCurrentFrame-m_nStartFrame, ax, ay);
end;


{============================== TGasKuDeGi =============================}

//      대형구데기 (가스쏘는 구데기)

{--------------------------}


constructor TGasKuDeGi.Create;
begin
   inherited Create;
   AttackEffectSurface := nil;
   DieEffectSurface := nil;
   m_boUseEffect := FALSE;
   BoUseDieEffect := FALSE;
end;

procedure TGasKuDeGi.CalcActorFrame;
var
   pm: PTMonsterAction;
   actor: TActor;
   haircount, scx, scy, stx, sty: integer;
   meff: TCharEffect;
begin
   m_nCurrentFrame := -1;

   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;

   case m_nCurrentAction of
      SM_TURN:
         begin
            m_nStartFrame := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
            m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
            m_dwFrameTime := pm.ActStand.ftime;
            m_dwStartTime := GetTickCount;
            m_nDefFrameCount := pm.ActStand.frame;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_WALK:
         begin
            m_nStartFrame := pm.ActWalk.start + m_btDir * (pm.ActWalk.frame + pm.ActWalk.skip);
            m_nEndFrame := m_nStartFrame + pm.ActWalk.frame - 1;
            m_dwFrameTime := pm.ActWalk.ftime;
            m_dwStartTime := GetTickCount;
            m_nMaxTick := pm.ActWalk.UseTick;
            m_nCurTick := 0;
            //WarMode := FALSE;
            m_nMoveStep := 1;
            if m_nCurrentAction = SM_WALK then
               Shift (m_btDir, m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1)
            else  //sm_backstep
               Shift (GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1);
         end;
      SM_HIT,
      SM_LIGHTING:
         begin
            m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
            m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
            m_dwFrameTime := pm.ActAttack.ftime;
            m_dwStartTime := GetTickCount;
            //WarMode := TRUE;
            m_dwWarModeTime := GetTickCount;
            Shift (m_btDir, 0, 0, 1);
            m_boUseEffect := TRUE;
            firedir := m_btDir;
            m_nEffectFrame := m_nStartFrame;
            m_nEffectStart := m_nStartFrame;
            if m_btRace = 20 then m_nEffectEnd := m_nEndFrame + 1
            else m_nEffectEnd := m_nEndFrame;
            m_dwEffectStartTime := GetTickCount;
            m_dwEffectFrameTime := m_dwFrameTime;

            //16방향인 마법 설정
            actor := PlayScene.FindActor (m_nTargetRecog);
            if actor <> nil then begin
               PlayScene.ScreenXYfromMCXY (m_nCurrX, m_nCurrY, scx, scy);
               PlayScene.ScreenXYfromMCXY (actor.m_nCurrX, actor.m_nCurrY, stx, sty);
               fire16dir := GetFlyDirection16 (scx, scy, stx, sty);
               //meff := TCharEffect.Create (ZOMBILIGHTINGEXPBASE, 12, actor);  //맞는 사람 효과
               //meff.ImgLib := FrmMain.WMon5Img;
               //meff.NextFrameTime := 50;
               //PlayScene.EffectList.Add (meff);
            end else
               fire16dir := firedir * 2;
         end;
      SM_STRUCK:
         begin
            m_nStartFrame := pm.ActStruck.start + m_btDir * (pm.ActStruck.frame + pm.ActStruck.skip);
            m_nEndFrame := m_nStartFrame + pm.ActStruck.frame - 1;
            m_dwFrameTime := m_dwStruckFrameTime; //pm.ActStruck.ftime;
            m_dwStartTime := GetTickCount;
         end;
      SM_DEATH:
         begin
            m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
            m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
            m_nStartFrame := m_nEndFrame; //
            m_dwFrameTime := pm.ActDie.ftime;
            m_dwStartTime := GetTickCount;
         end;
      SM_NOWDEATH:
         begin
            m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
            m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
            m_dwFrameTime := pm.ActDie.ftime;
            m_dwStartTime := GetTickCount;
            {
            if m_btRace = 40 then
               BoUseDieEffect := TRUE;
            }
            if (m_btRace = 40) or (m_btRace = 65) or (m_btRace = 66) or (m_btRace = 67) or (m_btRace = 68) or (m_btRace = 69) then
               BoUseDieEffect := TRUE;
         end;
      SM_SKELETON:
         begin
            m_nStartFrame := pm.ActDeath.start;
            m_nEndFrame := m_nStartFrame + pm.ActDeath.frame - 1;
            m_dwFrameTime := pm.ActDeath.ftime;
            m_dwStartTime := GetTickCount;
         end;
   end;
end;

function  TGasKuDeGi.GetDefaultFrame (wmode: Boolean): integer;
var
   cf, dr: integer;
   pm: PTMonsterAction;
begin
   Result:=0;//jacky
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;

   if m_boDeath then begin
      if m_boSkeleton then
         Result := pm.ActDeath.start
      else Result := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip) + (pm.ActDie.frame - 1);
   end else begin
      m_nDefFrameCount := pm.ActStand.frame;
      if m_nCurrentDefFrame < 0 then cf := 0
      else if m_nCurrentDefFrame >= pm.ActStand.frame then cf := 0
      else cf := m_nCurrentDefFrame;
      Result := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
   end;
end;

procedure  TGasKuDeGi.LoadSurface;
begin
   inherited LoadSurface;
   case m_btRace of
      //묑샌槻벎
      16://떪협
         begin
            if m_boUseEffect then
               AttackEffectSurface := FrmMain.WMon3Img.GetCachedImage (
                        KUDEGIGASBASE-1 + (firedir * 10) + m_nEffectFrame-m_nEffectStart, //가스는 처음 한프레음 늦게 시작함.
                        ax, ay);
         end;
      20://삽落怪쯔
         begin
            if m_boUseEffect then
               AttackEffectSurface := FrmMain.WMon4Img.GetCachedImage (
                        COWMONFIREBASE + (firedir * 10) + m_nEffectFrame-m_nEffectStart, //
                        ax, ay);
         end;
      21://怪쯔싱寮
         begin
            if m_boUseEffect then
               AttackEffectSurface := FrmMain.WMon4Img.GetCachedImage (
                        COWMONLIGHTBASE + (firedir * 10) + m_nEffectFrame-m_nEffectStart, //
                        ax, ay);
         end;
      24:
         begin
            if m_boUseEffect then
               AttackEffectSurface := FrmMain.WMonImg.GetCachedImage (
                        SUPERIORGUARDBASE + (m_btDir * 8) + m_nEffectFrame-m_nEffectStart, //
                        ax, ay);
         end;

      40://쉘暇1
         begin
            if m_boUseEffect then begin
               AttackEffectSurface := FrmMain.WMon5Img.GetCachedImage (
                        ZOMBILIGHTINGBASE + (fire16dir * 10) + m_nEffectFrame-m_nEffectStart, //
                        ax, ay);
            end;
            if BoUseDieEffect then begin
               DieEffectSurface := FrmMain.WMon5Img.GetCachedImage (
                        ZOMBIDIEBASE + m_nCurrentFrame-m_nStartFrame, //
                        bx, by);
            end;
         end;
      52://珪띔
         begin
            if m_boUseEffect then
               AttackEffectSurface := FrmMain.WMon4Img.GetCachedImage (
                        MOTHPOISONGASBASE + (firedir * 10) + m_nEffectFrame-m_nEffectStart, //
                        ax, ay);
         end;
      53://룅녔
         begin
            if m_boUseEffect then
               AttackEffectSurface := FrmMain.WMon3Img.GetCachedImage (
                        DUNGPOISONGASBASE + (firedir * 10) + m_nEffectFrame-m_nEffectStart, //
                        ax, ay);
         end;
      64: begin
        if m_boUseEffect then begin
          AttackEffectSurface := FrmMain.WMon20Img.GetCachedImage (
                        720 + (firedir * 10) + m_nEffectFrame-m_nEffectStart, //
                        ax, ay);
        end;
      end;
      65: begin
        if BoUseDieEffect then begin
          DieEffectSurface:= FrmMain.WMon20Img.GetCachedImage (
                        350 + m_nCurrentFrame-m_nStartFrame, bx, by);
        end;
      end;
      66: begin
        if BoUseDieEffect then begin
          DieEffectSurface:= FrmMain.WMon20Img.GetCachedImage (
                        1600 + m_nCurrentFrame-m_nStartFrame, bx, by);
        end;
      end;
      67: begin
        if BoUseDieEffect then begin
          DieEffectSurface:= FrmMain.WMon20Img.GetCachedImage (
                        1160 + (m_btDir * 10) + m_nCurrentFrame-m_nStartFrame, bx, by);
        end;
      end;
      68: begin
        if BoUseDieEffect then begin
          DieEffectSurface:= FrmMain.WMon20Img.GetCachedImage (
                        1600 + m_nCurrentFrame-m_nStartFrame, bx, by);
        end;
      end;

   end;
end;

procedure  TGasKuDeGi.Run;
var
   prv: integer;
   m_dwEffectFrameTimetime, m_dwFrameTimetime: longword;
begin
   if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then exit;

   m_boMsgMuch := FALSE;
   if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;

   //
   RunActSound (m_nCurrentFrame - m_nStartFrame);
   RunFrameAction (m_nCurrentFrame - m_nStartFrame);

   if m_boUseEffect then begin
      if m_boMsgMuch then m_dwEffectFrameTimetime := Round(m_dwEffectFrameTime * 2 / 3)
      else m_dwEffectFrameTimetime := m_dwEffectFrameTime;
      if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then begin
         m_dwEffectStartTime := GetTickCount;
         if m_nEffectFrame < m_nEffectEnd then begin
            Inc (m_nEffectFrame);
         end else begin
            m_boUseEffect := FALSE;
         end;
      end;
   end;

   prv := m_nCurrentFrame;
   if m_nCurrentAction <> 0 then begin
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
         m_nCurrentFrame := m_nStartFrame;

      if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else m_dwFrameTimetime := m_dwFrameTime;

      if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
         if m_nCurrentFrame < m_nEndFrame then begin
            Inc (m_nCurrentFrame);
            m_dwStartTime := GetTickCount;
         end else begin
            m_nCurrentAction := 0;
            BoUseDieEffect := FALSE;
         end;
      end;
      m_nCurrentDefFrame := 0;
      m_dwDefFrameTime := GetTickCount;
   end else begin
      if GetTickCount - m_dwSmoothMoveTime > 200 then begin
         if GetTickCount - m_dwDefFrameTime > 500 then begin
            m_dwDefFrameTime := GetTickCount;
            Inc (m_nCurrentDefFrame);
            if m_nCurrentDefFrame >= m_nDefFrameCount then
               m_nCurrentDefFrame := 0;
         end;
         DefaultMotion;
      end;
   end;

   if prv <> m_nCurrentFrame then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface;
   end;

end;


procedure TGasKuDeGi.DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean);
var
   idx: integer;
   d: TDirectDrawSurface;
   ceff: TColorEffect;
begin
   if not (m_btDir in [0..7]) then exit;
   if GetTickCount - m_dwLoadSurfaceTime > 60 * 1000 then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface; //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
   end;

   ceff := GetDrawEffectValue;

   if m_BodySurface <> nil then
      DrawEffSurface (dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);

end;

procedure TGasKuDeGi.DrawEff (dsurface: TDirectDrawSurface; dx, dy: integer);
var
   idx: integer;
   d: TDirectDrawSurface;
   ceff: TColorEffect;
begin
   if m_boUseEffect then
     if AttackEffectSurface <> nil then begin
        DrawBlend (dsurface,
                    dx + ax + m_nShiftX,
                    dy + ay + m_nShiftY,
                    AttackEffectSurface, 1);
     end;


   if BoUseDieEffect then
      if DieEffectSurface <> nil then begin
         DrawBlend (dsurface,
                    dx + bx + m_nShiftX,
                    dy + by + m_nShiftY,
                    DieEffectSurface, 1);
      end;
end;



{-----------------------------------------------------------}

function  TFireCowFaceMon.Light: integer;
var
   l: integer;
begin
   l := m_nChrLight;
   if l < 2 then begin
      if m_boUseEffect then
         l := 2;
   end;
   Result := l;
end;

function  TCowFaceKing.Light: integer;
var
   l: integer;
begin
   l := m_nChrLight;
   if l < 2 then begin
      if m_boUseEffect then
         l := 2;
   end;
   Result := l;
end;


{-----------------------------------------------------------}

//procedure TZombiLighting.Run;


{-----------------------------------------------------------}


procedure TSculptureMon.CalcActorFrame;
var
   pm: PTMonsterAction;
   haircount: integer;
begin
   m_nCurrentFrame := -1;

   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;
   m_boUseEffect := FALSE;

   case m_nCurrentAction of
      SM_TURN:
         begin
            if (m_nState and STATE_STONE_MODE) <> 0 then begin
               if (m_btRace = 48) or (m_btRace = 49) then
                  m_nStartFrame := pm.ActDeath.start // + Dir * (pm.ActDeath.frame + pm.ActDeath.skip)
               else
                  m_nStartFrame := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip);
               m_nEndFrame := m_nStartFrame;
               m_dwFrameTime := pm.ActDeath.ftime;
               m_dwStartTime := GetTickCount;
               m_nDefFrameCount := pm.ActDeath.frame;
            end else begin
               m_nStartFrame := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
               m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
               m_dwFrameTime := pm.ActStand.ftime;
               m_dwStartTime := GetTickCount;
               m_nDefFrameCount := pm.ActStand.frame;
            end;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_WALK, SM_BACKSTEP:
         begin
            m_nStartFrame := pm.ActWalk.start + m_btDir * (pm.ActWalk.frame + pm.ActWalk.skip);
            m_nEndFrame := m_nStartFrame + pm.ActWalk.frame - 1;
            m_dwFrameTime := pm.ActWalk.ftime;
            m_dwStartTime := GetTickCount;
            m_nMaxTick := pm.ActWalk.UseTick;
            m_nCurTick := 0;
            //WarMode := FALSE;
            m_nMoveStep := 1;
            if m_nCurrentAction = SM_WALK then
               Shift (m_btDir, m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1)
            else  //sm_backstep
               Shift (GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1);
         end;
      SM_DIGUP: //걷기 없음, SM_DIGUP, 방향 없음.
         begin
            if (m_btRace = 48) or (m_btRace = 49) then begin
               m_nStartFrame := pm.ActDeath.start;
            end else begin
               m_nStartFrame := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip);
            end;
            m_nEndFrame := m_nStartFrame + pm.ActDeath.frame - 1;
            m_dwFrameTime := pm.ActDeath.ftime;
            m_dwStartTime := GetTickCount;
            //WarMode := FALSE;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_HIT:
         begin
            m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
            m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
            m_dwFrameTime := pm.ActAttack.ftime;
            m_dwStartTime := GetTickCount;
            if m_btRace = 49 then begin
               m_boUseEffect := TRUE;
               firedir := m_btDir;
               m_nEffectFrame := 0; //startframe;
               m_nEffectStart := 0; //startframe;
               m_nEffectEnd := m_nEffectStart + 8;
               m_dwEffectStartTime := GetTickCount;
               m_dwEffectFrameTime := m_dwFrameTime;
            end;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_STRUCK:
         begin
            m_nStartFrame := pm.ActStruck.start + m_btDir * (pm.ActStruck.frame + pm.ActStruck.skip);
            m_nEndFrame := m_nStartFrame + pm.ActStruck.frame - 1;
            m_dwFrameTime := m_dwStruckFrameTime; //pm.ActStruck.ftime;
            m_dwStartTime := GetTickCount;
         end;
      SM_DEATH:
         begin
            m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
            m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
            m_nStartFrame := m_nEndFrame; //
            m_dwFrameTime := pm.ActDie.ftime;
            m_dwStartTime := GetTickCount;
         end;
      SM_NOWDEATH:
         begin
            m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
            m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
            m_dwFrameTime := pm.ActDie.ftime;
            m_dwStartTime := GetTickCount;
         end;
   end;
end;

procedure  TSculptureMon.LoadSurface;
begin
   inherited LoadSurface;
   case m_btRace of
      48, 49:
         begin
            if m_boUseEffect then
               AttackEffectSurface := FrmMain.WMon7Img.GetCachedImage (
                        SCULPTUREFIREBASE + (firedir * 10) + m_nEffectFrame-m_nEffectStart, //
                        ax, ay);
         end;
   end;
end;

function  TSculptureMon.GetDefaultFrame (wmode: Boolean): integer;
var
   cf, dr: integer;
   pm: PTMonsterAction;
begin
   Result:=0;//jacky
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;

   if m_boDeath then begin
      Result := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip) + (pm.ActDie.frame - 1);
   end else begin
      if (m_nState and STATE_STONE_MODE) <> 0 then begin
         case m_btRace of
            47: Result := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip);
            48, 49: Result := pm.ActDeath.start;
         end;
      end else begin
         m_nDefFrameCount := pm.ActStand.frame;
         if m_nCurrentDefFrame < 0 then cf := 0
         else if m_nCurrentDefFrame >= pm.ActStand.frame then cf := 0
         else cf := m_nCurrentDefFrame;
         Result := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
      end;
   end;
end;

procedure TSculptureMon.DrawEff (dsurface: TDirectDrawSurface; dx, dy: integer);
var
   idx: integer;
   d: TDirectDrawSurface;
   ceff: TColorEffect;
begin
   if m_boUseEffect then
      if AttackEffectSurface <> nil then begin
         DrawBlend (dsurface,
                    dx + ax + m_nShiftX,
                    dy + ay + m_nShiftY,
                    AttackEffectSurface, 1);
      end;
end;

procedure TSculptureMon.Run;
var
   m_dwEffectFrameTimetime, m_dwFrameTimetime: longword;
begin
   if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then exit;
   if m_boUseEffect then begin
      m_dwEffectFrameTimetime := m_dwEffectFrameTime;
      if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then begin
         m_dwEffectStartTime := GetTickCount;
         if m_nEffectFrame < m_nEffectEnd then begin
            Inc (m_nEffectFrame);
         end else begin
            m_boUseEffect := FALSE;
         end;
      end;
   end;
   inherited Run;
end;


{ TBanyaGuardMon }

procedure TBanyaGuardMon.CalcActorFrame;
var
   pm: PTMonsterAction;
begin
   m_nCurrentFrame := -1;
   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;
   case m_nCurrentAction of
     SM_HIT: begin
       m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
       m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
       m_dwFrameTime := pm.ActAttack.ftime;
       m_dwStartTime := GetTickCount;
       m_dwWarModeTime := GetTickCount;
       Shift (m_btDir, 0, 0, 1);
       m_boUseEffect := TRUE;
       m_nEffectFrame := m_nStartFrame;
       m_nEffectStart := m_nStartFrame;
       m_nEffectEnd := m_nEndFrame;
       m_dwEffectStartTime := GetTickCount;
       m_dwEffectFrameTime := m_dwFrameTime;
     end;
     SM_LIGHTING: begin
       m_nStartFrame := pm.ActCritical.start + m_btDir * (pm.ActCritical.frame + pm.ActCritical.skip);
       m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
       m_dwFrameTime := pm.ActCritical.ftime;
       m_dwStartTime := GetTickCount;
       m_nCurEffFrame:=0;
       m_boUseMagic:=True;
       m_dwWarModeTime := GetTickCount;
       Shift (m_btDir, 0, 0, 1);
       if (m_btRace = 71) then begin
         m_boUseEffect := TRUE;
         m_nEffectFrame := m_nStartFrame;
         m_nEffectStart := m_nStartFrame;
         m_nEffectEnd := m_nEndFrame;
         m_dwEffectStartTime := GetTickCount;
         m_dwEffectFrameTime := m_dwFrameTime;
       end;
     end;
     else begin
       inherited;
     end;
   end;

end;

constructor TBanyaGuardMon.Create;
begin
  inherited;
  n26C:=nil;
end;

procedure TBanyaGuardMon.DrawEff(dsurface: TDirectDrawSurface; dx,
  dy: integer);
begin
  inherited;
  if m_boUseEffect and (n26C <> nil) then begin
    DrawBlend (dsurface,dx + ax + m_nShiftX,dy + ay + m_nShiftY,n26C, 1);
  end;
end;

procedure TBanyaGuardMon.LoadSurface;
begin
  inherited;
  if bo260 then begin
    case m_btRace of
      70: begin
        AttackEffectSurface := FrmMain.WMon21Img.GetCachedImage (
                        2320 + m_nCurrentFrame - m_nStartFrame,
                        n264, n268);

      end;
      71: begin
        AttackEffectSurface := FrmMain.WMon21Img.GetCachedImage (
                        2870 + (m_btDir * 10) + m_nCurrentFrame - m_nStartFrame,
                        n264, n268);
      end;
      78: begin
        AttackEffectSurface := FrmMain.WMon22Img.GetCachedImage (
                        3120 + (m_btDir * 4) + m_nCurrentFrame - m_nStartFrame,
                        n264, n268);
      end;
    end;
  end else begin
    if m_boUseEffect then begin
      case m_btRace of
        70: begin
          if m_nCurrentAction = SM_HIT then begin
            n26C := FrmMain.WMon21Img.GetCachedImage (
                            2230 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart,
                            ax, ay);
          end;
        end;
        71: begin
          case m_nCurrentAction of
            SM_HIT: begin
              n26C := FrmMain.WMon21Img.GetCachedImage (
                            2780 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart,
                            ax, ay);
            end;
            SM_FLYAXE ..SM_LIGHTING: begin
              n26C := FrmMain.WMon21Img.GetCachedImage (
                            2960 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart,
                            ax, ay);
            end;
          end;
        end;
        72: begin
          if m_nCurrentAction = SM_HIT then begin
            n26C := FrmMain.WMon21Img.GetCachedImage (
                            3490 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart,
                            ax, ay);
          end;
        end;
        78: begin
          if m_nCurrentAction = SM_HIT then begin
            n26C := FrmMain.WMon22Img.GetCachedImage (
                            3440 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart,
                            ax, ay);
          end;
        end;
      end;
    end;
  end;
end;

procedure TBanyaGuardMon.Run;
var
   prv: integer;
   m_dwEffectFrameTimetime, m_dwFrameTimetime: longword;
   bo11:Boolean;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then exit;
   m_boMsgMuch := FALSE;
   if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;

   RunActSound (m_nCurrentFrame - m_nStartFrame);
   RunFrameAction (m_nCurrentFrame - m_nStartFrame);

   if m_boUseEffect then begin
      if m_boMsgMuch then m_dwEffectFrameTimetime := Round(m_dwEffectFrameTime * 2 / 3)
      else m_dwEffectFrameTimetime := m_dwEffectFrameTime;
      if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then begin
         m_dwEffectStartTime := GetTickCount;
         if m_nEffectFrame < m_nEffectEnd then begin
            Inc (m_nEffectFrame);
         end else begin
            m_boUseEffect := FALSE;
         end;
      end;
   end;

   prv := m_nCurrentFrame;
   if m_nCurrentAction <> 0 then begin
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
         m_nCurrentFrame := m_nStartFrame;

      if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else m_dwFrameTimetime := m_dwFrameTime;

      if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
         if m_nCurrentFrame < m_nEndFrame then begin
            Inc (m_nCurrentFrame);
            m_dwStartTime := GetTickCount;
         end else begin
            m_nCurrentAction := 0;
            m_boUseEffect := FALSE;
            bo260:=False;            
         end;
         if m_nCurrentAction = SM_LIGHTING then begin
           if (m_nCurrentFrame - m_nStartFrame) = 4 then begin
             if (m_btRace = 70) or (m_btRace = 81) then begin
               PlayScene.NewMagic (Self,m_nMagicNum,8,m_nCurrX,m_nCurrY,m_nTargetX,m_nTargetY,m_nTargetRecog,mtThunder,False,30,bo11);
               PlaySound(10112);
             end;
             if (m_btRace = 71) then begin
               PlayScene.NewMagic (Self,1,1,m_nCurrX,m_nCurrY,m_nTargetX,m_nTargetY,m_nTargetRecog,mtFly,True,30,bo11);
               PlaySound(10012);
             end;
             if (m_btRace = 72) then begin
               PlayScene.NewMagic (Self,11,32,m_nCurrX,m_nCurrY,m_nTargetX,m_nTargetY,m_nTargetRecog,mt13,False,30,bo11);
               PlaySound(2276);
             end;
             if (m_btRace = 78) then begin
               PlayScene.NewMagic (Self,11,37,m_nCurrX,m_nCurrY,m_nCurrX,m_nCurrY,m_nRecogId,mt13,False,30,bo11);
               PlaySound(2396);
             end;
           end;
         end;
         m_nCurrentDefFrame := 0;
         m_dwDefFrameTime := GetTickCount;
      end;
   end else begin
      if GetTickCount - m_dwSmoothMoveTime > 200 then begin
         if GetTickCount - m_dwDefFrameTime > 500 then begin
            m_dwDefFrameTime := GetTickCount;
            Inc (m_nCurrentDefFrame);
            if m_nCurrentDefFrame >= m_nDefFrameCount then
               m_nCurrentDefFrame := 0;
         end;
         DefaultMotion;
      end;
   end;

   if prv <> m_nCurrentFrame then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface;
   end;
end;

{ TElectronicScolpionMon }

procedure TElectronicScolpionMon.CalcActorFrame;
var
   pm: PTMonsterAction;
begin
   m_nCurrentFrame := -1;
   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;
   case m_nCurrentAction of
     SM_HIT: begin
       m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
       m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
       m_dwFrameTime := pm.ActAttack.ftime;
       m_dwStartTime := GetTickCount;
       m_dwWarModeTime := GetTickCount;
       Shift (m_btDir, 0, 0, 1);
     end;
     SM_LIGHTING: begin
       m_nStartFrame := pm.ActCritical.start + m_btDir * (pm.ActCritical.frame + pm.ActCritical.skip);
       m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
       m_dwFrameTime := pm.ActCritical.ftime;
       m_dwStartTime := GetTickCount;
       m_dwWarModeTime := GetTickCount;
       Shift (m_btDir, 0, 0, 1);
       m_boUseEffect := TRUE;
       firedir := m_btDir;
       m_nEffectFrame := m_nStartFrame;
       m_nEffectStart := m_nStartFrame;
       m_nEffectEnd := m_nEndFrame;
       m_dwEffectStartTime := GetTickCount;
       m_dwEffectFrameTime := m_dwFrameTime;
     end;
     else begin
       inherited;
     end;
   end;
end;

procedure TElectronicScolpionMon.LoadSurface;
begin
  inherited;
  {
  if (m_btRace = 60) and BoUseEffect and (CurrentAction = SM_SPELL) then begin
    AttackEffectSurface := FrmMain.WMon19Img.GetCachedImage (
                        430 + (firedir * 10) + m_nEffectFrame - m_nEffectStart,
                        ax, ay);
  }
  if (m_btRace = 60) and m_boUseEffect and (m_nCurrentAction = SM_LIGHTING) then begin
    AttackEffectSurface := FrmMain.WMon19Img.GetCachedImage (
                        430 + (firedir * 10) + m_nEffectFrame - m_nEffectStart,
                        ax, ay);
  end;
end;

{ TBossPigMon }

procedure TBossPigMon.LoadSurface;
begin
  inherited;
  if (m_btRace = 61) and m_boUseEffect then begin
    AttackEffectSurface := FrmMain.WMon19Img.GetCachedImage (
                        860 + (firedir * 10) + m_nEffectFrame - m_nEffectStart,
                        ax, ay);
  end;
end;

{ TKingOfSculpureKingMon }

procedure TKingOfSculpureKingMon.CalcActorFrame;
var
   pm: PTMonsterAction;
begin
   m_nCurrentFrame := -1;
   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;
   case m_nCurrentAction of
     SM_HIT: begin
       m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
       m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
       m_dwFrameTime := pm.ActAttack.ftime;
       m_dwStartTime := GetTickCount;
       m_dwWarModeTime := GetTickCount;
       Shift (m_btDir, 0, 0, 1);
       m_boUseEffect := TRUE;
       firedir := m_btDir;
       m_nEffectFrame := m_nStartFrame;
       m_nEffectStart := m_nStartFrame;
       m_nEffectEnd := m_nEndFrame;
       m_dwEffectStartTime := GetTickCount;
       m_dwEffectFrameTime := m_dwFrameTime;
     end;
     SM_LIGHTING: begin
       m_nStartFrame := pm.ActCritical.start + m_btDir * (pm.ActCritical.frame + pm.ActCritical.skip);
       m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
       m_dwFrameTime := pm.ActCritical.ftime;
       m_dwStartTime := GetTickCount;
       m_dwWarModeTime := GetTickCount;
       Shift (m_btDir, 0, 0, 1);
       m_boUseEffect := TRUE;
       firedir := m_btDir;
       m_nEffectFrame := m_nStartFrame;
       m_nEffectStart := m_nStartFrame;
       m_nEffectEnd := m_nEndFrame;
       m_dwEffectStartTime := GetTickCount;
       m_dwEffectFrameTime := m_dwFrameTime;
     end;
     SM_NOWDEATH: begin
       m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
       m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
       m_dwFrameTime := pm.ActDie.ftime;
       m_dwStartTime := GetTickCount;
       m_nEffectFrame := pm.ActDie.start;
       m_nEffectStart := pm.ActDie.start;
       m_nEffectEnd := pm.ActDie.start + pm.ActDie.frame - 1;
       m_dwEffectStartTime := GetTickCount;
       m_dwEffectFrameTime := m_dwFrameTime;
       m_boUseEffect := TRUE;
     end;
     else begin
      inherited;
     end;     
   end;
end;

procedure TKingOfSculpureKingMon.LoadSurface;
begin
  inherited;
  if (m_btRace = 62) and m_boUseEffect then begin
    case m_nCurrentAction of
      SM_HIT: begin
        AttackEffectSurface := FrmMain.WMon19Img.GetCachedImage (
                        1490 + (firedir * 10) + m_nEffectFrame - m_nEffectStart,
                        ax, ay);
      end;
      SM_LIGHTING: begin
        AttackEffectSurface := FrmMain.WMon19Img.GetCachedImage (
                        1380 + (firedir * 10) + m_nEffectFrame - m_nEffectStart,
                        ax, ay);
      end;
      SM_NOWDEATH: begin
        AttackEffectSurface := FrmMain.WMon19Img.GetCachedImage (
                        1470 + m_nEffectFrame - m_nEffectStart,
                        ax, ay);
      end;
    end;

  end;
end;

{ TSkeletonArcherMon }

procedure TSkeletonArcherMon.CalcActorFrame;
begin
  inherited;
  if (m_nCurrentAction = SM_NOWDEATH) and (m_btRace <> 72) then begin
    bo260:=True;
  end;
end;

procedure TSkeletonArcherMon.DrawEff(dsurface: TDirectDrawSurface; dx,
  dy: integer);
begin
  inherited;
  if bo260 and (AttackEffectSurface <> nil) then begin
    DrawBlend (dsurface,dx + n264 + m_nShiftX,dy + n268 + m_nShiftY,AttackEffectSurface, 1);
  end;
end;

procedure TSkeletonArcherMon.LoadSurface;
begin
  inherited;
  if bo260 then begin
        AttackEffectSurface := FrmMain.WMon20Img.GetCachedImage (
                        1600 + m_nEffectFrame - m_nEffectStart,
                        n264, n268);
  end;
end;

procedure TSkeletonArcherMon.Run;
var
  m_dwFrameTimetime: longword;
begin

  if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
  else m_dwFrameTimetime := m_dwFrameTime;
  if m_nCurrentAction <> 0 then begin
    if (GetTickCount - m_dwStartTime) > m_dwFrameTimetime then begin
      if m_nCurrentFrame < m_nEndFrame then begin
      end else begin
        m_nCurrentAction:=0;
        bo260:=False;
      end;
    end;
  end;

  inherited;
end;

{ TFlyingSpider }

procedure TFlyingSpider.CalcActorFrame;
var
  Eff8:TNormalDrawEffect;
begin
  inherited;
  if m_nCurrentAction = SM_NOWDEATH then begin
    Eff8:=TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,FrmMain.WMon12Img,1420,20,m_dwFrameTime,True);
    if Eff8 <> nil then begin
      Eff8.MagOwner:=g_MySelf;
      PlayScene.m_EffectList.Add(Eff8);
    end;
  end;
end;

{ TExplosionSpider }

procedure TExplosionSpider.CalcActorFrame;
begin
  inherited;
  case m_nCurrentAction of
    SM_HIT: begin
      m_boUseEffect:=False;
    end;
    SM_NOWDEATH: begin
      m_nEffectStart:=m_nStartFrame;
      m_nEffectFrame:=m_nStartFrame;
      m_dwEffectStartTime:=GetTickCount();
      m_dwEffectFrameTime:=m_dwFrameTime;
      m_nEffectEnd:=m_nEndFrame;
      m_boUseEffect:=True;
    end;
  end;
end;

procedure TExplosionSpider.LoadSurface;
begin
  inherited;
  if m_boUseEffect then
    AttackEffectSurface := FrmMain.WMon14Img.GetCachedImage (
                        730 + m_nEffectFrame-m_nEffectStart,
                        ax, ay);
end;

{ TSkeletonKingMon }

procedure TSkeletonKingMon.CalcActorFrame;
var
   pm: PTMonsterAction;
   actor: TActor;
   haircount, scx, scy, stx, sty: integer;
   meff: TCharEffect;
begin
   m_nCurrentFrame := -1;

   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;

   case m_nCurrentAction of
     SM_BACKSTEP,SM_WALK: begin
       m_nStartFrame := pm.ActWalk.start + m_btDir * (pm.ActWalk.frame + pm.ActWalk.skip);
       m_nEndFrame := m_nStartFrame + pm.ActWalk.frame - 1;
       m_dwFrameTime := pm.ActWalk.ftime;
       m_dwStartTime := GetTickCount;
       m_nEffectFrame:=pm.ActWalk.start;
       m_nEffectStart:=pm.ActWalk.start;
       m_nEffectEnd:=pm.ActWalk.start + pm.ActWalk.frame -1;
       m_dwEffectStartTime:=GetTickCount();
       m_dwEffectFrameTime:=m_dwFrameTime;
       m_boUseEffect:=True;
       m_nMaxTick := pm.ActWalk.UseTick;
       m_nCurTick := 0;
            //WarMode := FALSE;
       m_nMoveStep := 1;
       if m_nCurrentAction = SM_WALK then
         Shift (m_btDir, m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1)
       else
         Shift (GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1);
     end;
     SM_HIT: begin
       m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
       m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
       m_dwFrameTime := pm.ActAttack.ftime;
       m_dwStartTime := GetTickCount;
       m_dwWarModeTime:= GetTickCount;
       Shift (m_btDir, 0, 0, 1);
       m_boUseEffect := TRUE;
       firedir := m_btDir;
       m_nEffectFrame:=m_nStartFrame;
       m_nEffectStart:=m_nStartFrame;
       m_nEffectEnd:=m_nEndFrame;
       m_dwEffectStartTime:=GetTickCount();
       m_dwEffectFrameTime := m_dwFrameTime;
     end;
     SM_FLYAXE: begin
       m_nStartFrame := pm.ActCritical.start + m_btDir * (pm.ActCritical.frame + pm.ActCritical.skip);
       m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
       m_dwFrameTime := pm.ActCritical.ftime;
       m_dwStartTime := GetTickCount;
       m_dwWarModeTime:= GetTickCount;
       Shift (m_btDir, 0, 0, 1);
       m_boUseEffect := TRUE;
       firedir := m_btDir;
       m_nEffectFrame:=m_nStartFrame;
       m_nEffectStart:=m_nStartFrame;
       m_nEffectEnd:=m_nEndFrame;
       m_dwEffectStartTime:=GetTickCount();
       m_dwEffectFrameTime := m_dwFrameTime;
     end;
     SM_LIGHTING: begin
       m_nStartFrame := 80 + pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
       m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
       m_dwFrameTime := pm.ActAttack.ftime;
       m_dwStartTime := GetTickCount;
       m_dwWarModeTime:= GetTickCount;
       Shift (m_btDir, 0, 0, 1);
       m_boUseEffect := TRUE;
       firedir := m_btDir;
       m_nEffectFrame:=m_nStartFrame;
       m_nEffectStart:=m_nStartFrame;
       m_nEffectEnd:=m_nEndFrame;
       m_dwEffectStartTime:=GetTickCount();
       m_dwEffectFrameTime := m_dwFrameTime;
     end;
     SM_STRUCK: begin
       m_nStartFrame := pm.ActStruck.start + m_btDir * (pm.ActStruck.frame + pm.ActStruck.skip);
       m_nEndFrame := m_nStartFrame + pm.ActStruck.frame - 1;
       m_dwFrameTime := pm.ActStruck.ftime;
       m_dwStartTime := GetTickCount;
       m_nEffectFrame:=pm.ActStruck.start;
       m_nEffectStart:=pm.ActStruck.start;
       m_nEffectEnd:=pm.ActStruck.start + pm.ActStruck.frame -1;
       m_dwEffectStartTime:=GetTickCount;
       m_dwEffectFrameTime:=m_dwFrameTime;
       m_boUseEffect := TRUE;
     end;
     SM_NOWDEATH: begin
       m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
       m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
       m_dwFrameTime := pm.ActDie.ftime;
       m_dwStartTime := GetTickCount;
       m_nEffectFrame := pm.ActDie.start;
       m_nEffectStart := pm.ActDie.start;
       m_nEffectEnd := pm.ActDie.start + pm.ActDie.frame - 1;
       m_dwEffectStartTime := GetTickCount;
       m_dwEffectFrameTime := m_dwFrameTime;
       m_boUseEffect := TRUE;
     end;
     else begin
       inherited;
     end;
   end;
end;

procedure TSkeletonKingMon.LoadSurface;
begin
  inherited;
   if (m_btRace = 63) and m_boUseEffect then begin
     case m_nCurrentAction of
       SM_WALK: begin
         AttackEffectSurface := FrmMain.WMon20Img.GetCachedImage (
                                3060 + (m_btDir * 10) + m_nEffectFrame-m_nEffectStart,
                                ax,
                                ay);
       end;
       SM_HIT: begin
         AttackEffectSurface := FrmMain.WMon20Img.GetCachedImage (
                                3140 + (firedir * 10) + m_nEffectFrame-m_nEffectStart,
                                ax,
                                ay);
       end;
       SM_FLYAXE: begin
         AttackEffectSurface := FrmMain.WMon20Img.GetCachedImage (
                                3300 + (firedir * 10) + m_nEffectFrame-m_nEffectStart,
                                ax,
                                ay);
       end;
       SM_LIGHTING: begin
         AttackEffectSurface := FrmMain.WMon20Img.GetCachedImage (
                                3220 + (firedir * 10) + m_nEffectFrame-m_nEffectStart,
                                ax,
                                ay);
       end;
       SM_STRUCK: begin
         AttackEffectSurface := FrmMain.WMon20Img.GetCachedImage (
                                3380 + (m_btDir * 2) + m_nEffectFrame-m_nEffectStart,
                                ax,
                                ay);       
       end;
       SM_NOWDEATH: begin
         AttackEffectSurface := FrmMain.WMon20Img.GetCachedImage (
                                3400 + (m_btDir * 4) + m_nEffectFrame-m_nEffectStart,
                                ax,
                                ay);
       end;
     end;
   end;
end;

procedure TSkeletonKingMon.Run;
var
   prv: integer;
   m_dwEffectFrameTimetime, m_dwFrameTimetime: longword;
   meff: TFlyingFireBall;
begin
   if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then exit;

   m_boMsgMuch := FALSE;
   if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;

   //
   RunActSound (m_nCurrentFrame - m_nStartFrame);
   RunFrameAction (m_nCurrentFrame - m_nStartFrame);

   if m_boUseEffect then begin
      if m_boMsgMuch then m_dwEffectFrameTimetime := Round(m_dwEffectFrameTime * 2 / 3)
      else m_dwEffectFrameTimetime := m_dwEffectFrameTime;
      if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then begin
         m_dwEffectStartTime := GetTickCount;
         if m_nEffectFrame < m_nEffectEnd then begin
            Inc (m_nEffectFrame);
         end else begin
            m_boUseEffect := FALSE;
         end;
      end;
   end;

   prv := m_nCurrentFrame;
   if m_nCurrentAction <> 0 then begin
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
         m_nCurrentFrame := m_nStartFrame;

      if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else m_dwFrameTimetime := m_dwFrameTime;

      if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
         if m_nCurrentFrame < m_nEndFrame then begin
            Inc (m_nCurrentFrame);
            m_dwStartTime := GetTickCount;
         end else begin
            m_nCurrentAction := 0;
            m_boUseEffect:=False;
            BoUseDieEffect := FALSE;
         end;

         if (m_nCurrentAction = SM_FLYAXE) and (m_nCurrentFrame-m_nStartFrame = 4) then begin
            meff := TFlyingFireBall (PlayScene.NewFlyObject (self,
                             m_nCurrX,
                             m_nCurrY,
                             m_nTargetX,
                             m_nTargetY,
                             m_nTargetRecog,
                             mt12));
            if meff <> nil then begin
               meff.ImgLib := FrmMain.WMon20Img;
               meff.NextFrameTime := 40;
               meff.FlyImageBase := 3573;
            end;
         end;
        m_nCurrentDefFrame := 0;
        m_dwDefFrameTime := GetTickCount;
      end;
   end else begin
      if GetTickCount - m_dwSmoothMoveTime > 200 then begin
         if GetTickCount - m_dwDefFrameTime > 500 then begin
            m_dwDefFrameTime := GetTickCount;
            Inc (m_nCurrentDefFrame);
            if m_nCurrentDefFrame >= m_nDefFrameCount then
               m_nCurrentDefFrame := 0;
         end;
         DefaultMotion;
      end;
   end;

   if prv <> m_nCurrentFrame then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface;
   end;
end;

{ TStoneMonster }

procedure TStoneMonster.CalcActorFrame;
var
   pm: PTMonsterAction;
begin
   m_boUseMagic:=False;
   m_nCurrentFrame := -1;
   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;
   m_btDir:=0;
   case m_nCurrentAction of
     SM_TURN: begin
       m_nStartFrame := pm.ActStand.start;
       m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
       m_dwFrameTime := pm.ActStand.ftime;
       m_dwStartTime := GetTickCount;
       m_nDefFrameCount:=pm.ActStand.frame;
       if not m_boUseEffect then begin
         m_boUseEffect:=True;
         m_nEffectFrame := m_nStartFrame;
         m_nEffectStart := m_nStartFrame;
         m_nEffectEnd := m_nEndFrame;
         m_dwEffectStartTime := GetTickCount;
         m_dwEffectFrameTime := 300;
       end;
     end;
     SM_HIT: begin
       m_nStartFrame := pm.ActAttack.start;
       m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
       m_dwFrameTime := pm.ActAttack.ftime;
       m_dwStartTime := GetTickCount;
       m_dwWarModeTime := GetTickCount;
       if not m_boUseEffect then begin
         m_boUseEffect:=True;
         m_nEffectFrame := m_nStartFrame;
         m_nEffectStart := m_nStartFrame;
         m_nEffectEnd := m_nStartFrame + 25;
         m_dwEffectStartTime := GetTickCount;
         m_dwEffectFrameTime := 150;
       end;
     end;
     SM_STRUCK: begin
       m_nStartFrame := pm.ActStruck.start;
       m_nEndFrame := m_nStartFrame + pm.ActStruck.frame - 1;
       m_dwFrameTime := pm.ActStruck.ftime;
       m_dwStartTime := GetTickCount;
     end;
     SM_DEATH: begin
       m_nStartFrame := pm.ActDie.start;
       m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
       m_dwFrameTime := pm.ActDie.ftime;
       m_dwStartTime := GetTickCount;
     end;
     SM_NOWDEATH: begin
       m_nStartFrame := pm.ActDie.start;
       m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
       m_dwFrameTime := pm.ActDie.ftime;
       m_dwStartTime := GetTickCount;
       bo260:=True;
       m_nEffectFrame := m_nStartFrame;
       m_nEffectStart := m_nStartFrame;
       m_nEffectEnd := m_nStartFrame + 19;
       m_dwEffectStartTime := GetTickCount;
       m_dwEffectFrameTime := 80;
     end;
   end;
end;

constructor TStoneMonster.Create;
begin
  inherited;
  n26C:=nil;
  m_boUseEffect:=False;
  bo260:=False;
end;

procedure TStoneMonster.DrawEff(dsurface: TDirectDrawSurface; dx,
  dy: integer);
begin
  inherited;
  if m_boUseEffect and (n26C <> nil) then begin
    DrawBlend (dsurface,
               dx + ax + m_nShiftX,
               dy + ay + m_nShiftY,
               n26C, 1);
  end;
end;

procedure TStoneMonster.LoadSurface;
begin
  inherited;
  if bo260 then begin
    case m_btRace of
      75: begin
        AttackEffectSurface := FrmMain.WMon22Img.GetCachedImage (
                        2530 + m_nEffectFrame - m_nEffectStart,
                        n264, n268);
      end;
      77: begin
        AttackEffectSurface := FrmMain.WMon22Img.GetCachedImage (
                        2660 + m_nEffectFrame - m_nEffectStart,
                        n264, n268);      
      end;
    end;
  end else begin
    if m_boUseEffect then
      case m_btRace of
        75: begin
          case m_nCurrentAction of
            SM_HIT: begin
              n26C := FrmMain.WMon22Img.GetCachedImage (
                            2500 + m_nEffectFrame - m_nEffectStart,
                            ax, ay);
            end;
            SM_TURN: begin
              n26C := FrmMain.WMon22Img.GetCachedImage (
                            2490 + m_nEffectFrame - m_nEffectStart,
                            ax, ay);
            end;
          end;
        end;
        77: begin
          case m_nCurrentAction of
            SM_HIT: begin
              n26C := FrmMain.WMon22Img.GetCachedImage (
                            2630 + m_nEffectFrame - m_nEffectStart,
                            ax, ay);
            end;
            SM_TURN: begin
              n26C := FrmMain.WMon22Img.GetCachedImage (
                            2620 + m_nEffectFrame - m_nEffectStart,
                            ax, ay);
            end;
          end;
        end;
      end;
  end;
end;

procedure TStoneMonster.Run;
var
   prv: integer;
   m_dwEffectFrameTimetime: longword;
   m_dwFrameTimetime: longword;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then exit;
   m_boMsgMuch := FALSE;
   if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;

   RunActSound (m_nCurrentFrame - m_nStartFrame);
   RunFrameAction (m_nCurrentFrame - m_nStartFrame);

   if m_boUseEffect or bo260 then begin
      if m_boMsgMuch then m_dwEffectFrameTimetime := Round(m_dwEffectFrameTime * 2 / 3)
      else m_dwEffectFrameTimetime := m_dwEffectFrameTime;
      if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then begin
         m_dwEffectStartTime := GetTickCount;
         if m_nEffectFrame < m_nEffectEnd then begin
            Inc (m_nEffectFrame);
         end else begin
            m_boUseEffect := FALSE;
            bo260:=False;
         end;
      end;
   end;

   prv := m_nCurrentFrame;
   if m_nCurrentAction <> 0 then begin
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
         m_nCurrentFrame := m_nStartFrame;

      if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else m_dwFrameTimetime := m_dwFrameTime;

      if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
         if m_nCurrentFrame < m_nEndFrame then begin
            Inc (m_nCurrentFrame);
            m_dwStartTime := GetTickCount;
         end else begin
            m_nCurrentAction := 0;
         end;
         m_nCurrentDefFrame := 0;
         m_dwDefFrameTime := GetTickCount;
      end;
   end else begin
      if GetTickCount - m_dwSmoothMoveTime > 200 then begin
         if GetTickCount - m_dwDefFrameTime > 500 then begin
            m_dwDefFrameTime := GetTickCount;
            Inc (m_nCurrentDefFrame);
            if m_nCurrentDefFrame >= m_nDefFrameCount then
               m_nCurrentDefFrame := 0;
         end;
         DefaultMotion;
      end;
   end;

   if (prv <> m_nCurrentFrame) or (prv <> m_nEffectFrame) then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface;
   end;
end;

{ TAngel }

procedure TAngel.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
  blend, boFlag: Boolean);
var
  ceff: TColorEffect;
begin
  if not (m_btDir in [0..7]) then exit;
   if GetTickCount - m_dwLoadSurfaceTime > 60 * 1000 then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface; //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
   end;


  if n278 <> nil then begin
    //DrawBlendEx (dsurface, dx + n270 + m_nShiftX, dy + n274 + m_nShiftY, n278,
    //             0, 0, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, 1);

//    g_ImgMixSurface.Fill(0);
//    g_ImgMixSurface.Draw (0, 0, m_BodySurface.ClientRect, m_BodySurface, FALSE);
//    DrawEffect (0, 0, m_BodySurface.Width, m_BodySurface.Height, g_ImgMixSurface, ceBright);
//    DrawBlend (dsurface, dx + n270 + m_nShiftX, dy + n274 + m_nShiftY, g_ImgMixSurface, 1);

    DrawBlend (dsurface, dx + n270 + m_nShiftX, dy + n274 + m_nShiftY, n278, 1);
  end;
  //inherited;

  ceff := GetDrawEffectValue;
  //ceff := ceBright;

  if m_BodySurface <> nil then begin
    DrawEffSurface (dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);
  end;

  
end;

procedure TAngel.LoadSurface;
var
   mimg: TWMImages;
begin
   mimg := GetMonImg (m_wAppearance);
   if mimg <> nil then begin
     if (not m_boReverseFrame) then begin
       m_BodySurface := mimg.GetCachedImage (1280 + m_nCurrentFrame, m_nPx, m_nPy);
       n278 := mimg.GetCachedImage (920 + m_nCurrentFrame, n270, n274);
     end else begin
       m_BodySurface := mimg.GetCachedImage (
                            1280 + m_nEndFrame - (m_nCurrentFrame-m_nStartFrame),
                            m_nPx, m_nPy);
       n278 := mimg.GetCachedImage (
                            920 + m_nEndFrame - (m_nCurrentFrame-m_nStartFrame),
                            n270, n274);
     end;
   end;
end;

{ TPBOMA6Mon }

procedure TPBOMA6Mon.Run;
var
   prv: integer;
   m_dwEffectFrameTimetime, m_dwFrameTimetime: longword;
   meff: TFlyingAxe;
begin
   if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then exit;

   m_boMsgMuch := FALSE;
   if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;

   RunActSound (m_nCurrentFrame - m_nStartFrame);
   RunFrameAction (m_nCurrentFrame - m_nStartFrame);
   if m_nCurrentAction <> 0 then begin
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
         m_nCurrentFrame := m_nStartFrame;

      if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else m_dwFrameTimetime := m_dwFrameTime;

      if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
         if m_nCurrentFrame < m_nEndFrame then begin
            Inc (m_nCurrentFrame);
            m_dwStartTime := GetTickCount;
         end else begin
            m_nCurrentAction := 0;
            m_boUseEffect := FALSE;
         end;
         if (m_nCurrentAction = SM_FLYAXE) and (m_nCurrentFrame - m_nStartFrame = 4) then begin
            meff := TFlyingAxe (PlayScene.NewFlyObject (self,
                             m_nCurrX,
                             m_nCurrY,
                             g_nTargetX,
                             g_nTargetY,
                             m_nTargetRecog,
                             mt16));
            if meff <> nil then begin
               meff.ImgLib := FrmMain.WMon22Img;
               meff.NextFrameTime := 50;
               meff.FlyImageBase:=1989;
            end;
         end;
      end;
      m_nCurrentDefFrame := 0;
      m_dwDefFrameTime := GetTickCount;
   end else begin
      if GetTickCount - m_dwSmoothMoveTime > 200 then begin
         if GetTickCount - m_dwDefFrameTime > 500 then begin
            m_dwDefFrameTime := GetTickCount;
            Inc (m_nCurrentDefFrame);
            if m_nCurrentDefFrame >= m_nDefFrameCount then
               m_nCurrentDefFrame := 0;
         end;
         DefaultMotion;
      end;
   end;

   if prv <> m_nCurrentFrame then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface;
   end;

end;

{ TDragonStatue }

procedure TDragonStatue.CalcActorFrame;
var
   pm: PTMonsterAction;
begin
   m_btDir:=0;
   m_nCurrentFrame := -1;
   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;
   case m_nCurrentAction of
     SM_DIGUP: begin
       Shift (0, 0, 0, 1);
       m_nStartFrame:=0;
       m_nEndFrame:=9;
       m_dwFrameTime:=100;
       m_dwStartTime:=GetTickCount;
     end;
     SM_LIGHTING: begin
       m_nStartFrame:=0;
       m_nEndFrame:=9;
       m_dwFrameTime:=100;
       m_dwStartTime:=GetTickCount;
       m_boUseEffect:=True;
       m_nEffectStart:=0;
       m_nEffectFrame:=0;
       m_nEffectEnd:=9;
       m_dwEffectStartTime:=GetTickCount;
       m_dwEffectFrameTime:=100;
     end;
   end;
end;

constructor TDragonStatue.Create;
begin
  inherited;
  n26C:=nil;
end;

procedure TDragonStatue.DrawEff(dsurface: TDirectDrawSurface; dx,
  dy: integer);
begin
  inherited;
  if m_boUseEffect and (EffectSurface <> nil) then begin
    DrawBlend (dsurface,dx + ax + m_nShiftX,dy + ay + m_nShiftY,EffectSurface, 1);
  end;
end;

procedure TDragonStatue.LoadSurface;
var
  mimg:TWMImages;
begin
   mimg :=FrmMain.WDragonImg;
   if mimg <> nil then
     m_BodySurface := mimg.GetCachedImage (GetOffset (m_wAppearance) + m_nCurrentFrame, m_nPx, m_nPy);
   if m_boUseEffect then begin
     case m_btRace of
       84..86: begin
         EffectSurface:= mimg.GetCachedImage (310 + m_nEffectFrame, ax, ay);
       end;
       87..89: begin
         EffectSurface:= mimg.GetCachedImage (330 + m_nEffectFrame, ax, ay);
       end;
     end;
   end;
end;

procedure TDragonStatue.Run;
var
   prv: integer;
   dwEffectFrameTime, m_dwFrameTimetime: longword;
   bo11:Boolean;
begin
  m_btDir:=0;
   if (m_nCurrentAction = SM_WALK) or
      (m_nCurrentAction = SM_BACKSTEP) or
      (m_nCurrentAction = SM_RUN) or
      (m_nCurrentAction = SM_HORSERUN) then exit;

   m_boMsgMuch := FALSE;
   if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;

   if m_boUseEffect then begin
      if m_boMsgMuch then dwEffectFrameTime := Round(m_dwEffectFrameTime * 2 / 3)
      else dwEffectFrameTime := m_dwEffectFrameTime;
      if GetTickCount - m_dwEffectStartTime > dwEffectFrameTime then begin
         m_dwEffectStartTime := GetTickCount;
         if m_nEffectFrame < m_nEffectEnd then begin
            Inc (m_nEffectFrame);
         end else begin
            m_boUseEffect := FALSE;
         end;
      end;
   end;

   prv := m_nCurrentFrame;
   if m_nCurrentAction <> 0 then begin
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
         m_nCurrentFrame := m_nStartFrame;

      if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else m_dwFrameTimetime := m_dwFrameTime;

      if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
         if m_nCurrentFrame < m_nEndFrame then begin
            Inc (m_nCurrentFrame);
            m_dwStartTime := GetTickCount;
         end else begin
            m_nCurrentAction := 0;
            m_boUseEffect := FALSE;
            bo260:=False;
         end;
         if (m_nCurrentAction = SM_LIGHTING) and (m_nCurrentFrame = 4) then begin
           PlayScene.NewMagic (Self,74,74,m_nCurrX,m_nCurrY,m_nTargetX,m_nTargetY,0,mtThunder,False,30,bo11);
           PlaySound(8222);
         end;
      end;
      m_nCurrentDefFrame := 0;
      m_dwDefFrameTime := GetTickCount;
   end else begin
      if GetTickCount - m_dwSmoothMoveTime > 200 then begin
         if GetTickCount - m_dwDefFrameTime > 500 then begin
            m_dwDefFrameTime := GetTickCount;
            Inc (m_nCurrentDefFrame);
            if m_nCurrentDefFrame >= m_nDefFrameCount then
               m_nCurrentDefFrame := 0;
         end;
         DefaultMotion;
      end;
   end;

   if prv <> m_nCurrentFrame then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface;
   end;

end;

{ TPBOMA1Mon }

procedure TPBOMA1Mon.Run;
var
   prv: integer;
   m_dwEffectFrameTimetime, m_dwFrameTimetime: longword;
   meff: TFlyingBug;
begin
   if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then exit;

   m_boMsgMuch := FALSE;
   if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;

   RunActSound (m_nCurrentFrame - m_nStartFrame);
   RunFrameAction (m_nCurrentFrame - m_nStartFrame);
   if m_nCurrentAction <> 0 then begin
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
         m_nCurrentFrame := m_nStartFrame;

      if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else m_dwFrameTimetime := m_dwFrameTime;

      if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
         if m_nCurrentFrame < m_nEndFrame then begin
            Inc (m_nCurrentFrame);
            m_dwStartTime := GetTickCount;
         end else begin
            m_nCurrentAction := 0;
            m_boUseEffect := FALSE;
         end;
         if (m_nCurrentAction = SM_FLYAXE) and (m_nCurrentFrame - m_nStartFrame = 4) then begin
            meff := TFlyingBug (PlayScene.NewFlyObject (self,
                             m_nCurrX,
                             m_nCurrY,
                             m_nTargetX,
                             m_nTargetY,
                             m_nTargetRecog,
                             mt15));
            if meff <> nil then begin
               meff.ImgLib := FrmMain.WMon22Img;
               meff.NextFrameTime := 50;
               meff.FlyImageBase:=350;
               meff.MagExplosionBase := 430;
            end;
         end;
      end;
      m_nCurrentDefFrame := 0;
      m_dwDefFrameTime := GetTickCount;
   end else begin
      if GetTickCount - m_dwSmoothMoveTime > 200 then begin
         if GetTickCount - m_dwDefFrameTime > 500 then begin
            m_dwDefFrameTime := GetTickCount;
            Inc (m_nCurrentDefFrame);
            if m_nCurrentDefFrame >= m_nDefFrameCount then
               m_nCurrentDefFrame := 0;
         end;
         DefaultMotion;
      end;
   end;

   if prv <> m_nCurrentFrame then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface;
   end;

end;

{ TFireDragon }

procedure TFireDragon.CalcActorFrame;
var
   pm: PTMonsterAction;
begin
   m_btDir:=0;
   m_nCurrentFrame := -1;
   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;
   case m_nCurrentAction of
     SM_DIGUP: begin
       Shift (0, 0, 0, 1);
       m_nStartFrame:=0;
       m_nEndFrame:=9;
       m_dwFrameTime:=300;
       m_dwStartTime:=GetTickCount;
     end;
     SM_HIT: begin
       m_nStartFrame:=0;
       m_nEndFrame:=19;
       m_dwFrameTime:=150;
       m_dwStartTime:=GetTickCount;
       m_boUseEffect:=True;
       m_nEffectStart:=0;
       m_nEffectFrame:=0;
       m_nEffectEnd:=19;
       m_dwEffectStartTime:=GetTickCount;
       m_dwEffectFrameTime:=150;
       m_nCurEffFrame:=0;
       m_boUseMagic:=True;
       m_dwWarModeTime:=GetTickcount;
       Shift (m_btDir, 0, 0, 1);
     end;
     SM_STRUCK: begin
       m_nStartFrame:=0;
       m_nEndFrame:=9;
       m_dwFrameTime:=300;
       m_dwStartTime:=GetTickCount;
     end;
     81..83: begin
       m_nStartFrame:=0;
       m_nEndFrame:=5;
       m_dwFrameTime:=150;
       m_dwStartTime:=GetTickCount;
       m_boUseEffect:=True;
       m_nEffectStart:=0;
       m_nEffectFrame:=0;
       m_nEffectEnd:=10;
       m_dwEffectStartTime:=GetTickCount;
       m_dwEffectFrameTime:=150;
       m_nCurEffFrame:=0;
       m_boUseMagic:=True;
       m_dwWarModeTime:=GetTickcount;
       Shift (m_btDir, 0, 0, 1);
     end;
   end;
end;

constructor TFireDragon.Create;
begin
  inherited;
  n270:=nil;
end;

procedure TFireDragon.AttackEff;
var
  n8,nC,n10,n14,n18:integer;
  bo11:Boolean;
  i,iCount:integer;
begin
    n8:=m_nCurrX;
    nC:=m_nCurrY;
//    PlayScene.NewMagic (Self,80,80,XX,YY,n8 - 3,nC + 3,0,mtThunder,False,30,bo11);
//    PlayScene.NewMagic (Self,80,80,XX,YY,n8 - 3,nC + 3,0,mtThunder,False,30,bo11);
    iCount:=Random(4);
    for i:=0 to iCount do begin
    n10:=Random(4);
    n14:=Random(8);
    n18:=Random(8);
    case n10 of
      0: begin
        PlayScene.NewMagic (Self,80,80,m_nCurrX,m_nCurrY,n8 - n14 - 2,nC + n18 + 1,0,mtThunder,False,30,bo11);
      end;
      1: begin
        PlayScene.NewMagic (Self,80,80,m_nCurrX,m_nCurrY,n8 - n14,nC + n18,0,mtThunder,False,30,bo11);
      end;
      2: begin
        PlayScene.NewMagic (Self,80,80,m_nCurrX,m_nCurrY,n8 - n14,nC + n18 + 1,0,mtThunder,False,30,bo11);
      end;
      3: begin
        PlayScene.NewMagic (Self,80,80,m_nCurrX,m_nCurrY,n8 - n14 - 2,nC + n18,0,mtThunder,False,30,bo11);
      end;
    end;
    PlaySound(8206);
    end;
end;

procedure TFireDragon.DrawEff(dsurface: TDirectDrawSurface; dx,
  dy: integer);
begin
  inherited;
  if m_boUseEffect and (n270 <> nil) then begin
    DrawBlend (dsurface,dx + ax + m_nShiftX,dy + ay + m_nShiftY,n270, 1);
  end;
end;

procedure TFireDragon.LoadSurface;
var
  mimg:TWMImages;
begin
   mimg := FrmMain.WDragonImg;
   if mimg = nil then exit;
     if (not m_boReverseFrame) then begin
       case m_nCurrentAction of
         SM_HIT: begin
           m_BodySurface := mimg.GetCachedImage (40 + m_nCurrentFrame, m_nPx, m_nPy);
         end;

         81: begin
           m_BodySurface := mimg.GetCachedImage (10 + m_nCurrentFrame, m_nPx, m_nPy);
         end;
         82: begin
           m_BodySurface := mimg.GetCachedImage (20 + m_nCurrentFrame, m_nPx, m_nPy);
         end;
         83: begin
           m_BodySurface := mimg.GetCachedImage (30 + m_nCurrentFrame, m_nPx, m_nPy);
         end;
         else begin
           m_BodySurface := mimg.GetCachedImage (GetOffset (m_wAppearance) + m_nCurrentFrame, m_nPx, m_nPy);
         end;
       end;
     end else begin
       case m_nCurrentAction of
         SM_HIT: begin
           m_BodySurface := mimg.GetCachedImage (40 + m_nEndFrame - m_nCurrentFrame, ax, ay);
         end;
         81: begin
           m_BodySurface := mimg.GetCachedImage (10 + m_nEndFrame - m_nCurrentFrame, ax, ay);
         end;
         82: begin
           m_BodySurface := mimg.GetCachedImage (20 + m_nEndFrame - m_nCurrentFrame, ax, ay);
         end;
         83: begin
           m_BodySurface := mimg.GetCachedImage (30 + m_nEndFrame - m_nCurrentFrame, ax, ay);
         end;
         else begin
           m_BodySurface := mimg.GetCachedImage (GetOffset (m_wAppearance) + m_nEndFrame - m_nCurrentFrame, m_nPx, m_nPy);
         end;
       end;
     end;


   if m_boUseEffect then begin
     case m_nCurrentAction of
       SM_HIT: begin
         n270 := FrmMain.WDragonImg.GetCachedImage (60 + m_nEffectFrame, ax, ay);
       end;
       81: begin
         n270 := FrmMain.WDragonImg.GetCachedImage (90 + m_nEffectFrame, ax, ay);
       end;
       82: begin
         n270 := FrmMain.WDragonImg.GetCachedImage (100 + m_nEffectFrame, ax, ay);
       end;
       83: begin
         n270 := FrmMain.WDragonImg.GetCachedImage (110 + m_nEffectFrame, ax, ay);
       end;

     end;
   end;
   {
   Dec(px,14);
   Dec(py,14);
   Dec(ax,14);
   Dec(ay,14);
   }

end;

procedure TFireDragon.Run;
var
   prv: integer;
   m_dwEffectFrameTimetime, m_dwFrameTimetime: longword;
   bo11:Boolean;
begin
   if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then exit;

   m_boMsgMuch := FALSE;
   if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;
   if m_boRunSound then begin
     PlaySound(8201);
     m_boRunSound:=False;
   end;

   if m_boUseEffect then begin
      if m_boMsgMuch then m_dwEffectFrameTimetime := Round(m_dwEffectFrameTime * 2 / 3)
      else m_dwEffectFrameTimetime := m_dwEffectFrameTime;
      if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then begin
         m_dwEffectStartTime := GetTickCount;
         if m_nEffectFrame < m_nEffectEnd then begin
            Inc (m_nEffectFrame);
         end else begin
            m_boUseEffect := FALSE;
         end;
      end;
   end;

   prv := m_nCurrentFrame;
   if m_nCurrentAction <> 0 then begin
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
         m_nCurrentFrame := m_nStartFrame;

      if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else m_dwFrameTimetime := m_dwFrameTime;

      if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
         if m_nCurrentFrame < m_nEndFrame then begin
            Inc (m_nCurrentFrame);
            m_dwStartTime := GetTickCount;
         end else begin
            m_nCurrentAction := 0;
            m_boUseEffect := FALSE;
            bo260:=False;
         end;

         if (m_nCurrentAction = SM_HIT)  then begin//and (m_nCurrentFrame = 4) then begin
           AttackEff;
           PlaySound(8202);
         end;

         if (m_nCurrentAction = 81) or (m_nCurrentAction = 82) or (m_nCurrentAction = 83) then begin
           if (m_nCurrentFrame - m_nStartFrame) = 4 then begin
             PlayScene.NewMagic (Self,m_nCurrentAction,m_nCurrentAction,m_nCurrX,m_nCurrY,m_nTargetX,m_nTargetY,m_nTargetRecog,mtFly,True,30,bo11);
             PlaySound(8203);
           end;
         end;

      end;
      m_nCurrentDefFrame := 0;
      m_dwDefFrameTime := GetTickCount;
   end else begin
      if GetTickCount - m_dwSmoothMoveTime > 200 then begin
         if GetTickCount - m_dwDefFrameTime > 500 then begin
            m_dwDefFrameTime := GetTickCount;
            Inc (m_nCurrentDefFrame);
            if m_nCurrentDefFrame >= m_nDefFrameCount then
               m_nCurrentDefFrame := 0;
         end;
         DefaultMotion;
      end;
   end;

   if prv <> m_nCurrentFrame then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface;
   end;
end;

end.
