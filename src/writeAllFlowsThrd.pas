unit writeAllFlowsThrd;

interface

uses
  Classes, Hydrograph, GWIAdjustmentCollection, StormEventCollection,
  StormEvent, Analysis, modDatabase, ADODB_TLB, Variants;

type
  WriteAllFlowsThread = class(TThread)
    analysisName, textToAdd: string;
    analysisID, meterID, raingaugeID, timestep, timestepsPerHour: integer;
    minWeekdayDWFIndex, minWeekendDWFIndex, segmentsPerDay: integer;
    gwiAdjustments: TGWIAdjustmentCollection;
    events: TStormEventCollection;
    weekdayDWFMinimum, weekendDWFMinimum, minbwwf, area: real;
    defaultR, defaultT, defaultK: array[0..2] of real;
    recSet: _RecordSet;
    timestamp: TDateTime;
    conversionToMGD, conversionToInches: real;
    //rm 2009-10-28 - now accommodating alternate area units
    conversionToAcres: double;
    //rm 2009-10-29 - now implementing initial abstraction in Version 1.0.1
    //defaultAM, defaultAR, defaultAI: double;
    //rm 2010-09-29 now extra initial abstaction terms
    defaultAM, defaultAR, defaultAI: array[0..2] of double;
    //defaultAM2, defaultAR2, defaultAI2: double;
    //defaultAM3, defaultAR3, defaultAI3: double;

    diurnal: diurnalCurves;
    constructor CreateIt();
  private
    analysis: TAnalysis;
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

uses windows, mainform, sysutils, dialogs, feedbackWithMemo, writeAllFlows
     {$IFDEF VER140 } ,Variants {$ENDIF}, Math;

function WriteAllFlowsThread.isHoliday(date: TDateTime): boolean;
var
  i: integer;
begin
  isHoliday := false;
  for i := 0 to length(holidays) - 1 do begin
    if (trunc(date) = holidays[i]) then isHoliday := true;
  end;
end;

function WriteAllFlowsThread.dayOfWeekIndex(date: TDateTime): integer;
(* returns day of week 0 = sun, 1 = mon, 2 = tues..... 6 = saturday *)
(* holidays are returned as 7 *)
var
  dow: integer;
begin
  dow := dayofweek(date) - 1;
  if (isholiday(date)) then dow := 7;
  dayOfWeekIndex := dow;
end;

constructor WriteAllFlowsThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true; // Thread Free Itself when terminated
  Suspended := false;         // Continue the thread
end;

destructor WriteAllFlowsThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure WriteAllFlowsThread.Execute;
const
  maxArray = 2200;
  conversionFromAcreInchesPerHourToMGD = (43560.0*7.481*24.0)/(12.0*1000000.0);
var
  F: TextFile;
  todayMinTimestamp, nextMinTimestamp, prevMinTimestamp: TDateTime;
  rain, flow, fbww, fgwi, fiandi: double; //real;
//rm 2009-10-02 - a new variable because "flow" is used twice:
rdiiflow: double;

  year,month,day,hour,minute,second,ms: word;
  i, j, todayMinIndex, nextMinIndex, prevMinIndex, counter, dow: integer;
  todayBWW, todayGWIAdjAtMin: double; //real;
  todayCGWIAtMin, nextBWW, nextGWIAdjAtMin, nextCGWIAtMin, ratio, cgwi: real;
  prevBWW, prevGWIAdjAtMin, prevCGWIAtMin, qpeak: double; //real;
  rdiiCurve: array of array of double; //real;
  //rdiiTotal: array of real;
  event: TStormEvent;
  R, T, K : array[0..2] of double; //real;
  filename: string;
  iprec: integer;
  dfctr: double;
//rm 2009-10-29 - initial abstraction
  //AM, AR, AI: double;
  //abstraction_available, abstraction_used, excess, recovery: double;
