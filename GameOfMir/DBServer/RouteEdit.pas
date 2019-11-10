unit RouteEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBShare, StdCtrls, Grobal2;
type
  TfrmRouteEdit = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditSelGate: TEdit;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    EditGateIPaddr1: TEdit;
    EditGateIPaddr2: TEdit;
    Label3: TLabel;
    EditGatePort1: TEdit;
    EditGatePort2: TEdit;
    Label4: TLabel;
    EditGateIPaddr3: TEdit;
    EditGatePort3: TEdit;
    Label5: TLabel;
    EditGateIPaddr4: TEdit;
    EditGatePort4: TEdit;
    Label6: TLabel;
    EditGateIPaddr5: TEdit;
    EditGatePort5: TEdit;
    Label7: TLabel;
    EditGateIPaddr6: TEdit;
    EditGatePort6: TEdit;
    Label8: TLabel;
    EditGateIPaddr7: TEdit;
    EditGatePort7: TEdit;
    Label9: TLabel;
    EditGateIPaddr8: TEdit;
    EditGatePort8: TEdit;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    procedure ButtonOKClick(Sender: TObject);
  private
    m_EditOK:Boolean;
    procedure RefShowRoute();
    function ProcessRouteOK():Boolean;
    { Private declarations }
  public
    m_RouteInfo:TRouteInfo;
    function Open():TRouteInfo;
    { Public declarations }
  end;

var
  frmRouteEdit: TfrmRouteEdit;

implementation

uses HUtil32;

{$R *.dfm}

{ TfrmRouteEdit }

function TfrmRouteEdit.Open():TRouteInfo;
begin
  m_EditOK:=False;
  RefShowRoute();
  ShowModal;
  if m_EditOK then begin
    Result:=m_RouteInfo;
  end else Result.nGateCount:=-1;
    
end;

procedure TfrmRouteEdit.RefShowRoute;
begin
  EditSelGate.Text:=m_RouteInfo.sSelGateIP;
  EditGateIPaddr1.Text:=m_RouteInfo.sGameGateIP[0];
  EditGatePort1.Text:=IntToStr(m_RouteInfo.nGameGatePort[0]);

  EditGateIPaddr2.Text:=m_RouteInfo.sGameGateIP[1];
  EditGatePort2.Text:=IntToStr(m_RouteInfo.nGameGatePort[1]);

  EditGateIPaddr3.Text:=m_RouteInfo.sGameGateIP[2];
  EditGatePort3.Text:=IntToStr(m_RouteInfo.nGameGatePort[2]);

  EditGateIPaddr4.Text:=m_RouteInfo.sGameGateIP[3];
  EditGatePort4.Text:=IntToStr(m_RouteInfo.nGameGatePort[3]);

  EditGateIPaddr5.Text:=m_RouteInfo.sGameGateIP[4];
  EditGatePort5.Text:=IntToStr(m_RouteInfo.nGameGatePort[4]);

  EditGateIPaddr6.Text:=m_RouteInfo.sGameGateIP[5];
  EditGatePort6.Text:=IntToStr(m_RouteInfo.nGameGatePort[5]);

  EditGateIPaddr7.Text:=m_RouteInfo.sGameGateIP[6];
  EditGatePort7.Text:=IntToStr(m_RouteInfo.nGameGatePort[6]);

  EditGateIPaddr8.Text:=m_RouteInfo.sGameGateIP[7];
  EditGatePort8.Text:=IntToStr(m_RouteInfo.nGameGatePort[7]);
end;

procedure TfrmRouteEdit.ButtonOKClick(Sender: TObject);
begin
  if Sender = ButtonOK then begin
    if ProcessRouteOK() then  begin
      m_EditOK:=True;
      Close;
    end;
  end else
  if Sender = ButtonCancel then begin
    Close();
  end;

end;

function TfrmRouteEdit.ProcessRouteOK():Boolean;
var
  sGameGateIP:String;
  nGameGatePort:Integer;
