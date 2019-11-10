unit ItmUnit;

interface
uses
  Windows, Classes, SysUtils, Grobal2, MudUtil, SDK;
type
  TItemUnit = class
  public
    m_ItemNameList: TGList;
    constructor Create();
    destructor Destroy; override;

    function LoadCustomItemName(): Boolean;
    function SaveCustomItemName(): Boolean;
    function AddCustomItemName(nMakeIndex, nItemIndex: Integer; sItemName: string): Boolean;
    function DelCustomItemName(nMakeIndex, nItemIndex: Integer): Boolean;
    function GetCustomItemName(nMakeIndex, nItemIndex: Integer): string;
    procedure Lock();
    procedure UnLock();
  end;

  TItem = class
  public
    ItemType: Byte;
      Name: string[20];
    StdMode: Byte;
    Shape: Byte;
    Weight: Byte;
    AniCount: Byte;
    Source: ShortInt;
    Reserved: Byte;
    NeedIdentify: Byte;
    Looks: Word;
    DuraMax: dword;
    AC, AC2: Word;
    MAC, MAC2: Word;
    DC, DC2: Word;
    MC, MC2: Word;
    SC, SC2: Word;
    Need: dword;
    NeedLevel: dword;
    Price: UINT;
    stock: UINT;

    //New Fields
    Undead: ShortInt;
    Light: Boolean;
    Unique: Boolean;

  private
    function GetRandomRange(nCount, nRate: Integer): Integer;

  public
    constructor Create();
    destructor Destroy; override;

    procedure GetStandardItem(var StdItem: TStdItem);
    procedure GetItemAddValue(UserItem: pTUserItem; var StdItem: TStdItem);
    //function  GetCustomName(UserItem:pTUserItem):String;
    procedure ApplyItemParameters(var AddAbility: TAddAbility);
    procedure RandomUpgradeItem(UserItem: pTUserItem);
    procedure RandomUpgradeUnknownItem(UserItem: pTUserItem);
  end;

function GetItemName(UserItem: pTUserItem): string;

implementation

uses HUtil32, M2Share;





{ TItem }


constructor TItem.Create;
begin
  inherited;
end;

destructor TItem.Destroy;
begin
  inherited;
end;

