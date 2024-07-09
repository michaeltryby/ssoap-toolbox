unit EventStatGetter;

interface

uses modDatabase, Analysis, SysUtils, StrUtils, StormEventCollection, StormEvent,
      GWIAdjustmentCollection, Hydrograph;

type
  TEventStatGetter = class(TObject)
    constructor Create(analysisID : integer); overload;
  private
    FEventID: integer;
    FEventName: string;
    FAnalysisID: integer;
    FAnalysisName: string;
    FMeterID: integer;
    FMeterName: string;
    FRaingaugeID: integer;
    FRaingaugeName: string;
    FStart: real;
    FEnd: real;
    FArea: double;
    FiiVolume: double;
    FiiDepth: double;
    FeventTotalR: double;
    FeventTotalR1: double;
    FeventTotalR2: double;
    FeventTotalR3: double;
    FmaxRain: double;
    FRainVolume: double;
    FpeakObservedFlow: double;
    FpeakIIFlow: double;
    FaverageObservedFlow: double;
    Fpeakfctr: double;
    Fpeakwwf: double;
    Ffbwwsum: double;
    FsewerLength: double;
    FRDIIperLF: double;
    FRDIIgalperLF: double;
    FRDIIcfperLF: double;

    analysis: TAnalysis;
    holidays: daysArray;
    timestep, segmentsPerDay: integer;
    runningAverageDuration: double;
    timestepsToAverage: integer;
    conversionToMGD, conversionToInches: double;
    areaUnitLabel: string;
    conversionToAcres: double;
    volumeconversionfactor: double;
    weekdayDWFMinimum, weekendDWFMinimum, avggwi, avgbwwf, minbwwf: double;
    events: TStormEventCollection;
    event: TStormEvent;
    gwiAdjustments: TGWIAdjustmentCollection;
    minWeekdayDWFIndex, minWeekendDWFIndex, rdeltime: integer;
    diurnal: diurnalCurves;
    decimalPlaces: integer;
    flowUnitLabel, rainUnitLabel, volumeUnitLabel: string;
    rainStartDate, rainEndDate: TDateTime;

    //rm 2012-07-03
    weekdayDWFAvg: double;
    FRDIIperADWF: double;

    function isHoliday(date: TDateTime): boolean;
    function dayOfWeekIndex(date: TDateTime): integer;
    function GetVolumeConversionFactr(sFlowUnitLabel: string): double;
    function GetRDIIperLFLabel(sFlowUnitLabel: string; var dVol: double): string;
  public
    property AnalysisID: integer
      read FAnalysisID write FAnalysisID;
    property AnalysisName: string
      read FAnalysisName;
    property EventID: integer
      read FEventID write FEventID;
    property EventName: string
      read FEventName;

    property MeterName: string
      read FMeterName;
    property RaingaugeName: string
      read FRaingaugeName;

    property StartDate: real
      read FStart;
    property EndDate: real
      read FEnd;

    property Area: double read FArea;

    property iiVolume: double read FiiVolume;
    property iiDepth: double read FiiDepth;
    property eventTotalR: double read FeventTotalR;
    property eventTotalR1: double read FeventTotalR1;
    property eventTotalR2: double read FeventTotalR2;
    property eventTotalR3: double read FeventTotalR3;
    property maxRain: double read FmaxRain;
    property rainVolume: double read FRainVolume;
    property peakObservedFlow: double read FpeakObservedFlow;
    property peakIIFlow: double read FpeakIIFlow;
    property averageObservedFlow: double read FaverageObservedFlow;
    property peakfctr: double read Fpeakfctr;
    property peakwwf: double read Fpeakwwf;
    property fbwwsum: double read Ffbwwsum;
    property sewerLength: double read FsewerLength;
    property RDIIperLF: double read FRDIIperLF;
    property RDIIgalperLF: double read FRDIIgalperLF;
    property RDIIcfperLF: double read FRDIIcfperLF;

    //rm 2012-07-03
    property RDIIperADWF: double read FRDIIperADWF;

    function GetAnalysisSpecifics: integer;
    function GetEventStats(eventID: integer): integer;

    function eventRT(eventID: integer): double;
    function eventR1(eventID: integer): double;
    function eventR2(eventID: integer): double;
    function eventR3(eventID: integer): double;
    function eventR2R3(eventID: integer): double;

    procedure AllDone;
  end;

implementation
uses ADODB_TLB;

{ TEventStatGetter }

procedure TEventStatGetter.AllDone;
begin
  Finalize(diurnal);
  Finalize(holidays);
end;

constructor TEventStatGetter.Create(analysisID: integer);
begin
  FAnalysisID := analysisID;
  GetAnalysisSpecifics;
end;

function TEventStatGetter.dayOfWeekIndex(date: TDateTime): integer;
(* returns day of week 0 = sun, 1 = mon, 2 = tues..... 6 = saturday *)
(* holidays are returned as 7 *)
var
  dow: integer;
