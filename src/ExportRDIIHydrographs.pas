unit ExportRDIIHydrographs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, RDIIGraphFrame, StrUtils,
  moddatabase, Hydrograph, StormEvent;

type
  TfrmExportRDIIHydrographs = class(TForm)
    rgExportOptions: TRadioGroup;
    rgRainGauge: TRadioGroup;
    GroupBox1: TGroupBox;
    Label13: TLabel;
    Label19: TLabel;
    EndDatePicker: TDateTimePicker;
    StartDatePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    GroupBox2: TGroupBox;
    edOutFileName: TEdit;
    btnOutFileName: TButton;
    lblOutFileName: TLabel;
    lblInSWMM5: TLabel;
    edInSWMM5: TEdit;
    btnInSWMM5: TButton;
    lblOutSWMM5: TLabel;
    edOutSWMM5: TEdit;
    btnOutSWMM5: TButton;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    lblScenarioName: TLabel;
    OpenDialogSWMM5InpFile: TOpenDialog;
    SaveDialog1: TSaveDialog;
    FrameRDIIGraph1: TFrameRDIIGraph;
    btnSWMM5_in: TButton;
    btnSWMM5_out: TButton;
    procedure cancelButtonClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure btnOutFileNameClick(Sender: TObject);
    procedure btnInSWMM5Click(Sender: TObject);
    procedure btnOutSWMM5Click(Sender: TObject);
    procedure rgExportOptionsClick(Sender: TObject);
    procedure StartDatePickerChange(Sender: TObject);
    procedure EndDatePickerChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSWMM5_inClick(Sender: TObject);
    procedure edInSWMM5Change(Sender: TObject);
    procedure edOutSWMM5Change(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private
    { Private declarations }
    FScenarioID: integer;
    FScenarioName: string;
    FStartDateTime: TDateTime;
    FEndDateTime: TDateTime;

    FExportedStartDateTime: TDateTime;
    FExportedEndDateTime: TDateTime;
    FExportedTimeStepinDays: double; //TDateTime;
    FExportedNumTimeSteps: Integer;

    FFlowUnitLabel: string;
    FRainGaugeID: integer;
    FRainGaugeName: string;

    FRDIIOutFileName: string;
//rm 2010-04-22 - NO LONGER DOING DWF
//rm    FDWFOutFileName: string;

    holidays: daysArray;

    function isHoliday(date: TDateTime): boolean;
    function dayOfWeekIndex(date: TDateTime): integer;
    procedure GetThemHolidays();

    procedure SetScenarioID(const Value: integer);
    procedure SetEndDate(const Value: TDateTime);
    procedure SetStartDate(const Value: TDateTime);
    procedure SetRainGaugeID(const Value: integer);
    function GetSWMM5InpFileIn: string;
    function GetSWMM5InpFileOut: string;
    function GetEndDateTime: TDateTime;
    function GetStartDateTime: TDateTime;
    function GetUseAssignedGauge: boolean;
//rm 2010-04-22 - NO LONGER DOING DWF
//rm    function GetDWFOutFileName(sOutFileName: string):string;
    procedure ExportRDII2SWM5InterfaceFile;
//rm 2010-04-22 - NO LONGER DOING DWF
//rm    function ExportDWF2SWM5InterfaceFile: boolean;
    procedure InsertSWMM5InterFaceFile;
//rm 2010-04-22 - NO LONGER DOING DWF
//rm    procedure InsertSWMM5InterFaceFile_and_ClearDWFSection(boWroteDWFFile: boolean);
    procedure InsertSWMM5StartEndDates;
    procedure Export2CSVFile;
//rm 2010-04-22 - NO LONGER DOING DWF
//rm    procedure ExportDWF2CSVFile;
    procedure UpdateScenarioSWMM5InputFileName;
    procedure SetUseAssignedGauge(const Value: boolean);
  public
    { Public declarations }
    property ScenarioID: integer read FScenarioID write SetScenarioID;
    property RainGaugeID: integer read FRainGaugeID write SetRainGaugeID;
    property StartDate: TDateTime read GetStartDateTime write SetStartDate;
    property EndDate: TDateTime read GetEndDateTime write SetEndDate;
    property SWMM5InpFileIn: string read GetSWMM5InpFileIn;
    property SWMM5InpFileOut: string read GetSWMM5InpFileOut;
    property RainGaugeName: string read FRainGaugeName;
    property FlowUnitLabel: string read FFlowUnitLabel;
    property UseAssignedGauge: boolean read GetUseAssignedGauge write SetUseAssignedGauge;
  end;

var
  frmExportRDIIHydrographs: TfrmExportRDIIHydrographs;

implementation
uses feedbackWithMemo, swmm5INPrdiiExporterThread,
  mainform, math, ADODB_TLB;
{$R *.dfm}

{ TfrmExportRDIIHydrographs }

procedure TfrmExportRDIIHydrographs.btnInSWMM5Click(Sender: TObject);
begin
//browse for SWMM5 input file to modify
OpenDialogSWMM5InpFile.FileName := edInSWMM5.Text;
  OpenDialogSWMM5InpFile.Title :=
    'Please select the SWMM5 Input file to modify.';
  if OpenDialogSWMM5InpFile.Execute then begin
    edInSWMM5.Text := OpenDialogSWMM5InpFile.FileName;
    edInSWMM5.Hint := edInSWMM5.Text;
  end else begin

  end;

end;

procedure TfrmExportRDIIHydrographs.btnOutFileNameClick(Sender: TObject);
begin
//browse for output CSV filename
SaveDialog1.FileName := edOutFileName.Text;
  if rgExportOptions.ItemIndex = 0 then begin
    SaveDialog1.Filter := '*.TXT|*.TXT';
    SaveDialog1.DefaultExt := 'TXT';
    SaveDialog1.Title :=
      'Please enter the name of the SWMM5 Interface file to create.';
  end else begin
    SaveDialog1.Filter := '*.CSV|*.CSV';
    SaveDialog1.DefaultExt := 'CSV';
    SaveDialog1.Title :=
      'Please enter the name of the export file to create.';
  end;
  if SaveDialog1.Execute then begin
    edOutFileName.Text := SaveDialog1.FileName;
    edOutFileName.Hint := edOutFileName.Text;
  end;
end;

procedure TfrmExportRDIIHydrographs.btnOutSWMM5Click(Sender: TObject);
begin
//browse for SWMM5 input filename to write to
  Savedialog1.FileName := edInSWMM5.Text;
  SaveDialog1.Filter := '*.INP|*.INP';
  SaveDialog1.DefaultExt := 'INP';
  if (length(edOutSWMM5.Text) > 0) then
    Savedialog1.FileName := edOutSWMM5.Text;
  SaveDialog1.Title :=
    'Please enter the name of the SWMM5 Input file to create.';
  if SaveDialog1.Execute then begin
    edOutSWMM5.Text := SaveDialog1.FileName;
    edOutSWMM5.Hint := edOutSWMM5.Text;
  end;
  btnSWMM5_out.Enabled := Fileexists(edOutSWMM5.Text);
end;

procedure TfrmExportRDIIHydrographs.btnSWMM5_inClick(Sender: TObject);
begin
  if (Sender = btnSWMM5_in) then begin
    frmMain.RunSWMM5Interface(edInSWMM5.Text);
  end else begin
    frmMain.RunSWMM5Interface(edOutSWMM5.Text);
  end;
end;

procedure TfrmExportRDIIHydrographs.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

function TfrmExportRDIIHydrographs.dayOfWeekIndex(date: TDateTime): integer;
(* returns day of week 0 = sun, 1 = mon, 2 = tues..... 6 = saturday *)
(* holidays are returned as 7 *)
var
  dow: integer;
begin
  dow := dayofweek(date) - 1;
  if (isholiday(date)) then dow := 7;
  dayOfWeekIndex := dow;
end;

procedure TfrmExportRDIIHydrographs.edInSWMM5Change(Sender: TObject);
begin
  btnSWMM5_in.Enabled := (length(edInSWMM5.text) > 0);
end;

procedure TfrmExportRDIIHydrographs.edOutSWMM5Change(Sender: TObject);
begin
  btnSWMM5_out.Enabled := (length(edOutSWMM5.text) > 0);
end;

procedure TfrmExportRDIIHydrographs.EndDatePickerChange(Sender: TObject);
begin
//
  FEndDateTime := Floor(EndDatePicker.Date) + Frac(EndTimePicker.Time);
end;

procedure TfrmExportRDIIHydrographs.FormCreate(Sender: TObject);
begin
//
end;

procedure TfrmExportRDIIHydrographs.FormShow(Sender: TObject);
begin
  rgExportOptionsClick(Self);
end;

//rm 2010-04-22 - NO LONGER DOING DWF
(*
function TfrmExportRDIIHydrographs.GetDWFOutFileName(
  sOutFileName: string): string;
var
  sResult,fileext : string;
begin
  sResult := '';
  fileext := ExtractFileExt(sOutFileName);
  sResult := Copy(sOutFileName,1,Length(sOutFileName)-Length(fileext));
  sResult := sResult + '_DWF' + fileext;
  Result := sResult;
end;
*)
function TfrmExportRDIIHydrographs.GetEndDateTime: TDateTime;
begin
  Result := Floor(EndDatePicker.Date) + Frac(EndTimePicker.Time);
  //Result := EndDatePicker.Date + Frac(EndTimePicker.Time);
end;

function TfrmExportRDIIHydrographs.GetStartDateTime: TDateTime;
begin
  Result := Floor(StartDatePicker.Date) + Frac(StartTimePicker.Time);
  //Result := StartDatePicker.Date + Frac(StartTimePicker.Time);
end;

function TfrmExportRDIIHydrographs.GetSWMM5InpFileIn: string;
begin
  Result := edInSWMM5.Text;
end;

function TfrmExportRDIIHydrographs.GetSWMM5InpFileOut: string;
begin
  Result := edOutSWMM5.Text;
end;

procedure TfrmExportRDIIHydrographs.GetThemHolidays;
begin
  holidays := DatabaseModule.GetHolidays();
end;

function TfrmExportRDIIHydrographs.GetUseAssignedGauge: boolean;
begin
  Result := (rgRainGauge.ItemIndex = 1);
end;



procedure TfrmExportRDIIHydrographs.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmExportRDIIHydrographs.InsertSWMM5InterFaceFile;
var inFILESsection:boolean;
//rm 2010-04-22 - NO LONGER DOING DWF
    inFileName, inpline, sAction, sTypeRDII{, sTypeDWF}: string;
    OldFile,NewFile:TextFile;
    OldFilename,NewFileName{,IFaceFileName}:string;
    iLen: integer;
begin
//rm 2007-11-06 - slight re-tool here - we are going to put RDII flows in the file
//in the "USE RDII filename" clause, and the DWF flows in the file
//referenced by "USE INFLOWS filename"
  OldFilename := edInSWMM5.Text;
  NewFileName := edOutSWMM5.Text;
  FRDIIOutFileName := edOutFileName.Text;
//rm 2010-04-22 - NO LONGER DOING DWF
//rm  FDWFOutFileName := GetDWFOutFileName(FRDIIOutFileName);
  sAction := 'USE';
  sTypeRDII := 'RDII';
//rm 2010-04-22 - NO LONGER DOING DWF
//rm  sTypeDWF := 'INFLOWS';
  //see if the file exists
  {
  if not rdiiutils.fileCanBeRead(SWMM5InputFileName) then
  begin
    Result := false;
    exit;
  end;
  //see if the file is writeable
  if not rdiiutils.fileCanBeWritten(SWMM5InputFileName) then
  begin
    Result := false;
    exit;
  end;
  }
  //open the SWM5 Input file and look for the [FILES] position
  AssignFile(OldFile,OldFilename);
  {$I-}
  Reset(OldFile);
  {$I+}
  if IOResult <> 0 Then
  Begin
    //Result := false;
    MessageDlg('Error reading input file ' + OldFileName,mtError,[mbok],0);
    Exit;
  End;
  inFILESsection := false;
  while not (inFILESsection or EOF(OldFile)) do
  begin
    ReadLn(OldFile,inpline);
    if (Pos('[FILE', Trim(UpperCase(inpLine))) = 1) then
      inFILESsection :=true;
  end;
  //if no [FILES] in input file, just append ours and we are done
  if EOF(OldFile) then
  begin
    CloseFile(OldFile);
    CopyFile(pAnsiChar(OldFileName), pAnsiChar(NewFileName), false);
    AssignFile(NewFile,NewFileName);
    {$I-}
    Reset(NewFile);
    {$I+}
    if IOResult <> 0 Then
    Begin
      //Result := false;
      MessageDlg('Error creating new input file ' + NewFileName,mtError,[mbok],0);
      Exit;
    End;
    Append(NewFile);
    Writeln(NewFile,'[FILES]');
    Writeln(NewFile,' ',sAction,' ',sTypeRDII,' "',FRDIIOutFileName,'"');
//rm 2008-12-09
//rm 2010-04-22 - NO LONGER DOING DWF
//rm Writeln(NewFile,' ',sAction,' ',sTypeDWF,' "',FDWFOutFileName,'"');
    Writeln(NewFile);
    CloseFile(NewFile);
    //Result := true;
    //done with the easy case
    Exit;
  end else
  //if [FILES] section was found we have work to do:
  begin
    CloseFile(OldFile);
    //make a new textfile in the temp folder
    //NewFileName := GetEnvironmentVariable('TEMP') + '\' +
    //  ExtractFileName(OldFileName);
    AssignFile(NewFile,NewFileName);
    {$I-}
    Rewrite(NewFile);
    //start over with the existing SW5 input file
    Reset(OldFile);
    {$I+}
    if IOResult <> 0 Then
    Begin
      //Result := false;
      MessageDlg('Error creating new input file ' + NewFileName,mtError,[mbok],0);
      Exit;
    End;
    inFILESsection := false;
    //read in existing file and write new one
    //up until the [FILES] section
    while not (EOF(OldFile)) do
    begin
      ReadLn(OldFile,inpline);
      if (Pos('[FILE', Trim(UpperCase(inpLine))) = 1) then
      begin
        inFILESsection := true;
        writeln(NewFile,inpLine);
        //write out our new entry within the [FILES] section
        Writeln(NewFile,' ',sAction,' ',sTypeRDII,' "',FRDIIOutFileName,'"');
//rm 2008-12-09
//rm 2010-04-22 - NO LONGER DOING DWF
//rm Writeln(NewFile,' ',sAction,' ',sTypeDWF,' "',FDWFOutFileName,'"');
        // must remove any existing entry of the same Action (USE/SAVE)
        //  and Type (Rainfall, Runoff, Hotstart, RDII)
        ReadLn(OldFile,inpline);
        iLen := Length(sAction) + Length(sTypeRDII) + 1;
        While inFILESsection do begin
          if length(inpline) > 0 then begin
            if (copy(Trim(UpperCase(inpLine)),1,1) = '[') then begin
              inFILESsection := false;
              writeln(NewFile,inpLine);
            end else begin
              if (Length(inpLine) >= iLen) and
                ((copy(Trim(UpperCase(inpLine)),1,iLen) =
                (UpperCase(sAction) + ' ' + UpperCase(sTypeRDII)))
//rm 2010-04-22 - NO LONGER DOING DWF
{
                or
                (copy(Trim(UpperCase(inpLine)),1,iLen) =
                (UpperCase(sAction) + ' ' + UpperCase(sTypeDWF)))
}
                )
                 then begin
                //do not write this line out - it is replaced by our new one
                end else begin
                  writeln(NewFile,inpLine);
                end;
            end;
          end else begin
            writeln(NewFile,inpLine);
          end;
          if EOF(OldFile) then
            inFILESsection := false
          else
            ReadLn(OldFile,inpline);
        end;
      end else
        writeln(NewFile,inpLine);
    end;
    CloseFile(NewFile);
    CloseFile(OldFile);
    //overwrite the existing input file with our new file
    //CopyFile(pAnsiChar(NewFileName), pAnsiChar(OldFileName), false);
    //delete the new file we created
    //DeleteFile(pAnsiChar(NewFileName));
    //Result := true;
  end;

end;


//rm 2010-04-22 - NO LONGER DOING DWF
(*
procedure TfrmExportRDIIHydrographs.InsertSWMM5InterFaceFile_and_ClearDWFSection(boWroteDWFFile: boolean);
var inFILESsection,inDWFSection:boolean;
    hasFILESsection, hasDWFSection:boolean;
    inFileName, inpline, sAction, sTypeRDII, sTypeDWF, sTest1, sTest2: string;
    OldFile,NewFile:TextFile;
    OldFilename,NewFileName{,IFaceFileName}:string;
    iLen1, iLen2: integer;
begin
//rm 2007-11-06 - slight re-tool here - we are going to put RDII flows in the file
//in the "USE RDII filename" clause, and the DWF flows in the file
//referenced by "USE INFLOWS filename"
  OldFilename := edInSWMM5.Text;
  NewFileName := edOutSWMM5.Text;
  FRDIIOutFileName := edOutFileName.Text;
//rm 2010-04-22 - NO LONGER DOING DWF
//rm  FDWFOutFileName := GetDWFOutFileName(FRDIIOutFileName);
  sAction := 'USE';
  sTypeRDII := 'RDII';
  sTypeDWF := 'INFLOWS';
  //open the SWM5 Input file and look for the [FILES] position
  AssignFile(OldFile,OldFilename);
  {$I-}
  Reset(OldFile);
  {$I+}
  if IOResult <> 0 Then
  Begin
    //Result := false;
    MessageDlg('Error reading input file ' + OldFileName,mtError,[mbok],0);
    Exit;
  End;
  hasFILESsection := false;
  hasDWFSection := false;
  while not EOF(OldFile) do
  begin
    ReadLn(OldFile,inpline);
    if (Pos('[FILE', Trim(UpperCase(inpLine))) = 1) then
      hasFILESsection :=true
    else if (Pos('[DWF', Trim(UpperCase(inpLine))) = 1) then
      hasDWFSection := true;
  end;
  CloseFile(OldFile);
  //if no [FILES] or [DWF] in input file, just append ours and we are done
  //if [FILES] section was found we have work to do:
  if hasFILESsection then begin
    //make a new textfile in the temp folder
    //NewFileName := GetEnvironmentVariable('TEMP') + '\' +
    //  ExtractFileName(OldFileName);
    AssignFile(NewFile,NewFileName);
    {$I-}
    Rewrite(NewFile);
    //start over with the existing SW5 input file
    Reset(OldFile);
    {$I+}
    if IOResult <> 0 Then
    Begin
      //Result := false;
      MessageDlg('Error creating new input file ' + NewFileName,mtError,[mbok],0);
      Exit;
    End;
    inFILESsection := false;
    inDWFSection := false;
    //read in existing file and write new one
    //up until the [FILES] section
    while not (EOF(OldFile)) do
    begin
      ReadLn(OldFile,inpline);
      if (Pos('[FILE', Trim(UpperCase(inpLine))) = 1) then
      begin
        inFILESsection := true;
        writeln(NewFile,inpLine);
        //write out our new entry within the [FILES] section
        Writeln(NewFile,' ',sAction,' ',sTypeRDII,' "',FRDIIOutFileName,'"');
//rm 2008-12-09 a
if (boWroteDWFFile) then
Writeln(NewFile,' ',sAction,' ',sTypeDWF,' "',FDWFOutFileName,'"');
        // must remove any existing entry of the same Action (USE/SAVE)
        //  and Type (Rainfall, Runoff, Hotstart, RDII)
        ReadLn(OldFile,inpline);
        iLen1 := Length(sAction) + Length(sTypeRDII) + 1;
        iLen2 := Length(sAction) + Length(sTypeDWF) + 1;
        While inFILESsection do begin
          if length(inpline) > 0 then begin
            if (copy(Trim(UpperCase(inpLine)),1,1) = '[') then begin
              inFILESsection := false;
              writeln(NewFile,inpLine);
            end else begin
              if (Length(inpLine) >= 5) then begin
                sTest1 := copy(Trim(UpperCase(inpLine)),1,iLen1);
                sTest2 := copy(Trim(UpperCase(inpLine)),1,iLen2);
                if ((sTest1 = (UpperCase(sAction) + ' ' + UpperCase(sTypeRDII)))
                or (sTest2 = (UpperCase(sAction) + ' ' + UpperCase(sTypeDWF))))  then
                //do not write this line out - it is replaced by our new one
                else
                  writeln(NewFile,inpLine);
              end;
            end;
          end else begin
            writeln(NewFile,inpLine);
          end;
          if EOF(OldFile) then
            inFILESsection := false
          else
            ReadLn(OldFile,inpline);
        end;
      end else if (Pos('[DWF', Trim(UpperCase(inpLine))) = 1) then begin
        //we are going to leave out the existing DWF section body
        inDWFsection := true;
        writeln(NewFile,inpLine);
        ReadLn(OldFile,inpline);
        While inDWFsection do begin
          if length(inpline) > 0 then begin
            if (copy(Trim(UpperCase(inpLine)),1,1) = '[') then begin
              inDWFsection := false;
              writeln(NewFile,inpLine);
            end;
          end;
          if EOF(OldFile) then
            inDWFsection := false
          else
            ReadLn(OldFile,inpline);
        end;
      end else
        writeln(NewFile,inpLine);
    end;
    CloseFile(NewFile);
    CloseFile(OldFile);
  end else if hasDWFSection then begin //just a DWF Section to skip over
    //and then append files section
    AssignFile(NewFile,NewFileName);
    {$I-}
    Rewrite(NewFile);
    //start over with the existing SW5 input file
    Reset(OldFile);
    {$I+}
    if IOResult <> 0 Then
    Begin
      MessageDlg('Error creating new input file ' + NewFileName,mtError,[mbok],0);
      Exit;
    End;
    inDWFSection := false;
    //up until the [DWF] section
    while not (EOF(OldFile)) do
    begin
      ReadLn(OldFile,inpline);
      if (Pos('[DWF', Trim(UpperCase(inpLine))) = 1) then begin
        //we are going to leave out the existing DWF section body
        inDWFsection := true;
        writeln(NewFile,inpLine);
        ReadLn(OldFile,inpline);
        While inDWFsection do begin
          if length(inpline) > 0 then begin
            if (copy(Trim(UpperCase(inpLine)),1,1) = '[') then begin
              inDWFsection := false;
              writeln(NewFile,inpLine);
            end;
          end;
          if EOF(OldFile) then
            inDWFsection := false
          else
            ReadLn(OldFile,inpline);
        end;
      end else
        writeln(NewFile,inpLine);
    end;
    Writeln(NewFile,';;');
    Writeln(NewFile,';;');
    Writeln(NewFile,'[FILES]');
    Writeln(NewFile,' ',sAction,' ',sTypeRDII,' "',FRDIIOutFileName,'"');
//rm 2008-12-09
Writeln(NewFile,' ',sAction,' ',sTypeDWF,' "',FDWFOutFileName,'"');
    Writeln(NewFile,';;');
    CloseFile(NewFile);
    CloseFile(OldFile);
  end else begin //no [FILES] or [DWF] Section
    CopyFile(pAnsiChar(OldFileName), pAnsiChar(NewFileName), false);
    AssignFile(NewFile,NewFileName);
    {$I-}
    Reset(NewFile);
    {$I+}
    if IOResult <> 0 Then
    Begin
      //Result := false;
      MessageDlg('Error creating new input file ' + NewFileName,mtError,[mbok],0);
      Exit;
    End;
    Append(NewFile);
    Writeln(NewFile,'[FILES]');
    Writeln(NewFile,' ',sAction,' ',sTypeRDII,' "',FRDIIOutFileName,'"');
//rm 2008-12-09
Writeln(NewFile,' ',sAction,' ',sTypeDWF,' "',FDWFOutFileName,'"');
    Writeln(NewFile);
    CloseFile(NewFile);
  end;

end;
*)

procedure TfrmExportRDIIHydrographs.InsertSWMM5StartEndDates;
var
    OldFile,NewFile:TextFile;
    OldFileName,NewFileName,Line:string;
    iLen: integer;
    inOptionsSection: boolean;
begin
  OldFileName := edOutSWMM5.Text;
  //make a new textfile in the temp folder
  NewFileName := GetEnvironmentVariable('TEMP') + '\' +
    ExtractFileName(OldFileName);
  AssignFile(OldFile,OldFilename);
  {$I-}
  Reset(OldFile);
  {$I+}
  if IOResult <> 0 Then
  Begin
    //Result := false;
    MessageDlg('Error reading input file ' + OldFileName,mtError,[mbok],0);
    Exit;
  End;
  AssignFile(NewFile,NewFileName);
  {$I-}
  Rewrite(NewFile);
  {$I+}
  if IOResult <> 0 Then
  Begin
    MessageDlg('Error creating new input file ' + NewFileName,mtError,[mbok],0);
    Exit;
  End;
  inOptionsSection := false;
  while not (inOptionsSection or EOF(OldFile)) do
  begin
    ReadLn(OldFile,Line);
    WriteLn(NewFile,Line);
    if (LeftStr(Trim(UpperCase(Line)),5) = '[OPTI') then
      inOptionsSection :=true;
  end;
  while inOptionsSection do
  begin
    ReadLn(OldFile, Line);
    Line := Trim(Line);
    if (Pos('FLOW_UNITS', Line) = 1) then
      WriteLn(NewFile, 'FLOW_UNITS           ' + FFlowUnitLabel)
    else if (Pos('START_DATE', Line) = 1) then
      WriteLn(NewFile, 'START_DATE           ' + formatDateTime('mm/dd/yyyy',StartDate))
    else if (Pos('START_TIME', Line) = 1) then
      WriteLn(NewFile, 'START_TIME           ' + formatDateTime('hh:MM:ss',StartDate))
    else if (Pos('REPORT_START_DATE', Line) = 1) then
      WriteLn(NewFile, 'REPORT_START_DATE    ' + formatDateTime('mm/dd/yyyy',StartDate))
    else if (Pos('REPORT_START_TIME', Line) = 1) then
     WriteLn(NewFile, 'REPORT_START_TIME    ' + formatDateTime('hh:MM:ss',StartDate))
    else if (Pos('END_DATE', Line) = 1) then
      WriteLn(NewFile, 'END_DATE             ' + formatDateTime('mm/dd/yyyy',EndDate))
    else if (Pos('END_TIME', Line) = 1) then
      WriteLn(NewFile, 'END_TIME             ' + formatDateTime('hh:MM:ss',EndDate))
    else
      Writeln(NewFile, Line);
    if (LeftStr(Trim(UpperCase(Line)),1) = '[') then
      inOptionsSection := false;
  end;
  while not EOF(OldFile) do
  begin
    ReadLn(OldFile,Line);
    WriteLn(NewFile,Line);
  end;
  CloseFile(NewFile);
  CloseFile(OldFile);
  //overwrite the existing input file with our new file
  CopyFile(pAnsiChar(NewFileName), pAnsiChar(OldFileName), false);
  //delete the new file we created
  //DeleteFile(pAnsiChar(NewFileName));
  //Result := true;
end;

function TfrmExportRDIIHydrographs.isHoliday(date: TDateTime): boolean;
var
  i: integer;
begin
  isHoliday := false;
  for i := 0 to length(holidays) - 1 do begin
    if (trunc(date) = holidays[i]) then isHoliday := true;
  end;
end;

procedure TfrmExportRDIIHydrographs.Export2CSVFile;
var
  i, j, k, idx, num, areaUnitID: integer;
  area, KTmax: double;
    queryStr, queryStr1, queryStr2 : string;
    recSet:   _recordSet;
    F0: textfile;
    timeStamp, timestep: TDateTime;
    wantsFormattedDates: boolean;
begin

  FRDIIOutFileName := edOutFileName.Text;
//rm 2010-04-22 - NO LONGER DOING DWF
//rm  FDWFOutFileName := GetDWFOutFileName(FRDIIOutFileName);

  wantsFormattedDates := true;
  FrameRDIIGraph1.ClearAll;
  frmFeedbackWithMemo.Refresh;
  num := 0;
  queryStr1 := 'SELECT p.RTKPatternName, p.R1, p.T1, p.K1, ' +
            ' p.R2, p.T2, p.K2, p.R3, p.T3, p.K3, ' +
            ' p.AI, p.AM, p.AR, ' +
            ' a.RDIIAreaName, a.JunctionID, a.RainGaugeID, a.Area, a.AreaUnitID, ' +
//rm 2010-10-05
            ' p.AI2, p.AM2, p.AR2, p.AI3, p.AM3, p.AR3 ' +
            ' FROM RTKPatterns as p INNER JOIN ' +
            ' (RDIIAreas as a INNER JOIN RTKLinks as l ' +
            ' ON a.RDIIAreaID = l.RDIIAreaID) ' +
            ' ON p.RTKPatternID = l.RTKPatternID ' +
            ' WHERE l.ScenarioID = ' + inttostr(ScenarioID);
  queryStr2 := 'SELECT p.RTKPatternName, p.R1, p.T1, p.K1, ' +
            ' p.R2, p.T2, p.K2, p.R3, p.T3, p.K3, ' +
            ' p.AI, p.AM, p.AR, ' +
            ' a.SewerShedName, a.JunctionID, a.RainGaugeID, a.Area, a.AreaUnitID, ' +
//rm 2010-10-05
            ' p.AI2, p.AM2, p.AR2, p.AI3, p.AM3, p.AR3 ' +
            ' FROM RTKPatterns as p INNER JOIN ' +
            ' (SewerSheds as a INNER JOIN RTKLinks as l ' +
            ' ON a.SewerShedID = l.SewerShedID) ' +
            ' ON p.RTKPatternID = l.RTKPatternID ' +
            ' WHERE l.ScenarioID = ' + inttostr(ScenarioID) + ' AND l.RDIIAreaID < 1';
  queryStr := queryStr1 + ' UNION ALL ' + queryStr2;
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if recSet.EOF then begin
    recSet.Close;
    MessageDlg('No RDIIAreas or SewerSheds for the selected Scenario.',
      mtInformation,[mbok],0);
    exit;
  end;
  recSet.MoveFirst;
  k := 0;
  //num := recSet.RecordCount; - nope not working
  num := 0;
  While not recSet.EOF do begin
    inc(num);
    recSet.Movenext;
  end;
  if num < 1 then begin
    recSet.Close;
    MessageDlg('No RDIIAreas or SewerSheds for the selected Scenario.',
      mtInformation,[mbok],0);
    exit;
  end;
  recSet.MoveFirst;
  try
    FrameRDIIGraph1.NumAreas := num;
    FrameRDIIGraph1.RainGaugeName := RaingaugeName;
    while not recSet.EOF do begin
      FrameRDIIGraph1.R[0,k] := recSet.Fields.Item[1].Value;
      FrameRDIIGraph1.T[0,k] := recSet.Fields.Item[2].Value;
      FrameRDIIGraph1.K[0,k] := recSet.Fields.Item[3].Value;
      FrameRDIIGraph1.R[1,k] := recSet.Fields.Item[4].Value;
      FrameRDIIGraph1.T[1,k] := recSet.Fields.Item[5].Value;
      FrameRDIIGraph1.K[1,k] := recSet.Fields.Item[6].Value;
      FrameRDIIGraph1.R[2,k] := recSet.Fields.Item[7].Value;
      FrameRDIIGraph1.T[2,k] := recSet.Fields.Item[8].Value;
      FrameRDIIGraph1.K[2,k] := recSet.Fields.Item[9].Value;
{
//rm 2010-10-05
      if VarIsNull(recSet.Fields.Item[10].Value) then
        FrameRDIIGraph1.AI[k] := 0.0
      else
        FrameRDIIGraph1.AI[k] := recSet.Fields.Item[10].Value;
      if VarIsNull(recSet.Fields.Item[11].Value) then
        FrameRDIIGraph1.AM[k] := 0.0
      else
        FrameRDIIGraph1.AM[k] := recSet.Fields.Item[11].Value;
      if VarIsNull(recSet.Fields.Item[12].Value) then
        FrameRDIIGraph1.AR[k] := 0.0
      else
        FrameRDIIGraph1.AR[k] := recSet.Fields.Item[12].Value;
}
      if VarIsNull(recSet.Fields.Item[10].Value) then
        FrameRDIIGraph1.AI[0,k] := 0.0
      else
        FrameRDIIGraph1.AI[0,k] := recSet.Fields.Item[10].Value;
      if VarIsNull(recSet.Fields.Item[11].Value) then
        FrameRDIIGraph1.AM[0,k] := 0.0
      else
        FrameRDIIGraph1.AM[0,k] := recSet.Fields.Item[11].Value;
      if VarIsNull(recSet.Fields.Item[12].Value) then
        FrameRDIIGraph1.AR[0,k] := 0.0
      else
        FrameRDIIGraph1.AR[0,k] := recSet.Fields.Item[12].Value;
      FrameRDIIGraph1.S[k] := recSet.Fields.Item[13].Value;
      FrameRDIIGraph1.L[k] := recSet.Fields.Item[14].Value;
      if VarIsNull(recSet.Fields.Item[15].Value) then
        FrameRDIIGraph1.G[k] := FRainGaugeID
      else
        if UseAssignedGauge then
          FrameRDIIGraph1.G[k] := recSet.Fields.Item[15].Value
        else
          FrameRDIIGraph1.G[k] := FRainGaugeID;
      areaUnitID := recSet.Fields.Item[17].Value;

      if VarIsNull(recSet.Fields.Item[18].Value) then
        FrameRDIIGraph1.AI[1,k] := 0.0
      else
        FrameRDIIGraph1.AI[1,k] := recSet.Fields.Item[18].Value;
      if VarIsNull(recSet.Fields.Item[19].Value) then
        FrameRDIIGraph1.AM[1,k] := 0.0
      else
        FrameRDIIGraph1.AM[1,k] := recSet.Fields.Item[19].Value;
      if VarIsNull(recSet.Fields.Item[20].Value) then
        FrameRDIIGraph1.AR[1,k] := 0.0
      else
        FrameRDIIGraph1.AR[1,k] := recSet.Fields.Item[20].Value;

      if VarIsNull(recSet.Fields.Item[21].Value) then
        FrameRDIIGraph1.AI[2,k] := 0.0
      else
        FrameRDIIGraph1.AI[2,k] := recSet.Fields.Item[21].Value;
      if VarIsNull(recSet.Fields.Item[22].Value) then
        FrameRDIIGraph1.AM[2,k] := 0.0
      else
        FrameRDIIGraph1.AM[2,k] := recSet.Fields.Item[22].Value;
      if VarIsNull(recSet.Fields.Item[23].Value) then
        FrameRDIIGraph1.AR[2,k] := 0.0
      else
        FrameRDIIGraph1.AR[2,k] := recSet.Fields.Item[23].Value;

      FrameRDIIGraph1.A[k] :=
        DatabaseModule.GetConversionFactorForAreaUnitID(areaUnitID) * recSet.Fields.Item[16].Value;
      recSet.MoveNext;
      inc(k);
    end;
  finally
    recSet.Close;
  end;
  Screen.Cursor := crHourglass;
  try
    FrameRDIIGraph1.StartDate := GetStartDateTime;
    FrameRDIIGraph1.EndDate := GetEndDateTime + FrameRDIIGraph1.KTMax;
    FrameRDIIGraph1.FlowUnitLabel := FlowUnitLabel;
    FrameRDIIGraph1.UpdateData;

    FExportedStartDateTime := Floor(FrameRDIIGraph1.StartDate);
    FExportedEndDateTime := FrameRDIIGraph1.EndDate;
    FExportedTimeStepinDays := (FrameRDIIGraph1.TimeStep) / (24.0 * 60.0);
    FExportedNumTimeSteps := FrameRDIIGraph1.NumTimeSteps;

    //FrameRDIIGraph1.
    AssignFile(F0, FRDIIOutFileName);
    Rewrite(F0);

//    writeln(F0,'SWMM5');
//    writeln(F0,'FROM SSOAP-RDII HYDROGRAPH GENERATION TOOL: Hydrographs' +
//      ' for Scenario ' + FScenarioName);
//    writeln(F0, inttostr(FrameRDIIGraph1.timestep*60));
//    writeln(F0, '1');
//    writeln(F0, 'FLOW ' + flowUnitLabel);
//    writeln(F0, inttostr(FrameRDIIGraph1.numareas));
//    for i := 0 to FrameRDIIGraph1.numareas - 1 do begin
//      writeln(F0, FrameRDIIGraph1.L[i]);
//    end;

//rm 2007-10-23    timeStamp := FrameRDIIGraph1.StartDate;
    timeStamp := Floor(FrameRDIIGraph1.StartDate);
    timeStep := FrameRDIIGraph1.TimeStep / (24.0 * 60.0);
//    writeln(F0, 'Node Year Mon Day Hr Min Sec Flow');
    if wantsFormattedDates then
      write(F0, 'DateTime')
    else
      write(F0, 'Year,Mon,Day,Hr,Min,Sec');
    for j := 0 to FrameRDIIGraph1.numareas - 1 do begin
      write(F0, ',' + FrameRDIIGraph1.L[j]);
    end;
    writeln(F0);
{
    for j := 0 to FrameRDIIGraph1.numareas - 1 do begin
      write(F0, ',' + FloattoStr(FrameRDIIGraph1.A[j]));
    end;
    writeln(F0);
    for j := 0 to FrameRDIIGraph1.numareas - 1 do begin
      write(F0, ',' + FloattoStr(FrameRDIIGraph1.R[0,j]));
    end;
    writeln(F0);
    for j := 0 to FrameRDIIGraph1.numareas - 1 do begin
      write(F0, ',' + FloattoStr(FrameRDIIGraph1.R[1,j]));
    end;
    writeln(F0);
    for j := 0 to FrameRDIIGraph1.numareas - 1 do begin
      write(F0, ',' + FloattoStr(FrameRDIIGraph1.R[2,j]));
    end;
    writeln(F0);
    for j := 0 to FrameRDIIGraph1.numareas - 1 do begin
      write(F0, ',' + FloattoStr(FrameRDIIGraph1.T[0,j]));
    end;
    writeln(F0);
    for j := 0 to FrameRDIIGraph1.numareas - 1 do begin
      write(F0, ',' + FloattoStr(FrameRDIIGraph1.T[1,j]));
    end;
    writeln(F0);
    for j := 0 to FrameRDIIGraph1.numareas - 1 do begin
      write(F0, ',' + FloattoStr(FrameRDIIGraph1.T[2,j]));
    end;
    writeln(F0);
    for j := 0 to FrameRDIIGraph1.numareas - 1 do begin
      write(F0, ',' + FloattoStr(FrameRDIIGraph1.K[0,j]));
    end;
    writeln(F0);
    for j := 0 to FrameRDIIGraph1.numareas - 1 do begin
      write(F0, ',' + FloattoStr(FrameRDIIGraph1.K[1,j]));
    end;
    writeln(F0);
    for j := 0 to FrameRDIIGraph1.numareas - 1 do begin
      write(F0, ',' + FloattoStr(FrameRDIIGraph1.K[2,j]));
    end;
    writeln(F0);

    writeln(F0, 'KTMax = ' + FloatToStr(FrameRDIIGraph1.KTMax));
    writeln(F0, 'Raingauge = ' + FrameRDIIGraph1.RainGaugeName);
}
    for i := 0 to FrameRDIIGraph1.NumTimeSteps - 1 do begin

      //write(F0, FloatToStr(FrameRDIIGraph1.R[0,i]) + ',');

      if wantsFormattedDates then
        write(F0, FormatDateTime('yyyy/mm/dd h:MM:ss',timeStamp))
      else
        write(F0, FormatDateTime('yyyy,m,d,h,M,s',timeStamp));
      for j := 0 to FrameRDIIGraph1.numareas - 1 do begin
        write(F0, ',' + FormatFloat('0.####',FrameRDIIGraph1.Flow[j,i]));
      end;
      writeln(F0);
      timeStamp := round((timeStamp + timeStep) * 17280)/17280;    //round to nearest 5 secs
    end;
    CloseFile(F0);
  finally
    Screen.Cursor := crDefault;
    frmFeedbackWithMemo.feedbackMemo.Lines.add('');
    frmFeedbackWithMemo.feedbackMemo.Lines.add('Done exporting to ' + FRDIIOutFileName);
    frmFeedbackWithMemo.feedbackMemo.Lines.add('');
//    frmFeedbackWithMemo.feedbackMemo.Lines.add('This window may be closed.');
//    PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,0,0);
    //MessageDlg('Done processing ' + edOutFileName.text,mtInformation, [mbok], 0);
    FrameRDIIGraph1.ClearAll;
  end;
end;

//rm 2010-04-22 - NO LONGER DOING DWF
(*
procedure TfrmExportRDIIHydrographs.ExportDWF2CSVFile;
var
  i, j, m, idx, numMeters, numJunctions, oldMeterID, meterID,
  timestepinSeconds, dow: integer;
  hr,mn,sec,ms: word;
  area, meterArea, rat: double;
  queryStr, queryStr1, queryStr2, junction, oldjunction: string;
  recSet:   _recordSet;
  F0: textfile;
  timeStamp: TDateTime;
  weekdayDWFs, weekendDWFs: Array of THydrograph;
  junctions: array of string;
  areaRatios: array of double;
  meterIDs: array of integer;
  fileext: string;
  wantsFormattedDates: boolean;
begin
  wantsFormattedDates := true;
  numJunctions := 0;
  queryStr1 := 'SELECT ' +
              ' a.RDIIAreaName, a.JunctionID, a.MeterID, a.Area, b.Area ' +
              ' FROM Meters as b inner join ' +
              ' (RDIIAreas as a INNER JOIN RTKLinks as l ' +
              ' ON a.RDIIAreaID = l.RDIIAreaID) ' +
              ' on a.MeterID = b.MeterID ' +
              ' WHERE l.ScenarioID = ' + inttostr(ScenarioID) +
              ' ORDER BY a.MeterID;';
  queryStr2 := 'SELECT ' +
              ' a.SewerShedName, a.JunctionID, a.MeterID, a.Area, b.Area ' +
              ' FROM Meters as b inner join ' +
              ' (SewerSheds as a INNER JOIN RTKLinks as l ' +
              ' ON a.SewerShedID = l.SewerShedID) ' +
              ' on a.MeterID = b.MeterID ' +
              ' WHERE l.ScenarioID = ' + inttostr(ScenarioID) + ' AND l.RDIIAreaID < 1'+
              ' ORDER BY a.MeterID;';
  queryStr := queryStr1 + ' UNION ALL ' + queryStr2;
  //DatabaseModule.logSQL(queryStr);
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    //num := recSet.RecordCount; - nope not working
    numMeters := 0;
    numJunctions := 0;
    oldMeterID := -1;
    oldJunction := '';
    While not recSet.EOF do begin
      junction := recSet.Fields.Item[1].Value;
      meterID := recSet.Fields.Item[2].Value;
      area := recSet.Fields.Item[3].Value;
      meterArea := recSet.Fields.Item[4].Value;
      if meterArea > 0 then
        rat := area / meterArea
      else
        rat := 1;
      if meterID <> oldMeterID then begin
        inc(numMeters);
        oldMeterID := meterID;
      end;
      inc(numJunctions);
      recSet.Movenext;
    end;
    SetLength(weekDayDWFs,numMeters);
    SetLength(weekEndDWFs,numMeters);
    SetLength(junctions,numJunctions);
    SetLength(areaRatios,numJunctions);
    SetLength(meterids,numJunctions);
    oldMeterID := -1;
    j := 0;
    m := -1;
    recSet.MoveFirst;
    While not recSet.EOF do begin
      junction := recSet.Fields.Item[1].Value;
      meterID := recSet.Fields.Item[2].Value;
      area := recSet.Fields.Item[3].Value;
      meterArea := recSet.Fields.Item[4].Value;
      if meterArea > 0 then
        rat := area / meterArea
      else
        rat := 1;
      junctions[j] := junction;
      areaRatios[j] := rat;
      if meterID <> oldMeterID then begin
        inc(m);
        oldMeterID := meterID;
      end;
      meterids[j] := m;
      weekDayDWFs[m] := DatabaseModule.GetWeekdayDWF(meterID);
      weekEndDWFs[m] := DatabaseModule.GetWeekendDWF(meterID);
      inc(j);
      recSet.Movenext;
    end;
  end;
  recSet.Close;
  //now we have loaded up the array of junctions, areas, meterids
  //and the arrays of weekday and weekend DWFs
  Screen.Cursor := crHourglass;
  if numJunctions > 0 then
  try
    GetThemHolidays;
    timeStepinSeconds := round(FExportedTimeStepinDays * 24.0 * 60.0 * 60.0);

    AssignFile(F0,FDWFOutFileName);
    Rewrite(F0);

    if wantsFormattedDates then
      write(F0, 'DateTime')
    else
      write(F0, 'Year,Mon,Day,Hr,Min,Sec');
    for j := 0 to numJunctions - 1 do
      write(F0, ',' + junctions[j]);
    writeln(F0);
{
    writeln(F0,'Datetime, Junction, DWF_' + flowUnitLabel);
    writeln(F0,'FROM SSOAP-RDII HYDROGRAPH GENERATION TOOL: DWF Hydrographs' +
      ' for Scenario ' + FScenarioName);
    writeln(F0, inttostr(timestepinSeconds));
    writeln(F0, '1');
    writeln(F0, 'FLOW ' + flowUnitLabel);
    writeln(F0, inttostr(numJunctions));
    for j := 0 to numJunctions - 1 do begin
      writeln(F0, junctions[j]);
    end;
}
    timeStamp := FExportedStartDateTime;
    DecodeTime(timeStamp, hr, mn, sec, ms);
    idx := trunc(((hr + (mn / 60.0)) / 24) / FExportedTimeStepinDays);
    dow := dayOfWeekIndex(timestamp);


//    writeln(F0, 'Node Year Mon Day Hr Min Sec Flow');
{
    for i := 0 to FExportedNumTimeSteps - 1 do begin
      for j := 0 to numJunctions - 1 do begin
        if ((dow > 0) and (dow < 6)) then
          writeln(F0, junctions[j] +
            FormatDateTime(' yyyy m d h M s ',timeStamp) +
            FormatFloat('0.###',areaRatios[j] * weekdayDWFs[meterIDs[j]].Flows[idx]))
        else
          writeln(F0, junctions[j] +
            FormatDateTime(' yyyy m d h M s ',timeStamp) +
            FormatFloat('0.###',areaRatios[j] * weekendDWFs[meterIDs[j]].Flows[idx]));
      end;
      timeStamp := timeStamp + FExportedTimeStepinDays;
      DecodeTime(timeStamp, hr, mn, sec, ms);
      idx := trunc(((hr + (mn / 60.0)) / 24) / FExportedTimeStepinDays);
      dow := dayOfWeekIndex(timestamp);
    end;
}
{
      if wantsFormattedDates then
        write(F0, FormatDateTime('yyyy/mm/dd h:MM:ss',timeStamp))
      else
        write(F0, FormatDateTime('yyyy,m,d,h,M,s',timeStamp));
        for j := 0 to numJunctions - 1 do
          write(F0, ',' + FormatFloat('0.###',FrameRDIIGraph1.Flow[j,i]));
      end;
      writeln(F0);
}
    wantsFormattedDates := true;
    for i := 0 to FExportedNumTimeSteps - 1 do begin
      if wantsFormattedDates then
        write(F0, FormatDateTime('yyyy/m/d h:M:s',timeStamp))
      else
        write(F0, FormatDateTime('yyyy,m,d,h,M,s',timeStamp));
      if ((dow > 0) and (dow < 6)) then
          for j := 0 to numJunctions - 1 do
          write(F0, ', ' +
            FormatFloat('0.####',areaRatios[j] * weekdayDWFs[meterIDs[j]].Flows[idx]))
      else
          for j := 0 to numJunctions - 1 do
          write(F0, ', ' +
            FormatFloat('0.####',areaRatios[j] * weekendDWFs[meterIDs[j]].Flows[idx]));
      writeln(F0);
      //timeStamp := timeStamp + FExportedTimeStepinDays;
      timeStamp := round((timeStamp + FExportedTimeStepinDays) * 17280)/17280;    //round to nearest 5 secs
      DecodeTime(timeStamp, hr, mn, sec, ms);
      idx := trunc(((hr + (mn / 60.0)) / 24) / FExportedTimeStepinDays);
      dow := dayOfWeekIndex(timestamp);
    end;
    CloseFile(F0);
  finally
    Screen.Cursor := crDefault;
    Screen.Cursor := crDefault;
    frmFeedbackWithMemo.feedbackMemo.Lines.add('');
    frmFeedbackWithMemo.feedbackMemo.Lines.add('Done exporting DWF to ' + FDWFOutFileName);
    frmFeedbackWithMemo.feedbackMemo.Lines.add('');
    frmFeedbackWithMemo.feedbackMemo.Lines.add('This window may be closed.');
    PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,0,0);
    //MessageDlg('Done processing ' + FDWFOutFileName,mtInformation, [mbok], 0);
  end;
end;
*)