function TItem.GetRandomRange(nCount, nRate: Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to nCount - 1 do
    if Random(nRate) = 0 then Inc(Result);
end;



procedure TItem.GetStandardItem(var StdItem: TStdItem);
begin
  StdItem.Name := FilterShowName(Name);

  StdItem.StdMode := StdMode;
  StdItem.Shape := Shape;
  StdItem.Weight := Weight;
  StdItem.AniCount := AniCount;
  StdItem.Reserved := Reserved;
  StdItem.Source := Source;
  StdItem.NeedIdentify := NeedIdentify;
  StdItem.Looks := Looks;
  StdItem.DuraMax := DuraMax;
  StdItem.Need := Need;
  StdItem.NeedLevel := NeedLevel;
  StdItem.Price := Price;
end;

procedure TItem.GetItemAddValue(UserItem: pTUserItem; var StdItem: TStdItem);
begin
  case ItemType of
    ITEM_WEAPON:
      begin
        StdItem.DC := MakeLong(DC, DC2 + UserItem.btValue[0]);
        StdItem.MC := MakeLong(MC, MC2 + UserItem.btValue[1]);
        StdItem.SC := MakeLong(SC, SC2 + UserItem.btValue[2]);
        StdItem.AC := MakeLong(AC + UserItem.btValue[3], AC2 + UserItem.btValue[5]);
        StdItem.MAC := MakeLong(MAC + UserItem.btValue[4], MAC2 + UserItem.btValue[6]);
        if Byte(UserItem.btValue[7] - 1) < 10 then
        begin //Holy
          StdItem.Source := UserItem.btValue[7];
        end;
        if UserItem.btValue[10] <> 0 then
          StdItem.Reserved := StdItem.Reserved or 1;
      end;
    ITEM_ARMOR:
      begin
        StdItem.AC := MakeLong(AC, AC2 + UserItem.btValue[0]);
        StdItem.MAC := MakeLong(MAC, MAC2 + UserItem.btValue[1]);
        StdItem.DC := MakeLong(DC, DC2 + UserItem.btValue[2]);
        StdItem.MC := MakeLong(MC, MC2 + UserItem.btValue[3]);
        StdItem.SC := MakeLong(SC, SC2 + UserItem.btValue[4]);
      end;
    ITEM_ACCESSORY:
      begin
        StdItem.AC := MakeLong(AC, AC2 + UserItem.btValue[0]);
        StdItem.MAC := MakeLong(MAC, MAC2 + UserItem.btValue[1]);
        StdItem.DC := MakeLong(DC, DC2 + UserItem.btValue[2]);
        StdItem.MC := MakeLong(MC, MC2 + UserItem.btValue[3]);
        StdItem.SC := MakeLong(SC, SC2 + UserItem.btValue[4]);
        if UserItem.btValue[5] > 0 then
        begin
          StdItem.Need := UserItem.btValue[5];
        end;
        if UserItem.btValue[6] > 0 then
        begin
          StdItem.NeedLevel := UserItem.btValue[6];
        end;
      end;
  else
    begin
      StdItem.AC := 0;
      StdItem.MAC := 0;
      StdItem.DC := 0;
      StdItem.MC := 0;
      StdItem.SC := 0;
      StdItem.Source := 0;
      StdItem.Reserved := 0;
    end;
  end;
end;

{function TItem.GetCustomName(UserItem:pTUserItem):String;
begin
  if (UserItem<>nil) then begin
    if (UserItem.sCustomName<>'') then Result:=UserItem.sCustomName;
  end else
    Result := Name;
end;}

procedure TItem.RandomUpgradeItem(UserItem: pTUserItem);
var
  nUpgrade, nIncp, nVal: Integer;
begin
  case ItemType of
    ITEM_WEAPON:
      begin
        nUpgrade := GetRandomRange(g_Config.nWeaponDCAddValueMaxLimit {12}, g_Config.nWeaponDCAddValueRate {15});
        if Random(15) = 0 then UserItem.btValue[0] := nUpgrade + 1;

        nUpgrade := GetRandomRange(12, 15);
        if Random(20) = 0 then
        begin
          nIncp := (nUpgrade + 1) div 3;
          if nIncp > 0 then
          begin
            if Random(3) <> 0 then
            begin
              UserItem.btValue[6] := nIncp;
            end else
            begin
              UserItem.btValue[6] := nIncp + 10;
            end;
          end;
        end;

        nUpgrade := GetRandomRange(12, 15);
        if Random(15) = 0 then UserItem.btValue[1] := nUpgrade + 1;
        nUpgrade := GetRandomRange(12, 15);
        if Random(15) = 0 then UserItem.btValue[2] := nUpgrade + 1;
        nUpgrade := GetRandomRange(12, 15);
        if Random(24) = 0 then
        begin
          UserItem.btValue[5] := nUpgrade div 2 + 1;
        end;
        nUpgrade := GetRandomRange(12, 12);
        if Random(3) < 2 then
        begin
          nVal := (nUpgrade + 1) * 2000;
          UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nVal);
          UserItem.Dura := _MIN(65000, UserItem.Dura + nVal);
        end;
        nUpgrade := GetRandomRange(12, 15);
        if Random(10) = 0 then
        begin
          UserItem.btValue[7] := nUpgrade div 2 + 1;
        end;
      end;
    ITEM_ARMOR:
      begin
        nUpgrade := GetRandomRange(6, 15);
        if Random(30) = 0 then UserItem.btValue[0] := nUpgrade + 1;
        nUpgrade := GetRandomRange(6, 15);
        if Random(30) = 0 then UserItem.btValue[1] := nUpgrade + 1;

        nUpgrade := GetRandomRange(g_Config.nDressDCAddValueMaxLimit {6}, g_Config.nDressDCAddValueRate {20});
        if Random(g_Config.nDressDCAddRate {40}) = 0 then UserItem.btValue[2] := nUpgrade + 1;
        nUpgrade := GetRandomRange(g_Config.nDressMCAddValueMaxLimit {6}, g_Config.nDressMCAddValueRate {20});
        if Random(g_Config.nDressMCAddRate {40}) = 0 then UserItem.btValue[3] := nUpgrade + 1;
        nUpgrade := GetRandomRange(g_Config.nDressSCAddValueMaxLimit {6}, g_Config.nDressSCAddValueRate {20});
        if Random(g_Config.nDressSCAddRate {40}) = 0 then UserItem.btValue[4] := nUpgrade + 1;

        nUpgrade := GetRandomRange(6, 10);
        if Random(8) < 6 then
        begin
          nVal := (nUpgrade + 1) * 2000;
          UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nVal);
          UserItem.Dura := _MIN(65000, UserItem.Dura + nVal);
        end;
      end;
    ITEM_ACCESSORY:
      begin
        case StdMode of
          20, 21, 24:
            begin
              nUpgrade := GetRandomRange(6, 30);
              if Random(60) = 0 then UserItem.btValue[0] := nUpgrade + 1;
              nUpgrade := GetRandomRange(6, 30);
              if Random(60) = 0 then UserItem.btValue[1] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nNeckLace202124DCAddValueMaxLimit {6}, g_Config.nNeckLace202124DCAddValueRate {20});
              if Random(g_Config.nNeckLace202124DCAddRate {30}) = 0 then UserItem.btValue[2] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nNeckLace202124MCAddValueMaxLimit {6}, g_Config.nNeckLace202124MCAddValueRate {20});
              if Random(g_Config.nNeckLace202124MCAddRate {30}) = 0 then UserItem.btValue[3] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nNeckLace202124SCAddValueMaxLimit {6}, g_Config.nNeckLace202124SCAddValueRate {20});
              if Random(g_Config.nNeckLace202124SCAddRate {30}) = 0 then UserItem.btValue[4] := nUpgrade + 1;
              nUpgrade := GetRandomRange(6, 12);
              if Random(20) < 15 then
              begin
                nVal := (nUpgrade + 1) * 1000;
                UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nVal);
                UserItem.Dura := _MIN(65000, UserItem.Dura + nVal);
              end;
            end;
          26:
            begin
              nUpgrade := GetRandomRange(6, 20);
              if Random(20) = 0 then UserItem.btValue[0] := nUpgrade + 1;
              nUpgrade := GetRandomRange(6, 20);
              if Random(20) = 0 then UserItem.btValue[1] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nArmRing26DCAddValueMaxLimit {6}, g_Config.nArmRing26DCAddValueRate {20});
              if Random(g_Config.nArmRing26DCAddRate {30}) = 0 then UserItem.btValue[2] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nArmRing26MCAddValueMaxLimit {6}, g_Config.nArmRing26MCAddValueRate {20});
              if Random(g_Config.nArmRing26MCAddRate {30}) = 0 then UserItem.btValue[3] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nArmRing26SCAddValueMaxLimit {6}, g_Config.nArmRing26SCAddValueRate {20});
              if Random(g_Config.nArmRing26SCAddRate {30}) = 0 then UserItem.btValue[4] := nUpgrade + 1;
              nUpgrade := GetRandomRange(6, 12);
              if Random(20) < 15 then
              begin
                nVal := (nUpgrade + 1) * 1000;
                UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nVal);
                UserItem.Dura := _MIN(65000, UserItem.Dura + nVal);
              end;
            end;
          19:
            begin
              nUpgrade := GetRandomRange(6, 20);
              if Random(40) = 0 then UserItem.btValue[0] := nUpgrade + 1;
              nUpgrade := GetRandomRange(6, 20);
              if Random(40) = 0 then UserItem.btValue[1] := nUpgrade + 1;

              nUpgrade := GetRandomRange(g_Config.nNeckLace19DCAddValueMaxLimit {6}, g_Config.nNeckLace19DCAddValueRate {20});
              if Random(g_Config.nNeckLace19DCAddRate {30}) = 0 then UserItem.btValue[2] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nNeckLace19MCAddValueMaxLimit {6}, g_Config.nNeckLace19MCAddValueRate {20});
              if Random(g_Config.nNeckLace19MCAddRate {30}) = 0 then UserItem.btValue[3] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nNeckLace19SCAddValueMaxLimit {6}, g_Config.nNeckLace19SCAddValueRate {20});
              if Random(g_Config.nNeckLace19SCAddRate {30}) = 0 then UserItem.btValue[4] := nUpgrade + 1;
              nUpgrade := GetRandomRange(6, 10);
              if Random(4) < 3 then
              begin
                nVal := (nUpgrade + 1) * 1000;
                UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nVal);
                UserItem.Dura := _MIN(65000, UserItem.Dura + nVal);
              end;
            end;
          22:
            begin
              nUpgrade := GetRandomRange(g_Config.nRing22DCAddValueMaxLimit {6}, g_Config.nRing22DCAddValueRate {20});
              if Random(g_Config.nRing22DCAddRate {30}) = 0 then UserItem.btValue[2] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nRing22MCAddValueMaxLimit {6}, g_Config.nRing22MCAddValueRate {20});
              if Random(g_Config.nRing22MCAddRate {30}) = 0 then UserItem.btValue[3] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nRing22SCAddValueMaxLimit {6}, g_Config.nRing22SCAddValueRate {20});
              if Random(g_Config.nRing22SCAddRate {30}) = 0 then UserItem.btValue[4] := nUpgrade + 1;
              nUpgrade := GetRandomRange(6, 12);
              if Random(4) < 3 then
              begin
                nVal := (nUpgrade + 1) * 1000;
                UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nVal);
                UserItem.Dura := _MIN(65000, UserItem.Dura + nVal);
              end;
            end;
          23:
            begin
              nUpgrade := GetRandomRange(6, 20);
              if Random(40) = 0 then UserItem.btValue[0] := nUpgrade + 1;
              nUpgrade := GetRandomRange(6, 20);
              if Random(40) = 0 then UserItem.btValue[1] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nRing23DCAddValueMaxLimit {6}, g_Config.nRing23DCAddValueRate {20});
              if Random(g_Config.nRing23DCAddRate {30}) = 0 then UserItem.btValue[2] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nRing23MCAddValueMaxLimit {6}, g_Config.nRing23MCAddValueRate {20});
              if Random(g_Config.nRing23MCAddRate {30}) = 0 then UserItem.btValue[3] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nRing23SCAddValueMaxLimit {6}, g_Config.nRing23SCAddValueRate {20});
              if Random(g_Config.nRing23SCAddRate {30}) = 0 then UserItem.btValue[4] := nUpgrade + 1;
              nUpgrade := GetRandomRange(6, 12);
              if Random(4) < 3 then
              begin
                nVal := (nUpgrade + 1) * 1000;
                UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nVal);
                UserItem.Dura := _MIN(65000, UserItem.Dura + nVal);
              end;
            end;
          15:
            begin
              nUpgrade := GetRandomRange(6, 20);
              if Random(40) = 0 then UserItem.btValue[0] := nUpgrade + 1;
              nUpgrade := GetRandomRange(6, 20);
              if Random(30) = 0 then UserItem.btValue[1] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nHelMetDCAddValueMaxLimit {6}, g_Config.nHelMetDCAddValueRate {20});
              if Random(g_Config.nHelMetDCAddRate {30}) = 0 then UserItem.btValue[2] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nHelMetMCAddValueMaxLimit {6}, g_Config.nHelMetMCAddValueRate {20});
              if Random(g_Config.nHelMetMCAddRate {30}) = 0 then UserItem.btValue[3] := nUpgrade + 1;
              nUpgrade := GetRandomRange(g_Config.nHelMetSCAddValueMaxLimit {6}, g_Config.nHelMetSCAddValueRate {20});
              if Random(g_Config.nHelMetSCAddRate {30}) = 0 then UserItem.btValue[4] := nUpgrade + 1;
              nUpgrade := GetRandomRange(6, 12);
              if Random(4) < 3 then
              begin
                nVal := (nUpgrade + 1) * 1000;
                UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nVal);
                UserItem.Dura := _MIN(65000, UserItem.Dura + nVal);
              end;
            end;
        end;
      end;
  end;
