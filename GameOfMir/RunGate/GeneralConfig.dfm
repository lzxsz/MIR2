object frmGeneralConfig: TfrmGeneralConfig
  Left = 218
  Top = 153
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '基本设置'
  ClientHeight = 158
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '宋体'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBoxNet: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 113
    Caption = '网络设置（须重起后生效）'
    TabOrder = 0
    object LabelGateIPaddr: TLabel
      Left = 8
      Top = 20
      Width = 54
      Height = 12
      Caption = '网关地址:'
    end
    object LabelGatePort: TLabel
      Left = 8
      Top = 44
      Width = 54
      Height = 12
      Caption = '网关端口:'
    end
    object LabelServerPort: TLabel
      Left = 8
      Top = 92
      Width = 66
      Height = 12
      Caption = '服务器端口:'
    end
    object LabelServerIPaddr: TLabel
      Left = 8
      Top = 68
      Width = 66
      Height = 12
      Caption = '服务器地址:'
    end
    object EditGateIPaddr: TEdit
      Left = 80
      Top = 16
      Width = 97
      Height = 20
      Hint = 
        '地址一般默认为 0.0.0.0 ,通常不需要更改'#13#10'如果机器上有多个IP地址时,可以设为本机其'#13#10'中一个IP,以实现同锻口不同I' +
        'P的绑定.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object EditGatePort: TEdit
      Left = 80
      Top = 40
      Width = 41
      Height = 20
      Hint = '网关对外开放的端口号,此端口标准为 7200,'#13#10'此端口可以根据自己的要求进行修改.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '7200'
    end
    object EditServerPort: TEdit
      Left = 80
      Top = 88
      Width = 41
      Height = 20
      Hint = '游戏服务器的端口,此端口标准为 5000,'#13#10'如果使用的游戏服务器端修改过,则改为'#13#10'相应的端口就行了.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '5000'
    end
    object EditServerIPaddr: TEdit
      Left = 80
      Top = 64
      Width = 97
      Height = 20
      Hint = '游戏服务器IP地址,如果是单机运行服务'#13#10'器端时,一般就用 127.0.0.1 .'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '127.0.0.1'
    end
  end
  object GroupBoxInfo: TGroupBox
    Left = 200
    Top = 8
    Width = 161
    Height = 113
    Caption = '基本设置'
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 30
      Height = 12
      Caption = '名称:'
    end
    object LabelShowLogLevel: TLabel
      Left = 8
      Top = 44
      Width = 66
      Height = 12
      Caption = '日志详细度:'
    end
    object LabelShowBite: TLabel
      Left = 8
      Top = 92
      Width = 78
      Height = 12
      Caption = '流量显示单位:'
    end
    object EditTitle: TEdit
      Left = 40
      Top = 16
      Width = 105
      Height = 20
      Hint = '程序标题上显示的名称,此名称只用与显示'#13#10'暂时不做其他用途.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '⒌L网络'
    end
    object TrackBarLogLevel: TTrackBar
      Left = 8
      Top = 56
      Width = 145
      Height = 25
      Hint = '程序运行日志显示详细等级.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object ComboBoxShowBite: TComboBox
      Left = 88
      Top = 88
      Width = 57
      Height = 20
      Hint = '程序主介面上显示的监控数据流量显示单位'
      Style = csDropDownList
      ItemHeight = 12
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Items.Strings = (
        'KB'
        'B')
    end
  end
  object ButtonOK: TButton
    Left = 296
    Top = 128
    Width = 65
    Height = 25
    Hint = '保存当前设置,网络设置与下一次启动'#13#10'服务时生效'
    Caption = '确定(&O)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = ButtonOKClick
  end
end
