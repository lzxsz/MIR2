//-----------------------------------------------------------------------------
// Files: D3DFrame.h & .cpp, Delphi conversion by Arne Schäpers 01-MAR-2000
//
// Desc: Class to manage the Direct3D environment objects such as buffers,
//       viewports, and 3D devices.
//
//       The class is initialized with the Initialize() function, after which
//       the Get????() functions can be used to access the objects needed for
//       rendering. If the device or display needs to be changed, the
//       ChangeDevice() function can be called. If the display window is moved
//       the changes need to be reported with the Move() function.
//
//       After rendering a frame, the ShowFrame() function filps or blits the
//       backbuffer contents to the primary. If surfaces are lost, they can be
//       restored with the RestoreSurfaces() function. Finally, if normal
//       Windows output is needed, the FlipToGDISurface() provides a GDI
//       surface to draw on.
//
// Copyright (c) 1997-1999 Microsoft Corporation. All rights reserved
//-----------------------------------------------------------------------------

unit D3DFrame;

interface
uses Windows, Classes, DirectX, D3DUtil, SysUtils;

//-----------------------------------------------------------------------------
// Name: CD3DFramework7
// Desc: The Direct3D sample framework class for DX7. Maintains the D3D
//       surfaces and device used for 3D rendering.
//-----------------------------------------------------------------------------
type
  TD3DFramework7 = class(TObject)
    private
    // Internal variables for the framework class
    m_hWnd: HWND;               // The window object
    m_bIsFullscreen: Boolean;      // Fullscreen vs. windowed
    m_bIsStereo: Boolean;          // Stereo view mode
    m_dwRenderWidth: Cardinal;      // Dimensions of the render target
    m_dwRenderHeight: Cardinal;
    m_rcScreenRect: TRect;       // Screen rect for window
    m_pDD: IDirectDraw7;                // The DirectDraw object
    m_pD3D: IDirect3D7;               // The Direct3D object
    m_pd3dDevice: IDirect3DDevice7;  // The D3D device
    m_pddsFrontBuffer: IDirectDrawSurface7;    // The primary surface
    m_pddsBackBuffer: IDirectDrawSurface7;     // The backbuffer surface
    m_pddsBackBufferLeft: IDirectDrawSurface7; // For stereo modes
    m_pddsZBuffer: IDirectDrawSurface7;        // The zbuffer surface
    m_dwDeviceMemType: Cardinal;

    // Internal functions for the framework class
    function CreateZBuffer(pDeviceGuid: PGUID): HResult;
    function CreateFullscreenBuffers(Desc: PDDSurfaceDesc2): HResult;
    function CreateWindowedBuffers: HResult;
    function CreateDirectDraw(pDriverGUID: PGUID; dwFlags: Cardinal): HResult;

    function CreateDirect3D(pDeviceGUID: PGUID): HResult;
    function CreateEnvironment(pDriverGUID, pDeviceGUID: PGUID;
          pMode: PDDSurfaceDesc2; dwFlags: Cardinal): HResult;
  public
    constructor Create;
    destructor Destroy; override;
    // Access functions for DirectX objects
    property DirectDraw: IDirectDraw7 read m_pDD;
    property Direct3D: IDirect3D7 read m_pD3D;
    property D3DDevice: IDirect3DDevice7 read m_pd3dDevice;
    property FrontBuffer: IDirectDrawSurface7 read m_pddsFrontBuffer;
    property BackBuffer: IDirectDrawSurface7 read m_pddsBackBuffer;
    property RenderSurface: IDirectDrawSurface7 read m_pddsBackBuffer;
    property RenderSurfaceLeft: IDirectDrawSurface7 read m_pddsBackBufferLeft;

    // Functions to aid rendering
    function RestoreSurfaces: HResult;
    function ShowFrame: HResult;
    function FlipToGDISurface(bDrawFrame: Boolean { = FALSE}): HResult;

    // Functions for managing screen and viewport bounds
    property IsFullscreen: Boolean read m_bIsFullscreen;
    property IsStereo: Boolean read m_bIsStereo;

    procedure Move(x,y: Integer);

    // Creates the Framework
    function Initialize(Window: HWnd; pDriverGUID, pDeviceGUID: PGUID;
      pMode: PDDSURFACEDESC2; dwFlags: Cardinal): HResult;
    function DestroyObjects: HResult;
