object frmLoginServerConfig: TfrmLoginServerConfig
  Left = 222
  Top = 269
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #30331#24405#26381#21153#22120#39640#32423#35774#32622
  ClientHeight = 288
  ClientWidth = 545
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
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 529
    Height = 241
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #32593#20851#36335#30001
      object GridGateRoute: TStringGrid
        Left = 8
        Top = 8
        Width = 505
        Height = 177
        ColCount = 6
        DefaultRowHeight = 18
        FixedCols = 0
        TabOrder = 0
        ColWidths = (
          102
          62
          93
          86
          91
          42)
      end
    end
  end
end