begin
  dow := dayofweek(date) - 1;
  if (isholiday(date)) then dow := 7;
  dayOfWeekIndex := dow;
end;

function TEventStatGetter.eventRT(eventID: integer): double;
begin
//rm 2012-04-19
  event := events[eventID - 1];
  result := event.R[0] + event.R[1] + event.R[2];
end;

function TEventStatGetter.eventR1(eventID: integer): double;
begin
//rm 2012-04-19
  event := events[eventID - 1];
  result := event.R[0];
end;

function TEventStatGetter.eventR2(eventID: integer): double;
begin
//rm 2012-04-19
  event := events[eventID - 1]; //rm 2012-08-24 - added to be sure we are on the correct event
  result := event.R[1];
end;

function TEventStatGetter.eventR3(eventID: integer): double;
begin
//rm 2012-04-19
  event := events[eventID - 1]; //rm 2012-08-24 - added to be sure we are on the correct event
  result := event.R[2];
end;

function TEventStatGetter.eventR2R3(eventID: integer): double;
begin
//rm 2012-04-19
  event := events[eventID - 1]; //rm 2012-08-24 - added to be sure we are on the correct event
  result := event.R[1] + event.R[2];
end;

function TEventStatGetter.GetAnalysisSpecifics: integer;
var
  weekdayDWF, weekendDWF: THydrograph;
begin
  holidays := DatabaseModule.GetHolidays();
  FAnalysisName := DatabaseModule.GetAnalysisNameForID(FAnalysisID);

  analysis := DataBaseModule.GetAnalysis(FAnalysisName);
  FAnalysisID := analysis.AnalysisID;
  FMeterID := analysis.FlowMeterID;
  FRaingaugeID := analysis.RaingaugeID;
  runningAverageDuration := analysis.RunningAverageDuration;

  FArea := DatabaseModule.GetAreaForAnalysis(FAnalysisName);
  conversionToAcres := DatabaseModule.GetConversionToAcresForMeter('',FMeterID);
  FArea := FArea * conversionToAcres;
  //now area is in Acres so we can use it in calculations
  //remember to convert back to original units for display with the new areaunits variable
  areaUnitLabel := DatabaseModule.GetAreaUnitLabelForMeter('',FMeterID);
  //rm

  FMeterName := DatabaseModule.GetFlowMeterNameForAnalysis(FAnalysisName);
  FRaingaugeName := DatabaseModule.GetRaingaugeNameForAnalysis(FAnalysisName);
  minbwwf := DatabaseModule.GetBaseFlowRateForAnalysis(FAnalysisName);
  rdeltime := DatabaseModule.GetRainfallTimestep(FRaingaugeID);
  conversionToMGD := DatabaseModule.GetConversionForMeter(FMeterID);
  conversionToInches := DatabaseModule.GetConversionForRaingauge(FRaingaugeID);
  diurnal := DatabaseModule.GetDiurnalCurves(FAnalysisName);
  events := DatabaseModule.GetEvents(FAnalysisID);
  gwiAdjustments := DatabaseModule.GetGWIAdjustments(analysisID);
  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(FMeterName);

  //rm 2010-04-23
  volumeconversionfactor := GetVolumeConversionFactr(flowUnitLabel);
  //rm 2010-10-20
  Fsewerlength := DatabaseModule.GetSewerLengthForMeter(FMeterID);

  rainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(raingaugeName);
  decimalPlaces := DatabaseModule. GetRainfallDecimalPlacesForRaingauge(raingaugeName);
  volumeUnitLabel := DatabaseModule.GetFlowVolumeLabelForMeter(FMeterName);
  weekdayDWF := DatabaseModule.GetWeekdayDWF(FMeterID);
  weekendDWF := DatabaseModule.GetWeekendDWF(FMeterID);
  minWeekdayDWFIndex := weekdayDWF.indexOfMinimum;
  minWeekendDWFIndex := weekdayDWF.indexOfMinimum;
  weekdayDWFMinimum := weekdayDWF.Minimum;
  weekendDWFMinimum := weekendDWF.Minimum;

  //rm 2012-07-03 get weekday dwf avg flow
  weekdayDWFAvg := weekdayDWF.average;

  weekdayDWF.Free;
  weekendDWF.Free;

  timestep := DatabaseModule.GetFlowTimestep(FMeterID);
  segmentsPerDay := 1440 div timeStep;
  timestepsToAverage := round(runningAverageDuration*60/timestep);
  Result := 1;
end;

function TEventStatGetter.GetEventStats(eventID: integer): integer;
var
  timestamp, todayMinTimestamp: TDateTime;
  hour, minute, second, ms: word;
  todayCGWIAtMin, nextBWW, nextGWIAdjAtMin, nextCGWIAtMin, ratio: real;
  cgwi, prevBWW, prevGWIAdjAtMin, prevCGWIAtMin: real;
  i, k, todayMinIndex, nextMinIndex, prevMinIndex, dow: integer;
  nextMinTimestamp, prevMinTimestamp: TDateTime;
  todayGWIAdjAtMin, fbww, fgwi, todayBWW, avggwisum, avgbwwfsum, fgwisum: real;
  observedFlowHydrograph, IIHydrograph: THydrograph;
