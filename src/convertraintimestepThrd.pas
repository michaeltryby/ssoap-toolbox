unit convertraintimestepThrd;

interface

uses
  Classes, ADODB_TLB, Variants;

type
  integerPointer = ^integer;
  realPointer = ^real;
  ConvertRainTimestepThread = class(TThread)
    //rm 2008-11-10 integerBuffer: integerPointer;
    //rm 2008-11-10 realBuffer: realPointer;
    timestamp, newDate: TDateTime;
    textToAdd: string;
    raingaugeID, oldTimeStep, newTimeStep: integer;
    tableRecSet, queryRecSet: _RecordSet;
    fields, values: OleVariant;
    partialRain, newRain: real;
    newCode: integer;
    raingaugeName: string;
    constructor CreateIt();
  private
    procedure SaveNewTimeStep();
    procedure OpenRainfallTable();
    procedure OpenRainfallQuery();
    procedure UpdateRainfallQuery();
    procedure NextQueryRecord();
    procedure AppendRainRecord();
    procedure DeleteQueryRecord();
    procedure CloseAndFreeRainfallTable();
    procedure CloseAndFreeRainfallQuery();
    procedure ChangeToSmallerTimeStep();
    procedure ChangeToSmallerTimeStep_old();
    procedure ChangeToLargerTimeStep();
    procedure ChangeToLargerTimeStep_old();
    procedure UpdateStatus();
    procedure AddToFeedbackMemo();
    procedure FeedbackLn(line: string);
    procedure ShowADOErrors(ErrorList: ADODB_TLB.Errors);
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
  end;

implementation

uses windows, sysutils, feedbackWithMemo, convertraintimestep, modDatabase,
     mainform
     {$IFDEF VER140 } ,Variants {$ENDIF};

constructor ConvertRainTimestepThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true;     // Thread Free Itself when terminated
  Suspended := false;          // Continue the thread
end;

destructor ConvertRainTimestepThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure ConvertRainTimestepThread.Execute;
//var
//  raingaugeName: string;
begin
  //rm 2008-11-10 GetMem(integerBuffer,4);
  //rm 2008-11-10 GetMem(realBuffer,4);
  raingaugeName := frmConvertRainTimeStep.RaingaugeNameComboBox.Items.Strings[frmConvertRainTimeStep.RaingaugeNameComboBox.ItemIndex];
  raingaugeID := DatabaseModule.GetRaingaugeIDForName(raingaugeName);
  oldTimeStep := DatabaseModule.GetRainfallTimestep(raingaugeID);
  FeedbackLn('Converting rainfall timestep for raingauge ' + raingaugeName + ' ...');
  FeedbackLn('');
  //newTimeStep := frmConvertRainTimeStep.NewTimeStepSpinEdit.Value;
  newTimeStep := strToInt(frmConvertRainTimeStep.ComboBoxNewTimeStep.Text);
  FeedbackLn('Old Time Step = '+inttostr(oldTimeStep));
  FeedbackLn('New Time Step = '+inttostr(newTimeStep));
  //rm 2008-11-10 Synchronize(OpenRainfallTable);
  //rm 2008-11-10 Synchronize(OpenRainfallQuery);
  if (newTimeStep > oldTimeStep) then ChangeToLargerTimeStep();
  if (newTimeStep < oldTimeStep) then ChangeToSmallerTimeStep();
  Synchronize(SaveNewTimeStep);
  //rm 2008-11-10 Synchronize(CloseAndFreeRainfallQuery);
  //rm 2008-11-10 Synchronize(CloseAndFreeRainfallTable);
  //rm 2008-11-10 FreeMem(integerBuffer, 4);
  //rm 2008-11-10 FreeMem(realBuffer,4);
  FeedbackLn('');
  FeedbackLn('Conversion Complete.  This window may be closed.');
end;

//rm 2008-11-10 Converting to smaller can be done with just SQL, but this
//routine seems to work ok as is. . . .

