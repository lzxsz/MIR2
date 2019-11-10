unit DXPlay;

interface

{$INCLUDE DelphiXcfg.inc}

uses
  Windows, SysUtils, Classes, Forms, DXClass, ActiveX, DXETable,  
{$IfDef StandardDX}
  DirectDraw,
  {$IfDef DX9}
  DirectPlay8, DX7toDX8;
  {$Else}
  {$IfDef DX81}
  DirectPlay8, DX7toDX8;
  {$Else}
  DirectPlay;
  {$EndIf}
  {$EndIf}
{$Else}
  DirectX;
{$EndIf}

type
  {$IfDef DX9}
  TDPID = DWORD;
  {$EndIf}

  {  TDXPlayPlayer  }

  TDXPlayPlayer = class(TCollectionItem)
  private
    FData: Pointer;
    FID: TDPID;
    FName: string;
    FRemotePlayer: Boolean;
  public
    property Data: Pointer read FData write FData;
    property ID: TDPID read FID;
    property Name: string read FName;
    property RemotePlayer: Boolean read FRemotePlayer;
  end;

  {  TDXPlayPlayers  }

  TDXPlayPlayers = class(TCollection)
  private
    function GetPlayer(Index: Integer): TDXPlayPlayer;
  public
    constructor Create;
    function Find(ID: TDPID): TDXPlayPlayer;
    function IndexOf(ID: TDPID): Integer;
    property Players[Index: Integer]: TDXPlayPlayer read GetPlayer; default;
  end;

  {  TDXPlayModemSetting  }

  TDXPlayModemSetting = class(TPersistent)
  private
    FEnabled: Boolean;
    FPhoneNumber: string;
    FModemName: string;
    FModemNames: TStrings;
    function GetModemNames: TStrings;
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property ModemName: string read FModemName write FModemName;
    property ModemNames: TStrings read GetModemNames;
  published
    property Enabled: Boolean read FEnabled write FEnabled;
    property PhoneNumber: string read FPhoneNumber write FPhoneNumber;
  end;

  {  TDXPlayTCPIPSetting  }

  TDXPlayTCPIPSetting = class(TPersistent)
  private
    FEnabled: Boolean;
    FHostName: string;
    FPort: Word;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Enabled: Boolean read FEnabled write FEnabled;
    property HostName: string read FHostName write FHostName;
    property Port: Word read FPort write FPort;
  end;

  {  EDXPlayError  }

  EDXPlayError = class(Exception);

  {  TCustomDXPlay  }

  TDXPlayEvent = procedure(Sender: TObject; Player: TDXPlayPlayer) of object;

  TDXPlayMessageEvent = procedure(Sender: TObject; From: TDXPlayPlayer;
    Data: Pointer; DataSize: Integer) of object;

  TDXPlaySendCompleteResult = (crOk, crAbort, crGeneric);

  TDXPlaySendCompleteEvent = procedure(Sender: TObject; MessageID: DWORD;
    Result: TDXPlaySendCompleteResult; SendTime: Integer) of object;

  TCustomDXPlay = class(TComponent)
  private
    FDPlay: IDirectPlay4A;
    FGUID: string;
    FIsHost: Boolean;
    FLocalPlayer: TDXPlayPlayer;
    FMaxPlayers: Integer;
    FPlayers: TDXPlayPlayers;
    FCalledDoOpen: Boolean;
    FOnAddPlayer: TDXPlayEvent;
    FOnClose: TNotifyEvent;
    FOnDeletePlayer: TDXPlayEvent;
    FOnMessage: TDXPlayMessageEvent;
    FOnOpen: TNotifyEvent;
    FOnSendComplete: TDXPlaySendCompleteEvent;
    FOnSessionLost: TNotifyEvent;
    FOpened: Boolean;
    FRecvEvent: array[0..1] of THandle;
    FRecvThread: TThread;
    FInThread: Boolean;
    FProviderName: string;
    FProviders: TStrings;
    FSessionName: string;
    FSessions: TStrings;
    FReadSessioned: Boolean;
    FModemSetting: TDXPlayModemSetting;
    FTCPIPSetting: TDXPlayTCPIPSetting;
    FAsync: Boolean;
    FAsyncSupported: Boolean;
    procedure ChangeDPlay;
    procedure CreateDPlayWithoutDialog(out DPlay: IDirectPlay4A; const ProviderName: string);
    function OpenDPlayWithLobby(out Name: string): Boolean;
    function OpenDPlayWithoutLobby(out Name: string): Boolean;
    function OpenDPlayWithoutLobby2(const NewSession: Boolean; const ProviderName, SessionName, PlayerName: string): Boolean;
    procedure Open_(NameS: string);
    procedure ReceiveMessage;
    function GetProviders: TStrings;
    function GetSessionsPty: TStrings;
    procedure ClearSessionList;
    procedure SetGUID(const Value: string);
    procedure SetModemSetting(Value: TDXPlayModemSetting);
    procedure SetProviderName(const Value: string);
    procedure SetTCPIPSetting(Value: TDXPlayTCPIPSetting);
  protected
    procedure DoAddPlayer(Player: TDXPlayPlayer); virtual;
    procedure DoClose; virtual;
    procedure DoDeletePlayer(Player: TDXPlayPlayer); virtual;
    procedure DoMessage(From: TDXPlayPlayer; Data: Pointer; DataSize: Integer); virtual;
    procedure DoOpen; virtual;
    procedure DoSessionLost; virtual;
    procedure DoSendComplete(MessageID: DWORD; Result: TDXPlaySendCompleteResult;
      SendTime: Integer); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Close;
    procedure Open;
    procedure Open2(NewSession: Boolean; const SessionName, PlayerName: string);
    function GetProviderNameFromGUID(const ProviderGUID: TGUID): string;
    procedure GetSessions;
    procedure SendMessage(ToID: TDPID; Data: Pointer; DataSize: Integer);
    function SendMessageEx(ToID: TDPID; Data: Pointer; DataSize: Integer;
      dwFlags: DWORD): DWORD;
    property GUID: string read FGUID write SetGUID;
    property IsHost: Boolean read FIsHost;
    property LocalPlayer: TDXPlayPlayer read FLocalPlayer;
    property MaxPlayers: Integer read FMaxPlayers write FMaxPlayers;
    property OnAddPlayer: TDXPlayEvent read FOnAddPlayer write FOnAddPlayer;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnDeletePlayer: TDXPlayEvent read FOnDeletePlayer write FOnDeletePlayer;
    property OnMessage: TDXPlayMessageEvent read FOnMessage write FOnMessage;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
    property OnSendComplete: TDXPlaySendCompleteEvent read FOnSendComplete write FOnSendComplete;
    property OnSessionLost: TNotifyEvent read FOnSessionLost write FOnSessionLost;
    property Opened: Boolean read FOpened;
    property Players: TDXPlayPlayers read FPlayers;
    property ProviderName: string read FProviderName write SetProviderName;
    property Providers: TStrings read GetProviders;
    property SessionName: string read FSessionName;
    property Sessions: TStrings read GetSessionsPty;
    property ModemSetting: TDXPlayModemSetting read FModemSetting write SetModemSetting;
    property TCPIPSetting: TDXPlayTCPIPSetting read FTCPIPSetting write SetTCPIPSetting;
    property Async: Boolean read FAsync write FAsync;
    property AsyncSupported: Boolean read FAsyncSupported;
  end;

  TDXPlay = class(TCustomDXPlay)
  published
    property Async;
    property GUID;
    property MaxPlayers;
    property ModemSetting;
    property TCPIPSetting;
    property OnAddPlayer;
    property OnClose;
    property OnDeletePlayer;
    property OnMessage;
    property OnOpen;
    property OnSendComplete;
    property OnSessionLost;
  end;

