object frmConfigMonGen: TfrmConfigMonGen
  Left = 295
  Top = 215
  Width = 680
  Height = 415
  Caption = #21047#24618#37197#32622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 352
    Width = 306
    Height = 12
    Caption = #35828#26126':'#20808#28857#20987#21152#36733#65292#20877#28857#29190#29575#25991#20214#26368#21491#36793#20250#20986#29616#29190#29575#20869#23481#12290
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 408
    Top = 8
    Width = 251
    Height = 361
    Caption = #29190#29575#32534#36753
    TabOrder = 0
    object Memo1: TMemo
      Left = 8
      Top = 16
      Width = 235
      Height = 300
      Hint = #20462#25913#24618#29289#29190#29575'.'
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object Button1: TButton
      Left = 32
      Top = 328
      Width = 75
      Height = 25
      Caption = #21152#36733'(&S)'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 160
      Top = 328
      Width = 75
      Height = 25
      Caption = #20445#23384'(&B)'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 208
    Top = 8
    Width = 197
    Height = 325
    Caption = #24618#29289#21015#34920
    TabOrder = 1
    object ListBox1: TListBox
      Left = 8
      Top = 16
      Width = 181
      Height = 300
      ItemHeight = 13
      TabOrder = 0
      OnClick = ListBox1Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 8
    Width = 197
    Height = 325
    Caption = #21047#24618#21015#34920
    TabOrder = 2
    object ListBoxMonGen: TListBox
      Left = 8
      Top = 16
      Width = 181
      Height = 300
      Hint = #24618#29289#21015#34920'!'
      ItemHeight = 13
      TabOrder = 0
    end
  end
end
