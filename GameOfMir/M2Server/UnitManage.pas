unit UnitManage;

interface
uses
  WIndows,SDK,grobal2;
type
  TThreadInfo = record
    nRunFlag     :Integer;  //0x00
    boActived    :BOOL;  //0x04
    dwRunTick    :LongWord; //0x08
    Config       :pTM2Config;  //0x0C
    boTerminaled :BOOL;     //0x10
    hThreadHandle:THandle;  //0x14
    dwThreadID   :LongWord; //0x18   
    n1C          :Integer;  //0x1C
    n20          :Integer;  //0x20
    n24          :integer;  //0x24
  end;
  pTThreadInfo = ^TThreadInfo;
  procedure StartRegThread(Config:pTM2Config;ThreadInfo:pTThreadInfo);
  procedure RegServerThread(ThreadInfo:pTThreadInfo);stdcall;
implementation
procedure StartRegThread(Config:pTM2Config;ThreadInfo:pTThreadInfo);
begin
  ThreadInfo.Config:=Config;
  ThreadInfo.hThreadHandle:=CreateThread(nil,
                                         0,
                                         @RegServerThread,
                                         ThreadInfo,
                                         0,
                                         ThreadInfo.dwThreadID);
end;
procedure RegServerThread(ThreadInfo:pTThreadInfo);stdcall;
begin

end;
end.
