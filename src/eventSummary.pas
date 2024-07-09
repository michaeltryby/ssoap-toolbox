unit eventSummary;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, GWIAdjustmentCollection, StormEventCollection, Hydrograph, Spin,
  StormEvent, moddatabase, Analysis, StrUtils;

type
  TfrmEventStatisitics = class(TForm)
    AnalysisNameComboBox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    StatisticsMemo: TMemo;
    closeButton: TButton;
    EventSpinEdit: TSpinEdit;
    saveToTextFileButton: TButton;
    SaveStatsDialog: TSaveDialog;
    saveToCSVFileButton: TButton;
    Button1: TButton;

    procedure closeButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AnalysisNameComboBoxChange(Sender: TObject);
    procedure EventSpinEditChange(Sender: TObject);
    procedure saveToTextFileButtonClick(Sender: TObject);
    procedure saveToCSVFileButtonClick(Sender: TObject);
    procedure TimeStepsToAverageSpinEditChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private { Private declarations }
    analysis: TAnalysis;
    holidays: daysArray;
    events: TStormEventCollection;
    area, iiVolume, iiDepth, rainVolume, eventTotalR, maxRain: real;
    analysisID, raingaugeID, meterID, timestep, segmentsPerDay: integer;
    raingaugeName, flowMeterName, flowUnitLabel, rainUnitLabel, volumeUnitLabel: string;
    gwiAdjustments: TGWIAdjustmentCollection;
    minWeekdayDWFIndex, minWeekendDWFIndex, rdeltime: integer;
    weekdayDWFMinimum, weekendDWFMinimum, avggwi, avgbwwf, minbwwf: real;
    event: TStormEvent;
    rainStartDate, rainEndDate: TDateTime;
    runningAverageDuration: real;
    timestepsToAverage: integer;
    conversionToMGD, conversionToInches: real;
    peakObservedFlow, averageObservedFlow, peakIIFlow, peakfctr, peakwwf, fbwwsum: real;
    diurnal: diurnalCurves;
    decimalPlaces: integer;
    //rm 2009-10-30 - two new variable to accommodate area units other than acres
    areaUnitLabel: string;
    conversionToAcres: double;
    //rm 2010-04-23
    volumeconversionfactor: double;
    //rm 2010-10-20
    sewerlength, RDIIperLF, RDIIgalperLF, RDIIcfperLF: double;
    function isHoliday(date: TDateTime): boolean;
    function dayOfWeekIndex(date: TDateTime): integer;
    procedure UpdateDataBasedOnSelectedAnalysis;
    procedure UpdateDataBasedOnSelectedEvent;
    procedure OutputStatsToDialog;

    //rm 2010-04-23
    function GetVolumeConversionFactr(sFlowUnitLabel: string): double;
    //rm 2010-10-20
    function GetRDIIperLFLabel(sFlowUnitLabel: string; var dVol: double): string;

  public { Public declarations }
  end;

var
  frmEventStatisitics: TfrmEventStatisitics;


implementation

uses  rdiiutils, GWIAdjustment, mainform;

{$R *.DFM}

