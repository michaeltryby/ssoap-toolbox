unit RainfallCharacteristicAnalysisThrd;

interface

uses
  Classes, ADODB_TLB;

type
  RainfallCharacteristicAnalysisThread = class(TThread)
    raingaugeName, textToAdd, exportUnitLabel: string;
    raingaugeID, raingaugeUnit, decimalPlaces: integer;
    timestamp: TDateTime;
    conversionFactor: real;
    {SelectRainfallQuery: TQuery;}

    recSet: _RecordSet;
    constructor CreateIt();
  private  { Private declarations }
    procedure GetRaingaugeData();
    {procedure GetConversionFactor();}
    procedure OpenQuery();
    procedure GetNextRecord();
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

type
  eventRainfallRecord = record
        rainDataTime : Tdatetime;
        rainfall : real;
  end;

implementation

uses windows, sysutils, dialogs, feedbackWithMemo, RainfallCharacteristicAnalysis,
     modDatabase, DateUtils, mainform;



constructor RainfallCharacteristicAnalysisThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true; // Thread Free Itself when terminated
  Suspended := false;         // Continue the thread
end;

destructor RainfallCharacteristicAnalysisThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure RainfallCharacteristicAnalysisThread.Execute;
var
  eventStartTime, lastRainTime, currentRainTime: TDateTime;
  antecedantDryPeriod, diffTime: double;   //Antecedant Dry Period is in days, diffTime is in Days
  eventDuration: double;
  totalRainfall, eventRainfall : real;
  eventCounter, timeStepInMinutes, counter: integer;
  rainfallrecord1 : array of eventRainfallRecord;  //for peak hourly rainfall intensity calculation
  i, j : integer;  //counter
  lowArray, highArray : integer;
  peakHourlyIntensity, peakTempHourlyIntensity : real;
  dryWeatherDay : array of TDateTime;
  nextMonth, nextDay, nextYear, nextHour, nextMinute, nextCode: word;

begin
  raingaugename := frmRainfallCharacteristicAnalysis.RaingaugeNameComboBox.Items.Strings[frmRainfallCharacteristicAnalysis.RaingaugeNameComboBox.ItemIndex];


  Synchronize(GetRaingaugeData);
  {Synchronize(GetConversionFactor);}
  Synchronize(OpenQuery);
  counter := 0;

  if not recSet.eof then begin
    eventStartTime := TDateTime(recSet.fields.Item[0].value);
    {eventStartTime := recSet.fields.Item[0].value;}
    //showmessage(datetimetostr(eventStarttime));

    lastRainTime := eventStartTime;
    eventRainfall := recSet.fields.item[1].value;

    //Set the Dynamic Array to hold the rainfall record
    SetLength(rainfallrecord1,Length(rainfallrecord1)+1);
    rainfallrecord1[High(rainfallrecord1)].rainDataTime := lastRainTime;
    rainfallrecord1[High(rainfallrecord1)].rainfall  := eventRainfall;

    totalRainfall := 0;
    antecedantDryPeriod := 0;
    Synchronize(UpdateStatus);
    synchronize(GetNextRecord);
    eventCounter :=0;
  end;
  Feedbackln('Vol = Total Volume (inch)');
  Feedbackln('Dur = Rainfall Duration (hr)');
  Feedbackln('PI = Peak Intensity (in./hr.)');