end;

procedure TItem.RandomUpgradeUnknownItem(UserItem: pTUserItem);
var
  nUpgrade, nRandPoint, nVal: Integer;
begin
  case ItemType of
    ITEM_WEAPON:
      begin

      end;
    ITEM_ARMOR:
      begin

      end;
    ITEM_ACCESSORY:
      begin
        case StdMode of
          15:
            begin
              nRandPoint := {GetRandomRange(4,3) + GetRandomRange(4,8) + } GetRandomRange(g_Config.nUnknowHelMetACAddValueMaxLimit {4}, g_Config.nUnknowHelMetACAddRate {20});
              if nRandPoint > 0 then UserItem.btValue[0] := nRandPoint;
              nUpgrade := nRandPoint;
              nRandPoint := {GetRandomRange(4,3) + GetRandomRange(4,8) + } GetRandomRange(g_Config.nUnknowHelMetMACAddValueMaxLimit {4}, g_Config.nUnknowHelMetMACAddRate {20});
              if nRandPoint > 0 then UserItem.btValue[1] := nRandPoint;
              Inc(nUpgrade, nRandPoint);
              nRandPoint := {GetRandomRange(3,15) + } GetRandomRange(g_Config.nUnknowHelMetDCAddValueMaxLimit {3}, g_Config.nUnknowHelMetDCAddRate {30});
              if nRandPoint > 0 then UserItem.btValue[2] := nRandPoint;
              Inc(nUpgrade, nRandPoint);
              nRandPoint := {GetRandomRange(3,15) + } GetRandomRange(g_Config.nUnknowHelMetMCAddValueMaxLimit {3}, g_Config.nUnknowHelMetMCAddRate {30});
              if nRandPoint > 0 then UserItem.btValue[3] := nRandPoint;
              Inc(nUpgrade, nRandPoint);
              nRandPoint := {GetRandomRange(3,15) + } GetRandomRange(g_Config.nUnknowHelMetSCAddValueMaxLimit {3}, g_Config.nUnknowHelMetSCAddRate {30});
              if nRandPoint > 0 then UserItem.btValue[4] := nRandPoint;
              Inc(nUpgrade, nRandPoint);
              nRandPoint := GetRandomRange(6, 30);
              if nRandPoint > 0 then
              begin
                nVal := (nRandPoint + 1) * 1000;
                UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nVal);
                UserItem.Dura := _MIN(65000, UserItem.Dura + nVal);
              end;
              if Random(30) = 0 then UserItem.btValue[7] := 1;
              UserItem.btValue[8] := 1;
              if nUpgrade >= 3 then
              begin
                if UserItem.btValue[0] >= 5 then
                begin
                  UserItem.btValue[5] := 1;
                  UserItem.btValue[6] := UserItem.btValue[0] * 3 + 25;
                  Exit;
                end;
                if UserItem.btValue[2] >= 2 then
                begin
                  UserItem.btValue[5] := 1;
                  UserItem.btValue[6] := UserItem.btValue[2] * 4 + 35;
                  Exit;
                end;
                if UserItem.btValue[3] >= 2 then
                begin
                  UserItem.btValue[5] := 2;
                  UserItem.btValue[6] := UserItem.btValue[3] * 2 + 18;
                  Exit;
                end;
                if UserItem.btValue[4] >= 2 then
                begin
                  UserItem.btValue[5] := 3;
                  UserItem.btValue[6] := UserItem.btValue[4] * 2 + 18;
                  Exit;
                end;
                UserItem.btValue[6] := nUpgrade * 2 + 18;
              end;
            end;
          22, 23:
            begin
              nRandPoint := {GetRandomRange(4,3) + GetRandomRange(4,8) + } GetRandomRange(g_Config.nUnknowRingACAddValueMaxLimit {6}, g_Config.nUnknowRingACAddRate {20});
              if nRandPoint > 0 then UserItem.btValue[0] := nRandPoint;
              nUpgrade := nRandPoint;
              nRandPoint := {GetRandomRange(4,3) + GetRandomRange(4,8) + } GetRandomRange(g_Config.nUnknowRingMACAddValueMaxLimit {6}, g_Config.nUnknowRingMACAddRate {20});
              if nRandPoint > 0 then UserItem.btValue[1] := nRandPoint;
              Inc(nUpgrade, nRandPoint);
          // 以上二项为增加项，增加防，及魔防

              nRandPoint := {GetRandomRange(4,3) + GetRandomRange(4,8) + } GetRandomRange(g_Config.nUnknowRingDCAddValueMaxLimit {6}, g_Config.nUnknowRingDCAddRate {20});
              if nRandPoint > 0 then UserItem.btValue[2] := nRandPoint;
              Inc(nUpgrade, nRandPoint);
              nRandPoint := {GetRandomRange(4,3) + GetRandomRange(4,8) + } GetRandomRange(g_Config.nUnknowRingMCAddValueMaxLimit {6}, g_Config.nUnknowRingMCAddRate {20});
              if nRandPoint > 0 then UserItem.btValue[3] := nRandPoint;
              Inc(nUpgrade, nRandPoint);
              nRandPoint := {GetRandomRange(4,3) + GetRandomRange(4,8) + } GetRandomRange(g_Config.nUnknowRingSCAddValueMaxLimit {6}, g_Config.nUnknowRingSCAddRate {20});
              if nRandPoint > 0 then UserItem.btValue[4] := nRandPoint;
              Inc(nUpgrade, nRandPoint);
              nRandPoint := GetRandomRange(6, 30);
              if nRandPoint > 0 then
              begin
                nVal := (nRandPoint + 1) * 1000;
                UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nVal);
                UserItem.Dura := _MIN(65000, UserItem.Dura + nVal);
              end;
              if Random(30) = 0 then UserItem.btValue[7] := 1;
              UserItem.btValue[8] := 1;
              if nUpgrade >= 3 then
              begin
                if UserItem.btValue[2] >= 3 then
                begin
                  UserItem.btValue[5] := 1;
                  UserItem.btValue[6] := UserItem.btValue[2] * 3 + 25;
                  Exit;
                end;
                if UserItem.btValue[3] >= 3 then
                begin
                  UserItem.btValue[5] := 2;
                  UserItem.btValue[6] := UserItem.btValue[3] * 2 + 18;
                  Exit;
                end;
                if UserItem.btValue[4] >= 3 then
                begin
                  UserItem.btValue[5] := 3;
                  UserItem.btValue[6] := UserItem.btValue[4] * 2 + 18;
                  Exit;
                end;
                UserItem.btValue[6] := nUpgrade * 2 + 18;
              end;
            end;
          24, 26:
            begin
              nRandPoint := {GetRandomRange(3,5) + } GetRandomRange(g_Config.nUnknowNecklaceACAddValueMaxLimit {5}, g_Config.nUnknowNecklaceACAddRate {20});
              if nRandPoint > 0 then UserItem.btValue[0] := nRandPoint;
              nUpgrade := nRandPoint;
              nRandPoint := {GetRandomRange(3,5) + } GetRandomRange(g_Config.nUnknowNecklaceMACAddValueMaxLimit {5}, g_Config.nUnknowNecklaceMACAddRate {20});
              if nRandPoint > 0 then UserItem.btValue[1] := nRandPoint;
              Inc(nUpgrade, nRandPoint);
              nRandPoint := {GetRandomRange(3,15) + } GetRandomRange(g_Config.nUnknowNecklaceDCAddValueMaxLimit {5}, g_Config.nUnknowNecklaceDCAddRate {30});
              if nRandPoint > 0 then UserItem.btValue[2] := nRandPoint;
              Inc(nUpgrade, nRandPoint);
              nRandPoint := {GetRandomRange(3,15) + } GetRandomRange(g_Config.nUnknowNecklaceMCAddValueMaxLimit {5}, g_Config.nUnknowNecklaceMCAddRate {30});
              if nRandPoint > 0 then UserItem.btValue[3] := nRandPoint;
              Inc(nUpgrade, nRandPoint);
              nRandPoint := {GetRandomRange(3,15) + } GetRandomRange(g_Config.nUnknowNecklaceSCAddValueMaxLimit {5}, g_Config.nUnknowNecklaceSCAddRate {30});
              if nRandPoint > 0 then UserItem.btValue[4] := nRandPoint;
              Inc(nUpgrade, nRandPoint);
              nRandPoint := GetRandomRange(6, 30);
              if nRandPoint > 0 then
              begin
                nVal := (nRandPoint + 1) * 1000;
                UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nVal);
                UserItem.Dura := _MIN(65000, UserItem.Dura + nVal);
              end;
              if Random(30) = 0 then UserItem.btValue[7] := 1;
              UserItem.btValue[8] := 1;
              if nUpgrade >= 2 then
              begin
                if UserItem.btValue[0] >= 3 then
                begin
                  UserItem.btValue[5] := 1;
                  UserItem.btValue[6] := UserItem.btValue[0] * 3 + 25;
                  Exit;
                end;
                if UserItem.btValue[2] >= 2 then
                begin
                  UserItem.btValue[5] := 1;
                  UserItem.btValue[6] := UserItem.btValue[2] * 3 + 30;
                  Exit;
                end;
                if UserItem.btValue[3] >= 2 then
                begin
                  UserItem.btValue[5] := 2;
                  UserItem.btValue[6] := UserItem.btValue[3] * 2 + 20;
                  Exit;
                end;
                if UserItem.btValue[4] >= 2 then
                begin
                  UserItem.btValue[5] := 3;
                  UserItem.btValue[6] := UserItem.btValue[4] * 2 + 20;
                  Exit;
                end;
                UserItem.btValue[6] := nUpgrade * 2 + 18;
              end;
            end;
        end;
      end;
  end;
