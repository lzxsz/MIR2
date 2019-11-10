unit IDSocCli;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, JSocket,Grobal2,DBShare,IniFiles;
type
  TFrmIDSoc=class(TForm)
    IDSocket: TClientSocket;
    Timer1: TTimer;
    KeepAliveTimer: TTimer;
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure Timer1Timer(Sender : TObject);
    procedure IDSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure IDSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure KeepAliveTimerTimer(Sender: TObject);
  private
     GlobaSessionList :TList;      //0x2D8
    m_sSockMsg   :String;  //0x2E4
     sIDAddr:String;
     nIDPort:Integer;
    procedure ProcessSocketMsg;
    procedure ProcessAddSession(sData:String);
    procedure ProcessDelSession(sData:String);
    procedure ProcessGetOnlineCount(sData:String);

    procedure SendKeepAlivePacket();
    { Private declarations }
  public
    procedure SendSocketMsg(wIdent: Word; sMsg: String);
    function CheckSession(sAccount, sIPaddr: String;
      nSessionID: Integer): Boolean;
    function CheckSessionLoadRcd(sAccount, sIPaddr: String;nSessionID: Integer;var boFoundSession:boolean): Boolean;
    function SetSessionSaveRcd(sAccount:String): Boolean;
    procedure SetGlobaSessionNoPlay(nSessionID:Integer);
    procedure SetGlobaSessionPlay(nSessionID: Integer);
    function  GetGlobaSessionStatus(nSessionID: Integer): Boolean;
    procedure CloseSession(sAccount: String; nSessionID: Integer); //关闭全局会话
    procedure OpenConnect();
    procedure CloseConnect();
    function GetSession(sAccount,sIPaddr:String):Boolean;
    { Public declarations }
  end ;

var
  FrmIDSoc: TFrmIDSoc;

implementation

uses HUtil32, UsrSoc;



{$R *.DFM}

procedure TFrmIDSoc.FormCreate(Sender : TObject);
//0x004A128C
var
  Conf:TIniFile;
begin
  Conf:=TIniFile.Create(sConfFileName);
  if Conf <> nil then begin
    sIDAddr:=Conf.ReadString('Server','IDSAddr',sIDServerAddr);
    nIDPort:=Conf.ReadInteger('Server','IDSPort',nIDServerPort);
    Conf.Free;
  end;
  GlobaSessionList:=TList.Create;
  m_sSockMsg:='';
end;

procedure TFrmIDSoc.FormDestroy(Sender : TObject);
//0x004A13C8
var
  i:Integer;
  GlobaSessionInfo:pTGlobaSessionInfo;
begin
  for I := 0 to GlobaSessionList.Count - 1 do begin
    GlobaSessionInfo:=GlobaSessionList.Items[i];
    Dispose(GlobaSessionInfo);
  end;
  GlobaSessionList.Free;
end;

procedure TFrmIDSoc.Timer1Timer(Sender : TObject);//0x004A18C8
begin
  if (IDSocket.Address <> '') and not (IDSocket.Active) then
    IDSocket.Active:=True;
end;

procedure TFrmIDSoc.IDSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);//004A183C
begin
  m_sSockMsg:=m_sSockMsg + Socket.ReceiveText;
  if Pos(')',m_sSockMsg) > 0 then begin
    ProcessSocketMsg();
  end;
end;
//004A1958
procedure TFrmIDSoc.ProcessSocketMsg();
var
  sScoketText :String;
  sData       :String;
  sCode       :String;
  sBody       :String;
  nIdent      :Integer;
begin
  sScoketText:=m_sSockMsg;
  while (Pos(')',sScoketText) > 0) do begin
    sScoketText:=ArrestStringEx(sScoketText,'(',')',sData);
    if sData = '' then break;
    sBody  := GetValidStr3(sData,sCode,['/']);
    nIdent := Str_ToInt(sCode,0);
    case nIdent of
      SS_OPENSESSION{100} :ProcessAddSession(sBody);
      SS_CLOSESESSION{101}:ProcessDelSession(sBody);
      SS_KEEPALIVE{104}   :ProcessGetOnlineCount(sBody);
    end;
  end;
  m_sSockMsg:=sScoketText;
end;

procedure TFrmIDSoc.SendSocketMsg(wIdent: Word; sMsg: String);
//004A1C1C
var
  sSendText:String;
ResourceString
  sFormatMsg = '(%d/%s)';
begin
  sSendText:=format(sFormatMsg,[wIdent,sMsg]);
  if IDSocket.Socket.Connected then
    IDSocket.Socket.SendText(sSendText);