function DXPlayMessageType(P: Pointer): DWORD;

function DXPlayStringToGUID(const S: string): TGUID;
function DXDirectPlayCreate(const lpGUID: TGUID; out lplpDP: IDirectPlay;
  pUnk: IUnknown): HRESULT;

implementation

uses DXPlayFm, DXConsts;

function DXPlayMessageType(P: Pointer): DWORD;
begin
  Result := PDPMSG_GENERIC(P)^.dwType;
end;

function DXPlayStringToGUID(const S: string): TGUID;
var
  ErrorCode: Integer;
begin
  ErrorCode := CLSIDFromString(PWideChar(WideString(S)), Result);
  if ErrorCode<0 then
    raise EDXPlayError.Create(WindowsErrorMsg(ErrorCode));
end;

function GUIDToString(const ClassID: TGUID): string;
var
  ErrorCode: Integer;
  P: PWideChar;
begin
  ErrorCode := StringFromCLSID(ClassID, P);
  if ErrorCode<0 then
    raise EDXPlayError.Create(WindowsErrorMsg(ErrorCode));
  Result := P;
  CoTaskMemFree(P);
end;

function DXDirectPlayCreate(const lpGUID: TGUID; out lplpDP: IDirectPlay;
  pUnk: IUnknown): HRESULT;
type
  TDirectPlayCreate= function(const lpGUID: TGUID; out lplpDP: IDirectPlay; pUnk: IUnknown): HRESULT; stdcall;
begin
  Result := TDirectPlayCreate(DXLoadLibrary('DPlayX.dll', 'DirectPlayCreate'))
    (lpGUID, lplpDP, pUnk);
end;

function DXDirectPlayEnumerateA(lpEnumDPCallback: TDPEnumDPCallbackA; lpContext: Pointer): HRESULT;
type
  TDirectPlayEnumerateA= function(lpEnumDPCallback: TDPEnumDPCallbackA; lpContext: Pointer): HRESULT; stdcall;
begin
  Result := TDirectPlayEnumerateA(DXLoadLibrary('DPlayX.dll', 'DirectPlayEnumerateA'))
    (lpEnumDPCallback, lpContext);
end;

function DXDirectPlayLobbyCreateA(const lpguidSP: TGUID; out lplpDPL: IDirectPlayLobbyA;
  lpUnk: IUnknown; lpData: Pointer; dwDataSize: DWORD): HRESULT;
