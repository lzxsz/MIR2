unit colli3DX;

{$include DelphiXcfg.inc}


//*************************************************************************
//*                                                                       *
//*  TCollisionTester3DX  vs 1.3                                          *
//*                                                                       *
//*************************************************************************
//
// This Delphi 4, 5, 6 component is CopyRight:
//
// Henrik Fabricius, August 1999, March 2000, June 2002
// http://users.cybercity.dk/~bbl6194/delphi3dx.htm
// E-mail: henrik_og_bodil@vip.cybercity.dk
//
// You may use this component for free on the following conditions:
// 1) this text must remain part of the unit.
// 2) Any proposals for changes or improvements should be addressed directly to
//    the copyright owner Henrik Fabricius
// 3) The use of this component is on your own risk. The software is provided
//    as is without any garanties and warranty. The CopyRight Owner is not
//    responsible for any damage or losses of any kind caused by the use of this
//    software or the software it is intended to be used with.
//
// To place a link for down-loads of this component on your homepage
// please place a link to the Delphi3DX page where the latest version
// is available.
//
// To use this component you must have
// 1) Delphi 4, 5 or 6
// 2) MS-DirectX 6.0 or higher
// 3) the DelphiX components from Hori in Japan
//
// MS-DirectX is a trademark of the Microsoft Corporation
// Delphi 4, 5 and 6 is a trademark of the Inprise Corporation
//
// Use this component to check for collisions between 3D objects in
// Direct3D games.
// Place your 3D-objects in a world described by :
// - DXDrawUsed -
//
// Group the 3D-objects in series with different material
// or functional properties
// The 3D-object series are named by the property:
// - Indexof3DSeries -
// 3D-objects are named by the property :
// - Indexof3Dobject -
// A 3D-object consist of one or more 3D-elements named by the property :
// - Indexof3DElement -
//
// Surround each of your 3D elements by at least one collision object
// which must be a member of the following primitives :
// - box3D - sphere3D - ellipsoid3D - cylinder3D - conus3D -
// available CollOrientations are :
// - Symmetric_X - Symmetric_Y - Symmetric_Z -
// available material properties are :
// - solid3D - water3D - air3D
// the size of the small end of the conus is described by the property
// - PercentLeftatTop -
// a negative value means that the top is downwards
// available functional properties are :
// - Pickable - Shootable - Fixed3DObject
// Add each object by specifying :
// - FrameSeries - NextAddMesh - CoverWholeMesh -
// - IndexOf3DSeries - IndexOf3DObject - IndexOf3DElement -
// if coverWholeMesh is false then specify a box containing the part of the
// 3D object which should be covered by the coll object by the commands
// - BoxPartMin(x,y,z) - BoxPartMax(x,y,z) -
// Finally add the collision object by executing the command
// - AddCollisionObject -
//
// Bullets are described by the following properties :
// - BulletRadius - BulletRange - BulletFrame - LongShots -
// LongShots moves with a unlimited speed reaching the objects immediately
//
// The actor is described by :
// - FrontDistance - HeadRadius -
//
// The camera-frame and the bullet-frames move each time the move command
// is used in the main program.
// Execute the following commands prior to each move command :
//  - GetOldEyePos - GetOldBulletPos -
// The collisionTester needs this information to test for a possible collision
// in between the starting and the ending points of the Eye/bullet
//
// Test for collision with the following function calls :
// - if CollisionTester3DX1.Collision then ..
// - if CollisionTester3DX1.BulletCollision then ..
// On collision read the HitLinkNr and the properties of the collision object
//
// Destroy 3D collisionObjects by specifying :
//  - NextDestroyNr - IndexOf3DSeries -
// and the executing command DestroyCollisionObject
//
// Initialize the collisionTester with the command :
// - CollisionTester3DX1.ZeroSetIt -
// This must always be done when DXDraw is initialized
//
// To install the component:
// 1) place this unit and the dcr file in the same directory as DelphiX
// 2) In Delphi you must click on Component - Install Component
// 3) Select the colli3DX.pas file and choose the Samples package to install it
// 4) Rebuild the library
// 5) Look for a new icon with a bomb on the page named DelphiX
//
// Tutorial programs are available for down-load at
// http://users.cybercity.dk/~bbl6194/delphi3dx.htm
//
// Good Luck
// Henrik Fabricius
//
//
//****************************************************************************



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DXClass, DXDraws,
{$IfDef StandardDX}
  DirectDraw, Direct3D, Direct3DRM;
{$Else}
  DirectX;
{$EndIf}

Type
  Tshapes3D = (box3D, sphere3D, ellipsoid3D, cylinder3D, conus3D);
  Tmaterials3D = (solid3D, water3D, air3D);
  TOrientation3D = (symmetric_x, symmetric_y, symmetric_z);
  TFrames3D = Array of Array of IDirect3DRMFrame;

  TCollisionTester3DX = class(TComponent)
  private
    {private declarations}
    FDXDrawUsed       : TDXDraw;
    FFrameSeries      : TFrames3D;
    FNextAddMesh      : IDirect3DRMMesh;
    FBulletFrame      : IDirect3DRMFrame;
    FBoxPartMin       : TD3DVector;
    FBoxPartMax       : TD3DVector;
    FOldBulletPosition: TD3DVector;
    FOldEyePosition   : TD3DVector;

    FNrOfSeries        : integer;
    FSeriesIndex       : integer;
    FSeriesNr          : integer;
    FOrientation3D     : TOrientation3D;
    Fshape3D           : Tshapes3D;
    Fmaterial3D        : Tmaterials3D;
    FPercentLeftAtTop  : integer;
    Fbullet_hitLinknr  : integer;
    FIndexOf3DObject   : integer;
    FIndexOf3DElement  : integer;
    FNextDestroyNr     : integer;
    FNextAllOfMesh     : Boolean;
    FFrontDistance     : integer;
    FBulletRange       : integer;
    FBulletRadius      : integer;
    FHeadRadius        : integer;
    FFixed3DObject     : Boolean;
    FShootable         : Boolean;
    FLongShots         : Boolean;
    FPickable          : Boolean;
    FCheckAllCollObj   : Boolean;

    Fcoll_Nr_Objects  : Array of integer;
    FSeriesIndex_for_SeriesNr : Array of integer;

    FNrinFrameSeries  : Array of Array of integer;
    Fcoll_orientation : Array of Array of TOrientation3D;
    Fcoll_shape       : Array of Array of Tshapes3D;
    Fcoll_material    : Array of Array of Tmaterials3D;
    Fcoll_box_min     : Array of Array of TD3DVector;
    Fcoll_box_max     : Array of Array of TD3DVector;
    Fcoll_radius      : Array of Array of TD3DValue;
    Fcoll_frac_at_top : Array of Array of TD3DValue;
    Fcoll_shootable   : Array of Array of boolean;
    Fcoll_Pickable    : Array of Array of boolean;
    Fcoll_Fixed3D     : Array of Array of boolean;
    Fcoll_objectNr    : Array of Array of integer;

    procedure SetOrientation3D(Value : TOrientation3D);
    procedure SetShape3D(Value: TShapes3D);
    procedure SetMaterial3D(Value: Tmaterials3D);
    procedure SetPercentLeftatTop(Value: integer);
    procedure SetIndexOf3DObject(Value : integer);
    procedure SetIndexOf3DElement(Value : integer);
    procedure SetIndexOf3DSeries(Value : integer);
    procedure SetNextDestroyNr(Value : Integer);
    procedure SetBulletRadius(Value : Integer);
    procedure SetHeadRadius(Value : Integer);
    procedure SetFrontDistance(Value : Integer);
    procedure SetBulletRange(Value : Integer);
    function  add_space_for_one_more : boolean;
    procedure GetTheBox;
    procedure AddBox;
    procedure AddSphere;
    procedure AddCylinder;
    procedure AddConus;
    procedure AddEllipsoid;

    procedure MakeNewSeries;
    procedure Destroy_empty_series(SeriesNr : integer);
    function  GetSeriesNr(Nr : integer): integer;
    procedure remove_collision_object(seriesNr, Value : integer);
    function  CheckForSeriesIndex(indexnow : integer): boolean;
    procedure ListDataForCollObject;
    function  coll_test_box(coll_nr : byte;
                           old_attacker_position, attacker_position : TD3DVector;
                           bullet_radius : TD3DValue; longshot : boolean): boolean;
    function  coll_test_cylinder(coll_nr : byte;
                           old_attacker_position, attacker_position : TD3DVector;
                           bullet_radius : TD3DValue; longshot : boolean): boolean;
    function  coll_test_sphere(coll_nr : byte;
                           old_attacker_position,
                           attacker_position : TD3DVector;
                           bullet_radius : TD3Dvalue; longshot : boolean): boolean;
    function  coll_test_ellipsoid(coll_nr : byte;
                           old_attacker_position, attacker_position : TD3DVector;
                           bullet_radius : TD3DValue; longshot : boolean): boolean;
    function  coll_test_conus(coll_nr : byte;
                           old_attacker_position, attacker_position : TD3DVector;
                           bullet_radius : TD3DValue; longshot : boolean): boolean;

  protected

  public
    Constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    property DXDrawUsed       : TDXDraw write FDXDrawUsed stored false;
    property FrameSeries      : TFrames3D write FFrameSeries stored false;
    property NextAddMesh      : IDirect3DRMMesh write FNextAddMesh stored false;
    property BulletFrame      : IDirect3DRMFrame write FBulletFrame stored false;

    procedure ZeroSetIt;
    procedure BoxPartMin(xval, yval, zval: TD3DValue);
    procedure BoxPartMax(xval, yval, zval: TD3DValue);
    procedure GetOldBulletPos;
    procedure GetOldEyePos;

    function  HitLinkNr: integer;
    function  DestroyCollisionObject: boolean;
    procedure AddCollisionObject;
    function  Collision: boolean;
    function  Bulletcollision: boolean;
    function  BulletDead : boolean;


  published

    property BulletRadius     : Integer read FBulletRadius write SetBulletRadius
                                default 0;
    property BulletRange      : Integer read FbulletRange write SetBulletRange
                                Default 100;
    property CollisionCheckAll: Boolean read FCheckAllCollObj
                                write FCheckAllCollObj  Default true;
    property CollOrientation  : TOrientation3D read FOrientation3D
                                write SetOrientation3D default symmetric_y;
    property CollObjectType   : Tshapes3D read Fshape3D write SetShape3D
                                default box3D;
    property CollObjMaterial  : Tmaterials3D read Fmaterial3D write SetMaterial3D
                                default solid3D;
    property CoverWholeMesh   : boolean read FNextAllOfMesh
                                write FNextAllOfMesh default true;
    Property Fixed3DObject    : boolean read FFixed3DObject
                                write FFixed3DObject default true;
    property FrontDistance    : Integer read FFrontDistance
                                write SetFrontDistance default 0;
    property HeadRadius       : integer read FHeadRadius write SetHeadRadius
                                default 0;
    property IndexOf3DSeries  : integer read FSeriesIndex
                                write SetIndexOf3DSeries default 0;
    property IndexOf3DObject  : integer read FIndexOf3DObject
                                write SetIndexOf3DObject default 0;
    property IndexOf3DElement : integer read FIndexOf3DElement
                                write SetIndexOf3DElement default 0;
    property NextDestroyNr    : Integer read FNextDestroyNr
                                write SetNextDestroyNr default 0;
    Property PercentLeftAtTop : integer read FPercentLeftAtTop
                                write SetPercentLeftAtTop default 0;
    Property Pickable         : Boolean read FPickable write FPickable
                                default false;
    Property Shootable        : boolean read FShootable write FShootable
                                Default false;
    Property LongShots        : boolean read FLongShots write FLongShots
                                Default false;


  end; //end of Class



