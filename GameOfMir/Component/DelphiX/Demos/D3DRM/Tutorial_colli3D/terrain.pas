// The content of the landscape generating routines in this unit was derived
// from the C++ code in the book "The Awesome Power of Direct3D/DirectX by Peter
// Kovach".
// Thanks to Peter Kovach at directx.xoom.com for allowing me to include the
// translated code with this program.
//
// Henrik Fabricius, Delphi3DX, august 1999
unit terrain;

interface

uses
  windows, SysUtils, Dialogs, messages, Classes, DirectX, typer3D;


procedure GroundCheck(ground : IDIRECT3DRMFRAME;
                     delta : TD3DVALUE);cdecl;

procedure CreatePoints(var vertices : verticevekt; var normals : normalvekt;
             var vc, nc : DWORD; x, y, typ, lev : integer);

procedure getNormal (i, j : integer; var n : TD3DVECTOR);

procedure create_faces_1(var f : facevekt);
procedure create_faces_2(var f : facevekt);
procedure create_faces_3(var f : facevekt);
procedure create_faces_4(var f : facevekt);
procedure create_faces_5(var f : facevekt);

function getP(ii, jj : integer):DWORD;

Procedure Build_Plane(Meshbuilder : IDirect3DRMMeshBuilder3;
                  xvalue, yvalue, step : integer);




implementation

uses
  main;




procedure GroundCheck(ground : IDIRECT3DRMFRAME;
                     delta : TD3DVALUE);cdecl;
var
  i, j : integer;
  d3v, d3v1, d3v2 : TD3DVECTOR;
  flnu, distance : real; //float in c

  rval : HRESULT;

