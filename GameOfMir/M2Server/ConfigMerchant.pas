unit ConfigMerchant;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin,ObjNpc, StrUtils, SDK, HUtil32;

type
  TfrmConfigMerchant = class(TForm)
    ListBoxMerChant: TListBox;
    Label1: TLabel;
    GroupBoxNPC: TGroupBox;
    Label2: TLabel;
    EditScriptName: TEdit;
    Label3: TLabel;
    EditMapName: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditShowName: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    CheckBoxOfCastle: TCheckBox;
    ComboBoxDir: TComboBox;
    EditImageIdx: TSpinEdit;
    EditX: TSpinEdit;
    EditY: TSpinEdit;
    GroupBoxScript: TGroupBox;
    MemoScript: TMemo;
    ButtonScriptSave: TButton;
    GroupBox3: TGroupBox;
    CheckBoxBuy: TCheckBox;
    CheckBoxSell: TCheckBox;
    CheckBoxStorage: TCheckBox;
    CheckBoxGetback: TCheckBox;
    CheckBoxMakedrug: TCheckBox;
    CheckBoxUpgradenow: TCheckBox;
    CheckBoxGetbackupgnow: TCheckBox;
    CheckBoxRepair: TCheckBox;
    CheckBoxS_repair: TCheckBox;
    ButtonReLoadNpc: TButton;
    ButtonSave: TButton;
    CheckBoxDenyRefStatus: TCheckBox;
    Label9: TLabel;
    EditPriceRate: TSpinEdit;
    Label10: TLabel;
    EditMapDesc: TEdit;
    CheckBoxSendMsg: TCheckBox;
    CheckBoxAutoMove: TCheckBox;
    Label11: TLabel;
    EditMoveTime: TSpinEdit;
    ButtonClearTempData: TButton;
    ButtonRecover: TButton;
    procedure ListBoxMerChantClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure CheckBoxDenyRefStatusClick(Sender: TObject);
    procedure EditXChange(Sender: TObject);
    procedure EditYChange(Sender: TObject);
    procedure EditShowNameChange(Sender: TObject);
    procedure EditImageIdxChange(Sender: TObject);
    procedure CheckBoxOfCastleClick(Sender: TObject);
    procedure CheckBoxBuyClick(Sender: TObject);
    procedure CheckBoxSellClick(Sender: TObject);
    procedure CheckBoxGetbackClick(Sender: TObject);
    procedure CheckBoxStorageClick(Sender: TObject);
    procedure CheckBoxUpgradenowClick(Sender: TObject);
    procedure CheckBoxGetbackupgnowClick(Sender: TObject);
    procedure CheckBoxRepairClick(Sender: TObject);
    procedure CheckBoxS_repairClick(Sender: TObject);
    procedure CheckBoxMakedrugClick(Sender: TObject);
    procedure EditPriceRateChange(Sender: TObject);
    procedure ButtonScriptSaveClick(Sender: TObject);
    procedure ButtonReLoadNpcClick(Sender: TObject);
    procedure EditScriptNameChange(Sender: TObject);
    procedure EditMapNameChange(Sender: TObject);
    procedure ComboBoxDirChange(Sender: TObject);
    procedure MemoScriptChange(Sender: TObject);
    procedure CheckBoxSendMsgClick(Sender: TObject);
    procedure CheckBoxAutoMoveClick(Sender: TObject);
    procedure EditMoveTimeChange(Sender: TObject);
    procedure ButtonClearTempDataClick(Sender: TObject);
    procedure ListBoxMerChantDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListBoxMerChantMeasureItem(Control: TWinControl;
      Index: Integer; var Height: Integer);
    procedure ButtonRecoverClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    SelMerchant:TMerchant;
    RecoverMerchantList: TGList; //初始NPC数据份，用于恢复修改，lzxsz2022 - Add by davy 2022-5-22

    boOpened:Boolean;
    boModValued:Boolean;
    bIsNpcChanged:Boolean;
    
    procedure ModValue();
    procedure uModValue();
    procedure RefListBoxMerChant();
    procedure ClearMerchantData();
    procedure LoadScriptFile();
    procedure ChangeScriptAllowAction();

    //ListBox记录修改标记 lzxsz2022 -  Add  ydavy b2022-5-22
    procedure SetModifiedTag(ItemIndex: Integer);
    procedure DelModifiedTag(ItemIndex: Integer);
    function IsModifiedTag(ItemIndex: Integer):Boolean;
    function BackupRecoverMerchant(): Integer;

    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmConfigMerchant: TfrmConfigMerchant;

implementation

uses UsrEngn, M2Share, LocalDB;

{$R *.dfm}

