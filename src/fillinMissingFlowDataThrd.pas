unit fillinMissingFlowDataThrd;

interface

uses
  Classes, ADODB_TLB, Variants;

type
  integerPointer = ^integer;
  realPointer = ^real;

  FillinMissingFlowDataThread = class(TThread)
    integerBuffer: integerPointer;
    realBuffer: realPointer;
    meterID, timestep, missing: integer;
    tableRecSet, queryRecSet: _RecordSet;
    fields, values, keyValues: OleVariant;
    flows: array of real;
    codes: array of integer;
    dates: array of TDateTime;
    timestamp, insertTimestamp, bigGapStart, bigGapEnd: TDateTime;
    textToAdd: string;
    inBigGap: boolean;
    constructor CreateIt();
  private
    procedure GetFlowMeterData();
    procedure OpenFlowsTable();
    procedure AddFlowRecord();
    procedure UpdateFlowRecord();
    procedure FlushFlowsTable();
    procedure CloseFlowsTable();
    procedure OpenFirstFlowsQuery();
    procedure CloseFirstFlowsQuery();
    procedure OpenSecondFlowsQuery();
    procedure CloseSecondFlowsQuery();
    procedure NextFlowRecord();
    procedure UpdateStatus();
    procedure AddToFeedbackMemo();
    procedure Feedback(line: string);
    procedure ShowADOErrors(ErrorList: ADODB_TLB.Errors);
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
  end;

implementation

uses windows, sysutils, rdiiutils, modDatabase, fillinmissingdata,
     feedbackWithMemo, mainform
     {$IFDEF VER140 } ,Variants {$ENDIF};

constructor FillinMissingFlowDataThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true; // Thread Free Itself when terminated
  Suspended := false;         // Continue the thread
end;

destructor FillinMissingFlowDataThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure FillinMissingFlowDataThread.Execute;
var
  i, nIntervals, counter, maxLookAhead, windowSize, midPoint: integer;
  previousTimestamp: TDateTime;

  procedure interpolateFlow(missingIndex: integer);
  var
    index: integer;
  begin
    missing := missingIndex;
    index := 1;
    while (((index < maxLookAhead) and (missing+index<windowSize)) and (codes[missing+index] in [0,4,6])) do inc(index);
    if ((index < maxLookAhead) and (missing+index < windowSize)) then begin
      case codes[missing] of
        0: codes[missing] := 3;
        4: codes[missing] := 5;
        6: codes[missing] := 7;
      end;
      flows[missing] := flows[missing-1] +
        (flows[missing+index]-flows[missing-1])/(index+1);
      Synchronize(UpdateFlowRecord);
      Feedback('New value interpolated for '+dateTimeString(dates[missing])+' --> '+floattostrf(flows[missing],ffFixed,15,3));
    end
    else begin
      if (not inBigGap) then begin
        inBigGap := true;
        bigGapStart := dates[missing-1];
      end;
    end
  end;

begin
  Feedback('Checking for missing data records...');
  Synchronize(GetFlowMeterData);
  if (Length(frmFillInMissingDataForm.LargestGapEdit.Text) > 0)
    then maxLookAhead := (strtoint(frmFillInMissingDataForm.LargestGapEdit.Text) * 60) div timestep
    else maxLookAhead := 0;
  windowSize := (2 * maxLookAhead) + 1;
  midPoint := maxLookAhead;
  SetLength(flows,windowSize);
  SetLength(codes,windowSize);
  SetLength(dates,windowSize);

  GetMem(integerBuffer,4);
  GetMem(realBuffer,4);

  counter := 0;
  Synchronize(OpenFlowsTable);
  Synchronize(OpenFirstFlowsQuery);
  if not queryRecSet.EOF then
    previousTimestamp := queryRecSet.Fields.Item[0].Value;
//  previousTimestamp := query.fields[0].asDateTime;
  while (not queryRecSet.EOF) do begin
//  while (not query.eof) do begin
    timestamp := queryRecSet.Fields.Item[0].Value;
