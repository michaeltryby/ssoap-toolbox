unit computedVsSimulatedRDIISummaryStatistics;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Spin, StdCtrls, StormEventCollection, GWIAdjustmentCollection, Analysis,
  Hydrograph, StormEvent, math, modDatabase, ADODB_TLB, StrUtils;

type
  TfrmComparisonSummary = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    AnalysisNameComboBox: TComboBox;
    StatisticsMemo: TMemo;
    closeButton: TButton;
    EventSpinEdit: TSpinEdit;
    saveToCSVFileButton: TButton;
    SaveStatsDialog: TSaveDialog;
    SummaryMemo: TMemo;
    Button1: TButton;
    Button2: TButton;
    MemoDebug: TMemo;
    {procedure FormCreate(Sender: TObject);}
    procedure AnalysisNameComboBoxChange(Sender: TObject);
    procedure EventSpinEditChange(Sender: TObject);
    procedure TimeStepsToAverageSpinEditChange(Sender: TObject);
    procedure closeButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure saveToCSVFileButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
  private
    analysis: TAnalysis;

    gwiAdjustments: TGWIAdjustmentCollection;
    observedFlowHydrograph, iiHydrograph, rdiiHydrograph: THydrograph;
    //CCC 2010-02-18 ver 1.0.2
    simulatedFlowHydrograph: THydrograph;

    event: TStormEvent;
    analysisID, meterID, raingaugeID, rdeltime, timestep, segmentsPerDay: integer;
    timestepsToAverage, totalSegments: integer;
    flowMeterName, raingaugeName: string;
    conversionToMGD, conversionToInches: real;
    rainUnitLabel, volumeUnitLabel: string;
    minWeekdayDWFIndex, minWeekendDWFIndex: integer;
    area, minbwwf, weekdayDWFMinimum, weekendDWFMinimum: real;
    rainStartDate, rainEndDate: TDateTime;
    rdiiCurve: array of array of real;
    rdiiTotal: array of real;
    rainfall: array of real;
    startDay, endDay, days: integer;
    timestamp: TDateTime;
    rtimestamp: TTimeStamp;
    allavgerr, standarderror, avgerr: real;
    obsIIVolume, simIIVolume, rainVolume, maxRain: array of real;
    //CCC 2010-2-18 - add statistic for total flow in ver 1.0.2
    obsVolume, simVolume: array of real;
    eventTotalR, rdiiEventTotalR, rError, peakError: array of real;
    //CCC 2010-2-18 - add statistic for total flow in ver 1.0.2
    totalFlowError, totalVolumeError: array of real;

    insiderEvents, decimalPlaces: integer;
    //kMax, kRecover, iAbstraction: real;
    //rm 2009-11-03 - implementing initial abstraction now in ver 1.0.1
    defaultR, defaultT, defaultK : array[0..2] of real;
    diurnal: diurnalCurves;
    holidays: daysArray;
    //rm 2009-10-30 - Version 1.0.1 accommodates areas in units other than acres
    conversionToAcres: double;
    //rm 2010-04-23
    volumeconversionfactor: double;
    //rm 2010-09-29
    kMax, kRec, kIni: array[0..2] of double;

    function isHoliday(date: TDateTime): boolean;
    function dayOfWeekIndex(date: TDateTime): integer;
    procedure UpdateDataBasedOnSelectedAnalysis;
    //procedure calculateSimulatedRDII_OldAndBusted();
    procedure calculateSimulatedRDII();
    //procedure calculateSimulatedRDII_old();
    procedure OutputStatsToDialog;

    //rm 2010-04-23
    function GetVolumeConversionFactr(sFlowUnitLabel: string): double;

  public
    {this are public so that the obs vs. sim plot can use them}
    events: TStormEventCollection;
    obsIIPeak, simIIPeak, obsPeak, simPeak : array of real;
    allstandarderror: real;
    flowUnitLabel: string;
  end;

var
  frmComparisonSummary: TfrmComparisonSummary;

implementation

uses rdiiutils, obsvssim, mainform;
{$R *.DFM}

procedure TfrmComparisonSummary.UpdateDataBasedOnSelectedAnalysis;
  //rm 2010-04-21 testing - perhaps fixing some slack in datetimes that may throw things off
  //round dates to nearest minute by multiplying by 1440, rounding, and then dividing by 1440
//  SELECT CDbl(DateTime), Round(1440*DateTime), Round(1440*DateTime)/1440, CDate(Round(1440*DateTime)/1440),
//  (CDbl(DateTime) - Round(1440*DateTime)/1440) from flows
//  where abs(CDbl(DateTime) - Round(1440*DateTime)/1440) > 0
const
  conversionFromAcreInchesPerHourToMGD = (43560.0*7.481*24.0)/(12.0*1000000.0);
var
  i, j, k, numEvents, startIndex, endIndex, eventIndex, dow: integer;
  flowStartDateTime, flowEndDateTime: TDateTime;
  hour, minute, second, ms: word;
  fbww, fgwi, sumerror, sse, err, iidepth, rdiiDepth: real;
  weekdayDWF, weekendDWF: THydrograph;
  analysisName, queryStr: string;
  recSet: _RecordSet;
  test1, test2: single;
begin
  Screen.Cursor := crHourglass;
  analysisName := AnalysisNameComboBox.Text;
  analysis := DatabaseModule.GetAnalysis(analysisName);
  analysisID := analysis.analysisID;
  meterID := analysis.flowMeterID;
  raingaugeID := analysis.raingaugeID;

  area := DatabaseModule.GetAreaForAnalysis(analysisName);
  //rm 2009-10-30 - Version 1.0.1 accommodates areas in units other than acres
  //convert to acres for puposes of calculations
  //but remember to convert back for display purposes using new AreaUnitLabel
  conversionToAcres := DatabaseModule.GetConversionToAcresForMeter('',meterID);
  area := area * conversionToAcres;

  flowMeterName := DatabaseModule.GetFlowMeterNameForAnalysis(analysisName);
  raingaugeName := DatabaseModule.GetRaingaugeNameForAnalysis(analysisName);
  minbwwf := DatabaseModule.GetBaseFlowRateForAnalysis(analysisName);
  rdeltime := DatabaseModule.GetRainfallTimestep(raingaugeID);
  conversionToMGD := DatabaseModule.GetConversionForMeter(meterID);
  decimalPlaces := DatabaseModule. GetRainfallDecimalPlacesForRaingauge(raingaugeName);
{//rm 2010-10-07
  kRecover := analysis.RateOfReduction;
  kMax := analysis.MaxDepressionStorage;
  //rm 2009-11-03 - iAbstraction was left out -
  iAbstraction := analysis.InitialDepressionStorage;
  //rm 2010-09-29 - for now the default kMax, kRec and kIni are 0 for RTKs 2 and 3
  kMax2 := 0;
  kMax3 := 0;
  kRec2 := 0;
  kRec3 := 0;
  kIni2 := 0;
  kIni3 := 0;
  //rm
}
  //rm 2010-10-07
  for i := 0 to 2 do begin
    kMax[i] := analysis.MaxDepressionStorage[i];
    kRec[i] := analysis.RateOfReduction[i];
    kIni[i] := analysis.InitialDepressionStorage[i];
  end;
  for i := 0 to 2 do begin
    defaultR[i] := analysis.DefaultR[i];
    defaultT[i] := analysis.DefaultT[i];
    defaultK[i] := analysis.DefaultK[i];
  end;

  queryStr := 'SELECT StartDateTime, EndDateTime, TimeStep, Area FROM Meters ' +
           'WHERE (MeterID = ' + inttostr(meterID) + ');';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
  flowStartDateTime := recSet.Fields.Item[0].Value;
  flowEndDateTime := recSet.Fields.Item[1].Value;
  startDay := trunc(flowStartDateTime);
  endDay := trunc(flowEndDateTime) + 1;
  days := endDay - startDay;
  timestep := recSet.Fields.Item[2].Value;
  //rm 2009-10-30 - we already have the area ????
  //area := recSet.Fields.Item[3].Value;
  recSet.Close;

  segmentsPerDay := 1440 div timeStep;
  totalSegments := days * segmentsPerDay;
  timestepsToAverage := round(analysis.runningAverageDuration*60/timestep);

  SetLength(rainfall,totalSegments);
  SetLength(rdiiCurve,3,totalSegments);
  SetLength(rdiiTotal,totalSegments);
