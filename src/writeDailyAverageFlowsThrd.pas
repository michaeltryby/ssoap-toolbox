unit writeDailyAverageFlowsThrd;

interface

uses
  Classes, Hydrograph, GWIAdjustmentCollection, modDatabase, ADODB_TLB, StormEvent;

type
  WriteDailyAverageFlowsThread = class(TThread)
    textToAdd: string;
    recSet: _RecordSet;
    minbwwf, weekdayDWFMinimum, weekendDWFMinimum: real;
    analysisID, meterID, timestep, segmentsPerDay: integer;
    gwiAdjustments: TGWIAdjustmentCollection;
    minWeekdayDWFIndex, minWeekendDWFIndex: integer;
    timestamp: TDateTime;
    diurnal: diurnalCurves;
    constructor CreateIt();
  private
    holidays: daysArray;

    function isHoliday(date: TDateTime): boolean;
    function dayOfWeekIndex(date: TDateTime): integer;
    procedure GetThemHolidays();
    procedure GetAnalysisData();
    procedure OpenQuery();
    procedure NextRecord();
    procedure CloseAndFreeQuery();
    procedure UpdateStatus();
    procedure AddToFeedbackMemo();
    procedure Feedback(line: string);
    procedure FeedbackLn(line: string);
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
  end;

implementation

uses windows, mainform, sysutils, dialogs, feedbackWithMemo, writeDailyAverageFlows;

function WriteDailyAverageFlowsThread.isHoliday(date: TDateTime): boolean;
var
  i: integer;
begin
  isHoliday := false;
  for i := 0 to length(holidays) - 1 do begin
    if (trunc(date) = holidays[i]) then isHoliday := true;
  end;
end;

function WriteDailyAverageFlowsThread.dayOfWeekIndex(date: TDateTime): integer;
(* returns day of week 0 = sun, 1 = mon, 2 = tues..... 6 = saturday *)
(* holidays are returned as 7 *)
var
  dow: integer;
begin
  dow := dayofweek(date) - 1;
  if (isholiday(date)) then dow := 7;
  dayOfWeekIndex := dow;
end;

constructor WriteDailyAverageFlowsThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true; // Thread Free Itself when terminated
  Suspended := false;         // Continue the thread
end;

destructor WriteDailyAverageFlowsThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure WriteDailyAverageFlowsThread.Execute;
var
  F: TextFile;
  todayMinTimestamp, nextMinTimestamp, prevMinTimestamp: TDateTime;
  flow, fbww, fgwi, fiandi, todayBWW, todayGWIAdjAtMin: real;
  year, month, day, hour, minute, second, ms: word;
  k, todayMinIndex, nextMinIndex, prevMinIndex, dow: integer;
  todayCGWIAtMin, nextBWW, nextGWIAdjAtMin, nextCGWIAtMin, ratio, cgwi: real;
  prevBWW, prevGWIAdjAtMin, prevCGWIAtMin: real;
  counter, count, prevDay, prevMonth, prevYear: integer;
  avgobssum, avgdwfsum, avggwisum, avgbwwfsum, avgiisum: real;
  filename: string;
