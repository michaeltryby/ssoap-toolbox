unit swmm5INPrdiiExporterThread;

interface

uses
  Classes, modDatabase, ADODB_TLB, Variants, Uutils;

type
  swmm5INPrdiiExporterThrd = class(TThread)
    constructor CreateIt;
  private
    { Private declarations }
    FSrcSWMM5InpFileName: string;
    FDstSWMM5InpFileName: string;
    FRainGaugeName: string;
    FRainGaugeNames: string;
    FScenarioID: integer;
    FRainGaugeID: integer;
    FStart: TDateTime;
    FEnd: TDateTime;
    FInTextFile: TextFile;
    FOutTextFile: TextFile;
    FFlowUnitLabel: String;
    boReadNext:boolean;
    boAssignedGauges: boolean;
    Line, textToAdd: string;
    procedure OpenSWMM5InpFile;
    procedure CloseSWMM5InpFile;
    function WriteOPTIONSSection(iMode: integer):boolean;
    function WriteRDIISection: boolean;
    function WriteHydrographSection: boolean;
    function WriteRaingagesSection: boolean;
    function WriteTimeseriesSection: boolean;
//rm 2010-04-22 - NO LONGER DOING DWF
(*
    function WriteDWFSection: boolean;
    function WritePatternsSection: boolean;
*)
    procedure AddToFeedbackMemo;
    procedure FeedbackLn(line: string);
    procedure GetInputs;
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
  end;

implementation
uses windows, mainform, sysutils, dialogs, feedbackWithMemo,ExportRDIIHydrographs;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure swmm5INPrdiiexporterThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ swmm5INPrdiiexporterThread }
procedure swmm5INPrdiiExporterThrd.FeedbackLn(line: string);
begin
  textToAdd := line+#13+#10;
  Synchronize(AddToFeedbackMemo);
end;
procedure swmm5INPrdiiExporterThrd.GetInputs;
begin
  FSrcSWMM5InpFileName := frmExportRDIIHydrographs.SWMM5InpFileIn;    //frmmain.FSWMM5InpFileName;
  FDstSWMM5InpFileName := frmExportRDIIHydrographs.SWMM5InpFileOut;   //frmmain.FSWMM5InpFileName2;
  FRainGaugeName := frmExportRDIIHydrographs.RainGaugeName;           //frmmain.FRainGaugeName;
  FRainGaugeNames := '"' + FRainGaugeName + '"';
  FRainGaugeID := frmExportRDIIHydrographs.RainGaugeID;               //frmmain.FRainGaugeID;
  FScenarioID := frmExportRDIIHydrographs.ScenarioID;                 //frmmain.FScenarioID;
  FStart := frmExportRDIIHydrographs.StartDate;                       //frmmain.FStart;
  FEnd := frmExportRDIIHydrographs.EndDate;                           //frmmain.FEnd;
  FFlowUnitLabel := frmExportRDIIHydrographs.FlowUnitLabel;           //frmmain.FFlowUnitLabel;
  boAssignedGauges := frmExportRDIIHydrographs.UseAssignedGauge;
end;

procedure swmm5INPrdiiExporterThrd.AddToFeedbackMemo;
begin
  frmFeedbackWithMemo.feedbackMemo.Text := frmFeedbackWithMemo.feedbackMemo.Text+textToAdd;
  frmFeedbackWithMemo.feedbackMemo.SelStart := Length(frmFeedbackWithMemo.feedbackMemo.Text)
end;

procedure swmm5INPrdiiExporterThrd.CloseSWMM5InpFile;
begin
  try
    CloseFile(FOutTextFile);
    CloseFile(FInTextFile);
  finally

  end;
end;

constructor swmm5INPrdiiExporterThrd.CreateIt;
begin
  inherited Create(true);     // Create thread suspended
  FreeOnTerminate := true;    // Thread Free Itself when terminated
  Suspended := false;         // Continue the thread
{
  FSrcSWMM5InpFileName := frmExportRDIIHydrographs.SWMM5InpFileIn;    //frmmain.FSWMM5InpFileName;
  FDstSWMM5InpFileName := frmExportRDIIHydrographs.SWMM5InpFileOut;   //frmmain.FSWMM5InpFileName2;
  FRainGaugeName := frmExportRDIIHydrographs.RainGaugeName;           //frmmain.FRainGaugeName;
  FRainGaugeNames := '"' + FRainGaugeName + '"';
  FRainGaugeID := frmExportRDIIHydrographs.RainGaugeID;               //frmmain.FRainGaugeID;
  FScenarioID := frmExportRDIIHydrographs.ScenarioID;                 //frmmain.FScenarioID;
  FStart := frmExportRDIIHydrographs.StartDate;                       //frmmain.FStart;
  FEnd := frmExportRDIIHydrographs.EndDate;                           //frmmain.FEnd;
  FFlowUnitLabel := frmExportRDIIHydrographs.FlowUnitLabel;           //frmmain.FFlowUnitLabel;
  boAssignedGauges := frmExportRDIIHydrographs.UseAssignedGauge;
}
end;

