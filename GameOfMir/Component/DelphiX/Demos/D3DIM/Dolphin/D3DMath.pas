//-----------------------------------------------------------------------------
// File: D3DMath.h & .cpp
//
// Desc: Math functions and shortcuts for Direct3D programming.
//
// Delphi translation by Arne Schäpers, 03-MAR-2000
//
// Copyright (c) 1997-1999 Microsoft Corporation. All rights reserved
//-----------------------------------------------------------------------------
unit D3DMath;

interface
uses Windows, Math, DirectX;

//-----------------------------------------------------------------------------
// Useful Math constants
//-----------------------------------------------------------------------------
const
  g_PI       : FLOAT =   3.14159265358979323846; // Pi
  g_2_PI     : FLOAT =   6.28318530717958623200; // 2 * Pi
  g_PI_DIV_2 : FLOAT =   1.57079632679489655800; // Pi / 2
  g_PI_DIV_4 : FLOAT =   0.78539816339744827900; // Pi / 4
  g_INV_PI   : FLOAT =   0.31830988618379069122; // 1 / Pi
  g_DEGTORAD : FLOAT =   0.01745329251994329547; // Degrees to Radians
  g_RADTODEG : FLOAT =  57.29577951308232286465; // Radians to Degrees
  g_HUGE     : FLOAT =   1.0e+38;                // Huge number for
  g_EPSILON  : FLOAT =   1.0e-5;                 // Tolerance for s


//-----------------------------------------------------------------------------
// Fuzzy compares (within tolerance)
//-----------------------------------------------------------------------------
function D3DMath_IsZero(const a: FLOAT; fTol: FLOAT { = g_EPSILON}): Boolean;

//-----------------------------------------------------------------------------
// Matrix functions
//-----------------------------------------------------------------------------
procedure D3DMath_MatrixMultiply(var Res: TD3DMatrix; const a,b: TD3DMatrix);
function D3DMath_MatrixInvert(var Q: TD3DMatrix; const a: TD3DMatrix): HResult;


//-----------------------------------------------------------------------------
// Vector functions
//-----------------------------------------------------------------------------
function D3DMath_VectorMatrixMultiply(var vDest: TD3DVector;
   const vSrc: TD3DVector; const mat: TD3DMatrix): HResult;
function D3DMath_VertexMatrixMultiply(var vDest: TD3DVertex;
  const vSrc: TD3DVertex; const mat: TD3DMatrix): HResult;


//-----------------------------------------------------------------------------
// Quaternion functions
//-----------------------------------------------------------------------------
procedure D3DMath_QuaternionFromRotation(var x,y,z,w: FLOAT;
   const v: TD3DVector; fTheta: FLOAT);
procedure D3DMath_RotationFromQuaternion(var v: TD3DVector;
  var fTheta: FLOAT; const x,y,z,w: FLOAT);
procedure D3DMath_QuaternionFromAngles(var x,y,z,w: FLOAT;
   const fYaw, fPitch, fRoll: FLOAT);
procedure D3DMath_MatrixFromQuaternion(var mat: TD3DMatrix;
  const x,y,z,w: FLOAT);
procedure D3DMath_QuaternionFromMatrix(var x,y,z,w: FLOAT; var mat: TD3DMatrix);
procedure D3DMath_QuaternionMultiply(var Qx, Qy, Qz, Qw: FLOAT;
   const Ax, Ay, Az, Aw, Bx, By, Bz, Bw: FLOAT);
procedure D3DMath_QuaternionSlerp(var Qx, Qy, Qz, Qw: FLOAT;
  const Ax, Ay, Az, Aw: FLOAT; Bx, By, Bz, Bw, fAlpha: FLOAT);

implementation

//-----------------------------------------------------------------------------
// Fuzzy compares (within tolerance)
//-----------------------------------------------------------------------------
function D3DMath_IsZero(const a: FLOAT; fTol: FLOAT { = g_EPSILON}): Boolean;
begin
  Result := Abs(a) <= fTol;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_MatrixMultiply()
