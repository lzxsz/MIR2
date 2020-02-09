unit HerbActor;
//BOSS밍

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grobal2, DxDraws, CliUtil, magiceff, Actor, WIl;


const
   BEEQUEENBASE = 600;
   DOORDEATHEFFECTBASE = 120;
   WALLLEFTBROKENEFFECTBASE = 224;
   WALLRIGHTBROKENEFFECTBASE = 240;

type
   TDoorState = (dsOpen, dsClose, dsBroken);

   TKillingHerb = class (TActor)//Size 0x250
   private
   public
      constructor Create; override;
      destructor Destroy; override;
      procedure CalcActorFrame; override;
      function  GetDefaultFrame (wmode: Boolean): integer; override;
   end;

   TMineMon = class (TKillingHerb)
   private
   public
      constructor Create; override;
      procedure CalcActorFrame; override;
      function  GetDefaultFrame (wmode: Boolean): integer; override;
   end;

   TBeeQueen = class (TActor)
   private
   public
      procedure CalcActorFrame; override;
      function  GetDefaultFrame (wmode: Boolean): integer; override;
   end;

   TCentipedeKingMon = class (TKillingHerb)//Size 0x260
   private
      AttackEffectSurface :TDirectDrawSurface; //0x250
      BoUseDieEffect      :Boolean;            //0x254
      ax                  :integer;            //0x258
      ay                  :integer;            //0x25C
      procedure LoadEffect();
   public
      procedure CalcActorFrame; override;
      procedure LoadSurface; override;
      procedure DrawEff (dsurface: TDirectDrawSurface; dx, dy: integer);override;
      procedure Run;override;
   end;
   TBigHeartMon = class (TKillingHerb)//Size 0x260
   private
   public
     procedure CalcActorFrame; override;
   end;
   TSpiderHouseMon = class (TKillingHerb)
   private
   public
     procedure CalcActorFrame; override;
   end;
   TCastleDoor = class (TActor)
   private
      EffectSurface: TDirectDrawSurface;
      ax, ay: integer;
      oldunitx, oldunity: integer;
      procedure ApplyDoorState (dstate: TDoorState);
   public
      BoDoorOpen: Boolean;
      constructor Create; override;
      procedure CalcActorFrame; override;
      procedure  LoadSurface; override;
      function  GetDefaultFrame (wmode: Boolean): integer; override;
      procedure  ActionEnded; override;
      procedure  Run; override;
      procedure  DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean); override;
   end;

   TWallStructure = class (TActor)//0x62
   private
      EffectSurface: TDirectDrawSurface;
      BrokenSurface: TDirectDrawSurface;
      ax, ay, bx, by: integer;
      deathframe: integer;
      bomarkpos: Boolean;  //못가게 막고 있는지
   public
      constructor Create; override;
      procedure CalcActorFrame; override;
      procedure  LoadSurface; override;
      function  GetDefaultFrame (wmode: Boolean): integer; override;
      procedure  DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean); override;
      procedure  Run; override;
   end;

   TSoccerBall = class (TActor)//0x9
   private
   public
   end;
   TDragonBody = class (TKillingHerb)//0x5a
   private
   public
     procedure DrawEff (dsurface: TDirectDrawSurface; dx, dy: integer); override;
     procedure CalcActorFrame(); override;
  //   procedure LoadSurface(); override;    //lzx 2019-11-10 
   end;
implementation

uses
   ClMain, MShare;


{============================== TKillingHerb =============================}

//        식인초

{--------------------------}


constructor TKillingHerb.Create;
begin
   inherited Create;
end;

destructor TKillingHerb.Destroy;
begin
   inherited Destroy;
end;

procedure TKillingHerb.CalcActorFrame;
var
   pm: PTMonsterAction;
   haircount: integer;