begin
  event := events[eventID - 1];
  FStart := event.StartDate;
  FEnd := event.EndDate;
  FRainVolume := DatabaseModule.RainfallTotalForRaingaugeBetweenDates(FRaingaugeID,event.StartDate,event.EndDate);
  DatabaseModule.GetExtremeRainfallDateTimesBetweenDates(FRaingaugeID,
                                                         FStart,
                                                         FEnd,
                                                         RainStartDate,
                                                         RainEndDate);
  FmaxRain := DatabaseModule.GetMaximumRainfallBetweenDates(FRaingaugeID,FStart,FEnd);
  observedFlowHydrograph := DatabaseModule.ObservedFlowBetweenDateTimes(FMeterID,FStart,FEnd);
  iiHydrograph := observedFlowHydrograph.copyEmpty;
  avggwisum := 0.0;
  avgbwwfsum := 0.0;
  Fpeakfctr := 0.0;
  Fpeakwwf := 0.0;
  Ffbwwsum := 0.0;
  fgwisum := 0.0;
  for i := 0 to observedFlowHydrograph.size - 1 do begin
    timestamp := event.StartDate + (i / segmentsPerDay);
    DecodeTime(timestamp,hour,minute,second,ms);
    fgwi := gwiAdjustments.AdjustmentAt(timestamp);
    k := trunc((hour + (minute / 60.0)) / 24 * segmentsPerDay);
    dow := dayOfWeekIndex(timestamp);
    fbww := diurnal[dow,k];
    iiHydrograph.flows[i] := observedFlowHydrograph.flows[i]-fbww-fgwi;
    Ffbwwsum := Ffbwwsum + fbww;
    fgwisum := fgwisum + fgwi;
    if (observedFlowHydrograph.flows[i] > peakwwf) then begin
      Fpeakwwf := observedFlowHydrograph.flows[i];
    end;

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
    avggwisum := avggwisum + cgwi;
    avgbwwfsum := avgbwwfsum + fgwi + fbww - cgwi;
  end;
  avggwi := avggwisum / iiHydrograph.size;
  avgbwwf := avgbwwfsum / iiHydrograph.size;
  FiiVolume := iiHydrograph.volume;
  //rm 2009-10-30 - Note that we have already converted area to acres
  FiiDepth := FiiVolume*conversionToMGD*12.0/(area*43560.0)*1000000.0/7.481/conversionToInches;
  if (FrainVolume > 0.0)
    then FeventTotalR := FiiDepth/FrainVolume
  else FeventTotalR := 0.0;
  FpeakObservedFlow := observedFlowHydrograph.runningAverageMaximum(timestepsToAverage);
  FaverageObservedFlow := observedFlowHydrograph.average;
  FpeakIIFlow := iiHydrograph.runningAverageMaximum(timestepsToAverage);
//rm 2009-04-13
  if (abs(Ffbwwsum) > 0) then begin
    Fpeakfctr := FpeakobservedFlow / (Ffbwwsum / iiHydrograph.size);
    if (sewerlength > 0) then begin
      FRDIIperLF := (Farea * (iiDepth/12)*43560) / Fsewerlength; //in CF / LF
      FRDIIgalperLF := FiiVolume * volumeconversionfactor / Fsewerlength; //in gal / LF
      FRDIIcfperLF := ((FiiDepth/12) * Farea * 43560) / Fsewerlength; //in CF / LF
    end else begin
      FRDIIperLF := 0;
      FRDIIgalperLF := 0;
      FRDIIcfperLF := 0;
    end;
  end;
  //rm 2012-07-03 new one RDIIperADWF
  if (weekdayDWFAvg > 0) then
    FRDIIperADWF := FeventTotalR / weekdayDWFAvg
  else
    FRDIIperADWF := 0;


  observedFlowHydrograph.Free;
  iiHydrograph.Free;

  Result := 1;
end;

function TEventStatGetter.GetRDIIperLFLabel(sFlowUnitLabel: string;
  var dVol: double): string;
begin

end;

function TEventStatGetter.GetVolumeConversionFactr(
  sFlowUnitLabel: string): double;
var
  sTimeUnit: string;
begin
  if Length(sFlowUnitLabel) > 0 then begin
    sTimeUnit := RightStr(sFlowUnitLabel,1);
    if (sTimeUnit = 'S') then     //seconds in a day
      Result := 86400.0
    else if (sTimeUnit = 'M') then
      Result := 1440.0            //minutes in a day
    else if (sTimeUnit = 'D') then
      Result := 1.0
    else Result := 1.0;
  end else Result := 1.0;
end;

function TEventStatGetter.isHoliday(date: TDateTime): boolean;
var
  i: integer;
begin
  isHoliday := false;
  for i := 0 to length(holidays) - 1 do begin
    if (trunc(date) = holidays[i]) then isHoliday := true;
  end;
end;

end.
