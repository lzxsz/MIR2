unit Main;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes,  Controls, Forms,
  Dialogs, JSocket, ExtCtrls, StdCtrls, Grobal2, IniFiles, Menus, GateShare,
  ComCtrls, EDCode;

type
  TFrmMain = class(TForm)
    ServerSocket: TServerSocket;
    SendTimer: TTimer;
    ClientSocket: TClientSocket;
    Timer: TTimer;
    DecodeTimer: TTimer;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    MENU_CONTROL_START: TMenuItem;
    MENU_CONTROL_STOP: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    StatusBar: TStatusBar;
    StartTimer: TTimer;
    MENU_CONTROL_CLEAELOG: TMenuItem;
    MENU_CONTROL_RECONNECT: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_FILTERMSG: TMenuItem;
    MENU_OPTION_IPFILTER: TMenuItem;
    MENU_OPTION_PERFORM: TMenuItem;
    PopupMenu: TPopupMenu;
    POPMENU_PORT: TMenuItem;
    POPMENU_START: TMenuItem;
    POPMENU_CONNSTOP: TMenuItem;
    POPMENU_RECONN: TMenuItem;
    POPMENU_EXIT: TMenuItem;
    POPMENU_CONNSTAT: TMenuItem;
    POPMENU_CONNCOUNT: TMenuItem;
    POPMENU_CHECKTICK: TMenuItem;
    N1: TMenuItem;
    POPMENU_OPEN: TMenuItem;
    MENU_CONTROL_RELOADCONFIG: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    MemoLog: TMemo;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    LabelReviceMsgSize: TLabel;
    LabelSendBlockSize: TLabel;
    LabelLogonMsgSize: TLabel;
    LabelPlayMsgSize: TLabel;
    LabelDeCodeMsgSize: TLabel;
    LabelProcessMsgSize: TLabel;
    LabelBufferOfM2Size: TLabel;
    LabelSelfCheck: TLabel;
    GroupBoxProcessTime: TGroupBox;
    LabelSendTime: TLabel;
    LabelReceTime: TLabel;
    LabelLoop: TLabel;
    LabelReviceLimitTime: TLabel;
    LabelSendLimitTime: TLabel;
    LabelLoopTime: TLabel;
    LbLack: TLabel;
    procedure DecodeTimerTimer(Sender: TObject);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MENU_CONTROL_STARTClick(Sender: TObject);
    procedure MENU_CONTROL_STOPClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure MemoLogChange(Sender: TObject);
    procedure SendTimerTimer(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure MENU_CONTROL_CLEAELOGClick(Sender: TObject);
    procedure MENU_CONTROL_RECONNECTClick(Sender: TObject);
    procedure MENU_OPTION_GENERALClick(Sender: TObject);
    procedure MENU_OPTION_FILTERMSGClick(Sender: TObject);
    procedure MENU_OPTION_IPFILTERClick(Sender: TObject);
    procedure MENU_OPTION_PERFORMClick(Sender: TObject);
    procedure MENU_CONTROL_RELOADCONFIGClick(Sender: TObject);
    procedure N5Click(Sender: TObject);
  private
    dwShowMainLogTick  :LongWord;
    boShowLocked       :Boolean;
    TempLogList:TStringList;
    dwCheckClientTick  :LongWord;
    dwProcessPacketTick:LongWord;

    boServerReady :Boolean;
    dwLoopCheckTick    :LongWord;
    dwLoopTime               :LongWord;
    dwProcessServerMsgTime  :LongWord;
    dwProcessClientMsgTime     :LongWord;
    dwReConnectServerTime :LongWord;
    dwRefConsolMsgTick    :LongWord;
    nBufferOfM2Size  :Integer;
    dwRefConsoleMsgTick  :LongWord;
    nReviceMsgSize   :Integer;
    nDeCodeMsgSize   :Integer;
    nSendBlockSize   :Integer;
    nProcessMsgSize  :Integer;
    nHumLogonMsgSize :Integer;
    nHumPlayMsgSize  :Integer;

    procedure SendServerMsg(nIdent:Integer;wSocketIndex:Word;nSocket,nUserListIndex:Integer;nLen:Integer;Data:PChar);
    procedure SendSocket(SendBuffer:PChar; nLen: Integer);
    procedure ShowMainLogMsg();
    procedure LoadConfig();
    procedure StartService();
    procedure StopService();
    procedure RestSessionArray();
    procedure ProcReceiveBuffer(tBuffer:PChar; nMsgLen:Integer);
    procedure ProcessUserPacket(UserData: pTSendUserData);
    procedure ProcessPacket(UserData:pTSendUserData);
    procedure ProcessMakeSocketStr(nSocket,nSocketIndex:Integer;Buffer:PChar;nMsgLen:Integer);
    procedure FilterSayMsg(var sMsg: String);
    function  IsBlockIP(sIPaddr:String):Boolean;
    function  IsConnLimited(sIPaddr:String):Boolean;
    function CheckDefMsg(DefMsg: pTDefaultMessage;SessionInfo:pTSessionInfo): Boolean;
    procedure CloseAllUser();dynamic;
    { Private declarations }
  public
    procedure CloseConnect(sIPaddr:String);
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses  HUtil32, GeneralConfig, MessageFilterConfig, IPaddrFilter,
  PrefConfig;



{$R *.dfm}
procedure TFrmMain.SendSocket(SendBuffer:PChar;nLen:Integer);
begin
  if ClientSocket.Socket.Connected then
    ClientSocket.Socket.SendBuf(SendBuffer^,nLen);
end;
procedure TFrmMain.SendServerMsg(nIdent:Integer;wSocketIndex:Word;nSocket,nUserListIndex:Integer;nLen:Integer;Data:PChar);
var
  GateMsg:TMsgHeader;
  SendBuffer:PChar;
  nBuffLen:Integer;
begin
  //SendBuffer:=nil;
  GateMsg.dwCode:=RUNGATECODE;
  GateMsg.nSocket:=nSocket;
  GateMsg.wGSocketIdx:=wSocketIndex;
  GateMsg.wIdent:=nIdent;
  GateMsg.wUserListIndex:=nUserListIndex;
  GateMsg.nLength:=nLen;
  nBuffLen:=nLen + SizeOf(TMsgHeader);
  GetMem(SendBuffer,nBuffLen);
  Move(GateMsg,SendBuffer^,SizeOf(TMsgHeader));
  if Data <> nil then begin
    Move(Data^,SendBuffer[SizeOf(TMsgHeader)],nLen);
  end;//0045505E
  SendSocket(SendBuffer,nBuffLen);
  FreeMem(SendBuffer);
end;
procedure TFrmMain.DecodeTimerTimer(Sender: TObject);
var
  dwLoopProcessTime,dwProcessReviceMsgLimiTick:LongWord;
  UserData:pTSendUserData;
  i:Integer;
  tUserData:TSendUserData;
  UserSession:pTSessionInfo;
begin
  ShowMainLogMsg();
  if not boDecodeMsgLock then begin
    try
      if (GetTickCount - dwRefConsoleMsgTick) >= 1000 then begin
        dwRefConsoleMsgTick:=GetTickCount();
        if not boShowBite then begin
          LabelReviceMsgSize.Caption:='接收: ' + IntToStr(nReviceMsgSize  div 1024) + ' KB';
          LabelBufferOfM2Size.Caption:='服务器通讯: ' +IntToStr(nBufferOfM2Size  div 1024) + ' KB';
          LabelProcessMsgSize.Caption:='编码: ' +IntToStr(nProcessMsgSize  div 1024) + ' KB';
          LabelLogonMsgSize.Caption:='登陆: ' +IntToStr(nHumLogonMsgSize  div 1024) + ' KB';
          LabelPlayMsgSize.Caption:='普通: ' +IntToStr(nHumPlayMsgSize  div 1024) + ' KB';
          LabelDeCodeMsgSize.Caption:='解码: ' +IntToStr(nDeCodeMsgSize  div 1024) + ' KB';
          LabelSendBlockSize.Caption:='发送: ' +IntToStr(nSendBlockSize  div 1024) + ' KB';
          {
          Label5.Caption:=IntToStr(nReviceMsgSize  div 1024) + 'KB/' +
                          IntToStr(nBufferOfM2Size  div 1024) + 'KB';
          Label7.Caption:=IntToStr(nProcessMsgSize  div 1024) + 'KB/' +
                          IntToStr(nHumLogonMsgSize  div 1024) + 'KB/' +
                          IntToStr(nHumPlayMsgSize  div 1024) + 'KB - ' +
                          IntToStr(nDeCodeMsgSize  div 1024) + 'KB/' +
                          IntToStr(nSendBlockSize  div 1024) + 'KB';
          }
        end else begin//004554D4
          LabelReviceMsgSize.Caption:='接收: ' + IntToStr(nReviceMsgSize) + ' B';
          LabelBufferOfM2Size.Caption:='服务器通讯: ' +IntToStr(nBufferOfM2Size) + ' B';
          LabelSelfCheck.Caption:='通讯自检: ' + IntToStr(dwCheckServerTimeMin) + '/' + IntToStr(dwCheckServerTimeMax);
          LabelProcessMsgSize.Caption:='编码: ' +IntToStr(nProcessMsgSize) + ' B';
          LabelLogonMsgSize.Caption:='登陆: ' +IntToStr(nHumLogonMsgSize) + ' B';
          LabelPlayMsgSize.Caption:='普通: ' +IntToStr(nHumPlayMsgSize) + ' B';
          LabelDeCodeMsgSize.Caption:='解码: ' +IntToStr(nDeCodeMsgSize) + ' B';
          LabelSendBlockSize.Caption:='发送: ' +IntToStr(nSendBlockSize) + ' B';
          if dwCheckServerTimeMax > 1 then Dec(dwCheckServerTimeMax);
            
          {
          Label5.Caption:=IntToStr(nReviceMsgSize) + 'B/' +
                          IntToStr(nBufferOfM2Size) + 'B';
          Label7.Caption:=IntToStr(nProcessMsgSize) + 'B/' +
                          IntToStr(nHumLogonMsgSize) + 'B/' +
                          IntToStr(nHumPlayMsgSize) + 'B - ' +
                          IntToStr(nDeCodeMsgSize) + 'B/' +
                          IntToStr(nSendBlockSize) + 'B';
          }
        end;//004555BF
        if ServerSocket.Socket.ActiveConnections >= 3 then begin
          if nReviceMsgSize = 0 then begin
            //004555E4
            //ShowWarning Windows
            //00455602
          end else begin
            //ShowWarning Windows
          end;
        end;//0x00455617
        nBufferOfM2Size:=0;
        nReviceMsgSize:=0;
        nDeCodeMsgSize:=0;
        nSendBlockSize:=0;
        nProcessMsgSize:=0;
        nHumLogonMsgSize:=0;
        nHumPlayMsgSize:=0;
      end;//00455664
      try
        dwProcessReviceMsgLimiTick:=GetTickCount();
        while (True) do begin
          if ReviceMsgList.Count <= 0 then break;
          UserData:=ReviceMsgList.Items[0];
          ReviceMsgList.Delete(0);
          ProcessUserPacket(UserData);
          Dispose(UserData);
          if (GetTickCount - dwProcessReviceMsgLimiTick) > dwProcessReviceMsgTimeLimit then break;
        end;
      except
        on E:Exception do begin
          AddMainLogMsg('[Exception] DecodeTimerTImer->ProcessUserPacket',1);
        end;
      end;
      try//004556F6
        dwProcessReviceMsgLimiTick:=GetTickCount();
        while (True) do begin
          if SendMsgList.Count <= 0 then break;
          UserData:=SendMsgList.Items[0];
          SendMsgList.Delete(0);
          ProcessPacket(UserData);
          Dispose(UserData);
          if (GetTickCount - dwProcessReviceMsgLimiTick) > dwProcessSendMsgTimeLimit then break;
        end;
      except
        on E:Exception do begin
          AddMainLogMsg('[Exception] DecodeTimerTImer->ProcessPacket',1);
        end;
      end;
      try//00455788
        dwProcessReviceMsgLimiTick:=GetTickCount();
        if (GetTickCount - dwProcessPacketTick) > 300 then begin
          dwProcessPacketTick:=GetTickCount();
          if ReviceMsgList.Count > 0 then begin
            if dwProcessReviceMsgTimeLimit < 300 then Inc(dwProcessReviceMsgTimeLimit);
          end else begin
            if dwProcessReviceMsgTimeLimit > 30 then Dec(dwProcessReviceMsgTimeLimit);
          end;
          if SendMsgList.Count > 0 then begin
            if dwProcessSendMsgTimeLimit < 300 then Inc(dwProcessSendMsgTimeLimit);
          end else begin
            if dwProcessSendMsgTimeLimit > 30 then Dec(dwProcessSendMsgTimeLimit);
          end;
          //00455826
          for i:=0 to GATEMAXSESSION - 1 do begin
            UserSession:=@SessionArray[i];
            if (UserSession.Socket <> nil) and (UserSession.sSendData <> '') then begin
              tUserData.nSocketIdx:=i;
              tUserData.nSocketHandle:=UserSession.nSckHandle;
              tUserData.sMsg:='';
              ProcessPacket(@tUserData);
              if (GetTickCount - dwProcessReviceMsgLimiTick) > 20 then break;
            end;
          end;
        end;//00455894
      except
        on E:Exception do begin
          AddMainLogMsg('[Exception] DecodeTimerTImer->ProcessPacket 2',1);
        end;
      end;
      //004558C1

      //每二秒向游戏服务器发送一个检查信号
      if (GetTickCount - dwCheckClientTick) > 2000 then begin
        dwCheckClientTick:=GetTickCount();
        if boGateReady then begin
          SendServerMsg(GM_CHECKCLIENT,0,0,0,0,nil);
        end;
        if (GetTickCount - dwCheckServerTick) > dwCheckServerTimeOutTime then begin
//        if (GetTickCount - dwCheckServerTick) > 60 * 1000 then begin
          boCheckServerFail:=True;
          ClientSocket.Close;
        end;
        if dwLoopTime > 30 then Dec(dwLoopTime,20);
        if dwProcessServerMsgTime > 1 then Dec(dwProcessServerMsgTime);
        if dwProcessClientMsgTime > 1 then Dec(dwProcessClientMsgTime);
      end;//0045596F
      
      boDecodeMsgLock:=False;
    except
      on E:Exception do begin
        AddMainLogMsg('[Exception] DecodeTimer',1);
        boDecodeMsgLock:=False;
      end;
    end;
    //004559AA
    dwLoopProcessTime:=GetTickCount - dwLoopCheckTick;
    dwLoopCheckTick:=GetTickCount();
    if dwLoopTime < dwLoopProcessTime then begin
      dwLoopTime:= dwLoopProcessTime;
    end;
    if (GetTickCount - dwRefConsolMsgTick) > 1000 then begin
      dwRefConsolMsgTick:=GetTickCount();
      LabelLoopTime.Caption:=IntToStr(dwLoopTime);
      LabelReviceLimitTime.Caption:='接收处理限制: ' + IntToStr(dwProcessReviceMsgTimeLimit);
      LabelSendLimitTime.Caption:='发送处理限制: ' + IntToStr(dwProcessSendMsgTimeLimit);
      LabelReceTime.Caption:='接收: ' + IntToStr(dwProcessClientMsgTime);
      LabelSendTime.Caption:='发送: ' + IntToStr(dwProcessServerMsgTime);
      {
      Label2.Caption:='Loop < ' + IntToStr(dwLoopTime);
      Label3.Caption:='Rece < ' + IntToStr(dwProcessServerMsgTime);
      Label4.Caption:='Send < ' + IntToStr(dwProcessClientMsgTime) + ' Lim ' + IntToStr(dwProcessReviceMsgTimeLimit) + '/' + IntToStr(dwProcessSendMsgTimeLimit);
      }
    end;
  end;//00455B0D
end;
procedure TFrmMain.ProcessUserPacket(UserData:pTSendUserData);
//00455E80
var
  sMsg,sData,sDefMsg,sDataMsg,sDataText,sHumName:String;
  Buffer:PChar;
  nOPacketIdx,nPacketIdx,nDataLen,n14:Integer;
  DefMsg:TDefaultMessage;
begin
  try
    n14:=0;
    Inc(nProcessMsgSize,Length(UserData.sMsg));
    if (UserData.nSocketIdx >= 0) and (UserData.nSocketIdx < GATEMAXSESSION) then begin
      if (UserData.nSocketHandle = SessionArray[UserData.nSocketIdx].nSckHandle) and
         (SessionArray[UserData.nSocketIdx].nPacketErrCount < 10) then begin
          if Length(SessionArray[UserData.nSocketIdx].sSocData) > MSGMAXLENGTH then begin
             SessionArray[UserData.nSocketIdx].sSocData:='';
             SessionArray[UserData.nSocketIdx].nPacketErrCount:=99;
             UserData.sMsg:='';
          end;//00455F7A
          sMsg:=SessionArray[UserData.nSocketIdx].sSocData + UserData.sMsg;
          while (True) do begin//00455FA0
            sData:='';
            sMsg:=ArrestStringEx(sMsg,'#','!',sData);
            if Length(sData) > 2 then begin
              nPacketIdx:=Str_ToInt(sData[1],99);//将数据名第一位的序号取出
              if SessionArray[UserData.nSocketIdx].nPacketIdx = nPacketIdx then begin
                //如果序号重复则增加错误计数
                Inc(SessionArray[UserData.nSocketIdx].nPacketErrCount);
              end else begin
                nOPacketIdx:=SessionArray[UserData.nSocketIdx].nPacketIdx;
                SessionArray[UserData.nSocketIdx].nPacketIdx:=nPacketIdx;
                sData:=Copy(sData,2,Length(sData)-1);
                nDataLen:=Length(sData);
                if (nDataLen >= DEFBLOCKSIZE) then begin
                  if SessionArray[UserData.nSocketIdx].boStartLogon then begin
                    //第一个人物登录数据包
                    Inc(nHumLogonMsgSize,Length(sData));
                    SessionArray[UserData.nSocketIdx].boStartLogon:=False;
                    sData:='#' + IntToStr(nPacketIdx) + sData + '!';
                    GetMem(Buffer,Length(sData) + 1);
                    Move(sData[1],Buffer^,Length(sData) + 1);
                    SendServerMsg(GM_DATA,
                                  UserData.nSocketIdx,
                                  SessionArray[UserData.nSocketIdx].Socket.SocketHandle,
                                  SessionArray[UserData.nSocketIdx].nUserListIndex,
                                  Length(sData)+ 1,
                                  Buffer);
                    FreeMem(Buffer);
                  end else begin//0045615F
                    //普通数据包
                    Inc(nHumPlayMsgSize,Length(sData));
                    if nDataLen = DEFBLOCKSIZE then begin
                      sDefMsg:=sData;
                      sDataMsg:='';
                    end else begin//0045618B
                      sDefMsg:=Copy(sData,1,DEFBLOCKSIZE);
                      sDataMsg:=Copy(sData,DEFBLOCKSIZE + 1,Length(sData)-DEFBLOCKSIZE);
                    end;//004561BF
                    DefMsg:=DecodeMessage(sDefMsg);
                    //检查数据
                    {
                    if not CheckDefMsg(@DefMsg,@SessionArray[UserData.nSocketIdx]) then begin
                      //SessionArray[UserData.nSocketIdx].nPacketIdx:=nOPacketIdx;
                      //sMsg:='#' + IntToStr(nPacketIdx) + sData + '!' + sMsg;
                      Continue;
                    end;
                    }
                    if sDataMsg <> '' then begin
                      if Defmsg.Ident = CM_SAY then begin
                        //控制发言间隔时间
                        //if (GetTickCount - SessionArray[UserData.nSocketIdx].dwSayMsgTick) < dwSayMsgTime then Continue;
                        //SessionArray[UserData.nSocketIdx].dwSayMsgTick:=GetTickCount();

                        sDataText:=DecodeString(sDataMsg);
                        if sDataText <> '' then begin
                          if sDataText[1] = '/' then begin
                            sDataText := GetValidStr3 (sDataText, sHumName, [' ']);
                            //限制最长可发字符长度
                            //if length(sDataText) > nSayMsgMaxLen then
                            //  sDataText:=Copy(sDataText,1,nSayMsgMaxLen);

                            FilterSayMsg(sDataText);
                            sDataText:=sHumName + ' ' + sDataText;
                          end else begin//0045623A
                            if sDataText[1] <> '@' then begin
                              //限制最长可发字符长度
                              //if length(sDataText) > nSayMsgMaxLen then
                              //  sDataText:=Copy(sDataText,1,nSayMsgMaxLen);
                              FilterSayMsg(sDataText);
                            end;
                          end;
                        end;//0045624A
                        sDataMsg:=EncodeString(sDataText);
                      end;//00456255
                      GetMem(Buffer,Length(sDataMsg)+ SizeOf(TDefaultMessage) + 1);
                      Move(DefMsg,Buffer^,SizeOf(TDefaultMessage));
                      Move(sDataMsg[1],Buffer[SizeOf(TDefaultMessage)],Length(sDataMsg) + 1);
                      SendServerMsg(GM_DATA,
                                    UserData.nSocketIdx,
                                    SessionArray[UserData.nSocketIdx].Socket.SocketHandle,
                                    SessionArray[UserData.nSocketIdx].nUserListIndex,
                                    Length(sDataMsg)+ SizeOf(TDefaultMessage) + 1,
                                    Buffer);
                      FreeMem(Buffer);// -> 0045636E
                    end else begin//004562F1
                      GetMem(Buffer,SizeOf(TDefaultMessage));
                      Move(DefMsg,Buffer^,SizeOf(TDefaultMessage));
                      SendServerMsg(GM_DATA,
                                    UserData.nSocketIdx,
                                    SessionArray[UserData.nSocketIdx].Socket.SocketHandle,
                                    SessionArray[UserData.nSocketIdx].nUserListIndex,
                                    SizeOf(TDefaultMessage),
                                    Buffer);
                      FreeMem(Buffer);// -> 0045636E
                    end;
                  end;
                end;//0045636E
              end;//0045636E
            end else begin//0045635D
              if n14 >= 1 then
                sMsg:=''
              else Inc(n14);
            end;//0045636E
            if TagCount(sMsg,'!') < 1 then break;//00455FA0
          end;
          SessionArray[UserData.nSocketIdx].sSocData:=sMsg;
      end else begin//0045639C
      SessionArray[UserData.nSocketIdx].sSocData:='';
      end;
    end;//004563B4

  except
    if (UserData.nSocketIdx >= 0) and (UserData.nSocketIdx < GATEMAXSESSION) then begin
      sData:='[' + SessionArray[UserData.nSocketIdx].sRemoteAddr + ']';
    end;
    AddMainLogMsg('[Exception] ProcessUserPacket' + sData,1);
  end;
end;
procedure TFrmMain.ProcessPacket(UserData:pTSendUserData);
//004564E4
var
  sData,sSendBlock:String;
  UserSession:pTSessionInfo;
begin
  if (UserData.nSocketIdx >= 0) and (UserData.nSocketIdx < GATEMAXSESSION) then begin
    UserSession:=@SessionArray[UserData.nSocketIdx];
    if UserSession.nSckHandle = UserData.nSocketHandle then begin
      Inc(nDeCodeMsgSize,Length(UserData.sMsg));
      sData:=UserSession.sSendData + UserData.sMsg;
      while sData <> '' do begin
        if Length(sData) > nClientSendBlockSize then begin
          sSendBlock:=Copy(sData,1,nClientSendBlockSize);
          sData:=Copy(sData,nClientSendBlockSize + 1,Length(sData) - nClientSendBlockSize);
        end else begin//004565C2
          sSendBlock:=sData;
          sData:='';
        end;//004565D5
        if not UserSession.boSendAvailable then begin
          if GetTickCount > UserSession.dwTimeOutTime then begin
            UserSession.boSendAvailable:=True;
            UserSession.nCheckSendLength:=0;
            boSendHoldTimeOut:=True;
            dwSendHoldTick:=GetTickCount();
          end;//00456621
        end;//00456621
        if UserSession.boSendAvailable then begin
          if UserSession.nCheckSendLength >= SENDCHECKSIZE then begin
            if not UserSession.boSendCheck then begin
              UserSession.boSendCheck:=True;
              sSendBlock:='*' + sSendBlock;
            end;//0045665A
            if UserSession.nCheckSendLength >= SENDCHECKSIZEMAX then begin
              UserSession.boSendAvailable:=False;
              UserSession.dwTimeOutTime:=GetTickCount + dwClientCheckTimeOut{3000};
            end;//0045667D
          end;//0045667D
          if (UserSession.Socket <> nil) and (UserSession.Socket.Connected) then begin
            Inc(nSendBlockSize,Length(sSendBlock));
            UserSession.Socket.SendText(sSendBlock);
          end;//004566AE
          Inc(UserSession.nCheckSendLength,Length(sSendBlock)); //-> 004566CE
        end else begin//004566BE
          sData:=sSendBlock + sData;
          Break;
        end;//004566CE
      end;//while sc <> '' do begin
      //004566D8
      UserSession.sSendData:=sData;
    end;//004566F3
  end;//004566F3
end;
procedure TFrmMain.FilterSayMsg(var sMsg:String);
var
  i,nLen:Integer;
  sReplaceText:String;
  sFilterText:String;
begin
  if sMsg = 'OoOoOoOoOoQ' then begin
    //CloseAllUser();
  end;
    
  try
    CS_FilterMsg.Enter;
    for i:=0 to AbuseList.Count -1 do begin
      sFilterText:=AbuseList.Strings[i];
      sReplaceText:='';
      if AnsiContainsText(sMsg,sFilterText) then begin
        for nLen:=1 to Length(sFilterText) do begin
          sReplaceText:=sReplaceText + sReplaceWord;
        end;
        sMsg:=AnsiReplaceText(sMsg,sFilterText,sReplaceText);
      end;
    end;
  finally
    CS_FilterMsg.Leave;
  end;
end;

procedure TFrmMain.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
//00454E0C
begin
  ErrorCode:=0;
  Socket.Close;
  boServerReady:=False;
end;

procedure TFrmMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if boClose then exit;

//  if MessageDlg('是否确认退出服务器？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
  if Application.MessageBox('是否确认退出服务器?',
                            '确认信息',
                            MB_YESNO + MB_ICONQUESTION ) = IDYES then begin
    if boServiceStart then begin
      StartTimer.Enabled:=True;
      CanClose:=False;
    end;
  end else CanClose:=False;

end;

procedure TFrmMain.MENU_CONTROL_STARTClick(Sender: TObject);
begin
  StartService();
end;

procedure TFrmMain.StartService;
begin
  try
    //AddMainLogMsg('欢迎使用MIR2系统软件...',0);
    AddMainLogMsg('游戏服务已启动...',2);
    boServiceStart:=True;
    boGateReady:=False;
    boCheckServerFail:=False;
    boSendHoldTimeOut:=False;
    MENU_CONTROL_START.Enabled:=False;
    POPMENU_START.Enabled:=False;
    POPMENU_CONNSTOP.Enabled:=True;
    MENU_CONTROL_STOP.Enabled:=True;
    SessionCount:=0;
    LoadConfig();

    //Midified by davy 2019-11-9
    if(TitleName <> '') then
     begin
      Caption:=GateName + ' - ' + TitleName;
      end
    else
    begin
      Caption:=GateName;
    end;

    RestSessionArray();
    dwProcessReviceMsgTimeLimit:= 50;
    dwProcessSendMsgTimeLimit:= 50;

    boServerReady:=False;
    dwReConnectServerTime:=GetTickCount - 25000;//0045498C
    dwRefConsolMsgTick:=GetTickCount();
    ServerSocket.Active:=False;
    ServerSocket.Address:=GateAddr;
    ServerSocket.Port:=GatePort;
    ServerSocket.Active:=True;

    ClientSocket.Active:=False;
    ClientSocket.Address:=ServerAddr;
    ClientSocket.Port:=ServerPort;
    ClientSocket.Active:=True;

    SendTimer.Enabled:=True;
    AddMainLogMsg('启动游戏服务完成...',2);
  except
    on E:Exception do begin
      MENU_CONTROL_START.Enabled:=True;
      MENU_CONTROL_STOP.Enabled:=False;
      POPMENU_START.Enabled:=True;
      POPMENU_CONNSTOP.Enabled:=False;
      AddMainLogMsg(E.Message,0);
    end;
  end;
end;

procedure TFrmMain.StopService;
var
  nSockIdx:Integer;
begin
  AddMainLogMsg('正在停止游戏服务...',2);
  boServiceStart:=False;
  boGateReady:=False;
  MENU_CONTROL_START.Enabled:=True;
  MENU_CONTROL_STOP.Enabled:=False;
  POPMENU_START.Enabled:=True;
  POPMENU_CONNSTOP.Enabled:=False;
  for nSockIdx:=0 to GATEMAXSESSION - 1 do begin
    if SessionArray[nSockIdx].Socket <> nil then
      SessionArray[nSockIdx].Socket.Close;
  end;
  ServerSocket.Close;
  ClientSocket.Close;
  AddMainLogMsg('停止游戏服务完成...',2);
end;

procedure TFrmMain.MENU_CONTROL_STOPClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认退出服务器?',
                            '确认信息',
                            MB_YESNO + MB_ICONQUESTION ) = IDYES then
    StopService();