(* Get the conversion rates for the flow and rain values *)
  conversionToMGD := DatabaseModule.GetConversionForMeter(meterID);
  conversionToInches := DatabaseModule.GetConversionForRaingauge(raingaugeID);
{ get rainfall data }
  for i := 0 to totalSegments - 1 do rainfall[i] := 0.0;

  queryStr := 'SELECT DateTime, Volume FROM Rainfall WHERE ' +
              '((RaingaugeID = ' + inttostr(raingaugeID) + ') AND ' +
              '(DateTime >= ' + floattostr(flowStartDateTime) + ' AND ' +
              'DateTime <= ' + floattostr(flowEndDateTime) + ')) order by DateTime;';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash from empty recordset
  if recSet.EOF then
  else
    recSet.MoveFirst;
  while (not recSet.EOF) do begin
    timestamp := recSet.Fields.Item[0].Value;
    rtimestamp := DateTimeToTimeStamp(timestamp);
    i := (trunc(timestamp) - startday) * segmentsPerDay;
    i := i + trunc((rtimestamp.time / MSecsPerDay) * segmentsPerDay);
    rainfall[i] := recSet.Fields.Item[1].Value;
    recSet.MoveNext;
  end;
  recSet.Close;

  events := DatabaseModule.GetEvents(analysisID);
  numEvents := events.count;
  if (numEvents > 0) then begin
    gwiAdjustments := DatabaseModule.GetGWIAdjustments(analysisID);
{
      MemoDebug.Lines.Clear;
      for i := 0 to gwiAdjustments.Count - 1 do  begin
            MemoDebug.Lines.Add(Inttostr(i) + ' ' + FormatDateTime('MM/DD/YYYY',gwiAdjustments.DateNum(i)) + ' ' + FormatFloat('0.0000',gwiAdjustments.AdjustmentNum(i)));
      end;
      MemoDebug.visible := true;
}
    flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
    rainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(raingaugeName);
    volumeUnitLabel := DatabaseModule.GetFlowVolumeLabelForMeter(flowMeterName);

    //rm 2010-04-23
    volumeconversionfactor := GetVolumeConversionFactr(flowUnitLabel);

    weekdayDWF := DatabaseModule.GetWeekdayDWF(meterID);
    weekendDWF := DatabaseModule.GetWeekendDWF(meterID);
    minWeekdayDWFIndex := weekdayDWF.indexOfMinimum;
    minWeekendDWFIndex := weekdayDWF.indexOfMinimum;
    weekdayDWFMinimum := weekdayDWF.Minimum;
    weekendDWFMinimum := weekendDWF.Minimum;
    weekdayDWF.Free;
    weekendDWF.Free;

    diurnal := DatabaseModule.GetDiurnalCurves(analysisName);

    {configure the dialog controls}
    eventSpinEdit.Value := 1;
    eventSpinEdit.Enabled := true;
    saveToCSVFileButton.Enabled := true;
    eventSpinEdit.MaxValue := events.count;
    {initialize the arrays holding event data}
    SetLength(obsIIVolume,numEvents);
    SetLength(simIIVolume,numEvents);
    SetLength(obsIIPeak,numEvents);
    SetLength(simIIPeak,numEvents);
    {CCC 2010/02/18 - ver 1.0.2 - adding ObsPeak,SimPeak,ObsVolume,SimVolume}
    SetLength(obsVolume,numEvents);
    SetLength(simVolume,numEvents);
    SetLength(obsPeak,numEvents);
    SetLength(simPeak,numEvents);
    {end}
    SetLength(rainVolume,numEvents);
    SetLength(maxRain,numEvents);
    SetLength(eventTotalR,numEvents);
    SetLength(rdiiEventTotalR,numEvents);
    SetLength(rError,numEvents);
    SetLength(peakError,numEvents);
    SetLength(totalFlowError,numEvents);
    SetLength(totalVolumeError,numEvents);
    {initialize the RTK values}
    //rm 2010-10-15 - why are we doing this????
    {
    for i := 0 to numEvents - 1 do begin
      with TStormEvent(events[i]) do begin
        if (R[0] = 0) then begin
          for j := 0 to 2 do begin
            R[j] := analysis.defaultR[j];
            T[j] := analysis.defaultT[j];
            K[j] := analysis.defaultK[j];
          end;
        end;
      end;
    end;
    }
    {calculate the simulated RDII arrays}
    calculateSimulatedRDII();
