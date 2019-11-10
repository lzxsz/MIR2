//-----------------------------------------------------------------------------
// File: D3DUtil.h & .cpp
//
// Delphi translation by Arne Schäpers, 01-MAR-2000
//
// Shortcut macros and functions for using DX objects
//
//
// Copyright (c) 1997-1999 Microsoft Corporation. All rights reserved
//-----------------------------------------------------------------------------

unit D3DUtil;

interface
uses Windows, SysUtils, DirectX, Registry;

function EqualGUID(const G1,G2: TGUID): Boolean;
function D3DUtil_GetDXSDKMediaPath: String;

procedure D3DUtil_SetIdentityMatrix(var m: TD3DMatrix);
{$IFDEF VER130}
procedure D3DUtil_SetTranslateMatrix(var m: TD3DMATRIX; const tx, ty, tz: TD3DValue); overload;
procedure D3DUtil_SetTranslateMatrix(var m: TD3DMATRIX; const v: TD3DVector); overload;
{$ELSE}
procedure D3DUtil_SetTranslateMatrix(var m: TD3DMATRIX; const tx, ty, tz: TD3DValue);
{$ENDIF}
procedure D3DUtil_SetScaleMatrix(var m: TD3DMATRIX; const sx, sy, sz: TD3DValue);

procedure D3DUtil_SetRotateXMatrix(var m: TD3DMatrix; fRads: FLOAT);
procedure D3DUtil_SetRotateYMatrix(var m: TD3DMatrix; fRads: FLOAT);
procedure D3DUtil_SetRotateZMatrix(var m: TD3DMatrix; fRads: FLOAT);
procedure D3DUtil_SetRotationMatrix(var mat: TD3DMatrix; const vDir: TD3DVector; fRads: FLOAT);

function D3DUtil_SetViewMatrix(var mat: TD3DMATRIX; vFrom, vAt, vWorldUp: TD3DVector): HResult;
function D3DUtil_SetProjectionMatrix(var mat: TD3DMatrix;
  fFOV {= 1.570795}, fAspect {= 1.0}, fNearPlane {= 1.0}, fFarPlane {= 1000.0}: FLOAT): HResult;

procedure D3DUtil_InitMaterial(var mtrl: TD3DMaterial7;
   r {= 0.0}, g {= 0.0}, b {= 0.0}, a {= 1.0}: TD3DValue);
procedure D3DUtil_InitLight(var Light: TD3DLight7; ltType: TD3DLIGHTTYPE;
   x {= 0.0}, y {= 0.0},z {= 0.0}: FLOAT);
procedure D3DUtil_InitSurfaceDesc(var ddsd: TDDSurfaceDesc2;
   _dwFlags {= 0}, dwCaps {= 0}: Cardinal);

// ===========================================================
// Delphi functions substituting C initialization macros
function D3DVector(const _x,_y,_z: FLOAT): TD3DVector;
function D3DLVertex(const v: TD3DVector; const _color, _specular:
   TD3DColor; const _tu, _tv: TD3DValue): TD3DLVertex;
function D3DTLVertex(const v: TD3DVector; const _rhw: TD3DValue;
   const _color, _specular: TD3DColor;
   const _tu, _tv: TD3DValue): TD3DTLVertex;

// =============================================================

procedure SetScaleMatrix(var m: TD3DMATRIX; const v: TD3DVECTOR);
function MatrixMul(const a, b: TD3DMatrix) : TD3DMatrix;

const
  IdentityMatrix : TD3DMatrix = (
    _11: 1; _12: 0; _13: 0; _14: 0;
    _21: 0; _22: 1; _23: 0; _24: 0;
    _31: 0; _32: 0; _33: 1; _34: 0;
    _41: 0; _42: 0; _43: 0; _44: 1 );


  ZeroMatrix : TD3DMatrix = (
    _11: 0; _12: 0; _13: 0; _14: 0;
    _21: 0; _22: 0; _23: 0; _24: 0;
    _31: 0; _32: 0; _33: 0; _34: 0;
    _41: 0; _42: 0; _43: 0; _44: 0 );


implementation

function D3DVector(const _x,_y,_z: FLOAT): TD3DVector;
begin
  Result.x := _x; Result.y := _y; Result.z := _z;
