unit sewershedConverterImportThread;

interface

uses
  Classes, ADODB_TLB, Variants;

type
  integerPointer = ^integer;
  realPointer = ^real;

  ConverterImportThread = class(TThread)
    lineCounter : integer;
    //sewershedName: String;
    sourceUnitLabel, textToAdd, sewershedAreaUnitLabel: String;
    sewershedID, timestep: integer;
    fConversionFactor, vConversionFactor, dConversionFactor: real;
    integerBuffer: integerPointer;
    realBuffer: realPointer;
    date: TDateTime;
    linesToSkip: integer;
    tableFormat: string;
    nameColumn, nameWidth: integer;
    areaUnitColumn, areaUnitWidth,
    areaColumn, areaWidth,
    loadpointColumn, loadpointWidth, flowmeterColumn, flowmeterWidth: integer;
    tagColumn, tagWidth, raingaugeColumn, raingaugeWidth: integer;
    recSet: _RecordSet;
    fields, values: OleVariant;
    name, tag, loadpoint, raingauge, flowmeter : String;
    sDetails: TStringList;
    areaunit, globalareaunit: Integer;
    area : real;

    constructor CreateIt();
  private { Private declarations }

    procedure UpdateStatus();
    procedure GetConverterInfo();
    procedure GetSewershedInfo();
    procedure OpenSewerShedTable();
    procedure CloseFlowAndFreeFlowTable();
    procedure AddSewerShedRecord();
    procedure AddToFeedbackMemo();
    procedure FeedbackLn(line: string);
    procedure ShowADOErrors(ErrorList: ADODB_TLB.Errors);
    //rm 2009-06-03 Add a record to the import log table
    procedure AddImportLogRecord;
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
  end;

implementation

uses windows, sysutils, feedbackWithMemo, importSewerShedData, modDatabase, rdiiutils,
     mainform
     {$IFDEF VER140 } ,Variants {$ENDIF};

//rm 2007-11-16 - 2 problems -
// 1 - quotes around string values
// 2 - no checking for duplicate sewershed name
//
//rm 2008-11-04 - 2 more problems
// 1 - no checking for non-existent raingauge

constructor ConverterImportThread.CreateIt();
begin
  inherited Create(true);     // Create thread suspended
  FreeOnTerminate := true;    // Thread Free Itself when terminated
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
  F: TextFile;
  fullline, line: String;
  recordCounter: integer;

  i, separatorPosition, fieldCount: integer;
  substrings: array[1..maxFields] of String;
  include, shifted: boolean;
  earliestDate, latestDate: TDateTime;
  nonZeroRecords, negativeRecords: integer;
begin
  Feedbackln('Starting import...');
  sDetails := TStringList.Create;
  GetMem(integerBuffer,4);
  GetMem(realBuffer,4);

  //sewershedName := frmImportSewerShedDataUsingConverter.SewershedNameComboBox.Items.Strings[frmImportSewerShedDataUsingConverter.SewershedNameComboBox.ItemIndex];

  Synchronize(GetSewershedInfo);
  Synchronize(GetConverterInfo);
  feedbackln('Got Sewershed Converter Info.');
  Synchronize(OpenSewerShedTable);
  feedbackln('Opened Sewershed Table.');
  AssignFile(F, frmImportSewerShedDataUsingConverter.FilenameEdit.Text);
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
      Feedbackln('Sewershed import was not successful. Please see if the file is open by another application.');
      Feedbackln('');
      Feedbackln('This window may be closed.');
      Feedbackln('');
      exit;
    end;
  end;