begin
  filename := frmWriteDailyAverageFlows.FilenameEdit.Text;
  assignFile(F,filename);
  rewrite(F);
  Feedback('Determining Weekday and Weekend Flow DWF Hydrographs...');
  Synchronize(GetAnalysisData);
  Synchronize(GetThemHolidays);
  FeedbackLn('Done.');
  FeedbackLn('');
  Feedback('Writing output file...');
  counter := 0;
  Synchronize(OpenQuery);
  //rm 2009-06-09 - Beta 1 review - change BWWF to BWF
  //writeln(F,'"month","day","year","lotus date","number of obs","obs flow","adjusted DWF","gwi flow","BWWF","iandi"');
  writeln(F,'"month","day","year","lotus date","number of obs","obs flow","adjusted DWF","gwi flow","BWF","iandi"');
  prevDay := 0;
  prevYear := 0;
  prevMonth := 0;
  count := 0;
  avgobssum := 0.0;
  avgdwfsum := 0.0;
  avggwisum := 0.0;
  avgbwwfsum := 0.0;
  avgiisum := 0.0;
  while (not recSet.EOF) do begin
    timestamp := recSet.fields.item[0].Value;
    Synchronize(UpdateStatus);
    flow := recSet.fields.item[1].Value;
    DecodeDate(timestamp,year,month,day);
    DecodeTime(timestamp,hour,minute,second,ms);
    k := trunc((hour + (minute / 60.0)) / 24 * segmentsPerDay);
    dow := dayOfWeekIndex(timestamp);
    fbww := diurnal[dow,k];
    fgwi := gwiAdjustments.AdjustmentAt(timestamp);
    if (dow in [0,6,7]) then begin
      todayMinIndex := minWeekendDWFIndex;
      todayBWW := weekendDWFMinimum;
    end
    else begin
      todayMinIndex := minWeekdayDWFIndex;
      todayBWW := weekdayDWFMinimum;
    end;
    todayMinTimestamp := trunc(timestamp) + (todayMinIndex / segmentsPerDay);
    todayGWIAdjAtMin := gwiAdjustments.AdjustmentAt(todayMinTimeStamp);
    todayCGWIAtMin := todayBWW + todayGWIAdjAtMin;
    if (k >= todayMinIndex) then begin
      if (dayOfWeekIndex(timestamp + 1) in [0,6,7]) then begin
        nextMinIndex := minWeekendDWFIndex;
        nextBWW := weekendDWFMinimum;
      end
      else begin
        nextMinIndex := minWeekdayDWFIndex;
        nextBWW := weekdayDWFMinimum;
      end;
      nextMinTimestamp := trunc(timestamp) + (nextMinIndex / segmentsPerDay) + 1;
      nextGWIAdjAtMin := gwiAdjustments.AdjustmentAt(nextMinTimestamp);
      nextCGWIAtMin := nextBWW + nextGWIAdjAtMin;
      ratio := (timestamp-todayMinTimestamp)/(nextMinTimestamp-todayMinTimestamp);
      cgwi := todayCGWIAtMin + (nextCGWIAtMin - todayCGWIAtMin)*ratio - minbwwf;
    end
    else begin
      if (dayOfWeekIndex(timestamp - 1) in [0,6,7]) then begin
        prevMinIndex := minWeekendDWFIndex;
        prevBWW := weekendDWFMinimum;
      end
      else begin
        prevMinIndex := minWeekdayDWFIndex;
        prevBWW := weekdayDWFMinimum;
      end;
      prevMinTimestamp := trunc(timestamp) + (prevMinIndex / segmentsPerDay) - 1;
      prevGWIAdjAtMin := gwiAdjustments.AdjustmentAt(prevMinTimestamp);
      prevCGWIAtMin := prevBWW + prevGWIAdjAtMin;
      ratio := (timestamp-prevMinTimestamp)/(todayMinTimestamp-prevMinTimestamp);
      cgwi := prevCGWIAtMin + (todayCGWIAtMin - prevCGWIAtMin)*ratio - minbwwf;
    end;
    fiandi := flow-fbww-fgwi;
    if (prevday = 0) then begin
      prevday := day;
      prevMonth := month;
      prevYear := year;
    end;
    if (day = prevDay) then begin
      inc(count);
      avgobssum  := avgobssum  + flow;
      avgdwfsum  := avgdwfsum  + fbww + fgwi;
      avggwisum  := avggwisum  + cgwi;
      avgbwwfsum := avgbwwfsum + fbww + fgwi - cgwi;
      avgiisum   := avgiisum   + fiandi;
    end
    else begin
      write(F,prevMonth,',');
      write(F,prevday,',');
      write(F,prevYear,',');
      write(F,floattostrF(timestamp,ffFixed,8,3),',');
      write(F,count,',');
      write(F,floattostrF(avgobssum/count,ffFixed,8,4),',');
      write(F,floattostrF(avgdwfsum/count,ffFixed,8,4),',');
      write(F,floattostrF(avggwisum/count,ffFixed,8,4),',');
      write(F,floattostrF(avgbwwfsum/count,ffFixed,8,4),',');
      write(F,floattostrF(avgiisum/count,ffFixed,8,4),',');
      writeln(F);
      inc(counter);
      avgobssum  := flow;
      avgdwfsum  := fbww + fgwi;
      avggwisum  := cgwi;
      avgbwwfsum := fbww + fgwi - cgwi;
      avgiisum   := fiandi;
      count := 1;
      prevDay := day;
      prevMonth := month;
      prevYear := year;
    end;
    Synchronize(NextRecord);
  end;
  Synchronize(CloseAndFreeQuery);
  closeFile(F);
  Finalize(holidays);
  FeedbackLn('Done.');
  FeedbackLn('');
  FeedbackLn(inttostr(counter)+' records written to '+filename);
  FeedbackLn('');
  Feedback('Export Complete.  This window may be closed.');