//rm 2010-09-29 - recast initial abstraction and include extra terms
  AM, AR, AI, AA, AU: array[0..2] of double;
  excess, recovery: double;
//rm 2010-10-15 - need to keep track of eventnum to apply initial abstraction correctly
  iEventNum, inEvent: integer;
begin
  filename := frmWriteAllFlows.FilenameEdit.Text;
  iprec := frmWriteAllFlows.GetPrecision;
  assignFile(F,filename);
  rewrite(F);
  SetLength(rdiiCurve,3,maxArray);
  //rm 2009-10-27
  for i := 0 to 2 do for j := 0 to maxArray - 1 do rdiiCurve[i,j] := 0.0;
//rm 2010-09-29  AM:=0;AR:=0;AI:=0;
  for i := 0 to 2 do begin
    AM[i] := 0;
    AR[i] := 0;
    AI[i] := 0;
    AA[i] := 0;
    AU[i] := 0;
  end;
  //SetLength(rdiiTotal,maxArray);
  Feedback('Determining Weekday and Weekend Flow DWF Hydrographs...');
  Synchronize(GetAnalysisData);
  Synchronize(GetThemHolidays);
  FeedbackLn('Done.');
  FeedbackLn('');
  Feedback('Writing output file...');
  Synchronize(OpenQuery);
  //writeln(F,'"month","day","year","hour","lotus date","obs flow","avg DWF","gwi adjustment","adjusted DWF","gwi flow","BWWF","iandi","curve 1","curve 2","curve 3","total"');
  //rm 2009-06-09 - Beta 1 review comment  - change BWWF to BWF
  //writeln(F,'"month","day","year","hour","minute","second","lotus date","obs flow","avg DWF","gwi adjustment","adjusted DWF","gwi flow","BWWF","iandi","curve 1","curve 2","curve 3","total"');
  writeln(F,'"month","day","year","hour","minute","second","lotus date","obs flow","avg DWF","gwi adjustment","adjusted DWF","gwi flow","BWF","iandi","curve 1","curve 2","curve 3","total"');
  counter := 0;
  //rm 2009-10-29 - initialize abstraction used to default:
  {
  abstraction_used := Min(defaultAM, defaultAI);
  abstraction_available := defaultAM - abstraction_used;
  abstraction_available := Max(abstraction_available, 0);
  }
  //rm 2010-09-29 - include additional initial abstraction terms

  recovery := 0;
  //rm 2010-10-15
  iEventNum := -1;
  inEvent := -1;
  while (not recSet.EOF) do begin
    timestamp := recSet.Fields.Item[0].Value;
    Synchronize(UpdateStatus);
    flow := recSet.Fields.Item[1].Value;
    if vartype(recSet.Fields.Item[2].Value) = varDouble
      then rain := recSet.Fields.Item[2].Value
      else rain := 0.0;

    DecodeDate(timestamp,year,month,day);
    DecodeTime(timestamp,hour,minute,second,ms);
    i := trunc((hour + (minute / 60.0)) / 24 * segmentsPerDay);
    dow := dayOfWeekIndex(timestamp);
    fbww := diurnal[dow,i];
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
    if (i >= todayMinIndex) then begin
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
//rm 2007-11-02 - may need to re-jig this if we want to include initial abstraction terms
//rm 2009-10-29 - modeling initial abstraction off SWM5 source (via iigraph.pas)
//rm 2010-10-15 - had to move this block abov "if rain > 0" to ensure the Drec is set propelrly
    if inEvent < 0 then begin
      for i := 0 to 2 do begin
        R[i] := defaultR[i];
        T[i] := defaultT[i];
        K[i] := defaultK[i];
      end;
      {
      //rm 2009-10-29 - initial abstraction
      AM := defaultAM;
      AR := defaultAR;
      AI := defaultAI;
      }
      //rm 2010-09-29 - set defaults picked up from Analysis Table - note defaults are 0 for AI for RTKS 2 and 3
      //AM[0] := defaultAM;
      //AR[0] := defaultAR;
      //AI[0] := defaultAI;
      //rm 2010-10-15 - do not reset Do (AI) to default every single timestep
      for i := 0 to 2 do begin
        AM[i] := defaultAM[i];
        AR[i] := defaultAR[i];
        //AI[i] := defaultAI[i];   - do not reset every timestep!
      end;
    end;
      inEvent := -1;
      for i := 0 to events.count - 1 do begin
        event := events.Items[i];
        if ((timestamp >= event.startDate) and (timestamp <= event.endDate)) then begin
          //rm 2010-10-15
          inEvent := 1;
          if i <> iEventNum then begin //Entering New Event - set event RTKs etc
