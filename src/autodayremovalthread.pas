unit autodayremovalthread;

interface

uses
  Classes, modDatabase, ADODB_TLB, Variants, StormEvent;

const
  weekdays: set of 0..8 = [1,2,3,4,5];
  weekendsandholidays: set of 0..8 = [0,6,7];

type
  integerPointer = ^integer;
  realPointer = ^real;
  AutomaticDayRemovalThread = class(TThread)
    integerBuffer: integerPointer;
    realBuffer: realPointer;
    flowMeterName, raingaugeName, flowunit, textToAdd: String;
    rain: array[0..8] of real;
    previousTimestamp, timestamp: TDateTime;
    meterID, timestep, ndays, nlost, raingaugeID: integer;
    stda, meana, stdmax, meanmax, stdmin, meanmin: extended; //real;
    stdevs, maxa, mina, maxmax, minmax, maxmin, minmin: extended; //real;
    queryRecSet, tableRecSet: _RecordSet;
    fields, values: OleVariant;
    constructor CreateIt();
  private
    holidays: daysArray;
    function isHoliday(date: TDateTime): boolean;
    function dayOfWeekIndex(date: TDateTime): integer;
    procedure RemoveWeekdayDWFDays();
    procedure RemoveWeekendDWFDays();
    procedure Feedback(line: string);
    procedure ShowADOErrors(ErrorList: ADODB_TLB.Errors);
    procedure AddToFeedbackMemo();
    procedure UpdateStatus();
    procedure GetFlowMeterData();
    procedure GetThemHolidays();
    procedure GetRainfallTotal();
    procedure OpenFlowsQuery();
    procedure GetNextFlowRecord();
    procedure CloseFlowsQuery();
    procedure OpenDWFTable();
    procedure AddDWFRecord();
    procedure CloseDWFTable();
    procedure OutputStats();
    procedure CalculateWeekdayDWF();
    procedure CalculateWeekendDWF();

    procedure GetRaingaugeID();
    procedure GetDWFStatistics(flowMeterName, raingaugeName: string;
                               wdorwe: integer;
                               //rm 2010-04-27 stdevs: real;
                               stdevs: extended;
                               percentPoints: real;
                               dorainfall: boolean;
                               maxDayRain: array of real);
    procedure SelectDWFDays(flowMeterName, raingaugeName: string;
                            wdorwe: integer;
                            onlyGreater: boolean;
                            percentPoints: real;
                            dorainfall: boolean;
                            doStandardDev: boolean;
                            maxDayRain: array of real);

  protected
    procedure Execute; override;
  published
    destructor Destroy; override;

  end;

type
  realvalptr = ^realvalrec;
  realvalrec = record
                 val: real;
                 nextval: realvalptr;
               end;


var
  thisrunavg:realvalptr;
  avgarray: array of real;

implementation

uses graphics, windows, sysutils, autodayremoval, feedbackWithMemo, rdiiutils,
     mainform
     {$IFDEF VER140 } ,Variants {$ENDIF};

procedure initrunavg(numbrunavg: integer);
begin
  SetLength(avgarray,numbrunavg);
end;

//rm 2010-04-21 - more pecision here might help make more consistent results
//changing from real to extended
//function comprunavg(inval: real; numbrunavg: integer): extended; //real;
function comprunavg(inval: extended; numbrunavg: integer): extended; //real;
var
  i, nzero: integer;
  sum: extended; //real;
begin
  for i := 0 to numbrunavg - 2 do avgarray[i] := avgarray[i+1];
  avgarray[numbrunavg-1] := inval;
  sum := 0.0;
  nzero := 0;
  for i := 0 to numbrunavg - 1 do begin
    sum := sum + avgarray[i];
    if (avgarray[i] = 0.0) then inc(nzero);
  end;
  if (numbrunavg <> nzero)
    then comprunavg := sum / (numbrunavg - nzero)
    else comprunavg := 0.0;
end;

function AutomaticDayRemovalThread.isHoliday(date: TDateTime): boolean;
var
  i: integer;