end;

//-----------------------------------------------------------------------------
// Flags used for the Initialize() method of a CD3DFramework object
//-----------------------------------------------------------------------------
const
  D3DFW_FULLSCREEN    = $00000001; // Use fullscreen mode
  D3DFW_STEREO        = $00000002; // Use stereo-scopic viewing
  D3DFW_ZBUFFER       = $00000004; // Create and use a zbuffer
  D3DFW_NO_FPUSETUP   = $00000008; // Don't use default DDSCL_FPUSETUP flag


//-----------------------------------------------------------------------------
// Errors that the Initialize() and ChangeDriver() calls may return
//-----------------------------------------------------------------------------
const
  D3DFWERR_INITIALIZATIONFAILED = HResult($82000000);
  D3DFWERR_NODIRECTDRAW         = HResult($82000001);
  D3DFWERR_COULDNTSETCOOPLEVEL  = HResult($82000002);
  D3DFWERR_NODIRECT3D           = HResult($82000003);
  D3DFWERR_NO3DDEVICE           = HResult($82000004);
  D3DFWERR_NOZBUFFER            = HResult($82000005);
  D3DFWERR_INVALIDZBUFFERDEPTH  = HResult($82000006);
  D3DFWERR_NOVIEWPORT           = HResult($82000007);
  D3DFWERR_NOPRIMARY            = HResult($82000008);
  D3DFWERR_NOCLIPPER            = HResult($82000009);
  D3DFWERR_BADDISPLAYMODE       = HResult($8200000a);
  D3DFWERR_NOBACKBUFFER         = HResult($8200000b);
  D3DFWERR_NONZEROREFCOUNT      = HResult($8200000c);
  D3DFWERR_NORENDERTARGET       = HResult($8200000d);
  D3DFWERR_INVALIDMODE          = HResult($8200000e);
  D3DFWERR_NOTINITIALIZED       = HResult($8200000f);

implementation

{ TD3DFramework7 }

constructor TD3DFramework7.Create;
begin
  // CPP version initializes all m_ variables to 0
end;

destructor TD3DFramework7.Destroy;
begin
  DestroyObjects;
  inherited;
end;

//-----------------------------------------------------------------------------
// Name: CreateDirect3D()
// Desc: Create the Direct3D interface
//-----------------------------------------------------------------------------

function TD3DFramework7.CreateDirect3D(pDeviceGUID: PGUID): HResult;
var vp: TD3DViewPort7;
begin
  // Query DirectDraw for access to Direct3D
  if FAILED(m_pDD.QueryInterface(IID_IDirect3D7, m_pD3D )) then
  begin
    // DEBUG_MSG( _T("Couldn't get the Direct3D interface") );
    Result := D3DFWERR_NODIRECT3D;
    Exit;
  end;

  // Create the device
  if FAILED(m_pD3D.CreateDevice(pDeviceGUID^, m_pddsBackBuffer, m_pd3dDevice)) then
  begin
    // DEBUG_MSG( _T("Couldn't create the D3DDevice") );
    Result := D3DFWERR_NO3DDEVICE;
    Exit;
  end;

  // Finally, set the viewport for the newly created device
  with vp do
  begin
    dwX := 0; dwY := 0; dwWidth := m_dwRenderWidth; dwHeight := m_dwRenderHeight;
    dvMinZ := 0; dvMaxZ := 1.0;
  end;
  if FAILED(m_pd3dDevice.SetViewport(vp)) then
  begin
    // DEBUG_MSG( _T("Error: Couldn't set current viewport to device") );
    Result := D3DFWERR_NOVIEWPORT;
    Exit;
  end;
  Result := S_OK;
end;


//-----------------------------------------------------------------------------
// Name: CreateDirectDraw()
// Desc: Create the DirectDraw interface
//-----------------------------------------------------------------------------
function TD3DFramework7.CreateDirectDraw(pDriverGUID: PGUID;
  dwFlags: Cardinal): HResult;
