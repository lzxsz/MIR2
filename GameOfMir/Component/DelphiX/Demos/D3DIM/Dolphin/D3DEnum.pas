//--------------------------------------------------------------
// File: D3DEnum.h & D3DEnum.cpp
//
// Delphi translation by Arne Schäpers, 03-MAR-2000
//
// Desc: Functions to enumerate DDraw/D3D drivers,
// devices, and modes.
//
// Copyright (c) 1997-1999 Microsoft Corporation.
// All rights reserved
//--------------------------------------------------------------

unit D3DEnum;
{$IFDEF VER100} {$DEFINE DELPHI3} {$ENDIF}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, DirectX, D3DUtil, StdCtrls;


//--------------------------------------------------------------
// Flag and error definitions
//--------------------------------------------------------------
const
  D3DENUM_SOFTWAREONLY = $00000001 ; // Software-devices only
  D3DENUMERR_NODIRECTDRAW         = HResult($81000001);
  D3DENUMERR_ENUMERATIONFAILED    = HResult($81000002);
  D3DENUMERR_SUGGESTREFRAST       = HResult($81000003);
  // No devices found that meet the app's desired capabilities
  D3DENUMERR_NOCOMPATIBLEDEVICES  = HResult($81000004);

//--------------------------------------------------------------
// Name: struct D3DEnum_DeviceInfo
// Structure to hold info about the enumerated Direct3D devices.
//--------------------------------------------------------------

{$IFDEF DELPHI3}
const MAXSURFDESCS = 50; MAXDEVICES = 20;
{$ENDIF}
type
  TD3DEnum_DeviceInfo = record
    // D3D Device info
    strDesc: String[40];
    pDeviceGUID: PGUID;
    ddDeviceDesc: TD3DDEVICEDESC7;
    bHardware: Boolean;

    // DDraw Driver info
    pDriverGUID: PGUID;
    ddDriverCaps, ddHELCaps: TDDCAPS;

    // DDraw Mode Info
    ddsdFullscreenMode: TDDSurfaceDesc2;
    bWindowed, bStereo: Boolean;

    // For internal use (apps should not need to use these)
    guidDevice, guidDriver: TGUID;
{$IFDEF DELPHI3}
    pddsdModes: Array[0..MAXSURFDESCS] of TDDSurfaceDesc2;
{$ELSE}
    pddsdModes: Array of TDDSurfaceDesc2;
{$ENDIF}
    dwNumModes: DWORD;
    dwCurrentMode: DWORD;
    bDesktopCompatible, bStereoCompatible: Boolean;
  end;

  PD3DEnum_DeviceInfo = ^TD3DEnum_DeviceInfo;

// For code not yet switched to new struct name
type TD3DDEVICEINFO = TD3DEnum_DeviceInfo;


// Enumerates all drivers, devices, and modes. The callback
// function is called for each device, to confirm that the
// device supports the feature set required by the app.
type
  D3DEnumDevicesCallback = function(Caps: PDDCaps;
    Desc: PD3DDeviceDesc7): HResult;
function D3DEnum_EnumerateDevices(Callback:
  D3DEnumDevicesCallback): HResult;

// Cleans up any memory allocated during device enumeration
procedure D3DEnum_FreeResources;

// Returns a ptr to the array of enumerated D3DDEVICEINFO structures.
procedure D3DEnum_GetDevices(var ppDevices:
  PD3DEnum_DeviceInfo; var pdwCount: Cardinal);


// Picks a driver based on a set of passed in criteria. The
// D3DENUM_SOFTWAREONLY flag can be used to pick a software device.
function D3DEnum_SelectDefaultDevice(var pDevice: PD3DEnum_DeviceInfo;
         dwFlags: DWord { = 0}): HResult;

// Pops up a dialog which allows the user to select a new device.
function D3DEnum_UserChangeDevice(var ppDevice:
   PD3DEnum_DeviceInfo): HResult;

