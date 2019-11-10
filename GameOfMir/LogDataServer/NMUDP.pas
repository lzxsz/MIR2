{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
////////////////////////////////////////////////////////////////////////////
//                                                                        //
// Copyright © 1997-1999, NetMasters, L.L.C - All rights reserved worldwide.   //
//  Portions may be Copyright © Borland International, Inc.               //
//                                                                        //
// Unit Name: NMUDP                                                       //
//                                                                        //
// DESCRIPTION:Internet UDP Component                                     //
//  + Aug-9-98  Version 4.1 -- KNA                                        //
//                                                                        //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY  //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE    //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR  //
// PURPOSE.                                                               //
//                                                                        //
////////////////////////////////////////////////////////////////////////////
}
// Revision History
// 01 04 00 - KNA -  Non ASYNC messages passed on
// 07 12 99 - KNA -  Resolve Host converted to Wait
// 07 02 98 - KNA -  Port of sender available
// 01 27 98 - KNA -  Final release Ver 4.00 VCLS
//

{$IFDEF VER100}
{$DEFINE NMF3}
{$ENDIF}
{$IFDEF VER110}
{$DEFINE NMF3}
{$ENDIF}
{$IFDEF VER120}
{$DEFINE NMF3}
{$ENDIF}
{$IFDEF VER125}
{$DEFINE NMF3}
{$ENDIF}

unit NMUDP;

interface

uses
  Winsock, Classes, Sysutils, WinTypes, Messages, Forms;
{$IFDEF VER110}
{$OBJEXPORTALL On}
{$ENDIF}
{$IFDEF VER120}
{$OBJEXPORTALL On}
{$ENDIF}
{$IFDEF VER125}
{$OBJEXPORTALL On}
{$ENDIF}

const

   //  CompName           ='TNMUDP';

   //  Major_Version      ='4';
   //  Minor_Version      ='02';
   //  Date_Version       ='012798';

   { Levels for reporting Status Messages}
  Status_None = 0;
  Status_Informational = 1;
  Status_Basic = 2;
  Status_Routines = 4;
  Status_Debug = 8;
  Status_Trace = 16;


  WM_ASYNCHRONOUSPROCESS = WM_USER + 101; {Message number for asynchronous socket messages}

const {protocol}
  Const_cmd_true = 'TRUE';

{$IFDEF NMF3}
resourcestring
{$ELSE}
const
{$ENDIF}
  Cons_Palette_Inet = 'Internet';
  Cons_Msg_Wsk = 'Initializing Winsock';
  Cons_Msg_Lkp = 'Host Lookup Canceled';
  Cons_Msg_Data = 'Sending Data';
  Cons_Msg_InvStrm = 'Invalid stream';
  Cons_Msg_Echk = 'Checking Error In Error Manager';
  Cons_Msg_Eno = 'Unknown Error No. ';
  Cons_Msg_ELkp = 'Looking Up Error Message';
  Cons_Err_Addr = 'Null Remote Address';
  Cons_Err_Buffer = 'Invalid buffer';