var dwCoopFlags: Cardinal; ddsd: TDDSurfaceDesc2;
begin
  // Create the DirectDraw interface, and query for the DD7 interface
  if FAILED(DirectDrawCreateEx(pDriverGUID, m_pDD, IID_IDirectDraw7, nil)) then
  begin
    // DEBUG_MSG( _T("Could not create DirectDraw") );
    Result := D3DFWERR_NODIRECTDRAW;
    Exit;
  end;

  // Set the Windows cooperative level
  dwCoopFlags := DDSCL_NORMAL;
  if m_bIsFullscreen then
      dwCoopFlags := DDSCL_ALLOWREBOOT or DDSCL_EXCLUSIVE or DDSCL_FULLSCREEN;

  // By default, set the flag to allow D3D to optimize floating point calcs
  if dwFlags and D3DFW_NO_FPUSETUP = 0 then
    dwCoopFlags := dwCoopFlags or DDSCL_FPUSETUP;

  if FAILED(m_pDD.SetCooperativeLevel(m_hWnd, dwCoopFlags)) then
  begin
    // DEBUG_MSG( _T("Couldn't set coop level") );
    Result := D3DFWERR_COULDNTSETCOOPLEVEL;
    Exit;
  end;

  // Check that we are NOT in a palettized display. That case will fail,
  // since the framework doesn't use palettes.
  ddsd.dwSize := SizeOf(ddsd);
  m_pDD.GetDisplayMode(ddsd);
  if ddsd.ddpfPixelFormat.dwRGBBitCount <= 8 then Result := D3DFWERR_INVALIDMODE
    else Result := S_OK;
end;


//-----------------------------------------------------------------------------
// Name: CreateEnvironment()
// Desc: Creates the internal objects for the framework
//-----------------------------------------------------------------------------
function TD3DFramework7.CreateEnvironment(pDriverGUID, pDeviceGUID: PGUID;
  pMode: PDDSurfaceDesc2; dwFlags: Cardinal): HResult;
begin
  // Select the default memory type, for whether the device is HW or SW
  if EqualGUID(pDeviceGUID^, IID_IDirect3DHALDevice)
    then m_dwDeviceMemType := DDSCAPS_VIDEOMEMORY
   else if EqualGUID(pDeviceGUID^, IID_IDirect3DTnLHalDevice)
     then m_dwDeviceMemType := DDSCAPS_VIDEOMEMORY
   else m_dwDeviceMemType := DDSCAPS_SYSTEMMEMORY;

  // Create the DDraw object
  Result := CreateDirectDraw(pDriverGUID, dwFlags);
  if FAILED(Result) then Exit;

  // Create the front and back buffers, and attach a clipper
  if dwFlags and D3DFW_FULLSCREEN <> 0 then Result := CreateFullscreenBuffers(pMode)
    else Result := CreateWindowedBuffers;
  if FAILED(Result) then Exit;

  // Create the Direct3D object and the Direct3DDevice object
  Result := CreateDirect3D(pDeviceGUID);
  if FAILED(Result) then Exit;

  // Create and attach the zbuffer
  if dwFlags and D3DFW_ZBUFFER <> 0 then Result := CreateZBuffer(pDeviceGUID);
end;

//-----------------------------------------------------------------------------
// Name: CreateFullscreenBuffers()
// Desc: Creates the primary and (optional) backbuffer for rendering.
//       Windowed mode and fullscreen mode are handled differently.
//-----------------------------------------------------------------------------
function TD3DFramework7.CreateFullscreenBuffers(
  Desc: PDDSurfaceDesc2): HResult;
