//-----------------------------------------------------------------------------
// File: D3DApp.h & .cpp,
// Delphi translation by Arne Schäpers, 01-MAR-2000
//
// Application class for the Direct3D samples framework library.
//
// Copyright (c) 1998-1999 Microsoft Corporation.
// All rights reserved.
//-----------------------------------------------------------------------------

unit D3DApp;

interface
{$IFDEF VER100} {$DEFINE DELPHI3} {$ENDIF}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, DirectX,  // Erik's Header for DX7
  D3DFrame, D3DEnum, D3DUtil, MMSystem, Menus,
  DXTimer;  // threaded timer with msec accuracy

type
  TAPPMSGTYPE = (MSG_NONE, MSGERR_APPMUSTEXIT,
    MSGWARN_SWITCHEDTOSOFTWARE);

  TD3DEnumDevicesCallback = function(Caps: PDDCaps;
    Desc: PD3DDeviceDesc7): HResult of object;

  TD3DApplication = class(TForm)
    MainMenu: TMainMenu;
    mFile: TMenuItem;
    mFileGoStop: TMenuItem;
    mFileSingleStep: TMenuItem;
    N1: TMenuItem;
    mFileAbout: TMenuItem;
    mFileChangeDevice: TMenuItem;
    N2: TMenuItem;
    mFileExit: TMenuItem;
    mFileFullscreen: TMenuItem;
    N3: TMenuItem;
    ContextMenu: TPopupMenu;
    mContextGoStop: TMenuItem;
    mContextSingleStep: TMenuItem;
    N4: TMenuItem;
    mContextFullscreen: TMenuItem;
    mContextChangeDevice: TMenuItem;
    N5: TMenuItem;
    mContextAbout: TMenuItem;
    N6: TMenuItem;
    mContextExit: TMenuItem;
    procedure mFileGoStopClick(Sender: TObject);
    procedure mFileSingleStepClick(Sender: TObject);
    procedure mFileAboutClick(Sender: TObject);
    procedure mFileChangeDeviceClick(Sender: TObject);
    procedure mFileExitClick(Sender: TObject);
    procedure mFileFullscreenClick(Sender: TObject);
  private
    // switch between full screen and windowed mode
    bOldWindowedState: Boolean; //  = TRUE on init;
    dwSavedStyle: Cardinal;
    rcSaved: TRect;  // window rect (screen coords)

    // Internal variables and member functions
    m_pFramework: TD3DFramework7;
    m_bActive, m_bReady: Boolean;
    m_bFrameMoving, m_bSingleStep: Boolean;

    m_dwBaseTime, m_dwStopTime: Cardinal;

    m_matLeftView, m_matRightView, m_matView: TD3DMatrix;
    function Getm_pD3D: IDirect3D7;
    function Getm_pd3dDevice: IDirect3dDevice7;
    function Getm_pDD: IDirectDraw7;
    function Getm_pddsRenderTarget: IDirectDrawSurface7;
    function Getm_pddsRenderTargetLeft: IDirectDrawSurface7;
  private
    function Initialize3DEnvironment: HResult;
    function Change3DEnvironment: HResult;

    function Render3DEnvironment: HResult;
    procedure Cleanup3DEnvironment;
    procedure DisplayFrameworkError(hr: HRESULT; dwType: TAPPMSGTYPE);

  protected
    m_hWnd: HWnd;
    m_pDeviceInfo: PD3DEnum_DeviceInfo;
    m_ddsdRenderTarget: TDDSurfaceDesc2;
    property m_pDD: IDirectDraw7 read Getm_pDD;
    property m_pD3D: IDirect3D7 read Getm_pD3D;
    property m_pd3dDevice: IDirect3dDevice7
      read Getm_pd3dDevice;
    property m_pddsRenderTarget: IDirectDrawSurface7
      read Getm_pddsRenderTarget;
    property m_pddsRenderTargetLeft: IDirectDrawSurface7
      read Getm_pddsRenderTargetLeft;
  protected     // Overridable variables for the app
    m_bAppUseZBuffer, m_bAppUseStereo, m_bShowStats: Boolean;
    // Device enumeration confirmation
    FOnConfirmDevice: TD3DEnumDevicesCallback;

    // Overridable functions for the 3D scene created by the app
    function OneTimeSceneInit: HResult; virtual;
    function InitDeviceObjects: HResult; virtual;
    function DeleteDeviceObjects: HResult; virtual;
    function Render: HResult; virtual;
    function FrameMove(fTimeKey: FLOAT): HResult; virtual;
    function RestoreSurfaces: HResult; virtual;
    function FinalCleanup: HResult; virtual;

    // Overridable power management (APM) functions
    function OnQuerySuspend(dwFlags: Cardinal): Cardinal; virtual;
    function OnResumeSuspend(dwFlags: Cardinal): Cardinal; virtual;

    // View control functions (for stereo-enabled applications)
    property AppLeftViewMatrix: TD3DMatrix
      read m_matLeftView write m_matLeftView;
    property AppRightViewMatrix: TD3DMatrix
      read m_matRightView write m_matRightView;
    property AppViewMatrix: TD3DMatrix
      read m_matView write m_matView;

    procedure SetViewParams(vEyept, vLookatPt,
      vUpVec: PD3DVector; fEyeDistance: FLOAT);

    // Miscellaneous functions
    procedure ShowStats;
    procedure OutputText(x, y: Integer; Str: String);
  protected  // overriden VCL member functions
    procedure DoCreate; {$IFNDEF DELPHI3} override; {$ENDIF}
    procedure DoDestroy; {$IFNDEF DELPHI3} override; {$ENDIF}
    procedure Paint; override;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMMove(var Msg: TWMMove); message WM_MOVE;
    procedure WMEnterMenuLoop(var Msg: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var Msg: TMessage); message WM_EXITMENULOOP;
    procedure WMEnterSizeMove(var Msg: TMessage); message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove(var Msg: TMessage); message WM_EXITSIZEMOVE;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMPowerBroadcast(var Msg: TWMPower); message WM_POWERBROADCAST;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
  public
    // Functions to create, run, pause, and clean up the application
    constructor Create(AOwner: TComponent); override;
    {$IFDEF DELPHI3}
    destructor Destroy; override;
    {$ENDIF}
    function CreateFramework: HResult; // C++ member function "Create"
    procedure Pause(bPause: Boolean); virtual;
  public
    DXTimer: TDXTimer;
    procedure OnDXTimer(Sender: TObject); virtual;
    property OnConfirmDevice: TD3DEnumDevicesCallback read FOnConfirmDevice write FOnConfirmDevice;
  end;

