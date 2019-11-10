unit DXETable;

interface

{$INCLUDE DelphiXcfg.inc}

uses
  Windows, SysUtils, 
{$IfDef StandardDX}
  DirectDraw, DirectSound,
  {$IfDef DX9}
  Direct3D9, Direct3D, D3DX9, {Direct3D8,} DX7toDX8, DirectInput, DirectPlay8;
  {$Else}
  {$IfDef DX81}
  D3DX8, Direct3D8, DirectInput8, DirectXGraphics, DX7toDX8, DirectPlay8;
  {$Else}
  DirectInput, Direct3D, Direct3DRM, DirectPlay;
  {$EndIf}
  {$EndIf}
{$Else}
  DirectX;
{$EndIf}


function WindowsErrorMsg(ErrorCode: HRESULT): string;
function DDrawErrorMsg(ErrorCode: HRESULT): string;
function D3DErrorMsg(ErrorCode: HRESULT): string;
{$IfNDef DX9}
function D3DRMErrorMsg(ErrorCode: HRESULT): string;
{$EndIf}
function DSoundErrorMsg(ErrorCode: HRESULT): string;
function DInputErrorMsg(ErrorCode: HRESULT): string;
function DPlayErrorMsg(ErrorCode: HRESULT): string;

implementation

uses DXConsts;

function WindowsErrorMsg(ErrorCode: HRESULT): string;
var
  Buf: array [Byte] of Char;
