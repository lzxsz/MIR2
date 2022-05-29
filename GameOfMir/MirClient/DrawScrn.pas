unit DrawScrn;
//整个游戏场景的最终绘图工作

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, DirectX, IntroScn, Actor, cliUtil, clFunc,
  HUtil32;


const
   MAXSYSLINE = 8;
   
   BOTTOMBOARD = 1;

   VIEWCHATLINE = 8; //9;  //聊天信息框最大显示行数(用于聊天文本滚动)

   AREASTATEICONBASE = 150;
   HEALTHBAR_BLACK = 0;
   HEALTHBAR_RED = 1;


type
   TDrawScreen = class
   private
      m_dwFrameTime       :LongWord;
      m_dwFrameCount      :LongWord;
      m_dwDrawFrameCount  :LongWord;
      m_SysMsgList        :TStringList;
   public
      CurrentScene: TScene;
      ChatStrs: TStringList;
      ChatBks: TList;
      ChatBoardTop: integer;

      HintList: TStringList;
      HintX, HintY, HintWidth, HintHeight: integer;
      HintUp: Boolean;
      HintColor: TColor;

      constructor Create;
      destructor Destroy; override;
      procedure KeyPress (var Key: Char);
      procedure KeyDown (var Key: Word; Shift: TShiftState);
      procedure MouseMove (Shift: TShiftState; X, Y: Integer);
      procedure MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      procedure Initialize;
      procedure Finalize;
      procedure ChangeScene (scenetype: TSceneType);
      procedure DrawScreen (MSurface: TDirectDrawSurface);
      procedure DrawScreenTop (MSurface: TDirectDrawSurface);
      procedure AddSysMsg (msg: string);
      procedure AddChatBoardString (str: string; fcolor, bcolor: integer);
      procedure ClearChatBoard;

      procedure ShowHint (x, y: integer; str: string; color: TColor; drawup: Boolean);
      procedure ClearHint;
      procedure DrawHint (MSurface: TDirectDrawSurface);
   end;


implementation

uses
   ClMain, MShare, Share;
   

constructor TDrawScreen.Create;
var
   i: integer;
begin
   CurrentScene := nil;
   m_dwFrameTime := GetTickCount;
   m_dwFrameCount := 0;
   m_SysMsgList := TStringList.Create;
   ChatStrs := TStringList.Create;
   ChatBks := TList.Create;
   ChatBoardTop := 0;

   HintList := TStringList.Create;

end;

destructor TDrawScreen.Destroy;
begin
   m_SysMsgList.Free;
   ChatStrs.Free;
   ChatBks.Free;
   HintList.Free;
   inherited Destroy;
end;

procedure TDrawScreen.Initialize;
begin
end;

procedure TDrawScreen.Finalize;
begin
end;

procedure TDrawScreen.KeyPress (var Key: Char);
begin
   if CurrentScene <> nil then
      CurrentScene.KeyPress (Key);
end;

procedure TDrawScreen.KeyDown (var Key: Word; Shift: TShiftState);
begin
   if CurrentScene <> nil then
      CurrentScene.KeyDown (Key, Shift);
end;

procedure TDrawScreen.MouseMove (Shift: TShiftState; X, Y: Integer);
begin
   if CurrentScene <> nil then
      CurrentScene.MouseMove (Shift, X, Y);
end;

procedure TDrawScreen.MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if CurrentScene <> nil then
      CurrentScene.MouseDown (Button, Shift, X, Y);
end;

//变改场景
procedure TDrawScreen.ChangeScene (scenetype: TSceneType);
begin
   if CurrentScene <> nil then
      CurrentScene.CloseScene;
   case scenetype of
      stIntro:
              CurrentScene := IntroScene;       //前奏
      stLogin:
              CurrentScene := LoginScene;       //登录
      stSelectCountry:
              ; //Nothing
      stSelectChr:
              CurrentScene := SelectChrScene;   //选角色
      stNewChr:
              ; //Nothing
      stLoading:
              ; //Nothing 
      stLoginNotice:
              CurrentScene := LoginNoticeScene; //公告提示
      stPlayGame:
              CurrentScene := PlayScene;        //游戏场景
   end;

   if CurrentScene <> nil then
      CurrentScene.OpenScene;
