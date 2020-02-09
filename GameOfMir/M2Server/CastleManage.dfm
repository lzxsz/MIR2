object frmCastleManage: TfrmCastleManage
  Left = 438
  Top = 221
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #22478#22561#31649#29702
  ClientHeight = 282
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 7
    Top = 8
    Width = 186
    Height = 267
    Caption = #22478#22561#21015#34920
    TabOrder = 0
    object ListViewCastle: TListView
      Left = 8
      Top = 16
      Width = 169
      Height = 233
      Columns = <
        item
          Caption = #24207#21495
          Width = 36
        end
        item
          Caption = #32534#21495
          Width = 36
        end
        item
          Caption = #21517#31216
          Width = 90
        end>
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      GridLines = True
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListViewCastleClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 200
    Top = 8
    Width = 378
    Height = 267
    Caption = #22478#22561#20449#24687
    TabOrder = 1
    object PageControlCastle: TPageControl
      Left = 5
      Top = 19
      Width = 366
      Height = 238
      ActivePage = TabSheet1
      TabIndex = 0
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #22522#26412#29366#24577
        object GroupBox3: TGroupBox
          Left = 9
          Top = 2
          Width = 336
          Height = 136
          TabOrder = 0
          object Label2: TLabel
            Left = 15
            Top = 32
            Width = 54
            Height = 12
            Caption = #25152#23646#34892#20250':'
          end
          object Label1: TLabel
            Left = 15
            Top = 63
            Width = 54
            Height = 12
            Caption = #36164#37329#24635#25968':'
          end
          object Label3: TLabel
            Left = 15
            Top = 94
            Width = 54
            Height = 12
            Caption = #24403#22825#25910#20837':'
          end
          object Label7: TLabel
            Left = 197
            Top = 63
            Width = 30
            Height = 12
            Caption = #31561#32423':'
          end
          object Label8: TLabel
            Left = 197
            Top = 94
            Width = 30
            Height = 12
            Caption = #33021#28304':'
          end
          object EditOwenGuildName: TEdit
            Left = 71
            Top = 28
            Width = 225
            Height = 20
            Color = clBtnFace
            Font.Charset = GB2312_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
          end
          object EditTotalGold: TSpinEdit
            Left = 71
            Top = 59
            Width = 113
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 1
            Value = 0
          end
          object EditTodayIncome: TSpinEdit
            Left = 71
            Top = 90
            Width = 113
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 2
            Value = 0
          end
          object EditTechLevel: TSpinEdit
            Left = 229
            Top = 59
            Width = 69
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 3
            Value = 0
          end
          object EditPower: TSpinEdit
            Left = 229
            Top = 90
            Width = 69
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 4
            Value = 0
          end
        end
        object btnSaveCastleInfo: TButton
          Left = 273
          Top = 172
          Width = 65
          Height = 25
          Caption = #20445#23384'(&S)'
          TabOrder = 1
          OnClick = btnSaveCastleInfoClick
        end
      end
      object TabSheet3: TTabSheet
        Caption = #23432#21355#29366#24577
        ImageIndex = 2
        object grp1: TGroupBox
          Left = 2
          Top = 2
          Width = 353
          Height = 204
          TabOrder = 0
          object ListViewGuard: TListView
            Left = 7
            Top = 12
            Width = 339
            Height = 154
            Columns = <
              item
                Caption = #24207#21495
                Width = 36
              end
              item
                Caption = #21517#31216
                Width = 80
              end
              item
                Caption = #24231#26631
                Width = 60
              end
              item
                Caption = #34880#37327
                Width = 80
              end
              item
                Caption = #22478#38376#29366#24577
                Width = 60
              end>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
          end
          object btnRefresh: TButton
            Left = 271
            Top = 170
            Width = 65
            Height = 25
            Caption = #21047#26032'(&R)'
            TabOrder = 1
            OnClick = btnRefreshClick
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = #35774#32622
        ImageIndex = 1
        object GroupBox4: TGroupBox
          Left = 9
          Top = 2
          Width = 341
          Height = 204
          TabOrder = 0
          object Label4: TLabel
            Left = 14
            Top = 24
            Width = 54
            Height = 12
            Caption = #22478#22561#21517#31216':'
          end
          object Label5: TLabel
            Left = 14
            Top = 51
            Width = 54
            Height = 12
            Caption = #25152#23646#34892#20250':'
          end
          object Label6: TLabel
            Left = 159
            Top = 74
            Width = 54
            Height = 12
            Caption = #22238#22478#22320#22270':'
          end
          object Label9: TLabel
            Left = 14
            Top = 76
            Width = 54
            Height = 12
            Caption = #30343#23467#22320#22270':'
          end
          object Label10: TLabel
            Left = 159
            Top = 100
            Width = 54
            Height = 12
            Caption = #22238#22478#22352#26631':'
          end
          object Label11: TLabel
            Left = 14
            Top = 101
            Width = 54
            Height = 12
            Caption = #23494#36947#22320#22270':'
          end
          object Edit4: TEdit
            Left = 70
            Top = 18
            Width = 256
            Height = 20
            Color = clBtnFace
            Font.Charset = GB2312_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
          end
          object Edit5: TEdit
            Left = 70
            Top = 44
            Width = 256
            Height = 20
            Color = clWhite
            Font.Charset = GB2312_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object Edit6: TEdit
            Left = 215
            Top = 70
            Width = 110
            Height = 20
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 4
          end
          object Edit1: TEdit
            Left = 70
            Top = 70
            Width = 77
            Height = 20
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 2
          end
          object Edit3: TEdit
            Left = 70
            Top = 97
            Width = 77
            Height = 20
            TabOrder = 3
          end
          object btnSaveSetting: TButton
            Left = 264
            Top = 170
            Width = 65
            Height = 25
            Caption = #20445#23384'(&S)'
            TabOrder = 7
            OnClick = btnSaveSettingClick
          end
          object SpinEdit1: TSpinEdit
            Left = 215
            Top = 96
            Width = 51
            Height = 21
            MaxValue = 0
            MinValue = 0
            TabOrder = 5
            Value = 0
          end
          object SpinEdit2: TSpinEdit
            Left = 272
            Top = 96
            Width = 52
            Height = 21
            MaxValue = 0
            MinValue = 0
            TabOrder = 6
            Value = 0
          end
        end
      end
      object TabSheet4: TTabSheet
        Caption = #30003#35831#25915#22478
        ImageIndex = 3
        TabVisible = False
        object GroupBox6: TGroupBox
          Left = 8
          Top = 0
          Width = 313
          Height = 201
          TabOrder = 0
          object Gridactcastle: TStringGrid
            Left = 8
            Top = 16
            Width = 297
            Height = 145
            ColCount = 3
            DefaultRowHeight = 14
            FixedCols = 0
            RowCount = 9
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing]
            TabOrder = 0
            ColWidths = (
              30
              139
              119)
          end
          object Button2: TButton
            Left = 8
            Top = 168
            Width = 57
            Height = 25
            Caption = #22686#21152'(&A)'
            TabOrder = 1
            OnClick = Button2Click
          end
          object Button3: TButton
            Left = 72
            Top = 168
            Width = 57
            Height = 25
            Caption = #32534#36753'(&E)'
            TabOrder = 2
          end
          object Button4: TButton
            Left = 136
            Top = 168
            Width = 57
            Height = 25
            Caption = #21024#38500'(&D)'
            TabOrder = 3
          end
          object Button5: TButton
            Left = 240
            Top = 168
            Width = 57
            Height = 25
            Caption = #21047#26032'(&R)'
            TabOrder = 4
          end
        end
      end
    end
  end
end
