unit Main2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXClass, DXDraws;
                                                                
type
  TMapTile = record
    Num : Byte;                     // number of tiles at one coordinate (allows stacking of tiles)
    Tile : array[ 0..9 ] of Byte;   // type of tile (0=grass, 1=path, etc.)
    Height : array[ 0..9 ] of Byte; // how tall the tile reaches
    Layer : array[ 0..9 ] of Byte;  // used to make sure the sprites doesn't block.
    Walkable : boolean;             // Whether the tile at this location is walkable
  end;

  TMap = array[0..31, 0..31] of TMapTile;

  TMainForm = class(TDXForm)
    DXDraw: TDXDraw;
    DXTimer: TDXTimer;
    DXImageList: TDXImageList;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    MouseX, MouseY : Integer;      //Mouse position for cursor
    Map : TMap;
    viewx, viewy, sprite_x, player_x, sprite_y, player_y, xvel, yvel : Smallint;
    sprite_layer, sprite_frame, player_frame : Byte;
    scroll_speed : Byte;
    ScrollEdge : Byte;
    procedure SetupMap( FileName : string );
    procedure DrawIsoMap( x : Word ; y : Word );
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses MMSystem;

{$R *.DFM}

procedure TMainForm.DXDrawInitialize(Sender: TObject);
begin
  viewx := 0;
  viewy := 0;
  scroll_speed := 2;
  ScrollEdge := 20;
  player_x := 320;
  player_y := 240;
  sprite_x := 0;
  sprite_y := 0;
  sprite_layer := 1;
  sprite_frame := 0;
  player_frame := 0;
  yvel := 1;
  xvel := 2;

  SetupMap( 'Level1.map' );

  DXTimer.Enabled := True;
end;

procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
  DXTimer.Enabled := False;
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
begin
  if not DXDraw.CanDraw then exit;

  inc(sprite_frame);
  if sprite_frame > 1  then
  begin
    sprite_frame := 0;
  end;

  // Sort out sprite stuff
  Inc(sprite_x, xvel);
  if (sprite_x < 0) or (sprite_x > 512) then
        xvel := -xvel;
  Inc(sprite_y, yvel);
  if (sprite_y < 0) or (sprite_y > 512) then
        yvel := -yvel;

  //Check to see if the Mouse in the ScrollEdge
  if ( MouseX > ( DxDraw.Width - ScrollEdge ) ) then
  begin
    inc( viewx, scroll_speed );
    dec( viewy, scroll_speed );
  end
  else if ( MouseX < ScrollEdge ) then
  begin
    dec( viewx, scroll_speed );
    inc( viewy, scroll_speed );
  end
  else if ( MouseY > ( DxDraw.Height - ScrollEdge ) ) then
  begin
    inc( viewx, scroll_speed );
    inc( viewy, scroll_speed );
  end
  else if ( MouseY < ScrollEdge ) then
  begin
    dec( viewx, scroll_speed );
    dec( viewy, scroll_speed );
  end;

  // Sort out view stuff
  if ( viewx < 0 ) then
    inc( viewx , 512 );
  if ( viewx >= 512 ) then
    dec( viewx , 512 );
  if ( viewy < 0 ) then
    inc( viewy , 512 );
  if ( viewy  >= 512 ) then
    dec( viewy , 512 );



  //Draw the Map image
  DrawIsoMap( viewx, viewy );

  //Draw the cursor at the current mouse position
  DXImageList.Items[14].Draw( DXDraw.Surface, MouseX, MouseY, 0 );

  with DXDraw.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clWhite;
    Font.Size := 12;
    Textout( 0, 0, 'FPS: '+inttostr( DXTimer.FrameRate ) ); { Display the FrameRate }
    Textout( 0, 20, 'Instructions :' );
    Textout( 0, 40, 'Use the Arrow Keys or Mouse to scroll the image.' );
    TextOut( 0, 60, 'Use the Numeric Key Pad to change scolling speed.' );
    Release; {  Always release the surface you have finished drawing on before flipping  }
  end;

  DXDraw.Flip;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {  Application end  }
  case Key of
    VK_ESCAPE : {  Application end  }
    begin
      Close;
    end;

    VK_LEFT :
    begin
      dec( viewx, scroll_speed );
      inc( viewy, scroll_speed );
    end;

    VK_RIGHT :
    begin
      inc( viewx, scroll_speed );
      dec( viewy, scroll_speed );
    end;

    VK_UP :
    begin
      dec( viewx, scroll_speed );
      dec( viewy, scroll_speed );
    end;

    VK_DOWN :
    begin
      inc( viewx, scroll_speed );
      inc( viewy, scroll_speed );
    end;

    VK_NUMPAD0 :
    begin
      scroll_speed := 2;
    end;

    VK_NUMPAD1 :
    begin
      scroll_speed := 4;
    end;

    VK_NUMPAD2 :
    begin
      scroll_speed := 6;
    end;

    VK_NUMPAD3 :
    begin
      scroll_speed := 8;
    end;

    VK_NUMPAD4 :
    begin
      scroll_speed := 10;
    end;

    VK_NUMPAD5 :
    begin
      scroll_speed := 12;
    end;

    VK_NUMPAD6 :
    begin
      scroll_speed := 14;
    end;

    VK_NUMPAD7 :
    begin
      scroll_speed := 16;
    end;

    VK_NUMPAD8 :
    begin
      scroll_speed := 18;
    end;

    VK_NUMPAD9 :
    begin
      scroll_speed := 20;
    end;
  end;

  {  Screen mode change  }
  if (ssAlt in Shift) and (Key=VK_RETURN) then
  begin
    DXDraw.Finalize;

    if doFullScreen in DXDraw.Options then
    begin
      RestoreWindow;

      DXDraw.Cursor := crDefault; // We've got our own so we don't need Window's
      BorderStyle := bsSizeable;
      DXDraw.Options := DXDraw.Options - [doFullScreen];
    end
    else
    begin
      StoreWindow;

      DXDraw.Cursor := crNone;
      BorderStyle := bsNone;
      DXDraw.Options := DXDraw.Options + [doFullScreen];
    end;

    DXDraw.Initialize;
  end;