var dwModeFlags: Cardinal; ddsd: TDDSurfaceDesc2; ddscaps: TDDSCaps2;
begin
  // Get the dimensions of the screen bounds
  // Store the rectangle which contains the renderer
  m_rcScreenRect := Rect(0, 0, Desc.dwWidth, Desc.dwHeight);
  m_dwRenderWidth  := m_rcScreenRect.right  - m_rcScreenRect.left;
  m_dwRenderHeight := m_rcScreenRect.bottom - m_rcScreenRect.top;

  // Set the display mode to the requested dimensions. Check for
  // 320x200x8 modes, and set flag to avoid using ModeX
  if (m_dwRenderWidth = 320) and (m_dwRenderHeight = 200) and
      (Desc.ddpfPixelFormat.dwRGBBitCount = 8)
   then dwModeFlags := DDSDM_STANDARDVGAMODE
   else dwModeFlags := 0;

  if FAILED(m_pDD.SetDisplayMode(m_dwRenderWidth, m_dwRenderHeight,
    Desc.ddpfPixelFormat.dwRGBBitCount, Desc.dwRefreshRate, dwModeFlags)) then
  begin
    // DEBUG_MSG( _T("Can't set display mode") );
    Result := D3DFWERR_BADDISPLAYMODE;
    Exit;
  end;

  // Setup to create the primary surface w/backbuffer
  FillChar(ddsd, SizeOf(ddsd), 0);
  with ddsd do
  begin
    dwSize := Sizeof(ddsd);
    dwFlags := DDSD_CAPS or DDSD_BACKBUFFERCOUNT;
    ddsCaps.dwCaps := DDSCAPS_PRIMARYSURFACE or DDSCAPS_3DDEVICE or
                            DDSCAPS_FLIP or DDSCAPS_COMPLEX;
    dwBackBufferCount := 1;

    // Support for stereoscopic viewing
    if m_bIsStereo then
    begin
      ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_VIDEOMEMORY;
      ddsCaps.dwCaps2 := ddsCaps.dwCaps2 or DDSCAPS2_STEREOSURFACELEFT;
    end;
  end;

  // Create the primary surface
  Result := m_pDD.CreateSurface(ddsd, m_pddsFrontBuffer, nil);
  if FAILED(Result) then
  begin
    // DEBUG_MSG( _T("Error: Can't create primary surface") );
    if Result <> DDERR_OUTOFVIDEOMEMORY then Result := D3DFWERR_NOPRIMARY
     else ; // DEBUG_MSG( _T("Error: Out of video memory") );
    Exit;
  end;

  // Get the backbuffer, which was created along with the primary.
  FillChar(ddscaps,SizeOf(ddscaps),0);
  ddscaps.dwCaps := DDSCAPS_BACKBUFFER;
  Result := m_pddsFrontBuffer.GetAttachedSurface(ddscaps, m_pddsBackBuffer);
  if FAILED(Result) then
  begin
    // DEBUG_ERR( hr, _T("Error: Can't get the backbuffer") );
    Result := D3DFWERR_NOBACKBUFFER;
    Exit;
  end;

  // Increment the backbuffer count (for consistency with windowed mode)
  m_pddsBackBuffer._AddRef;

  // Support for stereoscopic viewing
  if m_bIsStereo then
  begin
    // Get the left backbuffer, which was created along with the primary.
    ddscaps.dwCaps := 0; ddscaps.dwCaps2 := DDSCAPS2_STEREOSURFACELEFT;
    Result := m_pddsBackBuffer.GetAttachedSurface(ddscaps, m_pddsBackBufferLeft);
    if FAILED(Result) then
    begin
      // DEBUG_ERR( hr, _T("Error: Can't get the left backbuffer") );
      Result := D3DFWERR_NOBACKBUFFER;
      Exit;
    end;
    m_pddsBackBufferLeft._AddRef;
  end;

  Result := S_OK;
end;


