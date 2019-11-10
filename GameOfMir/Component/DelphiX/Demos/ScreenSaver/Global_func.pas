unit Global_func;

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
  TSSMode = (ssSetPwd, ssPreview, ssConfig, ssRun);

const
  TestMode    : Boolean = False;
  IgnoreCount : Integer = 0;

procedure ReadIniFile;
procedure WriteIniFile;
procedure LoadJpegFromRes(ResJPEGname: string; Jpeg: TJpegImage);
function GetSysDir: string;
function TestSaverMode: TSSMode;
procedure RegisterSaver(Form_handle: HWND; activate: boolean);
procedure PreviewBitmap(bmp: TBitmap; sem_handle: THandle);
procedure CheckPassword;
procedure ChangePassword;
procedure DoRed(src: tbitmap);
procedure DoGreen(src: tbitmap);
procedure DoBlue(src: tbitmap);
procedure SetCol(src: tbitmap; layer: integer; dest: TDXImageList);
procedure SetPicAndDraw(src: tdximagelist; layer: integer; dest: TDirectDrawSurface);

var Resolution: string;
    Lights: Integer;
    Random_num, Draw_back: boolean;
    Param1, Param2: string;

implementation

uses
  IniFiles, Registry, SSaver_main, SSaver_config;

procedure ReadIniFile;
var ini: TIniFile;
begin
ini := TIniFile.Create(extractfilepath(application.exename)+'\DLights.ini');
resolution := ini.ReadString('Dancing Lights Config', 'Resolution', '800x600');
random_num := ini.ReadBool('Dancing Lights Config', 'Random lights', True);
Lights := ini.ReadInteger('Dancing Lights Config', 'Lights number', 5);
draw_back := ini.ReadBool('Dancing Lights Config', 'Draw background', True);
ini.Free;
end;

procedure WriteIniFile;
var ini: TIniFile;
begin
ini := TIniFile.Create(extractfilepath(application.exename)+'\DLights.ini');
ini.WriteString('Dancing Lights Config', 'Resolution', resolution);
ini.WriteBool('Dancing Lights Config', 'Random lights', random_num);
ini.WriteInteger('Dancing Lights Config', 'Lights number', lights);
ini.WriteBool('Dancing Lights Config', 'Draw background', draw_back);
ini.Free;
end;

procedure LoadJpegFromRes(ResJPEGname: string; Jpeg: TJpegImage);
var
  ResHandle : THandle;
  MemHandle : THandle;
  MemStream : TMemoryStream;
  ResPtr    : PByte;
  ResSize   : Longint;
begin
  ResHandle := FindResource(hInstance, PChar(ResJPEGname), 'JPEG');
  MemHandle := LoadResource(hInstance, ResHandle);
  ResPtr    := LockResource(MemHandle);
  MemStream := TMemoryStream.Create;
  ResSize := SizeOfResource(hInstance, ResHandle);
  MemStream.SetSize(ResSize);
  MemStream.Write(ResPtr^, ResSize);
  FreeResource(MemHandle);
  MemStream.Seek(0, 0);
  Jpeg.LoadFromStream(MemStream);
  MemStream.Free;
end;

function GetSysDir: string;
var SysDir    : String;
    NewLength : Integer;
begin
  SetLength(SysDir,MAX_PATH);
  NewLength := GetSystemDirectory(PChar(SysDir),MAX_PATH);
  SetLength(SysDir,NewLength);
  Result := SysDir+'\';
end;

function TestSaverMode: TSSMode;
begin
  Param1 := UpperCase(ParamStr(1));
  Param2 := UpperCase(ParamStr(2));
  Result := ssRun;

  if (Copy(Param1,1,2) = '/A') or (Copy(Param1,1,2) = '-A') or
     (Copy(Param1,1,1) = 'A') then
    Result := ssSetPwd;

  if (Copy(Param1,1,2) = '/P') or (Copy(Param1,1,2) = '-P') or
     (Copy(Param1,1,1) = 'P') then
    Result := ssPreview;

  if (Copy(Param1,1,2) = '/C') or (Copy(Param1,1,2) = '-C') or
     (Copy(Param1,1,1) = 'C') or (Param1 = '') then
    Result := ssConfig;
end;

procedure RegisterSaver(Form_handle: HWND; activate: boolean);
var Dummy: Boolean;
begin
if activate then
  begin
    SetWindowPos(Form_Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE + SWP_NOMOVE);
//    SystemParametersInfo(SPI_SCREENSAVERRUNNING,1,@Dummy,0);
    SetCapture(Form_Handle);
  end
  else
  begin
//    SystemParametersInfo(SPI_SCREENSAVERRUNNING,0,@Dummy,0);
    ReleaseCapture;
  end;
  ShowCursor(not activate);
end;

procedure PreviewBitmap(bmp: TBitmap; sem_handle: THandle);
var
  PrevWnd     : HWnd;
  PrevRect    : TRect;
  PrevCanvas  : TCanvas;
  ScrWidth,
  ScrHeight   : Integer;