begin
   m_boUseMagic := FALSE;
   m_nCurrentFrame := -1;

   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;

   case m_nCurrentAction of
      SM_TURN: //
         begin
            m_nStartFrame := pm.ActStand.start; // + Dir * (pm.ActStand.frame + pm.ActStand.skip);
            m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
            m_dwFrameTime := pm.ActStand.ftime;
            m_dwStartTime := GetTickCount;
            m_nDefFrameCount := pm.ActStand.frame;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_DIGUP: //, SM_DIGUP, .
         begin
            m_nStartFrame := pm.ActWalk.start; // + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
            m_nEndFrame := m_nStartFrame + pm.ActWalk.frame - 1;
            m_dwFrameTime := pm.ActWalk.ftime;
            m_dwStartTime := GetTickCount;
            m_nMaxTick := pm.ActWalk.UseTick;
            m_nCurTick := 0;
            //WarMode := FALSE;
            m_nMoveStep := 1;
            Shift (m_btDir, 0, 0, 1); //m_nMoveStep, 0, m_nEndFrame-startframe+1);
         end;
      SM_HIT:
         begin
            m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
            m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
            m_dwFrameTime := pm.ActAttack.ftime;
            m_dwStartTime := GetTickCount;
            //WarMode := TRUE;
            m_dwWarModeTime := GetTickCount;
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
      SM_DIGDOWN:
         begin
            m_nStartFrame := pm.ActDeath.start;
            m_nEndFrame := m_nStartFrame + pm.ActDeath.frame - 1;
            m_dwFrameTime := pm.ActDeath.ftime;
            m_dwStartTime := GetTickCount;
            m_boDelActionAfterFinished := TRUE;  
         end;
   end;
end;


function  TKillingHerb.GetDefaultFrame (wmode: Boolean): integer;
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
      Result := pm.ActStand.start + cf; //방향이 없음..
   end;
end;


{----------------------------------------------------------------------}
//비막원충


procedure TBeeQueen.CalcActorFrame;
var
   pm: PTMonsterAction;
begin
   m_boUseMagic := FALSE;
   m_nCurrentFrame := -1;

   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;

   case m_nCurrentAction of
      SM_TURN: //방향이 없음...
         begin
            m_nStartFrame := pm.ActStand.start; // + Dir * (pm.ActStand.frame + pm.ActStand.skip);
            m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
            m_dwFrameTime := pm.ActStand.ftime;
            m_dwStartTime := GetTickCount;
            m_nDefFrameCount := pm.ActStand.frame;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_HIT:
         begin
            m_nStartFrame := pm.ActAttack.start; // + Dir * (pm.ActAttack.frame + pm.ActAttack.skip);
            m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
            m_dwFrameTime := pm.ActAttack.ftime;
            m_dwStartTime := GetTickCount;
            //WarMode := TRUE;
            m_dwWarModeTime := GetTickCount;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_STRUCK:
         begin
            m_nStartFrame := pm.ActStruck.start; // + Dir * (pm.ActStruck.frame + pm.ActStruck.skip);
            m_nEndFrame := m_nStartFrame + pm.ActStruck.frame - 1;
            m_dwFrameTime := m_dwStruckFrameTime; //pm.ActStruck.ftime;
            m_dwStartTime := GetTickCount;
         end;
      SM_DEATH:
         begin
            m_nStartFrame := pm.ActDie.start; // + Dir * (pm.ActDie.frame + pm.ActDie.skip);
            m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
            m_nStartFrame := m_nEndFrame; //
            m_dwFrameTime := pm.ActDie.ftime;
            m_dwStartTime := GetTickCount;
         end;
      SM_NOWDEATH:
         begin
            m_nStartFrame := pm.ActDie.start; // + Dir * (pm.ActDie.frame + pm.ActDie.skip);
            m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
            m_dwFrameTime := pm.ActDie.ftime;
            m_dwStartTime := GetTickCount;
         end;
   end;
end;

function  TBeeQueen.GetDefaultFrame (wmode: Boolean): integer;
var
   pm: PTMonsterAction;
   cf: integer;
begin
   Result:=0;//jacky
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;

   if m_boDeath then begin
      Result := pm.ActDie.start + (pm.ActDie.frame - 1);
   end else begin
      m_nDefFrameCount := pm.ActStand.frame;
      if m_nCurrentDefFrame < 0 then cf := 0
      else if m_nCurrentDefFrame >= pm.ActStand.frame then cf := 0
      else cf := m_nCurrentDefFrame;
      Result := pm.ActStand.start + cf; //방향이 없음..
   end;
end;


{----------------------------------------------------------------------}
//지네왕


procedure TCentipedeKingMon.CalcActorFrame;
var
   pm: PTMonsterAction;