// Desc: Does the matrix operation: [Q] = [A] * [B]. Note that the order of
//       this operation was changed from the previous version of the DXSDK.
//-----------------------------------------------------------------------------
procedure D3DMath_MatrixMultiply(var Res: TD3DMatrix; const a,b: TD3DMatrix);
type TFLOATArray = Array[0..15] of FLOAT;
var pA, pB: ^TFLOATArray; Q: TFLOATArray; i,j,k: Integer;
begin
  pA := @a;  pB := @b;
  FillChar(Q, SizeOf(Q),0);

  for i := 0 to 3 do
    for j := 0 to 3 do
      for k := 0 to 3 do
        Q[4*i+j] := Q[4*i+j] + pA[4*i+k] * pB[4*k+j];
  Move(Q, Res, SizeOf(Q));
end;


//-----------------------------------------------------------------------------
// Name: D3DMath_MatrixInvert()
// Desc: Does the matrix operation: [Q] = inv[A]. Note: this function only
//       works for matrices with [0 0 0 1] for the 4th column.
//-----------------------------------------------------------------------------
function D3DMath_MatrixInvert(var Q: TD3DMatrix; const a: TD3DMatrix): HResult;
var fDetInv: FLOAT;
begin
  with a do
  begin
    if (Abs(_44 - 1.0) > 0.001) or (Abs(_14) > 0.001) or
      (Abs(_24) > 0.001) or (Abs(_34) > 0.001) then
    begin
      Result := E_INVALIDARG; Exit;
    end;

    fDetInv := 1.0 / (_11 * ( _22 * _33 - _23 * _32 ) -
                      _12 * ( _21 * _33 - _23 * _31 ) +
                      _13 * ( _21 * _32 - _22 * _31 ));

    q._11 :=  fDetInv * ( _22 * _33 - _23 * _32 );
    q._12 := -fDetInv * ( _12 * _33 - _13 * _32 );
    q._13 :=  fDetInv * ( _12 * _23 - _13 * _22 );
    q._14 := 0.0;

    q._21 := -fDetInv * ( _21 * _33 - _23 * _31 );
    q._22 :=  fDetInv * ( _11 * _33 - _13 * _31 );
    q._23 := -fDetInv * ( _11 * _23 - _13 * _21 );
    q._24 := 0.0;

    q._31 :=  fDetInv * ( _21 * _32 - _22 * _31 );
    q._32 := -fDetInv * ( _11 * _32 - _12 * _31 );
    q._33 :=  fDetInv * ( _11 * _22 - _12 * _21 );
    q._34 := 0.0;

    q._41 := -( _41 * q._11 + _42 * q._21 + _43 * q._31 );
    q._42 := -( _41 * q._12 + _42 * q._22 + _43 * q._32 );
    q._43 := -( _41 * q._13 + _42 * q._23 + _43 * q._33 );
    q._44 := 1.0;
  end;
  Result := S_OK;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_VectorMatrixMultiply()
// Desc: Multiplies a vector by a matrix
//-----------------------------------------------------------------------------
function D3DMath_VectorMatrixMultiply(var vDest: TD3DVector;
   const vSrc: TD3DVector; const mat: TD3DMatrix): HResult;
var w: FLOAT;
begin
  with mat, vSrc do
  begin
    w := x* _14 + y* _24 + z*  _34 +  _44;
    if Abs(w) < g_EPSILON then
    begin
      Result := E_INVALIDARG; Exit;
    end;

    vDest.x := (x* _11 + y* _21 + z*  _31 +  _41) / w;
    vDest.y := (x* _12 + y* _22 + z*  _32 +  _42) / w;
    vDest.z := (x* _13 + y* _23 + z*  _33 +  _43) / w;
  end;
  Result := S_OK;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_VertexMatrixMultiply()