procedure TfrmEventStatisitics.Button1Click(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEventStatisitics.closeButtonClick(Sender: TObject);
begin
//  Close;
  modalresult := mrCancel;
end;

procedure TfrmEventStatisitics.FormShow(Sender: TObject);
begin
  holidays := DatabaseModule.GetHolidays();
  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames();
  AnalysisNameComboBox.ItemIndex := 0;
  UpdateDataBasedOnSelectedAnalysis;
end;

function TfrmEventStatisitics.GetRDIIperLFLabel(sFlowUnitLabel: string;
  var dVol: double): string;
var sResult: string;
begin
//rm 2010-10-20 converting from Cubic Feet to either Gal or L
  if sFlowUnitLabel = 'CFS' then begin
    sResult := ' CF/LF';
  end else if sFlowUnitLabel = 'CMS' then begin
    dVol := dVol * 28.3168;
    sResult := ' L/LF';
  end else if sFlowUnitLabel = 'GPM' then begin
    dVol := dVol * 7.48051;
    sResult := ' Gal/LF';
  end else if sFlowUnitLabel = 'LPS' then begin
    dVol := dVol * 28.3168;
    sResult := ' L/LF';
  end else if sFlowUnitLabel = 'MGD' then begin
    dVol := dVol * 7.48051;
    sResult := ' Gal/LF';
  end else if sFlowUnitLabel = 'MLD' then begin
    dVol := dVol * 28.3168;
    sResult := ' L/LF';
  end else begin
    sResult := sFlowUnitLabel;
  end;
  Result := sResult;
end;

function TfrmEventStatisitics.GetVolumeConversionFactr(
  sFlowUnitLabel: string): double;
var
  sTimeUnit: string;
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

procedure TfrmEventStatisitics.UpdateDataBasedOnSelectedAnalysis;
var
  analysisName: string;
  weekdayDWF, weekendDWF: THydrograph;
begin
  Screen.Cursor := crHourglass;
  analysisName := AnalysisNameComboBox.Text;
  analysis := DataBaseModule.GetAnalysis(analysisName);
  analysisID := analysis.AnalysisID;
  meterID := analysis.FlowMeterID;
  raingaugeID := analysis.RaingaugeID;
  runningAverageDuration := analysis.RunningAverageDuration;

  area := DatabaseModule.GetAreaForAnalysis(analysisName);
  //rm 2009-10-30 Version 1.0.1 now accommodates areas other than acres
  //the area returned above is raw area from the record in the Meter table associated with the selected analysis
  //get the AreaUnitId from the Meter talbe to get the Conversionfactor from the AreaUnits table
  conversionToAcres := DatabaseModule.GetConversionToAcresForMeter('',meterID);
  area := area * conversionToAcres;
  //now area is in Acres so we can use it in calculations
  //remember to convert back to original units for display with the new areaunits variable
  areaUnitLabel := DatabaseModule.GetAreaUnitLabelForMeter('',meterID);
  //rm

  flowMeterName := DatabaseModule.GetFlowMeterNameForAnalysis(analysisName);
  raingaugeName := DatabaseModule.GetRaingaugeNameForAnalysis(analysisName);
  minbwwf := DatabaseModule.GetBaseFlowRateForAnalysis(analysisName);
  rdeltime := DatabaseModule.GetRainfallTimestep(raingaugeID);
  conversionToMGD := DatabaseModule.GetConversionForMeter(meterID);
  conversionToInches := DatabaseModule.GetConversionForRaingauge(raingaugeID);
  diurnal := DatabaseModule.GetDiurnalCurves(analysisName);
  events := DatabaseModule.GetEvents(analysisID);
  gwiAdjustments := DatabaseModule.GetGWIAdjustments(analysisID);
  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);

    //rm 2010-04-23
    volumeconversionfactor := GetVolumeConversionFactr(flowUnitLabel);
    //rm 2010-10-20
    sewerlength := DatabaseModule.GetSewerLengthForMeter(meterID);

  rainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(raingaugeName);
  decimalPlaces := DatabaseModule. GetRainfallDecimalPlacesForRaingauge(raingaugeName);
  volumeUnitLabel := DatabaseModule.GetFlowVolumeLabelForMeter(flowMeterName);
  weekdayDWF := DatabaseModule.GetWeekdayDWF(meterID);
  weekendDWF := DatabaseModule.GetWeekendDWF(meterID);
  minWeekdayDWFIndex := weekdayDWF.indexOfMinimum;
  minWeekendDWFIndex := weekdayDWF.indexOfMinimum;
  weekdayDWFMinimum := weekdayDWF.Minimum;
  weekendDWFMinimum := weekendDWF.Minimum;
  weekdayDWF.Free;
  weekendDWF.Free;

  timestep := DatabaseModule.GetFlowTimestep(meterID);
  segmentsPerDay := 1440 div timeStep;
  timestepsToAverage := round(runningAverageDuration*60/timestep);

  //rm 2008-09-03 - a little modification here
  if (events.count > 0) then begin
//    eventSpinEdit.Value := 1;
    eventSpinEdit.Enabled := true;
    saveToTextFileButton.Enabled := true;
    saveToCSVFileButton.Enabled := true;
    eventSpinEdit.MinValue := 1;
    eventSpinEdit.MaxValue := events.count;
    eventSpinEdit.Value := 1;
    event := events[eventSpinEdit.Value - 1];
    UpdateDataBasedOnSelectedEvent;
    OutputStatsToDialog;
  end
  else begin
    eventSpinEdit.Enabled := false;
    saveToTextFileButton.Enabled := false;
    saveToCSVFileButton.Enabled := false;
    StatisticsMemo.Lines.Clear;

    eventSpinEdit.MinValue := 0;
    eventSpinEdit.MaxValue := 0;
    eventSpinEdit.Value := 0;
  end;

  Screen.Cursor := crDefault;
