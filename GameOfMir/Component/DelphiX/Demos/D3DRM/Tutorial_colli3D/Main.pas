//****************************************************************************
// 3D-gaming with Delphi 4,5 or 6 and Microsoft DirectX 6 or higher  version 1.4
//****************************************************************************
//
// This DELPHI 4 and 5 program is CopyRight
// Henrik Fabricius, August 1999, march 2000, June 2002
// http://users.cybercity.dk/~bbl6194/delphi3dx.htm
// E-mail: henrik_og_bodil@vip.cybercity.dk
//
// You may use this program for free on the following conditions:
// 1) You must give credit to the author of this program, Hori and Peter Kovach
//    if you use parts of this code for your own code and put it on the internet
// 2) Any proposals for changes or improvements should be addressed directly to
//    the author of this program.
// 3) The use of this program is on your own risk. The software is provided as
//    is without any garanties and warranty. The author is not responsible for
//    any damage or losses of any kind caused by the use of this software or the
//    software it is intended to be used with.
//
// To use this program you must have
// 1) DELPHI 4, 5 or 6
// 2) MS-DirectX 6.0 or higher
// 3) The latest DelphiX components made for your Delphi version
// 4) The TCollisionTester3DX component ( obs! the colli3DX.pas file must be
//    placed in the same directory as DelphiX
//
// Use a joy stick to control the observer and to shoot bullets
// Alternatively use the arrow-buttons to move and the space button to shoot.
//
// MS_DirectX is a trademark of the Microsoft Corporation
// Delphi 4/5/6 is a trademark of the Inprise Corporation
// The TCollisionTester3DX component is CopyRight Henrik Fabricius
// You may always find the newest version at the Delphi3DX page
//
// You may use this program to learn how to use the TCollisionTester3DX component
// which checkes for collision between the observer and 3D-objects as well as
// between bullets fired by the observer and the 3D-objects. Please consult the
// first part of the source code for the TColllisionTester3DX component to learn
// more about the capabilities of the component.
// You may also use this program and the TcollisionTester3DX component to learn
// work with dynamic arrays.
//
// The main idea of the TCollisionTester3DX component is to surround each of the
// 3D objects by one or more simple 3D-collision objects and to use these objects
// for testing for collisions. The types of objects are box3D - sphere3D -
// ellipsoid3D - cylinder3D and conus3D. Types of materials are solid3D - water3D
// and air3D. Available functional properties are: pickable - shootable and
// fixed3Dobject.
// The collosionTester is initialized with the command: ZeroSetIt.
// It is both possible to work with bullets which are fired at a limited speed
// and at an unlimited speed.
//
// The program shows how to display 3D-objects and how to work with shadows.
//
// Press on ALT and Enter to shift between Windows and Full screen mode.
//
// The content of the landscape generating routines in the units terrain and
// field_1 were derived from the C++ code in the book "The Awesome Power of
// Direct3D/DirectX by Peter Kovach".
// Thanks to Peter Kovach at directx.xoom.com for allowing me to include the
// translated code with this program.
//
// It is shown how it is possible to use the Hardware counter in modern CPUs
// to perform a fast and high resolution timing of the AutoShooting function
// (see HWCounter.pas). Min time between bullets in msecs is declared as a
// constant in typer3D.pas
//
//   MinTimeBetweenBullets = 300;
//
// Links to pages containing gaming using the DelphiX and TCollisionTester3DX
// components are welcome on the Delphi3DX page.
//
// Good Luck
// Henrik Fabricius
// June 2002
//
// Look for further 3D-examples new components and updates on
// http://users.cybercity.dk/~bbl6194/delphi3dx.htm
//
//
//******************************************************************************
//
// THIS GAME GOES LIKE!
//
// Use a joystick or the arrows to move around
// Use button 1 on your joy stick or the SPACE button to fire at the objects
//
// Check the LongShots checkbox to shoot high speed bullets or uncheck it to
// work with visible bullets moving with limited speed.
//
// Five 3D objects are seen from the beginning.
// From time to time a new object appears.
//
// Shoot all the objects to win the game.
// The game is lost if the number of objects increases to 10.
//
// Use the panel with the radiobuttons to change the number of shots required to
// remove an object.
//
// Try to move around and see how the program prevents you from moving through
// the solid objects.
//
// Try to shoot close to the egg shaped object and the sphere to se how well the
// collisionobjects fits the real objects.
//
// Notice how the sigle boxshaped coll-object surrounding the chair gives an
// unrealistic impression of the shooting of a chair.
//
// *****************************************************************************
//






unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DXClass, DXDraws, DirectX, DXInput, MPlayer, typer3D, terrain,
  feld_1, DXSounds, DXWave, colli3DX, ExtCtrls, HWCounter;
  //obs colli3DX must be placed in the same directory as DelphiX

type

  TMainForm = class(TDXForm)
    DXDraw: TDXDraw;
    DXTimer: TDXTimer;
    OpenDialog: TOpenDialog;
    Edit1: TEdit;
    DXInput1: TDXInput;
    DXWaveList1: TDXWaveList;
    DXSound1: TDXSound;
    CollisionTester3DX1: TCollisionTester3DX;
    Timer1: TTimer;
    Timer2: TTimer;
    RadioGroup1: TRadioGroup;
    CheckBox1: TCheckBox;
    procedure DXDrawInitialize(Sender: TObject);
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawInitializeSurface(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private

    procedure CreateWarp(SeriesNr, objectnr : shortint);
    procedure get_list_of_3D_objects;
    procedure get_camera_data;
    procedure MoveForward(v : TD3DVECTOR);
    procedure MoveBackWard(v : TD3DVECTOR);
    procedure TurnLeft(a : TD3DVALUE);
    procedure TurnRight(a : TD3DVALUE);
    procedure Make_Retreat;
    procedure stopmove;
    Procedure Check_keyboard_and_joystick;
    procedure place_camera_spotlight(camera_position, camera_xaxis,
             camera_up : TD3DVECTOR; var camera_light_position : TD3DVECTOR);
    procedure make_3D_object(SeriesNr, objectnr : shortint; symaxis : TOrientation3D);
    procedure make_floor;
    procedure make_wall;
    procedure make_bullet_mesh;
    function  remove_bullet_frame(bullet_frame_nr : integer): boolean;
    function  explode_3Dobject_and_bullet(bullet_frame_nr,
                               hit_object_nr : integer): boolean;
    procedure introduce_a_new_3Dobject;
  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}




procedure TmainForm.get_camera_data;
begin
  //data which are collected repeatedly
  DXDraw.Camera.GetPosition(DXDraw.scene, camera_position);
  DXDraw.camera.GetOrientation(DXDraw.scene, camera_direction, camera_up);

  //calculate the x direction of the camera frame
  D3DRMVectorCrossProduct(camera_xaxis, camera_up, camera_direction);

  //according to the pages 123 og 124 in the Awesome Power of Direct3D/DirectX
  //we should reduce the length of the up and xaxis vectors by a factor of 4.5
  camera_xaxis.x := camera_xaxis.x/D3DVAL(4.5);
  camera_xaxis.y := camera_xaxis.y/D3DVAL(4.5);
  camera_xaxis.z := camera_xaxis.z/D3DVAL(4.5);

  camera_up.x := camera_up.x/D3DVAL(4.5);
  camera_up.y := camera_up.y/D3DVAL(4.5);
  camera_up.z := camera_up.z/D3DVAL(4.5);
end;


//Controlling the camera
procedure TmainForm.MoveForward(v : TD3DVECTOR);
begin
  DXDraw.Camera.SetVelocity(DXDraw.scene, v.x, v.y, v.z, FALSE);
end;


procedure TmainForm.MoveBackWard(v : TD3DVECTOR);
begin
  DXDraw.Camera.SetVelocity(DXDraw.scene, -v.x, -v.y, -v.z, FALSE);
end;

procedure TmainForm.TurnLeft(a : TD3DVALUE);
begin
  DXDraw.Camera.SetRotation(DXDraw.Scene, D3DVAL(0.0), D3DVAL(1.0),
                              D3DVAL(0.0), -a);
end;

procedure Tmainform.TurnRight(a : TD3DVALUE);
begin
  DXDraw.Camera.SetRotation(DXDraw.Scene, D3DVAL(0.0), D3DVAL(1.0),
                              D3DVAL(0.0), a);
end;


