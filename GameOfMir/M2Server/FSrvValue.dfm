object FrmServerValue: TFrmServerValue
  Left = 348
  Top = 257
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #24615#33021#21442#25968#37197#32622
  ClientHeight = 206
  ClientWidth = 468
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label18: TLabel
    Left = 8
    Top = 185
    Width = 432
    Height = 12
    Caption = #35843#25972#30340#21442#25968#31435#21363#29983#25928#65292#22312#32447#26102#35831#30830#35748#27492#21442#25968#30340#20316#29992#20877#35843#25972#65292#20081#35843#25972#23558#23548#33268#28216#25103#28151#20081
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object BitBtn1: TBitBtn
    Left = 368
    Top = 144
    Width = 91
    Height = 25
    Caption = #30830#23450'(&O)'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = BitBtn1Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object CbViewHack: TCheckBox
    Left = 152
    Top = 136
    Width = 161
    Height = 17
    Caption = #26174#31034#28216#25103#36895#24230#24322#24120#20449#24687
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = CbViewHackClick
  end
  object CkViewAdmfail: TCheckBox
    Left = 152
    Top = 152
    Width = 169
    Height = 17
    Caption = #26174#31034#38750#27861#30331#24405#20449#24687
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = CkViewAdmfailClick
  end
  object GroupBox1: TGroupBox
    Left = 152
    Top = 8
    Width = 169
    Height = 121
    Caption = #32593#20851#25968#25454#20256#36755
    TabOrder = 3
    object Label8: TLabel
      Left = 11
      Top = 24
      Width = 66
      Height = 12
      Caption = #25968#25454#22359#22823#23567':'
    end
    object Label7: TLabel
      Left = 9
      Top = 48
      Width = 66
      Height = 12
      Caption = #33258#26816#25968#25454#22359':'
    end
    object Label9: TLabel
      Left = 7
      Top = 69
      Width = 66
      Height = 12
      Caption = #20445#30041#25968#25454#22359':'
      Enabled = False
    end
    object Label10: TLabel
      Left = 7
      Top = 93
      Width = 54
      Height = 12
      Caption = #36127#36733#27979#35797':'
    end
    object Label11: TLabel
      Left = 145
      Top = 24
      Width = 6
      Height = 12
      Caption = 'B'
    end
    object Label12: TLabel
      Left = 145
      Top = 48
      Width = 6
      Height = 12
      Caption = 'B'
    end
    object Label13: TLabel
      Left = 145
      Top = 72
      Width = 6
      Height = 12
      Caption = 'B'
    end
    object Label14: TLabel
      Left = 145
      Top = 96
      Width = 12
      Height = 12
      Caption = 'KB'
    end
    object EGateLoad: TSpinEdit
      Left = 78
      Top = 92
      Width = 59
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
      OnChange = EGateLoadChange
    end
    object EAvailableBlock: TSpinEdit
      Left = 78
      Top = 68
      Width = 59
      Height = 21
      Enabled = False
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnChange = EAvailableBlockChange
    end
    object ECheckBlock: TSpinEdit
      Left = 78
      Top = 44
      Width = 59
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
      OnChange = ECheckBlockChange
    end
    object ESendBlock: TSpinEdit
      Left = 78
      Top = 21
      Width = 59
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 0
      OnChange = ESendBlockChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 137
    Height = 161
    Caption = #22788#29702#26102#38388#20998#37197'('#27627#31186')'
    TabOrder = 4
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 54
      Height = 12
      Caption = #20154#29289#22788#29702':'
    end
    object Label2: TLabel
      Left = 16
      Top = 40
      Width = 54
      Height = 12
      Caption = #24618#29289#22788#29702':'
    end
    object Label3: TLabel
      Left = 16
      Top = 64
      Width = 54
      Height = 12
      Caption = #24618#29289#21047#26032':'
    end
    object Label4: TLabel
      Left = 16
      Top = 88
      Width = 54
      Height = 12
      Caption = #25968#25454#20256#36755':'
    end
    object Label5: TLabel
      Left = 16
      Top = 136
      Width = 48
      Height = 12
      Caption = 'NPC'#22788#29702':'
    end
    object Label6: TLabel
      Left = 16
      Top = 112
      Width = 54
      Height = 12
      Caption = #20445#30041#22788#29702':'
      Enabled = False
    end
    object EHum: TSpinEdit
      Left = 76
      Top = 13
      Width = 47
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
      OnChange = EHumChange
    end
    object EMon: TSpinEdit
      Left = 76
      Top = 37
      Width = 47
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnChange = EMonChange
    end
    object EZen: TSpinEdit
      Left = 76
      Top = 61
      Width = 47
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
      OnChange = EZenChange
    end
    object ESoc: TSpinEdit
      Left = 76
      Top = 85
      Width = 47
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 0
      OnChange = ESocChange
    end
    object ENpc: TSpinEdit
      Left = 76
      Top = 133
      Width = 47
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 0
      OnChange = ENpcChange
    end
    object EDec: TSpinEdit
      Left = 76
      Top = 109
      Width = 47
      Height = 21
      Enabled = False
      MaxValue = 0
      MinValue = 0
      TabOrder = 5
      Value = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 328
    Top = 8
    Width = 129
    Height = 89
    Caption = #24618#29289#22788#29702#25511#21046
    TabOrder = 5
    object Label15: TLabel
      Left = 8
      Top = 16
      Width = 54
      Height = 12
      Caption = #21047#24618#20493#25968':'
    end
    object Label16: TLabel
      Left = 8
      Top = 64
      Width = 54
      Height = 12
      Caption = #22788#29702#38388#38548':'
    end
    object Label17: TLabel
      Left = 8
      Top = 40
      Width = 54
      Height = 12
      Caption = #21047#24618#38388#38548':'
    end
    object EditZenMonRate: TSpinEdit
      Left = 68
      Top = 13
      Width = 47
      Height = 21
      MaxValue = 1000
      MinValue = 0
      TabOrder = 0
      Value = 1
      OnChange = EditZenMonRateChange
    end
    object EditProcessTime: TSpinEdit
      Left = 68
      Top = 61
      Width = 47
      Height = 21
      Increment = 10
      MaxValue = 1000
      MinValue = 0
      TabOrder = 1
      Value = 1
      OnChange = EditProcessTimeChange
    end
    object EditZenMonTime: TSpinEdit
      Left = 68
      Top = 37
      Width = 47
      Height = 21
      Increment = 10
      MaxValue = 1000
      MinValue = 0
      TabOrder = 2
      Value = 1
      OnChange = EditZenMonTimeChange
    end
  end
  object ButtonDefault: TButton
    Left = 368
    Top = 112
    Width = 89
    Height = 25
    Caption = #40664#35748#35774#32622
    TabOrder = 6
    OnClick = ButtonDefaultClick
  end
end
