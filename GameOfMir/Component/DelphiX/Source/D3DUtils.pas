unit D3DUtils;

interface

uses
  Windows, Math,
{$IfDef StandardDX}
  DirectDraw, Direct3D;
{$Else}
  DirectX;
{$EndIf}


const
  g_PI       =  3.14159265358979323846; // Pi
  g_Uhel       =  g_PI / 180  ;
  g_2_PI     =  6.28318530717958623200; // 2 * Pi
  g_PI_DIV_2 =  1.57079632679489655800; // Pi / 2
  g_PI_DIV_4 =  0.78539816339744827900; // Pi / 4
  g_INV_PI   =  0.31830988618379069122; // 1 / Pi
  g_DEGTORAD =  0.01745329251994329547; // Degrees to Radians
  g_RADTODEG = 57.29577951308232286465; // Radians to Degrees
  g_HUGE     =  1.0e+38;                // Huge number for FLOAT
  g_EPSILON  =  1.0e-5;                 // Tolerance for FLOATs

function ProjectionMatrix( near_plane, far_plane,  fov_horiz,  fov_vert:real): TD3DMatrix ;  
function MakeD3DVector(x, y, z: TD3DValue): TD3DVector;
function MakeD3DVertex(hv, nv: TD3DVector; tu, tv: TD3DValue): TD3DVertex;

function D3DMath_IsZero(a: Double; fTol: Double{ = g_EPSILON}): Boolean;
procedure D3DMath_MatrixMultiply(var q: TD3DMatrix; const a, b: TD3DMatrix);
function D3DMath_MatrixInvert(var q: TD3DMatrix; const a: TD3DMatrix): HResult;
function D3DMath_VectorMatrixMultiply(var vDest: TD3DVector; const vSrc: TD3DVector;
  const mat: TD3DMatrix): HResult;
function D3DMath_VertexMatrixMultiply(var vDest: TD3DVertex; const vSrc: TD3DVertex;
  const mat: TD3DMatrix): HResult;
procedure D3DMath_QuaternionFromRotation(var x, y, z, w: Double;
  const v: TD3DVector; fTheta: Double);
procedure D3DMath_RotationFromQuaternion(var v: TD3DVector; var fTheta: Double;
  x, y, z, w: Double);
procedure D3DMath_QuaternionFromAngles(var x, y, z, w: Double; fYaw, fPitch, fRoll: Double);
procedure D3DMath_MatrixFromQuaternion(var mat: TD3DMatrix; x, y, z, w: Double);
procedure D3DMath_QuaternionFromMatrix(var x, y, z, w: Double; var mat: TD3DMatrix);
procedure D3DMath_QuaternionMultiply(var Qx, Qy, Qz, Qw: Double;
  Ax, Ay, Az, Aw, Bx, By, Bz, Bw: Double);
procedure D3DMath_QuaternionSlerp(var Qx, Qy, Qz, Qw: Double;
  Ax, Ay, Az, Aw, Bx, By, Bz, Bw, fAlpha: Double);

procedure D3DUtil_InitSurfaceDesc(var ddsd: TDDSurfaceDesc2; dwFlags, dwCaps: DWORD);
procedure D3DUtil_InitMaterial(var mtrl: TD3DMaterial7; r, g, b, a: Double);
procedure D3DUtil_InitLight(var light: TD3DLight7; ltType: TD3DLightType; x, y, z: Double);
procedure D3DUtil_SetIdentityMatrix(var m: TD3DMatrix);
function D3DUtil_SetViewMatrix(var mat: TD3DMatrix;  const vFrom, vAt, vWorldUp: TD3DVector): HResult;
function D3DUtil_SetProjectionMatrix(var mat: TD3DMatrix; fFOV, fAspect, fNearPlane, fFarPlane: Double): HResult;
procedure D3DUtil_SetRotateXMatrix(var mat: TD3DMatrix; fRads: Double);
procedure D3DUtil_SetRotateYMatrix(var mat: TD3DMatrix; fRads: Double);
procedure D3DUtil_SetRotateZMatrix(var mat: TD3DMatrix; fRads: Double);
procedure D3DUtil_SetRotationMatrix(var mat: TD3DMatrix; var vDir: TD3DVector; fRads: Double);