procedure Tmainform.StopMove;
begin
  //set the velocity of the camera to zero to stop our movement
  //see the Awesome Power of Direct3D/DirectX page 127.
  DXDraw.camera.SetRotation(DXDraw.Scene, D3DVAL(0.0), D3DVAL(1.0),
                      D3DVAL(0.0), D3DVAL(0.0));
  DXDraw.Camera.SetVelocity(DXDraw.scene, D3DVAL(0.0), D3DVAL(0.0),
                      D3DVAL(0.0), FALSE);
end;



procedure Tmainform.Make_Retreat;
begin
  //regret the last step leading to the observed collision
  if isDown in DXInput1.States
  then
    MoveForward(camera_direction);

  if isUp in DXInput1.States
  then
    MoveBackward(camera_direction);

  if isLeft in DXInput1.States
  then
    TurnRight(D3DVAL(0.05));

  if isRight in DXInput1.States
  then
    TurnLeft(D3DVAL(0.05));

end;



//Check the input devices and act on it
Procedure TmainForm.Check_keyboard_and_joystick;
var
  nr_bullets : integer;
begin
  //read input from joystick and keyboard
  DXinput1.Update;

  //move or stop
  if ((isLeft in DXInput1.States) or
      (isRight in DXInput1.States)) or
     ((isUp in DXInput1.States) or
      (isDown in DXInput1.States))
  then
  begin
    if nosteps
    then
      DXWaveList1.Items[0].Play(false); //the system hangs if true

    nosteps := false;

    if isUp in DXInput1.States
    then
    begin
      {if the up arrow is hit, move forward}
      get_camera_data;

      MoveForward(camera_direction);

      //Place camera light
      place_camera_spotlight(camera_position, camera_xaxis, camera_up,
                           camera_light_position);

    end; //end if isUp


    if isDown in DXInput1.States
    then
    begin
      {if the down arrow is hit, move backward}
      get_camera_data;

      MoveBackward(camera_direction);

      //place camera light
      place_camera_spotlight(camera_position, camera_xaxis, camera_up,
                         camera_light_position);

    end; //end if isdown



    if isLeft in DXInput1.States
    then
    begin
      {if the left arrow is hit, rotate to the left}
      get_camera_data;

      TurnLeft(D3DVAL(0.05));

      //place camera light
      place_camera_spotlight(camera_position, camera_xaxis, camera_up,
                         camera_light_position);

    end; //end if isleft


    if isRight in DXInput1.States
    then
    begin
      {if the right arrow is hit, rotate to the right}
      get_camera_data;

      TurnRight(D3DVAL(0.05));

      //place camera light
      place_camera_spotlight(camera_position, camera_xaxis, camera_up,
                         camera_light_position);

    end; //end if isRight


  end
  else
  begin
    //we must stop
    nosteps := true;
    DXWaveList1.Items[0].Stop;
    //stop moving
    stopmove;
  end;


  //Check if gun is fired
  //Only one bullet pr click
  if ((isButton1 in DXInput1.States) or
     (isButton31 in DXInput1.States)) and (not firing_bullet)
  then
  begin
    //introduce a new bullet frame moving as defined by the camera frame
    Firing_bullet := true;
    nr_bullets := number_of_bullets + 1;
    setlength(bullet_Frame, nr_bullets);

    //create the frame for the bullet
    DXDraw.D3DRM.CreateFrame(DXDraw.Scene, bullet_Frame[nr_bullets-1]);

    //get data for the camera frame
    get_camera_data;
    //set position and direction of the bullet frame
    //the bullets comes from below the camera (-0.4)
    //this makes the different bullets visible
    Bullet_frame[nr_bullets-1].SetPosition(DXDraw.scene,
                                         camera_position.x,
                                         (camera_position.y - 0.4),
                                         camera_position.z);
    Bullet_frame[nr_bullets-1].SetOrientation(DXDraw.scene,
                                         camera_direction.x,
                                         camera_direction.y,
                                         camera_direction.z,
                                         camera_up.x,
                                         camera_up.y,
                                         camera_up.z);

    //make the bullet visible
    Bullet_Frame[nr_bullets - 1].AddVisual(bullet_mesh);

    //set the speed for the bullet frame
    bullet_frame[nr_bullets - 1].SetVelocity(DXDraw.scene,
                             (D3DVAL(5.0) * camera_direction.x),
                             (D3DVAL(5.0) * camera_direction.y),
                             (D3DVAL(5.0) * camera_direction.z),
                                           FALSE);

    number_of_bullets := nr_bullets;

    CollisionTester3DX1.BulletFrame := Bullet_Frame[nr_bullets - 1];

    //play sound of misil when the bullet is fired
    fire_misil := true;

    //calculate earliest time for the next bullet
    if HardwareCounter_available
    then
      HWCountNextBulletAllowed := CalculateTimeForNextBullet;
  end
  else
  begin
    //New bullet requires that key has been released
    if not ((isButton1 in DXInput1.States) or (isButton31 in DXInput1.States))
    then
      Firing_bullet := false
    else
    begin
      //alternatively time since last bullet must exceed MinTimeBetweenBullets
      if HardwareCounter_available
      then
      begin
        //read number of clock cycles since the PC was turned on
        QueryPerformanceCounter(HWCountNow);
        //if time since last bullet was fired exceedes MinTimeBetweenBullets
        //then then reset Firing_bullet
        If HWCountNow >= HWCountNextBulletAllowed
        then
          Firing_bullet := false;
      end;
    end;
  end;
end;




//Pressing a key during full-screen mode or Windows-mode
procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  //list of wrapping techniques
  WrapChangeList: array[D3DRMWRAP_FLAT..D3DRMWRAP_CHROME] of TD3DRMWRAPTYPE =
    (D3DRMWRAP_CYLINDER, D3DRMWRAP_SPHERE, D3DRMWRAP_CHROME, D3DRMWRAP_FLAT);
begin
  {  Application end  }
  if Key=VK_ESCAPE then Close;

  {  Screen mode change  }
  if (ssAlt in Shift) and (Key=VK_RETURN) then
  begin
    //Methode to change between FullScreen and window
    //Buttons and the like are displayed on top of the DXDraw graphics when
    //Alignment = Alclient
    //buttons properti Anchors are changed to enable top and right anchoring
    //This makes the buttons stay at the right when changing between FullScreen
    //mode and windows mode

    DXDraw.Finalize;  //finalize the DXDraw mode

    if doFullScreen in DXDraw.Options then
    begin
      //shift from fullscreen mode to windows mode (read windows date)
      RestoreWindow;

      DXDraw.Cursor := crDefault;
      BorderStyle := bsSizeable;
      DXDraw.Options := DXDraw.Options - [doFullScreen]; //DXDraw.Options status
    end else
    begin
      //Shift from windows mode to Fullscreen mode

      StoreWindow; //save settings for the windows mode

      DXDraw.Cursor := crNone;
      BorderStyle := bsNone;
      DXDraw.Options := DXDraw.Options + [doFullScreen]; //shift DXDraw.option
    end;

    DXDraw.Initialize;  //Initialize DXDraw again with the new settings
  end;




  //If the user hits a T we will want to move forward one step for each keypress}
  //see the AweSome Power of Direct3D/DirectX page 124
  if Key = Ord('T')
  then
  begin
    //find data for the camera frame
    get_camera_data;

    {sets the velocity of the camera frame relative to the scene.frame to the
    value in the direction vector }
    DXDraw.Camera.SetVelocity(DXDraw.scene, camera_direction.x,
                    camera_direction.y, camera_direction.z, FALSE);

     //place the camera light
    place_camera_spotlight(camera_position, camera_xaxis, camera_up,
                         camera_light_position);

  end;

  if Key = Ord('R')
  then
  begin
    {if the user hits R, sets the velocity of the camera frame relative to the
    scene to the reverse value of the direction vector}
    get_camera_data;

    DXDraw.Camera.SetVelocity(DXDraw.Scene, -camera_direction.x,
                    -camera_direction.y, -camera_direction.z, FALSE);

     //place the camera light
    place_camera_spotlight(camera_position, camera_xaxis, camera_up,
                         camera_light_position);

  end;

  if Key= Ord('E')
  then
  begin
    //if the user hits E, we want to move forward continously at a higher speed}
    //The speed is increased 10 times
    get_camera_data;

    DXDraw.Camera.SetVelocity(DXDraw.scene,(D3DVAL(-10.0) * camera_direction.x),
          (D3DVAL(-10.0) * camera_direction.y),
          (D3DVAL(-10.0) * camera_direction.z), FALSE);

     //place the camera light
    place_camera_spotlight(camera_position, camera_xaxis, camera_up,
                         camera_light_position);

  end;


  if Key= Ord('Y')
  then
  begin
    {if the user hits Y, we want to move backward continously at a higher speed}
    get_camera_data;

    DXDraw.Camera.SetVelocity(DXDraw.scene,(D3DVAL(10.0) * camera_direction.x),
          (D3DVAL(10.0) * camera_direction.y),
          (D3DVAL(10.0) * camera_direction.z), FALSE);

     //place the camera light
    place_camera_spotlight(camera_position, camera_xaxis, camera_up,
                         camera_light_position);

  end;


