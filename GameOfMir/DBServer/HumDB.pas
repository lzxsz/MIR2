unit HumDB;

interface
uses
  Windows,Classes,SysUtils,Forms,MudUtil,Grobal2;
ResourceString
  sDBHeaderDesc     = '⒌L游戏数据库文件 2008/02/10';
  sDBIdxHeaderDesc  = '⒌L游戏数据库索引文件 2008/02/10';

type
  TDBHeader = record
    sDesc       :String[35]; //0x00
    n24         :Integer;    //0x24
    n28         :Integer;    //0x28
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
    nLastIndex  :Integer;    //0x5C
    dLastDate   :TDateTime;  //0x60
    nHumCount   :Integer;    //0x68
    n6C         :Integer;    //0x6C
    n70         :Integer;    //0x70
    dUpdateDate :TDateTime;  //0x74
  end;
  pTDBHeader = ^TDBHeader;
  TIdxHeader = record
    sDesc       :String[40]; //0x00
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
    nHumCount   :Integer;    //0x68
    nDeleteCount:Integer;    //0x6C
    nLastIndex  :Integer;    //0x70
    dUpdateDate :TDateTime;  //0x74
  end;

  pTHumInfo = ^THumInfo;
  TIdxRecord = record
    sChrName    :String[15];
    nIndex      :Integer;
  end;
  pTIdxRecord = ^TIdxRecord;


  TFileHumDB = class
    n4               :Integer;      //0x04
    m_nFileHandle    :Integer;      //0x08
    n0C              :Integer;      //0x0C
    m_OnChange       :TNotifyEvent;

    m_boChanged      :Boolean;      //0x18
    m_Header         :TDBHeader;    //0x1C
    m_QuickList      :TQuickList;   //0x98
    m_QuickIDList    :TQuickIDList; //0x9C
    m_DeletedList    :TList;        //0xA0 已被删除的记录号
    m_sDBFileName    :String;       //0xA4
  private
    procedure LoadQuickList;
    procedure Lock;
    procedure UnLock;
    function  UpdateRecord(nIndex:Integer;HumRecord:THumInfo;boNew:Boolean):Boolean;
    function  DeleteRecord(nIndex:Integer):Boolean;
    function  GetRecord(n08:Integer;var HumDBRecord:THumInfo):Boolean;
  public
    constructor Create(sFileName:String);
    destructor Destroy; override;

    function  Open():Boolean;
    function  OpenEx():Boolean;
    procedure Close();
    function  Index(sName:String):Integer;
    function  Get(n08:Integer;var HumDBRecord:THumInfo):Integer;
    function  GetBy(n08:Integer;var HumDBRecord:THumInfo):Boolean;
    function  FindByName(sChrName:String;ChrList:TStringList):Integer;
    function  FindByAccount(sAccount:String;var ChrList:TStringList):Integer;
    function  ChrCountOfAccount(sAccount:String):Integer;
    function  Add(HumRecord:THumInfo):Boolean;
    function  Delete(sName:String):Boolean;
    function  Update(nIndex:Integer;var HumDBRecord:THumInfo):Boolean;
    function  UpdateBy(nIndex:Integer;var HumDBRecord:THumInfo):Boolean;

  end;
  TFileDB = class
    n4          :Integer;        //0x4
    m_nFileHandle :Integer;        //0x08
    nC            :Integer;
    m_OnChange    :TNotifyEvent;   //0x10
    m_boChanged   :Boolean;        //0x18
    m_nLastIndex  :Integer;        //0x1C
    m_dUpdateTime :TDateTime;      //0x20
    m_Header      :TDBHeader;      //0x28
    m_QuickList   :TQuickList;     //0xA4
    m_DeletedList :TList;          //0xA8 已被删除的记录号
    m_sDBFileName :String;         //0xAC
    m_sIdxFileName:String;         //0xB0
  private
    procedure LoadQuickList;
    function  LoadDBIndex():Boolean;
    procedure SaveIndex();
    function  GetRecord(nIndex:Integer;var HumanRCD:THumDataInfo):Boolean;
    function  UpdateRecord(nIndex:Integer;var HumanRCD:THumDataInfo;boNew:Boolean):Boolean;
    function  DeleteRecord(nIndex:Integer):Boolean;
  public
    constructor Create(sFileName:String);
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
    function  Open():Boolean;
    function  OpenEx():Boolean;
    procedure Close();
    function  Index(sName:String):Integer;
    function  Get(nIndex:Integer;var HumanRCD:THumDataInfo):Integer;
    function  Update(nIndex:Integer;var HumanRCD:THumDataInfo):Boolean;
    function  Add(var HumanRCD:THumDataInfo):Boolean;
    function  Find(sChrName:String;List:TStrings):Integer;
    procedure Rebuild();
    function  Count():Integer;
    function  Delete(sChrName:String):Boolean;overload;
    function  Delete(nIndex:Integer):Boolean;overload;
  end;
