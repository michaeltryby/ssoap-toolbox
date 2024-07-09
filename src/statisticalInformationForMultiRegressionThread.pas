unit statisticalInformationForMultiRegressionThread;

interface

uses
  Classes, ADODB_TLB;

type
  statisticsForMultiRegressionThread = class(TThread)
    day: integer;
    analysisName, textToAdd: string;
    analysisID, meterID: integer;
    dailyAverage, average: real;
    AvgT1, AvgT2, AvgT3 : double;
    AvgK1, AvgK2, AvgK3 : double;
    ratioR1, ratioR2, ratioR3 : double;
    mediumR, averageR : double;
    eventCount : integer;

    constructor CreateIt();
  private
    {procedure GetAverageTK();
    procedure GetRratio();
    procedure GetMediumR();
    procedure GetAverageR();
    procedure GetMonthlyMediumR();}

    {procedure GetAverageFlows();
    procedure OpenQuery();
    procedure GetNextRecord();
    procedure CloseAndFreeQuery();
    procedure GetDailyAverage();
    procedure AddGWIAdjustment();
    procedure UpdateStatus();}
    procedure AddToFeedbackMemo();
    procedure Feedback(line: string);
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
  end;

implementation

uses sysutils, windows, feedbackWithMemo, modDatabase,
     rdiiutils, mainform, chooseAnalysis, variants;

constructor statisticsForMultiRegressionThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true;     // Thread Free Itself when terminated
  Suspended := false;          // Continue the thread
  eventcount := 0;
end;

destructor statisticsForMultiRegressionThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure statisticsForMultiRegressionThread.Execute;
var
  value: real;
  i,j,k : integer;
  line: string;
  mother_recSet : _RecordSet;
  child_recSet: _RecordSet;
  queryStr: string;
  eventStartString, eventEndString,antecedentStartString, antecedentEndString: string;
  counter : integer;
  eventStart, eventEnd, antecedentStart, antecedentEnd : TDateTime;
  //for determining rainfall intensity
  intensity, tempIntensity : double;
  tempHourlyRainStart, tempHourlyRainEnd : TDateTime;
  //rm
  interval: integer;
  iCount: integer;
  max, sum: double;
  val: array of double;
  isin: array of boolean;
  dtime: array of double;

begin
  analysisName := frmAnalysisSelector.SelectedAnalysis;
  analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);

  //interval := DatabaseModule.getrain
  //interval := DatabaseModule.GetRainTimestep()

  Feedback(analysisName);

  Feedback('Statistics For Multiple-Variable Regression ');
  Feedback('');
  //line := 'Number of Events             :     ' + inttostr(eventCount);
  //feedback(line);

  queryStr := 'SELECT e.AnalysisID, e.StartDateTime, e.EndDateTime, r.[R1], r.[R2], r.[R3], r.[T1], r.[T2], r.[T3], r.[K1], r.[K2], r.[K3] ' +
              ' FROM Events e inner join RTKPatterns r on e.RTKPatternID = r.RTKPatternID ' +
              ' WHERE (((e.AnalysisID) = ' +
              inttostr(analysisID) + '))';
//Feedback(queryStr);

  mother_recSet := CoRecordSet.Create;
  mother_recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
//  line := leftPad(floattostrF(mother_recSet.Fields.Item[3].Value+mother_recSet.Fields.Item[4].Value+mother_recSet.Fields.Item[5].Value,ffFixed,15,2),5);
  counter := 0;
  if mother_recSet.EOF then begin
    //averageR := 0;
    if counter = 0 then begin
        line := 'No RDII Analysis Results.';
        feedback(line);
        line := 'Please complete RDII analysis before performing this function.';
        feedback(line);
    end;

  end else begin
    Feedback(line);
    Feedback('  E       ED      R     V     D1    D2     I    A7    A14    A21   R1    R2    R3    T1    T2    T3    K1    K2    K3');
    Feedback(line);

    mother_recSet.MoveFirst;
    counter := 0;
    while not(mother_recSet.EOF) do begin

      counter := counter + 1;
      line := leftPad(inttostr(counter),3);
      //Event Start
      line := line + leftPad(datetostr(mother_recSet.Fields.Item[1].value),12);
      //Total R-Value
      line := line + leftPad(floattostrF(mother_recSet.Fields.Item[3].Value+mother_recSet.Fields.Item[4].Value+mother_recSet.Fields.Item[5].Value,ffFixed,15,2),6);


      eventStart := mother_recSet.Fields.Item[1].Value;
      eventEnd := mother_recSet.Fields.Item[2].Value;

      eventStartString := datetostr(EventStart) + ' ' + timetostr(EventStart);
      eventEndString := datetostr(EventEnd) + ' ' + timetostr(EventEnd);

      //Sum of Rainfall Volume