end;

procedure TItem.ApplyItemParameters(var AddAbility: TAddAbility);
begin
  case ItemType of
    ITEM_WEAPON:
      begin
        Inc(AddAbility.wHitPoint, AC2);
        if MAC2 > 10 then
        begin
          Inc(AddAbility.nHitSpeed, MAC2 - 10);
        end else
        begin
          Dec(AddAbility.nHitSpeed, MAC2);
        end;
        Inc(AddAbility.btLuck, AC);
        Inc(AddAbility.btUnLuck, MAC);
      end;
    ITEM_ARMOR:
      begin
        AddAbility.wAC := MakeLong(LoWord(AddAbility.wAC) + AC, HiWord(AddAbility.wAC) + AC2);
        AddAbility.wMAC := MakeLong(LoWord(AddAbility.wMAC) + MAC, HiWord(AddAbility.wMAC) + MAC2);

        Inc(AddAbility.btLuck, LoByte(Source));
        Inc(AddAbility.btUnLuck, Hibyte(Source));
      end;
    ITEM_ACCESSORY:
      begin
        case StdMode of
          19:
            begin
              Inc(AddAbility.wAntiMagic, AC2);
              Inc(AddAbility.btUnLuck, MAC);
              Inc(AddAbility.btLuck, MAC2);
            end;
          53:
            begin //新加物品属性
              if g_Config.boAddUserItemNewValue then
              begin
                Inc(AddAbility.wAntiMagic, AC2);
                Inc(AddAbility.btUnLuck, MAC);
                Inc(AddAbility.btLuck, MAC2);
              end else
              begin
                AddAbility.wAC := MakeLong(LoWord(AddAbility.wAC) + AC, HiWord(AddAbility.wAC) + AC2);
                AddAbility.wMAC := MakeLong(LoWord(AddAbility.wMAC) + MAC, HiWord(AddAbility.wMAC) + MAC2);
              end;
            end;
          63:
            begin //Charm
              Inc(AddAbility.wHP, AC);
              Inc(AddAbility.wMP, AC2);
              Inc(AddAbility.btUnLuck, MAC);
              Inc(AddAbility.btLuck, MAC2);
            end;
          20, 24:
            begin //004C0FF0
              Inc(AddAbility.wHitPoint, AC2);
              Inc(AddAbility.wSpeedPoint, MAC2);
            end;
          52:
            begin //原本与 20,24 一个属性，现在分开单独进行设置
              if g_Config.boAddUserItemNewValue then
              begin
                Inc(AddAbility.wHitPoint, AC2);
                Inc(AddAbility.wSpeedPoint, MAC2);
              end else
              begin
                AddAbility.wAC := MakeLong(LoWord(AddAbility.wAC) + AC, HiWord(AddAbility.wAC) + AC2);
                AddAbility.wMAC := MakeLong(LoWord(AddAbility.wMAC) + MAC, HiWord(AddAbility.wMAC) + MAC2);
              end;
            end;
          62:
            begin
              Inc(AddAbility.HandWeight, AC2);
              Inc(AddAbility.Weight, MAC);
              Inc(AddAbility.WearWeight, MAC2);
            end;
          21:
            begin
              Inc(AddAbility.wHealthRecover, AC2);
              Inc(AddAbility.wSpellRecover, MAC2);
              Inc(AddAbility.nHitSpeed, AC);
              Dec(AddAbility.nHitSpeed, MAC);
            end;
          54:
            begin //Belt
              if g_Config.boAddUserItemNewValue then
              begin
                Inc(AddAbility.wHealthRecover, AC2);
                Inc(AddAbility.wSpellRecover, MAC2);
                Inc(AddAbility.nHitSpeed, AC);
                Dec(AddAbility.nHitSpeed, MAC);
              end else
              begin
                AddAbility.wAC := MakeLong(LoWord(AddAbility.wAC) + AC, HiWord(AddAbility.wAC) + AC2);
                AddAbility.wMAC := MakeLong(LoWord(AddAbility.wMAC) + MAC, HiWord(AddAbility.wMAC) + MAC2);
              end;
            end;
          64:
            begin //Belt
              Inc(AddAbility.wHealthRecover, AC2);
              Inc(AddAbility.wSpellRecover, MAC2);
              Inc(AddAbility.nHitSpeed, AC);
              Dec(AddAbility.nHitSpeed, MAC);
            end;
          23:
            begin
              Inc(AddAbility.wAntiPoison, AC2);
              Inc(AddAbility.wPoisonRecover, MAC2);
              Inc(AddAbility.nHitSpeed, AC);
              Dec(AddAbility.nHitSpeed, MAC);
            end;
        {21: begin //格吧捞
     Inc(AddAbility.wAntiMagic,AC2);
     Inc(AddAbility.btUnLuck,MAC);
     Inc(AddAbility.btLuck,MAC2);
        end;
    22, //格吧捞
    41: begin //迫骂
     Inc(AddAbility.wHitPoint,AC2);
     Inc(AddAbility.wSpeedPoint,MAC2);
    end;
    23: begin //格吧捞
     Inc(AddAbility.wHealthRecover,AC2);
     Inc(AddAbility.wSpellRecover,MAC2);
     Inc(AddAbility.nHitSpeed,AC);
     Dec(AddAbility.nHitSpeed,MAC);
    end;
    32: begin //馆瘤
     Inc(AddAbility.wAntiPoison,AC2);
     Inc(AddAbility.wPoisonRecover,MAC2);
     Inc(AddAbility.nHitSpeed,AC);
     Dec(AddAbility.nHitSpeed,MAC);
    end;
    else begin
          AddAbility.wAC      := MakeLong(LoWord(AddAbility.wAC) + AC,HiWord(AddAbility.wAC) + AC2);
          AddAbility.wMAC     := MakeLong(LoWord(AddAbility.wMAC) + MAC,HiWord(AddAbility.wMAC) + MAC2);
    end;}
        end;
      end;
  end;
  AddAbility.wDC := MakeLong(LoWord(AddAbility.wDC) + DC, HiWord(AddAbility.wDC) + DC2);
  AddAbility.wMC := MakeLong(LoWord(AddAbility.wMC) + MC, HiWord(AddAbility.wMC) + MC2);
  AddAbility.wSC := MakeLong(LoWord(AddAbility.wSC) + SC, HiWord(AddAbility.wSC) + SC2);