//-----------------------------------------------------------------------------
// Name: CreateWindowedBuffers()
// Desc: Creates the primary and (optional) backbuffer for rendering.
//       Windowed mode and fullscreen mode are handled differently.
//-----------------------------------------------------------------------------
function TD3DFramework7.CreateWindowedBuffers: HResult;
var ddsd: TDDSurfaceDesc2; pcClipper: IDirectDrawClipper;
begin
  // Get the dimensions of the viewport and screen bounds
  GetClientRect(m_hWnd, m_rcScreenRect );
  MapWindowPoints(m_hWnd, HWND_DESKTOP, m_rcScreenRect.TopLeft, 2);

  m_dwRenderWidth  := m_rcScreenRect.right  - m_rcScreenRect.left;
  m_dwRenderHeight := m_rcScreenRect.bottom - m_rcScreenRect.top;

  // Create the primary surface
  FillChar(ddsd,SizeOf(ddsd),0);
  with ddsd do
  begin
    dwSize := sizeof(ddsd); dwFlags := DDSD_CAPS;
    ddsCaps.dwCaps := DDSCAPS_PRIMARYSURFACE;
  end;

  Result := m_pDD.CreateSurface(ddsd, m_pddsFrontBuffer, nil);
  if FAILED(Result) then
  begin
    // DEBUG_MSG( _T("Error: Can't create primary surface") );
    if Result <> DDERR_OUTOFVIDEOMEMORY then Result := D3DFWERR_NOPRIMARY
    else
    begin
      // DEBUG_MSG( _T("Error: Out of video memory") );
      Result := DDERR_OUTOFVIDEOMEMORY;
    end;
    Exit;
  end;

  // Create a clipper object
  if FAILED(m_pDD.CreateClipper( 0, pcClipper, nil)) then
  begin
    // DEBUG_MSG( _T("Error: Couldn't create clipper") );
    Result := D3DFWERR_NOCLIPPER;
    Exit;
  end;

  // Associate the clipper with the window
  pcClipper.SetHWnd(0, m_hWnd);
  m_pddsFrontBuffer.SetClipper(pcClipper);

  // Create a backbuffer
  with ddsd do
  begin
    dwFlags := DDSD_WIDTH or DDSD_HEIGHT or DDSD_CAPS;
    dwWidth := m_dwRenderWidth;
    dwHeight := m_dwRenderHeight;
    ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN or DDSCAPS_3DDEVICE;
  end;

  Result := m_pDD.CreateSurface(ddsd, m_pddsBackBuffer, nil);
  if FAILED(Result) then
  begin
    // DEBUG_ERR( hr, _T("Error: Couldn't create the backbuffer") );
    if Result <> DDERR_OUTOFVIDEOMEMORY then Result := D3DFWERR_NOBACKBUFFER
      else ; // DEBUG_MSG( _T("Error: Out of video memory") );
    Exit;
  end;

  Result := S_OK;
end;

//-----------------------------------------------------------------------------
// Name: EnumZBufferFormatsCallback()
// Desc: Simply returns the first matching enumerated z-buffer format
//-----------------------------------------------------------------------------
function EnumZBufferFormatsCallback(var lpDDPixFmt: TDDPixelFormat;
      lpContext: Pointer): HResult; stdcall;
var pddpfOut: PDDPixelFormat;
begin
  pddpfOut := lpContext;
  if pddpfOut^.dwRGBBitCount = lpDDPixFmt.dwRGBBitCount then
  begin
    pddpfOut^ := lpDDPixFmt;
    Result := D3DENUMRET_CANCEL;
  end
    else Result := D3DENUMRET_OK;
end;