implementation

function MakeD3DVector(x, y, z: TD3DValue): TD3DVector;
begin
  Result.x := x;
  Result.y := y;
  Result.z := z;
end;

function MakeD3DVertex(hv, nv: TD3DVector; tu, tv: TD3DValue): TD3DVertex;
begin
  Result.x := hv.x;
  Result.y := hv.y;
  Result.z := hv.z;
  Result.nx := nv.x;
  Result.ny := nv.y;
  Result.nz := nv.z;
  Result.tu := tu;
  Result.tv := tv;
end;


function ProjectionMatrix( near_plane,     // distance to near clipping plane
                           far_plane,     // distance to far clipping plane
                           fov_horiz,     // horizontal field of view angle, in radians
                           fov_vert:real): TD3DMatrix ;    // vertical field of view angle, in radians
var h,w,Q:real;
begin
    Fov_horiz:=g_Uhel * Fov_horiz;
    Fov_Vert:=g_Uhel * Fov_Vert;

    w := cotan(fov_horiz*0.5);
    h := cotan(fov_vert*0.5);
    Q := far_plane/(far_plane - near_plane);

    result._11 := w;
    result._22 := h;
    result._33 := Q;
    result._43 := -Q*near_plane;
    result._34 := 1;
end;
   // end of ProjectionMatrix()

//-----------------------------------------------------------------------------
// File: D3DMath.cpp
//
// Desc: Shortcut macros and functions for using DX objects
//
// Copyright (c) 1997-1999 Microsoft Corporation. All rights reserved
//-----------------------------------------------------------------------------

function D3DMath_IsZero(a: Double; fTol: Double{ = g_EPSILON}): Boolean;
begin
  if a<0 then
    Result := a>=-fTol
  else
    Result := a<=fTol;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_MatrixMultiply()
// Desc: Does the matrix operation: [Q] = [A] * [B]. Note that the order of
//       this operation was changed from the previous version of the DXSDK.
//-----------------------------------------------------------------------------
procedure D3DMath_MatrixMultiply(var q: TD3DMatrix; const a, b: TD3DMatrix);
type
  PArrayD3DValue = ^TArrayD3DValue;
  TArrayD3DValue = array[0..15] of TD3DValue;
var
  pA, pB, pQ: PArrayD3DValue;
  i, j, k: Integer;
begin
  FillChar(q, SizeOf(q), 0);

  pA := @a;
  pB := @b;
  pQ := @q;
  for i:=0 to 3 do
    for j:=0 to 3 do
      for k:=0 to 3 do
        pQ[4*i+j] := pQ[4*i+j] + pA[4*i+k] * pB[4*k+j];
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_MatrixInvert()
// Desc: Does the matrix operation: [Q] = inv[A]. Note: this function only
//       works for matrices with [0 0 0 1] for the 4th column.
//-----------------------------------------------------------------------------
function D3DMath_MatrixInvert(var q: TD3DMatrix; const a: TD3DMatrix): HResult;
var
  fDetInv: Double;