type
  TDirectPlayLobbyCreateA = function(const lpguidSP: TGUID; out lplpDPL: IDirectPlayLobbyA;
    lpUnk: IUnknown; lpData: Pointer; dwDataSize: DWORD): HRESULT; stdcall;
begin
  Result := TDirectPlayLobbyCreateA(DXLoadLibrary('DPlayX.dll', 'DirectPlayLobbyCreateA'))
    (lpguidSP, lplpDPL, lpUnk, lpData, dwDataSize);
end;

{  TDXPlayPlayers  }

constructor TDXPlayPlayers.Create;
begin
  inherited Create(TDXPlayPlayer);
end;

function TDXPlayPlayers.Find(ID: TDPID): TDXPlayPlayer;
var
  i: Integer;
begin
  i := IndexOf(ID);
  if i=-1 then
    raise EDXPlayError.Create(SDXPlayPlayerNotFound);
  Result := Players[i];
end;

function TDXPlayPlayers.IndexOf(ID: TDPID): Integer;
var
  i: Integer;
begin
  for i:=0 to Count-1 do
    if Players[i].FID=ID then
    begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

function TDXPlayPlayers.GetPlayer(Index: Integer): TDXPlayPlayer;
begin
  Result := TDXPlayPlayer(Items[Index]);
end;

{  TDXPlayModemSetting  }

destructor TDXPlayModemSetting.Destroy;
begin
  FModemNames.Free;
  inherited Destroy;
end;

procedure TDXPlayModemSetting.Assign(Source: TPersistent);
begin
  if Source is TDXPlayModemSetting then
  begin
    FEnabled := TDXPlayModemSetting(Source).FEnabled;
    FPhoneNumber := TDXPlayModemSetting(Source).FPhoneNumber;
    FModemName := TDXPlayModemSetting(Source).FModemName;
  end else
    inherited Assign(Source);
end;

function TDXPlayModemSetting.GetModemNames: TStrings;

  function EnumModemAddress(const guidDataType: TGUID;
    dwDataSize: DWORD; lpData: Pointer; lpContext: Pointer): BOOL; stdcall;
  begin
    if CompareMem(@guidDataType, @DPAID_Modem, SizeOf(TGUID)) then
      TStrings(lpContext).Add( PChar(lpData));
    Result := True;
  end;

var
  Lobby1: IDirectPlayLobbyA;
  Lobby: IDirectPlayLobby2A;
  DPlay1: IDirectPlay;
  DPlay: IDirectPlay4A;
  lpAddress: Pointer;
  dwAddressSize: DWORD;
begin
  if FModemNames=nil then
  begin
    FModemNames := TStringList.Create;
    try
      if DXDirectPlayLobbyCreateA(PGUID(nil)^, Lobby1, nil, nil, 0)<>0 then
        raise EDXPlayError.CreateFmt(SCannotInitialized, [SDirectPlay]);
      Lobby := Lobby1 as IDirectPlayLobby2A;

      if DXDirectPlayCreate(DPSPGUID_MODEM, DPlay1, nil)<>0 then
        raise EDXPlayError.CreateFmt(SCannotInitialized, [SDirectPlay]);
      DPlay := DPlay1 as IDirectPlay4A;

      {  get size of player address for all players  }
      if DPlay.GetPlayerAddress(DPID_ALLPLAYERS, nil, dwAddressSize)<>DPERR_BUFFERTOOSMALL then
        raise EDXPlayError.Create(SDXPlayModemListCannotBeAcquired);

      GetMem(lpAddress, dwAddressSize);
      try
        FillChar(lpAddress^, dwAddressSize, 0);

        {  get the address  }
        if DPlay.GetPlayerAddress(DPID_ALLPLAYERS, lpAddress, dwAddressSize)<>0 then
          raise EDXPlayError.Create(SDXPlayModemListCannotBeAcquired);

        {  get modem strings from address and put them in the combo box  }
        if Lobby.EnumAddress(@EnumModemAddress, lpAddress^, dwAddressSize, FModemNames)<>0 then
          raise EDXPlayError.Create(SDXPlayModemListCannotBeAcquired);
      finally
        FreeMem(lpAddress);
      end;
    except
      FModemNames.Free; FModemNames := nil;
      raise;
    end;
  end;

  Result := FModemNames;
end;

{  TDXPlayTCPIPSetting  }

procedure TDXPlayTCPIPSetting.Assign(Source: TPersistent);
begin
  if Source is TDXPlayTCPIPSetting then
  begin
    FEnabled := TDXPlayTCPIPSetting(Source).FEnabled;
    FHostName := TDXPlayTCPIPSetting(Source).FHostName;
  end else
    inherited Assign(Source);
end;

{  TCustomDXPlay  }

constructor TCustomDXPlay.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPlayers := TDXPlayPlayers.Create;
  FModemSetting := TDXPlayModemSetting.Create;
  FTCPIPSetting := TDXPlayTCPIPSetting.Create;
  FSessions := TStringList.Create;

  FGUID := GUIDToString(GUID_NULL);
  FMaxPlayers := 0;
end;

destructor TCustomDXPlay.Destroy;
var
  i: Integer;
