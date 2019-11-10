object frmDlgConfig: TfrmDlgConfig
  Left = 324
  Top = 196
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #28216#25103#31383#21475#35774#32622
  ClientHeight = 304
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 75
    Height = 13
    Caption = #28216#25103#31383#21475#21015#34920':'
  end
  object DlgList: TListBox
    Left = 8
    Top = 24
    Width = 153
    Height = 265
    ItemHeight = 13
    TabOrder = 0
    OnClick = DlgListClick
  end
  object GameWindowName: TGroupBox
    Left = 168
    Top = 16
    Width = 129
    Height = 177
    Caption = #30456#20851#35774#32622
    Enabled = False
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 18
      Width = 22
      Height = 13
      Caption = 'Top:'
    end
    object Label3: TLabel
      Left = 8
      Top = 42
      Width = 21
      Height = 13
      Caption = 'Left:'
    end
    object Label4: TLabel
      Left = 8
      Top = 66
      Width = 31
      Height = 13
      Caption = 'Width:'
    end
    object Label5: TLabel
      Left = 8
      Top = 90
      Width = 34
      Height = 13
      Caption = 'Height:'
    end
    object Label6: TLabel
      Left = 8
      Top = 114
      Width = 32
      Height = 13
      Caption = 'Image:'
    end
    object EditTop: TSpinEdit
      Left = 48
      Top = 16
      Width = 65
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
      OnChange = EditTopChange
    end
    object EditLeft: TSpinEdit
      Left = 48
      Top = 40
      Width = 65
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnChange = EditLeftChange
    end
    object EditHeight: TSpinEdit
      Left = 48
      Top = 88
      Width = 65
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
      OnChange = EditHeightChange
    end
    object EditWidth: TSpinEdit
      Left = 48
      Top = 64
      Width = 65
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 0
      OnChange = EditWidthChange
    end
    object EditImage: TSpinEdit
      Left = 48
      Top = 112
      Width = 65
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 0
      OnChange = EditImageChange
    end
    object ButtonShow: TButton
      Left = 24
      Top = 144
      Width = 73
      Height = 25
      Caption = #26174#31034#31383#21475
      TabOrder = 5
      OnClick = ButtonShowClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 304
    Top = 16
    Width = 129
    Height = 81
    Caption = 'GroupBox1'
    TabOrder = 2
    object Label7: TLabel
      Left = 8
      Top = 18
      Width = 10
      Height = 13
      Caption = 'X:'
    end
    object Label8: TLabel
      Left = 8
      Top = 42
      Width = 10
      Height = 13
      Caption = 'Y:'
    end
    object EditTestX: TSpinEdit
      Left = 48
      Top = 16
      Width = 65
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
      OnChange = EditTestXChange
    end
    object EditTestY: TSpinEdit
      Left = 48
      Top = 40
      Width = 65
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnChange = EditTestYChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 352
    Top = 200
    Width = 161
    Height = 105
    Caption = #36895#24230#35843#25972
    TabOrder = 3
    object Label9: TLabel
      Left = 8
      Top = 18
      Width = 27
      Height = 13
      Caption = #39764#27861':'
    end
    object Label10: TLabel
      Left = 8
      Top = 42
      Width = 27
      Height = 13
      Caption = #25915#20987':'
    end
    object EditSpellTime: TSpinEdit
      Left = 48
      Top = 16
      Width = 65
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
      OnChange = EditSpellTimeChange
    end
    object EditHitTime: TSpinEdit
      Left = 48
      Top = 40
      Width = 65
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnChange = EditHitTimeChange
    end
  end
  object GroupBox3: TGroupBox
    Left = 176
    Top = 208
    Width = 169
    Height = 89
    Caption = 'GroupBox3'
    TabOrder = 4
    object CheckBoxDrawTileMap: TCheckBox
      Left = 8
      Top = 16
      Width = 121
      Height = 17
      Caption = #26174#31034#22320#22270'Title'
      TabOrder = 0
      OnClick = CheckBoxDrawTileMapClick
    end
    object CheckBoxDrawDropItem: TCheckBox
      Left = 8
      Top = 32
      Width = 153
      Height = 17
      Caption = #26174#31034#22320#38754#29289#21697
      TabOrder = 1
      OnClick = CheckBoxDrawDropItemClick
    end
  end
  object GroupBox4: TGroupBox
    Left = 440
    Top = 16
    Width = 185
    Height = 137
    Caption = 'GroupBox4'
    TabOrder = 5
    object Label11: TLabel
      Left = 8
      Top = 20
      Width = 39
      Height = 13
      Caption = #27880#20876#21495':'
    end
    object Label12: TLabel
      Left = 8
      Top = 44
      Width = 51
      Height = 13
      Caption = #26381#21153#22120#21517':'
    end
    object Label13: TLabel
      Left = 8
      Top = 68
      Width = 51
      Height = 13
      Caption = #27880#20876#22320#22336':'
    end
    object Label14: TLabel
      Left = 8
      Top = 92
      Width = 51
      Height = 13
      Caption = #27880#20876#31471#21475':'
    end
    object EditKey: TEdit
      Left = 64
      Top = 16
      Width = 105
      Height = 21
      TabOrder = 0
    end
    object EditServerName: TEdit
      Left = 64
      Top = 40
      Width = 105
      Height = 21
      TabOrder = 1
    end
    object EditRegIPaddr: TEdit
      Left = 64
      Top = 64
      Width = 105
      Height = 21
      TabOrder = 2
    end
    object EditRegPort: TEdit
      Left = 64
      Top = 88
      Width = 105
      Height = 21
      TabOrder = 3
    end
  end
end
