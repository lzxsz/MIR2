(*==========================================================================;
 *
 *  Copyright (C) 1994-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  DirectX header version 98.08.07
 *
 *  Present by Hiroyuki Hori.
 *
 *  E-Mail: hori@ingjapan.ne.jp
 *  Homepage: http://www.ingjapan.ne.jp/hori/index-e.html
 *
 *  Present unit:
 *    DirectX.pas    DirectX 6 (DirectX 6 SDK)
 *    DShow.pas      DirectShow (DirectX Media SDK 5.1)
 *    DAnim.pas      DirectAnimation (DirectX Media SDK 5.1)
 *
 ***************************************************************************)

unit DShow;

interface

{$Z4}
{$A+}
{ $WEAKPACKAGEUNIT}

uses Windows, ActiveX, DirectX, MMSystem;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       comlite.h
 *
 ***************************************************************************)

function QzInitialize(pvReserved: Pointer): HResult; stdcall;
procedure QzUninitialize; stdcall;
procedure QzFreeUnusedLibraries; stdcall;

function QzGetMalloc(dwMemContext: Longint; out malloc: IMalloc): HResult; stdcall;
function QzTaskMemAlloc(cb: Longint): Pointer; stdcall;
function QzTaskMemRealloc(pv: Pointer; cb: Longint): Pointer; stdcall;
procedure QzTaskMemFree(pv: Pointer); stdcall;
function QzCreateFilterObject(const clsid: TCLSID; unkOuter: IUnknown;
  dwClsContext: Longint; const iid: TIID; out pv): HResult; stdcall;
function QzCLSIDFromString(psz: POleStr; out clsid: TCLSID): HResult; stdcall;
function QzStringFromGUID2(const guid: TGUID; psz: POleStr; cbMax: Integer): Integer; stdcall;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       errors.h
 *
 ***************************************************************************)

const
  VFW_FIRST_CODE = $200;
  MAX_ERROR_TEXT_LEN = 160;

type
  AMGETERRORTEXTPROCA = function(hr: HResult; pbuffer: PChar; MaxLen: DWORD): BOOL; stdcall;

  AMGETERRORTEXTPROCW = function(hr: HResult; pbuffer: PWideChar; MaxLen: DWORD): BOOL; stdcall;

  AMGETERRORTEXTPROC = AMGETERRORTEXTPROCA;

function AMGetErrorTextA(hr: HResult; pbuffer: PChar; MaxLen: DWORD): DWORD; stdcall;
function AMGetErrorTextW(hr: HResult; pbuffer: PWideChar; MaxLen: DWORD): DWORD; stdcall;
function AMGetErrorText(hr: HResult; pbuffer: PChar; MaxLen: DWORD): DWORD; stdcall;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       strmif.h
 *
 ***************************************************************************)