type  // Dialog form for selecting a new device
  TChangeDeviceForm = class(TForm)
    GroupBox1: TGroupBox;
    ModeCombo: TComboBox;
    cStereo: TCheckBox;
    bOK: TButton;
    bCancel: TButton;
    GroupBox2: TGroupBox;
    DeviceCombo: TComboBox;
    cDesktop: TCheckBox;
    procedure cDesktopClick(Sender: TObject);
    procedure cStereoClick(Sender: TObject);
    procedure DeviceComboChange(Sender: TObject);
    procedure ModeComboChange(Sender: TObject);
  private
    SelDevice: PD3DEnum_DeviceInfo;
    SelMode: Cardinal;
  public
    function ShowModal(var CurDevice:
      PD3DEnum_DeviceInfo): Integer; {$IFDEF  VER130} reintroduce; {$ENDIF}
  end;

implementation
{$R *.DFM}

//--------------------------------------------------------------
// Gives the app a chance to reject certain drivers and/or modes
//--------------------------------------------------------------
var g_fnAppConfirmFn: D3DEnumDevicesCallback;

var
{$IFDEF DELPHI3}  // Delphi 3
  g_pDeviceList: Array[0..MAXDEVICES] of TD3DEnum_DeviceInfo;
{$ELSE}
  g_pDeviceList: Array of TD3DEnum_DeviceInfo;
{$ENDIF}
  g_dwNumDevicesEnumerated: DWord;
  g_dwNumDevices: DWord;

// ===================================================
//-----------------------------------------------------------------------------
// Pops up a dialog which allows the user to select a new device.
//-----------------------------------------------------------------------------
function D3DEnum_UserChangeDevice(var ppDevice: PD3DEnum_DeviceInfo): HResult;
begin
  with TChangeDeviceForm.Create(Application) do
  begin
    if ShowModal(ppDevice) = mrOK then Result := S_OK
      else Result := E_FAIL;
    Free;
  end;
end;

{ TChangeDeviceForm }

function TChangeDeviceForm.ShowModal(var CurDevice: PD3DEnum_DeviceInfo): Integer;
var CurWindowed, CurStereo: Boolean; CurMode: Cardinal;
var pDeviceList: PD3DEnum_DeviceInfo; x, dwNumDevices: Integer;
begin
  // Get the app's current device
  with CurDevice^ do
  begin
    CurMode := dwCurrentMode; CurWindowed := bWindowed; CurStereo := bStereo;
  end;

  SelDevice := CurDevice; SelMode := CurMode;
  cDesktop.Checked := CurWindowed; cStereo.Checked := CurStereo;

  // Get access to the enumerated device list and fill in
  D3DEnum_GetDevices(pDeviceList, Cardinal(dwNumDevices));
  DeviceCombo.Clear;
  for x := 0 to dwNumDevices-1 do
  begin
    DeviceCombo.Items.AddObject(pDeviceList^.strDesc,Pointer(pDeviceList));
    if pDeviceList = CurDevice then DeviceCombo.ItemIndex := x;
    Inc(pDeviceList);
  end;

  DeviceComboChange(Self);  // update modes etc.

  Result := inherited ShowModal;

  if Result = mrOK then
  begin
    if (SelDevice = CurDevice) and (SelMode = CurMode)
     and (cDesktop.Checked = CurWindowed) and (cStereo.Checked = CurDevice^.bStereo)
    then Result := mrCancel  // no change at all
    else
    begin
      CurDevice := SelDevice;
      with CurDevice^ do
      begin
        bWindowed := cDesktop.Checked; bStereo := cStereo.Checked;
        dwCurrentMode := SelMode; ddsdFullscreenMode := pddsdModes[SelMode];
      end;
    end;
  end;
end;

