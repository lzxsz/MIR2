unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, { Dialogs,}
  StdCtrls, ExtCtrls, DXClass, DXDraws, DIB, MMSystem, ImgList, ComCtrls,
  DXSounds, DXInput, Buttons, DXWave, DXPlay, DirectX, Spin, Grids;
{  DXFonts}

const
  DXCHAT_MESSAGE = 0;
  MAX_MESSAGES = 8;
  MAX_DELAY = 600; // in frames

type
  TDXChatMessage = record
    Kind: DWORD;
    Size: Integer;
    Data: array[0..0] of Char;
  end;

type
  TChatDisplay = record
    Typing: boolean;
    OutMessage: string;
    InMessages: string;
    Delay: integer;
  end;

type
  TLaunchForm = class(TDXForm)
    DXDraw: TDXDraw;
    EngineDXTimer: TDXTimer;
    DXImageList: TDXImageList;
    SetupPageControl: TPageControl;
    VideoTabSheet: TTabSheet;
    IconImageList: TImageList;
    AudioTabSheet: TTabSheet;
    InputTabSheet: TTabSheet;
    NetworkTabSheet: TTabSheet;
    ScreenGroupBox: TGroupBox;
    VideoModeCombo: TComboBox;
    VideoLabel: TLabel;
    FullScreenCheckBox: TCheckBox;
    PerformGroupBox: TGroupBox;
    SysMemCheckBox: TCheckBox;
    WaitVSyncCheckBox: TCheckBox;
    FlipCheckBox: TCheckBox;
    GameTabSheet: TTabSheet;
    FrameRateGroupBox: TGroupBox;
    SetFrameCheckBox: TCheckBox;
    FrameSkipCheckBox: TCheckBox;
    FrameTrackPanel: TPanel;
    LowFrameLabel: TLabel;
    FrameTrackBar: TTrackBar;
    MedFrameLabel: TLabel;
    HiFrameLabel: TLabel;
    AudioBitRadioGroup: TRadioGroup;
    AudiokHzRadioGroup: TRadioGroup;
    VolumeGroupBox: TGroupBox;
    SoundVolPanel: TPanel;
    SoundVolTrackBar: TTrackBar;
    MusicVolPanel: TPanel;
    SoundCheckBox: TCheckBox;
    MusicCheckBox: TCheckBox;
    MusicVolTrackBar: TTrackBar;
    VideoInfoGroupBox: TGroupBox;
    AudioSettingsGroupBox: TGroupBox;
    DXSound: TDXSound;
    ExclusiveAudioCheckBox: TCheckBox;
    AudioCheckBox: TCheckBox;
    DXInput: TDXInput;
    InputGroupBox: TGroupBox;
    DXInputCheckBox: TCheckBox;
    PageControl: TPageControl;
    JoyTabSheet: TTabSheet;
    JoyGroupBox: TGroupBox;
    AutoCenter: TCheckBox;
    JoyCheckBox: TCheckBox;
    KeyTabSheet: TTabSheet;
    KeyGroupBox: TGroupBox;
    OrLabel: TLabel;
    SecondaryLabel: TLabel;
    PrimaryLabel: TLabel;
    StateListBox: TListBox;
    KeyComboBox1: TComboBox;
    KeyComboBox2: TComboBox;
    KeyComboBox3: TComboBox;
    JoySensePanel: TPanel;
    JoySenseTrackBar: TTrackBar;
    SenseLabel: TLabel;
    LessLabel: TLabel;
    MoreLabel: TLabel;
    MinLabel1: TLabel;
    MaxLabel1: TLabel;
    MinLabel2: TLabel;
    MaxLabel2: TLabel;
    ActionLabel: TLabel;
    TesrTabSheet: TTabSheet;
    InputTestGroupBox: TGroupBox;
    JoyTestPanel: TPanel;
    JoyShape: TShape;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    InputTestTimer: TTimer;
    StereoCheckBox: TCheckBox;
    GameGroupBox: TGroupBox;
    LaunchButton: TButton;
    GameMemo: TMemo;
    ShowAgainCheckBox: TCheckBox;
    DXPlay: TDXPlay;
    ConnectionGroupBox: TGroupBox;
    ConnectionComboBox: TComboBox;
    ConnectionLabel: TLabel;
    InternetGroupBox: TGroupBox;
    Label1: TLabel;
    ServersComboBox: TComboBox;
    PortCheckBox: TCheckBox;
    PortSpinEdit: TSpinEdit;
    ConnectButton: TButton;
    JoinHostPageControl: TPageControl;
    Join: TTabSheet;
    HostSheet: TTabSheet;
    JoinButton: TButton;
    PlayerComboBox: TComboBox;
    NameLabel: TLabel;
    SearchInternetCheckBox: TCheckBox;
    HostGroupBox: TGroupBox;
    PlayerHostLabel: TLabel;
    PlayerHostComboBox: TComboBox;
    GameNameLabel: TLabel;
    HostNameComboBox: TComboBox;
    PasswordEdit: TEdit;
    PasswordLabel: TLabel;
    MaxPlayersSpinEdit: TSpinEdit;
    Label2: TLabel;
    HostButton: TButton;
    PlayNetworkButton: TButton;
    GameStringGrid: TStringGrid;
    SessionEdit: TEdit;
    DXFont: TDXFont;
    procedure FormCreate(Sender: TObject);
    procedure DXDrawInitializing(Sender: TObject);
    procedure LaunchButtonClick(Sender: TObject);
    procedure DXDrawFinalize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EngineDXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DXDrawInitialize(Sender: TObject);
    procedure Default(Sender: TObject);
    procedure Center(Sender: TObject);
    procedure DXSoundInitialize(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure ConnectionComboBoxChange(Sender: TObject);
    procedure HostButtonClick(Sender: TObject);
    procedure PlayNetworkButtonClick(Sender: TObject);
    procedure JoinButtonClick(Sender: TObject);
    procedure GameStringGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SendBroadCastMessage(Sender: TObject; const AChatMessage: string);
    procedure DXPlayMessage(Sender: TObject; From: TDXPlayPlayer; Data: Pointer; DataSize: Integer);
    procedure EngineTick(Sender: TObject);
    procedure EngineDisplay(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FMouseX, FMouseY: integer; // mouse co-ords
    FChat: TChatDisplay; // chat display
  end;

var
  LaunchForm: TLaunchForm;

implementation

{$R *.DFM}

procedure TLaunchForm.FormCreate(Sender: TObject);
var
  GameRootDir: string;
  i: integer;
begin
  GameRootDir := ExtractFilePath(Application.ExeName);

  // *** Game Settings

  if fileexists(GameRootDir + 'readme.txt') then
    GameMemo.Lines.LoadFromFile(GameRootDir + 'readme.txt');

  // *** Video Settings

  VideoModeCombo.ItemIndex := 0; // set default resolution

  // *** Audio Settings

  // *** Network Settings

  ConnectionComboBox.Items.Clear;
  for i := 0 to DXPlay.Providers.Count - 1 do // Select only IPX/TCPIP
    if (CompareMem(PGUID(DXPlay.Providers.Objects[i]), @DPSPGUID_TCPIP, SizeOf(TGUID))) or
      (CompareMem(PGUID(DXPlay.Providers.Objects[i]), @DPSPGUID_IPX, SizeOf(TGUID)))
      then ConnectionComboBox.Items.Add(DXPlay.Providers.Strings[i]);
  ConnectionComboBox.ItemIndex := 1;
end;

procedure TLaunchForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then // go back to the launch pad
  begin;
    DXDraw.Finalize;
    Default(nil);
    Center(nil);
  end;

  if (ssAlt in Shift) and (Key = VK_RETURN) then // FullScreen mode toggle
  begin
    DXDraw.Finalize;
    if doFullScreen in DXDraw.Options then
    begin
      RestoreWindow;
      BorderStyle := bsSizeable;
      FullScreenCheckBox.Checked := False;
    end
    else
    begin
      StoreWindow;
      BorderStyle := bsNone;
      FullScreenCheckBox.Checked := True;
    end;
    DXDraw.Initialize;
  end;

  if not (ssAlt in Shift) and (Key = VK_RETURN) then // Send Chat
  begin
    if not FChat.Typing then FChat.Typing := true;
    if FChat.Typing and (FChat.OutMessage <> '') then
    begin
      SendBroadCastMessage(nil, FChat.OutMessage);
      FChat.OutMessage := '';
      FChat.Typing := false;
    end;
  end;

  if key = VK_BACK then
  begin
    if FChat.Typing and (FChat.OutMessage <> '') then
      Delete(FChat.OutMessage, length(FChat.OutMessage), 1);
  end;
end;

procedure TLaunchForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if FChat.Typing then
    case Key of
      'A'..'z', ' ', '.', '!', '@', '$', '*', '0'..'9':
        FChat.OutMessage := FChat.OutMessage + Key;
    end;
end;

procedure TLaunchForm.DXDrawMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  FMouseX := X;
  FMouseY := Y;
end;

procedure TLaunchForm.Default(Sender: TObject);
begin
  DXDraw.Hide;
  Width := 448;
  Height := 355;
  BorderStyle := bsDialog;
  SetupPageControl.Show;
end;

procedure TLaunchForm.Center(Sender: TObject);
begin
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2;
end;

procedure TLaunchForm.DXDrawInitializing(Sender: TObject);
var
  AVideoMode: string;
  AWidth, AHeight, ABitCount: Integer;
  i: integer; // loop
begin
  SetupPageControl.Hide; // hide setup page
  Dxdraw.Cursor := crNone; // no cursor
  Dxdraw.Show;

  // *** prime engine ***

  EngineDXTimer.Interval := 1000 div FrameTrackBar.Position;

  // *** find video mode ***

  AVideoMode := VideoModeCombo.Items.Strings[VideoModeCombo.Itemindex];
  i := Pos('x', AVideoMode);
  AWidth := StrToInt(Trim(Copy(AVideoMode, 1, i - 1))); // get width
  AVideoMode := Copy(AVideoMode, i + 1, Length(AVideoMode));
  i := Pos('x', AVideoMode);
  AHeight := StrToInt(Trim(Copy(AVideoMode, 1, i - 1))); // get height
  AVideoMode := Copy(AVideoMode, i + 1, Length(AVideoMode));
  ABitCount := StrToInt(Trim(AVideoMode)); // and bit count

  // *** set options ***

  with DxDraw do
  begin
    if FullScreenCheckBox.Checked then
    begin
      Options := Options + [doFullScreen];
      BorderStyle := bsNone;
      Dxdraw.Align := alClient; // take over form
      Display.Width := AWidth;
      Display.Height := AHeight;
      Display.BitCount := ABitCount;
    end
    else
    begin
      Options := Options - [doFullScreen];
      BorderStyle := bsSizeable;
      LaunchForm.ClientWidth := AWidth;
      LaunchForm.ClientHeight := AHeight;
      Align := alClient; // take over form
      Width := AWidth;
      Height := AHeight;
      Display.BitCount := ABitCount;
      Center(nil);
    end;
    if FlipCheckBox.Checked then Options := Options + [doFlip]
    else Options := Options - [doFlip];
    if WaitVSyncCheckBox.Checked then Options := Options + [doWaitVBlank]
    else Options := Options - [doWaitVBlank];
    if SysMemCheckBox.Checked then Options := Options + [doSystemMemory]
    else Options := Options - [doSystemMemory];
  end;

  if ABitCount = 8 then // in 8-bit mode only
  begin
    DXImageList.Items.MakeColorTable; // if you use 256 color images for everything
    DXDraw.ColorTable := DXImageList.Items.ColorTable; // use this for a glogal palette
    DXDraw.DefColorTable := DXImageList.Items.ColorTable;
    DXDraw.UpdatePalette;
  end;
end;

procedure TLaunchForm.DXDrawInitialize(Sender: TObject);
begin
  EngineDXTimer.Enabled := True; // start game
end;

procedure TLaunchForm.DXDrawFinalize(Sender: TObject);
begin
  EngineDXTimer.Enabled := False;
end;

procedure TLaunchForm.DXSoundInitialize(Sender: TObject);
var
  WaveFormat: TWaveFormatEx;
  ABit, AkHz, AChannels: integer;
begin
  case AudiokHzRadioGroup.ItemIndex of
    0: AkHz := 11025;
    1: AkHz := 22050;
    2: AkHz := 44100
  else
    AkHz := 22050;
  end;
  case AudioBitRadioGroup.ItemIndex of
    0: ABit := 8;
    1: ABit := 16
  else
    ABit := 8;
  end;
  if StereoCheckBox.Checked then AChannels := 2 else AChannels := 1;
  if ExclusiveAudioCheckBox.Checked then
    DXSound.Options := DXSound.Options + [soExclusive]
  else
    DXSound.Options := DXSound.Options - [soExclusive];

  MakePCMWaveFormatEx(WaveFormat, AkHz, ABit, AChannels);
  DXSound.Primary.SetFormat(WaveFormat);
end;

procedure TLaunchForm.ConnectButtonClick(Sender: TObject);
var i: integer;
begin
  JoinHostPageControl.Hide;
  if SearchInternetCheckBox.Checked and
    (Pos('TCP/IP', ConnectionComboBox.Items.Strings[ConnectionComboBox.ItemIndex]) <> 0) then
  begin
    DXPlay.TCPIPSetting.HostName := ServersComboBox.Text;
    DXPlay.TCPIPSetting.Port := PortSpinEdit.Value;
    DXPlay.TCPIPSetting.Enabled := True;
  end;
  Screen.Cursor := crHourGlass;
  try
    DXPlay.ProviderName := ConnectionComboBox.Items[ConnectionComboBox.ItemIndex];
    DXPlay.GetSessions;
  finally
    Screen.Cursor := crDefault;
  end;
  GameStringGrid.RowCount := 0;
  if DXPlay.Sessions.Count > 0 then // we got some sessions
  begin
    GameStringGrid.RowCount := DXPlay.Sessions.Count + 1;
    GameStringGrid.Cells[0, 0] := 'Game Session Name';
    for i := 0 to DXPlay.Sessions.Count - 1 do
      GameStringGrid.Cells[0, i + 1] := DXPlay.Sessions.Strings[i];
    GameStringGrid.FixedRows := 1;
  end;
  JoinHostPageControl.Show;
end;

procedure TLaunchForm.LaunchButtonClick(Sender: TObject);
begin
  try
    Dxdraw.Initialize;
  except
    Application.MessageBox(
      'DirectX was unable to initialize. To insure you have' + chr(13) +
      'insure you have the latest version of DirectX, please ' + chr(13) +
      'visit www.microsoft.com/directx',
      'Video Error',
      MB_OK + MB_ICONWARNING);
    Application.Terminate;
  end;
end;

procedure TLaunchForm.PlayNetworkButtonClick(Sender: TObject);
begin
  SetupPageControl.ActivePage := NetworkTabSheet;
end;

procedure TLaunchForm.ConnectionComboBoxChange(Sender: TObject);
begin
  GameStringGrid.RowCount := 0;
  GameStringGrid.Cols[0].Add('Game Session Name');
  DXPlay.ProviderName := '';
end;

procedure TLaunchForm.HostButtonClick(Sender: TObject);
begin
  DXPlay.MaxPlayers := MaxPlayersSpinEdit.Value;
  DXPlay.Open2(True, HostNameComboBox.Text, PlayerHostComboBox.Text);
  LaunchButton.Click;
end;

procedure TLaunchForm.JoinButtonClick(Sender: TObject);
begin
  DXPlay.Open2(False, SessionEdit.Text, PlayerComboBox.Text);
  LaunchButton.Click;
end;

procedure TLaunchForm.GameStringGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  GameStringGrid.MouseToCell(X, Y, ACol, ARow);
  if ARow > 0 then
    SessionEdit.Text := GameStringGrid.Cells[ACol, ARow];
end;

procedure TLaunchForm.SendBroadCastMessage(Sender: TObject; const AChatMessage: string);
var
  ChatMessage: ^TDXChatMessage;
  ChatMessageSize: Integer;
begin
  if not DXPlay.Opened then exit;
  ChatMessageSize := SizeOf(TDXChatMessage) + Length(AChatMessage);
  GetMem(ChatMessage, ChatMessageSize);
  try
    ChatMessage.Kind := DXCHAT_MESSAGE;
    ChatMessage.Size := Length(AChatMessage);
    StrLCopy(@ChatMessage^.Data, PChar(AChatMessage), Length(AChatMessage));
    DXPlay.SendMessage(DPID_ALLPLAYERS, ChatMessage, ChatMessageSize);
    DXPlay.SendMessage(DXPlay.LocalPlayer.ID, ChatMessage, ChatMessageSize);
  finally
    FreeMem(ChatMessage);
  end;
end;

procedure TLaunchForm.DXPlayMessage(Sender: TObject; From: TDXPlayPlayer; Data: Pointer; DataSize: Integer);
var
  ChatMessage: string;
begin
  case DXPlayMessageType(Data) of
    DXCHAT_MESSAGE:
      begin
        if TDXChatMessage(Data^).Size <= 0 then
          ChatMessage := ''
        else
        begin
          SetLength(ChatMessage, TDXChatMessage(Data^).Size);
          StrLCopy(PChar(ChatMessage), @TDXChatMessage(Data^).Data, Length(ChatMessage));
        end;
        FChat.InMessages := From.Name + ' ' + ChatMessage;
        FChat.Delay := MAX_DELAY;
      end;
  end;
end;

procedure TLaunchForm.EngineDXTimerTimer(Sender: TObject; LagCount: Integer);
begin
  EngineTick(nil);
  if not DXDraw.CanDraw then Exit;
  if LagCount > 1 then Exit;
  EngineDisplay(nil);
end;

procedure TLaunchForm.EngineTick(Sender: TObject);
begin
  if FChat.Delay > 0 then dec(FChat.Delay);
  if FChat.Delay = 0 then FChat.InMessages := '';
end;

procedure TLaunchForm.EngineDisplay(Sender: TObject);
var i: integer;
begin
  DXDraw.Surface.Fill(0); // clear screen

  if FChat.InMessages <> '' then
    DXFont.TextOut(DXDraw.Surface, 10, 10, FChat.InMessages);

  if FChat.Typing then
    DXFont.TextOut(DXDraw.Surface, 10, DXDraw.Height - 16, '! ' + FChat.OutMessage);

  DXImageList.items.find('mouse').draw(DXDraw.Surface, FMouseX, FMouseY, 0);
  DXDraw.Flip; // show screen
end;

end.