end;

function D3DLVertex(const v: TD3DVector; const _color, _specular:
   TD3DColor; const _tu, _tv: TD3DValue): TD3DLVertex;
begin
  with Result do
  begin
    x := v.x; y := v.y; z := v.z;
    dwReserved := 0;
    color := _color; specular := _specular;
    tu := _tu; tv := _tv;
  end;
end;

function D3DTLVertex(const v: TD3DVector; const _rhw: TD3DValue;
   const _color, _specular: TD3DColor;
   const _tu, _tv: TD3DValue): TD3DTLVertex;
begin
  with Result do
  begin
    sx := v.x; sy := v.y; sz := v.z;
    rhw := _rhw; color := _color; specular := _specular;
    tu := _tu; tv := _tv;
  end;
end;

//-----------------------------------------------------------------------------
// D3D Matrix functions. For performance reasons, some functions are inline.
//-----------------------------------------------------------------------------

procedure D3DUtil_SetIdentityMatrix(var m: TD3DMatrix);
begin
  FillChar(m,Sizeof(m),0);
  m._11 := 1.0; m._22 := 1.0; m._33 := 1.0; m._44 := 1.0;
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_SetRotateXMatrix()
// Desc: Create Rotation matrix about X axis
//-----------------------------------------------------------------------------
procedure D3DUtil_SetRotateXMatrix(var m: TD3DMatrix; fRads: FLOAT);
begin
  D3DUtil_SetIdentityMatrix(m);
  with m do
  begin
    _22 :=  cos( fRads ); _23 :=  sin( fRads );
    _32 := -sin( fRads );  _33 :=  cos( fRads );
  end;
end;


//-----------------------------------------------------------------------------
// Name: D3DUtil_SetRotateYMatrix()
// Desc: Create Rotation matrix about Y axis
//-----------------------------------------------------------------------------
procedure D3DUtil_SetRotateYMatrix(var m: TD3DMatrix; fRads: FLOAT);
begin
  D3DUtil_SetIdentityMatrix(m);
  with m do
  begin
    _11 :=  cos( fRads ); _13 := -sin( fRads );
    _31 :=  sin( fRads ); _33 :=  cos( fRads );
  end;
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_SetRotateZMatrix()
// Desc: Create Rotation matrix about Z axis
//-----------------------------------------------------------------------------
procedure D3DUtil_SetRotateZMatrix(var m: TD3DMatrix; fRads: FLOAT);
begin
  D3DUtil_SetIdentityMatrix(m);
  with m do
  begin
    _11  :=  cos( fRads ); _12  :=  sin( fRads );
    _21  := -sin( fRads ); _22  :=  cos( fRads );
  end;
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_SetRotationMatrix
// Desc: Create a Rotation matrix about vector direction
//-----------------------------------------------------------------------------
procedure D3DUtil_SetRotationMatrix(var mat: TD3DMatrix; const vDir: TD3DVector; fRads: FLOAT);
var fCos, fSin: FLOAT; v: TD3DVector;
begin
  fCos := Cos(fRads); fSin := Sin(fRads);
  v := VectorNormalize(vDir);

  with mat do
  begin
    _11 := ( v.x * v.x ) * ( 1.0 - fCos ) + fCos;
    _12 := ( v.x * v.y ) * ( 1.0 - fCos ) - (v.z * fSin);
    _13 := ( v.x * v.z ) * ( 1.0 - fCos ) + (v.y * fSin);

    _21 := ( v.y * v.x ) * ( 1.0 - fCos ) + (v.z * fSin);
    _22 := ( v.y * v.y ) * ( 1.0 - fCos ) + fCos ;
    _23 := ( v.y * v.z ) * ( 1.0 - fCos ) - (v.x * fSin);

    _31 := ( v.z * v.x ) * ( 1.0 - fCos ) - (v.y * fSin);
    _32 := ( v.z * v.y ) * ( 1.0 - fCos ) + (v.x * fSin);
    _33 := ( v.z * v.z ) * ( 1.0 - fCos ) + fCos;

    _14 := 0.0;  _24 := 0.0;  _34 := 0.0;
    _41 := 0.0;  _42 := 0.0;  _43 := 0.0;
    _44 := 1.0;
  end;
end;