end;













{ TItemUnit }


constructor TItemUnit.Create;
begin
  m_ItemNameList := TGList.Create;
end;

destructor TItemUnit.Destroy;
var
  i: Integer;
begin
  for i := 0 to m_ItemNameList.Count - 1 do
  begin
    Dispose(pTItemName(m_ItemNameList.Items[i]));
  end;
  m_ItemNameList.Free;
  inherited;
end;

function GetItemName(UserItem: pTUserItem): string;
begin
  //取自定义物品名称
  Result := '';
  if UserItem.btValue[13] = 1 then
    Result := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
  if Result = '' then
    Result := UserEngine.GetStdItemName(UserItem.wIndex);
end;

function TItemUnit.GetCustomItemName(nMakeIndex,
  nItemIndex: Integer): string;
var
  i: Integer;
  ItemName: pTItemName;
begin
  Result := '';
  m_ItemNameList.Lock;
  try
    for i := 0 to m_ItemNameList.Count - 1 do
    begin
      ItemName := m_ItemNameList.Items[i];
      if (ItemName.nMakeIndex = nMakeIndex) and (ItemName.nItemIndex = nItemIndex) then
      begin
        Result := ItemName.sItemName;
        Break;
      end;
    end;
  finally
    m_ItemNameList.UnLock;
  end;
