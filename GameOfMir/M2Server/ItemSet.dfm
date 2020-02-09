object frmItemSet: TfrmItemSet
  Left = 267
  Top = 278
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #29305#27530#23646#24615#29289#21697#35774#32622
  ClientHeight = 329
  ClientWidth = 431
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl: TPageControl
    Left = 8
    Top = 8
    Width = 417
    Height = 313
    ActivePage = TabSheet8
    TabIndex = 0
    TabOrder = 0
    object TabSheet8: TTabSheet
      Caption = #29305#27530#23646#24615
      object ButtonItemSetSave: TButton
        Left = 334
        Top = 237
        Width = 65
        Height = 25
        Caption = #20445#23384'(&S)'
        TabOrder = 0
        OnClick = ButtonItemSetSaveClick
      end
      object ItemSetPageControl: TPageControl
        Left = 8
        Top = 4
        Width = 393
        Height = 225
        ActivePage = TabSheet1
        MultiLine = True
        TabIndex = 0
        TabOrder = 1
        TabPosition = tpBottom
        object TabSheet1: TTabSheet
          Caption = #32463#39564#32763#20493
          object GroupBox141: TGroupBox
            Left = 8
            Top = 8
            Width = 369
            Height = 161
            Caption = #32463#39564#32763#20493
            TabOrder = 0
            object Label108: TLabel
              Left = 11
              Top = 24
              Width = 30
              Height = 12
              Caption = #20493#29575':'
            end
            object Label109: TLabel
              Left = 8
              Top = 104
              Width = 353
              Height = 49
              AutoSize = False
              Caption = 
                #20493#29575#20197#25345#20037#20026#26631#20934#65292#38500#20197#35774#23450#20540#65292#20026#27491#30495#30340#20493#29575#65292#29289#21697#26368#39640#25345#20037#20026'65'#65292#20063#23601#26159'65000'#28857#65292#20197#27492#25345#20037#26469#31639#38500#20197#35774#32622#30340#25968#23383#23601#26159#20493#25968#20102#65292#22914#26524#35774 +
                #32622#20026'10000'#65292#21017#20026' 6.5'#20493#32463#39564#12290#22914#26524#36523#19978#24102#20102#22810#20010#27492#23646#24615#35013#22791#65292#20493#29575#26159#32047#21152#30340#12290
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
              WordWrap = True
            end
            object EditItemExpRate: TSpinEdit
              Left = 56
              Top = 20
              Width = 57
              Height = 21
              EditorEnabled = False
              MaxValue = 60000
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditItemExpRateChange
            end
            object GroupBox1: TGroupBox
              Left = 160
              Top = 16
              Width = 200
              Height = 75
              Caption = #25968#25454#24211#35774#32622#32534#21495' [141]'
              TabOrder = 1
              object Label1: TLabel
                Left = 8
                Top = 18
                Width = 180
                Height = 12
                Caption = #27494#22120#12289#34593#28891#31867#20351#29992#23383#27573': AniCount'
              end
              object Label2: TLabel
                Left = 8
                Top = 36
                Width = 126
                Height = 12
                Caption = #39318#39280#31867#20351#29992#23383#27573': Shape'
              end
            end
          end
        end
        object TabSheet2: TTabSheet
          Caption = #25915#20987#32763#20493
          ImageIndex = 1
          object GroupBox142: TGroupBox
            Left = 8
            Top = 8
            Width = 369
            Height = 161
            Caption = #25915#20987#32763#20493
            TabOrder = 0
            object Label110: TLabel
              Left = 11
              Top = 24
              Width = 30
              Height = 12
              Caption = #20493#29575':'
            end
            object Label3: TLabel
              Left = 8
              Top = 104
              Width = 353
              Height = 49
              AutoSize = False
              Caption = 
                #20493#29575#20197#25345#20037#20026#26631#20934#65292#38500#20197#35774#23450#20540#65292#20026#27491#30495#30340#20493#29575#65292#29289#21697#26368#39640#25345#20037#20026'65'#65292#20063#23601#26159'65000'#28857#65292#20197#27492#25345#20037#26469#31639#38500#20197#35774#32622#30340#25968#23383#23601#26159#20493#25968#20102#65292#22914#26524#35774 +
                #32622#20026'10000'#65292#21017#20026' 6.5'#20493#32463#39564#12290#22914#26524#36523#19978#24102#20102#22810#20010#27492#23646#24615#35013#22791#65292#20493#29575#26159#32047#21152#30340#12290
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
              WordWrap = True
            end
            object EditItemPowerRate: TSpinEdit
              Left = 56
              Top = 20
              Width = 57
              Height = 21
              EditorEnabled = False
              MaxValue = 60000
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditItemPowerRateChange
            end
            object GroupBox2: TGroupBox
              Left = 160
              Top = 16
              Width = 200
              Height = 75
              Caption = #25968#25454#24211#35774#32622#32534#21495' [142]'
              TabOrder = 1
              object Label4: TLabel
                Left = 8
                Top = 18
                Width = 180
                Height = 12
                Caption = #27494#22120#12289#34593#28891#31867#20351#29992#23383#27573': AniCount'
              end
              object Label5: TLabel
                Left = 8
                Top = 36
                Width = 126
                Height = 12
                Caption = #39318#39280#31867#20351#29992#23383#27573': Shape'
              end
            end
          end
        end
        object TabSheet3: TTabSheet
          Caption = #32452#38431#20256#36865
          ImageIndex = 2
        end
        object TabSheet4: TTabSheet
          Caption = #34892#20250#20256#36865
          ImageIndex = 3
          object GroupBox28: TGroupBox
            Left = 8
            Top = 8
            Width = 369
            Height = 161
            Caption = #34892#20250#20256#36865
            TabOrder = 0
            object Label85: TLabel
              Left = 11
              Top = 24
              Width = 54
              Height = 12
              Caption = #20351#29992#38388#38548':'
            end
            object Label86: TLabel
              Left = 8
              Top = 104
              Width = 353
              Height = 49
              AutoSize = False
              Caption = #34892#20250#20256#36865#29289#21697#65292#34892#20250#25484#38376#20154#25165#33021#20351#29992#65292#23558#25972#20010#34892#20250#25104#21592#20840#37096#38598#20013#20110#20256#36865#25484#38376#20154#36523#36793#12290#34987#20256#36865#25104#21592#65292#24517#39035#20351#29992#21629#20196#20801#35768#34892#20250#20256#36865#12290
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
              WordWrap = True
            end
            object EditGuildRecallTime: TSpinEdit
              Left = 72
              Top = 20
              Width = 57
              Height = 21
              Hint = #37325#22797#20351#29992#27492#21151#33021#65292#25152#38656#38388#38548#26102#38388#12290#27492#35774#32622#20462#25913#21518#19981#33021#31435#21363#29983#25928#65292#38656#22312#19979#27425#20351#29992#26102#29983#25928#12290
              EditorEnabled = False
              MaxValue = 60000
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditGuildRecallTimeChange
            end
            object GroupBox29: TGroupBox
              Left = 160
              Top = 16
              Width = 200
              Height = 75
              Caption = #25968#25454#24211#35774#32622#32534#21495' [145]'
              TabOrder = 1
              object Label87: TLabel
                Left = 8
                Top = 18
                Width = 180
                Height = 12
                Caption = #27494#22120#12289#34593#28891#31867#20351#29992#23383#27573': AniCount'
              end
              object Label88: TLabel
                Left = 8
                Top = 36
                Width = 126
                Height = 12
                Caption = #39318#39280#31867#20351#29992#23383#27573': Shape'
              end
            end
          end
        end
        object TabSheet5: TTabSheet
          Caption = #40635#30201#25915#20987
          ImageIndex = 4
          object GroupBox44: TGroupBox
            Left = 8
            Top = 8
            Width = 369
            Height = 161
            Caption = #32463#39564#32763#20493
            TabOrder = 0
            object GroupBox45: TGroupBox
              Left = 167
              Top = 20
              Width = 195
              Height = 81
              Caption = #25968#25454#24211#35774#32622#32534#21495' [113]'
              TabOrder = 0
              object Label122: TLabel
                Left = 8
                Top = 18
                Width = 180
                Height = 12
                Caption = #27494#22120#12289#34593#28891#31867#20351#29992#23383#27573': AniCount'
              end
              object Label123: TLabel
                Left = 8
                Top = 36
                Width = 126
                Height = 12
                Caption = #39318#39280#31867#20351#29992#23383#27573': Shape'
              end
            end
            object GroupBox42: TGroupBox
              Left = 7
              Top = 20
              Width = 155
              Height = 81
              Caption = #21442#25968
              TabOrder = 1
              object Label120: TLabel
                Left = 11
                Top = 22
                Width = 54
                Height = 12
                Caption = #40635#30201#26426#29575':'
              end
              object Label116: TLabel
                Left = 11
                Top = 48
                Width = 54
                Height = 12
                Caption = #40635#30201#26102#38388':'
              end
              object Label124: TLabel
                Left = 127
                Top = 48
                Width = 12
                Height = 12
                Caption = #31186
              end
              object EditAttackPosionRate: TSpinEdit
                Left = 72
                Top = 18
                Width = 49
                Height = 21
                Hint = #40635#30201#25104#21151#26426#29575#65292#25968#23383#36234#23567#26426#29575#36234#22823#65292#27492#35774#32622#40664#35748#20026'5'
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 0
                Value = 100
                OnChange = EditAttackPosionRateChange
              end
              object EditAttackPosionTime: TSpinEdit
                Left = 72
                Top = 44
                Width = 49
                Height = 21
                Hint = #40635#30201#26102#38388#38271#24230#65292#21333#20301#31186#65292#40664#35748#35774#32622#20026'6'
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 1
                Value = 100
                OnChange = EditAttackPosionTimeChange
              end
            end
          end
        end
        object TabSheet6: TTabSheet
          Caption = #20256#36865
          ImageIndex = 5
          object GroupBox43: TGroupBox
            Left = 8
            Top = 8
            Width = 369
            Height = 161
            Caption = #20256#36865
            TabOrder = 0
            object GroupBox46: TGroupBox
              Left = 167
              Top = 20
              Width = 195
              Height = 81
              Caption = #25968#25454#24211#35774#32622#32534#21495' [112]'
              TabOrder = 0
              object Label117: TLabel
                Left = 8
                Top = 18
                Width = 180
                Height = 12
                Caption = #27494#22120#12289#34593#28891#31867#20351#29992#23383#27573': AniCount'
              end
              object Label118: TLabel
                Left = 8
                Top = 36
                Width = 126
                Height = 12
                Caption = #39318#39280#31867#20351#29992#23383#27573': Shape'
              end
            end
            object GroupBox47: TGroupBox
              Left = 7
              Top = 20
              Width = 155
              Height = 81
              Caption = #21442#25968
              TabOrder = 1
              object Label119: TLabel
                Left = 11
                Top = 56
                Width = 54
                Height = 12
                Caption = #20351#29992#38388#38548':'
              end
              object Label121: TLabel
                Left = 125
                Top = 56
                Width = 12
                Height = 12
                Caption = #31186
              end
              object CheckBoxUserMoveCanDupObj: TCheckBox
                Left = 8
                Top = 16
                Width = 137
                Height = 17
                Hint = #20851#38381#27492#36873#39033#21518#65292#20256#36865#24231#26631#19978#26377#35282#33394#26102#23558#19981#20801#35768#20256#36865
                Caption = #20801#35768#20256#36865#35282#33394#37325#21472
                TabOrder = 0
                OnClick = CheckBoxUserMoveCanDupObjClick
              end
              object CheckBoxUserMoveCanOnItem: TCheckBox
                Left = 8
                Top = 32
                Width = 137
                Height = 17
                Hint = #20851#38381#27492#36873#39033#21518#65292#20256#36865#24231#26631#19978#26377#29289#21697#26102#23558#19981#20801#35768#20256#36865
                Caption = #20801#35768#20256#36865#29289#21697#37325#21472
                TabOrder = 1
                OnClick = CheckBoxUserMoveCanOnItemClick
              end
              object EditUserMoveTime: TSpinEdit
                Left = 72
                Top = 52
                Width = 49
                Height = 21
                Hint = #20256#36865#21629#20196#20351#29992#38388#38548#26102#38388
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 2
                Value = 100
                OnChange = EditUserMoveTimeChange
              end
            end
          end
        end
      end
    end
    object TabSheet19: TTabSheet
      Caption = #31070#31192#22871#35013
      ImageIndex = 2
      object PageControl1: TPageControl
        Left = 8
        Top = 4
        Width = 393
        Height = 253
        ActivePage = TabSheet27
        MultiLine = True
        TabIndex = 0
        TabOrder = 0
        TabPosition = tpBottom
        object TabSheet27: TTabSheet
          Caption = #25106#25351#31867
          ImageIndex = 7
          object GroupBox49: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 65
            Caption = #25915#20987
            TabOrder = 0
            object Label152: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label153: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowRingDCAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowRingDCAddRateChange
            end
            object EditUnknowRingDCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowRingDCAddValueMaxLimitChange
            end
          end
          object GroupBox50: TGroupBox
            Left = 8
            Top = 80
            Width = 113
            Height = 65
            Caption = #39764#27861
            TabOrder = 1
            object Label155: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label156: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowRingMCAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowRingMCAddRateChange
            end
            object EditUnknowRingMCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowRingMCAddValueMaxLimitChange
            end
          end
          object GroupBox51: TGroupBox
            Left = 8
            Top = 152
            Width = 113
            Height = 65
            Caption = #36947#26415
            TabOrder = 2
            object Label158: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label159: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowRingSCAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowRingSCAddRateChange
            end
            object EditUnknowRingSCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowRingSCAddValueMaxLimitChange
            end
          end
          object GroupBox30: TGroupBox
            Left = 128
            Top = 8
            Width = 113
            Height = 65
            Caption = #38450#24481
            TabOrder = 3
            object Label89: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label90: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowRingACAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowRingACAddRateChange
            end
            object EditUnknowRingACAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowRingACAddValueMaxLimitChange
            end
          end
          object GroupBox31: TGroupBox
            Left = 128
            Top = 80
            Width = 113
            Height = 65
            Caption = #39764#27861#38450#24481
            TabOrder = 4
            object Label91: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label92: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowRingMACAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowRingMACAddRateChange
            end
            object EditUnknowRingMACAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowRingMACAddValueMaxLimitChange
            end
          end
        end
        object TabSheet25: TTabSheet
          Caption = #25163#38255#31867
          ImageIndex = 5
          object GroupBox32: TGroupBox
            Left = 8
            Top = 152
            Width = 113
            Height = 65
            Caption = #36947#26415
            TabOrder = 0
            object Label93: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label94: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowNecklaceSCAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowNecklaceSCAddRateChange
            end
            object EditUnknowNecklaceSCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowNecklaceSCAddValueMaxLimitChange
            end
          end
          object GroupBox33: TGroupBox
            Left = 128
            Top = 80
            Width = 113
            Height = 65
            Caption = #39764#27861#38450#24481
            TabOrder = 1
            object Label95: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label96: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowNecklaceMACAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowNecklaceMACAddRateChange
            end
            object EditUnknowNecklaceMACAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowNecklaceMACAddValueMaxLimitChange
            end
          end
          object GroupBox34: TGroupBox
            Left = 128
            Top = 8
            Width = 113
            Height = 65
            Caption = #38450#24481
            TabOrder = 2
            object Label97: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label98: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowNecklaceACAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowNecklaceACAddRateChange
            end
            object EditUnknowNecklaceACAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowNecklaceACAddValueMaxLimitChange
            end
          end
          object GroupBox35: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 65
            Caption = #25915#20987
            TabOrder = 3
            object Label99: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label100: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowNecklaceDCAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowNecklaceDCAddRateChange
            end
            object EditUnknowNecklaceDCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowNecklaceDCAddValueMaxLimitChange
            end
          end
          object GroupBox36: TGroupBox
            Left = 8
            Top = 80
            Width = 113
            Height = 65
            Caption = #39764#27861
            TabOrder = 4
            object Label101: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label102: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowNecklaceMCAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowNecklaceMCAddRateChange
            end
            object EditUnknowNecklaceMCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowNecklaceMCAddValueMaxLimitChange
            end
          end
        end
        object TabSheet20: TTabSheet
          Caption = #22836#30420#31867
          ImageIndex = 2
          object GroupBox37: TGroupBox
            Left = 8
            Top = 152
            Width = 113
            Height = 65
            Caption = #36947#26415
            TabOrder = 0
            object Label103: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label104: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowHelMetSCAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowHelMetSCAddRateChange
            end
            object EditUnknowHelMetSCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowHelMetSCAddValueMaxLimitChange
            end
          end
          object GroupBox38: TGroupBox
            Left = 8
            Top = 80
            Width = 113
            Height = 65
            Caption = #39764#27861
            TabOrder = 1
            object Label105: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label106: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowHelMetMCAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowHelMetMCAddRateChange
            end
            object EditUnknowHelMetMCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowHelMetMCAddValueMaxLimitChange
            end
          end
          object GroupBox39: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 65
            Caption = #25915#20987
            TabOrder = 2
            object Label107: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label111: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowHelMetDCAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowHelMetDCAddRateChange
            end
            object EditUnknowHelMetDCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowHelMetDCAddValueMaxLimitChange
            end
          end
          object GroupBox40: TGroupBox
            Left = 128
            Top = 8
            Width = 113
            Height = 65
            Caption = #38450#24481
            TabOrder = 3
            object Label112: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label113: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowHelMetACAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowHelMetACAddRateChange
            end
            object EditUnknowHelMetACAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowHelMetACAddValueMaxLimitChange
            end
          end
          object GroupBox41: TGroupBox
            Left = 128
            Top = 80
            Width = 113
            Height = 65
            Caption = #39764#27861#38450#24481
            TabOrder = 4
            object Label114: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label115: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditUnknowHelMetMACAddRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditUnknowHelMetMACAddRateChange
            end
            object EditUnknowHelMetMACAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditUnknowHelMetMACAddValueMaxLimitChange
            end
          end
        end
      end
      object ButtonUnKnowItemSave: TButton
        Left = 334
        Top = 253
        Width = 65
        Height = 25
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonUnKnowItemSaveClick
      end
    end
    object TabSheet9: TTabSheet
      Caption = #26497#21697#26426#29575
      ImageIndex = 1
      object AddValuePageControl: TPageControl
        Left = 8
        Top = 4
        Width = 393
        Height = 245
        ActivePage = TabSheet10
        MultiLine = True
        TabIndex = 0
        TabOrder = 0
        TabPosition = tpBottom
        object TabSheet10: TTabSheet
          Caption = #26426#29575#25511#21046
          object GroupBox3: TGroupBox
            Left = 8
            Top = 8
            Width = 137
            Height = 81
            Caption = #26497#21697#20986#29616#26426#29575
            TabOrder = 0
            object Label6: TLabel
              Left = 11
              Top = 24
              Width = 54
              Height = 12
              Caption = #24618#29289#25481#33853':'
            end
            object Label7: TLabel
              Left = 11
              Top = 48
              Width = 54
              Height = 12
              Caption = #21629#20196#21046#36896':'
            end
            object EditMonRandomAddValue: TSpinEdit
              Left = 72
              Top = 20
              Width = 57
              Height = 21
              Hint = #24618#29289#27515#20129#25481#33853#29289#21697#26497#21697#20986#29616#26426#29575#65292#25968#25454#36234#22823#65292#26426#29575#36234#23567#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditMonRandomAddValueChange
            end
            object EditMakeRandomAddValue: TSpinEdit
              Left = 72
              Top = 44
              Width = 57
              Height = 21
              Hint = 'GM'#21629#20196#21046#36896#29289#21697#26497#21697#20986#29616#26426#29575#65292#25968#25454#36234#22823#65292#26426#29575#36234#23567#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditMakeRandomAddValueChange
            end
          end
        end
        object TabSheet11: TTabSheet
          Caption = #27494#22120#31867
          ImageIndex = 1
          object Label32: TLabel
            Left = 8
            Top = 176
            Width = 222
            Height = 12
            Caption = #27494#22120#31867#65292#29289#21697#25968#25454#24211#23383#27573' StdMode 5 '#25110' 6'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object GroupBox4: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 65
            Caption = #25915#20987
            TabOrder = 0
            object Label8: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label9: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditWeaponDCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditWeaponDCAddValueMaxLimitChange
            end
            object EditWeaponDCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditWeaponDCAddValueRateChange
            end
          end
          object GroupBox5: TGroupBox
            Left = 8
            Top = 80
            Width = 113
            Height = 65
            Caption = #39764#27861
            TabOrder = 1
            object Label10: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label11: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditWeaponMCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditWeaponMCAddValueMaxLimitChange
            end
            object EditWeaponMCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditWeaponMCAddValueRateChange
            end
          end
          object GroupBox6: TGroupBox
            Left = 128
            Top = 8
            Width = 113
            Height = 65
            Caption = #36947#26415
            TabOrder = 2
            object Label12: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label13: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object EditWeaponSCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditWeaponSCAddValueMaxLimitChange
            end
            object EditWeaponSCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditWeaponSCAddValueRateChange
            end
          end
        end
        object TabSheet12: TTabSheet
          Caption = #34915#26381#31867
          ImageIndex = 2
          object Label33: TLabel
            Left = 136
            Top = 176
            Width = 234
            Height = 12
            Caption = #34915#26381#31867#65292#29289#21697#25968#25454#24211#23383#27573' StdMode 10 '#25110' 11'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object GroupBox7: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 89
            Caption = #25915#20987
            TabOrder = 0
            object Label14: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label15: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label20: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditDressDCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditDressDCAddValueMaxLimitChange
            end
            object EditDressDCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditDressDCAddValueRateChange
            end
            object EditDressDCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditDressDCAddRateChange
            end
          end
          object GroupBox8: TGroupBox
            Left = 8
            Top = 104
            Width = 113
            Height = 89
            Caption = #39764#27861
            TabOrder = 1
            object Label16: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label17: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label21: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditDressMCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditDressMCAddValueMaxLimitChange
            end
            object EditDressMCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditDressMCAddValueRateChange
            end
            object EditDressMCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditDressMCAddRateChange
            end
          end
          object GroupBox9: TGroupBox
            Left = 128
            Top = 8
            Width = 113
            Height = 89
            Caption = #36947#26415
            TabOrder = 2
            object Label18: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label19: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label22: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditDressSCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditDressSCAddValueMaxLimitChange
            end
            object EditDressSCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditDressSCAddValueRateChange
            end
            object EditDressSCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditDressSCAddRateChange
            end
          end
        end
        object TabSheet13: TTabSheet
          Caption = #39033#38142#31867
          ImageIndex = 3
          object Label34: TLabel
            Left = 136
            Top = 176
            Width = 198
            Height = 12
            Caption = #39033#38142#31867#65292#29289#21697#25968#25454#24211#23383#27573' StdMode 19'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object GroupBox10: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 89
            Caption = #25915#20987
            TabOrder = 0
            object Label23: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label24: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label25: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditNeckLace19DCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditNeckLace19DCAddValueMaxLimitChange
            end
            object EditNeckLace19DCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditNeckLace19DCAddValueRateChange
            end
            object EditNeckLace19DCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditNeckLace19DCAddRateChange
            end
          end
          object GroupBox11: TGroupBox
            Left = 8
            Top = 104
            Width = 113
            Height = 89
            Caption = #39764#27861
            TabOrder = 1
            object Label26: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label27: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label28: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditNeckLace19MCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditNeckLace19MCAddValueMaxLimitChange
            end
            object EditNeckLace19MCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditNeckLace19MCAddValueRateChange
            end
            object EditNeckLace19MCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditNeckLace19MCAddRateChange
            end
          end
          object GroupBox12: TGroupBox
            Left = 128
            Top = 8
            Width = 113
            Height = 89
            Caption = #36947#26415
            TabOrder = 2
            object Label29: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label30: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label31: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditNeckLace19SCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditNeckLace19SCAddValueMaxLimitChange
            end
            object EditNeckLace19SCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditNeckLace19SCAddValueRateChange
            end
            object EditNeckLace19SCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditNeckLace19SCAddRateChange
            end
          end
        end
        object TabSheet14: TTabSheet
          Caption = #39033#38142#25163#38255
          ImageIndex = 4
          object Label35: TLabel
            Left = 136
            Top = 176
            Width = 234
            Height = 12
            Caption = #39033#38142#25163#38255#31867#65292#25968#25454#24211#23383#27573' StdMode 21,21,24'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object GroupBox13: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 89
            Caption = #25915#20987
            TabOrder = 0
            object Label36: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label37: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label38: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditNeckLace202124DCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditNeckLace202124DCAddValueMaxLimitChange
            end
            object EditNeckLace202124DCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditNeckLace202124DCAddValueRateChange
            end
            object EditNeckLace202124DCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditNeckLace202124DCAddRateChange
            end
          end
          object GroupBox14: TGroupBox
            Left = 8
            Top = 104
            Width = 113
            Height = 89
            Caption = #39764#27861
            TabOrder = 1
            object Label39: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label40: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label41: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditNeckLace202124MCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditNeckLace202124MCAddValueMaxLimitChange
            end
            object EditNeckLace202124MCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditNeckLace202124MCAddValueRateChange
            end
            object EditNeckLace202124MCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditNeckLace202124MCAddRateChange
            end
          end
          object GroupBox15: TGroupBox
            Left = 128
            Top = 8
            Width = 113
            Height = 89
            Caption = #36947#26415
            TabOrder = 2
            object Label42: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label43: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label44: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditNeckLace202124SCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditNeckLace202124SCAddValueMaxLimitChange
            end
            object EditNeckLace202124SCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditNeckLace202124SCAddValueRateChange
            end
            object EditNeckLace202124SCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditNeckLace202124SCAddRateChange
            end
          end
        end
        object TabSheet15: TTabSheet
          Caption = #25163#38255#31867
          ImageIndex = 5
          object Label54: TLabel
            Left = 136
            Top = 176
            Width = 198
            Height = 12
            Caption = #25163#38255#31867#65292#29289#21697#25968#25454#24211#23383#27573' StdMode 26'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object GroupBox16: TGroupBox
            Left = 8
            Top = 104
            Width = 113
            Height = 89
            Caption = #39764#27861
            TabOrder = 0
            object Label45: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label46: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label47: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditArmRing26MCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditArmRing26MCAddValueMaxLimitChange
            end
            object EditArmRing26MCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditArmRing26MCAddValueRateChange
            end
            object EditArmRing26MCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditArmRing26MCAddRateChange
            end
          end
          object GroupBox17: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 89
            Caption = #25915#20987
            TabOrder = 1
            object Label48: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label49: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label50: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditArmRing26DCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditArmRing26DCAddValueMaxLimitChange
            end
            object EditArmRing26DCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditArmRing26DCAddValueRateChange
            end
            object EditArmRing26DCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditArmRing26DCAddRateChange
            end
          end
          object GroupBox18: TGroupBox
            Left = 128
            Top = 8
            Width = 113
            Height = 89
            Caption = #36947#26415
            TabOrder = 2
            object Label51: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label52: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label53: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditArmRing26SCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditArmRing26SCAddValueMaxLimitChange
            end
            object EditArmRing26SCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditArmRing26SCAddValueRateChange
            end
            object EditArmRing26SCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditArmRing26SCAddRateChange
            end
          end
        end
        object TabSheet16: TTabSheet
          Caption = #25106#25351#31867
          ImageIndex = 6
          object Label64: TLabel
            Left = 136
            Top = 176
            Width = 198
            Height = 12
            Caption = #25106#25351#31867#65292#29289#21697#25968#25454#24211#23383#27573' StdMode 22'
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object GroupBox19: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 89
            Caption = #25915#20987
            TabOrder = 0
            object Label55: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label56: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label57: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
              Enabled = False
              Visible = False
            end
            object EditRing22DCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditRing22DCAddValueMaxLimitChange
            end
            object EditRing22DCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditRing22DCAddValueRateChange
            end
            object EditRing22DCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              Enabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              Visible = False
              OnChange = EditRing22DCAddRateChange
            end
          end
          object GroupBox20: TGroupBox
            Left = 128
            Top = 8
            Width = 113
            Height = 89
            Caption = #36947#26415
            TabOrder = 1
            object Label58: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label59: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label60: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
              Enabled = False
              Visible = False
            end
            object EditRing22SCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditRing22SCAddValueMaxLimitChange
            end
            object EditRing22SCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditRing22SCAddValueRateChange
            end
            object EditRing22SCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              Enabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              Visible = False
              OnChange = EditRing22SCAddRateChange
            end
          end
          object GroupBox21: TGroupBox
            Left = 8
            Top = 104
            Width = 113
            Height = 89
            Caption = #39764#27861
            TabOrder = 2
            object Label61: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label62: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label63: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
              Enabled = False
              Visible = False
            end
            object EditRing22MCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditRing22MCAddValueMaxLimitChange
            end
            object EditRing22MCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditRing22MCAddValueRateChange
            end
            object EditRing22MCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              Enabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              Visible = False
              OnChange = EditRing22MCAddRateChange
            end
          end
        end
        object TabSheet17: TTabSheet
          Caption = #25106#25351#31867
          ImageIndex = 7
          object Label74: TLabel
            Left = 136
            Top = 176
            Width = 198
            Height = 12
            Caption = #25106#25351#31867#65292#29289#21697#25968#25454#24211#23383#27573' StdMode 23'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object GroupBox22: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 89
            Caption = #25915#20987
            TabOrder = 0
            object Label65: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label66: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label67: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
              Enabled = False
              Visible = False
            end
            object EditRing23DCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditRing23DCAddValueMaxLimitChange
            end
            object EditRing23DCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditRing23DCAddValueRateChange
            end
            object EditRing23DCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              Enabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              Visible = False
              OnChange = EditRing23DCAddRateChange
            end
          end
          object GroupBox23: TGroupBox
            Left = 8
            Top = 104
            Width = 113
            Height = 89
            Caption = #39764#27861
            TabOrder = 1
            object Label68: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label69: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label70: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
              Enabled = False
              Visible = False
            end
            object EditRing23MCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditRing23MCAddValueMaxLimitChange
            end
            object EditRing23MCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditRing23MCAddValueRateChange
            end
            object EditRing23MCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              Enabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              Visible = False
              OnChange = EditRing23MCAddRateChange
            end
          end
          object GroupBox24: TGroupBox
            Left = 128
            Top = 8
            Width = 113
            Height = 89
            Caption = #36947#26415
            TabOrder = 2
            object Label71: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label72: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label73: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
              Enabled = False
              Visible = False
            end
            object EditRing23SCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditRing23SCAddValueMaxLimitChange
            end
            object EditRing23SCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditRing23SCAddValueRateChange
            end
            object EditRing23SCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              Enabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              Visible = False
              OnChange = EditRing23SCAddRateChange
            end
          end
        end
        object TabSheet18: TTabSheet
          Caption = #22836#30420#31867
          ImageIndex = 8
          object Label84: TLabel
            Left = 136
            Top = 176
            Width = 198
            Height = 12
            Caption = #22836#30420#31867#65292#29289#21697#25968#25454#24211#23383#27573' StdMode 15'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object GroupBox25: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 89
            Caption = #25915#20987
            TabOrder = 0
            object Label75: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label76: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label77: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditHelMetDCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditHelMetDCAddValueMaxLimitChange
            end
            object EditHelMetDCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditHelMetDCAddValueRateChange
            end
            object EditHelMetDCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditHelMetDCAddRateChange
            end
          end
          object GroupBox26: TGroupBox
            Left = 8
            Top = 104
            Width = 113
            Height = 89
            Caption = #39764#27861
            TabOrder = 1
            object Label78: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label79: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label80: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditHelMetMCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditHelMetMCAddValueMaxLimitChange
            end
            object EditHelMetMCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditHelMetMCAddValueRateChange
            end
            object EditHelMetMCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditHelMetMCAddRateChange
            end
          end
          object GroupBox27: TGroupBox
            Left = 128
            Top = 8
            Width = 113
            Height = 89
            Caption = #36947#26415
            TabOrder = 2
            object Label81: TLabel
              Left = 11
              Top = 16
              Width = 54
              Height = 12
              Caption = #26368#39640#28857#25968':'
            end
            object Label82: TLabel
              Left = 11
              Top = 40
              Width = 54
              Height = 12
              Caption = #28857#25968#26426#29575':'
            end
            object Label83: TLabel
              Left = 11
              Top = 64
              Width = 54
              Height = 12
              Caption = #23646#24615#26426#29575':'
            end
            object EditHelMetSCAddValueMaxLimit: TSpinEdit
              Left = 64
              Top = 12
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditHelMetSCAddValueMaxLimitChange
            end
            object EditHelMetSCAddValueRate: TSpinEdit
              Left = 64
              Top = 36
              Width = 41
              Height = 21
              Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = EditHelMetSCAddValueRateChange
            end
            object EditHelMetSCAddRate: TSpinEdit
              Left = 64
              Top = 60
              Width = 41
              Height = 21
              Hint = #21152#23646#26497#21697#23646#24615#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#27492#26426#29575#20915#23450#26159#21542#21152#19978#23646#24615#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = EditHelMetSCAddRateChange
            end
          end
        end
      end
      object ButtonAddValueSave: TButton
        Left = 334
        Top = 253
        Width = 65
        Height = 25
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonAddValueSaveClick
      end
    end
  end
end
