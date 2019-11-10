// This unit demonstrates how it is possible to use the Hardware counter
// in modern CPUs for high resolution timing.
// The HWcounter counts the number of clock cycles since the PC was turned on
// Henrik Fabricius, Delphi3DX, June 2002

unit HWCounter;

interface

uses
  Windows, typer3D;


function Initialize_HardwareCounter: boolean;
function Counts_needed(msecs : integer): Int64;
function CalculateTimeForNextBullet: Int64;


implementation

var
  //Hardware counter
  FFrequency : Int64;
  FCounter_overhead : Int64;
  FCountStart : Int64;
  FCountStop : Int64;
  FCountsBetweenBullets : Int64;

function Initialize_HardwareCounter : boolean;
var
  svar : LongBool;
begin
  //The QueryPerformanceFrequency function retrieves the frequency
  //of the high-resolution performance counter, if it exists.
  svar := QueryPerformanceFrequency(FFrequency);

  if svar
  then
  begin
    //Find the time used for the call of the API Function
    QueryPerformanceCounter(FCountStart);
    QueryPerformanceCounter(FCountStop);
    FCounter_Overhead := FCountStop - FCountStart;
    //calculate counts needed beteen bullets
    FCountsBetweenBullets := Counts_needed(MinTimeBetweenBullets);
    HWCountNextBulletAllowed := CalculateTimeForNextBullet;
  end
  else
    FCounter_overhead := 0;

  //the counter exists if svar <> 0
  Result := svar;
end;



function Counts_needed(msecs : integer): Int64;
begin
  //Calculation of the number of caunts corresponding to a timedelay of msecs
  //Zero should give a zero repply
  if msecs = 0
  then
    Result := 0
  else
    Result := Fcounter_overhead + msecs * Ffrequency div 1000;
end;


function CalculateTimeForNextBullet: Int64;
var
  HWCountNow : Int64;
begin
  //Calculate HWCount where next bullet is allowed
  QueryPerformanceCounter(HWCountNow);
  Result := HWCountNow + FCountsBetweenBullets;
end;



end.
 