end;



procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //stop moving when the arrows are released
  StopMove;
end;



{************** keyboard procedures finished ****************}



procedure Tmainform.place_camera_spotlight(camera_position, camera_xaxis,
             camera_up : TD3DVECTOR; var camera_light_position : TD3DVECTOR);
begin
  {the spot-light is placed as if it was mounted on the camera}
  camera_light_position.x := camera_position.x + 2*(camera_xaxis.x+camera_up.x);
  camera_light_position.y := camera_position.y + 2*(camera_xaxis.y+camera_up.y);
  camera_light_position.z := camera_position.z + 2*(camera_xaxis.z+camera_up.z);

  LightFrame.SetPosition(DXDraw.Scene,
                         camera_light_position.x,
                         camera_light_position.y,
                         camera_light_position.z);

  {the orientation of spotlight is parallel to the camera frame direction}
  LightFrame.SetOrientation(DXDraw.Scene, camera_direction.x,
                         camera_direction.y, camera_direction.z,
                         camera_up.x, camera_up.y, camera_up.z);
end;


{************* Spotlight procedures finished here ************}



procedure TmainForm.get_list_of_3D_objects;
begin
  //As for a beginning we initialise the dynmic arrays to hold 3 3D-objects
  number_of_3D_objects := 5;

  //Working with dynamic arrays it is very important to set the length of the
  //array before filling anything new into it.
  //The SeLength command is somehow comparabil with the new command. However, the
  //setlength command must be used each time the size of array is increased.
  //However, it is not correct to use the setlength command when the size of the
  //array is going to be reduced. In this case you must use the following command
  //Mesh := Copy(Mesh, 0, (number_of_3D_objects + 1) )  Mesh = name of the array

  //1.st element in position 0
  SetLength(Mesh, number_of_3D_objects);
  SetLength(MeshFrame, number_of_3D_Series);
  SetLength(Meshframe[ShootableSeries], number_of_3D_objects);
  SetLength(MyShadow, number_of_3D_objects);
  SetLength(WrapType, number_of_3D_objects);
  SetLength(object_position, number_of_3D_objects);
  SetLength(object_direction, number_of_3D_objects);
  SetLength(object_scale, number_of_3D_objects);
  SetLength(object_texture_filename, number_of_3D_objects);
  SetLength(object_Filename, number_of_3D_objects);
  SetLength(nr_hits_3D_object, number_of_3D_objects);
  SetLength(CollType, number_of_3D_objects);

  {1. object}

  object_position[0].x := 10; //0.0;
  object_position[0].y := 3.18 + lift; //0.0;
  object_position[0].z := 20;
  populated[4, 3] := true; // xnow := 10/10 + 3  and znow := 20/10 + 1

  object_direction[0].x := 0.0;
  object_direction[0].y := 0.0;
  object_direction[0].z := 1.0;

  object_filename[0] := ExtractFilePath(Application.ExeName) + 'Egg.x';
  object_scale[0] := 3;
  object_texture_filename[0] := ExtractFilePath(Application.ExeName) + 'lake.bmp';
  WrapType[0] := D3DRMWRAP_CHROME;
  CollType[0] := ellipsoid3d;

  {2. object}
  object_position[1].x := -10.0;
  object_position[1].y := 6.0 + lift;  //0.0
  object_position[1].z := 30;
  populated[2,4] := true; // xnow := -10/10 + 3  and znow := 30/10 + 1

  object_direction[1].x := 0.0;
  object_direction[1].y := 0.0;
  object_direction[1].z := 1.0;

  object_filename[1] := ExtractFilePath(Application.ExeName) + 'chair.x';
  object_scale[1] := 0.02;
  object_texture_filename[1] := ExtractFilePath(Application.ExeName)+'lake.bmp';
  WrapType[1] := D3DRMWRAP_CYLINDER;
  CollType[1] := box3D;

  {3. object}
  object_position[2].x := -10.0;
  object_position[2].y := 0.25 + lift; //0.0
  object_position[2].z := 0;
  populated[2,1] := true; // xnow := -10/10 + 3  and znow := 0/10 + 1

  object_direction[2].x := 0.0;
  object_direction[2].y := 0.0;
  object_direction[2].z := 1.0;

  object_filename[2] := ExtractFilePath(Application.ExeName) + 'champagn.x';
  object_scale[2] := 1;
  object_texture_filename[2] := ExtractFilePath(Application.ExeName) + 'lake.bmp';
  WrapType[2] := D3DRMWRAP_CYLINDER;
  CollType[2] := cylinder3D;

  {4. object}
  object_position[3].x := -30.0;
  object_position[3].y := 0.95 + lift; //0.0
  object_position[3].z := -10;
  populated[0,0] := true; // xnow := -30/10 + 3  and znow := -10/10 + 1

  object_direction[3].x := 0.0;
  object_direction[3].y := 0.0;
  object_direction[3].z := 1.0;

  object_filename[3] := ExtractFilePath(Application.ExeName) + 'Cube.x';
  object_scale[3] := 2;
  object_texture_filename[3] := ExtractFilePath(Application.ExeName) + 'lake.bmp';
  WrapType[3] := D3DRMWRAP_CYLINDER;
  CollType[3] := box3D;

  {5. object}
  object_position[4].x := 20.0;
  object_position[4].y := 2.9 + lift; //0.0
  object_position[4].z := -10;
  populated[5,0] := true; // xnow := 20/10 + 3  and znow := -10/10 + 1

  object_direction[4].x := 0.0;
  object_direction[4].y := 0.0;
  object_direction[4].z := 1.0;

  object_filename[4] := ExtractFilePath(Application.ExeName) + 'Sphere.x';
  object_scale[4] := 2;
  object_texture_filename[4] := ExtractFilePath(Application.ExeName) + 'lake.bmp';
  WrapType[4] := D3DRMWRAP_CYLINDER;
  CollType[4] := sphere3D;

end;







//Wraps a 3D object
procedure TMainForm.CreateWarp(SeriesNr, objectnr : shortint);
var
  miny, maxy, height: TD3DVALUE;
  box: TD3DRMBOX;
  ov, sv: Double;