procedure TChangeDeviceForm.DeviceComboChange(Sender: TObject);
begin
  with DeviceCombo do SelDevice := Pointer(Items.Objects[ItemIndex]);
  with SelDevice^ do
  begin
    cDesktop.Enabled := bDesktopCompatible;
    cDesktop.Checked := bWindowed;
    cStereo.Checked := bStereo;
  end;
  cDesktopClick(Self);  // enable/disable mode box
end;

procedure TChangeDeviceForm.cDesktopClick(Sender: TObject);
begin
  ModeCombo.Enabled := not cDesktop.Checked;
  SelMode := SelDevice^.dwCurrentMode;
  cStereo.Enabled := not cDesktop.Checked and SelDevice^.bStereoCompatible;
  cStereoClick(Self);  // rebuild mode list
end;

procedure TChangeDeviceForm.cStereoClick(Sender: TObject);
var x: Cardinal;
begin
  ModeCombo.Clear;
  with SelDevice^ do
    for x := 0 to dwNumModes-1 do
    begin
      with pddsdModes[x] do
      begin
        // Skip non-stereo modes, if the device is in stereo mode
        if cStereo.Checked and (ddsCaps.dwCaps2 and
           DDSCAPS2_STEREOSURFACELEFT = 0) then continue;
        ModeCombo.Items.AddObject(Format('%d x %d x %d',[dwWidth,
           dwHeight,ddpfPixelFormat.dwRGBBitCount]), Pointer(x));
      end;
      if x = dwCurrentMode then  // set selection to active mode
        with ModeCombo do ItemIndex := Items.Count-1;
    end;
end;

procedure TChangeDeviceForm.ModeComboChange(Sender: TObject);
begin
  with ModeCombo do SelMode := Integer(Items.Objects[ItemIndex]);
end;


//-----------------------------------------------------------------------------
// Callback function for sorting display modes.
//-----------------------------------------------------------------------------
function SortModesCallback(Arg1, Arg2: Pointer): Integer;
var p2: PDDSurfaceDesc2;
begin
  p2 := Arg2;
  with PDDSurfaceDesc2(Arg1)^ do
    if dwWidth < p2^.dwWidth then Result := -1
     else if dwWidth > p2^.dwWidth then Result := +1
     else if dwHeight < p2^.dwHeight then Result := -1
     else if dwHeight > p2^.dwHeight then Result := +1
     else with ddpfPixelFormat do
       if dwRGBBitCount < p2^.ddpfPixelFormat.dwRGBBitCount then Result := -1
       else if dwRGBBitCount > p2^.ddpfPixelFormat.dwRGBBitCount then Result := +1
        else Result := 0;
end;

//-----------------------------------------------------------------------------
// Callback function for enumerating display modes.
//-----------------------------------------------------------------------------
function ModeEnumCallback(const ddsd: TDDSurfaceDesc2; pParentInfo: Pointer): HResult; stdcall;
begin
  Result := DDENUMRET_OK;
  with PD3DEnum_DeviceInfo(pParentInfo)^ do
  begin
    // Reallocate storage for the modes
{$IFDEF DELPHI3}
    if dwNumModes > MAXSURFDESCS then Exit;
{$ELSE}
    SetLength(pddsdModes, dwNumModes+1);
{$ENDIF}
    // Add the new mode
    pddsdModes[dwNumModes] := ddsd;
    Inc(dwNumModes);
  end;
end;

//-----------------------------------------------------------------------------
// Callback function for enumerating devices
//-----------------------------------------------------------------------------
function DeviceEnumCallback(strDesc, strName: PAnsiChar;
   const pDesc: TD3DDeviceDesc7; pParentInfo: Pointer): HResult; stdcall;