const
  IID_IPin: TGUID = '{56A86891-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IEnumPins: TGUID = '{56A86892-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IEnumMediaTypes: TGUID = '{89C31040-846B-11CE-97D3-00AA0055595A}';
  IID_IFilterGraph: TGUID = '{56A8689F-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IEnumFilters: TGUID = '{56A86893-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaFilter: TGUID = '{56A86899-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IBaseFilter: TGUID = '{56A86895-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IReferenceClock: TGUID = '{56A86897-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IReferenceClock2: TGUID = '{36B73885-C2C8-11CF-8B46-00805F6CEF60}';
  IID_IMediaSample: TGUID = '{56A8689A-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaSample2: TGUID = '{36B73884-C2C8-11CF-8B46-00805F6CEF60}';
  IID_IMemAllocator: TGUID = '{56A8689C-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMemInputPin: TGUID = '{56A8689D-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IAMovieSetup: TGUID = '{A3D8CEC0-7E5A-11CF-BBC5-00805F6CEF20}';
  IID_IMediaSeeking: TGUID = '{36B73880-C2C8-11CF-8B46-00805F6CEF60}';
  IID_IEnumRegFilters: TGUID = '{56A868A4-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IFilterMapper: TGUID = '{56A868A3-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IFilterMapper2: TGUID = '{B79BB0B0-33C1-11D1-ABE1-00A0C905F375}';
  IID_IQualityControl: TGUID = '{56A868A5-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IOverlayNotify: TGUID = '{56A868A0-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IOverlay: TGUID = '{56A868A1-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaEventSink: TGUID = '{56A868A2-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IFileSourceFilter: TGUID = '{56A868A6-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IFileSinkFilter: TGUID = '{A2104830-7C70-11CF-8BCE-00AA00A3F1A6}';
  IID_IFileSinkFilter2: TGUID = '{00855B90-CE1B-11D0-BD4F-00A0C911CE86}';
  IID_IFileAsyncIO: TGUID = '{56A868A7-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IGraphBuilder: TGUID = '{56A868A9-0AD4-11CE-B03A-0020AF0BA770}';
  IID_ICaptureGraphBuilder: TGUID = '{BF87B6E0-8C27-11D0-B3F0-00AA003761C5}';
  IID_IAMCopyCaptureFileProgress: TGUID = '{670D1D20-A068-11D0-B3F0-00AA003761C5}';
  IID_IFilterGraph2: TGUID = '{36B73882-C2C8-11CF-8B46-00805F6CEF60}';
  IID_IStreamBuilder: TGUID = '{56A868BF-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IAsyncReader: TGUID = '{56A868AA-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IGraphVersion: TGUID = '{56A868AB-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IResourceConsumer: TGUID = '{56A868AD-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IResourceManager: TGUID = '{56A868AC-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IDistributorNotify: TGUID = '{56A868AF-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IAMStreamControl: TGUID = '{36b73881-c2c8-11cf-8b46-00805f6cef60}';
  IID_ISeekingPassThru: TGUID = '{36B73883-C2C8-11CF-8B46-00805F6CEF60}';
  IID_IAMStreamConfig: TGUID = '{C6E13340-30AC-11d0-A18C-00A0C9118956}';
  IID_IConfigInterleaving: TGUID = '{BEE3D220-157B-11d0-BD23-00A0C911CE86}';
  IID_IConfigAviMux: TGUID = '{5ACD6AA0-F482-11ce-8B67-00AA00A3F1A6}';
  IID_IAMVideoCompression: TGUID = '{C6E13343-30AC-11d0-A18C-00A0C9118956}';
  IID_IAMVfwCaptureDialogs: TGUID = '{D8D715A0-6E5E-11D0-B3F0-00AA003761C5}';
  IID_IAMVfwCompressDialogs: TGUID = '{D8D715A3-6E5E-11D0-B3F0-00AA003761C5}';
  IID_IAMDroppedFrames: TGUID = '{C6E13344-30AC-11d0-A18C-00A0C9118956}';
  IID_IAMAudioInputMixer: TGUID = '{54C39221-8380-11d0-B3F0-00AA003761C5}';
  IID_IAMAnalogVideoDecoder: TGUID = '{C6E13350-30AC-11d0-A18C-00A0C9118956}';
  IID_IAMVideoProcAmp: TGUID = '{C6E13360-30AC-11d0-A18C-00A0C9118956}';
  IID_IAMCameraControl: TGUID = '{C6E13370-30AC-11d0-A18C-00A0C9118956}';
  IID_IAMCrossbar: TGUID = '{C6E13380-30AC-11d0-A18C-00A0C9118956}';
  IID_IAMTuner: TGUID = '{211A8761-03AC-11d1-8D13-00AA00BD8339}';
  IID_IAMTunerNotification: TGUID = '{211A8760-03AC-11d1-8D13-00AA00BD8339}';
  IID_IAMTVTuner: TGUID = '{211A8766-03AC-11d1-8D13-00AA00BD8339}';
  IID_IBPCSatelliteTuner: TGUID = '{211A8765-03AC-11d1-8D13-00AA00BD8339}';
  IID_IAMTVAudio: TGUID = '{83EC1C30-23D1-11d1-99E6-00A0C9560266}';
  IID_IAMTVAudioNotification: TGUID = '{83EC1C33-23D1-11D1-99E6-00A0C9560266}';
  IID_IAMAnalogVideoEncoder: TGUID = '{C6E133B0-30AC-11d0-A18C-00A0C9118956}';
  IID_IMediaPropertyBag: TGUID = '{6025A880-C0D5-11D0-BD4E-00A0C911CE86}';
  IID_IPersistMediaPropertyBag: TGUID = '{5738E040-B67F-11d0-BD4D-00A0C911CE86}';
  IID_IAMPhysicalPinInfo: TGUID = '{F938C991-3029-11CF-8C44-00AA006B6814}';
  IID_IAMExtDevice: TGUID = '{B5730A90-1A2C-11CF-8C23-00AA006B6814}';
  IID_IAMExtTransport: TGUID = '{A03CD5F0-3045-11CF-8C44-00AA006B6814}';
  IID_IAMTimecodeReader: TGUID = '{9B496CE1-811B-11CF-8C77-00AA006B6814}';
  IID_IAMTimecodeGenerator: TGUID = '{9B496CE0-811B-11CF-8C77-00AA006B6814}';
  IID_IAMTimecodeDisplay: TGUID = '{9B496CE2-811B-11CF-8C77-00AA006B6814}';
  IID_IAMDevMemoryAllocator: TGUID = '{C6545BF0-E76B-11D0-BD52-00A0C911CE86}';
  IID_IAMDevMemoryControl: TGUID = '{C6545BF1-E76B-11D0-BD52-00A0C911CE86}';
  IID_IAMStreamSelect: TGUID = '{C1960960-17F5-11D1-ABE1-00A0C905F375}';
  IID_IAMovie: TGUID = '{359ACE10-7688-11CF-8B23-00805F6CEF60}';
  IID_ICreateDevEnum: TGUID = '{29840822-5B84-11D0-BD3B-00A0C911CE86}';
  IID_IDvdControl: TGUID = '{A70EFE61-E2A3-11D0-A9BE-00AA0061BE93}';
  IID_IDvdInfo: TGUID = '{A70EFE60-E2A3-11D0-A9BE-00AA0061BE93}';
  IID_IDvdGraphBuilder: TGUID = '{FCC152B6-F372-11d0-8E00-00C04FD7C08B}';

const
  CHARS_IN_GUID = 39;

  MAX_PIN_NAME    = 128;
  MAX_FILTER_NAME = 128;

type
  TAM_Media_Type = record
    majortype: TGUID;
    subtype: TGUID;
    bFixedSizeSamples: BOOL;
    bTemporalCompression: BOOL;
    lSampleSize: ULONG;
    formattype: TGUID;
    pUnk: IUnknown;
    cbFormat: ULONG;
    pbFormat: Pointer;
  end;
  PAM_Media_Type = ^TAM_Media_Type;

  TPin_Direction = (
    PINDIR_INPUT,
    PINDIR_OUTPUT
  );

  TRefTime = double;

  HSEMAPHORE = Longint;

  TAllocator_Properties = record
    cBuffers: Longint;
    cbBuffer: Longint;
    cbAlign: Longint;
    cbPrefix: Longint;
  end;

  IBaseFilter = interface;

  TPin_Info = record
    pFilter: IBaseFilter;
    dir: TPin_Direction;
    achName: array[0..127] of WCHAR;
  end;

  IEnumMediaTypes = interface;

  IPin = interface(IUnknown)
    ['{56A86891-0AD4-11CE-B03A-0020AF0BA770}']
    function Connect(pReceivePin: IPin; const pmt: TAM_Media_Type): HResult; stdcall;
    function ReceiveConnection(pConnector: IPin; const pmt: TAM_Media_Type): HResult; stdcall;
    function Disconnect: HResult; stdcall;
    function ConnectedTo(out pPin: IPin): HResult; stdcall;
    function ConnectionMediaType(out pmt: TAM_Media_Type): HResult; stdcall;
    function QueryPinInfo(out pInfo: TPin_Info): HResult; stdcall;
    function QueryDirection(var pPinDir: TPin_Direction): HResult; stdcall;
    function QueryId(var Id: LPWSTR): HResult; stdcall;
    function QueryAccept(const pmt: TAM_Media_Type): HResult; stdcall;
    function EnumMediaTypes(out ppEnum: IEnumMediaTypes): HResult; stdcall;
    function QueryInternalConnections(out apPin: IPin; var nPin: ULONG): HResult; stdcall;
    function EndOfStream: HResult; stdcall;
    function BeginFlush: HResult; stdcall;
    function EndFlush: HResult; stdcall;
    function NewSegment(tStart, tStop: TReference_Time; dRate: double): HResult; stdcall;
  end;

  IEnumPins = interface(IUnknown)
    ['{56A86892-0AD4-11CE-B03A-0020AF0BA770}']
    function Next(cPins: ULONG; out ppPins; var pcFetched: ULONG): HResult; stdcall;
    function Skip(cPins: ULONG): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppEnum: IEnumPins): HResult; stdcall;
  end;

  IEnumMediaTypes = interface(IUnknown)
    ['{89C31040-846B-11CE-97D3-00AA0055595A}']
    function Next(cMediaTypes: ULONG; var ppMediaTypes: PAM_Media_Type;
        var pcFetched: ULONG): HResult; stdcall;
    function Skip(cMediaTypes: ULONG): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppEnum: IEnumMediaTypes): HResult; stdcall;
  end;

  IEnumFilters = interface;

  IFilterGraph = interface(IUnknown)
    ['{56A8689F-0AD4-11CE-B03A-0020AF0BA770}']
    function AddFilter(pFilter: IBaseFilter; pName: LPCWSTR): HResult; stdcall;
    function RemoveFilter(pFilter: IBaseFilter): HResult; stdcall;
    function EnumFilters(out ppEnum: IEnumFilters): HResult; stdcall;
    function FindFilterByName(pName: LPCWSTR; out ppFilter: IBaseFilter): HResult; stdcall;
    function ConnectDirect(ppinOut, ppinIn: IPin; const pmt: TAM_Media_Type): HResult; stdcall;
    function Reconnect(ppin: IPin): HResult; stdcall;
    function Disconnect(ppin: IPin): HResult; stdcall;
    function SetDefaultSyncSource: HResult; stdcall;
  end;

  IEnumFilters = interface(IUnknown)
    ['{56A86893-0AD4-11CE-B03A-0020AF0BA770}']
    function Next(cFilters: ULONG; out ppFilter: IBaseFilter;
        var pcFetched: ULONG): HResult; stdcall;
    function Skip(cFilters: ULONG): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppEnum: IEnumFilters): HResult; stdcall;
  end;

  TFilter_State = (
    State_Stopped,
    State_Paused,
    State_Running
  );

  IReferenceClock = interface;

  IMediaFilter = interface(IPersist)
    ['{56A86899-0AD4-11CE-B03A-0020AF0BA770}']
    function Stop: HResult; stdcall;
    function Pause: HResult; stdcall;
    function Run(tStart: TReference_Time): HResult; stdcall;
    function GetState(dwMilliSecsTimeout: DWORD; var State: TFilter_State): HResult; stdcall;
    function SetSyncSource(pClock: IReferenceClock): HResult; stdcall;
    function GetSyncSource(out pClock: IReferenceClock): HResult; stdcall;
  end;

  TFilterInfo = record
    achName: array[0..127] of WCHAR;
    pGraph: IFilterGraph;
  end;

  IBaseFilter = interface(IMediaFilter)
    ['{56A86895-0AD4-11CE-B03A-0020AF0BA770}']
    function EnumPins(out ppEnum: IEnumPins): HResult; stdcall;
    function FindPin(Id: LPCWSTR; out ppPin: IPin): HResult; stdcall;
    function QueryFilterInfo(out pInfo: TFilterInfo): HResult; stdcall;
    function JoinFilterGraph(pGraph: IFilterGraph; pName: LPCWSTR): HResult; stdcall;
    function QueryVendorInfo(var pVendorInfo: LPWSTR): HResult; stdcall;
  end;

  IReferenceClock = interface(IUnknown)
    ['{56A86897-0AD4-11CE-B03A-0020AF0BA770}']
    function GetTime(var pTime: TReference_Time): HResult; stdcall;
    function AdviseTime(baseTime, streamTime: TReference_Time;
        hEvent: THandle; var pdwAdviseCookie: DWORD): HResult; stdcall;
    function AdvisePeriodic(startTime, periodTime: TReference_Time;
        hSemaphore: HSEMAPHORE; var pdwAdviseCookie: DWORD): HResult; stdcall;
    function Unadvise(dwAdviseCookie: DWORD): HResult; stdcall;
  end;

  IReferenceClock2 = interface(IReferenceClock)
    ['{36B73885-C2C8-11CF-8B46-00805F6CEF60}']
  end;

  IMediaSample = interface(IUnknown)
    ['{56A8689A-0AD4-11CE-B03A-0020AF0BA770}']
    function GetPointer(var ppBuffer: Pointer): HResult; stdcall;
    function GetSize: Longint; stdcall;
    function GetTime(var pTimeStart, pTimeEnd: TReference_Time): HResult; stdcall;
    function SetTime(var pTimeStart, pTimeEnd: TReference_Time): HResult; stdcall;
    function IsSyncPoint: HResult; stdcall;
    function SetSyncPoint(bIsSyncPoint: BOOL): HResult; stdcall;
    function IsPreroll: HResult; stdcall;
    function SetPreroll(bIsPreroll: BOOL): HResult; stdcall;
    function GetActualDataLength: Longint; stdcall;
    function SetActualDataLength(lLen: Longint): HResult; stdcall;
    function GetMediaType(var ppMediaType: PAM_Media_Type): HResult; stdcall;
    function SetMediaType(const pMediaType: TAM_Media_Type): HResult; stdcall;
    function IsDiscontinuity: HResult; stdcall;
    function SetDiscontinuity(bDiscontinuity: BOOL): HResult; stdcall;
    function GetMediaTime(var pTimeStart, pTimeEnd: TReference_Time): HResult; stdcall;
    function SetMediaTime(var pTimeStart, pTimeEnd: TReference_Time): HResult; stdcall;
  end;                                     

const
  AM_SAMPLE_SPLICEPOINT         = $1;
  AM_SAMPLE_PREROLL             = $2;
  AM_SAMPLE_DATADISCONTINUITY   = $4;
  AM_SAMPLE_TYPECHANGED         = $8;
  AM_SAMPLE_TIMEVALID           = $10;
  AM_SAMPLE_TIMEDISCONTINUITY   = $40;
  AM_SAMPLE_FLUSH_ON_PAUSE      = $80;
  AM_SAMPLE_STOPVALID           = $100;
  AM_SAMPLE_ENDOFSTREAM         = $200;
  AM_STREAM_MEDIA               = 0;
  AM_STREAM_CONTROL             = 1;

type
  TAM_Sample2_Properties = record
    cbData: DWORD;
    dwTypeSpecificFlags: DWORD;
    dwSampleFlags: DWORD;
    lActual: Longint;
    tStart: TReference_Time;
    tStop: TReference_Time;
    dwStreamId: DWORD;
    pMediaType: PAM_Media_Type;
    pbBuffer: Pointer;
    cbBuffer: Longint;
  end;

type
  IMediaSample2 = interface(IMediaSample)
    ['{36B73884-C2C8-11CF-8B46-00805F6CEF60}']
    function GetProperties(cbProperties: DWORD; var pbProperties): HResult; stdcall;
    function SetProperties(cbProperties: DWORD; const pbProperties): HResult; stdcall;
  end;

const
  AM_GBF_PREVFRAMESKIPPED = 1;
  AM_GBF_NOTASYNCPOINT    = 2;
  AM_GBF_NOWAIT           = 4;

type
  IMemAllocator = interface(IUnknown)
    ['{56A8689C-0AD4-11CE-B03A-0020AF0BA770}']
    function SetProperties(const pRequest: TAllocator_Properties;
        var pActual: TAllocator_Properties): HResult; stdcall;
    function GetProperties(var pProps: TAllocator_Properties): HResult; stdcall;
    function Commit: HResult; stdcall;
    function Decommit: HResult; stdcall;      
    function GetBuffer(out ppBuffer: IMediaSample;
        var pStartTime, pEndTime: TReference_Time; dwFlags: DWORD): HResult; stdcall;
    function ReleaseBuffer(pBuffer: IMediaSample): HResult; stdcall;
  end;

  IMemInputPin = interface(IUnknown)
    ['{56A8689D-0AD4-11CE-B03A-0020AF0BA770}']
    function GetAllocator(out ppAllocator: IMemAllocator): HResult; stdcall;
    function NotifyAllocator(pAllocator: IMemAllocator; bReadOnly: BOOL): HResult; stdcall;
    function GetAllocatorRequirements(var pProps: TAllocator_Properties): HResult; stdcall;
    function Receive(pSample: IMediaSample): HResult; stdcall;
    function ReceiveMultiple(const pSamples; nSamples: Longint;
        var nSamplesProcessed: Longint): HResult; stdcall;
    function ReceiveCanBlock: HResult; stdcall;
  end;

  IAMovieSetup = interface(IUnknown)
    ['{A3D8CEC0-7E5A-11CF-BBC5-00805F6CEF20}']
    function Register: HResult; stdcall;
    function Unregister: HResult; stdcall;
  end;

const
  AM_SEEKING_NoPositioning          = 0;
  AM_SEEKING_AbsolutePositioning    = $1;
  AM_SEEKING_RelativePositioning    = $2;
  AM_SEEKING_IncrementalPositioning = $3;
  AM_SEEKING_PositioningBitsMask    = $3;
  AM_SEEKING_SeekToKeyFrame         = $4;
  AM_SEEKING_ReturnTime             = $8;
  AM_SEEKING_Segment                = $10;
  AM_SEEKING_NoFlush                = $20;

  AM_SEEKING_CanSeekAbsolute        = $1;
  AM_SEEKING_CanSeekForwards        = $2;
  AM_SEEKING_CanSeekBackwards       = $4;
  AM_SEEKING_CanGetCurrentPos       = $8;
  AM_SEEKING_CanGetStopPos          = $10;
  AM_SEEKING_CanGetDuration         = $20;
  AM_SEEKING_CanPlayBackwards       = $40;
  AM_SEEKING_CanDoSegments          = $80;
  AM_SEEKING_Source                 = $100;

type
  IMediaSeeking = interface(IUnknown)
    ['{36B73880-C2C8-11CF-8B46-00805F6CEF60}']
    function GetCapabilities(var pCapabilities: DWORD): HResult; stdcall;
    function CheckCapabilities(var pCapabilities: DWORD): HResult; stdcall;
    function IsFormatSupported(const pFormat: TGUID): HResult; stdcall;
    function QueryPreferredFormat(var pFormat: TGUID): HResult; stdcall;
    function GetTimeFormat(var pFormat: TGUID): HResult; stdcall;
    function IsUsingTimeFormat(const pFormat: TGUID): HResult; stdcall;
    function SetTimeFormat(const pFormat: TGUID): HResult; stdcall;
    function GetDuration(var pDuration: LONGLONG): HResult; stdcall;
    function GetStopPosition(var pStop: LONGLONG): HResult; stdcall;
    function GetCurrentPosition(var pCurrent: LONGLONG): HResult; stdcall;
    function ConvertTimeFormat(var pTarget: LONGLONG; const pTargetFormat: TGUID;
        Source: LONGLONG; const pSourceFormat: TGUID): HResult; stdcall;
    function SetPositions(var pCurrent: LONGLONG; dwCurrentFlags: DWORD;
        var pStop: LONGLONG; dwStopFlags: DWORD): HResult; stdcall;
    function GetPositions(var pCurrent, pStop: LONGLONG): HResult; stdcall;
    function GetAvailable(var pEarliest, pLatest: LONGLONG): HResult; stdcall;
    function SetRate(dRate: double): HResult; stdcall;
    function GetRate(var pdRate: double): HResult; stdcall;
    function GetPreroll(var pllPreroll: LONGLONG): HResult; stdcall;
  end;

const
  AM_MEDIAEVENT_NONOTIFY = $01;

type
  TRefFilter = record
    Clsid: TGUID;
    Name: LPWSTR;
  end;
  PRefFilter = ^TRefFilter;

  IEnumRegFilters = interface(IUnknown)
    ['{56A868A4-0AD4-11CE-B03A-0020AF0BA770}']
    function Next(cFilters: ULONG; var apRegFilter: PRefFilter;
        var pcFetched: ULONG): HResult; stdcall;
    function Skip(cFilters: ULONG): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppEnum: IEnumRegFilters): HResult; stdcall;
  end;

const
  MERIT_PREFERRED       = $800000;
  MERIT_NORMAL          = $600000;
  MERIT_UNLIKELY        = $400000;
  MERIT_DO_NOT_USE      = $200000;
  MERIT_SW_COMPRESSOR   = $100000;
  MERIT_HW_COMPRESSOR   = $100050;

type
  IFilterMapper = interface(IUnknown)
    ['{56A868A3-0AD4-11CE-B03A-0020AF0BA770}']
    function RegisterFilter(const clsid: TGUID; Name: LPCWSTR; dwMerit: DWORD): HResult; stdcall;
    function RegisterFilterInstance(const clsid: TGUID; Name: LPCWSTR;
        var MRId: TGUID): HResult; stdcall;
    function RegisterPin(const Filter: TGUID; Name: LPCWSTR;
        bRendered, bOutput, bZero, bMany: BOOL; const ConnectsToFilter: TGUID;
        ConnectsToPin: LPCWSTR): HResult; stdcall;
    function RegisterPinType(const clsFilter: TGUID; strName: LPCWSTR;
        const clsMajorType, clsSubType: TGUID): HResult; stdcall;
    function UnregisterFilter(const Filter: TGUID): HResult; stdcall;
    function UnregisterFilterInstance(const MRId: TGUID): HResult; stdcall;
    function UnregisterPin(const Filter: TGUID; Name: LPCWSTR): HResult; stdcall;
    function EnumMatchingFilters(out ppEnum: IEnumRegFilters; dwMerit: DWORD;
        bInputNeeded: BOOL; const clsInMaj, clsInSub: TGUID;
        bRender, bOututNeeded: BOOL; const clsOutMaj, clsOutSub: TGUID): HResult; stdcall;
  end;

  PRefInTypes = ^TRefInTypes;
  TRefInTypes = record
    clsMajorType: PGUID;
    clsMinorType: PGUID;
  end;

  PRegFilterPins = ^TRegFilterPins;
  TRegFilterPins = record
    strName: LPWSTR;
    bRendered: BOOL;
    bOutput: BOOL;
    bZero: BOOL;
    bMany: BOOL;
    oFilter: PGUID;
    strConnectsToPin: PWCHAR;
    nMediaTypes: UINT;
    lpMediaType: PRefInTypes;
  end;

  PRegPinMedium = ^TRegPinMedium;
  TRegPinMedium = record
    clsMedium: TGUID;
    dw1: DWORD;
    dw2: DWORD;
  end;

const
  REG_PINFLAG_B_ZERO     = $1;
  REG_PINFLAG_B_RENDERER = $2;
  REG_PINFLAG_B_MANY     = $4;
  REG_PINFLAG_B_OUTPUT   = $8;

type
  PRegFilterPins2 = ^TRegFilterPins2;
  TRegFilterPins2 = record
    dwFlags: DWORD;
    cInstances: UINT;
    nMediaTypes: UINT;
    lpMediaType: PRefInTypes;
    lpMedium: PRegPinMedium;
    clsPinCategory: PGUID;
  end;

  TRegFilter2 = record
    dwVersion: DWORD;
    dwMerit: DWORD;
    case Integer of
      0: (
        cPins: ULONG;
        cPins2: ULONG;
      );
      1: (
        rgPins: PRegFilterPins;
        rgPins2: PRegFilterPins2;
      );
  end;

  IFilterMapper2 = interface(IUnknown)
    ['{B79BB0B0-33C1-11D1-ABE1-00A0C905F375}']
    function CreateCategory(const clsidCategory: TGUID; dwCategoryMerit: DWORD;
        Description: LPCWSTR): HResult; stdcall;
    function UnregisterFilter(const pclsidCategory: TGUID;
        szInstance: PWCHAR; const Filter: TGUID): HResult; stdcall;
    function RegisterFilter(const clsidFilter: TGUID; Name: LPCWSTR;
        out ppMoniker: IMoniker; const pclsidCategory: TGUID;
        szInstance: PWCHAR; const prf2: TRegFilter2): HResult; stdcall;

    function EnumMatchingFilters(out ppEnum: IEnumMoniker; dwFlags: DWORD;
        bExactMatch: BOOL; dwMerit: DWORD; bInputNeeded: BOOL; cInputTypes: DWORD;
        const pInputTypes, pPinCategoryIn: TGUID; bRender, bOutputNeeded: BOOL;
        cOutputTypes: DWORD; const pMedOut: TRegPinMedium;
        const pPinCategoryOut: TGUID): HResult; stdcall;
  end;

  TQualityMessageType = (
    Famine,
    Flood
  );

  TQuality = record
    Typ: TQualityMessageType;
    Proportion: Longint;
    Late: TReference_Time;
    TimeStamp: TReference_Time;
  end;

  IQualityControl = interface(IUnknown)
    ['{56A868A5-0AD4-11CE-B03A-0020AF0BA770}']
    function Notify(pSelf: IBaseFilter; q: TQuality): HResult; stdcall;
    function SetSink(piqc: IQualityControl): HResult; stdcall;
  end;

const
  CK_NOCOLORKEY = $0;
  CK_INDEX      = $1;
  CK_RGB        = $2;

type
  TColorKey = record
    KeyType: DWORD;
    PaletteIndex: DWORD;
    LowColorValue: COLORREF;
    HighColorValue: COLORREF;
  end;

const
  ADVISE_NONE       = 0;
  ADVISE_CLIPPING   = $1;
  ADVISE_PALETTE    = $2;
  ADVISE_COLORKEY   = $4;
  ADVISE_POSITION   = $8;

  ADVISE_ALL = ADVISE_CLIPPING or ADVISE_PALETTE or ADVISE_COLORKEY or ADVISE_POSITION;

type
  IOverlayNotify = interface(IUnknown)
    ['{56A868A0-0AD4-11CE-B03A-0020AF0BA770}']
    function OnPaletteChange(dwColors: DWORD; const pPalette): HResult; stdcall;
    function OnClipChange(const pSourceRect, pDestinationRect: TRect;
        const pRgnData: TRgnData): HResult; stdcall;
    function OnColorKeyChange(const pColorKey: TColorKey): HResult; stdcall;
    function OnPositionChange(const pSourceRect, pDestinationRect: TRect): HResult; stdcall;
  end;

  IOverlay = interface(IUnknown)
    ['{56A868A1-0AD4-11CE-B03A-0020AF0BA770}']
    function GetPalette(var pdwColors: DWORD; var ppPalette): HResult; stdcall;
    function SetPalette(dwColors: DWORD; const pPalette): HResult; stdcall;
    function GetDefaultColorKey(var pColorKey: TColorKey): HResult; stdcall;
    function GetColorKey(var pColorKey: TColorKey): HResult; stdcall;
    function SetColorKey(const pColorKey: TColorKey): HResult; stdcall;
    function GetWindowHandle(var pHwnd: HWND): HResult; stdcall;
    function GetClipList(var pSourceRect, pDestinationRect: TRect;
        var ppRgnData: PRgnData): HResult; stdcall;
    function GetVideoPosition(var pSourceRect, pDestinationRect: TRect): HResult; stdcall;
    function Advise(pOverlayNotify: IOverlayNotify; dwInterests: DWORD): HResult; stdcall;
    function Unadvise: HResult; stdcall;
  end;

  IMediaEventSink = interface(IUnknown)
    ['{56A868A2-0AD4-11CE-B03A-0020AF0BA770}']
    function Notify(EventCode, EventParam1, EventParam2: Longint): HResult; stdcall;
  end;

  IFileSourceFilter = interface(IUnknown)
    ['{56A868A6-0AD4-11CE-B03A-0020AF0BA770}']
    function Load(pszFileName: PWCHAR; const pmt: TAM_Media_Type): HResult; stdcall;
    function GetCurFile(var ppszFileName: POLESTR; out pmt: TAM_Media_Type): HResult; stdcall;
  end;

  IFileSinkFilter = interface(IUnknown)
    ['{A2104830-7C70-11CF-8BCE-00AA00A3F1A6}']
    function SetFileName(pszFileName: POLESTR; const pmt: TAM_Media_Type): HResult; stdcall;
    function GetCurFile(var ppszFileName: POLESTR; out pmt: TAM_Media_Type): HResult; stdcall;
  end;

  IFileSinkFilter2 = interface(IFileSinkFilter)
    ['{00855B90-CE1B-11D0-BD4F-00A0C911CE86}']
    function SetMode(dwFlags: DWORD): HResult; stdcall;
    function GetMode(var pdwFlags: DWORD): HResult; stdcall;
  end;

  TAM_FileSink_Flags = (
    AM_FILE_INVALID_0,
    AM_FILE_OVERWRITE
  );

  PAsyncIOReq = ^TAsyncIOReq;
  TAsyncIOReq = record
    engine: array[0..3] of DWORD;
    lpv: Pointer;
    cb: DWORD;
    dwError: DWORD;
    cbDone: DWORD;
    liPos: TLargeInteger;
    hEvent: DWORD;
    dwUser: DWORD;
  end;

  IFileAsyncIO = interface(IUnknown)
    ['{56A868A7-0AD4-11CE-B03A-0020AF0BA770}']
    function QueryAlignment(var pdwAlign: DWORD): HResult; stdcall;
    function Read(const pReq: TAsyncIOReq): HResult; stdcall;
    function Write(const pReq: TAsyncIOReq): HResult; stdcall;
    function WaitForNext(var ppReq: PAsyncIOReq;
        dwTimeout: DWORD): HResult; stdcall;
    function WaitForSpecific(var pReq: TAsyncIOReq;
        dwTimeout: DWORD): HResult; stdcall;
    function DiscardPending: HResult; stdcall;
    function Flush: HResult; stdcall;
  end;

  IGraphBuilder = interface(IFilterGraph)
    ['{56A868A9-0AD4-11CE-B03A-0020AF0BA770}']
    function Connect(ppinOut, ppinIn: IPin): HResult; stdcall;
    function Render(ppinOut: IPin): HResult; stdcall;
    function RenderFile(lpcwstrFile, lpcwstrPlayList: LPCWSTR): HResult; stdcall;
    function AddSourceFilter(lpcwstrFileName, lpcwstrFilterName: LPCWSTR;
        out ppFilter: IBaseFilter): HResult; stdcall;
    function SetLogFile(hFile: THandle): HResult; stdcall;
    function Abort: HResult; stdcall;
    function ShouldOperationContinue: HResult; stdcall;
  end;

  IAMCopyCaptureFileProgress = interface;

  ICaptureGraphBuilder = interface(IUnknown)
    ['{BF87B6E0-8C27-11D0-B3F0-00AA003761C5}']
    function SetFiltergraph(pfg: IGraphBuilder): HResult; stdcall;
    function GetFiltergraph(out ppfg: IGraphBuilder): HResult; stdcall;
    function SetOutputFileName(const pType: TGUID; lpstrFile: PWCHAR;
        out ppf: IBaseFilter; out ppSink: IFileSinkFilter): HResult; stdcall;
    function FindInterface(const pCategory: TGUID; pf: IBaseFilter;
        const riid: TGUID; out ppint): HResult; stdcall;
    function RenderStream(const pCategory: TGUID; pSource: IUnknown;
        pfCompressor, pfRenderer: IBaseFilter): HResult; stdcall;
    function ControlStream(const pCategory: TGUID; pFilter: IBaseFilter;
        const pstart, pstop: TReference_Time; wStartCookie, wStopCookie: WORD): HResult; stdcall;
    function AllocCapFile(lpstr: PWCHAR; dwlSize: LONGLONG): HResult; stdcall;
    function CopyCaptureFile(lpwstrOld, lpwstrNew: PWCHAR; fAllowEscAbort: Integer;
        pCallback: IAMCopyCaptureFileProgress): HResult; stdcall;
  end;

  IAMCopyCaptureFileProgress = interface(IUnknown)
    ['{670D1D20-A068-11D0-B3F0-00AA003761C5}']
    function Progress(iProgress: Integer): HResult; stdcall;
  end;

const
  AM_RENDEREX_RENDERTOEXISTINGRENDERERS = $01;

type
  IFilterGraph2 = interface(IGraphBuilder)
    ['{36B73882-C2C8-11CF-8B46-00805F6CEF60}']
    function AddSourceFilterForMoniker(pMoniker: IMoniker; pCtx: IBindCtx;
        lpcwstrFilterName: LPCWSTR; out ppFilter: IBaseFilter): HResult; stdcall;
    function ReconnectEx(ppin: IPin; const pmt: TAM_Media_Type): HResult; stdcall;
    function RenderEx(pPinOut: IPin; dwFlags: DWORD; pvContext: Pointer): HResult; stdcall;
  end;

  IStreamBuilder = interface(IUnknown)
    ['{56A868BF-0AD4-11CE-B03A-0020AF0BA770}']
    function Render(ppinOut: IPin; pGraph: IGraphBuilder): HResult; stdcall;
    function Backout(ppinOut: IPin; pGraph: IGraphBuilder): HResult; stdcall;
  end;

  IAsyncReader = interface(IUnknown)
    ['{56A868AA-0AD4-11CE-B03A-0020AF0BA770}']
    function RequestAllocator(pPreferred: IMemAllocator;
        const pProps: TAllocator_Properties; out ppActual: IMemAllocator): HResult; stdcall;
    function Request(pSample: IMediaSample; dwUser: DWORD): HResult; stdcall;
    function WaitForNext(dwTimeout: DWORD; out ppSample: IMediaSample;
        var pdwUser: DWORD): HResult; stdcall;
    function SyncReadAligned(pSample: IMediaSample): HResult; stdcall;
    function SyncRead(llPosition: LONGLONG; lLength: Longint; var pBuffer): HResult; stdcall;
    function Length(var pTotal, pAvailable: LONGLONG): HResult; stdcall;
    function BeginFlush: HResult; stdcall;
    function EndFlush: HResult; stdcall;
  end;

  IGraphVersion = interface(IUnknown)
    ['{56A868AB-0AD4-11CE-B03A-0020AF0BA770}']
    function QueryVersion(var pVersion: Longint): HResult; stdcall;
  end;

  IResourceConsumer = interface(IUnknown)
    ['{56A868AD-0AD4-11CE-B03A-0020AF0BA770}']
    function AcquireResource(idResource: Longint): HResult; stdcall;
    function ReleaseResource(idResource: Longint): HResult; stdcall;
  end;

  IResourceManager = interface(IUnknown)
    ['{56A868AC-0AD4-11CE-B03A-0020AF0BA770}']
    function Register(pName: LPCWSTR; cResource: Longint;
        var plToken: Longint): HResult; stdcall;
    function RegisterGroup(pName: LPCWSTR; cResource: Longint;
        const palTokens: Longint; var plToken: Longint): HResult; stdcall;
    function RequestResource(idResource: Longint; pFocusObject: IUnknown;
        pConsumer: IResourceConsumer): HResult; stdcall;
    function NotifyAcquire(idResource: Longint; pConsumer: IResourceConsumer;
        hr: HResult): HResult; stdcall;
    function NotifyRelease(idResource: Longint; pConsumer: IResourceConsumer;
        bStillWant: BOOL): HResult; stdcall;
    function CancelRequest(idResource: Longint; pConsumer: IResourceConsumer): HResult; stdcall;
    function SetFocus(pFocusObject: IUnknown): HResult; stdcall;
    function ReleaseFocus(pFocusObject: IUnknown): HResult; stdcall;
  end;

  IDistributorNotify = interface(IUnknown)
    ['{56A868AF-0AD4-11CE-B03A-0020AF0BA770}']
    function Stop: HResult; stdcall;
    function Pause: HResult; stdcall;
    function Run(tStart: TReference_Time): HResult; stdcall;
    function SetSyncSource(pClock: IReferenceClock): HResult; stdcall;
    function NotifyGraphChange: HResult; stdcall;
  end;

const
  AM_STREAM_INFO_START_DEFINED   = $1;
  AM_STREAM_INFO_STOP_DEFINED    = $2;
  AM_STREAM_INFO_DISCARDING      = $4;
  AM_STREAM_INFO_STOP_SEND_EXTRA = $10;

type
  {TAM_Stream_Info_Flags = (
    AM_STREAM_INFO_INVALID_0,
    AM_STREAM_INFO_START_DEFINED,
    AM_STREAM_INFO_INVALID_1,
    AM_STREAM_INFO_STOP_DEFINED,
    AM_STREAM_INFO_INVALID_3,
    AM_STREAM_INFO_DISCARDING,
    AM_STREAM_INFO_INVALID_4,
    AM_STREAM_INFO_INVALID_5,
    AM_STREAM_INFO_INVALID_6,
    AM_STREAM_INFO_INVALID_7,
    AM_STREAM_INFO_INVALID_8,
    AM_STREAM_INFO_INVALID_9,
    AM_STREAM_INFO_INVALID_10,
    AM_STREAM_INFO_INVALID_11,
    AM_STREAM_INFO_INVALID_12,
    AM_STREAM_INFO_INVALID_13,
    AM_STREAM_INFO_INVALID_14,
    AM_STREAM_INFO_INVALID_15,
    AM_STREAM_INFO_STOP_SEND_EXTRA
  );
      }
  TAM_Stream_Info = record
    tStart: TReference_Time;
    tStop: TReference_Time;
    dwStartCookie: DWORD;
    dwStopCookie: DWORD;
    dwFlags: DWORD;
  end;

  IAMStreamControl = interface(IUnknown)
    ['{36b73881-c2c8-11cf-8b46-00805f6cef60}']
    function StartAt(const ptStart: TReference_Time; dwCookie: DWORD): HResult; stdcall;
    function StopAt(const ptStop: TReference_Time; bSendExtra: BOOL;
        dwCookie: DWORD): HResult; stdcall;
    function GetInfo(out pInfo: TAM_Stream_Info): HResult; stdcall;
  end;

  ISeekingPassThru = interface(IUnknown)
    ['{36B73883-C2C8-11CF-8B46-00805F6CEF60}']
    function Init(bSupportRendering: BOOL; pPin: IPin): HResult; stdcall;
  end;

  TVideo_Stream_Config_Caps = record
    guid: TGUID;
    VideoStandard: ULONG;
    InputSize: TSize;
    MinCroppingSize: TSize;
    MaxCroppingSize: TSize;
    CropGranularityX: Integer;
    CropGranularityY: Integer;
    CropAlignX: Integer;
    CropAlignY: Integer;
    MinOutputSize: TSize;
    MaxOutputSize: TSize;
    OutputGranularityX: Integer;
    OutputGranularityY: Integer;
    StretchTapsX: Integer;
    StretchTapsY: Integer;
    ShrinkTapsX: Integer;
    ShrinkTapsY: Integer;
    MinFrameInterval: LONGLONG;
    MaxFrameInterval: LONGLONG;
    MinBitsPerSecond: Longint;
    MaxBitsPerSecond: Longint;
  end;

  TAudio_Stream_Config_Caps = record
    guid: TGUID;
    MinimumChannels: ULONG;
    MaximumChannels: ULONG;
    ChannelsGranularity: ULONG;
    MinimumBitsPerSample: ULONG;
    MaximumBitsPerSample: ULONG;
    BitsPerSampleGranularity: ULONG;
    MinimumSampleFrequency: ULONG;
    MaximumSampleFrequency: ULONG;
    SampleFrequencyGranularity: ULONG;
  end;

  IAMStreamConfig = interface(IUnknown)
    ['{C6E13340-30AC-11d0-A18C-00A0C9118956}']
    function SetFormat(const pmt: TAM_Media_Type): HResult; stdcall;
    function GetFormat(var ppmt: PAM_Media_Type): HResult; stdcall;
    function GetNumberOfCapabilities(var piCount, piSize: Integer): HResult; stdcall;
    function GetStreamCaps(iIndex: Integer; var ppmt: PAM_Media_Type;
        var pSCC): HResult; stdcall;
  end;

  TInterleavingMode = (
    INTERLEAVE_NONE,
    INTERLEAVE_CAPTURE,
    INTERLEAVE_FULL
  );

  IConfigInterleaving = interface(IUnknown)
    ['{BEE3D220-157B-11d0-BD23-00A0C911CE86}']
    function put_Mode(mode: TInterleavingMode): HResult; stdcall;
    function get_Mode(var pMode: TInterleavingMode): HResult; stdcall;
    function put_Interleaving(const prtInterleave, prtPreroll: TReference_Time): HResult; stdcall;
    function get_Interleaving(var prtInterleave, prtPreroll: TReference_Time): HResult; stdcall;
  end;

  IConfigAviMux = interface(IUnknown)
    ['{5ACD6AA0-F482-11ce-8B67-00AA00A3F1A6}']
    function SetMasterStream(iStream: Longint): HResult; stdcall;
    function GetMasterStream(var pStream: Longint): HResult; stdcall;
    function SetOutputCompatibilityIndex(fOldIndex: BOOL): HResult; stdcall;
    function GetOutputCompatibilityIndex(var pfOldIndex: BOOL): HResult; stdcall;
  end;

const
  CompressionCaps_CanQuality    = $1;
  CompressionCaps_CanCrunch     = $2;
  CompressionCaps_CanKeyFrame   = $4;
  CompressionCaps_CanBFrame     = $8;
  CompressionCaps_CanWindow     = $10;

type
  IAMVideoCompression = interface(IUnknown)
    ['{C6E13343-30AC-11d0-A18C-00A0C9118956}']
    function put_KeyFrameRate(KeyFrameRate: Longint): HResult; stdcall;
    function get_KeyFrameRate(pKeyFrameRate: Longint): HResult; stdcall;
    function put_PFramesPerKeyFrame(PFramesPerKeyFrame: Longint): HResult; stdcall;
    function get_PFramesPerKeyFrame(var pPFramesPerKeyFrame: Longint): HResult; stdcall;
    function put_Quality(Quality: double): HResult; stdcall;
    function get_Quality(var pQuality: double): HResult; stdcall;
    function put_WindowSize(WindowSize: LONGLONG): HResult; stdcall;
    function get_WindowSize(var pWindowSize: LONGLONG): HResult; stdcall;
    function GetInfo(pszVersion: PWCHAR; var pcbVersion: Integer;
        pszDescription: LPWSTR; var pcbDescription: Integer;
        var pDefaultKeyFrameRate, pDefaultPFramesPerKey: Longint;
        var pDefaultQuality: double; pCapabilities: Longint): HResult; stdcall;
    function OverrideKeyFrame(FrameNumber: Longint): HResult; stdcall;
    function OverrideFrameSize(FrameNumber, Size: Longint): HResult; stdcall;
  end;

const
  VfwCaptureDialog_Source  = $1;
  VfwCaptureDialog_Format  = $2;
  VfwCaptureDialog_Display = $4;

  VfwCompressDialog_Config = $1;
  VfwCompressDialog_About  = $2;

type
  IAMVfwCaptureDialogs = interface(IUnknown)
    ['{D8D715A0-6E5E-11D0-B3F0-00AA003761C5}']
    function HasDialog(iDialog: Integer): HResult; stdcall;
    function ShowDialog(iDialog: Integer; hwnd: HWND): HResult; stdcall;
    function SendDriverMessage(iDialog: Integer; uMsg: Integer;
        dw1, dw2: Longint): HResult; stdcall;
  end;

  IAMVfwCompressDialogs = interface(IUnknown)
    ['{D8D715A3-6E5E-11D0-B3F0-00AA003761C5}']
    function ShowDialog(iDialog: Integer; hwnd: HWND): HResult; stdcall;
    function GetState(var pState; var pcbState: Integer): HResult; stdcall;
    function SetState(const pState; cbState: Integer): HResult; stdcall;
    function SendDriverMessage(uMsg: Integer; dw1, dw2: Longint): HResult; stdcall;
  end;

  IAMDroppedFrames = interface(IUnknown)
    ['{C6E13344-30AC-11d0-A18C-00A0C9118956}']
    function GetNumDropped(var plDropped: Longint): HResult; stdcall;
    function GetNumNotDropped(var plNotDropped: Longint): HResult; stdcall;
    function GetDroppedInfo(lSize: Longint; var plArray: Longint;
        var plNumCopied: Longint): HResult; stdcall;
    function GetAverageFrameSize(var plAverageSize: Longint): HResult; stdcall;
  end;

const
  AMF_AUTOMATICGAIN = -1;

type
  IAMAudioInputMixer = interface(IUnknown)
    ['{54C39221-8380-11d0-B3F0-00AA003761C5}']
    function put_Enable(fEnable: BOOL): HResult; stdcall;
    function get_Enable(var pfEnable: BOOL): HResult; stdcall;
    function put_Mono(fMono: BOOL): HResult; stdcall;
    function get_Mono(var pfMono: BOOL): HResult; stdcall;
    function put_MixLevel(Level: double): HResult; stdcall;
    function get_MixLevel(var pLevel: double): HResult; stdcall;
    function put_Pan(Pan: double): HResult; stdcall;
    function get_Pan(var pPan: double): HResult; stdcall;
    function put_Loudness(fLoudness: BOOL): HResult; stdcall;
    function get_Loudness(var pfLoudness: BOOL): HResult; stdcall;
    function put_Treble(Treble: double): HResult; stdcall;
    function get_Treble(var pTreble: double): HResult; stdcall;
    function get_TrebleRange(var pRange: double): HResult; stdcall;
    function put_Bass(Bass: double): HResult; stdcall;
    function get_Bass(var pBass: double): HResult; stdcall;
    function get_BassRange(var pRange: double): HResult; stdcall;
  end;

  IAMBufferNegotiation = interface(IUnknown)
    ['{56ED71A0-AF5F-11D0-B3F0-00AA003761C5}']
    function SuggestAllocatorProperties(const pprop: TAllocator_Properties): HResult; stdcall;
    function GetAllocatorProperties(var pprop: TAllocator_Properties): HResult; stdcall;
  end;

const
  AnalogVideo_None        = 0;
  AnalogVideo_NTSC_M      = $1;
  AnalogVideo_NTSC_M_J    = $2;
  AnalogVideo_NTSC_433    = $4;
  AnalogVideo_PAL_B       = $10;
  AnalogVideo_PAL_D       = $20;
  AnalogVideo_PAL_G       = $40;
  AnalogVideo_PAL_H       = $80;
  AnalogVideo_PAL_I       = $100;
  AnalogVideo_PAL_M       = $200;
  AnalogVideo_PAL_N       = $400;
  AnalogVideo_PAL_60      = $800;
  AnalogVideo_SECAM_B     = $1000;
  AnalogVideo_SECAM_D     = $2000;
  AnalogVideo_SECAM_G     = $4000;
  AnalogVideo_SECAM_H     = $8000;
  AnalogVideo_SECAM_K     = $10000;
  AnalogVideo_SECAM_K1    = $20000;
  AnalogVideo_SECAM_L     = $40000;
  AnalogVideo_SECAM_L1    = $80000;

  AnalogVideo_NTSC_Mask   = $00000007;
  AnalogVideo_PAL_Mask    = $00000FF0;
  AnalogVideo_SECAM_Mask  = $000FF000;

type
  TTunerInputType =(
    TunerInputCable,
    TunerInputAntenna
  );

  TVideoCopyProtectionType = (
    VideoCopyProtectionMacrovisionBasic,
    VideoCopyProtectionMacrovisionCBI
  );

  TPhysicalConnectorType = (
    PhysConn_Video_Tuner,
    PhysConn_Video_Composite,
    PhysConn_Video_SVideo,
    PhysConn_Video_RGB,
    PhysConn_Video_YRYBY,
    PhysConn_Video_SerialDigital,
    PhysConn_Video_ParallelDigital,
    PhysConn_Video_SCSI,
    PhysConn_Video_AUX,
    PhysConn_Video_1394,
    PhysConn_Video_USB,
    PhysConn_Video_VideoDecoder,
    PhysConn_Video_VideoEncoder,
    PhysConn_Video_SCART,
    PhysConn_Video_Black,
    PhysConn_Audio_Tuner,
    PhysConn_Audio_Line,
    PhysConn_Audio_Mic,
    PhysConn_Audio_AESDigital,
    PhysConn_Audio_SPDIFDigital,
    PhysConn_Audio_SCSI,
    PhysConn_Audio_AUX,
    PhysConn_Audio_1394,
    PhysConn_Audio_USB,
    PhysConn_Audio_AudioDecoder
  );

  IAMAnalogVideoDecoder = interface(IUnknown)
    ['{C6E13350-30AC-11d0-A18C-00A0C9118956}']
    function get_AvailableTVFormats(var lAnalogVideoStandard: Longint): HResult; stdcall;
    function put_TVFormat(lAnalogVideoStandard: Longint): HResult; stdcall;
    function get_TVFormat(var plAnalogVideoStandard: Longint): HResult; stdcall;
    function get_HorizontalLocked(var plLocked: Longint): HResult; stdcall;
    function put_VCRHorizontalLocking(lVCRHorizontalLocking: Longint): HResult; stdcall;
    function get_VCRHorizontalLocking(var plVCRHorizontalLocking: Longint): HResult; stdcall;
    function get_NumberOfLines(var plNumberOfLines: Longint): HResult; stdcall;
    function put_OutputEnable(lOutputEnable: LongBool): HResult; stdcall;
    function get_OutputEnable(var plOutputEnable: LongBool): HResult; stdcall;
  end;

  TVideoProcAmpProperty = (
    VideoProcAmp_Brightness,
    VideoProcAmp_Contrast,
    VideoProcAmp_Hue,
    VideoProcAmp_Saturation,
    VideoProcAmp_Sharpness,
    VideoProcAmp_Gamma,
    VideoProcAmp_ColorEnable,
    VideoProcAmp_WhiteBalance,
    VideoProcAmp_BacklightCompensation
  );

  TVideoProcAmpFlags = (
    VideoProcAmp_Flags_Manual,
    VideoProcAmp_Flags_Auto
  );

  IAMVideoProcAmp = interface(IUnknown)
    ['{C6E13360-30AC-11d0-A18C-00A0C9118956}']
    function GetRange(Property_: TVideoProcAmpProperty;
        var pMin, pMax, pSteppingDelta, pDefault, pCapsFlags: TVideoProcAmpFlags): HResult; stdcall;
    function Set_(Property_: TVideoProcAmpProperty; lValue: Longint;
        Flags: TVideoProcAmpFlags): HResult; stdcall;
    function Get(Property_: TVideoProcAmpProperty; var lValue: Longint;
        var Flags: TVideoProcAmpFlags): HResult; stdcall;
  end;

  TCameraControlProperty = (
    CameraControl_Pan,
    CameraControl_Tilt,
    CameraControl_Roll,
    CameraControl_Zoom,
    CameraControl_Exposure,
    CameraControl_Iris,
    CameraControl_Focus
  );

  TCameraControlFlags = (
    CameraControl_Flags_Manual,
    CameraControl_Flags_Auto
  );

  IAMCameraControl = interface(IUnknown)
    ['{C6E13370-30AC-11d0-A18C-00A0C9118956}']
    function GetRange(Property_: TCameraControlProperty;
        var pMin, pMax, pSteppingDelta, pDefault, pCapsFlags: Longint): HResult; stdcall;
    function Set_(Property_: TCameraControlProperty; lValue: Longint;
        Flags: TCameraControlFlags): HResult; stdcall;
    function Get(Property_: TCameraControlProperty; var lValue: Longint;
        var Flags: TCameraControlFlags): HResult; stdcall;
  end;

  IAMCrossbar = interface(IUnknown)
    ['{C6E13380-30AC-11d0-A18C-00A0C9118956}']
    function get_PinCounts(var OutputPinCount, InputPinCount: Longint): HResult; stdcall;
    function CanRoute(OutputPinIndex, InputPinIndex: Longint): HResult; stdcall;
    function Route(OutputPinIndex, InputPinIndex: Longint): HResult; stdcall;
    function get_IsRoutedTo(OutputPinIndex: Longint;
        var InputPinIndex: Longint): HResult; stdcall;
    function get_CrossbarPinInfo(IsInputPin: BOOL; PinIndex: Longint;
        var PinIndexRelated, PhysicalType: Longint): HResult; stdcall;
  end;

const
  AMTUNER_SUBCHAN_NO_TUNE = -2;
  AMTUNER_SUBCHAN_DEFAULT = -1;

  AMTUNER_HASNOSIGNALSTRENGTH = -1;
  AMTUNER_NOSIGNAL            = 0;
  AMTUNER_SIGNALPRESENT       = 1;

  AMTUNER_MODE_DEFAULT    = 0;
  AMTUNER_MODE_TV         = $1;
  AMTUNER_MODE_FM_RADIO   = $2;
  AMTUNER_MODE_AM_RADIO   = $4;
  AMTUNER_MODE_DSS        = $8;

type
  TAMTunerModeType = DWORD;

  TAMTunerEventType = (
    AMTUNER_EVENT_CHANGED
  );
  //AMTUNER_EVENT_CHANGED   = $1;

  IAMTunerNotification = interface;

  IAMTuner = interface(IUnknown)
    ['{211A8761-03AC-11d1-8D13-00AA00BD8339}']
    function put_Channel(lChannel, lVideoSubChannel, lAudioSubChannel: Longint): HResult; stdcall;
    function get_Channel(var lChannel, lVideoSubChannel, lAudioSubChannel: Longint): HResult; stdcall;
    function ChannelMinMax(var lChannelMin, lChannelMax): HResult; stdcall;
    function put_CountryCode(lCountryCode: Longint): HResult; stdcall;
    function get_CountryCode(var lCountryCode: Longint): HResult; stdcall;
    function put_TuningSpace(lTuningSpace: Longint): HResult; stdcall;
    function get_TuningSpace(var lTuningSpace: Longint): HResult; stdcall;
    function Logon(hCurrentUser: THandle): HResult; stdcall;
    function Logout: HResult; stdcall;
    function SignalPresent(var plSignalStrength: Longint): HResult; stdcall;
    function put_Mode(lMode: TAMTunerModeType): HResult; stdcall;
    function get_Mode(var plMode: TAMTunerModeType): HResult; stdcall;
    function GetAvailableModes(var plModes: Longint): HResult; stdcall;
    function RegisterNotificationCallBack(pNotify: IAMTunerNotification;
        lEvents: Longint): HResult; stdcall;
    function UnRegisterNotificationCallBack(pNotify: IAMTunerNotification): HResult; stdcall;
  end;

  IAMTunerNotification = interface(IUnknown)
    ['{211A8760-03AC-11d1-8D13-00AA00BD8339}']
    function OnEvent(Event: TAMTunerEventType): HResult; stdcall;
  end;

  IAMTVTuner = interface(IAMTuner)
    ['{211A8766-03AC-11d1-8D13-00AA00BD8339}']
    function get_AvailableTVFormats(var lAnalogVideoStandard: Longint): HResult; stdcall;
    function get_TVFormat(var plAnalogVideoStandard: Longint): HResult; stdcall;
    function AutoTune(lChannel: Longint; var plFoundSignal: Longint): HResult; stdcall;
    function StoreAutoTune: HResult; stdcall;
    function get_NumInputConnections(var plNumInputConnections: Longint): HResult; stdcall;
    function put_InputType(lIndex: Longint; InputType: TTunerInputType): HResult; stdcall;
    function get_InputType(lIndex: Longint; var InputType: TTunerInputType): HResult; stdcall;
    function put_ConnectInput(lIndex: Longint): HResult; stdcall;
    function get_ConnectInput(var plIndex: Longint): HResult; stdcall;
    function get_VideoFrequency(var lFreq: Longint): HResult; stdcall;
    function get_AudioFrequency(var lFreq: Longint): HResult; stdcall;
  end;

  IBPCSatelliteTuner = interface(IAMTuner)
    ['{211A8765-03AC-11d1-8D13-00AA00BD8339}']
    function get_DefaultSubChannelTypes(var plDefaultVideoType, plDefaultAudioType: Longint): HResult; stdcall;
    function put_DefaultSubChannelTypes(lDefaultVideoType, lDefaultAudioType: Longint): HResult; stdcall;
    function IsTapingPermitted: HResult; stdcall;
  end;

const
  AMTVAUDIO_MODE_MONO   = $1;
  AMTVAUDIO_MODE_STEREO = $2;
  AMTVAUDIO_MODE_LANG_A = $10;
  AMTVAUDIO_MODE_LANG_B = $20;
  AMTVAUDIO_MODE_LANG_C = $40;

type
  TAMTVAudioEventType = (
    AMTVAUDIO_EVENT_CHANGED
  );

  IAMTVAudio = interface(IUnknown)
    ['{83EC1C30-23D1-11d1-99E6-00A0C9560266}']
    function GetHardwareSupportedTVAudioModes(var plModes: Longint): HResult; stdcall;
    function GetAvailableTVAudioModes(var plModes: Longint): HResult; stdcall;
    function get_TVAudioMode(var plMode: Longint): HResult; stdcall;
    function put_TVAudioMode(lMode: Longint): HResult; stdcall;
    function RegisterNotificationCallBack(pNotify: IAMTunerNotification;
        lEvents: Longint): HResult; stdcall;
    function UnRegisterNotificationCallBack(pNotify: IAMTunerNotification): HResult; stdcall;
  end;

  IAMTVAudioNotification = interface(IUnknown)
    ['{83EC1C33-23D1-11D1-99E6-00A0C9560266}']
    function OnEvent(Event: TAMTVAudioEventType): HResult; stdcall;
  end;

  IAMAnalogVideoEncoder = interface(IUnknown)
    ['{C6E133B0-30AC-11d0-A18C-00A0C9118956}']
    function get_AvailableTVFormats(var lAnalogVideoStandard: Longint): HResult; stdcall;
    function put_TVFormat(lAnalogVideoStandard: Longint): HResult; stdcall;
    function get_TVFormat(var plAnalogVideoStandard: Longint): HResult; stdcall;
    function put_CopyProtection(lVideoCopyProtection: Longint): HResult; stdcall;
    function get_CopyProtection(var lVideoCopyProtection: Longint): HResult; stdcall;
    function put_CCEnable(lCCEnable: LongBool): HResult; stdcall;
    function get_CCEnable(var lCCEnable: LongBool): HResult; stdcall;
  end;

  TAMProperty_Pin = (
    AMPROPERTY_PIN_CATEGORY,
    AMPROPERTY_PIN_MEDIUM
  );

  IMediaPropertyBag = interface(IPropertyBag)
    ['{6025A880-C0D5-11D0-BD4E-00A0C911CE86}']
    function EnumProperty(iProperty: ULONG; var pvarPropertyName,
        pvarPropertyValue: Variant): HResult; stdcall;
  end;

  IPersistMediaPropertyBag = interface(IPersist)
     ['{5738E040-B67F-11d0-BD4D-00A0C911CE86}']
     function InitNew: HResult; stdcall;
     function Load(pPropBag: IMediaPropertyBag; pErrorLog: IErrorLog): HResult; stdcall;
     function Save(pPropBag: IMediaPropertyBag; fClearDirty, fSaveAllProperties: BOOL): HResult; stdcall;
  end;

  IAMPhysicalPinInfo = interface(IUnknown)
    ['{F938C991-3029-11CF-8C44-00AA006B6814}']
    function GetPhysicalType(var pType: Longint; var ppszType: POLESTR): HResult; stdcall;
  end;

  IAMExtDevice = interface(IUnknown)
    ['{B5730A90-1A2C-11CF-8C23-00AA006B6814}']
    function GetCapability(Capability: Longint; var pValue: Longint; pdblValue: double): HResult; stdcall;
    function get_ExternalDeviceID(var ppszData: POLESTR): HResult; stdcall;
    function get_ExternalDeviceVersion(var ppszData: POLESTR): HResult; stdcall;
    function put_DevicePower(PowerMode: Longint): HResult; stdcall;
    function get_DevicePower(var pPowerMode: Longint): HResult; stdcall;
    function Calibrate(hEvent: THandle; Mode: Longint; var pStatus: Longint): HResult; stdcall;
    function put_DevicePort(DevicePort: Longint): HResult; stdcall;
    function get_DevicePort(var pDevicePort: Longint): HResult; stdcall;
  end;

  IAMExtTransport = interface(IUnknown)
    ['{A03CD5F0-3045-11CF-8C44-00AA006B6814}']
    function GetCapability(Capability: Longint; var pValue: Longint; var pdblValue: double): HResult; stdcall;
    function put_MediaState(State: Longint): HResult; stdcall;
    function get_MediaState(var pState: Longint): HResult; stdcall;
    function put_LocalControl(State: Longint): HResult; stdcall;
    function get_LocalControl(var pState: Longint): HResult; stdcall;
    function GetStatus(StatusItem: Longint; var pValue: Longint): HResult; stdcall;
    function GetTransportBasicParameters(Param: Longint; var pValue: Longint; var ppszData: POLESTR): HResult; stdcall;
    function SetTransportBasicParameters(Param: Longint; Value: Longint; pszData: POLESTR): HResult; stdcall;
    function GetTransportVideoParameters(Param: Longint; var pValue: Longint): HResult; stdcall;
    function SetTransportVideoParameters(Param: Longint; Value: Longint): HResult; stdcall;
    function GetTransportAudioParameters(Param: Longint; var pValue: Longint): HResult; stdcall;
    function SetTransportAudioParameters(Param: Longint; Value: Longint): HResult; stdcall;
    function put_Mode(Mode: Longint): HResult; stdcall;
    function get_Mode(var pMode: Longint): HResult; stdcall;
    function put_Rate(dblRate: double): HResult; stdcall;
    function get_Rate(var pdblRate: double): HResult; stdcall;
    function GetChase(var pEnabled, pOffset: Longint; var phEvent: THandle): HResult; stdcall;
    function SetChase(Enable, Offset: Longint; hEvent: THandle): HResult; stdcall;
    function GetBump(var pSpeed, pDuration: Longint): HResult; stdcall;
    function SetBump(Speed, Duration: Longint): HResult; stdcall;
    function get_AntiClogControl(var pEnabled: Longint): HResult; stdcall;
    function put_AntiClogControl(Enable: Longint): HResult; stdcall;
    function GetEditPropertySet(EditID: Longint; var pState: Longint): HResult; stdcall;
    function SetEditPropertySet(var pEditID: Longint; State: Longint): HResult; stdcall;
    function GetEditProperty(EditID, Param: Longint; var pValue: Longint): HResult; stdcall;
    function SetEditProperty(EditID, Param, Value: Longint): HResult; stdcall;
    function get_EditStart(var pValue: Longint): HResult; stdcall;
    function put_EditStart(Value: Longint): HResult; stdcall;
  end;

  TTimeCode = record
    wFrameRate: Word;
    wFrameFract: Word;
    dwFrames: DWORD;
    qw: LONGLONG;
  end;

  TTimeCode_Sample = record
    qwTick: LONGLONG;
    timecode: TTimeCode;
    dwUser: DWORD;
    dwFlags: DWORD;
  end;

  IAMTimecodeReader = interface(IUnknown)
    ['{9B496CE1-811B-11CF-8C77-00AA006B6814}']
    function GetTCRMode(Param: Longint; var pValue: Longint): HResult; stdcall;
    function SetTCRMode(Param: Longint; Value: Longint): HResult; stdcall;
    function put_VITCLine(Line: Longint): HResult; stdcall;
    function get_VITCLine(var pLine: Longint): HResult; stdcall;
    function GetTimecode(var pTimecodeSample: TTimeCode_Sample): HResult; stdcall;
  end;

  IAMTimecodeGenerator = interface(IUnknown)
    ['{9B496CE0-811B-11CF-8C77-00AA006B6814}']
    function GetTCGMode(Param: Longint; var pValue: Longint): HResult; stdcall;
    function SetTCGMode(Param: Longint; Value: Longint): HResult; stdcall;
    function put_VITCLine(Line: Longint): HResult; stdcall;
    function get_VITCLine(var Line: Longint): HResult; stdcall;
    function SetTimecode(const pTimecodeSample: TTimeCode_Sample): HResult; stdcall;
    function GetTimecode(var pTimecodeSample: TTimeCode_Sample): HResult; stdcall;
  end;

  IAMTimecodeDisplay = interface(IUnknown)
    ['{9B496CE2-811B-11CF-8C77-00AA006B6814}']
    function GetTCDisplayEnable(var pState: Longint): HResult; stdcall;
    function SetTCDisplayEnable(State: Longint): HResult; stdcall;
    function GetTCDisplay(Param: Longint; var pValue: Longint): HResult; stdcall;
    function SetTCDisplay(Param, Value: Longint): HResult; stdcall;
  end;

  IAMDevMemoryAllocator = interface(IUnknown)
    ['{C6545BF0-E76B-11D0-BD52-00A0C911CE86}']
    function GetInfo(var pdwcbTotalFree, pdwcbLargestFree, pdwcbTotalMemory, pdwcbMinimumChunk: DWORD): HResult; stdcall;
    function CheckMemory(pBuffer: Pointer): HResult; stdcall;
    function Alloc(var ppBuffer: Pointer; var pdwcbBuffer: DWORD): HResult; stdcall;
    function Free(pBuffer: Pointer): HResult; stdcall;
    function GetDevMemoryObject(out ppUnkInnner: IUnknown; pUnkOuter: IUnknown): HResult; stdcall;
  end;

  IAMDevMemoryControl = interface(IUnknown)
    ['{C6545BF1-E76B-11D0-BD52-00A0C911CE86}']
    function QueryWriteSync: HResult; stdcall;
    function WriteSync: HResult; stdcall;
    function GetDevId(var pdwDevId: DWORD): HResult; stdcall;
  end;

const
  AMSTREAMSELECTINFO_ENABLED     = $1;
  AMSTREAMSELECTINFO_EXCLUSIVE   = $2;

  AMSTREAMSELECTENABLE_ENABLE    = $1;
  AMSTREAMSELECTENABLE_ENABLEALL = $2;

type
  IAMStreamSelect = interface(IUnknown)
    ['{C1960960-17F5-11D1-ABE1-00A0C905F375}']
    function Count(var pcStreams: DWORD): HResult; stdcall;
    function Info(lIndex: Longint; var ppmt: PAM_Media_Type;
        var pdwFlags: DWORD; var plcid: LCID; var pdwGroup: DWORD;
        var ppszName: PWCHAR; out ppObject: IUnknown; out ppUnk : IUnknown): HResult; stdcall;
    function Enable(lIndex: Longint; dwFlags: DWORD): HResult; stdcall;
  end;

  IAMovie = interface(IFilterGraph)
    ['{359ACE10-7688-11CF-8B23-00805F6CEF60}']
    function Connect(ppinOut, ppinIn: IPin): HResult; stdcall;
    function Render(ppinOut: IPin): HResult; stdcall;
    function Run: HResult; stdcall;
    function Pause: HResult; stdcall;
    function Stop: HResult; stdcall;
    function GetState(msTimeout: Longint; var pfs: TFilter_State): HResult; stdcall;
    function RenderFile(strFilename: LPCWSTR): HResult; stdcall;
    function AddSourceFilter(strFilename: LPCWSTR; out ppUnk: IBaseFilter): HResult; stdcall;
    function GetEventHandle(out hEvent: THandle): HResult; stdcall;
    function GetEvent(var lEventCode, lParam1, lParam2: Longint; msTimeout: Longint): HResult; stdcall;
    function WaitForCompletion(msTimeout: Longint; var pEvCode: Longint): HResult; stdcall;
    function CancelDefaultHandling(lEvCode: Longint): HResult; stdcall;
    function RestoreDefaultHandling(lEvCode: Longint): HResult; stdcall;
    function get_Duration(var plength: TRefTime): HResult; stdcall;
    function put_CurrentPosition(llTime: TRefTime): HResult; stdcall;
    function get_CurrentPosition(var pllTime: TRefTime): HResult; stdcall;
    function get_StopTime(var pllTime: TRefTime): HResult; stdcall;
    function put_StopTime(llTime: TRefTime): HResult; stdcall;
    function get_PrerollTime(var pllTime: TRefTime): HResult; stdcall;
    function put_PrerollTime(llTime: TRefTime): HResult; stdcall;
    function put_Rate(dRate: double): HResult; stdcall;
    function get_Rate(var pdRate: double): HResult; stdcall;
    function RemoveAllFilters: HResult; stdcall;
    function Play: HResult; stdcall;
    function PlayFile(strFilename: LPCWSTR): HResult; stdcall;
    function EnumFiltersByInterface(const riid: TGUID;
        out ppEnum: IEnumFilters): HResult; stdcall;
    function EnumPins(out ppEnum: IEnumPins): HResult; stdcall;
    function EnumPinsIn(out ppEnum: IEnumPins): HResult; stdcall;
    function EnumPinsOut(out ppEnum: IEnumPins): HResult; stdcall;
    function RenderAll: HResult; stdcall;
    function RenderNewFile(strFilename: LPCWSTR): HResult; stdcall;
    function FreeEventParams(lEvCode, lParam1, lParam2: Longint): HResult; stdcall;
  end;

const
  CDEF_CLASS_DEFAULT        = $1000;
  CDEF_BYPASS_CLASS_MANAGER = $2000;

type
  ICreateDevEnum = interface(IUnknown)
    ['{29840822-5B84-11D0-BD3B-00A0C911CE86}']
    function CreateClassEnumerator(const clsidDeviceClass: TGUID;
        out ppEnumMoniker: IEnumMoniker; dwFlags: DWORD): HResult; stdcall;
  end;

  TDVD_Domain = (
    DVD_DOMAIN_FirstPlay,
    DVD_DOMAIN_VideoManagerMenu,
    DVD_DOMAIN_VideoTitleSetMenu,
    DVD_DOMAIN_Title,
    DVD_DOMAIN_Stop
  );

  TDVD_Menu_ID = (
    DVD_MENU_INVALID_0,
    DVD_MENU_INVALID_1,
    DVD_MENU_Title,
    DVD_MENU_Root,
    DVD_MENU_Subpicture,
    DVD_MENU_Audio,
    DVD_MENU_Angle,
    DVD_MENU_Chapter
  );

  TDVD_Disc_Side = (
    DVD_SIDE_INVALID_0,
    DVD_SIDE_A,
    DVD_SIDE_B
  );

  TDVD_PREFERRED_Display_Mode = (
    DISPLAY_CONTENT_DEFAULT,
    DISPLAY_16x9,
    DISPLAY_4x3_PANSCAN_PREFERRED,
    DISPLAY_4x3_LETTERBOX_PREFERRED
  );

  TDVD_REGISTER = Word;

  TGPRMArray = array[0..15] of TDVD_REGISTER;
  TSPRMArray = array[0..23] of TDVD_REGISTER;

  TDVD_ATR = record
    ulCAT: ULONG;
    pbATRI: array[0..767] of Byte;
  end;

  TDVD_VideoATR = array[0..1] of Byte;
  TDVD_AudioATR = array[0..7] of Byte;
  TDVD_SubpictureATR = array[0..5] of Byte;

  TDVD_FrameRate = (
    DVD_FPS_INVALID_0,
    DVD_FPS_25,
    DVD_FPS_INVALID_2,
    DVD_FPS_30NonDrop
  );

  TDVD_TimeCode = record
    Hours1: ULONG;        // Hours
    Hours10: ULONG;       // Tens of Hours

    Minutes1: ULONG;      // Minutes
    Minutes10: ULONG;     // Tens of Minutes

    Seconds1: ULONG;      // Seconds
    Seconds10: ULONG;     // Tens of Seconds

    Frames1: ULONG;       // Frames
    Frames10: ULONG;      // Tens of Frames

    FrameRateCode: ULONG; // use DVD_FRAMERATE to indicate frames/sec and drop/non-drop
  end;

  TDVD_Playback_Location = record
    TitleNum: ULONG;
    ChapterNum: ULONG;
    TimeCode: ULONG;
  end;

  TVALID_UOP_SOMTHING_OR_OTHER = DWORD;

const
  DVD_PARENTAL_LEVEL_8    = $8000;
  DVD_PARENTAL_LEVEL_7    = $4000;
  DVD_PARENTAL_LEVEL_6    = $2000;
  DVD_PARENTAL_LEVEL_5    = $1000;
  DVD_PARENTAL_LEVEL_4    = $0800;
  DVD_PARENTAL_LEVEL_3    = $0400;
  DVD_PARENTAL_LEVEL_2    = $0200;
  DVD_PARENTAL_LEVEL_1    = $0100;

type
  IDvdControl = interface(IUnknown)
    ['{A70EFE61-E2A3-11D0-A9BE-00AA0061BE93}']
    function TitlePlay(uiTitle: ULONG): HResult; stdcall;
    function ChapterPlay(uiTitle: ULONG; uiChapter: ULONG): HResult; stdcall;
    function TimePlay(uiTitle: ULONG; bcdTime: ULONG): HResult; stdcall;
    function StopForResume: HResult; stdcall;
    function GoUp: HResult; stdcall;
    function TimeSearch(bcdTime: ULONG): HResult; stdcall;
    function ChapterSearch(Chapter: ULONG): HResult; stdcall;
    function PrevPGSearch: HResult; stdcall;
    function TopPGSearch: HResult; stdcall;
    function NextPGSearch: HResult; stdcall;
    function ForwardScan(dwSpeed: double): HResult; stdcall;
    function BackwardScan(dwSpeed: double): HResult; stdcall;
    function MenuCall(MenuID: TDVD_Menu_ID): HResult; stdcall;
    function Resume: HResult; stdcall;
    function UpperButtonSelect: HResult; stdcall;
    function LowerButtonSelect: HResult; stdcall;
    function LeftButtonSelect: HResult; stdcall;
    function RightButtonSelect: HResult; stdcall;
    function ButtonActivate: HResult; stdcall;
    function ButtonSelectAndActivate(uiButton: ULONG): HResult; stdcall;
    function StillOff: HResult; stdcall;
    function PauseOn: HResult; stdcall;
    function PauseOff: HResult; stdcall;
    function MenuLanguageSelect(Language: LCID): HResult; stdcall;
    function AudioStreamChange(nAudio: ULONG): HResult; stdcall;
    function SubpictureStreamChange(nSubPicture: ULONG; bDisplay: BOOL): HResult; stdcall;
    function AngleChange(ulAngle: ULONG): HResult; stdcall;
    function ParentalLevelSelect(ulParentalLevel: ULONG): HResult; stdcall;
    function ParentalCountrySelect(wCountry: Word): HResult; stdcall;
    function KaraokeAudioPresentationModeChange(ulMode: ULONG): HResult; stdcall;
    function VideoModePreferrence(ulPreferredDisplayMode: ULONG): HResult; stdcall;
    function SetRoot(pszPath: LPCWSTR): HResult; stdcall;
    function MouseActivate(const point: TPoint): HResult; stdcall;
    function MouseSelect(const point: TPoint): HResult; stdcall;
    function ChapterPlayAutoStop(ulTitle, ulChapter, ulChaptersToPlay: ULONG): HResult; stdcall;
  end;

  IDvdInfo = interface(IUnknown)
    ['{A70EFE60-E2A3-11D0-A9BE-00AA0061BE93}']
    function GetCurrentDomain(var pDomain: TDVD_Domain): HResult; stdcall;
    function GetCurrentLocation(var pLocation: TDVD_Playback_Location): HResult; stdcall;
    function GetTotalTitleTime(var pTotalTime: ULONG): HResult; stdcall;
    function GetCurrentButton(var pnButtonsAvailable, pnCurrentButton: ULONG): HResult; stdcall;
    function GetCurrentAngle(var pnAnglesAvailable, pnCurrentAngle: ULONG): HResult; stdcall;
    function GetCurrentAudio(var pnStreamsAvailable, pnCurrentStream: ULONG): HResult; stdcall;
    function GetCurrentSubpicture(var pnStreamsAvailable, pnCurrentStream: ULONG;
        pIsDisabled: BOOL): HResult; stdcall;
    function GetCurrentUOPS(var pUOP: TVALID_UOP_SOMTHING_OR_OTHER): HResult; stdcall;
    function GetAllSPRMs(var pRegisterArray: TSPRMArray): HResult; stdcall;
    function GetAllGPRMs(var pRegisterArray: TGPRMArray): HResult; stdcall;
    function GetAudioLanguage(nStream: ULONG; var pLanguage: LCID): HResult; stdcall;
    function GetSubpictureLanguage(nStream: ULONG; var pLanguage: LCID): HResult; stdcall;
    function GetTitleAttributes(nTitle: ULONG; var pATR: TDVD_ATR): HResult; stdcall;
    function GetVMGAttributes(var pATR: TDVD_ATR): HResult; stdcall;
    function GetCurrentVideoAttributes(var pATR: TDVD_VideoATR): HResult; stdcall;
    function GetCurrentAudioAttributes(var pATR: TDVD_AudioATR): HResult; stdcall;
    function GetCurrentSubpictureAttributes(var pATR: TDVD_SubpictureATR): HResult; stdcall;
    function GetCurrentVolumeInfo(var pNumOfVol, pThisVolNum: ULONG;
        var pSide: TDVD_Disc_Side; var pNumOfTitles: ULONG): HResult; stdcall;
    function GetDVDTextInfo(var pTextManager; cbBufSize: ULONG;
        var pcbActualSize: ULONG): HResult; stdcall;
    function GetPlayerParentalLevel(var pParentalLevel, pCountryCode: ULONG): HResult; stdcall;
    function GetNumberOfChapters(ulTitle: ULONG; var pNumberOfChapters: ULONG): HResult; stdcall;
    function GetTitleParentalLevels(ulTitle: ULONG; var pParentalLevels: ULONG): HResult; stdcall;
    function GetRoot(pRoot: PWCHAR; cbBufSize: ULONG; var pcbActualSize: ULONG): HResult; stdcall;
  end;

const
  M_DVD_HWDEC_PREFER     = $1;
  M_DVD_HWDEC_ONLY       = $2;
  M_DVD_SWDEC_PREFER     = $4;
  M_DVD_SWDEC_ONLY       = $8;
  M_DVD_NOVPE            = $100;

  AM_DVD_STREAM_VIDEO    = $1;
  AM_DVD_STREAM_AUDIO    = $2;
  AM_DVD_STREAM_SUBPIC   = $4;

type
  TAM_DVD_RenderStatus = record
    hrVPEStatus: HResult;
    bDvdVolInvalid: BOOL;
    bDvdVolUnknown: BOOL;
    bNoLine21In: BOOL;
    bNoLine21Out: BOOL;
    iNumStreams: Integer;
    iNumStreamsFailed: Integer;
    dwFailedStreamsFlag: DWORD;
  end;

  IDvdGraphBuilder = interface(IUnknown)
    ['{FCC152B6-F372-11d0-8E00-00C04FD7C08B}']
    function GetFiltergraph(out ppGB: IGraphBuilder): HResult; stdcall;
    function GetDvdInterface(const riid: TGUID; out ppvIF): HResult; stdcall;
    function RenderDvdVideoVolume(lpcwszPathName: LPCWSTR; dwFlags: DWORD;
        var pStatus: TAM_DVD_RenderStatus): HResult; stdcall;
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       mmstream.h
 *
 ***************************************************************************)

const
  IID_IMultiMediaStream: TGUID = '{B502D1BC-9A57-11d0-8FDE-00C04FD9189D}';
  IID_IMediaStream: TGUID = '{B502D1BD-9A57-11d0-8FDE-00C04FD9189D}';
  IID_IStreamSample: TGUID = '{B502D1BE-9A57-11d0-8FDE-00C04FD9189D}';

const
  MS_S_PENDING                = $80040401;
  MS_S_NOUPDATE               = $80040402;
  MS_S_ENDOFSTREAM            = $80040403;
  MS_E_SAMPLEALLOC            = $00040001;
  MS_E_PURPOSEID              = $00040002;
  MS_E_NOSTREAM               = $00040003;
  MS_E_NOSEEKING              = $00040004;
  MS_E_INCOMPATIBLE           = $00040005;
  MS_E_BUSY                   = $00040006;
  MS_E_NOTINIT                = $00040007;
  MS_E_SOURCEALREADYDEFINED   = $00040008;
  MS_E_INVALIDSTREAMTYPE      = $00040009;
  MS_E_NOTRUNNING             = $0004000A;

  MSPID_PrimaryVideo: TGUID = (D1:$A35FF56A;D2:$9FDA;D3:$11D0;D4:($8F,$DF,$00,$C0,$4F,$D9,$18,$9D));
  MSPID_PrimaryAudio: TGUID = (D1:$A35FF56B;D2:$9FDA;D3:$11D0;D4:($8F,$DF,$00,$C0,$4F,$D9,$18,$9D));

type
  PAPCFUNC = procedure(dwParam: DWORD); stdcall;

  TStream_Time = LONGLONG;

  MSPID = TGUID;

  TStream_Type = (
    STREAMTYPE_READ,
    STREAMTYPE_WRITE,
    STREAMTYPE_TRANSFORM
  );

  TStream_State = (
    STREAMSTATE_STOP,
    STREAMSTATE_RUN
  );

  TCompletion_Status_Flags = (
    COMPSTAT_INVALID_0,
    COMPSTAT_NOUPDATEOK,
    COMPSTAT_WAIT,
    COMPSTAT_INVALID_3,
    COMPSTAT_ABORT
  );

const
  MMSSF_HASCLOCK        = $1;
  MMSSF_SUPPORTSEEK     = $2;
  MMSSF_ASYNCHRONOUS    = $4;

  SSUPDATE_ASYNC = $1;
  SSUPDATE_CONTINUOUS = $2;

type
  IMediaStream = interface;
  IStreamSample = interface;

  IMultiMediaStream = interface(IUnknown)
    ['{B502D1BC-9A57-11d0-8FDE-00C04FD9189D}']
    function GetInformation(var pdwFlags: DWORD; var pStreamType: TStream_Type): HResult; stdcall;
    function GetMediaStream(const idPurpose: MSPID;
        out ppMediaStream: IMediaStream): HResult; stdcall;
    function EnumMediaStreams(Index: Longint; out ppMediaStream: IMediaStream): HResult; stdcall;
    function GetState(var pCurrentState: TStream_State): HResult; stdcall;
    function SetState(NewState: TStream_State): HResult; stdcall;
    function GetTime(var pCurrentTime: TStream_Time): HResult; stdcall;
    function GetDuration(var pDuration: TStream_Time): HResult; stdcall;
    function Seek(SeekTime: TStream_Time): HResult; stdcall;
    function GetEndOfStreamEventHandle(var phEOS: THandle): HResult; stdcall;
  end;

  IMediaStream = interface(IUnknown)
    ['{B502D1BD-9A57-11d0-8FDE-00C04FD9189D}']
    function GetMultiMediaStream(out ppMultiMediaStream: IMultiMediaStream): HResult; stdcall;
    function GetInformation(var pPurposeId: MSPID; var pType: TStream_Type): HResult; stdcall;
    function SetSameFormat(pStreamThatHasDesiredFormat: IMediaStream;
        dwFlags: DWORD): HResult; stdcall;
    function AllocateSample(dwFlags: DWORD; out ppSample: IStreamSample): HResult; stdcall;
    function CreateSharedSample(pExistingSample: IStreamSample; dwFlags: DWORD;
        out ppNewSample: IStreamSample): HResult; stdcall;
    function SendEndOfStream(dwFlags: DWORD): HResult; stdcall;
  end;

  IStreamSample = interface(IUnknown)
    ['{B502D1BE-9A57-11d0-8FDE-00C04FD9189D}']
    function GetMediaStream(out ppMediaStream: IMediaStream): HResult; stdcall;
    function GetSampleTimes(var pStartTime, pEndTime,
        pCurrentTime: TStream_Time): HResult; stdcall;
    function SetSampleTimes(var pStartTime, pEndTime: TStream_Time): HResult; stdcall;
    function Update(dwFlags: DWORD; hEvent: THandle; pfnAPC: PAPCFUNC;
        dwAPCData: DWORD): HResult; stdcall;
    function CompletionStatus(dwFlags: DWORD; dwMilliseconds: DWORD): HResult; stdcall;
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       amstream.h
 *
 ***************************************************************************)

const
  IID_IDirectShowStream: TGUID = '{7DB01C96-C0C3-11D0-8FF1-00C04FD9189D}';
  IID_IAMMultiMediaStream: TGUID = '{BEBE595C-9A6F-11D0-8FDE-00C04FD9189D}';
  IID_IAMMediaStream: TGUID = '{BEBE595D-9A6F-11D0-8FDE-00C04FD9189D}';
  IID_IMediaStreamFilter: TGUID = '{BEBE595E-9A6F-11D0-8FDE-00C04FD9189D}';
  IID_IDirectDrawMediaSampleAllocator: TGUID = '{AB6B4AFC-F6E4-11D0-900D-00C04FD9189D}';
  IID_IDirectDrawMediaSample: TGUID = '{AB6B4AFE-F6E4-11D0-900D-00C04FD9189D}';
  IID_IAMMediaTypeStream: TGUID = '{AB6B4AFA-F6E4-11D0-900D-00C04FD9189D}';
  IID_IAMMediaTypeSample: TGUID = '{AB6B4AFB-F6E4-11D0-900D-00C04FD9189D}';

const
  AMMSF_NOGRAPHTHREAD = $1;

  AMMSF_ADDDEFAULTRENDERER = $1;
  AMMSF_CREATEPEER = $2;

  AMMSF_RENDERTYPEMASK  = $3;
  AMMSF_RENDERTOEXISTING        = 0;
  AMMSF_RENDERALLSTREAMS        = $1;
  AMMSF_NORENDER        = $2;
  AMMSF_NOCLOCK = $4;
  AMMSF_RUN     = $8;

type
  TOutput_State = (
    Disabled,
    ReadData,
    RenderData
  );

  IDirectShowStream = interface(IDispatch)
    ['{7DB01C96-C0C3-11D0-8FF1-00C04FD9189D}']
    function get_FileName(var pVal: TBSTR): HResult; stdcall;
    function put_FileName(newVal: TBSTR): HResult; stdcall;
    function get_Video(var pVal: TOutput_State): HResult; stdcall;
    function put_Video(newVal: TOutput_State): HResult; stdcall;
    function get_Audio(var pVal: TOutput_State): HResult; stdcall;
    function put_Audio(newVal: TOutput_State): HResult; stdcall;
  end;

  IMediaStreamFilter = interface;

  IAMMultiMediaStream = interface(IMultiMediaStream)
    ['{BEBE595C-9A6F-11D0-8FDE-00C04FD9189D}']
    function Initialize(StreamType: TStream_Type; dwFlags: DWORD;
        pFilterGraph: IGraphBuilder): HResult; stdcall;
    function GetFilterGraph(out ppGraphBuilder: IGraphBuilder): HResult; stdcall;
    function GetFilter(out ppFilter: IMediaStreamFilter): HResult; stdcall;
    function AddMediaStream(pStreamObject: IUnknown; const PurposeId: MSPID;
        dwFlags: DWORD; out ppNewStream: IMediaStream): HResult; stdcall;
    function OpenFile(pszFileName: LPCWSTR; dwFlags: DWORD): HResult; stdcall;
    function OpenMoniker(pCtx: IBindCtx; pMoniker: IMoniker; dwFlags: DWORD): HResult; stdcall;
    function Render(dwFlags: DWORD): HResult; stdcall;
  end;

  IAMMediaStream = interface(IMediaStream)
    ['{BEBE595D-9A6F-11D0-8FDE-00C04FD9189D}']
    function Initialize(pSourceObject: IUnknown; dwFlags: DWORD;
        const PurposeId: MSPID; StreamType: TStream_Type): HResult; stdcall;
    function SetState(State: TFilter_State): HResult; stdcall;
    function JoinAMMultiMediaStream(pAMMultiMediaStream: IAMMultiMediaStream): HResult; stdcall;
    function JoinFilter(pMediaStreamFilter: IMediaStreamFilter): HResult; stdcall;
    function JoinFilterGraph(pFilterGraph: IFilterGraph): HResult; stdcall;
  end;

  IMediaStreamFilter = interface(IBaseFilter)
    ['{BEBE595E-9A6F-11D0-8FDE-00C04FD9189D}']
    function AddMediaStream(pAMMediaStream: IAMMediaStream): HResult; stdcall;
    function GetMediaStream(const idPurpose: MSPID;
        out ppMediaStream: IMediaStream): HResult; stdcall;
    function EnumMediaStreams(Index: Longint; out ppMediaStream: IMediaStream): HResult; stdcall;
    function SupportSeeking(bRenderer: BOOL): HResult; stdcall;
    function ReferenceTimeToStreamTime(var pTime: TReference_Time): HResult; stdcall;
    function GetCurrentStreamTime(var pCurrentStreamTime: TReference_Time): HResult; stdcall;
    function WaitUntil(WaitStreamTime: TReference_Time): HResult; stdcall;
    function Flush(bCancelEOS: BOOL): HResult; stdcall;
    function EndOfStream: HResult; stdcall;
  end;

  IDirectDrawMediaSampleAllocator = interface(IUnknown)
    ['{AB6B4AFC-F6E4-11D0-900D-00C04FD9189D}']
    function GetDirectDraw(out ppDirectDraw: IDirectDraw): HResult; stdcall;
  end;

  IDirectDrawMediaSample = interface(IUnknown)
    ['{AB6B4AFE-F6E4-11D0-900D-00C04FD9189D}']
    function GetSurfaceAndReleaseLock(out ppDirectDrawSurface: IDirectDrawSurface;
        var pRect: TRect): HResult; stdcall;
    function LockMediaSamplePointer: HResult; stdcall;
  end;

  IAMMediaTypeSample = interface;

  IAMMediaTypeStream = interface(IMediaStream)
    ['{AB6B4AFA-F6E4-11D0-900D-00C04FD9189D}']
    function GetFormat(out pMediaType: TAM_Media_Type; dwFlags: DWORD): HResult; stdcall;
    function SetFormat(const pMediaType: TAM_Media_Type; dwFlags: DWORD): HResult; stdcall;
    function CreateSample(lSampleSize: Longint; pbBuffer: Pointer;
        dwFlags: DWORD; pUnkOuter: IUnknown; out ppAMMediaTypeSample: IAMMediaTypeSample): HResult; stdcall;
    function GetStreamAllocatorRequirements(var pProps: TAllocator_Properties): HResult; stdcall;
    function SetStreamAllocatorRequirements(const pProps: TAllocator_Properties): HResult; stdcall;
  end;

  IAMMediaTypeSample = interface(IStreamSample)
    ['{AB6B4AFB-F6E4-11D0-900D-00C04FD9189D}']
    function SetPointer(pBuffer: Pointer; lSize: Longint): HResult; stdcall;
    function GetPointer(var ppBuffer: Pointer): HResult; stdcall;
    function GetSize: Longint; stdcall;
    function GetTime(var pTimeStart, pTimeEnd: TReference_Time): HResult; stdcall;
    function SetTime(var pTimeStart, pTimeEnd: TReference_Time): HResult; stdcall;
    function IsSyncPoint: HResult; stdcall;
    function SetSyncPoint(bIsSyncPoint: BOOL): HResult; stdcall;
    function IsPreroll: HResult; stdcall;
    function SetPreroll(bIsPreroll: BOOL): HResult; stdcall;
    function GetActualDataLength: Longint; stdcall;
    function SetActualDataLength(l: Longint): HResult; stdcall;
    function GetMediaType(var ppMediaType: PAM_Media_Type): HResult; stdcall;
    function SetMediaType(const pMediaType: TAM_Media_Type): HResult; stdcall;
    function IsDiscontinuity: HResult; stdcall;
    function SetDiscontinuity(bDiscontinuity: BOOL): HResult; stdcall;
    function GetMediaTime(var pTimeStart, pTimeEnd: LONGLONG): HResult; stdcall;
    function SetMediaTime(var pTimeStart, pTimeEnd: LONGLONG): HResult; stdcall;
  end;

const
{
EXTERN_C const IID LIBID_DirectShowStreamLib;

EXTERN_C const CLSID CLSID_AMMultiMediaStream;
}
  CLSID_AMMultiMediaStream: TGUID = '{49C47CE5-9BA4-11D0-8212-00C04FC32C45}';

  CLSID_AMDirectDrawStream: TGUID = (D1:$49C47CE4;D2:$9BA4;D3:$11D0;D4:($82,$12,$00,$C0,$4F,$C3,$2C,$45));
  CLSID_AMAudioStream: TGUID = (D1:$8496E040;D2:$AF4C;D3:$11D0;D4:($82,$12,$00,$C0,$4F,$C3,$2C,$45));
  CLSID_AMAudioData: TGUID = (D1:$F2468580;D2:$AF8A;D3:$11D0;D4:($82,$12,$00,$C0,$4F,$C3,$2C,$45));
  CLSID_AMMediaTypeStream: TGUID = (D1:$CF0F2F7C;D2:$F7BF;D3:$11D0;D4:($90,$0D,$00,$C0,$4F,$D9,$18,$9D));

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       ddstream.h
 *
 ***************************************************************************)

const
  DDSFF_PROGRESSIVERENDER = $1;

  IID_IDirectDrawMediaStream: TGUID = '{F4104FCE-9A70-11d0-8FDE-00C04FD9189D}';
  IID_IDirectDrawStreamSample: TGUID = '{F4104FCF-9A70-11d0-8FDE-00C04FD9189D}';

type
  IDirectDrawStreamSample = interface;

  IDirectDrawMediaStream = interface(IMediaStream)
    ['{F4104FCE-9A70-11d0-8FDE-00C04FD9189D}']
    function GetFormat(var pDDSDCurrent: DDSURFACEDESC;
        out ppDirectDrawPalette: IDirectDrawPalette;
        var pDDSDDesired: DDSURFACEDESC; var pdwFlags: DWORD): HResult; stdcall;
    function SetFormat(const pDDSurfaceDesc: DDSURFACEDESC;
        pDirectDrawPalette: IDirectDrawPalette): HResult; stdcall;
    function GetDirectDraw(out ppDirectDraw: IDirectDraw): HResult; stdcall;
    function SetDirectDraw(pDirectDraw: IDirectDraw): HResult; stdcall;
    function CreateSample(pSurface: IDirectDrawSurface; const pRect: TRect;
        dwFlags: DWORD; out ppSample: IDirectDrawStreamSample): HResult; stdcall;
    function GetTimePerFrame(var pFrameTime: TStream_Time): HResult; stdcall;
  end;

  IDirectDrawStreamSample = interface(IStreamSample)
    ['{F4104FCF-9A70-11d0-8FDE-00C04FD9189D}']
    function GetSurface(out ppDirectDrawSurface: IDirectDrawSurface;
        var pRect: TRect): HResult; stdcall;
    function SetRect(const pRect: TRect): HResult; stdcall;
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       austream.h
 *
 ***************************************************************************)

const
  IID_IAudioMediaStream: TGUID = '{F7537560-A3BE-11D0-8212-00C04FC32C45}';
  IID_IAudioStreamSample: TGUID = '{345FEE00-ABA5-11D0-8212-00C04FC32C45}';
  IID_IMemoryData: TGUID = '{327FC560-AF60-11D0-8212-00C04FC32C45}';
  IID_IAudioData: TGUID = '{54C719C0-AF60-11D0-8212-00C04FC32C45}';

type
  IAudioStreamSample = interface;
  IAudioData = interface;

  IAudioMediaStream = interface(IMediaStream)
    ['{F7537560-A3BE-11D0-8212-00C04FC32C45}']
    function GetFormat(var pWaveFormatCurrent: TWaveFormatEx): HResult; stdcall;
    function SetFormat(const lpWaveFormat: TWaveFormatEx): HResult; stdcall;
    function CreateSample(pAudioData: IAudioData; dwFlags: DWORD;
        out ppSample: IAudioStreamSample): HResult; stdcall;
  end;

  IAudioStreamSample = interface(IStreamSample)
    ['{345FEE00-ABA5-11D0-8212-00C04FC32C45}']
    function GetAudioData(out ppAudio: IAudioData): HResult; stdcall;
  end;

  IMemoryData = interface(IUnknown)
    ['{327FC560-AF60-11D0-8212-00C04FC32C45}']
    function SetBuffer(cbSize: DWORD; pbData: Pointer; dwFlags: DWORD): HResult; stdcall;
    function GetInfo(var pdwLength: DWORD; var ppbData: Pointer;
        var pcbActualData: DWORD): HResult; stdcall;
    function SetActual(cbDataValid: DWORD): HResult; stdcall;
  end;

  IAudioData = interface(IMemoryData)
    ['{54C719C0-AF60-11D0-8212-00C04FC32C45}']
    function GetFormat(var pWaveFormatCurrent: TWaveFormatEx): HResult; stdcall;
    function SetFormat(const lpWaveFormat: TWaveFormatEx): HResult; stdcall;
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       mpconfig.h
 *
 ***************************************************************************)

const
  IID_IMixerPinConfig: TGUID = (D1:$593CDDE1;D2:$0759;D3:$11D1;D4:($9E,$69,$00,$C0,$4F,$D7,$C1,$5B));

type
  TAM_Aspect_Ratio_Mode = (
    AM_ARMODE_STRETCHED,        // don't do any aspect ratio correction
    AM_ARMODE_LETTER_BOX,       // letter box the video, paint background color in the excess region
    AM_ARMODE_CROP,             // crop the video to the right aspect ratio
    AM_ARMODE_STRETCHED_AS_PRIMARY
  );

  IMixerPinConfig = interface(IUnknown)
    ['{593CDDE1-0759-11D1-9E69-00C04FD7C15B}']
    function SetRelativePosition(dwLeft, dwTop, dwRight, dwBottom: DWORD): HResult; stdcall;
    function GetRelativePosition(var dwLeft, dwTop, dwRight, dwBottom: DWORD): HResult; stdcall;
    function SetZOrder(dwZOrder: DWORD): HResult; stdcall;
    function GetZOrder(var dwZOrder: DWORD): HResult; stdcall;
    function SetColorKey(const pColorKey: TColorKey): HResult; stdcall;
    function GetColorKey(var pColorKey: TColorKey; var pColor: DWORD): HResult; stdcall;
    function SetBlendingParameter(dwBlendingParameter: DWORD): HResult; stdcall;
    function GetBlendingParameter(var dwBlendingParameter: DWORD): HResult; stdcall;
    function SetAspectRatioMode(amAspectRatioMode: TAM_Aspect_Ratio_Mode): HResult; stdcall;
    function GetAspectRatioMode(var amAspectRatioMode: TAM_Aspect_Ratio_Mode): HResult; stdcall;
    function SetStreamTransparent(bStreamTransparent: BOOL): HResult; stdcall;
    function GetStreamTransparent(var bStreamTransparent: BOOL): HResult; stdcall;
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       control.h
 *
 ***************************************************************************)