begin
  Mesh[objectnr].GetBox(box);

  maxy := box.max.y;
  miny := box.min.y;

  height := maxy - miny;
  if height=0 then height := 0.00001;  //avoid dividing with zero


  //See page 168 in the Awesome Power of direct3D/DirectX
  //ov og sv are common expressions used with the command CreateWarp(objectnr)

  //ou and ov names the Texture Origin
  ov := D3DDivide(miny, height);
  //su and sv are Texture Scale factor
  sv := D3DDivide(-1.0, height);

  //spheric wrap
  if WrapType[objectnr]=D3DRMWRAP_SPHERE then
  begin
    // See page 171 in the Awesome Power of Direct3D/DirectX
    // The Wrap is made as if the surface is put on a sphere surrounding the
    // 3D object. Then lines are drawn from the points on the sphere towards the
    // centre. The color of the points on the sphere is transfered to the points
    // where the lines intersects the object.

    //The CreateWrap command is discussed on page 168
    DXDraw.D3DRM.CreateWrap(D3DRMWRAP_SPHERE,     //wrap type
      nil,                                        //Frame we apply the Wrap to
      0, 0, 0,   //Origin of Wrap ox, oy, oz
      0, 0, 1,   //Z axis dx, dy, dz
      0, 1, 0,   //Y axis ux, uy, uz
      0, 0,      //Texture origin ou, ov
      1, 1,      //Texture scale factor su, sv
      Wrap
    );

    //in this case we apply one of two wrap commands Wrap.apply
    //The other one is discussed in the following  Wrap.ApplyRelative
    wrap.Apply(Mesh[objectnr]);  //wrap the surface on to the object
  end
  else
  begin

    if WrapType[objectnr]=D3DRMWRAP_CHROME
    then
    begin
      //See page 171 in the Awesome Power of Direct3D/DirectX
      //Once again we put an imaginary textured sphere around the object.
      //Lines are drawn from the orego of the frame to each point on the surface
      //of the 3D-object. The ray is reflected as given by the normal to the point
      //on the surface of the object. Then we follow the reflected ray. The color
      //is picked from the point where the reflected ray intersects the imaginary
      //sphere, and this color is painted on the point on the 3D-object which
      //reflected the ray.
      DXDraw.D3DRM.CreateWrap(D3DRMWRAP_CHROME,   //Wrap type
        DXDraw.Camera,    //Frame we apply the wrap to (here the camera frame)
        0, 0, 0,          //Origin of wrap ox, oy, oz
        0, 0, 1,          //Z axis dx, dy, dz
        0, 1, 0,          //Y axis ux, uy, uz
        0, ov,            //Texture origin ou, ov
        1, sv,            //Texture scale factor su, sv
        Wrap
      );

      //And we see that it is the ApplyRelative command which is used
      wrap.ApplyRelative(MeshFrame[SeriesNr, objectnr], //frame object
                          Mesh[objectnr]);    //3D wrap object
    end
    else
    begin
      //For the two remaining wrap types D3DRMWRAP_FLAT og D3DRMWRAP_CYLINDER
      //the texture is transfered like wrapping it in rubber.

      //D3DRMWRAP_FLAT: The texture is transfered like drawing a slap of rubber
      //onto the 3D-object.

      //D3DRMWRAP_CYLINDER: A virtual cylinder is surrounding the object. Lines
      //are drawn from the wall of the cylinder towards the axis of rotation.
      //The colors in the points on the surface of the cylinder are transfered
      //to the points of intersection on the object.
      //This technic is the most common.

      DXDraw.D3DRM.CreateWrap(WrapType[objectnr],//D3DRMWRAP_FLAT or D3DRMWRAP_CYLINDER
        nil,       //Frame we apply the wrap to
        0, 0, 0,   //Origin of wrap ox, oy, oz
        0, 0, 1,   //Z axis dx, dy, dz (e.g. the axis of symmetri of the cylinder)
        0, 1, 0,   //Y axis ux, uy, uz
        0, ov,     //Texture origin ou, ov
        1, sv,     //Texture Scale factor su, sv
        Wrap
      );
      wrap.Apply(Mesh[objectnr]);  //Apply the texture onto the mesh
    end;
  end;
end;





procedure Tmainform.make_bullet_mesh;
var
  Meshbuilder : IDirect3DRMMeshBuilder;
  bullet_filename : string;
  box: TD3DRMBOX;
begin
  {  Mesh making  }
  DXDraw.D3DRM.CreateMeshBuilder(MeshBuilder);

  bullet_Filename := ExtractFilePath(Application.ExeName) + 'Sphere.x';

  ChDir(ExtractFilePath(bullet_FileName));

  //Build the object by loading a directX object
  //See page 87 in the Awesome Power of Direct3D/DirectX
  MeshBuilder.Load(PChar(bullet_FileName),
    nil,
    D3DRMLOAD_FROMFILE,
    nil,
    nil);

  //The bullet is relatively small
  MeshBuilder.Scale(0.1, 0.1, 0.1);

  meshBuilder.CreateMesh(bullet_mesh);

  meshbuilder := nil;

  //calculate the BulletRadius and set the maximal distance of the bullets
  bullet_mesh.GetBox(box);
  with CollisionTester3DX1 do
  begin
    BulletRadius := round((box.max.y - box.min.y)/2);
    BulletRange := 150; //maximal flying range of the bullets is defined
  end;
end;



//make the floor
procedure TmainForm.Make_Floor;
var
  i, j, k : integer;
  plane_builder : IDirect3DRMMeshBuilder3;
  plane_wrap : IDirect3DRMWRAP;
begin
  {create the frame for the floor}
  DXDraw.D3DRM.CreateFrame(DXDraw.Scene, floor_frame);

  {rotate the floor frame pi around the xaxis}
  Floor_frame.AddRotation(D3DRMCOMBINE_BEFORE, D3DVAL(1.0), D3DVAL(0.0),
                          D3DVAL(0.0), D3DVAL(pi) );


  {position the floor frame}
  Floor_frame.SetPosition(DXDRAW.Scene, D3DVAL(0.0), D3DVAL(0.0), D3DVAL(20.0));

  {load textures for the Scene objects}
  DXDraw.D3DRM.LoadTexture(Pchar(ExtractFilePath(Application.ExeName) +
                           'S_ave148.bmp'), brick_tex);

  DXDraw.D3DRM.LoadTexture(Pchar(ExtractFilePath(Application.ExeName) +
                           'W_stone.bmp'), stone_tex);

  DXDraw.D3DRM.LoadTexture(Pchar(ExtractFilePath(Application.ExeName) +
                           'grass3a.bmp'), grass_tex);

  {create material}
  DXDraw.D3DRM.CreateMaterial(D3DVAL(16.0), mat);


  {  Mesh making  }
  //see page 84 og 139 in the Awesome Power of Direct3D/DirectX

  {initialise trans}
  feld(8, trans);

  //loop which creates the floor
  for i := 0 to (gTileX - 1) do
  begin
    for j := 0 to (gTileY - 1) do
    begin
      //it is important to reset VisGFeld to zero from the beginning
      //to obtain a visible floor when the screenmode is changed
      //This command was missing in the Awesome Power of Direct3D/DirectX
      VisGFeld[i, j] := 0;

      For k := 0 to 4 do
      begin
        Plane_Builder := nil;
        plane_wrap := nil;

        DXDraw.D3DRM3.CreateMeshBuilder(Plane_Builder);

        Build_Plane(plane_builder, i, j, k);

        {set render quality}
        Plane_Builder.SetQuality(Quality);

        Plane_builder.CreateMesh(ground_meshes[i, j, k]);

        if i < (gTileX - 1)
        then
        begin
          ground_meshes[i, j, k].SetGroupTexture(D3DRMGROUP_ALLGROUPS, brick_tex);

          DXDraw.D3DRM.CreateWrap(D3DRMWRAP_FLAT,
             nil,        //the frame we apply the wrap to
             0, 0, 0,    //origin of wrap ox, oy, oz
             0, 1, 0,    //Z axis dx, dy, dz for wrap
             0, 0, 1,    //Y axis ux, uy, uz for wrap
             0, 0,       //Texture origin ou, ov
             1.2, -1.2,  //Texture scale factor su, sv
             wrap);

          wrap.apply(ground_meshes[i, j, k]);
        end
        else
        begin
          ground_meshes[i, j, k].SetGroupTexture(D3DRMGROUP_ALLGROUPS, grass_tex);

          DXDraw.D3DRM.CreateWrap(D3DRMWRAP_FLAT,
             nil,        //the frame we apply the wrap to
             0, 0, 0,    //origin of wrap ox, oy, oz
             0, 1, 0,    //Z axis dx, dy, dz for wrap
             0, 0, 1,    //Y axis ux, uy, uz for wrap
             D3DVAL(j * (points_Ysize - 1) * m_step/1024), 0, //Texture origin ou, ov
             0.025, -0.1,  //Texture scale factor su, sv
             wrap);

          wrap.apply(ground_meshes[i, j, k]);
        end;



        ground_meshes[i, j, k].SetGroupMaterial(D3DRMGROUP_ALLGROUPS, mat);


        Plane_Builder.SetColorRGB(D3DVAL(1.0), D3DVAL(1.0), D3DVAL(1.0) );


        Plane_Builder := nil;


      end; //end for K
    end;  //end j loop
  end;  //end i loop


  //Set texture resolution of the tiles
  GroundCheck(Floor_frame, 0);



end;




//Create a wall
procedure TmainForm.make_wall;
var
  wall_builder : IDirect3DRMMeshBuilder;
  wall_wrap : IDirect3DRMWRAP;
  wall_tex : IDirect3DRMTexture;
  mat : IDirect3DRMMATERIAL;
