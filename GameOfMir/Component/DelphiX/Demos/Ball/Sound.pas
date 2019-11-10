// Panu Niva
// 3.12.2000
// Luokka, jossa on tapahtuma
// Äänen tuottaminen kun esim
// kaksi palloa törmää yhteen.

unit Sound;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MPlayer;

type
  TSound = class(TMediaPlayer)
  private
  protected
    FOnChange:TNotifyEvent;
    FPlayMode:Boolean;        // Soitetaanko vavvi vai ei
  public
    Constructor Create(AOwner:TComponent);      override;
    Destructor Destroy;                         override;
    procedure SetPlayMode(const Value:Boolean); virtual;
    procedure LoadSound(s:string);              virtual;
    procedure PlaySound;                        virtual;
  published
    property PlayMode:Boolean read FPlayMode write SetPlayMode;
    property OnChange:TNotifyEvent read FOnChange write FOnChange;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Pool', [TSound]);
end;

Constructor TSound.Create(AOwner:TComponent);
begin
  inherited;
  Visible := False;
end;

Destructor TSound.destroy;
begin
  inherited;
end;

procedure TSound.LoadSound(s:string);
begin
  Filename := s;
  Open;
end;

procedure TSound.PlaySound;
begin
  Play;
end;

procedure TSound.SetPlayMode(const Value:Boolean);
// Kun käsitellään tapahtumaa SetPlayMode kutsutaan metodia
// johon OnChange-metodiosoitin osoittaa ( =OnChange(Self) )
// Eli biljardi- ohjelmassa jos muutetaan SetPlayMode-metodia
// kutsutaan TMainForm-ohjelman VoiceChange-metodissa TSound-
// Luokan PlaySound-metodia, eli ei sinänsä väliä onko
// PlayMode True vai False koska ääni soitetaan joka kerran
// kun SetPlayMode-metodia kutsutaan.
// Boolean arvoa voi hyödyntää muulla tavalla, mutta sitä ei
// hyödynnetä ko. biljardi- ohjelmassa.
// Ts. konstailua.
begin
  FPlayMode := Value;
  if Assigned(OnChange) then OnChange(self);
end;

end.
