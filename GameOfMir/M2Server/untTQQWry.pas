unit untTQQWry;

interface

uses
  Windows, SysUtils, Classes, StrUtils, Controls, Math;

const  //用于内存文件映射标志
  QQWryMapFileTag = 'QQWryMapFile';

type
  TQQWry = class(TObject)
    public
      constructor Create(AQQWryFileName: string);
      destructor Destroy; override;
      function GetQQWryFileName: string;
      function GetQQWryFileSize: int64;
      function GetIPDataNum: int64;
      function GetQQWryDate: TDate;
      function GetQQWryDataFrom: string;

      procedure GetIPDataByIPRecordID(IPRecordID: int64; var IPData: PChar); overload;
      procedure GetIPLocationByEndIPOffset(EndIPOffset: int64; var IPLocation: PChar);
      procedure GetIPDataByIPRecordID(IPRecordID: int64; var IPData: TStringlist); overload;
      function GetIPValue(IP: string): int64;
      function GetIPDataID(IP: string): int64;
      function ExtractIPDataToTxtFile(ATxtFileName: string): integer;
    private
      QQWryFileName: string;
      QQWryFileSize: int64;
      IPDataNum: int64;
      FirstIPIndexOffset, LastIPIndexOffset: integer;

      hQQWryFile, hQQWryMapFile: THandle;
      pQQWryMapFile: Pointer;
      pQQWryPos: PByte;
      function GetFileSize(AFileName: string): int64;
  end;

implementation

///**
//* 获取文件大小
//* @param  (AFileName) (文件全名)
//* @return (文件大小)
//*/
function TQQWry.GetFileSize(AFileName: string): int64;
var
  FileStream: TFileStream;
begin
  try
    FileStream:=TFileStream.Create(AFileName, fmOpenRead);
  except
    raise Exception.Create(format('文件 %s 无法打开！', [AFileName]));
    exit;
  end;
  result:=FileStream.Size;
  FileStream.Free;
end;

///**
//* 构造函数，构造一个TQQWry即纯真IP数据库处理对象
//* @param (AQQWryFileName) (纯真IP数据库文件的全文件名)
//* @return 无
//*/
constructor TQQWry.Create(AQQWryFileName: string);
var
  Buffer: TOFStruct;
begin
  inherited Create;
  try
    QQWryFileName:='QQWry.Dat';
    //测文件存在
    if not FileExists(QQWryFileName) then
      raise Exception.Create(format('文件 %s 不存在！', [QQWryFileName]));

    //测文件大小
    QQWryFileSize:=GetFileSize(QQWryFileName);
    if QQWryFileSize=0 then
      raise Exception.Create(format('文件 %s 大小为空！', [QQWryFileName]));

    //打开文件句柄
    hQQWryFile:=OpenFile(PChar(QQWryFileName),
                         Buffer,
                         OF_READWRITE);
    if hQQWryFile=-1 then
      raise Exception.Create(format('文件 %s 不能打开！', [QQWryFileName]));

    //创建文件映像对象      
    hQQWryMapFile:=CreateFileMapping(hQQWryFile,
                                     nil,
                                     PAGE_READWRITE,
                                     0,
                                     QQWryFileSize,
                                     PChar(QQWryMapFileTag));
    if hQQWryMapFile=0 then begin
      CloseHandle(hQQWryFile);
      raise Exception.Create('不能创建内存映象文件！');
    end;

    //获取映象文件映射地址
    pQQWryMapFile:=MapViewOfFile(hQQWryMapFile,
                                 FILE_MAP_ALL_ACCESS,
                                 0,
                                 0,
                                 0);
    if pQQWryMapFile=nil then begin
      CloseHandle(hQQWryFile);
      CloseHandle(hQQWryMapFile);
      raise Exception.Create('不能获取文件映射地址！');
    end;

    pQQWryPos:=pQQWryMapFile;
    FirstIPIndexOffset:=PInteger(pQQWryPos)^;
    Inc(pQQWryPos, 4);
    LastIPIndexOffset:=PInteger(pQQWryPos)^;
    IPDataNum:=(LastIPIndexOffset - FirstIPIndexOffset) div 7 + 1;
  except
    on E: Exception do begin
      raise Exception.Create(E.Message);
      exit;
    end;
  end;
