unit nighttimeFlowsThread;

interface

uses
  Classes, ADODB_TLB;

type
  MinimumNighttimeFlowsThread = class(TThread)
    numsmall, numbtsteps, meterID: integer;
    avgarray, minimumFlows: array of real;
    minimumDates: array of TDateTime;
    textToAdd, flowUnitLabel: string;
    timestamp: TDateTime;
    recSet: _RecordSet;
    constructor CreateIt();
  private
    procedure GetFlowMeterData();
    procedure OpenFlowsQuery();
    procedure NextFlowRecord();
    procedure CloseAndFreeFlowsQuery();
    function CompAvg(): real;
    function ComputeAvg(flow:real): real;
    procedure ShowResults();
    procedure AddToFeedbackMemo();
    procedure Feedback(line: string);
    procedure UpdateStatus();
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
  end;

implementation

uses windows, mainform, sysutils, minimumNighttimeFlows, feedbackWithMemo, modDatabase;

constructor MinimumNighttimeFlowsThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true; // Thread Free Itself when terminated
  Suspended := false;         // Continue the thread
end;

destructor MinimumNighttimeFlowsThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure MinimumNighttimeFlowsThread.Execute;
var
  i, j: integer;
  dayNow: TDateTime;
  flow, avg, minFlow: real;
begin
  Synchronize(GetFlowMeterData);
  numbtsteps := frmMinimumNighttimeFlows.TimeStepsSpinEdit.Value;
  numsmall := frmMinimumNighttimeFlows.NumberMinimumFlowsSpinEdit.Value;
  SetLength(avgArray,numbtsteps);
  SetLength(minimumDates,numsmall);
  SetLength(minimumFlows,numsmall);
  for i := 0 to numsmall - 1 do minimumFlows[i] := 9999999.0;
  Synchronize(OpenFlowsQuery);
  //rm 2007-10-18 - prevent crash if no records
  if recSet.EOF then begin
    Synchronize(CloseAndFreeFlowsQuery);
    Synchronize(ShowResults);
    exit;
  end;
  dayNow := trunc(recSet.Fields.Item[0].Value);
  for i := 0 to numbtsteps - 1 do begin
    avgarray[i] := recSet.Fields.Item[1].Value;
    Synchronize(NextFlowRecord);
  end;
  Synchronize(CloseAndFreeFlowsQuery);
  minFlow := 9999999.0;
  Synchronize(OpenFlowsQuery);
  while (not recSet.EOF) do begin
    timestamp := recSet.Fields.Item[0].Value;
    Synchronize(UpdateStatus);
    flow := recSet.Fields.Item[1].Value;
    avg := computeAvg(flow);
    if (trunc(timestamp) = dayNow) then begin
      if (avg < minFlow) then minFlow := avg;
    end
    else begin
      if (minFlow<minimumFlows[numsmall-1]) then begin
        i := 0;
        while (minimumFlows[i] < minFlow) do inc(i);
        if (i < numsmall - 1) then begin
          for j := (numsmall - 1) downto (i + 1) do begin
            minimumFlows[j] := minimumFlows[j-1];
            minimumDates[j] := minimumDates[j-1];
          end;
        end;
        minimumFlows[i] := minFlow;
        minimumDates[i] := dayNow;
      end;
      dayNow := trunc(timestamp);
      minFlow := 9999999.0;
    end;
    Synchronize(NextFlowRecord);
  end;
  Synchronize(CloseAndFreeFlowsQuery);
  Synchronize(ShowResults);
  Feedback('');
  Feedback('This window may be closed.');
end;

procedure MinimumNighttimeFlowsThread.GetFlowMeterData();
begin
  meterID := DatabaseModule.GetMeterIDForName(frmMinimumNighttimeFlows.FlowMeterNameComboBox.Text);
  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(frmMinimumNighttimeFlows.FlowMeterNameComboBox.Text);
end;

procedure MinimumNighttimeFlowsThread.OpenFlowsQuery();
var
  queryStr: string;
begin
  queryStr := 'SELECT DateTime, Flow FROM Flows WHERE ' +
              '(MeterID = ' + inttostr(meterID) + ') ORDER BY DateTime;';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if no records
  if recSet.EOF then
    Feedback('No flow data!')
  else
    recSet.MoveFirst;
end;

procedure MinimumNighttimeFlowsThread.NextFlowRecord();
begin
  recSet.MoveNext;
end;

procedure MinimumNighttimeFlowsThread.CloseAndFreeFlowsQuery();
begin
  if (recSet.State <> adStateClosed) then recSet.Close;
end;

function MinimumNighttimeFlowsThread.CompAvg(): real;
var
  i: integer;
  sum: real;
  arezeros: boolean;
begin
  sum := 0.0;
  arezeros := false;
  for i := 0 to numbtsteps - 1 do begin
    if (avgarray[i] = 0) then arezeros := true;
    sum := sum+avgarray[i];
  end;
  if (arezeros) then compavg := 999999999.0
    else compavg := sum / numbtsteps;
end;

function MinimumNighttimeFlowsThread.ComputeAvg(flow:real): real;
var
  i: integer;
begin
  for i := 0 to numbtsteps - 2 do avgarray[i] := avgarray[i+1];
  avgarray[numbtsteps-1] := flow;
  computeavg := compavg;
end;

procedure MinimumNighttimeFlowsThread.ShowResults();
var
  i: integer;
begin
//rm 2009-06-09 - Beta 1 review indicates wrong flow unit label - but i cannot replicate error condition
  for i := 0 to numsmall - 1 do begin
    if (minimumFlows[i] <> 9999999.0) then
      Feedback(inttostr(i+1)+'   '+datetostr(minimumDates[i])+'   '+floattostrF(minimumFlows[i],ffFixed,8,4)+' '+flowUnitLabel);
  end;
end;

procedure MinimumNighttimeFlowsThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(textToAdd);
end;

procedure MinimumNighttimeFlowsThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;

procedure MinimumNighttimeFlowsThread.UpdateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(timestamp);
end;

end.
