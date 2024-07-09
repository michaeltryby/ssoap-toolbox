unit catchmentConverterImportThread;

interface

uses
  Classes, ADODB_TLB, Variants;

type
  integerPointer = ^integer;
  realPointer = ^real;

  ConverterImportThread = class(TThread)
    lineCounter : integer;
    //catchmentName: String;
    sourceUnitLabel, textToAdd, catchmentAreaUnitLabel: String;
    //catchmentID, timestep, code: integer;
    fConversionFactor, vConversionFactor, dConversionFactor: real;
    //flow, velocity, depth: real;
    integerBuffer: integerPointer;
    realBuffer: realPointer;
    date: TDateTime;
    linesToSkip: integer;
    tableFormat: string;
    nameColumn, nameWidth: integer;
    areaUnitColumn, areaUnitWidth,
    areaColumn, areaWidth,
    sewershedColumn, sewershedWidth: integer;
    loadpointColumn, loadpointWidth, tagColumn, tagWidth: integer;
    recSet: _RecordSet;
    fields, values: OleVariant;
    name, tag, loadpoint, sewershedName : String;
    areaunit, globalareaunit: Integer;
    area : real;

    constructor CreateIt();
  private { Private declarations }

    procedure UpdateStatus();
    procedure GetConverterInfo();
    procedure GetRDIIAreaInfo();
    procedure OpenRDIIAreaTable();
    procedure CloseFlowAndFreeFlowTable();
    procedure AddRDIIAreaRecord();
    //procedure UpdateCurrentFlowRecord();
    procedure AddToFeedbackMemo();
    procedure FeedbackLn(line: string);
    procedure ShowADOErrors(ErrorList: ADODB_TLB.Errors);
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
  end;

implementation

uses windows, sysutils, feedbackWithMemo, importCatchmentData, modDatabase, rdiiutils,
     mainform
     {$IFDEF VER140 } ,Variants {$ENDIF};

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
  GetMem(integerBuffer,4);
  GetMem(realBuffer,4);

  //sewershedName := frmImportSewerShedDataUsingConverter.SewershedNameComboBox.Items.Strings[frmImportSewerShedDataUsingConverter.SewershedNameComboBox.ItemIndex];

  //Synchronize(GetRDIIAreaInfo);
  Synchronize(GetConverterInfo);
  feedbackln('Got RDII Converter Info.');
  Synchronize(OpenRDIIAreaTable);
  feedbackln('Opened RDII Area Table.');
  AssignFile(F, frmImportRDIIAreaDataUsingConverter.FilenameEdit.Text);
  Reset(F);
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
          if (areaunitColumn > 0) then
            areaUnit := strtoint(copy(fullline,areaUnitColumn,areaUnitWidth))
          else
            areaUnit := -1;
          area := strtofloat(copy(fullline,areaColumn,areaWidth));
          if (sewershedColumn > 0) then
            sewershedName := copy(fullline,sewershedColumn,sewershedWidth)
          else
            sewershedName := '';
          if (loadpointColumn > 0)
            then loadpoint := copy(fullline,loadpointColumn,loadpointWidth)
            else loadpoint := '';
          if (tagColumn > 0)
            then tag := copy(fullline,tagColumn,tagWidth)
            else tag := frmImportRDIIAreaDataUsingConverter.TagEdit.Text;
        end
        else begin {FILE IS CSV FORMAT}
          line := AnsiUpperCase(fullline);
          for i := 1 to length(line) do begin
            //if line[i] in ['A'..'Z','\','/',':','"',chr(39),'_',',',#160] then line[i] := ' ';
            //if line[i] in ['"',chr(39),',',#160] then line[i] := ' ';
            //rm 2007-10-22 - add tab chr(9) to this list
            //if line[i] in ['"',chr(39),',',#160,Chr(9)] then line[i] := ',';
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
          name := substrings[nameColumn];
          if (areaunitColumn > 0) then
            areaUnit := strtoint(substrings[areaUnitColumn])
          else
            areaUnit := -1;
          area := strtofloat(substrings[areaColumn]);
          if (sewershedColumn > 0) then
            sewershedName := substrings[sewershedColumn]
          else
            sewershedName := '';
          if (loadpointColumn > 0)
            then loadpoint := substrings[loadpointColumn]
            else loadpoint := '';
          if (tagColumn > 0)
            then tag := substrings[tagColumn] //copy(fullline,tagColumn,tagWidth)
            else tag := frmImportRDIIAreaDataUsingConverter.TagEdit.Text;
        end;
        Synchronize(updateStatus);
        area := area / fConversionFactor;
        if areaunit < 1 then areaunit := globalareaunit;
        Synchronize(AddRDIIAreaRecord);

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

  Feedbackln('');
  Feedbackln('');
  Feedbackln('This window may be closed.');
  FreeMem(integerBuffer, 4);
  FreeMem(realBuffer,4);