begin
  isHoliday := false;
  for i := 0 to length(holidays) - 1 do begin
    if (trunc(date) = holidays[i]) then isHoliday := true;
  end;
end;

function AutomaticDayRemovalThread.dayOfWeekIndex(date: TDateTime): integer;
(* returns day of week 0 = sun, 1 = mon, 2 = tues..... 6 = saturday *)
(* holidays are returned as 7 *)
var
  dow: integer;
begin
  dow := dayofweek(date) - 1;
  if (isholiday(date)) then dow := 7;
  dayOfWeekIndex := dow;
end;

constructor AutomaticDayRemovalThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true;     // Thread Free Itself when terminated
  Suspended := false;          // Continue the thread
end;

destructor AutomaticDayRemovalThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure AutomaticDayRemovalThread.Execute;
var
  onlyGreater, dorainfall, doStandardDev: boolean;
  percentPoints: real;
  maxDayRain: array[0..7] of real;
begin
  flowMeterName := frmAutomaticDayRemoval.FlowMeterNameComboBox.Items.Strings[frmAutomaticDayRemoval.FlowMeterNameComboBox.ItemIndex];
  Synchronize(GetFlowMeterData);
  Synchronize(GetThemHolidays);
  {DO WEEKDAYS}
  if (frmAutomaticDayRemoval.WeekdaysCheckBox.Checked) then begin
    Synchronize(RemoveWeekdayDWFDays);
    stdevs := strtofloat(frmAutomaticDayRemoval.WeekdayStandardDeviationEdit.Text);
    onlyGreater := frmAutomaticDayRemoval.WeekdayOnlyGreaterCheckBox.Checked;
    if (frmAutomaticDayRemoval.WeekdayRemoveDaysMissingDataCheckBox.Checked) then begin
      if (Length(frmAutomaticDayRemoval.WeekdayMinimumPercentageEdit.Text) > 0)
        then percentPoints := strtofloat(frmAutomaticDayRemoval.WeekdayMinimumPercentageEdit.Text)
        else percentPoints := 0.0;
    end
    else begin
      percentPoints := 0.0;
    end;
    dorainfall := frmAutomaticDayRemoval.WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
    raingaugeName := frmAutomaticDayRemoval.WeekdayRaingaugeComboBox.Items.Strings[frmAutomaticDayRemoval.WeekdayRaingaugeComboBox.ItemIndex];
    Synchronize(GetRaingaugeID);
    if (length(frmAutomaticDayRemoval.WeekdayCurrentDayMaxRainEdit.Text) > 0)
      then maxDayRain[0] := strtofloat(frmAutomaticDayRemoval.WeekdayCurrentDayMaxRainEdit.Text)
      else maxDayRain[0] := 0.0;
    if (length(frmAutomaticDayRemoval.WeekdayPreviousDayMaxRainEdit.Text) > 0)
      then maxDayRain[1] := strtofloat(frmAutomaticDayRemoval.WeekdayPreviousDayMaxRainEdit.Text)
      else maxDayRain[1] := 0.0;
    if (length(frmAutomaticDayRemoval.WeekdayTwoDaysPreviousMaxRainEdit.Text) > 0)
      then maxDayRain[2] := strtofloat(frmAutomaticDayRemoval.WeekdayTwoDaysPreviousMaxRainEdit.Text)
      else maxDayRain[2] := 0.0;
    if (length(frmAutomaticDayRemoval.WeekdayThreeDaysPreviousMaxRainEdit.Text) > 0)
      then maxDayRain[3] := strtofloat(frmAutomaticDayRemoval.WeekdayThreeDaysPreviousMaxRainEdit.Text)
      else maxDayRain[3] := 0.0;
    if (length(frmAutomaticDayRemoval.WeekdayFourDaysPreviousMaxRainEdit.Text) > 0)
      then maxDayRain[4] := strtofloat(frmAutomaticDayRemoval.WeekdayFourDaysPreviousMaxRainEdit.Text)
      else maxDayRain[4] := 0.0;
    if (length(frmAutomaticDayRemoval.WeekdayFiveDaysPreviousMaxRainEdit.Text) > 0)
      then maxDayRain[5] := strtofloat(frmAutomaticDayRemoval.WeekdayFiveDaysPreviousMaxRainEdit.Text)
      else maxDayRain[5] := 0.0;
    if (length(frmAutomaticDayRemoval.WeekdaySixDaysPreviousMaxRainEdit.Text) > 0)
      then maxDayRain[6] := strtofloat(frmAutomaticDayRemoval.WeekdaySixDaysPreviousMaxRainEdit.Text)
      else maxDayRain[6] := 0.0;
    if (length(frmAutomaticDayRemoval.WeekdaySevenDaysPreviousMaxRainEdit.Text) > 0)
      then maxDayRain[7] := strtofloat(frmAutomaticDayRemoval.WeekdaySevenDaysPreviousMaxRainEdit.Text)
      else maxDayRain[7] := 0.0;


    Feedback('Determining Weekday Statistics...');
    GetDWFStatistics(flowMeterName,raingaugeName,1,stdevs,percentPoints,dorainfall,maxDayRain);
    Feedback('');
    Feedback('Eliminating Weekdays...');
    doStandardDev := frmAutomaticDayRemoval.WeekdayRemoveDaysStatisticallyCheckBox.Checked;
    SelectDWFDays(flowMeterName,raingaugeName,1,onlyGreater,percentPoints,dorainfall,doStandardDev,maxDayRain);
    try
      Synchronize(CalculateWeekdayDWF);
    except

    end;
  end;
  {DO WEEKENDS}
  if (frmAutomaticDayRemoval.WeekendCheckBox.Checked) then begin
    Synchronize(RemoveWeekendDWFDays);
    stdevs := strtofloat(frmAutomaticDayRemoval.WeekendStandardDeviationEdit.Text);
    onlyGreater := frmAutomaticDayRemoval.WeekendOnlyGreaterCheckBox.Checked;
    if (frmAutomaticDayRemoval.WeekendRemoveDaysMissingDataCheckBox.Checked) then begin
      if (Length(frmAutomaticDayRemoval.WeekendMinimumPercentageEdit.Text) > 0)
        then percentPoints := strtofloat(frmAutomaticDayRemoval.WeekendMinimumPercentageEdit.Text)
        else percentPoints := 0.0;
    end
    else begin
      percentPoints := 0.0;
    end;
    dorainfall := frmAutomaticDayRemoval.WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
    raingaugeName := frmAutomaticDayRemoval.WeekendRaingaugeComboBox.Items.Strings[frmAutomaticDayRemoval.WeekendRaingaugeComboBox.ItemIndex];
    Synchronize(GetRaingaugeID);
    if (length(frmAutomaticDayRemoval.WeekendCurrentDayMaxRainEdit.Text) > 0)
      then maxDayRain[0] := strtofloat(frmAutomaticDayRemoval.WeekendCurrentDayMaxRainEdit.Text)
      else maxDayRain[0] := 0.0;
    if (length(frmAutomaticDayRemoval.WeekendPreviousDayMaxRainEdit.Text) > 0)
      then maxDayRain[1] := strtofloat(frmAutomaticDayRemoval.WeekendPreviousDayMaxRainEdit.Text)
      else maxDayRain[1] := 0.0;
    if (length(frmAutomaticDayRemoval.WeekendTwoDaysPreviousMaxRainEdit.Text) > 0)
      then maxDayRain[2] := strtofloat(frmAutomaticDayRemoval.WeekendTwoDaysPreviousMaxRainEdit.Text)
      else maxDayRain[2] := 0.0;
    if (length(frmAutomaticDayRemoval.WeekendThreeDaysPreviousMaxRainEdit.Text) > 0)
      then maxDayRain[3] := strtofloat(frmAutomaticDayRemoval.WeekendThreeDaysPreviousMaxRainEdit.Text)
      else maxDayRain[3] := 0.0;
    if (length(frmAutomaticDayRemoval.WeekendFourDaysPreviousMaxRainEdit.Text) > 0)
      then maxDayRain[4] := strtofloat(frmAutomaticDayRemoval.WeekendFourDaysPreviousMaxRainEdit.Text)
      else maxDayRain[4] := 0.0;
    if (length(frmAutomaticDayRemoval.WeekendFiveDaysPreviousMaxRainEdit.Text) > 0)
      then maxDayRain[5] := strtofloat(frmAutomaticDayRemoval.WeekendFiveDaysPreviousMaxRainEdit.Text)
      else maxDayRain[5] := 0.0;
    if (length(frmAutomaticDayRemoval.WeekendSixDaysPreviousMaxRainEdit.Text) > 0)
      then maxDayRain[6] := strtofloat(frmAutomaticDayRemoval.WeekendSixDaysPreviousMaxRainEdit.Text)
      else maxDayRain[6] := 0.0;
    if (length(frmAutomaticDayRemoval.WeekendSevenDaysPreviousMaxRainEdit.Text) > 0)
      then maxDayRain[7] := strtofloat(frmAutomaticDayRemoval.WeekendSevenDaysPreviousMaxRainEdit.Text)
      else maxDayRain[7] := 0.0;




    Feedback('');
    Feedback('');
    Feedback('Determining Weekend Statistics...');
    GetDWFStatistics(flowMeterName,raingaugeName,2,stdevs,percentPoints,dorainfall,maxDayRain);
    Feedback('');
    Feedback('Eliminating Weekend days...');
    doStandardDev := frmAutomaticDayRemoval.WeekendRemoveDaysStatisticallyCheckBox.Checked;
    SelectDWFDays(flowMeterName,raingaugeName,2,onlyGreater,percentPoints,dorainfall,doStandardDev,maxDayRain);

    Synchronize(CalculateWeekendDWF);

  end;
  Finalize(holidays);
  Feedback('');
  Feedback('Computation Complete.  This window may be closed.');