end;
//添加系统信息
procedure TDrawScreen.AddSysMsg (msg: string);
begin
   if m_SysMsgList.Count >= 10 then m_SysMsgList.Delete (0);
   m_SysMsgList.AddObject (msg, TObject(GetTickCount));
end;
//添加信息聊天板
procedure TDrawScreen.AddChatBoardString (str: string; fcolor, bcolor: integer);
var
   i, len, aline: integer;
   dline, temp: string;
const
   BOXWIDTH = (SCREENWIDTH div 2 - 214) * 2{374}; //41 聊天框文字宽度
begin
   len := Length (str);
   temp := '';
   i := 1;
   while TRUE do begin
      if i > len then break;
      if byte (str[i]) >= 128 then begin
         temp := temp + str[i];
         Inc (i);
         if i <= len then temp := temp + str[i]
         else break;
      end else
         temp := temp + str[i];

      aline := FrmMain.Canvas.TextWidth (temp);
      if aline > BOXWIDTH then begin
         ChatStrs.AddObject (temp, TObject(fcolor));
         ChatBks.Add (Pointer(bcolor));
         str := Copy (str, i+1, Len-i);
         temp := '';
         break;
      end;
      Inc (i);
   end;
   if temp <> '' then begin
      ChatStrs.AddObject (temp, TObject(fcolor));
      ChatBks.Add (Pointer(bcolor));
      str := '';
   end;
   if ChatStrs.Count > 200 then begin
      ChatStrs.Delete (0);
      ChatBks.Delete (0);
      if ChatStrs.Count - ChatBoardTop < VIEWCHATLINE then Dec(ChatBoardTop);
   end else if (ChatStrs.Count-ChatBoardTop) > VIEWCHATLINE then begin
      Inc (ChatBoardTop);
   end;

   if str <> '' then
      AddChatBoardString (' ' + str, fcolor, bcolor);

end;

//这里只计算浮动提示信息的宽度和高度，但不显示 ，浮动提示信息的显示在函数TDrawScreen.DrawHint()中进行
procedure TDrawScreen.ShowHint (x, y: integer; str: string; color: TColor; drawup: Boolean);
var
   data: string;
   w, h: integer;