begin
  Close;

  FPlayers.Free;

  if FProviders<>nil then
  begin
    for i:=0 to FProviders.Count-1 do
      Dispose(PGUID(FProviders.Objects[i]));
  end;
  FProviders.Free;
  FModemSetting.Free;
  FTCPIPSetting.Free;
  ClearSessionList;
  FSessions.Free;
  inherited Destroy;
end;

type
  TDXPlayRecvThread = class(TThread)
  private
    FDXPlay: TCustomDXPlay;
    constructor Create(DXPlay: TCustomDXPlay);
    destructor Destroy; override;
    procedure Execute; override;
  end;

constructor TDXPlayRecvThread.Create(DXPlay: TCustomDXPlay);
begin
  FDXPlay := DXPlay;

  FDXPlay.FRecvEvent[1] := CreateEvent(nil, False, False, nil);

  FreeOnTerminate := True;
  inherited Create(True);
end;

destructor TDXPlayRecvThread.Destroy;
begin
  FreeOnTerminate := False;
  SetEvent(FDXPlay.FRecvEvent[1]);

  inherited Destroy;

  CloseHandle(FDXPlay.FRecvEvent[1]);

  FDXPlay.FRecvThread := nil;
  FDXPlay.Close;
end;

procedure TDXPlayRecvThread.Execute;
begin
  while WaitForMultipleObjects(2, @FDXPlay.FRecvEvent, False, INFINITE)=WAIT_OBJECT_0 do
  begin
    Synchronize(FDXPlay.ReceiveMessage);
  end;
end;

procedure TCustomDXPlay.ReceiveMessage;
var
  idFrom, idTo: DWORD;
  hr: HRESULT;
  lpvMsgBuffer: Pointer;
  dwMsgBufferSize: DWORD;
  Msg_CreatePlayerOrGroup: PDPMSG_CREATEPLAYERORGROUP;
  Msg_DeletePlayerOrGroup: PDPMSG_DESTROYPLAYERORGROUP;
  Msg_SendComplete: PDPMsg_SendComplete;
  SendCompleteResult: TDXPlaySendCompleteResult;
  Player: TDXPlayPlayer;
  i: Integer;
begin
  FInThread := True;
  try
    try
      lpvMsgBuffer := nil;
      dwMsgBufferSize := 0;

      try
        repeat
          hr := FDPlay.Receive(idFrom, idTo, DPRECEIVE_ALL, lpvMsgBuffer, dwMsgBufferSize);

          if hr=DPERR_BUFFERTOOSMALL then
          begin
            ReAllocMem(lpvMsgBuffer, dwMsgBufferSize);
            hr := FDPlay.Receive(idFrom, idTo, DPRECEIVE_ALL, lpvMsgBuffer, dwMsgBufferSize);
          end;

          if (hr=0) and (dwMsgBufferSize>=SizeOf(TDPMSG_GENERIC)) then
          begin
            if idFrom=DPID_SYSMSG then
            begin
              {  System message  }
              case PDPMSG_GENERIC(lpvMsgBuffer)^.dwType of
                DPSYS_CREATEPLAYERORGROUP:
                  begin
                    {  New player  }
                    Msg_CreatePlayerOrGroup := lpvMsgBuffer;

                    if Msg_CreatePlayerOrGroup.DPID<>FLocalPlayer.FID then
                    begin
                      Player := TDXPlayPlayer.Create(Players);
                      Player.FID := Msg_CreatePlayerOrGroup.DPID;
                      Player.FRemotePlayer := True;

                      with Msg_CreatePlayerOrGroup.dpnName do
                      begin
                        if lpszShortNameA<>nil then
                          Player.FName := lpszShortNameA;
                      end;

                      DoAddPlayer(Player);
                    end;
                  end;
                DPSYS_DESTROYPLAYERORGROUP:
                  begin
                    {  Player deletion  }
                    Msg_DeletePlayerOrGroup := lpvMsgBuffer;

                    if Msg_DeletePlayerOrGroup.DPID<>FLocalPlayer.FID then
                    begin
                      i := Players.IndexOf(Msg_DeletePlayerOrGroup.DPID);
                      if i<>-1 then
                      begin   
                        Player := Players[i];
                        DoDeletePlayer(Player);
                        Player.Free;
                      end;
                    end;
                  end;
                DPSYS_SESSIONLOST:
                  begin
                    {  The session was lost.  }
                    DoSessionLost;
                    Close;
                  end;
                DPSYS_HOST:
                  begin
                    {  Here became a host.  }
                    FIsHost := True;
                  end;
                DPSYS_SENDCOMPLETE:
                   begin
                     { Send complete  }
                     Msg_SendComplete := lpvMsgBuffer;
                     if Msg_SendComplete.idFrom=FLocalPlayer.FID then
                     begin
                       case Msg_SendComplete.hr of
                         DP_OK        : SendCompleteResult := crOk;
                         DPERR_ABORTED: SendCompleteResult := crAbort;
                         else           SendCompleteResult := crGeneric;
                       end;

                       DoSendComplete(Msg_SendComplete^.dwMsgID, SendCompleteResult, Msg_SendComplete^.dwSendTime);
                     end;
                   end;
              end;
            end else
            begin
              {  Application definition message  }
              DoMessage(Players.Find(idFrom), lpvMsgBuffer, dwMsgBufferSize);
            end;
          end;
        until hr<>0;
      finally
        FreeMem(lpvMsgBuffer);
      end;
    except
      on E: Exception do
        Application.HandleException(E);
    end;
  finally
    FInThread := False;
  end;