//Registering of the Component
Procedure Register;


implementation



procedure Register;
begin
  //Register the component together with the DelphiX components from Hori
  RegisterComponents('DelphiX', [TCollisionTester3DX]);
end; //end of Register


constructor TCollisionTester3DX.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  //The constructor always clears the storage it allocates for a new object
  //Hence there is no need to initialize fields except to nonzero or nonempty
  //values
  FDXDrawUsed := nil;
  FFrameSeries := nil;
  FNextAddMesh := nil;
  FBulletFrame := nil;

  FOrientation3D := symmetric_y;
  FShape3D := box3D;
  FMaterial3D := solid3D;
  FBulletRange := 100;
  FNrOfSeries := 0;
  setlength(FSeriesIndex_for_SeriesNr, 0);
  setlength(FColl_nr_objects, 0);
  setlength(FNrinFrameSeries, 0);
  setlength(Fcoll_shape, 0);
  setlength(Fcoll_box_min, 0);
  setlength(Fcoll_box_max, 0);
  setlength(Fcoll_radius, 0);
  setlength(Fcoll_frac_at_top, 0);
  setlength(Fcoll_objectnr, 0);
  setlength(Fcoll_shootable, 0);
  setlength(Fcoll_pickable, 0);
  setlength(Fcoll_orientation, 0);
  setlength(Fcoll_material, 0);
  setlength(Fcoll_Fixed3D, 0);

end; //end of creation







destructor TCollisionTester3DX.Destroy;
begin
  //destroy any embedded objects and free resources allocated by the objects
  FnrinFrameSeries := nil;
  Fcoll_shape := nil;
  Fcoll_box_min := nil;
  Fcoll_box_max := nil;
  Fcoll_radius := nil;
  Fcoll_frac_at_top := nil;
  Fcoll_objectnr := nil;
  Fcoll_shootable := nil;
  Fcoll_pickable := nil;
  Fcoll_orientation := nil;
  Fcoll_material := nil;
  Fcoll_Fixed3D := nil;
  FSeriesIndex_for_SeriesNr := nil;
  Fcoll_nr_objects := nil;

  inherited Destroy;
end; //end of Destroy




procedure TCollisionTester3DX.ZeroSetIt;
begin
  //initialises the dynamic arrays
  FnrinFrameSeries := nil;
  Fcoll_shape := nil;
  Fcoll_box_min := nil;
  Fcoll_box_max := nil;
  Fcoll_radius := nil;
  Fcoll_frac_at_top := nil;
  Fcoll_objectnr := nil;
  Fcoll_shootable := nil;
  Fcoll_pickable := nil;
  Fcoll_orientation := nil;
  Fcoll_material := nil;
  Fcoll_Fixed3D := nil;
  FSeriesIndex_for_SeriesNr := nil;
  Fcoll_nr_objects := nil;

  FDXDrawUsed := nil;
  FFrameSeries := nil;
  FNextAddMesh := nil;
  FBulletFrame := nil;

  FOrientation3D := symmetric_y;
  FShape3D := box3D;
  FMaterial3D := solid3D;
  FBulletRange := 100;
  FNrOfSeries := 0;
  setlength(FSeriesIndex_for_SeriesNr, 0);
  setlength(FColl_nr_objects, 0);
  setlength(FNrinFrameSeries, 0);
  setlength(Fcoll_shape, 0);
  setlength(Fcoll_box_min, 0);
  setlength(Fcoll_box_max, 0);
  setlength(Fcoll_radius, 0);
  setlength(Fcoll_frac_at_top, 0);
  setlength(Fcoll_objectnr, 0);
  setlength(Fcoll_shootable, 0);
  setlength(Fcoll_pickable, 0);
  setlength(Fcoll_orientation, 0);
  setlength(Fcoll_material, 0);
  setlength(Fcoll_Fixed3D, 0);

end;  //end of ZeroSetIt




function TcollisionTester3DX.HitLinkNr: integer;
begin
  result := Fbullet_hitlinknr;
end; //end of HitLinkNr



procedure TCollisionTester3DX.ListDataForCollObject;
var
  Nr : integer;
begin
  Nr := FBullet_HitLinkNr;

  CollObjectType   := Fcoll_shape[FSeriesNr, Nr];
  CollObjMaterial  := Fcoll_material[FSeriesNr, Nr];
  Fixed3DObject    := Fcoll_Fixed3D[FSeriesNr, Nr];
  CollOrientation  := Fcoll_orientation[FSeriesNr, Nr];
  IndexOf3DObject  := Fcoll_objectNr[FSeriesNr, Nr];
  IndexOf3DSeries  := FSeriesIndex;
  IndexOf3DElement := FNrinFrameSeries[FSeriesNr, Nr];
  Pickable         := Fcoll_pickable[FSeriesNr, Nr];
  Shootable        := Fcoll_shootable[FseriesNr, Nr];

end; //end of ListDataForCollObject




procedure TcollisionTester3DX.SetPercentLeftAtTop(Value : Integer);
begin
  //value can not be negative
  if (FPercentLeftAtTop <> Value) and (Value >= 0)
  then
    FPercentLeftAtTop := value;
end; //end of SetPercentLeftAtTop




procedure TcollisionTester3DX.SetOrientation3D(Value : TOrientation3D);
begin
  if FOrientation3D <> Value
  then
    FOrientation3D := Value;
end; //end setorientation3D


procedure TcollisionTester3DX.SetShape3D(Value : Tshapes3D);
begin
  if Fshape3D <> Value
  then
    Fshape3D := Value;
end; //end setshapes3D



procedure TcollisionTester3DX.SetMaterial3D(Value : Tmaterials3D);
begin
  if Fmaterial3D <> Value
  then
    Fmaterial3D := Value;
end; //end setshapes3D



procedure TCollisionTester3DX.SetIndexOf3DObject(Value : integer);
begin
  //Index can not be negative
  if (FIndexOf3DObject <> Value) and (Value >= 0)
  then
    FIndexOf3DObject := value;
end; //end setIndexOf3DObject


procedure TCollisionTester3DX.SetIndexOf3DElement(Value : integer);
begin
  //Index can not be negative
  if (FIndexOf3DElement <> Value) and (Value >= 0)
  then
    FIndexOf3DElement := value;
end; //end setIndexOf3DElement



procedure TCollisionTester3DX.SetIndexOf3DSeries(Value : integer);
begin
  //Index can not be negative
  if (FSeriesIndex <> Value) and (Value >= 0)
  then
    FSeriesIndex := value;
end; //end of SetIndexOf3DSeries




procedure TCollisionTester3DX.SetNextDestroyNr(Value : integer);
begin
  //Index can not be negative
  if (FNextDestroyNr <> Value) and (Value >= 0)
  then
    FNextDestroyNr := value;
end; //end of SetNextDestroyNr




procedure TCollisionTester3DX.SetBulletRadius(Value : Integer);
begin
  //Radius can not be negative
  if (FBulletRadius <> Value) and (Value >= 0)
  then
    FBulletRadius := value;
end; //end of SetBulletRadius



procedure TCollisionTester3DX.SetHeadRadius(Value : Integer);
begin
  //Radius can not be negative
  if (FHeadRadius <> Value) and (Value >= 0)
  then
    FHeadRadius := value;
end; //end of SetHeadRadius




procedure TCollisionTester3DX.SetFrontDistance(Value : Integer);
begin
  //FrontDistance can not be negative
  if (FFrontDistance <> Value) and (Value >= 0)
  then
    FFrontDistance := value;
end; //end of SetFrontDistance




procedure TCollisionTester3DX.SetBulletRange(Value : Integer);
begin
  //BulletRange can not be negative
  if (FBulletRange <> Value) and (Value >= 0)
  then
    FBulletRange := value;
end; //end of SetBulletRange




function TcollisionTester3DX.Add_Space_For_One_More: boolean;
var
  NewNr : integer;
begin
  //add space for one more element in the present series

  //length of Fcoll_nr_objects and FSeries_nIndex_for_SeriesNr are unchanged
  NewNr := Fcoll_nr_objects[FseriesNr] + 1;

  result := true;

  try
    SetLength(FNrinFrameSeries[FSeriesNr],  NewNr);
    SetLength(Fcoll_shape[FSeriesNr],       NewNr);
    SetLength(Fcoll_box_min[FSeriesNr],     NewNr);
    SetLength(Fcoll_box_max[FSeriesNr],     NewNr);
    SetLength(Fcoll_radius[FSeriesNr],      NewNr);
    SetLength(Fcoll_frac_at_top[FSeriesNr], NewNr);
    SetLength(Fcoll_objectnr[FSeriesNr],    NewNr);
    SetLength(Fcoll_shootable[FSeriesNr],   NewNr);
    SetLength(Fcoll_pickable[FSeriesNr],    NewNr);
    SetLength(Fcoll_orientation[FSeriesNr], NewNr);
    SetLength(Fcoll_material[FSeriesNr],    NewNr);
    SetLength(Fcoll_Fixed3D[FSeriesNr],     NewNr);

  except
    on EOutOfMemory do
    begin
      //There is not enough memory available. Free some memory
      dec(NewNr);

      copy(FNrinFrameSeries[FseriesNr],  0, NewNr);
      copy(Fcoll_shape[FseriesNr],       0, NewNr);
      copy(Fcoll_box_min[FSeriesNr],     0, NewNr);
      copy(Fcoll_box_max[FSeriesNr],     0, NewNr);
      copy(Fcoll_radius[FSeriesNr],      0, NewNr);
      copy(Fcoll_frac_at_top[FSeriesNr], 0, NewNr);
      copy(Fcoll_objectnr[FSeriesNr],    0, NewNr);
      copy(Fcoll_shootable[FSeriesNr],   0, NewNr);
      copy(Fcoll_pickable[FSeriesNr],    0, NewNr);
      copy(Fcoll_orientation[FSeriesNr], 0, NewNr);
      copy(Fcoll_material[FSeriesNr],    0, NewNr);
      copy(Fcoll_Fixed3D[FSeriesNr],     0, NewNr);

      result := false;
    end;
  end;

  //update count of objects in series
  Fcoll_nr_objects[FseriesNr] := NewNr;