begin
  //the default calling convention in DELPHI is 'register'
  //in this case the calling convention is specified to be 'cdecl'
  //This means that the parameters are passed from right to left
  //With the cdecl convention the caller removes parameters from the stack
  //when the call returns. Normally the procedure does this self
  //The default register convention is the most efficient since it usually
  //avoids creation of a stack frame. The ddecl convention is useful when you
  //call functions from DLLs written in C or C++

  g_faces := 0;

  flnu := (points_Xsize - 1) * (points_Ysize - 1) *  m_step  *  m_step;

  //Get the vector from the origon of the Scene frame to the origon of the
  //camera frame
  mainform.DXDraw.Camera.GetPosition(mainform.DXDraw.scene, d3v);

  //Get the coordinates of the same vector in the ground frame system
  //which normally have a different orientation
  ground.InverseTransform(d3v1, d3v);

  for i := 0 to (gTileX - 1) do
  begin
    for j := 0 to (gTileY - 1) do
    begin
      //Calculate the vector from the origon in the ground frame system
      //to the tile
      d3v2.x := D3DVAL( ((j - gTileY div 2) * (points_Ysize - 1)
                          + points_ysize div 2) * m_step);

      d3v2.y := D3DVAL( trans[(points_Xsize div 2 + i * (points_Xsize - 1) + 1),
                              (points_Ysize div 2 + j * (points_Ysize - 1) + 1)]
                       - 0.5);
      d3v2.z := D3DVAL( ((i - gTileX div 2) * (points_Xsize - 1) +
                         points_Xsize div 2) * m_step);

      //substract the vectors to find the distance from the camera
      //to the tile
      D3DRMVectorSubtract(d3v2, d3v2, d3v1);

      //distance is the squared distance
      distance := d3v2.x * d3v2.x + d3v2.y * d3v2.y + d3v2.z * d3v2.z;


      if distance > (8 * flnu)
      then
      begin
        g_faces := g_faces + 2;

        if (VisGFeld[i, j] = 5)
        then
          continue;  //continue with the next member in the loop


        if (visGFeld[i, j] > 0)
	then
        begin
          //delete the existing tile
          rval := ground.DeleteVisual(ground_meshes[i,j, (visGFeld[i, j] - 1)]);
          if rval <> D3DRM_OK
          then
            continue; //We did not succed in removing the tile
        end;

        //Add the desired tile of resolution 3  out of (0,1,2,3)
        rval := ground.AddVisual(ground_meshes[i, j, 4]);
        if rval <> D3DRM_OK
        then
        begin
          //the old tile was removed but we did not succed in adding a new
          visGFeld[i, j] := 0; //no tile
          continue; //go on with the next tile
        end;

        //remember the new resolution of the tile
        visGFeld[i,j] := 5;
      end
      else
      begin
        if distance > (4 * flnu)
        then
        begin
          //we are at a long distance from the tile
          g_faces := g_faces + 78;

          if (visGFeld[i, j] = 4)
          then
            continue;  //continue with the next member in the for loop

          if (visGFeld[i, j] > 0)
       	  then
          begin
            //delete the existing tile
            rval := ground.DeleteVisual(ground_meshes[i,j, (visGFeld[i, j] - 1)]);
            if rval <> D3DRM_OK
            then
              continue; //We did not succed in removing the tile
          end;

          //Add the desired tile of resolution 3  out of (0,1,2,3)
          rval := ground.AddVisual(ground_meshes[i, j, 3]);
          if rval <> D3DRM_OK
          then
          begin
            //the old tile was removed but we did not succed in adding a new
            visGFeld[i, j] := 0; //no tile
            continue; //go on with the next tile
          end;

          //remember the new resolution of the tile
          visGFeld[i,j] := 4;

        end // larger than 4 times flnu
        else
        begin
          //we must be somewhere between 3 and 4 times flnu away
          if distance > (2 * flnu)
          then
          begin
            g_faces := g_faces + 88;

            if visGFeld[i,j] = 3 //the tile is already correct
            then
              continue; //proceed with the next member in the loop

            if visGFeld[i, j] > 0
            then
            begin
       	      //remove the existing tile
              rval := ground.DeleteVisual( ground_meshes[i,j,(visGFeld[i, j]-1)]);
              if rval <> D3DRM_OK
              then
                continue;  //we did not succed in removing the tile
            end;

            //Add the desired tile with a resolution of 2 out of (0,1,2,3)
            rval := ground.AddVisual(ground_meshes[i, j, 2]);
            if rval <> D3DRM_OK
            then
            begin
              //the old tile was removed but we did not succed in adding a new
              visGFeld[i, j] := 0; //no tile
              continue; //go on with the next tile
            end;

            //remember the new resolution of the tile
            visGFeld[i, j] := 3;

          end //if distance larger than 2 times flnu
          else
          begin
            if distance > (1 * flnu)
            then
            begin
              //we must be somewhere between 1 and 2 times flnu away
              g_faces := g_faces + 200;

              if (visGFeld[i, j] = 2) //the resolution is already correct
              then
                continue; //proceed with the next member in the loop

              if (visGFeld[i, j] > 0)
              then
              begin
	        //delete the existing tile
                rval := ground.DeleteVisual(ground_meshes[i, j, (visGFeld[i, j] - 1)]);
                if rval <> D3DRM_OK
                then
                  continue;  //we did not succed in removing the tile
              end;

              //make the tile with the desired resolution of 1 out of (0,1,2,3)
              ground.AddVisual(ground_meshes[i, j, 1]);
              if rval <> D3DRM_OK
              then
              begin
                //the old tile was removed but we did not succed in adding a new
                visGFeld[i, j] := 0; //no tile
                continue; //go on with the next tile
              end;

              //remember the resolution of the new tile
              visGFeld[i, j] := 2;
            end
            else
            begin
              //The distance is less than flnu
              g_faces := g_faces + 552;

              if (visGFeld[i, j] = 1)
              then
                continue;  //the status of the tile is already correct

              if (visGFeld[i, j] > 0)
              then
              begin
                //delete the existing tile
	        rval := ground.DeleteVisual(ground_meshes[i,j,(visGFeld[i,j]-1)]);
                if rval <> D3DRM_OK
                then
                  continue; //we did not succeed in removing the tile.Try the next
              end;

              //add a tile with the desired resolution
              rval := ground.AddVisual(ground_meshes[i, j, 0]);
              if rval <> D3DRM_OK
              then
              begin
                //the old tile was removed but we did not succed in adding a new
                visGFeld[i, j] := 0; //no tile
                continue; //go on with the next tile
              end;

              //remember the status of the new tile
              visGFeld[i, j] := 1;

            end; // end closest distance

          end; // end second distance

        end; // end third distance

      end;  // end fourth distance

    end; // end j loop

  end;  // end i loop


end;





procedure CreatePoints(var vertices : verticevekt; var normals : normalvekt;
             var vc, nc : DWORD; x, y, typ, lev : integer);
var
  i, j, count, step : integer;
