unit SoundUtil;
//wav文件夹内声音文件的调用操作

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DirectX, DXClass, Grobal2, ExtCtrls, HUtil32, EdCode,
  Actor, DXSounds;


var
   CurVolume: integer;

procedure LoadSoundList (flname: string);
procedure LoadBGMusicList (flname: string);
procedure PlaySound (idx: integer);
function  PlayBGM (wavname: string): TDirectSoundBuffer;
procedure  PlayMp3 (wavname: string;boFlag:Boolean);
procedure SilenceSound;
procedure ItemClickSound (std: TStdItem);
procedure ItemUseSound (stdmode: integer);
procedure PlayMapMusic(boFlag:Boolean);

type
   SoundInfo = record
      Idx: integer;
      Name: string;
   end;

const
   bmg_intro            = 'wav\log-in-long2.wav';
   bmg_select           = 'wav\sellect-loop2.wav';
   bmg_field            = 'wav\Field2.wav';
   bmg_gameover         = 'wav\game over2.wav';

   s_walk_ground_l      = 1;
   s_walk_ground_r      = 2;
   s_run_ground_l       = 3;
   s_run_ground_r       = 4;
   s_walk_stone_l       = 5;
   s_walk_stone_r       = 6;
   s_run_stone_l        = 7;
   s_run_stone_r        = 8;
   s_walk_lawn_l        = 9;
   s_walk_lawn_r        = 10;
   s_run_lawn_l         = 11;
   s_run_lawn_r         = 12;
   s_walk_rough_l       = 13;
   s_walk_rough_r       = 14;
   s_run_rough_l        = 15;
   s_run_rough_r        = 16;
   s_walk_wood_l        = 17;
   s_walk_wood_r        = 18;
   s_run_wood_l         = 19;
   s_run_wood_r         = 20;
   s_walk_cave_l        = 21;
   s_walk_cave_r        = 22;
   s_run_cave_l         = 23;
   s_run_cave_r         = 24;
   s_walk_room_l        = 25;
   s_walk_room_r        = 26;
   s_run_room_l         = 27;
   s_run_room_r         = 28;
   s_walk_water_l       = 29;
   s_walk_water_r       = 30;
   s_run_water_l        = 31;
   s_run_water_r        = 32;


   s_hit_short          = 50;
   s_hit_wooden         = 51;
   s_hit_sword          = 52;
   s_hit_do             = 53;
   s_hit_axe            = 54;
   s_hit_club           = 55;
   s_hit_long           = 56;
   s_hit_fist           = 57;

   s_struck_short       = 60;
   s_struck_wooden      = 61;
   s_struck_sword       = 62;
   s_struck_do          = 63;
   s_struck_axe         = 64;
   s_struck_club        = 65;

   s_struck_body_sword  = 70;
   s_struck_body_axe    = 71;
   s_struck_body_longstick = 72;
   s_struck_body_fist   = 73;

   s_struck_armor_sword = 80;
   s_struck_armor_axe   = 81;
   s_struck_armor_longstick = 82;
   s_struck_armor_fist  = 83;

   //s_powerup_man         = 80;
   //s_powerup_woman       = 81;
   //s_die_man             = 82;
   //s_die_woman           = 83;
   //s_struck_man          = 84;
   //s_struck_woman        = 85;
   //s_firehit             = 86;

   //s_struck_magic        = 90;
   s_strike_stone        = 91;
   s_drop_stonepiece     = 92;

   s_rock_door_open     = 100;
   s_intro_theme        = 102;
   s_meltstone          = 101;
   s_main_theme         = 102;
   s_norm_button_click  = 103;
   s_rock_button_click  = 104;
   s_glass_button_click = 105;
   s_money              = 106;
   s_eat_drug           = 107;
   s_click_drug         = 108;
   s_spacemove_out      = 109;
   s_spacemove_in       = 110;

   s_click_weapon       = 111;
   s_click_armor        = 112;
   s_click_ring         = 113;
   s_click_armring      = 114;
   s_click_necklace     = 115;
   s_click_helmet       = 116;
   s_click_grobes       = 117;
   s_itmclick           = 118;

   s_yedo_man           = 130;
   s_yedo_woman         = 131;
   s_longhit            = 132;
   s_widehit            = 133;
   s_rush_l             = 134;
   s_rush_r             = 135;
   s_firehit_ready      = 136;
   s_firehit            = 137;

   s_man_struck     = 138;
   s_wom_struck     = 139;
   s_man_die        = 144;
   s_wom_die        = 145;


implementation

uses
   ClMain, MShare;


procedure LoadSoundList (flname: string);
var
   i, k, idx, n: integer;
   strlist: TStringList;
   str, data: string;