end;

procedure TMainForm.DrawIsoMap(x, y: Word);
var
  i, j, k : Word;
  current_layer, highest_layer, next_layer, last_layer : Byte;
  mapx, mapy, mx, my, tx, ty, xo, yo, xa, ya : SmallInt;
  screenx, screeny : Integer;
  length : Integer;
  tile_to_draw, height_to_draw : Integer;
  sprite_mx, sprite_my, xx, yy : Integer;
begin
  // initialise variables
  current_layer := 0;
  highest_layer := 0;
  next_layer := 0;
  last_layer := 0;

  sprite_mx := sprite_x div 16;
  sprite_my := sprite_y div 16;

  // Convert to fine co-ordinates
  mapx := x div 16;
  xo := x and 15;
  mapy := y div 16;
  yo := y and 15;
  xa := xo - yo;
  ya := ( xo shr 1 ) + ( yo shr 1 );

  while true do
  begin
    next_layer := 255;
    mx := mapx;
    my := mapy;
    screeny := 8 - ya;

    for i := 0 to 69 do // Vertical screen draw
    begin
      tx := mx;
      ty := my;
      screenx := 16 - xa;
      length := 24;

      if i mod 2 <> 0 then // if line is odd
      begin
        inc( length ); // draw extra tile
        dec( screenx, 16 ); // pre-step 16 pixels left
      end;

      for j := 0 to length - 1 do // horizontal screen draw
      begin
        for k := 0 to Map[ ty ][ tx ].Num - 1 do
        begin
          if Map[ ty ][ tx ].layer[ k ] = current_layer then
          begin
            tile_to_draw := Map[ ty ][ tx ].tile[ k ];
            height_to_draw := Map[ ty ][ tx ].height[ k ];
            DXImageList.Items[ tile_to_draw].Draw( DXDraw.Surface, screenx - 16, screeny - height_to_draw - 16, 0 );
            //DXImageList.Items[ tile_to_draw].Draw( DXDraw.Surface, screenx, screeny - height_to_draw, 0 );
          end;
          if ( tx = sprite_mx ) and ( ty = sprite_my ) and (current_layer = sprite_layer) then
          begin
            xo := sprite_x and 15;
            yo := sprite_y and 15;
            xx := xo - yo;
            yy := ( xo shr 1) + ( yo shr 1 );
            //DXImageList.Items[ 12 + sprite_frame].Draw( DXDraw.Surface, screenx - 48 + xx, screeny - 32 + yy, 0 );
            DXImageList.Items[ 12 + sprite_frame].Draw( DXDraw.Surface, screenx - 32 + xx, screeny - 16 + yy, 0 );
          end;

          if Map[ ty ][ tx ].layer[ k ] > highest_layer then
            highest_layer := Map[ ty ][ tx ].layer[ k ];

          if( Map[ ty ][ tx ].layer[ k ] < next_layer  ) and ( Map[ ty ][ tx ].layer[ k ] > last_layer  ) then
            next_layer := Map[ ty ][ tx ].layer[ k ];
        end;
        inc( screenx, 32 );// Move right 32 pixels for next tile

        inc( tx );
        if tx > 31 then
          tx := 0;

        dec( ty );
        if ty < 0 then
          ty := 31;
      end;

      inc( screeny, 8 );
      if i mod 2 <> 0  then
      begin
        inc( mx );
        if( mx > 31 ) then
          mx := 0;
      end
      else
      begin
        inc( my );
        if( my > 31 ) then
          my := 0;
      end;
    end;
    last_layer := current_layer;
    if current_layer = 0 then
     current_layer := 1
    else
      current_layer := next_layer;
    if current_layer > highest_layer then
      Break;
  end;