begin
  //initier count som side 143 i the Awesome Power of Direct3D/DirectX
  count := 1;

  //initier step som side 144 i the Awesome...
  step := 1 shl lev; //each shift doubles step


  //See the comment in typer3D.pas to understand the points selection
  //in this loop
  for i := 0 to (points_Xsize - 1) do
  begin
    for j := 0 to (points_Ysize - 1) do
    begin
      if ( (points[0, i, j] and step) <> 0) //bitwise comparison
      then
      begin
        points[1, i, j] := count;
        inc(count);
      end
      else
        Points[1, i, j] := 0;

    end;  //end of points_Ysize loop
  end; //end of Points_Xsize loop


  vc := count - 1;
  nc := count - 1;

  for i := 0 to (points_Xsize - 1) do
  begin
    for j := 0 to (points_Ysize - 1) do
    begin
      if points[1, i, j] > 0
      then
      begin
        case typ of
        0 : begin
              //typ is 0 when building a plane
              vertices[points[1,i,j] - 1].x := ( (y - gTiley div 2) *
                      (points_ysize - 1) + j) * m_step;

              vertices[points[1,i,j] - 1].y :=
                       trans[(i + (x + 1) * (points_xsize - 1) + 1),
                             (j + y * (points_ysize - 1) + 1) ] - 0.5;

              vertices[points[1,i,j] - 1].z := ( (x - gTileX div 2) *
                      (points_Xsize - 1) + i) * m_step;


              getNormal( (i + (x + 1) * (points_xsize - 1) + 1),
                         (j + y * (points_ysize - 1) + 1),
                         normals[points[1, i, j] - 1] );
            end;
        1 : begin
              //typ is 1 when building mountains
              vertices[points[1,i,j] - 1].x :=
                            (y * (points_ysize - 1) + j) * m_step;

              vertices[points[1,i,j] - 1].y :=
                            (x * (points_Xsize - 1) + i) * m_step;

              vertices[points[1,i,j] - 1].z :=
                            trans[(i + x * (points_xsize - 1) + 1),
                                  (j + y * (points_ysize - 1) + 1)] +
              8 * (trans[0, (j + y *(points_ysize - 1) + 1)] - 0.5) - 0.5;


              getNormal( (i + x * (points_xsize - 1) + 1),
                         (j + y * (points_ysize - 1) + 1),
                          normals[points[1, i, j] - 1] );
            end;
        end; // end case


      end;  //end of points loop
    end;  //end of points_Xsize loop
  end;  //end of points_Ysize loop


  if (lev = 4)
  then
  begin
    for i := 0 to (count - 2) do
    begin
      vertices[i].y := vertices[i].y + D3DVAL(m_step * 0.25);
    end;
  end;


end;  {of procedure createPoints}






procedure getNormal (i, j : integer; var n : TD3DVECTOR);
var
  d1, dza, dzb, dzc, dzd : TD3DVALUE;
  v1, v2, v3, v4 : TD3DVECTOR;
begin

  d1 := D3DVAL(1.0);

  if ((i = 0) or (j = 0))
  or ((i = (FL-1)) or (j = (FL-1) ))
  then
  begin
    n.x := D3DVAL(0.0);
    n.y := D3DVAL(1.0);
    n.z := D3DVAL(0.0);
  end
  else
  begin
    dza := D3DVAL(trans[i, j] - trans[i, (j-1)]);
    dzb := D3DVAL(trans[(i+1), j] - trans[i, j]);
    dzc := D3DVAL(trans[i, (j+1)] - trans[i, j]);
    dzd := D3DVAL(trans[(i-1), j] - trans[i, j]);

    v1.x := dza;
    v1.y := -d1;
    v1.z := dzb;

    v2.x := dzc;
    v2.y := -d1;
    v2.z := dzb;

    v3.x := dzc;
    v3.y := d1;
    v3.z := -dzd;

    v4.x := dza;
    v4.y := -d1;
    v4.z := -dzd;

    D3DRMVectorAdd(n, v1, v2);
    D3DRMVectorAdd(n, n, v3);
    D3DRMVectorAdd(n, n, v4);
    D3DRMVectorNormalize(n);
  end;
end;  {end of GetNormal}






procedure create_faces_1(var f : facevekt);
var
  i, j, count : integer;
