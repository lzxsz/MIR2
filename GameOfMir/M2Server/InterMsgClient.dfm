object FrmMsgClient: TFrmMsgClient
  Left = 543
  Top = 288
  Width = 170
  Height = 96
  Caption = 'FrmMsgClient'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object MsgClient: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = MsgClientConnect
    OnRead = MsgClientRead
    OnError = MsgClientError
    Left = 21
    Top = 17
  end
end
