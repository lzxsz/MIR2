unit EncryptUnit;

interface

uses
  Windows, SysUtils;

  function GetIdeSerialNumber():String;

implementation

function GetIdeSerialNumber():String;
const IDENTIFY_BUFFER_SIZE = 512;
type
  TIDERegs = packed record
    bFeaturesReg : BYTE; // Used for specifying SMART "commands".
    bSectorCountReg : BYTE; // IDE sector count register
    bSectorNumberReg : BYTE; // IDE sector number register
    bCylLowReg : BYTE; // IDE low order cylinder value
    bCylHighReg : BYTE; // IDE high order cylinder value
    bDriveHeadReg : BYTE; // IDE drive/head register
    bCommandReg : BYTE; // Actual IDE command.
    bReserved : BYTE; // reserved for future use. Must be zero.
  end;
  TSendCmdInParams = packed record
    // Buffer size in bytes
    cBufferSize : DWORD;
    // Structure with drive register values.
    irDriveRegs : TIDERegs;
    // Physical drive number to send command to (0,1,2,3).
    bDriveNumber : BYTE;
    bReserved : Array[0..2] of Byte;
    dwReserved : Array[0..3] of DWORD;
    bBuffer : Array[0..0] of Byte; // Input buffer.
  end;

  TIdSector = packed record
    wGenConfig : Word;
    wNumCyls : Word;
    wReserved : Word;
    wNumHeads : Word;
    wBytesPerTrack : Word;
    wBytesPerSector : Word;
    wSectorsPerTrack : Word;
    wVendorUnique : Array[0..2] of Word;
    sSerialNumber : Array[0..19] of CHAR;
    wBufferType : Word;
    wBufferSize : Word;
    wECCSize : Word;
    sFirmwareRev : Array[0..7] of Char;
    sModelNumber : Array[0..39] of Char;
    wMoreVendorUnique : Word;
    wDoubleWordIO : Word;
    wCapabilities : Word;
    wReserved1 : Word;
    wPIOTiming : Word;
    wDMATiming : Word;
    wBS : Word;
    wNumCurrentCyls : Word;
    wNumCurrentHeads : Word;
    wNumCurrentSectorsPerTrack : Word;
    ulCurrentSectorCapacity : DWORD;
    wMultSectorStuff : Word;
    ulTotalAddressableSectors : DWORD;
    wSingleWordDMA : Word;
    wMultiWordDMA : Word;
    bReserved : Array[0..127] of BYTE;
  end;
  PIdSector = ^TIdSector;

  TDriverStatus = packed record
    // Error code from driver, or 0 if no error.
    bDriverError : Byte;
    // Contents of IDE Error register. Only valid when bDriverError is SMART_IDE_ERROR.
    bIDEStatus : Byte;
    bReserved : Array[0..1] of Byte;
    dwReserved : Array[0..1] of DWORD;
  end;

  TSendCmdOutParams = packed record
    // Size of bBuffer in bytes
    cBufferSize : DWORD;
    // Driver status structure.
    DriverStatus : TDriverStatus;
    // Buffer of arbitrary length in which to store the data read from the drive.
    bBuffer : Array[0..0] of BYTE;
  end;

var
  hDevice : THandle;
  cbBytesReturned : DWORD;
  ptr : PChar;
  SCIP : TSendCmdInParams;
  aIdOutCmd : Array
  [0..(SizeOf(TSendCmdOutParams)+IDENTIFY_BUFFER_SIZE -1)-1] of Byte;
  IdOutCmd : TSendCmdOutParams absolute aIdOutCmd;

  procedure ChangeByteOrder( var Data; Size : Integer );
  var
    ptr : PChar;
    i : Integer;
    c : Char;
  begin
    ptr := @Data;
    for i := 0 to (Size shr 1)-1 do begin
      c := ptr^;
      ptr^ := (ptr+1)^;
      (ptr+1)^ := c;
      Inc(ptr,2);
    end;
  end;
begin
  Result := ''; // return empty string on error
  if SysUtils.Win32Platform=VER_PLATFORM_WIN32_NT then // Windows NT,Windows 2000
  begin
    // warning! change name for other drives: ex.: second drive '\\.\PhysicalDrive1\'
    hDevice := CreateFile( '\\.\PhysicalDrive0', GENERIC_READ or
    GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0 );
  end else // Version Windows 95 OSR2, Windows 98
    hDevice := CreateFile( '\\.\SMARTVSD', 0, 0, nil, CREATE_NEW, 0, 0 );
  if hDevice=INVALID_HANDLE_VALUE then Exit;

  try
    FillChar(SCIP,SizeOf(TSendCmdInParams)-1,#0);
    FillChar(aIdOutCmd,SizeOf(aIdOutCmd),#0);
    cbBytesReturned := 0;
    // Set up data structures for IDENTIFY command.
    with SCIP do begin
      cBufferSize := IDENTIFY_BUFFER_SIZE;
      // bDriveNumber := 0;
      with irDriveRegs do begin
        bSectorCountReg := 1;
        bSectorNumberReg := 1;
        // if Win32Platform=VER_PLATFORM_WIN32_NT then bDriveHeadReg := $A0
        // else bDriveHeadReg := $A0 or ((bDriveNum and 1) shl 4);
        bDriveHeadReg := $A0;
        bCommandReg := $EC;
      end;
    end;
    if not DeviceIoControl( hDevice, $0007c088, @SCIP,
    SizeOf(TSendCmdInParams)-1,
    @aIdOutCmd, SizeOf(aIdOutCmd), cbBytesReturned, nil ) then Exit;
  finally
    CloseHandle(hDevice);
  end;

  with PIdSector(@IdOutCmd.bBuffer)^ do begin
    ChangeByteOrder( sSerialNumber, SizeOf(sSerialNumber) );
    (PChar(@sSerialNumber)+SizeOf(sSerialNumber))^ := #0;
    Result := PChar(@sSerialNumber);
  end;
end;

end.