end;

procedure AutomaticDayRemovalThread.GetDWFStatistics(flowMeterName, raingaugeName: string;
                           wdorwe: integer;
//rm 2010-04-27                           stdevs: real;
                           stdevs: extended;
                           percentPoints: real;
                           dorainfall: boolean;
                           maxDayRain: array of real);
//rm 2010-04-21 - Issue here with different computers (different CPUs) giving different results
//Possible causes include: Summing up a large number of Small difference between two large numbers?
//Summing up a large number of very small calculated values in low precision
//First attempt at a fix is to change intermediate variables from real to extended
//Real has 15 significant digits
//Extended has 19
var
  includedays: set of 1..8;
  i, count, dow, numbrunavg, minNumb: integer;
  rainDay, prevDay, prevMonth: word;
//rm 2010-04021  sum, fmax, fmin, runavg, flow, average: real;
  sum, fmax, fmin, runavg, flow, average: extended; //real;
  year, month, day, hour, minute, second, ms: word;
  keep: boolean;
begin
  case wdorwe of
    1 : includedays := weekdays;
    2 : includedays := weekendsandholidays;
  end;
//rm 2010-04-27 - change order of calculation here:
//  minNumb := trunc((1440 / timestep) * (percentPoints/100.0));
  minNumb := trunc((1440.0 * percentPoints) / (timestep * 100.0));
