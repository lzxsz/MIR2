unit DXReg;

interface
{$I DelphiXcfg.inc}
uses
  Windows, SysUtils, Classes, Forms, Dialogs, Graphics, TypInfo,
  {$IfNDef DelphiX_Delphi6} DsgnIntf, {$Else} Designintf, DesignEditors, {$EndIf}
  DXDraws, DXSounds, DIB, DXWave, DXInput, DXPlay, DXSprite, DXClass;

type

  {  TDXDrawDisplayProperty  }

  TDXDrawDisplayProperty = class(TClassProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

  {  TDIBProperty  }

  TDIBProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetValue: string; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  {  TDXDIBEditor  }

  TDXDIBEditor = class(TComponentEditor)
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  {  TPictureCollectionItem_PictureProperty  }

  TPictureCollectionItem_PictureProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetValue: string; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  {  TDXImageListEditor  }

  TDXImageListEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  {  TWaveProperty  }

  TWaveProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetValue: string; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  {  TDXWaveEditor  }

  TDXWaveEditor = class(TComponentEditor)
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  {  TDXWaveListEditor  }

  TDXWaveListEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  {  TForceFeedbackEffectsProperty  }

  TForceFeedbackEffectsProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetValue: string; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  {  TDXInputEditor  }

  TDXInputEditor = class(TComponentEditor)
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  {  TGUIDProperty  }

  TGUIDProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  {  TSpriteProperty  }

  TSpriteProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TSpriteEditor = class(TDefaultEditor)
  public
    {$IfDef DelphiX_Delphi6}
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
    {$Else}
    procedure EditProperty(PropertyEditor : TPropertyEditor;
                           var continue, FreeEditor : boolean); override;
    {$EndIf}
  end;

  {  TMidiProperty  }

  TMidiProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetValue: string; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TMidiEditor = class(TDefaultEditor)
  public
    {$IfDef DelphiX_Delphi6}
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
    {$Else}
    procedure EditProperty(PropertyEditor : TPropertyEditor;
                           var continue, FreeEditor : boolean); override;
    {$EndIf}
  end;

procedure Register;

implementation

uses DXPictEdit, DXWaveEdit, DXFFBEdit, DXInptEdit, DXGUIDEdit, DXSpriteEdit,
  DXMidiEdit;

const
  SNone = '(None)';

  SSettingImage = '&Image...';
  SSettingWave = '&Wave...';
  SDXGFileFilter = 'DXG file(*.dxg)|*.dxg|All files(*.*)|*.*';
  SDXGOpenFileFilter = 'DXG file(*.dxg)|*.dxg|Bitmap file(*.bmp)|*.bmp|All files(*.*)|*.*';
  SDXWFileFilter = 'DXW file(*.dxw)|*.dxg|All files(*.*)|*.*';
  SDXWOpenFileFilter = 'DXW file(*.dxw)|*.dxw|Wave file(*.wav)|*.wav|All files(*.*)|*.*';
  SSinglePlayer = '&Single player';
  SMultiPlayer1 = 'Multi player &1';
  SMultiPlayer2 = 'Multi player &2';

  SOpen = '&Open...';
  SSave = '&Save..';

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TDXDrawDisplay), nil, '',
    TDXDrawDisplayProperty);

  RegisterPropertyEditor(TypeInfo(TDIB), nil, '', TDIBProperty);
  RegisterComponentEditor(TCustomDXDIB, TDXDIBEditor);

  RegisterPropertyEditor(TypeInfo(TPicture), TPictureCollectionItem, 'Picture', TPictureCollectionItem_PictureProperty);
  RegisterComponentEditor(TCustomDXImageList, TDXImageListEditor);

  RegisterPropertyEditor(TypeInfo(TWave), nil, '', TWaveProperty);
  RegisterComponentEditor(TCustomDXWave, TDXWaveEditor);

  RegisterComponentEditor(TCustomDXWaveList, TDXWaveListEditor);

  RegisterPropertyEditor(TypeInfo(TForceFeedbackEffects), nil, '', TForceFeedbackEffectsProperty);

  RegisterComponentEditor(TCustomDXInput, TDXInputEditor);

  RegisterPropertyEditor(TypeInfo(string), TCustomDXPlay, 'GUID', TGUIDProperty);

  RegisterPropertyEditor(TypeInfo(TImageSprite), NIL{TSpriteCollectionItem}, 'ISprite', TSpriteProperty);
  RegisterPropertyEditor(TypeInfo(TImageSpriteEx), NIL{TSpriteCollectionItem}, 'ISpriteEx', TSpriteProperty);
  RegisterPropertyEditor(TypeInfo(TSprite), NIL{TSpriteCollectionItem}, 'Sprite', TSpriteProperty);
  RegisterPropertyEditor(TypeInfo(TBackgroundSprite), NIL{TSpriteCollectionItem}, 'BckSprite', TSpriteProperty);
  //RegisterComponentEditor(TDXSpriteEngine,TSpriteEditor);

  RegisterPropertyEditor(TypeInfo(TMusicDataProp), nil, 'MIDI', TMidiProperty);

  RegisterComponents('DelphiX',
    [TDXDraw,
    TDXDIB,
    TDXImageList,
{$IFDEF DX3D_deprecated}
    TDX3D,
{$ENDIF}
    TDXSound,
    TDXWave,
    TDXWaveList,
    TDXInput,
    TDXPlay,
    TDXSpriteEngine,
    TDXTimer,
    TDXPaintBox,
    TDXFont,
    TDXPowerFont,
    TDXMusic]);