end;

procedure TCustomDXPlay.DoAddPlayer(Player: TDXPlayPlayer);
begin
  if Assigned(FOnAddPlayer) then FOnAddPlayer(Self, Player)
end;

procedure TCustomDXPlay.DoClose;
begin
  if Assigned(FOnClose) then FOnClose(Self);
end;

procedure TCustomDXPlay.DoDeletePlayer(Player: TDXPlayPlayer);
begin
  if Assigned(FOnDeletePlayer) then FOnDeletePlayer(Self, Player)
end;

procedure TCustomDXPlay.DoMessage(From: TDXPlayPlayer; Data: Pointer; DataSize: Integer);
begin
  if Assigned(FOnMessage) then FOnMessage(Self, From, Data, DataSize);
end;

procedure TCustomDXPlay.DoOpen;
begin
  if Assigned(FOnOpen) then FOnOpen(Self);
end;

procedure TCustomDXPlay.DoSessionLost;
begin
  if Assigned(FOnSessionLost) then FOnSessionLost(Self);
end;

procedure TCustomDXPlay.DoSendComplete(MessageID: DWORD; Result: TDXPlaySendCompleteResult;
  SendTime: Integer);
begin
  if Assigned(FOnSendComplete) then FOnSendComplete(Self, MessageID, Result, SendTime);
end;

function TCustomDXPlay.GetProviders: TStrings;

  function EnumProviderCallback(const lpguidSP: TGUID; lpSPName: LPSTR;
      dwMajorVersion: DWORD; dwMinorVersion: DWORD; lpContext: Pointer):
      BOOL; stdcall;
  var
    GUID: PGUID;
  begin
    GUID := New(PGUID);
    Move(lpguidSP, GUID^, SizeOf(TGUID));
    TStrings(lpContext).AddObject(lpSPName, TObject(GUID));
    Result := True;
  end;

begin
  if FProviders=nil then
  begin
    FProviders := TStringList.Create;
    try
      DXDirectPlayEnumerateA(@EnumProviderCallback, FProviders);
    except
      FProviders.Free; FProviders := nil;
      raise;
    end;
  end;

  Result := FProviders;
end;

procedure TCustomDXPlay.GetSessions;

  function EnumSessionsCallback(const lpThisSD: TDPSessionDesc2;
    var lpdwTimeOut: DWORD; dwFlags: DWORD; lpContext: Pointer): BOOL; stdcall;
  var
    Guid: PGUID;
  begin
    if dwFlags and DPESC_TIMEDOUT<>0 then
    begin
      Result := False;
      Exit;
    end;

    Guid := New(PGUID);
    Move(lpThisSD.guidInstance, Guid^, SizeOf(TGUID));
    TStrings(lpContext).AddObject(lpThisSD.lpszSessionNameA, TObject(Guid));

    Result := True;
  end;

var
  dpDesc: TDPSessionDesc2;
  hr: HRESULT;
begin
  if FDPlay=nil then
    raise EDXPlayError.Create(SDXPlayNotConnectedNow);

  ClearSessionList;

  FillChar(dpDesc, SizeOf(dpDesc), 0);
  dpDesc.dwSize := SizeOf(dpDesc);
  dpDesc.guidApplication := DXPlayStringToGUID(FGUID);

  hr := FDPlay.EnumSessions(dpDesc, 0, @EnumSessionsCallback, FSessions, DPENUMSESSIONS_AVAILABLE);
  if hr=DPERR_USERCANCEL then Abort;
  if hr<>0 then
    raise EDXPlayError.Create(SDXPlaySessionListCannotBeAcquired);

  FReadSessioned := True;
end;

function TCustomDXPlay.GetSessionsPty: TStrings;
begin
  if not FReadSessioned then GetSessions;
  Result := FSessions;
end;

function TCustomDXPlay.GetProviderNameFromGUID(const ProviderGUID: TGUID): string;
var
  i: Integer;
begin
  for i:=0 to Providers.Count-1 do
    if CompareMem(PGUID(Providers.Objects[i]), @ProviderGUID, SizeOf(TGUID)) then
    begin
      Result := Providers[i];
      Exit;
    end;

  raise EDXPlayError.Create(SDXPlayProviderSpecifiedGUIDNotFound);
end;

procedure TCustomDXPlay.CreateDPlayWithoutDialog(out DPlay: IDirectPlay4A; const ProviderName: string);
var
  i: Integer;
  ProviderGUID: TGUID;
  addressElements: array[0..15] of TDPCompoundAddressElement;
  dwElementCount: Integer;
  Lobby1: IDirectPlayLobbyA;
  Lobby: IDirectPlayLobby2A;
  lpAddress: Pointer;
  dwAddressSize: DWORD;