//rm 2007-11-06 - this is crashing at strtoint if Averaging Interval is < 1
//  numbrunavg := round(strtoint(frmAutomaticDayRemoval.AverageIntervalEdit.Text)*60/timestep);
  numbrunavg := round(strtofloat(frmAutomaticDayRemoval.AverageIntervalEdit.Text)*60/timestep);
  initrunavg(numbrunavg);


  count := 0;
  prevDay := 0;
  prevMonth := 0;
  previousTimestamp := 0;
  sum := 0;
  fmax := 0.0;
  fmin := 9999999.0;
  stda := 0.0;
  meana := 0.0;
  stdmax := 0.0;
  meanmax := 0.0;
  stdmin := 0.0;
  meanmin := 0.0;
  ndays := 0;
  nlost := 0;
  runavg := 0.0;
  for i := 0 to 8 do rain[i] := 0.0;
  rainDay := 0;

  Synchronize(OpenFlowsQuery);

  while (not queryRecSet.EOF) do begin
    timestamp := queryRecSet.Fields.Item[0].Value;
//Feedback('  ');
//Feedback(' time '+ datetimetostr(timestamp));
    Synchronize(UpdateStatus);
    DecodeDate(timestamp,year,month,day);
    DecodeTime(timestamp,hour,minute,second,ms);
    if ((dorainfall) and (day <> rainDay)) then begin
      rainDay := day;
      rain[8] := rain[7];
      rain[7] := rain[6];
      rain[6] := rain[5];
      rain[5] := rain[4];
      rain[4] := rain[3];
      rain[3] := rain[2];
      rain[2] := rain[1];
      rain[1] := rain[0];
      Synchronize(GetRainfallTotal);   // Sets new value of rain[0]
    end;
    flow := queryRecSet.Fields.Item[1].Value;
