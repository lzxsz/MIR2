object frmRouteManage: TfrmRouteManage
  Left = 278
  Top = 241
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #32593#20851#36335#30001#37197#32622
  ClientHeight = 223
  ClientWidth = 481
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 465
    Height = 209
    Caption = #32593#20851#36335#30001#34920
    TabOrder = 0
    object Label1: TLabel
      Left = 248
      Top = 181
      Width = 120
      Height = 12
      Caption = #21442#25968#35843#33410#21518#31435#21363#29983#25928#65281
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object ListViewRoute: TListView
      Left = 8
      Top = 16
      Width = 449
      Height = 153
      Columns = <
        item
          Caption = #24207#21495
          Width = 40
        end
        item
          Caption = #35282#33394#32593#20851
          Width = 80
        end
        item
          Caption = #32593#20851#25968#37327
          Width = 64
        end
        item
          Caption = #28216#25103#32593#20851
          Width = 1000
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ButtonDeleteClick
    end
    object ButtonEdit: TButton
      Left = 88
      Top = 176
      Width = 73
      Height = 25
      Hint = #20462#25913#36873#23450#30340#32593#20851#36335#30001
      Caption = #32534#36753'(&E)'
      TabOrder = 1
      OnClick = ButtonDeleteClick
    end
    object ButtonDelete: TButton
      Left = 168
      Top = 176
      Width = 73
      Height = 25
      Hint = #21024#38500#36873#23450#30340#32593#20851#36335#30001
      Caption = #21024#38500'(&D)'
      TabOrder = 2
      OnClick = ButtonDeleteClick
    end
    object ButtonOK: TButton
      Left = 384
      Top = 176
      Width = 73
      Height = 25
      Hint = #20445#23384#32593#20851#36335#30001#35774#32622#36864#20986
      Caption = #30830#23450'(&O)'
      TabOrder = 3
      OnClick = ButtonDeleteClick
    end
    object ButtonAddRoute: TButton
      Left = 8
      Top = 176
      Width = 73
      Height = 25
      Hint = #20462#25913#36873#23450#30340#32593#20851#36335#30001
      Caption = #22686#21152'(&A)'
      TabOrder = 4
      OnClick = ButtonDeleteClick
    end
  end
end