end; //end of Add_Space_For_One_More




procedure TcollisionTester3DX.MakeNewSeries;
begin
  inc(FNrOfSeries);

  SetLength(FSeriesIndex_for_SeriesNr, FNrOfSeries);
  FSeriesIndex_for_SeriesNr[FNrOfSeries-1] := FSeriesIndex;

  SetLength(Fcoll_nr_objects, FNrOfSeries);
  Fcoll_nr_objects[FNrOfSeries-1] := 0;

  SetLength(FNrinFrameSeries,  FNrOfSeries);
  SetLength(Fcoll_shape,       FNrOfSeries);
  SetLength(Fcoll_box_min,     FNrOfSeries);
  SetLength(Fcoll_box_max,     FNrOfSeries);
  SetLength(Fcoll_radius,      FNrOfSeries);
  SetLength(Fcoll_frac_at_top, FNrOfSeries);
  SetLength(Fcoll_objectnr,    FNrOfSeries);
  SetLength(Fcoll_shootable,   FNrOfSeries);
  SetLength(Fcoll_pickable,    FNrOfSeries);
  SetLength(Fcoll_orientation, FNrOfSeries);
  SetLength(Fcoll_material,    FNrOfSeries);
  SetLength(Fcoll_Fixed3D,     FNrOfSeries);
end; //end of MakeNewSeries




procedure TcollisionTester3DX.Destroy_Empty_Series(SeriesNr : integer);
var
  i, j : integer;
begin
  if seriesNr < (FNrOfSeries - 1)
  then
  begin
    for i := SeriesNr to (FNrOfSeries - 2) do
    begin
      FSeriesIndex_for_SeriesNr[i] := FSeriesIndex_for_SeriesNr[i+1];

      SetLength(FNrinFrameSeries[i], Fcoll_Nr_objects[i+1]);
      for j := 0 to (Fcoll_Nr_objects[i+1] - 1) do
        FNrinFrameSeries[i, j] := FNrinFrameSeries[(i+1), j];

      SetLength(Fcoll_shape[i], Fcoll_Nr_objects[i+1]);
      for j := 0 to (Fcoll_Nr_objects[i+1] - 1) do
        Fcoll_shape[i, j] := Fcoll_shape[(i+1), j];

      SetLength(Fcoll_box_min[i], Fcoll_Nr_objects[i+1]);
      for j := 0 to (Fcoll_Nr_objects[i+1] - 1) do
        Fcoll_box_min[i, j] := Fcoll_box_min[(i+1), j];

      SetLength(Fcoll_box_max[i], Fcoll_Nr_objects[i+1]);
      for j := 0 to (Fcoll_Nr_objects[i+1] - 1) do
        Fcoll_box_max[i, j] := Fcoll_box_max[(i+1), j];

      SetLength(Fcoll_radius[i], Fcoll_Nr_objects[i+1]);
      for j := 0 to (Fcoll_Nr_objects[i+1] - 1) do
        Fcoll_radius[i, j] := Fcoll_radius[(i+1), j];

      SetLength(Fcoll_frac_at_top[i], Fcoll_Nr_objects[i+1]);
      for j := 0 to (Fcoll_Nr_objects[i+1] - 1) do
        Fcoll_frac_at_top[i, j] := Fcoll_frac_at_top[(i+1), j];

      SetLength(Fcoll_objectnr[i], Fcoll_Nr_objects[i+1]);
      for j := 0 to (Fcoll_Nr_objects[i+1] - 1) do
        Fcoll_objectNr[i, j] := Fcoll_objectNr[(i+1), j];

      SetLength(Fcoll_shootable[i], Fcoll_Nr_objects[i+1]);
      for j := 0 to (Fcoll_Nr_objects[i+1] - 1) do
        Fcoll_shootable[i, j] := Fcoll_shootable[(i+1), j];

      SetLength(Fcoll_pickable[i], Fcoll_Nr_objects[i+1]);
      for j := 0 to (Fcoll_Nr_objects[i+1] - 1) do
        Fcoll_pickable[i, j] := Fcoll_pickable[(i+1), j];

      SetLength(Fcoll_orientation[i], Fcoll_Nr_objects[i+1]);
      for j := 0 to (Fcoll_Nr_objects[i+1] - 1) do
        Fcoll_orientation[i, j] := Fcoll_orientation[(i+1), j];

      SetLength(Fcoll_material[i], Fcoll_Nr_objects[i+1]);
      for j := 0 to (Fcoll_Nr_objects[i+1] - 1) do
        Fcoll_material[i, j] := Fcoll_material[(i+1), j];

      SetLength(Fcoll_Fixed3D[i], Fcoll_Nr_objects[i+1]);
      for j := 0 to (Fcoll_Nr_objects[i+1] - 1) do
        Fcoll_Fixed3D[i, j] := Fcoll_Fixed3D[(i+1), j];

      Fcoll_nr_objects[i] := Fcoll_nr_objects[i+1];

    end;
  end;

  dec(FNrOfSeries);

  FSeriesIndex_For_SeriesNr := copy(FSeriesIndex_for_SeriesNr, 0, FNrOfSeries);
  Fcoll_Nr_Objects := copy(Fcoll_Nr_Objects, 0, FNrOfSeries);
  FNrinFrameSeries := copy(FNrinFrameSeries, 0, FNrOfSeries);
  Fcoll_Shape := copy(Fcoll_Shape, 0, FNrOfSeries);
  Fcoll_Box_Min := copy(Fcoll_Box_Min, 0, FNrOfSeries);
  Fcoll_Box_Max := copy(Fcoll_Box_Max, 0, FNrOfSeries);
  Fcoll_Radius := copy(Fcoll_Radius, 0, FNrOfSeries);
  Fcoll_Frac_At_Top := copy(Fcoll_Frac_At_Top, 0, FNrOfSeries);
  Fcoll_ObjectNr := copy(Fcoll_ObjectNr, 0, FNrOfSeries);
  Fcoll_Shootable := copy(Fcoll_Shootable, 0, FNrOfSeries);
  Fcoll_Pickable := copy(Fcoll_Pickable, 0, FNrOfSeries);
  Fcoll_orientation := copy(Fcoll_orientation, 0, FNrOfSeries);
  Fcoll_Material := copy(Fcoll_Material, 0, FNrOfSeries);
  Fcoll_Fixed3D := copy(Fcoll_Fixed3D, 0, FNrOfSeries);
end; //end of Destroy_Empty_Series







procedure TcollisionTester3DX.Remove_Collision_Object(SeriesNr, Value : integer);
var
  i : integer;
begin
  //Elements in the series which have a higher index than the one removed
  //gets a smaller index which is correct when the main program removes the object
  for i := 0 to (FColl_nr_objects[SeriesNr] - 1) do
  begin
    if FNrinFrameSeries[SeriesNr, i] >= value
    then
      dec(FNrinFrameSeries[SeriesNr, i]);
  end;

  for i := Value to (Fcoll_nr_objects[SeriesNr] - 2) do
  begin
    FNrinFrameSeries[SeriesNr, i]  := FNrinFrameSeries[SeriesNr, (i+1)];
    Fcoll_shape[SeriesNr, i]       := Fcoll_shape[SeriesNr, (i+1)];
    Fcoll_box_min[SeriesNr, i]     := Fcoll_box_min[SeriesNr, (i+1)];
    Fcoll_box_max[SeriesNr, i]     := Fcoll_box_max[SeriesNr, (i+1)];
    Fcoll_radius[seriesNr, i]      := Fcoll_radius[SeriesNr, (i+1)];
    Fcoll_frac_at_top[SeriesNr, i] := Fcoll_frac_at_top[SeriesNr, (i+1)];
    Fcoll_objectnr[SeriesNr, i]    := Fcoll_objectnr[SeriesNr, (i+1)];
    Fcoll_shootable[SeriesNr, i]   := Fcoll_shootable[SeriesNr, (i+1)];
    Fcoll_Pickable[SeriesNr, i]    := Fcoll_Pickable[SeriesNr, (i+1)];
    Fcoll_orientation[SeriesNr, i] := Fcoll_orientation[SeriesNr, (i+1)];
    Fcoll_material[SeriesNr, i]    := Fcoll_material[SeriesNr, (i+1)];
    Fcoll_Fixed3D[SeriesNr, i]     := Fcoll_Fixed3D[SeriesNr, (i+1)];
  end;

  dec(Fcoll_nr_objects[SeriesNr]);

  //remember to reduce the length of Fcoll_frame
  FNrinFrameSeries[SeriesNr]  := copy(FNrinFrameSeries[SeriesNr], 0,
                                 Fcoll_nr_objects[SeriesNr]);
  Fcoll_shape[SeriesNr]       := copy(Fcoll_shape[SeriesNr], 0,
                                 Fcoll_nr_objects[SeriesNr]);
  Fcoll_box_min[SeriesNr]     := copy(Fcoll_box_min[SeriesNr], 0,
                                 Fcoll_nr_objects[SeriesNr]);
  Fcoll_box_max[SeriesNr]     := copy(Fcoll_box_max[SeriesNr], 0,
                                 Fcoll_nr_objects[SeriesNr]);
  Fcoll_radius[SeriesNr]      := copy(Fcoll_radius[SeriesNr], 0,
                                 Fcoll_nr_objects[SeriesNr]);
  Fcoll_frac_at_top[SeriesNr] := copy(Fcoll_frac_at_top[SeriesNr], 0,
                                 Fcoll_nr_objects[SeriesNr]);
  Fcoll_objectnr[SeriesNr]    := copy(Fcoll_objectnr[SeriesNr], 0,
                                 Fcoll_nr_objects[SeriesNr]);
  Fcoll_shootable[SeriesNr]   := copy(Fcoll_shootable[SeriesNr], 0,
                                 Fcoll_nr_objects[SeriesNr]);
  Fcoll_pickable[SeriesNr]    := copy(Fcoll_pickable[SeriesNr], 0,
                                 Fcoll_nr_objects[SeriesNr]);
  Fcoll_material[SeriesNr]    := copy(Fcoll_material[SeriesNr], 0,
                                 Fcoll_nr_objects[FSeriesNr]);
  Fcoll_orientation[SeriesNr] := copy(Fcoll_orientation[SeriesNr], 0,
                                 Fcoll_nr_objects[FSeriesNr]);
  Fcoll_fixed3D[SeriesNr]     := copy(Fcoll_fixed3D[SeriesNr], 0,
                                 Fcoll_nr_objects[SeriesNr]);

end; //end of Remove_Collision_Object







procedure TCollisionTester3DX.GetTheBox;
var
  box: TD3DRMBOX;
begin
  if FNextAllOfMesh
  then
  begin
    FNextAddMesh.GetBox(box);
    FColl_box_min[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)] := box.min;
    FColl_box_max[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)] := box.max;
  end
  else
  begin
    FColl_box_min[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)] := FBoxPartMin;
    FColl_box_max[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)] := FBoxPartMax;
  end;

end;  //end of GetTheBox



