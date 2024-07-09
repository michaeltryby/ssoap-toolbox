unit autowiadjcalcthread;

interface

uses
  Classes, GWIAdjustment, GWIAdjustmentCollection, ADODB_TLB;

type
  automaticGWIAdjCalcThread = class(TThread)
    day: integer;
    analysisName, textToAdd: string;
    analysisID, meterID: integer;
    dailyAverage, average: real;
    adjustment: TGWIAdjustment;
    recSet: _RecordSet;
    constructor CreateIt();
  private
    procedure RemoveAllGWIAdjustmentsForAnalysis();
    procedure GetAnalysisData();
    procedure GetAverageFlows();
    procedure OpenQuery();
    procedure GetNextRecord();
    procedure CloseAndFreeQuery();
    procedure GetDailyAverage();
    procedure AddGWIAdjustment();
    procedure UpdateStatus();
    procedure AddToFeedbackMemo();
    procedure Feedback(line: string);
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
  end;

implementation

uses sysutils, windows, feedbackWithMemo, modDatabase, automaticgwiadjcalc,
     rdiiutils, mainform;

constructor automaticGWIAdjCalcThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true;     // Thread Free Itself when terminated
  Suspended := false;          // Continue the thread
end;

destructor automaticGWIAdjCalcThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure automaticGWIAdjCalcThread.Execute;
var
  value: real;
  i: integer;
  flowMeterName, flowUnitLabel, line: string;
  adjustments: TGWIAdjustmentCollection;
begin
  analysisName := frmAutomaticGWIAdjustmentCalculation.AnalysisNameComboBox.Items.Strings[frmAutomaticGWIAdjustmentCalculation.AnalysisNameComboBox.ItemIndex];
  flowMeterName := DatabaseModule.GetFlowMeterNameForAnalysis(analysisName);
  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
  Synchronize(GetAnalysisData);
  Synchronize(RemoveAllGWIAdjustmentsForAnalysis);
  Feedback('Determing Weekday and Weekend Average Flows...');
  Synchronize(GetAverageFlows);
  Feedback('');
  Feedback('Calculating DWF adjustments for each DWF Day...');
  Synchronize(OpenQuery);
  adjustments := TGWIAdjustmentCollection.Create;
  while (not recSet.EOF) do begin
    day := trunc(recSet.Fields.Item[0].Value);
    Synchronize(UpdateStatus);
    Synchronize(GetDailyAverage);
    value := round((dailyAverage - average) * 1000.0) / 1000.0;
    adjustment := TGWIAdjustment.Create(day,value);
    adjustments.AddAdjustment(adjustment);
    Synchronize(GetNextRecord);
  end;
  Synchronize(CloseAndFreeQuery);
  Feedback('');
  Feedback('DWF Adj #     Date    Adjustment ('+flowUnitLabel+')');
  Feedback('--------------------------------------');
  for i := 0 to adjustments.count - 1 do begin
    adjustment := adjustments[i];
    Synchronize(AddGWIAdjustment);
    line := leftPad(inttostr(i+1),length(inttostr(adjustments.count)));
    line := line + '      ' + leftPad(datetostr(adjustment.Date),10);
    line := line + '      ' + leftPad(floattostrF(adjustment.value,ffFixed,15,3),8);
    Feedback(line);
  end;
  adjustments.Free;
  Feedback('');
  Feedback('This window may be closed.');
end;

procedure automaticGWIAdjCalcThread.RemoveAllGWIAdjustmentsForAnalysis();
begin
  DatabaseModule.RemoveAllGWIAdjustmentsForAnalysis(analysisID);
end;

procedure automaticGWIAdjCalcThread.GetAnalysisData();
var
  queryStr: string;
  localRecSet: _RecordSet;
begin
  queryStr := 'SELECT AnalysisID, MeterID FROM Analyses WHERE ' +
              '(AnalysisName = "' + analysisName + '");';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  localRecSet.MoveFirst;
  analysisID := localRecSet.Fields.Item[0].Value;
  meterID := localRecSet.Fields.Item[1].Value;
  localRecSet.Close;
end;

procedure automaticGWIAdjCalcThread.GetAverageFlows();
var
  wdaverage, weaverage: real;
begin
  wdaverage := DatabaseModule.averageFlowForMeterDuringWeekdayDWF(meterID);
  weaverage := DatabaseModule.averageFlowForMeterDuringWeekendDWF(meterID);
  average := wdaverage*5.0/7.0 + weaverage*2.0/7.0;
end;

procedure automaticGWIAdjCalcThread.OpenQuery();
var
  queryStr: string;
begin
  queryStr := 'SELECT DWFDate FROM DryWeatherFlowDays WHERE ' +
              '((MeterID = ' + inttostr(meterID) + ') AND (Include = True)) ' +
              'ORDER BY DWFDate;';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if no records
  if recset.EOF then
  else
    recSet.MoveFirst;
end;

procedure automaticGWIAdjCalcThread.CloseAndFreeQuery();
begin
  if (recSet.State <> adStateClosed) then recSet.Close;
end;

procedure automaticGWIAdjCalcThread.GetNextRecord();
begin
  recSet.MoveNext;
end;

procedure automaticGWIAdjCalcThread.GetDailyAverage();
begin
  dailyAverage := DatabaseModule.AverageFlowForMeterAndDay(meterID,day);
end;

procedure automaticGWIAdjCalcThread.AddGWIAdjustment();
begin
  DatabaseModule.AddGWIAdjustment(analysisID,adjustment);
end;

procedure automaticGWIAdjCalcThread.UpdateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(day);
end;

procedure automaticGWIAdjCalcThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(textToAdd);
end;

procedure automaticGWIAdjCalcThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;

end.