const
  LIBID_QuartzTypeLib: TGUID = (D1:$56A868B0;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));

  IID_IAMCollection: TGUID = (D1:$56A868B9;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  IID_IMediaControl: TGUID = (D1:$56A868B1;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  IID_IMediaEvent: TGUID = (D1:$56A868B6;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  IID_IMediaEventEx: TGUID = (D1:$56A868C0;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  IID_IMediaPosition: TGUID = (D1:$56A868B2;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  IID_IBasicAudio: TGUID = (D1:$56A868B3;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  IID_IVideoWindow: TGUID = (D1:$56A868B4;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  IID_IBasicVideo: TGUID = (D1:$56A868B5;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  IID_IDeferredCommand: TGUID = (D1:$56A868B8;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  IID_IQueueCommand: TGUID = (D1:$56A868B7;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));

  CLSID_FilgraphManager: TGUID = (D1:$E436EBB3;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));

  IID_IFilterInfo: TGUID = (D1:$56A868BA;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  IID_IRegFilterInfo: TGUID = (D1:$56A868BB;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  IID_IMediaTypeInfo: TGUID = (D1:$56A868BC;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  IID_IPinInfo: TGUID = (D1:$56A868BD;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));

type
  OAEVENT = Longint;
  OAHWND = Longint;
  OAFilterState = Longint;

(* Definition of interface: IAMCollection *)
  IAMCollection = interface(IDispatch)
    ['{56A868B9-0AD4-11CE-B03A-0020AF0BA770}']
    (* IAMCollection methods *)
    function get_Count(var plCount: Longint): HResult; stdcall;
    function Item(lItem: Longint; out ppUnk: IUnknown): HResult; stdcall;
    function get__NewEnum(out ppUnk: IUnknown): HResult; stdcall;
  end;

(* Definition of interface: IMediaControl *)
  IMediaControl = interface(IDispatch)
    ['{56A868B1-0AD4-11CE-B03A-0020AF0BA770}']
    (* IMediaControl methods *)
    function Run: HResult; stdcall;
    function Pause: HResult; stdcall;
    function Stop: HResult; stdcall;
    function GetState(msTimeout: Longint; var pfs: OAFilterState): HResult; stdcall;
    function RenderFile(strFilename: TBSTR): HResult; stdcall;
    function AddSourceFilter(strFilename: TBSTR; ppUnk: IDispatch): HResult; stdcall;
    function get_FilterCollection(out ppUnk: IDispatch): HResult; stdcall;
    function get_RegFilterCollection(out ppUnk: IDispatch): HResult; stdcall;
    function StopWhenReady: HResult; stdcall;
  end;
                                 
(* Definition of interface: IMediaEvent *)
  IMediaEvent = interface(IDispatch)
    ['{56A868B6-0AD4-11CE-B03A-0020AF0BA770}']
    (* IMediaEvent methods *)
    function GetEventHandle(var hEvent: OAEVENT): HResult; stdcall;
    function GetEvent(var lEventCode: Longint; var lParam1, lParam2: Longint;
        msTimeout: Longint): HResult; stdcall;
    function WaitForCompletion(msTimeout: Longint; var pEvCode: Longint): HResult; stdcall;
    function CancelDefaultHandling(lEvCode: Longint): HResult; stdcall;
    function RestoreDefaultHandling(lEvCode: Longint): HResult; stdcall;
    function FreeEventParams(lEvCode: Longint; lParam1, lParam2: Longint): HResult; stdcall;
  end;

(* Definition of interface: IMediaEventEx *)
  IMediaEventEx = interface(IMediaEvent)
    ['{56A868C0-0AD4-11CE-B03A-0020AF0BA770}']
    (* IMediaEventEx methods *)
    function SetNotifyWindow(hwnd: OAHWND; lMsg: Longint;
        lInstanceData: Longint): HResult; stdcall;
    function SetNotifyFlags(lNoNotifyFlags: Longint): HResult; stdcall;
    function GetNotifyFlags(var lplNoNotifyFlags: Longint): HResult; stdcall;
  end;

(* Definition of interface: IMediaPosition *)
  IMediaPosition = interface(IDispatch)
    ['{56A868B2-0AD4-11CE-B03A-0020AF0BA770}']
    (* IMediaPosition methods *)
    function get_Duration(var plength: TRefTime): HResult; stdcall;
    function put_CurrentPosition(llTime: TRefTime): HResult; stdcall;
    function get_CurrentPosition(var pllTime: TRefTime): HResult; stdcall;
    function get_StopTime(var pllTime: TRefTime): HResult; stdcall;
    function put_StopTime(llTime: TRefTime): HResult; stdcall;
    function get_PrerollTime(var pllTime: TRefTime): HResult; stdcall;
    function put_PrerollTime(llTime: TRefTime): HResult; stdcall;
    function put_Rate(dRate: double): HResult; stdcall;
    function get_Rate(var pdRate: double): HResult; stdcall;
    function CanSeekForward(var pCanSeekForward: Longint): HResult; stdcall;
    function CanSeekBackward(var pCanSeekBackward: Longint): HResult; stdcall;
  end;

(* Definition of interface: IBasicAudio *)
  IBasicAudio = interface(IDispatch)
    ['{56A868B3-0AD4-11CE-B03A-0020AF0BA770}']
    (* IBasicAudio methods *)
    function put_Volume(lVolume: Longint): HResult; stdcall;
    function get_Volume(var plVolume: Longint): HResult; stdcall;
    function put_Balance(lBalance: Longint): HResult; stdcall;
    function get_Balance(var plBalance: Longint): HResult; stdcall;
  end;

(* Definition of interface: IVideoWindow *)
  IVideoWindow = interface(IDispatch)
    ['{56A868B4-0AD4-11CE-B03A-0020AF0BA770}']
    (* IVideoWindow methods *)
    function put_Caption(strCaption: TBSTR): HResult; stdcall;
    function get_Caption(var strCaption: TBSTR): HResult; stdcall;
    function put_WindowStyle(WindowStyle: Longint): HResult; stdcall;
    function get_WindowStyle(var WindowStyle: Longint): HResult; stdcall;
    function put_WindowStyleEx(WindowStyleEx: Longint): HResult; stdcall;
    function get_WindowStyleEx(var WindowStyleEx: Longint): HResult; stdcall;
    function put_AutoShow(AutoShow: LongBool): HResult; stdcall;
    function get_AutoShow(var AutoShow: LongBool): HResult; stdcall;
    function put_WindowState(WindowState: Longint): HResult; stdcall;
    function get_WindowState(var WindowState: Longint): HResult; stdcall;
    function put_BackgroundPalette(BackgroundPalette: Longint): HResult; stdcall;
    function get_BackgroundPalette(var pBackgroundPalette: Longint): HResult; stdcall;
    function put_Visible(Visible: LongBool): HResult; stdcall;
    function get_Visible(var pVisible: LongBool): HResult; stdcall;
    function put_Left(Left: Longint): HResult; stdcall;
    function get_Left(var pLeft: Longint): HResult; stdcall;
    function put_Width(Width: Longint): HResult; stdcall;
    function get_Width(var pWidth: Longint): HResult; stdcall;
    function put_Top(Top: Longint): HResult; stdcall;
    function get_Top(var pTop: Longint): HResult; stdcall;
    function put_Height(Height: Longint): HResult; stdcall;
    function get_Height(var pHeight: Longint): HResult; stdcall;
    function put_Owner(Owner: OAHWND): HResult; stdcall;
    function get_Owner(var Owner: OAHWND): HResult; stdcall;
    function put_MessageDrain(Drain: OAHWND): HResult; stdcall;
    function get_MessageDrain(var Drain: OAHWND): HResult; stdcall;
    function get_BorderColor(var Color: Longint): HResult; stdcall;
    function put_BorderColor(Color: Longint): HResult; stdcall;
    function get_FullScreenMode(var FullScreenMode: LongBool): HResult; stdcall;
    function put_FullScreenMode(FullScreenMode: LongBool): HResult; stdcall;
    function SetWindowForeground(Focus: Longint): HResult; stdcall;
    function NotifyOwnerMessage(hwnd: Longint; uMsg, wParam, lParam: Longint): HResult; stdcall;
    function SetWindowPosition(Left, Top, Width, Height: Longint): HResult; stdcall;
    function GetWindowPosition(var pLeft, pTop, pWidth, pHeight: Longint): HResult; stdcall;
    function GetMinIdealImageSize(var pWidth, pHeight: Longint): HResult; stdcall;
    function GetMaxIdealImageSize(var pWidth, pHeight: Longint): HResult; stdcall;
    function GetRestorePosition(var pLeft, pTop, pWidth, pHeight: Longint): HResult; stdcall;
    function HideCursor(HideCursor: LongBool): HResult; stdcall;
    function IsCursorHidden(var CursorHidden: LongBool): HResult; stdcall;
  end;

(* Definition of interface: IBasicVideo *)
  IBasicVideo = interface(IDispatch)
    ['{56A868B5-0AD4-11CE-B03A-0020AF0BA770}']
    (* IBasicVideo methods *)
    function get_AvgTimePerFrame(var pAvgTimePerFrame: TRefTime): HResult; stdcall;
    function get_BitRate(var pBitRate: Longint): HResult; stdcall;
    function get_BitErrorRate(var pBitErrorRate: Longint): HResult; stdcall;
    function get_VideoWidth(var pVideoWidth: Longint): HResult; stdcall;
    function get_VideoHeight(var pVideoHeight: Longint): HResult; stdcall;
    function put_SourceLeft(SourceLeft: Longint): HResult; stdcall;
    function get_SourceLeft(var pSourceLeft: Longint): HResult; stdcall;
    function put_SourceWidth(SourceWidth: Longint): HResult; stdcall;
    function get_SourceWidth(var pSourceWidth: Longint): HResult; stdcall;
    function put_SourceTop(SourceTop: Longint): HResult; stdcall;
    function get_SourceTop(var pSourceTop: Longint): HResult; stdcall;
    function put_SourceHeight(SourceHeight: Longint): HResult; stdcall;
    function get_SourceHeight(var pSourceHeight: Longint): HResult; stdcall;
    function put_DestinationLeft(DestinationLeft: Longint): HResult; stdcall;
    function get_DestinationLeft(var pDestinationLeft: Longint): HResult; stdcall;
    function put_DestinationWidth(DestinationWidth: Longint): HResult; stdcall;
    function get_DestinationWidth(var pDestinationWidth: Longint): HResult; stdcall;
    function put_DestinationTop(DestinationTop: Longint): HResult; stdcall;
    function get_DestinationTop(var pDestinationTop: Longint): HResult; stdcall;
    function put_DestinationHeight(DestinationHeight: Longint): HResult; stdcall;
    function get_DestinationHeight(var pDestinationHeight: Longint): HResult; stdcall;
    function SetSourcePosition(Left, Top, Width, Height: Longint): HResult; stdcall;
    function GetSourcePosition(var pLeft, pTop, pWidth, pHeight: Longint): HResult; stdcall;
    function SetDefaultSourcePosition: HResult; stdcall;
    function SetDestinationPosition(Left, Top, Width, Height: Longint): HResult; stdcall;
    function GetDestinationPosition(var pLeft, pTop, pWidth, pHeight: Longint): HResult; stdcall;
    function SetDefaultDestinationPosition: HResult; stdcall;
    function GetVideoSize(var pWidth, Height: Longint): HResult; stdcall;
    function GetVideoPaletteEntries(StartIndex, Entries: Longint;
        var pRetrieved: Longint; var pPalette): HResult; stdcall;
    function GetCurrentImage(var BufferSize: Longint; var pDIBImage): HResult; stdcall;
    function IsUsingDefaultSource: HResult; stdcall;
    function IsUsingDefaultDestination: HResult; stdcall;
  end;

(* Definition of interface: IDeferredCommand *)
  IDeferredCommand = interface(IDispatch)
    ['{56A868B8-0AD4-11CE-B03A-0020AF0BA770}']
    (* IDeferredCommand methods *)
    function Cancel: HResult; stdcall;
    function Confidence(var pConfidence: Longint): HResult; stdcall;
    function Postpone(newtime: TRefTime): HResult; stdcall;
    function GetHResult(var phrResult: HResult): HResult; stdcall;
  end;

(* Definition of interface: IQueueCommand *)
  IQueueCommand = interface(IUnknown)
    ['{56A868B7-0AD4-11CE-B03A-0020AF0BA770}']
    (* IQueueCommand methods *)
    function InvokeAtStreamTime(out pCmd: IDeferredCommand; time: TRefTime;
        const iid: TGUID; dispidMethod: Longint; wFlags: SmallInt;
        cArgs: Longint; const pDispParams: Variant; var pvarResult: Variant;
        var puArgErr: SmallInt):  HResult; stdcall;
    function InvokeAtPresentationTime(out pCmd: IDeferredCommand;
        time: TRefTime; const iid: TGUID; dispidMethod: Longint;
        wFlags: SmallInt; cArgs: Longint; const pDispParams: Variant;
        var pvarResult: Variant; var puArgErr: SmallInt): HResult; stdcall;
  end;

(* Definition of interface: IFilterInfo *)
  IFilterInfo = interface(IDispatch)
    ['{56A868BA-0AD4-11CE-B03A-0020AF0BA770}']
    (* IFilterInfo methods *)
    function FindPin(strPinID: TBSTR; out ppUnk: IDispatch): HResult; stdcall;
    function get_Name(var strName: TBSTR): HResult; stdcall;
    function get_VendorInfo(var strVendorInfo: TBSTR): HResult; stdcall;
    function get_Filter(out ppUnk: IUnknown): HResult; stdcall;
    function get_Pins(out ppUnk: IDispatch): HResult; stdcall;
    function get_IsFileSource(var pbIsSource: LongBool): HResult; stdcall;
    function get_Filename(var pstrFilename: TBSTR): HResult; stdcall;
    function put_Filename(strFilename: TBSTR): HResult; stdcall;
  end;

(* Definition of interface: IRegFilterInfo *)
  IRegFilterInfo = interface(IDispatch)
    ['{56A868BB-0AD4-11CE-B03A-0020AF0BA770}']
    (* IRegFilterInfo methods *)
    function get_Name(var strName: TBSTR): HResult; stdcall;
    function Filter(out ppUnk: IDispatch): HResult; stdcall;
  end;

(* Definition of interface: IMediaTypeInfo *)
  IMediaTypeInfo = interface(IDispatch)
    ['{56A868BC-0AD4-11CE-B03A-0020AF0BA770}']
    (* IMediaTypeInfo methods *)
    function get_Type(var strType: TBSTR): HResult; stdcall;
    function get_Subtype(var strType: TBSTR): HResult; stdcall;
  end;

(* Definition of interface: IPinInfo *)
  IPinInfo = interface(IDispatch)
    ['{56A868BD-0AD4-11CE-B03A-0020AF0BA770}']
    (* IPinInfo methods *)
    function get_Pin(out ppUnk: IUnknown): HResult; stdcall;
    function get_ConnectedTo(out ppUnk: IDispatch): HResult; stdcall;
    function get_ConnectionMediaType(out ppUnk: IDispatch): HResult; stdcall;
    function get_FilterInfo(out ppUnk: IDispatch): HResult; stdcall;
    function get_Name(var ppUnk: TBSTR): HResult; stdcall;
    function get_Direction(var ppDirection: Longint): HResult; stdcall;
    function get_PinID(var strPinID: TBSTR): HResult; stdcall;
    function get_MediaTypes(out ppUnk: IDispatch): HResult; stdcall;
    function Connect(pPin: IUnknown): HResult; stdcall;
    function ConnectDirect(pPin: IUnknown): HResult; stdcall;
    function ConnectWithType(pPin: IUnknown; pMediaType: IDispatch): HResult; stdcall;
    function Disconnect: HResult; stdcall;
    function Render: HResult; stdcall;
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       qnetwork.h
 *
 ***************************************************************************)

const
  LIBID_QuartzNetTypeLib: TGUID = (D1:$56A868B1;D2:$0AD4;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));

  IID_IAMNetShowConfig: TGUID = (D1:$FA2AA8F1;D2:$8B62;D3:$11D0;D4:($A5,$20,$00,$00,$00,$00,$00,$00));
  IID_IAMChannelInfo: TGUID = (D1:$FA2AA8F2;D2:$8B62;D3:$11D0;D4:($A5,$20,$00,$00,$00,$00,$00,$00));
  IID_IAMNetworkStatus: TGUID = (D1:$FA2AA8F3;D2:$8B62;D3:$11D0;D4:($A5,$20,$00,$00,$00,$00,$00,$00));
  IID_IAMExtendedSeeking: TGUID = (D1:$FA2AA8F9;D2:$8B62;D3:$11D0;D4:($A5,$20,$00,$00,$00,$00,$00,$00));
  IID_IAMNetShowExProps: TGUID = (D1:$FA2AA8F5;D2:$8B62;D3:$11D0;D4:($A5,$20,$00,$00,$00,$00,$00,$00));
  IID_IAMExtendedErrorInfo: TGUID = (D1:$FA2AA8F6;D2:$8B62;D3:$11D0;D4:($A5,$20,$00,$00,$00,$00,$00,$00));
  IID_IAMMediaContent: TGUID = (D1:$FA2AA8EF;D2:$8B62;D3:$11D0;D4:($A5,$20,$00,$00,$00,$00,$00,$00));

type
  TAMExtendedSeekingCapabilities = (
    AM_EXSEEK_INVALID_0,
    AM_EXSEEK_CANSEEK,
    AM_EXSEEK_CANSCAN,
    AM_EXSEEK_INVALID_3,
    AM_EXSEEK_MARKERSEEK,
    AM_EXSEEK_INVALID_5,
    AM_EXSEEK_INVALID_6,
    AM_EXSEEK_INVALID_7,
    AM_EXSEEK_SCANWITHOUTCLOCK,
    AM_EXSEEK_INVALID_9,
    AM_EXSEEK_INVALID_10,
    AM_EXSEEK_INVALID_11,
    AM_EXSEEK_INVALID_12,
    AM_EXSEEK_INVALID_13,
    AM_EXSEEK_INVALID_14,
    AM_EXSEEK_INVALID_15,
    AM_EXSEEK_NOSTANDARDREPAINT
  );

  TDate = record
    da_year: Integer;   // Year - 1980
    da_day: Byte;       // Day of the month
    da_mon: Byte;       // Month (1 = Jan)
  end;

(* Definition of interface: IAMNetShowConfig *)
  IAMNetShowConfig = interface(IDispatch)
    ['{FA2AA8F1-8B62-11D0-A520-000000000000}']
    (* IAMNetShowConfig methods *)
    function get_BufferingTime(var pBufferingTime: double): HResult; stdcall;
    function put_BufferingTime(BufferingTime: double): HResult; stdcall;
    function get_UseFixedUDPPort(var pUseFixedUDPPort: WordBool): HResult; stdcall;
    function put_UseFixedUDPPort(UseFixedUDPPort: WordBool): HResult; stdcall;
    function get_FixedUDPPort(var pFixedUDPPort: Longint): HResult; stdcall;
    function put_FixedUDPPort(FixedUDPPort: Longint): HResult; stdcall;
    function get_UseHTTPProxy(var pUseHTTPProxy: WordBool): HResult; stdcall;
    function put_UseHTTPProxy(UseHTTPProxy: WordBool): HResult; stdcall;
    function get_EnableAutoProxy(var pEnableAutoProxy: WordBool): HResult; stdcall;
    function put_EnableAutoProxy(EnableAutoProxy: WordBool): HResult; stdcall;
    function get_HTTPProxyHost(var pbstrHTTPProxyHost: TBSTR): HResult; stdcall;
    function put_HTTPProxyHost(bstrHTTPProxyHost: TBSTR): HResult; stdcall;
    function get_HTTPProxyPort(var pHTTPProxyPort: Longint): HResult; stdcall;
    function put_HTTPProxyPort(HTTPProxyPort: Longint): HResult; stdcall;
    function get_EnableMulticast(var pEnableMulticast: WordBool): HResult; stdcall;
    function put_EnableMulticast(EnableMulticast: WordBool): HResult; stdcall;
    function get_EnableUDP(var pEnableUDP: WordBool): HResult; stdcall;
    function put_EnableUDP(EnableUDP: WordBool): HResult; stdcall;
    function get_EnableTCP(var pEnableTCP: WordBool): HResult; stdcall;
    function put_EnableTCP(EnableTCP: WordBool): HResult; stdcall;
    function get_EnableHTTP(var pEnableHTTP: WordBool): HResult; stdcall;
    function put_EnableHTTP(EnableHTTP: WordBool): HResult; stdcall;
  end;

(* Definition of interface: IAMChannelInfo *)
  IAMChannelInfo = interface(IDispatch)
    ['{FA2AA8F2-8B62-11D0-A520-000000000000}']
    (* IAMChannelInfo methods *)
    function get_ChannelName(var pbstrChannelName: TBSTR): HResult; stdcall;
    function get_ChannelDescription(var pbstrChannelDescription: TBSTR): HResult; stdcall;
    function get_ChannelURL(var pbstrChannelURL: TBSTR): HResult; stdcall;
    function get_ContactAddress(var pbstrContactAddress: TBSTR): HResult; stdcall;
    function get_ContactPhone(var pbstrContactPhone: TBSTR): HResult; stdcall;
    function get_ContactEmail(var pbstrContactEmail: TBSTR): HResult; stdcall;
  end;

(* Definition of interface: IAMNetworkStatus *)
  IAMNetworkStatus = interface(IDispatch)
    ['{FA2AA8F3-8B62-11D0-A520-000000000000}']
    (* IAMNetworkStatus methods *)
    function get_ReceivedPackets(var pReceivedPackets: Longint): HResult; stdcall;
    function get_RecoveredPackets(var pRecoveredPackets: Longint): HResult; stdcall;
    function get_LostPackets(var pLostPackets: Longint): HResult; stdcall;
    function get_ReceptionQuality(var pReceptionQuality: Longint): HResult; stdcall;
    function get_BufferingCount(var pBufferingCount: Longint): HResult; stdcall;
    function get_IsBroadcast(var pIsBroadcast: WordBool): HResult; stdcall;
    function get_BufferingProgress(var pBufferingProgress: Longint): HResult; stdcall;
  end;

(* Definition of interface: IAMExtendedSeeking *)
  IAMExtendedSeeking = interface(IDispatch)
    ['{FA2AA8F9-8B62-11D0-A520-000000000000}']
    (* IAMExtendedSeeking methods *)
    function get_ExSeekCapabilities(var pExCapabilities: Longint): HResult; stdcall;
    function get_MarkerCount(var pMarkerCount: Longint): HResult; stdcall;
    function get_CurrentMarker(var pCurrentMarker: Longint): HResult; stdcall;
    function GetMarkerTime(MarkerNum: Longint; var pMarkerTime: double): HResult; stdcall;
    function GetMarkerName(MarkerNum: Longint; var pbstrMarkerName: TBSTR): HResult; stdcall;
    function put_PlaybackSpeed(Speed: double): HResult; stdcall;
    function get_PlaybackSpeed(var pSpeed: double): HResult; stdcall;
  end;

(* Definition of interface: IAMNetShowExProps *)
  IAMNetShowExProps = interface(IDispatch)
    ['{FA2AA8F5-8B62-11D0-A520-000000000000}']
    (* IAMNetShowExProps methods *)
    function get_SourceProtocol(var pSourceProtocol: Longint): HResult; stdcall;
    function get_Bandwidth(var pBandwidth: Longint): HResult; stdcall;
    function get_ErrorCorrection(var pbstrErrorCorrection: TBSTR): HResult; stdcall;
    function get_CodecCount(var pCodecCount: Longint): HResult; stdcall;
    function GetCodecInstalled(CodecNum: Longint; var pCodecInstalled: WordBool): HResult; stdcall;
    function GetCodecDescription(CodecNum: Longint; var pbstrCodecDescription: TBSTR): HResult; stdcall;
    function GetCodecURL(CodecNum: Longint; var pbstrCodecURL: TBSTR): HResult; stdcall;
    function get_CreationDate(var pCreationDate: TDate): HResult; stdcall;
    function get_SourceLink(var pbstrSourceLink: TBSTR): HResult; stdcall;
  end;

(* Definition of interface: IAMExtendedErrorInfo *)
  IAMExtendedErrorInfo = interface(IDispatch)
    ['{FA2AA8F6-8B62-11D0-A520-000000000000}']
    (* IAMExtendedErrorInfo methods *)
    function get_HasError(var pHasError: WordBool): HResult; stdcall;
    function get_ErrorDescription(var pbstrErrorDescription: TBSTR): HResult; stdcall;
    function get_ErrorCode(var pErrorCode: Longint): HResult; stdcall;
  end;

(* Definition of interface: IAMMediaContent *)
  IAMMediaContent = interface(IDispatch)
    ['{FA2AA8EF-8B62-11D0-A520-000000000000}']
    (* IAMMediaContent methods *)
    function get_AuthorName(var pbstrAuthorName: TBSTR): HResult; stdcall;
    function get_Title(var pbstrTitle: TBSTR): HResult; stdcall;
    function get_Rating(var pbstrRating: TBSTR): HResult; stdcall;
    function get_Description(var pbstrDescription: TBSTR): HResult; stdcall;
    function get_Copyright(var pbstrCopyright: TBSTR): HResult; stdcall;
    function get_BaseURL(var pbstrBaseURL: TBSTR): HResult; stdcall;
    function get_LogoURL(var pbstrLogoURL: TBSTR): HResult; stdcall;
    function get_LogoIconURL(var pbstrLogoURL: TBSTR): HResult; stdcall;
    function get_WatermarkURL(var pbstrWatermarkURL: TBSTR): HResult; stdcall;
    function get_MoreInfoURL(var pbstrMoreInfoURL: TBSTR): HResult; stdcall;
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       cutlist.h
 *
 ***************************************************************************)

const
  CLSID_CutListSource: TGUID = (D1:$A5EA8D20;D2:$253D;D3:$11D1;D4:($B3,$F1,$00,$AA,$00,$37,$61,$C5));
  CLSID_CutListGraphBuilder: TGUID = (D1:$A5EA8D2F;D2:$253D;D3:$11D1;D4:($B3,$F1,$00,$AA,$00,$37,$61,$C5));

  IID_IAMCutListElement: TGUID = (D1:$CDE29520;D2:$3418;D3:$11CF;D4:($A5,$B0,$00,$20,$AF,$05,$3D,$8F));
  IID_IAMFileCutListElement: TGUID = (D1:$F0947070;D2:$276C;D3:$11D0;D4:($83,$16,$00,$20,$AF,$11,$C0,$10));
  IID_IAMVideoCutListElement: TGUID = (D1:$CDE29522;D2:$3418;D3:$11CF;D4:($A5,$B0,$00,$20,$AF,$05,$3D,$8F));
  IID_IAMAudioCutListElement: TGUID = (D1:$CDE29524;D2:$3418;D3:$11CF;D4:($A5,$B0,$00,$20,$AF,$05,$3D,$8F));
  IID_IStandardCutList: TGUID = (D1:$A5EA8D29;D2:$253D;D3:$11D1;D4:($B3,$F1,$00,$AA,$00,$37,$61,$C5));
  IID_IFileClip: TGUID = (D1:$A5EA8D2A;D2:$253D;D3:$11D1;D4:($B3,$F1,$00,$AA,$00,$37,$61,$C5));
  IID_ICutListGraphBuilder: TGUID = (D1:$A5EA8D2C;D2:$253D;D3:$11D1;D4:($B3,$F1,$00,$AA,$00,$37,$61,$C5));


const
  CL_DEFAULT_TIME = -1;

type
  TCL_Elem_Status = (
    CL_NOT_PLAYED,
    CL_PLAYING,
    CL_FINISHED,
    CL_STATE_INVALID
  );

const
  CL_STATE_MASK = CL_STATE_INVALID;
  CL_WAIT_FOR_STATE = TCL_Elem_Status($F0000000);

type
  TCL_Elem_Flags  = (
    CL_ELEM_NONE,
    CL_ELEM_FIRST,
    CL_ELEM_LAST,
    CL_ELEM_NULL
  );

const
  CL_ELEM_ALL = TCL_Elem_Flags($FFFFFFFF);

type
  IAMCutListElement = interface(IUnknown)
    ['{CDE29520-3418-11CF-A5B0-0020AF053D8F}']
    function GetElementStartPosition(var pmtStart: TReference_Time): HResult; stdcall;
    function GetElementDuration(var pmtDuration: TReference_Time): HResult; stdcall;
    function IsFirstElement: HResult; stdcall;
    function IsLastElement: HResult; stdcall;
    function IsNull: HResult; stdcall;
    function ElementStatus(var pdwStatus: DWORD; dwTimeoutMs: DWORD): HResult; stdcall;
  end;

  IAMFileCutListElement = interface(IUnknown)
    ['{F0947070-276C-11D0-8316-0020AF11C010}']
    function GetFileName(var ppwstrFileName: LPWSTR): HResult; stdcall;
    function GetTrimInPosition(var pmtTrimIn: TReference_Time): HResult; stdcall;
    function GetTrimOutPosition(var pmtTrimOut: TReference_Time): HResult; stdcall;
    function GetOriginPosition(var pmtOrigin: TReference_Time): HResult; stdcall;
    function GetTrimLength(var pmtLength: TReference_Time): HResult; stdcall;
    function GetElementSplitOffset(var pmtOffset: TReference_Time): HResult; stdcall;
  end;

  IAMVideoCutListElement = interface(IUnknown)
    ['{CDE29522-3418-11CF-A5B0-0020AF053D8F}']
    function IsSingleFrame: HResult; stdcall;
    function GetStreamIndex(var piStream: DWORD): HResult; stdcall;
  end;

  IAMAudioCutListElement = interface(IUnknown)
    //['{CDE29524-3418-11CF-A5B0-0020AF053D8F}']
    function GetStreamIndex(var piStream: DWORD): HResult; stdcall;
    function HasFadeIn: HResult; stdcall;
    function HasFadeOut: HResult; stdcall;
  end;

  IStandardCutList = interface(IUnknown)
    ['{A5EA8D29-253D-11D1-B3F1-00AA003761C5}']
    function AddElement(pElement: IAMCutListElement;
        mtStart, mtDuration: TReference_Time): HResult; stdcall;
    function RemoveElement(pElement: IAMCutListElement): HResult; stdcall;
    function GetFirstElement(pElement: IAMCutListElement): HResult; stdcall;
    function GetLastElement(pElement: IAMCutListElement): HResult; stdcall;
    function GetNextElement(pElement: IAMCutListElement): HResult; stdcall;

    function GetPreviousElement(pElement: IAMCutListElement): HResult; stdcall;
    function GetMediaType(out pmt: TAM_Media_Type): HResult; stdcall;
    function SetMediaType(const pmt: TAM_Media_Type): HResult; stdcall;
  end;

  IFileClip = interface(IUnknown)
    ['{A5EA8D2A-253D-11D1-B3F1-00AA003761C5}']
    function SetFileAndStream(wstrFileName: LPWSTR; streamNum: DWORD): HResult; stdcall;
    function CreateCut(out ppElement: IAMCutListElement; mtTrimIn, mtTrimOut,
        mtOrigin, mtLength, mtOffset: TReference_Time): HResult; stdcall;
    function GetMediaType(out pmt: TAM_Media_Type): HResult; stdcall;
  end;

  ICutListGraphBuilder = interface(IUnknown)
    ['{A5EA8D2C-253D-11D1-B3F1-00AA003761C5}']
    function SetFilterGraph(pFilterGraph: IGraphBuilder): HResult; stdcall;
    function GetFilterGraph(out pFilterGraph: IGraphBuilder): HResult; stdcall;
    function AddCutList(pCutList: IStandardCutList; out ppPin: IPin): HResult; stdcall;
    function RemoveCutList(pCutList: IStandardCutList): HResult; stdcall;
    function SetOutputFileName(const pType: TGUID; lpwstrFile: POLESTR;
        const ppf: IBaseFilter; const pSink: IFileSinkFilter): HResult; stdcall;
    function Render: HResult; stdcall;
    function GetElementFlags(pElement: IAMCutListElement; var lpdwFlags: DWORD): HResult; stdcall;
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       playlist.h
 *
 ***************************************************************************)

const
  IID_IAMPlayListItem: TGUID = (D1:$56A868FF;D2:$0AD4;D3:$11CE;D4:($B0,$A3,$00,$20,$AF,$0B,$A7,$70));
  IID_IAMPlayList: TGUID = (D1:$56A868FE;D2:$0AD4;D3:$11CE;D4:($B0,$A3,$00,$20,$AF,$0B,$A7,$70));

type
  TAMPlayListItemFlags = (
    AMPLAYLISTITEMFLAGS_INVALID_0,
    AMPLAYLISTITEM_CANSKIP,
    AMPLAYLISTITEM_CANBIND
  );

  TAMPlayLisyFlags = (
    AMPLAYLISTFLAGS_INVALID_0,
    AMPLAYLISTITEM_STARTINSCANMODE
  );

  IAMPlayListItem = interface(IUnknown)
    ['{56A868FF-0AD4-11CE-B0A3-0020AF0BA770}']
    function GetFlags(var pdwFlags: DWORD): HResult; stdcall;
    function GetSourceCount(var pdwSources: DWORD): HResult; stdcall;
    function GetSourceURL(dwSourceIndex: DWORD; var pbstrURL: TBSTR): HResult; stdcall;
    function GetSourceStart(dwSourceIndex: DWORD; var prtStart: TReference_Time): HResult; stdcall;
    function GetSourceDuration(dwSourceIndex: DWORD;
        var prtDuration: TReference_Time): HResult; stdcall;
    function GetSourceStartMarker(dwSourceIndex: DWORD;
        var pdwMarker: DWORD): HResult; stdcall;
    function GetSourceEndMarker(dwSourceIndex: DWORD;
        var pdwMarker: DWORD): HResult; stdcall;
    function GetSourceStartMarkerName(dwSourceIndex: DWORD;
        var pbstrStartMarker: TBSTR): HResult; stdcall;
    function GetSourceEndMarkerName(dwSourceIndex: DWORD;
        var pbstrEndMarker: TBSTR): HResult; stdcall;
  end;

  IAMPlayList = interface(IUnknown)
    ['{56A868FE-0AD4-11CE-B0A3-0020AF0BA770}']
    function GetFlags(var pdwFlags: DWORD): HResult; stdcall;
    function GetItemCount(var pdwItems: DWORD): HResult; stdcall;
    function GetItem(dwItemIndex: DWORD; out ppItem: IAMPlayListItem): HResult; stdcall;
    function GetRepeatInfo(var pdwRepeatCount, pdwRepeatStart,
        pdwRepeatEnd: DWORD): HResult; stdcall;
    function GetScanDuration(var prtScanDuration: TReference_Time): HResult; stdcall;
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       amvideo.h
 *
 ***************************************************************************)

// This is an interface on the video renderer that provides information about
// DirectDraw with respect to its use by the renderer. For example it allows
// an application to get details of the surface and any hardware capabilities
// that are available. It also allows someone to adjust the surfaces that the
// renderer should use and furthermore even set the DirectDraw instance. We
// allow someone to set the DirectDraw instance because DirectDraw can only
// be opened once per process so it helps resolve conflicts. There is some
// duplication in this interface as the hardware/emulated/FOURCCs available
// can all be found through the IDirectDraw interface, this interface allows
// simple access to that information without calling the DirectDraw provider
// itself. The AMDDS prefix is ActiveMovie DirectDraw Switches abbreviated.

const
  IID_IDirectDrawVideo: TGUID = (D1:$36D39EB0;D2:$DD75;D3:$11CE;D4:($BF,$0E,$00,$AA,$00,$55,$59,$5A));
  IID_IQualProp: TGUID = (D1:$1BD0ECB0;D2:$F8E2;D3:$11CE;D4:($AA,$C6,$00,$20,$AF,$0B,$99,$A3));
  IID_IFullScreenVideo: TGUID = (D1:$DD1D7110;D2:$7836;D3:$11CF;D4:($BF,$47,$00,$AA,$00,$55,$59,$5A));
  IID_IFullScreenVideoEx: TGUID = (D1:$53479470;D2:$F1DD;D3:$11CF;D4:($BC,$42,$00,$AA,$00,$AC,$74,$F6));
  IID_IBaseVideoMixer: TGUID = (D1:$61DED640;D2:$E912;D3:$11CE;D4:($A0,$99,$00,$AA,$00,$47,$9A,$58));

const
  AMDDS_NONE    = $00;        // No use for DCI/DirectDraw
  AMDDS_DCIPS   = $01;        // Use DCI primary surface
  AMDDS_PS      = $02;        // Use DirectDraw primary
  AMDDS_RGBOVR  = $04;        // RGB overlay surfaces
  AMDDS_YUVOVR  = $08;        // YUV overlay surfaces
  AMDDS_RGBOFF  = $10;        // RGB offscreen surfaces
  AMDDS_YUVOFF  = $20;        // YUV offscreen surfaces
  AMDDS_RGBFLP  = $40;        // RGB flipping surfaces
  AMDDS_YUVFLP  = $80;        // YUV flipping surfaces
  AMDDS_ALL     = $FF;        // ALL the previous flags
  AMDDS_DEFAULT = AMDDS_ALL;   // Use all available surfaces

  AMDDS_YUV = AMDDS_YUVOFF or AMDDS_YUVOVR or AMDDS_YUVFLP;
  AMDDS_RGB = AMDDS_RGBOFF or AMDDS_RGBOVR or AMDDS_RGBFLP;
  AMDDS_PRIMARY = AMDDS_DCIPS or AMDDS_PS;

type
  IDirectDrawVideo = interface(IUnknown)
    ['{36D39EB0-DD75-11CE-BF0E-00AA0055595A}']
    // IDirectDrawVideo methods
    function GetSwitches(var pSwitches: DWORD): HResult; stdcall;
    function SetSwitches(pSwitches: DWORD): HResult; stdcall;
    function GetCaps(var pCaps: DDCAPS): HResult; stdcall;
    function GetEmulatedCaps(var pCaps: DDCAPS): HResult; stdcall;
    function GetSurfaceDesc(var pSurfaceDesc: DDSURFACEDESC): HResult; stdcall;
    function GetFourCCCodes(var pCount, pCodes: DWORD): HResult; stdcall;
    function SetDirectDraw(pDirectDraw: IDirectDraw): HResult; stdcall;
    function GetDirectDraw(out ppDirectDraw: IDirectDraw): HResult; stdcall;
    function GetSurfaceType(var pSurfaceType: DWORD): HResult; stdcall;
    function SetDefault: HResult; stdcall;
    function UseScanLine(UseScanLine: LongBool): HResult; stdcall;
    function CanUseScanLine(var UseScanLine: LongBool): HResult; stdcall;
    function UseOverlayStretch(UseOverlayStretch: LongBool): HResult; stdcall;
    function CanUseOverlayStretch(var UseOverlayStretch: LongBool): HResult; stdcall;
    function UseWhenFullScreen(UseWhenFullScreen: LongBool): HResult; stdcall;
    function WillUseFullScreen(var UseWhenFullScreen: LongBool): HResult; stdcall;
  end;

  IQualProp = interface(IUnknown)
    ['{1BD0ECB0-F8E2-11CE-AAC6-0020AF0B99A3}']
    // Compare these with the functions in class CGargle in gargle.h
    function get_FramesDroppedInRenderer(var pcFrames: Integer): HResult; stdcall;
    function get_FramesDrawn(var pcFrames: Integer): HResult; stdcall;
    function get_AvgFrameRate(var piAvgFrameRate: Integer): HResult; stdcall;
    function get_Jitter(var iJitter: Integer): HResult; stdcall;
    function get_AvgSyncOffset(var piAvg: Integer): HResult; stdcall;
    function get_DevSyncOffset(var piDev: Integer): HResult; stdcall;
  end;

// This interface allows an application or plug in distributor to control a
// full screen renderer. The Modex renderer supports this interface. When
// connected a renderer should load the display modes it has available
// The number of modes available can be obtained through CountModes. Then
// information on each individual mode is available by calling GetModeInfo
// and IsModeAvailable. An application may enable and disable any modes
// by calling the SetEnabled flag with OATRUE or OAFALSE (not C/C++ TRUE
// and FALSE values) - the current value may be queried by IsModeEnabled

// A more generic way of setting the modes enabled that is easier to use
// when writing applications is the clip loss factor. This defines the
// amount of video that can be lost when deciding which display mode to
// use. Assuming the decoder cannot compress the video then playing an
// MPEG file (say 352x288) into a 320x200 display will lose about 25% of
// the image. The clip loss factor specifies the upper range permissible.
// To allow typical MPEG video to be played in 320x200 it defaults to 25%

  IFullScreenVideo = interface(IUnknown)
    ['{DD1D7110-7836-11CF-BF47-00AA0055595A}']
    // IFullScreenVideo methods
    function CountModes(var pModes: Longint): HResult; stdcall;
    function GetModeInfo(Mode: Longint; var pWidth, pHeight, pDepth: Longint): HResult; stdcall;
    function GetCurrentMode(var pMode: Longint): HResult; stdcall;
    function IsModeAvailable(Mode: Longint): HResult; stdcall;
    function IsModeEnabled(Mode: Longint): HResult; stdcall;
    function SetEnabled(Mode: Longint; bEnabled: Longint): HResult; stdcall;
    function GetClipFactor(var pClipFactor: Longint): HResult; stdcall;
    function SetClipFactor(ClipFactor: Longint): HResult; stdcall;
    function SetMessageDrain(hwnd: HWND): HResult; stdcall;
    function GetMessageDrain(var hwnd: HWND): HResult; stdcall;
    function SetMonitor(Monitor: Longint): HResult; stdcall;
    function GetMonitor(var Monitor: Longint): HResult; stdcall;
    function HideOnDeactivate(Hide: LongBool): HResult; stdcall;
    function IsHideOnDeactivate: HResult; stdcall;
    function SetCaption(strCaption: TBStr): HResult; stdcall;
    function GetCaption(var pstrCaption: TBStr): HResult; stdcall;
    function SetDefault: HResult; stdcall;
  end;

// This adds the accelerator table capabilities in fullscreen. This is being
// added between the original runtime release and the full SDK release. We
// cannot just add the method to IFullScreenVideo as we don't want to force
// applications to have to ship the ActiveMovie support DLLs - this is very
// important to applications that plan on being downloaded over the Internet

  IFullScreenVideoEx = interface(IFullScreenVideo)
    ['{53479470-F1DD-11CF-BC42-00AA00AC74F6}']
    // IFullScreenVideoEx
    function SetAcceleratorTable(hwnd: HWND; hAccel: HACCEL): HResult; stdcall;
    function GetAcceleratorTable(var hwnd: HWND; var hAccel: HACCEL): HResult; stdcall;
    function KeepPixelAspectRatio(KeepAspect: LongBool): HResult; stdcall;
    function IsKeepPixelAspectRatio(var pKeepAspect: LongBool): HResult; stdcall;
  end;

// The SDK base classes contain a base video mixer class. Video mixing in a
// software environment is tricky because we typically have multiple streams
// each sending data at unpredictable times. To work with this we defined a
// pin that is the lead pin, when data arrives on this pin we do a mix. As
// an alternative we may not want to have a lead pin but output samples at
// predefined spaces, like one every 1/15 of a second, this interfaces also
// supports that mode of operations (there is a working video mixer sample)

  IBaseVideoMixer = interface(IUnknown)
    ['{61DED640-E912-11CE-A099-00AA00479A58}']
    function SetLeadPin(iPin: Integer): HResult; stdcall;
    function GetLeadPin(var iPin: Integer): HResult; stdcall;
    function GetInputPinCount(var piPinCount: Integer): HResult; stdcall;
    function IsUsingClock(var pbValue: Integer): HResult; stdcall;
    function SetUsingClock(bValue: Integer): HResult; stdcall;
    function GetClockPeriod(var pbValue: Integer): HResult; stdcall;
    function SetClockPeriod(bValue: Integer): HResult; stdcall;
  end;

const
  iPALETTE_COLORS = 256;     // Maximum colours in palette
  iEGA_COLORS     = 16;      // Number colours in EGA palette
  iMASK_COLORS    = 3;       // Maximum three components
  iTRUECOLOR      = 16;      // Minimum true colour device
  iRED            = 0;       // Index position for RED mask
  iGREEN          = 1;       // Index position for GREEN mask
  iBLUE           = 2;       // Index position for BLUE mask
  iPALETTE        = 8;       // Maximum colour depth using a palette
  iMAXBITS        = 8;       // Maximum bits per colour component

// Used for true colour images that also have a palette
type
  TTrueColorInfo = record
    dwBitMasks: array[0..iMASK_COLORS-1] of DWORD;
    bmiColors: array[0..iPALETTE_COLORS-1] of TRGBQuad;
  end;

// The BITMAPINFOHEADER contains all the details about the video stream such
// as the actual image dimensions and their pixel depth. A source filter may
// also request that the sink take only a section of the video by providing a
// clipping rectangle in rcSource. In the worst case where the sink filter
// forgets to check this on connection it will simply render the whole thing
// which isn't a disaster. Ideally a sink filter will check the rcSource and
// if it doesn't support image extraction and the rectangle is not empty then
// it will reject the connection. A filter should use SetRectEmpty to reset a
// rectangle to all zeroes (and IsRectEmpty to later check the rectangle).
// The rcTarget specifies the destination rectangle for the video, for most
// source filters they will set this to all zeroes, a downstream filter may
// request that the video be placed in a particular area of the buffers it
// supplies in which case it will call QueryAccept with a non empty target

  TVideoInfoHeader = record
    rcSource: TRect;                   // The bit we really want to use
    rcTarget: TRect;                   // Where the video should go
    dwBitRate: DWORD;                  // Approximate bit data rate
    dwBitErrorRate: DWORD;             // Bit error rate for this stream
    AvgTimePerFrame: TReference_Time;  // Average time per frame (100ns units)

    bmiHeader: TBitmapInfoHeader;
  end;

// make sure the pbmi is initialized before using these macros
{function TRUECOLOR(pbmi: PBitmapInfo): Pointer;
function COLORS(pbmi: PBitmapInfo): Pointer;
function BITMASKS(pbmi: PBitmapInfo): Pointer;
{
#define TRUECOLOR(pbmi)  ((TRUECOLORINFO *)(((LPBYTE)&((pbmi)->bmiHeader)) \
                                        + (pbmi)->bmiHeader.biSize))
#define COLORS(pbmi)    ((RGBQUAD *)(((LPBYTE)&((pbmi)->bmiHeader))     \
                                        + (pbmi)->bmiHeader.biSize))
#define BITMASKS(pbmi)  ((DWORD *)(((LPBYTE)&((pbmi)->bmiHeader))       \
                                        + (pbmi)->bmiHeader.biSize))
 }