begin
   ClearHint;
   HintX := x;
   HintY := y;
   HintWidth := 0;
   HintHeight := 0;
   HintUp := drawup;
   HintColor := color;

   while TRUE do begin
      if str = '' then break;
      str := GetValidStr3 (str, data, ['\']);
      w := FrmMain.Canvas.TextWidth (data) + 4 * 2;
      if w > HintWidth then HintWidth := w;
      if data <> '' then
         HintList.Add (data)
   end;
   
   HintHeight := (FrmMain.Canvas.TextHeight('A') + 1) * HintList.Count + 3 * 2;
   if HintUp then
      HintY := HintY - HintHeight;
      
end;

procedure TDrawScreen.ClearHint;
begin
   HintList.Clear;
end;

procedure TDrawScreen.ClearChatBoard;
begin
   m_SysMsgList.Clear;
   ChatStrs.Clear;
   ChatBks.Clear;
   ChatBoardTop := 0;
end;


//绘制场景
procedure TDrawScreen.DrawScreen (MSurface: TDirectDrawSurface);
   procedure NameTextOut (surface: TDirectDrawSurface; x, y, fcolor, bcolor: integer; namestr: string);
   var
      i, row: integer;
      nstr: string;
   begin
      row := 0;
      for i:=0 to 10 do begin
         if namestr = '' then break;
         namestr := GetValidStr3 (namestr, nstr, ['\']);
         BoldTextOut (surface,
                      x - surface.Canvas.TextWidth(nstr) div 2,
                      y + row * 12,
                      fcolor, bcolor, nstr);
         Inc (row);
      end;
   end;
var
   i, k, line, sx, sy, fcolor, bcolor: integer;
   actor: TActor;
   str, uname: string;
   dsurface: TDirectDrawSurface;
   d: TDirectDrawSurface;
   rc: TRect;
   infoMsg :String;
begin
   MSurface.Fill(0);
   if CurrentScene <> nil then
      CurrentScene.PlayScene (MSurface);

   if GetTickCount - m_dwFrameTime > 1000 then begin
      m_dwFrameTime := GetTickCount;
      m_dwDrawFrameCount := m_dwFrameCount;
      m_dwFrameCount := 0;
   end;
   Inc (m_dwFrameCount);

   if g_MySelf = nil then exit;

   //游戏场景
   if CurrentScene = PlayScene then begin
      with MSurface do begin
         //
         with PlayScene do begin
            for k:=0 to m_ActorList.Count-1 do begin  //画出每一个人物的状态
               actor := m_ActorList[k];
         //显示人物血量(数字显示)Jacky
         if g_boShowHPNumber and (actor.m_Abil.MaxHP > 1) and not actor.m_boDeath then begin
           SetBkMode (Canvas.Handle, TRANSPARENT);
           infoMsg:=IntToStr(actor.m_Abil.HP) + '/' + IntToStr(actor.m_Abil.MaxHP);
           BoldTextOut (MSurface,actor.m_nSayX - 15 ,actor.m_nSayY - 5, clWhite, clBlack,infoMsg );
           Canvas.Release;
         end;
             if g_boShowRedHPLable then actor.m_boOpenHealth:=True; //显示血条
               if (actor.m_boOpenHealth or actor.m_noInstanceOpenHealth) and not actor.m_boDeath then begin
                  if actor.m_noInstanceOpenHealth then
                     if GetTickCount - actor.m_dwOpenHealthStart > actor.m_dwOpenHealthTime then
                        actor.m_noInstanceOpenHealth := True;
                  d := g_WMain2Images.Images[HEALTHBAR_BLACK];
                  if d <> nil then
                     MSurface.Draw (actor.m_nSayX - d.Width div 2, actor.m_nSayY - 10, d.ClientRect, d, TRUE);
                  d := g_WMain2Images.Images[HEALTHBAR_RED];
                  if d <> nil then begin
                     rc := d.ClientRect;
                     if actor.m_Abil.MaxHP > 0 then
                        rc.Right := Round((rc.Right-rc.Left) / actor.m_Abil.MaxHP * actor.m_Abil.HP);
                     MSurface.Draw (actor.m_nSayX - d.Width div 2, actor.m_nSayY - 10, rc, d, TRUE);
                  end;
               end;
            end;
         end;

         //画当前选择的物品/人物的名字
         SetBkMode (Canvas.Handle, TRANSPARENT);
         if (g_FocusCret <> nil) and PlayScene.IsValidActor (g_FocusCret) then begin
            //if FocusCret.Grouped then uname := char(7) + FocusCret.UserName
            //else
            uname := g_FocusCret.m_sDescUserName + '\' + g_FocusCret.m_sUserName;
            NameTextOut (MSurface,
                      g_FocusCret.m_nSayX, // - Canvas.TextWidth(uname) div 2,
                      g_FocusCret.m_nSayY + 30,
                      g_FocusCret.m_nNameColor, clBlack,
                      uname);
         end;
         //玩家名称
         if g_boSelectMyself then begin
            uname := g_MySelf.m_sDescUserName + '\' + g_MySelf.m_sUserName;
            NameTextOut (MSurface,
                      g_MySelf.m_nSayX, // - Canvas.TextWidth(uname) div 2,
                      g_MySelf.m_nSayY + 30,
                      g_MySelf.m_nNameColor, clBlack,
                      uname);
         end;

         Canvas.Font.Color := clWhite;

         //显示角色说话文字
         with PlayScene do begin
            for k:=0 to m_ActorList.Count-1 do begin
               actor := m_ActorList[k];
               if actor.m_SayingArr[0] <> '' then begin
                  if GetTickCount - actor.m_dwSayTime < 4 * 1000 then begin
                     for i:=0 to actor.m_nSayLineCount - 1 do  //显示每个玩家说的话
                        if actor.m_boDeath then                //死了的话就灰/红色显示
                           BoldTextOut (MSurface,
                                     actor.m_nSayX - (actor.m_SayWidthsArr[i] div 2),
                                     actor.m_nSayY - (actor.m_nSayLineCount*16) + i*14,
                                     clGray, clBlack,
                                     actor.m_SayingArr[i])
                        else                      //正常的玩家用黑/白色显示
                           BoldTextOut (MSurface,
                                     actor.m_nSayX - (actor.m_SayWidthsArr[i] div 2),
                                     actor.m_nSayY - (actor.m_nSayLineCount*16) + i*14,
                                     clWhite, clBlack,
                                     actor.m_SayingArr[i]);
                  end else                       //说的话显示4秒
                     actor.m_SayingArr[0] := '';
               end;
            end;
         end;

         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(SendCount) + ' : ' + IntToStr(ReceiveCount));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, 'HITSPEED=' + IntToStr(Myself.HitSpeed));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, 'DupSel=' + IntToStr(DupSelection));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(LastHookKey));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack,
         //             IntToStr(
         //                int64(GetTickCount - LatestSpellTime) - int64(700 + MagicDelayTime)
         //                ));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(PlayScene.EffectList.Count));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack,
         //                  IntToStr(Myself.XX) + ',' + IntToStr(Myself.m_nCurrY) + '  ' +
         //                  IntToStr(Myself.ShiftX) + ',' + IntToStr(Myself.ShiftY));

         //System Message
         //
         if (g_nAreaStateValue and $04) <> 0 then begin
            BoldTextOut (MSurface, 0, 0, clWhite, clBlack, '攻城区域');
         end;

         Canvas.Release;

         //显示地图状态，16种：0000000000000000 从右到左，为1表示：战斗、安全、上面的那种状态 (当前只有这几种状态)
         k := 0;
         for i:=0 to 15 do begin
            if g_nAreaStateValue and ($01 shr i) <> 0 then begin
               d := g_WMainImages.Images[AREASTATEICONBASE + i];
               if d <> nil then begin
                  k := k + d.Width;
                  MSurface.Draw (SCREENWIDTH-k, 0, d.ClientRect, d, TRUE);
               end;
            end;
         end;

      end;
   end;
