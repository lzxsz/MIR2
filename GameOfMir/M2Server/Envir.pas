unit Envir;

interface

uses
  Windows, SysUtils, Classes, Dialogs, Grobal2, MudUtil, SDK;
type
  TEnvirnoment = class;


  pTOSObject = ^TOSObject;
  TOSObject = record
    btType: Byte;
    CellObj: TObject;
    dwAddTime: dword;
  end;

  TMapHeader = packed record
    wWidth: Word;
    wHeight: Word;
    sTitle: string[16];
    UpdateDate: TDateTime;
    Reserved: array[0..22] of Char;
  end;
  TMapUnitInfo = packed record
    wBkImg: Word; //32768 $8000 为禁止移动区域
    wMidImg: Word;
    wFrImg: Word;
    btDoorIndex: Byte; //$80 (巩娄), 巩狼 侥喊 牢郸胶
    btDoorOffset: Byte; //摧腮 巩狼 弊覆狼 惑措 困摹, $80 (凯覆/摧塞(扁夯))
    btAniFrame: Byte; //$80(Draw Alpha) +  橇贰烙 荐
    btAniTick: Byte;
    btArea: Byte; //瘤开 沥焊
    btLight: Byte; //0..1..4 堡盔 瓤苞
  end;
  pTMapUnitInfo = ^TMapUnitInfo;
  TMap = array[0..1000 * 1000 - 1] of TMapUnitInfo;
  pTMap = ^TMap;
  TMapCellinfo = record
    chFlag: Byte;
    ObjList: TList;
  end;
  pTMapCellinfo = ^TMapCellinfo;

  TEnvirnoment = class
    Header: TMapHeader;

    sMapName: string; //0x4
    sMapDesc: string;
    MapCellArray: array of TMapCellinfo; //0x0C
    nMinMap: Integer; //0x10
    nServerIndex: Integer; //0x14
    nRequestLevel: Integer; //0x18 进入本地图所需等级

    Flag: TMapFlag;
    bo2C: Boolean;
    m_DoorList: TList;
    QuestNPC: TObject;
    m_QuestList: TList;
    m_dwWhisperTick: LongWord;

  private
    m_nMonCount: Integer;
    m_nHumCount: Integer;

    procedure Initialize(nWidth, nHeight: Integer);
  public
    constructor Create();
    destructor Destroy; override;
    function AddToMap(nX, nY: Integer; btType: Byte; pRemoveObject: TObject): Pointer;
    function CanWalk(nX, nY: Integer; boFlag: Boolean = False): Boolean;
    function CanWalkOfItem(nX, nY: Integer; boFlag, boItem: Boolean): Boolean;
    function CanWalkEx(nX, nY: Integer; boFlag: Boolean): Boolean;
    function CanFly(nSX, nSY, nDX, nDY: Integer): Boolean;
    function MoveToMovingObject(nCX, nCY: Integer; Cert: TObject; nX, nY: Integer; boFlag: Boolean): Integer;
    function GetItem(nX, nY: Integer): pTMapItem;
    function DeleteFromMap(nX, nY: Integer; btType: Byte; pRemoveObject: TObject): Integer;
    function IsCheapStuff(): Boolean;
    procedure AddDoorToMap;
    function AddToMapMineEvent(nX, nY: Integer; nType: Integer; Event: TObject): TObject;
    function LoadMapData(sMapFile: string): Boolean;
    function CreateQuest(nFlag, nValue: Integer; sMonName, sItem, sQuest: string; boGrouped: Boolean): Boolean;
    function GetMapCellInfo(nX, nY: Integer; var MapCellInfo: pTMapCellinfo): Boolean;
    function GetXYObjCount(nX, nY: Integer): Integer;
    function GetNextPosition(sX, sY, nDir, nFlag: Integer; var snx: Integer; var sny: Integer): Boolean;
    function IsValidCell(nX, nY: Integer): Boolean;
    procedure VerifyMapTime(nX, nY: Integer; BaseObject: TObject);
    function CanSafeWalk(nX, nY: Integer): Boolean;
    function ArroundDoorOpened(nX, nY: Integer): Boolean;
    function GetMovingObject(nX, nY: Integer; boFlag: Boolean): Pointer;
    function GetQuestNPC(BaseObject: TObject; sCharName, sItem: string; boFlag: Boolean): TObject;
    function GetItemEx(nX, nY: Integer; var nCount: Integer): Pointer;
    function GetDoor(nX, nY: Integer): pTDoorInfo;
    function IsValidObject(nX, nY: Integer; nRage: Integer; BaseObject: TObject): Boolean;
    function GetRangeBaseObject(nX, nY: Integer; nRage: Integer; boFlag: Boolean; BaseObjectList: TList): Integer;
    function GeTBaseObjects(nX, nY: Integer; boFlag: Boolean; BaseObjectList: TList): Integer;
    function GetEvent(nX, nY: Integer): TObject;
    procedure SetMapXYFlag(nX, nY: Integer; boFlag: Boolean);
    function GetXYHuman(nMapX, nMapY: Integer): Boolean;
    function GetEnvirInfo(): string;
    procedure AddObject(BaseObject: TObject);
    procedure DelObjectCount(BaseObject: TObject);
    property MonCount: Integer read m_nMonCount;
    property HumCount: Integer read m_nHumCount;
  end;
  TMapManager = class(TGList) //004B52B0
  private
  public
    constructor Create();
    destructor Destroy; override;
    procedure LoadMapDoor();
    function AddMapInfo(sMapName, sMapDesc: string; nServerNumber: Integer; MapFlag: pTMapFlag; QuestNPC: TObject): TEnvirnoment;
    function GetMapInfo(nServerIdx: Integer; sMapName: string): TEnvirnoment;
    function AddMapRoute(sSMapNO: string; nSMapX, nSMapY: Integer; sDMapNO: string; nDMapX, nDMapY: Integer): Boolean;
    function GetMapOfServerIndex(sMapName: string): Integer;
    function FindMap(sMapName: string): TEnvirnoment;
    procedure ReSetMinMap();
    procedure Run();
    procedure ProcessMapDoor();
  end;
implementation

uses ObjBase, ObjNpc, M2Share, Event, ObjMon, HUtil32, Castle;

{ TEnvirList }

