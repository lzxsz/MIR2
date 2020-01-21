object frmFunctionConfig: TfrmFunctionConfig
  Left = 492
  Top = 277
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #21151#33021#35774#32622
  ClientHeight = 362
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object FunctionConfigControl: TPageControl
    Left = 8
    Top = 8
    Width = 457
    Height = 345
    ActivePage = TabSheet1
    MultiLine = True
    TabIndex = 7
    TabOrder = 0
    OnChanging = FunctionConfigControlChanging
    object TabSheetGeneral: TTabSheet
      Caption = #22522#26412#21151#33021
      ImageIndex = 3
      object GroupBox7: TGroupBox
        Left = 304
        Top = 8
        Width = 140
        Height = 185
        Caption = #33021#37327#25511#21046
        TabOrder = 0
        object CheckBoxHungerSystem: TCheckBox
          Left = 8
          Top = 16
          Width = 121
          Height = 17
          Hint = #21551#29992#27492#21151#33021#21518','#20154#29289#24517#39035#23450#26102#21507#39135#29289#20197#20445#25345#33021#37327','#22914#26524#38271#26102#38388#26410#21507#39135#29289','#20154#29289#23558#34987#39295#27515'.'
          Caption = #21551#29992#33021#37327#25511#21046#31995#32479
          TabOrder = 0
          OnClick = CheckBoxHungerSystemClick
        end
        object GroupBoxHunger: TGroupBox
          Left = 8
          Top = 40
          Width = 124
          Height = 65
          Caption = #33021#37327#19981#22815#26102
          TabOrder = 1
          object CheckBoxHungerDecPower: TCheckBox
            Left = 8
            Top = 40
            Width = 113
            Height = 17
            Hint = #20154#29289#30340#25915#20987#21147','#19982#20154#29289#30340#33021#37327#30456#20851','#33021#37327#19981#22815#26102#20154#29289#30340#25915#20987#21147#23558#38543#20043#19979#38477'.'
            Caption = #33258#21160#20943#25915#20987#21147
            TabOrder = 0
            OnClick = CheckBoxHungerDecPowerClick
          end
          object CheckBoxHungerDecHP: TCheckBox
            Left = 8
            Top = 16
            Width = 113
            Height = 17
            Hint = #24403#20154#29289#38271#26102#38388#27809#21507#39135#29289#21518#33021#37327#38477#21040'0'#21518','#23558#24320#22987#33258#21160#20943#23569'HP'#20540','#38477#21040'0'#21518','#20154#29289#27515#20129'.'
            Caption = #33258#21160#20943#29983#21629#20540
            TabOrder = 1
            OnClick = CheckBoxHungerDecHPClick
          end
        end
      end
      object ButtonGeneralSave: TButton
        Left = 368
        Top = 261
        Width = 65
        Height = 25
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonGeneralSaveClick
      end
      object GroupBox34: TGroupBox
        Left = 8
        Top = 8
        Width = 137
        Height = 161
        Caption = #21517#23383#26174#31034#39068#33394
        TabOrder = 2
        object Label85: TLabel
          Left = 11
          Top = 16
          Width = 54
          Height = 12
          Caption = #25915#20987#29366#24577':'
        end
        object LabelPKFlagNameColor: TLabel
          Left = 112
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label87: TLabel
          Left = 11
          Top = 40
          Width = 54
          Height = 12
          Caption = #40644#21517#29366#24577':'
        end
        object LabelPKLevel1NameColor: TLabel
          Left = 112
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label89: TLabel
          Left = 11
          Top = 64
          Width = 54
          Height = 12
          Caption = #32418#21517#29366#24577':'
        end
        object LabelPKLevel2NameColor: TLabel
          Left = 112
          Top = 62
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label91: TLabel
          Left = 11
          Top = 88
          Width = 54
          Height = 12
          Caption = #32852#30431#25112#20105':'
        end
        object LabelAllyAndGuildNameColor: TLabel
          Left = 112
          Top = 86
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label93: TLabel
          Left = 11
          Top = 112
          Width = 54
          Height = 12
          Caption = #25932#23545#25112#20105':'
        end
        object LabelWarGuildNameColor: TLabel
          Left = 112
          Top = 110
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label95: TLabel
          Left = 11
          Top = 136
          Width = 54
          Height = 12
          Caption = #25112#20105#21306#22495':'
        end
        object LabelInFreePKAreaNameColor: TLabel
          Left = 112
          Top = 134
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditPKFlagNameColor: TSpinEdit
          Left = 64
          Top = 12
          Width = 41
          Height = 21
          Hint = #24403#20154#29289#25915#20987#20854#20182#20154#29289#26102#21517#23383#39068#33394','#40664#35748#20026'47'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditPKFlagNameColorChange
        end
        object EditPKLevel1NameColor: TSpinEdit
          Left = 64
          Top = 36
          Width = 41
          Height = 21
          Hint = #24403#20154#29289'PK'#28857#36229#36807'100'#28857#26102#21517#23383#39068#33394','#40664#35748#20026'251'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditPKLevel1NameColorChange
        end
        object EditPKLevel2NameColor: TSpinEdit
          Left = 64
          Top = 60
          Width = 41
          Height = 21
          Hint = #24403#20154#29289'PK'#28857#36229#36807'200'#28857#26102#21517#23383#39068#33394','#40664#35748#20026'249'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditPKLevel2NameColorChange
        end
        object EditAllyAndGuildNameColor: TSpinEdit
          Left = 64
          Top = 84
          Width = 41
          Height = 21
          Hint = #24403#20154#29289#22312#34892#20250#25112#20105#26102','#26412#34892#20250#21450#32852#30431#34892#20250#20154#29289#21517#23383#39068#33394','#40664#35748#20026'180'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditAllyAndGuildNameColorChange
        end
        object EditWarGuildNameColor: TSpinEdit
          Left = 64
          Top = 108
          Width = 41
          Height = 21
          Hint = #24403#20154#29289#22312#34892#20250#25112#20105#26102','#25932#23545#34892#20250#20154#29289#21517#23383#39068#33394','#40664#35748#20026'69'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = EditWarGuildNameColorChange
        end
        object EditInFreePKAreaNameColor: TSpinEdit
          Left = 64
          Top = 132
          Width = 41
          Height = 21
          Hint = #24403#20154#29289#22312#34892#20250#25112#20105#21306#22495#26102#20154#29289#21517#23383#39068#33394','#40664#35748#20026'221'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 5
          Value = 100
          OnChange = EditInFreePKAreaNameColorChange
        end
      end
      object GroupBox51: TGroupBox
        Left = 154
        Top = 8
        Width = 140
        Height = 185
        Caption = #22320#22270#20107#20214#35302#21457
        TabOrder = 3
        object CheckBox1: TCheckBox
          Left = 8
          Top = 32
          Width = 121
          Height = 17
          Caption = #24320#21551#22320#22270#20107#20214#35302#21457
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
      end
    end
    object PasswordSheet: TTabSheet
      Caption = #23494#30721#20445#25252
      ImageIndex = 2
      object GroupBox1: TGroupBox
        Left = 8
        Top = 0
        Width = 433
        Height = 193
        TabOrder = 0
        object CheckBoxEnablePasswordLock: TCheckBox
          Left = 8
          Top = -5
          Width = 121
          Height = 25
          Caption = #21551#29992#23494#30721#20445#25252#31995#32479
          TabOrder = 0
          OnClick = CheckBoxEnablePasswordLockClick
        end
        object GroupBox2: TGroupBox
          Left = 8
          Top = 16
          Width = 265
          Height = 169
          Caption = #38145#23450#25511#21046
          TabOrder = 1
          object CheckBoxLockGetBackItem: TCheckBox
            Left = 8
            Top = 16
            Width = 121
            Height = 17
            Caption = #31105#27490#21462#20179#24211#20179#24211
            TabOrder = 0
            OnClick = CheckBoxLockGetBackItemClick
          end
          object GroupBox4: TGroupBox
            Left = 8
            Top = 40
            Width = 249
            Height = 105
            Caption = #30331#24405#38145#23450
            TabOrder = 1
            object CheckBoxLockWalk: TCheckBox
              Left = 8
              Top = 32
              Width = 105
              Height = 17
              Caption = #31105#27490#36208#36335
              TabOrder = 0
              OnClick = CheckBoxLockWalkClick
            end
            object CheckBoxLockRun: TCheckBox
              Left = 8
              Top = 48
              Width = 105
              Height = 17
              Caption = #31105#27490#36305#27493
              TabOrder = 1
              OnClick = CheckBoxLockRunClick
            end
            object CheckBoxLockHit: TCheckBox
              Left = 8
              Top = 64
              Width = 105
              Height = 17
              Caption = #31105#27490#25915#20987
              TabOrder = 2
              OnClick = CheckBoxLockHitClick
            end
            object CheckBoxLockSpell: TCheckBox
              Left = 8
              Top = 80
              Width = 105
              Height = 17
              Caption = #31105#27490#39764#27861
              TabOrder = 3
              OnClick = CheckBoxLockSpellClick
            end
            object CheckBoxLockSendMsg: TCheckBox
              Left = 120
              Top = 32
              Width = 105
              Height = 17
              Caption = #31105#27490#32842#22825
              TabOrder = 4
              OnClick = CheckBoxLockSendMsgClick
            end
            object CheckBoxLockInObMode: TCheckBox
              Left = 120
              Top = 16
              Width = 121
              Height = 17
              Hint = #22914#26524#26377#23494#30721#20445#25252#26102','#20154#29289#30331#24405#26102#20026#38544#36523#29366#24577','#24618#29289#19981#20250#25915#20987#20154#29289','#22312#36755#20837#23494#30721#24320#38145#21518#24674#22797#27491#24120'.'
              Caption = #38145#23450#26102#20026'('#38544#36523#27169#24335')'
              TabOrder = 5
              OnClick = CheckBoxLockInObModeClick
            end
            object CheckBoxLockLogin: TCheckBox
              Left = 8
              Top = 16
              Width = 105
              Height = 17
              Caption = #38145#23450#20154#29289#30331#24405
              TabOrder = 6
              OnClick = CheckBoxLockLoginClick
            end
            object CheckBoxLockUseItem: TCheckBox
              Left = 120
              Top = 80
              Width = 105
              Height = 17
              Caption = #31105#27490#20351#29992#21697
              TabOrder = 7
              OnClick = CheckBoxLockUseItemClick
            end
            object CheckBoxLockDropItem: TCheckBox
              Left = 120
              Top = 64
              Width = 105
              Height = 17
              Caption = #31105#27490#25172#29289#21697
              TabOrder = 8
              OnClick = CheckBoxLockDropItemClick
            end
            object CheckBoxLockDealItem: TCheckBox
              Left = 120
              Top = 48
              Width = 121
              Height = 17
              Caption = #31105#27490#20132#26131#29289#21697
              TabOrder = 9
              OnClick = CheckBoxLockDealItemClick
            end
          end
        end
        object GroupBox3: TGroupBox
          Left = 280
          Top = 16
          Width = 145
          Height = 65
          Caption = #30721#36755#20837#38169#35823#25511#21046
          TabOrder = 2
          object Label1: TLabel
            Left = 8
            Top = 18
            Width = 54
            Height = 12
            Caption = #38169#35823#27425#25968':'
          end
          object EditErrorPasswordCount: TSpinEdit
            Left = 68
            Top = 15
            Width = 53
            Height = 21
            Hint = #22312#24320#38145#26102#36755#20837#23494#30721','#22914#26524#36755#20837#38169#35823#36229#36807#25351#23450#27425#25968','#21017#38145#23450#23494#30721','#24517#39035#37325#26032#30331#24405#19968#27425#25165#21487#20197#20877#27425#36755#20837#23494#30721'.'
            EditorEnabled = False
            MaxValue = 10
            MinValue = 1
            TabOrder = 0
            Value = 10
            OnChange = EditErrorPasswordCountChange
          end
          object CheckBoxErrorCountKick: TCheckBox
            Left = 8
            Top = 40
            Width = 129
            Height = 17
            Caption = #36229#36807#25351#23450#27425#25968#36386#19979#32447
            Enabled = False
            TabOrder = 1
            OnClick = CheckBoxErrorCountKickClick
          end
        end
        object ButtonPasswordLockSave: TButton
          Left = 360
          Top = 157
          Width = 65
          Height = 25
          Caption = #20445#23384'(&S)'
          TabOrder = 3
          OnClick = ButtonPasswordLockSaveClick
        end
      end
    end
    object TabSheet32: TTabSheet
      Caption = #32467#23130#31995#32479
      ImageIndex = 4
      object GroupBox49: TGroupBox
        Left = 8
        Top = 4
        Width = 185
        Height = 290
        Caption = #22827#22971#21015#34920
        TabOrder = 0
        object ListBox1: TListBox
          Left = 7
          Top = 17
          Width = 170
          Height = 265
          ItemHeight = 12
          TabOrder = 0
        end
      end
      object GroupBox50: TGroupBox
        Left = 200
        Top = 4
        Width = 185
        Height = 290
        Caption = #31163#23130#21015#34920
        TabOrder = 1
        object ListBox2: TListBox
          Left = 8
          Top = 16
          Width = 170
          Height = 265
          ItemHeight = 12
          TabOrder = 0
        end
      end
      object Button1: TButton
        Left = 390
        Top = 268
        Width = 57
        Height = 25
        Caption = #20445#23384'(&S)'
        TabOrder = 2
      end
    end
    object TabSheet33: TTabSheet
      Caption = #24072#24466#31995#32479
      ImageIndex = 5
      object GroupBox21: TGroupBox
        Left = 296
        Top = 16
        Width = 146
        Height = 153
        Caption = #24466#24351#20986#24072
        TabOrder = 0
        object GroupBox22: TGroupBox
          Left = 8
          Top = 16
          Width = 130
          Height = 49
          Caption = #20986#24072#31561#32423
          TabOrder = 0
          object Label29: TLabel
            Left = 8
            Top = 18
            Width = 54
            Height = 12
            Caption = #31561#32423#35201#27714':'
          end
          object EditMasterOKLevel: TSpinEdit
            Left = 68
            Top = 15
            Width = 53
            Height = 21
            Hint = #20986#24072#31561#32423#35774#32622','#20154#29289#22312#25308#24072#21518','#21040#25351#23450#31561#32423#21518#23558#33258#21160#20986#24072'.'
            MaxValue = 65535
            MinValue = 1
            TabOrder = 0
            Value = 10
            OnChange = EditMasterOKLevelChange
          end
        end
        object GroupBox23: TGroupBox
          Left = 8
          Top = 72
          Width = 130
          Height = 73
          Caption = #24072#29238#25152#24471
          TabOrder = 1
          object Label30: TLabel
            Left = 8
            Top = 18
            Width = 54
            Height = 12
            Caption = #22768#26395#28857#25968':'
          end
          object Label31: TLabel
            Left = 8
            Top = 42
            Width = 54
            Height = 12
            Caption = #20998#37197#28857#25968':'
          end
          object EditMasterOKCreditPoint: TSpinEdit
            Left = 68
            Top = 15
            Width = 53
            Height = 21
            Hint = #24466#24351#20986#24072#21518','#24072#29238#24471#21040#30340#22768#26395#28857#25968'.'
            MaxValue = 100
            MinValue = 0
            TabOrder = 0
            Value = 10
            OnChange = EditMasterOKCreditPointChange
          end
          object EditMasterOKBonusPoint: TSpinEdit
            Left = 68
            Top = 39
            Width = 53
            Height = 21
            Hint = #24466#24351#20986#24072#21518','#24072#29238#24471#21040#30340#20998#37197#28857#25968
            MaxValue = 1000
            MinValue = 0
            TabOrder = 1
            Value = 10
            OnChange = EditMasterOKBonusPointChange
          end
        end
      end
      object ButtonMasterSave: TButton
        Left = 376
        Top = 261
        Width = 65
        Height = 25
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonMasterSaveClick
      end
      object GroupBox52: TGroupBox
        Left = 8
        Top = 8
        Width = 280
        Height = 142
        Caption = #20986#24072#21015#34920
        TabOrder = 2
        object ListBox3: TListBox
          Left = 8
          Top = 16
          Width = 263
          Height = 117
          ItemHeight = 12
          TabOrder = 0
        end
      end
      object GroupBox53: TGroupBox
        Left = 8
        Top = 156
        Width = 280
        Height = 142
        Caption = #24378#34892#20986#24072#21015#34920
        TabOrder = 3
        object ListBox4: TListBox
          Left = 8
          Top = 16
          Width = 263
          Height = 117
          ItemHeight = 12
          TabOrder = 0
        end
      end
    end
    object TabSheet38: TTabSheet
      Caption = #36716#29983#31995#32479
      ImageIndex = 9
      object GroupBox29: TGroupBox
        Left = 8
        Top = 8
        Width = 113
        Height = 257
        Caption = #33258#21160#21464#33394
        TabOrder = 0
        object Label56: TLabel
          Left = 11
          Top = 16
          Width = 18
          Height = 12
          Caption = #19968':'
        end
        object LabelReNewNameColor1: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label58: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 12
          Caption = #20108':'
        end
        object LabelReNewNameColor2: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label60: TLabel
          Left = 11
          Top = 64
          Width = 18
          Height = 12
          Caption = #19977':'
        end
        object LabelReNewNameColor3: TLabel
          Left = 88
          Top = 62
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label62: TLabel
          Left = 11
          Top = 88
          Width = 18
          Height = 12
          Caption = #22235':'
        end
        object LabelReNewNameColor4: TLabel
          Left = 88
          Top = 86
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label64: TLabel
          Left = 11
          Top = 112
          Width = 18
          Height = 12
          Caption = #20116':'
        end
        object LabelReNewNameColor5: TLabel
          Left = 88
          Top = 110
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label66: TLabel
          Left = 11
          Top = 136
          Width = 18
          Height = 12
          Caption = #20845':'
        end
        object LabelReNewNameColor6: TLabel
          Left = 88
          Top = 134
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label68: TLabel
          Left = 11
          Top = 160
          Width = 18
          Height = 12
          Caption = #19971':'
        end
        object LabelReNewNameColor7: TLabel
          Left = 88
          Top = 158
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label70: TLabel
          Left = 11
          Top = 184
          Width = 18
          Height = 12
          Caption = #20843':'
        end
        object LabelReNewNameColor8: TLabel
          Left = 88
          Top = 182
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label72: TLabel
          Left = 11
          Top = 208
          Width = 18
          Height = 12
          Caption = #20061':'
        end
        object LabelReNewNameColor9: TLabel
          Left = 88
          Top = 206
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label74: TLabel
          Left = 11
          Top = 232
          Width = 18
          Height = 12
          Caption = #21313':'
        end
        object LabelReNewNameColor10: TLabel
          Left = 88
          Top = 230
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditReNewNameColor1: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditReNewNameColor1Change
        end
        object EditReNewNameColor2: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditReNewNameColor2Change
        end
        object EditReNewNameColor3: TSpinEdit
          Left = 40
          Top = 60
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditReNewNameColor3Change
        end
        object EditReNewNameColor4: TSpinEdit
          Left = 40
          Top = 84
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditReNewNameColor4Change
        end
        object EditReNewNameColor5: TSpinEdit
          Left = 40
          Top = 108
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = EditReNewNameColor5Change
        end
        object EditReNewNameColor6: TSpinEdit
          Left = 40
          Top = 132
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 5
          Value = 100
          OnChange = EditReNewNameColor6Change
        end
        object EditReNewNameColor7: TSpinEdit
          Left = 40
          Top = 156
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 6
          Value = 100
          OnChange = EditReNewNameColor7Change
        end
        object EditReNewNameColor8: TSpinEdit
          Left = 40
          Top = 180
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 7
          Value = 100
          OnChange = EditReNewNameColor8Change
        end
        object EditReNewNameColor9: TSpinEdit
          Left = 40
          Top = 204
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 8
          Value = 100
          OnChange = EditReNewNameColor9Change
        end
        object EditReNewNameColor10: TSpinEdit
          Left = 40
          Top = 228
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 9
          Value = 100
          OnChange = EditReNewNameColor10Change
        end
      end
      object ButtonReNewLevelSave: TButton
        Left = 360
        Top = 157
        Width = 65
        Height = 25
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonReNewLevelSaveClick
      end
      object GroupBox30: TGroupBox
        Left = 128
        Top = 8
        Width = 167
        Height = 65
        Caption = #26159#21542#21517#23383#21464#33394
        TabOrder = 2
        object Label57: TLabel
          Left = 8
          Top = 42
          Width = 30
          Height = 12
          Caption = #38388#38548':'
        end
        object Label59: TLabel
          Left = 83
          Top = 44
          Width = 12
          Height = 12
          Caption = #31186
        end
        object EditReNewNameColorTime: TSpinEdit
          Left = 44
          Top = 39
          Width = 37
          Height = 21
          Hint = #20986#24072#31561#32423#35774#32622','#20154#29289#22312#25308#24072#21518','#21040#25351#23450#31561#32423#21518#23558#33258#21160#20986#24072'.'
          EditorEnabled = False
          MaxValue = 10
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditReNewNameColorTimeChange
        end
        object CheckBoxReNewChangeColor: TCheckBox
          Left = 8
          Top = 16
          Width = 89
          Height = 17
          Hint = #25171#24320#27492#21151#33021#21518','#36716#29983#30340#20154#29289#30340#21517#23383#39068#33394#20250#33258#21160#21464#21270'.'
          Caption = #33258#21160#21464#33394
          TabOrder = 1
          OnClick = CheckBoxReNewChangeColorClick
        end
      end
      object GroupBox33: TGroupBox
        Left = 128
        Top = 80
        Width = 167
        Height = 41
        Caption = #36716#29983#25511#21046
        TabOrder = 3
        object CheckBoxReNewLevelClearExp: TCheckBox
          Left = 8
          Top = 16
          Width = 146
          Height = 17
          Hint = #36716#29983#26102#26159#21542#28165#38500#24050#32463#26377#30340#32463#39564#20540'.'
          Caption = #28165#38500#24050#26377#32463#39564
          TabOrder = 0
          OnClick = CheckBoxReNewLevelClearExpClick
        end
      end
    end
    object TabSheet39: TTabSheet
      Caption = #23453#23453#21319#32423
      ImageIndex = 10
      object ButtonMonUpgradeSave: TButton
        Left = 360
        Top = 261
        Width = 65
        Height = 25
        Caption = #20445#23384'(&S)'
        TabOrder = 0
        OnClick = ButtonMonUpgradeSaveClick
      end
      object GroupBox32: TGroupBox
        Left = 8
        Top = 8
        Width = 113
        Height = 233
        Caption = #31561#32423#39068#33394
        TabOrder = 1
        object Label65: TLabel
          Left = 11
          Top = 16
          Width = 18
          Height = 12
          Caption = #19968':'
        end
        object LabelMonUpgradeColor1: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label67: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 12
          Caption = #20108':'
        end
        object LabelMonUpgradeColor2: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label69: TLabel
          Left = 11
          Top = 64
          Width = 18
          Height = 12
          Caption = #19977':'
        end
        object LabelMonUpgradeColor3: TLabel
          Left = 88
          Top = 62
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label71: TLabel
          Left = 11
          Top = 88
          Width = 18
          Height = 12
          Caption = #22235':'
        end
        object LabelMonUpgradeColor4: TLabel
          Left = 88
          Top = 86
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label73: TLabel
          Left = 11
          Top = 112
          Width = 18
          Height = 12
          Caption = #20116':'
        end
        object LabelMonUpgradeColor5: TLabel
          Left = 88
          Top = 110
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label75: TLabel
          Left = 11
          Top = 136
          Width = 18
          Height = 12
          Caption = #20845':'
        end
        object LabelMonUpgradeColor6: TLabel
          Left = 88
          Top = 134
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label76: TLabel
          Left = 11
          Top = 160
          Width = 18
          Height = 12
          Caption = #19971':'
        end
        object LabelMonUpgradeColor7: TLabel
          Left = 88
          Top = 158
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label77: TLabel
          Left = 11
          Top = 184
          Width = 18
          Height = 12
          Caption = #20843':'
        end
        object LabelMonUpgradeColor8: TLabel
          Left = 88
          Top = 182
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label86: TLabel
          Left = 11
          Top = 208
          Width = 18
          Height = 12
          Caption = #20061':'
        end
        object LabelMonUpgradeColor9: TLabel
          Left = 88
          Top = 206
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditMonUpgradeColor1: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditMonUpgradeColor1Change
        end
        object EditMonUpgradeColor2: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditMonUpgradeColor2Change
        end
        object EditMonUpgradeColor3: TSpinEdit
          Left = 40
          Top = 60
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditMonUpgradeColor3Change
        end
        object EditMonUpgradeColor4: TSpinEdit
          Left = 40
          Top = 84
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditMonUpgradeColor4Change
        end
        object EditMonUpgradeColor5: TSpinEdit
          Left = 40
          Top = 108
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = EditMonUpgradeColor5Change
        end
        object EditMonUpgradeColor6: TSpinEdit
          Left = 40
          Top = 132
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 5
          Value = 100
          OnChange = EditMonUpgradeColor6Change
        end
        object EditMonUpgradeColor7: TSpinEdit
          Left = 40
          Top = 156
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 6
          Value = 100
          OnChange = EditMonUpgradeColor7Change
        end
        object EditMonUpgradeColor8: TSpinEdit
          Left = 40
          Top = 180
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 7
          Value = 100
          OnChange = EditMonUpgradeColor8Change
        end
        object EditMonUpgradeColor9: TSpinEdit
          Left = 40
          Top = 204
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 8
          Value = 100
          OnChange = EditMonUpgradeColor9Change
        end
      end
      object GroupBox31: TGroupBox
        Left = 128
        Top = 8
        Width = 97
        Height = 233
        Caption = #21319#32423#26432#24618#25968
        TabOrder = 2
        object Label61: TLabel
          Left = 11
          Top = 16
          Width = 18
          Height = 12
          Caption = #19968':'
        end
        object Label63: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 12
          Caption = #20108':'
        end
        object Label78: TLabel
          Left = 11
          Top = 64
          Width = 18
          Height = 12
          Caption = #19977':'
        end
        object Label79: TLabel
          Left = 11
          Top = 88
          Width = 18
          Height = 12
          Caption = #22235':'
        end
        object Label80: TLabel
          Left = 11
          Top = 112
          Width = 18
          Height = 12
          Caption = #20116':'
        end
        object Label81: TLabel
          Left = 11
          Top = 136
          Width = 18
          Height = 12
          Caption = #20845':'
        end
        object Label82: TLabel
          Left = 11
          Top = 160
          Width = 18
          Height = 12
          Caption = #19971':'
        end
        object Label83: TLabel
          Left = 11
          Top = 184
          Width = 18
          Height = 12
          Caption = #20843':'
        end
        object Label84: TLabel
          Left = 11
          Top = 208
          Width = 18
          Height = 12
          Caption = #20061':'
        end
        object EditMonUpgradeKillCount1: TSpinEdit
          Left = 40
          Top = 12
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditMonUpgradeKillCount1Change
        end
        object EditMonUpgradeKillCount2: TSpinEdit
          Left = 40
          Top = 36
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditMonUpgradeKillCount2Change
        end
        object EditMonUpgradeKillCount3: TSpinEdit
          Left = 40
          Top = 60
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditMonUpgradeKillCount3Change
        end
        object EditMonUpgradeKillCount4: TSpinEdit
          Left = 40
          Top = 84
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditMonUpgradeKillCount4Change
        end
        object EditMonUpgradeKillCount5: TSpinEdit
          Left = 40
          Top = 108
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = EditMonUpgradeKillCount5Change
        end
        object EditMonUpgradeKillCount6: TSpinEdit
          Left = 40
          Top = 132
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 5
          Value = 100
          OnChange = EditMonUpgradeKillCount6Change
        end
        object EditMonUpgradeKillCount7: TSpinEdit
          Left = 40
          Top = 156
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 6
          Value = 100
          OnChange = EditMonUpgradeKillCount7Change
        end
        object EditMonUpLvNeedKillBase: TSpinEdit
          Left = 40
          Top = 180
          Width = 49
          Height = 21
          Hint = #26432#24618#25968#37327'='#31561#32423' * '#20493#29575' + '#31561#32423' + '#22522#25968' + '#27599#32423#25968#37327
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 7
          Value = 100
          OnChange = EditMonUpLvNeedKillBaseChange
        end
        object EditMonUpLvRate: TSpinEdit
          Left = 40
          Top = 204
          Width = 49
          Height = 21
          Hint = #26432#24618#25968#37327'='#24618#29289#31561#32423' * '#20493#29575' + '#31561#32423' + '#22522#25968' + '#27599#32423#25968#37327
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 8
          Value = 100
          OnChange = EditMonUpLvRateChange
        end
      end
      object GroupBox35: TGroupBox
        Left = 232
        Top = 8
        Width = 137
        Height = 113
        Caption = #20027#20154#27515#20129#25511#21046
        TabOrder = 3
        object Label88: TLabel
          Left = 11
          Top = 40
          Width = 54
          Height = 12
          Caption = #21464#24322#26426#29575':'
        end
        object Label90: TLabel
          Left = 11
          Top = 64
          Width = 54
          Height = 12
          Caption = #22686#21152#25915#20987':'
        end
        object Label92: TLabel
          Left = 11
          Top = 88
          Width = 54
          Height = 12
          Caption = #22686#21152#36895#24230':'
        end
        object CheckBoxMasterDieMutiny: TCheckBox
          Left = 8
          Top = 16
          Width = 113
          Height = 17
          Caption = #20027#20154#27515#20129#21518#21464#24322
          TabOrder = 0
          OnClick = CheckBoxMasterDieMutinyClick
        end
        object EditMasterDieMutinyRate: TSpinEdit
          Left = 72
          Top = 36
          Width = 49
          Height = 21
          Hint = #25968#23383#36234#23567','#21464#24322#26426#29575#36234#22823'.'
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditMasterDieMutinyRateChange
        end
        object EditMasterDieMutinyPower: TSpinEdit
          Left = 72
          Top = 60
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditMasterDieMutinyPowerChange
        end
        object EditMasterDieMutinySpeed: TSpinEdit
          Left = 72
          Top = 84
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditMasterDieMutinySpeedChange
        end
      end
      object GroupBox47: TGroupBox
        Left = 232
        Top = 128
        Width = 137
        Height = 73
        Caption = #19971#24425#23453#23453
        TabOrder = 4
        object Label112: TLabel
          Left = 11
          Top = 40
          Width = 54
          Height = 12
          Caption = #26102#38388#38388#38548':'
        end
        object CheckBoxBBMonAutoChangeColor: TCheckBox
          Left = 8
          Top = 16
          Width = 121
          Height = 17
          Caption = #23453#23453#33258#21160#21464#33394
          TabOrder = 0
          OnClick = CheckBoxBBMonAutoChangeColorClick
        end
        object EditBBMonAutoChangeColorTime: TSpinEdit
          Left = 72
          Top = 36
          Width = 49
          Height = 21
          Hint = #25968#23383#36234#23567','#21464#33394#36895#24230#36234#24555','#21333#20301'('#31186').'
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 1
          TabOrder = 1
          Value = 100
          OnChange = EditBBMonAutoChangeColorTimeChange
        end
      end
    end
    object MonSaySheet: TTabSheet
      Caption = #24618#29289#35828#35805
      object GroupBox40: TGroupBox
        Left = 8
        Top = 8
        Width = 137
        Height = 49
        Caption = #24618#29289#35828#35805
        TabOrder = 0
        object CheckBoxMonSayMsg: TCheckBox
          Left = 8
          Top = 16
          Width = 113
          Height = 17
          Caption = #24320#21551#24618#29289#35828#35805
          TabOrder = 0
          OnClick = CheckBoxMonSayMsgClick
        end
      end
      object ButtonMonSayMsgSave: TButton
        Left = 376
        Top = 277
        Width = 65
        Height = 20
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonMonSayMsgSaveClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = #25216#33021#39764#27861
      ImageIndex = 1
      object MagicPageControl: TPageControl
        Left = 0
        Top = 0
        Width = 449
        Height = 273
        ActivePage = TabSheet18
        MultiLine = True
        TabIndex = 11
        TabOrder = 0
        TabPosition = tpBottom
        object TabSheet36: TTabSheet
          Caption = #25216#33021#21442#25968
          ImageIndex = 31
          object GroupBox17: TGroupBox
            Left = 8
            Top = 8
            Width = 145
            Height = 49
            Caption = #39764#27861#25915#20987#33539#22260#38480#21046
            TabOrder = 0
            object Label12: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #33539#22260#22823#23567':'
            end
            object EditMagicAttackRage: TSpinEdit
              Left = 68
              Top = 15
              Width = 53
              Height = 21
              Hint = #39764#27861#25915#20987#26377#25928#36317#31163','#36229#36807#25351#23450#36317#31163#25915#20987#26080#25928'.'
              EditorEnabled = False
              MaxValue = 20
              MinValue = 1
              TabOrder = 0
              Value = 10
              OnChange = EditMagicAttackRageChange
            end
          end
        end
        object TabSheet30: TTabSheet
          Caption = #25915#26432#21073#27861
          ImageIndex = 29
        end
        object TabSheet11: TTabSheet
          Caption = #21050#26432#21073#27861
          ImageIndex = 10
          object GroupBox9: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 41
            Caption = #26080#38480#21050#26432
            TabOrder = 0
            object CheckBoxLimitSwordLong: TCheckBox
              Left = 8
              Top = 16
              Width = 97
              Height = 17
              Hint = #25171#24320#27492#21151#33021#21518','#23558#26816#26597#26816#26597#38548#20301#26159#21542#26377#35282#33394#23384#22312','#20197#31105#27490#20992#20992#21050#26432'.'
              Caption = #31105#27490#26080#38480#21050#26432
              TabOrder = 0
              OnClick = CheckBoxLimitSwordLongClick
            end
          end
          object GroupBox10: TGroupBox
            Left = 8
            Top = 56
            Width = 129
            Height = 41
            Caption = #25915#20987#21147#20493#25968
            TabOrder = 1
            object Label4: TLabel
              Left = 8
              Top = 20
              Width = 30
              Height = 12
              Caption = #20493#25968':'
            end
            object Label10: TLabel
              Left = 96
              Top = 20
              Width = 24
              Height = 12
              Caption = '/100'
            end
            object EditSwordLongPowerRate: TSpinEdit
              Left = 44
              Top = 15
              Width = 45
              Height = 21
              Hint = #25915#20987#21147#20493#25968','#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968'.'
              EditorEnabled = False
              MaxValue = 1000
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditSwordLongPowerRateChange
            end
          end
        end
        object TabSheet23: TTabSheet
          Caption = #21322#26376#24367#20992
          ImageIndex = 22
        end
        object FiresWordTab: TTabSheet
          Caption = #28872#28779#21073#27861
        end
        object TabSheet24: TTabSheet
          Caption = #37326#34542#20914#25758
          ImageIndex = 23
        end
        object TabSheet2: TTabSheet
          Caption = #28779#29699#26415
          ImageIndex = 7
        end
        object TabSheet7: TTabSheet
          Caption = #25239#25298#28779#29615
          ImageIndex = 5
        end
        object TabSheet8: TTabSheet
          Caption = #22320#29425#28779
          ImageIndex = 6
        end
        object TabSheet9: TTabSheet
          Caption = #30142#20809#30005#24433
          ImageIndex = 8
        end
        object TabSheet10: TTabSheet
          Caption = #38647#30005#26415
          ImageIndex = 9
        end
        object TabSheet18: TTabSheet
          Caption = #35825#24785#20043#20809
          ImageIndex = 17
          object GroupBox38: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 41
            Caption = #24618#29289#31561#32423#38480#21046
            TabOrder = 0
            object Label98: TLabel
              Left = 8
              Top = 20
              Width = 30
              Height = 12
              Caption = #31561#32423':'
            end
            object EditMagTammingLevel: TSpinEdit
              Left = 44
              Top = 15
              Width = 61
              Height = 21
              Hint = #25351#23450#31561#32423#20197#19979#30340#24618#29289#25165#20250#34987#35825#24785','#25351#23450#31561#32423#20197#19978#30340#24618#29289#35825#24785#26080#25928'.'
              MaxValue = 65535
              MinValue = 1
              TabOrder = 0
              Value = 1
              OnChange = EditMagTammingLevelChange
            end
          end
          object GroupBox39: TGroupBox
            Left = 8
            Top = 56
            Width = 129
            Height = 73
            TabOrder = 1
            object Label99: TLabel
              Left = 8
              Top = 20
              Width = 54
              Height = 12
              Caption = #24618#29289#31561#32423':'
            end
            object Label100: TLabel
              Left = 8
              Top = 44
              Width = 54
              Height = 12
              Caption = #24618#29289#34880#37327':'
            end
            object EditMagTammingTargetLevel: TSpinEdit
              Left = 64
              Top = 15
              Width = 57
              Height = 21
              Hint = #24618#29289#31561#32423#27604#29575','#27492#25968#23383#36234#23567#26426#29575#36234#22823'.'
              MaxValue = 65535
              MinValue = 1
              TabOrder = 0
              Value = 1
              OnChange = EditMagTammingTargetLevelChange
            end
            object EditMagTammingHPRate: TSpinEdit
              Left = 64
              Top = 39
              Width = 57
              Height = 21
              Hint = #24618#29289#34880#37327#27604#29575','#27492#25968#23383#36234#22823','#26426#29575#36234#22823'.'
              MaxValue = 65535
              MinValue = 1
              TabOrder = 1
              Value = 1
              OnChange = EditMagTammingHPRateChange
            end
          end
          object GroupBox45: TGroupBox
            Left = 128
            Top = 8
            Width = 113
            Height = 41
            Caption = #35825#24785#25968#37327
            TabOrder = 2
            object Label111: TLabel
              Left = 8
              Top = 20
              Width = 30
              Height = 12
              Caption = #25968#37327':'
            end
            object EditTammingCount: TSpinEdit
              Left = 44
              Top = 15
              Width = 61
              Height = 21
              Hint = #21487#35825#24785#24618#29289#25968#37327'.'
              MaxValue = 65535
              MinValue = 1
              TabOrder = 0
              Value = 1
              OnChange = EditTammingCountChange
            end
          end
        end
        object TabSheet19: TTabSheet
          Caption = #30636#24687#31227#21160
          ImageIndex = 18
        end
        object TabSheet20: TTabSheet
          Caption = #28779#22681
          ImageIndex = 19
          object GroupBox46: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 41
            Caption = #23433#20840#21306#31105#27490#28779#22681
            TabOrder = 0
            object CheckBoxFireCrossInSafeZone: TCheckBox
              Left = 8
              Top = 16
              Width = 97
              Height = 17
              Hint = #25171#24320#27492#21151#33021#21518','#22312#23433#20840#21306#19981#20801#35768#25918#28779#22681'.'
              TabOrder = 0
              OnClick = CheckBoxFireCrossInSafeZoneClick
            end
          end
        end
        object TabSheet27: TTabSheet
          Caption = #39764#27861#30462
          ImageIndex = 26
        end
        object TabSheet28: TTabSheet
          Caption = #22307#35328#26415
          ImageIndex = 27
          object GroupBox37: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 41
            Caption = #24618#29289#31561#32423#38480#21046
            TabOrder = 0
            object Label97: TLabel
              Left = 8
              Top = 20
              Width = 30
              Height = 12
              Caption = #31561#32423':'
            end
            object EditMagTurnUndeadLevel: TSpinEdit
              Left = 44
              Top = 15
              Width = 61
              Height = 21
              Hint = #25351#23450#31561#32423#20197#19979#30340#24618#29289#25165#20250#34987#22307#35328','#25351#23450#31561#32423#20197#19978#30340#24618#29289#22307#35328#26080#25928'.'
              EditorEnabled = False
              MaxValue = 65535
              MinValue = 1
              TabOrder = 0
              Value = 1
              OnChange = EditMagTurnUndeadLevelChange
            end
          end
        end
        object TabSheet22: TTabSheet
          Caption = #22320#29425#38647#20809
          ImageIndex = 21
          object GroupBox15: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 41
            Caption = #25915#20987#33539#22260
            TabOrder = 0
            object Label9: TLabel
              Left = 8
              Top = 20
              Width = 30
              Height = 12
              Caption = #33539#22260':'
            end
            object EditElecBlizzardRange: TSpinEdit
              Left = 44
              Top = 15
              Width = 61
              Height = 21
              Hint = #39764#27861#25915#20987#33539#22260#21322#24452'.'
              EditorEnabled = False
              MaxValue = 12
              MinValue = 1
              TabOrder = 0
              Value = 1
              OnChange = EditElecBlizzardRangeChange
            end
          end
        end
        object TabSheet21: TTabSheet
          Caption = #29190#35010#28779#28976
          ImageIndex = 20
          object GroupBox13: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 41
            Caption = #25915#20987#33539#22260
            TabOrder = 0
            object Label7: TLabel
              Left = 8
              Top = 20
              Width = 30
              Height = 12
              Caption = #33539#22260':'
            end
            object EditFireBoomRage: TSpinEdit
              Left = 44
              Top = 15
              Width = 61
              Height = 21
              Hint = #39764#27861#25915#20987#33539#22260#21322#24452
              EditorEnabled = False
              MaxValue = 12
              MinValue = 1
              TabOrder = 0
              Value = 1
              OnChange = EditFireBoomRageChange
            end
          end
        end
        object TabSheet29: TTabSheet
          Caption = #20912#21638#21742
          ImageIndex = 28
          object GroupBox14: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 41
            Caption = #25915#20987#33539#22260
            TabOrder = 0
            object Label8: TLabel
              Left = 8
              Top = 20
              Width = 30
              Height = 12
              Caption = #33539#22260':'
            end
            object EditSnowWindRange: TSpinEdit
              Left = 44
              Top = 15
              Width = 61
              Height = 21
              Hint = #39764#27861#25915#20987#33539#22260#21322#24452'.'
              EditorEnabled = False
              MaxValue = 12
              MinValue = 1
              TabOrder = 0
              Value = 1
              OnChange = EditSnowWindRangeChange
            end
          end
        end
        object TabSheet5: TTabSheet
          Caption = #27835#24840#26415
          ImageIndex = 3
        end
        object TabSheet26: TTabSheet
          Caption = #32676#20307#27835#24840#26415
          ImageIndex = 25
        end
        object TabSheet6: TTabSheet
          Caption = #26045#27602#26415
          ImageIndex = 4
          object GroupBox16: TGroupBox
            Left = 8
            Top = 8
            Width = 137
            Height = 49
            Caption = #27602#33647#38477#28857
            TabOrder = 0
            object Label11: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #28857#25968#25511#21046':'
            end
            object EditAmyOunsulPoint: TSpinEdit
              Left = 68
              Top = 15
              Width = 53
              Height = 24
              Hint = #20013#27602#21518#25351#23450#26102#38388#20869#38477#28857#25968','#23454#38469#28857#25968#36319#25216#33021#31561#32423#21450#26412#36523#36947#26415#39640#20302#26377#20851','#27492#21442#25968#21482#26159#35843#20854#20013#31639#27861#21442#25968','#27492#25968#23383#36234#23567','#28857#25968#36234#22823'.'
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 10
              OnChange = EditAmyOunsulPointChange
            end
          end
        end
        object TabSheet31: TTabSheet
          Caption = #32676#20307#26045#27602#26415
          ImageIndex = 30
        end
        object TabSheet12: TTabSheet
          Caption = #28789#39746#28779#31526
          ImageIndex = 11
        end
        object TabSheet13: TTabSheet
          Caption = #24189#28789#30462
          ImageIndex = 12
        end
        object TabSheet14: TTabSheet
          Caption = #31070#22307#25112#30002#26415
          ImageIndex = 13
        end
        object TabSheet15: TTabSheet
          Caption = #25414#39764#21650
          ImageIndex = 14
        end
        object TabSheet16: TTabSheet
          Caption = #38544#36523#26415
          ImageIndex = 15
        end
        object TabSheet17: TTabSheet
          Caption = #38598#20307#38544#36523#26415
          ImageIndex = 16
        end
        object TabSheet3: TTabSheet
          Caption = #21484#21796#39607#39621
          ImageIndex = 1
          object GroupBox5: TGroupBox
            Left = 5
            Top = 2
            Width = 132
            Height = 135
            TabOrder = 0
            object Label2: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #24618#29289#21517#31216':'
            end
            object Label3: TLabel
              Left = 8
              Top = 58
              Width = 54
              Height = 12
              Caption = #21484#21796#25968#37327':'
            end
            object EditBoneFammName: TEdit
              Left = 8
              Top = 32
              Width = 105
              Height = 23
              Hint = #35774#32622#40664#35748#21484#21796#30340#24618#29289#21517#31216'.'
              TabOrder = 0
              OnChange = EditBoneFammNameChange
            end
            object EditBoneFammCount: TSpinEdit
              Left = 60
              Top = 55
              Width = 53
              Height = 24
              Hint = #35774#32622#21487#21484#21796#26368#22823#25968#37327'.'
              EditorEnabled = False
              MaxValue = 255
              MinValue = 1
              TabOrder = 1
              Value = 10
              OnChange = EditBoneFammCountChange
            end
          end
          object GroupBox6: TGroupBox
            Left = 144
            Top = 2
            Width = 289
            Height = 135
            TabOrder = 1
            object GridBoneFamm: TStringGrid
              Left = 8
              Top = 16
              Width = 265
              Height = 113
              ColCount = 4
              DefaultRowHeight = 18
              FixedCols = 0
              RowCount = 11
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
              TabOrder = 0
              OnSetEditText = GridBoneFammSetEditText
              ColWidths = (
                55
                76
                57
                52)
            end
          end
        end
        object TabSheet4: TTabSheet
          Caption = #21484#21796#31070#20861
          ImageIndex = 2
          object GroupBox11: TGroupBox
            Left = 5
            Top = 2
            Width = 132
            Height = 135
            TabOrder = 0
            object Label5: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #24618#29289#21517#31216':'
            end
            object Label6: TLabel
              Left = 8
              Top = 58
              Width = 54
              Height = 12
              Caption = #21484#21796#25968#37327':'
            end
            object EditDogzName: TEdit
              Left = 8
              Top = 32
              Width = 105
              Height = 23
              Hint = #35774#32622#40664#35748#21484#21796#30340#24618#29289#21517#31216'.'
              TabOrder = 0
              OnChange = EditDogzNameChange
            end
            object EditDogzCount: TSpinEdit
              Left = 60
              Top = 55
              Width = 53
              Height = 24
              Hint = #35774#32622#21487#21484#21796#26368#22823#25968#37327'.'
              EditorEnabled = False
              MaxValue = 255
              MinValue = 1
              TabOrder = 1
              Value = 10
              OnChange = EditDogzCountChange
            end
          end
          object GroupBox12: TGroupBox
            Left = 144
            Top = 2
            Width = 289
            Height = 135
            TabOrder = 1
            object GridDogz: TStringGrid
              Left = 8
              Top = 16
              Width = 265
              Height = 113
              ColCount = 4
              DefaultRowHeight = 18
              FixedCols = 0
              RowCount = 11
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
              TabOrder = 0
              OnSetEditText = GridBoneFammSetEditText
              ColWidths = (
                55
                76
                57
                52)
            end
          end
        end
        object TabSheet25: TTabSheet
          Caption = #24515#28789#21551#31034
          ImageIndex = 24
        end
        object TabSheet41: TTabSheet
          Caption = #28779#28976#20912
          ImageIndex = 32
          object GroupBox41: TGroupBox
            Left = 8
            Top = 8
            Width = 145
            Height = 73
            TabOrder = 0
            object Label101: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #30456#24046#26426#29575':'
            end
            object Label102: TLabel
              Left = 8
              Top = 42
              Width = 54
              Height = 12
              Caption = #30456#24046#38480#21046':'
            end
            object EditMabMabeHitRandRate: TSpinEdit
              Left = 68
              Top = 15
              Width = 53
              Height = 24
              Hint = #25915#20987#34987#25915#20987#21452#26041#30456#24046#31561#32423#21629#20013#26426#29575','#26368#23567#38480#21046'.'#25968#23383#36234#23567#26426#29575#36234#20302'.'
              EditorEnabled = False
              MaxValue = 20
              MinValue = 1
              TabOrder = 0
              Value = 10
              OnChange = EditMabMabeHitRandRateChange
            end
            object EditMabMabeHitMinLvLimit: TSpinEdit
              Left = 68
              Top = 39
              Width = 53
              Height = 24
              Hint = #25915#20987#40635#30201#26426#29575','#26368#23567#38480#21046','#25968#23383#36234#23567#26426#29575#36234#20302'.'
              EditorEnabled = False
              MaxValue = 20
              MinValue = 1
              TabOrder = 1
              Value = 10
              OnChange = EditMabMabeHitMinLvLimitChange
            end
          end
          object GroupBox42: TGroupBox
            Left = 8
            Top = 88
            Width = 145
            Height = 49
            Caption = #40635#30201#21629#20013#26426#29575
            TabOrder = 1
            object Label103: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #21629#20013#26426#29575':'
            end
            object EditMabMabeHitSucessRate: TSpinEdit
              Left = 68
              Top = 15
              Width = 53
              Height = 24
              Hint = #40635#30201#26102#38388#38271#24230#20493#29575','#22522#25968#19982#35282#33394#30340#39764#27861#26377#20851
              EditorEnabled = False
              MaxValue = 20
              MinValue = 1
              TabOrder = 0
              Value = 10
              OnChange = EditMabMabeHitSucessRateChange
            end
          end
          object GroupBox43: TGroupBox
            Left = 160
            Top = 8
            Width = 145
            Height = 49
            Caption = #40635#30201#26102#38388#21442#25968#20493#29575
            TabOrder = 2
            object Label104: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #21629#20013#26426#29575':'
            end
            object EditMabMabeHitMabeTimeRate: TSpinEdit
              Left = 68
              Top = 15
              Width = 53
              Height = 24
              Hint = #40635#30201#26102#38388#38271#24230#20493#29575','#22522#25968#19982#35282#33394#30340#39764#27861#26377#20851'.'
              EditorEnabled = False
              MaxValue = 20
              MinValue = 1
              TabOrder = 0
              Value = 10
              OnChange = EditMabMabeHitMabeTimeRateChange
            end
          end
        end
        object TabSheet43: TTabSheet
          Caption = #29422#23376#21564
          ImageIndex = 33
          object GroupBox48: TGroupBox
            Left = 8
            Top = 8
            Width = 115
            Height = 66
            TabOrder = 0
            object Label118: TLabel
              Left = 8
              Top = 0
              Width = 24
              Height = 12
              Caption = #20316#29992
            end
            object CheckBoxGroupMbAttackPlayObject: TCheckBox
              Left = 8
              Top = 16
              Width = 97
              Height = 17
              Hint = #25171#24320#27492#21151#33021#21518','#23601#21487#20197#40635#30201#20154#29289
              Caption = #20801#35768#40635#30201#20154#29289
              TabOrder = 0
              OnClick = CheckBoxGroupMbAttackPlayObjectClick
            end
            object CheckBoxGroupMbAttackbaobao: TCheckBox
              Left = 8
              Top = 40
              Width = 97
              Height = 17
              Caption = #20801#35768#40635#30201#23453#23453
              TabOrder = 1
              OnClick = CheckBoxGroupMbAttackbaobaoClick
            end
          end
        end
      end
      object ButtonSkillSave: TButton
        Left = 376
        Top = 277
        Width = 65
        Height = 20
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonSkillSaveClick
      end
    end
    object TabSheet34: TTabSheet
      Caption = #21319#32423#27494#22120
      ImageIndex = 6
      object GroupBox8: TGroupBox
        Left = 8
        Top = 8
        Width = 161
        Height = 121
        Caption = #22522#26412#35774#32622
        TabOrder = 0
        object Label13: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #26368#39640#28857#25968':'
        end
        object Label15: TLabel
          Left = 8
          Top = 42
          Width = 54
          Height = 12
          Caption = #25152#38656#36153#29992':'
        end
        object Label16: TLabel
          Left = 8
          Top = 66
          Width = 54
          Height = 12
          Caption = #25152#38656#26102#38388':'
        end
        object Label17: TLabel
          Left = 8
          Top = 90
          Width = 54
          Height = 12
          Caption = #36807#26399#26102#38388':'
        end
        object Label18: TLabel
          Left = 136
          Top = 65
          Width = 12
          Height = 12
          Caption = #31186
        end
        object Label19: TLabel
          Left = 136
          Top = 89
          Width = 12
          Height = 12
          Caption = #22825
        end
        object EditUpgradeWeaponMaxPoint: TSpinEdit
          Left = 68
          Top = 15
          Width = 61
          Height = 21
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditUpgradeWeaponMaxPointChange
        end
        object EditUpgradeWeaponPrice: TSpinEdit
          Left = 68
          Top = 39
          Width = 61
          Height = 21
          EditorEnabled = False
          MaxValue = 1000000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditUpgradeWeaponPriceChange
        end
        object EditUPgradeWeaponGetBackTime: TSpinEdit
          Left = 68
          Top = 63
          Width = 61
          Height = 21
          EditorEnabled = False
          MaxValue = 36000000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditUPgradeWeaponGetBackTimeChange
        end
        object EditClearExpireUpgradeWeaponDays: TSpinEdit
          Left = 68
          Top = 87
          Width = 61
          Height = 21
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 3
          Value = 10
          OnChange = EditClearExpireUpgradeWeaponDaysChange
        end
      end
      object GroupBox18: TGroupBox
        Left = 176
        Top = 8
        Width = 265
        Height = 89
        Caption = #25915#20987#21147#21319#32423
        TabOrder = 1
        object Label20: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #25104#21151#26426#29575':'
        end
        object Label21: TLabel
          Left = 8
          Top = 42
          Width = 54
          Height = 12
          Caption = #20108#28857#26426#29575':'
        end
        object Label22: TLabel
          Left = 8
          Top = 66
          Width = 54
          Height = 12
          Caption = #19977#28857#26426#29575':'
        end
        object ScrollBarUpgradeWeaponDCRate: TScrollBar
          Left = 64
          Top = 16
          Width = 145
          Height = 17
          Hint = #21319#32423#25915#20987#21147#28857#25968#25104#21151#26426#29575','#26426#29575#20026#24038#22823#21491#23567'.'
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarUpgradeWeaponDCRateChange
        end
        object EditUpgradeWeaponDCRate: TEdit
          Left = 216
          Top = 16
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarUpgradeWeaponDCTwoPointRate: TScrollBar
          Left = 64
          Top = 40
          Width = 145
          Height = 17
          Hint = #24471#21040#20108#28857#23646#24615#26426#29575','#26426#29575#20026#24038#22823#21491#23567'.'
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarUpgradeWeaponDCTwoPointRateChange
        end
        object EditUpgradeWeaponDCTwoPointRate: TEdit
          Left = 216
          Top = 40
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarUpgradeWeaponDCThreePointRate: TScrollBar
          Left = 64
          Top = 64
          Width = 145
          Height = 17
          Hint = #24471#21040#19977#28857#23646#24615#26426#29575','#26426#29575#20026#24038#22823#21491#23567'.'
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarUpgradeWeaponDCThreePointRateChange
        end
        object EditUpgradeWeaponDCThreePointRate: TEdit
          Left = 216
          Top = 64
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
      end
      object GroupBox19: TGroupBox
        Left = 176
        Top = 104
        Width = 265
        Height = 97
        Caption = #36947#26415#21319#32423
        TabOrder = 2
        object Label23: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #25104#21151#26426#29575':'
        end
        object Label24: TLabel
          Left = 8
          Top = 42
          Width = 54
          Height = 12
          Caption = #20108#28857#26426#29575':'
        end
        object Label25: TLabel
          Left = 8
          Top = 66
          Width = 54
          Height = 12
          Caption = #19977#28857#26426#29575':'
        end
        object ScrollBarUpgradeWeaponSCRate: TScrollBar
          Left = 64
          Top = 16
          Width = 145
          Height = 17
          Hint = #21319#32423#36947#26415#28857#25968#25104#21151#26426#29575','#26426#29575#20026#24038#22823#21491#23567'.'
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarUpgradeWeaponSCRateChange
        end
        object EditUpgradeWeaponSCRate: TEdit
          Left = 216
          Top = 16
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarUpgradeWeaponSCTwoPointRate: TScrollBar
          Left = 64
          Top = 40
          Width = 145
          Height = 17
          Hint = #24471#21040#20108#28857#23646#24615#26426#29575','#26426#29575#20026#24038#22823#21491#23567'.'
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarUpgradeWeaponSCTwoPointRateChange
        end
        object EditUpgradeWeaponSCTwoPointRate: TEdit
          Left = 216
          Top = 40
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarUpgradeWeaponSCThreePointRate: TScrollBar
          Left = 64
          Top = 64
          Width = 145
          Height = 17
          Hint = #24471#21040#19977#28857#23646#24615#26426#29575','#26426#29575#20026#24038#22823#21491#23567'.'
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarUpgradeWeaponSCThreePointRateChange
        end
        object EditUpgradeWeaponSCThreePointRate: TEdit
          Left = 216
          Top = 64
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
      end
      object GroupBox20: TGroupBox
        Left = 176
        Top = 208
        Width = 265
        Height = 89
        Caption = #39764#27861#21319#32423
        TabOrder = 3
        object Label26: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #25104#21151#26426#29575':'
        end
        object Label27: TLabel
          Left = 8
          Top = 42
          Width = 54
          Height = 12
          Caption = #20108#28857#26426#29575':'
        end
        object Label28: TLabel
          Left = 8
          Top = 66
          Width = 54
          Height = 12
          Caption = #19977#28857#26426#29575':'
        end
        object ScrollBarUpgradeWeaponMCRate: TScrollBar
          Left = 64
          Top = 16
          Width = 145
          Height = 17
          Hint = #21319#32423#39764#27861#28857#25968#25104#21151#26426#29575','#26426#29575#20026#24038#22823#21491#23567'.'
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarUpgradeWeaponMCRateChange
        end
        object EditUpgradeWeaponMCRate: TEdit
          Left = 216
          Top = 16
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarUpgradeWeaponMCTwoPointRate: TScrollBar
          Left = 64
          Top = 40
          Width = 145
          Height = 17
          Hint = #24471#21040#20108#28857#23646#24615#26426#29575','#26426#29575#20026#24038#22823#21491#23567'.'
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarUpgradeWeaponMCTwoPointRateChange
        end
        object EditUpgradeWeaponMCTwoPointRate: TEdit
          Left = 216
          Top = 40
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarUpgradeWeaponMCThreePointRate: TScrollBar
          Left = 64
          Top = 64
          Width = 145
          Height = 17
          Hint = #24471#21040#19977#28857#23646#24615#26426#29575','#26426#29575#20026#24038#22823#21491#23567'.'
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarUpgradeWeaponMCThreePointRateChange
        end
        object EditUpgradeWeaponMCThreePointRate: TEdit
          Left = 216
          Top = 64
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
      end
      object ButtonUpgradeWeaponSave: TButton
        Left = 8
        Top = 277
        Width = 65
        Height = 20
        Caption = #20445#23384'(&S)'
        TabOrder = 4
        OnClick = ButtonUpgradeWeaponSaveClick
      end
      object ButtonUpgradeWeaponDefaulf: TButton
        Left = 80
        Top = 277
        Width = 65
        Height = 20
        Caption = #40664#35748'(&D)'
        TabOrder = 5
        OnClick = ButtonUpgradeWeaponDefaulfClick
      end
    end
    object TabSheet35: TTabSheet
      Caption = #25366#30719#25511#21046
      ImageIndex = 7
      object GroupBox24: TGroupBox
        Left = 8
        Top = 8
        Width = 273
        Height = 60
        Caption = #24471#21040#30719#30707#26426#29575
        TabOrder = 0
        object Label32: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #21629#20013#26426#29575':'
        end
        object Label33: TLabel
          Left = 8
          Top = 36
          Width = 54
          Height = 12
          Caption = #25366#30719#26426#29575':'
        end
        object ScrollBarMakeMineHitRate: TScrollBar
          Left = 72
          Top = 16
          Width = 129
          Height = 15
          Hint = #35774#32622#30340#25968#23383#36234#23567#26426#29575#36234#22823'.'
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarMakeMineHitRateChange
        end
        object EditMakeMineHitRate: TEdit
          Left = 208
          Top = 16
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarMakeMineRate: TScrollBar
          Left = 72
          Top = 36
          Width = 129
          Height = 15
          Hint = #35774#32622#30340#25968#23383#36234#23567#26426#29575#36234#22823'.'
          Max = 500
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarMakeMineRateChange
        end
        object EditMakeMineRate: TEdit
          Left = 208
          Top = 36
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
      end
      object GroupBox25: TGroupBox
        Left = 8
        Top = 72
        Width = 273
        Height = 217
        Caption = #30719#30707#31867#22411#26426#29575
        TabOrder = 1
        object Label34: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #30719#30707#22240#23376':'
        end
        object Label35: TLabel
          Left = 8
          Top = 38
          Width = 42
          Height = 12
          Caption = #37329#30719#29575':'
        end
        object Label36: TLabel
          Left = 8
          Top = 56
          Width = 42
          Height = 12
          Caption = #38134#30719#29575':'
        end
        object Label37: TLabel
          Left = 8
          Top = 76
          Width = 42
          Height = 12
          Caption = #38081#30719#29575':'
        end
        object Label38: TLabel
          Left = 8
          Top = 96
          Width = 54
          Height = 12
          Caption = #40657#38081#30719#29575':'
        end
        object ScrollBarStoneTypeRate: TScrollBar
          Left = 72
          Top = 16
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarStoneTypeRateChange
        end
        object EditStoneTypeRate: TEdit
          Left = 208
          Top = 16
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarGoldStoneMax: TScrollBar
          Left = 72
          Top = 36
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarGoldStoneMaxChange
        end
        object EditGoldStoneMax: TEdit
          Left = 208
          Top = 36
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarSilverStoneMax: TScrollBar
          Left = 72
          Top = 56
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarSilverStoneMaxChange
        end
        object EditSilverStoneMax: TEdit
          Left = 208
          Top = 56
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
        object ScrollBarSteelStoneMax: TScrollBar
          Left = 72
          Top = 76
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 6
          OnChange = ScrollBarSteelStoneMaxChange
        end
        object EditSteelStoneMax: TEdit
          Left = 208
          Top = 76
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 7
        end
        object EditBlackStoneMax: TEdit
          Left = 208
          Top = 96
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 8
        end
        object ScrollBarBlackStoneMax: TScrollBar
          Left = 72
          Top = 96
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 9
          OnChange = ScrollBarBlackStoneMaxChange
        end
      end
      object ButtonMakeMineSave: TButton
        Left = 376
        Top = 277
        Width = 65
        Height = 20
        Caption = #20445#23384'(&S)'
        TabOrder = 2
        OnClick = ButtonMakeMineSaveClick
      end
      object GroupBox26: TGroupBox
        Left = 288
        Top = 8
        Width = 153
        Height = 121
        Caption = #30719#30707#21697#36136
        TabOrder = 3
        object Label39: TLabel
          Left = 8
          Top = 18
          Width = 78
          Height = 12
          Caption = #30719#30707#26368#23567#21697#36136':'
        end
        object Label40: TLabel
          Left = 8
          Top = 42
          Width = 78
          Height = 12
          Caption = #26222#36890#21697#36136#33539#22260':'
        end
        object Label41: TLabel
          Left = 8
          Top = 66
          Width = 66
          Height = 12
          Caption = #39640#21697#36136#26426#29575':'
        end
        object Label42: TLabel
          Left = 8
          Top = 90
          Width = 66
          Height = 12
          Caption = #39640#21697#36136#33539#22260':'
        end
        object EditStoneMinDura: TSpinEdit
          Left = 92
          Top = 15
          Width = 45
          Height = 21
          Hint = #30719#30707#20986#29616#26368#20302#21697#36136#28857#25968'.'
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditStoneMinDuraChange
        end
        object EditStoneGeneralDuraRate: TSpinEdit
          Left = 92
          Top = 39
          Width = 45
          Height = 21
          Hint = #30719#30707#38543#26426#20986#29616#21697#36136#28857#25968#33539#22260'.'
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditStoneGeneralDuraRateChange
        end
        object EditStoneAddDuraRate: TSpinEdit
          Left = 92
          Top = 63
          Width = 45
          Height = 21
          Hint = #30719#30707#20986#29616#39640#21697#36136#28857#25968#26426#29575','#39640#21697#36136#37327#25351#21487#36798#21040'20'#25110#20197#19978#30340#28857#25968'.'
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditStoneAddDuraRateChange
        end
        object EditStoneAddDuraMax: TSpinEdit
          Left = 92
          Top = 87
          Width = 45
          Height = 21
          Hint = #39640#21697#36136#30719#30707#38543#26426#20986#29616#21697#36136#28857#25968#33539#22260'.'
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 3
          Value = 10
          OnChange = EditStoneAddDuraMaxChange
        end
      end
      object ButtonMakeMineDefault: TButton
        Left = 296
        Top = 277
        Width = 65
        Height = 20
        Caption = #40664#35748'(&D)'
        TabOrder = 4
        OnClick = ButtonMakeMineDefaultClick
      end
    end
    object TabSheet42: TTabSheet
      Caption = #31069#31119#27833#25511#21046
      ImageIndex = 12
      object GroupBox44: TGroupBox
        Left = 8
        Top = 8
        Width = 273
        Height = 217
        Caption = #26426#29575#35774#32622
        TabOrder = 0
        object Label105: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #35781#21650#26426#29575':'
        end
        object Label106: TLabel
          Left = 8
          Top = 38
          Width = 54
          Height = 12
          Caption = #19968#32423#28857#25968':'
        end
        object Label107: TLabel
          Left = 8
          Top = 56
          Width = 54
          Height = 12
          Caption = #20108#32423#28857#25968':'
        end
        object Label108: TLabel
          Left = 8
          Top = 76
          Width = 54
          Height = 12
          Caption = #20108#32423#26426#29575':'
        end
        object Label109: TLabel
          Left = 8
          Top = 96
          Width = 54
          Height = 12
          Caption = #19977#32423#28857#25968':'
        end
        object Label110: TLabel
          Left = 8
          Top = 116
          Width = 54
          Height = 12
          Caption = #19977#32423#26426#29575':'
        end
        object ScrollBarWeaponMakeUnLuckRate: TScrollBar
          Left = 72
          Top = 16
          Width = 129
          Height = 15
          Hint = #20351#29992#31069#31119#27833#35781#21650#26426#29575','#25968#23383#36234#22823#26426#29575#36234#23567'.'
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarWeaponMakeUnLuckRateChange
        end
        object EditWeaponMakeUnLuckRate: TEdit
          Left = 208
          Top = 16
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarWeaponMakeLuckPoint1: TScrollBar
          Left = 72
          Top = 36
          Width = 129
          Height = 15
          Hint = #24403#27494#22120#30340#24184#36816#28857#23567#20110#27492#28857#25968#26102#20351#29992#31069#31119#27833#21017'100% '#25104#21151'.'
          Max = 500
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarWeaponMakeLuckPoint1Change
        end
        object EditWeaponMakeLuckPoint1: TEdit
          Left = 208
          Top = 36
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarWeaponMakeLuckPoint2: TScrollBar
          Left = 72
          Top = 56
          Width = 129
          Height = 15
          Hint = #24403#27494#22120#30340#24184#36816#28857#23567#20110#27492#28857#25968#26102#20351#29992#31069#31119#27833#21017#25353#25351#23450#26426#29575#20915#23450#26159#21542#21152#24184#36816'.'
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarWeaponMakeLuckPoint2Change
        end
        object EditWeaponMakeLuckPoint2: TEdit
          Left = 208
          Top = 56
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
        object ScrollBarWeaponMakeLuckPoint2Rate: TScrollBar
          Left = 72
          Top = 76
          Width = 129
          Height = 15
          Hint = #26426#29575#28857#25968','#25968#23383#36234#22823#26426#29575#36234#23567'.'
          Max = 500
          PageSize = 0
          TabOrder = 6
          OnChange = ScrollBarWeaponMakeLuckPoint2RateChange
        end
        object EditWeaponMakeLuckPoint2Rate: TEdit
          Left = 208
          Top = 76
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 7
        end
        object EditWeaponMakeLuckPoint3: TEdit
          Left = 208
          Top = 96
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 8
        end
        object ScrollBarWeaponMakeLuckPoint3: TScrollBar
          Left = 72
          Top = 96
          Width = 129
          Height = 15
          Hint = #24403#27494#22120#30340#24184#36816#28857#23567#20110#27492#28857#25968#26102#20351#29992#31069#31119#27833#21017#25353#25351#23450#26426#29575#20915#23450#26159#21542#21152#24184#36816'.'
          Max = 500
          PageSize = 0
          TabOrder = 9
          OnChange = ScrollBarWeaponMakeLuckPoint3Change
        end
        object ScrollBarWeaponMakeLuckPoint3Rate: TScrollBar
          Left = 72
          Top = 116
          Width = 129
          Height = 15
          Hint = #26426#29575#28857#25968','#25968#23383#36234#22823#26426#29575#36234#23567'.'
          Max = 500
          PageSize = 0
          TabOrder = 10
          OnChange = ScrollBarWeaponMakeLuckPoint3RateChange
        end
        object EditWeaponMakeLuckPoint3Rate: TEdit
          Left = 208
          Top = 116
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 11
        end
      end
      object ButtonWeaponMakeLuckDefault: TButton
        Left = 296
        Top = 277
        Width = 65
        Height = 20
        Caption = #40664#35748'(&D)'
        TabOrder = 1
        OnClick = ButtonWeaponMakeLuckDefaultClick
      end
      object ButtonWeaponMakeLuckSave: TButton
        Left = 376
        Top = 277
        Width = 65
        Height = 20
        Caption = #20445#23384'(&S)'
        TabOrder = 2
        OnClick = ButtonWeaponMakeLuckSaveClick
      end
    end
    object TabSheet37: TTabSheet
      Caption = #24425#31080#25511#21046
      ImageIndex = 8
      object GroupBox27: TGroupBox
        Left = 8
        Top = 8
        Width = 273
        Height = 169
        Caption = #20013#22870#26426#29575
        TabOrder = 0
        object Label43: TLabel
          Left = 8
          Top = 42
          Width = 42
          Height = 12
          Caption = #19968#31561#22870':'
        end
        object Label44: TLabel
          Left = 8
          Top = 62
          Width = 42
          Height = 12
          Caption = #20108#31561#22870':'
        end
        object Label45: TLabel
          Left = 8
          Top = 80
          Width = 42
          Height = 12
          Caption = #19977#31561#22870':'
        end
        object Label46: TLabel
          Left = 8
          Top = 100
          Width = 42
          Height = 12
          Caption = #22235#31561#22870':'
        end
        object Label47: TLabel
          Left = 8
          Top = 120
          Width = 42
          Height = 12
          Caption = #20116#31561#22870':'
        end
        object Label48: TLabel
          Left = 8
          Top = 140
          Width = 42
          Height = 12
          Caption = #20845#31561#22870':'
        end
        object Label49: TLabel
          Left = 8
          Top = 18
          Width = 30
          Height = 12
          Caption = #22240#23376':'
        end
        object ScrollBarWinLottery1Max: TScrollBar
          Left = 56
          Top = 40
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarWinLottery1MaxChange
        end
        object EditWinLottery1Max: TEdit
          Left = 192
          Top = 40
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarWinLottery2Max: TScrollBar
          Left = 56
          Top = 60
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarWinLottery2MaxChange
        end
        object EditWinLottery2Max: TEdit
          Left = 192
          Top = 60
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarWinLottery3Max: TScrollBar
          Left = 56
          Top = 80
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarWinLottery3MaxChange
        end
        object EditWinLottery3Max: TEdit
          Left = 192
          Top = 80
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
        object ScrollBarWinLottery4Max: TScrollBar
          Left = 56
          Top = 100
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 6
          OnChange = ScrollBarWinLottery4MaxChange
        end
        object EditWinLottery4Max: TEdit
          Left = 192
          Top = 100
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 7
        end
        object EditWinLottery5Max: TEdit
          Left = 192
          Top = 120
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 8
        end
        object ScrollBarWinLottery5Max: TScrollBar
          Left = 56
          Top = 120
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 9
          OnChange = ScrollBarWinLottery5MaxChange
        end
        object ScrollBarWinLottery6Max: TScrollBar
          Left = 56
          Top = 140
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 10
          OnChange = ScrollBarWinLottery6MaxChange
        end
        object EditWinLottery6Max: TEdit
          Left = 192
          Top = 140
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 11
        end
        object EditWinLotteryRate: TEdit
          Left = 192
          Top = 16
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 12
        end
        object ScrollBarWinLotteryRate: TScrollBar
          Left = 56
          Top = 16
          Width = 129
          Height = 15
          Max = 100000
          PageSize = 0
          TabOrder = 13
          OnChange = ScrollBarWinLotteryRateChange
        end
      end
      object GroupBox28: TGroupBox
        Left = 288
        Top = 8
        Width = 145
        Height = 169
        Caption = #22870#37329
        TabOrder = 1
        object Label50: TLabel
          Left = 8
          Top = 18
          Width = 42
          Height = 12
          Caption = #19968#31561#22870':'
        end
        object Label51: TLabel
          Left = 8
          Top = 42
          Width = 42
          Height = 12
          Caption = #20108#31561#22870':'
        end
        object Label52: TLabel
          Left = 8
          Top = 66
          Width = 42
          Height = 12
          Caption = #19977#31561#22870':'
        end
        object Label53: TLabel
          Left = 8
          Top = 90
          Width = 42
          Height = 12
          Caption = #22235#31561#22870':'
        end
        object Label54: TLabel
          Left = 8
          Top = 114
          Width = 42
          Height = 12
          Caption = #20116#31561#22870':'
        end
        object Label55: TLabel
          Left = 8
          Top = 138
          Width = 42
          Height = 12
          Caption = #20845#31561#22870':'
        end
        object EditWinLottery1Gold: TSpinEdit
          Left = 56
          Top = 15
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 0
          Value = 100000000
          OnChange = EditWinLottery1GoldChange
        end
        object EditWinLottery2Gold: TSpinEdit
          Left = 56
          Top = 39
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditWinLottery2GoldChange
        end
        object EditWinLottery3Gold: TSpinEdit
          Left = 56
          Top = 63
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditWinLottery3GoldChange
        end
        object EditWinLottery4Gold: TSpinEdit
          Left = 56
          Top = 87
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 3
          Value = 10
          OnChange = EditWinLottery4GoldChange
        end
        object EditWinLottery5Gold: TSpinEdit
          Left = 56
          Top = 111
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 4
          Value = 10
          OnChange = EditWinLottery5GoldChange
        end
        object EditWinLottery6Gold: TSpinEdit
          Left = 56
          Top = 135
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 5
          Value = 10
          OnChange = EditWinLottery6GoldChange
        end
      end
      object ButtonWinLotterySave: TButton
        Left = 376
        Top = 277
        Width = 65
        Height = 20
        Caption = #20445#23384'(&S)'
        ModalResult = 1
        TabOrder = 2
        OnClick = ButtonWinLotterySaveClick
      end
      object ButtonWinLotteryDefault: TButton
        Left = 296
        Top = 277
        Width = 65
        Height = 20
        Caption = #40664#35748'(&D)'
        TabOrder = 3
        OnClick = ButtonWinLotteryDefaultClick
      end
    end
    object TabSheet40: TTabSheet
      Caption = #31048#31095#29983#25928
      ImageIndex = 11
      object GroupBox36: TGroupBox
        Left = 8
        Top = 8
        Width = 137
        Height = 89
        TabOrder = 0
        object Label94: TLabel
          Left = 11
          Top = 40
          Width = 54
          Height = 12
          Caption = #29983#25928#26102#38271':'
        end
        object Label96: TLabel
          Left = 11
          Top = 64
          Width = 54
          Height = 12
          Caption = #33021#37327#20493#25968':'
          Enabled = False
        end
        object CheckBoxSpiritMutiny: TCheckBox
          Left = 8
          Top = 16
          Width = 113
          Height = 17
          Caption = #21551#29992#31048#31095#29305#27530#21151#33021
          TabOrder = 0
          OnClick = CheckBoxSpiritMutinyClick
        end
        object EditSpiritMutinyTime: TSpinEdit
          Left = 72
          Top = 36
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditSpiritMutinyTimeChange
        end
        object EditSpiritPowerRate: TSpinEdit
          Left = 72
          Top = 60
          Width = 49
          Height = 21
          EditorEnabled = False
          Enabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditSpiritPowerRateChange
        end
      end
      object ButtonSpiritMutinySave: TButton
        Left = 360
        Top = 261
        Width = 65
        Height = 25
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonSpiritMutinySaveClick
      end
    end
  end
end