end;

{ TDXDrawDisplayProperty }

function TDXDrawDisplayProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paValueList] - [paReadOnly];
end;

const
  SDisplayMode = '%dx%dx%d';

function TDXDrawDisplayProperty.GetValue: string;
begin
  with TDXDrawDisplay(GetOrdValue) do
    Result := Format(SDisplayMode, [Width, Height, BitCount]);
end;

procedure TDXDrawDisplayProperty.GetValues(Proc: TGetStrProc);
const             
  List: array[0..2] of TPoint = (
  (X:  640; Y:  480),
  (X:  800; Y:  600),
  (X: 1024; Y:  768));
var
  BitCount, i: Integer;
begin
  for i:=Low(List) to High(List) do
    for BitCount:=1 to 3 do
      Proc(Format(SDisplayMode, [List[i].x, List[i].y, BitCount*8]));
end;

procedure TDXDrawDisplayProperty.SetValue(const Value: string);
var
  s: string;
  i, AWidth, AHeight, ABitCount: Integer;
begin
  s := Value;

  i := Pos('x', s);
  AWidth := StrToInt(Copy(s, 1, i-1));
  s := Copy(s, i+1, Length(s));

  i := Pos('x', s);
  AHeight := StrToInt(Copy(s, 1, i-1));
  s := Copy(s, i+1, Length(s));

  ABitCount := StrToInt(s);

  with TDXDrawDisplay(GetOrdValue) do
  begin
    Width := AWidth;
    Height := AHeight;
    BitCount := ABitCount;
  end;

  SetOrdValue(GetOrdValue);
end;

{  TDIBProperty  }

procedure TDIBProperty.Edit;
var
  Form: TDelphiXPictureEditForm;
begin
  Form := TDelphiXPictureEditForm.Create(nil);
  try
    Form.ViewBox.Picture.Assign(TDIB(GetOrdValue));
    Form.DIBClassOnly := True;
    Form.ShowModal;
    if Form.Tag<>0 then
    begin
      SetOrdValue(Integer(Form.ViewBox.Picture.Graphic));
      Designer.Modified;
    end;
  finally
    Form.Free;
  end;
end;

function TDIBProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TDIBProperty.GetValue: string;
begin
  if TDIB(GetOrdValue).Size=0 then
    Result := SNone
  else
    Result := Format('(%s)', [TObject(GetOrdValue).ClassName]);
end;

{  TDXDIBEditor  }

procedure TDXDIBEditor.Edit;
var
  Form: TDelphiXPictureEditForm;
begin
  Form := TDelphiXPictureEditForm.Create(nil);
  try
    Form.ViewBox.Picture.Assign(TCustomDXDIB(Component).DIB);
    Form.DIBClassOnly := True;
    Form.ShowModal;
    if Form.Tag<>0 then
    begin
      TCustomDXDIB(Component).DIB.Assign(TGraphic(Form.ViewBox.Picture.Graphic));
      Designer.Modified;
    end;
  finally
    Form.Free;
  end;
end;

procedure TDXDIBEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: Edit;
  end;
end;

function TDXDIBEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := SSettingImage;
  end;
end;

function TDXDIBEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{  TPictureCollectionItem_PictureProperty  }