// declaration of object variable for this form deleted
// we don't want an auto created instance here!

implementation

{$R *.DFM}

{ TD3DApplication }
//-----------------------------------------------------------------------------
// Name: Change3DEnvironment()
// Desc: Handles driver, device, and/or mode changes for the app.
//-----------------------------------------------------------------------------
function TD3DApplication.Change3DEnvironment: HResult;
begin
  // Release all scene objects that will be re-created for the new device
  DeleteDeviceObjects;

  // Release framework objects, so a new device can be created
  Result := m_pFramework.DestroyObjects;
  if FAILED(Result) then
  begin
    DisplayFrameworkError(Result, MSGERR_APPMUSTEXIT );
    Exit;
  end;

  // Check if going from fullscreen to windowed mode, or vice versa.
  if m_pDeviceInfo^.bWindowed <> bOldWindowedState then
  begin
    if m_pDeviceInfo^.bWindowed then
    begin // Coming from fullscreen mode, so restore window properties
      SetWindowLong(m_hWnd, GWL_STYLE, dwSavedStyle);
      SetWindowPos(m_hWnd, HWND_NOTOPMOST, rcSaved.left, rcSaved.top,
        (rcSaved.right - rcSaved.left), (rcSaved.bottom - rcSaved.top), SWP_SHOWWINDOW);
    end else
    begin // Going to fullscreen mode, save/set window properties as needed
      dwSavedStyle := GetWindowLong( m_hWnd, GWL_STYLE );
      GetWindowRect( m_hWnd, rcSaved );
      SetWindowLong( m_hWnd, GWL_STYLE, Integer(WS_POPUP or WS_SYSMENU or WS_VISIBLE) );
    end;
    bOldWindowedState := m_pDeviceInfo^.bWindowed;
  end;

  // Inform the framework class of the driver change. It will internally
  // re-create valid surfaces, a d3ddevice, etc.
  Result := Initialize3DEnvironment;
  if FAILED(Result) then
  begin
    DisplayFrameworkError(Result, MSGERR_APPMUSTEXIT);
    Exit;
  end;

  // If the app is paused, trigger the rendering of the current frame
  if not m_bFrameMoving then
  begin
    m_bSingleStep := TRUE;
    Inc(m_dwBaseTime, timeGetTime - m_dwStopTime);
    m_dwStopTime  := timeGetTime;
  end;
  Result := S_OK;
