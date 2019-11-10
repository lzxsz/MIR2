program scroll_demo;

//  example for TDXScroll unit
//  Copyright by Pawel Sulkowski '2000
//  http://coders.shnet.pl/klub/
//  Code: Sulek       sulek@shnet.pl
//  Last changes 29.12.2000
//  Please leave information about the author even if you change something


uses
  Forms,
  main in 'main.pas' {mainForm},
  dxscroll in 'dxscroll.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'TDXScroll Presentation';
  Application.CreateForm(TmainForm, mainForm);
  Application.Run;
end.
