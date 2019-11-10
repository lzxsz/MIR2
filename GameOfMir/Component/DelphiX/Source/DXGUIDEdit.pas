unit DXGUIDEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ActiveX, ComObj;

type
  TDelphiXGUIDEditForm = class(TForm)
    Edit: TEdit;
    OKButton: TButton;
    CancelButton: TButton;
    NewButton: TButton;
    procedure NewButtonClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EditEnter(Sender: TObject);
  private
    FChanged: Boolean;
    FOldGUID: string;
  public
    GUID: string;
  end;

var
  DelphiXGUIDEditForm: TDelphiXGUIDEditForm;

implementation

uses DXConsts;

{$R *.DFM}

const
  SIsGUIDnewlyMade = 'Is GUID newly made?';

procedure TDelphiXGUIDEditForm.OKButtonClick(Sender: TObject);
begin
  if FChanged then
  begin
    GUID := GUIDToString(StringToGUID(Edit.Text));
    Tag := 1;
  end;
  Close;
end;

procedure TDelphiXGUIDEditForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TDelphiXGUIDEditForm.NewButtonClick(Sender: TObject);
var
  GUID: TGUID;
begin
  if Application.MessageBox(PChar(SIsGUIDnewlyMade), 'GUID', MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON2)<>IDYES then Exit;

  if CoCreateGuid(GUID)<>0 then
    raise Exception.CreateFmt(SCannotMade, ['GUID']);
  Edit.Text := GUIDToString(GUID);
  FChanged := True;
end;

procedure TDelphiXGUIDEditForm.EditChange(Sender: TObject);
begin
  FChanged := True;
end;

procedure TDelphiXGUIDEditForm.EditExit(Sender: TObject);
begin
  try
    Edit.Text := GUIDToString(StringToGUID(Edit.Text));
  except
    Edit.Text := FOldGUID;
    raise;
  end;
end;

procedure TDelphiXGUIDEditForm.FormShow(Sender: TObject);
begin
  Edit.Text := GUIDToString(StringToGUID(GUID));
end;

procedure TDelphiXGUIDEditForm.EditEnter(Sender: TObject);
begin
  FOldGUID := Edit.Text;
end;

end.