end;

procedure TfrmEventStatisitics.UpdateDataBasedOnSelectedEvent;
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
  rainVolume := DatabaseModule.RainfallTotalForRaingaugeBetweenDates(raingaugeID,event.StartDate,event.EndDate);
  DatabaseModule.GetExtremeRainfallDateTimesBetweenDates(raingaugeID,
                                                         event.startDate,
                                                         event.endDate,
                                                         rainStartDate,
                                                         rainEndDate);
  maxRain := DatabaseModule.GetMaximumRainfallBetweenDates(raingaugeID,event.startDate,event.endDate);
  observedFlowHydrograph := DatabaseModule.ObservedFlowBetweenDateTimes(meterID,event.startDate,event.EndDate);
  iiHydrograph := observedFlowHydrograph.copyEmpty;
  avggwisum := 0.0;
  avgbwwfsum := 0.0;
  //rm 2009-04-06
  peakfctr := 0.0;
  //rm 2009-04-13
  peakwwf := 0.0;
  fbwwsum := 0.0;
  //rm 2010-04-07
  fgwisum := 0.0;
  for i := 0 to observedFlowHydrograph.size - 1 do begin
    timestamp := event.StartDate + (i / segmentsPerDay);
    DecodeTime(timestamp,hour,minute,second,ms);
    fgwi := gwiAdjustments.AdjustmentAt(timestamp);
    k := trunc((hour + (minute / 60.0)) / 24 * segmentsPerDay);
    dow := dayOfWeekIndex(timestamp);
    fbww := diurnal[dow,k];
    iiHydrograph.flows[i] := observedFlowHydrograph.flows[i]-fbww-fgwi;
    //rm 2009-04-06
    fbwwsum := fbwwsum + fbww;
    //rm 2010-04-07
    fgwisum := fgwisum + fgwi;
    //if ((fbww + fgwi) > 0) then begin
    //  if (observedFlowHydrograph.flows[i]/(fbww + fgwi) > peakfctr) then begin
    //    peakfctr := observedFlowHydrograph.flows[i]/(fbww + fgwi);
    //  end;
    //end;
    //rm 2009-04-13
    if (observedFlowHydrograph.flows[i] > peakwwf) then begin
      peakwwf := observedFlowHydrograph.flows[i];
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
  iiVolume := iiHydrograph.volume;
  //rm 2009-10-30 - Note that we have already converted area to acres
  iiDepth := iiVolume*conversionToMGD*12.0/(area*43560.0)*1000000.0/7.481/conversionToInches;
  if (rainVolume > 0.0)
    then eventTotalR := iiDepth/rainVolume
  else eventTotalR := 0.0;
  peakObservedFlow := observedFlowHydrograph.runningAverageMaximum(timestepsToAverage);
  averageObservedFlow := observedFlowHydrograph.average;
  peakIIFlow := iiHydrograph.runningAverageMaximum(timestepsToAverage);
//rm 2009-04-13
  if (abs(fbwwsum) > 0) then begin
    peakfctr := peakobservedFlow / (fbwwsum / iiHydrograph.size);
//rm 2010-10-20
  if (sewerlength > 0) then begin
    RDIIperLF := (area * (iiDepth/12)*43560) / sewerlength; //in CF / LF
    RDIIgalperLF := iiVolume * 1000000 / sewerlength; //in gal / LF
    RDIIcfperLF := ((iiDepth/12) * area * 43560) / sewerlength; //in CF / LF
  end else begin
    RDIIperLF := 0;
    RDIIgalperLF := 0;
    RDIIcfperLF := 0;
  end;
//rm 2010-04-07
//  if (abs(fbwwsum + fgwisum) > 0) then begin
//    peakfctr := peakobservedFlow / ((fbwwsum + fgwisum) / iiHydrograph.size);
    //MessageDlg('Peakfctr = ' + floattostr(peakfctr),mtInformation,[mbOK],0);
    //peakfctr := peakobservedFlow / (avggwi + avgbwwf);
    //MessageDlg('Peakfctr = ' + floattostr(peakfctr),mtInformation,[mbOK],0);
  end;

  observedFlowHydrograph.Free;
  iiHydrograph.Free;