{ TfrmConfigMerchant }
//设置修改标记。自定义：在最后加个回车符作为修改标记
procedure TfrmConfigMerchant.SetModifiedTag(ItemIndex: Integer);
begin
  if(ItemIndex >=0) then
  begin
     if (IsModifiedTag(ItemIndex) = False) then
     begin
        ListBoxMerChant.Items.Strings[ItemIndex] :=  ListBoxMerChant.Items.Strings[ItemIndex] + #13;  //#13加回车符
     end;
     
     bIsNpcChanged := True;
  end;
end; 

//删除修改标记
procedure TfrmConfigMerchant.DelModifiedTag(ItemIndex: Integer);
var
   strItemText : String;
begin
  if(ItemIndex >=0) then
  begin
     if (IsModifiedTag(ItemIndex) = True) then
     begin
        strItemText := ListBoxMerChant.Items.Strings[ItemIndex];
        ListBoxMerChant.Items.Strings[ItemIndex] := LeftStr(strItemText,Length(strItemText)-1);
     end;
  end;
end;

//是否有修改标记
function TfrmConfigMerchant.IsModifiedTag(ItemIndex: Integer):Boolean;
var
   TagChar : String;
begin
  if(ItemIndex >=0) then
    begin
      TagChar :=  RightStr(ListBoxMerChant.Items.Strings[ItemIndex],1);
      if ( TagChar = #13 ) then
       begin
         result := True;  //#13加回车符
         Exit;  //类似于Return
       end
   end;

   result := False;
end;

procedure TfrmConfigMerchant.ModValue;
begin
  if(bIsNpcChanged = True) then
  begin
     ButtonSave.Enabled:=True;
     ButtonRecover.Enabled:=True;
  end;

  ButtonScriptSave.Enabled:=True;
end;

procedure TfrmConfigMerchant.uModValue;
begin
  if(bIsNpcChanged = False) then
  begin
    ButtonSave.Enabled:=False;
    ButtonRecover.Enabled:=False;
  end;

  ButtonScriptSave.Enabled:=False;
end;

//备份NPC用于恢复的数据。用于放弃修改，恢复原来数据。lzx2022 - Add By 2022-5-22
function TfrmConfigMerchant.BackupRecoverMerchant(): Integer;
var
  Merchant: TMerchant;
  tMerchantNPC : TMerchant;
  I: Integer;
begin

     RecoverMerchantList := TGList.Create;

     for I := 0 to UserEngine.m_MerchantList.Count - 1 do begin
       Merchant := TMerchant.Create;
       tMerchantNPC:=TMerchant(UserEngine.m_MerchantList.Items[I]);

       Merchant.m_sScript   := Copy(tMerchantNPC.m_sScript, 0, Length(tMerchantNPC.m_sScript));
       Merchant.m_sMapName  := Copy(tMerchantNPC.m_sMapName, 0, Length(tMerchantNPC.m_sMapName));
       Merchant.m_nCurrX    := tMerchantNPC.m_nCurrX;
       Merchant.m_nCurrY    := tMerchantNPC.m_nCurrY;
       Merchant.m_sCharName := Copy(tMerchantNPC.m_sCharName, 0, Length(tMerchantNPC.m_sCharName));
       Merchant.m_nFlag     := tMerchantNPC.m_nFlag;
       Merchant.m_wAppr     := tMerchantNPC.m_wAppr;
       Merchant.m_boCastle  := tMerchantNPC.m_boCastle;

       RecoverMerchantList.Add(Merchant);
     end;
   Result := 1;
end;


//对话框打开时自动调用该函数
procedure TfrmConfigMerchant.Open;
var
  Merchant: TMerchant;
  I: Integer;
begin
  boOpened:=False;
  uModValue();
  CheckBoxDenyRefStatus.Checked:=False;

  SelMerchant:=nil;
  RefListBoxMerChant;  //初始NPC化列表

  //备份恢复的NPC数据，用于恢复修改。lzx2022 - Add By 2022-5-22
  BackupRecoverMerchant();

  boOpened:=True;
  ShowModal;
end;


procedure TfrmConfigMerchant.ButtonClearTempDataClick(Sender: TObject);
begin
  if Application.MessageBox(PChar('是否确认清除NPC临时数据？'),'确认信息',MB_YESNO + MB_ICONQUESTION) = mrYes then begin
    ClearMerchantData();
  end;
end;

{
 //该保存事件会重写原的NCP配置文件，而不是只修改相应的记录。故弃用，改用新的。
 //lzxsz2022 - modified by davy 2022-5-21
procedure TfrmConfigMerchant.ButtonSaveClick_old(Sender: TObject);
var
  I:Integer;
  SaveList:TStringList;
  Merchant:TMerchant;
  sMerchantFile:String;
  sIsCastle:String;
  sCanMove:String;
begin
  sMerchantFile:=g_Config.sEnvirDir + 'Merchant.txt';
  SaveList:=TStringList.Create;
  UserEngine.m_MerchantList.Lock;
  try
    for I := 0 to UserEngine.m_MerchantList.Count - 1 do begin
      Merchant:=TMerchant(UserEngine.m_MerchantList.Items[I]);
       // if Merchant.m_sMapName = '0' then Continue;  //??? 这是BUG所在。这里跳过了0号地图的NCP，是错误的。 modified 2022-05-19

       //NCP列表的首一条记录是QFunction NCP，故跳过。
       //QFunction	0	0	0	QFunction	0	0	0	0	0
       if Merchant.m_sCharName = 'QFunction' then Continue;   //lzxsz2022 - Modifyed by davy 2022-05-19

    //lzxsz - Modified by davy 2022-5-20 
    //取消PNC自动移动设置,这个设置可能会扰乱服务端正常工作。
    //  if Merchant.m_boCastle then sIsCastle:='1'
    //  else sIsCastle:='0';
    //  if Merchant.m_boCanMove then sCanMove:='1'
    // else sCanMove:='0';

      //#N 表示十进制N表示的Ascii 字符。#9表示tab键。
      //#10表示换行。#13表示回车。#32 表示空格
      SaveList.Add(Merchant.m_sScript + #9 +
                   Merchant.m_sMapName + #9 +
                   IntToStr(Merchant.m_nCurrX) + #9 +
                   IntToStr(Merchant.m_nCurrY) + #9 +
                   Merchant.m_sCharName + #9 +
                   IntToStr(Merchant.m_nFlag) + #9 +
                   IntToStr(Merchant.m_wAppr) + #9 +
                   sIsCastle // + #9+
                   
               //    sCanMove + #9 +
               //    IntToStr(Merchant.m_dwMoveTime)
                   )
    end;
    SaveList.SaveToFile(sMerchantFile);
  finally
    UserEngine.m_MerchantList.UnLock;
  end;
  SaveList.Free;
  uModValue();
end;
}


//删除重复的分隔符，如果分隔符之间空格是隔开，则视为分隔符重复，会被删除空格和后面的分隔符
Function DelSameDelimiter(Ch : Char; S : String) : String;
 Var
  I : Integer;
  len : Integer;
begin
 I := 1;
 len := Length(S);
 
 While I <= len do
  begin
    If (S[I] = CH) and ((S[I+1] = CH) or (S[I+1] = ' ')) then
     begin
         //如果分隔符后面字符是相同的分隔符或是空格，删除后和分隔符或空格，
         Delete(S, I+1, 1);
     end //记住这里不能加分号
    Else         
      begin
         I := I + 1;
      end; //这里要加分号
  end;
 result := S;
end;

function GetLstBoxIndex(LstBox: TListBox): Integer;
begin
  Result:=-1;
  Result:=LstBox.ItemIndex;
end;

{
//该保存事件不会重写原的NCP配置文件，仅修改相应的记录。
//本函数取消CPN移动的设置项(sCanMove)，该设置可能会造成游戏中NCP位置混乱。
// lzxsz2022 - add by davy 2022-5-21
procedure TfrmConfigMerchant.ButtonSaveClick_old(Sender: TObject);
var
  I,N:Integer;
  SaveList:TStringList;
  Merchant:TMerchant;
  sMerchantFile:String;
  //sCanMove:String;

  sLineText:String;
  sFirst:String;
  AttributeList :TStrings;

  //修改参数 ,原参数
  sScript,   sOldScript   : String;
  sMapName,  sOldMapName  : String;
  sNpcName,  sOldNpcName  : String;
  sNpcCurrX, sOldNpcCurrX : String;
  sNpcCurrY, sOldNpcCurrY : String;
  sFlag,     sOldFlag     : String;
  sAppr,     sOldAppr     : String;
  sIsCastle, sOldIsCastle : String;

  sSelNpcName : String;      //ListBox选中的NPC名称
  
 // sFileNpcName   : String;     //文件中的NPC名称
 // nSelIdx : Integer;
  sSelItemText : String;
begin

  sMerchantFile:=g_Config.sEnvirDir + 'Merchant.txt';
  SaveList:=TStringList.Create;          //NPC文本对象
  SaveList.LoadFromFile(sMerchantFile);
  
  AttributeList := TStringList.Create;   //NPC属性列表

  UserEngine.m_MerchantList.Lock;
  try

  for N := 0 to ListBoxMerChant.Items.Count -1 do  //for1
  begin
    if(IsModifiedTag(N) = False) then      //if1
      begin
        continue;
      end
    else
     begin
       SelMerchant := TMerchant(ListBoxMerChant.Items.Objects[N]);
       sScript     := SelMerchant.m_sScript;            //0
       sMapName    := SelMerchant.m_sMapName;           //1
       sNpcCurrX   := IntToStr(SelMerchant.m_nCurrX);   //2
       sNpcCurrY   := IntToStr(SelMerchant.m_nCurrY);   //3
       sNpcName    := SelMerchant.m_sCharName;          //4
       sFlag       := IntToStr(SelMerchant.m_nFlag);    //5 方向
       sAppr       := IntToStr(SelMerchant.m_wAppr);    //6

       If SelMerchant.m_boCastle = True then  sIsCastle := '1' //7
       else    sIsCastle := '0';

       //获取原来未修改前，NPC的名称
       sSelItemText :=  ListBoxMerChant.Items.Strings[N];
       sSelNpcName := Trim(LeftStr(sSelItemText,Pos('-', sSelItemText)-1));  //截取NCP名称
   
    end; //if1
 
    //从配置文件中找出要修改的NCP,并进行修改保存

     for I := 0 to SaveList.Count -1 do     //for2
     begin

      // sLine := SaveList[I];
      // sLine := Trim(sLine);
      // sFirst := LeftStr(sLine,1);

      sLineText := Trim(SaveList[I]);
      
      if (sLineText <> '') and (sLineText[1] <> ';') then     //if2
       begin
         sLineText := GetValidStr3(sLineText, sOldScript, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldMapName, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldNpcCurrX, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldNpcCurrY, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldNpcName, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldFlag, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldAppr, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sIsCastle, [' ', #9]);

         // sLine := DelSameDelimiter(#9,sLine);    //删除重复的分隔符
         // AttributeList.Delimiter := #9;          //TAB 字符, 水平制表符
         // AttributeList.DelimitedText := sLine;

         // sFileNpcName := Trim(AttributeList[4]);  //配置文件中的NCP名称

          if (sOldNpcName = sSelNpcName)        and   //[4]
             (sOldScript = sScript)    and
             (sOldMapName = sMapName)   and
             (sOldNpcCurrX = sNpcCurrX)  and
             (sOldNpcCurrY = sNpcCurrY)  and
             (sOldFlag = sFlag)      and
             (sOldAppr = sAppr)      and
             (sIsCastle = sIsCastle)
          then
          begin
             AttributeList[0] := sScript;
             AttributeList[1] := sMapName;
             AttributeList[2] := sNpcCurrX;
             AttributeList[3] := sNpcCurrY;
             AttributeList[4] := sNpcName;

             AttributeList[5] := sFlag;
             AttributeList[6] := sAppr;
             AttributeList[7] := sIsCastle;

             //Copy(SaveList[I],0 ,Length(AttributeList.DelimitedText));
             SaveList[I] := AttributeList.DelimitedText;
             break;
          end;
      end;   //if2
   end;  //for2
 end;  //for1
    
    //将NCP配置的修改保存到文件中
    SaveList.SaveToFile(sMerchantFile);

    //刷新NPC列表
    ListBoxMerChant.Clear;
    SelMerchant:=nil;
    RefListBoxMerChant;

    //设置记录改变标记为无改变
    bIsNpcChanged := False;

   finally
     UserEngine.m_MerchantList.UnLock;
   end;

    SaveList.Free;
    AttributeList.Free;

  uModValue();


end;

}

//该保存事件不会重写原的NCP配置文件，仅修改相应的记录。
//本函数取消CPN移动的设置(sCanMove)。
procedure TfrmConfigMerchant.ButtonSaveClick(Sender: TObject);
var
  I,N:Integer;
  SaveList:TStringList;
  Merchant:TMerchant;
  sMerchantFile:String;
  //sCanMove:String;

  sLineText:String;
  sFirst:String;
  AttributeList :TStrings;

  //原参数 （来源配置文件）
  sOldScript   : String;
  sOldMapName  : String;
  sOldNpcName  : String;
  sOldNpcCurrX : String;
  sOldNpcCurrY : String;

  //对比参数 （来源配置文件ListBox文本）
  sComNpcName : String;      //ListBox文本的NPC名称
  sComNpcCurrX : String;     //ListBox文本的NPC坐标X
  sComNpcCurrY : String;     //ListBox文本的NPC坐标X
  sComMapName   :  String;   //ListBox文本的NPC地图名
  
  sSelIsCastle :  String;    //修改参数是否属城堡

  post1, post2, post3 : Integer;
    
   sSelItemText : String;
   OldItemIndex : Integer;
begin

  sMerchantFile:=g_Config.sEnvirDir + 'Merchant.txt';
  SaveList:=TStringList.Create;          //NPC文本对象
  SaveList.LoadFromFile(sMerchantFile);

  OldItemIndex :=  ListBoxMerChant.ItemIndex;
  
  UserEngine.m_MerchantList.Lock;
  try

    //从配置文件中找出要修改的NCP,并进行修改保存
     N:=0;
     for I := 0 to SaveList.Count -1 do     //for2
     begin

      sLineText := Trim(SaveList[I]);
      
      if (sLineText <> '') and (sLineText[1] <> ';') then     //if2
       begin
         sLineText := GetValidStr3(sLineText, sOldScript, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldMapName, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldNpcCurrX, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldNpcCurrY, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldNpcName, [' ', #9]);

        //从ListBox文本，获取比较参数（原来未修改的参数）
        sSelItemText :=  ListBoxMerChant.Items.Strings[N];
        //格式：名称 - 地图 (x:y)
        post1 := Pos('-', sSelItemText);        
        sComNpcName := Trim(LeftStr(sSelItemText,post1 - 1));  //NCP名称

        post2 := Pos('(', sSelItemText);
        sComMapName := Trim(MidStr(sSelItemText,post1+1, post2-post1-1));  //地图名称
        
        post1 := post2;
        post2 := Pos(':', sSelItemText);
        sComNpcCurrX := Trim(MidStr(sSelItemText,post1+1, post2-post1-1));  //X坐标

        post1 := post2;
        post2 := Pos(')', sSelItemText);
        sComNpcCurrY := Trim(MidStr(sSelItemText,post1+1, post2-post1-1));  //Y坐标

        if (sOldNpcName  = sComNpcName)   and
           (sOldMapName  = sComMapName)   and
           (sOldNpcCurrX = sComNpcCurrX) and
           (sOldNpcCurrY = sComNpcCurrY)
          then
          begin

        SelMerchant := TMerchant(ListBoxMerChant.Items.Objects[N]);

        if (SelMerchant.m_boCastle = true) then  sSelIsCastle := '1'
        else     sSelIsCastle := '0';
        
        SaveList[I] :=  SelMerchant.m_sScript + #9 +
                        SelMerchant.m_sMapName + #9 +
                        IntToStr(SelMerchant.m_nCurrX) + #9 +
                        IntToStr(SelMerchant.m_nCurrY) + #9 +
                        SelMerchant.m_sCharName + #9 +
                        IntToStr(SelMerchant.m_nFlag) + #9 +
                        IntToStr(SelMerchant.m_wAppr) + #9 +
                        sSelIsCastle;

           Inc(N);   //计数加1
          end;
      end;   //if2
   end;  //for2

   //将NCP配置的修改保存到文件中
   SaveList.SaveToFile(sMerchantFile);
   BackupRecoverMerchant();  //重新备份数据

  //刷新NPC列表
    ListBoxMerChant.Clear;
    SelMerchant:=nil;
    RefListBoxMerChant; //刷新

    ListBoxMerChant.SetFocus; //设置焦点
    ListBoxMerChant.Selected[OldItemIndex]:=True ;  //设置选择项高亮
    ListBoxMerChantClick(Sender); //调用点击事件

    //设置记录改变标记为无改变
    bIsNpcChanged := False;

   finally
     UserEngine.m_MerchantList.UnLock;
   end;

   SaveList.Free;

  uModValue();

end;



//恢复NCP的修改。仅在保存之前进行。lzxsz2022 - Add By davy 2022-5-22
procedure TfrmConfigMerchant.ButtonRecoverClick(Sender: TObject);
var
  I, N : Integer;
  Merchant:TMerchant;
  OldMerchant:TMerchant;
  OldItemIndex:Integer;
begin

  OldItemIndex :=  ListBoxMerChant.ItemIndex;
  ListBoxMerChant.Clear;   //重要
  SelMerchant:=nil;

  UserEngine.m_MerchantList.Lock;
  try
    for I := 0 to RecoverMerchantList.Count - 1 do begin
      OldMerchant:=TMerchant(RecoverMerchantList.Items[I]);
      Merchant:=TMerchant(UserEngine.m_MerchantList.Items[I]);

      Merchant.m_sScript   := Copy(OldMerchant.m_sScript, 0, Length(OldMerchant.m_sScript));
      Merchant.m_sMapName  := Copy(OldMerchant.m_sMapName, 0, Length(OldMerchant.m_sMapName));
      Merchant.m_nCurrX    := OldMerchant.m_nCurrX;
      Merchant.m_nCurrY    := OldMerchant.m_nCurrY;
      Merchant.m_sCharName := Copy(OldMerchant.m_sCharName, 0, Length(OldMerchant.m_sCharName));
      Merchant.m_nFlag     := OldMerchant.m_nFlag;
      Merchant.m_wAppr     := OldMerchant.m_wAppr;
      Merchant.m_boCastle  := OldMerchant.m_boCastle;

      if  (Merchant.m_nCurrX = 0) and (Merchant.m_nCurrY = 0) then Continue;
        
      ListBoxMerChant.Items.AddObject(Merchant.m_sCharName + ' - ' + Merchant.m_sMapName + ' (' + IntToStr(Merchant.m_nCurrX) + ':' + IntToStr(Merchant.m_nCurrY) + ')',Merchant );
    end;   //for
  finally
    UserEngine.m_MerchantList.UnLock;
  end;

  ListBoxMerChant.SetFocus; //设置焦点
  ListBoxMerChant.Selected[OldItemIndex]:=True ;  //设置选择项高亮
  ListBoxMerChantClick(Sender); //调用点击事件
    
  //设置记录改变标记为无改变
  bIsNpcChanged := False;
  uModValue();

end;


procedure TfrmConfigMerchant.ClearMerchantData;
var
  I: Integer;
  Merchant:TMerchant;
begin
  UserEngine.m_MerchantList.Lock;
  try
    for I := 0 to UserEngine.m_MerchantList.Count - 1 do begin
      Merchant:=TMerchant(UserEngine.m_MerchantList.Items[I]);
      Merchant.ClearData();
    end;
  finally
    UserEngine.m_MerchantList.UnLock;
  end;
end;

procedure TfrmConfigMerchant.RefListBoxMerChant;
var
  I: Integer;
  Merchant:TMerchant;
begin
  UserEngine.m_MerchantList.Lock;
  try
    for I := 0 to UserEngine.m_MerchantList.Count - 1 do begin
      Merchant:=TMerchant(UserEngine.m_MerchantList.Items[I]);
      //if (Merchant.m_sMapName = '0') and (Merchant.m_nCurrX = 0) and (Merchant.m_nCurrY = 0) then Continue;  //Bug 在依排除了0号地图。0号地图是存在的（0号是比奇省）
      if (Merchant.m_nCurrX = 0) and (Merchant.m_nCurrY = 0) then Continue;    //lzxsz2022 - Mydified by Davy 2022-5-22

      ListBoxMerChant.Items.AddObject(Merchant.m_sCharName + ' - ' + Merchant.m_sMapName + ' (' + IntToStr(Merchant.m_nCurrX) + ':' + IntToStr(Merchant.m_nCurrY) + ')',Merchant );
    end;
  finally
    UserEngine.m_MerchantList.UnLock;
  end;

end;

procedure TfrmConfigMerchant.ListBoxMerChantClick(Sender: TObject);
var
  nSelIndex:Integer;
begin
  CheckBoxDenyRefStatus.Checked:=False;
  uModValue();
  boOpened:=False;
  nSelIndex:=ListBoxMerChant.ItemIndex;
  if nSelIndex < 0 then exit;
  SelMerchant:=TMerchant(ListBoxMerChant.Items.Objects[nSelIndex]);  //选择的NPC
  EditScriptName.Text:=SelMerchant.m_sScript;
  EditMapName.Text:=SelMerchant.m_sMapName;
  EditMapDesc.Text:=SelMerchant.m_PEnvir.sMapDesc;
  EditX.Value:=SelMerchant.m_nCurrX;
  EditY.Value:=SelMerchant.m_nCurrY;
  EditShowName.Text:=SelMerchant.m_sCharName;
  ComboBoxDir.ItemIndex:=SelMerchant.m_nFlag;
  EditImageIdx.Value:=SelMerchant.m_wAppr;
  CheckBoxOfCastle.Checked:=SelMerchant.m_boCastle;
  //CheckBoxAutoMove.Checked:=SelMerchant.m_boCanMove;
  //EditMoveTime.Value:=SelMerchant.m_dwMoveTime;
  
  CheckBoxBuy.Checked:=SelMerchant.m_boBuy;
  CheckBoxSell.Checked:=SelMerchant.m_boSell;
  CheckBoxGetback.Checked:=SelMerchant.m_boGetback;
  CheckBoxStorage.Checked:=SelMerchant.m_boStorage;
  CheckBoxUpgradenow.Checked:=SelMerchant.m_boUpgradenow;
  CheckBoxGetbackupgnow.Checked:=SelMerchant.m_boGetBackupgnow;
  CheckBoxRepair.Checked:=SelMerchant.m_boRepair;
  CheckBoxS_repair.Checked:=SelMerchant.m_boS_repair;
  CheckBoxMakedrug.Checked:=SelMerchant.m_boMakeDrug;
  CheckBoxSendMsg.Checked:=SelMerchant.m_boSendmsg;

  EditPriceRate.Value:=SelMerchant.m_nPriceRate;
  MemoScript.Clear;
  ButtonReLoadNpc.Enabled:=False;
  LoadScriptFile();

  GroupBoxNPC.Enabled:=True;
  GroupBoxScript.Enabled:=True;

  boOpened:=True;
end;

procedure TfrmConfigMerchant.FormCreate(Sender: TObject);
begin
  ComboBoxDir.Items.Add('0');
  ComboBoxDir.Items.Add('1');
  ComboBoxDir.Items.Add('2');
  ComboBoxDir.Items.Add('3');
  ComboBoxDir.Items.Add('4');
  ComboBoxDir.Items.Add('5');
  ComboBoxDir.Items.Add('6');
  ComboBoxDir.Items.Add('7');

end;


procedure TfrmConfigMerchant.CheckBoxDenyRefStatusClick(Sender: TObject);
begin
  if SelMerchant <> nil then begin
    SelMerchant.m_boDenyRefStatus:=CheckBoxDenyRefStatus.Checked;
  end;
end;

//修改NPC的X坐标
procedure TfrmConfigMerchant.EditXChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_nCurrX:=EditX.Value;
  SetModifiedTag(ListBoxMerChant.ItemIndex); //设置修改标记，lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//修改NPC的Y坐标
procedure TfrmConfigMerchant.EditYChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_nCurrY:=EditY.Value;
  SetModifiedTag(ListBoxMerChant.ItemIndex); //设置修改标记，lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//修改NPC显示名称
procedure TfrmConfigMerchant.EditShowNameChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_sCharName:=Trim(EditShowName.Text);
  SetModifiedTag(ListBoxMerChant.ItemIndex); //设置修改标记，lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//修改NPC外形
procedure TfrmConfigMerchant.EditImageIdxChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_wAppr:=EditImageIdx.Value;
  SetModifiedTag(ListBoxMerChant.ItemIndex); //设置修改标记，lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//修改NPC脚本
procedure TfrmConfigMerchant.EditScriptNameChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_sScript:=Trim(EditScriptName.Text);
  SetModifiedTag(ListBoxMerChant.ItemIndex); //设置修改标记，lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//修改NPC地图
procedure TfrmConfigMerchant.EditMapNameChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_sMapName:=Trim(EditMapName.Text);
  SetModifiedTag(ListBoxMerChant.ItemIndex); //设置修改标记，lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//修改NPC方向
procedure TfrmConfigMerchant.ComboBoxDirChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_nFlag:=ComboBoxDir.ItemIndex;
  SetModifiedTag(ListBoxMerChant.ItemIndex); //设置修改标记，lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//修改NPC是否属于城堡
procedure TfrmConfigMerchant.CheckBoxOfCastleClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boCastle:=CheckBoxOfCastle.Checked;
  SetModifiedTag(ListBoxMerChant.ItemIndex); //设置修改标记，lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//取消NCP移动的设置。lzxsz-2022 Modifyed By Davy 2022-5-22
procedure TfrmConfigMerchant.CheckBoxAutoMoveClick(Sender: TObject);
begin
  //if not boOpened or (SelMerchant =nil) then exit;
  //SelMerchant.m_boCanMove:=CheckBoxAutoMove.Checked;
  //ModValue();
end;

//取消NCP移动时间间隔的设置。lzxsz-2022 Modifyed By Davy 2022-5-22
procedure TfrmConfigMerchant.EditMoveTimeChange(Sender: TObject);
begin
 // if not boOpened or (SelMerchant =nil) then exit;
 // SelMerchant.m_dwMoveTime:=EditMoveTime.Value;
 // ModValue();
end;

procedure TfrmConfigMerchant.LoadScriptFile;
var
  I: Integer;
  sScriptFile:String;
  LoadList:TStringList;
  LineText:String;
  boNoHeader:Boolean;
begin
  if SelMerchant = nil then exit;
  sScriptFile:=g_Config.sEnvirDir + 'Market_Def\' + SelMerchant.m_sScript + '-' + SelMerchant.m_sMapName + '.txt';
  MemoScript.Visible:=False;
  LineText:='(';
  if SelMerchant.m_boBuy then LineText:=LineText + sBUY + ' ';
  if SelMerchant.m_boSell then LineText:=LineText + sSELL + ' ';
  if SelMerchant.m_boMakeDrug then LineText:=LineText + sMAKEDURG + ' ';
  if SelMerchant.m_boStorage then LineText:=LineText + sSTORAGE + ' ';
  if SelMerchant.m_boGetback then LineText:=LineText + sGETBACK + ' ';
  if SelMerchant.m_boUpgradenow then LineText:=LineText + sUPGRADENOW + ' ';
  if SelMerchant.m_boGetBackupgnow then LineText:=LineText + sGETBACKUPGNOW + ' ';
  if SelMerchant.m_boRepair then LineText:=LineText + sREPAIR + ' ';
  if SelMerchant.m_boS_repair then LineText:=LineText + sSUPERREPAIR + ' ';
  if SelMerchant.m_boSendmsg then LineText:=LineText + sSL_SENDMSG + ' ';  
  LineText:=LineText + ')';
  MemoScript.Lines.Add(LineText);
  LineText:='%' + IntToStr(SelMerchant.m_nPriceRate);
  MemoScript.Lines.Add(LineText);
  for I := 0 to SelMerchant.m_ItemTypeList.Count - 1 do begin
    LineText:='+' + IntToStr(Integer(SelMerchant.m_ItemTypeList.Items[I]));
    MemoScript.Lines.Add(LineText);
  end;
  if FileExists(sScriptFile) then begin
    LoadList:=TStringList.Create;
    LoadList.LoadFromFile(sScriptFile);
    boNoHeader:=False;
    for I := 0 to LoadList.Count - 1 do begin
      LineText:=LoadList.Strings[I];
      if (LineText = '') or (LineText[1] = ';') then Continue;

      if (LineText[1] = '[') or (LineText[1] = '#') then boNoHeader:=True;
      if boNoHeader then begin
        MemoScript.Lines.Add(LineText);
      end;

    end;
    LoadList.Free;
  end;
  MemoScript.Visible:=True;
end;

procedure TfrmConfigMerchant.ChangeScriptAllowAction;
var
  LineText:String;
begin
  if (SelMerchant = nil) or (MemoScript.Lines.Count <=0 ) then exit;
  LineText:='(';
  if SelMerchant.m_boBuy then LineText:=LineText + sBUY + ' ';
  if SelMerchant.m_boSell then LineText:=LineText + sSELL + ' ';
  if SelMerchant.m_boMakeDrug then LineText:=LineText + sMAKEDURG + ' ';
  if SelMerchant.m_boStorage then LineText:=LineText + sSTORAGE + ' ';
  if SelMerchant.m_boGetback then LineText:=LineText + sGETBACK + ' ';
  if SelMerchant.m_boUpgradenow then LineText:=LineText + sUPGRADENOW + ' ';
  if SelMerchant.m_boGetBackupgnow then LineText:=LineText + sGETBACKUPGNOW + ' ';
  if SelMerchant.m_boRepair then LineText:=LineText + sREPAIR + ' ';
  if SelMerchant.m_boS_repair then LineText:=LineText + sSUPERREPAIR + ' ';
  if SelMerchant.m_boSendmsg then LineText:=LineText + sSL_SENDMSG + ' ';  
  LineText:=LineText + ')';
  MemoScript.Lines[0]:=LineText;
end;

procedure TfrmConfigMerchant.CheckBoxBuyClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boBuy:=CheckBoxBuy.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxSellClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boSell:=CheckBoxSell.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxGetbackClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boGetback:=CheckBoxGetback.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxStorageClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boStorage:=CheckBoxStorage.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxUpgradenowClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boUpgradenow:=CheckBoxUpgradenow.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxGetbackupgnowClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boGetBackupgnow:=CheckBoxGetbackupgnow.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxRepairClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boRepair:=CheckBoxRepair.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxS_repairClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boS_repair:=CheckBoxS_repair.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxMakedrugClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boMakeDrug:=CheckBoxMakedrug.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxSendMsgClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boSendmsg:=CheckBoxSendMsg.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.EditPriceRateChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
    
  SelMerchant.m_nPriceRate:=EditPriceRate.Value;
  MemoScript.Lines[1]:='%' + IntToStr(SelMerchant.m_nPriceRate);
  ModValue();

end;

procedure TfrmConfigMerchant.ButtonScriptSaveClick(Sender: TObject);
var
  sScriptFile:String;
begin
  sScriptFile:=g_Config.sEnvirDir + 'Market_Def\' + SelMerchant.m_sScript + '-' + SelMerchant.m_sMapName + '.txt';
  MemoScript.Lines.SaveToFile(sScriptFile);
  uModValue();
  ButtonReLoadNpc.Enabled:=True;
end;

procedure TfrmConfigMerchant.ButtonReLoadNpcClick(Sender: TObject);
begin
  if (SelMerchant =nil) then exit;
  try
    EnterCriticalSection(ProcessHumanCriticalSection);
    SelMerchant.ClearScript;
    SelMerchant.LoadNPCScript;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
  ButtonReLoadNpc.Enabled:=False;
end;

procedure TfrmConfigMerchant.MemoScriptChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  ModValue();
end;

//改变文本显示颜色
procedure TfrmConfigMerchant.ListBoxMerChantDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin

   if (Index >=0) then
   begin
     if (IsModifiedTag(Index) = True) then
     begin
         ListBoxMerChant.Canvas.Font.Color := clRed;
         ListBoxMerChant.Canvas.Font.Size :=10;
         ListBoxMerChant.Canvas.TextRect(Rect, Rect.Left, Rect.Top, ListBoxMerChant.Items[Index]);
     end
   else
       ListBoxMerChant.Canvas.Font.Color := clBlack;
       ListBoxMerChant.Canvas.Font.Size :=10;      
       ListBoxMerChant.Canvas.TextRect(Rect, Rect.Left, Rect.Top, ListBoxMerChant.Items[Index]);
    end;

end;

procedure TfrmConfigMerchant.ListBoxMerChantMeasureItem(
  Control: TWinControl; Index: Integer; var Height: Integer);
begin
     Height :=16;  //ListBox 行高
end;

 
//关闭窗口事件
procedure TfrmConfigMerchant.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  Result : Integer;
begin

    if( bIsNpcChanged = True) then
    begin
       Result := Application.MessageBox('有修NCP数据被修改，是否保存退出吗？','警告',MB_ICONWARNING+MB_YesNo);
       if Result = IDYES then  begin
           ButtonScriptSaveClick(Sender);   //保存
        end   else  begin
            ButtonRecoverClick(Sender);     //恢复
        end;
    end;
end;

end.