begin
  //setlength(f, (7 * 552 + 1));

  count := 0;

  i := 0;
  j := 0;

  while j < 20 do
  begin

    if (j and 2) <> 0  //  if (j&2) in c++
    then
    begin
      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
    end
    else
    begin
      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
    end;

    j := j + 2;
  end; //end while j < 20;


  i := 2;
  j := 0;

  while i < 18 do
  begin
    if (i and 2) <> 0   //  if (i&2)
    then
    begin
      f[count] := 3;  // f[count++] = 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count]:= getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
    end
    else
    begin
      f[count] := 3;  // f[count++] = 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
    end;

    i := i + 2;
  end; //end while i < 18



  i := 2;
  j := 2;

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j + 2));
  inc(count);
  f[count] := getP(i, (j + 2));
  inc(count);
  f[count] := getP((i + 1), (j+1));
  inc(count);
  f[count] := getP((i + 1), (j+1));
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP((i+1), (j+2));
  inc(count);
  f[count] := getP((i+1), (j+2));
  inc(count);
  f[count] := getP((i+1), (j + 1));
  inc(count);
  f[count] := getP((i+1), (j + 1));
  inc(count);

  f[count] := 3;  //f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+2), (j+1));
  inc(count);
  f[count] := getP((i+2), (j+1));
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);

  i := 2;
  j := 4;

  while j < 16 do
  begin
    f[count] := 3;  // f[count++] = 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, (j + 2));
    inc(count);
    f[count] := getP(i, (j + 2));
    inc(count);
    f[count] := getP((i + 1), (j+1));
    inc(count);
    f[count] := getP((i + 1), (j+1));
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP((i+1), (j+1));
    inc(count);
    f[count] := getP((i+1), (j+1));
    inc(count);
    f[count]:= getP((i+1), j);
    inc(count);
    f[count] := getP((i+1), j);
    inc(count);

    f[count] := 3;  //  f[count++] = 3;
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP((i + 1), (j + 2));
    inc(count);
    f[count] := getP((i + 1), (j + 2));
    inc(count);
    f[count] := getP((i+1), (j+1));
    inc(count);
    f[count] := getP((i+1), (j+1));
    inc(count);

    j := j + 2
  end; //end while j < 16


  i := 2;
  j := 16;

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP((i + 1), (j + 1));
  inc(count);
  f[count] := getP((i + 1), (j + 1));
  inc(count);
  f[count] := getP((i + 1), j);
  inc(count);
  f[count] := getP((i + 1), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP(i, (j + 2));
  inc(count);
  f[count] := getP(i, (j + 2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+1));
  inc(count);
  f[count] := getP((i+2), (j+1));
  inc(count);

  i := 4;
  j := 2;

  while i < 16 do
  begin
    f[count] := 3;  // f[count++] = 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, (j+1));
    inc(count);
    f[count] := getP(i, (j+1));
    inc(count);
    f[count] := getP((i+1), (j+1));
    inc(count);
    f[count] := getP((i+1), (j+1));
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP((i+1), (j+1));
    inc(count);
    f[count] := getP((i+1), (j+1));
    inc(count);
    f[count]:= getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);

    f[count] := 3;  // f[count++] = 3;
    inc(count);
    f[count] := getP((i+1), (j+1));
    inc(count);
    f[count] := getP((i+1), (j+1));
    inc(count);
    f[count] := getP((i+2), (j+1));
    inc(count);
    f[count] := getP((i+2), (j+1));
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);

    i := i + 2;
  end;  //end while i < 16


  for i := 3 to 16 do
  begin
    for j := 3 to 16 do
    begin
      f[count] := 3;  // f[count++] = 3;
      inc(count);
      f[count] := getP(i, (j+1));
      inc(count);
      f[count] := getP(i, (j+1));
      inc(count);
      f[count] := getP((i+1), (j+1));
      inc(count);
      f[count] := getP((i+1), (j+1));
      inc(count);
      f[count] := getP((i+1), j);
      inc(count);
      f[count] := getP((i+1), j);
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+1));
      inc(count);
      f[count] := getP(i, (j+1));
      inc(count);
      f[count]:= getP((i+1), j);
      inc(count);
      f[count] := getP((i+1), j);
      inc(count);
    end;
  end;


  i := 4;
  j := 17;

  while i < 16 do
  begin
    f[count] := 3;  //  f[count++] = 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, (j+1));
    inc(count);
    f[count] := getP(i, (j+1));
    inc(count);
    f[count] := getP((i+1), j);
    inc(count);
    f[count] := getP((i+1), j);
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP((i+1), j);
    inc(count);
    f[count] := getP((i+1), j);
    inc(count);
    f[count] := getP(i, (j+1));
    inc(count);
    f[count] := getP(i, (j+1));
    inc(count);
    f[count] := getP((i+2), (j+1));
    inc(count);
    f[count] := getP((i+2), (j+1));
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP((i+1), j);
    inc(count);
    f[count] := getP((i+1), j);
    inc(count);
    f[count] := getP((i+2), (j+1));
    inc(count);
    f[count] := getP((i+2), (j+1));
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);

    i := i + 2;
  end;  //end while i < 16




  i := 16;
  j := 2;

  f[count] := 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP (i, (j+1));
  inc(count);
  f[count] := getP(i, (j+1));
  inc(count);
  f[count] := getP ((i+1), (j+1));
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP ((i+2), j);
  inc(count);
  f[count] := getP ((i+2), j);
  inc(count);
  f[count] := getP ((i+1), (j+1));
  inc(count);
  f[count] := getP ((i+1), (j+1));
  inc(count);
  f[count] := getP ((i+2), (j+2));
  inc(count);
  f[count] := getP ((i+2), (j+2));
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+1), (j+2));
  inc(count);
  f[count] := getP((i+1), (j+2));
  inc(count);

  i := 17;
  j := 4;

  while j < 16 do
  begin
    f[count] := 3;  //f[count++] = 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, (j+1));
    inc(count);
    f[count] := getP(i, (j+1));
    inc(count);
    f[count] := getP((i+1), j);
    inc(count);
    f[count] := getP((i+1), j);
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP((i+1), j);
    inc(count);
    f[count] := getP((i+1), j);
    inc(count);
    f[count] := getP(i, (j+1));
    inc(count);
    f[count] := getP(i, (j+1));
    inc(count);
    f[count] := getP((i+1), (j+2));
    inc(count);
    f[count] := getP((i+1), (j+2));
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP((i+1), (j+2));
    inc(count);
    f[count] := getP((i+1), (j+2));
    inc(count);
    f[count] := getP(i, (j+1));
    inc(count);
    f[count] := getP(i, (j+1));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);

    j := j + 2;
  end; //end while j < 16


  i := 16;
  j := 16;

  f[count] := 3;
  inc(count);
  f[count] := getP(i, (j+1));
  inc(count);
  f[count] := getP(i, (j+1));
  inc(count);
  f[count] := getP (i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP ((i+1), (j+1));
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+1), j);
  inc(count);
  f[count] := getP((i+1), j);
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);
  f[count] := getP((i+1), (j+1));
  inc(count);

  i := 2;
  j := 18;

  while i < 18 do
  begin

    if (i and 2) <> 0
    then
    begin
      f[count] := 3;  // f[count++] = 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
    end
    else
    begin
      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i,j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
    end;


    i := i + 2;
  end; //end while i < 18




  i := 18;
  j := 0;

  while j < 20 do
  begin
    if (j and 2) <> 0
    then
    begin
      f[count] := 3;  // f[count++] = 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
    end
    else
    begin
      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i,j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
    end;


    j := j + 2;
  end;  //end while j < 20



  //final zero
  f[count] := 0;

  testantal := count;