end;

procedure TfrmEventStatisitics.OutputStatsToDialog;
var sRDIIperLFlabel: string;
begin
  StatisticsMemo.Lines.Clear;
  StatisticsMemo.Lines.Add('METER NAME            = '+flowMeterName);
  StatisticsMemo.Lines.Add('RAINGAUGE NAME        = '+raingaugeName);
//rm 2009-10-30 - now using areaunitslabel
//  StatisticsMemo.Lines.Add('SEWERED AREA          = '+floattostrF(area,ffFixed,8,2)+ ' Acres');
  StatisticsMemo.Lines.Add('SEWERED AREA          = '+
    floattostrF(area / conversionToAcres,ffFixed,8,2)+ ' ' + areaUnitLabel);
//rm 2010-10-20
  StatisticsMemo.Lines.Add('SEWER LENGTH          = '+
    floattostrF(sewerlength,ffFixed,8,2)+ ' feet');

  StatisticsMemo.Lines.Add('');
  StatisticsMemo.Lines.Add('EVENT NUMBER          = '+inttostr(eventSpinEdit.Value));
  StatisticsMemo.Lines.Add('START DATE & HOUR     = '+datetostr(event.StartDate)+ ' ' +timetostr(event.StartDate));
  StatisticsMemo.Lines.Add('END DATE & HOUR       = '+datetostr(event.EndDate)+ ' ' +timetostr(event.EndDate));
{  StatisticsMemo.Lines.Add('START DATE & HOUR     = '+datetostr(event.StartDate)+ ' ' +floattostrF(frac(event.StartDate)*24,ffFixed,8,2));
  StatisticsMemo.Lines.Add('END DATE & HOUR       = '+datetostr(event.EndDate)+ ' ' +floattostrF(frac(event.EndDate)*24,ffFixed,8,2));}
  StatisticsMemo.Lines.Add('DURATION              = '+floattostrF(event.duration*24,ffFixed,8,2)+ ' Hours');
  StatisticsMemo.Lines.Add('');
//rm 2010-04-23  StatisticsMemo.Lines.Add('EVENT I/I VOLUME      = '+floattostrF(iiVolume,ffFixed,8,3)+' '+volumeUnitLabel);
//  StatisticsMemo.Lines.Add('EVENT I/I VOLUME      = '+floattostrF(iiVolume,ffFixed,8,3)+' MG');
  StatisticsMemo.Lines.Add('EVENT I/I VOLUME      = '+floattostrF(iiVolume*volumeconversionfactor,ffFixed,8,3)+' '+volumeUnitLabel);
  StatisticsMemo.Lines.Add('                      = '+floattostrF(iiDepth,ffFixed,8,3)+' '+rainUnitLabel+' Over Sewered Area');
//rm 2010-10-20
sRDIIperLFlabel := GetRDIIperLFLabel(flowUnitLabel,RDIIperLF);
  StatisticsMemo.Lines.Add('I/I VOLUME/LF SEWER   = '+floattostrF(RDIIperLF,ffFixed,8,4) + sRDIIperLFlabel);
//  StatisticsMemo.Lines.Add('EVENT R/LF SEWER (cf) = '+floattostrF(RDIICFperLF,ffFixed,8,4));
//  StatisticsMemo.Lines.Add('EVENT R/LF SEWER (gal) = '+floattostrF(RDIIGalperLF,ffFixed,8,4));
  StatisticsMemo.Lines.Add('');
  StatisticsMemo.Lines.Add('EVENT RAINFALL VOLUME = '+floattostrF(rainvolume,ffFixed,8,decimalPlaces)+' '+rainUnitLabel);
  StatisticsMemo.Lines.Add('');
  StatisticsMemo.Lines.Add('EVENT TOTAL R VALUE   = '+floattostrF(eventTotalR,ffFixed,8,4));
  StatisticsMemo.Lines.Add('');
  StatisticsMemo.Lines.Add('');

  StatisticsMemo.Lines.Add('PEAK TOTAL FLOW       = '+floattostrF(peakObservedFlow,ffFixed,8,3)+' '+flowUnitLabel);
  StatisticsMemo.Lines.Add('PEAK I/I FLOW         = '+floattostrF(peakIIFlow,ffFixed,8,3)+' '+flowUnitLabel);