begin

  DXDraw.D3DRM.CreateFrame(DXDraw.Scene, MeshFrame[FixedSeries,
                           (number_of_fixed_objects - 1)]);

  {load texture for the wall}
  DXDraw.D3DRM.LoadTexture(Pchar(ExtractFilePath(Application.ExeName) +
                           'wall_1.bmp'), wall_tex);

  {create material}
  DXDraw.D3DRM.CreateMaterial(D3DVAL(16.0), mat);

  wall_Builder := nil;
  wall_wrap := nil;

  DXDraw.D3DRM.CreateMeshBuilder(wall_Builder);

  wall_builder.Load(Pchar(ExtractFilePath(Application.ExeName) + 'wall_2.x'),
                     nil, D3DRMLOAD_FROMFILE, nil, nil);

  {set render quality}
  wall_Builder.SetQuality(Quality);

  {scale the wall}
  wall_builder.Scale(1.0, 1.5, 2.0);

  //create the mesh
  wall_builder.CreateMesh(wall_mesh);

  wall_mesh.SetGroupTexture(D3DRMGROUP_ALLGROUPS, wall_tex);

  {supply material}
  wall_mesh.SetGroupMaterial(D3DRMGROUP_ALLGROUPS, mat);

  wall_Builder.SetColorRGB(D3DVAL(1.0), D3DVAL(1.0), D3DVAL(1.0) );

  DXDraw.D3DRM.CreateWrap(D3DRMWRAP_FLAT,
             nil,        //the frame we apply the wrap to
             0, 0, 0,    //origin of wrap ox, oy, oz
             0, 1, 0,    //Z axis dx, dy, dz for wrap
             0, 0, 1,    //Y axis ux, uy, uz for wrap
             0, 0,       //Texture origin ou, ov
             2, 0.2,     //Texture scale factor su, sv
             wall_wrap);

  //wrap the wall mesh
  wall_wrap.apply(wall_mesh);

  //make the wall visible
  MeshFrame[FixedSeries,(number_of_fixed_objects - 1)].AddVisual(wall_mesh);

  //Free memory used to build the wall
  wall_Builder := nil;
  wall_wrap := nil;

  //Finally position the wall
  MeshFrame[FixedSeries,(number_of_fixed_objects - 1)].SetPosition
                        (DXDraw.Scene,
                         D3DVAL(40),
                         -D3DVAL(1), //0
                         D3DVAL(2 * m_step * (Points_Ysize - 1)) );

  //Add a collision object surrounding the wall
  with collisionTester3DX1 do
  begin
    FrameSeries := MeshFrame;
    NextAddMesh := Wall_Mesh;
    IndexOf3DSeries := FixedSeries;
    IndexOf3DObject := (number_of_fixed_objects - 1);
    Indexof3DElement := (number_of_fixed_objects - 1);
    CollObjectType := Box3D; //use a box shaped collision object
    CollOrientation := symmetric_y;
    CollObjMaterial := Solid3D; //the wall is made of a solid material
    PickAble := false;
    ShootAble := false;
    Fixed3DObject := true; //the wall does not move
    CoverWholeMesh := true; //one collision object is used for the whole wall
    //Add the collision object
    AddCollisionObject;
  end;


end;




//Common procedure for making 3D objects
procedure TmainForm.make_3D_object(SeriesNr, objectnr : shortint; symaxis : TOrientation3D);
var
  image: IDirect3DRMTexture;
  Meshbuilder : IDirect3DRMMeshBuilder;
  box : TD3DRMbox;
begin
  {create a frame for the 3D-object}
  DXDraw.D3DRM.CreateFrame(DXDraw.Scene, MeshFrame[SeriesNr, objectnr]);  //Object frame

  //Place the Mesh frame in the referenceframe DXDraw.scene with its origo at
  MeshFrame[SeriesNr, objectnr].SetPosition(DXDraw.Scene,
        object_position[objectnr].x,
        object_position[objectnr].y,
        object_position[objectnr].z);

  //Orientate the Mesh frame(Reference frame, Mesh-frame z-axis, Mesh-frame y-axis
  MeshFrame[SeriesNr, objectnr].SetOrientation(DXDraw.Scene,
        object_direction[objectnr].x,
        object_direction[objectnr].y,
        object_direction[objectnr].z,
        0.0, 1.0, 0.0);  //normal orientation

  //The SetRotation command instructs a stepwise rotation of the respective frame
  //when calling MeshFrame.move (see page 77 i the Awesome Power of Direct3D/DirectX.
  //(reference frame DXDraw.scene, axis of rotation rvx, rvy, rvz and
  //an angular increment in radians rvTheta)
  MeshFrame[SeriesNr, objectnr].SetRotation(DXDraw.Scene, 0.0, 1.0, 0.0, 0.05);

  {  Mesh making  }
  //see page 84 and page 139 in the Awesome Power of Direct3D/DirectX
  DXDraw.D3DRM.CreateMeshBuilder(MeshBuilder);

  ChDir(ExtractFilePath(object_FileName[objectnr]));

  //Build the object mesh by loading an directX object
  //See page 87 in the Awesome Power of Direct3D/DirectX
  MeshBuilder.Load(PChar(object_FileName[objectnr]),  //the File with the object
    nil,
    D3DRMLOAD_FROMFILE, //load from file  see the other possibilities at page 87
    nil,
    nil);

  //Scale the 3D-object evenly in all directions 3X
  //E.g. see page 92 in the awesome power of direct3D/directX
  MeshBuilder.Scale(object_scale[objectnr],
                    object_scale[objectnr],
                    object_scale[objectnr]);

  //Load the texture for the surface (see pages 90 and 166 in the Awesome Power of Direct3D)
  //Alternatively, it is possible to use the command LoadTextureFromResource
  //to load the texture if a resource rs exists (see page 167 in the Awesome
  //Power of Direct3D/DirectX).
  //The bitmap must be rectangular (normally kvadratic) with a point resolution
  //of 1, 2, 4, 8, 16, 32, 64, 128 eller 256.
  //The number of colors must be 8, 24 or 32 bit (see page 167 in the AweSome Power of Direct3D/DirectX)
  DXDraw.D3DRM.LoadTexture(Pchar(object_texture_filename[objectnr]),//bitmap-fil
             image);  //image is the name of the texture formed

  //Supply the meshbuilder with the loaded texture named image
  MeshBuilder.SetTexture(image);

  //It is also common to describe the materiale. E.g. see the command
  //CreateMaterial(vPower, matname) on page 168 in the AweSome Power of Direct3D
  //vPower describes how reflacting the material is. A value of 5 gives a metallic
  //look - 15 a relatively neutral look and even larger values a plastic look.
  //Subsequently the command Meshbuilder.SetMaterial(matname) is applied.
  //obs. matname must be of the type LPDIRECT3DRMATERIAL (see page 168)

  //Finally the mesh builder creates the object mesh
  //see page 139 in the Awesome Power of Direct3D/DirectX
  meshBuilder.CreateMesh(mesh[objectnr]); //creates 3D-mesh in the addresse mesh

  //free the mesh builder
  meshbuilder := nil;

  //Now we make the mesh visible in the frame MeshFrame
  //see page 158 in the Awesome power of Direct3D/DirectX
  MeshFrame[SeriesNr, objectnr].AddVisual(mesh[objectnr]);

  //wrapping the texture onto the 3D-object
  if wrap_3D_objects then CreateWarp(SeriesNr, objectnr);



  Mesh[objectnr].GetBox(box);

  //introduce the shadow on the floor
  //the shadow is flush with the bottom of the 3D-object
  //object_position[objectnr].y is the y value of the position of the meshframe
  //in the sceen
  DXDraw.D3DRM.CreateShadow(mesh[objectnr], ShadowLight,
             Box.min.x, (Box.min.y + object_position[objectnr].y), Box.min.z,
             D3DVAL(0), D3DVAL(1), D3DVAL(0),
             myShadow[objectnr]);

  //show the shadow of the 3D-object
  MeshFrame[SeriesNr, objectnr].AddVisual(myShadow[objectnr]);



  //add a collision detection
  with collisionTester3DX1 do
  begin
    FrameSeries := MeshFrame;
    NextAddMesh := Mesh[objectnr];
    IndexOf3DSeries := SeriesNr;
    IndexOf3DObject := objectnr;
    Indexof3DElement := objectnr;
    CollObjectType := CollType[objectNr];
    CollOrientation := symaxis; //orientation of the box
    CollObjMaterial := Solid3D; //the object is made of a solide material
    PickAble := false; //it is not possible to pick the object
    ShootAble := true; //it is possible to shoot the object
    Fixed3DObject := true; //the object does not translate
    CoverWholeMesh := false; //The collisionobject does not necessarily cover all
    //never the same we choose to cover the whole object (it is just to demonstrate)
    BoxPartMin(box.min.x, box.min.y, box.min.z); //the box specifies the part
    BoxPartMax(box.max.x, box.max.y, box.max.z); //of the object which is covered
    AddCollisionObject;  //add the collision object
  end;


  //initialize the hit_counter
  nr_hits_3D_object[objectnr] := 0;