begin
   m_boUseMagic := FALSE;
   m_nCurrentFrame := -1;
   m_nBodyOffset := GetOffset(m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;

   case m_nCurrentAction of
      SM_TURN: //
         begin
            m_btDir := 0;
            inherited CalcActorFrame;
         end;
      SM_HIT:
         begin
            m_btDir:=0;
            m_nStartFrame:=pm.ActCritical.start + m_btDir * (pm.ActCritical.frame + pm.ActCritical.skip);
            m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
            m_dwFrameTime:=pm.ActCritical.ftime;
            m_dwStartTime := GetTickCount;
            BoUseDieEffect:=True;
            m_nEffectFrame:=0;
            m_nEffectStart:=0;
            m_nEffectEnd:=m_nEffectStart + 9;
            m_dwEffectFrameTime:= 62;
//            BoUseEffect:=True;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_DIGDOWN:
         begin
           inherited CalcActorFrame;
         end;
      else begin
         m_btDir := 0;
         inherited CalcActorFrame;
      end;
   end;
end;


{----------------------------------------------------------------------}
//성벽, 성문

constructor TCastleDoor.Create;
begin
   inherited Create;
   m_btDir := 0;
   EffectSurface := nil;
   m_nDownDrawLevel := 1;  //1셀 먼저 그림. (사람 머리가 성문 밑으로 들어가는 것을 막음)
end;

procedure TCastleDoor.ApplyDoorState (dstate: TDoorState);
var
   bowalk: Boolean;
begin
   Map.MarkCanWalk (m_nCurrX, m_nCurrY-2, TRUE);
   Map.MarkCanWalk (m_nCurrX+1, m_nCurrY-1, TRUE);
   Map.MarkCanWalk (m_nCurrX+1, m_nCurrY-2, TRUE);
   if dstate = dsClose then bowalk := FALSE
   else bowalk := TRUE;

   Map.MarkCanWalk (m_nCurrX, m_nCurrY, bowalk);
   Map.MarkCanWalk (m_nCurrX, m_nCurrY-1, bowalk);
   Map.MarkCanWalk (m_nCurrX, m_nCurrY-2, bowalk);
   Map.MarkCanWalk (m_nCurrX+1, m_nCurrY-1, bowalk);
   Map.MarkCanWalk (m_nCurrX+1, m_nCurrY-2, bowalk);
   Map.MarkCanWalk (m_nCurrX-1, m_nCurrY-1, bowalk);
   Map.MarkCanWalk (m_nCurrX-1, m_nCurrY, bowalk);
   Map.MarkCanWalk (m_nCurrX-1, m_nCurrY+1, bowalk);
   Map.MarkCanWalk (m_nCurrX-2, m_nCurrY, bowalk);

   if dstate = dsOpen then begin
      Map.MarkCanWalk (m_nCurrX, m_nCurrY-2, FALSE);
      Map.MarkCanWalk (m_nCurrX+1, m_nCurrY-1, FALSE);
      Map.MarkCanWalk (m_nCurrX+1, m_nCurrY-2, FALSE);
   end;
end;

procedure  TCastleDoor.LoadSurface;
var
   mimg: TWMImages;
begin
   inherited LoadSurface;
   mimg := GetMonImg (m_wAppearance);
   if m_boUseEffect then
      EffectSurface := mimg.GetCachedImage (DOORDEATHEFFECTBASE + (m_nCurrentFrame - m_nStartFrame), ax, ay);
end;

procedure TCastleDoor.CalcActorFrame;
var
   pm: PTMonsterAction;
   haircount: integer;
begin
   m_boUseEffect := FALSE;
   m_nCurrentFrame := -1;

   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;
   m_sUserName := ' ';

   case m_nCurrentAction of
      SM_NOWDEATH:
         begin
            m_nStartFrame := pm.ActDie.start;
            m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
            m_dwFrameTime := pm.ActDie.ftime;
            m_dwStartTime := GetTickCount;
            Shift (m_btDir, 0, 0, 1);
            m_boUseEffect := TRUE;
            ApplyDoorState (dsBroken);  //움직일 수 있게
         end;
      SM_STRUCK:
         begin
            m_nStartFrame := pm.ActStruck.start + m_btDir * (pm.ActStruck.frame + pm.ActStruck.skip);
            m_nEndFrame := m_nStartFrame + pm.ActStruck.frame - 1;
            m_dwFrameTime := pm.ActStand.ftime;
            m_dwStartTime := GetTickCount;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_DIGUP:  //문 열림
         begin
            m_nStartFrame := pm.ActAttack.start;
            m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
            m_dwFrameTime := pm.ActAttack.ftime;
            m_dwStartTime := GetTickCount;
            ApplyDoorState (dsOpen);  //움직일 수 있게
         end;
      SM_DIGDOWN:  //문 닫힘
         begin
            m_nStartFrame := pm.ActCritical.start;
            m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
            m_dwFrameTime := pm.ActCritical.ftime;
            m_dwStartTime := GetTickCount;
            BoDoorOpen := FALSE;
            m_boHoldPlace := TRUE;
            ApplyDoorState (dsClose);  //못움직임
         end;
      SM_DEATH:
         begin
            m_nStartFrame := pm.ActDie.start + pm.ActDie.frame - 1;
            m_nEndFrame := m_nStartFrame;
            m_nDefFrameCount := 0;
            ApplyDoorState (dsBroken);  //움직일 수 있게
         end;
      else  //방향이 없음...
         begin
            if m_btDir < 3 then begin
               m_nStartFrame := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
               m_nEndFrame := m_nStartFrame; // + pm.ActStand.frame - 1;
               m_dwFrameTime := pm.ActStand.ftime;
               m_dwStartTime := GetTickCount;
               m_nDefFrameCount := 0; //pm.ActStand.frame;
               Shift (m_btDir, 0, 0, 1);
               BoDoorOpen := FALSE;
               m_boHoldPlace := TRUE;
               ApplyDoorState (dsClose);  //못움직이게
            end else begin
               m_nStartFrame := pm.ActCritical.start;  //열려있는 상태
               m_nEndFrame := m_nStartFrame;
               m_nDefFrameCount := 0;

               BoDoorOpen := TRUE;
               m_boHoldPlace := FALSE;
               ApplyDoorState (dsOpen);  //걸을 수 있음
            end;
         end;
   end;
end;

function  TCastleDoor.GetDefaultFrame (wmode: Boolean): integer;
var
   pm: PTMonsterAction;
begin
   Result:=0;//jacky
   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;
   if m_boDeath then begin
      Result := pm.ActDie.start + pm.ActDie.frame - 1;
      m_nDownDrawLevel := 2;
   end else begin
      if BoDoorOpen then begin
         m_nDownDrawLevel := 2;
         Result := pm.ActCritical.start; // + Dir * (pm.ActStand.frame + pm.ActStand.skip);
      end else begin
         m_nDownDrawLevel := 1;
         Result := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
      end;
   end;
end;

procedure  TCastleDoor.ActionEnded;
begin
   if m_nCurrentAction = SM_DIGUP then begin  //문열림
      BoDoorOpen := TRUE;
      m_boHoldPlace := FALSE;
   end;
//   if CurrentAction = SM_DIGDOWN then
//      DefaultMotion;
end;

procedure  TCastleDoor.Run;
begin
   if (Map.m_nCurUnitX <> oldunitx) or (Map.m_nCurUnitY <> oldunity) then begin
      if m_boDeath then ApplyDoorState (dsBroken)
      else if BoDoorOpen then ApplyDoorState (dsOpen)
      else ApplyDoorState (dsClose);
   end;
   oldunitx := Map.m_nCurUnitX;
   oldunity := Map.m_nCurUnitY;
   inherited Run;
end;

procedure  TCastleDoor.DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean);
begin
   inherited DrawChr (dsurface, dx, dy, blend,False);
   if m_boUseEffect and not blend then
      if EffectSurface <> nil then begin
         DrawBlend (dsurface,
                    dx + ax + m_nShiftX,
                    dy + ay + m_nShiftY,
                    EffectSurface, 1);
      end;