//rm 2009-04-06
  Statisticsmemo.Lines.Add('PEAKING FACTOR        = ' + floattostrF(peakfctr ,ffFixed,8,3));

  StatisticsMemo.Lines.Add('MAX '+inttostr(rdeltime)+' MINUTE RAIN    = '+floattostrF(maxRain,ffFixed,8,3)+' '+rainUnitLabel);
  StatisticsMemo.Lines.Add('');
  StatisticsMemo.Lines.Add('AVERAGE OBS FLOW      = '+floattostrF(averageObservedFlow,ffFixed,8,3)+' '+flowUnitLabel);
  StatisticsMemo.Lines.Add('AVERAGE GWI FLOW      = '+floattostrF(avggwi,ffFixed,8,3)+' '+flowUnitLabel);
//rm 2009-06-09 - spelling?  StatisticsMemo.Lines.Add('AVERAGE BBW FLOW      = '+floattostrF(avgbwwf,ffFixed,8,3)+' '+flowUnitLabel);
  StatisticsMemo.Lines.Add('AVERAGE BWF FLOW      = '+floattostrF(avgbwwf,ffFixed,8,3)+' '+flowUnitLabel);
  StatisticsMemo.Lines.Add('');
  StatisticsMemo.Lines.Add('RAINFALL START DATE   = '+datetostr(rainStartDate)+ ' ' +timetostr(rainStartDate));
  StatisticsMemo.Lines.Add('RAINFALL END DATE     = '+datetostr(rainEndDate)+ ' ' +timetostr(rainEndDate));
{  StatisticsMemo.Lines.Add('RAINFALL START DATE   = '+datetostr(rainStartDate)+ ' ' +floattostrF(frac(rainStartDate)*24,ffFixed,8,2));
  StatisticsMemo.Lines.Add('RAINFALL END DATE     = '+datetostr(rainEndDate)+ ' ' +floattostrF(frac(rainEndDate)*24,ffFixed,8,2)); }
  StatisticsMemo.Lines.Add('RAIN DURATION         = '+floattostrF((rainEndDate-rainStartDate)*24,ffFixed,8,2)+' Hours');
end;

procedure TfrmEventStatisitics.AnalysisNameComboBoxChange(Sender: TObject);
begin
  UpdateDataBasedOnSelectedAnalysis;
end;

procedure TfrmEventStatisitics.EventSpinEditChange(Sender: TObject);
begin
  if (events.count > 0) then begin
  //rm 2008-09-03 -  a little error checking here
    if (eventSpinEdit.Value > 0) and
       (events.Count >= eventSpinEdit.Value) then begin

    event := events[eventSpinEdit.Value - 1];
    UpdateDataBasedOnSelectedEvent;
    OutputStatsToDialog;
//rm 2008-09-03 - why do we have to manually check if value is greater than maxval or less than minval???
       end else begin
         if (eventSpinEdit.Value > eventSpinEdit.MaxValue)  then begin
           eventSpinEdit.Value := eventSpinEdit.MaxValue;
         end else if (eventSpinEdit.Value < eventSpinEdit.MinValue) then begin
           eventSpinEdit.Value := eventSpinEdit.MinValue;
         end;
       end;
  end;
end;

procedure TfrmEventStatisitics.saveToTextFileButtonClick(Sender: TObject);
var
  i: integer;
  F: textFile;
begin
  SaveStatsDialog.Filter := 'Text Files|*.txt';
  SaveStatsDialog.DefaultExt := '.TXT';
  if (SaveStatsDialog.Execute) then begin
    Screen.Cursor := crHourglass;
    AssignFile(F,SaveStatsDialog.Filename);
    Rewrite(F);
    try
    for i := 0 to events.count - 1 do begin
      event := events[i];
      UpdateDataBasedOnSelectedEvent;

      writeln(F,'METER NAME            = ',flowMeterName);
      writeln(F,'RAINGAUGE NAME        = ',raingaugeName);
