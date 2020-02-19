unit IntroScn;
//游戏的引导场景实现,比如登录选人等

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, StdCtrls, Controls, Forms, Dialogs,
  extctrls, DXDraws, DXClass, FState, Grobal2, cliUtil, clFunc, SoundUtil,
  DXSounds, HUtil32;


const
   SELECTEDFRAME = 16;
   FREEZEFRAME = 13;
   EFFECTFRAME = 14;

type
   TLoginState = (lsLogin, lsNewid, lsNewidRetry, lsChgpw, lsCloseAll);
   TSceneType = (stIntro, stLogin, stSelectCountry, stSelectChr, stNewChr, stLoading,
                   stLoginNotice, stPlayGame);


   TSelChar = record
      Valid: Boolean;
      UserChr: TUserCharacterInfo;
      Selected: Boolean;
      FreezeState: Boolean; //TRUE:石化 FALSE:非石化
      Unfreezing: Boolean;  //正在解石化
      Freezing: Boolean;    //正在石化
      AniIndex: integer;    //
      DarkLevel: integer;
      EffIndex: integer;    //特效索引
      StartTime: longword;
      moretime: longword;
      startefftime: longword;
   end;

   TScene = class
   private
   public
      SceneType: TSceneType;
      constructor Create (scenetype: TSceneType);
      procedure Initialize; dynamic;
      procedure Finalize; dynamic;
      procedure OpenScene; dynamic;
      procedure CloseScene; dynamic;
      procedure OpeningScene; dynamic;
      procedure KeyPress (var Key: Char); dynamic;
      procedure KeyDown (var Key: Word; Shift: TShiftState); dynamic;
      procedure MouseMove (Shift: TShiftState; X, Y: Integer); dynamic;
      procedure MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer); dynamic;
      procedure PlayScene (MSurface: TDirectDrawSurface); dynamic;
   end;

   //Intro Scene
   TIntroScene = class (TScene)
   private
   public
      constructor Create;
      destructor Destroy; override;
      procedure OpenScene; override;
      procedure CloseScene; override;
      procedure PlayScene (MSurface: TDirectDrawSurface); override;
   end;

   //Login Scene
   TLoginScene = class (TScene)
   private
     m_EdId           :TEdit;
     m_EdPasswd       :TEdit;
     m_EdNewId        :TEdit;
     m_EdNewPasswd    :TEdit;
     m_EdConfirm      :TEdit;
     m_EdYourName     :TEdit;
     m_EdSSNo         :TEdit;
     m_EdBirthDay     :TEdit;
     m_EdQuiz1        :TEdit;
     m_EdAnswer1      :TEdit;
     m_EdQuiz2        :TEdit;
     m_EdAnswer2      :TEdit;
     m_EdPhone        :TEdit;
     m_EdMobPhone     :TEdit;
     m_EdEMail        :TEdit;
     m_EdChgId        :TEdit;
     m_EdChgCurrentpw :TEdit;
     m_EdChgNewPw     :TEdit;
     m_EdChgRepeat    :TEdit;
     m_nCurFrame      :Integer;
     m_nMaxFrame      :Integer;
     m_dwStartTime    :LongWord;  
     m_boNowOpening   :Boolean;
     m_boOpenFirst    :Boolean;
     m_NewIdRetryUE   :TUserEntry;
     m_NewIdRetryAdd  :TUserEntryAdd;
     procedure EdLoginIdKeyPress (Sender: TObject; var Key: Char);
     procedure EdLoginPasswdKeyPress (Sender: TObject; var Key: Char);
     procedure EdNewIdKeyPress (Sender: TObject; var Key: Char);
     procedure EdNewOnEnter (Sender: TObject);
     function  CheckUserEntrys: Boolean;
     function  NewIdCheckNewId: Boolean;
     function  NewIdCheckSSno: Boolean;
     function  NewIdCheckBirthDay: Boolean;
   public
     m_sLoginId            :String;
     m_sLoginPasswd        :String;
     m_boUpdateAccountMode :Boolean;
     constructor Create;
      destructor Destroy; override;
      procedure OpenScene; override;
      procedure CloseScene; override;
      procedure PlayScene (MSurface: TDirectDrawSurface); override;
      procedure ChangeLoginState (state: TLoginState);
      procedure NewClick;
      procedure NewIdRetry (boupdate: Boolean);
      procedure UpdateAccountInfos (ue: TUserEntry);
      procedure OkClick;
      procedure ChgPwClick;
      procedure NewAccountOk;
      procedure NewAccountClose;
      procedure ChgpwOk;
      procedure ChgpwCancel;
      procedure HideLoginBox;
      procedure OpenLoginDoor;
      procedure PassWdFail;
   end;

   //Select Chr Scene
   TSelectChrScene = class (TScene)
   private
      SoundTimer: TTimer;
      CreateChrMode: Boolean;
      EdChrName: TEdit;
      procedure SoundOnTimer (Sender: TObject);
      procedure MakeNewChar (index: integer);
      procedure EdChrnameKeyPress (Sender: TObject; var Key: Char);
   public
      NewIndex: integer;
      ChrArr: array[0..1] of TSelChar;
      constructor Create;
      destructor Destroy; override;
      procedure OpenScene; override;
      procedure CloseScene; override;
      procedure PlayScene (MSurface: TDirectDrawSurface); override;
      procedure SelChrSelect1Click;
      procedure SelChrSelect2Click;
      procedure SelChrStartClick;
      procedure SelChrNewChrClick;
      procedure SelChrEraseChrClick;
      procedure SelChrCreditsClick;
      procedure SelChrExitClick;
      procedure SelChrNewClose;
      procedure SelChrNewJob (job: integer);
      procedure SelChrNewm_btSex (sex: integer);
      procedure SelChrNewPrevHair;
      procedure SelChrNewNextHair;
      procedure SelChrNewOk;
      procedure ClearChrs;
      procedure AddChr (uname: string; job, hair, level, sex: integer);
      procedure SelectChr (index: integer);
   end;

   TLoginNotice = class (TScene)
   private
   public
      constructor Create;
      destructor Destroy; override;
   end;


implementation

uses
   ClMain, MShare, Share;


constructor TScene.Create (scenetype: TSceneType);
begin
   SceneType := scenetype;
end;

procedure TScene.Initialize;
begin
end;

procedure TScene.Finalize;
begin
end;

procedure TScene.OpenScene;
begin
   ;
end;

procedure TScene.CloseScene;
begin
   ;
end;

procedure TScene.OpeningScene;
begin
end;

procedure TScene.KeyPress (var Key: Char);
begin
end;

procedure TScene.KeyDown (var Key: Word; Shift: TShiftState);
begin
end;

