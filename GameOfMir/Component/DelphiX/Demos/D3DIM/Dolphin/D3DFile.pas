//-----------------------------------------------------------------------------
// File: D3DFile.h/.cpp
//
// Support code for loading DirectX .X files.
//
// Delphi translation by as (Arne Schäpers), NOV-1999
//
// Copyright (c) 1997-1999 Microsoft Corporation. All rights reserved.
//-----------------------------------------------------------------------------

unit D3DFile;  // D3DFile.h and .cpp from DX 7 SDK
interface
{$IFDEF VER100} {$DEFINE DELPHI3} {$ENDIF}
uses Windows, SysUtils, DirectX, // instead of RMXFTmpl, RMXFGuid,
    D3DUtil, D3DTextr;


type
  PD3DMatrix = ^TD3DMatrix;
  PD3DVertex = ^TD3DVertex;
  PD3DValue = ^TD3DValue;
  PD3DMaterial = ^TD3DMaterial;

// Internal structure for holding material data for within a mesh. This
// is used because multiple materials can be used in the same mesh.
const
  MAX_MATERIAL = 16;
  MAX_TEXTURE_NAME = 80;
type
  TMeshMaterialData = record
    m_mtrl: TD3DMaterial7;
    m_strTexture: String[MAX_TEXTURE_NAME];
    m_dwNumIndices: Cardinal;
  end;


// classes TD3DFile and TD3DFileObject
type
  TD3DFileObject = class; PD3DFileObject = ^TD3DFileObject;

  TEnumFileObjectsCallback = function(Obj: TD3DFileObject; mat: PD3DMatrix; pContext: Pointer): Boolean;


  TD3DFile = class(TObject)
  private
    m_pRoot: TD3DFileObject;
  public
    destructor Destroy; override;
    function GetMeshVertices(const strName: String; var ppVertices: PD3DVertex; var pdwNumVertices: Cardinal): HResult;
    function GetMeshIndices(const strName: String; var ppIndices: PWord; var pdwNumIndices: Cardinal): HResult;
    function FindObject(strName: PChar): TD3DFileObject;
    procedure EnumObjects(Callback: TEnumFileObjectsCallback; pmat: PD3DMatrix; pContext: Pointer);
    procedure Scale(fScale: TD3DValue);

    function Load(const strFileName: String): HResult;
    function Render(D3DDevice: IDirect3DDevice7): HResult;
  end;

{$IFDEF DELPHI3}
  TD3DVertexArray = Array[0..9999] of TD3DVertex; PD3DVertexArray = ^TD3DVertexArray;
  TWordArray = Array[0..9999] of Word; PWordArray = ^TWordArray;
  TD3DVectorArray = Array[0..9999] of TD3DVector; PD3DVectorArray = ^TD3DVectorArray;
{$ENDIF}
  TD3DFileObject = class
    private
      // Common data
      m_strName: String;
      m_pNext, m_pChild: TD3DFileObject;

      // For file frames
      m_mat: TD3DMATRIX;

      // For file meshes
      m_bHasMeshData: Boolean;
      m_dwNumVertices: Cardinal;
      m_dwNumIndices: Cardinal;
{$IFDEF DELPHI3}
      m_pVertices: PD3DVertexArray;
      m_pIndices: PWordArray;
{$ELSE}
      m_pVertices: Array of TD3DVERTEX;
      m_pIndices: Array of Word;
{$ENDIF}
      m_dwNumMaterials: Cardinal;
      m_Material: Array[0..MAX_MATERIAL-1] of TMeshMaterialData;
      m_bHasAlpha: Boolean;
    public
      // constructor / destructor
      constructor Create(const strName: String);
      destructor Destroy; override;
    public
      // Initializing functions
      procedure AddNext(Obj: TD3DFileObject);
      procedure AddChild(Obj: TD3DFileObject);
      procedure SetNormals(pNormals: PD3DVector);
      procedure SetTextureCoords(pTexCoords: PD3DValue);
      procedure SetMaterialData(dwMaterial: Cardinal; pmtrl: PD3DMaterial7; strName: String);
      procedure AddFace(dwMaterial: Cardinal; pFaceData: PDWord; dwNumFaces: Cardinal);
      function ComputeNormals: HResult;
      function SetMeshGeometry(pvVertices: PD3DVECTOR; dwNumVertices: Cardinal;
                             pFaces: PDWord; dwNumFaces: Cardinal): HResult;
      function GetMeshGeometry(var ppVertices: PD3DVERTEX; var pdwNumVertices: Cardinal;
                               var ppIndices: PWORD; var pdwNumIndices: Cardinal): HResult;
    public // Access functions
      property Name: String read m_strName write m_strName;
      property Matrix: TD3DMATRIX read m_mat write m_mat;
      property Next: TD3DFileObject read m_pNext;
      property Child: TD3DFileObject read m_pChild;
    public  // common functions
      procedure Render(D3DDevice: IDirect3DDevice7; bAlpha: Boolean);
      function EnumObjects(Callback: TEnumFileObjectsCallback; pmat: PD3DMATRIX; pContext: Pointer): Boolean;
  end;