//004B7038
function TMapManager.AddMapInfo(sMapName, sMapDesc: string; nServerNumber: Integer; MapFlag: pTMapFlag; QuestNPC: TObject): TEnvirnoment;
var
  Envir: TEnvirnoment;
  i: Integer;
begin
  Result := nil;
  Envir := TEnvirnoment.Create;
  Envir.sMapName := sMapName;
  Envir.sMapDesc := sMapDesc;
  Envir.nServerIndex := nServerNumber;

  Envir.Flag := MapFlag^;
  Envir.QuestNPC := QuestNPC;

  for i := 0 to MiniMapList.Count - 1 do
  begin
    if CompareText(MiniMapList.Strings[i], Envir.sMapName) = 0 then
    begin
      Envir.nMinMap := Integer(MiniMapList.Objects[i]);
      Break;
    end;
  end;
  if Envir.LoadMapData(g_Config.sMapDir + sMapName + '.map') then
  begin
    Result := Envir;
    Self.Add(Envir);
  end else
  begin
    MainOutMessage('Failure: ' + g_Config.sMapDir + sMapName + '.map' + ' could not be loaded.');
  end;
end;
//004B7280
function TMapManager.AddMapRoute(sSMapNO: string; nSMapX, nSMapY: Integer; sDMapNO: string; nDMapX, nDMapY: Integer): Boolean;
var
  GateObj: pTGateObj;
  SEnvir: TEnvirnoment;
  DEnvir: TEnvirnoment;
begin
  Result := False;
  SEnvir := FindMap(sSMapNO);
  DEnvir := FindMap(sDMapNO);
  if (SEnvir <> nil) and (DEnvir <> nil) then
  begin
    New(GateObj);
    GateObj.boFlag := False;
    GateObj.DEnvir := DEnvir;
    GateObj.nDMapX := nDMapX;
    GateObj.nDMapY := nDMapY;
    SEnvir.AddToMap(nSMapX, nSMapY, OS_GATEOBJECT, TObject(GateObj));
    Result := True;
  end;

end;
//004B63E4
function TEnvirnoment.AddToMap(nX, nY: Integer; btType: Byte;
  pRemoveObject: TObject): Pointer;
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  MapItem: pTMapItem;
  i: Integer;
  nGoldCount: Integer;
  bo1E: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TEnvirnoment::AddToMap';
begin
  Result := nil;
  try
    bo1E := False;
    if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then
    begin
      if MapCellInfo.ObjList = nil then
      begin
        MapCellInfo.ObjList := TList.Create;
      end else
      begin
        if btType = OS_ITEMOBJECT then
        begin
          if pTMapItem(pRemoveObject).Name = sSTRING_GOLDNAME then
          begin
            for i := 0 to MapCellInfo.ObjList.Count - 1 do
            begin
              OSObject := MapCellInfo.ObjList.Items[i];
              if OSObject.btType = OS_ITEMOBJECT then
              begin
                MapItem := pTMapItem(pTOSObject(MapCellInfo.ObjList.Items[i]).CellObj);
                if MapItem.Name = sSTRING_GOLDNAME then
                begin
                  nGoldCount := MapItem.Count + pTMapItem(pRemoveObject).Count;
                  if nGoldCount <= 2000 then
                  begin
                    MapItem.Count := nGoldCount;
                    MapItem.Looks := GetGoldShape(nGoldCount);
                    MapItem.AniCount := 0;
                    MapItem.Reserved := 0;
                    OSObject.dwAddTime := GetTickCount();
                    Result := MapItem;
                    bo1E := True;
                  end;
                end;
              end;
            end; //004B653D
          end; //004B653D
          if not bo1E and (MapCellInfo.ObjList.Count >= 5) then
          begin
            Result := nil;
            bo1E := True;
          end; //004B6558
        end; //004B6558
        if btType = OS_EVENTOBJECT then
        begin

        end;
      end; //004B655C
      if not bo1E then
      begin
        New(OSObject);
        OSObject.btType := btType;
        OSObject.CellObj := pRemoveObject;
        OSObject.dwAddTime := GetTickCount();
        MapCellInfo.ObjList.Add(OSObject);
        Result := Pointer(pRemoveObject);

        if (btType = OS_MOVINGOBJECT) and (not TBaseObject(pRemoveObject).m_boAddToMaped) then
        begin
          TBaseObject(pRemoveObject).m_boDelFormMaped := False;
          TBaseObject(pRemoveObject).m_boAddToMaped := True;
          AddObject(pRemoveObject);
        end;

      end; //004B659F

    end; //004B659F
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

procedure TEnvirnoment.AddDoorToMap(); //004B6A74
var
  i: Integer;
  Door: pTDoorInfo;
begin
  for i := 0 to m_DoorList.Count - 1 do
  begin
    Door := m_DoorList.Items[i];
    AddToMap(Door.nX, Door.nY, OS_DOOR, TObject(Door));
  end;
end;
function TEnvirnoment.GetMapCellInfo(nX, nY: Integer; var MapCellInfo: pTMapCellinfo): Boolean; //004B57D8
begin
  if (nX >= 0) and (nX < Header.wWidth) and (nY >= 0) and (nY < Header.wHeight) then
  begin
    MapCellInfo := @MapCellArray[nX * Header.wHeight + nY];
    Result := True;
  end else
  begin //004B5829
    Result := False;
  end;
end;
function TEnvirnoment.MoveToMovingObject(nCX, nCY: Integer; Cert: TObject; nX, nY: Integer; boFlag: Boolean): Integer; //004B612C
var
  MapCellInfo: pTMapCellinfo;
  BaseObject: TBaseObject;
  OSObject: pTOSObject;
  i: Integer;
  bo1A: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TEnvirnoment::MoveToMovingObject';
label
  Loop, Over;
