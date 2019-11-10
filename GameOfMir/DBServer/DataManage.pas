unit DataManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,HumDB;

type
  TfrmDataManage = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    m_FileDB    :TFileDB;
    m_FileHumDB :TFileHumDB;
    procedure Open();
    { Public declarations }
  end;

var
  frmDataManage: TfrmDataManage;

implementation

{$R *.dfm}

{ TfrmDataManage }


procedure TfrmDataManage.FormCreate(Sender: TObject);
begin
  m_FileDB    :=nil;
  m_FileHumDB :=nil;
end;

procedure TfrmDataManage.FormDestroy(Sender: TObject);
begin
//
end;


procedure TfrmDataManage.Open;
begin
  ShowModal;
end;

end.