//rm 2010-04-22 - NO LONGER DOING DWF
(*
function TfrmExportRDIIHydrographs.ExportDWF2SWM5InterfaceFile: boolean;
var
  boReturn: boolean;
  i, j, m, idx, numMeters, numJunctions, oldMeterID, meterID,
  timestepinSeconds, dow: integer;
  hr,mn,sec,ms: word;
  area, meterArea, rat: double;
  queryStr, queryStr1, queryStr2, junction, oldjunction: string;
  recSet:   _recordSet;
  F0: textfile;
  timeStamp: TDateTime;
  weekdayDWFs, weekendDWFs: Array of THydrograph;
  junctions: array of string;
  areaRatios: array of double;
  meterIDs: array of integer;
  fileext: string;
begin
  boReturn := false;
  numJunctions := 0;
  queryStr1 := 'SELECT ' +
              ' a.RDIIAreaName, a.JunctionID, a.MeterID, a.Area, b.Area ' +
              ' FROM Meters as b inner join ' +
              ' (RDIIAreas as a INNER JOIN RTKLinks as l ' +
              ' ON a.RDIIAreaID = l.RDIIAreaID) ' +
              ' on a.MeterID = b.MeterID ' +
              ' WHERE l.ScenarioID = ' + inttostr(ScenarioID) +
              ' ORDER BY a.MeterID';
  queryStr2 := 'SELECT ' +
              ' a.SewerShedName, a.JunctionID, a.MeterID, a.Area, b.Area ' +
              ' FROM Meters as b inner join ' +
              ' (SewerSheds as a INNER JOIN RTKLinks as l ' +
              ' ON a.SewerShedID = l.SewerShedID) ' +
              ' on a.MeterID = b.MeterID ' +
              ' WHERE l.ScenarioID = ' + inttostr(ScenarioID) + ' AND l.RDIIAreaID < 1' +
              ' ORDER BY a.MeterID';
  queryStr := queryStr1 + ' UNION ALL ' + queryStr2;

  //DatabaseModule.logSQL(queryStr);
  //messagedlg(queryStr,mtInformation,[mbok],0);
//  frmInfo.Memo1.Text := queryStr;
//  frmInfo.Show;

  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    //num := recSet.RecordCount; - nope not working
    numMeters := 0;
    numJunctions := 0;
    oldMeterID := -1;
    oldJunction := '';
    While not recSet.EOF do begin
      boReturn := true;
      junction := recSet.Fields.Item[1].Value;
      meterID := recSet.Fields.Item[2].Value;
      area := recSet.Fields.Item[3].Value;
      meterArea := recSet.Fields.Item[4].Value;
      if meterArea > 0 then
        rat := area / meterArea
      else
        rat := 1;
      if meterID <> oldMeterID then begin
        inc(numMeters);
        oldMeterID := meterID;
      end;
      inc(numJunctions);
      recSet.Movenext;
    end;
    SetLength(weekDayDWFs,numMeters);
    SetLength(weekEndDWFs,numMeters);
    SetLength(junctions,numJunctions);
    SetLength(areaRatios,numJunctions);
    SetLength(meterids,numJunctions);
    oldMeterID := -1;
    j := 0;
    m := -1;
    recSet.MoveFirst;
    While not recSet.EOF do begin
      junction := recSet.Fields.Item[1].Value;
      meterID := recSet.Fields.Item[2].Value;
      area := recSet.Fields.Item[3].Value;
      meterArea := recSet.Fields.Item[4].Value;
      if meterArea > 0 then
        rat := area / meterArea
      else
        rat := 1;
      junctions[j] := junction;
      areaRatios[j] := rat;
      if meterID <> oldMeterID then begin
        inc(m);
        oldMeterID := meterID;
      end;
      meterids[j] := m;
      weekDayDWFs[m] := DatabaseModule.GetWeekdayDWF(meterID);
      weekEndDWFs[m] := DatabaseModule.GetWeekendDWF(meterID);
      inc(j);
      recSet.Movenext;
    end;
  end;
  recSet.Close;
  //now we have loaded up the array of junctions, areas, meterids
  //and the arrays of weekday and weekend DWFs
  Screen.Cursor := crHourglass;
  if numJunctions > 0 then
  try
    GetThemHolidays;
    timeStepinSeconds := round(FExportedTimeStepinDays * 24.0 * 60.0 * 60.0);

    AssignFile(F0,FDWFOutFileName);
    Rewrite(F0);
    writeln(F0,'SWMM5');
    writeln(F0,'FROM SSOAP-RDII HYDROGRAPH GENERATION TOOL: DWF Hydrographs' +
      ' for Scenario ' + FScenarioName);
    writeln(F0, inttostr(timestepinSeconds));
    writeln(F0, '1');
    writeln(F0, 'FLOW ' + flowUnitLabel);
    writeln(F0, inttostr(numJunctions));
    for j := 0 to numJunctions - 1 do begin
      writeln(F0, junctions[j]);
    end;
    timeStamp := FExportedStartDateTime;
    DecodeTime(timeStamp, hr, mn, sec, ms);
    idx := trunc(((hr + (mn / 60.0)) / 24) / FExportedTimeStepinDays);
    dow := dayOfWeekIndex(timestamp);

    writeln(F0, 'Node Year Mon Day Hr Min Sec Flow');
    for i := 0 to FExportedNumTimeSteps - 1 do begin
      for j := 0 to numJunctions - 1 do begin
        if ((dow > 0) and (dow < 6)) then
          writeln(F0, junctions[j] +
            FormatDateTime(' yyyy m d h M s ',timeStamp) +
            FormatFloat('0.####',areaRatios[j] * weekdayDWFs[meterIDs[j]].Flows[idx]))
        else
          writeln(F0, junctions[j] +
            FormatDateTime(' yyyy m d h M s ',timeStamp) +
            FormatFloat('0.####',areaRatios[j] * weekendDWFs[meterIDs[j]].Flows[idx]));
      end;
//      timeStamp := timeStamp + FExportedTimeStepinDays;
      timeStamp := round((timeStamp + FExportedTimeStepinDays) * 17280)/17280;    //round to nearest 5 secs
      DecodeTime(timeStamp, hr, mn, sec, ms);
      idx := trunc(((hr + (mn / 60.0)) / 24) / FExportedTimeStepinDays);
      dow := dayOfWeekIndex(timestamp);
    end;
    CloseFile(F0);
  finally
    Screen.Cursor := crDefault;
    MessageDlg('Done processing ' + FDWFOutFileName,mtInformation, [mbok], 0);
  end;
  Result := boReturn;
end;
*)