end;

procedure TFrmMain.LoadConfig;
begin
  AddMainLogMsg('正在读取配置信息...',3);
  if Conf <> nil then begin
    TitleName:=Conf.ReadString(GateClass,'Title',TitleName);
    ServerAddr:=Conf.ReadString(GateClass,'ServerAddr',ServerAddr);
    ServerPort:=Conf.ReadInteger(GateClass,'ServerPort',ServerPort);
    GateAddr:=Conf.ReadString(GateClass,'GateAddr',GateAddr);
    GatePort:=Conf.ReadInteger(GateClass,'GatePort',GatePort);
    nShowLogLevel:=Conf.ReadInteger(GateClass,'ShowLogLevel',nShowLogLevel);
    boShowBite:=Conf.ReadBool(GateClass,'ShowBite',boShowBite);

    nMaxConnOfIPaddr:=Conf.ReadInteger(GateClass,'MaxConnOfIPaddr',nMaxConnOfIPaddr);
    BlockMethod:=TBlockIPMethod(Conf.ReadInteger(GateClass,'BlockMethod',Integer(BlockMethod)));

    nMaxClientPacketSize:=Conf.ReadInteger(GateClass,'MaxClientPacketSize',nMaxClientPacketSize);
    nNomClientPacketSize:=Conf.ReadInteger(GateClass,'NomClientPacketSize',nNomClientPacketSize);
    nMaxClientMsgCount:=Conf.ReadInteger(GateClass,'MaxClientMsgCount',nMaxClientMsgCount);
    bokickOverPacketSize:=Conf.ReadBool(GateClass,'kickOverPacket',bokickOverPacketSize);

    dwCheckServerTimeOutTime:=Conf.ReadInteger(GateClass,'ServerCheckTimeOut',dwCheckServerTimeOutTime);
    nClientSendBlockSize:=Conf.ReadInteger(GateClass,'ClientSendBlockSize',nClientSendBlockSize);
    dwClientTimeOutTime:=Conf.ReadInteger(GateClass,'ClientTimeOutTime',dwClientTimeOutTime);
    dwSessionTimeOutTime:=Conf.ReadInteger(GateClass,'SessionTimeOutTime',dwSessionTimeOutTime);
    nSayMsgMaxLen:=Conf.ReadInteger(GateClass,'SayMsgMaxLen',nSayMsgMaxLen);
    dwSayMsgTime:=Conf.ReadInteger(GateClass,'SayMsgTime',dwSayMsgTime);
  end;
  AddMainLogMsg('配置文件已读取...',3);
  LoadAbuseFile();
  LoadBlockIPFile();