begin
    PrevWnd := StrToInt(Param2);
    while not IsWindowVisible(PrevWnd) do
      Application.ProcessMessages;
    GetWindowRect(PrevWnd,PrevRect);
    ScrWidth := PrevRect.Right-PrevRect.Left+1;
    ScrHeight := PrevRect.Bottom-PrevRect.Top+1;
    Bmp.Height := ScrHeight;
    Bmp.Width := ScrWidth;
    PrevRect := Rect(0,0,ScrWidth-1,ScrHeight-1);
    PrevCanvas := TCanvas.Create;
    PrevCanvas.Handle := GetDC(PrevWnd);
    while IsWindowVisible(PrevWnd) do
      begin
      PrevCanvas.CopyRect(PrevRect,Bmp.Canvas,PrevRect);
      Sleep(10);
      Application.ProcessMessages;
      end;
    PrevCanvas.Free;
    CloseHandle(Sem_Handle);
    Halt;
end;

procedure CheckPassword;
var
  DLL       : THandle;
  PwdFunc   : function (Parent: THandle): Boolean; stdcall;
  Reg     : TRegistry;
  CanClose : Boolean;
begin
  if (TestSaverMode <> ssRun) or TestMode then
    begin
    MainForm.Close;
    Exit;
    end;

  IgnoreCount := 5;
  CanClose := False;
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('Control Panel\Desktop',False) then
    begin
    try
      try
        ShowCursor(True);
        if Reg.ReadInteger('ScreenSaveUsePassword') <> 0 then
          begin
          DLL := LoadLibrary(PChar(GetSysDir+'PASSWORD.CPL'));
          if DLL <> 0 then
            begin
            PwdFunc := GetProcAddress(DLL,'VerifyScreenSavePwd');
            if PwdFunc(Application.Handle) then
            CanClose := True;
            FreeLibrary(DLL);
            end
          else CanClose := True;
          end
        else CanClose := True;
      finally
        ShowCursor(False);
      end;
    except
      CanClose := True;
    end;
  end
  else
    CanClose := True;

  Reg.Free;

  if CanClose then MainForm.Close;
end;

procedure ChangePassword;
var
  DLL         : THandle;
  PwdFunc     : function (a: PChar; ParentHandle: THandle; b, c :Integer):
                  Integer; stdcall;
begin
    DLL := LoadLibrary(PChar(GetSysDir+'MPR.DLL'));
    if DLL <> 0 then begin
      PwdFunc := GetProcAddress(DLL, 'PwdChangePasswordA');
      if Assigned(PwdFunc) then
        PwdFunc('SCRSAVE',StrToInt(Param2),0,0);
      FreeLibrary(DLL);
    end;
    Halt;
end;

procedure DoRed(src: tbitmap);
var
  c, x, y: integer;
  pix: pbytearray;
begin
  for y := 0 to src.height - 1 do
    begin
    pix := src.scanline[y];
    for x := 0 to src.width - 1 do
      begin
      c := x * 3;
      if (pix[c + 2] > 40) and (pix[c + 2] < 30) then
      pix[c + 2] := $FF
      else
      pix[c + 2] := 0;
      end;
    end;
end;

procedure DoGreen(src: tbitmap);
var
  c, x, y: integer;
  pix: pbytearray;
begin
  for y := 0 to src.height - 1 do
    begin
    pix := src.scanline[y];
    for x := 0 to src.width - 1 do
      begin
      c := x * 3;
      if (pix[c + 1] > 40) and (pix[c + 1] < 30) then
      pix[c + 1] := $FF
      else
      pix[c + 1] := 0;
      end;
    end;
end;

procedure DoBlue(src: tbitmap);
var
  c, x, y: integer;
  pix: pbytearray;
begin
  for y := 0 to src.height - 1 do
    begin
    pix := src.scanline[y];
    for x := 0 to src.width - 1 do
      begin
      c := x * 3;
      if (pix[c] > 40) and (pix[c] < 30) then
      pix[c] := $FF
      else
      pix[c] := 0;
      end;
    end;
end;

procedure SetCol(src: tbitmap; layer: integer; dest: TDXImageList);
begin
  case random(7) of
    0: DoRed(src);
    1: DoGreen(src);
    2: DoBlue(src);
    3: begin
       DoRed(src);
       DoGreen(src);
       end;
    4: begin
       DoRed(src);
       DoBlue(src);
       end;
    5: begin
       DoGreen(src);
       DoBlue(src);
       end;
  end;
Dest.Items[layer].Picture.Bitmap.Assign(src);
Dest.Items[layer].Restore;
end;

procedure SetPicAndDraw(src: tdximagelist; layer: integer; dest: TDirectDrawSurface);
var
  Temp, XSize, YSize, Alpha, XPos, YPos: real;
begin
  Temp := (TotalTime / 96 + layer * 2) / 4;
  XSize := 100 + 50 * cos(Temp / 4);
  YSize := 100 + 50 * cos(Temp / 2);
  Alpha := 170.0 + 40.0 * sin((Temp - layer * 4) / 5);
  XPos := (int(MainForm.DXDraw.SurfaceWidth div 2) - 60) + (70 * cos(Temp / 8 + layer));
  YPos := (int(MainForm.DXDraw.SurfaceHeight div 2) - 60) + (70 * cos(Temp / 6 + layer));

  Src.Items[layer].DrawAdd(dest, bounds(round(xpos), round(ypos), round(xsize),
    round(ysize)), 0, round(alpha));
end;

end.
