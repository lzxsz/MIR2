object frmViewOnlineHuman: TfrmViewOnlineHuman
  Left = 274
  Top = 230
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #22312#32447#20154#29289
  ClientHeight = 262
  ClientWidth = 864
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 112
    Top = 234
    Width = 30
    Height = 12
    Caption = #25490#24207':'
  end
  object PanelStatus: TPanel
    Left = 0
    Top = 0
    Width = 864
    Height = 217
    Align = alTop
    Caption = #27491#22312#35835#21462#25968#25454'...'
    TabOrder = 0
    object GridHuman: TStringGrid
      Left = 1
      Top = 1
      Width = 862
      Height = 215
      Align = alClient
      ColCount = 14
      DefaultRowHeight = 18
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
      TabOrder = 0
      OnDblClick = GridHumanDblClick
      ColWidths = (
        33
        78
        31
        44
        39
        37
        47
        74
        89
        32
        150
        59
        55
        57)
    end
  end
  object ButtonRefGrid: TButton
    Left = 10
    Top = 228
    Width = 73
    Height = 25
    Caption = #21047#26032'(&R)'
    TabOrder = 1
    OnClick = ButtonRefGridClick
  end
  object ComboBoxSort: TComboBox
    Left = 152
    Top = 232
    Width = 113
    Height = 20
    Style = csDropDownList
    ItemHeight = 12
    TabOrder = 2
    OnClick = ComboBoxSortClick
    Items.Strings = (
      #21517#31216
      #24615#21035
      #32844#19994
      #31561#32423
      #22320#22270
      'IP'
      #26435#38480
      #25152#22312#22320#21306)
  end
  object EditSearchName: TEdit
    Left = 320
    Top = 232
    Width = 129
    Height = 20
    TabOrder = 3
  end
  object ButtonSearch: TButton
    Left = 456
    Top = 228
    Width = 73
    Height = 25
    Caption = #25628#32034'(&S)'
    TabOrder = 4
    OnClick = ButtonSearchClick
  end
  object ButtonView: TButton
    Left = 599
    Top = 228
    Width = 80
    Height = 25
    Caption = #20154#29289#20449#24687'(&V)'
    TabOrder = 5
    OnClick = ButtonViewClick
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 288
    Top = 229
  end
end