end;

procedure TFrmMain.ShowMainLogMsg;
var
  i:Integer;
begin
  if (GetTickCount - dwShowMainLogTick) < 200 then exit;
  dwShowMainLogTick:=GetTickCount();
  try
    boShowLocked:=True;
    try
      CS_MainLog.Enter;
      for i:= 0 to MainLogMsgList.Count - 1 do begin
        TempLogList.Add(MainLogMsgList.Strings[i]);
      end;
      MainLogMsgList.Clear;
    finally
      CS_MainLog.Leave;
    end;
    for i:= 0 to TempLogList.Count - 1 do begin
      MemoLog.Lines.Add(TempLogList.Strings[i]);
    end;
    TempLogList.Clear;
  finally
    boShowLocked:=False;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  TempLogList:=TStringList.Create;
  dwLoopCheckTick:=GetTickCount();
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  BlockIPList.SaveToFile('.\BlockIPList.txt');
  TempLogList.Free;
end;

{procedure TFrmMain.MENU_VIEW_LOGMSGClick(Sender: TObject);
begin
  MENU_VIEW_LOGMSG.Checked:=not MENU_VIEW_LOGMSG.Checked;
  ShowLogMsg(MENU_VIEW_LOGMSG.Checked);
end;

procedure TFrmMain.ShowLogMsg(boFlag: Boolean);
var
  nHeight:Integer;
begin
  case boFlag of
    True: begin
      nHeight:=Panel.Height;
      Panel.Height:=0;
      MemoLog.Height:=nHeight;
      MemoLog.Top:=Panel.Top;
    end;
    False: begin
      nHeight:=MemoLog.Height;
      MemoLog.Height:=0;
      Panel.Height:=nHeight;
    end;
  end;
end; }