//rm 2009-10-30 - now using areaunitslabel
//      writeln(F,'SEWERED AREA          = ',floattostrF(area,ffFixed,8,2)+ ' Acres');
      writeln(F,'SEWERED AREA          = ' +
        floattostrF(area / conversionToAcres,ffFixed,8,2)+ ' ' + areaUnitLabel);
      writeln(F);
      writeln(F,'EVENT NUMBER          = ',inttostr(i+1));
      writeln(F,'START DATE & HOUR     = ',datetostr(event.StartDate)+ ' ' +floattostrF(frac(event.StartDate)*24,ffFixed,8,2));
      writeln(F,'END DATE & HOUR       = ',datetostr(event.EndDate)+ ' ' +floattostrF(frac(event.EndDate)*24,ffFixed,8,2));
      writeln(F,'DURATION              = ',floattostrF(event.duration*24,ffFixed,8,2)+ ' Hours');
      writeln(F);
//rm 2010-04-23        writeln(F,'EVENT I/I VOLUME      = ',floattostrF(iiVolume,ffFixed,8,3)+' '+volumeUnitLabel);
      writeln(F,'EVENT I/I VOLUME      = ',floattostrF(iiVolume*volumeconversionfactor,ffFixed,8,3)+' '+volumeUnitLabel);
      writeln(F,'                      = ',floattostrF(iiDepth,ffFixed,8,3)+' '+rainUnitLabel+' Over Sewered Area');
      writeln(F);
      writeln(F,'EVENT RAINFALL VOLUME = ',floattostrF(rainvolume,ffFixed,8,3)+' '+rainUnitLabel);
      writeln(F);
      writeln(F,'EVENT TOTAL R VALUE   = ',floattostrF(eventTotalR,ffFixed,8,4));
      writeln(F);
      writeln(F,'PEAK TOTAL FLOW       = ',floattostrF(peakObservedFlow,ffFixed,8,3)+' '+flowUnitLabel);
      writeln(F,'PEAK I/I FLOW         = ',floattostrF(peakIIFlow,ffFixed,8,3)+' '+flowUnitLabel);

      //rm 2009-04-06
      writeln(F,'PEAKING FACTOR        = ' + floattostrF(peakfctr ,ffFixed,8,3));

      writeln(F,'MAX '+inttostr(rdeltime)+' MINUTE RAIN    = ',floattostrF(maxRain,ffFixed,8,3)+' '+rainUnitLabel);
      writeln(F);
      writeln(F,'AVERAGE OBS FLOW      = ',floattostrF(averageObservedFlow,ffFixed,8,3)+' '+flowUnitLabel);
      writeln(F,'AVERAGE GWI FLOW      = ',floattostrF(avggwi,ffFixed,8,3)+' '+flowUnitLabel);
      writeln(F,'AVERAGE BBW FLOW      = ',floattostrF(avgbwwf,ffFixed,8,3)+' '+flowUnitLabel);
      writeln(F);
      writeln(F,'RAINFALL START DATE   = ',datetostr(rainStartDate)+ ' ' +floattostrF(frac(rainStartDate)*24,ffFixed,8,2));
      writeln(F,'RAINFALL END DATE     = ',datetostr(rainEndDate)+ ' ' +floattostrF(frac(rainEndDate)*24,ffFixed,8,2));
      writeln(F,'RAIN DURATION         = ',floattostrF((rainEndDate-rainStartDate)*24,ffFixed,8,2)+' Hours');
      writeln(F);
      writeln(F);
    end;
    finally
      CloseFile(F);
    end;
    Screen.Cursor := crDefault;
    i := MessageDlg('Done exporting to ' + SaveStatsDialog.Filename + '.',
      mtInformation, [mbok],0);
  end;
end;

procedure TfrmEventStatisitics.saveToCSVFileButtonClick(Sender: TObject);
var
  i: integer;
  F: textFile;
begin
  SaveStatsDialog.Filter := 'CSV Files|*.csv';
  SaveStatsDialog.DefaultExt := '.CSV';
  if (SaveStatsDialog.Execute) then begin
    Screen.Cursor := crHourglass;
    AssignFile(F,SaveStatsDialog.Filename);
    Rewrite(F);
    writeln(F,'METER NAME,',flowMeterName);
    writeln(F,'RAINGAUGE NAME,',raingaugeName);
//rm 2009-10-30 - now using areaunitslabel
//    writeln(F,'SEWERED AREA,',floattostrF(area,ffFixed,8,2),',Acres');
    writeln(F,'SEWERED AREA,',
//rm 2010-04-27      floattostrF(area / conversionToAcres,ffFixed,8,2),',Acres');
      floattostrF(area / conversionToAcres,ffFixed,8,2),','+areaUnitLabel);
    writeln(F);