implementation

type  // ptr types are arrays in C but not in Pascal
  TDWordArray = Array[0..9999]of DWord; PDWordArray = ^TDWordArray;

// Get the nth face
function GetFace(pFaceData: PDWord; dwFace: DWord): PDWord;
var x: Integer;
begin
  for x := 0 to dwFace-1 do
    Inc(pFaceData, pFaceData^ + 1);  // elements, not bytes
  Result := pFaceData;
end;

// Get number of indices from face data
function GetNumIndices(pFaceData: PDWord; dwNumFaces: DWord): DWord;
var x: Integer;
begin
  Result := 0;
  for x := 1 to dwNumFaces do
  begin
    Inc(Result, (pFaceData^ - 2) * 3);
    Inc(pFaceData, pFaceData^ + 1);  // pFaceData^ + 1 elements (not bytes)
  end;
end;

{ TD3DFileObject }
procedure TD3DFileObject.AddChild(Obj: TD3DFileObject);
begin  // simple linked list
  if Assigned(m_pChild) then m_pChild.AddNext(Obj)
   else m_pChild := Obj;
end;


// Adds one or more faces to a material slot in a Mesh. Note: this must
// be called in order (material 0 first, then 1, ...)
procedure TD3DFileObject.AddFace(dwMaterial: Cardinal; pFaceData: PDWord;
  dwNumFaces: Cardinal);
var pIndices: PWord; x, y: Integer; dwNumVerticesPerFace: Cardinal;
begin
  // Make sure dwMaterial is in range
  if dwMaterial >= MAX_MATERIAL then Exit;

  // Update the material count
  if m_dwNumMaterials < dwMaterial+1 then m_dwNumMaterials := dwMaterial+1;

  // add indices to the end
  pIndices := @m_pIndices[0];
  for x := 0 to dwMaterial do
    Inc(pIndices, m_Material[x].m_dwNumIndices);

  // Assign the indices (build a triangle fan for high-order polygons)
  for x := 1 to dwNumFaces do
  begin
    dwNumVerticesPerFace := pFaceData^; Inc(pFaceData);

    for y := 2 to dwNumVerticesPerFace-1 do
    begin
      Inc(m_Material[dwMaterial].m_dwNumIndices, 3);
      pIndices^ := LoWord(PDWordArray(pFaceData)^[0]); Inc(pIndices);
      pIndices^ := LoWord(PDWordArray(pFaceData)^[y-1]); Inc(pIndices);
      pIndices^ := LoWord(PDWordArray(pFaceData)^[y]); Inc(pIndices);
    end;
    Inc(pFaceData, dwNumVerticesPerFace);
  end;
end;

procedure TD3DFileObject.AddNext(Obj: TD3DFileObject);
begin
  if Assigned(m_pNext) then m_pNext.AddNext(Obj)
    else m_pNext := Obj;
end;

function TD3DFileObject.ComputeNormals: HResult;
var pNormals: {$IFDEF DELPHI3} PD3DVectorArray; {$ELSE} Array of TD3DVector; {$ENDIF}
    x: Integer; a,b,c: Word; v1,v2,v3: PD3DVector;
    n: TD3DVector;