end;

///**
//* 析构函数 (释放TQQWry对象，关闭文件映射，关闭文件映像对象句柄，关闭文件句柄)
//* @param  无
//* @return 无
//*/
destructor TQQWry.Destroy;
begin
  if pQQWryMapFile<>nil then UnMapViewOfFile(pQQWryMapFile);  //关闭文件映射
  if hQQWryMapFile<>0 then CloseHandle(hQQWryMapFile);        //关闭文件映像对象句柄
  if hQQWryFile<>0 then CloseHandle(hQQWryFile);              //关闭文件句柄
  inherited Destroy;
end;

///**
//* 获取纯真IP数据库文件的全文件名
//* @param  无
//* @return (纯真IP数据库文件的全文件名)
//*/
function TQQWry.GetQQWryFileName: string;
begin
  Result:=QQWryFileName;
end;

///**
//* 获取纯真IP数据库文件大小
//* @param  无
//* @return (纯真IP数据库文件大小)
//*/
function TQQWry.GetQQWryFileSize: int64;
begin
  Result:=QQWryFileSize;
end;

///**
//* 获取纯真IP数据库内含有的IP地址信息记录数
//* @param  无
//* @return (纯真IP数据库记录数)
//*/
function TQQWry.GetIPDataNum: int64;
begin
  Result:=IPDataNum;
end;

///**
//* 获取当前QQIP数据库的更新日期
//* @param  无
//* @return QQIP当前数据库的更新日期  TDate
//*/
function TQQWry.GetQQWryDate: TDate;
var
  DateString: string;
  IPData: TStringlist;
begin
  IPData:=TStringlist.Create;
  GetIPDataByIPRecordID(GetIPDataNum, IPData);
  DateString:=IPData[3];
  IPData.Free;
  
  DateString:=copy(DateString, 1, pos('IP数据', DateString) - 1);
  DateString:=StringReplace(DateString, '年', '-', [rfReplaceAll, rfIgnoreCase]);
  DateString:=StringReplace(DateString, '月', '-', [rfReplaceAll, rfIgnoreCase]);
  DateString:=StringReplace(DateString, '日', '-', [rfReplaceAll, rfIgnoreCase]);
  Result:=StrToDate(DateString);
end;

///**
//* 获取当前QQIP数据库的来源信息
//* @param  无
//* @return 当前QQIP数据库的来源信息  string
//*/
function TQQWry.GetQQWryDataFrom: string;
var
  FromString: string;
  IPData: TStringlist;
begin
  IPData:=TStringlist.Create;
  GetIPDataByIPRecordID(GetIPDataNum, IPData);
  FromString:=IPData[2];
  IPData.Free;
  Result:=FromString;
end;

///**
//* 给定一个IP地址信息记录号，返回该项记录的信息
//* @param  (IPRecordID, IPData) (IP地址信息记录号, 返回的该条信息：①起始IP 15字节 ②结束IP 15字节 ③国家 ④地区 ⑤回车键2字节)
//* @return 无
//*/
procedure TQQWry.GetIPDataByIPRecordID(IPRecordID: int64; var IPData: PChar);
var
  EndIPOffset: integer;
  i: integer;
  
  pBlank, pReturn: PChar;
  
  IPByteStr: string;
  IPByteStrLen: integer;
  IPDataPos: integer;
  IPLocation: PChar;