end;



//Initialisation of DXDraw
procedure TMainForm.DXDrawInitialize(Sender: TObject);
var
  objectnr : shortint;
begin

  //ZeroSet the collisionTester
  //This command must always be included with DXDrawInitialize if this procedure
  //is called more than once.
  //In this case DXDraw is initialised when shifting between windows mode and
  //full screen mode.
  CollisionTester3DX1.ZeroSetIt;


  //do3D
  if do3D in DXDraw.Options
  then
    DXDraw.Options := DXDraw.Options
  else
    DXDraw.Options := DXDraw.options + [do3D];


  //Use Zbuffering to remove hidden surfaces
  if doZBuffer in DXDraw.Options
  then
    DXDraw.Options := DXDraw.Options
  else
    DXDraw.Options := DXDraw.options + [doZBuffer];


  {  Frame making  }
  //Create frames for the light source and the objects in the 3D scene.
  //See page 71 i the Awesome power of Direct3D/DirectX
  DXDraw.D3DRM.CreateFrame(DXDraw.Scene, LightFrame);


  {  Light setting  }
  //We choose to have light source which supply directed light = D3DRMLight_Directional
  //(see page 64 i the Awesome Power of Direct3D/DirectX)
  //The last quantity in the parantesis is the name of the variable which we
  //may choose freely.
  DXDraw.D3DRM.CreateLightRGB(D3DRMLIGHT_DIRECTIONAL, 0.8, 0.8, 0.8, Light);
  //Add the directed light
  LightFrame.AddLight(Light);

  //Furthermore add some ambient light
  DXDraw.D3DRM.CreateLightRGB(D3DRMLIGHT_AMBIENT, fraction_ambient,
  fraction_ambient, fraction_ambient, AmbientLight);  //fraction_ambient is vari
  //add the diffuse light
  DXDraw.Scene.AddLight(AmbientLight);

  //Finally add a shadow casting light
  DXDraw.D3DRM.CreateFrame(DXDraw.Scene, ShadowLightFrame);
  ShadowLightFrame.Setposition(DXDraw.Scene, D3DVAL(20), D3DVAL(50), -D3DVAL(20));
  DXDraw.D3DRM.CreateLightRGB(D3DRMLIGHT_POINT, 0.9, 0.8, 0.7, ShadowLight);
  ShadowLightFrame.AddLight(ShadowLight);

  //Place the camera (see page 91 in the Awesome Power of Direct3D/DirectX
  DXDraw.Camera.SetPosition(DXDraw.Scene,      //the reference frame
                            camera_position.x, //x relative to this
                            camera_position.y, //y relative to this
                            camera_position.z);//z relative to this

  //Orientating the camera (see page 468 in the Awesome Power of Direct3D/DirectX
  DXDraw.Camera.SetOrientation(DXDraw.Scene,   //frame which should be oriented
                            camera_direction.x, //Desired direction of z axis
                            camera_direction.y,
                            camera_direction.z,
                            camera_up.x,        //Desired direction of y-axis
                            camera_up.y,
                            camera_up.z);

  //place the camera light
  place_camera_spotlight(camera_position, camera_xaxis, camera_up,
                         camera_light_position);

  {************* GENERATE the FLOOR and the WALL ********************}
  {generate the floor}
  make_floor;

  {create the wall}
  number_of_fixed_objects := 1;
  SetLength(MeshFrame[FixedSeries], number_of_fixed_objects);
  make_wall;

  {************* make the bullet ***********************}
  make_bullet_mesh;
  //initialize number of bullets
  number_of_bullets := 0;


  //set DXDraw for CollisionTester3DX
  with CollisionTester3DX1 do
  begin
    DXDrawUsed := DXDraw;
    FrameSeries := MeshFrame;
    HeadRadius := 1;
    CollisionCheckAll := true;
    FrontDistance := 0;
  end;

  {************** Insertion of mesh objects *************}
  //remember to set the length before adding new objects
  SetLength(Mesh, number_of_3D_objects);
  SetLength(MeshFrame[shootableseries], number_of_3D_objects);
  SetLength(MyShadow, number_of_3D_objects);
  setlength(nr_hits_3D_object, number_of_3D_objects);

  //rebuild mesh and meshframe
  for objectnr := 0 to (number_of_3D_objects - 1) do
  begin
    //In this case all objects are oriented along the x axis
    //Normally one would remember the orientation of each object in an array
    make_3D_object(ShootableSeries, objectnr, symmetric_x);

  end;


  {******* Finished the insertion of 3D-objects ***********}

  //enable timer which activates the rotation and wrapping of the 3D objects
  timer1.enabled := true;


  //Enable the timer controlling the animation
  DXTimer.Enabled := True;
end;




//Free memory used for 3D
procedure TMainForm.DXDrawFinalize(Sender: TObject);
var
  i, j, k : shortint;
begin

  DXTimer.Enabled := False;  //stop the timer

  //stop the insertion of new objects
  timer2.enabled := false;

  Wrap := nil;

  lightframe := nil;
  ShadowLightFrame := nil;
  floor_frame := nil;
  //FixedSeries
  wall_mesh := nil;
  MeshFrame[FixedSeries, 0] := nil; //wall_frame

  ShadowLight := nil;
  Light := nil;
  AmbientLight := nil;
  mat := nil;
  nr_hits_3D_object := nil;

  //ShootableSeries
  for i := 0 to (number_of_3D_objects - 1) do
  begin
    MyShadow[i] := nil;
    Mesh[i] := nil;
    MeshFrame[ShootableSeries, i] := nil;
  end;

  for i := 0 to (gTileX - 1) do
  begin
    for j := 0 to (gTileY - 1) do
    begin
      For k := 0 to 4 do
        ground_meshes[i, j, k] := nil;
    end;
  end;

  for i := 0 to (number_of_bullets - 1) do
  begin
    bullet_frame[i] := nil;
  end;

  number_of_bullets := 0;

  bullet_mesh := nil;


  {Dont free the memory used by dynamic arrays created during initialize
  as we will loose all information about the settings for the objects
  WrapType := nil;
  object_position := nil;
  object_direction := nil;
  object_scale := nil;
  object_texture_filename := nil;
  object_FileName := nil;
  }


end;




//Quality of rendering
procedure TMainForm.DXDrawInitializeSurface(Sender: TObject);
begin
  //use hardware rendering
  if doHardware in DXDraw.NowOptions then
  begin
    {  Bi-linear filtering  }
    DXDraw.D3DRMDevice.SetTextureQuality(D3DRMTEXTURE_LINEAR);
  end;

  {  Alpha blending  }
  DXDraw.D3DRMDevice2.SetRenderMode(D3DRMRENDERMODE_BLENDEDTRANSPARENCY or
                     D3DRMRENDERMODE_SORTEDTRANSPARENCY);
end;




//Timer controlling the animation
procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
const
  DeviceText: array[Boolean] of string =
    ('Software', 'Hardware');
  WrapText: array[D3DRMWRAP_FLAT..D3DRMWRAP_CHROME] of string =
    ('Wrap is flat', 'Wrap is cylindrical', 'Wrap is spherical', 'Wrap is chrome');
var
  bullet_frame_nr : integer;
  s: string;
  r: TRect;
  hit_object_nr, objectnr : shortint;
  bullet_lost : boolean;
