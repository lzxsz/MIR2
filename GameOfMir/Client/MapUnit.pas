unit MapUnit;
 //地图单元
{ MAP文件结构
    文件头：52字节
    第一行第一列定义
    第二行第一列定义
    第三行第一列定义
    。
    第Width行第一列定义
    第一行第二列定义
}
interface

uses
   Windows, Classes, SysUtils, Grobal2, HUtil32, DXDraws, CliUtil,
   MShare, Share;



type
// -------------------------------------------------------------------------------
// Map
// -------------------------------------------------------------------------------

  TMapPrjInfo = record
     Ident: string[16];
     ColCount: integer;
     RowCount: integer;
  end;
    //.MAP文件头  52bytes
  TMapHeader = packed record
    wWidth      :Word;        //宽度      2
    wHeight     :Word;        //高度      2
    sTitle      :String[16];     //标题      16
    UpdateDate  :TDateTime;      //更新日期  8
    Reserved    :array[0..22] of Char;  //保留      20
  end;
  TMapInfo = packed record
    wBkImg       :Word;
    wMidImg      :Word;
    wFrImg       :Word;
    btDoorIndex  :Byte;  //$80 (巩娄), 巩狼 侥喊 牢郸胶
    btDoorOffset :Byte;  //摧腮 巩狼 弊覆狼 惑措 困摹, $80 (凯覆/摧塞(扁夯))
    btAniFrame   :Byte;      //$80(Draw Alpha) +  橇贰烙 荐
    btAniTick    :Byte;
    btArea       :Byte;        //瘤开 沥焊
    btLight      :Byte;       //0..1..4 堡盔 瓤苞
  end;
  pTMapInfo = ^TMapInfo;

  TMapInfoArr = array[0..MaxListSize] of TMapInfo;
  pTMapInfoArr = ^TMapInfoArr;

  TMap = class
  private
    function  LoadMapInfo(sMapFile:String; var nWidth, nHeight: Integer): Boolean;
    procedure UpdateMapSeg (cx, cy: integer); //, maxsegx, maxsegy: integer);
    procedure LoadMapArr(nCurrX, nCurrY: integer);
    procedure SaveMapArr(nCurrX,nCurrY:Integer);
  public
    m_sMapBase      :string;
    m_MArr          :array[0..MAXX * 3, 0..MAXY * 3] of TMapInfo;
    m_boChange      :Boolean;
    m_ClientRect    :TRect;
    m_OldClientRect :TRect;
    m_nBlockLeft    :Integer;
    m_nBlockTop     :Integer; //鸥老 谅钎肺 哭率, 怖措扁 谅钎
    m_nOldLeft      :Integer;
    m_nOldTop       :Integer;
    m_sOldMap       :String;
    m_nCurUnitX     :Integer;
    m_nCurUnitY     :Integer;
    m_sCurrentMap   :String;
    m_boSegmented   :Boolean;
    m_nSegXCount    :Integer;
    m_nSegYCount    :Integer;
    constructor Create;
    destructor Destroy;override;//Jacky
    procedure UpdateMapSquare (cx, cy: integer);
    procedure UpdateMapPos (mx, my: integer);
    procedure ReadyReload;
    procedure LoadMap(sMapName:String;nMx,nMy:Integer);
    procedure MarkCanWalk (mx, my: integer; bowalk: Boolean);
    function  CanMove (mx, my: integer): Boolean;
    function  CanFly  (mx, my: integer): Boolean;
    function  GetDoor (mx, my: integer): Integer;
    function  IsDoorOpen (mx, my: integer): Boolean;
    function  OpenDoor (mx, my: integer): Boolean;
    function  CloseDoor (mx, my: integer): Boolean;
  end;

  procedure DrawMiniMap;

implementation

uses
   ClMain;