procedure TPictureCollectionItem_PictureProperty.Edit;
var
  Form: TDelphiXPictureEditForm;
  Item: TPictureCollectionItem;
  TempDIB: TDIB;
begin
  Form := TDelphiXPictureEditForm.Create(nil);
  try
    Form.ViewBox.Picture := TPicture(GetOrdValue);
    Form.ShowModal;
    if Form.Tag<>0 then
    begin
      SetOrdValue(Integer(Form.ViewBox.Picture));

      Item := GetComponent(0) as TPictureCollectionItem;
      if Item.Picture.Graphic<>nil then
      begin
        TempDIB := TDIB.Create;
        try
          TempDIB.SetSize(1, 1, 24);
          TempDIB.Canvas.Draw(0, 0, Item.Picture.Graphic);
          Item.TransparentColor := TempDIB.Pixels[0, 0];
        finally
          TempDIB.Free;
        end;
      end;
      Designer.Modified;
    end;
  finally
    Form.Free;
  end;
end;

function TPictureCollectionItem_PictureProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TPictureCollectionItem_PictureProperty.GetValue: string;
begin
  if (TPicture(GetOrdValue).Graphic=nil) or (TPicture(GetOrdValue).Graphic.Empty) then
    Result := SNone
  else
    Result := Format('(%s)', [TPicture(GetOrdValue).Graphic.ClassName]);
end;

{  TDXImageListEditor  }

procedure TDXImageListEditor.ExecuteVerb(Index: Integer);
var
  OpenDialog: TOpenDialog;
  SaveDialog: TSaveDialog;
  i: Integer;
begin
  case Index of
    0: begin
         OpenDialog := TOpenDialog.Create(nil);
         try
           OpenDialog.DefaultExt := 'dxg';
           OpenDialog.Filter := SDXGOpenFileFilter;
           OpenDialog.Options := [ofPathMustExist, ofFileMustExist, ofAllowMultiSelect];
           if OpenDialog.Execute then
           begin
             if OpenDialog.FilterIndex=2 then
             begin
               for i:=0 to OpenDialog.Files.Count-1 do
                 with TPictureCollectionItem.Create(TCustomDXImageList(Component).Items) do
                 begin
                   try
                     Picture.LoadFromFile(OpenDialog.Files[i]);
                     Name := ExtractFileName(OpenDialog.Files[i]);
                   except
                     Free;
                     raise;
                   end;
                 end;
             end else
               TCustomDXImageList(Component).Items.LoadFromFile(OpenDialog.FileName);
             Designer.Modified;
           end;
         finally
           OpenDialog.Free;
         end;
       end;
    1: begin
         SaveDialog := TSaveDialog.Create(nil);
         try
           SaveDialog.DefaultExt := 'dxg';
           SaveDialog.Filter := SDXGFileFilter;
           SaveDialog.Options := [ofOverwritePrompt, ofPathMustExist];
           if SaveDialog.Execute then
             TCustomDXImageList(Component).Items.SaveToFile(SaveDialog.FileName);
         finally
           SaveDialog.Free;
         end;
       end;
  end;
end;

function TDXImageListEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := SOpen;
    1: Result := SSave;
  end;
end;

function TDXImageListEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

{  TWaveProperty  }

procedure TWaveProperty.Edit;
var
  Form: TDelphiXWaveEditForm;
begin
  Form := TDelphiXWaveEditForm.Create(nil);
  try
    Form.Wave := TWave(GetOrdValue);
    Form.ShowModal;
    if Form.Tag<>0 then
    begin
      SetOrdValue(Integer(Form.Wave));
      Designer.Modified;
    end;
  finally
    Form.Free;
  end;
end;

function TWaveProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TWaveProperty.GetValue: string;
begin
  if TWave(GetOrdValue).Size=0 then
    Result := SNone
  else
    Result := Format('(%s)', [TObject(GetOrdValue).ClassName]);
end;

{  TDXWaveEditor  }

procedure TDXWaveEditor.Edit;
var
  Form: TDelphiXWaveEditForm;
begin
  Form := TDelphiXWaveEditForm.Create(nil);
  try
    Form.Wave := TCustomDXWave(Component).Wave;
    Form.ShowModal;
    if Form.Tag<>0 then
    begin
      TCustomDXWave(Component).Wave := Form.Wave;
      Designer.Modified;
    end;
  finally
    Form.Free;
  end;
end;

procedure TDXWaveEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: Edit;
  end;