//Feedback(' flow '+ floattostrF(flow,ffFixed,8,5));
    if (flow > 0.0) then begin
      if (prevDay = 0) then prevDay := day;
      if (prevMonth = 0) then prevMonth := month;
      if (previousTimestamp = 0) then previousTimestamp := timestamp;
      if (day = prevDay) then begin
        runavg := comprunavg(flow,numbrunavg);
//Feedback('      runavg '+ floattostrF(runavg,ffFixed,8,5));
        if (runavg > fmax) then fmax := runavg;
        if (runavg < fmin) then fmin := runavg;
        sum := sum + flow;
//Feedback('      sum '+ floattostrF(sum,ffFixed,8,5));
        inc(count);
//Feedback('      count '+ inttostr(count));
      end
      else begin
        if (count > 0) then average := sum/count
                       else average := 0.0;
        keep := true;
        if (count < minNumb) then keep := false;
        dow := dayOfWeekIndex(previousTimestamp);
        if (not (dow in includedays)) then keep := false;
        if (dorainfall) then
          for i := 0 to 7 do if (rain[i+1] > maxdayrain[i]) then keep := false;
        if (keep) then begin
          stda := stda+sqr(average);
          meana := meana+average;
          stdmax := stdmax+sqr(fmax);
          meanmax := meanmax+fmax;
          stdmin := stdmin+sqr(fmin);
          meanmin := meanmin+fmin;
{
Feedback('      stda '+ floattostrF(stda,ffFixed,8,5));
Feedback('      meana '+ floattostrF(meana,ffFixed,8,5));
Feedback('      stdmax '+ floattostrF(stdmax,ffFixed,8,5));
Feedback('      meanmax '+ floattostrF(meanmax,ffFixed,8,5));
Feedback('      stdmin '+ floattostrF(stdmin,ffFixed,8,5));
Feedback('      meanmin '+ floattostrF(meanmin,ffFixed,8,5));
}
          inc(ndays);
        end
        else inc(nlost);
        count := 1;
        fmax := runavg;
        fmin := runavg;
        sum := flow;
        prevMonth := month;
        prevDay := day;
        previousTimestamp := timestamp;
      end;
    end;
    Synchronize(GetNextFlowRecord);
  end;
  Synchronize(CloseFlowsQuery);
  if (ndays > 1) then begin
    stda := sqrt((stda-(sqr(meana)/ndays))/(ndays-1));
    meana := meana/ndays;
    stdmax := sqrt((stdmax-(sqr(meanmax)/ndays))/(ndays-1));
    meanmax := meanmax/ndays;
    stdmin := sqrt((stdmin-(sqr(meanmin)/ndays))/(ndays-1));
    meanmin := meanmin/ndays;
  end
  else begin
    meana := 0.0;
    meanmax := 0.0;
    meanmin := 0.0;
  end;
  maxa := meana+stda*stdevs;
  mina := meana-stda*stdevs;
  maxmax := meanmax+stdmax*stdevs;
  minmax := meanmax-stdmax*stdevs;
  maxmin := meanmin+stdmin*stdevs;
  minmin := meanmin-stdmin*stdevs;

  OutputStats;