procedure ConvertRainTimestepThread.ChangeToSmallerTimeStep();
var
  i, ratio, totalrecordsAffected: integer;
  rain, offset, remainingRain: real;
  sqlStr: string;
  sRatio, sCode, sRgid, sOffset: string;
  recordsAffected: OleVariant;
begin
  ratio := oldTimeStep div newTimeStep;
  newCode := 5;
  offset := newTimeStep / 1440.0;
  sOffset := FormatFloat('0.000000000',offset);
  sRatio := inttostr(ratio);
  sCode := inttostr(newCode);
  sRgid := inttostr(raingaugeID);
  //rm 2008-11-10 First flag the rainfall records of interest for later processing
  sqlStr := 'UPDATE Rainfall SET ' +
            'Code = -99 WHERE ' +
            '(RaingaugeID = ' + sRgid + ');';
  frmMain.connection.Execute(sqlStr,recordsAffected,adCmdText);
  feedbackln(Inttostr(recordsAffected) +
    ' records in Rainfall table for raingauge ' + raingaugeName + '.');
  totalrecordsAffected := 0;
  for i := 1 to ratio - 1 do begin
      //newDate := timeStamp + (i*newTimeStep/1440.0);
    sqlStr := 'Insert into Rainfall (RaingaugeID, [DateTime], Volume, Code) ' +
      ' Select RaingaugeID, [DateTime] + ' + inttostr(i) + ' * ' + sOffset +
      ', Volume / ' +  sRatio + ', ' + sCode +
      ' FROM Rainfall where RaingaugeID = ' + sRgid +
      ' AND Code = -99';
    frmMain.connection.Execute(sqlStr,recordsAffected,adCmdText);
    totalRecordsAffected := totalRecordsAffected + recordsAffected;
  end;
  feedbackln(Inttostr(totalrecordsAffected) +
    ' new records added to Rainfall table with 1/' + sRatio + ' old value.');
  sqlStr := 'Update Rainfall ' +
    ' Set Volume = Volume / ' +  sRatio + ', Code = ' + sCode +
    ' Where RaingaugeID = ' + sRgid +
    ' AND Code = -99';
  frmMain.connection.Execute(sqlStr,recordsAffected,adCmdText);
  feedbackln(Inttostr(recordsAffected) +
    ' old records updated in Rainfall table updated to 1/' + sRatio + ' old value.');

end;

procedure ConvertRainTimestepThread.ChangeToSmallerTimeStep_old();
var
  i, ratio: integer;
  rain, remainingRain: real;
begin
  ratio := oldTimeStep div newTimeStep;
  newCode := 5;
  while (not queryRecSet.EOF) do begin
    timestamp := queryRecSet.Fields.Item[0].Value;
    //rm 2007-11-06 - user request to show a readable datetime here instead of decimal day
    //feedbackln(floattostr(timestamp));
    feedbackln(formatdatetime('mm/dd/yyyy hhhh:mm' ,timestamp));
    Synchronize(UpdateStatus);
    rain := queryRecSet.Fields.Item[1].Value;
    partialRain := trunc(((rain * 100) / ratio)) / 100;
    newRain := partialRain;
    Synchronize(UpdateRainfallQuery);
    for i := 1 to ratio - 2 do begin
      newDate := timeStamp + (i*newTimeStep/1440.0);
      Synchronize(AppendRainRecord);
    end;
    remainingRain := rain - (partialRain * (ratio - 1));
    newRain := remainingRain;
    newDate := timeStamp + (ratio-1)*newTimeStep/1440.0;
    Synchronize(AppendRainRecord);
    Synchronize(NextQueryRecord);
  end;
end;