begin
  Result:=False;
  FillChar(m_RouteInfo,SizeOf(m_RouteInfo),0);
  m_RouteInfo.sSelGateIP:=Trim(EditSelGate.Text);
  if not IsIPaddr(m_RouteInfo.sSelGateIP) then begin
    MessageBox(Handle,'角色网关输入错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditSelGate.SetFocus;
    exit;
  end;
  sGameGateIP   :=Trim(EditGateIPaddr1.Text);
  nGameGatePort :=Str_ToInt(EditGatePort1.Text,0);

  if not IsIPaddr(sGameGateIP) then begin
    MessageBox(Handle,'游戏网关一输入错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditGateIPaddr1.SetFocus;
    exit;
  end;
  if nGameGatePort <= 0 then begin
    MessageBox(Handle,'游戏网关一输入错误！！！','错误信息',MB_OK + MB_ICONERROR);
    EditGatePort1.SetFocus;
    exit;
  end;
  m_RouteInfo.sGameGateIP[0]   :=sGameGateIP;
  m_RouteInfo.nGameGatePort[0] :=nGameGatePort;
  m_RouteInfo.nGateCount        :=1;
  Result:=True;
  sGameGateIP   :=Trim(EditGateIPaddr2.Text);
  nGameGatePort :=Str_ToInt(EditGatePort2.Text,0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then begin
    exit;
  end;
  m_RouteInfo.sGameGateIP[1]   :=sGameGateIP;
  m_RouteInfo.nGameGatePort[1] :=nGameGatePort;
  m_RouteInfo.nGateCount       :=2;

  sGameGateIP   :=Trim(EditGateIPaddr3.Text);
  nGameGatePort :=Str_ToInt(EditGatePort3.Text,0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then begin
    exit;
  end;
  m_RouteInfo.sGameGateIP[2]   :=sGameGateIP;
  m_RouteInfo.nGameGatePort[2] :=nGameGatePort;
  m_RouteInfo.nGateCount       :=3;

  sGameGateIP   :=Trim(EditGateIPaddr4.Text);
  nGameGatePort :=Str_ToInt(EditGatePort4.Text,0);
  if (not IsIPaddr(m_RouteInfo.sGameGateIP[3])) or (nGameGatePort <= 0) then begin
    exit;
  end;
  m_RouteInfo.sGameGateIP[3]   :=sGameGateIP;
  m_RouteInfo.nGameGatePort[3] :=nGameGatePort;
  m_RouteInfo.nGateCount       :=4;

  sGameGateIP:=Trim(EditGateIPaddr5.Text);
  nGameGatePort:=Str_ToInt(EditGatePort5.Text,0);
  if (not IsIPaddr(sGameGateIP)) or (nGameGatePort <= 0) then begin
    exit;
  end;
  m_RouteInfo.sGameGateIP[4]   :=sGameGateIP;
  m_RouteInfo.nGameGatePort[4] :=nGameGatePort;
  m_RouteInfo.nGateCount       :=5;

  sGameGateIP:=Trim(EditGateIPaddr6.Text);
  nGameGatePort:=Str_ToInt(EditGatePort6.Text,0);
  if (not IsIPaddr(m_RouteInfo.sGameGateIP[5])) or (nGameGatePort <= 0) then begin
    exit;
  end;
  m_RouteInfo.sGameGateIP[5]   :=sGameGateIP;
  m_RouteInfo.nGameGatePort[5] :=nGameGatePort;
  m_RouteInfo.nGateCount       :=6;

  sGameGateIP:=Trim(EditGateIPaddr7.Text);
  nGameGatePort:=Str_ToInt(EditGatePort7.Text,0);
  if (not IsIPaddr(m_RouteInfo.sGameGateIP[6])) or (nGameGatePort <= 0) then begin
    exit;
  end;
  m_RouteInfo.sGameGateIP[6]   :=sGameGateIP;
  m_RouteInfo.nGameGatePort[6] :=nGameGatePort;
  m_RouteInfo.nGateCount       :=7;

  sGameGateIP   :=Trim(EditGateIPaddr8.Text);
  nGameGatePort :=Str_ToInt(EditGatePort8.Text,0);
  if (not IsIPaddr(m_RouteInfo.sGameGateIP[7])) or (nGameGatePort <= 0) then begin
    exit;
  end;
  m_RouteInfo.sGameGateIP[7]   :=sGameGateIP;
  m_RouteInfo.nGameGatePort[7] :=nGameGatePort;
  m_RouteInfo.nGateCount       :=8;

end;

end.