var x: Integer;
  pDriverInfo, pDeviceInfo: PD3DEnum_DeviceInfo;

  procedure StoreSupportedModes;
  var x: Integer;
      ddsdMode: TDDSurfaceDesc2; dwRenderDepths, dwDepth: DWord;
  begin
    // Build list of supported modes for the device
    for x := 0 to pDriverInfo^.dwNumModes-1 do
    begin
      ddsdMode := pDriverInfo^.pddsdModes[x];
      dwRenderDepths := pDeviceInfo^.ddDeviceDesc.dwDeviceRenderBitDepth;
      dwDepth := ddsdMode.ddpfPixelFormat.dwRGBBitCount;

      // Accept modes that are compatable with the device
      if ((dwDepth = 32) and (dwRenderDepths and DDBD_32 <> 0)) or
         ((dwDepth = 24) and (dwRenderDepths and DDBD_24 <> 0)) or
         ((dwDepth = 16) and (dwRenderDepths and DDBD_16 <> 0)) then
      with pDeviceInfo^ do
      begin
        // Copy compatible modes to the list of device-supported modes
        pddsdModes[dwNumModes] := ddsdMode; Inc(dwNumModes);

       // Record whether the device has any stereo modes
       if ddsdMode.ddsCaps.dwCaps2 and DDSCAPS2_STEREOSURFACELEFT  <> 0
          then bStereoCompatible := True;
      end;
    end;
  end;

begin
  Result := D3DENUMRET_OK;
  // Keep track of # of devices that were enumerated
  Inc(g_dwNumDevicesEnumerated);

  pDriverInfo := pParentInfo;
{$IFDEF DELPHI3}
  if g_dwNumDevices >= MAXDEVICES then Exit;
{$ELSE}
  SetLength(g_pDeviceList,g_dwNumDevices+1);
{$ENDIF}
  pDeviceInfo := @g_pDeviceList[g_dwNumDevices];

  FillChar(pDeviceInfo^, SizeOf(TD3DEnum_DeviceInfo), 0);

  // Select either the HAL or HEL device desc:
  with pDeviceInfo^ do
  begin
    bHardware := pDesc.dwDevCaps and D3DDEVCAPS_HWRASTERIZATION <> 0;
    Move(pDesc, ddDeviceDesc, SizeOf(TD3DDeviceDesc7));

    // Set up device info for this device
    bDesktopCompatible := pDriverInfo^.bDesktopCompatible;
    ddDriverCaps       := pDriverInfo^.ddDriverCaps;
    ddHELCaps          := pDriverInfo^.ddHELCaps;
    guidDevice         := pDesc.deviceGUID;
    pDeviceGUID        := @guidDevice;
{$IFDEF DELPHI3}
    // use a fixed array with MAXDESC entries
{$ELSE}
    SetLength(pddsdModes, pDriverInfo^.dwNumModes);
{$ENDIF}
    // Copy the driver GUID and description for the device
    if pDriverInfo^.pDriverGUID <> nil then
    begin
      guidDriver  := pDriverInfo^.guidDriver;
      pDriverGUID := @guidDriver;
      strDesc := pDriverInfo^.strDesc;
    end else
    begin
      pDriverGUID := nil;
      strDesc := strName;
    end;

    // Avoid duplicates: only enum HW devices for secondary DDraw drivers.
    if (pDriverGUID <> nil) and not pDeviceInfo^.bHardware
      then Exit;

    // Give the app a chance to accept or reject this device.
    if Assigned(g_fnAppConfirmFn) then
        if FAILED(g_fnAppConfirmFn(@ddDriverCaps, @ddDeviceDesc))
          then Exit;

    // Build list of supported modes for the device
    StoreSupportedModes;

    // Bail if the device has no supported modes
    if dwNumModes = 0 then Exit;

    // Find a 640x480x16 mode for the default fullscreen mode
    for x := 0 to dwNumModes-1 do
        with pddsdModes[x] do
          if (dwWidth = 640) and (dwHeight = 480) and
            (ddpfPixelFormat.dwRGBBitCount = 16) then
          begin
            ddsdFullscreenMode := pddsdModes[x];
            dwCurrentMode      := x;
            Break;
          end;

    // Select whether the device is initially windowed
    bWindowed := bDesktopCompatible;
  end;
  // Accept the device and return
  Inc(g_dwNumDevices);