begin
{$IFDEF DELPHI3}
  GetMem(pNormals, m_dwNumVertices*SizeOf(TD3DVector));
{$ELSE}
  SetLength(pNormals, m_dwNumVertices);
{$ENDIF}
  FillChar(pNormals[0],SizeOf(TD3DVector)*m_dwNumVertices,0);  // neccessary?

  x := 0; while x < Integer(m_dwNumIndices) do
  begin
    a := m_pIndices[x+0]; b := m_pIndices[x+1]; c := m_pIndices[x+2];
    v1 := @m_pVertices[a]; v2 := @m_pVertices[b]; v3 := @m_pVertices[c];

    n := VectorNormalize(VectorCrossProduct(VectorSub(v2^,v1^), VectorSub(v3^,v2^)));

    pNormals[a] := VectorAdd(pNormals[a], n);
    pNormals[b] := VectorAdd(pNormals[b], n);
    pNormals[c] := VectorAdd(pNormals[c], n);

    Inc(x,3);
  end;

  // Assign the newly computed normals back to the vertices
  for x := 0 to m_dwNumVertices-1 do
  begin
    // Provide some relief to bogus normals
    if VectorMagnitude(pNormals[x]) < 0.1
      then pNormals[x] := D3DVECTOR(0.0, 0.0, 1.0);

    pNormals[x] := VectorNormalize(pNormals[x]);
    m_pVertices[x].nx := pNormals[x].x;
    m_pVertices[x].ny := pNormals[x].y;
    m_pVertices[x].nz := pNormals[x].z;
  end;

  Result := S_OK;
  // auto delete if pNormals goes out of scope
{$IFDEF DELPHI3}
  FreeMem(pNormals);
{$ENDIF}
end;

constructor TD3DFileObject.Create(const strName: String);
begin
  inherited Create;
  m_strName := strName;

  // Set a default matrix
  D3DUtil_SetIdentityMatrix( m_mat );

  // Set a default material
  D3DUtil_InitMaterial( m_Material[0].m_mtrl, 1.0, 1.0, 1.0, 0);
end;

destructor TD3DFileObject.Destroy;
var x: Integer; TexName: String;
begin
  m_pNext.Free; m_pChild.Free;
  for x := 0 to m_dwNumMaterials-1 do
  begin  // can't cast short strings to PChar
    TexName := m_Material[x].m_strTexture;
    D3DTextr_DestroyTexture(PChar(TexName));
  end;
{$IFDEF DELPHI3}
  FreeMem(m_pVertices); FreeMem(m_pIndices);
{$ELSE}
  m_pVertices := nil; m_pIndices := nil;
{$ENDIF}
end;

// Enumerates all objects in the file.
function TD3DFileObject.EnumObjects(Callback: TEnumFileObjectsCallback;
  pmat: PD3DMATRIX; pContext: Pointer): Boolean;
var NewMat: TD3DMatrix;
begin
  Result := True;
  if Callback(Self, pmat, pContext) then Exit; // True

  if Assigned(m_pChild) then
  begin // Concat matrix set
    NewMat := MatrixMul(pmat^, m_mat);
    if m_pChild.EnumObjects(Callback, @NewMat, pContext) then Exit; // True
  end;

  if Assigned(m_pNext) then
    if m_pNext.EnumObjects(Callback, pmat, pContext) then Exit; // True

  Result := False;
end;

function TD3DFileObject.GetMeshGeometry(var ppVertices: PD3DVERTEX;
  var pdwNumVertices: Cardinal; var ppIndices: PWORD;
  var pdwNumIndices: Cardinal): HResult;
begin
   if Assigned(@ppVertices) then ppVertices := @m_pVertices[0];
   if Assigned(@pdwNumVertices) then pdwNumVertices := m_dwNumVertices;
   if Assigned(@ppIndices) then ppIndices := @m_pIndices[0];
   if Assigned(@pdwNumIndices) then pdwNumIndices := m_dwNumIndices;

   Result := S_OK;
end;

procedure TD3DFileObject.Render(D3DDevice: IDirect3DDevice7; bAlpha: Boolean);
var
  x: Integer; pIndices: PWord; dwNumIndices: DWord; strTexture: String;
  matWorldOld, matWorldNew: TD3DMatrix;