begin
  if (abs(a._44-1.0)>0.001) or (abs(a._14) > 0.001) or (abs(a._24) > 0.001) or (abs(a._34) > 0.001) then
  begin
    Result := E_INVALIDARG;
    Exit;
  end;

  fDetInv := 1.0 / ( a._11 * ( a._22 * a._33 - a._23 * a._32 ) -
                     a._12 * ( a._21 * a._33 - a._23 * a._31 ) +
                     a._13 * ( a._21 * a._32 - a._22 * a._31 ) );

  q._11 :=  fDetInv * ( a._22 * a._33 - a._23 * a._32 );
  q._12 := -fDetInv * ( a._12 * a._33 - a._13 * a._32 );
  q._13 :=  fDetInv * ( a._12 * a._23 - a._13 * a._22 );
  q._14 := 0.0;

  q._21 := -fDetInv * ( a._21 * a._33 - a._23 * a._31 );
  q._22 :=  fDetInv * ( a._11 * a._33 - a._13 * a._31 );
  q._23 := -fDetInv * ( a._11 * a._23 - a._13 * a._21 );
  q._24 := 0.0;

  q._31 :=  fDetInv * ( a._21 * a._32 - a._22 * a._31 );
  q._32 := -fDetInv * ( a._11 * a._32 - a._12 * a._31 );
  q._33 :=  fDetInv * ( a._11 * a._22 - a._12 * a._21 );
  q._34 := 0.0;

  q._41 := -( a._41 * q._11 + a._42 * q._21 + a._43 * q._31 );
  q._42 := -( a._41 * q._12 + a._42 * q._22 + a._43 * q._32 );
  q._43 := -( a._41 * q._13 + a._42 * q._23 + a._43 * q._33 );
  q._44 := 1.0;

  Result := S_OK;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_VectorMatrixMultiply()
// Desc: Multiplies a vector by a matrix
//-----------------------------------------------------------------------------
function D3DMath_VectorMatrixMultiply(var vDest: TD3DVector; const vSrc: TD3DVector;
  const mat: TD3DMatrix): HResult;
var
  x, y, z, w: Double;
begin
  x := vSrc.x*mat._11 + vSrc.y*mat._21 + vSrc.z* mat._31 + mat._41;
  y := vSrc.x*mat._12 + vSrc.y*mat._22 + vSrc.z* mat._32 + mat._42;
  z := vSrc.x*mat._13 + vSrc.y*mat._23 + vSrc.z* mat._33 + mat._43;
  w := vSrc.x*mat._14 + vSrc.y*mat._24 + vSrc.z* mat._34 + mat._44;

  if abs(w) < g_EPSILON then
  begin
    Result := E_INVALIDARG;
    Exit;
  end;

  vDest.x := x/w;
  vDest.y := y/w;
  vDest.z := z/w;

  Result := S_OK;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_VertexMatrixMultiply()
// Desc: Multiplies a vertex by a matrix
//-----------------------------------------------------------------------------
function D3DMath_VertexMatrixMultiply(var vDest: TD3DVertex; const vSrc: TD3DVertex;
  const mat: TD3DMatrix): HResult;
var
  pSrcVec, pDestVec: PD3DVector;
begin
  pSrcVec := @vSrc.x;
  pDestVec := @vDest.x;

  Result := D3DMath_VectorMatrixMultiply(pDestVec^, pSrcVec^, mat);
  if SUCCEEDED(Result) then
  begin
    pSrcVec  := @vSrc.nx;
    pDestVec := @vDest.nx;
    Result := D3DMath_VectorMatrixMultiply(pDestVec^, pSrcVec^, mat);
  end;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_QuaternionFromRotation()
// Desc: Converts a normalized axis and angle to a unit quaternion.
//-----------------------------------------------------------------------------
procedure D3DMath_QuaternionFromRotation(var x, y, z, w: Double;
  const v: TD3DVector; fTheta: Double);
begin
  x := sin( fTheta/2.0 ) * v.x;
  y := sin( fTheta/2.0 ) * v.y;
  z := sin( fTheta/2.0 ) * v.z;
  w := cos( fTheta/2.0 );
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_RotationFromQuaternion()
// Desc: Converts a normalized axis and angle to a unit quaternion.
//-----------------------------------------------------------------------------
procedure D3DMath_RotationFromQuaternion(var v: TD3DVector; var fTheta: Double;
  x, y, z, w: Double);
begin
  fTheta := arccos(w) * 2.0;
  v.x    := x / sin( fTheta/2.0 );
  v.y    := y / sin( fTheta/2.0 );
  v.z    := z / sin( fTheta/2.0 );
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_QuaternionFromAngles()
// Desc: Converts euler angles to a unit quaternion.
//-----------------------------------------------------------------------------
procedure D3DMath_QuaternionFromAngles(var x, y, z, w: Double; fYaw, fPitch, fRoll: Double);
var
  fSinYaw, fSinPitch, fSinRoll, fCosYaw, fCosPitch, fCosRoll: Double;
