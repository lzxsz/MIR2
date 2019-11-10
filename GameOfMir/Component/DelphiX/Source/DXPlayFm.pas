unit DXPlayFm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DXPlay, ActiveX, DXETable, DIB, 
{$IfDef StandardDX}
  DirectDraw, DirectPlay;
{$Else}
  DirectX;
{$EndIf}

type
  TDelphiXDXPlayForm = class(TForm)
    Notebook: TNotebook;
    NextButton: TButton;
    BackButton: TButton;
    CancelButton: TButton;
    Bevel1: TBevel;
    ProviderList: TListBox;
    Label1: TLabel;
    Bevel2: TBevel;
    Label2: TLabel;
    NewGame: TRadioButton;
    JoinGame: TRadioButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    NewGameSessionName: TEdit;
    NewGamePlayerName: TEdit;
    Label7: TLabel;
    JoinGamePlayerName: TEdit;
    Label8: TLabel;
    JoinGameSessionList: TListBox;
    DXPaintBox1: TDXPaintBox;
    JoinGamePlayerList: TListBox;
    JoinGameGetPlayerListTimer: TTimer;
    procedure NotebookPageChanged(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure ProviderListClick(Sender: TObject);
    procedure NewGameClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NewGameSessionNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NewGamePlayerNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure JoinGameSessionListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure JoinGamePlayerNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure JoinGameGetPlayerListTimerTimer(Sender: TObject);
    procedure JoinGameSessionListClick(Sender: TObject);
  private
    FProviderGUID: TGUID;
  public
    DPlay: IDirectPlay4A;
    DXPlay: TCustomDXPlay;
    PlayerName: string;
    ProviderName: string;
    SessionName: string;
  end;

var
  DelphiXDXPlayForm: TDelphiXDXPlayForm;

implementation

uses DXConsts;

{$R *.DFM}

procedure TDelphiXDXPlayForm.FormShow(Sender: TObject);
begin
  ProviderList.Items := DXPlay.Providers;
  NotebookPageChanged(nil);
end;

procedure TDelphiXDXPlayForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to JoinGameSessionList.Items.Count-1 do
    Dispose(PGUID(JoinGameSessionList.Items.Objects[i]));
end;

procedure TDelphiXDXPlayForm.BackButtonClick(Sender: TObject);
begin
  JoinGameGetPlayerListTimer.Enabled := False;

  if Notebook.ActivePage='SessionNew' then
  begin
    DPlay := nil;
    Notebook.ActivePage := 'SessionType'
  end else if Notebook.ActivePage='SessionJoin' then
  begin
    DPlay := nil;
    Notebook.ActivePage := 'SessionType'
  end else
    Notebook.PageIndex := Notebook.PageIndex - 1;
end;

procedure TDelphiXDXPlayForm.NextButtonClick(Sender: TObject);

  procedure InitDirectPlay;
  var
    DPlay1: IDirectPlay;
  begin
    if DXDirectPlayCreate(FProviderGUID, DPlay1, nil)<>0 then
      raise EDXPlayError.CreateFmt(SCannotInitialized, [SDirectPlay]);

    DPlay := DPlay1 as IDirectPlay4A;
  end;

  function EnumSessionsCallback(const lpThisSD: TDPSessionDesc2;
      var lpdwTimeOut: DWORD; dwFlags: DWORD; lpContext: Pointer): BOOL; stdcall;
  var
    Guid: PGUID;
  begin
    if dwFlags and DPESC_TIMEDOUT<>0 then
    begin
      Result := False;
      Exit;
    end;

    Guid := New(PGUID);
    Move(lpThisSD.guidInstance, Guid^, SizeOf(TGUID));
    TDelphiXDXPlayForm(lpContext).JoinGameSessionList.Items.AddObject(lpThisSD.lpszSessionNameA, Pointer(Guid));

    Result := True;
  end;

var
  dpDesc: TDPSessionDesc2;
  i: Integer;
  c: array[0..1023] of Char;
  hr: HRESULT;
begin
  if Notebook.ActivePage='SelectProvider' then
  begin
    FProviderGUID := PGUID(ProviderList.Items.Objects[ProviderList.ItemIndex])^;

    InitDirectPlay;

    Notebook.ActivePage := 'SessionType';
  end else
  if Notebook.ActivePage='SessionType' then
  begin
    if DPlay=nil then InitDirectPlay;

    if NewGame.Checked then
      Notebook.ActivePage := 'SessionNew'
    else
    begin
      for i:=0 to JoinGameSessionList.Items.Count-1 do
        Dispose(PGUID(JoinGameSessionList.Items.Objects[i]));
      JoinGameSessionList.Items.Clear;

      FillChar(dpDesc, SizeOf(dpDesc), 0);
      dpDesc.dwSize := SizeOf(dpDesc);
      dpDesc.guidApplication := DXPlayStringToGUID(DXPlay.GUID);

      hr := DPlay.EnumSessions(dpDesc, 0, @EnumSessionsCallback, Self, DPENUMSESSIONS_AVAILABLE);
      if hr=DPERR_USERCANCEL then Exit;
      if hr<>0 then
        raise EDXPlayError.Create(SDXPlaySessionListCannotBeAcquired);

      Notebook.ActivePage := 'SessionJoin';
    end;
  end else if Notebook.ActivePage='SessionNew' then
  begin
    if DPlay=nil then InitDirectPlay;

    {  Session making  }
    StrLCopy(@c, PChar(NewGameSessionName.Text), SizeOf(c));

    FillChar(dpDesc, SizeOf(dpDesc), 0);
    dpDesc.dwSize := SizeOf(dpDesc);
    dpDesc.dwFlags := DPSESSION_MIGRATEHOST or DPSESSION_KEEPALIVE;
    dpDesc.lpszSessionNameA := @c;
    dpDesc.guidApplication := DXPlayStringToGUID(DXPlay.GUID);
    dpDesc.dwMaxPlayers := DXPlay.MaxPlayers;

    hr := DPlay.Open(dpDesc, DPOPEN_CREATE);
    if hr=DPERR_USERCANCEL then Exit;
    if hr<>0 then
    begin
      DPlay := nil;
      raise EDXPlayError.CreateFmt(SDXPlaySessionCannotOpened, [NewGameSessionName.Text]);
    end;

    PlayerName := NewGamePlayerName.Text;
    ProviderName := ProviderList.Items[ProviderList.ItemIndex];
    SessionName := NewGameSessionName.Text;

    Tag := 1;
    Close;
  end else if Notebook.ActivePage='SessionJoin' then
  begin
    if DPlay=nil then InitDirectPlay;

    {  Session connection  }
    FillChar(dpDesc, SizeOf(dpDesc), 0);
    dpDesc.dwSize := SizeOf(dpDesc);
    dpDesc.guidInstance := PGUID(JoinGameSessionList.Items.Objects[JoinGameSessionList.ItemIndex])^;
    dpDesc.guidApplication := DXPlayStringToGUID(DXPlay.GUID);

    hr := DPlay.Open(dpDesc, DPOPEN_JOIN);
    if hr=DPERR_USERCANCEL then Exit;
    if hr<>0 then
    begin
      DPlay := nil;
      raise EDXPlayError.CreateFmt(SDXPlaySessionCannotOpened, [NewGameSessionName.Text]);
    end;

    PlayerName := JoinGamePlayerName.Text;
    ProviderName := ProviderList.Items[ProviderList.ItemIndex];
    SessionName := JoinGameSessionList.Items[JoinGameSessionList.ItemIndex];

    Tag := 1;
    Close;
  end else
    Notebook.PageIndex := Notebook.PageIndex + 1;
end;

procedure TDelphiXDXPlayForm.JoinGameGetPlayerListTimerTimer(
  Sender: TObject);
      
  function EnumPlayersCallback2(TDPID: TDPID; dwPlayerType: DWORD;
    const lpName: TDPName; dwFlags: DWORD; lpContext: Pointer): BOOL; stdcall;
  begin
    with lpName do
    begin
      if lpszShortNameA<>nil then
        TDelphiXDXPlayForm(lpContext).JoinGamePlayerList.Items.Add(lpszShortNameA);
    end;

    Result := True;
  end;

var
  dpDesc: TDPSessionDesc2;
  hr: HRESULT;
  TempDPlay: IDirectPlay4A;
  DPlay1: IDirectPlay;                             
begin
  JoinGameGetPlayerListTimer.Enabled := False;
  JoinGamePlayerList.Items.Clear;
  
  TempDPlay := DPlay;
  if TempDPlay=nil then
  begin
    if DXDirectPlayCreate(FProviderGUID, DPlay1, nil)<>0 then
      Exit;
    TempDPlay := DPlay1 as IDirectPlay4A;
    DPlay1 := nil;
  end;            
  try
    FillChar(dpDesc, SizeOf(dpDesc), 0);
    dpDesc.dwSize := SizeOf(dpDesc);
    dpDesc.guidInstance := PGUID(JoinGameSessionList.Items.Objects[JoinGameSessionList.ItemIndex])^;
    dpDesc.guidApplication := DXPlayStringToGUID(DXPlay.GUID);

    hr := TempDPlay.Open(dpDesc, DPOPEN_JOIN);
    if hr<>0 then Exit;
    try
      TempDPlay.EnumPlayers(PGUID(nil), @EnumPlayersCallback2, Self, DPENUMPLAYERS_REMOTE);
    finally
      TempDPlay.Close;
    end;
  finally
    TempDPlay := nil;                          
  end;
end;

procedure TDelphiXDXPlayForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TDelphiXDXPlayForm.NotebookPageChanged(Sender: TObject);
begin
  if Notebook.ActivePage='SelectProvider' then
  begin
    BackButton.Enabled := False;
    NextButton.Enabled := ProviderList.ItemIndex<>-1;
    NextButton.Caption := DXPlayFormNext;
  end else if Notebook.ActivePage='SessionType' then
  begin
    BackButton.Enabled := True;
    NextButton.Enabled := NewGame.Checked or JoinGame.Checked;
    NextButton.Caption := DXPlayFormNext;
  end else if Notebook.ActivePage='SessionNew' then
  begin
    BackButton.Enabled := True;
    NextButton.Enabled := (NewGameSessionName.Text<>'') and (NewGamePlayerName.Text<>'');
    NextButton.Caption := DXPlayFormComplete;
  end else if Notebook.ActivePage='SessionJoin' then
  begin
    BackButton.Enabled := True;
    NextButton.Enabled := (JoinGameSessionList.ItemIndex<>-1) and (JoinGamePlayerName.Text<>'');
    NextButton.Caption := DXPlayFormComplete;
  end;
end;

procedure TDelphiXDXPlayForm.JoinGameSessionListClick(Sender: TObject);
begin
  NotebookPageChanged(nil);

  JoinGamePlayerList.Clear;
  if JoinGameSessionList.ItemIndex<>-1 then
  begin
    JoinGameGetPlayerListTimer.Enabled := False;
    JoinGameGetPlayerListTimer.Enabled := True;
  end;
end;

procedure TDelphiXDXPlayForm.ProviderListClick(Sender: TObject);
begin
  NotebookPageChanged(nil);
end;

procedure TDelphiXDXPlayForm.NewGameClick(Sender: TObject);
begin
  NotebookPageChanged(nil);
end;

procedure TDelphiXDXPlayForm.EditKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_RETURN) and (NextButton.Enabled) then
  begin
    NextButtonClick(nil);
    Key := 0;
  end;