var
  HumChrDB              :TFileHumDB;
  HumDataDB             :TFileDB;
implementation

uses DBShare, HUtil32;

{ TFileHumDB }

constructor TFileHumDB.Create(sFileName: String);//0x0048B73C
begin
  m_sDBFileName := sFileName;
  m_QuickList   := TQuickList.Create;
  m_QuickIDList := TQuickIDList.Create;
  m_DeletedList := TList.Create;
  n4ADAFC       := 0;
  n4ADB04       := 0;
  boHumDBReady  := False;
  LoadQuickList();
end;
destructor TFileHumDB.Destroy;
begin
  m_QuickList.Free;
  m_QuickIDList.Free;
  inherited;
end;
procedure TFileHumDB.Lock();//0x0048B870
begin
  EnterCriticalSection(HumDB_CS);
end;
procedure TFileHumDB.UnLock();//0x0048B888
begin
  LeaveCriticalSection(HumDB_CS);
end;

procedure TFileHumDB.LoadQuickList();
//0x48BA64
var
  nRecordIndex :Integer;
  nIndex       :Integer;
  AccountList  :TStringList;
  ChrNameList  :TStringList;
  DBHeader     :TDBHeader;
  DBRecord     :THumInfo;
begin
  n4:=0;
  m_QuickList.Clear;
  m_QuickIDList.Clear;
  m_DeletedList.Clear;
  nRecordIndex:=0;
  n4ADAFC:=0;
  n4ADB00:=0;
  n4ADB04:=0;
  AccountList:=TStringList.Create;
  ChrNameList:=TStringList.Create;
  try
    if Open then begin
      FileSeek(m_nFileHandle,0,0);
      if FileRead(m_nFileHandle,DBHeader,SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
        n4ADB04:=DBHeader.nHumCount;
        for nIndex:=0 to DBHeader.nHumCount - 1 do begin
          Inc(n4ADAFC);
          if FileRead(m_nFileHandle,DBRecord,SizeOf(THumInfo)) <> SizeOf(THumInfo) then begin
            break;
          end;
          if not DBRecord.Header.boDeleted then begin
            m_QuickList.AddObject(DBRecord.Header.sName,TObject(nRecordIndex));
            AccountList.AddObject(DBRecord.sAccount,TObject(DBRecord.Header.nSelectID));
            ChrNameList.AddObject(DBRecord.sChrName,TObject(nRecordIndex));
            Inc(n4ADB00);
          end else begin //0x0048BC04
            m_DeletedList.Add(TObject(nIndex));
          end;
          Inc(nRecordIndex);
          Application.ProcessMessages;
          if Application.Terminated then begin
            Close;
            exit;
          end;
        end;
      end; //0x0048BC52
    end;
  finally
    Close();
  end;
  for nIndex:=0 to AccountList.Count -1 do begin
    m_QuickIDList.AddRecord(AccountList.Strings[nIndex],
                          ChrNameList.Strings[nIndex],
                          Integer(ChrNameList.Objects[nIndex]),
                          Integer(AccountList.Objects[nIndex]));
    if (nIndex mod 100) = 0 then
      Application.ProcessMessages;
  end;
  //0x0048BCF4
  AccountList.Free;
  ChrNameList.Free;
  m_QuickList.SortString(0,m_QuickList.Count -1);
  boHumDBReady:=True;
end;
procedure TFileHumDB.Close;//0x0048BA24
begin
  FileClose(m_nFileHandle);
  if m_boChanged and Assigned(m_OnChange) then begin
    m_OnChange(Self);
  end;
  UnLock();
end;

function TFileHumDB.Open: Boolean;//0x0048B928
begin
  Lock();
  n4:=0;
  m_boChanged:=False;
  if FileExists(m_sDBFileName) then begin
    m_nFileHandle:=FileOpen(m_sDBFileName,fmOpenReadWrite or fmShareDenyNone);
    if m_nFileHandle > 0 then
      FileRead(m_nFileHandle,m_Header,SizeOf(TDBHeader));
  end else begin //0x0048B999
    m_nFileHandle:=FileCreate(m_sDBFileName);
    if m_nFileHandle > 0 then begin
      FillChar(m_Header,SizeOf(TDBHeader),#0);
      m_Header.sDesc:= sDBHeaderDesc;
      m_Header.nHumCount:=0;
      m_Header.n6C:=0;
      FileWrite(m_nFileHandle,m_Header,SizeOf(TDBHeader));
    end;
  end;
  if m_nFileHandle > 0 then Result:=True
  else Result:=False;
end;

function TFileHumDB.OpenEx: Boolean;//0x0048B8A0
var
  DBHeader:TDBHeader;
begin
  Lock();
  m_boChanged:=False;
  m_nFileHandle:=FileOpen(m_sDBFileName,fmOpenReadWrite or fmShareDenyNone);
  if m_nFileHandle > 0 then begin
    Result:=True;
    if FileRead(m_nFileHandle,DBHeader,SizeOf(TDBHeader)) = SizeOf(TDBHeader) then
      m_Header:=DBHeader;
    n4:=0;
  end else Result:=False;
end;

function TFileHumDB.Index(sName: String): Integer;//0x0048C384
begin
  Result:=m_QuickList.GetIndex(sName);
end;

function TFileHumDB.Get(n08: Integer;
  var HumDBRecord: THumInfo):Integer;//0x0048C0CC
var
  nIndex:Integer;
begin
  nIndex:=Integer(m_QuickList.Objects[n08]);
  if GetRecord(nIndex,HumDBRecord) then Result:=nIndex
  else Result:= -1;
end;

function TFileHumDB.GetRecord(n08: Integer;
  var HumDBRecord: THumInfo): Boolean;
//0x0048BEEC
begin
  if FileSeek(m_nFileHandle,SizeOf(THumInfo) * n08 + SizeOf(TDBHeader),0) <> -1 then begin
    FileRead(m_nFileHandle,HumDBRecord,SizeOf(THumInfo));
    FileSeek(m_nFileHandle,-SizeOf(THumInfo) * n08 + SizeOf(TDBHeader),1);
    n4:=n08;
    Result:=True;
  end else Result:=False;
end;

function TFileHumDB.FindByName(sChrName: String;
  ChrList: TStringList): Integer;//0x0048C3E0
var
  I:Integer;
begin
  for I:= 0 to m_QuickList.Count - 1 do begin
    if CompareLStr(m_QuickList.Strings[I],sChrName,length(sChrName)) then begin
      ChrList.AddObject(m_QuickList.Strings[I],m_QuickList.Objects[I]);
    end;
  end;
  Result:=ChrList.Count;
end;

function TFileHumDB.GetBy(n08: Integer;
  var HumDBRecord: THumInfo): Boolean;//0x0048C118
begin
  if n08 >= 0 then
    Result:=GetRecord(n08,HumDBRecord)
  else Result:= False;
end;

function TFileHumDB.FindByAccount(sAccount: String;
  var ChrList: TStringList): Integer;//0x0048C4DC
var
  ChrNameList:TList;
  QuickID:pTQuickID;
  i:Integer;
begin
  ChrNameList:=nil;
  m_QuickIDList.GetChrList(sAccount,ChrNameList);
  if ChrNameList <> nil then begin
    for i:= 0 to ChrNameList.Count - 1 do begin
      QuickID:=ChrNameList.Items[i];
      ChrList.AddObject(QuickID.sAccount,TObject(QuickID));
    end;
  end;
  Result:=ChrList.Count;
end;

function TFileHumDB.ChrCountOfAccount(sAccount: String): Integer;//0x0048C5B0
var
  ChrList:TList;
  I,n18:Integer;
  HumDBRecord: THumInfo;
begin
  n18:=0;
  ChrList:=nil;
  m_QuickIDList.GetChrList(sAccount,ChrList);
  if ChrList <> nil then begin
    for I:= 0 to ChrList.Count - 1 do begin
      if GetBy(pTQuickID(ChrList.Items[I]).nIndex,HumDBRecord) and
         not HumDBRecord.boDeleted then Inc(n18);
    end;
  end;
  Result:=n18;  
end;

function TFileHumDB.Add(HumRecord: THumInfo): Boolean;//0x0048C1F4
var
  Header:TDBHeader;
  nIndex:Integer;
begin
  if m_QuickList.GetIndex(HumRecord.Header.sName) >= 0 then Result:=False
  else begin
    Header:=m_Header;
    if m_DeletedList.Count > 0 then begin
      nIndex:=Integer(m_DeletedList.Items[0]);
      m_DeletedList.Delete(0);
    end else begin
      nIndex:=m_Header.nHumCount;
      Inc(m_Header.nHumCount);
    end;
    if UpdateRecord(nIndex,HumRecord,True) then begin
      m_QuickList.AddRecord(HumRecord.Header.sName,nIndex);
      m_QuickIDList.AddRecord(HumRecord.sAccount,HumRecord.sChrName,nIndex,HumRecord.Header.nSelectID);
      Result:=True;
    end else begin
      m_Header:=Header;
      Result:=False;
    end;
  end;
end;

function TFileHumDB.UpdateRecord(nIndex: Integer; HumRecord: THumInfo;
  boNew: Boolean): Boolean;//0x0048BF5C
var
  HumRcd:THumInfo;
  nPosion,n10:Integer;
begin
  nPosion:=nIndex * SizeOf(THumInfo) + SizeOf(TDBHeader);
  if FileSeek(m_nFileHandle,nPosion,0) = nPosion then begin
    n10:=FileSeek(m_nFileHandle,0,1);
    if boNew and
       (FileRead(m_nFileHandle,HumRcd,SizeOf(THumInfo)) = SizeOf(THumInfo)) and
       (not HumRcd.Header.boDeleted) and (HumRcd.Header.sName <> '') then Result:=True
    else begin
      HumRecord.Header.boDeleted:=False;
      HumRecord.Header.dCreateDate:=Now();
      m_Header.dUpdateDate:=Now();
      FileSeek(m_nFileHandle,0,0);
      FileWrite(m_nFileHandle,m_Header,SizeOf(TDBHeader));
      FileSeek(m_nFileHandle,n10,0);
      FileWrite(m_nFileHandle,HumRecord,SizeOf(THumInfo));
      FileSeek(m_nFileHandle,-SizeOf(THumInfo),1);
      n4:=nIndex;
      m_boChanged:=True;
      Result:=True;
    end;
  end else Result:=False;
end;

function TFileHumDB.Delete(sName: String): Boolean;//0x0048BDE0
var
  n10:integer;
  HumRecord:THumInfo;
  ChrNameList:TList;
  n14:Integer;
begin
  Result:=False;
  n10:=m_QuickList.GetIndex(sName);
  if n10 < 0 then exit;
  Get(n10,HumRecord);
  if DeleteRecord(Integer(m_QuickList.Objects[n10])) then begin
    m_QuickList.Delete(n10);
    Result:=True;
  end;
  n14:=m_QuickIDList.GetChrList(HumRecord.sAccount,ChrNameList);
  if n14 >= 0 then begin
    m_QuickIDList.DelRecord(n14,HumRecord.sChrName);
  end;

end;

function TFileHumDB.DeleteRecord(nIndex: Integer): Boolean;//0x0048BD58
var
  HumRcdHeader:TRecordHeader;
begin
  Result:=False;
  if FileSeek(m_nFileHandle,nIndex * SizeOf(THumInfo) + SizeOf(TDBHeader),0) = -1 then exit;
  HumRcdHeader.boDeleted:=True;
  HumRcdHeader.dCreateDate:=Now();
  FileWrite(m_nFileHandle,HumRcdHeader,SizeOf(TRecordHeader));
  m_DeletedList.Add(Pointer(nIndex));
  m_boChanged:=True;
  Result:=True;
end;

function TFileHumDB.Update(nIndex: Integer;var HumDBRecord: THumInfo): Boolean;//0x0048C14C
begin
  Result:=False;
  if nIndex < 0 then exit;
  if m_QuickList.Count <= nIndex then exit;
  if UpdateRecord(Integer(m_QuickList.Objects[nIndex]),HumDBRecord,False) then Result:=True;
end;



function TFileHumDB.UpdateBy(nIndex: Integer;  var HumDBRecord: THumInfo): Boolean;//00048C1B4
begin
  Result:=False;
  if UpdateRecord(nIndex,HumDBRecord,False) then Result:=True;    
end;

{ TFileDB }



constructor TFileDB.Create(sFileName: String);//0x0048A0F4
begin
  n4            := 0;
  boDataDBReady := False;
  m_sDBFileName := sFileName;
  m_sIdxFileName:= sFileName + '.idx';
  m_QuickList   := TQuickList.Create;
  m_DeletedList := TList.Create;
  n4ADAE4       := 0;
  n4ADAF0       := 0;
  m_nLastIndex  := -1;
  if LoadDBIndex then boDataDBReady:=True
  else LoadQuickList();
end;
destructor TFileDB.Destroy;
begin
  if boDataDBReady then SaveIndex();
    
  m_QuickList.Free;
  m_DeletedList.Free;
  inherited;
end;
function TFileDB.LoadDBIndex: Boolean;//0x0048AA6C
var
  nIdxFileHandle :Integer;
  IdxHeader      :TIdxHeader;
  DBHeader       :TDBHeader;
  IdxRecord      :TIdxRecord;
  HumRecord      :THumDataInfo;
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
          if IdxHeader.nHumCount <> DBHeader.nHumCount then
            Result:=False;
          if IdxHeader.sDesc <> sDBIdxHeaderDesc then
            Result:=False;
        end;//0x0048AB65
        if IdxHeader.nLastIndex <> DBHeader.nLastIndex then begin
          Result:=False;
        end;
        if IdxHeader.nLastIndex > -1 then begin
          FileSeek(m_nFileHandle,IdxHeader.nLastIndex * SizeOf(THumDataInfo) + SizeOf(TDBHeader),0);
          if FileRead(m_nFileHandle,HumRecord,SizeOf(THumDataInfo)) = SizeOf(THumDataInfo) then
            if IdxHeader.dUpdateDate <> HumRecord.Header.dCreateDate then
              Result:=False;
        end;
      end; //0x0048ABD7
    finally
      Close();
    end;
    if Result then begin
      m_nLastIndex:=IdxHeader.nLastIndex;
      m_dUpdateTime:=IdxHeader.dUpdateDate;
      for i:=0 to IdxHeader.nQuickCount -1 do begin
        if FileRead(nIdxFileHandle,IdxRecord,SizeOf(TIdxRecord)) = SizeOf(TIdxRecord) then begin
          m_QuickList.AddObject(IdxRecord.sChrName,TObject(IdxRecord.nIndex));
        end else begin
          Result:=False;
          break;
        end;
      end; //0048AC7A
      for i:=0 to IdxHeader.nDeleteCount -1 do begin
        if FileRead(nIdxFileHandle,n14,SizeOf(Integer)) = SizeOf(Integer) then
          m_DeletedList.Add(Pointer(n14))
        else begin
          Result:=False;
          break;
        end;
      end;
    end; //0048ACC5
    FileClose(nIdxFileHandle);
  end; //0048ACCD
  if Result then begin
    n4ADAE4:=m_QuickList.Count;
    n4ADAE8:=m_QuickList.Count;
    n4ADAF0:=DBHeader.nHumCount;
    m_QuickList.SortString(0,m_QuickList.Count -1);
  end else m_QuickList.Clear;
end;

procedure TFileDB.LoadQuickList;//0x0048A440
var
  nIndex       :Integer;
  DBHeader     :TDBHeader;
  RecordHeader :TRecordHeader;
begin
  n4:=0;
  m_QuickList.Clear;
  m_DeletedList.Clear;
  n4ADAE4:=0;
  n4ADAE8:=0;
  n4ADAF0:=0;
  try
    if Open then begin
      FileSeek(m_nFileHandle,0,0);
      if FileRead(m_nFileHandle,DBHeader,SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
        n4ADAF0:=DBHeader.nHumCount;
        for nIndex:=0 to DBHeader.nHumCount - 1 do begin
          Inc(n4ADAE4);
          if FileSeek(m_nFileHandle,nIndex * SizeOf(THumDataInfo) + SizeOf(TDBHeader),0) = -1 then break;
          if FileRead(m_nFileHandle,RecordHeader,SizeOf(TRecordHeader)) <> SizeOf(TRecordHeader) then break;
          if not RecordHeader.boDeleted then begin
            if RecordHeader.sName <> '' then begin
              m_QuickList.AddObject(RecordHeader.sName,TObject(nIndex));
              Inc(n4ADAE8);
            end else m_DeletedList.Add(TObject(nIndex));
          end else begin
            m_DeletedList.Add(TObject(nIndex));
            Inc(n4ADAEC);
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
  m_nLastIndex:=m_Header.nLastIndex;
  m_dUpdateTime:=m_Header.dLastDate;
  boDataDBReady:=True;
end;

procedure TFileDB.Lock;//00048A254
begin
  EnterCriticalSection(HumDB_CS);
end;
procedure TFileDB.UnLock;//0048A268
begin
  LeaveCriticalSection(HumDB_CS);
end;

function TFileDB.Open: Boolean;//0048A304
begin
  Lock();
  n4:=0;
  m_boChanged:=False;
  if FileExists(m_sDBFileName) then begin
    m_nFileHandle:=FileOpen(m_sDBFileName,fmOpenReadWrite or fmShareDenyNone);
    if m_nFileHandle > 0 then
      FileRead(m_nFileHandle,m_Header,SizeOf(TDBHeader));
  end else begin //0048B999
    m_nFileHandle:=FileCreate(m_sDBFileName);
    if m_nFileHandle > 0 then begin
      FillChar(m_Header,SizeOf(TDBHeader),#0);
      m_Header.sDesc:= sDBHeaderDesc;
      m_Header.nHumCount:=0;
      m_Header.n6C:=0;
      FileWrite(m_nFileHandle,m_Header,SizeOf(TDBHeader));
    end;
  end;
  if m_nFileHandle > 0 then Result:=True
  else Result:=False;
end;

procedure TFileDB.Close;//0x0048A400
begin
  FileClose(m_nFileHandle);
  if m_boChanged and Assigned(m_OnChange) then begin
    m_OnChange(Self);
  end;
  UnLock();
end;


function TFileDB.OpenEx: Boolean;//0x0048A27C
var
  DBHeader:TDBHeader;
begin
  Lock();
  m_boChanged:=False;
  m_nFileHandle:=FileOpen(m_sDBFileName,fmOpenReadWrite or fmShareDenyNone);
  if m_nFileHandle > 0 then begin
    Result:=True;
    if FileRead(m_nFileHandle,DBHeader,SizeOf(TDBHeader)) = SizeOf(TDBHeader) then
      m_Header:=DBHeader;
    n4:=0;
  end else Result:=False;
end;

function TFileDB.Index(sName: String): Integer;//0x0048B534
begin
  Result:=m_QuickList.GetIndex(sName);
end;

function TFileDB.Get(nIndex: Integer; var HumanRCD: THumDataInfo):Integer;//0x0048B320
var
  nIdx:Integer;
begin
  nIdx:=Integer(m_QuickList.Objects[nIndex]);
  if GetRecord(nIdx,HumanRCD) then Result:=nIdx
  else Result:= -1;
end;

function TFileDB.Update(nIndex: Integer;
  var HumanRCD: THumDataInfo): Boolean;//0x0048B36C
begin
  Result:=False;
  if (nIndex >= 0) and (m_QuickList.Count > nIndex) then
    if UpdateRecord(Integer(m_QuickList.Objects[nIndex]),HumanRCD,False) then Result:=True;
end;

function TFileDB.Add(var HumanRCD: THumDataInfo): Boolean;//0x0048B3E0
var
  sHumanName :String;
  DBHeader   :TDBHeader;
  nIdx       :Integer;
begin
  sHumanName:=HumanRCD.Header.sName;
  if m_QuickList.GetIndex(sHumanName) >= 0 then begin
    Result:=False;
  end else begin
    DBHeader:=m_Header;
    if m_DeletedList.Count > 0 then begin
      nIdx:=Integer(m_DeletedList.Items[0]);
      m_DeletedList.Delete(0);
    end else begin
      nIdx:=m_Header.nHumCount;
      Inc(m_Header.nHumCount);
    end;
    if UpdateRecord(nIdx,HumanRCD,True) then begin
      m_QuickList.AddRecord(HumanRCD.Header.sName,nIdx);
      Result:=True;
    end else begin
      m_Header:=DBHeader;
      Result:=False;
    end;
  end;
end;

function TFileDB.GetRecord(nIndex: Integer;
  var HumanRCD: THumDataInfo): Boolean;//0x0048B0C8
begin
  if FileSeek(m_nFileHandle,nIndex * SizeOf(THumDataInfo) + SizeOf(TDBHeader),0) <> -1 then begin
    FileRead(m_nFileHandle,HumanRCD,SizeOf(THumDataInfo));
    FileSeek(m_nFileHandle,-SizeOf(THumDataInfo),1);
    n4:=nIndex;
    Result:=True;
  end else Result:=False;
end;

function TFileDB.UpdateRecord(nIndex: Integer;
  var HumanRCD: THumDataInfo;boNew:Boolean): Boolean;//0x0048B134
var
  nPosion,n10:Integer;
  dt20     :TDateTime;
  ReadRCD  :THumDataInfo;
begin
  nPosion:=nIndex * SizeOf(THumDataInfo) + SizeOf(TDBHeader);
  if FileSeek(m_nFileHandle,nPosion,0) = nPosion then begin
    dt20:=Now();
    m_nLastIndex:=nIndex;
    m_dUpdateTime:=dt20;
    n10:=FileSeek(m_nFileHandle,0,1);
    if boNew
       and (FileRead(m_nFileHandle,ReadRCD,SizeOf(THumDataInfo)) = SizeOf(THumDataInfo))
       and not ReadRCD.Header.boDeleted and (ReadRCD.Header.sName <> '') then begin
      Result:=False;
    end else begin //0048B1F5
      HumanRCD.Header.boDeleted   :=False;
      HumanRCD.Header.dCreateDate :=Now();
      m_Header.nLastIndex         :=m_nLastIndex;
      m_Header.dLastDate          :=m_dUpdateTime;
      m_Header.dUpdateDate        :=Now();
      FileSeek(m_nFileHandle,0,0);
      FileWrite(m_nFileHandle,m_Header,SizeOf(TDBHeader));
      FileSeek(m_nFileHandle,n10,0);
      FileWrite(m_nFileHandle,HumanRCD,SizeOf(THumDataInfo));
      FileSeek(m_nFileHandle,-SizeOf(THumDataInfo),1);
      n4:=nIndex;
      m_boChanged:=True;
      Result:=True;
    end;
  end else Result:=False;
end;



function TFileDB.Find(sChrName: String;
  List: TStrings): Integer;//0x0048B590
var
  I: Integer;
begin
  for I := 0 to m_QuickList.Count - 1 do begin
    if CompareLStr(m_QuickList.Strings[i],sChrName,length(sChrName)) then begin
      List.AddObject(m_QuickList.Strings[i],m_QuickList.Objects[i]);
    end;
  end;
  Result:=List.Count;  
end;

function TFileDB.Delete(nIndex: Integer): Boolean;//0x0048AF4C
var
  I: Integer;
  s14:String;
begin
  Result:=False;
  for I := 0 to m_QuickList.Count - 1 do begin
    if Integer(m_QuickList.Objects[i]) = nIndex then begin
      s14:=m_QuickList.Strings[i];
      if DeleteRecord(nIndex) then begin
        m_QuickList.Delete(i);
        Result:=True;
        break;
      end;
    end;
  end;
end;

function TFileDB.DeleteRecord(nIndex: Integer): Boolean;//0x0048AD8C
var
  ChrRecordHeader:TRecordHeader;
begin
  Result:=False;
  if FileSeek(m_nFileHandle,nIndex * SizeOf(THumDataInfo) + SizeOf(TDBHeader),0) = -1 then exit;
  m_nLastIndex                :=nIndex;
  m_dUpdateTime               :=Now();
  ChrRecordHeader.boDeleted   :=True;
  ChrRecordHeader.dCreateDate :=Now();
  FileWrite(m_nFileHandle,ChrRecordHeader,SizeOf(TRecordHeader));
  m_DeletedList.Add(Pointer(nIndex));
  m_Header.nLastIndex           :=m_nLastIndex;
  m_Header.dLastDate            :=m_dUpdateTime;
  m_Header.dUpdateDate          :=Now();
  FileSeek(m_nFileHandle,0,0);
  FileWrite(m_nFileHandle,m_Header,SizeOf(TDBHeader));
  m_boChanged:=True;
  Result:=True;
end;

procedure TFileDB.Rebuild;//0x0048A688
var
  sTempFileName:String;
  nHandle,n10:Integer;
  DBHeader:TDBHeader;
  ChrRecord:THumDataInfo;
begin
  sTempFileName:='Mir#$00.DB';
  if FileExists(sTempFileName) then
    DeleteFile(sTempFileName);
  nHandle:=FileCreate(sTempFileName);
  n10:=0;
  if nHandle < 0 then exit;
  try
    if Open then begin
      FileSeek(m_nFileHandle,0,0);
      if FileRead(m_nFileHandle,DBHeader,SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
        FileWrite(nHandle,DBHeader,SizeOf(TDBHeader));
        while(True) do begin
          if FileRead(m_nFileHandle,ChrRecord,SizeOf(THumDataInfo)) = SizeOf(THumDataInfo) then begin
            if ChrRecord.Header.boDeleted then Continue;
            FileWrite(nHandle,ChrRecord,SizeOf(THumDataInfo));
            Inc(n10);
          end else break;
        end;
        DBHeader.nHumCount:=n10;
        DBHeader.dUpdateDate:=Now();
        FileSeek(nHandle,0,0);
        FileWrite(nHandle,DBHeader,SizeOf(TDBHeader));
      end;
    end;
  finally
    Close;
  end;
  FileClose(nHandle);
  FileCopy(sTempFileName,m_sDBFileName);
  DeleteFile(sTempFileName);
end;

function TFileDB.Count: Integer;
begin
  Result:=m_QuickList.Count;
end;

function TFileDB.Delete(sChrName: String): Boolean;//0x0048AEB4
var
  n10:Integer;
begin
  Result:=False;
  n10:=m_QuickList.GetIndex(sChrName);
  if n10 < 0 then exit;
  if DeleteRecord(Integer(m_QuickList.Objects[n10])) then begin
    m_QuickList.Delete(n10);
    Result:=True;
  end;    
end;



procedure TFileDB.SaveIndex;//0x0048A83C
var
  IdxHeader      :TIdxHeader;
  nIdxFileHandle :Integer;
  I              :Integer;
  nDeletedIdx    :Integer;
  IdxRecord      :TIdxRecord;
begin
  FillChar(IdxHeader,SizeOf(TIdxHeader),#0);
  IdxHeader.sDesc        := sDBIdxHeaderDesc;
  IdxHeader.nQuickCount  := m_QuickList.Count;
  IdxHeader.nHumCount    := m_Header.nHumCount;
  IdxHeader.nDeleteCount := m_DeletedList.Count;
  IdxHeader.nLastIndex   := m_nLastIndex;
  IdxHeader.dUpdateDate  := m_dUpdateTime;
  if FileExists(m_sIdxFileName) then
    nIdxFileHandle:=FileOpen(m_sIdxFileName,fmOpenReadWrite or fmShareDenyNone)
  else nIdxFileHandle:=FileCreate(m_sIdxFileName);

  if nIdxFileHandle > 0 then begin
    FileWrite(nIdxFileHandle,IdxHeader,SizeOf(TIdxHeader));
    for I := 0 to  m_QuickList.Count - 1 do begin
      IdxRecord.sChrName:=m_QuickList.Strings[I];
      IdxRecord.nIndex:=Integer(m_QuickList.Objects[I]);
      FileWrite(nIdxFileHandle,IdxRecord,SizeOf(TIdxRecord));
    end;
    for I := 0 to  m_DeletedList.Count - 1 do begin
      nDeletedIdx:=Integer(m_DeletedList.Items[I]);
      FileWrite(nIdxFileHandle,nDeletedIdx,SizeOf(Integer));
    end;
    FileClose(nIdxFileHandle);
  end;
end;

end.
