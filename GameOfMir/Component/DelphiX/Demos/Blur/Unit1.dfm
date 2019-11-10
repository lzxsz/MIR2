object Form1: TForm1
  Left = 205
  Top = 138
  Width = 218
  Height = 112
  Caption = 'Gaussian blur'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 46
    Height = 13
    Caption = 'Blur level:'
  end
  object Button1: TButton
    Left = 104
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Blur'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 40
    Width = 73
    Height = 21
    TabOrder = 1
    Text = '5'
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 168
    Top = 8
  end
end
