unit DolphinU;  // 10-MAR-2000 as (Arne Schäpers)
// Auf Delphi umgesetztes Sample des DirectX-SDKs
// Setzt DirectX 7 und die Header-Dateien von Erik Unger voraus

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, DirectX,  // Header von Erik Unger
  // D3D-Rahmenprogramm aus dem DX-SDK, auf Delphi umgesetzt
  D3DEnum,D3DApp,D3DFrame,D3DFile,D3DTextr,D3DUtil,D3DMath;

type
  TDolphinForm = class(TD3DApplication)
    procedure FormCreate(Sender: TObject);
  private
    // Meshes für den Delphin, werden aus X-Dateien geladen
    m_pDolphinGroupObject, m_pDolphinObject,
    m_pFloorObject: TD3DFile; // Seeboden (X-Datei)

    // Vertexdaten aus den Dateiobjekten
    m_pDolphinVertices, m_pDolphin1Vertices,
    m_pDolphin2Vertices, m_pDolphin3Vertices: PD3DVertex;
    // Zahl der Vertexe in allen vier Meshes gleich
    m_dwNumDolphinVertices: Cardinal;
    // Seeboden: Vertexe und Vertexzahl
    m_pFloorVertices: PD3DVertex;
    m_dwNumFloorVertices: Cardinal;
  protected  // Overrides für TD3DApplication
    function OneTimeSceneInit: HResult; override;
    function InitDeviceObjects: HResult; override;
    function DeleteDeviceObjects: HResult; override;
    function Render: HResult; override;
    function FrameMove(fTimeKey: FLOAT): HResult; override;
    function FinalCleanup: HResult; override;
  end;

var DolphinForm: TDolphinForm;

implementation
{$R *.DFM}

procedure TDolphinForm.FormCreate(Sender: TObject);
begin
  Caption := 'Dolphin: Blending Meshes in Real Time';
  m_bAppUseZBuffer  :=  TRUE;
  m_bAppUseStereo   :=  TRUE;
  m_bShowStats      :=  TRUE;
  OnConfirmDevice := nil;  // alle D3D-Geräte abzählen
  // D3D-Rahmen anlegen, ruft OneTimeSceneInit auf
  CreateFramework;
end;

// Wird einmal beim Programmstart aufgerufen, übernimmt alle
// von Grafiktreiber und -modus unabhängigen Initialisierungen
function TDolphinForm.OneTimeSceneInit: HResult;
var x: Integer; pVert, pVert1, pVert2, pVert3: PD3DVertex;

  procedure ScaleVertex(V: PD3DVertex; Factor: FLOAT);
  begin
    with V^ do
    begin
      x := x * Factor; y := y * Factor; z := z * Factor;
    end;
  end;
begin
  m_pDolphinGroupObject := TD3DFile.Create;
  m_pDolphinObject      := TD3DFile.Create;
  m_pFloorObject       := TD3DFile.Create;

  Result := m_pDolphinGroupObject.Load(ExtractFilePath(ParamStr(0))+'dolphin_group.x');
  Result := Result
    or m_pDolphinGroupObject.GetMeshVertices('Dolph01',
          m_pDolphin1Vertices, m_dwNumDolphinVertices)
    or m_pDolphinGroupObject.GetMeshVertices('Dolph02',
          m_pDolphin2Vertices, m_dwNumDolphinVertices)
    or m_pDolphinGroupObject.GetMeshVertices('Dolph03',
          m_pDolphin3Vertices, m_dwNumDolphinVertices);

  if FAILED(Result) then
  begin
    ShowMessage('Error loading DOLPHIN_GROUP.X file');
    Result := E_FAIL; Exit;
  end;

  Result := m_pDolphinObject.Load('dolphin.x');
  Result := Result
    or m_pDolphinObject.GetMeshVertices('Dolph02',
       m_pDolphinVertices, m_dwNumDolphinVertices);
  if FAILED(Result) then
  begin
    ShowMessage('Error loading DOLPHIN.X file');
    Result := E_FAIL; Exit;
  end;

  Result := m_pFloorObject.Load('seafloor.x');
  Result := Result
    or m_pFloorObject.GetMeshVertices('SeaFloor',
          m_pFloorVertices, m_dwNumFloorVertices);
  if FAILED(Result) then
  begin
    ShowMessage('Error loading SEAFLOOR.X file');
    Result := E_FAIL; Exit;
  end;

  // redundant -- Bitmaps bereits über X-Dateien geladen