//      queryStr := 'SELECT Sum(Rainfall.Volume) AS SumOfVolume ' +
//                  'FROM Analyses LEFT JOIN Rainfall ON Analyses.RainGaugeID = Rainfall.RainGaugeID ' +
//                  'WHERE (((Rainfall.DateTime) >= #' +
//                  eventStartString + '# And (Rainfall.DateTime)<=#' +
//                  eventEndString + '#) AND ((Analyses.AnalysisID)= ' +
//                  inttostr(analysisID) + '))';
//convert based on RainUnits
      queryStr := 'SELECT Sum(Rainfall.Volume * RainUnits.ConversionFactor) AS SumOfVolume ' +
                  ' FROM (Analyses INNER JOIN Rainfall ON Analyses.RainGaugeID = Rainfall.RainGaugeID) ' +
                  ' inner join (RainUnits inner Join Raingauges on RainUnits.RainUnitID = Raingauges.RainUnitID) ' +
                  ' on Rainfall.RaingaugeID = Raingauges.RaingaugeID ' +
                  ' WHERE (((Rainfall.DateTime) >= #' +
                  eventStartString + '# And (Rainfall.DateTime)<=#' +
                  eventEndString + '#) AND ((Analyses.AnalysisID)= ' +
                  inttostr(analysisID) + '))';
//Feedback(queryStr);

      child_recSet := CoRecordSet.Create;
      child_recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      if child_recSet.EOF then begin
        line := line + leftPad(floattostrF(0,ffFixed,15,2),6);
      end else begin
        if not VarIsNull(child_recSet.Fields.Item[0].value) then
          line := line + leftPad(floattostrF(child_recSet.Fields.Item[0].Value,ffFixed,15,2),6)
        else
          line := line + leftPad(floattostrF(0,ffFixed,15,2),6);
      end;
      child_recSet.Close;

      //Event Duration
      line := line + leftPad(floattostrF((eventEnd - eventStart)*24,ffFixed,15,1),6);

      //Rainfall Duration and Intensity
      //include conversion factor and order by datetime
      queryStr := 'SELECT Rainfall.Volume * RainUnits.ConversionFactor, Rainfall.DateTime ' +
                  'FROM (Analyses INNER JOIN Rainfall ON Analyses.RainGaugeID = Rainfall.RainGaugeID) ' +
                  ' inner join (RainUnits inner Join Raingauges on RainUnits.RainUnitID = Raingauges.RainUnitID) ' +
                  ' on Rainfall.RaingaugeID = Raingauges.RaingaugeID ' +
                  ' WHERE (((Rainfall.DateTime) >= #' +
                  eventStartString + '# And (Rainfall.DateTime)<=#' +
                  eventEndString + '#) AND ((Analyses.AnalysisID)= ' +
                  inttostr(analysisID) + ')) ORDER by Rainfall.DateTime';
