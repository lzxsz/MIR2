unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass,turbopixels;



const maxrad=8;
      maxbod=5;
      dguma=20;
      sguma=1.8;
      vaha=1;
      grav=5;
      odpor=2.5;
type
  TForm1 = class(TForm)
    DXTimer: TDXTimer;
    DXDraw: TDXDraw;
    DXImageList: TDXImageList;
    procedure FormCreate(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


  tbod=record
      x,y,vx,vy : real;
     end;

  tvec=record
         x,y:real;
       end;

var
  Form1: TForm1;
  bod:array[1..maxrad,0..maxbod] of tbod;
  svec,rvec,avec:tvec;
  sit,body:boolean;
implementation

{$R *.DFM}


procedure init;
var t,i:integer;
begin
   for i:=1 to maxrad do begin
     for t:=0 to maxbod do begin
      bod[i,t].x:=Mouse.CursorPos.x+i*dguma;
      bod[i,t].y:=Mouse.CursorPos.y+t*dguma;
    end;
   end;
   sit:=true;
   body:=true;
end;


procedure spring(t1,t2:tbod;var v:tvec);
var dx,dy:real;
    d,sf:real;
begin
    dx:=t1.X-t2.X;
    dy:=t1.Y-t2.Y;
    d:=sqrt(sqr(dx) +sqr(dy));
    if (d>DGUMA) then begin
     SF:=SGUMA*(d-DGUMA);
     v.x:=v.x+((dx/d)* SF);
     v.y:=v.y+((dy/d)* SF);
   end;
end;

procedure pocitej;
var t,i:integer;
    zx,zy,dx,dy,delx,deldx,z:real;
begin
  for i:=1 to maxrad do begin
   for t:=0 to maxbod do begin
    if ((t=0) and (i=1)) or ( (t=0) and (i=maxrad) ) then continue;
    svec.x:=0;     // svec je vysledek pusobeni kouli na sebe
    svec.y:=0;

    if t>0 then spring(bod[i,t-1],bod[i,t],svec);
    if t<maxbod then   spring(bod[i,t+1],bod[i,t],svec);

    if i<maxrad then  spring(bod[i+1,t],bod[i,t],svec);
    if i>1 then  spring(bod[i-1,t],bod[i,t],svec);

    rvec.x:=-bod[i,t].vx*ODPOR;           // odpor prostredi
    rvec.y:=-bod[i,t].vy*ODPOR;

    avec.x:=(svec.x+rvec.x)*0.01;            //gravitace a delim to
    avec.y:=((svec.y+rvec.y)+GRAV)*0.01;

    bod[i,t].vx:=bod[i,t].vx+avec.x;
    bod[i,t].vy:=bod[i,t].vy+avec.y;

    bod[i,t].x:=bod[i,t].x+bod[i,t].vx;
    bod[i,t].y:=bod[i,t].y+bod[i,t].vy;

    if (bod[i,t].x>screen.Width) or (bod[i,t].x<0) then bod[i,t].vx:=-bod[i,t].vx*0.9;
    if (bod[i,t].y>screen.Height) or (bod[i,t].y<0) then bod[i,t].vy:=-bod[i,t].vy;

   end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DXImageList.Items.MakeColorTable; // if you use 256 color images for everything
  DXDraw.ColorTable := DXImageList.Items.ColorTable; // use this for a glogal palette
  DXDraw.DefColorTable := DXImageList.Items.ColorTable;
  DXDraw.UpdatePalette;
  init;
end;

procedure TForm1.DXDrawInitialize(Sender: TObject);
begin
  DXTimer.Enabled := True; // start game thread
  DxDraw.Cursor := crnone;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = VK_ESCAPE then
    Close;
 if Key =ord('N') then sit:=not sit;
 if Key =ord('P') then body:=not body;

end;

procedure TForm1.DXTimerTimer(Sender: TObject; LagCount: Integer);
var mx,my,t,i:integer;
    r:array[0..3] of tpoint;

begin
pocitej;
if not DXDraw.CanDraw then Exit;

    bod[1,0].x := Mouse.CursorPos.x;
    bod[1,0].y := Mouse.CursorPos.y;

    bod[maxrad,0].x := Mouse.CursorPos.x+(maxrad*dguma);
    bod[maxrad,0].y := Mouse.CursorPos.y;

  DXDraw.Surface.Fill(0); // clear screen

  if sit then begin
    turboLock(DXDraw.Surface);

    for i:=1 to maxrad do  for t:=1 to maxbod do
        turboWuLine16(round(bod[i][t-1].x), round(bod[i][t-1].y),  round(bod[i][t].x), round(bod[i][t].y),  192, 192, 192);

    for t:=0 to maxbod do  for i:=1 to maxrad-1 do
        turboWuLine16(round(bod[i][t].x), round(bod[i][t].y),  round(bod[i+1][t].x), round(bod[i+1][t].y),  192, 192, 192);

    turbounLock;
  end;

  if body then
  for i:=1 to maxrad do  for t:=0 to maxbod do with DXImageList.items.find('bod') do
    if do3D in DXDraw.Options then
      drawadd(DXDraw.Surface, Bounds(round(bod[i][t].x)-5, round(bod[i][t].y)-5,width,height), 0)
    else
      draw(DXDraw.Surface, round(bod[i][t].x)-5, round(bod[i][t].y)-5, 0);

  if do3D in DXDraw.Options then 
    with DXDraw.Surface.Canvas do begin
      TextOut(0,3,'FPS: ' + inttostr(dxtimer.FrameRate)+ '  2001 - radekurban@yahoo.com, www.geocities.com/urbo_cz');
      TextOut(0,15,'Press "N" for on/off lines , "P" for on/off pixels.');
      Release
    end
    else begin
  turbowrite(dxdraw.Surface, DXImageList, 'font',
    'FPS: ' + inttostr(dxtimer.FrameRate)+ '  2001 - radekurban@yahoo.com, www.geocities.com/urbo_cz', 0, 3);
  turbowrite(dxdraw.Surface, DXImageList, 'font','Press "N" for on/off lines , "P" for on/off pixels.', 0, 15);
  end;

  DXDraw.Flip; // show screen
end;
end.
