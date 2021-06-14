unit M2Share;

interface
                                                                                              
uses
  Windows, Messages, Classes, SysUtils, StdCtrls, Graphics, RunSock, Envir, ItmUnit, Magic, NoticeM, Guild, Event, Dialogs, untTQQWry,
  Castle, FrnEngn, UsrEngn, MudUtil, Grobal2, ObjBase, ObjRobot, ObjNpc, SyncObjs, IniFiles, SDK, EncryptUnit, WinSock, MD5Unit;

resourcestring
  g_sTitleName = '游戏数据引擎';
  g_sProductName = 'MIR2游戏数据引擎';
  g_sVersion = '引擎版本: 1.5.0 (20020522)';
  g_sUpDateTime = '更新日期: 2019/09/09';
  g_sProgram = '程序制作: Cola PI';
  
  g_sWebSite = '程序网站:';   // http://www.***.com
  g_sBbsSite = '程序论坛:';   // http://bbs.***.com
  g_sCopyright = 'Copyright (C) 2002';

const
  DEBUG = 1; //调试模式
  CHECKNEWMSG = 0; //是否显示未处理的客户端消息

  NOEXCEPTION = 0;
  TRYEXCEPTION = 1;
  CATEXCEPTION = TRYEXCEPTION;

  DEMOCLIENT = 0; //是否演示客户端

  VERDEMO = 0;
  VERFREE = 1;
  VERSTD = 2;
  VEROEM = 3;
  VERPRO = 4;
  VERENT = 5;
  SoftVersion = VERENT; //程序版本类型


  USELOCALCODE = 0;
  USEREMOTECODE = 1;

  USECODE = USELOCALCODE;
  RequestVersion = 5;


  LF = 0;
  LD = 1;
  ZQ = 2;
  DUDU = 3;
  ZYL = 4;
  WL = 5;
  TEST = 53;

  VEROWNER = WL;

  OEM = 0;
  OEM775 = 1;
  OEMVER = OEM;

{$IF SoftVersion = VERENT}
  ENDYEAR = 2005;
  ENDMONTH = 5;
  ENDDAY = 20;
{$ELSE}
  ENDYEAR = 2005;
  ENDMONTH = 6;
  ENDDAY = 20;
{$IFEND}


  OLDMONSTERMODE = 0;
  NEWMONSTERMODE = 1;
  PROCESSMONSTMODE = NEWMONSTERMODE; //处理怪物模式

  THREADENGINE = 0; //DB数据库SOCKET连接使用线程
  TIMERENGINE = 1; //DB数据库SOCKET连接使用控件
  DBSOCKETMODE = TIMERENGINE;
  IDSOCKETMODE = TIMERENGINE;
  USERENGINEMODE = TIMERENGINE;

  CHECKENDYEAR = ENDYEAR;
  CHECKENDMONTH = ENDMONTH;
  CHECKENDDAY = ENDDAY;
{$IF OEMVER = OEM775}

{$ELSE}

{$IFEND}


  MAXUPLEVEL = High(Word) {65535};
  MAXHUMPOWER = High(Word) {65535};

  BODYLUCKUNIT = 5000; //10?

  //《热血传奇》1.50版“虎卫传说”
  // 时间：2002年8月 新的冒险乐园被一个接一个的发现：白日门、丛林迷宫、赤月峡谷，尘封已久的天尊、法神、圣战套装终于出世。　

  //《热血传奇》1.70版“魔神归来”
  // 时间：2003年1月 封魔谷的入口打开，虹魔教主威力初显。师徒、好友、婚姻系统的全面推出。

  //攻击模式 (热血传奇1.70版)
{
  HAM_ALL      = 0;   //全体攻击              (First)
  HAM_PEACE    = 1;   //和平功击
  HAM_DEAR     = 2;   //夫妻攻击
  HAM_MASTER   = 3;   //师徒攻击
  HAM_GROUP    = 4;   //编组攻击
  HAM_GUILD    = 5;   //行会攻击
  HAM_PKATTACK = 6;   //红名攻击（善恶攻击）   (Last)
}

  //攻击模式 (热血传奇1.50版)
  HAM_ALL      = 0;   //全体攻击                (First)
  HAM_PEACE    = 1;   //和平功击
  HAM_GROUP    = 2;   //编组攻击
  HAM_GUILD    = 3;   //行会攻击
  HAM_PKATTACK = 4;   //红名攻击(善恶攻击)      (Last)

  //注：热血传奇1.50版 无 夫妻攻击 和 师徒攻击

  // 和平攻击模式：除了对暴民以外其他攻击都无效。
  // 行会联盟攻击模式：对自己行会内的其他玩家攻击无效
  // 编组攻击模式：处于同一小组的玩家攻击无效
  // 全体攻击模式：对所有的玩家和暴民都具有攻击效果。
  // 善恶攻击模式：PK红名专用攻击模式。

  DEFHIT = 5;
  DEFSPEED = 15;
  jWarr = 0;
  jWizard = 1;
  jTaos = 2;

  //lzx2020 - for debug bag item count by davy 2020-1-17
  //注意：该数值只有在数据库构发生改变后才需要调整(如背包最大物品数量)，否则不要改变该数值。
  SIZEOFTHUMAN = 3628; //3660; //3588;  //人物数据结构的字节大小。如果只改了背包物品数量，其他结构没变，则3660 对应 46个物品, 3588 对应 43个物品。

  //怪物、动物和卫士编号
  MONSTER_SANDMOB = 3;
  MONSTER_ROCKMAN = 4;
  MONSTER_RON = 9;
  MONSTER_MINORNUMA = 18;
  ARCHER_POLICE = 20;

  SUPREGUARD = 11;
  PETSUPREGUARD = 12;

  ANIMAL_CHICKEN = 51;
  ANIMAL_DEER = 52;
  ANIMAL_WOLF = 53;

  TRAINER = 55;

  MONSTER_OMA = 80;
  MONSTER_OMAKNIGHT = 81;
  MONSTER_SPITSPIDER = 82;
  MONSTER_STICK = 85;
  MONSTER_DUALAXE = 87;
  MONSTER_THONEDARK = 93;
  MONSTER_LIGHTZOMBI = 94;
  MONSTER_DIGOUTZOMBI = 95;
  MONSTER_ZILKINZOMBI = 96;
  MONSTER_WHITESKELETON = 100;
  MONSTER_BEEQUEEN = 103;
  MONSTER_BEE = 125;
  MONSTER_MAGUNGSA = 143;
  MONSTER_SCULTURE = 101;
  MONSTER_SCULTUREKING = 102;
  MONSTER_ARCHERGUARD = 112;
  MONSTER_ELFMONSTER = 113;
  MONSTER_ELFWARRIOR = 114;

  sMAN = 'MAN';
  sSUNRAISE = 'SUNRAISE';
  sDAY = 'DAY';
  sSUNSET = 'SUNSET';
  sNIGHT = 'NIGHT';
  sWarrior = 'Warrior';
  sWizard = 'Wizard';
  sTaos = 'Taoist';
  sSUN = 'SUN';
  sMON = 'MON';
  sTUE = 'TUE';
  sWED = 'WED';
  sTHU = 'THU';
  sFRI = 'FRI';
  sSAT = 'SAT';

//脚本常量
  sCHECK = 'CHECK';
  nCHECK = 1;
  sRANDOM = 'RANDOM';
  nRANDOM = 2;
  sGENDER = 'GENDER';
  nGENDER = 3;
  sDAYTIME = 'DAYTIME';
  nDAYTIME = 4;
  sCHECKOPEN = 'CHECKOPEN';
  nCHECKOPEN = 5;
  sCHECKUNIT = 'CHECKUNIT';
  nCHECKUNIT = 6;
  sCHECKLEVEL = 'CHECKLEVEL';
  nCHECKLEVEL = 7;
  sCHECKJOB = 'CHECKJOB';
  nCHECKJOB = 8;
  sCHECKBBCOUNT = 'CHECKBBCOUNT';
  nCHECKBBCOUNT = 9;

  sCHECKITEM = 'CHECKITEM';
  nCHECKITEM = 20;
  sCHECKITEMW = 'CHECKITEMW';
  nCHECKITEMW = 21;
  sCHECKGOLD = 'CHECKGOLD';
  nCHECKGOLD = 22;
  sISTAKEITEM = 'ISTAKEITEM';
  nISTAKEITEM = 23;
  sCHECKDURA = 'CHECKDURA';
  nCHECKDURA = 24;
  sCHECKDURAEVA = 'CHECKDURAEVA';
  nCHECKDURAEVA = 25;
  sDAYOFWEEK = 'DAYOFWEEK';
  nDAYOFWEEK = 26;
  sHOUR = 'HOUR';
  nHOUR = 27;
  sMIN = 'MIN';
  nMIN = 28;
  sCHECKPKPOINT = 'CHECKPKPOINT';
  nCHECKPKPOINT = 29;
  sCHECKLUCKYPOINT = 'CHECKLUCKYPOINT';
  nCHECKLUCKYPOINT = 30;
  sCHECKMONMAP = 'CHECKMONMAP';
  nCHECKMONMAP = 31;
  sCHECKMONAREA = 'CHECKMONAREA';
  nCHECKMONAREA = 32;
  sCHECKHUM = 'CHECKHUM';
  nCHECKHUM = 33;
  sCHECKBAGGAGE = 'CHECKBAGGAGE';
  nCHECKBAGGAGE = 34;

  sEQUAL = 'EQUAL';
  nEQUAL = 35;
  sLARGE = 'LARGE';
  nLARGE = 36;
  sSMALL = 'SMALL';
  nSMALL = 37;
  sSC_CHECKMAGIC = 'CHECKMAGIC';
  nSC_CHECKMAGIC = 38;
  sSC_CHKMAGICLEVEL = 'CHKMAGICLEVEL';
  nSC_CHKMAGICLEVEL = 39;
  sSC_CHECKMONRECALL = 'CHECKMONRECALL';
  nSC_CHECKMONRECALL = 40;
  sSC_CHECKHORSE = 'CHECKHORSE';
  nSC_CHECKHORSE = 41;
  sSC_CHECKRIDING = 'CHECKRIDING';
  nSC_CHECKRIDING = 42;
  sSC_STARTDAILYQUEST = 'STARTDAILYQUEST';
  nSC_STARTDAILYQUEST = 45;
  sSC_CHECKDAILYQUEST = 'CHECKDAILYQUEST';
  nSC_CHECKDAILYQUEST = 46;
  sSC_RANDOMEX = 'RANDOMEX';
  nSC_RANDOMEX = 47;
  sCHECKNAMELIST = 'CHECKNAMELIST';
  nCHECKNAMELIST = 48;
  sSC_CHECKWEAPONLEVEL = 'CHECKWEAPONLEVEL';
  nSC_CHECKWEAPONLEVEL = 49;
  sSC_CHECKWEAPONATOM = 'CHECKWEAPONATOM';
  nSC_CHECKWEAPONATOM = 50;
  sSC_CHECKREFINEWEAPON = 'CHECKREFINEWEAPON';
  nSC_CHECKREFINEWEAPON = 51;
  sSC_CHECKWEAPONMCTYPE = 'CHECKWEAPONMCTYPE';
  nSC_CHECKWEAPONMCTYPE = 52;
  sSC_CHECKREFINEITEM = 'CHECKREFINEITEM';
  nSC_CHECKREFINEITEM = 53;
  sSC_HASWEAPONATOM = 'HASWEAPONATOM';
  nSC_HASWEAPONATOM = 54;

  sSC_ISGUILDMASTER = 'ISGUILDMASTER';
  nSC_ISGUILDMASTER = 55;
  sSC_CANPROPOSECASTLEWAR = 'CANPROPOSECASTLEWAR';
  nSC_CANPROPOSECASTLEWAR = 56;
  sSC_CANHAVESHOOTER = 'CANHAVESHOOTER';
  nSC_CANHAVESHOOTER = 57;
  sSC_CHECKFAME = 'CHECKFAME';
  nSC_CHECKFAME = 58;
  sSC_ISONCASTLEWAR = 'ISONCASTLEWAR';
  nSC_ISONCASTLEWAR = 59;
  sSC_ISONREADYCASTLEWAR = 'ISONREADYCASTLEWAR';
  nSC_ISONREADYCASTLEWAR = 60;
  sSC_ISCASTLEGUILD = 'ISCASTLEGUILD';
  nSC_ISCASTLEGUILD = 61;
  sSC_ISATTACKGUILD = 'ISATTACKGUILD'; //是否为攻城方
  nSC_ISATTACKGUILD = 63;
  sSC_ISDEFENSEGUILD = 'ISDEFENSEGUILD'; //是否为守城方
  nSC_ISDEFENSEGUILD = 65;
  sSC_CHECKSHOOTER = 'CHECKSHOOTER';
  nSC_CHECKSHOOTER = 66;
  sSC_CHECKSAVEDSHOOTER = 'CHECKSAVEDSHOOTER';
  nSC_CHECKSAVEDSHOOTER = 67;
  sSC_HASGUILD = 'HAVEGUILD'; //是否加入行会
  nSC_HASGUILD = 68;
  sSC_CHECKCASTLEDOOR = 'CHECKCASTLEDOOR'; //检查城门
  nSC_CHECKCASTLEDOOR = 69;
  sSC_CHECKCASTLEDOOROPEN = 'CHECKCASTLEDOOROPEN'; //城门是否打开
  nSC_CHECKCASTLEDOOROPEN = 70;
  sSC_CHECKPOS = 'CHECKPOS';
  nSC_CHECKPOS = 71;
  sSC_CANCHARGESHOOTER = 'CANCHARGESHOOTER';
  nSC_CANCHARGESHOOTER = 72;
  sSC_ISATTACKALLYGUILD = 'ISATTACKALLYGUILD'; //是否为攻城方联盟行会
  nSC_ISATTACKALLYGUILD = 73;
  sSC_ISDEFENSEALLYGUILD = 'ISDEFENSEALLYGUILD'; //是否为守城方联盟行会
  nSC_ISDEFENSEALLYGUILD = 74;
  sSC_TESTTEAM = 'TESTTEAM';
  nSC_TESTTEAM = 75;
  sSC_ISSYSOP = 'ISSYSOP';
  nSC_ISSYSOP = 76;
  sSC_ISADMIN = 'ISADMIN';
  nSC_ISADMIN = 77;
  sSC_CHECKBONUS = 'CHECKBONUS';
  nSC_CHECKBONUS = 78;
  sSC_CHECKMARRIAGE = 'CHECKMARRIAGE';
  nSC_CHECKMARRIAGE = 79;
  sSC_CHECKMARRIAGERING = 'CHECKMARRIAGERING';
  nSC_CHECKMARRIAGERING = 80;

  sSC_CHECKGMETERM = 'CHECKGMETERM';
  nSC_CHECKGMETERM = 100;
  sSC_CHECKOPENGME = 'CHECKOPENGME';
  nSC_CHECKOPENGME = 101;
  sSC_CHECKENTERGMEMAP = 'CHECKENTERGMEMAP';
  nSC_CHECKENTERGMEMAP = 102;
  sSC_CHECKSERVER = 'CHECKSERVER';
  nSC_CHECKSERVER = 103;
  sSC_ELARGE = 'ELARGE';
  nSC_ELARGE = 104;
  sSC_ESMALL = 'ESMALL';
  nSC_ESMALL = 105;
  sSC_CHECKGROUPCOUNT = 'CHECKGROUPCOUNT';
  nSC_CHECKGROUPCOUNT = 106;
  sSC_CHECKACCESSORY = 'CHECKACCESSORY';
  nSC_CHECKACCESSORY = 107;
  sSC_ONERROR = 'ONERROR';
  nSC_ONERROR = 108;
  sSC_CHECKARMOR = 'CHECKARMOR';
  nSC_CHECKARMOR = 109;

  sCHECKACCOUNTLIST = 'CHECKACCOUNTLIST';
  nCHECKACCOUNTLIST = 135;
  sCHECKIPLIST = 'CHECKIPLIST';
  nCHECKIPLIST = 136;
  sCHECKCREDITPOINT = 'CHECKCREDITPOINT';
  nCHECKCREDITPOINT = 137;
  sSC_CHECKPOSEDIR = 'CHECKPOSEDIR';
  nSC_CHECKPOSEDIR = 138;
  sSC_CHECKPOSELEVEL = 'CHECKPOSELEVEL';
  nSC_CHECKPOSELEVEL = 139;
  sSC_CHECKPOSEGENDER = 'CHECKPOSEGENDER';
  nSC_CHECKPOSEGENDER = 140;
  sSC_CHECKLEVELEX = 'CHECKLEVELEX';
  nSC_CHECKLEVELEX = 141;
  sSC_CHECKBONUSPOINT = 'CHECKBONUSPOINT';
  nSC_CHECKBONUSPOINT = 142;


//取消 师徒 和 结婚系统 的相关内容
{
  sSC_CHECKMARRY = 'CHECKMARRY';
  nSC_CHECKMARRY = 143;
  sSC_CHECKPOSEMARRY = 'CHECKPOSEMARRY';
  nSC_CHECKPOSEMARRY = 144;
  sSC_CHECKMARRYCOUNT = 'CHECKMARRYCOUNT';
  nSC_CHECKMARRYCOUNT = 145;
  sSC_CHECKMASTER = 'CHECKMASTER';
  nSC_CHECKMASTER = 146;
  sSC_HAVEMASTER = 'HAVEMASTER';
  nSC_HAVEMASTER = 147;
  sSC_CHECKPOSEMASTER = 'CHECKPOSEMASTER';
  nSC_CHECKPOSEMASTER = 148;
  sSC_POSEHAVEMASTER = 'POSEHAVEMASTER';
  nSC_POSEHAVEMASTER = 149;
  sSC_CHECKISMASTER = 'CHECKPOSEISMASTER';
  nSC_CHECKISMASTER = 150;
  sSC_CHECKPOSEISMASTER = 'CHECKISMASTER';
  nSC_CHECKPOSEISMASTER = 151;
}

  sSC_CHECKNAMEIPLIST = 'CHECKNAMEIPLIST';
  nSC_CHECKNAMEIPLIST = 152;
  sSC_CHECKACCOUNTIPLIST = 'CHECKACCOUNTIPLIST';
  nSC_CHECKACCOUNTIPLIST = 153;
  sSC_CHECKSLAVECOUNT = 'CHECKSLAVECOUNT';
  nSC_CHECKSLAVECOUNT = 154;
  sSC_CHECKCASTLEMASTER = 'ISCASTLEMASTER';
  nSC_CHECKCASTLEMASTER = 155;
  sSC_ISNEWHUMAN = 'ISNEWHUMAN';
  nSC_ISNEWHUMAN = 156;
  sSC_CHECKMEMBERTYPE = 'CHECKMEMBERTYPE';
  nSC_CHECKMEMBERTYPE = 157;
  sSC_CHECKMEMBERLEVEL = 'CHECKMEMBERLEVEL';
  nSC_CHECKMEMBERLEVEL = 158;
  sSC_CHECKGAMEGOLD = 'CHECKGAMEGOLD';
  nSC_CHECKGAMEGOLD = 159;
  sSC_CHECKGAMEPOINT = 'CHECKGAMEPOINT';
  nSC_CHECKGAMEPOINT = 160;

  sSC_CHECKNAMELISTPOSITION = 'CHECKNAMELISTPOSITION';
  nSC_CHECKNAMELISTPOSITION = 161;
  sSC_CHECKGUILDLIST = 'CHECKGUILDLIST';
  nSC_CHECKGUILDLIST = 162;
  sSC_CHECKRENEWLEVEL = 'CHECKRENEWLEVEL';
  nSC_CHECKRENEWLEVEL = 163;

  sSC_CHECKSLAVELEVEL = 'CHECKSLAVELEVEL';
  nSC_CHECKSLAVELEVEL = 164;
  sSC_CHECKSLAVENAME = 'CHECKSLAVENAME';
  nSC_CHECKSLAVENAME = 165;

  sSC_CHECKCREDITPOINT = 'CHECKCREDITPOINT';
  nSC_CHECKCREDITPOINT = 166;

  sSC_CHECKOFGUILD = 'CHECKOFGUILD';
  nSC_CHECKOFGUILD = 167;
  sSC_CHECKPAYMENT = 'CHECKPAYMENT';
  nSC_CHECKPAYMENT = 168;
  sSC_CHECKUSEITEM = 'CHECKUSEITEM';
  nSC_CHECKUSEITEM = 169;
  sSC_CHECKBAGSIZE = 'CHECKBAGSIZE';
  nSC_CHECKBAGSIZE = 170;
  sSC_CHECKLISTCOUNT = 'CHECKLISTCOUNT';
  nSC_CHECKLISTCOUNT = 171;
  sSC_CHECKDC = 'CHECKDC';
  nSC_CHECKDC = 172;
  sSC_CHECKMC = 'CHECKMC';
  nSC_CHECKMC = 173;
  sSC_CHECKSC = 'CHECKSC';
  nSC_CHECKSC = 174;
  sSC_CHECKHP = 'CHECKHP';
  nSC_CHECKHP = 175;
  sSC_CHECKMP = 'CHECKMP';
  nSC_CHECKMP = 176;

  sSC_CHECKITEMTYPE = 'CHECKITEMTYPE';
  nSC_CHECKITEMTYPE = 180;
  sSC_CHECKEXP = 'CHECKEXP';
  nSC_CHECKEXP = 181;
  sSC_CHECKCASTLEGOLD = 'CHECKCASTLEGOLD';
  nSC_CHECKCASTLEGOLD = 182;

  sSC_PASSWORDERRORCOUNT = 'PASSWORDERRORCOUNT';
  nSC_PASSWORDERRORCOUNT = 183;
  sSC_ISLOCKPASSWORD = 'ISLOCKPASSWORD';
  nSC_ISLOCKPASSWORD = 184;
  sSC_ISLOCKSTORAGE = 'ISLOCKSTORAGE';
  nSC_ISLOCKSTORAGE = 185;


  sSC_CHECKBUILDPOINT = 'CHECKGUILDBUILDPOINT';
  nSC_CHECKBUILDPOINT = 186;
  sSC_CHECKAURAEPOINT = 'CHECKGUILDAURAEPOINT';
  nSC_CHECKAURAEPOINT = 187;
  sSC_CHECKSTABILITYPOINT = 'CHECKGUILDSTABILITYPOINT';
  nSC_CHECKSTABILITYPOINT = 188;
  sSC_CHECKFLOURISHPOINT = 'CHECKGUILDFLOURISHPOINT';
  nSC_CHECKFLOURISHPOINT = 189;

  sSC_CHECKCONTRIBUTION = 'CHECKCONTRIBUTION'; //贡献度
  nSC_CHECKCONTRIBUTION = 190;
  sSC_CHECKRANGEMONCOUNT = 'CHECKRANGEMONCOUNT'; //检查一个区域中有多少怪
  nSC_CHECKRANGEMONCOUNT = 191;

  sSC_CHECKITEMADDVALUE = 'CHECKITEMADDVALUE';
  nSC_CHECKITEMADDVALUE = 192;
  sSC_CHECKINMAPRANGE = 'CHECKINMAPRANGE';
  nSC_CHECKINMAPRANGE = 193;

  sSC_CASTLECHANGEDAY = 'CASTLECHANGEDAY';
  nSC_CASTLECHANGEDAY = 194;
  sSC_CASTLEWARDAY = 'CASTLEWARAY';
  nSC_CASTLEWARDAY = 195;
  sSC_ONLINELONGMIN = 'ONLINELONGMIN';
  nSC_ONLINELONGMIN = 196;
  sSC_CHECKGUILDCHIEFITEMCOUNT = 'CHECKGUILDCHIEFITEMCOUNT';
  nSC_CHECKGUILDCHIEFITEMCOUNT = 197;

  sSC_CHECKNAMEDATELIST = 'CHECKNAMEDATELIST';
  nSC_CHECKNAMEDATELIST = 198;
  sSC_CHECKMAPHUMANCOUNT = 'CHECKMAPHUMANCOUNT';
  nSC_CHECKMAPHUMANCOUNT = 199;

  sSC_CHECKMAPMONCOUNT = 'CHECKMAPMONCOUNT';
  nSC_CHECKMAPMONCOUNT = 200;
  sSC_CHECKVAR = 'CHECKVAR';
  nSC_CHECKVAR = 201;
  sSC_CHECKSERVERNAME = 'CHECKSERVERNAME';
  nSC_CHECKSERVERNAME = 202;

  sSC_CHECKMAP = 'CHECKMAP';
  nSC_CHECKMAP = 203;
  sSC_REVIVESLAVE = 'REVIVESLAVES';
  nSC_REVIVESLAVE = 206;
  sSC_CHECKMAGICLVL = 'CHECKMAGICLVL';
  nSC_CHECKMAGICLVL = 207;
  sSC_CHECKGROUPCLASS = 'CHECKGROUPCLASS';
  nSC_CHECKGROUPCLASS = 208;


//Action
  sSET = 'SET';
  nSET = 1;
  sTAKE = 'TAKE';
  nTAKE = 2;
  sSC_GIVE = 'GIVE';
  nSC_GIVE = 3;
  sTAKEW = 'TAKEW';
  nTAKEW = 4;
  sCLOSE = 'CLOSE';
  nCLOSE = 5;
  sRESET = 'RESET';
  nRESET = 6;
  sSETOPEN = 'SETOPEN';
  nSETOPEN = 7;
  sSETUNIT = 'SETUNIT';
  nSETUNIT = 8;
  sRESETUNIT = 'RESETUNIT';
  nRESETUNIT = 9;
  sBREAK = 'BREAK';
  nBREAK = 10;
  sTIMERECALL = 'TIMERECALL';
  nTIMERECALL = 11;
  sSC_PARAM1 = 'PARAM1';
  nSC_PARAM1 = 12;
  sSC_PARAM2 = 'PARAM2';
  nSC_PARAM2 = 13;
  sSC_PARAM3 = 'PARAM3';
  nSC_PARAM3 = 14;
  sSC_PARAM4 = 'PARAM4';
  nSC_PARAM4 = 15;
  sSC_EXEACTION = 'EXEACTION';
  nSC_EXEACTION = 16;

  sMAPMOVE = 'MAPMOVE';
  nMAPMOVE = 19;
  sMap = 'MAP';
  nMAP = 20;
  sTAKECHECKITEM = 'TAKECHECKITEM';
  nTAKECHECKITEM = 21;
  sMONGEN = 'MONGEN';
  nMONGEN = 22;
  sSC_MONGENP = 'MONGENP';
  nSC_MONGENP = 23;
  sMONCLEAR = 'MONCLEAR';
  nMONCLEAR = 24;
  sMOV = 'MOV';
  nMOV = 25;
  sINC = 'INC';
  nINC = 26;
  sDEC = 'DEC';
  nDEC = 27;
  sSUM = 'SUM';
  nSUM = 28;
  sSC_DIV = 'DIV';
  sSC_MUL = 'MUL';
  sSC_PERCENT = 'PERCENT';

  sBREAKTIMERECALL = 'BREAKTIMERECALL';
  nBREAKTIMERECALL = 29;
  sSENDMSG = 'SENDMSG';
  nSENDMSG = 30;
  sCHANGEMODE = 'CHANGEMODE';
  nCHANGEMODE = 31;
  sPKPOINT = 'PKPOINT';
  nPKPOINT = 32;
  sCHANGEXP = 'CHANGEXP';
  nCHANGEXP = 33;
  sSC_RECALLMOB = 'RECALLMOB';
  nSC_RECALLMOB = 34;
  sKICK = 'KICK';
  nKICK = 35;
  sMOVR = 'MOVR';
  nMOVR = 50;
  sEXCHANGEMAP = 'EXCHANGEMAP';
  nEXCHANGEMAP = 51;
  sRECALLMAP = 'RECALLMAP';
  nRECALLMAP = 52;
  sADDBATCH = 'ADDBATCH';
  nADDBATCH = 53;
  sBATCHDELAY = 'BATCHDELAY';
  nBATCHDELAY = 54;
  sBATCHMOVE = 'BATCHMOVE';
  nBATCHMOVE = 55;
  sPLAYDICE = 'PLAYDICE';
  nPLAYDICE = 56;
  sSC_PASTEMAP = 'PASTEMAP';
  sSC_LOADGEN = 'LOADGEN';

  sADDNAMELIST = 'ADDNAMELIST';
  nADDNAMELIST = 57;

  sDELNAMELIST = 'DELNAMELIST';
  nDELNAMELIST = 58;

  sADDGUILDLIST = 'ADDGUILDLIST';
  nADDGUILDLIST = 59;

  sDELGUILDLIST = 'DELGUILDLIST';
  nDELGUILDLIST = 60;

  sADDACCOUNTLIST = 'ADDACCOUNTLIST';
  nADDACCOUNTLIST = 61;
  sDELACCOUNTLIST = 'DELACCOUNTLIST';
  nDELACCOUNTLIST = 62;
  sADDIPLIST = 'ADDIPLIST';
  nADDIPLIST = 63;
  sDELIPLIST = 'DELIPLIST';
  nDELIPLIST = 64;

  sGOQUEST = 'GOQUEST';
  nGOQUEST = 100;
  sENDQUEST = 'ENDQUEST';
  nENDQUEST = 101;
  sGOTO = 'GOTO';
  nGOTO = 102;
  sSC_HAIRCOLOR = 'HAIRCOLOR';
  nSC_HAIRCOLOR = 104;
  sSC_WEARCOLOR = 'WEARCOLOR';
  nSC_WEARCOLOR = 105;
  sSC_HAIRSTYLE = 'HAIRSTYLE';
  nSC_HAIRSTYLE = 106;
  sSC_MONRECALL = 'MONRECALL';
  nSC_MONRECALL = 107;
  sSC_HORSECALL = 'HORSECALL';
  nSC_HORSECALL = 108;
  sSC_HAIRRNDCOL = 'HAIRRNDCOL';
  nSC_HAIRRNDCOL = 109;
  sSC_RANDSETDAILYQUEST = 'RANDSETDAILYQUEST';
  nSC_RANDSETDAILYQUEST = 110;
  sSC_REFINEWEAPON = 'REFINEWEAPON';
  nSC_REFINEWEAPON = 113;
  sSC_RECALLGROUPMEMBERS = 'RECALLGROUPMEMBERS';
  nSC_RECALLGROUPMEMBERS = 117;
  sSC_MAPTING = 'MAPTING';
  nSC_MAPTING = 118;
  sSC_WRITEWEAPONNAME = 'WRITEWEAPONNAME';
  nSC_WRITEWEAPONNAME = 119;
  sSC_DELAYGOTO = 'DELAYGOTO';
  nSC_DELAYGOTO = 120;
  sSC_ENABLECMD = 'ENABLECMD';
  nSC_ENABLECMD = 121;
  sSC_LINEMSG = 'LINEMSG';
  nSC_LINEMSG = 122;
  sSC_EVENTMSG = 'EVENTMSG';
  nSC_EVENTMSG = 123;
  sSC_SOUNDMSG = 'SOUNDMSG';
  nSC_SOUNDMSG = 124;
  sSC_SETMISSION = 'SETMISSION';
  nSC_SETMISSION = 125;
  sSC_CLEARMISSION = 'CLEARMISSION';
  nSC_CLEARMISSION = 126;
  sSC_MONPWR = 'MONPWR';
  nSC_MONPWR = 127;
  sSC_ENTER_OK = 'ENTER_OK';
  nSC_ENTER_OK = 128;
  sSC_ENTER_FAIL = 'ENTER_FAIL';
  nSC_ENTER_FAIL = 129;
  sSC_MONADDITEM = 'MONADDITEM';
  nSC_MONADDITEM = 130;
  sSC_CHANGEWEATHER = 'CHANGEWEATHER';
  nSC_CHANGEWEATHER = 131;
  sSC_CHANGEWEAPONATOM = 'CHANGEWEAPONATOM';
  nSC_CHANGEWEAPONATOM = 132;
  sSC_GETREPAIRCOST = 'GETREPAIRCOST';
  nSC_GETREPAIRCOST = 134;
  sSC_KILLHORSE = 'KILLHORSE';
  nSC_KILLHORSE = 133;
  sSC_REPAIRITEM = 'REPAIRITEM';
  nSC_REPAIRITEM = 135;
  sSC_USEREMERGENCYCLOSE = 'USEREMERGENCYCLOSE';
  nSC_USEREMERGENCYCLOSE = 138;
  sSC_BUILDGUILD = 'BUILDGUILD';
  nSC_BUILDGUILD = 139;
  sSC_GUILDWAR = 'GUILDWAR';
  nSC_GUILDWAR = 140;
  sSC_CHANGEUSERNAME = 'CHANGEUSERNAME';
  nSC_CHANGEUSERNAME = 141;
  sSC_CHANGEMONLEVEL = 'CHANGEMONLEVEL';
  nSC_CHANGEMONLEVEL = 142;
  sSC_DROPITEMMAP = 'DROPITEMMAP';
  nSC_DROPITEMMAP = 143;
  sSC_CLEARITEMMAP = 'CLEARITEMMAP';
  nSC_CLEARITEMMAP = 170;
  sSC_PROPOSECASTLEWAR = 'PROPOSECASTLEWAR';
  nSC_PROPOSECASTLEWAR = 144;
  sSC_FINISHCASTLEWAR = 'FINISHCASTLEWAR';
  nSC_FINISHCASTLEWAR = 145;
  sSC_MOVENPC = 'MOVENPC';
  nSC_MOVENPC = 146;
  sSC_SPEAK = 'SPEAK';
  nSC_SPEAK = 147;
  sSC_SENDCMD = 'SENDCMD';
  nSC_SENDCMD = 148;
  sSC_INCFAME = 'INCFAME';
  nSC_INCFAME = 149;
  sSC_DECFAME = 'DECFAME';
  nSC_DECFAME = 150;
  sSC_CAPTURECASTLEFLAG = 'CAPTURECASTLEFLAG';
  nSC_CAPTURECASTLEFLAG = 151;
  sSC_MAKESHOOTER = 'MAKESHOOTER';
  nSC_MAKESHOOTER = 153;
  sSC_KILLSHOOTER = 'KILLSHOOTER';
  nSC_KILLSHOOTER = 154;
  sSC_LEAVESHOOTER = 'LEAVESHOOTER';
  nSC_LEAVESHOOTER = 155;
  sSC_CHANGEMAPATTR = 'CHANGEMAPATTR';
  nSC_CHANGEMAPATTR = 157;
  sSC_RESETMAPATTR = 'RESETMAPATTR';
  nSC_RESETMAPATTR = 158;
  sSC_MAKECASTLEDOOR = 'MAKECASTLEDOOR';
  nSC_MAKECASTLEDOOR = 159;
  sSC_REPAIRCASTLEDOOR = 'REPAIRCASTLEDOOR';
  nSC_REPAIRCASTLEDOOR = 160;
  sSC_CHARGESHOOTER = 'CHARGESHOOTER';
  nSC_CHARGESHOOTER = 161;
  sSC_SETAREAATTR = 'SETAREAATTR';
  nSC_SETAREAATTR = 162;
  sSC_CLEARDELAYGOTO = 'CLEARDELAYGOTO';
  nSC_CLEARDELAYGOTO = 163;

  sSC_TESTFLAG = 'TESTFLAG';
  nSC_TESTFLAG = 164;
  sSC_APPLYFLAG = 'APPLYFLAG';
  nSC_APPLYFLAG = 165;
  sSC_PASTEFLAG = 'PASTEFLAG';
  nSC_PASTEFLAG = 166;
  sSC_GETBACKCASTLEGOLD = 'GETBACKCASTLEGOLD';
  nSC_GETBACKCASTLEGOLD = 167;
  sSC_GETBACKUPGITEM = 'GETBACKUPGITEM';
  nSC_GETBACKUPGITEM = 168;
  sSC_TINGWAR = 'TINGWAR';
  nSC_TINGWAR = 169;
  sSC_SAVEPASSWD = 'SAVEPASSWD';
  nSC_SAVEPASSWD = 171;
  sSC_CREATENPC = 'CREATENPC';
  nSC_CREATENPC = 172;
  sSC_TAKEBONUS = 'TAKEBONUS';
  nSC_TAKEBONUS = 173;
  sSC_SYSMSG = 'SYSMSG';
  nSC_SYSMSG = 174;
  sSC_LOADVALUE = 'LOADVALUE';
  nSC_LOADVALUE = 175;
  sSC_SAVEVALUE = 'SAVEVALUE';
  nSC_SAVEVALUE = 176;
  sSC_SAVELOG = 'SAVELOG';
  nSC_SAVELOG = 177;
  sSC_GETMARRIED = 'GETMARRIED';
  nSC_GETMARRIED = 178;
  sSC_DIVORCE = 'DIVORCE';
  nSC_DIVORCE = 189;
  sSC_CAPTURESAYING = 'CAPTURESAYING';
  nSC_CAPTURESAYING = 190;
  sSC_CANCELMARRIAGERING = 'CANCELMARRIAGERING';
  nSC_CANCELMARRIAGERING = 191;
  sSC_OPENUSERMARKET = 'OPENUSERMARKET';
  nSC_OPENUSERMARKET = 192;
  sSC_SETTYPEUSERMARKET = 'SETTYPEUSERMARKET';
  nSC_SETTYPEUSERMARKET = 193;
  sSC_CHECKSOLDITEMSUSERMARKET = 'CHECKSOLDITEMSUSERMARKET';
  nSC_CHECKSOLDITEMSUSERMARKET = 194;
  sSC_SETGMEMAP = 'SETGMEMAP';
  nSC_SETGMEMAP = 200;
  sSC_SETGMEPOINT = 'SETGMEPOINT';
  nSC_SETGMEPOINT = 201;
  sSC_SETGMETIME = 'SETGMETIME';
  nSC_SETGMETIME = 209;
  sSC_STARTNEWGME = 'STARTNEWGME';
  nSC_STARTNEWGME = 202;
  sSC_MOVETOGMEMAP = 'MOVETOGMEMAP';
  mSC_MOVETOGMEMAP = 203;
  sSC_FINISHGME = 'FINISHGME';
  nSC_FINISHGME = 204;
  sSC_CONTINUEGME = 'CONTINUEGME';
  nSC_CONTINUEGME = 205;
  sSC_SETGMEPLAYTIME = 'SETGMEPLAYTIME';
  nSC_SETGMEPLAYTIME = 206;
  sSC_SETGMEPAUSETIME = 'SETGMEPAUSETIME';
  nSC_SETGMEPAUSETIME = 207;
  sSC_SETGMELIMITUSER = 'SETGMELIMITUSER';
  nSC_SETGMELIMITUSER = 208;
  sSC_SETEVENTMAP = 'SETEVENTMAP';
  nSC_SETEVENTMAP = 210;
  sSC_RESETEVENTMAP = 'RESETEVENTMAP';
  nSC_RESETEVENTMAP = 211;
  sSC_TESTREFINEPOINTS = 'TESTREFINEPOINTS';
  nSC_TESTREFINEPOINTS = 220;
  sSC_RESETREFINEWEAPON = 'RESETREFINEWEAPON';
  nSC_RESETREFINEWEAPON = 221;
  sSC_TESTREFINEACCESSORIES = 'TESTREFINEACCESSORIES';
  nSC_TESTREFINEACCESSORIES = 222;
  sSC_REFINEACCESSORIES = 'REFINEACCESSORIES';
  nSC_REFINEACCESSORIES = 223;
  sSC_APPLYMONMISSION = 'APPLYMONMISSION';
  nSC_APPLYMONMISSION = 225;
  sSC_MAPMOVER = 'MAPMOVER';
  nSC_MAPMOVER = 226;
  sSC_ADDSTR = 'ADDSTR';
  nSC_ADDSTR = 227;
  sSC_SETEVENTDAMAGE = 'SETEVENTDAMAGE';
  nSC_SETEVENTDAMAGE = 228;
  sSC_FORMATSTR = 'FORMATSTR';
  nSC_FORMATSTR = 229;
  sSC_CLEARPATH = 'CLEARPATH';
  nSC_CLEARPATH = 230;
  sSC_ADDPATH = 'ADDPATH';
  nSC_ADDPATH = 231;
  sSC_APPLYPATH = 'APPLYPATH';
  nSC_APPLYPATH = 232;
  sSC_MAPSPELL = 'MAPSPELL';
  nSC_MAPSPELL = 233;
  sSC_GIVEEXP = 'GIVEEXP';
  nSC_GIVEEXP = 234;
  sSC_GROUPMOVE = 'GROUPMOVE';
  nSC_GROUPMOVE = 235;
  sSC_GIVEEXPMAP = 'GIVEEXPMAP';
  nSC_GIVEEXPMAP = 236;
  sSC_APPLYMONEX = 'APPLYMONEX';
  nSC_APPLYMONEX = 237;
  sSC_CLEARNAMELIST = 'CLEARNAMELIST';
  nSC_CLEARNAMELIST = 238;
  sSC_TINGCASTLEVISITOR = 'TINGCASTLEVISITOR';
  nSC_TINGCASTLEVISITOR = 239;
  sSC_MAKEHEALZONE = 'MAKEHEALZONE';
  nSC_MAKEHEALZONE = 240;
  sSC_MAKEDAMAGEZONE = 'MAKEDAMAGEZONE';
  nSC_MAKEDAMAGEZONE = 241;
  sSC_CLEARZONE = 'CLEARZONE';
  nSC_CLEARZONE = 242;
  sSC_READVALUESQL = 'READVALUESQL';
  nSC_READVALUESQL = 250;
  sSC_READSTRINGSQL = 'READSTRINGSQL';
  nSC_READSTRINGSQL = 255;
  sSC_WRITEVALUESQL = 'WRITEVALUESQL';
  nSC_WRITEVALUESQL = 251;
  sSC_INCVALUESQL = 'INCVALUESQL';
  nSC_INCVALUESQL = 252;
  sSC_DECVALUESQL = 'DECVALUESQL';
  nSC_DECVALUESQL = 253;
  sSC_UPDATEVALUESQL = 'UPDATEVALUESQL';
  nSC_UPDATEVALUESQL = 254;
  sSC_KILLSLAVE = 'KILLSLAVE';
  nSC_KILLSLAVE = 260;
  sSC_SETITEMEVENT = 'SETITEMEVENT';
  nSC_SETITEMEVENT = 261;
  sSC_REMOVEITEMEVENT = 'REMOVEITEMEVENT';
  nSC_REMOVEITEMEVENT = 262;
  sSC_RETURN = 'RETURN';
  nSC_RETURN = 263;
  sSC_CLEARCASTLEOWNER = 'CLEARCASTLEOWNER';
  nSC_CLEARCASTLEOWNER = 270;
  sSC_DISSOLUTIONGUILD = 'DISSOLUTIONGUILD';
  nSC_DISSOLUTIONGUILD = 271;
  sSC_CHANGEGENDER = 'CHANGEGENDER';
  nSC_CHANGEGENDER = 272;
  sSC_SETFAME = 'SETFAME';
  nSC_SETFAME = 273;

  sSC_CHANGELEVEL = 'CHANGELEVEL';
  nSC_CHANGELEVEL = 300;

//  sSC_MARRY = 'MARRY';
//  nSC_MARRY = 301;
//  sSC_UNMARRY = 'UNMARRY';
//  nSC_UNMARRY = 302;
//  sSC_GETMARRY = 'GETMARRY';
//  nSC_GETMARRY = 303;
//  sSC_GETMASTER = 'GETMASTER';
//  nSC_GETMASTER = 304;

  sSC_CLEARSKILL = 'CLEARSKILL';
  nSC_CLEARSKILL = 305;
  sSC_DELNOJOBSKILL = 'DELNOJOBSKILL';
  nSC_DELNOJOBSKILL = 306;
  sSC_DELSKILL = 'DELSKILL';
  nSC_DELSKILL = 307;
  sSC_ADDSKILL = 'ADDSKILL';
  nSC_ADDSKILL = 308;
  sSC_SKILLLEVEL = 'SKILLLEVEL';
  nSC_SKILLLEVEL = 309;

  sSC_CHANGEPKPOINT = 'CHANGEPKPOINT';
  nSC_CHANGEPKPOINT = 310;
  sSC_CHANGEEXP = 'CHANGEEXP';
  nSC_CHANGEEXP = 311;
  sSC_CHANGEJOB = 'CHANGEJOB';
  nSC_CHANGEJOB = 312;
  sSC_MISSION = 'MISSION';
  nSC_MISSION = 313;
  sSC_MOBPLACE = 'MOBPLACE';
  nSC_MOBPLACE = 314;
  sSC_SETMEMBERTYPE = 'SETMEMBERTYPE';
  nSC_SETMEMBERTYPE = 315;
  sSC_SETMEMBERLEVEL = 'SETMEMBERLEVEL';
  nSC_SETMEMBERLEVEL = 316;
  sSC_GAMEGOLD = 'GAMEGOLD';
  nSC_GAMEGOLD = 317;
  sSC_AUTOADDGAMEGOLD = 'AUTOADDGAMEGOLD';
  nSC_AUTOADDGAMEGOLD = 318;
  sSC_AUTOSUBGAMEGOLD = 'AUTOSUBGAMEGOLD';
  nSC_AUTOSUBGAMEGOLD = 319;
  sSC_CHANGENAMECOLOR = 'CHANGENAMECOLOR';
  nSC_CHANGENAMECOLOR = 320;
  sSC_CLEARPASSWORD = 'CLEARPASSWORD';
  nSC_CLEARPASSWORD = 321;
  sSC_RENEWLEVEL = 'RENEWLEVEL';
  nSC_RENEWLEVEL = 322;
  sSC_KILLMONEXPRATE = 'KILLMONEXPRATE';
  nSC_KILLMONEXPRATE = 323;
  sSC_POWERRATE = 'POWERRATE';
  nSC_POWERRATE = 324;
  sSC_CHANGEMODE = 'CHANGEMODE';
  nSC_CHANGEMODE = 325;
  sSC_CHANGEPERMISSION = 'CHANGEPERMISSION';
  nSC_CHANGEPERMISSION = 326;
  sSC_KILL = 'KILL';
  nSC_KILL = 327;
  sSC_KICK = 'KICK';
  nSC_KICK = 328;
  sSC_BONUSPOINT = 'BONUSPOINT';
  nSC_BONUSPOINT = 329;
  sSC_RESTRENEWLEVEL = 'RESTRENEWLEVEL';
  nSC_RESTRENEWLEVEL = 330;

//  sSC_DELMARRY = 'DELMARRY';
//  nSC_DELMARRY = 331;
//  sSC_DELMASTER = 'DELMASTER';
//  nSC_DELMASTER = 332;
//  sSC_MASTER = 'MASTER';
//  nSC_MASTER = 333;
//  sSC_UNMASTER = 'UNMASTER';
//  nSC_UNMASTER = 334;

  sSC_CREDITPOINT = 'CREDITPOINT';
  nSC_CREDITPOINT = 335;
  sSC_CLEARNEEDITEMS = 'CLEARNEEDITEMS';
  nSC_CLEARNEEDITEMS = 336;
  sSC_CLEARMAKEITEMS = 'CLEARMAKEITEMS';
  nSC_CLEARMAEKITEMS = 337;
  sSC_SETSENDMSGFLAG = 'SETSENDMSGFLAG';
  nSC_SETSENDMSGFLAG = 338;
  sSC_UPGRADEITEMS = 'UPGRADEITEM';
  nSC_UPGRADEITEMS = 339;
  sSC_UPGRADEITEMSEX = 'UPGRADEITEMEX';
  nSC_UPGRADEITEMSEX = 340;
  sSC_MONGENEX = 'MONGENEX';
  nSC_MONGENEX = 341;
  sSC_CLEARMAPMON = 'CLEARMAPMON';
  nSC_CLEARMAPMON = 342;
  sSC_SETMAPMODE = 'SETMPAMODE';
  nSC_SETMAPMODE = 343;
  sSC_GAMEPOINT = 'GAMEPOINT';
  nSC_GAMEPOINT = 344;
  sSC_PKZONE = 'PKZONE';
  nSC_PKZONE = 345;
  sSC_RESTBONUSPOINT = 'RESTBONUSPOINT';
  nSC_RESTBONUSPOINT = 346;

  sSC_TAKECASTLEGOLD = 'TAKECASTLEGOLD';
  nSC_TAKECASTLEGOLD = 347;
  sSC_HUMANHP = 'HUMANHP';
  nSC_HUMANHP = 348;
  sSC_HUMANMP = 'HUMANMP';
  nSC_HUMANMP = 349;

  sSC_BUILDPOINT = 'GUILDBUILDPOINT';
  nSC_BUILDPOINT = 350;
  sSC_AURAEPOINT = 'GUILDAURAEPOINT';
  nSC_AURAEPOINT = 351;
  sSC_STABILITYPOINT = 'GUILDSTABILITYPOINT';
  nSC_STABILITYPOINT = 352;
  sSC_FLOURISHPOINT = 'GUILDFLOURISHPOINT';
  nSC_FLOURISHPOINT = 353;
  sSC_OPENMAGICBOX = 'OPENITEMBOX' {'OPENMAGICBOX'};
  nSC_OPENMAGICBOX = 354;
  sSC_SETRANKLEVELNAME = 'SETRANKLEVELNAME';
  nSC_SETRANKLEVELNAME = 355;
  sSC_GMEXECUTE = 'GMEXECUTE';
  nSC_GMEXECUTE = 356;
  sSC_GUILDCHIEFITEMCOUNT = 'GUILDCHIEFITEMCOUNT';
  nSC_GUILDCHIEFITEMCOUNT = 357;
  sSC_ADDNAMEDATELIST = 'ADDNAMEDATELIST';
  nSC_ADDNAMEDATELIST = 358;
  sSC_DELNAMEDATELIST = 'DELNAMEDATELIST';
  nSC_DELNAMEDATELIST = 359;
  sSC_MOBFIREBURN = 'MOBFIREBURN';
  nSC_MOBFIREBURN = 360;
  sSC_MESSAGEBOX = 'MESSAGEBOX';
  nSC_MESSAGEBOX = 361;

  sSC_SETSCRIPTFLAG = 'SETSCRIPTFLAG'; //设置用于NPC输入框操作的控制标志
  nSC_SETSCRIPTFLAG = 362;
  sSC_SETAUTOGETEXP = 'SETAUTOGETEXP';
  nSC_SETAUTOGETEXP = 363;
  sSC_VAR = 'VAR';
  nSC_VAR = 364;
  sSC_LOADVAR = 'LOADVAR';
  nSC_LOADVAR = 365;
  sSC_SAVEVAR = 'SAVEVAR';
  nSC_SAVEVAR = 366;
  sSC_CALCVAR = 'CALCVAR';
  nSC_CALCVAR = 367;

  sSC_GUILDRECALL = 'GUILDRECALL';
  nSC_GUILDRECALL = 368;
  sSC_GROUPADDLIST = 'GROUPADDLIST';
  nSC_GROUPADDLIST = 369;
  sSC_CLEARLIST = 'CLEARLIST';
  nSC_CLEARLIST = 370;
  sSC_GROUPRECALL = 'GROUPRECALL';
  nSC_GROUPRECALL = 371;
  sSC_GROUPMOVEMAP = 'GROUPMOVEMAP';
  nSC_GROUPMOVEMAP = 372;
  sSC_SAVESLAVES = 'SAVESLAVES';
  nSC_SAVESLAVES = 373;


  sSL_SENDMSG = '@@sendmsg';
  sSUPERREPAIR = '@s_repair';
  sSUPERREPAIROK = '~@s_repair';
  sSUPERREPAIRFAIL = '@fail_s_repair';
  sREPAIR = '@repair';
  sREPAIROK = '~@repair';
  sBUY = '@buy';
  sSELL = '@sell';
  sMAKEDURG = '@makedrug';
  sPRICES = '@prices';
  sSTORAGE = '@storage';
  sGETBACK = '@getback';
  sUPGRADENOW = '@upgradenow';
  sUPGRADEING = '~@upgradenow_ing';
  sUPGRADEOK = '~@upgradenow_ok';
  sUPGRADEFAIL = '~@upgradenow_fail';
  sGETBACKUPGNOW = '@getbackupgnow';
  sGETBACKUPGOK = '~@getbackupgnow_ok';
  sGETBACKUPGFAIL = '~@getbackupgnow_fail';
  sGETBACKUPGFULL = '~@getbackupgnow_bagfull';
  sGETBACKUPGING = '~@getbackupgnow_ing';
  sEXIT = '@exit';
  sBACK = '@back';
  sMAIN = '@main';
  sFAILMAIN = '~@main';

//  sGETMASTER = '@@getmaster';
//  sGETMARRY = '@@getmarry';

  sUSEITEMNAME = '@@useitemname';

  sBUILDGUILDNOW = '@@buildguildnow';
  sSCL_GUILDWAR = '@@guildwar';
  sDONATE = '@@donate';
  sREQUESTCASTLEWAR = '@requestcastlewarnow';

  sCASTLENAME = '@@castlename';
  sWITHDRAWAL = '@@withdrawal';
  sRECEIPTS = '@@receipts';
  sOPENMAINDOOR = '@openmaindoor';
  sCLOSEMAINDOOR = '@closemaindoor';
  sREPAIRDOORNOW = '@repairdoornow';
  sREPAIRWALLNOW1 = '@repairwallnow1';
  sREPAIRWALLNOW2 = '@repairwallnow2';
  sREPAIRWALLNOW3 = '@repairwallnow3';
  sHIREARCHERNOW = '@hirearchernow';
  sHIREGUARDNOW = '@hireguardnow';
  sHIREGUARDOK = '@hireguardok';
  sMarket_Def = 'Market_Def\';
  sNpc_def = 'Npc_def\';
type
  Tshoplist = record
    stypename: string;
    sItemsname: string;
    sItemspic: string;
    sdic: string;
    nItemsindex: Integer;
    nEffectindex: Integer;
    npicindex: Integer;
  end;
  pTshoplist = ^Tshoplist;
  TConsoleData = packed record
    nCrcExtInt: Integer;
    nCrcDllInt: Integer;
  end;


  TItemBind = record
    nMakeIdex: Integer;
    nItemIdx: Integer;
    sBindName: string[20];
  end;
  pTItemBind = ^TItemBind;

//  TConsoleData = packed record
//    nCrcExtInt: Integer;
//   nCrcDllInt: Integer;
 // end;
  pTConsoleData = ^TConsoleData;
{$IF OEMVER = OEM775}
  TLevelInfo = record
    wHP: Word;
    wMP: Word;
    dwExp: LongWord;
    wAC: Word;
    wMaxAC: Word;
    wACLimit: Word;
    wMAC: Word;
    wMaxMAC: Word;
    wMACLimit: Word;
    wDC: Word;
    wMaxDC: Word;
    wDCLimit: Word;
    dwDCExp: LongWord;
    wMC: Word;
    wMaxMC: Word;
    wMCLimit: Word;
    dwMCExp: LongWord;
    wSC: Word;
    wMaxSC: Word;
    wSCLimit: Word;
    dwSCExp: LongWord;
  end;
  Tshoplist = record
    stypename: string;
    sItemsname: string;
    sItemspic: string;
    sdic: string;
    nItemsindex: Integer;
    nEffectindex: Integer;
    npicindex: Integer;
  end;
  pTshoplist = ^Tshoplist;
  TConsoleData = packed record
    nCrcExtInt: Integer;
    nCrcDllInt: Integer;
  end;
{$IFEND}
  {
  TScriptACTMsg = record
    nCode      :Integer;  //0x00
    sParam1    :String;   //0x04
    nParam1    :Integer;  //0x08
    sParam2    :String;   //0x0C
    nParam2    :Integer;  //0x10
    sParam3    :String;   //0x14
    nParam3    :Integer;  //0x18
  end;
  }

procedure SetProcessName(sName: string);
procedure CopyStdItemToOStdItem(StdItem: pTStdItem; OStdItem: pTOStdItem);
function GetExVersionNO(nVersionDate: Integer; var nOldVerstionDate: Integer): Integer;
function GetNextDirection(sX, sY, dx, dy: Integer): Byte;
function LoadLineNotice(FileName: string): Boolean;
function GetMultiServerAddrPort(btServerIndex: Byte; var sIPaddr: string; var nPort: Integer): Boolean;
procedure MainOutMessage(Msg: string);

function AddDateTimeOfDay(DateTime: TDateTime; nDay: Integer): TDateTime;
function GetGoldShape(nGold: Integer): Word; //金币在地上显示的外形ID
function GetRandomLook(nBaseLook, nRage: Integer): Integer;
function FilterShowName(sName: string): string;
function CheckGuildName(sGuildName: string): Boolean;
function CheckUserItems(nIdx: Integer; StdItem: TItem): Boolean;
function GetItemNumber(): Integer;
function GetItemNumberEx(): Integer;
function sub_4B2F80(nDir, nRage: Integer): Byte;
function GetValNameNo(sText: string): Integer;
function IsAccessory(nIndex: Integer): Boolean;
function GetMakeItemInfo(sItemName: string): TStringList;
procedure AddLogonCostLog(sMsg: string);
procedure AddGameDataLog(sMsg: string);
procedure TrimStringList(sList: TStringList);
function CanMakeItem(sItemName: string): Boolean;
function CanMoveMap(sMapName: string): Boolean;
function CanSellItem(sItemName: string): Boolean;
function LoadMonSayMsg(): Boolean;
//function Loadshoplist(): Boolean; //+++
function LoadItemBindIPaddr(): Boolean;
function SaveItemBindIPaddr(): Boolean;
function LoadItemBindAccount(): Boolean;
function SaveItemBindAccount(): Boolean;
function LoadItemBindCharName(): Boolean;
function SaveItemBindCharName(): Boolean;
function LoadDisableMakeItem(): Boolean;
function SaveDisableMakeItem(): Boolean;
function LoadUnMasterList(): Boolean;
function SaveUnMasterList(): Boolean;
function LoadUnForceMasterList(): Boolean;
function SaveUnForceMasterList(): Boolean;
function LoadEnableMakeItem(): Boolean;
function SaveEnableMakeItem(): Boolean;
function LoadDisableMoveMap(): Boolean;
function SaveDisableMoveMap(): Boolean;
function LoadAllowSellOffItem(): Boolean;
function SaveAllowSellOffItem(): Boolean;
function SaveChatLog(): Boolean;

function GetUseItemName(nIndex: Integer): string;
function GetUseItemIdx(sName: string): Integer;
function LoadMonDropLimitList(): Boolean;
function SaveMonDropLimitList(): Boolean;
function LoadDisableTakeOffList(): Boolean;
function SaveDisableTakeOffList(): Boolean;
function InDisableTakeOffList(nItemIdx: Integer): Boolean;
function LoadDisableSendMsgList(): Boolean;
function SaveDisableSendMsgList(): Boolean;
function GetDisableSendMsgList(sHumanName: string): Boolean;
function LoadGameLogItemNameList(): Boolean;
function GetGameLogItemNameList(sItemName: string): Byte;
function SaveGameLogItemNameList(): Boolean;
function LoadDenyIPAddrList(): Boolean;
function GetDenyIPaddrList(sIPaddr: string): Boolean;
function SaveDenyIPAddrList(): Boolean;
function LoadDenyAccountList(): Boolean;
function GetDenyAccountList(sAccount: string): Boolean;
function SaveDenyAccountList(): Boolean;
function LoadDenyChrNameList(): Boolean;
function GetDenyChrNameList(sChrName: string): Boolean;
function SaveDenyChrNameList(): Boolean;
function LoadNoClearMonList(): Boolean;
function GetNoClearMonList(sMonName: string): Boolean;
function SaveNoClearMonList(): Boolean;
procedure LoadExp();
procedure LoadGameCommand();
procedure LoadString();
procedure LoadConfig();
function GetRGB(c256: Byte): TColor; stdcall;
procedure SendGameCenterMsg(wIdent: Word; sSENDMSG: string);
function GetIPLocal(sIPaddr: string): string;
function IsCheapStuff(tByte: Byte): Boolean;
function CompareIPaddr(sIPaddr, dIPaddr: string): Boolean;
var
  RemoteXORKey: Integer = -1;
  LocalXORKey: Integer = -2;
  M2ServerVersion: Single = 2;
  g_nGetLicenseInfo: Integer = -1;
  g_nM2Crc: Integer;
  g_dwGameCenterHandle: THandle;
  IsDebuggerPresent: function(): Boolean; stdcall;
  CheckVersion: TCheckVersion = nil;
  nCheckVersion: Integer = -1;
  //CertCheck         :TList; //用于检查角色创建释放
  //EventCheck         :TList; //用于检查事件创建释放
{$IF OEMVER = OEM775}
  Level775: TIniFile;
{$IFEND}
  Config: TIniFile;
  ExpConf: TIniFile;
  CommandConf: TIniFile;
  StringConf: TIniFile;
  Memo: TMemo;
  nServerIndex: Integer = 0; //0x004EBC04
  RunSocket: TRunSocket; //0x004EBB84
  MainLogMsgList: TStringList; //0x004EBC60
  LogStringList: TStringList; //0x004EBC64
  LogonCostLogList: TStringList; //0x004EBC68
  g_MapManager: TMapManager; //0x004EBB90
  ItemUnit: TItemUnit;
  MagicManager: TMagicManager; //0x004EBB98
  NoticeManager: TNoticeManager; //0x004EBB9C
  g_GuildManager: TGuildManager; //0x004EBBA0
  g_EventManager: TEventManager; //0x004EBBA4
  g_CastleManager: TCastleManager;
//  g_UserCastle        :TUserCastle;      //0x004EBBA8
  FrontEngine: TFrontEngine; //0x004EBB88
  UserEngine: TUserEngine; //0x004EBB8C
  RobotManage: TRobotManage;
  g_MakeItemList: TStringList; //0x004EBBAC
  g_StartPoint: TGList;
  g_RedStartPoint: TStartPoint;
  ServerTableList: TList; //0x004EBBB4
  g_DenySayMsgList: TQuickList; //0x004EBBB8
  MiniMapList: TStringList; //0x004EBBBC
  g_UnbindList: TStringList; //0x004EBBC0
  LineNoticeList: TStringList; //0x004EBBC4
  QuestDiaryList: TList; //0x004EBBC8
  ItemEventList: TStringList; //0x004EBBCC
  AbuseTextList: TStringList; //0x004EBBD0
  g_MonSayMsgList: TStringList; //怪物说明信息列表
  g_DisableMakeItemList: TGStringList; //禁止制造物品列表
  g_EnableMakeItemList: TGStringList; //禁止制造物品列表
  g_DisableSellOffList: TGStringList;
  g_DisableMoveMapList: TGStringList; //禁止移动地图列表
  g_ItemNameList: TGList; //物品别名列表
  g_DisableSendMsgList: TGStringList; //禁止发信息名称列表
  g_MonDropLimitLIst: TGStringList; //怪物爆物品限制
  g_DisableTakeOffList: TGStringList; //禁止取下物品列表
  g_ChatLoggingList: TGStringList;
  g_StartPointList: TGStringList; //0x004EBBB0
  g_Shoplist: TGList; //+++
  g_ItemBindIPaddr: TGList;
  g_ItemBindAccount: TGList;
  g_ItemBindCharName: TGList;
  g_UnMasterList: TGStringList; //出师记录表
  g_UnForceMasterList: TGStringList; //强行出师记录表
  g_GameLogItemNameList: TGStringList; //游戏日志物品名
  g_boGameLogGold: Boolean;
  g_boGameLogGameGold: Boolean;
  g_boGameLogGamePoint: Boolean;
  g_boGameLogHumanDie: Boolean;
  g_DenyIPAddrList: TGStringList; //IP过滤列表
  g_DenyChrNameList: TGStringList; //角色过滤列表
  g_DenyAccountList: TGStringList; //登录帐号过滤列表
  g_NoClearMonList: TGStringList; //不清除怪物列表
  n4EBBD0: Integer;


  LogMsgCriticalSection: TRTLCriticalSection; //0x4EBC40
  ProcessMsgCriticalSection: TRTLCriticalSection; //0x4EBC44
  UserDBSection: TRTLCriticalSection;
  ProcessHumanCriticalSection: TRTLCriticalSection;



  CS_6: TCriticalSection; //0x4EBC58
  //MD5               :TMD5;
//  sDBSocStr         :String;            //0x4EBC84
//  boGetHumDataBusy  :Boolean;           //0x4EBC88
  g_nTotalHumCount: Integer; //0x004EB3C3
//  g_nLoadHumanDBErrorCount :Integer; //0x4EBC8C           :Integer;
//  g_nLoadHumanDBCount      :Integer;  //0x4EBC90
//  g_nSaveHumanDBCount      :Integer;//0x4EBC94           :Integer;
//  g_nHumanDBQueryID        :SmallInt;//0x4EBC7C           :SmallInt;
  g_boMission: Boolean;
  g_sMissionMap: string;
  g_nMissionX: Integer;
  g_nMissionY: Integer;

  boStartReady: Boolean; //0x4EBC78
  g_boExitServer: Boolean; //004EBC79
  boFilterWord: Boolean;

  sLogFileName: string; //004EBBFC
  nRunTimeMin: Integer;
  nRunTimeMax: Integer;
  {
  dwSockCountMin    :LongWord;
  dwSockCountMax    :LongWord;
  dwUsrTimeMin      :LongWord;
  dwUsrTimeMax      :LongWord;
  dwHumCountMin     :LongWord;
  dwHumCountMax     :LongWord;
  dwMonTimeMin      :LongWord;
  dwMonTimeMax      :LongWord;
  dwUsrRotCountMin  :LongWord;
  dwUsrRotCountMax  :LongWord;
  }
  g_nBaseObjTimeMin: Integer;
  g_nBaseObjTimeMax: Integer;
  g_nSockCountMin: Integer;
  g_nSockCountMax: Integer;
  g_nUsrTimeMin: Integer;
  g_nUsrTimeMax: Integer;
  g_nHumCountMin: Integer;
  g_nHumCountMax: Integer;
  g_nMonTimeMin: Integer;
  g_nMonTimeMax: Integer;
  g_nMonGenTime: Integer;
  g_nMonGenTimeMin: Integer;
  g_nMonGenTimeMax: Integer;
  g_nMonProcTime: Integer;
  g_nMonProcTimeMin: Integer;
  g_nMonProcTimeMax: Integer;
  dwUsrRotCountMin: Integer;
  dwUsrRotCountMax: Integer;

  g_dwUsrRotCountTick: LongWord; //0x4EBD48          :LongWord;
  g_nProcessHumanLoopTime: Integer; //0x004EBD54    //处理人物列表循环次数
  g_dwHumLimit: LongWord = 30; //0x4EBD98
  g_dwMonLimit: LongWord = 30; //0x4EBD9C
  g_dwZenLimit: LongWord = 5; //0x4EBDA0
  g_dwNpcLimit: LongWord = 5; //0x4EBDA4
  g_dwSocLimit: LongWord = 10; //0x4EBDA8
  g_dwSocCheckTimeOut: LongWord = 50; //2 * 1000;
  nDecLimit: Integer = 20; //0x4EBDAC

  nShiftUsrDataNameNo: Integer;
{$IF OEMVER = OEM775}
  sConfig775FileName: string = '.\775.txt';
{$IFEND}     {保存配置文件}
  sConfigFileName: string = '.\!Setup.txt';
  sExpConfigFileName: string = '.\Exps.ini';
  sCommandFileName: string = '.\Command.ini';
  sStringFileName: string = '.\String.ini';

  dwRunDBTimeMax: LongWord; //0x004EBC98
  g_dwStartTick: LongWord; //0x004EBD14

  g_dwRunTick: LongWord; //0x4EBD18;
  n4EBD1C: Integer;

  g_nGameTime: Integer;

  g_sMonGenInfo1: string; //0x4EBD58
  g_sMonGenInfo2: string; //0x4EBD78
  g_sProcessName: string;
  g_sOldProcessName: string;


  g_ManageNPC: TNormNpc;
  g_RobotNPC: TNormNpc;
  g_FunctionNPC: TMerchant;
  g_DynamicVarList: TList;
  nCurrentMonthly: Integer; //0x004EBD00
  nTotalTimeUsage: Integer; //0x004EBD04
  nLastMonthlyTotalUsage: Integer; //0x004EBD08
  nGrossTotalCnt: Integer; //0x004EBD0C
  nGrossResetCnt: Integer; //0x004EBD10
  n4EBB68: Integer; //0x004EBB68
  n4EBB6C: Integer; //0x004EBB6C


  ColorTable: array[0..255] of TRGBQuad;
  ColorArray: array[0..1023] of Byte = (
    $00, $00, $00, $00, $00, $00, $80, $00, $00, $80, $00, $00, $00, $80, $80, $00,
    $80, $00, $00, $00, $80, $00, $80, $00, $80, $80, $00, $00, $C0, $C0, $C0, $00,
    $97, $80, $55, $00, $C8, $B9, $9D, $00, $73, $73, $7B, $00, $29, $29, $2D, $00,
    $52, $52, $5A, $00, $5A, $5A, $63, $00, $39, $39, $42, $00, $18, $18, $1D, $00,
    $10, $10, $18, $00, $18, $18, $29, $00, $08, $08, $10, $00, $71, $79, $F2, $00,
    $5F, $67, $E1, $00, $5A, $5A, $FF, $00, $31, $31, $FF, $00, $52, $5A, $D6, $00,
    $00, $10, $94, $00, $18, $29, $94, $00, $00, $08, $39, $00, $00, $10, $73, $00,
    $00, $18, $B5, $00, $52, $63, $BD, $00, $10, $18, $42, $00, $99, $AA, $FF, $00,
    $00, $10, $5A, $00, $29, $39, $73, $00, $31, $4A, $A5, $00, $73, $7B, $94, $00,
    $31, $52, $BD, $00, $10, $21, $52, $00, $18, $31, $7B, $00, $10, $18, $2D, $00,
    $31, $4A, $8C, $00, $00, $29, $94, $00, $00, $31, $BD, $00, $52, $73, $C6, $00,
    $18, $31, $6B, $00, $42, $6B, $C6, $00, $00, $4A, $CE, $00, $39, $63, $A5, $00,
    $18, $31, $5A, $00, $00, $10, $2A, $00, $00, $08, $15, $00, $00, $18, $3A, $00,
    $00, $00, $08, $00, $00, $00, $29, $00, $00, $00, $4A, $00, $00, $00, $9D, $00,
    $00, $00, $DC, $00, $00, $00, $DE, $00, $00, $00, $FB, $00, $52, $73, $9C, $00,
    $4A, $6B, $94, $00, $29, $4A, $73, $00, $18, $31, $52, $00, $18, $4A, $8C, $00,
    $11, $44, $88, $00, $00, $21, $4A, $00, $10, $18, $21, $00, $5A, $94, $D6, $00,
    $21, $6B, $C6, $00, $00, $6B, $EF, $00, $00, $77, $FF, $00, $84, $94, $A5, $00,
    $21, $31, $42, $00, $08, $10, $18, $00, $08, $18, $29, $00, $00, $10, $21, $00,
    $18, $29, $39, $00, $39, $63, $8C, $00, $10, $29, $42, $00, $18, $42, $6B, $00,
    $18, $4A, $7B, $00, $00, $4A, $94, $00, $7B, $84, $8C, $00, $5A, $63, $6B, $00,
    $39, $42, $4A, $00, $18, $21, $29, $00, $29, $39, $46, $00, $94, $A5, $B5, $00,
    $5A, $6B, $7B, $00, $94, $B1, $CE, $00, $73, $8C, $A5, $00, $5A, $73, $8C, $00,
    $73, $94, $B5, $00, $73, $A5, $D6, $00, $4A, $A5, $EF, $00, $8C, $C6, $EF, $00,
    $42, $63, $7B, $00, $39, $56, $6B, $00, $5A, $94, $BD, $00, $00, $39, $63, $00,
    $AD, $C6, $D6, $00, $29, $42, $52, $00, $18, $63, $94, $00, $AD, $D6, $EF, $00,
    $63, $8C, $A5, $00, $4A, $5A, $63, $00, $7B, $A5, $BD, $00, $18, $42, $5A, $00,
    $31, $8C, $BD, $00, $29, $31, $35, $00, $63, $84, $94, $00, $4A, $6B, $7B, $00,
    $5A, $8C, $A5, $00, $29, $4A, $5A, $00, $39, $7B, $9C, $00, $10, $31, $42, $00,
    $21, $AD, $EF, $00, $00, $10, $18, $00, $00, $21, $29, $00, $00, $6B, $9C, $00,
    $5A, $84, $94, $00, $18, $42, $52, $00, $29, $5A, $6B, $00, $21, $63, $7B, $00,
    $21, $7B, $9C, $00, $00, $A5, $DE, $00, $39, $52, $5A, $00, $10, $29, $31, $00,
    $7B, $BD, $CE, $00, $39, $5A, $63, $00, $4A, $84, $94, $00, $29, $A5, $C6, $00,
    $18, $9C, $10, $00, $4A, $8C, $42, $00, $42, $8C, $31, $00, $29, $94, $10, $00,
    $10, $18, $08, $00, $18, $18, $08, $00, $10, $29, $08, $00, $29, $42, $18, $00,
    $AD, $B5, $A5, $00, $73, $73, $6B, $00, $29, $29, $18, $00, $4A, $42, $18, $00,
    $4A, $42, $31, $00, $DE, $C6, $63, $00, $FF, $DD, $44, $00, $EF, $D6, $8C, $00,
    $39, $6B, $73, $00, $39, $DE, $F7, $00, $8C, $EF, $F7, $00, $00, $E7, $F7, $00,
    $5A, $6B, $6B, $00, $A5, $8C, $5A, $00, $EF, $B5, $39, $00, $CE, $9C, $4A, $00,
    $B5, $84, $31, $00, $6B, $52, $31, $00, $D6, $DE, $DE, $00, $B5, $BD, $BD, $00,
    $84, $8C, $8C, $00, $DE, $F7, $F7, $00, $18, $08, $00, $00, $39, $18, $08, $00,
    $29, $10, $08, $00, $00, $18, $08, $00, $00, $29, $08, $00, $A5, $52, $00, $00,
    $DE, $7B, $00, $00, $4A, $29, $10, $00, $6B, $39, $10, $00, $8C, $52, $10, $00,
    $A5, $5A, $21, $00, $5A, $31, $10, $00, $84, $42, $10, $00, $84, $52, $31, $00,
    $31, $21, $18, $00, $7B, $5A, $4A, $00, $A5, $6B, $52, $00, $63, $39, $29, $00,
    $DE, $4A, $10, $00, $21, $29, $29, $00, $39, $4A, $4A, $00, $18, $29, $29, $00,
    $29, $4A, $4A, $00, $42, $7B, $7B, $00, $4A, $9C, $9C, $00, $29, $5A, $5A, $00,
    $14, $42, $42, $00, $00, $39, $39, $00, $00, $59, $59, $00, $2C, $35, $CA, $00,
    $21, $73, $6B, $00, $00, $31, $29, $00, $10, $39, $31, $00, $18, $39, $31, $00,
    $00, $4A, $42, $00, $18, $63, $52, $00, $29, $73, $5A, $00, $18, $4A, $31, $00,
    $00, $21, $18, $00, $00, $31, $18, $00, $10, $39, $18, $00, $4A, $84, $63, $00,
    $4A, $BD, $6B, $00, $4A, $B5, $63, $00, $4A, $BD, $63, $00, $4A, $9C, $5A, $00,
    $39, $8C, $4A, $00, $4A, $C6, $63, $00, $4A, $D6, $63, $00, $4A, $84, $52, $00,
    $29, $73, $31, $00, $5A, $C6, $63, $00, $4A, $BD, $52, $00, $00, $FF, $10, $00,
    $18, $29, $18, $00, $4A, $88, $4A, $00, $4A, $E7, $4A, $00, $00, $5A, $00, $00,
    $00, $88, $00, $00, $00, $94, $00, $00, $00, $DE, $00, $00, $00, $EE, $00, $00,
    $00, $FB, $00, $00, $94, $5A, $4A, $00, $B5, $73, $63, $00, $D6, $8C, $7B, $00,
    $D6, $7B, $6B, $00, $FF, $88, $77, $00, $CE, $C6, $C6, $00, $9C, $94, $94, $00,
    $C6, $94, $9C, $00, $39, $31, $31, $00, $84, $18, $29, $00, $84, $00, $18, $00,
    $52, $42, $4A, $00, $7B, $42, $52, $00, $73, $5A, $63, $00, $F7, $B5, $CE, $00,
    $9C, $7B, $8C, $00, $CC, $22, $77, $00, $FF, $AA, $DD, $00, $2A, $B4, $F0, $00,
    $9F, $00, $DF, $00, $B3, $17, $E3, $00, $F0, $FB, $FF, $00, $A4, $A0, $A0, $00,
    $80, $80, $80, $00, $00, $00, $FF, $00, $00, $FF, $00, $00, $00, $FF, $FF, $00,
    $FF, $00, $00, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $00, $FF, $FF, $FF, $00
    );



  g_GMRedMsgCmd: Char = '!';
  g_nGMREDMSGCMD: Integer = 6;

  g_dwSendOnlineTick: LongWord;


  g_HighLevelHuman: TObject = nil;
  g_HighPKPointHuman: TObject = nil;
  g_HighDCHuman: TObject = nil;
  g_HighMCHuman: TObject = nil;
  g_HighSCHuman: TObject = nil;
  g_HighOnlineHuman: TObject = nil;


  g_dwSpiritMutinyTick: LongWord;


{$IF USECODE = USEREMOTECODE}
  g_Encode6BitBuf: TEncode6BitBuf = (
    $55, $8B, $EC, $83, $C4, $E0, $89, $4D, $F4, $89, $55, $F8, $89, $45, $FC, $33,
    $C0, $89, $45, $EC, $C6, $45, $E5, $00, $33, $C0, $89, $45, $E8, $8B, $45, $F4,
    $48, $85, $C0, $0F, $8C, $C3, $00, $00, $00, $40, $89, $45, $E0, $C7, $45, $F0,
    $00, $00, $00, $00, $8B, $45, $E8, $3B, $45, $08, $0F, $8D, $AC, $00, $00, $00,
    $8B, $45, $FC, $8B, $55, $F0, $8A, $04, $10, $88, $45, $E6, $8B, $4D, $EC, $83,
    $C1, $02, $33, $C0, $8A, $45, $E6, $D3, $E8, $0A, $45, $E5, $24, $3F, $88, $45,
    $E7, $8B, $45, $EC, $83, $C0, $02, $B9, $08, $00, $00, $00, $2B, $C8, $33, $C0,
    $8A, $45, $E6, $D3, $E0, $C1, $E8, $02, $24, $3F, $88, $45, $E5, $83, $45, $EC,
    $02, $83, $7D, $EC, $06, $7D, $13, $8A, $45, $E7, $04, $3C, $8B, $55, $F8, $8B,
    $4D, $E8, $88, $04, $0A, $FF, $45, $E8, $EB, $46, $8B, $45, $08, $48, $3B, $45,
    $E8, $7E, $23, $8A, $45, $E7, $04, $3C, $8B, $55, $F8, $8B, $4D, $E8, $88, $04,
    $0A, $8A, $45, $E5, $04, $3C, $8B, $55, $F8, $8B, $4D, $E8, $88, $44, $0A, $01,
    $83, $45, $E8, $02, $EB, $11, $8A, $45, $E7, $04, $3C, $8B, $55, $F8, $8B, $4D,
    $E8, $88, $04, $0A, $FF, $45, $E8, $33, $C0, $89, $45, $EC, $C6, $45, $E5, $00,
    $FF, $45, $F0, $FF, $4D, $E0, $0F, $85, $48, $FF, $FF, $FF, $83, $7D, $EC, $00,
    $7E, $11, $8A, $45, $E5, $04, $3C, $8B, $55, $F8, $8B, $4D, $E8, $88, $04, $0A,
    $FF, $45, $E8, $8B, $45, $F8, $8B, $55, $E8, $C6, $04, $10, $00, $8B, $E5, $5D,
    $C2, $04, $00, $90);

  g_Decode6BitBuf: TDecode6BitBuf = (
    $55, $8B, $EC, $83, $C4, $DC, $89, $4D, $F4, $89, $55, $F8, $89, $45, $FC, $C7,
    $45, $EC, $02, $00, $00, $00, $33, $C0, $89, $45, $E8, $33, $C0, $89, $45, $E4,
    $C6, $45, $E2, $00, $8B, $45, $F4, $48, $85, $C0, $0F, $8C, $B5, $00, $00, $00,
    $40, $89, $45, $DC, $C7, $45, $F0, $00, $00, $00, $00, $8B, $45, $FC, $8B, $55,
    $F0, $0F, $B6, $04, $10, $83, $E8, $3C, $78, $10, $8B, $45, $FC, $8B, $55, $F0,
    $8A, $04, $10, $2C, $3C, $88, $45, $E3, $EB, $0A, $33, $C0, $89, $45, $E4, $E9,
    $81, $00, $00, $00, $8B, $45, $E4, $3B, $45, $08, $7D, $79, $8B, $45, $E8, $83,
    $C0, $06, $83, $F8, $08, $7C, $43, $B9, $06, $00, $00, $00, $2B, $4D, $EC, $8A,
    $45, $E3, $24, $3F, $25, $FF, $00, $00, $00, $D3, $E8, $0A, $45, $E2, $88, $45,
    $E1, $8B, $45, $F8, $8B, $55, $E4, $8A, $4D, $E1, $88, $0C, $10, $FF, $45, $E4,
    $33, $C0, $89, $45, $E8, $83, $7D, $EC, $06, $7D, $06, $83, $45, $EC, $02, $EB,
    $09, $C7, $45, $EC, $02, $00, $00, $00, $EB, $1F, $8B, $4D, $EC, $8A, $45, $E3,
    $D2, $E0, $8B, $55, $EC, $22, $82, $02, $15, $5E, $00, $88, $45, $E2, $B8, $08,
    $00, $00, $00, $2B, $45, $EC, $01, $45, $E8, $FF, $45, $F0, $FF, $4D, $DC, $0F,
    $85, $56, $FF, $FF, $FF, $8B, $45, $F8, $8B, $55, $E4, $C6, $04, $10, $00, $8B,
    $E5, $5D, $C2, $04, $00);
{$IFEND}
  g_Config: TM2Config = (
    nConfigSize: SizeOf(TM2Config);
    sServerName             :'热血传奇';
    sServerIPaddr           :'127.0.0.1';
    sWebSite                :'';   // http://www.***.com
    sBbsSite                :'';   // http://bbs.***.com
    sClientDownload         :'';   // http://www.***.com
    sQQ                     :'';   // 123456789
    sPhone                  :'';   // 123456789
    sBankAccount0           :'工商银行';
    sBankAccount1           :'农业银行';
    sBankAccount2           :'建设银行';
    sBankAccount3           :'邮政储蓄';
    sBankAccount4           :'民生银行';
    sBankAccount5           :'银行信息';
    sBankAccount6           :'银行信息';
    sBankAccount7           :'银行信息';
    sBankAccount8           :'银行信息';
    sBankAccount9           :'银行信息';
    nServerNumber: 0;
    boVentureServer: False;
    boTestServer: True;
    boServiceMode: False;
    boNonPKServer: False;
    nTestLevel: 1;
    nTestGold: 0;
    nTestUserLimit: 1000;
    nSendBlock: 1024;
    nCheckBlock: 4069;
    nAvailableBlock: 8000;
    nGateLoad: 0;
    nUserFull: 1000;
    nZenFastStep: 300;
    sGateAddr: '127.0.0.1';
    nGatePort: 5000;
    sDBAddr: '127.0.0.1';
    nDBPort: 6000;
    sIDSAddr: '127.0.0.1';
    nIDSPort: 5600;
    sMsgSrvAddr: '127.0.0.1';
    nMsgSrvPort: 4900;
    sLogServerAddr: '127.0.0.1';
    nLogServerPort: 10000;
    boDiscountForNightTime: False;
    nHalfFeeStart: 2;
    nHalfFeeEnd: 10;
    boViewHackMessage: False;
    boViewAdmissionFailure: False;
    sBaseDir: '.\Share\';
    sGuildDir: '.\GuildBase\Guilds\';
    sGuildFile: '.\GuildBase\GuildList.txt';
    sVentureDir: '.\ShareV\';
    sConLogDir: '.\ConLog\';
    sCastleDir: '.\Envir\Castle\';
    sCastleFile: '.\Envir\Castle\List.txt';
    sEnvirDir: '.\Envir\';
    sMapDir: '.\Map\';
    sNoticeDir: '.\Notice\';
    sLogDir: '.\Log\';
    sPlugDir: '.\Plug-in\';
    sClientFile1: 'mir.1';
    sClientFile2: 'mir.2';
    sClientFile3: 'mir.3';

    sClothsMan              :'布衣(男)';
    sClothsWoman            :'布衣(女)';
    sWoodenSword            :'木剑';
    sCandle                 :'蜡烛';
    sBasicDrug              :'金创药(小量)';
    sGoldStone              :'金矿';
    sSilverStone            :'银矿';
    sSteelStone             :'铁矿';
    sCopperStone            :'铜矿';
    sBlackStone             :'黑铁矿';
    sGemStone1              :'RubyOre';
    sGemStone2              :'AmethystOre';
    sGemStone3              :'NephriteOre';
    sGemStone4              :'PlatinumOre';
    sZuma                   :('祖玛卫士','祖玛雕像','祖玛弓箭手','楔蛾');
    sBee                    :'小角蝇';
    sSpider                 :'小蜘蛛';
    sWomaHorn               :'沃玛号角';
    sZumaPiece              :'祖玛头像';
    sGameGoldName           :'元宝';    //游戏币
    sGamePointName          :'游戏点';  //游戏点（能量点）
    sPayMentPointName       :'充值点';  //秒卡点
    DBSocket: INVALID_SOCKET;
    nHealthFillTime: 300;
    nSpellFillTime: 800;
    nMonUpLvNeedKillBase: 100;
    nMonUpLvRate: 16;
    MonUpLvNeedKillCount: (0, 0, 50, 100, 200, 300, 600, 1200);
    SlaveColor: ($FF, $FE, $93, $9A, $E5, $A8, $B4, $FC, 249);
//    dwNeedExps              :TLevelNeedExp;
    WideAttack: (7, 1, 2);
    CrsAttack: (7, 1, 2, 3, 4, 5, 6);
    SpitMap: (
    ((0, 0, 1, 0, 0), //DR_UP
    (0, 0, 1, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0)),
    ((0, 0, 0, 0, 1), //DR_UPRIGHT
    (0, 0, 0, 1, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0)),
    ((0, 0, 0, 0, 0), //DR_RIGHT
    (0, 0, 0, 0, 0),
    (0, 0, 0, 1, 1),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0)),
    ((0, 0, 0, 0, 0), //DR_DOWNRIGHT
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 1, 0),
    (0, 0, 0, 0, 1)),
    ((0, 0, 0, 0, 0), //DR_DOWN
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 1, 0, 0),
    (0, 0, 1, 0, 0)),
    ((0, 0, 0, 0, 0), //DR_DOWNLEFT
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 1, 0, 0, 0),
    (1, 0, 0, 0, 0)),
    ((0, 0, 0, 0, 0), //DR_LEFT
    (0, 0, 0, 0, 0),
    (1, 1, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0)),
    ((1, 0, 0, 0, 0), //DR_UPLEFT
    (0, 1, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0))
    );

    sHomeMap: '0';
    nHomeX: 289;
    nHomeY: 618;
    sRedHomeMap: '3';
    nRedHomeX: 845;
    nRedHomeY: 674;
    sRedDieHomeMap: '3';
    nRedDieHomeX: 839;
    nRedDieHomeY: 668;
    boJobHomePoint: False;
    sWarriorHomeMap: '0';
    nWarriorHomeX: 289;
    nWarriorHomeY: 618;
    sWizardHomeMap: '0';
    nWizardHomeX: 650;
    nWizardHomeY: 631;
    sTaoistHomeMap: '0';
    nTaoistHomeX: 334;
    nTaoistHomeY: 266;
    dwDecPkPointTime: 2 * 60 * 1000;
    nDecPkPointCount: 1;
    dwPKFlagTime: 60 * 1000;
    nKillHumanAddPKPoint: 100;
    nKillHumanDecLuckPoint: 500;
    dwDecLightItemDrugTime: 500;
    nSafeZoneSize: 10;
    nStartPointSize: 2;
    dwHumanGetMsgTime: 200;
    nGroupMembersMax: 10;
    sFireBallSkill: '火球术';
    sHealSkill: '治愈术';
    ReNewNameColor: ($FF, $FE, $93, $9A, $E5, $A8, $B4, $FC, $B4, $FC);
    dwReNewNameColorTime: 2000;
    boReNewChangeColor: True;
    boReNewLevelClearExp: True;
    BonusAbilofWarr: (DC: 17; MC: 20; SC: 20; AC: 20; MAC: 20; HP: 1; MP: 3; Hit: 20; Speed: 35; X2: 0);
    BonusAbilofWizard: (DC: 17; MC: 25; SC: 30; AC: 20; MAC: 15; HP: 2; MP: 1; Hit: 25; Speed: 35; X2: 0);
    BonusAbilofTaos: (DC: 20; MC: 30; SC: 17; AC: 20; MAC: 15; HP: 2; MP: 1; Hit: 30; Speed: 30; X2: 0);
    NakedAbilofWarr: (DC: 512; MC: 2560; SC: 20; AC: 768; MAC: 1280; HP: 0; MP: 0; Hit: 0; Speed: 0; X2: 0);
    NakedAbilofWizard: (DC: 512; MC: 512; SC: 2560; AC: 1280; MAC: 768; HP: 0; MP: 0; Hit: 5; Speed: 0; X2: 0);
    NakedAbilofTaos: (DC: 20; MC: 30; SC: 17; AC: 20; MAC: 15; HP: 2; MP: 1; Hit: 30; Speed: 30; X2: 0);
    nUpgradeWeaponMaxPoint: 20;
    nUpgradeWeaponPrice: 10000;
    dwUPgradeWeaponGetBackTime: 60 * 60 * 1000;
    nClearExpireUpgradeWeaponDays: 8;
    nUpgradeWeaponDCRate: 100;
    nUpgradeWeaponDCTwoPointRate: 30;
    nUpgradeWeaponDCThreePointRate: 200;
    nUpgradeWeaponSCRate: 100;
    nUpgradeWeaponSCTwoPointRate: 30;
    nUpgradeWeaponSCThreePointRate: 200;
    nUpgradeWeaponMCRate: 100;
    nUpgradeWeaponMCTwoPointRate: 30;
    nUpgradeWeaponMCThreePointRate: 200;
    dwProcessMonstersTime: 10;
    dwRegenMonstersTime: 200;
    nMonGenRate: 10;
    nProcessMonRandRate: 5;
    nProcessMonLimitCount: 5;
    nSoftVersionDate: 20020522;
    boCanOldClientLogon: True;
    dwConsoleShowUserCountTime: 10 * 60 * 1000;
    dwShowLineNoticeTime: 5 * 60 * 1000;
    nLineNoticeColor: 2;
    nStartCastleWarDays: 4;
    nStartCastlewarTime: 20;
    dwShowCastleWarEndMsgTime: 10 * 60 * 1000;
    dwCastleWarTime: 3 * 60 * 60 * 1000;
    dwGetCastleTime: 10 * 60 * 1000;
    dwGuildWarTime: 3 * 60 * 60 * 1000;
    nBuildGuildPrice: 1000000;
    nGuildWarPrice: 30000;
    nMakeDurgPrice: 100;
    nHumanMaxGold: 10000000;
    nHumanTryModeMaxGold: 100000;
    nTryModeLevel: 7;
    boTryModeUseStorage: False;
    nCanShoutMsgLevel: 7;
    boShowMakeItemMsg: False;
    boShutRedMsgShowGMName: False;
    nSayMsgMaxLen: 80;
    dwSayMsgTime: 3 * 1000;
    nSayMsgCount: 2;
    dwDisableSayMsgTime: 60 * 1000;
    nSayRedMsgMaxLen: 255;
    boShowGuildName: True;
    boShowRankLevelName: False;
    boMonSayMsg: False;
    nStartPermission: 0;
    boKillHumanWinLevel: False;
    boKilledLostLevel: False;
    boKillHumanWinExp: False;
    boKilledLostExp: False;
    nKillHumanWinLevel: 1;
    nKilledLostLevel: 1;
    nKillHumanWinExp: 100000;
    nKillHumanLostExp: 100000;
    nHumanLevelDiffer: 10;
    nMonsterPowerRate: 10;
    nItemsPowerRate: 10;
    nItemsACPowerRate: 10;
    boSendOnlineCount: True;
    nSendOnlineCountRate: 10;
    dwSendOnlineTime: 5 * 60 * 1000;
    dwSaveHumanRcdTime: 10 * 60 * 1000;
    dwHumanFreeDelayTime: 5 * 60 * 1000;
    dwMakeGhostTime: 3 * 60 * 1000;
    dwClearDropOnFloorItemTime: 60 * 60 * 1000;
    dwFloorItemCanPickUpTime: 2 * 60 * 1000;
    boPasswordLockSystem: False; //是否启用密码保护系统
    boLockDealAction: False; //是否锁定交易操作
    boLockDropAction: False; //是否锁定扔物品操作
    boLockGetBackItemAction: False; //是否锁定取仓库操作
    boLockHumanLogin: False; //是否锁定走操作
    boLockWalkAction: False; //是否锁定走操作
    boLockRunAction: False; //是否锁定跑操作
    boLockHitAction: False; //是否锁定攻击操作
    boLockSpellAction: False; //是否锁定魔法操作
    boLockSendMsgAction: False; //是否锁定发信息操作
    boLockUserItemAction: False; //是否锁定使用物品操作
    boLockInObModeAction: False; //锁定时进入隐身状态
    nPasswordErrorCountLock: 3; //输入密码错误超过 指定次数则锁定密码
    boPasswordErrorKick: False; //输入密码错误超过限制则踢下线
    nSendRefMsgRange: 12;
    boDecLampDura: True;
    boHungerSystem: False;
    boHungerDecHP: False;
    boHungerDecPower: False;
    boDiableHumanRun: False;
    boRUNHUMAN: False;
    boRUNMON: False;
    boRunNpc: False;
    boRunGuard: False;
    boWarDisHumRun: False;
    boGMRunAll: True;
    dwTryDealTime: 3000;
    dwDealOKTime: 1000;
    boCanNotGetBackDeal: True;
    boDisableDeal: False;
    nMasterOKLevel: 500;
    nMasterOKCreditPoint: 0;
    nMasterOKBonusPoint: 0;
    boPKLevelProtect: False;
    nPKProtectLevel: 10;
    nRedPKProtectLevel: 10;
    nItemPowerRate: 10000;
    nItemExpRate: 10000;
    nScriptGotoCountLimit: 30;
    btHearMsgFColor: $00; //前景
    btHearMsgBColor: $FF; //背景
    btWhisperMsgFColor: $FC; //前景
    btWhisperMsgBColor: $FF; //背景
    btGMWhisperMsgFColor: $FF; //前景
    btGMWhisperMsgBColor: $38; //背景
    btCryMsgFColor: $0; //前景
    btCryMsgBColor: $97; //背景
    btGreenMsgFColor: $DB; //前景
    btGreenMsgBColor: $FF; //背景
    btBlueMsgFColor: $FF; //前景
    btBlueMsgBColor: $FC; //背景
    btRedMsgFColor: $FF; //前景
    btRedMsgBColor: $38; //背景
    btGuildMsgFColor: $DB; //前景
    btGuildMsgBColor: $FF; //背景
    btGroupMsgFColor: $C4; //前景
    btGroupMsgBColor: $FF; //背景
    btCustMsgFColor: $FC; //前景
    btCustMsgBColor: $FF; //背景
    nMonRandomAddValue: 10;
    nMakeRandomAddValue: 10;
    nWeaponDCAddValueMaxLimit: 12;
    nWeaponDCAddValueRate: 15;
    nWeaponMCAddValueMaxLimit: 12;
    nWeaponMCAddValueRate: 15;
    nWeaponSCAddValueMaxLimit: 12;
    nWeaponSCAddValueRate: 15;
    nDressDCAddRate: 40;
    nDressDCAddValueMaxLimit: 6;
    nDressDCAddValueRate: 20;
    nDressMCAddRate: 40;
    nDressMCAddValueMaxLimit: 6;
    nDressMCAddValueRate: 20;
    nDressSCAddRate: 40;
    nDressSCAddValueMaxLimit: 6;
    nDressSCAddValueRate: 20;
    nNeckLace202124DCAddRate: 40;
    nNeckLace202124DCAddValueMaxLimit: 6;
    nNeckLace202124DCAddValueRate: 20;
    nNeckLace202124MCAddRate: 40;
    nNeckLace202124MCAddValueMaxLimit: 6;
    nNeckLace202124MCAddValueRate: 20;
    nNeckLace202124SCAddRate: 40;
    nNeckLace202124SCAddValueMaxLimit: 6;
    nNeckLace202124SCAddValueRate: 20;
    nNeckLace19DCAddRate: 30;
    nNeckLace19DCAddValueMaxLimit: 6;
    nNeckLace19DCAddValueRate: 20;
    nNeckLace19MCAddRate: 30;
    nNeckLace19MCAddValueMaxLimit: 6;
    nNeckLace19MCAddValueRate: 20;
    nNeckLace19SCAddRate: 30;
    nNeckLace19SCAddValueMaxLimit: 6;
    nNeckLace19SCAddValueRate: 20;
    nArmRing26DCAddRate: 30;
    nArmRing26DCAddValueMaxLimit: 6;
    nArmRing26DCAddValueRate: 20;
    nArmRing26MCAddRate: 30;
    nArmRing26MCAddValueMaxLimit: 6;
    nArmRing26MCAddValueRate: 20;
    nArmRing26SCAddRate: 30;
    nArmRing26SCAddValueMaxLimit: 6;
    nArmRing26SCAddValueRate: 20;
    nRing22DCAddRate: 30;
    nRing22DCAddValueMaxLimit: 6;
    nRing22DCAddValueRate: 20;
    nRing22MCAddRate: 30;
    nRing22MCAddValueMaxLimit: 6;
    nRing22MCAddValueRate: 20;
    nRing22SCAddRate: 30;
    nRing22SCAddValueMaxLimit: 6;
    nRing22SCAddValueRate: 20;
    nRing23DCAddRate: 30;
    nRing23DCAddValueMaxLimit: 6;
    nRing23DCAddValueRate: 20;
    nRing23MCAddRate: 30;
    nRing23MCAddValueMaxLimit: 6;
    nRing23MCAddValueRate: 20;
    nRing23SCAddRate: 30;
    nRing23SCAddValueMaxLimit: 6;
    nRing23SCAddValueRate: 20;
    nHelMetDCAddRate: 30;
    nHelMetDCAddValueMaxLimit: 6;
    nHelMetDCAddValueRate: 20;
    nHelMetMCAddRate: 30;
    nHelMetMCAddValueMaxLimit: 6;
    nHelMetMCAddValueRate: 20;
    nHelMetSCAddRate: 30;
    nHelMetSCAddValueMaxLimit: 6;
    nHelMetSCAddValueRate: 20;
    nUnknowHelMetACAddRate: 20;
    nUnknowHelMetACAddValueMaxLimit: 4;
    nUnknowHelMetMACAddRate: 20;
    nUnknowHelMetMACAddValueMaxLimit: 4;
    nUnknowHelMetDCAddRate: 30;
    nUnknowHelMetDCAddValueMaxLimit: 3;
    nUnknowHelMetMCAddRate: 30;
    nUnknowHelMetMCAddValueMaxLimit: 3;
    nUnknowHelMetSCAddRate: 30;
    nUnknowHelMetSCAddValueMaxLimit: 3;
    nUnknowRingACAddRate: 20;
    nUnknowRingACAddValueMaxLimit: 4;
    nUnknowRingMACAddRate: 20;
    nUnknowRingMACAddValueMaxLimit: 4;
    nUnknowRingDCAddRate: 20;
    nUnknowRingDCAddValueMaxLimit: 6;
    nUnknowRingMCAddRate: 20;
    nUnknowRingMCAddValueMaxLimit: 6;
    nUnknowRingSCAddRate: 20;
    nUnknowRingSCAddValueMaxLimit: 6;
    nUnknowNecklaceACAddRate: 20;
    nUnknowNecklaceACAddValueMaxLimit: 5;
    nUnknowNecklaceMACAddRate: 20;
    nUnknowNecklaceMACAddValueMaxLimit: 5;
    nUnknowNecklaceDCAddRate: 30;
    nUnknowNecklaceDCAddValueMaxLimit: 5;
    nUnknowNecklaceMCAddRate: 30;
    nUnknowNecklaceMCAddValueMaxLimit: 5;
    nUnknowNecklaceSCAddRate: 30;
    nUnknowNecklaceSCAddValueMaxLimit: 5;
    nMonOneDropGoldCount: 2000;
    nMakeMineHitRate: 4; //挖矿命中率
    nMakeMineRate: 12; //挖矿率
    nStoneTypeRate: 120;
    nStoneTypeRateMin: 56;
    nGoldStoneMin: 1;
    nGoldStoneMax: 2;
    nSilverStoneMin: 3;
    nSilverStoneMax: 20;
    nSteelStoneMin: 21;
    nSteelStoneMax: 45;
    nBlackStoneMin: 46;
    nBlackStoneMax: 56;
    nStoneMinDura: 3000;
    nStoneGeneralDuraRate: 13000;
    nStoneAddDuraRate: 20;
    nStoneAddDuraMax: 10000;

//取消彩票功能
//    nWinLottery6Min: 1;
//    nWinLottery6Max: 4999;
//    nWinLottery5Min: 14000;
//    nWinLottery5Max: 15999;
//    nWinLottery4Min: 16000;
//    nWinLottery4Max: 16149;
//    nWinLottery3Min: 16150;
//    nWinLottery3Max: 16169;
//    nWinLottery2Min: 16170;
//    nWinLottery2Max: 16179;
//    nWinLottery1Min: 16180;
//    nWinLottery1Max: 16185; //16180 + 1820;
//    nWinLottery1Gold: 1000000;
//    nWinLottery2Gold: 200000;
//    nWinLottery3Gold: 100000;
//    nWinLottery4Gold: 10000;
//    nWinLottery5Gold: 1000;
//    nWinLottery6Gold: 500;
//    nWinLotteryRate: 30000;
//    nWinLotteryCount: 0;
//    nNoWinLotteryCount: 0;
//    nWinLotteryLevel1: 0;
//    nWinLotteryLevel2: 0;
//    nWinLotteryLevel3: 0;
//    nWinLotteryLevel4: 0;
//    nWinLotteryLevel5: 0;
//    nWinLotteryLevel6: 0;

    GlobalVal: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    nItemNumber: 0;
    nItemNumberEx: High(Integer) div 2;
    nGuildRecallTime: 180;
    nGroupRecallTime: 180;
    boControlDropItem: False;
    boInSafeDisableDrop: False;
    nCanDropGold: 1000;
    nCanDropPrice: 500;
    boSendCustemMsg: True;
    boSubkMasterSendMsg: True;
    nSuperRepairPriceRate: 3; //特修价格倍数
    nRepairItemDecDura: 30; //普通修理掉持久数(特持久上限减下限再除以此数为减的数值)
    boDieScatterBag: True;
    nDieScatterBagRate: 3;
    boDieRedScatterBagAll: True;
    nDieDropUseItemRate: 30;
    nDieRedDropUseItemRate: 15;
    boDieDropGold: False;
    boKillByHumanDropUseItem: False;
    boKillByMonstDropUseItem: True;
    boKickExpireHuman: False;
    nGuildRankNameLen: 16;
    nGuildMemberMaxLimit: 200;
    nGuildNameLen: 16;
    nAttackPosionRate: 5;
    nAttackPosionTime: 5;
    dwRevivalTime: 60 * 1000; //复活间隔时间
    boUserMoveCanDupObj: False;
    boUserMoveCanOnItem: True;
    dwUserMoveTime: 10;
    dwPKDieLostExpRate: 1000;
    nPKDieLostLevelRate: 20000;
    btPKFlagNameColor: $2F;
    btPKLevel1NameColor: $FB;
    btPKLevel2NameColor: $F9;
    btAllyAndGuildNameColor: $B4;
    btWarGuildNameColor: $45;
    btInFreePKAreaNameColor: $DD;
    boSpiritMutiny: False;
    dwSpiritMutinyTime: 30 * 60 * 1000;
    nSpiritPowerRate: 2;
    boMasterDieMutiny: False;
    nMasterDieMutinyRate: 5;
    nMasterDieMutinyPower: 10;
    nMasterDieMutinySpeed: 5;
    boBBMonAutoChangeColor: False;
    dwBBMonAutoChangeColorTime: 3000;
    boOldClientShowHiLevel: True;
    boShowScriptActionMsg: True;
    nRunSocketDieLoopLimit: 100;
    boThreadRun: False;
    boShowExceptionMsg: False;
    boShowPreFixMsg: False;
    nMagicAttackRage: 8; //魔法锁定范围
    sSkeleton: '变异骷髅';
    nSkeletonCount: 1;
//    g_Config.BoneFammArray                       :array[0..9] of TRecallMigic;
    sDragon: '神兽';
    sDragon1: '神兽1';
    nDragonCount: 1;
//    g_Config.DogzArray                           :array[0..9] of TRecallMigic;
    sAngel: 'HolyDeva';
    nAmyOunsulPoint: 10;
    boDisableInSafeZoneFireCross: False;
    boGroupMbAttackPlayObject: False;
    boGroupMbAttackBaoBao: True;
    dwPosionDecHealthTime: 2500;
    nPosionDamagarmor: 12; //中红毒着持久及减防量（实际大小为 12 / 10）
    boLimitSwordLong: False;
    nSwordLongPowerRate: 100;
    nFireBoomRage: 1;
    nSnowWindRange: 1;
    nElecBlizzardRange: 2;
    nMagTurnUndeadLevel: 50; //圣言怪物等级限制
    nMagTammingLevel: 50; //诱惑之光怪物等级限制
    nMagTammingTargetLevel: 10; //诱惑怪物相差等级机率，此数字越小机率越大；
    nMagTammingHPRate: 100; //成功机率=怪物最高HP 除以 此倍率，此倍率越大诱惑机率越高
    nMagTammingCount: 5;
    nMabMabeHitRandRate: 100;
    nMabMabeHitMinLvLimit: 10;
    nMabMabeHitSucessRate: 21;
    nMabMabeHitMabeTimeRate: 20;
    sCASTLENAME: '沙巴克';
    sCastleHomeMap: '3';
    nCastleHomeX: 644;
    nCastleHomeY: 290;
    nCastleWarRangeX: 100;
    nCastleWarRangeY: 100;
    nCastleTaxRate: 5;
    boGetAllNpcTax: False;
    nHireGuardPrice: 300000;
    nHireArcherPrice: 300000;
    nCastleGoldMax: 10000000;
    nCastleOneDayGold: 2000000;
    nRepairDoorPrice: 2000000;
    nRepairWallPrice: 500000;
    nCastleMemberPriceRate: 80;
    nMaxHitMsgCount: 1;
    nMaxSpellMsgCount: 1;
    nMaxRunMsgCount: 1;
    nMaxWalkMsgCount: 1;
    nMaxTurnMsgCount: 1;
    nMaxSitDonwMsgCount: 1;
    nMaxDigUpMsgCount: 1;
    boSpellSendUpdateMsg: True;
    boActionSendActionMsg: True;
    boKickOverSpeed: False;
    btSpeedControlMode: 0;
    nOverSpeedKickCount: 4;
    dwDropOverSpeed: 10;
    dwHitIntervalTime: 900; //攻击间隔
    dwMagicHitIntervalTime: 800; //魔法间隔
    dwRunIntervalTime: 600; //跑步间隔
    dwWalkIntervalTime: 600; //走路间隔
    dwTurnIntervalTime: 600; //换方向间隔
    boControlActionInterval: True;
    boControlWalkHit: True;
    boControlRunLongHit: True;
    boControlRunHit: True;
    boControlRunMagic: True;
    dwActionIntervalTime: 350; //组合操作间隔
    dwRunLongHitIntervalTime: 800; //跑位刺杀间隔
    dwRunHitIntervalTime: 800; //跑位攻击间隔
    dwWalkHitIntervalTime: 800; //走位攻击间隔
    dwRunMagicIntervalTime: 900; //跑位魔法间隔
    boDisableStruck: False; //不显示人物弯腰动作
    boDisableSelfStruck: False; //自己不显示人物弯腰动作
    dwStruckTime: 100; //人物弯腰停留时间
    dwKillMonExpMultiple: 1; //杀怪经验倍数
{$IF SoftVersion = VERENT}
    dwRequestVersion: 98;
{$ELSE}
    dwRequestVersion: RequestVersion;
{$IFEND}
    boHighLevelKillMonFixExp: False;
    boAddUserItemNewValue: True;
    sLineNoticePreFix: '〖公告〗';
    sSysMsgPreFix: '〖系统〗';
    sGuildMsgPreFix: '〖行会〗';
    sGroupMsgPreFix: '〖组队〗';
    sHintMsgPreFix: '〖提示〗';
    sGMRedMsgpreFix: '〖ＧＭ〗';
    sMonSayMsgpreFix: '〖怪物〗';
    sCustMsgpreFix: '〖祝福〗';
    sCastleMsgpreFix: '〖城主〗';
    sGuildNotice: '公告';
    sGuildWar: '敌对行会';
    sGuildAll: '联盟行会';
    sGuildMember: '行会成员';
    sGuildMemberRank: '行会成员';
    sGuildChief: '行会掌门人';
    boKickAllUser: False;
    boTestSpeedMode: False;
    ClientConf: (
    boClientCanSet: True;
    boRUNHUMAN: False;
    boRUNMON: False;
    boRunNpc: False;
    boWarRunAll: False;
    btDieColor: 5;
    wSpellTime: 500;
    wHitIime: 1400;
    wItemFlashTime: 5 * 100 {5 * 1000};
    btItemSpeed: 25; {60}
    boCanStartRun: False;
    boParalyCanRun: False;
    boParalyCanWalk: False;
    boParalyCanHit: False;
    boParalyCanSpell: False;
    boShowRedHPLable: False;  //是否显示血条
    boShowHPNumber: False;
    boShowJobLevel: True;
    boDuraAlert: True;
    boMagicLock: False;
    boAutoPuckUpItem: False;
    );
    nWeaponMakeUnLuckRate: 20;
    nWeaponMakeLuckPoint1: 1;
    nWeaponMakeLuckPoint2: 3;
    nWeaponMakeLuckPoint3: 7;
    nWeaponMakeLuckPoint2Rate: 6;
    nWeaponMakeLuckPoint3Rate: 10 + 30;
    boCheckUserItemPlace: True;
{$IF DEMOCLIENT = 1}
    nClientKey: 6534;
{$ELSE}
    nClientKey: 500;
{$IFEND}
    nLevelValueOfTaosHP: 6;
    nLevelValueOfTaosHPRate: 2.5;
    nLevelValueOfTaosMP: 8;
    nLevelValueOfWizardHP: 15;
    nLevelValueOfWizardHPRate: 1.8;
    nLevelValueOfWarrHP: 4;
    nLevelValueOfWarrHPRate: 4.5;
    nProcessMonsterInterval: 2;
    nDBSocketSendLen: 0;

    //dwSendWhisperTime                   :5 * 60 * 1000;
    );
//===============================================================

//g_sADODBString       :String = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=.\Envir\Data.mdb;Persist Security Info=False';  //ADO 数据源名称
  sDBName: string = 'HERODB'; //BDE 数据源名称

{$IF OEMVER = OEM775}
  g_LevelInfo: array[0..MAXLEVEL] of TLevelInfo;
{$IFEND}

  g_dwOldNeedExps: TLevelNeedExp = (
    100, //1
    200, //2
    300, //3
    400, //4
    600, //5
    900, //6
    1200, //7
    1700, //8
    2500, //9
    6000, //10
    8000, //11
    10000, //12
    15000, //13
    30000, //14
    40000, //15
    50000, //16
    70000, //17
    100000, //18
    120000, //19
    140000, //20
    250000, //21
    300000, //22
    350000, //23
    400000, //24
    500000, //25
    700000, //26
    1000000, //27
    1400000, //28
    1800000, //29
    2000000, //30
    2400000, //31
    2800000, //32
    3200000, //33
    3600000, //34
    4000000, //35
    4800000, //36
    5600000, //37
    8200000, //38
    9000000, //39
    12000000, //40
    16000000, //41
    30000000, //42
    50000000, //43
    80000000, //44
    120000000, //45
    480000000, //46
    1000000000, //47
    3000000000, //48
    3500000000, //49
    4000000000, //50
    4000000000, //51
    4000000000, //52
    4000000000, //53
    4000000000, //54
    4000000000, //55
    4000000000, //56
    4000000000, //57
    4000000000, //58
    4000000000, //59
    4000000000, //60
    4000000000, //61
    4000000000, //62
    4000000000, //63
    4000000000, //64
    4000000000, //65
    4000000000, //66
    4000000000, //67
    4000000000, //68
    4000000000, //69
    4000000000, //70
    4000000000, //71
    4000000000, //72
    4000000000, //73
    4000000000, //74
    4000000000, //75
    4000000000, //76
    4000000000, //77
    4000000000, //78
    4000000000, //79
    4000000000, //80
    4000000000, //81
    4000000000, //82
    4000000000, //83
    4000000000, //84
    4000000000, //85
    4000000000, //86
    4000000000, //87
    4000000000, //88
    4000000000, //89
    4000000000, //90
    4000000000, //91
    4000000000, //92
    4000000000, //93
    4000000000, //94
    4000000000, //95
    4000000000, //96
    4000000000, //97
    4000000000, //98
    4000000000, //99
    4000000000, //100
    4000000000, //101
    4000000000, //102
    4000000000, //103
    4000000000, //104
    4000000000, //105
    4000000000, //106
    4000000000, //107
    4000000000, //108
    4000000000, //109
    4000000000, //110
    4000000000, //111
    4000000000, //112
    4000000000, //113
    4000000000, //114
    4000000000, //115
    4000000000, //116
    4000000000, //117
    4000000000, //118
    4000000000, //119
    4000000000, //120
    4000000000, //121
    4000000000, //122
    4000000000, //123
    4000000000, //124
    4000000000, //125
    4000000000, //126
    4000000000, //127
    4000000000, //128
    4000000000, //129
    4000000000, //130
    4000000000, //131
    4000000000, //132
    4000000000, //133
    4000000000, //134
    4000000000, //135
    4000000000, //136
    4000000000, //137
    4000000000, //138
    4000000000, //139
    4000000000, //140
    4000000000, //141
    4000000000, //142
    4000000000, //143
    4000000000, //144
    4000000000, //145
    4000000000, //146
    4000000000, //147
    4000000000, //148
    4000000000, //149
    4000000000, //150
    4000000000, //151
    4000000000, //152
    4000000000, //153
    4000000000, //154
    4000000000, //155
    4000000000, //156
    4000000000, //157
    4000000000, //158
    4000000000, //159
    4000000000, //160
    4000000000, //161
    4000000000, //162
    4000000000, //163
    4000000000, //164
    4000000000, //165
    4000000000, //166
    4000000000, //167
    4000000000, //168
    4000000000, //169
    4000000000, //170
    4000000000, //171
    4000000000, //172
    4000000000, //173
    4000000000, //174
    4000000000, //175
    4000000000, //176
    4000000000, //177
    4000000000, //178
    4000000000, //179
    4000000000, //180
    4000000000, //181
    4000000000, //182
    4000000000, //183
    4000000000, //184
    4000000000, //185
    4000000000, //186
    4000000000, //187
    4000000000, //188
    4000000000, //189
    4000000000, //190
    4000000000, //191
    4000000000, //192
    4000000000, //193
    4000000000, //194
    4000000000, //195
    4000000000, //196
    4000000000, //197
    4000000000, //198
    4000000000, //199
    4000000000, //200
    4000000000, //201
    4000000000, //202
    4000000000, //203
    4000000000, //204
    4000000000, //205
    4000000000, //206
    4000000000, //207
    4000000000, //208
    4000000000, //209
    4000000000, //210
    4000000000, //211
    4000000000, //212
    4000000000, //213
    4000000000, //214
    4000000000, //215
    4000000000, //216
    4000000000, //217
    4000000000, //218
    4000000000, //219
    4000000000, //220
    4000000000, //221
    4000000000, //222
    4000000000, //223
    4000000000, //224
    4000000000, //225
    4000000000, //226
    4000000000, //227
    4000000000, //228
    4000000000, //229
    4000000000, //230
    4000000000, //231
    4000000000, //232
    4000000000, //233
    4000000000, //234
    4000000000, //235
    4000000000, //236
    4000000000, //237
    4000000000, //238
    4000000000, //239
    4000000000, //240
    4000000000, //241
    4000000000, //242
    4000000000, //243
    4000000000, //244
    4000000000, //245
    4000000000, //246
    4000000000, //247
    4000000000, //248
    4000000000, //249
    4000000000, //250
    4000000000, //251
    4000000000, //252
    4000000000, //253
    4000000000, //254
    4000000000, //255
    4000000000, //256
    4000000000, //257
    4000000000, //258
    4000000000, //259
    4000000000, //260
    4000000000, //261
    4000000000, //262
    4000000000, //263
    4000000000, //264
    4000000000, //265
    4000000000, //266
    4000000000, //267
    4000000000, //268
    4000000000, //269
    4000000000, //270
    4000000000, //271
    4000000000, //272
    4000000000, //273
    4000000000, //274
    4000000000, //275
    4000000000, //276
    4000000000, //277
    4000000000, //278
    4000000000, //279
    4000000000, //280
    4000000000, //281
    4000000000, //282
    4000000000, //283
    4000000000, //284
    4000000000, //285
    4000000000, //286
    4000000000, //287
    4000000000, //288
    4000000000, //289
    4000000000, //290
    4000000000, //291
    4000000000, //292
    4000000000, //293
    4000000000, //294
    4000000000, //295
    4000000000, //296
    4000000000, //297
    4000000000, //298
    4000000000, //299
    4000000000, //300
    4000000000, //301
    4000000000, //302
    4000000000, //303
    4000000000, //304
    4000000000, //305
    4000000000, //306
    4000000000, //307
    4000000000, //308
    4000000000, //309
    4000000000, //310
    4000000000, //311
    4000000000, //312
    4000000000, //313
    4000000000, //314
    4000000000, //315
    4000000000, //316
    4000000000, //317
    4000000000, //318
    4000000000, //319
    4000000000, //320
    4000000000, //321
    4000000000, //322
    4000000000, //323
    4000000000, //324
    4000000000, //325
    4000000000, //326
    4000000000, //327
    4000000000, //328
    4000000000, //329
    4000000000, //330
    4000000000, //331
    4000000000, //332
    4000000000, //333
    4000000000, //334
    4000000000, //335
    4000000000, //336
    4000000000, //337
    4000000000, //338
    4000000000, //339
    4000000000, //340
    4000000000, //341
    4000000000, //342
    4000000000, //343
    4000000000, //344
    4000000000, //345
    4000000000, //346
    4000000000, //347
    4000000000, //348
    4000000000, //349
    4000000000, //350
    4000000000, //351
    4000000000, //352
    4000000000, //353
    4000000000, //354
    4000000000, //355
    4000000000, //356
    4000000000, //357
    4000000000, //358
    4000000000, //359
    4000000000, //360
    4000000000, //361
    4000000000, //362
    4000000000, //363
    4000000000, //364
    4000000000, //365
    4000000000, //366
    4000000000, //367
    4000000000, //368
    4000000000, //369
    4000000000, //370
    4000000000, //371
    4000000000, //372
    4000000000, //373
    4000000000, //374
    4000000000, //375
    4000000000, //376
    4000000000, //377
    4000000000, //378
    4000000000, //379
    4000000000, //380
    4000000000, //381
    4000000000, //382
    4000000000, //383
    4000000000, //384
    4000000000, //385
    4000000000, //386
    4000000000, //387
    4000000000, //388
    4000000000, //389
    4000000000, //390
    4000000000, //391
    4000000000, //392
    4000000000, //393
    4000000000, //394
    4000000000, //395
    4000000000, //396
    4000000000, //397
    4000000000, //398
    4000000000, //399
    4000000000, //400
    4000000000, //401
    4000000000, //402
    4000000000, //403
    4000000000, //404
    4000000000, //405
    4000000000, //406
    4000000000, //407
    4000000000, //408
    4000000000, //409
    4000000000, //410
    4000000000, //411
    4000000000, //412
    4000000000, //413
    4000000000, //414
    4000000000, //415
    4000000000, //416
    4000000000, //417
    4000000000, //418
    4000000000, //419
    4000000000, //420
    4000000000, //421
    4000000000, //422
    4000000000, //423
    4000000000, //424
    4000000000, //425
    4000000000, //426
    4000000000, //427
    4000000000, //428
    4000000000, //429
    4000000000, //430
    4000000000, //431
    4000000000, //432
    4000000000, //433
    4000000000, //434
    4000000000, //435
    4000000000, //436
    4000000000, //437
    4000000000, //438
    4000000000, //439
    4000000000, //440
    4000000000, //441
    4000000000, //442
    4000000000, //443
    4000000000, //444
    4000000000, //445
    4000000000, //446
    4000000000, //447
    4000000000, //448
    4000000000, //449
    4000000000, //450
    4000000000, //451
    4000000000, //452
    4000000000, //453
    4000000000, //454
    4000000000, //455
    4000000000, //456
    4000000000, //457
    4000000000, //458
    4000000000, //459
    4000000000, //460
    4000000000, //461
    4000000000, //462
    4000000000, //463
    4000000000, //464
    4000000000, //465
    4000000000, //466
    4000000000, //467
    4000000000, //468
    4000000000, //469
    4000000000, //470
    4000000000, //471
    4000000000, //472
    4000000000, //473
    4000000000, //474
    4000000000, //475
    4000000000, //476
    4000000000, //477
    4000000000, //478
    4000000000, //479
    4000000000, //480
    4000000000, //481
    4000000000, //482
    4000000000, //483
    4000000000, //484
    4000000000, //485
    4000000000, //486
    4000000000, //487
    4000000000, //488
    4000000000, //489
    4000000000, //490
    4000000000, //491
    4000000000, //492
    4000000000, //493
    4000000000, //494
    4000000000, //495
    4000000000, //496
    4000000000, //497
    4000000000, //498
    4000000000, //499
    4000000000 //500
    );


//===============================================================

//===============================================================
//游戏命令方面参数
  g_GameCommand            :TGameCommand = (
    DATA                   :(sCmd:'Date';nPerMissionMin:0;nPerMissionMax:10);
    PRVMSG                 :(sCmd:'PrvMsg';nPerMissionMin:0;nPerMissionMax:10);
    ALLOWMSG               :(sCmd:'AllowMsg';nPerMissionMin:0;nPerMissionMax:10);
    LETSHOUT               :(sCmd:'LetShout';nPerMissionMin:0;nPerMissionMax:10);
    LETTRADE               :(sCmd:'LetTrade';nPerMissionMin:0;nPerMissionMax:10);
    LETGUILD               :(sCmd:'LetGuild';nPerMissionMin:0;nPerMissionMax:10);
    ENDGUILD               :(sCmd:'EndGuild';nPerMissionMin:0;nPerMissionMax:10);
    BANGUILDCHAT           :(sCmd:'BanGuildChat';nPerMissionMin:0;nPerMissionMax:10);
    AUTHALLY               :(sCmd:'AuthAlly';nPerMissionMin:0;nPerMissionMax:10);
    AUTH                   :(sCmd:'联盟';nPerMissionMin:0;nPerMissionMax:10);
    AUTHCANCEL             :(sCmd:'取消联盟';nPerMissionMin:0;nPerMissionMax:10);
    DIARY                  :(sCmd:'Diary';nPerMissionMin:0;nPerMissionMax:10);
    USERMOVE               :(sCmd:'Move';nPerMissionMin:0;nPerMissionMax:10);
    SEARCHING              :(sCmd:'Searching';nPerMissionMin:0;nPerMissionMax:10);
    ALLOWGROUPCALL         :(sCmd:'AllowGroupRecall';nPerMissionMin:0;nPerMissionMax:10);
    GROUPRECALLL           :(sCmd:'GroupRecall';nPerMissionMin:0;nPerMissionMax:10);
    ALLOWGUILDRECALL       :(sCmd:'AllowGuildRecall';nPerMissionMin:0;nPerMissionMax:10);
    GUILDRECALLL           :(sCmd:'GuildRecall';nPerMissionMin:0;nPerMissionMax:10);
    UNLOCKSTORAGE          :(sCmd:'UnLockStorage';nPerMissionMin:0;nPerMissionMax:10);
    UNLOCK                 :(sCmd:'UnLock';nPerMissionMin:0;nPerMissionMax:10);
    LOCK                   :(sCmd:'Lock';nPerMissionMin:0;nPerMissionMax:10);
    PASSWORDLOCK           :(sCmd:'PasswordLock';nPerMissionMin:0;nPerMissionMax:10);
    SETPASSWORD            :(sCmd:'SetPassword';nPerMissionMin:0;nPerMissionMax:10);
    CHGPASSWORD            :(sCmd:'ChgPassword';nPerMissionMin:0;nPerMissionMax:10);
    CLRPASSWORD            :(sCmd:'ClrPassword';nPerMissionMin:10;nPerMissionMax:10);
    UNPASSWORD             :(sCmd:'UnPassword';nPerMissionMin:0;nPerMissionMax:10);
    MEMBERFUNCTION         :(sCmd:'MemberFunc';nPerMissionMin:0;nPerMissionMax:10);
    MEMBERFUNCTIONEX       :(sCmd:'MemberFuncEx';nPerMissionMin:0;nPerMissionMax:10);

//取消 结婚 与 师徒 的相关内容    
//    DEAR                   :(sCmd:'Dear';nPerMissionMin:0;nPerMissionMax:10);
//    ALLOWDEARRCALL         :(sCmd:'AllowDearRecall';nPerMissionMin:0;nPerMissionMax:10);
//   DEARRECALL             :(sCmd:'DearRecall';nPerMissionMin:0;nPerMissionMax:10);
//    MASTER                 :(sCmd:'Master';nPerMissionMin:0;nPerMissionMax:10);
//    ALLOWMASTERRECALL      :(sCmd:'AllowMasterRecall';nPerMissionMin:0;nPerMissionMax:10);
//    MASTERECALL            :(sCmd:'MasterRecall';nPerMissionMin:0;nPerMissionMax:10);

    ATTACKMODE             :(sCmd:'AttackMode';nPerMissionMin:0;nPerMissionMax:10);
    REST                   :(sCmd:'Rest';nPerMissionMin:0;nPerMissionMax:10);
    TAKEONHORSE            :(sCmd:'骑马';nPerMissionMin:0;nPerMissionMax:10);
    TAKEOFHORSE            :(sCmd:'下马';nPerMissionMin:0;nPerMissionMax:10);
    HUMANLOCAL             :(sCmd:'HumanLocal';nPerMissionMin:3;nPerMissionMax:10);
    MOVE                   :(sCmd:'Move';nPerMissionMin:3;nPerMissionMax:6);
    POSITIONMOVE           :(sCmd:'PositionMove';nPerMissionMin:3;nPerMissionMax:6);
    INFO                   :(sCmd:'Info';nPerMissionMin:3;nPerMissionMax:10);
    MOBLEVEL               :(sCmd:'MobLevel';nPerMissionMin:3;nPerMissionMax:10);
    MOBCOUNT               :(sCmd:'MobCount';nPerMissionMin:3;nPerMissionMax:10);
    HUMANCOUNT             :(sCmd:'HumanCount';nPerMissionMin:3;nPerMissionMax:10);
    MAP                    :(sCmd:'Map';nPerMissionMin:3;nPerMissionMax:10);
    KICK                   :(sCmd:'Kick';nPerMissionMin:10;nPerMissionMax:10);
    TING                   :(sCmd:'Ting';nPerMissionMin:10;nPerMissionMax:10);
    SUPERTING              :(sCmd:'SuperTing';nPerMissionMin:10;nPerMissionMax:10);
    MAPMOVE                :(sCmd:'MapMove';nPerMissionMin:10;nPerMissionMax:10);
    SHUTUP                 :(sCmd:'Shutup';nPerMissionMin:10;nPerMissionMax:10);
    RELEASESHUTUP          :(sCmd:'ReleaseShutup';nPerMissionMin:10;nPerMissionMax:10);
    SHUTUPLIST             :(sCmd:'ShutupList';nPerMissionMin:10;nPerMissionMax:10);
    GAMEMASTER             :(sCmd:'GameMaster';nPerMissionMin:10;nPerMissionMax:10);
    OBSERVER               :(sCmd:'Observer';nPerMissionMin:10;nPerMissionMax:10);
    SUEPRMAN               :(sCmd:'Superman';nPerMissionMin:10;nPerMissionMax:10);
    LEVEL                  :(sCmd:'Level';nPerMissionMin:10;nPerMissionMax:10);
    SABUKWALLGOLD          :(sCmd:'SabukWallGold';nPerMissionMin:10;nPerMissionMax:10);
    RECALL                 :(sCmd:'Recall';nPerMissionMin:10;nPerMissionMax:10);
    REGOTO                 :(sCmd:'ReGoto';nPerMissionMin:10;nPerMissionMax:10);
    SHOWFLAG               :(sCmd:'showflag';nPerMissionMin:10;nPerMissionMax:10);
    SHOWOPEN               :(sCmd:'showopen';nPerMissionMin:10;nPerMissionMax:10);
    SHOWUNIT               :(sCmd:'showunit';nPerMissionMin:10;nPerMissionMax:10);
    ATTACK                 :(sCmd:'Attack';nPerMissionMin:10;nPerMissionMax:10);
    MOB                    :(sCmd:'Mob';nPerMissionMin:10;nPerMissionMax:10);
    MOBNPC                 :(sCmd:'MobNpc';nPerMissionMin:10;nPerMissionMax:10);
    DELNPC                 :(sCmd:'DelNpc';nPerMissionMin:10;nPerMissionMax:10);
    NPCSCRIPT              :(sCmd:'NpcScript';nPerMissionMin:10;nPerMissionMax:10);
    RECALLMOB              :(sCmd:'RecallMob';nPerMissionMin:10;nPerMissionMax:10);
    LUCKYPOINT             :(sCmd:'LuckyPoint';nPerMissionMin:10;nPerMissionMax:10);

    //取消彩票功能
    //LOTTERYTICKET          :(sCmd:'LotteryTicket';nPerMissionMin:10;nPerMissionMax:10);  //彩票
    
    RELOADGUILD            :(sCmd:'ReloadGuild';nPerMissionMin:10;nPerMissionMax:10);
    RELOADLINENOTICE       :(sCmd:'ReloadLineNotice';nPerMissionMin:10;nPerMissionMax:10);
    RELOADABUSE            :(sCmd:'ReloadAbuse';nPerMissionMin:10;nPerMissionMax:10);
    BACKSTEP               :(sCmd:'Backstep';nPerMissionMin:10;nPerMissionMax:10);
    BALL                   :(sCmd:'Ball';nPerMissionMin:10;nPerMissionMax:10);
    FREEPENALTY            :(sCmd:'FreePK';nPerMissionMin:10;nPerMissionMax:10);
    PKPOINT                :(sCmd:'PKpoint';nPerMissionMin:10;nPerMissionMax:10);
    INCPKPOINT             :(sCmd:'IncPkPoint';nPerMissionMin:10;nPerMissionMax:10);
    CHANGELUCK             :(sCmd:'ChangeLuck';nPerMissionMin:10;nPerMissionMax:10);
    HUNGER                 :(sCmd:'Hunger';nPerMissionMin:10;nPerMissionMax:10);
    HAIR                   :(sCmd:'hair';nPerMissionMin:10;nPerMissionMax:10);
    TRAINING               :(sCmd:'Training';nPerMissionMin:10;nPerMissionMax:10);
    DELETESKILL            :(sCmd:'DeleteSkill';nPerMissionMin:10;nPerMissionMax:10);
    CHANGEJOB              :(sCmd:'ChangeJob';nPerMissionMin:10;nPerMissionMax:10);
    CHANGEGENDER           :(sCmd:'ChangeGender';nPerMissionMin:10;nPerMissionMax:10);
    NAMECOLOR              :(sCmd:'NameColor';nPerMissionMin:10;nPerMissionMax:10);
    MISSION                :(sCmd:'Mission';nPerMissionMin:10;nPerMissionMax:10);
    MOBPLACE               :(sCmd:'MobPlace';nPerMissionMin:10;nPerMissionMax:10);
    TRANSPARECY            :(sCmd:'Transparency';nPerMissionMin:10;nPerMissionMax:10);
    DELETEITEM             :(sCmd:'DeleteItem';nPerMissionMin:10;nPerMissionMax:10);
    LEVEL0                 :(sCmd:'Level0';nPerMissionMin:10;nPerMissionMax:10);
    CLEARMISSION           :(sCmd:'ClearMission';nPerMissionMin:10;nPerMissionMax:10);
    SETFLAG                :(sCmd:'setflag';nPerMissionMin:10;nPerMissionMax:10);
    SETOPEN                :(sCmd:'setopen';nPerMissionMin:10;nPerMissionMax:10);
    SETUNIT                :(sCmd:'setunit';nPerMissionMin:10;nPerMissionMax:10);
    RECONNECTION           :(sCmd:'Reconnection';nPerMissionMin:10;nPerMissionMax:10);
    DISABLEFILTER          :(sCmd:'DisableFilter';nPerMissionMin:10;nPerMissionMax:10);
    CHGUSERFULL            :(sCmd:'CHGUSERFULL';nPerMissionMin:10;nPerMissionMax:10);
    CHGZENFASTSTEP         :(sCmd:'CHGZENFASTSTEP';nPerMissionMin:10;nPerMissionMax:10);
    CONTESTPOINT           :(sCmd:'ContestPoint';nPerMissionMin:10;nPerMissionMax:10);
    STARTCONTEST           :(sCmd:'StartContest';nPerMissionMin:10;nPerMissionMax:10);
    ENDCONTEST             :(sCmd:'EndContest';nPerMissionMin:10;nPerMissionMax:10);
    ANNOUNCEMENT           :(sCmd:'Announcement';nPerMissionMin:10;nPerMissionMax:10);
    OXQUIZROOM             :(sCmd:'OXQuizRoom';nPerMissionMin:10;nPerMissionMax:10);
    GSA                    :(sCmd:'gsa';nPerMissionMin:10;nPerMissionMax:10);
    CHANGEITEMNAME         :(sCmd:'ChangeItemName';nPerMissionMin:10;nPerMissionMax:10);
    DISABLESENDMSG         :(sCmd:'DisableSendMsg';nPerMissionMin:10;nPerMissionMax:10);
    ENABLESENDMSG          :(sCmd:'EnableSendMsg';nPerMissionMin:10;nPerMissionMax:10);
    DISABLESENDMSGLIST     :(sCmd:'DisableSendMsgList';nPerMissionMin:10;nPerMissionMax:10);
    KILL                   :(sCmd:'Kill';nPerMissionMin:10;nPerMissionMax:10);
    MAKE                   :(sCmd:'make';nPerMissionMin:10;nPerMissionMax:10);
    SMAKE                  :(sCmd:'Supermake';nPerMissionMin:10;nPerMissionMax:10);
    BONUSPOINT             :(sCmd:'BonusPoint';nPerMissionMin:10;nPerMissionMax:10);
    DELBONUSPOINT          :(sCmd:'DelBonusPoint';nPerMissionMin:10;nPerMissionMax:10);
    RESTBONUSPOINT         :(sCmd:'RestBonusPoint';nPerMissionMin:10;nPerMissionMax:10);
    FIREBURN               :(sCmd:'FireBurn';nPerMissionMin:10;nPerMissionMax:10);
    TESTFIRE               :(sCmd:'TestFire';nPerMissionMin:10;nPerMissionMax:10);
    TESTSTATUS             :(sCmd:'TestStatus';nPerMissionMin:10;nPerMissionMax:10);
    DELGOLD                :(sCmd:'DelGold';nPerMissionMin:10;nPerMissionMax:10);
    ADDGOLD                :(sCmd:'AddGold';nPerMissionMin:10;nPerMissionMax:10);
    DELGAMEGOLD            :(sCmd:'DelGamePoint';nPerMissionMin:10;nPerMissionMax:10);
    ADDGAMEGOLD            :(sCmd:'AddGamePoint';nPerMissionMin:10;nPerMissionMax:10);
    GAMEGOLD               :(sCmd:'GameGold';nPerMissionMin:10;nPerMissionMax:10);
    GAMEPOINT              :(sCmd:'GamePoint';nPerMissionMin:10;nPerMissionMax:10);
    CREDITPOINT            :(sCmd:'CreditPoint';nPerMissionMin:10;nPerMissionMax:10);
    TESTGOLDCHANGE         :(sCmd:'Test_GOLD_Change';nPerMissionMin:10;nPerMissionMax:10);
    REFINEWEAPON           :(sCmd:'RefineWeapon';nPerMissionMin:10;nPerMissionMax:10);
    RELOADADMIN            :(sCmd:'ReloadAdmin';nPerMissionMin:10;nPerMissionMax:10);
    RELOADNPC              :(sCmd:'ReloadNpc';nPerMissionMin:10;nPerMissionMax:10);
    RELOADMANAGE           :(sCmd:'ReloadManage';nPerMissionMin:10;nPerMissionMax:10);
    RELOADROBOTMANAGE      :(sCmd:'ReloadRobotManage';nPerMissionMin:10;nPerMissionMax:10);
    RELOADROBOT            :(sCmd:'ReloadRobot';nPerMissionMin:10;nPerMissionMax:10);
    RELOADMONITEMS         :(sCmd:'ReloadMonItems';nPerMissionMin:10;nPerMissionMax:10);
    RELOADDIARY            :(sCmd:'ReloadDiary';nPerMissionMin:10;nPerMissionMax:10);
    RELOADITEMDB           :(sCmd:'ReloadItemDB';nPerMissionMin:10;nPerMissionMax:10);
    RELOADMAGICDB          :(sCmd:'ReloadMagicDB';nPerMissionMin:10;nPerMissionMax:10);
    RELOADMONSTERDB        :(sCmd:'ReloadMonsterDB';nPerMissionMin:10;nPerMissionMax:10);
    RELOADMINMAP           :(sCmd:'ReLoadMinMap';nPerMissionMin:10;nPerMissionMax:10);
    REALIVE                :(sCmd:'ReAlive';nPerMissionMin:10;nPerMissionMax:10);
    ADJUESTLEVEL           :(sCmd:'AdjustLevel';nPerMissionMin:10;nPerMissionMax:10);
    ADJUESTEXP             :(sCmd:'AdjustExp';nPerMissionMin:10;nPerMissionMax:10);
    ADDGUILD               :(sCmd:'AddGuild';nPerMissionMin:10;nPerMissionMax:10);
    DELGUILD               :(sCmd:'DelGuild';nPerMissionMin:10;nPerMissionMax:10);
    CHANGESABUKLORD        :(sCmd:'ChangeSabukLord';nPerMissionMin:10;nPerMissionMax:10);
    FORCEDWALLCONQUESTWAR  :(sCmd:'ForcedWallconquestWar';nPerMissionMin:10;nPerMissionMax:10);
    ADDTOITEMEVENT         :(sCmd:'AddToItemEvent';nPerMissionMin:10;nPerMissionMax:10);
    ADDTOITEMEVENTASPIECES :(sCmd:'AddToItemEventAsPieces';nPerMissionMin:10;nPerMissionMax:10);
    ITEMEVENTLIST          :(sCmd:'ItemEventList';nPerMissionMin:10;nPerMissionMax:10);
    STARTINGGIFTNO         :(sCmd:'StartingGiftNo';nPerMissionMin:10;nPerMissionMax:10);
    DELETEALLITEMEVENT     :(sCmd:'DeleteAllItemEvent';nPerMissionMin:10;nPerMissionMax:10);
    STARTITEMEVENT         :(sCmd:'StartItemEvent';nPerMissionMin:10;nPerMissionMax:10);
    ITEMEVENTTERM          :(sCmd:'ItemEventTerm';nPerMissionMin:10;nPerMissionMax:10);
    ADJUESTTESTLEVEL       :(sCmd:'AdjustTestLevel';nPerMissionMin:10;nPerMissionMax:10);
    TRAININGSKILL          :(sCmd:'TrainingSkill';nPerMissionMin:10;nPerMissionMax:10);
    OPDELETESKILL          :(sCmd:'OPDeleteSkill';nPerMissionMin:10;nPerMissionMax:10);
    CHANGEWEAPONDURA       :(sCmd:'ChangeWeaponDura';nPerMissionMin:10;nPerMissionMax:10);
    RELOADGUILDALL         :(sCmd:'ReloadGuildAll';nPerMissionMin:10;nPerMissionMax:10);
    WHO                    :(sCmd:'Who ';nPerMissionMin:3;nPerMissionMax:10);
    TOTAL                  :(sCmd:'Total ';nPerMissionMin:5;nPerMissionMax:10);
    TESTGA                 :(sCmd:'Testga';nPerMissionMin:10;nPerMissionMax:10);
    MAPINFO                :(sCmd:'MapInfo';nPerMissionMin:10;nPerMissionMax:10);
    SBKDOOR                :(sCmd:'SbkDoor';nPerMissionMin:10;nPerMissionMax:10);

//取消 结婚 与 师徒 的相关内容
//    CHANGEDEARNAME         :(sCmd:'DearName';nPerMissionMin:10;nPerMissionMax:10);
//    CHANGEMASTERNAME       :(sCmd:'MasterName';nPerMissionMin:10;nPerMissionMax:10);

    STARTQUEST             :(sCmd:'StartQuest';nPerMissionMin:10;nPerMissionMax:10);
    SETPERMISSION          :(sCmd:'SetPermission';nPerMissionMin:10;nPerMissionMax:10);
    CLEARMON               :(sCmd:'ClearMon';nPerMissionMin:10;nPerMissionMax:10);
    RENEWLEVEL             :(sCmd:'ReNewLevel';nPerMissionMin:10;nPerMissionMax:10);
    DENYIPLOGON            :(sCmd:'DenyIPLogon';nPerMissionMin:10;nPerMissionMax:10);
    DENYACCOUNTLOGON       :(sCmd:'DenyAccountLogon';nPerMissionMin:10;nPerMissionMax:10);
    DENYCHARNAMELOGON      :(sCmd:'DenyCharNameLogon';nPerMissionMin:10;nPerMissionMax:10);
    DELDENYIPLOGON         :(sCmd:'DelDenyIPLogon';nPerMissionMin:10;nPerMissionMax:10);
    DELDENYACCOUNTLOGON    :(sCmd:'DelDenyAccountLogon';nPerMissionMin:10;nPerMissionMax:10);
    DELDENYCHARNAMELOGON   :(sCmd:'DelDenyCharNameLogon';nPerMissionMin:10;nPerMissionMax:10);
    SHOWDENYIPLOGON        :(sCmd:'ShowDenyIPLogon';nPerMissionMin:10;nPerMissionMax:10);
    SHOWDENYACCOUNTLOGON   :(sCmd:'ShowDenyAccountLogon';nPerMissionMin:10;nPerMissionMax:10);
    SHOWDENYCHARNAMELOGON  :(sCmd:'ShowDenyCharNameLogon';nPerMissionMin:10;nPerMissionMax:10);
    VIEWWHISPER            :(sCmd:'ViewWhisper';nPerMissionMin:10;nPerMissionMax:10);
    SPIRIT                 :(sCmd:'祈祷生效';nPerMissionMin:10;nPerMissionMax:10);
    SPIRITSTOP             :(sCmd:'停止叛变';nPerMissionMin:10;nPerMissionMax:10);
    SETMAPMODE             :(sCmd:'SetMapMode';nPerMissionMin:10;nPerMissionMax:10);
    SHOWMAPMODE            :(sCmd:'ShowMapMode';nPerMissionMin:10;nPerMissionMax:10);
    TESTSERVERCONFIG       :(sCmd:'TestServerConfig';nPerMissionMin:10;nPerMissionMax:10);
    SERVERSTATUS           :(sCmd:'ServerStatus';nPerMissionMin:10;nPerMissionMax:10);
    TESTGETBAGITEM         :(sCmd:'TestGetBagItem';nPerMissionMin:10;nPerMissionMax:10);
    CLEARBAG               :(sCmd:'ClearBag';nPerMissionMin:10;nPerMissionMax:10);
    SHOWUSEITEMINFO        :(sCmd:'ShowUseItemInfo';nPerMissionMin:10;nPerMissionMax:10);
    BINDUSEITEM            :(sCmd:'BindUseItem';nPerMissionMin:10;nPerMissionMax:10);
    MOBFIREBURN            :(sCmd:'MobFireBurn';nPerMissionMin:10;nPerMissionMax:10);
    TESTSPEEDMODE          :(sCmd:'TestSpeedMode';nPerMissionMin:10;nPerMissionMax:10);
    LOCKLOGON              :(sCmd:'LockLogin';nPerMissionMin:0;nPerMissionMax:0);
  );

//===============================================================

//===============================================================
//游戏显示文字内容参数
  sClientSoftVersionError     :String = '游戏版本错误!';
  sDownLoadNewClientSoft      :String = '请到网站上下载最新版本游戏客户端软件!';
  sForceDisConnect            :String = '连接被强行中断.';
  sClientSoftVersionTooOld    :String = '请到官方网站下载最新登陆器.';
  sDownLoadAndUseNewClient    :String = '否则可能无法正常显示游戏.';
  sOnlineUserFull             :String = '可允许的玩家数量已满.';
  sYouNowIsTryPlayMode        :String = '你现在处于测试中，你可以在七级以前使用，但是会限制你的一些功能.';
  g_sNowIsFreePlayMode        :String = '当前服务器运行于测试模式.';
  sAttackModeOfAll            :String = '[攻击模式: 全体攻击]';
  sAttackModeOfPeaceful       :String = '[攻击模式: 和平攻击]';

//取消 结婚 与 师徒 的相关内容
//  sAttackModeOfDear           :String = '[攻击模式: 夫妻攻击]'; 
//  sAttackModeOfMaster         :String = '[攻击模式: 师徒攻击]';

  sAttackModeOfGroup          :String = '[攻击模式: 编组攻击]';
  sAttackModeOfGuild          :String = '[攻击模式: 行会攻击]';
  sAttackModeOfRedWhite       :String = '[攻击模式: 红名攻击]';
  sStartChangeAttackModeHelp  :String = '使用组合快捷键 CTRL-H 更改攻击模式...';
  sStartNoticeMsg             :String = '欢迎进入本服务器进行游戏...';

  sThrustingOn                :String = '启用刺杀剑法';
  sThrustingOff               :String = '关闭刺杀剑法';
  sHalfMoonOn                 :String = '开启半月弯刀';
  sHalfMoonOff                :String = '关闭半月弯刀';
  sRedHalfMoonOn              :String = 'RedHalfmoon Enabled';
  sRedHalfMoonOff             :String = 'RedHalfmoon Disabled';
  sCrsHitOn                   :String = '开启抱月刀法';
  sCrsHitOff                  :String = '关闭抱月刀法';
  sTwinHitOn                  :String = '开启龙影剑法';
  sTwinHitOff                 :String = '关闭龙影剑法';
  sFireSpiritsSummoned        :String = '召唤烈火精灵成功...';
  sFireSpiritsFail            :String = '召唤烈火精灵失败...';
  sSpiritsGone                :String = '召唤烈火精灵结束...';
  sMateDoTooweak              :String = '冲撞力不够...';

  g_sTheWeaponBroke           :String = '武器升级破碎.';
  sTheWeaponRefineSuccessfull :String = '武器升级成功!';


  sYouPoisoned                :String = '你中毒了[时间:%d秒，点数:%d点].';

  sPetRest                    :String = '宝宝行动：休息';
  sPetAttack                  :String = '宝宝行动：攻击';

  sWearNotOfWoMan             :String = '非女性用品.';
  sWearNotOfMan               :String = '非男性用品.';
  sHandWeightNot              :String = '腕力不够.';
  sWearWeightNot              :String = '负重力不够.';
  g_sItemIsNotThisAccount     :String = '此物品不为此帐号所有.';
  g_sItemIsNotThisIPaddr      :String = '此物品不为此IP所有.';
  g_sItemIsNotThisCharName    :String = '此物品不为你所有.';
  g_sLevelNot                 :String = '等级不够.';
  g_sJobOrLevelNot            :String = '职业不对或等级不够.';
  g_sJobOrDCNot               :String = '职业不对或攻击力不够.';
  g_sJobOrMCNot               :String = '职业不对或魔法力不够.';
  g_sJobOrSCNot               :String = '职业不对或道术不够.';
  g_sDCNot                    :String = '攻击力不够.';
  g_sMCNot                    :String = '魔法力不够.';
  g_sSCNot                    :String = '道术不够.';
  g_sCreditPointNot           :String = '声望点不够.';
  g_sReNewLevelNot            :String = '转生等级不够.';
  g_sGuildNot                 :String = '加入了行会才可以使用此物品.';
  g_sGuildMasterNot           :String = '行会掌门才可以使用此物品.';
  g_sSabukHumanNot            :String = '沙城成员才可以使用此物品.';
  g_sSabukMasterManNot        :String = '沙城城主才可以使用此物品.';
  g_sMemberNot                :String = '会员才可以使用此物品.';
  g_sMemberTypeNot            :String = '指定类型的会员可以使用此物品.';
  g_sCanottWearIt             :String = '此物品不适使用.';

  sCanotUseDrugOnThisMap      :String = '此地图不允许使用任何药品.';
  sGameMasterMode             :String = '已进入管理员模式.';
  sReleaseGameMasterMode      :String = '已退出管理员模式.';
  sObserverMode               :String = '已进入隐身模式.';
  g_sReleaseObserverMode      :String = '已退出隐身模式.';
  sSupermanMode               :String = '已进入无敌模式.';
  sReleaseSupermanMode        :String = '已退出无敌模式.';
  sYouFoundNothing            :String = '未获取任何物品...';

  g_sNoPasswordLockSystemMsg  :String = '游戏密码保护系统还没有启用.';
  g_sAlreadySetPasswordMsg    :String = '仓库早已设置了一个密码，如需要修改密码请使用修改密码命令！！！';
  g_sReSetPasswordMsg         :String = '请重复输入一次仓库密码：';
  g_sPasswordOverLongMsg      :String = '输入的密码长度不正确！！！，密码长度必须在 4 - 7 的范围内，请重新设置密码。';
  g_sReSetPasswordOKMsg       :String = '密码设置成功！！，仓库已经自动上锁，请记好您的仓库密码，在取仓库时需要使用此密码开锁。';
  g_sReSetPasswordNotMatchMsg :String = '二次输入的密码不一致，请重新设置密码！！！';
  g_sPleaseInputUnLockPasswordMsg :String = '请输入仓库密码：';
  g_sStorageUnLockOKMsg           :String = '密码输入成功！！！，仓库已经开锁。';
  g_sPasswordUnLockOKMsg          :String = '密码输入成功！！！，密码系统已经开锁。';
  g_sStorageAlreadyUnLockMsg      :String = '仓库早已解锁！！！';
  g_sStorageNoPasswordMsg         :String = '仓库还没设置密码！！！';
  g_sUnLockPasswordFailMsg        :String = '密码输入错误！！！，请检查好再输入。';
  g_sLockStorageSuccessMsg        :String = '仓库加锁成功。';
  g_sStoragePasswordClearMsg      :String = '仓库密码已清除！！！';
  g_sPleaseUnloadStoragePasswordMsg  :String = '请先解锁密码再使用此命令清除密码！！！';  
  g_sStorageAlreadyLockMsg        :String = '仓库早已加锁了！！！';
  g_sStoragePasswordLockedMsg     :String = '由于密码输入错误超过三次，仓库密码已被锁定！！！';
  g_sSetPasswordMsg               :String = '请输入一个长度为 4 - 7 位的仓库密码:';
  g_sPleaseInputOldPasswordMsg    :String = '请输入原仓库密码: ';
  g_sOldPasswordIsClearMsg        :String = '密码已清除。';
  g_sPleaseUnLockPasswordMsg      :String = '请先解锁仓库密码后再用此命令清除密码！！！';
  g_sNoPasswordSetMsg             :String = '仓库还没设置密码，请用设置密码命令设置仓库密码！！！';
  g_sOldPasswordIncorrectMsg      :String = '输入的原仓库密码不正确！！！';
  g_sStorageIsLockedMsg           :String = '仓库已被加锁，请先输入仓库正确的开锁密码，再取物品！！！';
  g_sActionIsLockedMsg            :String = '你当前已启用密码保护系统，请先输入正确的密码，才可以正常游戏！！！';
  g_sPasswordNotSetMsg            :String = '对不起，没有设置仓库密码此功能无法使用，设置仓库密码请输入指令 @%s';
  g_sNotPasswordProtectMode       :String = '你正处于非保护模式，如想你的装备更加安全，请输入指令 @%s';
  g_sCanotDropGoldMsg             :String = '太少的金币不允许扔在地上！！！';
  g_sCanotDropInSafeZoneMsg       :String = '安全区不允许扔东西在地上！！！';
  g_sCanotDropItemMsg             :String = '当前无法进行此操作！！！';
  g_sCanotUseItemMsg              :String = '当前无法进行此操作！！！';
  g_sCanotTryDealMsg              :String = '当前无法进行此操作！！！';
  g_sPleaseTryDealLaterMsg        :String = '请稍候再交易！！！';
  g_sDealItemsDenyGetBackMsg      :String = '交易的金币或物品不可以取回，要取回请取消再重新交易！！！';
  g_sDisableDealItemsMsg          :String = '交易功能暂时关闭！！！';
  g_sDealActionCancelMsg          :String = '交易取消！！！';
  g_sPoseDisableDealMsg           :String = '对方禁止进入交易...';
  g_sDealSuccessMsg               :String = '交易成功...';
  g_sDealOKTooFast                :String = '过早按了成交按钮。';
  g_sYourBagSizeTooSmall          :String = '你的背包空间不够，无法装下对方交易给你的物品！！！';
  g_sDealHumanBagSizeTooSmall     :String = '交易对方的背包空间不够，无法装下对方交易给你的物品！！！';
  g_sYourGoldLargeThenLimit       :String = '你的所带的金币太多，无法装下对方交易给你的金币！！！';
  g_sDealHumanGoldLargeThenLimit  :String = '交易对方的所带的金币太多，无法装下对方交易给你的金币！！！';
  g_sYouDealOKMsg                 :String = '你已经确认交易了.';
  g_sPoseDealOKMsg                :String = '对方已经确认交易了.';
  g_sKickClientUserMsg            :String = '请不要使用非法外挂软件.';


//取消 师徒 和 结婚系统 的相关内容  
{  
  g_sStartMarryManMsg             :String = '[%n]: %s 与 %d 的婚礼现在开始...';
  g_sStartMarryWoManMsg           :String = '[%n]: %d 与 %s 的婚礼现在开始...';
  g_sStartMarryManAskQuestionMsg  :String = '[%n]: %s 你愿意娶 %d 小姐为妻，并照顾她一生一世吗？';
  g_sStartMarryWoManAskQuestionMsg:String = '[%n]: %d 你愿意娶 %s 小姐为妻，并照顾她一生一世吗？';

  g_sMarryManAnswerQuestionMsg    :String = '[%s]: 我愿意！！！，%d 小姐我会尽我一生的时间来照顾您，让您过上快乐美满的日子的。';
  g_sMarryManAskQuestionMsg       :String = '[%n]: %d 你愿意嫁给 %s 先生为妻，并照顾他一生一世吗？';

  g_sMarryWoManAnswerQuestionMsg  :String = '[%s]: 我愿意！！！，%d 先生我愿意让你来照顾我，保护我。';
  g_sMarryWoManGetMarryMsg        :String = '[%n]: 我宣布 %d 先生与 %s 小姐正式成为合法夫妻。';

  g_sMarryWoManDenyMsg            :String = '[%s]: %d 你这个好色之徒，谁会愿意嫁给你呀！！！，癞蛤蟆想吃天鹅肉。';
  g_sMarryWoManCancelMsg          :String = '[%n]: 真是可惜，二个人这个时候才翻脸，你们培养好感情后再来找我吧！！！';

  g_sfUnMarryManLoginMsg          :String = '你的老婆%d已经强行与你脱离了夫妻关系了！！！';
  g_sfUnMarryWoManLoginMsg        :String = '你的老公%d已经强行与你脱离了夫妻关系了！！！';

  g_sManLoginDearOnlineSelfMsg    :String = '你的老婆%d当前位于%m(%x:%y).';
  g_sManLoginDearOnlineDearMsg    :String = '你的老公%s在:%m(%x:%y)上线了.';

  g_sWoManLoginDearOnlineSelfMsg  :String = '你的老公当前位于%m(%x:%y).';
  g_sWoManLoginDearOnlineDearMsg  :String = '你的老婆%s在:%m(%x:%y) 上线了.';

  g_sManLoginDearNotOnlineMsg     :String = '你的老婆现在不在线.';
  g_sWoManLoginDearNotOnlineMsg   :String = '你的老公现在不在线.';

  g_sManLongOutDearOnlineMsg      :String = '你的老公在:%m(%x:%y)下线了.';
  g_sWoManLongOutDearOnlineMsg    :String = '你的老婆在:%m(%x:%y)下线了.';

  g_sYouAreNotMarryedMsg          :String = '你都没结婚查什么？';
  g_sYourWifeNotOnlineMsg         :String = '你的老婆还没有上线！！！';
  g_sYourHusbandNotOnlineMsg      :String = '你的老公还没有上线！！！';

  g_sYourWifeNowLocateMsg         :String = '你的老婆现在位于:';
  g_sYourHusbandSearchLocateMsg   :String = '你的老公正在找你，他现在位于:';
  g_sYourHusbandNowLocateMsg      :String = '你的老公现在位于:';
  g_sYourWifeSearchLocateMsg      :String = '你的老婆正在找你，他现在位于:';


  g_sfUnMasterLoginMsg            :String = '你的一个徒弟已经背判师门了！！！';
  g_sfUnMasterListLoginMsg        :String = '你的师父%d已经将你逐出师门了！！！';

  g_sMasterListOnlineSelfMsg      :String = '你的师父%d当前位于%m(%x:%y)。';
  g_sMasterListOnlineMasterMsg    :String = '你的徒弟%s在:%m(%x:%y)上线了！！！。';

  g_sMasterOnlineSelfMsg          :String = '你的徒弟当前位于%m(%x:%y)。';
  g_sMasterOnlineMasterListMsg    :String = '你的师父%s在:%m(%x:%y) 上线了！！！。';

  g_sMasterLongOutMasterListOnlineMsg      :String = '你的师父在:%m(%x:%y)下线了！！！。';
  g_sMasterListLongOutMasterOnlineMsg    :String = '你的徒弟%s在:%m(%x:%y)下线了！！！。';

  g_sMasterListNotOnlineMsg       :String = '你的师父现不在线！！！';
  g_sMasterNotOnlineMsg           :String = '你的徒弟现不在线！！！';

  g_sYouAreNotMasterMsg           :String = '你都没师徒关系查什么？';
  g_sYourMasterNotOnlineMsg       :String = '你的师父还没有上线！！！';
  g_sYourMasterListNotOnlineMsg   :String = '你的徒弟还没有上线！！！';

  g_sYourMasterNowLocateMsg       :String = '你的师父现在位于:';
  g_sYourMasterListSearchLocateMsg:String = '你的徒弟正在找你，他现在位于:';
  g_sYourMasterListNowLocateMsg   :String = '你的徒弟现在位于:';
  g_sYourMasterSearchLocateMsg    :String = '你的师父正在找你，他现在位于:';
  g_sYourMasterListUnMasterOKMsg  :String = '你的徒弟%d已经圆满出师了！！！';
  g_sYouAreUnMasterOKMsg          :string = '你已经出师了！！！';

  g_sUnMasterLoginMsg             :String = '你的一个徒弟已经圆满出师了！！！';

  g_sNPCSayUnMasterOKMsg          :String = '[%n]: 我宣布%d与%s正式脱离师徒关系。';

  g_sNPCSayForceUnMasterMsg       :String = '[%n]: 我宣布%s与%d已经正式脱离师徒关系！！！';

}

  g_sMyInfo                       :String; //'『<人物名称>』: %name 『<当前位置>』: %map(%x:%y)\『<当前等级>』: %level 『<金 币 数>』: %gold 『<PK 点 数>』:%pk\『<生 命 值>』: %minhp/%maxhp 『<魔 法 值>』: %minmp/%maxmp\『<攻 击 力>』: %mindc/%maxdc 『<魔 法 力>』: %minmc/%maxmc 『<道 术 力>』: %minsc/%maxsc\『<登录时间>』: %logontime 『<在线时长>』: %logonlong 分钟\';
  g_sSendOnlineCountMsg           :String = '当前在线人数: %c';

  g_sOpenedDealMsg                :String = '开始交易.';
  g_sSendCustMsgCanNotUseNowMsg   :String = '祝福语功能还没有开放.';
  g_sSubkMasterMsgCanNotUseNowMsg :String = '城主发信息功能还没有开放!';
  g_sWeaponRepairSuccess          :String = '武器修复成功...';
  g_sDefenceUpTime                :String = '防御力增加%d秒';
  g_sMagDefenceUpTime             :String = '魔法防御力增加%d秒';
  g_sAttPowerUpTime               :String = '你中毒了[时间:%d秒，点数:%d点]';

//取消彩票功能
//  g_sWinLottery1Msg               :String = '祝贺您，中了一等奖。';
//  g_sWinLottery2Msg               :String = '祝贺您，中了二等奖。';
//  g_sWinLottery3Msg               :String = '祝贺您，中了三等奖。';
//  g_sWinLottery4Msg               :String = '祝贺您，中了四等奖。';
//  g_sWinLottery5Msg               :String = '祝贺您，中了五等奖。';
//  g_sWinLottery6Msg               :String = '祝贺您，中了六等奖。';
//  g_sNotWinLotteryMsg             :String = '等下次机会吧!';

  g_sWeaptonMakeLuck              :String = '武器被加幸运了...';
  g_sWeaptonNotMakeLuck           :String = '无效.';
  g_sTheWeaponIsCursed            :String = '你的武器被诅咒了.';
  g_sCanotTakeOffItem             :String = '无法取下物品.';
  g_sJoinGroup                    :String = '%s 已加入小组.';
  g_sTryModeCanotUseStorage       :String = '试玩模式不可以使用仓库功能.';
  g_sCanotGetItems                :String = '无法携带更多的东西.';

//  g_sEnableDearRecall             :String = '[允许夫妻传送]';
//  g_sDisableDearRecall            :String = '[禁止夫妻传送]';
//  g_sEnableMasterRecall           :String = '[允许师徒传送]';
//  g_sDisableMasterRecall          :String = '[禁止师徒传送]';

  g_sNowCurrDateTime              :String = '前系统日期时间: ';
  g_sEnableHearWhisper            :String = '[允许私聊]';
  g_sDisableHearWhisper           :String = '[禁止私聊]';
  g_sEnableShoutMsg               :String = '[允许群聊]';
  g_sDisableShoutMsg              :String = '[禁止群聊]';
  g_sEnableDealMsg                :String = '[允许交易]';
  g_sDisableDealMsg               :String = '[禁止交易]';
  g_sEnableGuildChat              :String = '[允许行会聊天]';
  g_sDisableGuildChat             :String = '[禁止行会聊天]';
  g_sEnableJoinGuild              :String = '[允许加入行会]';
  g_sDisableJoinGuild             :String = '[禁止加入行会]';
  g_sEnableAuthAllyGuild          :String = '[允许行会联盟]';
  g_sDisableAuthAllyGuild         :String = '[禁止行会联盟]';
  g_sEnableGroupRecall            :String = '[允许天地合一]';
  g_sDisableGroupRecall           :String = '[禁止天地合一]';
  g_sEnableGuildRecall            :String = '[允许行会合一]';
  g_sDisableGuildRecall           :String = '[禁止行会合一]';
  g_sPleaseInputPassword          :String = '请输入密码:';
  g_sTheMapDisableMove            :String = '地图%s(%s)不允许传送...';
  g_sTheMapNotFound               :String = '%s 此地图号不存在.';
  g_sYourIPaddrDenyLogon          :String = '你当前登录的IP地址已被禁止登录了！！！';
  g_sYourAccountDenyLogon         :String = '你当前登录的帐号已被禁止登录了！！！';
  g_sYourCharNameDenyLogon        :String = '你当前登录的人物已被禁止登录了！！！';
  g_sCanotPickUpItem              :String = '在一定时间以内无法捡起此物品！！！';
  g_sCanotSendmsg                 :String = '无法发送信息.';
  g_sUserDenyWhisperMsg           :String = '  拒绝私聊...';
  g_sUserNotOnLine                :String = '  没有在线...';
  g_sRevivalRecoverMsg            :String = '复活戒指生效，体力恢复.';
  g_sClientVersionTooOld          :String = '由于您使用的客户端版本太老了，无法正确显示人物信息！！！';

  g_sCastleGuildName              :String = '(%castlename)%guildname[%rankname]';
  g_sNoCastleGuildName            :String = '%guildname[%rankname]';
  g_sWarrReNewName                :String = '%chrname\*<圣>*';
  g_sWizardReNewName              :String = '%chrname\*<神>*';
  g_sTaosReNewName                :String = '%chrname\*<尊>*';
  g_sRankLevelName                :String = '%s\Level';

//  g_sManDearName                  :String = '%ss 的老公';
//  g_sWoManDearName                :String = '%ss 的老婆';
//  g_sMasterName                   :String = '%ss 的师父';
//  g_sNoMasterName                 :String = '%ss 的徒弟';
//  g_sHumanShowName                :String = '%chrname\%guildname\%dearname\%mastername';

  g_sHumanShowName                :String = '%chrname\%guildname';  //更改角名显示：角色名和行会名  （这是传奇1.50版的显示）

  g_sChangePermissionMsg          :String = '当前权限等级为:%d';
  g_sChangeKillMonExpRateMsg      :String = '经验倍数:%g 时长%d秒';
  g_sChangePowerRateMsg           :String = '攻击力倍数:%g 时长%d秒';
  g_sChangeMemberLevelMsg         :String = '当前会员等级为:%d';
  g_sChangeMemberTypeMsg          :String = '当前会员类型为:%d';
  g_sScriptChangeHumanHPMsg       :String = '当前HP值为:%d';
  g_sScriptChangeHumanMPMsg       :String = '当前MP值为:%d';
  g_sScriptGuildAuraePointNoGuild :String = '你还没加入行会！！！';
  g_sScriptGuildAuraePointMsg     :String = '你的行会人气度为:%d';
  g_sScriptGuildBuildPointNoGuild :String = '你还没加入行会！！！';
  g_sScriptGuildBuildPointMsg     :String = '你的行会的建筑度为:%d';
  g_sScriptGuildFlourishPointNoGuild :String = '你还没加入行会！！！';
  g_sScriptGuildFlourishPointMsg  :String = '你的行会的繁荣度为:%d';
  g_sScriptGuildStabilityPointNoGuild:String = '你的行会的建筑度为:%d';
  g_sScriptGuildStabilityPointMsg :String = '你的行会的安定度为:%d';
  g_sScriptChiefItemCountMsg      :String = '你的行会的超级装备数为:%d';

  g_sDisableSayMsg                :String = '[由于你重复发相同的内容，%d分钟内你将被禁止发言...]';
  g_sOnlineCountMsg               :String = '在线人数: %d';
  g_sTotalOnlineCountMsg          :String = '总在线人数: %d';
  g_sYouNeedLevelMsg              :String = '你的等级要在%d级以上才能用此功能！！！';
  g_sThisMapDisableSendCyCyMsg    :String = '本地图不允许喊话！！！';
  g_sYouCanSendCyCyLaterMsg       :String = '%d秒后才可以再发文字！！';
  g_sYouIsDisableSendMsg          :String = '禁止聊天！！';
  g_sYouMurderedMsg               :String = '你犯了谋杀罪...';
  g_sYouKilledByMsg               :String = '你被%s杀害了...';
  g_sYouProtectedByLawOfDefense   :String = '[--你受到正当规则保护--]';
  g_sYourUseItemIsNul             :String = '你的%s处没有放上装备...';

ResourceString
  g_sGameLogMsg1                   = '%d'#9'%s'#9'%d'#9'%d'#9'%s'#9'%s'#9'%d'#9'%s'#9'%s';
  g_sHumanDieEvent                 = '人物死亡事件';
  g_sHitOverSpeed                  = '[攻击超速] %s 间隔:%d 数量:%d';
  g_sRunOverSpeed                  = '[跑步超速] %s 间隔:%d 数量:%d';
  g_sWalkOverSpeed                 = '[行走超速] %s 间隔:%d 数量:%d';
  g_sSpellOverSpeed                = '[魔法超速] %s 间隔:%d 数量:%d';
  g_sBunOverSpeed                  = '[游戏超速] %s 间隔:%d 数量:%d';

  g_sGameCommandPermissionTooLow   = '权限不够...';
  g_sGameCommandParamUnKnow        = '命令格式: @%s %s';
  g_sGameCommandMoveHelpMsg        = '地图号';
  g_sGameCommandPositionMoveHelpMsg         = '地图号 座标X 座标Y';
  g_sGameCommandPositionMoveCanotMoveToMap  = '无法移动到地图: %s X:%s Y:%s';
  g_sGameCommandInfoHelpMsg                 = '人物名称';
//  g_sGameCommandHumanNotOnLine             :String = '%s 现在没在线！！！';
  g_sNowNotOnLineOrOnOtherServer            = '%s 现在不在线，或在其它服务器上！！！';
  g_sGameCommandMobCountHelpMsg             = '地图号';
  g_sGameCommandMobCountMapNotFound         = '指定的地图不存在！！！';
  g_sGameCommandMobCountMonsterCount        = '怪物数量：%d';
  g_sGameCommandHumanCountHelpMsg           = '地图号';
  g_sGameCommandKickHumanHelpMsg            = '人物名称';
  g_sGameCommandTingHelpMsg                 = '人物名称';
  g_sGameCommandSuperTingHelpMsg            = '人物名称 范围(0-10)';
  g_sGameCommandMapMoveHelpMsg              = '源地图  目标地图';
  g_sGameCommandMapMoveMapNotFound          = '地图%s不存在！！！';
  g_sGameCommandShutupHelpMsg               = '人物名称  时间长度(分钟)';
  g_sGameCommandShutupHumanMsg              = '%s 已被禁言%d分钟';
  g_sGameCommandGamePointHelpMsg            = '人物名称 控制符(+,-,=) 游戏点数(1-100000000)';
  g_sGameCommandGamePointHumanMsg           = '你的游戏点已增加%d点，当前总点数为%d点。';
  g_sGameCommandGamePointGMMsg              = '%s的游戏点已增加%d点，当前总点数为%d点。';

  g_sGameCommandCreditPointHelpMsg          = '人物名称 控制符(+,-,=) 声望点数(0-255)';
  g_sGameCommandCreditPointHumanMsg         = '你的声望点已增加%d点，当前总声望点数为%d点。';
  g_sGameCommandCreditPointGMMsg            = '%s的声望点已增加%d点，当前总声望点数为%d点。';

  g_sGameCommandGameGoldHelpMsg             = ' 人物名称 控制符(+,-,=) 游戏币(1-200000000)';
  g_sGameCommandGameGoldHumanMsg            = '你的%s已增加%d，当前拥有%d%s。';
  g_sGameCommandGameGoldGMMsg               = '%s的%s已增加%d，当前拥有%d%s。';

  g_sGameCommandMapInfoMsg                  = '地图名称: %s(%s)';
  g_sGameCommandMapInfoSizeMsg              = '地图大小: X(%d) Y(%d)';

  g_sGameCommandShutupReleaseHelpMsg        = '人物名称';
  g_sGameCommandShutupReleaseCanSendMsg     = '你已经恢复聊天功能！！！';
  g_sGameCommandShutupReleaseHumanCanSendMsg  = '%s 已经恢复聊天。';
  g_sGameCommandShutupListIsNullMsg         = '禁言列表为空！！！';

  g_sGameCommandLevelConsoleMsg             = '[等级调整] %s (%d -> %d)';
  g_sGameCommandSbkGoldHelpMsg              = '城堡名称 控制符(=、-、+) 金币数(1-100000000)';
  g_sGameCommandSbkGoldCastleNotFoundMsg    = '城堡%s未找到！！！';
  g_sGameCommandSbkGoldShowMsg              = '%s的金币数为: %d 今天收入: %d';
  g_sGameCommandRecallHelpMsg               = '人物名称';
  g_sGameCommandReGotoHelpMsg               = '人物名称';
  g_sGameCommandShowHumanFlagHelpMsg        = '人物名称 标识号';
  g_sGameCommandShowHumanFlagONMsg          = '%s: [%d] = ON';
  g_sGameCommandShowHumanFlagOFFMsg         = '%s: [%d] = OFF';

  g_sGameCommandShowHumanUnitHelpMsg        = '人物名称 单元号';
  g_sGameCommandShowHumanUnitONMsg          = '%s: [%d] = ON';
  g_sGameCommandShowHumanUnitOFFMsg         = '%s: [%d] = OFF';
  g_sGameCommandMobHelpMsg                  = '怪物名称 数量 等级';
  g_sGameCommandMobMsg                      = '怪物名称不正确或其它未问题！！！';
  g_sGameCommandMobNpcHelpMsg               = 'NPC名称 脚本文件名 外形(数字) 属沙城(0,1)';
  g_sGameCommandNpcScriptHelpMsg            = '？？？？';
  g_sGameCommandDelNpcMsg                   = '命令使用方法不正确，必须与NPC面对面，才能使用此命令！！！';
  g_sGameCommandRecallMobHelpMsg            = '怪物名称 数量 等级';
  g_sGameCommandLuckPointHelpMsg            = '人物名称 控制符 幸运点数';

  g_sGameCommandLuckPointMsg                = '%s 的幸运点数为:%d/%g 幸运值为:%d';

//取消彩票功能
//  g_sGameCommandLotteryTicketMsg            = '已中彩票数:%d 未中彩票数:%d 一等奖:%d 二等奖:%d 三等奖:%d 四等奖:%d 五等奖:%d 六等奖:%d ';

  g_sGameCommandReloadGuildHelpMsg          = '行会名称';
  g_sGameCommandReloadGuildOnMasterserver   = '此命令只能在主游戏服务器上执行！！！';
  g_sGameCommandReloadGuildNotFoundGuildMsg = '未找到行会%s！！！';
  g_sGameCommandReloadGuildSuccessMsg       = '行会%s重加载成功...';

  g_sGameCommandReloadLineNoticeSuccessMsg  = '重新加载公告设置信息完成。';
  g_sGameCommandReloadLineNoticeFailMsg     = '重新加载公告设置信息失败！！！';
  g_sGameCommandFreePKHelpMsg               = '人物名称';
  g_sGameCommandFreePKHumanMsg              = '你的PK值已经被清除...';
  g_sGameCommandFreePKMsg                   = '%s的PK值已经被清除...';
  g_sGameCommandPKPointHelpMsg              = '人物名称';
  g_sGameCommandPKPointMsg                  = '%s的PK点数为:%d';
  g_sGameCommandIncPkPointHelpMsg           = '人物名称 PK点数';
  g_sGameCommandIncPkPointAddPointMsg       = '%s的PK值已增加%d点...';
  g_sGameCommandIncPkPointDecPointMsg       = '%s的PK值已减少%d点...';
  g_sGameCommandHumanLocalHelpMsg           = '人物名称';
  g_sGameCommandHumanLocalMsg               = '%s来自:%s';
  g_sGameCommandPrvMsgHelpMsg               = '人物名称';
  g_sGameCommandPrvMsgUnLimitMsg            = '%s 已从禁止私聊列表中删除...';
  g_sGameCommandPrvMsgLimitMsg              = '%s 已被加入禁止私聊列表...';
  g_sGamecommandMakeHelpMsg                 = ' 物品名称  数量';
  g_sGamecommandMakeItemNameOrPerMissionNot = '输入的物品名称不正确，或权限不够！！！';
  g_sGamecommandMakeInCastleWarRange        = '攻城区域，禁止使用此功能！！！';
  g_sGamecommandMakeInSafeZoneRange         = '非安全区，禁止使用此功能！！！';
  g_sGamecommandMakeItemNameNotFound        = '%s 物品名称不正确！！！';
  g_sGamecommandSuperMakeHelpMsg            = '身上没指定物品！！！';
  g_sGameCommandViewWhisperHelpMsg          = ' 人物名称';
  g_sGameCommandViewWhisperMsg1             = '已停止侦听%s的私聊信息...';
  g_sGameCommandViewWhisperMsg2             = '正在侦听%s的私聊信息...';
  g_sGameCommandReAliveHelpMsg              = ' 人物名称';
  g_sGameCommandReAliveMsg                  = '%s 已获重生.';
  g_sGameCommandChangeJobHelpMsg            = ' 人物名称 职业类型(Warr Wizard Taos)';
  g_sGameCommandChangeJobMsg                = '%s 的职业更改成功。';
  g_sGameCommandChangeJobHumanMsg           = '职业更改成功。';
  g_sGameCommandTestGetBagItemsHelpMsg      = '(用于测试升级武器方面参数)';
  g_sGameCommandShowUseItemInfoHelpMsg      = '人物名称';
  g_sGameCommandBindUseItemHelpMsg          = '人物名称 物品类型 绑定方法';
  g_sGameCommandBindUseItemNoItemMsg        = '%s的%s没有戴物品！！！';
  g_sGameCommandBindUseItemAlreadBindMsg    = '%s的%s上的物品早已绑定过了！！！';
  g_sGameCommandMobFireBurnHelpMsg          = '命令格式: %s %s %s %s %s %s %s';
  g_sGameCommandMobFireBurnMapNotFountMsg   = '地图%s 不存在';

resourcestring
  {U_DRESSNAME      = '衣服';
  U_WEAPONNAME      = '武器';
  U_RIGHTHANDNAME   = '照明物';
  U_NECKLACENAME    = '项链';
  U_HELMETNAME      = '头盔';
  U_ARMRINGLNAME    = '左手镯';
  U_ARMRINGRNAME    = '右手镯';
  U_RINGLNAME       = '左戒指';
  U_RINGRNAME       = '右戒指';

  U_BUJUKNAME       = '物品';
  U_BELTNAME        = '腰带';
  U_BOOTSNAME       = '鞋子';
  U_CHARMNAME       = '宝石';}

  U_DRESSNAME     = 'Dress';     //衣服
  U_WEAPONNAME    = 'Weapon';    //武器
  U_RIGHTHANDNAME = 'RightHand'; //照明物 (火把)
  U_NECKLACENAME  = 'Necklace';  //项链
  U_HELMETNAME    = 'Helmet';    //头盔
  U_ARMRINGLNAME  = 'BraceL';    //左手镯
  U_ARMRINGRNAME  = 'BraceR';    //右手镯
  U_RINGLNAME     = 'RingL';     //左戒指
  U_RINGRNAME     = 'RingR';     //右戒指
  U_BUJUKNAME     = 'Bujuk';     //护身符(道符)

//  U_BELTNAME  = 'Belt';        //腰带
//  U_BOOTSNAME = 'Boots';       //鞋子
//  U_CHARMNAME = 'Charm';

//===============================================================
var
  IPLocal: TIPLocal = nil;
  nIPLocal: Integer = -1;
implementation

uses HUtil32, EDcode;
var
  nAddGameDataLog: Integer = -1;
procedure SetProcessName(sName: string);
begin
//  g_sOldProcessName:=g_sProcessName;
//  g_sProcessName:=sName;
end;
procedure CopyStdItemToOStdItem(StdItem: pTStdItem; OStdItem: pTOStdItem);
begin
  OStdItem.Name := StdItem.Name;
  OStdItem.StdMode := StdItem.StdMode;
  OStdItem.Shape := StdItem.Shape;
  OStdItem.Weight := StdItem.Weight;
  OStdItem.AniCount := StdItem.AniCount;
  OStdItem.Source := StdItem.Source;
  OStdItem.Reserved := StdItem.Reserved;
  OStdItem.NeedIdentify := StdItem.NeedIdentify;
  OStdItem.Looks := StdItem.Looks;
  OStdItem.DuraMax := StdItem.DuraMax;
  OStdItem.AC := MakeWord(_MIN(High(Byte), LoWord(StdItem.AC)), _MIN(High(Byte), HiWord(StdItem.AC)));
  OStdItem.MAC := MakeWord(_MIN(High(Byte), LoWord(StdItem.MAC)), _MIN(High(Byte), HiWord(StdItem.MAC)));
  OStdItem.DC := MakeWord(_MIN(High(Byte), LoWord(StdItem.DC)), _MIN(High(Byte), HiWord(StdItem.DC)));
  OStdItem.MC := MakeWord(_MIN(High(Byte), LoWord(StdItem.MC)), _MIN(High(Byte), HiWord(StdItem.MC)));
  OStdItem.SC := MakeWord(_MIN(High(Byte), LoWord(StdItem.SC)), _MIN(High(Byte), HiWord(StdItem.SC)));
  OStdItem.Need := StdItem.Need;
  OStdItem.NeedLevel := StdItem.NeedLevel;
  OStdItem.Price := StdItem.Price;
end;


//004E40B0
function LoadLineNotice(FileName: string): Boolean;
var
  i: Integer;
  sText: string;
begin
  Result := False;
  if FileExists(FileName) then
  begin
    LineNoticeList.LoadFromFile(FileName);
    i := 0;
    while (True) do
    begin
      if LineNoticeList.Count <= i then Break;
      sText := Trim(LineNoticeList.Strings[i]);
      if sText = '' then
      begin
        LineNoticeList.Delete(i);
        Continue;
      end;
      LineNoticeList.Strings[i] := sText;
      Inc(i);
    end;
    Result := True;
  end;
end;
function GetMultiServerAddrPort(btServerIndex: Byte; var sIPaddr: string; var nPort: Integer): Boolean;
begin
  Result := False;
//  ServerTableList
end;
procedure MainOutMessage(Msg: string);
begin
  if not g_Config.boShowExceptionMsg then
  begin
    if (Length(Msg) > 2) and ((Msg[2] = 'E') or (Msg[1] = 'A')) then
      Exit;
  end;
  EnterCriticalSection(LogMsgCriticalSection);
  try
    MainLogMsgList.Add('[' + DateTimeToStr(Now) + '] ' + Msg);
  finally
    LeaveCriticalSection(LogMsgCriticalSection);
  end;
end;

//获取扩展的版本号
function GetExVersionNO(nVersionDate: Integer; var nOldVerstionDate: Integer): Integer;
begin
  Result := 0;
  nOldVerstionDate := 0;

  if nVersionDate > 100000000 then
  begin
    while (nVersionDate > 100000000) do
    begin
      Dec(nVersionDate, 100000000);
      Inc(Result, 100000000);
    end;
  end;
  nOldVerstionDate := nVersionDate;
end;

function GetNextDirection(sX, sY, dx, dy: Integer): Byte; //004B2C38
var
  flagx, flagy: Integer;
begin
  Result := DR_DOWN;
  if sX < dx then flagx := 1
  else if sX = dx then flagx := 0
  else flagx := -1;
  if abs(sY - dy) > 2
    then if (sX >= dx - 1) and (sX <= dx + 1) then flagx := 0;

  if sY < dy then flagy := 1
  else if sY = dy then flagy := 0
  else flagy := -1;
  if abs(sX - dx) > 2 then if (sY > dy - 1) and (sY <= dy + 1) then flagy := 0;

  if (flagx = 0) and (flagy = -1) then Result := DR_UP;
  if (flagx = 1) and (flagy = -1) then Result := DR_UPRIGHT;
  if (flagx = 1) and (flagy = 0) then Result := DR_RIGHT;
  if (flagx = 1) and (flagy = 1) then Result := DR_DOWNRIGHT;
  if (flagx = 0) and (flagy = 1) then Result := DR_DOWN;
  if (flagx = -1) and (flagy = 1) then Result := DR_DOWNLEFT;
  if (flagx = -1) and (flagy = 0) then Result := DR_LEFT;
  if (flagx = -1) and (flagy = -1) then Result := DR_UPLEFT;
end;
function CheckUserItems(nIdx: Integer; StdItem: TItem): Boolean; //004B2D70
begin
  Result := False;
  case nIdx of
    U_DRESS: if StdItem.StdMode in [10, 11] then Result := True;
    U_WEAPON: if (StdItem.StdMode = 5) or (StdItem.StdMode = 6) then Result := True;
    U_RIGHTHAND: if (StdItem.StdMode = 29) or (StdItem.StdMode = 30) or (StdItem.StdMode = 28) then Result := True;
    U_NECKLACE: if (StdItem.StdMode = 19) or (StdItem.StdMode = 20) or (StdItem.StdMode = 21) then Result := True;
    U_HELMET: if StdItem.StdMode = 15 then Result := True;
    U_ARMRINGL: if (StdItem.StdMode = 24) or (StdItem.StdMode = 25) or (StdItem.StdMode = 26) then Result := True;
    U_ARMRINGR: if (StdItem.StdMode = 24) or (StdItem.StdMode = 26) then Result := True;
    U_RINGL, U_RINGR: if (StdItem.StdMode = 22) or (StdItem.StdMode = 23) then Result := True;
    U_BUJUK: if (StdItem.StdMode = 25) or (StdItem.StdMode = 51) then Result := True;

//    U_BELT: if (StdItem.StdMode = 54) or (StdItem.StdMode = 64) then Result := True;
//    U_BOOTS: if (StdItem.StdMode = 52) or (StdItem.StdMode = 62) then Result := True;
//    U_CHARM: if (StdItem.StdMode = 53) or (StdItem.StdMode = 63) then Result := True;
  end;
end;

function AddDateTimeOfDay(DateTime: TDateTime; nDay: Integer): TDateTime; //00455DD4
var
  Year, Month, Day: Word;
begin
  if nDay > 0 then
  begin
    Dec(nDay);
    DecodeDate(DateTime, Year, Month, Day);
    while (True) do
    begin
      if MonthDays[False][Month] >= (Day + nDay) then Break;
      nDay := (Day + nDay) - MonthDays[False][Month] - 1;
      Day := 1;
      if Month <= 11 then
      begin
        Inc(Month);
        Continue;
      end;
      Month := 1;
      if Year = 99 then
      begin
        Year := 2000;
        Continue;
      end;
      Inc(Year);
    end; // while
    //TryEncodeDate(Year,Month,Day,Result);
    Inc(Day, nDay);
    Result := EncodeDate(Year, Month, Day);
  end else
  begin
    Result := DateTime;
  end;

end;
function GetGoldShape(nGold: Integer): Word;
//00455E98
begin
  Result := 112;
  if nGold >= 30 then Result := 113;
  if nGold >= 70 then Result := 114;
  if nGold >= 300 then Result := 115;
  if nGold >= 1000 then Result := 116;
end;
function GetRandomLook(nBaseLook, nRage: Integer): Integer; //00455EEC
begin
  Result := nBaseLook + Random(nRage);
end;
function CheckGuildName(sGuildName: string): Boolean; //00455BF4
var
  i: Integer;
begin
  Result := True;
  if Length(sGuildName) > g_Config.nGuildNameLen then
  begin
    Result := False;
    Exit;
  end;
  for i := 1 to Length(sGuildName) do
  begin
    if (sGuildName[i] < '0' {30}) or
      (sGuildName[i] = '/' {2F}) or
      (sGuildName[i] = '\' {5C}) or
      (sGuildName[i] = ':' {3A}) or
      (sGuildName[i] = '*') or
      (sGuildName[i] = ' ') or
      (sGuildName[i] = '"') or
      (sGuildName[i] = '''') or
      (sGuildName[i] = '<' {3C}) or
      (sGuildName[i] = '|' {7C}) or
      (sGuildName[i] = '?' {3F}) or
      (sGuildName[i] = '>' {3E}) then
    begin
      Result := False;
    end;
  end;
end;
function GetItemNumber(): Integer; //004E3E34
begin
  Inc(g_Config.nItemNumber);
  if g_Config.nItemNumber > (High(Integer) div 2 - 1) then
  begin
    g_Config.nItemNumber := 1;
  end;
  Result := g_Config.nItemNumber;
end;
function GetItemNumberEx(): Integer;
begin
  Inc(g_Config.nItemNumberEx);
  if g_Config.nItemNumberEx < High(Integer) div 2 then g_Config.nItemNumberEx := High(Integer) div 2;

  if g_Config.nItemNumberEx > (High(Integer) - 1) then
  begin
    g_Config.nItemNumberEx := High(Integer) div 2;
  end;
  Result := g_Config.nItemNumberEx;
end;
function FilterShowName(sName: string): string;
var
  i: Integer;
  SC: string;
  bo11: Boolean;
begin
  Result := '';
  SC := '';
  bo11 := False;
  for i := 1 to Length(sName) do
  begin
    if ((sName[i] >= '0') and (sName[i] <= '9')) or (sName[i] = '-') then
    begin
      Result := Copy(sName, 1, i - 1);
      SC := Copy(sName, i, Length(sName));
      bo11 := True;
      Break;
    end;
  end;
  if not bo11 then Result := sName;
end;
function sub_4B2F80(nDir, nRage: Integer): Byte;
begin
  Result := (nDir + nRage) mod 8;
end;
function GetValNameNo(sText: string): Integer; //0049ABF0
var
  nValNo: Integer;
begin
  Result := -1;
  if Length(sText) >= 2 then
  begin
    if UpCase(sText[1]) = 'P' then
    begin
      nValNo := Str_ToInt(sText[2], -1);
      if nValNo < 10 then Result := nValNo;
    end;
    if UpCase(sText[1]) = 'G' then
    begin
      if Length(sText) = 3 then
      begin
        nValNo := Str_ToInt(Copy(sText, 2, 2), -1);
        if nValNo < 20 then Result := nValNo + 100;
      end else
      begin
        nValNo := Str_ToInt(sText[2], -1);
        if nValNo < 10 then Result := nValNo + 100;
      end;
    end;
    if UpCase(sText[1]) = 'M' then
    begin
      if Length(sText) = 3 then
      begin
        nValNo := Str_ToInt(Copy(sText, 2, 2), -1);
        if nValNo < 100 then Result := nValNo + 300;
      end else
      begin
        nValNo := Str_ToInt(sText[2], -1);
        if nValNo < 10 then Result := nValNo + 300;
      end;
    end;
    if UpCase(sText[1]) = 'I' then
    begin
      if Length(sText) = 3 then
      begin
        nValNo := Str_ToInt(Copy(sText, 2, 2), -1);
        if nValNo < 100 then Result := nValNo + 400;
      end else
      begin
        nValNo := Str_ToInt(sText[2], -1);
        if nValNo < 10 then Result := nValNo + 400;
      end;
    end;
    if UpCase(sText[1]) = 'D' then
    begin
      nValNo := Str_ToInt(sText[2], -1);
      if nValNo < 10 then Result := nValNo + 200;
    end;
  end;
end;
function IsAccessory(nIndex: Integer): Boolean; //004B2E94
var
  Item: TItem;
begin
  Item := UserEngine.GetStdItem(nIndex);
  if Item.ItemType = ITEM_ACCESSORY then Result := True
  //if Item.StdMode in [19,20,21,22,23,24,26] then Result:=True
  else Result := False;

end;
function GetMakeItemInfo(sItemName: string): TStringList;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to g_MakeItemList.Count - 1 do
  begin
    if g_MakeItemList.Strings[i] = sItemName then
    begin
      Result := TStringList(g_MakeItemList.Objects[i]);
      Break;
    end;
  end;
end;

procedure AddGameDataLog(sMsg: string);
begin
  //调用插件中的日志处理函数，返回值为True 时直接退出函数，False 时使用默认函数处理游戏日志
  EnterCriticalSection(LogMsgCriticalSection);
  try
    LogStringList.Add(sMsg);
  finally
    LeaveCriticalSection(LogMsgCriticalSection);
  end;
end;
procedure AddLogonCostLog(sMsg: string); //004E437C
begin
  EnterCriticalSection(LogMsgCriticalSection);
  try
    LogonCostLogList.Add(sMsg);
  finally
    LeaveCriticalSection(LogMsgCriticalSection);
  end;
end;
procedure TrimStringList(sList: TStringList); //0x00455D48
var
  n8: Integer;
  SC: string;
begin
  n8 := 0;
  while (True) do
  begin
    if (sList.Count) <= n8 then Break;
    SC := Trim(sList.Strings[n8]);
    if SC = '' then
    begin
      sList.Delete(n8);
      Continue;
    end;
    Inc(n8);
  end;
end;
function CanMakeItem(sItemName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  g_DisableMakeItemList.Lock;
  try
    for i := 0 to g_DisableMakeItemList.Count - 1 do
    begin
      if CompareText(g_DisableMakeItemList.Strings[i], sItemName) = 0 then
      begin
        Result := False;
        Exit;
      end;
    end;
  finally
    g_DisableMakeItemList.UnLock;
  end;

  g_EnableMakeItemList.Lock;
  try
    for i := 0 to g_EnableMakeItemList.Count - 1 do
    begin
      if CompareText(g_EnableMakeItemList.Strings[i], sItemName) = 0 then
      begin
        Result := True;
        Break;
      end;
    end;
  finally
    g_EnableMakeItemList.UnLock;
  end;
end;

function CanMoveMap(sMapName: string): Boolean;
var
  i: Integer;
begin
  Result := True;
  g_DisableMoveMapList.Lock;
  try
    for i := 0 to g_DisableMoveMapList.Count - 1 do
    begin
      if CompareText(g_DisableMoveMapList.Strings[i], sMapName) = 0 then
      begin
        Result := False;
        Break;
      end;
    end;
  finally
    g_DisableMoveMapList.UnLock;
  end;
end;

//物品是否允许销售
function CanSellItem(sItemName: string): Boolean;
var
  i: Integer;
begin
  Result := True;
  g_DisableSellOffList.Lock;
  try
    for i := 0 to g_DisableSellOffList.Count - 1 do
    begin
      if CompareText(g_DisableSellOffList.Strings[i], sItemName) = 0 then
      begin
        Result := False;
        Break;
      end;
    end;
  finally
    g_DisableSellOffList.UnLock;
  end;
end;
{function Loadshoplist(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
  sLineText, stypename, sItemsname, sItemspic, sdic,sItemsindex, sEffectindex, spicindex: string;
  nItemsindex, nEffectindex, npicindex: Integer;
  shoplist: Tshoplist;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ShopItemList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_Shoplist.Lock;
    try
      for i := 0 to g_Shoplist.Count - 1 do begin
        Dispose(pTshoplist(g_Shoplist.Items[i]));
      end;
      g_Shoplist.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do begin
        sLineText := Trim(LoadList.Strings[i]);
        if sLineText[1] = ';' then Continue;
        sLineText := GetValidStr3(sLineText, stypename, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sItemsname, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sItemsindex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sItemspic, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sEffectindex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, spicindex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sdic, [' ', ',', #9]);

      //  nItemsindex := Str_ToInt(nItemsindex, -1);
      //  nEffectindex := Str_ToInt(nEffectindex, -1);
      //  npicindex := Str_ToInt(npicindex, -1);

        if (nItemsindex > 0) and (nEffectindex > 0) and (npicindex > 0) then begin
       //   New(shoplist);
          shoplist.nItemsindex := nItemsindex;
          shoplist.nEffectindex := nEffectindex;
          shoplist.npicindex := npicindex;
          g_Shoplist.Add(shoplist);
        end;
      end;
    finally
      g_Shoplist.UnLock;
    end;
    Result := True;
  end else begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;     }

function LoadItemBindIPaddr(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
  sLineText, sMakeIndex, sItemIndex, sBindName: string;
  nMakeIndex, nItemIndex: Integer;
  ItemBind: pTItemBind;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemBindIPaddr.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_ItemBindIPaddr.Lock;
    try
      for i := 0 to g_ItemBindIPaddr.Count - 1 do
      begin
        Dispose(pTItemBind(g_ItemBindIPaddr.Items[i]));
      end;
      g_ItemBindIPaddr.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        sLineText := Trim(LoadList.Strings[i]);
        if sLineText[1] = ';' then Continue;
        sLineText := GetValidStr3(sLineText, sItemIndex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sMakeIndex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sBindName, [' ', ',', #9]);
        nMakeIndex := Str_ToInt(sMakeIndex, -1);
        nItemIndex := Str_ToInt(sItemIndex, -1);
        if (nMakeIndex > 0) and (nItemIndex > 0) and (sBindName <> '') then
        begin
          New(ItemBind);
          ItemBind.nMakeIdex := nMakeIndex;
          ItemBind.nItemIdx := nItemIndex;
          ItemBind.sBindName := sBindName;
          g_ItemBindIPaddr.Add(ItemBind);
        end;
      end;
    finally
      g_ItemBindIPaddr.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;
function SaveItemBindIPaddr(): Boolean;
var
  i: Integer;
  SaveList: TStringList;
  sFileName: string;
  ItemBind: pTItemBind;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemBindIPaddr.txt';
  SaveList := TStringList.Create;
  g_ItemBindIPaddr.Lock;
  try
    for i := 0 to g_ItemBindIPaddr.Count - 1 do
    begin
      ItemBind := g_ItemBindIPaddr.Items[i];
      SaveList.Add(IntToStr(ItemBind.nItemIdx) + #9 + IntToStr(ItemBind.nMakeIdex) + #9 + ItemBind.sBindName);
    end;
  finally
    g_ItemBindIPaddr.UnLock;
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
  Result := True;
end;
function LoadItemBindAccount(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
  sLineText, sMakeIndex, sItemIndex, sBindName: string;
  nMakeIndex, nItemIndex: Integer;
  ItemBind: pTItemBind;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemBindAccount.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_ItemBindAccount.Lock;
    try
      for i := 0 to g_ItemBindAccount.Count - 1 do
      begin
        Dispose(pTItemBind(g_ItemBindAccount.Items[i]));
      end;
      g_ItemBindAccount.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        sLineText := Trim(LoadList.Strings[i]);
        if sLineText[1] = ';' then Continue;
        sLineText := GetValidStr3(sLineText, sItemIndex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sMakeIndex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sBindName, [' ', ',', #9]);
        nMakeIndex := Str_ToInt(sMakeIndex, -1);
        nItemIndex := Str_ToInt(sItemIndex, -1);
        if (nMakeIndex > 0) and (nItemIndex > 0) and (sBindName <> '') then
        begin
          New(ItemBind);
          ItemBind.nMakeIdex := nMakeIndex;
          ItemBind.nItemIdx := nItemIndex;
          ItemBind.sBindName := sBindName;
          g_ItemBindAccount.Add(ItemBind);
        end;
      end;
    finally
      g_ItemBindAccount.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;
function SaveItemBindAccount(): Boolean;
var
  i: Integer;
  SaveList: TStringList;
  sFileName: string;
  ItemBind: pTItemBind;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemBindAccount.txt';
  SaveList := TStringList.Create;
  g_ItemBindAccount.Lock;
  try
    for i := 0 to g_ItemBindAccount.Count - 1 do
    begin
      ItemBind := g_ItemBindAccount.Items[i];
      SaveList.Add(IntToStr(ItemBind.nItemIdx) + #9 + IntToStr(ItemBind.nMakeIdex) + #9 + ItemBind.sBindName);
    end;
  finally
    g_ItemBindAccount.UnLock;
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
  Result := True;
end;
function LoadItemBindCharName(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
  sLineText, sMakeIndex, sItemIndex, sBindName: string;
  nMakeIndex, nItemIndex: Integer;
  ItemBind: pTItemBind;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemBindChrName.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_ItemBindCharName.Lock;
    try
      for i := 0 to g_ItemBindCharName.Count - 1 do
      begin
        Dispose(pTItemBind(g_ItemBindCharName.Items[i]));
      end;
      g_ItemBindCharName.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        sLineText := Trim(LoadList.Strings[i]);
        if sLineText[1] = ';' then Continue;
        sLineText := GetValidStr3(sLineText, sItemIndex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sMakeIndex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sBindName, [' ', ',', #9]);
        nMakeIndex := Str_ToInt(sMakeIndex, -1);
        nItemIndex := Str_ToInt(sItemIndex, -1);
        if (nMakeIndex > 0) and (nItemIndex > 0) and (sBindName <> '') then
        begin
          New(ItemBind);
          ItemBind.nMakeIdex := nMakeIndex;
          ItemBind.nItemIdx := nItemIndex;
          ItemBind.sBindName := sBindName;
          g_ItemBindCharName.Add(ItemBind);
        end;
      end;
    finally
      g_ItemBindCharName.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function SaveItemBindCharName(): Boolean;
var
  i: Integer;
  SaveList: TStringList;
  sFileName: string;
  ItemBind: pTItemBind;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemBindChrName.txt';
  SaveList := TStringList.Create;
  g_ItemBindCharName.Lock;
  try
    for i := 0 to g_ItemBindCharName.Count - 1 do
    begin
      ItemBind := g_ItemBindCharName.Items[i];
      SaveList.Add(IntToStr(ItemBind.nItemIdx) + #9 + IntToStr(ItemBind.nMakeIdex) + #9 + ItemBind.sBindName);
    end;
  finally
    g_ItemBindCharName.UnLock;
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
  Result := True;
end;
function LoadDisableMakeItem(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DisableMakeItem.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_DisableMakeItemList.Lock;
    try
      g_DisableMakeItemList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        g_DisableMakeItemList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_DisableMakeItemList.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;
function SaveDisableMakeItem(): Boolean;
var
  sFileName: string;
begin
  sFileName := g_Config.sEnvirDir + 'DisableMakeItem.txt';
  g_DisableMakeItemList.Lock;
  try
    g_DisableMakeItemList.SaveToFile(sFileName);
  finally
    g_DisableMakeItemList.UnLock;
  end;
  Result := True;
end;
function LoadUnMasterList(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'UnMaster.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_UnMasterList.Lock;
    try
      g_UnMasterList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        g_UnMasterList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_UnMasterList.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;
function SaveUnMasterList(): Boolean;
var
  sFileName: string;
begin
  sFileName := g_Config.sEnvirDir + 'UnMaster.txt';
  g_UnMasterList.Lock;
  try
    g_UnMasterList.SaveToFile(sFileName);
  finally
    g_UnMasterList.UnLock;
  end;
  Result := True;
end;

function LoadUnForceMasterList(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'UnForceMaster.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_UnForceMasterList.Lock;
    try
      g_UnForceMasterList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        g_UnForceMasterList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_UnForceMasterList.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;
function SaveUnForceMasterList(): Boolean;
var
  sFileName: string;
begin
  sFileName := g_Config.sEnvirDir + 'UnForceMaster.txt';
  g_UnForceMasterList.Lock;
  try
    g_UnForceMasterList.SaveToFile(sFileName);
  finally
    g_UnForceMasterList.UnLock;
  end;
  Result := True;
end;

function LoadEnableMakeItem(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'EnableMakeItem.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_EnableMakeItemList.Lock;
    try
      g_EnableMakeItemList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        g_EnableMakeItemList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_EnableMakeItemList.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function SaveEnableMakeItem(): Boolean;
var
  sFileName: string;
begin
  sFileName := g_Config.sEnvirDir + 'EnableMakeItem.txt';
  g_EnableMakeItemList.Lock;
  try
    g_EnableMakeItemList.SaveToFile(sFileName);
  finally
    g_EnableMakeItemList.UnLock;
  end;
  Result := True;
end;

function LoadDisableMoveMap(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DisableMoveMap.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_DisableMoveMapList.Lock;
    try
      g_DisableMoveMapList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        g_DisableMoveMapList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_DisableMoveMapList.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;
function SaveDisableMoveMap(): Boolean;
var
  sFileName: string;
begin
  sFileName := g_Config.sEnvirDir + 'DisableMoveMap.txt';
  g_DisableMoveMapList.Lock;
  try
    g_DisableMoveMapList.SaveToFile(sFileName);
  finally
    g_DisableMoveMapList.UnLock;
  end;
  Result := True;
end;

function LoadAllowSellOffItem(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DisableSellOffItem.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_DisableSellOffList.Lock;
    try
      g_DisableSellOffList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        g_DisableSellOffList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_DisableSellOffList.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function SaveAllowSellOffItem(): Boolean;
var
  sFileName: string;
begin
  sFileName := g_Config.sEnvirDir + 'DisableSellOffItem.txt';
  g_DisableSellOffList.Lock;
  try
    g_DisableSellOffList.SaveToFile(sFileName);
  finally
    g_DisableSellOffList.UnLock;
  end;
  Result := True;
end;

function SaveChatLog(): Boolean;
var
  sFileName: string;
  LoadList: TStringList;
begin
  sFileName := '.\ChatLog.txt';

  if FileExists(sFileName) then
  begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    g_ChatLoggingList.AddStrings(LoadList);
    LoadList.Free;
  end else

    g_ChatLoggingList.Lock;
  try
    g_ChatLoggingList.SaveToFile(sFileName);
  finally
    g_ChatLoggingList.UnLock;
  end;
  Result := True;
end;



function GetUseItemIdx(sName: string): Integer;
begin
  Result := -1;
  if CompareText(sName, U_DRESSNAME) = 0 then
  begin
    Result := 0;
  end else
    if CompareText(sName, U_WEAPONNAME) = 0 then
    begin
      Result := 1;
    end else
      if CompareText(sName, U_RIGHTHANDNAME) = 0 then
      begin
        Result := 2;
      end else
        if CompareText(sName, U_NECKLACENAME) = 0 then
        begin
          Result := 3;
        end else
          if CompareText(sName, U_HELMETNAME) = 0 then
          begin
            Result := 4;
          end else
            if CompareText(sName, U_ARMRINGLNAME) = 0 then
            begin
              Result := 5;
            end else
              if CompareText(sName, U_ARMRINGRNAME) = 0 then
              begin
                Result := 6;
              end else
                if CompareText(sName, U_RINGLNAME) = 0 then
                begin
                  Result := 7;
                end else
                  if CompareText(sName, U_RINGRNAME) = 0 then
                  begin
                    Result := 8;
                    end else
                    if CompareText(sName, U_BUJUKNAME) = 0 then   //护身符
                    begin
                      Result := 9;
                 end;   //结束

//取消1.70增加的3个装备
{
                    end else
                      if CompareText(sName, U_BELTNAME) = 0 then
                      begin
                        Result := 10;
                      end else
                        if CompareText(sName, U_BOOTSNAME) = 0 then
                        begin
                          Result := 11;
                        end else
                          if CompareText(sName, U_CHARMNAME) = 0 then
                          begin
                            Result := 12;
                          end;
}                          

end;
function GetUseItemName(nIndex: Integer): string;

begin
  case nIndex of //
    0: Result := U_DRESSNAME;
    1: Result := U_WEAPONNAME;
    2: Result := U_RIGHTHANDNAME;
    3: Result := U_NECKLACENAME;
    4: Result := U_HELMETNAME;
    5: Result := U_ARMRINGLNAME;
    6: Result := U_ARMRINGRNAME;
    7: Result := U_RINGLNAME;
    8: Result := U_RINGRNAME;
    9: Result := U_BUJUKNAME;

//    10: Result := U_BELTNAME;
//    11: Result := U_BOOTSNAME;
//    12: Result := U_CHARMNAME;
  end;
end;


function LoadDisableSendMsgList(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DisableSendMsgList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_DisableSendMsgList.Clear;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do
    begin
      g_DisableSendMsgList.Add(Trim(LoadList.Strings[i]));
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function LoadMonDropLimitList(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sLineText: string;
  sFileName: string;
  sItemName, sItemCount: string;
  nItemCount: Integer;
  MonDrop: pTMonDrop;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'MonDropLimitList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_MonDropLimitLIst.Clear;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do
    begin
      sLineText := Trim(LoadList.Strings[i]);
      if (sLineText = '') or (sLineText[1] = ';') then Continue;
      sLineText := GetValidStr3(sLineText, sItemName, [' ', '/', ',', #9]);
      sLineText := GetValidStr3(sLineText, sItemCount, [' ', '/', ',', #9]);
      nItemCount := Str_ToInt(sItemCount, -1);
      if (sItemName <> '') and (nItemCount >= 0) then
      begin
        New(MonDrop);
        MonDrop.sItemName := sItemName;
        MonDrop.nDropCount := 0;
        MonDrop.nNoDropCount := 0;
        MonDrop.nCountLimit := nItemCount;
        g_MonDropLimitLIst.AddObject(sItemName, TObject(MonDrop));
      end;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;
function SaveMonDropLimitList(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
  sLineText: string;
  MonDrop: pTMonDrop;
begin
  sFileName := g_Config.sEnvirDir + 'MonDropLimitList.txt';
  LoadList := TStringList.Create;
  for i := 0 to g_MonDropLimitLIst.Count - 1 do
  begin
    MonDrop := pTMonDrop(g_MonDropLimitLIst.Objects[i]);
    sLineText := MonDrop.sItemName + #9 + IntToStr(MonDrop.nCountLimit);
    LoadList.Add(sLineText);
  end;
  LoadList.SaveToFile(sFileName);
  LoadList.Free;
  Result := True;
end;

function LoadDisableTakeOffList(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sLineText: string;
  sFileName: string;
  sItemName, sItemIdx: string;
  nItemIdx: Integer;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DisableTakeOffList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    LoadList.LoadFromFile(sFileName);
    g_DisableTakeOffList.Lock;
    try
      g_DisableTakeOffList.Clear;
      for i := 0 to LoadList.Count - 1 do
      begin
        sLineText := Trim(LoadList.Strings[i]);
        if (sLineText = '') or (sLineText[1] = ';') then Continue;
        sLineText := GetValidStr3(sLineText, sItemName, [' ', '/', ',', #9]);
        sLineText := GetValidStr3(sLineText, sItemIdx, [' ', '/', ',', #9]);
        nItemIdx := Str_ToInt(sItemIdx, -1);
        if (sItemName <> '') and (nItemIdx >= 0) then
        begin
          g_DisableTakeOffList.AddObject(sItemName, TObject(nItemIdx));
        end;
      end;
    finally
      g_DisableTakeOffList.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function SaveDisableTakeOffList(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
  sLineText: string;
begin
  sFileName := g_Config.sEnvirDir + 'DisableTakeOffList.txt';
  LoadList := TStringList.Create;
  g_DisableTakeOffList.Lock;
  try
    for i := 0 to g_DisableTakeOffList.Count - 1 do
    begin
      sLineText := g_DisableTakeOffList.Strings[i] + #9 + IntToStr(Integer(g_DisableTakeOffList.Objects[i]));
      LoadList.Add(sLineText);
    end;
  finally
    g_DisableTakeOffList.UnLock;
  end;
  LoadList.SaveToFile(sFileName);
  LoadList.Free;
  Result := True;
end;
function InDisableTakeOffList(nItemIdx: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  g_DisableTakeOffList.Lock;
  try
    for i := 0 to g_DisableTakeOffList.Count - 1 do
    begin
      if Integer(g_DisableTakeOffList.Objects[i]) = nItemIdx - 1 then
      begin
        Result := True;
        Break;
      end;
    end;
  finally
    g_DisableTakeOffList.UnLock;
  end;
end;

function SaveDisableSendMsgList(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
begin
  sFileName := g_Config.sEnvirDir + 'DisableSendMsgList.txt';
  LoadList := TStringList.Create;
  for i := 0 to g_DisableSendMsgList.Count - 1 do
  begin
    LoadList.Add(g_DisableSendMsgList.Strings[i]);
  end;
  LoadList.SaveToFile(sFileName);
  LoadList.Free;
  Result := True;
end;
function GetDisableSendMsgList(sHumanName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to g_DisableSendMsgList.Count - 1 do
  begin
    if CompareText(sHumanName, g_DisableSendMsgList.Strings[i]) = 0 then
    begin
      Result := True;
      Break;
    end;
  end;
end;
function LoadGameLogItemNameList(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'GameLogItemNameList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_GameLogItemNameList.Lock;
    try
      g_GameLogItemNameList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        g_GameLogItemNameList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_GameLogItemNameList.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function GetGameLogItemNameList(sItemName: string): Byte;
var
  i: Integer;
begin
  Result := 0;
  g_GameLogItemNameList.Lock;
  try
    for i := 0 to g_GameLogItemNameList.Count - 1 do
    begin
      if CompareText(sItemName, g_GameLogItemNameList.Strings[i]) = 0 then
      begin
        Result := 1;
        Break;
      end;
    end;
  finally
    g_GameLogItemNameList.UnLock;
  end;
end;

function SaveGameLogItemNameList(): Boolean;
var
  sFileName: string;
begin
  sFileName := g_Config.sEnvirDir + 'GameLogItemNameList.txt';
  g_GameLogItemNameList.Lock;
  try
    g_GameLogItemNameList.SaveToFile(sFileName);
  finally
    g_GameLogItemNameList.UnLock;
  end;
  Result := True;
end;
function LoadDenyIPAddrList(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DenyIPAddrList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_DenyIPAddrList.Lock;
    try
      g_DenyIPAddrList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        g_DenyIPAddrList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_DenyIPAddrList.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;
function GetDenyIPaddrList(sIPaddr: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  g_DenyIPAddrList.Lock;
  try
    for i := 0 to g_DenyIPAddrList.Count - 1 do
    begin
      if CompareText(sIPaddr, g_DenyIPAddrList.Strings[i]) = 0 then
      begin
        Result := True;
        Break;
      end;
    end;
  finally
    g_DenyIPAddrList.UnLock;
  end;
end;
function SaveDenyIPAddrList(): Boolean;
var
  i: Integer;
  sFileName: string;
  SaveList: TStringList;
begin
  sFileName := g_Config.sEnvirDir + 'DenyIPAddrList.txt';
  SaveList := TStringList.Create;
  g_DenyIPAddrList.Lock;
  try
    for i := 0 to g_DenyIPAddrList.Count - 1 do
    begin
      if Integer(g_DenyIPAddrList.Objects[i]) <> 0 then
      begin
        SaveList.Add(g_DenyIPAddrList.Strings[i]);
      end;
    end;
    SaveList.SaveToFile(sFileName);
  finally
    g_DenyIPAddrList.UnLock;
  end;
  SaveList.Free;
  Result := True;
end;

function LoadDenyChrNameList(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DenyChrNameList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_DenyChrNameList.Lock;
    try
      g_DenyChrNameList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        g_DenyChrNameList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_DenyChrNameList.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;
function GetDenyChrNameList(sChrName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  g_DenyChrNameList.Lock;
  try
    for i := 0 to g_DenyChrNameList.Count - 1 do
    begin
      if CompareText(sChrName, g_DenyChrNameList.Strings[i]) = 0 then
      begin
        Result := True;
        Break;
      end;
    end;
  finally
    g_DenyChrNameList.UnLock;
  end;
end;
function SaveDenyChrNameList(): Boolean;
var
  i: Integer;
  sFileName: string;
  SaveList: TStringList;
begin
  sFileName := g_Config.sEnvirDir + 'DenyChrNameList.txt';
  SaveList := TStringList.Create;
  g_DenyChrNameList.Lock;
  try
    for i := 0 to g_DenyChrNameList.Count - 1 do
    begin
      if Integer(g_DenyChrNameList.Objects[i]) <> 0 then
      begin
        SaveList.Add(g_DenyChrNameList.Strings[i]);
      end;
    end;
    SaveList.SaveToFile(sFileName);
  finally
    g_DenyChrNameList.UnLock;
  end;
  SaveList.Free;
  Result := True;
end;
function LoadDenyAccountList(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DenyAccountList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_DenyAccountList.Lock;
    try
      g_DenyAccountList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        g_DenyAccountList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_DenyAccountList.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;
function GetDenyAccountList(sAccount: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  g_DenyAccountList.Lock;
  try
    for i := 0 to g_DenyAccountList.Count - 1 do
    begin
      if CompareText(sAccount, g_DenyAccountList.Strings[i]) = 0 then
      begin
        Result := True;
        Break;
      end;
    end;
  finally
    g_DenyAccountList.UnLock;
  end;
end;
function SaveDenyAccountList(): Boolean;
var
  i: Integer;
  sFileName: string;
  SaveList: TStringList;
begin
  sFileName := g_Config.sEnvirDir + 'DenyAccountList.txt';
  SaveList := TStringList.Create;
  g_DenyAccountList.Lock;
  try
    for i := 0 to g_DenyAccountList.Count - 1 do
    begin
      if Integer(g_DenyAccountList.Objects[i]) <> 0 then
      begin
        SaveList.Add(g_DenyAccountList.Strings[i]);
      end;
    end;
    SaveList.SaveToFile(sFileName);
  finally
    g_DenyAccountList.UnLock;
  end;
  SaveList.Free;
  Result := True;
end;

function LoadNoClearMonList(): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'NoClearMonList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    g_NoClearMonList.Lock;
    try
      g_NoClearMonList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        g_NoClearMonList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_NoClearMonList.UnLock;
    end;
    Result := True;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function GetNoClearMonList(sMonName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  g_NoClearMonList.Lock;
  try
    for i := 0 to g_NoClearMonList.Count - 1 do
    begin
      if CompareText(sMonName, g_NoClearMonList.Strings[i]) = 0 then
      begin
        Result := True;
        Break;
      end;
    end;
  finally
    g_NoClearMonList.UnLock;
  end;
end;
function SaveNoClearMonList(): Boolean;
var
  i: Integer;
  sFileName: string;
  SaveList: TStringList;
begin
  sFileName := g_Config.sEnvirDir + 'NoClearMonList.txt';
  SaveList := TStringList.Create;
  g_NoClearMonList.Lock;
  try
    for i := 0 to g_NoClearMonList.Count - 1 do
    begin
      SaveList.Add(g_NoClearMonList.Strings[i]);
    end;
    SaveList.SaveToFile(sFileName);
  finally
    g_NoClearMonList.UnLock;
  end;
  SaveList.Free;
  Result := True;
end;

function LoadMonSayMsg(): Boolean;
var
  i, ii: Integer;
  sStatus, sRate, sColor, sMonName, sSayMsg: string;
  nStatus, nRate, nColor: Integer;
  LoadList: TStringList;
  sLineText: string;
  MonSayMsg: pTMonSayMsg;
  sFileName: string;
  MonSayList: TList;
  boSearch: Boolean;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'GenMsg.txt';
  if FileExists(sFileName) then
  begin
    g_MonSayMsgList.Clear;
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do
    begin
      sLineText := Trim(LoadList.Strings[i]);
      if (sLineText <> '') and (sLineText[1] < ';') then
      begin
        sLineText := GetValidStr3(sLineText, sStatus, [' ', '/', ',', #9]);
        sLineText := GetValidStr3(sLineText, sRate, [' ', '/', ',', #9]);
        sLineText := GetValidStr3(sLineText, sColor, [' ', '/', ',', #9]);
        sLineText := GetValidStr3(sLineText, sMonName, [' ', '/', ',', #9]);
        sLineText := GetValidStr3(sLineText, sSayMsg, [' ', '/', ',', #9]);
        if (sStatus <> '') and (sRate <> '') and (sColor <> '') and (sMonName <> '') and (sSayMsg <> '') then
        begin
          nStatus := Str_ToInt(sStatus, -1);
          nRate := Str_ToInt(sRate, -1);
          nColor := Str_ToInt(sColor, -1);
          if (nStatus >= 0) and (nRate >= 0) and (nColor >= 0) then
          begin
            New(MonSayMsg);
            case nStatus of
              0: MonSayMsg.State := s_KillHuman;
              1: MonSayMsg.State := s_UnderFire;
              2: MonSayMsg.State := s_Die;
              3: MonSayMsg.State := s_MonGen;
            else MonSayMsg.State := s_UnderFire;
            end;
            case nColor of
              0: MonSayMsg.Color := c_Red;
              1: MonSayMsg.Color := c_Green;
              2: MonSayMsg.Color := c_Blue;
              3: MonSayMsg.Color := c_White;
            else MonSayMsg.Color := c_White;
            end;
            MonSayMsg.nRate := nRate;
            MonSayMsg.sSayMsg := sSayMsg;
            boSearch := False;
            for ii := 0 to g_MonSayMsgList.Count - 1 do
            begin
              if CompareText(g_MonSayMsgList.Strings[ii], sMonName) = 0 then
              begin
                TList(g_MonSayMsgList.Objects[ii]).Add(MonSayMsg);
                boSearch := True;
                Break;
              end;
            end;
            if not boSearch then
            begin
              MonSayList := TList.Create;
              MonSayList.Add(MonSayMsg);
              g_MonSayMsgList.AddObject(sMonName, TObject(MonSayList));
            end;
          end;
        end;
      end;
    end;
    LoadList.Free;
    Result := True;
  end;
end;
procedure LoadExp();
var
  i: Integer;
  LoadInteger: Integer;
  LoadString: string;
begin
  LoadInteger := ExpConf.ReadInteger('Exp', 'KillMonExpMultiple', -1);
  if LoadInteger < 0 then
  begin
    ExpConf.WriteInteger('Exp', 'KillMonExpMultiple', g_Config.dwKillMonExpMultiple);
  end else
  begin
    g_Config.dwKillMonExpMultiple := ExpConf.ReadInteger('Exp', 'KillMonExpMultiple', g_Config.dwKillMonExpMultiple);
  end;

  LoadInteger := ExpConf.ReadInteger('Exp', 'HighLevelKillMonFixExp', -1);
  if LoadInteger < 0 then
  begin
    ExpConf.WriteBool('Exp', 'HighLevelKillMonFixExp', g_Config.boHighLevelKillMonFixExp);
  end else
  begin
    g_Config.boHighLevelKillMonFixExp := ExpConf.ReadBool('Exp', 'HighLevelKillMonFixExp', g_Config.boHighLevelKillMonFixExp);
  end;

  for i := 1 to High(g_Config.dwNeedExps) do
  begin
    LoadString := ExpConf.ReadString('Exp', 'Level' + IntToStr(i), '');
    LoadInteger := Str_ToInt(LoadString, 0);
    if LoadInteger = 0 then
    begin
      ExpConf.WriteString('Exp', 'Level' + IntToStr(i), IntToStr(g_dwOldNeedExps[i]));
      g_Config.dwNeedExps[i] := g_dwOldNeedExps[i];
    end else
    begin
      g_Config.dwNeedExps[i] := LoadInteger;
    end;
  end;
{$IF OEMVER = OEM775}
  for i := 1 to High(g_LevelInfo) do
  begin
    LoadInteger := Level775.ReadInteger('HP', 'HP' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('HP', 'HP' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wHP := Level775.ReadInteger('HP', 'HP' + IntToStr(i), g_LevelInfo[i].wHP);
    end;

    LoadInteger := Level775.ReadInteger('MP', 'MP' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('MP', 'MP' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wMP := Level775.ReadInteger('MP', 'MP' + IntToStr(i), g_LevelInfo[i].wMP);
    end;

    LoadString := Level775.ReadString('Exp', 'Exp' + IntToStr(i), '');
    LoadInteger := Str_ToInt(LoadString, 0);
    if LoadInteger = 0 then
    begin
      Level775.WriteString('Exp', 'Exp' + IntToStr(i), '1000');
      g_LevelInfo[i].dwExp := g_dwOldNeedExps[i];
    end else
    begin
      g_LevelInfo[i].dwExp := LoadInteger;
    end;

    LoadInteger := Level775.ReadInteger('AC', 'AC' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('AC', 'AC' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wAC := Level775.ReadInteger('AC', 'AC' + IntToStr(i), g_LevelInfo[i].wAC);
    end;

    LoadInteger := Level775.ReadInteger('MaxAC', 'MaxAC' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('MaxAC', 'MaxAC' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wMaxAC := Level775.ReadInteger('MaxAC', 'MaxAC' + IntToStr(i), g_LevelInfo[i].wMaxAC);
    end;
    LoadInteger := Level775.ReadInteger('ACLimit', 'ACLimit' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('ACLimit', 'ACLimit' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wACLimit := Level775.ReadInteger('ACLimit', 'ACLimit' + IntToStr(i), g_LevelInfo[i].wACLimit);
    end;

    LoadInteger := Level775.ReadInteger('MAC', 'MAC' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('MAC', 'MAC' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wMAC := Level775.ReadInteger('MAC', 'MAC' + IntToStr(i), g_LevelInfo[i].wMAC);
    end;

    LoadInteger := Level775.ReadInteger('MaxMAC', 'MaxMAC' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('MaxMAC', 'MaxMAC' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wMaxMAC := Level775.ReadInteger('MaxMAC', 'MaxMAC' + IntToStr(i), g_LevelInfo[i].wMaxMAC);
    end;
    LoadInteger := Level775.ReadInteger('MACLimit', 'MACLimit' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('MACLimit', 'MACLimit' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wMACLimit := Level775.ReadInteger('MACLimit', 'MACLimit' + IntToStr(i), g_LevelInfo[i].wMACLimit);
    end;

    LoadInteger := Level775.ReadInteger('DC', 'DC' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('DC', 'DC' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wDC := Level775.ReadInteger('DC', 'DC' + IntToStr(i), g_LevelInfo[i].wDC);
    end;

    LoadInteger := Level775.ReadInteger('MaxDC', 'MaxDC' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('MaxDC', 'MaxDC' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wMaxDC := Level775.ReadInteger('MaxDC', 'MaxDC' + IntToStr(i), g_LevelInfo[i].wMaxDC);
    end;
    LoadInteger := Level775.ReadInteger('DCLimit', 'DCLimit' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('DCLimit', 'DCLimit' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wDCLimit := Level775.ReadInteger('DCLimit', 'DCLimit' + IntToStr(i), g_LevelInfo[i].wDCLimit);
    end;

    LoadInteger := Level775.ReadInteger('MC', 'MC' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('MC', 'MC' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wMC := Level775.ReadInteger('MC', 'MC' + IntToStr(i), g_LevelInfo[i].wMC);
    end;

    LoadInteger := Level775.ReadInteger('MaxMC', 'MaxMC' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('MaxMC', 'MaxMC' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wMaxMC := Level775.ReadInteger('MaxMC', 'MaxMC' + IntToStr(i), g_LevelInfo[i].wMaxMC);
    end;
    LoadInteger := Level775.ReadInteger('MCLimit', 'MCLimit' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('MCLimit', 'MCLimit' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wMCLimit := Level775.ReadInteger('MCLimit', 'MCLimit' + IntToStr(i), g_LevelInfo[i].wMCLimit);
    end;

    LoadInteger := Level775.ReadInteger('SC', 'SC' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('SC', 'SC' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wSC := Level775.ReadInteger('SC', 'SC' + IntToStr(i), g_LevelInfo[i].wSC);
    end;

    LoadInteger := Level775.ReadInteger('MaxSC', 'MaxSC' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('MaxSC', 'MaxSC' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wMaxSC := Level775.ReadInteger('MaxSC', 'MaxSC' + IntToStr(i), g_LevelInfo[i].wMaxSC);
    end;
    LoadInteger := Level775.ReadInteger('SCLimit', 'SCLimit' + IntToStr(i), -1);
    if LoadInteger < 0 then
    begin
      Level775.WriteInteger('SCLimit', 'SCLimit' + IntToStr(i), 100);
    end else
    begin
      g_LevelInfo[i].wSCLimit := Level775.ReadInteger('SCLimit', 'SCLimit' + IntToStr(i), g_LevelInfo[i].wSCLimit);
    end;
  end;
{$IFEND}
end;
procedure LoadGameCommand();
var
  LoadString: string;
  nLoadInteger: Integer;
begin
  LoadString := CommandConf.ReadString('Command', 'Date', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Date', g_GameCommand.Data.sCmd)
  else g_GameCommand.Data.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'Date', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Date', g_GameCommand.Data.nPermissionMin)
  else g_GameCommand.Data.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'PrvMsg', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'PrvMsg', g_GameCommand.PRVMSG.sCmd)
  else g_GameCommand.PRVMSG.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'PrvMsg', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'PrvMsg', g_GameCommand.PRVMSG.nPermissionMin)
  else g_GameCommand.PRVMSG.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AllowMsg', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AllowMsg', g_GameCommand.ALLOWMSG.sCmd)
  else g_GameCommand.ALLOWMSG.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'AllowMsg', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AllowMsg', g_GameCommand.ALLOWMSG.nPermissionMin)
  else g_GameCommand.ALLOWMSG.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'LetShout', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'LetShout', g_GameCommand.LETSHOUT.sCmd)
  else g_GameCommand.LETSHOUT.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'LetTrade', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'LetTrade', g_GameCommand.LETTRADE.sCmd)
  else g_GameCommand.LETTRADE.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'LetGuild', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'LetGuild', g_GameCommand.LETGUILD.sCmd)
  else g_GameCommand.LETGUILD.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'EndGuild', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'EndGuild', g_GameCommand.ENDGUILD.sCmd)
  else g_GameCommand.ENDGUILD.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'BanGuildChat', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'BanGuildChat', g_GameCommand.BANGUILDCHAT.sCmd)
  else g_GameCommand.BANGUILDCHAT.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'AuthAlly', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AuthAlly', g_GameCommand.AUTHALLY.sCmd)
  else g_GameCommand.AUTHALLY.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'Auth', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Auth', g_GameCommand.AUTH.sCmd)
  else g_GameCommand.AUTH.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'AuthCancel', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AuthCancel', g_GameCommand.AUTHCANCEL.sCmd)
  else g_GameCommand.AUTHCANCEL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'ViewDiary', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ViewDiary', g_GameCommand.DIARY.sCmd)
  else g_GameCommand.DIARY.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'UserMove', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'UserMove', g_GameCommand.USERMOVE.sCmd)
  else g_GameCommand.USERMOVE.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'Searching', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Searching', g_GameCommand.SEARCHING.sCmd)
  else g_GameCommand.SEARCHING.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'AllowGroupCall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AllowGroupCall', g_GameCommand.ALLOWGROUPCALL.sCmd)
  else g_GameCommand.ALLOWGROUPCALL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'GroupCall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'GroupCall', g_GameCommand.GROUPRECALLL.sCmd)
  else g_GameCommand.GROUPRECALLL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'AllowGuildReCall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AllowGuildReCall', g_GameCommand.ALLOWGUILDRECALL.sCmd)
  else g_GameCommand.ALLOWGUILDRECALL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'GuildReCall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'GuildReCall', g_GameCommand.GUILDRECALLL.sCmd)
  else g_GameCommand.GUILDRECALLL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'StorageUnLock', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StorageUnLock', g_GameCommand.UNLOCKSTORAGE.sCmd)
  else g_GameCommand.UNLOCKSTORAGE.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'PasswordUnLock', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'PasswordUnLock', g_GameCommand.UnLock.sCmd)
  else g_GameCommand.UnLock.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'StorageLock', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StorageLock', g_GameCommand.Lock.sCmd)
  else g_GameCommand.Lock.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'StorageSetPassword', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StorageSetPassword', g_GameCommand.SETPASSWORD.sCmd)
  else g_GameCommand.SETPASSWORD.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'PasswordLock', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'PasswordLock', g_GameCommand.PASSWORDLOCK.sCmd)
  else g_GameCommand.PASSWORDLOCK.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'StorageChgPassword', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StorageChgPassword', g_GameCommand.CHGPASSWORD.sCmd)
  else g_GameCommand.CHGPASSWORD.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'StorageClearPassword', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StorageClearPassword', g_GameCommand.CLRPASSWORD.sCmd)
  else g_GameCommand.CLRPASSWORD.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'StorageClearPassword', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'StorageClearPassword', g_GameCommand.CLRPASSWORD.nPermissionMin)
  else g_GameCommand.CLRPASSWORD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'StorageUserClearPassword', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StorageUserClearPassword', g_GameCommand.UNPASSWORD.sCmd)
  else g_GameCommand.UNPASSWORD.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'MemberFunc', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MemberFunc', g_GameCommand.MEMBERFUNCTION.sCmd)
  else g_GameCommand.MEMBERFUNCTION.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'MemberFuncEx', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MemberFuncEx', g_GameCommand.MEMBERFUNCTIONEX.sCmd)
  else g_GameCommand.MEMBERFUNCTIONEX.sCmd := LoadString;

//取消 结婚 与 师徒 的相关内容  
{
  LoadString := CommandConf.ReadString('Command', 'Dear', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Dear', g_GameCommand.DEAR.sCmd)
  else g_GameCommand.DEAR.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'Master', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Master', g_GameCommand.MASTER.sCmd)
  else g_GameCommand.MASTER.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'DearRecall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DearRecall', g_GameCommand.DEARRECALL.sCmd)
  else g_GameCommand.DEARRECALL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'MasterRecall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MasterRecall', g_GameCommand.MASTERECALL.sCmd)
  else g_GameCommand.MASTERECALL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'AllowDearRecall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AllowDearRecall', g_GameCommand.ALLOWDEARRCALL.sCmd)
  else g_GameCommand.ALLOWDEARRCALL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'AllowMasterRecall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AllowMasterRecall', g_GameCommand.ALLOWMASTERRECALL.sCmd)
  else g_GameCommand.ALLOWMASTERRECALL.sCmd := LoadString;

 }


  LoadString := CommandConf.ReadString('Command', 'AttackMode', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AttackMode', g_GameCommand.ATTACKMODE.sCmd)
  else g_GameCommand.ATTACKMODE.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'Rest', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Rest', g_GameCommand.REST.sCmd)
  else g_GameCommand.REST.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'TakeOnHorse', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'TakeOnHorse', g_GameCommand.TAKEONHORSE.sCmd)
  else g_GameCommand.TAKEONHORSE.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'TakeOffHorse', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'TakeOffHorse', g_GameCommand.TAKEOFHORSE.sCmd)
  else g_GameCommand.TAKEOFHORSE.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'HumanLocal', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'HumanLocal', g_GameCommand.HUMANLOCAL.sCmd)
  else g_GameCommand.HUMANLOCAL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'HumanLocal', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'HumanLocal', g_GameCommand.HUMANLOCAL.nPermissionMin)
  else g_GameCommand.HUMANLOCAL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Move', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Move', g_GameCommand.Move.sCmd)
  else g_GameCommand.Move.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MoveMin', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MoveMin', g_GameCommand.Move.nPermissionMin)
  else g_GameCommand.Move.nPermissionMin := nLoadInteger;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MoveMax', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MoveMax', g_GameCommand.Move.nPermissionMax)
  else g_GameCommand.Move.nPermissionMax := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'PositionMove', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'PositionMove', g_GameCommand.POSITIONMOVE.sCmd)
  else g_GameCommand.POSITIONMOVE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'PositionMoveMin', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'PositionMoveMin', g_GameCommand.POSITIONMOVE.nPermissionMin)
  else g_GameCommand.POSITIONMOVE.nPermissionMin := nLoadInteger;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'PositionMoveMax', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'PositionMoveMax', g_GameCommand.POSITIONMOVE.nPermissionMax)
  else g_GameCommand.POSITIONMOVE.nPermissionMax := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Info', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Info', g_GameCommand.INFO.sCmd)
  else g_GameCommand.INFO.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Info', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Info', g_GameCommand.INFO.nPermissionMin)
  else g_GameCommand.INFO.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'MobLevel', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MobLevel', g_GameCommand.MOBLEVEL.sCmd)
  else g_GameCommand.MOBLEVEL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MobLevel', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MobLevel', g_GameCommand.MOBLEVEL.nPermissionMin)
  else g_GameCommand.MOBLEVEL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'MobCount', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MobCount', g_GameCommand.MOBCOUNT.sCmd)
  else g_GameCommand.MOBCOUNT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MobCount', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MobCount', g_GameCommand.MOBCOUNT.nPermissionMin)
  else g_GameCommand.MOBCOUNT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'HumanCount', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'HumanCount', g_GameCommand.HUMANCOUNT.sCmd)
  else g_GameCommand.HUMANCOUNT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'HumanCount', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'HumanCount', g_GameCommand.HUMANCOUNT.nPermissionMin)
  else g_GameCommand.HUMANCOUNT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Map', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Map', g_GameCommand.Map.sCmd)
  else g_GameCommand.Map.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Map', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Map', g_GameCommand.Map.nPermissionMin)
  else g_GameCommand.Map.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Kick', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Kick', g_GameCommand.KICK.sCmd)
  else g_GameCommand.KICK.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Kick', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Kick', g_GameCommand.KICK.nPermissionMin)
  else g_GameCommand.KICK.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Ting', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Ting', g_GameCommand.TING.sCmd)
  else g_GameCommand.TING.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Ting', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Ting', g_GameCommand.TING.nPermissionMin)
  else g_GameCommand.TING.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SuperTing', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SuperTing', g_GameCommand.SUPERTING.sCmd)
  else g_GameCommand.SUPERTING.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SuperTing', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SuperTing', g_GameCommand.SUPERTING.nPermissionMin)
  else g_GameCommand.SUPERTING.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'MapMove', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MapMove', g_GameCommand.MAPMOVE.sCmd)
  else g_GameCommand.MAPMOVE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MapMove', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MapMove', g_GameCommand.MAPMOVE.nPermissionMin)
  else g_GameCommand.MAPMOVE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Shutup', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Shutup', g_GameCommand.SHUTUP.sCmd)
  else g_GameCommand.SHUTUP.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Shutup', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Shutup', g_GameCommand.SHUTUP.nPermissionMin)
  else g_GameCommand.SHUTUP.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReleaseShutup', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReleaseShutup', g_GameCommand.RELEASESHUTUP.sCmd)
  else g_GameCommand.RELEASESHUTUP.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReleaseShutup', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReleaseShutup', g_GameCommand.RELEASESHUTUP.nPermissionMin)
  else g_GameCommand.RELEASESHUTUP.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ShutupList', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ShutupList', g_GameCommand.SHUTUPLIST.sCmd)
  else g_GameCommand.SHUTUPLIST.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ShutupList', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ShutupList', g_GameCommand.SHUTUPLIST.nPermissionMin)
  else g_GameCommand.SHUTUPLIST.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'GameMaster', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'GameMaster', g_GameCommand.GAMEMASTER.sCmd)
  else g_GameCommand.GAMEMASTER.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'GameMaster', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'GameMaster', g_GameCommand.GAMEMASTER.nPermissionMin)
  else g_GameCommand.GAMEMASTER.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ObServer', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ObServer', g_GameCommand.OBSERVER.sCmd)
  else g_GameCommand.OBSERVER.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ObServer', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ObServer', g_GameCommand.OBSERVER.nPermissionMin)
  else g_GameCommand.OBSERVER.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SuperMan', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SuperMan', g_GameCommand.SUEPRMAN.sCmd)
  else g_GameCommand.SUEPRMAN.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SuperMan', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SuperMan', g_GameCommand.SUEPRMAN.nPermissionMin)
  else g_GameCommand.SUEPRMAN.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Level', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Level', g_GameCommand.Level.sCmd)
  else g_GameCommand.Level.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Level', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Level', g_GameCommand.Level.nPermissionMin)
  else g_GameCommand.Level.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SabukWallGold', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SabukWallGold', g_GameCommand.SABUKWALLGOLD.sCmd)
  else g_GameCommand.SABUKWALLGOLD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SabukWallGold', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SabukWallGold', g_GameCommand.SABUKWALLGOLD.nPermissionMin)
  else g_GameCommand.SABUKWALLGOLD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Recall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Recall', g_GameCommand.RECALL.sCmd)
  else g_GameCommand.RECALL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Recall', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Recall', g_GameCommand.RECALL.nPermissionMin)
  else g_GameCommand.RECALL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReGoto', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReGoto', g_GameCommand.REGOTO.sCmd)
  else g_GameCommand.REGOTO.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReGoto', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReGoto', g_GameCommand.REGOTO.nPermissionMin)
  else g_GameCommand.REGOTO.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Flag', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Flag', g_GameCommand.SHOWFLAG.sCmd)
  else g_GameCommand.SHOWFLAG.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Flag', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Flag', g_GameCommand.SHOWFLAG.nPermissionMin)
  else g_GameCommand.SHOWFLAG.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ShowOpen', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ShowOpen', g_GameCommand.SHOWOPEN.sCmd)
  else g_GameCommand.SHOWOPEN.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ShowOpen', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ShowOpen', g_GameCommand.SHOWOPEN.nPermissionMin)
  else g_GameCommand.SHOWOPEN.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ShowUnit', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ShowUnit', g_GameCommand.SHOWUNIT.sCmd)
  else g_GameCommand.SHOWUNIT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ShowUnit', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ShowUnit', g_GameCommand.SHOWUNIT.nPermissionMin)
  else g_GameCommand.SHOWUNIT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Attack', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Attack', g_GameCommand.Attack.sCmd)
  else g_GameCommand.Attack.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Attack', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Attack', g_GameCommand.Attack.nPermissionMin)
  else g_GameCommand.Attack.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Mob', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Mob', g_GameCommand.MOB.sCmd)
  else g_GameCommand.MOB.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Mob', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Mob', g_GameCommand.MOB.nPermissionMin)
  else g_GameCommand.MOB.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'MobNpc', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MobNpc', g_GameCommand.MOBNPC.sCmd)
  else g_GameCommand.MOBNPC.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MobNpc', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MobNpc', g_GameCommand.MOBNPC.nPermissionMin)
  else g_GameCommand.MOBNPC.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelNpc', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelNpc', g_GameCommand.DELNPC.sCmd)
  else g_GameCommand.DELNPC.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelNpc', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelNpc', g_GameCommand.DELNPC.nPermissionMin)
  else g_GameCommand.DELNPC.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'NpcScript', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'NpcScript', g_GameCommand.NPCSCRIPT.sCmd)
  else g_GameCommand.NPCSCRIPT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'NpcScript', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'NpcScript', g_GameCommand.NPCSCRIPT.nPermissionMin)
  else g_GameCommand.NPCSCRIPT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'RecallMob', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'RecallMob', g_GameCommand.RECALLMOB.sCmd)
  else g_GameCommand.RECALLMOB.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'RecallMob', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'RecallMob', g_GameCommand.RECALLMOB.nPermissionMin)
  else g_GameCommand.RECALLMOB.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'LuckPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'LuckPoint', g_GameCommand.LUCKYPOINT.sCmd)
  else g_GameCommand.LUCKYPOINT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'LuckPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'LuckPoint', g_GameCommand.LUCKYPOINT.nPermissionMin)
  else g_GameCommand.LUCKYPOINT.nPermissionMin := nLoadInteger;

//取消彩票功能
//  LoadString := CommandConf.ReadString('Command', 'LotteryTicket', '');
//  if LoadString = '' then
//    CommandConf.WriteString('Command', 'LotteryTicket', g_GameCommand.LOTTERYTICKET.sCmd)
//  else g_GameCommand.LOTTERYTICKET.sCmd := LoadString;
//  nLoadInteger := CommandConf.ReadInteger('Permission', 'LotteryTicket', -1);
//  if nLoadInteger < 0 then
//    CommandConf.WriteInteger('Permission', 'LotteryTicket', g_GameCommand.LOTTERYTICKET.nPermissionMin)
//  else g_GameCommand.LOTTERYTICKET.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadGuild', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadGuild', g_GameCommand.RELOADGUILD.sCmd)
  else g_GameCommand.RELOADGUILD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadGuild', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadGuild', g_GameCommand.RELOADGUILD.nPermissionMin)
  else g_GameCommand.RELOADGUILD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadLineNotice', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadLineNotice', g_GameCommand.RELOADLINENOTICE.sCmd)
  else g_GameCommand.RELOADLINENOTICE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadLineNotice', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadLineNotice', g_GameCommand.RELOADLINENOTICE.nPermissionMin)
  else g_GameCommand.RELOADLINENOTICE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadAbuse', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadAbuse', g_GameCommand.RELOADABUSE.sCmd)
  else g_GameCommand.RELOADABUSE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadAbuse', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadAbuse', g_GameCommand.RELOADABUSE.nPermissionMin)
  else g_GameCommand.RELOADABUSE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'BackStep', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'BackStep', g_GameCommand.BACKSTEP.sCmd)
  else g_GameCommand.BACKSTEP.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'BackStep', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'BackStep', g_GameCommand.BACKSTEP.nPermissionMin)
  else g_GameCommand.BACKSTEP.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Ball', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Ball', g_GameCommand.BALL.sCmd)
  else g_GameCommand.BALL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Ball', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Ball', g_GameCommand.BALL.nPermissionMin)
  else g_GameCommand.BALL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'FreePenalty', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'FreePenalty', g_GameCommand.FREEPENALTY.sCmd)
  else g_GameCommand.FREEPENALTY.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'FreePenalty', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'FreePenalty', g_GameCommand.FREEPENALTY.nPermissionMin)
  else g_GameCommand.FREEPENALTY.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'PkPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'PkPoint', g_GameCommand.PKPOINT.sCmd)
  else g_GameCommand.PKPOINT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'PkPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'PkPoint', g_GameCommand.PKPOINT.nPermissionMin)
  else g_GameCommand.PKPOINT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'IncPkPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'IncPkPoint', g_GameCommand.IncPkPoint.sCmd)
  else g_GameCommand.IncPkPoint.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'IncPkPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'IncPkPoint', g_GameCommand.IncPkPoint.nPermissionMin)
  else g_GameCommand.IncPkPoint.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeLuck', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeLuck', g_GameCommand.CHANGELUCK.sCmd)
  else g_GameCommand.CHANGELUCK.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeLuck', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeLuck', g_GameCommand.CHANGELUCK.nPermissionMin)
  else g_GameCommand.CHANGELUCK.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Hunger', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Hunger', g_GameCommand.HUNGER.sCmd)
  else g_GameCommand.HUNGER.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Hunger', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Hunger', g_GameCommand.HUNGER.nPermissionMin)
  else g_GameCommand.HUNGER.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Hair', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Hair', g_GameCommand.HAIR.sCmd)
  else g_GameCommand.HAIR.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Hair', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Hair', g_GameCommand.HAIR.nPermissionMin)
  else g_GameCommand.HAIR.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Training', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Training', g_GameCommand.TRAINING.sCmd)
  else g_GameCommand.TRAINING.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Training', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Training', g_GameCommand.TRAINING.nPermissionMin)
  else g_GameCommand.TRAINING.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DeleteSkill', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DeleteSkill', g_GameCommand.DELETESKILL.sCmd)
  else g_GameCommand.DELETESKILL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DeleteSkill', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DeleteSkill', g_GameCommand.DELETESKILL.nPermissionMin)
  else g_GameCommand.DELETESKILL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeJob', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeJob', g_GameCommand.CHANGEJOB.sCmd)
  else g_GameCommand.CHANGEJOB.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeJob', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeJob', g_GameCommand.CHANGEJOB.nPermissionMin)
  else g_GameCommand.CHANGEJOB.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeGender', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeGender', g_GameCommand.CHANGEGENDER.sCmd)
  else g_GameCommand.CHANGEGENDER.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeGender', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeGender', g_GameCommand.CHANGEGENDER.nPermissionMin)
  else g_GameCommand.CHANGEGENDER.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'NameColor', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'NameColor', g_GameCommand.NAMECOLOR.sCmd)
  else g_GameCommand.NAMECOLOR.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'NameColor', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'NameColor', g_GameCommand.NAMECOLOR.nPermissionMin)
  else g_GameCommand.NAMECOLOR.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Mission', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Mission', g_GameCommand.Mission.sCmd)
  else g_GameCommand.Mission.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Mission', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Mission', g_GameCommand.Mission.nPermissionMin)
  else g_GameCommand.Mission.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'MobPlace', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MobPlace', g_GameCommand.MobPlace.sCmd)
  else g_GameCommand.MobPlace.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MobPlace', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MobPlace', g_GameCommand.MobPlace.nPermissionMin)
  else g_GameCommand.MobPlace.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Transparecy', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Transparecy', g_GameCommand.TRANSPARECY.sCmd)
  else g_GameCommand.TRANSPARECY.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Transparecy', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Transparecy', g_GameCommand.TRANSPARECY.nPermissionMin)
  else g_GameCommand.TRANSPARECY.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DeleteItem', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DeleteItem', g_GameCommand.DELETEITEM.sCmd)
  else g_GameCommand.DELETEITEM.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DeleteItem', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DeleteItem', g_GameCommand.DELETEITEM.nPermissionMin)
  else g_GameCommand.DELETEITEM.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Level0', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Level0', g_GameCommand.LEVEL0.sCmd)
  else g_GameCommand.LEVEL0.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Level0', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Level0', g_GameCommand.LEVEL0.nPermissionMin)
  else g_GameCommand.LEVEL0.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ClearMission', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ClearMission', g_GameCommand.CLEARMISSION.sCmd)
  else g_GameCommand.CLEARMISSION.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ClearMission', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ClearMission', g_GameCommand.CLEARMISSION.nPermissionMin)
  else g_GameCommand.CLEARMISSION.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SetFlag', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SetFlag', g_GameCommand.SETFLAG.sCmd)
  else g_GameCommand.SETFLAG.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SetFlag', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SetFlag', g_GameCommand.SETFLAG.nPermissionMin)
  else g_GameCommand.SETFLAG.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SetOpen', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SetOpen', g_GameCommand.SETOPEN.sCmd)
  else g_GameCommand.SETOPEN.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SetOpen', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SetOpen', g_GameCommand.SETOPEN.nPermissionMin)
  else g_GameCommand.SETOPEN.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SetUnit', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SetUnit', g_GameCommand.SETUNIT.sCmd)
  else g_GameCommand.SETUNIT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SetUnit', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SetUnit', g_GameCommand.SETUNIT.nPermissionMin)
  else g_GameCommand.SETUNIT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReConnection', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReConnection', g_GameCommand.RECONNECTION.sCmd)
  else g_GameCommand.RECONNECTION.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReConnection', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReConnection', g_GameCommand.RECONNECTION.nPermissionMin)
  else g_GameCommand.RECONNECTION.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DisableFilter', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DisableFilter', g_GameCommand.DISABLEFILTER.sCmd)
  else g_GameCommand.DISABLEFILTER.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DisableFilter', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DisableFilter', g_GameCommand.DISABLEFILTER.nPermissionMin)
  else g_GameCommand.DISABLEFILTER.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeUserFull', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeUserFull', g_GameCommand.CHGUSERFULL.sCmd)
  else g_GameCommand.CHGUSERFULL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeUserFull', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeUserFull', g_GameCommand.CHGUSERFULL.nPermissionMin)
  else g_GameCommand.CHGUSERFULL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeZenFastStep', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeZenFastStep', g_GameCommand.CHGZENFASTSTEP.sCmd)
  else g_GameCommand.CHGZENFASTSTEP.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeZenFastStep', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeZenFastStep', g_GameCommand.CHGZENFASTSTEP.nPermissionMin)
  else g_GameCommand.CHGZENFASTSTEP.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ContestPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ContestPoint', g_GameCommand.CONTESTPOINT.sCmd)
  else g_GameCommand.CONTESTPOINT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ContestPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ContestPoint', g_GameCommand.CONTESTPOINT.nPermissionMin)
  else g_GameCommand.CONTESTPOINT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'StartContest', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StartContest', g_GameCommand.STARTCONTEST.sCmd)
  else g_GameCommand.STARTCONTEST.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'StartContest', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'StartContest', g_GameCommand.STARTCONTEST.nPermissionMin)
  else g_GameCommand.STARTCONTEST.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'EndContest', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'EndContest', g_GameCommand.ENDCONTEST.sCmd)
  else g_GameCommand.ENDCONTEST.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'EndContest', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'EndContest', g_GameCommand.ENDCONTEST.nPermissionMin)
  else g_GameCommand.ENDCONTEST.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Announcement', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Announcement', g_GameCommand.ANNOUNCEMENT.sCmd)
  else g_GameCommand.ANNOUNCEMENT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Announcement', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Announcement', g_GameCommand.ANNOUNCEMENT.nPermissionMin)
  else g_GameCommand.ANNOUNCEMENT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'OXQuizRoom', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'OXQuizRoom', g_GameCommand.OXQUIZROOM.sCmd)
  else g_GameCommand.OXQUIZROOM.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'OXQuizRoom', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'OXQuizRoom', g_GameCommand.OXQUIZROOM.nPermissionMin)
  else g_GameCommand.OXQUIZROOM.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Gsa', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Gsa', g_GameCommand.GSA.sCmd)
  else g_GameCommand.GSA.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Gsa', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Gsa', g_GameCommand.GSA.nPermissionMin)
  else g_GameCommand.GSA.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeItemName', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeItemName', g_GameCommand.CHANGEITEMNAME.sCmd)
  else g_GameCommand.CHANGEITEMNAME.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeItemName', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeItemName', g_GameCommand.CHANGEITEMNAME.nPermissionMin)
  else g_GameCommand.CHANGEITEMNAME.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DisableSendMsg', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DisableSendMsg', g_GameCommand.DISABLESENDMSG.sCmd)
  else g_GameCommand.DISABLESENDMSG.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DisableSendMsg', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DisableSendMsg', g_GameCommand.DISABLESENDMSG.nPermissionMin)
  else g_GameCommand.DISABLESENDMSG.nPermissionMin := nLoadInteger;


  LoadString := CommandConf.ReadString('Command', 'EnableSendMsg', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'EnableSendMsg', g_GameCommand.ENABLESENDMSG.sCmd)
  else g_GameCommand.ENABLESENDMSG.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'EnableSendMsg', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'EnableSendMsg', g_GameCommand.ENABLESENDMSG.nPermissionMin)
  else g_GameCommand.ENABLESENDMSG.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DisableSendMsgList', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DisableSendMsgList', g_GameCommand.DISABLESENDMSGLIST.sCmd)
  else g_GameCommand.DISABLESENDMSGLIST.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DisableSendMsgList', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DisableSendMsgList', g_GameCommand.DISABLESENDMSGLIST.nPermissionMin)
  else g_GameCommand.DISABLESENDMSGLIST.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Kill', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Kill', g_GameCommand.KILL.sCmd)
  else g_GameCommand.KILL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Kill', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Kill', g_GameCommand.KILL.nPermissionMin)
  else g_GameCommand.KILL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Make', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Make', g_GameCommand.MAKE.sCmd)
  else g_GameCommand.MAKE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MakeMin', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MakeMin', g_GameCommand.MAKE.nPermissionMin)
  else g_GameCommand.MAKE.nPermissionMin := nLoadInteger;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'MakeMax', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MakeMax', g_GameCommand.MAKE.nPermissionMax)
  else g_GameCommand.MAKE.nPermissionMax := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SuperMake', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SuperMake', g_GameCommand.SMAKE.sCmd)
  else g_GameCommand.SMAKE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SuperMake', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SuperMake', g_GameCommand.SMAKE.nPermissionMin)
  else g_GameCommand.SMAKE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'BonusPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'BonusPoint', g_GameCommand.BonusPoint.sCmd)
  else g_GameCommand.BonusPoint.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'BonusPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'BonusPoint', g_GameCommand.BonusPoint.nPermissionMin)
  else g_GameCommand.BonusPoint.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelBonuPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelBonuPoint', g_GameCommand.DELBONUSPOINT.sCmd)
  else g_GameCommand.DELBONUSPOINT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelBonuPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelBonuPoint', g_GameCommand.DELBONUSPOINT.nPermissionMin)
  else g_GameCommand.DELBONUSPOINT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'RestBonuPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'RestBonuPoint', g_GameCommand.RESTBONUSPOINT.sCmd)
  else g_GameCommand.RESTBONUSPOINT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'RestBonuPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'RestBonuPoint', g_GameCommand.RESTBONUSPOINT.nPermissionMin)
  else g_GameCommand.RESTBONUSPOINT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'FireBurn', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'FireBurn', g_GameCommand.FIREBURN.sCmd)
  else g_GameCommand.FIREBURN.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'FireBurn', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'FireBurn', g_GameCommand.FIREBURN.nPermissionMin)
  else g_GameCommand.FIREBURN.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'TestStatus', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'TestStatus', g_GameCommand.TESTSTATUS.sCmd)
  else g_GameCommand.TESTSTATUS.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'TestStatus', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'TestStatus', g_GameCommand.TESTSTATUS.nPermissionMin)
  else g_GameCommand.TESTSTATUS.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelGold', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelGold', g_GameCommand.DELGOLD.sCmd)
  else g_GameCommand.DELGOLD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelGold', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelGold', g_GameCommand.DELGOLD.nPermissionMin)
  else g_GameCommand.DELGOLD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AddGold', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AddGold', g_GameCommand.ADDGOLD.sCmd)
  else g_GameCommand.ADDGOLD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AddGold', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AddGold', g_GameCommand.ADDGOLD.nPermissionMin)
  else g_GameCommand.ADDGOLD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelGameGold', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelGameGold', g_GameCommand.DELGAMEGOLD.sCmd)
  else g_GameCommand.DELGAMEGOLD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelGameGold', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelGameGold', g_GameCommand.DELGAMEGOLD.nPermissionMin)
  else g_GameCommand.DELGAMEGOLD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AddGamePoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AddGamePoint', g_GameCommand.ADDGAMEGOLD.sCmd)
  else g_GameCommand.ADDGAMEGOLD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AddGameGold', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AddGameGold', g_GameCommand.ADDGAMEGOLD.nPermissionMin)
  else g_GameCommand.ADDGAMEGOLD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'GameGold', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'GameGold', g_GameCommand.GAMEGOLD.sCmd)
  else g_GameCommand.GAMEGOLD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'GameGold', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'GameGold', g_GameCommand.GAMEGOLD.nPermissionMin)
  else g_GameCommand.GAMEGOLD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'GamePoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'GamePoint', g_GameCommand.GAMEPOINT.sCmd)
  else g_GameCommand.GAMEPOINT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'GamePoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'GamePoint', g_GameCommand.GAMEPOINT.nPermissionMin)
  else g_GameCommand.GAMEPOINT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'CreditPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'CreditPoint', g_GameCommand.CREDITPOINT.sCmd)
  else g_GameCommand.CREDITPOINT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'CreditPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'CreditPoint', g_GameCommand.CREDITPOINT.nPermissionMin)
  else g_GameCommand.CREDITPOINT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'TestGoldChange', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'TestGoldChange', g_GameCommand.TESTGOLDCHANGE.sCmd)
  else g_GameCommand.TESTGOLDCHANGE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'TestGoldChange', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'TestGoldChange', g_GameCommand.TESTGOLDCHANGE.nPermissionMin)
  else g_GameCommand.TESTGOLDCHANGE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'RefineWeapon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'RefineWeapon', g_GameCommand.REFINEWEAPON.sCmd)
  else g_GameCommand.REFINEWEAPON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'RefineWeapon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'RefineWeapon', g_GameCommand.REFINEWEAPON.nPermissionMin)
  else g_GameCommand.REFINEWEAPON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadAdmin', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadAdmin', g_GameCommand.RELOADADMIN.sCmd)
  else g_GameCommand.RELOADADMIN.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadAdmin', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadAdmin', g_GameCommand.RELOADADMIN.nPermissionMin)
  else g_GameCommand.RELOADADMIN.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadNpc', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadNpc', g_GameCommand.ReLoadNpc.sCmd)
  else g_GameCommand.ReLoadNpc.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadNpc', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadNpc', g_GameCommand.ReLoadNpc.nPermissionMin)
  else g_GameCommand.ReLoadNpc.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadManage', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadManage', g_GameCommand.RELOADMANAGE.sCmd)
  else g_GameCommand.RELOADMANAGE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadManage', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadManage', g_GameCommand.RELOADMANAGE.nPermissionMin)
  else g_GameCommand.RELOADMANAGE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadRobotManage', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadRobotManage', g_GameCommand.RELOADROBOTMANAGE.sCmd)
  else g_GameCommand.RELOADROBOTMANAGE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadRobotManage', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadRobotManage', g_GameCommand.RELOADROBOTMANAGE.nPermissionMin)
  else g_GameCommand.RELOADROBOTMANAGE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadRobot', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadRobot', g_GameCommand.RELOADROBOT.sCmd)
  else g_GameCommand.RELOADROBOT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadRobot', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadRobot', g_GameCommand.RELOADROBOT.nPermissionMin)
  else g_GameCommand.RELOADROBOT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadMonitems', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadMonitems', g_GameCommand.RELOADMONITEMS.sCmd)
  else g_GameCommand.RELOADMONITEMS.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadMonitems', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadMonitems', g_GameCommand.RELOADMONITEMS.nPermissionMin)
  else g_GameCommand.RELOADMONITEMS.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadDiary', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadDiary', g_GameCommand.RELOADDIARY.sCmd)
  else g_GameCommand.RELOADDIARY.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadDiary', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadDiary', g_GameCommand.RELOADDIARY.nPermissionMin)
  else g_GameCommand.RELOADDIARY.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadItemDB', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadItemDB', g_GameCommand.RELOADITEMDB.sCmd)
  else g_GameCommand.RELOADITEMDB.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadItemDB', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadItemDB', g_GameCommand.RELOADITEMDB.nPermissionMin)
  else g_GameCommand.RELOADITEMDB.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadMagicDB', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadMagicDB', g_GameCommand.RELOADMAGICDB.sCmd)
  else g_GameCommand.RELOADMAGICDB.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadMagicDB', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadMagicDB', g_GameCommand.RELOADMAGICDB.nPermissionMin)
  else g_GameCommand.RELOADMAGICDB.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadMonsterDB', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadMonsterDB', g_GameCommand.RELOADMONSTERDB.sCmd)
  else g_GameCommand.RELOADMONSTERDB.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadMonsterDB', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadMonsterDB', g_GameCommand.RELOADMONSTERDB.nPermissionMin)
  else g_GameCommand.RELOADMONSTERDB.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReAlive', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReAlive', g_GameCommand.ReAlive.sCmd)
  else g_GameCommand.ReAlive.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReAlive', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReAlive', g_GameCommand.ReAlive.nPermissionMin)
  else g_GameCommand.ReAlive.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AdjuestTLevel', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AdjuestTLevel', g_GameCommand.ADJUESTLEVEL.sCmd)
  else g_GameCommand.ADJUESTLEVEL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AdjuestTLevel', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AdjuestTLevel', g_GameCommand.ADJUESTLEVEL.nPermissionMin)
  else g_GameCommand.ADJUESTLEVEL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AdjuestExp', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AdjuestExp', g_GameCommand.ADJUESTEXP.sCmd)
  else g_GameCommand.ADJUESTEXP.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AdjuestExp', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AdjuestExp', g_GameCommand.ADJUESTEXP.nPermissionMin)
  else g_GameCommand.ADJUESTEXP.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AddGuild', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AddGuild', g_GameCommand.AddGuild.sCmd)
  else g_GameCommand.AddGuild.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AddGuild', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AddGuild', g_GameCommand.AddGuild.nPermissionMin)
  else g_GameCommand.AddGuild.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelGuild', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelGuild', g_GameCommand.DELGUILD.sCmd)
  else g_GameCommand.DELGUILD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelGuild', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelGuild', g_GameCommand.DELGUILD.nPermissionMin)
  else g_GameCommand.DELGUILD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeSabukLord', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeSabukLord', g_GameCommand.CHANGESABUKLORD.sCmd)
  else g_GameCommand.CHANGESABUKLORD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeSabukLord', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeSabukLord', g_GameCommand.CHANGESABUKLORD.nPermissionMin)
  else g_GameCommand.CHANGESABUKLORD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ForcedWallConQuestWar', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ForcedWallConQuestWar', g_GameCommand.FORCEDWALLCONQUESTWAR.sCmd)
  else g_GameCommand.FORCEDWALLCONQUESTWAR.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ForcedWallConQuestWar', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ForcedWallConQuestWar', g_GameCommand.FORCEDWALLCONQUESTWAR.nPermissionMin)
  else g_GameCommand.FORCEDWALLCONQUESTWAR.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AddToItemEvent', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AddToItemEvent', g_GameCommand.ADDTOITEMEVENT.sCmd)
  else g_GameCommand.ADDTOITEMEVENT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AddToItemEvent', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AddToItemEvent', g_GameCommand.ADDTOITEMEVENT.nPermissionMin)
  else g_GameCommand.ADDTOITEMEVENT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AddToItemEventAspieces', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AddToItemEventAspieces', g_GameCommand.ADDTOITEMEVENTASPIECES.sCmd)
  else g_GameCommand.ADDTOITEMEVENTASPIECES.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AddToItemEventAspieces', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AddToItemEventAspieces', g_GameCommand.ADDTOITEMEVENTASPIECES.nPermissionMin)
  else g_GameCommand.ADDTOITEMEVENTASPIECES.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ItemEventList', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ItemEventList', g_GameCommand.ItemEventList.sCmd)
  else g_GameCommand.ItemEventList.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ItemEventList', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ItemEventList', g_GameCommand.ItemEventList.nPermissionMin)
  else g_GameCommand.ItemEventList.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'StartIngGiftNO', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StartIngGiftNO', g_GameCommand.STARTINGGIFTNO.sCmd)
  else g_GameCommand.STARTINGGIFTNO.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'StartIngGiftNO', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'StartIngGiftNO', g_GameCommand.STARTINGGIFTNO.nPermissionMin)
  else g_GameCommand.STARTINGGIFTNO.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DeleteAllItemEvent', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DeleteAllItemEvent', g_GameCommand.DELETEALLITEMEVENT.sCmd)
  else g_GameCommand.DELETEALLITEMEVENT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DeleteAllItemEvent', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DeleteAllItemEvent', g_GameCommand.DELETEALLITEMEVENT.nPermissionMin)
  else g_GameCommand.DELETEALLITEMEVENT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'StartItemEvent', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StartItemEvent', g_GameCommand.STARTITEMEVENT.sCmd)
  else g_GameCommand.STARTITEMEVENT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'StartItemEvent', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'StartItemEvent', g_GameCommand.STARTITEMEVENT.nPermissionMin)
  else g_GameCommand.STARTITEMEVENT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ItemEventTerm', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ItemEventTerm', g_GameCommand.ITEMEVENTTERM.sCmd)
  else g_GameCommand.ITEMEVENTTERM.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ItemEventTerm', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ItemEventTerm', g_GameCommand.ITEMEVENTTERM.nPermissionMin)
  else g_GameCommand.ITEMEVENTTERM.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AdjuestTestLevel', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AdjuestTestLevel', g_GameCommand.ADJUESTTESTLEVEL.sCmd)
  else g_GameCommand.ADJUESTTESTLEVEL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AdjuestTestLevel', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AdjuestTestLevel', g_GameCommand.ADJUESTTESTLEVEL.nPermissionMin)
  else g_GameCommand.ADJUESTTESTLEVEL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'OpTraining', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'OpTraining', g_GameCommand.TRAININGSKILL.sCmd)
  else g_GameCommand.TRAININGSKILL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'OpTraining', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'OpTraining', g_GameCommand.TRAININGSKILL.nPermissionMin)
  else g_GameCommand.TRAININGSKILL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'OpDeleteSkill', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'OpDeleteSkill', g_GameCommand.OPDELETESKILL.sCmd)
  else g_GameCommand.OPDELETESKILL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'OpDeleteSkill', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'OpDeleteSkill', g_GameCommand.OPDELETESKILL.nPermissionMin)
  else g_GameCommand.OPDELETESKILL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeWeaponDura', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeWeaponDura', g_GameCommand.CHANGEWEAPONDURA.sCmd)
  else g_GameCommand.CHANGEWEAPONDURA.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeWeaponDura', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeWeaponDura', g_GameCommand.CHANGEWEAPONDURA.nPermissionMin)
  else g_GameCommand.CHANGEWEAPONDURA.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadGuildAll', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadGuildAll', g_GameCommand.RELOADGUILDALL.sCmd)
  else g_GameCommand.RELOADGUILDALL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadGuildAll', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadGuildAll', g_GameCommand.RELOADGUILDALL.nPermissionMin)
  else g_GameCommand.RELOADGUILDALL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Who', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Who', g_GameCommand.WHO.sCmd)
  else g_GameCommand.WHO.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'Who', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Who', g_GameCommand.WHO.nPermissionMin)
  else g_GameCommand.WHO.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Total', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Total', g_GameCommand.TOTAL.sCmd)
  else g_GameCommand.TOTAL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Total', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Total', g_GameCommand.TOTAL.nPermissionMin)
  else g_GameCommand.TOTAL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'TestGa', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'TestGa', g_GameCommand.TESTGA.sCmd)
  else g_GameCommand.TESTGA.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'TestGa', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'TestGa', g_GameCommand.TESTGA.nPermissionMin)
  else g_GameCommand.TESTGA.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'MapInfo', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MapInfo', g_GameCommand.MAPINFO.sCmd)
  else g_GameCommand.MAPINFO.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MapInfo', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MapInfo', g_GameCommand.MAPINFO.nPermissionMin)
  else g_GameCommand.MAPINFO.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SbkDoor', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SbkDoor', g_GameCommand.SBKDOOR.sCmd)
  else g_GameCommand.SBKDOOR.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SbkDoor', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SbkDoor', g_GameCommand.SBKDOOR.nPermissionMin)
  else g_GameCommand.SBKDOOR.nPermissionMin := nLoadInteger;

// 取消 结婚 与 师徒 的相关内容
{
  LoadString := CommandConf.ReadString('Command', 'ChangeDearName', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeDearName', g_GameCommand.CHANGEDEARNAME.sCmd)
  else g_GameCommand.CHANGEDEARNAME.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeDearName', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeDearName', g_GameCommand.CHANGEDEARNAME.nPermissionMin)
  else g_GameCommand.CHANGEDEARNAME.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeMasterName', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeMasterrName', g_GameCommand.CHANGEMASTERNAME.sCmd)
  else g_GameCommand.CHANGEMASTERNAME.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeMasterName', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeMasterName', g_GameCommand.CHANGEMASTERNAME.nPermissionMin)
  else g_GameCommand.CHANGEMASTERNAME.nPermissionMin := nLoadInteger;
}

  LoadString := CommandConf.ReadString('Command', 'StartQuest', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StartQuest', g_GameCommand.STARTQUEST.sCmd)
  else g_GameCommand.STARTQUEST.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'StartQuest', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'StartQuest', g_GameCommand.STARTQUEST.nPermissionMin)
  else g_GameCommand.STARTQUEST.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SetPermission', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SetPermission', g_GameCommand.SETPERMISSION.sCmd)
  else g_GameCommand.SETPERMISSION.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SetPermission', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SetPermission', g_GameCommand.SETPERMISSION.nPermissionMin)
  else g_GameCommand.SETPERMISSION.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ClearMon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ClearMon', g_GameCommand.CLEARMON.sCmd)
  else g_GameCommand.CLEARMON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ClearMon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ClearMon', g_GameCommand.CLEARMON.nPermissionMin)
  else g_GameCommand.CLEARMON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReNewLevel', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReNewLevel', g_GameCommand.RENEWLEVEL.sCmd)
  else g_GameCommand.RENEWLEVEL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReNewLevel', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReNewLevel', g_GameCommand.RENEWLEVEL.nPermissionMin)
  else g_GameCommand.RENEWLEVEL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DenyIPaddrLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DenyIPaddrLogon', g_GameCommand.DENYIPLOGON.sCmd)
  else g_GameCommand.DENYIPLOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DenyIPaddrLogon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DenyIPaddrLogon', g_GameCommand.DENYIPLOGON.nPermissionMin)
  else g_GameCommand.DENYIPLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DenyAccountLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DenyAccountLogon', g_GameCommand.DENYACCOUNTLOGON.sCmd)
  else g_GameCommand.DENYACCOUNTLOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DenyAccountLogon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DenyAccountLogon', g_GameCommand.DENYACCOUNTLOGON.nPermissionMin)
  else g_GameCommand.DENYACCOUNTLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DenyCharNameLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DenyCharNameLogon', g_GameCommand.DENYCHARNAMELOGON.sCmd)
  else g_GameCommand.DENYCHARNAMELOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DenyCharNameLogon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DenyCharNameLogon', g_GameCommand.DENYCHARNAMELOGON.nPermissionMin)
  else g_GameCommand.DENYCHARNAMELOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelDenyIPLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelDenyIPLogon', g_GameCommand.DELDENYIPLOGON.sCmd)
  else g_GameCommand.DELDENYIPLOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelDenyIPLogon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelDenyIPLogon', g_GameCommand.DELDENYIPLOGON.nPermissionMin)
  else g_GameCommand.DELDENYIPLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelDenyAccountLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelDenyAccountLogon', g_GameCommand.DELDENYACCOUNTLOGON.sCmd)
  else g_GameCommand.DELDENYACCOUNTLOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelDenyAccountLogon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelDenyAccountLogon', g_GameCommand.DELDENYACCOUNTLOGON.nPermissionMin)
  else g_GameCommand.DELDENYACCOUNTLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelDenyCharNameLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelDenyCharNameLogon', g_GameCommand.DELDENYCHARNAMELOGON.sCmd)
  else g_GameCommand.DELDENYCHARNAMELOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelDenyCharNameLogon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelDenyCharNameLogon', g_GameCommand.DELDENYCHARNAMELOGON.nPermissionMin)
  else g_GameCommand.DELDENYCHARNAMELOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ShowDenyIPLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ShowDenyIPLogon', g_GameCommand.SHOWDENYIPLOGON.sCmd)
  else g_GameCommand.SHOWDENYIPLOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ShowDenyIPLogon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ShowDenyIPLogon', g_GameCommand.SHOWDENYIPLOGON.nPermissionMin)
  else g_GameCommand.SHOWDENYIPLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ShowDenyAccountLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ShowDenyAccountLogon', g_GameCommand.SHOWDENYACCOUNTLOGON.sCmd)
  else g_GameCommand.SHOWDENYACCOUNTLOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ShowDenyAccountLogon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ShowDenyAccountLogon', g_GameCommand.SHOWDENYACCOUNTLOGON.nPermissionMin)
  else g_GameCommand.SHOWDENYACCOUNTLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ShowDenyCharNameLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ShowDenyCharNameLogon', g_GameCommand.SHOWDENYCHARNAMELOGON.sCmd)
  else g_GameCommand.SHOWDENYCHARNAMELOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ShowDenyCharNameLogon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ShowDenyCharNameLogon', g_GameCommand.SHOWDENYCHARNAMELOGON.nPermissionMin)
  else g_GameCommand.SHOWDENYCHARNAMELOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ViewWhisper', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ViewWhisper', g_GameCommand.VIEWWHISPER.sCmd)
  else g_GameCommand.VIEWWHISPER.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ViewWhisper', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ViewWhisper', g_GameCommand.VIEWWHISPER.nPermissionMin)
  else g_GameCommand.VIEWWHISPER.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SpiritStart', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SpiritStart', g_GameCommand.SPIRIT.sCmd)
  else g_GameCommand.SPIRIT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SpiritStart', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SpiritStart', g_GameCommand.SPIRIT.nPermissionMin)
  else g_GameCommand.SPIRIT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SpiritStop', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SpiritStop', g_GameCommand.SPIRITSTOP.sCmd)
  else g_GameCommand.SPIRITSTOP.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SpiritStop', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SpiritStop', g_GameCommand.SPIRITSTOP.nPermissionMin)
  else g_GameCommand.SPIRITSTOP.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SetMapMode', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SetMapMode', g_GameCommand.SetMapMode.sCmd)
  else g_GameCommand.SetMapMode.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SetMapMode', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SetMapMode', g_GameCommand.SetMapMode.nPermissionMin)
  else g_GameCommand.SetMapMode.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ShoweMapMode', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ShoweMapMode', g_GameCommand.SHOWMAPMODE.sCmd)
  else g_GameCommand.SHOWMAPMODE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ShoweMapMode', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ShoweMapMode', g_GameCommand.SHOWMAPMODE.nPermissionMin)
  else g_GameCommand.SHOWMAPMODE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ClearBag', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ClearBag', g_GameCommand.CLEARBAG.sCmd)
  else g_GameCommand.CLEARBAG.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ClearBag', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ClearBag', g_GameCommand.CLEARBAG.nPermissionMin)
  else g_GameCommand.CLEARBAG.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'LockLogin', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'LockLogin', g_GameCommand.LOCKLOGON.sCmd)
  else g_GameCommand.LOCKLOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'LockLogin', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'LockLogin', g_GameCommand.LOCKLOGON.nPermissionMin)
  else g_GameCommand.LOCKLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'GMRedMsgCmd', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'GMRedMsgCmd', g_GMRedMsgCmd)
  else g_GMRedMsgCmd := LoadString[1];
  nLoadInteger := CommandConf.ReadInteger('Permission', 'GMRedMsgCmd', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'GMRedMsgCmd', g_nGMREDMSGCMD)
  else g_nGMREDMSGCMD := nLoadInteger;
end;
procedure LoadString();
  function LoadConfigString(sSection, sIdent, sDefault: string): string;
  var
    sString: string;
  begin
    sString := StringConf.ReadString(sSection, sIdent, '');
    if sString = '' then
    begin
      StringConf.WriteString(sSection, sIdent, sDefault);
      Result := sDefault;
    end else
    begin
      Result := sString;
    end;
  end;
var
  LoadString: string;
begin
  LoadString := StringConf.ReadString('String', 'ClientSoftVersionError', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ClientSoftVersionError', sClientSoftVersionError)
  else sClientSoftVersionError := LoadString;

  LoadString := StringConf.ReadString('String', 'DownLoadNewClientSoft', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DownLoadNewClientSoft', sDownLoadNewClientSoft)
  else sDownLoadNewClientSoft := LoadString;

  LoadString := StringConf.ReadString('String', 'ForceDisConnect', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ForceDisConnect', sForceDisConnect)
  else sForceDisConnect := LoadString;

  LoadString := StringConf.ReadString('String', 'ClientSoftVersionTooOld', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ClientSoftVersionTooOld', sClientSoftVersionTooOld)
  else sClientSoftVersionTooOld := LoadString;

  LoadString := StringConf.ReadString('String', 'DownLoadAndUseNewClient', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DownLoadAndUseNewClient', sDownLoadAndUseNewClient)
  else sDownLoadAndUseNewClient := LoadString;

  LoadString := StringConf.ReadString('String', 'OnlineUserFull', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'OnlineUserFull', sOnlineUserFull)
  else sOnlineUserFull := LoadString;

  LoadString := StringConf.ReadString('String', 'YouNowIsTryPlayMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouNowIsTryPlayMode', sYouNowIsTryPlayMode)
  else sYouNowIsTryPlayMode := LoadString;

  LoadString := StringConf.ReadString('String', 'NowIsFreePlayMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NowIsFreePlayMode', g_sNowIsFreePlayMode)
  else g_sNowIsFreePlayMode := LoadString;

  LoadString := StringConf.ReadString('String', 'AttackModeOfAll', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'AttackModeOfAll', sAttackModeOfAll)
  else sAttackModeOfAll := LoadString;

  LoadString := StringConf.ReadString('String', 'AttackModeOfPeaceful', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'AttackModeOfPeaceful', sAttackModeOfPeaceful)
  else sAttackModeOfPeaceful := LoadString;

  LoadString := StringConf.ReadString('String', 'AttackModeOfGroup', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'AttackModeOfGroup', sAttackModeOfGroup)
  else sAttackModeOfGroup := LoadString;

  LoadString := StringConf.ReadString('String', 'AttackModeOfGuild', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'AttackModeOfGuild', sAttackModeOfGuild)
  else sAttackModeOfGuild := LoadString;

  LoadString := StringConf.ReadString('String', 'AttackModeOfRedWhite', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'AttackModeOfRedWhite', sAttackModeOfRedWhite)
  else sAttackModeOfRedWhite := LoadString;

  LoadString := StringConf.ReadString('String', 'StartChangeAttackModeHelp', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StartChangeAttackModeHelp', sStartChangeAttackModeHelp)
  else sStartChangeAttackModeHelp := LoadString;

  LoadString := StringConf.ReadString('String', 'StartNoticeMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StartNoticeMsg', sStartNoticeMsg)
  else sStartNoticeMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ThrustingOn', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ThrustingOn', sThrustingOn)
  else sThrustingOn := LoadString;

  LoadString := StringConf.ReadString('String', 'ThrustingOff', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ThrustingOff', sThrustingOff)
  else sThrustingOff := LoadString;

  LoadString := StringConf.ReadString('String', 'HalfMoonOn', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'HalfMoonOn', sHalfMoonOn)
  else sHalfMoonOn := LoadString;

  LoadString := StringConf.ReadString('String', 'HalfMoonOff', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'HalfMoonOff', sHalfMoonOff)
  else sHalfMoonOff := LoadString;

  sCrsHitOn := LoadConfigString('String', 'CrsHitOn', sCrsHitOn);
  sCrsHitOff := LoadConfigString('String', 'CrsHitOff', sCrsHitOff);

  sTwinHitOn := LoadConfigString('String', 'TwinHitOn', sTwinHitOn);
  sTwinHitOff := LoadConfigString('String', 'TwinHitOff', sTwinHitOff);

  LoadString := StringConf.ReadString('String', 'FireSpiritsSummoned', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'FireSpiritsSummoned', sFireSpiritsSummoned)
  else sFireSpiritsSummoned := LoadString;

  LoadString := StringConf.ReadString('String', 'FireSpiritsFail', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'FireSpiritsFail', sFireSpiritsFail)
  else sFireSpiritsFail := LoadString;

  LoadString := StringConf.ReadString('String', 'SpiritsGone', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SpiritsGone', sSpiritsGone)
  else sSpiritsGone := LoadString;

  LoadString := StringConf.ReadString('String', 'MateDoTooweak', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MateDoTooweak', sMateDoTooweak)
  else sMateDoTooweak := LoadString;

  LoadString := StringConf.ReadString('String', 'TheWeaponBroke', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TheWeaponBroke', g_sTheWeaponBroke)
  else g_sTheWeaponBroke := LoadString;

  LoadString := StringConf.ReadString('String', 'TheWeaponRefineSuccessfull', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TheWeaponRefineSuccessfull', sTheWeaponRefineSuccessfull)
  else sTheWeaponRefineSuccessfull := LoadString;

  LoadString := StringConf.ReadString('String', 'YouPoisoned', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouPoisoned', sYouPoisoned)
  else sYouPoisoned := LoadString;

  LoadString := StringConf.ReadString('String', 'PetRest', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PetRest', sPetRest)
  else sPetRest := LoadString;

  LoadString := StringConf.ReadString('String', 'PetAttack', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PetAttack', sPetAttack)
  else sPetAttack := LoadString;

  LoadString := StringConf.ReadString('String', 'WearNotOfWoMan', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WearNotOfWoMan', sWearNotOfWoMan)
  else sWearNotOfWoMan := LoadString;

  LoadString := StringConf.ReadString('String', 'WearNotOfMan', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WearNotOfMan', sWearNotOfMan)
  else sWearNotOfMan := LoadString;

  LoadString := StringConf.ReadString('String', 'HandWeightNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'HandWeightNot', sHandWeightNot)
  else sHandWeightNot := LoadString;

  LoadString := StringConf.ReadString('String', 'WearWeightNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WearWeightNot', sWearWeightNot)
  else sWearWeightNot := LoadString;

  LoadString := StringConf.ReadString('String', 'ItemIsNotThisAccount', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ItemIsNotThisAccount', g_sItemIsNotThisAccount)
  else g_sItemIsNotThisAccount := LoadString;

  LoadString := StringConf.ReadString('String', 'ItemIsNotThisIPaddr', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ItemIsNotThisIPaddr', g_sItemIsNotThisIPaddr)
  else g_sItemIsNotThisIPaddr := LoadString;

  LoadString := StringConf.ReadString('String', 'ItemIsNotThisCharName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ItemIsNotThisCharName', g_sItemIsNotThisCharName)
  else g_sItemIsNotThisCharName := LoadString;

  LoadString := StringConf.ReadString('String', 'LevelNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'LevelNot', g_sLevelNot)
  else g_sLevelNot := LoadString;

  LoadString := StringConf.ReadString('String', 'JobOrLevelNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'JobOrLevelNot', g_sJobOrLevelNot)
  else g_sJobOrLevelNot := LoadString;

  LoadString := StringConf.ReadString('String', 'JobOrDCNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'JobOrDCNot', g_sJobOrDCNot)
  else g_sJobOrDCNot := LoadString;

  LoadString := StringConf.ReadString('String', 'JobOrMCNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'JobOrMCNot', g_sJobOrMCNot)
  else g_sJobOrMCNot := LoadString;

  LoadString := StringConf.ReadString('String', 'JobOrSCNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'JobOrSCNot', g_sJobOrSCNot)
  else g_sJobOrSCNot := LoadString;

  LoadString := StringConf.ReadString('String', 'DCNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DCNot', g_sDCNot)
  else g_sDCNot := LoadString;

  LoadString := StringConf.ReadString('String', 'MCNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MCNot', g_sMCNot)
  else g_sMCNot := LoadString;

  LoadString := StringConf.ReadString('String', 'SCNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SCNot', g_sSCNot)
  else g_sSCNot := LoadString;

  LoadString := StringConf.ReadString('String', 'CreditPointNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CreditPointNot', g_sCreditPointNot)
  else g_sCreditPointNot := LoadString;

  LoadString := StringConf.ReadString('String', 'ReNewLevelNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ReNewLevelNot', g_sReNewLevelNot)
  else g_sReNewLevelNot := LoadString;

  LoadString := StringConf.ReadString('String', 'GuildNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'GuildNot', g_sGuildNot)
  else g_sGuildNot := LoadString;

  LoadString := StringConf.ReadString('String', 'GuildMasterNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'GuildMasterNot', g_sGuildMasterNot)
  else g_sGuildMasterNot := LoadString;

  LoadString := StringConf.ReadString('String', 'SabukHumanNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SabukHumanNot', g_sSabukHumanNot)
  else g_sSabukHumanNot := LoadString;

  LoadString := StringConf.ReadString('String', 'SabukMasterManNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SabukMasterManNot', g_sSabukMasterManNot)
  else g_sSabukMasterManNot := LoadString;

  LoadString := StringConf.ReadString('String', 'MemberNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MemberNot', g_sMemberNot)
  else g_sMemberNot := LoadString;

  LoadString := StringConf.ReadString('String', 'MemberTypeNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MemberTypeNot', g_sMemberTypeNot)
  else g_sMemberTypeNot := LoadString;

  LoadString := StringConf.ReadString('String', 'CanottWearIt', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanottWearIt', g_sCanottWearIt)
  else g_sCanottWearIt := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotUseDrugOnThisMap', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotUseDrugOnThisMap', sCanotUseDrugOnThisMap)
  else sCanotUseDrugOnThisMap := LoadString;

  LoadString := StringConf.ReadString('String', 'GameMasterMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'GameMasterMode', sGameMasterMode)
  else sGameMasterMode := LoadString;

  LoadString := StringConf.ReadString('String', 'ReleaseGameMasterMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ReleaseGameMasterMode', sReleaseGameMasterMode)
  else sReleaseGameMasterMode := LoadString;

  LoadString := StringConf.ReadString('String', 'ObserverMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ObserverMode', sObserverMode)
  else sObserverMode := LoadString;

  LoadString := StringConf.ReadString('String', 'ReleaseObserverMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ReleaseObserverMode', g_sReleaseObserverMode)
  else g_sReleaseObserverMode := LoadString;

  LoadString := StringConf.ReadString('String', 'SupermanMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SupermanMode', sSupermanMode)
  else sSupermanMode := LoadString;

  LoadString := StringConf.ReadString('String', 'ReleaseSupermanMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ReleaseSupermanMode', sReleaseSupermanMode)
  else sReleaseSupermanMode := LoadString;

  LoadString := StringConf.ReadString('String', 'YouFoundNothing', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouFoundNothing', sYouFoundNothing)
  else sYouFoundNothing := LoadString;

  LoadString := StringConf.ReadString('String', 'LineNoticePreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'LineNoticePreFix', g_Config.sLineNoticePreFix)
  else g_Config.sLineNoticePreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'SysMsgPreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SysMsgPreFix', g_Config.sSysMsgPreFix)
  else g_Config.sSysMsgPreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'GuildMsgPreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'GuildMsgPreFix', g_Config.sGuildMsgPreFix)
  else g_Config.sGuildMsgPreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'GroupMsgPreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'GroupMsgPreFix', g_Config.sGroupMsgPreFix)
  else g_Config.sGroupMsgPreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'HintMsgPreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'HintMsgPreFix', g_Config.sHintMsgPreFix)
  else g_Config.sHintMsgPreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'GMRedMsgpreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'GMRedMsgpreFix', g_Config.sGMRedMsgpreFix)
  else g_Config.sGMRedMsgpreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'MonSayMsgpreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MonSayMsgpreFix', g_Config.sMonSayMsgpreFix)
  else g_Config.sMonSayMsgpreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'CustMsgpreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CustMsgpreFix', g_Config.sCustMsgpreFix)
  else g_Config.sCustMsgpreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'CastleMsgpreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CastleMsgpreFix', g_Config.sCastleMsgpreFix)
  else g_Config.sCastleMsgpreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'NoPasswordLockSystemMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NoPasswordLockSystemMsg', g_sNoPasswordLockSystemMsg)
  else g_sNoPasswordLockSystemMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'AlreadySetPassword', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'AlreadySetPassword', g_sAlreadySetPasswordMsg)
  else g_sAlreadySetPasswordMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ReSetPassword', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ReSetPassword', g_sReSetPasswordMsg)
  else g_sReSetPasswordMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PasswordOverLong', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PasswordOverLong', g_sPasswordOverLongMsg)
  else g_sPasswordOverLongMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ReSetPasswordOK', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ReSetPasswordOK', g_sReSetPasswordOKMsg)
  else g_sReSetPasswordOKMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ReSetPasswordNotMatch', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ReSetPasswordNotMatch', g_sReSetPasswordNotMatchMsg)
  else g_sReSetPasswordNotMatchMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PleaseInputUnLockPassword', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PleaseInputUnLockPassword', g_sPleaseInputUnLockPasswordMsg)
  else g_sPleaseInputUnLockPasswordMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StorageUnLockOK', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StorageUnLockOK', g_sStorageUnLockOKMsg)
  else g_sStorageUnLockOKMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StorageAlreadyUnLock', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StorageAlreadyUnLock', g_sStorageAlreadyUnLockMsg)
  else g_sStorageAlreadyUnLockMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StorageNoPassword', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StorageNoPassword', g_sStorageNoPasswordMsg)
  else g_sStorageNoPasswordMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'UnLockPasswordFail', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'UnLockPasswordFail', g_sUnLockPasswordFailMsg)
  else g_sUnLockPasswordFailMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'LockStorageSuccess', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'LockStorageSuccess', g_sLockStorageSuccessMsg)
  else g_sLockStorageSuccessMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StoragePasswordClearMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StoragePasswordClearMsg', g_sStoragePasswordClearMsg)
  else g_sStoragePasswordClearMsg := LoadString;
  LoadString := StringConf.ReadString('String', 'PleaseUnloadStoragePasswordMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PleaseUnloadStoragePasswordMsg', g_sPleaseUnloadStoragePasswordMsg)
  else g_sPleaseUnloadStoragePasswordMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StorageAlreadyLock', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StorageAlreadyLock', g_sStorageAlreadyLockMsg)
  else g_sStorageAlreadyLockMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StoragePasswordLocked', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StoragePasswordLocked', g_sStoragePasswordLockedMsg)
  else g_sStoragePasswordLockedMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StorageSetPassword', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StorageSetPassword', g_sSetPasswordMsg)
  else g_sSetPasswordMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PleaseInputOldPassword', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PleaseInputOldPassword', g_sPleaseInputOldPasswordMsg)
  else g_sPleaseInputOldPasswordMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PasswordIsClearMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PasswordIsClearMsg', g_sOldPasswordIsClearMsg)
  else g_sOldPasswordIsClearMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'NoPasswordSet', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NoPasswordSet', g_sNoPasswordSetMsg)
  else g_sNoPasswordSetMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'OldPasswordIncorrect', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'OldPasswordIncorrect', g_sOldPasswordIncorrectMsg)
  else g_sOldPasswordIncorrectMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StorageIsLocked', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StorageIsLocked', g_sStorageIsLockedMsg)
  else g_sStorageIsLockedMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PleaseTryDealLaterMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PleaseTryDealLaterMsg', g_sPleaseTryDealLaterMsg)
  else g_sPleaseTryDealLaterMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'DealItemsDenyGetBackMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DealItemsDenyGetBackMsg', g_sDealItemsDenyGetBackMsg)
  else g_sDealItemsDenyGetBackMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableDealItemsMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableDealItemsMsg', g_sDisableDealItemsMsg)
  else g_sDisableDealItemsMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotTryDealMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotTryDealMsg', g_sCanotTryDealMsg)
  else g_sCanotTryDealMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'DealActionCancelMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DealActionCancelMsg', g_sDealActionCancelMsg)
  else g_sDealActionCancelMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PoseDisableDealMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PoseDisableDealMsg', g_sPoseDisableDealMsg)
  else g_sPoseDisableDealMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'DealSuccessMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DealSuccessMsg', g_sDealSuccessMsg)
  else g_sDealSuccessMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'DealOKTooFast', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DealOKTooFast', g_sDealOKTooFast)
  else g_sDealOKTooFast := LoadString;

  LoadString := StringConf.ReadString('String', 'YourBagSizeTooSmall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourBagSizeTooSmall', g_sYourBagSizeTooSmall)
  else g_sYourBagSizeTooSmall := LoadString;

  LoadString := StringConf.ReadString('String', 'DealHumanBagSizeTooSmall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DealHumanBagSizeTooSmall', g_sDealHumanBagSizeTooSmall)
  else g_sDealHumanBagSizeTooSmall := LoadString;

  LoadString := StringConf.ReadString('String', 'YourGoldLargeThenLimit', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourGoldLargeThenLimit', g_sYourGoldLargeThenLimit)
  else g_sYourGoldLargeThenLimit := LoadString;

  LoadString := StringConf.ReadString('String', 'DealHumanGoldLargeThenLimit', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DealHumanGoldLargeThenLimit', g_sDealHumanGoldLargeThenLimit)
  else g_sDealHumanGoldLargeThenLimit := LoadString;

  LoadString := StringConf.ReadString('String', 'YouDealOKMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouDealOKMsg', g_sYouDealOKMsg)
  else g_sYouDealOKMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PoseDealOKMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PoseDealOKMsg', g_sPoseDealOKMsg)
  else g_sPoseDealOKMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'KickClientUserMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'KickClientUserMsg', g_sKickClientUserMsg)
  else g_sKickClientUserMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ActionIsLockedMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ActionIsLockedMsg', g_sActionIsLockedMsg)
  else g_sActionIsLockedMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PasswordNotSetMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PasswordNotSetMsg', g_sPasswordNotSetMsg)
  else g_sPasswordNotSetMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'NotPasswordProtectMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NotPasswordProtectMode', g_sNotPasswordProtectMode)
  else g_sNotPasswordProtectMode := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotDropGoldMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotDropGoldMsg', g_sCanotDropGoldMsg)
  else g_sCanotDropGoldMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotDropInSafeZoneMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotDropInSafeZoneMsg', g_sCanotDropInSafeZoneMsg)
  else g_sCanotDropInSafeZoneMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotDropItemMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotDropItemMsg', g_sCanotDropItemMsg)
  else g_sCanotDropItemMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotDropItemMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotDropItemMsg', g_sCanotDropItemMsg)
  else g_sCanotDropItemMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotUseItemMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotUseItemMsg', g_sCanotUseItemMsg)
  else g_sCanotUseItemMsg := LoadString;

//取消结婚 与 师徒系统的 相关功能  
{  
  LoadString := StringConf.ReadString('String', 'StartMarryManMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StartMarryManMsg', g_sStartMarryManMsg)
  else g_sStartMarryManMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StartMarryWoManMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StartMarryWoManMsg', g_sStartMarryWoManMsg)
  else g_sStartMarryWoManMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StartMarryManAskQuestionMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StartMarryManAskQuestionMsg', g_sStartMarryManAskQuestionMsg)
  else g_sStartMarryManAskQuestionMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StartMarryWoManAskQuestionMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StartMarryWoManAskQuestionMsg', g_sStartMarryWoManAskQuestionMsg)
  else g_sStartMarryWoManAskQuestionMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MarryManAnswerQuestionMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MarryManAnswerQuestionMsg', g_sMarryManAnswerQuestionMsg)
  else g_sMarryManAnswerQuestionMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MarryManAskQuestionMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MarryManAskQuestionMsg', g_sMarryManAskQuestionMsg)
  else g_sMarryManAskQuestionMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MarryWoManAnswerQuestionMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MarryWoManAnswerQuestionMsg', g_sMarryWoManAnswerQuestionMsg)
  else g_sMarryWoManAnswerQuestionMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MarryWoManGetMarryMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MarryWoManGetMarryMsg', g_sMarryWoManGetMarryMsg)
  else g_sMarryWoManGetMarryMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MarryWoManDenyMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MarryWoManDenyMsg', g_sMarryWoManDenyMsg)
  else g_sMarryWoManDenyMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MarryWoManCancelMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MarryWoManCancelMsg', g_sMarryWoManCancelMsg)
  else g_sMarryWoManCancelMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ForceUnMarryManLoginMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ForceUnMarryManLoginMsg', g_sfUnMarryManLoginMsg)
  else g_sfUnMarryManLoginMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ForceUnMarryWoManLoginMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ForceUnMarryWoManLoginMsg', g_sfUnMarryWoManLoginMsg)
  else g_sfUnMarryWoManLoginMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ManLoginDearOnlineSelfMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ManLoginDearOnlineSelfMsg', g_sManLoginDearOnlineSelfMsg)
  else g_sManLoginDearOnlineSelfMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ManLoginDearOnlineDearMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ManLoginDearOnlineDearMsg', g_sManLoginDearOnlineDearMsg)
  else g_sManLoginDearOnlineDearMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'WoManLoginDearOnlineSelfMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WoManLoginDearOnlineSelfMsg', g_sWoManLoginDearOnlineSelfMsg)
  else g_sWoManLoginDearOnlineSelfMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'WoManLoginDearOnlineDearMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WoManLoginDearOnlineDearMsg', g_sWoManLoginDearOnlineDearMsg)
  else g_sWoManLoginDearOnlineDearMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ManLoginDearNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ManLoginDearNotOnlineMsg', g_sManLoginDearNotOnlineMsg)
  else g_sManLoginDearNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'WoManLoginDearNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WoManLoginDearNotOnlineMsg', g_sWoManLoginDearNotOnlineMsg)
  else g_sWoManLoginDearNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ManLongOutDearOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ManLongOutDearOnlineMsg', g_sManLongOutDearOnlineMsg)
  else g_sManLongOutDearOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'WoManLongOutDearOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WoManLongOutDearOnlineMsg', g_sWoManLongOutDearOnlineMsg)
  else g_sWoManLongOutDearOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouAreNotMarryedMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouAreNotMarryedMsg', g_sYouAreNotMarryedMsg)
  else g_sYouAreNotMarryedMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourWifeNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourWifeNotOnlineMsg', g_sYourWifeNotOnlineMsg)
  else g_sYourWifeNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourHusbandNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourHusbandNotOnlineMsg', g_sYourHusbandNotOnlineMsg)
  else g_sYourHusbandNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourWifeNowLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourWifeNowLocateMsg', g_sYourWifeNowLocateMsg)
  else g_sYourWifeNowLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourHusbandSearchLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourHusbandSearchLocateMsg', g_sYourHusbandSearchLocateMsg)
  else g_sYourHusbandSearchLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourHusbandNowLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourHusbandNowLocateMsg', g_sYourHusbandNowLocateMsg)
  else g_sYourHusbandNowLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourWifeSearchLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourWifeSearchLocateMsg', g_sYourWifeSearchLocateMsg)
  else g_sYourWifeSearchLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'FUnMasterLoginMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'FUnMasterLoginMsg', g_sfUnMasterLoginMsg)
  else g_sfUnMasterLoginMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'UnMasterListLoginMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'UnMasterListLoginMsg', g_sfUnMasterListLoginMsg)
  else g_sfUnMasterListLoginMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterListOnlineSelfMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterListOnlineSelfMsg', g_sMasterListOnlineSelfMsg)
  else g_sMasterListOnlineSelfMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterListOnlineMasterMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterListOnlineMasterMsg', g_sMasterListOnlineMasterMsg)
  else g_sMasterListOnlineMasterMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterOnlineSelfMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterOnlineSelfMsg', g_sMasterOnlineSelfMsg)
  else g_sMasterOnlineSelfMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterOnlineMasterListMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterOnlineMasterListMsg', g_sMasterOnlineMasterListMsg)
  else g_sMasterOnlineMasterListMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterLongOutMasterListOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterLongOutMasterListOnlineMsg', g_sMasterLongOutMasterListOnlineMsg)
  else g_sMasterLongOutMasterListOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterListLongOutMasterOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterListLongOutMasterOnlineMsg', g_sMasterListLongOutMasterOnlineMsg)
  else g_sMasterListLongOutMasterOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterListNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterListNotOnlineMsg', g_sMasterListNotOnlineMsg)
  else g_sMasterListNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterNotOnlineMsg', g_sMasterNotOnlineMsg)
  else g_sMasterNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouAreNotMasterMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouAreNotMasterMsg', g_sYouAreNotMasterMsg)
  else g_sYouAreNotMasterMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourMasterNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourMasterNotOnlineMsg', g_sYourMasterNotOnlineMsg)
  else g_sYourMasterNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourMasterListNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourMasterListNotOnlineMsg', g_sYourMasterListNotOnlineMsg)
  else g_sYourMasterListNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourMasterNowLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourMasterNowLocateMsg', g_sYourMasterNowLocateMsg)
  else g_sYourMasterNowLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourMasterListSearchLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourMasterListSearchLocateMsg', g_sYourMasterListSearchLocateMsg)
  else g_sYourMasterListSearchLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourMasterListNowLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourMasterListNowLocateMsg', g_sYourMasterListNowLocateMsg)
  else g_sYourMasterListNowLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourMasterSearchLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourMasterSearchLocateMsg', g_sYourMasterSearchLocateMsg)
  else g_sYourMasterSearchLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourMasterListUnMasterOKMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourMasterListUnMasterOKMsg', g_sYourMasterListUnMasterOKMsg)
  else g_sYourMasterListUnMasterOKMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouAreUnMasterOKMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouAreUnMasterOKMsg', g_sYouAreUnMasterOKMsg)
  else g_sYouAreUnMasterOKMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'UnMasterLoginMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'UnMasterLoginMsg', g_sUnMasterLoginMsg)
  else g_sUnMasterLoginMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'NPCSayUnMasterOKMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NPCSayUnMasterOKMsg', g_sNPCSayUnMasterOKMsg)
  else g_sNPCSayUnMasterOKMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'NPCSayForceUnMasterMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NPCSayForceUnMasterMsg', g_sNPCSayForceUnMasterMsg)
  else g_sNPCSayForceUnMasterMsg := LoadString;

}


  LoadString := StringConf.ReadString('String', 'MyInfo', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MyInfo', g_sMyInfo)
  else g_sMyInfo := LoadString;

  LoadString := StringConf.ReadString('String', 'OpenedDealMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'OpenedDealMsg', g_sOpenedDealMsg)
  else g_sOpenedDealMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'SendCustMsgCanNotUseNowMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SendCustMsgCanNotUseNowMsg', g_sSendCustMsgCanNotUseNowMsg)
  else g_sSendCustMsgCanNotUseNowMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'SubkMasterMsgCanNotUseNowMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SubkMasterMsgCanNotUseNowMsg', g_sSubkMasterMsgCanNotUseNowMsg)
  else g_sSubkMasterMsgCanNotUseNowMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'SendOnlineCountMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SendOnlineCountMsg', g_sSendOnlineCountMsg)
  else g_sSendOnlineCountMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'WeaponRepairSuccess', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WeaponRepairSuccess', g_sWeaponRepairSuccess)
  else g_sWeaponRepairSuccess := LoadString;

  LoadString := StringConf.ReadString('String', 'DefenceUpTime', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DefenceUpTime', g_sDefenceUpTime)
  else g_sDefenceUpTime := LoadString;

  LoadString := StringConf.ReadString('String', 'MagDefenceUpTime', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MagDefenceUpTime', g_sMagDefenceUpTime)
  else g_sMagDefenceUpTime := LoadString;

//取消彩票功能
{
  LoadString := StringConf.ReadString('String', 'WinLottery1Msg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WinLottery1Msg', g_sWinLottery1Msg)
  else g_sWinLottery1Msg := LoadString;

  LoadString := StringConf.ReadString('String', 'WinLottery2Msg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WinLottery2Msg', g_sWinLottery2Msg)
  else g_sWinLottery2Msg := LoadString;

  LoadString := StringConf.ReadString('String', 'WinLottery3Msg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WinLottery3Msg', g_sWinLottery3Msg)
  else g_sWinLottery3Msg := LoadString;

  LoadString := StringConf.ReadString('String', 'WinLottery4Msg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WinLottery4Msg', g_sWinLottery4Msg)
  else g_sWinLottery4Msg := LoadString;

  LoadString := StringConf.ReadString('String', 'WinLottery5Msg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WinLottery5Msg', g_sWinLottery5Msg)
  else g_sWinLottery5Msg := LoadString;

  LoadString := StringConf.ReadString('String', 'WinLottery6Msg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WinLottery6Msg', g_sWinLottery6Msg)
  else g_sWinLottery6Msg := LoadString;

  LoadString := StringConf.ReadString('String', 'NotWinLotteryMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NotWinLotteryMsg', g_sNotWinLotteryMsg)
  else g_sNotWinLotteryMsg := LoadString;
}

  LoadString := StringConf.ReadString('String', 'WeaptonMakeLuck', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WeaptonMakeLuck', g_sWeaptonMakeLuck)
  else g_sWeaptonMakeLuck := LoadString;

  LoadString := StringConf.ReadString('String', 'WeaptonNotMakeLuck', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WeaptonNotMakeLuck', g_sWeaptonNotMakeLuck)
  else g_sWeaptonNotMakeLuck := LoadString;

  LoadString := StringConf.ReadString('String', 'TheWeaponIsCursed', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TheWeaponIsCursed', g_sTheWeaponIsCursed)
  else g_sTheWeaponIsCursed := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotTakeOffItem', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotTakeOffItem', g_sCanotTakeOffItem)
  else g_sCanotTakeOffItem := LoadString;

  LoadString := StringConf.ReadString('String', 'JoinGroupMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'JoinGroupMsg', g_sJoinGroup)
  else g_sJoinGroup := LoadString;

  LoadString := StringConf.ReadString('String', 'TryModeCanotUseStorage', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TryModeCanotUseStorage', g_sTryModeCanotUseStorage)
  else g_sTryModeCanotUseStorage := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotGetItemsMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotGetItemsMsg', g_sCanotGetItems)
  else g_sCanotGetItems := LoadString;

//取消 允许 夫妻 和 师徒 传送提示文本  
{
  LoadString := StringConf.ReadString('String', 'EnableDearRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableDearRecall', g_sEnableDearRecall)
  else g_sEnableDearRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableDearRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableDearRecall', g_sDisableDearRecall)
  else g_sDisableDearRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableMasterRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableMasterRecall', g_sEnableMasterRecall)
  else g_sEnableMasterRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableMasterRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableMasterRecall', g_sDisableMasterRecall)
  else g_sDisableMasterRecall := LoadString;
}

  LoadString := StringConf.ReadString('String', 'NowCurrDateTime', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NowCurrDateTime', g_sNowCurrDateTime)
  else g_sNowCurrDateTime := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableHearWhisper', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableHearWhisper', g_sEnableHearWhisper)
  else g_sEnableHearWhisper := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableHearWhisper', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableHearWhisper', g_sDisableHearWhisper)
  else g_sDisableHearWhisper := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableShoutMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableShoutMsg', g_sEnableShoutMsg)
  else g_sEnableShoutMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableShoutMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableShoutMsg', g_sDisableShoutMsg)
  else g_sDisableShoutMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableDealMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableDealMsg', g_sEnableDealMsg)
  else g_sEnableDealMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableDealMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableDealMsg', g_sDisableDealMsg)
  else g_sDisableDealMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableGuildChat', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableGuildChat', g_sEnableGuildChat)
  else g_sEnableGuildChat := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableGuildChat', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableGuildChat', g_sDisableGuildChat)
  else g_sDisableGuildChat := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableJoinGuild', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableJoinGuild', g_sEnableJoinGuild)
  else g_sEnableJoinGuild := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableJoinGuild', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableJoinGuild', g_sDisableJoinGuild)
  else g_sDisableJoinGuild := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableAuthAllyGuild', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableAuthAllyGuild', g_sEnableAuthAllyGuild)
  else g_sEnableAuthAllyGuild := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableAuthAllyGuild', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableAuthAllyGuild', g_sDisableAuthAllyGuild)
  else g_sDisableAuthAllyGuild := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableGroupRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableGroupRecall', g_sEnableGroupRecall)
  else g_sEnableGroupRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableGroupRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableGroupRecall', g_sDisableGroupRecall)
  else g_sDisableGroupRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableGuildRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableGuildRecall', g_sEnableGuildRecall)
  else g_sEnableGuildRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableGuildRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableGuildRecall', g_sDisableGuildRecall)
  else g_sDisableGuildRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'PleaseInputPassword', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PleaseInputPassword', g_sPleaseInputPassword)
  else g_sPleaseInputPassword := LoadString;

  LoadString := StringConf.ReadString('String', 'TheMapDisableMove', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TheMapDisableMove', g_sTheMapDisableMove)
  else g_sTheMapDisableMove := LoadString;

  LoadString := StringConf.ReadString('String', 'TheMapNotFound', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TheMapNotFound', g_sTheMapNotFound)
  else g_sTheMapNotFound := LoadString;

  LoadString := StringConf.ReadString('String', 'YourIPaddrDenyLogon', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourIPaddrDenyLogon', g_sYourIPaddrDenyLogon)
  else g_sYourIPaddrDenyLogon := LoadString;

  LoadString := StringConf.ReadString('String', 'YourAccountDenyLogon', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourAccountDenyLogon', g_sYourAccountDenyLogon)
  else g_sYourAccountDenyLogon := LoadString;

  LoadString := StringConf.ReadString('String', 'YourCharNameDenyLogon', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourCharNameDenyLogon', g_sYourCharNameDenyLogon)
  else g_sYourCharNameDenyLogon := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotPickUpItem', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotPickUpItem', g_sCanotPickUpItem)
  else g_sCanotPickUpItem := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotSendmsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotSendmsg', g_sCanotSendmsg)
  else g_sCanotSendmsg := LoadString;

  LoadString := StringConf.ReadString('String', 'UserDenyWhisperMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'UserDenyWhisperMsg', g_sUserDenyWhisperMsg)
  else g_sUserDenyWhisperMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'UserNotOnLine', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'UserNotOnLine', g_sUserNotOnLine)
  else g_sUserNotOnLine := LoadString;

  LoadString := StringConf.ReadString('String', 'RevivalRecoverMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'RevivalRecoverMsg', g_sRevivalRecoverMsg)
  else g_sRevivalRecoverMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ClientVersionTooOld', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ClientVersionTooOld', g_sClientVersionTooOld)
  else g_sClientVersionTooOld := LoadString;

  LoadString := StringConf.ReadString('String', 'CastleGuildName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CastleGuildName', g_sCastleGuildName)
  else g_sCastleGuildName := LoadString;

  LoadString := StringConf.ReadString('String', 'NoCastleGuildName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NoCastleGuildName', g_sNoCastleGuildName)
  else g_sNoCastleGuildName := LoadString;

  LoadString := StringConf.ReadString('String', 'WarrReNewName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WarrReNewName', g_sWarrReNewName)
  else g_sWarrReNewName := LoadString;

  LoadString := StringConf.ReadString('String', 'WizardReNewName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WizardReNewName', g_sWizardReNewName)
  else g_sWizardReNewName := LoadString;

  LoadString := StringConf.ReadString('String', 'TaosReNewName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TaosReNewName', g_sTaosReNewName)
  else g_sTaosReNewName := LoadString;

  LoadString := StringConf.ReadString('String', 'RankLevelName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'RankLevelName', g_sRankLevelName)
  else g_sRankLevelName := LoadString;

//取消 夫妻 和 师徒 关系 显示文字 
{
  LoadString := StringConf.ReadString('String', 'ManDearName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ManDearName', g_sManDearName)
  else g_sManDearName := LoadString;

  LoadString := StringConf.ReadString('String', 'WoManDearName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WoManDearName', g_sWoManDearName)
  else g_sWoManDearName := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterName', g_sMasterName)
  else g_sMasterName := LoadString;

  LoadString := StringConf.ReadString('String', 'NoMasterName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NoMasterName', g_sNoMasterName)
  else g_sNoMasterName := LoadString;
}

  LoadString := StringConf.ReadString('String', 'HumanShowName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'HumanShowName', g_sHumanShowName)
  else g_sHumanShowName := LoadString;

  LoadString := StringConf.ReadString('String', 'ChangePermissionMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ChangePermissionMsg', g_sChangePermissionMsg)
  else g_sChangePermissionMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ChangeKillMonExpRateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ChangeKillMonExpRateMsg', g_sChangeKillMonExpRateMsg)
  else g_sChangeKillMonExpRateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ChangePowerRateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ChangePowerRateMsg', g_sChangePowerRateMsg)
  else g_sChangePowerRateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ChangeMemberLevelMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ChangeMemberLevelMsg', g_sChangeMemberLevelMsg)
  else g_sChangeMemberLevelMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ChangeMemberTypeMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ChangeMemberTypeMsg', g_sChangeMemberTypeMsg)
  else g_sChangeMemberTypeMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ScriptChangeHumanHPMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ScriptChangeHumanHPMsg', g_sScriptChangeHumanHPMsg)
  else g_sScriptChangeHumanHPMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ScriptChangeHumanMPMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ScriptChangeHumanMPMsg', g_sScriptChangeHumanMPMsg)
  else g_sScriptChangeHumanMPMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouCanotDisableSayMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouCanotDisableSayMsg', g_sDisableSayMsg)
  else g_sDisableSayMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'OnlineCountMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'OnlineCountMsg', g_sOnlineCountMsg)
  else g_sOnlineCountMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'TotalOnlineCountMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TotalOnlineCountMsg', g_sTotalOnlineCountMsg)
  else g_sTotalOnlineCountMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouNeedLevelSendMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouNeedLevelSendMsg', g_sYouNeedLevelMsg)
  else g_sYouNeedLevelMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ThisMapDisableSendCyCyMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ThisMapDisableSendCyCyMsg', g_sThisMapDisableSendCyCyMsg)
  else g_sThisMapDisableSendCyCyMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouCanSendCyCyLaterMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouCanSendCyCyLaterMsg', g_sYouCanSendCyCyLaterMsg)
  else g_sYouCanSendCyCyLaterMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouIsDisableSendMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouIsDisableSendMsg', g_sYouIsDisableSendMsg)
  else g_sYouIsDisableSendMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouMurderedMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouMurderedMsg', g_sYouMurderedMsg)
  else g_sYouMurderedMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouKilledByMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouKilledByMsg', g_sYouKilledByMsg)
  else g_sYouKilledByMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouProtectedByLawOfDefense', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouProtectedByLawOfDefense', g_sYouProtectedByLawOfDefense)
  else g_sYouProtectedByLawOfDefense := LoadString;
  {
  LoadString:=StringConf.ReadString('String','GameCommandPermissionTooLow','');
  if LoadString = '' then
    StringConf.WriteString('String','GameCommandPermissionTooLow',g_sGameCommandPermissionTooLow)
  else g_sGameCommandPermissionTooLow:=LoadString;
  }
end;

procedure LoadConfig();
var
  i: Integer;
  nLoadInteger: Integer;
  nLoadFloat: Double;
  sLoadString: string;
begin
  LoadString();
  LoadGameCommand();
  LoadExp();
  //============================================================================
  if StringConf.ReadString('Guild', 'GuildNotice', '') = '' then
    StringConf.WriteString('Guild', 'GuildNotice', g_Config.sGuildNotice);
  g_Config.sGuildNotice := StringConf.ReadString('Guild', 'GuildNotice', g_Config.sGuildNotice);

  if StringConf.ReadString('Guild', 'GuildWar', '') = '' then
    StringConf.WriteString('Guild', 'GuildWar', g_Config.sGuildWar);
  g_Config.sGuildWar := StringConf.ReadString('Guild', 'GuildWar', g_Config.sGuildWar);

  if StringConf.ReadString('Guild', 'GuildAll', '') = '' then
    StringConf.WriteString('Guild', 'GuildAll', g_Config.sGuildAll);
  g_Config.sGuildAll := StringConf.ReadString('Guild', 'GuildAll', g_Config.sGuildAll);

  if StringConf.ReadString('Guild', 'GuildMember', '') = '' then
    StringConf.WriteString('Guild', 'GuildMember', g_Config.sGuildMember);
  g_Config.sGuildMember := StringConf.ReadString('Guild', 'GuildMember', g_Config.sGuildMember);

  if StringConf.ReadString('Guild', 'GuildMemberRank', '') = '' then
    StringConf.WriteString('Guild', 'GuildMemberRank', g_Config.sGuildMemberRank);
  g_Config.sGuildMemberRank := StringConf.ReadString('Guild', 'GuildMemberRank', g_Config.sGuildMemberRank);

  if StringConf.ReadString('Guild', 'GuildChief', '') = '' then
    StringConf.WriteString('Guild', 'GuildChief', g_Config.sGuildChief);
  g_Config.sGuildChief := StringConf.ReadString('Guild', 'GuildChief', g_Config.sGuildChief);

  //服务器设置
  if Config.ReadInteger('Server', 'ServerIndex', -1) < 0 then
    Config.WriteInteger('Server', 'ServerIndex', nServerIndex);
  nServerIndex := Config.ReadInteger('Server', 'ServerIndex', nServerIndex);

  if Config.ReadString('Server', 'ServerName', '') = '' then
    Config.WriteString('Server', 'ServerName', g_Config.sServerName);
  g_Config.sServerName := Config.ReadString('Server', 'ServerName', g_Config.sServerName);

  if StringConf.ReadString('Server', 'ServerIP', '') = '' then
    StringConf.WriteString('Server', 'ServerIP', g_Config.sServerIPaddr);
  g_Config.sServerIPaddr := StringConf.ReadString('Server', 'ServerIP', g_Config.sServerIPaddr);

  if StringConf.ReadString('Server', 'WebSite', '') = '' then
    StringConf.WriteString('Server', 'WebSite', g_Config.sWebSite);
  g_Config.sWebSite := StringConf.ReadString('Server', 'WebSite', g_Config.sWebSite);

  if StringConf.ReadString('Server', 'BbsSite', '') = '' then
    StringConf.WriteString('Server', 'BbsSite', g_Config.sBbsSite);
  g_Config.sBbsSite := StringConf.ReadString('Server', 'BbsSite', g_Config.sBbsSite);

  if StringConf.ReadString('Server', 'ClientDownload', '') = '' then
    StringConf.WriteString('Server', 'ClientDownload', g_Config.sClientDownload);
  g_Config.sClientDownload := StringConf.ReadString('Server', 'ClientDownload', g_Config.sClientDownload);

  if StringConf.ReadString('Server', 'QQ', '') = '' then
    StringConf.WriteString('Server', 'QQ', g_Config.sQQ);
  g_Config.sQQ := StringConf.ReadString('Server', 'QQ', g_Config.sQQ);

  if StringConf.ReadString('Server', 'Phone', '') = '' then
    StringConf.WriteString('Server', 'Phone', g_Config.sPhone);
  g_Config.sPhone := StringConf.ReadString('Server', 'Phone', g_Config.sPhone);

  if StringConf.ReadString('Server', 'BankAccount0', '') = '' then
    StringConf.WriteString('Server', 'BankAccount0', g_Config.sBankAccount0);
  g_Config.sBankAccount0 := StringConf.ReadString('Server', 'BankAccount0', g_Config.sBankAccount0);

  if StringConf.ReadString('Server', 'BankAccount1', '') = '' then
    StringConf.WriteString('Server', 'BankAccount1', g_Config.sBankAccount1);
  g_Config.sBankAccount1 := StringConf.ReadString('Server', 'BankAccount1', g_Config.sBankAccount1);

  if StringConf.ReadString('Server', 'BankAccount2', '') = '' then
    StringConf.WriteString('Server', 'BankAccount2', g_Config.sBankAccount2);
  g_Config.sBankAccount2 := StringConf.ReadString('Server', 'BankAccount2', g_Config.sBankAccount2);

  if StringConf.ReadString('Server', 'BankAccount3', '') = '' then
    StringConf.WriteString('Server', 'BankAccount3', g_Config.sBankAccount3);
  g_Config.sBankAccount3 := StringConf.ReadString('Server', 'BankAccount3', g_Config.sBankAccount3);

  if StringConf.ReadString('Server', 'BankAccount4', '') = '' then
    StringConf.WriteString('Server', 'BankAccount4', g_Config.sBankAccount4);
  g_Config.sBankAccount4 := StringConf.ReadString('Server', 'BankAccount4', g_Config.sBankAccount4);

  if StringConf.ReadString('Server', 'BankAccount5', '') = '' then
    StringConf.WriteString('Server', 'BankAccount5', g_Config.sBankAccount5);
  g_Config.sBankAccount5 := StringConf.ReadString('Server', 'BankAccount5', g_Config.sBankAccount5);

  if StringConf.ReadString('Server', 'BankAccount6', '') = '' then
    StringConf.WriteString('Server', 'BankAccount6', g_Config.sBankAccount6);
  g_Config.sBankAccount6 := StringConf.ReadString('Server', 'BankAccount6', g_Config.sBankAccount6);

  if StringConf.ReadString('Server', 'BankAccount7', '') = '' then
    StringConf.WriteString('Server', 'BankAccount7', g_Config.sBankAccount7);
  g_Config.sBankAccount7 := StringConf.ReadString('Server', 'BankAccount7', g_Config.sBankAccount7);

  if StringConf.ReadString('Server', 'BankAccount8', '') = '' then
    StringConf.WriteString('Server', 'BankAccount8', g_Config.sBankAccount8);
  g_Config.sBankAccount8 := StringConf.ReadString('Server', 'BankAccount8', g_Config.sBankAccount8);

  if StringConf.ReadString('Server', 'BankAccount9', '') = '' then
    StringConf.WriteString('Server', 'BankAccount9', g_Config.sBankAccount9);
  g_Config.sBankAccount9 := StringConf.ReadString('Server', 'BankAccount9', g_Config.sBankAccount9);

  if Config.ReadInteger('Server', 'ServerNumber', -1) < 0 then
    Config.WriteInteger('Server', 'ServerNumber', g_Config.nServerNumber);
  g_Config.nServerNumber := Config.ReadInteger('Server', 'ServerNumber', g_Config.nServerNumber);

  if Config.ReadString('Server', 'VentureServer', '') = '' then
    Config.WriteString('Server', 'VentureServer', BoolToStr(g_Config.boVentureServer));
  g_Config.boVentureServer := CompareText(Config.ReadString('Server', 'VentureServer', 'FALSE'), 'TRUE') = 0;

  if Config.ReadString('Server', 'TestServer', '') = '' then
    Config.WriteString('Server', 'TestServer', BoolToStr(g_Config.boTestServer));
  g_Config.boTestServer := CompareText(Config.ReadString('Server', 'TestServer', 'FALSE'), 'TRUE') = 0;

  if Config.ReadInteger('Server', 'TestLevel', -1) < 0 then
    Config.WriteInteger('Server', 'TestLevel', g_Config.nTestLevel);
  g_Config.nTestLevel := Config.ReadInteger('Server', 'TestLevel', g_Config.nTestLevel);

  if Config.ReadInteger('Server', 'TestGold', -1) < 0 then
    Config.WriteInteger('Server', 'TestGold', g_Config.nTestGold);
  g_Config.nTestGold := Config.ReadInteger('Server', 'TestGold', g_Config.nTestGold);

  if Config.ReadInteger('Server', 'TestServerUserLimit', -1) < 0 then
    Config.WriteInteger('Server', 'TestServerUserLimit', g_Config.nTestUserLimit);
  g_Config.nTestUserLimit := Config.ReadInteger('Server', 'TestServerUserLimit', g_Config.nTestUserLimit);

  if Config.ReadString('Server', 'ServiceMode', '') = '' then
    Config.WriteString('Server', 'ServiceMode', BoolToStr(g_Config.boServiceMode));
  g_Config.boServiceMode := CompareText(Config.ReadString('Server', 'ServiceMode', 'FALSE'), 'TRUE') = 0;

  if Config.ReadString('Server', 'NonPKServer', '') = '' then
    Config.WriteString('Server', 'NonPKServer', BoolToStr(g_Config.boNonPKServer));
  g_Config.boNonPKServer := CompareText(Config.ReadString('Server', 'NonPKServer', 'FALSE'), 'TRUE') = 0;

  if Config.ReadString('Server', 'ViewHackMessage', '') = '' then
    Config.WriteString('Server', 'ViewHackMessage', BoolToStr(g_Config.boViewHackMessage));
  g_Config.boViewHackMessage := CompareText(Config.ReadString('Server', 'ViewHackMessage', 'FALSE'), 'TRUE') = 0;

  if Config.ReadString('Server', 'ViewAdmissionFailure', '') = '' then
    Config.WriteString('Server', 'ViewAdmissionFailure', BoolToStr(g_Config.boViewAdmissionFailure));
  g_Config.boViewAdmissionFailure := CompareText(Config.ReadString('Server', 'ViewAdmissionFailure', 'FALSE'), 'TRUE') = 0;

  if Config.ReadString('Server', 'GateAddr', '') = '' then
    Config.WriteString('Server', 'GateAddr', g_Config.sGateAddr);
  g_Config.sGateAddr := Config.ReadString('Server', 'GateAddr', g_Config.sGateAddr);

  if Config.ReadInteger('Server', 'GatePort', -1) < 0 then
    Config.WriteInteger('Server', 'GatePort', g_Config.nGatePort);
  g_Config.nGatePort := Config.ReadInteger('Server', 'GatePort', g_Config.nGatePort);

  if Config.ReadString('Server', 'DBAddr', '') = '' then
    Config.WriteString('Server', 'DBAddr', g_Config.sDBAddr);
  g_Config.sDBAddr := Config.ReadString('Server', 'DBAddr', g_Config.sDBAddr);

  if Config.ReadInteger('Server', 'DBPort', -1) < 0 then
    Config.WriteInteger('Server', 'DBPort', g_Config.nDBPort);
  g_Config.nDBPort := Config.ReadInteger('Server', 'DBPort', g_Config.nDBPort);

  if Config.ReadString('Server', 'IDSAddr', '') = '' then
    Config.WriteString('Server', 'IDSAddr', g_Config.sIDSAddr);
  g_Config.sIDSAddr := Config.ReadString('Server', 'IDSAddr', g_Config.sIDSAddr);

  if Config.ReadInteger('Server', 'IDSPort', -1) < 0 then
    Config.WriteInteger('Server', 'IDSPort', g_Config.nIDSPort);
  g_Config.nIDSPort := Config.ReadInteger('Server', 'IDSPort', g_Config.nIDSPort);

  if Config.ReadString('Server', 'MsgSrvAddr', '') = '' then
    Config.WriteString('Server', 'MsgSrvAddr', g_Config.sMsgSrvAddr);
  g_Config.sMsgSrvAddr := Config.ReadString('Server', 'MsgSrvAddr', g_Config.sMsgSrvAddr);

  if Config.ReadInteger('Server', 'MsgSrvPort', -1) < 0 then
    Config.WriteInteger('Server', 'MsgSrvPort', g_Config.nMsgSrvPort);
  g_Config.nMsgSrvPort := Config.ReadInteger('Server', 'MsgSrvPort', g_Config.nMsgSrvPort);

  if Config.ReadString('Server', 'LogServerAddr', '') = '' then
    Config.WriteString('Server', 'LogServerAddr', g_Config.sLogServerAddr);
  g_Config.sLogServerAddr := Config.ReadString('Server', 'LogServerAddr', g_Config.sLogServerAddr);

  if Config.ReadInteger('Server', 'LogServerPort', -1) < 0 then
    Config.WriteInteger('Server', 'LogServerPort', g_Config.nLogServerPort);
  g_Config.nLogServerPort := Config.ReadInteger('Server', 'LogServerPort', g_Config.nLogServerPort);

  if Config.ReadString('Server', 'DiscountForNightTime', '') = '' then
    Config.WriteString('Server', 'DiscountForNightTime', BoolToStr(g_Config.boDiscountForNightTime));
  g_Config.boDiscountForNightTime := CompareText(Config.ReadString('Server', 'DiscountForNightTime', 'FALSE'), 'TRUE') = 0;

  if Config.ReadInteger('Server', 'HalfFeeStart', -1) < 0 then
    Config.WriteInteger('Server', 'HalfFeeStart', g_Config.nHalfFeeStart);
  g_Config.nHalfFeeStart := Config.ReadInteger('Server', 'HalfFeeStart', g_Config.nHalfFeeStart);

  if Config.ReadInteger('Server', 'HalfFeeEnd', -1) < 0 then
    Config.WriteInteger('Server', 'HalfFeeEnd', g_Config.nHalfFeeEnd);
  g_Config.nHalfFeeEnd := Config.ReadInteger('Server', 'HalfFeeEnd', g_Config.nHalfFeeEnd);

  if Config.ReadInteger('Server', 'HumLimit', -1) < 0 then
    Config.WriteInteger('Server', 'HumLimit', g_dwHumLimit);
  g_dwHumLimit := Config.ReadInteger('Server', 'HumLimit', g_dwHumLimit);

  if Config.ReadInteger('Server', 'MonLimit', -1) < 0 then
    Config.WriteInteger('Server', 'MonLimit', g_dwMonLimit);
  g_dwMonLimit := Config.ReadInteger('Server', 'MonLimit', g_dwMonLimit);

  if Config.ReadInteger('Server', 'ZenLimit', -1) < 0 then
    Config.WriteInteger('Server', 'ZenLimit', g_dwZenLimit);
  g_dwZenLimit := Config.ReadInteger('Server', 'ZenLimit', g_dwZenLimit);

  if Config.ReadInteger('Server', 'NpcLimit', -1) < 0 then
    Config.WriteInteger('Server', 'NpcLimit', g_dwNpcLimit);
  g_dwNpcLimit := Config.ReadInteger('Server', 'NpcLimit', g_dwNpcLimit);

  if Config.ReadInteger('Server', 'SocLimit', -1) < 0 then
    Config.WriteInteger('Server', 'SocLimit', g_dwSocLimit);
  g_dwSocLimit := Config.ReadInteger('Server', 'SocLimit', g_dwSocLimit);

  if Config.ReadInteger('Server', 'DecLimit', -1) < 0 then
    Config.WriteInteger('Server', 'DecLimit', nDecLimit);
  nDecLimit := Config.ReadInteger('Server', 'DecLimit', nDecLimit);

  if Config.ReadInteger('Server', 'SendBlock', -1) < 0 then
    Config.WriteInteger('Server', 'SendBlock', g_Config.nSendBlock);
  g_Config.nSendBlock := Config.ReadInteger('Server', 'SendBlock', g_Config.nSendBlock);

  if Config.ReadInteger('Server', 'CheckBlock', -1) < 0 then
    Config.WriteInteger('Server', 'CheckBlock', g_Config.nCheckBlock);
  g_Config.nCheckBlock := Config.ReadInteger('Server', 'CheckBlock', g_Config.nCheckBlock);

  if Config.ReadInteger('Server', 'SocCheckTimeOut', -1) < 0 then
    Config.WriteInteger('Server', 'SocCheckTimeOut', g_dwSocCheckTimeOut);
  g_dwSocCheckTimeOut := Config.ReadInteger('Server', 'SocCheckTimeOut', g_dwSocCheckTimeOut);

  if Config.ReadInteger('Server', 'AvailableBlock', -1) < 0 then
    Config.WriteInteger('Server', 'AvailableBlock', g_Config.nAvailableBlock);
  g_Config.nAvailableBlock := Config.ReadInteger('Server', 'AvailableBlock', g_Config.nAvailableBlock);

  if Config.ReadInteger('Server', 'GateLoad', -1) < 0 then
    Config.WriteInteger('Server', 'GateLoad', g_Config.nGateLoad);
  g_Config.nGateLoad := Config.ReadInteger('Server', 'GateLoad', g_Config.nGateLoad);

  if Config.ReadInteger('Server', 'UserFull', -1) < 0 then
    Config.WriteInteger('Server', 'UserFull', g_Config.nUserFull);
  g_Config.nUserFull := Config.ReadInteger('Server', 'UserFull', g_Config.nUserFull);

  if Config.ReadInteger('Server', 'ZenFastStep', -1) < 0 then
    Config.WriteInteger('Server', 'ZenFastStep', g_Config.nZenFastStep);
  g_Config.nZenFastStep := Config.ReadInteger('Server', 'ZenFastStep', g_Config.nZenFastStep);

  if Config.ReadInteger('Server', 'ProcessMonstersTime', -1) < 0 then
    Config.WriteInteger('Server', 'ProcessMonstersTime', g_Config.dwProcessMonstersTime);
  g_Config.dwProcessMonstersTime := Config.ReadInteger('Server', 'ProcessMonstersTime', g_Config.dwProcessMonstersTime);

  if Config.ReadInteger('Server', 'RegenMonstersTime', -1) < 0 then
    Config.WriteInteger('Server', 'RegenMonstersTime', g_Config.dwRegenMonstersTime);
  g_Config.dwRegenMonstersTime := Config.ReadInteger('Server', 'RegenMonstersTime', g_Config.dwRegenMonstersTime);


  if Config.ReadInteger('Server', 'HumanGetMsgTimeLimit', -1) < 0 then
    Config.WriteInteger('Server', 'HumanGetMsgTimeLimit', g_Config.dwHumanGetMsgTime);
  g_Config.dwHumanGetMsgTime := Config.ReadInteger('Server', 'HumanGetMsgTimeLimit', g_Config.dwHumanGetMsgTime);

{  if (GetMD5Text(g_sProductName) <> '82700a24a055c27073062735c233d6e5') or
     (GetMD5Text(g_sVersion) <> 'dfd2a178f1728b926f1c748cfb1dfd94') or
     (GetMD5Text(g_sProgram) <> 'eb8c6063b27da4f3906e96c4882a20ac') or
     (GetMD5Text(g_sWebSite) <> '98802f43ff881556bb02ad2ca116198b') or
     (GetMD5Text(g_sBbsSite) <> '34eacca1b042f154e6c8807aa6b11727') then begin
    g_Config.boCheckFail:=True;
  end;  }//nicky


  //============================================================================
  //目录设置
  if Config.ReadString('Share', 'BaseDir', '') = '' then
    Config.WriteString('Share', 'BaseDir', g_Config.sBaseDir);
  g_Config.sBaseDir := Config.ReadString('Share', 'BaseDir', g_Config.sBaseDir);

  if Config.ReadString('Share', 'GuildDir', '') = '' then
    Config.WriteString('Share', 'GuildDir', g_Config.sGuildDir);
  g_Config.sGuildDir := Config.ReadString('Share', 'GuildDir', g_Config.sGuildDir);

  if Config.ReadString('Share', 'GuildFile', '') = '' then
    Config.WriteString('Share', 'GuildFile', g_Config.sGuildFile);
  g_Config.sGuildFile := Config.ReadString('Share', 'GuildFile', g_Config.sGuildFile);

  if Config.ReadString('Share', 'VentureDir', '') = '' then
    Config.WriteString('Share', 'VentureDir', g_Config.sVentureDir);
  g_Config.sVentureDir := Config.ReadString('Share', 'VentureDir', g_Config.sVentureDir);

  if Config.ReadString('Share', 'ConLogDir', '') = '' then
    Config.WriteString('Share', 'ConLogDir', g_Config.sConLogDir);
  g_Config.sConLogDir := Config.ReadString('Share', 'ConLogDir', g_Config.sConLogDir);

  if Config.ReadString('Share', 'CastleDir', '') = '' then
    Config.WriteString('Share', 'CastleDir', g_Config.sCastleDir);
  g_Config.sCastleDir := Config.ReadString('Share', 'CastleDir', g_Config.sCastleDir);

  if Config.ReadString('Share', 'CastleFile', '') = '' then
//    Config.WriteString('Share','CastleFile',g_Config.sCastleFile);
    Config.WriteString('Share', 'CastleFile', g_Config.sCastleDir + 'List.txt');
  g_Config.sCastleFile := Config.ReadString('Share', 'CastleFile', g_Config.sCastleFile);

  if Config.ReadString('Share', 'EnvirDir', '') = '' then
    Config.WriteString('Share', 'EnvirDir', g_Config.sEnvirDir);
  g_Config.sEnvirDir := Config.ReadString('Share', 'EnvirDir', g_Config.sEnvirDir);

  if Config.ReadString('Share', 'MapDir', '') = '' then
    Config.WriteString('Share', 'MapDir', g_Config.sMapDir);
  g_Config.sMapDir := Config.ReadString('Share', 'MapDir', g_Config.sMapDir);

  if Config.ReadString('Share', 'NoticeDir', '') = '' then
    Config.WriteString('Share', 'NoticeDir', g_Config.sNoticeDir);
  g_Config.sNoticeDir := Config.ReadString('Share', 'NoticeDir', g_Config.sNoticeDir);

  sLoadString := Config.ReadString('Share', 'LogDir', '');
  if sLoadString = '' then
    Config.WriteString('Share', 'LogDir', g_Config.sLogDir)
  else g_Config.sLogDir := sLoadString;

  if Config.ReadString('Share', 'PlugDir', '') = '' then
    Config.WriteString('Share', 'PlugDir', g_Config.sPlugDir);
  g_Config.sPlugDir := Config.ReadString('Share', 'PlugDir', g_Config.sPlugDir);

  //游戏币设
  sLoadString := Config.ReadString('Share', 'GameGold', '');   //游戏币
  if sLoadString = '' then
    Config.WriteString('Share', 'GameGold', g_Config.sGameGoldName)
  else g_Config.sGameGoldName := sLoadString;

  sLoadString := Config.ReadString('Share', 'GamePoint', '');    //游戏点
  if sLoadString = '' then
    Config.WriteString('Share', 'GamePoint', g_Config.sGamePointName)
  else g_Config.sGamePointName := sLoadString;

  sLoadString := Config.ReadString('Share', 'PayMentPointName', '');  //秒卡点 (充值点)
  if sLoadString = '' then
    Config.WriteString('Share', 'PayMentPointName', g_Config.sPayMentPointName)
  else g_Config.sPayMentPointName := sLoadString;

  //============================================================================
  //名称设置
  if Config.ReadString('Names', 'HealSkill', '') = '' then
    Config.WriteString('Names', 'HealSkill', g_Config.sHealSkill);
  g_Config.sHealSkill := Config.ReadString('Names', 'HealSkill', g_Config.sHealSkill);

  if Config.ReadString('Names', 'FireBallSkill', '') = '' then
    Config.WriteString('Names', 'FireBallSkill', g_Config.sFireBallSkill);
  g_Config.sFireBallSkill := Config.ReadString('Names', 'FireBallSkill', g_Config.sFireBallSkill);

  if Config.ReadString('Names', 'ClothsMan', '') = '' then
    Config.WriteString('Names', 'ClothsMan', g_Config.sClothsMan);
  g_Config.sClothsMan := Config.ReadString('Names', 'ClothsMan', g_Config.sClothsMan);

  if Config.ReadString('Names', 'ClothsWoman', '') = '' then
    Config.WriteString('Names', 'ClothsWoman', g_Config.sClothsWoman);
  g_Config.sClothsWoman := Config.ReadString('Names', 'ClothsWoman', g_Config.sClothsWoman);

  if Config.ReadString('Names', 'WoodenSword', '') = '' then
    Config.WriteString('Names', 'WoodenSword', g_Config.sWoodenSword);
  g_Config.sWoodenSword := Config.ReadString('Names', 'WoodenSword', g_Config.sWoodenSword);

  if Config.ReadString('Names', 'Candle', '') = '' then
    Config.WriteString('Names', 'Candle', g_Config.sCandle);
  g_Config.sCandle := Config.ReadString('Names', 'Candle', g_Config.sCandle);

  if Config.ReadString('Names', 'BasicDrug', '') = '' then
    Config.WriteString('Names', 'BasicDrug', g_Config.sBasicDrug);
  g_Config.sBasicDrug := Config.ReadString('Names', 'BasicDrug', g_Config.sBasicDrug);

  if Config.ReadString('Names', 'GoldStone', '') = '' then
    Config.WriteString('Names', 'GoldStone', g_Config.sGoldStone);
  g_Config.sGoldStone := Config.ReadString('Names', 'GoldStone', g_Config.sGoldStone);

  if Config.ReadString('Names', 'SilverStone', '') = '' then
    Config.WriteString('Names', 'SilverStone', g_Config.sSilverStone);
  g_Config.sSilverStone := Config.ReadString('Names', 'SilverStone', g_Config.sSilverStone);

  if Config.ReadString('Names', 'SteelStone', '') = '' then
    Config.WriteString('Names', 'SteelStone', g_Config.sSteelStone);
  g_Config.sSteelStone := Config.ReadString('Names', 'SteelStone', g_Config.sSteelStone);

  if Config.ReadString('Names', 'CopperStone', '') = '' then
    Config.WriteString('Names', 'CopperStone', g_Config.sCopperStone);
  g_Config.sCopperStone := Config.ReadString('Names', 'CopperStone', g_Config.sCopperStone);

  if Config.ReadString('Names', 'BlackStone', '') = '' then
    Config.WriteString('Names', 'BlackStone', g_Config.sBlackStone);
  g_Config.sBlackStone := Config.ReadString('Names', 'BlackStone', g_Config.sBlackStone);


  if Config.ReadString('Names', 'Gem1Stone', '') = '' then
    Config.WriteString('Names', 'Gem1Stone', g_Config.sGemStone1);
  g_Config.sGemStone1 := Config.ReadString('Names', 'Gem1Stone', g_Config.sGemStone1);

  if Config.ReadString('Names', 'Gem2Stone', '') = '' then
    Config.WriteString('Names', 'Gem2Stone', g_Config.sGemStone2);
  g_Config.sGemStone2 := Config.ReadString('Names', 'Gem2Stone', g_Config.sGemStone2);

  if Config.ReadString('Names', 'Gem3Stone', '') = '' then
    Config.WriteString('Names', 'Gem3Stone', g_Config.sGemStone3);
  g_Config.sGemStone3 := Config.ReadString('Names', 'Gem3Stone', g_Config.sGemStone3);

  if Config.ReadString('Names', 'Gem4Stone', '') = '' then
    Config.WriteString('Names', 'Gem4Stone', g_Config.sGemStone4);
  g_Config.sGemStone4 := Config.ReadString('Names', 'Gem4Stone', g_Config.sGemStone4);


  if Config.ReadString('Names', 'Zuma1', '') = '' then
    Config.WriteString('Names', 'Zuma1', g_Config.sZuma[0]);
  g_Config.sZuma[0] := Config.ReadString('Names', 'Zuma1', g_Config.sZuma[0]);

  if Config.ReadString('Names', 'Zuma2', '') = '' then
    Config.WriteString('Names', 'Zuma2', g_Config.sZuma[1]);
  g_Config.sZuma[1] := Config.ReadString('Names', 'Zuma2', g_Config.sZuma[1]);

  if Config.ReadString('Names', 'Zuma3', '') = '' then
    Config.WriteString('Names', 'Zuma3', g_Config.sZuma[2]);
  g_Config.sZuma[2] := Config.ReadString('Names', 'Zuma3', g_Config.sZuma[2]);

  if Config.ReadString('Names', 'Zuma4', '') = '' then
    Config.WriteString('Names', 'Zuma4', g_Config.sZuma[3]);
  g_Config.sZuma[3] := Config.ReadString('Names', 'Zuma4', g_Config.sZuma[3]);

  if Config.ReadString('Names', 'Bee', '') = '' then
    Config.WriteString('Names', 'Bee', g_Config.sBee);
  g_Config.sBee := Config.ReadString('Names', 'Bee', g_Config.sBee);

  if Config.ReadString('Names', 'Spider', '') = '' then
    Config.WriteString('Names', 'Spider', g_Config.sSpider);
  g_Config.sSpider := Config.ReadString('Names', 'Spider', g_Config.sSpider);

  if Config.ReadString('Names', 'WomaHorn', '') = '' then
    Config.WriteString('Names', 'WomaHorn', g_Config.sWomaHorn);
  g_Config.sWomaHorn := Config.ReadString('Names', 'WomaHorn', g_Config.sWomaHorn);

  if Config.ReadString('Names', 'ZumaPiece', '') = '' then
    Config.WriteString('Names', 'ZumaPiece', g_Config.sZumaPiece);
  g_Config.sZumaPiece := Config.ReadString('Names', 'ZumaPiece', g_Config.sZumaPiece);

  if Config.ReadString('Names', 'Skeleton', '') = '' then
    Config.WriteString('Names', 'Skeleton', g_Config.sSkeleton);
  g_Config.sSkeleton := Config.ReadString('Names', 'Skeleton', g_Config.sSkeleton);

  if Config.ReadString('Names', 'Dragon', '') = '' then
    Config.WriteString('Names', 'Dragon', g_Config.sDragon);
  g_Config.sDragon := Config.ReadString('Names', 'Dragon', g_Config.sDragon);

  if Config.ReadString('Names', 'Dragon1', '') = '' then
    Config.WriteString('Names', 'Dragon1', g_Config.sDragon1);
  g_Config.sDragon1 := Config.ReadString('Names', 'Dragon1', g_Config.sDragon1);

  if Config.ReadString('Names', 'Angel', '') = '' then
    Config.WriteString('Names', 'Angel', g_Config.sAngel);
  g_Config.sAngel := Config.ReadString('Names', 'Angel', g_Config.sAngel);

  if g_Config.nAppIconCrc <> 1242102148 then
    g_Config.boCheckFail := True;
  //============================================================================
  //游戏设置
  if Config.ReadInteger('Setup', 'ItemNumber', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemNumber', g_Config.nItemNumber);
  g_Config.nItemNumber := Config.ReadInteger('Setup', 'ItemNumber', g_Config.nItemNumber);

  if Config.ReadInteger('Setup', 'ItemNumberEx', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemNumberEx', g_Config.nItemNumberEx);
  g_Config.nItemNumberEx := Config.ReadInteger('Setup', 'ItemNumberEx', g_Config.nItemNumberEx);

//------------------------------------
{
  //取消客户端软件版本校验 2021-6-7
  //读取要校验的客户端文件名
  if Config.ReadString('Setup', 'ClientFile1', '') = '' then
    Config.WriteString('Setup', 'ClientFile1', g_Config.sClientFile1);
  g_Config.sClientFile1 := Config.ReadString('Setup', 'ClientFile1', g_Config.sClientFile1);

  if Config.ReadString('Setup', 'ClientFile2', '') = '' then
    Config.WriteString('Setup', 'ClientFile2', g_Config.sClientFile2);
  g_Config.sClientFile2 := Config.ReadString('Setup', 'ClientFile2', g_Config.sClientFile2);

  if Config.ReadString('Setup', 'ClientFile3', '') = '' then
    Config.WriteString('Setup', 'ClientFile3', g_Config.sClientFile3);
  g_Config.sClientFile3 := Config.ReadString('Setup', 'ClientFile3', g_Config.sClientFile3);
}
//------------------------------------

  if Config.ReadInteger('Setup', 'MonUpLvNeedKillBase', -1) < 0 then
    Config.WriteInteger('Setup', 'MonUpLvNeedKillBase', g_Config.nMonUpLvNeedKillBase);
  g_Config.nMonUpLvNeedKillBase := Config.ReadInteger('Setup', 'MonUpLvNeedKillBase', g_Config.nMonUpLvNeedKillBase);

  if Config.ReadInteger('Setup', 'MonUpLvRate', -1) < 0 then
    Config.WriteInteger('Setup', 'MonUpLvRate', g_Config.nMonUpLvRate);
  g_Config.nMonUpLvRate := Config.ReadInteger('Setup', 'MonUpLvRate', g_Config.nMonUpLvRate);

  for i := Low(g_Config.MonUpLvNeedKillCount) to High(g_Config.MonUpLvNeedKillCount) do
  begin
    if Config.ReadInteger('Setup', 'MonUpLvNeedKillCount' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'MonUpLvNeedKillCount' + IntToStr(i), g_Config.MonUpLvNeedKillCount[i]);
    g_Config.MonUpLvNeedKillCount[i] := Config.ReadInteger('Setup', 'MonUpLvNeedKillCount' + IntToStr(i), g_Config.MonUpLvNeedKillCount[i]);
  end;

  for i := Low(g_Config.SlaveColor) to High(g_Config.SlaveColor) do
  begin
    if Config.ReadInteger('Setup', 'SlaveColor' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'SlaveColor' + IntToStr(i), g_Config.SlaveColor[i]);
    g_Config.SlaveColor[i] := Config.ReadInteger('Setup', 'SlaveColor' + IntToStr(i), g_Config.SlaveColor[i]);
  end;


  if Config.ReadString('Setup', 'HomeMap', '') = '' then
    Config.WriteString('Setup', 'HomeMap', g_Config.sHomeMap);
  g_Config.sHomeMap := Config.ReadString('Setup', 'HomeMap', g_Config.sHomeMap);

  if Config.ReadInteger('Setup', 'HomeX', -1) < 0 then
    Config.WriteInteger('Setup', 'HomeX', g_Config.nHomeX);
  g_Config.nHomeX := Config.ReadInteger('Setup', 'HomeX', g_Config.nHomeX);

  if Config.ReadInteger('Setup', 'HomeY', -1) < 0 then
    Config.WriteInteger('Setup', 'HomeY', g_Config.nHomeY);
  g_Config.nHomeY := Config.ReadInteger('Setup', 'HomeY', g_Config.nHomeY);

  if Config.ReadString('Setup', 'RedHomeMap', '') = '' then
    Config.WriteString('Setup', 'RedHomeMap', g_Config.sRedHomeMap);
  g_Config.sRedHomeMap := Config.ReadString('Setup', 'RedHomeMap', g_Config.sRedHomeMap);

  if Config.ReadInteger('Setup', 'RedHomeX', -1) < 0 then
    Config.WriteInteger('Setup', 'RedHomeX', g_Config.nRedHomeX);
  g_Config.nRedHomeX := Config.ReadInteger('Setup', 'RedHomeX', g_Config.nRedHomeX);

  if Config.ReadInteger('Setup', 'RedHomeY', -1) < 0 then
    Config.WriteInteger('Setup', 'RedHomeY', g_Config.nRedHomeY);
  g_Config.nRedHomeY := Config.ReadInteger('Setup', 'RedHomeY', g_Config.nRedHomeY);

  if Config.ReadString('Setup', 'RedDieHomeMap', '') = '' then
    Config.WriteString('Setup', 'RedDieHomeMap', g_Config.sRedDieHomeMap);
  g_Config.sRedDieHomeMap := Config.ReadString('Setup', 'RedDieHomeMap', g_Config.sRedDieHomeMap);

  if Config.ReadInteger('Setup', 'RedDieHomeX', -1) < 0 then
    Config.WriteInteger('Setup', 'RedDieHomeX', g_Config.nRedDieHomeX);
  g_Config.nRedDieHomeX := Config.ReadInteger('Setup', 'RedDieHomeX', g_Config.nRedDieHomeX);

  if Config.ReadInteger('Setup', 'RedDieHomeY', -1) < 0 then
    Config.WriteInteger('Setup', 'RedDieHomeY', g_Config.nRedDieHomeY);
  g_Config.nRedDieHomeY := Config.ReadInteger('Setup', 'RedDieHomeY', g_Config.nRedDieHomeY);


  if Config.ReadInteger('Setup', 'JobHomePointSystem', -1) < 0 then
    Config.WriteBool('Setup', 'JobHomePointSystem', g_Config.boJobHomePoint);
  g_Config.boJobHomePoint := Config.ReadBool('Setup', 'JobHomePointSystem', g_Config.boJobHomePoint);

  if Config.ReadString('Setup', 'WarriorHomeMap', '') = '' then
    Config.WriteString('Setup', 'WarriorHomeMap', g_Config.sWarriorHomeMap);
  g_Config.sWarriorHomeMap := Config.ReadString('Setup', 'WarriorHomeMap', g_Config.sWarriorHomeMap);

  if Config.ReadInteger('Setup', 'WarriorHomeX', -1) < 0 then
    Config.WriteInteger('Setup', 'WarriorHomeX', g_Config.nWarriorHomeX);
  g_Config.nWarriorHomeX := Config.ReadInteger('Setup', 'WarriorHomeX', g_Config.nWarriorHomeX);

  if Config.ReadInteger('Setup', 'WarriorHomeY', -1) < 0 then
    Config.WriteInteger('Setup', 'WarriorHomeY', g_Config.nWarriorHomeY);
  g_Config.nWarriorHomeY := Config.ReadInteger('Setup', 'WarriorHomeY', g_Config.nWarriorHomeY);

  if Config.ReadString('Setup', 'WizardHomeMap', '') = '' then
    Config.WriteString('Setup', 'WizardHomeMap', g_Config.sWizardHomeMap);
  g_Config.sWizardHomeMap := Config.ReadString('Setup', 'WizardHomeMap', g_Config.sWizardHomeMap);

  if Config.ReadInteger('Setup', 'WizardHomeX', -1) < 0 then
    Config.WriteInteger('Setup', 'WizardHomeX', g_Config.nWizardHomeX);
  g_Config.nWizardHomeX := Config.ReadInteger('Setup', 'WizardHomeX', g_Config.nWizardHomeX);

  if Config.ReadInteger('Setup', 'WizardHomeY', -1) < 0 then
    Config.WriteInteger('Setup', 'WizardHomeY', g_Config.nWizardHomeY);
  g_Config.nWizardHomeY := Config.ReadInteger('Setup', 'WizardHomeY', g_Config.nWizardHomeY);

  if Config.ReadString('Setup', 'TaoistHomeMap', '') = '' then
    Config.WriteString('Setup', 'TaoistHomeMap', g_Config.sTaoistHomeMap);
  g_Config.sTaoistHomeMap := Config.ReadString('Setup', 'TaoistHomeMap', g_Config.sTaoistHomeMap);

  if Config.ReadInteger('Setup', 'TaoistHomeX', -1) < 0 then
    Config.WriteInteger('Setup', 'TaoistHomeX', g_Config.nTaoistHomeX);
  g_Config.nTaoistHomeX := Config.ReadInteger('Setup', 'TaoistHomeX', g_Config.nTaoistHomeX);

  if Config.ReadInteger('Setup', 'TaoistHomeY', -1) < 0 then
    Config.WriteInteger('Setup', 'TaoistHomeY', g_Config.nTaoistHomeY);
  g_Config.nTaoistHomeY := Config.ReadInteger('Setup', 'TaoistHomeY', g_Config.nTaoistHomeY);

  nLoadInteger := Config.ReadInteger('Setup', 'HealthFillTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HealthFillTime', g_Config.nHealthFillTime)
  else g_Config.nHealthFillTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SpellFillTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SpellFillTime', g_Config.nSpellFillTime)
  else g_Config.nSpellFillTime := nLoadInteger;

  if Config.ReadInteger('Setup', 'DecPkPointTime', -1) < 0 then
    Config.WriteInteger('Setup', 'DecPkPointTime', g_Config.dwDecPkPointTime);
  g_Config.dwDecPkPointTime := Config.ReadInteger('Setup', 'DecPkPointTime', g_Config.dwDecPkPointTime);

  if Config.ReadInteger('Setup', 'DecPkPointCount', -1) < 0 then
    Config.WriteInteger('Setup', 'DecPkPointCount', g_Config.nDecPkPointCount);
  g_Config.nDecPkPointCount := Config.ReadInteger('Setup', 'DecPkPointCount', g_Config.nDecPkPointCount);

  if Config.ReadInteger('Setup', 'PKFlagTime', -1) < 0 then
    Config.WriteInteger('Setup', 'PKFlagTime', g_Config.dwPKFlagTime);
  g_Config.dwPKFlagTime := Config.ReadInteger('Setup', 'PKFlagTime', g_Config.dwPKFlagTime);

  if Config.ReadInteger('Setup', 'KillHumanAddPKPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'KillHumanAddPKPoint', g_Config.nKillHumanAddPKPoint);
  g_Config.nKillHumanAddPKPoint := Config.ReadInteger('Setup', 'KillHumanAddPKPoint', g_Config.nKillHumanAddPKPoint);

  if Config.ReadInteger('Setup', 'KillHumanDecLuckPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'KillHumanDecLuckPoint', g_Config.nKillHumanDecLuckPoint);
  g_Config.nKillHumanDecLuckPoint := Config.ReadInteger('Setup', 'KillHumanDecLuckPoint', g_Config.nKillHumanDecLuckPoint);

  if Config.ReadInteger('Setup', 'DecLightItemDrugTime', -1) < 0 then
    Config.WriteInteger('Setup', 'DecLightItemDrugTime', g_Config.dwDecLightItemDrugTime);
  g_Config.dwDecLightItemDrugTime := Config.ReadInteger('Setup', 'DecLightItemDrugTime', g_Config.dwDecLightItemDrugTime);


  if Config.ReadInteger('Setup', 'SafeZoneSize', -1) < 0 then
    Config.WriteInteger('Setup', 'SafeZoneSize', g_Config.nSafeZoneSize);
  g_Config.nSafeZoneSize := Config.ReadInteger('Setup', 'SafeZoneSize', g_Config.nSafeZoneSize);

  if Config.ReadInteger('Setup', 'StartPointSize', -1) < 0 then
    Config.WriteInteger('Setup', 'StartPointSize', g_Config.nStartPointSize);
  g_Config.nStartPointSize := Config.ReadInteger('Setup', 'StartPointSize', g_Config.nStartPointSize);

  for i := Low(g_Config.ReNewNameColor) to High(g_Config.ReNewNameColor) do
  begin
    if Config.ReadInteger('Setup', 'ReNewNameColor' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'ReNewNameColor' + IntToStr(i), g_Config.ReNewNameColor[i]);
    g_Config.ReNewNameColor[i] := Config.ReadInteger('Setup', 'ReNewNameColor' + IntToStr(i), g_Config.ReNewNameColor[i]);
  end;
  if Config.ReadInteger('Setup', 'ReNewNameColorTime', -1) < 0 then
    Config.WriteInteger('Setup', 'ReNewNameColorTime', g_Config.dwReNewNameColorTime);
  g_Config.dwReNewNameColorTime := Config.ReadInteger('Setup', 'ReNewNameColorTime', g_Config.dwReNewNameColorTime);

  if Config.ReadInteger('Setup', 'ReNewChangeColor', -1) < 0 then
    Config.WriteBool('Setup', 'ReNewChangeColor', g_Config.boReNewChangeColor);
  g_Config.boReNewChangeColor := Config.ReadBool('Setup', 'ReNewChangeColor', g_Config.boReNewChangeColor);

  if Config.ReadInteger('Setup', 'ReNewLevelClearExp', -1) < 0 then
    Config.WriteBool('Setup', 'ReNewLevelClearExp', g_Config.boReNewLevelClearExp);
  g_Config.boReNewLevelClearExp := Config.ReadBool('Setup', 'ReNewLevelClearExp', g_Config.boReNewLevelClearExp);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrDC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrDC', g_Config.BonusAbilofWarr.DC);
  g_Config.BonusAbilofWarr.DC := Config.ReadInteger('Setup', 'BonusAbilofWarrDC', g_Config.BonusAbilofWarr.DC);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrMC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrMC', g_Config.BonusAbilofWarr.MC);
  g_Config.BonusAbilofWarr.MC := Config.ReadInteger('Setup', 'BonusAbilofWarrMC', g_Config.BonusAbilofWarr.MC);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrSC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrSC', g_Config.BonusAbilofWarr.SC);
  g_Config.BonusAbilofWarr.SC := Config.ReadInteger('Setup', 'BonusAbilofWarrSC', g_Config.BonusAbilofWarr.SC);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrAC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrAC', g_Config.BonusAbilofWarr.AC);
  g_Config.BonusAbilofWarr.AC := Config.ReadInteger('Setup', 'BonusAbilofWarrAC', g_Config.BonusAbilofWarr.AC);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrMAC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrMAC', g_Config.BonusAbilofWarr.MAC);
  g_Config.BonusAbilofWarr.MAC := Config.ReadInteger('Setup', 'BonusAbilofWarrMAC', g_Config.BonusAbilofWarr.MAC);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrHP', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrHP', g_Config.BonusAbilofWarr.HP);
  g_Config.BonusAbilofWarr.HP := Config.ReadInteger('Setup', 'BonusAbilofWarrHP', g_Config.BonusAbilofWarr.HP);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrMP', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrMP', g_Config.BonusAbilofWarr.MP);
  g_Config.BonusAbilofWarr.MP := Config.ReadInteger('Setup', 'BonusAbilofWarrMP', g_Config.BonusAbilofWarr.MP);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrHit', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrHit', g_Config.BonusAbilofWarr.Hit);
  g_Config.BonusAbilofWarr.Hit := Config.ReadInteger('Setup', 'BonusAbilofWarrHit', g_Config.BonusAbilofWarr.Hit);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrSpeed', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrSpeed', g_Config.BonusAbilofWarr.Speed);
  g_Config.BonusAbilofWarr.Speed := Config.ReadInteger('Setup', 'BonusAbilofWarrSpeed', g_Config.BonusAbilofWarr.Speed);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrX2', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrX2', g_Config.BonusAbilofWarr.X2);
  g_Config.BonusAbilofWarr.X2 := Config.ReadInteger('Setup', 'BonusAbilofWarrX2', g_Config.BonusAbilofWarr.X2);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardDC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardDC', g_Config.BonusAbilofWizard.DC);
  g_Config.BonusAbilofWizard.DC := Config.ReadInteger('Setup', 'BonusAbilofWizardDC', g_Config.BonusAbilofWizard.DC);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardMC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardMC', g_Config.BonusAbilofWizard.MC);
  g_Config.BonusAbilofWizard.MC := Config.ReadInteger('Setup', 'BonusAbilofWizardMC', g_Config.BonusAbilofWizard.MC);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardSC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardSC', g_Config.BonusAbilofWizard.SC);
  g_Config.BonusAbilofWizard.SC := Config.ReadInteger('Setup', 'BonusAbilofWizardSC', g_Config.BonusAbilofWizard.SC);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardAC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardAC', g_Config.BonusAbilofWizard.AC);
  g_Config.BonusAbilofWizard.AC := Config.ReadInteger('Setup', 'BonusAbilofWizardAC', g_Config.BonusAbilofWizard.AC);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardMAC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardMAC', g_Config.BonusAbilofWizard.MAC);
  g_Config.BonusAbilofWizard.MAC := Config.ReadInteger('Setup', 'BonusAbilofWizardMAC', g_Config.BonusAbilofWizard.MAC);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardHP', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardHP', g_Config.BonusAbilofWizard.HP);
  g_Config.BonusAbilofWizard.HP := Config.ReadInteger('Setup', 'BonusAbilofWizardHP', g_Config.BonusAbilofWizard.HP);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardMP', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardMP', g_Config.BonusAbilofWizard.MP);
  g_Config.BonusAbilofWizard.MP := Config.ReadInteger('Setup', 'BonusAbilofWizardMP', g_Config.BonusAbilofWizard.MP);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardHit', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardHit', g_Config.BonusAbilofWizard.Hit);
  g_Config.BonusAbilofWizard.Hit := Config.ReadInteger('Setup', 'BonusAbilofWizardHit', g_Config.BonusAbilofWizard.Hit);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardSpeed', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardSpeed', g_Config.BonusAbilofWizard.Speed);
  g_Config.BonusAbilofWizard.Speed := Config.ReadInteger('Setup', 'BonusAbilofWizardSpeed', g_Config.BonusAbilofWizard.Speed);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardX2', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardX2', g_Config.BonusAbilofWizard.X2);
  g_Config.BonusAbilofWizard.X2 := Config.ReadInteger('Setup', 'BonusAbilofWizardX2', g_Config.BonusAbilofWizard.X2);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosDC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosDC', g_Config.BonusAbilofTaos.DC);
  g_Config.BonusAbilofTaos.DC := Config.ReadInteger('Setup', 'BonusAbilofTaosDC', g_Config.BonusAbilofTaos.DC);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosMC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosMC', g_Config.BonusAbilofTaos.MC);
  g_Config.BonusAbilofTaos.MC := Config.ReadInteger('Setup', 'BonusAbilofTaosMC', g_Config.BonusAbilofTaos.MC);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosSC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosSC', g_Config.BonusAbilofTaos.SC);
  g_Config.BonusAbilofTaos.SC := Config.ReadInteger('Setup', 'BonusAbilofTaosSC', g_Config.BonusAbilofTaos.SC);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosAC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosAC', g_Config.BonusAbilofTaos.AC);
  g_Config.BonusAbilofTaos.AC := Config.ReadInteger('Setup', 'BonusAbilofTaosAC', g_Config.BonusAbilofTaos.AC);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosMAC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosMAC', g_Config.BonusAbilofTaos.MAC);
  g_Config.BonusAbilofTaos.MAC := Config.ReadInteger('Setup', 'BonusAbilofTaosMAC', g_Config.BonusAbilofTaos.MAC);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosHP', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosHP', g_Config.BonusAbilofTaos.HP);
  g_Config.BonusAbilofTaos.HP := Config.ReadInteger('Setup', 'BonusAbilofTaosHP', g_Config.BonusAbilofTaos.HP);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosMP', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosMP', g_Config.BonusAbilofTaos.MP);
  g_Config.BonusAbilofTaos.MP := Config.ReadInteger('Setup', 'BonusAbilofTaosMP', g_Config.BonusAbilofTaos.MP);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosHit', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosHit', g_Config.BonusAbilofTaos.Hit);
  g_Config.BonusAbilofTaos.Hit := Config.ReadInteger('Setup', 'BonusAbilofTaosHit', g_Config.BonusAbilofTaos.Hit);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosSpeed', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosSpeed', g_Config.BonusAbilofTaos.Speed);
  g_Config.BonusAbilofTaos.Speed := Config.ReadInteger('Setup', 'BonusAbilofTaosSpeed', g_Config.BonusAbilofTaos.Speed);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosX2', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosX2', g_Config.BonusAbilofTaos.X2);
  g_Config.BonusAbilofTaos.X2 := Config.ReadInteger('Setup', 'BonusAbilofTaosX2', g_Config.BonusAbilofTaos.X2);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrDC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrDC', g_Config.NakedAbilofWarr.DC);
  g_Config.NakedAbilofWarr.DC := Config.ReadInteger('Setup', 'NakedAbilofWarrDC', g_Config.NakedAbilofWarr.DC);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrMC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrMC', g_Config.NakedAbilofWarr.MC);
  g_Config.NakedAbilofWarr.MC := Config.ReadInteger('Setup', 'NakedAbilofWarrMC', g_Config.NakedAbilofWarr.MC);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrSC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrSC', g_Config.NakedAbilofWarr.SC);
  g_Config.NakedAbilofWarr.SC := Config.ReadInteger('Setup', 'NakedAbilofWarrSC', g_Config.NakedAbilofWarr.SC);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrAC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrAC', g_Config.NakedAbilofWarr.AC);
  g_Config.NakedAbilofWarr.AC := Config.ReadInteger('Setup', 'NakedAbilofWarrAC', g_Config.NakedAbilofWarr.AC);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrMAC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrMAC', g_Config.NakedAbilofWarr.MAC);
  g_Config.NakedAbilofWarr.MAC := Config.ReadInteger('Setup', 'NakedAbilofWarrMAC', g_Config.NakedAbilofWarr.MAC);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrHP', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrHP', g_Config.NakedAbilofWarr.HP);
  g_Config.NakedAbilofWarr.HP := Config.ReadInteger('Setup', 'NakedAbilofWarrHP', g_Config.NakedAbilofWarr.HP);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrMP', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrMP', g_Config.NakedAbilofWarr.MP);
  g_Config.NakedAbilofWarr.MP := Config.ReadInteger('Setup', 'NakedAbilofWarrMP', g_Config.NakedAbilofWarr.MP);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrHit', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrHit', g_Config.NakedAbilofWarr.Hit);
  g_Config.NakedAbilofWarr.Hit := Config.ReadInteger('Setup', 'NakedAbilofWarrHit', g_Config.NakedAbilofWarr.Hit);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrSpeed', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrSpeed', g_Config.NakedAbilofWarr.Speed);
  g_Config.NakedAbilofWarr.Speed := Config.ReadInteger('Setup', 'NakedAbilofWarrSpeed', g_Config.NakedAbilofWarr.Speed);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrX2', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrX2', g_Config.NakedAbilofWarr.X2);
  g_Config.NakedAbilofWarr.X2 := Config.ReadInteger('Setup', 'NakedAbilofWarrX2', g_Config.NakedAbilofWarr.X2);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardDC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardDC', g_Config.NakedAbilofWizard.DC);
  g_Config.NakedAbilofWizard.DC := Config.ReadInteger('Setup', 'NakedAbilofWizardDC', g_Config.NakedAbilofWizard.DC);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardMC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardMC', g_Config.NakedAbilofWizard.MC);
  g_Config.NakedAbilofWizard.MC := Config.ReadInteger('Setup', 'NakedAbilofWizardMC', g_Config.NakedAbilofWizard.MC);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardSC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardSC', g_Config.NakedAbilofWizard.SC);
  g_Config.NakedAbilofWizard.SC := Config.ReadInteger('Setup', 'NakedAbilofWizardSC', g_Config.NakedAbilofWizard.SC);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardAC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardAC', g_Config.NakedAbilofWizard.AC);
  g_Config.NakedAbilofWizard.AC := Config.ReadInteger('Setup', 'NakedAbilofWizardAC', g_Config.NakedAbilofWizard.AC);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardMAC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardMAC', g_Config.NakedAbilofWizard.MAC);
  g_Config.NakedAbilofWizard.MAC := Config.ReadInteger('Setup', 'NakedAbilofWizardMAC', g_Config.NakedAbilofWizard.MAC);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardHP', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardHP', g_Config.NakedAbilofWizard.HP);
  g_Config.NakedAbilofWizard.HP := Config.ReadInteger('Setup', 'NakedAbilofWizardHP', g_Config.NakedAbilofWizard.HP);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardMP', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardMP', g_Config.NakedAbilofWizard.MP);
  g_Config.NakedAbilofWizard.MP := Config.ReadInteger('Setup', 'NakedAbilofWizardMP', g_Config.NakedAbilofWizard.MP);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardHit', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardHit', g_Config.NakedAbilofWizard.Hit);
  g_Config.NakedAbilofWizard.Hit := Config.ReadInteger('Setup', 'NakedAbilofWizardHit', g_Config.NakedAbilofWizard.Hit);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardSpeed', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardSpeed', g_Config.NakedAbilofWizard.Speed);
  g_Config.NakedAbilofWizard.Speed := Config.ReadInteger('Setup', 'NakedAbilofWizardSpeed', g_Config.NakedAbilofWizard.Speed);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardX2', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardX2', g_Config.NakedAbilofWizard.X2);
  g_Config.NakedAbilofWizard.X2 := Config.ReadInteger('Setup', 'NakedAbilofWizardX2', g_Config.NakedAbilofWizard.X2);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosDC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosDC', g_Config.NakedAbilofTaos.DC);
  g_Config.NakedAbilofTaos.DC := Config.ReadInteger('Setup', 'NakedAbilofTaosDC', g_Config.NakedAbilofTaos.DC);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosMC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosMC', g_Config.NakedAbilofTaos.MC);
  g_Config.NakedAbilofTaos.MC := Config.ReadInteger('Setup', 'NakedAbilofTaosMC', g_Config.NakedAbilofTaos.MC);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosSC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosSC', g_Config.NakedAbilofTaos.SC);
  g_Config.NakedAbilofTaos.SC := Config.ReadInteger('Setup', 'NakedAbilofTaosSC', g_Config.NakedAbilofTaos.SC);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosAC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosAC', g_Config.NakedAbilofTaos.AC);
  g_Config.NakedAbilofTaos.AC := Config.ReadInteger('Setup', 'NakedAbilofTaosAC', g_Config.NakedAbilofTaos.AC);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosMAC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosMAC', g_Config.NakedAbilofTaos.MAC);
  g_Config.NakedAbilofTaos.MAC := Config.ReadInteger('Setup', 'NakedAbilofTaosMAC', g_Config.NakedAbilofTaos.MAC);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosHP', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosHP', g_Config.NakedAbilofTaos.HP);
  g_Config.NakedAbilofTaos.HP := Config.ReadInteger('Setup', 'NakedAbilofTaosHP', g_Config.NakedAbilofTaos.HP);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosMP', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosMP', g_Config.NakedAbilofTaos.MP);
  g_Config.NakedAbilofTaos.MP := Config.ReadInteger('Setup', 'NakedAbilofTaosMP', g_Config.NakedAbilofTaos.MP);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosHit', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosHit', g_Config.NakedAbilofTaos.Hit);
  g_Config.NakedAbilofTaos.Hit := Config.ReadInteger('Setup', 'NakedAbilofTaosHit', g_Config.NakedAbilofTaos.Hit);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosSpeed', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosSpeed', g_Config.NakedAbilofTaos.Speed);
  g_Config.NakedAbilofTaos.Speed := Config.ReadInteger('Setup', 'NakedAbilofTaosSpeed', g_Config.NakedAbilofTaos.Speed);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosX2', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosX2', g_Config.NakedAbilofTaos.X2);
  g_Config.NakedAbilofTaos.X2 := Config.ReadInteger('Setup', 'NakedAbilofTaosX2', g_Config.NakedAbilofTaos.X2);

  if Config.ReadInteger('Setup', 'GroupMembersMax', -1) < 0 then
    Config.WriteInteger('Setup', 'GroupMembersMax', g_Config.nGroupMembersMax);
  g_Config.nGroupMembersMax := Config.ReadInteger('Setup', 'GroupMembersMax', g_Config.nGroupMembersMax);


  if Config.ReadInteger('Setup', 'UPgradeWeaponGetBackTime', -1) < 0 then
    Config.WriteInteger('Setup', 'UPgradeWeaponGetBackTime', g_Config.dwUPgradeWeaponGetBackTime);
  g_Config.dwUPgradeWeaponGetBackTime := Config.ReadInteger('Setup', 'UPgradeWeaponGetBackTime', g_Config.dwUPgradeWeaponGetBackTime);

  if Config.ReadInteger('Setup', 'ClearExpireUpgradeWeaponDays', -1) < 0 then
    Config.WriteInteger('Setup', 'ClearExpireUpgradeWeaponDays', g_Config.nClearExpireUpgradeWeaponDays);
  g_Config.nClearExpireUpgradeWeaponDays := Config.ReadInteger('Setup', 'ClearExpireUpgradeWeaponDays', g_Config.nClearExpireUpgradeWeaponDays);

  if Config.ReadInteger('Setup', 'UpgradeWeaponPrice', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponPrice', g_Config.nUpgradeWeaponPrice);
  g_Config.nUpgradeWeaponPrice := Config.ReadInteger('Setup', 'UpgradeWeaponPrice', g_Config.nUpgradeWeaponPrice);

  if Config.ReadInteger('Setup', 'UpgradeWeaponMaxPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponMaxPoint', g_Config.nUpgradeWeaponMaxPoint);
  g_Config.nUpgradeWeaponMaxPoint := Config.ReadInteger('Setup', 'UpgradeWeaponMaxPoint', g_Config.nUpgradeWeaponMaxPoint);

  if Config.ReadInteger('Setup', 'UpgradeWeaponDCRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponDCRate', g_Config.nUpgradeWeaponDCRate);
  g_Config.nUpgradeWeaponDCRate := Config.ReadInteger('Setup', 'UpgradeWeaponDCRate', g_Config.nUpgradeWeaponDCRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponDCTwoPointRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponDCTwoPointRate', g_Config.nUpgradeWeaponDCTwoPointRate);
  g_Config.nUpgradeWeaponDCTwoPointRate := Config.ReadInteger('Setup', 'UpgradeWeaponDCTwoPointRate', g_Config.nUpgradeWeaponDCTwoPointRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponDCThreePointRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponDCThreePointRate', g_Config.nUpgradeWeaponDCThreePointRate);
  g_Config.nUpgradeWeaponDCThreePointRate := Config.ReadInteger('Setup', 'UpgradeWeaponDCThreePointRate', g_Config.nUpgradeWeaponDCThreePointRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponMCRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponMCRate', g_Config.nUpgradeWeaponMCRate);
  g_Config.nUpgradeWeaponMCRate := Config.ReadInteger('Setup', 'UpgradeWeaponMCRate', g_Config.nUpgradeWeaponMCRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponMCTwoPointRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponMCTwoPointRate', g_Config.nUpgradeWeaponMCTwoPointRate);
  g_Config.nUpgradeWeaponMCTwoPointRate := Config.ReadInteger('Setup', 'UpgradeWeaponMCTwoPointRate', g_Config.nUpgradeWeaponMCTwoPointRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponMCThreePointRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponMCThreePointRate', g_Config.nUpgradeWeaponMCThreePointRate);
  g_Config.nUpgradeWeaponMCThreePointRate := Config.ReadInteger('Setup', 'UpgradeWeaponMCThreePointRate', g_Config.nUpgradeWeaponMCThreePointRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponSCRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponSCRate', g_Config.nUpgradeWeaponSCRate);
  g_Config.nUpgradeWeaponSCRate := Config.ReadInteger('Setup', 'UpgradeWeaponSCRate', g_Config.nUpgradeWeaponSCRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponSCTwoPointRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponSCTwoPointRate', g_Config.nUpgradeWeaponSCTwoPointRate);
  g_Config.nUpgradeWeaponSCTwoPointRate := Config.ReadInteger('Setup', 'UpgradeWeaponSCTwoPointRate', g_Config.nUpgradeWeaponSCTwoPointRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponSCThreePointRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponSCThreePointRate', g_Config.nUpgradeWeaponSCThreePointRate);
  g_Config.nUpgradeWeaponSCThreePointRate := Config.ReadInteger('Setup', 'UpgradeWeaponSCThreePointRate', g_Config.nUpgradeWeaponSCThreePointRate);

  if Config.ReadInteger('Setup', 'BuildGuild', -1) < 0 then
    Config.WriteInteger('Setup', 'BuildGuild', g_Config.nBuildGuildPrice);
  g_Config.nBuildGuildPrice := Config.ReadInteger('Setup', 'BuildGuild', g_Config.nBuildGuildPrice);

  if Config.ReadInteger('Setup', 'MakeDurg', -1) < 0 then
    Config.WriteInteger('Setup', 'MakeDurg', g_Config.nMakeDurgPrice);
  g_Config.nMakeDurgPrice := Config.ReadInteger('Setup', 'MakeDurg', g_Config.nMakeDurgPrice);

  if Config.ReadInteger('Setup', 'GuildWarFee', -1) < 0 then
    Config.WriteInteger('Setup', 'GuildWarFee', g_Config.nGuildWarPrice);
  g_Config.nGuildWarPrice := Config.ReadInteger('Setup', 'GuildWarFee', g_Config.nGuildWarPrice);

  if Config.ReadInteger('Setup', 'HireGuard', -1) < 0 then
    Config.WriteInteger('Setup', 'HireGuard', g_Config.nHireGuardPrice);
  g_Config.nHireGuardPrice := Config.ReadInteger('Setup', 'HireGuard', g_Config.nHireGuardPrice);

  if Config.ReadInteger('Setup', 'HireArcher', -1) < 0 then
    Config.WriteInteger('Setup', 'HireArcher', g_Config.nHireArcherPrice);
  g_Config.nHireArcherPrice := Config.ReadInteger('Setup', 'HireArcher', g_Config.nHireArcherPrice);

  if Config.ReadInteger('Setup', 'RepairDoor', -1) < 0 then
    Config.WriteInteger('Setup', 'RepairDoor', g_Config.nRepairDoorPrice);
  g_Config.nRepairDoorPrice := Config.ReadInteger('Setup', 'RepairDoor', g_Config.nRepairDoorPrice);

  if Config.ReadInteger('Setup', 'RepairWall', -1) < 0 then
    Config.WriteInteger('Setup', 'RepairWall', g_Config.nRepairWallPrice);
  g_Config.nRepairWallPrice := Config.ReadInteger('Setup', 'RepairWall', g_Config.nRepairWallPrice);

  if Config.ReadInteger('Setup', 'CastleMemberPriceRate', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleMemberPriceRate', g_Config.nCastleMemberPriceRate);
  g_Config.nCastleMemberPriceRate := Config.ReadInteger('Setup', 'CastleMemberPriceRate', g_Config.nCastleMemberPriceRate);

  if Config.ReadInteger('Setup', 'CastleGoldMax', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleGoldMax', g_Config.nCastleGoldMax);
  g_Config.nCastleGoldMax := Config.ReadInteger('Setup', 'CastleGoldMax', g_Config.nCastleGoldMax);

  if Config.ReadInteger('Setup', 'CastleOneDayGold', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleOneDayGold', g_Config.nCastleOneDayGold);
  g_Config.nCastleOneDayGold := Config.ReadInteger('Setup', 'CastleOneDayGold', g_Config.nCastleOneDayGold);

  if Config.ReadString('Setup', 'CastleName', '') = '' then
    Config.WriteString('Setup', 'CastleName', g_Config.sCASTLENAME);
  g_Config.sCASTLENAME := Config.ReadString('Setup', 'CastleName', g_Config.sCASTLENAME);

  if Config.ReadString('Setup', 'CastleHomeMap', '') = '' then
    Config.WriteString('Setup', 'CastleHomeMap', g_Config.sCastleHomeMap);
  g_Config.sCastleHomeMap := Config.ReadString('Setup', 'CastleHomeMap', g_Config.sCastleHomeMap);

  if Config.ReadInteger('Setup', 'CastleHomeX', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleHomeX', g_Config.nCastleHomeX);
  g_Config.nCastleHomeX := Config.ReadInteger('Setup', 'CastleHomeX', g_Config.nCastleHomeX);

  if Config.ReadInteger('Setup', 'CastleHomeY', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleHomeY', g_Config.nCastleHomeY);
  g_Config.nCastleHomeY := Config.ReadInteger('Setup', 'CastleHomeY', g_Config.nCastleHomeY);

  if Config.ReadInteger('Setup', 'CastleWarRangeX', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleWarRangeX', g_Config.nCastleWarRangeX);
  g_Config.nCastleWarRangeX := Config.ReadInteger('Setup', 'CastleWarRangeX', g_Config.nCastleWarRangeX);

  if Config.ReadInteger('Setup', 'CastleWarRangeY', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleWarRangeY', g_Config.nCastleWarRangeY);
  g_Config.nCastleWarRangeY := Config.ReadInteger('Setup', 'CastleWarRangeY', g_Config.nCastleWarRangeY);

  if Config.ReadInteger('Setup', 'CastleTaxRate', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleTaxRate', g_Config.nCastleTaxRate);
  g_Config.nCastleTaxRate := Config.ReadInteger('Setup', 'CastleTaxRate', g_Config.nCastleTaxRate);

  if Config.ReadInteger('Setup', 'CastleGetAllNpcTax', -1) < 0 then
    Config.WriteBool('Setup', 'CastleGetAllNpcTax', g_Config.boGetAllNpcTax);
  g_Config.boGetAllNpcTax := Config.ReadBool('Setup', 'CastleGetAllNpcTax', g_Config.boGetAllNpcTax);

  nLoadInteger := Config.ReadInteger('Setup', 'GenMonRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'GenMonRate', g_Config.nMonGenRate)
  else g_Config.nMonGenRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'ProcessMonRandRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'ProcessMonRandRate', g_Config.nProcessMonRandRate)
  else g_Config.nProcessMonRandRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'ProcessMonLimitCount', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'ProcessMonLimitCount', g_Config.nProcessMonLimitCount)
  else g_Config.nProcessMonLimitCount := nLoadInteger;

  if Config.ReadInteger('Setup', 'HumanMaxGold', -1) < 0 then
    Config.WriteInteger('Setup', 'HumanMaxGold', g_Config.nHumanMaxGold);
  g_Config.nHumanMaxGold := Config.ReadInteger('Setup', 'HumanMaxGold', g_Config.nHumanMaxGold);

  if Config.ReadInteger('Setup', 'HumanTryModeMaxGold', -1) < 0 then
    Config.WriteInteger('Setup', 'HumanTryModeMaxGold', g_Config.nHumanTryModeMaxGold);
  g_Config.nHumanTryModeMaxGold := Config.ReadInteger('Setup', 'HumanTryModeMaxGold', g_Config.nHumanTryModeMaxGold);

  if Config.ReadInteger('Setup', 'TryModeLevel', -1) < 0 then
    Config.WriteInteger('Setup', 'TryModeLevel', g_Config.nTryModeLevel);
  g_Config.nTryModeLevel := Config.ReadInteger('Setup', 'TryModeLevel', g_Config.nTryModeLevel);

  if Config.ReadInteger('Setup', 'TryModeUseStorage', -1) < 0 then
    Config.WriteBool('Setup', 'TryModeUseStorage', g_Config.boTryModeUseStorage);
  g_Config.boTryModeUseStorage := Config.ReadBool('Setup', 'TryModeUseStorage', g_Config.boTryModeUseStorage);

  if Config.ReadInteger('Setup', 'ShutRedMsgShowGMName', -1) < 0 then
    Config.WriteBool('Setup', 'ShutRedMsgShowGMName', g_Config.boShutRedMsgShowGMName);
  g_Config.boShutRedMsgShowGMName := Config.ReadBool('Setup', 'ShutRedMsgShowGMName', g_Config.boShutRedMsgShowGMName);

  if Config.ReadInteger('Setup', 'ShowMakeItemMsg', -1) < 0 then
    Config.WriteBool('Setup', 'ShowMakeItemMsg', g_Config.boShowMakeItemMsg);
  g_Config.boShowMakeItemMsg := Config.ReadBool('Setup', 'ShowMakeItemMsg', g_Config.boShowMakeItemMsg);

  if Config.ReadInteger('Setup', 'ShowGuildName', -1) < 0 then
    Config.WriteBool('Setup', 'ShowGuildName', g_Config.boShowGuildName);
  g_Config.boShowGuildName := Config.ReadBool('Setup', 'ShowGuildName', g_Config.boShowGuildName);

  if Config.ReadInteger('Setup', 'ShowRankLevelName', -1) < 0 then
    Config.WriteBool('Setup', 'ShowRankLevelName', g_Config.boShowRankLevelName);
  g_Config.boShowRankLevelName := Config.ReadBool('Setup', 'ShowRankLevelName', g_Config.boShowRankLevelName);

  if Config.ReadInteger('Setup', 'MonSayMsg', -1) < 0 then
    Config.WriteBool('Setup', 'MonSayMsg', g_Config.boMonSayMsg);
  g_Config.boMonSayMsg := Config.ReadBool('Setup', 'MonSayMsg', g_Config.boMonSayMsg);

  if Config.ReadInteger('Setup', 'SayMsgMaxLen', -1) < 0 then
    Config.WriteInteger('Setup', 'SayMsgMaxLen', g_Config.nSayMsgMaxLen);
  g_Config.nSayMsgMaxLen := Config.ReadInteger('Setup', 'SayMsgMaxLen', g_Config.nSayMsgMaxLen);

  if Config.ReadInteger('Setup', 'SayMsgTime', -1) < 0 then
    Config.WriteInteger('Setup', 'SayMsgTime', g_Config.dwSayMsgTime);
  g_Config.dwSayMsgTime := Config.ReadInteger('Setup', 'SayMsgTime', g_Config.dwSayMsgTime);

  if Config.ReadInteger('Setup', 'SayMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'SayMsgCount', g_Config.nSayMsgCount);
  g_Config.nSayMsgCount := Config.ReadInteger('Setup', 'SayMsgCount', g_Config.nSayMsgCount);

  if Config.ReadInteger('Setup', 'DisableSayMsgTime', -1) < 0 then
    Config.WriteInteger('Setup', 'DisableSayMsgTime', g_Config.dwDisableSayMsgTime);
  g_Config.dwDisableSayMsgTime := Config.ReadInteger('Setup', 'DisableSayMsgTime', g_Config.dwDisableSayMsgTime);

  if Config.ReadInteger('Setup', 'SayRedMsgMaxLen', -1) < 0 then
    Config.WriteInteger('Setup', 'SayRedMsgMaxLen', g_Config.nSayRedMsgMaxLen);
  g_Config.nSayRedMsgMaxLen := Config.ReadInteger('Setup', 'SayRedMsgMaxLen', g_Config.nSayRedMsgMaxLen);

  if Config.ReadInteger('Setup', 'CanShoutMsgLevel', -1) < 0 then
    Config.WriteInteger('Setup', 'CanShoutMsgLevel', g_Config.nCanShoutMsgLevel);
  g_Config.nCanShoutMsgLevel := Config.ReadInteger('Setup', 'CanShoutMsgLevel', g_Config.nCanShoutMsgLevel);

  if Config.ReadInteger('Setup', 'StartPermission', -1) < 0 then
    Config.WriteInteger('Setup', 'StartPermission', g_Config.nStartPermission);
  g_Config.nStartPermission := Config.ReadInteger('Setup', 'StartPermission', g_Config.nStartPermission);

  if Config.ReadInteger('Setup', 'SendRefMsgRange', -1) < 0 then
    Config.WriteInteger('Setup', 'SendRefMsgRange', g_Config.nSendRefMsgRange);
  g_Config.nSendRefMsgRange := Config.ReadInteger('Setup', 'SendRefMsgRange', g_Config.nSendRefMsgRange);

  if Config.ReadInteger('Setup', 'DecLampDura', -1) < 0 then
    Config.WriteBool('Setup', 'DecLampDura', g_Config.boDecLampDura);
  g_Config.boDecLampDura := Config.ReadBool('Setup', 'DecLampDura', g_Config.boDecLampDura);

  if Config.ReadInteger('Setup', 'HungerSystem', -1) < 0 then
    Config.WriteBool('Setup', 'HungerSystem', g_Config.boHungerSystem);
  g_Config.boHungerSystem := Config.ReadBool('Setup', 'HungerSystem', g_Config.boHungerSystem);

  if Config.ReadInteger('Setup', 'HungerDecHP', -1) < 0 then
    Config.WriteBool('Setup', 'HungerDecHP', g_Config.boHungerDecHP);
  g_Config.boHungerDecHP := Config.ReadBool('Setup', 'HungerDecHP', g_Config.boHungerDecHP);

  if Config.ReadInteger('Setup', 'HungerDecPower', -1) < 0 then
    Config.WriteBool('Setup', 'HungerDecPower', g_Config.boHungerDecPower);
  g_Config.boHungerDecPower := Config.ReadBool('Setup', 'HungerDecPower', g_Config.boHungerDecPower);

  if Config.ReadInteger('Setup', 'DiableHumanRun', -1) < 0 then
    Config.WriteBool('Setup', 'DiableHumanRun', g_Config.boDiableHumanRun);
  g_Config.boDiableHumanRun := Config.ReadBool('Setup', 'DiableHumanRun', g_Config.boDiableHumanRun);

  if Config.ReadInteger('Setup', 'RunHuman', -1) < 0 then
    Config.WriteBool('Setup', 'RunHuman', g_Config.boRUNHUMAN);
  g_Config.boRUNHUMAN := Config.ReadBool('Setup', 'RunHuman', g_Config.boRUNHUMAN);

  if Config.ReadInteger('Setup', 'RunMon', -1) < 0 then
    Config.WriteBool('Setup', 'RunMon', g_Config.boRUNMON);
  g_Config.boRUNMON := Config.ReadBool('Setup', 'RunMon', g_Config.boRUNMON);

  if Config.ReadInteger('Setup', 'RunNpc', -1) < 0 then
    Config.WriteBool('Setup', 'RunNpc', g_Config.boRunNpc);
  g_Config.boRunNpc := Config.ReadBool('Setup', 'RunNpc', g_Config.boRunNpc);

  nLoadInteger := Config.ReadInteger('Setup', 'RunGuard', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'RunGuard', g_Config.boRunGuard)
  else g_Config.boRunGuard := nLoadInteger = 1;

  if Config.ReadInteger('Setup', 'WarDisableHumanRun', -1) < 0 then
    Config.WriteBool('Setup', 'WarDisableHumanRun', g_Config.boWarDisHumRun);
  g_Config.boWarDisHumRun := Config.ReadBool('Setup', 'WarDisableHumanRun', g_Config.boWarDisHumRun);

  if Config.ReadInteger('Setup', 'GMRunAll', -1) < 0 then
    Config.WriteBool('Setup', 'GMRunAll', g_Config.boGMRunAll);
  g_Config.boGMRunAll := Config.ReadBool('Setup', 'GMRunAll', g_Config.boGMRunAll);

  if Config.ReadInteger('Setup', 'SkeletonCount', -1) < 0 then
    Config.WriteInteger('Setup', 'SkeletonCount', g_Config.nSkeletonCount);
  g_Config.nSkeletonCount := Config.ReadInteger('Setup', 'SkeletonCount', g_Config.nSkeletonCount);

  for i := Low(g_Config.SkeletonArray) to High(g_Config.SkeletonArray) do
  begin
    if Config.ReadInteger('Setup', 'SkeletonHumLevel' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'SkeletonHumLevel' + IntToStr(i), g_Config.SkeletonArray[i].nHumLevel);
    g_Config.SkeletonArray[i].nHumLevel := Config.ReadInteger('Setup', 'SkeletonHumLevel' + IntToStr(i), g_Config.SkeletonArray[i].nHumLevel);

    if Config.ReadString('Names', 'Skeleton' + IntToStr(i), '') = '' then
      Config.WriteString('Names', 'Skeleton' + IntToStr(i), g_Config.SkeletonArray[i].sMonName);
    g_Config.SkeletonArray[i].sMonName := Config.ReadString('Names', 'Skeleton' + IntToStr(i), g_Config.SkeletonArray[i].sMonName);

    if Config.ReadInteger('Setup', 'SkeletonCount' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'SkeletonCount' + IntToStr(i), g_Config.SkeletonArray[i].nCount);
    g_Config.SkeletonArray[i].nCount := Config.ReadInteger('Setup', 'SkeletonCount' + IntToStr(i), g_Config.SkeletonArray[i].nCount);

    if Config.ReadInteger('Setup', 'SkeletonLevel' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'SkeletonLevel' + IntToStr(i), g_Config.SkeletonArray[i].nLevel);
    g_Config.SkeletonArray[i].nLevel := Config.ReadInteger('Setup', 'SkeletonLevel' + IntToStr(i), g_Config.SkeletonArray[i].nLevel);
  end;

  if Config.ReadInteger('Setup', 'DragonCount', -1) < 0 then
    Config.WriteInteger('Setup', 'DragonCount', g_Config.nDragonCount);
  g_Config.nDragonCount := Config.ReadInteger('Setup', 'DragonCount', g_Config.nDragonCount);

  for i := Low(g_Config.DragonArray) to High(g_Config.DragonArray) do
  begin
    if Config.ReadInteger('Setup', 'DragonHumLevel' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'DragonHumLevel' + IntToStr(i), g_Config.DragonArray[i].nHumLevel);
    g_Config.DragonArray[i].nHumLevel := Config.ReadInteger('Setup', 'DragonHumLevel' + IntToStr(i), g_Config.DragonArray[i].nHumLevel);

    if Config.ReadString('Names', 'Dragon' + IntToStr(i), '') = '' then
      Config.WriteString('Names', 'Dragon' + IntToStr(i), g_Config.DragonArray[i].sMonName);
    g_Config.DragonArray[i].sMonName := Config.ReadString('Names', 'Dragon' + IntToStr(i), g_Config.DragonArray[i].sMonName);

    if Config.ReadInteger('Setup', 'DragonCount' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'DragonCount' + IntToStr(i), g_Config.DragonArray[i].nCount);
    g_Config.DragonArray[i].nCount := Config.ReadInteger('Setup', 'DragonCount' + IntToStr(i), g_Config.DragonArray[i].nCount);

    if Config.ReadInteger('Setup', 'DragonLevel' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'DragonLevel' + IntToStr(i), g_Config.DragonArray[i].nLevel);
    g_Config.DragonArray[i].nLevel := Config.ReadInteger('Setup', 'DragonLevel' + IntToStr(i), g_Config.DragonArray[i].nLevel);
  end;

  if Config.ReadInteger('Setup', 'TryDealTime', -1) < 0 then
    Config.WriteInteger('Setup', 'TryDealTime', g_Config.dwTryDealTime);
  g_Config.dwTryDealTime := Config.ReadInteger('Setup', 'TryDealTime', g_Config.dwTryDealTime);

  if Config.ReadInteger('Setup', 'DealOKTime', -1) < 0 then
    Config.WriteInteger('Setup', 'DealOKTime', g_Config.dwDealOKTime);
  g_Config.dwDealOKTime := Config.ReadInteger('Setup', 'DealOKTime', g_Config.dwDealOKTime);

  if Config.ReadInteger('Setup', 'CanNotGetBackDeal', -1) < 0 then
    Config.WriteBool('Setup', 'CanNotGetBackDeal', g_Config.boCanNotGetBackDeal);
  g_Config.boCanNotGetBackDeal := Config.ReadBool('Setup', 'CanNotGetBackDeal', g_Config.boCanNotGetBackDeal);

  if Config.ReadInteger('Setup', 'DisableDeal', -1) < 0 then
    Config.WriteBool('Setup', 'DisableDeal', g_Config.boDisableDeal);
  g_Config.boDisableDeal := Config.ReadBool('Setup', 'DisableDeal', g_Config.boDisableDeal);

  if Config.ReadInteger('Setup', 'MasterOKLevel', -1) < 0 then
    Config.WriteInteger('Setup', 'MasterOKLevel', g_Config.nMasterOKLevel);
  g_Config.nMasterOKLevel := Config.ReadInteger('Setup', 'MasterOKLevel', g_Config.nMasterOKLevel);

  if Config.ReadInteger('Setup', 'MasterOKCreditPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'MasterOKCreditPoint', g_Config.nMasterOKCreditPoint);
  g_Config.nMasterOKCreditPoint := Config.ReadInteger('Setup', 'MasterOKCreditPoint', g_Config.nMasterOKCreditPoint);

  if Config.ReadInteger('Setup', 'MasterOKBonusPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'MasterOKBonusPoint', g_Config.nMasterOKBonusPoint);
  g_Config.nMasterOKBonusPoint := Config.ReadInteger('Setup', 'MasterOKBonusPoint', g_Config.nMasterOKBonusPoint);

  if Config.ReadInteger('Setup', 'PKProtect', -1) < 0 then
    Config.WriteBool('Setup', 'PKProtect', g_Config.boPKLevelProtect);
  g_Config.boPKLevelProtect := Config.ReadBool('Setup', 'PKProtect', g_Config.boPKLevelProtect);

  if Config.ReadInteger('Setup', 'PKProtectLevel', -1) < 0 then
    Config.WriteInteger('Setup', 'PKProtectLevel', g_Config.nPKProtectLevel);
  g_Config.nPKProtectLevel := Config.ReadInteger('Setup', 'PKProtectLevel', g_Config.nPKProtectLevel);

  if Config.ReadInteger('Setup', 'RedPKProtectLevel', -1) < 0 then
    Config.WriteInteger('Setup', 'RedPKProtectLevel', g_Config.nRedPKProtectLevel);
  g_Config.nRedPKProtectLevel := Config.ReadInteger('Setup', 'RedPKProtectLevel', g_Config.nRedPKProtectLevel);

  if Config.ReadInteger('Setup', 'ItemPowerRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemPowerRate', g_Config.nItemPowerRate);
  g_Config.nItemPowerRate := Config.ReadInteger('Setup', 'ItemPowerRate', g_Config.nItemPowerRate);

  if Config.ReadInteger('Setup', 'ItemExpRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemExpRate', g_Config.nItemExpRate);
  g_Config.nItemExpRate := Config.ReadInteger('Setup', 'ItemExpRate', g_Config.nItemExpRate);

  if Config.ReadInteger('Setup', 'ScriptGotoCountLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'ScriptGotoCountLimit', g_Config.nScriptGotoCountLimit);
  g_Config.nScriptGotoCountLimit := Config.ReadInteger('Setup', 'ScriptGotoCountLimit', g_Config.nScriptGotoCountLimit);

  if Config.ReadInteger('Setup', 'HearMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'HearMsgFColor', g_Config.btHearMsgFColor);
  g_Config.btHearMsgFColor := Config.ReadInteger('Setup', 'HearMsgFColor', g_Config.btHearMsgFColor);

  if Config.ReadInteger('Setup', 'HearMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'HearMsgBColor', g_Config.btHearMsgBColor);
  g_Config.btHearMsgBColor := Config.ReadInteger('Setup', 'HearMsgBColor', g_Config.btHearMsgBColor);

  if Config.ReadInteger('Setup', 'WhisperMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'WhisperMsgFColor', g_Config.btWhisperMsgFColor);
  g_Config.btWhisperMsgFColor := Config.ReadInteger('Setup', 'WhisperMsgFColor', g_Config.btWhisperMsgFColor);

  if Config.ReadInteger('Setup', 'WhisperMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'WhisperMsgBColor', g_Config.btWhisperMsgBColor);
  g_Config.btWhisperMsgBColor := Config.ReadInteger('Setup', 'WhisperMsgBColor', g_Config.btWhisperMsgBColor);

  if Config.ReadInteger('Setup', 'GMWhisperMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GMWhisperMsgFColor', g_Config.btGMWhisperMsgFColor);
  g_Config.btGMWhisperMsgFColor := Config.ReadInteger('Setup', 'GMWhisperMsgFColor', g_Config.btGMWhisperMsgFColor);

  if Config.ReadInteger('Setup', 'GMWhisperMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GMWhisperMsgBColor', g_Config.btGMWhisperMsgBColor);
  g_Config.btGMWhisperMsgBColor := Config.ReadInteger('Setup', 'GMWhisperMsgBColor', g_Config.btGMWhisperMsgBColor);

  if Config.ReadInteger('Setup', 'CryMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'CryMsgFColor', g_Config.btCryMsgFColor);
  g_Config.btCryMsgFColor := Config.ReadInteger('Setup', 'CryMsgFColor', g_Config.btCryMsgFColor);

  if Config.ReadInteger('Setup', 'CryMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'CryMsgBColor', g_Config.btCryMsgBColor);
  g_Config.btCryMsgBColor := Config.ReadInteger('Setup', 'CryMsgBColor', g_Config.btCryMsgBColor);

  if Config.ReadInteger('Setup', 'GreenMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GreenMsgFColor', g_Config.btGreenMsgFColor);
  g_Config.btGreenMsgFColor := Config.ReadInteger('Setup', 'GreenMsgFColor', g_Config.btGreenMsgFColor);

  if Config.ReadInteger('Setup', 'GreenMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GreenMsgBColor', g_Config.btGreenMsgBColor);
  g_Config.btGreenMsgBColor := Config.ReadInteger('Setup', 'GreenMsgBColor', g_Config.btGreenMsgBColor);

  if Config.ReadInteger('Setup', 'BlueMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'BlueMsgFColor', g_Config.btBlueMsgFColor);
  g_Config.btBlueMsgFColor := Config.ReadInteger('Setup', 'BlueMsgFColor', g_Config.btBlueMsgFColor);

  if Config.ReadInteger('Setup', 'BlueMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'BlueMsgBColor', g_Config.btBlueMsgBColor);
  g_Config.btBlueMsgBColor := Config.ReadInteger('Setup', 'BlueMsgBColor', g_Config.btBlueMsgBColor);

  if Config.ReadInteger('Setup', 'RedMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'RedMsgFColor', g_Config.btRedMsgFColor);
  g_Config.btRedMsgFColor := Config.ReadInteger('Setup', 'RedMsgFColor', g_Config.btRedMsgFColor);

  if Config.ReadInteger('Setup', 'RedMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'RedMsgBColor', g_Config.btRedMsgBColor);
  g_Config.btRedMsgBColor := Config.ReadInteger('Setup', 'RedMsgBColor', g_Config.btRedMsgBColor);

  if Config.ReadInteger('Setup', 'GuildMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GuildMsgFColor', g_Config.btGuildMsgFColor);
  g_Config.btGuildMsgFColor := Config.ReadInteger('Setup', 'GuildMsgFColor', g_Config.btGuildMsgFColor);

  if Config.ReadInteger('Setup', 'GuildMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GuildMsgBColor', g_Config.btGuildMsgBColor);
  g_Config.btGuildMsgBColor := Config.ReadInteger('Setup', 'GuildMsgBColor', g_Config.btGuildMsgBColor);

  if Config.ReadInteger('Setup', 'GroupMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GroupMsgFColor', g_Config.btGroupMsgFColor);
  g_Config.btGroupMsgFColor := Config.ReadInteger('Setup', 'GroupMsgFColor', g_Config.btGroupMsgFColor);

  if Config.ReadInteger('Setup', 'GroupMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GroupMsgBColor', g_Config.btGroupMsgBColor);
  g_Config.btGroupMsgBColor := Config.ReadInteger('Setup', 'GroupMsgBColor', g_Config.btGroupMsgBColor);

  if Config.ReadInteger('Setup', 'CustMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'CustMsgFColor', g_Config.btCustMsgFColor);
  g_Config.btCustMsgFColor := Config.ReadInteger('Setup', 'CustMsgFColor', g_Config.btCustMsgFColor);

  if Config.ReadInteger('Setup', 'CustMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'CustMsgBColor', g_Config.btCustMsgBColor);
  g_Config.btCustMsgBColor := Config.ReadInteger('Setup', 'CustMsgBColor', g_Config.btCustMsgBColor);

  if Config.ReadInteger('Setup', 'MonRandomAddValue', -1) < 0 then
    Config.WriteInteger('Setup', 'MonRandomAddValue', g_Config.nMonRandomAddValue);
  g_Config.nMonRandomAddValue := Config.ReadInteger('Setup', 'MonRandomAddValue', g_Config.nMonRandomAddValue);

  if Config.ReadInteger('Setup', 'MakeRandomAddValue', -1) < 0 then
    Config.WriteInteger('Setup', 'MakeRandomAddValue', g_Config.nMakeRandomAddValue);
  g_Config.nMakeRandomAddValue := Config.ReadInteger('Setup', 'MakeRandomAddValue', g_Config.nMakeRandomAddValue);

  if Config.ReadInteger('Setup', 'WeaponDCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'WeaponDCAddValueMaxLimit', g_Config.nWeaponDCAddValueMaxLimit);
  g_Config.nWeaponDCAddValueMaxLimit := Config.ReadInteger('Setup', 'WeaponDCAddValueMaxLimit', g_Config.nWeaponDCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'WeaponDCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'WeaponDCAddValueRate', g_Config.nWeaponDCAddValueRate);
  g_Config.nWeaponDCAddValueRate := Config.ReadInteger('Setup', 'WeaponDCAddValueRate', g_Config.nWeaponDCAddValueRate);

  if Config.ReadInteger('Setup', 'WeaponMCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'WeaponMCAddValueMaxLimit', g_Config.nWeaponMCAddValueMaxLimit);
  g_Config.nWeaponMCAddValueMaxLimit := Config.ReadInteger('Setup', 'WeaponMCAddValueMaxLimit', g_Config.nWeaponMCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'WeaponMCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'WeaponMCAddValueRate', g_Config.nWeaponMCAddValueRate);
  g_Config.nWeaponMCAddValueRate := Config.ReadInteger('Setup', 'WeaponMCAddValueRate', g_Config.nWeaponMCAddValueRate);

  if Config.ReadInteger('Setup', 'WeaponSCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'WeaponSCAddValueMaxLimit', g_Config.nWeaponSCAddValueMaxLimit);
  g_Config.nWeaponSCAddValueMaxLimit := Config.ReadInteger('Setup', 'WeaponSCAddValueMaxLimit', g_Config.nWeaponSCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'WeaponSCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'WeaponSCAddValueRate', g_Config.nWeaponSCAddValueRate);
  g_Config.nWeaponSCAddValueRate := Config.ReadInteger('Setup', 'WeaponSCAddValueRate', g_Config.nWeaponSCAddValueRate);

  if Config.ReadInteger('Setup', 'DressDCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'DressDCAddValueMaxLimit', g_Config.nDressDCAddValueMaxLimit);
  g_Config.nDressDCAddValueMaxLimit := Config.ReadInteger('Setup', 'DressDCAddValueMaxLimit', g_Config.nDressDCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'DressDCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DressDCAddValueRate', g_Config.nDressDCAddValueRate);
  g_Config.nDressDCAddValueRate := Config.ReadInteger('Setup', 'DressDCAddValueRate', g_Config.nDressDCAddValueRate);

  if Config.ReadInteger('Setup', 'DressDCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DressDCAddRate', g_Config.nDressDCAddRate);
  g_Config.nDressDCAddRate := Config.ReadInteger('Setup', 'DressDCAddRate', g_Config.nDressDCAddRate);

  if Config.ReadInteger('Setup', 'DressMCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'DressMCAddValueMaxLimit', g_Config.nDressMCAddValueMaxLimit);
  g_Config.nDressMCAddValueMaxLimit := Config.ReadInteger('Setup', 'DressMCAddValueMaxLimit', g_Config.nDressMCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'DressMCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DressMCAddValueRate', g_Config.nDressMCAddValueRate);
  g_Config.nDressMCAddValueRate := Config.ReadInteger('Setup', 'DressMCAddValueRate', g_Config.nDressMCAddValueRate);

  if Config.ReadInteger('Setup', 'DressMCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DressMCAddRate', g_Config.nDressMCAddRate);
  g_Config.nDressMCAddRate := Config.ReadInteger('Setup', 'DressMCAddRate', g_Config.nDressMCAddRate);

  if Config.ReadInteger('Setup', 'DressSCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'DressSCAddValueMaxLimit', g_Config.nDressSCAddValueMaxLimit);
  g_Config.nDressSCAddValueMaxLimit := Config.ReadInteger('Setup', 'DressSCAddValueMaxLimit', g_Config.nDressSCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'DressSCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DressSCAddValueRate', g_Config.nDressSCAddValueRate);
  g_Config.nDressSCAddValueRate := Config.ReadInteger('Setup', 'DressSCAddValueRate', g_Config.nDressSCAddValueRate);

  if Config.ReadInteger('Setup', 'DressSCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DressSCAddRate', g_Config.nDressSCAddRate);
  g_Config.nDressSCAddRate := Config.ReadInteger('Setup', 'DressSCAddRate', g_Config.nDressSCAddRate);

  if Config.ReadInteger('Setup', 'NeckLace19DCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19DCAddValueMaxLimit', g_Config.nNeckLace19DCAddValueMaxLimit);
  g_Config.nNeckLace19DCAddValueMaxLimit := Config.ReadInteger('Setup', 'NeckLace19DCAddValueMaxLimit', g_Config.nNeckLace19DCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'NeckLace19DCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19DCAddValueRate', g_Config.nNeckLace19DCAddValueRate);
  g_Config.nNeckLace19DCAddValueRate := Config.ReadInteger('Setup', 'NeckLace19DCAddValueRate', g_Config.nNeckLace19DCAddValueRate);

  if Config.ReadInteger('Setup', 'NeckLace19DCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19DCAddRate', g_Config.nNeckLace19DCAddRate);
  g_Config.nNeckLace19DCAddRate := Config.ReadInteger('Setup', 'NeckLace19DCAddRate', g_Config.nNeckLace19DCAddRate);

  if Config.ReadInteger('Setup', 'NeckLace19MCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19MCAddValueMaxLimit', g_Config.nNeckLace19MCAddValueMaxLimit);
  g_Config.nNeckLace19MCAddValueMaxLimit := Config.ReadInteger('Setup', 'NeckLace19MCAddValueMaxLimit', g_Config.nNeckLace19MCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'NeckLace19MCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19MCAddValueRate', g_Config.nNeckLace19MCAddValueRate);
  g_Config.nNeckLace19MCAddValueRate := Config.ReadInteger('Setup', 'NeckLace19MCAddValueRate', g_Config.nNeckLace19MCAddValueRate);

  if Config.ReadInteger('Setup', 'NeckLace19MCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19MCAddRate', g_Config.nNeckLace19MCAddRate);
  g_Config.nNeckLace19MCAddRate := Config.ReadInteger('Setup', 'NeckLace19MCAddRate', g_Config.nNeckLace19MCAddRate);

  if Config.ReadInteger('Setup', 'NeckLace19SCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19SCAddValueMaxLimit', g_Config.nNeckLace19SCAddValueMaxLimit);
  g_Config.nNeckLace19SCAddValueMaxLimit := Config.ReadInteger('Setup', 'NeckLace19SCAddValueMaxLimit', g_Config.nNeckLace19SCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'NeckLace19SCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19SCAddValueRate', g_Config.nNeckLace19SCAddValueRate);
  g_Config.nNeckLace19SCAddValueRate := Config.ReadInteger('Setup', 'NeckLace19SCAddValueRate', g_Config.nNeckLace19SCAddValueRate);

  if Config.ReadInteger('Setup', 'NeckLace19SCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19SCAddRate', g_Config.nNeckLace19SCAddRate);
  g_Config.nNeckLace19SCAddRate := Config.ReadInteger('Setup', 'NeckLace19SCAddRate', g_Config.nNeckLace19SCAddRate);

  if Config.ReadInteger('Setup', 'NeckLace202124DCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124DCAddValueMaxLimit', g_Config.nNeckLace202124DCAddValueMaxLimit);
  g_Config.nNeckLace202124DCAddValueMaxLimit := Config.ReadInteger('Setup', 'NeckLace202124DCAddValueMaxLimit', g_Config.nNeckLace202124DCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'NeckLace202124DCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124DCAddValueRate', g_Config.nNeckLace202124DCAddValueRate);
  g_Config.nNeckLace202124DCAddValueRate := Config.ReadInteger('Setup', 'NeckLace202124DCAddValueRate', g_Config.nNeckLace202124DCAddValueRate);

  if Config.ReadInteger('Setup', 'NeckLace202124DCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124DCAddRate', g_Config.nNeckLace202124DCAddRate);
  g_Config.nNeckLace202124DCAddRate := Config.ReadInteger('Setup', 'NeckLace202124DCAddRate', g_Config.nNeckLace202124DCAddRate);

  if Config.ReadInteger('Setup', 'NeckLace202124MCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124MCAddValueMaxLimit', g_Config.nNeckLace202124MCAddValueMaxLimit);
  g_Config.nNeckLace202124MCAddValueMaxLimit := Config.ReadInteger('Setup', 'NeckLace202124MCAddValueMaxLimit', g_Config.nNeckLace202124MCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'NeckLace202124MCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124MCAddValueRate', g_Config.nNeckLace202124MCAddValueRate);
  g_Config.nNeckLace202124MCAddValueRate := Config.ReadInteger('Setup', 'NeckLace202124MCAddValueRate', g_Config.nNeckLace202124MCAddValueRate);

  if Config.ReadInteger('Setup', 'NeckLace202124MCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124MCAddRate', g_Config.nNeckLace202124MCAddRate);
  g_Config.nNeckLace202124MCAddRate := Config.ReadInteger('Setup', 'NeckLace202124MCAddRate', g_Config.nNeckLace202124MCAddRate);

  if Config.ReadInteger('Setup', 'NeckLace202124SCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124SCAddValueMaxLimit', g_Config.nNeckLace202124SCAddValueMaxLimit);
  g_Config.nNeckLace202124SCAddValueMaxLimit := Config.ReadInteger('Setup', 'NeckLace202124SCAddValueMaxLimit', g_Config.nNeckLace202124SCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'NeckLace202124SCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124SCAddValueRate', g_Config.nNeckLace202124SCAddValueRate);
  g_Config.nNeckLace202124SCAddValueRate := Config.ReadInteger('Setup', 'NeckLace202124SCAddValueRate', g_Config.nNeckLace202124SCAddValueRate);

  if Config.ReadInteger('Setup', 'NeckLace202124SCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124SCAddRate', g_Config.nNeckLace202124SCAddRate);
  g_Config.nNeckLace202124SCAddRate := Config.ReadInteger('Setup', 'NeckLace202124SCAddRate', g_Config.nNeckLace202124SCAddRate);


  if Config.ReadInteger('Setup', 'ArmRing26DCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26DCAddValueMaxLimit', g_Config.nArmRing26DCAddValueMaxLimit);
  g_Config.nArmRing26DCAddValueMaxLimit := Config.ReadInteger('Setup', 'ArmRing26DCAddValueMaxLimit', g_Config.nArmRing26DCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'ArmRing26DCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26DCAddValueRate', g_Config.nArmRing26DCAddValueRate);
  g_Config.nArmRing26DCAddValueRate := Config.ReadInteger('Setup', 'ArmRing26DCAddValueRate', g_Config.nArmRing26DCAddValueRate);

  if Config.ReadInteger('Setup', 'ArmRing26DCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26DCAddRate', g_Config.nArmRing26DCAddRate);
  g_Config.nArmRing26DCAddRate := Config.ReadInteger('Setup', 'ArmRing26DCAddRate', g_Config.nArmRing26DCAddRate);

  if Config.ReadInteger('Setup', 'ArmRing26MCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26MCAddValueMaxLimit', g_Config.nArmRing26MCAddValueMaxLimit);
  g_Config.nArmRing26MCAddValueMaxLimit := Config.ReadInteger('Setup', 'ArmRing26MCAddValueMaxLimit', g_Config.nArmRing26MCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'ArmRing26MCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26MCAddValueRate', g_Config.nArmRing26MCAddValueRate);
  g_Config.nArmRing26MCAddValueRate := Config.ReadInteger('Setup', 'ArmRing26MCAddValueRate', g_Config.nArmRing26MCAddValueRate);

  if Config.ReadInteger('Setup', 'ArmRing26MCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26MCAddRate', g_Config.nArmRing26MCAddRate);
  g_Config.nArmRing26MCAddRate := Config.ReadInteger('Setup', 'ArmRing26MCAddRate', g_Config.nArmRing26MCAddRate);

  if Config.ReadInteger('Setup', 'ArmRing26SCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26SCAddValueMaxLimit', g_Config.nArmRing26SCAddValueMaxLimit);
  g_Config.nArmRing26SCAddValueMaxLimit := Config.ReadInteger('Setup', 'ArmRing26SCAddValueMaxLimit', g_Config.nArmRing26SCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'ArmRing26SCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26SCAddValueRate', g_Config.nArmRing26SCAddValueRate);
  g_Config.nArmRing26SCAddValueRate := Config.ReadInteger('Setup', 'ArmRing26SCAddValueRate', g_Config.nArmRing26SCAddValueRate);

  if Config.ReadInteger('Setup', 'ArmRing26SCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26SCAddRate', g_Config.nArmRing26SCAddRate);
  g_Config.nArmRing26SCAddRate := Config.ReadInteger('Setup', 'ArmRing26SCAddRate', g_Config.nArmRing26SCAddRate);

  if Config.ReadInteger('Setup', 'Ring22DCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22DCAddValueMaxLimit', g_Config.nRing22DCAddValueMaxLimit);
  g_Config.nRing22DCAddValueMaxLimit := Config.ReadInteger('Setup', 'Ring22DCAddValueMaxLimit', g_Config.nRing22DCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'Ring22DCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22DCAddValueRate', g_Config.nRing22DCAddValueRate);
  g_Config.nRing22DCAddValueRate := Config.ReadInteger('Setup', 'Ring22DCAddValueRate', g_Config.nRing22DCAddValueRate);

  if Config.ReadInteger('Setup', 'Ring22DCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22DCAddRate', g_Config.nRing22DCAddRate);
  g_Config.nRing22DCAddRate := Config.ReadInteger('Setup', 'Ring22DCAddRate', g_Config.nRing22DCAddRate);

  if Config.ReadInteger('Setup', 'Ring22MCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22MCAddValueMaxLimit', g_Config.nRing22MCAddValueMaxLimit);
  g_Config.nRing22MCAddValueMaxLimit := Config.ReadInteger('Setup', 'Ring22MCAddValueMaxLimit', g_Config.nRing22MCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'Ring22MCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22MCAddValueRate', g_Config.nRing22MCAddValueRate);
  g_Config.nRing22MCAddValueRate := Config.ReadInteger('Setup', 'Ring22MCAddValueRate', g_Config.nRing22MCAddValueRate);

  if Config.ReadInteger('Setup', 'Ring22MCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22MCAddRate', g_Config.nRing22MCAddRate);
  g_Config.nRing22MCAddRate := Config.ReadInteger('Setup', 'Ring22MCAddRate', g_Config.nRing22MCAddRate);

  if Config.ReadInteger('Setup', 'Ring22SCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22SCAddValueMaxLimit', g_Config.nRing22SCAddValueMaxLimit);
  g_Config.nRing22SCAddValueMaxLimit := Config.ReadInteger('Setup', 'Ring22SCAddValueMaxLimit', g_Config.nRing22SCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'Ring22SCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22SCAddValueRate', g_Config.nRing22SCAddValueRate);
  g_Config.nRing22SCAddValueRate := Config.ReadInteger('Setup', 'Ring22SCAddValueRate', g_Config.nRing22SCAddValueRate);

  if Config.ReadInteger('Setup', 'Ring22SCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22SCAddRate', g_Config.nRing22SCAddRate);
  g_Config.nRing22SCAddRate := Config.ReadInteger('Setup', 'Ring22SCAddRate', g_Config.nRing22SCAddRate);


  if Config.ReadInteger('Setup', 'Ring23DCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23DCAddValueMaxLimit', g_Config.nRing23DCAddValueMaxLimit);
  g_Config.nRing23DCAddValueMaxLimit := Config.ReadInteger('Setup', 'Ring23DCAddValueMaxLimit', g_Config.nRing23DCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'Ring23DCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23DCAddValueRate', g_Config.nRing23DCAddValueRate);
  g_Config.nRing23DCAddValueRate := Config.ReadInteger('Setup', 'Ring23DCAddValueRate', g_Config.nRing23DCAddValueRate);

  if Config.ReadInteger('Setup', 'Ring23DCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23DCAddRate', g_Config.nRing23DCAddRate);
  g_Config.nRing23DCAddRate := Config.ReadInteger('Setup', 'Ring23DCAddRate', g_Config.nRing23DCAddRate);

  if Config.ReadInteger('Setup', 'Ring23MCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23MCAddValueMaxLimit', g_Config.nRing23MCAddValueMaxLimit);
  g_Config.nRing23MCAddValueMaxLimit := Config.ReadInteger('Setup', 'Ring23MCAddValueMaxLimit', g_Config.nRing23MCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'Ring23MCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23MCAddValueRate', g_Config.nRing23MCAddValueRate);
  g_Config.nRing23MCAddValueRate := Config.ReadInteger('Setup', 'Ring23MCAddValueRate', g_Config.nRing23MCAddValueRate);

  if Config.ReadInteger('Setup', 'Ring23MCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23MCAddRate', g_Config.nRing23MCAddRate);
  g_Config.nRing23MCAddRate := Config.ReadInteger('Setup', 'Ring23MCAddRate', g_Config.nRing23MCAddRate);

  if Config.ReadInteger('Setup', 'Ring23SCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23SCAddValueMaxLimit', g_Config.nRing23SCAddValueMaxLimit);
  g_Config.nRing23SCAddValueMaxLimit := Config.ReadInteger('Setup', 'Ring23SCAddValueMaxLimit', g_Config.nRing23SCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'Ring23SCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23SCAddValueRate', g_Config.nRing23SCAddValueRate);
  g_Config.nRing23SCAddValueRate := Config.ReadInteger('Setup', 'Ring23SCAddValueRate', g_Config.nRing23SCAddValueRate);

  if Config.ReadInteger('Setup', 'Ring23SCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23SCAddRate', g_Config.nRing23SCAddRate);
  g_Config.nRing23SCAddRate := Config.ReadInteger('Setup', 'Ring23SCAddRate', g_Config.nRing23SCAddRate);

  if Config.ReadInteger('Setup', 'HelMetDCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetDCAddValueMaxLimit', g_Config.nHelMetDCAddValueMaxLimit);
  g_Config.nHelMetDCAddValueMaxLimit := Config.ReadInteger('Setup', 'HelMetDCAddValueMaxLimit', g_Config.nHelMetDCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'HelMetDCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetDCAddValueRate', g_Config.nHelMetDCAddValueRate);
  g_Config.nHelMetDCAddValueRate := Config.ReadInteger('Setup', 'HelMetDCAddValueRate', g_Config.nHelMetDCAddValueRate);

  if Config.ReadInteger('Setup', 'HelMetDCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetDCAddRate', g_Config.nHelMetDCAddRate);
  g_Config.nHelMetDCAddRate := Config.ReadInteger('Setup', 'HelMetDCAddRate', g_Config.nHelMetDCAddRate);

  if Config.ReadInteger('Setup', 'HelMetMCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetMCAddValueMaxLimit', g_Config.nHelMetMCAddValueMaxLimit);
  g_Config.nHelMetMCAddValueMaxLimit := Config.ReadInteger('Setup', 'HelMetMCAddValueMaxLimit', g_Config.nHelMetMCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'HelMetMCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetMCAddValueRate', g_Config.nHelMetMCAddValueRate);
  g_Config.nHelMetMCAddValueRate := Config.ReadInteger('Setup', 'HelMetMCAddValueRate', g_Config.nHelMetMCAddValueRate);

  if Config.ReadInteger('Setup', 'HelMetMCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetMCAddRate', g_Config.nHelMetMCAddRate);
  g_Config.nHelMetMCAddRate := Config.ReadInteger('Setup', 'HelMetMCAddRate', g_Config.nHelMetMCAddRate);

  if Config.ReadInteger('Setup', 'HelMetSCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetSCAddValueMaxLimit', g_Config.nHelMetSCAddValueMaxLimit);
  g_Config.nHelMetSCAddValueMaxLimit := Config.ReadInteger('Setup', 'HelMetSCAddValueMaxLimit', g_Config.nHelMetSCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'HelMetSCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetSCAddValueRate', g_Config.nHelMetSCAddValueRate);
  g_Config.nHelMetSCAddValueRate := Config.ReadInteger('Setup', 'HelMetSCAddValueRate', g_Config.nHelMetSCAddValueRate);

  if Config.ReadInteger('Setup', 'HelMetSCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetSCAddRate', g_Config.nHelMetSCAddRate);
  g_Config.nHelMetSCAddRate := Config.ReadInteger('Setup', 'HelMetSCAddRate', g_Config.nHelMetSCAddRate);

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetACAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetACAddRate', g_Config.nUnknowHelMetACAddRate)
  else g_Config.nUnknowHelMetACAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetACAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetACAddValueMaxLimit', g_Config.nUnknowHelMetACAddValueMaxLimit)
  else g_Config.nUnknowHelMetACAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetMACAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetMACAddRate', g_Config.nUnknowHelMetMACAddRate)
  else g_Config.nUnknowHelMetMACAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetMACAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetMACAddValueMaxLimit', g_Config.nUnknowHelMetMACAddValueMaxLimit)
  else g_Config.nUnknowHelMetMACAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetDCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetDCAddRate', g_Config.nUnknowHelMetDCAddRate)
  else g_Config.nUnknowHelMetDCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetDCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetDCAddValueMaxLimit', g_Config.nUnknowHelMetDCAddValueMaxLimit)
  else g_Config.nUnknowHelMetDCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetMCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetMCAddRate', g_Config.nUnknowHelMetMCAddRate)
  else g_Config.nUnknowHelMetMCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetMCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetMCAddValueMaxLimit', g_Config.nUnknowHelMetMCAddValueMaxLimit)
  else g_Config.nUnknowHelMetMCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetSCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetSCAddRate', g_Config.nUnknowHelMetSCAddRate)
  else g_Config.nUnknowHelMetSCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetSCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetSCAddValueMaxLimit', g_Config.nUnknowHelMetSCAddValueMaxLimit)
  else g_Config.nUnknowHelMetSCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceACAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceACAddRate', g_Config.nUnknowNecklaceACAddRate)
  else g_Config.nUnknowNecklaceACAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceACAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceACAddValueMaxLimit', g_Config.nUnknowNecklaceACAddValueMaxLimit)
  else g_Config.nUnknowNecklaceACAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceMACAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceMACAddRate', g_Config.nUnknowNecklaceMACAddRate)
  else g_Config.nUnknowNecklaceMACAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceMACAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceMACAddValueMaxLimit', g_Config.nUnknowNecklaceMACAddValueMaxLimit)
  else g_Config.nUnknowNecklaceMACAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceDCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceDCAddRate', g_Config.nUnknowNecklaceDCAddRate)
  else g_Config.nUnknowNecklaceDCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceDCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceDCAddValueMaxLimit', g_Config.nUnknowNecklaceDCAddValueMaxLimit)
  else g_Config.nUnknowNecklaceDCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceMCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceMCAddRate', g_Config.nUnknowNecklaceMCAddRate)
  else g_Config.nUnknowNecklaceMCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceMCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceMCAddValueMaxLimit', g_Config.nUnknowNecklaceMCAddValueMaxLimit)
  else g_Config.nUnknowNecklaceMCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceSCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceSCAddRate', g_Config.nUnknowNecklaceSCAddRate)
  else g_Config.nUnknowNecklaceSCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceSCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceSCAddValueMaxLimit', g_Config.nUnknowNecklaceSCAddValueMaxLimit)
  else g_Config.nUnknowNecklaceSCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingACAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingACAddRate', g_Config.nUnknowRingACAddRate)
  else g_Config.nUnknowRingACAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingACAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingACAddValueMaxLimit', g_Config.nUnknowRingACAddValueMaxLimit)
  else g_Config.nUnknowRingACAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingMACAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingMACAddRate', g_Config.nUnknowRingMACAddRate)
  else g_Config.nUnknowRingMACAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingMACAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingMACAddValueMaxLimit', g_Config.nUnknowRingMACAddValueMaxLimit)
  else g_Config.nUnknowRingMACAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingDCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingDCAddRate', g_Config.nUnknowRingDCAddRate)
  else g_Config.nUnknowRingDCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingDCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingDCAddValueMaxLimit', g_Config.nUnknowRingDCAddValueMaxLimit)
  else g_Config.nUnknowRingDCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingMCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingMCAddRate', g_Config.nUnknowRingMCAddRate)
  else g_Config.nUnknowRingMCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingMCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingMCAddValueMaxLimit', g_Config.nUnknowRingMCAddValueMaxLimit)
  else g_Config.nUnknowRingMCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingSCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingSCAddRate', g_Config.nUnknowRingSCAddRate)
  else g_Config.nUnknowRingSCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingSCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingSCAddValueMaxLimit', g_Config.nUnknowRingSCAddValueMaxLimit)
  else g_Config.nUnknowRingSCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MonOneDropGoldCount', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MonOneDropGoldCount', g_Config.nMonOneDropGoldCount)
  else g_Config.nMonOneDropGoldCount := nLoadInteger;

  if Config.ReadInteger('Setup', 'MakeMineHitRate', -1) < 0 then
    Config.WriteInteger('Setup', 'MakeMineHitRate', g_Config.nMakeMineHitRate);
  g_Config.nMakeMineHitRate := Config.ReadInteger('Setup', 'MakeMineHitRate', g_Config.nMakeMineHitRate);

  if Config.ReadInteger('Setup', 'MakeMineRate', -1) < 0 then
    Config.WriteInteger('Setup', 'MakeMineRate', g_Config.nMakeMineRate);
  g_Config.nMakeMineRate := Config.ReadInteger('Setup', 'MakeMineRate', g_Config.nMakeMineRate);

  if Config.ReadInteger('Setup', 'StoneTypeRate', -1) < 0 then
    Config.WriteInteger('Setup', 'StoneTypeRate', g_Config.nStoneTypeRate);
  g_Config.nStoneTypeRate := Config.ReadInteger('Setup', 'StoneTypeRate', g_Config.nStoneTypeRate);

  if Config.ReadInteger('Setup', 'StoneTypeRateMin', -1) < 0 then
    Config.WriteInteger('Setup', 'StoneTypeRateMin', g_Config.nStoneTypeRateMin);
  g_Config.nStoneTypeRateMin := Config.ReadInteger('Setup', 'StoneTypeRateMin', g_Config.nStoneTypeRateMin);

  if Config.ReadInteger('Setup', 'GoldStoneMin', -1) < 0 then
    Config.WriteInteger('Setup', 'GoldStoneMin', g_Config.nGoldStoneMin);
  g_Config.nGoldStoneMin := Config.ReadInteger('Setup', 'GoldStoneMin', g_Config.nGoldStoneMin);

  if Config.ReadInteger('Setup', 'GoldStoneMax', -1) < 0 then
    Config.WriteInteger('Setup', 'GoldStoneMax', g_Config.nGoldStoneMax);
  g_Config.nGoldStoneMax := Config.ReadInteger('Setup', 'GoldStoneMax', g_Config.nGoldStoneMax);

  if Config.ReadInteger('Setup', 'SilverStoneMin', -1) < 0 then
    Config.WriteInteger('Setup', 'SilverStoneMin', g_Config.nSilverStoneMin);
  g_Config.nSilverStoneMin := Config.ReadInteger('Setup', 'SilverStoneMin', g_Config.nSilverStoneMin);

  if Config.ReadInteger('Setup', 'SilverStoneMax', -1) < 0 then
    Config.WriteInteger('Setup', 'SilverStoneMax', g_Config.nSilverStoneMax);
  g_Config.nSilverStoneMax := Config.ReadInteger('Setup', 'SilverStoneMax', g_Config.nSilverStoneMax);

  if Config.ReadInteger('Setup', 'SteelStoneMin', -1) < 0 then
    Config.WriteInteger('Setup', 'SteelStoneMin', g_Config.nSteelStoneMin);
  g_Config.nSteelStoneMin := Config.ReadInteger('Setup', 'SteelStoneMin', g_Config.nSteelStoneMin);

  if Config.ReadInteger('Setup', 'SteelStoneMax', -1) < 0 then
    Config.WriteInteger('Setup', 'SteelStoneMax', g_Config.nSteelStoneMax);
  g_Config.nSteelStoneMax := Config.ReadInteger('Setup', 'SteelStoneMax', g_Config.nSteelStoneMax);

  if Config.ReadInteger('Setup', 'BlackStoneMin', -1) < 0 then
    Config.WriteInteger('Setup', 'BlackStoneMin', g_Config.nBlackStoneMin);
  g_Config.nBlackStoneMin := Config.ReadInteger('Setup', 'BlackStoneMin', g_Config.nBlackStoneMin);

  if Config.ReadInteger('Setup', 'BlackStoneMax', -1) < 0 then
    Config.WriteInteger('Setup', 'BlackStoneMax', g_Config.nBlackStoneMax);
  g_Config.nBlackStoneMax := Config.ReadInteger('Setup', 'BlackStoneMax', g_Config.nBlackStoneMax);

  if Config.ReadInteger('Setup', 'StoneMinDura', -1) < 0 then
    Config.WriteInteger('Setup', 'StoneMinDura', g_Config.nStoneMinDura);
  g_Config.nStoneMinDura := Config.ReadInteger('Setup', 'StoneMinDura', g_Config.nStoneMinDura);

  if Config.ReadInteger('Setup', 'StoneGeneralDuraRate', -1) < 0 then
    Config.WriteInteger('Setup', 'StoneGeneralDuraRate', g_Config.nStoneGeneralDuraRate);
  g_Config.nStoneGeneralDuraRate := Config.ReadInteger('Setup', 'StoneGeneralDuraRate', g_Config.nStoneGeneralDuraRate);

  if Config.ReadInteger('Setup', 'StoneAddDuraRate', -1) < 0 then
    Config.WriteInteger('Setup', 'StoneAddDuraRate', g_Config.nStoneAddDuraRate);
  g_Config.nStoneAddDuraRate := Config.ReadInteger('Setup', 'StoneAddDuraRate', g_Config.nStoneAddDuraRate);

  if Config.ReadInteger('Setup', 'StoneAddDuraMax', -1) < 0 then
    Config.WriteInteger('Setup', 'StoneAddDuraMax', g_Config.nStoneAddDuraMax);
  g_Config.nStoneAddDuraMax := Config.ReadInteger('Setup', 'StoneAddDuraMax', g_Config.nStoneAddDuraMax);

//取消彩票功能
{
  if Config.ReadInteger('Setup', 'WinLottery1Min', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery1Min', g_Config.nWinLottery1Min);
  g_Config.nWinLottery1Min := Config.ReadInteger('Setup', 'WinLottery1Min', g_Config.nWinLottery1Min);

  if Config.ReadInteger('Setup', 'WinLottery1Max', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery1Max', g_Config.nWinLottery1Max);
  g_Config.nWinLottery1Max := Config.ReadInteger('Setup', 'WinLottery1Max', g_Config.nWinLottery1Max);

  if Config.ReadInteger('Setup', 'WinLottery2Min', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery2Min', g_Config.nWinLottery2Min);
  g_Config.nWinLottery2Min := Config.ReadInteger('Setup', 'WinLottery2Min', g_Config.nWinLottery2Min);

  if Config.ReadInteger('Setup', 'WinLottery2Max', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery2Max', g_Config.nWinLottery2Max);
  g_Config.nWinLottery2Max := Config.ReadInteger('Setup', 'WinLottery2Max', g_Config.nWinLottery2Max);

  if Config.ReadInteger('Setup', 'WinLottery3Min', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery3Min', g_Config.nWinLottery3Min);
  g_Config.nWinLottery3Min := Config.ReadInteger('Setup', 'WinLottery3Min', g_Config.nWinLottery3Min);

  if Config.ReadInteger('Setup', 'WinLottery3Max', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery3Max', g_Config.nWinLottery3Max);
  g_Config.nWinLottery3Max := Config.ReadInteger('Setup', 'WinLottery3Max', g_Config.nWinLottery3Max);

  if Config.ReadInteger('Setup', 'WinLottery4Min', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery4Min', g_Config.nWinLottery4Min);
  g_Config.nWinLottery4Min := Config.ReadInteger('Setup', 'WinLottery4Min', g_Config.nWinLottery4Min);

  if Config.ReadInteger('Setup', 'WinLottery4Max', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery4Max', g_Config.nWinLottery4Max);
  g_Config.nWinLottery4Max := Config.ReadInteger('Setup', 'WinLottery4Max', g_Config.nWinLottery4Max);

  if Config.ReadInteger('Setup', 'WinLottery5Min', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery5Min', g_Config.nWinLottery5Min);
  g_Config.nWinLottery5Min := Config.ReadInteger('Setup', 'WinLottery5Min', g_Config.nWinLottery5Min);

  if Config.ReadInteger('Setup', 'WinLottery5Max', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery5Max', g_Config.nWinLottery5Max);
  g_Config.nWinLottery5Max := Config.ReadInteger('Setup', 'WinLottery5Max', g_Config.nWinLottery5Max);

  if Config.ReadInteger('Setup', 'WinLottery6Min', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery6Min', g_Config.nWinLottery6Min);
  g_Config.nWinLottery6Min := Config.ReadInteger('Setup', 'WinLottery6Min', g_Config.nWinLottery6Min);

  if Config.ReadInteger('Setup', 'WinLottery6Max', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery6Max', g_Config.nWinLottery6Max);
  g_Config.nWinLottery6Max := Config.ReadInteger('Setup', 'WinLottery6Max', g_Config.nWinLottery6Max);

  if Config.ReadInteger('Setup', 'WinLotteryRate', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLotteryRate', g_Config.nWinLotteryRate);
  g_Config.nWinLotteryRate := Config.ReadInteger('Setup', 'WinLotteryRate', g_Config.nWinLotteryRate);

  if Config.ReadInteger('Setup', 'WinLottery1Gold', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery1Gold', g_Config.nWinLottery1Gold);
  g_Config.nWinLottery1Gold := Config.ReadInteger('Setup', 'WinLottery1Gold', g_Config.nWinLottery1Gold);

  if Config.ReadInteger('Setup', 'WinLottery2Gold', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery2Gold', g_Config.nWinLottery2Gold);
  g_Config.nWinLottery2Gold := Config.ReadInteger('Setup', 'WinLottery2Gold', g_Config.nWinLottery2Gold);

  if Config.ReadInteger('Setup', 'WinLottery3Gold', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery3Gold', g_Config.nWinLottery3Gold);
  g_Config.nWinLottery3Gold := Config.ReadInteger('Setup', 'WinLottery3Gold', g_Config.nWinLottery3Gold);

  if Config.ReadInteger('Setup', 'WinLottery4Gold', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery4Gold', g_Config.nWinLottery4Gold);
  g_Config.nWinLottery4Gold := Config.ReadInteger('Setup', 'WinLottery4Gold', g_Config.nWinLottery4Gold);

  if Config.ReadInteger('Setup', 'WinLottery5Gold', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery5Gold', g_Config.nWinLottery5Gold);
  g_Config.nWinLottery5Gold := Config.ReadInteger('Setup', 'WinLottery5Gold', g_Config.nWinLottery5Gold);

  if Config.ReadInteger('Setup', 'WinLottery6Gold', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery6Gold', g_Config.nWinLottery6Gold);
  g_Config.nWinLottery6Gold := Config.ReadInteger('Setup', 'WinLottery6Gold', g_Config.nWinLottery6Gold);
}

  if Config.ReadInteger('Setup', 'GuildRecallTime', -1) < 0 then
    Config.WriteInteger('Setup', 'GuildRecallTime', g_Config.nGuildRecallTime);
  g_Config.nGuildRecallTime := Config.ReadInteger('Setup', 'GuildRecallTime', g_Config.nGuildRecallTime);

  if Config.ReadInteger('Setup', 'GroupRecallTime', -1) < 0 then
    Config.WriteInteger('Setup', 'GroupRecallTime', g_Config.nGroupRecallTime);
  g_Config.nGroupRecallTime := Config.ReadInteger('Setup', 'GroupRecallTime', g_Config.nGroupRecallTime);

  if Config.ReadInteger('Setup', 'ControlDropItem', -1) < 0 then
    Config.WriteBool('Setup', 'ControlDropItem', g_Config.boControlDropItem);
  g_Config.boControlDropItem := Config.ReadBool('Setup', 'ControlDropItem', g_Config.boControlDropItem);

  if Config.ReadInteger('Setup', 'InSafeDisableDrop', -1) < 0 then
    Config.WriteBool('Setup', 'InSafeDisableDrop', g_Config.boInSafeDisableDrop);
  g_Config.boInSafeDisableDrop := Config.ReadBool('Setup', 'InSafeDisableDrop', g_Config.boInSafeDisableDrop);

  if Config.ReadInteger('Setup', 'CanDropGold', -1) < 0 then
    Config.WriteInteger('Setup', 'CanDropGold', g_Config.nCanDropGold);
  g_Config.nCanDropGold := Config.ReadInteger('Setup', 'CanDropGold', g_Config.nCanDropGold);

  if Config.ReadInteger('Setup', 'CanDropPrice', -1) < 0 then
    Config.WriteInteger('Setup', 'CanDropPrice', g_Config.nCanDropPrice);
  g_Config.nCanDropPrice := Config.ReadInteger('Setup', 'CanDropPrice', g_Config.nCanDropPrice);

  nLoadInteger := Config.ReadInteger('Setup', 'SendCustemMsg', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'SendCustemMsg', g_Config.boSendCustemMsg)
  else g_Config.boSendCustemMsg := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'SubkMasterSendMsg', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'SubkMasterSendMsg', g_Config.boSubkMasterSendMsg)
  else g_Config.boSubkMasterSendMsg := nLoadInteger = 1;

  if Config.ReadInteger('Setup', 'SuperRepairPriceRate', -1) < 0 then
    Config.WriteInteger('Setup', 'SuperRepairPriceRate', g_Config.nSuperRepairPriceRate);
  g_Config.nSuperRepairPriceRate := Config.ReadInteger('Setup', 'SuperRepairPriceRate', g_Config.nSuperRepairPriceRate);

  if Config.ReadInteger('Setup', 'RepairItemDecDura', -1) < 0 then
    Config.WriteInteger('Setup', 'RepairItemDecDura', g_Config.nRepairItemDecDura);
  g_Config.nRepairItemDecDura := Config.ReadInteger('Setup', 'RepairItemDecDura', g_Config.nRepairItemDecDura);

  if Config.ReadInteger('Setup', 'DieScatterBag', -1) < 0 then
    Config.WriteBool('Setup', 'DieScatterBag', g_Config.boDieScatterBag);
  g_Config.boDieScatterBag := Config.ReadBool('Setup', 'DieScatterBag', g_Config.boDieScatterBag);

  if Config.ReadInteger('Setup', 'DieScatterBagRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DieScatterBagRate', g_Config.nDieScatterBagRate);
  g_Config.nDieScatterBagRate := Config.ReadInteger('Setup', 'DieScatterBagRate', g_Config.nDieScatterBagRate);

  if Config.ReadInteger('Setup', 'DieRedScatterBagAll', -1) < 0 then
    Config.WriteBool('Setup', 'DieRedScatterBagAll', g_Config.boDieRedScatterBagAll);
  g_Config.boDieRedScatterBagAll := Config.ReadBool('Setup', 'DieRedScatterBagAll', g_Config.boDieRedScatterBagAll);

  if Config.ReadInteger('Setup', 'DieDropUseItemRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DieDropUseItemRate', g_Config.nDieDropUseItemRate);
  g_Config.nDieDropUseItemRate := Config.ReadInteger('Setup', 'DieDropUseItemRate', g_Config.nDieDropUseItemRate);

  if Config.ReadInteger('Setup', 'DieRedDropUseItemRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DieRedDropUseItemRate', g_Config.nDieRedDropUseItemRate);
  g_Config.nDieRedDropUseItemRate := Config.ReadInteger('Setup', 'DieRedDropUseItemRate', g_Config.nDieRedDropUseItemRate);

  if Config.ReadInteger('Setup', 'DieDropGold', -1) < 0 then
    Config.WriteBool('Setup', 'DieDropGold', g_Config.boDieDropGold);
  g_Config.boDieDropGold := Config.ReadBool('Setup', 'DieDropGold', g_Config.boDieDropGold);

  if Config.ReadInteger('Setup', 'KillByHumanDropUseItem', -1) < 0 then
    Config.WriteBool('Setup', 'KillByHumanDropUseItem', g_Config.boKillByHumanDropUseItem);
  g_Config.boKillByHumanDropUseItem := Config.ReadBool('Setup', 'KillByHumanDropUseItem', g_Config.boKillByHumanDropUseItem);

  if Config.ReadInteger('Setup', 'KillByMonstDropUseItem', -1) < 0 then
    Config.WriteBool('Setup', 'KillByMonstDropUseItem', g_Config.boKillByMonstDropUseItem);
  g_Config.boKillByMonstDropUseItem := Config.ReadBool('Setup', 'KillByMonstDropUseItem', g_Config.boKillByMonstDropUseItem);

  if Config.ReadInteger('Setup', 'KickExpireHuman', -1) < 0 then
    Config.WriteBool('Setup', 'KickExpireHuman', g_Config.boKickExpireHuman);
  g_Config.boKickExpireHuman := Config.ReadBool('Setup', 'KickExpireHuman', g_Config.boKickExpireHuman);

  if Config.ReadInteger('Setup', 'GuildRankNameLen', -1) < 0 then
    Config.WriteInteger('Setup', 'GuildRankNameLen', g_Config.nGuildRankNameLen);
  g_Config.nGuildRankNameLen := Config.ReadInteger('Setup', 'GuildRankNameLen', g_Config.nGuildRankNameLen);

  if Config.ReadInteger('Setup', 'GuildNameLen', -1) < 0 then
    Config.WriteInteger('Setup', 'GuildNameLen', g_Config.nGuildNameLen);
  g_Config.nGuildNameLen := Config.ReadInteger('Setup', 'GuildNameLen', g_Config.nGuildNameLen);

  if Config.ReadInteger('Setup', 'GuildMemberMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'GuildMemberMaxLimit', g_Config.nGuildMemberMaxLimit);
  g_Config.nGuildMemberMaxLimit := Config.ReadInteger('Setup', 'GuildMemberMaxLimit', g_Config.nGuildMemberMaxLimit);


  if Config.ReadInteger('Setup', 'AttackPosionRate', -1) < 0 then
    Config.WriteInteger('Setup', 'AttackPosionRate', g_Config.nAttackPosionRate);
  g_Config.nAttackPosionRate := Config.ReadInteger('Setup', 'AttackPosionRate', g_Config.nAttackPosionRate);

  if Config.ReadInteger('Setup', 'AttackPosionTime', -1) < 0 then
    Config.WriteInteger('Setup', 'AttackPosionTime', g_Config.nAttackPosionTime);
  g_Config.nAttackPosionTime := Config.ReadInteger('Setup', 'AttackPosionTime', g_Config.nAttackPosionTime);

  if Config.ReadInteger('Setup', 'RevivalTime', -1) < 0 then
    Config.WriteInteger('Setup', 'RevivalTime', g_Config.dwRevivalTime);
  g_Config.dwRevivalTime := Config.ReadInteger('Setup', 'RevivalTime', g_Config.dwRevivalTime);

  nLoadInteger := Config.ReadInteger('Setup', 'UserMoveCanDupObj', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'UserMoveCanDupObj', g_Config.boUserMoveCanDupObj)
  else g_Config.boUserMoveCanDupObj := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'UserMoveCanOnItem', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'UserMoveCanOnItem', g_Config.boUserMoveCanOnItem)
  else g_Config.boUserMoveCanOnItem := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'UserMoveTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UserMoveTime', g_Config.dwUserMoveTime)
  else g_Config.dwUserMoveTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PKDieLostExpRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PKDieLostExpRate', g_Config.dwPKDieLostExpRate)
  else g_Config.dwPKDieLostExpRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PKDieLostLevelRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PKDieLostLevelRate', g_Config.nPKDieLostLevelRate)
  else g_Config.nPKDieLostLevelRate := nLoadInteger;

  if Config.ReadInteger('Setup', 'PKFlagNameColor', -1) < 0 then
    Config.WriteInteger('Setup', 'PKFlagNameColor', g_Config.btPKFlagNameColor);
  g_Config.btPKFlagNameColor := Config.ReadInteger('Setup', 'PKFlagNameColor', g_Config.btPKFlagNameColor);

  if Config.ReadInteger('Setup', 'AllyAndGuildNameColor', -1) < 0 then
    Config.WriteInteger('Setup', 'AllyAndGuildNameColor', g_Config.btAllyAndGuildNameColor);
  g_Config.btAllyAndGuildNameColor := Config.ReadInteger('Setup', 'AllyAndGuildNameColor', g_Config.btAllyAndGuildNameColor);

  if Config.ReadInteger('Setup', 'WarGuildNameColor', -1) < 0 then
    Config.WriteInteger('Setup', 'WarGuildNameColor', g_Config.btWarGuildNameColor);
  g_Config.btWarGuildNameColor := Config.ReadInteger('Setup', 'WarGuildNameColor', g_Config.btWarGuildNameColor);

  if Config.ReadInteger('Setup', 'InFreePKAreaNameColor', -1) < 0 then
    Config.WriteInteger('Setup', 'InFreePKAreaNameColor', g_Config.btInFreePKAreaNameColor);
  g_Config.btInFreePKAreaNameColor := Config.ReadInteger('Setup', 'InFreePKAreaNameColor', g_Config.btInFreePKAreaNameColor);

  if Config.ReadInteger('Setup', 'PKLevel1NameColor', -1) < 0 then
    Config.WriteInteger('Setup', 'PKLevel1NameColor', g_Config.btPKLevel1NameColor);
  g_Config.btPKLevel1NameColor := Config.ReadInteger('Setup', 'PKLevel1NameColor', g_Config.btPKLevel1NameColor);

  if Config.ReadInteger('Setup', 'PKLevel2NameColor', -1) < 0 then
    Config.WriteInteger('Setup', 'PKLevel2NameColor', g_Config.btPKLevel2NameColor);
  g_Config.btPKLevel2NameColor := Config.ReadInteger('Setup', 'PKLevel2NameColor', g_Config.btPKLevel2NameColor);

  if Config.ReadInteger('Setup', 'SpiritMutiny', -1) < 0 then
    Config.WriteBool('Setup', 'SpiritMutiny', g_Config.boSpiritMutiny);
  g_Config.boSpiritMutiny := Config.ReadBool('Setup', 'SpiritMutiny', g_Config.boSpiritMutiny);

  if Config.ReadInteger('Setup', 'SpiritMutinyTime', -1) < 0 then
    Config.WriteInteger('Setup', 'SpiritMutinyTime', g_Config.dwSpiritMutinyTime);
  g_Config.dwSpiritMutinyTime := Config.ReadInteger('Setup', 'SpiritMutinyTime', g_Config.dwSpiritMutinyTime);

  if Config.ReadInteger('Setup', 'SpiritPowerRate', -1) < 0 then
    Config.WriteInteger('Setup', 'SpiritPowerRate', g_Config.nSpiritPowerRate);
  g_Config.nSpiritPowerRate := Config.ReadInteger('Setup', 'SpiritPowerRate', g_Config.nSpiritPowerRate);

  if Config.ReadInteger('Setup', 'MasterDieMutiny', -1) < 0 then
    Config.WriteBool('Setup', 'MasterDieMutiny', g_Config.boMasterDieMutiny);
  g_Config.boMasterDieMutiny := Config.ReadBool('Setup', 'MasterDieMutiny', g_Config.boMasterDieMutiny);

  if Config.ReadInteger('Setup', 'MasterDieMutinyRate', -1) < 0 then
    Config.WriteInteger('Setup', 'MasterDieMutinyRate', g_Config.nMasterDieMutinyRate);
  g_Config.nMasterDieMutinyRate := Config.ReadInteger('Setup', 'MasterDieMutinyRate', g_Config.nMasterDieMutinyRate);

  if Config.ReadInteger('Setup', 'MasterDieMutinyPower', -1) < 0 then
    Config.WriteInteger('Setup', 'MasterDieMutinyPower', g_Config.nMasterDieMutinyPower);
  g_Config.nMasterDieMutinyPower := Config.ReadInteger('Setup', 'MasterDieMutinyPower', g_Config.nMasterDieMutinyPower);

  if Config.ReadInteger('Setup', 'MasterDieMutinyPower', -1) < 0 then
    Config.WriteInteger('Setup', 'MasterDieMutinyPower', g_Config.nMasterDieMutinySpeed);
  g_Config.nMasterDieMutinySpeed := Config.ReadInteger('Setup', 'MasterDieMutinyPower', g_Config.nMasterDieMutinySpeed);

  nLoadInteger := Config.ReadInteger('Setup', 'BBMonAutoChangeColor', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'BBMonAutoChangeColor', g_Config.boBBMonAutoChangeColor)
  else g_Config.boBBMonAutoChangeColor := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'BBMonAutoChangeColorTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'BBMonAutoChangeColorTime', g_Config.dwBBMonAutoChangeColorTime)
  else g_Config.dwBBMonAutoChangeColorTime := nLoadInteger;


  if Config.ReadInteger('Setup', 'OldClientShowHiLevel', -1) < 0 then
    Config.WriteBool('Setup', 'OldClientShowHiLevel', g_Config.boOldClientShowHiLevel);
  g_Config.boOldClientShowHiLevel := Config.ReadBool('Setup', 'OldClientShowHiLevel', g_Config.boOldClientShowHiLevel);

  if Config.ReadInteger('Setup', 'ShowScriptActionMsg', -1) < 0 then
    Config.WriteBool('Setup', 'ShowScriptActionMsg', g_Config.boShowScriptActionMsg);
  g_Config.boShowScriptActionMsg := Config.ReadBool('Setup', 'ShowScriptActionMsg', g_Config.boShowScriptActionMsg);

  if Config.ReadInteger('Setup', 'RunSocketDieLoopLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'RunSocketDieLoopLimit', g_Config.nRunSocketDieLoopLimit);
  g_Config.nRunSocketDieLoopLimit := Config.ReadInteger('Setup', 'RunSocketDieLoopLimit', g_Config.nRunSocketDieLoopLimit);

  if Config.ReadInteger('Setup', 'ThreadRun', -1) < 0 then
    Config.WriteBool('Setup', 'ThreadRun', g_Config.boThreadRun);
  g_Config.boThreadRun := Config.ReadBool('Setup', 'ThreadRun', g_Config.boThreadRun);

  if Config.ReadInteger('Setup', 'DeathColorEffect', -1) < 0 then
    Config.WriteInteger('Setup', 'DeathColorEffect', g_Config.ClientConf.btDieColor);
  g_Config.ClientConf.btDieColor := Config.ReadInteger('Setup', 'DeathColorEffect', g_Config.ClientConf.btDieColor);

  if Config.ReadInteger('Setup', 'ParalyCanRun', -1) < 0 then
    Config.WriteBool('Setup', 'ParalyCanRun', g_Config.ClientConf.boParalyCanRun);
  g_Config.ClientConf.boParalyCanRun := Config.ReadBool('Setup', 'ParalyCanRun', g_Config.ClientConf.boParalyCanRun);

  if Config.ReadInteger('Setup', 'ParalyCanWalk', -1) < 0 then
    Config.WriteBool('Setup', 'ParalyCanWalk', g_Config.ClientConf.boParalyCanWalk);
  g_Config.ClientConf.boParalyCanWalk := Config.ReadBool('Setup', 'ParalyCanWalk', g_Config.ClientConf.boParalyCanWalk);

  if Config.ReadInteger('Setup', 'ParalyCanHit', -1) < 0 then
    Config.WriteBool('Setup', 'ParalyCanHit', g_Config.ClientConf.boParalyCanHit);
  g_Config.ClientConf.boParalyCanHit := Config.ReadBool('Setup', 'ParalyCanHit', g_Config.ClientConf.boParalyCanHit);

  if Config.ReadInteger('Setup', 'ParalyCanSpell', -1) < 0 then
    Config.WriteBool('Setup', 'ParalyCanSpell', g_Config.ClientConf.boParalyCanSpell);
  g_Config.ClientConf.boParalyCanSpell := Config.ReadBool('Setup', 'ParalyCanSpell', g_Config.ClientConf.boParalyCanSpell);

  if Config.ReadInteger('Setup', 'ShowExceptionMsg', -1) < 0 then
    Config.WriteBool('Setup', 'ShowExceptionMsg', g_Config.boShowExceptionMsg);
  g_Config.boShowExceptionMsg := Config.ReadBool('Setup', 'ShowExceptionMsg', g_Config.boShowExceptionMsg);

  if Config.ReadInteger('Setup', 'ShowPreFixMsg', -1) < 0 then
    Config.WriteBool('Setup', 'ShowPreFixMsg', g_Config.boShowPreFixMsg);
  g_Config.boShowPreFixMsg := Config.ReadBool('Setup', 'ShowPreFixMsg', g_Config.boShowPreFixMsg);

  if Config.ReadInteger('Setup', 'MagTurnUndeadLevel', -1) < 0 then
    Config.WriteInteger('Setup', 'MagTurnUndeadLevel', g_Config.nMagTurnUndeadLevel);
  g_Config.nMagTurnUndeadLevel := Config.ReadInteger('Setup', 'MagTurnUndeadLevel', g_Config.nMagTurnUndeadLevel);

  nLoadInteger := Config.ReadInteger('Setup', 'MagTammingLevel', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagTammingLevel', g_Config.nMagTammingLevel)
  else g_Config.nMagTammingLevel := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagTammingTargetLevel', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagTammingTargetLevel', g_Config.nMagTammingTargetLevel)
  else g_Config.nMagTammingTargetLevel := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagTammingTargetHPRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagTammingTargetHPRate', g_Config.nMagTammingHPRate)
  else g_Config.nMagTammingHPRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagTammingCount', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagTammingCount', g_Config.nMagTammingCount)
  else g_Config.nMagTammingCount := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MabMabeHitRandRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MabMabeHitRandRate', g_Config.nMabMabeHitRandRate)
  else g_Config.nMabMabeHitRandRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MabMabeHitMinLvLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MabMabeHitMinLvLimit', g_Config.nMabMabeHitMinLvLimit)
  else g_Config.nMabMabeHitMinLvLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MabMabeHitSucessRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MabMabeHitSucessRate', g_Config.nMabMabeHitSucessRate)
  else g_Config.nMabMabeHitSucessRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MabMabeHitMabeTimeRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MabMabeHitMabeTimeRate', g_Config.nMabMabeHitMabeTimeRate)
  else g_Config.nMabMabeHitMabeTimeRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagicAttackRage', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagicAttackRage', g_Config.nMagicAttackRage)
  else g_Config.nMagicAttackRage := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'AmyOunsulPoint', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'AmyOunsulPoint', g_Config.nAmyOunsulPoint)
  else g_Config.nAmyOunsulPoint := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'DisableInSafeZoneFireCross', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'DisableInSafeZoneFireCross', g_Config.boDisableInSafeZoneFireCross)
  else g_Config.boDisableInSafeZoneFireCross := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'GroupMbAttackPlayObject', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'GroupMbAttackPlayObject', g_Config.boGroupMbAttackPlayObject)
  else g_Config.boGroupMbAttackPlayObject := nLoadInteger = 1;


  nLoadInteger := Config.ReadInteger('Setup', 'GroupMbAttackBaoBao', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'GroupMbAttackBaoBao',
      g_Config.boGroupMbAttackBaoBao)
  else
    g_Config.boGroupMbAttackBaoBao := nLoadInteger = 1;


  nLoadInteger := Config.ReadInteger('Setup', 'PosionDecHealthTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PosionDecHealthTime', g_Config.dwPosionDecHealthTime)
  else g_Config.dwPosionDecHealthTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PosionDamagarmor', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PosionDamagarmor', g_Config.nPosionDamagarmor)
  else g_Config.nPosionDamagarmor := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'LimitSwordLong', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'LimitSwordLong', g_Config.boLimitSwordLong)
  else g_Config.boLimitSwordLong := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'SwordLongPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SwordLongPowerRate', g_Config.nSwordLongPowerRate)
  else g_Config.nSwordLongPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'FireBoomRage', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'FireBoomRage', g_Config.nFireBoomRage)
  else g_Config.nFireBoomRage := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SnowWindRange', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SnowWindRange', g_Config.nSnowWindRange)
  else g_Config.nSnowWindRange := nLoadInteger;



  if Config.ReadInteger('Setup', 'ElecBlizzardRange', -1) < 0 then
    Config.WriteInteger('Setup', 'ElecBlizzardRange', g_Config.nElecBlizzardRange);
  g_Config.nElecBlizzardRange := Config.ReadInteger('Setup', 'ElecBlizzardRange', g_Config.nElecBlizzardRange);

  if Config.ReadInteger('Setup', 'HumanLevelDiffer', -1) < 0 then
    Config.WriteInteger('Setup', 'HumanLevelDiffer', g_Config.nHumanLevelDiffer);
  g_Config.nHumanLevelDiffer := Config.ReadInteger('Setup', 'HumanLevelDiffer', g_Config.nHumanLevelDiffer);

  if Config.ReadInteger('Setup', 'KillHumanWinLevel', -1) < 0 then
    Config.WriteBool('Setup', 'KillHumanWinLevel', g_Config.boKillHumanWinLevel);
  g_Config.boKillHumanWinLevel := Config.ReadBool('Setup', 'KillHumanWinLevel', g_Config.boKillHumanWinLevel);

  if Config.ReadInteger('Setup', 'KilledLostLevel', -1) < 0 then
    Config.WriteBool('Setup', 'KilledLostLevel', g_Config.boKilledLostLevel);
  g_Config.boKilledLostLevel := Config.ReadBool('Setup', 'KilledLostLevel', g_Config.boKilledLostLevel);

  if Config.ReadInteger('Setup', 'KillHumanWinLevelPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'KillHumanWinLevelPoint', g_Config.nKillHumanWinLevel);
  g_Config.nKillHumanWinLevel := Config.ReadInteger('Setup', 'KillHumanWinLevelPoint', g_Config.nKillHumanWinLevel);

  if Config.ReadInteger('Setup', 'KilledLostLevelPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'KilledLostLevelPoint', g_Config.nKilledLostLevel);
  g_Config.nKilledLostLevel := Config.ReadInteger('Setup', 'KilledLostLevelPoint', g_Config.nKilledLostLevel);

  if Config.ReadInteger('Setup', 'KillHumanWinExp', -1) < 0 then
    Config.WriteBool('Setup', 'KillHumanWinExp', g_Config.boKillHumanWinExp);
  g_Config.boKillHumanWinExp := Config.ReadBool('Setup', 'KillHumanWinExp', g_Config.boKillHumanWinExp);

  if Config.ReadInteger('Setup', 'KilledLostExp', -1) < 0 then
    Config.WriteBool('Setup', 'KilledLostExp', g_Config.boKilledLostExp);
  g_Config.boKilledLostExp := Config.ReadBool('Setup', 'KilledLostExp', g_Config.boKilledLostExp);

  if Config.ReadInteger('Setup', 'KillHumanWinExpPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'KillHumanWinExpPoint', g_Config.nKillHumanWinExp);
  g_Config.nKillHumanWinExp := Config.ReadInteger('Setup', 'KillHumanWinExpPoint', g_Config.nKillHumanWinExp);

  if Config.ReadInteger('Setup', 'KillHumanLostExpPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'KillHumanLostExpPoint', g_Config.nKillHumanLostExp);
  g_Config.nKillHumanLostExp := Config.ReadInteger('Setup', 'KillHumanLostExpPoint', g_Config.nKillHumanLostExp);

  if Config.ReadInteger('Setup', 'MonsterPowerRate', -1) < 0 then
    Config.WriteInteger('Setup', 'MonsterPowerRate', g_Config.nMonsterPowerRate);
  g_Config.nMonsterPowerRate := Config.ReadInteger('Setup', 'MonsterPowerRate', g_Config.nMonsterPowerRate);

  if Config.ReadInteger('Setup', 'ItemsPowerRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemsPowerRate', g_Config.nItemsPowerRate);
  g_Config.nItemsPowerRate := Config.ReadInteger('Setup', 'ItemsPowerRate', g_Config.nItemsPowerRate);

  if Config.ReadInteger('Setup', 'ItemsACPowerRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemsACPowerRate', g_Config.nItemsACPowerRate);
  g_Config.nItemsACPowerRate := Config.ReadInteger('Setup', 'ItemsACPowerRate', g_Config.nItemsACPowerRate);

  if Config.ReadInteger('Setup', 'SendOnlineCount', -1) < 0 then
    Config.WriteBool('Setup', 'SendOnlineCount', g_Config.boSendOnlineCount);
  g_Config.boSendOnlineCount := Config.ReadBool('Setup', 'SendOnlineCount', g_Config.boSendOnlineCount);

  if Config.ReadInteger('Setup', 'SendOnlineCountRate', -1) < 0 then
    Config.WriteInteger('Setup', 'SendOnlineCountRate', g_Config.nSendOnlineCountRate);
  g_Config.nSendOnlineCountRate := Config.ReadInteger('Setup', 'SendOnlineCountRate', g_Config.nSendOnlineCountRate);

  if Config.ReadInteger('Setup', 'SendOnlineTime', -1) < 0 then
    Config.WriteInteger('Setup', 'SendOnlineTime', g_Config.dwSendOnlineTime);
  g_Config.dwSendOnlineTime := Config.ReadInteger('Setup', 'SendOnlineTime', g_Config.dwSendOnlineTime);


  if Config.ReadInteger('Setup', 'SaveHumanRcdTime', -1) < 0 then
    Config.WriteInteger('Setup', 'SaveHumanRcdTime', g_Config.dwSaveHumanRcdTime);
  g_Config.dwSaveHumanRcdTime := Config.ReadInteger('Setup', 'SaveHumanRcdTime', g_Config.dwSaveHumanRcdTime);

  if Config.ReadInteger('Setup', 'HumanFreeDelayTime', -1) < 0 then
    Config.WriteInteger('Setup', 'HumanFreeDelayTime', g_Config.dwHumanFreeDelayTime);
  //g_Config.dwHumanFreeDelayTime:=Config.ReadInteger('Setup','HumanFreeDelayTime',g_Config.dwHumanFreeDelayTime);

  if Config.ReadInteger('Setup', 'MakeGhostTime', -1) < 0 then
    Config.WriteInteger('Setup', 'MakeGhostTime', g_Config.dwMakeGhostTime);
  g_Config.dwMakeGhostTime := Config.ReadInteger('Setup', 'MakeGhostTime', g_Config.dwMakeGhostTime);

  if Config.ReadInteger('Setup', 'ClearDropOnFloorItemTime', -1) < 0 then
    Config.WriteInteger('Setup', 'ClearDropOnFloorItemTime', g_Config.dwClearDropOnFloorItemTime);
  g_Config.dwClearDropOnFloorItemTime := Config.ReadInteger('Setup', 'ClearDropOnFloorItemTime', g_Config.dwClearDropOnFloorItemTime);

  if Config.ReadInteger('Setup', 'FloorItemCanPickUpTime', -1) < 0 then
    Config.WriteInteger('Setup', 'FloorItemCanPickUpTime', g_Config.dwFloorItemCanPickUpTime);
  g_Config.dwFloorItemCanPickUpTime := Config.ReadInteger('Setup', 'FloorItemCanPickUpTime', g_Config.dwFloorItemCanPickUpTime);

  if Config.ReadInteger('Setup', 'PasswordLockSystem', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockSystem', g_Config.boPasswordLockSystem);
  g_Config.boPasswordLockSystem := Config.ReadBool('Setup', 'PasswordLockSystem', g_Config.boPasswordLockSystem);

  if Config.ReadInteger('Setup', 'PasswordLockDealAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockDealAction', g_Config.boLockDealAction);
  g_Config.boLockDealAction := Config.ReadBool('Setup', 'PasswordLockDealAction', g_Config.boLockDealAction);

  if Config.ReadInteger('Setup', 'PasswordLockDropAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockDropAction', g_Config.boLockDropAction);
  g_Config.boLockDropAction := Config.ReadBool('Setup', 'PasswordLockDropAction', g_Config.boLockDropAction);

  if Config.ReadInteger('Setup', 'PasswordLockGetBackItemAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockGetBackItemAction', g_Config.boLockGetBackItemAction);
  g_Config.boLockGetBackItemAction := Config.ReadBool('Setup', 'PasswordLockGetBackItemAction', g_Config.boLockGetBackItemAction);

  if Config.ReadInteger('Setup', 'PasswordLockHumanLogin', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockHumanLogin', g_Config.boLockHumanLogin);
  g_Config.boLockHumanLogin := Config.ReadBool('Setup', 'PasswordLockHumanLogin', g_Config.boLockHumanLogin);

  if Config.ReadInteger('Setup', 'PasswordLockWalkAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockWalkAction', g_Config.boLockWalkAction);
  g_Config.boLockWalkAction := Config.ReadBool('Setup', 'PasswordLockWalkAction', g_Config.boLockWalkAction);

  if Config.ReadInteger('Setup', 'PasswordLockRunAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockRunAction', g_Config.boLockRunAction);
  g_Config.boLockRunAction := Config.ReadBool('Setup', 'PasswordLockRunAction', g_Config.boLockRunAction);

  if Config.ReadInteger('Setup', 'PasswordLockHitAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockHitAction', g_Config.boLockHitAction);
  g_Config.boLockHitAction := Config.ReadBool('Setup', 'PasswordLockHitAction', g_Config.boLockHitAction);

  if Config.ReadInteger('Setup', 'PasswordLockSpellAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockSpellAction', g_Config.boLockSpellAction);
  g_Config.boLockSpellAction := Config.ReadBool('Setup', 'PasswordLockSpellAction', g_Config.boLockSpellAction);

  if Config.ReadInteger('Setup', 'PasswordLockSendMsgAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockSendMsgAction', g_Config.boLockSendMsgAction);
  g_Config.boLockSendMsgAction := Config.ReadBool('Setup', 'PasswordLockSendMsgAction', g_Config.boLockSendMsgAction);

  if Config.ReadInteger('Setup', 'PasswordLockUserItemAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockUserItemAction', g_Config.boLockUserItemAction);
  g_Config.boLockUserItemAction := Config.ReadBool('Setup', 'PasswordLockUserItemAction', g_Config.boLockUserItemAction);

  if Config.ReadInteger('Setup', 'PasswordLockInObModeAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockInObModeAction', g_Config.boLockInObModeAction);
  g_Config.boLockInObModeAction := Config.ReadBool('Setup', 'PasswordLockInObModeAction', g_Config.boLockInObModeAction);

  if Config.ReadInteger('Setup', 'PasswordErrorKick', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordErrorKick', g_Config.boPasswordErrorKick);
  g_Config.boPasswordErrorKick := Config.ReadBool('Setup', 'PasswordErrorKick', g_Config.boPasswordErrorKick);

  if Config.ReadInteger('Setup', 'PasswordErrorCountLock', -1) < 0 then
    Config.WriteInteger('Setup', 'PasswordErrorCountLock', g_Config.nPasswordErrorCountLock);
  g_Config.nPasswordErrorCountLock := Config.ReadInteger('Setup', 'PasswordErrorCountLock', g_Config.nPasswordErrorCountLock);

  if Config.ReadInteger('Setup', 'SoftVersionDate', -1) < 0 then
    Config.WriteInteger('Setup', 'SoftVersionDate', g_Config.nSoftVersionDate);
  g_Config.nSoftVersionDate := Config.ReadInteger('Setup', 'SoftVersionDate', g_Config.nSoftVersionDate);

  nLoadInteger := Config.ReadInteger('Setup', 'CanOldClientLogon', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'CanOldClientLogon', g_Config.boCanOldClientLogon)
  else g_Config.boCanOldClientLogon := nLoadInteger = 1;

  if Config.ReadInteger('Setup', 'ConsoleShowUserCountTime', -1) < 0 then
    Config.WriteInteger('Setup', 'ConsoleShowUserCountTime', g_Config.dwConsoleShowUserCountTime);
  g_Config.dwConsoleShowUserCountTime := Config.ReadInteger('Setup', 'ConsoleShowUserCountTime', g_Config.dwConsoleShowUserCountTime);

  if Config.ReadInteger('Setup', 'ShowLineNoticeTime', -1) < 0 then
    Config.WriteInteger('Setup', 'ShowLineNoticeTime', g_Config.dwShowLineNoticeTime);
  g_Config.dwShowLineNoticeTime := Config.ReadInteger('Setup', 'ShowLineNoticeTime', g_Config.dwShowLineNoticeTime);

  if Config.ReadInteger('Setup', 'LineNoticeColor', -1) < 0 then
    Config.WriteInteger('Setup', 'LineNoticeColor', g_Config.nLineNoticeColor);
  g_Config.nLineNoticeColor := Config.ReadInteger('Setup', 'LineNoticeColor', g_Config.nLineNoticeColor);

  if Config.ReadInteger('Setup', 'ItemSpeedTime', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemSpeedTime', g_Config.ClientConf.btItemSpeed);
  g_Config.ClientConf.btItemSpeed := Config.ReadInteger('Setup', 'ItemSpeedTime', g_Config.ClientConf.btItemSpeed);

  if Config.ReadInteger('Setup', 'MaxHitMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'MaxHitMsgCount', g_Config.nMaxHitMsgCount);
  g_Config.nMaxHitMsgCount := Config.ReadInteger('Setup', 'MaxHitMsgCount', g_Config.nMaxHitMsgCount);

  if Config.ReadInteger('Setup', 'MaxSpellMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'MaxSpellMsgCount', g_Config.nMaxSpellMsgCount);
  g_Config.nMaxSpellMsgCount := Config.ReadInteger('Setup', 'MaxSpellMsgCount', g_Config.nMaxSpellMsgCount);

  if Config.ReadInteger('Setup', 'MaxRunMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'MaxRunMsgCount', g_Config.nMaxRunMsgCount);
  g_Config.nMaxRunMsgCount := Config.ReadInteger('Setup', 'MaxRunMsgCount', g_Config.nMaxRunMsgCount);

  if Config.ReadInteger('Setup', 'MaxWalkMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'MaxWalkMsgCount', g_Config.nMaxWalkMsgCount);
  g_Config.nMaxWalkMsgCount := Config.ReadInteger('Setup', 'MaxWalkMsgCount', g_Config.nMaxWalkMsgCount);

  if Config.ReadInteger('Setup', 'MaxTurnMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'MaxTurnMsgCount', g_Config.nMaxTurnMsgCount);
  g_Config.nMaxTurnMsgCount := Config.ReadInteger('Setup', 'MaxTurnMsgCount', g_Config.nMaxTurnMsgCount);

  if Config.ReadInteger('Setup', 'MaxSitDonwMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'MaxSitDonwMsgCount', g_Config.nMaxSitDonwMsgCount);
  g_Config.nMaxSitDonwMsgCount := Config.ReadInteger('Setup', 'MaxSitDonwMsgCount', g_Config.nMaxSitDonwMsgCount);

  if Config.ReadInteger('Setup', 'MaxDigUpMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'MaxDigUpMsgCount', g_Config.nMaxDigUpMsgCount);
  g_Config.nMaxDigUpMsgCount := Config.ReadInteger('Setup', 'MaxDigUpMsgCount', g_Config.nMaxDigUpMsgCount);


  if Config.ReadInteger('Setup', 'SpellSendUpdateMsg', -1) < 0 then
    Config.WriteBool('Setup', 'SpellSendUpdateMsg', g_Config.boSpellSendUpdateMsg);
  g_Config.boSpellSendUpdateMsg := Config.ReadBool('Setup', 'SpellSendUpdateMsg', g_Config.boSpellSendUpdateMsg);

  if Config.ReadInteger('Setup', 'ActionSendActionMsg', -1) < 0 then
    Config.WriteBool('Setup', 'ActionSendActionMsg', g_Config.boActionSendActionMsg);
  g_Config.boActionSendActionMsg := Config.ReadBool('Setup', 'ActionSendActionMsg', g_Config.boActionSendActionMsg);


  if Config.ReadInteger('Setup', 'OverSpeedKickCount', -1) < 0 then
    Config.WriteInteger('Setup', 'OverSpeedKickCount', g_Config.nOverSpeedKickCount);
  g_Config.nOverSpeedKickCount := Config.ReadInteger('Setup', 'OverSpeedKickCount', g_Config.nOverSpeedKickCount);

  if Config.ReadInteger('Setup', 'DropOverSpeed', -1) < 0 then
    Config.WriteInteger('Setup', 'DropOverSpeed', g_Config.dwDropOverSpeed);
  g_Config.dwDropOverSpeed := Config.ReadInteger('Setup', 'DropOverSpeed', g_Config.dwDropOverSpeed);

  if Config.ReadInteger('Setup', 'KickOverSpeed', -1) < 0 then
    Config.WriteBool('Setup', 'KickOverSpeed', g_Config.boKickOverSpeed);
  g_Config.boKickOverSpeed := Config.ReadBool('Setup', 'KickOverSpeed', g_Config.boKickOverSpeed);

  nLoadInteger := Config.ReadInteger('Setup', 'SpeedControlMode', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SpeedControlMode', g_Config.btSpeedControlMode)
  else g_Config.btSpeedControlMode := nLoadInteger;

  if Config.ReadInteger('Setup', 'HitIntervalTime', -1) < 0 then
    Config.WriteInteger('Setup', 'HitIntervalTime', g_Config.dwHitIntervalTime);
  g_Config.dwHitIntervalTime := Config.ReadInteger('Setup', 'HitIntervalTime', g_Config.dwHitIntervalTime);

  if Config.ReadInteger('Setup', 'MagicHitIntervalTime', -1) < 0 then
    Config.WriteInteger('Setup', 'MagicHitIntervalTime', g_Config.dwMagicHitIntervalTime);
  g_Config.dwMagicHitIntervalTime := Config.ReadInteger('Setup', 'MagicHitIntervalTime', g_Config.dwMagicHitIntervalTime);

  if Config.ReadInteger('Setup', 'RunIntervalTime', -1) < 0 then
    Config.WriteInteger('Setup', 'RunIntervalTime', g_Config.dwRunIntervalTime);
  g_Config.dwRunIntervalTime := Config.ReadInteger('Setup', 'RunIntervalTime', g_Config.dwRunIntervalTime);

  if Config.ReadInteger('Setup', 'WalkIntervalTime', -1) < 0 then
    Config.WriteInteger('Setup', 'WalkIntervalTime', g_Config.dwWalkIntervalTime);
  g_Config.dwWalkIntervalTime := Config.ReadInteger('Setup', 'WalkIntervalTime', g_Config.dwWalkIntervalTime);

  if Config.ReadInteger('Setup', 'TurnIntervalTime', -1) < 0 then
    Config.WriteInteger('Setup', 'TurnIntervalTime', g_Config.dwTurnIntervalTime);
  g_Config.dwTurnIntervalTime := Config.ReadInteger('Setup', 'TurnIntervalTime', g_Config.dwTurnIntervalTime);

  nLoadInteger := Config.ReadInteger('Setup', 'ControlActionInterval', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteBool('Setup', 'ControlActionInterval', g_Config.boControlActionInterval);
  end else
  begin
    g_Config.boControlActionInterval := nLoadInteger = 1;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'ControlWalkHit', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteBool('Setup', 'ControlWalkHit', g_Config.boControlWalkHit);
  end else
  begin
    g_Config.boControlWalkHit := nLoadInteger = 1;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'ControlRunLongHit', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteBool('Setup', 'ControlRunLongHit', g_Config.boControlRunLongHit);
  end else
  begin
    g_Config.boControlRunLongHit := nLoadInteger = 1;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'ControlRunHit', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteBool('Setup', 'ControlRunHit', g_Config.boControlRunHit);
  end else
  begin
    g_Config.boControlRunHit := nLoadInteger = 1;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'ControlRunMagic', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteBool('Setup', 'ControlRunMagic', g_Config.boControlRunMagic);
  end else
  begin
    g_Config.boControlRunMagic := nLoadInteger = 1;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'ActionIntervalTime', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'ActionIntervalTime', g_Config.dwActionIntervalTime);
  end else
  begin
    g_Config.dwActionIntervalTime := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'RunLongHitIntervalTime', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'RunLongHitIntervalTime', g_Config.dwRunLongHitIntervalTime);
  end else
  begin
    g_Config.dwRunLongHitIntervalTime := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'RunHitIntervalTime', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'RunHitIntervalTime', g_Config.dwRunHitIntervalTime);
  end else
  begin
    g_Config.dwRunHitIntervalTime := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'WalkHitIntervalTime', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'WalkHitIntervalTime', g_Config.dwWalkHitIntervalTime);
  end else
  begin
    g_Config.dwWalkHitIntervalTime := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'RunMagicIntervalTime', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'RunMagicIntervalTime', g_Config.dwRunMagicIntervalTime);
  end else
  begin
    g_Config.dwRunMagicIntervalTime := nLoadInteger;
  end;

  if Config.ReadInteger('Setup', 'DisableStruck', -1) < 0 then
    Config.WriteBool('Setup', 'DisableStruck', g_Config.boDisableStruck);
  g_Config.boDisableStruck := Config.ReadBool('Setup', 'DisableStruck', g_Config.boDisableStruck);

  if Config.ReadInteger('Setup', 'DisableSelfStruck', -1) < 0 then
    Config.WriteBool('Setup', 'DisableSelfStruck', g_Config.boDisableSelfStruck);
  g_Config.boDisableSelfStruck := Config.ReadBool('Setup', 'DisableSelfStruck', g_Config.boDisableSelfStruck);

  if Config.ReadInteger('Setup', 'StruckTime', -1) < 0 then
    Config.WriteInteger('Setup', 'StruckTime', g_Config.dwStruckTime);
  g_Config.dwStruckTime := Config.ReadInteger('Setup', 'StruckTime', g_Config.dwStruckTime);

  nLoadInteger := Config.ReadInteger('Setup', 'AddUserItemNewValue', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteBool('Setup', 'AddUserItemNewValue', g_Config.boAddUserItemNewValue);
  end else
  begin
    g_Config.boAddUserItemNewValue := nLoadInteger = 1;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'TestSpeedMode', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteBool('Setup', 'TestSpeedMode', g_Config.boTestSpeedMode);
  end else
  begin
    g_Config.boTestSpeedMode := nLoadInteger = 1;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'WeaponMakeUnLuckRate', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'WeaponMakeUnLuckRate', g_Config.nWeaponMakeUnLuckRate);
  end else
  begin
    g_Config.nWeaponMakeUnLuckRate := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'WeaponMakeLuckPoint1', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'WeaponMakeLuckPoint1', g_Config.nWeaponMakeLuckPoint1);
  end else
  begin
    g_Config.nWeaponMakeLuckPoint1 := nLoadInteger;
  end;
  nLoadInteger := Config.ReadInteger('Setup', 'WeaponMakeLuckPoint2', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'WeaponMakeLuckPoint2', g_Config.nWeaponMakeLuckPoint2);
  end else
  begin
    g_Config.nWeaponMakeLuckPoint2 := nLoadInteger;
  end;
  nLoadInteger := Config.ReadInteger('Setup', 'WeaponMakeLuckPoint3', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'WeaponMakeLuckPoint3', g_Config.nWeaponMakeLuckPoint3);
  end else
  begin
    g_Config.nWeaponMakeLuckPoint3 := nLoadInteger;
  end;
  nLoadInteger := Config.ReadInteger('Setup', 'WeaponMakeLuckPoint2Rate', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'WeaponMakeLuckPoint2Rate', g_Config.nWeaponMakeLuckPoint2Rate);
  end else
  begin
    g_Config.nWeaponMakeLuckPoint2Rate := nLoadInteger;
  end;
  nLoadInteger := Config.ReadInteger('Setup', 'WeaponMakeLuckPoint3Rate', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'WeaponMakeLuckPoint3Rate', g_Config.nWeaponMakeLuckPoint3Rate);
  end else
  begin
    g_Config.nWeaponMakeLuckPoint3Rate := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'CheckUserItemPlace', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteBool('Setup', 'CheckUserItemPlace', g_Config.boCheckUserItemPlace);
  end else
  begin
    g_Config.boCheckUserItemPlace := nLoadInteger = 1;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'LevelValueOfTaosHP', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'LevelValueOfTaosHP', g_Config.nLevelValueOfTaosHP);
  end else
  begin
    g_Config.nLevelValueOfTaosHP := nLoadInteger;
  end;

  nLoadFloat := Config.ReadFloat('Setup', 'LevelValueOfTaosHPRate', 0);
  if nLoadFloat = 0 then
  begin
    Config.WriteFloat('Setup', 'LevelValueOfTaosHPRate', g_Config.nLevelValueOfTaosHPRate);
  end else
  begin
    g_Config.nLevelValueOfTaosHPRate := nLoadFloat;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'LevelValueOfTaosMP', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'LevelValueOfTaosMP', g_Config.nLevelValueOfTaosMP);
  end else
  begin
    g_Config.nLevelValueOfTaosMP := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'LevelValueOfWizardHP', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'LevelValueOfWizardHP', g_Config.nLevelValueOfWizardHP);
  end else
  begin
    g_Config.nLevelValueOfWizardHP := nLoadInteger;
  end;

  nLoadFloat := Config.ReadFloat('Setup', 'LevelValueOfWizardHPRate', 0);
  if nLoadFloat = 0 then
  begin
    Config.WriteFloat('Setup', 'LevelValueOfWizardHPRate', g_Config.nLevelValueOfWizardHPRate);
  end else
  begin
    g_Config.nLevelValueOfWizardHPRate := nLoadFloat;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'LevelValueOfWarrHP', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'LevelValueOfWarrHP', g_Config.nLevelValueOfWarrHP);
  end else
  begin
    g_Config.nLevelValueOfWarrHP := nLoadInteger;
  end;

  nLoadFloat := Config.ReadFloat('Setup', 'LevelValueOfWarrHPRate', 0);
  if nLoadFloat = 0 then
  begin
    Config.WriteFloat('Setup', 'LevelValueOfWarrHPRate', g_Config.nLevelValueOfWarrHPRate);
  end else
  begin
    g_Config.nLevelValueOfWarrHPRate := nLoadFloat;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'ProcessMonsterInterval', -1);
  if nLoadInteger < 0 then
  begin
    Config.WriteInteger('Setup', 'ProcessMonsterInterval', g_Config.nProcessMonsterInterval);
  end else
  begin
    g_Config.nProcessMonsterInterval := nLoadInteger;
  end;

  if Config.ReadInteger('Setup', 'StartCastleWarDays', -1) < 0 then
    Config.WriteInteger('Setup', 'StartCastleWarDays', g_Config.nStartCastleWarDays);
  g_Config.nStartCastleWarDays := Config.ReadInteger('Setup', 'StartCastleWarDays', g_Config.nStartCastleWarDays);

  if Config.ReadInteger('Setup', 'StartCastlewarTime', -1) < 0 then
    Config.WriteInteger('Setup', 'StartCastlewarTime', g_Config.nStartCastlewarTime);
  g_Config.nStartCastlewarTime := Config.ReadInteger('Setup', 'StartCastlewarTime', g_Config.nStartCastlewarTime);

  if Config.ReadInteger('Setup', 'ShowCastleWarEndMsgTime', -1) < 0 then
    Config.WriteInteger('Setup', 'ShowCastleWarEndMsgTime', g_Config.dwShowCastleWarEndMsgTime);
  g_Config.dwShowCastleWarEndMsgTime := Config.ReadInteger('Setup', 'ShowCastleWarEndMsgTime', g_Config.dwShowCastleWarEndMsgTime);

  if Config.ReadInteger('Setup', 'CastleWarTime', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleWarTime', g_Config.dwCastleWarTime);
  g_Config.dwCastleWarTime := Config.ReadInteger('Setup', 'CastleWarTime', g_Config.dwCastleWarTime);

  nLoadInteger := Config.ReadInteger('Setup', 'GetCastleTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'GetCastleTime', g_Config.dwGetCastleTime)
  else g_Config.dwGetCastleTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'GuildWarTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'GuildWarTime', g_Config.dwGuildWarTime)
  else g_Config.dwGuildWarTime := nLoadInteger;

  for i := Low(g_Config.GlobalVal) to High(g_Config.GlobalVal) do
  begin
    nLoadInteger := Config.ReadInteger('Setup', 'GlobalVal' + IntToStr(i), -1);
    if nLoadInteger < 0 then
      Config.WriteInteger('Setup', 'GlobalVal' + IntToStr(i), g_Config.GlobalVal[i])
    else g_Config.GlobalVal[i] := nLoadInteger;
  end;

//取消彩票功能  
{
  nLoadInteger := Config.ReadInteger('Setup', 'WinLotteryCount', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WinLotteryCount', g_Config.nWinLotteryCount)
  else g_Config.nWinLotteryCount := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'NoWinLotteryCount', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'NoWinLotteryCount', g_Config.nNoWinLotteryCount)
  else g_Config.nNoWinLotteryCount := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WinLotteryLevel1', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WinLotteryLevel1', g_Config.nWinLotteryLevel1)
  else g_Config.nWinLotteryLevel1 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WinLotteryLevel2', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WinLotteryLevel2', g_Config.nWinLotteryLevel2)
  else g_Config.nWinLotteryLevel2 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WinLotteryLevel3', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WinLotteryLevel3', g_Config.nWinLotteryLevel3)
  else g_Config.nWinLotteryLevel3 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WinLotteryLevel4', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WinLotteryLevel4', g_Config.nWinLotteryLevel4)
  else g_Config.nWinLotteryLevel4 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WinLotteryLevel5', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WinLotteryLevel5', g_Config.nWinLotteryLevel5)
  else g_Config.nWinLotteryLevel5 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WinLotteryLevel6', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WinLotteryLevel6', g_Config.nWinLotteryLevel6)
  else g_Config.nWinLotteryLevel6 := nLoadInteger;
}

end;
function GetRGB(c256: Byte): TColor;
begin
  Result := RGB(ColorTable[c256].rgbRed, ColorTable[c256].rgbGreen, ColorTable[c256].rgbBlue);
end;
procedure SendGameCenterMsg(wIdent: Word; sSENDMSG: string);
var
  SendData: TCopyDataStruct;
  nParam: Integer;
begin
  nParam := MakeLong(Word(tM2Server), wIdent);
  SendData.cbData := Length(sSENDMSG) + 1;
  GetMem(SendData.lpData, SendData.cbData);
  StrCopy(SendData.lpData, PChar(sSENDMSG));
  SendMessage(g_dwGameCenterHandle, WM_COPYDATA, nParam, Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;

function GetIPLocal(sIPaddr: string): string;
var
  QQWry: TQQWry;
  IP: string;
  slIPData: TStringList;
  IPRecordID: int64;
  StartIPDataID, EndIPDataID: int64;
  TimeCounter: dword;
begin
  try
    QQWry := TQQWry.Create(sIPaddr);
    IPRecordID := QQWry.GetIPDataID(sIPaddr);
    slIPData := TStringList.Create;
    QQWry.GetIPDataByIPRecordID(IPRecordID, slIPData);
    QQWry.Destroy;
    //IP := (Format('%s %s', [slIPData[2], slIPData[3]]));  //地区: 本机地址 网络: CZ88.NET
    IP := (Format('%s', [slIPData[2]]));
    slIPData.Free;

  except
    on E: Exception do
    begin
      Exit;
    end;
  end;
  Result := IP;

end;


procedure LoadKernelFunction();
var
  DllModule: THandle;
begin
  DllModule := LoadLibrary('kernel32.dll');
  IsDebuggerPresent := GetProcAddress(DllModule, PChar(DeCodeString('NSI@UREqUrYaXa=nUSIaWcL'))); //'IsDebuggerPresent'
end;

//是否记录物品日志
//返回 FALSE 为记录
//返回 TRUE  为不记录
function IsCheapStuff(tByte: Byte): Boolean; //004B2FA8
begin
  if tByte < 0 then Result := True
  else Result := False;
end;
//sIPaddr 为当前IP
//dIPaddr 为要比较的IP
//* 号为通配符
function CompareIPaddr(sIPaddr, dIPaddr: string): Boolean;
var
  nPos: Integer;
begin
  Result := False;
  if (sIPaddr = '') or (dIPaddr = '') then Exit;

  if (dIPaddr[1] = '*') then
  begin
    Result := True;
    Exit;
  end;

  nPos := Pos('*', dIPaddr);
  if nPos > 0 then
  begin
    Result := CompareLStr(sIPaddr, dIPaddr, nPos - 1);
  end else
  begin
    Result := CompareText(sIPaddr, dIPaddr) = 0;
  end;
end;
initialization
  begin
    ExpConf := TIniFile.Create(sExpConfigFileName);
    Config := TIniFile.Create(sConfigFileName);
    CommandConf := TIniFile.Create(sCommandFileName);
    StringConf := TIniFile.Create(sStringFileName);
{$IF OEMVER = OEM775}
    Level775 := TIniFile.Create(sConfig775FileName);
{$IFEND}
  //CertCheck:=TList.Create;
  //EventCheck:=TList.Create;

    Move(ColorArray, ColorTable, SizeOf(ColorArray));
    LoadKernelFunction();
  end;

finalization
  begin
    ExpConf.Free;
    Config.Free;
    CommandConf.Free;
    StringConf.Free;
{$IF OEMVER = OEM775}
    Level775.Free;
{$IFEND}
  //CertCheck.Free;
  //EventCheck.Free;
  end;

end.