end;

//-----------------------------------------------------------------------------
// Name: DriverEnumCallback()
// Desc: Callback function for enumerating drivers.
//-----------------------------------------------------------------------------
function DriverEnumCallback(_pGUID: PGUID; _strDesc, _strName: PAnsiChar;
  pContext: Pointer; Monitor: HMonitor): LongBool; stdcall;
var DevInfo: TD3DEnum_DeviceInfo;
    pDD: IDirectDraw7;
    pD3D: IDirect3D7;
    x: Integer; SortDone: Boolean; ddsdTemp: TDDSurfaceDesc2;
begin
  Result := Boolean(D3DENUMRET_OK);
  // Use the GUID to create the DirectDraw object
  if FAILED(DirectDrawCreateEx(_pGUID, pDD, IID_IDirectDraw7, nil)) then
  begin
    // DEBUG_MSG( _T("Can't create DDraw during enumeration!") );
    Exit;
  end;

  // Create a D3D object, to enumerate the d3d devices
  if FAILED(pDD.QueryInterface(IID_IDirect3D7, pD3D)) then
  begin
    // DEBUG_MSG( _T("Can't query IDirect3D7 during enumeration!") );
    Exit;
  end;

  // Copy data to a device info structure
  FillChar(DevInfo, SizeOf(DevInfo), 0);
  with DevInfo do
  begin
    strDesc := _strDesc;
    ddDriverCaps.dwSize := SizeOf(TDDCaps);
    ddHELCaps.dwSize := sizeof(TDDCaps);
    pDD.GetCaps(@ddDriverCaps, @ddHELCaps);

    if _pGUID <> nil then
    begin
      guidDriver := _pGUID^;
      pDriverGUID := @guidDriver;
    end;

    // Record whether the device can render into a desktop window
    if ddDriverCaps.dwCaps2 and DDCAPS2_CANRENDERWINDOWED <> 0 then
      if pDriverGUID = nil then  bDesktopCompatible := True;

    // Enumerate the fullscreen display modes.
    pDD.EnumDisplayModes(0, nil, @DevInfo, ModeEnumCallback);

    // Sort list of display modes. Delphi still lacks a qsort, so
    // we do a (yuck!) bubble sort here
    repeat
      SortDone := True;
      for x := 0 to dwNumModes-2 do //  Length(pddsdModes)-2 do
        if SortModesCallback(@pddsdModes[x],@pddsdModes[x+1]) > 0 then
        begin
          ddsdTemp := pddsdModes[x]; pddsdModes[x] := pddsdModes[x+1]; pddsdModes[x+1] := ddsdTemp;
          SortDone := False;
        end;
    until SortDone;

    // Now, enumerate all the 3D devices
    pD3D.EnumDevices(DeviceEnumCallback, @DevInfo);

    // Clean up and return
{$IFDEF DELPHI3}
{$ELSE}
    pddsdModes := nil;
{$ENDIF}
  end;
end;


//-----------------------------------------------------------------------------
// Enumerates all drivers, devices, and modes. The callback function is
// called each device, to confirm that the device supports the feature
// set required by the app.
//-----------------------------------------------------------------------------
function D3DEnum_EnumerateDevices(Callback: D3DEnumDevicesCallback): HResult;
begin
  // Store the device enumeration callback function
  g_fnAppConfirmFn := Callback;

  // Enumerate drivers, devices, and modes
  DirectDrawEnumerateEx(DriverEnumCallback, nil,
    DDENUM_ATTACHEDSECONDARYDEVICES or DDENUM_DETACHEDSECONDARYDEVICES
      or DDENUM_NONDISPLAYDEVICES);

  // Make sure devices were actually enumerated
  if g_dwNumDevicesEnumerated = 0 then
  begin
    // DEBUG_MSG( _T("No devices and/or modes were enumerated!")
    Result := HResult(D3DENUMERR_ENUMERATIONFAILED);
  end else if g_dwNumDevices = 0 then
  begin
    // DEBUG_MSG( _T("No enumerated devices were accepted!") );
    // DEBUG_MSG( _T("Try enabling the D3D Reference Rasterizer.") );
    Result := HResult(D3DENUMERR_SUGGESTREFRAST);
  end
    else Result := S_OK;
