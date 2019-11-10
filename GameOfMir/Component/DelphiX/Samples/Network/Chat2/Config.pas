unit Config;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DXPlay, DirectX, Spin;

type
  TConfigForm = class(TForm)
    ProviderList: TComboBox;
    Label1: TLabel;
    ProviderSetting: TNotebook;
    SessionListBox: TListBox;
    Label2: TLabel;
    JoinButton: TButton;
    HostButton: TButton;
    SessionNameEdit: TEdit;
    PlayerNameEdit: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    TCPIPHostName: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    ModemPhoneNumber: TEdit;
    Label7: TLabel;
    ModemComboBox: TComboBox;
    TCPIPConnectButton: TButton;
    ModemConnectButton: TButton;
    OtherConnectButton: TButton;
    Label8: TLabel;
    TCPIPPort: TSpinEdit;
    procedure FormShow(Sender: TObject);
    procedure ProviderListChange(Sender: TObject);
    procedure TCPIPConnectButtonClick(Sender: TObject);
    procedure OtherConnectButtonClick(Sender: TObject);
    procedure JoinButtonClick(Sender: TObject);
    procedure HostButtonClick(Sender: TObject);
    procedure SessionListBoxClick(Sender: TObject);
    procedure ModemConnectButtonClick(Sender: TObject);
  private
    procedure Connect;
  public
    DXPlay: TDXPlay;
  end;

var
  ConfigForm: TConfigForm;

implementation

{$R *.DFM}

procedure TConfigForm.FormShow(Sender: TObject);
begin
  ProviderList.Items := DXPlay.Providers;
  ProviderList.ItemIndex := 0;
  ProviderListChange(nil);
end;

procedure TConfigForm.ProviderListChange(Sender: TObject);
begin
  SessionListBox.Items.Clear;

  DXPlay.ProviderName := '';
  JoinButton.Enabled := False;
  HostButton.Enabled := False;

  SessionListBox.Enabled := False;
  SessionListBox.Color := clBtnFace;
  SessionNameEdit.Enabled := False;
  SessionNameEdit.Color := clBtnFace;
  PlayerNameEdit.Enabled := False;
  PlayerNameEdit.Color := clBtnFace;

  if CompareMem(PGUID(ProviderList.Items.Objects[ProviderList.ItemIndex]), @DPSPGUID_TCPIP, SizeOf(TGUID)) then
  begin
    {  TCP/IP  }
    ProviderSetting.ActivePage := 'ProviderSettingTCPIP';
  end else
  if CompareMem(PGUID(ProviderList.Items.Objects[ProviderList.ItemIndex]), @DPSPGUID_MODEM, SizeOf(TGUID)) then
  begin
    {  Modem  }
    ProviderSetting.ActivePage := 'ProviderSettingModem';
    if ModemComboBox.Items.Count=0 then
    begin
      Screen.Cursor := crHourGlass;
      try
        ModemComboBox.Items := DXPlay.ModemSetting.ModemNames;
        ModemComboBox.ItemIndex := 0;
      finally
        Screen.Cursor := crDefault;
      end;
    end;
  end else
  begin
    {  Other  }
    ProviderSetting.ActivePage := 'Default';
  end;
end;

procedure TConfigForm.Connect;
begin
  Screen.Cursor := crHourGlass;
  try
    DXPlay.GetSessions;
    SessionListBox.Items := DXPlay.Sessions;
  finally
    Screen.Cursor := crDefault;
  end;

  JoinButton.Enabled := SessionListBox.Items.Count>0;
  HostButton.Enabled := True;
  if JoinButton.Enabled then
  begin
    SessionListBox.Enabled := True;
    SessionListBox.Color := clWhite;
  end;
  SessionNameEdit.Enabled := True;
  SessionNameEdit.Color := clWhite;
  PlayerNameEdit.Enabled := True;
  PlayerNameEdit.Color := clWhite;
end;

procedure TConfigForm.TCPIPConnectButtonClick(Sender: TObject);
begin
  SessionListBox.Items.Clear;

  DXPlay.TCPIPSetting.HostName := TCPIPHostName.Text;
  DXPlay.TCPIPSetting.Port := TCPIPPort.Value;
  DXPlay.TCPIPSetting.Enabled := True;
  DXPlay.ProviderName := ProviderList.Items[ProviderList.ItemIndex];

  Connect;
end;

procedure TConfigForm.ModemConnectButtonClick(Sender: TObject);
begin
  SessionListBox.Items.Clear;

  DXPlay.ModemSetting.PhoneNumber := ModemPhoneNumber.Text;
  DXPlay.ModemSetting.ModemName := ModemComboBox.Items[ModemComboBox.ItemIndex];
  DXPlay.ModemSetting.Enabled := True;
  DXPlay.ProviderName := ProviderList.Items[ProviderList.ItemIndex];

  Connect;
end;

procedure TConfigForm.OtherConnectButtonClick(Sender: TObject);
begin
  SessionListBox.Items.Clear;

  DXPlay.ProviderName := ProviderList.Items[ProviderList.ItemIndex];

  Connect;
end;

procedure TConfigForm.JoinButtonClick(Sender: TObject);
begin
  DXPlay.Open2(False, SessionNameEdit.Text, PlayerNameEdit.Text);
  Tag := 1;
  Close;
end;

procedure TConfigForm.HostButtonClick(Sender: TObject);
begin
  DXPlay.Open2(True, SessionNameEdit.Text, PlayerNameEdit.Text);
  Tag := 1;
  Close;
end;

procedure TConfigForm.SessionListBoxClick(Sender: TObject);
begin
  SessionNameEdit.Text := SessionListBox.Items[SessionListBox.ItemIndex];
end;

end.