begin
  fSinYaw   := sin( fYaw/2.0 );
  fSinPitch := sin( fPitch/2.0 );
  fSinRoll  := sin( fRoll/2.0 );
  fCosYaw   := cos( fYaw/2.0 );
  fCosPitch := cos( fPitch/2.0 );
  fCosRoll  := cos( fRoll/2.0 );

  x := fSinRoll * fCosPitch * fCosYaw - fCosRoll * fSinPitch * fSinYaw;
  y := fCosRoll * fSinPitch * fCosYaw + fSinRoll * fCosPitch * fSinYaw;
  z := fCosRoll * fCosPitch * fSinYaw - fSinRoll * fSinPitch * fCosYaw;
  w := fCosRoll * fCosPitch * fCosYaw + fSinRoll * fSinPitch * fSinYaw;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_MatrixFromQuaternion()
// Desc: Converts a unit quaternion into a rotation matrix.
//-----------------------------------------------------------------------------
procedure D3DMath_MatrixFromQuaternion(var mat: TD3DMatrix; x, y, z, w: Double);
var
  xx, yy, zz, xy, xz, yz, wx, wy, wz: Double;
begin
  xx := x*x; yy := y*y; zz := z*z;
  xy := x*y; xz := x*z; yz := y*z;
  wx := w*x; wy := w*y; wz := w*z;

  mat._11 := 1 - 2 * ( yy + zz );
  mat._12 :=     2 * ( xy - wz );
  mat._13 :=     2 * ( xz + wy );

  mat._21 :=     2 * ( xy + wz );
  mat._22 := 1 - 2 * ( xx + zz );
  mat._23 :=     2 * ( yz - wx );

  mat._31 :=     2 * ( xz - wy );
  mat._32 :=     2 * ( yz + wx );
  mat._33 := 1 - 2 * ( xx + yy );

  mat._14 := 0.0; mat._24 := 0.0; mat._34 := 0.0;
  mat._41 := 0.0; mat._42 := 0.0; mat._43 := 0.0;
  mat._44 := 1.0;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_QuaternionFromMatrix()
// Desc: Converts a rotation matrix into a unit quaternion.
//-----------------------------------------------------------------------------
procedure D3DMath_QuaternionFromMatrix(var x, y, z, w: Double; var mat: TD3DMatrix);
var
  s: Double;
  xx, yy, zz, xy, xz, yz, wx, wy, wz: Double;
begin
  if( mat._11 + mat._22 + mat._33 > 0.0 )then
  begin
    s := sqrt( mat._11 + mat._22 + mat._33 + mat._44 );

    x := (mat._23-mat._32) / (2*s);
    y := (mat._31-mat._13) / (2*s);
    z := (mat._12-mat._21) / (2*s);
    w := 0.5 * s;
  end;

  xx := x*x; yy := y*y; zz := z*z;
  xy := x*y; xz := x*z; yz := y*z;
  wx := w*x; wy := w*y; wz := w*z;

  mat._11 := 1 - 2 * ( yy + zz );
  mat._12 :=     2 * ( xy - wz );
  mat._13 :=     2 * ( xz + wy );

  mat._21 :=     2 * ( xy + wz );
  mat._22 := 1 - 2 * ( xx + zz );
  mat._23 :=     2 * ( yz - wx );

  mat._31 :=     2 * ( xz - wy );
  mat._32 :=     2 * ( yz + wx );
  mat._33 := 1 - 2 * ( xx + yy );

  mat._14 := 0.0; mat._24 := 0.0; mat._34 := 0.0;
  mat._41 := 0.0; mat._42 := 0.0; mat._43 := 0.0;
  mat._44 := 1.0;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_QuaternionMultiply()
