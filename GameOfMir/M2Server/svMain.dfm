object FrmMain: TFrmMain
  Left = 554
  Top = 138
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 372
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MemoLog: TMemo
    Left = 0
    Top = 0
    Width = 484
    Height = 214
    Align = alTop
    BevelInner = bvNone
    Color = clInfoText
    Ctl3D = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    OEMConvert = True
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    OnChange = MemoLogChange
    OnDblClick = MemoLogDblClick
  end
  object GridGate: TStringGrid
    Left = 0
    Top = 291
    Width = 484
    Height = 81
    Align = alBottom
    Color = clHighlightText
    ColCount = 7
    Ctl3D = True
    DefaultRowHeight = 18
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ParentCtl3D = False
    TabOrder = 1
    ColWidths = (
      42
      110
      62
      60
      60
      61
      60)
  end
  object Panel1: TPanel
    Left = 0
    Top = 214
    Width = 484
    Height = 78
    Align = alTop
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object LbUserCount: TLabel
      Left = 370
      Top = 40
      Width = 18
      Height = 12
      Caption = '...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clOlive
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object LbTimeCount: TLabel
      Left = 370
      Top = 56
      Width = 18
      Height = 12
      Caption = '...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object LbRunTime: TLabel
      Left = 370
      Top = 24
      Width = 18
      Height = 12
      Caption = '...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clOlive
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label20: TLabel
      Left = 4
      Top = 56
      Width = 18
      Height = 12
      Caption = '...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clOlive
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 4
      Top = 40
      Width = 18
      Height = 12
      Caption = '...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clOlive
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 4
      Top = 24
      Width = 18
      Height = 12
      Caption = '...'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clOlive
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object MemStatus: TLabel
      Left = 453
      Top = 8
      Width = 18
      Height = 12
      Alignment = taRightJustify
      Caption = '...'
      Font.Charset = GB2312_CHARSET
      Font.Color = clHighlight
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label5: TLabel
      Left = 4
      Top = 8
      Width = 18
      Height = 12
      Caption = '...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clOlive
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    Left = 56
    Top = 16
  end
  object RunTimer: TTimer
    Enabled = False
    Interval = 1
    Left = 88
    Top = 16
  end
  object DBSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 6000
    Left = 56
    Top = 80
  end
  object ConnectTimer: TTimer
    Enabled = False
    Interval = 3000
    Left = 56
    Top = 48
  end
  object StartTimer: TTimer
    Enabled = False
    Interval = 100
    Left = 120
    Top = 16
  end
  object SaveVariableTimer: TTimer
    Interval = 10000
    Left = 152
    Top = 16
  end
  object CloseTimer: TTimer
    Enabled = False
    Interval = 100
    Left = 88
    Top = 48
  end
  object LogUDP: TNMUDP
    RemotePort = 10000
    LocalPort = 0
    ReportLevel = 1
    Left = 88
    Top = 80
  end
  object MainMenu: TMainMenu
    Left = 120
    Top = 80
    object MENU_CONTROL: TMenuItem
      Caption = #25511#21046
      OnClick = MENU_CONTROLClick
      object MENU_CONTROL_START: TMenuItem
        Caption = #21551#21160#26381#21153
        ShortCut = 16467
        OnClick = MENU_CONTROL_STARTClick
      end
      object MENU_CONTROL_STOP: TMenuItem
        Caption = #20851#38381#26381#21153
        ShortCut = 16468
        OnClick = MENU_CONTROL_STOPClick
      end
      object MENU_CONTROL_CLEARLOGMSG: TMenuItem
        Caption = #28165#38500#26085#24535
        OnClick = MENU_CONTROL_CLEARLOGMSGClick
      end
      object MENU_CONTROL_RELOAD: TMenuItem
        Caption = #37325#26032#21152#36733
        object MENU_CONTROL_RELOAD_ITEMDB: TMenuItem
          Caption = #29289#21697#25968#25454
          OnClick = MENU_CONTROL_RELOAD_ITEMDBClick
        end
        object MENU_CONTROL_RELOAD_MAGICDB: TMenuItem
          Caption = #25216#33021#25968#25454
          OnClick = MENU_CONTROL_RELOAD_MAGICDBClick
        end
        object MENU_CONTROL_RELOAD_MONSTERDB: TMenuItem
          Caption = #24618#29289#25968#25454
          OnClick = MENU_CONTROL_RELOAD_MONSTERDBClick
        end
        object MENU_CONTROL_RELOAD_MONSTERSAY: TMenuItem
          Caption = #24618#29289#35828#35805#37197#32622
          OnClick = MENU_CONTROL_RELOAD_MONSTERSAYClick
        end
        object MENU_CONTROL_RELOAD_DISABLEMAKE: TMenuItem
          Caption = #25968#25454#21015#34920
          OnClick = MENU_CONTROL_RELOAD_DISABLEMAKEClick
        end
        object MENU_CONTROL_RELOAD_STARTPOINT: TMenuItem
          Caption = #22320#22270#23433#20840#21306
          OnClick = MENU_CONTROL_RELOAD_STARTPOINTClick
        end
        object MENU_CONTROL_RELOAD_CONF: TMenuItem
          Caption = #21442#25968#35774#32622
          OnClick = MENU_CONTROL_RELOAD_CONFClick
        end
      end
      object MENU_CONTROL_GATE: TMenuItem
        Caption = #28216#25103#32593#20851
        object MENU_CONTROL_GATE_OPEN: TMenuItem
          Caption = #25171#24320
          OnClick = MENU_CONTROL_GATE_OPENClick
        end
        object MENU_CONTROL_GATE_CLOSE: TMenuItem
          Caption = #20851#38381
          OnClick = MENU_CONTROL_GATE_CLOSEClick
        end
      end
      object MENU_CONTROL_EXIT: TMenuItem
        Caption = #36864#20986#31243#24207
        ShortCut = 16472
        OnClick = MENU_CONTROL_EXITClick
      end
    end
    object MENU_VIEW: TMenuItem
      Caption = #26597#30475
      object MENU_VIEW_ONLINEHUMAN: TMenuItem
        Caption = #22312#32447#20154#25968
        OnClick = MENU_VIEW_ONLINEHUMANClick
      end
      object MENU_VIEW_SESSION: TMenuItem
        Caption = #20840#23616#20250#35805
        OnClick = MENU_VIEW_SESSIONClick
      end
      object MENU_VIEW_LEVEL: TMenuItem
        Caption = #31561#32423#23646#24615
        OnClick = MENU_VIEW_LEVELClick
      end
      object MENU_VIEW_LIST: TMenuItem
        Caption = #21015#34920#20449#24687
        OnClick = MENU_VIEW_LISTClick
      end
      object MENU_VIEW_KERNELINFO: TMenuItem
        Caption = #20869#26680#25968#25454
        OnClick = MENU_VIEW_KERNELINFOClick
      end
      object MENU_VIEW_GATE: TMenuItem
        Caption = #32593#20851#29366#24577
        Checked = True
        OnClick = MENU_VIEW_GATEClick
      end
    end
    object MENU_OPTION: TMenuItem
      Caption = #36873#39033
      object MENU_OPTION_GENERAL: TMenuItem
        Caption = #22522#26412#35774#32622
        OnClick = MENU_OPTION_GENERALClick
      end
      object MENU_OPTION_GAME: TMenuItem
        Caption = #21442#25968#35774#32622
        OnClick = MENU_OPTION_GAMEClick
      end
      object MENU_OPTION_ITEMFUNC: TMenuItem
        Caption = #29289#21697#35013#22791
        OnClick = MENU_OPTION_ITEMFUNCClick
      end
      object MENU_OPTION_FUNCTION: TMenuItem
        Caption = #21151#33021#35774#32622
        OnClick = MENU_OPTION_FUNCTIONClick
      end
      object G1: TMenuItem
        Caption = #28216#25103#21629#20196
        OnClick = G1Click
      end
      object MENU_OPTION_MONSTER: TMenuItem
        Caption = #24618#29289#35774#32622
        OnClick = MENU_OPTION_MONSTERClick
      end
      object MENU_OPTION_SERVERCONFIG: TMenuItem
        Caption = #24615#33021#21442#25968
        OnClick = MENU_OPTION_SERVERCONFIGClick
      end
    end
    object MENU_MANAGE: TMenuItem
      Caption = #31649#29702
      object MENU_MANAGE_ONLINEMSG: TMenuItem
        Caption = #22312#32447#28040#24687
        OnClick = MENU_MANAGE_ONLINEMSGClick
      end
      object MENU_TOOLS_GAMESHOP: TMenuItem
        Caption = #21830#22478#31649#29702
        OnClick = MENU_TOOLS_GAMESHOPClick
      end
      object MENU_MANAGE_CASTLE: TMenuItem
        Caption = #22478#22561#31649#29702
        OnClick = MENU_MANAGE_CASTLEClick
      end
    end
    object MENU_TOOLS: TMenuItem
      Caption = #24037#20855
      object MENU_TOOLS_MERCHANT: TMenuItem
        Caption = #20132#26131'NPC'#37197#32622
        OnClick = MENU_TOOLS_MERCHANTClick
      end
      object MENU_TOOLS_NPC: TMenuItem
        Caption = #31649#29702'NPC'#37197#32622
      end
      object MENU_TOOLS_MONGEN: TMenuItem
        Caption = #21047#24618#37197#32622
        OnClick = MENU_TOOLS_MONGENClick
      end
      object MENU_TOOLS_IPSEARCH: TMenuItem
        Caption = #22320#21306#26597#35810
        OnClick = MENU_TOOLS_IPSEARCHClick
      end
    end
    object MENU_HELP: TMenuItem
      Caption = #24110#21161
      object MENU_HELP_ABOUT: TMenuItem
        Caption = #20851#20110#20316#32773
        ShortCut = 16449
        OnClick = MENU_HELP_ABOUTClick
      end
    end
  end
end
