unit DXSpriteEdit;

interface

uses
  Windows, SysUtils, Classes, Forms, Dialogs, Controls, ExtCtrls, StdCtrls,
  Graphics, DXSprite;

type

  {  TDelphiXWaveEditForm  }

  TDelphiXSpriteEditForm = class(TForm)
    Bevel2: TBevel;
    OKButton: TButton;
    CancelButton: TButton;
    ClearButton: TButton;
    Panel1: TPanel;
    rgSpriteType: TRadioGroup;
    EAlpha: TEdit;
    EAngle: TEdit;
    EAnimCount: TEdit;
    EAnimLooped: TComboBox;
    EAnimPos: TEdit;
    EAnimSpeed: TEdit;
    EAnimStart: TEdit;
    ECollisioned: TComboBox;
    EHeight: TEdit;
    EMapHeight: TEdit;
    EMapWidth: TEdit;
    EMoved: TComboBox;
    EPixelCheck: TComboBox;
    ETile: TComboBox;
    EVisible: TComboBox;
    EWidth: TEdit;
    EX: TEdit;
    EY: TEdit;
    EZ: TEdit;
    LAlpha: TLabel;
    LAngle: TLabel;
    LAnimCount: TLabel;
    LAnimPos: TLabel;
    LAnimSpeed: TLabel;
    LAnimStart: TLabel;
    LCollisioned: TLabel;
    LHeight: TLabel;
    LMapHeight: TLabel;
    LMapWidth: TLabel;
    LMoved: TLabel;
    LPixelCheck: TLabel;
    LTile: TLabel;
    LVisible: TLabel;
    LAnimLooped: TLabel;
    LWidth: TLabel;
    LX: TLabel;
    LY: TLabel;
    LZ: TLabel;
    Label1: TLabel;
    EBlendMode: TComboBox;
    procedure OKButtonClick(Sender: TObject);
  private
    FChanged: Boolean;
    FvkType: TSpriteType;
    FSprite: TSprite;
    procedure FieldEnabler(SpriteType:TSpriteType);
  public
    procedure LoadDataToForm(AData: TPersistent);
    procedure SaveDataFromForm(var AData: TPersistent);
    property Sprite: TSprite read FSprite write FSprite;
  end;

var
  DelphiXSpriteEditForm: TDelphiXSpriteEditForm;

implementation

uses DXConsts;

{$R *.DFM}

{ TDelphiXSpriteEditForm }

procedure TDelphiXSpriteEditForm.LoadDataToForm(AData: TPersistent);
  Procedure LoadAsSprite;
  Begin
    With AData as TSprite Do Begin
      If Collisioned Then
        ECollisioned.ItemIndex := 1
      Else
        ECollisioned.ItemIndex := 0;
      If Moved Then
        EMoved.ItemIndex := 1
      Else
        EMoved.ItemIndex := 0;
      If Visible Then
        EVisible.ItemIndex := 1
      Else
        EVisible.ItemIndex := 0;
      EHeight.Text := IntToStr(Height);
      EWidth.Text := IntToStr(Width);
      EX.Text := FloatToStr(X);
      EY.Text := FloatToStr(Y);
      EZ.Text := IntToStr(Z);
    End;
  End;
  procedure LoadAsImageSprite;
  Begin
    LoadAsSprite;
    With AData as TImageSprite Do Begin
      EAnimCount.Text := IntToStr(AnimCount);
      If AnimLooped Then
        EAnimLooped.ItemIndex := 1
      Else
        EAnimLooped.ItemIndex := 0;
      EAnimPos.Text := FloatToStr(AnimPos);
      EAnimSpeed.Text := FloatToStr(AnimSpeed);
      EAnimStart.Text := IntToStr(AnimStart);
      If PixelCheck Then
        EPixelCheck.ItemIndex := 1
      Else
        EPixelCheck.ItemIndex := 0;
      If Tile Then
        ETile.ItemIndex := 1
      Else
        ETile.ItemIndex := 0;
    End;
  End;
  procedure LoadAsImageSpriteEx;
  Begin
    LoadAsSprite;
    LoadAsImageSprite;
    With AData as TImageSpriteEx Do Begin
      EAlpha.Text := IntToStr(Alpha);
      EAngle.Text := IntToStr(Angle);
      EBlendMode.ItemIndex := Ord(BlendMode);
    End;
  End;
  procedure LoadAsBackgroundSprite;
  Begin
    LoadAsSprite;
    With AData as TBackgroundSprite Do Begin
      EMapHeight.Text := IntToStr(MapHeight);
      If Tile Then
        ETile.ItemIndex := 1
      Else
        ETile.ItemIndex := 0;
      EMapWidth.Text := IntToStr(MapWidth);
    End;
  End;
const
  cktypearr: Array [TSpriteType] of Integer = (0,2,3,1);
begin
  if AData is TBackgroundSprite Then Fvktype := stBackgroundSprite
  Else if AData is TImageSpriteEx Then Fvktype := stImageSpriteEx
  Else if AData is TImageSprite Then Fvktype := stImageSprite
  Else Fvktype := stSprite;

  rgSpriteType.ItemIndex := ckTypeArr[Fvktype];
  FieldEnabler(Fvktype);
  Try
  Case Fvktype of
    stSprite :           LoadAsSprite;
    stImageSprite :      LoadAsImageSprite;
    stImageSpriteEx :    LoadAsImageSpriteEx;
    stBackgroundSprite : LoadAsBackgroundSprite;
  End;
  Except
    on E: Exception do
      ShowMessage(E.Message);
  End;