// Desc: Mulitples two quaternions together as in {Q} = {A} * {B}.
//-----------------------------------------------------------------------------
procedure D3DMath_QuaternionMultiply(var Qx, Qy, Qz, Qw: Double;
  Ax, Ay, Az, Aw, Bx, By, Bz, Bw: Double);
var
  Dx, Dy, Dz, Dw: Double;
begin
  Dx :=  Ax*Bw + Ay*Bz - Az*By + Aw*Bx;
  Dy := -Ax*Bz + Ay*Bw + Az*Bx + Aw*By;
  Dz :=  Ax*By - Ay*Bx + Az*Bw + Aw*Bz;
  Dw := -Ax*Bx - Ay*By - Az*Bz + Aw*Bw;

  Qx := Dx; Qy := Dy; Qz := Dz; Qw := Dw;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_SlerpQuaternions()
// Desc: Compute a quaternion which is the spherical linear interpolation
//       between two other quaternions by dvFraction.
//-----------------------------------------------------------------------------
procedure D3DMath_QuaternionSlerp(var Qx, Qy, Qz, Qw: Double;
  Ax, Ay, Az, Aw, Bx, By, Bz, Bw, fAlpha: Double);
var
  fCosTheta: Double;
  fBeta: Double;
  fTheta: Double;
begin
  // Compute dot product (equal to cosine of the angle between quaternions)
  fCosTheta := Ax*Bx + Ay*By + Az*Bz + Aw*Bw;

  // Check angle to see if quaternions are in opposite hemispheres
  if fCosTheta < 0.0 then
  begin
    // If so, flip one of the quaterions
    fCosTheta := -fCosTheta;
    Bx := -Bx; By := -By; Bz := -Bz; Bw := -Bw;
  end;

  // Set factors to do linear interpolation, as a special case where the
  // quaternions are close together.
  fBeta := 1.0 - fAlpha;

  // If the quaternions aren't close, proceed with spherical interpolation
  if 1.0 - fCosTheta > 0.001 then
  begin
    fTheta := arccos( fCosTheta );

    fBeta  := sin( fTheta*fBeta ) / sin( fTheta);
    fAlpha := sin( fTheta*fAlpha ) / sin( fTheta);
  end;

  // Do the interpolation
  Qx := fBeta*Ax + fAlpha*Bx;
  Qy := fBeta*Ay + fAlpha*By;
  Qz := fBeta*Az + fAlpha*Bz;
  Qw := fBeta*Aw + fAlpha*Bw;
end;

//-----------------------------------------------------------------------------
// File: D3DUtil.cpp
//
// Desc: Shortcut macros and functions for using DX objects
//
//
// Copyright (c) 1997-1999 Microsoft Corporation. All rights reserved
//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
// Name: D3DUtil_InitSurfaceDesc()
// Desc: Helper function called to build a DDSURFACEDESC2 structure,
//       typically before calling CreateSurface() or GetSurfaceDesc()
//-----------------------------------------------------------------------------
procedure D3DUtil_InitSurfaceDesc(var ddsd: TDDSurfaceDesc2; dwFlags, dwCaps: DWORD);
begin
  FillChar(ddsd, SizeOf(ddsd), 0);
  ddsd.dwSize                 := SizeOf(ddsd);
  ddsd.dwFlags                := dwFlags;
  ddsd.ddsCaps.dwCaps         := dwCaps;
  ddsd.ddpfPixelFormat.dwSize := SizeOf(ddsd.ddpfPixelFormat);
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_InitMaterial()
// Desc: Helper function called to build a D3DMATERIAL7 structure
//-----------------------------------------------------------------------------
procedure D3DUtil_InitMaterial(var mtrl: TD3DMaterial7; r, g, b, a: Double);
begin
  FillChar(mtrl, SizeOf(mtrl), 0);
  mtrl.dcvDiffuse.r := r; mtrl.dcvAmbient.r := r;
  mtrl.dcvDiffuse.g := g; mtrl.dcvAmbient.g := g;
  mtrl.dcvDiffuse.b := b; mtrl.dcvAmbient.b := b;
  mtrl.dcvDiffuse.a := a; mtrl.dcvAmbient.a := a;
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_InitLight()
// Desc: Initializes a D3DLIGHT7 structure
//-----------------------------------------------------------------------------
procedure D3DUtil_InitLight(var light: TD3DLight7; ltType: TD3DLightType; x, y, z: Double);
begin
  FillChar(light, SizeOf(light), 0);
  light.dltType        := ltType;
  light.dcvDiffuse.r   := 1.0;
  light.dcvDiffuse.g   := 1.0;
  light.dcvDiffuse.b   := 1.0;
  light.dcvSpecular    := light.dcvDiffuse;
  light.dvPosition.x   := x; light.dvDirection.x := x;
  light.dvPosition.y   := y; light.dvDirection.y := y;
  light.dvPosition.z   := z; light.dvDirection.z := z;
  light.dvAttenuation0 := 1.0;
  light.dvRange        := D3DLIGHT_RANGE_MAX;