destructor swmm5INPrdiiExporterThrd.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited;
end;

procedure swmm5INPrdiiExporterThrd.Execute;
var
  bo0, bo1, bo2, bo3, bo4, bo5, bo6: boolean;
  LineCount: longint;
  Section: string;
  i: integer;

begin
//rm 2007-11-26 - Modifications made to overcome limitation
//  - if an RTK Pattern is used for more than one raingauge
//  - only the last one was registering with SWMM 5
// - Modified to out put a separate HYDROGRAPH for each
// - combination of RTK Pattern and Raingauge
  { Place thread code here }
//rm 2010-05-06 - moved code from CreateIt to here:
  FeedbackLn('Processing ' + FSrcSWMM5InpFileName);
  synchronize(GetInputs);
//rm-

  bo0 := false;
  bo1 := false;
  bo2 := false;
  bo3 := false;
  bo4 := false;
  bo5 := false;
  bo6 := false;
  boReadNext := true;
  Synchronize(OpenSWMM5InpFile);
  try
    // Read each line of input file
    Reset(FInTextFile);
    LineCount := 0;
    //Section := '';
    while not EOF(FInTextFile) do
    begin
      if boReadNext then begin
        Readln(FInTextFile, Line);
        Inc(LineCount);
        Line := TrimRight(Line);
      end else
        boReadNext := true;
      // Check if line begins a new input section
      if (Pos('[', Line) = 1) then
      begin

        if (Pos('[OPTI', Line) = 1) then begin
          bo0 := WriteOPTIONSSection(0);
          //Line := '*&*';
          {
          while not (EOF(FInTextFile) or (Pos('[', Line) = 1)) do
            Readln(FInTextFile, Line);
          }
          boReadNext := false;
        end else if (Pos('[RDII', Line) = 1) then begin
          bo1 := WriteRDIISection;
          Line := '*&*';
          while not (EOF(FInTextFile) or (Pos('[', Line) = 1)) do
            Readln(FInTextFile, Line);
          boReadNext := false;
        end else if (Pos('[HYDR', Line) = 1) then begin
          bo2 := WriteHydrographSection;
          Line := '*&*';
          while not (EOF(FInTextFile) or (Pos('[', Line) = 1)) do
            Readln(FInTextFile, Line);
          boReadNext := false;
        end else if (Pos('[RAIN', Line) = 1) then begin
          bo3 := WriteRaingagesSection;
          Line := '*&*';
          while not (EOF(FInTextFile) or (Pos('[', Line) = 1)) do
            Readln(FInTextFile, Line);
          boReadNext := false;
        end else if (Pos('[TIME', Line) = 1) then begin
          bo4 := WriteTimeseriesSection;
          Line := '*&*';
          while not (EOF(FInTextFile) or (Pos('[', Line) = 1)) do
            Readln(FInTextFile, Line);
          boReadNext := false;
//rm 2010-04-22 - NO LONGER DOING DWF
(*
        end else if (Pos('[DWF', Line) = 1) then begin
          bo5 := WriteDWFSection;
          //rm 2007-11-06 - if no DWF section to write from database,
          //write the DWF section from source file to dest file
          if bo5 then begin
            Line := '*&*';
            while not (EOF(FInTextFile) or (Pos('[', Line) = 1)) do
              Readln(FInTextFile, Line);
            boReadNext := false;
          end else begin
            frmFeedbackWithMemo.feedbackMemo.Lines.Add('No DWF in DB.');
            bo5 := true; //done with it - do not attempt to write this section later
          end;
        end else if (Pos('[PATT', Line) = 1) then begin
          bo6 := WritePatternsSection;
          //rm 2007-11-06 - if no PATTERNS section to write from database,
          //write the PATTERNS section from source file to dest file
          if bo6 then begin
            Line := '*&*';
            while not (EOF(FInTextFile) or (Pos('[', Line) = 1)) do
              Readln(FInTextFile, Line);
            boReadNext := false;
          end else begin
            frmFeedbackWithMemo.feedbackMemo.Lines.Add('No PATTERNS in DB.');
            bo6 := true; //done with it - do not attempt to write this section later
          end;
*)
        end else
          writeln(FOutTextFile, Line);
      end else begin
        writeln(FOutTextFile, Line);
      end;
    end;
    if not bo0 then bo0 := WriteOPTIONSSection(1);
    if not bo1 then bo1 := WriteRDIISection;
    if not bo2 then bo2 := WriteHydrographSection;
    if not bo3 then bo3 := WriteRaingagesSection;
    if not bo4 then bo4 := WriteTimeseriesSection;