//rm 2010-04-07 - Some of the headings are erroneous
//GWI FLOW MGD should be Average Observed Flow
//BASE WASTEWATER FLOW MGD should be AVERAGE GWI
//RAINFALL FLOW MGD shoudl be AVERAGE BASE WASTEWATER FLOW
    writeln(F,',,,,,,,,,,"<--------EVENT AVERAGE-------->"');
    writeln(F,',,,,"I/I","RAIN",,"PEAK I/I","PEAK TOTAL","PEAK",',
//      '"OBSERVED","GWI","BASE WASTEWATER","RAINFALL","RAINFALL","RAINFALL"');
      ',"OBSERVED","GWI","BASE WASTEWATER","RAINFALL","RAINFALL","RAINFALL"');
    writeln(F,',,,"DURATION","VOLUME","VOLUME","TOTAL","FLOW","FLOW","FACTOR","RAINFALL",',
      '"FLOW","FLOW","FLOW","STARTDATE","ENDDATE","DURATION"');
    write(F,'"EVENT","START DATE","END DATE","Hours","',rainUnitLabel,'","',rainUnitLabel,'","R-VALUE","',
      flowUnitLabel,'","',flowUnitLabel,'",,"',rainUnitLabel,'/',rdeltime:0,' MINUTES"');
    writeln(F,',"',flowUnitLabel,'","',flowUnitLabel,'","',flowUnitLabel,'",,,"Hours"');

    for i := 0 to events.count - 1 do begin
      event := events[i];
      UpdateDataBasedOnSelectedEvent;
      write(F,inttostr(i+1),',');
      write(F,dateTimeString(event.StartDate),',');
      write(F,dateTimeString(event.EndDate),',');
      write(F,floattostrF(event.duration*24,ffFixed,8,2),',');
      write(F,floattostrF(iiDepth,ffFixed,8,3),',');
      write(F,floattostrF(rainvolume,ffFixed,8,3),',');
      write(F,floattostrF(eventTotalR,ffFixed,8,4),',');
      write(F,floattostrF(peakIIFlow,ffFixed,8,3),',');
      write(F,floattostrF(peakObservedFlow,ffFixed,8,3),',');
      write(F,floattostrF(peakFctr,ffFixed,8,3),',');
      write(F,floattostrF(maxRain,ffFixed,8,3),',');
      write(F,floattostrF(averageObservedFlow,ffFixed,8,3),',');
      write(F,floattostrF(avggwi,ffFixed,8,3),',');
      write(F,floattostrF(avgbwwf,ffFixed,8,3),',');
      write(F,dateTimeString(rainStartDate),',');
      write(F,dateTimeString(rainEndDate),',');
      write(F,floattostrF((rainEndDate-rainStartDate)*24,ffFixed,8,2),',');
      writeln(F);
    end;
    CloseFile(F);
    Screen.Cursor := crDefault;
    i := MessageDlg('Done exporting to ' + SaveStatsDialog.Filename + '.',
      mtInformation, [mbok],0);
  end;
end;

procedure TfrmEventStatisitics.TimeStepsToAverageSpinEditChange(
  Sender: TObject);
begin
  if (events.count > 0) then begin
    UpdateDataBasedOnSelectedEvent;
    OutputStatsToDialog;
  end;
end;

function TfrmEventStatisitics.isHoliday(date: TDateTime): boolean;
var
  i: integer;
begin
  isHoliday := false;
  for i := 0 to length(holidays) - 1 do begin
    if (trunc(date) = holidays[i]) then isHoliday := true;
  end;
end;

function TfrmEventStatisitics.dayOfWeekIndex(date: TDateTime): integer;
(* returns day of week 0 = sun, 1 = mon, 2 = tues..... 6 = saturday *)
(* holidays are returned as 7 *)
var
  dow: integer;
begin
  dow := dayofweek(date) - 1;
  if (isholiday(date)) then dow := 7;
  dayOfWeekIndex := dow;
end;


procedure TfrmEventStatisitics.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  events.Free;
  gwiAdjustments.Free;

  Finalize(diurnal);
  Finalize(holidays);
end;

end.

