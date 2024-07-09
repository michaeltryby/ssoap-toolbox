unit conRainImportThread;

interface

uses
  Classes, ADODB_TLB, Variants;

type
  integerPointer = ^integer;
  realPointer= ^real;
  ImportCONRainThread = class(TThread)
    raingaugeName, sourceUnitLabel, textToAdd: String;
    raingaugeID, timestep, code: integer;
    date: TDateTime;
    rain, conversionFactor: real;
    integerBuffer: integerPointer;
    realBuffer: realPointer;
    recSet: _RecordSet;
    fields, values: OleVariant;
    constructor CreateIt();
  private { Private declarations }
    procedure GetRaingaugeInfo();
    procedure GetUnitInfo();
    procedure OpenRainfallTable();
    procedure UpdateCurrentRainfallRecord();
    procedure AddRainfallRecord();
    procedure CloseAndFreeRainfallTable();
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
  windows, sysutils, feedbackWithMemo, modDatabase, mainform,
  importrainfalldatafromCONfile, rdiiutils
  {$IFDEF VER140 } ,Variants {$ENDIF};

constructor ImportCONRainThread.CreateIt();
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true; // Thread Free Itself when terminated
  Suspended := false;         // Continue the thread
end;

destructor ImportCONRainThread.Destroy;
begin
   PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
   inherited destroy;
end;

procedure ImportCONRainThread.Execute;
type
  y2kRainRec = packed record
                 month: byte;
                 day: byte;
                 year: word;
                 rain: word;
                 ldate: real48;
                 code: byte;
               end;
  nonY2kRainRec = packed record
                    month: word;
                    day: word;
                    year: word;
                    rain: word;
                    ldate: real48;
                  end;
var
  y2kRainFile: file of y2kRainRec;
  nonY2kRainFile: file of nonY2kRainRec;
  previousRain: real;
  minimumDate, maximumDate, previousDate: TDateTime;
  include, isY2k, isEOF: boolean;
  y2kRainDat: y2kRainRec;
  nonY2kRainDat: nonY2kRainRec;
  month,year,day,hour,minute: integer;
  earliestDate, latestDate: TDateTime;