end;


//-----------------------------------------------------------------------------
// Cleans up any memory allocated during device enumeration
//-----------------------------------------------------------------------------
procedure D3DEnum_FreeResources;
begin
{$IFDEF DELPHI3}
{$ELSE}
  g_pDeviceList := nil;
{$ENDIF}
end;

//-----------------------------------------------------------------------------
// Returns a ptr to the array of enumerated D3DDEVICEINFO structures.
//-----------------------------------------------------------------------------
procedure D3DEnum_GetDevices(var ppDevices:  PD3DEnum_DeviceInfo; var pdwCount: Cardinal);
begin
//  if g_pDeviceList = nil then
  if g_dwNumDevices = 0 then
  begin
    ppDevices := nil; pdwCount := 0;
  end else
  begin
     ppDevices := @g_pDeviceList[0];
//     pdwCount := Length(g_pDeviceList);
     pdwCount := g_dwNumDevices;
  end;
end;

//-----------------------------------------------------------------------------
// Picks a driver based on a set of passed in criteria. The
// D3DENUM_SOFTWAREONLY flag can be used to pick a software device.
//-----------------------------------------------------------------------------
function D3DEnum_SelectDefaultDevice(var pDevice: PD3DEnum_DeviceInfo;
                                     dwFlags: DWord { = 0}): HResult;
var pRefRastDevice, pSoftwareDevice,
    pHardwareDevice, pHardwareTnLDevice,
    pDeviceList: PD3DEnum_DeviceInfo;
    x: Integer; dwNumDevices: Cardinal;
begin
  // Check arguments
  if not Assigned(@pDevice) then
  begin
    Result := E_INVALIDARG; Exit;
  end;

  // Get access to the enumerated device list
  D3DEnum_GetDevices(pDeviceList, dwNumDevices);

  // Look for windowable software, hardware, and hardware TnL devices
  pRefRastDevice := nil; pSoftwareDevice := nil;
  pHardwareDevice := nil;  pHardwareTnLDevice := nil;

  for x := 0 to dwNumDevices-1 do
  begin
    with pDeviceList^ do
      if bDesktopCompatible then
      begin
        if bHardware then
        begin
          if  EqualGUID(pDeviceGUID^, IID_IDirect3DTnLHalDevice)
            then pHardwareTnLDevice := pDeviceList
            else pHardwareDevice := pDeviceList;
        end else
        begin
          if EqualGUID(pDeviceGUID^, IID_IDirect3DRefDevice)
            then pRefRastDevice := pDeviceList
            else pSoftwareDevice := pDeviceList;
        end;
      end;
    Inc(pDeviceList);
  end;

  // Prefer a hardware TnL device first, then a non-TnL hardware device, and
  // finally, a software device.
  Result := S_OK;
  if (dwFlags and D3DENUM_SOFTWAREONLY = 0) and (pHardwareTnLDevice <> nil)
     then pDevice := pHardwareTnLDevice
  else if (dwFlags and D3DENUM_SOFTWAREONLY = 0) and (pHardwareDevice <> nil)
     then pDevice := pHardwareDevice
  else if pSoftwareDevice <> nil then pDevice := pSoftwareDevice
  else if pRefRastDevice <> nil then pDevice := pRefRastDevice
  else Result := HResult(D3DENUMERR_NOCOMPATIBLEDEVICES);

  // Set the windowed state of the newly selected device
  if pDevice <> nil then pDevice^.bWindowed := True;
end;


end.

