object frmGlobaSession: TfrmGlobaSession
  Left = 185
  Top = 147
  BorderStyle = bsSingle
  Caption = #26597#30475#20840#23616#20250#35805
  ClientHeight = 210
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object StringGrid: TStringGrid
    Left = 8
    Top = 13
    Width = 523
    Height = 163
    DefaultRowHeight = 18
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    TabOrder = 0
    ColWidths = (
      69
      73
      70
      121
      64)
  end
  object RefTimer: TTimer
    Enabled = False
    OnTimer = RefTimerTimer
    Left = 329
    Top = 179
  end
end