end;


function TItemUnit.AddCustomItemName(nMakeIndex, nItemIndex: Integer;
  sItemName: string): Boolean;
var
  i: Integer;
  ItemName: pTItemName;
begin
  Result := False;
  m_ItemNameList.Lock;
  try
    for i := 0 to m_ItemNameList.Count - 1 do
    begin
      ItemName := m_ItemNameList.Items[i];
      if (ItemName.nMakeIndex = nMakeIndex) and (ItemName.nItemIndex = nItemIndex) then
      begin
        Exit;
      end;
    end;
    New(ItemName);
    ItemName.nMakeIndex := nMakeIndex;
    ItemName.nItemIndex := nItemIndex;
    ItemName.sItemName := sItemName;
    m_ItemNameList.Add(ItemName);
    Result := True;
  finally
    m_ItemNameList.UnLock;
  end;
end;

function TItemUnit.DelCustomItemName(nMakeIndex, nItemIndex: Integer): Boolean;
var
  i: Integer;
  ItemName: pTItemName;
begin
  Result := False;
  m_ItemNameList.Lock;
  try
    for i := 0 to m_ItemNameList.Count - 1 do
    begin
      ItemName := m_ItemNameList.Items[i];
      if (ItemName.nMakeIndex = nMakeIndex) and (ItemName.nItemIndex = nItemIndex) then
      begin
        Dispose(ItemName);
        m_ItemNameList.Delete(i);
        Result := True;
        Exit;
      end;
    end;
  finally
    m_ItemNameList.UnLock;
  end;
