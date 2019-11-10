unit LSShare;

interface
uses
  Windows,Messages,Classes,SysUtils,SyncObjs,MudUtil,IniFiles,Grobal2, SDK;
const 

  IDFILEMODE  = 0; //文件模式
  IDDBMODE    = 1; //数据库模式

  IDMODE      = IDFILEMODE;
  
type
  TGateNet = record
    sIPaddr   :String;
    nPort     :Integer;
    boEnable  :Boolean;
  end;
  TGateRoute = record
    sServerName  :String;
    sTitle       :String;
    sRemoteAddr  :String;
    sPublicAddr  :String;
    nSelIdx      :Integer;
    Gate         :array [0..9] of TGateNet;
  end;
  TConfig = record
    IniConf         :TIniFile;
    boRemoteClose   :Boolean;
    sDBServer       :String[30];    //0x00475368
    nDBSPort        :Integer;   //0x00475374
    sFeeServer      :String[30];    //0x0047536C
    nFeePort        :Integer;   //0x00475378
    sLogServer      :String[30];    //0x00475370
    nLogPort        :Integer;   //0x0047537C
    sGateAddr       :String[30];
    nGatePort       :Integer;
    sServerAddr     :String[30];
    nServerPort     :Integer;
    sMonAddr        :String[30];
    nMonPort        :Integer;
    sGateIPaddr     :String[30]; //当前处理的网关连接IP地址
    sIdDir          :String[50];
    sWebLogDir      :String[50];
    sFeedIDList     :String[50];
    sFeedIPList     :String[50];
    sCountLogDir    :String[50];
    sChrLogDir      :String[50];
    boTestServer    :Boolean;
    boEnableMakingID:Boolean;
    boDynamicIPMode :Boolean;
    nReadyServers   :Integer;

    GateCriticalSection :TRTLCriticalSection;
    GateList            :TList;
    SessionList         :TGList;
    ServerNameList      :TStringList;
    AccountCostList     :TQuickList;
    IPaddrCostList      :TQuickList;
    boShowDetailMsg     :Boolean;
    dwProcessGateTick   :LongWord;          //0x00475380
    dwProcessGateTime   :LongWord;          //0x00475384
    nRouteCount         :Integer;//0x47328C
    GateRoute           :array[0..59] of TGateRoute;
  end;
  pTConfig = ^TConfig;
  function GetCodeMsgSize(X: Double):Integer;
  function CheckAccountName(sName:String):Boolean;
  function GetSessionID():Integer;
  procedure SaveGateConfig(Config:pTConfig);
  function GetGatePublicAddr(Config:pTConfig;sGateIP:String):String;
  function GenSpaceString(sStr:String;nSpaceCOunt:Integer):String;
  procedure MainOutMessage(sMsg:String);
  procedure SendGameCenterMsg(wIdent:Word;sSendMsg:String);
var
  g_Config:TConfig =(boRemoteClose   :False;
                     sDBServer       :'127.0.0.1';
                     nDBSPort        :16300;
                     sFeeServer      :'127.0.0.1';
                     nFeePort        :16301;
                     sLogServer      :'127.0.0.1';
                     nLogPort        :16301;
                     sGateAddr       :'0.0.0.0';
                     nGatePort       :5500;
                     sServerAddr     :'0.0.0.0';
                     nServerPort     :5600;
                     sMonAddr        :'0.0.0.0';
                     nMonPort        :3000;
                     sIdDir          :'.\IDDB\';             //0x00470D04
                     sWebLogDir      :'.\Share\';          //0x00470D08
                     sFeedIDList     :'.\FeedIDList.txt';  //0x00470D0C
                     sFeedIPList     :'.\FeedIPList.txt';  //0x00470D10
                     sCountLogDir    :'.\CountLog\';       //0x00470D14
                     sChrLogDir      :'.\ChrLog\';
                     boTestServer    :True;
                     boEnableMakingID:True;
                     boDynamicIPMode :False;
                     nReadyServers   :0;
                     boShowDetailMsg :False
                     );





  //g_sGateAddr     :String = '0.0.0.0';
  //g_nGatePort     :Integer = 5500;
  //g_sServerAddr   :String = '0.0.0.0';
  //g_nServerPort   :Integer = 5600;
  //g_sMonAddr      :String = '0.0.0.0';
  //g_nMonPort      :Integer = 3000;

  //g_boDynamicIPMode :Boolean = False;


  //nReadyServers     :Integer;           //0x00475388
  StringList_0      :TStringList;       //0x0047538C
  nOnlineCountMin   :Integer;           //0x00475390
  nOnlineCountMax   :Integer;           //0x00475394
  nMemoHeigh        :Integer;           //0x00475398
  g_OutMessageCS    :TRTLCriticalSection;
  g_MainMsgList     :TStringList;       //0x0047539C
  CS_DB             :TCriticalSection;  //0x004753A0
  n4753A4           :Integer;           //0x004753A4
  n4753A8           :Integer;           //0x004753A8
  n4753B0           :Integer;           //0x004753B0

  //sIdDir            :String = '.\DB\';             //0x00470D04
  //sWebLogDir        :String = '.\Share\';          //0x00470D08
  //sFeedIDList       :String = '.\FeedIDList.txt';  //0x00470D0C
  //sFeedIPList       :String = '.\FeedIPList.txt';  //0x00470D10
  //sCountLogDir      :String = '.\CountLog\';       //0x00470D14
  //sChrLogDir        :String = '.\ChrLog\';
  //boTestServer      :Boolean = False;              //0x00470D18
  //boEnableMakingID  :Boolean = True;              //0x00470D18

  n47328C           :Integer;

  nSessionIdx       :Integer;          //0x00473294

  g_n472A6C         :Integer;
  g_n472A70         :Integer;
  g_n472A74         :Integer;
  g_boDataDBReady   :Boolean;         //0x00472A78
  bo470D20          :Boolean;




  nVersionDate     :Integer = 20011006;


  ServerAddr       :array[0..99] of String[15];



  g_dwGameCenterHandle:THandle;
  