//rm 2008-11-10 How about some SQL?
// 1) Update Rainfall set Code = -99 where RaingaugeID = raingaugeID
// 2) insert into Rainfall (Raingaugeid, [DateTime], Volume, Code)
//    SELECT Raingaugeid,
//    CDate(Int(DateTime) + (Int(CDate(Format(DateTime,"hh:nn")) * 1440 / newts) * newts)/1440),
//    sum(Volume), 7
//    FROM Rainfall
//    WHERE RaingaugeID = raingaugeID
//    GROUP BY Raingaugeid,
//    CDate(Int(DateTime) + (Int(CDate(Format(DateTime,"hh:nn")) * 1440 / newts) * newts)/1440)
// 3) Delete from Rainfall where RaingaugeID = raingaugeID and Code = -99
// 4) Update RainGauges set TimeStep = newTimeStep where RainGaugeID = raingaugeID

procedure ConvertRainTimestepThread.ChangeToLargerTimeStep();
var
  sqlStr: string;
  snewts, srgid: string;
  recordsAffected: OleVariant;
begin
  snewts := inttostr(newTimeStep);
  srgid := inttostr(raingaugeID);

  //rm 2008-11-10 First flag the rainfall records of interest for later deletion
  sqlStr := 'UPDATE Rainfall SET ' +
            'Code = -99 WHERE ' +
            '(RaingaugeID = ' + srgid + ');';
  frmMain.connection.Execute(sqlStr,recordsAffected,adCmdText);
  feedbackln(Inttostr(recordsAffected) +
    ' records in Rainfall table for raingauge ' + raingaugeName + '.');

//rm 2008-11-10 Now append records to the rainfall table representing the new timestep
  sqlStr := 'Insert into Rainfall (Raingaugeid, [DateTime], Volume, Code) ' +
    ' SELECT Raingaugeid, ' +
    ' CDate(Int(DateTime) + (Int(CDate(Format(DateTime,"hh:nn")) * 1440 / ' +
    snewts + ') * ' + snewts + ')/1440), ' +
    ' sum(Volume), 7 ' +
    ' FROM Rainfall ' +
    ' WHERE RaingaugeID = ' + srgid +
    ' GROUP BY Raingaugeid, ' +
    ' CDate(Int(DateTime) + (Int(CDate(Format(DateTime,"hh:nn")) * 1440 / ' +
    snewts + ') * ' + snewts + ')/1440)';
  //feedbackln(sqlStr);
  frmMain.connection.Execute(sqlStr,recordsAffected,adCmdText);
  feedbackln(Inttostr(recordsAffected) + ' new records added to Rainfall table.');

//rm 2008-11-10 Now delete the original rainfall records
  sqlStr := 'DELETE from Rainfall ' +
            'WHERE (Code = -99) and ' +
            '(RaingaugeID = ' + srgid + ');';
  frmMain.connection.Execute(sqlStr,recordsAffected,adCmdText);
  feedbackln(Inttostr(recordsAffected) + ' old records removed from Rainfall table.');

end;

//rm 2008-11-10 renamed this old procedure (not working) and replaced with new procedure
//with the SQL calls
procedure ConvertRainTimestepThread.ChangeToLargerTimeStep_old();
var
  currentRangeEnd, rangeBoundaryAtOrBefore,rangeBoundary: TDateTime;
  rain, sum: real;
