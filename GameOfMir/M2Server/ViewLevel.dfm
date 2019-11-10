object frmViewLevel: TfrmViewLevel
  Left = 498
  Top = 232
  Width = 326
  Height = 310
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #20154#29289#31561#32423#23646#24615
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
  object GroupBox10: TGroupBox
    Left = 8
    Top = 8
    Width = 121
    Height = 49
    Caption = #20154#29289#31561#32423
    TabOrder = 0
    object Label4: TLabel
      Left = 8
      Top = 20
      Width = 30
      Height = 12
      Caption = #31561#32423':'
    end
    object EditHumanLevel: TSpinEdit
      Left = 44
      Top = 15
      Width = 45
      Height = 21
      EditorEnabled = False
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 1
      OnChange = EditHumanLevelChange
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 64
    Width = 121
    Height = 49
    Caption = #20154#29289#32844#19994
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 30
      Height = 12
      Caption = #32844#19994':'
    end
    object ComboBoxJob: TComboBox
      Left = 40
      Top = 16
      Width = 73
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 0
      Text = #27494#22763
      OnChange = ComboBoxJobChange
      Items.Strings = (
        #27494#22763
        #39764#27861#24072
        #36947#22763)
    end
  end
  object GridHumanInfo: TStringGrid
    Left = 136
    Top = 8
    Width = 169
    Height = 257
    ColCount = 2
    DefaultRowHeight = 18
    RowCount = 13
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    TabOrder = 2
    ColWidths = (
      64
      99)
    RowHeights = (
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18)
  end
  object ButtonClose: TButton
    Left = 32
    Top = 152
    Width = 65
    Height = 25
    Caption = #20851#38381'(&C)'
    TabOrder = 3
    OnClick = ButtonCloseClick
  end
end