type

  UDPSockError = class(Exception);

   {Event Handlers}

  TOnErrorEvent = procedure(Sender: TComponent; errno: word; Errmsg: string) of object;
  TOnStatus = procedure(Sender: TComponent; status: string) of object;
  TOnReceive = procedure(Sender: TComponent; NumberBytes: Integer; FromIP: string; Port: integer) of object;
  THandlerEvent = procedure(var handled: boolean) of object;
  TBuffInvalid = procedure(var handled: boolean; var Buff: array of char; var length: integer) of object;
  TStreamInvalid = procedure(var handled: boolean; Stream: TStream) of object;

  TNMUDP = class(TComponent)
  private
    IBuff: array[0..2048] of char;
    IBuffSize: integer;
    FRemoteHost: string;
    FRemotePort: integer;
    FLocalPort: integer; {Port at server to connect to}
    RemoteAddress, RemoteAddress2: TSockAddr; {Address of remote host}
    FSocketWindow: hwnd;
    Wait_Flag: boolean; {Flag to indicate if synchronous request completed or not}
    RemoteHostS: PHostEnt; {Entity to store remote host linfo from a Hostname request}
    Canceled: boolean; {Flag to indicate request cancelled}
    Succeed: boolean; {Flag for indicating if synchronous request succeded}
    MyWSAData: TWSADATA; {Socket Information}
    FOnStatus: TOnStatus; {} {Event handler on a status change}
    FReportLevel: integer; {Reporting Level}
    _status: string; {Current status}
    _ProcMsg: boolean; {Flag to supress or enable socket message processing}
    FLastErrorno: integer; {The last error Encountered}
    FOnErrorEvent: TOnErrorEvent; {} {Event handler for error nitification}
    FOnDataReceived: TOnReceive;
    FOnDataSend: TNotifyEvent;
    FOnInvalidHost: THandlerEvent;
    FOnStreamInvalid: TStreamInvalid;
    FOnBufferInvalid: TBuffInvalid;
    procedure WndProc(var message: TMessage);
    procedure ResolveRemoteHost;
    procedure SetLocalPort(NewLocalPort: integer);
    procedure ProcessIncomingdata;
  protected
    procedure StatusMessage(Level: byte; value: string);
    function ErrorManager(ignore: word): string;
    function SocketErrorStr(Errno: word): string;
    procedure Wait;
  public
    EventHandle : THandle;
    ThisSocket: TSocket; {The socket number of the Powersocket}
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Cancel;
    procedure SendStream(DataStream: TStream);
    procedure SendBuffer(Buff: array of char; length: integer);
    procedure ReadStream(DataStream: TStream);
    procedure ReadBuffer(var Buff: array of char; var length: integer);
  published
    property RemoteHost: string read FRemoteHost write FRemoteHost; {Host Nmae or IP of remote host}
    property RemotePort: integer read FRemotePort write FRemotePort; {Port of remote host}
    property LocalPort: integer read FLocalPort write SetLocalPort; {Port of remote host}
    property ReportLevel: integer read FReportLevel write FReportLevel;
    property OnDataReceived: TOnReceive read FOnDataReceived write FOnDataReceived;
    property OnDataSend: TNotifyEvent read FOnDataSend write FOnDataSend;
    property OnStatus: TOnStatus read FOnStatus write FOnStatus;
    property OnInvalidHost: THandlerEvent read FOnInvalidHost write FOnInvalidHost;
    property OnStreamInvalid: TStreamInvalid read FOnStreamInvalid write FOnStreamInvalid;
    property OnBufferInvalid: TBuffInvalid read FOnBufferInvalid write FOnBufferInvalid;
  end; {_ TNMUDP               = class(TComponent) _}

procedure Register;

implementation

uses NMConst;

procedure Register;
begin
  RegisterComponents(Cons_Palette_Inet, [TNMUDP]);
end; {_ procedure register; _}

procedure WaitforSync(Handle: THandle);
begin
  repeat
    if MsgWaitForMultipleObjects(1, Handle, False,
      INFINITE, QS_ALLINPUT)
      = WAIT_OBJECT_0 + 1
      then Application.ProcessMessages
    else BREAK;
  until True = False;
end; {_WaitforSync_}

procedure TNMUDP.Cancel;
begin
  StatusMessage(Status_Debug, sPSk_Cons_msg_Cancel); {Status Message}
  Canceled := True; {Set Cancelled to true}
  SetEvent(EventHandle);
end;


constructor TNMUDP.Create(AOwner: TComponent);

begin
  inherited create(AOwner);
  _ProcMsg := FALSE; {Inhibit Event processing for socket}
   { Initialize memory }
  getmem(RemoteHostS, MAXGETHOSTSTRUCT); {Initialize memory for host address structure}
  FSocketWindow := AllocateHWnd(WndProc); {Create Window handle to receive message notification}
   { Set Variables }
  FreportLevel := Status_Informational; {Set Default Reporting Level}
  Canceled := FALSE; {Cancelled flag off}
  EventHandle :=  CreateEvent(nil, True, False, '');
  StatusMessage(Status_debug, Cons_Msg_Wsk); {Status Message}
  if WSAStartUp($0101, MyWSADATA) = 0 then
    try
      ThisSocket := Socket(AF_INET, SOCK_DGRAM, 0); {Get a new socket}
      if ThisSocket = TSocket(INVALID_SOCKET) then
        ErrorManager(WSAEWOULDBLOCK); {If error handle error}
      setsockopt(ThisSocket, SOL_SOCKET, SO_DONTLINGER, Const_cmd_true, 4);
    except
      WSACleanup; {If error Cleanup}
      raise; {Pass exception to calling function}
    end {_ try _}
  else {_ NOT if WSAStartUp($0101, MyWSADATA) = 0 then _}
    ErrorManager(WSAEWOULDBLOCK); {Handle Statrtup error}
  _ProcMsg := true;
