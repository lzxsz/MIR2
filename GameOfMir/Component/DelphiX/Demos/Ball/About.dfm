object FormAbout: TFormAbout
  Left = 223
  Top = 109
  Width = 404
  Height = 266
  Caption = 'Information about The Pool'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -32
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 37
  object LabelAbout: TLabel
    Left = 152
    Top = 56
    Width = 89
    Height = 37
    Caption = 'POOL'
  end
  object LabelAuthor: TLabel
    Left = 128
    Top = 120
    Width = 136
    Height = 24
    Caption = 'Panu Niva  2000'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 160
    Top = 176
    Width = 75
    Height = 25
    Caption = 'ok'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
end