begin
  Result := 0;
  try
    bo1A := True;
    if not boFlag and GetMapCellInfo(nX, nY, MapCellInfo) then
    begin
      if MapCellInfo.chFlag = 0 then
      begin
        if MapCellInfo.ObjList <> nil then
        begin
          for i := 0 to MapCellInfo.ObjList.Count - 1 do
          begin //004B61AD
            if pTOSObject(MapCellInfo.ObjList.Items[i]).btType = OS_MOVINGOBJECT then
            begin
              BaseObject := TBaseObject(pTOSObject(MapCellInfo.ObjList.Items[i]).CellObj);
              if BaseObject <> nil then
              begin //004B61DB
                if not BaseObject.m_boGhost
                  and BaseObject.bo2B9
                  and not BaseObject.m_boDeath
                  and not BaseObject.m_boFixedHideMode
                  and not BaseObject.m_boObMode then
                begin
                  bo1A := False;
                  Break;
                end;
              end; //004B6223
            end; //004B6223
          end; //004B622D
        end; //004B6238
      end else
      begin //004B622D   if MapCellInfo.chFlag = 0 then begin
        Result := -1;
        bo1A := False;
      end; //004B6238
    end; //004B6238
    if bo1A then
    begin //004B6238
      if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag <> 0) then
      begin
        Result := -1;
      end else
      begin //004B6265
        if GetMapCellInfo(nCX, nCY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then
        begin
          i := 0;
          while (True) do
          begin
            if MapCellInfo.ObjList.Count <= i then Break;
            OSObject := MapCellInfo.ObjList.Items[i];
            if OSObject.btType = OS_MOVINGOBJECT then
            begin
              if TBaseObject(OSObject.CellObj) = TBaseObject(Cert) then
              begin
                MapCellInfo.ObjList.Delete(i);
                Dispose(OSObject);
                if MapCellInfo.ObjList.Count > 0 then Continue;
                MapCellInfo.ObjList.Free;
                MapCellInfo.ObjList := nil;
                Break;
              end;
            end;
            Inc(i);
          end;
        end; //4B6311
        if GetMapCellInfo(nX, nY, MapCellInfo) then
        begin
          if (MapCellInfo.ObjList = nil) then
          begin
            MapCellInfo.ObjList := TList.Create;
          end;
          New(OSObject);
          OSObject.btType := OS_MOVINGOBJECT;
          OSObject.CellObj := Cert;
          OSObject.dwAddTime := GetTickCount;
          MapCellInfo.ObjList.Add(OSObject);
          Result := 1;
        end; //004B6383
      end; //004B6383
    end; //004B6383
  except
    on E: Exception do
    begin
      MainOutMessage(sExceptionMsg);
      MainOutMessage(E.Message);
    end;
  end;
//  pMapCellInfo = GetMapCellInfo(nX, nY);
end;
//======================================================================
//检查地图指定座标是否可以移动
//boFlag  如果为TRUE 则忽略座标上是否有角色
//返回值 True 为可以移动，False 为不可以移动
//======================================================================
function TEnvirnoment.CanWalk(nX, nY: Integer; boFlag: Boolean = False): Boolean; //004B5ED0
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  i: Integer;
begin
  Result := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then
  begin
    Result := True;
    if not boFlag and (MapCellInfo.ObjList <> nil) then
    begin
      for i := 0 to MapCellInfo.ObjList.Count - 1 do
      begin
        OSObject := MapCellInfo.ObjList.Items[i];
        if OSObject.btType = OS_MOVINGOBJECT then
        begin
          BaseObject := TBaseObject(OSObject.CellObj);
          if BaseObject <> nil then
          begin
            if not BaseObject.m_boGhost
              and BaseObject.bo2B9
              and not BaseObject.m_boDeath
              and not BaseObject.m_boFixedHideMode
              and not BaseObject.m_boObMode then
            begin
              Result := False;
              Break;
            end;
          end; //004B5FB5
        end; //004B5FB5
      end;
    end;
  end; //004B5FBD
end;

//======================================================================
//检查地图指定座标是否可以移动
//boFlag  如果为TRUE 则忽略座标上是否有角色
//返回值 True 为可以移动，False 为不可以移动
//======================================================================
function TEnvirnoment.CanWalkOfItem(nX, nY: Integer; boFlag, boItem: Boolean): Boolean; //004B5ED0
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  i: Integer;
begin
  Result := True;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then
  begin
//    Result:=True;
    if (MapCellInfo.ObjList <> nil) then
    begin
      for i := 0 to MapCellInfo.ObjList.Count - 1 do
      begin
        OSObject := MapCellInfo.ObjList.Items[i];
        if not boFlag and (OSObject.btType = OS_MOVINGOBJECT) then
        begin
          BaseObject := TBaseObject(OSObject.CellObj);
          if BaseObject <> nil then
          begin
            if not BaseObject.m_boGhost
              and BaseObject.bo2B9
              and not BaseObject.m_boDeath
              and not BaseObject.m_boFixedHideMode
              and not BaseObject.m_boObMode then
            begin
              Result := False;
              Break;
            end;
          end; //004B5FB5
        end; //004B5FB5
        if not boItem and (OSObject.btType = OS_ITEMOBJECT) then
        begin
          Result := False;
          Break;
        end;
      end;
    end;
  end; //004B5FBD
end;

function TEnvirnoment.CanWalkEx(nX, nY: Integer; boFlag: Boolean): Boolean; //004B5ED0
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  i: Integer;
  Castle: TUserCastle;
begin
  Result := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then
  begin
    Result := True;
    if not boFlag and (MapCellInfo.ObjList <> nil) then
    begin
      for i := 0 to MapCellInfo.ObjList.Count - 1 do
      begin
        OSObject := MapCellInfo.ObjList.Items[i];
        if OSObject.btType = OS_MOVINGOBJECT then
        begin
          BaseObject := TBaseObject(OSObject.CellObj);
          if BaseObject <> nil then
          begin
            {//01/25 多城堡 控制
            if g_Config.boWarDisHumRun and UserCastle.m_boUnderWar and
              UserCastle.InCastleWarArea(BaseObject.m_PEnvir,BaseObject.m_nCurrX,BaseObject.m_nCurrY) then begin
            }
            Castle := g_CastleManager.InCastleWarArea(BaseObject);
            if g_Config.boWarDisHumRun and (Castle <> nil) and (Castle.m_boUnderWar) then
            begin
            end else
            begin
              if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
              begin
                if g_Config.boRUNHUMAN or Flag.boRUNHUMAN then Continue;
              end else
              begin
                if BaseObject.m_btRaceServer = RC_NPC then
                begin
                  if g_Config.boRunNpc then Continue;
                end else
                begin
                  if BaseObject.m_btRaceServer in [RC_GUARD, RC_ARCHERGUARD] then
                  begin
                    if g_Config.boRunGuard then Continue;
                  end else
                  begin
                    if g_Config.boRUNMON or Flag.boRUNMON then Continue;
                  end;
                end;
              end;
            end;

            if not BaseObject.m_boGhost
              and BaseObject.bo2B9
              and not BaseObject.m_boDeath
              and not BaseObject.m_boFixedHideMode
              and not BaseObject.m_boObMode then
            begin
              Result := False;
              Break;
            end;
          end; //004B5FB5
        end; //004B5FB5
      end;
    end;
  end; //004B5FBD
end;

constructor TMapManager.Create;
begin
  inherited Create;
end;

destructor TMapManager.Destroy;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    TEnvirnoment(Items[i]).Free;
  end;
  inherited;
end;
     //Envir:TEnvirnoment
function TMapManager.FindMap(sMapName: string): TEnvirnoment; //4B7350
var
  Map: TEnvirnoment;
  i: Integer;
begin
  Result := nil;
  Lock;
  try
    for i := 0 to Count - 1 do
    begin
      Map := TEnvirnoment(Items[i]);
      if CompareText(Map.sMapName, sMapName) = 0 then
      begin
        Result := Map;
        Break;
      end;
    end;
  finally
    UnLock;
  end;
end;

function TMapManager.GetMapInfo(nServerIdx: Integer; sMapName: string): TEnvirnoment; //004B7424
var
  i: Integer;
  Envir: TEnvirnoment;
begin
  Result := nil;
  Lock;
  try
    for i := 0 to Count - 1 do
    begin
      Envir := Items[i];
      if (Envir.nServerIndex = nServerIdx) and (CompareText(Envir.sMapName, sMapName) = 0) then
      begin
        Result := Envir;
        Break;
      end;
    end; //004B74C8
  finally
    UnLock;
  end;
end;

function TEnvirnoment.DeleteFromMap(nX, nY: Integer; btType: Byte;
  pRemoveObject: TObject): Integer; //004B6710
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  n18: Integer;
  btRaceServer: Byte;
resourcestring
  sExceptionMsg1 = '[Exception] TEnvirnoment::DeleteFromMap -> Except 1 ** %d';
  sExceptionMsg2 = '[Exception] TEnvirnoment::DeleteFromMap -> Except 2 ** %d';
begin
  Result := -1;
  try
    if GetMapCellInfo(nX, nY, MapCellInfo) then
    begin
      if MapCellInfo <> nil then
      begin
        try
          if MapCellInfo.ObjList <> nil then
          begin
            n18 := 0;
            while (True) do
            begin
              if MapCellInfo.ObjList.Count <= n18 then Break;
              OSObject := MapCellInfo.ObjList.Items[n18];
              if OSObject <> nil then
              begin
                if (OSObject.btType = btType) and (OSObject.CellObj = pRemoveObject) then
                begin
                  MapCellInfo.ObjList.Delete(n18);
                  Dispose(OSObject);
                  Result := 1;
                  //减地图人物怪物计数
                  if (btType = OS_MOVINGOBJECT) and (not TBaseObject(pRemoveObject).m_boDelFormMaped) then
                  begin
                    TBaseObject(pRemoveObject).m_boDelFormMaped := True;
                    TBaseObject(pRemoveObject).m_boAddToMaped := False;
                    DelObjectCount(pRemoveObject);
                  end;

                  if MapCellInfo.ObjList.Count > 0 then Continue;
                  MapCellInfo.ObjList.Free;
                  MapCellInfo.ObjList := nil;
                  Break;
                  {//Jacky 处理防止内存泄露 有待换上
                  if MapCellInfo.ObjList.Count <= 0 then begin
                    MapCellInfo.ObjList.Free;
                    MapCellInfo.ObjList:=nil;
                  end;
                  break;
                  }
                end
              end else
              begin
                MapCellInfo.ObjList.Delete(n18);
                if MapCellInfo.ObjList.Count > 0 then Continue;
                MapCellInfo.ObjList.Free;
                MapCellInfo.ObjList := nil;
                Break;
              end;
              Inc(n18);
            end;
          end else
          begin
            Result := -2;
          end;
        except
          OSObject := nil;
          MainOutMessage(Format(sExceptionMsg1, [btType]));
        end;
      end else Result := -3;
    end else Result := 0;
  except
    MainOutMessage(Format(sExceptionMsg2, [btType]));
  end;
end;

function TEnvirnoment.GetItem(nX, nY: Integer): pTMapItem; //004B5B0C
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := nil;
  bo2C := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then
  begin
    bo2C := True;
    if MapCellInfo.ObjList <> nil then
    begin
      for i := 0 to MapCellInfo.ObjList.Count - 1 do
      begin
        OSObject := MapCellInfo.ObjList.Items[i];
        if OSObject.btType = OS_ITEMOBJECT then
        begin
          Result := pTMapItem(OSObject.CellObj);
          Exit;
        end;
        if OSObject.btType = OS_GATEOBJECT then
          bo2C := False;
        if OSObject.btType = OS_MOVINGOBJECT then
        begin
          BaseObject := TBaseObject(OSObject.CellObj);
          if not BaseObject.m_boDeath then
            bo2C := False;
        end;
      end;
    end;
  end;
end;

function TMapManager.GetMapOfServerIndex(sMapName: string): Integer; //004B7510
var
  i: Integer;
  Envir: TEnvirnoment;
begin
  Result := 0;
  Lock;
  try
    for i := 0 to Count - 1 do
    begin
      Envir := Items[i];
      if (CompareText(Envir.sMapName, sMapName) = 0) then
      begin
        Result := Envir.nServerIndex;
        Break;
      end;
    end;
  finally
    UnLock;
  end;
end;

procedure TMapManager.LoadMapDoor; //004B6FFC
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    TEnvirnoment(Items[i]).AddDoorToMap;
  end;
end;
procedure TMapManager.ProcessMapDoor;
begin

end;

procedure TMapManager.ReSetMinMap;
var
  i, ii: Integer;
  Envirnoment: TEnvirnoment;
begin
  for i := 0 to Count - 1 do
  begin
    Envirnoment := TEnvirnoment(Items[i]);
    for ii := 0 to MiniMapList.Count - 1 do
    begin
      if CompareText(MiniMapList.Strings[ii], Envirnoment.sMapName) = 0 then
      begin
        Envirnoment.nMinMap := Integer(MiniMapList.Objects[ii]);
        Break;
      end;
    end;
  end;
end;

function TEnvirnoment.IsCheapStuff: Boolean; //004B6E24
begin
  if m_QuestList.Count > 0 then Result := True
  else Result := False;
end;

function TEnvirnoment.AddToMapMineEvent(nX, nY: Integer; nType: Integer; Event: TObject): TObject; //004B6600
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  bo19, bo1A: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TEnvirnoment::AddToMapMineEvent ';
begin
  Result := nil;
  try
    bo19 := GetMapCellInfo(nX, nY, MapCellInfo);
    bo1A := False;
    if bo19 and (MapCellInfo.chFlag <> 0) then
    begin
      if MapCellInfo.ObjList = nil then MapCellInfo.ObjList := TList.Create;
      if not bo1A then
      begin
        New(OSObject);
        OSObject.btType := nType;
        OSObject.CellObj := Event;
        OSObject.dwAddTime := GetTickCount();
        MapCellInfo.ObjList.Add(OSObject);
        Result := Event;
      end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

procedure TEnvirnoment.VerifyMapTime(nX, nY: Integer; BaseObject: TObject); //004B6980
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  boVerify: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TEnvirnoment::VerifyMapTime';
begin
  try
    boVerify := False;
    if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo <> nil) and (MapCellInfo.ObjList <> nil) then
    begin
      for i := 0 to MapCellInfo.ObjList.Count - 1 do
      begin
        OSObject := MapCellInfo.ObjList.Items[i];
        if (OSObject.btType = OS_MOVINGOBJECT) and (OSObject.CellObj = BaseObject) then
        begin
          OSObject.dwAddTime := GetTickCount();
          boVerify := True;
          Break;
        end;
      end;
    end;
    if not boVerify then
      AddToMap(nX, nY, OS_MOVINGOBJECT, BaseObject);
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

