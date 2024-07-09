unit rainfallConverterImportThread;

interface

uses
  Classes, ADODB_TLB, Variants;

type
  integerPointer = ^integer;
  realPointer = ^real;
  ConverterImportThread = class(TThread)
    textToAdd, sourceUnitLabel: string;
    integerBuffer: integerPointer;
    realBuffer: realPointer;
    raingaugeUnit: integer;
    monthColumn, monthWidth: integer;
    yearColumn, yearWidth: integer;
    dayColumn, dayWidth: integer;
    hourColumn, hourWidth: integer;
    minuteColumn, minuteWidth: integer;
    codeColumn, codeWidth: integer;
    rainColumn, rainWidth: integer;
    militaryTime: boolean;
    ampmColumn: integer;
    date: TDateTime;
    raingaugeName, tableFormat, rainUnitLabel: String;
    raingaugeID, timestep, code, linesToSkip: integer;
    rain, conversionFactor: real;
    recSet: _RecordSet;
    fields, values: OleVariant;
    constructor CreateIt();
  private { Private declarations }
    procedure GetRaingaugeInfo();
    procedure GetConverterInfo();
    procedure OpenRainfallTable();
    procedure UpdateCurrentRainfallRecord();
    procedure AddRainfallRecord();
    procedure CloseAndFreeRainfallTable();
    procedure UpdateMinMaxTimes();
    procedure UpdateStatus();
    procedure AddToFeedbackMemo();
    procedure FeedbackLn(line: string);
    procedure ShowADOErrors(ErrorList: ADODB_TLB.Errors);
    //rm 2009-06-03 Add a record to the import log table
    procedure AddImportLogRecord;
    //rm 2009-06-12 Validate rainfall for gauge
    procedure Validate;
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
  end;

implementation

//rm 2007-10-31
//1) Abort if more than 100 errors in first 200 lines (usu. a problem with converter)
//2) Always add record for first line of data - even if it is zero.
//      (there is a difference between missing data and zero)
//rm 2008-10-09
//3) Always add record for last line of data - even if it is zero.


uses windows, sysutils, mainform, feedbackWithMemo, importRainData,
     modDatabase, rdiiutils
    {$IFDEF VER140 } ,Variants {$ENDIF};

constructor ConverterImportThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true; // Thread Free Itself when terminated
  Suspended := false;         // Continue the thread
end;

destructor ConverterImportThread.Destroy;
begin
   PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
   inherited destroy;
end;

procedure ConverterImportThread.Execute;
const
  maxFields = 50;
  totalMaximums = 5;
var
  previousRain, duration, totRain, average, dryHours: real;
  minimumDate, maximumDate, previousDate: TDateTime;
  F: TextFile;
  fullline, line, AMPM, outString: String;
  lineCounter, recordCounter, month, year, day, hour, minute: integer;
  errorCounter:integer;
  i, j, fieldCount, separatorPosition: integer;
  substrings: array[1..maxFields] of String;
  maxRains, maxHours: array[1..totalMaximums] of real;
  maxRainDates, maxHoursDates: array[1..totalMaximums] of TDateTime;
  include: boolean;
  earliestDate, latestDate: TDateTime;
  //rm 2007-10-31
  boAborted, boFirstRecord: boolean;
begin
  boAborted := false;
  boFirstRecord := true;
  Feedbackln('Starting import...');
  earliestDate := 0.0;
  latestDate := 0.0;
  previousDate := 0.0;
  previousRain := 0;
  totRain := 0.0;
  for i := 1 to 5 do begin
    maxRains[i] := 0.0;
    maxHours[i] := 0.0;
    maxRainDates[i] := 0.0;
    maxHoursDates[i] := 0.0;
  end;
  GetMem(integerBuffer,4);
  GetMem(realBuffer,4);

  raingaugeName := frmImportRainDataUsingConverter.RaingaugeNameComboBox.Items.Strings[frmImportRainDataUsingConverter.RaingaugeNameComboBox.ItemIndex];
   { must use frac() below because .Time includes the date portion}
  minimumDate := trunc(frmImportRainDataUsingConverter.StartDatePicker.DateTime) + frac(frmImportRainDataUsingConverter.StartTimePicker.Time);
  maximumDate := trunc(frmImportRainDataUsingConverter.EndDatePicker.DateTime) + frac(frmImportRainDataUsingConverter.EndTimePicker.Time);

  Synchronize(GetRaingaugeInfo);
  Synchronize(GetConverterInfo);
  Synchronize(OpenRainfallTable);

  AssignFile(F, frmImportRainDataUsingConverter.FilenameEdit.Text);
