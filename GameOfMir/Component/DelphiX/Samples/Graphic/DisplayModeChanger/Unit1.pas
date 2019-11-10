unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, DXDraws, DXClass, StdCtrls;

type

  TForm1 = class(TDXForm)
    DXDraw: TDXDraw;
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    FileExit: TMenuItem;
    ModesMenu: TMenuItem;
    procedure FileExitClick(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure ModeItemClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.ModeItemClick(Sender: TObject);
var
  s: string;
  i, AWidth, AHeight, ABitCount: Integer;
begin
  DXDraw.Finalize;

  s := TMenuItem(Sender).Caption;

  i := Pos('x', s);
  AWidth := StrToInt(Copy(s, 1, i-1));
  s := Copy(s, i+1, Length(s));

  i := Pos('x', s);
  AHeight := StrToInt(Copy(s, 1, i-1));
  s := Copy(s, i+1, Length(s));

  ABitCount := StrToInt(s);

  DXDraw.Display.Width := AWidth;
  DXDraw.Display.Height := AHeight;
  DXDraw.Display.BitCount := ABitCount;
  DXDraw.Options := DXDraw.Options + [doFullScreen];
  DXDraw.Initialize;
end;

procedure TForm1.DXDrawInitialize(Sender: TObject);
var
  i: Integer;
  MenuItem: TMenuItem;
begin
  for i:=ModesMenu.Count-1 downto 0 do
    ModesMenu.Items[0].Free;

  for i:=0 to DXDraw.Display.Count-1 do
  begin
    MenuItem := TMenuItem.Create(ModesMenu);
    with MenuItem do
    begin
      Caption := Format('%dx%dx%d', [DXDraw.Display.Modes[i].Width,
        DXDraw.Display.Modes[i].Height, DXDraw.Display.Modes[i].BitCount]);
      OnClick := ModeItemClick;
    end;
    ModesMenu.Add(MenuItem);
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  DXDrawInitialize(nil);
end;     

end.