//FeedbackLn('');
//FeedbackLn('Starting Event Number: ' + IntToStr(i) );
            iEventNum := i;
            if (event.R[0] > 0.0) or (event.R[1] > 0.0) or (event.R[2] > 0.0) then begin
              for j := 0 to 2 do begin
                R[j] := event.R[j];
                T[j] := event.T[j];
                K[j] := event.K[j];
              //end;
              //rm 2010-09-29 - initial abstraction extra terms
              //for j := 0 to 2 do begin
                AM[j] := event.AM[j+1]; //Dmax
                AR[j] := event.AR[j+1]; //Drec
                AI[j] := event.AI[j+1]; //Do
                AU[j] := AI[j];         //abstraction used
              end;
            end;
{
FeedbackLn('');
FeedbackLn('R1 = ' + floattostrF(R[0],ffFixed,15,3));
FeedbackLn('R2 = ' + floattostrF(R[1],ffFixed,15,3));
FeedbackLn('R3 = ' + floattostrF(R[2],ffFixed,15,3));
FeedbackLn('Dmax1 = ' + floattostrF(AM[0],ffFixed,15,3));
FeedbackLn('Dmax2 = ' + floattostrF(AM[1],ffFixed,15,3));
FeedbackLn('Dmax3 = ' + floattostrF(AM[2],ffFixed,15,3));
FeedbackLn('Drec1 = ' + floattostrF(AR[0],ffFixed,15,3));
FeedbackLn('Drec2 = ' + floattostrF(AR[1],ffFixed,15,3));
FeedbackLn('Drec3 = ' + floattostrF(AR[2],ffFixed,15,3));
FeedbackLn('Do1 = ' + floattostrF(AI[0],ffFixed,15,3));
FeedbackLn('Do2 = ' + floattostrF(AI[1],ffFixed,15,3));
FeedbackLn('Do3 = ' + floattostrF(AI[2],ffFixed,15,3));
FeedbackLn('');
}
          end;
        end;
      end;
    if (rain > 0) then begin
{//rm 2010-10-15 - had to move this block
      for i := 0 to 2 do begin
        R[i] := defaultR[i];
        T[i] := defaultT[i];
        K[i] := defaultK[i];
      end;

      //rm 2009-10-29 - initial abstraction
      AM := defaultAM;
      AR := defaultAR;
      AI := defaultAI;

      //rm 2010-09-29 - set defaults picked up from Analysis Table - note defaults are 0 for AI for RTKS 2 and 3
      //AM[0] := defaultAM;
      //AR[0] := defaultAR;
      //AI[0] := defaultAI;
      //rm 2010-10-15 - do not reset Do (AI) to default every single timestep
      for i := 0 to 2 do begin
        AM[i] := defaultAM[i];
        AR[i] := defaultAR[i];
        //AI[i] := defaultAI[i];
      end;

      for i := 0 to events.count - 1 do begin
        event := events.Items[i];
        if ((timestamp >= event.startDate) and (timestamp <= event.endDate)) then begin
          //rm 2010-10-15
          if i <> iEventNum then begin
            iEventNum := i;
            if (event.R[0] > 0.0) then begin
              for j := 0 to 2 do begin
                R[j] := event.R[j];
                T[j] := event.T[j];
                K[j] := event.K[j];
              end;
              //rm 2010-09-29 - initial abstraction extra terms
              for j := 0 to 2 do begin
                AM[j] := event.AM[j+1];
                AR[j] := event.AR[j+1];
                AI[j] := event.AI[j+1];
              end;
            end;

          end;
        end;
      end;
}
      //rm 2009-10-29 - no recovery during rain
      recovery := 0;
