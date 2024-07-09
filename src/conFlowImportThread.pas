unit conFlowImportThread;

interface

uses
  Classes, ADODB_TLB, Variants;

type
  integerPointer = ^integer;
  realPointer = ^real;
  ImportY2KFlowThread = class(TThread)
    flowMeterName, sourceUnitLabel, textToAdd: String;
    meterID, timestep, code: integer;
    conversionFactor, flow: real;
    integerBuffer: integerPointer;
    realBuffer: realPointer;
    date: TDateTime;
    recSet: _RecordSet;
    fields, values: OleVariant;
    constructor CreateIt();
  private
    procedure GetMeterInfo();
    procedure OpenFlowTable();
    procedure AddFlowRecord();
    procedure UpdateCurrentFlowRecord();
    procedure CloseAndFreeFlowTable();
    procedure UpdateMinMaxTimes();
    procedure UpdateStatus();
    procedure AddToFeedbackMemo();
    procedure Feedback(line: string);
    procedure FeedbackLn(line: string);
    procedure ShowADOErrors(ErrorList: ADODB_TLB.Errors);
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
  end;

implementation

uses
  sysutils, windows, rdiiutils, modDatabase, importflowdatafromCONfile,
  feedbackWithMemo, mainform
  {$IFDEF VER140 } ,Variants {$ENDIF};

constructor ImportY2KFlowThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true; // Thread Free Itself when terminated
  Suspended := false;         // Continue the thread
end;

destructor ImportY2KFlowThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure ImportY2KFlowThread.Execute;
type
  y2kFlowRec = packed record
                 month: byte;
                 day: byte;
                 year: word;
                 flow: real48;
                 ldate: real48;
                 code: byte;
               end;
  nonY2kFlowRec = packed record
                    month: byte;
                    day: byte;
                    year: byte;
                    flow: real48;
                    ldate: real48;
                  end;

var
  y2kFile: file of y2kFlowRec;
  nonY2kFile: file of nonY2kFlowRec;
  month, year, day, hour, minute: integer;
  previousFlow: real;
  previousDate, minimumDate, maximumDate: TDateTime;
  include, isEOF, isY2k: boolean;
  y2kFlowdat: y2kFlowRec;
  nonY2kFlowdat: nonY2kFlowRec;
  earliestDate, latestDate: TDateTime;
