unit rtkPatternConverterImportThread;

interface

uses
  Classes, ADODB_TLB, Variants;

type
  integerPointer = ^integer;
  realPointer = ^real;

  ConverterImportThread = class(TThread)
    lineCounter : integer;
    rtkPatternName, comments: String;
    R1,T1,K1,R2,T2,K2,R3,T3,K3,AM,AR,AI: double;
    //rm 2010-09-29 - added for initial abstraction for RTKs 2 and 3
    AM2,AR2,AI2,AM3,AR3,AI3: double;
    Mon:integer;
    textToAdd: String;
    integerBuffer: integerPointer;
    realBuffer: realPointer;
    date: TDateTime;
    linesToSkip: integer;
    tableFormat: string;
    nameColumn, nameWidth,
    commentsColumn, commentsWidth,
    R1Column, R1Width, T1Column, T1Width, K1Column, K1Width,
    R2Column, R2Width, T2Column, T2Width, K2Column, K2Width,
    R3Column, R3Width, T3Column, T3Width, K3Column, K3Width,
    AMColumn, AMwidth, ARColumn, ARWidth, AIColumn, AIWidth,
    //rm 2010-09-29 - added for initial abstraction for RTKs 2 and 3
    AM2Column, AM2width, AR2Column, AR2Width, AI2Column, AI2Width,
    AM3Column, AM3width, AR3Column, AR3Width, AI3Column, AI3Width,
    MonColumn, MonWidth : integer;
    recSet: _RecordSet;
    fields, values: OleVariant;
    sDetails: TStringList;
    constructor CreateIt();
  private { Private declarations }

    procedure UpdateStatus();
    procedure GetConverterInfo();
    procedure GetRTKPatternInfo();
    procedure OpenRTKPatternTable();
    procedure CloseFlowAndFreeFlowTable();
    procedure AddRTKPatternRecord();
    //procedure UpdateCurrentFlowRecord();
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

