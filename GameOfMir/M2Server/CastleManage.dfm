object frmCastleManage: TfrmCastleManage
  Left = 200
  Top = 226
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #22478#22561#31649#29702
  ClientHeight = 279
  ClientWidth = 564
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
    Left = 8
    Top = 8
    Width = 193
    Height = 257
    Caption = #22478#22561#21015#34920
    TabOrder = 0
    object ListViewCastle: TListView
      Left = 8
      Top = 16
      Width = 177
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
          Width = 100
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListViewCastleClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 208
    Top = 8
    Width = 353
    Height = 257
    Caption = #22478#22561#20449#24687
    TabOrder = 1
    object PageControlCastle: TPageControl
      Left = 8
      Top = 16
      Width = 337
      Height = 233
      ActivePage = TabSheet1
      TabIndex = 0
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #22522#26412#29366#24577
        object GroupBox3: TGroupBox
          Left = 5
          Top = 5
          Width = 321
          Height = 92
          TabOrder = 0
          object Label2: TLabel
            Left = 8
            Top = 20
            Width = 54
            Height = 12
            Caption = #25152#23646#34892#20250':'
          end
          object Label1: TLabel
            Left = 8
            Top = 44
            Width = 54
            Height = 12
            Caption = #36164#37329#24635#25968':'
          end
          object Label3: TLabel
            Left = 8
            Top = 68
            Width = 54
            Height = 12
            Caption = #24403#22825#25910#20837':'
          end
          object Label7: TLabel
            Left = 152
            Top = 44
            Width = 30
            Height = 12
            Caption = #31561#32423':'
          end
          object Label8: TLabel
            Left = 152
            Top = 68
            Width = 30
            Height = 12
            Caption = #33021#28304':'
          end
          object EditOwenGuildName: TEdit
            Left = 64
            Top = 16
            Width = 81
            Height = 20
            TabOrder = 0
          end
          object EditTotalGold: TSpinEdit
            Left = 64
            Top = 40
            Width = 81
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 1
            Value = 0
          end
          object EditTodayIncome: TSpinEdit
            Left = 64
            Top = 64
            Width = 81
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 2
            Value = 0
          end
          object EditTechLevel: TSpinEdit
            Left = 184
            Top = 40
            Width = 49
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 3
            Value = 0
          end
          object EditPower: TSpinEdit
            Left = 184
            Top = 64
            Width = 49
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 4
            Value = 0
          end
        end
        object Button6: TButton
          Left = 256
          Top = 176
          Width = 67
          Height = 25
          Caption = #20445#23384'(&S)'
          TabOrder = 1
        end
      end
      object TabSheet3: TTabSheet
        Caption = #23432#21355#29366#24577
        ImageIndex = 2
        object GroupBox5: TGroupBox
          Left = 5
          Top = 0
          Width = 318
          Height = 201
          TabOrder = 0
          object ListViewGuard: TListView
            Left = 8
            Top = 16
            Width = 300
            Height = 145
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
          object ButtonRefresh: TButton
            Left = 240
            Top = 168
            Width = 65
            Height = 25
            Caption = #21047#26032'(&R)'
            TabOrder = 1
            OnClick = ButtonRefreshClick
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = #35774#32622
        ImageIndex = 1
        object GroupBox4: TGroupBox
          Left = 5
          Top = 5
          Width = 321
          Height = 196
          TabOrder = 0
          object Label4: TLabel
            Left = 8
            Top = 24
            Width = 54
            Height = 12
            Caption = #22478#22561#21517#31216':'
          end
          object Label5: TLabel
            Left = 8
            Top = 48
            Width = 54
            Height = 12
            Caption = #25152#23646#34892#20250':'
          end
          object Label6: TLabel
            Left = 176
            Top = 72
            Width = 54
            Height = 12
            Caption = #22238#22478#22320#22270':'
          end
          object Label9: TLabel
            Left = 8
            Top = 72
            Width = 54
            Height = 12
            Caption = #30343#23467#22320#22270':'
          end
          object Label10: TLabel
            Left = 8
            Top = 96
            Width = 54
            Height = 12
            Caption = #22238#22478#24231#26631':'
          end
          object Label11: TLabel
            Left = 176
            Top = 96
            Width = 54
            Height = 12
            Caption = #23494#36947#22320#22270':'
          end
          object Edit4: TEdit
            Left = 64
            Top = 16
            Width = 249
            Height = 20
            TabOrder = 0
          end
          object Edit5: TEdit
            Left = 64
            Top = 40
            Width = 249
            Height = 20
            TabOrder = 1
          end
          object Edit6: TEdit
            Left = 232
            Top = 64
            Width = 81
            Height = 20
            TabOrder = 2
          end
          object Edit1: TEdit
            Left = 64
            Top = 64
            Width = 105
            Height = 20
            TabOrder = 3
          end
          object Edit3: TEdit
            Left = 232
            Top = 88
            Width = 81
            Height = 20
            TabOrder = 4
          end
          object Button1: TButton
            Left = 240
            Top = 160
            Width = 67
            Height = 25
            Caption = #20445#23384'(&S)'
            TabOrder = 5
          end
          object SpinEdit1: TSpinEdit
            Left = 64
            Top = 88
            Width = 49
            Height = 21
            MaxValue = 0
            MinValue = 0
            TabOrder = 6
            Value = 0
          end
          object SpinEdit2: TSpinEdit
            Left = 120
            Top = 88
            Width = 49
            Height = 21
            MaxValue = 0
            MinValue = 0
            TabOrder = 7
            Value = 0
          end
        end
      end
      object TabSheet4: TTabSheet
        Caption = #30003#35831#25915#22478
        ImageIndex = 3
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