//rm 2009-06-11 - Beta 1 review comment - if file open by Excel or something - this bombs
  try
    Reset(F);
  except
    on E: Exception do begin
      //rm - Raising here causes cascade of error messages
      //maybe due to threading???
      //Raise E;
      Feedbackln('');
      Feedbackln('Error opening file.');
      Feedbackln(E.Message);
      Feedbackln('');
      Feedbackln('Rainfall import was not successful. Please see if the file is open by another application.');
      Feedbackln('');
      Feedbackln('This window may be closed.');
      Feedbackln('');
      exit;
    end;
  end;
//rm
  lineCounter := linesToSkip;
  recordCounter := 0;
  errorCounter := 0;
  try
    for i := 1 to linesToSkip do readln(F);
    while (not eof(F)) do begin
      inc(lineCounter);
      readln(F,fullline);
      try
        if (tableFormat = 'C/W') then begin   {FILE IS COLUMN/WIDTH FORMAT}
          month := strtoint(copy(fullline,monthColumn,monthWidth));
          year := strtoint(copy(fullline,yearColumn,yearWidth));
          day := strtoint(copy(fullline,dayColumn,dayWidth));
          hour := strtoint(copy(fullline,hourColumn,hourWidth));
          if (minuteColumn > 0)
            then minute := strtoint(copy(fullline,minuteColumn,minuteWidth))
            else minute := 0;
          rain := strtofloat(copy(fullline,rainColumn,rainWidth));
          if (codeColumn > 0)
            then code := strtoint(copy(fullline,codeColumn,codeWidth))
            else code := 1;
          if (not militaryTime) then AMPM := copy(fullline,ampmColumn,1);
        end
        else begin {FILE IS CSV FORMAT}
          line := AnsiUpperCase(fullline);
          for i := 1 to length(line) do begin
            //rm 2007-10-22 - add tab chr(9) to this list
            //if line[i] in ['A'..'Z','\','/',':','"',chr(39),'_',',',#160,Chr(9)] then line[i] := ',';
            //rm 2009-06-04 - remove the 'A'..'Z' and '_' and quotes from this list
            if line[i] in ['\','/',':',',',#160,Chr(9)] then line[i] := ',';
          end;
          line := TrimLeft(line);
          line := TrimRight(line);
          fieldCount := 0;
          //separatorPosition := Pos(' ',line);
          separatorPosition := Pos(',',line);
          while ((separatorPosition > 0) and (fieldCount < maxFields)) do begin
            inc(fieldCount);
            subStrings[fieldCount] := copy(line,1,separatorPosition-1);
            line := copy(line,separatorPosition+1,length(line)-separatorPosition+1);
            line := TrimLeft(line);
            //separatorPosition := Pos(' ',line);
            separatorPosition := Pos(',',line);
          end;
          if (fieldCount < maxFields) then substrings[fieldCount+1] := line;
          month := strtoint(substrings[monthColumn]);
          year := strtoint(substrings[yearColumn]);
          day := strtoint(substrings[dayColumn]);
          hour := strtoint(substrings[hourColumn]);
          minute := strtoint(substrings[minuteColumn]);
          rain := strtofloat(substrings[rainColumn]);
//          if (codeColumn > 0)
//            then code := strtoint(substrings[codeColumn])
//            else code := 1;
          if (codeColumn > 0) then begin
          //rm 2007-10-2
            if (Length(substrings[codeColumn])>0) then
              code := strtoint(substrings[codeColumn])
              else code := 1;
          end else code := 1;
          if (not militaryTime) then AMPM := substrings[ampmColumn];
        end;
        if (year < 50)
          then year := year + 2000
          else if (year < 99) then year := year + 1900;
        AMPM := AnsiUppercase(AMPM);
        if ((copy(AMPM,1,1) = 'P') and (hour < 12)) then hour := hour + 12;
        if ((copy(AMPM,1,1) = 'A') and (hour = 12)) then hour := hour - 12;
        date := EncodeDate(year,month,day)+EncodeTime(hour,minute,0,0);
//this is designed to round datetime to nearest timestep:
        date := trunc((date/(timestep/1440.0))+0.5)*(timestep/1440.0);
//this is designed to round datetime to nearest minute:
        date := trunc((date*1440) + 0.5)/1440;

        if ((earliestDate = 0) or (date < earliestDate)) then earliestDate := date;
        if ((latestDate = 0) or (date > latestDate)) then latestDate := date;
        Synchronize(updateStatus);
        include := true;
        if ((frmImportRainDataUsingConverter.StartDateTimeCheckBox.Enabled) and ((frmImportRainDataUsingConverter.StartDateTimeCheckBox.checked) and (date < minimumDate))) then include := false;
        if ((frmImportRainDataUsingConverter.EndDateTimeCheckBox.Enabled) and ((frmImportRainDataUsingConverter.EndDateTimeCheckBox.checked) and (date > maximumDate))) then include := false;
        if (rain = 0.0) then include := false;
        //if (include) then begin
        if (include or boFirstRecord) then begin
          boFirstRecord := false;
          rain := rain / conversionFactor;
          totRain := totRain + rain;

          i := 0;
          repeat
            inc(i);
          until (i = totalMaximums) or (rain > maxRains[i]);
          if (rain > maxRains[i]) then begin
            for j := 5 downto (i+1) do begin
              maxRains[j] := maxRains[j-1];
              maxRainDates[j] := maxRainDates[j];
            end;
            maxRains[i] := rain;
            maxRainDates[i] := date;
          end;

          if (previousDate > 0.0)
            then dryhours := date - previousDate
            else dryhours := 0.0;
          i := 0;
          repeat
            inc(i);
          until (i = totalMaximums) or (dryHours > maxHours[i]);
          if (dryHours > maxHours[i]) then begin
            for j := 5 downto (i+1) do begin
              maxHours[j] := maxHours[j-1];
              maxHoursDates[j] := maxHoursDates[j];
            end;
            maxHours[i] := dryHours;
            maxHoursDates[i] := date;
          end;

          if (abs(date - previousDate) < 0.0005) then begin
            if (not frmImportRainDataUsingConverter.FirstValueRadioButton.Checked) then begin
              if (frmImportRainDataUsingConverter.AverageFlowsRadioButton.Checked) then
                 rain := (rain + previousRain) * 0.5;
              Synchronize(UpdateCurrentRainfallRecord);
              previousDate := date;
              previousRain := rain;
            end;
          end
          else begin
            inc(recordCounter);
            Synchronize(AddRainfallRecord);
            previousDate := date;
            previousRain := rain;
          end;
        end;
      except
        on E: Exception do begin
          Feedbackln('Error reading data on line '+inttostr(lineCounter)+': '+fullline);
          //rm 2007-10-31 - if using wrong converter somehow the user will get a slow
          //cascade of error messages in the feedback window
          //the intention here is to allow an abort if errors are more than
          //half of the first 200 lines
          inc(errorCounter);
          if (errorCounter > 100) and (recordCounter < 100) then begin
            Feedbackln('');
            Feedbackln('TOO MANY ERRORS IN INPUT. ABORTING. . . ');
            boAborted := true;
            raise;
          end;
        end;
      end;
    end;
    //rm 2008-10-09 - add a record for the last date in file (if haven't already, i.e. rain=0)
    if (rain=0) then begin
       inc(recordCounter);
       Synchronize(AddRainfallRecord);
    end;
    //rm
  finally
    Synchronize(CloseAndFreeRainfallTable);
    CloseFile(F);
    if boAborted then begin
      Feedbackln('');
      Feedbackln('Import Aborted.');
    end else begin
      Synchronize(UpdateMinMaxTimes);
      Feedbackln('');
      Feedbackln('Import Complete.');
    end;
  FreeMem(integerBuffer, 4);
  FreeMem(realBuffer,4);
  Feedbackln('');
  Feedbackln(inttostr(recordCounter)+' records imported.');
  Feedbackln('');
  Feedbackln('First Date in file = '+leftpad(dateTimeString(earliestDate),16));
  Feedbackln('Last Date in file  = '+leftpad(dateTimeString(latestDate),16));
  duration := (latestDate - earliestDate) / 365.25;
  average := (totrain / duration);
  Feedbackln('Duration           = '+leftpad(floattostrF(duration,ffFixed,8,3),10)+ ' Years');
  Feedbackln('Total Rainfall     = '+leftpad(floattostrF(totrain,ffFixed,8,3),10)+' Inches');
  Feedbackln('Average Rainfall   = '+leftpad(floattostrF(average,ffFixed,8,3),10)+' Inches/Year');
  Feedbackln('');
  Feedbackln(' Five maximum '+inttostr(timestep)+' minute rainfall ('+rainUnitLabel+') and dry periods (days)');
  Feedbackln(' between observed rainfall data:');
  Feedbackln('    date      max rain        date     previous dry days');
  for i := 1 to totalMaximums do begin
    outString := leftpad(dateString(maxRainDates[i]),11);
    outString := outString + leftpad(floattostrF(maxRains[i],ffFixed,8,3),10);
    outString := outString + leftpad(dateString(maxHoursDates[i]),16);
    outString := outString + leftpad(floattostrF(maxHours[i],ffFixed,8,4),10);
    Feedbackln(outstring);
  end;
  Feedbackln('');
  Synchronize(Validate);
  Feedbackln('');
  Feedbackln('This window may be closed.');
  Synchronize(AddImportLogRecord);
  end;
end;

procedure ConverterImportThread.GetRaingaugeInfo();
begin
  raingaugeID := DatabaseModule.GetRaingaugeIDForName(raingaugeName);
  timestep := DatabaseModule.GetRainfallTimestep(raingaugeID);
  raingaugeUnit := DatabaseModule.GetRainUnitIDForRaingauge(raingaugeID);
  rainUnitLabel := DatabaseModule.GetRainUnitLabelForRaingauge(raingaugeName);
end;

procedure ConverterImportThread.GetConverterInfo();
var
  rainConverterName, queryStr: string;
  localRecSet: _RecordSet;
begin
  rainConverterName := frmImportRainDataUsingConverter.ConverterComboBox.Items.Strings[frmImportRainDataUsingConverter.ConverterComboBox.ItemIndex];
  sourceUnitLabel := DatabaseModule.GetRainUnitLabelForRainConverter(rainConverterName);
  conversionFactor := DatabaseModule.GetConversionFactorToUnitForRaingauge(raingaugeID,sourceUnitLabel);
  queryStr := 'SELECT LinesToSkip, Format, MonthColumn, MonthWidth, YearColumn, ' +
              'YearWidth, DayColumn, DayWidth, HourColumn, HourWidth, ' +
              'MinuteColumn, MinuteWidth, CodeColumn, CodeWidth, RainColumn, ' +
              'RainWidth, MilitaryTime, AMPMColumn FROM RainConverters WHERE ' +
              '(RainConverterName = "' + rainConverterName + '");';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  localRecSet.MoveFirst;
  linesToSkip := localRecSet.Fields.Item[0].Value;
  tableFormat := localRecSet.Fields.Item[1].Value;
  monthColumn := localRecSet.Fields.Item[2].Value;
  monthWidth := localRecSet.Fields.Item[3].Value;
  yearColumn := localRecSet.Fields.Item[4].Value;
  yearWidth := localRecSet.Fields.Item[5].Value;
  dayColumn := localRecSet.Fields.Item[6].Value;
  dayWidth := localRecSet.Fields.Item[7].Value;
  hourColumn := localRecSet.Fields.Item[8].Value;
  hourWidth := localRecSet.Fields.Item[9].Value;
  minuteColumn := localRecSet.Fields.Item[10].Value;
  minuteWidth := localRecSet.Fields.Item[11].Value;
  codeColumn := localRecSet.Fields.Item[12].Value;
  codeWidth := localRecSet.Fields.Item[13].Value;
  rainColumn := localRecSet.Fields.Item[14].Value;
  rainWidth := localRecSet.Fields.Item[15].Value;
  militaryTime := localRecSet.Fields.Item[16].Value;
  ampmColumn := localRecSet.Fields.Item[17].Value;
  localRecSet.Close;
end;

procedure ConverterImportThread.OpenRainfallTable();
begin
  recSet := CoRecordSet.Create;
  recSet.Open('Rainfall',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  fields := VarArrayCreate([1,4],varVariant);
  values := VarArrayCreate([1,4],varVariant);
  fields[1] := 'RainGaugeID';
  fields[2] := 'DateTime';
  fields[3] := 'Volume';
  fields[4] := 'Code';

  values[1] := raingaugeID;
end;

procedure ConverterImportThread.CloseAndFreeRainfallTable();
begin
  if (recSet.State <> adStateClosed) then recSet.Close;
end;

procedure ConverterImportThread.updateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(date);
end;

procedure ConverterImportThread.Validate;
//rm 2009-06-12 - Beta 1 review - duplicate entries in rainfall table cause erroneous
//rainfall amounts - and there is no check for AM/PM data being imported as Military Time data
var iNumDupes: integer;
begin
  Feedbackln('');
  Feedbackln('Validating Rainfall for Raingauge. . . ');
  DatabaseModule.ValidateRainfall4Raingauge(raingaugeID, iNumDupes);
  if (iNumDupes > 0) then begin
    Feedbackln('* * * * * DUPLICATES FOUND! * * * * *');
    Feedbackln(IntToStr(iNumDupes) + ' duplicate entries found for raingauge ' + raingaugeName);
    Feedbackln('');
    Feedbackln('It is highly reccommended that you re-import rainfall for this gauge and press the "Remove" button when prompted.');
    Feedbackln('');
    Feedbackln('(One cause of this may be importing AM/PM data as Military Time.)');
    Feedbackln('');
  end else begin
    Feedbackln('No duplicate entries found for raingauge ' + raingaugeName);
  end;
end;

procedure ConverterImportThread.AddImportLogRecord;
var idx: integer;
begin
  //rm 2009-06-03 - add to log file
  idx := DatabaseModule.GetRainConverterIndexForName(
   frmImportRainDataUsingConverter.ConverterComboBox.Items.Strings[frmImportRainDataUsingConverter.ConverterComboBox.ItemIndex]);
  DatabaseModule.LogImport(1, raingaugeID, idx,
    frmImportRainDataUsingConverter.FilenameEdit.Text, Now,
    frmFeedbackWithMemo.feedbackMemo.Text);
end;

procedure ConverterImportThread.AddRainfallRecord();
begin
  values[2] := date;
  values[3] := rain;
  values[4] := code;
  try
    recSet.AddNew(fields,values);
  except
    ShowADOErrors(frmMain.Connection.Errors);
  end;
end;

procedure ConverterImportThread.UpdateCurrentRainfallRecord();
begin
  values[2] := date;
  values[3] := rain;
  values[4] := code;
  try
    recSet.Update(fields,values);
  except
    ShowADOErrors(frmMain.Connection.Errors);
  end;
end;

procedure ConverterImportThread.UpdateMinMaxTimes();
begin
  DatabaseModule.UpdateMinMaxRainTimes(raingaugeID);
end;

procedure ConverterImportThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Text := frmFeedbackWithMemo.feedbackMemo.Text+textToAdd;
  frmFeedbackWithMemo.feedbackMemo.SelStart := Length(frmFeedbackWithMemo.feedbackMemo.Text)
end;

procedure ConverterImportThread.FeedbackLn(line: string);
begin
  textToAdd := line+#13+#10;
  Synchronize(AddToFeedbackMemo);
end;

procedure ConverterImportThread.ShowADOErrors(ErrorList: ADODB_TLB.Errors);
var
  I: Integer;
  E: ADODB_TLB.Error;
  S: String;
begin
  for i := 0 to ErrorList.Count - 1 do begin
    E := ErrorList[i];
    S := Format('ADO Error %d of %d:'#13#13'%s',
      [i+1,ErrorList.count,e.description]);
    Feedbackln(s);
  end;
end;

end.
 