procedure TCollisionTester3DX.BoxPartMin(xval, yval, zval : TD3DValue);
begin
  FBoxPartMin.x := xval;
  FBoxPartMin.y := yval;
  FBoxPartMin.z := zval;
end; //end of BoxPartMin




procedure TCollisionTester3DX.BoxPartMax(xval, yval, zval : TD3DValue);
begin
  FBoxPartMax.x := xval;
  FBoxPartMax.y := yval;
  FBoxPartMax.z := zval;
end; //end of BoxPartMax





procedure TCollisionTester3DX.AddBox;
begin
  if add_space_for_one_more
  then
  begin
    GetTheBox;

    Fcoll_objectnr[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]    := FIndexOf3DObject;
    Fcoll_shape[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]       := box3D;
    FNrinFrameSeries[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]  := FIndexof3Delement;
    Fcoll_radius[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]      := 0; //not used
    Fcoll_frac_at_top[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)] := 0; //not used
    Fcoll_material[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]    := Fmaterial3D;
    Fcoll_orientation[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)] := Forientation3D;
    Fcoll_shootable[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] -1)]    := Fshootable;
    Fcoll_Pickable[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]    := Fpickable;
    Fcoll_fixed3D[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]     := FFixed3DObject;
  end;
end; //end of AddBox




procedure TCollisionTester3DX.AddSphere;
begin
  if add_space_for_one_more
  then
  begin
    GetTheBox;
    Fcoll_objectnr[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]    := FIndexOf3DObject;
    Fcoll_shape[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]       := sphere3D;
    FNrinFrameSeries[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]  := FIndexof3Delement;
    Fcoll_radius[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]      :=
     (FColl_box_max[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].x
    - FColl_box_min[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].x
    + FColl_box_max[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].y
    - FColl_box_min[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].y
    + FColl_box_max[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].z
    - FColl_box_min[FSeriesNr, (Fcoll_Nr_objects[FseriesNr] - 1)].z)/2/3;
    Fcoll_frac_at_top[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)] := 0; //not used
    Fcoll_orientation[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)] := Forientation3D;
    Fcoll_material[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]    := Fmaterial3D;
    Fcoll_shootable[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]   := Fshootable;
    Fcoll_Pickable[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]    := Fpickable;
    Fcoll_fixed3D[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]     := FFixed3DObject;
  end;

end; //end of AddSphere





procedure TCollisionTester3DX.Addcylinder;
begin
  //the sphere cowers whole of the 3D-object
  if add_space_for_one_more
  then
  begin
    GetTheBox;

    Fcoll_objectnr[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]    := FIndexOf3DObject;
    Fcoll_shape[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]       := cylinder3D;
    FNrinFrameSeries[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]  := FIndexof3Delement;
    case Forientation3D of
    symmetric_x : Fcoll_radius[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]      :=
     (FColl_box_max[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].y
    - FColl_box_min[FSeriesNr, (Fcoll_Nr_objects[FseriesNr] - 1)].y
    + FColl_box_max[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].z
    - FColl_box_min[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].z)/2/2;
    symmetric_y : Fcoll_radius[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]      :=
     (FColl_box_max[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].x
    - FColl_box_min[FSeriesNr, (Fcoll_Nr_objects[FseriesNr] - 1)].x
    + FColl_box_max[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].z
    - FColl_box_min[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].z)/2/2;
    symmetric_z : Fcoll_radius[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]      :=
     (FColl_box_max[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].x
    - FColl_box_min[FSeriesNr, (Fcoll_Nr_objects[FseriesNr] - 1)].x
    + FColl_box_max[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].y
    - FColl_box_min[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].y)/2/2;
    end;

    Fcoll_frac_at_top[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)] := 0; //not used
    Fcoll_orientation[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)] := Forientation3D;
    Fcoll_material[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]    := Fmaterial3D;
    Fcoll_shootable[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]   := Fshootable;
    Fcoll_Pickable[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]    := Fpickable;
    Fcoll_fixed3D[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]     := FFixed3DObject;
  end;
end; //end of Addcylinder




procedure TCollisionTester3DX.Addconus;
begin
  //the conus cowers whole of or part of the 3D-object
  //fraction_left_at_top = 0 if sharp tip
  if add_space_for_one_more
  then
  begin
    GettheBox;

    Fcoll_objectnr[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]    := FIndexOf3DObject;
    Fcoll_shape[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]       := conus3D;
    FNrinFrameSeries[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]  := FIndexof3Delement;
    Fcoll_radius[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]      :=
     (FColl_box_max[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].x
    - FColl_box_min[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].x
    + FColl_box_max[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].z
    - FColl_box_min[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)].z)/2/2;
    Fcoll_frac_at_top[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)] := FPercentLeftAtTop/100;
    Fcoll_orientation[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)] := Forientation3D;
    Fcoll_material[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]    := Fmaterial3D;
    Fcoll_shootable[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] -1)]    := Fshootable;
    Fcoll_Pickable[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]    := Fpickable;
    Fcoll_fixed3D[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]     := FFixed3DObject;
  end;
end; //end of Addconus




procedure TCollisionTester3DX.AddEllipsoid;
begin
  if add_space_for_one_more
  then
  begin
    GetTheBox;
    Fcoll_objectnr[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]      := FIndexOf3DObject;
    Fcoll_shape[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]         := Ellipsoid3D;
    FNrinFrameSeries[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]  := FIndexof3Delement;
    Fcoll_radius[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]        := 0; //not used
    Fcoll_frac_at_top[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]   := 0; //not used
    Fcoll_orientation[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)] := Forientation3D;
    Fcoll_material[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]      := Fmaterial3D;
    Fcoll_shootable[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]     := Fshootable;
    Fcoll_Pickable[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]      := Fpickable;
    Fcoll_fixed3D[FSeriesNr, (Fcoll_Nr_objects[FSeriesNr] - 1)]       := FFixed3DObject;
  end;
end; //end of AddEllipsoid







function TcollisionTester3DX.GetSeriesNr(Nr : integer): integer;
var
  NrNow, i : integer;
begin

  if FNrOfSeries = 0
  then
    NrNow := 0
  else
  begin
    NrNow := -1;
    for i := 0 to (FNrOfSeries - 1) do
    begin
      if Nr = FSeriesIndex_for_SeriesNr[i]
      then
        NrNow := i;
    end;

    if NrNow = -1
    then
      NrNow := FNrOfSeries; //make new series
  end;

  if NrNow = FNrOfSeries
  then
    MakeNewSeries;


  result := NrNow;


end; //end of GetSeriesNr





function TcollisionTester3DX.CheckForSeriesIndex(indexnow : integer): boolean;
var
  i : integer;
begin

  if FNrOfSeries = 0
  then
    result := false
  else
  begin
    FSeriesNr := -1;
    for i := 0 to (FNrOfSeries - 1) do
    begin
      if indexnow = FSeriesIndex_for_SeriesNr[i]
      then
        FSeriesNr := i;
    end;

    result := (FSeriesNr <> -1);
  end;

end; //end of CheckForSeriesIndex





procedure TcollisionTester3DX.AddCollisionObject;
begin
  FSeriesNr := GetSeriesNr(FSeriesIndex);

  case Fshape3D of
    box3D      : AddBox;
    sphere3D   : AddSphere;
    cylinder3D : AddCylinder;
    ellipsoid3D: AddEllipsoid;
    Conus3D    : AddConus;
  end;

end; //end of AddCollisionObject





function TCollisionTester3DX.DestroyCollisionObject: boolean;
var
  test_nr : integer;
begin
  //remove all collision objects connected with the 3D-object
  //with the index FnextDestroyNr

  //Check whether series index exists
  if CheckForSeriesIndex(FSeriesIndex)
  then
  begin
    //FSeriesNr was found
    test_nr := 0;

    while (test_nr <= (Fcoll_nr_objects[FSeriesNr] - 1)) do
    begin
      if Fcoll_objectnr[FSeriesNr, test_nr] = FnextDestroyNr
      then
        remove_collision_object(FSeriesNr, FnextDestroyNr)
      else
        inc(test_nr);
    end; //end of while loop

    //now we have to decrement all Fcoll_objectnr values larger than object_nr
    //because the main program does a similar decrementation when the 3D-object
    //is removed

    if Fcoll_nr_objects[FSeriesNr] > 0
    then
    begin
      //the series is not empty
      for test_nr := 0 to (Fcoll_nr_objects[FSeriesNr] - 1) do
      begin
        if Fcoll_objectnr[FSeriesNr, test_nr] > FNextDestroyNr
        then
          dec(Fcoll_objectnr[FSeriesNr, test_nr]);
      end;
    end
    else
      destroy_empty_Series(FSeriesNr);


    result := true; //collision object was destroyed

  end //end of CheckForSeriesIndex...
  else
    result := false; //unable to destroy

end; //end of DestroyCollisionObject






function TcollisionTester3DX.coll_test_sphere(coll_nr : byte;
                              old_attacker_position, attacker_position : TD3DVector;
                              bullet_radius : TD3DValue; longshot : boolean): boolean;
var
  new_eye, old_eye : TD3DVector;
  dstep, step, center : TD3DVector;
  radius, d0, d1, d2, rod, rod2, t1, t2 : TD3DValue;
begin
  result := false;
  
  //Get the coordinates of the old eye_position in the actual coll frame
  FFrameSeries[FSeriesIndex, FNrinFrameSeries[FSeriesNr, coll_nr]].InverseTransform
                 (old_eye, old_attacker_position);

  //Get the coordinates of the eye_position in the actual coll frame
  FFrameSeries[FSeriesIndex, FNrinFrameSeries[FSeriesNr, coll_nr]].InverseTransform
                 (new_eye, attacker_position);

  center.x := (Fcoll_box_max[FSeriesNr, coll_nr].x
             + Fcoll_box_min[FSeriesNr, coll_nr].x)/2;
  center.y := (Fcoll_box_max[FSeriesNr, coll_nr].y
             + Fcoll_box_min[FSeriesNr, coll_nr].y)/2;
  center.z := (Fcoll_box_max[FSeriesNr, coll_nr].z
             + Fcoll_box_min[FSeriesNr, coll_nr].z)/2;

  //radius of sphere enlarged with the radius of the bullet
  //to cover the space where a collision may occure
  radius := Fcoll_radius[FSeriesNr, coll_nr] + bullet_radius;

  //eye to center distance
  dstep.x := old_eye.x - center.x;
  dstep.y := old_eye.y - center.y;
  dstep.z := old_eye.z - center.z;

  //step in eye position
  step.x := new_eye.x - old_eye.x;
  step.y := new_eye.y - old_eye.y;
  step.z := new_eye.z - old_eye.z;

  //collision is only possible when something moves
  if (abs(step.x) < 1e-3) and (abs(step.y) < 1e-3) and (abs(step.z) < 1e-3)
  then
  begin
    result := false;
    exit;
  end;


  //factors
  d0 := sqr(dstep.x) + sqr(dstep.y) + sqr(dstep.z) - sqr(radius);
  d1 := 2 * (step.x * dstep.x + step.y * dstep.y + step.z * dstep.z);
  d2 := sqr(step.x) + sqr(step.y) + sqr(step.z);

  //solving an equation of the second degree
  rod := sqr(d1) - 4 * d2 * d0;

  //d2 is never zero
  if rod > 0
  then
  begin
    rod2 := sqrt(rod);
    t1 := (-d1 - rod2)/2/d2;
    t2 := (-d1 + rod2)/2/d2;

    // if longshot then look into all future
    if longshot
    then
      result := (t1 >= 0) or (t2 >= 0)
    else
    begin
      //collision in between the starting and the ending point if
      result := ((t1 >= 0) and (t1 <= 1))
             or ((t2 >= 0) and (t2 <= 1));
    end;
  end;

