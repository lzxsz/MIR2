object FrmSetting: TFrmSetting
  Left = 372
  Top = 229
  BorderStyle = bsDialog
  Caption = #22522#26412#35774#32622
  ClientHeight = 153
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 305
    Height = 105
    Caption = #22522#26412#35774#32622
    TabOrder = 0
    object CheckBoxAttack: TCheckBox
      Left = 16
      Top = 16
      Width = 89
      Height = 17
      Caption = #38450#25915#20987#20445#25252
      TabOrder = 0
      OnClick = CheckBoxAttackClick
    end
    object CheckBoxDenyChrName: TCheckBox
      Left = 16
      Top = 40
      Width = 145
      Height = 17
      Caption = #20801#35768#29305#27530#23383#31526#21019#24314#20154#29289
      TabOrder = 1
      OnClick = CheckBoxDenyChrNameClick
    end
  end
  object ButtonOK: TButton
    Left = 240
    Top = 120
    Width = 75
    Height = 25
    Caption = #30830#23450'(&O)'
    TabOrder = 1
    OnClick = ButtonOKClick
  end
end
