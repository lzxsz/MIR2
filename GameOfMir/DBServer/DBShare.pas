unit DBShare;

interface
uses
  Windows,Messages,Classes,SysUtils,JSocket,IniFiles,Grobal2,MudUtil;
type
  TGateInfo = record
    Socket      :TCustomWinSocket;
    sGateaddr   :String;   //0x04
    sText       :String;   //0x08
    UserList    :TList;    //0x0C
    dwTick10    :LongWord; //0x10
    nGateID     :Integer;  //网关ID
  end;
  pTGateInfo = ^TGateInfo;
  TUserInfo = record
    sAccount      :String;     //0x00
    sUserIPaddr   :String;     //0x0B
    sGateIPaddr   :String;
    sConnID       :String;     //0x20
    nSessionID    :Integer;    //0x24
    Socket        :TCustomWinSocket;
    s2C           :String;     //0x2C
    boChrSelected :Boolean;    //0x30
    boChrQueryed  :Boolean;    //0x31
    dwTick34      :LongWord;   //0x34
    dwChrTick     :LongWord;   //0x38
    nSelGateID    :ShortInt;   //角色网关ID
  end;
  pTUserInfo = ^TUserInfo;
  TRouteInfo = record
    nGateCount    :Integer;
    sSelGateIP    :String[15];
    sGameGateIP   :array[0..7] of String[15];
    nGameGatePort :array[0..7] of Integer;
  end;
  pTRouteInfo = ^TRouteInfo;
  procedure LoadConfig();
  procedure LoadIPTable();
  procedure LoadGateID();
  function GetGateID(sIPaddr:String):Integer;
  function GetCodeMsgSize(X: Double):Integer;
  function CheckChrName(sChrName:String):Boolean;
  function InClearMakeIndexList(nIndex:Integer):Boolean;
  procedure OutMainMessage(sMsg:String);
  procedure WriteLogMsg(sMsg:String);
  function  CheckServerIP(sIP:String):Boolean;
  procedure SendGameCenterMsg(wIdent:Word;sSendMsg:String);
var
  PosFile            :String = '.\Dbsrc.Ini';
  sHumDBFilePath     :String = '.\FDB\';
  sDataDBFilePath    :String = '.\FDB\';
  sFeedPath          :String = '.\FDB\';
  sBackupPath        :String = '.\FDB\';
  sConnectPath       :String = '.\Connects\';
  sLogPath           :String = '.\Log\';

  nServerPort        :Integer = 6000;
  sServerAddr        :String  = '0.0.0.0';
  g_nGatePort        :Integer = 5100;
  g_sGateAddr        :String  = '0.0.0.0';
  nIDServerPort      :Integer = 5600;
  sIDServerAddr      :String  ='127.0.0.1';

  g_boEnglishNames   :Boolean = False;   //   语言验证

  boViewHackMsg      :Boolean = False;
//  sDBIdxHeaderDesc   :String = 'legend of mir database index file 2001/7';
//  sDBHeaderDesc      :String = 'legend of mir database file 1999/1';
  HumDB_CS           :TRTLCriticalSection; //0x004ADACC

  n4ADAE4            :Integer;
  n4ADAE8            :Integer;
  n4ADAEC            :Integer;
  n4ADAF0            :Integer;
  boDataDBReady      :Boolean;  //0x004ADAF4
  n4ADAFC            :Integer;
  n4ADB00            :Integer;
  n4ADB04            :Integer;
  boHumDBReady       :Boolean;  //0x4ADB08
  n4ADBF4            :Integer;
  n4ADBF8            :Integer;
  n4ADBFC            :Integer;
  n4ADC00            :Integer;
  n4ADC04            :Integer;
  boAutoClearDB      :Boolean;  //0x004ADC08
  g_nQueryChrCount   :Integer;  //0x004ADC0C
  nHackerNewChrCount :Integer;  //0x004ADC10
  nHackerDelChrCount :Integer;  //0x004ADC14
  nHackerSelChrCount :Integer;  //0x004ADC18
  n4ADC1C            :Integer;
  n4ADC20            :Integer;
  n4ADC24            :Integer;
  n4ADC28            :Integer;
  n4ADC2C            :Integer;
  n4ADB10            :Integer;
  n4ADB14            :Integer;
  n4ADB18            :Integer;
  n4ADBB8            :Integer;
  bo4ADB1C           :Boolean;

  sServerName        :String = 'MIR2';  //'⒌L网络';
  sConfFileName      :String = '.\Dbsrc.ini';
  sGateConfFileName  :String = '.\!ServerInfo.txt';
  sServerIPConfFileNmae:String = '.\!AddrTable.txt';
  sGateIDConfFileName:String = '.\SelectID.txt';

  sMapFile           :String;
  DenyChrNameList    :TStringList;
  ServerIPList       :TStringList;
  GateIDList         :TStringList;
  {
  nClearIndex        :Integer;   //当前清理位置（记录的ID）
  nClearCount        :Integer;   //当前已经清量数量
  nRecordCount       :Integer;   //当前总记录数
  }
  {
  boClearLevel1      :Boolean = True;
  boClearLevel2      :Boolean = True;
  boClearLevel3      :Boolean = True;
  }
  dwInterval         :LongWord = 3000;    //清理时间间隔长度

  nLevel1            :Integer = 1;        //清理等级 1
  nLevel2            :Integer = 7;        //清理等级 2
  nLevel3            :Integer = 14;       //清理等级 3

  nDay1              :Integer = 14;       //清理未登录天数 1
  nDay2              :Integer = 62;       //清理未登录天数 2
  nDay3              :Integer = 124;      //清理未登录天数 3

  nMonth1            :Integer = 0;      //清理未登录月数 1
  nMonth2            :Integer = 0;      //清理未登录月数 2
  nMonth3            :Integer = 0;      //清理未登录月数 3

  g_nClearRecordCount:Integer;
  g_nClearIndex:Integer; //0x324
  g_nClearCount:Integer;//0x328
  g_nClearItemIndexCount:Integer;

  boOpenDBBusy       :Boolean;  //0x350
  g_dwGameCenterHandle :THandle;
  g_boDynamicIPMode    :Boolean = False;
  g_CheckCode          :TCheckCode;
  g_ClearMakeIndex     :TStringList;

  g_RouteInfo         :array [0..19] of TRouteInfo;

   boAttack: Boolean = False;
   boDenyChrName: Boolean = True;