end;





procedure create_faces_2(var f : facevekt);
var
  i, j, count : integer;
begin
  //f := nil;
  //setlength(f, (7 * 200 + 1));

  count := 0;

  i := 0;
  j := 0;

  while  j < 20 do
  begin
    if (j and 2) <> 0  //  if (j&2) in c++
    then
    begin
      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count]:= getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
    end
    else
    begin
      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
    end;

    j := j + 2;
  end;  //end j < 20


  i := 2;
  j := 0;

  while i < 18 do
  begin
    if (i and 2) <> 0   // if (i&2)
    then
    begin
      f[count] := 3;  // f[count++] = 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count]:= getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
    end
    else
    begin
      f[count] := 3;  // f[count++] = 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
    end;

    i := i + 2;
  end;  //end while i < 18



  i := 2;
  while i < 18 do
  begin

    j := 2;
    while j < 18 do
    begin
      f[count] := 3;  // f[count++] = 3;
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP((i+2), (j + 2));
      inc(count);
      f[count] := getP((i+2), (j + 2));
      inc(count);
      f[count] := getP((i + 2), j);
      inc(count);
      f[count] := getP((i + 2), j);
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);

      j := j + 2;
    end; //end while j < 18

    i := i + 2;
  end; //end while i < 18


  i := 2;
  j := 18;

  while i < 18 do
  begin
    if (i and 2) <> 0
    then
    begin
      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);

    end
    else
    begin
      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
    end;

    i := i + 2;
  end;  // end while i<18



  i := 18;
  j := 0;

  while j < 20 do
  begin
    if (j and 2) <> 0
    then
    begin
      f[count] := 3;  // f[count++] = 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP((i + 2), (j+2));
      inc(count);
      f[count] := getP((i + 2), (j+2));
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count]:= getP(i, (j + 2));
      inc(count);
      f[count] := getP(i, (j + 2));
      inc(count);
    end
    else
    begin
      f[count] := 3;  // f[count++] = 3;
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, (j + 2));
      inc(count);
      f[count] := getP(i, (j + 2));
      inc(count);

      f[count] := 3;  // f[count++] = 3;
      inc(count);
      f[count] := getP(i,(j+2));
      inc(count);
      f[count] := getP(i, (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), (j+2));
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
      f[count] := getP((i+2), j);
      inc(count);
    end;

    j := j + 2
  end;  //end while j < 20


  //final zero
  f[count] := 0;

  testantal := count;

