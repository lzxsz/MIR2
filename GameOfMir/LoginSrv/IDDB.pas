unit IDDB;

interface
uses
  Windows,Classes,SysUtils,Forms,Grobal2,MudUtil;
ResourceString
  sDBHeaderDesc     = '游戏数据库文件 2009/09/09';
  sDBIdxHeaderDesc  = '游戏数据库索引文件 2009/09/09';
type
  TDBHeader = packed record
    sDesc       :String[34]; //0x00
    n23         :Integer;    //0x23
    n28         :Integer;    //0x27
    n2C         :Integer;    //0x2B
    n30         :Integer;    //0x2F
    n34         :Integer;    //0x33
    n38         :Integer;    //0x37
    n3C         :Integer;    //0x3B
    n40         :Integer;    //0x3F
    n44         :Integer;    //0x43
    n48         :Integer;    //0x47
    n4B         :Byte;       //0x4B
    n4C         :Integer;    //0x4C
    n50         :Integer;    //0x50
    n54         :Integer;    //0x54
    n58         :Integer;    //0x58
    nLastIndex  :Integer;    //0x5C
    dLastDate   :TDateTime;  //0x60
    nIDCount    :Integer;    //0x68
    n6C         :Integer;    //0x6C
    nDeletedIdx :Integer;    //0x70
    dUpdateDate :TDateTime;  //0x74
  end;
  pTDBHeader = ^TDBHeader;
  TIdxHeader = packed record
    sDesc       :String[43]; //0x00
    n2C         :Integer;    //0x2C
    n30         :Integer;    //0x30
    n34         :Integer;    //0x34
    n38         :Integer;    //0x38
    n3C         :Integer;    //0x3C
    n40         :Integer;    //0x40
    n44         :Integer;    //0x44
    n48         :Integer;    //0x48
    n4C         :Integer;    //0x4C
    n50         :Integer;    //0x50
    n54         :Integer;    //0x54
    n58         :Integer;    //0x58
    n5C         :Integer;    //0x5C
    n60         :Integer;    //0x60
    nQuickCount :Integer;    //0x64
    nIDCount    :Integer;    //0x68
    nLastIndex  :Integer;    //0x6C
    dUpdateDate :TDateTime;  //0x70
  end;


  TRecordDeletedHeader = packed record
    boDeleted     :Boolean;
    bt1           :Byte;
    bt2           :Byte;
    bt3           :Byte;
    CreateDate    :TDateTime; //0x04
    LastLoginDate :TDateTime; //0x0C
    n14           :Integer;
    nNextDeletedIdx  :Integer;
//    sAccount   :String[11];//0x14
  end;



  TIdxRecord = packed record
    sName       :String[11];
    nIndex      :Integer;
  end;
  pTIdxRecord = ^TIdxRecord;
  //TNotifyEvent = procedure(Sender: TObject) of object;
  TFileIDDB = class
    m_nLastReadIdx  :Integer;        //0x4  最后访问的记录号
    m_nDeletedIdx   :Integer;        //0x8  已删除的最后一个记录号
    nC              :Integer;        //0x0C
