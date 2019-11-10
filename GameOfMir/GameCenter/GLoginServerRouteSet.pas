unit GLoginServerRouteSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmLoginServerRouteSet = class(TForm)
    GroupBox1: TGroupBox;
  private
    m_boNewRouteMode:Boolean;
    { Private declarations }
  public
    procedure Open(boNewRouteMode:Boolean);
    { Public declarations }
  end;

var
  frmLoginServerRouteSet: TfrmLoginServerRouteSet;

implementation

{$R *.dfm}

{ TfrmLoginServerRouteSet }

procedure TfrmLoginServerRouteSet.Open(boNewRouteMode: Boolean);
begin
  m_boNewRouteMode:=boNewRouteMode;
  ShowModal;
end;

end.