// All the image based filters use this to communicate their media types. It's
// centred principally around the BITMAPINFO. This structure always contains a
// BITMAPINFOHEADER followed by a number of other fields depending on what the
// BITMAPINFOHEADER contains. If it contains details of a palettised format it
// will be followed by one or more RGBQUADs defining the palette. If it holds
// details of a true colour format then it may be followed by a set of three
// DWORD bit masks that specify where the RGB data can be found in the image
// (For more information regarding BITMAPINFOs see the Win32 documentation)

// The rcSource and rcTarget fields are not for use by filters supplying the
// data. The destination (target) rectangle should be set to all zeroes. The
// source may also be zero filled or set with the dimensions of the video. So
// if the video is 352x288 pixels then set it to (0,0,352,288). These fields
// are mainly used by downstream filters that want to ask the source filter
// to place the image in a different position in an output buffer. So when
// using for example the primary surface the video renderer may ask a filter
// to place the video images in a destination position of (100,100,452,388)
// on the display since that's where the window is positioned on the display

// !!! WARNING !!!
// DO NOT use this structure unless you are sure that the BITMAPINFOHEADER
// has a normal biSize == sizeof(BITMAPINFOHEADER) !
// !!! WARNING !!!

type
  TVideoInfo = record
    rcSource: TRect;                   // The bit we really want to use
    rcTarget: TRect;                   // Where the video should go
    dwBitRate: DWORD;                  // Approximate bit data rate
    dwBitErrorRate: DWORD;             // Bit error rate for this stream
    AvgTimePerFrame: TReference_Time;  // Average time per frame (100ns units)

    bmiHeader: TBitmapInfoHeader;

    case Integer of
    0: (
      bmiColors: array[0..iPALETTE_COLORS-1] of TRGBQuad // Colour palette
      );
    1: (
      dwBitMasks: array[0..iMASK_COLORS-1] of DWORD      // True colour masks
      );
    2: (
      TrueColorInfo: TTrueColorInfo                      // Both of the above
      );
  end;

// These macros define some standard bitmap format sizes

const
  SIZE_EGA_PALETTE = iEGA_COLORS * SizeOf(TRGBQuad);
  SIZE_PALETTE = iPALETTE_COLORS * SizeOf(TRGBQuad);
  SIZE_MASKS = iMASK_COLORS * SizeOf(DWORD);

  SIZE_PREHEADER = 48; // offset TVideoInfoHeader.bmiHeader
  SIZE_VIDEOHEADER = SizeOf(TVideoInfoHeader);

// !!! for abnormal biSizes
// #define SIZE_VIDEOHEADER(pbmi) ((pbmi)->bmiHeader.biSize + SIZE_PREHEADER)

// DIBSIZE calculates the number of bytes required by an image
{
function WIDTHBYTES(bits: Integer): DWORD;
function DIBWIDTHBYTES(const bhi: TBitmapInfoHeader): DWORD;
function _DIBSIZE(const bmi: TBitmapInfoHeader): DWORD;
function DIBSIZE(const bmi: TBitmapInfoHeader): DWORD;
{
#define WIDTHBYTES(bits) ((DWORD)(((bits)+31) & (~31)) / 8)
#define DIBWIDTHBYTES(bi) (DWORD)WIDTHBYTES((DWORD)(bi).biWidth * (DWORD)(bi).biBitCount)
#define _DIBSIZE(bi) (DIBWIDTHBYTES(bi) * (DWORD)(bi).biHeight)
#define DIBSIZE(bi) ((bi).biHeight < 0 ? (-1)*(_DIBSIZE(bi)) : _DIBSIZE(bi))
}
// This compares the bit masks between two VIDEOINFOHEADERs
{
function BIT_MASKS_MATCH(const bmi1, bmi2: TBitmapInfo): Boolean;
{
#define BIT_MASKS_MATCH(pbmi1,pbmi2)                                \
    (((pbmi1)->dwBitMasks[iRED] == (pbmi2)->dwBitMasks[iRED]) &&        \
     ((pbmi1)->dwBitMasks[iGREEN] == (pbmi2)->dwBitMasks[iGREEN]) &&    \
     ((pbmi1)->dwBitMasks[iBLUE] == (pbmi2)->dwBitMasks[iBLUE]))
}
// These zero fill different parts of the VIDEOINFOHEADER structure

// Only use these macros for pbmi's with a normal BITMAPINFOHEADER biSize
{procedure RESET_MASKS(var bmi: TBitmapInfo);
procedure RESET_HEADER(var bmi: TBitmapInfo);
procedure RESET_PALETTE(var bmi: TBitmapInfo);
{
#define RESET_MASKS(pbmi) (ZeroMemory((PVOID)(pbmi)->dwBitFields,SIZE_MASKS))
#define RESET_HEADER(pbmi) (ZeroMemory((PVOID)(pbmi),SIZE_VIDEOHEADER))
#define RESET_PALETTE(pbmi) (ZeroMemory((PVOID)(pbmi)->bmiColors,SIZE_PALETTE));
}
{
// !!! This is the right way to do it, but may break existing code
#define RESET_MASKS(pbmi) (ZeroMemory((PVOID)(((LPBYTE)(pbmi)->bmiHeader) + \
                        (pbmi)->bmiHeader.biSize,SIZE_MASKS)))
#define RESET_HEADER(pbmi) (ZeroMemory((PVOID)(pbmi), SIZE_PREHEADER +      \
                        sizeof(BITMAPINFOHEADER)))
#define RESET_PALETTE(pbmi) (ZeroMemory((PVOID)(((LPBYTE)(pbmi)->bmiHeader) + \
                        (pbmi)->bmiHeader.biSize,SIZE_PALETTE))
}

// Other (hopefully) useful bits and bobs
{
#define PALETTISED(pbmi) ((pbmi)->bmiHeader.biBitCount <= iPALETTE)
#define PALETTE_ENTRIES(pbmi) ((DWORD) 1 << (pbmi)->bmiHeader.biBitCount)

// Returns the address of the BITMAPINFOHEADER from the VIDEOINFOHEADER
#define HEADER(pVideoInfo) (&(((VIDEOINFOHEADER *) (pVideoInfo))->bmiHeader))
 }