end;


//-----------------------------------------------------------------------------
// Name: Cleanup3DEnvironment()
// Desc: Cleanup scene objects
//-----------------------------------------------------------------------------
procedure TD3DApplication.Cleanup3DEnvironment;
begin
  if Assigned(DXTimer) then DXTimer.Enabled := False;  // Delphi specific
  m_bActive := False; m_bReady := False;
  if Assigned(m_pFramework) then
  begin
    DeleteDeviceObjects;
    m_pFrameWork.Free; m_pFrameWork := nil;
    FinalCleanup;
  end;
  D3DEnum_FreeResources;
end;

//-----------------------------------------------------------------------------
// Name: DisplayFrameworkError()
// Desc: Displays error messages in a message box
//-----------------------------------------------------------------------------
procedure TD3DApplication.DisplayFrameworkError(hr: HRESULT;
  dwType: TAPPMSGTYPE);
var StrMsg: String;
begin
  case hr of
    D3DENUMERR_NODIRECTDRAW:
      strMsg := 'Could not create DirectDraw!';
    D3DENUMERR_NOCOMPATIBLEDEVICES:
      strMsg := 'Could not find any compatible Direct3D devices.';
    D3DENUMERR_SUGGESTREFRAST:
      strMsg := 'Could not find any compatible devices.'#13#10+
                'Try enabling the reference rasterizer using EnableRefRast.reg.';
    D3DENUMERR_ENUMERATIONFAILED:
      strMsg := 'Enumeration failed. Your system may be in an'#13#10+
                'unstable state and need to be rebooted';
    D3DFWERR_INITIALIZATIONFAILED:
      strMsg := 'Generic initialization error.'#13#10+
                'Enable debug output for detailed information.';
    D3DFWERR_NODIRECTDRAW:
      strMsg := 'No DirectDraw';
    D3DFWERR_NODIRECT3D:
      strMsg := 'No Direct3D';
    D3DFWERR_INVALIDMODE:
      strMsg := 'This sample requires a 16-bit (or higher) ' +
                'display mode\nto run in a window.'#13#10+
                'Please switch your desktop settings accordingly.';
    D3DFWERR_COULDNTSETCOOPLEVEL:
      strMsg := 'Could not set Cooperative Level';

    D3DFWERR_NO3DDEVICE:
      begin
        strMsg := 'Could not create the Direct3DDevice object.';
        if dwType = MSGWARN_SWITCHEDTOSOFTWARE then
          strMsg := strMsg + #13#10+'The 3D hardware chipset may not support'+
             ' rendering in the current display mode.';
      end;
    D3DFWERR_NOZBUFFER:
      strMsg := 'No ZBuffer';
    D3DFWERR_INVALIDZBUFFERDEPTH:
      strMsg := 'Invalid Z-buffer depth. Try switching modes'#13#10+
                'from 16- to 32-bit (or vice versa)';
    D3DFWERR_NOVIEWPORT:
      strMsg := 'No Viewport';
    D3DFWERR_NOPRIMARY:
      strMsg := 'No primary';
    D3DFWERR_NOCLIPPER:
      strMsg := 'No Clipper';
    D3DFWERR_BADDISPLAYMODE:
      strMsg := 'Bad display mode';
    D3DFWERR_NOBACKBUFFER:
      strMsg := 'No backbuffer';
    D3DFWERR_NONZEROREFCOUNT:
      strMsg := 'A DDraw object has a non-zero reference'#13#10+
                 'count (meaning it was not properly cleaned up).';
    D3DFWERR_NORENDERTARGET:
      strMsg := 'No render target';
    E_OUTOFMEMORY:
      strMsg := 'Not enough memory!';
    DDERR_OUTOFVIDEOMEMORY:
      strMsg := 'There was insufficient video memory to use the'#13#10+
                'hardware device.';
  else
     strMsg := 'Generic application error.'#13#10'Enable '+
               'debug output for detailed information.';
  end; // case

  if dwType = MSGERR_APPMUSTEXIT then
  begin
    strMsg := strMsg + #13#10'This sample will now exit.';
    MessageDlg(strMsg, mtError, [mbOK], 0);
    PostQuitMessage(0);
  end else
  begin
    if dwType = MSGWARN_SWITCHEDTOSOFTWARE then
      strMsg := strMsg + #13#10+'Switching to software rasterizer.';
    MessageDlg(strMsg, mtWarning, [mbOK], 0);
  end;
