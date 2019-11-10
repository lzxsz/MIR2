object Form1: TForm1
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Perlin Noise Example - By Michael Hansen'
  ClientHeight = 270
  ClientWidth = 398
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 4
    Top = 2
    Width = 260
    Height = 260
    Shape = bsFrame
    Style = bsRaised
  end
  object Label1: TLabel
    Left = 270
    Top = 180
    Width = 26
    Height = 13
    Caption = 'View:'
  end
  object Label2: TLabel
    Left = 270
    Top = 220
    Width = 44
    Height = 13
    Caption = 'Grainess:'
  end
  object Draw: TButton
    Left = 170
    Top = 180
    Width = 36
    Height = 25
    Caption = 'Draw'
    TabOrder = 0
    Visible = False
    OnClick = DrawClick
  end
  object NoiseGen: TButton
    Left = 270
    Top = 5
    Width = 116
    Height = 26
    Caption = 'Generate Noise'
    TabOrder = 1
    OnClick = NoiseGenClick
  end
  object NoiseRadio: TRadioGroup
    Left = 270
    Top = 35
    Width = 116
    Height = 56
    Caption = 'Noise type:'
    Items.Strings = (
      'Grayscale'
      'Monochrome')
    TabOrder = 2
    OnClick = NoiseRadioClick
  end
  object SmoothRadio: TRadioGroup
    Left = 270
    Top = 100
    Width = 116
    Height = 61
    Caption = 'Smoothen settings:'
    Items.Strings = (
      'Interpolation'
      'None')
    TabOrder = 3
    OnClick = SmoothRadioClick
  end
  object ViewCombo: TComboBox
    Left = 270
    Top = 195
    Width = 116
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    Text = 'Mixed Layers'
    OnChange = ViewComboChange
  end
  object Edit1: TEdit
    Left = 270
    Top = 235
    Width = 46
    Height = 21
    TabOrder = 5
    Text = '128'
  end
  object UpDown1: TUpDown
    Left = 316
    Top = 235
    Width = 15
    Height = 21
    Associate = Edit1
    Max = 255
    Increment = 3
    Position = 128
    TabOrder = 6
    OnClick = UpDown1Click
  end
end