end;

function TDXWaveEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := SSettingWave;
  end;
end;

function TDXWaveEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{  TDXWaveListEditor  }

procedure TDXWaveListEditor.ExecuteVerb(Index: Integer);
var
  OpenDialog: TOpenDialog;
  SaveDialog: TSaveDialog;
  i: Integer;
begin
  case Index of
    0: begin
         OpenDialog := TOpenDialog.Create(nil);
         try
           OpenDialog.DefaultExt := 'dxw';
           OpenDialog.Filter := SDXWOpenFileFilter;
           OpenDialog.Options := [ofPathMustExist, ofFileMustExist, ofAllowMultiSelect];
           if OpenDialog.Execute then
           begin
             if OpenDialog.FilterIndex=2 then
             begin
               for i:=0 to OpenDialog.Files.Count-1 do
                 with TWaveCollectionItem.Create(TCustomDXWaveList(Component).Items) do
                 begin
                   try
                     Wave.LoadFromFile(OpenDialog.Files[i]);
                     Name := ExtractFileName(OpenDialog.Files[i]);
                   except
                     Free;
                     raise;
                   end;
                 end;
             end else
               TCustomDXWaveList(Component).Items.LoadFromFile(OpenDialog.FileName);
             Designer.Modified;
           end;
         finally
           OpenDialog.Free;
         end;
       end;
    1: begin
         SaveDialog := TSaveDialog.Create(nil);
         try
           SaveDialog.DefaultExt := 'dxw';
           SaveDialog.Filter := SDXWFileFilter;
           SaveDialog.Options := [ofOverwritePrompt, ofPathMustExist];
           if SaveDialog.Execute then
             TCustomDXWaveList(Component).Items.SaveToFile(SaveDialog.FileName);
         finally
           SaveDialog.Free;
         end;
       end;
  end;
end;

function TDXWaveListEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := SOpen;
    1: Result := SSave;
  end;
end;

function TDXWaveListEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

{  TForceFeedbackEffectsProperty  }

procedure TForceFeedbackEffectsProperty.Edit;
var
  Form: TDelphiXFFEditForm;
  Effects: TForceFeedbackEffects;
begin
  Effects := TForceFeedbackEffects(GetOrdValue);

  Form := TDelphiXFFEditForm.Create(nil);
  try
    if Effects.Input is TJoystick then
      Form.Effects := Form.DXInput.Joystick.Effects
    else if Effects.Input is TKeyboard then
      Form.Effects := Form.DXInput.Keyboard.Effects
    else if Effects.Input is TMouse then
      Form.Effects := Form.DXInput.Mouse.Effects
    else Exit;

    Form.Effects.Assign(TForceFeedbackEffects(GetOrdValue));
    Form.ShowModal;
    if Form.Tag<>0 then
    begin
      SetOrdValue(Integer(Form.Effects));
      Designer.Modified;
    end;
  finally
    Form.Free;
  end;
end;

function TForceFeedbackEffectsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TForceFeedbackEffectsProperty.GetValue: string;
begin
  if TForceFeedbackEffects(GetOrdValue).Count=0 then
    Result := SNone
  else
    Result := Format('(%s)', [TObject(GetOrdValue).ClassName]);
end;

{  TDXInputEditor  }

procedure TDXInputEditor.Edit;
var
  Form: TDelphiXInputEditForm;
begin
  Form := TDelphiXInputEditForm.Create(nil);
  try
    Form.DXInput := TCustomDXInput(Component);
    Form.ShowModal;
    if Form.Tag<>0 then
      Designer.Modified;
  finally
    Form.Free;
  end;
end;

procedure TDXInputEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: begin
         with TCustomDXInput(Component) do
         begin
           Joystick.ID := 0;
           Keyboard.KeyAssigns := DefKeyAssign;
         end;
         Designer.Modified;
       end;
    1: begin
         with TCustomDXInput(Component) do
         begin
           Joystick.ID := 0;
           Keyboard.KeyAssigns := DefKeyAssign2_1;
         end;
         Designer.Modified;
       end;
    2: begin
         with TCustomDXInput(Component) do
         begin
           Joystick.ID := 1;
           Keyboard.KeyAssigns := DefKeyAssign2_2;
         end;
         Designer.Modified;
       end;
  end;
end;

function TDXInputEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := SSinglePlayer;
    1: Result := SMultiPlayer1;
    2: Result := SMultiPlayer2;
  end;
