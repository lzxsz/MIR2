unit MudUtil;

interface
uses
  Windows,Classes,SysUtils;
type
  TQuickID = record
    sAccount    :String[16];  //0x00
    sChrName    :String[20];  //0x15
    nIndex      :Integer;     //0x34
    nSelectID   :Integer;
  end;
  pTQuickID =^TQuickID;
  TQuickList = class(TStringList)
  private
    CriticalSection:TRTLCriticalSection;
    function GetCaseSensitive: Boolean;
    procedure SetCaseSensitive(const Value: Boolean);
  public
    Constructor Create;
    Destructor  Destroy;override;
    procedure SortString(nMin,nMax:Integer);
    function  GetIndex(sName:String):Integer;
    function  AddRecord(sName:String;nIndex:Integer):Boolean;
    procedure Lock;
    procedure UnLock;
  published
    property boCaseSensitive:Boolean read GetCaseSensitive write SetCaseSensitive;
  end;
  TQuickIDList = class(TStringList)
  public
    procedure AddRecord(sAccount, sChrName:String;nIndex,nSelIndex: Integer);
    procedure DelRecord(nIndex:Integer;sChrName:String);
    function  GetChrList(sAccount:String;var ChrNameList:TList):Integer;
  end;

implementation

{ TQuickIDList }

procedure TQuickIDList.AddRecord(sAccount, sChrName:String;nIndex,nSelIndex: Integer);
//0x0045B750
var
  QuickID:pTQuickID;
  ChrList:TList;
  nLow,nHigh,nMed,n1C,n20:Integer;