//    calculateSimulatedRDII_OldAndBusted();
    {for each event determine observed and simulated II statistics}

    for eventIndex := 0 to numEvents - 1 do begin
      event := events[eventIndex];
      rainVolume[eventIndex] := DatabaseModule.RainfallTotalForRaingaugeBetweenDates(raingaugeID,event.StartDate,event.EndDate);
      observedFlowHydrograph := DatabaseModule.ObservedFlowBetweenDateTimes(meterID,event.startDate,event.EndDate);
      DatabaseModule.GetExtremeRainfallDateTimesBetweenDates(raingaugeID,
                                                             event.startDate,
                                                             event.endDate,
                                                             rainStartDate,
                                                             rainEndDate);
      maxRain[eventIndex] := DatabaseModule.GetMaximumRainfallBetweenDates(raingaugeID,event.startDate,event.endDate);

      iiHydrograph := observedFlowHydrograph.copyEmpty;
      rdiiHydrograph := observedFlowHydrograph.copyEmpty;
      //CCC 2010-02-18 ver 1.0.2
      simulatedFlowHydrograph := observedFlowHydrograph.copyEmpty;

      {OBSERVED RDII CALCULATIONS}
      for j := 0 to observedFlowHydrograph.size - 1 do begin
        timestamp := event.StartDate + (j / segmentsPerDay);
        DecodeTime(timestamp,hour,minute,second,ms);
        fgwi := gwiAdjustments.AdjustmentAt(timestamp);
        k := trunc((hour + (minute / 60.0)) / 24 * segmentsPerDay);
        dow := dayOfWeekIndex(timestamp);
        fbww := diurnal[dow,k];
        iiHydrograph.flows[j] := observedFlowHydrograph.flows[j]-fbww-fgwi;
      end;
      obsIIVolume[eventIndex] := iiHydrograph.volume;
      obsIIPeak[eventIndex] := iiHydrograph.runningAverageMaximum(timestepsToAverage);
      //CCC 2010-02-18 ver 1.0.2  ObsPeak
      obsPeak[eventIndex] := observedFlowHydrograph.runningAverageMaximum(timestepsToAverage);
      obsVolume[eventIndex] := observedFlowHydrograph.volume * volumeconversionfactor;
      {SIMULATED RDII CALCULATIONS}
      startIndex := round((event.startDate - startDay) * segmentsPerDay);
      endIndex := round((event.endDate - startDay) * segmentsPerDay);
      for j := startIndex to endIndex do begin
        rdiiHydrograph.flows[j-startIndex] := rdiitotal[j];
      end;
      //CCC 2010-02-18 ver 1.0.2 TotalFlow
      {Total SIMULATED FLOW HYDROGRAPH CALCULATIONS - RDII Flow + fbww + fgwi}
      for j := 0 to simulatedFlowHydrograph.size - 1 do begin
        timestamp := event.StartDate + (j / segmentsPerDay);
        DecodeTime(timestamp,hour,minute,second,ms);
        fgwi := gwiAdjustments.AdjustmentAt(timestamp);
        k := trunc((hour + (minute / 60.0)) / 24 * segmentsPerDay);
        dow := dayOfWeekIndex(timestamp);
        fbww := diurnal[dow,k];
        simulatedFlowHydrograph.flows[j] := rdiiHydrograph.flows[j]+fbww+fgwi;
      end;

      simIIVolume[eventIndex] := rdiiHydrograph.volume;
      simIIPeak[eventIndex] := rdiiHydrograph.runningAverageMaximum(timestepsToAverage);

      //CCC 2010-02-18 ver 1.0.2 TotalFlow
      simVolume[eventIndex] := simulatedFlowHydrograph.volume * volumeconversionfactor;
      simPeak[eventIndex] := simulatedFlowHydrograph.runningAverageMaximum(timestepsToAverage);




      iiHydrograph.Free;
      rdiiHydrograph.Free;
      simulatedFlowHydrograph.Free;

    end;

    sumerror := 0.0;
    sse := 0.0;
    for eventIndex := 0 to numEvents - 1 do begin
      err := simIIPeak[eventIndex] - obsIIPeak[eventIndex];
      sumerror := sumerror + err;
      sse := sse + err*err;
    end;
    allavgerr := sumerror/numEvents;
    if (numEvents > 1)
      then allstandardError := sqrt(sse/(numEvents - 1))
      else allstandardError := 0.0;

    sumerror := 0.0;
    sse := 0.0;
    insiderEvents := 0;
    for eventIndex := 0 to numEvents - 1 do begin
      err := simIIPeak[eventIndex] - obsIIPeak[eventIndex];
      if (abs(err) < allstandarderror) then begin
        inc(insiderEvents);
        sumerror := sumerror + err;
        sse := sse + err*err;
      end;
    end;
    //rm 2010-04-21 - bombs here if numEvents = 1?? definitely bombs if insiderEvents = 0!
    //avgerr := sumerror/insiderEvents;
    //if (insiderEvents > 1)
    //  then standardError := sqrt(sse/(insiderEvents - 1))
    //  else standardError := 0.0;
    if (insiderEvents > 1) then begin
      standardError := sqrt(sse/(insiderEvents - 1));
      avgerr := sumerror/insiderEvents;
    end else begin
      standardError := 0.0;
      //rm 2010-04-21 - TODO - figure out what to do with avgerr if insiderEvents = 0
      avgerr := sumerror;
    end;

    for eventIndex := 0 to numEvents - 1 do begin
      if (rainVolume[eventIndex] > 0.0) then begin
        iiDepth := obsIIVolume[eventIndex]*conversionToMGD*12.0/(area*43560.0)*1000000.0/7.481/conversionToInches;
        eventTotalR[eventIndex] := iiDepth / rainVolume[eventIndex];
        rdiiDepth := simIIVolume[eventIndex]*conversionToMGD*12.0/(area*43560.0)*1000000.0/7.481/conversionToInches;
        //rm 2010-02-09 - the simIIVolume takes into account Initial Abstraction
        //the rainvolume[] does not.
        //so you will get a lower total R than the sum of your R1, R2, and R3
        //if you are using initial abstraction
        rdiiEventTotalR[eventIndex] := rdiiDepth / rainVolume[eventIndex];
      end
      else begin
        eventTotalR[eventIndex] := 0.0;
        rdiiEventTotalR[eventIndex] := 0.0;
      end;
      if (eventTotalR[eventIndex] > 0.0)
        then rError[eventIndex] := (rdiiEventTotalR[eventIndex] - eventTotalR[eventIndex]) / eventTotalR[eventIndex] * 100.0
        else rError[eventIndex] := 0.0;
      if (obsIIPeak[eventIndex] > 0.0)
        then peakError[eventIndex] := (simIIPeak[eventIndex] - obsIIPeak[eventIndex]) / obsIIPeak[eventIndex] * 100.0
        else peakError[eventIndex] := 0.0;
      if (obsVolume[eventIndex] > 0.0)
        then totalVolumeError[eventIndex] := (simVolume[eventIndex] - obsVolume[eventIndex]) / obsVolume[eventIndex] * 100.0
        else totalVolumeError[eventIndex] := 0.0;
      if (obsPeak[eventIndex] > 0.0)
        then totalFlowError[eventIndex] := (simPeak[eventIndex] - obsPeak[eventIndex]) / obsPeak[eventIndex] * 100.0
        else totalFlowError[eventIndex] := 0.0;


    end;

    SummaryMemo.Clear;
    SummaryMemo.Lines.Add('Statistics for all '+inttostr(numEvents)+' events');
    SummaryMemo.Lines.Add('Average error  = '+floattostrF(allavgerr,ffFixed,15,3)+' '+flowUnitLabel);
    SummaryMemo.Lines.Add('Standard error = '+floattostrF(allstandarderror,ffFixed,15,3)+' '+flowUnitLabel);
    SummaryMemo.Lines.Add('');
    if (insiderEvents < 2) then begin
      SummaryMemo.Lines.Add('There are not enough events after eliminating outliers to');
      SummaryMemo.Lines.Add('compute peak flow statistics.');
    end
    else begin
      SummaryMemo.Lines.Add('Statistics for '+inttostr(insiderEvents)+' events determined to not be outliers');
      SummaryMemo.Lines.Add('Outliers are identified as those events whose error is greater');
      SummaryMemo.Lines.Add('than one standard error');
      SummaryMemo.Lines.Add('Average error  = '+floattostrF(avgerr,ffFixed,15,3)+' '+flowUnitLabel);
      SummaryMemo.Lines.Add('Standard error = '+floattostrF(standarderror,ffFixed,15,3)+' '+flowUnitLabel);
    end;

    event := events[eventSpinEdit.Value - 1];
    OutputStatsToDialog;
  end
  else begin
    eventSpinEdit.Enabled := false;
    saveToCSVFileButton.Enabled := false;
    StatisticsMemo.Lines.Clear;
  end;

  Screen.Cursor := crDefault;
end;

// CCC - 02/18/2010 - version 1.0.2
// Add Statistic on Total Flow Comparison: peak and volume
procedure TfrmComparisonSummary.OutputStatsToDialog;
var
  i, eventIndex: integer;