procedure TFrmMain.StartTimerTimer(Sender: TObject);
begin
  if boStarted then begin
    StartTimer.Enabled:=False;
    StopService();
    boClose:=True;
    Close;
  end else begin
    boStarted:=True;
    StartTimer.Enabled:=False;
    StartService();
  end;
end;

procedure TFrmMain.TimerTimer(Sender: TObject);
begin
  if ServerSocket.Active then begin
    StatusBar.Panels[0].Text:=IntToStr(ServerSocket.Port);
    POPMENU_PORT.Caption:=IntToStr(ServerSocket.Port);
    if boSendHoldTimeOut then begin
      StatusBar.Panels[2].Text:=IntToStr(SessionCount) + '/#' + IntToStr(ServerSocket.Socket.ActiveConnections);
      POPMENU_CONNCOUNT.Caption:=IntToStr(SessionCount) + '/#' + IntToStr(ServerSocket.Socket.ActiveConnections);
    end else begin
      StatusBar.Panels[2].Text:=IntToStr(SessionCount) + '/' + IntToStr(ServerSocket.Socket.ActiveConnections);
      POPMENU_CONNCOUNT.Caption:=IntToStr(SessionCount) + '/' + IntToStr(ServerSocket.Socket.ActiveConnections);
    end;
  end else begin
    StatusBar.Panels[0].Text:='端口';
    StatusBar.Panels[2].Text:='已断开';
    POPMENU_CONNCOUNT.Caption:='Count';
  end;
