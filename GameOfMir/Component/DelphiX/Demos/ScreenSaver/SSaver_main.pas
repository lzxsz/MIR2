unit SSaver_main;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  DXDraws,
  DXClass,
  Jpeg;

type
  TMainForm = class(TForm)
    DXDraw: TDXDraw;
    DXTimer: TDXTimer;
    DXImageList: TDXImageList;
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    StartTime, LastTime: DWord;
    Bmp: TBitmap;
    Jpg: TJpegImage;
    Loading: Boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  TotalTime: integer;

implementation

uses Global_func, SSaver_config;

{$R *.DFM}

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
var
  I: integer;
begin
  if not DXDraw.CanDraw then Exit;
  if not MainForm.Focused then MainForm.SetFocus;
  DXDraw.Surface.Fill(0);

  if draw_back then
  DXImageList.Items.Find('back').StretchDraw(DXDraw.Surface,
    bounds(0, 0, dxdraw.surfacewidth, dxdraw.surfaceheight), 0);

  LastTime := TotalTime;
  TotalTime := GetTickCount - StartTime;
  TotalTime := (LastTime + TotalTime) div 2;

  for I := 1 to lights do
    begin
      SetPicAndDraw(dximagelist, I, DXDraw.Surface);
    end;

  DXDraw.Flip;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: integer;
begin
  Loading := True;

  bmp := TBitmap.Create;
  jpg := TJpegImage.Create;

  Randomize;
  if not TestMode then ReadIniFile;
  if random_num then lights := random(9)+1;
  Resolution := Resolution + 'x16';

  with DXDraw.Display do
    begin
    I := Pos('x', Resolution);
    Width := StrToInt(Copy(resolution, 1, I - 1));
    Resolution := Copy(Resolution, I + 1, Length(Resolution));
    I := Pos('x', Resolution);
    Height := StrToInt(Copy(Resolution, 1, I - 1));
    Resolution := Copy(Resolution, I + 1, Length(Resolution));
    BitCount := Strtoint(Resolution);
    end;
  DXDraw.Initialize;

  StartTime := GetTickCount;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RegisterSaver(MainForm.Handle, False);
end;

procedure TMainForm.FormShow(Sender: TObject);
var I: integer;
begin
if Loading then
  begin
    LoadJpegFromRes('texture', jpg);
    for I := 1 to Lights do
    begin
    bmp.Assign(jpg);
    SetCol(bmp, I, DXImageList);
    Loading := False;
    end;
    RegisterSaver(MainForm.Handle, True);
  end;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CheckPassword;
end;

procedure TMainForm.DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  CheckPassword;
end;

procedure TMainForm.DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if IgnoreCount > 0 then begin
    Dec(IgnoreCount);
    Exit;
  end;

  CheckPassword;

end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  bmp.free;
  jpg.Free;
end;

procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
  DXTimer.Enabled := False;
end;

procedure TMainForm.DXDrawInitialize(Sender: TObject);
begin
  DXTimer.Enabled := True;
end;

end.