begin
  eventIndex := eventSpinEdit.Value - 1;
  event := events[eventIndex];
  StatisticsMemo.Lines.Clear;
  StatisticsMemo.Lines.Add('Event Number          = '+inttostr(eventIndex+1));
  StatisticsMemo.Lines.Add('Start Date & Hour     = '+datetostr(event.StartDate)+ ' ' +timetostr(event.StartDate));
  StatisticsMemo.Lines.Add('End Date & Hour       = '+datetostr(event.EndDate)+ ' ' +timetostr(event.EndDate));
{  StatisticsMemo.Lines.Add('Start Date & Hour     = '+datetostr(event.StartDate)+ ' ' +floattostrF(frac(event.StartDate)*24,ffFixed,8,2));
  StatisticsMemo.Lines.Add('End Date & Hour       = '+datetostr(event.EndDate)+ ' ' +floattostrF(frac(event.EndDate)*24,ffFixed,8,2));  }
  StatisticsMemo.Lines.Add('Duration              = '+floattostrF(event.duration*24,ffFixed,8,2)+ ' Hours');
  StatisticsMemo.Lines.Add('');
  StatisticsMemo.Lines.Add('Curve Number        R  T(hours)       K');
  for i := 0 to 2 do begin
    StatisticsMemo.Lines.Add('         '+inttostr(i+1)+'    '+
      floattostrF(event.R[i],ffFixed,15,5)+'       '+
      floattostrF(event.T[i],ffFixed,15,1)+'     '+
      floattostrF(event.K[i],ffFixed,15,1));
  end;
  StatisticsMemo.Lines.Add('');
  StatisticsMemo.Lines.Add('Event Rainfall Volume = '+floattostrF(rainVolume[eventIndex],ffFixed,8,decimalPlaces)+' '+rainUnitLabel);
  StatisticsMemo.Lines.Add('Max '+inttostr(rdeltime)+' Minute Rain    = '+floattostrF(maxRain[eventIndex],ffFixed,8,decimalPlaces)+' '+rainUnitLabel);
  StatisticsMemo.Lines.Add('');
  StatisticsMemo.Lines.Add('                                      Observed     Simulated   % Difference');
//CCC 02/18/2010 - version 1.0.2
//  StatisticsMemo.Lines.Add('Total Event Volume (Gallon)            ' +
  StatisticsMemo.Lines.Add('Total Event Volume (' + volumeUnitLabel + ')' +
                            leftPad(floattostrF(ObsVolume[eventIndex],ffFixed,15,3),25-length(volumeUnitLabel)) + ' ' +
                            leftPad(floattostrF(SimVolume[eventIndex],ffFixed,15,3),13) + ' ' +
                            leftPad(floattostrF(totalVolumeError[eventIndex],ffFixed,10,1),11));

  StatisticsMemo.Lines.Add('Peak Total Flow Rate ('+flowUnitLabel+')' +
                           leftPad(floattostrF(obsPeak[eventIndex],ffFixed,15,3),(23-length(flowUnitLabel))) + ' ' +
                           leftPad(floattostrF(simPeak[eventIndex],ffFixed,15,3),13) + ' ' +
                           leftPad(floattostrF(totalFlowError[eventIndex],ffFixed,15,1),11));

  StatisticsMemo.Lines.Add('Total Event I/I Volume (Total R)' +
                            leftPad(floattostrF(eventTotalR[eventIndex],ffFixed,15,3),14) + ' ' +
                            leftPad(floattostrF(rdiiEventTotalR[eventIndex],ffFixed,15,3),13) + ' ' +
                            leftPad(floattostrF(rError[eventIndex],ffFixed,15,1),11));
  StatisticsMemo.Lines.Add('Peak I/I Flow Rate ('+flowUnitLabel+')'+
                           leftPad(floattostrF(obsIIPeak[eventIndex],ffFixed,15,3),(25-length(flowUnitLabel))) + ' ' +
                           leftPad(floattostrF(simIIPeak[eventIndex],ffFixed,15,3),13) + ' ' +
                           leftPad(floattostrF(peakError[eventIndex],ffFixed,15,1),11));
  StatisticsMemo.Lines.Add('');
  if (abs(simIIPeak[eventIndex] - obsIIPeak[eventIndex]) < allstandardError)
    then StatisticsMemo.Lines.Add('This event is not a peak flow outlier.')
    else StatisticsMemo.Lines.Add('This event is a peak flow outlier.');
end;

(*
procedure TfrmComparisonSummary.calculateSimulatedRDII_OldAndBusted();
const
  conversionFromAcreInchesPerHourToMGD = (43560.0*7.481*24.0)/(12.0*1000000.0);
var
  i, j, m, n, index, timestepsPerHour : integer;
  day, qpeak, flow, rain, prevRainDate, abstraction, excess: real;
  event: TStormEvent;
  R,T,K : array[0..2] of real;
begin
  { DETERMINE SIMULATED RDII }
  //rm 2009-10-30 - This does not implement initial abstraction the way RDII graph does
  for i := 0 to totalSegments - 1 do begin
    for j := 0 to 2 do begin
      rdiiCurve[j,i] := 0.0;
      rdiiCurve[j,i] := 0.0;
      rdiiCurve[j,i] := 0.0;
    end;
  end;
  timestepsPerHour := 60 div timestep;
  abstraction := analysis.InitialDepressionStorage;
  prevRainDate := 0;
  for i := 0 to days - 1 do begin
    for j := 0 to segmentsPerDay - 1 do begin
      index := (i * segmentsPerDay) + j;
      rain := rainfall[index];
      if (rain > 0) then begin
        for m := 0 to 2 do begin
          R[m] := analysis.defaultR[m];
          T[m] := analysis.defaultT[m];
          K[m] := analysis.defaultK[m];
        end;
        day := (startDay + i) + (j / segmentsPerDay);
        for m := 0 to events.count - 1 do begin
          event := events.Items[m];
          if ((day >= event.startDate) and (day <= event.endDate)) then begin
            if (event.R[0] > 0.0) then
              for n := 0 to 2 do begin
                R[n] := event.R[n];
                T[n] := event.T[n];
                K[n] := event.K[n];
              end;
          end;
        end;
        abstraction := min(kmax,(abstraction+krecover*(day-prevRainDate-timestep/(24.0*60.0))));
        abstraction := max(abstraction,0.0);
        prevRainDate := day;
        excess := max(rain-abstraction,0.0);
        abstraction := abstraction-(rain-excess);
        if (excess > 0.0) then begin
          for m := 0 to 2 do begin
            if ((R[m] > 0.0) and (T[m] > 0.0)) then begin
              qpeak := R[m]*2.0*area/(T[m]*(1+K[m]))
                       *conversionFromAcreInchesPerHourToMGD
                       /conversionToMGD
                       *conversionToInches;
              for n := 0 to trunc(T[m] * (K[m] + 1) * timestepsPerHour) do begin
                if (index + n < totalSegments) then begin
                  if (n <= T[m] * timestepsPerHour)
                    then flow := (n / (T[m] * timestepsPerHour)) * qpeak * excess
                    else flow := (1.0 - ((n-(T[m]*timestepsPerHour) )/(K[m]*T[m]*timestepsPerHour))) * qpeak * excess;
                  rdiiCurve[m,index+n] := rdiiCurve[m,index+n] + flow;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  for i := 0 to totalSegments - 1 do
    rdiiTotal[i] := rdiiCurve[0,i] + rdiiCurve[1,i] + rdiiCurve[2,i];
end;
*)