end;
//004A1718
function TFrmIDSoc.CheckSession(sAccount, sIPaddr: String;
  nSessionID: Integer): Boolean;
var
  i:Integer;
  GlobaSessionInfo:pTGlobaSessionInfo;
begin
  g_CheckCode.dwThread0:=1001800;
  Result:=False;
  for i:=0 to GlobaSessionList.Count -1 do begin
    GlobaSessionInfo:=GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then begin
      //if (GlobaSessionInfo.sAccount = sAccount) and (GlobaSessionInfo.sIPaddr = sIPaddr) then begin
      if (GlobaSessionInfo.sAccount = sAccount) and (GlobaSessionInfo.nSessionID = nSessionID) then begin
        Result:=True;
        break;
      end;
    end;
  end;
  g_CheckCode.dwThread0:=1001801;
end;

function TFrmIDSoc.CheckSessionLoadRcd(sAccount, sIPaddr: String;nSessionID: Integer;var boFoundSession:boolean): Boolean;
var
  i:Integer;
  GlobaSessionInfo:pTGlobaSessionInfo;
begin
  g_CheckCode.dwThread0:=1001900;
  Result:=False;
  boFoundSession:=False;
  for i:=0 to GlobaSessionList.Count -1 do begin
    GlobaSessionInfo:=GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then begin
      //if (GlobaSessionInfo.sAccount = sAccount) and (GlobaSessionInfo.sIPaddr = sIPaddr) then begin
      if (GlobaSessionInfo.sAccount = sAccount) and (GlobaSessionInfo.nSessionID = nSessionID) then begin
        boFoundSession:=True;
        if not GlobaSessionInfo.boLoadRcd then begin
          GlobaSessionInfo.boLoadRcd:=True;
          Result:=True;
        end;
        break;
      end;
    end;
  end;
  g_CheckCode.dwThread0:=1001901;
end;

function TFrmIDSoc.SetSessionSaveRcd(sAccount:String): Boolean;
var
  i:Integer;
  GlobaSessionInfo:pTGlobaSessionInfo;
begin
  g_CheckCode.dwThread0:=1002500;
  Result:=False;
  for i:=0 to GlobaSessionList.Count -1 do begin
    GlobaSessionInfo:=GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then begin
      //if (GlobaSessionInfo.sAccount = sAccount) and (GlobaSessionInfo.sIPaddr = sIPaddr) then begin
      if (GlobaSessionInfo.sAccount = sAccount) then begin
        GlobaSessionInfo.boLoadRcd:=False;
        Result:=True;
      end;
    end;
  end;
  g_CheckCode.dwThread0:=1002501;
end;

//004A15E0
procedure TFrmIDSoc.SetGlobaSessionNoPlay(nSessionID: Integer);
var
  i:Integer;
  GlobaSessionInfo:pTGlobaSessionInfo;
begin
  g_CheckCode.dwThread0:=1002300;
  for i:=0 to GlobaSessionList.Count -1 do begin
    GlobaSessionInfo:=GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then begin
      if (GlobaSessionInfo.nSessionID = nSessionID) then begin
        GlobaSessionInfo.boStartPlay:=False;
        break;
      end;
    end;
  end;
  g_CheckCode.dwThread0:=1002301;
end;

//004A1644
procedure TFrmIDSoc.SetGlobaSessionPlay(nSessionID: Integer);
var
  i:Integer;
  GlobaSessionInfo:pTGlobaSessionInfo;
begin
  g_CheckCode.dwThread0:=1002400;
  for i:=0 to GlobaSessionList.Count -1 do begin
    GlobaSessionInfo:=GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then begin
      if (GlobaSessionInfo.nSessionID = nSessionID) then begin
        GlobaSessionInfo.boStartPlay:=True;
        break;
      end;
    end;
  end;
  g_CheckCode.dwThread0:=1002401;
end;
function TFrmIDSoc.GetGlobaSessionStatus(nSessionID: Integer):Boolean;//004A16A8
var
  i:Integer;
  GlobaSessionInfo:pTGlobaSessionInfo;
begin
  Result:=False;
  for i:=0 to GlobaSessionList.Count -1 do begin
    GlobaSessionInfo:=GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then begin
      if (GlobaSessionInfo.nSessionID = nSessionID) then begin
        Result:=GlobaSessionInfo.boStartPlay;
        break;
      end;
    end;
  end;
end;

procedure TFrmIDSoc.CloseSession(sAccount:String;nSessionID: Integer);//0x4A1500
var
  I                :Integer;
  GlobaSessionInfo :pTGlobaSessionInfo;