//Feedback(queryStr);
      child_recSet := CoRecordSet.Create;
      child_recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      tempIntensity := 0;
      intensity := 0;
      iCount := 0;
      tempHourlyRainStart := 0.0;
      tempHourlyRainEnd := 0.0;
      if child_recSet.EOF then begin
        //Rainfall Duration
        line := line + leftPad(floattostrF(0,ffFixed,15,1),6);
        //and the line for peak hourly intensity
        line := line + leftPad(floattostrF(0,ffFixed,15,1),6);
      end else begin
        //there may be a placeholder with 0 volume at start and/or end of rainfall record
        //in other words you cannot assume that a rainfall record has non-zero volume
        if (child_recSet.Fields.Item[0].Value > 0.0) then //vol > 0
          tempHourlyRainStart := child_recSet.Fields.Item[1].Value; //set start of rainfall
        while not(child_recSet.EOF) do begin
          // - moved peak hourly intensity calc to a second pass
          //if (child_recSet.Fields.Item[1].Value - tempHourlyRainStart) > 0.0417 then begin
          //  // refresh
          //  if tempIntensity > intensity then intensity := tempIntensity;
          //  tempIntensity := 0;
          //end else begin
          //  tempIntensity := tempIntensity + child_recSet.Fields.Item[0].Value;
          //end;
          if (child_recSet.Fields.Item[0].Value > 0.0) then begin //vol > 0
            tempHourlyRainEnd := child_recSet.Fields.Item[1].Value;
            if (tempHourlyRainStart < 1.0) then //haven't set start of rainfall yet
              tempHourlyRainStart := child_recSet.Fields.Item[1].Value;
          end;
          child_recSet.MoveNext;
          iCount := iCount + 1;
        end;
        //child_recSet.MovePrevious; - not necessary anymore
        //Rainfall Duration
        //line := line + leftPad(floattostrF(((child_recSet.Fields.Item[1].value - tempHourlyRainStart))*24,ffFixed,15,1),6);
        line := line + leftPad(floattostrF(((tempHourlyRainEnd - tempHourlyRainStart))*24,ffFixed,15,1),6);
        //line := line + leftPad(floattostrF(intensity,ffFixed,15,2),6); //Rainfall Intensity
        //now get the peak hourly rainfall
        //slide a backward-looking 1-hour window across the data
        //and store the max sum of values in that window
        SetLength(val, iCount);
        SetLength(isin, iCount);
        SetLength(dtime, iCount);
        max := 0;
        sum := 0;
        j := 0;
        child_recSet.MoveFirst;
        while not(child_recSet.EOF) do begin
          isin[j] := true;  //the current record is within the 1-hour window
          //store the value and time so we can subtract
          // the value from the sum when the time falls behind the 1-hour window
          val[j] := child_recSet.Fields.Item[0].Value; //store the value
          dtime[j] := child_recSet.Fields.Item[1].Value; //store the time
          //add current value to the 1-hour total
          sum := sum + val[j];
          //subtract any values that may have dropped out of the 1-hour window
          for k := 0 to j - 1 do begin
              //if the test value is flagged as being within the 1-hour window
              if (isin[k]) then begin
                //check to see if its time is still withing the 1-hour window
                if (dtime[k] < (dtime[j] - 0.0416)) then begin {0.0146 is just shy of 1/24th day}
                  //subtract value from sum if its date is before the 1-hour window
                  sum := sum - val[k];
                  //and flag it as outside the 1-hour window
                  isin[k] := false;
                end;
              end;
          end;
          //set max to sum if current max is less than current sum
          if max < sum then max := sum;
          child_recSet.MoveNext;
          j := j + 1;
        end;
        line := line + leftPad(floattostrF(max,ffFixed,15,2),6); //Rainfall Intensity
        SetLength(val, 0);
        SetLength(isin, 0);
        SetLength(dtime, 0);
      end; //Rainfall Duration and Intensity
      child_recSet.Close;

      //Sum of AMD 7 days Volume
      antecedentStart := eventStart - 7;
      antecedentEnd := eventStart;

      antecedentStartString :=  datetostr(antecedentStart) + ' ' + timetostr(antecedentStart);
      antecedentEndString :=  datetostr(antecedentEnd) + ' ' + timetostr(antecedentEnd);

      queryStr := 'SELECT Sum(Rainfall.Volume * RainUnits.ConversionFactor) AS SumOfVolume ' +
                  ' FROM (Analyses INNER JOIN Rainfall ON Analyses.RainGaugeID = Rainfall.RainGaugeID) ' +
                  ' inner join (RainUnits inner Join Raingauges on RainUnits.RainUnitID = Raingauges.RainUnitID) ' +
                  ' on Rainfall.RaingaugeID = Raingauges.RaingaugeID ' +
                  ' WHERE (((Rainfall.DateTime) >= #' +
                  antecedentStartString + '# And (Rainfall.DateTime)<=#' +
                  antecedentEndString + '#) AND ((Analyses.AnalysisID)= ' +
                  inttostr(analysisID) + '))';
//Feedback(queryStr);
      child_recSet := CoRecordSet.Create;
      child_recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      if child_recSet.EOF then begin
        line := line + '0     ';
      end else begin
        child_recSet.MoveFirst;
        if not VarIsNull(child_recSet.Fields.Item[0].value) then
          line := line + leftPad(floattostrF(child_recSet.Fields.Item[0].Value,ffFixed,15,2),6)
        else
          line := line + leftPad(floattostrF(0,ffFixed,15,2),6);
      end;
      child_recSet.Close;

      //Sum of AMD 14 days Volume
      antecedentStart := eventStart - 14;
      antecedentStartString :=  datetostr(antecedentStart) + ' ' + timetostr(antecedentStart);

      queryStr := 'SELECT Sum(Rainfall.Volume * RainUnits.ConversionFactor) AS SumOfVolume ' +
                  ' FROM (Analyses INNER JOIN Rainfall ON Analyses.RainGaugeID = Rainfall.RainGaugeID) ' +
                  ' inner join (RainUnits inner Join Raingauges on RainUnits.RainUnitID = Raingauges.RainUnitID) ' +
                  ' on Rainfall.RaingaugeID = Raingauges.RaingaugeID ' +
                  ' WHERE (((Rainfall.DateTime) >= #' +
                  antecedentStartString + '# And (Rainfall.DateTime)<=#' +
                  antecedentEndString + '#) AND ((Analyses.AnalysisID)= ' +
                  inttostr(analysisID) + '))';
