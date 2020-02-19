unit EditRcd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Grobal2, ComCtrls, StdCtrls, Spin;

type
  TfrmEditRcd = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditChrName: TEdit;
    Label2: TLabel;
    EditAccount: TEdit;
    Label3: TLabel;
    EditPassword: TEdit;

//取消结婚、师徒功能
//    Label4: TLabel;
//    EditDearName: TEdit;
//    Label5: TLabel;
//    EditMasterName: TEdit;

    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    EditIdx: TEdit;
    Label12: TLabel;
    EditCurMap: TEdit;
    Label13: TLabel;
    EditCurX: TSpinEdit;
    EditCurY: TSpinEdit;
    Label14: TLabel;
    Label15: TLabel;
    EditHomeMap: TEdit;
    EditHomeX: TSpinEdit;
    EditHomeY: TSpinEdit;
    EditLevel: TSpinEdit;
    EditGold: TSpinEdit;
    EditGameGold: TSpinEdit;
    EditGamePoint: TSpinEdit;
    Label16: TLabel;
    EditCreditPoint: TSpinEdit;
    Label10: TLabel;
    EditPayPoint: TSpinEdit;
    Label17: TLabel;
    EditPKPoint: TSpinEdit;
    Label18: TLabel;
    EditContribution: TSpinEdit;
    GroupBox3: TGroupBox;
    ListViewMagic: TListView;
    GroupBox4: TGroupBox;
    ListViewUserItem: TListView;
    GroupBox5: TGroupBox;
    ListViewStorage: TListView;
    ButtonSaveData: TButton;
    ButtonExportData: TButton;
    ButtonImportData: TButton;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;

//取消结婚、师徒功能
//    CheckBoxIsMaster: TCheckBox;

    procedure ButtonExportDataClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditPasswordChange(Sender: TObject);
   private
    m_boOpened:Boolean;
    procedure RefShow();
    procedure RefShowRcd();
    procedure RefShowMagic();
    procedure RefShowUserItem();
    procedure RefShowStorage();
    procedure ProcessSaveRcdToFile();
    procedure ProcessLoadRcdformFile();
    procedure ProcessSaveRcd();
    { Private declarations }
  public
    m_ChrRcd:THumDataInfo;
    m_nIdx  :Integer;
    procedure Open();
    { Public declarations }
  end;

var
  frmEditRcd: TfrmEditRcd;

implementation

uses HumDB;

{$R *.dfm}

{ TfrmEditRcd }


procedure TfrmEditRcd.FormCreate(Sender: TObject);
begin
  //
end;

procedure TfrmEditRcd.RefShowRcd;
begin
  EditIdx.Text        :=IntToStr(m_nIdx);
  EditChrName.Text    :=m_ChrRcd.Data.sChrName;
  EditAccount.Text    :=m_ChrRcd.Data.sAccount;
  EditPassword.Text   :=m_ChrRcd.Data.sStoragePwd;

//  EditDearName.Text   :=m_ChrRcd.Data.sDearName;
//  EditMasterName.Text :=m_ChrRcd.Data.sMasterName;
//  CheckBoxIsMaster.Checked:=m_ChrRcd.Data.boMaster;

  EditCurMap.Text     :=m_ChrRcd.Data.sCurMap;
  EditCurX.Value      :=m_ChrRcd.Data.wCurX;
  EditCurY.Value      :=m_ChrRcd.Data.wCurY;

  EditHomeMap.Text    :=m_ChrRcd.Data.sHomeMap;
  EditHomeX.Value     :=m_ChrRcd.Data.wHomeX;
  EditHomeY.Value     :=m_ChrRcd.Data.wHomeY;

  EditLevel.Value     :=m_ChrRcd.Data.Abil.Level;
  EditGold.Value      :=m_ChrRcd.Data.nGold;
  EditGameGold.Value  :=m_ChrRcd.Data.nGameGold;
  EditGamePoint.Value :=m_ChrRcd.Data.nGamePoint;
  EditPayPoint.Value  :=m_ChrRcd.Data.nPayMentPoint;
  EditCreditPoint.Value:=m_ChrRcd.Data.btCreditPoint;
  EditPKPoint.Value    :=m_ChrRcd.Data.nPKPoint;
end;

procedure TfrmEditRcd.Open;
begin

  RefShow();
  Caption:=format('编辑人物数据 [%s]',[m_ChrRcd.Data.sChrName]);
  PageControl.ActivePageIndex:=0;
  
  ShowModal;
end;

procedure TfrmEditRcd.RefShow;
begin
  m_boOpened:=False;
  RefShowRcd();
  RefShowMagic();
  RefShowUserItem();
  RefShowStorage();
  m_boOpened:=True;
end;

procedure TfrmEditRcd.RefShowMagic;
var
  I: Integer;
  ListItem:TListItem;