procedure TfrmComparisonSummary.calculateSimulatedRDII();
//re-jigged by rm on 2007-11-01
//set abstraction calculations to match SWMM5
//challenge was to set initial abstraction used term only once at start of a defined event
//and then to set initial abstractiion used back to analysis default at end of defined event
//You can't just set all parameters to analysis defaults and then check to see if you are
// in an event because then you would be setting the initial term at every timestep
//So you have to use some state variables that let you know
//  a) exactly when you have entered an event, and
//  b) exactly when you have exited and are no longer in any event
//
//In a) you set abstraction_used to the event initial value
//  (unless current abstraction_used is higher)
//In b) you set abstraction_used to the analysis default value
//  (unless current abstraction_used is higher)
//
//rm 2010-09-29 rejigged again to accommodate initial abstraction terms for each of the 3 RTK sets
const
  conversionFromAcreInchesPerHourToMGD = (43560.0*7.481*24.0)/(12.0*1000000.0);
var
  i, j, m, n, index, timestepsPerHour, oldEventNum, inEventNum, lastEventNum : integer;
  day, qpeak, flow, rain, {prevRainDate, abstraction,} {absmax, absrecover,} excess: double;
  //rm 2007-11-01 - Fix for the initial abstraction issue
  //absmax, absrecover,abstraction_available, abstraction_used: double;
  event: TStormEvent;
  R,T,K : array[0..2] of real;
  //rm 2010-09-29
  AM, AR, AI, AA, AU : array[0..2] of double; //Abstraction Max, Recover, Init, and Used
{
  F: textfile;   }
begin
{
  assignfile(F,'c:\wincalc.txt');
  rewrite(F);
}

  { DETERMINE SIMULATED RDII }
  for i := 0 to totalSegments - 1 do begin
    for j := 0 to 2 do begin
      rdiiCurve[j,i] := 0.0;
    end;
  end;
  timestepsPerHour := 60 div timestep;
//rm 2007-11-01
//  abstraction := iabstraction;
//  prevRainDate := 0;
  for n := 0 to 2 do begin
    R[n] := defaultR[n];
    T[n] := defaultT[n];
    K[n] := defaultK[n];
  end;
  //rm 2010-09-29 - REFACTORing Initial Abstraction Terms
  // absmax => AM[0..2]
  // absrecover => AR[0..2]
  // iabstraction => AI[0..2]
  // abstraction_available => AA[0..2]
  // abstraction_used => AU[0..2]
  {
  absmax := kmax;             //default analysis kmax
  absrecover := krecover;     //default analysis krecover
  abstraction_available := absmax - iabstraction;    //default analysis iabstraction
  abstraction_available := max(abstraction_available, 0.0);
  abstraction_used := absmax - abstraction_available;
  }
  {
  AM[0] := kmax;         //default read from Analysis table
  AR[0] := krecover;     //default read from Analysis table
  AI[0] := iabstraction; //default read from Analysis table
  AM[1] := kMax2;
  AR[1] := kRec2;
  AI[1] := kIni2;
  AM[2] := kMax3;
  AR[2] := kRec3;
  AI[2] := kIni3;
  AU[0] := 0;
  AU[1] := 0;
  AU[2] := 0;
  }
  for n := 0 to 2 do begin
    AM[n] := kmax[n]; //default read from Analysis table
    AR[n] := krec[n]; //default read from Analysis table
    AI[n] := kini[n]; //default read from Analysis table
    AU[n] := AI[n]; //0;
  end;

  oldEventNum := -1; //set to current eventnum upon entering an event
  inEventNum := -1; //set back to -1 upon leaving an event
  lastEventNum := inEventNum;  //tracks changes in inEventNum
  for i := 0 to days - 1 do begin
    for j := 0 to segmentsPerDay - 1 do begin
      index := (i * segmentsPerDay) + j;
//rm 2007-11-01 Moved "for m" block up above "if (rain > 0)" block due to initial abstraction terms
      day := (startDay + i) + (j / segmentsPerDay);
      { determine the RTK values at this instant }
      inEventNum := -1;  //reset inEventNum, but not lastEventNum
      for m := 0 to events.count - 1 do begin
        event := events.Items[m];
        if ((day >= event.startDate) and (day <= event.endDate)) then begin
        //we are in an event - update parameters
          inEventNum := m;
          lastEventNum := inEventNum;
          //only need to set these once - first time we are in event
          //need to do this only once or initial depth will get reset every time
          if m > oldEventNum then begin //first time to this event
//writeln(F, 'Starting Event Num ', IntToStr(m), ' on ', floattostrF(day,ffFixed,15,5));
            oldEventNum := m;
            if ((event.R[0] > 0.0) or (event.R[1] > 0.0) or (event.R[2] > 0.0)) then begin
            //if any R is > 0, then assume user has assigned parameters for this event
              for n := 0 to 2 do begin
                R[n] := event.R[n];
                T[n] := event.T[n];
                K[n] := event.K[n];
              //end;
              {
              absmax := event.AM;
              absrecover := event.AR;
              abstraction_used := max(abstraction_used, event.AI);
              }
              //for n := 0 to 2 do  begin
                AM[n] := event.AM[n+1];
                AR[n] := event.AR[n+1];
                AI[n] := event.AI[n+1];
                //rm 2010-10-15 - when starting an event AU = AI
                AU[n] := AI[n]; //Max(AU[n], AI[n]);
              end;
            end else begin
            //if all Rs are 0, then perhaps user has not assigned parameters
            //for this event - set parameters to analysis defaults
              for n := 0 to 2 do begin
                R[n] := defaultR[n];
                T[n] := defaultT[n];
                K[n] := defaultK[n];
              end;
              {
              absmax := kmax;             //default analysis kmax
              absrecover := krecover;     //default analysis krecover
              abstraction_used := max(abstraction_used, iabstraction);
              }
              //rm 2010-10-07
              {
              AM[0] := kmax;         //default read from Analysis table
              AR[0] := krecover;     //default read from Analysis table
              AI[0] := iabstraction; //default read from Analysis table
              AU[0] := Max(AU[0], AI[0]);
              AM[1] := kMax2;
              AR[1] := kRec2;
              AI[1] := kIni2;
              AU[1] := Max(AU[1], AI[1]);
              AM[2] := kMax3;
              AR[2] := kRec3;
              AI[2] := kIni3;
              AU[2] := Max(AU[2], AI[2]);
              }
              for n := 0 to 2 do begin
                AM[n] := kmax[n];
                AR[n] := krec[n];
                AI[n] := kini[n];
                //rm 2010-10-15 - when starting an event AU = AI
                AU[n] := AI[n]; //Max(AU[n], AI[n]);
              end;

            end;
            {
            abstraction_available := absmax - abstraction_used;
            abstraction_available := max(abstraction_available, 0.0);
            abstraction_used := absmax - abstraction_available;
            }
            for n := 0 to 2 do begin
              AA[n] := AM[n] - AU[n];
              AA[n] := Max(AA[n], 0.0);
              AU[n] := AM[n] - AA[n];
            end;
          end; //if m > oldEventNum
          break; //don't need to check any more events -can't be in more than one
        end; //if ((day >= event.startDate) and (day <= event.endDate))
      end; //for m := 0 to events.count - 1
      if lastEventNum > inEventNum then begin //we just left an event and are no longer in one