end;

procedure WriteDailyAverageFlowsThread.GetAnalysisData();
var
  analysisName, flowMeterName: string;
  weekdayDWF, weekendDWF: THydrograph;
begin
  analysisName := frmWriteDailyAverageFlows.AnalysisNameComboBox.Text;
  minbwwf := DatabaseModule.GetBaseFlowRateForAnalysis(analysisName);
  flowMeterName := DatabaseModule.GetFlowMeterNameForAnalysis(analysisName);
  analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
  gwiAdjustments := DatabaseModule.GetGWIAdjustments(analysisID);
  meterID := DatabaseModule.GetMeterIDForName(flowMeterName);

  weekdayDWF := DatabaseModule.GetWeekdayDWF(meterID);
  weekendDWF := DatabaseModule.GetWeekendDWF(meterID);
  minWeekdayDWFIndex := weekdayDWF.indexOfMinimum;
  minWeekendDWFIndex := weekendDWF.indexOfMinimum;
  weekdayDWFMinimum := weekdayDWF.Minimum;
  weekendDWFMinimum := weekendDWF.Minimum;
  weekdayDWF.Free;
  weekendDWF.Free;

  timestep := DatabaseModule.GetFlowTimestep(meterID);
  segmentsPerDay := 1440 div timeStep;

  diurnal := DatabaseModule.GetDiurnalCurves(analysisName);
end;

procedure WriteDailyAverageFlowsThread.OpenQuery();
var
  startDateTime, endDateTime: TDateTime;
  queryStr: string;
begin
  startDateTime := frmWriteDailyAverageFlows.StartDatePicker.Date +
                   frac(frmWriteDailyAverageFlows.StartTimePicker.Time);
  endDateTime := frmWriteDailyAverageFlows.EndDatePicker.Date +
                 frac(frmWriteDailyAverageFlows.EndTimePicker.Time);
  queryStr := 'SELECT DateTime, Flow FROM Flows WHERE ' +
              '((MeterID = ' + inttostr(meterID) + ') AND ' +
              '(DateTime >= ' + floattostr(startDateTime) + ' AND ' +
//rm 2010-05-04 - ORDER BY DATETIME??
//              'DateTime <= ' + floattostr(endDateTime) + '));';
              'DateTime <= ' + floattostr(endDateTime) + ')) ORDER BY DATETIME;';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //rm 2007-10-18
  if not recSet.EOF then
    recSet.MoveFirst;
end;

procedure WriteDailyAverageFlowsThread.NextRecord();
begin
  recSet.MoveNext;
end;

procedure WriteDailyAverageFlowsThread.CloseAndFreeQuery();
begin
  if (recSet.State <> adStateClosed) then recSet.Close;
end;

procedure WriteDailyAverageFlowsThread.UpdateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(timestamp);
end;

procedure WriteDailyAverageFlowsThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Text := frmFeedbackWithMemo.feedbackMemo.Text+textToAdd;
  frmFeedbackWithMemo.feedbackMemo.SelStart := Length(frmFeedbackWithMemo.feedbackMemo.Text)
end;

procedure WriteDailyAverageFlowsThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;

procedure WriteDailyAverageFlowsThread.FeedbackLn(line: string);
begin
  textToAdd := line+#13+#10;
  Synchronize(AddToFeedbackMemo);
end;

procedure WriteDailyAverageFlowsThread.GetThemHolidays();
begin
  holidays := DatabaseModule.GetHolidays();
end;


end.
