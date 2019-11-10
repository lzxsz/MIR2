unit CreateChr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Buttons;
type
  TFrmCreateChr=class(TForm)
    EdUserId: TEdit;
    EdChrName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    BitBtnOK: TBitBtn;
    BitBtnCancel: TBitBtn;
    Label3: TLabel;
    EditSelectID: TEdit;
    procedure FormShow(Sender : TObject);
  private
    function  GetInputInfo():Boolean;
    { Private declarations }
  public
    sUserId:String;
    sChrName:String;
    nSelectID:Integer;
    function IncputChrInfo():Boolean;
    { Public declarations }
  end;

var
  FrmCreateChr: TFrmCreateChr;

implementation

uses HUtil32;

{$R *.DFM}

procedure TFrmCreateChr.FormShow(Sender : TObject);
begin
  EdUserId.SetFocus;
end;

function TFrmCreateChr.IncputChrInfo: Boolean;//0x0049C65C
begin
  sUserId  := '';
  sChrName := '';
  Result   := GetInputInfo;
end;

function TFrmCreateChr.GetInputInfo():Boolean;
begin
  Result:=False;
  EdUserId.Text:=sUserId;
  EdChrName.Text:=sChrName;
  if Self.ShowModal = mrOk then begin
    sUserId   :=Trim(EdUserId.Text);
    sChrName  :=Trim(EdChrName.Text);
    nSelectID :=Str_ToInt(Trim(EditSelectID.Text),-1);
    if nSelectID < 0 then begin
      MessageBox(Handle,'选择ID输入不正确！！！','确认信息',MB_OK + MB_ICONEXCLAMATION);
      exit;
    end;
      Result:= True;
  end;
end;
end.