begin
  New(QuickID);
  QuickID.sAccount:=sAccount;
  QuickID.sChrName:=sChrName;
  QuickID.nIndex:=nIndex;
  QuickID.nSelectID:=nSelIndex;
  if Count = 0 then begin
    ChrList:=TList.Create;
    ChrList.Add(QuickID);
    AddObject(sAccount,ChrList);
  end else begin //0x0045B839
    if Count= 1 then begin
      nMed:=CompareStr(sAccount,Self.Strings[0]);
      if nMed > 0 then begin
        ChrList:=TList.Create;
        ChrList.Add(QuickID);
        AddObject(sAccount,ChrList);
      end else begin //0x0045B89C
        if nMed < 0 then begin
          ChrList:=TList.Create;
          ChrList.Add(QuickID);
          InsertObject(0,sAccount,ChrList);
        end else begin
          ChrList:=TList(Self.Objects[0]);
          ChrList.Add(QuickID);
        end;
      end;
    end else begin //0x0045B8EF
      nLow:=0;
      nHigh:=Self.Count -1;
      nMed:=(nHigh - nLow) div 2 + nLow;
      while (true) do begin
        if (nHigh - nLow) = 1 then begin
          n20:=CompareStr(sAccount,Self.Strings[nHigh]);
          if n20 > 0 then begin
            ChrList:=TList.Create;
            ChrList.Add(QuickID);
            InsertObject(nHigh + 1,sAccount,ChrList);
            break;
          end else begin
            if CompareStr(sAccount,Self.Strings[nHigh]) = 0 then begin
              ChrList:=TList(Self.Objects[nHigh]);
              ChrList.Add(QuickID);
              break;
            end else begin //0x0045B9BB
              n20:=CompareStr(sAccount,Self.Strings[nLow]);
              if n20 > 0 then begin
                ChrList:=TList.Create;
                ChrList.Add(QuickID);
                InsertObject(nLow + 1,sAccount,ChrList);
                break;
              end else begin
                if n20 < 0 then begin
                  ChrList:=TList.Create;
                  ChrList.Add(QuickID);
                  InsertObject(nLow,sAccount,ChrList);
                  break;
                end else begin
                  ChrList:=TList(Self.Objects[n20]);
                  ChrList.Add(QuickID);
                  break;
                end;
              end;
            end;
          end;

        end else begin //0x0045BA6A
          n1C:=CompareStr(sAccount,Self.Strings[nMed]);
          if n1C > 0 then begin
            nLow:=nMed;
            nMed:=(nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          if n1C < 0 then begin
            nHigh:=nMed;
            nMed:=(nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          ChrList:=TList(Self.Objects[nMed]);
          ChrList.Add(QuickID);
          break;
        end;
      end;
    end;
  end;
end;

procedure TQuickIDList.DelRecord(nIndex: Integer; sChrName: String);
//0x0045BCEC
var
  QuickID:pTQuickID;
  ChrList:TList;
  i:integer;
begin
  if (Self.Count - 1) < nIndex then exit;
  ChrList:=TList(Self.Objects[nIndex]);
  for i:= 0 to ChrList.Count - 1 do begin
    QuickID:=ChrList.Items[i];
    if QuickID.sChrName = sChrName then begin
      Dispose(QuickID);
      ChrList.Delete(i);
      break;
    end;
  end;
  if ChrList.Count <= 0 then begin
    ChrList.Free;
    Self.Delete(nIndex);
  end;
    
end;

function TQuickIDList.GetChrList(sAccount: String;
  var ChrNameList: TList): Integer;
//0x0045BB28
var
  nHigh,nLow,nMed,n20,n24:Integer;
begin
  Result:= -1;
  if Self.Count = 0 then exit;
  if Self.Count = 1 then begin
    if CompareStr(sAccount,Self.Strings[0]) = 0 then begin
      ChrNameList:=TList(Self.Objects[0]);
      Result:= 0;
    end;
  end else begin //0x0045BBB7
    nLow:=0;
    nHigh:=Self.Count -1;
    nMed:=(nHigh-nLow) div 2 + nLow;
    n24:= -1;
    while (True) do begin
      if (nHigh - nLow) = 1 then begin
        if CompareStr(sAccount,Self.Strings[nHigh]) = 0 then n24:=nHigh;
        if CompareStr(sAccount,Self.Strings[nLow]) = 0 then n24:=nLow;
        break;
      end else begin
        n20:=CompareStr(sAccount,Self.Strings[nMed]);
        if n20 > 0 then begin
          nLow:=nMed;
          nMed:=(nHigh-nLow) div 2 + nLow;
          Continue;
        end;
        if n20 < 0 then begin
          nHigh:=nMed;
          nMed:=(nHigh-nLow) div 2 + nLow;
          Continue;
        end;
        n24:=nMed;
        break;
      end;
    end;
    if n24 <> -1 then ChrNameList:=TList(Self.Objects[n24]);
    Result:= n24;
  end;
end;

{ TQuickList }

function TQuickList.GetIndex(sName: String): Integer;
//0x0045B498
var
  nLow,nHigh,nMed,nCompareVal:Integer;
  s:string;
begin
  Result:= -1;
  if Self.Count <> 0 then begin
    if Self.Sorted then begin
      if Self.Count = 1 then begin
        if CompareStr(sName,Self.Strings[0]) = 0 then Result:=0;   // - > 0x0045B71D
      end else begin //0x0045B51E
        nLow:=0;
        nHigh:=Self.Count -1;
        nMed:=(nHigh - nLow) div 2 + nLow;
        while (true) do begin
          if (nHigh - nLow) = 1 then begin
            if CompareStr(sName,Self.Strings[nHigh]) = 0 then Result:=nHigh;
            if CompareStr(sName,Self.Strings[nLow]) = 0 then Result:=nLow;
            break; // - > 0x0045B71D
          end else begin; //0x0045B59A
            nCompareVal:=CompareStr(sName,Self.Strings[nMed]);
            if nCompareVal > 0 then begin
              nLow:=nMed;
              nMed:=(nHigh - nLow) div 2 + nLow;
              Continue;
            end; //0x0045B5DA
            if nCompareVal < 0 then begin
              nHigh:=nMed;
              nMed:=(nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            Result:=nMed;
            break;
          end; //0x0045B609
        end;
      end;
    end else begin //0x0045B609
      if Self.Count = 1 then begin
        if CompareText(sName,Self.Strings[0]) = 0 then Result:=0;
      end else begin

        nLow:=0;
        nHigh:=Self.Count - 1;
        nMed:=(nHigh - nLow) div 2 + nLow;
        while (true) do begin
          if (nHigh - nLow) = 1 then begin
            if CompareText(sName,Self.Strings[nHigh]) = 0 then Result:=nHigh;
            if CompareText(sName,Self.Strings[nLow]) = 0 then Result:=nLow;
            break;  
          end else begin //0x0045B6B3
            nCompareVal:=CompareText(sName,Self.Strings[nMed]);
            if nCompareVal > 0 then begin
              nLow:=nMed;
              nMed:=(nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            if nCompareVal < 0 then begin
              nHigh:=nMed;
              nMed:=(nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            Result:=nMed;
            break;
          end;
        end;         
      end;            
    end; //0x0045B71D 
  end;
  
end;

procedure TQuickList.SortString(nMin, nMax: Integer);
//0x0045AF78
var
  ntMin,ntMax:Integer;
  s18:String;
begin
  if Self.Count > 0 then
    while (True) do begin
      ntMin:=nMin;
      ntMax:=nMax;
      s18:=Self.Strings[(nMin + nMax) shr 1];
      while (True) do begin
        while (CompareText(Self.Strings[ntMin],s18) < 0) do Inc(ntMin);
        while (CompareText(Self.Strings[ntMax],s18) > 0) do Dec(ntMax);
        if ntMin <= ntMax then begin
          Self.Exchange(ntMin,ntMax);
          Inc(ntMin);
          Dec(ntMax);
        end;
        if ntMin > ntMax then break
      end;
      if nMin < ntMax then SortString(nMin,ntMax);
      nMin:=ntMin;
      if ntMin >= nMax then break;
    end;
end;

function TQuickList.AddRecord(sName: String; nIndex: Integer): Boolean;
//0x0045B0D0
var
  nLow,nHigh,nMed,nCompareVal:Integer;
begin
  Result:=True;
  if Self.Count = 0 then begin
    Self.AddObject(sName,TObject(nIndex));
  end else begin //0x0045B133
    if Self.Sorted then begin
      if Self.Count = 1 then begin
        nMed:=CompareStr(sName,Self.Strings[0]);
        if nMed > 0 then
          Self.AddObject(sName,TObject(nIndex))
        else begin
          if nMed < 0 then Self.InsertObject(0,sName,TObject(nIndex));
        end;
      end else begin //0x0045B19F
        nLow:=0;
        nHigh:=Self.Count -1;
        nMed:=(nHigh - nLow) div 2 + nLow;
        while (true) do begin
          if (nHigh - nLow) = 1 then begin
            nMed:=CompareStr(sName,Self.Strings[nHigh]);
            if nMed > 0 then begin
              Self.InsertObject(nHigh + 1,sName,TObject(nIndex));
              break;
            end else begin
              nMed:=CompareStr(sName,Self.Strings[nLow]);
              if nMed > 0 then begin
                Self.InsertObject(nLow + 1,sName,TObject(nIndex));
                break;
              end else begin
                if nMed < 0 then begin
                  Self.InsertObject(nLow,sName,TObject(nIndex));
                  break;;
                end else begin
                  Result:=False;
                  break;
                end;
              end;
            end;
          end else begin //0x0045B26A
            nCompareVal:=CompareStr(sName,Self.Strings[nMed]);
            if nCompareVal > 0 then begin
              nLow:=nMed;
              nMed:=(nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            if nCompareVal < 0 then begin
              nHigh:=nMed;
              nMed:=(nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            Result:=False;
            break;
          end;
        end;
      end;
    end else begin
      if Self.Count = 1 then begin
        nMed:=CompareText(sName,Self.Strings[0]);
        if nMed > 0 then
          Self.AddObject(sName,TObject(nIndex))
        else begin
          if nMed < 0 then Self.InsertObject(0,sName,TObject(nIndex));
        end;
      end else begin //
        nLow:=0;
        nHigh:=Self.Count -1;
        nMed:=(nHigh - nLow) div 2 + nLow;
        while (true) do begin
          if (nHigh - nLow) = 1 then begin
            nMed:=CompareText(sName,Self.Strings[nHigh]);
            if nMed > 0 then begin
              Self.InsertObject(nHigh + 1,sName,TObject(nIndex));
              break;
            end else begin
              nMed:=CompareText(sName,Self.Strings[nLow]);
              if nMed > 0 then begin
                Self.InsertObject(nLow + 1,sName,TObject(nIndex));
                break;
              end else begin
                if nMed < 0 then begin
                  Self.InsertObject(nLow,sName,TObject(nIndex));
                  break;
                end else begin
                  Result:=False;
                  break;
                end;
              end;
            end;
          end else begin //0x0045B26A
           nCompareVal:=CompareText(sName,Self.Strings[nMed]);
            if nCompareVal > 0 then begin
              nLow:=nMed;
              nMed:=(nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            if nCompareVal < 0 then begin
              nHigh:=nMed;
              nMed:=(nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            Result:=False;
            break;
          end;
        end;
      end;
    end;
  end;
end;

function TQuickList.GetCaseSensitive: Boolean;
begin
  result:=CaseSensitive;
end;

procedure TQuickList.SetCaseSensitive(const Value: Boolean);
begin
  CaseSensitive:=Value;
end;

procedure TQuickList.Lock;
begin
  EnterCriticalSection(CriticalSection);
end;

procedure TQuickList.UnLock;
begin
  LeaveCriticalSection(CriticalSection);
end;

constructor TQuickList.Create;
begin
  inherited;
  InitializeCriticalSection(CriticalSection);
end;

destructor TQuickList.Destroy;
begin
  DeleteCriticalSection(CriticalSection);
  inherited;
end;

end.