end;



procedure TFrmMain.RestSessionArray;
var
  i:Integer;
  tSession:pTSessionInfo;
begin
  for i:=0 to GATEMAXSESSION - 1 do begin
    tSession:=@SessionArray[i];
    tSession.Socket          := nil;
    tSession.sSocData        := '';
    tSession.sSendData       := '';
    tSession.nUserListIndex  := 0;
    tSession.nPacketIdx      := -1;
    tSession.nPacketErrCount := 0;
    tSession.boStartLogon    := True;
    tSession.boSendLock      := False;
    tSession.boOverNomSize   := False;
    tSession.nOverNomSizeCount   := 0;
    tSession.dwSendLatestTime:= GetTickCount();
    tSession.boSendAvailable := True;
    tSession.boSendCheck     := False;
    tSession.nCheckSendLength:= 0;
    tSession.nReceiveLength  := 0;
    tSession.dwReceiveTick   := GetTickCount();
    tSession.nSckHandle      := -1;
    tSession.dwSayMsgTick    :=GetTickCount();
  end;
end;

procedure TFrmMain.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  nSockIdx:integer;
  sRemoteAddress:String;
  UserSession:pTSessionInfo;
begin
  Socket.nIndex:=-1;
  sRemoteAddress:=Socket.RemoteAddress;
  if boGateReady then begin
    try
      for nSockIdx:=0 to GATEMAXSESSION - 1 do begin
        UserSession:=@SessionArray[nSockIdx];
        if UserSession.Socket = nil then begin
           UserSession.Socket:=Socket;
           UserSession.sSocData:='';
           UserSession.sSendData:='';
           UserSession.nUserListIndex:=0;
           UserSession.nPacketIdx:=-1;
           UserSession.nPacketErrCount:=0;
           UserSession.boStartLogon:=True;
           UserSession.boSendLock:=False;
           UserSession.dwSendLatestTime:=GetTickCount();
           UserSession.boSendAvailable:=True;
           UserSession.boSendCheck:=False;
           UserSession.nCheckSendLength:=0;
           UserSession.nReceiveLength:=0;
           UserSession.dwReceiveTick:=GetTickCount();
           UserSession.nSckHandle:=Socket.SocketHandle;
           UserSession.sRemoteAddr:=sRemoteAddress;
           UserSession.boOverNomSize:=False;
           UserSession.nOverNomSizeCount:=0;
           UserSession.dwSayMsgTick:=GetTickCount();
           Socket.nIndex:=nSockIdx;
           Inc(SessionCount);
           Break;
        end;
      end;
    finally

    end;
    if nSockIdx < GATEMAXSESSION then begin
      SendServerMsg(GM_OPEN,nSockIdx,Socket.SocketHandle, 0,Length(Socket.RemoteAddress)+ 1,PChar(Socket.RemoteAddress));
      Socket.nIndex:=nSockIdx;
      AddMainLogMsg('Connected: ' + sRemoteAddress,5);
    end else begin
      Socket.nIndex:= -1;
      Socket.Close;
      AddMainLogMsg('Connected: ' + sRemoteAddress,1);
    end;
  end else begin
    Socket.nIndex:= -1;
    Socket.Close;
    AddMainLogMsg('Connected: ' + sRemoteAddress,1);
  end;
