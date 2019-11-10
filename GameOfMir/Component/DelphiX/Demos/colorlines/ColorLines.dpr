program ColorLines;

uses
  Forms,
  ScreenColorLines in 'ScreenColorLines.pas' {FormColorLines},
  SpectraLibrary in 'SpectraLibrary.pas',
  BresenhamLibrary in 'BresenhamLibrary.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormColorLines, FormColorLines);
  Application.Run;
end.
