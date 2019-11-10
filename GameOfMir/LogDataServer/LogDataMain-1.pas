unit LogDataMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls,NMUDP, ExtCtrls,IniFiles;
type
  TFrmLogData=class(TForm)
    NMUDP: TNMUDP;
    Label3: TLabel;
    Timer1: TTimer;
    Label1: TLabel;

    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure Timer1Timer(Sender : TObject);
    procedure WriteLogFile();
    function  IntToString(nInt:Integer):String;
    procedure NMUDPDataReceived(Sender: TComponent; NumberBytes: Integer;
      FromIP: String; Port: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    LogMsgList: TStringList;
    m_boRemoteClose:Boolean;

    { Private declarations }
  public
    procedure MyMessage(var MsgData:TWmCopyData);message WM_COPYDATA;

    { Public declarations }
  end;

var
  FrmLogData: TFrmLogData;


implementation

uses LDShare, Grobal2, HUtil32;

{$R *.DFM}

procedure TFrmLogData.NMUDPDataReceived(Sender: TComponent;
  NumberBytes: Integer; FromIP: String; Port: Integer);
var
  MStream:TMemoryStream;
  s8:String;
begin
try
  try
    MStream:=TMemoryStream.Create;
    NMUDP.ReadStream(MStream);
    setlength(s8,NumberBytes);
    MStream.Read(s8[1],NumberBytes);
    LogMsgList.Add(s8);
  finally
    MStream.Free;
  end;
except

end;
end;

procedure TFrmLogData.FormCreate(Sender : TObject);
var
  Conf:TIniFile;
  nX,nY:Integer;
begin
  g_dwGameCenterHandle:=Str_ToInt(ParamStr(1),0);
  nX:=Str_ToInt(ParamStr(2),-1);
  nY:=Str_ToInt(ParamStr(3),-1);
  if (nX >= 0) or (nY >= 0) then begin
    Left:=nX;
    Top:=nY;
  end;
  m_boRemoteClose:=False;
  SendGameCenterMsg(SG_FORMHANDLE,IntToStr(Self.Handle));
  SendGameCenterMsg(SG_STARTNOW,'正在启动日志服务器...');
  LogMsgList:=TStringList.Create;
  Conf:=TIniFile.Create('.\logdata.ini');
  if Conf <> nil then begin
    sBaseDir:=Conf.ReadString('Setup','BaseDir',sBaseDir);
    //sServerName:=Conf.ReadString('Setup','Caption',sServerName);
    sServerName:=Conf.ReadString('Setup','ServerName',sServerName);
    nServerPort:=Conf.ReadInteger('Setup','Port',nServerPort);
    Conf.Free;
  end;
  Caption:=sCaption + ' - ' + sServerName;
    Label4.Caption:=sBaseDir;

  NMUDP.LocalPort:=nServerPort;
  SendGameCenterMsg(SG_STARTOK,'日志服务器启动完成...');
end;

procedure TFrmLogData.FormDestroy(Sender : TObject);
begin
  LogMsgList.Free;
end;

procedure TFrmLogData.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if m_boRemoteClose then exit;
  if Application.MessageBox('是否确认退出服务器?',
                            '提示信息',
                            MB_YESNO + MB_ICONQUESTION ) = IDYES then begin
  end else CanClose:=False;
end;
procedure TFrmLogData.Timer1Timer(Sender : TObject);
begin
  WriteLogFile();
end;

procedure TFrmLogData.WriteLogFile();
var
  I: Integer;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  sLogDir,sLogFile:String;
  s2E8:String;
  F:TextFile;
begin

 // if LogMsgList.Count <= 0 then exit; //如果志信息列表的信息数为0，则退出
  
  DecodeDate(Date, Year, Month, Day);
  DecodeTime(Time, Hour, Min, Sec, MSec);
  sLogDir:= sBaseDir + IntToStr(Year) + '-' + IntToString(Month) + '-' + IntToString(Day);
  if not FileExists(sLogDir) then begin
    CreateDirectoryA(PChar(sLogDir),nil);
  end;
  sLogFile:=sLogDir + '\Log-' + IntToString(Hour) + 'h' + IntToString((Min div 10) * 2) + 'm.txt';
  Label4.Caption:=sLogFile;

  try
    AssignFile(F,sLogFile);
    if not FileExists(sLogFile) then Rewrite(F)
    else Append(F);
    for i:= 0 to LogMsgList.Count - 1 do begin
      Writeln(F,LogMsgList.Strings[i] + #9 + FormatDateTime('yyyy-mm-dd hh:mm:ss',Now));
      Flush(f)
    end;
    LogMsgList.Clear;
  finally
    CloseFile(F);
    
  end;
end;

function TFrmLogData.IntToString(nInt:Integer):String;
//0x0044304C
begin
  if nInt < 10 then Result:='0' + IntToStr(nInt)
  else Result:=IntToStr(nInt);
end;



procedure TFrmLogData.MyMessage(var MsgData: TWmCopyData);
var
  sData:String;
  ProgramType:TProgamType;
  wIdent:Word;
begin
  wIdent:=HiWord(MsgData.From);
//  ProgramType:=TProgamType(LoWord(MsgData.From));
  sData:=StrPas(MsgData.CopyDataStruct^.lpData);
  case wIdent of    //
    GS_QUIT: begin
      m_boRemoteClose:=True;
      Close();
    end;
    1: ;
    2: ;
    3: ;
  end;    // case
end;

end.
