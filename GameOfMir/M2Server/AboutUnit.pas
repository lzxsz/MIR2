unit AboutUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg;

type
  TFrmAbout = class(TForm)
    ButtonOK: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open();
  end;

var
  FrmAbout: TFrmAbout;

implementation
uses {EDcodeUnit, Common , }M2Share;
{$R *.dfm}
procedure TFrmAbout.Open();
var
  sProductName: string;
  sVersion: string;
  sUpDateTime: string;
  sProgram: string;
  sWebSite: string;
  sBbsSite: string;
begin
 // Decode(g_sProductName, sProductName);
 // Decode(g_sVersion, sVersion);
//  Decode(g_sUpDateTime, sUpDateTime);
 // Decode(g_sProgram, sProgram);
 // Decode(g_sWebSite, sWebSite);
 // Decode(g_sBbsSite, sBbsSite);
//  EditProductName.Text := sProductName;
//  EditVersion.Text := Format(sVersion, [0]);
//  EditUpDateTime.Text := sUpDateTime;
 // EditProgram.Text := sProgram;
 // EditWebSite.Text := sWebSite;
 // EditBbsSite.Text := sBbsSite;
  ShowModal;
end;



procedure TFrmAbout.ButtonOKClick(Sender: TObject);
begin
  Close;
end;

end.