begin
  Result := '';
  if ErrorCode<>0 then
  begin
    if FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil,
      ErrorCode, LOCALE_USER_DEFAULT, Buf, sizeof(Buf), nil)<>0 then
    begin
      Result := Buf;
      {  Last #13#10 is deleted.  }
      while Copy(Result, Length(Result)-1, 2)=#13#10 do
        Result := Copy(Result, 1, Length(Result)-2);
    end else
      Result := Format(SUnknownError, [ErrorCode]);
  end;
end;

function DDrawErrorMsg(ErrorCode: HRESULT): string;
begin               
  case ErrorCode of
    DD_OK                               : Result := 'DD_OK';
    DDERR_ALREADYINITIALIZED            : Result := 'DDERR_ALREADYINITIALIZED';
    DDERR_BLTFASTCANTCLIP               : Result := 'DDERR_BLTFASTCANTCLIP';
    DDERR_CANNOTATTACHSURFACE           : Result := 'DDERR_CANNOTATTACHSURFACE';
    DDERR_CANTCREATEDC                  : Result := 'DDERR_CANTCREATEDC';
    DDERR_CANTDUPLICATE                 : Result := 'DDERR_CANTDUPLICATE';
    DDERR_CLIPPERISUSINGHWND            : Result := 'DDERR_CLIPPERISUSINGHWND';
    DDERR_COLORKEYNOTSET                : Result := 'DDERR_COLORKEYNOTSET';
    DDERR_CURRENTLYNOTAVAIL             : Result := 'DDERR_CURRENTLYNOTAVAIL';
    DDERR_DIRECTDRAWALREADYCREATED      : Result := 'DDERR_DIRECTDRAWALREADYCREATED';
    DDERR_EXCEPTION                     : Result := 'DDERR_EXCEPTION';
    DDERR_EXCLUSIVEMODEALREADYSET       : Result := 'DDERR_EXCLUSIVEMODEALREADYSET';
    DDERR_GENERIC                       : Result := 'DDERR_GENERIC';
    DDERR_HEIGHTALIGN                   : Result := 'DDERR_HEIGHTALIGN';
    DDERR_HWNDALREADYSET                : Result := 'DDERR_HWNDALREADYSET';
    DDERR_HWNDSUBCLASSED                : Result := 'DDERR_HWNDSUBCLASSED';
    DDERR_IMPLICITLYCREATED             : Result := 'DDERR_IMPLICITLYCREATED';
    DDERR_INCOMPATIBLEPRIMARY           : Result := 'DDERR_INCOMPATIBLEPRIMARY';
    DDERR_INVALIDCAPS                   : Result := 'DDERR_INVALIDCAPS';
    DDERR_INVALIDCLIPLIST               : Result := 'DDERR_INVALIDCLIPLIST';
    DDERR_INVALIDDIRECTDRAWGUID         : Result := 'DDERR_INVALIDDIRECTDRAWGUID';
    DDERR_INVALIDMODE                   : Result := 'DDERR_INVALIDMODE';
    DDERR_INVALIDOBJECT                 : Result := 'DDERR_INVALIDOBJECT';
    DDERR_INVALIDPARAMS                 : Result := 'DDERR_INVALIDPARAMS';
    DDERR_INVALIDPIXELFORMAT            : Result := 'DDERR_INVALIDPIXELFORMAT';
    DDERR_INVALIDPOSITION               : Result := 'DDERR_INVALIDPOSITION';
    DDERR_INVALIDRECT                   : Result := 'DDERR_INVALIDRECT';
    DDERR_LOCKEDSURFACES                : Result := 'DDERR_LOCKEDSURFACES';
    DDERR_NO3D                          : Result := 'DDERR_NO3D';
    DDERR_NOALPHAHW                     : Result := 'DDERR_NOALPHAHW';
    DDERR_NOBLTHW                       : Result := 'DDERR_NOBLTHW';
    DDERR_NOCLIPLIST                    : Result := 'DDERR_NOCLIPLIST';
    DDERR_NOCLIPPERATTACHED             : Result := 'DDERR_NOCLIPPERATTACHED';
    DDERR_NOCOLORCONVHW                 : Result := 'DDERR_NOCOLORCONVHW';
    DDERR_NOCOLORKEY                    : Result := 'DDERR_NOCOLORKEY';
    DDERR_NOCOLORKEYHW                  : Result := 'DDERR_NOCOLORKEYHW';
    DDERR_NOCOOPERATIVELEVELSET         : Result := 'DDERR_NOCOOPERATIVELEVELSET';
    DDERR_NODC                          : Result := 'DDERR_NODC';
    DDERR_NODDROPSHW                    : Result := 'DDERR_NODDROPSHW';
    DDERR_NODIRECTDRAWHW                : Result := 'DDERR_NODIRECTDRAWHW';
    DDERR_NOEMULATION                   : Result := 'DDERR_NOEMULATION';
    DDERR_NOEXCLUSIVEMODE               : Result := 'DDERR_NOEXCLUSIVEMODE';
    DDERR_NOFLIPHW                      : Result := 'DDERR_NOFLIPHW';
    DDERR_NOGDI                         : Result := 'DDERR_NOGDI';
    DDERR_NOHWND                        : Result := 'DDERR_NOHWND';
    DDERR_NOMIRRORHW                    : Result := 'DDERR_NOMIRRORHW';
    DDERR_NOOVERLAYDEST                 : Result := 'DDERR_NOOVERLAYDEST';
    DDERR_NOOVERLAYHW                   : Result := 'DDERR_NOOVERLAYHW';
    DDERR_NOPALETTEATTACHED             : Result := 'DDERR_NOPALETTEATTACHED';
    DDERR_NOPALETTEHW                   : Result := 'DDERR_NOPALETTEHW';
    DDERR_NORASTEROPHW                  : Result := 'DDERR_NORASTEROPHW';
    DDERR_NOROTATIONHW                  : Result := 'DDERR_NOROTATIONHW';
    DDERR_NOSTRETCHHW                   : Result := 'DDERR_NOSTRETCHHW';
    DDERR_NOT4BITCOLOR                  : Result := 'DDERR_NOT4BITCOLOR';
    DDERR_NOT4BITCOLORINDEX             : Result := 'DDERR_NOT4BITCOLORINDEX';
    DDERR_NOT8BITCOLOR                  : Result := 'DDERR_NOT8BITCOLOR';
    DDERR_NOTAOVERLAYSURFACE            : Result := 'DDERR_NOTAOVERLAYSURFACE';
    DDERR_NOTEXTUREHW                   : Result := 'DDERR_NOTEXTUREHW';
    DDERR_NOTFLIPPABLE                  : Result := 'DDERR_NOTFLIPPABLE';
    DDERR_NOTFOUND                      : Result := 'DDERR_NOTFOUND';
    DDERR_NOTLOCKED                     : Result := 'DDERR_NOTLOCKED';
    DDERR_NOTPALETTIZED                 : Result := 'DDERR_NOTPALETTIZED';
    DDERR_NOVSYNCHW                     : Result := 'DDERR_NOVSYNCHW';
    DDERR_NOZBUFFERHW                   : Result := 'DDERR_NOZBUFFERHW';
    DDERR_NOZOVERLAYHW                  : Result := 'DDERR_NOZOVERLAYHW';
    DDERR_OUTOFCAPS                     : Result := 'DDERR_OUTOFCAPS';
    DDERR_OUTOFMEMORY                   : Result := 'DDERR_OUTOFMEMORY';
    DDERR_OUTOFVIDEOMEMORY              : Result := 'DDERR_OUTOFVIDEOMEMORY';
    DDERR_OVERLAYCANTCLIP               : Result := 'DDERR_OVERLAYCANTCLIP';
    DDERR_OVERLAYCOLORKEYONLYONEACTIVE  : Result := 'DDERR_OVERLAYCOLORKEYONLYONEACTIVE';
    DDERR_OVERLAYNOTVISIBLE             : Result := 'DDERR_OVERLAYNOTVISIBLE';
    DDERR_PALETTEBUSY                   : Result := 'DDERR_PALETTEBUSY';
    DDERR_PRIMARYSURFACEALREADYEXISTS   : Result := 'DDERR_PRIMARYSURFACEALREADYEXISTS';
    DDERR_REGIONTOOSMALL                : Result := 'DDERR_REGIONTOOSMALL';
    DDERR_SURFACEALREADYATTACHED        : Result := 'DDERR_SURFACEALREADYATTACHED';
    DDERR_SURFACEALREADYDEPENDENT       : Result := 'DDERR_SURFACEALREADYDEPENDENT';
    DDERR_SURFACEBUSY                   : Result := 'DDERR_SURFACEBUSY';
    DDERR_SURFACEISOBSCURED             : Result := 'DDERR_SURFACEISOBSCURED';
    DDERR_SURFACELOST                   : Result := 'DDERR_SURFACELOST';
    DDERR_SURFACENOTATTACHED            : Result := 'DDERR_SURFACENOTATTACHED';
    DDERR_TOOBIGHEIGHT                  : Result := 'DDERR_TOOBIGHEIGHT';
    DDERR_TOOBIGSIZE                    : Result := 'DDERR_TOOBIGSIZE';
    DDERR_TOOBIGWIDTH                   : Result := 'DDERR_TOOBIGWIDTH';
    DDERR_UNSUPPORTED                   : Result := 'DDERR_UNSUPPORTED';
    DDERR_UNSUPPORTEDFORMAT             : Result := 'DDERR_UNSUPPORTEDFORMAT';
    DDERR_UNSUPPORTEDMASK               : Result := 'DDERR_UNSUPPORTEDMASK';
    DDERR_VERTICALBLANKINPROGRESS       : Result := 'DDERR_VERTICALBLANKINPROGRESS';
    DDERR_WASSTILLDRAWING               : Result := 'DDERR_WASSTILLDRAWING';
    DDERR_WRONGMODE                     : Result := 'DDERR_WRONGMODE';
    DDERR_XALIGN                        : Result := 'DDERR_XALIGN';
  else
    Result := WindowsErrorMsg(ErrorCode);
  end;
end;

function D3DErrorMsg(ErrorCode: HRESULT): string;
begin
  case ErrorCode of
    D3D_OK                              : Result := 'D3D_OK';
    D3DERR_BADMAJORVERSION              : Result := 'D3DERR_BADMAJORVERSION';
    D3DERR_BADMINORVERSION              : Result := 'D3DERR_BADMINORVERSION';
    D3DERR_INVALID_DEVICE               : Result := 'D3DERR_INVALID_DEVICE';
    D3DERR_INITFAILED                   : Result := 'D3DERR_INITFAILED';
    D3DERR_DEVICEAGGREGATED             : Result := 'D3DERR_DEVICEAGGREGATED';
    D3DERR_EXECUTE_CREATE_FAILED        : Result := 'D3DERR_EXECUTE_CREATE_FAILED';
    D3DERR_EXECUTE_DESTROY_FAILED       : Result := 'D3DERR_EXECUTE_DESTROY_FAILED';
    D3DERR_EXECUTE_LOCK_FAILED          : Result := 'D3DERR_EXECUTE_LOCK_FAILED';
    D3DERR_EXECUTE_UNLOCK_FAILED        : Result := 'D3DERR_EXECUTE_UNLOCK_FAILED';
    D3DERR_EXECUTE_LOCKED               : Result := 'D3DERR_EXECUTE_LOCKED';
    D3DERR_EXECUTE_NOT_LOCKED           : Result := 'D3DERR_EXECUTE_NOT_LOCKED';
    D3DERR_EXECUTE_FAILED               : Result := 'D3DERR_EXECUTE_FAILED';
    D3DERR_EXECUTE_CLIPPED_FAILED       : Result := 'D3DERR_EXECUTE_CLIPPED_FAILED';
    D3DERR_TEXTURE_NO_SUPPORT           : Result := 'D3DERR_TEXTURE_NO_SUPPORT';
    D3DERR_TEXTURE_CREATE_FAILED        : Result := 'D3DERR_TEXTURE_CREATE_FAILED';
    D3DERR_TEXTURE_DESTROY_FAILED       : Result := 'D3DERR_TEXTURE_DESTROY_FAILED';
    D3DERR_TEXTURE_LOCK_FAILED          : Result := 'D3DERR_TEXTURE_LOCK_FAILED';
    D3DERR_TEXTURE_UNLOCK_FAILED        : Result := 'D3DERR_TEXTURE_UNLOCK_FAILED';
    D3DERR_TEXTURE_LOAD_FAILED          : Result := 'D3DERR_TEXTURE_LOAD_FAILED';
    D3DERR_TEXTURE_SWAP_FAILED          : Result := 'D3DERR_TEXTURE_SWAP_FAILED';
    D3DERR_TEXTURE_LOCKED               : Result := 'D3DERR_TEXTURE_LOCKED';
    D3DERR_TEXTURE_NOT_LOCKED           : Result := 'D3DERR_TEXTURE_NOT_LOCKED';
    D3DERR_TEXTURE_GETSURF_FAILED       : Result := 'D3DERR_TEXTURE_GETSURF_FAILED';
    D3DERR_MATRIX_CREATE_FAILED         : Result := 'D3DERR_MATRIX_CREATE_FAILED';
    D3DERR_MATRIX_DESTROY_FAILED        : Result := 'D3DERR_MATRIX_DESTROY_FAILED';
    D3DERR_MATRIX_SETDATA_FAILED        : Result := 'D3DERR_MATRIX_SETDATA_FAILED';
    D3DERR_MATRIX_GETDATA_FAILED        : Result := 'D3DERR_MATRIX_GETDATA_FAILED';
    D3DERR_SETVIEWPORTDATA_FAILED       : Result := 'D3DERR_SETVIEWPORTDATA_FAILED';

    D3DERR_INVALIDCURRENTVIEWPORT       : Result := 'D3DERR_INVALIDCURRENTVIEWPORT';
    D3DERR_INVALIDPRIMITIVETYPE         : Result := 'D3DERR_INVALIDPRIMITIVETYPE';
    D3DERR_INVALIDVERTEXTYPE            : Result := 'D3DERR_INVALIDVERTEXTYPE';
    D3DERR_TEXTURE_BADSIZE              : Result := 'D3DERR_TEXTURE_BADSIZE';
    D3DERR_INVALIDRAMPTEXTURE           : Result := 'D3DERR_INVALIDRAMPTEXTURE';
    D3DERR_MATERIAL_CREATE_FAILED       : Result := 'D3DERR_MATERIAL_CREATE_FAILED';
    D3DERR_MATERIAL_DESTROY_FAILED      : Result := 'D3DERR_MATERIAL_DESTROY_FAILED';
    D3DERR_MATERIAL_SETDATA_FAILED      : Result := 'D3DERR_MATERIAL_SETDATA_FAILED';
    D3DERR_MATERIAL_GETDATA_FAILED      : Result := 'D3DERR_MATERIAL_GETDATA_FAILED';
    D3DERR_INVALIDPALETTE               : Result := 'D3DERR_INVALIDPALETTE';

    D3DERR_ZBUFF_NEEDS_SYSTEMMEMORY     : Result := 'D3DERR_ZBUFF_NEEDS_SYSTEMMEMORY';
    D3DERR_ZBUFF_NEEDS_VIDEOMEMORY      : Result := 'D3DERR_ZBUFF_NEEDS_VIDEOMEMORY';
    D3DERR_SURFACENOTINVIDMEM           : Result := 'D3DERR_SURFACENOTINVIDMEM';
    D3DERR_LIGHT_SET_FAILED             : Result := 'D3DERR_LIGHT_SET_FAILED';
    D3DERR_LIGHTHASVIEWPORT             : Result := 'D3DERR_LIGHTHASVIEWPORT';

    D3DERR_LIGHTNOTINTHISVIEWPORT       : Result := 'D3DERR_LIGHTNOTINTHISVIEWPORT';
    D3DERR_SCENE_IN_SCENE               : Result := 'D3DERR_SCENE_IN_SCENE';
    D3DERR_SCENE_NOT_IN_SCENE           : Result := 'D3DERR_SCENE_NOT_IN_SCENE';


    D3DERR_SCENE_BEGIN_FAILED           : Result := 'D3DERR_SCENE_BEGIN_FAILED';
    D3DERR_SCENE_END_FAILED             : Result := 'D3DERR_SCENE_END_FAILED';
    D3DERR_INBEGIN                      : Result := 'D3DERR_INBEGIN';
    D3DERR_NOTINBEGIN                   : Result := 'D3DERR_NOTINBEGIN';
    D3DERR_NOVIEWPORTS                  : Result := 'D3DERR_NOVIEWPORTS';
    D3DERR_VIEWPORTDATANOTSET           : Result := 'D3DERR_VIEWPORTDATANOTSET';
    D3DERR_VIEWPORTHASNODEVICE          : Result := 'D3DERR_VIEWPORTHASNODEVICE';

    D3DERR_NOCURRENTVIEWPORT            : Result := 'D3DERR_NOCURRENTVIEWPORT';
  else
    Result := WindowsErrorMsg(ErrorCode);                                                          
  end;
end;
{$IfNDef DX9}
function D3DRMErrorMsg(ErrorCode: HRESULT): string;
begin
  case ErrorCode of
    D3DRM_OK                            : Result := 'D3DRM_OK';
    D3DRMERR_BADALLOC                   : Result := 'D3DRMERR_BADALLOC';
    D3DRMERR_BADDEVICE                  : Result := 'D3DRMERR_BADDEVICE';
    D3DRMERR_BADFILE                    : Result := 'D3DRMERR_BADFILE';
    D3DRMERR_BADMAJORVERSION            : Result := 'D3DRMERR_BADMAJORVERSION';
    D3DRMERR_BADMINORVERSION            : Result := 'D3DRMERR_BADMINORVERSION';
    D3DRMERR_BADOBJECT                  : Result := 'D3DRMERR_BADOBJECT';
    D3DRMERR_BADTYPE                    : Result := 'D3DRMERR_BADTYPE';
    D3DRMERR_BADVALUE                   : Result := 'D3DRMERR_BADVALUE';
    D3DRMERR_FACEUSED                   : Result := 'D3DRMERR_FACEUSED';
    D3DRMERR_FILENOTFOUND               : Result := 'D3DRMERR_FILENOTFOUND';
    D3DRMERR_NOTDONEYET                 : Result := 'D3DRMERR_NOTDONEYET';
    D3DRMERR_NOTFOUND                   : Result := 'D3DRMERR_NOTFOUND';
    D3DRMERR_UNABLETOEXECUTE            : Result := 'D3DRMERR_UNABLETOEXECUTE';
  else
    Result := WindowsErrorMsg(ErrorCode);
  end;
end;
{$EndIf}
function DSoundErrorMsg(ErrorCode: HRESULT): string;
begin
  case ErrorCode of
    DS_OK                               : Result := 'DS_OK';
    DSERR_ALLOCATED                     : Result := 'DSERR_ALLOCATED';
    DSERR_ALREADYINITIALIZED            : Result := 'DSERR_ALREADYINITIALIZED';
    DSERR_BADFORMAT                     : Result := 'DSERR_BADFORMAT';
    DSERR_BUFFERLOST                    : Result := 'DSERR_BUFFERLOST';
    DSERR_CONTROLUNAVAIL                : Result := 'DSERR_CONTROLUNAVAIL';
    DSERR_GENERIC                       : Result := 'DSERR_GENERIC';
    DSERR_INVALIDPARAM                  : Result := 'DSERR_INVALIDPARAM';
    DSERR_INVALIDCALL                   : Result := 'DSERR_INVALIDCALL';
    DSERR_NOAGGREGATION                 : Result := 'DSERR_NOAGGREGATION';
    DSERR_NODRIVER                      : Result := 'DSERR_NODRIVER';
    DSERR_OUTOFMEMORY                   : Result := 'DSERR_OUTOFMEMORY';
    DSERR_PRIOLEVELNEEDED               : Result := 'DSERR_PRIOLEVELNEEDED';
    DSERR_UNSUPPORTED                   : Result := 'DSERR_UNSUPPORTED';
  else
    Result := WindowsErrorMsg(ErrorCode);
  end;
end;

function DInputErrorMsg(ErrorCode: HRESULT): string;
begin
  case ErrorCode of
    DI_OK                               : Result := 'DI_OK';
    DI_NOTATTACHED                      : Result := 'DI_NOTATTACHED, DI_BUFFEROVERFLOW, DI_PROPNOEFFECT, DI_POLLEDDEVICE';
    DIERR_OLDDIRECTINPUTVERSION         : Result := 'DIERR_OLDDIRECTINPUTVERSION';
    DIERR_BETADIRECTINPUTVERSION        : Result := 'DIERR_BETADIRECTINPUTVERSION';
    DIERR_BADDRIVERVER                  : Result := 'DIERR_BADDRIVERVER';
    DIERR_DEVICENOTREG                  : Result := 'DIERR_DEVICENOTREG';
    DIERR_OBJECTNOTFOUND                : Result := 'DIERR_OBJECTNOTFOUND';
    DIERR_INVALIDPARAM                  : Result := 'DIERR_INVALIDPARAM';
    DIERR_NOINTERFACE                   : Result := 'DIERR_NOINTERFACE';
    DIERR_GENERIC                       : Result := 'DIERR_GENERIC';
    DIERR_OUTOFMEMORY                   : Result := 'DIERR_OUTOFMEMORY';
    DIERR_UNSUPPORTED                   : Result := 'DIERR_UNSUPPORTED';
    DIERR_NOTINITIALIZED                : Result := 'DIERR_NOTINITIALIZED';
    DIERR_ALREADYINITIALIZED            : Result := 'DIERR_ALREADYINITIALIZED';
    DIERR_NOAGGREGATION                 : Result := 'DIERR_NOAGGREGATION';
    DIERR_OTHERAPPHASPRIO               : Result := 'DIERR_OTHERAPPHASPRIO, DIERR_READONLY, DIERR_HANDLEEXISTS';
    DIERR_INPUTLOST                     : Result := 'DIERR_INPUTLOST';
    DIERR_ACQUIRED                      : Result := 'DIERR_ACQUIRED';
    DIERR_NOTACQUIRED                   : Result := 'DIERR_NOTACQUIRED';
    E_PENDING                           : Result := 'E_PENDING';
  else
    Result := WindowsErrorMsg(ErrorCode);
  end;
end;
{$IfDef DX9}
function DPlayErrorMsg(ErrorCode: HRESULT): string;
begin
  case ErrorCode of
    DPN_OK                               : Result := 'DPN_OK';
    DPNERR_ALREADYINITIALIZED            : Result := 'DPNERR_ALREADYINITIALIZED';
    //DPNERR_ACCESSDENIED                  : Result := 'DPNERR_ACCESSDENIED';
    //DPNERR_ACTIVEPLAYERS                 : Result := 'DPNERR_ACTIVEPLAYERS';
    DPNERR_BUFFERTOOSMALL                : Result := 'DPNERR_BUFFERTOOSMALL';
    //DPNERR_CANTADDPLAYER                 : Result := 'DPNERR_CANTADDPLAYER';
    DPNERR_CANTCREATEGROUP               : Result := 'DPNERR_CANTCREATEGROUP';
    DPNERR_CANTCREATEPLAYER              : Result := 'DPNERR_CANTCREATEPLAYER';
    //DPNERR_CANTCREATESESSION             : Result := 'DPNERR_CANTCREATESESSION';
    //DPNERR_CAPSNOTAVAILABLEYET           : Result := 'DPNERR_CAPSNOTAVAILABLEYET';
    DPNERR_EXCEPTION                     : Result := 'DPNERR_EXCEPTION';
    DPNERR_GENERIC                       : Result := 'DPNERR_GENERIC';
    DPNERR_INVALIDFLAGS                  : Result := 'DPNERR_INVALIDFLAGS';
    DPNERR_INVALIDOBJECT                 : Result := 'DPNERR_INVALIDOBJECT';
    DPNERR_INVALIDPARAM                  : Result := 'DPNERR_INVALIDPARAM, DPNERR_INVALIDPARAMS';
    DPNERR_INVALIDPLAYER                 : Result := 'DPNERR_INVALIDPLAYER';
    DPNERR_INVALIDGROUP                  : Result := 'DPNERR_INVALIDGROUP';
    DPNERR_NOCAPS                        : Result := 'DPNERR_NOCAPS';
    DPNERR_NOCONNECTION                  : Result := 'DPNERR_NOCONNECTION';
    //DPNERR_NOMEMORY                      : Result := 'DPNERR_NOMEMORY, DPNERR_OUTOFMEMORY';
    //DPNERR_NOMESSAGES                    : Result := 'DPNERR_NOMESSAGES';
    //DPNERR_NONAMESERVERFOUND             : Result := 'DPNERR_NONAMESERVERFOUND';
    //DPNERR_NOPLAYERS                     : Result := 'DPNERR_NOPLAYERS';
    //DPNERR_NOSESSIONS                    : Result := 'DPNERR_NOSESSIONS';
    DPNERR_PENDING                       : Result := 'DPNERR_PENDING';
    //DPNERR_SENDTOOBIG                    : Result := 'DPNERR_SENDTOOBIG';
    //DPNERR_TIMEOUT                       : Result := 'DPNERR_TIMEOUT';
    //DPNERR_UNAVAILABLE                   : Result := 'DPNERR_UNAVAILABLE';
    DPNERR_UNSUPPORTED                   : Result := 'DPNERR_UNSUPPORTED';
    //DPNERR_BUSY                          : Result := 'DPNERR_BUSY';
    DPNERR_USERCANCEL                    : Result := 'DPNERR_USERCANCEL';
    DPNERR_NOINTERFACE                   : Result := 'DPNERR_NOINTERFACE';
    //DPNERR_CANNOTCREATESERVER            : Result := 'DPNERR_CANNOTCREATESERVER';
    DPNERR_PLAYERLOST                    : Result := 'DPNERR_PLAYERLOST';
    //DPNERR_SESSIONLOST                   : Result := 'DPNERR_SESSIONLOST';
    DPNERR_UNINITIALIZED                 : Result := 'DPNERR_UNINITIALIZED';
    //DPNERR_NONEWPLAYERS                  : Result := 'DPNERR_NONEWPLAYERS';
    DPNERR_INVALIDPASSWORD               : Result := 'DPNERR_INVALIDPASSWORD';
    DPNERR_CONNECTING                    : Result := 'DPNERR_CONNECTING';
    //DPNERR_BUFFERTOOLARGE                : Result := 'DPNERR_BUFFERTOOLARGE';
    //DPNERR_CANTCREATEPROCESS             : Result := 'DPNERR_CANTCREATEPROCESS';
    //DPNERR_APPNOTSTARTED                 : Result := 'DPNERR_APPNOTSTARTED';
    DPNERR_INVALIDINTERFACE              : Result := 'DPNERR_INVALIDINTERFACE';
    //DPNERR_NOSERVICEPROVIDER             : Result := 'DPNERR_NOSERVICEPROVIDER';
    //DPNERR_UNKNOWNAPPLICATION            : Result := 'DPNERR_UNKNOWNAPPLICATION';
    //DPNERR_NOTLOBBIED                    : Result := 'DPNERR_NOTLOBBIED';
    //DPNERR_SERVICEPROVIDERLOADED         : Result := 'DPNERR_SERVICEPROVIDERLOADED';
    DPNERR_NOTREGISTERED                 : Result := 'DPNERR_NOTREGISTERED';
// Security related errors
    //DPNERR_AUTHENTICATIONFAILED          : Result := 'DPNERR_AUTHENTICATIONFAILED';
    //DPNERR_CANTLOADSSPI                  : Result := 'DPNERR_CANTLOADSSPI';
    //DPNERR_ENCRYPTIONFAILED              : Result := 'DPNERR_ENCRYPTIONFAILED';
    //DPNERR_SIGNFAILED                    : Result := 'DPNERR_SIGNFAILED';
    //DPNERR_CANTLOADSECURITYPACKAGE       : Result := 'DPNERR_CANTLOADSECURITYPACKAGE';
    //DPNERR_ENCRYPTIONNOTSUPPORTED        : Result := 'DPNERR_ENCRYPTIONNOTSUPPORTED';
    //DPNERR_CANTLOADCAPI                  : Result := 'DPNERR_CANTLOADCAPI';
    //DPNERR_NOTLOGGEDIN                   : Result := 'DPNERR_NOTLOGGEDIN';
    //DPNERR_LOGONDENIED                   : Result := 'DPNERR_LOGONDENIED';
  else
    Result := WindowsErrorMsg(ErrorCode);
  end;
end;
{$Else}
function DPlayErrorMsg(ErrorCode: HRESULT): string;
begin
  case ErrorCode of
    DP_OK                               : Result := 'DP_OK';
    DPERR_ALREADYINITIALIZED            : Result := 'DPERR_ALREADYINITIALIZED';
    DPERR_ACCESSDENIED                  : Result := 'DPERR_ACCESSDENIED';
    DPERR_ACTIVEPLAYERS                 : Result := 'DPERR_ACTIVEPLAYERS';
    DPERR_BUFFERTOOSMALL                : Result := 'DPERR_BUFFERTOOSMALL';
    DPERR_CANTADDPLAYER                 : Result := 'DPERR_CANTADDPLAYER';
    DPERR_CANTCREATEGROUP               : Result := 'DPERR_CANTCREATEGROUP';
    DPERR_CANTCREATEPLAYER              : Result := 'DPERR_CANTCREATEPLAYER';
    DPERR_CANTCREATESESSION             : Result := 'DPERR_CANTCREATESESSION';
    DPERR_CAPSNOTAVAILABLEYET           : Result := 'DPERR_CAPSNOTAVAILABLEYET';
    DPERR_EXCEPTION                     : Result := 'DPERR_EXCEPTION';
    DPERR_GENERIC                       : Result := 'DPERR_GENERIC';
    DPERR_INVALIDFLAGS                  : Result := 'DPERR_INVALIDFLAGS';
    DPERR_INVALIDOBJECT                 : Result := 'DPERR_INVALIDOBJECT';
    DPERR_INVALIDPARAM                  : Result := 'DPERR_INVALIDPARAM, DPERR_INVALIDPARAMS';
    DPERR_INVALIDPLAYER                 : Result := 'DPERR_INVALIDPLAYER';
    DPERR_INVALIDGROUP                  : Result := 'DPERR_INVALIDGROUP';
    DPERR_NOCAPS                        : Result := 'DPERR_NOCAPS';
    DPERR_NOCONNECTION                  : Result := 'DPERR_NOCONNECTION';
    DPERR_NOMEMORY                      : Result := 'DPERR_NOMEMORY, DPERR_OUTOFMEMORY';
    DPERR_NOMESSAGES                    : Result := 'DPERR_NOMESSAGES';
    DPERR_NONAMESERVERFOUND             : Result := 'DPERR_NONAMESERVERFOUND';
    DPERR_NOPLAYERS                     : Result := 'DPERR_NOPLAYERS';
    DPERR_NOSESSIONS                    : Result := 'DPERR_NOSESSIONS';
    DPERR_PENDING                       : Result := 'DPERR_PENDING';
    DPERR_SENDTOOBIG                    : Result := 'DPERR_SENDTOOBIG';
    DPERR_TIMEOUT                       : Result := 'DPERR_TIMEOUT';
    DPERR_UNAVAILABLE                   : Result := 'DPERR_UNAVAILABLE';
    DPERR_UNSUPPORTED                   : Result := 'DPERR_UNSUPPORTED';
    DPERR_BUSY                          : Result := 'DPERR_BUSY';
    DPERR_USERCANCEL                    : Result := 'DPERR_USERCANCEL';
    DPERR_NOINTERFACE                   : Result := 'DPERR_NOINTERFACE';
    DPERR_CANNOTCREATESERVER            : Result := 'DPERR_CANNOTCREATESERVER';
    DPERR_PLAYERLOST                    : Result := 'DPERR_PLAYERLOST';
    DPERR_SESSIONLOST                   : Result := 'DPERR_SESSIONLOST';
    DPERR_UNINITIALIZED                 : Result := 'DPERR_UNINITIALIZED';
    DPERR_NONEWPLAYERS                  : Result := 'DPERR_NONEWPLAYERS';
    DPERR_INVALIDPASSWORD               : Result := 'DPERR_INVALIDPASSWORD';
    DPERR_CONNECTING                    : Result := 'DPERR_CONNECTING';
    DPERR_BUFFERTOOLARGE                : Result := 'DPERR_BUFFERTOOLARGE';
    DPERR_CANTCREATEPROCESS             : Result := 'DPERR_CANTCREATEPROCESS';
    DPERR_APPNOTSTARTED                 : Result := 'DPERR_APPNOTSTARTED';
    DPERR_INVALIDINTERFACE              : Result := 'DPERR_INVALIDINTERFACE';
    DPERR_NOSERVICEPROVIDER             : Result := 'DPERR_NOSERVICEPROVIDER';
    DPERR_UNKNOWNAPPLICATION            : Result := 'DPERR_UNKNOWNAPPLICATION';
    DPERR_NOTLOBBIED                    : Result := 'DPERR_NOTLOBBIED';
    DPERR_SERVICEPROVIDERLOADED         : Result := 'DPERR_SERVICEPROVIDERLOADED';
    DPERR_NOTREGISTERED                 : Result := 'DPERR_NOTREGISTERED';
// Security related errors
    DPERR_AUTHENTICATIONFAILED          : Result := 'DPERR_AUTHENTICATIONFAILED';
    DPERR_CANTLOADSSPI                  : Result := 'DPERR_CANTLOADSSPI';
    DPERR_ENCRYPTIONFAILED              : Result := 'DPERR_ENCRYPTIONFAILED';
    DPERR_SIGNFAILED                    : Result := 'DPERR_SIGNFAILED';
    DPERR_CANTLOADSECURITYPACKAGE       : Result := 'DPERR_CANTLOADSECURITYPACKAGE';
    DPERR_ENCRYPTIONNOTSUPPORTED        : Result := 'DPERR_ENCRYPTIONNOTSUPPORTED';
    DPERR_CANTLOADCAPI                  : Result := 'DPERR_CANTLOADCAPI';
    DPERR_NOTLOGGEDIN                   : Result := 'DPERR_NOTLOGGEDIN';
    DPERR_LOGONDENIED                   : Result := 'DPERR_LOGONDENIED';
  else
    Result := WindowsErrorMsg(ErrorCode);
  end;
end;
{$EndIf}
end.