procedure D3DUtil_SetTranslateMatrix(var m: TD3DMATRIX; const tx, ty, tz: TD3DValue);
begin
  D3DUtil_SetIdentityMatrix(m); m._41 := tx; m._42 := ty; m._43 := tz;
end;

{$IFDEF VER130}
procedure D3DUtil_SetTranslateMatrix(var m: TD3DMATRIX; const v: TD3DVector);
begin
  D3DUtil_SetTranslateMatrix(m, v.x, v.y, v.z);
end;
{$ENDIF}

procedure D3DUtil_SetScaleMatrix(var m: TD3DMATRIX; const sx, sy, sz: TD3DValue);
begin
  D3DUtil_SetIdentityMatrix(m); m._11 := sx; m._22 := sy; m._33 := sz;
end;

procedure SetScaleMatrix(var m: TD3DMATRIX; const v: TD3DVECTOR);
begin
  D3DUtil_SetScaleMatrix( m, v.x, v.y, v.z );
end;

// Multiplies two matrices.
function MatrixMul(const a, b: TD3DMatrix) : TD3DMatrix;
var
  i,j,k : integer;
begin
  Result := ZeroMatrix;
  for i := 0 to 3 do
    for j := 0 to 3 do
      for k := 0 to 3 do
        Result.m[i,j] := Result.m[i,j] + (a.m[k,j] * b.m[i,k]);
end;

function EqualGUID(const G1,G2: TGUID): Boolean;
begin
  Result := CompareMem(@G1,@G2,SizeOf(TGUID));
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_InitMaterial()
// Desc: Helper function called to build a D3DMATERIAL7 structure
//-----------------------------------------------------------------------------
procedure D3DUtil_InitMaterial(var mtrl: TD3DMaterial7; r,g,b, a: TD3DValue);
begin
  FillChar(mtrl, SizeOf(mtrl), 0);
  with mtrl do
  begin
    dcvDiffuse.r := r; dcvAmbient.r := r;
    dcvDiffuse.g := g; dcvAmbient.g := g;
    dcvDiffuse.b := b; dcvAmbient.b := b;
    dcvDiffuse.a := a; dcvAmbient.a := a;
  end;
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_InitSurfaceDesc()
// Desc: Helper function called to build a DDSURFACEDESC2 structure,
//       typically before calling CreateSurface() or GetSurfaceDesc()
//-----------------------------------------------------------------------------
procedure D3DUtil_InitSurfaceDesc(var ddsd: TDDSurfaceDesc2; _dwFlags, dwCaps: Cardinal);
begin
  FillChar(ddsd, SizeOf(ddsd), 0);
  with ddsd do
  begin
    dwSize := SizeOf(ddsd);
    dwFlags := _dwFlags;
    ddsCaps.dwCaps  := dwCaps;
    ddpfPixelFormat.dwSize := Sizeof(TDDPixelFormat);
  end;
end;


//-----------------------------------------------------------------------------
// Name: D3DUtil_GetDXSDKMediaPath()
// Desc: Returns the DirectX SDK media path, as stored in the system registry
//       during the SDK install.
//-----------------------------------------------------------------------------
function D3DUtil_GetDXSDKMediaPath: String;
var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKey('Software\Microsoft\DirectX',False) then
    begin
      Result := ReadString('DXSDK Samples Path');
      if Result <> '' then Result := Result + '\D3DIM\Media\';
    end;
    Free;
  end;
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_SetViewMatrix()
// Desc: Given an eye point, a lookat point, and an up vector, this
//       function builds a 4x4 view matrix.
//-----------------------------------------------------------------------------
function D3DUtil_SetViewMatrix(var  mat: TD3DMATRIX;
  vFrom, vAt, vWorldUp: TD3DVector): HResult;
