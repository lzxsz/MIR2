unit pooltestform;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, pool, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    pallo:TPool;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  pallo:=TPool.Create(self);
  pallo.Parent := self;
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
  pallo.loadbitmap;
end;

end.


