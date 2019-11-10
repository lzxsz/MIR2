
// Panu Niva 3.12.2000
// Biljardi-pelin pääohjelma
// Pelaaminen tapahtuu hiiren avulla.
// Hiiren osoitin kohdistetaan lyöntipisteeseen
// ja painetaan hiiren ykkösnappia, jolloin
// lyöntipallo liikkuu kohti hiiren osoitinta.
// Lyönnin voimakkuuden voi säätää
// Shift ( - ) ja Return ( + ) näppäimillä.
// ohjeet piirtyy myös pelin näytölle.
// Projektiin mukaan DXBall, ShootBall Sound ja About.
// Muutoksia:
// Kun pallo menee pussin suulle se häviää
// Muutetaan myöhemmin siten että pallon
// annetaan mennä syvemmälle pussiin ennenkuin
// se poistetaan pelipöydältä.
// Näin saadaan peli mallinnettua enemmän
// oikean biljardin mukaiseksi.
// Lisätääm myös pallojen määrä viiteentoista
// sekä kahta väriä + musta pallo eli kasipallo.


unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXClass, DXDraws, DXInput, Math, DXBall, ShootBall, Sound, MPlayer, Menus,
  StdCtrls, About, OleCtrls, SHDocVw;

const
  InitialNumBalls = 6; // Pallojen maksimilukumäärä-1 alussa
  TimerInterval = 15;  // Kellotus
  MaxSpeed = 15;
  VASEN = 31;          // Etäisyydet reunoista
  OIKEA = 31;
  YLA = 51;
  ALA = 31;

  YPUSSI1 = 60;        // Reuna Pussien etäisyydet Laidoista Y-suunnassa
  YPUSSI2 = 40;
  XPUSSI  = 365;       // Keski Pussien reunojen etäisyydet Laidoista

  REUNA = 10;          // Pallon etäisyys laidasta x- tai y- suunnassa,
  YLAREUNA = 40;       // kun pallo poistetaan (=tuhotaan pöydältä).
  Help = 'direction.html';