end;



{----------------------------------------------------------------------}
//성벽


constructor TWallStructure.Create;
begin
   inherited Create;
   m_btDir := 0;
   EffectSurface := nil;
   BrokenSurface := nil;
   bomarkpos := FALSE;
   //DownDrawLevel := 1;
end;

procedure TWallStructure.CalcActorFrame;
var
   pm: PTMonsterAction;
   haircount: integer;
begin
   m_boUseEffect := FALSE;
   m_nCurrentFrame := -1;

   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;
   m_sUserName := ' ';
   deathframe := 0;
   m_boUseEffect := FALSE;

   case m_nCurrentAction of
      SM_NOWDEATH:
         begin
            m_nStartFrame := pm.ActDie.start;
            m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
            m_dwFrameTime := pm.ActDie.ftime;
            m_dwStartTime := GetTickCount;
            deathframe := pm.ActStand.start + m_btDir;
            Shift (m_btDir, 0, 0, 1);
            m_boUseEffect := TRUE;
         end;
      SM_DEATH:
         begin
            m_nStartFrame := pm.ActDie.start + pm.ActDie.frame - 1;
            m_nEndFrame := m_nStartFrame;
            m_nDefFrameCount := 0;
         end;
      SM_DIGUP:  //모습이 변경될때 마다
         begin
            m_nStartFrame := pm.ActDie.start;
            m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
            m_dwFrameTime := pm.ActDie.ftime;
            m_dwStartTime := GetTickCount;
            deathframe := pm.ActStand.start + m_btDir;
            m_boUseEffect := TRUE;
         end;
      else  //방향이 없음...
         begin
            m_nStartFrame := pm.ActStand.start + m_btDir; // * (pm.ActStand.frame + pm.ActStand.skip);
            m_nEndFrame := m_nStartFrame; // + pm.ActStand.frame - 1;
            m_dwFrameTime := pm.ActStand.ftime;
            m_dwStartTime := GetTickCount;
            m_nDefFrameCount := 0; //pm.ActStand.frame;
            Shift (m_btDir, 0, 0, 1);
            m_boHoldPlace := TRUE;
         end;
   end;