begin
  try
    if (IPRecordID<=0) or (IPRecordID>GetIPDataNum) then
      raise Exception.Create('IP信息记录号过小或越界！');
    
    pBlank:='               ';
    pReturn:=#13#10;
    EndIPOffset:=0;
    
    //取内存文件映射首地址
    pQQWryPos:=pQQWryMapFile;
    //根据记录的ID号移到该记录号的索引处，因为高位在后所以从后往前读
    Inc(pQQWryPos, FirstIPIndexOffset + (IPRecordID - 1) * 7 + 3);

    //取始末IP地址
    //索引的前4个字节为该条记录的起始IP地址
    IPDataPos:=0;
    for i:=0 to 3 do begin
      IPByteStr:=IntToStr(pQQWryPos^);
      IPByteStrLen:=Length(IPByteStr);
      CopyMemory(@IPData[IPDataPos], PChar(IPByteStr), IPByteStrLen);
      Inc(IPDataPos, IPByteStrLen);
      if i<>3 then begin
        IPData[IPDataPos]:='.';
        Inc(IPDataPos);
      end;
      dec(pQQWryPos);
    end;
    //填充空格至16位
    CopyMemory(@IPData[IPDataPos], pBlank, 16-IPDataPos);
    IPDataPos:=16;
    
    Inc(pQQWryPos, 5);
    //后3个字节是该条记录的内容区域的偏移值，内容区域的前4个字节为该条记录的结束IP地址
    CopyMemory(@EndIPOffset, pQQWryPos, 3);

    //取该条记录的结束IP地址
    pQQWryPos:=pQQWryMapFile;
    Inc(pQQWryPos, EndIPOffset + 3);
    for i:=0 to 3 do begin
      IPByteStr:=IntToStr(pQQWryPos^);
      IPByteStrLen:=Length(IPByteStr);
      CopyMemory(@IPData[IPDataPos], PChar(IPByteStr), IPByteStrLen);
      Inc(IPDataPos, IPByteStrLen);
      if i<>3 then begin
        IPData[IPDataPos]:='.';
        Inc(IPDataPos);
      end;
      dec(pQQWryPos);
    end;
    //填充空格至16位
    CopyMemory(@IPData[IPDataPos], pBlank, 32-IPDataPos);
    IPDataPos:=32;

    //取该条记录的国家地区信息
    IPLocation:=PChar(@IPData[IPDataPos]);
    GetIPLocationByEndIPOffset(EndIPOffset, IPLocation);

    //结尾的回车
    if IPLocation[StrLen(IPLocation) - 1]<>' ' then 
      Inc(IPDataPos, StrLen(IPLocation))
    else
      Inc(IPDataPos, StrLen(IPLocation) - 1);
    CopyMemory(@IPData[IPDataPos], pReturn, 2);
  except
    on E: Exception do begin
      Destroy;
      raise Exception.Create(E.Message);
      exit;
    end;
  end;
end;

///**
//* 给定一条记录的结束IP地址的偏移，返回该条记录的国家地区信息
//* @param  (EndIPOffset, IPLocation) (该条记录的结束IP地址偏移, 该条记录的国家地区信息)
//* @return 无
//*/
procedure TQQWry.GetIPLocationByEndIPOffset(EndIPOffset: int64; var IPLocation: PChar);
const
  //实际信息字串存放位置的重定向模式
  REDIRECT_MODE_1 = 1;
  REDIRECT_MODE_2 = 2;
