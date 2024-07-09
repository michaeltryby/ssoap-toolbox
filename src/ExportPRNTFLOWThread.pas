unit ExportPRNTFLOWThread;

interface

uses
  Classes, ADODB_TLB;

type
  PRNTFLOWExportThread = class(TThread)
    meterID: integer;
    flowMeterName, exportUnitLabel, textToAdd: string;
    conversionFactor: real;
    timestamp: TDateTime;
    recSet: _RecordSet;
    constructor CreateIt();
  private  { Private declarations }
    procedure GetFlowMeterData();
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

implementation

uses mainform, windows, sysutils, dialogs, feedbackWithMemo, exportprntflowcsv, modDatabase;

constructor PRNTFLOWExportThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true; // Thread Free Itself when terminated
  Suspended := false;         // Continue the thread
end;

destructor PRNTFLOWExportThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure PRNTFLOWExportThread.Execute;
var
  F: TextFile;
  filename, line: string;
  flow: real;
  month, day, year, hour, minute, second, ms, code: word;
  counter: integer;
begin
  filename := frmExportPRNTFLOWCSV.FilenameEdit.Text;
  flowMeterName := frmExportPRNTFLOWCSV.FlowMeterNameComboBox.Items.Strings[frmExportPRNTFLOWCSV.FlowMeterNameComboBox.ItemIndex];
  exportUnitLabel := frmExportPRNTFLOWCSV.UnitsComboBox.Items.Strings[frmExportPRNTFLOWCSV.UnitsComboBox.ItemIndex];
  AssignFile(F,filename);
  Rewrite(F);
  try
  Feedback('Exporting...');
  writeln(F,'"',flowMeterName,'"');
  line := '"Month","Day","Year","Hour","Minute","Flow ('+ exportUnitLabel + ')","Code"';
  writeln(F,line);
  Synchronize(GetFlowMeterData);
  Synchronize(OpenQuery);
  counter := 0;
  while (not recSet.EOF) do begin
    inc(counter);
    timestamp := TDateTime(recSet.Fields.Item[0].Value);
    Synchronize(updateStatus);
    decodeDate(timestamp,year,month,day);
    decodeTime(timestamp,hour,minute,second,ms);
    flow := recSet.Fields.Item[1].Value;
    flow := flow * conversionFactor;
    code := recSet.Fields.Item[2].Value;
    line := inttostr(month)+', '+inttostr(day)+', '+inttostr(year)+', '+inttostr(hour)+', '+inttostr(minute)+', '+FloatToStrF(flow,ffFixed,15,3)+', '+inttostr(code);
    writeln(F,line);
    Synchronize(GetNextRecord);
  end;
  finally
    CloseFile(F);
    Synchronize(CloseAndFreeQuery);
    Feedbackln('Exporting Complete.');
    Feedbackln('');
    Feedbackln(inttostr(counter)+' records written to '+filename);
    Feedbackln('');
    Feedback('This window may be closed.');
  end;
end;

procedure PRNTFLOWExportThread.GetFlowMeterData();
begin
  meterID := DatabaseModule.GetMeterIDForName(flowMeterName);
  conversionFactor := DatabaseModule.GetConversionFactorToUnitForMeter(meterID,exportUnitLabel);
end;

procedure PRNTFLOWExportThread.OpenQuery();
var
  startDateTime, endDateTime: TDateTime;
  queryStr: string;
begin
  startDateTime := frmExportPRNTFLOWCSV.StartDatePicker.Date +
                   frac(frmExportPRNTFLOWCSV.StartTimePicker.Time);
  endDateTime := frmExportPRNTFLOWCSV.EndDatePicker.Date +
                 frac(frmExportPRNTFLOWCSV.EndTimePicker.Time);
  queryStr := 'SELECT DateTime, Flow, Code FROM Flows WHERE ' +
              '(((MeterID =' + inttostr(meterID) + ') AND ' +
              '(DateTime <= ' + floattostr(endDateTime) + ')) AND ' +
              '(DateTime >= ' + floattostr(startDateTime) + ')) ' +
              'ORDER BY DateTime;';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if no data
  if not recSet.EOF then
    recSet.MoveFirst;
end;

procedure PRNTFLOWExportThread.GetNextRecord();
begin
  recSet.MoveNext;
end;

procedure PRNTFLOWExportThread.CloseAndFreeQuery();
begin
  if (recSet.State <> adStateClosed) then recSet.Close;
end;

procedure PRNTFLOWExportThread.UpdateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(timestamp);
end;

procedure PRNTFLOWExportThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Text := frmFeedbackWithMemo.feedbackMemo.Text+textToAdd;
  frmFeedbackWithMemo.feedbackMemo.SelStart := Length(frmFeedbackWithMemo.feedbackMemo.Text)
end;

procedure PRNTFLOWExportThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;

procedure PRNTFLOWExportThread.FeedbackLn(line: string);
begin
  textToAdd := line+#13+#10;
  Synchronize(AddToFeedbackMemo);
end;

end.
