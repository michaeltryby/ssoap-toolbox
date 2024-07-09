unit flowConverterImportThread;
//rm 2009-08-26 - added two new fields modeled after rainfallConverterImportThread
//MilitaryTime and AMPM
//changes to version 1.0

interface

uses
  Classes, ADODB_TLB, Variants;

type
  integerPointer = ^integer;
  realPointer = ^real;

  ConverterImportThread = class(TThread)
    flowMeterName, sourceUnitLabel, textToAdd, meterFlowUnitLabel: String;
    meterID, timestep, code: integer;
    fConversionFactor, vConversionFactor, dConversionFactor: real;
    flow, velocity, depth: real;
    integerBuffer: integerPointer;
    realBuffer: realPointer;
    date: TDateTime;
    linesToSkip: integer;
    tableFormat: string;
    monthColumn, monthWidth: integer;
    yearColumn, yearWidth, dayColumn, dayWidth, hourColumn, hourWidth: integer;
    minuteColumn, minuteWidth, codeColumn, codeWidth, flowColumn, flowWidth: integer;
    velocityColumn, velocityWidth, depthColumn, depthWidth: integer;
    //rm 2009-08-26 - two new fields
    militaryTime: boolean;
    ampmColumn: integer;
    //rm
    recSet: _RecordSet;
    fields, values: OleVariant;
    constructor CreateIt();
  private { Private declarations }
    boAborted: boolean;
    procedure UpdateStatus();
    procedure GetMeterInfo();
    procedure GetConverterInfo();
    procedure OpenFlowTable();
    procedure CloseFlowAndFreeFlowTable();
    procedure AddFlowRecord();
    procedure UpdateCurrentFlowRecord();
    procedure UpdateMinMaxTimes();
    procedure AddToFeedbackMemo();
    procedure FeedbackLn(line: string);
    procedure ShowADOErrors(ErrorList: ADODB_TLB.Errors);
    procedure AddImportLogRecord;
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
  end;

implementation

uses windows, sysutils, feedbackWithMemo, importFlowData, modDatabase, rdiiutils,
     mainform
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
var
  minFlow, maxFlow, previousFlow, avgSum: real;
  newDate, previousDate, minimumDate, maximumDate, maxFlowTime, minFlowTime: TDateTime;
  F: TextFile;
  fullline, line: String;
  lineCounter, recordCounter, month, year, day, hour, minute: integer;
  //rm 2007-10-31 added errorcounter
  errorCounter: integer;
  i, separatorPosition, fieldCount: integer;
  substrings: array[1..maxFields] of String;
  include, shifted: boolean;
  earliestDate, latestDate: TDateTime;
  nonZeroRecords, negativeRecords: integer;
  //rm 2009-08-26 - AMPM
  AMPM: string;
begin
  boAborted := false;
  Feedbackln('Starting import...');
  earliestDate := 0.0;
  latestDate := 0.0;
  previousDate := 0.0;
  previousFlow := 0.0;

  GetMem(integerBuffer,4);
  GetMem(realBuffer,4);

  flowMeterName := frmImportFlowDataUsingConverter.FlowMeterNameComboBox.Items.Strings[frmImportFlowDataUsingConverter.FlowMeterNameComboBox.ItemIndex];
  { must use frac() below because .Time includes the date portion, Arrg!}
  minimumDate := trunc(frmImportFlowDataUsingConverter.StartDatePicker.DateTime) + frac(frmImportFlowDataUsingConverter.StartTimePicker.Time);
  maximumDate := trunc(frmImportFlowDataUsingConverter.EndDatePicker.DateTime) + frac(frmImportFlowDataUsingConverter.EndTimePicker.Time);

  Synchronize(GetMeterInfo);
  Synchronize(GetConverterInfo);
  Synchronize(OpenFlowTable);
  AssignFile(F, frmImportFlowDataUsingConverter.FilenameEdit.Text);
  //Reset(F);
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
      Feedbackln('Flow import was not successful. Please see if the file is open by another application.');
      Feedbackln('');
      Feedbackln('This window may be closed.');
      Feedbackln('');
      exit;
    end;
  end;