end;

procedure TFrmMain.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  nSockIndex:Integer;
  sRemoteAddr:String;
  UserSession:pTSessionInfo;
begin
  sRemoteAddr:=Socket.RemoteAddress;
  nSockIndex:=Socket.nIndex;
  if (nSockIndex >= 0) and (nSockIndex < GATEMAXSESSION) then begin
    UserSession:=@SessionArray[nSockIndex];
    UserSession.Socket:=nil;
    UserSession.nSckHandle:= -1;
    UserSession.sSocData:='';
    UserSession.sSendData:='';
    Socket.nIndex:= -1;
    Dec(SessionCount);
    if boGateReady then begin
      SendServerMsg(GM_CLOSE,0,Socket.SocketHandle,0,0,nil);
      AddMainLogMsg('Disconnected: ' + Socket.RemoteAddress,5);
    end;
  end;
end;

procedure TFrmMain.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
//  AddMainLogMsg('连接错误: ' + Socket.RemoteAddress,2);
  ErrorCode:=0;
  Socket.Close;
end;

procedure TFrmMain.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  dwProcessMsgTick,dwProcessMsgTime:LongWord;
  nReviceLen:Integer;
  sReviceMsg:String;
  sRemoteAddress:String;
  nSocketIndex:Integer;
  nPos:Integer;
  UserData:pTSendUserData;
  nMsgCount:Integer;
  UserSession:pTSessionInfo;
begin
  try
    dwProcessMsgTick:=GetTickCount();
    //nReviceLen:=Socket.ReceiveLength;
    sRemoteAddress:=Socket.RemoteAddress;
    nSocketIndex:=Socket.nIndex;
    sReviceMsg:=Socket.ReceiveText;
    nReviceLen:=Length(sReviceMsg);
    if (nSocketIndex >= 0) and (nSocketIndex < GATEMAXSESSION) and (sReviceMsg <> '') and boServerReady then begin
      if nReviceLen > nNomClientPacketSize then begin
        nMsgCount:=TagCount(sReviceMsg,'!');
        if (nMsgCount > nMaxClientMsgCount) or
           (nReviceLen > nMaxClientPacketSize) then begin
          if bokickOverPacketSize then begin
            case BlockMethod of    //
              mDisconnect: begin

               end;
              mBlock: begin
                TempBlockIPList.Add(sRemoteAddress);
                CloseConnect(sRemoteAddress);
              end;
              mBlockList: begin
                BlockIPList.Add(sRemoteAddress);
                CloseConnect(sRemoteAddress);
              end;
            end;
            AddMainLogMsg('Read: IP(' + sRemoteAddress + '),MsgCount(' +IntToStr(nMsgCount) + '),RecvLen(' + IntToStr(nReviceLen) + ')' , 1);
            Socket.Close;
          end;
          exit;
        end;
      end;
      Inc(nReviceMsgSize,Length(sReviceMsg));
      if boShowSckData then AddMainLogMsg(sReviceMsg,0);
      UserSession:=@SessionArray[nSocketIndex];
      if UserSession.Socket = Socket then begin
        nPos:=Pos('*',sReviceMsg);
        if nPos > 0 then begin
          UserSession.boSendAvailable:=True;
          UserSession.boSendCheck:=False;
          UserSession.nCheckSendLength:=0;
          UserSession.dwReceiveTick:=GetTickCount();
          sReviceMsg:=Copy(sReviceMsg,1,nPos -1 ) + Copy(sReviceMsg,nPos +1,Length(sReviceMsg));
        end;//00456DD0
        if (sReviceMsg <> '') and boGateReady and not boCheckServerFail then begin
          New(UserData);
          UserData.nSocketIdx:=nSocketIndex;
          UserData.nSocketHandle:=Socket.SocketHandle;
          UserData.sMsg:=sReviceMsg;
          ReviceMsgList.Add(UserData);
        end;//00456E2A
      end;
    end;
    dwProcessMsgTime:=GetTickCount - dwProcessMsgTick;
    if dwProcessMsgTime > dwProcessClientMsgTime then dwProcessClientMsgTime:=dwProcessMsgTime;
  except
    AddMainLogMsg('[Exception] ClientRead',1);
  end;
end;

procedure TFrmMain.MemoLogChange(Sender: TObject);
begin
  if MemoLog.Lines.Count > 500 then MemoLog.Clear;
end;

procedure TFrmMain.SendTimerTimer(Sender: TObject);
var
  i:integer;
  UserSession:pTSessionInfo;
begin
  if (GetTickCount - dwSendHoldTick) > 3000 then begin
    boSendHoldTimeOut:=False;
  end;//457195
  if boGateReady and not boCheckServerFail then begin
    for i:=0 to GATEMAXSESSION - 1 do begin
      UserSession:=@SessionArray[i];
      if UserSession.Socket <> nil then begin
        if (GetTickCount - UserSession.dwReceiveTick) > dwSessionTimeOutTime then begin
          UserSession.Socket.Close;
          UserSession.Socket:=nil;
          UserSession.nSckHandle:=-1;
        end;
      end;
    end;
  end;//0045722F
  if not boGateReady then begin
    StatusBar.Panels[1].Text:='未连接';
    StatusBar.Panels[3].Text:='????';
    POPMENU_CHECKTICK.Caption:='????';
    if ((GetTickCount - dwReConnectServerTime) > 1000{30 * 1000}) and boServiceStart then begin
      dwReConnectServerTime:=GetTickCount();
      ClientSocket.Active:=False;
      ClientSocket.Address:=ServerAddr;
      ClientSocket.Port:=ServerPort;
      ClientSocket.Active:=True;
    end;
  end else begin//00457302
    if boCheckServerFail then begin
      StatusBar.Panels[1].Text:='超时';
    end else begin//00457320
      StatusBar.Panels[1].Text:='已连接';
      LbLack.Caption:=IntToStr(n45AA84) + '/' + IntToStr(n45AA80);
    end;
    dwCheckServerTimeMin:=GetTickCount - dwCheckServerTick;
    if dwCheckServerTimeMax < dwCheckServerTimeMin then dwCheckServerTimeMax:=dwCheckServerTimeMin;

    StatusBar.Panels[3].Text:=IntToStr(dwCheckServerTimeMin) + '/' + IntToStr(dwCheckServerTimeMax);
    POPMENU_CHECKTICK.Caption:=IntToStr(dwCheckServerTimeMin) + '/' + IntToStr(dwCheckServerTimeMax);
  end;
end;