// MPEG variant - includes a DWORD length followed by the
// video sequence header after the video header.
//
// The sequence header includes the sequence header start code and the
// quantization matrices associated with the first sequence header in the
// stream so is a maximum of 140 bytes long.
type
  TMPEG1VideInfo = record
    hdr: TVideoInfoHeader;                  // Compatible with VIDEOINFO
    dwStartTimeCode: DWORD;                 // 25-bit Group of pictures time code
                                            // at start of data
    cbSequenceHeader: DWORD;                // Length in bytes of bSequenceHeader
    bSequenceHeader: array[0..0] of Byte;   // Sequence header including
                                            // quantization matrices if any
  end;

const
  MAX_SIZE_MPEG1_SEQUENCE_INFO = 140;
{
#define SIZE_MPEG1VIDEOINFO(pv) (FIELD_OFFSET(MPEG1VIDEOINFO, bSequenceHeader[0]) + (pv)->cbSequenceHeader)
#define MPEG1_SEQUENCE_INFO(pv) ((const BYTE *)(pv)->bSequenceHeader)
}

// Analog video variant - Use this when the format is FORMAT_AnalogVideo
//
// rcSource defines the portion of the active video signal to use
// rcTarget defines the destination rectangle
//    both of the above are relative to the dwActiveWidth and dwActiveHeight fields
// dwActiveWidth is currently set to 720 for all formats (but could change for HDTV)
// dwActiveHeight is 483 for NTSC and 575 for PAL/SECAM  (but could change for HDTV)
type
  TAnalogVideoInfo = record
    rcSource: TRect;                   // Width max is 720, height varies w/ TransmissionS
    rcTarget: TRect;                   // Where the video should go
    dwBitRate: DWORD;                  // Always 720 (CCIR-601 active samples per line)
    dwBitErrorRate: DWORD;             // 483 for NTSC, 575 for PAL/SECAM
    AvgTimePerFrame: TReference_Time;  // Normal ActiveMovie units (100 nS)
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       amaudio.h
 *
 ***************************************************************************)

const
  IID_IAMDirectSound: TGUID = (D1:$546F4260;D2:$D53E;D3:$11CF;D4:($B3,$F0,$00,$AA,$00,$37,$61,$C5));

// This is the interface the audio renderer supports to give the application
// access to the direct sound object and buffers it is using, to allow the
// application to use things like the 3D features of Direct Sound for the
// soundtrack of a movie being played with Active Movie

// be nice to our friends in C
type
  IAMDirectSound = interface(IUnknown)
    ['{546F4260-D53E-11CF-B3F0-00AA003761C5}']
    (* IAMDirectSound methods *)
    function GetDirectSoundInterface(out lplpds: IDirectSound): HResult; stdcall;
    function GetPrimaryBufferInterface(out lplpdsb: IDirectSoundBuffer): HResult; stdcall;
    function GetSecondaryBufferInterface(out lplpdsb: IDirectSoundBuffer): HResult; stdcall;
    function ReleaseDirectSoundInterface(lpds: IDirectSound): HResult; stdcall;
    function ReleasePrimaryBufferInterface(lpdsb: IDirectSoundBuffer): HResult; stdcall;
    function ReleaseSecondaryBufferInterface(lpdsb: IDirectSoundBuffer): HResult; stdcall;
    function SetFocusWindow(hwnd: HWND; b: BOOL): HResult; stdcall;
    function GetFocusWindow(var hwnd: HWND; var b: BOOL): HResult; stdcall;
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       amvpe.h
 *
 ***************************************************************************)

type

(*
 * VIDOESIGNALINFO
 *)
  TAMVideoSignalInfo = record
    dwSize: DWORD;              // Size of the structure
    dwVREFHeight: DWORD;        // Specifies the number of lines of data in the vref
    bDoubleClock: BOOL;         // videoport should enable double clocking
    bVACT: BOOL;                // videoport should use an external VACT signal
    bInterlaced: BOOL;          // Indicates that the signal is interlaced
    bHalfline: BOOL;            // Device will write half lines into the frame buffer
    bInvertedPolarity: BOOL;    // Devoce inverts the polarity by default
  end;

(*
 * DDVIDEOPORTCONNECT
 *)
   DDVIDEOPORTCONNECT = record
     dwSize: DWORD;             // size of the DDVIDEOPORTCONNECT structure
     guidTypeID: TGUID;         // Description of video port connection
     dwPortWidth: DWORD;        // Width of the video port
     dwFlags: DWORD;            // Connection flags
   end;

  IVPEConfig = interface(IUnknown)
    ['{BC29A660-30E3-11d0-9E69-00C04FD7C15B}']
    // gets the various connection information structures (guid, portwidth)
    // in an array of structures. If the pointer to the array is NULL, first
    // parameter returns the total number of formats supported.
    function GetConnectInfo(var lpNumConnectInfo: DWORD;
        var lpddvpConnectInfo: DDVIDEOPORTCONNECT): HResult; stdcall;

    function SetConnectInfo(const ddvpConnectInfo: DDVIDEOPORTCONNECT): HResult; stdcall;

    // gets the various formats supported by the decoder in an array
    // of structures. If the pointer to the array is NULL, first parameter
    // returns the total number of formats supported.
    function GetVideoFormats(var lpNumFormats: DWORD;
        const lpddpfFormats: DDPIXELFORMAT): HResult; stdcall;

    // retrives maximum pixels per second rate expected for a given
    // format and a given scaling factor. If decoder does not support
    // those scaling factors, then it gives the rate and the nearest
    // scaling factors.
    function GetMaxPixelRate(const ddpfFormat: DDPIXELFORMAT;
        lpdwZoomHeight, lpdwZoomWidth: DWORD;
        var lpdwMaxPixelsPerSecond: DWORD): HResult; stdcall;

    // retrives various properties of the decoder for a given format
    function GetVideoSignalInfo(const ddpfFormat: DDPIXELFORMAT;
        var lpAMVideoSignalInfo: TAMVideoSignalInfo): HResult; stdcall;

    // asks the decoder to ouput in this format. Return value should give
    // appropriate error code
    function SetVideoFormat(const ddpfFormat: DDPIXELFORMAT): HResult; stdcall;

    // asks the decoder to treat even fields like odd fields and visa versa
    function SetInvertPolarity: HResult; stdcall;

    // sets the scaling factors. If decoder does not support these,
    // then it sets the values to the nearest factors it can support
    function SetScalingFactors(var lpdwZoomHeight, lpdwZoomWidth: DWORD): HResult; stdcall;
  end;

  IVPE = interface(IUnknown)
    ['{BC29A661-30E3-11d0-9E69-00C04FD7C15B}']
    function SetOverlaySurface(lpOverlaySurface: IUnknown;
       iNumBackBuffers: Integer): HResult; stdcall;
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       dv.h
 *
 ***************************************************************************)

const
  DV_SMCHN       = $0000e000;
  DV_AUDIOMODE   = $00000f00;
  DV_AUDIO5060   = $00200000;
  DV_AUDIOSMP    = $38000000;
  DV_AUDIOQU     = $07000000;
  DV_NTSC525_60  = 0;
  DV_PAL625_50   = 1;

  DV_SD          = $00;
  DV_HD          = $01;
  DV_SL          = $02;

  SIZE_DVINFO    = $20;

type
  TDVInfo = record
    //for 1st 5/6 DIF seq.
    dwDVAAuxSrc: DWORD;
    dwDVAAuxCtl: DWORD;
    //for 2nd  5/6 DIF seq.
    dwDVAAuxSrc1: DWORD;
    dwDVAAuxCtl1: DWORD;
    //for video information
    dwDVVAuxSrc: DWORD;
    dwDVVAuxCtl: DWORD;
    dwDVReserved: array[0..1] of DWORD;
  end;

  TDVAudInfo = record
    bAudStyle: array[0..1] of Byte;
    //LSB 6 bits for starting DIF sequence number
    //MSB 2 bits: 0 for mon. 1: stereo in one 5/6 DIF sequences, 2: stereo audio in both 5/6 DIF sequences
    //example: 0x00: mon, audio in first 5/6 DIF sequence
    //                 0x05: mon, audio in 2nd 5 DIF sequence
    //                 0x15: stereo, audio only in 2nd 5 DIF sequence
    //                 0x10: stereo, audio only in 1st 5/6 DIF sequence
    //                 0x20: stereo, left ch in 1st 5/6 DIF sequence, right ch in 2nd 5/6 DIF sequence
    //                 0x26: stereo, rightch in 1st 6 DIF sequence, left ch in 2nd 6 DIF sequence
    bAudQu: array[0..1] of Byte;            //qbits, only support 12, 16,

    bNumAudPin: Byte;                              //how many pin(language)
    wAvgSamplesPerPinPerFrm: array[0..1] of WORD;  //samples size for one audio pin in one frame(which has 10 or 12 DIF sequence)
    wBlkMode: WORD;                                //45 for NTSC, 54 for PAL
    wDIFMode: WORD;                                //5  for NTSC, 6 for PAL
    wBlkDiv: WORD;                                 //15  for NTSC, 18 for PAL
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       vptype.h
 *
 ***************************************************************************)

type
  // enum to specify the criterion, which the vpmixer is supposed to use
  // in order to select the video format
  TAMVP_Select_Format_By = (
    AMVP_DO_NOT_CARE,
    AMVP_BEST_BANDWIDTH,
    AMVP_INPUT_SAME_AS_OUTPUT
  );

  // enum to specify the various mode
  TAMVP_Mode = (
    AMVP_MODE_WEAVE,
    AMVP_MODE_BOBINTERLEAVED,
    AMVP_MODE_BOBNONINTERLEAVED,
    AMVP_MODE_SKIPEVEN,
    AMVP_MODE_SKIPODD
  );

  // struct to specify the width and height. The context could be anything
  // such as scaling cropping etc.
  TAMVPSize = record
    dwWidth: DWORD;                    // the width
    dwHeight: DWORD;                   // the height
  end;

  // struct to specify the dimensional characteristics of the input stream
  TAMVPIMInfo = record
    dwFieldWidth: DWORD;               // Field height of the data
    dwFieldHeight: DWORD;              // Field width of the data
    dwVBIWidth: DWORD;                 // Width of the VBI data
    dwVBIHeight: DWORD;                // Height of the VBI data
    rcValidRegion: TRect;              // The vaild rectangle, used for cropping
  end;


  // struct to specify the various data specific characteristics of the input stream
  TAMVPDataInfo = record
     dwSize: DWORD;                    // Size of the struct
     dwMicrosecondsPerField: DWORD;    // Time taken by each field
     amvpDimInfo: TAMVPIMInfo;         // Dimensional Information
     dwPictAspectRatioX: DWORD;        // X dimension of Picture Aspect Ratio
     dwPictAspectRatioY: DWORD;        // Y dimension of Picture Aspect Ratio
     bEnableDoubleClock: BOOL;         // Videoport should enable double clocking
     bEnableVACT: BOOL;                // Videoport should use an external VACT signal
     bDataIsInterlaced: BOOL;          // Indicates that the signal is interlaced
     lHalfLinesOdd: Longint;           // number of halflines in the odd field
     bFieldPolarityInverted: BOOL;     // Device inverts the polarity by default
     dwNumLinesInVREF: DWORD;          // Number of lines of data in VREF
     lHalfLinesEven: Longint;          // number of halflines in the even field
     dwReserved1: DWORD;               // Reserved for future use
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       vpconfig.h
 *
 ***************************************************************************)

const
  IID_IVPConfig: TGUID = (D1:$BC29A660;D2:$30E3;D3:$11D0;D4:($9E,$69,$00,$C0,$4F,$D7,$C1,$5B));
  IID_IVPVBIConfig: TGUID = (D1:$EC529B00;D2:$1A1F;D3:$11D1;D4:($BA,$D9,$00,$60,$97,$44,$11,$1A));

type
// IVPBaseConfig
  IVPBaseConfig = interface(IUnknown)
    // gets the various connection information structures (guid, portwidth)
    // in an array of structures. If the pointer to the array is NULL, first
    // parameter returns the total number of formats supported.
    function GetConnectInfo(var pdwNumConnectInfo: DWORD;
      var pddVPConnectInfo: DDVIDEOPORTCONNECT): HResult; stdcall;

    // sets the connection entry chosen (0, 1, .. ,(dwNumProposedEntries-1))
    function SetConnectInfo(dwChosenEntry: DWORD): HResult; stdcall;

    // gets various data parameters, includes dimensionnal info
    function GetVPDataInfo(var pamvpDataInfo: TAMVPDataInfo): HResult; stdcall;

    // retrives maximum pixels per second rate expected for a given
    // format and a given scaling factor. If decoder does not support
    // those scaling factors, then it gives the rate and the nearest
    // scaling factors.
    function GetMaxPixelRate(var pamvpSize: TAMVPSize;
      var pdwMaxPixelsPerSecond: DWORD): HResult; stdcall;

    // informs the callee of the videoformats supported by the videoport
    function InformVPInputFormats(dwNumFormats: DWORD;
      const  pDDPixelFormats: DDPIXELFORMAT): HResult; stdcall;

    // gets the various formats supported by the decoder in an array
    // of structures. If the pointer to the array is NULL, first parameter
    // returns the total number of formats supported.
    function GetVideoFormats(var pdwNumFormats: DWORD;
      var pddPixelFormats: DDPIXELFORMAT): HResult; stdcall;

    // sets the format entry chosen (0, 1, .. ,(dwNumProposedEntries-1))
    function SetVideoFormat(dwChosenEntry: DWORD): HResult; stdcall;

    // asks the decoder to treat even fields like odd fields and visa versa
    function SetInvertPolarity: HResult; stdcall;

    // the mixer uses this function to determine if the callee wants
    // the vpmixer to use its overlay surface and if so to get a pointer to it
    function GetOverlaySurface(out ppddOverlaySurface: IDirectDrawSurface): HResult; stdcall;

    // sets the direct draw kernel handle
    function SetDirectDrawKernelHandle(dwDDKernelHandle: DWORD): HResult; stdcall;

    // sets the video port id
    function SetVideoPortID(dwVideoPortID: DWORD): HResult; stdcall;

    // sets the direct draw surface kernel handle
    function SetDDSurfaceKernelHandles(cHandles: DWORD;
        rgDDKernelHandles: DWORD): HResult; stdcall;

    // Tells driver about surface created on its behalf by ovmixer/vbisurf and
    // returned from videoport/ddraw. Should always return NOERROR or E_NOIMPL.
    // dwPitch is the pitch of the surface (distance in pixels between the start
    // pixels of two consecutive lines of the surface). (dwXOrigin, dwYOrigin)
    // are the (X, Y) coordinates of the pixel at which valid data starts.
    function SetSurfaceParameters(dwPitch: DWORD; dwXOrigin, dwYOrigin: DWORD): HResult; stdcall;
  end;

// IVPConfig
  IVPConfig = interface(IVPBaseConfig)
    ['{BC29A660-30E3-11D0-9E69-00C04FD7C15B}']
    // the mixer uses this function to determine if the callee wants
    // the mixer to decimate VIDEO data at its own descrition
    function IsVPDecimationAllowed(var pbIsDecimationAllowed: BOOL): HResult; stdcall;

    // sets the scaling factors. If decoder does not support these,
    // then it sets the values to the nearest factors it can support
    function SetScalingFactors(const pamvpSize: TAMVPSize): HResult; stdcall;
  end;

// IVPVBIConfig
  IVPVBIConfig = interface(IVPBaseConfig)
    ['{EC529B00-1A1F-11D1-BAD9-00609744111A}']
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       vpnotify.h
 *
 ***************************************************************************)

const
  IID_IVPNotify: TGUID = (D1:$C76794A1;D2:$D6C5;D3:$11D0;D4:($9E,$69,$00,$C0,$4F,$D7,$C1,$5B));
  IID_IVPVBINotify: TGUID = (D1:$EC529B01;D2:$1A1F;D3:$11D1;D4:($BA,$D9,$00,$60,$97,$44,$11,$1A));

type
// interface IVPBaseNotify
  IVPBaseNotify = interface(IUnknown)
    // this function initializes the reconnection to the decoder.
    function RenegotiateVPParameters: HResult; stdcall;
  end;

// interface IVPNotify
  IVPNotify = interface(IVPBaseNotify)
    ['{C76794A1-D6C5-11D0-9E69-00C04FD7C15B}']
    // function to set the mode (bob, weave etc)
    function SetDeinterlaceMode(mode: TAMVP_Mode): HResult; stdcall;
    // function to get the mode (bob, weave etc)
    function GetDeinterlaceMode(var pMode: TAMVP_Mode): HResult; stdcall;
    // this function sets the overlay surface that the mixer is supposed to use.
    function SetOverlaySurface(pOverlaySurface: IDirectDrawSurface): HResult; stdcall;
    // this function gets the overlay surface that the mixer is using
    function GetOverlaySurface(out ppOverlaySurface: IDirectDrawSurface): HResult; stdcall;
    // this functions sets the color-controls, if the chip supports it.
    function SetColorControls(const pColorControl: DDCOLORCONTROL): HResult; stdcall;
    // this functions also returns the capability of the hardware in the dwFlags
    // value of the struct.
    function GetColorControls(var pColorControl: DDCOLORCONTROL): HResult; stdcall;
  end;

// interface IVPVBINotify
  IVPVBINotify = interface(IVPBaseNotify)
    ['{EC529B01-1A1F-11D1-BAD9-00609744111A}']
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       mpegtype.h
 *
 ***************************************************************************)

const
  IID_IMpegAudioDecoder: TGUID = (D1:$B45DD570;D2:$3C77;D3:$11D1;D4:($AB,$E1,$00,$A0,$C9,$05,$F3,$75));

type
//
//  AM_MPEGSYSTEMTYPE defines the format block contents for
//  data of type MEDIATYPE_MPEG1System when the format
//  block GUID is FORMAT_MPEG1System
//
//  The format block consists of elements of type
//  AM_MPEGSYSTEMTYPE up to the length of the format block
//  Each format block is 8-byte aligned from the start of
//  the format block
//

  TAM_MPEGSreamType = record
    dwStreamId: DWORD;               // Stream id of stream to process
    dwReserved: DWORD;               // 8-byte alignment
    mt: TAM_Media_Type;              // Type for substream - pbFormat is NULL
    bFormat: array[0..0] of Byte;    // Format data
  end;

  TAM_MPEGSystemType = record
    dwBitRate: DWORD;                // Bits per second
    cStreams: DWORD;                 // Number of streams
    Streams: array[0..0] of TAM_MPEGSreamType;
  end;
{
//
//  Helper macros for AM_MPEGSTREAMTYPE
//
#define AM_MPEGSTREAMTYPE_ELEMENTLENGTH(pStreamType)  \
    FIELD_OFFSET(AM_MPEGSTREAMTYPE, bFormat[(pStreamType)->mt.cbFormat])
#define AM_MPEGSTREAMTYPE_NEXT(pStreamType)           \
    ((AM_MPEGSTREAMTYPE *)((PBYTE)(pStreamType) +     \
     ((AM_MPEGSTREAMTYPE_ELEMENTLENGTH(pStreamType) + 7) & ~7)))
 }
//
// IMpegAudioDecoder
//

// Values for DualMode
const
  AM_MPEG_AUDIO_DUAL_MERGE = 0;
  AM_MPEG_AUDIO_DUAL_LEFT  = 1;
  AM_MPEG_AUDIO_DUAL_RIGHT = 2;

type
//
//
// Microsoft MPEG audio WAV definition
//
(*  MPEG-1 audio wave format (audio layer only).   (0x0050)   *)

  TMPEG1WaveFormat = record
    wfx: TWaveFormatEx;
    fwHeadLayer: Word;
    dwHeadBitrate: DWORD;
    fwHeadMode: Word;
    fwHeadModeExt: Word;
    wHeadEmphasis: Word;
    fwHeadFlags: Word;
    dwPTSLow: DWORD;
    dwPTSHigh: DWORD;
  end;

const
  ACM_MPEG_LAYER1         = $0001;
  ACM_MPEG_LAYER2         = $0002;
  ACM_MPEG_LAYER3         = $0004;
  ACM_MPEG_STEREO         = $0001;
  ACM_MPEG_JOINTSTEREO    = $0002;
  ACM_MPEG_DUALCHANNEL    = $0004;
  ACM_MPEG_SINGLECHANNEL  = $0008;
  ACM_MPEG_PRIVATEBIT     = $0001;
  ACM_MPEG_COPYRIGHT      = $0002;
  ACM_MPEG_ORIGINALHOME   = $0004;
  ACM_MPEG_PROTECTIONBIT  = $0008;
  ACM_MPEG_ID_MPEG1       = $0010;

type
  IMpegAudioDecoder = interface(IUnknown)
    ['{B45DD570-3C77-11D1-ABE1-00A0C905F375}']
    function get_FrequencyDivider(var pDivider: Longint): HResult; stdcall;
    function put_FrequencyDivider(Divider: Longint): HResult; stdcall;
    function get_DecoderAccuracy(var pAccuracy: Longint): HResult; stdcall;
    function put_DecoderAccuracy(Accuracy: Longint): HResult; stdcall;
    function get_Stereo(var pStereo: Longint): HResult; stdcall;
    function put_Stereo(Stereo: Longint): HResult; stdcall;
    function get_DecoderWordSize(var pWordSize: Longint): HResult; stdcall;
    function put_DecoderWordSize(WordSize: Longint): HResult; stdcall;
    function get_IntegerDecode(var pIntDecode: Longint): HResult; stdcall;
    function put_IntegerDecode(IntDecode: Longint): HResult; stdcall;
    function get_DualMode(var pIntDecode: Longint): HResult; stdcall;
    function put_DualMode(IntDecode: Longint): HResult; stdcall;
    function get_AudioFormat(var lpFmt: TMPEG1WaveFormat): HResult; stdcall;
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       il21dec.h
 *
 ***************************************************************************)
// Line 21 Decoder related definitions and interfaces for ActiveMovie

const
  IID_IAMLine21Decoder: TGUID = (D1:$6E8D4A21;D2:$310C;D3:$11D0;D4:($B7,$9A,$00,$AA,$00,$37,$67,$A7));

type
//
//  Some enum data types used as line 21 decoder params by the interface
//
  TAM_Line21_CCLevel = (       // should we use TC1, TC2 in stead?
    AM_L21_CCLEVEL_TC2
  );

  TAM_Line21_CCService = (
    AM_L21_CCSERVICE_None,
    AM_L21_CCSERVICE_Caption1,
    AM_L21_CCSERVICE_Caption2,
    AM_L21_CCSERVICE_Text1,
    AM_L21_CCSERVICE_Text2,
    AM_L21_CCSERVICE_XDS,
    AM_L21_CCSERVICE_INVALID_6,
    AM_L21_CCSERVICE_INVALID_7,
    AM_L21_CCSERVICE_INVALID_8,
    AM_L21_CCSERVICE_INVALID_9,
    AM_L21_CCSERVICE_DefChannel,
    AM_L21_CCSERVICE_Invalid
  );

  TAM_Line21_CCState = (
    AM_L21_CCSTATE_Off,
    AM_L21_CCSTATE_On
  );

  TAM_Line21_CCStyle = (
    AM_L21_CCSTYLE_None,
    AM_L21_CCSTYLE_PopOn,
    AM_L21_CCSTYLE_PaintOn,
    AM_L21_CCSTYLE_RollUp
  );

  TAM_Line21_DrawBGMode = (
    AM_L21_DRAWBGMODE_Opaque,
    AM_L21_DRAWBGMODE_Transparent
  );

//
//  Line 21 Decoder standard COM interface
//
  IAMLine21Decoder = interface(IUnknown)
    ['{6E8D4A21-310C-11D0-B79A-00AA003767A7}']
    //
    // Decoder options to be used by apps
    //

    // What is the decoder's level
    function GetDecoderLevel(var lpLevel: TAM_Line21_CCLevel): HResult; stdcall;
    // supported level value is AM_L21Level_TC2 only
    // skipping the SetDecoderLevel( )

    // Which of the services is being currently used
    function GetCurrentService(var lpService: TAM_Line21_CCService): HResult; stdcall;
    function SetCurrentService(Service: TAM_Line21_CCService): HResult; stdcall;
    // supported service values are AM_L21Service_Caption1,
    // AM_L21Service_Caption2, AM_L21Service_Text1, AM_L21Service_Text2,
    // AM_L21Service_XDS, AM_L21Service_None)

    // Query/Set the service state (On/Off)
    // supported state values are AM_L21State_On and AM_L21State_Off
    function GetServiceState(var lpState: TAM_Line21_CCState): HResult; stdcall;
    function SetServiceState(State: TAM_Line21_CCState): HResult; stdcall;

    //
    // Output options to be used by downstream filters
    //

    // What size, bitdepth etc should the output video be
    function GetOutputFormat(var lpbmih: TBitmapInfoHeader): HResult; stdcall;
    // GetOutputFormat() method, if successful, returns
    // 1.  S_FALSE if no output format has so far been defined by downstream filters
    // 2.  S_OK if an output format has already been defined by downstream filters
    function SetOutputFormat(const lpbmih: TBitmapInfoHeader): HResult; stdcall;

    // Specify physical color to be used in colorkeying the background
    // for overlay mixing
    function GetBackgroundColor(var pdwPhysColor: DWORD): HResult; stdcall;
    function SetBackgroundColor(dwPhysColor: DWORD): HResult; stdcall;

    // Specify if whole output bitmap should be redrawn for each sample
    function GetRedrawAlways(var lpbOption: BOOL): HResult; stdcall;
    function SetRedrawAlways(bOption: BOOL): HResult; stdcall;

    // Specify if the caption text background should be opaque/transparent
    function GetDrawBackgroundMode(var lpMode: TAM_Line21_DrawBGMode): HResult; stdcall;
    function SetDrawBackgroundMode(Mode: TAM_Line21_DrawBGMode): HResult; stdcall;
    // supported mode values are AM_L21_DrawBGMode_Opaque and
    // AM_L21_DrawBGMode_Transparent
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       dvdevcod.h
 *
 ***************************************************************************)
// list of standard DVD-Video event codes and the expected params

const
  EC_DVDBASE                                                    = $0100;

type
  TDVD_Error = (
    DVD_ERROR_INVALID_0,
    DVD_ERROR_Unexpected,           // Something unexpected happened, perhaps content
                                    //   is incorrectly authored.  Playback is stopped.
    DVD_ERROR_CopyProtectFail,      // Key exchange for DVD copy protection failed.
                                    //   Playback is stopped.
    DVD_ERROR_InvalidDVD1_0Disc,    // DVD-Video disc is incorrectly authored for v1.0
                                    //   of spec. Playback is stopped.
    DVD_ERROR_InvalidDiscRegion,    // The Disc is not approved for playback by decoders
                                    //   from this DVD region.
    DVD_ERROR_LowParentalLevel      // Player parental level is lower than the lowest parental
                                    //   level available in the DVD content. Playback is stopped.
  );

  TDVD_Warning = (
    DVD_WARNING_INVALID_0,
    DVD_WARNING_InvalidDVD1_0Disc,   // DVD-Video disc is incorrectly authored. Playback
                                     //   can continue, but unexpected behavior may occur.
    DVD_WARNING_FormatNotSupported   // A decoder would not support the current format.  Playback
                                     //   of a stream (audio, video of SP) may not function.
  );

const

// DVD-Video event codes
// ======================
//
// All DVD-Video event are always passed on to the application, and are
// never processed by the filter graph


  EC_DVD_DOMAIN_CHANGE                    = (EC_DVDBASE + $01);
// Parameters: ( DWORD, void )
// lParam1 is enum DVD_DOMAIN, and indicates the player's new domain
//
// Raised from following domains: all
//
// Signaled when ever the DVD player changes domains.


  EC_DVD_TITLE_CHANGE                     = (EC_DVDBASE + $02);
// Parameters: ( DWORD, void )
// lParam1 is the new title number.
//
// Raised from following domains: DVD_DOMAIN_Title
//
// Indicates when the current title number changes.  Title numbers
// range 1 to 99.  This indicates the TTN, which is the title number
// with respect to the whole disc, not the VTS_TTN which is the title
// number with respect to just a current VTS.


  EC_DVD_CHAPTER_START                   = (EC_DVDBASE + $03);
// Parameters: ( DWORD, void )
// lParam1 is the new chapter number (which is the program number for
// One_Sequential_PGC_Titles).
//
// Raised from following domains: DVD_DOMAIN_Title
//
// Signales that DVD player started playback of a new program in the Title
// domain.  This is only signaled for One_Sequential_PGC_Titles.


  EC_DVD_AUDIO_STREAM_CHANGE              = (EC_DVDBASE + $04);
// Parameters: ( DWORD, void )
// lParam1 is the new user audio stream number.
//
// Raised from following domains: all
//
// Signaled when ever the current user audio stream number changes for the main
// title.  This can be changed automatically with a navigation command on disc
// as well as through IDVDAnnexJ.
// Audio stream numbers range from 0 to 7.  Stream $ffffffff
// indicates that no stream is selected.

  EC_DVD_SUBPICTURE_STREAM_CHANGE         = (EC_DVDBASE + $05);
// Parameters: ( DWORD, void )
// lParam1 is the new user subpicture stream number.
//
// Raised from following domains: all
//
// Signaled when ever the current user subpicture stream number changes for the main
// title.  This can be changed automatically with a navigation command on disc
// as well as through IDVDAnnexJ.
// Subpicture stream numbers range from 0 to 31.  Stream $ffffffff
// indicates that no stream is selected.

  EC_DVD_ANGLE_CHANGE                     = (EC_DVDBASE + $06);
// Parameters: ( DWORD, DWORD )
// lParam1 is the number of available angles.
// lParam2 is the current user angle number.
//
// Raised from following domains: all
//
// Signaled when ever either
//   a) the number of available angles changes, or
//   b) the current user angle number changes.
// Current angle number can be changed automatically with navigation command
// on disc as well as through IDVDAnnexJ.
// When the number of available angles is 1, the current video is not multiangle.
// Angle numbers range from 1 to 9.


  EC_DVD_BUTTON_CHANGE                    = (EC_DVDBASE + $07);
// Parameters: ( DWORD, DWORD )
// lParam1 is the number of available buttons.
// lParam2 is the current selected button number.
//
// Raised from following domains: all
//
// Signaled when ever either
//   a) the number of available buttons changes, or
//   b) the current selected button number changes.
// The current selected button can be changed automatically with navigation
// commands on disc as well as through IDVDAnnexJ.
// Button numbers range from 1 to 36.  Selected button number 0 implies that
// no button is selected.  Note that these button numbers enumerate all
// available button numbers, and do not always correspond to button numbers
// used for IDVDAnnexJ::ButtonSelectAndActivate since only a subset of buttons
// may be activated with ButtonSelectAndActivate.


  EC_DVD_VALID_UOPS_CHANGE                = (EC_DVDBASE + $08);
// Parameters: ( DWORD, void )
// lParam1 is a VALID_UOP_SOMTHING_OR_OTHER bit-field stuct which indicates
//   which IDVDAnnexJ commands are explicitly disable by the DVD disc.
//
// Raised from following domains: all
//
// Signaled when ever the available set of IDVDAnnexJ methods changes.  This
// only indicates which operations are explicited disabled by the content on
// the DVD disc, and does not guarentee that it is valid to call methods
// which are not disabled.  For example, if no buttons are currently present,
// IDVDAnnexJ::ButtonActivate() won't work, even though the buttons are not
// explicitly disabled.


  EC_DVD_STILL_ON                         = (EC_DVDBASE + $09);
// Parameters: ( BOOL, DWORD )
// lParam1 == 0  -->  buttons are available, so StillOff won't work
// lParam1 == 1  -->  no buttons available, so StillOff will work
// lParam2 indicates the number of seconds the still will last, with $ffffffff
//   indicating an infinite still (wait till button or StillOff selected).
//
// Raised from following domains: all
//
// Signaled at the beginning of any still: PGC still, Cell Still, or VOBU Still.
// Note that all combinations of buttons and still are possible (buttons on with
// still on, buttons on with still off, button off with still on, button off
// with still off).

  EC_DVD_STILL_OFF                         = (EC_DVDBASE + $0a);
// Parameters: ( void, void )
//
//   Indicating that any still that is currently active
//   has been released.
//
// Raised from following domains: all
//
// Signaled at the end of any still: PGC still, Cell Still, or VOBU Still.
//

  EC_DVD_CURRENT_TIME                     = (EC_DVDBASE + $0b);
// Parameters: ( DWORD, BOOL )
// lParam1 is a DVD_TIMECODE which indicates the current
//   playback time code in a BCD HH:MM:SS:FF format.
// lParam2 == 0  -->  time code is 25 frames/sec
// lParam2 == 1  -->  time code is 30 frames/sec (non-drop).
//
// Raised from following domains: DVD_DOMAIN_Title
//
// Signaled at the beginning of every VOBU, which occurs every .4 to 1.0 sec.
// This is only signaled for One_Sequential_PGC_Titles.


  EC_DVD_ERROR                            = (EC_DVDBASE + $0c);
// Parameters: ( DWORD, void)
// lParam1 is an enum DVD_ERROR which notifies the app of some error condition.
//
// Raised from following domains: all
//

  EC_DVD_WARNING                           = (EC_DVDBASE + $0d);
// Parameters: ( DWORD, void)
// lParam1 is an enum DVD_WARNING which notifies the app of some warning condition.
//
// Raised from following domains: all
//

  EC_DVD_CHAPTER_AUTOSTOP                  = (EC_DVDBASE + $0e);
// Parameters: (void, void)
//
//  Indicating that playback is stopped as a result of a call
//  to IDVDControl::ChapterPlayAutoStop()
//
// Raised from following domains : DVD_DOMAIN_TITLE
//

  EC_DVD_NO_FP_PGC                         = (EC_DVDBASE + $0f);
//  Parameters : (void, void)
//
//  Raised from the following domains : FP_DOM
//
//  Indicates that the DVD disc does not have a FP_PGC (First Play Program Chain)
//  and the DVD Navigator will not automatically load any PGC and start playback.
//

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       dvdmedia.h
 *
 ***************************************************************************)

type
// -----------------------------------------------------------------------
// AC-3 definition for the AM_KSPROPSETID_AC3 property set
// -----------------------------------------------------------------------
  TAM_Property_AC3 = (
    AM_PROPERTY_AC3_INVALID_0,
    AM_PROPERTY_AC3_ERROR_CONCEALMENT,
    AM_PROPERTY_AC3_ALTERNATE_AUDIO,
    AM_PROPERTY_AC3_DOWNMIX,
    AM_PROPERTY_AC3_BIT_STREAM_MODE,
    AM_PROPERTY_AC3_DIALOGUE_LEVEL,
    AM_PROPERTY_AC3_LANGUAGE_CODE,
    AM_PROPERTY_AC3_ROOM_TYPE
  );

  TAM_AC3_Error_Concelment = record
    fRepeatPreviousBlock: BOOL;
    fErrorInCurrentBlock: BOOL;
  end;

  TAM_AC3_Alteranate_Audio = record
    fStereo: BOOL;
    DualMode: Longint;
  end;

const
  AM_AC3_ALTERNATE_AUDIO_1     = 1;
  AM_AC3_ALTERNATE_AUDIO_2     = 2;
  AM_AC3_ALTERNATE_AUDIO_BOTH   = 3;

type
  TAM_AC3_DownMix = record
    fDownMix: BOOL;
    fDolbySurround: BOOL;
  end;

  TAM_AC3_BitStream_Mode = record
    BitStreamMode: Longint;
  end;

const
  AM_AC3_SERVICE_MAIN_AUDIO            = 0;
  AM_AC3_SERVICE_NO_DIALOG             = 1;
  AM_AC3_SERVICE_VISUALLY_IMPAIRED     = 2;
  AM_AC3_SERVICE_HEARING_IMPAIRED      = 3;
  AM_AC3_SERVICE_DIALOG_ONLY           = 4;
  AM_AC3_SERVICE_COMMENTARY            = 5;
  AM_AC3_SERVICE_EMERGENCY_FLASH       = 6;
  AM_AC3_SERVICE_VOICE_OVER            = 7;

type
  TAM_AC3_Dialogue_Level = record
    DialogueLevel: Longint;
  end;

  TAM_AC3_RoomType = record
    fLargeRoom: BOOL;
  end;

// -----------------------------------------------------------------------
// subpicture definition for the AM_KSPROPSETID_DvdSubPic property set
// -----------------------------------------------------------------------

  TAM_Property_DVDSubpic = (
    AM_PROPERTY_DVDSUBPIC_PALETTE,
    AM_PROPERTY_DVDSUBPIC_HLI,
    AM_PROPERTY_DVDSUBPIC_COMPOSIT_ON   // TRUE for subpicture is displayed
  );

  TAM_DVD_YUV = record
    Reserved: Byte;
    Y: byte;
    U: Byte;
    V: Byte;
  end;

  TAM_Property_SPPAL = record
    sppal: array[0..15] of TAM_DVD_YUV;
  end;

  TAMColCon = record
    emph1col: Byte;
    emph2col: Byte;
    backcol: Byte;
    patcol: Byte;
    emph1con: Byte;
    emph2con: Byte;
    backcon: Byte;
    patcon: Byte;
  end;

  TAM_Property_SPHLI = record
    HLISS: Word;      //
    Reserved: Word;
    StartPTM: Longint;   // start presentation time in x/90000
    EndPTM: Longint;     // end PTM in x/90000
    StartX: Word;
    StartY: Word;
    StopX: Word;
    StopY: Word;
    ColCon: TAMColCon;     // color contrast description (4 bytes as given in HLI)
  end;

  AM_PROPERTY_COMPOSIT_ON = BOOL;

// -----------------------------------------------------------------------
// copy protection definitions
// -----------------------------------------------------------------------

// AM_UseNewCSSKey for the dwTypeSpecificFlags in IMediaSample2 to indicate
// the exact point in a stream after which to start applying a new CSS key.
// This is typically sent on an empty media sample just before attempting
// to renegotiate a CSS key.
const
  AM_UseNewCSSKey    = $1;