{
  Feedback(' SUMMARY OF SELECTION RANGE ');
  Feedback('                       MINIMUM ('+flowunit+')  MAXIMUM ('+flowunit+')');
  Feedback(' Daily Avg Range         '+ floattostrF(mina,ffFixed,8,5) +   '        ' + floattostrF(maxa,ffFixed,8,5));
  Feedback(' Daily Max Range         '+ floattostrF(minmax,ffFixed,8,5) + '        ' + floattostrF(maxmax,ffFixed,8,5));
  Feedback(' Daily Min Range         '+ floattostrF(minmin,ffFixed,8,5) + '        ' + floattostrF(maxmin,ffFixed,8,5));
 }
end;


procedure AutomaticDayRemovalThread.SelectDWFDays(
                           flowMeterName, raingaugeName: string;
                           wdorwe: integer;
                           onlyGreater: boolean;
                           percentPoints: real;
                           dorainfall: boolean;
                           doStandardDev: boolean;
                           maxDayRain: array of real);
var
  includedays: set of 1..8;
  dow, minNumb, i, count, numbrunavg: integer;
  rainDay, prevDay, prevMonth: word;
//rm 2010-05-03  average, flow, sum, fmax, fmin, runavg, sqrtArg: real;
  average, flow, sum, fmax, fmin, runavg, sqrtArg: extended;
  year, month, day, hour, minute, second, ms: word;
  keep: boolean;
begin
  case wdorwe of
    1 : includedays := weekdays;
    2 : includedays := weekendsandholidays;
  end;
  stda := 0.0;
  meana := 0.0;
  stdmax := 0.0;
  meanmax := 0.0;
  stdmin := 0.0;
  meanmin := 0.0;
  ndays := 0;
  nlost := 0;
  count := 0;
  prevDay := 0;
  prevMonth := 0;
  previousTimestamp := 0;
  sum := 0;
  fmax := 0.0;
  fmin := 9999999.0;
  runavg := 0.0;
  for i := 0 to 8 do rain[i] := 0.0;
  rainDay := 0;

  GetMem(integerBuffer,4);
  GetMem(realBuffer,4);

//rm 2010-04-27 - change order of calculation here:
//  minNumb := trunc((1440 / timestep) * (percentPoints/100.0));
//    Feedback('minNumb: ' + inttostr(minNumb));
  minNumb := trunc((1440.0 * percentPoints) / (timestep * 100.0));
//    Feedback('minNumb: ' + inttostr(minNumb));
//rm 2007-11-06 this is crashing at strtoint for averaging interval < 1
//  numbrunavg := round(strtoint(frmAutomaticDayRemoval.AverageIntervalEdit.Text)*60/timestep);
  numbrunavg := round(strtofloat(frmAutomaticDayRemoval.AverageIntervalEdit.Text)*60/timestep);

  Synchronize(OpenFlowsQuery);
  Synchronize(OpenDWFTable);

  while (not queryRecSet.EOF) do begin
    timestamp := queryRecSet.Fields.Item[0].Value;
    Synchronize(UpdateStatus);
    DecodeDate(timestamp,year,month,day);
    DecodeTime(timestamp,hour,minute,second,ms);

    //7/9/2011 - for testing purpose
    if (timestamp = 40733) then begin
      timestamp := timestamp;

    end;

    if ((dorainfall) and (day <> rainDay)) then begin
      rainDay := day;
      rain[8] := rain[7];
      rain[7] := rain[6];
      rain[6] := rain[5];
      rain[5] := rain[4];
      rain[4] := rain[3];
      rain[3] := rain[2];
      rain[2] := rain[1];
      rain[1] := rain[0];
      Synchronize(GetRainfallTotal);   // Sets new value of rain[0]
    end;
    flow := queryRecSet.Fields.Item[1].Value;