type
  TMainForm = class(TDXForm)
    DXDraw: TDXDraw;
    ImageList: TDXImageList;
    DXTimer: TDXTimer;
    DXInput: TDXInput;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Options1: TMenuItem;
    Numberofballs1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    HowtoPlay1: TMenuItem;
    WebBrowser1: TWebBrowser;
    ButtonHelpOK: TButton;
    NewGame1: TMenuItem;
    ButtonSlowSpeed: TButton;
    ButtonFastSpeed: TButton;
    Label1: TLabel;
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure DXDrawMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Sound1Change(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Numberofballs1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure HowtoPlay1Click(Sender: TObject);
    procedure ButtonHelpOKClick(Sender: TObject);
    procedure NewGame1Click(Sender: TObject);
    procedure ButtonSlowSpeedClick(Sender: TObject);
    procedure ButtonFastSpeedClick(Sender: TObject);
  private
    pallo: Array[0..InitialNumBalls] of TDXBall; // Muutettava yleiskäyttöiseksi
    Shooted: Array[0..InitialNumBalls] of TShootBall; // Muutettava yleiskäyttöiseksi
    Beep:TSound;              // Click soundi
    procedure CollisionResponseBalls;
    procedure CollisionResponseSides(pm:integer);
    procedure FrictionalResistance(parameter:integer);
    procedure DrawSides;
    procedure BackUp(parameter:integer);
    procedure TestDestroy(parameter:integer);
    procedure Print(x,y:integer; s:string);
    procedure CreateBalls;
  end;

var
  MainForm: TMainForm;
  Speed:integer;             // Lyöntivoima
  Friction:real;             // Kitka
  ShootedBalls:integer;      // Pussittejen pallojen lkm;
  NumBalls:integer;          // Pallojen lukumäärä lomakkeen
                             // alustuksen jälkeen
  NumBallsDestroy:integer;   // Pöydöltä poistettujen pallojen lkm
  HitBallOut:Boolean;        // Onko lyöntipallo ulkona vai ei
implementation

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Beep := TSound.Create(self);    // "Ääni" luokan muodostus
  Beep.Parent := self;
  Beep.LoadSound (ExtractFilePath(ParamStr(0))+'puck.wav');   // Click ääni
  //imageList.Items.LoadFromFile('whiteball.dxg'); // lyöntipallo items[0]

  imageList.Items.MakeColorTable;
  DXDraw.ColorTable := ImageList.Items.ColorTable;
  DXDraw.DefColorTable := ImageList.Items.ColorTable;
  CreateBalls;
end;

procedure TMainForm.DXDrawInitialize(Sender: TObject);
begin
  DXTimer.Enabled := True;
end;

procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
  DXTimer.Enabled := False;
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
var
  i:integer;
  param:integer;
begin
  if not DXDraw.CanDraw then exit;

  DXDraw.Surface.Fill(2595);  {Vihryt väri 2595}

  {  Pallon liikunto  }

  for i:=0 to NumBalls do
  begin
    param := i;
    FrictionalResistance(param); // Kitka
    pallo[i].Move;
    CollisionResponseBalls;   // Testataan onko törmäyksiä muihin palloihin
    CollisionResponseSides(param); // Testataan onko törmäyksiä laitoihin

    ImageList.Items[pallo[i].ballcolour].Draw(DXDraw.Surface,round(pallo[i].X),round(pallo[i].Y),0);
  end;

  //    ImageList.Items[0].Draw(DXDraw.Surface, X, Y, 0); Piirretään muistiin

  DrawSides;    // Piirretään reunat;
  DXDraw.Flip;  // "Kääntää" näytön sisällön näkyviin.
end;

procedure TMainForm.CollisionResponseBalls;
var
  a:integer;      // Pallo A törmää
  b:integer;      // Pallo B:hen.
begin
  for a:=0 to NumBalls do
  begin
    for b:= a+1 to NumBalls do
    begin
         if (a = b) then  // Itseensä ei voi verrata
           continue;
         pallo[a].React(pallo[b]);
         if pallo[a].Tag = 1 then
         begin
           Beep.PlayMode := True;    // Click Ääni;
           Beep.PlaySound;
           pallo[a].Tag := 0;
           Beep.PlayMode := False;
         end;
    end;
  end;
end;

procedure TMainForm.FrictionalResistance(parameter:integer);

// Lasketaan kitkan aihettama vähennys
// siirtymiin dx ja dy ( ts. nopeudet x- ja y- suunnissa )

var
  fx:real;
  fy:real;
  length:real;
begin
  fx := pallo[parameter].dx;
  fy := pallo[parameter].dy;
  length := sqrt(fx*fx + fy*fy);

// Lasketaan kitkan aiheuttama vastus
  if length >= 0.50 then
  begin
    fx := friction*fx;
    fy := friction*fy;
  end;

  if length < 0.50 then
  begin
    pallo[parameter].dx := 0;
    pallo[parameter].dy := 0;
  end;

  pallo[parameter].dx := pallo[parameter].dx - fx;
  pallo[parameter].dy := pallo[parameter].dy - fy;
end;

procedure TMainForm.CollisionResponseSides(pm:integer);

// laitoihin törmäyksessä on oletuksena
// että pallon energia säilyy törmäyksessä
// muuttumattomana.
// Jos pallo menee pussiin tuhotaan pallo ja laitetaan se
// näytille ruudun ylälaitaan luomalla ilmentymä ShootBall- luokalle.
// Jotta saadaan jotain käyttöä sinänsä turhalle luokalle.

begin
    if pallo[pm].X <= VASEN then
    begin
      // Testataan ollaanko pussin kohdalla y-suunnassa.
      // Jos on annetaan pallon liikkua yli laidan.
      if (pallo[pm].Y < YPUSSI1) or
         (pallo[pm].Y > DXDraw.Surface.Height-ImageList.Items[0].Height-YPUSSI2) then
      begin
      // Testataan onko pallo tuhottavissa
        TestDestroy(pm);
        exit;
      end;
      while (pallo[pm].X < VASEN) do
      // Peruutetaan palloa kunnes se on pelialueen laitojen sisällä
      begin
        BackUp(pm);
      end;
      // Muutetaan pallon x-suunta vastakkaiseksi
      pallo[pm].dx := -(pallo[pm].dx);
    end;

    if pallo[pm].X >= DXDraw.Surface.Width-ImageList.Items[0].Width-OIKEA then
    begin
      // Testataan ollaanko pussin kohdalla y-suunnassa.
      // Jos on annetaan pallon liikkua yli laidan.
      if (pallo[pm].Y < YPUSSI1) or
         (pallo[pm].Y > DXDraw.Surface.Height-ImageList.Items[0].Height-YPUSSI2) then
      begin
      // Testataan onko pallo tuhottavissa
        TestDestroy(pm);
        exit;
      end;
      while (pallo[pm].X > DXDraw.Surface.Width-ImageList.Items[0].Width-OIKEA) do
      // Peruutetaan palloa kunnes se on pelialueen laitojen sisällä
      begin
        BackUp(pm);
      end;
      // Muutetaan pallon x-suunta vastakkaiseksi
       pallo[pm].dx := -(pallo[pm].dx);
    end;

    if pallo[pm].Y <= YLA then
    begin
      // Testataan ollaanko pussin kohdalla x-suunnassa.
      // Jos on annetaan pallon liikkua yli laidan.
      if (pallo[pm].X > XPUSSI) and   // Ylin keskireikä
         (pallo[pm].X < DXDraw.Surface.Width-ImageList.Items[0].Width-XPUSSI) then
      begin
      // Testataan onko pallo tuhottavissa
        TestDestroy(pm);
        exit;
      end;

      // Testataan ollaanko pussin kohdalla x-suunnassa.
      // Jos on annetaan pallon liikkua yli laidan.
      if (pallo[pm].X < YPUSSI2) or
         (pallo[pm].X > DXDraw.Surface.Width-ImageList.Items[0].Width-YPUSSI2) then
      begin
      // Testataan onko pallo tuhottavissa
        TestDestroy(pm);
        exit;
      end;
      while (pallo[pm].Y < YLA) do
      // Peruutetaan palloa kunnes se on pelialueen laitojen sisällä
      begin
        BackUp(pm);
      end;
      // Muutetaan pallon y-suunta vastakkaiseksi
       pallo[pm].dy := -(pallo[pm].dy);
    end;

    if pallo[pm].Y >= DXDraw.Surface.Height-ImageList.Items[0].Height-ALA then
    begin
      // Testataan ollaanko pussin kohdalla x-suunnassa.
      // Jos on annetaan pallon liikkua yli laidan.
      if (pallo[pm].X > XPUSSI) and   // Alin keskireikä
         (pallo[pm].X < DXDraw.Surface.Width-ImageList.Items[0].Width-XPUSSI) then
      begin
      // Testataan onko pallo tuhottavissa
        TestDestroy(pm);
        exit;
      end;

      // Testataan ollaanko pussin kohdalla x-suunnassa.
      // Jos on annetaan pallon liikkua yli laidan.
      if (pallo[pm].X < YPUSSI2) or
         (pallo[pm].X > DXDraw.Surface.Width-ImageList.Items[0].Width-YPUSSI2) then
      begin
      // Testataan onko pallo tuhottavissa
        TestDestroy(pm);
        exit;
      end;
      while (pallo[pm].Y > DXDraw.Surface.Height-ImageList.Items[0].Height-ALA) do
      // Peruutetaan palloa kunnes se on pelialueen laitojen sisällä
      begin
        BackUp(pm);
      end;
      // Muutetaan pallon y-suunta vastakkaiseksi
       pallo[pm].dy := -(pallo[pm].dy);
    end;
end;

procedure TMainForm.DXDrawMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

// Käydään kaikki pallot läpi ja tarkistetaan
// onko joku pallo liikkeessä. Jos on poistutaan
// proseduurista.

var
  cx:real;         // Muutos X-suunnassa
  cy:real;         // Muutos Y-suunnassa
  radius:real;     // Lyöntipallon ja hiirellä osoitetun
                   // kohteen välinen ero
  procent:real;    // Montako prosenttia speed on radius:sta
begin
  // Jos Lyöntipallo on ulkona pelialueelta Sijoitetaan lyöntipallo
  // Hiiren avulla uudelleen pelialueelle.
  if HitBallOut then
  begin
    pallo[0].SetX(X);
    pallo[0].SetY(Y);
    pallo[0].dx := 0;
    pallo[0].dy := 0;
    HitBallOut := False;
  end

  else
  begin
    // Lasketaan dx:n ja dy:n uudet arvot lyötivoima
    // (=Speed) huomioonottaen.
    cx := X-(pallo[0].X+(ImageList.Items[0].Width/2));
    cy := Y-(pallo[0].Y+(ImageList.Items[0].Height/2));
    radius := sqrt(cx*cx + cy*cy);
    procent := (100*Speed)/radius;
    pallo[0].dx := (procent/100)*cx;
    pallo[0].dy := (procent/100)*cy;
  end;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then Speed := Speed+1; // Lisää lyöntivoimaa yhdellä
  if Key=VK_SHIFT then Speed := Speed-1; // vähentää lyöntivoimaa yhdellä
  if Speed < 0 then speed := 0;
  if Speed > MaxSpeed then speed := MaxSpeed;
end;

procedure TMainForm.DrawSides;
begin
  Print(0,0,'Lyöntivoima Return+, Shift-. Tähtäys ja lyönti hiirellä. Lyöntivoima: '+IntToStr(Speed));

  with DXDraw.Surface.Canvas do
  begin
    Pen.Color := clYellow;
    // Ylin-viiva
    MoveTo(0,20);
    LineTo(780,20);
    // Pöydän ylä-osa
    MoveTo(60,50);
    LineTo(365,50);
    MoveTo(415,50);
    LineTo(720,50);
    // Pöydän ala-osa
    MoveTo(60,420);
    LineTo(365,420);
    MoveTo(415,420);
    LineTo(720,420);
    // Pöydän laidat
    MoveTo(30,80);
    LineTo(30,390);
    MoveTo(750,80);
    LineTo(750,390);

    // Pöydän reiät:
    // Vasen  ylä
    Arc(10,30,60,80,60,50,30,80);
    // Vasen  ala
    Arc(10,390,60,440,30,395,60,420);
    // Oikea ylä
    Arc(720,30,770,80,748,70,720,50);
    // Oikea ala
    Arc(720,390,770,440,720,420,748,395);
    // Keski ylä
    Arc(365,30,415,80,415,50,365,50);
    // Keski ala
    Arc(365,390,415,440,365,420,415,420);

    Release; {  Välttämätön  }
  end;
end;

procedure TMainForm.BackUp(parameter:integer);
// Peruutetaan palloa x- ja y-suunnassa 1/1000 osa takaisinpäin
begin
  pallo[parameter].X := pallo[parameter].X - (pallo[parameter].dx/1000);
  pallo[parameter].Y := pallo[parameter].Y - (pallo[parameter].dy/1000);
end;

procedure TmainForm.TestDestroy(parameter:integer);
var
  i:integer;
  // Testataan onko pallo tuhottavissa
begin
    if parameter = 0 then                   // Lyöntipalloa ei voi poistaa
    begin                                   // ( =tuhota ) pöydält pois.
      Print(0, 25, 'Sijoita lyöntipallo hiiren osoittimen kohtaan ja paina hiiren ykkösnappia!');
      pallo[0].dx := 0;
      pallo[0].dy := 0;
      HitBallOut := True;                   // Lyöntipallo on ulkona.
    end                                     // HitBallOut:a tarvitaan
                                            // DXDrawMouseUp-metodissa.
    else
    begin
      NumBallsDestroy := NumBallsDestroy + 1; // Lisätään yhdellä poistettujen
                                              // pallojen lukumäärää.
      NumBalls := NumBalls -1;                // Vähennetään yhdellä pöydällä
                                              // olevien pallojen lukumäärää.
      for i:=parameter to NumBalls do         // Kurotaan "parametrien väli" umpeen
      begin
        pallo[i]:=pallo[i+1];
      end;
      // Piirretään ylälaitaan pallo
      // joka on TDXDraw-piirtopinnan ulkopuolella.
      Shooted[NumBallsDestroy-1] := TShootBall.Create(self);
      Shooted[NumBallsDestroy-1].Parent := self;
      Shooted[NumBallsDestroy-1].LoadBitmap('redball.bmp');
      Shooted[NumBallsDestroy-1].SetX((NumBallsDestroy-1)*21);
      if NumBallsDestroy > 5 then
      begin
        Shooted[NumBallsDestroy-1].SetY(21);
        Shooted[NumBallsDestroy-1].SetX((NumBallsDestroy-6)*21);
      end;
      if NumBallsDestroy > 10 then
      begin
        Shooted[NumBallsDestroy-1].SetY(42);
        Shooted[NumBallsDestroy-1].SetX((NumBallsDestroy-11)*21);
      end;
      Shooted[NumBallsDestroy-1].Paint;
    end;
end;



procedure TMainForm.Print(x,y:integer; s:string);
begin
  with DXDraw.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clWhite;
    Font.Size := 12;
    Textout(x, y, s);
    Release;
  end;
end;

procedure TMainForm.Sound1Change(Sender: TObject);
begin
  Beep.PlaySound;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.Numberofballs1Click(Sender: TObject);
begin
//  FormNumberOfBalls.Show;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
  FormAbout.Show;
end;

procedure TMainForm.HowtoPlay1Click(Sender: TObject);
begin
  ButtonHelpOK.Visible := True;
  WebBrowser1.Width := 300;
  WebBrowser1.Height := 300;
  WebBrowser1.Navigate(WebBrowser1.Path+help); // Path = Polku, jossa
                                               // sovellus sijaitsee.
end;

procedure TMainForm.ButtonHelpOKClick(Sender: TObject);
begin
  ButtonHelpOK.Visible := False;
  WebBrowser1.Width := 0;
  WebBrowser1.Height := 0;
end;

procedure TMainForm.CreateBalls;
var
  i:integer;
begin
  HitBallOut := False;           // Lyöntipallo ei o0le ulkona
  NumBallsDestroy := 0;          // Nolla poistettua (=pussitettua) palloa
  NumBalls := InitialNumBalls;   // Siirretään vakion arvo "Tavalliseen"
                                 // globaaliin muuttujaan
  Speed := 0;                    // Lyöntivoima
  Friction := 0.005;             // Kitka
  DXTimer.Interval := TimerInterval;

    pallo[0] := TDXBall.Create(self);  // Lyöntipallo
    pallo[0].SetX(100);
    pallo[0].SetY(200);
    pallo[0].ballcolour := 1;          // Valkoinen väri
    pallo[1] := TDXBall.Create(self);
    pallo[1].SetX(548);
    pallo[1].SetY(200);
    pallo[2] := TDXBall.Create(self);
    pallo[2].SetX(567);
    pallo[2].SetY(212);
    pallo[3] := TDXBall.Create(self);
    pallo[3].SetX(567);
    pallo[3].SetY(188);
    pallo[4] := TDXBall.Create(self);
    pallo[4].SetX(586);
    pallo[4].SetY(200);
    pallo[5] := TDXBall.Create(self);
    pallo[5].SetX(586);
    pallo[5].SetY(222);
    pallo[6] := TDXBall.Create(self);
    pallo[6].SetX(586);
    pallo[6].SetY(178);

  for i:=0 to NumBalls do begin
    pallo[i].Imagelist := imagelist;   // viittaus DXBall:n imagelist:iin
  end;

end;

procedure TMainForm.NewGame1Click(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to NumBalls do begin
    pallo[i].Destroy;
  end;
  for i:=0 to NumBallsDestroy-1 do begin
    Shooted[i].Destroy;
  end;
  CreateBalls;
end;

procedure TMainForm.ButtonSlowSpeedClick(Sender: TObject);
begin
  Speed := Speed-1; // vähentää lyöntivoimaa yhdellä
  if Speed < 0 then speed := 0;
  if Speed > MaxSpeed then speed := MaxSpeed;
end;

procedure TMainForm.ButtonFastSpeedClick(Sender: TObject);
begin
  Speed := Speed+1; // lisää lyöntivoimaa yhdellä
  if Speed < 0 then speed := 0;
  if Speed > MaxSpeed then speed := MaxSpeed;
end;

end.

