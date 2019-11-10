unit GLoginServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls;

type
  TfrmLoginServerConfig = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GridGateRoute: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmLoginServerConfig: TfrmLoginServerConfig;

implementation

{$R *.dfm}

procedure TfrmLoginServerConfig.FormCreate(Sender: TObject);
begin
  GridGateRoute.Cells[0,0]:='服务器名称';
  GridGateRoute.Cells[1,0]:='路由标识';
  GridGateRoute.Cells[2,0]:='登录网关内IP';
  GridGateRoute.Cells[3,0]:='登录网关外IP';
  GridGateRoute.Cells[4,0]:='角色网关';
  GridGateRoute.Cells[5,0]:='端口';
end;

procedure TfrmLoginServerConfig.Open;
begin
  ShowModal;
end;

end.
