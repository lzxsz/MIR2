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
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object EditGatePort: TEdit
      Left = 80
      Top = 40
      Width = 41
      Height = 20
      TabOrder = 1
      Text = '7200'
    end
    object EditServerPort: TEdit
      Left = 80
      Top = 88
      Width = 41
      Height = 20
      TabOrder = 2
      Text = '5000'
    end
    object EditServerIPaddr: TEdit
      Left = 80
      Top = 64
      Width = 97
      Height = 20
      TabOrder = 3
      Text = '127.0.0.1'
    end
  end
  object GroupBoxInfo: TGroupBox
    Left = 200
    Top = 8
    Width = 161
    Height = 113
    Caption = '基本参数'
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 30
      Height = 12
      Caption = '标题:'
    end
    object LabelShowLogLevel: TLabel
      Left = 8
      Top = 44
      Width = 78
      Height = 12
      Caption = '显示日志等级:'
    end
    object EditTitle: TEdit
      Left = 40
      Top = 16
      Width = 105
      Height = 20
      TabOrder = 0
      Text = '⒌L网络'
    end
    object TrackBarLogLevel: TTrackBar
      Left = 8
      Top = 56
      Width = 145
      Height = 25
      TabOrder = 1
    end
  end
  object ButtonOK: TButton
    Left = 296
    Top = 128
    Width = 65
    Height = 25
    Caption = '确定(&O)'
    TabOrder = 2
    OnClick = ButtonOKClick
  end
end