procedure TfrmExportRDIIHydrographs.ExportRDII2SWM5InterfaceFile;
var
  i, j, k, idx, num, areaUnitID, im: integer;
  area, KTmax: double;
    queryStr, queryStr1, queryStr2: string;
    recSet:   _recordSet;
    F0: textfile;
    timeStamp, timeStep : TDateTime;
begin
//rm 2007-11-06 - NO Provision for DWF export  -
//  Options:
//    1) Include DWF in with RDII in single Interface file
//    2) Put DWF in separate Interface file
//        - RDII in "USE RDII {filename}", DWF in "USE INFLOWS {filename}"
//    3) Put DWF in [DWF] and [PATTERNS] sections of the SWMM5 input file
//
//I think I like option 2 - let's pursue that
//
//Get the DWF from WeekdayDWF and WeekendAndHoliday DWF by MeterID
//  Adjust Flow by (RDIIArea or Sewershed Area)/(Meter Area)
//  for each load point
//
im:=1000;
//showmessage(inttostr(im));im:=im+1;
try
  FrameRDIIGraph1.ClearAll;
finally

end;
//showmessage(inttostr(im));im:=im+1;
  num := 0;
  queryStr1 := 'SELECT p.RTKPatternName, p.R1, p.T1, p.K1, ' +
            ' p.R2, p.T2, p.K2, p.R3, p.T3, p.K3, ' +
            ' p.AI, p.AM, p.AR, ' +
            ' a.RDIIAreaName, a.JunctionID, a.RainGaugeID, a.Area, a.AreaUnitID ' +
            ' FROM RTKPatterns as p INNER JOIN ' +
            ' (RDIIAreas as a INNER JOIN RTKLinks as l ' +
            ' ON a.RDIIAreaID = l.RDIIAreaID) ' +
            ' ON p.RTKPatternID = l.RTKPatternID ' +
            ' WHERE l.ScenarioID = ' + inttostr(ScenarioID);
  queryStr2 := 'SELECT p.RTKPatternName, p.R1, p.T1, p.K1, ' +
            ' p.R2, p.T2, p.K2, p.R3, p.T3, p.K3, ' +
            ' p.AI, p.AM, p.AR, ' +
            ' a.SewerShedName, a.JunctionID, a.RainGaugeID, a.Area, a.AreaUnitID ' +
            ' FROM RTKPatterns as p INNER JOIN ' +
            ' (SewerSheds as a INNER JOIN RTKLinks as l ' +
            ' ON a.SewerShedID = l.SewerShedID) ' +
            ' ON p.RTKPatternID = l.RTKPatternID ' +
            ' WHERE l.ScenarioID = ' + inttostr(ScenarioID) + ' AND l.RDIIAreaID < 1';
