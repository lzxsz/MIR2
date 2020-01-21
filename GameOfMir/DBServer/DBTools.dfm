object frmDBTool: TfrmDBTool
  Left = 224
  Top = 281
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #25968#25454#31649#29702#24037#20855
  ClientHeight = 296
  ClientWidth = 597
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 577
    Height = 273
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #25968#25454#24211#20449#24687
      object GroupBox1: TGroupBox
        Left = 9
        Top = 3
        Width = 273
        Height = 233
        Caption = #20154#29289#20449#24687#25968#25454#24211'(Mir.DB)'
        TabOrder = 0
        object GridMirDBInfo: TStringGrid
          Left = 8
          Top = 16
          Width = 257
          Height = 201
          ColCount = 2
          DefaultRowHeight = 18
          RowCount = 10
          TabOrder = 0
          ColWidths = (
            64
            181)
        end
      end
      object GroupBox2: TGroupBox
        Left = 288
        Top = 4
        Width = 273
        Height = 233
        Caption = #20154#29289#25968#25454#24211'(Hum.DB)'
        TabOrder = 1
        object GridHumDBInfo: TStringGrid
          Left = 8
          Top = 16
          Width = 257
          Height = 201
          ColCount = 2
          DefaultRowHeight = 18
          RowCount = 10
          TabOrder = 0
          ColWidths = (
            64
            181)
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #25968#25454#24211#37325#24314
      ImageIndex = 1
      object LabelProcess: TLabel
        Left = 8
        Top = 224
        Width = 64
        Height = 13
        Caption = 'LabelProcess'
      end
      object ButtonStartRebuild: TButton
        Left = 8
        Top = 8
        Width = 113
        Height = 25
        Caption = #24320#22987'(&S)'
        TabOrder = 0
        OnClick = ButtonStartRebuildClick
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 48
        Width = 185
        Height = 121
        Caption = #37325#24314#36873#39033
        TabOrder = 1
        object CheckBoxDelDenyChr: TCheckBox
          Left = 16
          Top = 16
          Width = 113
          Height = 17
          Caption = #21024#38500#24050#31105#29992#30340#35282#33394
          TabOrder = 0
          OnClick = CheckBoxDelDenyChrClick
        end
        object CheckBoxDelAllItem: TCheckBox
          Left = 16
          Top = 48
          Width = 113
          Height = 17
          Caption = #21024#38500#20154#29289#29289#21697
          TabOrder = 1
          OnClick = CheckBoxDelAllItemClick
        end
        object CheckBoxDelAllSkill: TCheckBox
          Left = 16
          Top = 64
          Width = 113
          Height = 17
          Caption = #21024#38500#20154#29289#25216#33021
          TabOrder = 2
          OnClick = CheckBoxDelAllSkillClick
        end
        object CheckBoxDelBonusAbil: TCheckBox
          Left = 16
          Top = 80
          Width = 113
          Height = 17
          Caption = #21024#38500#20154#29289#23646#24615#28857
          TabOrder = 3
          OnClick = CheckBoxDelBonusAbilClick
        end
        object CheckBoxDelLevel: TCheckBox
          Left = 16
          Top = 32
          Width = 153
          Height = 17
          Caption = #21024#38500#20154#29289#31561#32423#21450#30456#20851#20449#24687
          TabOrder = 4
          OnClick = CheckBoxDelLevelClick
        end
      end
    end
  end
  object TimerShowInfo: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerShowInfoTimer
    Left = 104
    Top = 248
  end
end
