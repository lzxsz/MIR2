object frmViewKernelInfo: TfrmViewKernelInfo
  Left = 321
  Top = 267
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #20869#26680#25968#25454#26597#30475
  ClientHeight = 233
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 457
    Height = 209
    ActivePage = TabSheet4
    TabIndex = 0
    TabOrder = 0
    object TabSheet4: TTabSheet
      Caption = #31995#32479#25968#25454
      ImageIndex = 3
      object GroupBox6: TGroupBox
        Left = 8
        Top = 8
        Width = 193
        Height = 97
        Caption = #20869#23384#20998#37197
        TabOrder = 0
        object Label25: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #20869#23384#22823#23567':'
        end
        object Label26: TLabel
          Left = 8
          Top = 44
          Width = 66
          Height = 12
          Caption = #20869#23384#22359#25968#37327':'
        end
        object EditAllocMemCount: TEdit
          Left = 88
          Top = 40
          Width = 73
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditAllocMemSize: TEdit
          Left = 88
          Top = 16
          Width = 73
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = #28216#25103#25968#25454
      object GroupBox1: TGroupBox
        Left = 8
        Top = 4
        Width = 153
        Height = 121
        Caption = #28216#25103#25968#25454#24211
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 20
          Width = 78
          Height = 12
          Caption = #35835#21462#35831#27714#27425#25968':'
        end
        object Label2: TLabel
          Left = 8
          Top = 44
          Width = 78
          Height = 12
          Caption = #35835#21462#22833#36133#27425#25968':'
        end
        object Label3: TLabel
          Left = 8
          Top = 68
          Width = 78
          Height = 12
          Caption = #20445#23384#35831#27714#27425#25968':'
        end
        object Label4: TLabel
          Left = 8
          Top = 92
          Width = 78
          Height = 12
          Caption = #35831#27714#26631#35782#25968#23383':'
        end
        object EditLoadHumanDBCount: TEdit
          Left = 88
          Top = 16
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditLoadHumanDBErrorCoun: TEdit
          Left = 88
          Top = 40
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
        object EditSaveHumanDBCount: TEdit
          Left = 88
          Top = 64
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 2
        end
        object EditHumanDBQueryID: TEdit
          Left = 88
          Top = 88
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 3
        end
      end
      object GroupBox4: TGroupBox
        Left = 168
        Top = 4
        Width = 177
        Height = 69
        Caption = #29289#21697#31995#21015#21495
        TabOrder = 1
        object Label7: TLabel
          Left = 8
          Top = 20
          Width = 78
          Height = 12
          Caption = #24618#29289#25481#33853#29289#21697':'
        end
        object Label8: TLabel
          Left = 8
          Top = 44
          Width = 78
          Height = 12
          Caption = #21629#20196#21046#36896#29289#21697':'
        end
        object EditItemNumber: TEdit
          Left = 88
          Top = 16
          Width = 73
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditItemNumberEx: TEdit
          Left = 88
          Top = 40
          Width = 73
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #24425#31080#25968#25454
      ImageIndex = 1
      object GroupBox2: TGroupBox
        Left = 8
        Top = 4
        Width = 153
        Height = 77
        Caption = #20013#22870#25968#37327
        TabOrder = 0
        object Label5: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #20013#22870#24635#25968':'
        end
        object Label6: TLabel
          Left = 8
          Top = 44
          Width = 54
          Height = 12
          Caption = #26410#20013#22870#25968':'
        end
        object EditWinLotteryCount: TEdit
          Left = 88
          Top = 16
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditNoWinLotteryCount: TEdit
          Left = 88
          Top = 40
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
      end
      object GroupBox3: TGroupBox
        Left = 168
        Top = 4
        Width = 129
        Height = 165
        Caption = #20013#22870#27604#20363
        TabOrder = 1
        object Label9: TLabel
          Left = 8
          Top = 20
          Width = 42
          Height = 12
          Caption = #19968#31561#22870':'
        end
        object Label10: TLabel
          Left = 8
          Top = 44
          Width = 42
          Height = 12
          Caption = #20108#31561#22870':'
        end
        object Label11: TLabel
          Left = 8
          Top = 68
          Width = 42
          Height = 12
          Caption = #19977#31561#22870':'
        end
        object Label12: TLabel
          Left = 8
          Top = 92
          Width = 42
          Height = 12
          Caption = #22235#31561#22870':'
        end
        object Label13: TLabel
          Left = 8
          Top = 116
          Width = 42
          Height = 12
          Caption = #20116#31561#22870':'
        end
        object Label14: TLabel
          Left = 8
          Top = 140
          Width = 42
          Height = 12
          Caption = #20845#31561#22870':'
        end
        object EditWinLotteryLevel1: TEdit
          Left = 56
          Top = 16
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditWinLotteryLevel2: TEdit
          Left = 56
          Top = 40
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
        object EditWinLotteryLevel3: TEdit
          Left = 56
          Top = 64
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 2
        end
        object EditWinLotteryLevel4: TEdit
          Left = 56
          Top = 88
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 3
        end
        object EditWinLotteryLevel5: TEdit
          Left = 56
          Top = 112
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 4
        end
        object EditWinLotteryLevel6: TEdit
          Left = 56
          Top = 136
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 5
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #20840#23616#21464#37327
      ImageIndex = 2
      object GroupBox5: TGroupBox
        Left = 8
        Top = 4
        Width = 425
        Height = 165
        Caption = #20840#23616#21464#37327#29366#24577
        TabOrder = 0
        object Label15: TLabel
          Left = 8
          Top = 20
          Width = 42
          Height = 12
          Caption = #21464#37327#19968':'
        end
        object Label16: TLabel
          Left = 8
          Top = 44
          Width = 42
          Height = 12
          Caption = #21464#37327#20108':'
        end
        object Label17: TLabel
          Left = 8
          Top = 68
          Width = 42
          Height = 12
          Caption = #21464#37327#19977':'
        end
        object Label18: TLabel
          Left = 8
          Top = 92
          Width = 42
          Height = 12
          Caption = #21464#37327#22235':'
        end
        object Label19: TLabel
          Left = 8
          Top = 116
          Width = 42
          Height = 12
          Caption = #21464#37327#20116':'
        end
        object Label20: TLabel
          Left = 8
          Top = 140
          Width = 42
          Height = 12
          Caption = #21464#37327#20845':'
        end
        object Label21: TLabel
          Left = 120
          Top = 92
          Width = 42
          Height = 12
          Caption = #21464#37327#21313':'
        end
        object Label22: TLabel
          Left = 120
          Top = 20
          Width = 42
          Height = 12
          Caption = #21464#37327#19971':'
        end
        object Label23: TLabel
          Left = 120
          Top = 44
          Width = 42
          Height = 12
          Caption = #21464#37327#20843':'
        end
        object Label24: TLabel
          Left = 120
          Top = 68
          Width = 42
          Height = 12
          Caption = #21464#37327#20061':'
        end
        object EditGlobalVal1: TEdit
          Left = 56
          Top = 16
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditGlobalVal2: TEdit
          Left = 56
          Top = 40
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
        object EditGlobalVal3: TEdit
          Left = 56
          Top = 64
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 2
        end
        object EditGlobalVal4: TEdit
          Left = 56
          Top = 88
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 3
        end
        object EditGlobalVal5: TEdit
          Left = 56
          Top = 112
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 4
        end
        object EditGlobalVal6: TEdit
          Left = 56
          Top = 136
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 5
        end
        object EditGlobalVal7: TEdit
          Left = 168
          Top = 16
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 6
        end
        object EditGlobalVal8: TEdit
          Left = 168
          Top = 40
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 7
        end
        object EditGlobalVal9: TEdit
          Left = 168
          Top = 64
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 8
        end
        object EditGlobalVal10: TEdit
          Left = 168
          Top = 88
          Width = 57
          Height = 20
          ReadOnly = True
          TabOrder = 9
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = #24037#20316#32447#31243
      ImageIndex = 4
      object GroupBox7: TGroupBox
        Left = 8
        Top = 4
        Width = 425
        Height = 165
        Caption = #32447#31243#29366#24577
        TabOrder = 0
        object GridThread: TStringGrid
          Left = 8
          Top = 16
          Width = 409
          Height = 137
          DefaultRowHeight = 18
          FixedCols = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
          TabOrder = 0
          ColWidths = (
            35
            50
            51
            90
            64)
        end
      end
    end
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 328
    Top = 176
  end
end