//showmessage(inttostr(im));im:=im+1;
  queryStr := queryStr1 + ' UNION ALL ' + queryStr2;
//showmessage(querystr);
  recSet := CoRecordSet.Create;
//showmessage(inttostr(im));im:=im+1;
try
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);

finally

end;
//showmessage(inttostr(im));im:=im+1;
  if recSet.EOF then begin
    MessageDlg('No RDIIAreas or SewerSheds for the selected Scenario.',
      mtInformation,[mbok],0);
    recSet.Close;
    exit;
  end;
//showmessage(inttostr(im));im:=im+1;

  recSet.MoveFirst;
  k := 0;
  //num := recSet.RecordCount; - nope not working
  num := 0;
  While not recSet.EOF do begin
    inc(num);
    recSet.Movenext;
  end;
  if num < 1 then begin
    recSet.Close;
    MessageDlg('No RDIIAreas or SewerSheds for the selected Scenario.',
      mtInformation,[mbok],0);
    exit;
  end;
  recSet.MoveFirst;
  try
    FrameRDIIGraph1.NumAreas := num;
    FrameRDIIGraph1.RainGaugeName := RaingaugeName;
    while not recSet.EOF do begin
      FrameRDIIGraph1.R[0,k] := recSet.Fields.Item[1].Value;
      FrameRDIIGraph1.T[0,k] := recSet.Fields.Item[2].Value;
      FrameRDIIGraph1.K[0,k] := recSet.Fields.Item[3].Value;
      FrameRDIIGraph1.R[1,k] := recSet.Fields.Item[4].Value;
      FrameRDIIGraph1.T[1,k] := recSet.Fields.Item[5].Value;
      FrameRDIIGraph1.K[1,k] := recSet.Fields.Item[6].Value;
      FrameRDIIGraph1.R[2,k] := recSet.Fields.Item[7].Value;
      FrameRDIIGraph1.T[2,k] := recSet.Fields.Item[8].Value;
      FrameRDIIGraph1.K[2,k] := recSet.Fields.Item[9].Value;
{
//rm 2010-10-05
      if VarIsNull(recSet.Fields.Item[10].Value) then
        FrameRDIIGraph1.AI[k] := 0.0
      else
        FrameRDIIGraph1.AI[k] := recSet.Fields.Item[10].Value;
      if VarIsNull(recSet.Fields.Item[11].Value) then
        FrameRDIIGraph1.AM[k] := 0.0
      else
        FrameRDIIGraph1.AM[k] := recSet.Fields.Item[11].Value;
      if VarIsNull(recSet.Fields.Item[12].Value) then
        FrameRDIIGraph1.AR[k] := 0.0
      else
        FrameRDIIGraph1.AR[k] := recSet.Fields.Item[12].Value;
}
      if VarIsNull(recSet.Fields.Item[10].Value) then
        FrameRDIIGraph1.AI[0,k] := 0.0
      else
        FrameRDIIGraph1.AI[0,k] := recSet.Fields.Item[10].Value;
      if VarIsNull(recSet.Fields.Item[11].Value) then
        FrameRDIIGraph1.AM[0,k] := 0.0
      else
        FrameRDIIGraph1.AM[0,k] := recSet.Fields.Item[11].Value;
      if VarIsNull(recSet.Fields.Item[12].Value) then
        FrameRDIIGraph1.AR[0,k] := 0.0
      else
        FrameRDIIGraph1.AR[0,k] := recSet.Fields.Item[12].Value;

      FrameRDIIGraph1.S[k] := recSet.Fields.Item[13].Value;
      FrameRDIIGraph1.L[k] := recSet.Fields.Item[14].Value;
      if VarIsNull(recSet.Fields.Item[15].Value) then
        FrameRDIIGraph1.G[k] := FRainGaugeID
      else
        if UseAssignedGauge then
          FrameRDIIGraph1.G[k] := recSet.Fields.Item[15].Value
        else
          FrameRDIIGraph1.G[k] := FRainGaugeID;
      //FrameRDIIGraph1.A[k] := recSet.Fields.Item[16].Value;
      areaUnitID := recSet.Fields.Item[17].Value;


      FrameRDIIGraph1.A[k] :=
        DatabaseModule.GetConversionFactorForAreaUnitID(areaUnitID) * recSet.Fields.Item[16].Value;
      recSet.MoveNext;
      inc(k);
    end;
  finally
    recSet.Close;
  end;
  Screen.Cursor := crHourglass;
  try
    FrameRDIIGraph1.StartDate := GetStartDateTime;
    FrameRDIIGraph1.EndDate := GetEndDateTime + FrameRDIIGraph1.KTMax;
    FrameRDIIGraph1.FlowUnitLabel := FlowUnitLabel;
    FrameRDIIGraph1.UpdateData;
    AssignFile(F0,FRDIIOutFileName);
    Rewrite(F0);
    writeln(F0,'SWMM5');
    writeln(F0,'FROM SSOAP-RDII HYDROGRAPH GENERATION TOOL: Hydrographs' +
      ' for Scenario ' + FScenarioName);
    writeln(F0, inttostr(FrameRDIIGraph1.timestep*60));
    writeln(F0, '1');
    writeln(F0, 'FLOW ' + flowUnitLabel);
    writeln(F0, inttostr(FrameRDIIGraph1.numareas));
    for i := 0 to FrameRDIIGraph1.numareas - 1 do begin
      writeln(F0, FrameRDIIGraph1.L[i]);
    end;
    //rm 2007-10-23 timeStamp := FrameRDIIGraph1.StartDate;
    timeStamp := Floor(FrameRDIIGraph1.StartDate);
    timeStep := FrameRDIIGraph1.TimeStep / (24.0 * 60.0);

    FExportedStartDateTime := timeStamp;
    FExportedTimeStepinDays := timeStep;
    FExportedEndDateTime := FrameRDIIGraph1.EndDate;
    FExportedNumTimeSteps := FrameRDIIGraph1.NumTimeSteps;

    writeln(F0, 'Node Year Mon Day Hr Min Sec Flow');
    for i := 0 to FrameRDIIGraph1.NumTimeSteps - 1 do begin
      for j := 0 to FrameRDIIGraph1.numareas - 1 do begin
        writeln(F0, FrameRDIIGraph1.L[j] +
          FormatDateTime(' yyyy m d h M s ',timeStamp) +
          FormatFloat('0.####',FrameRDIIGraph1.Flow[j,i]));
      end;
      //timeStamp := timeStamp + timeStep;
      timeStamp := round((timeStamp + timeStep) * 17280)/17280;    //round to nearest 5 secs
    end;
    CloseFile(F0);
  finally
    Screen.Cursor := crDefault;
    MessageDlg('Done processing ' + FRDIIOutFileName, mtInformation, [mbok], 0);
    FrameRDIIGraph1.ClearAll;
  end;
