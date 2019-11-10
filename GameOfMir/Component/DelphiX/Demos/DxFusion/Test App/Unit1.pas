Unit Unit1;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, DXClass, jpeg, StdCtrls, ComCtrls, Menus,
  Spin, DXDraws, DIB;

Type
  TForm1 = Class(TDXForm)
    Scr: TDXDraw;
    rgDrawMethod: TRadioGroup;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    Label2: TLabel;
    Timer: TDXTimer;
    rgFilter: TRadioGroup;
    tbAlpha: TTrackBar;
    Label3: TLabel;
    mmMenu: TMainMenu;
    About1: TMenuItem;
    Exit1: TMenuItem;
    About2: TMenuItem;
    btnPlay: TButton;
    Imgs: TDXImageList;
    Procedure rgDrawMethodClick(Sender: TObject);
    Procedure Exit1Click(Sender: TObject);
    Procedure About2Click(Sender: TObject);
    Procedure btnPlayClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject; LagCount: Integer);
    procedure ScrInitialize(Sender: TObject);
    procedure ScrFinalize(Sender: TObject);
  Private
    { Private declarations }
    FPause: Boolean;
    eDIB, iDIB: TDXDIB;
  Public
    { Public declarations }
  End;

Var
  Form1: TForm1;

Implementation

{$R *.DFM}

Procedure TForm1.rgDrawMethodClick(Sender: TObject);
Begin
  With rgDrawMethod Do
    If (ItemIndex = 7) Or (ItemIndex = 8) Then
      rgFilter.Enabled := True
    Else
      rgFilter.Enabled := False;

End;

Procedure TForm1.Exit1Click(Sender: TObject);
Begin
  Application.Terminate;
End;

Procedure TForm1.About2Click(Sender: TObject);
Begin
  Application.MessageBox('conFusion DrawMethod Demo' + chr(13) + 'by Joakim Back' + chr(13) + chr(13) + 'WWW: www.algonet.se/~aseback/acoustic/cd_2den.html' + chr(13) + 'Email: n98joab@tycho.helsingborg.se', 'About', 0);
End;

Procedure TForm1.btnPlayClick(Sender: TObject);
Begin
  FPause := Not FPause;
  Case FPause Of
    True:
      Begin
        btnPlay.Caption := 'Run';
      End;
    False:
      Begin
        btnPlay.Caption := 'Pause';
      End;
  End;
End;

procedure TForm1.TimerTimer(Sender: TObject; LagCount: Integer);
Const
  A: Array[0..9] of Integer=(1,1,1,3,1,1,1,2,1,3);
Var
  i, j, k: integer;
  X:TPictureCollectionItem;

Begin
  If NOT Scr.CanDraw Then exit;

  //Imgs.Items[0].Draw(Scr.Surface, 0, 0, 0);
  eDIB.DIB.Assign(Imgs.Items[0].Picture);

  For i := 0 To SpinEdit1.Value Do
  Begin
    j := random(Scr.Width - Imgs.Items[2].Width);
    k := random(Scr.Height - Imgs.Items[2].Height);
    iDIB.DIB.Assign(Imgs.Items[A[rgDrawMethod.ItemIndex]].Picture);
    Case rgDrawMethod.ItemIndex Of
      0: eDIB.DIB.DrawTo(iDIB.DIB, j, k, iDIB.DIB.Width, iDIB.DIB.Height, 0, 0);
      1: eDIB.DIB.DrawTransparent(iDIB.DIB, j, k, iDIB.DIB.Width, iDIB.DIB.Height, 0, 0, clBlack);
      2: eDIB.DIB.DrawAdditive(iDIB.DIB, j, k, iDIB.DIB.Width, iDIB.DIB.Height, 255, 0);
      3: eDIB.DIB.DrawDarken(iDIB.DIB, j, k, iDIB.DIB.Width, iDIB.DIB.Height, 0);
      4: eDIB.DIB.DrawTranslucent(iDIB.DIB, j, k, iDIB.DIB.Width, iDIB.DIB.Height, 0, 0, clBlack);
      5: eDIB.DIB.DrawAlpha(iDIB.DIB, j, k, iDIB.DIB.Width, iDIB.DIB.Height, 0, 0, tbAlpha.Position, clBlack);
      6: eDIB.DIB.DrawAlphaMask(iDIB.DIB, iDIB.DIB, j, k, iDIB.DIB.Width, iDIB.DIB.Height, 0, 0);
      7: Case rgFilter.ItemIndex Of
          0: eDIB.DIB.DrawShadow(iDIB.DIB, j, k, iDIB.DIB.Width, iDIB.DIB.Height, 0, fmNormal);
          1: eDIB.DIB.DrawShadow(iDIB.DIB, j, k, iDIB.DIB.Width, iDIB.DIB.Height, 0, fmMix25);
          2: eDIB.DIB.DrawShadow(iDIB.DIB, j, k, iDIB.DIB.Width, iDIB.DIB.Height, 0, fmMix50);
          3: eDIB.DIB.DrawShadow(iDIB.DIB, j, k, iDIB.DIB.Width, iDIB.DIB.Height, 0, fmMix75);
        End;
      9: eDIB.DIB.DrawMorphed(iDIB.DIB, j, k, iDIB.DIB.Width, iDIB.DIB.Height, 0, 0, clBlack);
    End;
  End;

  //Timer.Tag := Timer.Tag + 1;
  eDIB.DIB.DrawOn(eDIB.DIB.Canvas,Scr.ClientRect, Scr.Surface.Canvas, 0, 0);
  with Scr.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clWhite;
    Font.Size := 12;
    Textout(0, 0, 'FPS: '+inttostr(Timer.FrameRate));
    if doHardware in Scr.NowOptions then
      Textout(0, 14, 'Device: Hardware')
    else
      Textout(0, 14, 'Device: Software');

    Release; {  Indispensability  }
  end;

  //Scr.Surface.BltFast(0,0,Bounds(0,0,eDIB.DIB.Width, eDIB.DIB.Height),COPYRT,eDIB.DIB);
  //eDIB.DIB.DrawOn(Image1.ClientRect, Image1.Canvas, 0, 0);

  //Form1.Caption := 'Graphics_engine.pas demo - fps: ' + inttostr(Timer.Tag);
  //Timer.Tag := 0;

  Scr.Flip;
end;

procedure TForm1.ScrInitialize(Sender: TObject);
begin
  eDIB := TDXDIB.Create(Self);
  eDIB.DIB.SetSize(Imgs.Items[0].Width, Imgs.Items[0].Height,24);
  iDIB := TDXDIB.Create(Self);
  iDIB.DIB.SetSize(Imgs.Items[1].Width, Imgs.Items[1].Height,24);
  Timer.Enabled := True;
end;

procedure TForm1.ScrFinalize(Sender: TObject);
begin
  Timer.Enabled := False;
end;

End.

