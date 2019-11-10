program dxwEdit;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Main};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
