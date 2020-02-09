unit clEvent;
//消息管理器

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DirectX, DXClass, Grobal2, ExtCtrls, HUtil32, EdCode,
  CliUtil, MShare, Share;


const
{$IF CUSTOMLIBFILE = 1}
   ZOMBIDIGUPDUSTBASE = 420;
   STONEFRAGMENTBASE = 10;
   HOLYCURTAINBASE = 20;
   FIREBURNBASE = 40;
   SCULPTUREFRAGMENT = 59;
{$ELSE}
   ZOMBIDIGUPDUSTBASE = 420;
   STONEFRAGMENTBASE = 64;
   HOLYCURTAINBASE = 1390;
   FIREBURNBASE = 1630;
   SCULPTUREFRAGMENT = 1349;
{$IFEND}
type
  TClEvent = class
    m_nX      :Integer;
    m_nY      :Integer;
    m_nDir    :Integer;
    m_nPx     :Integer;
    m_nPy     :Integer;
    m_nEventType  :Integer;
    m_nEventParam :Integer;
    m_nServerId   :Integer;
    m_Dsurface    :TDirectDrawSurface;
    m_boBlend     :Boolean;
    m_dwFrameTime :LongWord;
    m_dwCurframe  :LongWord;
    m_nLight      :Integer;
   private
   public
      constructor Create (svid, ax, ay, evtype: integer);
      destructor Destroy; override;
      procedure DrawEvent (backsurface: TDirectDrawSurface; ax, ay: integer); dynamic;
      procedure Run; dynamic;
   end;

   TClEventManager = class
   private
   public
      EventList: TList;
      constructor Create;
      destructor Destroy; override;
      procedure ClearEvents;
      function  AddEvent (evn: TClEvent): TClEvent;
      procedure DelEvent (evn: TClEvent);
      procedure DelEventById (svid: integer);
      function  GetEvent (ax, ay, etype: integer): TClEvent;
      procedure Execute;
   end;


implementation

uses
   ClMain;

constructor TClEvent.Create (svid, ax, ay, evtype: integer);
begin
   m_nServerId := svid;
   m_nX := ax;
   m_nY := ay;
   m_nEventType := evtype;
   m_nEventParam := 0;
   m_boBlend := FALSE;
   m_dwFrameTime := GetTickCount;
   m_dwCurframe := 0;
   m_nLight := 0;
end;

destructor TClEvent.Destroy;
begin
   inherited Destroy;
end;

procedure TClEvent.DrawEvent (backsurface: TDirectDrawSurface; ax, ay: integer);
begin
   if m_Dsurface <> nil then
      if m_boBlend then DrawBlend (backsurface, ax + m_nPx, ay + m_nPy, m_Dsurface, 1)
      else backsurface.Draw(ax + m_nPx, ay+m_nPy, m_Dsurface.ClientRect, m_Dsurface, TRUE);
end;

