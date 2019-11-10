object frmPrefConfig: TfrmPrefConfig
  Left = 427
  Top = 211
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #24615#33021#35774#32622
  ClientHeight = 149
  ClientWidth = 193
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBoxServer: TGroupBox
    Left = 8
    Top = 8
    Width = 177
    Height = 49
    Caption = #26381#21153#22120#36890#35759
    TabOrder = 0
    object LabelCheckTimeOut: TLabel
      Left = 8
      Top = 20
      Width = 54
      Height = 12
      Caption = #26816#27979#36229#26102':'
    end
    object Label1: TLabel
      Left = 136
      Top = 20
      Width = 12
      Height = 12
      Caption = #31186
    end
    object EditServerCheckTimeOut: TSpinEdit
      Left = 72
      Top = 16
      Width = 49
      Height = 21
      EditorEnabled = False
      Increment = 30
      MaxLength = 600
      MaxValue = 60
      MinValue = 60
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Value = 0
      OnChange = EditServerCheckTimeOutChange
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 64
    Width = 177
    Height = 49
    Caption = #23458#25143#31471#36890#35759
    TabOrder = 1
    object LabelSendBlockSize: TLabel
      Left = 8
      Top = 20
      Width = 54
      Height = 12
      Caption = #25968#25454#22823#23567':'
    end
    object Label3: TLabel
      Left = 144
      Top = 20
      Width = 24
      Height = 12
      Caption = #23383#33410
    end
    object EditSendBlockSize: TSpinEdit
      Left = 78
      Top = 16
      Width = 57
      Height = 21
      Hint = #21457#36865#32473#23458#25143#31471#25968#25454#21253#22823#23567
      EditorEnabled = False
      Increment = 50
      MaxLength = 600
      MaxValue = 5000
      MinValue = 100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Value = 100
      OnChange = EditSendBlockSizeChange
    end
  end
  object ButtonOK: TButton
    Left = 118
    Top = 122
    Width = 65
    Height = 24
    Caption = #30830#23450'(&O)'
    TabOrder = 2
    OnClick = ButtonOKClick
  end
end