// Desc: Multiplies a vertex by a matrix
//-----------------------------------------------------------------------------
function D3DMath_VertexMatrixMultiply(var vDest: TD3DVertex;
  const vSrc: TD3DVertex; const mat: TD3DMatrix): HResult;
var pSrcVec, pDestVec: PD3DVector;
begin
  pSrcVec := @vSrc.x; pDestVec := @vDest.x;

  Result := D3DMath_VectorMatrixMultiply(pDestVec^, pSrcVec^, mat);
  if SUCCEEDED(Result) then
  begin
    pSrcVec := @vSrc.nx; pDestVec := @vDest.nx;
    Result := D3DMath_VectorMatrixMultiply(pDestVec^, pSrcVec^, mat );
  end;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_QuaternionFromRotation()
// Desc: Converts a normalized axis and angle to a unit quaternion.
//-----------------------------------------------------------------------------
procedure D3DMath_QuaternionFromRotation(var x,y,z,w: FLOAT;
   const v: TD3DVector; fTheta: FLOAT);
var fSinTheta: FLOAT;
begin
  fTheta := fTheta / 2.0;
  fSinTheta := Sin(fTheta);
  x := fSinTheta * v.x; y := fSinTheta * v.y; z := fSinTheta * v.z;
  w := Cos(fTheta);
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_RotationFromQuaternion()
// Desc: Converts a normalized axis and angle to a unit quaternion.
//-----------------------------------------------------------------------------
procedure D3DMath_RotationFromQuaternion(var v: TD3DVector;
  var fTheta: FLOAT; const x,y,z,w: FLOAT);
var fTheta2Sin: FLOAT;
begin
  fTheta := ArcCos(w) * 2.0;
  fTheta2Sin := Sin(fTheta / 2.0);
  v.x := x / fTheta2Sin; v.y := y / fTheta2Sin;   v.z := z / fTheta2Sin;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_QuaternionFromAngles()
// Desc: Converts euler angles to a unit quaternion.
//-----------------------------------------------------------------------------
procedure D3DMath_QuaternionFromAngles(var x,y,z,w: FLOAT;
   const fYaw, fPitch, fRoll: FLOAT);
var fSinYaw, fSinPitch, fSinRoll, fCosYaw, fCosPitch, fCosRoll: FLOAT;
begin
  fSinYaw := sin(fYaw/2.0); fSinPitch := sin(fPitch/2.0);
  fSinRoll := sin(fRoll/2.0); fCosYaw := cos(fYaw/2.0);
  fCosPitch := cos(fPitch/2.0); fCosRoll := (fRoll/2.0);

  x := fSinRoll * fCosPitch * fCosYaw - fCosRoll * fSinPitch * fSinYaw;
  y := fCosRoll * fSinPitch * fCosYaw + fSinRoll * fCosPitch * fSinYaw;
  z := fCosRoll * fCosPitch * fSinYaw - fSinRoll * fSinPitch * fCosYaw;
  w := fCosRoll * fCosPitch * fCosYaw + fSinRoll * fSinPitch * fSinYaw;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_MatrixFromQuaternion()
// Desc: Converts a unit quaternion into a rotation matrix.
//-----------------------------------------------------------------------------
procedure D3DMath_MatrixFromQuaternion(var mat: TD3DMatrix;
  const x,y,z,w: FLOAT);
var xx, yy, zz, xy, xz, yz, wx, wy, wz: FLOAT;
begin
  xx := Sqr(x); yy := Sqr(y); zz := Sqr(z);
  xy := x*y; xz := x*z; yz := y*z;
  wx := w*x; wy := w*y; wz := w*z;

  with mat do
  begin
    _11 :=  1 - 2 * ( yy + zz );
    _12 :=      2 * ( xy - wz );
    _13 :=      2 * ( xz + wy );

    _21 :=      2 * ( xy + wz );
    _22 :=  1 - 2 * ( xx + zz );
    _23 :=      2 * ( yz - wx );

    _31 :=      2 * ( xz - wy );
    _32 :=      2 * ( yz + wx );
    _33 :=  1 - 2 * ( xx + yy );

    _14 := 0; _24 := 0; _34 :=  0;
    _41 := 0; _42 := 0; _43 :=  0;
    _44 :=  1.0;
  end;