implementation



function GetCodeMsgSize(X: Double):Integer;
begin
  if INT(X) < X then Result:=TRUNC(X) + 1
  else Result:=TRUNC(X)
end;

function CheckAccountName(sName:String):Boolean; //00454384
var
  i: Integer;
  nLen:Integer;
begin
  Result:=False;
  if sName = '' then exit;
  Result:=True;
  nLen:=length(sName);
  i:=1;
  while (True) do  begin
    if i > nLen then break;
    if (sName[i] < '0') or (sName[i] > 'z') then begin;
      Result:=False;
      if (sName[i] >= #$B0) and (sName[i] <= #$C8) then begin
        Inc(i);
        if i <= nLen then
          if (sName[i] >= #$A1) and (sName[i] <= #$FE) then Result:=True;
      end;
      if not Result then break;
    end;
    Inc(i);
  end;
end;
//00468BDC
function GetSessionID():Integer;
begin
  Inc(nSessionIdx);
  if nSessionIdx >= High(Integer) then begin
    nSessionIdx:=2;
  end;
  Result:=nSessionIdx;
end;
//0046D4F4
procedure SaveGateConfig(Config:pTConfig);
var
  SaveList:TStringList;
  i,n8:Integer;
  s10,sC:String;
begin
  SaveList:=TStringList.Create;
  SaveList.Add(';No space allowed');
  SaveList.Add(GenSpaceString(';Server',15) + GenSpaceString('Title',15) + GenSpaceString('Remote',17) + GenSpaceString('Public',17) + 'Gate...');
  for i:=0 to Config.nRouteCount -1 do begin
    sC:=GenSpaceString(Config.GateRoute[i].sServerName,15) + GenSpaceString(Config.GateRoute[i].sTitle,15) + GenSpaceString(Config.GateRoute[i].sRemoteAddr,17) + GenSpaceString(Config.GateRoute[i].sPublicAddr,17);
    n8:=0;
    while (True) do  begin
      s10:=Config.GateRoute[i].Gate[n8].sIPaddr;
      if s10 = '' then break;
      if not Config.GateRoute[i].Gate[n8].boEnable then
        s10:='*' + s10;
      s10 := s10 + ':' + IntToStr(Config.GateRoute[i].Gate[n8].nPort);
      sC:=sC + GenSpaceString(s10,17);
      Inc(n8);
      if n8 >= 10 then break;
    end;
    SaveList.Add(sC);
  end;
  SaveList.SaveToFile('.\!addrtable.txt');
  SaveList.Free;
end;
//0046D7F8
function GetGatePublicAddr(Config:pTConfig;sGateIP:String):String;
var
  I:Integer;
begin
  Result:=sGateIP;
  for I:=0 to Config.nRouteCount -1 do begin
    if Config.GateRoute[I].sRemoteAddr = sGateIP then begin
      Result:=Config.GateRoute[I].sPublicAddr;
      break;
    end;
  end;
end;
//004541C4
function GenSpaceString(sStr:String;nSpaceCOunt:Integer):String;
var
  I: Integer;
begin
  Result:=sStr + ' ';
  for I := 1 to nSpaceCOunt - length(sStr) do begin
    Result:=Result + ' ';
  end;
end;
//00468F00
procedure MainOutMessage(sMsg:String);
begin
  EnterCriticalSection(g_OutMessageCS);
  try
    g_MainMsgList.Add(sMsg)
  finally
    LeaveCriticalSection(g_OutMessageCS);
  end;
end;

procedure SendGameCenterMsg(wIdent:Word;sSendMsg:String);
var
  SendData:TCopyDataStruct;
  nParam:Integer;
begin
  nParam:=MakeLong(Word(tLoginSrv),wIdent);
  SendData.cbData:=Length (sSendMsg) + 1;
  GetMem(SendData.lpData,SendData.cbData);
  StrCopy (SendData.lpData, PChar(sSendMsg));
  SendMessage(g_dwGameCenterHandle,WM_COPYDATA,nParam,Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;  

initialization
begin
  InitializeCriticalSection(g_OutMessageCS);

  g_MainMsgList:=TStringList.Create;

end;
Finalization
begin
  g_MainMsgList.Free;
  DeleteCriticalSection(g_OutMessageCS);
end;
end.