//writeln(F, 'Leaving Event Num ', IntToStr(inEventNum), ' on ', floattostrF(day,ffFixed,15,5));
      //inEventNum is -1 if not in an event
      //lastEventNum is still the number of the last event if we just left an event
        lastEventNum := inEventNum;
        //for this non-event - set parameters to analysis defaults
        for n := 0 to 2 do begin
          R[n] := defaultR[n];
          T[n] := defaultT[n];
          K[n] := defaultK[n];
        end;
        {
        absmax := kmax;             //default analysis kmax
        absrecover := krecover;     //default analysis krecover
        abstraction_used := max(abstraction_used, iabstraction);
        abstraction_available := absmax - abstraction_used;
        abstraction_available := max(abstraction_available, 0.0);
        abstraction_used := absmax - abstraction_available;
        }
              {
              absmax := kmax;             //default analysis kmax
              absrecover := krecover;     //default analysis krecover
              abstraction_used := max(abstraction_used, iabstraction);
              }
              //rm 2010-10-07
              {
              AM[0] := kmax;         //default read from Analysis table
              AR[0] := krecover;     //default read from Analysis table
              AI[0] := iabstraction; //default read from Analysis table
              AM[1] := kMax2;
              AR[1] := kRec2;
              AI[1] := kIni2;
              AM[2] := kMax3;
              AR[2] := kRec3;
              AI[2] := kIni3;
              }
              for n := 0 to 2 do begin
                AM[n] := kmax[n];
                AR[n] := krec[n];
                //rm 2010-10-15 - do not reset initial AI[n] := kini[n];
                AU[n] := Max(AU[n], AI[n]);
                AA[n] := AM[n] - AU[n];
                AA[n] := Max(AA[n], 0.0);
                AU[n] := AM[n] - AA[n];
              end;
            //end;
      end;
      //done setting parameters - now process the rain
      rain := rainfall[index];
//rm 2007-11-01
//ia = UnitHyd[j].ia[m][IA_MAX] - UHData[j].iaUsed;
//ia = MAX(ia, 0.0);
      {
      abstraction_available := absmax - abstraction_used;
      abstraction_available := max(abstraction_available, 0.0);
      }
              for n := 0 to 2 do begin
                AA[n] := AM[n] - AU[n];
                AA[n] := Max(AA[n], 0.0);
                AU[n] := AM[n] - AA[n];
              end;
//rm 2010-09-29 - need to move the "m:=0..2" loop up here
  for m := 0 to 2 do begin
    if ((R[m] > 0.0) and (T[m] > 0.0)) then begin

      if (rain > 0) then begin
//        day := (startDay + i) + (j / segmentsPerDay);
//        if (prevRainDate = 0) then prevRainDate := day;
        {calculate each composite RDII curve at this instant}
//        abstraction := min(absmax,(abstraction+absrecover*(day-prevRainDate-timestep/(24.0*60.0))));
//        abstraction := max(abstraction,0.0);
//        prevRainDate := day;
//        excess := max(rain-abstraction,0.0);
//        abstraction := abstraction-(rain-excess);
// --- reduce rain depth by unused IA
//netRainDepth = rainDepth - ia;
//rm 2010-09-29        excess := rain - abstraction_available;
        excess := rain - AA[m]; //abstraction_available;
        excess := max(excess, 0.0);
//netRainDepth = MAX(netRainDepth, 0.0);
// --- update amount of IA used up
//ia = rainDepth - netRainDepth;
//rm 2010-09-29        abstraction_available := rain - excess; //additional volume added this timestep
        AA[m] := rain - excess; //additional volume added this timestep
//UHData[j].iaUsed += ia;
//rm 2010-09-29        abstraction_used := abstraction_used + abstraction_available;
        AU[m] := AU[m] + AA[m]; //abstraction_available;
//rm 2010-10-15 - left this bad boy out:
        AU[m] := min(AU[m], AM[m]);
//        abstraction_used := abstraction_used + rain - excess;
//        abstraction_used := min(abstraction_used, absmax);
{        writeln(F,'***  ',floattostrF(prevRainDate,ffFixed,15,5),'   '
                         ,floattostrF(abstraction,ffFixed,15,5),'   '
                         ,floattostrF(excess,ffFixed,15,5));   }
        if (excess > 0.0) then begin
//rm 2010-09-29          for m := 0 to 2 do begin
//rm 2010-09-29            if ((R[m] > 0.0) and (T[m] > 0.0)) then begin
              qpeak := R[m]*2.0*area/(T[m]*(1+K[m]))
                       *conversionFromAcreInchesPerHourToMGD
                       /conversionToMGD
                       *conversionToInches;
                       //rm 2009-10-29 Note that area has been converted to acres already if necessary
              for n := 0 to trunc(T[m] * (K[m] + 1) * timestepsPerHour) do begin
                if (index + n < totalSegments) then begin
                  if (n <= T[m] * timestepsPerHour)
                    then flow := (n / (T[m] * timestepsPerHour)) * qpeak * excess
                    else flow := (1.0 - ((n-(T[m]*timestepsPerHour) )/(K[m]*T[m]*timestepsPerHour))) * qpeak * excess;
                  rdiiCurve[m,index+n] := rdiiCurve[m,index+n] + flow;
                end;
              end;
//rm 2010-09-29            end;
//rm 2010-09-29          end;
        end; {if (excess > 0.0)}
      end {if (rain > 0)} else begin //no rain - recover some abstraction volume
// --- recover a portion of the IA already used
//UHData[j].iaUsed -= dt / 86400. * UnitHyd[j].ia[m][IA_REC];
//UHData[j].iaUsed = MAX(UHData[j].iaUsed, 0.0);
//rm 2010-09-29        abstraction_used := abstraction_used - ((timestep/1440.0) * absrecover);
        AU[m] := AU[m] - ((timestep/1440.0) * AR[m]);
//rm 2010-09-29        abstraction_used := max(abstraction_used, 0.0);
        AU[m] := max(AU[m], 0.0);
      end; {}
    end; {if ((R[m] > 0.0) and (T[m] > 0.0))}
  end; {for m := 0 to 2}
end; {for j := 0 to segmentsPerDay - 1}
end; {for i := 0 to days - 1}
  for i := 0 to totalSegments - 1 do
    rdiiTotal[i] := rdiiCurve[0,i] + rdiiCurve[1,i] + rdiiCurve[2,i];