begin
  //检查文件是否存在
   if FileExists (flname) then begin
      strlist := TStringList.Create;
      strlist.LoadFromFile (flname);
      idx := 0;
      for i:=0 to strlist.Count-1 do begin
         str := strlist[i];
         if str <> '' then begin
            if str[1] = ';' then continue;
            str := Trim (GetValidStr3 (str, data, [':', ' ', #9]));
            n := Str_ToInt(data, 0);
            if n > idx then begin
               for k:=0 to n-g_SoundList.Count-1 do
                  g_SoundList.Add ('');
               g_SoundList.Add (str);
               idx := n;
            end;
         end;
      end;
      strlist.Free;
   end;
end;

procedure PlaySound (idx: integer);
begin
  if (g_Sound <> nil) and g_boSound then  begin
    if (idx >= 0) and (idx < g_SoundList.Count) then begin
      if g_SoundList[idx] <> '' then
        if FileExists (g_SoundList[idx]) then
          try
            g_Sound.EffectFile(g_SoundList[idx], FALSE, FALSE);
          except
          end;
    end;
  end;
end;
procedure PlayMapMusic(boFlag:Boolean);
var
  i:Integer;
  pFileName:^String;
  sFileName:String;
  nIndex:Integer;
begin

  {
  nIndex:=Random(BGMusicList.Count);
  if (nIndex < BGMusicList.Count) and (nIndex >= 0) then begin
    pFileName:=Pointer(BGMusicList.Objects[nIndex]);
  end;
  }
  {
  for i:=0 to BGMusicList.Count -1 do begin
    if CompareText(sMapName,BGMusicList.Strings[i]) = 0 then begin
      pFileName:=Pointer(BGMusicList.Objects[i]);
      break;
    end;
  end;
  }
  if (g_nMapMusic < 0) or (not boFlag) then begin
    PlayMp3('',False);
    exit;
  end;
  sFileName:='.\Music\' + IntToStr(g_nMapMusic) + '.mp3';
  PlayMp3(sFileName,boFlag);
end;
procedure LoadBGMusicList (flname: string);
var
  strlist: TStringList;
  str,sMapName,sFileName: string;
  pFileName:^String;
  i:Integer;
begin
  if FileExists (flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile (flname);
    for i:=0 to strlist.Count-1 do begin
      str := strlist[i];
      if (str = '') or (str[1] = ';') then continue;
      str:=GetValidStr3 (str, sMapName, [':', ' ', #9]);
      str:=GetValidStr3 (str, sFileName, [':', ' ', #9]);
      sMapName:=Trim(sMapName);
      sFileName:=Trim(sFileName);

      if (sMapName <> '') and (sFileName <> '') then begin
        New(pFileName);
        pFileName^:=sFileName;
        BGMusicList.AddObject(sMapName,TObject(pFileName));
      end;
    end;
    strlist.Free;;
  end;
end;
function  PlayBGM (wavname: string): TDirectSoundBuffer;
begin

   Result:=nil;//Jacky
   if not g_boBGSound then exit;
   if g_Sound <> nil then  begin
      if wavname <> '' then
         if FileExists (wavname) then begin
            try
               SilenceSound;
               g_Sound.EffectFile(wavname, TRUE, FALSE);
            except
            end;
         end;
   end;

end;
procedure  PlayMp3 (wavname: string;boFlag:Boolean);
begin


   if MP3 <> nil then  begin
      if not boFlag then begin
        Mp3.Stop;
        exit;
      end;
      if not g_boBGSound then exit;
      if wavname <> '' then
         if FileExists (wavname) then begin
            try
               MP3.Stop;
               MP3.Play(wavname);
            except
            end;
         end;
   end;
end;
procedure SilenceSound;
begin
   if g_Sound <> nil then  begin
      g_Sound.Clear;
   end;
end;

procedure ItemClickSound (std: TStdItem);
begin
   case std.StdMode of
      0, 31: PlaySound (s_click_drug);
      5, 6: PlaySound (s_click_weapon);
      10, 11: PlaySound (s_click_armor);
      22, 23: PlaySound (s_click_ring);
      24, 26: begin
        if (pos ('手镯', std.Name) > 0) or (pos ('手套', std.Name) > 0) then
          PlaySound (s_click_grobes)
        else
          PlaySound (s_click_armring);
      end;
      19, 20, 21: PlaySound (s_click_necklace);
      15: PlaySound (s_click_helmet);
      else PlaySound (s_itmclick);
   end;
end;

procedure ItemUseSound (stdmode: integer);
begin
   case stdmode of
      0: PlaySound (s_click_drug);
      1,2: PlaySound (s_eat_drug);
      else  ;
   end;
end;


end.