//
// AM_KSPROPSETID_CopyProt property set definitions
//
type
  TAM_Property_DVDCopyProt = (
    AM_PROPERTY_DVDCOPY_INVALID_0,
    AM_PROPERTY_DVDCOPY_CHLG_KEY,
    AM_PROPERTY_DVDCOPY_DVD_KEY1,
    AM_PROPERTY_DVDCOPY_DEC_KEY2,
    AM_PROPERTY_DVDCOPY_TITLE_KEY,
    AM_PROPERTY_COPY_MACROVISION,
    AM_PROPERTY_DVDCOPY_REGION,
    AM_PROPERTY_DVDCOPY_SET_COPY_STATE,
    AM_PROPERTY_DVDCOPY_INVALID_8,
    AM_PROPERTY_DVDCOPY_INVALID_9,
    AM_PROPERTY_DVDCOPY_INVALID_10,
    AM_PROPERTY_DVDCOPY_INVALID_11,
    AM_PROPERTY_DVDCOPY_INVALID_12,
    AM_PROPERTY_DVDCOPY_INVALID_13,
    AM_PROPERTY_DVDCOPY_INVALID_14,
    AM_PROPERTY_DVDCOPY_INVALID_15,
    AM_PROPERTY_DVDCOPY_INVALID_16,
    AM_PROPERTY_DVDCOPY_INVALID_17,
    AM_PROPERTY_DVDCOPY_INVALID_18,
    AM_PROPERTY_DVDCOPY_INVALID_19,
    AM_PROPERTY_DVDCOPY_INVALID_20,
    AM_PROPERTY_DVDCOPY_INVALID_21,
    AM_PROPERTY_DVDCOPY_INVALID_22,
    AM_PROPERTY_DVDCOPY_INVALID_23,
    AM_PROPERTY_DVDCOPY_INVALID_24,
    AM_PROPERTY_DVDCOPY_INVALID_25,
    AM_PROPERTY_DVDCOPY_INVALID_26,
    AM_PROPERTY_DVDCOPY_INVALID_27,
    AM_PROPERTY_DVDCOPY_INVALID_28,
    AM_PROPERTY_DVDCOPY_INVALID_29,
    AM_PROPERTY_DVDCOPY_INVALID_30,
    AM_PROPERTY_DVDCOPY_INVALID_31,
    AM_PROPERTY_DVDCOPY_INVALID_32,
    AM_PROPERTY_DVDCOPY_INVALID_33,
    AM_PROPERTY_DVDCOPY_INVALID_34,
    AM_PROPERTY_DVDCOPY_INVALID_35,
    AM_PROPERTY_DVDCOPY_INVALID_36,
    AM_PROPERTY_DVDCOPY_INVALID_37,
    AM_PROPERTY_DVDCOPY_INVALID_38,
    AM_PROPERTY_DVDCOPY_INVALID_39,
    AM_PROPERTY_DVDCOPY_INVALID_40,
    AM_PROPERTY_DVDCOPY_INVALID_41,
    AM_PROPERTY_DVDCOPY_INVALID_42,
    AM_PROPERTY_DVDCOPY_INVALID_43,
    AM_PROPERTY_DVDCOPY_INVALID_44,
    AM_PROPERTY_DVDCOPY_INVALID_45,
    AM_PROPERTY_DVDCOPY_INVALID_46,
    AM_PROPERTY_DVDCOPY_INVALID_47,
    AM_PROPERTY_DVDCOPY_INVALID_48,
    AM_PROPERTY_DVDCOPY_INVALID_49,
    AM_PROPERTY_DVDCOPY_INVALID_50,
    AM_PROPERTY_DVDCOPY_INVALID_51,
    AM_PROPERTY_DVDCOPY_INVALID_52,
    AM_PROPERTY_DVDCOPY_INVALID_53,
    AM_PROPERTY_DVDCOPY_INVALID_54,
    AM_PROPERTY_DVDCOPY_INVALID_55,
    AM_PROPERTY_DVDCOPY_INVALID_56,
    AM_PROPERTY_DVDCOPY_INVALID_57,
    AM_PROPERTY_DVDCOPY_INVALID_58,
    AM_PROPERTY_DVDCOPY_INVALID_59,
    AM_PROPERTY_DVDCOPY_INVALID_60,
    AM_PROPERTY_DVDCOPY_INVALID_61,
    AM_PROPERTY_DVDCOPY_INVALID_62,
    AM_PROPERTY_DVDCOPY_INVALID_63,
    AM_PROPERTY_DVDCOPY_INVALID_64,
    AM_PROPERTY_DVDCOPY_INVALID_65,
    AM_PROPERTY_DVDCOPY_INVALID_66,
    AM_PROPERTY_DVDCOPY_INVALID_67,
    AM_PROPERTY_DVDCOPY_INVALID_68,
    AM_PROPERTY_DVDCOPY_INVALID_69,
    AM_PROPERTY_DVDCOPY_INVALID_70,
    AM_PROPERTY_DVDCOPY_INVALID_71,
    AM_PROPERTY_DVDCOPY_INVALID_72,
    AM_PROPERTY_DVDCOPY_INVALID_73,
    AM_PROPERTY_DVDCOPY_INVALID_74,
    AM_PROPERTY_DVDCOPY_INVALID_75,
    AM_PROPERTY_DVDCOPY_INVALID_76,
    AM_PROPERTY_DVDCOPY_INVALID_77,
    AM_PROPERTY_DVDCOPY_INVALID_78,
    AM_PROPERTY_DVDCOPY_INVALID_79,
    AM_PROPERTY_DVDCOPY_INVALID_80,
    AM_PROPERTY_DVDCOPY_INVALID_81,
    AM_PROPERTY_DVDCOPY_INVALID_82,
    AM_PROPERTY_DVDCOPY_INVALID_83,
    AM_PROPERTY_DVDCOPY_INVALID_84,
    AM_PROPERTY_DVDCOPY_INVALID_85,
    AM_PROPERTY_DVDCOPY_INVALID_86,
    AM_PROPERTY_DVDCOPY_INVALID_87,
    AM_PROPERTY_DVDCOPY_INVALID_88,
    AM_PROPERTY_DVDCOPY_INVALID_89,
    AM_PROPERTY_DVDCOPY_INVALID_90,
    AM_PROPERTY_DVDCOPY_INVALID_91,
    AM_PROPERTY_DVDCOPY_INVALID_92,
    AM_PROPERTY_DVDCOPY_INVALID_93,
    AM_PROPERTY_DVDCOPY_INVALID_94,
    AM_PROPERTY_DVDCOPY_INVALID_95,
    AM_PROPERTY_DVDCOPY_INVALID_96,
    AM_PROPERTY_DVDCOPY_INVALID_97,
    AM_PROPERTY_DVDCOPY_INVALID_98,
    AM_PROPERTY_DVDCOPY_INVALID_99,
    AM_PROPERTY_DVDCOPY_INVALID_100,
    AM_PROPERTY_DVDCOPY_INVALID_101,
    AM_PROPERTY_DVDCOPY_INVALID_102,
    AM_PROPERTY_DVDCOPY_INVALID_103,
    AM_PROPERTY_DVDCOPY_INVALID_104,
    AM_PROPERTY_DVDCOPY_INVALID_105,
    AM_PROPERTY_DVDCOPY_INVALID_106,
    AM_PROPERTY_DVDCOPY_INVALID_107,
    AM_PROPERTY_DVDCOPY_INVALID_108,
    AM_PROPERTY_DVDCOPY_INVALID_109,
    AM_PROPERTY_DVDCOPY_INVALID_110,
    AM_PROPERTY_DVDCOPY_INVALID_111,
    AM_PROPERTY_DVDCOPY_INVALID_112,
    AM_PROPERTY_DVDCOPY_INVALID_113,
    AM_PROPERTY_DVDCOPY_INVALID_114,
    AM_PROPERTY_DVDCOPY_INVALID_115,
    AM_PROPERTY_DVDCOPY_INVALID_116,
    AM_PROPERTY_DVDCOPY_INVALID_117,
    AM_PROPERTY_DVDCOPY_INVALID_118,
    AM_PROPERTY_DVDCOPY_INVALID_119,
    AM_PROPERTY_DVDCOPY_INVALID_120,
    AM_PROPERTY_DVDCOPY_INVALID_121,
    AM_PROPERTY_DVDCOPY_INVALID_122,
    AM_PROPERTY_DVDCOPY_INVALID_123,
    AM_PROPERTY_DVDCOPY_INVALID_124,
    AM_PROPERTY_DVDCOPY_INVALID_125,
    AM_PROPERTY_DVDCOPY_INVALID_126,
    AM_PROPERTY_DVDCOPY_INVALID_127,
    AM_PROPERTY_DVDCOPY_DISC_KEY);

  TAM_DVDCopy_ChlgKey = record
    ChlgKey: array[0..9] of Byte;
    Reserved: array[0..1] of Byte;
  end;

  TAM_DVDCopy_BusKey = record
    BusKey: array[0..4] of Byte;
    Reserved: array[0..0] of Byte;
  end;

  TAM_DVDCopy_DiscKey = record
    DiscKey: array[0..2047] of Byte;
  end;

  TAM_DVDCopy_TitleKey = record
    KeyFlags: Longint;
    Reserved1: array[0..1] of Longint;
    TitleKey: array[0..5] of Byte;
    Reserved2: array[0..1] of Byte;
  end;

  TAM_Copy_MacroVision = record
    MACROVISIONLevel: Longint;
  end;

  TAM_DVDCopy_Set_Copy_State = record
    DVDCopyState: Longint;
  end;

  TAM_DVDCopyState = (
    AM_DVDCOPYSTATE_INITIALIZE,
    AM_DVDCOPYSTATE_INITIALIZE_TITLE,   // indicates we are starting a title
                                                                            // key copy protection sequence
    AM_DVDCOPYSTATE_AUTHENTICATION_NOT_REQUIRED,
    AM_DVDCOPYSTATE_AUTHENTICATION_REQUIRED,
    AM_DVDCOPYSTATE_DONE
  );

  TAM_Copy_MacroVision_Level = (
    AM_MACROVISION_DISABLED,
    AM_MACROVISION_LEVEL1,
    AM_MACROVISION_LEVEL2,
    AM_MACROVISION_LEVEL3
  );

// CSS region stucture
  TDVD_Region = record
    CopySystem: Byte;
    RegionData: Byte;
    SystemRegion: Byte;
    Reserved: Byte;
  end;

//
// CGMS Copy Protection Flags
//

const
  AM_DVD_CGMS_RESERVED_MASK      = $00000078;

  AM_DVD_CGMS_COPY_PROTECT_MASK  = $00000018;
  AM_DVD_CGMS_COPY_PERMITTED     = $00000000;
  AM_DVD_CGMS_COPY_ONCE          = $00000010;
  AM_DVD_CGMS_NO_COPY            = $00000018;

  AM_DVD_COPYRIGHT_MASK          = $00000040;
  AM_DVD_NOT_COPYRIGHTED         = $00000000;
  AM_DVD_COPYRIGHTED             = $00000040;

  AM_DVD_SECTOR_PROTECT_MASK     = $00000020;
  AM_DVD_SECTOR_NOT_PROTECTED    = $00000000;
  AM_DVD_SECTOR_PROTECTED        = $00000020;


// -----------------------------------------------------------------------
// video format blocks
// -----------------------------------------------------------------------

type
  TAM_MPEG2Level = (
    AM_MPEG2Level_INVALID_0,
    AM_MPEG2Level_Low,
    AM_MPEG2Level_Main,
    AM_MPEG2Level_High1440,
    AM_MPEG2Level_High
  );

  TAM_MPEG2Profile = (
    AM_MPEG2Profile_0,
    AM_MPEG2Profile_Simple,
    AM_MPEG2Profile_Main,
    AM_MPEG2Profile_SNRScalable,
    AM_MPEG2Profile_SpatiallyScalable,
    AM_MPEG2Profile_High
  );

const
  AMINTERLACE_IsInterlaced             = $00000001;  // if 0, other interlace bits are irrelevent
  AMINTERLACE_1FieldPerSample          = $00000002;  // else 2 fields per media sample
  AMINTERLACE_Field1First              = $00000004;  // else Field 2 is first;  top field in PAL is field 1, top field in NTSC is field 2?
  AMINTERLACE_UNUSED                   = $00000008;  //
  AMINTERLACE_FieldPatternMask         = $00000030;  // use this mask with AMINTERLACE_FieldPat*
  AMINTERLACE_FieldPatField1Only       = $00000000;  // stream never contains a Field2
  AMINTERLACE_FieldPatField2Only       = $00000010;  // stream never contains a Field1
  AMINTERLACE_FieldPatBothRegular      = $00000020;  // There will be a Field2 for every Field1 (required for Weave?)
  AMINTERLACE_FieldPatBothIrregular    = $00000030;  // Random pattern of Field1s and Field2s
  AMINTERLACE_DisplayModeMask          = $000000c0;
  AMINTERLACE_DisplayModeBobOnly       = $00000000;
  AMINTERLACE_DisplayModeWeaveOnly     = $00000040;
  AMINTERLACE_DisplayModeBobOrWeave    = $00000080;

  AMCOPYPROTECT_RestrictDuplication    = $00000001;  // duplication of this stream should be restricted

  AMMPEG2_DoPanScan            = $00000001;  //if set, the MPEG-2 video decoder should crop output image
                                                //  based on pan-scan vectors in picture_display_extension
                                                //  and change the picture aspect ratio accordingly.
  AMMPEG2_DVDLine21Field1      = $00000002;  //if set, the MPEG-2 decoder must be able to produce an output
                                                //  pin for DVD style closed caption data found in GOP layer of field 1
  AMMPEG2_DVDLine21Field2      = $00000004;  //if set, the MPEG-2 decoder must be able to produce an output
                                                //  pin for DVD style closed caption data found in GOP layer of field 2
  AMMPEG2_SourceIsLetterboxed  = $00000008;  //if set, indicates that black bars have been encoded in the top
                                                //  and bottom of the video.
  AMMPEG2_FilmCameraMode       = $00000010;  //if set, indicates "film mode" used for 625/50 content.  If cleared,
                                                //  indicates that "camera mode" was used.
  AMMPEG2_LetterboxAnalogOut   = $00000020;  //if set and this stream is sent to an analog output, it should
                        //  be letterboxed.  Streams sent to VGA should be letterboxed only by renderers.

type
  TVideoInfoHeader2 = record
    rcSource: TRect;
    rcTarget: TRect;
    dwBitRate: DWORD;
    dwBitErrorRate: DWORD;
    AvgTimePerFrame: TReference_Time;
    dwInterlaceFlags: DWORD;         // use AMINTERLACE_* defines. Reject connection if undefined bits are not 0
    dwCopyProtectFlags: DWORD;       // use AMCOPYPROTECT_* defines. Reject connection if undefined bits are not 0
    dwPictAspectRatioX: DWORD;       // X dimension of picture aspect ratio, e.g. 16 for 16x9 display
    dwPictAspectRatioY: DWORD;       // Y dimension of picture aspect ratio, e.g.  9 for 16x9 display
    dwReserved1: DWORD;              // must be 0; reject connection otherwise
    dwReserved2: DWORD;              // must be 0; reject connection otherwise
    bmiHeader: TBitmapInfoHeader;
  end;

  TMPEG2VideoInfo = record
     hdr: TVideoInfoHeader;
     dwStartTimeCode: DWORD;                 //  ?? not used for DVD ??
     cbSequenceHeader: DWORD;                // is 0 for DVD (no sequence header)
     dwProfile: DWORD;                       // use enum MPEG2Profile
     dwLevel: DWORD;                         // use enum MPEG2Level
     dwFlags: DWORD;                         // use AMMPEG2_* defines.  Reject connection if undefined bits are not 0
     dwSequenceHeader: array[0..0] of DWORD; // DWORD instead of Byte for alignment purposes
                                               //   For MPEG-2, if a sequence_header is included, the sequence_extension
                                               //   should also be included
  end;
{
#define SIZE_MPEG2VIDEOINFO(pv) (FIELD_OFFSET(MPEG2VIDEOINFO, bSequenceHeader[0]) + (pv)->cbSequenceHeader)
#define MPEG1_SEQUENCE_INFO(pv) ((const BYTE *)(pv)->bSequenceHeader)
 }

//===================================================================================
// flags for dwTypeSpecificFlags in AM_SAMPLE2_PROPERTIES which define type specific
// data in IMediaSample2
//===================================================================================

const
  AM_VIDEO_FLAG_FIELD_MASK          = $0003;    // use this mask to check whether the sample is field1 or field2 or frame
  AM_VIDEO_FLAG_INTERLEAVED_FRAME   = $0000;    // the sample is a frame (remember to use AM_VIDEO_FLAG_FIELD_MASK when using this)
  AM_VIDEO_FLAG_FIELD1              = $0001;    // the sample is field1 (remember to use AM_VIDEO_FLAG_FIELD_MASK when using this)
  AM_VIDEO_FLAG_FIELD2              = $0002;    // the sample is the field2 (remember to use AM_VIDEO_FLAG_FIELD_MASK when using this)
  AM_VIDEO_FLAG_FIELD1FIRST         = $0004;    // if set means display field1 first, else display field2 first.
                                        // this bit is irrelavant for 1FieldPerSample mode
  AM_VIDEO_FLAG_WEAVE               = $0008;    // if set use bob display mode else weave
  AM_VIDEO_FLAG_IPB_MASK            = $0030;    // use this mask to check whether the sample is I, P or B
  AM_VIDEO_FLAG_I_SAMPLE            = $0000;    // I Sample (remember to use AM_VIDEO_FLAG_IPB_MASK when using this)
  AM_VIDEO_FLAG_P_SAMPLE            = $0010;    // P Sample (remember to use AM_VIDEO_FLAG_IPB_MASK when using this)
  AM_VIDEO_FLAG_B_SAMPLE            = $0020;    // B Sample (remember to use AM_VIDEO_FLAG_IPB_MASK when using this)
  AM_VIDEO_FLAG_REPEAT_FIELD        = $0040;    // if set means display the field which has been displayed first again after displaying
                                        // both fields first. This bit is irrelavant for 1FieldPerSample mode
// -----------------------------------------------------------------------
// AM_KSPROPSETID_TSRateChange property set definitions for time stamp
// rate changes.
// -----------------------------------------------------------------------
type
  TAM_Property_TS_Rate_Change = (
    AM_RATE_INVALID_0,
    AM_RATE_SimpleRateChange,   // rw, use AM_SimpleRateChange
    AM_RATE_ExactRateChange,    // rw, use AM_ExactRateChange
    AM_RATE_MaxFullDataRate,    // r, use AM_MaxFullDataRate
    AM_RATE_Step                // w, use AM_Step
  );

  TAM_SimpleRateChange = record
    // this is the simplest mechinism to set a time stamp rate change on
    // a filter (simplest for the person setting the rate change, harder
    // for the filter doing the rate change).
    StartTime: TReference_Time;    //stream time at which to start this rate
    Rate: Longint;                //new rate * 10000 (decimal)
  end;

  TAM_ExactRateChange = record
    OutputZeroTime: TReference_Time;   //input TS that maps to zero output TS
    Rate: Longint;                    //new rate * 10000 (decimal)
  end;

  TAM_MaxFullDateRate = Longint;    //rate * 10000 (decimal)

  TAM_Step = DWORD;        // number of frame to step

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       activecf.h
 *
 ***************************************************************************)

const
  CFSTR_VFW_FILTERLIST = 'Video for Windows 4 Filters';

type
  TVFW_FilterList = record
    cFilters: UINT;                     // number of CLSIDs in aClsId
    aClsId: array[0..0] of TGUID;       // ClsId of each filter
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       ddkernel.h
 *
 ***************************************************************************)

const
  IID_IDirectDrawKernel: TGUID = (D1:$8D56C120;D2:$6A08;D3:$11D0;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  IID_IDirectDrawSurfaceKernel: TGUID = (D1:$60755DA0;D2:$6A40;D3:$11D0;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));

type
  DDKERNELCAPS = record
    dwSize: DWORD;                // size of the DDKERNELCAPS structure
    dwCaps: DWORD;                // indicates which fields contain data
    dwIRQCaps: DWORD;             // max width of the video port field
  end;

{ IDirectDrawKernel Interface }

  IDirectDrawKernel = interface(IUnknown)
    ['{8D56C120-6A08-11D0-9B06-00A0C903A3B8}']
    (*** IDirectDrawKernel methods ***)
    function GetCaps(var lpDDKernelCaps: DDKERNELCAPS): HResult; stdcall;
    function GetKernelHandle(var lpKernelHandle: DWORD): HResult; stdcall;
    function ReleaseKernelHandle(KernelHandle: DWORD): HResult; stdcall;
  end;

{ IDirectDrawSurfaceKernel Interface }

  IDirectDrawSurfaceKernel = interface(IUnknown)
    ['{8D56C120-6A08-11D0-9B06-00A0C903A3B8}']
    (*** IDirectDrawSurfaceKernel methods ***)
    function GetKernelHandle(var lpKernelHandle: DWORD): HResult; stdcall;
    function ReleaseKernelHandle(KernelHandle: DWORD): HResult; stdcall;
  end;

const
{ DDKERNELCAPS CAPS }

  DDKERNELCAPS_SKIPFIELDS       = $00000001;
  DDKERNELCAPS_AUTOFLIP         = $00000002;
  DDKERNELCAPS_SETSTATE         = $00000004;
  DDKERNELCAPS_LOCK             = $00000008;
  DDKERNELCAPS_FLIPVIDEOPORT    = $00000010;
  DDKERNELCAPS_FLIPOVERLAY      = $00000020;
  DDKERNELCAPS_TRANSFER_SYSMEM  = $00000040;
  DDKERNELCAPS_TRANSFER_AGP     = $00000080;
  DDKERNELCAPS_FIELDPOLARITY    = $00000100;

{ DDKERNELCAPS IRQ CAPS }

  DDIRQ_DISPLAY_VSYNC  = $00000001;
  DDIRQ_RESERVED1      = $00000002;
  DDIRQ_VPORT0_VSYNC   = $00000004;
  DDIRQ_VPORT0_LINE    = $00000008;
  DDIRQ_VPORT1_VSYNC   = $00000010;
  DDIRQ_VPORT1_LINE    = $00000020;
  DDIRQ_VPORT2_VSYNC   = $00000040;
  DDIRQ_VPORT2_LINE    = $00000080;
  DDIRQ_VPORT3_VSYNC   = $00000100;
  DDIRQ_VPORT3_LINE    = $00000200;
  DDIRQ_VPORT4_VSYNC   = $00000400;
  DDIRQ_VPORT4_LINE    = $00000800;
  DDIRQ_VPORT5_VSYNC   = $00001000;
  DDIRQ_VPORT5_LINE    = $00002000;
  DDIRQ_VPORT6_VSYNC   = $00004000;
  DDIRQ_VPORT6_LINE    = $00008000;
  DDIRQ_VPORT7_VSYNC   = $00010000;
  DDIRQ_VPORT7_LINE    = $00020000;
  DDIRQ_VPORT8_VSYNC   = $00040000;
  DDIRQ_VPORT8_LINE    = $00080000;
  DDIRQ_VPORT9_VSYNC   = $00010000;
  DDIRQ_VPORT9_LINE    = $00020000;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       vfwmsgs.h
 *
 ***************************************************************************)

const
//
// Define the severity codes
//

  VFW_E_INVALIDMEDIATYPE            = $80040200;
  VFW_E_INVALIDSUBTYPE              = $80040201;
  VFW_E_NEED_OWNER                  = $80040202;
  VFW_E_ENUM_OUT_OF_SYNC            = $80040203;
  VFW_E_ALREADY_CONNECTED           = $80040204;
  VFW_E_FILTER_ACTIVE               = $80040205;
  VFW_E_NO_TYPES                    = $80040206;
  VFW_E_NO_ACCEPTABLE_TYPES         = $80040207;
  VFW_E_INVALID_DIRECTION           = $80040208;
  VFW_E_NOT_CONNECTED               = $80040209;
  VFW_E_NO_ALLOCATOR                = $8004020A;
  VFW_E_RUNTIME_ERROR               = $8004020B;
  VFW_E_BUFFER_NOTSET               = $8004020C;
  VFW_E_BUFFER_OVERFLOW             = $8004020D;
  VFW_E_BADALIGN                    = $8004020E;
  VFW_E_ALREADY_COMMITTED           = $8004020F;
  VFW_E_BUFFERS_OUTSTANDING         = $80040210;
  VFW_E_NOT_COMMITTED               = $80040211;
  VFW_E_SIZENOTSET                  = $80040212;
  VFW_E_NO_CLOCK                    = $80040213;
  VFW_E_NO_SINK                     = $80040214;
  VFW_E_NO_INTERFACE                = $80040215;
  VFW_E_NOT_FOUND                   = $80040216;
  VFW_E_CANNOT_CONNECT              = $80040217;
  VFW_E_CANNOT_RENDER               = $80040218;
  VFW_E_CHANGING_FORMAT             = $80040219;
  VFW_E_NO_COLOR_KEY_SET            = $8004021A;
  VFW_E_NOT_OVERLAY_CONNECTION      = $8004021B;
  VFW_E_NOT_SAMPLE_CONNECTION       = $8004021C;
  VFW_E_PALETTE_SET                 = $8004021D;
  VFW_E_COLOR_KEY_SET               = $8004021E;
  VFW_E_NO_COLOR_KEY_FOUND          = $8004021F;
  VFW_E_NO_PALETTE_AVAILABLE        = $80040220;
  VFW_E_NO_DISPLAY_PALETTE          = $80040221;
  VFW_E_TOO_MANY_COLORS             = $80040222;
  VFW_E_STATE_CHANGED               = $80040223;
  VFW_E_NOT_STOPPED                 = $80040224;
  VFW_E_NOT_PAUSED                  = $80040225;
  VFW_E_NOT_RUNNING                 = $80040226;
  VFW_E_WRONG_STATE                 = $80040227;
  VFW_E_START_TIME_AFTER_END        = $80040228;
  VFW_E_INVALID_RECT                = $80040229;
  VFW_E_TYPE_NOT_ACCEPTED           = $8004022A;
  VFW_E_SAMPLE_REJECTED             = $8004022B;
  VFW_E_SAMPLE_REJECTED_EOS         = $8004022C;
  VFW_E_DUPLICATE_NAME              = $8004022D;
  VFW_S_DUPLICATE_NAME              = $0004022D;
  VFW_E_TIMEOUT                     = $8004022E;
  VFW_E_INVALID_FILE_FORMAT         = $8004022F;
  VFW_E_ENUM_OUT_OF_RANGE           = $80040230;
  VFW_E_CIRCULAR_GRAPH              = $80040231;
  VFW_E_NOT_ALLOWED_TO_SAVE         = $80040232;
  VFW_E_TIME_ALREADY_PASSED         = $80040233;
  VFW_E_ALREADY_CANCELLED           = $80040234;
  VFW_E_CORRUPT_GRAPH_FILE          = $80040235;
  VFW_E_ADVISE_ALREADY_SET          = $80040236;
  VFW_S_STATE_INTERMEDIATE          = $00040237;
  VFW_E_NO_MODEX_AVAILABLE          = $80040238;
  VFW_E_NO_ADVISE_SET               = $80040239;
  VFW_E_NO_FULLSCREEN               = $8004023A;
  VFW_E_IN_FULLSCREEN_MODE          = $8004023B;
  VFW_E_UNKNOWN_FILE_TYPE           = $80040240;
  VFW_E_CANNOT_LOAD_SOURCE_FILTER   = $80040241;
  VFW_S_PARTIAL_RENDER              = $00040242;
  VFW_E_FILE_TOO_SHORT              = $80040243;
  VFW_E_INVALID_FILE_VERSION        = $80040244;
  VFW_S_SOME_DATA_IGNORED           = $00040245;
  VFW_S_CONNECTIONS_DEFERRED        = $00040246;
  VFW_E_INVALID_CLSID               = $80040247;
  VFW_E_INVALID_MEDIA_TYPE          = $80040248;
  VFW_E_BAD_KEY                     = $800403F2;
  VFW_S_NO_MORE_ITEMS               = $00040103;
  VFW_E_SAMPLE_TIME_NOT_SET         = $80040249;
  VFW_S_RESOURCE_NOT_NEEDED         = $00040250;
  VFW_E_MEDIA_TIME_NOT_SET          = $80040251;
  VFW_E_NO_TIME_FORMAT_SET          = $80040252;
  VFW_E_MONO_AUDIO_HW               = $80040253;
  VFW_S_MEDIA_TYPE_IGNORED          = $00040254;
  VFW_E_NO_AUDIO_HARDWARE           = $80040256;
  VFW_S_VIDEO_NOT_RENDERED          = $00040257;
  VFW_S_AUDIO_NOT_RENDERED          = $00040258;
  VFW_E_RPZA                        = $80040259;
  VFW_S_RPZA                        = $0004025A;
  VFW_E_PROCESSOR_NOT_SUITABLE      = $8004025B;
  VFW_E_UNSUPPORTED_AUDIO           = $8004025C;
  VFW_E_UNSUPPORTED_VIDEO           = $8004025D;
  VFW_E_MPEG_NOT_CONSTRAINED        = $8004025E;
  VFW_E_NOT_IN_GRAPH                = $8004025F;
  VFW_S_ESTIMATED                   = $00040260;
  VFW_E_NO_TIME_FORMAT              = $80040261;
  VFW_E_READ_ONLY                   = $80040262;
  VFW_S_RESERVED                    = $00040263;
  VFW_E_BUFFER_UNDERFLOW            = $80040264;
  VFW_E_UNSUPPORTED_STREAM          = $80040265;
  VFW_E_NO_TRANSPORT                = $80040266;
  VFW_S_STREAM_OFF                  = $00040267;
  VFW_S_CANT_CUE                    = $00040268;
  VFW_E_BAD_VIDEOCD                 = $80040269;
  VFW_S_NO_STOP_TIME                = $00040270;
  VFW_E_OUT_OF_VIDEO_MEMORY         = $80040271;
  VFW_E_VP_NEGOTIATION_FAILED       = $80040272;
  VFW_E_DDRAW_CAPS_NOT_SUITABLE     = $80040273;
  VFW_E_NO_VP_HARDWARE              = $80040274;
  VFW_E_NO_CAPTURE_HARDWARE         = $80040275;
  VFW_E_DVD_OPERATION_INHIBITED     = $80040276;
  VFW_E_DVD_INVALIDDOMAIN           = $80040277;
  VFW_E_DVD_GRAPHNOTREADY           = $80040279;
  VFW_E_DVD_RENDERFAIL              = $8004027A;
  VFW_E_DVD_DECNOTENOUGH            = $8004027B;
  VFW_E_DDRAW_VERSION_NOT_SUITABLE  = $8004027C;

  E_PROP_SET_UNSUPPORTED            = $80070492;
  E_PROP_ID_UNSUPPORTED             = $80070490;


(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       edevdefs.h
 *
 ***************************************************************************)

const
  ED_BASE                                 = $1000;

// this is used to tell the device communications object which
// physical communications port to use.
  DEV_PORT_SIM                            = 1;
  DEV_PORT_COM1                           = 2;
  DEV_PORT_COM2                           = 3;
  DEV_PORT_COM3                           = 4;
  DEV_PORT_COM4                           = 5;
  DEV_PORT_DIAQ                           = 6;
  DEV_PORT_ARTI                           = 7;
  DEV_PORT_1394                           = 8;
  DEV_PORT_USB                            = 9;
  DEV_PORT_MIN                            = DEV_PORT_SIM;
  DEV_PORT_MAX                            = DEV_PORT_USB;

//      IAMExtDevice Capability Items:  unless otherwise specified, these items return
//         OATRUE or OAFALSE.  All return values are in pdwValue unless otherwise specified:

  ED_DEVCAP_CAN_RECORD                    = ED_BASE+1;
  ED_DEVCAP_CAN_RECORD_STROBE             = ED_BASE+2;
  ED_DEVCAP_HAS_AUDIO                     = ED_BASE+3;
  ED_DEVCAP_HAS_VIDEO                     = ED_BASE+4;
  ED_DEVCAP_USES_FILES                    = ED_BASE+5;
  ED_DEVCAP_CAN_SAVE                      = ED_BASE+6;
  ED_DEVCAP_DEVICE_TYPE                   = ED_BASE+7;
  ED_DEVTYPE_VCR                          = ED_BASE+8;
  ED_DEVTYPE_LASERDISK                    = ED_BASE+9;
  ED_DEVTYPE_ATR                          = ED_BASE+10;
  ED_DEVTYPE_DDR                          = ED_BASE+11;
  ED_DEVTYPE_ROUTER                       = ED_BASE+12;
  ED_DEVTYPE_KEYER                        = ED_BASE+13;
  ED_DEVTYPE_MIXER_VIDEO                  = ED_BASE+14;
  ED_DEVTYPE_DVE                          = ED_BASE+15;
  ED_DEVTYPE_WIPEGEN                      = ED_BASE+16;
  ED_DEVTYPE_MIXER_AUDIO                  = ED_BASE+17;
  ED_DEVTYPE_CG                           = ED_BASE+18;
  ED_DEVTYPE_TBC                          = ED_BASE+19;
  ED_DEVTYPE_TCG                          = ED_BASE+20;
  ED_DEVTYPE_GPI                          = ED_BASE+21;
  ED_DEVTYPE_JOYSTICK                     = ED_BASE+22;
  ED_DEVTYPE_KEYBOARD                     = ED_BASE+23;

// returns mfr-specific ID from external device.
  ED_DEVCAP_EXTERNAL_DEVICE_ID            = ED_BASE+24;

  ED_DEVCAP_TIMECODE_READ                 = ED_BASE+25;
  ED_DEVCAP_TIMECODE_WRITE                = ED_BASE+26;
//      used for seekable non-timecode enabled devices
  ED_DEVCAP_CTLTRK_READ                   = ED_BASE+27;
//      used for seekable non-timecode enabled devices
  ED_DEVCAP_INDEX_READ                    = ED_BASE+28;

// returns device preroll time in current time format
  ED_DEVCAP_PREROLL                       = ED_BASE+29;
// returns device postroll time in current time format
  ED_DEVCAP_POSTROLL                     = ED_BASE+30;

// returns indication of device’s synchronization accuracy.
  ED_DEVCAP_SYNC_ACCURACY                = ED_BASE+31;
  ED_SYNCACC_PRECISE                     = ED_BASE+32;
  ED_SYNCACC_FRAME                       = ED_BASE+33;
  ED_SYNCACC_ROUGH                       = ED_BASE+34;

// returns device’s normal framerate.
  ED_DEVCAP_NORMAL_RATE                  = ED_BASE+35;
  ED_RATE_24                             = ED_BASE+36;
  ED_RATE_25                             = ED_BASE+37;
  ED_RATE_2997                           = ED_BASE+38;
  ED_RATE_30                             = ED_BASE+39;

  ED_DEVCAP_CAN_PREVIEW = ED_BASE+40;
  ED_DEVCAP_CAN_MONITOR_SOURCES = ED_BASE+41;

// indicates implementation allows testing of methods/parameters by
// setting the hi bit of a parm that makes sense - see individual methods
// for details.
  ED_DEVCAP_CAN_TEST                     = ED_BASE+42;

// indicates device accepts video as an input.
  ED_DEVCAP_VIDEO_INPUTS                 = ED_BASE+43;

// indicates device accepts audio as an input.
  ED_DEVCAP_AUDIO_INPUTS                 = ED_BASE+44;

  ED_DEVCAP_NEEDS_CALIBRATING            = ED_BASE+45;

  ED_DEVCAP_SEEK_TYPE                    = ED_BASE+46;
  ED_SEEK_PERFECT                        = ED_BASE+47;
  ED_SEEK_FAST                           = ED_BASE+48;
  ED_SEEK_SLOW                           = ED_BASE+49;

  ED_POWER_ON                            = ED_BASE+50;
  ED_POWER_OFF                           = ED_BASE+51;
  ED_POWER_STANDBY                       = ED_BASE+52;

  ED_ACTIVE                              = ED_BASE+53;
  ED_INACTIVE                            = ED_BASE+54;
  ED_ALL                                 = ED_BASE+55;
  ED_TEST                                = ED_BASE+56;

//      IAMExtTransport Capability Items:  unless otherwise specified, these items return
//         OATRUE or OAFALSE.  All return values are in pdwValue unless otherwise specified:

  ED_TRANSCAP_CAN_EJECT                  = ED_BASE+100;
  ED_TRANSCAP_CAN_BUMP_PLAY              = ED_BASE+101;
  ED_TRANSCAP_CAN_PLAY_BACKWARDS         = ED_BASE+102;
  ED_TRANSCAP_CAN_SET_EE                 = ED_BASE+103;
  ED_TRANSCAP_CAN_SET_PB                 = ED_BASE+104;
  ED_TRANSCAP_CAN_DELAY_VIDEO_IN         = ED_BASE+105;
  ED_TRANSCAP_CAN_DELAY_VIDEO_OUT        = ED_BASE+106;
  ED_TRANSCAP_CAN_DELAY_AUDIO_IN         = ED_BASE+107;
  ED_TRANSCAP_CAN_DELAY_AUDIO_OUT        = ED_BASE+108;
  ED_TRANSCAP_FWD_VARIABLE_MAX           = ED_BASE+109;
  ED_TRANSCAP_REV_VARIABLE_MAX           = ED_BASE+110;
  ED_TRANSCAP_NUM_AUDIO_TRACKS           = ED_BASE+111;
  ED_TRANSCAP_LTC_TRACK                  = ED_BASE+112;
  ED_TRANSCAP_NEEDS_TBC                  = ED_BASE+113;
  ED_TRANSCAP_NEEDS_CUEING               = ED_BASE+114;
  ED_TRANSCAP_CAN_INSERT                 = ED_BASE+115;
  ED_TRANSCAP_CAN_ASSEMBLE               = ED_BASE+116;
  ED_TRANSCAP_FIELD_STEP                 = ED_BASE+117;
  ED_TRANSCAP_CLOCK_INC_RATE             = ED_BASE+118;
  ED_TRANSCAP_CAN_DETECT_LENGTH          = ED_BASE+119;
  ED_TRANSCAP_CAN_FREEZE                 = ED_BASE+120;
  ED_TRANSCAP_HAS_TUNER                  = ED_BASE+121;
  ED_TRANSCAP_HAS_TIMER                  = ED_BASE+122;
  ED_TRANSCAP_HAS_CLOCK                  = ED_BASE+123;

//      IAMExtTransport Media States
  ED_MEDIA_SPIN_UP                       = ED_BASE+130;
  ED_MEDIA_SPIN_DOWN                     = ED_BASE+131;
  ED_MEDIA_UNLOAD                        = ED_BASE+132;

//      IAMExtTransport Modes
  ED_MODE_PLAY                           = ED_BASE+200;
  ED_MODE_STOP                           = ED_BASE+201;
  ED_MODE_FREEZE                         = ED_BASE+202;
  ED_MODE_THAW                           = ED_BASE+203;
  ED_MODE_FF                             = ED_BASE+204;
  ED_MODE_REW                            = ED_BASE+205;
  ED_MODE_RECORD                         = ED_BASE+206;
  ED_MODE_RECORD_STROBE                  = ED_BASE+207;
  ED_MODE_STEP                           = ED_BASE+208;
  ED_MODE_SHUTTLE                        = ED_BASE+209;
  ED_MODE_EDIT_CUE                       = ED_BASE+210;
  ED_MODE_VAR_SPEED                      = ED_BASE+211;
  ED_MODE_PERFORM                        = ED_BASE+212;
  ED_MODE_LINK_ON                        = ED_BASE+280;
  ED_MODE_LINK_OFF                       = ED_BASE+281;

