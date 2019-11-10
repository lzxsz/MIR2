unit Wave;

interface

{$INCLUDE DelphiXcfg.inc}

uses
  Windows, SysUtils, Classes, MMSystem;

type

  {  EWaveError  }

  EWaveError = class(Exception);

  {  TWave  }

  TWave = class(TPersistent)
  private
    FData: Pointer;
    FFormat: PWaveFormatEx;
    FFormatSize: Integer;
    FSize: Integer;
    procedure SetFormatSize(Value: Integer);
    procedure SetSize(Value: Integer);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadData(Stream: TStream); virtual;
    procedure WriteData(Stream: TStream); virtual;
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    procedure LoadFromFile(const FileName : string);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName : string);
    procedure SaveToStream(Stream: TStream);
    procedure SetPCMFormat(SamplesPerSec, BitsPerSample, Channels: Integer);
    property Data: Pointer read FData;
    property Format: PWaveFormatEx read FFormat;
    property FormatSize: Integer read FFormatSize write SetFormatSize;
    property Size: Integer read FSize write SetSize;
  end;

  {  TCustomDXWave  }

  TCustomDXWave = class(TComponent)
  private
    FWave: TWave;
    procedure SetWave(Value: TWave);
  public
    constructor Create(AOnwer: TComponent); override;
    destructor Destroy; override;
    property Wave: TWave read FWave write SetWave;
  end;

  {  TDXWave  }

  TDXWave = class(TCustomDXWave)
  published
    property Wave;
  end;

  {  EWaveStreamError  }

  EWaveStreamError = class(Exception);

  {  TCustomWaveStream  }

  TCustomWaveStream = class(TStream)
  private
    FPosition: Integer;
  protected
    function GetFilledSize: Integer; virtual;
    function GetFormat: PWaveFormatEx; virtual; abstract;
    function GetFormatSize: Integer; virtual;
    function GetSize: Integer; virtual;
    function ReadWave(var Buffer; Count: Integer): Integer; virtual;
    procedure SetFormatSize(Value: Integer); virtual; abstract;
    procedure SetSize(Value: Integer); override;
    function WriteWave(const Buffer; Count: Integer): Integer; virtual;
  public
    function Read(var Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    procedure SetPCMFormat(SamplesPerSec, BitsPerSample, Channels: Integer);
    property FilledSize: Integer read GetFilledSize;
    property Format: PWaveFormatEx read GetFormat;
    property FormatSize: Integer read GetFormatSize write SetFormatSize;
    property Size: Integer read GetSize write SetSize;
  end;

  {  TCustomWaveStream2  }

  TCustomWaveStream2 = class(TCustomWaveStream)
  private
    FFormat: PWaveFormatEx;
    FFormatSize: Integer;
  protected
    function GetFormat: PWaveFormatEx; override;
    function GetFormatSize: Integer; override;
    procedure SetFormatSize(Value: Integer); override;
  public
    destructor Destroy; override;
  end;

  {  TWaveObjectStream  }

  TWaveObjectStream = class(TCustomWaveStream)
  private
    FWave: TWave;
  protected
    function GetFormat: PWaveFormatEx; override;
    function GetFormatSize: Integer; override;
    function GetSize: Integer; override;
    function ReadWave(var Buffer; Count: Integer): Integer; override;
    procedure SetFormatSize(Value: Integer); override;
    procedure SetSize(Value: Integer); override;
    function WriteWave(const Buffer; Count: Integer): Integer; override;
  public
    constructor Create(AWave: TWave);
  end;

  {  TWaveStream  }

  TWaveStream = class(TCustomWaveStream2)
  private
    FDataPosition: Integer;
    FDataHeaderPosition: Integer;
    FOpened: Boolean;
    FOriPosition: Integer;
    FReadMode: Boolean;
    FSize: Integer;
    FStream: TStream;
    procedure CloseWriteMode;
    procedure OpenReadMode;
    procedure OpenWriteMode;
  protected
    function GetSize: Integer; override;
    function ReadWave(var Buffer; Count: Integer): Integer; override;
    function WriteWave(const Buffer; Count: Integer): Integer; override;
  public
    constructor Create(AStream: TStream);
    destructor Destroy; override;
    procedure Open(WriteMode: Boolean);
  end;

  {  TWaveFileStream  }

  TWaveFileStream = class(TWaveStream)
  private
    FFileStream: TFileStream;
  public
    constructor Create(const FileName: string; FileMode: Integer);
    destructor Destroy; override;
  end;

procedure MakePCMWaveFormatEx(var Format: TWaveFormatEx;
  SamplesPerSec, BitsPerSample, Channels: Integer);

implementation

uses DXConsts;

procedure MakePCMWaveFormatEx(var Format: TWaveFormatEx;
  SamplesPerSec, BitsPerSample, Channels: Integer);
begin
  with Format do
  begin
    wFormatTag := WAVE_FORMAT_PCM;
    nChannels := Channels;
    nSamplesPerSec := SamplesPerSec;
    wBitsPerSample := BitsPerSample;
    nBlockAlign := nChannels*(wBitsPerSample div 8);
    nAvgBytesPerSec := nBlockAlign*nSamplesPerSec;
    cbSize := 0;
  end;
end;

{  TWave  }

const
  WavePoolSize = 8096;

destructor TWave.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TWave.Assign(Source: TPersistent);
var
  AWave: TWave;
begin
  if Source=nil then
  begin
    Clear;
  end else if Source is TWave then
  begin
    if Source<>Self then
    begin
      AWave := TWave(Source);
      Size := AWave.Size;
      FormatSize := AWave.FormatSize;
      Move(AWave.Data^, FData^, FSize);
      Move(AWave.Format^, FFormat^, FFormatSize);
    end;
  end else
    inherited Assign(Source);
end;

procedure TWave.Clear;
begin
  FreeMem(FData, 0); FData := nil;
  FreeMem(FFormat, 0); FFormat := nil;

  FSize := 0;
  FFormatSize := 0;
end;

procedure TWave.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('WAVE', ReadData, WriteData, True);
end;

procedure TWave.LoadFromFile(const FileName : string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TWave.LoadFromStream(Stream: TStream);
var
  WaveStream: TWaveStream;
begin
  Clear;

  WaveStream := TWaveStream.Create(Stream);
  try
    WaveStream.Open(False);

    FormatSize := WaveStream.FormatSize;
    Move(WaveStream.Format^, Format^, FormatSize);
    Size := WaveStream.Size;
    WaveStream.ReadBuffer(FData^, Size);
  finally
    WaveStream.Free;
  end;
end;

procedure TWave.ReadData(Stream: TStream);
begin
  LoadFromStream(Stream);
end;

procedure TWave.SaveToFile(const FileName : string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TWave.SaveToStream(Stream: TStream);
var
  WaveStream: TWaveStream;
begin
  if (FFormatSize<=0) or (FSize<=0) then Exit;

  WaveStream := TWaveStream.Create(Stream);
  try
    WaveStream.FormatSize := FormatSize;
    Move(Format^, WaveStream.Format^, FormatSize);

    WaveStream.Open(True);
    WaveStream.WriteBuffer(FData^, Size);
  finally
    WaveStream.Free;
  end;
end;

procedure TWave.SetFormatSize(Value: Integer);
begin
  if Value<=0 then Value := 0;
  ReAllocMem(FFormat, Value);
  FFormatSize := Value;
end;

procedure TWave.SetPCMFormat(SamplesPerSec, BitsPerSample, Channels: Integer);
begin
  FormatSize := SizeOf(TWaveFormatEx);
  MakePCMWaveFormatEx(Format^, SamplesPerSec, BitsPerSample, Channels);
end;

procedure TWave.SetSize(Value: Integer);
var
  i: Integer;
begin
  if Value<=0 then Value := 0;

  i := (Value+WavePoolSize-1) div WavePoolSize;
  if i<>(FSize+WavePoolSize-1) div WavePoolSize then
    ReAllocMem(FData, i*WavePoolSize);

  FSize := Value;
end;

procedure TWave.WriteData(Stream: TStream);
begin
  SaveToStream(Stream);
end;

{  TCustomDXWave  }

constructor TCustomDXWave.Create(AOnwer: TComponent);
begin
  inherited Create(AOnwer);
  FWave := TWave.Create;
end;

destructor TCustomDXWave.Destroy;
begin
  FWave.Free;
  inherited Destroy;
end;

procedure TCustomDXWave.SetWave(Value: TWave);
begin
  FWave.Assign(Value);
end;

{  TCustomWaveStream  }

function TCustomWaveStream.GetFilledSize: Longint;
begin
  Result := -1;
end;

function TCustomWaveStream.GetFormatSize: Integer;
begin
  Result := 0;
end;

function TCustomWaveStream.GetSize: Integer;
begin
  Result := -1;
end;

function TCustomWaveStream.Read(var Buffer; Count: Longint): Longint;
begin
  if GetSize<0 then
    Result := ReadWave(Buffer, Count)
  else
  begin
    if FPosition>Size then
      FPosition := Size;
    if FPosition+Count>Size then
      Result := Size-FPosition
    else
      Result := Count;

    Result := ReadWave(Buffer, Result);
  end;

  Inc(FPosition, Result);
end;

function TCustomWaveStream.ReadWave(var Buffer; Count: Integer): Integer;
begin
  Result := 0;
end;

function TCustomWaveStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent  : FPosition := FPosition + Offset;
    soFromEnd      : FPosition := GetSize + Offset;
  end;
  if FPosition<0 then FPosition := 0;
  if FPosition>GetSize then FPosition := GetSize;

  Result := FPosition;
end;

procedure TCustomWaveStream.SetPCMFormat(SamplesPerSec, BitsPerSample, Channels: Integer);
begin
  FormatSize := SizeOf(TWaveFormatEx);
  MakePCMWaveFormatEx(Format^, SamplesPerSec, BitsPerSample, Channels);
end;

procedure TCustomWaveStream.SetSize(Value: Integer);
begin
end;

function TCustomWaveStream.Write(const Buffer; Count: Longint): Longint;
begin
  if FPosition>Size then
    FPosition := Size;
  Result := WriteWave(Buffer, Count);
  Inc(FPosition, Result);
end;

function TCustomWaveStream.WriteWave(const Buffer; Count: Integer): Integer;
begin
  Result := 0;
end;

{  TCustomWaveStream2  }

destructor TCustomWaveStream2.Destroy;
begin
  FormatSize := 0;
  inherited Destroy;
end;

function TCustomWaveStream2.GetFormat: PWaveFormatEx;
begin
  Result := FFormat;
end;

function TCustomWaveStream2.GetFormatSize: Integer;
begin
  Result := FFormatSize;
end;

procedure TCustomWaveStream2.SetFormatSize(Value: Integer);
begin
  ReAllocMem(FFormat, Value);
  FFormatSize := Value;
end;

{  TWaveObjectStream  }

constructor TWaveObjectStream.Create(AWave: TWave);
begin
  inherited Create;
  FWave := AWave;

  FormatSize := FWave.FormatSize;
  Move(FWave.Format^, Format^, FormatSize);
end;

function TWaveObjectStream.GetFormat: PWaveFormatEx;
begin
  Result := FWave.Format;
end;

function TWaveObjectStream.GetFormatSize: Integer;
begin
  Result := FWave.FormatSize;
end;

function TWaveObjectStream.GetSize: Integer;
begin
  Result := FWave.Size;
end;

function TWaveObjectStream.ReadWave(var Buffer; Count: Integer): Integer;
begin
  Result := Count;
  Move(Pointer(Integer(FWave.Data)+Position)^, Buffer, Count);
end;

procedure TWaveObjectStream.SetFormatSize(Value: Integer);
begin
  FWave.FormatSize := Value;
end;

procedure TWaveObjectStream.SetSize(Value: Integer);
begin
  FWave.Size := Value;
end;

function TWaveObjectStream.WriteWave(const Buffer; Count: Integer): Integer;
begin
  Result := Count;
  if Position+Count>Size then
    SetSize(Size+(Position+Count+Size));
  Move(Buffer, Pointer(Integer(FWave.Data)+Position)^, Count);
end;

{  TWaveStream  }

const
  ID_RIFF = Ord('R') + Ord('I')*$100 + Ord('F')*$10000 + Ord('F')*$1000000;
  ID_WAVE = Ord('W') + Ord('A')*$100 + Ord('V')*$10000 + Ord('E')*$1000000;
  ID_FMT  = Ord('f') + Ord('m')*$100 + Ord('t')*$10000 + Ord(' ')*$1000000;
  ID_FACT = Ord('f') + Ord('a')*$100 + Ord('c')*$10000 + Ord('t')*$1000000;
  ID_DATA = Ord('d') + Ord('a')*$100 + Ord('t')*$10000 + Ord('a')*$1000000;

type
  TWaveFileHeader = packed record
    FType: Integer;
    Size: Longint;
    RType: Integer;
  end;

  TWaveChunkHeader = packed record
    CType: Longint;
    Size: Longint;
  end;

constructor TWaveStream.Create(AStream: TStream);
begin
  inherited Create;
  FStream := AStream;

  FOriPosition := FStream.Position;
end;

destructor TWaveStream.Destroy;
begin
  if FOpened and (not FReadMode) then
    CloseWriteMode;
  inherited Destroy;
end;

function TWaveStream.GetSize: Integer;
begin
  if FOpened then
  begin
    if not FReadMode then
      Result := FStream.Size-FDataPosition
    else
      Result := FSize;
  end else
    Result := 0;
end;

function TWaveStream.ReadWave(var Buffer; Count: Integer): Integer;
begin
  if not FOpened then
    raise EWaveStreamError.Create(SStreamNotOpend);

  FStream.Position := FDataPosition+Position;
  Result := FStream.Read(Buffer, Count);
end;

function TWaveStream.WriteWave(const Buffer; Count: Integer): Integer;
begin
  if not FOpened then
    raise EWaveStreamError.Create(SStreamNotOpend);

  if FReadMode then
  begin
    if Position+Count>FSize then
      Count := FSize-Position;
  end;

  FStream.Position := FDataPosition+Position;
  Result := FStream.Write(Buffer, Count);
end;

procedure TWaveStream.Open(WriteMode: Boolean);
begin
  if WriteMode then
    OpenWriteMode
  else
    OpenReadMode;
end;

procedure TWaveStream.OpenReadMode;
var
  WF: TWaveFileHeader;
  WC: TWaveChunkHeader;

  procedure Readfmt;   { fmt }
  begin
    FormatSize := WC.Size;
    FStream.ReadBuffer(Format^, WC.Size);
  end;

  procedure Readdata; { data }
  begin
    FSize := WC.Size;
    FDataPosition := FStream.Position;
    FStream.Seek(FSize, 1);
  end;

begin
  if FOpened then
    raise EWaveStreamError.Create(SStreamOpend);

  FOpened := True;
  FReadMode := True;

  FStream.Position := FOriPosition;

  //if FStream.Size-FStream.Position<=0 then Exit;

  {  File header reading.  }
  FStream.ReadBuffer(WF, SizeOf(TWaveFileHeader));

  {  Is it Wave file of the file?  }
  if (WF.FType<>ID_RIFF) or (WF.RType<>ID_WAVE) then
    raise EWaveStreamError.Create(SInvalidWave);

  {  Chunk reading.  }
  FillChar(WC, SizeOf(WC), 0);
  FStream.Read(WC, SizeOf(TWaveChunkHeader));
  while WC.CType<>0 do
  begin
    case WC.CType of
      ID_FMT : Readfmt;
      ID_DATA: Readdata;
    else
    {  Chunk which does not correspond is disregarded.  }
      FStream.Seek(WC.Size, 1);
    end;

    FillChar(WC, SizeOf(WC), 0);
    FStream.Read(WC, SizeOf(TWaveChunkHeader));
  end;
end;

procedure TWaveStream.OpenWriteMode;

  procedure WriteFmt;    { fmt }
  var
    WC: TWaveChunkHeader;
  begin
    with WC do
    begin
      CType := ID_FMT;
      Size := FFormatSize;
    end;

    FStream.WriteBuffer(WC, SizeOf(WC));
    FStream.WriteBuffer(FFormat^, FFormatSize);
  end;

  procedure WriteData;   { data }
  var
    WC: TWaveChunkHeader;
  begin
    FDataHeaderPosition := FStream.Position;

    with WC do
    begin
      CType := ID_DATA;
      Size := 0;
    end;

    FStream.WriteBuffer(WC, SizeOf(WC));

    FDataPosition := FStream.Position;
  end;

var
  WF: TWaveFileHeader;
begin
  if FOpened then
    raise EWaveStreamError.Create(SStreamOpend);

  if FormatSize=0 then
    raise EWaveStreamError.Create(SInvalidWaveFormat);

  FOpened := True;
  FStream.Position := FOriPosition;

  FStream.WriteBuffer(WF, SizeOf(TWaveFileHeader));

  {  Chunk writing.  }
  WriteFmt;
  WriteData;
end;

procedure TWaveStream.CloseWriteMode;

  procedure WriteDataHeader; { data }
  var
    WC: TWaveChunkHeader;
  begin
    FStream.Position := FDataHeaderPosition;

    with WC do
    begin
      CType := ID_DATA;
      Size := Self.Size;
    end;

    FStream.WriteBuffer(WC, SizeOf(WC));
  end;

var
  WF: TWaveFileHeader;
begin
  with WF do
  begin
    FType := ID_RIFF;
    Size := (FStream.Size-FOriPosition)-SizeOf(TWaveChunkHeader);
    RType := ID_WAVE;
  end;
  FStream.Position := FOriPosition;
  FStream.WriteBuffer(WF, SizeOf(TWaveFileHeader));
  WriteDataHeader;
  FStream.Position := FStream.Size;
end;

{  TWaveFileStream  }

constructor TWaveFileStream.Create(const FileName: string; FileMode: Integer);
begin
  FFileStream := TFileStream.Create(FileName, FileMode);
  inherited Create(FFileStream);
end;

destructor TWaveFileStream.Destroy;
begin
  inherited Destroy;
  FFileStream.Free;
end;

end.