begin
  if m_bHasMeshData then
  begin
    // Render the mesh
    pIndices := @m_pIndices[0];
    for x := 0 to m_dwNumMaterials do
    begin
      // Skip materials with no references
      if m_Material[x].m_dwNumIndices = 0 then continue;

      // Render opaque and transparent meshes during separate passes
      if bAlpha = m_bHasAlpha then
      begin
        strTexture   := m_Material[x].m_strTexture;
        dwNumIndices := m_Material[x].m_dwNumIndices;

        if strTexture <> '' then D3DDevice.SetTexture( 0, D3DTextr_GetSurface(strTexture));
        D3DDevice.SetMaterial(m_Material[x].m_mtrl);
        D3DDevice.DrawIndexedPrimitive(D3DPT_TRIANGLELIST, D3DFVF_VERTEX,
                                            m_pVertices[0], m_dwNumVertices,
                                            pIndices^, dwNumIndices, 0 );
      end;
      Inc(pIndices, m_Material[x].m_dwNumIndices);
    end;
  end else if Assigned(m_pChild) then
  begin
    // Save the old matrix sate
    D3DDevice.GetTransform( D3DTRANSFORMSTATE_WORLD, matWorldOld );

    // Concat the frame matrix with the current world matrix
    matWorldNew := MatrixMul(m_mat, matWorldOld);
    D3DDevice.SetTransform( D3DTRANSFORMSTATE_WORLD, matWorldNew );

    // Render the child nodes
    m_pChild.Render(D3DDevice, bAlpha );

    // Restore the old matrix state
    D3DDevice.SetTransform(D3DTRANSFORMSTATE_WORLD, matWorldOld );
  end;

  // Render the remaining sibling nodes
  if Assigned(m_pNext) then m_pNext.Render(D3DDevice, bAlpha);
end;

// Sets the material structure for the mesh
procedure TD3DFileObject.SetMaterialData(dwMaterial: Cardinal;
  pmtrl: PD3DMaterial7; strName: String);
begin
  if dwMaterial < MAX_MATERIAL then
  begin
    m_Material[dwMaterial].m_mtrl := pmtrl^;
    m_Material[dwMaterial].m_strTexture := strName;

    if pmtrl^.diffuse.a < 1.0 then m_bHasAlpha := True;
  end;
end;

function TD3DFileObject.SetMeshGeometry(pvVertices: PD3DVECTOR;
  dwNumVertices: Cardinal; pFaces: PDWord; dwNumFaces: Cardinal): HResult;
var x: Integer;
begin
{$IFDEF DELPHI3}
  if m_dwNumVertices <> dwNumVertices then
  begin
    if m_dwNumVertices <> 0 then FreeMem(m_pVertices);
    GetMem(m_pVertices, dwNumVertices * SizeOf(TD3DVertex));
  end;
{$ENDIF}
  // Set up vertices
  m_dwNumVertices := dwNumVertices;
  try
{$IFNDEF DELPHI3}
    SetLength(m_pVertices, m_dwNumVertices);
{$ENDIF}
  except
    Result := E_FAIL;
    Exit;
  end;

  FillChar(m_pVertices[0], m_dwNumVertices*Sizeof(TD3DVertex), 0);
  for x := 0 to m_dwNumVertices-1 do
  begin
    with m_pVertices[x] do
    begin
      x := pvVertices^.x; y := pvVertices^.y; z := pvVertices^.z;
      Inc(pvVertices);
    end;
  end;

  // Count the number of indices (converting n-sided faces to triangles)
  m_dwNumIndices := GetNumIndices(pFaces, dwNumFaces );

  // Allocate memory for the indices, you must call AddFace() to set the vertices
  try
{$IFDEF DELPHI3}
    if m_pIndices <> nil then FreeMem(m_pIndices);
    GetMem(m_pIndices, m_dwNumIndices * SizeOf(Word));
{$ELSE}
    SetLength(m_pIndices, m_dwNumIndices);
{$ENDIF}
  except
    Result := E_FAIL;
    Exit;
  end;

  m_bHasMeshData  := True;
  Result := S_OK;
end;

procedure TD3DFileObject.SetNormals(pNormals: PD3DVector);
var x: Integer;
begin
  for x := 0 to m_dwNumVertices-1 do
    with m_pVertices[x] do
    begin
      nx := pNormals.x;
      ny := pNormals.y;
      nz := pNormals.z;
      Inc(pNormals);
    end;
end;

procedure TD3DFileObject.SetTextureCoords(pTexCoords: PD3DValue);
var x: Integer;
begin
  for x := 0 to m_dwNumVertices-1 do
  begin
    m_pVertices[x].tu := pTexCoords^; Inc(pTexCoords);
    m_pVertices[x].tv := pTexCoords^; Inc(pTexCoords);
  end;
end;

// ------------------ TD3DFile -------------------------
destructor TD3DFile.Destroy;
begin
  m_pRoot.Free;
end;

