unit autoeventdefThread;

interface

uses
  Classes, GWIAdjustmentCollection, GWIAdjustment, Hydrograph, modDatabase,
  StormEventCollection, StormEvent, Analysis, ADODB_TLB;

type
  automaticEventDefThread = class(TThread)
    analysisName, textToAdd: string;
    timestep, analysisID, meterID, raingaugeID: integer;
    gwiAdjustments: TGWIAdjustmentCollection;
    recSet: _RecordSet;
    newEvent: TStormEvent;
    volume: real;
    events: TStormEventCollection;
    timestamp: TDateTime;
    diurnal: diurnalCurves;

    constructor CreateIt();
  private
    analysis: TAnalysis;
    holidays: daysArray;
    boHasData: boolean;

    function isHoliday(date: TDateTime): boolean;
    function dayOfWeekIndex(date: TDateTime): integer;
    procedure GetThemHolidays();

    procedure RemoveAllEventsForAnalysis();
    procedure GetAnalysisData();
    procedure GetGWIAdjustments();
    procedure GetDWF();
    procedure OpenQuery();
    procedure NextRecord();
    procedure CloseAndFreeQuery();
    procedure RainfallTotalForRaingaugeBetweenDates();
    procedure AddEventsToDatabase();
    procedure UpdateStatus();
    procedure AddToFeedbackMemo();
    procedure Feedback(line: string);
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
  end;

implementation

uses sysutils, windows, feedbackWithMemo, automaticeventdef, rdiiutils, mainform;

function automaticEventDefThread.isHoliday(date: TDateTime): boolean;
var
  i: integer;
begin
  isHoliday := false;
  for i := 0 to length(holidays) - 1 do begin
    if (trunc(date) = holidays[i]) then isHoliday := true;
  end;
end;

function automaticEventDefThread.dayOfWeekIndex(date: TDateTime): integer;
(* returns day of week 0 = sun, 1 = mon, 2 = tues..... 6 = saturday *)
(* holidays are returned as 7 *)
var
  dow: integer;
begin
  dow := dayofweek(date) - 1;
  if (isholiday(date)) then dow := 7;
  dayOfWeekIndex := dow;
end;

constructor automaticEventDefThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true;     // Thread Free Itself when terminated
  Suspended := false;          // Continue the thread
end;

destructor automaticEventDefThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure automaticEventDefThread.Execute;
var
  flow, gwi, fbww, iiflow, averageII, minEventDuration,minRainVolume: real;
  i, timestepsToAverage, segmentsPerDay: integer;
  avgarray: array of real;
  hour, minute, second, ms: word;
  peakii, prevpeakii, minPeakII, addStart, addEnd: real;
  previousEvent: TStormEvent;
  inEvent, keepit: boolean;

  function computeavg(flow:real): real;
  var
    m: integer;
    sum: real;
  begin
    if (timestepsToAverage > 1) then begin
      for m := 0 to timestepsToAverage - 2 do avgarray[m] := avgarray[m+1];
    end;
    avgarray[timestepsToAverage-1] := flow;
    sum := 0;
    for m := 0 to timestepsToAverage - 1 do sum := sum + avgarray[m];
    computeavg := sum / timestepsToAverage;
  end;

  function calciiflow(): real;
  var
    k, dow: integer;
  begin
    gwi := gwiAdjustments.AdjustmentAt(timestamp);
    k := trunc((hour + (minute / 60.0)) / 24 * segmentsPerDay);
    dow := dayOfWeekIndex(timestamp);
    fbww := diurnal[dow,k];
    calciiflow := flow - fbww - gwi;
  end;

begin
  analysisName := frmAutomaticEventIdentification.AnalysisNameComboBox.Items.Strings[frmAutomaticEventIdentification.AnalysisNameComboBox.ItemIndex];
  Synchronize(GetAnalysisData);
  Synchronize(RemoveAllEventsForAnalysis);
  Synchronize(GetThemHolidays);

  segmentsPerDay := 1440 div timeStep;

  timestepsToAverage := frmAutomaticEventIdentification.TimeStepsToAverageSpinEdit.Value;
  SetLength(avgarray,timestepsToAverage);

  if (Length(frmAutomaticEventIdentification.MinimumPeakIIEdit.Text) > 0)
    then minPeakII := strtofloat(frmAutomaticEventIdentification.MinimumPeakIIEdit.Text)
    else minPeakII := 0.0;
  if (Length(frmAutomaticEventIdentification.MinimumEventDurationEdit.Text) > 0)
    then minEventDuration := strtofloat(frmAutomaticEventIdentification.MinimumEventDurationEdit.Text)
    else minEventDuration := 0.0;
  if (Length(frmAutomaticEventIdentification.MinimumRainfallVolumeEdit.Text) > 0)
    then minRainVolume := strtofloat(frmAutomaticEventIdentification.MinimumRainfallVolumeEdit.Text)
    else minRainVolume := 0.0;
  addStart := frmAutomaticEventIdentification.HoursToAddToStartSpinEdit.Value;
  addEnd := frmAutomaticEventIdentification.HoursToAddToEndSpinEdit.Value;

  Synchronize(GetGWIAdjustments);
  Feedback('Determing Weekday and Weekend DWF Hydrographs...');
  Synchronize(GetDWF);

  Feedback('');
  Feedback('Scanning Flow Record to Determine Events...');
  Synchronize(OpenQuery);