end;

procedure TMainForm.SetupMap(FileName: string);
var
  FileStream : TFileStream;
  C : Char;
  x, y : Word;
  tempbuffer : array[ 0..31, 0..31 ] of Char;
begin
  FileStream := TFileStream.Create( FileName, fmOpenRead );
  try
    // Do things with FileStream
    try
      for y := 0 to 31 do
      begin
        for x := 0 to 31 do
        begin
          FileStream.ReadBuffer( C, SizeOf( C ) );
          tempbuffer[ y ][ x ] := C;
        end;
      end;
    except on E: Exception do
      MessageDlg(E.Message, mtError, [mbOk], 0);
    end;
  finally
    FileStream.Free;
  end;

  // Transform Map into Map Structure
  for y := 0 to 31 do
  begin
    for x := 0 to 31 do
    begin
      case tempbuffer[ y ][ x ] of
        '0' :  // 0 -> Grass
        begin
          Map[ y ][ x ].Num := 1;
          Map[ y ][ x ].Tile[0] := 0;
          Map[ y ][ x ].Height[ 0 ] := 0;
          Map[ y ][ x ].Layer[ 0 ] := 0;
          Map[ y ][ x ].Walkable := true;
        end;

        '1' : // 1 -> Path
        begin
          Map[ y ][ x ].Num := 1;
          Map[ y ][ x ].Tile[ 0 ] := 1;
          Map[ y ][ x ].Height[ 0 ] := 0;
          Map[ y ][ x ].Layer[ 0 ] := 0;
          Map[ y ][ x ].Walkable := true;
        end;

        '2' : // 2 -> Water
        begin
          Map[ y ][ x ].Num := 1;
          Map[ y ][ x ].Tile[ 0 ] := 2;
          Map[ y ][ x ].Height[ 0 ] := 0;
          Map[ y ][ x ].Layer[ 0 ] := 0;
          Map[ y ][ x ].Walkable := false;
        end;

        '3' : // 3 -> Builing Corner
        begin
          Map[ y ][ x ].Num := 3;
          Map[ y ][ x ].Tile[ 0 ] := 3;
          Map[ y ][ x ].Height[ 0 ] := 0;
          Map[ y ][ x ].Layer[ 0 ] := 1;
          Map[ y ][ x ].Tile[ 1 ] := 4;
          Map[ y ][ x ].Height[ 1 ] := 0;
          Map[ y ][ x ].Layer[ 1 ] := 1;
          Map[ y ][ x ].Tile[ 2 ] := 5;
          Map[ y ][ x ].Height[ 2 ] := 8;
          Map[ y ][ x ].Layer[ 2 ] := 2;
          Map[ y ][ x ].Walkable := false;
        end;

        '4' : // 4 -> Builing Wall and Roof
        begin
          Map[ y ][ x ].Num := 2;
          Map[ y ][ x ].Tile[ 0 ] := 3;
          Map[ y ][ x ].Height[ 0 ] := 0;
          Map[ y ][ x ].Layer[ 0 ] := 1;
          Map[ y ][ x ].Tile[ 1 ] := 5;
          Map[ y ][ x ].Height[ 1 ] := 8;
          Map[ y ][ x ].Layer[ 1 ] := 2;
          Map[ y ][ x ].Walkable := false;
        end;

        '5' : // 5 -> Builing Wall and roof
        begin
          Map[ y ][ x ].Num := 2;
          Map[ y ][ x ].Tile[ 0 ] := 4;
          Map[ y ][ x ].Height[ 0 ] := 0;
          Map[ y ][ x ].Layer[ 0 ] := 1;
          Map[ y ][ x ].Tile[ 1 ] := 5;
          Map[ y ][ x ].Height[ 1 ] := 8;
          Map[ y ][ x ].Layer[ 1 ] := 2;
          Map[ y ][ x ].Walkable := false;
        end;

        '6' : // 6 -> Builing roof
        begin
          Map[ y ][ x ].Num := 1;
          Map[ y ][ x ].Tile[ 0 ] := 5;
          Map[ y ][ x ].Height[ 0 ] := 8;
          Map[ y ][ x ].Layer[ 0 ] := 2;
          Map[ y ][ x ].Walkable := false;
        end;

        '7' : // 7 -> Builing door and stairs
        begin
          Map[ y ][ x ].Num := 3;
          Map[ y ][ x ].Tile[ 0 ] := 3;
          Map[ y ][ x ].Height[ 0 ] := 0;
          Map[ y ][ x ].Layer[ 0 ] := 1;
          Map[ y ][ x ].Tile[ 1 ] := 10;
          Map[ y ][ x ].Height[ 1 ] := 0;
          Map[ y ][ x ].Layer[ 1 ] := 1;
          Map[ y ][ x ].Tile[ 2 ] := 5;
          Map[ y ][ x ].Height[ 2 ] := 8;
          Map[ y ][ x ].Layer[ 2 ] := 2;
          Map[ y ][ x ].Walkable := false;
        end;

        '8' : // 8 -> Builing door and roof
        begin
          Map[ y ][ x ].Num := 3;
          Map[ y ][ x ].Tile[ 0 ] := 4;
          Map[ y ][ x ].Height[ 0 ] := 0;
          Map[ y ][ x ].Layer[ 0 ] := 1;
          Map[ y ][ x ].Tile[ 1 ] := 11;
          Map[ y ][ x ].Height[ 1 ] := 0;
          Map[ y ][ x ].Layer[ 1 ] := 1;
          Map[ y ][ x ].Tile[ 2 ] := 5;
          Map[ y ][ x ].Height[ 2 ] := 8;
          Map[ y ][ x ].Layer[ 2 ] := 2;
          Map[ y ][ x ].Walkable := false;
        end;

        'A' : // A -> Plant
        begin
          Map[ y ][ x ].Num := 2;
          Map[ y ][ x ].Tile[ 0 ] := 0;
          Map[ y ][ x ].Height[ 0 ] := 0;
          Map[ y ][ x ].Layer[ 0 ] := 0;
          Map[ y ][ x ].Tile[ 1 ] := 15;
          Map[ y ][ x ].Height[ 1 ] := 28;
          Map[ y ][ x ].Layer[ 1 ] := 1;
          Map[ y ][ x ].Walkable := false;
        end;

        'B' : // B -> Palm Tree
        begin
          Map[ y ][ x ].Num := 2;
          Map[ y ][ x ].Tile[ 0 ] := 0;
          Map[ y ][ x ].Height[ 0 ] := 0;
          Map[ y ][ x ].Layer[ 0 ] := 0;
          Map[ y ][ x ].Tile[ 1 ] := 16;
          Map[ y ][ x ].Height[ 1 ] := 61;
          Map[ y ][ x ].Layer[ 1 ] := 1;
          Map[ y ][ x ].Walkable := false;
        end;

      end;
    end;
  end;
end;

procedure TMainForm.DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //Whenever the mouse is moved, these variables will be updated with the
  //new coordinates of the mouse!
  MouseX := X;
  MouseY := Y;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DXImageList.Items.MakeColorTable; // if you use 256 color images for everything
  DXDraw.ColorTable := DXImageList.Items.ColorTable; // use this for a glogal palette
  DXDraw.DefColorTable := DXImageList.Items.ColorTable;
  DXDraw.UpdatePalette;
  DXDraw.cursor:=crNone;  // MEW -- disable cursor while on DXDraw
end;

end.