end;




procedure create_faces_3(var f : facevekt);
var
  i, j, count : integer;
begin
  //f := nil;
  //setlength(f, (7 * 88 + 1));

  count := 0;

  i := 0;
  j := 0;

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP((i+2), (j + 2));
  inc(count);
  f[count] := getP((i+2), (j + 2));
  inc(count);

  f[count] := 3;  //f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);


  i := 0;
  j := 2;

  while j < 18 do
  begin

    f[count] := 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count]:= getP((i+2), (j+4));
    inc(count);
    f[count] := getP((i+2), (j+4));
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+4));
    inc(count);
    f[count] := getP(i, (j+4));
    inc(count);
    f[count] := getP((i+2), (j+4));
    inc(count);
    f[count] := getP((i+2), (j+4));
    inc(count);

    j := j + 4;
  end; //end while j < 18

  i := 0;
  j := 18;

  f[count] := 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);



  i := 2;
  j := 0;

  while i < 18 do
  begin
    f[count] := 3;  // f[count++] = 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count]:= getP((i+4), (j+2));
    inc(count);
    f[count] := getP((i+4), (j+2));
    inc(count);

    f[count] := 3;  //f[count++] = 3;
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+4), (j+2));
    inc(count);
    f[count] := getP((i+4), (j+2));
    inc(count);
    f[count] := getP((i+4), j);
    inc(count);
    f[count] := getP((i+4), j);
    inc(count);

    i := i + 4;
  end; //end while i < 18



  i := 2;

  while i < 18 do
  begin

    j := 2;
    while j < 18 do
    begin
      f[count] := 3;  // f[count++] = 3;
      inc(count);
      f[count] := getP(i, (j+4));
      inc(count);
      f[count] := getP(i, (j+4));
      inc(count);
      f[count] := getP((i+4), (j + 4));
      inc(count);
      f[count] := getP((i+4), (j + 4));
      inc(count);
      f[count] := getP((i + 4), j);
      inc(count);
      f[count] := getP((i + 4), j);
      inc(count);

      f[count] := 3;
      inc(count);
      f[count] := getP(i, (j+4));
      inc(count);
      f[count] := getP(i, (j+4));
      inc(count);
      f[count] := getP((i+4), j);
      inc(count);
      f[count] := getP((i+4), j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);
      f[count] := getP(i, j);
      inc(count);

      j := j + 4;
    end; //end while j < 18

    i := i + 4;
  end; //end while i < 18


  i := 2;
  j := 18;

  while i < 18 do
  begin
    f[count] := 3;  // f[count++] = 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+4), j);
    inc(count);
    f[count] := getP((i+4), j);
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP((i+4), j);
    inc(count);
    f[count] := getP((i+4), j);
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+4), (j+2));
    inc(count);
    f[count] := getP((i+4), (j+2));
    inc(count);

    i := i + 4;
  end; //end while i < 18



  i := 18;
  j := 0;

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP((i + 2), j);
  inc(count);
  f[count] := getP((i + 2), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count]:= getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);


  i := 18;
  j := 2;

  while j < 18 do
  begin
    f[count] := 3;  // f[count++] = 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, (j+4));
    inc(count);
    f[count] := getP(i, (j+4));
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP(i, (j+4));
    inc(count);
    f[count] := getP(i, (j+4));
    inc(count);
    f[count] := getP((i+2), (j+4));
    inc(count);
    f[count] := getP((i+2), (j+4));
    inc(count);

    j := j + 4;
  end; //end while j < 18



  i := 18;
  j := 18;

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP((i + 2), (j+2));
  inc(count);
  f[count] := getP((i + 2), (j+2));
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count]:= getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);

  //final zero
  f[count] := 0;

end;




procedure create_faces_4(var f : facevekt);
var
  i, j, count : integer;