end;

function TDXInputEditor.GetVerbCount: Integer;
begin
  Result := 3;
end;

{  TGUIDProperty  }

procedure TGUIDProperty.Edit;
var
  Form: TDelphiXGUIDEditForm;
begin
  Form := TDelphiXGUIDEditForm.Create(nil);
  try
    Form.GUID := GetStrValue;
    Form.ShowModal;
    if Form.Tag<>0 then
    begin
      SetStrValue(Form.GUID);
      Designer.Modified;
    end;
  finally
    Form.Free;
  end;
end;

function TGUIDProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

{ TSpriteProperty }

procedure TSpriteProperty.Edit;
var
  DirectAccessToSprite: TPersistent;
  Form: TDelphiXSpriteEditForm;
begin
  DirectAccessToSprite := TPersistent(GetOrdValue);
  Form := TDelphiXSpriteEditForm.Create(nil);
  try
    Form.LoadDataToForm(DirectAccessToSprite);
    //Form.Sprite.AsSign(TPersistent(GetOrdValue));
    Form.ShowModal;
    if Form.Tag<>0 then
    begin
      Form.SaveDataFromForm(DirectAccessToSprite);
      Designer.Modified;
    end;
  finally
    Form.Free;
  end;
end;

function TSpriteProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;
{$IfDef DelphiX_Delphi6}
procedure TSpriteEditor.EditProperty(const Prop: IProperty; var Continue: Boolean);
{$Else}
procedure TSpriteEditor.EditProperty(PropertyEditor : TPropertyEditor;
                                   var continue, FreeEditor : boolean);
{$EndIf}
var
  PropName : string;
begin
  PropName:={$IfDef DelphiX_Delphi6}Prop{$Else}PropertyEditor{$EndIf}.GetName;
  if (CompareText(PropName, 'Sprite')=0) Or (CompareText(PropName, 'ISprite')=0)
    Or (CompareText(PropName, 'ISpriteEx')=0) Or (CompareText(PropName, 'BckSprite')=0) then
  begin
    {$IfDef DelphiX_Delphi6}Prop{$Else}PropertyEditor{$EndIf}.edit;
    continue:=false;
  end;
end;

{  TMidiProperty  }

procedure TMidiProperty.Edit;
var
  DelphiXMidiEditForm: TDelphiXMidiEditForm;
  DirectAccessToMidiData: TMusicDataProp;
  S: string; I: Integer;
begin
  DirectAccessToMidiData := TMusicDataProp(GetOrdValue);
  DelphiXMidiEditForm := TDelphiXMidiEditForm.Create(nil);
  try
    DelphiXMidiEditForm.MidiData := DirectAccessToMidiData.MusicData;
    DelphiXMidiEditForm.MidiFileName := DirectAccessToMidiData.MidiName;
    DelphiXMidiEditForm.Showmodal;
    if DelphiXMidiEditForm.Tag = 1 then begin
      DirectAccessToMidiData.MusicData := DelphiXMidiEditForm.MidiData;
      S := '';
      if DelphiXMidiEditForm.MidiFileName <> '' then begin
        S := ExtractFileName(DelphiXMidiEditForm.MidiFileName);
        I := Pos(ExtractFileExt(S),S);
        if I > 0 then S := Copy(S, 1, I-1);
      end;
      DirectAccessToMidiData.MidiName := S;
      Designer.Modified;
    end;
  finally
    DelphiXMidiEditForm.Free;
  end;
end;

function TMidiProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TMidiProperty.GetValue: string;
var
  S: string;
begin
  S := TMusicDataProp(GetOrdValue).MusicData;
  if Length(S) = 0 then
    Result := SNone
  else
    Result := '(Midi)';
end;

{$IfDef DelphiX_Delphi6}
procedure TMidiEditor.EditProperty(const Prop: IProperty; var Continue: Boolean);
{$Else}
procedure TMidiEditor.EditProperty(PropertyEditor : TPropertyEditor;
                                   var continue, FreeEditor : boolean);
{$EndIf}
var
  PropName : string;
begin
  PropName:={$IfDef DelphiX_Delphi6}Prop{$Else}PropertyEditor{$EndIf}.GetName;
  if (CompareText(PropName, 'Midi')=0) then
  begin
    {$IfDef DelphiX_Delphi6}Prop{$Else}PropertyEditor{$EndIf}.edit;
    continue:=false;
  end;
end;

end.