//rm 2010-04-22 - NO LONGER DOING DWF
(*
    if not bo5 then bo5 := WriteDWFSection;
    if not bo6 then bo6 := WritePatternsSection;
*)
  finally
    FeedbackLn('');
    FeedbackLn('Processing Complete.');
    FeedbackLn('');
    FeedbackLn('This window may be closed.');
    FeedbackLn('');
    synchronize(CloseSWMM5Inpfile);
  end;
end;

procedure swmm5INPrdiiExporterThrd.OpenSWMM5InpFile;
begin
  if FileExists(FSrcSWMM5InpFileName) then begin
    AssignFile(FInTextFile, FSrcSWMM5InpFileName);
    Reset(FInTextFile);
    AssignFile(FOutTextFile, FDstSWMM5InpFileName);
    Rewrite(FOutTextFile);
    FeedbackLn('Opened output ' + FDstSWMM5InpFileName);
  end else
    FeedbackLn('File not found.');
end;

function swmm5INPrdiiExporterThrd.WriteHydrographSection: boolean;
var boResult: boolean;
    queryStr, queryStr1, queryStr2: string;
    recordsAffected: OleVariant;
    recSet: _RecordSet;
begin
  FeedbackLn('[HYDROGRAPHS]');
  boResult := false;
  WriteLn(FOutTextFile, '[HYDROGRAPHS]');
  WriteLn(FOutTextFile, ';;                 Rain Gage/');
  WriteLn(FOutTextFile, ';;Name             Month            R1       T1       K1       R2       T2       K2       R3       T3       K3      ');
  WriteLn(FOutTextFile, ';;------------------------------------------------------------------------------------------------------------------');

  recSet := CoRecordSet.Create;
  if boAssignedGauges then begin
    queryStr1 := 'Select distinct b.RTKPatternName + ''_'' + a.RainGaugeName, ' +
              ' a.RainGaugeName from ' +
              ' RainGauges as a ' +
              ' inner join (RTKPatterns as b ' +
              ' inner join (RDIIAreas as c ' +
              ' inner join RTKLinks as d ' +
              ' on d.RDIIAreaID = c.RDIIAreaID) ' +
              ' on d.RTKPAtternID = b.RTKPAtternID) ' +
              ' on a.RainGaugeID = c.RainGaugeID ' +
              ' Where d.ScenarioID = ' + inttostr(FScenarioID);
    queryStr2 := 'Select distinct b.RTKPatternName + ''_'' + a.RainGaugeName, ' +
              ' a.RainGaugeName from ' +
              ' RainGauges as a ' +
              ' inner join (RTKPatterns as b ' +
              ' inner join (SewerSheds as c ' +
              ' inner join RTKLinks as d ' +
              ' on d.SewerShedID = c.SewerShedID) ' +
              ' on d.RTKPAtternID = b.RTKPAtternID) ' +
              ' on a.RainGaugeID = c.RainGaugeID ' +
              ' Where d.ScenarioID = ' + inttostr(FScenarioID) + ' AND d.RDIIAreaID < 1';
    queryStr := queryStr1 + ' UNION ALL ' + queryStr2;
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  end else begin
    queryStr := 'SELECT distinct d.RTKPatternName, ''' + FRainGaugeName + ''' from ' +
              ' RTKLinks as a inner join RTKPatterns as d ' +
              ' on a.RTKPatternID = d.RTKPatternID ' +
              ' where a.ScenarioID = ' + inttostr(FScenarioID);
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  end;
  if not recSet.EOF then begin
    recSet.MoveFirst;
    FeedbackLn(
      recSet.GetString(adClipString, recSet.RecordCount,#9,#13#10,'<null>'));
    recSet.MoveFirst;
    writeln(FOutTextFile,recSet.GetString(adClipString,
      recSet.RecordCount,#9,#13#10,'<null>'));
    recSet.Close;
    if boAssignedGauges then begin
      queryStr1 := 'Select distinct b.RTKPatternName + ''_'' + a.RainGaugeName, ' +
                ' ''ALL'', ' +
                ' b.R1, b.T1, b.K1, b.R2, b.T2, b.K2, b.R3, b.T3, b.K3, ' +
                ' b.AM, b.AR, b.AI ' +
                ' from RainGauges as a ' +
                ' inner join (RTKPatterns as b ' +
                ' inner join (RDIIAreas as c ' +
                ' inner join RTKLinks as d ' +
                ' on d.RDIIAreaID = c.RDIIAreaID) ' +
                ' on d.RTKPAtternID = b.RTKPAtternID) ' +
                ' on a.RainGaugeID = c.RainGaugeID ' +
                ' Where d.ScenarioID = ' + inttostr(FScenarioID);
      queryStr2 := 'Select distinct b.RTKPatternName + ''_'' + a.RainGaugeName, ' +
                ' ''ALL'', ' +
                ' b.R1, b.T1, b.K1, b.R2, b.T2, b.K2, b.R3, b.T3, b.K3, ' +
                ' b.AM, b.AR, b.AI ' +
                ' from RainGauges as a ' +
                ' inner join (RTKPatterns as b ' +
                ' inner join (SewerSheds as c ' +
                ' inner join RTKLinks as d ' +
                ' on d.SewerShedID = c.SewerShedID) ' +
                ' on d.RTKPAtternID = b.RTKPAtternID) ' +
                ' on a.RainGaugeID = c.RainGaugeID ' +
                ' Where d.ScenarioID = ' + inttostr(FScenarioID) + ' AND d.RDIIAreaID < 1';
      queryStr := queryStr1 + ' UNION ALL ' + queryStr2;
    end else begin
      queryStr := 'SELECT distinct d.RTKPatternName, ''ALL'', ' +
                ' d.R1, d.T1, d.K1, d.R2, d.T2, d.K2, d.R3, d.T3, d.K3, ' +
                ' d.AM, d.AR, d.AI ' +
                ' from RTKLinks as l inner join RTKPatterns as d ' +
                ' on l.RTKPatternID = d.RTKPatternID ' +
                ' where l.ScenarioID = ' + inttostr(FScenarioID);
    end;
    recSet := CoRecordSet.Create;
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then begin
      recSet.MoveFirst;
      FeedbackLn(recSet.GetString(adClipString,
        recSet.RecordCount,#9,#13#10,'<null>'));
      recSet.MoveFirst;
      writeln(FOutTextFile,recSet.GetString(adClipString,
        recSet.RecordCount,#9,#13#10,'<null>'));
      boResult := true;
    end else begin
      boResult := false;
    end;
    recSet.Close;
  end else begin
    boResult := false;
  end;
  //recSet.Close;
  Result := boResult;
end;

function swmm5INPrdiiExporterThrd.WriteOPTIONSSection(iMode: integer): boolean;
var boResult: boolean;
begin
  FeedbackLn('[OPTIONS]');
  boResult := false;
  if iMode = 1 then begin
    WriteLn(FOutTextFile, '[OPTIONS]');
    WriteLn(FOutTextFile, 'FLOW_UNITS           ' + FFlowUnitLabel);
    WriteLn(FOutTextFile, 'START_DATE           ' + formatDateTime('mm/dd/yyyy',FStart));
    WriteLn(FOutTextFile, 'START_TIME           ' + formatDateTime('hh:MM:ss',FStart));
    WriteLn(FOutTextFile, 'REPORT_START_DATE    ' + formatDateTime('mm/dd/yyyy',FStart));
    WriteLn(FOutTextFile, 'REPORT_START_TIME    ' + formatDateTime('hh:MM:ss',FStart));
    WriteLn(FOutTextFile, 'END_DATE             ' + formatDateTime('mm/dd/yyyy',FEnd));
    WriteLn(FOutTextFile, 'END_TIME             ' + formatDateTime('hh:MM:ss',FEnd));
    boResult := true;
  end else begin
    WriteLn(FOutTextFile, '[OPTIONS]');
    Line := '*&*';
    While (Pos('[',Trim(Line)) <> 1) do begin
      ReadLn(FInTextFile, Line);
      Line := Trim(Line);
      if (Pos('FLOW_UNITS', Line) = 1) then
        WriteLn(FOutTextFile, 'FLOW_UNITS           ' + FFlowUnitLabel)
      else if (Pos('START_DATE', Line) = 1) then
        WriteLn(FOutTextFile, 'START_DATE           ' + formatDateTime('mm/dd/yyyy',FStart))
      else if (Pos('START_TIME', Line) = 1) then
        WriteLn(FOutTextFile, 'START_TIME           ' + formatDateTime('hh:MM:ss',FStart))
      else if (Pos('REPORT_START_DATE', Line) = 1) then
        WriteLn(FOutTextFile, 'REPORT_START_DATE    ' + formatDateTime('mm/dd/yyyy',FStart))
      else if (Pos('REPORT_START_TIME', Line) = 1) then
        WriteLn(FOutTextFile, 'REPORT_START_TIME    ' + formatDateTime('hh:MM:ss',FStart))
      else if (Pos('END_DATE', Line) = 1) then
        WriteLn(FOutTextFile, 'END_DATE             ' + formatDateTime('mm/dd/yyyy',FEnd))
      else if (Pos('END_TIME', Line) = 1) then
        WriteLn(FOutTextFile, 'END_TIME             ' + formatDateTime('hh:MM:ss',FEnd))
      else
        WriteLn(FOutTextFile, Line);
      //ReadLn(FInTextFile, Line);
      //Line := Trim(Line);
    end;
    boReadNext := false;
    boResult := true;
  end;
  FeedbackLn('FLOW_UNITS           ' + FFlowUnitLabel);
  FeedbackLn('START_DATE           ' + formatDateTime('mm/dd/yyyy',FStart));
  FeedbackLn('START_TIME           ' + formatDateTime('hh:MM:ss',FStart));
  FeedbackLn('REPORT_START_DATE    ' + formatDateTime('mm/dd/yyyy',FStart));
  FeedbackLn('REPORT_START_TIME    ' + formatDateTime('hh:MM:ss',FStart));
  FeedbackLn('END_DATE             ' + formatDateTime('mm/dd/yyyy',FEnd));
  FeedbackLn('END_TIME             ' + formatDateTime('hh:MM:ss',FEnd));
  Result := boResult;
end;

function swmm5INPrdiiExporterThrd.WriteRaingagesSection: boolean;
var boResult: boolean;
    queryStr, queryStr1, queryStr2 : string;
    recordsAffected: OleVariant;
    recSet: _RecordSet;
begin
  FeedbackLn('[RAINGAGES]');
  boResult := false;
  WriteLn(FOutTextFile, '[RAINGAGES]');
  WriteLn(FOutTextFile, ';;                 Rain      Recd.  Snow   Data       Source           Station    Rain ');
  WriteLn(FOutTextFile, ';;Name             Type      Freq.  Catch  Source     Name             ID         Units');
  WriteLn(FOutTextFile, ';;-------------------------------------------------------------------------------------');
  if boAssignedGauges then begin
    queryStr1 :=
          ' SELECT RainGaugeName, ''VOLUME'', ''0:'' + CStr(TimeStep), ''0'', ' +
          ' ''TIMESERIES'', RainGaugeName from RainGauges ' +
          ' where RainGaugeID in ' +
          ' (Select a.RainGaugeID from RDIIAreas as a ' +
          ' inner join RTKLinks as b on a.RDIIAreaID = b.RDIIAreaID ' +
          ' where b.ScenarioID = ' + inttostr(FScenarioID) + ')';
    queryStr2 :=
          ' SELECT RainGaugeName, ''VOLUME'', ''0:'' + CStr(TimeStep), ''0'', ' +
          ' ''TIMESERIES'', RainGaugeName from RainGauges ' +
          ' where RainGaugeID in ' +
          ' (Select a.RainGaugeID from SewerSheds as a ' +
          ' inner join RTKLinks as b on a.SewerShedID = b.SewerShedID ' +
          ' where b.ScenarioID = ' + inttostr(FScenarioID) + ' AND b.RDIIAreaID < 1 ' + ')';
    queryStr := queryStr1 + ' UNION ALL ' + queryStr2;
    recSet := CoRecordSet.Create;
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if recSet.EOF then begin
      boResult := false;
    end else begin
      recSet.MoveFirst;
      FeedbackLn(
      recSet.GetString(adClipString,
      recSet.RecordCount,#9,#13#10,'<null>'));
      recSet.MoveFirst;
      writeln(FOutTextFile,recSet.GetString(adClipString,
      recSet.RecordCount,#9,#13#10,'<null>'));
      boResult := true;
      recSet.MoveFirst;
      FRainGaugeNames := '';
      FRainGaugeNames := '"' + vartostr(recSet.Fields.Item[0].Value) + '"';
      while not recSet.EOF do begin
        recSet.MoveNext;
        if not recSet.EOF then begin
          FRainGaugeNames := FRainGaugeNames + ',"' +
            vartostr(recSet.Fields.Item[0].Value) + '"';
        end;
      end;
    end;
    recSet.Close;
    boResult := true;
  end else begin
    queryStr :=
          'SELECT RainGaugeName, ''VOLUME'', "00:" + CStr(TimeStep), ''0'', ' +
          ' ''TIMESERIES'', RainGaugeName from RainGauges ' +
          ' where RainGaugeName = ''' + FRainGaugeName + '''';
    recSet := CoRecordSet.Create;
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then begin
      recSet.MoveFirst;
      FeedbackLn(
      recSet.GetString(adClipString,
      recSet.RecordCount,#9,#13#10,'<null>'));
      recSet.MoveFirst;
      writeln(FOutTextFile,recSet.GetString(adClipString,
      recSet.RecordCount,#9,#13#10,'<null>'));
      boResult := true;
    end else begin
      boResult := false;
    end;
    recSet.Close;
  end;
  Result := boResult;

end;

function swmm5INPrdiiExporterThrd.WriteRDIISection: boolean;
var boResult: boolean;
    queryStr, queryStr1, queryStr2 : string;
    recordsAffected: OleVariant;
    recSet: _RecordSet;
begin
  FeedbackLn('[RDII]');
  boResult := false;
  WriteLn(FOutTextFile, '[RDII]');
  WriteLn(FOutTextFile, ';;Node             Unit Hydrograph  Sewer Area');
  WriteLn(FOutTextFile, ';;--------------------------------------------');
  //Query for RDIIAreas in this Scenario
  if boAssignedGauges then begin
    queryStr1 :=
      'SELECT b.JunctionID, c.RTKPatternName + ''_'' + d.RainGaugeName, b.Area from ' +
      ' ((RTKLinks as a inner join RDIIAreas as b ' +
      ' on a.RDIIAreaID = b.RDIIAreaID) ' +
      ' inner join RTKPatterns as c ' +
      ' on a.RTKPatternID = c.RTKPatternID) ' +
      ' inner join RainGauges as d on b.RaingaugeID = d.RainGaugeID ' +
      ' where a.ScenarioID = ' +
      inttostr(FScenarioID);
    //Query for SewerSheds in this Scenario
    queryStr2 :=
      'SELECT b.JunctionID, c.RTKPatternName + ''_'' + d.RainGaugeName, b.Area from ' +
      ' ((RTKLinks as a inner join SewerSheds as b ' +
      ' on a.SewerShedID = b.SewerShedID) ' +
      ' inner join RTKPatterns as c ' +
      ' on a.RTKPatternID = c.RTKPatternID) ' +
      ' inner join RainGauges as d on b.RaingaugeID = d.RainGaugeID ' +
      ' where a.ScenarioID = ' +
      inttostr(FScenarioID) + ' AND a.RDIIAreaID < 1';
  end else begin
    queryStr1 :=
      'SELECT b.JunctionID, c.RTKPatternName, b.Area from ' +
      ' (RTKLinks as a inner join RDIIAreas as b ' +
      ' on a.RDIIAreaID = b.RDIIAreaID) ' +
      ' inner join RTKPatterns as c ' +
      ' on a.RTKPatternID = c.RTKPatternID ' +
      ' where a.ScenarioID = ' +
      inttostr(FScenarioID);
    //Query for SewerSheds in this Scenario
    queryStr2 :=
      'SELECT b.JunctionID, c.RTKPatternName, b.Area from ' +
      ' (RTKLinks as a inner join SewerSheds as b ' +
      ' on a.SewerShedID = b.SewerShedID) ' +
      ' inner join RTKPatterns as c ' +
      ' on a.RTKPatternID = c.RTKPatternID ' +
      ' where a.ScenarioID = ' +
      inttostr(FScenarioID) + ' AND a.RDIIAreaID < 1';
  end;

  queryStr := queryStr1 + ' UNION ALL ' + queryStr2;
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    FeedbackLn(
      recSet.GetString(adClipString,
      recSet.RecordCount,#9,#13#10,'<null>'));
    recSet.MoveFirst;
    writeln(FOutTextFile,recSet.GetString(adClipString,
      recSet.RecordCount,#9,#13#10,'<null>'));
    recSet.Close;
    boResult := true;
  end else begin //no RDIIAreas or Sewersheds
    recSet.Close;
    boResult := false;
  end;
  Result := boResult;
end;

function swmm5INPrdiiExporterThrd.WriteTimeseriesSection: boolean;
var boResult: boolean;
    sqlStr: string;
    recordsAffected: OleVariant;
    recSet: _RecordSet;
{
SELECT b.RainGaugeName, Format(c.DateTime,"m/d/yyyy hh:MM:ss"), c.Volume from
             RainGauges as b inner join
             Rainfall as c on b.RainGaugeID = c.RainGaugeID
             where b.RaingaugeName = "New_Raingauge"
and c.DateTime >= CDate("01/30/2005 12:40") and c.DateTime <= CDate("01/31/2005 12:55")
             order by b.RainGaugeName, c.DateTime;
}
begin
  FeedbackLn('[TIMESERIES]');
  boResult := false;
  WriteLn(FOutTextFile, '[TIMESERIES]');
  WriteLn(FOutTextFile, ';;Name             Date       Time       Value');
  WriteLn(FOutTextFile, ';;--------------------------------------------');
  sqlStr := ' SELECT b.RainGaugeName, Format(c.DateTime,"m/d/yyyy hh:MM:ss"), c.Volume from ' +
            ' RainGauges as b inner join ' +
            ' Rainfall as c on b.RainGaugeID = c.RainGaugeID ' +
            ' where b.RaingaugeName in (' + FRainGaugeNames + ') ' +
            ' and c.DateTime >= ' + FloattoStr(FStart) +
            ' and c.DateTime <= ' + FloattoStr(FEnd) +
            ' order by b.RainGaugeName, c.DateTime;';
  recSet := CoRecordSet.Create;
  recSet.Open(sqlStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    FeedbackLn(
    recSet.GetString(adClipString,
    recSet.RecordCount,#9,#13#10,'<null>'));
    recSet.MoveFirst;
    writeln(FOutTextFile,recSet.GetString(adClipString,
    recSet.RecordCount,#9,#13#10,'<null>'));
    boResult := true;
  end else begin
    boResult := false;
  end;
  recSet.Close;
  Result := boResult;
end;

//rm 2010-04-22 - NO LONGER DOING DWF
(*
function swmm5INPrdiiExporterThrd.WriteDWFSection: boolean;
var boResult: boolean;
    queryStr, queryStr1, queryStr2 : string;
    recordsAffected: OleVariant;
    recSet: _RecordSet;
begin
//write out the [DWF] section
//[DWF]
//;;                                  Average    Time
//;;Node             Parameter        Value      Patterns
//;;-----------------------------------------------------
//  KRO3001          FLOW             1          "" "" "DWF" "" "" "" ""
//Here the average value is the fraction that the RDII Area takes up of the Sewershed
//The Time Pattern is "" "" "MeterName" "" "" "" ""
  frmFeedbackWithMemo.feedbackMemo.Lines.Add('[DWF]');
  boResult := false;
  WriteLn(FOutTextFile, '[DWF]');
  WriteLn(FOutTextFile, ';;                                  Average    Time');
  WriteLn(FOutTextFile, ';;Node             Parameter        Value      Patterns');
  WriteLn(FOutTextFile, ';;-----------------------------------------------------');
  queryStr1 :=
  //rm 2007-11-21 - should the area ratio be based on rdii area / sewershed area
  //or rdii area / meter area ????
  // - the DWF was calculated based on the meter area
  //  'SELECT b.JunctionID, ''FLOW'', b.Area / c.Area as Area,' +
    'SELECT b.JunctionID, ''FLOW'', b.Area / d.Area as Area,' +
    ' '' "" "" "'' + d.MeterName + ''_HR" "'' + d.MeterName + ''_WE" '' from ' +
    ' ((RTKLinks as a inner join RDIIAreas as b ' +
    ' on a.RDIIAreaID = b.RDIIAreaID) ' +
    ' inner join Sewersheds as c ' +
    ' on b.SewershedID = c.SewershedID) ' +
    ' inner join Meters as d on c.MeterID = d.MeterID ' +
    ' where a.ScenarioID = ' +
    inttostr(FScenarioID);
  queryStr2 :=
  //rm 2007-11-21 - we were setting area ratio to 1 assuming sewershed area = meter area
  //but that may not be the case
  //  'SELECT b.JunctionID, ''FLOW'', 1 as Area,' +
    'SELECT b.JunctionID, ''FLOW'', b.Area / d.Area as Area,' +
    ' '' "" "" "'' + d.MeterName + ''_HR" "'' + d.MeterName + ''_WE" '' from ' +
    ' (RTKLinks as a inner join SewerSheds as b ' +
    ' on a.SewerShedID = b.SewerShedID) ' +
    ' inner join Meters as d on b.MeterID = d.MeterID ' +
    ' where a.ScenarioID = ' +
    inttostr(FScenarioID) + ' AND a.RDIIAreaID < 1';
  queryStr := queryStr1 + ' UNION ALL ' + queryStr2;
  //frmFeedbackWithMemo.feedbackMemo.Lines.Add(queryStr);
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //Now have Loadpoint, RDIIArea area / Sewershed area, Metername
  if not recSet.EOF then begin
    recSet.MoveFirst;
    frmFeedbackWithMemo.feedbackMemo.Lines.Add(
      recSet.GetString(adClipString, recSet.RecordCount,#9,#13#10,'<null>'));
    recSet.MoveFirst;
    writeln(FOutTextFile,
      recSet.GetString(adClipString, recSet.RecordCount,#9,#13#10,'<null>'));
    boResult := true;
  end;
  Result := boResult;
end;

function swmm5INPrdiiExporterThrd.WritePatternsSection: boolean;
var boResult: boolean;
    queryStr, queryStr1, queryStr2 : string;
    recordsAffected: OleVariant;
    recSet: _RecordSet;
    i, iMeterID: integer;
    sMeterName: string;
    DWFStrings: TStringList;
begin
//write out the patterns for each DWF
//[PATTERNS]
//;;Name             Type       Multipliers
//;;----------------------------------------------------------------------
//  DWF              HOURLY     .0151 .01373 .01812 .01098 .01098 .01922
//  DWF                         .02773 .03789 .03515 .03982 .02059 .02471
//  DWF                         .03021 .03789 .03350 .03158 .03954 .02114
//  DWF                         .02801 .03680 .02911 .02334 .02499 .02718

//Pattern Name will be Metername for the sewershed
//Type will always be "HOURLY" for weekdays, and "WEEKEND" for weekends
//Multipliers will be from the WeekdayDWF table for weekdays, WeekendAndHolidayDWF
//table for weekends and holidays
//
//rm 2007-11-19 - Must convert from flow units of the Meter
//  to flow units of the Scenario!!
//
  frmFeedbackWithMemo.feedbackMemo.Lines.Add('[PATTERNS]');
  boResult := false;
  WriteLn(FOutTextFile, '[PATTERNS]');
  WriteLn(FOutTextFile, ';;Name             Type       Multipliers');
  WriteLn(FOutTextFile, ';;0---------------------------------------------------------------------');
  queryStr1 :=
        'Select distinct a.MeterID from RDIIAreas as a inner join RTKLinks as b ' +
        ' on a.RDIIAreaID = b.RDIIAreaID ' +
        ' where b.ScenarioID = ' + inttostr(FScenarioID);
  queryStr2 :=
        'Select distinct a.MeterID from SewerSheds as a inner join RTKLinks as b ' +
        ' on a.SewerShedID = b.SewerShedID ' +
        ' where b.ScenarioID = ' + inttostr(FScenarioID) + ' and b.RDIIAreaID < 1';
  queryStr := queryStr1 + ' UNION ALL ' + queryStr2;
//  frmFeedbackWithMemo.feedbackMemo.Lines.Add(queryStr);
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    frmFeedbackWithMemo.feedbackMemo.Lines.Add(
      recSet.GetString(adClipString, recSet.RecordCount,#9,#13#10,'<null>'));
    recSet.MoveFirst;
    while not recSet.EOF do begin
      //
      if not varisnull(recSet.Fields.Item[0].Value) then begin
        iMeterID := recSet.Fields.Item[0].Value;
        if iMeterID > -1 then begin
          sMeterName := DatabaseModule.GetFlowMeterNameForID(iMeterID);
          DWFStrings := DatabaseModule.GetDWFStrings4MeterID(iMeterID, false, FFlowUnitLabel);
          for i := 0 to DWFStrings.Count - 1 do
            frmFeedbackWithMemo.feedbackMemo.Lines.Add('HOURLY  ' + DWFStrings[i]);
          if DWFStrings.Count > 3 then begin
            Writeln(FOutTextFile, '  ', sMeterName + '_HR', #9, 'HOURLY', #9, DWFStrings[0]);
            Writeln(FOutTextFile, '  ', sMeterName + '_HR', #9, #9, DWFStrings[1]);
            Writeln(FOutTextFile, '  ', sMeterName + '_HR', #9, #9, DWFStrings[2]);
            Writeln(FOutTextFile, '  ', sMeterName + '_HR', #9, #9, DWFStrings[3]);
          end;
          //Now do the same for Weekends and holidays
          DWFStrings := DatabaseModule.GetDWFStrings4MeterID(iMeterID, true, FFlowUnitLabel);
          for i := 0 to DWFStrings.Count - 1 do
            frmFeedbackWithMemo.feedbackMemo.Lines.Add('WEEKEND  ' + DWFStrings[i]);
          if DWFStrings.Count > 3 then begin
            Writeln(FOutTextFile, '  ', sMeterName + '_WE', #9, 'WEEKEND', #9, DWFStrings[0]);
            Writeln(FOutTextFile, '  ', sMeterName + '_WE', #9, #9, DWFStrings[1]);
            Writeln(FOutTextFile, '  ', sMeterName + '_WE', #9, #9, DWFStrings[2]);
            Writeln(FOutTextFile, '  ', sMeterName + '_WE', #9, #9, DWFStrings[3]);
          end;
          boResult := true;
        end else begin
        end;
      end;
      recSet.MoveNext;
    end;
    FreeAndNil(DWFStrings);
  end else begin
    boResult := false;
  end;
  recSet.Close;
  Result := boResult;
end;
*)
end.