//rm 2009-06-12 - Beta 1 feedback - It is "ADP" not "AMC"
//  Feedbackln('AMC = Antecedant Dry Period (days)');
  Feedbackln('ADP = Antecedant Dry Period (days)');
  Feedbackln('');
  Feedback('Analyzing...');
  Feedbackln('');
  Feedbackln('Event'+#9+'Start Date/Time'+#9#9+'Vol'+#9+'Dur'+#9+'PI'+#9+'AMC');

  while (not recSet.eof) do begin
    currentRainTime := TDateTime(recSet.Fields.Item[0].value);
    //showmessage(datetimetostr(currentRaintime));  //Debug
    //showmessage(datetimetostr(lastRainTime));     //Debug
    Synchronize(UpdateStatus);
    diffTime := currentRainTime - lastRainTime;

    if diffTime*24 > frmRainfallCharacteristicAnalysis.mit_hour.Value then
      begin
        //Calculate Peak Hourly Intensity for this event
        peakHourlyIntensity := 0;
        lowArray := Low(rainfallrecord1);
        highArray := High(rainfallrecord1);

        for i := lowArray to highArray do begin
          peakTempHourlyIntensity := rainfallrecord1[i].rainfall;

          for j := i + 1 to highArray do begin
            diffTime := rainfallrecord1[j].rainDataTime - rainfallrecord1[i].rainDataTime;
            if diffTime * 24 >= 1 then break  // > 1 hour
            else peakTempHourlyIntensity := peakTempHourlyIntensity + rainfallRecord1[j].rainfall;
          end;
          if peakTempHourlyIntensity > peakHourlyIntensity then peakHourlyIntensity := peakTempHourlyIntensity;
        end;

        //Calculate the duration of the rain event
        eventDuration := lastRainTime - eventStartTime;
        eventCounter := eventCounter + 1;

        //Print the result to the Thread board
        Feedbackln(inttostr(eventCounter)+#9+formatdatetime('mm/dd/yyyy hhhh:mm' ,eventstarttime)+#9+formatfloat('0.00',eventRainfall)+#9+formatfloat('0.00',eventduration * 24 + frmRainfallCharacteristicAnalysis.rainfallTimeStepSpinEdit.value / 60)+#9+formatfloat('0.00',peakHourlyIntensity)+#9+formatfloat('0.0',antecedantDryPeriod));

        //Find AMC for the next event
        antecedantDryPeriod := currentRainTime - lastRainTime;

        //Determine Dry Weather Period
        diffTime := currentRainTime - lastRainTime;
        if diffTime >= frmRainfallCharacteristicAnalysis.DryPeriodDefinitionSpinEdit.Value + 1 then begin
          i := 1;
          while i <= (diffTime - frmRainfallCharacteristicAnalysis.DryPeriodDefinitionSpinEdit.Value) do begin
            SetLength(dryWeatherDay,Length(dryWeatherDay)+1);
            dryweatherday[High(dryWeatherDay)] := incday(currentRainTime,-1*i);
            i := i + 1;
          end;
        end;

        //reset
        eventStartTime := currentRainTime;
        lastRainTime := eventStartTime;
        totalRainfall := totalRainfall + eventRainfall;
        eventRainfall := recSet.Fields.item[1].value * conversionFactor;
        rainfallRecord1 := nil;
        setLength(rainfallrecord1,Length(rainfallrecord1)+1);
        rainfallrecord1[High(rainfallrecord1)].rainDataTime := currentRainTime;
        rainfallrecord1[High(rainfallrecord1)].rainfall  := recSet.Fields.item[1].value * conversionFactor;

      end
    else begin
      eventRainfall := eventRainfall + recSet.Fields.item[1].value * conversionFactor;

      setLength(rainfallrecord1,Length(rainfallrecord1)+1);
      rainfallrecord1[High(rainfallrecord1)].rainDataTime := currentRainTime;
      rainfallrecord1[High(rainfallrecord1)].rainfall  := recSet.Fields.item[1].value * conversionFactor;

      lastRainTime := currentRainTime;

    end;
    inc(counter);
    Synchronize(GetNextRecord);

  end;
  Feedbackln('');
  Feedbackln('');
  // Print Dry Weather Analysis
//rm 2009-06-12 - Beta 1 feedback - dry weather days is confusing - take out for now
//  Feedbackln('Dry Weather Days: ');
//  lowArray := Low(dryWeatherDay);
//  highArray := High(dryWeatherDay);
//  for i := lowArray to highArray do begin
//    Feedbackln(formatDateTime('mm/dd/yyy',dryWeatherDay[i]));
//  end;
//rm


  rainfallrecord1:= nil;
  dryWeatherDay := nil;
  Synchronize(CloseAndFreeQuery);
  Feedbackln('Analysis Complete.');
  Feedbackln('');
  Feedback('This window may be closed.');
end;

procedure RainfallCharacteristicAnalysisThread.GetRaingaugeData();
begin
  raingaugeID := DatabaseModule.GetRaingaugeIDForName(raingaugeName);
  raingaugeUnit := DatabaseModule.GetRainUnitIDForRaingauge(raingaugeID);
  exportUnitLabel := DatabaseModule.GetRainUnitLabelForRaingauge(raingaugeName);
  conversionFactor := DatabaseModule.GetConversionFactorToUnitForRaingauge(raingaugeID,exportUnitLabel);
  end;

{procedure RainfallCharacteristicAnalysisThread.GetConversionFactor();
var
  exportRainUnit: integer;
  exportConversionFactor, raingaugeConversionFactor: real;
  rainUnitsTable: TTable;
begin
  rainUnitsTable := TTable.Create(frmRainfallCharacteristicAnalysis);
  rainUnitsTable.DatabaseName := 'MeterDatabase';
  rainUnitsTable.TableName := 'RainUnits';
  rainUnitsTable.Open;
  //rainUnitsTable.Locate('Label',exportUnitLabel,[]);
  //exportRainUnit := rainUnitsTable.FieldByName('RainUnitID').asInteger;
  decimalPlaces := rainUnitsTable.FieldByName('DecimalPlaces').asInteger;
  if (raingaugeUnit = exportRainUnit) then
    conversionFactor := 1.0
  else begin
    exportConversionFactor := rainUnitsTable.FieldByName('ConversionFactor').asFloat;
    rainUnitsTable.Locate('RainUnitID',raingaugeUnit,[]);
    raingaugeConversionFactor := rainUnitsTable.FieldByName('ConversionFactor').asFloat;
    conversionFactor := raingaugeConversionFactor / exportConversionFactor;
  end;
  rainUnitsTable.Close;
  rainUnitsTable.Free;
end;}

procedure RainfallCharacteristicAnalysisThread.OpenQuery();
var
  queryStr: string;
  startDateTime, endDateTime: TDateTime;

begin
  startDateTime := frmRainfallCharacteristicAnalysis.StartDatePicker.Date + frac(frmRainfallCharacteristicAnalysis.StartTimePicker.Time);
  endDateTime := frmRainfallCharacteristicAnalysis.EndDatePicker.Date + frac(frmRainfallCharacteristicAnalysis.EndTimePicker.Time);
  queryStr := 'SELECT DateTime, Volume, Code FROM Rainfall WHERE ' +
              '(((RaingaugeID =' + inttostr(raingaugeID) + ') AND ' +
              '(DateTime <= ' + floattostr(endDateTime) + ')) AND ' +
              '(DateTime >= ' + floattostr(startDateTime) + ')) ' +
              'ORDER BY DateTime;';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
end;

procedure RainfallCharacteristicAnalysisThread.GetNextRecord();
begin
  recSet.MoveNext;
end;

procedure RainfallCharacteristicAnalysisThread.CloseAndFreeQuery();
begin
  recSet.Close;
end;

procedure RainfallCharacteristicAnalysisThread.UpdateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(timestamp);
end;

procedure RainfallCharacteristicAnalysisThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Text := frmFeedbackWithMemo.feedbackMemo.Text+textToAdd;
  frmFeedbackWithMemo.feedbackMemo.SelStart := Length(frmFeedbackWithMemo.feedbackMemo.Text)
end;

procedure RainfallCharacteristicAnalysisThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;

procedure RainfallCharacteristicAnalysisThread.FeedbackLn(line: string);
begin
  textToAdd := line+#13+#10;
  Synchronize(AddToFeedbackMemo);
end;

end.
