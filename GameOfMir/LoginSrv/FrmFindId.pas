unit FrmFindId;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Grids, IDDB,Grobal2;
type
  TFrmFindUserId=class(TForm)
    IdGrid: TStringGrid;
    Panel1: TPanel;
    EdFindId: TEdit;
    Label1: TLabel;
    BtnFindAll: TButton;
    Button1: TButton;
    BtnEdit: TButton;
    Button2: TButton;

    procedure FormCreate(Sender : TObject);
    procedure BtnFindAllClick(Sender : TObject);
    procedure Button1Click(Sender : TObject);
    procedure BtnEditClick(Sender : TObject);
    procedure Button2Click(Sender : TObject);
    procedure EdFindIdKeyPress(Sender: TObject; var Key: Char);
  private
    procedure RefChrGrid(nIndex:Integer;var DBRecord:TAccountDBRecord);
    { Private declarations }
  public
    { Public declarations }
  end ;

var
  FrmFindUserId: TFrmFindUserId;

implementation

uses EditUserInfo, LMain, MasSock, LSShare;



{$R *.DFM}
//00467AB4
procedure TFrmFindUserId.EdFindIdKeyPress(Sender: TObject; var Key: Char);
var
  sAccount:String;
  n08,nIndex:Integer;
  DBRecord:TAccountDBRecord;
begin
  if Key <> #13 then exit;
    
  sAccount:=Trim(EdFindId.Text);
  IdGrid.RowCount:=1;
  try
    if AccountDB.Open then begin
      n08:=AccountDB.Index(sAccount);
      if n08 >= 0 then begin
        nIndex:=AccountDB.Get(n08,DBRecord);
        if nIndex >= 0 then  RefChrGrid(-1,DBRecord);
      end;
    end;
  finally
    AccountDB.Close;
  end;
end;

procedure TFrmFindUserId.FormCreate(Sender : TObject);
begin

  IdGrid.RowCount:=2;
  IdGrid.Cells[0,0]:='帐号';
  IdGrid.Cells[1,0]:='密码';
  IdGrid.Cells[2,0]:='用户名称';
  IdGrid.Cells[3,0]:='身份证号';
  IdGrid.Cells[4,0]:='生日';
  IdGrid.Cells[5,0]:='问题一';
  IdGrid.Cells[6,0]:='答案一';
  IdGrid.Cells[7,0]:='问题二';
  IdGrid.Cells[8,0]:='答案二';
  IdGrid.Cells[9,0]:='电话';
  IdGrid.Cells[10,0]:='移动电话';
  IdGrid.Cells[11,0]:='备注一';
  IdGrid.Cells[12,0]:='备注二';
  IdGrid.Cells[13,0]:='创建时间';
  IdGrid.Cells[14,0]:='最后登录时间';
  IdGrid.Cells[15,0]:='电子邮箱';
end;
//0x00467BF8
procedure TFrmFindUserId.BtnFindAllClick(Sender : TObject);
var
  sAccount:String;
  AccountList:TStringList;
  i,nIndex:Integer;
  DBRecord:TAccountDBRecord;
begin
try
  IdGrid.RowCount:=1;
  sAccount:=Trim(EdFindId.Text);
  if sAccount = '' then exit;
  AccountList:=TStringList.Create;
  try
    if AccountDB.Open then begin
      if AccountDB.FindByName(sAccount,AccountList) > 0 then begin
        for i:= 0 to AccountList.Count - 1 do begin
          nIndex:=Integer(AccountList.Objects[i]);
          if AccountDB.GetBy(nIndex,DBRecord) then begin
            RefChrGrid(-1,DBRecord);
          end;
        end;
      end;
    end;
  finally
    AccountDB.Close;
  end;
  AccountList.Free;
except
  MainOutMessage('TFrmFindUserId.BtnFindAllClick');
end;
end;

procedure TFrmFindUserId.Button1Click(Sender : TObject);
begin
  FrmMasSoc.LoadServerAddr();
end;
//0x00467D84
procedure TFrmFindUserId.BtnEditClick(Sender : TObject);
var
  nRow,nIndex:Integer;
  sAccount:String;
  DBRecord:TAccountDBRecord;
  bo11,bo12:Boolean;
  Config  :pTConfig;  
ResourceString
  sEditAccount = 'ch2';