//    Feedback('      flow: '+ floattostrF(flow,ffFixed,8,5));
    if (flow > 0.0) then begin
      if (prevDay = 0) then prevDay := day;
      if (prevMonth = 0) then prevMonth := month;
      if (previousTimestamp = 0) then previousTimestamp := timestamp;
      if (day = prevDay) then begin
        runavg := comprunavg(flow,numbrunavg);
        if (runavg > fmax) then fmax := runavg;
        if (runavg < fmin) then fmin := runavg;
        sum := sum + flow;
        inc(count);

        // testing - at the end of the day
        if count = 288 then begin
          count := count;
        end
      end
      else begin
        if (count > 0) then average := sum/count
                       else average := 0.0;
    //Feedback(' day: ' + inttostr(year) + '/' + inttostr(month) + '/' + inttostr(day) + '   average: '+ floattostrF(average,ffFixed,8,5));
        keep := true;
        if (count < minNumb) then keep := false;
        dow := dayOfWeekIndex(previousTimestamp);
        if (not (dow in includedays)) then keep := false;
        if (dorainfall) then
          for i := 0 to 7 do if (rain[i+1] > maxdayrain[i]) then keep := false;
        if (doStandardDev) then begin
          if (average > maxa) then keep := false;
          if (fmax > maxmax) then keep := false;
          if (fmin > maxmin) then keep := false;
          if (not onlyGreater) then begin
            if (average < mina) then keep := false;
            if (fmax < minmax) then keep := false;
            if (fmin < minmin) then keep := false;
          end;
        end;
        if (keep) then begin
          Synchronize(AddDWFRecord);
          stda := stda + sqr(average);
          meana := meana + average;
          stdmax := stdmax + sqr(fmax);
          meanmax := meanmax + fmax;
          stdmin := stdmin + sqr(fmin);
          meanmin := meanmin + fmin;
          inc(ndays);
    //Feedback('ndays: ' + inttostr(nDays) + ' average: ' + floattostrF(average,ffFixed,8,5) + ' meana: ' + floattostrF(meana/ndays,ffFixed,8,5));
        end
        else inc(nlost);
        count := 1;
        fmax := runavg;
        fmin := runavg;
        sum := flow;
        prevMonth := month;
        prevDay := day;
        previousTimestamp := timestamp;
      end;
    end;
    Synchronize(GetNextFlowRecord);
  end;
  Synchronize(CloseFlowsQuery);
  Synchronize(CloseDWFTable);
  FreeMem(integerBuffer, 4);
  FreeMem(realBuffer,4);
  if (ndays > 1) then begin
    stda := sqrt((stda-(sqr(meana)/ndays))/(ndays-1));
    meana := meana / ndays;
    sqrtArg := (stdmax-(sqr(meanmax)/ndays))/(ndays-1);
    if (sqrtArg < 0.0) then sqrtArg := 0.0;
    stdmax := sqrt(sqrtArg);
    meanmax := meanmax / ndays;
    sqrtArg := (stdmin-(sqr(meanmin)/ndays))/(ndays-1);
    if (sqrtArg < 0.0) then sqrtArg := 0.0;
    stdmin := sqrt(sqrtArg);
    meanmin := meanmin / ndays;
  end
  else begin
    meana := 0.0;
    meanmax := 0.0;
    meanmin := 0.0;
  end;
  OutputStats();
end;

procedure AutomaticDayRemovalThread.RemoveWeekdayDWFDays();
begin
  DatabaseModule.RemoveWeekdayDWFDays(flowMeterName);
end;

procedure AutomaticDayRemovalThread.RemoveWeekendDWFDays();
begin
  DatabaseModule.RemoveWeekendDWFDays(flowMeterName);
end;

procedure AutomaticDayRemovalThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(textToAdd);
end;

procedure AutomaticDayRemovalThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;

procedure AutomaticDayRemovalThread.GetFlowMeterData();
begin
  meterID := DatabaseModule.GetMeterIDForName(flowMeterName);
  timestep := DatabaseModule.GetFlowTimestep(meterID);
  flowUnit := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
end;

procedure AutomaticDayRemovalThread.OpenFlowsQuery();
var
  queryStr: string;
