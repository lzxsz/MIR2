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
  SStreamNotOpend = 'Stream not opend';
  SWaveStreamNotSet = 'WaveStream not set';
  SCannotMade = '%s cannot be made';
  SCannotInitialized = '%s cannot be initialized';
  SCannotChanged = '%s cannot be changed';
  SCannotLock = '%s cannot be locked';
  SCannotOpened = '%s cannot be opened';
  SDLLNotLoaded = '%s not loaded';
  SImageNotFound = 'Image ''%s'' not found';
  SWaveNotFound = 'Wave ''%s'' not found';
  SEffectNotFound = 'Effect ''%s'' not found';
  SListIndexError = 'Index of the list exceeds the range. (%d)';
  SScanline = 'Index of the scanning line exceeded the range. (%d)';
  SNoForm = 'Form not found';
  SSinceDirectX5 = 'Necessary since DirectX 5';
  SSinceDirectX6 = 'Necessary since DirectX 6';
  SSinceDirectX7 = 'Necessary since DirectX 7';
  S3DDeviceNotFound = '3D device not found';
  SDisplayModeChange = 'Display mode cannot be changed (%dx%d %dbit)';
  SDisplayModeCannotAcquired = 'A present display mode cannot be acquired';
  SInvalidDIB = 'DIB is invalid';
  SInvalidDIBBitCount = 'Bitcount in invalid (%d)';
  SInvalidDIBPixelFormat = 'PixelFormat in invalid';
  SInvalidWave = 'Wave is invalid';
  SInvalidDisplayBitCount = 'It should be either of 8 or 16 or 24 or 32';
  SInvalidWaveFormat = 'Format is invalid';
  SNotSupported = '%s not supported';
  SStreamOpend = 'Stream has already been opened';
  SNecessaryDirectInputUseMouse = 'DirectInput is necessary to use the mouse';

  {  DirectPlay  }
  SDXPlayNotConnectedNow = 'TDXPlay component is not connected now.';
  SDXPlayProviderNotFound = 'Provider ''%s'' not found';
  SDXPlayProviderSpecifiedGUIDNotFound = 'Provider of specified GUID is not found';
  SDXPlayModemListCannotBeAcquired = 'Modem list cannot be acquired';
  SDXPlaySessionListCannotBeAcquired = 'Session list cannot be acquired';
  SDXPlaySessionNotFound = 'Session ''%s'' not found';
  SDXPlaySessionCannotOpened = 'Session %s cannot be opened';
  SDXPlayPlayerNotFound = 'The player of specified ID is not found';
  SDXPlayMessageIllegal = 'The message form is illegal';
  SDXPlayPlayerNameIsNotSpecified = 'Player name is not specified';
  SDXPlaySessionNameIsNotSpecified = 'Session name is not specified';

  DXPlayFormNext = 'Next >';
  DXPlayFormComplete = 'Complete';


 
  SNotSupportGraphicFile = 'This format graphic not suported';
  SInvalidDXTFile = 'This DXT file is invalid';
  SCannotLoadGraphic = 'Can''t Load this Graphic';
  SOverlay = 'Not posible Overlay Surface';

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