//    w10         :Word;           //0x10
//    w12         :Word;           //0x12
//    n14         :Integer;
    m_OnChange      :TNotifyEvent;
    m_boChanged     :Boolean;        //0x18 数据库已被更改
    m_nLastIndex    :Integer;        //0x1C 最后一次写数据的记录号
    m_dLastDate     :TDateTime;      //0x20 最后修改日期
    m_nFileHandle   :Integer;        //0x28
    m_Header        :TDBHeader;      //0x2C 数据库头
    m_QuickList     :TQuickList;     //0xA4 数据索引表
    m_sDBFileName   :String;         //0xAC
    m_sIdxFileName  :String;         //0xB0
    FCriticalSection:TRTLCriticalSection;
  private
    function LoadDBIndex: Boolean;
    procedure LoadQuickList;
    procedure SaveDBIndex;
    function GetRecord(nIndex: Integer; var DBRecord: TAccountDBRecord): Boolean;

    function UpdateRecord(nIndex: Integer; DBRecord: TAccountDBRecord;
      boNew: Boolean): Boolean;

  public
    constructor Create(sFileName:String);
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
    function Open: Boolean;
    function OpenEx: Boolean;
    function Index(sName:String):Integer;
    function Get(nIndex:Integer;var DBRecord: TAccountDBRecord):Integer;
    function FindByName(sName:string; var List:TStringList):Integer;
    function GetBy(nIndex:Integer;var DBRecord:TAccountDBRecord):Boolean;
    function Update(nIndex: Integer; var DBRecord: TAccountDBRecord): Boolean;
    function Add(var DBRecord: TAccountDBRecord):Boolean;
    procedure Close;
  end;
var
  AccountDB     :TFileIDDB;  
implementation

uses LSShare, HUtil32;

{ TFileIDDB }
//00457D5C
constructor TFileIDDB.Create(sFileName: String);
begin
  InitializeCriticalSection(FCriticalSection);
  m_nLastReadIdx              := 0;
  m_sDBFileName               := sFileName;
  m_sIdxFileName              := sFileName + '.idx';
  m_QuickList                 := TQuickList.Create;
  m_QuickList.boCaseSensitive := False;
  g_n472A6C                   := 0;
  g_n472A74                   := 0;
  g_boDataDBReady             := False;
  m_nLastIndex                := -1;
  m_nDeletedIdx               := -1;
  if LoadDBIndex then g_boDataDBReady:=True
  else LoadQuickList();
end;

destructor TFileIDDB.Destroy;
//0x00457E64
begin
  if g_boDataDBReady then SaveDBIndex();
  m_QuickList.Free;
  DeleteCriticalSection(FCriticalSection);
end;
procedure TFileIDDB.Lock; //0x00457EA8
begin
  EnterCriticalSection(FCriticalSection);
end;
procedure TFileIDDB.UnLock;
begin
  LeaveCriticalSection(FCriticalSection);
end;
//00457F60
function TFileIDDB.Open: Boolean;
begin
  Lock();
  m_nLastReadIdx:=0;
  m_boChanged:=False;
  if FileExists(m_sDBFileName) then begin
    m_nFileHandle:=FileOpen(m_sDBFileName,fmOpenReadWrite or fmShareDenyNone);
    if m_nFileHandle > 0 then
      FileRead(m_nFileHandle,m_Header,SizeOf(TDBHeader));
  end else begin
    m_nFileHandle:=FileCreate(m_sDBFileName);
    if m_nFileHandle > 0 then begin
      m_Header.sDesc       := sDBHeaderDesc;
      m_Header.nIDCount    := 0;
      m_Header.n6C         := 0;
      m_Header.nDeletedIdx := -1;
      FileWrite(m_nFileHandle,m_Header,SizeOf(TDBHeader));
    end;
  end;
  if m_nFileHandle > 0 then begin
    Result:=True;
//    nDeletedIdx:=Header.n70; //Jacky 增加
  end else Result:=False;
end;
procedure TFileIDDB.Close();//0x00458064
begin
  FileClose(m_nFileHandle);
  if m_boChanged and Assigned(m_OnChange) then begin
    m_OnChange(Self);
  end;
    
  UnLock();
end;

//加载数据索引文件
//00458508
function TFileIDDB.LoadDBIndex():Boolean;
var
  nIdxFileHandle :Integer;
  IdxHeader      :TIdxHeader;
  DBHeader       :TDBHeader;
  IdxRecord      :TIdxRecord;
  HumRecord      :TAccountDBRecord;
  I              :Integer;
  n14            :Integer;