begin
//rm 2010-05-04 - How about an "ORDER BY DATETIME" here?
//  queryStr := 'SELECT DateTime, Flow FROM Flows WHERE (MeterID = ' + inttostr(meterID) + ');';
  queryStr := 'SELECT DateTime, Flow FROM Flows WHERE (MeterID = ' + inttostr(meterID) + ')';
  queryStr := queryStr + ' ORDER BY DATETIME; ';
  queryRecSet := CoRecordSet.Create;
  queryRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if queryRecSet.EOF then
  else
    queryRecSet.MoveFirst;
end;

procedure AutomaticDayRemovalThread.GetRainfallTotal();
begin
  rain[0] := DatabaseModule.RainfallTotalForRaingaugeAndDay(raingaugeID,timestamp);
end;

procedure AutomaticDayRemovalThread.GetThemHolidays();
begin
  holidays := DatabaseModule.GetHolidays();
end;

procedure AutomaticDayRemovalThread.GetNextFlowRecord();
begin
  queryRecSet.MoveNext;
end;

procedure AutomaticDayRemovalThread.CloseFlowsQuery();
begin
  queryRecSet.Close;
end;

procedure AutomaticDayRemovalThread.UpdateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(timestamp);
end;

procedure AutomaticDayRemovalThread.OpenDWFTable();
begin
  tableRecSet := CoRecordSet.Create;
  tableRecSet.Open('DryWeatherFlowDays',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  fields := VarArrayCreate([1,3],varVariant);
  values := VarArrayCreate([1,3],varVariant);
  fields[1] := 'MeterID';
  fields[2] := 'DWFDate';
  fields[3] := 'Include';

  values[1] := meterID;
end;

procedure AutomaticDayRemovalThread.AddDWFRecord();
begin
  {CCC - 07/19/2011 - Fix the reported bug of selecting 1 day earlier for DWF}
  values[2] := int(previousTimestamp);
  //values[2] := int(timestamp);
  values[3] := 1;
  try
    tableRecSet.AddNew(fields,values);
  except
    ShowADOErrors(frmMain.Connection.Errors);
  end;
end;

procedure AutomaticDayRemovalThread.CloseDWFTable();
begin
  tableRecSet.Close;
end;

procedure AutomaticDayRemovalThread.OutputStats();
begin
  Feedback(' Number of days written = '+inttostr(ndays));
  Feedback(' Number of days lost    = '+inttostr(nlost));
  Feedback('                      AVERAGE ('+flowunit+')   STANDARD DEVIATION ('+flowunit+')');
  Feedback('Average Daily Flow      '+floattostrF(meana,ffFixed,8,4)+  '                  '+floattostrF(stda,ffFixed,8,4));
  Feedback('Maximum Daily Flow      '+floattostrF(meanmax,ffFixed,8,4)+'                  '+floattostrF(stdmax,ffFixed,8,4));
  Feedback('Minimum Daily Flow      '+floattostrF(meanmin,ffFixed,8,4)+'                  '+floattostrF(stdmin,ffFixed,8,4));
end;

procedure AutomaticDayRemovalThread.CalculateWeekdayDWF();
begin
  DatabaseModule.CalculateWeekdayDWF(meterID);
end;

procedure AutomaticDayRemovalThread.CalculateWeekendDWF();
begin
  DatabaseModule.CalculateWeekendDWF(meterID);
end;

procedure AutomaticDayRemovalThread.GetRaingaugeID();
begin
  raingaugeID := DatabaseModule.GetRaingaugeIDForName(raingaugeName);
end;

procedure AutomaticDayRemovalThread.ShowADOErrors(ErrorList: ADODB_TLB.Errors);
var
  I: Integer;
  E: ADODB_TLB.Error;
  S: String;
begin
  for i := 0 to ErrorList.Count - 1 do begin
    E := ErrorList[i];
    S := Format('ADO Error %d of %d:'#13#13'%s',
      [i+1,ErrorList.count,e.description]);
    Feedback(s+#13);
  end;
end;

end.
