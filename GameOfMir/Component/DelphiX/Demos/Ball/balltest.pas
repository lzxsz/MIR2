unit balltest;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, pallo, StdCtrls;

type
  Tbiljarditesti = class(TForm)
    ButtonPiirra: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonPiirraClick(Sender: TObject);
  private
    pallo:TPallo;
  public
  end;


var
  biljarditesti: Tbiljarditesti;

implementation

{$R *.DFM}



procedure Tbiljarditesti.FormCreate(Sender: TObject);
begin
  doublebuffered := True;
  pallo := TPallo.Create(self);
  pallo.Parent := self;

  pallo.SetAngle(30);
  pallo.LoadBitmaps('hauto.bmp');
end;

procedure Tbiljarditesti.ButtonPiirraClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to 100 do begin
    pallo.DrawBall;
    Application.ProcessMessages;
    pallo.Move;
  end;
end;
            
end.