//      IAMTimecodeReader/Generator/Display defines
//
// Timecode Generator Mode params and values:
//
  ED_TCG_TIMECODE_TYPE                   = ED_BASE+400;
  ED_TCG_SMPTE_LTC                       = ED_BASE+401;
  ED_TCG_SMPTE_VITC                      = ED_BASE+402;
  ED_TCG_MIDI_QF                         = ED_BASE+403;
  ED_TCG_MIDI_FULL                       = ED_BASE+404;

  ED_TCG_FRAMERATE                       = ED_BASE+405;
  ED_FORMAT_SMPTE_30                     = ED_BASE+406;
  ED_FORMAT_SMPTE_30DROP                 = ED_BASE+407;
  ED_FORMAT_SMPTE_25                     = ED_BASE+408;
  ED_FORMAT_SMPTE_24                     = ED_BASE+409;

  ED_TCG_SYNC_SOURCE                     = ED_BASE+410;
  ED_TCG_VIDEO                           = ED_BASE+411;
  ED_TCG_READER                          = ED_BASE+412;
  ED_TCG_FREE                            = ED_BASE+413;

  ED_TCG_REFERENCE_SOURCE                = ED_BASE+414;

// TimeCodeReader Mode params and values:
  ED_TCR_SOURCE                          = ED_BASE+416;
// ED_TCG (already defined)
  ED_TCR_LTC                             = ED_BASE+417;
  ED_TCR_VITC                            = ED_BASE+418;
  ED_TCR_CT                              = ED_BASE+419;

// TimeCode Display Mode params and values:
//
  ED_TCD_SOURCE                          = ED_BASE+422;
  ED_TCR                                 = ED_BASE+423;
  ED_TCG                                 = ED_BASE+424;

  ED_TCD_SIZE                            = ED_BASE+425;
  ED_SMALL                               = ED_BASE+426;
  ED_MED                                 = ED_BASE+427;
  ED_LARGE                               = ED_BASE+428;

  ED_TCD_POSITION                        = ED_BASE+429;
  ED_TOP                                 = $0001;
  ED_MIDDLE                              = $0002;
  ED_BOTTOM                              = $0004;
  ED_LEFT                                = $0100;
  ED_CENTER                              = $0200;
  ED_RIGHT                               = $0400;

  ED_TCD_INTENSITY                       = ED_BASE+436;
  ED_HIGH                                = ED_BASE+437;
  ED_LOW                                 = ED_BASE+438;

  ED_TCD_TRANSPARENCY                    = ED_BASE+439;
  ED_TCD_INVERT                          = ED_BASE+440;

//      IAMExtTransport defines
//
// Transport status, params and values
//

// IAMExtTransport Status items and and values:
  ED_MODE                                = ED_BASE+500;
  ED_ERROR                               = ED_BASE+501;
  ED_LOCAL                               = ED_BASE+502;
  ED_RECORD_INHIBIT                      = ED_BASE+503;
  ED_SERVO_LOCK                          = ED_BASE+504;
  ED_MEDIA_PRESENT                       = ED_BASE+505;
  ED_MEDIA_LENGTH                        = ED_BASE+506;
  ED_MEDIA_SIZE                          = ED_BASE+507;
  ED_MEDIA_TRACK_COUNT                   = ED_BASE+508;
  ED_MEDIA_TRACK_LENGTH                  = ED_BASE+509;
  ED_MEDIA_SIDE                          = ED_BASE+510;

  ED_MEDIA_TYPE                          = ED_BASE+511;
  ED_MEDIA_VHS                           = ED_BASE+512;
  ED_MEDIA_SVHS                          = ED_BASE+513;
  ED_MEDIA_HI8                           = ED_BASE+514;
  ED_MEDIA_UMATIC                        = ED_BASE+515;
  ED_MEDIA_DVC                           = ED_BASE+516;
  ED_MEDIA_1_INCH                        = ED_BASE+517;
  ED_MEDIA_D1                            = ED_BASE+518;
  ED_MEDIA_D2                            = ED_BASE+519;
  ED_MEDIA_D3                            = ED_BASE+520;
  ED_MEDIA_D5                            = ED_BASE+521;
  ED_MEDIA_DBETA                         = ED_BASE+522;
  ED_MEDIA_BETA                          = ED_BASE+523;
  ED_MEDIA_8MM                           = ED_BASE+524;
  ED_MEDIA_DDR                           = ED_BASE+525;
  ED_MEDIA_OTHER                         = ED_BASE+526;
  ED_MEDIA_CLV                           = ED_BASE+527;
  ED_MEDIA_CAV                           = ED_BASE+528;
  ED_MEDIA_POSITION                      = ED_BASE+529;

  ED_LINK_MODE                           = ED_BASE+530;

// IAMExtTransport Basic Parms
  ED_TRANSBASIC_TIME_FORMAT              = ED_BASE+540;
  ED_FORMAT_MILLISECONDS                 = ED_BASE+541;
  ED_FORMAT_FRAMES                       = ED_BASE+542;
  ED_FORMAT_REFERENCE_TIME               = ED_BASE+543;

  ED_FORMAT_HMSF                         = ED_BASE+547;
  ED_FORMAT_TMSF                         = ED_BASE+548;

  ED_TRANSBASIC_TIME_REFERENCE           = ED_BASE+549;
  ED_TIMEREF_TIMECODE                    = ED_BASE+550;
  ED_TIMEREF_CONTROL_TRACK               = ED_BASE+551;
  ED_TIMEREF_INDEX                       = ED_BASE+552;

  ED_TRANSBASIC_SUPERIMPOSE              = ED_BASE+553;
  ED_TRANSBASIC_END_STOP_ACTION          = ED_BASE+554;

  ED_TRANSBASIC_RECORD_FORMAT            = ED_BASE+555;
  ED_RECORD_FORMAT_SP                    = ED_BASE+556;
  ED_RECORD_FORMAT_LP                    = ED_BASE+557;
  ED_RECORD_FORMAT_EP                    = ED_BASE+558;

  ED_TRANSBASIC_STEP_COUNT               = ED_BASE+559;
  ED_TRANSBASIC_STEP_UNIT                = ED_BASE+560;
  ED_STEP_FIELD                          = ED_BASE+561;
  ED_STEP_FRAME                          = ED_BASE+562;
  ED_STEP_3_2                            = ED_BASE+563;

  ED_TRANSBASIC_PREROLL                  = ED_BASE+564;
  ED_TRANSBASIC_RECPREROLL               = ED_BASE+565;
  ED_TRANSBASIC_POSTROLL                 = ED_BASE+566;
  ED_TRANSBASIC_EDIT_DELAY               = ED_BASE+567;
  ED_TRANSBASIC_PLAYTC_DELAY             = ED_BASE+568;
  ED_TRANSBASIC_RECTC_DELAY              = ED_BASE+569;
  ED_TRANSBASIC_EDIT_FIELD               = ED_BASE+570;
  ED_TRANSBASIC_FRAME_SERVO              = ED_BASE+571;
  ED_TRANSBASIC_CF_SERVO                 = ED_BASE+572;
  ED_TRANSBASIC_SERVO_REF                = ED_BASE+573;
  ED_REF_EXTERNAL                        = ED_BASE+574;
  ED_REF_INPUT                           = ED_BASE+575;
  ED_REF_INTERNAL                        = ED_BASE+576;
  ED_REF_AUTO                            = ED_BASE+577;

  ED_TRANSBASIC_WARN_GL                  = ED_BASE+578;
  ED_TRANSBASIC_SET_TRACKING             = ED_BASE+579;
  ED_TRACKING_PLUS                       = ED_BASE+580;
  ED_TRACKING_MINUS                      = ED_BASE+581;
  ED_TRACKING_RESET                      = ED_BASE+582;

  ED_TRANSBASIC_SET_FREEZE_TIMEOUT       = ED_BASE+583;
  ED_TRANSBASIC_VOLUME_NAME              = ED_BASE+584;
  ED_TRANSBASIC_BALLISTIC_1              = ED_BASE+585;
  ED_TRANSBASIC_BALLISTIC_2              = ED_BASE+586;
  ED_TRANSBASIC_BALLISTIC_3              = ED_BASE+587;
  ED_TRANSBASIC_BALLISTIC_4              = ED_BASE+588;
  ED_TRANSBASIC_BALLISTIC_5              = ED_BASE+589;
  ED_TRANSBASIC_BALLISTIC_6              = ED_BASE+590;
  ED_TRANSBASIC_BALLISTIC_7              = ED_BASE+591;
  ED_TRANSBASIC_BALLISTIC_8              = ED_BASE+592;
  ED_TRANSBASIC_BALLISTIC_9              = ED_BASE+593;
  ED_TRANSBASIC_BALLISTIC_10             = ED_BASE+594;
  ED_TRANSBASIC_BALLISTIC_11             = ED_BASE+595;
  ED_TRANSBASIC_BALLISTIC_12             = ED_BASE+596;
  ED_TRANSBASIC_BALLISTIC_13             = ED_BASE+597;
  ED_TRANSBASIC_BALLISTIC_14             = ED_BASE+598;
  ED_TRANSBASIC_BALLISTIC_15             = ED_BASE+599;
  ED_TRANSBASIC_BALLISTIC_16             = ED_BASE+600;
  ED_TRANSBASIC_BALLISTIC_17             = ED_BASE+601;
  ED_TRANSBASIC_BALLISTIC_18             = ED_BASE+602;
  ED_TRANSBASIC_BALLISTIC_19             = ED_BASE+603;
  ED_TRANSBASIC_BALLISTIC_20             = ED_BASE+604;

// consumer VCR items
  ED_TRANSBASIC_SETCLOCK                 = ED_BASE+605;
  ED_TRANSBASIC_SET_COUNTER_FORMAT       = ED_BASE+606;
  ED_TRANSBASIC_SET_COUNTER_VALUE        = ED_BASE+607;

  ED_TRANSBASIC_SETTUNER_CH_UP           = ED_BASE+608;
  ED_TRANSBASIC_SETTUNER_CH_DN           = ED_BASE+609;
  ED_TRANSBASIC_SETTUNER_SK_UP           = ED_BASE+610;
  ED_TRANSBASIC_SETTUNER_SK_DN           = ED_BASE+611;
  ED_TRANSBASIC_SETTUNER_CH              = ED_BASE+612;
  ED_TRANSBASIC_SETTUNER_NUM             = ED_BASE+613;
  ED_TRANSBASIC_SETTIMER_EVENT           = ED_BASE+614;
  ED_TRANSBASIC_SETTIMER_STARTDAY        = ED_BASE+615;
  ED_TRANSBASIC_SETTIMER_STARTTIME       = ED_BASE+616;
  ED_TRANSBASIC_SETTIMER_STOPDAY         = ED_BASE+617;
  ED_TRANSBASIC_SETTIMER_STOPTIME        = ED_BASE+618;

// IAMExtTransport video parameters
  ED_TRANSVIDEO_SET_OUTPUT               = ED_BASE+630;
  ED_E2E                                 = ED_BASE+631;
  ED_PLAYBACK                            = ED_BASE+632;
  ED_OFF                                 = ED_BASE+633;

  ED_TRANSVIDEO_SET_SOURCE               = ED_BASE+634;

// IAMExtTransport audio parameters
  ED_TRANSAUDIO_ENABLE_OUTPUT            = ED_BASE+640;
  ED_AUDIO_ALL                           = $10000000;
  ED_AUDIO_1                             = $0000001;
  ED_AUDIO_2                             = $0000002;
  ED_AUDIO_3                             = $0000004;
  ED_AUDIO_4                             = $0000008;
  ED_AUDIO_5                             = $0000010;
  ED_AUDIO_6                             = $0000020;
  ED_AUDIO_7                             = $0000040;
  ED_AUDIO_8                             = $0000080;
  ED_AUDIO_9                             = $0000100;
  ED_AUDIO_10                            = $0000200;
  ED_AUDIO_11                            = $0000400;
  ED_AUDIO_12                            = $0000800;
  ED_AUDIO_13                            = $0001000;
  ED_AUDIO_14                            = $0002000;
  ED_AUDIO_15                            = $0004000;
  ED_AUDIO_16                            = $0008000;
  ED_AUDIO_17                            = $0010000;
  ED_AUDIO_18                            = $0020000;
  ED_AUDIO_19                            = $0040000;
  ED_AUDIO_20                            = $0080000;
  ED_AUDIO_21                            = $0100000;
  ED_AUDIO_22                            = $0200000;
  ED_AUDIO_23                            = $0400000;
  ED_AUDIO_24                            = $0800000;
  ED_VIDEO                               = $2000000;

  ED_TRANSAUDIO_ENABLE_RECORD            = ED_BASE+642;
  ED_TRANSAUDIO_ENABLE_SELSYNC           = ED_BASE+643;
  ED_TRANSAUDIO_SET_SOURCE               = ED_BASE+644;
  ED_TRANSAUDIO_SET_MONITOR              = ED_BASE+645;

// Edit Property Set-related defs

// The following values reflect (and control) the state of an
// edit property set
  ED_INVALID                             = ED_BASE+652;
  ED_EXECUTING                           = ED_BASE+653;
  ED_REGISTER                            = ED_BASE+654;
  ED_DELETE                              = ED_BASE+655;

// Edit property set parameters and values
  ED_EDIT_HEVENT                         = ED_BASE+656;
  ED_EDIT_TEST                           = ED_BASE+657;
  ED_EDIT_IMMEDIATE                      = ED_BASE+658;

  ED_EDIT_MODE                           = ED_BASE+659;
// can be one of the following values:
  ED_EDIT_MODE_ASSEMBLE                  = ED_BASE+660;
  ED_EDIT_MODE_INSERT                    = ED_BASE+661;
  ED_EDIT_MODE_CRASH_RECORD              = ED_BASE+662;
  ED_EDIT_MODE_BOOKMARK_TIME             = ED_BASE+663;
  ED_EDIT_MODE_BOOKMARK_CHAPTER          = ED_BASE+664;

  ED_EDIT_MASTER                         = ED_BASE+666;

  ED_EDIT_TRACK                          = ED_BASE+667;
// can be one of the following possible OR'd values:
//      ED_VIDEO, ED_AUDIO_1 thru ED_AUDIO_24 (or ED_AUDIO_ALL)

  ED_EDIT_SRC_INPOINT                    = ED_BASE+668;
  ED_EDIT_SRC_OUTPOINT                   = ED_BASE+669;
  ED_EDIT_REC_INPOINT                    = ED_BASE+670;
  ED_EDIT_REC_OUTPOINT                   = ED_BASE+671;

  ED_EDIT_REHEARSE_MODE                  = ED_BASE+672;
// can be one of the following possible values:
  ED_EDIT_BVB                            = ED_BASE+673;
  ED_EDIT_VBV                            = ED_BASE+674;
  ED_EDIT_VVV                            = ED_BASE+675;
  ED_EDIT_PERFORM                        = ED_BASE+676;


// Set this property to OATRUE to kill the edit if in progress
  ED_EDIT_ABORT                          = ED_BASE+677;
// how long to wait for edit to complete
  ED_EDIT_TIMEOUT                        = ED_BASE+678;

// This property causes the device to seek to a point specified by
// ED_EDIT_SEEK_MODE (see below).  NOTE: Only one event at a time can seek.
  ED_EDIT_SEEK                           = ED_BASE+679;
  ED_EDIT_SEEK_MODE                      = ED_BASE+680;

//possible values:
  ED_EDIT_SEEK_EDIT_IN                   = ED_BASE+681;
  ED_EDIT_SEEK_EDIT_OUT                  = ED_BASE+682;
  ED_EDIT_SEEK_PREROLL                   = ED_BASE+683;
  ED_EDIT_SEEK_PREROLL_CT                = ED_BASE+684;
  ED_EDIT_SEEK_BOOKMARK                  = ED_BASE+685;

//
// Some error codes:
//
// device could be in local mode
  ED_ERR_DEVICE_NOT_READY                = ED_BASE+700;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       aviriff.h
 *
 ***************************************************************************)

type
(*+
 *
 * Structures and defines for the RIFF AVI file format extended to
 * handle very large/long files
 *
 *-=====================================================================*)

                 {
#if !defined NUMELMS
  #define NUMELMS(aa) (sizeof(aa)/sizeof((aa)[0]))
#endif
                  }
// all structures in this file are packed on word boundaries
//
(*
 * heres the general layout of an AVI riff file (new format)
 *
 * RIFF (3F??????) AVI       <- not more than 1 GB in size
 *     LIST (size) hdrl
 *         avih (0038)
 *         LIST (size) strl
 *             strh (0038)
 *             strf (????)
 *             indx (3ff8)   <- size may vary, should be sector sized
 *         LIST (size) strl
 *             strh (0038)
 *             strf (????)
 *             indx (3ff8)   <- size may vary, should be sector sized
 *         LIST (size) odml
 *             dmlh (????)
 *         JUNK (size)       <- fill to align to sector - 12
 *     LIST (7f??????) movi  <- aligned on sector - 12
 *         00dc (size)       <- sector aligned
 *         01wb (size)       <- sector aligned
 *         ix00 (size)       <- sector aligned
 *     idx1 (00??????)       <- sector aligned
 * RIFF (7F??????) AVIX
 *     JUNK (size)           <- fill to align to sector -12
 *     LIST (size) movi
 *         00dc (size)       <- sector aligned
 * RIFF (7F??????) AVIX      <- not more than 2GB in size
 *     JUNK (size)           <- fill to align to sector - 12
 *     LIST (size) movi
 *         00dc (size)       <- sector aligned
 *
 *-===================================================================*)

//
// structures for manipulating RIFF headers
//
{
#define FCC(ch4) ((((DWORD)(ch4) & 0xFF) << 24) |     \
                  (((DWORD)(ch4) & 0xFF00) << 8) |    \
                  (((DWORD)(ch4) & 0xFF0000) >> 8) |  \
                  (((DWORD)(ch4) & 0xFF000000) >> 24))
}
  TRIFFChunk = packed record
    fcc: FOURCC;
    cb: DWORD;
  end;

  TRIFFList = packed record
    fcc: FOURCC;
    cb: DWORD;
    fccListType: FOURCC;
  end;

{
#define RIFFROUND(cb) ((cb) + ((cb)&1))
#define RIFFNEXT(pChunk) (LPRIFFCHUNK)((LPBYTE)(pChunk) \
                          + sizeof(RIFFCHUNK) \
                          + RIFFROUND(((LPRIFFCHUNK)pChunk)->cb))

}
//
// ==================== avi header structures ===========================
//

// main header for the avi file (compatibility header)
//
//#define ckidMAINAVIHEADER FCC('avih')

  TAVIMainHeader = packed record
    fcc: FOURCC;                   // 'avih'
    cb: DWORD;                     // size of this structure -8
    dwMicroSecPerFrame: DWORD;     // frame display rate (or 0L)
    dwMaxBytesPerSec: DWORD;       // max. transfer rate
    dwPaddingGranularity: DWORD;   // pad to multiples of this size; normally 2K.
    dwFlags: DWORD;                // the ever-present flags
    dwTotalFrames: DWORD;          // # frames in first movi list
    dwInitialFrames: DWORD;
    dwStreams: DWORD;
    dwSuggestedBufferSize: DWORD;
    dwWidth: DWORD;
    dwHeight: DWORD;
    dwReserved: array[0..3] of DWORD;
  end;

const
  AVIF_HASINDEX       = $00000010; // Index at end of file?
  AVIF_MUSTUSEINDEX   = $00000020;
  AVIF_ISINTERLEAVED  = $00000100;
  AVIF_TRUSTCKTYPE    = $00000800; // Use CKType to find key frames
  AVIF_WASCAPTUREFILE = $00010000;
  AVIF_COPYRIGHTED    = $00020000;

{
#define ckidODML          FCC('odml')
#define ckidAVIEXTHEADER  FCC('dmlh')
}
type
  TAVIExtHeader = packed record
    fcc: FOURCC;                       // 'dmlh'
    cb: DWORD;                         // size of this structure -8
    dwGrandFrames: DWORD;              // total number of frames in the file
    dwFuture: array[0..60] of DWORD;   // to be defined later
  end;

//
// structure of an AVI stream header riff chunk
//
{ #define ckidSTREAMLIST   FCC('strl')

#define ckidSTREAMHEADER FCC('strh')
}
  TAVIStreamHeader = packed record
     fcc: FOURCC;            // 'strh'
     cb: DWORD;              // size of this structure - 8

     fccType: FOURCC;        // stream type codes

     fccHandler: FOURCC;
     dwFlags: DWORD;

     wPriority: DWORD;
     wLanguage: DWORD;
     dwInitialFrames: DWORD;
     dwScale: DWORD;
     dwRate: DWORD;          // dwRate/dwScale is stream tick rate in ticks/sec
     dwStart: DWORD;
     dwLength: DWORD;
     dwSuggestedBufferSize: DWORD;
     dwQuality: DWORD;
     dwSampleSize: DWORD;

     rcFrame: packed record
       left: SmallInt;
       top: SmallInt;
       right: SmallInt;
       bottom: SmallInt;
     end;
  end;

const
{
#define streamtypeVIDEO FCC('vids')
#define streamtypeAUDIO FCC('auds')
#define streamtypeMIDI  FCC('mids')
#define streamtypeTEXT  FCC('txts')
}
  AVISF_DISABLED         = $00000001;
  AVISF_VIDEO_PALCHANGES = $00010000;

//
// structure of an AVI stream format chunk
//
{
#define ckidSTREAMFORMAT FCC('strf')
}
//
// avi stream formats are different for each stream type
//
// BITMAPINFOHEADER for video streams
// WAVEFORMATEX or PCMWAVEFORMAT for audio streams
// nothing for text streams
// nothing for midi streams


//
// structure of old style AVI index
//
{ #define ckidAVIOLDINDEX FCC('idx1')
}
type
  TAVIOldIndex = packed record
    fcc: FOURCC;      // 'idx1'
    cb: DWORD;        // size of this structure -8

    aIndex: array[0..0] of packed record
      dwChunkId: DWORD;
      dwFlags: DWORD;
      dwOffset: DWORD;      // offset of riff chunk header for the data
      dwSize: DWORD;        // size of the data (excluding riff header size)
    end;                    // size of this array
  end;

const
  AVIIF_LIST       = $00000001;
  AVIIF_KEYFRAME   = $00000010;

  AVIIF_NO_TIME    = $00000100;
  AVIIF_COMPRESSOR = $0FFF0000;  // unused?

{
#define AVIIF_LIST       0x00000001
#define AVIIF_KEYFRAME   0x00000010

#define AVIIF_NO_TIME    0x00000100
#define AVIIF_COMPRESSOR 0x0FFF0000  // unused?
}

//#define TIMECODE_RATE_30DROP 0   // this MUST be zero

// struct for all the SMPTE timecode info
//
type
  TTimeCodeData = packed record
    time: TTimeCode;
    dwSMPTEflags: DWORD;
    dwUser: DWORD;
  end;

// dwSMPTEflags masks/values
//
const
  TIMECODE_SMPTE_BINARY_GROUP = $07;
  TIMECODE_SMPTE_COLOR_FRAME  = $08;

//
// ============ structures for new style AVI indexes =================
//

// index type codes
//
  AVI_INDEX_OF_INDEXES      = $00;
  AVI_INDEX_OF_CHUNKS       = $01;
  AVI_INDEX_OF_TIMED_CHUNKS = $02;
  AVI_INDEX_OF_SUB_2FIELD   = $03;
  AVI_INDEX_IS_DATA         = $80;

// index subtype codes
//
  AVI_INDEX_SUB_DEFAULT     = $00;

// INDEX_OF_CHUNKS subtype codes
//
  AVI_INDEX_SUB_2FIELD      = $01;

// meta structure of all avi indexes
//
type
  TAVIMetaIndex = packed record
    fcc: FOURCC;
    cb: UINT;
    wLongsPerEntry: WORD;
    bIndexSubType: BYTE;
    bIndexType: BYTE;
    nEntriesInUse: DWORD;
    dwChunkId: DWORD;
    dwReserved: array[0..2] of DWORD;
    adwIndex: array[0..0] of DWORD;
  end;

const
  STDINDEXSIZE = $4000;
{
#define NUMINDEX(wLongsPerEntry) ((STDINDEXSIZE-32)/4/(wLongsPerEntry))
#define NUMINDEXFILL(wLongsPerEntry) ((STDINDEXSIZE/4) - NUMINDEX(wLongsPerEntry))
}
// structure of a super index (INDEX_OF_INDEXES)
//
//#define ckidAVISUPERINDEX FCC('indx')

type
 TAVISuperIndex = packed record
   fcc: FOURCC;                      // 'indx'
   cb: UINT;                         // size of this structure
   wLongsPerEntry: WORD;             // ==4
   bIndexSubType: BYTE;              // ==0 (frame index) or AVI_INDEX_SUB_2FIELD
   bIndexType: BYTE;                 // ==AVI_INDEX_OF_INDEXES
   nEntriesInUse: DWORD;             // offset of next unused entry in aIndex
   dwChunkId: DWORD;                 // chunk ID of chunks being indexed, (i.e. RGB8)
   dwReserved: array[0..2] of DWORD; // must be 0

   aIndex: array[0..3] of record
     qwOffset: LONGLONG;             // 64 bit offset to sub index chunk
     dwSize: DWORD;              // 32 bit size of sub index chunk
     dwDuration: DWORD;          // time span of subindex chunk (in stream ticks)
   end;
 end;

//#define Valid_SUPERINDEX(pi) (*(DWORD *)(&((pi)->wLongsPerEntry)) == (4 | (AVI_INDEX_OF_INDEXES << 24)))

// struct of a standard index (AVI_INDEX_OF_CHUNKS)
//

 TAVIStdIndex_Entry = packed record
   dwOffset: DWORD;      // 32 bit offset to data (points to data, not riff header)
   dwSize: DWORD;        // 31 bit size of data (does not include size of riff header), bit 31 is deltaframe bit
 end;

const
  AVISTDINDEX_DELTAFRAME = $80000000; // Delta frames have the high bit set;
  AVISTDINDEX_SIZEMASK = not $80000000;

type
  TAVIStdIndex = packed record
    fcc: FOURCC;           // 'indx' or '##ix'
    cb: UINT;              // size of this structure
    wLongsPerEntry: WORD;  // ==2
    bIndexSubType: BYTE;   // ==0
    bIndexType: BYTE;      // ==AVI_INDEX_OF_CHUNKS
    nEntriesInUse: DWORD;  // offset of next unused entry in aIndex
    dwChunkId: DWORD;      // chunk ID of chunks being indexed, (i.e. RGB8)
    qwBaseOffset: LONGLONG;    // base offset that all index intries are relative to
    dwReserved_3: DWORD;
    aIndex: array[0..2043] of TAVIStdIndex_Entry;
  end;

// struct of a time variant standard index (AVI_INDEX_OF_TIMED_CHUNKS)
//
  TAVITimedIndex_Entry = packed record
    dwOffset: DWORD;     // 32 bit offset to data (points to data, not riff header)
    dwSize: DWORD;       // 31 bit size of data (does not include size of riff header) (high bit is deltaframe bit)
    dwDuration: DWORD;   // how much time the chunk should be played (in stream ticks)
  end;

  TAVITimedIndex = packed record
    fcc: FOURCC;           // 'indx' or '##ix'
    cb: UINT;              // size of this structure
    wLongsPerEntry: WORD;  // ==3
    bIndexSubType: BYTE;   // ==0
    bIndexType: BYTE;      // ==AVI_INDEX_OF_TIMED_CHUNKS
    nEntriesInUse: DWORD;  // offset of next unused entry in aIndex
    dwChunkId: DWORD;      // chunk ID of chunks being indexed, (i.e. RGB8)
    qwBaseOffset: LONGLONG;    // base offset that all index intries are relative to
    dwReserved_3: DWORD;   // must be 0
    aIndex: array[0..1361] of TAVITimedIndex_Entry;
    adwTrailingFill: array[0..2733] of DWORD; // to align struct to correct size
  end;

// structure of a timecode stream
//
  TAVITimeCodeIndex = packed record
    fcc: FOURCC;                      // 'indx' or '##ix'
    cb: UINT;                         // size of this structure
    wLongsPerEntry: WORD;             // ==4
    bIndexSubType: BYTE;              // ==0
    bIndexType: BYTE;                 // ==AVI_INDEX_IS_DATA
    nEntriesInUse: DWORD;             // offset of next unused entry in aIndex
    dwChunkId: DWORD;                 // 'time'
    dwReserved: array[0..2] of DWORD; // must be 0
    aIndex: array[0..0] of TTimeCodeData;
    //TIMECODEDATA aIndex[NUMINDEX(sizeof(TIMECODEDATA)/sizeof(LONG))];
  end;

// structure of a timecode discontinuity list (when wLongsPerEntry == 7)
//
  TAVITcdlIndex_Entry = packed record
    dwTick: DWORD;             // stream tick time that maps to this timecode value
    time: TTimeCode;
    dwSMPTEflags: DWORD;
    dwUser: DWORD;
    szReelId: array[0..11] of Char;
  end;

  TAVITcdlIndex = packed record
    fcc: FOURCC;                      // 'indx' or '##ix'
    cb: UINT;                         // size of this structure
    wLongsPerEntry: WORD;             // ==7 (must be 4 or more all 'tcdl' indexes
    bIndexSubType: BYTE;              // ==0
    bIndexType: BYTE;                 // ==AVI_INDEX_IS_DATA
    nEntriesInUse: DWORD;             // offset of next unused entry in aIndex
    dwChunkId: DWORD;                 // 'tcdl'
    dwReserved: array[0..2] of DWORD; // must be 0
    aIndex: array[0..583] of TAVITcdlIndex_Entry;
    adwTrailingFill: array[0..3511] of DWORD;  // to align struct to correct size
  end;

  TAVIFieldIndex_Chunk = packed record
    fcc: FOURCC;            // 'ix##'
    cb: DWORD;              // size of this structure
    wLongsPerEntry: WORD;   // must be 3 (size of each entry in
                            // aIndex array)
    bIndexSubType: BYTE;    // AVI_INDEX_2FIELD
    bIndexType: BYTE;       // AVI_INDEX_OF_CHUNKS
    nEntriesInUse: DWORD;   //
    dwChunkId: DWORD;       // '##dc' or '##db'
    qwBaseOffset: LONGLONG; // offsets in aIndex array are relative to this
    dwReserved3: DWORD;     // must be 0

    aIndex: array[0..0] of packed record
      dwOffset: DWORD;
      dwSize: DWORD;          // size of all fields
      dwOffsetField2: DWORD;  // (bit 31 set for NON-keyframes)
    end;                      // offset to second field
  end;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       evcode.h
 *
 ***************************************************************************)

const
//
// list of standard Quartz event codes and the expected params
//

// Event codes are broken into two groups
//   -- system event codes
//   -- extension event codes
// All system event codes are below EC_USER

  EC_SYSTEMBASE                        = $00;
  EC_USER                              = $8000;


// System-defined event codes
// ==========================
//
// There are three types of system-defined event codes:
//
// 1.  Those which are always passed through to the application
//     (To be collected by calls to GetEvent or within WaitForCompletion.)
//     (e.g. EC_ERRORABORT, EC_USERABORT.)
//
// 2.  Those which are pure internal and will never be passed to
//     the application.  (e.g. EC_SHUTDOWN)
//
// 3.  Those which have default handling.  Default handing implies that
//     the event is not passed to the application.  However, default
//     handling may be canceled by calling
//     IMediaEvent::CancelDefaultHandling.  If the default handling is
//     cancelled in this way, then the message will be delivered to the
//     application and the application must action it appropriately.
//     Default handling can be restored by calling RestoreDefaultHandling.
//
// We will refer to these events as application, internal and defaulted
// events respectively.
//
// System-defined events may have interface pointers, BSTR's, etc passed
// as parameters.  It is therefore essential that, for any message
// retrieved using GetEvent, a matching call to FreeEventParams is made
// to ensure that relevant interfaces are released and storage freed.
// Failure to call FreeEventParams will result in memory leaks, if not
// worse.
//
// Filters sending these messages to the filter graph should not AddRef()
// any interfaces that they may pass as parameters.  The filter graph
// manager will AddRef them if required.  E.g. if the event is to be queued
// for the application or queued to a worker thread.

// Each event listed below is immediately followed by a parameter list
// detailing the types of the parameters associated with the message,
// and an indication of whether the message is an application, internal
// or defaulted message.  This is then followed by a short description.
// The use of "void" in the parameter list implies that the parameter is not
// used.  Such parameters should be zero.



  EC_COMPLETE                          = $01;
// ( HResult, void ) : defaulted (special)
// Signals the completed playback of a stream within the graph.  This message
// is sent by renderers when they receive end-of-stream.  The default handling
// of this message results in a _SINGLE_ EC_COMPLETE being sent to the
// application when ALL of the individual renderers have signaled EC_COMPLETE
// to the filter graph.  If the default handing is canceled, the application
// will see all of the individual EC_COMPLETEs.


  EC_USERABORT                         = $02;
// ( void, void ) : application
// In some sense, the user has requested that playback be terminated.
// This message is typically sent by renderers that render into a
// window if the user closes the window into which it was rendering.
// It is up to the application to decide if playback should actually
// be stopped.


  EC_ERRORABORT                        = $03;
// ( HResult, void ) : application
// Operation aborted because of error


  EC_TIME                              = $04;
// ( DWORD, DWORD ) : application
// The requested reference time occurred.  (This event is currently not used).
// lParam1 is low dword of ref time, lParam2 is high dword of TRefTime.


  EC_REPAINT                           = $05;
// ( IPin * (could be NULL), void ) : defaulted
// A repaint is required - lParam1 contains the (IPin *) that needs the data
// to be sent again. Default handling is: if the output pin which the IPin is
// attached  to supports the IMediaEventSink interface then it will be called
// with the EC_REPAINT first.  If that fails then normal repaint processing is
// done by the filter graph.


// Stream error notifications
  EC_STREAM_ERROR_STOPPED              = $06;
  EC_STREAM_ERROR_STILLPLAYING         = $07;
// ( HResult, DWORD ) : application
// lParam 1 is major code, lParam2 is minor code, either may be zero.


  EC_ERROR_STILLPLAYING                = $08;
// ( HResult, void ) : application
// The filter graph manager may issue Run's to the graph asynchronously.
// If such a Run fails, EC_ERROR_STILLPLAYING is issued to notify the
// application of the failure.  The state of the underlying filters
// at such a time will be indeterminate - they will all have been asked
// to run, but some are almost certainly not.


  EC_PALETTE_CHANGED                   = $09;
// ( void, void ) : application
// notify application that the video palette has changed


  EC_VIDEO_SIZE_CHANGED                = $0A;
// ( DWORD, void ) : application
// Sent by video renderers.
// Notifies the application that the native video size has changed.
// LOWORD of the DWORD is the new width, HIWORD is the new height.


  EC_QUALITY_CHANGE                    = $0B;
// ( void, void ) : application
// Notify application that playback degradation has occurred


  EC_SHUTTING_DOWN                     = $0C;
// ( void, void ) : internal
// This message is sent by the filter graph manager to any plug-in
// distributors which support IMediaEventSink to notify them that
// the filter graph is starting to shutdown.


  EC_CLOCK_CHANGED                     = $0D;
// ( void, void ) : application
// Notify application that the clock has changed.
// (i.e. SetSyncSource has been called on the filter graph and has been
// distributed successfully to the filters in the graph.)


  EC_OPENING_FILE                            = $10;
  EC_BUFFERING_DATA                    = $11;
// ( BOOL, void ) : application
// lParam1 == 1   --> starting to open file or buffer data
// lParam1 == 0   --> not opening or buffering any more
// (This event does not appear to be used by ActiveMovie.)


  EC_FULLSCREEN_LOST                   = $12;
// ( void, IBaseFilter * ) : application
// Sent by full screen renderers when switched away from full screen.
// IBaseFilter may be NULL.


  EC_ACTIVATE                          = $13;
// ( BOOL, IBaseFilter * ) : internal
// Sent by video renderers when they lose or gain activation.
// lParam1 is set to 1 if gained or 0 if lost
// lParam2 is the IBaseFilter* for the filter that is sending the message
// Used for sound follows focus and full-screen switching


  EC_NEED_RESTART                      = $14;
// ( void, void ) : defaulted
// Sent by renderers when they regain a resource (e.g. audio renderer).
// Causes a restart by Pause/put_Current/Run (if running).


  EC_WINDOW_DESTROYED                  = $15;
// ( IBaseFilter *, void ) : internal
// Sent by video renderers when the window has been destroyed. Handled
// by the filter graph / distributor telling the resource manager.
// lParam1 is the IBaseFilter* of the filter whose window is being destroyed


  EC_DISPLAY_CHANGED                   = $16;
// ( IPin *, void ) : internal
// Sent by renderers when they detect a display change. the filter graph
// will arrange for the graph to be stopped and the pin send in lParam1
// to be reconnected. by being reconnected it allows a renderer to reset
// and connect with a more appropriate format for the new display mode
// lParam1 contains an (IPin *) that should be reconnected by the graph


  EC_STARVATION                        = $17;
// ( void, void ) : defaulted
// Sent by a filter when it detects starvation. Default handling (only when
// running) is for the graph to be paused until all filters enter the
// paused state and then run. Normally this would be sent by a parser or source
// filter when too little data is arriving.


  EC_OLE_EVENT                       = $18;
// ( BSTR, BSTR ) : application
// Sent by a filter to pass a text string to the application.
// Conventionally, the first string is a type, and the second a parameter.


  EC_NOTIFY_WINDOW                     = $19;
// ( HWND, void ) : internal
// Pass the window handle around during pin connection.

  EC_STREAM_CONTROL_STOPPED          = $1A;
// ( IPin * pSender, DWORD dwCookie )
// Notification that an earlier call to IAMStreamControl::StopAt
// has now take effect.  Calls to the method can be marked
// with a cookie which is passed back in the second parameter,
// allowing applications to easily tie together request
// and completion notifications.
//
// NB: IPin will point to the pin that actioned the Stop.  This
// may not be the pin that the StopAt was sent to.

  EC_STREAM_CONTROL_STARTED          = $1B;
// ( IPin * pSender, DWORD dwCookie )
// Notification that an earlier call to IAMStreamControl::StartAt
// has now take effect.  Calls to the method can be marked
// with a cookie which is passed back in the second parameter,
// allowing applications to easily tie together request
// and completion notifications.
//
// NB: IPin will point to the pin that actioned the Start.  This
// may not be the pin that the StartAt was sent to.

  EC_END_OF_SEGMENT                    = $1C;
//
// ( const REFERENCE_TIME *pStreamTimeAtEndOfSegment, DWORD dwSegmentNumber )
//
// pStreamTimeAtEndOfSegment
//     pointer to the accumulated stream clock
//     time since the start of the segment - this is directly computable
//     as the sum of the previous and current segment durations (Stop - Start)
//     and the rate applied to each segment
//     The source add this time to the time within each segment to get
//     a total elapsed time
//
// dwSegmentNumber
//     Segment number - starts at 0
//
// Notifies that a segment end has been reached when the
// AM_SEEKING_Segment flags was set for IMediaSeeking::SetPositions
// Passes in an IMediaSeeking interface to allow the next segment
// to be defined by the application

  EC_SEGMENT_STARTED                   = $1D;