end; //end of coll_test_sphere




function TcollisionTester3DX.coll_test_ellipsoid(coll_nr : byte;
                              old_attacker_position, attacker_position : TD3DVector;
                              bullet_radius : TD3DValue; longshot : boolean): boolean;
var
  new_eye, old_eye : TD3DVector;
  dstep, step, center : TD3DVector;
  d0, d1, d2, rod, rod2, t1, t2, a, b, c : TD3DValue;
begin
  result := false;

  //Get the coordinates of the old eye_position in the actual coll frame
  FFrameSeries[FSeriesIndex, FNrinFrameSeries[FSeriesNr, coll_nr]].InverseTransform
                 (old_eye, old_attacker_position);

  //Get the coordinates of the eye_position in the actual coll frame
  FFrameSeries[FSeriesIndex, FNrinFrameSeries[FSeriesNr, coll_nr]].InverseTransform
                 (new_eye, attacker_position);

  center.x := (Fcoll_box_max[FSeriesNr, coll_nr].x
             + Fcoll_box_min[FSeriesNr, coll_nr].x)/2;
  center.y := (Fcoll_box_max[FSeriesNr, coll_nr].y
             + Fcoll_box_min[FSeriesNr, coll_nr].y)/2;
  center.z := (Fcoll_box_max[FSeriesNr, coll_nr].z
             + Fcoll_box_min[FSeriesNr, coll_nr].z)/2;

  //x, y and z radius of ellipsoid enlarged with the radius of the bullet
  //to cover the space where a collision may occure
  a := (Fcoll_box_max[FSeriesNr, coll_nr].x
             - Fcoll_box_min[FSeriesNr, coll_nr].x)/2 + bullet_radius;
  b := (Fcoll_box_max[FSeriesNr, coll_nr].y
             - Fcoll_box_min[FSeriesNr, coll_nr].y)/2 + bullet_radius;
  c := (Fcoll_box_max[FSeriesNr, coll_nr].z
             - Fcoll_box_min[FSeriesNr, coll_nr].z)/2 + bullet_radius;

  //eye to center distance
  dstep.x := old_eye.x - center.x;
  dstep.y := old_eye.y - center.y;
  dstep.z := old_eye.z - center.z;

  //step in eye position
  step.x := new_eye.x - old_eye.x;
  step.y := new_eye.y - old_eye.y;
  step.z := new_eye.z - old_eye.z;

  //collision is only possible when something moves
  if (abs(step.x) < 1e-3) and (abs(step.y) < 1e-3) and (abs(step.z) < 1e-3)
  then
  begin
    result := false;
    exit;
  end;


  //factors
  d0 := sqr(b * c * dstep.x) + sqr(a * c * dstep.y) + sqr(a * b * dstep.z)
        - sqr(a * b * c);
  d1 := 2 * (sqr(b * c) * step.x * dstep.x + sqr(a * c) * step.y * dstep.y
        + sqr(a * b) * step.z * dstep.z);
  d2 := sqr(b * c * step.x) + sqr(a * c * step.y) + sqr(a * b * step.z);

  //solving an equation of the second degree
  rod := sqr(d1) - 4 * d2 * d0;

  //d2 is never zero
  if rod > 0
  then
  begin
    rod2 := sqrt(rod);
    t1 := (-d1 - rod2)/2/d2;
    t2 := (-d1 + rod2)/2/d2;

    // if longshot then look into all future
    if longshot
    then
      result := (t1 >= 0) or (t2 >= 0)
    else
    begin
      //collision in between the starting and the ending point if
      result := ((t1 >= 0) and (t1 <= 1))
             or ((t2 >= 0) and (t2 <= 1));
    end;
  end;

end; //end of coll_test_ellipsoid





function TcollisionTester3DX.coll_test_cylinder(coll_nr : byte;
                              old_attacker_position, attacker_position : TD3DVector;
                              bullet_radius : TD3DValue; longshot : boolean): boolean;
var
  distance : TD3DValue;
  new_eye, old_eye : TD3DVector;
  dstep, step, center : TD3DVector;
  radius, d0, d1, d2, rod, rod2, t1, t2, xc1, yc1, zc1, xc2, yc2, zc2 : TD3DValue;
begin
  result := false;


  //Get the coordinates of the old eye_position in the actual coll frame
  FFrameSeries[FSeriesIndex, FNrinFrameSeries[FSeriesNr, coll_nr]].InverseTransform
                 (old_eye, old_attacker_position);

  //Get the coordinates of the eye_position in the actual coll frame
  FFrameSeries[FSeriesIndex, FNrinFrameSeries[FSeriesNr, coll_nr]].InverseTransform
                 (new_eye, attacker_position);

  center.x := (Fcoll_box_max[FSeriesNr, coll_nr].x
             + Fcoll_box_min[FSeriesNr, coll_nr].x)/2;
  center.y := (Fcoll_box_max[FSeriesNr, coll_nr].y
             + Fcoll_box_min[FSeriesNr, coll_nr].y)/2;
  center.z := (Fcoll_box_max[FSeriesNr, coll_nr].z
             + Fcoll_box_min[FSeriesNr, coll_nr].z)/2;

  //radius of sphere enlarged with the radius of the bullet
  //to cover the space where a collision may occure
  radius := Fcoll_radius[FSeriesNr, coll_nr] + bullet_radius;

  //eye to center distance
  dstep.x := old_eye.x - center.x;
  dstep.y := old_eye.y - center.y;
  dstep.z := old_eye.z - center.z;

  //step in eye position
  step.x := new_eye.x - old_eye.x;
  step.y := new_eye.y - old_eye.y;
  step.z := new_eye.z - old_eye.z;

  //collision is only possible when something moves
  if (abs(step.x) < 1e-3) and (abs(step.y) < 1e-3) and (abs(step.z) < 1e-3)
  then
  begin
    result := false;
    exit;
  end;

  d0 := 1; //just to avoid warnings
  d1 := 1;
  d2 := 1;


  //The cylinder is alined parallel to the x, y or z axis
  case FOrientation3D of
  symmetric_x :
  begin
    //factors
    d0 := sqr(dstep.y) + sqr(dstep.z) - sqr(radius);
    d1 := 2 * (step.y * dstep.y + step.z * dstep.z);
    d2 := sqr(step.y) + sqr(step.z);
  end;
  symmetric_y :
  begin
    //factors
    d0 := sqr(dstep.x) + sqr(dstep.z) - sqr(radius);
    d1 := 2 * (step.x * dstep.x + step.z * dstep.z);
    d2 := sqr(step.x) + sqr(step.z);
  end;
  symmetric_z :
  begin
    //factors
    d0 := sqr(dstep.x) + sqr(dstep.y) - sqr(radius);
    d1 := 2 * (step.x * dstep.x + step.y * dstep.y);
    d2 := sqr(step.x) + sqr(step.y);
  end;
  end; //end of case FOrientation3D of


  //solving an equation of the second degree
  rod := sqr(d1) - 4 * d2 * d0;

  //d2 is never zero
  if rod >= 0
  then
  begin
    //only then is the collision possible
    rod2 := sqrt(rod);
    t1 := (-d1 - rod2)/2/d2;
    t2 := (-d1 + rod2)/2/d2;

    // if longshot then look into all future
    if longshot
    then
      result := (t1 >= 0) or (t2 >= 0)
    else
    begin
      //collision in between the starting and the ending point if
      result := ((t1 >= 0) and (t1 <= 1))
             or ((t2 >= 0) and (t2 <= 1));
    end;

    // however the collision also affords that we are within the length of the cylinder
    if result then
    begin
      case FOrientation3D of
      symmetric_x :
      begin
        xc1 := old_eye.x + t1 * step.x;
        xc2 := old_eye.x + t2 * step.x;


        if longshot
        then
          result :=
           (result and (t1 >= 0) and
           (xc1 >= (Fcoll_box_min[FseriesNr, coll_nr].x - bullet_radius)) and
           (xc1 <= (Fcoll_box_max[FseriesNr, coll_nr].x + bullet_radius)) )
          or
           (result and (t2 >= 0) and
           (xc2 >= (Fcoll_box_min[FseriesNr, coll_nr].x - bullet_radius)) and
           (xc2 <= (Fcoll_box_max[FseriesNr, coll_nr].x + bullet_radius)) )
        else
          result :=
           (result and (t1 >= 0) and (t1 <= 1) and
           (xc1 >= (Fcoll_box_min[FseriesNr, coll_nr].x - bullet_radius)) and
           (xc1 <= (Fcoll_box_max[FseriesNr, coll_nr].x + bullet_radius)) )
         or
           (result and (t2 >= 0) and (t2 <= 1) and
           (xc2 >= (Fcoll_box_min[FseriesNr, coll_nr].x - bullet_radius)) and
           (xc2 <= (Fcoll_box_max[FseriesNr, coll_nr].x + bullet_radius)) );

         //if collision detected then exit now
         if result then exit;

      end;
      symmetric_y :
      begin
        yc1 := old_eye.y + t1 * step.y;
        yc2 := old_eye.y + t2 * step.y;


        if longshot
        then
          result :=
           (result and (t1 >= 0) and
           (yc1 >= (Fcoll_box_min[FseriesNr, coll_nr].y - bullet_radius)) and
           (yc1 <= (Fcoll_box_max[FseriesNr, coll_nr].y + bullet_radius)) )
          or
           (result and (t2 >= 0) and
           (yc2 >= (Fcoll_box_min[FseriesNr, coll_nr].y - bullet_radius)) and
           (yc2 <= (Fcoll_box_max[FseriesNr, coll_nr].y + bullet_radius)) )
        else
          result :=
           (result and (t1 >= 0) and (t1 <= 1) and
           (yc1 >= (Fcoll_box_min[FseriesNr, coll_nr].y - bullet_radius)) and
           (yc1 <= (Fcoll_box_max[FseriesNr, coll_nr].y + bullet_radius)) )
         or
           (result and (t2 >= 0) and (t2 <= 1) and
           (yc2 >= (Fcoll_box_min[FseriesNr, coll_nr].y - bullet_radius)) and
           (yc2 <= (Fcoll_box_max[FseriesNr, coll_nr].y + bullet_radius)) );

         //if collision detected then exit now
         if result then exit;


      end;
      symmetric_z :
      begin
        zc1 := old_eye.z + t1 * step.z;
        zc2 := old_eye.z + t2 * step.z;


        if longshot
        then
          result :=
           (result and (t1 >= 0) and
           (zc1 >= (Fcoll_box_min[FseriesNr, coll_nr].z - bullet_radius)) and
           (zc1 <= (Fcoll_box_max[FseriesNr, coll_nr].z + bullet_radius)) )
          or
           (result and (t2 >= 0) and
           (zc2 >= (Fcoll_box_min[FseriesNr, coll_nr].z - bullet_radius)) and
           (zc2 <= (Fcoll_box_max[FseriesNr, coll_nr].z + bullet_radius)) )
        else
          result :=
           (result and (t1 >= 0) and (t1 <= 1) and
           (zc1 >= (Fcoll_box_min[FseriesNr, coll_nr].z - bullet_radius)) and
           (zc1 <= (Fcoll_box_max[FseriesNr, coll_nr].z + bullet_radius)) )
         or
           (result and (t2 >= 0) and (t2 <= 1) and
           (zc2 >= (Fcoll_box_min[FseriesNr, coll_nr].z - bullet_radius)) and
           (zc2 <= (Fcoll_box_max[FseriesNr, coll_nr].z + bullet_radius)) );

         //if collision detected then exit now
         if result then exit;
      end;

      end; //end of case
    end;

    //exit if a collision occured
    if result then exit;
  end;


  //the collision may also occur with the end surfaces of the cylinder
  case FOrientation3D of
  symmetric_x :
  begin
    if step.x > 1e-6
    then
    begin
      //1st end surface
      t1 := (Fcoll_box_min[FseriesNr, coll_Nr].x - old_eye.x)/step.x;
      yc1 := old_eye.y + t1 * step.y;
      zc1 := old_eye.z + t1 * step.z;

      distance := sqrt( sqr(yc1 - center.y) + sqr(zc1 - center.z) );

      result := (distance < radius) and (t1 >= 0);
      if not longshot then result := result and (t1 <= 1);
      if result then exit;

      //2nd end surface
      t1 := (Fcoll_box_max[FseriesNr, coll_Nr].x - old_eye.x)/step.x;
      yc1 := old_eye.y + t1 * step.y;
      zc1 := old_eye.z + t1 * step.z;

      distance := sqrt( sqr(yc1 - center.y) + sqr(zc1 - center.z) );

      result := (distance < radius) and (t1 >= 0);
      if not longshot then result := result and (t1 <= 1);
      if result then exit;
    end;
  end;
  symmetric_y :
  begin
    if step.y > 1e-6
    then
    begin
      //1st end surface
      t1 := (Fcoll_box_min[FseriesNr, coll_Nr].y - old_eye.y)/step.y;
      xc1 := old_eye.x + t1 * step.x;
      zc1 := old_eye.z + t1 * step.z;

      distance := sqrt( sqr(xc1 - center.x) + sqr(zc1 - center.z) );

      result := (distance < radius) and (t1 >= 0);
      if not longshot then result := result and (t1 <= 1);
      if result then exit;

      //2nd end surface
      t1 := (Fcoll_box_max[FseriesNr, coll_Nr].y - old_eye.y)/step.y;
      xc1 := old_eye.x + t1 * step.x;
      zc1 := old_eye.z + t1 * step.z;

      distance := sqrt( sqr(xc1 - center.x) + sqr(zc1 - center.z) );

      result := (distance < radius) and (t1 >= 0);
      if not longshot then result := result and (t1 <= 1);
      if result then exit;
    end;

  end;
  symmetric_z :
  begin
    if step.z > 1e-6
    then
    begin
      //1st end surface
      t1 := (Fcoll_box_min[FseriesNr, coll_Nr].z - old_eye.z)/step.z;
      xc1 := old_eye.x + t1 * step.x;
      yc1 := old_eye.y + t1 * step.y;

      distance := sqrt( sqr(xc1 - center.x) + sqr(yc1 - center.y) );

      result := (distance < radius) and (t1 >= 0);
      if not longshot then result := result and (t1 <= 1);
      if result then exit;

      //2nd end surface
      t1 := (Fcoll_box_max[FseriesNr, coll_Nr].z - old_eye.z)/step.z;
      xc1 := old_eye.x + t1 * step.x;
      yc1 := old_eye.y + t1 * step.y;

      distance := sqrt( sqr(xc1 - center.x) + sqr(yc1 - center.y) );

      result := (distance < radius) and (t1 >= 0);
      if not longshot then result := result and (t1 <= 1);
      if result then exit;
    end;

  end;


  end; //end of case