end;

procedure TfrmExportRDIIHydrographs.okButtonClick(Sender: TObject);
var bo: boolean;
  im: integer;
begin
//Do it!
  case rgExportOptions.ItemIndex of
    0:begin //swmm5 interface file
      //validate
      if (length(edOutFileName.Text) < 1) then begin
        MessageDlg('Please select the output interface file.',
                  mtError, [mbok],0);
        edOutFileName.SetFocus;
        exit;
      end;
      if (length(edInSWMM5.Text) < 1) then begin
        //MessageDlg('Please select the input SWMM5 file.',
        //          mtError, [mbok],0);
        //NOT REQUIRED - prompt user tho
        if (MessageDlg('Are you sure you do NOT want to update a ' +
            'SWMM5 input file with this interface file?',
            mtConfirmation, [mbYes,mbNo],0) <> mrYes) then
        begin
          edInSWMM5.SetFocus;
          exit;
        end;
      end;
      if (length(edInSWMM5.Text) > 0) and (length(edOutSWMM5.Text) < 1) then begin
        MessageDlg('Please select the output SWMM5 input file.',
                  mtError, [mbok],0);
        edOutSWMM5.SetFocus;
        exit;
      end;
      if (length(edInSWMM5.Text) > 0) and (Uppercase(edInSWMM5.Text) = Uppercase(edOutSWMM5.Text)) then begin
        MessageDlg('Output file must be different from input file.',
                  mtError, [mbok],0);
        edOutSWMM5.SetFocus;
        exit;
      end;