// Enumerates all objects in the file.
procedure TD3DFile.EnumObjects(Callback: TEnumFileObjectsCallback; pmat: PD3DMatrix; pContext: Pointer);
var mat: TD3DMatrix;
begin
  if Assigned(m_pRoot) then
  begin
    if Assigned(pmat) then mat := pmat^
      else D3DUtil_SetIdentityMatrix(mat);
    m_pRoot.EnumObjects(Callback, @mat, pContext);
  end;
end;



type
  TFindMeshRec = record
    strName: String;
    pObject: TD3DFileObject;
  end;
  PFindMeshRec = ^TFindMeshRec;

// Callback to find a mesh.
// Only called by Delphi -- using registers for parms is OK
function FindMeshCB(pFileObject: TD3DFileObject; pmat: PD3dMatrix; pContext: Pointer): Boolean;
begin
  with PFindMeshRec(pContext)^ do
    if strName = AnsiUpperCase(pFileObject.Name) then
    begin
      pObject := pFileObject;
      Result := True;
    end
      else Result := False; // keep enumerating
end;


// Searches all meshes in file object and returns named mesh
function TD3DFile.FindObject(strName: PChar): TD3DFileObject;
var Data: TFindMeshRec;
begin
  if strName = nil then Result := m_pRoot
  else
  begin
    Data.strName := AnsiUpperCase(strName); Data.pObject := nil;
    EnumObjects(FindMeshCB, nil, @Data);
    Result := Data.pObject;
  end;
end;


// Traverse the hierarchy of frames and meshes that make up the file
// object, and retrieves the indices for the specified mesh.
function TD3DFile.GetMeshIndices(const strName: String;
  var ppIndices: PWord; var pdwNumIndices: Cardinal): HResult;
var pObject: TD3DFileObject;
    ppVertices: PD3DVertex; pdwNumVertices: Cardinal;  // dummies
begin
  pObject := FindObject(PChar(strName));
  if Assigned(pObject)
    then Result := pObject.GetMeshGeometry(ppVertices, pdwNumVertices, ppIndices, pdwNumIndices)
    else Result := E_FAIL;
end;

// Traverse the hierarchy of frames and meshes that make up the file
// object, and retrieves the vertices for the specified mesh.
function TD3DFile.GetMeshVertices(const strName: String;
  var ppVertices: PD3DVertex; var pdwNumVertices: Cardinal): HResult;
var pObject: TD3DFileObject;
    ppIndices: PWord; pdwNumIndices: Cardinal; // dummies
begin
  pObject := FindObject(PChar(strName));
  if Assigned(pObject)
    then Result := pObject.GetMeshGeometry(ppVertices, pdwNumVertices, ppIndices, pdwNumIndices)
    else Result := E_FAIL;
end;

// ---------- File parsing ---------------------------------
function ParseMaterial(FileData: IDirectXFileData; Mesh: TD3DFileObject; dwMaterial: DWord): HResult;
var pData: Cardinal; dwSize: DWord; strTexture: Array[0..127] of Char;
    TextureName: ^PChar;
    mtrl: TD3DMaterial7; DataGUID: PGUID;
    ChildObj: IDirectXFileObject; ChildData: IDirectXFileData;
begin
  Result := HResult(0);
  if FAILED(FileData.GetData(nil, dwSize, Pointer(pData))) then Exit;
  // Set the material properties for the mesh
  FillChar(mtrl, SizeOf(mtrl), 0);
  Move(Pointer(pData+0)^, mtrl.diffuse, SizeOf(FLOAT)*4);
  Move(Pointer(pData+0)^, mtrl.ambient, SizeOf(FLOAT)*4);
  Move(Pointer(pData+16)^, mtrl.power, SizeOf(FLOAT)*1);
  Move(Pointer(pData+20)^, mtrl.specular, SizeOf(FLOAT)*3);
  Move(Pointer(pData+32)^, mtrl.emissive, SizeOf(FLOAT)*3);

  strTexture[0] := #0;

  if SUCCEEDED(FileData.GetNextObject(ChildObj)) then
  begin
    if SUCCEEDED(ChildObj.QueryInterface(IID_IDirectXFileData, ChildData)) then
    begin
      ChildData.GetType(DataGUID);
      if EqualGUID(TID_D3DRMTextureFilename, DataGuid^) then
        if SUCCEEDED(ChildData.GetData(nil, dwSize, Pointer(TextureName))) then
        begin
          D3DTextr_CreateTextureFromFile(TextureName^,0,0);
          StrLCopy(strTexture, TextureName^, 128);
        end;
    end;
  end;

  Mesh.SetMaterialData( dwMaterial, @mtrl, strTexture );
  Result := S_OK;