end; //end of coll_test_cylinder





function TcollisionTester3DX.coll_test_conus(coll_nr : byte;
                              old_attacker_position, attacker_position : TD3DVector;
                              bullet_radius : TD3DValue; longshot : boolean): boolean;
var
  height3D, width3D : TD3DValue;
  distance : TD3DValue;
  new_eye, old_eye : TD3DVector;
  dstep, step, center : TD3DVector;
  radius, d0, d1, d2, rod, rod2, t1, t2, xc1, yc1, zc1, xc2, yc2, zc2 : TD3DValue;
  xc, yc, zc, conusfact : TD3DValue;
begin
  result := false;

  //Get the coordinates of the old eye_position in the actual coll frame
  FFrameSeries[FSeriesIndex, FNrinFrameSeries[FSeriesNr, coll_nr]].InverseTransform
                 (old_eye, old_attacker_position);

  //Get the coordinates of the eye_position in the actual coll frame
  FFrameSeries[FSeriesIndex, FNrinFrameSeries[FSeriesNr, coll_nr]].InverseTransform
                 (new_eye, attacker_position);

  center.x := (Fcoll_box_max[FSeriesNr, coll_nr].x
             + Fcoll_box_min[FSeriesNr, coll_nr].x)/2;
  center.y := (Fcoll_box_max[FSeriesNr, coll_nr].y
             + Fcoll_box_min[FSeriesNr, coll_nr].y)/2;
  center.z := (Fcoll_box_max[FSeriesNr, coll_nr].z
             + Fcoll_box_min[FSeriesNr, coll_nr].z)/2;


  //step in eye position
  step.x := new_eye.x - old_eye.x;
  step.y := new_eye.y - old_eye.y;
  step.z := new_eye.z - old_eye.z;

  //collision is only possible when something moves
  if (abs(step.x) < 1e-3) and (abs(step.y) < 1e-3) and (abs(step.z) < 1e-3)
  then
  begin
    result := false;
    exit;
  end;

  //if FPercentLeftatTop is positiv then the conus is largest at the bottom
  xc := center.x;
  yc := center.y;
  zc := center.z;

  width3D := 10;  //just to avoid warnings
  height3D := 10;

  case FOrientation3D of
  symmetric_x :
  begin
    height3D := Fcoll_box_max[FSeriesNr, coll_nr].x
              - Fcoll_box_min[FSeriesNr, coll_nr].x;
    width3D := (Fcoll_box_max[FSeriesNr, coll_Nr].y
              - Fcoll_box_min[FSeriesNr, coll_nr].y
              + Fcoll_box_max[FSeriesNr, coll_nr].z
              - Fcoll_box_min[FSeriesNr, coll_nr].z)/2;

    //the top of the conus is maller than the bottom of it
    if FPercentLeftatTop >= 0
    then
      xc := center.x - height3D/2 + 100 * height3D/(100 - FpercentLeftatTop)
    else
      xc := center.x + height3D/2 - 100 * height3D/(100 + FpercentLeftatTop);
  end; //end of symmetric_x
  symmetric_y :
  begin
    height3D := Fcoll_box_max[FSeriesNr, coll_nr].y
              - Fcoll_box_min[FSeriesNr, coll_nr].y;
    width3D := (Fcoll_box_max[FSeriesNr, coll_Nr].x
              - Fcoll_box_min[FSeriesNr, coll_nr].x
              + Fcoll_box_max[FSeriesNr, coll_nr].z
              - Fcoll_box_min[FSeriesNr, coll_nr].z)/2;

    //the top of the conus is maller than the bottom of it
    if FPercentLeftatTop >= 0
    then
      yc := center.y - height3D/2 + 100 * height3D/(100 - FpercentLeftatTop)
    else
      yc := center.y + height3D/2 - 100 * height3D/(100 + FpercentLeftatTop);
  end; //end of symmetric_y
  symmetric_z :
  begin
    height3D := Fcoll_box_max[FSeriesNr, coll_nr].z
              - Fcoll_box_min[FSeriesNr, coll_nr].z;
    width3D := (Fcoll_box_max[FSeriesNr, coll_Nr].x
              - Fcoll_box_min[FSeriesNr, coll_nr].x
              + Fcoll_box_max[FSeriesNr, coll_nr].y
              - Fcoll_box_min[FSeriesNr, coll_nr].y)/2;

    //the top of the conus is maller than the bottom of it
    if FPercentLeftatTop >= 0
    then
      zc := center.z - height3D/2 + 100 * height3D/(100 - FpercentLeftatTop)
    else
      zc := center.z + height3D/2 - 100 * height3D/(100 + FpercentLeftatTop);
  end; //end of symmetric_z
  end; //end of case

  //mathematically we need the conusfact describing the ratio between the radius of
  //the large end of the conus and the height of the conus
  if width3D > 0
  then
    conusfact := height3D/2/width3D
  else
    conusfact := 1e9;

  //eye to the fictive tip of the conus distance
  dstep.x := old_eye.x - xc;
  dstep.y := old_eye.y - yc;
  dstep.z := old_eye.z - zc;

  d0 := 1; //just to avoid warnings
  d1 := 1;
  d2 := 1;

  //The conus is aligned parallel to the x, y or z axis
  case FOrientation3D of
  symmetric_x :
  begin
    //factors
    d0 := sqr(dstep.y) + sqr(dstep.z) - sqr(dstep.x * conusfact);
    d1 := 2 * (step.y * dstep.y + step.z * dstep.z
          - sqr(conusfact) * step.x * dstep.x);
    d2 := sqr(step.y) + sqr(step.z) - sqr(conusfact * step.x);
  end;
  symmetric_y :
  begin
    //factors
    d0 := sqr(dstep.x) + sqr(dstep.z) - sqr(dstep.y * conusfact);
    d1 := 2 * (step.x * dstep.x + step.z * dstep.z
          - sqr(conusfact) * step.y * dstep.y);
    d2 := sqr(step.x) + sqr(step.z) - sqr(conusfact * step.y);
  end;
  symmetric_z :
  begin
    //factors
    d0 := sqr(dstep.x) + sqr(dstep.y) - sqr(dstep.z * conusfact);
    d1 := 2 * (step.x * dstep.x + step.y * dstep.y
          - sqr(conusfact) * step.z * dstep.z);
    d2 := sqr(step.x) + sqr(step.y) - sqr(conusfact * step.z);
  end;
  end; //end of case FOrientation3D of


  //solving an equation of the second degree
  rod := sqr(d1) - 4 * d2 * d0;

  //d2 is never zero
  if rod >= 0
  then
  begin
    //only then is the collision possible
    rod2 := sqrt(rod);
    t1 := (-d1 - rod2)/2/d2;
    t2 := (-d1 + rod2)/2/d2;

    // if longshot then look into all future
    if longshot
    then
      result := (t1 >= 0) or (t2 >= 0)
    else
    begin
      //collision in between the starting and the ending point if
      result := ((t1 >= 0) and (t1 <= 1))
             or ((t2 >= 0) and (t2 <= 1));
    end;

    // however the collision also affords that we are within the length of the conus
    if result then
    begin
      case FOrientation3D of
      symmetric_x :
      begin
        xc1 := old_eye.x + t1 * step.x;
        xc2 := old_eye.x + t2 * step.x;


        if longshot
        then
          result :=
           (result and (t1 >= 0) and
           (xc1 >= (Fcoll_box_min[FseriesNr, coll_nr].x - bullet_radius)) and
           (xc1 <= (Fcoll_box_max[FseriesNr, coll_nr].x + bullet_radius)) )
          or
           (result and (t2 >= 0) and
           (xc2 >= (Fcoll_box_min[FseriesNr, coll_nr].x - bullet_radius)) and
           (xc2 <= (Fcoll_box_max[FseriesNr, coll_nr].x + bullet_radius)) )
        else
          result :=
           (result and (t1 >= 0) and (t1 <= 1) and
           (xc1 >= (Fcoll_box_min[FseriesNr, coll_nr].x - bullet_radius)) and
           (xc1 <= (Fcoll_box_max[FseriesNr, coll_nr].x + bullet_radius)) )
         or
           (result and (t2 >= 0) and (t2 <= 1) and
           (xc2 >= (Fcoll_box_min[FseriesNr, coll_nr].x - bullet_radius)) and
           (xc2 <= (Fcoll_box_max[FseriesNr, coll_nr].x + bullet_radius)) );

         //if collision detected then exit now
         if result then exit;

      end;
      symmetric_y :
      begin
        yc1 := old_eye.y + t1 * step.y;
        yc2 := old_eye.y + t2 * step.y;


        if longshot
        then
          result :=
           (result and (t1 >= 0) and
           (yc1 >= (Fcoll_box_min[FseriesNr, coll_nr].y - bullet_radius)) and
           (yc1 <= (Fcoll_box_max[FseriesNr, coll_nr].y + bullet_radius)) )
          or
           (result and (t2 >= 0) and
           (yc2 >= (Fcoll_box_min[FseriesNr, coll_nr].y - bullet_radius)) and
           (yc2 <= (Fcoll_box_max[FseriesNr, coll_nr].y + bullet_radius)) )
        else
          result :=
           (result and (t1 >= 0) and (t1 <= 1) and
           (yc1 >= (Fcoll_box_min[FseriesNr, coll_nr].y - bullet_radius)) and
           (yc1 <= (Fcoll_box_max[FseriesNr, coll_nr].y + bullet_radius)) )
         or
           (result and (t2 >= 0) and (t2 <= 1) and
           (yc2 >= (Fcoll_box_min[FseriesNr, coll_nr].y - bullet_radius)) and
           (yc2 <= (Fcoll_box_max[FseriesNr, coll_nr].y + bullet_radius)) );

         //if collision detected then exit now
         if result then exit;


      end;
      symmetric_z :
      begin
        zc1 := old_eye.z + t1 * step.z;
        zc2 := old_eye.z + t2 * step.z;


        if longshot
        then
          result :=
           (result and (t1 >= 0) and
           (zc1 >= (Fcoll_box_min[FseriesNr, coll_nr].z - bullet_radius)) and
           (zc1 <= (Fcoll_box_max[FseriesNr, coll_nr].z + bullet_radius)) )
          or
           (result and (t2 >= 0) and
           (zc2 >= (Fcoll_box_min[FseriesNr, coll_nr].z - bullet_radius)) and
           (zc2 <= (Fcoll_box_max[FseriesNr, coll_nr].z + bullet_radius)) )
        else
          result :=
           (result and (t1 >= 0) and (t1 <= 1) and
           (zc1 >= (Fcoll_box_min[FseriesNr, coll_nr].z - bullet_radius)) and
           (zc1 <= (Fcoll_box_max[FseriesNr, coll_nr].z + bullet_radius)) )
         or
           (result and (t2 >= 0) and (t2 <= 1) and
           (zc2 >= (Fcoll_box_min[FseriesNr, coll_nr].z - bullet_radius)) and
           (zc2 <= (Fcoll_box_max[FseriesNr, coll_nr].z + bullet_radius)) );

         //if collision detected then exit now
         if result then exit;
      end;

      end; //end of case
    end;

    //exit if a collision occured
    if result then exit;
  end;


  //the collision may also occur with the end surfaces of the cylinder
  case FOrientation3D of
  symmetric_x :
  begin
    if step.x > 1e-6
    then
    begin
      //1st end surface
      t1 := (Fcoll_box_min[FseriesNr, coll_Nr].x - old_eye.x)/step.x;
      yc1 := old_eye.y + t1 * step.y;
      zc1 := old_eye.z + t1 * step.z;

      distance := sqrt( sqr(yc1 - center.y) + sqr(zc1 - center.z) );

      if FPercentLeftatTop >= 0
      then
        radius := width3D/2 //the large end of the conus is down
      else
        radius := -width3D/2 * FPercentLeftatTop;

      radius := radius + bullet_radius;

      result := (distance < radius) and (t1 >= 0);
      if not longshot then result := result and (t1 <= 1);
      if result then exit;

      //2nd end surface
      t1 := (Fcoll_box_max[FseriesNr, coll_Nr].x - old_eye.x)/step.x;
      yc1 := old_eye.y + t1 * step.y;
      zc1 := old_eye.z + t1 * step.z;

      distance := sqrt( sqr(yc1 - center.y) + sqr(zc1 - center.z) );

      if FPercentLeftatTop >= 0
      then
        radius := width3D/2 * FPercentLeftatTop //the small end of the conus is upwards
      else
        radius := width3D/2;

      radius := radius + bullet_radius;

      result := (distance < radius) and (t1 >= 0);
      if not longshot then result := result and (t1 <= 1);
      if result then exit;
    end;
  end;
  symmetric_y :
  begin
    if step.y > 1e-6
    then
    begin
      //1st end surface
      t1 := (Fcoll_box_min[FseriesNr, coll_Nr].y - old_eye.y)/step.y;
      xc1 := old_eye.x + t1 * step.x;
      zc1 := old_eye.z + t1 * step.z;

      distance := sqrt( sqr(xc1 - center.x) + sqr(zc1 - center.z) );

      if FPercentLeftatTop >= 0
      then
        radius := width3D/2 //the large end of the conus is down
      else
        radius := -width3D/2 * FPercentLeftatTop;

      radius := radius + bullet_radius;

      result := (distance < radius) and (t1 >= 0);
      if not longshot then result := result and (t1 <= 1);
      if result then exit;

      //2nd end surface
      t1 := (Fcoll_box_max[FseriesNr, coll_Nr].y - old_eye.y)/step.y;
      xc1 := old_eye.x + t1 * step.x;
      zc1 := old_eye.z + t1 * step.z;

      distance := sqrt( sqr(xc1 - center.x) + sqr(zc1 - center.z) );

      if FPercentLeftatTop >= 0
      then
        radius := width3D/2 * FPercentLeftatTop //the small end of the conus is upwards
      else
        radius := width3D/2;

      radius := radius + bullet_radius;

      result := (distance < radius) and (t1 >= 0);
      if not longshot then result := result and (t1 <= 1);
      if result then exit;
    end;

  end;
  symmetric_z :
  begin
    if step.z > 1e-6
    then
    begin
      //1st end surface
      t1 := (Fcoll_box_min[FseriesNr, coll_Nr].z - old_eye.z)/step.z;
      xc1 := old_eye.x + t1 * step.x;
      yc1 := old_eye.y + t1 * step.y;

      distance := sqrt( sqr(xc1 - center.x) + sqr(yc1 - center.y) );

      if FPercentLeftatTop >= 0
      then
        radius := width3D/2 //the large end of the conus is down
      else
        radius := width3D/2 * FPercentLeftatTop;

      radius := radius + bullet_radius;

      result := (distance < radius) and (t1 >= 0);
      if not longshot then result := result and (t1 <= 1);
      if result then exit;

      //2nd end surface
      t1 := (Fcoll_box_max[FseriesNr, coll_Nr].z - old_eye.z)/step.z;
      xc1 := old_eye.x + t1 * step.x;
      yc1 := old_eye.y + t1 * step.y;

      distance := sqrt( sqr(xc1 - center.x) + sqr(yc1 - center.y) );

      if FPercentLeftatTop >= 0
      then
        radius := -width3D/2 * FPercentLeftatTop //the small end of the conus is upwards
      else
        radius := width3D/2;

      radius := radius + bullet_radius;

      result := (distance < radius) and (t1 >= 0);
      if not longshot then result := result and (t1 <= 1);
      if result then exit;
    end;

  end;


  end; //end of case


