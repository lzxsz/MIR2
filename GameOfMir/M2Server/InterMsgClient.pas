unit InterMsgClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JSocket;

type
  TFrmMsgClient = class(TForm)
    MsgClient: TClientSocket;
    procedure MsgClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure MsgClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure MsgClientRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    dw2D4Tick: LongWord;
    sRecvMsg: string; //0x2D8
    procedure DecodeSocStr;
    { Private declarations }
  public
    procedure SendSocket(sMsg: string);
    procedure ConnectMsgServer();
    procedure Run();
    { Public declarations }
  end;

var
  FrmMsgClient: TFrmMsgClient;

implementation

uses M2Share, HUtil32, EDcode, Grobal2;

{$R *.dfm}

{ TFrmMsgClient }

procedure TFrmMsgClient.ConnectMsgServer; //00495E68
begin
  MsgClient.Active := False;
  MsgClient.Address := g_Config.sMsgSrvAddr;
  MsgClient.Port := g_Config.nMsgSrvPort;
  dw2D4Tick := GetTickCount();
end;

procedure TFrmMsgClient.Run; //00496360
begin
  if MsgClient.Socket.Connected then
  begin
    DecodeSocStr();
  end else
  begin
    if GetTickCount - dw2D4Tick > 20 * 1000 then
    begin
      dw2D4Tick := GetTickCount();
      MsgClient.Active := True;
    end;
  end;
{$IF (DEBUG = 0) and (SoftVersion <> VERDEMO)}
  if IsDebuggerPresent then
    Application.Terminate;
{$IFEND}
end;
procedure TFrmMsgClient.DecodeSocStr; //00496020
var
  sData, SC, s10, s14, s18: string;
  n1C, n20: Integer;
resourcestring
  sExceptionMsg = '[Exception] FrmIdSoc::DecodeSocStr';
begin
  try
    if Pos(')', sRecvMsg) <= 0 then Exit;
    sData := sRecvMsg;
    sRecvMsg := '';
    while (True) do
    begin
      sData := ArrestStringEx(sData, '(', ')', SC);
      if SC = '' then Break;
      s14 := GetValidStr3(SC, s10, ['/']);
      s14 := GetValidStr3(s14, s18, ['/']);
      n1C := Str_ToInt(s10, 0);
      n20 := Str_ToInt(DeCodeString(s18), -1);
      case n1C of //
        SS_200: ;
        SS_201: ;
        SS_202: ;
        SS_WHISPER: ;
        SS_204: ;
        SS_205: ;
        SS_206: ;
        SS_207: ;
        SS_208: ;
        SS_209: ;
        SS_210: ;
        SS_211: ;
        SS_212: ;
        SS_213: ;
        SS_214: ;
      end;
      if Pos(')', sData) <= 0 then Break;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

procedure TFrmMsgClient.SendSocket(sMsg: string); //00495F74
begin
  if MsgClient.Socket.Connected then
    MsgClient.Socket.SendText('(' + sMsg + ')');
end;
procedure TFrmMsgClient.MsgClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  sRecvMsg := '';
end;

procedure TFrmMsgClient.MsgClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFrmMsgClient.MsgClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  sRecvMsg := sRecvMsg + Socket.ReceiveText;
end;

end.
