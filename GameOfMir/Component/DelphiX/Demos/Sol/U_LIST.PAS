unit u_list;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids;

type
  TForm2 = class(TForm)
    lista: TStringGrid;
    procedure FormActivate(Sender: TObject);
    procedure listaSetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses u_sol32;

{$R *.DFM}

procedure TForm2.FormActivate(Sender: TObject);
var i:byte;
begin
lista.rowcount:=form1.ip;
lista.cells[0,0]:='N°';
lista.cells[1,0]:='X';
lista.cells[2,0]:='Y';
for i:=  1 to form1.ip do
   with lista do
   begin
        cells[0,i]:=inttostr(i);
        cells[1,i]:=inttostr(xp[i]);
        cells[2,i]:=inttostr(yp[i]);
   end;
end;

procedure TForm2.listaSetEditText(Sender: TObject; ACol, ARow: Longint;
  const Value: string);
var num,code:longint;
begin
     if  (arow > 0) then
         begin
            val(value,num,code);
            if code <> 0 then
               exit
         end
     else
        exit;

     if (acol=1) then
          xp[arow]:=num
     else
          Yp[arow]:=num;
end;

end.