//    timestamp := query.fields[0].asDateTime;
    Synchronize(UpdateStatus);
    nIntervals := (round(timestamp * 1440) - round(previousTimestamp * 1440)) div timestep;
    if (nIntervals > 1) then begin
      for i := 1 to nIntervals - 1 do begin
        insertTimestamp := previousTimeStamp + (timestep * i / 1440.0);
        insertTimestamp := trunc((insertTimestamp*1440) + 0.5)/1440;
        Synchronize(AddFlowRecord);
      end;
      counter := counter + nIntervals - 1;
    end;
    previousTimestamp := timestamp;
    Synchronize(NextFlowRecord);
  end;
  Synchronize(CloseFirstFlowsQuery);
  Synchronize(FlushFlowsTable);
  Feedback('Number of missing data record inserted: '+inttostr(counter));
  Feedback('');
  Feedback('Determining values for missing and zero data...');
  inBigGap := false;
  Synchronize(OpenSecondFlowsQuery);
  i := 0;
  while ((not queryRecSet.EOF) and (i < windowSize)) do begin
//  while ((not query.eof) and (i < windowSize)) do begin
    dates[i] := queryRecSet.Fields.Item[0].Value;
//    dates[i] := query.fields[0].asDateTime;
    flows[i] := queryRecSet.Fields.Item[1].Value;
//    flows[i] := query.fields[1].asFloat;
    codes[i] := queryRecSet.Fields.Item[2].Value;
//    codes[i] := query.fields[2].asInteger;
    inc(i);
    Synchronize(NextFlowRecord);
  end;
  for i := 1 to midPoint - 1 do begin
    if (codes[i] in [0,4,6]) then begin
      if (not (codes[i-1] in [0,4,6])) then interpolateFlow(i);
    end
    else begin
      if (inBigGap) then begin
        bigGapEnd := dates[i];
        Feedback('Large Gap between '+dateTimeString(bigGapStart)+' and '+dateTimeString(bigGapEnd));
        inBigGap := false;
      end;
    end;
  end;
  while (not queryRecSet.EOF) do begin
//  while (not query.eof) do begin
    timestamp := dates[midPoint];
    Synchronize(UpdateStatus);
    if (codes[midPoint] in [0,4,6]) then begin
      if (not (codes[midPoint-1] in [0,4,6])) then interpolateFlow(midPoint);
    end
    else begin
      if (inBigGap) then begin
        bigGapEnd := dates[midPoint];
        Feedback('Large Gap between '+dateTimeString(bigGapStart)+' and '+dateTimeString(bigGapEnd));
        inBigGap := false;
      end;
    end;
    for i := 0 to windowSize - 2 do begin
      dates[i] := dates[i+1];
      flows[i] := flows[i+1];
      codes[i] := codes[i+1];
    end;
    dates[windowSize-1] := queryRecSet.Fields.Item[0].Value;
//    dates[windowSize-1] := query.fields[0].asDateTime;
    flows[windowSize-1] := queryRecSet.Fields.Item[1].Value;
//    flows[windowSize-1] := query.fields[1].asFloat;
    codes[windowSize-1] := queryRecSet.Fields.Item[2].Value;
//    codes[windowSize-1] := query.fields[2].asInteger;
    Synchronize(NextFlowRecord);
  end;
  for i := midPoint to windowSize - 2 do begin
    if (codes[i] in [0,4,6]) then begin
      if (not (codes[i-1] in [0,4,6])) then interpolateFlow(i);
    end
    else begin
      if (inBigGap) then begin
        bigGapEnd := dates[i];
        Feedback('Large Gap between  '+dateTimeString(bigGapStart)+' and '+dateTimeString(bigGapEnd));
        inBigGap := false;
      end;
    end;
  end;
  Synchronize(CloseSecondFlowsQuery);
  Synchronize(FlushFlowsTable);
  Synchronize(CloseFlowsTable);
  Feedback('');
  Feedback('Computation Complete.  This window may be closed.');
  FreeMem(integerBuffer,4);
  FreeMem(realBuffer,4);
end;

procedure FillinMissingFlowDataThread.GetFlowMeterData();
var
  flowMeterName: string;
begin
  flowMeterName := frmFillInMissingDataForm.FlowMeterNameComboBox.Items[frmFillInMissingDataForm.FlowMeterNameComboBox.ItemIndex];
  meterID := DatabaseModule.GetMeterIDForName(flowMeterName);
  timestep := DatabaseModule.GetFlowTimestep(meterID);
end;

