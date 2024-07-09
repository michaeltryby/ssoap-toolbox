unit hydrograph;

interface

type
  THydrograph = class(TObject)
    constructor createWithSize(hydrographSize, timestep: integer);

  private
    Fflows: array of real;
    Ftimestep: integer;
    procedure PutFlow (Index: integer; value: real);
    function GetFlow (Index: integer): real;
  public
    property Flows[Index: integer]: real
    read GetFlow write PutFlow;
    property TimeStep: integer
    read Ftimestep write Ftimestep;

    function size(): integer;
    function average: real;
    function runningAverageMaximum(numPointsToAverage: integer): real;
    function runningAverageMinimum(numPointsToAverage: integer): real;
    function volume: real;
    function minimum: real;
    function maximum: real;
    function indexOfMinimum: integer;

    function copyEmpty: THydrograph;
  end;


implementation

uses SysUtils;

constructor THydrograph.CreateWithSize(hydrographSize, timestep: integer);
begin
  SetLength(Fflows,hydrographSize);
  Ftimestep := timestep;
end;

procedure THydrograph.PutFlow(index: integer; value: real);
begin
  //rm 2007-10-22 - a little range checking
  if index < size then Fflows[index] := value;
end;

function THydrograph.GetFlow(index: integer): real;
begin
  //rm 2007-10-22 - a little range checking
  if index < size then GetFlow := Fflows[index]
  else GetFlow := 0;
end;

function THydrograph.size(): integer;
begin
  size := length(Fflows);
end;

function THydrograph.average(): real;
var
  i, count: integer;
  sum: real;
begin
  sum := 0.0;
  count := length(Fflows);
  for i := 0 to count - 1 do sum := sum + Fflows[i];
  average := sum/count;
end;

function THydrograph.runningAverageMaximum(numPointsToAverage: integer): real;
var
  i,j,k,count: integer;
  max, sum, avg: real;
  avgArray: array of real;
begin
  SetLength(avgArray,numPointsToAverage);
  max := 0.0;
  for i := 0 to length(avgArray) - 1 do avgArray[i] := 0.0;
  for i := 0 to length(Fflows) - 1 do begin
    for j := numPointsToAverage - 1 downto 1 do avgArray[j] := avgArray[j-1];
    avgArray[0] := Fflows[i];
    if (i < numPointsToAverage)
      then count := i + 1
      else count := numPointsToAverage;
    sum := avgArray[0];
    for k := 1 to count - 1 do sum := sum + avgArray[k];
    avg := sum / count;
    if (avg > max) then max := avg;
  end;
  runningAverageMaximum := max;
  avgArray := nil;
end;

function THydrograph.runningAverageMinimum(numPointsToAverage: integer): real;
var
  i,j,k,count: integer;
  min, sum, avg: real;
  avgArray: array of real;
begin
  SetLength(avgArray,numPointsToAverage);
  min := 9999999.9;
  for i := 0 to length(avgArray) - 1 do avgArray[i] := 0.0;
  for i := 0 to length(Fflows) - 1 do begin
    for j := numPointsToAverage - 1 downto 1 do avgArray[j] := avgArray[j-1];
    avgArray[0] := Fflows[i];
    if (i < numPointsToAverage)
      then count := i + 1
      else count := numPointsToAverage;
    sum := avgArray[0];
    for k := 1 to count - 1 do sum := sum + avgArray[k];
    avg := sum / count;
    if (avg < min) then min := avg;
  end;
  runningAverageMinimum := min;
  avgArray := nil;
end;


function THydrograph.volume(): real;
var
  i: integer;
  sum: real;
begin
  sum := Fflows[0];
  for i := 1 to length(Fflows) - 1 do
    sum := sum + Fflows[i];
  volume := sum * Ftimestep / 1440;
end;

function THydrograph.minimum: real;
var
  i: integer;
  min: real;
begin
  min := Fflows[0];
  for i := 1 to length(Fflows) - 1 do
    if (Fflows[i] < min) then min := Fflows[i];
  minimum := min;
end;

function THydrograph.indexOfMinimum: integer;
var
  i, minIndex: integer;
  min: real;
begin
  minIndex := 0;
  min := Fflows[0];
  for i := 1 to length(Fflows) - 1 do
    if (Fflows[i] < min) then begin
      min := Fflows[i];
      minIndex := i;
    end;
  indexOfMinimum := minIndex;
end;

function THydrograph.maximum: real;
var
  i: integer;
  max: real;
begin
  max := Fflows[0];
  for i := 1 to length(Fflows) - 1 do
    if (Fflows[i] > max) then max := Fflows[i];
  maximum := max;
end;

function THydrograph.copyEmpty: THydrograph;
begin
  copyEmpty := THydrograph.createWithSize(Length(FFlows),Ftimestep);
end;


end.
