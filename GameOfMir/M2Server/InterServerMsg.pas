unit InterServerMsg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JSocket, ObjBase;

type
  TServerMsgInfo = record
    Socket: TCustomWinSocket;
    s2E0: string;
  end;
  pTServerMsgInfo = ^TServerMsgInfo;
  TFrmSrvMsg = class(TForm)
    MsgServer: TServerSocket;
    procedure MsgServerClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure MsgServerClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure MsgServerClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure MsgServerClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    PlayObject: TPlayObject;
    SrvArray: array[0..9] of TServerMsgInfo;
    procedure DecodeSocStr;
    procedure MsgGetUserServerChange;
    procedure SendSocket(Socket: TCustomWinSocket; sMsg: string);
    { Private declarations }
  public
    constructor Create();
    destructor Destroy; override;
    procedure SendSocketMsg(sMsg: string);
    procedure StartMsgServer();
    procedure Run();
    { Public declarations }
  end;

var
  FrmSrvMsg: TFrmSrvMsg;

implementation

uses M2Share, Grobal2;

{$R *.dfm}

{ TFrmSrvMsg }

procedure TFrmSrvMsg.Run; //004975C8
begin
{$IF (DEBUG = 0) and (SoftVersion <> VERDEMO)}
  if IsDebuggerPresent then
    Application.Terminate;
{$IFEND}
end;

procedure TFrmSrvMsg.StartMsgServer; //004966B0
resourcestring
  sExceptionMsg = '[Exception] TFrmSrvMsg::StartMsgServer';
begin
  try
    MsgServer.Active := False;
    MsgServer.Address := g_Config.sMsgSrvAddr;
    MsgServer.Port := g_Config.nMsgSrvPort;
    MsgServer.Active := True;
  except
    on E: Exception do
    begin
      MainOutMessage(sExceptionMsg);
      MainOutMessage(E.Message);
    end;
  end;
end;
procedure TFrmSrvMsg.DecodeSocStr; //00496A0C
begin

end;
procedure TFrmSrvMsg.MsgGetUserServerChange; //00496D10
begin

end;

procedure TFrmSrvMsg.SendSocket(Socket: TCustomWinSocket; sMsg: string); //0049685C
begin
  if Socket.Connected then
    Socket.SendText('(' + sMsg + ')');
end;

procedure TFrmSrvMsg.SendSocketMsg(sMsg: string);
var
  i: Integer;
  ServerMsgInfo: pTServerMsgInfo;
begin
  for i := Low(SrvArray) to High(SrvArray) do
  begin
    ServerMsgInfo := @SrvArray[i];
    if ServerMsgInfo.Socket <> nil then
      SendSocket(ServerMsgInfo.Socket, sMsg);
  end;
end;

constructor TFrmSrvMsg.Create;
begin
  FillChar(SrvArray, SizeOf(SrvArray), 0);
  PlayObject := TPlayObject.Create;
end;

destructor TFrmSrvMsg.Destroy;
begin
  PlayObject.Free;
  inherited;
end;

procedure TFrmSrvMsg.MsgServerClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i: Integer;
  ServerMsgInfo: pTServerMsgInfo;
begin
  for i := Low(SrvArray) to High(SrvArray) do
  begin
    ServerMsgInfo := @SrvArray[i];
    if ServerMsgInfo.Socket = nil then
    begin
      ServerMsgInfo.Socket := Socket;
      ServerMsgInfo.s2E0 := '';
      Socket.nIndex := i;
    end;
  end;
end;

procedure TFrmSrvMsg.MsgServerClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i: Integer;
  ServerMsgInfo: pTServerMsgInfo;
begin
  for i := Low(SrvArray) to High(SrvArray) do
  begin
    ServerMsgInfo := @SrvArray[i];
    if ServerMsgInfo.Socket = Socket then
    begin
      ServerMsgInfo.Socket := nil;
      ServerMsgInfo.s2E0 := '';
    end;
  end;
end;

procedure TFrmSrvMsg.MsgServerClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFrmSrvMsg.MsgServerClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  nC: Integer;
begin
  nC := Socket.nIndex;
  if (nC <= High(SrvArray)) and (SrvArray[nC].Socket = Socket) then
  begin
    SrvArray[nC].s2E0 := SrvArray[nC].s2E0 + Socket.ReceiveText;
  end;

end;

end.