end; {_ constructor TNMUDP.Create(AOwner: TComponent); _}

{*******************************************************************************************
Destroy Power Socket
********************************************************************************************}

destructor TNMUDP.Destroy;
begin
   {cancel; }
  freemem(RemoteHostS, MAXGETHOSTSTRUCT); {Free memory for fetching Host Entity}
  DeAllocateHWnd(FSocketWindow); {Release window handle for Winsock messages}
  CloseHandle(EventHandle);
  WSACleanUp; {Clean up Winsock}
  inherited destroy; {Do inherited destroy method}
end; {_ destructor TNMUDP.Destroy; _}

procedure TNMUDP.SetLocalPort(NewLocalPort: integer);
begin
  if ThisSocket <> 0 then closesocket(ThisSocket);
  WSAcleanup;
  if WSAStartUp($0101, MyWSADATA) = 0 then
    try
      ThisSocket := Socket(AF_INET, SOCK_DGRAM, 0); {Get a new socket}
      if ThisSocket = TSocket(INVALID_SOCKET) then
        ErrorManager(WSAEWOULDBLOCK); {If error handle error}
    except
      WSACleanup; {If error Cleanup}
      raise; {Pass exception to calling function}
    end {_ try _}
  else {_ NOT if WSAStartUp($0101, MyWSADATA) = 0 then _}
    ErrorManager(WSAEWOULDBLOCK); {Handle Statrtup error}
  FLocalPort := NewLocalPort;
  Loaded;
end; {_ procedure TNMUDP.SetLocalPort(NewLocalPort: integer); _}


procedure TNMUDP.Loaded;
var
  buf: array[0..17] of char;
begin
  if not (csDesigning in ComponentState) then
    begin
      RemoteAddress2.sin_addr.S_addr := Inet_Addr(strpcopy(buf, '0.0.0.0'));
      RemoteAddress2.sin_family := AF_INET; {Family = Internet address}
      RemoteAddress2.sin_port := htons(FLocalPort); {Set port to given port}
      wait_flag := FALSE; {Set flag to wait}
      {Bind Socket to given address}
      WinSock.bind(ThisSocket, RemoteAddress2, SizeOf(RemoteAddress2));
      {Direct reply message to WM_WAITFORRESPONSE handler}
      WSAAsyncselect(ThisSocket, FSocketWindow, WM_ASYNCHRONOUSPROCESS, FD_READ);
    end; {_ if not (csDesigning in ComponentState) then _}
end; {_ procedure TNMUDP.Loaded; _}

{*******************************************************************************************
Resolve IP Address of Remote Host
********************************************************************************************}

procedure TNMUDP.ResolveRemoteHost;
var
  BUF: array[0..127] of char;
  CTry: integer;
  Handled: boolean;
begin
  remoteaddress.sin_addr.S_addr := Inet_Addr(strpcopy(buf, FRemoteHost));
  if remoteaddress.sin_addr.S_addr = SOCKET_ERROR then
      {If given name not an IP address already}
    begin
      CTry := 0;
      repeat
        Wait_Flag := FALSE; {Reset flag indicating wait over}
         {Resolve IP address}
        wsaasyncgethostbyname(FSocketWindow, WM_ASYNCHRONOUSPROCESS, Buf, PChar(remotehostS), MAXGETHOSTSTRUCT);
        repeat
          Wait;
        until Wait_Flag or Canceled; {Till host name resolved, Timed out or cancelled}
         {Handle errors}
        if Canceled then
          raise UDPSockError.create(Cons_Msg_Lkp);
        if Succeed = FALSE then
          begin
            if CTry < 1 then
              begin
                CTry := CTry + 1;
                Handled := FALSE;
                if assigned(FOnInvalidHost) then FOnInvalidHost(Handled);
                if not handled then UDPSockError.create(Cons_Msg_Lkp);
              end {_ if CTry < 1 then _}
            else {_ NOT if CTry < 1 then _}  raise UDPSockError.create(Cons_Msg_Lkp);
          end {_ if Succeed = FALSE then _}
        else {_ NOT if Succeed = FALSE then _}
            {Fill up remote host information with retreived results}
          with RemoteAddress.sin_addr.S_un_b do
            begin
              s_b1 := remotehostS.h_addr_list^[0];
              s_b2 := remotehostS.h_addr_list^[1];
              s_b3 := remotehostS.h_addr_list^[2];
              s_b4 := remotehostS.h_addr_list^[3];
            end; {_ with RemoteAddress.sin_addr.S_un_b do _}
      until Succeed = true;
    end; {_ if remoteaddress.sin_addr.S_addr = SOCKET_ERROR then _}