//-----------------------------------------------------------------------------
// Name: CreateZBuffer()
// Desc: Internal function called by Create() to make and attach a zbuffer
//       to the renderer
//-----------------------------------------------------------------------------
function TD3DFramework7.CreateZBuffer(pDevicEGUID: PGUID): HResult;
var ddDesc: TD3DDeviceDesc7; ddsd: TDDSurfaceDesc2;
begin
  // Check if the device supports z-bufferless hidden surface removal. If so,
  // we don't really need a z-buffer
  m_pd3dDevice.GetCaps(ddDesc);
  if(ddDesc.dpcTriCaps.dwRasterCaps and D3DPRASTERCAPS_ZBUFFERLESSHSR <> 0) then
  begin
    Result := S_OK; Exit;
  end;

  // Get z-buffer dimensions from the render target
  ddsd.dwSize := SizeOf(ddsd);
  m_pddsBackBuffer.GetSurfaceDesc(ddsd);

  // Setup the surface desc for the z-buffer.
  with ddsd do
  begin
    dwFlags        := DDSD_WIDTH or DDSD_HEIGHT or DDSD_CAPS or DDSD_PIXELFORMAT;
    ddsCaps.dwCaps := DDSCAPS_ZBUFFER or m_dwDeviceMemType;
    ddpfPixelFormat.dwSize := 0;  // Tag the pixel format as unitialized

    // Get an appropiate pixel format from enumeration of the formats. On the
    // first pass, we look for a zbuffer dpeth which is equal to the frame
    // buffer depth (as some cards unfornately require this).
    m_pD3D.EnumZBufferFormats(pDeviceGUID^,
      EnumZBufferFormatsCallback, @ddpfPixelFormat);

      if ddpfPixelFormat.dwSize = 0 then
      begin // Try again, just accepting any 16-bit zbuffer
        ddpfPixelFormat.dwRGBBitCount := 16;
        m_pD3D.EnumZBufferFormats(pDeviceGUID^,
          EnumZBufferFormatsCallback, @ddpfPixelFormat);

        if ddpfPixelFormat.dwSize = 0 then
        begin
          // DEBUG_MSG( _T("Device doesn't support requested zbuffer format") );
          Result := D3DFWERR_NOZBUFFER;
          Exit;
        end;
      end;
  end;

  // Create and attach a z-buffer
  Result := m_pDD.CreateSurface(ddsd, m_pddsZBuffer, nil);
  if FAILED(Result) then
  begin
    // DEBUG_MSG( _T("Error: Couldn't create a ZBuffer surface") );
    if Result <> DDERR_OUTOFVIDEOMEMORY then Result := D3DFWERR_NOZBUFFER
      else ; // DEBUG_MSG( _T("Error: Out of video memory") );
    Exit;
  end;

  if FAILED(m_pddsBackBuffer.AddAttachedSurface(m_pddsZBuffer)) then
  begin
    // DEBUG_MSG( _T("Error: Couldn't attach zbuffer to render surface") );
    Result := D3DFWERR_NOZBUFFER;
    Exit;
  end;


  // For stereoscopic viewing, attach zbuffer to left surface as well
  if m_bIsStereo then
  begin
    if FAILED(m_pddsBackBufferLeft.AddAttachedSurface(m_pddsZBuffer)) then
    begin
      // DEBUG_MSG( _T("Error: Couldn't attach zbuffer to left render surface") );
      Result := D3DFWERR_NOZBUFFER;
      Exit;
    end;
  end;

  // Finally, this call rebuilds internal structures
  if FAILED(m_pd3dDevice.SetRenderTarget(m_pddsBackBuffer, 0)) then
  begin
    // DEBUG_MSG( _T("Error: SetRenderTarget() failed after attaching zbuffer!") );
    Result := D3DFWERR_NOZBUFFER;
    Exit;
  end;

  Result := S_OK;
end;


//-----------------------------------------------------------------------------
// Name: DestroyObjects()
// Desc: Cleans everything up upon deletion. This code returns an error
//       if any of the objects have remaining reference counts.
//-----------------------------------------------------------------------------
function TD3DFramework7.DestroyObjects: HResult;
var RefCount: Integer;
begin
  Result := S_OK;
  if Assigned(m_pDD) then m_pDD.SetCooperativeLevel(m_hWnd, DDSCL_NORMAL);

  if Assigned(m_pd3dDevice) then
  begin // Do a safe check for releasing the D3DDEVICE. RefCount must be zero.
    RefCount := m_pd3dDevice._Release;
    if RefCount > 0 then
    begin
      Result := D3DFWERR_NONZEROREFCOUNT;
      // DEBUG_MSG( _T("Error: D3DDevice object is still referenced!") );
    end;
    Pointer(m_pd3dDevice) := nil;  // Refcount already decreased
  end;

  m_pddsBackBuffer := nil; m_pddsBackBufferLeft := nil;
  m_pddsZBuffer := nil; m_pddsFrontBuffer := nil;
  m_pD3D := nil;

  if Assigned(m_pDD) then
  begin  // Do a safe check for releasing DDRAW. RefCount must be zero.
    RefCount := m_pDD._Release;
    if RefCount > 0 then
    begin
      Result := D3DFWERR_NONZEROREFCOUNT;
      // DEBUG_MSG( _T("Error: DDraw object is still referenced!") );
    end;
    Pointer(m_pDD) := nil;
  end;