implementation

uses DBSMain, HUtil32;
procedure LoadGateID();
var
  I         :Integer;
  LoadList  :TStringList;
  sLineText :String;
  sID       :String;
  sIPaddr   :String;
  nID       :Integer;
begin
  GateIDList.Clear;
  if FileExists(sGateIDConfFileName) then begin
    LoadList:=TStringList.Create;
    LoadList.LoadFromFile(sGateIDConfFileName);
    for I := 0 to LoadList.Count - 1 do begin
      sLineText:=LoadList.Strings[I];
      if (sLineText = '') or (sLineText[1] = ';') then Continue;
      sLineText:=GetValidStr3(sLineText,sID,[' ',#9]);
      sLineText:=GetValidStr3(sLineText,sIPaddr,[' ',#9]);
      nID:=Str_ToInt(sID,-1);
      if nID < 0 then Continue;        
      GateIDList.AddObject(sIPaddr,TObject(nID))
    end;   
    LoadList.Free;
  end;
end;
function GetGateID(sIPaddr:String):Integer;
var
  I: Integer;
begin
  Result:=0;
  for I := 0 to GateIDList.Count - 1 do begin
    if GateIDList.Strings[I] = sIPaddr then begin
      Result:=Integer(GateIDList.Objects[I]);
      break;
    end;
      
  end;
end;
procedure LoadIPTable();
begin
  ServerIPList.Clear;
  try
     ServerIPList.LoadFromFile(sServerIPConfFileNmae);
  except
    OutMainMessage('加载IP列表文件 ' + sServerIPConfFileNmae +' 出错!');
  end;
end;
procedure LoadConfig();
var
  Conf:TIniFile;
  LoadInteger:Integer;
begin
  Conf:=TIniFile.Create(sConfFileName);
  if Conf <> nil then begin
    sDataDBFilePath:=Conf.ReadString('DB','Dir',sDataDBFilePath);
    sHumDBFilePath:=Conf.ReadString('DB','HumDir',sHumDBFilePath);
    sFeedPath:=Conf.ReadString('DB','FeeDir',sFeedPath);
    sBackupPath:=Conf.ReadString('DB','Backup',sBackupPath);
    sConnectPath:=Conf.ReadString('DB','ConnectDir',sConnectPath);
    sLogPath:=Conf.ReadString('DB','LogDir',sLogPath);
    
    nServerPort:=Conf.ReadInteger('Setup','ServerPort',nServerPort);
    sServerAddr:=Conf.ReadString('Setup','ServerAddr',sServerAddr);

    g_nGatePort:=Conf.ReadInteger('Setup','GatePort',g_nGatePort);
    g_sGateAddr:=Conf.ReadString('Setup','GateAddr',g_sGateAddr);

    sIDServerAddr:=Conf.ReadString('Server','IDSAddr',sIDServerAddr);
    nIDServerPort:=Conf.ReadInteger('Server','IDSPort',nIDServerPort);

    boViewHackMsg:=Conf.ReadBool('Setup','ViewHackMsg',boViewHackMsg);
    sServerName:=Conf.ReadString('Setup','ServerName',sServerName);

    boAttack := Conf.ReadBool('Setup', 'Attack', boAttack);
    boDenyChrName := Conf.ReadBool('Setup', 'DenyChrName', boDenyChrName);
    {
    boClearLevel1:=Conf.ReadBool('DBClear','ClearLevel1',boClearLevel1);
    boClearLevel2:=Conf.ReadBool('DBClear','ClearLevel2',boClearLevel2);
    boClearLevel3:=Conf.ReadBool('DBClear','ClearLevel3',boClearLevel3);
    }
    dwInterval:=Conf.ReadInteger('DBClear','Interval',dwInterval);
    nLevel1:=Conf.ReadInteger('DBClear','Level1',nLevel1);
    nLevel2:=Conf.ReadInteger('DBClear','Level2',nLevel2);
    nLevel3:=Conf.ReadInteger('DBClear','Level3',nLevel3);
    nDay1:=Conf.ReadInteger('DBClear','Day1',nDay1);
    nDay2:=Conf.ReadInteger('DBClear','Day2',nDay2);
    nDay3:=Conf.ReadInteger('DBClear','Day3',nDay3);
    nMonth1:=Conf.ReadInteger('DBClear','Month1',nMonth1);
    nMonth2:=Conf.ReadInteger('DBClear','Month2',nMonth2);
    nMonth3:=Conf.ReadInteger('DBClear','Month3',nMonth3);

    LoadInteger:=Conf.ReadInteger('Setup','DynamicIPMode',-1);
    if LoadInteger < 0 then begin
      Conf.WriteBool('Setup','DynamicIPMode',g_boDynamicIPMode);
    end else g_boDynamicIPMode:=LoadInteger = 1;

     g_boEnglishNames:=Conf.ReadBool('Setup','EnglishNameOnly',g_boEnglishNames); //  语言验证

    PosFile := Conf.ReadString('Setup','Positions','.\Dbsrc.ini');
    
    Conf.Free;
  end;
  LoadIPTable();
  LoadGateID();
end;
function GetCodeMsgSize(X: Double):Integer;
begin
  if INT(X) < X then Result:=TRUNC(X) + 1
  else Result:=TRUNC(X)
end;

function CheckChrName(sChrName:String):Boolean;
//0x0045BE60
var
  I: Integer;
  Chr:Char;
  boIsTwoByte:Boolean;
  FirstChr:Char;
begin
  Result:=True;
  boIsTwoByte:=False;
  FirstChr:=#0;
  for I := 1 to length(sChrName) do begin
    Chr:=(sChrName[i]);
    if boIsTwoByte then begin
      //if Chr < #$A1 then Result:=False; //如果小于就是非法字符
//      if Chr < #$81 then Result:=False; //如果小于就是非法字符

      if not ((FirstChr <= #$F7) and (Chr >= #$40) and (Chr <= #$FE)) then
        if not ((FirstChr > #$F7) and (Chr >= #$40) and (Chr <= #$A0)) then Result:=False;




      boIsTwoByte:=False;
    end else begin //0045BEC0
      //if (Chr >= #$B0) and (Chr <= #$C8) then begin
      if (Chr >= #$81) and (Chr <= #$FE) then begin
        boIsTwoByte:=True;
        FirstChr:=Chr;
      end else begin //0x0045BED2
        if not ((Chr >= '0'{#30}) and (Chr <= '9'{#39})) and
           not ((Chr >= 'a'{#61}) and (Chr <= 'z'){#7A}) and
           not ((Chr >= 'A'{#41}) and (Chr <= 'Z'{#5A})) then
          Result:=False;
      end;
    end;
    if not Result then break;
  end;

end;
function InClearMakeIndexList(nIndex:Integer):Boolean;
var
  I: Integer;
begin
  Result:=False;
  for I := 0 to g_ClearMakeIndex.Count - 1 do begin
    if nIndex = Integer(g_ClearMakeIndex.Objects[I]) then begin
      Result:=True;
      break;
    end;      
  end;
end;

procedure OutMainMessage(sMsg:String);
begin
 sMsg:='[' + DateTimeToStr(Now) + '] ' + sMsg;
 WriteLogMsg(sMsg);
  FrmDBSrv.MemoLog.Lines.Add(sMsg);
end;

procedure WriteLogMsg(sMsg:String);
begin

end;
function CheckServerIP(sIP: String): Boolean;
var
  i:Integer;
begin
  Result:=False;
  for I := 0 to ServerIPList.Count - 1 do begin
    if CompareText(sIP,ServerIPList.Strings[i]) = 0 then begin
      Result:=True;
      break;
    end;
  end;
end;

procedure SendGameCenterMsg(wIdent:Word;sSendMsg:String);
var
  SendData:TCopyDataStruct;
  nParam:Integer;
begin
 { nParam:=MakeLong(Word(tDBServer),wIdent);
  SendData.cbData:=Length (sSendMsg) + 1;
  GetMem(SendData.lpData,SendData.cbData);
  StrCopy (SendData.lpData, PChar(sSendMsg));
  SendMessage(g_dwGameCenterHandle,WM_COPYDATA,nParam,Cardinal(@SendData));
  FreeMem(SendData.lpData);}
end;

initialization
begin
  InitializeCriticalSection(HumDB_CS);
  DenyChrNameList  :=TStringList.Create;
  ServerIPList     :=TStringList.Create;
  GateIDList       :=TStringList.Create;
  g_ClearMakeIndex :=TStringList.Create;
end;
Finalization
begin
  DenyChrNameList.Free;
  ServerIPList.Free;
  GateIDList.Free;
  g_ClearMakeIndex.Free;
end;

end.