end;

//屏幕左上角显示系统消息文字
procedure TDrawScreen.DrawScreenTop (MSurface: TDirectDrawSurface);
var
   i, sx, sy: integer;
begin
   if g_MySelf = nil then exit;
      //游戏状态：显示所有系统消息(左上角显示的)
   if CurrentScene = PlayScene then begin
      with MSurface do begin
         SetBkMode (Canvas.Handle, TRANSPARENT);
         if m_SysMsgList.Count > 0 then begin
            sx := 30;
            sy := 40;

            for i:=0 to m_SysMsgList.Count-1 do begin

               //BoldTextOut (MSurface, sx, sy, clGreen, clBlack, m_SysMsgList[i]);
               BoldTextOut (MSurface, sx, sy, TColor($00FF00) , clBlack, m_SysMsgList[i]);  //clAqua显示系统消息文字

               inc (sy, 16);
            end;
            //3秒减少一个系统消息
            if GetTickCount - longword(m_SysMsgList.Objects[0]) >= 3000 then
               m_SysMsgList.Delete (0);
         end;
         Canvas.Release;
      end;
   end;
end;

//在游戏界面显示提示信息。如地图名，角色位置坐标，系统时间
procedure TDrawScreen.DrawHint (MSurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
   i, hx, hy, old: integer;
   str: string;
   oldFontSize: integer;
begin
   hx:=0;
   hy:=0;

   //显示浮动提示框
   if HintList.Count > 0 then begin
      d := g_WMainImages.Images[394];
      if d <> nil then begin
         if HintWidth > d.Width then HintWidth := d.Width;
         if HintHeight > d.Height then HintHeight := d.Height;
         if HintX + HintWidth > SCREENWIDTH then hx := SCREENWIDTH - HintWidth
         else hx := HintX;
         if HintY < 0 then hy := 0
         else hy := HintY;
         if hx < 0 then hx := 0;

         DrawBlendEx (MSurface, hx, hy, d, 0, 0, HintWidth, HintHeight, 0);
      end;
   end;

   with MSurface do begin
      SetBkMode (Canvas.Handle, TRANSPARENT);  //设置Canvas背景为透明模式

      //在浮动提示框中显示提示信息
      if HintList.Count > 0 then begin
         Canvas.Font.Color := HintColor;
         for i:=0 to HintList.Count-1 do begin
            Canvas.TextOut (hx+4, hy+3+(Canvas.TextHeight('A')+1)*i, HintList[i]);
         end;
      end;

      if g_MySelf <> nil then begin

         //显示人物血量
         //BoldTextOut (MSurface, 15, SCREENHEIGHT - 120, clWhite, clBlack, IntToStr(g_MySelf.m_Abil.HP) + '/' + IntToStr(g_MySelf.m_Abil.MaxHP));
         //人物MP值
         //BoldTextOut (MSurface, 115, SCREENHEIGHT - 120, clWhite, clBlack, IntToStr(g_MySelf.m_Abil.MP) + '/' + IntToStr(g_MySelf.m_Abil.MaxMP));
         //人物经验值
         //BoldTextOut (MSurface, 655, SCREENHEIGHT - 55, clWhite, clBlack, IntToStr(g_MySelf.Abil.Exp) + '/' + IntToStr(g_MySelf.Abil.MaxExp));
         //人物背包重量
         //BoldTextOut (MSurface, 655, SCREENHEIGHT - 25, clWhite, clBlack, IntToStr(g_MySelf.Abil.Weight) + '/' + IntToStr(g_MySelf.Abil.MaxWeight));

         //显示绿色提示 (用于调试) -----------------
         if g_boShowGreenHint then begin
            str:= 'Time: ' + TimeToStr(Time) +
                  ' Exp: ' + IntToStr(g_MySelf.m_Abil.Exp) + '/' + IntToStr(g_MySelf.m_Abil.MaxExp) +
                  ' Weight: ' + IntToStr(g_MySelf.m_Abil.Weight) + '/' + IntToStr(g_MySelf.m_Abil.MaxWeight) +
                  ' ' + g_sGoldName + ': ' + IntToStr(g_MySelf.m_nGold) +
                  ' Cursor: ' + IntToStr(g_nMouseCurrX) + ':' + IntToStr(g_nMouseCurrY) + '(' + IntToStr(g_nMouseX) + ':' + IntToStr(g_nMouseY) + ')';
            if g_FocusCret <> nil then begin
              str:= str + ' Target: ' + g_FocusCret.m_sUserName + '(' + IntToStr(g_FocusCret.m_Abil.HP) + '/' + IntToStr(g_FocusCret.m_Abil.MaxHP) + ')';
            end else begin
              str:= str + ' Target: -/-';
            end;

            BoldTextOut (MSurface, 10, 0, clLime , clBlack, str);

            str:='';
         end;
         //显示绿色提示结束 ------------------

         //显示在坏地图时的情况信息(用于调试)
         if g_boCheckBadMapMode then begin
              str := IntToStr(m_dwDrawFrameCount) +  ' '
              + '  Mouse ' + IntToStr(g_nMouseX) + ':' + IntToStr(g_nMouseY) + '(' + IntToStr(g_nMouseCurrX) + ':' + IntToStr(g_nMouseCurrY) + ')'
              + '  HP' + IntToStr(g_MySelf.m_Abil.HP) + '/' + IntToStr(g_MySelf.m_Abil.MaxHP)
              + '  D0 ' + IntToStr(g_nDebugCount)
              + '  D1 ' + IntToStr(g_nDebugCount1) + ' D2 '
              + IntToStr(g_nDebugCount2);
              BoldTextOut (MSurface, 10, 0, clWhite, clBlack, str);
         end;

         //old := Canvas.Font.Size;
         //Canvas.Font.Size := 8;
         //BoldTextOut (MSurface, 8, SCREENHEIGHT-42, clWhite, clBlack, ServerName);

         //显示白示提 (用于调试) ------------------
         if g_boShowWhiteHint then begin
             if g_MySelf.m_nGameGold > 10 then begin
                BoldTextOut (MSurface, 8, SCREENHEIGHT-42, clWhite, clBlack, g_sGameGoldName + ' ' + IntToStr(g_MySelf.m_nGameGold));
             end else begin
                BoldTextOut (MSurface, 8, SCREENHEIGHT-42, clRed, clBlack, g_sGameGoldName + ' ' + IntToStr(g_MySelf.m_nGameGold));
            end;

         if g_MySelf.m_nGamePoint > 10 then begin
               BoldTextOut (MSurface, 8, SCREENHEIGHT-58, clWhite, clBlack, g_sGamePointName + ' ' + IntToStr(g_MySelf.m_nGamePoint));
            end else begin
             BoldTextOut (MSurface, 8, SCREENHEIGHT-58, clRed, clBlack, g_sGamePointName + ' ' + IntToStr(g_MySelf.m_nGamePoint));
            end;

            //鼠标所指坐标
            BoldTextOut (MSurface, 115, SCREENHEIGHT - 40, clWhite, clBlack, IntToStr(g_nMouseCurrX) + ':' + IntToStr(g_nMouseCurrY));
            //显示时间
            BoldTextOut (MSurface, 410, SCREENHEIGHT - 147, clWhite, clBlack, FormatDateTime('dddddd hh:mm:ss ampm', Now));
         end;
        //显示白示提结束 -----------------------

        // BoldTextOut (MSurface, 8, SCREENHEIGHT- 74, clWhite, clBlack, format('AllocMemCount:%d',[AllocMemCount]));
        // BoldTextOut (MSurface, 8, SCREENHEIGHT- 90, clWhite, clBlack, format('AllocMemSize:%d',[AllocMemSize div 1024]));

         //Canvas.Font.Size := old;

          //-------------------------------------------------------
          //正式用
          //在显示游戏界面显示【地图名，位置坐标】，【系统时间】
           SetBkMode (Canvas.Handle, TRANSPARENT);
           oldFontSize := Canvas.Font.Size;
           Canvas.Font.Size :=10;

           //在游戏界面左下角，显示角色所在地图和位置 (坐标)
           BoldTextOut (MSurface, 8, SCREENHEIGHT-20, clWhite, clBlack, g_sMapTitle + ' ' + IntToStr(g_MySelf.m_nCurrX) + ':' + IntToStr(g_MySelf.m_nCurrY));

           //在游戏界面左下角，显示时间 (系统时间)
           //BoldTextOut (MSurface, SCREENWIDTH - 125, SCREENHEIGHT - 23, clWhite, clBlack, FormatDateTime('tt', Now));  //hh:mm:ss ampm
           Canvas.Font.Size := oldFontSize;
           //-------------------------------------------------------

      end;
      //BoldTextOut (MSurface, 10, 20, clWhite, clBlack, IntToStr(DebugCount) + ' / ' + IntToStr(DebugCount1));
      Canvas.Release;
   end;
end;


end.
