unit rdiiConverterImportThread;

interface

uses
  Classes, ADODB_TLB, Variants;

type
  integerPointer = ^integer;
  realPointer = ^real;

  rdiiConvertandImportThread = class(TThread)
    lineCounter : integer;
    sewershedName: String;
    sourceUnitLabel, textToAdd, sewershedAreaUnitLabel: String;
    sewershedID, timestep, code: integer;
    fConversionFactor, vConversionFactor, dConversionFactor: real;
    flow, velocity, depth: real;
    integerBuffer: integerPointer;
    realBuffer: realPointer;
    date: TDateTime;
    linesToSkip: integer;
    tableFormat: string;
    nodeColumn, nodeWidth: integer;
    areaColumn, areaWidth, nodeLocationXColumn, nodeLocationXWidth, nodeLocationYColumn, nodeLocationYWidth: integer;
    tagColumn, tagWidth, codeColumn, codeWidth: integer;
    recSet: _RecordSet;
    fields, values: OleVariant;
    node, tag : String;
    area, nodeLocationX, nodeLocationY : real;

    constructor CreateIt();
  private { Private declarations }

    procedure UpdateStatus();
    procedure GetConverterInfo();
    procedure GetSewershedInfo();
    procedure OpenRdiiTable();
    procedure CloseFlowAndFreeFlowTable();
    procedure AddRdiiRecord();
    procedure UpdateCurrentFlowRecord();
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

uses windows, sysutils, feedbackWithMemo, importRdiiData, modDatabase, rdiiutils,
     mainform
     {$IFDEF VER140 } ,Variants {$ENDIF};

constructor rdiiConvertandImportThread.CreateIt();
begin
  inherited Create(true);     // Create thread suspended
  FreeOnTerminate := true;    // Thread Free Itself when terminated
  Suspended := false;         // Continue the thread
end;

destructor rdiiConvertandImportThread.Destroy;
begin
   PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
   inherited destroy;
end;

procedure rdiiConvertandImportThread.Execute;
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

  sewershedName := frmImportRdiiDataUsingConverter.SewershedNameComboBox.Items.Strings[frmImportRdiiDataUsingConverter.SewershedNameComboBox.ItemIndex];

  Synchronize(GetSewershedInfo);
  Synchronize(GetConverterInfo);
  Synchronize(OpenRdiiTable);
  AssignFile(F, frmImportRdiiDataUsingConverter.FilenameEdit.Text);
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
      Feedbackln('RDII import was not successful. Please see if the file is open by another application.');
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
          node := copy(fullline,nodeColumn,nodeWidth);
          area := strtofloat(copy(fullline,areaColumn,areaWidth));
          if (nodeLocationXColumn > 0)
            then nodeLocationX := strtofloat(copy(fullline,nodeLocationXColumn,nodeLocationXWidth))
            else nodeLocationX := 0;
          if (nodeLocationYColumn > 0)
            then nodeLocationY := strtofloat(copy(fullline,nodeLocationYColumn,nodeLocationYWidth))
            else nodeLocationY := 0;
          if (codeColumn > 0)
            then code := strtoint(copy(fullline,codeColumn,codeWidth))
            else code := 1;
          if (tagColumn > 0)
            then tag := copy(fullline,tagColumn,tagWidth)
            else tag := frmImportRdiiDataUsingConverter.TagEdit.Text;
        end
        else begin {FILE IS CSV FORMAT}
          line := AnsiUpperCase(fullline);
          for i := 1 to length(line) do begin
//            if line[i] in ['A'..'Z','\','/',':','"',chr(39),'_',',',#160] then line[i] := ' ';
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
          node := substrings[nodeColumn];
          area := strtofloat(substrings[areaColumn]);
          //if (nodeLocationXColumn > 0)
          //  then nodeLocationX := strtofloat(substrings[nodeLocationXColumn])
          //  else nodeLocationX := 0;
          //if (nodeLocationYColumn > 0)
          //  then nodeLocationY := strtofloat(substrings[nodeLocationYColumn])
          //  else nodeLocationY := 0;
          if (nodeLocationXColumn > 0) then begin
          //rm 2007-10-2
            if (Length(substrings[nodeLocationXColumn])>0) then
              nodeLocationX := strtoint(substrings[nodeLocationXColumn])
              else nodeLocationX := 0;
          end else nodeLocationX := 0;
          if (nodeLocationYColumn > 0) then begin
          //rm 2007-10-2
            if (Length(substrings[nodeLocationYColumn])>0) then
              nodeLocationY := strtoint(substrings[nodeLocationYColumn])
              else nodeLocationY := 0;
          end else nodeLocationY := 0;

          //if (codeColumn > 0)
          //  then code := strtoint(substrings[codeColumn])
          //  else code := 1;
          if (codeColumn > 0) then begin
          //rm 2007-10-2
            if (Length(substrings[codeColumn])>0) then
              code := strtoint(substrings[codeColumn])
              else code := 1;
          end else code := 1;
          //if (tagColumn > 0)
          //  then tag := copy(fullline,tagColumn,tagWidth)
          //  else tag := frmImportRdiiDataUsingConverter.TagEdit.Text;
          if (tagColumn > 0) then begin
          //rm 2007-10-2
            if (Length(substrings[tagColumn])>0) then
              tag := substrings[tagColumn]
              else tag := '';
          end else tag := '';

        end;
        Synchronize(updateStatus);
        area := area / fConversionFactor;
        Synchronize(AddRdiiRecord);

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

  if (shifted) then Feedbackln('  Warning :  Times were shifted to the nearest '+inttostr(timestep)+' increment');

  Feedbackln('');
  Feedbackln('');
  Feedbackln('This window may be closed.');
  Synchronize(AddImportLogRecord);
  FreeMem(integerBuffer, 4);
  FreeMem(realBuffer,4);