//ia = UnitHyd[j].ia[m][IA_MAX] - UHData[j].iaUsed;
//ia = MAX(ia, 0.0);
//rm 2010-09-29
{
      abstraction_used := Min(abstraction_used, AM);
      abstraction_available := AM - abstraction_used;
      abstraction_available := Max(abstraction_available, 0.0);
}
// --- reduce rain depth by unused IA
//netRainDepth = rainDepth - ia;
{
      excess := rain - abstraction_available;
      excess := Max(excess, 0.0);
}
//netRainDepth = MAX(netRainDepth, 0.0);
// --- update amount of IA used up
//ia = rainDepth - netRainDepth;
//UHData[j].iaUsed += ia;
{
      abstraction_used := abstraction_used + rain - excess;
}
//rm 2010-09-29      if excess > 0 then
      for i := 0 to 2 do begin
        if ((R[i] > 0.0) and (T[i] > 0.0)) then begin
          AU[i] := Min(AU[i], AM[i]);
          AA[i] := AM[i] - AU[i];
          AA[i] := Max(AA[i], 0.0);
          excess := rain - AA[i];
          excess := Max(excess, 0.0);
          AU[i] := AU[i] + rain - excess;
          if excess > 0 then begin
//            qpeak := R[i]*2.0*area/(T[i]*(1.0+K[i]))
//                     *conversionFromAcreInchesPerHourToMGD
//                     /conversionToMGD
//                     *conversionToInches
//                     *conversionToAcres;
            qpeak := R[i]/(T[i]*(1.0+K[i])) * excess; //rain;
            for j := 0 to trunc(T[i] * (K[i] + 1.0) * timestepsPerHour) do begin
              if (j <= T[i] * timestepsPerHour)
                then rdiiflow := (j / (T[i] * timestepsPerHour)) * qpeak
                else rdiiflow := (1.0 - ((j-(T[i]*timestepsPerHour) )/(K[i]*T[i]*timestepsPerHour))) * qpeak;
              //if (rdiiflow < 0.0) then rdiiflow := 0.0;
              if (rdiiflow > 0) then
                rdiiCurve[i,j] := rdiiCurve[i,j] + rdiiflow;
            end;
          end;
        end;
      end;
    end else begin //no rain - recover some abstraction volume
// --- recover a portion of the IA already used
//UHData[j].iaUsed -= dt / 86400. * UnitHyd[j].ia[m][IA_REC];
//UHData[j].iaUsed = MAX(UHData[j].iaUsed, 0.0);
      excess := 0;
      {
      recovery := ((timestep/1440.0) * AR);
      abstraction_used := abstraction_used - recovery;
      abstraction_used := max(abstraction_used, 0.0);
      }
      for i := 0 to 2 do begin
        recovery := ((timestep/1440.0) * AR[i]);
        AU[i] := AU[i] - recovery;
        AU[i] := Max(AU[i], 0);
      end;
    end;
    write(F,month,',');
    write(F,day,',');
    write(F,year,',');

    write(F,inttostr(hour),',');
    write(F,inttostr(minute),',');
    write(F,inttostr(second),',');