end;



// =======================================================================
// App specific overridables - might as well have been declared as abstract
function TD3DApplication.InitDeviceObjects: HResult;
begin Result := S_OK; end;
function TD3DApplication.DeleteDeviceObjects: HResult;
begin Result := S_OK; end;
function TD3DApplication.OneTimeSceneInit: HResult;
begin Result := S_OK; end;
function TD3DApplication.Render: HResult;
begin Result := S_OK; end;
function TD3DApplication.FinalCleanup: HResult;
begin Result := S_OK; end;
function TD3DApplication.RestoreSurfaces: HResult;
begin Result := S_OK; end;
function TD3DApplication.FrameMove(fTimeKey: FLOAT): HResult;
begin Result := S_OK; end;

// =========================================================================
//-----------------------------------------------------------------------------
// Name: Initialize3DEnvironment()
// Desc: Initializes the sample framework, then calls the app-specific function
//       to initialize device specific objects. This code is structured to
//       handled any errors that may occur duing initialization
//-----------------------------------------------------------------------------
function TD3DApplication.Initialize3DEnvironment: HResult;
var dwFrameworkFlags: Cardinal;
begin
  if not m_pDeviceInfo^.bWindowed then dwFrameworkFlags := D3DFW_FULLSCREEN else dwFrameworkFlags := 0;
  if m_pDeviceInfo^.bStereo then dwFrameworkFlags := dwFrameworkFlags or D3DFW_STEREO;
  if m_bAppUseZBuffer then dwFrameworkFlags := dwFrameworkFlags or D3DFW_ZBUFFER;

  // Initialize the D3D framework
  Result := m_pFramework.Initialize(m_hWnd,
     m_pDeviceInfo^.pDriverGUID, m_pDeviceInfo^.pDeviceGUID,
     @m_pDeviceInfo^.ddsdFullscreenMode, dwFrameworkFlags);
  if SUCCEEDED(Result) then
  begin
    // Delphi specific: don't copy but use access functions (properties)
    // in order to leave the refcount at 1
{    m_pDD        := m_pFramework.DirectDraw;
    m_pD3D       := m_pFramework.Direct3D;
    m_pd3dDevice := m_pFramework.D3DDevice;

    m_pddsRenderTarget     := m_pFramework.RenderSurface;
    m_pddsRenderTargetLeft := m_pFramework.RenderSurfaceLeft;
}
    m_ddsdRenderTarget.dwSize := SizeOf(m_ddsdRenderTarget);
    m_pddsRenderTarget.GetSurfaceDesc(m_ddsdRenderTarget);

    // Let the app run its startup code which creates the 3d scene.
    Result := InitDeviceObjects;
    if SUCCEEDED(Result) then Result := S_OK
    else
    begin
      DeleteDeviceObjects;
      m_pFramework.DestroyObjects;
    end;
  end;

  // If we get here, the first initialization passed failed. If that was with a
  // hardware device, try again using a software rasterizer instead.
  if FAILED(Result) and m_pDeviceInfo^.bHardware then
  begin // Try again with a software rasterizer
    DisplayFrameworkError(Result, MSGWARN_SWITCHEDTOSOFTWARE);
    D3DEnum_SelectDefaultDevice(m_pDeviceInfo, D3DENUM_SOFTWAREONLY);
    Result := Initialize3DEnvironment;
  end;
end;


//-----------------------------------------------------------------------------
// Name: OutputText()
// Desc: Draws text on the window.
//-----------------------------------------------------------------------------
procedure TD3DApplication.OutputText(x, y: Integer; Str: String);

  procedure DoOutput(Target: IDirectDrawSurface7);
  var DC: HDC;
  begin   // Get a DC for the surface. Then, write out the buffer
    if Assigned(Target) and SUCCEEDED(Target.GetDC(DC)) then
    begin
      SetTextColor(DC, RGB(255,255,0) );
      SetBkMode(DC, TRANSPARENT );
      ExtTextOut(DC, x, y, 0, nil, PChar(Str), Length(Str), nil);
      Target.ReleaseDC(DC);
    end;
  end;
begin
  DoOutput(m_pddsRenderTarget);
  // Do the same for the left surface (in case of stereoscopic viewing).
  DoOutput(m_pddsRenderTargetLeft);