begin
  sum := 0;
  currentRangeEnd := 0;
  while (not queryRecSet.EOF) do begin
    timestamp := queryRecSet.Fields.Item[0].Value;
    //rm 2007-11-06 - user request to show a readable datetime here instead of decimal day
    //feedbackln(floattostr(timestamp));
    feedbackln(formatdatetime('mm/dd/yyyy hhhh:mm' ,timestamp));
    Synchronize(UpdateStatus);
    rain := queryRecSet.Fields.Item[1].Value;
    if (rain > 0) then begin
      rangeBoundaryAtOrBefore := trunc(timestamp*1440/newTimeStep)/(1440/newTimeStep);
      rangeBoundary := trunc((timestamp*1440/newTimeStep)+1.0)/(1440/newTimeStep);
      if (currentRangeEnd = 0) then
        if (timestamp = rangeBoundaryAtOrBefore)
          then currentRangeEnd := rangeBoundaryAtOrBefore
          else currentRangeEnd := rangeBoundaryAtOrBefore + (newTimeStep/1440);
      if (timestamp <= currentRangeEnd) then
        sum := sum + rain
      else begin
        newCode := 7;
        newRain := sum;
        newDate := currentRangeEnd-(newTimeStep/1440);
        Synchronize(AppendRainRecord);
        currentRangeEnd := rangeBoundary;
        sum := rain;
      end;
    end;
    Synchronize(DeleteQueryRecord);
    Synchronize(NextQueryRecord);
  end;
end;

procedure ConvertRainTimestepThread.UpdateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := dateToStr(timestamp);
end;

procedure ConvertRainTimestepThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Text := frmFeedbackWithMemo.feedbackMemo.Text+textToAdd;
  frmFeedbackWithMemo.feedbackMemo.SelStart := Length(frmFeedbackWithMemo.feedbackMemo.Text)
end;

procedure ConvertRainTimestepThread.FeedbackLn(line: string);
begin
  textToAdd := line+#13+#10;
  Synchronize(AddToFeedbackMemo);
end;

procedure ConvertRainTimestepThread.SaveNewTimeStep();
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'UPDATE Raingauges SET ' +
            'TimeStep = ' + inttostr(newTimeStep) + ' WHERE ' +
            '(RaingaugeID = ' + inttostr(raingaugeID) + ');';
  frmMain.connection.Execute(sqlStr,recordsAffected,adCmdText);
end;

procedure ConvertRainTimestepThread.OpenRainfallTable();
begin
  tableRecSet := CoRecordSet.Create;
  tableRecSet.Open('Rainfall',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTableDirect);
  fields := VarArrayCreate([1,4],varVariant);
  values := VarArrayCreate([1,4],varVariant);
  fields[1] := 'RainGaugeID';
  fields[2] := 'DateTime';
  fields[3] := 'Volume';
  fields[4] := 'Code';

  values[1] := raingaugeID;
end;

procedure ConvertRainTimestepThread.OpenRainfallQuery();
var
  queryStr: string;
begin
  queryStr := 'SELECT DateTime, Volume, Code FROM Rainfall WHERE ' +
              '((RaingaugeID = ' + inttostr(raingaugeID) + ') AND (Volume >= 0)) order by datetime;';
  queryRecSet := CoRecordSet.Create;
  queryRecSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  queryRecSet.MoveFirst;
end;

procedure ConvertRainTimestepThread.CloseAndFreeRainfallTable();
begin
  tableRecSet.Close;
end;

procedure ConvertRainTimestepThread.CloseAndFreeRainfallQuery();
begin
  queryRecSet.Close;
end;

procedure ConvertRainTimestepThread.UpdateRainfallQuery();
begin
  queryRecSet.Fields.Item[1].Value := newRain;
  queryRecSet.Fields.Item[2].Value := newCode;
  queryRecSet.UpdateBatch(1);
end;

procedure ConvertRainTimestepThread.AppendRainRecord();
begin
  values[2] := newDate;
  values[3] := newRain;
  values[4] := newCode;
  try
    tableRecSet.AddNew(fields,values);
  except
    ShowADOErrors(frmMain.Connection.Errors);
  end;
end;

procedure ConvertRainTimestepThread.NextQueryRecord();
begin
  queryRecSet.MoveNext;
end;

procedure ConvertRainTimestepThread.DeleteQueryRecord();
begin
  try
    queryRecSet.Delete(adAffectCurrent);
  except
    ShowADOErrors(frmMain.Connection.Errors);
  end;
end;

procedure ConvertRainTimestepThread.ShowADOErrors(ErrorList: ADODB_TLB.Errors);
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
