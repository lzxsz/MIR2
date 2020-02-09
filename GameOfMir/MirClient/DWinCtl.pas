unit DWinCtl;
//Ã·π©º∏∏ˆ‘⁄DXœ¬ π”√µƒøÿº˛

interface

uses
  Windows, Classes, Graphics, SysUtils, Controls, DXDraws, DXClass,
  Forms, DirectX, DIB, Grids, wmUtil, HUtil32, Wil, cliUtil;


type
   TClickSound = (csNone, csStone, csGlass, csNorm);
   TDControl = class;
   TOnDirectPaint = procedure(Sender: TObject; dsurface: TDirectDrawSurface) of object;
   TOnKeyPress = procedure(Sender: TObject; var Key: Char) of object;
   TOnKeyDown = procedure(Sender: TObject; var Key: word; Shift: TShiftState) of object;
   TOnMouseMove = procedure(Sender: TObject; Shift: TShiftState; X, Y: integer) of object;
   TOnMouseDown = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer) of object;
   TOnMouseUp = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
   TOnClick = procedure(Sender: TObject) of object;
   TOnClickEx = procedure(Sender: TObject; X, Y: integer) of object;
   TOnInRealArea = procedure(Sender: TObject; X, Y: integer; var IsRealArea: Boolean) of object;
   TOnGridSelect = procedure(Sender: TObject; ACol, ARow: integer; Shift: TShiftState) of object;
   TOnGridPaint = procedure(Sender: TObject; ACol, ARow: integer; Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface) of object;
   TOnClickSound = procedure(Sender: TObject; Clicksound: TClickSound) of object;

   TDControl = class (TCustomControl)
   private
      FCaption: string;      //0x1F0
      FDParent: TDControl;   //0x1F4
      FEnableFocus: Boolean; //0x1F8
      FOnDirectPaint: TOnDirectPaint; //0x1FC
      FOnKeyPress: TOnKeyPress; //0x200
      FOnKeyDown: TOnKeyDown;   //0x204
      FOnMouseMove: TOnMouseMove; //0x208
      FOnMouseDown: TOnMouseDown; //0x20C
      FOnMouseUp: TOnMouseUp;     //0x210
      FOnDblClick: TNotifyEvent;  //0x214
      FOnClick: TOnClickEx;       //0x218
      FOnInRealArea: TOnInRealArea; //0x21C
      FOnBackgroundClick: TOnClick; //0x220
      procedure SetCaption (str: string);
   protected
      FVisible: Boolean;
   public
      Background: Boolean; //0x24D
      DControls: TList;    //0x250
      //FaceSurface: TDirectDrawSurface;
      WLib: TWMImages;     //0x254
      FaceIndex: integer;  //0x258
      WantReturn: Boolean; //Background¿œ∂ß, Click¿« ªÁøÎ ø©∫Œ..

      constructor Create (AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Paint; override;
      procedure Loaded; override;
      function  SurfaceX (x: integer): integer;
      function  SurfaceY (y: integer): integer;
      function  LocalX (x: integer): integer;
      function  LocalY (y: integer): integer;
      procedure AddChild (dcon: TDControl);
      procedure ChangeChildOrder (dcon: TDControl);
      function  InRange (x, y: integer): Boolean;
      function  KeyPress (var Key: Char): Boolean; dynamic;
      function  KeyDown (var Key: Word; Shift: TShiftState): Boolean; dynamic;
      function  MouseMove (Shift: TShiftState; X, Y: Integer): Boolean; dynamic;
      function  MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; dynamic;
      function  MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; dynamic;
      function  DblClick (X, Y: integer): Boolean; dynamic;
      function  Click (X, Y: integer): Boolean; dynamic;

      function  CanFocusMsg: Boolean;

      procedure SetImgIndex (Lib: TWMImages; index: integer);
      procedure DirectPaint (dsurface: TDirectDrawSurface); dynamic;

   published
      property OnDirectPaint: TOnDirectPaint read FOnDirectPaint write FOnDirectPaint;
      property OnKeyPress: TOnKeyPress read FOnKeyPress write FOnKeyPress;
      property OnKeyDown: TOnKeyDown read FOnKeyDown write FOnKeyDown;
      property OnMouseMove: TOnMouseMove read FOnMouseMove write FOnMouseMove;
      property OnMouseDown: TOnMouseDown read FOnMouseDown write FOnMouseDown;
      property OnMouseUp: TOnMouseUp read FOnMouseUp write FOnMouseUp;
      property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
      property OnClick: TOnClickEx read FOnClick write FOnClick;
      property OnInRealArea: TOnInRealArea read FOnInRealArea write FOnInRealArea;
      property OnBackgroundClick: TOnClick read FOnBackgroundClick write FOnBackgroundClick;
      property Caption: string read FCaption write SetCaption;
      property DParent: TDControl read FDParent write FDParent;
      property Visible: Boolean read FVisible write FVisible;
      property EnableFocus: Boolean read FEnableFocus write FEnableFocus;
      property Color;
      property Font;
      property Hint;
      property ShowHint;
      property Align;
   end;

   TDButton = class (TDControl)
   private
      FClickSound: TClickSound;
      FOnClick: TOnClickEx;
      FOnClickSound: TOnClickSound;
   public
      Downed: Boolean;
      constructor Create (AOwner: TComponent); override;
      function  MouseMove (Shift: TShiftState; X, Y: Integer): Boolean; override;
      function  MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
      function  MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
   published
      property ClickCount: TClickSound read FClickSound write FClickSound;
      property OnClick: TOnClickEx read FOnClick write FOnClick;
      property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
   end;

   TDGrid = class (TDControl)
   private
      FColCount, FRowCount: integer;
      FColWidth, FRowHeight: integer;
      FViewTopLine: integer;
      SelectCell: TPoint;
      DownPos: TPoint;
      FOnGridSelect: TOnGridSelect;
      FOnGridMouseMove: TOnGridSelect;
      FOnGridPaint: TOnGridPaint;
      function  GetColRow (x, y: integer; var acol, arow: integer): Boolean;
   public
      CX, CY: integer;
      Col, Row: integer;
      constructor Create (AOwner: TComponent); override;
      function  MouseMove (Shift: TShiftState; X, Y: Integer): Boolean; override;
      function  MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
      function  MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
      function  Click (X, Y: integer): Boolean; override;
      procedure DirectPaint (dsurface: TDirectDrawSurface); override;
   published
      property ColCount: integer read FColCount write FColCount;
      property RowCount: integer read FRowCount write FRowCount;
      property ColWidth: integer read FColWidth write FColWidth;
      property RowHeight: integer read FRowHeight write FRowHeight;
      property ViewTopLine: integer read FViewTopLine write FViewTopLine;
      property OnGridSelect: TOnGridSelect read FOnGridSelect write FOnGridSelect;
      property OnGridMouseMove: TOnGridSelect read FOnGridMouseMove write FOnGridMouseMove;
      property OnGridPaint: TOnGridPaint read FOnGridPaint write FOnGridPaint;
   end;

   TDWindow = class (TDButton)
   private
      FFloating: Boolean;
      SpotX, SpotY: integer;
   protected
      procedure SetVisible (flag: Boolean);
   public
      DialogResult: TModalResult;
      constructor Create (AOwner: TComponent); override;
      function  MouseMove (Shift: TShiftState; X, Y: Integer): Boolean; override;
      function  MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
      function  MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
      procedure Show;
      function  ShowModal: integer;
   published
      property Visible: Boolean read FVisible write SetVisible;
      property Floating: Boolean read FFloating write FFloating;
   end;


   TDWinManager = class (TComponent)
   private
   public
      DWinList: TList; //list of TDControl;
      constructor Create (AOwner: TComponent); override;
      destructor Destroy; override;
      procedure AddDControl (dcon: TDControl; visible: Boolean);
      procedure DelDControl (dcon: TDControl);
      procedure ClearAll;

      function  KeyPress (var Key: Char): Boolean;
      function  KeyDown (var Key: Word; Shift: TShiftState): Boolean;
      function  MouseMove (Shift: TShiftState; X, Y: Integer): Boolean;
      function  MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
      function  MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
      function  DblClick (X, Y: integer): Boolean;
      function  Click (X, Y: integer): Boolean;
      procedure DirectPaint (dsurface: TDirectDrawSurface);
   end;

procedure Register;
procedure SetDFocus (dcon: TDControl);
procedure ReleaseDFocus;
procedure SetDCapture (dcon: TDControl);
procedure ReleaseDCapture;

var
   MouseCaptureControl: TDControl; //mouse message
   FocusedControl: TDControl; //Key message
   MainWinHandle: integer;
   ModalDWindow: TDControl;


implementation

uses
  Share;


procedure Register;
begin
   RegisterComponents('MirGame', [TDWinManager, TDControl, TDButton, TDGrid, TDWindow]);
end;


procedure SetDFocus (dcon: TDControl);
begin
   FocusedControl := dcon;
end;

procedure ReleaseDFocus;
begin
   FocusedControl := nil;
end;

procedure SetDCapture (dcon: TDControl);
begin
   SetCapture (MainWinHandle);
   MouseCaptureControl := dcon;
end;

procedure ReleaseDCapture;
begin
   ReleaseCapture;
   MouseCaptureControl := nil;
end;

{----------------------------- TDControl -------------------------------}

constructor TDControl.Create (AOwner: TComponent);
begin
   inherited Create (AOwner);
   DParent := nil;
   inherited Visible := FALSE;
   FEnableFocus := FALSE;
   Background := FALSE;

   FOnDirectPaint := nil;
   FOnKeyPress := nil;
   FOnKeyDown := nil;
   FOnMouseMove := nil;
   FOnMouseDown := nil;
   FOnMouseUp := nil;
   FOnInRealArea := nil;
   DControls := TList.Create;
   FDParent := nil;

   Width := 80;
   Height:= 24;
   FCaption := '';
   FVisible := TRUE;
   //FaceSurface := nil;
   WLib := nil;
   FaceIndex := 0;
end;

destructor TDControl.Destroy;
begin
   DControls.Free;
   inherited Destroy;
end;

procedure TDControl.SetCaption (str: string);
begin
   FCaption := str;
   if csDesigning in ComponentState then begin
      Refresh;
   end;
end;

procedure TDControl.Paint;
begin
   if csDesigning in ComponentState then begin
      if self is TDWindow then begin
         with Canvas do begin
            Pen.Color := clBlack;
            MoveTo (0, 0);
            LineTo (Width-1, 0);
            LineTo (Width-1, Height-1);
            LineTo (0, Height-1);
            LineTo (0, 0);
            LineTo (Width-1, Height-1);
            MoveTo (Width-1, 0);
            LineTo (0, Height-1);
            TextOut ((Width-TextWidth(Caption)) div 2, (Height-TextHeight(Caption)) div 2, Caption);
         end;
      end else begin
         with Canvas do begin
            Pen.Color := clBlack;
            MoveTo (0, 0);
            LineTo (Width-1, 0);
            LineTo (Width-1, Height-1);
            LineTo (0, Height-1);
            LineTo (0, 0);
            TextOut ((Width-TextWidth(Caption)) div 2, (Height-TextHeight(Caption)) div 2, Caption);
         end;
      end;
   end;
end;

procedure TDControl.Loaded;
var
   i: integer;
   dcon: TDControl;
begin
   if not (csDesigning in ComponentState) then begin
      if Parent <> nil then
         for i:=0 to TControl(Parent).ComponentCount-1 do begin
            if TControl(Parent).Components[i] is TDControl then begin
               dcon := TDControl(TControl(Parent).Components[i]);
               if dcon.DParent = self then begin
                  AddChild (dcon);
               end;
            end;
         end;
   end;
end;

//¡ˆø™ ¡¬«•∏¶ ¿¸√º ¡¬«•∑Œ πŸ≤ﬁ
function  TDControl.SurfaceX (x: integer): integer;
var
   d: TDControl;
begin
   d := self;
   while TRUE do begin
      if d.DParent = nil then break;
      x := x + d.DParent.Left;
      d := d.DParent;
   end;
   Result := x;
end;

function  TDControl.SurfaceY (y: integer): integer;
var
   d: TDControl;
begin
   d := self;
   while TRUE do begin
      if d.DParent = nil then break;
      y := y + d.DParent.Top;
      d := d.DParent;
   end;
   Result := y;
end;

//¿¸√º¡¬«•∏¶ ∞¥√º¿« ¡¬«•∑Œ πŸ≤ﬁ
function  TDControl.LocalX (x: integer): integer;
var
   d: TDControl;
begin
   d := self;
   while TRUE do begin
      if d.DParent = nil then break;
      x := x - d.DParent.Left;
      d := d.DParent;
   end;
   Result := x;
end;

function  TDControl.LocalY (y: integer): integer;
var
   d: TDControl;
begin
   d := self;
   while TRUE do begin
      if d.DParent = nil then break;
      y := y - d.DParent.Top;
      d := d.DParent;
   end;
   Result := y;
end;

procedure TDControl.AddChild (dcon: TDControl);
begin
   DControls.Add (Pointer (dcon));
end;

procedure TDControl.ChangeChildOrder (dcon: TDControl);
var
   i: integer;
begin
   if not (dcon is TDWindow) then exit;
   if TDWindow(dcon).Floating then begin
      for i:=0 to DControls.Count-1 do begin
         if dcon = DControls[i] then begin
            DControls.Delete (i);
            break;
         end;
      end;
      DControls.Add (dcon);
   end;
end;

function  TDControl.InRange (x, y: integer): Boolean;
var
   inrange: Boolean;
   d: TDirectDrawSurface;
begin
   if (x >= Left) and (x < Left+Width) and (y >= Top) and (y < Top+Height) then begin
      inrange := TRUE;
      if Assigned (FOnInRealArea) then
         FOnInRealArea(self, x-Left, y-Top, inrange)
      else
         if WLib <> nil then begin
            d := WLib.Images[FaceIndex];
            if d <> nil then
               if d.Pixels[x-Left, y-Top] <= 0 then
                  inrange := FALSE;
         end;
      Result := inrange;
   end else
      Result := FALSE;
end;

function  TDControl.KeyPress (var Key: Char): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   if Background then exit;
   for i:=DControls.Count-1 downto 0 do
      if TDControl(DControls[i]).Visible then
         if TDControl(DControls[i]).KeyPress(Key) then begin
            Result := TRUE;
            exit;
         end;
   if (FocusedControl=self) then begin
      if Assigned (FOnKeyPress) then FOnKeyPress (self, Key);
      Result := TRUE;
   end;
end;

function  TDControl.KeyDown (var Key: Word; Shift: TShiftState): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   if Background then exit;
   for i:=DControls.Count-1 downto 0 do
      if TDControl(DControls[i]).Visible then
         if TDControl(DControls[i]).KeyDown(Key, Shift) then begin
            Result := TRUE;
            exit;
         end;
   if (FocusedControl=self) then begin
      if Assigned (FOnKeyDown) then FOnKeyDown (self, Key, Shift);
      Result := TRUE;
   end;
end;

function  TDControl.CanFocusMsg: Boolean;
begin
   if (MouseCaptureControl = nil) or ((MouseCaptureControl <> nil) and ((MouseCaptureControl=self) or (MouseCaptureControl=DParent))) then
      Result := TRUE
   else
      Result := FALSE;
end;

function  TDControl.MouseMove (Shift: TShiftState; X, Y: Integer): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   for i:=DControls.Count-1 downto 0 do
      if TDControl(DControls[i]).Visible then
         if TDControl(DControls[i]).MouseMove(Shift, X-Left, Y-Top) then begin
            Result := TRUE;
            exit;
         end;

   if (MouseCaptureControl <> nil) then begin //MouseCapture ¿Ã∏È ¿⁄Ω≈¿Ã øÏº±
      if (MouseCaptureControl = self) then begin
         if Assigned (FOnMouseMove) then
            FOnMouseMove (self, Shift, X, Y);
         Result := TRUE;
      end;
      exit;
   end;

   if Background then exit;
   if InRange (X, Y) then begin
      if Assigned (FOnMouseMove) then
         FOnMouseMove (self, Shift, X, Y);
      Result := TRUE;
   end;
end;

function  TDControl.MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   for i:=DControls.Count-1 downto 0 do
      if TDControl(DControls[i]).Visible then
         if TDControl(DControls[i]).MouseDown(Button, Shift, X-Left, Y-Top) then begin
            Result := TRUE;
            exit;
         end;
   if Background then begin
      if Assigned (FOnBackgroundClick) then begin
         WantReturn := FALSE;
         FOnBackgroundClick (self);
         if WantReturn then Result := TRUE;
      end;
      ReleaseDFocus;
      exit;
   end;
   if CanFocusMsg then begin
      if InRange (X, Y) or (MouseCaptureControl = self) then begin
         if Assigned (FOnMouseDown) then
            FOnMouseDown (self, Button, Shift, X, Y);
         if EnableFocus then SetDFocus (self);
         //else ReleaseDFocus;
         Result := TRUE;
      end;
   end;
end;

function  TDControl.MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   for i:=DControls.Count-1 downto 0 do
      if TDControl(DControls[i]).Visible then
         if TDControl(DControls[i]).MouseUp(Button, Shift, X-Left, Y-Top) then begin
            Result := TRUE;
            exit;
         end;

   if (MouseCaptureControl <> nil) then begin //MouseCapture ¿Ã∏È ¿⁄Ω≈¿Ã øÏº±
      if (MouseCaptureControl = self) then begin
         if Assigned (FOnMouseUp) then
            FOnMouseUp (self, Button, Shift, X, Y);
         Result := TRUE;
      end;
      exit;
   end;

   if Background then exit;
   if InRange (X, Y) then begin
      if Assigned (FOnMouseUp) then
         FOnMouseUp (self, Button, Shift, X, Y);
      Result := TRUE;
   end;
end;

function  TDControl.DblClick (X, Y: integer): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   if (MouseCaptureControl <> nil) then begin //MouseCapture ¿Ã∏È ¿⁄Ω≈¿Ã øÏº±
      if (MouseCaptureControl = self) then begin
         if Assigned (FOnDblClick) then
            FOnDblClick (self);
         Result := TRUE;
      end;
      exit;
   end;
   for i:=DControls.Count-1 downto 0 do
      if TDControl(DControls[i]).Visible then
         if TDControl(DControls[i]).DblClick(X-Left, Y-Top) then begin
            Result := TRUE;
            exit;
         end;
   if Background then exit;
   if InRange (X, Y) then begin
      if Assigned (FOnDblClick) then
         FOnDblClick (self);
      Result := TRUE;
   end;
end;

function  TDControl.Click (X, Y: integer): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   if (MouseCaptureControl <> nil) then begin //MouseCapture ¿Ã∏È ¿⁄Ω≈¿Ã øÏº±
      if (MouseCaptureControl = self) then begin
         if Assigned (FOnClick) then
            FOnClick (self, X, Y);
         Result := TRUE;
      end;
      exit;
   end;
   for i:=DControls.Count-1 downto 0 do
      if TDControl(DControls[i]).Visible then
         if TDControl(DControls[i]).Click(X-Left, Y-Top) then begin
            Result := TRUE;
            exit;
         end;
   if Background then exit;
   if InRange (X, Y) then begin
      if Assigned (FOnClick) then
         FOnClick (self, X, Y);
      Result := TRUE;
   end;
end;

procedure TDControl.SetImgIndex (Lib: TWMImages; index: integer);
var
   d: TDirectDrawSurface;
begin
   //FaceSurface := dsurface;
   if Lib <> nil then begin
      d := Lib.Images[index];
      WLib := Lib;
      FaceIndex := index;
      if d <> nil then begin
         Width := d.Width;
         Height := d.Height;
      end;
   end;
end;

procedure TDControl.DirectPaint (dsurface: TDirectDrawSurface);
var
   i: integer;
   d: TDirectDrawSurface;
begin
   if Assigned (FOnDirectPaint) then
      FOnDirectPaint (self, dsurface)
   else
      if WLib <> nil then begin
         d := WLib.Images[FaceIndex];
         if d <> nil then
            dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end;
   for i:=0 to DControls.Count-1 do
      if TDControl(DControls[i]).Visible then
         TDControl(DControls[i]).DirectPaint (dsurface);
end;


{--------------------- TDButton --------------------------}


constructor TDButton.Create (AOwner: TComponent);
begin
   inherited Create (AOwner);
   Downed := FALSE;
   FOnClick := nil;
   FEnableFocus := TRUE;
   FClickSound := csNone;
end;

function  TDButton.MouseMove (Shift: TShiftState; X, Y: Integer): Boolean;
begin
   Result := inherited MouseMove (Shift, X, Y);
   if (not Background) and (not Result) then begin
      Result := inherited MouseMove (Shift, X, Y);
      if MouseCaptureControl = self then
         if InRange (X, Y) then Downed := TRUE
         else Downed := FALSE;
   end;
end;

function  TDButton.MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
   Result := FALSE;
   if inherited MouseDown (Button, Shift, X, Y) then begin
      if (not Background) and (MouseCaptureControl=nil) then begin
         Downed := TRUE;
         SetDCapture (self);
      end;
      Result := TRUE;
   end;
end;

function  TDButton.MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
   Result := FALSE;
   if inherited MouseUp (Button, Shift, X, Y) then begin
      ReleaseDCapture;
      if not Background then begin
         if InRange (X, Y) then begin
            if Assigned (FOnClickSound) then FOnClickSound(self, FClickSound);
            if Assigned (FOnClick) then FOnClick(self, X, Y);
         end;
      end;
      Downed := FALSE;
      Result := TRUE;
      exit;
   end else begin
      ReleaseDCapture;
      Downed := FALSE;
   end;
end;

{------------------------- TDGrid --------------------------}

constructor TDGrid.Create (AOwner: TComponent);
begin
   inherited Create (AOwner);
   FColCount := 8;
   FRowCount := 5;
   FColWidth := 36;
   FRowHeight:= 32;
   FOnGridSelect := nil;
   FOnGridMouseMove := nil;
   FOnGridPaint := nil;
end;

function  TDGrid.GetColRow (x, y: integer; var acol, arow: integer): Boolean;
begin
   Result := FALSE;
   if InRange (x, y) then begin
      acol := (x-Left) div FColWidth;
      arow := (y-Top) div FRowHeight;
      Result := TRUE;
   end;
end;

function  TDGrid.MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
   acol, arow: integer;
begin
   Result := FALSE;
   if mbLeft = Button then begin
      if GetColRow (X, Y, acol, arow) then begin
         SelectCell.X := acol;
         SelectCell.Y := arow;
         DownPos.X := X;
         DownPos.Y := Y;
         SetDCapture (self);
         Result := TRUE;
      end;
   end;
end;

function  TDGrid.MouseMove (Shift: TShiftState; X, Y: Integer): Boolean;
var
   acol, arow: integer;
begin
   Result := FALSE;
   if InRange (X, Y) then begin
      if GetColRow (X, Y, acol, arow) then begin
         if Assigned (FOnGridMouseMove) then
            FOnGridMouseMove (self, acol, arow, Shift);
      end;
      Result := TRUE;
   end;
end;

function  TDGrid.MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
   acol, arow: integer;
begin
   Result := FALSE;
   if mbLeft = Button then begin  
      if GetColRow (X, Y, acol, arow) then begin
         if (SelectCell.X = acol) and (SelectCell.Y = arow) then begin
            Col := acol;
            Row := arow;
            if Assigned (FOnGridSelect) then
               FOnGridSelect (self, acol, arow, Shift);
         end;
         Result := TRUE;
      end;
      ReleaseDCapture;
   end;      
end;

function  TDGrid.Click (X, Y: integer): Boolean;
var
   acol, arow: integer;
begin
   Result := FALSE;
  { if GetColRow (X, Y, acol, arow) then begin
      if Assigned (FOnGridSelect) then
         FOnGridSelect (self, acol, arow, []);
      Result := TRUE;
   end; }
end;

procedure TDGrid.DirectPaint (dsurface: TDirectDrawSurface);
var
   i, j: integer;
   rc: TRect;
begin
   if Assigned (FOnGridPaint) then
      for i:=0 to FRowCount-1 do
         for j:=0 to FColCount-1 do begin
            rc := Rect (Left + j*FColWidth, Top + i*FRowHeight, Left+j*(FColWidth+1)-1, Top+i*(FRowHeight+1)-1);
            if (SelectCell.Y = i) and (SelectCell.X = j) then
               FOnGridPaint (self, j, i, rc, [gdSelected], dsurface)
            else FOnGridPaint (self, j, i, rc, [], dsurface);
         end;
end;


{--------------------- TDWindown --------------------------}


constructor TDWindow.Create (AOwner: TComponent);
begin
   inherited Create (AOwner);
   FFloating := FALSE;
   FEnableFocus := TRUE;
   Width := 120;
   Height := 120;
end;

procedure TDWindow.SetVisible (flag: Boolean);
begin
   FVisible := flag;
   if Floating then begin
      if DParent <> nil then
         DParent.ChangeChildOrder (self);
   end;
end;

function  TDWindow.MouseMove (Shift: TShiftState; X, Y: Integer): Boolean;
var
   al, at: integer;
begin
   Result := inherited MouseMove (Shift, X, Y);
   if Result and FFloating and (MouseCaptureControl=self) then begin
      if (SpotX <> X) or (SpotY <> Y) then begin
         al := Left + (X - SpotX);
         at := Top + (Y - SpotY);
         if al+Width < WINLEFT then al := WINLEFT - Width;
         if al > WINRIGHT then al := WINRIGHT;
         if at+Height < WINTOP then at := WINTOP - Height;
         if at+Height > BOTTOMEDGE then at := BOTTOMEDGE-Height;
         Left := al;
         Top := at;
         SpotX := X;
         SpotY := Y;
      end;
   end;
end;

function  TDWindow.MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
   Result := inherited MouseDown (Button, Shift, X, Y);
   if Result then begin
      if Floating then begin
         if DParent <> nil then
            DParent.ChangeChildOrder (self);
      end;
      SpotX := X;
      SpotY := Y;
   end;
end;

function  TDWindow.MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
   Result := inherited MouseUp (Button, Shift, X, Y);
end;

procedure TDWindow.Show;
begin
   Visible := TRUE;
   if Floating then begin
      if DParent <> nil then
         DParent.ChangeChildOrder (self);
   end;
   if EnableFocus then SetDFocus (self);
end;

function  TDWindow.ShowModal: integer;
begin
   Result:=0;//Jacky
   Visible := TRUE;
   ModalDWindow := self;
   if EnableFocus then SetDFocus (self);
end;


{--------------------- TDWinManager --------------------------}


constructor TDWinManager.Create (AOwner: TComponent);
begin
   inherited Create (AOwner);
   DWinList := TList.Create;
   MouseCaptureControl := nil;
   FocusedControl := nil;
end;

destructor TDWinManager.Destroy;
begin
   inherited Destroy;
end;

procedure TDWinManager.ClearAll;
begin
   DWinList.Clear;
end;

procedure TDWinManager.AddDControl (dcon: TDControl; visible: Boolean);
begin
   dcon.Visible := visible;
   DWinList.Add (dcon);
end;

procedure TDWinManager.DelDControl (dcon: TDControl);
var
   i: integer;
begin
   for i:=0 to DWinList.Count-1 do
      if DWinList[i] = dcon then begin
         DWinList.Delete (i);
         break;
      end;
end;

function  TDWinManager.KeyPress (var Key: Char): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   if ModalDWindow <> nil then begin
      if ModalDWindow.Visible then begin
         with ModalDWindow do
            Result := KeyPress (Key);
         exit;
      end else
         ModalDWindow := nil;
      Key := #0; //ModalDWindow∞° KeyDown¿ª ∞≈ƒ°∏Èº≠ Visible=false∑Œ ∫Ø«œ∏Èº≠
             //KeyPress∏¶ ¥ŸΩ√∞≈√ƒº≠ ModalDwindow=nil¿Ã µ»¥Ÿ.
   end;

   if FocusedControl <> nil then begin
      if FocusedControl.Visible then begin
         Result := FocusedControl.KeyPress (Key);
      end else
         ReleaseDFocus;
   end;
   {for i:=0 to DWinList.Count-1 do begin
      if TDControl(DWinList[i]).Visible then begin
         if TDControl(DWinList[i]).KeyPress (Key) then begin
            Result := TRUE;
            break;
         end;
      end;
   end; }
end;

function  TDWinManager.KeyDown (var Key: Word; Shift: TShiftState): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   if ModalDWindow <> nil then begin
      if ModalDWindow.Visible then begin
         with ModalDWindow do
            Result := KeyDown (Key, Shift);
         exit;
      end else MOdalDWindow := nil;
   end;
   if FocusedControl <> nil then begin
      if FocusedControl.Visible then
         Result := FocusedControl.KeyDown (Key, Shift)
      else
         ReleaseDFocus;
   end;
   {for i:=0 to DWinList.Count-1 do begin
      if TDControl(DWinList[i]).Visible then begin
         if TDControl(DWinList[i]).KeyDown (Key, Shift) then begin
            Result := TRUE;
            break;
         end;
      end;
   end; }
end;

function  TDWinManager.MouseMove (Shift: TShiftState; X, Y: Integer): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   if ModalDWindow <> nil then begin
      if ModalDWindow.Visible then begin
         with ModalDWindow do
            MouseMove (Shift, LocalX(X), LocalY(Y));
         Result := TRUE;
         exit;
      end else MOdalDWindow := nil;
   end;
   if MouseCaptureControl <> nil then begin
      with MouseCaptureControl do
         Result := MouseMove (Shift, LocalX(X), LocalY(Y));
   end else
      for i:=0 to DWinList.Count-1 do begin
         if TDControl(DWinList[i]).Visible then begin
            if TDControl(DWinList[i]).MouseMove (Shift, X, Y) then begin
               Result := TRUE;
               break;
            end;
         end;
      end;
end;

function  TDWinManager.MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   if ModalDWindow <> nil then begin
      if ModalDWindow.Visible then begin
         with ModalDWindow do
            MouseDown (Button, Shift, LocalX(X), LocalY(Y));
         Result := TRUE;    
         exit;
      end else ModalDWindow := nil;     
   end;
   if MouseCaptureControl <> nil then begin
      with MouseCaptureControl do
         Result := MouseDown (Button, Shift, LocalX(X), LocalY(Y));
   end else
      for i:=0 to DWinList.Count-1 do begin
         if TDControl(DWinList[i]).Visible then begin
            if TDControl(DWinList[i]).MouseDown (Button, Shift, X, Y) then begin
               Result := TRUE;
               break;
            end;
         end;
      end;
end;

function  TDWinManager.MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
   i: integer;
begin
   Result := TRUE;
   if ModalDWindow <> nil then begin
      if ModalDWindow.Visible then begin
         with ModalDWindow do
            Result := MouseUp (Button, Shift, LocalX(X), LocalY(Y));
         exit;
      end else ModalDWindow := nil;
   end;
   if MouseCaptureControl <> nil then begin
      with MouseCaptureControl do
         Result := MouseUp (Button, Shift, LocalX(X), LocalY(Y));
   end else
      for i:=0 to DWinList.Count-1 do begin
         if TDControl(DWinList[i]).Visible then begin
            if TDControl(DWinList[i]).MouseUp (Button, Shift, X, Y) then begin
               Result := TRUE;
               break;
            end;
         end;
      end;
end;

function  TDWinManager.DblClick (X, Y: integer): Boolean;
var
   i: integer;
begin
   Result := TRUE;
   if ModalDWindow <> nil then begin
      if ModalDWindow.Visible then begin
         with ModalDWindow do
            Result := DblClick (LocalX(X), LocalY(Y));
         exit;
      end else ModalDWindow := nil;
   end;
   if MouseCaptureControl <> nil then begin
      with MouseCaptureControl do
         Result := DblClick (LocalX(X), LocalY(Y));
   end else
      for i:=0 to DWinList.Count-1 do begin
         if TDControl(DWinList[i]).Visible then begin
            if TDControl(DWinList[i]).DblClick (X, Y) then begin
               Result := TRUE;
               break;
            end;
         end;
      end;
end;

function  TDWinManager.Click (X, Y: integer): Boolean;
var
   i: integer;
begin
   Result := TRUE;
   if ModalDWindow <> nil then begin
      if ModalDWindow.Visible then begin
         with ModalDWindow do
            Result := Click (LocalX(X), LocalY(Y));
         exit;
      end else ModalDWindow := nil;
   end;
   if MouseCaptureControl <> nil then begin
      with MouseCaptureControl do
         Result := Click (LocalX(X), LocalY(Y));
   end else
      for i:=0 to DWinList.Count-1 do begin
         if TDControl(DWinList[i]).Visible then begin
            if TDControl(DWinList[i]).Click (X, Y) then begin
               Result := TRUE;
               break;
            end;
         end;
      end;
end;

procedure TDWinManager.DirectPaint (dsurface: TDirectDrawSurface);
var
   i: integer;
begin
   for i:=0 to DWinList.Count-1 do begin
      if TDControl(DWinList[i]).Visible then begin
         TDControl(DWinList[i]).DirectPaint (dsurface);
      end;
   end;
   if ModalDWindow <> nil then begin
      if ModalDWindow.Visible then
         with ModalDWindow do
            DirectPaint (dsurface);
   end;
end;

end.