//  D3DTextr_CreateTextureFromFile('seafloor.bmp',0,0);
//  D3DTextr_CreateTextureFromFile('dolphin.bmp',0,0);

  Randomize;

  // Seeboden skalieren, einige "zufällige" Unregelmäßigkeiten
  pVert := m_pFloorVertices;
  for x := 0 to m_dwNumFloorVertices-1 do
  with pVert^ do
  begin
    y := y + Random(3); tu := tu * 10; tv := tv * 10;
    Inc(pVert);
  end;

  // Delphin skalieren - das Original ist um einiges zu groß
  pVert1 := m_pDolphin1Vertices; pVert2 := m_pDolphin2Vertices;
  pVert3 := m_pDolphin3Vertices;
  for x := 0 to m_dwNumDolphinVertices-1 do
  begin
    ScaleVertex(pVert1,0.01); Inc(pVert1);
    ScaleVertex(pVert2,0.01); Inc(pVert2);
    ScaleVertex(pVert3,0.01); Inc(pVert3);
  end;
  Result := S_OK;
end;

// Von Grafiktreiber und -modus abhängige Initialisierungen,
// wird bei jedem Wechsel erneut aufgerufen
const WATER_COLOR = $00006688;  // Farbe des Wassers

function TDolphinForm.InitDeviceObjects: HResult;
var Light: TD3DLight7; vp: TD3dViewport7;
    fAspect: FLOAT;
    vEyePt, vLookatPt, vUpVec: TD3DVector;
    matWorld, matProj: TD3DMatrix;
    fFogStart, fFogEnd: FLOAT;

begin
  // Beleuchtung einrichten
  if m_pDeviceInfo.ddDeviceDesc.dwVertexProcessingCaps and
        D3DVTXPCAPS_DIRECTIONALLIGHTS <> 0 then
  begin
    D3DUtil_InitLight(light, D3DLIGHT_DIRECTIONAL, 0.0, -1.0, 0.0);
    with m_pd3dDevice do
    begin
      SetLight(0,light);
      LightEnable(0, TRUE);
      SetRenderState(D3DRENDERSTATE_LIGHTING, Ord(True));
    end;
  end;
  m_pd3dDevice.SetRenderState(D3DRENDERSTATE_AMBIENT, $33333333);

  // Transformationsmatrizen
  m_pd3dDevice.GetViewport(vp);
  fAspect := vp.dwHeight / vp.dwWidth;

  vEyePt := D3DVECTOR( 0.0, 0.0, -10.0);
  vLookatPt := D3DVECTOR(0.0, 0.0, 0.0);
  vUpVec    := D3DVECTOR(0.0, 1.0, 0.0);

  D3DUtil_SetIdentityMatrix( matWorld );
  SetViewParams(@vEyePt, @vLookatPt, @vUpVec, 0.1);
  D3DUtil_SetProjectionMatrix(matProj, Pi/3, fAspect, 1.0, 1000.0);

  m_pd3dDevice.SetTransform(D3DTRANSFORMSTATE_WORLD, matWorld );
  m_pd3dDevice.SetTransform(D3DTRANSFORMSTATE_PROJECTION, matProj);

  // (bereits geladene) Texturen für den Treiber einrichten
  D3DTextr_RestoreAllTextures(m_pd3dDevice);

  with m_pd3dDevice do
  begin
    SetTextureStageState( 0, D3DTSS_COLORARG1, D3DTA_TEXTURE );
    SetTextureStageState( 0, D3DTSS_COLORARG2, D3DTA_DIFFUSE );
    SetTextureStageState( 0, D3DTSS_COLOROP,   Ord(D3DTOP_MODULATE));
    SetTextureStageState( 0, D3DTSS_MINFILTER, Ord(D3DTFN_LINEAR));
    SetTextureStageState( 0, D3DTSS_MAGFILTER, Ord(D3DTFG_LINEAR));

    // Vorgegebene Render states
    SetRenderState( D3DRENDERSTATE_DITHERENABLE, Ord(True));
    SetRenderState( D3DRENDERSTATE_SPECULARENABLE, Ord(False));
    SetRenderState( D3DRENDERSTATE_ZENABLE, Ord(True));

    // Fogging an
    fFogStart := 1.0;  fFogEnd := 50.0;
    SetRenderState( D3DRENDERSTATE_FOGENABLE, Ord(True));
    SetRenderState( D3DRENDERSTATE_FOGCOLOR, WATER_COLOR);
    SetRenderState( D3DRENDERSTATE_FOGTABLEMODE, Ord(D3DFOG_NONE));
    SetRenderState( D3DRENDERSTATE_FOGVERTEXMODE, Ord(D3DFOG_LINEAR));
    SetRenderState( D3DRENDERSTATE_FOGSTART, PDWord(@fFogStart)^);
    SetRenderState( D3DRENDERSTATE_FOGEND,   PDWord(@fFogEnd)^);
  end;
  Result := S_OK;
end;

