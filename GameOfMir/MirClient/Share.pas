unit Share;

interface

const
  RUNLOGINCODE       = 9; //½øÈëÓÎÏ·×´Ì¬Âë,Ä¬ÈÏÎª0 ²âÊÔÎª 9

  STDCLIENT          = 0;
  RMCLIENT           = 99;
  CLIENTTYPE         = RMCLIENT; //ÆÕÍ¨µÄÎª0 ,99 Îª¹ÜÀí¿Í»§¶Ë

  //RMCLIENTTITLE      = '¢µ£ÌÒýÇæ®';
   RMCLIENTTITLE      = 'MIR2';


  DEBUG         = 0;
  SWH800        = 0;
  SWH1024       = 1;
  SWH           = SWH800;

  CUSTOMLIBFILE = 0; //×Ô¶¨ÒåÍ¼¿âÎ»ÖÃ
  
   MAXSCREENWIDTH = 1920;
   MAXSCREENHEIGHT = 1080;
   HUDWIDTH = 800;
   WINLEFT = 60;
   WINTOP = 60;

   MAPDIR             = 'Map\'; //µØÍ¼ÎÄ¼þËùÔÚÄ¿Â¼
   CONFIGFILE         = 'Config\%s.ini';
{$IF CUSTOMLIBFILE = 1}
   EFFECTIMAGEDIR     = 'Graphics\Effect\';
   MAINIMAGEFILE      = 'Graphics\FrmMain\Main.wil';
   MAINIMAGEFILE2     = 'Graphics\FrmMain\Main2.wil';
   MAINIMAGEFILE3     = 'Graphics\FrmMain\Main3.wil';
{$ELSE}
   MAINIMAGEFILE      = 'Data\Prguse.wil';
   MAINIMAGEFILE2     = 'Data\Prguse2.wil';
   MAINIMAGEFILE3     = 'Data\Prguse3.wil';
   EFFECTIMAGEDIR     = 'Data\';
{$IFEND}

   CHRSELIMAGEFILE    = 'Data\ChrSel.wil';
   MINMAPIMAGEFILE    = 'Data\mmap.wil';
   TITLESIMAGEFILE    = 'Data\Tiles.wil';
   SMLTITLESIMAGEFILE = 'Data\SmTiles.wil';
   HUMWINGIMAGESFILE  = 'Data\HumEffect.wil';
   MAGICONIMAGESFILE  = 'Data\MagIcon.wil';
   HUMIMGIMAGESFILE   = 'Data\Hum.wil';
   HAIRIMGIMAGESFILE  = 'Data\Hair.wil';
   WEAPONIMAGESFILE   = 'Data\Weapon.wil';
   NPCIMAGESFILE      = 'Data\Npc.wil';
   MAGICIMAGESFILE    = 'Data\Magic.wil';
   MAGIC2IMAGESFILE   = 'Data\Magic2.wil';
   EVENTEFFECTIMAGESFILE = EFFECTIMAGEDIR + 'Event.wil';
   BAGITEMIMAGESFILE   = 'Data\Items.wil';
   STATEITEMIMAGESFILE = 'Data\StateItem.wil';
   DNITEMIMAGESFILE    = 'Data\DnItems.wil';
   OBJECTIMAGEFILE     = 'Data\Objects.wil';
   OBJECTIMAGEFILE1    = 'Data\Objects%d.wil';
   MONIMAGEFILE        = 'Data\Mon%d.wil';
   DRAGONIMAGEFILE     = 'Data\Dragon.wil';
   EFFECTIMAGEFILE     = 'Data\Effect.wil';

   MONIMAGEFILEEX      = 'Graphics\Monster\%d.wil';
   MONPMFILE           = 'Graphics\Monster\%d.pm';
   
   {
   MAXX = 40;
   MAXY = 40;
   }
  MAXX = 40;
  MAXY = 40;

  DEFAULTCURSOR = 0; //ÏµÍ³Ä¬ÈÏ¹â±ê
  IMAGECURSOR   = 1; //Í¼ÐÎ¹â±ê

  USECURSOR     = DEFAULTCURSOR; //Ê¹ÓÃÊ²Ã´ÀàÐÍµÄ¹â±ê

  MAXBAGITEMCL = 46; //52; //¿Í»§¶ËÔÊÐí°ü¹ü·ÅÎïÆ·µÄ×î´óÊýÁ¿
  MAXFONT = 8;
  ENEMYCOLOR = 69;

var
   SCREENWIDTH: Integer = 800;
   SCREENHEIGHT: Integer = 600;
   MAPSURFACEWIDTH: Integer = 800;
   MAPSURFACEHEIGHT: Integer = 600;
   WINRIGHT: Integer = 740;
   BOTTOMEDGE: Integer = 570;
   HUDLEFT: Integer = 0;

procedure SetGameResolution(const Resolution: string);

implementation

procedure SetGameResolution(const Resolution: string);
begin
   SCREENWIDTH := 800;
   SCREENHEIGHT := 600;
   if Resolution = '1024x768' then begin
      SCREENWIDTH := 1024;
      SCREENHEIGHT := 768;
   end else if Resolution = '1280x720' then begin
      SCREENWIDTH := 1280;
      SCREENHEIGHT := 720;
   end else if Resolution = '1920x1080' then begin
      SCREENWIDTH := 1920;
      SCREENHEIGHT := 1080;
   end;
   MAPSURFACEWIDTH := SCREENWIDTH;
   MAPSURFACEHEIGHT := SCREENHEIGHT;
   WINRIGHT := SCREENWIDTH - 60;
   BOTTOMEDGE := SCREENHEIGHT - 30;
   HUDLEFT := (SCREENWIDTH - HUDWIDTH) div 2;
end;

end.