{  for i := 0 to totalSegments - 1 do begin
    day := startDay + (i / segmentsPerDay);
    writeln(F,floattostrF(day,ffFixed,15,5),'   ',
              floattostrF(rdiiCurve[0,i],ffFixed,15,5),'   ',
              floattostrF(rdiiCurve[1,i],ffFixed,15,5),'   ',
              floattostrF(rdiiCurve[2,i],ffFixed,15,5));
  end;
}
{
closefile(F);
}
end;
(*
procedure TfrmComparisonSummary.calculateSimulatedRDII_old();
//re-jigged by rm on 2009-11-03 based on rejigging done in iigraph.pas on 2007-11-01
//set abstraction calculations to match SWMM5
//challenge was to set initial abstraction used term only once at start of a defined event
//and then to set initial abstractiion used back to analysis default at end of defined event
//You can't just set all parameters to analysis defaults and then check to see if you are
// in an event because then you would be setting the initial term at every timestep
//So you have to use some state variables that let you know
//  a) exactly when you have entered an event, and
//  b) exactly when you have exited and are no longer in any event
//
//In a) you set abstraction_used to the event initial value
//  (unless current abstraction_used is higher)
//In b) you set abstraction_used to the analysis default value
//  (unless current abstraction_used is higher)
//
const
  conversionFromAcreInchesPerHourToMGD = (43560.0*7.481*24.0)/(12.0*1000000.0);
var
  i, j, m, n, index, timestepsPerHour, oldEventNum, inEventNum, lastEventNum : integer;
  day, qpeak, flow, rain, absmax, absrecover, excess: double;
  abstraction_available, abstraction_used: double;
  event: TStormEvent;
  R,T,K : array[0..2] of real;
{  F: textfile;   }
begin
{  assignfile(f,'e:\wincalc.txt');
  rewrite(F);  }

  { DETERMINE SIMULATED RDII }
  for i := 0 to totalSegments - 1 do begin
    for j := 0 to 2 do begin
      rdiiCurve[j,i] := 0.0;
    end;
  end;
  timestepsPerHour := 60 div timestep;
  for n := 0 to 2 do begin
    R[n] := defaultR[n];
    T[n] := defaultT[n];
    K[n] := defaultK[n];
  end;
  absmax := kmax;             //default analysis kmax
  absrecover := krecover;     //default analysis krecover
  abstraction_available := absmax - iabstraction;    //default analysis iabstraction
  abstraction_available := max(abstraction_available, 0.0);
  abstraction_used := absmax - abstraction_available;
  oldEventNum := -1; //set to current eventnum upon entering an event
  inEventNum := -1; //set back to -1 upon leaving an event
  lastEventNum := inEventNum;  //tracks changes in inEventNum
  for i := 0 to days - 1 do begin
    for j := 0 to segmentsPerDay - 1 do begin
      index := (i * segmentsPerDay) + j;
//rm 2007-11-01 Moved "for m" block up above "if (rain > 0)" block due to initial abstraction terms
      day := (startDay + i) + (j / segmentsPerDay);
      { determine the RTK values at this instant }
      inEventNum := -1;  //reset inEventNum, but not lastEventNum
      for m := 0 to events.count - 1 do begin
        event := events.Items[m];
        if ((day >= event.startDate) and (day <= event.endDate)) then begin
        //we are in an event - update parameters
          inEventNum := m;
          lastEventNum := inEventNum;
          //only need to set these once - first time we are in event
          //need to do this only once or initial depth will get reset every time
          if m > oldEventNum then begin //first time to this event
            oldEventNum := m;
            if ((event.R[0] > 0.0) or (event.R[1] > 0.0) or (event.R[2] > 0.0)) then begin
            //if any R is > 0, then assume user has assigned parameters for this event
              for n := 0 to 2 do begin
                R[n] := event.R[n];
                T[n] := event.T[n];
                K[n] := event.K[n];
              end;
              absmax := event.AM[1];
              absrecover := event.AR[1];
              abstraction_used := max(abstraction_used, event.AI[1]);
            end else begin
            //if all Rs are 0, then perhaps user has not assigned parameters
            //for this event - set parameters to analysis defaults
              for n := 0 to 2 do begin
                R[n] := defaultR[n];
                T[n] := defaultT[n];
                K[n] := defaultK[n];
              end;
              absmax := kmax;             //default analysis kmax
              absrecover := krecover;     //default analysis krecover
              abstraction_used := max(abstraction_used, iabstraction);
            end;
            abstraction_available := absmax - abstraction_used;
            abstraction_available := max(abstraction_available, 0.0);
            abstraction_used := absmax - abstraction_available;
          end; //if m > oldEventNum
          break; //don't need to check any more events -can't be in more than one
        end; //if ((day >= event.startDate) and (day <= event.endDate))
      end; //for m := 0 to events.count - 1
      if lastEventNum > inEventNum then begin //we just left an event and are no longer in one
      //inEventNum is -1 if not in an event
      //lastEventNum is still the number of the last event if we just left an event
        lastEventNum := inEventNum;
        //for this non-event - set parameters to analysis defaults
        for n := 0 to 2 do begin
          R[n] := defaultR[n];
          T[n] := defaultT[n];
          K[n] := defaultK[n];
        end;
        absmax := kmax;             //default analysis kmax
        absrecover := krecover;     //default analysis krecover
        abstraction_used := max(abstraction_used, iabstraction);
        abstraction_available := absmax - abstraction_used;
        abstraction_available := max(abstraction_available, 0.0);
        abstraction_used := absmax - abstraction_available;
      end;
      //done setting parameters - now process the rain
      rain := rainfall[index];
//rm 2007-11-01
//ia = UnitHyd[j].ia[m][IA_MAX] - UHData[j].iaUsed;
//ia = MAX(ia, 0.0);
      abstraction_available := absmax - abstraction_used;
      abstraction_available := max(abstraction_available, 0.0);
      if (rain > 0) then begin
// --- reduce rain depth by unused IA
//netRainDepth = rainDepth - ia;
        excess := rain - abstraction_available;
        excess := max(excess, 0.0);
//netRainDepth = MAX(netRainDepth, 0.0);
// --- update amount of IA used up
//ia = rainDepth - netRainDepth;
        abstraction_available := rain - excess; //additional volume added this timestep
//UHData[j].iaUsed += ia;
        abstraction_used := abstraction_used + abstraction_available;
{        writeln(F,'***  ',floattostrF(prevRainDate,ffFixed,15,5),'   '
                         ,floattostrF(abstraction,ffFixed,15,5),'   '
                         ,floattostrF(excess,ffFixed,15,5));   }
        if (excess > 0.0) then begin
          for m := 0 to 2 do begin
            if ((R[m] > 0.0) and (T[m] > 0.0)) then begin
              qpeak := R[m]*2.0*area/(T[m]*(1+K[m]))
                       *conversionFromAcreInchesPerHourToMGD
                       /conversionToMGD
                       *conversionToInches;
                       //rm 2009-10-29 Note that area has been converted to acres already if necessary
              for n := 0 to trunc(T[m] * (K[m] + 1) * timestepsPerHour) do begin
                if (index + n < totalSegments) then begin
                  if (n <= T[m] * timestepsPerHour)
                    then flow := (n / (T[m] * timestepsPerHour)) * qpeak * excess
                    else flow := (1.0 - ((n-(T[m]*timestepsPerHour) )/(K[m]*T[m]*timestepsPerHour))) * qpeak * excess;
                  rdiiCurve[m,index+n] := rdiiCurve[m,index+n] + flow;
                end;
              end;
            end;
          end;
        end;
      end else begin //no rain - recover some abstraction volume
// --- recover a portion of the IA already used
//UHData[j].iaUsed -= dt / 86400. * UnitHyd[j].ia[m][IA_REC];
//UHData[j].iaUsed = MAX(UHData[j].iaUsed, 0.0);
        abstraction_used := abstraction_used - ((timestep/1440.0) * absrecover);
        abstraction_used := max(abstraction_used, 0.0);
      end;
    end;
  end;
  for i := 0 to totalSegments - 1 do
    rdiiTotal[i] := rdiiCurve[0,i] + rdiiCurve[1,i] + rdiiCurve[2,i];

{  for i := 0 to totalSegments - 1 do begin
    day := startDay + (i / segmentsPerDay);
    writeln(F,floattostrF(day,ffFixed,15,5),'   ',
              floattostrF(rdiiCurve[0,i],ffFixed,15,5),'   ',
              floattostrF(rdiiCurve[1,i],ffFixed,15,5),'   ',
              floattostrF(rdiiCurve[2,i],ffFixed,15,5));
  end;       }
{  closefile(F);  }
end;
*)
procedure TfrmComparisonSummary.AnalysisNameComboBoxChange(
  Sender: TObject);