// Gibt die bei InitDeviceObjects angelegten Objekte wieder frei
// Bei jedem Wechsel von Grafiktreiber und -modus aufgerufen
function TDolphinForm.DeleteDeviceObjects: HResult;
begin
  // DirectDraw-Oberflächen der Texturen. Textur-Bitmaps
  // bleiben davon unberührt
  D3DTextr_InvalidateAllTextures;
  // Lichtquellen etc. werden beim Abbau der Geräteschnittstelle
  // automatisch beseitigt
  Result := S_OK;
end;

// Gegenstück zu OneTimeSceneInit
function TDolphinForm.FinalCleanup: HResult;
begin
  m_pDolphinGroupObject.Free;
  m_pDolphinObject.Free;
  m_pFloorObject.Free;
  Result := S_OK;
end;


// Lineare Interpolation sämtlicher Vertexe und Normalen zweier
// Meshes. Ziel-Mesh und beide Quellen müssen exakt dieselbe
// Zahl und Reihenfolge der Vertexe haben. Wird hier für den
// Flossenschlag des Delphinsd benutzt, fWeight von 0..1.0
procedure BlendMeshes(pDstMesh, pSrcMesh1, pSrcMesh2: PD3DVertex;
   dwNumVertices: Cardinal; fWeight: FLOAT);
var fInvWeight: FLOAT; i: Integer;
begin
  fInvWeight := 1.0 - fWeight;
  // LERP-Positionen und Normale
  for i := 0 to Integer(dwNumVertices)-1 do
  with pDstMesh^ do
  begin
    x  := fWeight*pSrcMesh1^.x  + fInvWeight*pSrcMesh2^.x;
    y  := fWeight*pSrcMesh1^.y  + fInvWeight*pSrcMesh2^.y;
    z  := fWeight*pSrcMesh1^.z  + fInvWeight*pSrcMesh2^.z;
    nx := fWeight*pSrcMesh1^.nx + fInvWeight*pSrcMesh2^.nx;
    ny := fWeight*pSrcMesh1^.ny + fInvWeight*pSrcMesh2^.ny;
    nz := fWeight*pSrcMesh1^.nz + fInvWeight*pSrcMesh2^.nz;

    Inc(pDstMesh); Inc(pSrcMesh1); Inc(pSrcMesh2);
  end;
end;

// Fortschreibung der Bewegung abhängig von fTimeKey
function TDolphinForm.FrameMove(fTimeKey: FLOAT): HResult;
var fKickFreq, fWeight, fPhase: FLOAT; pObject: TD3DFileObject;
    matDolphin: TD3DMatrix;
    matTrans1, matRotate1, matRotate2: TD3DMatrix;
begin
  fKickFreq := 2*fTimeKey;

  fWeight := sin(fKickFreq);  // Flossenschlag
  if fWeight < 0.0 then
      BlendMeshes( m_pDolphinVertices, m_pDolphin3Vertices,
         m_pDolphin2Vertices, m_dwNumDolphinVertices, -fWeight )
  else
      BlendMeshes( m_pDolphinVertices, m_pDolphin1Vertices,
        m_pDolphin2Vertices, m_dwNumDolphinVertices, fWeight);

  // Delphin im Kreis schwimmen lassen
  pObject := m_pDolphinObject.FindObject('x3ds_Dolph02');
  if Assigned(pObject) then
  begin
    matDolphin := pObject.Matrix;
    fPhase := fTimeKey/3;

    D3DUtil_SetRotateZMatrix(matRotate1, -cos(fKickFreq)/6);
    D3DUtil_SetRotateYMatrix(matRotate2, fPhase);
    D3DUtil_SetTranslateMatrix(matTrans1, -5*sin(fPhase),
              sin(fKickFreq)/2, 10-10*cos(fPhase));

    D3DUtil_SetIdentityMatrix(matDolphin);
    D3DMath_MatrixMultiply(matDolphin, matTrans1, matDolphin );
    D3DMath_MatrixMultiply(matDolphin, matRotate2, matDolphin );
    D3DMath_MatrixMultiply(matDolphin, matRotate1, matDolphin );
    pObject.Matrix := matDolphin;
  end;
  Result := S_OK;
end;

// Wird einmal pro Frame aufgerufen (Transformationsmatrizen,
// Objekte, Viewports etc. bereits eingerichtet). Löscht den
// Viewport und zeichnet die gesamte Szene
function TDolphinForm.Render: HResult;
begin
  // Viewport mit Hintergrundfarbe löschen
  m_pd3dDevice.Clear( 0, nil, D3DCLEAR_TARGET
    or D3DCLEAR_ZBUFFER, WATER_COLOR, 1.0, 0);
  // Szene zeichnen
  if SUCCEEDED(m_pd3dDevice.BeginScene) then
  begin
    m_pFloorObject.Render(m_pd3dDevice);
    m_pDolphinObject.Render(m_pd3dDevice);
    m_pd3dDevice.EndScene; // Zeichenoperation abgeschlossen
  end;
  Result := S_OK;
end;

end.

