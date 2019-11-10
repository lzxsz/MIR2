unit ViewLevel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Grids, ObjBase;

type
  TfrmViewLevel = class(TForm)
    GroupBox10: TGroupBox;
    Label4: TLabel;
    EditHumanLevel: TSpinEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ComboBoxJob: TComboBox;
    GridHumanInfo: TStringGrid;
    ButtonClose: TButton;
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditHumanLevelChange(Sender: TObject);
    procedure ComboBoxJobChange(Sender: TObject);
  private
    PlayObject: TPlayObject;
    procedure RecalcHuman();
    procedure RefView();
    { Private declarations }
  public
    procedure Open;
    { Public declarations }
  end;

var
  frmViewLevel: TfrmViewLevel;

implementation

uses M2Share, Envir;



{$R *.dfm}

{ TfrmLevel }

procedure TfrmViewLevel.Open;
begin
  PlayObject := TPlayObject.Create;
  PlayObject.m_Abil.Level := 1;
  PlayObject.m_btJob := jWarr;
  PlayObject.m_sMapName := '0';
  PlayObject.m_PEnvir := g_MapManager.FindMap('0');
  PlayObject.m_nCurrX := 330;
  PlayObject.m_nCurrY := 266;
  EditHumanLevel.Value := 1;
  ComboBoxJob.ItemIndex := 0;
  RefView();
  ShowModal;
  PlayObject.Free;
end;

procedure TfrmViewLevel.ButtonCloseClick(Sender: TObject);
begin
  Close();
end;

procedure TfrmViewLevel.FormCreate(Sender: TObject);
begin
  GridHumanInfo.Cells[0, 0] := '属性';
  GridHumanInfo.Cells[1, 0] := '数值';
  GridHumanInfo.Cells[0, 1] := '经验值';
  GridHumanInfo.Cells[0, 2] := '防御';
  GridHumanInfo.Cells[0, 3] := '魔防';
  GridHumanInfo.Cells[0, 4] := '攻击力';
  GridHumanInfo.Cells[0, 5] := '魔法';
  GridHumanInfo.Cells[0, 6] := '道术';
  GridHumanInfo.Cells[0, 7] := '生命值';
  GridHumanInfo.Cells[0, 8] := '魔法值';
  GridHumanInfo.Cells[0, 9] := '背包';
  GridHumanInfo.Cells[0, 10] := '负重';
  GridHumanInfo.Cells[0, 11] := '腕力';
end;

procedure TfrmViewLevel.RecalcHuman;
begin
  PlayObject.RecalcLevelAbilitys;
  PlayObject.RecalcAbilitys;
  PlayObject.HasLevelUp(0);
end;

procedure TfrmViewLevel.RefView;
begin
  RecalcHuman();
  GridHumanInfo.Cells[1, 1] := IntToStr(PlayObject.m_Abil.MaxExp);
  GridHumanInfo.Cells[1, 2] := IntToStr(LoWord(PlayObject.m_WAbil.AC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.AC));
  GridHumanInfo.Cells[1, 3] := IntToStr(LoWord(PlayObject.m_WAbil.MAC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.MAC));
  GridHumanInfo.Cells[1, 4] := IntToStr(LoWord(PlayObject.m_WAbil.DC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.DC));
  GridHumanInfo.Cells[1, 5] := IntToStr(LoWord(PlayObject.m_WAbil.MC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.MC));
  GridHumanInfo.Cells[1, 6] := IntToStr(LoWord(PlayObject.m_WAbil.SC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.SC));
  GridHumanInfo.Cells[1, 7] := IntToStr(PlayObject.m_WAbil.HP) + '/' + IntToStr(PlayObject.m_WAbil.MaxHP);
  GridHumanInfo.Cells[1, 8] := IntToStr(PlayObject.m_WAbil.MP) + '/' + IntToStr(PlayObject.m_WAbil.MaxMP);
  GridHumanInfo.Cells[1, 9] := IntToStr(PlayObject.m_WAbil.Weight) + '/' + IntToStr(PlayObject.m_WAbil.MaxWeight);
  GridHumanInfo.Cells[1, 10] := IntToStr(PlayObject.m_WAbil.WearWeight) + '/' + IntToStr(PlayObject.m_WAbil.MaxWearWeight);
  GridHumanInfo.Cells[1, 11] := IntToStr(PlayObject.m_WAbil.HandWeight) + '/' + IntToStr(PlayObject.m_WAbil.MaxHandWeight);
end;

procedure TfrmViewLevel.EditHumanLevelChange(Sender: TObject);
begin
  if EditHumanLevel.Value < 1 then EditHumanLevel.Value := 1;

  PlayObject.m_Abil.Level := EditHumanLevel.Value;
  RefView();
end;

procedure TfrmViewLevel.ComboBoxJobChange(Sender: TObject);
begin
  PlayObject.m_btJob := ComboBoxJob.ItemIndex;
  RefView();
end;

end.