var
  RedirectMode: byte;
  pSplit: PChar;
  CountryFirstOffset, CountrySecondOffset: int64;
  IPCountryLen: integer;
  IPArea: PChar;
  ///**
  //* 给定一个地区信息偏移值，返回在数据文件中该偏移量下的地区信息
  //* @param  (AreaOffset, IPArea) (地区信息在文件中的偏移值, 返回的地区信息)
  //* @return
  //*/  
  procedure ReadIPAreaByAreaOffset(AreaOffset: int64; var IPArea: PChar);
  var
    ModeByte: byte;
    ReadAreaOffset: int64;
  begin
    try
      ModeByte:=0;
      ReadAreaOffset:=0;
      
      //取内存文件映射首地址
      pQQWryPos:=pQQWryMapFile;
      //移到偏移处
      inc(pQQWryPos, AreaOffset);
      //读模式
      CopyMemory(@ModeByte, pQQWryPos, 1);
      //模式1或2，后3字节为偏移
      if (ModeByte = REDIRECT_MODE_1) or (ModeByte = REDIRECT_MODE_2) then begin
        //读偏移
        Inc(pQQWryPos);
        CopyMemory(@ReadAreaOffset, pQQWryPos, 3);
        //若偏移为0，则为未知地区，对于以前的数据库有这个错误
        if ReadAreaOffset=0 then IPArea:='未知地区'
        else begin  //去偏移处读字符串
          pQQWryPos:=pQQWryMapFile;
          Inc(pQQWryPos, ReadAreaOffset);
          CopyMemory(IPArea, PChar(pQQWryPos), StrLen(PChar(pQQWryPos)));
        end;
      //没有模式，直接读字符串
      end else begin
        pQQWryPos:=pQQWryMapFile;
        Inc(pQQWryPos, AreaOffset);
        CopyMemory(IPArea, PChar(pQQWryPos), StrLen(PChar(pQQWryPos)));
      end;
    except
      on E: Exception do begin
        raise Exception.Create(E.Message);
        exit;
      end;      
    end;
  end;
begin
  try
    RedirectMode:=0;
    pSplit:=' ';
    CountryFirstOffset:=0;
    CountrySecondOffset:=0;
    
    //取内存文件映射首地址
    pQQWryPos:=pQQWryMapFile;
    //根据记录ID号移到该记录号的索引处
    Inc(pQQWryPos, EndIPOffset + 4);

    CopyMemory(@RedirectMode, pQQWryPos, 1);
    //重定向模式1的处理
    if RedirectMode = REDIRECT_MODE_1 then begin
      Inc(pQQWryPos);
      //模式值为1，则后3个字节的内容为国家信息的偏移值
      CopyMemory(@CountryFirstOffset, pQQWryPos, 3);
      //进行重定向
      pQQWryPos:=pQQWryMapFile;
      Inc(pQQWryPos, CountryFirstOffset);
      //第二次读取国家信息的重定向模式
      CopyMemory(@RedirectMode, pQQWryPos, 1);
      //第二次重定向模式为模式2的处理
      if RedirectMode = REDIRECT_MODE_2 then begin
          //后3字节的内容即为第二次重定向偏移值
          Inc(pQQWryPos);
          CopyMemory(@CountrySecondOffset, pQQWryPos, 3);
          //读取第二次重定向偏移值下的字符串值，即为国家信息
          pQQWryPos:=pQQWryMapFile;
          Inc(pQQWryPos, CountrySecondOffset);
          IPCountryLen:=StrLen(PChar(pQQWryPos));
          CopyMemory(IPLocation, PChar(pQQWryPos), IPCountryLen);
          //用空格分割国家和地区
          CopyMemory(@IPLocation[IPCountryLen], pSplit, 1);
          
          //若第一次重定向模式为1，进行重定向后读取的第二次重定向模式为2，
          //则地区信息存放在第一次国家信息偏移值的后面
          IPArea:=PChar(@IPLocation[IPCountryLen + 1]);
          ReadIPAreaByAreaOffset(CountryFirstOffset + 4, IPArea);

      //第二次重定向模式不是模式2的处理
      end else begin
          IPCountryLen:=StrLen(PChar(pQQWryPos));
          CopyMemory(IPLocation, PChar(pQQWryPos), IPCountryLen);
          //用空格分割国家和地区
          CopyMemory(@IPLocation[IPCountryLen], pSplit, 1);
          //读地区信息
          IPArea:=PChar(@IPLocation[IPCountryLen + 1]);
          ReadIPAreaByAreaOffset(CountryFirstOffset + IPCountryLen + 1, IPArea);
      end;

    //重定向模式2的处理
    end else if RedirectMode = REDIRECT_MODE_2 then begin
      Inc(pQQWryPos);
      //模式值为2，则后3个字节的内容为国家信息的偏移值
      CopyMemory(@CountrySecondOffset, pQQWryPos, 3);
      //进行重定向
      pQQWryPos:=pQQWryMapFile;
      Inc(pQQWryPos, CountrySecondOffset);
      //国家信息
      IPCountryLen:=StrLen(PChar(pQQWryPos));
      CopyMemory(IPLocation, PChar(pQQWryPos), IPCountryLen);
      //用空格分割国家和地区
      CopyMemory(@IPLocation[IPCountryLen], pSplit, 1);
      
      //地区信息
      IPArea:=PChar(@IPLocation[IPCountryLen + 1]);
      ReadIPAreaByAreaOffset(EndIPOffset + 8, IPArea);
    //不是重定向模式的处理，存放的即是IP地址信息
    end else begin
      //国家信息
      IPCountryLen:=StrLen(PChar(pQQWryPos));
      CopyMemory(IPLocation, PChar(pQQWryPos), IPCountryLen);
      //用空格分割国家和地区
      CopyMemory(@IPLocation[IPCountryLen], pSplit, 1);

      //地区信息
      IPArea:=PChar(@IPLocation[IPCountryLen + 1]);
      ReadIPAreaByAreaOffset(EndIPOffset + 4 + IPCountryLen + 1, IPArea);
    end;
  except
    on E: Exception do begin
      raise Exception.Create(E.Message);
      exit;
    end;
  end;