begin
  //f := nil;
  //setlength(f, (7 * 78 + 1));

  count := 0;

  i := 0;
  j := 0;

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP((i+2), (j + 2));
  inc(count);
  f[count] := getP((i+2), (j + 2));
  inc(count);

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);


  i := 0;
  j := 2;

  while j < 18 do
  begin

    f[count] := 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count]:= getP((i+2), (j+4));
    inc(count);
    f[count] := getP((i+2), (j+4));
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+4));
    inc(count);
    f[count] := getP(i, (j+4));
    inc(count);
    f[count] := getP((i+2), (j+4));
    inc(count);
    f[count] := getP((i+2), (j+4));
    inc(count);

    j := j + 4;
  end; //end while j < 18


  i := 0;
  j := 18;

  f[count] := 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);



  j := 0;
  i := 2;

  while i < 18 do
  begin

    f[count] := 3;  // f[count++] = 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count]:= getP((i+4), (j+2));
    inc(count);
    f[count] := getP((i+4), (j+2));
    inc(count);

    f[count] := 3; // f[count++] = 3;
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+4), (j+2));
    inc(count);
    f[count] := getP((i+4), (j+2));
    inc(count);
    f[count] := getP((i+4), j);
    inc(count);
    f[count] := getP((i+4), j);
    inc(count);

    i := i + 4;
  end; //end i < 18



  i := 2;
  j := 2;

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP((i + 4), j);
  inc(count);
  f[count] := getP((i + 4), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);


  i := 2;
  j := 6;

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP((i+4), (j+8));
  inc(count);
  f[count] := getP((i+4), (j+8));
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP(i, (j+8));
  inc(count);
  f[count] := getP(i, (j+8));
  inc(count);
  f[count] := getP((i+4), (j+8));
  inc(count);
  f[count] := getP((i+4), (j+8));
  inc(count);


  i := 2;
  j := 14;

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);
  f[count]:= getP((i+4), j);
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);


  i := 6;
  j := 2;

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count]:= getP((i+8), (j+4));
  inc(count);
  f[count] := getP((i+8), (j+4));
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);
  f[count] := getP((i+8), (j+4));
  inc(count);
  f[count] := getP((i+8), (j+4));
  inc(count);
  f[count]:= getP((i+8), j);
  inc(count);
  f[count] := getP((i+8), j);
  inc(count);

  i := 6;
  j := 6;

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+8));
  inc(count);
  f[count] := getP(i, (j+8));
  inc(count);
  f[count] := getP((i + 8), j);
  inc(count);
  f[count] := getP((i + 8), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+8), j);
  inc(count);
  f[count] := getP((i+8), j);
  inc(count);
  f[count] := getP(i, (j+8));
  inc(count);
  f[count] := getP(i, (j+8));
  inc(count);
  f[count]:= getP((i+8), (j+8));
  inc(count);
  f[count] := getP((i+8), (j+8));
  inc(count);

  i := 6;
  j := 14;

  f[count] := 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP((i + 4), (j+4));
  inc(count);
  f[count] := getP((i + 4), (j+4));
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);
  f[count]:= getP((i+8), j);
  inc(count);
  f[count] := getP((i+8), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+8), j);
  inc(count);
  f[count] := getP((i+8), j);
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);
  f[count]:= getP((i+8), (j+4));
  inc(count);
  f[count] := getP((i+8), (j+4));
  inc(count);

  i := 14;
  j := 2;

  f[count] := 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP((i + 4), (j+4));
  inc(count);
  f[count] := getP((i + 4), (j+4));
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);
  f[count]:= getP((i+4), j);
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);


  i := 14;
  j := 6;

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+8));
  inc(count);
  f[count] := getP(i, (j+8));
  inc(count);
  f[count] := getP((i + 4), (j+4));
  inc(count);
  f[count] := getP((i + 4), (j+4));
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);
  f[count]:= getP((i+4), j);
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);
  f[count] := getP(i, (j+8));
  inc(count);
  f[count] := getP(i, (j+8));
  inc(count);
  f[count]:= getP((i+4), (j+8));
  inc(count);
  f[count] := getP((i+4), (j+8));
  inc(count);

  i := 14;
  j := 14;

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP((i + 4), j);
  inc(count);
  f[count] := getP((i + 4), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);
  f[count] := getP((i+4), j);
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count] := getP(i, (j+4));
  inc(count);
  f[count]:= getP((i+4), (j+4));
  inc(count);
  f[count] := getP((i+4), (j+4));
  inc(count);


  i := 2;
  j := 18;

  while i < 18 do
  begin
    f[count] := 3;  // f[count++] = 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP(i, (j+2));
    inc(count);
    f[count] := getP((i + 2), (j+2));
    inc(count);
    f[count] := getP((i + 2), (j+2));
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count]:= getP((i+4), j);
    inc(count);
    f[count] := getP((i+4), j);
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP((i+4), j);
    inc(count);
    f[count] := getP((i+4), j);
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+4), (j+2));
    inc(count);
    f[count] := getP((i+4), (j+2));
    inc(count);

    i := i + 4;
  end; //end while i < 18


  i := 18;
  j := 0;

  f[count] := 3;  //f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP((i + 2), j);
  inc(count);
  f[count] := getP((i + 2), j);
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);


  i := 18;
  j := 2;

  while j < 18 do
  begin
    f[count] := 3;  // f[count++] = 3;
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, (j+4));
    inc(count);
    f[count] := getP(i, (j+4));
    inc(count);
    f[count] := getP((i + 2), (j+2));
    inc(count);
    f[count] := getP((i + 2), (j+2));
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP((i+2), j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);
    f[count] := getP(i, j);
    inc(count);

    f[count] := 3;
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP((i+2), (j+2));
    inc(count);
    f[count] := getP(i, (j+4));
    inc(count);
    f[count] := getP(i, (j+4));
    inc(count);
    f[count]:= getP((i+2), (j+4));
    inc(count);
    f[count] := getP((i+2), (j+4));
    inc(count);

    j := j + 4;
  end;  //end while j < 18


  i := 18;
  j := 18;

  f[count] := 3;  //  f[count++] = 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP(i, (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);

  f[count] := 3;
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP(i, j);
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), (j+2));
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);
  f[count] := getP((i+2), j);
  inc(count);

  //final zero
  f[count] := 0;