begin
  Feedback('Starting import...');
  earliestDate := 0.0;
  latestDate := 0.0;
  previousDate := 0.0;
  previousRain := 0;

  GetMem(integerBuffer,4);
  GetMem(realBuffer,4);

  raingaugeName := frmImportRainfallFromCONFile.RaingaugeNameComboBox.Items.Strings[frmImportRainfallFromCONFile.RaingaugeNameComboBox.ItemIndex];
  sourceUnitLabel := 'Hundredths of an Inch';
   { must use frac() below because .Time includes the date portion, Arrg!}
  minimumDate := frmImportRainfallFromCONFile.StartDatePicker.DateTime + frac(frmImportRainfallFromCONFile.StartTimePicker.Time);
  maximumDate := frmImportRainfallFromCONFile.EndDatePicker.DateTime + frac(frmImportRainfallFromCONFile.EndTimePicker.Time);

  Synchronize(GetRaingaugeInfo);
  Synchronize(GetUnitInfo);
  Synchronize(OpenRainfallTable);

  isY2K := frmImportRainfallFromCONFile.y2kCheckBox.checked;
  if (isY2k) then begin
    AssignFile(y2kRainFile, frmImportRainfallFromCONFile.FilenameEdit.Text);
    Reset(y2kRainFile);
    isEOF := eof(y2kRainfile);
  end
  else begin
    AssignFile(nonY2kRainFile, frmImportRainfallFromCONFile.FilenameEdit.Text);
    Reset(nonY2kRainFile);
    isEOF := eof(nonY2kRainFile);
  end;

  try
    try
      while (not isEOF) do begin
        if (isY2K) then begin
          read(y2kRainfile,y2kRainDat);
          month := y2kRainDat.month;
          year := y2kRainDat.year;
          day := y2kRainDat.day;
          hour := gethour(y2kRainDat.ldate);
          minute := getminute(y2kRainDat.ldate);
          code := y2kRainDat.code;
          rain := (y2kRainDat.rain)
        end
        else begin
          read(nonY2kRainfile,nonY2kRainDat);
          month := nonY2kRainDat.month;
          year := y2k(nonY2kRainDat.year);
          day := nonY2kRainDat.day;
          hour := gethour(nonY2kRainDat.ldate);
          minute := getminute(nonY2kRainDat.ldate);
          rain := (nonY2kRainDat.rain);
          code := 2;
        end;
        date := EncodeDate(year,month,day)+EncodeTime(hour,minute,0,0);
        date := trunc((date/(timestep/1440.0))+0.5)*(timestep/1440.0);
        if ((earliestDate = 0) or (date < earliestDate)) then earliestDate := date;
        if ((latestDate = 0) or (date > latestDate)) then latestDate := date;
        Synchronize(updateStatus);
        include := true;
        if ((frmImportRainfallFromCONFile.StartDateTimeCheckBox.Enabled) and ((frmImportRainfallFromCONFile.StartDateTimeCheckBox.checked) and (date < minimumDate))) then include := false;
        if ((frmImportRainfallFromCONFile.EndDateTimeCheckBox.Enabled) and ((frmImportRainfallFromCONFile.EndDateTimeCheckBox.checked) and (date > maximumDate))) then include := false;
        if (include) then begin
          rain := rain / conversionFactor;
          if (abs(date - previousDate) < 0.0005) then begin
            if (not frmImportRainfallFromCONFile.FirstValueRadioButton.Checked) then begin
              if (frmImportRainfallFromCONFile.AverageFlowsRadioButton.Checked) then
                rain := (rain + previousRain) * 0.5;
              Synchronize(UpdateCurrentRainfallRecord);
              previousDate := date;
              previousRain := rain;
            end;
          end
          else begin
            Synchronize(AddRainfallRecord);
            previousDate := date;
            previousRain := rain;
          end;
        end;
        if (isY2k)
          then isEOF := eof(y2kRainFile)
          else isEOF := eof(nonY2kRainFile);
      end;
    except
      on E: Exception do begin
        Feedbackln('');
        Feedbackln('');
        Feedbackln('Error reading file "'+frmImportRainfallFromCONFile.FilenameEdit.Text+'".');
        Feedbackln('');
        Feedbackln('This file may not be a rainfall .CON file, or');
        Feedbackln('the Y2K option may not be set correctly.');
        Feedbackln('');
        Feedbackln('');
      end;
    end;
  finally
    Synchronize(CloseAndFreeRainfallTable);
    if (isY2k)
      then CloseFile(y2kRainFile)
      else CloseFile(nonY2kRainFile);
    Synchronize(UpdateMinMaxTimes);
  end;
  FreeMem(integerBuffer, 4);
  FreeMem(realBuffer,4);
  if (earliestDate > 0.0) then begin
    Feedbackln('Import Complete.');
    Feedbackln('');
    Feedbackln('The rainfall data ranged from '+dateTimeString(earliestDate)+' to '+dateTimeString(latestDate)+'.');
  end
  else begin
    Feedbackln('No rainfall data was imported.');
  end;
  Feedbackln('');
  Feedback('This window may be closed.');
end;

procedure ImportCONRainThread.GetRaingaugeInfo();
begin
  raingaugeID := DatabaseModule.GetRaingaugeIDForName(raingaugeName);
  timestep := DatabaseModule.GetRainfallTimestep(raingaugeID);
end;

procedure ImportCONRainThread.GetUnitInfo();
begin
  conversionFactor := DatabaseModule.GetConversionFactorToUnitForRaingauge(raingaugeID,sourceUnitLabel);
end;

procedure ImportCONRainThread.OpenRainfallTable();
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

procedure ImportCONRainThread.CloseAndFreeRainfallTable();
begin
  if (recSet.State <> adStateClosed) then recSet.Close;
end;

procedure ImportCONRainThread.updateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(date);
end;

procedure ImportCONRainThread.AddRainfallRecord();
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

procedure ImportCONRainThread.UpdateCurrentRainfallRecord();
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

procedure ImportCONRainThread.UpdateMinMaxTimes();
begin
  DatabaseModule.UpdateMinMaxRainTimes(raingaugeID);
end;

procedure ImportCONRainThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Text := frmFeedbackWithMemo.feedbackMemo.Text+textToAdd;
  frmFeedbackWithMemo.feedbackMemo.SelStart := Length(frmFeedbackWithMemo.feedbackMemo.Text)
end;

procedure ImportCONRainThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;

procedure ImportCONRainThread.FeedbackLn(line: string);
begin
  textToAdd := line+#13+#10;
  Synchronize(AddToFeedbackMemo);
end;

procedure ImportCONRainThread.ShowADOErrors(ErrorList: ADODB_TLB.Errors);
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