end;


//-----------------------------------------------------------------------------
// Name: Render3DEnvironment()
// Desc: Draws the scene.
//-----------------------------------------------------------------------------
function TD3DApplication.Render3DEnvironment: HResult;
var fTime: FLOAT; LocalDD: IDirectDraw7;
begin
  // Check the cooperative level before rendering
  LocalDD := m_pDD;
  Result := LocalDD.TestCooperativeLevel;
  LocalDD := nil;  // Delphi specific: clear this reference now!
//  m_pDD.TestCooperativeLevel;
  if FAILED(Result) then
  begin
     case Result of
       DDERR_EXCLUSIVEMODEALREADYSET,
       DDERR_NOEXCLUSIVEMODE:
           // Do nothing because some other app has exclusive mode
           Result := S_OK;

       DDERR_WRONGMODE:
         // The display mode changed on us. Resize accordingly
         if m_pDeviceInfo^.bWindowed then Result := Change3DEnvironment;
     end;
     Exit;
  end;

  // Get the relative time, in seconds
  fTime := (timeGetTime - m_dwBaseTime) * 0.001;

  // FrameMove (animate) the scene
  if m_bFrameMoving or m_bSingleStep then
  begin
    Result := FrameMove(fTime);
    if FAILED(Result) then Exit;
    m_bSingleStep := False;
  end;

  // If the display is in a stereo mode, render the scene from the left eye
  // first, then the right eye.
  if m_bAppUseStereo and m_pDeviceInfo^.bStereo and not m_pDeviceInfo^.bWindowed then
  begin
    // Render the scene from the left eye
    m_pd3dDevice.SetTransform( D3DTRANSFORMSTATE_VIEW, m_matLeftView );
    Result := m_pd3dDevice.SetRenderTarget(m_pddsRenderTargetLeft, 0);
    if SUCCEEDED(Result) then Result := Render;
    if FAILED(Result) then Exit;

    //Render the scene from the right eye
    m_pd3dDevice.SetTransform(D3DTRANSFORMSTATE_VIEW, m_matRightView);
    Result := m_pd3dDevice.SetRenderTarget(m_pddsRenderTarget, 0);
    if SUCCEEDED(Result) then Result := Render;
    if FAILED(REsult) then Exit;
  end else
  begin
    // Set center viewing matrix if app is stereo-enabled
    if m_bAppUseStereo then m_pd3dDevice.SetTransform(D3DTRANSFORMSTATE_VIEW, m_matView);

    // Render the scene as normal
    Result := Render;
    if FAILED(Result) then Exit;
  end;

  // Show the frame rate, etc.
  if m_bShowStats then ShowStats;

  // Show the frame on the primary surface.
  Result := m_pFramework.ShowFrame;
  if Result = DDERR_SURFACELOST then
  begin
    m_pFramework.RestoreSurfaces;
    RestoreSurfaces;
    Result := S_OK;
  end;
end;


//-----------------------------------------------------------------------------
// Name: SetViewParams()
// Desc: Sets the parameters to be used by the SetViewMatrix() function.  You
//       must call this function rather than setting the D3D view matrix
//       yourself in order for stereo modes to work properly.
//-----------------------------------------------------------------------------
procedure TD3DApplication.SetViewParams(vEyept, vLookatPt,
  vUpVec: PD3DVector; fEyeDistance: FLOAT);
var vView, vLeftEyePt, vRightEyePt: TD3DVector;
begin
  // Adjust camera position for left or right eye along the axis
  // perpendicular to the view direction vector and the up vector.
  vView :=  VectorSub(vLookatPt^, vEyePt^);
  vView := VectorCrossProduct( vView, vUpVec^);
  vView := VectorMulS(VectorNormalize(vView), fEyeDistance);

  vLeftEyePt  := VectorAdd(vEyePt^, vView);
  vRightEyePt := VectorSub(vEyePt^,vView);

  // Set the view matrices
  D3DUtil_SetViewMatrix(m_matLeftView,  vLeftEyePt,  vLookatPt^, vUpVec^);
  D3DUtil_SetViewMatrix(m_matRightView, vRightEyePt, vLookatPt^, vUpVec^);
  D3DUtil_SetViewMatrix(m_matView,      vEyePt^,     vLookatPt^, vUpVec^);
end;


