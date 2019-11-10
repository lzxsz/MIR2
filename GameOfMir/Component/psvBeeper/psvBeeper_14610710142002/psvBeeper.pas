{*******************************************************}
{                                                       }
{          psvBeeper Delphi components Library          }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{                                                       }
{     Use, modification and distribution is allowed     }
{without limitation, warranty, or liability of any kind.}
{                                                       }
{*******************************************************}

{$WARNINGS OFF}

unit psvBeeper;


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,  MMSystem,  IniFiles, RegStr,  Registry;

const
{ SoundTypes }
  MB_OK = 0;
  MB_ICONHAND = 16;
  MB_ICONQUESTION = 32;
  MB_ICONEXCLAMATION = 48;
  MB_ICONASTERISK = 64;

Type TSoundType =
  (
    OK,
    ICONHAND,
    ICONQUESTION,
    ICONEXCLAMATION,
    ICONASTERISK
    );

type
  TpsvBeeper = class(TComponent)
  private
    FSound : TSoundType;
  protected
    function  Get_SoundBeep(SoundType: TSoundType): TSoundType;
    procedure Set_Sound(Value: TSoundType);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Beep;
  published
    property Sound : TSoundType read FSound Write Set_Sound;
  end;


  TpsvWavSound = class(TComponent)
  private
    { Private declarations }
    FSoundFile: PString;
    FSoundLoop: Boolean;
    FActive   : Boolean;
    FBeforePlay : TNotifyEvent;
    FAfterPlay  : TNotifyEvent;
  protected
    { Protected declarations }
    procedure PlaySound(const FileName: String; uFlags: word);
    function  GetSoundFile: String;
    procedure SetSoundFile(const V: String);
    Procedure SetActive(Const V : boolean);
  public
    { Public declarations }
    procedure GetSoundFromRegistry(AppName,EventName : string);
  published
    { Published declarations }
    property SoundFile: String  read GetSoundFile write SetSoundFile;
    property SoundLoop: Boolean read FSoundLoop   write FSoundLoop default TRUE;
    Property Active   : Boolean read FActive      write SetActive  default FALSE;
    Property BeforePlay : TNotifyEvent read FBeforePlay write FBeforePlay;
    Property AfterPlay  : TNotifyEvent read FAfterPlay  write FAfterPlay;
  end;

  TpsvMidiSound = class(TComponent)
  private
    { Private declarations }
    DeviceId:integer;
    Fname:string;
  public
    { Public declarations }
    function Open:integer;
    function Play:integer;
    function Close:integer;
    procedure Execute;
  published
    { Published declarations }
    property MidiFile: string read fname write fname;
  end;


procedure Register;

implementation


constructor TpsvBeeper.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSound := OK;
end;


function TpsvBeeper.Get_SoundBeep(SoundType: TSoundType): TSoundType;
begin
  Set_Sound(SoundType);
  Beep;
  Result := FSound;
end;

procedure TpsvBeeper.Beep;
var ISound : integer;
begin
  ISound := MB_OK;
  case FSound of
    OK :                   ISound := MB_OK        ;
    ICONHAND :             ISound := MB_ICONHAND  ;
    ICONQUESTION :         ISound := MB_ICONQUESTION;
    ICONEXCLAMATION :      ISound := MB_ICONEXCLAMATION;
    ICONASTERISK :         ISound := MB_ICONASTERISK;
  end;
   MessageBeep(ISound);
end;

procedure TpsvBeeper.Set_Sound(Value: TSoundType);
begin
  if FSound <> Value then FSound := Value;
end;


procedure TpsvWavSound.PlaySound(const FileName: String; uFlags: word);

var
  SName: array[0..128] of char;

begin
  if Assigned(fBeforePlay) then
   fBeforePlay(Self);
  if (length(FileName) > 0)
    then begin
           StrPCopy(SName,FileName);
           sndPlaySound(SName,uFlags);
         end
    else sndPlaySound(NIL,0);
end;

Procedure TpsvWavSound.SetActive(Const V : boolean);
Var Param : Word;
begin
  if (FSoundFile = NIL) then
    begin
      FActive := False;
      Exit;
    end;

  if V then
    begin
      FActive := True;
      Param := snd_Async+snd_NoDefault;
      if (FSoundLoop)
        then Param := Param + snd_Loop;
       PlaySound(Soundfile,Param);
      if ( not FSoundLoop) then
        begin
          FActive := False;
         if Assigned(fAfterPlay) then
            fAfterPlay(Self);
         end;
    end
      else
        begin
          if ( ( not FSoundLoop) or ( not FActive) ) then
            Exit;
          FActive := False;
          PlaySound('',0);
         if Assigned(fAfterPlay) then
            fAfterPlay(Self);
        end;
end;

procedure TpsvWavSound.GetSoundFromRegistry(AppName,EventName : string);
Var R : TRegistry;
    V : String;
begin
  R := TRegistry.Create;
  V := REGSTR_PATH_APPS+'\'+AppName+'\'+EventName+'\.current';
  R.OpenKey(V,False);
  V := R.ReadString('');
  R.Destroy;
  AssignStr(FSoundFile,V);
  PlaySound('',0);
end;

function TpsvWavSound.GetSoundFile: String;

begin
  if (FSoundFile <> NIL)
    then Result := FSoundFile^
    else Result := '';
end;

procedure TpsvWavSound.SetSoundFile(const V: String);

var
  Param: word;

begin
  AssignStr(FSoundFile,V);
  PlaySound('',0);
  if (length(SoundFile) > 0) and (csDesigning in ComponentState)
    then
      begin
         Param := snd_Async+snd_NoDefault;
         PlaySound(Soundfile,Param);
      end;
end;




function TpsvMidiSound.Open:integer;
Var
 open_s : TMCI_OPEN_PARMS;
 set_s  : TMCI_SEQ_SET_PARMS;
 a      :  array[0..512] of char;
begin
 with open_s do
   begin
     lpstrDeviceType:=LPCSTR(MCI_DEVTYPE_SEQUENCER);
     lpstrElementName:=StrPCopy(a,fname);
   end;
   with set_s do
     begin
       dwTimeFormat:=MCI_FORMAT_MILLISECONDS;
     end;
   result:=mciSendCommand(0,MCI_OPEN,
                       MCI_OPEN_TYPE or MCI_OPEN_TYPE_ID or MCI_OPEN_ELEMENT,
                       DWORD(@open_s));
   DeviceId:=open_s.wDeviceId;
   if result<>0 then exit;
   result:=mciSendCommand(DeviceId,MCI_SET,
                       MCI_SET_TIME_FORMAT,
                       DWORD(@set_s));

   if result<>0 then self.close;
end;

function TpsvMidiSound.Play:integer;
Var
 play_s:TMCI_PLAY_PARMS;
begin
 with play_s do
   begin
    dwFrom:=0;
    dwTo  :=0;
   end;
 result:=mciSendCommand( DeviceID,MCI_PLAY,0,
                        DWORD(@play_s));
end;

function TpsvMidiSound.Close:integer;
Var
 close_s:TMCI_GENERIC_PARMS;
begin
 result:=mciSendCommand(DeviceId,MCI_CLOSE,
                       0,
                       DWORD(@close_s));
end;


procedure TpsvMidiSound.Execute;
begin
  open;
  play;
end;

procedure Register;
begin
  RegisterComponents('Sound', [TpsvBeeper]);
  RegisterComponents('Sound', [TpsvWavSound]);
  RegisterComponents('Sound', [TpsvMidiSound]);
end;

end.
