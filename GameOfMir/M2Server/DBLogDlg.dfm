object LoginDialog: TLoginDialog
  Left = 375
  Top = 289
  Width = 288
  Height = 185
  Caption = 'Database Login'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object OKButton: TButton
    Left = 58
    Top = 114
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelButton: TButton
    Left = 149
    Top = 113
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Panel: TPanel
    Left = 8
    Top = 7
    Width = 257
    Height = 98
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Label3: TLabel
      Left = 10
      Top = 6
      Width = 49
      Height = 13
      Caption = 'Database:'
    end
    object DatabaseName: TLabel
      Left = 91
      Top = 6
      Width = 3
      Height = 13
    end
    object Bevel: TBevel
      Left = 1
      Top = 24
      Width = 254
      Height = 9
      Shape = bsTopLine
    end
    object Panel1: TPanel
      Left = 2
      Top = 31
      Width = 253
      Height = 65
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 56
        Height = 13
        Caption = '&User Name:'
        FocusControl = UserName
      end
      object Label2: TLabel
        Left = 8
        Top = 36
        Width = 49
        Height = 13
        Caption = '&Password:'
        FocusControl = Password
      end
      object UserName: TEdit
        Left = 86
        Top = 5
        Width = 153
        Height = 21
        MaxLength = 31
        TabOrder = 0
      end
      object Password: TEdit
        Left = 86
        Top = 33
        Width = 153
        Height = 21
        MaxLength = 31
        PasswordChar = '*'
        TabOrder = 1
      end
    end
  end
end