end;

procedure D3DUtil_SetIdentityMatrix(var m: TD3DMatrix);
begin
  m._12 := 0; m._13 := 0; m._14 := 0; m._21 := 0; m._23 := 0; m._24 := 0;
  m._31 := 0; m._32 := 0; m._34 := 0; m._41 := 0; m._42 := 0; m._43 := 0;
  m._11 := 1; m._22 := 1; m._33 := 1; m._44 := 1;
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_SetViewMatrix()
// Desc: Given an eye point, a lookat point, and an up vector, this
//       function builds a 4x4 view matrix.
//-----------------------------------------------------------------------------
function D3DUtil_SetViewMatrix(var mat: TD3DMatrix;  const vFrom, vAt, vWorldUp: TD3DVector): HResult;
var
  vView: TD3DVector;
  fLength: Double;
  fDotProduct: Double;
  vUp: TD3DVector;
  vRight: TD3DVector;
begin
  // Get the z basis vector, which points straight ahead. This is the
  // difference from the eyepoint to the lookat point.
  vView := VectorSub(vAt, vFrom);

  fLength := VectorMagnitude( vView );
  if fLength < 0.1e-6 then
  begin
    Result := E_INVALIDARG;
    Exit;
  end;

  // Normalize the z basis vector
  vView := VectorDivS(vView, fLength);

  // Get the dot product, and calculate the projection of the z basis
  // vector onto the up vector. The projection is the y basis vector.
  fDotProduct :=VectorDotProduct( vWorldUp, vView );

  vUp := VectorSub(vWorldUp, VectorMulS(vView, fDotProduct));

  // If this vector has near-zero length because the input specified a
  // bogus up vector, let's try a default up vector
  fLength := VectorMagnitude(vUp);
  if 1e-6 > fLength then
  begin
    vUp := VectorSub(MakeD3DVector(0, 1, 0), VectorMulS(vView, vView.y));

    // If we still have near-zero length, resort to a different axis.
    fLength := VectorMagnitude(vUp);
    if 1e-6 > fLength then
    begin
      vUp := VectorSub(MakeD3DVector(0, 0, 1), VectorMulS(vView, vView.z));

      fLength := VectorMagnitude(vUp);
      if  1e-6 > fLength then
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
  vRight := VectorCrossProduct( vUp, vView );

  // Start building the matrix. The first three rows contains the basis
  // vectors used to rotate the view to point at the lookat point
  D3DUtil_SetIdentityMatrix( mat );
  mat._11 := vRight.x;    mat._12 := vUp.x;    mat._13 := vView.x;
  mat._21 := vRight.y;    mat._22 := vUp.y;    mat._23 := vView.y;
  mat._31 := vRight.z;    mat._32 := vUp.z;    mat._33 := vView.z;

  // Do the translation values (rotations are still about the eyepoint)
  mat._41 := - VectorDotProduct( vFrom, vRight );
  mat._42 := - VectorDotProduct( vFrom, vUp );
  mat._43 := - VectorDotProduct( vFrom, vView );

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
function D3DUtil_SetProjectionMatrix(var mat: TD3DMatrix; fFOV, fAspect, fNearPlane, fFarPlane: Double): HResult;
var
  w, h, Q: Double;