end;

procedure TDelphiXDXPlayForm.NewGameSessionNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if NewGameSessionName.Text='' then Exit;

  if Key=VK_RETURN then
  begin
    if NextButton.Enabled then
    begin
      NextButtonClick(nil);
      Key := 0;
    end else if NewGamePlayerName.Text='' then
    begin
      NewGamePlayerName.SetFocus;
      Key := 0;
    end;
  end;
end;

procedure TDelphiXDXPlayForm.NewGamePlayerNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if NewGamePlayerName.Text='' then Exit;

  if Key=VK_RETURN then
  begin
    if NextButton.Enabled then
    begin
      NextButtonClick(nil);
      Key := 0;
    end else if NewGameSessionName.Text='' then
    begin
      NewGameSessionName.SetFocus;
      Key := 0;
    end;
  end;
end;

procedure TDelphiXDXPlayForm.JoinGameSessionListKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if JoinGameSessionList.ItemIndex=-1 then Exit;

  if Key=VK_RETURN then
  begin
    if NextButton.Enabled then
    begin
      NextButtonClick(nil);
      Key := 0;
    end else if JoinGamePlayerName.Text='' then
    begin
      JoinGamePlayerName.SetFocus;
      Key := 0;
    end;
  end;
end;

procedure TDelphiXDXPlayForm.JoinGamePlayerNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if JoinGamePlayerName.Text='' then Exit;

  if Key=VK_RETURN then
  begin
    if NextButton.Enabled then
    begin
      NextButtonClick(nil);
      Key := 0;
    end else if JoinGameSessionList.ItemIndex=-1 then
    begin
      JoinGameSessionList.SetFocus;
      Key := 0;         
    end;
  end;
end;

end.

