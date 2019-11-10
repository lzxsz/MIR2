object frmCertServerSet: TfrmCertServerSet
  Left = 266
  Top = 263
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #39564#35777#26381#21153#22120#22320#22336#35774#32622
  ClientHeight = 170
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 193
    Height = 73
    Caption = #28216#25103#32593#20851#39564#35777#26381#21153#22120
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 18
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#22320#22336':'
    end
    object Label2: TLabel
      Left = 8
      Top = 42
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#22320#22336':'
    end
    object EditRunGate_Config_RegServerAddr: TEdit
      Left = 80
      Top = 16
      Width = 97
      Height = 20
      TabOrder = 0
      Text = '000.000.000.000'
      OnChange = EditChange
    end
    object EditRunGate_Config_RegServerPort: TEdit
      Left = 80
      Top = 40
      Width = 65
      Height = 20
      TabOrder = 1
      Text = '88888'
      OnChange = EditChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 88
    Width = 193
    Height = 73
    Caption = #25968#25454#24211#39564#35777#26381#21153#22120
    TabOrder = 1
    object Label3: TLabel
      Left = 8
      Top = 18
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#22320#22336':'
    end
    object Label4: TLabel
      Left = 8
      Top = 42
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#22320#22336':'
    end
    object EditDBServer_Config_RegServerAddr: TEdit
      Left = 80
      Top = 16
      Width = 97
      Height = 20
      TabOrder = 0
      Text = '000.000.000.000'
      OnChange = EditChange
    end
    object EditDBServer_Config_RegServerPort: TEdit
      Left = 80
      Top = 40
      Width = 65
      Height = 20
      TabOrder = 1
      Text = '88888'
      OnChange = EditChange
    end
  end
  object GroupBox3: TGroupBox
    Left = 208
    Top = 8
    Width = 193
    Height = 73
    Caption = #28216#25103#24341#25806#39564#35777#26381#21153#22120
    TabOrder = 2
    object Label5: TLabel
      Left = 8
      Top = 18
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#22320#22336':'
    end
    object Label6: TLabel
      Left = 8
      Top = 42
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#22320#22336':'
    end
    object EditM2Server_Config_RegServerAddr: TEdit
      Left = 80
      Top = 16
      Width = 97
      Height = 20
      TabOrder = 0
      Text = '000.000.000.000'
      OnChange = EditChange
    end
    object EditM2Server_Config_RegServerPort: TEdit
      Left = 80
      Top = 40
      Width = 65
      Height = 20
      TabOrder = 1
      Text = '88888'
      OnChange = EditChange
    end
  end
  object ButtonOK: TButton
    Left = 336
    Top = 128
    Width = 65
    Height = 25
    Caption = #30830#23450'(&O)'
    TabOrder = 3
    OnClick = ButtonOKClick
  end
end