end; //end of coll_test_conus




function TcollisionTester3DX.coll_test_box(coll_nr : byte;
                              old_attacker_position, attacker_position : TD3DVector;
                              bullet_radius : TD3DValue; longshot : boolean): boolean;
var
  new_eye, old_eye : TD3DVector;
  step : TD3DVector;
  t1, xc, yc, zc : TD3DValue;
begin
  result := false;

  //Get the coordinates of the old eye_position in the actual coll frame
  FFrameSeries[FSeriesIndex, FNrinFrameSeries[FSeriesNr, coll_nr]].InverseTransform
                 (old_eye, old_attacker_position);

  //Get the coordinates of the eye_position in the actual coll frame
  FFrameSeries[FSeriesIndex, FNrinFrameSeries[FSeriesNr, coll_nr]].InverseTransform
                 (new_eye, attacker_position);

  //step in eye position
  step.x := new_eye.x - old_eye.x;
  step.y := new_eye.y - old_eye.y;
  step.z := new_eye.z - old_eye.z;

  //collision is only possible when something moves
  if (abs(step.x) < 1e-3) and (abs(step.y) < 1e-3) and (abs(step.z) < 1e-3)
  then
  begin
    result := false;
    exit;
  end;

  //check the surfaces which are normal to the x-axis
  if abs(step.x) >= 1E-6
  then
  begin
    //test 1st surface
    t1 := (Fcoll_box_min[FseriesNr, coll_nr].x - old_eye.x)/step.x;
    //collision point
    zc := old_eye.z + t1 * step.z;
    yc := old_eye.y + t1 * step.y;

    //collision if the collision point is close enough to the surface
    result :=
      (zc >= (Fcoll_box_min[FseriesNr, coll_nr].z - bullet_radius)) and
      (zc <= (Fcoll_box_max[FseriesNr, coll_nr].z + bullet_radius)) and
      (yc >= (Fcoll_box_min[FseriesNr, coll_nr].y - bullet_radius)) and
      (yc <= (Fcoll_box_max[FseriesNr, coll_nr].y + bullet_radius));

    if longshot
    then result := result and (t1 >= 0)
    else result := result and (t1 >= 0) and (t1 <= 1);

    //if collision detected then exit now
    if result then exit;

    //test 2nd surface
    t1 := (Fcoll_box_max[FseriesNr, coll_nr].x - old_eye.x)/step.x;
    //collision point
    zc := old_eye.z + t1 * step.z;
    yc := old_eye.y + t1 * step.y;

    //collision if the collision point is close enough to the surface
    result :=
      (zc >= (Fcoll_box_min[FseriesNr, coll_nr].z - bullet_radius)) and
      (zc <= (Fcoll_box_max[FseriesNr, coll_nr].z + bullet_radius)) and
      (yc >= (Fcoll_box_min[FseriesNr, coll_nr].y - bullet_radius)) and
      (yc <= (Fcoll_box_max[FseriesNr, coll_nr].y + bullet_radius));

    if longshot
    then result := result and (t1 >= 0)
    else result := result and (t1 >= 0) and (t1 <= 1);

    //if collision detected then exit now
    if result then exit;

  end; //end of step.x <> 0


  //check the surfaces which are normal to the y-axis
  if abs(step.y) >= 1E-6
  then
  begin
    //test 1st surface
    t1 := (Fcoll_box_min[FseriesNr, coll_nr].y - old_eye.y)/step.y;
    //collision point
    xc := old_eye.x + t1 * step.x;
    zc := old_eye.z + t1 * step.z;

    //collision if the collision point is close enough to the surface
    result :=
      (xc >= (Fcoll_box_min[FseriesNr, coll_nr].x - bullet_radius)) and
      (xc <= (Fcoll_box_max[FseriesNr, coll_nr].x + bullet_radius)) and
      (zc >= (Fcoll_box_min[FseriesNr, coll_nr].z - bullet_radius)) and
      (zc <= (Fcoll_box_max[FseriesNr, coll_nr].z + bullet_radius));

    if longshot
    then result := result and (t1 >= 0)
    else result := result and (t1 >= 0) and (t1 <= 1);

    //if collision detected then exit now
    if result then exit;

    //test 2nd surface
    t1 := (Fcoll_box_max[FseriesNr, coll_nr].y - old_eye.y)/step.y;
    //collision point
    xc := old_eye.x + t1 * step.x;
    zc := old_eye.z + t1 * step.z;

    //collision if the collision point is close enough to the surface
    result :=
      (xc >= (Fcoll_box_min[FseriesNr, coll_nr].x - bullet_radius)) and
      (xc <= (Fcoll_box_max[FseriesNr, coll_nr].x + bullet_radius)) and
      (zc >= (Fcoll_box_min[FseriesNr, coll_nr].z - bullet_radius)) and
      (zc <= (Fcoll_box_max[FseriesNr, coll_nr].z + bullet_radius));

    if longshot
    then result := result and (t1 >= 0)
    else result := result and (t1 >= 0) and (t1 <= 1);

    //if collision detected then exit now
    if result then exit;

  end; //end of step.y <> 0



  //check the surfaces which are normal to the z-axis
  if abs(step.z) >= 1E-6
  then
  begin
    //test 1st surface
    t1 := (Fcoll_box_min[FseriesNr, coll_nr].z - old_eye.z)/step.z;
    //collision point
    xc := old_eye.x + t1 * step.x;
    yc := old_eye.y + t1 * step.y;

    //collision if the collision point is close enough to the surface
    result :=
      (xc >= (Fcoll_box_min[FseriesNr, coll_nr].x - bullet_radius)) and
      (xc <= (Fcoll_box_max[FseriesNr, coll_nr].x + bullet_radius)) and
      (yc >= (Fcoll_box_min[FseriesNr, coll_nr].y - bullet_radius)) and
      (yc <= (Fcoll_box_max[FseriesNr, coll_nr].y + bullet_radius));

    if longshot
    then result := result and (t1 >= 0)
    else result := result and (t1 >= 0) and (t1 <= 1);

    //if collision detected then exit now
    if result then exit;

    //test 2nd surface
    t1 := (Fcoll_box_max[FseriesNr, coll_nr].z - old_eye.z)/step.z;
    //collision point
    xc := old_eye.x + t1 * step.x;
    yc := old_eye.y + t1 * step.y;

    //collision if the collision point is close enough to the surface
    result :=
      (xc >= (Fcoll_box_min[FseriesNr, coll_nr].x - bullet_radius)) and
      (xc <= (Fcoll_box_max[FseriesNr, coll_nr].x + bullet_radius)) and
      (yc >= (Fcoll_box_min[FseriesNr, coll_nr].y - bullet_radius)) and
      (yc <= (Fcoll_box_max[FseriesNr, coll_nr].y + bullet_radius));

    if longshot
    then result := result and (t1 >= 0)
    else result := result and (t1 >= 0) and (t1 <= 1);

    //if collision detected then exit now
    if result then exit;

  end; //end of step.z <> 0