//  MagicInfo:pTHumMagicInfo;
begin
{  ListViewMagic.Clear;

  for I := Low(m_ChrRcd.Data.Magic) to High(m_ChrRcd.Data.Magic) do begin
    MagicInfo:=@m_ChrRcd.Data.Magic[I];
    if MagicInfo.wMagIdx = 0 then break;

    ListItem:=ListViewMagic.Items.Add;
    ListItem.Caption:=IntToStr(I);
    ListItem.SubItems.Add(IntToStr(MagicInfo.wMagIdx));
    ListItem.SubItems.Add('');
    ListItem.SubItems.Add(IntToStr(MagicInfo.btLevel));
    ListItem.SubItems.Add(IntToStr(MagicInfo.nTranPoint));
    ListItem.SubItems.Add(IntToStr(MagicInfo.btKey));
  end;}
end;

procedure TfrmEditRcd.RefShowUserItem;
var
  I: Integer;
  ListItem:TListItem;
  UserItem:pTUserItem;
ResourceString
  sItemValue = '%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d';
    //'%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d'  
begin
  ListViewUserItem.Clear;

  for I := Low(m_ChrRcd.Data.HumItems) to High(m_ChrRcd.Data.HumItems) do begin
    UserItem:=@m_ChrRcd.Data.HumItems[I];
    ListItem:=ListViewUserItem.Items.Add;
    ListItem.Caption:=IntToStr(I);
    ListItem.SubItems.Add(IntToStr(UserItem.MakeIndex));
    ListItem.SubItems.Add(IntToStr(UserItem.wIndex));
    ListItem.SubItems.Add('');    ;
    ListItem.SubItems.Add(format('%d/%d',[UserItem.Dura,UserItem.DuraMax]));

    ListItem.SubItems.Add(format(sItemValue,[
                                 UserItem.btValue[0],
                                 UserItem.btValue[1],
                                 UserItem.btValue[2],
                                 UserItem.btValue[3],
                                 UserItem.btValue[4],
                                 UserItem.btValue[5],
                                 UserItem.btValue[6],
                                 UserItem.btValue[7],
                                 UserItem.btValue[8],
                                 UserItem.btValue[9],
                                 UserItem.btValue[10],
                                 UserItem.btValue[11],
                                 UserItem.btValue[12],
                                 UserItem.btValue[13]
    ]));

  end;
end;

procedure TfrmEditRcd.RefShowStorage;
var
  I: Integer;
  ListItem:TListItem;
  UserItem:pTUserItem;
begin
  ListViewStorage.Clear;

  for I := Low(m_ChrRcd.Data.StorageItems) to High(m_ChrRcd.Data.StorageItems) do begin
    UserItem:=@m_ChrRcd.Data.StorageItems[I];
    if UserItem.wIndex = 0 then Continue;
      
    ListItem:=ListViewStorage.Items.Add;
    ListItem.Caption:=IntToStr(I);
    ListItem.SubItems.Add(IntToStr(UserItem.MakeIndex));
    ListItem.SubItems.Add(IntToStr(UserItem.wIndex));
    ListItem.SubItems.Add('');    ;
    ListItem.SubItems.Add(format('%d/%d',[UserItem.Dura,UserItem.DuraMax]));
    ListItem.SubItems.Add(format('%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d/%d',[
                                 UserItem.btValue[0],
                                 UserItem.btValue[1],
                                 UserItem.btValue[2],
                                 UserItem.btValue[3],
                                 UserItem.btValue[4],
                                 UserItem.btValue[5],
                                 UserItem.btValue[6],
                                 UserItem.btValue[7],
                                 UserItem.btValue[8],
                                 UserItem.btValue[9],
                                 UserItem.btValue[10],
                                 UserItem.btValue[11],
                                 UserItem.btValue[12],
                                 UserItem.btValue[13]
    ]));

  end;

end;

procedure TfrmEditRcd.ButtonExportDataClick(Sender: TObject);
begin
  if Sender = ButtonExportData then begin
    ProcessSaveRcdToFile();
  end else
  if Sender = ButtonImportData then begin
    ProcessLoadRcdformFile();
  end else
  if Sender = ButtonSaveData then begin
    ProcessSaveRcd();
  end;
    
end;

procedure TfrmEditRcd.ProcessSaveRcdToFile;
var
  sSaveFileName:String;
  nFileHandle:Integer;