var vView, vUp, vRight: TD3DVector; fLength, fDotProduct: FLOAT;
begin
  // Get the z basis vector, which points straight ahead. This is the
  // difference from the eyepoint to the lookat point.
  vView := VectorSub(vAt, vFrom);

  fLength := VectorMagnitude(vView);
  if fLength < 1E-6 then
  begin
    Result := E_INVALIDARG; Exit;
  end;

  // Normalize the z basis vector
  vView := VectorDivS(vView, fLength);

  // Get the dot product, and calculate the projection of the z basis
  // vector onto the up vector. The projection is the y basis vector.
  fDotProduct := VectorDotProduct( vWorldUp, vView );

  vUp := VectorSub(vWorldUp, VectorMulS(vView, fDotProduct));

  // If this vector has near-zero length because the input specified a
  // bogus up vector, let's try a default up vector
  fLength := VectorMagnitude(vUp);
  if fLength <= 1E-6 then
  begin
    vUp.x := 0; vUp.y := 1; vUp.z := 0;
    vUp := VectorSub(vUp, VectorMulS(vView, vView.y));

    // If we still have near-zero length, resort to a different axis.
    fLength := VectorMagnitude(vUp);
    if fLength <= 1E-6 then
    begin
      vUp.x := 0; vUp.y := 0; vUp.z := 1;
      vUp := VectorSub(vUp, VectorMulS(vView, vView.z));

      fLength := VectorMagnitude(vUp);
      if fLength <= 1E-6 then
      begin
        Result := E_INVALIDARG;
        Exit;
      end;
    end;
  end;

  // Normalize the y basis vector
  vUp := VectorDivS(vUp, fLength);

  // The x basis vector is found simply with the cross product of the y
  // and z basis vectors
  vRight := VectorCrossProduct(vUp, vView);

  // Start building the matrix. The first three rows contains the basis
  // vectors used to rotate the view to point at the lookat point
  D3DUtil_SetIdentityMatrix(mat);
  with mat do
  begin
    _11 := vRight.x;    _12 := vUp.x;    _13 := vView.x;
    _21 := vRight.y;    _22 := vUp.y;    _23 := vView.y;
    _31 := vRight.z;    _32 := vUp.z;    _33 := vView.z;

    // Do the translation values (rotations are still about the eyepoint)
    _41 := - VectorDotProduct( vFrom, vRight );
    _42 := - VectorDotProduct( vFrom, vUp );
    _43 := - VectorDotProduct( vFrom, vView );
  end;
  Result := S_OK;
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_SetProjectionMatrix()
// Desc: Sets the passed in 4x4 matrix to a perpsective projection matrix built
//       from the field-of-view (fov, in y), aspect ratio, near plane (D),
//       and far plane (F). Note that the projection matrix is normalized for
//       element [3][4] to be 1.0. This is performed so that W-based range fog
//       will work correctly.
//-----------------------------------------------------------------------------
function D3DUtil_SetProjectionMatrix(var mat: TD3DMatrix;
  fFOV, fAspect, fNearPlane, fFarPlane: FLOAT): HResult;
var w,h,Q: FLOAT;
begin
  if (Abs(fFarPlane-fNearPlane) < 0.01) or (Abs(sin(fFOV/2)) < 0.01) then
  begin
    Result := E_INVALIDARG;
    Exit;
  end;

  w := fAspect * (cos(fFOV/2)/sin(fFOV/2) );  // cosf, sinf = cos,sin(FLOAT)
  h :=   1.0  * (cos(fFOV/2)/sin(fFOV/2) );
  Q := fFarPlane / ( fFarPlane - fNearPlane );

  FillChar(mat, SizeOf(mat), 0);
  with mat do
  begin
    _11 := w; _22 := h; _33 := Q;
    _34 := 1.0;
    _43 := -Q*fNearPlane;
  end;

  Result := S_OK;
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_InitLight()
// Desc: Initializes a D3DLIGHT7 structure
//-----------------------------------------------------------------------------
procedure D3DUtil_InitLight(var Light: TD3DLight7; ltType: TD3DLIGHTTYPE; x,y,z: FLOAT);
begin
  FillChar(Light, SizeOf(Light), 0);
  with Light do
  begin
    dltType        := ltType;
    dcvDiffuse.r   := 1.0; dcvDiffuse.g := 1.0; dcvDiffuse.b := 1.0;
    dcvSpecular    := dcvDiffuse;
    dvPosition.x   := x; dvDirection.x := x;
    dvPosition.y   := y; dvDirection.y := y;
    dvPosition.z   := z; dvDirection.z := z;
    dvAttenuation0 := 1.0;
    dvRange        := D3DLIGHT_RANGE_MAX;
  end;
end;

end.