begin
  UpdateDataBasedOnSelectedAnalysis;
end;

procedure TfrmComparisonSummary.EventSpinEditChange(Sender: TObject);
begin
  if (events.count > 0) then OutputStatsToDialog;
end;

procedure TfrmComparisonSummary.TimeStepsToAverageSpinEditChange(
  Sender: TObject);
begin
  if (events.count > 0) then UpdateDataBasedOnSelectedAnalysis;
end;

procedure TfrmComparisonSummary.closeButtonClick(Sender: TObject);
begin
//  Close;
  modalresult := mrCancel;
end;

procedure TfrmComparisonSummary.FormShow(Sender: TObject);
begin
  holidays := DatabaseModule.GetHolidays();
  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames();
  AnalysisNameComboBox.ItemIndex := 0;
  UpdateDataBasedOnSelectedAnalysis;
end;


function TfrmComparisonSummary.GetVolumeConversionFactr(
  sFlowUnitLabel: string): double;
var sTimeUnit: string;
begin
//rm 2010-04-23 - need a means of converting the THydrograph.volume from
//Flowunit-Days to something more meaningful
//(THydrograph.volume was written with only MGD in mind)
{
  if sFlowUnitLabel = 'CFS' then Result := 86400.0  //to CF
  else if sFlowUnitLabel = 'CMS' then Result := 86400.0  //to CM
  else if sFlowUnitLabel = 'GPM' then Result := 1440.0   //to Gal
  else if sFlowUnitLabel = 'LPS' then Result := 86400.0  //to L
  else if sFlowUnitLabel = 'MGD' then Result := 1.0      //to MG
  else if sFlowUnitLabel = 'MLD' then Result := 1.0      //to ML
  else Result := 1.0;
}
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

procedure TfrmComparisonSummary.saveToCSVFileButtonClick(Sender: TObject);
var
  i, numEvents, eventIndex: integer;
  F: textFile;
begin
  SaveStatsDialog.Filter := 'CSV Files|*.csv';
  SaveStatsDialog.DefaultExt := '.CSV';
  if (SaveStatsDialog.Execute) then begin
    Screen.Cursor := crHourglass;
    AssignFile(F,SaveStatsDialog.Filename);
    Rewrite(F);
    writeln(F,'"Comma Space Delimited, Flows are in ',flowUnitLabel,'"');
    writeln(F,'"Volumes are expressed as total R-value"');
{    if removenegs then writeln(newout,'"Note negative flows have been eliminated from observed I/I volumes.');  }
    write(F,'"event","event start","event end",');
    write(F,'"duration","r1","t1","k1","r2","t2","k2","r3","t3","k3",');
    write(F,'"rainfall volume","peak rainfall","obs. volume(R)",');
    write(F,'"sim. volume(R)","difference","percent dif","obs peak",');
    writeln(F,'"sim peak","difference","percent dif"');

    numEvents := events.count;
    for eventIndex := 0 to numEvents - 1 do begin
      event := events[eventIndex];

      write(F,eventIndex+1,',');
      write(F,dateTimeString(event.startDate),',');
      write(F,dateTimeString(event.endDate),',');
      write(F,floatToStrF(event.duration*24,ffFixed,15,2),',');
      for i := 0 to 2 do begin
        write(F,floattostrF(event.R[i],ffFixed,15,5),',',
                floattostrF(event.T[i],ffFixed,15,2),',',
                floattostrF(event.K[i],ffFixed,15,2),',');
      end;

      write(F,floattostrF(rainvolume[eventIndex],ffFixed,15,2),',');
      write(F,floattostrF(maxrain[eventIndex],ffFixed,15,2),',');

      write(F,floattostrF(eventTotalR[eventIndex],ffFixed,15,3),',');
      write(F,floattostrF(rdiiEventTotalR[eventIndex],ffFixed,15,3),',');
      write(F,floattostrF(rdiiEventTotalR[eventIndex]-eventTotalR[eventIndex],ffFixed,15,3),',');
      write(F,floattostrF(rError[eventIndex],ffFixed,15,1),',');

      write(F,floattostrF(obsIIPeak[eventIndex],ffFixed,15,3),',');
      write(F,floattostrF(simIIPeak[eventIndex],ffFixed,15,3),',');
      write(F,floattostrF(simIIPeak[eventIndex]-obsIIPeak[eventIndex],ffFixed,15,3),',');
      write(F,floattostrF(peakError[eventIndex],ffFixed,15,1));

      if (abs(simIIPeak[eventIndex] - obsIIPeak[eventIndex]) < allstandardError)
        then writeln(F)
        else writeln(F,',   *');
    end;
    writeln(F);
    writeln(F,'"Statistics comparing sim and obs peak I/I flow for all ',numEvents,' events"');
    writeln(F,'"Average error  = '+floattostrF(allavgerr,ffFixed,15,3),' ',flowUnitLabel,'"');
    writeln(F,'"Standard error = '+floattostrF(allstandarderror,ffFixed,15,3),' ',flowUnitLabel,'"');
    writeln(F);
    if (insiderEvents < 2) then begin
      writeln(F,'There are not enough events after eliminating outliers to');
      writeln(F,'compute peak flow statistics.');
    end
    else begin
      writeln(F,'"Stats for ',insiderEvents,' events excluding outliers"');
      writeln(F,'"Outliers are those events whose error in peak I/I flow is greater than"');
      writeln(F,'"one standard error identified by * in above table."');
      writeln(F,'"Average error  = '+floattostrF(avgerr,ffFixed,15,3),' ',flowUnitLabel,'"');
      writeln(F,'"Standard error = '+floattostrF(standarderror,ffFixed,15,3),' ',flowUnitLabel,'"');
    end;

    CloseFile(F);
    Screen.Cursor := crDefault;
    i := MessageDlg('Done exporting to ' + SaveStatsDialog.Filename + '.',
      mtInformation, [mbok],0);
  end;
end;

procedure TfrmComparisonSummary.Button1Click(Sender: TObject);
begin
   frmObsVsSimPlot.showModal;
end;

procedure TfrmComparisonSummary.Button2Click(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;


function TfrmComparisonSummary.isHoliday(date: TDateTime): boolean;
var
  i: integer;
begin
  isHoliday := false;
  for i := 0 to length(holidays) - 1 do begin
    if (trunc(date) = holidays[i]) then isHoliday := true;
  end;
end;

function TfrmComparisonSummary.dayOfWeekIndex(date: TDateTime): integer;
(* returns day of week 0 = sun, 1 = mon, 2 = tues..... 6 = saturday *)
(* holidays are returned as 7 *)
var
  dow: integer;
begin
  dow := dayofweek(date) - 1;
  if (isholiday(date)) then dow := 7;
  dayOfWeekIndex := dow;
end;


procedure TfrmComparisonSummary.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Finalize(holidays);
end;


end.