end;

function ParseMeshMaterialList(FileData: IDirectXFileData; Mesh: TD3DFileObject): HResult;
var ChildObj: IDirectXFileObject; ChildData: IDirectXFileData; ChildDataRef: IDirectXFileDataReference;
    dwMaterial: Cardinal; ObjGUID: PGUID;
begin
  dwMaterial := 0;
  while SUCCEEDED(FileData.GetNextObject(ChildObj)) do
  begin
    if SUCCEEDED(ChildObj.QueryInterface(IID_IDirectXFileData, ChildData)) then
    begin
      ChildData.GetType(ObjGUID);
      if EqualGUID(ObjGUID^, TID_D3DRMMaterial) then
      begin
        ParseMaterial(ChildData, Mesh, dwMaterial);
        Inc(dwMaterial);
      end;
    end;

    if SUCCEEDED(ChildObj.QueryInterface(IID_IDirectXFileDataReference, ChildDataRef)) then
      if SUCCEEDED(ChildDataRef.Resolve(ChildData)) then
      begin
        ChildData.GetType(ObjGUID);
        if EqualGUID(ObjGUID^, TID_D3DRMMaterial) then
        begin
          ParseMaterial(ChildData, Mesh, dwMaterial);
          Inc(dwMaterial);
        end;
      end;
  end; // while GetNextObject

  Result := S_OK;
end;

function ParseMesh(FileData:  IDirectXFileData; ParentFrame: TD3DFileObject): HResult;
var dwNameLen: DWord; strName: Array[0..79] of Char;
    dwSize: DWord; pData: PDWord;
    dwNumVertices: Cardinal; pVertices: PD3DVector;
    dwNumFaces: Cardinal; pFaceData: PDWord;

    Mesh: TD3DFileObject;
    HasNormals, HasMaterials: Boolean;
    ChildObj: IDirectXFileObject; ChildData: IDirectXFileData;
    DataGuid: PGUID;
    dwNumMaterials, dwNumMatFaces: Cardinal; pMatFace: PDWord;
    matIndex, faceIndex: Cardinal; pCurMatFace: PDWord;
    dwNumNormals: DWord; pNormals: PD3DVector;
    dwNumTexCoords: DWord; pTexCoords: PD3DValue;


begin
  Result := E_FAIL; dwNameLen := 80;
  if FAILED(FileData.GetName(strName, dwNameLen)) then Exit;

  // Read the Mesh data from the file
  if FAILED(FileData.GetData(nil, dwSize, Pointer(pData))) then Exit;

  dwNumVertices := pData^; Inc(pData);
  pVertices := PD3DVector(pData); Inc(pData, (12 div SizeOf(pData^))*dwNumVertices);
  dwNumFaces := pData^; Inc(pData);
  pFaceData  := pData;

  // Create the Mesh object
  Mesh := TD3DFileObject.Create(strName);
  Mesh.SetMeshGeometry(pVertices, dwNumVertices, pFaceData, dwNumFaces);

  HasNormals := False; HasMaterials := False;

  // Enumerate child objects
  while SUCCEEDED(FileData.GetNextObject(ChildObj)) do
    if SUCCEEDED(ChildObj.QueryInterface(IID_IDirectXFileData,ChildData)) then
    begin
      ChildData.GetType(DataGUID);
      if FAILED(ChildData.GetData(nil, dwSize, Pointer(pData))) then
      begin
        Mesh.Free;
        Result := HResult(0);  // ?
        Exit;
      end;

      if EqualGUID(DataGUID^, TID_D3DRMMeshMaterialList) then
      begin
        dwNumMaterials := pData^; Inc(pData);
        dwNumMatFaces := pData^; Inc(pData);
        pMatFace := pData;

        if (dwNumMaterials = 1) or (dwNumMatFaces <> dwNumFaces) then
        begin // Only one material add all faces at once
          Mesh.AddFace(0, pFaceData, dwNumFaces );
        end else // Multiple materials, add in sorted order
          for matIndex := 0 to dwNumMaterials do
          begin
            pCurMatFace := pMatFace;
            for faceIndex := 0 to dwNumMatFaces-1 do
            begin
              if pCurMatFace^ = matIndex then
                Mesh.AddFace(matIndex, GetFace(pFaceData, faceIndex), 1);
              Inc(pCurMatFace);
            end;
          end;
        ParseMeshMaterialList(ChildData, Mesh);
        HasMaterials := True;
      end
      else if EqualGUID(DataGUID^, TID_D3DRMMeshNormals) then
      begin
        dwNumNormals := pData^; Inc(pData);
        pNormals := PD3DVector(pData);

        if dwNumNormals = dwNumVertices then
        begin
          Mesh.SetNormals(pNormals); HasNormals := True;
        end;
      end
      else if EqualGUID(DataGUID^, TID_D3DRMMeshTextureCoords) then
      begin // Copy the texture coords into the mesh's vertices
        dwNumTexCoords := pData^; Inc(pData);
        pTexCoords := PD3dValue(pData);

        if dwNumTexCoords = dwNumVertices then Mesh.SetTextureCoords(pTexCoords);
      end;
    end;  // while & QueryInterface

  if not HasMaterials then Mesh.AddFace(0, pFaceData, dwNumFaces);

  if not HasNormals then Mesh.ComputeNormals;

  ParentFrame.AddChild(Mesh);
  Result := S_OK;
