object frmViewSession: TfrmViewSession
  Left = 359
  Top = 235
  Width = 446
  Height = 208
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #26597#30475#20840#23616#20250#35805
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
  object ButtonRefGrid: TButton
    Left = 8
    Top = 138
    Width = 73
    Height = 24
    Caption = #21047#26032'(&R)'
    TabOrder = 0
    OnClick = ButtonRefGridClick
  end
  object PanelStatus: TPanel
    Left = 0
    Top = 0
    Width = 430
    Height = 129
    Align = alTop
    TabOrder = 1
    object GridSession: TStringGrid
      Left = 1
      Top = 1
      Width = 428
      Height = 127
      Align = alClient
      ColCount = 6
      DefaultRowHeight = 18
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      ColWidths = (
        34
        83
        86
        73
        67
        72)
    end
  end
end