//-----------------------------------------------------------------------------
// Name: ShowStats()
// Desc: Shows frame rate and dimensions of the rendering device.
//-----------------------------------------------------------------------------
procedure TD3DApplication.ShowStats;
const dwFrames: Cardinal = 0; fFPS: FLOAT = 0.0; fLastTime: FLOAT = 0.0;
var fTime: FLOAT;
begin
  // Keep track of the time lapse and frame count
  fTime := timeGetTime * 0.001; // Get current time in seconds
  Inc(dwFrames);

  // Update the frame rate once per second
  if fTime - fLastTime > 1 then
  begin
    fFPS := dwFrames / (fTime - fLastTime);
    fLastTime := fTime;
    dwFrames  := 0;
  end;

  with m_ddsdRenderTarget do
    OutputText(0,0, Format('%7.02f fps (%dx%dx%d)',
      [fFPS, dwWidth, dwHeight, ddpfPixelFormat.dwRGBBitCount]));
end;

constructor TD3DApplication.Create(AOwner: TComponent);
begin
  inherited;
{$IFDEF DELPHI3}
  DoCreate;
{$ENDIF}
end;

{$IFDEF DELPHI3}
destructor TD3DApplication.Destroy;
begin
  DoDestroy;
  inherited;
end;
{$ENDIF}

var CurrentApp: TD3DApplication;
function EnumConfirmDevice(Caps: PDDCaps; Desc: PD3DDeviceDesc7): HResult;
begin
  with CurrentApp do
    if Assigned(FOnConfirmDevice) then Result := FOnConfirmDevice(Caps,Desc)
      else Result := S_OK;
end;


function TD3DApplication.CreateFramework: HResult;  // C++ create member function
begin
  m_hWnd := Handle; // Delphi specific

  // Enumerate available D3D devices. The callback is used so the app can
  // confirm/reject each enumerated device depending on its capabilities.
  CurrentApp := Self;
  Result := D3DEnum_EnumerateDevices(EnumConfirmDevice);

  if FAILED(Result) then
  begin
    DisplayFrameworkError(Result, MSGERR_APPMUSTEXIT);
    Exit;
  end;

  // Select a device. Ask for a hardware device that renders in a window.
  if SUCCEEDED(Result) then
  begin
    Result := D3DEnum_SelectDefaultDevice(m_pDeviceInfo,0);
    if FAILED(Result) then DisplayFrameworkError(Result, MSGERR_APPMUSTEXIT);
  end;

  // Initialize the app's custom scene stuff
  if SUCCEEDED(Result) then
  begin
    Result := OneTimeSceneInit;
    if FAILED(Result) then DisplayFrameworkError(Result, MSGERR_APPMUSTEXIT);
  end;

  // Create a new CD3DFramework class. This class does all of our D3D
  // initialization and manages the common D3D objects.
  m_pFramework := TD3DFrameWork7.Create;

  // Initialize the 3D environment for the app
  if SUCCEEDED(Result) then
  begin
    Result := Initialize3DEnvironment;
    if FAILED(Result) then
    begin
      DisplayFrameworkError(Result, MSGERR_APPMUSTEXIT);
      Cleanup3DEnvironment;
      Result := E_FAIL;
    end;

    // Setup the app so it can support single-stepping
    m_dwBaseTime := timeGetTime;

    // The app is ready to go
    m_bReady := True;
    // timing engine - Delphi specific
    if DXTimer = nil then DXTimer := TDXTimer.Create(Self);
    with DXTimer do
    begin
      Interval := 10;  // 100 frames
      OnTimer := OnDXTimer;
      Enabled := True;
    end;
  end
end;

// ========================================
procedure TD3DApplication.DoCreate;
begin
  // initializations from C++ constructor
  m_bFrameMoving := True; Caption := 'Direct 3D Application';
  bOldWindowedState := True;

  inherited;
  mFileGoStop.Shortcut := VK_SPACE;
  mFileSingleStep.Shortcut := VK_RETURN;
  mFileFullscreen.ShortCut := Shortcut(VK_RETURN,[ssAlt]);
  mFileExit.Shortcut := VK_ESCAPE;
end;

procedure TD3DApplication.OnDXTimer(Sender: TObject);
var Msg: TMsg;
begin
  if not (m_bReady and m_bActive) or PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then Exit;
  if FAILED(Render3DEnvironment) then PostQuitMessage(0);
end;

procedure TD3DApplication.DoDestroy;
begin
  Cleanup3DEnvironment;
  inherited;
end;