//rm 2009-11-03 - not enough precision    write(F,floattostrF(timestamp,ffFixed,8,3),',');
    write(F,floattostrF(timestamp,ffFixed,15,8),',');
    write(F,floattostrF(flow,ffFixed,12,iprec),',');
    write(F,floattostrF(fbww,ffFixed,12,iprec),',');
    write(F,floattostrF(fgwi,ffFixed,12,iprec),',');
    write(F,floattostrF(fbww+fgwi,ffFixed,12,iprec),',');
    write(F,floattostrF(cgwi,ffFixed,12,iprec),',');
    write(F,floattostrF(fbww+fgwi-cgwi,ffFixed,12,iprec),',');
    write(F,floattostrF(fiandi,ffFixed,12,iprec),',');

    dfctr := 2.0 * area * conversionFromAcreInchesPerHourToMGD
      * conversionToInches / conversionToMGD * conversionToAcres;

    write(F,floattostrF(rdiiCurve[0,0] * dfctr,ffFixed,12,iprec),',');
    write(F,floattostrF(rdiiCurve[1,0] * dfctr,ffFixed,12,iprec),',');
    write(F,floattostrF(rdiiCurve[2,0] * dfctr,ffFixed,12,iprec),',');
    write(F,floattostrF((rdiiCurve[0,0]+rdiiCurve[1,0]+rdiiCurve[2,0]) * dfctr,ffFixed,12,iprec),',');
    //write(F,floattostrF(rain,ffFixed,8,iprec),',');
    writeln(F);
    inc(counter);
    for i := 0 to maxArray - 2 do begin
      rdiiCurve[0,i] := rdiiCurve[0,i+1];
      rdiiCurve[1,i] := rdiiCurve[1,i+1];
      rdiiCurve[2,i] := rdiiCurve[2,i+1];
    end;
    rdiiCurve[0,maxArray - 1] := 0.0;
    rdiiCurve[1,maxArray - 1] := 0.0;
    rdiiCurve[2,maxArray - 1] := 0.0;
    Synchronize(NextRecord);

  end;
  Synchronize(CloseAndFreeQuery);
  Finalize(holidays);
  closeFile(F);
  FeedbackLn('Done.');
  FeedbackLn('');
  FeedbackLn(inttostr(counter)+' records written to '+filename);
  FeedbackLn('');
  Feedback('Export Complete.  This window may be closed.');
end;

procedure WriteAllFlowsThread.GetAnalysisData();
var
  flowMeterName, raingaugeName, queryStr: String;
  i: integer;
  weekdayDWF, weekendDWF: THydrograph;
  localRecSet: _RecordSet;
begin
  analysisName := frmWriteAllFlows.AnalysisNameComboBox.Text;
  analysis := DatabaseModule.GetAnalysis(analysisName);
  analysisID := analysis.AnalysisID;
  meterID := analysis.FlowMeterID;
  raingaugeID := analysis.RaingaugeID;

  diurnal := DatabaseModule.GetDiurnalCurves(analysisName);
  minbwwf := DatabaseModule.GetBaseFlowRateForAnalysis(analysisName);
  flowMeterName := DatabaseModule.GetFlowMeterNameForAnalysis(analysisName);
  raingaugeName := DatabaseModule.GetRaingaugeNameForAnalysis(analysisName);
  gwiAdjustments := DatabaseModule.GetGWIAdjustments(analysisID);
  area := DatabaseModule.GetAreaForAnalysis(analysisName);

  //rm 2010-05-06
  //round datetimes to nearest minute or the Quick join will fail
  DatabaseModule.RoundDateTimesToNearestMinute('Flows');
  DatabaseModule.RoundDateTimesToNearestMinute('Rainfall');

  events := DatabaseModule.GetEvents(analysisID);
  timestep := DatabaseModule.GetFlowTimestep(meterID);