end;

procedure  TWallStructure.LoadSurface;
var
   mimg: TWMImages;
begin
   mimg := GetMonImg (m_wAppearance);
   if deathframe > 0 then begin //(CurrentAction = SM_NOWDEATH) or (CurrentAction = SM_DEATH) then begin
      m_BodySurface := mimg.GetCachedImage (GetOffset (m_wAppearance) + deathframe, m_nPx, m_nPy);
   end else begin
      inherited LoadSurface;
   end;
   BrokenSurface := mimg.GetCachedImage (GetOffset (m_wAppearance) + 8 + m_btDir, bx, by);

   if m_boUseEffect then begin
      if m_wAppearance = 901 then
         EffectSurface := mimg.GetCachedImage (WALLLEFTBROKENEFFECTBASE + (m_nCurrentFrame - m_nStartFrame), ax, ay)
      else
         EffectSurface := mimg.GetCachedImage (WALLRIGHTBROKENEFFECTBASE + (m_nCurrentFrame - m_nStartFrame), ax, ay);
   end;
end;

function  TWallStructure.GetDefaultFrame (wmode: Boolean): integer;
var
   pm: PTMonsterAction;
begin
   Result:=0;//jacky
   m_nBodyOffset := GetOffset (m_wAppearance);
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;
    Result := pm.ActStand.start + m_btDir; // * (pm.ActStand.frame + pm.ActStand.skip);
end;

procedure TWallStructure.DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean);
begin
   inherited DrawChr (dsurface, dx, dy, blend,boFlag);
   if (BrokenSurface <> nil) and (not blend) then begin
      dsurface.Draw (dx + bx + m_nShiftX,
                     dy + by + m_nShiftY,
                     BrokenSurface.ClientRect,
                     BrokenSurface, TRUE);
   end;
   if m_boUseEffect and (not blend) then begin
      if EffectSurface <> nil then begin
         DrawBlend (dsurface,
                    dx + ax + m_nShiftX,
                    dy + ay + m_nShiftY,
                    EffectSurface, 1);
      end;
   end;
end;

procedure  TWallStructure.Run;
begin
   if m_boDeath then begin
      if bomarkpos then begin
         Map.MarkCanWalk (m_nCurrX, m_nCurrY, TRUE);
         bomarkpos := FALSE;
      end;
   end else begin
      if not bomarkpos then begin
         Map.MarkCanWalk (m_nCurrX, m_nCurrY, FALSE);
         bomarkpos := TRUE;
      end;
   end;
   PlayScene.SetActorDrawLevel (self, 0);
   inherited Run;