im := 0;
//Showmessage(inttostr(im));im := im +1;
      FRDIIOutFileName := edOutFileName.Text;
//Showmessage(inttostr(im));im := im +1;
//rm 2010-04-22 - NO LONGER DOING DWF
//rm      FDWFOutFileName := GetDWFOutFileName(FRDIIOutFileName);
//Showmessage(inttostr(im));im := im +1;
//BOMB!!!
      ExportRDII2SWM5InterfaceFile;
//Showmessage(inttostr(im));im := im +1;
//rm 2010-04-22 - NOT DOING DWF ANYMORE
//rm      bo := ExportDWF2SWM5InterfaceFile;
//Showmessage(inttostr(im));im := im +1;
      if (length(edInSWMM5.Text) > 0) then begin
//Showmessage(inttostr(im));im := im +1;
//rm 2010-04-22 - NO LONGER DOING DWF
//rm        InsertSWMM5InterFaceFile_and_ClearDWFSection(bo);
        InsertSWMM5InterFaceFile;
//Showmessage(inttostr(im));im := im +1;
        InsertSWMM5StartEndDates;
//Showmessage(inttostr(im));im := im +1;
        UpdateScenarioSWMM5InputFileName;
//Showmessage(inttostr(im));im := im +1;
      end;
    end;
    1:begin //sections of swmm5 input file
      //validate