procedure FillinMissingFlowDataThread.OpenFlowsTable();
begin
  tableRecSet := CoRecordSet.Create;
  tableRecSet.Open('Flows',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTableDirect);
  fields := VarArrayCreate([1,4],varVariant);
  values := VarArrayCreate([1,4],varVariant);
  keyValues := VarArrayCreate([1,2],varVariant);
  fields[1] := 'MeterID';
  fields[2] := 'DateTime';
  fields[3] := 'Flow';
  fields[4] := 'Code';

  values[1] := meterID;

  keyValues[1] := meterID;
end;

procedure FillinMissingFlowDataThread.OpenFirstFlowsQuery();
var
  queryStr: string;
begin
  queryStr := 'SELECT DateTime FROM Flows WHERE ' +
              '(MeterID = ' + inttostr(meterID) + ') ORDER BY DateTime;';
  queryRecSet := CoRecordSet.Create;
  queryRecSet.Open(queryStr,frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdText);
//rm 2007-11-27 - a little error checking here:
  if queryRecSet.EOF then begin
    Feedback('No Flow Data for Selected Meter.'+#13);
  end else begin
    queryRecSet.MoveFirst;
  end;
end;

procedure FillinMissingFlowDataThread.NextFlowRecord();
begin
  queryRecSet.MoveNext;
end;

procedure FillinMissingFlowDataThread.CloseFirstFlowsQuery();
begin
  queryRecSet.Close;
end;

procedure FillinMissingFlowDataThread.OpenSecondFlowsQuery();
var
  queryStr: string;
begin
  queryStr := 'SELECT DateTime, Flow, Code FROM Flows WHERE ' +
              '(MeterID = ' + inttostr(meterID) + ') ORDER BY DateTime;';
  queryRecSet := CoRecordSet.Create;
  queryRecSet.Open(queryStr,frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdText);
//rm 2007-11-27 - a little error checking here:
  if queryRecSet.EOF then begin
    Feedback('No Flow Data for Selected Meter.'+#13);
  end else begin
    queryRecSet.MoveFirst;
  end;
end;

procedure FillinMissingFlowDataThread.CloseSecondFlowsQuery();
begin
  queryRecSet.Close;
end;

procedure FillinMissingFlowDataThread.FlushFlowsTable();
begin
//  table.FlushBuffers;
end;

procedure FillinMissingFlowDataThread.CloseFlowsTable();
begin
  tableRecSet.Close;
end;

procedure FillinMissingFlowDataThread.UpdateFlowRecord();
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'UPDATE Flows SET ' +
            'Flow = ' + floattostr(flows[missing]) + ', ' +
            'Code = ' + inttostr(codes[missing]) + ' WHERE ' +
            '(MeterID = ' + inttostr(meterID) + ') AND ' +
//rm 2007-11-27 these dates as floats are not working
//            '(DateTime = ' + floattostr(dates[missing]) + ');';
//dateTimeString(dates[missing]
            '(DateTime = #' + dateTimeString(dates[missing]) + '#);';
//            '(ABS(DateTime - ' + floattostr(dates[missing]) + ') < 0.0001);';
//            '(INT(DateTime * 1440) = ' + inttostr(trunc(dates[missing] * 1440)) + ');';
//original:            '(DateTime = ' + floattostr(dates[missing]) + ');';
//  Feedback(sqlStr+#13);
  frmMain.connection.Execute(sqlStr,recordsAffected,adCmdText);
//  Feedback(' Records: ' + inttostr(recordsAffected)+#13);

//  table.Locate('MeterID;DateTime',VarArrayOf([meterID,dates[missing]]),[]);
//  table.Edit;
//  realBuffer^ := flows[missing];
//  table.fields.fieldByName('Flow').SetData(realBuffer);
//  integerBuffer^ := codes[missing];
//  table.fields.FieldByName('Code').SetData(integerBuffer);
end;

procedure FillinMissingFlowDataThread.AddFlowRecord();
begin
  values[2] := insertTimestamp;
  values[3] := 0.0;
  values[4] := 4;
  try
    tableRecSet.AddNew(fields,values);
  except
    ShowADOErrors(frmMain.Connection.Errors);
  end;
end;

procedure FillinMissingFlowDataThread.UpdateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(timestamp);
end;

procedure FillinMissingFlowDataThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(textToAdd);
end;

procedure FillinMissingFlowDataThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;

procedure FillinMissingFlowDataThread.ShowADOErrors(ErrorList: ADODB_TLB.Errors);
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

