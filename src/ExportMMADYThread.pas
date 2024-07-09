unit exportMMADYThread;

interface

uses
  Classes, ADODB_TLB;

type
  MMADYExportThread = class(TThread)
    flowMeterName, exportUnitLabel, textToAdd: String;
    meterID, timestep: integer;
    maximum, minimum, averageSum, conversionFactor: real;
    pastFlowsCounter, dayCounter: integer;
    maximumAverage, minimumAverage: real;
    F: TextFile;
    previousDay, previousMonth, previousYear: integer;
    month: word;
    overallMaximum, overallMinimum, overallAverageSum: real;
    timestamp: TDateTime;
    recSet: _RecordSet;
    constructor CreateIt();
  private { Private declarations }
    procedure GetFlowMeterData();
    procedure OpenQuery();
    procedure GetNextRecord();
    procedure CloseAndFreeQuery();
    procedure UpdateStatus();
    procedure writeDay();
    procedure AddToFeedbackMemo();
    procedure Feedback(line: string);
    procedure FeedbackLn(line: string);
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
  end;

implementation

uses mainform, windows, sysutils, dialogs,
     exportmaxminavgflow, feedbackWithMemo, modDatabase;

constructor MMADYExportThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true; // Thread Free Itself when terminated
  Suspended := false;         // Continue the thread
end;

destructor MMADYExportThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure MMADYExportThread.Execute;
var
  day, year, hour, minute, second, ms: word;
  pastflows: array of real;
  i, index, valuesPerDay, maximumAveragingRange, minimumAveragingRange: integer;
  flow, sum, runningAverage: real;
  counter: integer;
  filename: string;
begin
  filename := frmExportMaxMinAvg.FilenameEdit.Text;
  flowMeterName := frmExportMaxMinAvg.FlowMeterNameComboBox.Items.Strings[frmExportMaxMinAvg.FlowMeterNameComboBox.ItemIndex];
  exportUnitLabel := frmExportMaxMinAvg.UnitsComboBox.Items.Strings[frmExportMaxMinAvg.UnitsComboBox.ItemIndex];
  AssignFile(F,filename);
  Rewrite(F);
  try
  Feedback('Exporting...');
  Synchronize(GetFlowMeterData);
  Synchronize(OpenQuery);
  valuesPerDay := 1440 div timestep;
  SetLength(pastFlows,valuesPerDay);
  pastFlowsCounter := 0;
  for i := 0 to valuesPerDay - 1 do pastFlows[i] := 0.0;
  maximumAveragingRange := (frmExportMaxMinAvg.MaximumFlowAveragingDurationSpinEdit.Value * 60) div timestep;
  minimumAveragingRange := (frmExportMaxMinAvg.MinimumFlowAveragingDurationSpinEdit.Value * 60) div timestep;
  previousDay := 0;
  previousMonth := 0;
  previousYear := 0;
  maximum := -99999.0;
  minimum :=  99999.0;
  averageSum := 0.0;
  overallMaximum := -99999.0;
  overallMinimum :=  99999.0;
  overallAverageSum := 0.0;
  maximumAverage := -99999.0;
  minimumAverage :=  99999.0;
  dayCounter := 0;
  counter := 0;
  while (not recSet.EOF) do begin
    timestamp := TDateTime(recSet.Fields.Item[0].Value);
    Synchronize(updateStatus);
    decodeDate(timestamp,year,month,day);
    decodeTime(timestamp,hour,minute,second,ms);
    flow := recSet.Fields.Item[1].Value;
    if (previousDay = 0) then previousDay := day;
    if (previousMonth = 0) then previousMonth := month;
    if (previousYear = 0) then previousYear := year;
    index := ((hour * 60) + minute) div timestep;
    if (pastFlowsCounter > 0) then begin
      sum := 0.0;
      if (index >= maximumAveragingRange) then
        for i := index - maximumAveragingRange to index - 1 do
          sum := sum + pastFlows[i]
      else begin
        for i := 0 to index - 1 do sum := sum + pastFlows[i];
        for i := valuesPerDay - maximumAveragingRange + index to valuesPerDay - 1 do
          sum := sum + pastFlows[i];
      end;
      if (pastFlowsCounter < maximumAveragingRange)
        then runningAverage := sum / pastFlowsCounter
        else runningAverage := sum / maximumAveragingRange;
      if (runningAverage > maximum) then maximum := runningAverage;
      sum := 0.0;
      if (index >= minimumAveragingRange) then
        for i := index - minimumAveragingRange to index - 1 do
          sum := sum + pastFlows[i]
      else begin
        for i := 0 to index - 1 do sum := sum + pastFlows[i];
        for i := valuesPerDay - minimumAveragingRange + index to valuesPerDay - 1 do
          sum := sum + pastFlows[i];
      end;
      if (pastFlowsCounter < minimumAveragingRange)
        then runningAverage := sum / pastFlowsCounter
        else runningAverage := sum / minimumAveragingRange;
      if (runningAverage < minimum) then minimum := runningAverage;
    end;
    if (day <> previousDay) then begin
      writeDay();
      inc(counter);
    end;
    if (pastFlowsCounter < valuesPerDay) then inc(pastFlowsCounter);
    pastFlows[index] := flow;
    averageSum := averageSum + flow;
    overallAverageSum := overallAverageSum + flow;
    if (flow > overallMaximum) then overallMaximum := flow;
    if (flow < overallMinimum) then overallMinimum := flow;
    previousDay := day;
    previousMonth := month;
    previousYear := year;
    inc(dayCounter);
    Synchronize(GetNextRecord);
  end;
  if (dayCounter > 0) then begin   {protect against an empty flow record}
    month := 0;
    writeDay();
    inc(counter);
  end;
  finally
    CloseFile(F);
    Synchronize(CloseAndFreeQuery);
    Feedbackln('Exporting Complete.');
    Feedbackln('');
    Feedbackln(inttostr(counter)+' records written to '+filename);
    Feedbackln('');
    Feedback('This window may be closed.');
  end;