(* Get the conversion rates for the flow and rain and area values *)
  conversionToMGD := DatabaseModule.GetConversionForMeter(meterID);
  conversionToInches := DatabaseModule.GetConversionForRaingauge(raingaugeID);
  conversionToAcres := DatabaseModule.GetConversionToAcresForMeter('',meterID);

  weekdayDWF := DatabaseModule.GetWeekdayDWF(meterID);
  weekendDWF := DatabaseModule.GetWeekendDWF(meterID);
  minWeekdayDWFIndex := weekdayDWF.indexOfMinimum;
  minWeekendDWFIndex := weekendDWF.indexOfMinimum;
  weekdayDWFMinimum := weekdayDWF.Minimum;
  weekendDWFMinimum := weekendDWF.Minimum;
  weekdayDWF.Free;
  weekendDWF.Free;

  segmentsPerDay := 1440 div timeStep;
  timestepsPerHour := 60 div timestep;

//rm 2009-10-29 - let's implement initial abstraction here in Version 1.0.1
//  queryStr := 'SELECT R1, R2, R3, T1, T2, T3, K1, K2, K3 FROM Analyses WHERE ' +
  queryStr := 'SELECT R1, R2, R3, T1, T2, T3, K1, K2, K3, ' +
              ' MaxDepressionStorage, RateOfReduction, InitialValue, ' +
//rm 2010-10-07
              ' MaxDepressionStorage2, RateOfReduction2, InitialValue2, ' +
              ' MaxDepressionStorage3, RateOfReduction3, InitialValue3 ' +
//rm
              ' FROM Analyses WHERE ' +
              '(AnalysisID = ' + inttostr(analysisID) + ');';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  localRecSet.MoveFirst;
  for i := 0 to 2 do begin
    defaultR[i] := localRecSet.Fields.Item[i].Value;
    defaultT[i] := localRecSet.Fields.Item[3+i].Value;
    defaultK[i] := localRecSet.Fields.Item[6+i].Value;
  end;
  //rm 2009-10-29 - the initial abstraction terms
  if VarIsNull(localRecSet.Fields.Item[9].Value) then
    defaultAM[0] := 0.0
  else
    defaultAM[0] := localRecSet.Fields.Item[9].Value;
  if VarIsNull(localRecSet.Fields.Item[10].Value) then
    defaultAR[0] := 0.0
  else
    defaultAR[0] := localRecSet.Fields.Item[10].Value;
  if VarIsNull(localRecSet.Fields.Item[11].Value) then
    defaultAI[0] := 0.0
  else
    defaultAI[0] := localRecSet.Fields.Item[11].Value;

  //rm 2010-10-07 - the NEW initial abstraction terms
  if VarIsNull(localRecSet.Fields.Item[12].Value) then
    defaultAM[1] := 0.0
  else
    defaultAM[1] := localRecSet.Fields.Item[12].Value;
  if VarIsNull(localRecSet.Fields.Item[13].Value) then
    defaultAR[1] := 0.0
  else
    defaultAR[1] := localRecSet.Fields.Item[13].Value;
  if VarIsNull(localRecSet.Fields.Item[14].Value) then
    defaultAI[1] := 0.0
  else
    defaultAI[1]:= localRecSet.Fields.Item[14].Value;
  if VarIsNull(localRecSet.Fields.Item[15].Value) then
    defaultAM[2] := 0.0
  else
    defaultAM[2] := localRecSet.Fields.Item[15].Value;
  if VarIsNull(localRecSet.Fields.Item[16].Value) then
    defaultAR[2] := 0.0
  else
    defaultAR[2] := localRecSet.Fields.Item[16].Value;
  if VarIsNull(localRecSet.Fields.Item[17].Value) then
    defaultAI[2] := 0.0
  else
    defaultAI[2]:= localRecSet.Fields.Item[17].Value;

  localRecSet.Close;
end;

procedure WriteAllFlowsThread.OpenQuery();
var
  startDateTime, endDateTime: TDateTime;
  queryStr: string;
begin
  startDateTime := frmWriteAllFlows.StartDatePicker.Date +
                   frac(frmWriteAllFlows.StartTimePicker.Time);
  endDateTime := frmWriteAllFlows.EndDatePicker.Date +
                 frac(frmWriteAllFlows.EndTimePicker.Time);