begin
  i := Providers.IndexOf(ProviderName);
  if i=-1 then
    raise EDXPlayError.CreateFmt(SDXPlayProviderNotFound, [ProviderName]);
  ProviderGUID := PGUID(Providers.Objects[i])^;

  {  DirectPlay address making  }
  if DXDirectPlayLobbyCreateA(PGUID(nil)^, Lobby1, nil, nil, 0)<>0 then
    raise EDXPlayError.CreateFmt(SCannotInitialized, [SDirectPlay]);
  Lobby := Lobby1 as IDirectPlayLobby2A;

  FillChar(addressElements, SizeOf(addressElements), 0);
  dwElementCount := 0;

  addressElements[dwElementCount].guidDataType := DPAID_ServiceProvider;
  addressElements[dwElementCount].dwDataSize := SizeOf(TGUID);
  addressElements[dwElementCount].lpData := @ProviderGUID;
  Inc(dwElementCount);

  if CompareMem(@ProviderGUID, @DPSPGUID_MODEM, SizeOf(TGUID)) and ModemSetting.Enabled then
  begin
    {  Modem  }
    if ModemSetting.FModemName<>'' then
    begin
      addressElements[dwElementCount].guidDataType := DPAID_Modem;
      addressElements[dwElementCount].dwDataSize := Length(ModemSetting.FModemName)+1;
      addressElements[dwElementCount].lpData := PChar(ModemSetting.FModemName);
      Inc(dwElementCount);
    end;

    if ModemSetting.FPhoneNumber<>'' then
    begin
      addressElements[dwElementCount].guidDataType := DPAID_Phone;
      addressElements[dwElementCount].dwDataSize := Length(ModemSetting.FPhoneNumber)+1;
      addressElements[dwElementCount].lpData := PChar(ModemSetting.FPhoneNumber);
      Inc(dwElementCount);
    end;
  end else
  if CompareMem(@ProviderGUID, @DPSPGUID_TCPIP, SizeOf(TGUID)) and TCPIPSetting.Enabled then
  begin
    {  TCP/IP  }
    if TCPIPSetting.FHostName<>'' then
    begin
      addressElements[dwElementCount].guidDataType := DPAID_INet;
      addressElements[dwElementCount].dwDataSize := Length(TCPIPSetting.FHostName)+1;
      addressElements[dwElementCount].lpData := PChar(TCPIPSetting.FHostName);
      Inc(dwElementCount);
    end;

    if TCPIPSetting.Port<>0 then
    begin                                                           
      addressElements[dwElementCount].guidDataType := DPAID_INetPort;
      addressElements[dwElementCount].dwDataSize := SizeOf(TCPIPSetting.FPort);
      addressElements[dwElementCount].lpData := @TCPIPSetting.FPort;
      Inc(dwElementCount);                                         
    end;
  end;

  if Lobby.CreateCompoundAddress(addressElements[0], dwElementCount, nil, dwAddressSize)<>DPERR_BUFFERTOOSMALL then
    raise EDXPlayError.CreateFmt(SCannotInitialized, [SDirectPlay]);

  GetMem(lpAddress, dwAddressSize);
  try
    FillChar(lpAddress^, dwAddressSize, 0);

    if Lobby.CreateCompoundAddress(addressElements[0], dwElementCount, lpAddress, dwAddressSize)<>0 then
      raise EDXPlayError.CreateFmt(SCannotInitialized, [SDirectPlay]);

    {  DirectPlay initialization  }
    if CoCreateInstance(CLSID_DirectPlay, nil, CLSCTX_INPROC_SERVER, IID_IDirectPlay4A, DPlay)<>0 then
      raise EDXPlayError.CreateFmt(SCannotInitialized, [SDirectPlay]);
    try
      {  DirectPlay address initialization  }
      if DPlay.InitializeConnection(lpAddress, 0)<>0 then
        raise EDXPlayError.CreateFmt(SCannotInitialized, [SDirectPlay]);
    except
      DPlay := nil;
      raise;
    end;
  finally
    FreeMem(lpAddress);
  end;
end;

procedure TCustomDXPlay.ClearSessionList;
var
  i: Integer;
begin
  FReadSessioned := False;
  for i:=0 to FSessions.Count-1 do
    Dispose(PGUID(FSessions.Objects[i]));
  FSessions.Clear;
end;

procedure TCustomDXPlay.Open;
var
  PlayerName: string;
begin
  Close;
  try
    if not OpenDPlayWithLobby(PlayerName) then
    begin
      if not OpenDPlayWithoutLobby(PlayerName) then
        Abort;
    end;

    Open_(PlayerName);
  except
    Close;
    raise;
  end;
end;

procedure TCustomDXPlay.Open2(NewSession: Boolean; const SessionName, PlayerName: string);
begin
  if not OpenDPlayWithoutLobby2(NewSession, ProviderName, SessionName, PlayerName) then
    Abort;

  Open_(PlayerName);
end;

