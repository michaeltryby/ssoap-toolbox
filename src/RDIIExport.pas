unit RDIIExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RDIIGraphFrame, ADODB_TLB,
  {StormEvent, StormEventCollection,} rdiiutils, math, Hydrograph, ComCtrls;

type
  TfrmRDIIExport = class(TForm)
    Label7: TLabel;
    Label5: TLabel;
    ListBoxRDIIAreas: TListBox;
    FrameRDIIGraph1: TFrameRDIIGraph;
    btnExport2RDIISections: TButton;
    ListBoxSewerSheds: TListBox;
    Label2: TLabel;
    ScenarioNameComboBox: TComboBox;
    Label3: TLabel;
    ScenarioDescription: TMemo;
    ComboBoxRainGauges: TComboBox;
    Label11: TLabel;
    Label4: TLabel;
    ComboBoxEvents: TComboBox;
    Label13: TLabel;
    Label19: TLabel;
    EndDatePicker: TDateTimePicker;
    StartDatePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    btnUpdate: TButton;
    btnClose: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialogSWMM5InpFile: TOpenDialog;
    btnExport2InterfaceFile: TButton;
    CheckBoxAssignedGauge: TCheckBox;
    btnEditScenario: TButton;
    btnEditSewerShed: TButton;
    btnEditRTKs: TButton;
    btnEditRDIIArea: TButton;
    btnHelp: TButton;
    chkbxAllSewerSheds: TCheckBox;
    chkbxAllRDIIArea: TCheckBox;
    btnExport: TButton;
    btnToggleColors: TButton;
    CheckBoxFreezeTime: TCheckBox;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxSewerShedsClick(Sender: TObject);
    procedure btnExport2RDIISectionsClick(Sender: TObject);
    procedure ScenarioNameComboBoxChange(Sender: TObject);
    procedure ListBoxRDIIAreasClick(Sender: TObject);
    procedure ComboBoxRainGaugesChange(Sender: TObject);
    procedure ComboBoxEventsChange(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnExport2InterfaceFileClick(Sender: TObject);
    procedure CheckBoxAssignedGaugeClick(Sender: TObject);
    procedure btnEditScenarioClick(Sender: TObject);
    procedure btnEditSewerShedClick(Sender: TObject);
    procedure btnEditRTKsClick(Sender: TObject);
    procedure btnEditRDIIAreaClick(Sender: TObject);
    procedure chkbxAllSewerShedsClick(Sender: TObject);
    procedure chkbxAllRDIIAreaClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnToggleColorsClick(Sender: TObject);
    procedure CheckBoxFreezeTimeClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
    //events: TStormEventCollection;
    //event: TStormEvent;
    iScenarioID, iSewerShedID, iRDIIAreaID, iRaingaugeID, iMeterID: integer;
    sScenarioName, sSewerShedName, sRDIIAreaName, sRaingaugeName, sMeterName: string;
    boDrawing: boolean;
    //area: double;
    procedure UpdateChart;
    procedure LoadUpAllChartsButDontDrawThem;
    procedure fillListBoxSewerSheds;
    procedure SetComboBoxRaingaugesItemIndex(sRainGaugeName: string; boUpdate:boolean);
    procedure fillComboBoxEvents;
  public
    { Public declarations }
  end;

Const
  FLAG_ALL_EVENTS = -99;
  FLAG_ALL_EVENTS_LABEL = '<ALL>';

var
  frmRDIIExport: TfrmRDIIExport;

implementation

uses analysis, moddatabase, mainform, feedbackWithMemo,
      swmm5INPrdiiExporterthread, editscenario, scenariomanager,
      editsewershed, RTKPatternEditor, editcatchment, ExportRDIIHydrographs,
  newscenario;

{$R *.dfm}

procedure TfrmRDIIExport.btnCloseClick(Sender: TObject);
begin
  FrameRDIIGraph1.ClearAll;
  Close;
end;

procedure TfrmRDIIExport.btnEditRDIIAreaClick(Sender: TObject);
begin
//edit selected rdii area
  if ListboxSewerSheds.ItemIndex > -1 then begin
    sSewerShedName := ListBoxSewersheds.Items[ListBoxSewersheds.ItemIndex];
    iSewerShedID := DatabaseModule.GetSewershedIDForName(sSewerShedName);
  end;
  if ListboxRDIIAreas.ItemIndex > -1 then begin
    sRDIIAreaName := ListboxRDIIAreas.Items[ListboxRDIIAreas.ItemIndex];
    iRDIIAreaID := DatabaseModule.GetRDIIAreaIDForName(sRDIIAreaName);
    frmEditCatchment.RDIIAreaName := sRDIIAreaName;
    frmEditCatchment.boAddingNew := false;
    frmEditCatchment.ShowModal;
  end;
end;

procedure TfrmRDIIExport.btnEditRTKsClick(Sender: TObject);
var queryStr: string;
    recSet: _recordSet;
    rtkPatternName: string;
    area: double;
    areaUnitID: integer;
begin
//edit RTK pattern for selected RDIIArea or SewerShed
  if ListBoxRDIIAreas.Count > 0 then begin
    if ListboxRDIIAreas.ItemIndex > -1 then begin
      sRDIIAreaName := ListBoxRDIIAreas.Items[ListBoxRDIIAreas.ItemIndex];
      iRDIIAreaID := DatabaseModule.GetRDIIAreaIDForName(sRDIIAreaName);
//, p.R1, p.T1, p.K1, ' +
//            ' p.R2, p.T2, p.K2, p.R3, p.T3, p.K3, ' +
//            ' p.AI, p.AM, p.AR, ' +

            queryStr := 'SELECT p.RTKPatternName, ' +
            ' a.RDIIAreaName, a.JunctionID, a.Area, a.AreaUnitID ' +
            ' FROM RTKPatterns as p INNER JOIN ' +
            ' (RDIIAreas as a INNER JOIN RTKLinks as l ' +
            ' ON a.RDIIAreaID = l.RDIIAreaID) ' +
            ' ON p.RTKPatternID = l.RTKPatternID ' +
            ' WHERE l.ScenarioID = ' + inttostr(iScenarioID) +
            ' AND l.RDIIAreaID = ' + inttostr(iRDIIAreaID) + ';';

      recSet := CoRecordSet.Create;
      recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
      if not recSet.EOF then
      begin
        try
          recSet.MoveFirst;
  rtkPatternName := recSet.Fields.Item[0].Value;
  frmRTKPatternEditor.AddingNewRecord := false;
  frmRTKpatternEditor.RTKPatternName := rtkPatternName;
  frmRTKpatternEditor.RainGaugeName := sRaingaugeName;
  frmRTKPAtternEditor.StartDate := Floor(StartDatePicker.Date) + Frac(StartTimePicker.Time);
  frmRTKPAtternEditor.EndDate := Floor(EndDatePicker.Date) + Frac(EndTimePicker.Time);
  frmRTKPAtternEditor.UseRainGaugeDates := false;
  area := recSet.Fields.Item[3].Value;
  areaUnitID := recSet.Fields.Item[4].Value;
  frmRTKPAtternEditor.AreaInAcres := area * DatabaseModule.GetConversionFactorForAreaUnitID(areaUnitID);
  frmRTKPatternEditor.ShowModal;
        finally

        end;
      end else begin
        showmessage('No RTK Pattern found for selected RDII Area.');
      end;
    end;
  end else if ListBoxSewerSheds.Items.count > 0 then begin
    if ListboxSewerSheds.ItemIndex > -1 then begin
      sSewerShedName := ListBoxSewerSheds.Items[ListBoxSewerSheds.ItemIndex];
      iSewerShedID := DatabaseModule.GetSewerShedIDForName(sSewerShedName);
//, p.R1, p.T1, p.K1, ' +
//            ' p.R2, p.T2, p.K2, p.R3, p.T3, p.K3, ' +
//            ' p.AI, p.AM, p.AR, ' +
            queryStr := 'SELECT p.RTKPatternName, ' +
            ' a.SewerShedName, a.JunctionID, a.Area, a.AreaUnitID ' +
            ' FROM RTKPatterns as p INNER JOIN ' +
            ' (SewerSheds as a INNER JOIN RTKLinks as l ' +
            ' ON a.SewerShedID = l.SewerShedID) ' +
            ' ON p.RTKPatternID = l.RTKPatternID ' +
            ' WHERE l.ScenarioID = ' + inttostr(iScenarioID) +
            ' AND l.SewerShedID = ' + inttostr(iSewerShedID) + ';';

      recSet := CoRecordSet.Create;
      recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
      if not recSet.EOF then
      begin
        try
          recSet.MoveFirst;
  rtkPatternName := recSet.Fields.Item[0].Value;
  frmRTKPatternEditor.AddingNewRecord := false;
  frmRTKpatternEditor.RTKPatternName := rtkPatternName;
  frmRTKpatternEditor.RainGaugeName := sRaingaugeName;
  frmRTKPAtternEditor.StartDate := Trunc(StartDatePicker.Date) + Frac(StartTimePicker.Time);
  frmRTKPAtternEditor.EndDate := Trunc(EndDatePicker.Date) + Frac(EndTimePicker.Time);
  frmRTKPAtternEditor.UseRainGaugeDates := false;
  area := recSet.Fields.Item[3].Value;
  areaUnitID := recSet.Fields.Item[4].Value;
  frmRTKPAtternEditor.AreaInAcres := area * DatabaseModule.GetConversionFactorForAreaUnitID(areaUnitID);
  frmRTKPatternEditor.ShowModal;
        finally

        end;
      end else begin
        showmessage('No RTK Pattern found for selected Sewershed.');
      end;
    end;
  end;
end;

procedure TfrmRDIIExport.btnEditScenarioClick(Sender: TObject);
begin
//edit selected scenariio
  frmEditScenario.scenarioName := sScenarioName;
  if (Length(sScenarioName) > 0) then begin
    frmEditScenario.ShowModal;
    ScenarioNameComboBoxChange(Sender);
  end else begin
    if ScenarioNameComboBox.Items.Count < 1 then begin
      MessageDlg('You must create a Scenario first.',mtError,[mbok],0);
    end else
      MessageDlg('Please select a Scenario to continue.',mtError,[mbok],0);
  end;

end;

procedure TfrmRDIIExport.btnEditSewerShedClick(Sender: TObject);
begin
//edit selected sewershed
  if ListboxSewerSheds.ItemIndex > -1 then begin
    sSewerShedName := ListBoxSewersheds.Items[ListBoxSewersheds.ItemIndex];
    iSewerShedID := DatabaseModule.GetSewershedIDForName(sSewerShedName);
    frmEditSewershed.sewershedName := sSewerShedName;
    frmEditSewershed.boAddingNew := false;
    frmEditSewershed.ShowModal;
  end;
end;

procedure TfrmRDIIExport.btnExport2RDIISectionsClick(Sender: TObject);
var boAssignedGauges: boolean;
begin
//export the selected RDII hydrographs
  boAssignedGauges := CheckBoxAssignedGauge.Checked;
  OpenDialogSWMM5InpFile.Title :=
    'Please select the SWMM5 Input file to modify.';
  if OpenDialogSWMM5InpFile.Execute then begin
    frmMain.FSWMM5InpFileName := OpenDialogSWMM5InpFile.FileName;
    Savedialog1.FileName := frmMain.FSWMM5InpFileName;
    SaveDialog1.Title :=
      'Please enter the name of the SWMM5 Input file to create.';
    SaveDialog1.Filter := '*.INP|*.INP';
    SaveDialog1.DefaultExt := 'INP';
    if SaveDialog1.Execute then begin
      frmMain.FSWMM5InpFileName2 := SaveDialog1.FileName;
      if (frmMain.FSWMM5InpFileName2 = frmMain.FSWMM5InpFileName) then begin
      end else begin
        frmMain.FScenarioID := iScenarioID;
        frmMain.FRainGaugeName := sRainGaugeName;
        frmMain.FStart := Floor(StartDatePicker.Date) +
          Frac(StartTimePicker.Time);
        frmMain.FEnd := Floor(EndDatePicker.Date) +
          Frac(EndTimePicker.Time);
//        if boAssignedGauges then
//          frmMain.FRainGaugeID := DatabaseModule.getrain
//        else
          frmMain.FRainGaugeID := iRainGaugeID;
        frmMain.FFlowUnitLabel := DatabaseModule.GetFlowUnitLabelForScenario(iScenarioID);
        frmFeedbackWithMemo.Caption := 'SWMM5 Input File RDII HYDROGRAPH Section Export';
        //SWMM5RDIISectionWriterThread.CreateIt;
        SWMM5INPrdiiExporterThrd.CreateIt;
        frmFeedbackWithMemo.OpenForProcessing;
      end;
    end;
  end;

end;

procedure TfrmRDIIExport.btnExportClick(Sender: TObject);
begin
//export to:
// a) RDII Sections of a SWMM5 INP file
// b) SWMM5 Interface file timeseries
// c) Other format (CSV)
  if ScenarioNameComboBox.Items.Count < 1 then begin
    MessageDlg('You must create a Scenario first.',mtError,[mbok],0);
  end else begin
  frmExportRDIIHydrographs.UseAssignedGauge :=
      CheckBoxAssignedGauge.Checked;
  frmExportRDIIHydrographs.ScenarioID := iScenarioID;
  frmExportRDIIHydrographs.RainGaugeID := iRainGaugeID;
  frmExportRDIIHydrographs.StartDate :=
//rm 2007-10-24    StartDatePicker.Date + frac(StartTimePicker.Time);
    Floor(StartDatePicker.Date) + frac(StartTimePicker.Time);
  frmExportRDIIHydrographs.EndDate :=
//rm 2007-10-24    EndDatePicker.Date + frac(EndTimePicker.Time);
    Floor(EndDatePicker.Date) + frac(EndTimePicker.Time);
  frmExportRDIIHydrographs.Showmodal;
  end;
end;

procedure TfrmRDIIExport.btnHelpClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmRDIIExport.btnToggleColorsClick(Sender: TObject);
begin
  frmMain.ToggleChartColors;
  boDrawing := true;
  UpdateChart;
end;

procedure TfrmRDIIExport.btnUpdateClick(Sender: TObject);
begin
  boDrawing := true;
  UpdateChart;
end;

procedure TfrmRDIIExport.btnExport2InterfaceFileClick(Sender: TObject);
var
  inFileName, outFileName, iFaceFileName: string;
  F1, F2, F3: textfile;
  i, j, numareas : integer;
  timeStamp: TDateTime;
  timeStep : TDateTime;
  flowunitlabel: string;
  boAssignedGauges: boolean;
begin
//Export to SWMM5 Interface file
  boAssignedGauges := CheckBoxAssignedGauge.Checked;
  boDrawing := false;
  LoadUpAllChartsButDontDrawThem;
  numareas := FrameRDIIGraph1.NumAreas;
  flowunitlabel := FrameRDIIGraph1.FlowUnitLabel;
  if Length(Trim(flowunitlabel)) < 1 then
    flowunitlabel := 'MGD';  //default is MGD - gives a conversion factor of 1.0
  OpenDialogSWMM5InpFile.Title :=
    'Please select the SWMM5 Input file to modify.';
  if OpenDialogSWMM5InpFile.Execute then begin
    inFileName := OpenDialogSWMM5InpFile.FileName;
    Savedialog1.FileName := frmMain.FSWMM5InpFileName;
    SaveDialog1.Title :=
      'Please enter the name of the SWMM5 Input file to create.';
    SaveDialog1.Filter := '*.INP|*.INP';
    SaveDialog1.DefaultExt := 'INP';
    if SaveDialog1.Execute then begin
      outFileName := SaveDialog1.FileName;
      Savedialog1.FileName := '';
      SaveDialog1.Title :=
        'Please enter the name of the SWMM5 Interface file to create.';
      SaveDialog1.Filter := '*.TXT|*.TXT';
      SaveDialog1.DefaultExt := 'TXT';
      if SaveDialog1.Execute then begin
        iFaceFilename := Savedialog1.FileName;
        AssignFile(F1,inFilename);
        AssignFile(F2,outFilename);
        AssignFile(F3,iFaceFilename);
        Rewrite(F3);
        writeln(F3,'SWMM5');
        writeln(F3,'FROM SSOAP-RDII HYDROGRAPH GENERATION TOOL: Hydrographs' +
          ' for Scenario ' + ScenarioNameComboBox.Text);
        writeln(F3, inttostr(FrameRDIIGraph1.timestep*60));
        writeln(F3, '1');
        writeln(F3, 'FLOW ' + flowUnitLabel);
        writeln(F3, inttostr(FrameRDIIGraph1.numareas));
        for i := 0 to numareas - 1 do begin
          writeln(F3, FrameRDIIGraph1.L[i]);
        end;
        timeStamp := FrameRDIIGraph1.StartDate;
        timeStep := FrameRDIIGraph1.TimeStep / (24 * 60);
        writeln(F3, 'Node Year Mon Day Hr Min Sec Flow');
        for i := 0 to FrameRDIIGraph1.NumTimeSteps - 1 do begin
          for j := 0 to numareas - 1 do begin
            writeln(F3, FrameRDIIGraph1.L[j] +
              FormatDateTime(' yyyy m d h M s ',timeStamp) +
              FormatFloat('0.###',FrameRDIIGraph1.Flow[j,i]));
          end;
          timeStamp := timeStamp + timeStep;
        end;
        CloseFile(F3);
      end;
    end;
  end;
  boDrawing := true;
  UpdateChart;
end;

procedure TfrmRDIIExport.CheckBoxAssignedGaugeClick(Sender: TObject);
var iRGID: integer;
    sRGName: string;
    i: integer;
begin
  boDrawing := true;
  if CheckBoxAssignedGauge.checked then begin
    if iRDIIAreaID > -1 then begin
      iRainGaugeID := DatabaseModule.GetRainGaugeIDforRDIIAreaID(iRDIIAreaID);
      sRainGaugeName := DatabaseModule.GetRaingaugeNameForID(iRainGaugeID);
      SetComboBoxRaingaugesItemIndex(sRainGaugeName, false);
    end else if iSewerShedID > -1 then begin
      iRainGaugeID := DatabaseModule.GetRainGaugeIDforSewershedID(iSewerShedID);
      sRainGaugeName := DatabaseModule.GetRaingaugeNameForID(iRainGaugeID);
      SetComboBoxRaingaugesItemIndex(sRainGaugeName, false);
    end;
  end;
//  UpdateChart;
//set the raingauge to the one assigned to the selected subarea
(*
  if CheckBoxAssignedGauge.checked then begin
    iRGID := DatabaseModule.GetRainGaugeIDforSewershedID(iSewerShedID);
    sRGName := DatabaseModule.GetRaingaugeNameForID(iRGID);
    try
      //ComboBoxRainGauges.Text := sRGName;
      //ComboBoxRainGaugesChange(Self);
      i := 0;
      repeat
        if (UpperCase(ComboBoxRainGauges.Items[i]) = UpperCase(sRGName)) then
          ComboboxRainGauges.ItemIndex := i;
        inc(i);
      until i = ComboBoxRainGauges.Items.Count;
      //ComboBoxRainGauges.Text := sRGName;
      ComboBoxRainGaugesChange(CheckBoxAssignedGauge);
    finally

    end;
  end else begin

  end;
*)
end;

procedure TfrmRDIIExport.CheckBoxFreezeTimeClick(Sender: TObject);
var bo: boolean;
begin
  bo := not CheckBoxFreezeTime.Checked;
  StartDatePicker.Enabled := bo;
  StartTimePicker.Enabled := bo;
  EndDatePicker.Enabled := bo;
  EndTimePicker.Enabled := bo;
end;

procedure TfrmRDIIExport.chkbxAllRDIIAreaClick(Sender: TObject);
begin
//  chkbxAllRDIIArea.Checked := not chkbxAllRDIIArea.Checked;
  UpdateChart;
end;

procedure TfrmRDIIExport.chkbxAllSewerShedsClick(Sender: TObject);
begin
//  chkbxAllSewerSheds.Checked := not chkbxAllSewerSheds.Checked;
  UpdateChart;
end;

procedure TfrmRDIIExport.ComboBoxEventsChange(Sender: TObject);
var
  idx:integer;
  sStart, sEnd: string;
  startdate, enddate: TDateTime;
begin
//change event
//parse the comboboxevents.text to startdate and enddate
//unless flag set to entire record for raingauge
//then get start and end by raingaugeid
  if ((ListBoxSewerSheds.Count > 0) or (ListBoxRDIIAreas.Count > 0)) then begin
    idx := Pos(' to ', ComboBoxEvents.Text);
    if idx > 0 then begin
      sStart := copy(ComboBoxEvents.Text, 1, idx-1);
      sEnd := copy(ComboBoxEvents.Text, idx + 4, 10000);
      startdate := StrToDateTime(sStart);
      enddate   := StrToDateTime(sEnd);
    end else if ComboBoxEvents.Text = FLAG_ALL_EVENTS_LABEL then begin
      DatabaseModule.GetExtremeRainfallDateTimesBetweenDates( iRainGaugeID,
        0, 1000000, startdate, enddate);
        //event.StartDate := startdate;
        //event.EndDate   := enddate;
    end;
    if not CheckBoxFreezeTime.checked then begin
      //rm 2009-06-08 - trap error if no valid rainfall dates
      try
        StartDatePicker.Date := startdate;
        StartTimePicker.Time := startdate;
        EndDatePicker.Date := enddate;
        EndTimePicker.Time := enddate;
        //showmessage('start = ' + DateTimeToStr(event.StartDate) );
        //showmessage('end = ' +  DateTimeToStr(event.EndDate) );
        UpdateChart;
      except
        on E: Exception do begin
          MessageDlg('There was an error setting start and end dates for rainfall.',
            mtError,[mbok],0);
        end;
      end;
    end;
  end;
end;

procedure TfrmRDIIExport.ComboBoxRainGaugesChange(Sender: TObject);
begin
  FrameRDIIGraph1.ClearAll;
//set up the events combobox
 if ((ListBoxSewerSheds.Count > 0) or (ListBoxRDIIAreas.Count > 0)) then begin
  sRaingaugeName := ComboBoxRainGauges.Text;
  iRainGaugeID := DatabaseModule.GetRainGaugeIDforName(sRaingaugeName);
  fillComboBoxEvents;
{
  if ComboBoxEvents.Items.Count > 1 then begin
    ComboBoxEvents.ItemIndex := 1;
    ComboBoxEventsChange(Sender);
  end else if ComboBoxEvents.Items.Count > 0 then begin
    ComboBoxEvents.ItemIndex := 0;
    ComboBoxEventsChange(Sender);
  end else begin
    ComboBoxEvents.ItemIndex := -1;
  end;
}
  if not (Sender = CheckBoxAssignedGauge) then begin
    CheckBoxAssignedGauge.Checked := false;
  end;
  UpdateChart;
 end;
end;

procedure TfrmRDIIExport.fillComboBoxEvents;
var
    queryStr: string;
    recSet:   _recordSet;
begin
{
SELECT Events.StartDateTime, Events.EndDateTime
FROM Raingauges INNER JOIN
(Analyses INNER JOIN Events
ON Analyses.AnalysisID = Events.AnalysisID)
ON Raingauges.RaingaugeID = Analyses.RainGaugeID
Where RainGauges.RainGaugeID = 10;
}
  ComboBoxEvents.Clear;
  //add a placeholder for the entire record set for this raingauge
  ComboBoxEvents.Items.Add('<ALL>');
  queryStr := 'SELECT distinct e.StartDateTime, e.EndDateTime ' +
              ' FROM Raingauges as r INNER JOIN ' +
              ' (Analyses as a INNER JOIN Events as e ' +
              ' ON a.AnalysisID = e.AnalysisID) ' +
              ' ON r.RaingaugeID = a.RainGaugeID ' +
              ' Where r.RainGaugeID = ' +
              inttostr(iRaingaugeID);
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if not recSet.EOF then
  begin
    try
      recSet.MoveFirst;
      while not recSet.EOF do begin
        ComboBoxEvents.Items.Add(
          DateTimetostr(recSet.Fields.Item[0].Value) + ' to ' +
          DateTimetostr(recSet.Fields.Item[1].Value));
        recSet.MoveNext;
      end;
    finally
      recSet.Close;
    end;
  end;
  if ComboBoxEvents.Items.Count > 1 then begin
    ComboBoxEvents.ItemIndex := 1;
    ComboBoxEventsChange(Self);
  end else if ComboBoxEvents.Items.Count > 0 then begin
    ComboBoxEvents.ItemIndex := 0;
    ComboBoxEventsChange(Self);
  end;
end;

procedure TfrmRDIIExport.fillListBoxSewerSheds;
var
    queryStr: string;
    recSet:   _recordSet;
begin
{
SELECT distinct Sewersheds.SewershedName, Sewersheds.Area
FROM Sewersheds INNER JOIN
(Scenarios INNER JOIN RTKLinks ON Scenarios.ScenarioID = RTKLinks.ScenarioID)
ON Sewersheds.SewershedID = RTKLinks.SewershedID
where Scenarios.ScenarioID = 1;
}
  ListBoxSewerSheds.Clear;
  queryStr := 'SELECT distinct a.SewershedName, a.Area ' +
              ' FROM SewerSheds as a INNER JOIN ' +
              ' (Scenarios as b INNER JOIN RTKLinks as c ' +
              ' ON b.ScenarioID = c.ScenarioID) ' +
              ' ON a.SewershedID = c.SewershedID ' +
              ' WHERE (b.ScenarioID = ' + inttostr(iScenarioID) + ');';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if not recSet.EOF then
  begin
    try
      recSet.MoveFirst;
      while not recSet.EOF do begin
        //ListBoxSewerSheds.Items.Add(recSet.Fields.Item[0].Value + ', ' + floattostr(recSet.Fields.Item[1].Value));
        ListBoxSewerSheds.Items.Add(recSet.Fields.Item[0].Value);
        recSet.MoveNext;
      end;
    finally
      recSet.Close;
    end;
  end;
  ListBoxRDIIAreas.Clear;
  queryStr := 'SELECT distinct a.RDIIAreaName, a.Area ' +
              ' FROM RDIIAreas as a INNER JOIN ' +
              ' (Scenarios as b INNER JOIN RTKLinks as c ' +
              ' ON b.ScenarioID = c.ScenarioID) ' +
              ' ON a.RDIIAreaID = c.RDIIAreaID ' +
              ' WHERE (b.ScenarioID = ' + inttostr(iScenarioID) + ');';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if not recSet.EOF then
  begin
    try
      recSet.MoveFirst;
      while not recSet.EOF do begin
        //ListBoxSewerSheds.Items.Add(recSet.Fields.Item[0].Value + ', ' + floattostr(recSet.Fields.Item[1].Value));
        ListBoxRDIIAreas.Items.Add(recSet.Fields.Item[0].Value);
        recSet.MoveNext;
      end;
    finally
      recSet.Close;
    end;
  end;

  if ListBoxSewerSheds.Items.Count > 0 then begin
    ListBoxSewersheds.ItemIndex := 0;
    ListBoxSewerShedsClick(Self);
  end else if ListBoxRDIIAreas.Items.Count > 0 then begin
    ListBoxRDIIAreas.ItemIndex := 0;
    ListBoxRDIIAreasClick(Self);
//    ListBoxRDIIAreas.Clear;
  end;
end;

procedure TfrmRDIIExport.FormResize(Sender: TObject);
begin
  FrameRDIIGraph1.Width := Self.ClientWidth - FrameRDIIGraph1.Left - 4;
  FrameRDIIGraph1.Height := Self.ClientHeight - 2 * FrameRDIIGraph1.Top;
  FrameRDIIGraph1.FrameResize(Sender);

end;

procedure TfrmRDIIExport.FormShow(Sender: TObject);
begin
  //event := TStormEvent.Create;
  iRDIIAreaID := -1;
  iSewerShedID := -1;
  boDrawing := false;
  ComboBoxRaingauges.Items := DatabaseModule.GetRaingaugeNames;
  if ComboBoxRaingauges.Items.Count < 1 then
    MessageDlg('You cannot export RDII hydrographs without a rain gauge.',mtError,[mbok],0);

  ScenarioNameComboBox.Items := DatabaseModule.GetScenarioNames();
  if ScenarioNameComboBox.Items.Count < 1 then begin
    MessageDlg('You must create a Scenario before you can export hydrographs.',mtError,[mbok],0);
    frmAddNewScenario.ShowModal;
    ScenarioNameComboBox.Items := DatabaseModule.GetScenarioNames();
  end;
  ScenarioNameComboBox.ItemIndex := 0;
  ScenarioNameComboBoxChange(Sender);

  if comboboxRaingauges.Items.Count > 0 then begin
    comboboxraingauges.ItemIndex := 0;
    ComboBoxRainGaugesChange(self);
    btnExport.Enabled := true;
    btnUpdate.Enabled := true;
    boDrawing := true;
    UpdateChart;
  end else begin
    btnExport.Enabled := false;
    btnUpdate.Enabled := false;
    boDrawing := false;
  end;
  //ListBoxSewersheds.Items := DatabaseModule.GetSewershedNames;
  //ListBoxSewersheds.ItemIndex := 0;
  //ListBoxSewerShedsClick(Sender);

end;

procedure TfrmRDIIExport.ListBoxRDIIAreasClick(Sender: TObject);
begin
  FrameRDIIGraph1.ClearAll;
  if ListBoxRDIIAreas.ItemIndex > -1 then begin
    sRDIIAreaName := ListBoxRDIIAreas.Items[ListBoxRDIIAreas.ItemIndex];
    iRDIIAreaID := DatabaseModule.GetRDIIAreaIDForName(sRDIIAreaName);
    if CheckBoxAssignedGauge.Checked then begin
      iRainGaugeID := DatabaseModule.GetRainGaugeIDforRDIIAreaID(iRDIIAreaID);
      sRainGaugeName := DatabaseModule.GetRaingaugeNameForID(iRainGaugeID);
      SetComboBoxRaingaugesItemIndex(sRainGaugeName, false);
    end;
    if (not chkbxAllRDIIArea.checked) and (Length(sRainGaugeName) > 0) then UpdateChart;

    //area := DatabaseModule.GetRDIIAreaArea(iRDIIAreaID);
    //iRainGaugeID := DatabaseModule.GetRainGaugeIDforRDIIAreaID(iRDIIAreaID);
    //sRainGaugeName := DatabaseModule.GetRaingaugeNameForID(iRainGaugeID);
    //SetComboBoxRaingaugesItemIndex(sRainGaugeName);
  end else begin
    iRDiiAreaID := -1;
  end;
end;

procedure TfrmRDIIExport.ListBoxSewerShedsClick(Sender: TObject);
begin
  FrameRDIIGraph1.ClearAll;
  if ListBoxSewersheds.ItemIndex > -1 then begin

    sSewerShedName := ListBoxSewersheds.Items[ListBoxSewersheds.ItemIndex];
    iSewerShedID := DatabaseModule.GetSewershedIDForName(sSewerShedName);

(*
//    ListBoxRDIIAreas.Items := DatabaseModule.GetRDIIAreaNamesforSewershedID(iSewerShedID);
    ListBoxRDIIAreas.Items := DatabaseModule.GetRDIIAreaNamesforSewershedIDandScenarioID(iSewerShedID,iScenarioID);
    if ListBoxRDIIAreas.Items.Count > 0 then begin
      ListBoxRDIIAreas.ItemIndex := 0;
      ListBoxRDIIAreasClick(Sender);
      if (chkbxAllRDIIArea.checked) and (Length(sRainGaugeName) > 0) then UpdateChart;
    end else begin
*)
      ListBoxRDIIAreas.ItemIndex := -1;
      iRDIIAreaID := -1;
      if CheckBoxAssignedGauge.Checked then begin
        iRainGaugeID := DatabaseModule.GetRainGaugeIDforSewershedID(iSewerShedID);
        sRainGaugeName := DatabaseModule.GetRaingaugeNameForID(iRainGaugeID);
        SetComboBoxRaingaugesItemIndex(sRainGaugeName, false);
      end;
      if (not chkbxAllSewerSheds.checked) and (Length(sRainGaugeName) > 0) then UpdateChart;
//    end;
  end else begin
    iSewerShedID := -1;
  end;
  btnEditRDIIArea.Enabled := (ListBoxRDIIAreas.Count > 0);
end;

procedure TfrmRDIIExport.ScenarioNameComboBoxChange(Sender: TObject);
begin
  FrameRDIIGraph1.ClearAll;
  sScenarioName := ScenarioNameComboBox.Text;
  iScenarioID := DatabaseModule.GetScenarioIDForName(sScenarioName);
  scenarioDescription.Text := DatabaseModule.GetScenarioDesciption(sScenarioName);
  fillListBoxSewerSheds;
  if ((ListBoxSewerSheds.Count < 1) and (ListBoxRDIIAreas.Count < 1)) then
    messagedlg('There are no sewersheds / rdii areas associated with the selected Scenario',
      mtInformation,[mbok],0);
  btnEditSewerShed.Enabled := (ListBoxSewerSheds.Count > 0);
  btnEditRDIIArea.Enabled := (ListBoxRDIIAreas.Count > 0);
end;

procedure TfrmRDIIExport.SetComboBoxRaingaugesItemIndex(sRainGaugeName: string; boUpdate:boolean);
var idx: integer;
begin
  idx := -1;
  Repeat
    inc(idx);
  Until (idx = ComboBoxRaingauges.Items.Count)
    or (ComboBoxRaingauges.Items[idx] = sRainGaugeName);
  if (idx < ComboBoxRaingauges.Items.Count) then begin
    ComboBoxRaingauges.ItemIndex := idx;
    // if boUpdate then
      ComboBoxRainGaugesChange(CheckBoxAssignedGauge);
  end else begin
    ComboBoxRaingauges.ItemIndex := -1;
  end;
end;

procedure TfrmRDIIExport.LoadUpAllChartsButDontDrawThem;
var
  i, j, k, idx, num: integer;
  area, KTmax: double;
    queryStr: string;
    recSet:   _recordSet;
    boUseAssignedRainGauge:boolean;
begin
  boUseAssignedRainGauge := CheckBoxAssignedGauge.Checked;
  boDrawing := false;
  num := 0;
  k := 0;
  KTMax := 0;
  for j := 0 to ListBoxSewerSheds.Count - 1 do begin
    ListboxSewerSheds.ItemIndex := j;
    ListBoxSewerShedsClick(Self);
    if ListBoxRDIIAreas.Items.Count > 0 then
      num := num + ListBoxRDIIAreas.Items.Count
    else
      num := num + 1;
  end;
  FrameRDIIGraph1.NumAreas := num;
  //FrameRDIIGraph1.Title := 'Sewersheds for Scenario ' +
  //    ScenarioNameComboBox.Text;
  for j := 0 to ListBoxSewerSheds.Count - 1 do begin
    ListboxSewerSheds.ItemIndex := j;
    ListBoxSewerShedsClick(Self);
    if ListBoxRDIIAreas.Items.Count > 0 then begin
      for i := 0 to ListBoxRDIIAreas.Count - 1 do begin
        FrameRDIIGraph1.S[k] := ListBoxRDIIAreas.Items[i];
        idx := DatabaseModule.GetRDIIAreaIDForName(ListBoxRDIIAreas.Items[i]);
        area := DatabaseModule.GetRDIIAreaArea(idx);
        FrameRDIIGraph1.A[k] := area;
        FrameRDIIGraph1.L[k] := DatabaseModule.GetJunctionIDforRDIIAreaID(idx);
        //now load up all the RTKs for this RDIIArea / Scenario
        //select the RTKPatternIDs from RTKLinks
        //where ScenarioID = iScenarioID
        //and RDIIAreaID = idx
        queryStr := 'SELECT p.RTKPatternName, p.R1, p.T1, p.K1, ' +
              ' p.R2, p.T2, p.K2, p.R3, p.T3, p.K3, ' +
              ' p.AI, p.AM, p.AR, ' +
              ' a.RDIIAreaName, a.JunctionID, a.RainGaugeID, ' +
//rm 2010-10-05
              ' p.AI2, p.AM2, p.AR2, p.AI3, p.AM3, p.AR3 ' +
              ' FROM RTKPatterns as p INNER JOIN ' +
              ' (RDIIAreas as a INNER JOIN RTKLinks as l ' +
              ' ON a.RDIIAreaID = l.RDIIAreaID) ' +
              ' ON p.RTKPatternID = l.RTKPatternID ' +
              ' WHERE l.ScenarioID = ' + inttostr(iScenarioID) +
              ' AND l.RDIIAreaID = ' + inttostr(idx) + ';';
        recSet := CoRecordSet.Create;
        recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
        if not recSet.EOF then
        begin
          try
            recSet.MoveFirst;
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
            if boUseAssignedRainGauge then begin
              if VarIsNull(recSet.Fields.Item[15].Value) then
                //do nothing FrameRDIIGraph1.G[k] := ;
              else
                FrameRDIIGraph1.G[k] := recSet.Fields.Item[15].Value;
            end;
            if VarIsNull(recSet.Fields.Item[16].Value) then
              FrameRDIIGraph1.AI[1,k] := 0.0
            else
              FrameRDIIGraph1.AI[1,k] := recSet.Fields.Item[16].Value;
            if VarIsNull(recSet.Fields.Item[17].Value) then
              FrameRDIIGraph1.AM[1,k] := 0.0
            else
              FrameRDIIGraph1.AM[1,k] := recSet.Fields.Item[17].Value;
            if VarIsNull(recSet.Fields.Item[18].Value) then
              FrameRDIIGraph1.AR[1,k] := 0.0
            else
              FrameRDIIGraph1.AR[1,k] := recSet.Fields.Item[18].Value;

            if VarIsNull(recSet.Fields.Item[19].Value) then
              FrameRDIIGraph1.AI[2,k] := 0.0
            else
              FrameRDIIGraph1.AI[2,k] := recSet.Fields.Item[19].Value;
            if VarIsNull(recSet.Fields.Item[20].Value) then
              FrameRDIIGraph1.AM[2,k] := 0.0
            else
              FrameRDIIGraph1.AM[2,k] := recSet.Fields.Item[20].Value;
            if VarIsNull(recSet.Fields.Item[21].Value) then
              FrameRDIIGraph1.AR[2,k] := 0.0
            else
              FrameRDIIGraph1.AR[2,k] := recSet.Fields.Item[21].Value;

          finally
            recSet.Close;
          end;
        end;
        inc(k);
      end;
    end else begin
      i := j;
        FrameRDIIGraph1.S[k] := ListBoxSewerSheds.Items[i];
        idx := DatabaseModule.GetSewerShedIDForName(ListBoxSewerSheds.Items[i]);
        area := DatabaseModule.GetSewerShedArea(idx);
        FrameRDIIGraph1.A[k] := area;
        FrameRDIIGraph1.L[k] := DatabaseModule.GetJunctionIDforSewerShedID(idx);
        //now load up all the RTKs for this SewerShed / Scenario
        //select the RTKPatternIDs from RTKLinks
        //where ScenarioID = iScenarioID
        //and SewerShedID = idx
        queryStr := 'SELECT p.RTKPatternName, p.R1, p.T1, p.K1, ' +
              ' p.R2, p.T2, p.K2, p.R3, p.T3, p.K3, ' +
              ' p.AI, p.AM, p.AR, ' +
              ' a.SewerShedName, a.JunctionID, a.RainGaugeID, ' +
//rm 2010-10-05
              ' p.AI2, p.AM2, p.AR2, p.AI3, p.AM3, p.AR3 ' +
              ' FROM RTKPatterns as p INNER JOIN ' +
              ' (SewerSheds as a INNER JOIN RTKLinks as l ' +
              ' ON a.SewerShedID = l.SewerShedID) ' +
              ' ON p.RTKPatternID = l.RTKPatternID ' +
              ' WHERE l.ScenarioID = ' + inttostr(iScenarioID) +
              ' AND l.SewerShedID = ' + inttostr(idx) + ';';
        recSet := CoRecordSet.Create;
        recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
        if not recSet.EOF then
        begin
          try
            recSet.MoveFirst;
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
            if boUseAssignedRainGauge then begin
              if VarIsNull(recSet.Fields.Item[15].Value) then
                //do nothing FrameRDIIGraph1.G[k] := ;
              else
                FrameRDIIGraph1.G[k] := recSet.Fields.Item[15].Value;
            end;

            if VarIsNull(recSet.Fields.Item[16].Value) then
              FrameRDIIGraph1.AI[1,k] := 0.0
            else
              FrameRDIIGraph1.AI[1,k] := recSet.Fields.Item[16].Value;
            if VarIsNull(recSet.Fields.Item[17].Value) then
              FrameRDIIGraph1.AM[1,k] := 0.0
            else
              FrameRDIIGraph1.AM[1,k] := recSet.Fields.Item[17].Value;
            if VarIsNull(recSet.Fields.Item[18].Value) then
              FrameRDIIGraph1.AR[1,k] := 0.0
            else
              FrameRDIIGraph1.AR[1,k] := recSet.Fields.Item[18].Value;

            if VarIsNull(recSet.Fields.Item[19].Value) then
              FrameRDIIGraph1.AI[2,k] := 0.0
            else
              FrameRDIIGraph1.AI[2,k] := recSet.Fields.Item[19].Value;
            if VarIsNull(recSet.Fields.Item[20].Value) then
              FrameRDIIGraph1.AM[2,k] := 0.0
            else
              FrameRDIIGraph1.AM[2,k] := recSet.Fields.Item[20].Value;
            if VarIsNull(recSet.Fields.Item[21].Value) then
              FrameRDIIGraph1.AR[2,k] := 0.0
            else
              FrameRDIIGraph1.AR[2,k] := recSet.Fields.Item[21].Value;


          finally
            recSet.Close;
          end;
        end;
        inc(k);
      end;
  end;
  if num > 0 then begin
    Screen.Cursor := crHourglass;
    try
      FrameRDIIGraph1.StartDate :=
          StartDatePicker.Date + frac(StartTimePicker.Time);
      FrameRDIIGraph1.EndDate :=
          EndDatePicker.Date + frac(EndTimePicker.Time) +
            FrameRDIIGraph1.KTMax;
      if not boUseAssignedRainGauge then FrameRDIIGraph1.RainGaugeName := sRaingaugeName;
      FrameRDIIGraph1.FlowUnitLabel := DatabaseModule.GetFlowUnitLabelForScenario(iScenarioID);
      FrameRDIIGraph1.UpdateData;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmRDIIExport.UpdateChart;
var
  i, idx, num: integer;
  area, KTmax: double;
    queryStr: string;
    recSet:   _recordSet;
    boUseAssignedRainGauge:boolean;

begin
  if not boDrawing then exit;
  boUseAssignedRainGauge := CheckBoxAssignedGauge.Checked;
  FrameRDIIGraph1.ClearAll;
  num := 0;
  KTMax := 0;
  if ((ListBoxRDIIAreas.Items.Count > 0)  and (iRDIIAreaID > -1)) then begin
    if chkbxAllRDIIArea.Checked then
      num := ListBoxRDIIAreas.Items.Count
    else
      num := 1;
    FrameRDIIGraph1.NumAreas := num;
    if ListBoxRDIIAreas.ItemIndex < 0 then ListBoxRDIIAreas.ItemIndex := 0;
    FrameRDIIGraph1.Title := 'RDII Hydrograph for RDII Area ' +
        ListBoxRDIIAreas.Items[ListBoxRDIIAreas.ItemIndex];
    for i := 0 to num - 1 do begin
      if chkbxAllRDIIArea.Checked then begin
        FrameRDIIGraph1.S[i] := ListBoxRDIIAreas.Items[i];
        idx := DatabaseModule.GetRDIIAreaIDForName(ListBoxRDIIAreas.Items[i]);
      end else begin
        if ListBoxRDIIAreas.ItemIndex < 0 then ListBoxRDIIAreas.ItemIndex := 0;
        FrameRDIIGraph1.S[i] := ListBoxRDIIAreas.Items[ListBoxRDIIAreas.ItemIndex];
        idx := DatabaseModule.GetRDIIAreaIDForName(ListBoxRDIIAreas.Items[ListBoxRDIIAreas.ItemIndex]);
      end;
      area := DatabaseModule.GetRDIIAreaArea(idx);
      FrameRDIIGraph1.A[i] := area;
      FrameRDIIGraph1.L[i] := DatabaseModule.GetJunctionIDforRDIIAreaID(idx);
      //now load up all the RTKs for this RDIIArea / Scenario
      //select the RTKPatternIDs from RTKLinks
      //where ScenarioID = iScenarioID
      //and RDIIAreaID = idx
      queryStr := 'SELECT p.RTKPatternName, p.R1, p.T1, p.K1, ' +
            ' p.R2, p.T2, p.K2, p.R3, p.T3, p.K3, ' +
            ' p.AI, p.AM, p.AR, ' +
            ' a.RDIIAreaName, a.JunctionID, a.RainGaugeID, ' +
//rm 2010-10-05
            ' p.AI2, p.AM2, p.AR2, p.AI3, p.AM3, p.AR3 ' +
            ' FROM RTKPatterns as p INNER JOIN ' +
            ' (RDIIAreas as a INNER JOIN RTKLinks as l ' +
            ' ON a.RDIIAreaID = l.RDIIAreaID) ' +
            ' ON p.RTKPatternID = l.RTKPatternID ' +
            ' WHERE l.ScenarioID = ' + inttostr(iScenarioID) +
            ' AND l.RDIIAreaID = ' + inttostr(idx) + ';';
      recSet := CoRecordSet.Create;
      recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
      if not recSet.EOF then
      begin
        try
          recSet.MoveFirst;
          FrameRDIIGraph1.R[0,i] := recSet.Fields.Item[1].Value;
          FrameRDIIGraph1.T[0,i] := recSet.Fields.Item[2].Value;
          FrameRDIIGraph1.K[0,i] := recSet.Fields.Item[3].Value;
          FrameRDIIGraph1.R[1,i] := recSet.Fields.Item[4].Value;
          FrameRDIIGraph1.T[1,i] := recSet.Fields.Item[5].Value;
          FrameRDIIGraph1.K[1,i] := recSet.Fields.Item[6].Value;
          FrameRDIIGraph1.R[2,i] := recSet.Fields.Item[7].Value;
          FrameRDIIGraph1.T[2,i] := recSet.Fields.Item[8].Value;
          FrameRDIIGraph1.K[2,i] := recSet.Fields.Item[9].Value;
{
//rm 2010-10-05
          if VarIsNull(recSet.Fields.Item[10].Value) then
            FrameRDIIGraph1.AI[i] := 0.0
          else
            FrameRDIIGraph1.AI[i] := recSet.Fields.Item[10].Value;
          if VarIsNull(recSet.Fields.Item[11].Value) then
            FrameRDIIGraph1.AM[i] := 0.0
          else
            FrameRDIIGraph1.AM[i] := recSet.Fields.Item[11].Value;
          if VarIsNull(recSet.Fields.Item[12].Value) then
            FrameRDIIGraph1.AR[i] := 0.0
          else
            FrameRDIIGraph1.AR[i] := recSet.Fields.Item[12].Value;
}
          if VarIsNull(recSet.Fields.Item[10].Value) then
            FrameRDIIGraph1.AI[0,i] := 0.0
          else
            FrameRDIIGraph1.AI[0,i] := recSet.Fields.Item[10].Value;
          if VarIsNull(recSet.Fields.Item[11].Value) then
            FrameRDIIGraph1.AM[0,i] := 0.0
          else
            FrameRDIIGraph1.AM[0,i] := recSet.Fields.Item[11].Value;
          if VarIsNull(recSet.Fields.Item[12].Value) then
            FrameRDIIGraph1.AR[0,i] := 0.0
          else
            FrameRDIIGraph1.AR[0,i] := recSet.Fields.Item[12].Value;

          FrameRDIIGraph1.S[i] := recSet.Fields.Item[13].Value;
          FrameRDIIGraph1.L[i] := recSet.Fields.Item[14].Value;
//          if boUseAssignedRainGauge then begin
//            if VarIsNull(recSet.Fields.Item[15].Value) then
//              //do nothing FrameRDIIGraph1.G[k] := ;
//            else
//              FrameRDIIGraph1.G[i] := recSet.Fields.Item[15].Value;
//          end;
          if VarIsNull(recSet.Fields.Item[16].Value) then
            FrameRDIIGraph1.AI[1,i] := 0.0
          else
            FrameRDIIGraph1.AI[1,i] := recSet.Fields.Item[16].Value;
          if VarIsNull(recSet.Fields.Item[17].Value) then
            FrameRDIIGraph1.AM[1,i] := 0.0
          else
            FrameRDIIGraph1.AM[1,i] := recSet.Fields.Item[17].Value;
          if VarIsNull(recSet.Fields.Item[18].Value) then
            FrameRDIIGraph1.AR[1,i] := 0.0
          else
            FrameRDIIGraph1.AR[1,i] := recSet.Fields.Item[18].Value;

          if VarIsNull(recSet.Fields.Item[19].Value) then
            FrameRDIIGraph1.AI[2,i] := 0.0
          else
            FrameRDIIGraph1.AI[2,i] := recSet.Fields.Item[19].Value;
          if VarIsNull(recSet.Fields.Item[20].Value) then
            FrameRDIIGraph1.AM[2,i] := 0.0
          else
            FrameRDIIGraph1.AM[2,i] := recSet.Fields.Item[20].Value;
          if VarIsNull(recSet.Fields.Item[21].Value) then
            FrameRDIIGraph1.AR[2,i] := 0.0
          else
            FrameRDIIGraph1.AR[2,i] := recSet.Fields.Item[21].Value;

        finally
          recSet.Close;
        end;
      end;
    end;
  end else if ListBoxSewerSheds.Items.Count > 0 then begin
    if chkbxAllSewerSheds.Checked then
      num := ListBoxSewerSheds.Items.Count
    else
      num := 1;
    FrameRDIIGraph1.NumAreas := num;
    if ListBoxSewerSheds.ItemIndex < 0 then ListBoxSewerSheds.ItemIndex := 0;
    FrameRDIIGraph1.Title := 'RDII Hydrograph for ' +
        ListBoxSewerSheds.Items[ListBoxSewerSheds.ItemIndex];
    for i := 0 to num - 1 do begin
      if chkbxAllSewerSheds.Checked then begin
        FrameRDIIGraph1.S[i] := ListBoxSewerSheds.Items[i];
        idx := DatabaseModule.GetSewershedIDForName(ListBoxSewerSheds.Items[i]);
      end else begin
        if ListBoxSewerSheds.ItemIndex < 0 then ListBoxSewerSheds.ItemIndex := 0;
        FrameRDIIGraph1.S[i] := ListBoxSewerSheds.Items[ListBoxSewerSheds.ItemIndex];
        idx := DatabaseModule.GetSewershedIDForName(ListBoxSewerSheds.Items[ListBoxSewerSheds.ItemIndex]);
      end;
      area := DatabaseModule.GetSewerShedArea(idx);
      FrameRDIIGraph1.A[i] := area;
      FrameRDIIGraph1.L[i] := DatabaseModule.GetJunctionIDforSewerShedID(idx);
      queryStr := 'SELECT p.RTKPatternName, p.R1, p.T1, p.K1, ' +
            ' p.R2, p.T2, p.K2, p.R3, p.T3, p.K3, ' +
            ' p.AI, p.AM, p.AR, ' +
            ' a.SewershedName, a.JunctionID, a.RainGaugeID, ' +
//rm 2010-10-05
            ' p.AI2, p.AM2, p.AR2, p.AI3, p.AM3, p.AR3 ' +
            ' FROM RTKPatterns as p INNER JOIN ' +
            ' (SewerSheds as a INNER JOIN RTKLinks as l ' +
            ' ON a.SewerShedID = l.SewerShedID) ' +
            ' ON p.RTKPatternID = l.RTKPatternID ' +
            ' WHERE l.ScenarioID = ' + inttostr(iScenarioID) +
            ' AND l.SewerShedID = ' + inttostr(idx) + ';';
      recSet := CoRecordSet.Create;
      recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
      if not recSet.EOF then
      begin
        try
          recSet.MoveFirst;
          FrameRDIIGraph1.R[0,i] := recSet.Fields.Item[1].Value;
          FrameRDIIGraph1.T[0,i] := recSet.Fields.Item[2].Value;
          FrameRDIIGraph1.K[0,i] := recSet.Fields.Item[3].Value;
          FrameRDIIGraph1.R[1,i] := recSet.Fields.Item[4].Value;
          FrameRDIIGraph1.T[1,i] := recSet.Fields.Item[5].Value;
          FrameRDIIGraph1.K[1,i] := recSet.Fields.Item[6].Value;
          FrameRDIIGraph1.R[2,i] := recSet.Fields.Item[7].Value;
          FrameRDIIGraph1.T[2,i] := recSet.Fields.Item[8].Value;
          FrameRDIIGraph1.K[2,i] := recSet.Fields.Item[9].Value;
{
//rm 2010-10-05
          if VarIsNull(recSet.Fields.Item[10].Value) then
            FrameRDIIGraph1.AI[i] := 0.0
          else
            FrameRDIIGraph1.AI[i] := recSet.Fields.Item[10].Value;
          if VarIsNull(recSet.Fields.Item[11].Value) then
            FrameRDIIGraph1.AM[i] := 0.0
          else
            FrameRDIIGraph1.AM[i] := recSet.Fields.Item[11].Value;
          if VarIsNull(recSet.Fields.Item[12].Value) then
            FrameRDIIGraph1.AR[i] := 0.0
          else
            FrameRDIIGraph1.AR[i] := recSet.Fields.Item[12].Value;
}
          if VarIsNull(recSet.Fields.Item[10].Value) then
            FrameRDIIGraph1.AI[0,i] := 0.0
          else
            FrameRDIIGraph1.AI[0,i] := recSet.Fields.Item[10].Value;
          if VarIsNull(recSet.Fields.Item[11].Value) then
            FrameRDIIGraph1.AM[0,i] := 0.0
          else
            FrameRDIIGraph1.AM[0,i] := recSet.Fields.Item[11].Value;
          if VarIsNull(recSet.Fields.Item[12].Value) then
            FrameRDIIGraph1.AR[0,i] := 0.0
          else
            FrameRDIIGraph1.AR[0,i] := recSet.Fields.Item[12].Value;

          FrameRDIIGraph1.S[i] := recSet.Fields.Item[13].Value;
          if varisnull(recSet.Fields.Item[14].Value) then
            FrameRDIIGraph1.L[i] := ''
          else
            FrameRDIIGraph1.L[i] := recSet.Fields.Item[14].Value;
//          if boUseAssignedRainGauge then begin
//            if VarIsNull(recSet.Fields.Item[15].Value) then
//              //do nothing FrameRDIIGraph1.G[k] := ;
//            else
//              FrameRDIIGraph1.G[i] := recSet.Fields.Item[15].Value;
//          end;
          if VarIsNull(recSet.Fields.Item[16].Value) then
            FrameRDIIGraph1.AI[1,i] := 0.0
          else
            FrameRDIIGraph1.AI[1,i] := recSet.Fields.Item[16].Value;
          if VarIsNull(recSet.Fields.Item[17].Value) then
            FrameRDIIGraph1.AM[1,i] := 0.0
          else
            FrameRDIIGraph1.AM[1,i] := recSet.Fields.Item[17].Value;
          if VarIsNull(recSet.Fields.Item[18].Value) then
            FrameRDIIGraph1.AR[1,i] := 0.0
          else
            FrameRDIIGraph1.AR[1,i] := recSet.Fields.Item[18].Value;

          if VarIsNull(recSet.Fields.Item[19].Value) then
            FrameRDIIGraph1.AI[2,i] := 0.0
          else
            FrameRDIIGraph1.AI[2,i] := recSet.Fields.Item[19].Value;
          if VarIsNull(recSet.Fields.Item[20].Value) then
            FrameRDIIGraph1.AM[2,i] := 0.0
          else
            FrameRDIIGraph1.AM[2,i] := recSet.Fields.Item[20].Value;
          if VarIsNull(recSet.Fields.Item[21].Value) then
            FrameRDIIGraph1.AR[2,i] := 0.0
          else
            FrameRDIIGraph1.AR[2,i] := recSet.Fields.Item[21].Value;

        finally
          recSet.Close;
        end;
      end;
    end;
  end;
  if num > 0 then begin
    Screen.Cursor := crHourglass;
    try
      FrameRDIIGraph1.StartDate :=
          floor(StartDatePicker.Date) + frac(StartTimePicker.Time);
      FrameRDIIGraph1.EndDate :=
          floor(EndDatePicker.Date) + frac(EndTimePicker.Time) +
            FrameRDIIGraph1.KTMax;
      FrameRDIIGraph1.RainGaugeName := sRaingaugeName;
//      if not boUseAssignedRainGauge then FrameRDIIGraph1.RainGaugeName := sRaingaugeName;
      FrameRDIIGraph1.FlowUnitLabel := DatabaseModule.GetFlowUnitLabelForScenario(iScenarioID);
      FrameRDIIGraph1.UpdateData; //(num);
      FrameRDIIGraph1.RedrawChart;
    finally
      Screen.Cursor := crDefault;
    end;
  end;

end;

end.