end;



//-----------------------------------------------------------------------------
// Name: D3DMath_QuaternionFromMatrix()
// Desc: Converts a rotation matrix into a unit quaternion.
//-----------------------------------------------------------------------------
procedure D3DMath_QuaternionFromMatrix(var x,y,z,w: FLOAT; var mat: TD3DMatrix);
var s, xx, yy, zz, xy, xz, yz, wx, wy, wz: FLOAT;
begin
  if mat._11 + mat._22 + mat._33 > 0.0 then
  begin
    s := Sqrt( mat._11 + mat._22 + mat._33 + mat._44 );

    x := (mat._23-mat._32) / (2*s);
    y := (mat._31-mat._13) / (2*s);
    z := (mat._12-mat._21) / (2*s);
    w := 0.5 * s;
  end else
  begin
    xx := Sqr(x); yy := Sqr(y); zz := Sqr(z);
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

    mat._14 := 0; mat._24 := 0; mat._34 := 0;
    mat._41 := 0; mat._42 := 0; mat._43 := 0;
    mat._44 := 1.0;
  end;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_QuaternionMultiply()
// Desc: Mulitples two quaternions together as in {Q} = {A} * {B}.
//-----------------------------------------------------------------------------
procedure D3DMath_QuaternionMultiply(var Qx, Qy, Qz, Qw: FLOAT;
   const Ax, Ay, Az, Aw, Bx, By, Bz, Bw: FLOAT);
begin
  Qx :=  Ax*Bw + Ay*Bz - Az*By + Aw*Bx;
  Qy := -Ax*Bz + Ay*Bw + Az*Bx + Aw*By;
  Qz :=  Ax*By - Ay*Bx + Az*Bw + Aw*Bz;
  Qw := -Ax*Bx - Ay*By - Az*Bz + Aw*Bw;
end;

//-----------------------------------------------------------------------------
// Name: D3DMath_SlerpQuaternions()
// Desc: Compute a quaternion which is the spherical linear interpolation
//       between two other quaternions by dvFraction.
//-----------------------------------------------------------------------------
procedure D3DMath_QuaternionSlerp(var Qx, Qy, Qz, Qw: FLOAT;
  const Ax, Ay, Az, Aw: FLOAT; Bx, By, Bz, Bw, fAlpha: FLOAT);
var fCosTheta, fBeta, fTheta: FLOAT;
begin
  // Compute dot product (equal to cosine of the angle between quaternions)
  fCosTheta := Ax*Bx + Ay*By + Az*Bz + Aw*Bw;

  // Check angle to see if quaternions are in opposite hemispheres
  if fCosTheta < 0.0 then
  begin // If so, flip one of the quaterions
     fCosTheta := -fCosTheta;
     Bx := -Bx; By := -By; Bz := -Bz; Bw := -Bw;
  end;

  // Set factors to do linear interpolation, as a special case where the
  // quaternions are close together.
  fBeta := 1.0 - fAlpha;

  // If the quaternions aren't close, proceed with spherical interpolation
  if 1.0 - fCosTheta > 0.001 then
  begin
    fTheta := ArcCos(fCosTheta);

    fBeta  := Sin(fTheta*fBeta) / Sin(fTheta);
    fAlpha := Sin(fTheta*fAlpha) / Sin(fTheta);
  end;

  // Do the interpolation
  Qx := fBeta*Ax + fAlpha*Bx; Qy := fBeta*Ay + fAlpha*By;
  Qz := fBeta*Az + fAlpha*Bz; Qw := fBeta*Aw + fAlpha*Bw;
end;

end.