begin
  if (abs(fFarPlane-fNearPlane)<0.01) or (abs(sin(fFOV/2))<0.01) then
  begin
    Result := E_INVALIDARG;
    Exit;
  end;

  w := fAspect * ( cos(fFOV/2)/sin(fFOV/2) );
  h :=   1.0   * ( cos(fFOV/2)/sin(fFOV/2) );
  Q := fFarPlane / ( fFarPlane - fNearPlane );

  FillChar(mat, SizeOf(mat), 0);
  mat._11 := w;
  mat._22 := h;
  mat._33 := Q;
  mat._34 := 1.0;
  mat._43 := -Q*fNearPlane;

  Result := S_OK;
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_SetRotateXMatrix()
// Desc: Create Rotation matrix about X axis
//-----------------------------------------------------------------------------
procedure D3DUtil_SetRotateXMatrix(var mat: TD3DMatrix; fRads: Double);
begin
  D3DUtil_SetIdentityMatrix( mat );
  mat._22 :=  cos( fRads );
  mat._23 :=  sin( fRads );
  mat._32 := -sin( fRads );
  mat._33 :=  cos( fRads );
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_SetRotateYMatrix()
// Desc: Create Rotation matrix about Y axis
//-----------------------------------------------------------------------------
procedure D3DUtil_SetRotateYMatrix(var mat: TD3DMatrix; fRads: Double);
begin
  D3DUtil_SetIdentityMatrix( mat );
  mat._11 :=  cos( fRads );
  mat._13 := -sin( fRads );
  mat._31 :=  sin( fRads );
  mat._33 :=  cos( fRads );
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_SetRotateZMatrix()
// Desc: Create Rotation matrix about Z axis
//-----------------------------------------------------------------------------
procedure D3DUtil_SetRotateZMatrix(var mat: TD3DMatrix; fRads: Double);
begin
  D3DUtil_SetIdentityMatrix( mat );
  mat._11  :=  cos( fRads );
  mat._12  :=  sin( fRads );
  mat._21  := -sin( fRads );
  mat._22  :=  cos( fRads );
end;

//-----------------------------------------------------------------------------
// Name: D3DUtil_SetRotationMatrix
// Desc: Create a Rotation matrix about vector direction
//-----------------------------------------------------------------------------
procedure D3DUtil_SetRotationMatrix(var mat: TD3DMatrix; var vDir: TD3DVector; fRads: Double);
var
  fCos, fSin: Double;
  v: TD3DVector;
begin
  fCos := cos( fRads );
  fSin := sin( fRads );
  v    := VectorNormalize( vDir );

  mat._11 := ( v.x * v.x ) * ( 1.0 - fCos ) + fCos;
  mat._12 := ( v.x * v.y ) * ( 1.0 - fCos ) - (v.z * fSin);
  mat._13 := ( v.x * v.z ) * ( 1.0 - fCos ) + (v.y * fSin);

  mat._21 := ( v.y * v.x ) * ( 1.0 - fCos ) + (v.z * fSin);
  mat._22 := ( v.y * v.y ) * ( 1.0 - fCos ) + fCos ;
  mat._23 := ( v.y * v.z ) * ( 1.0 - fCos ) - (v.x * fSin);

  mat._31 := ( v.z * v.x ) * ( 1.0 - fCos ) - (v.y * fSin);
  mat._32 := ( v.z * v.y ) * ( 1.0 - fCos ) + (v.x * fSin);
  mat._33 := ( v.z * v.z ) * ( 1.0 - fCos ) + fCos;

  mat._14 := 0; mat._24 := 0; mat._34 := 0;
  mat._41 := 0; mat._42 := 0; mat._43 := 0;
  mat._44 := 1.0;
end;

end.