procedure TD3DApplication.Paint;
begin
  inherited;
   // Handle paint messages when the app is not ready
   if Assigned(m_pFramework) and not m_bReady then
     if Assigned(m_pDeviceInfo) then
       if m_pDeviceInfo^.bWindowed then m_pFramework.ShowFrame
         else m_pFramework.FlipToGDISurface(True);
end;

procedure TD3DApplication.WMMove(var Msg: TWMMove);
var Pt: TPoint;
begin
  inherited;
  // If in windowed mode, move the Framework's window
  if Assigned(m_pFramework) and m_bActive and m_bReady
    and m_pDeviceInfo.bWindowed then
  begin
    Pt := ClientToScreen(Point(0,0));
    m_pFramework.Move(Pt.X, Pt.Y);
  end;
end;

procedure TD3DApplication.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin  // only applies if "redraw window while resizing" is activated
  with Msg.MinMaxInfo^.ptMinTrackSize do
  begin
    x := 100; y:= 100;
  end;
  inherited;
end;

procedure TD3DApplication.WMSize(var Msg: TWMSize);
begin
  inherited;
  // Check to see if we are losing our window...
  m_bActive := (Msg.SizeType <> SIZE_MAXHIDE)
    and (Msg.SizeType <> SIZE_MINIMIZED);

  // A new window size will require a new backbuffer
  // size, so the 3D structures must be changed accordingly.
  if m_bActive and m_bReady and m_pDeviceInfo.bWindowed then
  begin
    m_bReady := False;
    m_bReady := SUCCEEDED(Change3DEnvironment);
  end;
end;

procedure TD3DApplication.WMEnterMenuLoop(var Msg: TMessage);
begin
  inherited;
  Pause(True);
end;

procedure TD3DApplication.WMExitMenuLoop(var Msg: TMessage);
begin
  inherited;
  Pause(False);
end;


procedure TD3DApplication.WMEnterSizeMove(var Msg: TMessage);
begin
  // Halt frame movement while the app is sizing or moving
  if m_bFrameMoving then m_dwStopTime := timeGetTime;
  inherited;
end;

procedure TD3DApplication.WMExitSizeMove(var Msg: TMessage);
begin
  // Halt frame movement while the app is sizing or moving
  if m_bFrameMoving then Inc(m_dwBaseTime, timeGetTime-m_dwStopTime);
  inherited;
end;

procedure TD3DApplication.WMSetCursor(var Msg: TWMSetCursor);
begin
  // Prevent a cursor in fullscreen mode
  if m_bActive and m_bReady and not m_pDeviceInfo.bWindowed then
  begin
    SetCursor(0);
    Msg.Result := 1;
  end else inherited;
end;

procedure TD3DApplication.WMNCHitTest(var Msg: TWMNCHitTest);
begin // Prevent the user from selecting the menu in fullscreen mode
  if not m_pDeviceInfo.bWindowed then Msg.Result := HTCLIENT
   else inherited;
end;

procedure TD3DApplication.WMPowerBroadcast(var Msg: TWMPower);
begin
  case Msg.PowerEvt of
    PWR_SUSPENDREQUEST:
       // At this point, the app should save any data for open
       // network connections, files, etc.., and prepare to go into
       // a suspended mode.
       Msg.Result := OnQuerySuspend(Msg.Unused);

    PWR_SUSPENDRESUME:
       // At this point, the app should recover any data, network
       // connections, files, etc.., and resume running from when
       // the app was suspended.
       Msg.Result := OnResumeSuspend(Msg.Unused);
  end;
  inherited;
end;

procedure TD3DApplication.WMSysCommand(var Msg: TWMSysCommand);
begin // Prevent moving/sizing and power loss in fullscreen mode
  with Msg do
    if ((CmdType = SC_MOVE) or (CmdType = SC_SIZE) or
      (CmdType = SC_MAXIMIZE) or (CmdType = SC_MONITORPOWER))
     and not m_pDeviceInfo^.bWindowed
   then Result := 1
   else inherited;
end;

//-----------------------------------------------------------------------------
// Name: OnQuerySuspend()
// Desc: Called when the app receives a PBT_APMQUERYSUSPEND message, meaning
//       the computer is about to be suspended. At this point, the app should
//       save any data for open network connections, files, etc.., and prepare
//       to go into a suspended mode.
//-----------------------------------------------------------------------------
function TD3DApplication.OnQuerySuspend(dwFlags: Cardinal): Cardinal;
begin
  Pause(True);
  Result := 1;