end;

///**
//* 给定一个IP地址信息记录号，返回该项记录的信息，用Stringlist接收该条信息，效率较低
//* @param  (IPRecordID, IPData) (IP地址信息记录号, 返回的该条信息：①起始IP ②结束IP ③国家 ④地区)
//* @return 无
//*/
procedure TQQWry.GetIPDataByIPRecordID(IPRecordID: int64; var IPData: TStringlist);
var
  aryIPData: array[0..254] of char;
  pIPData: PChar;
  i: integer;
begin
  try
    FillChar(aryIPData, SizeOf(aryIPData), #0);
    pIPData:=PChar(@aryIPData[0]);
    
    GetIPDataByIPRecordID(IPRecordID, pIPData);
    //去掉结尾的回车符
    pIPData[StrLen(pIPData) - 2]:=#0;
    IPData.CommaText:=StrPas(pIPData);
    //有可能地区为空，也有可能地区中含有空格
    for i:=1 to 4 - IPData.Count do
      IPData.Add('无');
    for i:=5 to IPData.Count do
      IPData[3]:=IPData[3] + ' ' + IPData[i - 1];    
  except
    on E: Exception do begin
      raise Exception.Create(E.Message);
      exit;
    end;
  end;
end;

///**
//* 给定一个IP地址（四段点分字符串形式），返回该IP的数值
//* @param  (IP)  (IP地址，四段点分字符串形式）
//* @return 该IP的数值
//*/
function TQQWry.GetIPValue(IP: string): int64;
var
  slIP: TStringlist;
  i: integer;
  function SplitStringToStringlist(aString: string; aSplitChar: string): TStringlist;
  begin
    Result:=TStringList.Create;
    while pos(aSplitChar, aString)>0 do begin
      Result.Add(copy(aString, 1, pos(aSplitChar, aString)-1));
      aString:=copy(aString, pos(aSplitChar, aString)+1, length(aString)-pos(aSplitChar, aString));
    end;
    Result.Add(aString);
  end;
begin
  try
    slIP:=SplitStringToStringlist(IP, '.');
    Result:=0;
    for i:=3 downto 0 do begin
      Result:=Result + StrToInt(slIP[i]) * trunc(power(256, 3-i));
    end;
  except
    on E: Exception do begin
      raise Exception.Create('无效的IP地址！');
      exit;
    end;      
  end;
end;

///**
//* 给定一个IP地址（四段点分字符串形式），返回该IP地址所在的记录号
//* @param  IP  IP地址（四段点分字符串形式）  string
//* @return 该IP地址所在的记录号  Cardinal
//*/
function TQQWry.GetIPDataID(IP: string): int64;
  function SearchIPDataID(IPRecordFrom, IPRecordTo, IPValue: int64): int64;
  var
    CompareIPValue1, CompareIPValue2: int64;
  begin
    Result:=0;
    CompareIPValue1:=0;
    CompareIPValue2:=0;
    
    pQQWryPos:=pQQWryMapFile;
    Inc(pQQWryPos, FirstIPIndexOffset + ((IPRecordTo - IPRecordFrom) div 2 + IPRecordFrom - 1) * 7);
    CopyMemory(@CompareIPValue1, pQQWryPos, 4); 
    pQQWryPos:=pQQWryMapFile;
    Inc(pQQWryPos, FirstIPIndexOffset + ((IPRecordTo - IPRecordFrom) div 2 + IPRecordFrom) * 7);
    CopyMemory(@CompareIPValue2, pQQWryPos, 4);
    //找到了
    if (IPRecordFrom=IPRecordTo) or ((IPValue>=CompareIPValue1) and (IPValue<CompareIPValue2)) then begin
      Result:=(IPRecordTo - IPRecordFrom) div 2 + IPRecordFrom;
    end else
      //后半段找
      if IPValue>CompareIPValue1 then begin
        Result:=SearchIPDataID((IPRecordTo - IPRecordFrom) div 2 + IPRecordFrom + 1, IPRecordTo, IPValue);
      end else
        //前半段找
        if IPValue<CompareIPValue1 then begin
          Result:=SearchIPDataID(IPRecordFrom, (IPRecordTo - IPRecordFrom) div 2 + IPRecordFrom - 1, IPValue);
        end;
  end;
begin
  try
    Result:=SearchIPDataID(1, GetIPDataNum, GetIPValue(IP));
  except
    on E: Exception do begin
      Destroy;
      raise Exception.Create(E.Message);
      exit;
    end;    
  end;
end;

///**
//* 将IP地址数据库解压成文本文件
//* @param  (ATxtFileName) (解压后的文本文件全名)
//* @return -1为解压失败，非-1值为解压所耗时间，单位毫秒
//*/
function TQQWry.ExtractIPDataToTxtFile(ATxtFileName: string): integer;
var
  QQWryMemoryStream: TMemoryStream;
  i: integer;
  IPData, NowPos: PChar;
  TimeCounter: DWORD;
  pReturn: PChar;
begin
  result:=-1;
  try
    IPData:=StrAlloc(41943040);
    NowPos:=IPData;

    TimeCounter:=GetTickCount;
    for i:=1 to GetIPDataNum do begin
      GetIPDataByIPRecordID(i, NowPos);
      Inc(NowPos, StrLen(NowPos));
    end;
    pReturn:=#13#10;
    NowPos:=StrECopy(NowPos, pReturn);
    NowPos:=StrECopy(NowPos, pReturn);
    NowPos:=StrECopy(NowPos, PChar(format('IP数据库共有数据 ： %d 条', [GetIPDataNum])));
    NowPos:=StrECopy(NowPos, pReturn);

    QQWryMemoryStream:=TMemoryStream.Create;
    QQWryMemoryStream.SetSize(NowPos - IPData);
    QQWryMemoryStream.WriteBuffer(IPData^, NowPos - IPData);
    QQWryMemoryStream.SaveToFile(ATxtFileName);
    StrDispose(IPData);
    QQWryMemoryStream.Destroy;
    result:=GetTickCount-TimeCounter;
  except
    on E: Exception do begin
      raise Exception.Create(E.Message);
      exit;
    end;
  end;
end;

end.