end; //end of coll_test_box






function TCollisionTester3DX.BulletDead:boolean;
var
  camera_position, bullet_position : TD3DVector;
  Distance : TD3DValue;
begin
  FBulletFrame.GetPosition(FDXDrawUsed.Scene, bullet_position);
  FDXDrawUsed.Camera.GetPosition(FDXDrawUsed.Scene, camera_position);

  Distance := sqr(Bullet_position.x - camera_position.x)
            + sqr(Bullet_position.y - camera_position.y)
            + sqr(Bullet_position.z - camera_position.z);

  //remove the bullet if it is beyond the bulletrange or if it is a longshot
  result := (sqrt(Distance) > FBulletRange) or FLongShots;

end; //end of BulletDead




//use this function to check whether the camera or an object in a distance of
// -from camera- from the camera collides with any collision object
function TCollisionTester3DX.collision: boolean;
var
  i : integer;
  camera_position, camera_direction, camera_up : TD3DVECTOR;
  eye_position : TD3DVector;
begin
  Result := false;
  FBullet_HitlinkNr := -1;

  if CheckForSeriesIndex(FSeriesIndex)
  then
  begin
    //The series exists
    if Fcoll_Nr_objects[FSeriesNr] > 0
    then
    begin
      //The series is not empty

      //Get the position of the camera
      FDXDrawUsed.Camera.GetPosition(FDXDrawUsed.Scene, camera_position);
      FDXDrawUsed.camera.GetOrientation(FDXDrawUsed.scene, camera_direction, camera_up);
      //calculate the eye position
      eye_position.x := camera_position.x + FFrontDistance * camera_direction.x;
      eye_position.y := camera_position.y + FFrontDistance * camera_direction.y;
      eye_position.z := camera_position.z + FFrontDistance * camera_direction.z;

      //test whether the eye collides with any of the collision objects
      i := 0;
      while (not result) and (i < Fcoll_nr_objects[FSeriesNr]) do //0..
      begin
        case Fcoll_shape[FSeriesNr, i] of
          box3D      : Result := coll_test_box(i, FOldEyePosition,
                                 eye_position, FHeadRadius, false);
          sphere3D   : Result := coll_test_sphere(i, FOldEyePosition,
                                 eye_position, FHeadRadius, false);
          cylinder3D : Result := coll_test_cylinder(i, FOldEyePosition,
                                 eye_position, FHeadRadius, false);
          ellipsoid3D: Result := coll_test_ellipsoid(i, FOldEyePosition,
                                 eye_position, FHeadRadius, false);
          conus3D    : Result := coll_test_conus(i, FOldEyePosition,
                                 eye_position, FHeadRadius, false);
        end;

        if result then Fbullet_hitLinkNr := Fcoll_objectnr[FseriesNr, i];
        inc(i);
      end;
    end;
  end; //end of if checkforseriesIndex

  if result
  then
    ListDataForCollObject;

end; //end of collision







//use this function to check whether an object sent from the camera collides
//with any collision object
function TCollisionTester3DX.BulletCollision: boolean;
var
  i: integer;
  bullet_position : TD3DVector;
begin
  Result := false;
  FBullet_HitLinkNr := -1;

  if checkForSeriesIndex(FSeriesIndex)
  then
  begin
    //Series exists

    //test whether eye collides with any of the collision objects
    if Fcoll_Nr_objects[FSeriesNr] > 0
    then
    begin
      //Get position of the bullet
      FBulletFrame.GetPosition(FDXDrawUsed.Scene, bullet_position);
      i := 0;

      while (not result) and (i < Fcoll_Nr_objects[FSeriesNr]) do //0..
      begin
        if FColl_Shootable[FseriesNr, i] or
           (FColl_material[FSeriesNr, i] = solid3D)
        then
        begin
          case Fcoll_shape[FSeriesNr, i] of
            box3D      : result := coll_test_box(i, FOldBulletPosition,
                                             bullet_position,
                                             FBulletRadius, FLongShots);
            sphere3D   : result := coll_test_sphere(i, FOldBulletPosition,
                                             bullet_position,
                                             FBulletRadius, FLongShots);
            cylinder3D : result := coll_test_cylinder(i, FOldBulletPosition,
                                             bullet_position,
                                             FBulletRadius, FLongShots);
            ellipsoid3D: result := coll_test_ellipsoid(i, FOldBulletPosition,
                                             bullet_position,
                                             FBulletRadius, FLongShots);
            conus3D    : result := coll_test_conus(i, FOldBulletPosition,
                                             bullet_position,
                                             FBulletRadius, FLongShots);
          end; //end case
        end; //end of if..

        if result
        then
          FBullet_HitLinkNr := Fcoll_ObjectNr[FSeriesNr, i];

        inc(i);
      end; //end of while

      if result
      then
        ListDataForCollObject;

    end; //end if Fcoll_Nr_ob....
  end; //end if checkForSeriesIndex...

end; //end of bullet_collision




procedure TCollisionTester3DX.GetOldBulletPos;
begin
  FbulletFrame.GetPosition(FDXDrawUsed.Scene, FOldBulletPosition);
end; //end of GetOldBulletPos


procedure TCollisionTester3DX.GetOldEyePos;
var
  OldPos, camera_direction, camera_up : TD3DVector;
begin
  FDXDrawUsed.Camera.GetPosition(FDXDrawUsed.Scene, OldPos);
  FDXDrawUsed.Camera.GetOrientation(FDXDrawUsed.Scene, camera_direction, camera_up);

  FOldEyePosition.x := OldPos.x + FFrontDistance * camera_direction.x;
  FOldEyePosition.y := OldPos.y + FFrontDistance * camera_direction.y;
  FOldEyePosition.z := OldPos.z + FFrontDistance * camera_direction.z;

end; //end of GetOldEyePos






end.