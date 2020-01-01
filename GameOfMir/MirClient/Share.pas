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

{$IF SWH = SWH800}
   SCREENWIDTH = 800;
   SCREENHEIGHT = 600;
{$ELSEIF SWH = SWH1024}
   SCREENWIDTH = 1024;
   SCREENHEIGHT = 768;
{$IFEND}

   MAPSURFACEWIDTH = SCREENWIDTH;
   MAPSURFACEHEIGHT = SCREENHEIGHT- 155;

   WINLEFT = 60;
   WINTOP  = 60;
   WINRIGHT = SCREENWIDTH-60;
   BOTTOMEDGE = SCREENHEIGHT-30;  // Bottom WINBOTTOM

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
  MAXX = SCREENWIDTH div 20;
  MAXY = SCREENWIDTH div 20;

  DEFAULTCURSOR = 0; //ÏµÍ³Ä¬ÈÏ¹â±ê
  IMAGECURSOR   = 1; //Í¼ÐÎ¹â±ê

  USECURSOR     = DEFAULTCURSOR; //Ê¹ÓÃÊ²Ã´ÀàÐÍµÄ¹â±ê

  MAXBAGITEMCL = 46; //52; //¿Í»§¶ËÔÊÐí°ü¹ü·ÅÎïÆ·µÄ×î´óÊýÁ¿
  MAXFONT = 8;
  ENEMYCOLOR = 69;

implementation

end.