constructor TEnvirnoment.Create; //004B5318
begin
  Pointer(MapCellArray) := nil;
  sMapName := '';
  nServerIndex := 0;
  nMinMap := 0;
  FillChar(Flag, SizeOf(TMapFlag), #0);
  {m_nWidth     := 0;
  m_nHeight    := 0;
  m_boDARK     := False;
  m_boDAY      := False;}
  m_nMonCount := 0;
  m_nHumCount := 0;
  m_DoorList := TList.Create;
  m_QuestList := TList.Create;

  m_dwWhisperTick := 0;
end;

destructor TEnvirnoment.Destroy;
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  nX, nY: Integer;
  DoorInfo: pTDoorInfo;
begin
  for nX := 0 to Header.wWidth - 1 do
  begin
    for nY := 0 to Header.wHeight - 1 do
    begin
      if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then
      begin
        for i := 0 to MapCellInfo.ObjList.Count - 1 do
        begin
          OSObject := MapCellInfo.ObjList.Items[i];
          case OSObject.btType of
            OS_ITEMOBJECT: Dispose(pTMapItem(OSObject.CellObj));
            OS_GATEOBJECT: Dispose(pTGateObj(OSObject.CellObj));
            OS_EVENTOBJECT: TEvent(OSObject.CellObj).Free;
          end;
          Dispose(OSObject);
        end;
        MapCellInfo.ObjList.Free;
        MapCellInfo.ObjList := nil;
      end;
    end;
  end;

  for i := 0 to m_DoorList.Count - 1 do
  begin
    DoorInfo := m_DoorList.Items[i];
    Dec(DoorInfo.Status.nRefCount);
    if DoorInfo.Status.nRefCount <= 0 then
      Dispose(DoorInfo.Status);

    Dispose(DoorInfo);
  end;
  m_DoorList.Free;
  for i := 0 to m_QuestList.Count - 1 do
  begin
    Dispose(pTMapQuestInfo(m_QuestList.Items[i]));
  end;
  m_QuestList.Free;
  FreeMem(MapCellArray);
  Pointer(MapCellArray) := nil;
  inherited;
end;



function TEnvirnoment.LoadMapData(sMapFile: string): Boolean; //004B54E0
var
  fHandle: Integer;
  nMapSize: Integer;
  n24, nW, nH: Integer;
  MapBuffer: pTMap;
  Point: Integer;
  Door: pTDoorInfo;
  i, j: Integer;
  MapCellInfo: pTMapCellinfo;
begin
  Result := False;
  if FileExists(sMapFile) then
  begin
    fHandle := FileOpen(sMapFile, fmOpenRead or fmShareExclusive);
    if fHandle > 0 then
    begin
      FileRead(fHandle, Header, SizeOf(TMapHeader));

      Initialize(Header.wWidth, Header.wHeight);
      nMapSize := Header.wWidth * SizeOf(TMapUnitInfo) * Header.wHeight;

      MapBuffer := AllocMem(nMapSize);
      FileRead(fHandle, MapBuffer^, nMapSize);
      j := 0;
      for nW := 0 to Header.wWidth - 1 do
      begin
        n24 := nW * Header.wHeight;
        for nH := 0 to Header.wHeight - 1 do
        begin
          if (MapBuffer[n24 + nH].wBkImg) and $8000 <> 0 then
          begin
            MapCellInfo := @MapCellArray[n24 + nH];
            MapCellInfo.chFlag := 1;
          end; //004B5601
          if MapBuffer[n24 + nH].wFrImg and $8000 <> 0 then
          begin
            MapCellInfo := @MapCellArray[n24 + nH];
            MapCellInfo.chFlag := 2;
          end; //004B562C

          if MapBuffer[n24 + nH].btDoorIndex and $80 <> 0 then
          begin
            Point := (MapBuffer[n24 + nH].btDoorIndex and $7F);
            if Point > 0 then
            begin
              New(Door);
              Door.nX := nW;
              Door.nY := nH;
              Door.n08 := Point;
              Door.Status := nil;
              for i := 0 to m_DoorList.Count - 1 do
              begin
                if abs(pTDoorInfo(m_DoorList.Items[i]).nX - Door.nX) <= 10 then
                begin
                  if abs(pTDoorInfo(m_DoorList.Items[i]).nY - Door.nY) <= 10 then
                  begin
                    if pTDoorInfo(m_DoorList.Items[i]).n08 = Point then
                    begin
                      Door.Status := pTDoorInfo(m_DoorList.Items[i]).Status;
                      Inc(Door.Status.nRefCount);
                      Break;
                    end;
                  end;
                end;
              end; //004B5730
              if Door.Status = nil then
              begin
                New(Door.Status);
                Door.Status.boOpened := False;
                Door.Status.bo01 := False;
                Door.Status.n04 := 0;
                Door.Status.dwOpenTick := 0;
                Door.Status.nRefCount := 1;
              end;
              m_DoorList.Add(Door);
            end; //004B5780
          end;
        end; //004B578C
      end; //004B5798
      //Dispose(MapBuffer);

      FreeMem(MapBuffer);

      FileClose(fHandle);
      Result := True;
    end; //004B57B1
  end; //004B57B1
end;

procedure TEnvirnoment.Initialize(nWidth, nHeight: Integer); //004B53FC
var
  nW, nH: Integer;
  MapCellInfo: pTMapCellinfo;
begin
  if (nWidth > 1) and (nHeight > 1) then
  begin
    if MapCellArray <> nil then
    begin
      for nW := 0 to Header.wWidth - 1 do
      begin
        for nH := 0 to Header.wHeight - 1 do
        begin
          MapCellInfo := @MapCellArray[nW * Header.wHeight + nH];
          if MapCellInfo.ObjList <> nil then
          begin
            MapCellInfo.ObjList.Free;
            MapCellInfo.ObjList := nil;
          end;
        end;
      end;
      FreeMem(MapCellArray);
      Pointer(MapCellArray) := nil;
    end; //004B54AF
    Pointer(MapCellArray) := AllocMem((Header.wWidth * Header.wHeight) * SizeOf(TMapCellinfo));
  end; //004B54DB
end;

//nFlag,boFlag,Monster,Item,Quest,boGrouped
function TEnvirnoment.CreateQuest(nFlag, nValue: Integer; sMonName, sItem, sQuest: string;
  boGrouped: Boolean): Boolean; //004B6C3C
var
  MapQuest: pTMapQuestInfo;
  MapMerchant: TMerchant;
begin
  Result := False;
  if nFlag < 0 then Exit;
  New(MapQuest);
  MapQuest.nFlag := nFlag;
  if nValue > 1 then nValue := 1;
  MapQuest.nValue := nValue;
  if sMonName = '*' then sMonName := '';
  MapQuest.sMonName := sMonName;
  if sItem = '*' then sItem := '';
  MapQuest.sItemName := sItem;
  if sQuest = '*' then sQuest := '';
  MapQuest.boGrouped := boGrouped;


  MapMerchant := TMerchant.Create;
  MapMerchant.m_sMapName := '0';
  MapMerchant.m_nCurrX := 0;
  MapMerchant.m_nCurrY := 0;
  MapMerchant.m_sCharName := sQuest;
  MapMerchant.m_nFlag := 0;
  MapMerchant.m_wAppr := 0;
  MapMerchant.m_sFilePath := 'MapQuest_def\';
  MapMerchant.m_boIsHide := True;
  MapMerchant.m_boIsQuest := False;

  UserEngine.QuestNPCList.Add(MapMerchant);
  MapQuest.NPC := MapMerchant;
  m_QuestList.Add(MapQuest);
  Result := True;
end;

function TEnvirnoment.GetXYObjCount(nX, nY: Integer): Integer; //004B5DB0
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := 0;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then
  begin
    for i := 0 to MapCellInfo.ObjList.Count - 1 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if OSObject.btType = OS_MOVINGOBJECT then
      begin
        BaseObject := TBaseObject(OSObject.CellObj);
        if BaseObject <> nil then
        begin
          if not BaseObject.m_boGhost and
            BaseObject.bo2B9 and
            not BaseObject.m_boDeath and
            not BaseObject.m_boFixedHideMode and
            not BaseObject.m_boObMode then
          begin
            Inc(Result);
          end;
        end;
      end;
    end;
  end;
end;
//004B2A6C
function TEnvirnoment.GetNextPosition(sX, sY, nDir, nFlag: Integer; var snx: Integer; var sny: Integer): Boolean;
begin
  snx := sX;
  sny := sY;
  case nDir of
    DR_UP: if sny > nFlag - 1 then Dec(sny, nFlag);
    DR_DOWN: if sny < (Header.wWidth - nFlag) then Inc(sny, nFlag);
    DR_LEFT: if snx > nFlag - 1 then Dec(snx, nFlag);
    DR_RIGHT: if snx < (Header.wWidth - nFlag) then Inc(snx, nFlag);
    DR_UPLEFT:
      begin
        if (snx > nFlag - 1) and (sny > nFlag - 1) then
        begin
          Dec(snx, nFlag);
          Dec(sny, nFlag);
        end;
      end;
    DR_UPRIGHT:
      begin //004B2B77
        if (snx > nFlag - 1) and (sny < (Header.wHeight - nFlag)) then
        begin
          Inc(snx, nFlag);
          Dec(sny, nFlag);
        end;
      end;
    DR_DOWNLEFT:
      begin //004B2BAC
        if (snx < (Header.wWidth - nFlag)) and (sny > nFlag - 1) then
        begin
          Dec(snx, nFlag);
          Inc(sny, nFlag);
        end;
      end;
    DR_DOWNRIGHT:
      begin
        if (snx < (Header.wWidth - nFlag)) and (sny < (Header.wHeight - nFlag)) then
        begin
          Inc(snx, nFlag);
          Inc(sny, nFlag);
        end;
      end;
  end;
  if (snx = sX) and (sny = sY) then Result := False
  else Result := True;

end;

function TEnvirnoment.CanSafeWalk(nX, nY: Integer): Boolean; //004B609C
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
begin
  Result := True;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then
  begin
    for i := MapCellInfo.ObjList.Count - 1 downto 0 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if OSObject.btType = OS_EVENTOBJECT then
      begin
        if TEvent(OSObject.CellObj).m_nDamage > 0 then Result := False;
      end;
    end;
  end;
end;

function TEnvirnoment.ArroundDoorOpened(nX, nY: Integer): Boolean; //004B6B48
var
  i: Integer;
  Door: pTDoorInfo;
resourcestring
  sExceptionMsg = '[Exception] TEnvirnoment::ArroundDoorOpened ';
begin
  Result := True;
  try
    for i := 0 to m_DoorList.Count - 1 do
    begin
      Door := m_DoorList.Items[i];
      if (abs(Door.nX - nX) <= 1) and ((abs(Door.nY - nY) <= 1)) then
      begin
        if not Door.Status.boOpened then
        begin
          Result := False;
          Break;
        end;
      end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

function TEnvirnoment.GetMovingObject(nX, nY: Integer; boFlag: Boolean): Pointer; //004B5838
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := nil;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then
  begin
    for i := 0 to MapCellInfo.ObjList.Count - 1 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if OSObject.btType = OS_MOVINGOBJECT then
      begin
        BaseObject := TBaseObject(OSObject.CellObj);
        if ((BaseObject <> nil) and
          (not BaseObject.m_boGhost) and
          (BaseObject.bo2B9)) and
          ((not boFlag) or (not BaseObject.m_boDeath)) then
        begin

          Result := BaseObject;
          Break;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetQuestNPC(BaseObject: TObject; sCharName, sItem: string; boFlag: Boolean): TObject; //004B6E4C
var
  i: Integer;
  MapQuestFlag: pTMapQuestInfo;
  nFlagValue: Integer;
  bo1D: Boolean;
begin
  Result := nil;
  for i := 0 to m_QuestList.Count - 1 do
  begin
    MapQuestFlag := m_QuestList.Items[i];
    nFlagValue := TBaseObject(BaseObject).GetQuestFalgStatus(MapQuestFlag.nFlag);

    if nFlagValue = MapQuestFlag.nValue then
    begin
      if (boFlag = MapQuestFlag.boGrouped) or (not boFlag) then
      begin
        bo1D := False;
        if (MapQuestFlag.sMonName <> '') and (MapQuestFlag.sItemName <> '') then
        begin
          if (MapQuestFlag.sMonName = sCharName) and (MapQuestFlag.sItemName = sItem) then
            bo1D := True;
        end;
        if (MapQuestFlag.sMonName <> '') and (MapQuestFlag.sItemName = '') then
        begin
          if (MapQuestFlag.sMonName = sCharName) and (sItem = '') then
            bo1D := True;
        end;
        if (MapQuestFlag.sMonName = '') and (MapQuestFlag.sItemName <> '') then
        begin
          if (MapQuestFlag.sItemName = sItem) then
            bo1D := True;
        end;
        if bo1D then
        begin
          Result := MapQuestFlag.NPC;
          Break;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetItemEx(nX, nY: Integer;
  var nCount: Integer): Pointer; //004B5C10
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := nil;
  nCount := 0;
  bo2C := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then
  begin
    bo2C := True;
    if MapCellInfo.ObjList <> nil then
    begin
      for i := 0 to MapCellInfo.ObjList.Count - 1 do
      begin
        OSObject := MapCellInfo.ObjList.Items[i];
        if OSObject.btType = OS_ITEMOBJECT then
        begin
          Result := Pointer(OSObject.CellObj);
          Inc(nCount);
        end;
        if OSObject.btType = OS_GATEOBJECT then
        begin
          bo2C := False;
        end;
        if OSObject.btType = OS_MOVINGOBJECT then
        begin
          BaseObject := TBaseObject(OSObject.CellObj);
          if not BaseObject.m_boDeath then
            bo2C := False;
        end;
      end;
    end;
  end;

end;

function TEnvirnoment.GetDoor(nX, nY: Integer): pTDoorInfo; //004B6ACC
var
  i: Integer;
  Door: pTDoorInfo;
begin
  Result := nil;
  for i := 0 to m_DoorList.Count - 1 do
  begin
    Door := m_DoorList.Items[i];
    if (Door.nX = nX) and (Door.nY = nY) then
    begin
      Result := Door;
      Exit;
    end;
  end;
end;

function TEnvirnoment.IsValidObject(nX, nY, nRage: Integer; BaseObject: TObject): Boolean; //004B5A3C
var
  nXX, nYY, i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
begin
  Result := False;
  for nXX := nX - nRage to nX + nRage do
  begin
    for nYY := nY - nRage to nY + nRage do
    begin
      if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then
      begin
        for i := 0 to MapCellInfo.ObjList.Count - 1 do
        begin
          OSObject := MapCellInfo.ObjList.Items[i];
          if OSObject.CellObj = BaseObject then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetRangeBaseObject(nX, nY, nRage: Integer; boFlag: Boolean;
  BaseObjectList: TList): Integer; //004B59C0
var
  nXX, nYY: Integer;
begin
  for nXX := nX - nRage to nX + nRage do
  begin
    for nYY := nY - nRage to nY + nRage do
    begin
      GeTBaseObjects(nXX, nYY, boFlag, BaseObjectList);
    end;
  end;
  Result := BaseObjectList.Count;
end;
//boFlag 是否包括死亡对象
//FALSE 包括死亡对象
//TRUE  不包括死亡对象
function TEnvirnoment.GeTBaseObjects(nX, nY: Integer; boFlag: Boolean;
  BaseObjectList: TList): Integer; //004B58F8
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then
  begin
    for i := 0 to MapCellInfo.ObjList.Count - 1 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if OSObject.btType = OS_MOVINGOBJECT then
      begin
        BaseObject := TBaseObject(OSObject.CellObj);
        if BaseObject <> nil then
        begin
          if not BaseObject.m_boGhost and BaseObject.bo2B9 then
          begin
            if not boFlag or not BaseObject.m_boDeath then
              BaseObjectList.Add(BaseObject);
          end;
        end;
      end;
    end;
  end;
  Result := BaseObjectList.Count;
end;

function TEnvirnoment.GetEvent(nX, nY: Integer): TObject; //004B5D24
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
begin
  Result := nil;
  bo2C := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then
  begin
    for i := 0 to MapCellInfo.ObjList.Count - 1 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if OSObject.btType = OS_EVENTOBJECT then
      begin
        Result := OSObject.CellObj;
      end;
    end;
  end;
end;

procedure TEnvirnoment.SetMapXYFlag(nX, nY: Integer; boFlag: Boolean); //004B5E8C
var
  MapCellInfo: pTMapCellinfo;
begin
  if GetMapCellInfo(nX, nY, MapCellInfo) then
  begin
    if boFlag then MapCellInfo.chFlag := 0
    else MapCellInfo.chFlag := 2;
  end;
end;

function TEnvirnoment.CanFly(nSX, nSY, nDX, nDY: Integer): Boolean; //004B600C
var
  r28, r30: Real;
  n14, n18, n1C: Integer;
begin
  Result := True;
  r28 := (nDX - nSX) / 1.0E1;
  r30 := (nDY - nDX) / 1.0E1;
  n14 := 0;
  while (True) do
  begin
    n18 := Round(nSX + r28);
    n1C := Round(nSY + r30);
    if not CanWalk(n18, n1C, True) then
    begin
      Result := False;
      Break;
    end;
    Inc(n14);
    if n14 >= 10 then Break;
  end;
end;



function TEnvirnoment.GetXYHuman(nMapX, nMapY: Integer): Boolean;
var
  i: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := False;
  if GetMapCellInfo(nMapX, nMapY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then
  begin
    for i := 0 to MapCellInfo.ObjList.Count - 1 do
    begin
      OSObject := MapCellInfo.ObjList.Items[i];
      if OSObject.btType = OS_MOVINGOBJECT then
      begin
        BaseObject := TBaseObject(OSObject.CellObj);
        if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.IsValidCell(nX, nY: Integer): Boolean; //0x004B5FC8
var
  MapCellInfo: pTMapCellinfo;
begin
  Result := True;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 2) then
    Result := False;
end;

function TEnvirnoment.GetEnvirInfo: string;
var
  sMsg: string;
begin
  sMsg := 'Map:%s(%s) DAY:%s DARK:%s SAFE:%s FIGHT:%s FIGHT3:%s QUIZ:%s NORECONNECT:%s(%s) MUSIC:%s(%d) EXPRATE:%s(%f) PKWINLEVEL:%s(%d) PKLOSTLEVEL:%s(%d) PKWINEXP:%s(%d) PKLOSTEXP:%s(%d) DECHP:%s(%d/%d) INCHP:%s(%d/%d)';

//取消 结婚 与 师徒 的相关内容  
  //  sMsg := sMsg + ' DECGAMEGOLD:%s(%d/%d) INCGAMEGOLD:%s(%d/%d) INCGAMEPOINT:%s(%d/%d) RUNHUMAN:%s RUNMON:%s NEEDHOLE:%s NORECALL:%s NOGUILDRECALL:%s NODEARRECALL:%s NOMASTERRECALL:%s NODRUG:%s MINE:%s MINE2:%s NODROPITEM:%s';

    sMsg := sMsg + ' DECGAMEGOLD:%s(%d/%d) INCGAMEGOLD:%s(%d/%d) INCGAMEPOINT:%s(%d/%d) RUNHUMAN:%s RUNMON:%s NEEDHOLE:%s NORECALL:%s NOGUILDRECALL:%s NODRUG:%s MINE:%s MINE2:%s NODROPITEM:%s';

  sMsg := sMsg + ' NOTHROWITEM:%s NOPOSITIONMOVE:%s NOHORSE:%s NOCHAT:%s';
  Result := Format(sMsg, [sMapName,
    sMapDesc,
      BoolToStr(Flag.boDAYLIGHT),
      BoolToStr(Flag.boDARKness),
      BoolToStr(Flag.boSAFE),
      BoolToStr(Flag.boFIGHTZone),
      BoolToStr(Flag.boFIGHT3Zone),
      BoolToStr(Flag.boQUIZ),
      BoolToStr(Flag.boNORECONNECT), Flag.sNOReConnectMap,
      BoolToStr(Flag.boMUSIC), Flag.nMUSICID,
      BoolToStr(Flag.boEXPRATE), Flag.nEXPRATE / 100,
      BoolToStr(Flag.boPKWINLEVEL), Flag.nPKWINLEVEL,
      BoolToStr(Flag.boPKLOSTLEVEL), Flag.nPKLOSTLEVEL,
      BoolToStr(Flag.boPKWINEXP), Flag.nPKWINEXP,
      BoolToStr(Flag.boPKLOSTEXP), Flag.nPKLOSTEXP,
      BoolToStr(Flag.boDECHP), Flag.nDECHPTIME, Flag.nDECHPPOINT,
      BoolToStr(Flag.boINCHP), Flag.nINCHPTIME, Flag.nINCHPPOINT,
      BoolToStr(Flag.boDECGAMEGOLD), Flag.nDECGAMEGOLDTIME, Flag.nDECGAMEGOLD,
      BoolToStr(Flag.boINCGAMEGOLD), Flag.nINCGAMEGOLDTIME, Flag.nINCGAMEGOLD,
      BoolToStr(Flag.boINCGAMEPOINT), Flag.nINCGAMEPOINTTIME, Flag.nINCGAMEPOINT,
      BoolToStr(Flag.boRUNHUMAN),
      BoolToStr(Flag.boRUNMON),
      BoolToStr(Flag.boNEEDHOLE),
      BoolToStr(Flag.boNORECALL),
      BoolToStr(Flag.boNOGUILDRECALL),
      
//取消 结婚 与 师徒 的相关内容
//     BoolToStr(Flag.boNODEARRECALL),
//     BoolToStr(Flag.boNOMASTERRECALL),

      BoolToStr(Flag.boNODRUG),
      BoolToStr(Flag.boMINE),
      BoolToStr(Flag.boMINE2),
      BoolToStr(Flag.boNODROPITEM),
      BoolToStr(Flag.boNOTHROWITEM),
      BoolToStr(Flag.boNOPOSITIONMOVE),
      BoolToStr(Flag.boNOHORSE),
      BoolToStr(Flag.boNOCHAT)
      ]);
end;

procedure TEnvirnoment.AddObject(BaseObject: TObject);
var
  btRaceServer: Byte;
begin
  btRaceServer := TBaseObject(BaseObject).m_btRaceServer;
  if btRaceServer = RC_PLAYOBJECT then Inc(m_nHumCount);
  if btRaceServer >= RC_ANIMAL then Inc(m_nMonCount);
end;

procedure TEnvirnoment.DelObjectCount(BaseObject: TObject);
var
  btRaceServer: Byte;
begin
  btRaceServer := TBaseObject(BaseObject).m_btRaceServer;
  if btRaceServer = RC_PLAYOBJECT then Inc(m_nHumCount);
  if btRaceServer >= RC_ANIMAL then Inc(m_nMonCount);
end;

procedure TMapManager.Run;
begin

end;

end.
