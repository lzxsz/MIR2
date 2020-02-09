unit ViewKernelInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Grids, SDK, Grobal2;

type
  TfrmViewKernelInfo = class(TForm)
    Timer: TTimer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditLoadHumanDBCount: TEdit;
    EditLoadHumanDBErrorCoun: TEdit;
    EditSaveHumanDBCount: TEdit;
    EditHumanDBQueryID: TEdit;
    GroupBox4: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    EditItemNumber: TEdit;
    EditItemNumberEx: TEdit;
    TabSheet3: TTabSheet;
    GroupBox5: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    EditGlobalVal1: TEdit;
    EditGlobalVal2: TEdit;
    EditGlobalVal3: TEdit;
    EditGlobalVal4: TEdit;
    EditGlobalVal5: TEdit;
    EditGlobalVal6: TEdit;
    EditGlobalVal7: TEdit;
    Label21: TLabel;
    Label22: TLabel;
    EditGlobalVal8: TEdit;
    EditGlobalVal9: TEdit;
    Label23: TLabel;
    EditGlobalVal10: TEdit;
    Label24: TLabel;
    TabSheet4: TTabSheet;
    GroupBox6: TGroupBox;
    Label25: TLabel;
    EditAllocMemCount: TEdit;
    Label26: TLabel;
    EditAllocMemSize: TEdit;
    TabSheet5: TTabSheet;
    GroupBox7: TGroupBox;
    GridThread: TStringGrid;
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure GridThreadAdd(ThreadInfo: pTThreadInfo; Index: Integer);
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmViewKernelInfo: TfrmViewKernelInfo;

implementation

uses M2Share;

{$R *.dfm}

{ TfrmViewKernelInfo }


procedure TfrmViewKernelInfo.FormCreate(Sender: TObject);
resourcestring
  sNo = '序号';
  sHandle = '句柄';
  sThreadID = '线程ID';
  sRunTime = '运行时间';
  sRunFlag = '运行状态';
begin
  GridThread.Cells[0, 0] := sNo;
  GridThread.Cells[1, 0] := sHandle;
  GridThread.Cells[2, 0] := sThreadID;
  GridThread.Cells[3, 0] := sRunTime;
  GridThread.Cells[4, 0] := sRunFlag;
end;
procedure TfrmViewKernelInfo.Open;
begin
  Timer.Enabled := True;
  ShowModal;
  Timer.Enabled := False;
end;

procedure TfrmViewKernelInfo.TimerTimer(Sender: TObject);
var
  Config: pTM2Config;
  ThreadInfo: pTThreadInfo;
begin
  Config := @g_Config;
  EditLoadHumanDBCount.Text := IntToStr(g_Config.nLoadDBCount);
  EditLoadHumanDBErrorCoun.Text := IntToStr(g_Config.nLoadDBErrorCount);
  EditSaveHumanDBCount.Text := IntToStr(g_Config.nSaveDBCount);
  EditHumanDBQueryID.Text := IntToStr(g_Config.nDBQueryID);

  EditItemNumber.Text := IntToStr(g_Config.nItemNumber);
  EditItemNumberEx.Text := IntToStr(g_Config.nItemNumberEx);

//取消彩票功能
//  EditWinLotteryCount.Text := IntToStr(g_Config.nWinLotteryCount);
//  EditNoWinLotteryCount.Text := IntToStr(g_Config.nNoWinLotteryCount);
//  EditWinLotteryLevel1.Text := IntToStr(g_Config.nWinLotteryLevel1);
//  EditWinLotteryLevel2.Text := IntToStr(g_Config.nWinLotteryLevel2);
//  EditWinLotteryLevel3.Text := IntToStr(g_Config.nWinLotteryLevel3);
//  EditWinLotteryLevel4.Text := IntToStr(g_Config.nWinLotteryLevel4);
//  EditWinLotteryLevel5.Text := IntToStr(g_Config.nWinLotteryLevel5);
//  EditWinLotteryLevel6.Text := IntToStr(g_Config.nWinLotteryLevel6);

  EditGlobalVal1.Text := IntToStr(g_Config.GlobalVal[0]);
  EditGlobalVal2.Text := IntToStr(g_Config.GlobalVal[1]);
  EditGlobalVal3.Text := IntToStr(g_Config.GlobalVal[2]);
  EditGlobalVal4.Text := IntToStr(g_Config.GlobalVal[3]);
  EditGlobalVal5.Text := IntToStr(g_Config.GlobalVal[4]);
  EditGlobalVal6.Text := IntToStr(g_Config.GlobalVal[5]);
  EditGlobalVal7.Text := IntToStr(g_Config.GlobalVal[6]);
  EditGlobalVal8.Text := IntToStr(g_Config.GlobalVal[7]);
  EditGlobalVal9.Text := IntToStr(g_Config.GlobalVal[8]);
  EditGlobalVal10.Text := IntToStr(g_Config.GlobalVal[9]);

  EditAllocMemSize.Text := IntToStr(AllocMemSize);
  EditAllocMemCount.Text := IntToStr(AllocMemCount);

//  GridThread.Row:=2;

  ThreadInfo := @Config.UserEngineThread;
  GridThreadAdd(ThreadInfo, 0);
  ThreadInfo := @Config.IDSocketThread;
  GridThreadAdd(ThreadInfo, 1);
  ThreadInfo := @Config.DBSOcketThread;
  GridThreadAdd(ThreadInfo, 2);

end;

procedure TfrmViewKernelInfo.GridThreadAdd(ThreadInfo: pTThreadInfo; Index: Integer);
begin
  GridThread.Cells[0, Index + 1] := Format('%d', [Index]);
  GridThread.Cells[1, Index + 1] := Format('%d', [ThreadInfo.hThreadHandle]);
  GridThread.Cells[2, Index + 1] := Format('%d', [ThreadInfo.dwThreadID]);
  GridThread.Cells[3, Index + 1] := Format('%d/%d/%d', [GetTickCount - ThreadInfo.dwRunTick,
    ThreadInfo.nRunTime,
      ThreadInfo.nMaxRunTime]);
  GridThread.Cells[4, Index + 1] := Format('%d', [ThreadInfo.nRunFlag]);
end;


end.