end;

//-----------------------------------------------------------------------------
// Name: FlipToGDISurface()
// Desc: Puts the GDI surface in front of the primary, so that dialog
//       boxes and other windows drawing funcs may happen.
//-----------------------------------------------------------------------------
function TD3DFramework7.FlipToGDISurface(bDrawFrame: Boolean): HResult;
begin
  if Assigned(m_pDD) and m_bIsFullscreen then
  begin
    m_pDD.FlipToGDISurface;
    if bDrawFrame then
    begin
     DrawMenuBar(m_hWnd);
     RedrawWindow(m_hWnd, nil, 0, RDW_FRAME);
    end;
  end;
  Result := S_OK;
end;


function TD3DFramework7.Initialize(Window: HWnd; pDriverGUID,
  pDeviceGUID: PGUID; pMode: PDDSurfaceDesc2; dwFlags: Cardinal): HResult;
begin
  // Check params. Note: A NULL mode is valid for windowed modes only.
  if (Window = 0) or (pDeviceGUID = nil) or
      ((pMode = nil) and (dwFlags and D3DFW_FULLSCREEN <> 0)) then
  begin
    Result := E_INVALIDARG; Exit;
  end;

  // Setup state for windowed/fullscreen mode
  m_hWnd := Window; m_bIsStereo := False;
  m_bIsFullscreen := (dwFlags and D3DFW_FULLSCREEN) <> 0;

  // Support stereoscopic viewing for fullscreen modes which support it
  if ((dwFlags and D3DFW_STEREO  <> 0) and (dwFlags and D3DFW_FULLSCREEN <> 0)) then
    if pMode^.ddsCaps.dwCaps2 and DDSCAPS2_STEREOSURFACELEFT <> 0
      then m_bIsStereo := True;

  // Create the D3D rendering environment (surfaces, device, viewport, etc.)
  Result := CreateEnvironment(pDriverGUID, pDeviceGUID, pMode, dwFlags);
  if FAILED(Result) then DestroyObjects
   else Result := S_OK;
end;

//-----------------------------------------------------------------------------
// Name: Move()
// Desc: Moves the screen rect for windowed renderers
//-----------------------------------------------------------------------------
procedure TD3DFramework7.Move(x, y: Integer);
begin
  if not m_bIsFullscreen then
    m_rcScreenRect := Rect(x, y, x+ Integer(m_dwRenderWidth), y + Integer(m_dwRenderHeight));
end;


//-----------------------------------------------------------------------------
// Name: RestoreSurfaces()
// Desc: Checks for lost surfaces and restores them if lost. Note: Don't
//       restore render surface, since it's just a duplicate ptr.
//-----------------------------------------------------------------------------
function TD3DFramework7.RestoreSurfaces: HResult;
begin
  Result := m_pDD.RestoreAllSurfaces;
end;

//-----------------------------------------------------------------------------
// Name: ShowFrame()
// Desc: Show the frame on the primary surface, via a blt or a flip.
//-----------------------------------------------------------------------------
function TD3DFramework7.ShowFrame: HResult;
begin
  if not Assigned(m_pddsFrontBuffer) then
  begin
    Result := D3DFWERR_NOTINITIALIZED; Exit;
  end;

  if m_bIsFullscreen then
  begin // We are in fullscreen mode, so perform a flip.
    if m_bIsStereo then Result := m_pddsFrontBuffer.Flip(nil, DDFLIP_WAIT or DDFLIP_STEREO )
     else Result := m_pddsFrontBuffer.Flip(nil, DDFLIP_WAIT);
  end
    else // We are in windowed mode, so perform a blit.
      Result := m_pddsFrontBuffer.Blt(@m_rcScreenRect, m_pddsBackBuffer, nil, DDBLT_WAIT, nil);
end;

end.

