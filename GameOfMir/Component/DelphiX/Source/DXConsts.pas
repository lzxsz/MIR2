unit DXConsts;

interface

resourcestring
  SNone = '(None)';
  SUnknownError = 'Unknown Error (%d)';

  SDirectDraw = 'DirectDraw';
  SDirect3DRM = 'Direct3D RetainedMode';
  SDirectSound = 'DirectSound';
  SDirectSoundCapture = 'DirectSoundCapture';
  SDirectDrawClipper = 'Clipper';
  SDirectDrawPalette = 'Palette';
  SDirectDrawSurface = 'Surface';
  SDirectDrawPrimarySurface = 'Primary Surface';
  SDirectSoundBuffer = 'Sound Buffer';
  SDirectSoundPrimaryBuffer = 'Primary Buffer';
  SDirectSoundCaptureBuffer = 'Sound Capture Buffer';
  STexture = 'Texture';
  SDirectPlay = 'DirectPlay';
  SSession = 'Session';

  SNotMade = '%s not made';
  SStreamNotOpend = 'Stream not opened';
  SWaveStreamNotSet = 'WaveStream not set';
  SCannotMade = '%s cannot be made';
  SCannotInitialized = '%s cannot be initialized';
  SCannotChanged = '%s cannot be changed';
  SCannotLock = '%s cannot be locked';
  SCannotOpened = '%s cannot be opened';
  SDLLNotLoaded = '%s is not loaded';
  SImageNotFound = 'Image ''%s'' not found';
  SWaveNotFound = 'Wave ''%s'' not found';
  SEffectNotFound = 'Effect ''%s'' not found';
  SListIndexError = 'Index of the list exceeds the range. (%d)';
  SScanline = 'Index of the scanning line exceeded the range. (%d)';
  SNoForm = 'Form not found';
  SSinceDirectX5 = 'Requires DirectX 5.0 or later';
  SSinceDirectX6 = 'Requires DirectX 6.0 or later';
  SSinceDirectX7 = 'Requires DirectX 7.0 or later';
  S3DDeviceNotFound = '3D device not found';
  SDisplayModeChange = 'Display mode cannot be changed (%dx%d %dbit)';
  SDisplayModeCannotAcquired = 'Display mode cannot be acquired';
  SInvalidDIB = 'DIB is invalid';
  SInvalidDIBBitCount = 'Bitcount in invalid (%d)';
  SInvalidDIBPixelFormat = 'PixelFormat in invalid';
  SInvalidWave = 'Wave is invalid';
  SInvalidDisplayBitCount = 'Display requires 8, 16, 24 or 32 bits';
  SInvalidWaveFormat = 'Format is invalid';
  SNotSupported = '%s not supported';
  SStreamOpend = 'Stream is already open';
  SNecessaryDirectInputUseMouse = 'DirectInput is required for mouse support';

  {  DirectPlay  }
  SDXPlayNotConnectedNow = 'TDXPlay component is disconnected.';
  SDXPlayProviderNotFound = 'Provider ''%s'' not found';
  SDXPlayProviderSpecifiedGUIDNotFound = 'Provider''s specified GUID is not found';
  SDXPlayModemListCannotBeAcquired = 'Modem list cannot be acquired';
  SDXPlaySessionListCannotBeAcquired = 'Session list cannot be acquired';
  SDXPlaySessionNotFound = 'Session ''%s'' not found';
  SDXPlaySessionCannotOpened = 'Session %s cannot be opened';
  SDXPlayPlayerNotFound = 'Player''s specified ID is not found';
  SDXPlayMessageIllegal = 'Illegal message form';
  SDXPlayPlayerNameIsNotSpecified = 'Player name is not specified';
  SDXPlaySessionNameIsNotSpecified = 'Session name is not specified';

  DXPlayFormNext = 'Next >';
  DXPlayFormComplete = 'Complete';


  SNotSupportGraphicFile = 'Graphic format not suported';
  SInvalidDXTFile = 'DXT file is invalid';
  SCannotLoadGraphic = 'Can not load graphic';
  SOverlay = 'Surface overlay not possible';

const
  SDIBSize = '(%dx%d)';
  SDIBColor = '%d color';
  SDIBBitSize = '%d bytes';
  SDIBBitSize_K = '%d Kbytes';

const
  SWaveLength = '%.4g sec';
  SWaveFrequency = '%dHz';
  SWaveBitCount = '%dbit';
  SWaveMono = 'Mono';
  SWaveStereo = 'Stereo';
  SWaveSize = '%d bytes';

const
  SKeyLeft = 'Left';
  SKeyUp = 'Up';
  SKeyRight = 'Right';
  SKeyDown = 'Down';

const
  SFFBEffectEditor = '%s Effect Editor';

implementation

end.