begin
  if not DXDraw.CanDraw then exit;

  DXtimer.enabled := false;

  Check_keyboard_and_joystick;

  //update the floor
  GroundCheck(Floor_frame, 0);

  //If the command  MeshFrame.SetRotation(DXDraw.Scene, 0.0, 1.0, 0.0, 0.05) has
  //been used, then calling the command - move - starts a rotation of dTheta
  // =0.05 radians around 0,1,0

  for objectnr := 0 to (number_of_3D_objects - 1) do
  begin
    if rotate_3D_object
    then
      MeshFrame[ShootableSeries, objectnr].Move(1.0);
  end;


  //The SetVelocity command is used to set the velocity of the camera frame.
  //The frame moves with the selected speed when the command move is used.
  //see page 478 in the Awesome Power of Direct3D/DirectX

  //remember the position of the Eye before moving it
  CollisionTester3DX1.GetOldEyePos;

  DXDraw.Camera.move(1.0);

  //Check for collision
  with CollisionTester3DX1 do
  begin
    //check for collision with members of FixedSeries
    IndexOf3DSeries := FixedSeries;
    CollisionCheckAll := true;

    if number_of_fixed_objects > 0
    then
    begin
      if CollisionTester3DX1.collision
      then
      begin
        //it is not possible to pass solid objects
        if CollObjMaterial = solid3D
        then
        begin
          //stop moving
          stopmove;
          //step one step backward
          Make_Retreat;
          DXDraw.Camera.move(1.0);
          //and stand still
          stopmove;
        end;
      end;
    end; //end of if number_of....

    //check for collision with members of ShootableSeries
    IndexOf3DSeries := ShootableSeries;
    CollisionCheckAll := true;


    if number_of_3D_objects > 0
    then
    begin
      if CollisionTester3DX1.collision
      then
      begin
        //it is not possible to pass solid objects
        if CollObjMaterial = solid3D
        then
        begin
          //stop moving
          stopmove;
          //step one step backward
          Make_Retreat;
          DXDraw.Camera.move(1.0);
          //and stand still
          stopmove;
        end;
      end;
    end;  //end of if number_of...
    //no more series to test
  end;



  //check whether bullets hits anything
  if (number_of_bullets > 0)
  then
  begin
    bullet_lost := false;
    bullet_frame_nr := 0;


    while (bullet_frame_nr <= (number_of_bullets - 1)) do
    begin
      //tell the tester about the bulletframe
      CollisionTester3DX1.BulletFrame := Bullet_Frame[Bullet_Frame_Nr];

      //remember the position of the bullet before moving it
      CollisionTester3DX1.GetOldBulletPos;

      //move the bullet
      bullet_frame[Bullet_Frame_Nr].move(1.0);

      //play sound of misil if a new bullet was fired
      if fire_misil
      then
      begin
        if CollisionTester3DX1.LongShots
        then
          DXWaveList1.Items[3].Play(false)  //gun shot - the system hangs if true
        else
          DXWaveList1.Items[1].Play(false); //misil - the system hangs if true

        fire_misil := false;
      end;

      //remove bullet if it is dead
      if collisionTester3DX1.BulletDead and (not collisionTester3DX1.LongShots)
      then
      begin
        bullet_lost := remove_bullet_frame(Bullet_Frame_Nr);
      end
      else
      begin
        //check for collision with members of the FixedSeries
        //however if longshots then only look for shootables
        bullet_lost := false;

        if (number_of_fixed_objects > 0) and (not CollisionTester3DX1.Longshots)
        then
        begin
          with collisionTester3DX1 do
          begin
            IndexOf3DSeries := FixedSeries;
            CollisionCheckAll := true;

            if CollisionTester3DX1.BulletCollision
            then
            begin
              //bullet is dead if solid object
              if CollObjMaterial = solid3D
              then
              begin
                hit_object_nr := CollisionTester3DX1.HitLinkNr;
                bullet_lost := remove_bullet_frame(bullet_frame_nr);
              end;
            end; //end if bulletcollision
          end;  //finished with fixed series
        end; //end of if ....


        if (not bullet_lost) and (number_of_3D_objects > 0)
        then
        begin
          //Bullet is not dead yet
          //Check for collision with the shootable series
          with CollisionTester3DX1 do
          begin
            IndexOf3DSeries := ShootableSeries;
            CollisionCheckAll := true;

            if CollisionTester3DX1.BulletCollision
            then
            begin
              hit_object_nr := CollisionTester3DX1.HitLinkNr;

              //increment hit counts for the 3D-object
              inc(nr_hits_3D_object[hit_object_nr]);

              if nr_hits_3D_object[hit_object_nr] >= max_hits
              then
              begin
                CollisionTester3DX1.NextDestroyNr := hit_object_nr;

                //remove the 3Dobject before removing the coll object
                bullet_lost := explode_3Dobject_and_bullet(bullet_frame_nr, hit_object_nr);
                //remove the corresponding coll object if the object was removed
                if bullet_lost
                then
                  CollisionTester3DX1.DestroyCollisionObject;


              end
              else
                bullet_lost := remove_bullet_frame(bullet_frame_nr);

            end; //end if bulletcollision


          end; //finished with shootable series

        end; //end if bullet still is alive

        //remove longshots
        if CollisionTester3DX1.LongShots and (not bullet_lost)
        then
          bullet_lost := remove_bullet_frame(bullet_frame_nr);

      end; //end bullet is not at dead distance


      if not bullet_lost then inc(bullet_frame_nr);

    end; //end of while bullets left
  end; //end of checking for bullet collisions


  //insertion of new 3Dobjects should be controlled by DXtimer
  if insert_a_new_3Dobject
  then
  begin
    introduce_a_new_3Dobject;

    insert_a_new_3Dobject := false;
  end;


  DXDraw.Viewport.ForceUpdate(0, 0, DXDraw.SurfaceWidth, DXDraw.SurfaceHeight);

  //The command render is discussed at page 287 in the Awesome Power of Direct3D/DirectX
  DXDraw.Render;


  game_finished := game_finished or (number_of_3D_objects = 0);

  if game_finished
  then
  begin
    //stop the insertion of new objects
    timer2.enabled := false;

    if number_of_3D_objects = 0
    then
      s := 'Congratulations - You win'
    else
      s := 'Sorry - You lost the game';

    r := DXDraw.Surface.ClientRect;

    with DXDraw.Surface.Canvas do
    begin
      Brush.Style := bsClear;
      Font.Color := clWhite;
      Font.Size := 24;
      DrawText(Handle, PChar(s), Length(s), r, DT_CENTER or DT_NOCLIP);

      Release; {  Indispensability  }
    end;

    if not nosteps
    then
    begin
      //stop the sound of footsteps playing
      nosteps := true;
      DXWaveList1.Items[0].stop;
      stopmove;
    end;
  end;


  DXDraw.Flip;    //Update the screen

  DXTimer.enabled := not game_finished;
end;






procedure TMainForm.FormCreate(Sender: TObject);
begin

  //position of the camera
  camera_position.x := 0;   {Hori -5.0; }
  camera_position.y := 1;   {Eye-level of person} {Hori 10.0;}
  camera_position.z := -10; {Hori 0.0;}

  //Orientation of the camera (see page 468 in the Awesome Power of Direct3D/DirectX
  //camera frame z-axis
  camera_direction.x := 0;   {Hori 0.35;}
  camera_direction.y := 0;   {Hori -0.65;}
  camera_direction.z := 1.0;

  //camera frame y axis
  camera_up.x := 0;   {Hori -0.15;}
  camera_up.y := 1.0;
  camera_up.z := 0;   {Hori 0.5;}

  //camera frame x-axis
  camera_xaxis.x := 1.0;
  camera_xaxis.y := 0;
  camera_xaxis.z := 0;


  fraction_ambient := 0.9; {0.9  fraction of ambient light}

  //Get the list of the initial 3D objects
  get_list_of_3D_objects;

  next_wraptype := D3DRMWRAP_CYLINDER;

  {initialize random numbergenerator used by object insertion}
  randomize;

  //Try to initialize the Hardware_counter
  HardwareCounter_available := Initialize_HardwareCounter;

  //sound related initializations
  //footsteps
  nosteps := true;
  DXWaveList1.Items[0].looped := true;

  //missil
  fire_misil := false;
  DXWaveList1.Items[1].looped := false;

  //kanon
  DXWaveList1.Items[2].looped := false;

  //gun shot
  DXWaveList1.Items[3].looped := false;
  firing_bullet := false;
  HWCountNextBulletAllowed := 0;

  //status of game
  game_finished := false;
  insert_a_new_3Dobject := false;

  max_hits := 1;
  radiogroup1.itemindex := 0;

  //longshots is false
  CollisionTester3DX1.Longshots := false;
  checkbox1.checked := false;
end;






function TmainForm.remove_bullet_frame(bullet_frame_nr : integer): boolean;
var
  i : integer;
  rval : HRESULT;
begin
  //remove the bullet
  rval := bullet_frame[bullet_frame_nr].DeleteVisual(Bullet_mesh);

  if rval = D3DRM_OK
  then
  begin
    Bullet_frame[bullet_frame_nr] := nil;

    //shift the bullet frames
    for i := bullet_frame_nr to (number_of_bullets - 1 - 1) do
    begin
      bullet_frame[i] := bullet_frame[i + 1];
    end;

    dec(number_of_bullets);
    bullet_frame := copy(Bullet_frame, 0, number_of_bullets);

    //succeded in removing the bullet
    result := true;
  end
  else
    result := false;