//rm
  lineCounter := linesToSkip;
  recordCounter := 0;
  negativeRecords := 0;
  nonZeroRecords := 0;
  errorCounter := 0;
  maxFlow := -99999.0;
  minFlow :=  99999.0;
  avgSum := 0.0;
  shifted := false;
  try
    for i := 1 to linesToSkip do readln(F);
    while (not eof(f)) do begin
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
          flow := strtofloat(copy(fullline,flowColumn,flowWidth));
          if (velocityColumn > 0)
            then velocity := strtofloat(copy(fullline,velocityColumn,velocityWidth))
            else velocity := 0;
          if (depthColumn > 0)
            then depth := strtofloat(copy(fullline,depthColumn,depthWidth))
            else depth := 0;
          if (codeColumn > 0)
            then code := strtoint(copy(fullline,codeColumn,codeWidth))
            else code := 1;
          //rm 2009-08-26
          if ((not militaryTime) and (ampmColumn > 0)) then AMPM := copy(fullline,ampmColumn,1);
        end
        else begin {FILE IS CSV FORMAT}
          line := AnsiUpperCase(fullline);
          for i := 1 to length(line) do begin
            //if line[i] in ['A'..'Z','\','/',':','"',chr(39),'_',',',#160] then line[i] := ' ';
            //rm 2007-10-22 - add tab chr(9) to this list
            //if line[i] in ['A'..'Z','\','/',':','"',chr(39),'_',',',#160,Chr(9)] then line[i] := ',';
            //rm 2009-06-04 - remove the 'A'..'Z' and '_' and quotes from this list
            if line[i] in ['\','/',':',',',#160,Chr(9)] then line[i] := ',';
          end;
          line := TrimRight(line);
          line := TrimLeft(line);
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
          flow := strtofloat(substrings[flowColumn]);
          if (velocityColumn > 0) then begin
          //rm 2007-10-2
            if (Length(substrings[velocityColumn])>0) then
            velocity := strtofloat(substrings[velocityColumn])
            else velocity := 0;
          end else velocity := 0;
          if (depthColumn > 0) then begin
          //rm 2007-10-2
            if (Length(substrings[depthColumn])>0) then
            depth := strtofloat(substrings[depthColumn])
            else depth := 0;
          end else depth := 0;

          if (codeColumn > 0) then begin
          //rm 2007-10-2
            if (Length(substrings[codeColumn])>0) then
              code := strtoint(substrings[codeColumn])
              else code := 1;
          end else code := 1;
          //rm 2009-08-26
          if ((not militaryTime) and (ampmColumn > 0)) then AMPM := substrings[ampmColumn];
        end;
        if (year < 50)
          then year := year + 2000
          else if (year < 99) then year := year + 1900;
        //rm 2009-08-26
        AMPM := AnsiUppercase(AMPM);
        if ((copy(AMPM,1,1) = 'P') and (hour < 12)) then hour := hour + 12;
        if ((copy(AMPM,1,1) = 'A') and (hour = 12)) then hour := hour - 12;
        //rm
        date := EncodeDate(year,month,day)+EncodeTime(hour,minute,0,0);
        newDate := trunc((date/(timestep/1440.0))+0.5)*(timestep/1440.0);
        //rm 2007-10-31 - apparently newDate never = date:
        //if (newDate <> date) then begin
        if (abs(newDate - date) > 0.000694) {1 minute} then begin
          shifted := true;
        end;
//rm 2007-11-27 - try something new here:
//original:        date := newDate;
//this is designed to round datetime to nearest minute:
        date := trunc((newDate*1440) + 0.5)/1440;

        if ((earliestDate = 0) or (date < earliestDate)) then earliestDate := date;
        if ((latestDate = 0) or (date > latestDate)) then latestDate := date;
        Synchronize(updateStatus);
        include := true;
        if ((frmImportFlowDataUsingConverter.StartDateTimeCheckBox.Enabled) and ((frmImportFlowDataUsingConverter.StartDateTimeCheckBox.checked) and (date < minimumDate))) then include := false;
        if ((frmImportFlowDataUsingConverter.EndDateTimeCheckBox.Enabled) and ((frmImportFlowDataUsingConverter.EndDateTimeCheckBox.checked) and (date > maximumDate))) then include := false;
        if (include) then begin
          flow := flow / fConversionFactor;
          if (flow > 0) then inc(nonZeroRecords);
          if (flow <> 0) then begin
            if (flow > maxFlow) then begin
              maxFlow := flow;
              maxFlowTime := date;
            end;
            if (flow < minFlow) then begin
              minFlow := flow;
              minFlowTime := date;
            end;
            avgSum := avgSum + flow;
          end;
          if ((flow = 0.0) and (frmImportFlowDataUsingConverter.ConsiderZeroFlowsMissingDataCheckBox.checked))
            then code := 0;
          if (flow < 0.0) then begin
            inc(negativeRecords);
            if (frmImportFlowDataUsingConverter.ConsiderNegativeFlowsMissingDataCheckBox.checked) then code := 0;
          end;
          if (abs(date - previousDate) < 0.0005) then begin
            if (not frmImportFlowDataUsingConverter.FirstFlowRadioButton.Checked) then begin
              if (frmImportFlowDataUsingConverter.AverageFlowsRadioButton.Checked) then
                flow := (flow + previousFlow) * 0.5;
              Synchronize(UpdateCurrentFlowRecord);
              previousDate := date;
              previousFlow := flow;
            end;
          end
          else begin
            Synchronize(AddFlowRecord);
            inc(recordCounter);
            previousDate := date;
            previousFlow := flow;
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
  finally
    Synchronize(CloseFlowAndFreeFlowTable);
    CloseFile(f);
    if boAborted then begin
      Feedbackln('');
      Feedbackln('Import Aborted.');
    end else begin
      Synchronize(UpdateMinMaxTimes);
      Feedbackln('');
      Feedbackln('Import Complete.');
    end;
  if (shifted) then Feedbackln('  Warning :  Times were shifted to the nearest '+inttostr(timestep)+' increment');
  Feedbackln('');
  Feedbackln('Number of lines processed  = '+inttostr(linecounter));
  //rm 2007-10-31
  Feedbackln('Number of errors encountered = '+inttostr(errorCounter));
  Feedbackln('Number of non-zero flows     = '+inttostr(nonZeroRecords));
  Feedbackln('Number of negative flows     = '+inttostr(negativeRecords));
  Feedbackln('Number of records imported   = '+inttostr(recordCounter));
  Feedbackln('');
  Feedbackln('The flow data ranged from '+dateTimeString(earliestDate));
  Feedbackln('                       to '+dateTimeString(latestDate));
  Feedbackln('');
  Feedbackln('Maximum Flow = '+floattostrF(maxFlow,ffFixed,15,3)+' '+meterFlowUnitLabel+
             ' @ '+datetimetoStr(maxFlowTime));
  Feedbackln('Minimum Flow = '+floattostrF(minFlow,ffFixed,15,3)+' '+meterFlowUnitLabel+
             ' @ '+datetimetoStr(minFlowTime));
  if (nonZeroRecords > 0) then
  Feedbackln('Average Flow = '+floattostrF(avgSum/nonZeroRecords,ffFixed,15,3)+' '+meterFlowUnitLabel);

  Feedbackln('');
  Feedbackln('This window may be closed.');
  Synchronize(AddImportLogRecord);
  FreeMem(integerBuffer, 4);
  FreeMem(realBuffer,4);
  end;
end;

procedure ConverterImportThread.updateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(date);
end;

procedure ConverterImportThread.GetMeterInfo();
begin
  meterID := DatabaseModule.GetMeterIDForName(flowMeterName);
  timestep := DatabaseModule.GetFlowTimestep(meterID);
  meterFlowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
end;

procedure ConverterImportThread.GetConverterInfo();
var
  flowConverterName, queryStr: string;
  localRecSet: _RecordSet;
begin
  flowConverterName := frmImportFlowDataUsingConverter.ConverterComboBox.Items.Strings[frmImportFlowDataUsingConverter.ConverterComboBox.ItemIndex];
//rm 2008-11-11: TODO: set up source and destination unit handling for Flow, Velocty and Depth
sourceUnitLabel := DatabaseModule.GetFlowUnitLabelForFlowConverter(flowConverterName);
fConversionFactor := DatabaseModule.GetConversionFactorToUnitForMeter(meterID,sourceUnitLabel);
//sourceUnitLabel := meterFlowUnitLabel;
//fConversionFactor := 1.0;
//rm
//rm 2009-08-26 - add , MilitaryTime, AMPMColumn  like rainconverter
  queryStr := 'SELECT LinesToSkip, Format, MonthColumn, MonthWidth, YearColumn, ' +
              'YearWidth, DayColumn, DayWidth, HourColumn, HourWidth, ' +
              'MinuteColumn, MinuteWidth, CodeColumn, CodeWidth, ' +
              'FlowColumn, FlowWidth, VelocityColumn, VelocityWidth, DepthColumn, ' +
              'DepthWidth, MilitaryTime, AMPMColumn FROM FlowConverters WHERE ' +
              '(FlowConverterName = "' + flowConverterName + '");';
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
  flowColumn := localRecSet.Fields.Item[14].Value;
  flowWidth := localRecSet.Fields.Item[15].Value;
  VelocityColumn := localRecSet.Fields.Item[16].Value;
  VelocityWidth := localRecSet.Fields.Item[17].Value;
  DepthColumn := localRecSet.Fields.Item[18].Value;
  DepthWidth := localRecSet.Fields.Item[19].Value;
  //rm 2009-08-26 - new fields
  //rm 2009-11-03 - new fields might be null  - if so set to default
  if VarIsNull(localRecSet.Fields.Item[20].Value) then
    militaryTime := true
  else
    militaryTime := localRecSet.Fields.Item[20].Value;
  if VarIsNull(localRecSet.Fields.Item[21].Value) then
    ampmColumn := 0
  else
    ampmColumn := localRecSet.Fields.Item[21].Value;
  localRecSet.Close;
end;

procedure ConverterImportThread.OpenFlowTable();
begin
  recSet := CoRecordSet.Create;
  recSet.Open('Flows',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  fields := VarArrayCreate([1,6],varVariant);
  values := VarArrayCreate([1,6],varVariant);
  fields[1] := 'MeterID';
  fields[2] := 'DateTime';
  fields[3] := 'Flow';
  fields[4] := 'Velocity';
  fields[5] := 'Depth';
  fields[6] := 'Code';

  values[1] := meterID;
end;

procedure ConverterImportThread.CloseFlowAndFreeFlowTable();
begin
  if (recSet.State <> adStateClosed) then recSet.Close;
end;

procedure ConverterImportThread.AddFlowRecord();
begin

  values[2] := date;
  values[3] := flow;
  values[4] := velocity;
  values[5] := depth;
  values[6] := code;
  try
    recSet.AddNew(fields,values);
  except
    ShowADOErrors(frmMain.Connection.Errors);
  end;
end;

procedure ConverterImportThread.UpdateCurrentFlowRecord();
begin

  values[2] := date;
  values[3] := flow;
  values[4] := code;
  try
    recSet.Update(fields,values);
  except
    ShowADOErrors(frmMain.Connection.Errors);
  end;
end;

procedure ConverterImportThread.AddImportLogRecord;
var idx: integer;
  s: string;
begin
  //rm 2009-06-03 - add to log file
  idx := DatabaseModule.GetFlowConverterIndexForName(
   frmImportFlowDataUsingConverter.ConverterComboBox.Items.Strings[frmImportFlowDataUsingConverter.ConverterComboBox.ItemIndex]);
  DatabaseModule.LogImport(2, meterID, idx,
    frmImportFlowDataUsingConverter.FilenameEdit.Text, Now,
    frmFeedbackWithMemo.feedbackMemo.Text);
end;

procedure ConverterImportThread.UpdateMinMaxTimes();
var flowconverterindex: integer;
begin
  DatabaseModule.UpdateMinMaxFlowTimes(meterID);
end;

procedure ConverterImportThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Text := frmFeedbackWithMemo.feedbackMemo.Text+textToAdd;
  frmFeedbackWithMemo.feedbackMemo.SelStart := Length(frmFeedbackWithMemo.feedbackMemo.Text)
//rm 2007-10-31 - testing
//  frmFeedbackWithMemo.feedbackMemo.Lines.Add(textToAdd);
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