end; {_ procedure TNMUDP.ResolveRemoteHost; _}

procedure TNMUDP.SendStream(DataStream: TStream);
var Ctry, i: integer;
  BUf: array[0..2047] of char;
  Handled: boolean;
begin
  CTry := 0;
  while DataStream.size = 0 do
    if CTry > 0 then raise Exception.create(Cons_Msg_InvStrm)
    else {_ NOT if CTry > 0 then raise Exception.create(Cons_Msg_InvStrm) _}
      if not assigned(FOnStreamInvalid) then raise Exception.create(Cons_Msg_InvStrm)
      else {_ NOT if not assigned(FOnStreamInvalid) then raise Exception.create(Cons_Msg_InvStrm) _}
        begin
          Handled := FALSE;
          FOnStreamInvalid(Handled, DataStream);
          if not Handled then raise Exception.create(Cons_Msg_InvStrm)
          else {_ NOT if not Handled then raise Exception.create(Cons_Msg_InvStrm) _}  CTry := CTry + 1;
        end; {_ NOT if not assigned(FOnStreamInvalid) then raise Exception.create(Cons_Msg_InvStrm) _}
  Canceled := FALSE; {Turn Canceled off}
  ResolveRemoteHost; {Resolve the IP address of remote host}
  if RemoteAddress.sin_addr.S_addr = 0 then
    raise UDPSockError.create(Cons_Err_Addr); {If Resolving failed raise exception}
  StatusMessage(Status_Basic, Cons_Msg_Data); {Inform status}
  RemoteAddress.sin_family := AF_INET; {Make connected true}
{$R-}
  RemoteAddress.sin_port := htons(FRemotePort); {If no proxy get port from Port property}
{$R+}
  i := SizeOf(RemoteAddress); {i := size of remoteaddress structure}
   {Connect to remote host}
  DataStream.position := 0;
  DataStream.ReadBuffer(Buf, DataStream.size);
  WinSock.SendTo(ThisSocket, Buf, DataStream.size, 0, RemoteAddress, i);
  if assigned(FOnDataSend) then FOnDataSend(self);
end; {_ procedure TNMUDP.SendStream(DataStream: TStream); _}

procedure TNMUDP.SendBuffer(Buff: array of char; length: integer);
var Ctry, i: integer;
  Handled: boolean;
begin
  CTry := 0;
  while length = 0 do
    if CTry > 0 then raise Exception.create(Cons_Err_Buffer)
    else {_ NOT if CTry > 0 then raise Exception.create(Cons_Err_Buffer) _}
      if not assigned(FOnBufferInvalid) then raise Exception.create(Cons_Err_Buffer)
      else {_ NOT if not assigned(FOnBufferInvalid) then raise Exception.create(Cons_Err_Buffer) _}
        begin
          Handled := FALSE;
          FOnBufferInvalid(Handled, Buff, length);
          if not Handled then raise Exception.create(Cons_Err_Buffer)
          else {_ NOT if not Handled then raise Exception.create(Cons_Err_Buffer) _}  CTry := CTry + 1;
        end; {_ NOT if not assigned(FOnBufferInvalid) then raise Exception.create(Cons_Err_Buffer) _}
  Canceled := FALSE; {Turn Canceled off}
  ResolveRemoteHost; {Resolve the IP address of remote host}
  if RemoteAddress.sin_addr.S_addr = 0 then
    raise UDPSockError.create(Cons_Err_Addr); {If Resolving failed raise exception}
  StatusMessage(Status_Basic, Cons_Msg_Data); {Inform status}
  RemoteAddress.sin_family := AF_INET; {Make connected true}
{$R-}
  RemoteAddress.sin_port := htons(FRemotePort); {If no proxy get port from Port property}
{$R+}
  i := SizeOf(RemoteAddress); {i := size of remoteaddress structure}
  WinSock.SendTo(ThisSocket, Buff, length, 0, RemoteAddress, i);
  if assigned(FOnDataSend) then FOnDataSend(self);
end; {_ procedure TNMUDP.SendBuffer(Buff: array of char; length: integer); _}
{*******************************************************************************************
Handle Power socket error
********************************************************************************************}

function TNMUDP.ErrorManager(ignore: word): string;
var
  slasterror: string;
