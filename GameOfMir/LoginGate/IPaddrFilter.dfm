object frmIPaddrFilter: TfrmIPaddrFilter
  Left = 198
  Top = 273
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #32593#32476#23433#20840#36807#28388
  ClientHeight = 306
  ClientWidth = 619
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
  object GroupBoxActive: TGroupBox
    Left = 8
    Top = 8
    Width = 137
    Height = 289
    Caption = #24403#21069#36830#25509
    TabOrder = 0
    object Label4: TLabel
      Left = 8
      Top = 24
      Width = 54
      Height = 12
      Caption = #36830#25509#21015#34920':'
    end
    object ListBoxActiveList: TListBox
      Left = 8
      Top = 40
      Width = 121
      Height = 241
      Hint = #24403#21069#36830#25509#30340'IP'#22320#22336#21015#34920
      ItemHeight = 12
      Items.Strings = (
        '888.888.888.888')
      ParentShowHint = False
      PopupMenu = ActiveListPopupMenu
      ShowHint = True
      Sorted = True
      TabOrder = 0
    end
  end
  object GroupBox1: TGroupBox
    Left = 152
    Top = 8
    Width = 265
    Height = 289
    Caption = #36807#28388#21015#34920
    TabOrder = 1
    object LabelTempList: TLabel
      Left = 8
      Top = 24
      Width = 54
      Height = 12
      Caption = #21160#24577#36807#28388':'
    end
    object Label1: TLabel
      Left = 136
      Top = 24
      Width = 54
      Height = 12
      Caption = #27704#20037#36807#28388':'
    end
    object ListBoxTempList: TListBox
      Left = 8
      Top = 40
      Width = 121
      Height = 241
      Hint = #21160#24577#36807#28388#21015#34920','#22312#27492#21015#34920#20013#30340'IP'#23558#26080#27861#24314#31435#36830#25509','#20294#22312#31243#24207#37325#26032#21551#21160#26102#27492#21015#34920#30340#20449#24687#23558#34987#28165#31354
      ItemHeight = 12
      Items.Strings = (
        '888.888.888.888')
      ParentShowHint = False
      PopupMenu = TempBlockListPopupMenu
      ShowHint = True
      Sorted = True
      TabOrder = 0
    end
    object ListBoxBlockList: TListBox
      Left = 136
      Top = 40
      Width = 121
      Height = 241
      Hint = #27704#20037#36807#28388#21015#34920','#22312#27492#21015#34920#20013#30340'IP'#23558#26080#27861#24314#31435#36830#25509','#27492#21015#34920#23558#20445#23384#20110#37197#32622#25991#20214#20013','#22312#31243#24207#37325#26032#21551#21160#26102#20250#37325#26032#21152#36733#27492#21015#34920
      ItemHeight = 12
      Items.Strings = (
        '888.888.888.888')
      ParentShowHint = False
      PopupMenu = BlockListPopupMenu
      ShowHint = True
      Sorted = True
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 424
    Top = 8
    Width = 185
    Height = 253
    Caption = #25915#20987#20445#25252
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 54
      Height = 12
      Caption = #36830#25509#38480#21046':'
    end
    object Label3: TLabel
      Left = 136
      Top = 24
      Width = 42
      Height = 12
      Caption = #36830#25509'/IP'
    end
    object Label7: TLabel
      Left = 32
      Top = 224
      Width = 120
      Height = 12
      Caption = #20197#19978#21442#25968#35843#21518#31435#21363#29983#25928
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object EditMaxConnect: TSpinEdit
      Left = 64
      Top = 19
      Width = 65
      Height = 21
      Hint = #21333#20010'IP'#22320#22336','#26368#22810#21487#20197#24314#31435#36830#25509#25968','#36229#36807#25351#23450#36830#25509#25968#23558#25353#19979#38754#30340#25805#20316#22788#29702
      EditorEnabled = False
      MaxValue = 1000
      MinValue = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Value = 50
      OnChange = EditMaxConnectChange
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 122
      Width = 169
      Height = 89
      Caption = #25915#20987#25805#20316
      TabOrder = 1
      object RadioAddBlockList: TRadioButton
        Left = 16
        Top = 64
        Width = 129
        Height = 17
        Hint = #23558#27492#36830#25509#30340'IP'#21152#20837#27704#20037#36807#28388#21015#34920','#24182#23558#27492'IP'#30340#25152#26377#36830#25509#24378#34892#20013#26029
        Caption = #21152#20837#27704#20037#36807#28388#21015#34920
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = RadioAddBlockListClick
      end
      object RadioAddTempList: TRadioButton
        Left = 16
        Top = 40
        Width = 129
        Height = 17
        Hint = #23558#27492#36830#25509#30340'IP'#21152#20837#21160#24577#36807#28388#21015#34920','#24182#23558#27492'IP'#30340#25152#26377#36830#25509#24378#34892#20013#26029
        Caption = #21152#20837#21160#24577#36807#28388#21015#34920
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = RadioAddTempListClick
      end
      object RadioDisConnect: TRadioButton
        Left = 16
        Top = 16
        Width = 129
        Height = 17
        Hint = #23558#36830#25509#31616#21333#30340#26029#24320#22788#29702
        Caption = #26029#24320#36830#25509
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = RadioDisConnectClick
      end
    end
  end
  object ButtonOK: TButton
    Left = 524
    Top = 272
    Width = 80
    Height = 25
    Caption = #30830#23450'(&O)'
    Default = True
    TabOrder = 3
    OnClick = ButtonOKClick
  end
  object BlockListPopupMenu: TPopupMenu
    OnPopup = BlockListPopupMenuPopup
    Left = 376
    Top = 160
    object BPOPMENU_REFLIST: TMenuItem
      Caption = #21047#26032'(&R)'
      OnClick = BPOPMENU_REFLISTClick
    end
    object BPOPMENU_SORT: TMenuItem
      Caption = #25490#24207'(&S)'
      OnClick = BPOPMENU_SORTClick
    end
    object BPOPMENU_ADD: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = BPOPMENU_ADDClick
    end
    object BPOPMENU_ADDTEMPLIST: TMenuItem
      Caption = #21152#20837#21160#24577#36807#28388#21015#34920'(&A)'
      OnClick = BPOPMENU_ADDTEMPLISTClick
    end
    object BPOPMENU_DELETE: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = BPOPMENU_DELETEClick
    end
  end
  object TempBlockListPopupMenu: TPopupMenu
    OnPopup = TempBlockListPopupMenuPopup
    Left = 216
    Top = 160
    object TPOPMENU_REFLIST: TMenuItem
      Caption = #21047#26032'(&R)'
      OnClick = TPOPMENU_REFLISTClick
    end
    object TPOPMENU_SORT: TMenuItem
      Caption = #25490#24207'(&S)'
      OnClick = TPOPMENU_SORTClick
    end
    object TPOPMENU_ADD: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = TPOPMENU_ADDClick
    end
    object TPOPMENU_BLOCKLIST: TMenuItem
      Caption = #21152#20837#27704#20037#36807#28388#21015#34920'(&D)'
      OnClick = TPOPMENU_BLOCKLISTClick
    end
    object TPOPMENU_DELETE: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = TPOPMENU_DELETEClick
    end
  end
  object ActiveListPopupMenu: TPopupMenu
    OnPopup = ActiveListPopupMenuPopup
    Left = 32
    Top = 160
    object APOPMENU_REFLIST: TMenuItem
      Caption = #21047#26032'(&R)'
      OnClick = APOPMENU_REFLISTClick
    end
    object APOPMENU_SORT: TMenuItem
      Caption = #25490#24207'(&S)'
      OnClick = APOPMENU_SORTClick
    end
    object APOPMENU_ADDTEMPLIST: TMenuItem
      Caption = #21152#20837#21160#24577#36807#28388#21015#34920'(&A)'
      OnClick = APOPMENU_ADDTEMPLISTClick
    end
    object APOPMENU_BLOCKLIST: TMenuItem
      Caption = #21152#20837#27704#20037#36807#28388#21015#34920'(&D)'
      OnClick = APOPMENU_BLOCKLISTClick
    end
    object APOPMENU_KICK: TMenuItem
      Caption = #36386#38500#19979#32447'(&K)'
      OnClick = APOPMENU_KICKClick
    end
  end
end