procedure TCustomDXPlay.Open_(NameS: string);

  function EnumPlayersCallback2(TDPID: TDPID; dwPlayerType: DWORD;
    const lpName: TDPName; dwFlags: DWORD; lpContext: Pointer): BOOL;
    stdcall;
  var                   
    Player: TDXPlayPlayer;
  begin
    Player := TDXPlayPlayer.Create(TCustomDXPlay(lpContext).Players);
    Player.FID := TDPID;
    Player.FRemotePlayer := True;

    with lpName do
    begin
      if lpszShortNameA<>nil then
        Player.FName := lpszShortNameA;
    end;

    Result := True;
  end;

var
  Name2: array[0..1023] of Char;
  Name: TDPName;
begin
  if FOpened then Close;
  FOpened := True;
  try
    {  Player making  }
    StrLCopy(@Name2, PChar(NameS), SizeOf(Name2));

    Name.lpszShortNameA := @Name2;
    Name.lpszLongNameA := nil;

    FRecvEvent[0] := CreateEvent(nil, False, False, nil);

    FLocalPlayer := TDXPlayPlayer.Create(FPlayers);
    FLocalPlayer.FName := NameS;

    if FDPlay.CreatePlayer(FLocalPlayer.FID, @Name, FRecvEvent[0], nil, 0, 0)<>DP_OK then
      raise EDXPlayError.CreateFmt(SCannotOpened, [FSessionName]);

    {  Player enumeration  }
    FDPlay.EnumPlayers(PGUID(nil), @EnumPlayersCallback2, Self, DPENUMPLAYERS_REMOTE);

    FIsHost := FPlayers.Count=1;

    FCalledDoOpen := True; DoOpen;
    DoAddPlayer(FLocalPlayer);

    {  Thread start  }
    FRecvThread := TDXPlayRecvThread.Create(Self);
    FRecvThread.Resume;
  except
    Close;
    raise;
  end;
end;

procedure TCustomDXPlay.ChangeDPlay;
var
  caps: TDPCAPS;
begin
  FAsyncSupported := False;
  if FDPlay<>nil then
  begin
    FillChar(caps, SizeOf(caps), 0);
    caps.dwSize := SizeOf(caps);
    FDPlay.GetCaps(caps, 0);

    FAsyncSupported := caps.dwFlags and DPCAPS_ASYNCSUPPORTED<>0;
  end;
end;

function TCustomDXPlay.OpenDPlayWithLobby(out Name: string): Boolean;
var
  DPlay1: IDirectPlay2;
  Lobby: IDirectPlayLobbyA;
  dwSize: DWORD;
  ConnectionSettings: PDPLConnection;
begin
  Result := False;

  if DXDirectPlayLobbyCreateA(PGUID(nil)^, Lobby, nil, nil, 0)<>0 then
    Exit;

  if Lobby.GetConnectionSettings(0, PDPLConnection(nil), dwSize)<>DPERR_BUFFERTOOSMALL then
    Exit;

  GetMem(ConnectionSettings, dwSize);
  try
    if Lobby.GetConnectionSettings(0, ConnectionSettings, dwSize)<>0 then
      Exit;

    with ConnectionSettings^.lpSessionDesc^ do
    begin
      dwFlags := DPSESSION_MIGRATEHOST or DPSESSION_KEEPALIVE or DPSESSION_DIRECTPLAYPROTOCOL;
      dwMaxPlayers := FMaxPlayers;
    end;

    if Lobby.SetConnectionSettings(0, 0, ConnectionSettings^)<>0 then
      Exit;

    if Lobby.Connect(0, DPlay1, nil)<>0 then
      Exit;
    FDPlay := DPlay1 as IDirectPlay4A;
    ChangeDPlay;

    with ConnectionSettings.lpSessionDesc^ do
    begin
      if lpszSessionNameA<>nil then
        FSessionName := lpszSessionNameA;
    end;

    with ConnectionSettings.lpPlayerName^ do
    begin
      if lpszShortNameA<>nil then
        Name := lpszShortNameA;
    end;
  finally
    FreeMem(ConnectionSettings);
  end;

  Result := True;
end;

function TCustomDXPlay.OpenDPlayWithoutLobby(out Name: string): Boolean;
var
  Form: TDelphiXDXPlayForm;
begin
  Form := TDelphiXDXPlayForm.Create(Application);
  try
    Form.DXPlay := Self;
    Form.ShowModal;

    Result := Form.Tag<>0;

    FDPlay := Form.DPlay;
    ChangeDPlay;

    Name := Form.PlayerName;
    FProviderName := Form.ProviderName;
    FSessionName := Form.SessionName;
  finally
    Form.Free;
  end;
end;

function TCustomDXPlay.OpenDPlayWithoutLobby2(const NewSession: Boolean;
  const ProviderName, SessionName, PlayerName: string): Boolean;
var
  dpDesc: TDPSessionDesc2;
  i: Integer;
  hr: HRESULT;
