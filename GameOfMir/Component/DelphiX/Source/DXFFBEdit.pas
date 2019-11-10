unit DXFFBEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, DXInput, TypInfo, ExtCtrls, Menus, ComCtrls;

type
  TDelphiXFFEditForm = class(TForm)
    ListGroupBox: TGroupBox;
    AddButton: TButton;
    DelButton: TButton;
    EditGroupBox: TGroupBox;
    EffectTypeBox: TComboBox;
    EffectTypeLabel: TLabel;
    ConstantLabel: TLabel;
    ConstantYEdit: TSpinEdit;
    ConstantXEdit: TSpinEdit;
    ConstantXLabel: TLabel;
    ConstantYLabel: TLabel;
    FadeTimeLabel: TLabel;
    FadeTimeEdit: TSpinEdit;
    PeriodLabel: TLabel;
    PeriodEdit: TSpinEdit;
    PeriodLabel2: TLabel;
    PowerLabel: TLabel;
    TimeLabel: TLabel;
    TimeEdit: TSpinEdit;
    TimeLabel2: TLabel;
    AttackTimeEditLabel: TLabel;
    AttackTimeEdit: TSpinEdit;
    RunButton: TButton;
    RunGroupButton: TButton;
    OKButton: TButton;
    CancelButton: TButton;
    DXInput: TDXInput;
    NameEditLabel: TLabel;
    NameEdit: TEdit;
    Bevel1: TBevel;
    StopButton: TButton;
    PopupMenu: TPopupMenu;
    A1: TMenuItem;
    DeleteEffectItem: TMenuItem;
    PowerEdit: TSpinEdit;
    Timer: TTimer;
    Bevel2: TBevel;
    N1: TMenuItem;
    N2: TMenuItem;
    SaveToFileItem: TMenuItem;
    AddFromFileButton: TButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    EffectView: TTreeView;
    ConditionLabel: TLabel;
    ConditionXLabel: TLabel;
    ConditionXEdit: TSpinEdit;
    ConditionYLabel: TLabel;
    ConditionYEdit: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    AttackLevelEdit: TSpinEdit;
    FadeLevelEdit: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure EffectViewChange(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure RunButtonClick(Sender: TObject);
    procedure RunGroupButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure ChangeEvent(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure NameEditChange(Sender: TObject);
    procedure EffectViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure EffectViewDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure AddFromFileButtonClick(Sender: TObject);
    procedure SaveToFileItemClick(Sender: TObject);
    procedure EffectViewEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure EffectTypeBoxChange(Sender: TObject);
  private
    FChanged: Boolean;
    FSelectEffect: TForceFeedbackEffect;
    FOldStates: TDXInputStates;
    FUpdating: Boolean;
    function AddTree(Parent: TTreeNode; Effect: TForceFeedbackEffect): TTreeNode;
    procedure Save;
  public
    Effects: TForceFeedbackEffects;
  end;

var
  DelphiXFFEditForm: TDelphiXFFEditForm;

implementation

uses DXConsts;

{$R *.DFM}

procedure TDelphiXFFEditForm.FormCreate(Sender: TObject);
var
  e: TForceFeedbackEffectType;
  s: string;
begin
  for e:=Low(e) to High(e) do
  begin
    if e=etNone then
      s := SNone
    else
      s := GetEnumName(TypeInfo(TForceFeedbackEffectType), Integer(e));

    EffectTypeBox.Items.Add(s);
  end;
end;

function TDelphiXFFEditForm.AddTree(Parent: TTreeNode; Effect: TForceFeedbackEffect): TTreeNode;
var
  i: Integer;
begin
  Result := EffectView.Items.AddChildObject(Parent, Effect.Name, Effect);
  for i:=0 to Effect.Count-1 do
    AddTree(Result, Effect.Effects[i]);
end;

procedure TDelphiXFFEditForm.Save;
begin
  if FChanged then EffectViewChange(nil, nil);
end;

procedure TDelphiXFFEditForm.FormShow(Sender: TObject);
begin
  Caption := Format(SFFBEffectEditor, [Effects.Input.ClassName]);

  Effects.Input.Enabled := True;

  EffectView.Selected := AddTree(nil, Effects);
  if EffectView.Selected<>nil then
    EffectView.Selected.Expanded := True;
end;

procedure TDelphiXFFEditForm.OKButtonClick(Sender: TObject);
begin
  Save;
  Tag := 1;
  Close;
end;

procedure TDelphiXFFEditForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure SetControlEnabled(Control: TControl; Value: Boolean);
var
  NewColor: TColor;
begin
  Control.Enabled := Value;

  if Value then NewColor := clWindow else NewColor := clBtnFace;

  if Control is TComboBox then TComboBox(Control).Color := NewColor;
  if Control is TSpinEdit then TSpinEdit(Control).Color := NewColor;
  if Control is TEdit then TEdit(Control).Color := NewColor;
end;

procedure TDelphiXFFEditForm.EffectViewChange(Sender: TObject; Node: TTreeNode);
var
  i: Integer;
  Control: TControl;
begin
  StopButtonClick(nil);

  FUpdating := True;
  try
    if FSelectEffect<>nil then
    begin
      if FChanged then
      begin
        with FSelectEffect do
        begin
          Name := NameEdit.Text;

          EffectType := etNone;

          Power := PowerEdit.Value;
          Time := TimeEdit.Value;
          AttackTime := AttackTimeEdit.Value;
          AttackLevel := AttackLevelEdit.Value;
          FadeTime := FadeTimeEdit.Value;
          FadeLevel := FadeLevelEdit.Value;
          Constant := Point(ConstantXEdit.Value, ConstantYEdit.Value);
          Period := PeriodEdit.Value;
          Condition := Point(ConditionXEdit.Value, ConditionYEdit.Value);

          EffectType := TForceFeedbackEffectType(EffectTypeBox.ItemIndex);
        end;
      end;
    end;

    FSelectEffect := nil;
    if (EffectView.Selected<>nil) and (EffectView.Selected.Data<>nil) then
      FSelectEffect := EffectView.Selected.Data;

    DelButton.Enabled := (FSelectEffect<>nil) and (FSelectEffect.Parent<>nil);
    DeleteEffectItem.Enabled := DelButton.Enabled;
    SaveToFileItem.Enabled := FSelectEffect<>nil;

    if FSelectEffect<>nil then
    begin
      for i:=0 to ComponentCount-1 do
        if (Components[i] is TControl) then
        begin
          Control := TControl(Components[i]);
          if Control.Parent=EditGroupBox then
            SetControlEnabled(Control, True);
        end;
    end else
    begin
      for i:=0 to ComponentCount-1 do
        if (Components[i] is TControl) then
        begin
          Control := TControl(Components[i]);
          if Control.Parent=EditGroupBox then
          begin
            SetControlEnabled(Control, False);
            if Control is TEdit then
              TEdit(Control).Text := ''
            else if Control is TSpinEdit then
              TSpinEdit(Control).Value := 0
            else if Control is TComboBox then
              TComboBox(Control).ItemIndex := 0
            else if Control is TCheckBox then
              TCheckBox(Control).Checked := False;
          end;
        end;
    end;

    if FSelectEffect<>nil then
    begin
      with FSelectEffect do
      begin
        NameEdit.Text := Name;

        EffectTypeBox.ItemIndex := Integer(EffectType);

        PowerEdit.Value := Power;
        TimeEdit.Value := Time;

        AttackTimeEdit.Value := AttackTime;
        AttackLevelEdit.Value := AttackLevel;

        FadeTimeEdit.Value := FadeTime;
        FadeLevelEdit.Value := FadeLevel;

        ConstantXEdit.Value := Constant.X;
        ConstantYEdit.Value := Constant.Y;

        PeriodEdit.Value := Period;

        ConditionXEdit.Value := Condition.X;
        ConditionYEdit.Value := Condition.Y;
      end;

      EffectTypeBoxChange(nil);
    end;
  finally
    FUpdating := False;
  end;

  FChanged := False;
  FOldStates := [];
end;

procedure TDelphiXFFEditForm.AddButtonClick(Sender: TObject);
var
  Effect: TForceFeedbackEffect;
  OwnerEffect: TForceFeedbackEffect;
  i, j: Integer;
  Flag: Boolean;
begin
  if FSelectEffect<>nil then
    OwnerEffect := FSelectEffect
  else
    OwnerEffect := Effects;

  {  Unique name making  }
  j := 0;
  repeat
    Flag := True;
    Inc(j);
    for i:=0 to OwnerEffect.Count-1 do
      if AnsiCompareText(OwnerEffect[i].Name, Format('Effect%d', [j]))=0 then
      begin
        Flag := False;
        Break;
      end;
  until Flag;

  {  Effect making  }
  Effect := TForceFeedbackEffect.Create(OwnerEffect);
  Effect.Name := Format('Effect%d', [j]);

  EffectView.Selected := AddTree(EffectView.Selected, Effect);
end;

procedure TDelphiXFFEditForm.DelButtonClick(Sender: TObject);
begin
  FSelectEffect.Free;
  FSelectEffect := nil;

  EffectView.Selected.Delete;
end;

procedure TDelphiXFFEditForm.RunButtonClick(Sender: TObject);
begin
  if not RunButton.Enabled then Exit;

  Save;

  if not DXInput.UseDirectInput then
  begin
    Screen.Cursor := crHourGlass;
    try
      DXInput.UseDirectInput := True;
    finally
      Screen.Cursor := crDefault;
    end;
  end;

  FSelectEffect.Start;
end;

procedure TDelphiXFFEditForm.RunGroupButtonClick(Sender: TObject);
var
  Effect: TForceFeedbackEffect;
begin
  if not RunGroupButton.Enabled then Exit;

  Save;

  if not DXInput.UseDirectInput then
  begin
    Screen.Cursor := crHourGlass;
    try
      DXInput.UseDirectInput := True;
    finally
      Screen.Cursor := crDefault;
    end;
  end;

  Effect := FSelectEffect;
  while (Effect.Parent<>nil) and (Effect.Parent.Parent<>nil) do
    Effect := Effect.Parent;

  Effect.Start;
end;

procedure TDelphiXFFEditForm.StopButtonClick(Sender: TObject);
begin
  Effects.Stop;
  Effects.UnLoad(True);
end;

procedure TDelphiXFFEditForm.ChangeEvent(Sender: TObject);
begin
  if not FUpdating then FChanged := True;
end;

procedure TDelphiXFFEditForm.TimerTimer(Sender: TObject);
var
  s: TDXInputStates;
begin
  if not (Effects.Input is TKeyboard) then
  begin
    Effects.Input.Update;
    s := Effects.Input.States;

    if (isButton1 in s) and (not (isButton1 in FOldStates)) then
      RunGroupButtonClick(nil)
    else if (isButton2 in s) and (not (isButton2 in FOldStates)) then
      RunButtonClick(nil)
    else if (s*[isButton1, isButton2]=[]) and (FOldStates*[isButton1, isButton2]<>[]) then
      StopButtonClick(nil);

    FOldStates := s;
  end;
end;

procedure TDelphiXFFEditForm.NameEditChange(Sender: TObject);
begin
  if not FUpdating then
    if EffectView.Selected<>nil then
    begin
      EffectView.Selected.Text := NameEdit.Text;
      FSelectEffect.Name := NameEdit.Text;
    end;
end;

procedure TDelphiXFFEditForm.EffectViewDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  Node: TTreeNode;
begin
  Accept := False;

  Node := EffectView.GetNodeAt(X, Y);
  if Node=nil then Exit;

  if Node=EffectView.Items.GetFirstNode then Exit;

  while Node<>nil do
  begin
    if Node=EffectView.Selected then
      Exit;
    Node := Node.Parent;
  end;

  Accept := True;
end;

procedure TDelphiXFFEditForm.EffectViewDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  Node, Node2: TTreeNode;
  Effect: TForceFeedbackEffect;
begin
  Save;

  Node := EffectView.GetNodeAt(X, Y);

  if Node<>nil then
  begin
    Effect := TObject(EffectView.Selected.Data) as TForceFeedbackEffect;

    Node2 := EffectView.Selected;

    if X>Node.DisplayRect(True).Right+10 then
    begin
      {  Effect is moved to the child.  }
      Effect.Parent := TObject(Node.Data) as TForceFeedbackEffect;
      EffectView.Selected.MoveTo(Node, naAddChild);
      Effect.Index := EffectView.Selected.Index;
    end else
    begin
      {  Effect is moved to the brother.  }
      Effect.Parent := (TObject(Node.Data) as TForceFeedbackEffect).Parent;
      EffectView.Selected.MoveTo(Node, naInsert);
      Effect.Index := EffectView.Selected.Index;
    end;

    EffectView.Selected := Node2;

    EffectView.Invalidate;
  end;
end;

procedure TDelphiXFFEditForm.AddFromFileButtonClick(Sender: TObject);
var
  i: Integer;
  Effect: TForceFeedbackEffect;
begin
  if not OpenDialog.Execute then Exit;

  Save;

  for i:=0 to OpenDialog.Files.Count-1 do
  begin
    Effect := TForceFeedbackEffect.Create(Effects);
    try
      Effect.LoadFromFile(OpenDialog.Files[i]);
    except
      Effect.Free;
      raise;
    end;

    EffectView.Selected := AddTree(EffectView.Items.GetFirstNode, Effect);
  end;
end;

procedure TDelphiXFFEditForm.SaveToFileItemClick(Sender: TObject);
begin
  SaveDialog.FileName := FSelectEffect.Name+'.ffe';

  if not SaveDialog.Execute then Exit;

  Save;

  FSelectEffect.SaveToFile(SaveDialog.FileName);
end;

procedure TDelphiXFFEditForm.EffectViewEdited(Sender: TObject;
  Node: TTreeNode; var S: String);
begin
  NameEdit.Text := s;
end;

procedure TDelphiXFFEditForm.EffectTypeBoxChange(Sender: TObject);
var
  EffectType: TForceFeedbackEffectType;
begin
  ChangeEvent(Sender);

  EffectType := TForceFeedbackEffectType(EffectTypeBox.ItemIndex);

  SetControlEnabled(PowerEdit, EffectType<>etNone);
  SetControlEnabled(TimeEdit, EffectType<>etNone);

  SetControlEnabled(AttackTimeEdit, EffectType<>etNone);
  SetControlEnabled(AttackLevelEdit, EffectType<>etNone);

  SetControlEnabled(FadeTimeEdit, EffectType<>etNone);
  SetControlEnabled(FadeLevelEdit, EffectType<>etNone);

  SetControlEnabled(ConstantXEdit, EffectType in [etConstantForce, etPeriodic, etCondition]);
  SetControlEnabled(ConstantYEdit, EffectType in [etConstantForce, etPeriodic, etCondition]);

  SetControlEnabled(PeriodEdit, EffectType in [etPeriodic]);

  SetControlEnabled(ConditionXEdit, EffectType in [etCondition]);
  SetControlEnabled(ConditionYEdit, EffectType in [etCondition]);
end;

end.
