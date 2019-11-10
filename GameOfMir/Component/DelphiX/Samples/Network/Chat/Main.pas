unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DXPlay, DirectX;
                           
const
  DXCHAT_MESSAGE = 0;

type
  TDXChatMessage = record
    MessageType: DWORD;  {  MessageType is absolutely necessary.  }
    Len: Integer;
    C: array[0..0] of Char;
  end;

type
  TMainForm = class(TForm)
    DXPlay1: TDXPlay;
    Memo1: TMemo;
    Edit1: TEdit;
    Button1: TButton;
    procedure DXPlay1AddPlayer(Sender: TObject; Player: TDXPlayPlayer);
    procedure DXPlay1DeletePlayer(Sender: TObject; Player: TDXPlayPlayer);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DXPlay1Message(Sender: TObject; Player: TDXPlayPlayer; Data: Pointer;
      DataSize: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXPlay1Open(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.DXPlay1AddPlayer(Sender: TObject; Player: TDXPlayPlayer);
begin
  Memo1.Lines.Add(Format('  %s entered a room.', [Player.Name]));
end;

procedure TMainForm.DXPlay1DeletePlayer(Sender: TObject;
  Player: TDXPlayPlayer);
begin
  Memo1.Lines.Add(Format('  %s left a room.', [Player.Name]));
end;

procedure TMainForm.DXPlay1Open(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to DXPlay1.Players.Count-1 do
    if DXPlay1.Players[i].RemotePlayer then
      Memo1.Lines.Add(Format('  %s is entering a room.', [DXPlay1.Players[i].Name]));
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DXPlay1.Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  try
    DXPlay1.Open;
  except
    on E: Exception do
    begin
      Application.ShowMainForm := False;
      Application.HandleException(E);
      Application.Terminate;
    end;
  end;

  MainForm.Caption := Format('%s : %s', [DXPlay1.ProviderName, DXPlay1.SessionName]);
end;

procedure TMainForm.DXPlay1Message(Sender: TObject; Player: TDXPlayPlayer;
  Data: Pointer; DataSize: Integer);
var
  s: string;
begin
  case DXPlayMessageType(Data) of
    DXCHAT_MESSAGE:
        begin
          if TDXChatMessage(Data^).Len<=0 then
            s := ''
          else begin
            SetLength(s, TDXChatMessage(Data^).Len);
            StrLCopy(PChar(s), @TDXChatMessage(Data^).c, Length(s));
          end;

          Memo1.Lines.Add(Format('%s>    %s', [Player.Name, s]));
        end;
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  Msg: ^TDXChatMessage;
  MsgSize: Integer;
begin
  MsgSize := SizeOf(TDXChatMessage)+Length(Edit1.Text);
  GetMem(Msg, MsgSize);
  try
    Msg.MessageType := DXCHAT_MESSAGE;
    Msg.Len := Length(Edit1.Text);
    StrLCopy(@Msg^.c, PChar(Edit1.Text), Length(Edit1.Text));

    {  The message is sent all.  }
    DXPlay1.SendMessage(DPID_ALLPLAYERS, Msg, MsgSize);

    {  The message is sent also to me.  }
    DXPlay1.SendMessage(DXPlay1.LocalPlayer.ID, Msg, MsgSize);

    Edit1.Text := '';
  finally
    FreeMem(Msg);
  end;
end;

procedure TMainForm.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then
  begin
    Button1Click(nil);
    key := 0;
  end;
end;

end.