end;

procedure rdiiConvertandImportThread.updateStatus;
begin
  frmFeedbackWithMemo.DateLabel.caption := inttostr(lineCounter);
end;

procedure rdiiConvertandImportThread.GetSewershedInfo();
begin
  sewershedID := DatabaseModule.GetSewershedIDForName(sewershedName);
  sewershedAreaUnitLabel := DatabaseModule.GetAreaUnitLabelForSewershed(sewershedName);
end;

procedure rdiiConvertandImportThread.GetConverterInfo();
var
  rdiiConverterName, queryStr: string;
  localRecSet: _RecordSet;
begin
  rdiiConverterName := frmImportRdiiDataUsingConverter.ConverterComboBox.Items.Strings[frmImportRdiiDataUsingConverter.ConverterComboBox.ItemIndex];
  sourceUnitLabel := DatabaseModule.GetAreaUnitLabelForRdiiConverter(rdiiConverterName);
  fConversionFactor := DatabaseModule.GetConversionFactorToUnitForRdiiArea(sewershedID,sourceUnitLabel);
  queryStr := 'SELECT LinesToSkip, Format, NodeColumn, NodeWidth, AreaColumn, ' +
              'AreaWidth, NodeLocationXColumn, NodeLocationXWidth, NodeLocationYColumn, NodeLocationYWidth, ' +
              'CodeColumn, CodeWidth ' +
              'FROM RdiiConverters WHERE ' +
              '(RdiiConverterName = "' + rdiiConverterName + '");';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  localRecSet.MoveFirst;
  linesToSkip := localRecSet.Fields.Item[0].Value;
  tableFormat := localRecSet.Fields.Item[1].Value;
  nodeColumn := localRecSet.Fields.Item[2].Value;
  nodeWidth := localRecSet.Fields.Item[3].Value;
  areaColumn := localRecSet.Fields.Item[4].Value;
  areaWidth := localRecSet.Fields.Item[5].Value;
  nodeLocationXColumn := localRecSet.Fields.Item[6].Value;
  nodeLocationXWidth := localRecSet.Fields.Item[7].Value;
  nodeLocationYColumn := localRecSet.Fields.Item[8].Value;
  nodeLocationYWidth := localRecSet.Fields.Item[9].Value;
  codeColumn := localRecSet.Fields.Item[10].Value;
  codeWidth := localRecSet.Fields.Item[11].Value;
  localRecSet.Close;
end;

procedure rdiiConvertandImportThread.OpenRdiiTable();
begin
  recSet := CoRecordSet.Create;
  //recSet.Open('RDII',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  recSet.Open('RDIIAreas',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  fields := VarArrayCreate([1,6],varVariant);
  values := VarArrayCreate([1,6],varVariant);
  fields[1] := 'JunctionID';
//fields[2] := 'Sewer Area';
  fields[2] := 'Area';
  fields[3] := 'SewershedID';
  fields[4] := 'NodeLocationX';
  fields[5] := 'NodeLocationY';
  fields[6] := 'Tag';

  {values[1] := meterID;}
end;

procedure rdiiConvertandImportThread.CloseFlowAndFreeFlowTable();
begin
  recSet.Close;
end;

procedure rdiiConvertandImportThread.AddImportLogRecord;
var idx: integer;
begin
  //rm 2009-06-03 - add to log file
  idx := DatabaseModule.GetRDIIAreaConverterIndexForName(
   frmImportRdiiDataUsingConverter.ConverterComboBox.Items.Strings[frmImportRdiiDataUsingConverter.ConverterComboBox.ItemIndex]);
  DatabaseModule.LogImport(4, sewershedID, idx,
    frmImportRdiiDataUsingConverter.FilenameEdit.Text, Now,
    frmFeedbackWithMemo.feedbackMemo.Text);
end;

procedure rdiiConvertandImportThread.AddRdiiRecord();
begin
  values[1] := node;
  values[2] := area;
  values[3] := sewershedID;
  values[4] := nodeLocationX;
  values[5] := nodeLocationY;
  values[6] := tag;
  try
    recSet.AddNew(fields,values);
  except
    ShowADOErrors(frmMain.Connection.Errors);
  end;
end;

procedure rdiiConvertandImportThread.UpdateCurrentFlowRecord();
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


procedure rdiiConvertandImportThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Text := frmFeedbackWithMemo.feedbackMemo.Text+textToAdd;
  frmFeedbackWithMemo.feedbackMemo.SelStart := Length(frmFeedbackWithMemo.feedbackMemo.Text)
end;

procedure rdiiConvertandImportThread.FeedbackLn(line: string);
begin
  textToAdd := line+#13+#10;
  Synchronize(AddToFeedbackMemo);
end;

procedure rdiiConvertandImportThread.ShowADOErrors(ErrorList: ADODB_TLB.Errors);
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