//rm
  lineCounter := linesToSkip;
  recordCounter := 0;
  shifted := false;
  try
    for i := 1 to linesToSkip do readln(F);
    while (not eof(f)) do begin
      inc(lineCounter);
      readln(F,fullline);
      try
        if (tableFormat = 'C/W') then begin   {FILE IS COLUMN/WIDTH FORMAT}
          name := copy(fullline,nameColumn,nameWidth);
          if (areaUnitColumn > 0) then
            areaUnit := strtoint(copy(fullline,areaUnitColumn,areaUnitWidth))
          else
            areaUnit := -1;
          area := strtofloat(copy(fullline,areaColumn,areaWidth));
          if (loadpointColumn > 0) then
            loadpoint := copy(fullline,loadpointColumn,loadpointWidth)
          else
            loadpoint := '';
          if (raingaugeColumn > 0)
            then raingauge := copy(fullline,raingaugeColumn,raingaugeWidth)
            else raingauge := '';
          if (flowmeterColumn > 0)
            then flowmeter := copy(fullline,flowmeterColumn,flowmeterWidth)
            else flowmeter := '';
          if (tagColumn > 0)
            then tag := copy(fullline,tagColumn,tagWidth)
            else tag := frmImportSewerShedDataUsingConverter.TagEdit.Text;
        end
        else begin {FILE IS CSV FORMAT}
          line := AnsiUpperCase(fullline);
          //line := UpperCase(fullline);
          for i := 1 to length(line) do begin
            //if line[i] in ['A'..'Z','\','/',':','"',chr(39),'_',',',#160] then line[i] := ' ';
            //if line[i] in ['"',chr(39),',',#160] then line[i] := ' ';
            //rm 2007-11-16 - BAD idea to convert a double-quote to a comma!
            //if line[i] in ['"',chr(39),',',#160,chr(9)] then line[i] := ',';
            if line[i] in [',',#160,chr(9)] then line[i] := ',';
          end;
          line := TrimRight(line);
          line := TrimLeft(line);
          line := StringReplace(line,'"','',[rfReplaceAll]);
          //Feedbackln('??.' + line);
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
          name := substrings[nameColumn];
          if (areaUnitColumn > 0) then
            areaUnit := strtoint(substrings[areaUnitColumn])
          else
            areaUnit := -1;
          area := strtofloat(substrings[areaColumn]);
          if (loadpointColumn > 0) then
            loadpoint := substrings[loadpointColumn]
          else
            loadpoint := '';
          if (raingaugeColumn > 0)
            then raingauge := substrings[raingaugeColumn]
            else raingauge := '';
          if (flowmeterColumn > 0)
            then flowmeter := substrings[flowmeterColumn]
            else flowmeter := '';
          if (tagColumn > 0)
            then tag := substrings[tagColumn] //copy(fullline,tagColumn,tagWidth)
            else tag := frmImportSewerShedDataUsingConverter.TagEdit.Text;

        end;
        Synchronize(updateStatus);
        area := area / fConversionFactor;
        if (areaunit < 1) then areaUnit := globalareaunit;
        Synchronize(AddSewerShedRecord);
        Synchronize(AddImportLogRecord);
      except
        on E: Exception do begin
          Feedbackln('Error reading data on line '+inttostr(lineCounter)+': '+fullline);
        end;
      end;
    end;
  finally
    Synchronize(CloseFlowAndFreeFlowTable);
    CloseFile(f);
  end;
  Feedbackln('');
  Feedbackln('Import Complete.');

  //if (shifted) then Feedbackln('  Warning :  Times were shifted to the nearest '+inttostr(timestep)+' increment');

  Feedbackln('');
  Feedbackln('');
  Feedbackln('This window may be closed.');
  //rm 2009-06-10 - multiple sewershed ids per import Synchronize(AddImportLogRecord);
  FreeMem(integerBuffer, 4);
  FreeMem(realBuffer,4);
end;

procedure ConverterImportThread.updateStatus;
begin
  frmFeedbackWithMemo.DateLabel.caption := inttostr(lineCounter);
end;

procedure ConverterImportThread.GetSewershedInfo();
begin
  //sewershedID := DatabaseModule.GetSewershedIDForName(sewershedName);
  //sewershedAreaUnitLabel := DatabaseModule.GetAreaUnitLabelForSewershed(sewershedName);
end;

procedure ConverterImportThread.GetConverterInfo();
var
  sewershedConverterName, queryStr: string;
  localRecSet: _RecordSet;
begin
  sewershedConverterName := frmImportSewerShedDataUsingConverter.ConverterComboBox.Items.Strings[frmImportSewerShedDataUsingConverter.ConverterComboBox.ItemIndex];
  sourceUnitLabel := DatabaseModule.GetAreaUnitLabelForSewerShedConverter(sewershedConverterName);
  //fConversionFactor := DatabaseModule.GetConversionFactorToUnitForRdiiArea(sewershedID,sourceUnitLabel);
  fConversionFactor := 1.0;
  queryStr := 'SELECT LinesToSkip, Format, AreaUnitID, NameColumn, NameWidth, AreaUnitColumn, ' +
              'AreaUnitWidth, AreaColumn, AreaWidth, ' +
              'RainGaugeIDColumn, RainGaugeIDWidth, ' +
              'FlowMeterIDColumn, FlowMeterIDWidth, ' +
              'LoadPointColumn,LoadPointWidth,TagColumn, TagWidth ' +
              'FROM SewerShedConverters WHERE ' +
              '(SewerShedConverterName = "' + sewershedConverterName + '");';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  localRecSet.MoveFirst;
  linesToSkip := localRecSet.Fields.Item[0].Value;
  tableFormat := localRecSet.Fields.Item[1].Value;
  globalareaunit := localRecSet.Fields.Item[2].Value;
  nameColumn := localRecSet.Fields.Item[3].Value;
  nameWidth := localRecSet.Fields.Item[4].Value;
  //rm 2007-11-16 - not used anymore
  areaUnitColumn := 0; //localRecSet.Fields.Item[5].Value;
  areaUnitWidth := 10; //localRecSet.Fields.Item[6].Value;
  areaColumn := localRecSet.Fields.Item[7].Value;
  areaWidth := localRecSet.Fields.Item[8].Value;
  raingaugeColumn := localRecSet.Fields.Item[9].Value;
  raingaugeWidth := localRecSet.Fields.Item[10].Value;
  flowmeterColumn := localRecSet.Fields.Item[11].Value;
  flowmeterWidth := localRecSet.Fields.Item[12].Value;
  loadpointColumn := localRecSet.Fields.Item[13].Value;
  loadpointWidth := localRecSet.Fields.Item[14].Value;
  tagColumn := localRecSet.Fields.Item[15].Value;
  tagWidth := localRecSet.Fields.Item[16].Value;
  localRecSet.Close;
end;

procedure ConverterImportThread.OpenSewerShedTable();
begin
  recSet := CoRecordSet.Create;
  recSet.Open('SewerSheds',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  fields := VarArrayCreate([1,7],varVariant);
  values := VarArrayCreate([1,7],varVariant);
  fields[1] := 'SewershedName';
  fields[2] := 'AreaUnitID';
  fields[3] := 'Area';
  fields[4] := 'RainGaugeID';
  fields[5] := 'MeterID';
  fields[6] := 'JunctionID';
  fields[7] := 'Tag';
end;

procedure ConverterImportThread.CloseFlowAndFreeFlowTable();
begin
  recSet.Close;
end;

procedure ConverterImportThread.AddImportLogRecord;
var iSewershedIdx, idx: integer;
begin
  //rm 2009-06-03 - add to log file
  iSewershedIdx := DatabaseModule.GetSewershedIDForName(name);
  idx := DatabaseModule.GetSewershedConverterIndexForName(
   frmImportSewerShedDataUsingConverter.ConverterComboBox.Items.Strings[frmImportSewerShedDataUsingConverter.ConverterComboBox.ItemIndex]);
  DatabaseModule.LogImport(3, iSewershedIdx, idx,
    frmImportSewerShedDataUsingConverter.FilenameEdit.Text, Now,
    sDetails.Text);
end;

procedure ConverterImportThread.AddSewerShedRecord();
var
  raingaugeID, flowmeterID: integer;
begin
  sDetails.Clear;
  raingaugeID := DatabaseModule.GetRaingaugeIDForName(raingauge);
  flowmeterID := DatabaseModule.GetMeterIDForName(flowmeter);
  feedbackln('Adding Sewershed ' + name);
  sDetails.Add('Adding Sewershed ' + name);
  //rm 2008-11-04 - check for non-existant raingauge
  if (raingaugeID < 0) then begin
     feedbackln('ERROR - Raingauge Name "' + raingauge + '" not found in database.');
     sDetails.Add('ERROR - Raingauge Name "' + raingauge + '" not found in database.');
  end;
  //rm 2009-06-10 - ditto for flowmeters
  if (flowmeterID < 0) then begin
     feedbackln('ERROR - Flowmeter Name "' + flowmeter + '" not found in database.');
     sDetails.Add('ERROR - Flowmeter Name "' + flowmeter + '" not found in database.');
  end;
  values[1] := name;
  values[2] := areaUnit;
  values[3] := area;
  values[4] := raingaugeID;
  values[5] := flowmeterID;
  values[6] := loadpoint;
  values[7] := tag;
  try
    recSet.AddNew(fields,values);
  except
    ShowADOErrors(frmMain.Connection.Errors);
  end;
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
