unit ExportPRNTRAINThread;

interface

uses
  Classes, ADODB_TLB, Variants;

type
  PRNTRAINExportThread = class(TThread)
    raingaugeName, exportUnitLabel, textToAdd: string;
    raingaugeID, decimalPlaces: integer;
    timestamp: TDateTime;
    conversionFactor: real;
    recSet: _RecordSet;
    constructor CreateIt();
  private  { Private declarations }
    procedure GetRaingaugeData();
    procedure GetDecimalPlaces();
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

uses windows, sysutils, dialogs, feedbackWithMemo, exportprntraintabular,
     modDatabase, mainform;

constructor PRNTRAINExportThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true; // Thread Free Itself when terminated
  Suspended := false;         // Continue the thread
end;

destructor PRNTRAINExportThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure PRNTRAINExportThread.Execute;
var
  F: TextFile;
  nextTimestamp: TDateTime;
  rain, nextRain, decimalHour, timeStepInDays: real;
  timeStepInMinutes, counter: integer;
  month, day, year, hour, minute, second, ms, code: word;
  nextMonth, nextDay, nextYear, nextHour, nextMinute, nextCode: word;
  filename: string;
begin
  filename := frmExportPRNTRAINTabular.FilenameEdit.Text;
  raingaugeName := frmExportPRNTRAINTabular.RaingaugeNameComboBox.Items.Strings[frmExportPRNTRAINTabular.RaingaugeNameComboBox.ItemIndex];
  exportUnitLabel := frmExportPRNTRAINTabular.UnitsComboBox.Items.Strings[frmExportPRNTRAINTabular.UnitsComboBox.ItemIndex];
  AssignFile(F,filename);
  Rewrite(F);
  try
  Feedback('Exporting...');
  Synchronize(GetRaingaugeData);
  Synchronize(GetDecimalPlaces);
  Synchronize(OpenQuery);
  counter := 0;
  if (frmExportPRNTRAINTabular.separateHoursMinutesRadioButton.checked)
    then writeln(F,'     month       day      year      hour    minute  rainfall      code')
    else writeln(F,'     month       day      year      hour  rainfall      code');
  if (frmExportPRNTRAINTabular.nonzeroObservationsRadioButton.checked) then begin
    while (not recSet.EOF) do begin
      timestamp := TDateTime(recSet.Fields.Item[0].Value);
      Synchronize(UpdateStatus);
      decodeDate(timestamp,year,month,day);
      decodeTime(timestamp,hour,minute,second,ms);
      rain := recSet.Fields.Item[1].Value;
      rain := rain * conversionFactor;
      code := recSet.Fields.Item[2].Value;
      if (frmExportPRNTRAINTabular.separateHoursMinutesRadioButton.checked) then
        writeln(F,month:10,day:10,year:10,hour:10,minute:10,rain:10:decimalPlaces,code:10)
      else begin
        decimalHour := hour + (minute / 60.0);
        writeln(F,month:10,day:10,year:10,decimalHour:10:3,rain:10:decimalPlaces,code:10)
      end;
      inc(counter);
      Synchronize(GetNextRecord);
    end;
  end
  else begin
    timeStepInMinutes := frmExportPRNTRAINTabular.outputTimeStepSpinEdit.Value;
    timeStepInDays := timeStepInMinutes / 1440.0;
    timestamp := TDateTime(recSet.Fields.Item[0].Value);
    decodeDate(timestamp,year,month,day);
    decodeTime(timestamp,hour,minute,second,ms);
    rain := recSet.Fields.Item[1].Value;
    rain := rain * conversionFactor;
    code := recSet.Fields.Item[2].Value;
    while (not recSet.EOF) do begin
      Synchronize(GetNextRecord);
      if not recSet.EOF then begin

      if not varisnull(recSet.Fields.Item[0].Value) then begin

      nextTimestamp := TDateTime(recSet.Fields.Item[0].Value);
      decodeDate(nextTimestamp,nextYear,nextMonth,nextDay);
      decodeTime(nextTimestamp,nextHour,nextMinute,second,ms);
      nextRain := recSet.Fields.Item[1].Value;
      nextRain := nextRain * conversionFactor;
      nextCode := recSet.Fields.Item[2].Value;
      repeat
        if (frmExportPRNTRAINTabular.separateHoursMinutesRadioButton.checked) then
          writeln(F,month:10,day:10,year:10,hour:10,minute:10,rain:10:decimalPlaces,code:10)
        else begin
          decimalHour := hour + (minute / 60.0);
          writeln(F,month:10,day:10,year:10,decimalHour:10:3,rain:10:decimalPlaces,code:10)
        end;
        inc(counter);
        timestamp := timestamp + timeStepInDays;
        timestamp := trunc((timestamp/(timestepInMinutes/1440.0))+0.5)*(timestepInMinutes/1440.0);
        rain := 0.0;
        code := 0;
        decodeDate(timestamp,year,month,day);
        decodeTime(timestamp,hour,minute,second,ms);
      until ((timestamp - nextTimestamp) > (-timeStepInDays / 2.0));
      timeStamp := nextTimestamp;
      month := nextMonth;
      day := nextDay;
      year := nextYear;
      hour := nextHour;
      minute := nextMinute;
      rain := nextRain;
      code := nextCode;
      end;
      end;
    end;
  end;
  finally
    Flush(F);
    CloseFile(F);
    Synchronize(CloseAndFreeQuery);
    Feedbackln('Exporting Complete.');
    Feedbackln('');
    Feedbackln(inttostr(counter)+' records written to '+filename);
    Feedbackln('');
    Feedback('This window may be closed.');
  end;