//Feedback(queryStr);

      child_recSet := CoRecordSet.Create;
      child_recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      if child_recSet.EOF then begin
        line := line + leftPad(floattostrF(0,ffFixed,15,2),6);
      end else begin
        child_recSet.MoveFirst;
        if not VarIsNull(child_recSet.Fields.Item[0].value) then
          line := line + leftPad(floattostrF(child_recSet.Fields.Item[0].Value,ffFixed,15,2),6)
        else
          line := line + leftPad(floattostrF(0,ffFixed,15,2),6);
      end;
      child_recSet.Close;


      //Sum of AMD 21 days Volume
      antecedentStart := eventStart - 21;
      antecedentStartString :=  datetostr(antecedentStart) + ' ' + timetostr(antecedentStart);

      queryStr := 'SELECT Sum(Rainfall.Volume * RainUnits.ConversionFactor) AS SumOfVolume ' +
                  ' FROM (Analyses INNER JOIN Rainfall ON Analyses.RainGaugeID = Rainfall.RainGaugeID) ' +
                  ' inner join (RainUnits inner Join Raingauges on RainUnits.RainUnitID = Raingauges.RainUnitID) ' +
                  ' on Rainfall.RaingaugeID = Raingauges.RaingaugeID ' +
                  ' WHERE (((Rainfall.DateTime) >= #' +
                  antecedentStartString + '# And (Rainfall.DateTime)<=#' +
                  antecedentEndString + '#) AND ((Analyses.AnalysisID)= ' +
                  inttostr(analysisID) + '))';
//Feedback(queryStr);

      child_recSet := CoRecordSet.Create;
      child_recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      if child_recSet.EOF then begin
        line := line + leftPad(floattostrF(0,ffFixed,15,2),6);
      end else begin
        child_recSet.MoveFirst;
        if not VarIsNull(child_recSet.Fields.Item[0].value) then
          line := line + leftPad(floattostrF(child_recSet.Fields.Item[0].Value,ffFixed,15,2),6)
        else
          line := line + leftPad(floattostrF(0,ffFixed,15,2),6);
      end;
      child_recSet.Close;


        //R1, R2, R3, T1, T2, T3, K1, K2, K3
        line := line + leftPad(floattostrF(mother_recSet.Fields.Item[3].Value,ffFixed,15,2),6);
        line := line + leftPad(floattostrF(mother_recSet.Fields.Item[4].Value,ffFixed,15,2),6);
        line := line + leftPad(floattostrF(mother_recSet.Fields.Item[5].Value,ffFixed,15,2),6);
        line := line + leftPad(floattostrF(mother_recSet.Fields.Item[6].Value,ffFixed,15,1),6);
        line := line + leftPad(floattostrF(mother_recSet.Fields.Item[7].Value,ffFixed,15,1),6);
        line := line + leftPad(floattostrF(mother_recSet.Fields.Item[8].Value,ffFixed,15,1),6);
        line := line + leftPad(floattostrF(mother_recSet.Fields.Item[9].Value,ffFixed,15,1),6);
        line := line + leftPad(floattostrF(mother_recSet.Fields.Item[10].Value,ffFixed,15,1),6);
        line := line + leftPad(floattostrF(mother_recSet.Fields.Item[11].Value,ffFixed,15,1),6);

      Feedback(line);
      mother_recSet.MoveNext;
    end;
  end;
  mother_recSet.Close;

  feedback('');
  line := 'E = Event Number';
  feedback(line);
  line := 'ED = Event Date';
  feedback(line);
  line := 'R = Total R-Value';
  feedback(line);
  line := 'V = Total Rainfall Volume (inch)';
  feedback(line);
  line := 'D1 = RDII Event Duration (hour)';
  feedback(line);
  line := 'D2 = Rainfall Event Duration (hour)';
  feedback(line);
  line := 'I = Peak Rainfall Intensity (inch/hr)';
  feedback(line);
  line := 'A7 = Total Rainfall Volume (inch) - 7 days prior to the event)';
  feedback(line);
  line := 'A14 = Total Rainfall Volume (inch) - 14 days prior to the event)';
  feedback(line);
  line := 'A21 = Total Rainfall Volume (inch) - 21 days prior to the event)';
  feedback(line);
  line := 'R1, T1, K1 = RDII parameters for Fast Response';
  feedback(line);
  line := 'R2, T2, K2 = RDII parameters for Medium Response';
  feedback(line);
  line := 'R3, T3, K3 = RDII parameters for Slow Response';
  feedback(line);

end;




procedure statisticsForMultiRegressionThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(textToAdd);
end;

procedure statisticsForMultiRegressionThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;

end.