begin
  SaveDialog.FileName:=m_ChrRcd.Data.sChrName;
  SaveDialog.InitialDir:='.\';
  if not SaveDialog.Execute then exit;
  sSaveFileName:=SaveDialog.FileName;

  if FileExists(sSaveFileName) then
    nFileHandle:=FileOpen(sSaveFileName,fmOpenReadWrite or fmShareDenyNone)
  else nFileHandle:=FileCreate(sSaveFileName);
  if nFileHandle <= 0 then begin
    MessageBox(Handle,'保存文件出现错误！！！','错误信息',MB_OK + MB_ICONEXCLAMATION);
    exit;
  end;
  FileWrite(nFileHandle,m_ChrRcd,SizeOf(THumDataInfo));
  FileClose(nFileHandle);
  MessageBox(Handle,'人物数据导出成功！！！','提示信息',MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmEditRcd.ProcessLoadRcdformFile;
var
  sLoadFileName:String;
  nFileHandle:Integer;
  ChrRcd:THumDataInfo;
begin
  OpenDialog.FileName:=m_ChrRcd.Data.sChrName;
  OpenDialog.InitialDir:='.\';
  if not OpenDialog.Execute then exit;
  sLoadFileName:=OpenDialog.FileName;

  if not FileExists(sLoadFileName) then begin
    MessageBox(Handle,'指定的文件未找到！！！','错误信息',MB_OK + MB_ICONEXCLAMATION);
    exit;
  end;
  nFileHandle:=FileOpen(sLoadFileName,fmOpenReadWrite or fmShareDenyNone);

  if nFileHandle <= 0 then begin
    MessageBox(Handle,'打开文件出现错误！！！','错误信息',MB_OK + MB_ICONEXCLAMATION);
    exit;
  end;
  if not FileRead(nFileHandle,ChrRcd,SizeOf(THumDataInfo)) = SizeOf(THumDataInfo) then begin
    MessageBox(Handle,'读取文件出现错误！！！'#13#13'文件格式可能不正确','错误信息',MB_OK + MB_ICONEXCLAMATION);
    exit;
  end;
  ChrRcd.Header:=m_ChrRcd.Header;
  ChrRcd.Data.sChrName:=m_ChrRcd.Data.sChrName;
  ChrRcd.Data.sAccount:=m_ChrRcd.Data.sAccount;
  m_ChrRcd:=ChrRcd;
  FileClose(nFileHandle);
  RefShow();
  MessageBox(Handle,'人物数据导入成功！！！','提示信息',MB_OK + MB_ICONINFORMATION);
end;


procedure TfrmEditRcd.ProcessSaveRcd;
var
  nIdx     :Integer;
  boSaveOK :Boolean;
begin
  boSaveOK:=False;
  try
    if HumDataDB.Open then begin
      nIdx:=HumDataDB.Index(m_ChrRcd.Header.sName);
      if (nIdx >= 0) then begin
        HumDataDB.Update(nIdx,m_ChrRcd);
        boSaveOK:=True;
      end;
    end;
  finally
    HumDataDB.Close;
  end;
  if boSaveOK then begin
    MessageBox(Handle,'人物数据保存成功！！！','提示信息',MB_OK + MB_ICONINFORMATION);
  end else begin
    MessageBox(Handle,'人物数据保存失败！！！','错误信息',MB_OK + MB_ICONEXCLAMATION);
  end;
    
end;


procedure TfrmEditRcd.EditPasswordChange(Sender: TObject);
begin
  if not m_boOpened then exit;
  if Sender = EditPassword then begin
    m_ChrRcd.Data.sStoragePwd:=Trim(EditPassword.Text);
  end else

//取消结婚 与 师徒系统的相关功能
//  if Sender = EditDearName then begin
//    m_ChrRcd.Data.sDearName:=Trim(EditDearName.Text);
//  end else
//  if Sender = EditMasterName then begin
//   m_ChrRcd.Data.sMasterName:=Trim(EditMasterName.Text);
//  end else
//  if Sender = CheckBoxIsMaster then begin
//    m_ChrRcd.Data.boMaster:=CheckBoxIsMaster.Checked;
//  end else

  if Sender = EditCurMap then begin
    m_ChrRcd.Data.sCurMap:=Trim(EditCurMap.Text);
  end else
  if Sender = EditCurX then begin
    m_ChrRcd.Data.wCurX:=EditCurX.Value;
  end else
  if Sender = EditCurY then begin
    m_ChrRcd.Data.wCurY:=EditCurY.Value;
  end else
  if Sender = EditHomeMap then begin
    m_ChrRcd.Data.sHomeMap:=Trim(EditHomeMap.Text);
  end else    
  if Sender = EditHomeX then begin
    m_ChrRcd.Data.wHomeX:=EditHomeX.Value;
  end else
  if Sender = EditCurY then begin
    m_ChrRcd.Data.wHomeY:=EditHomeY.Value;
  end else
  if Sender = EditLevel then begin
    m_ChrRcd.Data.Abil.Level:=EditLevel.Value;
  end else
  if Sender = EditGold then begin
    m_ChrRcd.Data.nGold:=EditGold.Value;
  end else
  if Sender = EditGameGold then begin
    m_ChrRcd.Data.nGameGold:=EditGameGold.Value;
  end else
  if Sender = EditGamePoint then begin
    m_ChrRcd.Data.nGamePoint:=EditGamePoint.Value;
  end else
  if Sender = EditPayPoint then begin
    m_ChrRcd.Data.nPayMentPoint:=EditPayPoint.Value;
  end else
  if Sender = EditCreditPoint then begin
    m_ChrRcd.Data.btCreditPoint:=EditCreditPoint.Value;
  end else
  if Sender = EditPKPoint then begin
    m_ChrRcd.Data.nPKPoint:=EditPKPoint.Value;
  end else
  if Sender = EditContribution then begin
    m_ChrRcd.Data.wContribution:=EditContribution.Value;
  end

end;



end.