procedure TClEvent.Run;
begin
  m_Dsurface := nil;
  if GetTickCount - m_dwFrameTime > 20 then begin
    m_dwFrameTime := GetTickCount;
    Inc (m_dwCurframe);
  end;
  case m_nEventType of
{$IF CUSTOMLIBFILE = 1}
    ET_DIGOUTZOMBI: m_Dsurface := g_WEventEffectImages.GetCachedImage (m_nDir, m_nPx, m_nPy);
{$ELSE}
    ET_DIGOUTZOMBI: m_Dsurface := FrmMain.WMon6Img.GetCachedImage (ZOMBIDIGUPDUSTBASE+m_nDir, m_nPx, m_nPy);
{$IFEND}
    ET_PILESTONES: begin
      if m_nEventParam <= 0 then m_nEventParam := 1;
      if m_nEventParam > 5 then m_nEventParam := 5;
{$IF CUSTOMLIBFILE = 1}
      m_Dsurface := g_WEventEffectImages.GetCachedImage (STONEFRAGMENTBASE+(m_nEventParam - 1), m_nPx, m_nPy);
{$ELSE}
      m_Dsurface := FrmMain.WEffectImg.GetCachedImage (STONEFRAGMENTBASE+(m_nEventParam-1), m_nPx, m_nPy);
{$IFEND}
    end;
    ET_HOLYCURTAIN: begin
{$IF CUSTOMLIBFILE = 1}
      m_Dsurface := g_WEventEffectImages.GetCachedImage(HOLYCURTAINBASE+(m_dwCurframe mod 10), m_nPx, m_nPy);
{$ELSE}
      m_Dsurface := g_WMagicImages.GetCachedImage(HOLYCURTAINBASE+(m_dwCurframe mod 10), m_nPx, m_nPy);
{$IFEND}

      m_boBlend := TRUE;
      m_nLight := 1;
    end;
    ET_FIRE: begin
{$IF CUSTOMLIBFILE = 1}
      m_Dsurface := g_WEventEffectImages.GetCachedImage(FIREBURNBASE+((m_dwCurframe div 2) mod 6), m_nPx, m_nPy);
{$ELSE}
      m_Dsurface := g_WMagicImages.GetCachedImage(FIREBURNBASE+((m_dwCurframe div 2) mod 6), m_nPx, m_nPy);
{$IFEND}


      m_boBlend := TRUE;
      m_nLight := 1;
    end;
    ET_SCULPEICE: begin
{$IF CUSTOMLIBFILE = 1}
      m_Dsurface := g_WEventEffectImages.GetCachedImage(SCULPTUREFRAGMENT, m_nPx, m_nPy);
{$ELSE}
      m_Dsurface := FrmMain.WMon7Img.GetCachedImage(SCULPTUREFRAGMENT, m_nPx, m_nPy);
{$IFEND}
    end;
  end;
end;


{-----------------------------------------------------------------------------}



{-----------------------------------------------------------------------------}

constructor TClEventManager.Create;
begin
   EventList := TList.Create;
end;

destructor TClEventManager.Destroy;
var
  i: integer;
begin
  for i:=0 to EventList.Count-1 do
    TClEvent(EventList[i]).Free;
  EventList.Free;
  inherited Destroy;
end;

procedure TClEventManager.ClearEvents;
var
  i: integer;
begin
  for i:=0 to EventList.Count-1 do
    TClEvent(EventList[i]).Free;
  EventList.Clear;
end;

function  TClEventManager.AddEvent (evn: TClEvent): TClEvent;
var
  i: integer;
  event: TClEvent;
begin
  for i:=0 to EventList.Count-1 do
    if (EventList[i] = evn) or (TClEvent(EventList[i]).m_nServerId = evn.m_nServerId) then begin
      evn.Free;
      Result := nil;
      exit;
    end;
  EventList.Add (evn);
  Result := evn;
end;

procedure TClEventManager.DelEvent (evn: TClEvent);
var
  i: integer;
begin
  for i:=0 to EventList.Count-1 do
    if EventList[i] = evn then begin
      TClEvent(EventList[i]).Free;
      EventList.Delete (i);
      break;
    end;
end;

procedure TClEventManager.DelEventById (svid: integer);
var
  i: integer;
begin
  for i:=0 to EventList.Count-1 do
    if TClEvent(EventList[i]).m_nServerId = svid then begin
      TClEvent(EventList[i]).Free;
      EventList.Delete (i);
      break;
    end;
end;

function  TClEventManager.GetEvent (ax, ay, etype: integer): TClEvent;
var
  i: integer;
begin
  Result := nil;
  for i:=0 to EventList.Count-1 do
    if (TClEvent(EventList[i]).m_nX = ax) and (TClEvent(EventList[i]).m_nY = ay) and
       (TClEvent(EventList[i]).m_nEventType = etype) then begin
      Result := TClEvent(EventList[i]);
      break;
    end;
end;

procedure TClEventManager.Execute;
var
  i: integer;
begin
  for i:=0 to EventList.Count-1 do
    TClEvent(EventList[i]).Run;
end;

end.
