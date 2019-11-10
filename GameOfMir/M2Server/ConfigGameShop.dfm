object frmConfigGameShop: TfrmConfigGameShop
  Left = 378
  Top = 176
  Width = 783
  Height = 512
  Caption = #21830#21697#32534#36753
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 8
    Top = 320
    Width = 60
    Height = 12
    Caption = #21830#21697#21517#31216#65306
  end
  object Label3: TLabel
    Left = 200
    Top = 296
    Width = 60
    Height = 12
    Caption = #21830#21697#25551#36848#65306
  end
  object Label2: TLabel
    Left = 8
    Top = 345
    Width = 60
    Height = 12
    Caption = #21830#21697#20215#26684#65306
  end
  object Label4: TLabel
    Left = 8
    Top = 370
    Width = 60
    Height = 12
    Caption = #25152#23646#20998#31867#65306
  end
  object Label5: TLabel
    Left = 8
    Top = 395
    Width = 60
    Height = 12
    Caption = #32844#19994#20998#31867#65306
  end
  object Label6: TLabel
    Left = 8
    Top = 420
    Width = 60
    Height = 12
    Caption = #35814#32454#29289#21697#65306
  end
  object Label7: TLabel
    Left = 8
    Top = 445
    Width = 60
    Height = 12
    Caption = #29289#21697#29366#24577#65306
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 590
    Height = 280
    Caption = #21830#21697#21015#34920
    TabOrder = 0
    object ListViewItemList: TListView
      Left = 8
      Top = 16
      Width = 574
      Height = 255
      Columns = <
        item
          Caption = #21830#21697#21517#31216
          Width = 90
        end
        item
          Caption = #20215#26684
          Width = 70
        end
        item
          Caption = #25152#23646#20998#31867
          Width = 70
        end
        item
          Caption = #32844#19994#20998#31867
          Width = 70
        end
        item
          Caption = #35814#32454
        end
        item
          Caption = #29366#24577
        end
        item
          Caption = #25551#36848
          Width = 170
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object GroupBox2: TGroupBox
    Left = 605
    Top = 8
    Width = 160
    Height = 457
    Caption = #29289#21697#21015#34920
    TabOrder = 1
    object ListBoxItemList: TListBox
      Left = 8
      Top = 16
      Width = 145
      Height = 433
      ItemHeight = 12
      TabOrder = 0
    end
  end
  object EditShopItemName: TEdit
    Left = 72
    Top = 316
    Width = 120
    Height = 20
    ReadOnly = True
    TabOrder = 2
  end
  object SpinEditPrice: TSpinEdit
    Left = 72
    Top = 340
    Width = 120
    Height = 21
    MaxValue = 100000000
    MinValue = 0
    TabOrder = 3
    Value = 100
  end
  object Memo1: TMemo
    Left = 200
    Top = 316
    Width = 397
    Height = 89
    TabOrder = 4
  end
  object ButtonDelShopItem: TButton
    Left = 200
    Top = 412
    Width = 75
    Height = 25
    Caption = #21024#38500'(&D)'
    TabOrder = 5
  end
  object ButtonChgShopItem: TButton
    Left = 280
    Top = 412
    Width = 75
    Height = 25
    Caption = #20462#25913'(&C)'
    TabOrder = 6
  end
  object ButtonAddShopItem: TButton
    Left = 360
    Top = 412
    Width = 75
    Height = 25
    Caption = #22686#21152'(&A)'
    TabOrder = 7
  end
  object ButtonSaveShopItemList: TButton
    Left = 440
    Top = 412
    Width = 75
    Height = 25
    Caption = #20445#23384'(&S)'
    TabOrder = 8
  end
  object ButtonLoadShopItemList: TButton
    Left = 280
    Top = 440
    Width = 313
    Height = 25
    Caption = #37325#26032#21152#36733#21830#21697#21015#34920'(&R)'
    TabOrder = 9
  end
  object ComboBox1: TComboBox
    Left = 72
    Top = 366
    Width = 120
    Height = 20
    ItemHeight = 12
    TabOrder = 10
    Text = #26368#26032
    Items.Strings = (
      #26368#26032
      #20840#37096
      #27494#22120
      #30420#30002
      #36741#21161
      #32454#33410
      #21253#22218
      #29305#27530)
  end
  object ComboBox2: TComboBox
    Left = 72
    Top = 391
    Width = 120
    Height = 20
    ItemHeight = 12
    TabOrder = 11
    Text = #20840#37096
    Items.Strings = (
      #20840#37096
      #25112#22763
      #27861#24072
      #36947#22763
      #36890#29992)
  end
  object ComboBox3: TComboBox
    Left = 72
    Top = 416
    Width = 120
    Height = 20
    ItemHeight = 12
    TabOrder = 12
    Text = #21542
    Items.Strings = (
      #21542
      #26159)
  end
  object ComboBox4: TComboBox
    Left = 72
    Top = 441
    Width = 120
    Height = 20
    ItemHeight = 12
    TabOrder = 13
    Text = #26080
    Items.Strings = (
      #26080
      #26368#26032
      #26368#22909)
  end
end