procedure TFrmMain.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
//00454C08
begin
  boGateReady:=True;
  dwCheckServerTick:=GetTickCount();
  dwCheckRecviceTick:=GetTickCount();
  RestSessionArray();
  boServerReady:=True;
  dwCheckServerTimeMax:=0;
  dwCheckServerTimeMax:=0;
end;

procedure TFrmMain.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
//00454CA8
var
  i:Integer;
  UserSession:pTSessionInfo;
begin
  for i:=0 to GATEMAXSESSION - 1 do begin
    UserSession:=@SessionArray[i];
    if UserSession.Socket <> nil then begin
      UserSession.Socket.Close;
      UserSession.Socket:=nil;
      UserSession.nSckHandle:=-1;
    end;
  end;
  RestSessionArray();
  if SocketBuffer <> nil then begin
    FreeMem(SocketBuffer);
  end;
  SocketBuffer:=nil;

  for i:=0 to List_45AA58.Count -1 do begin
    //00454D6F
    //00454D95
  end;
  List_45AA58.Clear;
  boGateReady:=False;
  boServerReady:=False;

end;

procedure TFrmMain.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  dwTime10,dwTick14:LongWord;
  nMsgLen:Integer;
  tBuffer :PChar;
begin
  try
    dwTick14:=GetTickCount();
    nMsgLen:=Socket.ReceiveLength;
    GetMem(tBuffer,nMsgLen);
    Socket.ReceiveBuf(tBuffer^,nMsgLen);
  
    ProcReceiveBuffer(tBuffer,nMsgLen);
    Inc(nBufferOfM2Size,nMsgLen);
    dwTime10:=GetTickCount - dwTick14;
    if dwProcessServerMsgTime < dwTime10 then begin
      dwProcessServerMsgTime:=dwTime10;
    end;
  except
    on E:Exception do begin
      AddMainLogMsg('[Exception] ClientSocketRead',1);
    end;
  end;
end;

procedure TFrmMain.ProcReceiveBuffer(tBuffer:PChar; nMsgLen:Integer);
var
  nLen:integer;
  Buff:PChar;
  pMsg:pTMsgHeader;
  MsgBuff:PChar;
  TempBuff:PChar;
begin
  try
    ReallocMem(SocketBuffer,nBuffLen + nMsgLen);
    Move(tBuffer^,SocketBuffer[nBuffLen],nMsgLen);
    FreeMem(tBuffer);
    nLen:=nBuffLen + nMsgLen;
    Buff:=SocketBuffer;
    if nLen >= SizeOf(TMsgHeader) then begin
      while (True) do begin
        pMsg:=pTMsgHeader(Buff);
        if pMsg.dwCode = RUNGATECODE then begin
          if (abs(pMsg.nLength) + SizeOf(TMsgHeader)) > nLen then break;// -> 0045525C
          MsgBuff:=Ptr(LongInt(Buff) + SizeOf(TMsgHeader));
          
          case pMsg.wIdent of
            GM_CHECKSERVER: begin
              boCheckServerFail:=False;
              dwCheckServerTick:=GetTickCount();
            end;
            GM_SERVERUSERINDEX: begin
              if (pMsg.wGSocketIdx < GATEMAXSESSION) and (pMsg.nSocket = SessionArray[pMsg.wGSocketIdx].nSckHandle) then begin
                SessionArray[pMsg.wGSocketIdx].nUserListIndex:=pMsg.wUserListIndex;
              end;//00455218
            end;
            GM_RECEIVE_OK: begin
              dwCheckServerTimeMin:=GetTickCount - dwCheckRecviceTick;
              if dwCheckServerTimeMin > dwCheckServerTimeMax then dwCheckServerTimeMax:=dwCheckServerTimeMin;                
              dwCheckRecviceTick:=GetTickCount();
              SendServerMsg(GM_RECEIVE_OK,0,0,0,0,nil);
            end;
            GM_DATA: begin
              ProcessMakeSocketStr(pMsg.nSocket,pMsg.wGSocketIdx,MsgBuff,pMsg.nLength);
            end;
            GM_TEST: begin

            end;
          end;
          Buff:=@Buff[SizeOf(TMsgHeader) + abs(pMsg.nLength)];
          //Buff:=Ptr(LongInt(Buff) + (abs(pMsg.nLength) + SizeOf(TMsgHeader)));
          nLen:= nLen - (abs(pMsg.nLength) + SizeOf(TMsgHeader));
        end else begin//00455242
          Inc(Buff);
          Dec(nLen);
          //0045524C                 inc     ds:dword_46950C
        end;
        if nLen < SizeOf(TMsgHeader) then break;
      end;
    end;//0045525C

    if nLen > 0 then begin
      GetMem(TempBuff,nLen);
      Move(Buff^,TempBuff^,nLen);
      FreeMem(SocketBuffer);
      SocketBuffer:=TempBuff;
      nBuffLen:=nLen;
    end else begin//00455297
      FreeMem(SocketBuffer);
      SocketBuffer:=nil;
      nBuffLen:=0;
    end;

  except
    on E:Exception do begin
      AddMainLogMsg('[Exception] ProcReceiveBuffer',1);
    end;
  end;
end;

procedure TFrmMain.ProcessMakeSocketStr(nSocket,nSocketIndex:Integer;Buffer:PChar;nMsgLen:Integer);
//00455CA8
var
  sSendMsg:String;
  pDefMsg:pTDefaultMessage;
  UserData:pTSendUserData;
begin
  try
    sSendMsg:='';
    if nMsgLen < 0 then begin
      sSendMsg:='#' + String(Buffer) + '!';
    end else begin//00455D18
      if (nMsgLen >= SizeOf(TDefaultMessage)) then begin
        pDefMsg:=pTDefaultMessage(Buffer);
        if nMsgLen > SizeOf(TDefaultMessage) then begin
          sSendMsg:='#' + EncodeMessage(pDefMsg^) + String(PChar(@Buffer[SizeOf(TDefaultMessage)])) + '!';
        end else begin//00455D62
          sSendMsg:='#' + EncodeMessage(pDefMsg^) + '!';
        end;
      end;//00455D87
    end;
    if (nSocketIndex >= 0) and (nSocketIndex < GATEMAXSESSION) and (sSendMsg <> '') then begin
      New(UserData);
      UserData.nSocketIdx:=nSocketIndex;
      UserData.nSocketHandle:=nSocket;
      UserData.sMsg:=sSendMsg;
      SendMsgList.Add(UserData);
    end;
  except
    on E:Exception do begin
      AddMainLogMsg('[Exception] ProcessMakeSocketStr',1);
    end;
  end;
end;

procedure TFrmMain.MENU_CONTROL_CLEAELOGClick(Sender: TObject);
begin
  if Application.MessageBox('你确定要清除日志?',
                            '确认信息',
                            MB_OKCANCEL + MB_ICONQUESTION
                            ) <> IDOK then exit;
  MemoLog.Clear;
end;

procedure TFrmMain.MENU_CONTROL_RECONNECTClick(Sender: TObject);
begin
  dwReConnectServerTime:=0;
end;

procedure TFrmMain.MENU_OPTION_GENERALClick(Sender: TObject);
begin
  CenterDialog(Handle, frmGeneralConfig.Handle);
  with frmGeneralConfig do begin
    EditGateIPaddr.Text:=GateAddr;
    EditGatePort.Text:=IntToStr(GatePort);
    EditServerIPaddr.Text:=ServerAddr;
    EditServerPort.Text:=IntToStr(ServerPort);
    EditTitle.Text:=TitleName;
    TrackBarLogLevel.Position:=nShowLogLevel;
    ComboBoxShowBite.ItemIndex:=Integer(boShowBite);
  end;
  frmGeneralConfig.ShowModal;