end;





procedure create_faces_5(var f : facevekt);
var
  count : integer;
begin
  //f := nil;
  //setlength(f, (7 * 2 + 1));

  count := 0;

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(0, 0);
  inc(count);
  f[count] := getP(0, 0);
  inc(count);
  f[count] := getP(0, (points_Ysize - 1));
  inc(count);
  f[count] := getP(0, (points_Ysize - 1));
  inc(count);
  f[count] := getP((points_Xsize - 1), (Points_Ysize - 1));
  inc(count);
  f[count] := getP((points_Xsize - 1), (Points_Ysize - 1));
  inc(count);

  f[count] := 3;  // f[count++] = 3;
  inc(count);
  f[count] := getP(0, 0);
  inc(count);
  f[count] := getP(0, 0);
  inc(count);
  f[count] := getP((Points_Xsize - 1), (Points_Ysize - 1));
  inc(count);
  f[count] := getP((Points_Xsize - 1), (Points_Ysize - 1));
  inc(count);
  f[count] := getP((Points_Xsize - 1), 0);
  inc(count);
  f[count] := getP((Points_Xsize - 1), 0);
  inc(count);


  //final zero
  f[count] := 0;

end;






function getP(ii, jj : integer):DWORD; //:integer;
begin
  result := points[1, ii, jj] - 1;
end;





Procedure Build_Plane(Meshbuilder : IDirect3DRMMeshBuilder3;
                  xvalue, yvalue, step : integer);
var
  rval : HRESULT;
  vertexCount, normalCount : DWORD;  //counts number of members in the arrays
  nix : IDIRECT3DRMFACEARRAY;
begin

  //pascal style
  CreatePoints(vertices, normals, vertexCount, normalCount, xvalue, yvalue, 0,
               step);

  {the code creating the ground terrain is designed to handle multiple (four)
  levels of detail. The way this is done is by using fewer of the internal
  points defining the surface when we wish to use fewer polygons to increase
  the speed of our rendering}
  case step of
  0 : create_faces_1(facedata);
  1 : create_faces_2(facedata);
  2 : create_faces_3(facedata);
  3 : create_faces_4(facedata);
  4 : create_faces_5(facedata);
  end;


  Pvertices := @vertices;     //make Pvertices point at vertices
  Pnormals := @normals;       //make Pnormals point at normals
  Pfacedata := @facedata;     //make Pfacedata point at facedata


  //Notice how the faces are added
  rval := Meshbuilder.AddFaces(vertexcount, Pvertices^, normalCount,
                                   @Pnormals^, PfaceData^, @nix);

  if Failed(rval)
  then
  begin
    {negativ value of rval indicates failior}
    //vertices := nil;
    //normals := nil;
    //faceData := nil;
    nix := nil;
  end
  else
  begin
    meshbuilder.SetQuality(Quality); //set quality of renderer

    //vertices := nil;
    //normals := nil;
    //faceData := nil;
    nix := nil;
  end;



end;  {buildplane}








end.