end;

function ParseFrame(FileData: IDirectXFileData; ParentFrame: TD3DFileObject): HResult;
var dwNameLen: DWord; strName: Array[0..79] of Char;
    Frame: TD3DFileObject;
    ChildObj: IDirectXFileObject; ChildData: IDirectXFileData; CDGuid: PGUID;
    dwSize: DWord; pData: Pointer;
begin
  dwNameLen := SizeOf(strName);
  if FAILED (FileData.GetName(strName, dwNameLen)) then
  begin
    Result := E_FAIL; Exit;
  end;

  Frame := TD3DFileObject.Create(strName);

  // Enumerate child objects.
  while SUCCEEDED(FileData.GetNextObject(ChildObj)) do
    if SUCCEEDED(ChildObj.QueryInterface(IID_IDirectXFileData, ChildData)) then
    begin
      ChildData.GetType(CDGuid);
      if EqualGUID(CDGuid^,TID_D3DRMFrame ) then ParseFrame(ChildData, Frame)
       else if EqualGUID(CDGuid^,TID_D3DRMMesh) then ParseMesh(ChildData, Frame)
       else if EqualGUID(CDGuid^,TID_D3DRMFrameTransformMatrix) then
       begin
         if FAILED(ChildData.GetData(nil, dwSize, pData)) then
         begin
           Frame.Free;
           Result := HResult(0); // ??
           Exit;
         end;

         if dwSize = SizeOf(TD3DMatrix) then
         begin // Convert from a left- to a right-handed cordinate system
           with PD3DMatrix(pData)^ do
           begin
             _13 := _13 * -1.0; _31 := _31 * -1.0;
             _23 := _23 * -1.0; _32 := _32 * -1.0;
             _43 := _43 * -1.0;
           end;
           Frame.Matrix := PD3DMatrix(pData)^;
         end;
       end;  // FrameTransformMatrix
    end;  //  QueryInterface for ChildData
    ParentFrame.AddChild(Frame);
    Result := S_OK;
end;

// Loads a .X geometry file, and creates a hierarchy of frames and meshes
// to represent the geometry in that file.
function TD3DFile.Load(const strFileName: String): HResult;
var DXFile: IDirectXFile; EnumObj: IDirectXFileEnumObject; FileData: IDirectXFileData;
    ObjGUID: PGUID;