end;

procedure ConverterImportThread.updateStatus;
begin
  frmFeedbackWithMemo.DateLabel.caption := inttostr(lineCounter);
end;

procedure ConverterImportThread.GetRDIIAreaInfo();
begin
  //catchmentID := DatabaseModule.GetCatchmentIDForName(catchmentName);
  //catchmentAreaUnitLabel := DatabaseModule.GetAreaUnitLabelForCatchment(catchmentName);
end;

procedure ConverterImportThread.GetConverterInfo();
var
  RDIIAreaConverterName, queryStr: string;
  localRecSet: _RecordSet;
begin
  RDIIAreaConverterName :=
    frmImportRDIIAreaDataUsingConverter.ConverterComboBox.Items.Strings[frmImportRDIIAreaDataUsingConverter.ConverterComboBox.ItemIndex];
  sourceUnitLabel := DatabaseModule.GetAreaUnitLabelForRDIIAreaConverter(RDIIAreaConverterName);
  //fConversionFactor := DatabaseModule.GetConversionFactorToUnitForRdiiArea(sewershedID,sourceUnitLabel);
  fConversionFactor := 1.0;
  queryStr := 'SELECT LinesToSkip, Format, AreaUnitID, NameColumn, NameWidth, ' +
              'SewerShedColumn, SewerShedWidth, ' +
              'AreaUnitColumn, AreaUnitWidth, AreaColumn, AreaWidth, ' +
              'LoadPointColumn,LoadPointWidth, TagColumn, TagWidth ' +
              'FROM RDIIAreaConverters WHERE ' +
              '(RDIIAreaConverterName = "' + RDIIAreaConverterName + '");';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  localRecSet.MoveFirst;
  linesToSkip := localRecSet.Fields.Item[0].Value;
  tableFormat := localRecSet.Fields.Item[1].Value;
  globalareaunit :=  localRecSet.Fields.Item[2].Value;
  nameColumn := localRecSet.Fields.Item[3].Value;
  nameWidth := localRecSet.Fields.Item[4].Value;
  sewershedColumn := localRecSet.Fields.Item[5].Value;
  sewershedWidth := localRecSet.Fields.Item[6].Value;
  areaUnitColumn := localRecSet.Fields.Item[7].Value;
  areaUnitWidth := localRecSet.Fields.Item[8].Value;
  areaColumn := localRecSet.Fields.Item[9].Value;
  areaWidth := localRecSet.Fields.Item[10].Value;
  loadpointColumn := localRecSet.Fields.Item[11].Value;
  loadpointWidth := localRecSet.Fields.Item[12].Value;
  tagColumn := localRecSet.Fields.Item[13].Value;
  tagWidth := localRecSet.Fields.Item[14].Value;
  localRecSet.Close;
end;

procedure ConverterImportThread.OpenRDIIAreaTable();
begin
  recSet := CoRecordSet.Create;
  recSet.Open('RDIIAreas',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  fields := VarArrayCreate([1,8],varVariant);
  values := VarArrayCreate([1,8],varVariant);
  fields[1] := 'RDIIAreaName';
  fields[2] := 'SewerShedID';
  fields[3] := 'AreaUnitID';
  fields[4] := 'Area';
  fields[5] := 'JunctionID';
  fields[6] := 'Tag';
  //rm 2007-11-21
  fields[7] := 'RainGaugeID';
  fields[8] := 'MeterID';
end;

procedure ConverterImportThread.CloseFlowAndFreeFlowTable();
begin
  recSet.Close;
end;

procedure ConverterImportThread.AddRDIIAreaRecord();
var sewershedID: integer;
begin
  sewershedID := DatabaseModule.GetSewershedIDForName(sewershedName);
  feedbackln('Adding RDII Area ' + name);
  if (sewershedID < 0) then begin
    feedbackln('ERROR - Sewershed "' + sewershedName + '" not found in database.');
  end;
  values[1] := name;
  values[2] := sewershedID;
  values[3] := areaUnit;
  values[4] := area;
  values[5] := loadpoint;
  values[6] := tag;
  values[7] := DatabaseModule.GetRainGaugeIDforSewershedID(sewershedID);
  values[8] := DatabaseModule.GetMeterIDForSewershedID(sewershedID);
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