end;

//-----------------------------------------------------------------------------
// Name: OnResumeSuspend()
// Desc: Called when the app receives a PBT_APMRESUMESUSPEND message, meaning
//       the computer has just resumed from a suspended state. At this point,
//       the app should recover any data, network connections, files, etc..,
//       and resume running from when the app was suspended.
//-----------------------------------------------------------------------------
function TD3DApplication.OnResumeSuspend(dwFlags: Cardinal): Cardinal;
begin
  Pause(False);
  Result := 1;
end;


// =================================================

// Access functions instead of fields in order
// to keep the ref count at 1 -
function TD3DApplication.Getm_pD3D: IDirect3D7;
begin
  Result := m_pFramework.Direct3D;
end;

function TD3DApplication.Getm_pd3dDevice: IDirect3dDevice7;
begin
  Result := m_pFramework.D3DDevice;
end;

function TD3DApplication.Getm_pDD: IDirectDraw7;
begin
  Result := m_pFramework.DirectDraw;
end;

function TD3DApplication.Getm_pddsRenderTarget: IDirectDrawSurface7;
begin
  Result := m_pFramework.RenderSurface;
end;

function TD3DApplication.Getm_pddsRenderTargetLeft: IDirectDrawSurface7;
begin
  Result := m_pFramework.RenderSurfaceLeft;
end;


//-----------------------------------------------------------------------------
// Name: Pause()
// Desc: Called in to toggle the pause state of the app. This function
//       brings the GDI surface to the front of the display, so drawing
//       output like message boxes and menus may be displayed.
//-----------------------------------------------------------------------------

procedure TD3DApplication.Pause(bPause: Boolean);
const dwAppPausedCount: Integer = 0;
begin
  if bPause then Inc(dwAppPausedCount) else Dec(dwAppPausedCount);
  m_bReady := dwAppPausedCount <= 0;

  // Handle the first pause request (of many, nestable pause requests)
  if bPause and (dwAppPausedCount=1) then
  begin
    // Get a surface for the GDI
    if Assigned(m_pFramework) then
          m_pFramework.FlipToGDISurface(True);

    // Stop the scene from animating
    if m_bFrameMoving then m_dwStopTime := timeGetTime;
  end;

  if dwAppPausedCount = 0 then // Restart the scene
    if m_bFrameMoving then
      Inc(m_dwBaseTime, timeGetTime - m_dwStopTime);
end;

// ===============================================
procedure TD3DApplication.mFileGoStopClick(Sender: TObject);
begin
  // Toggle frame movement
  m_bFrameMoving := not m_bFrameMoving;

  if m_bFrameMoving then Inc(m_dwBaseTime, timeGetTime - m_dwStopTime)
   else m_dwStopTime := timeGetTime;
end;

procedure TD3DApplication.mFileSingleStepClick(Sender: TObject);
begin  // Single-step frame movement
  if not m_bFrameMoving
    then Inc(m_dwBaseTime, timeGetTime - (m_dwStopTime + 100));

  m_dwStopTime   := timeGetTime;
  m_bFrameMoving := False;
  m_bSingleStep  := True;
end;

procedure TD3DApplication.mFileAboutClick(Sender: TObject);
begin
  // Display the About box
  Pause(True);
  ShowMessage(Caption + #13#10+ 'Delphi translation by Arne Schäpers');
  Pause(False);
end;

procedure TD3DApplication.mFileChangeDeviceClick(Sender: TObject);
begin
  // Display the device-selection dialog box.
  if m_bActive and m_bReady then
  begin
    Pause(True);
    if SUCCEEDED(D3DEnum_UserChangeDevice(m_pDeviceInfo)) then
    begin
      if SUCCEEDED(Change3DEnvironment) then Pause(False);
    end
     else Pause(False);  // continue after user cancelled device selection
  end;
end;

procedure TD3DApplication.mFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TD3DApplication.mFileFullscreenClick(Sender: TObject);
begin
  // Toggle the fullscreen/window mode
  if m_bActive and m_bReady then
  begin
    m_bReady := False;
    m_pDeviceInfo.bWindowed := not m_pDeviceInfo.bWindowed;
    mFileFullScreen.Checked := not m_pDeviceInfo.bWindowed;
    mContextFullScreen.Checked := not m_pDeviceInfo.bWindowed;
    m_bReady := SUCCEEDED(Change3DEnvironment);
  end;
end;

end.