begin
  Result:=False;
  nIdxFileHandle:=0;
  FillChar(IdxHeader,SizeOf(TIdxHeader),#0);
  if FileExists(m_sIdxFileName) then
    nIdxFileHandle:=FileOpen(m_sIdxFileName,fmOpenReadWrite or fmShareDenyNone);
  if nIdxFileHandle > 0 then begin
    Result:=True;
    FileRead(nIdxFileHandle,IdxHeader,SizeOf(TIdxHeader));

    try
      if Open then begin
        FileSeek(m_nFileHandle,0,0);
        if FileRead(m_nFileHandle,DBHeader,SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
          if IdxHeader.nIDCount <> DBHeader.nIDCount then
            Result:=False;
        end;
        if IdxHeader.nLastIndex <> DBHeader.nLastIndex then begin
          Result:=False;
        end;
        if IdxHeader.nLastIndex > -1 then begin
          FileSeek(m_nFileHandle,IdxHeader.nLastIndex * SizeOf(TAccountDBRecord) + SizeOf(TDBHeader),0);
          if FileRead(m_nFileHandle,HumRecord,SizeOf(TAccountDBRecord)) = SizeOf(TAccountDBRecord) then
            if IdxHeader.dUpdateDate <> HumRecord.Header.UpdateDate then
              Result:=False;
        end;
      end;
    finally
      Close();
    end;
    if Result then begin
      m_nLastIndex  := IdxHeader.nLastIndex;
      m_dLastDate   := IdxHeader.dUpdateDate;
      for i:=0 to IdxHeader.nQuickCount -1 do begin
        if FileRead(nIdxFileHandle,IdxRecord,SizeOf(TIdxRecord)) = SizeOf(TIdxRecord) then begin
          m_QuickList.AddObject(IdxRecord.sName,TObject(IdxRecord.nIndex));
        end else begin
          Result:=False;
          break;
        end;
      end;
    end;
    FileClose(nIdxFileHandle);
  end;
  if Result then begin
    g_n472A6C:=DBHeader.nIDCount;
    g_n472A74:=DBHeader.nIDCount;
  end else m_QuickList.Clear;
end;

//生成数据索引
//0x004580A4
procedure TFileIDDB.LoadQuickList();
var
  nIndex        :Integer;
  n10           :Integer;
  DBHeader      :TDBHeader;
  DBRecord      :TAccountDBRecord;
  DeletedHeader :TRecordDeletedHeader;
begin
  m_nLastReadIdx := 0;
  m_nDeletedIdx  := -1;
  nIndex         := 0;
  g_n472A6C      := 0;
  g_n472A70      := 0;
  g_n472A74      := 0;
  m_QuickList.Clear;
  try
    if Open then begin
      FileSeek(m_nFileHandle,0,0);
      if FileRead(m_nFileHandle,DBHeader,SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
        g_n472A74:=DBHeader.nIDCount;
        for nIndex:=0 to DBHeader.nIDCount -1 do begin
          Inc(g_n472A6C);
          if FileRead(m_nFileHandle,DBRecord,SizeOf(TAccountDBRecord)) <> SizeOf(TAccountDBRecord) then begin
            break;
          end;
          if not DBRecord.Header.boDeleted then begin
            if DBRecord.UserEntry.sAccount <> '' then begin
              m_QuickList.AddObject(DBRecord.UserEntry.sAccount,TObject(nIndex));
              Inc(g_n472A70);
            end;
          end else begin //004581D5
            n10:=FileSeek(m_nFileHandle,-SizeOf(TAccountDBRecord),1);
            FileRead(m_nFileHandle,DeletedHeader,SizeOf(TRecordDeletedHeader));
            FileSeek(m_nFileHandle,-SizeOf(TRecordDeletedHeader),1);
            DeletedHeader.nNextDeletedIdx:=m_nDeletedIdx;
            m_nDeletedIdx:=nIndex;
            FileWrite(m_nFileHandle,DeletedHeader,SizeOf(TRecordDeletedHeader));
            FileSeek(m_nFileHandle,n10,0);
          end;
          Application.ProcessMessages;
          if Application.Terminated then begin
            Close;
            exit;
          end;
        end;
      end;
    end;
  finally
    Close();
  end;
  m_QuickList.SortString(0,m_QuickList.Count -1);
  m_nLastIndex    := m_Header.nLastIndex;
  m_dLastDate     := m_Header.dLastDate;
  g_boDataDBReady :=True;

end;
//0045832C
procedure TFileIDDB.SaveDBIndex();
var
  IdxHeader      :TIdxHeader;
  nIdxFileHandle :Integer;
  I              :Integer;
  n10            :Integer;
  IdxRecord      :TIdxRecord;
begin
  FillChar(IdxHeader,SizeOf(TIdxHeader),#0);
  IdxHeader.sDesc       := sDBIdxHeaderDesc;
  IdxHeader.nQuickCount := m_QuickList.Count;
  IdxHeader.nIDCount    := m_Header.nIDCount;
  IdxHeader.nLastIndex  := m_nLastIndex;
  IdxHeader.dUpdateDate := m_dLastDate;
  if FileExists(m_sIdxFileName) then
    nIdxFileHandle:=FileOpen(m_sIdxFileName,fmOpenReadWrite or fmShareDenyNone)
  else nIdxFileHandle:=FileCreate(m_sIdxFileName);

  if nIdxFileHandle > 0 then begin
    FileWrite(nIdxFileHandle,IdxHeader,SizeOf(TIdxHeader));
    for I := 0 to  m_QuickList.Count - 1 do begin
      FillChar(IdxRecord,SizeOf(TIdxRecord),#0);
      IdxRecord.sName:=m_QuickList.Strings[I];
      IdxRecord.nIndex:=Integer(m_QuickList.Objects[I]);
      FileWrite(nIdxFileHandle,IdxRecord,SizeOf(TIdxRecord));
    end;
    FileClose(nIdxFileHandle);
  end;
end;
//0x00458C6C
function TFileIDDB.FindByName(sName: string;
  var List: TStringList): Integer;
var
  I:Integer;
begin
  for I:= 0 to m_QuickList.Count - 1 do begin
    if CompareLStr(m_QuickList.Strings[I],sName,length(sName)) then begin
      List.AddObject(m_QuickList.Strings[I],m_QuickList.Objects[I]);
    end;
  end;
  Result:=List.Count;
end;
//0x00458A34
function TFileIDDB.GetBy(nIndex: Integer;
  var DBRecord: TAccountDBRecord): Boolean;
begin
  if nIndex >= 0 then
    Result:=GetRecord(nIndex,DBRecord)
  else Result:= False;
end;
function TFileIDDB.GetRecord(nIndex: Integer;
  var DBRecord: TAccountDBRecord): Boolean;
begin
  if FileSeek(m_nFileHandle,SizeOf(TAccountDBRecord) * nIndex + SizeOf(TDBHeader),0) <> -1 then begin
    FileRead(m_nFileHandle,DBRecord,SizeOf(TAccountDBRecord));
    FileSeek(m_nFileHandle,-SizeOf(TAccountDBRecord) * nIndex + SizeOf(TDBHeader),1);
    m_nLastReadIdx:=nIndex;
    Result:=True;
  end else Result:=False;
end;
//0x00458C10
function TFileIDDB.Index(sName: String): Integer;
begin
  Result:=m_QuickList.GetIndex(sName);
end;
//0x004589E8
function TFileIDDB.Get(nIndex: Integer; var DBRecord: TAccountDBRecord): Integer;
var
  nRecordIndex:Integer;
begin
  nRecordIndex:=Integer(m_QuickList.Objects[nIndex]);
  if GetRecord(nRecordIndex,DBRecord) then Result:=nRecordIndex
  else Result:= -1;
end;
//00457ED8
function TFileIDDB.OpenEx: Boolean;
var
  DBHeader:TDBHeader;
begin
  Lock();
  m_boChanged:=False;
  m_nFileHandle:=FileOpen(m_sDBFileName,fmOpenRead or fmShareDenyNone);
  if m_nFileHandle > 0 then begin
    Result:=True;
    if FileRead(m_nFileHandle,DBHeader,SizeOf(TDBHeader)) = SizeOf(TDBHeader) then
      m_Header:=DBHeader;
    m_nLastReadIdx:=0;
  end else Result:=False;
end;
function TFileIDDB.UpdateRecord(nIndex: Integer; DBRecord: TAccountDBRecord;
  boNew: Boolean): Boolean;//0x0048BF5C
var
  DeletedHeader :TRecordDeletedHeader;
  nPosion       :Integer;
  n10           :Integer;
  dDateTime     :TDateTime;
begin
  nPosion:=nIndex * SizeOf(TAccountDBRecord) + SizeOf(TDBHeader);
  if FileSeek(m_nFileHandle,nPosion,0) = nPosion then begin
    m_nLastIndex  := nIndex;
    dDateTime     := Now();
    m_dLastDate   := dDateTime;
    n10:=FileSeek(m_nFileHandle,0,1);
    if boNew then begin
       if FileRead(m_nFileHandle,DeletedHeader,SizeOf(TRecordDeletedHeader)) = SizeOf(TRecordDeletedHeader) then begin
         if DeletedHeader.boDeleted then begin
           m_nDeletedIdx:=DeletedHeader.nNextDeletedIdx;
         end else begin
           m_nDeletedIdx:= -1;
           Result:=False;
           exit;
         end;
       end; //0045888B
       DBRecord.Header.CreateDate:=dDateTime;
    end; //004588B4
    DBRecord.Header.boDeleted    := False;
    DBRecord.Header.UpdateDate   := dDateTime;
    m_Header.nLastIndex          := m_nLastIndex;
    m_Header.dLastDate           := m_dLastDate;
    m_Header.nDeletedIdx         := m_nDeletedIdx;
    m_Header.dUpdateDate         := Now();
    FileSeek(m_nFileHandle,0,0);
    FileWrite(m_nFileHandle,m_Header,SizeOf(TDBHeader));
    FileSeek(m_nFileHandle,n10,0);
    FileWrite(m_nFileHandle,DBRecord,SizeOf(TAccountDBRecord));
    FileSeek(m_nFileHandle,-SizeOf(TAccountDBRecord),1);
    m_nLastReadIdx  := nIndex;
    m_boChanged     := True;
    Result:=True;
  end else Result:=False;
end;

function TFileIDDB.Update(nIndex: Integer;
  var DBRecord: TAccountDBRecord): Boolean;
//0x0048C14C
begin
  Result:=False;
  if nIndex < 0 then exit;
  if m_QuickList.Count <= nIndex then exit;
  if UpdateRecord(Integer(m_QuickList.Objects[nIndex]),DBRecord,False) then Result:=True;
end;

//00458ADC
function TFileIDDB.Add(var DBRecord: TAccountDBRecord): Boolean;
var
  sAccountName :String;
  DBHeader     :TDBHeader;
  nC           :Integer;
begin
  sAccountName:=DBRecord.UserEntry.sAccount;
  if m_QuickList.GetIndex(sAccountName) >= 0 then begin
    Result:=False;
  end else begin
    DBHeader:=m_Header;
    if m_nDeletedIdx = -1 then begin
      nC:=m_Header.nIDCount;
      Inc(m_Header.nIDCount);
    end else nC:= m_nDeletedIdx;
      
    if UpdateRecord(nC,DBRecord,True) then begin
      m_QuickList.AddRecord(DBRecord.UserEntry.sAccount,nC);
      Result:=True;
    end else begin
      m_Header := DBHeader;
      Result   := False;
    end;
  end;
end;

end.
