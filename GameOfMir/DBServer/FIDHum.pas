unit FIDHum;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, DB, DBTables, Grids, Buttons,HumDB,Grobal2;
type
  TFrmIDHum=class(TForm)
    Query1: TQuery;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    EdChrName: TEdit;
    Label5: TLabel;
    BtnCreateChr: TSpeedButton;
    BtnEraseChr: TSpeedButton;
    BtnChrNameSearch: TSpeedButton;
    ChrGrid: TStringGrid;
    BtnSelAll: TSpeedButton;
    CbShowDelChr: TCheckBox;
    BtnDeleteChr: TSpeedButton;
    BtnRevival: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    BtnDeleteChrAllInfo: TSpeedButton;
    SpeedButton2: TSpeedButton;
    LabelCount: TLabel;
    SpeedButtonEditData: TSpeedButton;
    EditUserId: TEdit;
    lbl1: TLabel;
    BtnListUserIdAllChr: TSpeedButton;
    procedure FormCreate(Sender : TObject);
    procedure BtnChrNameSearchClick(Sender : TObject);
    procedure BtnSelAllClick(Sender : TObject);
    procedure BtnEraseChrClick(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure ChrGridClick(Sender : TObject);
    procedure ChrGridDblClick(Sender : TObject);
    procedure BtnDeleteChrClick(Sender : TObject);
    procedure BtnRevivalClick(Sender : TObject);
    procedure SpeedButton1Click(Sender : TObject);
    procedure BtnCreateChrClick(Sender : TObject);
    procedure BtnDeleteChrAllInfoClick(Sender : TObject);
    procedure SpeedButton2Click(Sender : TObject);
    procedure RefChrGrid(n08:Integer;HumDBRecord:THumInfo);
    procedure EdChrNameKeyPress(Sender: TObject; var Key: Char);
    //procedure EdUserIdKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButtonEditDataClick(Sender: TObject);
    procedure BtnListUserIdAllChrClick(Sender: TObject);
    procedure EditUserIdKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end ;

var
  FrmIDHum: TFrmIDHum;

implementation

uses HUtil32, MudUtil, CreateChr, FDBexpl, viewrcd, EditRcd;


{$R *.DFM}

procedure TFrmIDHum.FormCreate(Sender : TObject);
begin
  Edit1.Text:='';
  Edit2.Text:='';
  //IdGrid.Cells[0,0]:='登录帐号';
  //IdGrid.Cells[1,0]:='密码';
  //IdGrid.Cells[2,0]:='用户名称';
  //IdGrid.Cells[3,0]:='ResiRegi';
  //IdGrid.Cells[4,0]:='Tran';
  //IdGrid.Cells[5,0]:='Secretwd';
  //IdGrid.Cells[6,0]:='Adress(cont)';
  //IdGrid.Cells[7,0]:='备注';

  ChrGrid.Cells[0,0]:='索引号';
  ChrGrid.Cells[1,0]:='人物名称';
  ChrGrid.Cells[2,0]:='登录帐号';
  ChrGrid.Cells[3,0]:='是否禁用';
  ChrGrid.Cells[4,0]:='禁用时间';
  ChrGrid.Cells[5,0]:='操作计数';
  ChrGrid.Cells[6,0]:='选择编号';

end;

{
procedure TFrmIDHum.EdUserIdKeyPress(Sender: TObject; var Key: Char);
//0x0049FF58
var
  sAccount:String;
  ChrList:TStringList;
  i,nIndex:Integer;
  HumDBRecord:THumInfo;
begin
  if Key = #13 then begin
    Key:=#0;
    sAccount:=EdUserId.Text;
    ChrGrid.RowCount:=1;
    if sAccount <> '' then begin
      ChrList:=TStringList.Create;
      try
        if HumChrDB.OpenEx then begin
          HumChrDB.FindByAccount(sAccount,ChrList);
          for i:=0 to ChrList.Count -1 do begin
            nIndex:=pTQuickID(ChrList.Objects[i]).nIndex;
            if nIndex >= 0 then begin
              HumChrDB.GetBy(nIndex,HumDBRecord);
              if CbShowDelChr.Checked then RefChrGrid(nIndex,HumDBRecord)
              else if not HumDBRecord.boDeleted then
                RefChrGrid(nIndex,HumDBRecord);
            end;
          end;
        end;
      finally
        HumChrDB.Close;
      end;
      ChrList.Free;
    end;
  end;
end;
}

//帐号输入框回车键事件
procedure TFrmIDHum.EditUserIdKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key:=#0;
    BtnListUserIdAllChrClick(Sender);
  end;
end;

//列出登录帐号的所有人物
procedure TFrmIDHum.BtnListUserIdAllChrClick(Sender: TObject);
var
  sAccount:String;
  ChrList:TStringList;
  i,nIndex:Integer;
  HumDBRecord:THumInfo;
begin
      sAccount:=EditUserId.Text;
      ChrGrid.RowCount:=1;
      if sAccount <> '' then begin
        ChrList:=TStringList.Create;
        try
          if HumChrDB.OpenEx then begin
            HumChrDB.FindByAccount(sAccount,ChrList);
            for i:=0 to ChrList.Count -1 do begin
              nIndex:=pTQuickID(ChrList.Objects[i]).nIndex;
              if nIndex >= 0 then begin
                HumChrDB.GetBy(nIndex,HumDBRecord);
                if CbShowDelChr.Checked then RefChrGrid(nIndex,HumDBRecord)
                else if not HumDBRecord.boDeleted then
                  RefChrGrid(nIndex,HumDBRecord);
              end;
            end;
          end;
        finally
          HumChrDB.Close;
        end;
        ChrList.Free;
      end;
end;


procedure TFrmIDHum.EdChrNameKeyPress(Sender: TObject; var Key: Char);
//0x004A025C
begin
  if Key = #13 then begin
    Key:=#0;
    BtnChrNameSearchClick(Sender);
  end;
end;

//查找
procedure TFrmIDHum.BtnChrNameSearchClick(Sender : TObject);
var
  s64:String;
  n08,nIndex:Integer;
  HumDBRecord:THumInfo;
begin
  s64:=EdChrName.Text;
  ChrGrid.RowCount:=1;
  if Trim(s64) ='' then exit;  //名字不能为空                   
  
  try
    if HumChrDB.OpenEx then begin
      n08:=HumChrDB.Index(s64);
      if n08 >= 0 then begin
        nIndex:=HumChrDB.Get(n08,HumDBRecord);
        if (nIndex >= 0) then begin
          if CbShowDelChr.Checked then RefChrGrid(nIndex,HumDBRecord)
          else if not HumDBRecord.boDeleted then
            RefChrGrid(nIndex,HumDBRecord);
        end;
      end;
    end;
  finally
    HumChrDB.Close;
  end;
end;

procedure TFrmIDHum.BtnSelAllClick(Sender : TObject);
var
  sChrName:String;
  ChrList:TStringList;
  I,nIndex:Integer;
  HumDBRecord:THumInfo;
begin
  sChrName:=EdChrName.Text;
  ChrGrid.RowCount:=1;
  ChrList:=TStringList.Create;
  try
    if HumChrDB.OpenEx then begin
      if HumChrDB.FindByName(sChrName,ChrList) > 0 then begin
        for I:= 0 to ChrList.Count - 1 do begin
          nIndex:=Integer(ChrList.Objects[I]);
          if HumChrDB.GetBy(nIndex,HumDBRecord) then begin
            if CbShowDelChr.Checked then RefChrGrid(nIndex,HumDBRecord)
            else if not HumDBRecord.boDeleted then
              RefChrGrid(nIndex,HumDBRecord);
          end;
        end;
      end;
    end;
  finally
    HumChrDB.Close;
  end;
  ChrList.Free;
end;

//删除人物，消除角色数据
procedure TFrmIDHum.BtnEraseChrClick(Sender : TObject);//004A04DC
var
  nIndex:Integer;
  sChrName:String;
begin
  sChrName:=EdChrName.Text;
  if sChrName = '' then exit;
  if MessageDlg('是否确认删除人物 ' + sChrName + ' ？',mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumChrDB.Open then begin
           HumChrDB.Delete(sChrName);
           MessageDlg(sChrName + ' 人物已删除',mtWarning, [mbYes], 0);
      end;
    finally
      HumChrDB.Close;
    end;
  end;
end;

procedure TFrmIDHum.FormShow(Sender : TObject);
begin
  EdChrName.SetFocus;
end;

procedure TFrmIDHum.ChrGridClick(Sender : TObject);
var
  nRow:Integer;
begin
  nRow:=ChrGrid.Row;
  if nRow < 1 then exit;
  if ChrGrid.RowCount - 1 < nRow then exit;
  EdChrName.Text:=ChrGrid.Cells[1,nRow];
end;

procedure TFrmIDHum.ChrGridDblClick(Sender : TObject);//0x004A08C0
var
  n8,nC:Integer;
  s10:String;
  ChrRecord:THumDataInfo;
begin
  s10:='';
  n8:=ChrGrid.Row;

  if (n8 >= 1) and (ChrGrid.RowCount - 1 >= n8) then
    s10:= ChrGrid.Cells[1,n8];

  try
    if HumDataDB.OpenEx then begin
      nC:=HumDataDB.Index(s10);
      if nC >= 0 then begin
        if HumDataDB.Get(nC,ChrRecord) >= 0 then begin
          FrmFDBViewer.n2F8:=nC;
          FrmFDBViewer.s2FC:=s10;
          FrmFDBViewer.ChrRecord:=ChrRecord;
          FrmFDBViewer.Show;
          FrmFDBViewer.ShowHumData;
        end;
      end;
    end;
  finally
     HumDataDB.Close;
  end;
end;

//禁用人物，非消除数据
procedure TFrmIDHum.BtnDeleteChrClick(Sender : TObject);
var
  sChrName:String;
  nIndex:Integer;
  HumRecord:THumInfo;
begin
  sChrName:=EdChrName.Text;
  if sChrName = '' then exit;
  if MessageDlg('是否确认禁用人物 ' + sChrName + ' ？',mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumChrDB.Open then begin
        nIndex:=HumChrDB.Index(sChrName);
        if nIndex >= 0 then begin
          HumChrDB.Get(nIndex,HumRecord);
          HumRecord.boDeleted:=True;
          HumRecord.dModDate:=Now();
          Inc(HumRecord.btCount);
          HumChrDB.Update(nIndex,HumRecord);
        end else begin
          MessageDlg(sChrName + ' 人物不存在',mtWarning, [mbYes], 0);
        end;
      end;
    finally
      HumChrDB.Close;
    end;
  end;
end;

//启用人物
procedure TFrmIDHum.BtnRevivalClick(Sender : TObject);
//0x004A0D28
var
  sChrName:String;
  nIndex:Integer;
  HumRecord:THumInfo;
begin
  sChrName:=EdChrName.Text;
  if sChrName = '' then exit;
  if MessageDlg('是否确认启用人物 ' + sChrName + ' ？',mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumChrDB.Open then begin
        nIndex:=HumChrDB.Index(sChrName);
        if nIndex >= 0 then begin
          HumChrDB.Get(nIndex,HumRecord);
          HumRecord.boDeleted:=False;
          Inc(HumRecord.btCount);
          HumChrDB.Update(nIndex,HumRecord);
        end else begin
          MessageDlg(sChrName + ' 人物不存在',mtWarning, [mbYes], 0);
        end;

      end;
    finally
      HumChrDB.Close;
    end;
  end;
end;

procedure TFrmIDHum.SpeedButton1Click(Sender : TObject);
begin
  FrmFDBExplore.Show;
end;

//创建人物角色
procedure TFrmIDHum.BtnCreateChrClick(Sender : TObject);
var
  nCheckCode:Integer;
  HumRecord:THumInfo;
begin
  if not FrmCreateChr.IncputChrInfo then exit;

  FillChar(HumRecord,SizeOf(THumInfo),#0);
  nCheckCode:=0;
  try
    if HumChrDB.Open then begin
      if HumChrDB.ChrCountOfAccount(FrmCreateChr.sUserId) < 2 then begin //帐号字符长度必需大于2

        HumRecord.sChrName         :=FrmCreateChr.sChrName;
        HumRecord.sAccount         :=FrmCreateChr.sUserId;
        HumRecord.boDeleted        :=False;                                                                 
        HumRecord.btCount          :=0;

        HumRecord.Header.nSelectID :=FrmCreateChr.nSelectID;
        HumRecord.Header.sName     :=FrmCreateChr.sChrName;
        HumRecord.Header.sAccount  :=FrmCreateChr.sUserId;
        
        if HumRecord.Header.sName <> '' then begin
          if not HumChrDB.Add(HumRecord) then nCheckCode:=2;
        end;          
      end else nCheckCode:=3;
    end;
  finally
    HumChrDB.Close;
  end;
  if nCheckCode = 0 then ShowMessage('人物创建成功')
  else ShowMessage('人物创建失败！！！')
end;

//删除人物及人物数据 （消除数据）
procedure TFrmIDHum.BtnDeleteChrAllInfoClick(Sender : TObject);//0x004A0610
var
  sChrName:String;
  nIndex:Integer;
begin
  sChrName:=EdChrName.Text;
  if sChrName = '' then exit;
  if MessageDlg('是否确认删除人物 ' + sChrName + ' 及人物数据？',mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin

    try
      if HumChrDB.Open then begin
        HumChrDB.Delete(sChrName);  //删除人物名称
      end;
    finally
      HumChrDB.Close;
    end;
    
    try
      if HumDataDB.Open then begin
         HumDataDB.Delete(sChrName);   //删除人物条目
        end;
    finally
      HumDataDB.Close;
    end;
     MessageDlg(sChrName + ' 人物及数据已删除',mtWarning, [mbYes], 0);

  end;
end;


procedure TFrmIDHum.SpeedButton2Click(Sender : TObject);//0x004A0B64
var
  nIndex:Integer;
  HumRecord:THumInfo;
  nRow:Integer;
begin
  nRow:=ChrGrid.Row;
  if nRow < 1 then exit;
  if ChrGrid.RowCount - 1 < nRow then exit;
  nIndex:=Str_ToInt(ChrGrid.Cells[0,nRow],0);
  if MessageDlg('是否确认禁用记录 ' + IntToStr(nIndex) + ' ？',mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumChrDB.Open then begin
        if HumChrDB.GetBy(nIndex,HumRecord) then begin
          HumRecord.boDeleted :=True;
          HumRecord.dModDate  :=Now();
          Inc(HumRecord.btCount);
          HumChrDB.UpdateBy(nIndex,HumRecord);
        end;
      end;
    finally
      HumChrDB.Close;
    end;
  end;
end;

procedure TFrmIDHum.RefChrGrid(n08:Integer;HumDBRecord:THumInfo);//0x004A00C4
var
  nRowCount:Integer;
begin
  ChrGrid.RowCount:=ChrGrid.RowCount + 1;
  ChrGrid.FixedRows:=1;
  nRowCount:=ChrGrid.RowCount - 1;
  ChrGrid.Cells[0,nRowCount]:=IntToStr(n08);
  ChrGrid.Cells[1,nRowCount]:=HumDBRecord.sChrName;
  ChrGrid.Cells[2,nRowCount]:=HumDBRecord.sAccount;
  ChrGrid.Cells[3,nRowCount]:=BoolToStr(HumDBRecord.boDeleted);
  if HumDBRecord.boDeleted then
    ChrGrid.Cells[4,nRowCount]:=DateTimeToStr(HumDBRecord.dModDate)
  else ChrGrid.Cells[4,nRowCount]:='';

  ChrGrid.Cells[5,nRowCount]:=IntToStr(HumDBRecord.btCount);
  ChrGrid.Cells[6,nRowCount]:=IntToStr(HumDBRecord.Header.nSelectID);
  LabelCount.Caption:=IntToStr(ChrGrid.RowCount - 1);
end;

procedure TFrmIDHum.SpeedButtonEditDataClick(Sender: TObject);
var
  nRow,nIdx:Integer;
  sName:String;
  ChrRecord:THumDataInfo;
begin
  sName:='';
  nRow:=ChrGrid.Row;

  if (nRow >= 1) and (ChrGrid.RowCount - 1 >= nRow) then
    sName:= ChrGrid.Cells[1,nRow];
  if sName = '' then exit;
    
  try
    if HumDataDB.OpenEx then begin
      nIdx:=HumDataDB.Index(sName);
      if nIdx >= 0 then begin
        if HumDataDB.Get(nIdx,ChrRecord) >= 0 then begin
          frmEditRcd.m_nIdx:=nIdx;
          frmEditRcd.m_ChrRcd:=ChrRecord;
        end;
      end;
    end;
  finally
     HumDataDB.Close;
  end;
  frmEditRcd.Open;
end;

end.
