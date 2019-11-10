object frmConfigMerchant: TfrmConfigMerchant
  Left = 119
  Top = 138
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '交易NPC配置'
  ClientHeight = 468
  ClientWidth = 1028
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '宋体'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 81
    Height = 15
    Caption = 'NPC列表:'
  end
  object ListBoxMerChant: TListBox
    Left = 10
    Top = 30
    Width = 501
    Height = 211
    ItemHeight = 15
    TabOrder = 0
    OnClick = ListBoxMerChantClick
  end
  object GroupBoxNPC: TGroupBox
    Left = 10
    Top = 250
    Width = 501
    Height = 171
    Enabled = False
    TabOrder = 1
    object Label2: TLabel
      Left = 10
      Top = 25
      Width = 68
      Height = 15
      Caption = '脚本名称:'
    end
    object Label3: TLabel
      Left = 260
      Top = 25
      Width = 26
      Height = 15
      Caption = '地图名称:'
    end
    object Label4: TLabel
      Left = 10
      Top = 55
      Width = 10
      Height = 15
      Caption = '座标X:'
    end
    object Label5: TLabel
      Left = 150
      Top = 55
      Width = 10
      Height = 15
      Caption = '座标Y:'
    end
    object Label6: TLabel
      Left = 10
      Top = 85
      Width = 78
      Height = 15
      Caption = '显示名称:'
    end
    object Label7: TLabel
      Left = 260
      Top = 85
      Width = 19
      Height = 15
      Caption = '方向:'
    end
    object Label8: TLabel
      Left = 380
      Top = 85
      Width = 28
      Height = 15
      Caption = '外形:'
    end
    object Label10: TLabel
      Left = 260
      Top = 55
      Width = 69
      Height = 15
      Caption = '地图描述:'
    end
    object Label11: TLabel
      Left = 360
      Top = 115
      Width = 55
      Height = 15
      Caption = '移动间隔:'
    end
    object EditScriptName: TEdit
      Left = 80
      Top = 20
      Width = 151
      Height = 23
      Hint = '脚本文件名称.文件名称以此名字加地图名组合为实际文件名.'
      TabOrder = 0
      OnChange = EditScriptNameChange
    end
    object EditMapName: TEdit
      Left = 330
      Top = 20
      Width = 151
      Height = 23
      Hint = '地图名称.'
      TabOrder = 1
      OnChange = EditMapNameChange
    end
    object EditShowName: TEdit
      Left = 88
      Top = 80
      Width = 151
      Height = 23
      TabOrder = 2
      OnChange = EditShowNameChange
    end
    object CheckBoxOfCastle: TCheckBox
      Left = 80
      Top = 110
      Width = 101
      Height = 21
      Hint = '指定此NPC属于城堡管理,当攻城时NPC将停止营业.'
      Caption = '属于城堡'
      TabOrder = 3
      OnClick = CheckBoxOfCastleClick
    end
    object ComboBoxDir: TComboBox
      Left = 300
      Top = 80
      Width = 61
      Height = 23
      Hint = '默认站立方向.'
      Style = csDropDownList
      ItemHeight = 15
      TabOrder = 4
      OnChange = ComboBoxDirChange
    end
    object EditImageIdx: TSpinEdit
      Left = 420
      Top = 79
      Width = 61
      Height = 24
      Hint = '外观图形.'
      EditorEnabled = False
      MaxValue = 65535
      MinValue = 0
      TabOrder = 5
      Value = 0
      OnChange = EditImageIdxChange
    end
    object EditX: TSpinEdit
      Left = 80
      Top = 49
      Width = 61
      Height = 24
      Hint = '当前座标X.'
      EditorEnabled = False
      MaxValue = 1000
      MinValue = 1
      TabOrder = 6
      Value = 1
      OnChange = EditXChange
    end
    object EditY: TSpinEdit
      Left = 170
      Top = 49
      Width = 61
      Height = 24
      Hint = '当前座标Y.'
      EditorEnabled = False
      MaxValue = 1000
      MinValue = 1
      TabOrder = 7
      Value = 1
      OnChange = EditYChange
    end
    object EditMapDesc: TEdit
      Left = 330
      Top = 50
      Width = 151
      Height = 23
      Enabled = False
      ReadOnly = True
      TabOrder = 8
    end
    object CheckBoxAutoMove: TCheckBox
      Left = 260
      Top = 110
      Width = 85
      Height = 21
      Hint = 'NPC会在地图进行随机移动'
      Caption = '自动移动'
      TabOrder = 9
      OnClick = CheckBoxAutoMoveClick
    end
    object EditMoveTime: TSpinEdit
      Left = 430
      Top = 109
      Width = 51
      Height = 24
      Hint = '随机移动间隔时间秒'
      EditorEnabled = False
      MaxValue = 65535
      MinValue = 0
      TabOrder = 10
      Value = 0
      OnChange = EditMoveTimeChange
    end
  end
  object GroupBoxScript: TGroupBox
    Left = 520
    Top = 10
    Width = 501
    Height = 451
    Enabled = False
    TabOrder = 2
    object MemoScript: TMemo
      Left = 10
      Top = 170
      Width = 481
      Height = 271
      ScrollBars = ssBoth
      TabOrder = 0
      OnChange = MemoScriptChange
    end
    object ButtonScriptSave: TButton
      Left = 420
      Top = 30
      Width = 71
      Height = 31
      Hint = '保存脚本文件'
      Caption = '保存(&S)'
      TabOrder = 1
      OnClick = ButtonScriptSaveClick
    end
    object GroupBox3: TGroupBox
      Left = 10
      Top = 20
      Width = 401
      Height = 141
      Caption = '脚本参数'
      TabOrder = 2
      object Label9: TLabel
        Left = 10
        Top = 110
        Width = 57
        Height = 15
        Caption = '交易折扣:'
      end
      object CheckBoxBuy: TCheckBox
        Left = 10
        Top = 20
        Width = 41
        Height = 21
        Caption = '买'
        TabOrder = 0
        OnClick = CheckBoxBuyClick
      end
      object CheckBoxSell: TCheckBox
        Left = 10
        Top = 40
        Width = 41
        Height = 21
        Caption = '卖'
        TabOrder = 1
        OnClick = CheckBoxSellClick
      end
      object CheckBoxStorage: TCheckBox
        Left = 90
        Top = 40
        Width = 81
        Height = 21
        Caption = '取仓库'
        TabOrder = 2
        OnClick = CheckBoxStorageClick
      end
      object CheckBoxGetback: TCheckBox
        Left = 90
        Top = 20
        Width = 81
        Height = 21
        Caption = '存仓库'
        TabOrder = 3
        OnClick = CheckBoxGetbackClick
      end
      object CheckBoxMakedrug: TCheckBox
        Left = 300
        Top = 60
        Width = 91
        Height = 21
        Caption = '合成物品'
        TabOrder = 4
        OnClick = CheckBoxMakedrugClick
      end
      object CheckBoxUpgradenow: TCheckBox
        Left = 190
        Top = 20
        Width = 91
        Height = 21
        Caption = '升级武器'
        TabOrder = 5
        OnClick = CheckBoxUpgradenowClick
      end
      object CheckBoxGetbackupgnow: TCheckBox
        Left = 190
        Top = 40
        Width = 91
        Height = 21
        Caption = '取回升级'
        TabOrder = 6
        OnClick = CheckBoxGetbackupgnowClick
      end
      object CheckBoxRepair: TCheckBox
        Left = 300
        Top = 20
        Width = 91
        Height = 21
        Caption = '修理物品'
        TabOrder = 7
        OnClick = CheckBoxRepairClick
      end
      object CheckBoxS_repair: TCheckBox
        Left = 300
        Top = 40
        Width = 91
        Height = 21
        Caption = '特殊修理'
        TabOrder = 8
        OnClick = CheckBoxS_repairClick
      end
      object EditPriceRate: TSpinEdit
        Left = 80
        Top = 105
        Width = 61
        Height = 24
        Hint = 'NPC交易时折扣,80为80%'
        EditorEnabled = False
        MaxValue = 500
        MinValue = 60
        TabOrder = 9
        Value = 60
        OnChange = EditPriceRateChange
      end
      object CheckBoxSendMsg: TCheckBox
        Left = 90
        Top = 60
        Width = 103
        Height = 21
        Caption = '祝福语'
        TabOrder = 10
        OnClick = CheckBoxSendMsgClick
      end
    end
    object ButtonReLoadNpc: TButton
      Left = 420
      Top = 70
      Width = 71
      Height = 31
      Hint = '重新加载NPC脚本.'
      Caption = '加载(&L)'
      Enabled = False
      TabOrder = 3
      OnClick = ButtonReLoadNpcClick
    end
  end
  object ButtonSave: TButton
    Left = 10
    Top = 430
    Width = 71
    Height = 31
    Hint = '保存交易NPC设置'
    Caption = '保存(&S)'
    TabOrder = 3
    OnClick = ButtonSaveClick
  end
  object CheckBoxDenyRefStatus: TCheckBox
    Left = 378
    Top = 430
    Width = 119
    Height = 21
    Hint = '使用此方法,可以刷新NPC在游戏中的数据,打开此选项几秒后再关闭,NPC更改的参数就会在游戏中刷新.'
    Caption = '刷新状态'
    TabOrder = 4
    OnClick = CheckBoxDenyRefStatusClick
  end
  object ButtonClearTempData: TButton
    Left = 210
    Top = 430
    Width = 111
    Height = 31
    Hint = '清除所有NPC的临时文件,包括临时价格表及交易物品库存,在NPC买卖物品有问题时可使用此功能清理.'
    Caption = '清除数据(&C)'
    TabOrder = 5
    OnClick = ButtonClearTempDataClick
  end
  object ButtonViewData: TButton
    Left = 90
    Top = 430
    Width = 111
    Height = 31
    Caption = '查看数据(&V)'
    TabOrder = 6
    Visible = False
    OnClick = ButtonClearTempDataClick
  end
end