end;

procedure PRNTRAINExportThread.GetRaingaugeData();
begin
  raingaugeID := DatabaseModule.GetRaingaugeIDForName(raingaugeName);
  conversionFactor := DatabaseModule.GetConversionFactorToUnitForRaingauge(raingaugeID,exportUnitLabel);
end;

procedure PRNTRAINExportThread.GetDecimalPlaces();
var
  queryStr: string;
  localRecSet: _RecordSet;
begin
  queryStr := 'SELECT DecimalPlaces FROM RainUnits WHERE ' +
              'Label = "' + exportUnitLabel + '";';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  localRecSet.MoveFirst;
  decimalPlaces := localRecSet.Fields.Item[0].Value;
  localRecSet.Close;
end;

procedure PRNTRAINExportThread.OpenQuery();
var
  startDateTime, endDateTime: TDateTime;
  queryStr: string;
begin
//this does not work for entire range because the datetimepickers are not being set
  startDateTime := trunc(frmExportPRNTRAINTabular.StartDatePicker.Date) +
                   frac(frmExportPRNTRAINTabular.StartTimePicker.Time);
  endDateTime := trunc(frmExportPRNTRAINTabular.EndDatePicker.Date) +
                 frac(frmExportPRNTRAINTabular.EndTimePicker.Time);
  queryStr := 'SELECT DateTime, Volume, Code FROM Rainfall WHERE ' +
              '(((RaingaugeID =' + inttostr(raingaugeID) + ') AND ' +
              '(DateTime <= ' + floattostr(endDateTime) + ')) AND ' +
              '(DateTime >= ' + floattostr(startDateTime) + ')) ' +
              'ORDER BY DateTime;';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if not recSet.EOF then
    recSet.MoveFirst;
end;

procedure PRNTRAINExportThread.GetNextRecord();
begin
  recSet.MoveNext;
end;

procedure PRNTRAINExportThread.CloseAndFreeQuery();
begin
  if (recSet.State <> adStateClosed) then recSet.Close;
end;

procedure PRNTRAINExportThread.UpdateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(timestamp);
end;

procedure PRNTRAINExportThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Text := frmFeedbackWithMemo.feedbackMemo.Text+textToAdd;
  frmFeedbackWithMemo.feedbackMemo.SelStart := Length(frmFeedbackWithMemo.feedbackMemo.Text)
end;

procedure PRNTRAINExportThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;

procedure PRNTRAINExportThread.FeedbackLn(line: string);
begin
  textToAdd := line+#13+#10;
  Synchronize(AddToFeedbackMemo);
end;

end.
 