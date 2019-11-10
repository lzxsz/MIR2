unit IP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, StrUtils, DateUtils, shellapi, untTQQWry;

type
  TFormIP = class(TForm)
    Memo1: TMemo;
    Edit1: TEdit;
    Buttonip: TButton;
    Label1: TLabel;
    procedure ButtonipClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState; x,
      y: Integer);
    procedure Label1MouseLeave(Sender: TObject);
  private
    QQWry: TQQWry;
{ Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  FormIP: TFormIP;

implementation

{$R *.dfm}


procedure TFormIP.Open;

begin
  TFormIP.Create(Owner);
  ShowModal;
end;


procedure TFormIP.ButtonipClick(Sender: TObject);
var

  slIPData: TStringList;
  IPRecordID: int64;
  StartIPDataID, EndIPDataID: int64;
  TimeCounter: dword;
begin

//    if Edit1.Text = '' then begin
//      Application.MessageBox('输入的IP地址格式不正确！！！', '错误信息', MB_OK + MB_ICONERROR);
//     Exit;
//    end;
  if FileExists('.\QQWry.dat') then
  begin
  end else
  begin
    Memo1.Lines.Add('IP数据库文件<QQWry.dat>未找到，无法进行查询！');
  end;



 //Screen.Cursor:=crHourglass;
 //IP地址->地址信息
  begin
    try
      QQWry := TQQWry.Create(Edit1.Text);
      IPRecordID := QQWry.GetIPDataID(Edit1.Text);
      slIPData := TStringList.Create;
      QQWry.GetIPDataByIPRecordID(IPRecordID, slIPData);
      QQWry.Destroy;
      Memo1.Lines.Add(Format('ID: %d IP: %s - %s 地区: %s 网络: %s',
        [IPRecordID, slIPData[0], slIPData[1], slIPData[2], slIPData[3]]));
      slIPData.Free;
    except
      on E: Exception do
      begin
  //msgbox(E.Message, OKOnly + Critical, '错误');

        Application.MessageBox('输入的IP地址格式不正确！！！', '错误信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    Exit;
  end;
end;
procedure TFormIP.Label1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'Open', PChar('http://update.cz88.net/soft/qqwry.rar'), nil, nil, sw_ShowNormal);
end;

procedure TFormIP.Label1MouseMove(Sender: TObject; Shift: TShiftState; x,
  y: Integer);
begin
  Label1.Font.Color := clRed;

end;

procedure TFormIP.Label1MouseLeave(Sender: TObject);
begin
  Label1.Font.Color := clBlue;
end;

end.