begin
  // Cleanup any existing object
  m_pRoot.Free; m_pRoot := nil;
  Result := E_FAIL;
  // Create the file object, and register the D3DRM templates for .X files
  if FAILED(DirectXFileCreate(DXFile)) then Exit;
  if FAILED(DXFile.RegisterTemplates(@D3DRM_XTEMPLATES, D3DRM_XTEMPLATE_BYTES)) then Exit;

  // Create an enumerator object, to enumerate through the .X file objects.
  // This will open the file in the current directory.
  Result := DXFile.CreateEnumObject(PChar(strFilename), DXFILELOAD_FROMFILE, EnumObj);

  if FAILED(Result) then
  begin  // try MediaPath instead
    Result := DXFile.CreateEnumObject(PChar(D3DUtil_GetDXSDKMediaPath+ExtractFileName(strFileName)),
          DXFILELOAD_FROMFILE, EnumObj);
    if FAILED(Result) then Exit;
  end;

  // Create a root object for the X file object
  m_pRoot := TD3DFileObject.Create('D3DFile_Root');

  // Cycle through each object. Parse meshes and frames as appropriate
  repeat
    Result := EnumObj.GetNextDataObject(FileData);
    if SUCCEEDED(Result) then
    begin
      FileData.GetType(ObjGUID);
      if EqualGUID(ObjGUID^, TID_D3DRMFrame)
         then ParseFrame(FileData, m_pRoot)
       else if EqualGUID(ObjGUID^,TID_D3DRMMesh)
         then ParseMesh(FileData, m_pRoot);
    end;
  until FAILED(Result);

  // Success will result in Result == DXFILEERR_NOMOREOBJECTS
  if Result <> DXFILEERR_NOMOREOBJECTS then
  begin
    m_pRoot.Free; m_pRoot := nil;
  end
    else Result := S_OK;
end;

// Renders the hierarchy of frames and meshes that make up the file object
function TD3DFile.Render(D3DDevice: {$IFDEF DIRECTX6} IDirect3DDevice3 {$ELSE} IDirect3DDevice7 {$ENDIF}): HResult;
var dwAlphaState, dwSrcBlendState, dwDestBlendState: DWord;
    mtrlSaved: TD3DMaterial7;
    matSaved: TD3DMatrix;
    pddsSavedTexture: {$IFDEF DIRECTX6} IDirect3DTexture2; {$ELSE} IDirectDrawSurface7; {$ENDIF}
begin
  Result := S_OK;
  if not Assigned(m_pRoot) then Exit;


  // State render states that will be overwritten
  with D3DDevice do
  begin
    GetMaterial(mtrlSaved );
    GetTexture( 0, pddsSavedTexture);
    GetTransform(D3DTRANSFORMSTATE_WORLD, matSaved );
    GetRenderState(D3DRENDERSTATE_ALPHABLENDENABLE, dwAlphaState );
    GetRenderState(D3DRENDERSTATE_SRCBLEND,  dwSrcBlendState );
    GetRenderState(D3DRENDERSTATE_DESTBLEND, dwDestBlendState );

    // Render the opaque file object's hierarchy of frames and meshes
    m_pRoot.Render(D3DDevice, False);

    // Render the transparent file object's hierarchy of frames and meshes
    SetRenderState( D3DRENDERSTATE_ALPHABLENDENABLE, Ord(True));
    SetRenderState( D3DRENDERSTATE_SRCBLEND,  Ord(D3DBLEND_SRCALPHA) );
    SetRenderState( D3DRENDERSTATE_DESTBLEND, Ord(D3DBLEND_INVSRCALPHA) );
    m_pRoot.Render(D3DDevice, TRUE );

    // Restore the render states
    SetRenderState( D3DRENDERSTATE_ALPHABLENDENABLE, dwAlphaState );
    SetRenderState( D3DRENDERSTATE_SRCBLEND,  dwSrcBlendState );
    SetRenderState( D3DRENDERSTATE_DESTBLEND, dwDestBlendState );
    SetTransform( D3DTRANSFORMSTATE_WORLD, matSaved );
    SetTexture( 0, pddsSavedTexture );
    SetMaterial(mtrlSaved );
  end;
end;

// Callback to scale a mesh. Called internally, uses regs for parameter passing
function ScaleMeshCB(pFileObject: TD3DFileObject; pmat: PD3DMatrix; pContext: Pointer): Boolean;
var pVertices: PD3DVertex; dwNumVertices: Cardinal; i: Integer;
    pIndices: PWORD; dwNumIndices: Cardinal; // dummies
    fScale: TD3DValue;
begin
  fScale := PD3DValue(pContext)^;

  if SUCCEEDED(pFileObject.GetMeshGeometry(pVertices, dwNumVertices,
    pIndices, dwNumIndices)) then
    for i := 1 to dwNumVertices do
    begin
      with pVertices^ do
      begin
        x := x * fScale; y := y * fScale; z := z * fScale;
        Inc(pVertices);
      end;
    end;

  // Keep enumerating
  Result := False;
end;

// Scales all meshes in the file
procedure TD3DFile.Scale(fScale: TD3DValue);
begin
  EnumObjects(ScaleMeshCB, nil, @fScale);
end;

end.