begin
  StatusMessage(STATUS_TRACE, Cons_Msg_Echk); {Report Status}
  FLastErrorno := wsagetlasterror; {Set last error}
  if (FLastErrorno and ignore) <> ignore then
      {If the error is not the error to be ignored}
    begin
      slasterror := SocketErrorStr(FLastErrorno); {Get the description string for error}
      if assigned(fonerrorevent) then
         {If error handler present excecute it}
        FOnerrorEvent(Self, FLastErrorno, slasterror);
      raise UDPSockError.create(slasterror); {Raise exception}
    end; {_ if (FLastErrorno and ignore) <> ignore then _}
  result := slasterror; {return error string}
end; {_ function TNMUDP.ErrorManager(ignore: word): string; _}

{*******************************************************************************************
Return Error Message Corresponding To Error number
********************************************************************************************}

function TNMUDP.SocketErrorStr(ErrNo: word): string;
begin
  if ErrNo <> 0 then
      {If error exits}
    begin
      (*for x := 0 to 50 do                                {Get error string}
        if winsockmessage[x].errorcode = errno then
          Result := inttostr( winsockmessage[x].errorcode ) + ':' + winsockmessage[x].text; *)
      if Result = '' then {If not found say unknown error}
        Result := Cons_Msg_Eno + IntToStr(ErrNo);
    end; {_ if ErrNo <> 0 then _}
  StatusMessage(Status_DEBUG, Cons_Msg_ELkp + result); {Status message}
end; {_ function TNMUDP.SocketErrorStr(ErrNo: word): string; _}

{*******************************************************************************************
Output a Status message: depends on current Reporting Level
********************************************************************************************}

procedure TNMUDP.StatusMessage(Level: byte; value: string);
begin
  if level <= FReportLevel then
      {If level of error less than present report level}
    begin
      _status := value; {Set status to vale of error}
      if assigned(FOnStatus) then
        FOnStatus(self, _status); {If Status handler present excecute it}
    end; {_ if level <= FReportLevel then _}
end; {_ procedure TNMUDP.StatusMessage(Level: byte; value: string); _}

{*******************************************************************************************
Socket Message handler
********************************************************************************************}

procedure TNMUDP.WndProc(var message: TMessage);
begin
  if _ProcMsg then {If Processing of messages enabled}
    with message do
      if msg = WM_ASYNCHRONOUSPROCESS then
        begin
          if lparamLo = FD_Read then
            ProcessIncomingdata
          else {_ NOT if lparamLo = FD_Read then _}
            begin
              wait_flag := TRUE;
              if lparamhi > 0 then
                  {If no error}
                Succeed := FALSE {Succed flag not set}
              else {_ NOT if lparamhi > 0 then _}
                Succeed := TRUE;
            end; {_ NOT if lparamLo = FD_Read then _}
          SetEvent(EventHandle);
        end {_ if msg = WM_ASYNCHRONOUSPROCESS then _}
      else
        Result := DefWindowProc(FSocketWindow, Msg, wParam, lParam);
end; {_ procedure TNMUDP.WndProc(var message: TMessage); _}


procedure TNMUDP.ProcessIncomingdata;
var
  From: TSockAddr;
  i: integer;
  s1: string;
  p1: u_short;

begin
  i := sizeof(From);
  IBuffSize := Winsock.RecvFrom(ThisSocket, IBuff, 2048, 0, From, i);
  if assigned(FOnDataReceived) then
    begin
      s1 := format('%d.%d.%d.%d', [ord(From.sin_addr.S_un_b.S_b1), ord(From.sin_addr.S_un_b.S_b2), ord(From.sin_addr.S_un_b.S_b3), ord(From.sin_addr.S_un_b.S_b4)]);
      p1 := ntohs(From.sin_port);
      FOnDataReceived(self, IBuffSize, s1, p1);
    end; {_ if assigned(FOnDataReceived) then _}
end; {_ procedure TNMUDP.ProcessIncomingdata; _}

procedure TNMUDP.ReadStream(DataStream: TStream);

begin
  DataStream.WriteBuffer(IBuff, IBuffSize);
  DataStream.position := 0;
end; {_ procedure TNMUDP.ReadStream(DataStream: TStream); _}

procedure TNMUDP.Wait;
begin
  WaitforSync(EventHandle);
  ResetEvent(EventHandle);
end;

procedure TNMUDP.ReadBuffer(var Buff: array of char; var length: integer);

begin
  Move(IBuff, Buff, IBuffSize);
  length := IBuffSize;
end; {_ procedure TNMUDP.ReadBuffer(var Buff: array of char; var length: integer); _}


end.