im := 100;
      if (length(edInSWMM5.Text) < 1) then begin
        MessageDlg('Please select the input SWMM5 file.',
                  mtError, [mbok],0);
        edInSWMM5.SetFocus;
        exit;
      end;
//Showmessage(inttostr(im));im := im +1;
      if (length(edOutSWMM5.Text) < 1) then begin
        MessageDlg('Please select the output SWMM5 input file.',
                  mtError, [mbok],0);
        edOutSWMM5.SetFocus;
        exit;
      end;
//Showmessage(inttostr(im));im := im +1;
      if (Uppercase(edInSWMM5.Text) = Uppercase(edOutSWMM5.Text)) then begin
        MessageDlg('Output file must be different from input file.',
                  mtError, [mbok],0);
        edOutSWMM5.SetFocus;
        exit;
      end;
//Showmessage(inttostr(im));im := im +1;

      frmFeedbackWithMemo.Caption := 'SWMM5 Input File RDII HYDROGRAPH Section Export';

      SWMM5INPrdiiExporterThrd.CreateIt;
      frmFeedbackWithMemo.OpenForProcessing;

      UpdateScenarioSWMM5InputFileName;
    end;
    2:begin //csv
      //validate
      if (length(edOutFileName.Text) < 1) then begin
        MessageDlg('Please select the output CSV file.',
                  mtError, [mbok],0);
        edOutFileName.SetFocus;
        exit;
      end;
      frmFeedbackWithMemo.DateLabel.caption := datetostr(date);
      frmFeedbackWithMemo.Caption := 'RDII HYDROGRAPH Export to CSV';
      frmFeedbackWithMemo.feedbackMemo.Clear;
      frmFeedbackWithMemo.Show;
      Export2CSVFile;