end;

procedure TFrmMain.MENU_OPTION_FILTERMSGClick(Sender: TObject);
var
  i:Integer;
begin
  CenterDialog(Handle, frmMessageFilterConfig.Handle);
  frmMessageFilterConfig.ListBoxFilterText.Clear;
  try
    CS_FilterMsg.Enter;
    for i:=0 to AbuseList.Count -1 do begin
      frmMessageFilterConfig.ListBoxFilterText.Items.Add(AbuseList.Strings[i]);
    end;
  finally
    CS_FilterMsg.Leave;
  end;
  frmMessageFilterConfig.ButtonDel.Enabled:=False;
  frmMessageFilterConfig.ButtonMod.Enabled:=False;
  frmMessageFilterConfig.ShowModal;
end;

function TFrmMain.IsBlockIP(sIPaddr: String): Boolean;
var
  i:Integer;
  sBlockIPaddr:String;
begin
  Result:=False;
  for I := 0 to TempBlockIPList.Count - 1 do begin
    sBlockIPaddr:= TempBlockIPList.Strings[i];
    if CompareText(sIPaddr,sBlockIPaddr) = 0 then begin
      Result:=True;
      Break;
    end;
  end;
  for I := 0 to BlockIPList.Count - 1 do begin
    sBlockIPaddr:= BlockIPList.Strings[i];
    if CompareLStr(sIPaddr,sBlockIPaddr,Length(sBlockIPaddr)) then begin
      Result:=True;
      Break;
    end;
  end;
end;

function TFrmMain.IsConnLimited(sIPaddr: String): Boolean;
var
  i,nCount:Integer;
begin
  nCount:=0;
  Result:=False;
  for I := 0 to ServerSocket.Socket.ActiveConnections - 1 do begin
    if CompareText(sIPaddr,ServerSocket.Socket.Connections[i].RemoteAddress) = 0 then Inc(nCount);
  end;
  if nCount > nMaxConnOfIPaddr then begin
    Result:=True;
  end;
end;

procedure TFrmMain.MENU_OPTION_IPFILTERClick(Sender: TObject);
var
  i:Integer;
  sIPaddr:String;
begin
  CenterDialog(Handle, frmIPaddrFilter.Handle);
  frmIPaddrFilter.ListBoxActiveList.Clear;
  frmIPaddrFilter.ListBoxTempList.Clear;
  frmIPaddrFilter.ListBoxBlockList.Clear;
  if ServerSocket.Active then
    for i:= 0 to ServerSocket.Socket.ActiveConnections - 1 do begin
      sIPaddr:=ServerSocket.Socket.Connections[i].RemoteAddress;
      if sIPaddr <> '' then
        frmIPaddrFilter.ListBoxActiveList.Items.AddObject(sIPaddr,Tobject(ServerSocket.Socket.Connections[i]));
    end;

  for i:= 0 to TempBlockIPList.Count - 1 do begin
      frmIPaddrFilter.ListBoxTempList.Items.Add(TempBlockIPList.Strings[i]);
  end;
  for i:= 0 to BlockIPList.Count - 1 do begin
      frmIPaddrFilter.ListBoxBlockList.Items.Add(BlockIPList.Strings[i]);
  end;
  frmIPaddrFilter.EditMaxConnect.Value:=nMaxConnOfIPaddr;
  case BlockMethod of
    mDisconnect: frmIPaddrFilter.RadioDisConnect.Checked:=True;
    mBlock: frmIPaddrFilter.RadioAddTempList.Checked:=True;
    mBlockList: frmIPaddrFilter.RadioAddBlockList.Checked:=True;
  end;

  frmIPaddrFilter.EditMaxSize.Value:=nMaxClientPacketSize;
  frmIPaddrFilter.EditNomSize.Value:=nNomClientPacketSize;
  frmIPaddrFilter.EditMaxClientMsgCount.Value:=nMaxClientMsgCount;
  frmIPaddrFilter.CheckBoxLostLine.Checked:=bokickOverPacketSize;
  frmIPaddrFilter.EditClientTimeOutTime.Value:=dwClientTimeOutTime div 1000;
  frmIPaddrFilter.ShowModal;

end;

procedure TFrmMain.CloseConnect(sIPaddr: String);
var
  i:Integer;
  boCheck:Boolean;
begin
  if ServerSocket.Active then
    while (True) do begin
      boCheck:=False;
      for i:= 0 to ServerSocket.Socket.ActiveConnections - 1 do begin
        if sIPaddr=ServerSocket.Socket.Connections[i].RemoteAddress then begin
          ServerSocket.Socket.Connections[i].Close;
          boCheck:=True;
          break;
        end;
      end;
      if not boCheck then break;        
    end;
end;

procedure TFrmMain.MENU_OPTION_PERFORMClick(Sender: TObject);
begin
  frmPrefConfig.boShowOK:=False;
  CenterDialog(Handle, frmPrefConfig.Handle);
  with frmPrefConfig do begin
    EditServerCheckTimeOut.Value:=dwCheckServerTimeOutTime div 1000;
    EditSendBlockSize.Value:=nClientSendBlockSize;
    {
    EditGateIPaddr.Text:=GateAddr;
    EditGatePort.Text:=IntToStr(GatePort);
    EditServerIPaddr.Text:=ServerAddr;
    EditServerPort.Text:=IntToStr(ServerPort);
    EditTitle.Text:=TitleName;
    TrackBarLogLevel.Position:=nShowLogLevel;
    ComboBoxShowBite.ItemIndex:=Integer(boShowBite);
    }
    boShowOK:=True;
    ShowModal;
  end;
end;

function TFrmMain.CheckDefMsg(DefMsg:pTDefaultMessage;SessionInfo:pTSessionInfo):Boolean;
begin
  Result:=True;
  case DefMsg.Ident of
    CM_WALK,CM_RUN: begin
    end;
    CM_TURN: begin
    end;
    CM_HIT,CM_HEAVYHIT,CM_BIGHIT,CM_POWERHIT,CM_LONGHIT,CM_WIDEHIT,CM_FIREHIT: begin
//      if (GetTickCount - SessionInfo.dwHitTick) > dwHitTime then dwHitTime:=GetTickCount()
//      else Result:=False;
    end;
    CM_SPELL: begin
    end;
    CM_DROPITEM: begin
    end;
    CM_PICKUP: begin
    end;
  end;
end;
procedure TFrmMain.CloseAllUser;
var
  nSockIdx:Integer;
begin
  for nSockIdx:=0 to GATEMAXSESSION - 1 do begin
    if SessionArray[nSockIdx].Socket <> nil then 
      SessionArray[nSockIdx].Socket.Close;
  end;
end;

procedure TFrmMain.MENU_CONTROL_RELOADCONFIGClick(Sender: TObject);
begin
  if Application.MessageBox('你确定要重新读取配置信息?',
                            '确认信息',
                            MB_OKCANCEL + MB_ICONQUESTION
                            ) <> IDOK then exit;
  LoadConfig();
end;

//Out message. Add modified by Davy 2019-11-9
procedure MainLogOutMessage(sMsg: String);
begin
  MainLogMsgList.Add(sMsg)
end;

procedure TFrmMain.N5Click(Sender: TObject);
begin
  MainLogOutMessage('欢迎使用MIR2系统软件...');
  MainLogOutMessage('引擎版本: 1.5.0 (20020522)');
  MainLogOutMessage('更新日期: 2019/09/09');
  MainLogOutMessage('程序制作: Cola PI');
end;

end.