end;

function TItemUnit.LoadCustomItemName: Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
  sLineText: string;
  sMakeIndex: string;
  sItemIndex: string;
  nMakeIndex: Integer;
  nItemIndex: Integer;
  sItemName: string;
  ItemName: pTItemName;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemNameList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    m_ItemNameList.Lock;
    try
      m_ItemNameList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        sLineText := Trim(LoadList.Strings[i]);
        sLineText := GetValidStr3(sLineText, sMakeIndex, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sItemIndex, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sItemName, [' ', #9]);
        nMakeIndex := Str_ToInt(sMakeIndex, -1);
        nItemIndex := Str_ToInt(sItemIndex, -1);
        if (nMakeIndex >= 0) and (nItemIndex >= 0) then
        begin
          New(ItemName);
          ItemName.nMakeIndex := nMakeIndex;
          ItemName.nItemIndex := nItemIndex;
          ItemName.sItemName := sItemName;
          m_ItemNameList.Add(ItemName);
        end;
      end;
      Result := True;
    finally
      m_ItemNameList.UnLock;
    end;
  end else
  begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function TItemUnit.SaveCustomItemName: Boolean;
var
  i: Integer;
  SaveList: TStringList;
  sFileName: string;
  ItemName: pTItemName;
begin
  sFileName := g_Config.sEnvirDir + 'ItemNameList.txt';
  SaveList := TStringList.Create;
  m_ItemNameList.Lock;
  try
    for i := 0 to m_ItemNameList.Count - 1 do
    begin
      ItemName := m_ItemNameList.Items[i];
      SaveList.Add(IntToStr(ItemName.nMakeIndex) + #9 + IntToStr(ItemName.nItemIndex) + #9 + ItemName.sItemName);
    end;
  finally
    m_ItemNameList.UnLock;
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
  Result := True;
end;

procedure TItemUnit.Lock;
begin
  m_ItemNameList.Lock;
end;

procedure TItemUnit.UnLock;
begin
  m_ItemNameList.UnLock;
end;

end.
