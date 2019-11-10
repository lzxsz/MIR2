object frmIPaddrFilter: TfrmIPaddrFilter
  Left = 198
  Top = 273
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '网络安全过滤'
  ClientHeight = 383
  ClientWidth = 774
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '宋体'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object GroupBoxActive: TGroupBox
    Left = 10
    Top = 10
    Width = 171
    Height = 361
    Caption = '当前连接'
    TabOrder = 0
    object Label4: TLabel
      Left = 10
      Top = 30
      Width = 57
      Height = 15
      Caption = '连接列表''s:'
    end
    object ListBoxActiveList: TListBox
      Left = 10
      Top = 50
      Width = 151
      Height = 301
      Hint = '当前连接的IP地址列表'
      ItemHeight = 15
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
    Left = 190
    Top = 10
    Width = 331
    Height = 361
    Caption = '过滤列表'
    TabOrder = 1
    object LabelTempList: TLabel
      Left = 10
      Top = 30
      Width = 143
      Height = 15
      Caption = '动态过滤:'
    end
    object Label1: TLabel
      Left = 170
      Top = 30
      Width = 89
      Height = 15
      Caption = '永久过滤:'
    end
    object ListBoxTempList: TListBox
      Left = 10
      Top = 50
      Width = 151
      Height = 301
      Hint = '动态过滤列表,在此列表中的IP将无法建立连接,但在程序重新启动时此列表的信息将被清空'
      ItemHeight = 15
      Items.Strings = (
        '888.888.888.888')
      ParentShowHint = False
      PopupMenu = TempBlockListPopupMenu
      ShowHint = True
      Sorted = True
      TabOrder = 0
    end
    object ListBoxBlockList: TListBox
      Left = 170
      Top = 50
      Width = 151
      Height = 301
      Hint = '永久过滤列表,在此列表中的IP将无法建立连接,此列表将保存于配置文件中,在程序重新启动时会重新加载此列表'
      ItemHeight = 15
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
    Left = 530
    Top = 10
    Width = 231
    Height = 321
    Caption = '攻击保护'
    TabOrder = 2
    object Label2: TLabel
      Left = 10
      Top = 25
      Width = 31
      Height = 15
      Caption = '连接限制:'
    end
    object Label3: TLabel
      Left = 170
      Top = 25
      Width = 28
      Height = 15
      Caption = '连接/IP'
    end
    object Label7: TLabel
      Left = 40
      Top = 290
      Width = 80
      Height = 17
      Caption = '以上参数调后立即生效'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -15
      Font.Name = '宋体'
      Font.Style = []
      ParentFont = False
    end
    object EditMaxConnect: TSpinEdit
      Left = 80
      Top = 20
      Width = 81
      Height = 24
      Hint = '单个IP地址,最多可以建立连接数,超过指定连接数将按下面的操作处理'
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
      Left = 10
      Top = 170
      Width = 211
      Height = 111
      Caption = '攻击操作'
      TabOrder = 1
      object RadioAddBlockList: TRadioButton
        Left = 20
        Top = 80
        Width = 161
        Height = 21
        Hint = '将此连接的IP加入永久过滤列表,并将此IP的所有连接强行中断'
        Caption = '加入永久过滤列表'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = RadioAddBlockListClick
      end
      object RadioAddTempList: TRadioButton
        Left = 20
        Top = 50
        Width = 161
        Height = 21
        Hint = '将此连接的IP加入动态过滤列表,并将此IP的所有连接强行中断'
        Caption = '加入动态过滤列表'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = RadioAddTempListClick
      end
      object RadioDisConnect: TRadioButton
        Left = 20
        Top = 20
        Width = 161
        Height = 21
        Hint = '将连接简单的断开处理'
        Caption = '断开连接'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = RadioDisConnectClick
      end
    end
  end
  object ButtonOK: TButton
    Left = 650
    Top = 340
    Width = 111
    Height = 31
    Caption = '确定(&O)'
    Default = True
    TabOrder = 3
    OnClick = ButtonOKClick
  end
  object BlockListPopupMenu: TPopupMenu
    OnPopup = BlockListPopupMenuPopup
    Left = 376
    Top = 160
    object BPOPMENU_REFLIST: TMenuItem
      Caption = '刷新(&R)'
      OnClick = BPOPMENU_REFLISTClick
    end
    object BPOPMENU_SORT: TMenuItem
      Caption = '排序(&S)'
      OnClick = BPOPMENU_SORTClick
    end
    object BPOPMENU_ADD: TMenuItem
      Caption = '增加(&A)'
      OnClick = BPOPMENU_ADDClick
    end
    object BPOPMENU_ADDTEMPLIST: TMenuItem
      Caption = '加入动态过滤列表(&A)'
      OnClick = BPOPMENU_ADDTEMPLISTClick
    end
    object BPOPMENU_DELETE: TMenuItem
      Caption = '删除(&D)'
      OnClick = BPOPMENU_DELETEClick
    end
  end
  object TempBlockListPopupMenu: TPopupMenu
    OnPopup = TempBlockListPopupMenuPopup
    Left = 216
    Top = 160
    object TPOPMENU_REFLIST: TMenuItem
      Caption = '刷新(&R)'
      OnClick = TPOPMENU_REFLISTClick
    end
    object TPOPMENU_SORT: TMenuItem
      Caption = '排序(&S)'
      OnClick = TPOPMENU_SORTClick
    end
    object TPOPMENU_ADD: TMenuItem
      Caption = '增加(&A)'
      OnClick = TPOPMENU_ADDClick
    end
    object TPOPMENU_BLOCKLIST: TMenuItem
      Caption = '加入永久过滤列表(&D)'
      OnClick = TPOPMENU_BLOCKLISTClick
    end
    object TPOPMENU_DELETE: TMenuItem
      Caption = '删除(&D)'
      OnClick = TPOPMENU_DELETEClick
    end
  end
  object ActiveListPopupMenu: TPopupMenu
    OnPopup = ActiveListPopupMenuPopup
    Left = 32
    Top = 160
    object APOPMENU_REFLIST: TMenuItem
      Caption = '刷新(&R)'
      OnClick = APOPMENU_REFLISTClick
    end
    object APOPMENU_SORT: TMenuItem
      Caption = '排序(&S)'
      OnClick = APOPMENU_SORTClick
    end
    object APOPMENU_ADDTEMPLIST: TMenuItem
      Caption = '加入动态过滤列表(&A)'
      OnClick = APOPMENU_ADDTEMPLISTClick
    end
    object APOPMENU_BLOCKLIST: TMenuItem
      Caption = '加入永久过滤列表(&D)'
      OnClick = APOPMENU_BLOCKLISTClick
    end
    object APOPMENU_KICK: TMenuItem
      Caption = '踢除下线(&K)'
      OnClick = APOPMENU_KICKClick
    end
  end
end