//
// ( const REFERENCE_TIME *pStreamTimeAtStartOfSegment, DWORD dwSegmentNumber)
//
// pStreamTimeAtStartOfSegment
//     pointer to the accumulated stream clock
//     time since the start of the segment - this is directly computable
//     as the sum of the previous segment durations (Stop - Start)
//     and the rate applied to each segment
//
// dwSegmentNumber
//     Segment number - starts at 0
//
// Notifies that a new segment has been started.
// This is sent synchronously by any entity that will issue
// EC_END_OF_SEGMENT when a new segment is started
// (See IMediaSeeking::SetPositions - AM_SEEKING_Segment flag)
// It is used to compute how many EC_END_OF_SEGMENT notifications
// to expect at the end of a segment and as a consitency check

  EC_LENGTH_CHANGED                   = $1E;

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       uuids.h
 *
 ***************************************************************************)

const

// -- to allow consistent labeling of Media types and subtypes --
  // ?? GUID_NULL ??
  MEDIATYPE_NULL: TGUID = (D1:$00000000;D2:$0000;D3:$0000;D4:($00,$00,$00,$00,$00,$00,$00,$00));
  MEDIASUBTYPE_NULL: TGUID = (D1:$00000000;D2:$0000;D3:$0000;D4:($00,$00,$00,$00,$00,$00,$00,$00));

// -- Use this subtype if you don't have a use for a subtype for your type
  MEDIASUBTYPE_None: TGUID = (D1:$E436EB8E;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));

// -- major types ---
  MEDIATYPE_Video: TGUID = (D1:$73646976;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIATYPE_Audio: TGUID = (D1:$73647561;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIATYPE_Text: TGUID = (D1:$73747874;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIATYPE_Midi: TGUID = (D1:$7364696D;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIATYPE_Stream: TGUID = (D1:$E436EB83;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIATYPE_Interleaved: TGUID = (D1:$73766169;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIATYPE_File: TGUID = (D1:$656C6966;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIATYPE_ScriptCommand: TGUID = (D1:$73636D64;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIATYPE_AUXLine21Data: TGUID = (D1:$670AEA80;D2:$3A82;D3:$11D0;D4:($B7,$9B,$00,$AA,$00,$37,$67,$A7));
  MEDIATYPE_Timecode: TGUID = (D1:$0482DEE3;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));

// -- sub types ---
  MEDIASUBTYPE_YVU9: TGUID = (D1:$39555659;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_Y411: TGUID = (D1:$31313459;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_Y41P: TGUID = (D1:$50313459;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_YUY2: TGUID = (D1:$32595559;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_YVYU: TGUID = (D1:$55595659;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_UYVY: TGUID = (D1:$59565955;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_Y211: TGUID = (D1:$31313259;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_YV12: TGUID = (D1:$32315659;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_CLJR: TGUID = (D1:$524A4C43;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_IF09: TGUID = (D1:$39304649;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_CPLA: TGUID = (D1:$414C5043;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_MJPG: TGUID = (D1:$47504A4D;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_TVMJ: TGUID = (D1:$4A4D5654;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_WAKE: TGUID = (D1:$454B4157;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_CFCC: TGUID = (D1:$43434643;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_IJPG: TGUID = (D1:$47504A49;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_Plum: TGUID = (D1:$6D756C50;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_DVCS: TGUID = (D1:$53435644;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_DVSD: TGUID = (D1:$44535644;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_MDVF: TGUID = (D1:$4656444D;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_RGB1: TGUID = (D1:$E436EB78;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_RGB4: TGUID = (D1:$E436EB79;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_RGB8: TGUID = (D1:$E436EB7A;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_RGB565: TGUID = (D1:$E436EB7B;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_RGB555: TGUID = (D1:$E436EB7C;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_RGB24: TGUID = (D1:$E436EB7D;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_RGB32: TGUID = (D1:$E436EB7E;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_Overlay: TGUID = (D1:$E436EB7F;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_MPEG1Packet: TGUID = (D1:$E436EB80;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_MPEG1Payload: TGUID = (D1:$E436EB81;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_MPEG1AudioPayload: TGUID = (D1:$00000050;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIATYPE_MPEG1SystemStream: TGUID = (D1:$E436EB82;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_MPEG1System: TGUID = (D1:$E436EB84;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_MPEG1VideoCD: TGUID = (D1:$E436EB85;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_MPEG1Video: TGUID = (D1:$E436EB86;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_MPEG1Audio: TGUID = (D1:$E436EB87;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_Avi: TGUID = (D1:$E436EB88;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_QTMovie: TGUID = (D1:$E436EB89;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_QTRpza: TGUID = (D1:$617A7072;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_QTSmc: TGUID = (D1:$20636D73;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_QTRle: TGUID = (D1:$20656C72;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_QTJpeg: TGUID = (D1:$6765706A;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_PCMAudio_Obsolete: TGUID = (D1:$E436EB8A;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_PCM: TGUID = (D1:$00000001;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_WAVE: TGUID = (D1:$E436EB8B;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_AU: TGUID = (D1:$E436EB8C;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_AIFF: TGUID = (D1:$E436EB8D;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_dvsd_: TGUID = (D1:$64737664;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_dvhd: TGUID = (D1:$64687664;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_dvsl: TGUID = (D1:$6C737664;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_Line21_BytePair: TGUID = (D1:$6E8D4A22;D2:$310C;D3:$11D0;D4:($B7,$9A,$00,$AA,$00,$37,$67,$A7));
  MEDIASUBTYPE_Line21_GOPPacket: TGUID = (D1:$6E8D4A23;D2:$310C;D3:$11D0;D4:($B7,$9A,$00,$AA,$00,$37,$67,$A7));
  MEDIASUBTYPE_Line21_VBIRawData: TGUID = (D1:$6E8D4A24;D2:$310C;D3:$11D0;D4:($B7,$9A,$00,$AA,$00,$37,$67,$A7));
  MEDIASUBTYPE_DssVideo: TGUID = (D1:$A0AF4F81;D2:$E163;D3:$11D0;D4:($BA,$D9,$00,$60,$97,$44,$11,$1A));
  MEDIASUBTYPE_DssAudio: TGUID = (D1:$A0AF4F82;D2:$E163;D3:$11D0;D4:($BA,$D9,$00,$60,$97,$44,$11,$1A));
  MEDIASUBTYPE_VPVideo: TGUID = (D1:$5A9B6A40;D2:$1A22;D3:$11D1;D4:($BA,$D9,$00,$60,$97,$44,$11,$1A));
  MEDIASUBTYPE_VPVBI: TGUID = (D1:$5A9B6A41;D2:$1A22;D3:$11D1;D4:($BA,$D9,$00,$60,$97,$44,$11,$1A));

// the cutlist source filter
  CLSID_SimpleCutList: TGUID = (D1:$A5EA8D30;D2:$253D;D3:$11D1;D4:($B3,$F1,$00,$AA,$00,$37,$61,$C5));
  CLSID_VideoFileClip: TGUID = (D1:$A5EA8D31;D2:$253D;D3:$11D1;D4:($B3,$F1,$00,$AA,$00,$37,$61,$C5));
  CLSID_AudioFileClip: TGUID = (D1:$A5EA8D32;D2:$253D;D3:$11D1;D4:($B3,$F1,$00,$AA,$00,$37,$61,$C5));
  CLSID_CutListCacheMemory: TGUID = (D1:$A5EA8D33;D2:$253D;D3:$11D1;D4:($B3,$F1,$00,$AA,$00,$37,$61,$C5));


// end cut list stuff
  CLSID_CaptureGraphBuilder: TGUID = (D1:$BF87B6E0;D2:$8C27;D3:$11D0;D4:($B3,$F0,$00,$AA,$00,$37,$61,$C5));
  CLSID_ProtoFilterGraph: TGUID = (D1:$E436EBB0;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  CLSID_SystemClock: TGUID = (D1:$E436EBB1;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  CLSID_FilterMapper: TGUID = (D1:$E436EBB2;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  CLSID_FilterGraph: TGUID = (D1:$E436EBB3;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  CLSID_FilterGraphNoThread: TGUID = (D1:$E436EBB8;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  CLSID_MPEG1Doc: TGUID = (D1:$E4BBD160;D2:$4269;D3:$11CE;D4:($83,$8D,$00,$AA,$00,$55,$59,$5A));
  CLSID_FileSource: TGUID = (D1:$701722E0;D2:$8AE3;D3:$11CE;D4:($A8,$5C,$00,$AA,$00,$2F,$EA,$B5));
  CLSID_MPEG1PacketPlayer: TGUID = (D1:$26C25940;D2:$4CA9;D3:$11CE;D4:($A8,$28,$00,$AA,$00,$2F,$EA,$B5));
  CLSID_MPEG1Splitter: TGUID = (D1:$336475D0;D2:$942A;D3:$11CE;D4:($A8,$70,$00,$AA,$00,$2F,$EA,$B5));
  CLSID_CMpegVideoCodec: TGUID = (D1:$FEB50740;D2:$7BEF;D3:$11CE;D4:($9B,$D9,$00,$00,$E2,$02,$59,$9C));
  CLSID_CMpegAudioCodec: TGUID = (D1:$4A2286E0;D2:$7BEF;D3:$11CE;D4:($9B,$D9,$00,$00,$E2,$02,$59,$9C));
  CLSID_TextRender: TGUID = (D1:$E30629D3;D2:$27E5;D3:$11CE;D4:($87,$5D,$00,$60,$8C,$B7,$80,$66));

  CLSID_InfTee: TGUID = (D1:$F8388A40;D2:$D5BB;D3:$11D0;D4:($BE,$5A,$00,$80,$C7,$06,$56,$8E));
  CLSID_AviSplitter: TGUID = (D1:$1B544C20;D2:$FD0B;D3:$11CE;D4:($8C,$63,$00,$AA,$00,$44,$B5,$1E));
  CLSID_AviReader: TGUID = (D1:$1B544C21;D2:$FD0B;D3:$11CE;D4:($8C,$63,$00,$AA,$00,$44,$B5,$1E));
  CLSID_VfwCapture: TGUID = (D1:$1B544C22;D2:$FD0B;D3:$11CE;D4:($8C,$63,$00,$AA,$00,$44,$B5,$1E));
  CLSID_CaptureProperties: TGUID = (D1:$1B544C22;D2:$FD0B;D3:$11CE;D4:($8C,$63,$00,$AA,$00,$44,$B5,$1F));
  CLSID_FGControl: TGUID = (D1:$E436EBB4;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  CLSID_MOVReader: TGUID = (D1:$44584800;D2:$F8EE;D3:$11CE;D4:($B2,$D4,$00,$DD,$01,$10,$1B,$85));
  CLSID_AVIDoc: TGUID = (D1:$D3588AB0;D2:$0781;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  CLSID_AVIDocWriter: TGUID = (D1:$D3588AB1;D2:$0781;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  CLSID_VideoRenderer: TGUID = (D1:$70E102B0;D2:$5556;D3:$11CE;D4:($97,$C0,$00,$AA,$00,$55,$59,$5A));
  CLSID_Colour: TGUID = (D1:$1643E180;D2:$90F5;D3:$11CE;D4:($97,$D5,$00,$AA,$00,$55,$59,$5A));
  CLSID_Dither: TGUID = (D1:$1DA08500;D2:$9EDC;D3:$11CF;D4:($BC,$10,$00,$AA,$00,$AC,$74,$F6));
  CLSID_ModexRenderer: TGUID = (D1:$07167665;D2:$5011;D3:$11CF;D4:($BF,$33,$00,$AA,$00,$55,$59,$5A));
  CLSID_AudioRender: TGUID = (D1:$E30629D1;D2:$27E5;D3:$11CE;D4:($87,$5D,$00,$60,$8C,$B7,$80,$66));
  CLSID_AudioProperties: TGUID = (D1:$05589FAF;D2:$C356;D3:$11CE;D4:($BF,$01,$00,$AA,$00,$55,$59,$5A));

  CLSID_DSoundRender: TGUID = (D1:$79376820;D2:$07D0;D3:$11CF;D4:($A2,$4D,$00,$20,$AF,$D7,$97,$67));
  CLSID_AudioRecord: TGUID = (D1:$E30629D2;D2:$27E5;D3:$11CE;D4:($87,$5D,$00,$60,$8C,$B7,$80,$66));
  CLSID_AVIDec: TGUID = (D1:$CF49D4E0;D2:$1115;D3:$11CE;D4:($B0,$3A,$00,$20,$AF,$0B,$A7,$70));
  CLSID_ACMWrapper: TGUID = (D1:$6A08CF80;D2:$0E18;D3:$11CF;D4:($A2,$4D,$00,$20,$AF,$D7,$97,$67));
  CLSID_AsyncReader: TGUID = (D1:$E436EBB5;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  CLSID_URLReader: TGUID = (D1:$E436EBB6;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  CLSID_PersistMonikerPID: TGUID = (D1:$E436EBB7;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  CLSID_AMovie: TGUID = (D1:$5F2759C0;D2:$7685;D3:$11CF;D4:($8B,$23,$00,$80,$5F,$6C,$EF,$60));
  CLSID_AVICo: TGUID = (D1:$D76E2820;D2:$1563;D3:$11CF;D4:($AC,$98,$00,$AA,$00,$4C,$0F,$A9));
  CLSID_FileWriter: TGUID = (D1:$8596E5F0;D2:$0DA5;D3:$11D0;D4:($BD,$21,$00,$A0,$C9,$11,$CE,$86));

  CLSID_AviDest: TGUID = (D1:$E2510970;D2:$F137;D3:$11CE;D4:($8B,$67,$00,$AA,$00,$A3,$F1,$A6));
  CLSID_AviMuxProptyPage: TGUID = (D1:$C647B5C0;D2:$157C;D3:$11D0;D4:($BD,$23,$00,$A0,$C9,$11,$CE,$86));
  CLSID_AviMuxProptyPage1: TGUID = (D1:$0A9AE910;D2:$85C0;D3:$11D0;D4:($BD,$42,$00,$A0,$C9,$11,$CE,$86));
  CLSID_AVIMIDIRender: TGUID = (D1:$07B65360;D2:$C445;D3:$11CE;D4:($AF,$DE,$00,$AA,$00,$6C,$14,$F4));

  CLSID_DVVideoCodec: TGUID = (D1:$B1B77C00;D2:$C3E4;D3:$11CF;D4:($AF,$79,$00,$AA,$00,$B6,$7A,$42));
  CLSID_DVVideoEnc: TGUID = (D1:$13AA3650;D2:$BB6F;D3:$11D0;D4:($AF,$B9,$00,$AA,$00,$B6,$7A,$42));
  CLSID_DVSplitter: TGUID = (D1:$4EB31670;D2:$9FC6;D3:$11CF;D4:($AF,$6E,$00,$AA,$00,$B6,$7A,$42));
  CLSID_DVMux: TGUID = (D1:$129D7E40;D2:$C10D;D3:$11D0;D4:($AF,$B9,$00,$AA,$00,$B6,$7A,$42));
  CLSID_SeekingPassThru: TGUID = (D1:$060AF76C;D2:$68DD;D3:$11D0;D4:($8F,$C1,$00,$C0,$4F,$D9,$18,$9D));
  CLSID_Line21Decoder: TGUID = (D1:$6E8D4A20;D2:$310C;D3:$11D0;D4:($B7,$9A,$00,$AA,$00,$37,$67,$A7));
  CLSID_OverlayMixer: TGUID = (D1:$CD8743A1;D2:$3736;D3:$11D0;D4:($9E,$69,$00,$C0,$4F,$D7,$C1,$5B));
  CLSID_VBISurfaces: TGUID = (D1:$814B9800;D2:$1C88;D3:$11D1;D4:($BA,$D9,$00,$60,$97,$44,$11,$1A));

// pnp objects and categories
  CLSID_SystemDeviceEnum: TGUID = (D1:$62BE5D10;D2:$60EB;D3:$11D0;D4:($BD,$3B,$00,$A0,$C9,$11,$CE,$86));
  CLSID_CDeviceMoniker: TGUID = (D1:$4315D437;D2:$5B8C;D3:$11D0;D4:($BD,$3B,$00,$A0,$C9,$11,$CE,$86));
  CLSID_VideoInputDeviceCategory: TGUID = (D1:$860BB310;D2:$5D01;D3:$11D0;D4:($BD,$3B,$00,$A0,$C9,$11,$CE,$86));
  CLSID_CVidCapClassManager: TGUID = (D1:$860BB310;D2:$5D01;D3:$11D0;D4:($BD,$3B,$00,$A0,$C9,$11,$CE,$86));
  CLSID_LegacyAmFilterCategory: TGUID = (D1:$083863F1;D2:$70DE;D3:$11D0;D4:($BD,$40,$00,$A0,$C9,$11,$CE,$86));
  CLSID_CQzFilterClassManager: TGUID = (D1:$083863F1;D2:$70DE;D3:$11D0;D4:($BD,$40,$00,$A0,$C9,$11,$CE,$86));
  CLSID_VideoCompressorCategory: TGUID = (D1:$33D9A760;D2:$90C8;D3:$11D0;D4:($BD,$43,$00,$A0,$C9,$11,$CE,$86));
  CLSID_CIcmCoClassManager: TGUID = (D1:$33D9A760;D2:$90C8;D3:$11D0;D4:($BD,$43,$00,$A0,$C9,$11,$CE,$86));
  CLSID_AudioCompressorCategory: TGUID = (D1:$33D9A761;D2:$90C8;D3:$11D0;D4:($BD,$43,$00,$A0,$C9,$11,$CE,$86));
  CLSID_CAcmCoClassManager: TGUID = (D1:$33D9A761;D2:$90C8;D3:$11D0;D4:($BD,$43,$00,$A0,$C9,$11,$CE,$86));
  CLSID_AudioInputDeviceCategory: TGUID = (D1:$33D9A762;D2:$90C8;D3:$11D0;D4:($BD,$43,$00,$A0,$C9,$11,$CE,$86));
  CLSID_CWaveinClassManager: TGUID = (D1:$33D9A762;D2:$90C8;D3:$11D0;D4:($BD,$43,$00,$A0,$C9,$11,$CE,$86));
  CLSID_AudioRendererCategory: TGUID = (D1:$E0F158E1;D2:$CB04;D3:$11D0;D4:($BD,$4E,$00,$A0,$C9,$11,$CE,$86));
  CLSID_CWaveOutClassManager: TGUID = (D1:$E0F158E1;D2:$CB04;D3:$11D0;D4:($BD,$4E,$00,$A0,$C9,$11,$CE,$86));
  CLSID_MidiRendererCategory: TGUID = (D1:$4EFE2452;D2:$168A;D3:$11D1;D4:($BC,$76,$00,$C0,$4F,$B9,$45,$3B));
  CLSID_CMidiOutClassManager: TGUID = (D1:$4EFE2452;D2:$168A;D3:$11D1;D4:($BC,$76,$00,$C0,$4F,$B9,$45,$3B));
  CLSID_ActiveMovieCategories: TGUID = (D1:$DA4E3DA0;D2:$D07D;D3:$11D0;D4:($BD,$50,$00,$A0,$C9,$11,$CE,$86));
  CLSID_DVDHWDecodersCategory: TGUID = (D1:$2721AE20;D2:$7E70;D3:$11D0;D4:($A5,$D6,$28,$DB,$04,$C1,$00,$00));
  CLSID_FilterMapper2: TGUID = (D1:$CDA42200;D2:$BD88;D3:$11D0;D4:($BD,$4E,$00,$A0,$C9,$11,$CE,$86));
  CLSID_MemoryAllocator: TGUID = (D1:$1E651CC0;D2:$B199;D3:$11D0;D4:($82,$12,$00,$C0,$4F,$C3,$2C,$45));
  CLSID_MediaPropertyBag: TGUID = (D1:$CDBD8D00;D2:$C193;D3:$11D0;D4:($BD,$4E,$00,$A0,$C9,$11,$CE,$86));
  CLSID_DvdGraphBuilder: TGUID = (D1:$FCC152B7;D2:$F372;D3:$11D0;D4:($8E,$00,$00,$C0,$4F,$D7,$C0,$8B));
  CLSID_DVDNavigator: TGUID = (D1:$9B8C4620;D2:$2C1A;D3:$11D0;D4:($84,$93,$00,$A0,$24,$38,$AD,$48));


// -- format types ---
  FORMAT_None: TGUID = (D1:$0F6417D6;D2:$C318;D3:$11D0;D4:($A4,$3F,$00,$A0,$C9,$22,$31,$96));
  FORMAT_VideoInfo: TGUID = (D1:$05589F80;D2:$C356;D3:$11CE;D4:($BF,$01,$00,$AA,$00,$55,$59,$5A));
  FORMAT_VideoInfo2: TGUID = (D1:$F72A76A0;D2:$EB0A;D3:$11D0;D4:($AC,$E4,$00,$00,$C0,$CC,$16,$BA));
  FORMAT_WaveFormatEx: TGUID = (D1:$05589F81;D2:$C356;D3:$11CE;D4:($BF,$01,$00,$AA,$00,$55,$59,$5A));
  FORMAT_MPEGVideo: TGUID = (D1:$05589F82;D2:$C356;D3:$11CE;D4:($BF,$01,$00,$AA,$00,$55,$59,$5A));
  FORMAT_MPEGStreams: TGUID = (D1:$05589F83;D2:$C356;D3:$11CE;D4:($BF,$01,$00,$AA,$00,$55,$59,$5A));
  FORMAT_DvInfo: TGUID = (D1:$05589F84;D2:$C356;D3:$11CE;D4:($BF,$01,$00,$AA,$00,$55,$59,$5A));


// -- Video related GUIDs ---
  CLSID_DirectDrawProperties: TGUID = (D1:$944D4C00;D2:$DD52;D3:$11CE;D4:($BF,$0E,$00,$AA,$00,$55,$59,$5A));
  CLSID_PerformanceProperties: TGUID = (D1:$59CE6880;D2:$ACF8;D3:$11CF;D4:($B5,$6E,$00,$80,$C7,$C4,$B6,$8A));
  CLSID_QualityProperties: TGUID = (D1:$418AFB70;D2:$F8B8;D3:$11CE;D4:($AA,$C6,$00,$20,$AF,$0B,$99,$A3));
  CLSID_VPObject: TGUID = (D1:$CE292861;D2:$FC88;D3:$11D0;D4:($9E,$69,$00,$C0,$4F,$D7,$C1,$5B));
  IID_IVPObject: TGUID = (D1:$CE292862;D2:$FC88;D3:$11D0;D4:($9E,$69,$00,$C0,$4F,$D7,$C1,$5B));
  IID_IVPControl: TGUID = (D1:$25DF12C1;D2:$3DE0;D3:$11D1;D4:($9E,$69,$00,$C0,$4F,$D7,$C1,$5B));
  CLSID_VPVBIObject: TGUID = (D1:$814B9801;D2:$1C88;D3:$11D1;D4:($BA,$D9,$00,$60,$97,$44,$11,$1A));
  IID_IVPVBIObject: TGUID = (D1:$814B9802;D2:$1C88;D3:$11D1;D4:($BA,$D9,$00,$60,$97,$44,$11,$1A));


  CLSID_ModexProperties: TGUID = (D1:$0618AA30;D2:$6BC4;D3:$11CF;D4:($BF,$36,$00,$AA,$00,$55,$59,$5A));

// DV decoder property
  CLSID_DVDecPropertiesPage: TGUID = (D1:$101193C0;D2:$0BFE;D3:$11D0;D4:($AF,$91,$00,$AA,$00,$B6,$7A,$42));

// DV encoder property
  CLSID_DVEncPropertiesPage: TGUID = (D1:$4150F050;D2:$BB6F;D3:$11D0;D4:($AF,$B9,$00,$AA,$00,$B6,$7A,$42));

// DV Muxer property
  CLSID_DVMuxPropertyPage: TGUID = (D1:$4DB880E0;D2:$C10D;D3:$11D0;D4:($AF,$B9,$00,$AA,$00,$B6,$7A,$42));


// -- Analog video related GUIDs ---


// -- format types ---
  FORMAT_AnalogVideo: TGUID = (D1:$0482DDE0;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));

  MEDIATYPE_AnalogVideo: TGUID = (D1:$0482DDE1;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  MEDIASUBTYPE_AnalogVideo_NTSC_M: TGUID = (D1:$0482DDE2;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  MEDIASUBTYPE_AnalogVideo_PAL_B: TGUID = (D1:$0482DDE5;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  MEDIASUBTYPE_AnalogVideo_PAL_D: TGUID = (D1:$0482DDE6;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  MEDIASUBTYPE_AnalogVideo_PAL_G: TGUID = (D1:$0482DDE7;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  MEDIASUBTYPE_AnalogVideo_PAL_H: TGUID = (D1:$0482DDE8;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  MEDIASUBTYPE_AnalogVideo_PAL_I: TGUID = (D1:$0482DDE9;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  MEDIASUBTYPE_AnalogVideo_PAL_M: TGUID = (D1:$0482DDEA;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  MEDIASUBTYPE_AnalogVideo_PAL_N: TGUID = (D1:$0482DDEB;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));

// -- Analog Video subtypes, SECAM
  MEDIASUBTYPE_AnalogVideo_SECAM_B: TGUID = (D1:$0482DDF0;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  MEDIASUBTYPE_AnalogVideo_SECAM_D: TGUID = (D1:$0482DDF1;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  MEDIASUBTYPE_AnalogVideo_SECAM_G: TGUID = (D1:$0482DDF2;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  MEDIASUBTYPE_AnalogVideo_SECAM_H: TGUID = (D1:$0482DDF3;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  MEDIASUBTYPE_AnalogVideo_SECAM_K: TGUID = (D1:$0482DDF4;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  MEDIASUBTYPE_AnalogVideo_SECAM_K1: TGUID = (D1:$0482DDF5;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  MEDIASUBTYPE_AnalogVideo_SECAM_L: TGUID = (D1:$0482DDF6;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));


// --  External audio related GUIDs ---

// -- major types, Analog Audio
  MEDIATYPE_AnalogAudio: TGUID = (D1:$0482DEE1;D2:$7817;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));

// -- Well known time format GUIDs ---
  TIME_FORMAT_NONE: TGUID = (D1:$00000000;D2:$0000;D3:$0000;D4:($00,$00,$00,$00,$00,$00,$00,$00));
  TIME_FORMAT_FRAME: TGUID = (D1:$7B785570;D2:$8C82;D3:$11CF;D4:($BC,$0C,$00,$AA,$00,$AC,$74,$F6));
  TIME_FORMAT_BYTE: TGUID = (D1:$7B785571;D2:$8C82;D3:$11CF;D4:($BC,$0C,$00,$AA,$00,$AC,$74,$F6));
  TIME_FORMAT_SAMPLE: TGUID = (D1:$7B785572;D2:$8C82;D3:$11CF;D4:($BC,$0C,$00,$AA,$00,$AC,$74,$F6));
  TIME_FORMAT_FIELD: TGUID = (D1:$7B785573;D2:$8C82;D3:$11CF;D4:($BC,$0C,$00,$AA,$00,$AC,$74,$F6));
  TIME_FORMAT_MEDIA_TIME: TGUID = (D1:$7B785574;D2:$8C82;D3:$11CF;D4:($BC,$0C,$00,$AA,$00,$AC,$74,$F6));

// for IKsPropertySet
  AMPROPSETID_Pin: TGUID = (D1:$9B00F101;D2:$1567;D3:$11D1;D4:($B3,$F1,$00,$AA,$00,$37,$61,$C5));
  PIN_CATEGORY_CAPTURE: TGUID = (D1:$FB6C4281;D2:$0353;D3:$11D1;D4:($90,$5F,$00,$00,$C0,$CC,$16,$BA));
  PIN_CATEGORY_PREVIEW: TGUID = (D1:$FB6C4282;D2:$0353;D3:$11D1;D4:($90,$5F,$00,$00,$C0,$CC,$16,$BA));
  PIN_CATEGORY_ANALOGVIDEOIN: TGUID = (D1:$FB6C4283;D2:$0353;D3:$11D1;D4:($90,$5F,$00,$00,$C0,$CC,$16,$BA));
  PIN_CATEGORY_VBI: TGUID = (D1:$FB6C4284;D2:$0353;D3:$11D1;D4:($90,$5F,$00,$00,$C0,$CC,$16,$BA));
  PIN_CATEGORY_VIDEOPORT: TGUID = (D1:$FB6C4285;D2:$0353;D3:$11D1;D4:($90,$5F,$00,$00,$C0,$CC,$16,$BA));
  PIN_CATEGORY_NABTS: TGUID = (D1:$FB6C4286;D2:$0353;D3:$11D1;D4:($90,$5F,$00,$00,$C0,$CC,$16,$BA));
  PIN_CATEGORY_EDS: TGUID = (D1:$FB6C4287;D2:$0353;D3:$11D1;D4:($90,$5F,$00,$00,$C0,$CC,$16,$BA));
  PIN_CATEGORY_TELETEXT: TGUID = (D1:$FB6C4288;D2:$0353;D3:$11D1;D4:($90,$5F,$00,$00,$C0,$CC,$16,$BA));
  PIN_CATEGORY_CC: TGUID = (D1:$FB6C4289;D2:$0353;D3:$11D1;D4:($90,$5F,$00,$00,$C0,$CC,$16,$BA));
  PIN_CATEGORY_STILL: TGUID = (D1:$FB6C428A;D2:$0353;D3:$11D1;D4:($90,$5F,$00,$00,$C0,$CC,$16,$BA));
  PIN_CATEGORY_TIMECODE: TGUID = (D1:$FB6C428B;D2:$0353;D3:$11D1;D4:($90,$5F,$00,$00,$C0,$CC,$16,$BA));
  PIN_CATEGORY_VIDEOPORT_VBI: TGUID = (D1:$FB6C428C;D2:$0353;D3:$11D1;D4:($90,$5F,$00,$00,$C0,$CC,$16,$BA));


// -------------------------------------------------------------------------
// KSProxy GUIDS
// -------------------------------------------------------------------------

  CLSID_TVTunerFilterPropertyPage: TGUID = (D1:$266EEE41;D2:$6C63;D3:$11CF;D4:($8A,$03,$00,$AA,$00,$6E,$CB,$65));
  CLSID_CrossbarFilterPropertyPage: TGUID = (D1:$71F96461;D2:$78F3;D3:$11D0;D4:($A1,$8C,$00,$A0,$C9,$11,$89,$56));
  CLSID_TVAudioFilterPropertyPage: TGUID = (D1:$71F96463;D2:$78F3;D3:$11D0;D4:($A1,$8C,$00,$A0,$C9,$11,$89,$56));
  CLSID_VideoProcAmpPropertyPage: TGUID = (D1:$71F96464;D2:$78F3;D3:$11D0;D4:($A1,$8C,$00,$A0,$C9,$11,$89,$56));
  CLSID_CameraControlPropertyPage: TGUID = (D1:$71F96465;D2:$78F3;D3:$11D0;D4:($A1,$8C,$00,$A0,$C9,$11,$89,$56));
  CLSID_AnalogVideoDecoderPropertyPage: TGUID = (D1:$71F96466;D2:$78F3;D3:$11D0;D4:($A1,$8C,$00,$A0,$C9,$11,$89,$56));
  CLSID_VideoStreamConfigPropertyPage: TGUID = (D1:$71F96467;D2:$78F3;D3:$11D0;D4:($A1,$8C,$00,$A0,$C9,$11,$89,$56));

(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       ksuuids.h
 *
 ***************************************************************************)
// contains the GUIDs for the MediaType type, subtype fields and format types
// for DVD/MPEG2 media types.

const
  MEDIASUBTYPE_MPEG2_AUDIO: TGUID = (D1:$E06D802B;D2:$DB46;D3:$11CF;D4:($B4,$D1,$00,$80,$005F,$6C,$BB,$EA));
  MEDIASUBTYPE_DOLBY_AC3: TGUID = (D1:$E06D802C;D2:$DB46;D3:$11CF;D4:($B4,$D1,$00,$80,$005F,$6C,$BB,$EA));
  MEDIASUBTYPE_DVD_SUBPICTURE: TGUID = (D1:$E06D802D;D2:$DB46;D3:$11CF;D4:($B4,$D1,$00,$80,$005F,$6C,$BB,$EA));
  MEDIASUBTYPE_DVD_LPCM_AUDIO: TGUID = (D1:$E06D8032;D2:$DB46;D3:$11CF;D4:($B4,$D1,$00,$80,$005F,$6C,$BB,$EA));

// DVD-related mediatypes
  MEDIATYPE_DVD_ENCRYPTED_PACK: TGUID = (D1:$ED0B916A;D2:$044D;D3:$11D1;D4:($AA,$78,$00,$C0,$004F,$C3,$1D,$60));
  MEDIATYPE_DVD_NAVIGATION: TGUID = (D1:$E06D802E;D2:$DB46;D3:$11CF;D4:($B4,$D1,$00,$80,$005F,$6C,$BB,$EA));
  MEDIASUBTYPE_DVD_NAVIGATION_PCI: TGUID = (D1:$E06D802F;D2:$DB46;D3:$11CF;D4:($B4,$D1,$00,$80,$005F,$6C,$BB,$EA));
  MEDIASUBTYPE_DVD_NAVIGATION_DSI: TGUID = (D1:$E06D8030;D2:$DB46;D3:$11CF;D4:($B4,$D1,$00,$80,$005F,$6C,$BB,$EA));
  MEDIASUBTYPE_DVD_NAVIGATION_PROVIDER: TGUID = (D1:$E06D8031;D2:$DB46;D3:$11CF;D4:($B4,$D1,$00,$80,$005F,$6C,$BB,$EA));

//
// DVD - MPEG2/AC3-related Formats
//

  FORMAT_MPEG2Video: TGUID = (D1:$E06D80E3;D2:$DB46;D3:$11CF;D4:($B4,$D1,$00,$80,$005F,$6C,$BB,$EA));
  FORMAT_DolbyAC3: TGUID = (D1:$E06D80E4;D2:$DB46;D3:$11CF;D4:($B4,$D1,$00,$80,$005F,$6C,$BB,$EA));
  FORMAT_MPEG2Audio: TGUID = (D1:$E06D80E5;D2:$DB46;D3:$11CF;D4:($B4,$D1,$00,$80,$005F,$6C,$BB,$EA));
  FORMAT_DVD_LPCMAudio: TGUID = (D1:$E06D80E6;D2:$DB46;D3:$11CF;D4:($B4,$D1,$00,$80,$005F,$6C,$BB,$EA));

//
// KS Property Set Id (to communicate with the WDM Proxy filter) -- from
// ksmedia.h of WDM DDK.
//

  AM_KSPROPSETID_AC3: TGUID = (D1:$BFABE720;D2:$6E1F;D3:$11D0;D4:($BC,$F2,$44,$45,$53,$54,$00,$00));
  AM_KSPROPSETID_DvdSubPic: TGUID = (D1:$AC390460;D2:$43AF;D3:$11D0;D4:($BD,$6A,$00,$35,$05,$C1,$03,$A9));
  AM_KSPROPSETID_CopyProt: TGUID = (D1:$0E8A0A40;D2:$6AEF;D3:$11D0;D4:($9E,$D0,$00,$A0,$24,$CA,$19,$B3));
  AM_KSPROPSETID_TSRateChange: TGUID = (D1:$A503C5C0;D2:$1D1D;D3:$11D1;D4:($AD,$80,$44,$45,$53,$54,$00,$00));

//
// KS categories from ks.h and ksmedia.h
//
//

  AM_KSCATEGORY_CAPTURE: TGUID = (D1:$65E8773D;D2:$8F56;D3:$11D0;D4:($A3,$B9,$00,$A0,$C9,$22,$31,$96));
  AM_KSCATEGORY_RENDER: TGUID = (D1:$65E8773E;D2:$8F56;D3:$11D0;D4:($A3,$B9,$00,$A0,$C9,$22,$31,$96));
  AM_KSCATEGORY_DATACOMPRESSOR: TGUID = (D1:$1E84C900;D2:$7E70;D3:$11D0;D4:($A5,$D6,$28,$DB,$04,$C1,$00,$00));
  AM_KSCATEGORY_AUDIO: TGUID = (D1:$6994AD04;D2:$93EF;D3:$11D0;D4:($A3,$CC,$00,$A0,$C9,$22,$31,$96));
  AM_KSCATEGORY_VIDEO: TGUID = (D1:$6994AD05;D2:$93EF;D3:$11D0;D4:($A3,$CC,$00,$A0,$C9,$22,$31,$96));
  AM_KSCATEGORY_TVTUNER: TGUID = (D1:$A799A800;D2:$A46D;D3:$11D0;D4:($A1,$8C,$00,$A0,$24,$01,$DC,$D4));
  AM_KSCATEGORY_CROSSBAR: TGUID = (D1:$A799A801;D2:$A46D;D3:$11D0;D4:($A1,$8C,$00,$A0,$24,$01,$DC,$D4));
  AM_KSCATEGORY_TVAUDIO: TGUID = (D1:$A799A802;D2:$A46D;D3:$11D0;D4:($A1,$8C,$00,$A0,$24,$01,$DC,$D4));


//
// guids needed to support IKsPin interface
//
//

  IID_IKsPin: TGUID = (D1:$B61178D1;D2:$A2D9;D3:$11CF;D4:($9E,$53,$00,$AA,$00,$A2,$16,$A1));
  AM_INTERFACESETID_Standard: TGUID = (D1:$1A8766A0;D2:$62CE;D3:$11CF;D4:($A5,$D6,$28,$DB,$04,$C1,$00,$00));

implementation

const
  ole32 = 'ole32.dll';
  quartz = 'quartz.dll';

function QzInitialize; external ole32 name 'CoInitialize';
procedure QzUninitialize; external ole32 name 'CoUninitialize';
procedure QzFreeUnusedLibraries; external ole32 name 'CoFreeUnusedLibraries';

function QzGetMalloc; external ole32 name 'CoGetMalloc';
function QzTaskMemAlloc; external ole32 name 'CoTaskMemAlloc';
function QzTaskMemRealloc; external ole32 name 'CoTaskMemRealloc';
procedure QzTaskMemFree; external ole32 name 'CoTaskMemFree';

function QzCreateFilterObject; external ole32 name 'CoCreateInstance';
function QzCLSIDFromString; external ole32 name 'CLSIDFromString';
function QzStringFromGUID2; external ole32 name 'StringFromGUID2';


function AMGetErrorTextA; external quartz;
function AMGetErrorTextW; external quartz;
function AMGetErrorText; external quartz name 'AMGetErrorTextA';

end.