end;

procedure TDelphiXSpriteEditForm.SaveDataFromForm(var AData: TPersistent);
  Procedure SaveAsSprite;
  Begin
    With AData as TSprite Do Begin
      Collisioned := ECollisioned.ItemIndex = 1;
      Moved := EMoved.ItemIndex = 1;
      Visible := EVisible.ItemIndex = 1;
      Height := StrToInt(EHeight.Text);
      Width := StrToInt(EWidth.Text);
      X := StrToFloat(EX.Text);
      Y := StrToFloat(EY.Text);
      Z := StrToInt(EZ.Text);
    End;
  End;
  procedure SaveAsImageSprite;
  Begin
    SaveAsSprite;
    With AData as TImageSprite Do Begin
      AnimCount := StrToInt(EAnimCount.Text);
      AnimLooped := EAnimLooped.ItemIndex = 1;
      AnimPos := StrToFloat(EAnimPos.Text);
      AnimSpeed := StrToFloat(EAnimSpeed.Text);
      AnimStart := StrToInt(EAnimStart.Text);

      PixelCheck := EPixelCheck.ItemIndex = 1;
      Tile := ETile.ItemIndex = 1;
    End;
  End;
  procedure SaveAsImageSpriteEx;
  Begin
    SaveAsSprite;
    SaveAsImageSprite;
    With AData as TImageSpriteEx Do Begin
      Alpha := StrToInt(EAlpha.Text);
      Angle := StrToInt(EAngle.Text);
      BlendMode := TBlendMode(EBlendMode.ItemIndex);
    End;
  End;
  procedure SaveAsBackgroundSprite;
  Begin
    SaveAsSprite;
    With AData as TBackgroundSprite Do Begin
      MapHeight := StrToInt(EMapHeight.Text);
      Tile := ETile.ItemIndex = 1;
      MapWidth := StrToInt(EMapWidth.Text);
    End;
  End;
begin
  Try
    Case Fvktype of
      stSprite :           SaveAsSprite;
      stImageSprite :      SaveAsImageSprite;
      stImageSpriteEx :    SaveAsImageSpriteEx;
      stBackgroundSprite : SaveAsBackgroundSprite;
    End;
  Except
    on E: Exception do
      ShowMessage(E.Message);
  End;
end;

procedure TDelphiXSpriteEditForm.OKButtonClick(Sender: TObject);
begin
  FChanged := True;
  if FChanged then
  begin
    Tag := 1;
  end;

  Close;
end;

procedure TDelphiXSpriteEditForm.FieldEnabler(SpriteType: TSpriteType);
Var I:Integer;
begin
  EAlpha.Enabled := (SpriteType in [stImageSpriteEx]);
  EAngle.Enabled := (SpriteType in [stImageSpriteEx]);
  EBlendMode.Enabled := (SpriteType in [stImageSpriteEx]);
  EAnimCount.Enabled := (SpriteType in [stImageSprite, stImageSpriteEx]);
  EAnimLooped.Enabled := (SpriteType in [stImageSprite, stImageSpriteEx]);
  EAnimPos.Enabled := (SpriteType in [stImageSprite, stImageSpriteEx]);
  EAnimSpeed.Enabled := (SpriteType in [stImageSprite, stImageSpriteEx]);
  EAnimStart.Enabled := (SpriteType in [stImageSprite, stImageSpriteEx]);
  ECollisioned.Enabled := (SpriteType in [stSprite..stBackgroundSprite]);
  EHeight.Enabled := (SpriteType in [stSprite..stBackgroundSprite]);
  //EImage.Enabled := (SpriteType in [stImageSprite..stBackgroundSprite]);
  EMapHeight.Enabled := (SpriteType in [stBackgroundSprite]);
  EMapWidth.Enabled := (SpriteType in [stBackgroundSprite]);
  EMoved.Enabled := (SpriteType in [stSprite..stBackgroundSprite]);
  EPixelCheck.Enabled := (SpriteType in [stImageSprite, stImageSpriteEx]);
  ETile.Enabled := (SpriteType in [stImageSprite..stBackgroundSprite]);
  EVisible.Enabled := (SpriteType in [stSprite..stBackgroundSprite]);
  EWidth.Enabled := (SpriteType in [stSprite..stBackgroundSprite]);
  EX.Enabled := (SpriteType in [stSprite..stBackgroundSprite]);
  EY.Enabled := (SpriteType in [stSprite..stBackgroundSprite]);
  EZ.Enabled := (SpriteType in [stSprite..stBackgroundSprite]);
  For I := 0 To ComponentCount-1 Do Begin
    If (Components[I] is TEdit) Then With (Components[I] as TEdit) Do
      If Enabled Then Color := clWindow Else Color := clBtnFace;
    If (Components[I] is TComboBox) Then With (Components[I] as TComboBox) Do
      If Enabled Then Color := clWindow Else Color := clBtnFace;
  End
end;

end.