//rm 2010-04-22 - NOT DOING DWF ANYMORE
//rm      ExportDWF2CSVFile;
    end;
  end;
  btnSWMM5_out.Enabled := Fileexists(edOutSWMM5.Text);
end;

procedure TfrmExportRDIIHydrographs.rgExportOptionsClick(Sender: TObject);
begin
  case rgExportOptions.ItemIndex of
    0:begin //swmm5 interface file
      lblOutFileName.Enabled := true;
      edOutFileName.Enabled := true;
      btnOutFileName.Enabled := true;
      lblInSWMM5.Enabled := true;
      edInSWMM5.Enabled := true;
      btnInSWMM5.Enabled := true;
      lblOutSWMM5.Enabled := true;
      edOutSWMM5.Enabled := true;
      btnOutSWMM5.Enabled := true;
    end;
    1:begin //sections of swmm5 input file
      lblOutFileName.Enabled :=false;
      edOutFileName.Enabled := false;
      btnOutFileName.Enabled := false;
      lblInSWMM5.Enabled := true;
      edInSWMM5.Enabled := true;
      btnInSWMM5.Enabled := true;
      lblOutSWMM5.Enabled := true;
      edOutSWMM5.Enabled := true;
      btnOutSWMM5.Enabled := true;
    end;
    2:begin //csv
      lblOutFileName.Enabled := true;
      edOutFileName.Enabled := true;
      btnOutFileName.Enabled := true;
      lblInSWMM5.Enabled := false;
      edInSWMM5.Enabled := false;
      btnInSWMM5.Enabled := false;
      lblOutSWMM5.Enabled := false;
      edOutSWMM5.Enabled := false;
      btnOutSWMM5.Enabled := false;
    end;
  end;
end;

procedure TfrmExportRDIIHydrographs.SetEndDate(const Value: TDateTime);
begin
  FEndDateTime := Value;
  EndDatePicker.DateTime := FEndDateTime;
  EndTimePicker.DateTime := FEndDateTime;
end;

procedure TfrmExportRDIIHydrographs.SetRainGaugeID(const Value: integer);
begin
  FRainGaugeID := Value;
  FRainGaugeName := DatabaseModule.GetRainGaugeNameForID(FRainGaugeID);
  rgRainGauge.Items[0] := 'Use Selected Rain Gauge (' + FRainGaugeName + ')'; 
end;

procedure TfrmExportRDIIHydrographs.SetScenarioID(const Value: integer);
begin
  FScenarioID := Value;
  FScenarioName := DatabaseModule.GetScenarioNameForID(FScenarioID);
  lblScenarioName.Caption := 'Scenario: ' + FScenarioName;
  FFlowUnitLabel := DatabaseModule.GetFlowUnitLabelForScenario(FScenarioID);
end;

procedure TfrmExportRDIIHydrographs.SetStartDate(const Value: TDateTime);
begin
  FStartDateTime := Value;
  StartDatePicker.DateTime := FStartDateTime;
  StartTimePicker.DateTime := FStartDateTime;
end;

procedure TfrmExportRDIIHydrographs.SetUseAssignedGauge(const Value: boolean);
begin
  if Value then
    rgRainGauge.ItemIndex := 1
  else
    rgRainGauge.ItemIndex := 0;
end;

procedure TfrmExportRDIIHydrographs.StartDatePickerChange(Sender: TObject);
begin
//
  FStartDateTime := Floor(StartDatePicker.Date) + Frac(StartTimePicker.Time);
end;

procedure TfrmExportRDIIHydrographs.UpdateScenarioSWMM5InputFileName;
begin
  DatabaseModule.SetScenarioInpFileName(FScenarioID,edOutSWMM5.Text);
end;

end.