end;




function TmainForm.explode_3Dobject_and_bullet(bullet_frame_nr,
                                                hit_object_nr : integer): boolean;
var
  i : integer;
  rval, rval2, rval3 : HRESULT;
begin
  //remove the object which was hit
  rval := MeshFrame[ShootableSeries, hit_object_nr].DeleteVisual(mesh[hit_object_nr]);
  rval2 := MeshFrame[ShootableSeries, hit_object_nr].DeleteVisual(MyShadow[hit_object_nr]);

  if rval = D3DRM_OK
  then
  begin
    //play sound of explosion
    DXWaveList1.Items[2].Play(false);  //the system hangs if true

    //the 3D object was deleted from the screen
    MyShadow[hit_object_nr] := nil;
    Mesh[hit_object_nr] := nil;
    MeshFrame[Shootableseries, hit_object_nr] := nil;

    //shift the content of the arrays
    for i := hit_object_nr to (number_of_3D_objects - 1 - 1) do
    begin
      MeshFrame[ShootableSeries, i] := MeshFrame[ShootAbleSeries, (i+1)];
      Mesh[i] := Mesh[i+1];
      MyShadow[i] := MyShadow[i+1];
      WrapType[i] := WrapType[i+1];
      object_position[i] := object_position[i+1];
      object_direction[i] := object_direction[i+1];
      object_scale[i] := object_scale[i+1];
      object_texture_filename[i] := object_texture_filename[i+1];
      object_filename[i] := object_filename[i+1];
      nr_hits_3D_object[i] := nr_hits_3D_object[i+1];
      CollType[i] := CollType[i+1];
    end;

    //change the length of the dynamic arrays
    dec(number_of_3D_objects);
    Mesh := Copy(Mesh, 0, number_of_3D_objects);
    MyShadow := Copy(MyShadow, 0, number_of_3D_objects);

    MeshFrame[ShootableSeries] := Copy(MeshFrame[ShootableSeries], 0, number_of_3D_objects);
    WrapType := Copy(WrapType, 0, number_of_3D_objects);
    object_position := Copy(object_position, 0, number_of_3D_objects);
    object_direction := Copy(object_direction, 0, number_of_3D_objects);
    object_scale := Copy(object_scale, 0, number_of_3D_objects);
    object_texture_filename := Copy(object_texture_filename, 0, number_of_3D_objects);
    object_filename := Copy(object_filename, 0, number_of_3D_objects);
    nr_hits_3D_object := copy(nr_hits_3D_object, 0, number_of_3D_objects);
    CollType := copy(CollType, 0, number_of_3D_objects);

    //remove the bullet
    rval3 := bullet_frame[bullet_frame_nr].DeleteVisual(Bullet_mesh);

    if rval3 = D3DRM_OK
    then
    begin
      Bullet_frame[bullet_frame_nr] := nil;

      //shift the bullet frames
      for i := bullet_frame_nr to (number_of_bullets - 1 - 1) do
      begin
        bullet_frame[i] := bullet_frame[i + 1];

      end;

      dec(number_of_bullets);
      bullet_frame := copy(Bullet_frame, 0, number_of_bullets);
    end;

    result := true; //succeeded in removing the object
  end
  else
    result := false; //did not succeed in removing the 3Dobject
end;







procedure TMainForm.Timer1Timer(Sender: TObject);
var
  i : integer;
begin
  timer1.enabled := false;

  //do wrap the 3D objects from the beginning
  wrap_3D_objects := true;
  for i := 0 to (number_of_3D_objects - 1) do createWarp(shootableSeries, i);

  //rotate the 3D-objects from the start
  rotate_3D_object := true;

  //set timing interval for insertion of new objects depending on game mode
  if  doFullScreen in DXDraw.Options
  then
    timer2.interval := 5000   //insert new objects quickly in fullscreenmode
  else
    timer2.interval := 10000;


  timer2.enabled := true;
end;



procedure TMainForm.Timer2Timer(Sender: TObject);
begin
  insert_a_new_3Dobject := true;
end;


procedure Tmainform.introduce_a_new_3Dobject;
var
  selec : integer;
  xnow, znow : integer;
begin

  game_finished := game_finished or (number_of_3D_objects >= 10);

  inc(number_of_3D_objects);

  SetLength(Mesh, number_of_3D_objects);
  SetLength(MeshFrame[shootableSeries], number_of_3D_objects);
  SetLength(MyShadow, number_of_3D_objects);
  SetLength(WrapType, number_of_3D_objects);
  SetLength(object_position, number_of_3D_objects);
  SetLength(object_direction, number_of_3D_objects);
  SetLength(object_scale, number_of_3D_objects);
  SetLength(object_texture_filename, number_of_3D_objects);
  SetLength(object_Filename, number_of_3D_objects);
  SetLength(nr_hits_3D_object, number_of_3D_objects);
  SetLength(CollType, number_of_3D_objects);

  //find a free location for placing the object
  repeat
    xnow := random(6);
    znow := random(6);
  until not populated[xnow, znow];

  populated[xnow, znow] := true;

  object_position[number_of_3D_objects-1].x := 10 * (xnow - 3);
  object_position[number_of_3D_objects-1].z := 10 * (znow - 1);


  object_direction[number_of_3D_objects - 1].x := 0.0;
  object_direction[number_of_3D_objects - 1].y := 0.0;
  object_direction[number_of_3D_objects - 1].z := 1.0;


  object_texture_filename[number_of_3D_objects-1] :=
                           ExtractFilePath(Application.ExeName) + 'lake.bmp';


  selec := random(5);
  case selec of
  0 : begin
        object_FileName[number_of_3D_objects-1] := ExtractFilePath(Application.Exename) +
                'Egg.x';
        object_scale[number_of_3D_objects-1] := 3;
        object_position[number_of_3D_objects - 1].y := 3.18 + lift; //0.0;

        WrapType[number_of_3D_objects - 1] := D3DRMWRAP_CHROME;
        CollType[number_of_3D_objects - 1] := ellipsoid3D;

      end;
  1 : begin
        object_FileName[number_of_3D_objects-1] := ExtractFilePath(Application.Exename) +
                'chair.x';
        object_scale[number_of_3D_objects-1] := 0.02;
        object_position[number_of_3D_objects - 1].y := 6.0 + lift; //0.0;

        WrapType[number_of_3D_objects - 1] := D3DRMWRAP_CYLINDER;
        CollType[number_of_3D_objects - 1] := box3D;

      end;
  2 : begin
        object_FileName[number_of_3D_objects-1] := ExtractFilePath(Application.Exename) +
                'champagn.x';
        object_scale[number_of_3D_objects-1] := 1;
        object_position[number_of_3D_objects - 1].y := 0.25 + lift; //0.0;

        WrapType[number_of_3D_objects - 1] := D3DRMWRAP_CYLINDER;
        CollType[number_of_3D_objects - 1] := cylinder3D;

      end;
  3 : begin
        object_FileName[number_of_3D_objects-1] := ExtractFilePath(Application.Exename) +
                'cube.x';
        object_scale[number_of_3D_objects-1] := 2;
        object_position[number_of_3D_objects - 1].y := 0.95 + lift; //0.0;

        WrapType[number_of_3D_objects - 1] := D3DRMWRAP_CYLINDER;
        CollType[number_of_3D_objects - 1] := box3D;

      end;
  4 : begin
        object_FileName[number_of_3D_objects-1] := ExtractFilePath(Application.Exename) +
                'sphere.x';
        object_scale[number_of_3D_objects-1] := 2;
        object_position[number_of_3D_objects - 1].y := 2.9 + lift ; //0.0;

        WrapType[number_of_3D_objects - 1] := D3DRMWRAP_CYLINDER;
        CollType[number_of_3D_objects - 1] := sphere3D;

      end;




  end;

  //make the 3D object
  make_3D_object(ShootableSeries, (number_of_3D_objects - 1), symmetric_x);


end;



procedure TMainForm.RadioGroup1Click(Sender: TObject);
begin
  max_hits := radiogroup1.itemindex + 1;
end;

procedure TMainForm.CheckBox1Click(Sender: TObject);
begin
  CollisionTester3DX1.LongShots := checkbox1.checked;
end;

end.
