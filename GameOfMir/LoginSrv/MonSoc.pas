unit MonSoc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, JSocket;
type
  TFrmMonSoc=class(TForm)
    MonSocket: TServerSocket;
    MonTimer: TTimer;
    procedure FormCreate(Sender : TObject);
    procedure MonTimerTimer(Sender : TObject);
    procedure MonSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end ;

var
  FrmMonSoc: TFrmMonSoc;

implementation

uses MasSock, LSShare;

{$R *.DFM}

procedure TFrmMonSoc.FormCreate(Sender : TObject);
var
  Config  :pTConfig;
begin
  Config:=@g_Config;
  MonSocket.Active:=False;
  MonSocket.Address:=Config.sMonAddr;
  MonSocket.Port:=Config.nMonPort;
  MonSocket.Active:=True;
end;

procedure TFrmMonSoc.MonTimerTimer(Sender : TObject);
var
  I: Integer;
  nC:Integer;
  MsgServer:pTMsgServerInfo;
  sServerName:String;
  sMsg:String;
begin
  sMsg:='';
  nC:=FrmMasSoc.m_ServerList.Count;
  for I := 0 to FrmMasSoc.m_ServerList.Count - 1 do begin
    MsgServer:=FrmMasSoc.m_ServerList.Items[i];
    sServerName:=MsgServer.sServerName;
    if sServerName <> '' then begin
      sMsg:=sMsg + sServerName + '/' + IntToStr(MsgServer.nServerIndex) + '/' + IntToStr(MsgServer.nOnlineCount) + '/';
      if (GetTickCount - MsgServer.dwKeepAliveTick) < 30000 then sMsg:=sMsg + 'Õý³£ ;'
      else  sMsg:=sMsg + '³¬Ê± ;';
    end else sMsg:='-/-/-/-;';
  end;
  for I := 0 to MonSocket.Socket.ActiveConnections - 1 do begin
    MonSocket.Socket.Connections[i].SendText(IntToStr(nC) + ';' + sMsg);
  end;
end;

procedure TFrmMonSoc.MonSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode:=0;
  Socket.Close;
end;

end.