constructor TMap.Create;
begin
   inherited Create;
   //GetMem (MInfoArr, sizeof(TMapInfo) * LOGICALMAPUNIT * 3 * LOGICALMAPUNIT * 3);
   m_ClientRect  := Rect (0,0,0,0);
   m_boChange    :=False;
   m_sMapBase    := '.\Map\'; //地图文件所在目录
   m_sCurrentMap := '';       //当前地图文件名（不含.MAP）
   m_boSegmented := FALSE;
   m_nSegXCount  := 0;
   m_nSegYCount  := 0;
   m_nCurUnitX   := -1;       //当前单元位置X、Y
   m_nCurUnitY   := -1;
   m_nBlockLeft  := -1;       //当前块X,Y左上角
   m_nBlockTop   := -1;
   m_sOldMap     := '';       //前一个地图文件名（在换地图的时候用）
end;

destructor TMap.Destroy;
begin
   inherited Destroy;
end;
//读MAP文件的宽度和高度
function  TMap.LoadMapInfo (sMapFile:String; var nWidth, nHeight: Integer): Boolean;
var
  sFileName    :String;
  nHandle      :Integer;
  Header       :TMapHeader;
begin
  Result := FALSE;
  sFileName := m_sMapBase + sMapFile;
  if FileExists (sFileName) then begin
    nHandle := FileOpen (sFileName, fmOpenRead or fmShareDenyNone);
    if nHandle > 0 then begin
      FileRead (nHandle, Header, sizeof(TMapHeader));
      nWidth := Header.wWidth;
      nHeight := Header.wHeight;
    end;
    FileClose(nHandle);
  end;
end;

//segmented map 牢 版快
procedure TMap.UpdateMapSeg (cx, cy: integer); //, maxsegx, maxsegy: integer);
begin

end;

//加载地图段数据
//以当前座标为准
procedure TMap.LoadMapArr(nCurrX,nCurrY: integer);
var
  I         :Integer;
  K         :Integer;
  nAline    :Integer;
  nLx       :Integer;
  nRx       :Integer;
  nTy       :Integer;
  nBy       :Integer;
  sFileName :String;
  nHandle   :Integer;
  Header    :TMapHeader; 