//rm 2007-10-18 - prevent crash if no records
  if not boHasData then begin
    Feedback('No flow data!');
    Synchronize(CloseAndFreeQuery);
    events.Free;
    exit;
  end;


  for i := 0 to timestepsToAverage - 1 do begin
    timestamp := recSet.Fields.Item[0].Value;
    DecodeTime(timestamp,hour,minute,second,ms);
    flow := recSet.Fields.Item[1].Value;
    iiflow := calciiflow();
    avgarray[i] := iiflow;
    Synchronize(NextRecord);
  end;

  peakii := 0.0;
  events := TStormEventCollection.Create;
  events.Capacity := 50;
  inEvent := false;
  while (not recSet.EOF) do begin
    timestamp := recSet.Fields.Item[0].Value;
    Synchronize(UpdateStatus);
    DecodeTime(timestamp,hour,minute,second,ms);
    flow := recSet.Fields.Item[1].Value;
    iiflow := calciiflow();
    averageII := computeavg(iiflow);

    if (averageII > 0.0) then begin
      if (inEvent) then begin
        if (averageII > peakII) then peakII := averageII;
      end
      else begin
        newEvent := TStormEvent.Create;
        newEvent.StartDate := timestamp;
        prevPeakII := peakII;
        peakII := averageII;
        inEvent := true;
      end;
    end
    else if (inEvent) then begin
      newEvent.EndDate := timestamp;
      keepit := true;
      if (peakii < minPeakII) then keepit := false;
      if ((newEvent.Duration * 24) < minEventDuration) then keepit := false;
      if (keepit) then begin
        newEvent.StartDate := newEvent.StartDate - ((timeStepsToAverage*timeStep/1440) + (addStart / 24.0));
        newEvent.EndDate := newEvent.EndDate + (addEnd / 24.0);
        if (events.count > 1) then begin
          if (newEvent.StartDate > previousEvent.EndDate) then begin
            Synchronize(RainfallTotalForRaingaugeBetweenDates);
            if (volume >= minRainVolume) then begin
              events.AddEvent(newEvent);
              previousEvent := newEvent;
            end;
          end
          else begin
            previousEvent.EndDate := newEvent.EndDate;
            newEvent.Free;
            if (prevPeakII > peakII) then peakII := prevPeakII;
          end;
        end
        else begin
          Synchronize(RainfallTotalForRaingaugeBetweenDates);
          if (volume >= minRainVolume) then begin
            events.AddEvent(newEvent);
            previousEvent := newEvent;
          end;
        end;
      end
      else begin
        newEvent.Free;
      end;
      inEvent := false;
    end;
    Synchronize(NextRecord);
  end;
  Synchronize(CloseAndFreeQuery);
  Synchronize(AddEventsToDatabase);
  events.Free;
  Finalize(holidays);
  Feedback('');
  Feedback('This window may be closed.');
end;

procedure automaticEventDefThread.RemoveAllEventsForAnalysis();
begin
  DatabaseModule.RemoveAllEventsForAnalysis(analysisID);
end;

procedure automaticEventDefThread.GetAnalysisData();
begin
  analysis := DatabaseModule.GetAnalysis(analysisName);
  analysisID := analysis.AnalysisID;
  meterID := analysis.FlowMeterID;
  raingaugeID := analysis.RaingaugeID;

  timestep := DatabaseModule.GetFlowTimestep(meterID);
end;

procedure automaticEventDefThread.GetGWIAdjustments();
begin
  gwiAdjustments := DatabaseModule.GetGWIAdjustments(analysisID);
end;

procedure automaticEventDefThread.GetDWF();
begin
  diurnal := DatabaseModule.GetDiurnalCurves(analysisName);
end;

procedure automaticEventDefThread.OpenQuery();
var
  queryStr: string;
begin
  boHasData := true;
  queryStr := 'SELECT DateTime, Flow FROM Flows WHERE (MeterID =' + inttostr(meterID) + ')';
  //rm 2007-10-22 - ORDER BY DATETIME
  queryStr := queryStr + ' ORDER BY [DATETIME];';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if no records
  if recSet.EOF then begin
    Feedback('NO FLOW DATA?');
    boHasData := false;
  end else begin
    recSet.MoveFirst;
    boHasData := true;
  end;
end;

procedure automaticEventDefThread.NextRecord();
begin
  recSet.MoveNext;
end;

procedure automaticEventDefThread.CloseAndFreeQuery();
begin
//rm 2007-10-18
  if not (recSet = nil) then
    if (recSet.State <> adStateClosed) then recSet.Close;
end;

procedure automaticEventDefThread.RainfallTotalForRaingaugeBetweenDates();
begin
  volume := DatabaseModule.RainfallTotalForRaingaugeBetweenDates(raingaugeID,newEvent.StartDate,newEvent.EndDate);
end;

procedure automaticEventDefThread.AddEventsToDatabase();
var
  i: integer;
  event: TStormEvent;
  line: string;
begin
  Feedback('');
  Feedback(inttostr(events.count)+' events defined');
  Feedback('');
  Feedback('Event #        Start Date           End Date');
  Feedback('--------------------------------------------');
  for i := 0 to events.count - 1 do begin
    event := events[i];
    line := leftPad(inttostr(i+1),length(inttostr(events.count)));
    line := line + '       ' + leftPad(dateTimeString(event.StartDate),16);
    line := line + '   ' + leftPad(dateTimeString(event.EndDate),16);
    Feedback(line);
  end;
  DatabaseModule.AddEvents(analysisID, events);
end;

procedure automaticEventDefThread.UpdateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(timestamp);
end;

procedure automaticEventDefThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(textToAdd);
end;

procedure automaticEventDefThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;

procedure automaticEventDefThread.GetThemHolidays();
begin
  holidays := DatabaseModule.GetHolidays();
end;


end.
