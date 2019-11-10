unit Parse;

interface

uses Windows,Classes,SysUtils,MudUtil;

type
  TThreadParseList = class(TThread)
  private
    AccountLoadList:TStringList;
    IPaddrLoadList:TStringList;
    AccountCostList:TQuickList;
    IPaddrCostList:TQuickList;
    bo40:Boolean;
    { Private declarations }

  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;      
  end;

implementation

uses LSShare, HUtil32, LMain;



{ Important: Methods and properties of objects in VCL or CLX can only be used
  in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure ThreadParseList.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ ThreadParseList }

constructor TThreadParseList.Create(CreateSuspended: Boolean);
begin
  inherited;
  AccountLoadList:=TStringList.Create;
  IPaddrLoadList:=TStringList.Create;
  AccountCostList:=TQuickList.Create;
  IPaddrCostList:=TQuickList.Create;
  bo40:=False;
end;

destructor TThreadParseList.Destroy;
begin
   AccountLoadList.Free;
   IPaddrLoadList.Free;
   AccountCostList.Free;
   IPaddrCostList.Free;
  inherited;
end;

procedure TThreadParseList.Execute;
var
  I: Integer;
  dwTick2C:LongWord;
  s18,s1C,s24,s28:String;
  nC,n10,n14:Integer;
  Config  :pTConfig;
begin
  Config:=@g_Config;
  dwTick2C:=0;
  while (True) do begin
    if (GetTickCount - dwTick2C) > 5 * 60 * 1000 then begin
      dwTick2C:=GetTickCount();
      try
        if FileExists(Config.sFeedIDList) then begin
          AccountLoadList.Clear;
          AccountLoadList.LoadFromFile(Config.sFeedIDList);
          if AccountLoadList.Count > 0 then begin
            AccountCostList.Clear;
            for I := 0 to AccountLoadList.Count - 1 do begin
              s18:=Trim(AccountLoadList.Strings[i]);
              s18:=GetValidStr3(s18,s1C,[' ',#9]);
              s18:=GetValidStr3(s18,s24,[' ',#9]);
              s18:=GetValidStr3(s18,s28,[' ',#9]);
              n10:=Str_ToInt(s24,0);
              n14:=Str_ToInt(s28,0);
              nC:=MakeLong(_MAX(n14,0),_MAX(n10,0));
              AccountCostList.AddRecord(s1C,nC);
              if not bo40 then begin
                if (i mod 100) = 0 then Sleep(1);
              end;
            end;
          end;
          LoadAccountCostList(Config,AccountCostList);
        end;
      except
        MainOutMessage('Exception] loading on IDStrList.');
      end;

      try
        if FileExists(Config.sFeedIPList) then begin
          IPaddrLoadList.Clear;
          IPaddrLoadList.LoadFromFile(Config.sFeedIPList);
          if IPaddrLoadList.Count > 0 then begin
            IPaddrCostList.Clear;
            for I := 0 to IPaddrLoadList.Count - 1 do begin
              s18:=Trim(IPaddrLoadList.Strings[i]);
              s18:=GetValidStr3(s18,s1C,[' ',#9]);
              s18:=GetValidStr3(s18,s24,[' ',#9]);
              s18:=GetValidStr3(s18,s28,[' ',#9]);
              n10:=Str_ToInt(s24,0);
              n14:=Str_ToInt(s28,0);
              nC:=MakeLong(_MAX(n14,0),_MAX(n10,0));
              IPaddrCostList.AddRecord(s1C,nC);
              if not bo40 then begin
                if (i mod 100) = 0 then Sleep(1);
              end;
            end;
          end;
          LoadIPaddrCostList(Config,IPaddrCostList);
        end;
      except
        MainOutMessage('Exception] loading on IPStrList.');
      end;
    end;
    Sleep(10);
    if Self.Terminated then break;      
  end;
end;

end.
