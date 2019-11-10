program DXGDumper;

uses
  Forms,
  dumper in 'dumper.pas' {dump};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tdump, dump);
  Application.Run;
end.
