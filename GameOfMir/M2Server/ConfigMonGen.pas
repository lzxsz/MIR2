unit ConfigMonGen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmConfigMonGen = class(TForm)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Button1: TButton;
    Button3: TButton;
    GroupBox2: TGroupBox;
    ListBox1: TListBox;
    GroupBox3: TGroupBox;
    ListBoxMonGen: TListBox;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmConfigMonGen: TfrmConfigMonGen;

implementation

uses UsrEngn, M2Share, Grobal2;

{$R *.dfm}

{ TfrmConfigMonGen }

procedure TfrmConfigMonGen.Open;
var
  i: Integer;
  MonGen: pTMonGenInfo;
begin
  for i := 0 to UserEngine.m_MonGenList.Count - 1 do
  begin
    MonGen := UserEngine.m_MonGenList.Items[i];
    ListBoxMonGen.Items.AddObject(MonGen.sMapName + '(' + IntToStr(MonGen.nX) + ':' + IntToStr(MonGen.nY) + ')' + ' - ' + MonGen.sMonName, TObject(MonGen));
  end;
  Self.ShowModal;
end;

procedure TfrmConfigMonGen.Button1Click(Sender: TObject);
var
   sr               :   TSearchRec;
begin
  listbox1.Items.Clear;
  if   FindFirst('.\Envir\MonItems'+'\*.*',   faAnyFile,   sr)   =   0   then
  begin
  if (sr.Name <> '.') and (sr.Name <> '..') then listbox1.Items.Add(sr.Name);
  while   FindNext(sr)   =   0   do
  if (sr.Name <> '.') and (sr.Name <> '..') then listbox1.Items.Add(sr.name);
  FindClose(SR);
  end;
  end;

procedure TfrmConfigMonGen.Button3Click(Sender: TObject);
var
  LoadList		: TStringList;
    i       :Integer;
      sMonGenFile	: String;
begin
    sMonGenFile:=g_Config.sEnvirDir + 'MonItems\' + ListBox1.Items.Strings [ListBox1.ItemIndex];
    LoadList:=TStringList.Create;
    for i:=0 to  Memo1.Lines.Count - 1 do begin
      LoadList.Add(Memo1.Lines.Strings[i]);
    end;
    LoadList.SaveToFile(sMonGenFile);
    LoadList.free;
end;

procedure TfrmConfigMonGen.ListBox1Click(Sender: TObject);
var
  LoadList		: TStringList;
  I			      : Integer;
  LineText		: String;
  sMonGenFile	: String;
begin
  Memo1.Clear;
  sMonGenFile:=g_Config.sEnvirDir + 'MonItems\' + ListBox1.Items.Strings [ListBox1.ItemIndex];
  if FileExists(sMonGenFile) then begin
    LoadList:=TStringList.Create;
    LoadList.LoadFromFile(sMonGenFile);
    for I := 0 to LoadList.Count - 1 do begin
      LineText:=LoadList.Strings[I];
      if (LineText = '') or (LineText[1] = ';') then Continue;
      Memo1.Lines.Add(LineText);
    end;
  end;
//   LoadList.Free;
end;
end.