begin
  for I:=0 to GlobaSessionList.Count -1 do begin
    GlobaSessionInfo:=GlobaSessionList.Items[I];
    if GlobaSessionInfo <> nil then begin
      if (GlobaSessionInfo.nSessionID = nSessionID) then begin
        if GlobaSessionInfo.sAccount = sAccount then begin
          Dispose(GlobaSessionInfo);
          GlobaSessionList.Delete(I);
          break;
        end;
      end;
    end;
  end;
end;
procedure TFrmIDSoc.IDSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode:=0;
  Socket.Close;
end;



procedure TFrmIDSoc.ProcessAddSession(sData: String);
//004A1A80
var
  sAccount,s10,s14,s18,sIPaddr:String;
  GlobaSessionInfo:pTGlobaSessionInfo;
begin
  g_CheckCode.dwThread0:=1001600;
  //OutMainMessage('Add: ' + sData);
  sData:=GetValidStr3(sData,sAccount,['/']);
  sData:=GetValidStr3(sData,s10,['/']);
  sData:=GetValidStr3(sData,s14,['/']);
  sData:=GetValidStr3(sData,s18,['/']);
  sData:=GetValidStr3(sData,sIPaddr,['/']);
  New(GlobaSessionInfo);
  GlobaSessionInfo.sAccount:=sAccount;
  GlobaSessionInfo.sIPaddr:=sIPaddr;
  GlobaSessionInfo.nSessionID:=Str_ToInt(s10,0);
  GlobaSessionInfo.n24:=Str_ToInt(s14,0);
  GlobaSessionInfo.boStartPlay:=False;
  GlobaSessionInfo.boLoadRcd:=False;
  GlobaSessionInfo.dwAddTick:=GetTickCount();
  GlobaSessionInfo.dAddDate:=Now();
  GlobaSessionList.Add(GlobaSessionInfo);
  g_CheckCode.dwThread0:=1001601;
end;

procedure TFrmIDSoc.ProcessDelSession(sData: String);//004A1B84
var
  sAccount:String;
  i,nSessionID:Integer;
  GlobaSessionInfo:pTGlobaSessionInfo;
begin
  g_CheckCode.dwThread0:=1001700;
  //OutMainMessage('Del: ' + sData);
  sData:=GetValidStr3(sData,sAccount,['/']);
  nSessionID:=Str_ToInt(sData,0);
  for i:=0 to GlobaSessionList.Count -1 do begin
    GlobaSessionInfo:=GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then begin
      if (GlobaSessionInfo.nSessionID = nSessionID) and (GlobaSessionInfo.sAccount = sAccount) then begin
        Dispose(GlobaSessionInfo);
        GlobaSessionList.Delete(i);
        break;
      end;
    end;
  end;
  g_CheckCode.dwThread0:=1001701;
end;

procedure TFrmIDSoc.SendKeepAlivePacket;
begin
  if IDSocket.Socket.Connected then begin
    IDSocket.Socket.SendText('(' + IntToStr(SS_SERVERINFO) + '/' + sServerName + '/' + '99' + '/' + IntToStr(FrmUserSoc.GetUserCount) + ')');
  end;

  //(103/⒌L网络/0/0)
end;

procedure TFrmIDSoc.CloseConnect;
begin
  KeepAliveTimer.Enabled:=False;
  IDSocket.Active:=False;
end;

function TFrmIDSoc.GetSession(sAccount, sIPaddr: String): Boolean;
var
  i:Integer;
  GlobaSessionInfo:pTGlobaSessionInfo;
begin
  g_CheckCode.dwThread0:=1002200;
  Result:=False;
  for i:=0 to GlobaSessionList.Count -1 do begin
    GlobaSessionInfo:=GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then begin
      if (GlobaSessionInfo.sAccount = sAccount) and (GlobaSessionInfo.sIPaddr = sIPaddr) then begin
        Result:=True;
        break;
      end;
    end;
  end;
  g_CheckCode.dwThread0:=1002201;
end;

procedure TFrmIDSoc.OpenConnect;
begin
  KeepAliveTimer.Enabled:=True;
  IDSocket.Active:=False;
  IDSocket.Address:=sIDServerAddr;
  IDSocket.Port:=nIDServerPort;
  IDSocket.Active:=True;
end;

procedure TFrmIDSoc.KeepAliveTimerTimer(Sender: TObject);
begin
  SendKeepAlivePacket();
end;

procedure TFrmIDSoc.ProcessGetOnlineCount(sData: String);
begin

end;

end.