begin
  Config:=@g_Config;
  nRow:=IdGrid.Row;
  if nRow <= 0 then exit;
  sAccount:=IdGrid.Cells[0,nRow];
  if sAccount = '' then exit;
  bo11:=False;
  try
    if AccountDB.OpenEx then begin
      nIndex:=AccountDB.Index(sAccount);
      if nIndex >= 0 then
        if AccountDB.Get(nIndex,DBRecord) >= 0 then bo11:=True;
    end;
  finally
    AccountDB.Close;
  end;
  if FrmUserInfoEdit.sub_466AEC(DBRecord) then begin
    try
      if AccountDB.Open then begin
        nIndex:=AccountDB.Index(sAccount);
        if nIndex >= 0 then
          if AccountDB.Update(nIndex,DBRecord) then begin
            RefChrGrid(nRow,DBRecord);
            bo12:=True;
          end;
      end;        
    finally
      AccountDB.Close;
    end;
  end;
  if bo12 then begin //00467F34
   // WriteLogMsg(Config,sEditAccount,DBRecord.UserEntry,DBRecord.UserEntryAdd);
  end;
end;
//00467F94
procedure TFrmFindUserId.Button2Click(Sender : TObject);
var
  DBRecord:TAccountDBRecord;
  sAccount:String;
  nIndex:Integer;
  boMakeSuccess:Boolean;
  Config  :pTConfig;  
ResourceString
  sAddAccount      = 'ch2';
  sMakingIDSuccess = '创建帐号成功: %s';

begin
  Config:=@g_Config;
  FillChar(DBRecord,SizeOf(TAccountDBRecord),#0);
  boMakeSuccess:=False;
  if FrmUserInfoEdit.sub_466B10(True,DBRecord) and (DBRecord.UserEntry.sAccount <> '')then begin
    sAccount:=DBRecord.UserEntry.sAccount;
    DBRecord.Header.sAccount:=sAccount;
    try
      if AccountDB.Open then begin
        nIndex:=AccountDB.Index(sAccount);
        if nIndex < 0 then begin
          if AccountDB.Add(DBRecord) then boMakeSuccess:=True;
        end;
      end;
    finally
      AccountDB.Close;
    end;
  end;
  if boMakeSuccess then begin
    MainOutMessage(format(sMakingIDSuccess,[sAccount]));
   // WriteLogMsg(Config,sAddAccount,DBRecord.UserEntry,DBRecord.UserEntryAdd);
  end;
end;

procedure TFrmFindUserId.RefChrGrid(nIndex:Integer;var DBRecord:TAccountDBRecord);
var
  nRow:integer;
begin
try
  if nIndex <= 0 then begin
    IdGrid.RowCount:=IdGrid.RowCount + 1;
    IdGrid.FixedRows:=1;
    nRow:=IdGrid.RowCount - 1;
  end else begin
    nRow:=nIndex;
  end;
  IdGrid.Cells[0,nRow]:=DBRecord.UserEntry.sAccount;
  IdGrid.Cells[1,nRow]:=DBRecord.UserEntry.sPassword;
  IdGrid.Cells[2,nRow]:=DBRecord.UserEntry.sUserName;
  IdGrid.Cells[3,nRow]:=DBRecord.UserEntry.sSSNo;
  IdGrid.Cells[4,nRow]:=DBRecord.UserEntryAdd.sBirthDay;
  IdGrid.Cells[5,nRow]:=DBRecord.UserEntry.sQuiz;
  IdGrid.Cells[6,nRow]:=DBRecord.UserEntry.sAnswer;
  IdGrid.Cells[7,nRow]:=DBRecord.UserEntryAdd.sQuiz2;
  IdGrid.Cells[8,nRow]:=DBRecord.UserEntryAdd.sAnswer2;
  IdGrid.Cells[9,nRow]:=DBRecord.UserEntry.sPhone;
  IdGrid.Cells[10,nRow]:=DBRecord.UserEntryAdd.sMobilePhone;
  IdGrid.Cells[11,nRow]:=DBRecord.UserEntryAdd.sMemo;
  IdGrid.Cells[12,nRow]:=DBRecord.UserEntryAdd.sMemo2;
  IdGrid.Cells[13,nRow]:=DateTimeToStr(DBRecord.Header.CreateDate);
  IdGrid.Cells[14,nRow]:=DateTimeToStr(DBRecord.Header.UpdateDate);
  IdGrid.Cells[15,nRow]:=DBRecord.UserEntry.sEMail;
except

end;
end;

end.