begin
  Feedback('Starting import...');
  earliestDate := 0.0;
  latestDate := 0.0;
  previousDate := 0.0;
  previousFlow := 0.0;

  GetMem(integerBuffer,4);
  GetMem(realBuffer,4);

  flowMeterName := frmImportFlowFromCONFile.FlowMeterNameComboBox.Items.Strings[frmImportFlowFromCONFile.FlowMeterNameComboBox.ItemIndex];
  sourceUnitLabel := frmImportFlowFromCONFile.UnitsComboBox.Items.Strings[frmImportFlowFromCONFile.UnitsComboBox.ItemIndex];
  { must use frac() below because .Time includes the date portion, Arrg!}
  minimumDate := frmImportFlowFromCONFile.StartDatePicker.DateTime + frac(frmImportFlowFromCONFile.StartTimePicker.Time);
  maximumDate := frmImportFlowFromCONFile.EndDatePicker.DateTime + frac(frmImportFlowFromCONFile.EndTimePicker.Time);

  Synchronize(GetMeterInfo);

  isY2K := frmImportFlowFromCONFile.y2kCheckBox.checked;
  if (isY2K) then begin
    AssignFile(y2kFile, frmImportFlowFromCONFile.FilenameEdit.Text);
    Reset(y2kFile);
    isEOF := eof(y2kFile);
  end
  else begin
    AssignFile(nonY2kFile, frmImportFlowFromCONFile.FilenameEdit.Text);
    Reset(nonY2kFile);
    isEOF := eof(nonY2kFile);
  end;
  Synchronize(OpenFlowTable);

  try
    try
      while (not isEOF) do begin
        if (isY2K) then begin
          read(y2kFile,y2kFlowdat);
          month := y2kFlowdat.month;
          year := y2kFlowdat.year;
          day := y2kFlowdat.day;
          hour := gethour(y2kFlowdat.ldate);
          minute := getminute(y2kFlowdat.ldate);
          code := y2kFlowdat.code;
          flow := y2kFlowdat.flow;
        end
        else begin
          read(nonY2kFile,nonY2kFlowdat);
          month := nonY2kFlowdat.month;
          year := y2k(nonY2kFlowdat.year);
          day := nonY2kFlowdat.day;
          hour := gethour(nonY2kFlowdat.ldate);
          minute := getminute(nonY2kFlowdat.ldate);
          flow := nonY2kFlowdat.flow;
          code := 2;
        end;
        date := EncodeDate(year,month,day)+EncodeTime(hour,minute,0,0);
        date := trunc((date/(timestep/1440.0))+0.5)*(timestep/1440.0);
        if ((earliestDate = 0) or (date < earliestDate)) then earliestDate := date;
        if ((latestDate = 0) or (date > latestDate)) then latestDate := date;
        Synchronize(updateStatus);
        include := true;
        if ((frmImportFlowFromCONFile.StartDateTimeCheckBox.Enabled) and ((frmImportFlowFromCONFile.StartDateTimeCheckBox.checked) and (date < minimumDate))) then include := false;
        if ((frmImportFlowFromCONFile.EndDateTimeCheckBox.Enabled) and ((frmImportFlowFromCONFile.EndDateTimeCheckBox.checked) and (date > maximumDate))) then include := false;
        if (include) then begin
          flow := flow / conversionFactor;
          if ((flow = 0.0) and (frmImportFlowFromCONFile.ConsiderZeroFlowsMissingDataCheckBox.checked)) then code := 0;
          if ((flow < 0.0) and (frmImportFlowFromCONFile.ConsiderNegativeFlowsMissingDataCheckBox.checked)) then code := 0;
          if (abs(date - previousDate) < 0.0005) then begin
            if (not frmImportFlowFromCONFile.FirstFlowRadioButton.Checked) then begin
              if (frmImportFlowFromCONFile.AverageFlowsRadioButton.Checked) then
                flow := (flow + previousFlow) * 0.5;
              Synchronize(UpdateCurrentFlowRecord);
              previousDate := date;
              previousFlow := flow;
            end;
          end
          else begin
            Synchronize(AddFlowRecord);
            previousDate := date;
            previousFlow := flow;
          end;
        end;
        if (isY2K)
          then isEOF := eof(y2kFile)
          else isEOF := eof(nonY2kFile);
      end;
    except
      on E: Exception do begin
        Feedbackln('');
        Feedbackln('');
        Feedbackln('Error reading file "'+frmImportFlowFromCONFile.FilenameEdit.Text+'".');
        Feedbackln('');
        Feedbackln('This file may not be a flow .CON file, or');
        Feedbackln('the Y2K option may not be set correctly.');
        Feedbackln('');
        Feedbackln('');
      end;
    end;
  finally
    Synchronize(CloseAndFreeFlowTable);
    if (isY2K)
      then CloseFile(y2kFile)
      else CloseFile(nonY2kFile);
    Synchronize(UpdateMinMaxTimes);
  end;
  FreeMem(integerBuffer,4);
  FreeMem(realBuffer,4);
  if (earliestDate > 0.0) then begin
    Feedbackln('Import Complete.');
    Feedbackln('');
    Feedbackln('The flow data ranged from '+dateTimeString(earliestDate)+' to '+dateTimeString(latestDate)+'.');
  end
  else begin
    Feedbackln('No flow data was imported.');
  end;
  Feedbackln('');
  Feedback('This window may be closed.');
end;

procedure ImportY2KFlowThread.GetMeterInfo();
begin
  meterID := DatabaseModule.GetMeterIDForName(flowMeterName);
  timestep := DatabaseModule.GetFlowTimestep(meterID);
  conversionFactor := DatabaseModule.GetConversionFactorToUnitForMeter(meterID,sourceUnitLabel);
end;

procedure ImportY2KFlowThread.OpenFlowTable();
begin
  recSet := CoRecordSet.Create;
  recSet.Open('Flows',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  fields := VarArrayCreate([1,4],varVariant);
  values := VarArrayCreate([1,4],varVariant);
  fields[1] := 'MeterID';
  fields[2] := 'DateTime';
  fields[3] := 'Flow';
  fields[4] := 'Code';

  values[1] := meterID;
end;

procedure ImportY2KFlowThread.CloseAndFreeFlowTable();
begin
  if (recSet.State <> adStateClosed) then recSet.Close;
end;

procedure ImportY2KFlowThread.AddFlowRecord();
begin
  values[2] := date;
  values[3] := flow;
  values[4] := code;
  try
    recSet.AddNew(fields,values);
  except
    ShowADOErrors(frmMain.Connection.Errors);
  end;
end;

procedure ImportY2KFlowThread.UpdateCurrentFlowRecord();
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

procedure ImportY2KFlowThread.UpdateMinMaxTimes();
begin
  DatabaseModule.UpdateMinMaxFlowTimes(meterID);
end;

procedure ImportY2KFlowThread.UpdateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(date);
end;

procedure ImportY2KFlowThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Text := frmFeedbackWithMemo.feedbackMemo.Text+textToAdd;
  frmFeedbackWithMemo.feedbackMemo.SelStart := Length(frmFeedbackWithMemo.feedbackMemo.Text)
end;

procedure ImportY2KFlowThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;

procedure ImportY2KFlowThread.FeedbackLn(line: string);
begin
  textToAdd := line+#13+#10;
  Synchronize(AddToFeedbackMemo);
end;

procedure ImportY2KFlowThread.ShowADOErrors(ErrorList: ADODB_TLB.Errors);
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