procedure TScene.MouseMove (Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TScene.MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TScene.PlayScene (MSurface: TDirectDrawSurface);
begin
   ;
end;


{------------------- TIntroScene ----------------------}


constructor TIntroScene.Create;
begin
   inherited Create (stIntro);
end;

destructor TIntroScene.Destroy;
begin
   inherited Destroy;
end;

procedure TIntroScene.OpenScene;
begin
end;

procedure TIntroScene.CloseScene;
begin
end;

procedure TIntroScene.PlayScene (MSurface: TDirectDrawSurface);
begin
end;


{--------------------- Login ----------------------}
//登录块景

constructor TLoginScene.Create;
var
   nx, ny: integer;
begin
   inherited Create (stLogin);

   //登录--用户、密码
   //登陆ID输入框
   m_EdId := TEdit.Create (FrmMain.Owner);
   with m_EdId do begin
      Parent := FrmMain;
      Color  := clBlack;
      Font.Color := clWhite;
      Font.Size := 10;
      MaxLength := 10;
      BorderStyle := bsNone;
      OnKeyPress := EdLoginIdKeyPress;
      Visible := FALSE;
      Tag := 10;
   end;
   //密码输入框
   m_EdPasswd := TEdit.Create (FrmMain.Owner);
   with m_EdPasswd do begin
      Parent := FrmMain; Color  := clBlack; Font.Size := 10; MaxLength := 10; Font.Color := clWhite;
      BorderStyle := bsNone; PasswordChar := '*';
      OnKeyPress := EdLoginPasswdKeyPress; Visible := FALSE;
      Tag := 10;
   end;


    //登录--新用户输入 对话框
   //登陆提示
   nx := SCREENWIDTH  div 2 - 320 {192}{79};    //减去对话框图片宽的1/2 
   ny := SCREENHEIGHT div 2 - 237 {146}{64};   //减去对话框图片高的1/2

   m_EdNewId := TEdit.Create (FrmMain.Owner);     //用户(新册注)
   with m_EdNewId do begin
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 116; //104;
      Left := nx + 161; //86;
      Top  := ny + 117; //91;
      BorderStyle := bsNone; Color := clBlack; Font.Color := clWhite; MaxLength := 10;
      Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
      Tag := 11;
   end;

   m_EdNewPasswd := TEdit.Create (FrmMain.Owner);    //密码(新册注)
   with m_EdNewPasswd do begin
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 116; //104;
      Left := nx + 161; //86;
      Top  := ny + 138; //118;
      BorderStyle := bsNone; Color := clBlack; Font.Color := clWhite; MaxLength := 10;
      PasswordChar := '*'; Visible := FALSE;  OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
      Tag := 11;
   end;
   m_EdConfirm := TEdit.Create (FrmMain.Owner);    //确认 密码（新册注）
   with m_EdConfirm do begin
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 116; //104;
      Left := nx + 162; //86;
      Top  := ny + 159; //149;
      BorderStyle := bsNone; Color := clBlack; Font.Color := clWhite; MaxLength := 10;
      PasswordChar := '*';  Visible := FALSE;  OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
      Tag := 11;
   end;
   m_EdYourName := TEdit.Create (FrmMain.Owner);      //你的名字
   with m_EdYourName do begin
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 116; //105;
      Left := nx + 161; //86;
      Top  := ny + 188; //190;
      BorderStyle := bsNone; Color  := clBlack; Font.Color := clWhite; MaxLength := 20;
      Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
      Tag := 11;
   end;
   m_EdSSNo := TEdit.Create (FrmMain.Owner);        //身份证
   with m_EdSSNo do begin
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 116; //105;
      Left := nx + 161; //86;
      Top  := ny + 207;
      BorderStyle := bsNone; Color  := clBlack; Font.Color := clWhite; MaxLength := 18;   //14
      Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
      Tag := 11;
   end;
   m_EdBirthDay := TEdit.Create (FrmMain.Owner);        //生日
   with m_EdBirthDay do begin
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 116; //105;
      Left := nx + 161; //86;
      Top  := ny + 227; //217;
      BorderStyle := bsNone; Color  := clBlack; Font.Color := clWhite; MaxLength := 10;
      Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
      Tag := 11;
   end;
   m_EdQuiz1 := TEdit.Create (FrmMain.Owner);    //提问1
   with m_EdQuiz1 do begin
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 162; //124;
      Left := nx + 161; //263;
      Top  := ny + 257; //118;
      BorderStyle := bsNone; Color  := clBlack; Font.Color := clWhite; MaxLength := 20;
      Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
      Tag := 11;
   end;
   m_EdAnswer1 := TEdit.Create (FrmMain.Owner);   //回答1
   with m_EdAnswer1 do begin
      Parent := FrmMain;
      Height := 16; //12;
      Width  := 162;
      Left := nx + 161; //263;
      Top  := ny + 277; //149;
      BorderStyle := bsNone; Color  := clBlack; Font.Color := clWhite; MaxLength := 12;
      Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
      Tag := 11;
   end;
   m_EdQuiz2 := TEdit.Create (FrmMain.Owner);    //提问2
   with m_EdQuiz2 do begin
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 162; //124;
      Left := nx + 161; //263;
      Top  := ny + 297; //190;
      BorderStyle := bsNone; Color  := clBlack; Font.Color := clWhite; MaxLength := 20;
      Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
      Tag := 11;
   end;
   m_EdAnswer2 := TEdit.Create (FrmMain.Owner);    //回答2
   with m_EdAnswer2 do begin
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 162; //124;
      Left := nx + 161;//263;
      Top  := ny + 317;//218;
      BorderStyle := bsNone; Color  := clBlack; Font.Color := clWhite; MaxLength := 12;
      Visible := FALSE; OnKeyPress := EdNewIdKeyPress; OnEnter := EdNewOnEnter;
      Tag := 11;
   end;
   m_EdPhone := TEdit.Create (FrmMain.Owner);   //电话号码
   with m_EdPhone do begin
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 116; //124;
      Left := nx + 161; //263;
      Top  := ny + 348; //285;
      BorderStyle := bsNone;
      Color  := clBlack;
      Font.Color := clWhite;
      MaxLength := 14;
      Visible := FALSE;
      OnKeyPress := EdNewIdKeyPress;
      OnEnter := EdNewOnEnter;
      Tag := 11;
   end;
   m_EdMobPhone := TEdit.Create (FrmMain.Owner);   //移动电话号码
   with m_EdMobPhone do begin             
      Parent := FrmMain;
      Height := 16; //12;
      Width  := 116; //124;
      Left := nx + 161; //263;
      Top  := ny + 368; //315;
      BorderStyle := bsNone;
      Color  := clBlack;
      Font.Color := clWhite;
      MaxLength := 13;
      Visible := FALSE;
      OnKeyPress := EdNewIdKeyPress;
      OnEnter := EdNewOnEnter;
      Tag := 11;
   end;
   m_EdEMail := TEdit.Create (FrmMain.Owner);    //E-Mail
   with m_EdEMail do begin
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 162; //124;
      Left := nx + 161; //263;
      Top  := ny + 387; //368;
      BorderStyle := bsNone;
      Color := clBlack;
      Font.Color := clWhite;
      MaxLength := 40;
      Visible := FALSE;
      OnKeyPress := EdNewIdKeyPress;
      OnEnter := EdNewOnEnter;
      Tag := 11;
   end;

   //登录--修改密码输入 对话框
   nx := SCREENWIDTH div 2 - 210 {192}{192};    //减去对话框图片宽的1/2
   ny := SCREENHEIGHT div 2 - 150 {146}{150};   //减去对话框图片高的1/2
   m_EdChgId := TEdit.Create (FrmMain.Owner);
   with m_EdChgId do begin                      //用户名
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 137; //104;
      Left := nx+ 239; //191;
      Top  := ny+ 118; //92;
      BorderStyle := bsNone;
      Color := clBlack;
      Font.Color := clWhite;
      MaxLength := 10;
      Visible := FALSE;
      OnKeyPress := EdNewIdKeyPress;
      OnEnter := EdNewOnEnter;
      Tag := 12;
   end;

   m_EdChgCurrentpw := TEdit.Create (FrmMain.Owner);      //当前密码
   with m_EdChgCurrentpw do begin
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 137; //104;
      Left := nx+ 239; //191;
      Top  := ny+ 150; //119;
      BorderStyle := bsNone;
      Color := clBlack;
      Font.Color := clWhite;
      MaxLength := 10;
      PasswordChar := '*';
      Visible := FALSE;
      OnKeyPress := EdNewIdKeyPress;
      OnEnter := EdNewOnEnter;
      Tag := 12;
   end;
   m_EdChgNewPw := TEdit.Create (FrmMain.Owner);         //新密码
   with m_EdChgNewPw do begin
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 137; //104;
      Left := nx+ 239; //191;
      Top  := ny+ 177; //145;
      BorderStyle := bsNone;
      Color := clBlack;
      Font.Color := clWhite;
      MaxLength := 10;
      PasswordChar := '*';
      Visible := FALSE;
      OnKeyPress := EdNewIdKeyPress;
      OnEnter := EdNewOnEnter;
      Tag := 12;
   end;
   m_EdChgRepeat := TEdit.Create (FrmMain.Owner);       //重复 密码
   with m_EdChgRepeat do begin
      Parent := FrmMain;
      Height := 16; //13;
      Width  := 137; //104;                                       
      Left := nx+ 239; //191;
      Top  := ny+ 208; //172;
      BorderStyle := bsNone;
      Color := clBlack;
      Font.Color := clWhite;
      MaxLength := 10;
      PasswordChar := '*';
      Visible := FALSE;
      OnKeyPress := EdNewIdKeyPress;
      OnEnter := EdNewOnEnter;
      Tag := 12;
   end;
end;

destructor TLoginScene.Destroy;
begin
   inherited Destroy;
end;

//登陆，用户帐号与密码输入框，位置、大小设定
procedure TLoginScene.OpenScene;
var
   i: integer;
   d: TDirectDrawSurface;
   cx, cy : integer;
begin
   
   cx := SCREENWIDTH div 2 ; //320 {192}{79};
   cy := SCREENHEIGHT div 2 ; //238{146}{64};

   m_nCurFrame := 0;  //登陆进入读取速度
   m_nMaxFrame := 10; //登陆进入读取画面数
   m_sLoginId := '';
   m_sLoginPasswd := '';

   with m_EdId do begin      //登陆ID输入框
      Left   := cx -50;  //255;
      Top    := cy - 42;  //511;
      Height := 16;
      Width  := 112;
      //Visible := FALSE;
   end;
   with m_EdPasswd do begin    //登陆密码输入框
      Left   := cx-50;
      Top    := cy-10;
      Height := 16;
      Width  := 112;
      //Visible := FALSE;
   end;
   m_boOpenFirst := TRUE;

   FrmDlg.DLogin.Visible := TRUE;
   FrmDlg.DNewAccount.Visible := FALSE;
   m_boNowOpening := FALSE;
   PlayBGM (bmg_intro);

end;

procedure TLoginScene.CloseScene;
begin
   m_EdId.Visible := FALSE;
   m_EdPasswd.Visible := FALSE;
   FrmDlg.DLogin.Visible := FALSE;
   SilenceSound;
end;

procedure TLoginScene.EdLoginIdKeyPress (Sender: TObject; var Key: Char);
begin
   if Key = #13 then begin
      Key := #0;
      m_sLoginId := LowerCase(m_EdId.Text);
      if m_sLoginId <> '' then begin
         m_EdPasswd.SetFocus;
      end;
   end;
end;

procedure TLoginScene.EdLoginPasswdKeyPress (Sender: TObject; var Key: Char);
begin
   if (Key = '~') or (Key = '''') then Key := '_';
   if Key = #13 then begin
      Key := #0;
      m_sLoginId := LowerCase(m_EdId.Text);
      m_sLoginPasswd := m_EdPasswd.Text;
      if (m_sLoginId <> '') and (m_sLoginPasswd <> '') then begin
         //拌沥栏肺 肺弊牢 茄促.
         FrmMain.SendLogin (m_sLoginId, m_sLoginPasswd);
         m_EdId.Text := '';
         m_EdPasswd.Text := '';
         m_EdId.Visible := FALSE;
         m_EdPasswd.Visible := FALSE;
      end else
         if (m_EdId.Visible) and (m_EdId.Text = '') then m_EdId.SetFocus;
   end;
end;

procedure TLoginScene.PassWdFail;
begin

   m_EdId.Visible := TRUE;
   m_EdPasswd.Visible := TRUE;
   m_EdId.SetFocus;
end;


function  TLoginScene.NewIdCheckNewId: Boolean;
begin
   Result := TRUE;
   m_EdNewId.Text := Trim(m_EdNewId.Text);
   if Length(m_EdNewId.Text) < 3 then begin
      FrmDlg.DMessageDlg ('登录帐号的长度必须大于3位。', [mbOk]);
      Beep;
      m_EdNewId.SetFocus;
      Result := FALSE;
   end;
end;

function  TLoginScene.NewIdCheckSSno: Boolean;
var
   str, t1, t2, t3, syear, smon, sday: string;
   ayear, amon, aday, sex: integer;
   flag: Boolean;
begin
   Result := TRUE;
   str := m_EdSSNo.Text;
   str := GetValidStr3 (str, t1, ['-']);
   GetValidStr3 (str, t2, ['-']);
   flag := TRUE;
   if (Length(t1) = 6) and (Length(t2) = 7) then begin
      smon := Copy(t1, 3, 2);
      sday := Copy(t1, 5, 2);
      amon := Str_ToInt (smon, 0);
      aday := Str_ToInt (sday, 0);
      if (amon <= 0) or (amon > 12) then flag := FALSE;
      if (aday <= 0) or (aday > 31) then flag := FALSE;
      sex := Str_ToInt (Copy(t2, 1, 1), 0);
      if (sex <= 0) or (sex > 2) then flag := FALSE;
   end else flag := FALSE;
   if not flag then begin
      Beep;
      m_EdSSNo.SetFocus;
      Result := FALSE;
   end;
end;

function  TLoginScene.NewIdCheckBirthDay: Boolean;
var
   str, t1, t2, t3, syear, smon, sday: string;
   ayear, amon, aday, sex: integer;
   flag: Boolean;
begin
   Result := TRUE;
   flag := TRUE;
   str := m_EdBirthDay.Text;
   str := GetValidStr3 (str, syear, ['/']);
   str := GetValidStr3 (str, smon, ['/']);
   str := GetValidStr3 (str, sday, ['/']);
   ayear := Str_ToInt(syear, 0);
   amon := Str_ToInt(smon, 0);
   aday := Str_ToInt(sday, 0);
   if (ayear <= 1890) or (ayear > 2101) then flag := FALSE;
   if (amon <= 0) or (amon > 12) then flag := FALSE;
   if (aday <= 0) or (aday > 31) then flag := FALSE;
   if not flag then begin
      Beep;
      m_EdBirthDay.SetFocus;
      Result := FALSE;
   end;
end;

//车回按键处理
procedure TLoginScene.EdNewIdKeyPress (Sender: TObject; var Key: Char);
var
   str, t1, t2, t3, syear, smon, sday: string;
   ayear, amon, aday, sex: integer;
   flag: Boolean;
begin
   if (Sender = m_EdNewPasswd) or (Sender = m_EdChgNewPw) or (Sender = m_EdChgRepeat) then
      if (Key = '~') or (Key = '''') or (Key = ' ') then Key := #0;
   if Key = #13 then begin
      Key := #0;
      if Sender = m_EdNewId then begin
         if not NewIdCheckNewId then
            exit;
      end;
      if Sender = m_EdNewPasswd then begin
         if Length(m_EdNewPasswd.Text) < 4 then begin
            FrmDlg.DMessageDlg ('密码长度必须大于 4位。', [mbOk]);
            Beep;
            m_EdNewPasswd.SetFocus;
            exit;
         end;
      end;
      if Sender = m_EdConfirm then begin
         if m_EdNewPasswd.Text <> m_EdConfirm.Text then begin
            FrmDlg.DMessageDlg ('二次输入的密码不一至！！！', [mbOk]);
            Beep;
            m_EdConfirm.SetFocus;
            exit;
         end;
      end;

      if (Sender = m_EdYourName) or (Sender = m_EdQuiz1) or (Sender = m_EdAnswer1) or
         (Sender = m_EdQuiz2) or (Sender = m_EdAnswer2) or (Sender = m_EdPhone) or
         (Sender = m_EdMobPhone) or (Sender = m_EdEMail)
      then begin
         TEdit(Sender).Text := Trim(TEdit(Sender).Text);
         if TEdit(Sender).Text = '' then begin
            Beep;
            TEdit(Sender).SetFocus;
            exit;
         end;
      end;

      if (Sender = m_EdSSNo) and (not EnglishVersion) then begin 
         if not NewIdCheckSSno then
            exit;
      end;

      if Sender = m_EdBirthDay then begin
         if not NewIdCheckBirthDay then
            exit;
      end;

      if TEdit(Sender).Text <> '' then begin
         //帐号注册按键焦点处理
         if Sender = m_EdNewId then m_EdNewPasswd.SetFocus;
         if Sender = m_EdNewPasswd then m_EdConfirm.SetFocus;
         if Sender = m_EdConfirm then m_EdYourName.SetFocus;

         //如果是英文版本，则跳过身份证号
         if not EnglishVersion  then begin
            if Sender = m_EdYourName  then  m_EdSSNo.SetFocus;
            if Sender = m_EdSSNo then m_EdBirthDay.SetFocus;
          end else begin
              if (Sender = m_EdYourName ) then  m_EdBirthDay.SetFocus;
          end;
         
         if Sender = m_EdBirthDay then m_EdQuiz1.SetFocus;
         if Sender = m_EdQuiz1 then m_EdAnswer1.SetFocus;
         if Sender = m_EdAnswer1 then m_EdQuiz2.SetFocus;
         if Sender = m_EdQuiz2 then m_EdAnswer2.SetFocus;
         if Sender = m_EdAnswer2 then m_EdPhone.SetFocus;
         if Sender = m_EdPhone then m_EdMobPhone.SetFocus;
         if Sender = m_EdMobPhone then m_EdEMail.SetFocus;
         if Sender = m_EdEMail then begin
            if m_EdNewId.Enabled then m_EdNewId.SetFocus
            else if m_EdNewPasswd.Enabled then m_EdNewPasswd.SetFocus;
         end;

         //修改密码按键焦点处理
         if Sender = m_EdChgId then m_EdChgCurrentpw.SetFocus;
         if Sender = m_EdChgCurrentpw then m_EdChgNewPw.SetFocus;
         if Sender = m_EdChgNewPw then m_EdChgRepeat.SetFocus;
         if Sender = m_EdChgRepeat then m_EdChgId.SetFocus;
      end;
   end;
end;

procedure TLoginScene.EdNewOnEnter (Sender: TObject);
var
   hx, hy: integer;
begin
   //登录显示
   FrmDlg.NAHelps.Clear;
   hx := TEdit(Sender).Left + TEdit(Sender).Width + 10;
   hy := TEdit(Sender).Top + TEdit(Sender).Height +116; //18;
   if Sender = m_EdNewId then begin
      FrmDlg.NAHelps.Add ('登录ID可以是以下内容组合：');
      FrmDlg.NAHelps.Add ('字母或数字。');
      FrmDlg.NAHelps.Add ('长度至少是3位。');
      FrmDlg.NAHelps.Add ('不能和其他玩家的登录ID重复。');
      FrmDlg.NAHelps.Add ('请仔细选择你的ID。');
      FrmDlg.NAHelps.Add ('你的ID可以用与我们的所有服务器。');
      FrmDlg.NAHelps.Add ('');
   end;
   if Sender = m_EdNewPasswd then begin
      FrmDlg.NAHelps.Add ('密码至少4位，由字母或数字组成。');
      FrmDlg.NAHelps.Add ('我们建议你：');
      FrmDlg.NAHelps.Add ('最好不要用一个简单的密码。');
      FrmDlg.NAHelps.Add ('以消除一些不安全因素。');
      FrmDlg.NAHelps.Add ('');
   end;
   if Sender = m_EdConfirm then begin
      FrmDlg.NAHelps.Add ('重新输入一遍密码：');
      FrmDlg.NAHelps.Add ('两次输入的密码必须一致。');
      FrmDlg.NAHelps.Add ('');
   end;
   if Sender = m_EdYourName then begin
      FrmDlg.NAHelps.Add ('你的真实姓名。');
      FrmDlg.NAHelps.Add ('');
   end;
   if Sender = m_EdSSNo then begin
      FrmDlg.NAHelps.Add ('身份证号码');
      FrmDlg.NAHelps.Add ('必须输入真实的身份证号码。');
      FrmDlg.NAHelps.Add ('');
   end;
   if Sender = m_EdBirthDay then begin
      FrmDlg.NAHelps.Add ('输入您的生日，');
      FrmDlg.NAHelps.Add ('例如 1977/10/15');
      FrmDlg.NAHelps.Add ('');
   end;
   if (Sender = m_EdQuiz1) or (Sender = m_EdQuiz2) then begin
      FrmDlg.NAHelps.Add ('请输入一个密码问题');
      FrmDlg.NAHelps.Add ('请明确只有你本人才知道这个问题。');
      FrmDlg.NAHelps.Add ('');
   end;
   if (Sender = m_EdAnswer1) or (Sender = m_EdAnswer2) then begin
      FrmDlg.NAHelps.Add ('请输入一个问题的回答');
      FrmDlg.NAHelps.Add ('请明确只有你本人才知道这个答案。');
      FrmDlg.NAHelps.Add ('');
   end;
   if (Sender=m_EdYourName) or (Sender=m_EdSSNo) or (Sender=m_EdQuiz1) or (Sender=m_EdQuiz2) or (Sender=m_EdAnswer1) or (Sender=m_EdAnswer2) then begin
      FrmDlg.NAHelps.Add ('请认证填写问题：');
      FrmDlg.NAHelps.Add ('这将会是我们帮你找回密码');
      FrmDlg.NAHelps.Add ('的一条重要途径，');
      FrmDlg.NAHelps.Add ('请写你自己好记的问题。');
      FrmDlg.NAHelps.Add ('');
   end;

   if Sender = m_EdPhone then begin
      FrmDlg.NAHelps.Add ('输入你的电话号码：');
      FrmDlg.NAHelps.Add ('例如 001-88888888');
      FrmDlg.NAHelps.Add ('');
   end;
   if Sender = m_EdMobPhone then begin
      FrmDlg.NAHelps.Add ('请输入你的手机号码：');
      FrmDlg.NAHelps.Add ('');
   end;
   if Sender = m_EdEMail then begin
      FrmDlg.NAHelps.Add ('请输入你的邮箱地址。');
      FrmDlg.NAHelps.Add ('注意：');
      FrmDlg.NAHelps.Add ('该邮箱地址将回成为你找回密码');
      FrmDlg.NAHelps.Add ('的唯一邮箱.请认真填写。');
      FrmDlg.NAHelps.Add ('');
   end;
end;

procedure TLoginScene.HideLoginBox;
begin
   //EdId.Visible := FALSE;
   //EdPasswd.Visible := FALSE;
   //FrmDlg.DLogin.Visible := FALSE;
   ChangeLoginState (lsCloseAll);
end;

procedure TLoginScene.OpenLoginDoor;
begin
   m_boNowOpening := TRUE;
   m_dwStartTime := GetTickCount;
   HideLoginBox;
   PlaySound (s_rock_door_open);
end;

//播放块景动画
procedure TLoginScene.PlayScene (MSurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   if m_boOpenFirst then begin
      m_boOpenFirst := FALSE;
      m_EdId.Visible := TRUE;
      m_EdPasswd.Visible := TRUE;
      m_EdId.SetFocus;
   end;
   //登陆画面相关
{$IF CUSTOMLIBFILE = 1}
   d := g_WMainImages.Images[83{102-80}];
{$ELSE}
   d := g_WChrSelImages.Images[102-80];
{$IFEND}
   if d <> nil then begin
      MSurface.Draw ((SCREENWIDTH - 800) div 2, (SCREENHEIGHT - 600) div 2, d.ClientRect, d, FALSE);
   end;
   if m_boNowOpening then begin
      //if GetTickCount - StartTime > 230 then begin
//开门速度
      if GetTickCount - m_dwStartTime > 300 then begin   //300
         m_dwStartTime := GetTickCount;
         Inc (m_nCurFrame);
      end;
      if m_nCurFrame >= m_nMaxFrame-1 then begin
         m_nCurFrame := m_nMaxFrame-1;
         if not g_boDoFadeOut and not g_boDoFadeIn then begin
            g_boDoFadeOut := TRUE;
            g_boDoFadeIn := TRUE;
            g_nFadeIndex := 29;
         end;
      end;
{$IF CUSTOMLIBFILE = 1}
      d := g_WMainImages.Images[m_nCurFrame+84{103 + CurFrame-80}];
{$ELSE}
      d := g_WChrSelImages.Images[103 + m_nCurFrame-80];
{$IFEND}
      //开门相关. 开门动画
      if d <> nil then
        // MSurface.Draw ((SCREENWIDTH - 800) div 2 + 252{152}, (SCREENHEIGHT - 600) div 2 + 106{96}, d.ClientRect, d, TRUE);
         MSurface.Draw ((SCREENWIDTH - d.Width) div 2 +1, (SCREENHEIGHT - d.Height) div 2 - 23 , d.ClientRect, d, TRUE);   //Midified by Davy 2019-11-13

      if g_boDoFadeOut then begin
         if g_nFadeIndex <= 1 then begin
            g_WMainImages.ClearCache;
            g_WChrSelImages.ClearCache;
            DScreen.ChangeScene (stSelectChr); //
         end;
      end;
   end; 
end;

//改变注册状态
procedure TLoginScene.ChangeLoginState (state: TLoginState);
var
   i, focus: integer;
   c: TControl;
begin
   focus := -1;
   case state of
      lsLogin: focus := 10;
      lsNewIdRetry, lsNewId: focus := 11;
      lsChgpw: focus := 12;
      lsCloseAll: focus := -1;
   end;
   with FrmMain do begin  //login
      for i:=0 to ControlCount-1 do begin
         c := Controls[i];
         if c is TEdit then begin
            if c.Tag in [10..12] then begin
               if c.Tag = focus then begin
                  c.Visible := TRUE;
                  TEdit(c).Text := '';
               end else begin
                  c.Visible := FALSE;
                  TEdit(c).Text := '';
               end;
            end;
         end;
      end;

      //如果是英文版身份证号不可用
      if EnglishVersion then  
         m_EdSSNo.Visible := FALSE;

      case state of
         lsLogin:
            begin
               FrmDlg.DNewAccount.Visible := FALSE;
               FrmDlg.DChgPw.Visible := FALSE;
               FrmDlg.DLogin.Visible := TRUE;              
               if m_EdId.Visible then m_EdId.SetFocus;
            end;
         lsNewIdRetry,
         lsNewId:
            begin
               if m_boUpdateAccountMode then
                  m_EdNewId.Enabled := FALSE
               else
                  m_EdNewId.Enabled := TRUE;
               FrmDlg.DNewAccount.Visible := TRUE;
               FrmDlg.DChgPw.Visible := FALSE;
               FrmDlg.DLogin.Visible := FALSE;
               if m_EdNewId.Visible and m_EdNewId.Enabled then begin
                  m_EdNewId.SetFocus;
               end else begin
                  if m_EdConfirm.Visible and m_EdConfirm.Enabled then
                     m_EdConfirm.SetFocus;
               end;
            end;
         lsChgpw:
            begin
               FrmDlg.DNewAccount.Visible := FALSE;
               FrmDlg.DChgPw.Visible := TRUE;
               FrmDlg.DLogin.Visible := FALSE;
               if m_EdChgId.Visible then m_EdChgId.SetFocus;
            end;
         lsCloseAll:
            begin
               FrmDlg.DNewAccount.Visible := FALSE;
               FrmDlg.DChgPw.Visible := FALSE;
               FrmDlg.DLogin.Visible := FALSE;
            end;
      end;
   end;
end;

procedure TLoginScene.NewClick;
begin
   m_boUpdateAccountMode := FALSE;
   FrmDlg.NewAccountTitle := '';
   ChangeLoginState (lsNewId);
end;

procedure TLoginScene.NewIdRetry (boupdate: Boolean);
begin
   m_boUpdateAccountMode := boupdate;
   ChangeLoginState (lsNewidRetry);
   m_EdNewId.Text     := m_NewIdRetryUE.sAccount;
   m_EdNewPasswd.Text := m_NewIdRetryUE.sPassword;
   m_EdYourName.Text  := m_NewIdRetryUE.sUserName;
   m_EdSSNo.Text      := m_NewIdRetryUE.sSSNo;
   m_EdQuiz1.Text     := m_NewIdRetryUE.sQuiz;
   m_EdAnswer1.Text   := m_NewIdRetryUE.sAnswer;
   m_EdPhone.Text     := m_NewIdRetryUE.sPhone;
   m_EdEMail.Text     := m_NewIdRetryUE.sEMail;
   m_EdQuiz2.Text     := m_NewIdRetryAdd.sQuiz2;
   m_EdAnswer2.Text   := m_NewIdRetryAdd.sAnswer2;
   m_EdMobPhone.Text  := m_NewIdRetryAdd.sMobilePhone;
   m_EdBirthDay.Text  := m_NewIdRetryAdd.sBirthDay;
end;

procedure TLoginScene.UpdateAccountInfos (ue: TUserEntry);
begin
   m_NewIdRetryUE := ue;
   FillChar (m_NewIdRetryAdd, sizeof(TUserEntryAdd), #0);
   m_boUpdateAccountMode := TRUE; //扁粮俊 乐绰 沥焊甫 犁涝仿窍绰 版快
   NewIdRetry (TRUE);
   FrmDlg.NewAccountTitle := '(请完成帐户信息的所有必需的领域...)';
end;

procedure TLoginScene.OkClick;
var
   key: char;
begin
   key := #13; //CR (回车) ASCII
   EdLoginPasswdKeyPress (self, key);
end;

procedure TLoginScene.ChgPwClick;
begin
   ChangeLoginState (lsChgPw);
end;

function  TLoginScene.CheckUserEntrys: Boolean;
begin
   Result := FALSE;
   m_EdNewId.Text := Trim(m_EdNewId.Text);
   m_EdQuiz1.Text := Trim(m_EdQuiz1.Text);
   m_EdYourName.Text := Trim(m_EdYourName.Text);
   if not NewIdCheckNewId then exit;

   if not EnglishVersion then begin 
      if not NewIdCheckSSNo then 
         exit;
   end;

   if not NewIdCheckBirthday then exit;
   if Length(m_EdNewId.Text) < 3 then begin
      m_EdNewId.SetFocus;
      exit;
   end;
   if Length(m_EdNewPasswd.Text) < 3 then begin
      m_EdNewPasswd.SetFocus;
      exit;
   end;
   if m_EdNewPasswd.Text <> m_EdConfirm.Text then begin
      m_EdConfirm.SetFocus;
      exit;
   end;
   if Length(m_EdQuiz1.Text) < 1 then begin
      m_EdQuiz1.SetFocus;
      exit;
   end;
   if Length(m_EdAnswer1.Text) < 1 then begin
      m_EdAnswer1.SetFocus;
      exit;
   end;
   if Length(m_EdQuiz2.Text) < 1 then begin
      m_EdQuiz2.SetFocus;
      exit;
   end;
   if Length(m_EdAnswer2.Text) < 1 then begin
      m_EdAnswer2.SetFocus;
      exit;
   end;
   if Length(m_EdYourName.Text) < 1 then begin
      m_EdYourName.SetFocus;
      exit;
   end;
   if not EnglishVersion then begin //
      if Length(m_EdSSNo.Text) < 1 then begin
         m_EdSSNo.SetFocus;
         exit;
      end;
   end;
   Result := TRUE;
end;

procedure TLoginScene.NewAccountOk;
var
   ue: TUserEntry;
   ua: TUserEntryAdd;
begin
   if CheckUserEntrys then begin
      FillChar (ue, sizeof(TUserEntry), #0);
      FillChar (ua, sizeof(TUserEntryAdd), #0);
      ue.sAccount := LowerCase(m_EdNewId.Text);
      ue.sPassword := m_EdNewPasswd.Text;
      ue.sUserName := m_EdYourName.Text;
      //
      if not EnglishVersion then
         ue.sSSNo := m_EdSSNo.Text
      else
         ue.sSSNo := '666666-8888888';
         //ue.sSSNo := '650101-1455111';

      ue.sQuiz := m_EdQuiz1.Text;
      ue.sAnswer := Trim(m_EdAnswer1.Text);
      ue.sPhone := m_EdPhone.Text;
      ue.sEMail := Trim(m_EdEMail.Text);

      ua.sQuiz2 := m_EdQuiz2.Text;
      ua.sAnswer2 := Trim(m_EdAnswer2.Text);
      ua.sBirthday := m_EdBirthDay.Text;
      ua.sMobilePhone := m_EdMobPhone.Text;

      m_NewIdRetryUE := ue;    //犁矫档锭 荤侩
      m_NewIdRetryUE.sAccount := '';
      m_NewIdRetryUE.sPassword := '';
      m_NewIdRetryAdd := ua;

      if not m_boUpdateAccountMode then
         FrmMain.SendNewAccount (ue, ua)
      else
         FrmMain.SendUpdateAccount (ue, ua);
      m_boUpdateAccountMode := FALSE;
      NewAccountClose;
   end;
end;

procedure TLoginScene.NewAccountClose;
begin
   if not m_boUpdateAccountMode then
      ChangeLoginState (lsLogin);
end;

procedure TLoginScene.ChgpwOk;
var
   uid, passwd, newpasswd: string;
begin
   if m_EdChgNewPw.Text = m_EdChgRepeat.Text then begin
      uid := m_EdChgId.Text;
      passwd := m_EdChgCurrentpw.Text;
      newpasswd := m_EdChgNewPw.Text;
      FrmMain.SendChgPw (uid, passwd, newpasswd);
      ChgpwCancel;
   end else begin
      FrmDlg.DMessageDlg ('密码确认不是正确的。', [mbOk]);
      m_EdChgNewPw.SetFocus;
   end;
end;

procedure TLoginScene.ChgpwCancel;
begin
   ChangeLoginState (lsLogin);
end;


{-------------------- TSelectChrScene ------------------------}
//选择角色
constructor TSelectChrScene.Create;
begin
   CreateChrMode := FALSE;
   FillChar (ChrArr, sizeof(TSelChar)*2, #0);
   ChrArr[0].FreezeState := TRUE; //登陆人物填写
   ChrArr[1].FreezeState := TRUE;
   NewIndex := 0;
   EdChrName := TEdit.Create (FrmMain.Owner);
   with EdChrName do begin
      Parent := FrmMain;
      Height := 16; //21;
      Width  := 137; //129;
      BorderStyle := bsNone;
      Color := clBlack;
      Font.Color := clWhite;
      ImeMode := LocalLanguage;
      MaxLength := 14;
      Visible := FALSE;
      OnKeyPress := EdChrnameKeyPress;
   end;
   SoundTimer := TTimer.Create (FrmMain.Owner);
   with SoundTimer do begin
      OnTimer := SoundOnTimer;
      Interval := 1;
      Enabled := FALSE;
   end;
   inherited Create (stSelectChr);
end;

destructor TSelectChrScene.Destroy;
begin
   inherited Destroy;
end;

procedure TSelectChrScene.OpenScene;
begin
   FrmDlg.DSelectChr.Visible := TRUE;
   SoundTimer.Enabled := TRUE;
   SoundTimer.Interval := 1;
end;

procedure TSelectChrScene.CloseScene;
begin
   SilenceSound;
   FrmDlg.DSelectChr.Visible := FALSE;
   SoundTimer.Enabled := FALSE;
end;

procedure TSelectChrScene.SoundOnTimer (Sender: TObject);
begin
   PlayBGM (bmg_select);
   SoundTimer.Enabled := FALSE;
   //SoundTimer.Interval := 38 * 1000;
end;

procedure TSelectChrScene.SelChrSelect1Click;
begin
   if (not ChrArr[0].Selected) and (ChrArr[0].Valid) then begin
      FrmMain.SelectChr(ChrArr[0].UserChr.Name);//2004/05/17
      ChrArr[0].Selected := TRUE;
      ChrArr[1].Selected := FALSE;
      ChrArr[0].Unfreezing := TRUE;
      ChrArr[0].AniIndex := 0;
      ChrArr[0].DarkLevel := 0;
      ChrArr[0].EffIndex := 0;
      ChrArr[0].StartTime := GetTickCount;
      ChrArr[0].MoreTime := GetTickCount;
      ChrArr[0].StartEffTime := GetTickCount;
      PlaySound (s_meltstone);
   end;
end;

procedure TSelectChrScene.SelChrSelect2Click;
begin
   if (not ChrArr[1].Selected) and (ChrArr[1].Valid) then begin
      FrmMain.SelectChr(ChrArr[1].UserChr.Name);//2004/05/17
      ChrArr[1].Selected := TRUE;
      ChrArr[0].Selected := FALSE;
      ChrArr[1].Unfreezing := TRUE;
      ChrArr[1].AniIndex := 0;
      ChrArr[1].DarkLevel := 0;
      ChrArr[1].EffIndex := 0;
      ChrArr[1].StartTime := GetTickCount;
      ChrArr[1].MoreTime := GetTickCount;
      ChrArr[1].StartEffTime := GetTickCount;
      PlaySound (s_meltstone);
   end;
end;

procedure TSelectChrScene.SelChrStartClick;
var
   chrname: string;
begin
   chrname := '';
   if ChrArr[0].Valid and ChrArr[0].Selected then chrname := ChrArr[0].UserChr.Name;
   if ChrArr[1].Valid and ChrArr[1].Selected then chrname := ChrArr[1].UserChr.Name;
   if chrname <> '' then begin
      if not g_boDoFadeOut and not g_boDoFadeIn then begin
         g_boDoFastFadeOut := TRUE;
         g_nFadeIndex := 29;
      end;
      FrmMain.SendSelChr (chrname);
   end else
      FrmDlg.DMessageDlg ('一开始你应该创建一个新角色。\，如果你选择了<创建角色>你就可以建立一个新角色了 .', [mbOk]);
end;

procedure TSelectChrScene.SelChrNewChrClick;
begin
   if not ChrArr[0].Valid or not ChrArr[1].Valid then begin
      if not ChrArr[0].Valid then MakeNewChar (0)
      else MakeNewChar (1);
   end else
      FrmDlg.DMessageDlg ('每个账号只能创建两个角色！！！', [mbOk]);
end;

//删除角色对话框
procedure TSelectChrScene.SelChrEraseChrClick;
var
   n: integer;
begin
   n := 0;
   if ChrArr[0].Valid and ChrArr[0].Selected then n := 0;
   if ChrArr[1].Valid and ChrArr[1].Selected then n := 1;
   if (ChrArr[n].Valid) and (not ChrArr[n].FreezeState) and (ChrArr[n].UserChr.Name <> '') then begin
      //删除角色.
      if mrYes = FrmDlg.DMessageDlg ('"' + ChrArr[n].UserChr.Name + '" 删除角色是不可以恢复的.\' +
                                                                    '一段时间内，你将不可以使用相同的角色名字.\' +
                                                                    '你真的想删除角色吗?', [mbYes, mbNo, mbCancel]) then
         FrmMain.SendDelChr (ChrArr[n].UserChr.Name);
   end;
end;

procedure TSelectChrScene.SelChrCreditsClick;
begin
end;

procedure TSelectChrScene.SelChrExitClick;
begin
   FrmMain.Close;
end;

procedure TSelectChrScene.ClearChrs;
begin
   FillChar (ChrArr, sizeof(TSelChar)*2, #0);
   ChrArr[0].FreezeState := FALSE;
   ChrArr[1].FreezeState := TRUE; //人物出现相关
   ChrArr[0].Selected := TRUE;
   ChrArr[1].Selected := FALSE;
   ChrArr[0].UserChr.Name := '';
   ChrArr[1].UserChr.Name := '';
end;

procedure TSelectChrScene.AddChr (uname: string; job, hair, level, sex: integer);
var
   n: integer;
begin
   if not ChrArr[0].Valid then n := 0
   else if not ChrArr[1].Valid then n := 1
   else exit;
   ChrArr[n].UserChr.Name := uname;
   ChrArr[n].UserChr.Job := job;
   ChrArr[n].UserChr.Hair := hair;
   ChrArr[n].UserChr.Level := level;
   ChrArr[n].UserChr.Sex := sex;
   ChrArr[n].Valid := TRUE;
end;

//创建新角色
procedure TSelectChrScene.MakeNewChar (index: integer);
begin
   CreateChrMode := TRUE;
   NewIndex := index;

   //调轩创建角色对话框位置
   if index = 0 then begin
      FrmDlg.DCreateChr.Left := 420; //469;
      FrmDlg.DCreateChr.Top := 15; //63; //////****选择人物筐;
   end else begin
      FrmDlg.DCreateChr.Left := 70; //87;
      FrmDlg.DCreateChr.Top := 15; //63;   //////****选择人物筐;
   end;
   
   FrmDlg.DCreateChr.Visible := TRUE;
   ChrArr[NewIndex].Valid := TRUE;
   ChrArr[NewIndex].FreezeState := FALSE;
   EdChrName.Left := FrmDlg.DCreateChr.Left + 71; //63;   //////****选择人物筐名字;
   EdChrName.Top  := FrmDlg.DCreateChr.Top + 107; //79;
   EdChrName.Visible := TRUE;
   EdChrName.SetFocus;
   SelectChr (NewIndex);
   FillChar (ChrArr[NewIndex].UserChr, sizeof(TUserCharacterInfo), #0);
end;

procedure TSelectChrScene.EdChrnameKeyPress (Sender: TObject; var Key: Char);
begin

end;


procedure TSelectChrScene.SelectChr (index: integer);
begin
   ChrArr[index].Selected := TRUE;
   ChrArr[index].DarkLevel := 30;
   ChrArr[index].StartTime := GetTickCount;
   ChrArr[index].Moretime := GetTickCount;
   if index = 0 then ChrArr[1].Selected := FALSE
   else ChrArr[0].Selected := FALSE;
end;

procedure TSelectChrScene.SelChrNewClose;
begin
   ChrArr[NewIndex].Valid := FALSE;
   CreateChrMode := FALSE;
   FrmDlg.DCreateChr.Visible := FALSE;
   EdChrName.Visible := FALSE;
   if NewIndex = 1 then begin
      ChrArr[0].Selected := TRUE;
      ChrArr[0].FreezeState := FALSE;
   end;
end;

procedure TSelectChrScene.SelChrNewOk;
var
   chrname, shair, sjob, ssex: string;
begin
   chrname := Trim(EdChrName.Text);
   if chrname <> '' then begin
      ChrArr[NewIndex].Valid := FALSE;
      CreateChrMode := FALSE;
      FrmDlg.DCreateChr.Visible := FALSE;
      EdChrName.Visible := FALSE;
      if NewIndex = 1 then begin
         ChrArr[0].Selected := TRUE;
         ChrArr[0].FreezeState := FALSE;
      end;
      shair := IntToStr(1 + Random(5)); //////****IntToStr(ChrArr[NewIndex].UserChr.Hair);
      sjob  := IntToStr(ChrArr[NewIndex].UserChr.Job);
      ssex  := IntToStr(ChrArr[NewIndex].UserChr.Sex);
      FrmMain.SendNewChr (FrmMain.LoginId, chrname, shair, sjob, ssex); //货 某腐磐甫 父电促.
   end;
end;

procedure TSelectChrScene.SelChrNewJob (job: integer);
begin
   if (job in [0..2]) and (ChrArr[NewIndex].UserChr.Job <> job) then begin
      ChrArr[NewIndex].UserChr.Job := job;
      SelectChr (NewIndex);
   end;
end;

procedure TSelectChrScene.SelChrNewm_btSex (sex: integer);
begin
   if sex <> ChrArr[NewIndex].UserChr.Sex then begin
      ChrArr[NewIndex].UserChr.Sex := sex;
      SelectChr (NewIndex);
   end;
end;

procedure TSelectChrScene.SelChrNewPrevHair;
begin
end;

procedure TSelectChrScene.SelChrNewNextHair;
begin
end;

//选择角色场景(显示角色形象、名称、等级、职业)
procedure TSelectChrScene.PlayScene (MSurface: TDirectDrawSurface);
var
   n, bx, by, fx, fy, img: integer;
   ex, ey:Integer; //选择人物时显示的效果光位置
   d, e, dd: TDirectDrawSurface;
   svname: string;
begin
   bx:=0;
   by:=0;
   fx:=0;
   fy:=0;//Jacky
{$IF SWH = SWH800}
   d := g_WMainImages.Images[65];
{$ELSEIF SWH = SWH1024}
//   d := g_WMainImages.Images[82];
   d := g_WMainImages.Images[65];
{$IFEND}
   //显示选择人物背景画面
   if d <> nil then begin
//      MSurface.Draw (0, 0, d.ClientRect, d, FALSE);
      MSurface.Draw ((SCREENWIDTH - d.Width) div 2,(SCREENHEIGHT - d.Height) div 2, d.ClientRect, d, FALSE);

   end;

   for n:=0 to 1 do begin
      if ChrArr[n].Valid then begin
         ex := (SCREENWIDTH - 800) div 2 + 90{90};
         ey := (SCREENHEIGHT - 600) div 2 + 60-2{60-2};//  效果光位置
         case ChrArr[n].UserChr.Job of
            0: begin
               if ChrArr[n].UserChr.Sex = 0 then begin
                  bx := (SCREENWIDTH - 800) div 2 + 71{71};
                  by := (SCREENHEIGHT - 600) div 2 + 75-23{75-23}; //人物位置
                  fx := bx;
                  fy := by;
               end else begin
                  bx := (SCREENWIDTH - 800) div 2 + 65{65};
                  by := (SCREENHEIGHT - 600) div 2 + 75-2-18{75-2-18};  //
                  fx := bx-28+28;
                  fy := by-16+16;    //
               end;
            end;
            1: begin
               if ChrArr[n].UserChr.Sex = 0 then begin
                  bx := (SCREENWIDTH - 800) div 2 + 77{77};
                  by := (SCREENHEIGHT - 600) div 2 + 75-29{75-29};
                  fx := bx;
                  fy := by;
               end else begin
                  bx := (SCREENWIDTH - 800) div 2 + 141+30{141+30};
                  by := (SCREENHEIGHT - 600) div 2 + 85+14-2{85+14-2}; //2人物位置
                  fx := bx-30;
                  fy := by-14;
               end;
            end;
            2: begin
               if ChrArr[n].UserChr.Sex = 0 then begin
                  bx := (SCREENWIDTH - 800) div 2 + 85{85};
                  by := (SCREENHEIGHT - 600) div 2 + 75-12{75-12};
                  fx := bx;
                  fy := by;
               end else begin
                  bx := (SCREENWIDTH - 800) div 2 + 141+23{141+23};
                  by := (SCREENHEIGHT - 600) div 2 + 85+20-2{85+20-2};
                  fx := bx-23;
                  fy := by-20;
               end;
            end;
         end;
         if n = 1 then begin
            ex := (SCREENWIDTH - 800) div 2 + 430{430};   //  2效果光位置
            ey := (SCREENHEIGHT - 600) div 2 + 60{60};
            bx := bx + 340;
            by := by + 2;   //2人物位置石化
            fx := fx + 340;
            fy := fy + 2;    //2人物位置不石化
         end;
         if ChrArr[n].Unfreezing then begin //人物相关 ，非石化时
            img := 140 - 80 + ChrArr[n].UserChr.Job * 40 + ChrArr[n].UserChr.Sex * 120;
            d := g_WChrSelImages.Images[img + ChrArr[n].aniIndex];
            e := g_WChrSelImages.Images[4 + ChrArr[n].effIndex]; //图片张数
            if d <> nil then MSurface.Draw (bx, by, d.ClientRect, d, TRUE); //绘人物 （解石化）
            if e <> nil then DrawBlend (MSurface, ex, ey, e, 1);            //绘效果光

            if GetTickCount - ChrArr[n].StartTime > 50{120} then begin
               ChrArr[n].StartTime := GetTickCount;
               ChrArr[n].aniIndex := ChrArr[n].aniIndex + 1;
            end;
            
            if GetTickCount - ChrArr[n].startefftime >50{ 110} then begin
               ChrArr[n].startefftime := GetTickCount;
               ChrArr[n].effIndex := ChrArr[n].effIndex + 1;
               
               //if ChrArr[n].effIndex > EFFECTFRAME-1 then
               //   ChrArr[n].effIndex := EFFECTFRAME-1;
            end;
            
            if ChrArr[n].aniIndex > FREEZEFRAME-1 then begin
               ChrArr[n].Unfreezing := FALSE;
               ChrArr[n].FreezeState := FALSE;
               ChrArr[n].aniIndex := 0;
            end;

         end else
            if not ChrArr[n].Selected and (not ChrArr[n].FreezeState and not ChrArr[n].Freezing) then begin //
               ChrArr[n].Freezing := TRUE;
               ChrArr[n].aniIndex := 0;
               ChrArr[n].StartTime := GetTickCount;
            end;
         if ChrArr[n].Freezing then begin //选择时不见
            img := 140 - 80 + ChrArr[n].UserChr.Job * 40 + ChrArr[n].UserChr.Sex * 120;
            d := g_WChrSelImages.Images[img + FREEZEFRAME - ChrArr[n].aniIndex - 1];
            if d <> nil then MSurface.Draw (bx, by, d.ClientRect, d, TRUE);
            if GetTickCount - ChrArr[n].StartTime > 50 then begin
               ChrArr[n].StartTime := GetTickCount;
               ChrArr[n].aniIndex := ChrArr[n].aniIndex + 1;
            end;
            if ChrArr[n].aniIndex > FREEZEFRAME-1 then begin
               ChrArr[n].Freezing := FALSE; //
               ChrArr[n].FreezeState := TRUE; //
               ChrArr[n].aniIndex := 0;
            end;
         end;
         if not ChrArr[n].Unfreezing and not ChrArr[n].Freezing then begin
            if not ChrArr[n].FreezeState then begin  //选择人物不见
               img := 120 - 80 + ChrArr[n].UserChr.Job * 40 + ChrArr[n].aniIndex + ChrArr[n].UserChr.Sex * 120;
               d := g_WChrSelImages.Images[img];
               if d <> nil then begin
                  if ChrArr[n].DarkLevel > 0 then begin
                     dd := TDirectDrawSurface.Create (frmMain.DXDraw.DDraw);
                     dd.SystemMemory := TRUE;
                     dd.SetSize (d.Width, d.Height);
                     dd.Draw (0, 0, d.ClientRect, d, FALSE);
                     MakeDark (dd, 30-ChrArr[n].DarkLevel);
                     MSurface.Draw (fx, fy, dd.ClientRect, dd, TRUE);
                     dd.Free;
                  end else
                     MSurface.Draw (fx, fy, d.ClientRect, d, TRUE);

               end;
            end else begin      //选择第2人物不见
               img := 140 - 80 + ChrArr[n].UserChr.Job * 40 + ChrArr[n].UserChr.Sex * 120;
               d := g_WChrSelImages.Images[img];
               if d <> nil then
                  MSurface.Draw (bx, by, d.ClientRect, d, TRUE);
            end;
            if ChrArr[n].Selected then begin
               if GetTickCount - ChrArr[n].StartTime > 300 then begin
                  ChrArr[n].StartTime := GetTickCount;
                  ChrArr[n].aniIndex := ChrArr[n].aniIndex + 1;
                  if ChrArr[n].aniIndex > SELECTEDFRAME-1 then
                     ChrArr[n].aniIndex := 0;
               end;
               if GetTickCount - ChrArr[n].moretime > 25 then begin
                  ChrArr[n].moretime := GetTickCount;
                  if ChrArr[n].DarkLevel > 0 then
                     ChrArr[n].DarkLevel := ChrArr[n].DarkLevel - 1;
               end;
            end;
         end;
         //显示选择角色时人物名称等级
         if n = 0 then begin             //左边角色
            if ChrArr[n].UserChr.Name <> '' then begin
               with MSurface do begin
                  SetBkMode (Canvas.Handle, TRANSPARENT);
                  BoldTextOut (MSurface, (SCREENWIDTH - 800) div 2 + 117, (SCREENHEIGHT - 600) div 2 + 493, clWhite, clBlack, ChrArr[n].UserChr.Name);          //名称
                  BoldTextOut (MSurface, (SCREENWIDTH - 800) div 2 + 117, (SCREENHEIGHT - 600) div 2 + 522, clWhite, clBlack, IntToStr(ChrArr[n].UserChr.Level)); //等级
                  BoldTextOut (MSurface, (SCREENWIDTH - 800) div 2 + 117, (SCREENHEIGHT - 600) div 2 + 552, clWhite, clBlack, GetJobName(ChrArr[n].UserChr.Job)); //职业
                  Canvas.Release;
               end;
            end;
         end else begin                   //右边角色
            if ChrArr[n].UserChr.Name <> '' then begin
               with MSurface do begin
                  SetBkMode (Canvas.Handle, TRANSPARENT);
                  BoldTextOut (MSurface, (SCREENWIDTH - 800) div 2 + 671, (SCREENHEIGHT - 600) div 2 + 495, clWhite, clBlack, ChrArr[n].UserChr.Name);          //名称
                  BoldTextOut (MSurface, (SCREENWIDTH - 800) div 2 + 671, (SCREENHEIGHT - 600) div 2 + 524, clWhite, clBlack, IntToStr(ChrArr[n].UserChr.Level)); //等级
                  BoldTextOut (MSurface, (SCREENWIDTH - 800) div 2 + 671, (SCREENHEIGHT - 600) div 2 + 554, clWhite, clBlack, GetJobName(ChrArr[n].UserChr.Job)); //职业
                  Canvas.Release;
               end;
            end;
         end;
         with MSurface do begin
            SetBkMode (Canvas.Handle, TRANSPARENT);
            if BO_FOR_TEST then svname := '服务器名字'
            else svname := g_sServerName;
            BoldTextOut (MSurface, SCREENWIDTH div 2{405} - Canvas.TextWidth(svname) div 2, (SCREENHEIGHT - 600) div 2 + 7{8}, clWhite, clBlack, svname);
            Canvas.Release;
         end;
      end;
   end;
end;


{--------------------------- TLoginNotice ----------------------------}
//登录注意提示
constructor TLoginNotice.Create;
begin
   inherited Create (stLoginNotice);
end;

destructor TLoginNotice.Destroy;
begin
   inherited Destroy;
end;


end.