end;


{ TMineMon }

procedure TMineMon.CalcActorFrame;
begin
  inherited;

end;

constructor TMineMon.Create;
begin
  inherited;

end;




procedure TCentipedeKingMon.DrawEff(dsurface: TDirectDrawSurface; dx,
  dy: integer);
var
   idx: integer;
   d: TDirectDrawSurface;
   ceff: TColorEffect;
begin
 if m_boUseEffect then
  if AttackEffectSurface <> nil then
    DrawBlend (dsurface,dx + ax + m_nShiftX,dy + ay + m_nShiftY,AttackEffectSurface, 1);

end;

procedure TCentipedeKingMon.LoadEffect;
begin
  if m_boUseEffect then
    AttackEffectSurface := FrmMain.WMon15Img.GetCachedImage (
                        100 + m_nEffectFrame-m_nEffectStart, //가스는 처음 한프레음 늦게 시작함.
                        ax, ay);
end;

procedure TCentipedeKingMon.LoadSurface;
begin
   inherited LoadSurface;
   LoadEffect();
end;

function TMineMon.GetDefaultFrame(wmode: Boolean): integer;
begin

end;

{ TBigHeartMon }

procedure TBigHeartMon.CalcActorFrame;
begin
  m_btDir:=0;
  inherited CalcActorFrame;
end;

{ TSpiderHouseMon }

procedure TSpiderHouseMon.CalcActorFrame;
begin
  m_btDir:=0;
  inherited CalcActorFrame;
end;

procedure TCentipedeKingMon.Run;
begin
   if (m_nCurrentAction = SM_WALK) or
      (m_nCurrentAction = SM_BACKSTEP) or
      (m_nCurrentAction = SM_HORSERUN) or
      (m_nCurrentAction = SM_RUN)
   then exit;
   if BoUseDieEffect then begin
     if (m_nCurrentFrame - m_nStartFrame) >= 5 then begin
       BoUseDieEffect:=False;
       m_boUseEffect:=True;
       m_dwEffectStartTime:=GetTickCount();
       m_nEffectFrame:=0;
       LoadEffect();
     end;
   end;
   if m_boUseEffect then begin
     if (GetTickCount - m_dwEffectStartTime) > m_dwEffectFrameTime then begin
       m_dwEffectStartTime:=GetTickCount();
       if m_nEffectFrame < m_nEffectEnd then begin
         Inc(m_nEffectFrame);
         LoadEffect();
       end else m_boUseEffect:=False;
     end;
   end;
  inherited;
end;

{ TDragonBody }

procedure TDragonBody.CalcActorFrame;
var
   pm: PTMonsterAction;
begin
  m_btDir:=0;
  m_boUseMagic:=False;
  m_nCurrentFrame:= -1;
  m_nBodyOffset := GetOffset(m_wAppearance);
  pm := GetRaceByPM (m_btRace,m_wAppearance);
  if pm = nil then exit;
  if m_nCurrentAction = SM_DIGUP then begin
    m_nMaxTick:=pm.ActWalk.ftime;
    m_nCurTick:=0;
    m_nMoveStep:=1;
    Shift (m_btDir, 0, 0, 1);
  end;
  m_nStartFrame:=0;
  m_nEndFrame:=1;
  m_dwFrameTime:=400;
  m_dwStartTime:=GetTickCount();
end;

procedure TDragonBody.DrawEff(dsurface: TDirectDrawSurface; dx,
  dy: integer);
//0x0046C3C0
begin
   if not (m_btDir in [0..7]) then exit;
   if GetTickCount - m_dwLoadSurfaceTime > 60 * 1000 then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface; //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
   end;
    if m_BodySurface <> nil then
      DrawBlend (dsurface,dx + m_nPx + m_nShiftX,dy + m_nPy + m_nShiftY,m_BodySurface, 1);

end;

{* lzx 2019-11-10
procedure TDragonBody.LoadSurface;
begin
  m_BodySurface := FrmMain.WDragonImg.GetCachedImage(GetOffset(m_wAppearance),m_nPx,m_nHpy);
end;
}

end.
