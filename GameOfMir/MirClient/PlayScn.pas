unit PlayScn;
//ÓÎÏ·Ö÷³¡¾°
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, DirectX, IntroScn, Grobal2, CliUtil, HUtil32,
  Actor, HerbActor, AxeMon, SoundUtil, ClEvent, Wil,
  StdCtrls, clFunc, magiceff, extctrls, MShare, Share;


const
//µØÍ¼ºÍÎïÆ·ÄÏÕ¾µÄµØ·½
   MAPSURFACEWIDTH = 800;
   MAPSURFACEHEIGHT = 445;

   LONGHEIGHT_IMAGE = 35;
   FLASHBASE = 410;
   AAX = 16;
   SOFFX = 0;
   SOFFY = 0;
   LMX = 30;
   LMY = 26;



   MAXLIGHT = 5;
   LightFiles : array[0..MAXLIGHT] of string = (
      'Data\lig0a.dat',
      'Data\lig0b.dat',
      'Data\lig0c.dat',
      'Data\lig0d.dat',
      'Data\lig0e.dat',
      'Data\lig0f.dat'
   );

   LightMask0 : array[0..2, 0..2] of shortint = (
      (0,1,0),
      (1,3,1),
      (0,1,0)
   );
   LightMask1 : array[0..4, 0..4] of shortint = (
      (0,1,1,1,0),
      (1,1,3,1,1),
      (1,3,4,3,1),
      (1,1,3,1,1),
      (0,1,2,1,0)
   );
   LightMask2 : array[0..8, 0..8] of shortint = (
      (0,0,0,1,1,1,0,0,0),
      (0,0,1,2,3,2,1,0,0),
      (0,1,2,3,4,3,2,1,0),
      (1,2,3,4,4,4,3,2,1),
      (1,3,4,4,4,4,4,3,1),
      (1,2,3,4,4,4,3,2,1),
      (0,1,2,3,4,3,2,1,0),
      (0,0,1,2,3,2,1,0,0),
      (0,0,0,1,1,1,0,0,0)
   );
   LightMask3 : array[0..10, 0..10] of shortint = (
      (0,0,0,0,1,1,1,0,0,0,0),
      (0,0,0,1,2,2,2,1,0,0,0),
      (0,0,1,2,3,3,3,2,1,0,0),
      (0,1,2,3,4,4,4,3,2,1,0),
      (1,2,3,4,4,4,4,4,3,2,1),
      (2,3,4,4,4,4,4,4,4,3,2),
      (1,2,3,4,4,4,4,4,3,2,1),
      (0,1,2,3,4,4,4,3,2,1,0),
      (0,0,1,2,3,3,3,2,1,0,0),
      (0,0,0,1,2,2,2,1,0,0,0),
      (0,0,0,0,1,1,1,0,0,0,0)
   );

   LightMask4 : array[0..14, 0..14] of shortint = (
      (0,0,0,0,0,0,1,1,1,0,0,0,0,0,0),
      (0,0,0,0,0,1,1,1,1,1,0,0,0,0,0),
      (0,0,0,0,1,1,2,2,2,1,1,0,0,0,0),
      (0,0,0,1,1,2,3,3,3,2,1,1,0,0,0),
      (0,0,1,1,2,3,4,4,4,3,2,1,1,0,0),
      (0,1,1,2,3,4,4,4,4,4,3,2,1,1,0),
      (1,1,2,3,4,4,4,4,4,4,4,3,2,1,1),
      (1,2,3,4,4,4,4,4,4,4,4,4,3,2,1),
      (1,1,2,3,4,4,4,4,4,4,4,3,2,1,1),
      (0,1,1,2,3,4,4,4,4,4,3,2,1,1,0),
      (0,0,1,1,2,3,4,4,4,3,2,1,1,0,0),
      (0,0,0,1,1,2,3,3,3,2,1,1,0,0,0),
      (0,0,0,0,1,1,2,2,2,1,1,0,0,0,0),
      (0,0,0,0,0,1,1,1,1,1,0,0,0,0,0),
      (0,0,0,0,0,0,1,1,1,0,0,0,0,0,0)
   );

   LightMask5 : array[0..16, 0..16] of shortint = (
      (0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0),
      (0,0,0,0,0,0,1,2,2,2,1,0,0,0,0,0,0),
      (0,0,0,0,0,1,2,4,4,4,2,1,0,0,0,0,0),
      (0,0,0,0,1,2,4,4,4,4,4,2,1,0,0,0,0),
      (0,0,0,1,2,4,4,4,4,4,4,4,2,1,0,0,0),
      (0,0,1,2,4,4,4,4,4,4,4,4,4,2,1,0,0),
      (0,1,2,4,4,4,4,4,4,4,4,4,4,4,2,1,0),
      (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
      (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
      (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
      (0,1,2,4,4,4,4,4,4,4,4,4,4,4,2,1,0),
      (0,0,1,2,4,4,4,4,4,4,4,4,4,2,1,0,0),
      (0,0,0,1,2,4,4,4,4,4,4,4,2,1,0,0,0),
      (0,0,0,0,1,2,4,4,4,4,4,2,1,0,0,0,0),
      (0,0,0,0,0,1,2,4,4,4,2,1,0,0,0,0,0),
      (0,0,0,0,0,0,1,2,2,2,1,0,0,0,0,0,0),
      (0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0)
     { (0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0),
      (0,0,0,0,0,0,0,1,2,2,2,1,0,0,0,0,0,0,0),
      (0,0,0,0,0,0,1,2,4,4,4,2,1,0,0,0,0,0,0),
      (0,0,0,0,0,1,2,4,4,4,4,4,2,1,0,0,0,0,0),
      (0,0,0,0,1,2,4,4,4,4,4,4,4,2,1,0,0,0,0),
      (0,0,0,1,2,4,4,4,4,4,4,4,4,4,2,1,0,0,0),
      (0,0,1,2,4,4,4,4,4,4,4,4,4,4,4,2,1,0,0),
      (0,1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1,0),
      (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
      (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
      (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
      (0,1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1,0),
      (0,0,1,2,4,4,4,4,4,4,4,4,4,4,4,2,1,0,0),
      (0,0,0,1,2,4,4,4,4,4,4,4,4,4,2,1,0,0,0),
      (0,0,0,0,1,2,4,4,4,4,4,4,4,2,1,0,0,0,0),
      (0,0,0,0,0,1,2,4,4,4,4,4,2,1,0,0,0,0,0),
      (0,0,0,0,0,0,1,2,4,4,4,2,1,0,0,0,0,0,0),
      (0,0,0,0,0,0,0,1,2,2,2,1,0,0,0,0,0,0,0),
      (0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0) }
   );

type
   PShoftInt = ^ShortInt;
   TLightEffect = record
      Width: integer;
      Height: integer;
      PFog: Pbyte;
   end;
   TLightMapInfo = record
      ShiftX: integer;
      ShiftY: integer;
      light:  integer;
      bright: integer;
   end;

   TPlayScene = class (TScene)
   private
     m_MapSurface    :TDirectDrawSurface;
     m_ObjSurface    :TDirectDrawSurface; //0x0C

     m_FogScreen     :array[0..MAPSURFACEHEIGHT, 0..MAPSURFACEWIDTH] of byte;
     m_PFogScreen    :PByte;
     m_nFogWidth     :Integer;
     m_nFogHeight    :Integer;
     m_Lights        :array[0..MAXLIGHT] of TLightEffect;
     m_dwMoveTime    :LongWord;
     m_nMoveStepCount:Integer;
     m_dwAniTime     :LongWord;
     m_nAniCount     :Integer;
     m_nDefXX        :Integer;
     m_nDefYY        :Integer;
     m_MainSoundTimer:TTimer;
     m_MsgList       :TList;
     m_LightMap      :array[0..LMX, 0..LMY] of TLightMapInfo;
     procedure DrawTileMap;
     procedure LoadFog;
     procedure ClearLightMap;
     procedure AddLight (x, y, shiftx, shifty, light: integer; nocheck: Boolean);
     procedure UpdateBright (x, y, light: integer);
     function  CheckOverLight (x, y, light: integer): Boolean;
     procedure ApplyLightMap;
     procedure DrawLightEffect (lx, ly, bright: integer);
     procedure EdChatKeyPress (Sender: TObject; var Key: Char);
     procedure SoundOnTimer (Sender: TObject);
     function  CrashManEx(mx, my: integer): Boolean;
     procedure ClearDropItem();
   public
      EdChat: TEdit;
      MemoLog: TMemo;
      EdAccountt: TEdit;//2004/05/17
      EdChrNamet: TEdit;//2004/05/17
      {
      EdChgChrName: TEdit;
      EdChgCurPwd: TEdit;
      EdChgNewPwd: TEdit;
      EdChgRePwd: TEdit;
      }
            
     m_ActorList        :TList;
     m_TempList         :TList;
     m_GroundEffectList :TList;  //¹Ù´Ú¿¡ ±ò¸®´Â ¸¶¹ý ¸®½ºÆ®
     m_EffectList       :TList; //¸¶¹ýÈ¿°ú ¸®½ºÆ®
     m_FlyList          :TList;  //³¯¾Æ´Ù´Ï´Â °Í (´øÁøµµ³¢, Ã¢, È­»ì)
     m_dwBlinkTime      :LongWord;
     m_boViewBlink      :Boolean;
      constructor Create;
      destructor Destroy; override;
      procedure Initialize; override;
      procedure Finalize; override;
      procedure OpenScene; override;
      procedure CloseScene; override;
      procedure OpeningScene; override;
      procedure DrawMiniMap (surface: TDirectDrawSurface);
      procedure PlayScene (MSurface: TDirectDrawSurface); override;
      function  ButchAnimal (x, y: integer): TActor;

      function  FindActor (id: integer): TActor;overload;
      function  FindActor (sName:String): TActor;overload;
      function  FindActorXY (x, y: integer): TActor;
      function  IsValidActor (actor: TActor): Boolean;
      function  NewActor (chrid: integer; cx, cy, cdir: word; cfeature, cstate: integer): TActor;
      procedure ActorDied (actor: TObject); //Á×Àº actor´Â ¸Ç À§·Î
      procedure SetActorDrawLevel (actor: TObject; level: integer);
      procedure ClearActors;
      function  DeleteActor (id: integer): TActor;
      procedure DelActor (actor: TObject);
      procedure SendMsg (ident, chrid, x, y, cdir, feature, state: integer; str: string);

      procedure NewMagic (aowner: TActor;
                          magid, magnumb, cx, cy, tx, ty, targetcode: integer;
                          mtype: TMagicType;
                          Recusion: Boolean;
                          anitime: integer;
                          var bofly: Boolean);
      procedure DelMagic (magid: integer);
      function  NewFlyObject (aowner: TActor; cx, cy, tx, ty, targetcode: integer;  mtype: TMagicType): TMagicEff;
      //function  NewStaticMagic (aowner: TActor; tx, ty, targetcode, effnum: integer);

      procedure ScreenXYfromMCXY (cx, cy: integer; var sx, sy: integer);
      procedure CXYfromMouseXY (mx, my: integer; var ccx, ccy: integer);
      function  GetCharacter (x, y, wantsel: integer; var nowsel: integer; liveonly: Boolean): TActor;
      function  GetAttackFocusCharacter (x, y, wantsel: integer; var nowsel: integer; liveonly: Boolean): TActor;
      function  IsSelectMyself (x, y: integer): Boolean;
      function  GetDropItems (x, y: integer; var inames: string): PTDropItem;
      function  GetXYDropItems (nX,nY:Integer):pTDropItem;
      procedure GetXYDropItemsList (nX,nY:Integer;var ItemList:TList);
      function  CanRun (sx, sy, ex, ey: integer): Boolean;
      function  CanWalk (mx, my: integer): Boolean;
      function  CanWalkEx (mx, my: integer): Boolean;
      function  CrashMan (mx, my: integer): Boolean; //»ç¶÷³¢¸® °ãÄ¡´Â°¡?
      function  CanFly (mx, my: integer): Boolean;
      procedure RefreshScene;
      procedure CleanObjects;
   end;


implementation

uses
   ClMain, FState;


constructor TPlayScene.Create;
var
  nx,ny:Integer;
begin
   m_MapSurface := nil;
   m_ObjSurface := nil;
   m_MsgList := TList.Create;   //ÏûÏ¢ÁÐ±í
   m_ActorList := TList.Create;    //½ÇÉ«ÁÐ±í
   m_TempList := TList.Create;
   m_GroundEffectList := TList.Create;
   m_EffectList := TList.Create;
   m_FlyList := TList.Create;
   m_dwBlinkTime := GetTickCount;
   m_boViewBlink := FALSE;
   //ÁÄÌìÐÅÏ¢ÊäÈë¿ò
   EdChat := TEdit.Create (FrmMain.Owner);
   with EdChat do begin
      Parent := FrmMain;
      BorderStyle := bsNone;
      OnKeyPress := EdChatKeyPress;
      Visible := FALSE;
      MaxLength := 70;
      Ctl3D := FALSE;
      Left   := 208;
      Top    := SCREENHEIGHT - 19;
      Height := 12;
      Width  := (SCREENWIDTH div 2 - 207) * 2{387};
      Color := clSilver;
   end;

   //ÁÄÌìÐÅÏ¢¼ÇÂ¼¿ò
   MemoLog:=TMemo.Create(FrmMain.Owner);
   with MemoLog do begin
      Parent := FrmMain;
      BorderStyle := bsNone;
      Visible := False;
     // Visible := True;
      Ctl3D := True;
    Left := 0;
    Top := 250;
    Width := 300;
    Height := 150;
   end;
   //2004/05/17
   EdAccountt := TEdit.Create (FrmMain.Owner);
   with EdAccountt do begin
      Parent := FrmMain;
      BorderStyle := bsSingle;
      Visible := False;
      MaxLength := 70;
      Ctl3D := True;
      Left   := (SCREENWIDTH - 194) div 2;
      Top    := SCREENHEIGHT - 200;
      Height := 12;
      Width  := 194;
   end;
   //2004/05/17
   //2004/05/17
   EdChrNamet := TEdit.Create (FrmMain.Owner);
   with EdChrNamet do begin
      Parent := FrmMain;
      BorderStyle := bsSingle;
      Visible := False;
      MaxLength := 70;
      Ctl3D := True;
      Left   := (SCREENWIDTH - 194) div 2;
      Top    := SCREENHEIGHT - 176;
      Height := 12;
      Width  := 194;
   end;
   //2004/05/17

   m_dwMoveTime := GetTickCount;
   m_dwAniTime := GetTickCount;
   m_nAniCount := 0;
   m_nMoveStepCount := 0;
   m_MainSoundTimer := TTimer.Create (FrmMain.Owner);
   with m_MainSoundTimer do begin
      OnTimer := SoundOnTimer;
      Interval := 1;
      Enabled := FALSE;
   end;
   {
   nx:=192;
   ny:=150;
   }
   nx := SCREENWIDTH div 2 - 210 {192}{192};
   ny := SCREENHEIGHT div 2 - 150{146}{150};
   {
   EdChgChrName := TEdit.Create (FrmMain.Owner);
   with EdChgChrName do begin
      Parent:=FrmMain;
      Height:=16;
      Width:=137;
      Left:=nx + 239;
      Top:=ny + 117;
      BorderStyle:=bsNone;
      Color:=clBlack;
      Font.Color:=clWhite;
      MaxLength:=10;
      Visible:=FALSE;
      //OnKeyPress:=EdNewIdKeyPress;
      //OnEnter:=EdNewOnEnter;
      Tag:=12;
   end;

   EdChgCurPwd := TEdit.Create (FrmMain.Owner);
   with EdChgCurPwd do begin
      Parent:=FrmMain;
      Height:=16;
      Width:=137;
      Left:=nx+239;
      Top:=ny+149;
      BorderStyle:=bsNone;
      Color:=clBlack;
      Font.Color:=clWhite;
      MaxLength:=10;
      PasswordChar:='*';
      Visible:=FALSE;
      //OnKeyPress:=EdNewIdKeyPress;
      //OnEnter:=EdNewOnEnter;
      Tag := 12;
   end;
   EdChgNewPwd := TEdit.Create (FrmMain.Owner);
   with EdChgNewPwd do begin
      Parent:=FrmMain;
      Height:=16;
      Width:=137;
      Left:=nx+239;
      Top:=ny+176;
      BorderStyle:=bsNone;
      Color:=clBlack;
      Font.Color:=clWhite;
      MaxLength:=10;
      PasswordChar:='*';
      Visible:=FALSE;
      //OnKeyPress:=EdNewIdKeyPress;
      //OnEnter:=EdNewOnEnter;
      Tag:=12;
   end;
   EdChgRePwd := TEdit.Create (FrmMain.Owner);
   with EdChgRePwd do begin
      Parent := FrmMain;
      Height := 16;
      Width  := 137;
      Left := nx+239;
      Top  := ny+208;
      BorderStyle := bsNone;
      Color := clBlack;
      Font.Color := clWhite;
      MaxLength := 10;
      PasswordChar := '*';
      Visible := FALSE;
      //OnKeyPress := EdNewIdKeyPress;
      //OnEnter := EdNewOnEnter;
      Tag := 12;
   end;
   }
end;

destructor TPlayScene.Destroy;
begin
   m_MsgList.Free;
   m_ActorList.Free;
   m_TempList.Free;
   m_GroundEffectList.Free;
   m_EffectList.Free;
   m_FlyList.Free;
   inherited Destroy;
end;
 //ÓÎÏ·Ö÷³¡¾°µÄ±³¾°ÒôÀÖ£¨³¤¶È£º43Ãë£©
procedure TPlayScene.SoundOnTimer (Sender: TObject);
begin
   PlaySound (s_main_theme);
   m_MainSoundTimer.Interval := 46 * 1000;
end;
 //ÁÄÌìÐÅÏ¢ÊäÈë
procedure TPlayScene.EdChatKeyPress (Sender: TObject; var Key: Char);
begin
   if Key = #13 then begin
      FrmMain.SendSay (EdChat.Text);
      EdChat.Text := '';
      EdChat.Visible := FALSE;
      Key := #0;
   end;
   if Key = #27 then begin
      EdChat.Text := '';
      EdChat.Visible := FALSE;
      Key := #0;
   end;
end;
 //³õÊ¼»¯³¡¾°
procedure TPlayScene.Initialize;
var
   i: integer;
begin
  //µØÍ¼
   m_MapSurface := TDirectDrawSurface.Create (frmMain.DxDraw.DDraw);
   m_MapSurface.SystemMemory := TRUE;
   m_MapSurface.SetSize (MAPSURFACEWIDTH+UNITX*4+30, MAPSURFACEHEIGHT+UNITY*4);
   //ÎïÆ·
   m_ObjSurface := TDirectDrawSurface.Create (frmMain.DxDraw.DDraw);
   m_ObjSurface.SystemMemory := TRUE;
   m_ObjSurface.SetSize (MAPSURFACEWIDTH-SOFFX*2, MAPSURFACEHEIGHT);
   //Îí
   m_nFogWidth := MAPSURFACEWIDTH - SOFFX * 2;
   m_nFogHeight := MAPSURFACEHEIGHT;
   m_PFogScreen := @m_FogScreen;
   //PFogScreen := AllocMem (FogWidth * FogHeight);
   ZeroMemory (m_PFogScreen, MAPSURFACEHEIGHT * MAPSURFACEWIDTH);

   g_boViewFog := FALSE;
   for i:=0 to MAXLIGHT do
      m_Lights[i].PFog := nil;
   LoadFog;

end;

procedure TPlayScene.Finalize;
begin
   if m_MapSurface <> nil then
      m_MapSurface.Free;
   if m_ObjSurface <> nil then
      m_ObjSurface.Free;
   m_MapSurface := nil;
   m_ObjSurface := nil;
end;
 //³¡¾°¿ªÊ¼
procedure TPlayScene.OpenScene;
begin
   g_WMainImages.ClearCache;  //·Î±×ÀÎ ÀÌ¹ÌÁö Ä³½Ã¸¦ Áö¿î´Ù.
   FrmDlg.ViewBottomBox (TRUE);
   //EdChat.Visible := TRUE;
   //EdChat.SetFocus;
   SetImeMode (FrmMain.Handle, LocalLanguage);
   //MainSoundTimer.Interval := 1000;
   //MainSoundTimer.Enabled := TRUE;
end;
 //¹Ø±Õ³¡¾°
procedure TPlayScene.CloseScene;
begin
   //MainSoundTimer.Enabled := FALSE;
   SilenceSound;

   EdChat.Visible := FALSE;
   FrmDlg.ViewBottomBox (FALSE);
end;

procedure TPlayScene.OpeningScene;
begin
end;
//Ë¢ÐÂ³¡¾°(ÓÎÏ·½ÇÉ«£©
procedure TPlayScene.RefreshScene;
var
   i: integer;
begin
   Map.m_OldClientRect.Left := -1;
   for i:=0 to m_ActorList.Count-1 do
      TActor (m_ActorList[i]).LoadSurface;
end;

procedure TPlayScene.CleanObjects;
var
   i: integer;
begin
   //É¾³ýËùÓÐ·Çµ±Ç°Íæ¼Ò½ÇÉ«
   for i := m_ActorList.Count-1 downto 0 do begin
      if TActor(m_ActorList[i]) <> g_MySelf then begin
         TActor(m_ActorList[i]).Free;
         m_ActorList.Delete (i);
      end;
   end;
   m_MsgList.Clear;
   g_TargetCret := nil;
   g_FocusCret := nil;
   g_MagicTarget := nil;
     //Çå³ýÄ§·¨Ð§¹û
   for i:=0 to m_GroundEffectList.Count-1 do
      TMagicEff (m_GroundEffectList[i]).Free;
   m_GroundEffectList.Clear;
   for i:=0 to m_EffectList.Count-1 do
      TMagicEff (m_EffectList[i]).Free;
   m_EffectList.Clear;
end;

{---------------------- Draw Map -----------------------}
 //»­µØÍ¼
procedure TPlayScene.DrawTileMap;
var
  i,j, nY,nX,nImgNumber:integer;
  DSurface: TDirectDrawSurface;
begin
  with Map do
    if (m_ClientRect.Left = m_OldClientRect.Left) and (m_ClientRect.Top = m_OldClientRect.Top) then exit;

  Map.m_OldClientRect := Map.m_ClientRect;
  m_MapSurface.Fill(0);

//µØÍ¼±³¾° »­µØÃæ
 if not g_boDrawTileMap then exit;
  with Map.m_ClientRect do begin
    nY := -UNITY * 2;
    for j:=(Top - Map.m_nBlockTop - 1) to (Bottom - Map.m_nBlockTop + 1) do begin
      nX := AAX + 14 -UNITX;
      for i:=(Left - Map.m_nBlockLeft -2) to (Right - Map.m_nBlockLeft + 1) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT *3) then begin
          nImgNumber := (Map.m_MArr[i, j].wBkImg and $7FFF);
          if nImgNumber > 0 then begin
            if (i mod 2 = 0) and (j mod 2 = 0) then begin
              nImgNumber := nImgNumber - 1;
              DSurface := g_WTilesImages.Images[nImgNumber];
              if Dsurface <> nil then begin
                //Jacky ÏÔÊ¾µØÍ¼ÄÚÈÝ
//                DrawLine(DSurface);
                m_MapSurface.Draw (nX, nY, DSurface.ClientRect, DSurface, FALSE);
              end;
             end;
           end;
         end;
         Inc (nX, UNITX);
       end;
       Inc (nY, UNITY);
    end;
  end;

//µØÍ¼ÖÐ¼ä²ã
   with Map.m_ClientRect do begin
      nY := -UNITY;
      for j:=(Top - Map.m_nBlockTop-1) to (Bottom - Map.m_nBlockTop+1) do begin
         nX := AAX + 14 -UNITX;
         for i:=(Left - Map.m_nBlockLeft-2) to (Right - Map.m_nBlockLeft+1) do begin
            if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
               nImgNumber := Map.m_MArr[i, j].wMidImg;
               if nImgNumber > 0 then begin
                  nImgNumber := nImgNumber - 1;
                  DSurface := g_WSmTilesImages.Images[nImgNumber];
                  if Dsurface <> nil then
                     m_MapSurface.Draw (nX, nY, DSurface.ClientRect, DSurface, TRUE);
               end;
            end;
            Inc (nX, UNITX);
         end;
         Inc (nY, UNITY);
      end;
   end;

end;



{----------------------- Æ÷±×, ¶óÀÌÆ® Ã³¸® -----------------------}


procedure TPlayScene.LoadFog;  //¶óÀÌÆ® µ¥ÀÌÅ¸ ÀÐ±â
var
   i, fhandle, w, h, prevsize: integer;
   cheat: Boolean;
begin
   prevsize := 0; //Á¶ÀÛ Ã¼Å©
   cheat := FALSE;
   for i:=0 to MAXLIGHT do begin
      if FileExists (LightFiles[i]) then begin
         fhandle := FileOpen (LightFiles[i], fmOpenRead or fmShareDenyNone);
         FileRead (fhandle, w, sizeof(integer));
         FileRead (fhandle, h, sizeof(integer));
         m_Lights[i].Width := w;
         m_Lights[i].Height := h;
         m_Lights[i].PFog := AllocMem  (w * h + 8);
         if prevsize < w * h then begin
            FileRead (fhandle, m_Lights[i].PFog^, w*h);
         end else
            cheat := TRUE;
         prevsize := w * h;
         FileClose (fhandle);
      end;
   end;
   if cheat then
      for i:=0 to MAXLIGHT do begin
         if m_Lights[i].PFog <> nil then
            FillChar (m_Lights[i].PFog^, m_Lights[i].Width*m_Lights[i].Height+8, #0);
      end;
end;

procedure TPlayScene.ClearDropItem;
var
  I:Integer;
  DropItem:pTDropItem;
begin
  for I := g_DropedItemList.Count - 1 downto 0 do begin
    DropItem:=g_DropedItemList.Items[I];
    if DropItem = nil then begin
      g_DropedItemList.Delete(I);
      Continue;
    end;
    if (abs(DropItem.x - g_MySelf.m_nCurrX) > 30) and (abs(DropItem.y - g_MySelf.m_nCurrY) > 30) then begin
{$IF DEBUG = 1}
      DScreen.AddChatBoardString (format('DropItem:%s X:%d Y:%d',[DropItem.Name,DropItem.X,DropItem.Y]),clWhite, clRed);
{$IFEND}
      Dispose(DropItem);
      g_DropedItemList.Delete(I);
    end;
  end;
end;

procedure TPlayScene.ClearLightMap;
var
   i, j: integer;
begin
   FillChar (m_LightMap, (LMX+1)*(LMY+1)*SizeOf(TLightMapInfo), 0);
   for i:=0 to LMX do
      for j:=0 to LMY do
         m_LightMap[i, j].Light := -1;
end;

procedure TPlayScene.UpdateBright (x, y, light: integer);
var
   i, j, r, lx, ly: integer;
   pmask: ^ShortInt;
begin
   pmask:=nil;//jacky
   r := -1;
   case light of
      0: begin r := 2; pmask := @LightMask0; end;
      1: begin r := 4; pmask := @LightMask1; end;
      2: begin r := 8; pmask := @LightMask2; end;
      3: begin r := 10; pmask := @LightMask3; end;
      4: begin r := 14; pmask := @LightMask4; end;
      5: begin r := 16; pmask := @LightMask5; end;
   end;
   for i:=0 to r do
      for j:=0 to r do begin
         lx := x-(r div 2)+i;
         ly := y-(r div 2)+j;
         if (lx in [0..LMX]) and (ly in [0..LMY]) then
            m_LightMap[lx, ly].bright := m_LightMap[lx, ly].bright + PShoftInt(integer(pmask) + (i*(r+1) + j) * sizeof(shortint))^;
      end;
end;

function  TPlayScene.CheckOverLight (x, y, light: integer): Boolean;
var
   i, j, r, mlight, lx, ly, count, check: integer;
   pmask: ^ShortInt;
begin
   pmask:=nil;//jacky
   check:=0;//jacky
   r := -1;
   case light of
      0: begin r := 2; pmask := @LightMask0; check := 0; end;
      1: begin r := 4; pmask := @LightMask1; check := 4; end;
      2: begin r := 8; pmask := @LightMask2; check := 8; end;
      3: begin r := 10; pmask := @LightMask3; check := 18; end;
      4: begin r := 14; pmask := @LightMask4; check := 30; end;
      5: begin r := 16; pmask := @LightMask5; check := 40; end;
   end;
   count := 0;
   for i:=0 to r do
      for j:=0 to r do begin
         lx := x-(r div 2)+i;
         ly := y-(r div 2)+j;
         if (lx in [0..LMX]) and (ly in [0..LMY]) then begin
            mlight := PShoftInt(integer(pmask) + (i*(r+1) + j) * sizeof(shortint))^;
            if m_LightMap[lx, ly].bright < mlight then begin
               inc (count, mlight - m_LightMap[lx, ly].bright);
               if count >= check then begin
                  Result := FALSE;
                  exit;
               end;
            end;
         end;
      end;
   Result := TRUE;
end;

procedure TPlayScene.AddLight (x, y, shiftx, shifty, light: integer; nocheck: Boolean);
var
   lx, ly: integer;
begin
   lx := x - g_MySelf.m_nRx + LMX div 2;
   ly := y - g_MySelf.m_nRy + LMY div 2;
   if (lx >= 1) and (lx < LMX) and (ly >= 1) and (ly < LMY) then begin
      if m_LightMap[lx, ly].light < light then begin
         if not CheckOverLight(lx, ly, light) or nocheck then begin // > LightMap[lx, ly].light then begin
            UpdateBright (lx, ly, light);
            m_LightMap[lx, ly].light := light;
            m_LightMap[lx, ly].Shiftx := shiftx;
            m_LightMap[lx, ly].Shifty := shifty;
         end;
      end;
   end;
end;

procedure TPlayScene.ApplyLightMap;
var
   i, j, light, defx, defy, lx, ly, lxx, lyy, lcount: integer;
begin
   defx := -UNITX*2 + AAX + 14 - g_MySelf.m_nShiftX;
   defy := -UNITY*3 - g_MySelf.m_nShiftY;
   lcount := 0;
   for i:=1 to LMX-1 do
      for j:=1 to LMY-1 do begin
         light := m_LightMap[i, j].light;
         if light >= 0 then begin
            lx := (i + g_MySelf.m_nRx - LMX div 2);
            ly := (j + g_MySelf.m_nRy - LMY div 2);
            lxx := (lx-Map.m_ClientRect.Left)*UNITX + defx + m_LightMap[i, j].ShiftX;
            lyy := (ly-Map.m_ClientRect.Top)*UNITY + defy + m_LightMap[i, j].ShiftY;

            FogCopy (m_Lights[light].PFog,
                     0,
                     0,
                     m_Lights[light].Width,
                     m_Lights[light].Height,
                     m_PFogScreen,
                     lxx - (m_Lights[light].Width-UNITX) div 2,
                     lyy - (m_Lights[light].Height-UNITY) div 2 - 5,
                     m_nFogWidth,
                     m_nFogHeight,
                     20);
            inc (lcount);
         end;
      end;
end;

procedure TPlayScene.DrawLightEffect (lx, ly, bright: integer);
begin
   if (bright > 0) and (bright <= MAXLIGHT) then
      FogCopy (m_Lights[bright].PFog,
               0,
               0,
               m_Lights[bright].Width,
               m_Lights[bright].Height,
               m_PFogScreen,
               lx - (m_Lights[bright].Width-UNITX) div 2,
               ly - (m_Lights[bright].Height-UNITY) div 2,
               m_nFogWidth,
               m_nFogHeight,
               15);
end;

{-----------------------------------------------------------------------}

procedure TPlayScene.DrawMiniMap (surface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  v: Boolean;
  mx, my,nx,ny, i: integer;
  rc: TRect;
  actor:TActor;
  x,y:integer;
  btColor:Byte;
begin
  if GetTickCount > m_dwBlinkTime + 300 then begin
    m_dwBlinkTime := GetTickCount;
    m_boViewBlink := not m_boViewBlink;
  end;
  if g_nMiniMapIndex < 0 then exit; //Jacky
  d := g_WMMapImages.Images[g_nMiniMapIndex];
  if d = nil then exit;
  mx := (g_MySelf.m_nCurrX*48) div 32;
  my := (g_MySelf.m_nCurrY*32) div 32;
  rc.Left := _MAX(0, mx-60);
  rc.Top := _MAX(0, my-60);
  rc.Right := _MIN(d.ClientRect.Right, rc.Left + 120);
  rc.Bottom := _MIN(d.ClientRect.Bottom, rc.Top + 120);

  if g_nViewMinMapLv = 1 then
    DrawBlendEx (surface, (SCREENWIDTH-120), 0, d, rc.Left, rc.Top, 120, 120, 0)
  else surface.Draw ((SCREENWIDTH-120), 0, rc, d, FALSE);
     //À×´ï
  if not m_boViewBlink then exit;
  mx := (SCREENWIDTH-120) + (g_MySelf.m_nCurrX * 48) div 32 - rc.Left;
  my := (g_MySelf.m_nCurrY * 32) div 32 - rc.Top;
  surface.Pixels[mx, my] := 255;

  for nx:=g_MySelf.m_nCurrX - 10  to g_MySelf.m_nCurrX + 10 do begin
    for ny:=g_MySelf.m_nCurrY - 10 to g_MySelf.m_nCurrY + 10 do begin
      actor := FindActorXY(nx,ny);
      if (actor <> nil) and (actor <> g_MySelf) and (not actor.m_boDeath) then begin
        mx := (SCREENWIDTH-120) + (actor.m_nCurrX * 48) div 32 - rc.Left;
        my := (actor.m_nCurrY * 32) div 32 - rc.Top;

        case actor.m_btRace of    //
          50,45,12: btColor:=218;
          0: btColor:=255;
          else btColor:=249;
        end;    // case
        for x:=0 to 1 do
          for y:=0 to 1 do
            surface.Pixels[mx+x, my+y] := btColor
      end;
    end;
  end;
end;


{-----------------------------------------------------------------------}


procedure TPlayScene.PlayScene (MSurface: TDirectDrawSurface);
   function  CheckOverlappedObject (myrc, obrc: TRect): Boolean;
   begin
      if (obrc.Right > myrc.Left) and (obrc.Left < myrc.Right) and
         (obrc.Bottom > myrc.Top) and (obrc.Top < myrc.Bottom) then
         Result := TRUE
      else Result := FALSE;
   end;

var
   i, j, k, n, m, mmm, ix, iy, line, defx, defy, wunit, fridx, ani, anitick, ax, ay, idx, drawingbottomline: integer;
   DSurface, d: TDirectDrawSurface;
   blend, movetick: Boolean;
   //myrc, obrc: TRect;
   DropItem: PTDropItem;
   evn: TClEvent;
   actor: TActor;
   meff: TMagicEff;
   msgstr: string;
  ShowItem:pTShowItem;
  nFColor,nBColor:Integer;
begin
   drawingbottomline:=0;//jacky
   if (g_MySelf = nil) then begin
      msgstr := 'ÕýÔÚ·µ»ØÈËÎïÑ¡Ôñ,ÇëµÈ´ý...';
      with MSurface.Canvas do begin
         SetBkMode (Handle, TRANSPARENT);
         BoldTextOut (MSurface, (SCREENWIDTH-TextWidth(msgstr)) div 2, (SCREENHEIGHT - 600) +200,
                      clWhite, clBlack, msgstr);
         Release;
      end;
      exit;
   end;

   g_boDoFastFadeOut := FALSE;

   //Ä³¸¯ÅÍ¿¡µé¿¡°Ô ¸Þ¼¼Áö¸¦ Àü´Þ
   movetick := FALSE;
   if GetTickCount - m_dwMoveTime >= 100 then begin
      m_dwMoveTime := GetTickCount;   //ÀÌµ¿ÀÇ µ¿±âÈ­
      movetick := TRUE;          //ÀÌµ¿ Æ½
      Inc (m_nMoveStepCount);
      if m_nMoveStepCount > 1 then m_nMoveStepCount := 0;
   end;
   if GetTickCount - m_dwAniTime >= 50 then begin
      m_dwAniTime := GetTickCount;
      Inc (m_nAniCount);
      if m_nAniCount > 100000 then m_nAniCount := 0;
   end;

   try
   i := 0;                          //¿©±â´Â ¸Þ¼¼Áö¸¸ Ã³¸®ÇÔ
   while TRUE do begin              //Frame Ã³¸®´Â ¿©±â¼­ ¾ÈÇÔ.
      if i >= m_ActorList.Count then break;
      actor := m_ActorList[i];
      if movetick then actor.m_boLockEndFrame := FALSE;
      if not actor.m_boLockEndFrame then begin
         actor.ProcMsg;   //¸Þ¼¼Áö Ã³¸®ÇÏ¸é¼­ actor°¡ Áö¿öÁú ¼ö ÀÖÀ½.
         if movetick then
            if actor.Move(m_nMoveStepCount) then begin  //µ¿±âÈ­ÇØ¼­ ¿òÁ÷ÀÓ
               Inc (i);
               continue;
            end;
         actor.Run;    //
         if actor <> g_MySelf then actor.ProcHurryMsg;
      end;
      if actor = g_MySelf then actor.ProcHurryMsg;
      //
      if actor.m_nWaitForRecogId <> 0 then begin
         if actor.IsIdle then begin
            DelChangeFace (actor.m_nWaitForRecogId);
            NewActor (actor.m_nWaitForRecogId, actor.m_nCurrX, actor.m_nCurrY, actor.m_btDir, actor.m_nWaitForFeature, actor.m_nWaitForStatus);
            actor.m_nWaitForRecogId := 0;
            actor.m_boDelActor := TRUE;
         end;
      end;
      if actor.m_boDelActor then begin
         //actor.Free;
         g_FreeActorList.Add (actor);
         m_ActorList.Delete (i);
         if g_TargetCret = actor then g_TargetCret := nil;
         if g_FocusCret = actor then g_FocusCret := nil;
         if g_MagicTarget = actor then g_MagicTarget := nil;
      end else
         Inc (i);
   end;
   except
      DebugOutStr ('101');
   end;

   try
   i := 0;
   while TRUE do begin
      if i >= m_GroundEffectList.Count then break;
      meff := m_GroundEffectList[i];
      if meff.m_boActive then begin
         if not meff.Run then begin //¸¶¹ýÈ¿°ú
            meff.Free;
            m_GroundEffectList.Delete (i);
            continue;
         end;
      end;
      Inc (i);
   end;
   i := 0;
   while TRUE do begin
      if i >= m_EffectList.Count then break;
      meff := m_EffectList[i];
      if meff.m_boActive then begin
         if not meff.Run then begin //¸¶¹ýÈ¿°ú
            meff.Free;
            m_EffectList.Delete (i);
            continue;
         end;
      end;
      Inc (i);
   end;
   i := 0;
   while TRUE do begin
      if i >= m_FlyList.Count then break;
      meff := m_FlyList[i];
      if meff.m_boActive then begin
         if not meff.Run then begin //µµ³¢,È­»ìµî ³¯¾Æ°¡´Â°Í
            meff.Free;
            m_FlyList.Delete (i);
            continue;
         end;
      end;
      Inc (i);
   end;
   
   EventMan.Execute;
   except
      DebugOutStr ('102');
   end;

   try
   ClearDropItem();
   {
   //Çå³ý³¬¹ýÏÔÊ¾·¶Î§µÄÎïÆ·Êý¾Ý
   for k:=0 to g_DropedItemList.Count - 1 do begin
     DropItem:= PTDropItem(g_DropedItemList[k]);
     if DropItem <> nil then begin
       if (Abs(DropItem.x - Myself.m_nCurrX) > 30) and (Abs(DropItem.y - Myself.m_nCurrY) > 30) then begin
         Dispose (PTDropItem (g_DropedItemList[k]));
         g_DropedItemList.Delete (k);
         break;  //ÇÑ¹ø¿¡ ÇÑ°³¾¿..
       end;
     end;
   end;
   }
   //»ç¶óÁø ´ÙÀÌ³ª¹Í¿ÀºêÁ§Æ® °Ë»ç
   for k:=0 to EventMan.EventList.Count-1 do begin
      evn := TClEvent (EventMan.EventList[k]);
      if (Abs(evn.m_nX-g_MySelf.m_nCurrX) > 30) and (Abs(evn.m_nY-g_MySelf.m_nCurrY) > 30) then begin
         evn.Free;
         EventMan.EventList.Delete (k);
         break;  //ÇÑ¹ø¿¡ ÇÑ°³¾¿
      end;
   end;
   except
      DebugOutStr ('103');
   end;

   try
   with Map.m_ClientRect do begin
{$IF SWH = SWH800}
      Left   := g_MySelf.m_nRx - 9;
      Top    := g_MySelf.m_nRy - 9;
      Right  := g_MySelf.m_nRx + 9;                         // ¿À¸¥ÂÊ Â¥Åõ¸® ±×¸²
      Bottom := g_MySelf.m_nRy + 8;
{$ELSEIF SWH = SWH1024}
      Left   := g_MySelf.m_nRx - 12;
      Top    := g_MySelf.m_nRy - 12;
      Right  := g_MySelf.m_nRx + 12;                         //
      Bottom := g_MySelf.m_nRy + 15;
{$IFEND}
   end;
   Map.UpdateMapPos (g_MySelf.m_nRx, g_MySelf.m_nRy);

   ///////////////////////
   //ViewFog := FALSE;
   ///////////////////////

   if g_boNoDarkness or (g_MySelf.m_boDeath) then begin
      g_boViewFog := FALSE;
   end;

   if g_boViewFog then begin //Æ÷±×
      ZeroMemory (m_PFogScreen, MAPSURFACEHEIGHT * MAPSURFACEWIDTH);
      ClearLightMap;
   end;

//   drawingbottomline := 450;
   drawingbottomline := SCREENHEIGHT;
   m_ObjSurface.Fill(0);

   DrawTileMap;

   m_ObjSurface.Draw (0, 0,
                    Rect(UNITX*3 + g_MySelf.m_nShiftX,
                         UNITY*2 + g_MySelf.m_nShiftY,
                         UNITX*3 + g_MySelf.m_nShiftX + MAPSURFACEWIDTH,
                         UNITY*2 + g_MySelf.m_nShiftY + MAPSURFACEHEIGHT),
                    m_MapSurface,
                    FALSE);

   except
      DebugOutStr ('104');
   end;

   defx := -UNITX*2 - g_MySelf.m_nShiftX + AAX + 14;
   defy := -UNITY*2 - g_MySelf.m_nShiftY;
   m_nDefXX := defx;
   m_nDefYY := defy;

   try
   m := defy - UNITY;
   for j:=(Map.m_ClientRect.Top - Map.m_nBlockTop) to (Map.m_ClientRect.Bottom - Map.m_nBlockTop + LONGHEIGHT_IMAGE) do begin
      if j < 0 then begin Inc (m, UNITY); continue; end;
      n := defx-UNITX*2;
      //*** 48*32 
      for i:=(Map.m_ClientRect.Left - Map.m_nBlockLeft-2) to (Map.m_ClientRect.Right - Map.m_nBlockLeft+2) do begin
         if (i >= 0) and (i < LOGICALMAPUNIT*3) and (j >= 0) and (j < LOGICALMAPUNIT*3) then begin
            fridx := (Map.m_MArr[i, j].wFrImg) and $7FFF;
            if fridx > 0 then begin
               ani := Map.m_MArr[i, j].btAniFrame;
               wunit := Map.m_MArr[i, j].btArea;
               if (ani and $80) > 0 then begin
                  blend := TRUE;
                  ani := ani and $7F;
               end;
               if ani > 0 then begin
                  anitick := Map.m_MArr[i, j].btAniTick;
                  fridx := fridx + (m_nAniCount mod (ani + (ani*anitick))) div (1+anitick);
               end;
               if (Map.m_MArr[i, j].btDoorOffset and $80) > 0 then begin //¿­¸²
                  if (Map.m_MArr[i, j].btDoorIndex and $7F) > 0 then  //¹®À¸·Î Ç¥½ÃµÈ °Í¸¸
                     fridx := fridx + (Map.m_MArr[i, j].btDoorOffset and $7F); //¿­¸° ¹®
               end;
               fridx := fridx - 1;
               // ¹°Ã¼ ±×¸²
               DSurface := GetObjs (wunit, fridx);
               if DSurface <> nil then begin
                  if (DSurface.Width = 48) and (DSurface.Height = 32) then begin
                     mmm := m + UNITY - DSurface.Height;
                     if (n+DSurface.Width > 0) and (n <= SCREENWIDTH) and (mmm + DSurface.Height > 0) and (mmm < drawingbottomline) then begin
                        m_ObjSurface.Draw (n, mmm, DSurface.ClientRect, Dsurface, TRUE)
                     end else begin
                        if mmm < drawingbottomline then begin //ºÒÇÊ¿äÇÏ°Ô ±×¸®´Â °ÍÀ» ÇÇÇÔ
                           m_ObjSurface.Draw (n, mmm, DSurface.ClientRect, DSurface, TRUE)
                        end;
                     end;
                  end;
               end;
            end;
         end;
         Inc (n, UNITX);
      end;
      Inc (m, UNITY);
   end;

   //¶¥¹Ù´Ú¿¡ ±×·ÁÁö´Â ¸¶¹ý
   for k:=0 to m_GroundEffectList.Count-1 do begin
      meff := TMagicEff(m_GroundEffectList[k]);
      //if j = (meff.Ry - Map.BlockTop) then begin
      meff.DrawEff (m_ObjSurface);
      if g_boViewFog then begin
         AddLight (meff.Rx, meff.Ry, 0, 0, meff.light, FALSE);
      end;
   end;

   except
      DebugOutStr ('105');
   end;  

   try
   m := defy - UNITY;
   for j:=(Map.m_ClientRect.Top - Map.m_nBlockTop) to (Map.m_ClientRect.Bottom - Map.m_nBlockTop + LONGHEIGHT_IMAGE) do begin
      if j < 0 then begin Inc (m, UNITY); continue; end;
      n := defx-UNITX*2;
      //*** ¹è°æ¿ÀºêÁ§Æ® ±×¸®±â
      for i:=(Map.m_ClientRect.Left - Map.m_nBlockLeft-2) to (Map.m_ClientRect.Right - Map.m_nBlockLeft+2) do begin
         if (i >= 0) and (i < LOGICALMAPUNIT*3) and (j >= 0) and (j < LOGICALMAPUNIT*3) then begin
            fridx := (Map.m_MArr[i, j].wFrImg) and $7FFF;
            if fridx > 0 then begin
               blend := FALSE;
               wunit := Map.m_MArr[i, j].btArea;
               //¿¡´Ï¸ÞÀÌ¼Ç
               ani := Map.m_MArr[i, j].btAniFrame;
               if (ani and $80) > 0 then begin
                  blend := TRUE;
                  ani := ani and $7F;
               end;
               if ani > 0 then begin
                  anitick := Map.m_MArr[i, j].btAniTick;
                  fridx := fridx + (m_nAniCount mod (ani + (ani*anitick))) div (1+anitick);
               end;
               if (Map.m_MArr[i, j].btDoorOffset and $80) > 0 then begin //¿­¸²
                  if (Map.m_MArr[i, j].btDoorIndex and $7F) > 0 then  //¹®À¸·Î Ç¥½ÃµÈ °Í¸¸
                     fridx := fridx + (Map.m_MArr[i, j].btDoorOffset and $7F); //¿­¸° ¹®
               end;
               fridx := fridx - 1;
               // ¹°Ã¼ ±×¸²
               if not blend then begin
                  DSurface := GetObjs (wunit, fridx);
                  if DSurface <> nil then begin
                     if (DSurface.Width <> 48) or (DSurface.Height <> 32) then begin
                        mmm := m + UNITY - DSurface.Height;
                        if (n+DSurface.Width > 0) and (n <= SCREENWIDTH) and (mmm + DSurface.Height > 0) and (mmm < drawingbottomline) then begin
                           m_ObjSurface.Draw (n, mmm, DSurface.ClientRect, Dsurface, TRUE)
                        end else begin
                           if mmm < drawingbottomline then begin //ºÒÇÊ¿äÇÏ°Ô ±×¸®´Â °ÍÀ» ÇÇÇÔ
                              m_ObjSurface.Draw (n, mmm, DSurface.ClientRect, DSurface, TRUE)
                           end;
                        end;
                     end;
                  end;
               end else begin
                  DSurface := GetObjsEx (wunit, fridx, ax, ay);
                  if DSurface <> nil then begin
                     mmm := m + ay - 68; //UNITY - DSurface.Height;
                     if (n > 0) and (mmm + DSurface.Height > 0) and (n + Dsurface.Width < SCREENWIDTH) and (mmm < drawingbottomline) then begin
                        DrawBlend (m_ObjSurface, n+ax-2, mmm, DSurface, 1);
                     end else begin
                        if mmm < drawingbottomline then begin //ºÒÇÊ¿äÇÏ°Ô ±×¸®´Â °ÍÀ» ÇÇÇÔ
                           DrawBlend (m_ObjSurface, n+ax-2, mmm, DSurface, 1);
                        end;
                     end;
                  end;
               end;
            end;

         end;
         Inc (n, UNITX);
      end;

      if (j <= (Map.m_ClientRect.Bottom - Map.m_nBlockTop)) and (not g_boServerChanging) then begin

         //*** ¹Ù´Ú¿¡ º¯°æµÈ ÈëÀÇ ÈçÀû
         for k:=0 to EventMan.EventList.Count-1 do begin
            evn := TClEvent (EventMan.EventList[k]);
            if j = (evn.m_nY - Map.m_nBlockTop) then begin
               evn.DrawEvent (m_ObjSurface,
                              (evn.m_nX-Map.m_ClientRect.Left)*UNITX + defx,
                              m);
            end;
         end;

         if g_boDrawDropItem then begin

         //ÏÔÊ¾µØÃæÎïÆ·ÍâÐÎ
         for k:=0 to g_DropedItemList.Count-1 do begin
            DropItem := PTDropItem (g_DropedItemList[k]);
            if DropItem <> nil then begin
               if j = (DropItem.y - Map.m_nBlockTop) then begin
                  d := g_WDnItemImages.Images[DropItem.Looks];
                  if d <> nil then begin
                     ix := (DropItem.x-Map.m_ClientRect.Left) * UNITX + defx + SOFFX; // + actor.ShiftX;
                     iy := m; // + actor.ShiftY;
                     if DropItem = g_FocusItem then begin
                        g_ImgMixSurface.Draw (0, 0, d.ClientRect, d, FALSE);
                        DrawEffect (0, 0, d.Width, d.Height, g_ImgMixSurface, ceBright);
                        m_ObjSurface.Draw (ix + HALFX-(d.Width div 2),
                                      iy + HALFY-(d.Height div 2),
                                      d.ClientRect,
                                      g_ImgMixSurface, TRUE);
                     end else begin
                        m_ObjSurface.Draw (ix + HALFX-(d.Width div 2),
                                      iy + HALFY-(d.Height div 2),
                                      d.ClientRect,
                                      d, TRUE);
                     end;

                  end;
               end;
            end;
         end;
         end;
         
         //*** ÏÔÊ¾ÈËÎïËµ»°ÐÅÏ¢
         for k:=0 to m_ActorList.Count-1 do begin
            actor := m_ActorList[k];
            if (j = actor.m_nRy-Map.m_nBlockTop-actor.m_nDownDrawLevel) then begin
               actor.m_nSayX := (actor.m_nRx-Map.m_ClientRect.Left)*UNITX + defx + actor.m_nShiftX + 24;
               if actor.m_boDeath then
                  actor.m_nSayY := m + UNITY + actor.m_nShiftY + 16 - 60  + (actor.m_nDownDrawLevel * UNITY)
               else actor.m_nSayY := m + UNITY + actor.m_nShiftY + 16 - 95  + (actor.m_nDownDrawLevel * UNITY);
               actor.DrawChr (m_ObjSurface, (actor.m_nRx-Map.m_ClientRect.Left)*UNITX + defx,
                                           m + (actor.m_nDownDrawLevel * UNITY),
                                           FALSE,True);
            end;
         end;
         for k:=0 to m_FlyList.Count-1 do begin
            meff := TMagicEff(m_FlyList[k]);
            if j = (meff.Ry - Map.m_nBlockTop) then
               meff.DrawEff (m_ObjSurface);
         end;

      end;
      Inc (m, UNITY);
   end;
   except
      DebugOutStr ('106');
   end;


   try
   if g_boViewFog then begin
      m := defy - UNITY*4;
      for j:=(Map.m_ClientRect.Top - Map.m_nBlockTop - 4) to (Map.m_ClientRect.Bottom - Map.m_nBlockTop + LONGHEIGHT_IMAGE) do begin
         if j < 0 then begin Inc (m, UNITY); continue; end;
         n := defx-UNITX*5;
         //¹è°æ Æ÷±× ±×¸®±â
         for i:=(Map.m_ClientRect.Left - Map.m_nBlockLeft-5) to (Map.m_ClientRect.Right - Map.m_nBlockLeft+5) do begin
            if (i >= 0) and (i < LOGICALMAPUNIT*3) and (j >= 0) and (j < LOGICALMAPUNIT*3) then begin
               idx := Map.m_MArr[i, j].btLight;
               if idx > 0 then begin
                  AddLight (i+Map.m_nBlockLeft, j+Map.m_nBlockTop, 0, 0, idx, FALSE);
               end;
            end;
            Inc (n, UNITX);
         end;
         Inc (m, UNITY);
      end;

      //Ä³¸¯ÅÍ Æ÷±× ±×¸®±â
      if m_ActorList.Count > 0 then begin
         for k:=0 to m_ActorList.Count-1 do begin
            actor := m_ActorList[k];
            if (actor = g_MySelf) or (actor.Light > 0) then
               AddLight (actor.m_nRx, actor.m_nRy, actor.m_nShiftX, actor.m_nShiftY, actor.Light, actor=g_MySelf);
         end;
      end else begin
         if g_MySelf <> nil then
            AddLight (g_MySelf.m_nRx, g_MySelf.m_nRy, g_MySelf.m_nShiftX, g_MySelf.m_nShiftY, g_MySelf.Light, TRUE);
      end;
   end;
   except
      DebugOutStr ('107');
   end;

   if not g_boServerChanging then begin
      try
      //**** ÁÖÀÎ°ø Ä³¸¯ÅÍ ±×¸®±â
      if not g_boCheckBadMapMode then
         if g_MySelf.m_nState and $00800000 = 0 then //Åõ¸íÀÌ ¾Æ´Ï¸é
            g_MySelf.DrawChr (m_ObjSurface, (g_MySelf.m_nRx-Map.m_ClientRect.Left)*UNITX+defx, (g_MySelf.m_nRy - Map.m_ClientRect.Top-1)*UNITY+defy, TRUE,FALSE);

      //****
      if (g_FocusCret <> nil) then begin
         if IsValidActor (g_FocusCret) and (g_FocusCret <> g_MySelf) then
//            if (actor.m_btRace <> 81) or (FocusCret.State and $00800000 = 0) then //Jacky
            if (g_FocusCret.m_nState and $00800000 = 0) then //Jacky
               g_FocusCret.DrawChr (m_ObjSurface,
                           (g_FocusCret.m_nRx - Map.m_ClientRect.Left)*UNITX+defx,
                           (g_FocusCret.m_nRy - Map.m_ClientRect.Top-1)*UNITY+defy, TRUE,FALSE);
      end;
      if (g_MagicTarget <> nil) then begin
         if IsValidActor (g_MagicTarget) and (g_MagicTarget <> g_MySelf) then
            if g_MagicTarget.m_nState and $00800000 = 0 then //Åõ¸íÀÌ ¾Æ´Ï¸é
               g_MagicTarget.DrawChr (m_ObjSurface,
                           (g_MagicTarget.m_nRx-Map.m_ClientRect.Left)*UNITX+defx,
                           (g_MagicTarget.m_nRy - Map.m_ClientRect.Top-1)*UNITY+defy, TRUE,FALSE);
      end;
      except
         DebugOutStr ('108');
      end;
   end;
   
   try
   //**** ¸¶¹ý È¿°ú

   for k:=0 to m_ActorList.Count-1 do begin
      actor := m_ActorList[k];
      actor.DrawEff (m_ObjSurface,
                     (actor.m_nRx-Map.m_ClientRect.Left)*UNITX + defx,
                     (actor.m_nRy-Map.m_ClientRect.Top-1)*UNITY + defy);
   end;
   
   for k:=0 to m_EffectList.Count-1 do begin
      meff := TMagicEff(m_EffectList[k]);
      //if j = (meff.Ry - Map.BlockTop) then begin
      meff.DrawEff (m_ObjSurface);
      if g_boViewFog then begin
         AddLight (meff.Rx, meff.Ry, 0, 0, meff.Light, FALSE);
      end;
   end;
   if g_boViewFog then begin
      for k:=0 to EventMan.EventList.Count-1 do begin
         evn := TClEvent (EventMan.EventList[k]);
         if evn.m_nLight > 0 then
            AddLight (evn.m_nX, evn.m_nY, 0, 0, evn.m_nLight, FALSE);
      end;
   end;
   except
      DebugOutStr ('109');
   end;

   //µØÃæÎïÆ·ÉÁÁÁ
  try
    for k:=0 to g_DropedItemList.Count-1 do begin
      DropItem := PTDropItem (g_DropedItemList[k]);
      if DropItem <> nil then begin
        if GetTickCount - DropItem.FlashTime > g_dwDropItemFlashTime{5 * 1000} then begin
          DropItem.FlashTime := GetTickCount;
          DropItem.BoFlash := TRUE;
          DropItem.FlashStepTime := GetTickCount;
          DropItem.FlashStep := 0;
        end;
        ix:=(DropItem.x - Map.m_ClientRect.Left) * UNITX + defx + SOFFX;
        iy:=(DropItem.y - Map.m_ClientRect.Top - 1) * UNITY + defy + SOFFY;
        if DropItem.BoFlash then begin
          if GetTickCount - DropItem.FlashStepTime >= 20 then begin
            DropItem.FlashStepTime := GetTickCount;
            Inc (DropItem.FlashStep);
          end;
          if (DropItem.FlashStep >= 0) and (DropItem.FlashStep < 10) then begin
            DSurface := g_WMainImages.GetCachedImage (FLASHBASE + DropItem.FlashStep, ax, ay);
            DrawBlend (m_ObjSurface, ix + ax, iy + ay, DSurface, 1);
          end else DropItem.BoFlash := FALSE;
        end;
        ShowItem:=GetShowItem(DropItem.Name);
        if (DropItem <> g_FocusItem) and (((ShowItem <> nil) and (ShowItem.boShowName)) or g_boShowAllItem) then begin
             //ÏÔÊ¾µØÃæÎïÆ·Ãû³Æ
          if ShowItem <> nil then begin
            nFColor:=ShowItem.nFColor;
            nBColor:=ShowItem.nBColor;
          end else begin
            nFColor:=clWhite;
            nBColor:=clBlack;
          end;
            
          with m_ObjSurface.Canvas do begin
            SetBkMode (Handle, TRANSPARENT);
            BoldTextOut(m_ObjSurface,
                         ix + HALFX - TextWidth(DropItem.Name) div 2,
                         iy + HALFY - TextHeight(DropItem.Name) * 2,// div 2,
                         nFColor,
                         nBColor,
                         DropItem.Name);
            Release;
          end;
        end;
      end;
    end;
  except
    DebugOutStr('110');
  end;
   try

   //g_boViewFog:=False;      //Jacky ÃâÀ¯ Ð§¹û. ÊÇ·ñÃâÀ¯Öò£¨¼´ÊÇ·ñ²é¿´Îí£©£¬g_boViewFog = FalseÃâÀ¯Öò , g_boViewFog = TrueÒªÀ¯Öò ,Modified By Davy  2019-11-17

   if  g_boViewFog and not g_boForceNotViewFog  then begin
      ApplyLightMap;
      DrawFog (m_ObjSurface, m_PFogScreen, m_nFogWidth);
      MSurface.Draw (SOFFX, SOFFY, m_ObjSurface.ClientRect, m_ObjSurface, FALSE);
   end else begin
      if g_MySelf.m_boDeath then //ÈËÎïËÀÍö£¬ÏÔÊ¾ºÚ°×»­Ãæ
         DrawEffect (0, 0, m_ObjSurface.Width, m_ObjSurface.Height, m_ObjSurface, g_DeathColorEffect{ceGrayScale});


      MSurface.Draw (SOFFX, SOFFY, m_ObjSurface.ClientRect, m_ObjSurface, FALSE);
   end;
   except
      DebugOutStr ('111');
   end;

   if g_boViewMiniMap then begin
      DrawMiniMap (MSurface);
   end;


end;

{-------------------------------------------------------}

//cx, cy, tx, ty : ¸ÊÀÇ ÁÂÇ¥
procedure TPlayScene.NewMagic (aowner: TActor;
                               magid, magnumb{Effect}, cx, cy, tx, ty, targetcode: integer;
                               mtype: TMagicType; //EffectType
                               Recusion: Boolean;
                               anitime: integer;
                               var bofly: Boolean);
var
   i, scx, scy, sctx, scty, effnum: integer;
   meff: TMagicEff;
   target: TActor;
   wimg: TWMImages;
begin
   bofly := FALSE;
   if magid <> 111 then //
      for i:=0 to m_EffectList.Count-1 do
         if TMagicEff(m_EffectList[i]).ServerMagicId = magid then
            exit; //
   ScreenXYfromMCXY (cx, cy, scx, scy);
   ScreenXYfromMCXY (tx, ty, sctx, scty);
   if magnumb > 0 then GetEffectBase (magnumb-1, 0, wimg, effnum)  //magnumb{Effect}
   else effnum := -magnumb;
   target := FindActor (targetcode);

   meff := nil;
   case mtype of  //EffectType
      mtReady, mtFly, mtFlyAxe: begin
        meff := TMagicEff.Create (magid{ÌæÎªmagnumb£¬»÷ÖÐºóµÄÐ§¹û¸Ä±äÁË}, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
        meff.TargetActor := target;
        if magnumb = 39 then begin
          meff.frame := 4;
          if wimg <> nil then
            meff.ImgLib:=wimg;
        end;
        bofly := TRUE;
      end;
      mtExplosion:
        case magnumb of
          18: begin //ÓÕ»óÖ®¹â
            meff := TMagicEff.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 1570;
            meff.TargetActor := target;
            meff.NextFrameTime := 80;
          end;
          21: begin //±¬ÁÑ»ðÑæ
            meff := TMagicEff.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 1660;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 20;
            meff.Light := 3;
          end;
          26: begin //ÐÄÁéÆôÊ¾
            meff := TMagicEff.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 3990;
            meff.TargetActor := target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 10;
            meff.Light := 2;
          end;
          27: begin //ÈºÌåÖÎÁÆÊõ
            meff := TMagicEff.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 1800;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 10;
            meff.Light := 3;
          end;
          30: begin //Ê¥ÑÔÊõ
            meff := TMagicEff.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 3930;
            meff.TargetActor := target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 16;
            meff.Light := 3;
          end;
          31: begin //±ùÅØÏø
            meff := TMagicEff.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 3850;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 20;
            meff.Light := 3;
          end;
          34: begin //ÃðÌì»ð
            meff := TMagicEff.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 140;
            meff.TargetActor := target; //target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 20;
            meff.Light := 3;
            if wimg <> nil then
              meff.ImgLib:=wimg;
          end;
          40: begin // ¾»»¯Êõ
            meff := TMagicEff.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 620;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 100;
            meff.ExplosionFrame := 20;
            meff.Light := 3;
            if wimg <> nil then
              meff.ImgLib:=wimg;
          end;
          45: begin //»ðÁúÆøÑæ
            meff := TMagicEff.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 920;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 100;
            meff.ExplosionFrame := 20;
            meff.Light := 3;
            if wimg <> nil then
              meff.ImgLib:=wimg;
          end;
          47: begin //ì«·çÆÆ
            meff := TMagicEff.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 1010;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 100;
            meff.ExplosionFrame := 20;
            meff.Light := 3;
            if wimg <> nil then
              meff.ImgLib:=wimg;
          end;
          48: begin //ÑªÖä
            meff := TMagicEff.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 1060;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 50;
            meff.ExplosionFrame := 40;
            meff.Light := 3;
            if wimg <> nil then
              meff.ImgLib:=wimg;
          end;
          49: begin //÷¼÷ÃÖä
            meff := TMagicEff.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.MagExplosionBase := 1110;
            meff.TargetActor := nil; //target;
            meff.NextFrameTime := 100;
            meff.ExplosionFrame := 10;
            meff.Light := 3;
            if wimg <> nil then
              meff.ImgLib:=wimg;
          end;
          else begin //Ä¬ÈÏ
            meff := TMagicEff.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.TargetActor := target;
            meff.NextFrameTime := 80;
         end;
      end;
      mtFireWind:
         meff := nil;  //È¿°ú ¾øÀ½
      mtFireGun: //È­¿°¹æ»ç
         meff := TFireGunEffect.Create (930, scx, scy, sctx, scty);
      mtThunder: begin
        //meff := TThuderEffect.Create (950, sctx, scty, nil); //target);
        meff := TThuderEffect.Create (10, sctx, scty, nil); //target);
        meff.ExplosionFrame := 6;
        meff.ImgLib := g_WMagic2Images;
      end;
      mtLightingThunder:
         meff := TLightingThunder.Create (970, scx, scy, sctx, scty, target);
      mtExploBujauk: begin
        case magnumb of
          10: begin  //
            meff := TExploBujaukEffect.Create (1160, scx, scy, sctx, scty, target);
            meff.MagExplosionBase := 1360;
          end;
          17: begin  //
            meff := TExploBujaukEffect.Create (1160, scx, scy, sctx, scty, target);
            meff.MagExplosionBase := 1540;
          end;
        end;
        bofly := TRUE;
      end;
      mtBujaukGroundEffect: begin
        meff := TBujaukGroundEffect.Create (1160, magnumb, scx, scy, sctx, scty);
        case magnumb of
          11: meff.ExplosionFrame := 16; //
          12: meff.ExplosionFrame := 16; //
          46: meff.ExplosionFrame := 24;
        end;
        bofly := TRUE;
      end;
      mtKyulKai: begin
        meff := nil; //TKyulKai.Create (1380, scx, scy, sctx, scty);
      end;
      mt12: begin

      end;

  {*
      mt13: begin
        meff := TMagicEff.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
        if meff <> nil then begin
          case magnumb of
            32: begin
              meff.ImgLib := FrmMain.WMon21Img;
              meff.MagExplosionBase:=3580;
              meff.TargetActor := target;
              meff.Light := 3;
              meff.NextFrameTime := 20;
            end;
            37: begin
              meff.ImgLib := FrmMain.WMon22Img;
              meff.MagExplosionBase:=3520;
              meff.TargetActor := target;
              meff.Light := 5;
              meff.NextFrameTime := 20;
            end;
          end;
        end;
      end;
 *}

      mt14: begin
        meff := TThuderEffect.Create (140, sctx, scty, nil); //target);
        meff.ExplosionFrame := 10;
        meff.ImgLib := g_WMagic2Images;
      end;
      mt15: begin
        meff := TFlyingBug.Create (magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
        meff.TargetActor := target;
        bofly:=True;
      end;
      mt16: begin

      end;
   end;
   if (meff = nil) then exit;


   meff.TargetRx := tx;
   meff.TargetRy := ty;
   if meff.TargetActor <> nil then begin
      meff.TargetRx := TActor(meff.TargetActor).m_nCurrX;
      meff.TargetRy := TActor(meff.TargetActor).m_nCurrY;
   end;
   meff.MagOwner := aowner;
   m_EffectList.Add (meff);
end;

procedure TPlayScene.DelMagic (magid: integer);
var
   i: integer;
begin
   for i:=0 to m_EffectList.Count-1 do begin
      if TMagicEff(m_EffectList[i]).ServerMagicId = magid then begin
         TMagicEff(m_EffectList[i]).Free;
         m_EffectList.Delete (i);
         break;
      end;
   end;
end;

//cx, cy, tx, ty : ¸ÊÀÇ ÁÂÇ¥
function  TPlayScene.NewFlyObject (aowner: TActor; cx, cy, tx, ty, targetcode: integer;  mtype: TMagicType): TMagicEff;
var
   i, scx, scy, sctx, scty: integer;
   meff: TMagicEff;
begin
   ScreenXYfromMCXY (cx, cy, scx, scy);
   ScreenXYfromMCXY (tx, ty, sctx, scty);
   case mtype of
      mtFlyArrow: meff := TFlyingArrow.Create (1, 1, scx, scy, sctx, scty, mtype, TRUE, 0);
      mt12: meff := TFlyingFireBall.Create (1, 1, scx, scy, sctx, scty, mtype, TRUE, 0);
      mt15: meff := TFlyingBug.Create (1, 1, scx, scy, sctx, scty, mtype, TRUE, 0);
      else meff := TFlyingAxe.Create (1, 1, scx, scy, sctx, scty, mtype, TRUE, 0);
   end;
   meff.TargetRx := tx;
   meff.TargetRy := ty;
   meff.TargetActor := FindActor (targetcode);
   meff.MagOwner := aowner;
   m_FlyList.Add (meff);
   Result := meff;
end;

//Àü±â½î´Â Á»ºñÀÇ ¸¶¹ýÃ³·³ ±æ°Ô ³ª°¡´Â ¸¶¹ý
//effnum: °¢ ¹øÈ£¸¶´Ù Base°¡ ´Ù ´Ù¸£´Ù.
{function  NewStaticMagic (aowner: TActor; tx, ty, targetcode, effnum: integer);
var
   i, scx, scy, sctx, scty, effbase: integer;
   meff: TMagicEff;
begin
   ScreenXYfromMCXY (cx, cy, scx, scy);
   ScreenXYfromMCXY (tx, ty, sctx, scty);
   case effnum of
      1: effbase := 340;   //Á»ºñÀÇ ¶óÀÌÆ®´×ÀÇ ½ÃÀÛ À§Ä¡
      else exit;
   end;

   meff := TLightingEffect.Create (effbase, 1, 1, scx, scy, sctx, scty, mtype, TRUE, 0);
   meff.TargetRx := tx;
   meff.TargetRy := ty;
   meff.TargetActor := FindActor (targetcode);
   meff.MagOwner := aowner;
   FlyList.Add (meff);
   Result := meff;
end;  }

{-------------------------------------------------------}

//¸Ê ÁÂÇ¥°è·Î ¼¿ Áß¾ÓÀÇ ½ºÅ©¸° ÁÂÇ¥¸¦ ¾ò¾î³¿
{procedure TPlayScene.ScreenXYfromMCXY (cx, cy: integer; var sx, sy: integer);
begin
   if Myself = nil then exit;
   sx := -UNITX*2 - Myself.ShiftX + AAX + 14 + (cx - Map.ClientRect.Left) * UNITX + UNITX div 2;
   sy := -UNITY*3 - Myself.ShiftY + (cy - Map.ClientRect.Top) * UNITY + UNITY div 2;
end; }

procedure TPlayScene.ScreenXYfromMCXY (cx, cy: integer; var sx, sy: integer);
begin
   if g_MySelf = nil then exit;
{$IF SWH = SWH800}
     sx := (cx-g_MySelf.m_nRx)*UNITX + 364 + UNITX div 2 - g_MySelf.m_nShiftX;
     sy := (cy-g_MySelf.m_nRy)*UNITY + 192 + UNITY div 2 - g_MySelf.m_nShiftY;
{$ELSEIF SWH = SWH1024}
     sx := (cx-g_MySelf.m_nRx)*UNITX + 485{364} + UNITX div 2 - g_MySelf.m_nShiftX;
     sy := (cy-g_MySelf.m_nRy)*UNITY + 270{192} + UNITY div 2 - g_MySelf.m_nShiftY;
{$IFEND}
end;

//ÆÁÄ»×ù±ê mx, my×ª»»³Éccx, ccyµØÍ¼×ù±ê
procedure TPlayScene.CXYfromMouseXY (mx, my: integer; var ccx, ccy: integer);
begin
   if g_MySelf = nil then exit;
{$IF SWH = SWH800}
   ccx := Round((mx - 364 + g_MySelf.m_nShiftX - UNITX) / UNITX) + g_MySelf.m_nRx;
   ccy := Round((my - 192 + g_MySelf.m_nShiftY - UNITY) / UNITY) + g_MySelf.m_nRy;
{$ELSEIF SWH = SWH1024}
   ccx := Round((mx - 485{364}  + g_MySelf.m_nShiftX - UNITX) / UNITX) + g_MySelf.m_nRx;
   ccy := Round((my - 270{192} + g_MySelf.m_nShiftY - UNITY) / UNITY) + g_MySelf.m_nRy;
{$IFEND}
end;

//È­¸éÁÂÇ¥·Î Ä³¸¯ÅÍ, ÇÈ¼¿ ´ÜÀ§·Î ¼±ÅÃ..
function  TPlayScene.GetCharacter (x, y, wantsel: integer; var nowsel: integer; liveonly: Boolean): TActor;
var
   k, i, ccx, ccy, dx, dy: integer;
   a: TActor;
begin
   Result := nil;
   nowsel := -1;
   CXYfromMouseXY (x, y, ccx, ccy);
   for k:=ccy+8 downto ccy-1 do begin
      for i:=m_ActorList.Count-1 downto 0 do
         if TActor(m_ActorList[i]) <> g_MySelf then begin
            a := TActor(m_ActorList[i]);
            if (not liveonly or not a.m_boDeath) and (a.m_boHoldPlace) and (a.m_boVisible) then begin
               if a.m_nCurrY = k then begin
                  //´õ ³ÐÀº ¹üÀ§·Î ¼±ÅÃµÇ°Ô
                  dx := (a.m_nRx-Map.m_ClientRect.Left)*UNITX + m_nDefXX + a.m_nPx + a.m_nShiftX;
                  dy := (a.m_nRy-Map.m_ClientRect.Top-1)*UNITY + m_nDefYY + a.m_nPy + a.m_nShiftY;
                  if a.CheckSelect (x-dx, y-dy) then begin
                     Result := a;
                     Inc (nowsel);
                     if nowsel >= wantsel then
                        exit;
                  end;
               end;
            end;
         end;
   end;
end;

//È¡µÃÊó±êËùÖ¸×ø±êµÄ½ÇÉ«
function  TPlayScene.GetAttackFocusCharacter (x, y, wantsel: integer; var nowsel: integer; liveonly: Boolean): TActor;
var
   k, i, ccx, ccy, dx, dy, centx, centy: integer;
   a: TActor;
begin
   Result := GetCharacter (x, y, wantsel, nowsel, liveonly);
   if Result = nil then begin
      nowsel := -1;
      CXYfromMouseXY (x, y, ccx, ccy);
      for k:=ccy+8 downto ccy-1 do begin
         for i:=m_ActorList.Count-1 downto 0 do
            if TActor(m_ActorList[i]) <> g_MySelf then begin
               a := TActor(m_ActorList[i]);
               if (not liveonly or not a.m_boDeath) and (a.m_boHoldPlace) and (a.m_boVisible) then begin
                  if a.m_nCurrY = k then begin
                     //
                     dx := (a.m_nRx-Map.m_ClientRect.Left)*UNITX + m_nDefXX + a.m_nPx + a.m_nShiftX;
                     dy := (a.m_nRy-Map.m_ClientRect.Top-1)*UNITY+ m_nDefYY + a.m_nPy + a.m_nShiftY;
                     if a.CharWidth > 40 then centx := (a.CharWidth - 40) div 2
                     else centx := 0;
                     if a.CharHeight > 70 then centy := (a.CharHeight - 70) div 2
                     else centy := 0;
                     if (x-dx >= centx) and (x-dx <= a.CharWidth-centx) and (y-dy >= centy) and (y-dy <= a.CharHeight-centy) then begin
                        Result := a;
                        Inc (nowsel);
                        if nowsel >= wantsel then
                           exit;
                     end;
                  end;
               end;
            end;
      end;
   end;
end;

function  TPlayScene.IsSelectMyself (x, y: integer): Boolean;
var
  k, i, ccx, ccy, dx, dy: integer;
begin
  Result := FALSE;
  CXYfromMouseXY (x, y, ccx, ccy);
  for k:=ccy+2 downto ccy-1 do begin
    if g_MySelf.m_nCurrY = k then begin
      //´õ ³ÐÀº ¹üÀ§·Î ¼±ÅÃµÇ°Ô
      dx:=(g_MySelf.m_nRx - Map.m_ClientRect.Left) * UNITX + m_nDefXX + g_MySelf.m_nPx + g_MySelf.m_nShiftX;
      dy:=(g_MySelf.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + m_nDefYY + g_MySelf.m_nPy + g_MySelf.m_nShiftY;
      if g_MySelf.CheckSelect (x-dx, y-dy) then begin
        Result := TRUE;
        exit;
      end;
    end;
  end;
end;
//È¡µÃÖ¸¶¨×ù±êµØÃæÎïÆ·
// x,y ÎªÆÁÄ»×ù±ê
function  TPlayScene.GetDropItems (x, y: integer; var inames: string): PTDropItem; //È­¸éÁÂÇ¥·Î ¾ÆÀÌÅÛ
var
  k, i, ccx, ccy, ssx, ssy, dx, dy: integer;
  DropItem:PTDropItem;
  s: TDirectDrawSurface;
  c: byte;
begin
  Result := nil;
  CXYfromMouseXY (x, y, ccx, ccy);
  ScreenXYfromMCXY (ccx, ccy, ssx, ssy);
  dx := x - ssx;
  dy := y - ssy;
  inames := '';
  for i:=0 to g_DropedItemList.Count-1 do begin
    DropItem := PTDropItem(g_DropedItemList[i]);
    if (DropItem.X = ccx) and (DropItem.Y = ccy) then begin

      s := g_WDnItemImages.Images[DropItem.Looks];
      if s = nil then continue;
      dx := (x - ssx) + (s.Width div 2) - 3;
      dy := (y - ssy) + (s.Height div 2);
      c := s.Pixels[dx, dy];
      if c <> 0 then begin

        if Result = nil then Result := DropItem;
        inames := inames + DropItem.Name + '\';
        //break;
      end;
    end;
  end;
end;
procedure TPlayScene.GetXYDropItemsList(nX,nY:Integer;var ItemList:TList);
var
  I:Integer;
  DropItem:pTDropItem;
begin
  for I:= 0 to g_DropedItemList.Count - 1 do begin
    DropItem:=g_DropedItemList[i];
    if (DropItem.X = nX) and (DropItem.Y = nY) then begin
      ItemList.Add(DropItem);
    end;
  end;
end;

function TPlayScene.GetXYDropItems(nX, nY: Integer): pTDropItem;
var
  I:Integer;
  DropItem:pTDropItem;
begin
  Result:=nil;
  for I:= 0 to g_DropedItemList.Count - 1 do begin
    DropItem:=g_DropedItemList[i];
    if (DropItem.X = nX) and (DropItem.Y = nY) then begin
      Result:=DropItem;
      break;
    end;
  end;
end;

function  TPlayScene.CanRun (sx, sy, ex, ey: integer): Boolean;
var
   ndir, rx, ry: integer;
begin
   ndir := GetNextDirection (sx, sy, ex, ey);
   rx := sx;
   ry := sy;
   GetNextPosXY (ndir, rx, ry);

   if Map.CanMove (rx, ry) and Map.CanMove (ex, ey) then
     Result:=True
   else Result:=False;

   if CanWalkEx (rx, ry) and CanWalkEx (ex, ey) then
      Result := TRUE
   else Result := FALSE;
end;
function  TPlayScene.CanWalkEx (mx, my: integer): Boolean;
begin
   Result := FALSE;
   if Map.CanMove(mx,my) then
      Result := not CrashManEx (mx, my);
end;
   //´©ÈË
function  TPlayScene.CrashManEx (mx, my: integer): Boolean;
var
  I:Integer;
  Actor:TActor;
begin    
  Result := False;
  for i:=0 to m_ActorList.Count-1 do begin
    Actor:= TActor(m_ActorList[i]);
    if (Actor.m_boVisible) and (Actor.m_boHoldPlace) and (not Actor.m_boDeath) and (Actor.m_nCurrX = mx) and (Actor.m_nCurrY = my) then begin
//      DScreen.AddChatBoardString ('Actor.m_btRace ' + IntToStr(Actor.m_btRace),clWhite, clRed);
      if (Actor.m_btRace = RCC_USERHUMAN) and g_boCanRunHuman then Continue;
      if (Actor.m_btRace = RCC_MERCHANT) and g_boCanRunNpc then Continue;
      if ((Actor.m_btRace > RCC_USERHUMAN) and (Actor.m_btRace <> RCC_MERCHANT)) and g_boCanRunMon then Continue;
      //m_btRace ´óÓÚ 0 ²¢²»µÈÓÚ 50 ÔòÎª¹ÖÎï
      Result:=True;
      break;
    end;
  end;
end;

function  TPlayScene.CanWalk (mx, my: integer): Boolean;
begin
   Result := FALSE;
   if Map.CanMove(mx,my) then
      Result := not CrashMan (mx, my);
end;

function  TPlayScene.CrashMan (mx, my: integer): Boolean;
var
   i: integer;
   a: TActor;
begin
   Result := FALSE;
   for i:=0 to m_ActorList.Count-1 do begin
      a := TActor(m_ActorList[i]);
      if (a.m_boVisible) and (a.m_boHoldPlace) and (not a.m_boDeath) and (a.m_nCurrX = mx) and (a.m_nCurrY = my) then begin
         Result := TRUE;
         break;
      end;
   end;
end;

function  TPlayScene.CanFly (mx, my: integer): Boolean;
begin
   Result := Map.CanFly (mx, my);
end;


{------------------------ Actor ------------------------}

function  TPlayScene.FindActor (id: integer): TActor;
var
   i: integer;
begin
   Result := nil;
   for i:=0 to m_ActorList.Count-1 do begin
      if TActor(m_ActorList[i]).m_nRecogId = id then begin
         Result := TActor(m_ActorList[i]);
         break;
      end;
   end;
end;

function TPlayScene.FindActor(sName: String): TActor;
var
  I:Integer;
  Actor:TActor;
begin
  Result := nil;
  for I:=0 to m_ActorList.Count-1 do begin
    Actor:=TActor(m_ActorList[i]);
    if CompareText(Actor.m_sUserName,sName) = 0 then begin
      Result:=Actor;
      break;
    end;
  end;
end;

function  TPlayScene.FindActorXY (x, y: integer): TActor;  //¸Ê ÁÂÇ¥·Î actor ¾òÀ½
var
   i: integer;
begin
   Result := nil;
   for i:=0 to m_ActorList.Count-1 do begin
      if (TActor(m_ActorList[i]).m_nCurrX = x) and (TActor(m_ActorList[i]).m_nCurrY = y) then begin
         Result := TActor(m_ActorList[i]);
         if not Result.m_boDeath and Result.m_boVisible and Result.m_boHoldPlace then
            break;
      end;
   end;
end;

function  TPlayScene.IsValidActor (actor: TActor): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   for i:=0 to m_ActorList.Count - 1 do begin
      if TActor(m_ActorList[i]) = actor then begin
         Result := TRUE;
         break;
      end;
   end;
end;

function  TPlayScene.NewActor (chrid:     integer;
                               cx:        word; //x
                               cy:        word; //y
                               cdir:      word;
                               cfeature:  integer; //race, hair, dress, weapon
                               cstate:    integer): TActor;
var
   i: integer;
   actor: TActor;
begin
   Result:=nil;//jacky
   for i:=0 to m_ActorList.Count-1 do
      if TActor(m_ActorList[i]).m_nRecogId = chrid then begin
         Result := TActor(m_ActorList[i]);
         exit; //ÀÌ¹Ì ÀÖÀ½
      end;
   if IsChangingFace (chrid) then exit;  //º¯½ÅÁß...      

   case RACEfeature (cfeature) of //m_btRaceImg
      0:  actor := THumActor.Create;              //ÈËÎï
      9:  actor := TSoccerBall.Create;            //×ãÇò
      13: actor := TKillingHerb.Create;           //Ê³ÈË»¨
      14: actor := TSkeletonOma.Create;           //÷¼÷Ã
      15: actor := TDualAxeOma.Create;            //ÖÀ¸«÷¼÷Ã

      16: actor := TGasKuDeGi.Create;             //¶´Çù

      17: actor := TCatMon.Create;                //¹³×¦Ã¨
      18: actor := THuSuABi.Create;               //µ¾²ÝÈË
      19: actor := TCatMon.Create;                //ÎÖÂêÕ½Ê¿

      20: actor := TFireCowFaceMon.Create;        //»ðÑæÎÖÂê
      21: actor := TCowFaceKing.Create;           //ÎÖÂê½ÌÖ÷
      22: actor := TDualAxeOma.Create;            //ºÚ°µÕ½Ê¿
      23: actor := TWhiteSkeleton.Create;         //±äÒì÷¼÷Ã
      24: actor := TSuperiorGuard.Create;         //´øµ¶ÎÀÊ¿
      30: actor := TCatMon.Create; //³¯°³Áþ
      31: actor := TCatMon.Create;                //½ÇÓ¬
      32: actor := TScorpionMon.Create;           //Ð«×Ó

      33: actor := TCentipedeKingMon.Create;      //´¥ÁúÉñ
      34: actor := TBigHeartMon.Create;           //³àÔÂ¶ñÄ§
      35: actor := TSpiderHouseMon.Create;        //»ÃÓ°Ö©Öë
      36: actor := TExplosionSpider.Create;       //ÔÂÄ§Ö©Öë
      37: actor := TFlyingSpider.Create;       //

      40: actor := TZombiLighting.Create;         //½©Ê¬1
      41: actor := TZombiDigOut.Create;           //½©Ê¬2
      42: actor := TZombiZilkin.Create;           //½©Ê¬3

      43: actor := TBeeQueen.Create;              //½ÇÓ¬³²

      45: actor := TArcherMon.Create;             //¹­¼ýÊÖ
      47: actor := TSculptureMon.Create;          //×æÂêµñÏñ
      48: actor := TSculptureMon.Create;          //
      49: actor := TSculptureKingMon.Create;      //×æÂê½ÌÖ÷

      50: actor := TNpcActor.Create;

      52: actor := TGasKuDeGi.Create;             //Ð¨¶ê
      53: actor := TGasKuDeGi.Create;             //·à³æ
      54: actor := TSmallElfMonster.Create;       //ÉñÊÞ
      55: actor := TWarriorElfMonster.Create;     //ÉñÊÞ1

      60: actor := TElectronicScolpionMon.Create;
      61: actor := TBossPigMon.Create;
      62: actor := TKingOfSculpureKingMon.Create;
      63: actor := TSkeletonKingMon.Create;
      64: actor := TGasKuDeGi.Create;       
      65: actor := TSamuraiMon.Create;
      66: actor := TSkeletonSoldierMon.Create;
      67: actor := TSkeletonSoldierMon.Create;
      68: actor := TSkeletonSoldierMon.Create;
      69: actor := TSkeletonArcherMon.Create;
      70: actor := TBanyaGuardMon.Create;
      71: actor := TBanyaGuardMon.Create;
      72: actor := TBanyaGuardMon.Create;
      73: actor := TPBOMA1Mon.Create;
      74: actor := TCatMon.Create;
      75: actor := TStoneMonster.Create;
      76: actor := TSuperiorGuard.Create;
      77: actor := TStoneMonster.Create;
      78: actor := TBanyaGuardMon.Create;
      79: actor := TPBOMA6Mon.Create;
      80: actor := TMineMon.Create;
      81: actor := TAngel.Create;
      83: actor := TFireDragon.Create;
      84: actor := TDragonStatue.Create;

      90: actor := TDragonBody.Create;            //Áú
      98: actor := TWallStructure.Create;         //LeftWall
      99: actor := TCastleDoor.Create;            //MainDoor
      else actor := TActor.Create;
   end;

   with actor do begin
      m_nRecogId := chrid;
      m_nCurrX     := cx;
      m_nCurrY     := cy;
      m_nRx        := m_nCurrX;
      m_nRy        := m_nCurrY;
      m_btDir      := cdir;
      m_nFeature   := cfeature;
      m_btRace     := RACEfeature(cfeature);         //changefeature°¡ ÀÖÀ»¶§¸¸
      m_btHair     := HAIRfeature(cfeature);         //º¯°æµÈ´Ù.
      m_btDress    := DRESSfeature(cfeature);
      m_btWeapon   := WEAPONfeature(cfeature);
      m_wAppearance:= APPRfeature(cfeature);
//      Horse:=Horsefeature(cfeature);
//      Effect:=Effectfeature(cfeature);
      m_Action     := GetMonAction(m_wAppearance);
      if m_btRace = 0 then begin
        m_btSex := m_btDress mod 2;   //0:³²ÀÚ 1:¿©ÀÚ
      end else begin
        m_btSex := 0;
      end;
      m_nState  := cstate;
      m_SayingArr[0] := '';
   end;
   m_ActorList.Add(actor);
   Result := actor;
end;

procedure TPlayScene.ActorDied (actor: TObject);
var
   i: integer;
   flag: Boolean;
begin
   for i:=0 to m_ActorList.Count-1 do
      if m_ActorList[i] = actor then begin
         m_ActorList.Delete (i);
         break;
      end;
   flag := FALSE;
   for i:=0 to m_ActorList.Count-1 do
      if not TActor(m_ActorList[i]).m_boDeath then begin
         m_ActorList.Insert (i, actor);
         flag := TRUE;
         break;
      end;
   if not flag then m_ActorList.Add (actor);
end;

procedure TPlayScene.SetActorDrawLevel (actor: TObject; level: integer);
var
   i: integer;
begin
   if level = 0 then begin  //¸Ç Ã³À½¿¡ ±×¸®µµ·Ï ÇÔ
      for i:=0 to m_ActorList.Count-1 do
         if m_ActorList[i] = actor then begin
            m_ActorList.Delete (i);
            m_ActorList.Insert (0, actor);
            break;
         end;
   end;
end;

procedure TPlayScene.ClearActors;  //·Î±×¾Æ¿ô¸¸ »ç¿ë
var
   i: integer;
begin
   for i:=0 to m_ActorList.Count-1 do
      TActor(m_ActorList[i]).Free;
   m_ActorList.Clear;
   g_MySelf := nil;
   g_TargetCret := nil;
   g_FocusCret := nil;
   g_MagicTarget := nil;

   //¸¶¹ýµµ ÃÊ±âÈ­ ÇØ¾ßÇÔ.
   for i:=0 to m_EffectList.Count-1 do
      TMagicEff (m_EffectList[i]).Free;
   m_EffectList.Clear;
end;

function  TPlayScene.DeleteActor (id: integer): TActor;
var
   i: integer;
begin
   Result := nil;
   i := 0;
   while TRUE do begin
      if i >= m_ActorList.Count then break;
      if TActor(m_ActorList[i]).m_nRecogId = id then begin
         if g_TargetCret = TActor(m_ActorList[i]) then g_TargetCret := nil;
         if g_FocusCret = TActor(m_ActorList[i]) then g_FocusCret := nil;
         if g_MagicTarget = TActor(m_ActorList[i]) then g_MagicTarget := nil;
         TActor(m_ActorList[i]).m_dwDeleteTime := GetTickCount;
         g_FreeActorList.Add (m_ActorList[i]);
         //TActor(ActorList[i]).Free;
         m_ActorList.Delete (i);
      end else
         Inc (i);
   end;
end;

procedure TPlayScene.DelActor (actor: TObject);
var
   i: integer;
begin
   for i:=0 to m_ActorList.Count-1 do
      if m_ActorList[i] = actor then begin
         TActor(m_ActorList[i]).m_dwDeleteTime := GetTickCount;
         g_FreeActorList.Add (m_ActorList[i]);
         m_ActorList.Delete (i);
         break;
      end;
end;

function  TPlayScene.ButchAnimal (x, y: integer): TActor;
var
   i: integer;
   a: TActor;
begin
   Result := nil;
   for i:=0 to m_ActorList.Count-1 do begin
      a := TActor(m_ActorList[i]);
      if a.m_boDeath and (a.m_btRace <> 0) then begin //µ¿¹° ½ÃÃ¼
         if (abs(a.m_nCurrX - x) <= 1) and (abs(a.m_nCurrY - y) <= 1) then begin
            Result := a;
            break;
         end;
      end;
   end;
end;


{------------------------- Msg -------------------------}


//¸Þ¼¼Áö¸¦ ¹öÆÛ¸µÇÏ´Â ÀÌÀ¯´Â ?
//Ä³¸¯ÅÍÀÇ ¸Þ¼¼Áö ¹öÆÛ¿¡ ¸Þ¼¼Áö°¡ ³²¾Æ ÀÖ´Â »óÅÂ¿¡¼­
//´ÙÀ½ ¸Þ¼¼Áö°¡ Ã³¸®µÇ¸é ¾ÈµÇ±â ¶§¹®ÀÓ.
procedure TPlayScene.SendMsg (ident, chrid, x, y, cdir, feature, state: integer; str: string);
var
   actor: TActor;
begin
   case ident of
      SM_TEST:
         begin
            actor := NewActor (111, 254{x}, 214{y}, 0, 0, 0);
            g_MySelf := THumActor (actor);
            Map.LoadMap ('0', g_MySelf.m_nCurrX, g_MySelf.m_nCurrY);
         end;
      SM_CHANGEMAP,
      SM_NEWMAP: begin
        Map.LoadMap (str, x, y);
        DarkLevel := cdir;
        if DarkLevel = 0 then g_boViewFog := FALSE
        else g_boViewFog := TRUE;
            //
        if g_boViewMiniMap then begin
//              BoViewMiniMap := FALSE;
          g_nMiniMapIndex:= -1;
          frmMain.SendWantMiniMap;
        end;
            //
        if (ident = SM_NEWMAP) and (g_MySelf <> nil) then begin
          g_MySelf.m_nCurrX := x;
          g_MySelf.m_nCurrY := y;
          g_MySelf.m_nRx := x;
          g_MySelf.m_nRy := y;
          DelActor (g_MySelf);
        end;
        
      end;
      SM_LOGON:
         begin
            actor := FindActor (chrid);
            if actor = nil then begin
               actor := NewActor (chrid, x, y, Lobyte(cdir), feature, state);
               actor.m_nChrLight := Hibyte(cdir);
               cdir := Lobyte(cdir);
               actor.SendMsg (SM_TURN, x, y, cdir, feature, state, '', 0);
            end;
            if g_MySelf <> nil then begin
               g_MySelf := nil;
            end;
            g_MySelf := THumActor (actor);
         end;
      SM_HIDE:
         begin
            actor := FindActor (chrid);
            if actor <> nil then begin
               if actor.m_boDelActionAfterFinished then begin //¶¥À¸·Î »ç¶óÁö´Â ¾Ö´Ï¸ÞÀÌ¼ÇÀÌ ³¡³ª¸é ÀÚµ¿À¸·Î »ç¶óÁü.
                  exit;
               end;
               if actor.m_nWaitForRecogId <> 0 then begin  //º¯½ÅÁß.. º¯½ÅÀÌ ³¡³ª¸é ÀÚµ¿À¸·Î »ç¶óÁü
                  exit;
               end;
            end;
            DeleteActor (chrid);
         end;
      else begin
            actor := FindActor (chrid);
            if (ident=SM_TURN) or (ident=SM_RUN) or (ident=SM_HORSERUN) or (ident=SM_WALK) or
               (ident=SM_BACKSTEP) or
               (ident = SM_DEATH) or (ident = SM_SKELETON) or
               (ident = SM_DIGUP) or (ident = SM_ALIVE) then
            begin
               if actor = nil then
                  actor := NewActor (chrid, x, y, Lobyte(cdir), feature, state);
               if actor <> nil then begin
                  actor.m_nChrLight := Hibyte(cdir);
                  cdir := Lobyte(cdir);
                  if ident = SM_SKELETON then begin
                     actor.m_boDeath := TRUE;  
                     actor.m_boSkeleton := TRUE;
                  end;
               end;
            end;
            if actor = nil then exit;
            case ident of
               SM_FEATURECHANGED: begin
                 actor.m_nFeature := feature;
                 actor.m_nFeatureEx:=state;
                 actor.FeatureChanged;
               end;
               SM_CHARSTATUSCHANGED: begin
                 actor.m_nState:= Feature;
                 actor.m_nHitSpeed:= state;
               end;
               else begin
                  if ident = SM_TURN then begin
                     if str <> '' then
                        actor.m_sUserName := str;
                  end;
                  actor.SendMsg (ident, x, y, cdir, feature, state, '', 0);
               end;
            end;
         end;
   end;
end;


end.