//rm 2009-05-19 -  this is not working where there are multiple raingauges and one raingauge has rain where the other does not
//  queryStr := 'SELECT Flows.DateTime, Flows.Flow, Rainfall.Volume FROM Flows ' +
//              'LEFT OUTER JOIN Rainfall ON (Flows.DateTime = Rainfall.DateTime) ' +
//              'WHERE ((MeterID = ' + inttostr(meterID) + ') AND ' +
//              '(Flows.DateTime >= ' + floattostr(startDateTime) + ' AND ' +
//              'Flows.DateTime <= ' + floattostr(endDateTime) + ') AND ' +
//              '(Rainfall.RaingaugeID = ' + inttostr(raingaugeID) + ' OR ' +
//              '(ISNULL(Rainfall.RaingaugeID)))) order by Flows.DateTime;';
  querystr := 'Select DateTime, Flow, Max(Volume) from ' +
                ' (SELECT Flows.DateTime, Flows.Flow, Rainfall.Volume ' +
//rm 2010-05-06 - the "loose" join is just way too slow.
//the problem was imprecise datetimes - we are now rounding all datetimes to the nearest minute
//so the old join will work now . . . .
////rm 2009-10-28 - there may be some imprecision in datetimes making this join unreliable:
////                ' FROM Flows INNER JOIN Rainfall ON Flows.DateTime = Rainfall.DateTime ' +
//                ' FROM Flows INNER JOIN Rainfall ON ' +
//// loosen the tolerance on the DateTime join to about a minute: (0.0006944444 days)
//                ' Abs(Flows.DateTime - Rainfall.DateTime) < 0.0006 ' +
////                ' Round(1440*Flows.DateTime) = Round(1440*Rainfall.DateTime) ' +
////                ' Flows.DateTime = Rainfall.DateTime ' +
                ' FROM Flows INNER JOIN Rainfall ON ' +
                ' Flows.DateTime = Rainfall.DateTime ' +
                ' WHERE ((Flows.DateTime>= ' + floattostr(startDateTime) +
                ' AND Flows.DateTime<= ' + floattostr(endDateTime) + ') ' +
                ' AND ((Rainfall.RainGaugeID= ' + inttostr(raingaugeID) + ') ' +
                ' AND (Flows.MeterID= ' + inttostr(meterID) + '))) ' +
                ' UNION ALL ' +
                ' SELECT Flows.DateTime, Flows.Flow, 0 as Volume ' +
                ' FROM Flows ' +
                ' WHERE ((Flows.DateTime>= ' + floattostr(startDateTime) +
                ' And Flows.DateTime<= ' + floattostr(endDateTime) + ') ' +
                ' AND (Flows.MeterID=' + inttostr(meterID) + '))) ' +
                ' Group by DateTime, Flow ';
//rm 2009-10-02
//FeedbackLn(querystr);

  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //rm 2007-10-18
  if not recSet.EOF then
    recSet.MoveFirst;
end;

procedure WriteAllFlowsThread.NextRecord();
begin
  recSet.MoveNext;
end;

procedure WriteAllFlowsThread.CloseAndFreeQuery();
begin
  if (recSet.State <> adStateClosed) then recSet.Close;
end;

procedure WriteAllFlowsThread.UpdateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(timestamp);
end;

procedure WriteAllFlowsThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Text := frmFeedbackWithMemo.feedbackMemo.Text+textToAdd;
  frmFeedbackWithMemo.feedbackMemo.SelStart := Length(frmFeedbackWithMemo.feedbackMemo.Text)
end;

procedure WriteAllFlowsThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;

procedure WriteAllFlowsThread.FeedbackLn(line: string);
begin
  textToAdd := line+#13+#10;
  Synchronize(AddToFeedbackMemo);
end;

procedure WriteAllFlowsThread.GetThemHolidays();
begin
  holidays := DatabaseModule.GetHolidays();
end;

end.
