object frmMessageFilterConfig: TfrmMessageFilterConfig
  Left = 208
  Top = 225
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #25991#23383#36807#28388
  ClientHeight = 195
  ClientWidth = 232
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
    Top = 8
    Width = 54
    Height = 12
    Caption = #36807#28388#35774#32622':'
  end
  object ListBoxFilterText: TListBox
    Left = 8
    Top = 24
    Width = 153
    Height = 161
    ItemHeight = 12
    TabOrder = 0
    OnClick = ListBoxFilterTextClick
    OnDblClick = ListBoxFilterTextDblClick
  end
  object ButtonAdd: TButton
    Left = 170
    Top = 64
    Width = 57
    Height = 25
    Caption = #22686#21152'(&A)'
    TabOrder = 1
    OnClick = ButtonAddClick
  end
  object ButtonDel: TButton
    Left = 170
    Top = 96
    Width = 57
    Height = 25
    Caption = #21024#38500'(&D)'
    TabOrder = 2
    OnClick = ButtonDelClick
  end
  object ButtonOK: TButton
    Left = 170
    Top = 160
    Width = 57
    Height = 25
    Caption = #30830#23450'(&O)'
    TabOrder = 3
    OnClick = ButtonOKClick
  end
  object ButtonMod: TButton
    Left = 170
    Top = 128
    Width = 57
    Height = 25
    Caption = #20462#25913'(&M)'
    TabOrder = 4
    OnClick = ButtonModClick
  end
end
