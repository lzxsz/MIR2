unit DXInptEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Menus, ExtCtrls, Spin, Buttons, DXInput;

type
  TDelphiXInputEditForm = class(TForm)
    PopupMenu: TPopupMenu;
    Player1: TMenuItem;
    Player2_1: TMenuItem;
    Player2_2: TMenuItem;
    OKButton: TButton;
    CancelButton: TButton;
    PageControl: TPageControl;
    JoyTabSheet: TTabSheet;
    KeyTabSheet: TTabSheet;
    GroupBox1: TGroupBox;
    StateListBox: TListBox;
    KeyComboBox1: TComboBox;
    KeyComboBox2: TComboBox;
    KeyComboBox3: TComboBox;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    IDEdit: TSpinEdit;
    Bevel1: TBevel;
    AutoCenter: TCheckBox;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    DeadZoneZ: TSpinEdit;
    DeadZoneY: TSpinEdit;
    DeadZoneX: TSpinEdit;
    GroupBox4: TGroupBox;
    Label4: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    RangeZ: TSpinEdit;
    RangeY: TSpinEdit;
    RangeX: TSpinEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ForceFeedback: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure StateListBoxClick(Sender: TObject);
    procedure Player1Click(Sender: TObject);
    procedure Player2_1Click(Sender: TObject);
    procedure Player2_2Click(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EditChange(Sender: TObject);
  private
    FChanged: Boolean;
    FOldIndex: Integer;
    procedure UpdateData;
  public
    DXInput: TCustomDXInput;
    KeyAssigns: TKeyAssignList;
  end;

var
  DelphiXInputEditForm: TDelphiXInputEditForm;

implementation

uses DXConsts;

{$R *.dfm}

function GetKeyText(Key: Integer): string;
begin
  Result := '';
  case Key of
    0          : Result := SNone;
    VK_TAB     : Result := 'TAB';
    VK_RETURN  : Result := 'Enter';
    VK_SHIFT   : Result := 'Shift';
    VK_ESCAPE  : Result := 'Esc';
    VK_SPACE   : Result := 'Space';
    VK_PRIOR   : Result := 'Page Up';
    VK_NEXT    : Result := 'Page Down';
    VK_LEFT    : Result := SKeyLeft;
    VK_UP      : Result := SKeyUp;
    VK_RIGHT   : Result := SKeyRight;
    VK_DOWN    : Result := SKeyDown;
    $30..$39,
    $41..$5A   : Result := Char(Key); {0..9, A..Z}
    VK_NUMPAD0..VK_NUMPAD9:
                 Result := 'Num '+inttostr(Key-VK_NUMPAD0);
    VK_MULTIPLY: Result := 'Num *';
    VK_ADD     : Result := 'Num +';
    VK_SUBTRACT: Result := 'Num -';
    VK_DECIMAL : Result := 'Num .';
    VK_DIVIDE  : Result := 'Num /';
    VK_F1..VK_F15:
                 Result := 'F'+inttostr(Key-VK_F1+1);
  end;
end;

function DXInputStateText(State: TDXInputState): string;
begin
  Result := '';
  case State of
    isUp   : Result := 'Up';
    isDown : Result := 'Down';
    isLeft : Result := 'Left';
    isRight: Result := 'Right';
    isButton1..isButton32
      : Result := 'Button' + inttostr(Ord(State)-Ord(isButton1)+1);
  end;
end;

procedure TDelphiXInputEditForm.FormCreate(Sender: TObject);
var
  i: TDXInputState;
  i2: Integer;
  s: string;
begin
 for i := LOW(TDXInputState) to HIGH(TDXInputState) do
    StateListBox.Items.Add(DXInputStateText(i));

  for i2:=0 to 255 do
  begin
    s := GetKeyText(i2);
    if s<>'' then KeyComboBox1.Items.AddObject(s, Pointer(i2));
  end;
  KeyComboBox2.Items.Assign(KeyComboBox1.Items);
  KeyComboBox3.Items.Assign(KeyComboBox1.Items);
end;

procedure TDelphiXInputEditForm.FormShow(Sender: TObject);
begin
  KeyAssigns := DXInput.Keyboard.KeyAssigns;

  IDEdit.Value := DXInput.Joystick.ID;

  AutoCenter.Checked := DXInput.Joystick.AutoCenter;
  ForceFeedback.Checked := DXInput.Joystick.ForceFeedback;

  DeadZoneX.Value := DXInput.Joystick.DeadZoneX;
  DeadZoneY.Value := DXInput.Joystick.DeadZoneY;
  DeadZoneZ.Value := DXInput.Joystick.DeadZoneZ;

  RangeX.Value := DXInput.Joystick.RangeX;
  RangeY.Value := DXInput.Joystick.RangeY;
  RangeZ.Value := DXInput.Joystick.RangeZ;

  UpdateData;

  FChanged := False;
end;

procedure TDelphiXInputEditForm.OKButtonClick(Sender: TObject);
begin
  if FChanged then
  begin
    if StateListBox.ItemIndex<>-1 then
    begin
      FOldIndex := StateListBox.ItemIndex;
      StateListBoxClick(nil);
    end;

    DXInput.Joystick.ID := IDEdit.Value;

    DXInput.Joystick.AutoCenter := AutoCenter.Checked;
    DXInput.Joystick.ForceFeedback := ForceFeedback.Checked;

    DXInput.Joystick.DeadZoneX := DeadZoneX.Value;
    DXInput.Joystick.DeadZoneY := DeadZoneY.Value;
    DXInput.Joystick.DeadZoneZ := DeadZoneZ.Value;

    DXInput.Joystick.RangeX := RangeX.Value;
    DXInput.Joystick.RangeY := RangeY.Value;
    DXInput.Joystick.RangeZ := RangeZ.Value;

    DXInput.Keyboard.KeyAssigns := KeyAssigns;

    Tag := 1;
  end;

  Close;
end;

procedure TDelphiXInputEditForm.UpdateData;
begin
  FOldIndex := -1;
  StateListBox.ItemIndex := 0;
  StateListBoxClick(nil);
end;

procedure TDelphiXInputEditForm.StateListBoxClick(Sender: TObject);

  procedure SetItemIndex(ComboBox: TComboBox; Data: Integer);
  var
    i: Integer;
  begin
    for i:=0 to ComboBox.Items.Count-1 do
      if Integer(ComboBox.Items.Objects[i])=Data then
      begin
        ComboBox.ItemIndex := i;
        Exit;
      end;
    ComboBox.ItemIndex := 0;
  end;

var
  KeyAssign: PKeyAssign;
begin
  if FOldIndex<>-1 then
  begin
    KeyAssign := @KeyAssigns[TDXInputState(FOldIndex)];
    KeyAssign^[0] := Integer(KeyComboBox1.Items.Objects[KeyComboBox1.ItemIndex]);
    KeyAssign^[1] := Integer(KeyComboBox2.Items.Objects[KeyComboBox2.ItemIndex]);
    KeyAssign^[2] := Integer(KeyComboBox3.Items.Objects[KeyComboBox3.ItemIndex]);
  end;
  FOldIndex := StateListBox.ItemIndex;

  KeyAssign := @KeyAssigns[TDXInputState(FOldIndex)];
  SetItemIndex(KeyComboBox1,  KeyAssign^[0]);
  SetItemIndex(KeyComboBox2,  KeyAssign^[1]);
  SetItemIndex(KeyComboBox3,  KeyAssign^[2]);
end;

procedure TDelphiXInputEditForm.Player1Click(Sender: TObject);
begin
  IDEdit.Value := 0;
  KeyAssigns := DefKeyAssign;

  FChanged := True;
  UpdateData;
end;

procedure TDelphiXInputEditForm.Player2_1Click(Sender: TObject);
begin
  IDEdit.Value := 0;
  KeyAssigns := DefKeyAssign2_1;

  FChanged := True;
  UpdateData;
end;

procedure TDelphiXInputEditForm.Player2_2Click(Sender: TObject);
begin
  IDEdit.Value := 1;
  KeyAssigns := DefKeyAssign2_2;

  FChanged := True;
  UpdateData;
end;

procedure TDelphiXInputEditForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TDelphiXInputEditForm.EditChange(Sender: TObject);
begin
  FChanged := True;
end;

end.