end;

procedure MMADYExportThread.writeDay();
var
  average, overallAverage: real;
  writeit: boolean;
begin
  maximum := (maximum * conversionFactor);
  minimum := (minimum * conversionFactor);
  average := (averageSum / pastFlowsCounter) * conversionFactor;
  if (average > maximumAverage) then maximumAverage := average;
  if (average < minimumAverage) then minimumAverage := average;
  writeit := true;
  if ((maximum = 0.0) and (not frmExportMaxMinAvg.WriteZeroMaximumsCheckBox.Checked)) then writeit := false;
  if ((minimum = 0.0) and (not frmExportMaxMinAvg.WriteZeroMinimumsCheckBox.Checked)) then writeit := false;
  if ((average = 0.0) and (not frmExportMaxMinAvg.WriteZeroAveragesCheckBox.Checked)) then writeit := false;
  if (writeit) then begin
    write(F,previousMonth:3,previousDay:3,previousYear:5,maximum:10:3,minimum:10:3,average:10:3);
    if (month <> previousMonth) then begin
      overallMaximum := overallMaximum * conversionFactor;
      overallMinimum := overallMinimum * conversionFactor;
      overallAverage := (overallAverageSum / dayCounter) * conversionFactor;
      maximumAverage := maximumAverage;
      minimumAverage := minimumAverage;
      write(F,previousMonth:3,previousYear:5,overallMaximum:10:3,overallMinimum:10:3,overallAverage:10:3);
      write(F,maximumAverage:10:3,minimumAverage:10:3,overallAverage:10:3);
      overallMaximum := -99999.0;
      overallMinimum :=  99999.0;
      overallAverageSum := 0;
      maximumAverage := -99999.0;
      minimumAverage :=  99999.0;
      dayCounter := 0;
    end;
    writeln(F);
  end;
  maximum := -99999.0;
  minimum :=  99999.0;
  averageSum := 0;
end;

procedure MMADYExportThread.GetFlowMeterData();
begin
  meterID := DatabaseModule.GetMeterIDForName(flowMeterName);
  timestep := DatabaseModule.GetFlowTimestep(meterID);
  conversionFactor := DatabaseModule.GetConversionFactorToUnitForMeter(meterID,exportUnitLabel);
end;

procedure MMADYExportThread.OpenQuery();
var
  startDateTime, endDateTime: TDateTime;
  queryStr: string;
begin
  startDateTime := frmExportMaxMinAvg.StartDatePicker.Date +
                   frac(frmExportMaxMinAvg.StartTimePicker.Time);
  endDateTime := frmExportMaxMinAvg.EndDatePicker.Date +
                 frac(frmExportMaxMinAvg.EndTimePicker.Time);

  queryStr := 'SELECT DateTime, Flow FROM Flows WHERE ' +
              '(((MeterID =' + inttostr(meterID) + ') AND ' +
              '(DateTime <= ' + floattostr(endDateTime) + ')) AND ' +
              '(DateTime >= ' + floattostr(startDateTime) + ')) ' +
              'ORDER BY DateTime;';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
end;

procedure MMADYExportThread.GetNextRecord();
begin
  recSet.MoveNext;
end;

procedure MMADYExportThread.CloseAndFreeQuery();
begin
  if (recSet.State <> adStateClosed) then recSet.Close;
end;

procedure MMADYExportThread.UpdateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(timestamp);
end;

procedure MMADYExportThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Text := frmFeedbackWithMemo.feedbackMemo.Text+textToAdd;
  frmFeedbackWithMemo.feedbackMemo.SelStart := Length(frmFeedbackWithMemo.feedbackMemo.Text)
end;

procedure MMADYExportThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;

procedure MMADYExportThread.FeedbackLn(line: string);
begin
  textToAdd := line+#13+#10;
  Synchronize(AddToFeedbackMemo);
end;

end.