uses windows, sysutils, feedbackWithMemo, importRTKPatternData, modDatabase, rdiiutils,
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
  sDetails := TSTringList.Create;
  Feedbackln('Starting import...');

  GetMem(integerBuffer,4);
  GetMem(realBuffer,4);

  //sewershedName := frmImportSewerShedDataUsingConverter.SewershedNameComboBox.Items.Strings[frmImportSewerShedDataUsingConverter.SewershedNameComboBox.ItemIndex];

  Synchronize(GetRTKPatternInfo);
  Synchronize(GetConverterInfo);
  Synchronize(OpenRTKPatternTable);
  AssignFile(F, frmImportRTKPatternData.FilenameEdit.Text);
  Reset(F);
  lineCounter := linesToSkip;
  recordCounter := 0;
  shifted := false;
  try
    for i := 1 to linesToSkip do readln(F);
    while (not eof(f)) do begin
      sDetails.Clear;
      inc(lineCounter);
      readln(F,fullline);
      try
        if (tableFormat = 'C/W') then begin   {FILE IS COLUMN/WIDTH FORMAT}
          rtkPatternName := copy(fullline,nameColumn,nameWidth);
          //rm 2009-06-10 - remove quotes
          rtkPatternName := StringReplace(rtkPatternName, '"', '', [rfReplaceAll, rfIgnoreCase]);
          comments := copy(fullline,commentsColumn,commentsWidth);
          //rm 2009-06-10 - remove quotes
          comments := StringReplace(comments, '"', '', [rfReplaceAll, rfIgnoreCase]);
          R1 := StrToFloat(copy(fullline,R1Column,R1Width));
          T1 := StrToFloat(copy(fullline,T1Column,T1Width));
          K1 := StrToFloat(copy(fullline,K1Column,K1Width));
          R2 := StrToFloat(copy(fullline,R2Column,R2Width));
          T2 := StrToFloat(copy(fullline,T2Column,T2Width));
          K2 := StrToFloat(copy(fullline,K2Column,K2Width));
          R3 := StrToFloat(copy(fullline,R3Column,R3Width));
          T3 := StrToFloat(copy(fullline,T3Column,T3Width));
          K3 := StrToFloat(copy(fullline,K3Column,K3Width));
          if AMColumn > 0 then begin
            AM := StrToFloat(copy(fullline,AMColumn,AMWidth));
            AR := StrToFloat(copy(fullline,ARColumn,ARWidth));
            AI := StrToFloat(copy(fullline,AIColumn,AIWidth));
          end else begin
            AM := 0.0;
            AR := 0.0;
            AI := 0.0;
          end;
          //rm 2010-09-29
          if AM2Column > 0 then begin
            AM2 := StrToFloat(copy(fullline,AM2Column,AM2Width));
            AR2 := StrToFloat(copy(fullline,AR2Column,AR2Width));
            AI2 := StrToFloat(copy(fullline,AI2Column,AI2Width));
          end else begin
            AM2 := 0.0;
            AR2 := 0.0;
            AI2 := 0.0;
          end;
          //rm 2010-09-29
          if AM3Column > 0 then begin
            AM3 := StrToFloat(copy(fullline,AM3Column,AM3Width));
            AR3 := StrToFloat(copy(fullline,AR3Column,AR3Width));
            AI3 := StrToFloat(copy(fullline,AI3Column,AI3Width));
          end else begin
            AM3 := 0.0;
            AR3 := 0.0;
            AI3 := 0.0;
          end;
          if MonColumn > 0 then
            Mon := StrToInt(copy(fullline,MonColumn,MonWidth))
          else
            Mon := 0;
        end
        else begin {FILE IS CSV FORMAT}
          line := AnsiUpperCase(fullline);
          for i := 1 to length(line) do begin
            //if line[i] in ['A'..'Z','\','/',':','"',chr(39),'_',',',#160] then line[i] := ' ';
            //if line[i] in ['"',chr(39),',',#160] then line[i] := ' ';
            if line[i] in [',',#160,Chr(9)] then line[i] := ',';
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
          rtkPatternName := substrings[nameColumn];
          //rm 2009-06-10 - remove quotes
          rtkPatternName := StringReplace(rtkPatternName, '"', '', [rfReplaceAll, rfIgnoreCase]);
          comments := substrings[commentsColumn];
          //rm 2009-06-10 - remove quotes
          comments := StringReplace(comments, '"', '', [rfReplaceAll, rfIgnoreCase]);
          R1 := StrToFloat(substrings[R1Column]);
          T1 := StrToFloat(substrings[T1Column]);
          K1 := StrToFloat(substrings[K1Column]);
          R2 := StrToFloat(substrings[R2Column]);
          T2 := StrToFloat(substrings[T2Column]);
          K2 := StrToFloat(substrings[K2Column]);
          R3 := StrToFloat(substrings[R3Column]);
          T3 := StrToFloat(substrings[T3Column]);
          K3 := StrToFloat(substrings[K3Column]);
          if AMColumn > 0 then begin
            AM := StrToFloat(substrings[AMColumn]);
            AR := StrToFloat(substrings[ARColumn]);
            AI := StrToFloat(substrings[AIColumn]);
          end else begin
            AM := 0.0;
            AR := 0.0;
            AI := 0.0;
          end;
          //rm 2010-09-29
          if AM2Column > 0 then begin
            AM2 := StrToFloat(substrings[AM2Column]);
            AR2 := StrToFloat(substrings[AR2Column]);
            AI2 := StrToFloat(substrings[AI2Column]);
          end else begin
            AM2 := 0.0;
            AR2 := 0.0;
            AI2 := 0.0;
          end;
          if AM3Column > 0 then begin
            AM3 := StrToFloat(substrings[AM3Column]);
            AR3 := StrToFloat(substrings[AR3Column]);
            AI3 := StrToFloat(substrings[AI3Column]);
          end else begin
            AM3 := 0.0;
            AR3 := 0.0;
            AI3 := 0.0;
          end;
          if MonColumn > 0 then
            Mon := StrToInt(substrings[MonColumn])
          else
            Mon := 0;
        end;
        Synchronize(updateStatus);
        Synchronize(AddRTKPatternRecord);
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
  FreeMem(integerBuffer, 4);
  FreeMem(realBuffer,4);
  sDetails.Free;
end;

procedure ConverterImportThread.updateStatus;
begin
  frmFeedbackWithMemo.DateLabel.caption := inttostr(lineCounter);
end;

procedure ConverterImportThread.GetRTKPatternInfo();
begin
  //catchmentID := DatabaseModule.GetCatchmentIDForName(catchmentName);
  //catchmentAreaUnitLabel := DatabaseModule.GetAreaUnitLabelForCatchment(catchmentName);
end;

procedure ConverterImportThread.GetConverterInfo();
var
  RTKPatternConverterName, queryStr: string;
  localRecSet: _RecordSet;
begin
  RTKPatternConverterName :=
    frmImportRTKPatternData.ConverterComboBox.Items.Strings[frmImportRTKPatternData.ConverterComboBox.ItemIndex];
  queryStr := 'SELECT LinesToSkip, [Format], NameColumn, NameWidth, ' +
              'CommentsColumn, CommentsWidth, ' +
              'R1Column, R1Width, T1Column, T1Width, K1Column, K1Width, ' +
              'R2Column, R2Width, T2Column, T2Width, K2Column, K2Width, ' +
              'R3Column, R3Width, T3Column, T3Width, K3Column, K3Width, ' +
              'AMColumn, AMWidth, ARColumn, ARWidth, AIColumn, AIWidth, ' +
//rm 2010-09-29
              'AM2Column, AM2Width, AR2Column, AR2Width, AI2Column, AI2Width, ' +
              'AM3Column, AM3Width, AR3Column, AR3Width, AI3Column, AI3Width, ' +
              'MonColumn, MonWidth ' +
              'FROM RTKPatternConverters WHERE ' +
              '(RTKPatternConverterName = "' + RTKPatternConverterName + '");';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  localRecSet.MoveFirst;
  linesToSkip := localRecSet.Fields.Item[0].Value;
  tableFormat := localRecSet.Fields.Item[1].Value;
  nameColumn := localRecSet.Fields.Item[2].Value;
  nameWidth := localRecSet.Fields.Item[3].Value;
  commentsColumn := localRecSet.Fields.Item[4].Value;
  commentsWidth := localRecSet.Fields.Item[5].Value;
  R1Column := localRecSet.Fields.Item[6].Value;
  R1Width := localRecSet.Fields.Item[7].Value;
  T1Column := localRecSet.Fields.Item[8].Value;
  T1Width := localRecSet.Fields.Item[9].Value;
  K1Column := localRecSet.Fields.Item[10].Value;
  K1Width := localRecSet.Fields.Item[11].Value;
  R2Column := localRecSet.Fields.Item[12].Value;
  R2Width := localRecSet.Fields.Item[13].Value;
  T2Column := localRecSet.Fields.Item[14].Value;
  T2Width := localRecSet.Fields.Item[15].Value;
  K2Column := localRecSet.Fields.Item[16].Value;
  K2Width := localRecSet.Fields.Item[17].Value;
  R3Column := localRecSet.Fields.Item[18].Value;
  R3Width := localRecSet.Fields.Item[19].Value;
  T3Column := localRecSet.Fields.Item[20].Value;
  T3Width := localRecSet.Fields.Item[21].Value;
  K3Column := localRecSet.Fields.Item[22].Value;
  K3Width := localRecSet.Fields.Item[23].Value;

  AMColumn := localRecSet.Fields.Item[24].Value;
  AMWidth := localRecSet.Fields.Item[25].Value;
  ARColumn := localRecSet.Fields.Item[26].Value;
  ARWidth := localRecSet.Fields.Item[27].Value;
  AIColumn := localRecSet.Fields.Item[28].Value;
  AIWidth := localRecSet.Fields.Item[29].Value;
//rm 2010-09-29
  AM2Column := localRecSet.Fields.Item[30].Value;
  AM2Width := localRecSet.Fields.Item[31].Value;
  AR2Column := localRecSet.Fields.Item[32].Value;
  AR2Width := localRecSet.Fields.Item[33].Value;
  AI2Column := localRecSet.Fields.Item[34].Value;
  AI2Width := localRecSet.Fields.Item[35].Value;
  AM3Column := localRecSet.Fields.Item[36].Value;
  AM3Width := localRecSet.Fields.Item[37].Value;
  AR3Column := localRecSet.Fields.Item[38].Value;
  AR3Width := localRecSet.Fields.Item[39].Value;
  AI3Column := localRecSet.Fields.Item[40].Value;
  AI3Width := localRecSet.Fields.Item[41].Value;

  MonColumn := localRecSet.Fields.Item[42].Value;
  MonWidth := localRecSet.Fields.Item[43].Value;

  localRecSet.Close;
end;

procedure ConverterImportThread.OpenRTKPatternTable();
begin
  recSet := CoRecordSet.Create;
  recSet.Open('RTKPatterns',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  fields := VarArrayCreate([1,15],varVariant);
  values := VarArrayCreate([1,15],varVariant);
  fields[1] := 'RTKPatternName';
  fields[2] := 'Description';
  fields[3] := 'R1';
  fields[4] := 'T1';
  fields[5] := 'K1';
  fields[6] := 'R2';
  fields[7] := 'T2';
  fields[8] := 'K2';
  fields[9] := 'R3';
  fields[10] := 'T3';
  fields[11] := 'K3';

  fields[12] := 'AI';
  fields[13] := 'AM';
  fields[14] := 'AR';

  //rm 2010-09-29
  fields[15] := 'AI2';
  fields[16] := 'AM2';
  fields[17] := 'AR2';
  fields[18] := 'AI3';
  fields[19] := 'AM3';
  fields[20] := 'AR3';

  fields[21] := 'Mon';
end;

procedure ConverterImportThread.CloseFlowAndFreeFlowTable();
begin
  recSet.Close;
end;

procedure ConverterImportThread.AddImportLogRecord;
var idx, RTKidx: integer;
begin
  //rm 2009-06-03 - add to log file
//rm 2010-09-29  RTKidx := DatabaseModule.GetRTKPAtternIDforName(rtkPatternName);
  RTKidx := DatabaseModule.GetRTKPAtternIDforNameAndMonth(rtkPatternName, Mon);
  idx := DatabaseModule.GetRTKPatternConverterIndexForName(
   frmImportRTKPatternData.ConverterComboBox.Items.Strings[frmImportRTKPatternData.ConverterComboBox.ItemIndex]);
  DatabaseModule.LogImport(5, RTKidx, idx,
    frmImportRTKPatternData.FilenameEdit.Text, Now,
    sDetails.Text);
end;

procedure ConverterImportThread.AddRTKPatternRecord();
var rtkPatternID: integer;
begin
//rm 2010-09-29 - revised to include initial abstraction for the other two RTK sets
  Feedbackln('Adding RTK Pattern "' + rtkPatternName + '."');
  sDetails.Add('Adding RTK Pattern "' + rtkPatternName + '."');
//rm 2010-09-29  rtkPatternID := DatabaseModule.GetRTKPatternIDForName(RTKPatternName);
  rtkPatternID := DatabaseModule.GetRTKPatternIDForNameAndMonth(RTKPatternName, Mon);
  values[1] := rtkPatternName;
  values[2] := comments;
  values[3] := R1;
  values[4] := T1;
  values[5] := K1;
  values[6] := R2;
  values[7] := T2;
  values[8] := K2;
  values[9] := R3;
  values[10] := T3;
  values[11] := K3;

  values[12] := AI;
  values[13] := AM;
  values[14] := AR;
//rm 2010-09-29  values[15] := Mon;
  values[15] := AI2;
  values[16] := AM2;
  values[17] := AR2;
  values[18] := AI3;
  values[19] := AM3;
  values[20] := AR3;

  values[21] := Mon;
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
    sDetails.Add(s);
  end;
end;


end.
