//Henrik Fabricius, Delphi3DX, august 1999
unit typer3D;

interface

uses
  windows, DirectX, colli3dx;


type
  normalvekt = array [0..297] of TD3Dvector;
  verticevekt = array [0..297] of TD3Dvector;
  facevekt = Array [0..3865] of DWORD;  //DWORD 4 bytes long
  //transvekt = Array[0..(FL - 1), 0..(FL - 1)] of real;
  transvekt = Array[0..256, 0..256] of real;
const

  {constants related to the buildplane procedure}
  {from the Awesome Power of Direct3D/DirectX}

  {from unit constant.hpp}
  FL = 257;
  points_Xsize = 21;  // lX in the book and in his program
  points_Ysize = 21;  // lY in the book and in his program

  gTileX = 8;   {8 in chap 10 but 7 in chap 7}
  gTileY = 7;
  mTileX = 2;
  mTileY = 7;

  // distance between 2 nodes of the field
  m_step = 0.5;

  //Rendering quality
  quality = D3DRMRENDER_GOURAUD;  //D3DRMRENDER_Wireframe;

  //constant for the FELD
  MAXHOEHE = 1.5;

  //lift makes shadows visible
  lift = 0.2;

  //number_of_3D_series
  Number_of_3D_series = 2;

  //Index of fixed objects in FixedSeries
  FixedSeries = 0; //frames are in the 1. series index = 0

  //Series number of series with shootable objects
  ShootableSeries = 1; //frames are in the 2. series  index = 1

  //Min time between bullets in msecs
  MinTimeBetweenBullets = 300;


var
  facedata : facevekt;
  vertices : verticevekt;
  normals : normalvekt;

  //*********************

  Pvertices : ^TD3Dvector; // Pointer to variable or array of TD3Dvector
  Pnormals : ^TD3Dvector;  // Pointer to variable or array of TD3Dvector
  Pfacedata : ^DWORD;      // Pointer to variable or array of DWORD

  //*********************

  g_faces : word;

  ground_meshes : Array[0..(gTileX - 1),
                        0..(gTileY - 1),
                        0..4] of IDIRECT3DRMMESH;

  {variables related to the BuildPlane proc }
  trans : transvekt; //see page 142 in the book

  {The numbers in points[0, i, j] have the following bitwise representations
  0 = 0000, 1 = 0001, 3 = 0011, 7 = 0111, 15 = 1111.
  The procedure CreatePoints in terrain.pas picks meshpoints from the points
  array by performing a logic comparison with the following selectors
  1 shl 0 = 0001, 1 shl 1 = 0010, 1 shl 2 = 0100, 1 shl 3 = 1000
  The point is selected when the result of the logical comparison is different
  from zero.
  Four different grids can be formed from the points array      HF jan 1999
  }

  points : Array[0..1, 0..(points_Xsize - 1), 0..(points_Ysize - 1)] of DWORD
  = (
      (
        (31, 0,15, 0,15, 0,15, 0,15, 0,15, 0,15, 0,15, 0,15, 0,15, 0,31),
        ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
        (15, 0,15, 0, 3, 0,15, 0, 3, 0,15, 0, 3, 0,15, 0, 3, 0,15, 0,15),
        ( 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0),
        (15, 0, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 0,15),
        ( 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0),
        (15, 0,15, 1, 3, 1,15, 1, 3, 1, 7, 1, 3, 1,15, 1, 3, 1,15, 0,15),
        ( 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0),
        (15, 0, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 0,15),
        ( 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0),
        (15, 0,15, 1, 3, 1, 7, 1, 3, 1, 7, 1, 3, 1, 7, 1, 3, 1,15, 0,15),
        ( 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0),
        (15, 0, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 0,15),
        ( 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0),
        (15, 0,15, 1, 3, 1,15, 1, 3, 1, 7, 1, 3, 1,15, 1, 3, 1,15, 0,15),
        ( 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0),
        (15, 0, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 0,15),
        ( 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0),
        (15, 0,15, 0, 3, 0,15, 0, 3, 0,15, 0, 3, 0,15, 0, 3, 0,15, 0,15),
        ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
        (31, 0,15, 0,15, 0,15, 0,15, 0,15, 0,15, 0,15, 0,15, 0,15, 0,31)
      ),
      (
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
       )
     );




  {******************************************************************}

  {camera}
  camera_position, camera_direction, camera_up, camera_xaxis : TD3DVECTOR;

  
  {Frames for light sources}
  LightFrame: IDirect3DRMFrame;
  ShadowLightFrame : IDirect3DRMFrame;

  {directed light}
  camera_light_position: TD3DVECTOR;
  fraction_ambient : TD3DVALUE;  {fraction of ambient light e.g. 0.1}

  {ShadowLight}
  ShadowLight: IDirect3DRMLight;

  //names of the light sources
  Light, AmbientLight: IDirect3DRMLight;

  {floor}
  Floor_frame : IDirect3DRMFrame;
  brick_tex, stone_tex, grass_tex : IDirect3DRMTEXTURE;
  mat : IDirect3DRMMATERIAL;
  visGFeld : Array[0..(gTileX-1), 0..(gTileY-1)] of integer;  //static array

  {wall}
  wall_mesh : IDirect3DRMMesh;
  number_of_fixed_objects : shortint;

  {3D-object}
  rotate_3D_object : boolean;
  number_of_3D_objects : shortint;


  wrap: IDirect3DRMWrap;
  next_wraptype : TD3DRMWrapType;
  wrap_3D_objects : boolean;

  {Dynamic arrays}
  Mesh: Array of IDirect3DRMMesh;
  MeshFrame: TFrames3D; //important!
  MyShadow : Array of IDirect3DRMVISUAL;
  WrapType: Array of TD3DRMWRAPTYPE;
  object_position : Array of TD3DVECTOR;
  object_direction : Array of TD3DVECTOR;
  object_scale : Array of TD3DVALUE;
  object_texture_filename : Array of string;
  object_FileName: Array of string;
  nr_hits_3D_object : Array of integer;
  CollType: Array of Tshapes3D;

  //fixed arrays
  populated : array[0..6, 0..6] of boolean;


  //bullets
  bullet_frame : Array of IDirect3DRMFrame;
  bullet_mesh : IDirect3DRMMesh;
  bullet_radius : TD3DValue;
  number_of_bullets : integer;
  firing_bullet : boolean;

  testantal : integer;
  nosteps : boolean;
  fire_misil : boolean;

  game_finished : boolean;
  insert_a_new_3Dobject : boolean;

  //number of hits needed to destroy 3D_object
  max_hits : integer;

  //Hardware counter
  HWCountNow : int64;
  HWCountNextBulletAllowed : Int64;
  HardwareCounter_available : boolean;



implementation



end.