begin
  Result := False;

  if FDPlay=nil then
    raise EDXPlayError.Create(SDXPlayNotConnectedNow);

  if SessionName='' then
    raise EDXPlayError.Create(SDXPlaySessionNameIsNotSpecified);

  if PlayerName='' then
    raise EDXPlayError.Create(SDXPlayPlayerNameIsNotSpecified);

  if NewSession then
  begin
    {  Session connection  }
    FillChar(dpDesc, SizeOf(dpDesc), 0);
    dpDesc.dwSize := SizeOf(dpDesc);
    dpDesc.dwFlags := DPSESSION_MIGRATEHOST or DPSESSION_KEEPALIVE;
    dpDesc.lpszSessionNameA := PChar(SessionName);
    dpDesc.guidApplication := DXPlayStringToGUID(GUID);
    dpDesc.dwMaxPlayers := MaxPlayers;

    hr := FDPlay.Open(dpDesc, DPOPEN_CREATE);
    if hr=DPERR_USERCANCEL then Exit;
    if hr<>0 then
      raise EDXPlayError.CreateFmt(SDXPlaySessionCannotOpened, [FSessionName]);
  end else
  begin
    {  Session connection  }
    {  Enum session  }
    i := Sessions.IndexOf(SessionName);
    if i=-1 then raise EDXPlayError.CreateFmt(SDXPlaySessionNotFound, [SessionName]);

    FillChar(dpDesc, SizeOf(dpDesc), 0);
    dpDesc.dwSize := SizeOf(dpDesc);
    dpDesc.guidInstance := PGUID(Sessions.Objects[i])^;
    dpDesc.guidApplication := DXPlayStringToGUID(GUID);

    hr := FDPlay.Open(dpDesc, DPOPEN_JOIN);
    if hr=DPERR_USERCANCEL then Exit;
    if hr<>0 then
      raise EDXPlayError.CreateFmt(SDXPlaySessionCannotOpened, [FSessionName]);
  end;

  Result := True;

  FSessionName := SessionName;
end;

procedure TCustomDXPlay.Close;
begin
  FOpened := False;
  FReadSessioned := False;

  try
    if FCalledDoOpen then
    begin
      FCalledDoOpen := False;
      DoClose;
    end;
  finally
    if FDPlay<>nil then
    begin
      if FLocalPlayer<>nil then FDPlay.DestroyPlayer(FLocalPlayer.FID);
      FDPlay.Close;
    end;

    FProviderName := '';
    FSessionName := '';
    FAsyncSupported := False;
    
    ClearSessionList;

    FDPlay := nil;
    ChangeDPlay;

    if FInThread then
      SetEvent(FRecvEvent[1])
    else
      FRecvThread.Free;
    
    CloseHandle(FRecvEvent[0]); FRecvEvent[0] := 0;

    FPlayers.Clear;

    FLocalPlayer := nil;
  end;
end;

procedure TCustomDXPlay.SendMessage(ToID: TDPID; Data: Pointer; DataSize: Integer);
begin
  if not Opened then Exit;

  if DataSize<SizeOf(TDPMSG_GENERIC) then
    raise EDXPlayError.Create(SDXPlayMessageIllegal);

  if ToID=FLocalPlayer.ID then
  begin
    {  Message to me  }
    DoMessage(FLocalPlayer, Data, DataSize);
  end else
  if FAsync and FAsyncSupported then
    FDPlay.SendEx(FLocalPlayer.ID, ToID, DPSEND_GUARANTEED or DPSEND_ASYNC, Data, DataSize, 0, 0, nil, nil)
  else
    FDPlay.Send(FLocalPlayer.ID, ToID, DPSEND_GUARANTEED, Data^, DataSize);
end;

function TCustomDXPlay.SendMessageEx(ToID: TDPID; Data: Pointer; DataSize: Integer;
  dwFlags: DWORD): DWORD;
begin
  if not Opened then Exit;

  if DataSize<SizeOf(TDPMSG_GENERIC) then
    raise EDXPlayError.Create(SDXPlayMessageIllegal);

  Result := 0;
  if ToID=FLocalPlayer.ID then
  begin
    {  自分宛のメッセージ  }
    DoMessage(FLocalPlayer, Data, DataSize);
  end else
    FDPlay.SendEx(FLocalPlayer.ID, ToID, dwFlags, Data, DataSize,
      0, 0, nil, @Result); // 0 以外はサポートしないデバイスあるので使わない
end;

procedure TCustomDXPlay.SetGUID(const Value: string);
begin
  if Value<>FGUID then
  begin
    if Value='' then
    begin
      FGUID := GUIDToString(GUID_NULL);
    end else
    begin
      FGUID := GUIDToString(DXPlayStringToGUID(Value));
    end;
  end;
end;

procedure TCustomDXPlay.SetModemSetting(Value: TDXPlayModemSetting);
begin
  FModemSetting.Assign(Value);
end;

procedure TCustomDXPlay.SetProviderName(const Value: string);
begin
  Close;
  FProviderName := Value;
  if FProviderName='' then Exit;
  try
    CreateDPlayWithoutDialog(FDPlay, Value);
  except
    FProviderName := '';
    raise;
  end;
end;

procedure TCustomDXPlay.SetTCPIPSetting(Value: TDXPlayTCPIPSetting);
begin
  FTCPIPSetting.Assign(Value);
end;

initialization
  CoInitialize(nil);
finalization
  CoUninitialize;
end.