begin
  FillChar(m_MArr, SizeOf(m_MArr), #0);
  sFileName:=m_sMapBase + m_sCurrentMap + '.map';
  if FileExists(sFileName) then begin
    nHandle:=FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if nHandle > 0 then begin
      FileRead (nHandle, Header, SizeOf(TMapHeader));
      nLx := (nCurrX - 1) * LOGICALMAPUNIT;
      nRx := (nCurrX + 2) * LOGICALMAPUNIT;    //rx
      nTy := (nCurrY - 1) * LOGICALMAPUNIT;
      nBy := (nCurrY + 2) * LOGICALMAPUNIT;

      if nLx < 0 then nLx := 0;
      if nTy < 0 then nTy := 0;
      if nBy >= Header.wHeight then nBy := Header.wHeight;
      nAline := SizeOf(TMapInfo) * Header.wHeight; //一个列的大小（字节数）
      for I:=nLx to nRx - 1 do begin    //i最多有 3*LOGICALMAPUNIT 值,这就是要更新的地图的行数
        if (I >= 0) and (I < Header.wWidth) then begin
        //当前行列为X,Y，则应从X*每行字节数+Y*每项字节数开始读第一行数据
          FileSeek(nHandle, SizeOf(TMapHeader) + (nAline * I) + (SizeOf(TMapInfo) * nTy), 0);
          FileRead(nHandle, m_MArr[I - nLx, 0], SizeOf(TMapInfo) * (nBy - nTy));
        end;
      end;
      FileClose(nHandle);
    end;
  end;
end;

procedure TMap.SaveMapArr(nCurrX,nCurrY:Integer);
var
  I         :Integer;
  K         :Integer;
  nAline    :Integer;
  nLx       :Integer;
  nRx       :Integer;
  nTy       :Integer;
  nBy       :Integer;
  sFileName :String;
  nHandle   :Integer;
  Header    :TMapHeader; 
begin
  FillChar(m_MArr, SizeOf(m_MArr), #0);
  sFileName:=m_sMapBase + m_sCurrentMap + '.map';
  if FileExists(sFileName) then begin
    nHandle:=FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if nHandle > 0 then begin
      FileRead (nHandle, Header, SizeOf(TMapHeader));
      nLx := (nCurrX - 1) * LOGICALMAPUNIT;
      nRx := (nCurrX + 2) * LOGICALMAPUNIT;    //rx
      nTy := (nCurrY - 1) * LOGICALMAPUNIT;
      nBy := (nCurrY + 2) * LOGICALMAPUNIT;

      if nLx < 0 then nLx := 0;
      if nTy < 0 then nTy := 0;
      if nBy >= Header.wHeight then nBy := Header.wHeight;
      nAline := SizeOf(TMapInfo) * Header.wHeight;
      for I:=nLx to nRx - 1 do begin
        if (I >= 0) and (I < Header.wWidth) then begin
          FileSeek(nHandle, SizeOf(TMapHeader) + (nAline * I) + (SizeOf(TMapInfo) * nTy), 0);
          FileRead(nHandle, m_MArr[I - nLx, 0], SizeOf(TMapInfo) * (nBy - nTy));
        end;
      end;
      FileClose(nHandle);
    end;
  end;
end;
procedure TMap.ReadyReload;
begin
   m_nCurUnitX := -1;
   m_nCurUnitY := -1;
end;

//cx, cy: 位置, 以LOGICALMAPUNIT为单位
procedure TMap.UpdateMapSquare (cx, cy: integer);
begin
  if (cx <> m_nCurUnitX) or (cy <> m_nCurUnitY) then begin
    if m_boSegmented then
      updatemapseg (cx, cy)
    else
      LoadMapArr(cx, cy);
    m_nCurUnitX := cx;
    m_nCurUnitY := cy;
  end;
end;

//林某腐捞 捞悼矫 后锅捞 龋免..
procedure TMap.UpdateMapPos (mx, my: integer);   //mx,my象素坐标
var
   cx, cy: integer; //地图的逻辑坐标
   procedure Unmark (xx, yy: integer); //xx,yy是象素点坐标
   var
      ax, ay: integer;
   begin
      if (cx = xx div LOGICALMAPUNIT) and (cy = yy div LOGICALMAPUNIT) then begin
         ax := xx - m_nBlockLeft;
         ay := yy - m_nBlockTop;
         m_MArr[ax,ay].wFrImg := m_MArr[ax,ay].wFrImg and $7FFF;
         m_MArr[ax,ay].wBkImg := m_MArr[ax,ay].wBkImg and $7FFF;
      end;
   end;
begin
   cx := mx div LOGICALMAPUNIT;    //折算成逻辑坐标
   cy := my div LOGICALMAPUNIT;
   m_nBlockLeft := _MAX (0, (cx - 1) * LOGICALMAPUNIT);    //象素坐标
   m_nBlockTop  := _MAX (0, (cy - 1) * LOGICALMAPUNIT);

   UpdateMapSquare (cx, cy);

   if (m_nOldLeft <> m_nBlockLeft) or (m_nOldTop <> m_nBlockTop) or (m_sOldMap <> m_sCurrentMap) then begin
      //3锅甘 己寒磊府 滚弊 焊沥 (2001-7-3)
      if m_sCurrentMap = '3' then begin
         Unmark (624, 278);
         Unmark (627, 278);
         Unmark (634, 271);

         Unmark (564, 287);
         Unmark (564, 286);
         Unmark (661, 277);
         Unmark (578, 296);
      end;
   end;
   m_nOldLeft := m_nBlockLeft;
   m_nOldTop := m_nBlockTop;
end;

//甘函版矫 贸澜 茄锅 龋免..
procedure TMap.LoadMap(sMapName:String;nMx,nMy:Integer);
begin
   m_nCurUnitX   := -1;
   m_nCurUnitY   := -1;
   m_sCurrentMap := sMapName;
   m_boSegmented := FALSE; //Segmented 登绢 乐绰瘤 八荤茄促.
   UpdateMapPos(nMx, nMy);
   m_sOldMap := m_sCurrentMap;
end;
//置前景是否可以行走
procedure TMap.MarkCanWalk (mx, my: integer; bowalk: Boolean);
var
   cx, cy: integer;
begin
   cx := mx - m_nBlockLeft;
   cy := my - m_nBlockTop;
   if (cx < 0) or (cy < 0) then exit;
   if bowalk then //该坐标可以行走，则MArr[cx,cy]的值最高位为0
      Map.m_MArr[cx, cy].wFrImg := Map.m_MArr[cx, cy].wFrImg and $7FFF
   else //不可以行走的，最高位为1
      Map.m_MArr[cx, cy].wFrImg := Map.m_MArr[cx, cy].wFrImg or $8000;  //给框流捞霸 茄促.
end;
 //若前景和背景都可以走，则返回真
function  TMap.CanMove (mx, my: integer): Boolean;
var
   cx, cy: integer;
begin
   Result:=False;  //jacky
   cx := mx - m_nBlockLeft;
   cy := my - m_nBlockTop;
   if (cx < 0) or (cy < 0) then exit;
      //前景和背景都可以走（最高位为0）
   Result := ((Map.m_MArr[cx, cy].wBkImg and $8000) + (Map.m_MArr[cx, cy].wFrImg and $8000)) = 0;
   if Result then begin //巩八荤
      if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin  //巩娄捞 乐澜
         if (Map.m_MArr[cx, cy].btDoorOffset and  $80) = 0 then
            Result := FALSE; //巩捞 救 凯啡澜.
      end;
   end;
end;
 //若前景可以走，则返回真。
function  TMap.CanFly(mx, my: integer): Boolean;
var
   cx, cy: integer;
begin
   Result:=False;  //jacky
   cx := mx - m_nBlockLeft;
   cy := my - m_nBlockTop;
   if (cx < 0) or (cy < 0) then exit;
   Result := (Map.m_MArr[cx, cy].wFrImg and $8000) = 0;
   if Result then begin //巩八荤
      if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin  //巩娄捞 乐澜
         if (Map.m_MArr[cx, cy].btDoorOffset and  $80) = 0 then
            Result := FALSE; //巩捞 救 凯啡澜.
      end;
   end;
end;
 //获得指定坐标的门的索引号
function  TMap.GetDoor (mx, my: integer): Integer;
var
   cx, cy: integer;
begin
   Result := 0;
   cx := mx - m_nBlockLeft;
   cy := my - m_nBlockTop;
   if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin
      Result := Map.m_MArr[cx, cy].btDoorIndex and $7F;
   end;
end;
 //判断门是否打开
function  TMap.IsDoorOpen (mx, my: integer): Boolean;
var
   cx, cy: integer;
begin
   Result := FALSE;
   cx := mx - m_nBlockLeft;
   cy := my - m_nBlockTop;
   if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin
      Result := (Map.m_MArr[cx, cy].btDoorOffset and $80 <> 0);
   end;
end;
 //打开门
function  TMap.OpenDoor (mx, my: integer): Boolean;
var
   i, j, cx, cy, idx: integer;
begin
   Result := FALSE;
   cx := mx - m_nBlockLeft;
   cy := my - m_nBlockTop;
   if (cx < 0) or (cy < 0) then exit;
   if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin
      idx := Map.m_MArr[cx, cy].btDoorIndex and $7F;
      for i:=cx - 10 to cx + 10 do
         for j:=cy - 10 to cy + 10 do begin
            if (i > 0) and (j > 0) then
               if (Map.m_MArr[i, j].btDoorIndex and $7F) = idx then
                  Map.m_MArr[i, j].btDoorOffset := Map.m_MArr[i, j].btDoorOffset or $80;
         end;
   end;
end;

function  TMap.CloseDoor (mx, my: integer): Boolean;
var
   i, j, cx, cy, idx: integer;
begin
   Result := FALSE;
   cx := mx - m_nBlockLeft;
   cy := my - m_nBlockTop;
   if (cx < 0) or (cy < 0) then exit;
   if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin
      idx := Map.m_MArr[cx, cy].btDoorIndex and $7F;
      for i:=cx-8 to cx+10 do
         for j:=cy-8 to cy+10 do begin
            if (Map.m_MArr[i, j].btDoorIndex and $7F) = idx then
               Map.m_MArr[i, j].btDoorOffset := Map.m_MArr[i, j].btDoorOffset and $7F;
         end;
   end;
end;


const
   SCALE = 4;
//画小地图
procedure DrawMiniMap;
var
   sx, sy, ex, ey, i, j, imgnum, wunit, ani, ny, oheight, MX, MY: integer;
   d: TDirectDrawSurface;
begin
   g_MiniMapSurface.Fill(0);
   MX := UNITX div SCALE;
   MY := UNITY div SCALE;
   sx := _MAX(0,      (g_MySelf.m_nCurrX - Map.m_nBlockLeft) div 2 * 2 - 22);
   ex := _MIN(MAXX*3, (g_MySelf.m_nCurrX - Map.m_nBlockLeft) div 2 * 2 + 22);
   sy := _MAX(0,      (g_MySelf.m_nCurrY - Map.m_nBlockTop) div 2 * 2 - 22);
   ey := _MIN(MAXY*3, (g_MySelf.m_nCurrY - Map.m_nBlockTop) div 2 * 2 + 22);

   for i:=0 to ex-sx do begin
      for j:=0 to ey-sy do begin
         if (i >= 0) and (j < MAXY*3) and ((i+sx) mod 2 = 0) and ((j+sy) mod 2 = 0) then begin
            imgnum := (Map.m_MArr[sx+i, sy+j].wBkImg and $7FFF);
            if imgnum > 0 then begin
               imgnum := imgnum - 1;
               d := g_WTilesImages.Images[imgnum];
               if d <> nil then
                  g_MiniMapSurface.StretchDraw (
                                 Rect (i*MX, j*MY, i*MX + d.Width div SCALE, j*MY + d.Height div SCALE),
                                 d.ClientRect,
                                 d,
                                 FALSE);

            end;
         end;
      end;
   end;
   for i:=0 to ex-sx-1 do begin
      for j:=0 to ey-sy-1 do begin
         imgnum := Map.m_MArr[sx+i, sy+j].wMidImg;
         if imgnum > 0 then begin
            imgnum := imgnum - 1;
            d := g_WSmTilesImages.Images[imgnum];
            if d <> nil then
               g_MiniMapSurface.StretchDraw (
                              Rect (i*MX, j*MY, i*MX + d.Width div SCALE, j*MY + d.Height div SCALE),
                              d.ClientRect,
                              d,
                              TRUE);
         end;
      end;
   end;
   for j:=0 to ey-sy-1+25 do begin
      for i:=0 to ex-sx do begin
         if (i >= 0) and (i < MAXX*3) and (j < MAXY*3) then begin
            imgnum := (Map.m_MArr[sx+i, sy+j].wFrImg and $7FFF);
            if imgnum > 0 then begin
               wunit := Map.m_MArr[sx+i, sy+j].btArea;
               ani := Map.m_MArr[sx+i, sy+j].btAniFrame;
               if (ani and $80) > 0 then begin
                  continue;
               end;
               imgnum := imgnum - 1;
               d := GetObjs(wunit, imgnum);
               if d <> nil then begin
                  ny := j*MY - d.Height div SCALE + MY;
                  if ny < 360 then
                     g_MiniMapSurface.StretchDraw (
                                 Rect (i*MX, ny, i*MX + d.Width div SCALE, ny + d.Height div SCALE),
                                 d.ClientRect,
                                 d,
                                 TRUE);
               end;
            end;
         end;
      end;
   end;
   //DrawEffect (0, 0, MiniMapSurface.Width, MiniMapSurface.Height, MiniMapSurface, ceGrayScale);
end;


end.
