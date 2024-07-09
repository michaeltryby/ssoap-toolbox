unit SWMM5resultsImport1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ADODB_TLB, SWMM5_IFACE, Uutils;

type
  TfrmSWMM5ResultsImport1 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    ScenarioNameComboBox: TComboBox;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    SWMM5OutputFileEdit: TEdit;
    GroupBox1: TGroupBox;
    lblEnd: TLabel;
    lblStart: TLabel;
    lblNumPer: TLabel;
    lblRep: TLabel;
    lblSuccess: TLabel;
    lblUnits: TLabel;
    lblVersion: TLabel;
    dlgOpenSWMM5Output: TOpenDialog;
    BrowseSWMMfile: TButton;
    ScenarioDescription: TMemo;
    Label1: TLabel;
    lblNumSubc: TLabel;
    lblNumCond: TLabel;
    lblNumJunc: TLabel;
    Label4: TLabel;
    SWMM5InputFileEdit: TEdit;
    procedure FormShow(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
    procedure BrowseSWMMfileClick(Sender: TObject);
    procedure ScenarioNameComboBoxChange(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    existingScenarioNames: TStringList;
  public { Public declarations }
    procedure UpdateScenario_SWMM5_Output(iSceneID:integer;sSWMM5Output:string);
  end;

var
  frmSWMM5ResultsImport1: TfrmSWMM5ResultsImport1;

implementation

uses modDatabase, mainform, frmSSOOutfallSelector, frmNodeDepthSelector, feedbackWithMemo;

{$R *.DFM}

procedure TfrmSWMM5ResultsImport1.FormShow(Sender: TObject);
begin
//- I went and set this to 'OK' upon successful import
  cancelButton.Caption := 'Cancel';
  GroupBox1.Visible := false;
  existingScenarioNames := DatabaseModule.GetScenarioNames;
  ScenarioNameComboBox.Items := existingScenarioNames; //DatabaseModule.GetScenarioNames();
  if ScenarioNameComboBox.Items.Count > 0 then begin
    ScenarioNameComboBox.ItemIndex := 0;
    ScenarioNameComboBoxChange(Self);
  end;
//  scenarioDescription.Text := DatabaseModule.GetScenarioDesciption(ScenarioNameComboBox.Text);
end;


procedure TfrmSWMM5ResultsImport1.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmSWMM5ResultsImport1.okButtonClick(Sender: TObject);
var
  iresult: integer;
  i, k, j, n:integer;
  val : single;
  outcount,ival,idx : integer;
  pipeID, junctionID, outfallID : string;
  Pipes: TStringList;            //list of the pipes found in outfile
  Dates: TStringList;               //all the datetimes from start of reporting to end
  PipeCaps: array of array of double;  //the pipecap timeseries for each pipe
  maxCaps, floodingVolume, outfallVolume : real;
  scFlowUnitID, scDepthUnitID, scRainUnitID, scVelUnitID, scAreaUnitID,
  outFlowUnitID, outDepthUnitID : integer;
  scFlowUnits, outFlowUnits, scDepthUnits, outDepthUnits: string;
  flowconversionFactor, depthconversionfactor, flow2volumeFactor : double;
  volume, duration : double;
  pipeSize, pipelength : double;
  iSceneID: integer;
  strOutputFile, strOutputFileDateStamp: string;
  idxJun, idxJunMaster: integer;
  inv, depth, maxdepth: single;
  Junctions: TStringList;
  bo_OldData: boolean; //keep track of whether we are overwriting old results
  fdt: TDateTime;
begin
//rm 2009-05-22 - extensive edits here

  iSceneID := DatabaseModule.GetScenarioIDForName(ScenarioNameComboBox.Text);
  if (iSceneID < 0) then begin
    MessageDlg('Could not find selected scenario in database.',mtError, [mbok], 0);
    exit;
  end;
  DatabaseModule.GetUnitIDs4Scenario(iSceneID,
    scRainUnitID, scFlowUnitID, scDepthUnitID, scVelUnitID, scAreaUnitID);
  scFlowUnits := DatabaseModule.GetFlowUnitLabelForID(scFlowUnitID);
  scDepthUnits := DatabaseModule.GetDepthUnitLabelForID(scDepthUnitID);
  //swmm5_iface.CloseSwmmOutFile;
  {need a loop to make sure the file is valid}
  strOutputFile := SWMM5OutputFileEdit.Text;
  if (Length(strOutputFile) < 1) then begin
    MessageDlg('Please select a SWMM5 output file to process.',mtInformation,[mbok],0);
    exit;
  end;
  if not FileExists(strOutputFile) then begin
    MessageDlg('Could not find the SWMM5 output file specified.',mtInformation,[mbok],0);
    exit;
  end;

  bo_oldData := false;
  if DatabaseModule.GetScenarioSWMM5ResultsCount(iSceneID) > 0 then begin
    if (MessageDlg('This scenario already has SWMM5 results loaded. ' +
       'Would you like to replace them?', mtConfirmation, [mbyes,mbno],0) <> mrYes) then
    exit;
  //rm 2009-06-04 before clearing existing results - load up the SSOs and Junctions selected for timeseries
    bo_oldData := true;
    SSOOutfallForm.SetScenarioID(iSceneID, false);
    NodeSelectorForm.SetScenarioID(iSceneID, false);
  //rm - that way if results are re-imported, selections are not lost
  end;
  DatabaseModule.ClearScenarioSWMM5Results(iSceneID);
  fdt := Uutils.FileDateTime(strOutputFile);
  strOutputFileDateStamp := FormatDateTime('',fdt);

  frmFeedbackWithMemo.Caption := 'SWMM 5 Results Import';
  frmFeedbackWithMemo.feedbackMemo.Clear;
  frmFeedbackWithMemo.DateLabel.Caption := DateTimetoStr(Now);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add('SWMM 5 Results Import for Scenario: ');
  frmFeedbackWithMemo.feedbackMemo.Lines.Add('  ' + ScenarioNameComboBox.Text);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add('Scenario Flow Units: ' + scFlowUnits);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add('Scenario Depth Units: ' + scDepthUnits);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
  frmFeedbackWithMemo.feedbackMemo.Lines.Add('Processing SWMM 5 Output File: ');
  frmFeedbackWithMemo.feedbackMemo.Lines.Add('  ' + strOutputFile);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add('Output File Date Stamp: ' +strOutputFileDateStamp);

  iresult := swmm5_iface.OpenSwmmOutFile(strOutputFile);
  if iresult <> 0 then begin
    MessageDlg('There was a problem reading "' + strOutputFile +
      '" as a SWMM5 Output file.', mtError, [mbOK],0);
    Exit;
  end;
  outFlowUnitID := DatabaseModule.GetFlowUnitID(swmm5_iface.Units);
  outDepthUnitID := DatabaseModule.GetDepthUnitIDForSWMM5FlowUnitLabel(swmm5_iface.Units);
  outFlowUnits := DatabaseModule.GetFlowUnitLabelForID(outFlowUnitID);
  outDepthUnits := DatabaseModule.GetDepthUnitLabelForID(outDepthUnitID);

  lblSuccess.Caption := 'Success: TRUE';// + inttostr(iresult);
  lblUnits.Caption := 'Flow Units: ' + outFlowUnits;
  lblVersion.Caption := 'Engine Version: ' + inttostr(swmm5_iface.SWMM_Version);
  lblNumper.Caption := 'Num Periods: ' + inttostr(swmm5_iFace.SWMM_Nperiods);
  lblRep.Caption := 'Report Step: ' + inttostr(swmm5_iface.SWMM_ReportStep);
  lblStart.Caption := 'Start Date: ' + DateTimetostr(swmm5_iFace.StartDate);
  lblEnd.Caption := 'End Date: ' + DateTimetostr(swmm5_iFace.EndDate);
  lblNumSubc.Caption := 'Number of Subcatchments: ' + inttostr(swmm5_iFace.SWMM_Nsubcatch);
  lblNumJunc.Caption := 'Number of Junctions: ' + inttostr(swmm5_iFace.SWMM_Nnodes);
  lblNumCond.Caption := 'Number of Conduits: ' + inttostr(swmm5_iFace.SWMM_Nlinks);

  frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(lblSuccess.Caption);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add('Output File ' + lblUnits.Caption);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add('Output File Depth Units: ' + outDepthUnits);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(lblVersion.Caption);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(lblNumper.Caption);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(lblRep.Caption);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(lblStart.Caption);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(lblEnd.Caption);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(lblNumSubc.Caption);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(lblNumJunc.Caption);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(lblNumCond.Caption);
  frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
  //frmFeedbackWithMemo.feedbackMemo.Lines.Add();
  //frmFeedbackWithMemo.feedbackMemo.Lines.Add();

  GroupBox1.Visible := true;
  GroupBox1.Invalidate;
  Invalidate;
  Refresh;
  //rm 2009-06-15 - Let's store the data in same units as in OUT file conversionFactor := DatabaseModule.GetFlowConversionFactor(flowUnitID);
  flowconversionFactor := 1.0;
  depthconversionfactor := 1.0;
  //rm 2009-06-17 - Let's compare the Scenario Flow Unit ID to the OUTPUT file Flow Unit ID
  if (scFlowUnitID <> outFlowUnitID) then begin
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('********** NOTE: **********');
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('Scenario flow units differ from flow units of SWMM 5 Output.');
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('***************************');
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
  end;

  outCount := 0;

  try
    Screen.Cursor := crHourGlass;
    //Conduit Capacity
    for i := 0 to swmm5_iface.SWMM_Nlinks - 1 do
    begin
      j := swmm5_iface.GetSwmmObjectProperty(2, i, 0, val, ival);
      if (ival = 0) then  //got a pipe
      begin
        pipeID := swmm5_iFace.CondName(i);
        idx := swmm5_iFace.CondIndexOf(swmm5_IFace.condName(i));
        maxCaps := 0;
        duration := 0;
        for j := 0 to swmm5_iFace.SWMM_Nperiods - 1 do
        begin
          k := swmm5_iFace.GetSwmmResult(2, idx, 4, j, val); //4 for % filled
          if val > maxCaps then maxCaps := val;
          if val = 1 then duration := duration + (swmm5_iface.SWMM_ReportStep / 86400)
        end;
        j := swmm5_iface.GetSwmmObjectProperty(2, idx, 3, val, ival);  //3 for pipesize
        {inc(outCount);}
        // save PipeID and MaxCaps to database
        pipesize := val;
        j := swmm5_iface.GetSwmmObjectProperty(2, idx, 4, val, ival);  //4 for pipelength
        pipelength := val;
        //DatabaseModule.AddSWMM5ResultCondCaps(DatabaseModule.GetScenarioIDForName(ScenarioNameComboBox.Text),pipeID,maxCaps,duration,pipesize,pipelength);
        //rm 2009-06-29 - added outFlowUnitID
        //DatabaseModule.AddSWMM5ResultCondCaps(iSceneID,pipeID,maxCaps,duration,pipesize,pipelength);
        DatabaseModule.AddSWMM5ResultCondCaps(iSceneID,pipeID,maxCaps,
          duration,pipesize,pipelength,outFlowUnitID);
      end;
      if i mod 10 = 0 then
      begin
        lblNumCond.Caption := 'Processing Conduit: ' + inttostr(i) + '/' + inttostr(swmm5_iFace.SWMM_Nlinks);
        Invalidate;
        Refresh;
      end;
    end;
    lblNumCond.Caption := 'Number of conduits: ' + inttostr(swmm5_iFace.SWMM_Nlinks);

  //Junction Flooding & Depth
    //volume is calculated in units determined by flowunits
    //generally take the first two characters of flowunits label to get volume units
    //except for GPM -> "G" and "LPS" -> "L"
    //for MGD or MLD vol = flow * numdays
    flow2volumeFactor := (swmm5_iface.SWMM_ReportStep / 86400.0);
    if (outFlowUnits = 'CFS') or (outFlowUnits = 'CMS') or (outFlowUnits = 'LPS') then begin
      //for CFS vol in CF = flow * numsecs
      flow2volumeFactor := swmm5_iface.SWMM_ReportStep;
    end else if (outFlowUnits = 'GPM') then begin
      //for GPM vol in gal = flow * numMinutes
      flow2volumeFactor := (swmm5_iface.SWMM_ReportStep / 60.0);
    end;

    for i := 0 to swmm5_iface.SWMM_Nnodes - 1 do
    begin
      j := swmm5_iface.GetSwmmObjectProperty(1, i, 0, val, ival);
      if (ival = 0) then  //got a manhole
      begin
        j := swmm5_iface.GetSwmmObjectProperty(1, i, 1, inv, ival);  // 1 = invert
        j := swmm5_iface.GetSwmmObjectProperty(1, i, 2, depth, ival);  // 2 = mh depth
        junctionID := swmm5_iFace.JuncName(i);
        idx := swmm5_iFace.JuncIndexOf(junctionID);
        floodingVolume := 0;
        duration := 0;
        maxdepth := 0;
        for j := 0 to swmm5_iFace.SWMM_Nperiods - 1 do
        begin
          k := swmm5_iFace.GetSwmmResult(1, idx, 5, j, val);   //5 for flooding
          //flow2volumeFactor - convert the flow into MGD
          //swmm5_iface.SWMM_ReportStep / 86400 = x day
          //volume = MGD * day
          volume := val * flowconversionFactor * flow2volumeFactor;
          floodingVolume := floodingVolume + volume; //in first two char of flowunits
          if val > 0 then duration := duration + (swmm5_iface.SWMM_ReportStep / 86400);
          //rm 2009-05-27 - collect max depth for every manhole
          k := swmm5_iFace.GetSwmmResult(1, idx, 0, j, val);   //0 for depth above invert
          if val > maxdepth then begin
            maxdepth := val;
          end;
        end;
        // Save junctionID and floodingVolume to database
        DatabaseModule.AddSWMM5ResultFloodingVolume(iSceneID,junctionID,
          floodingVolume, duration, outFlowUnitID);
        DatabaseModule.AddSWMM5ResultJuncDepths(iSceneID,junctionID,
          inv, depth, maxdepth, outDepthUnitID);
      end;
      if i mod 10 = 0 then
      begin
        lblNumJunc.Caption := 'Processing Junction: ' + inttostr(i) + '/' + inttostr(swmm5_iFace.SWMM_Nnodes);
        Invalidate;
        Refresh;
      end;
    end;
    lblNumJunc.Caption := 'Number of Junctions: ' + inttostr(swmm5_iFace.SWMM_Nnodes);

    frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('This window may be closed.');
    frmFeedbackWithMemo.OpenAfterProcessing;
    // - Update the ImportLog
    DatabaseModule.LogImport(7, iSceneID, -1, SWMM5OutputFileEdit.Text, Now, frmFeedbackWithMemo.feedbackMemo.Text);

  //Outfall Volume and Full Timeseries
    frmFeedbackWithMemo.Caption := 'SWMM 5 Outfall Flow Timeseries Import';
    frmFeedbackWithMemo.feedbackMemo.Clear;
    frmFeedbackWithMemo.DateLabel.Caption := DateTimetoStr(Now);
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('SWMM 5 Outfall Flow Timeseries Import for Scenario: ');
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('  ' + ScenarioNameComboBox.Text);
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('Scenario Flow Units: ' + scFlowUnits);
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('Scenario Depth Units: ' + scDepthUnits);
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('Processing SWMM 5 Output file: ');
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('  ' + strOutputFile);
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('Output File Date Stamp: ' +strOutputFileDateStamp);
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('Output File Flow Units: ' + outFlowUnits);
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('Output File Depth Units: ' + outDepthUnits);
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
    if (scFlowUnitID <> outFlowUnitID) then begin
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('********** NOTE: **********');
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('Scenario flow units differ from flow units of SWMM 5 Output.');
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('***************************');
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
    end;
    for i := 0 to swmm5_iface.SWMM_Nnodes - 1 do
    begin
      j := swmm5_iface.GetSwmmObjectProperty(1, i, 0, val, ival);
      if (ival = 1) then  //got an outfall
      begin
        OutfallID := swmm5_iFace.JuncName(i);
        //add TS Master record to TSMaster table
        idxJunMaster := DatabaseModule.AddSWMM5ResultJuncFlowTSMaster(iSceneID,
          OutfallID, true, false, outFlowUnitID);
        if (idxJunMaster > -1) then begin

        end;
        frmFeedbackWithMemo.feedbackMemo.Lines.Add('Importing Outfall Flow Timeseries for Junction: ' + OutfallID);
        idx := swmm5_iFace.JuncIndexOf(OutfallID);
        outfallVolume := 0;
        for j := 0 to swmm5_iFace.SWMM_Nperiods - 1 do
        begin
          k := swmm5_iFace.GetSwmmResult(1, idx, 4, j, val); //4 for total inflows
          //flow2volumeFactor - convert the flow into MGD
          //swmm5_iface.SWMM_ReportStep / 86400 = x day
          //volume = MGD * day

          volume := val * flowconversionFactor * flow2volumeFactor;
          outfallvolume := outfallvolume + volume; //in MG
          //add TS flow record to TSDetails table
          DatabaseModule.AddSWMM5ResultJuncFlowTSDetail(iSceneID, idxJunMaster,
            swmm5_iFace.StartDate + j * (swmm5_iface.SWMM_ReportStep / 86400),
            val * flowconversionFactor);

        end;
        //Save outfallID and outfallVolume to database
        DatabaseModule.AddSWMM5ResultOutletVolume(iSceneID,
          OutfallID,outfallVolume,outFlowUnitID);

      end;
    end;
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('Done Importing Outfall Flow Timeseries');
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('This window may be closed.');
    frmFeedbackWithMemo.OpenAfterProcessing;
    // - Let's update the Scenarios.SWMM5_Output
    UpdateScenario_SWMM5_Output(iSceneID,SWMM5OutputFileEdit.Text);
    // - Update the ImportLog
    DatabaseModule.LogImport(8, iSceneID, -1, SWMM5OutputFileEdit.Text, Now, frmFeedbackWithMemo.feedbackMemo.Text);
    //- let user know we are done
    cancelButton.Caption := 'Close';

    //allow user to select SSOs from list of all outfalls
    SSOOutfallForm.SetScenarioID(iSceneID,  bo_oldData);
    SSOOutfallForm.ShowModal;
    //allow user to select junctions to import Depth TS for
    NodeSelectorForm.SetScenarioID(iSceneID,  bo_oldData);
    NodeSelectorForm.ShowModal;

    //now import node depth timeseries for the junctions selected in previous
    Junctions := DataBaseModule.GetJunctionsbyScenario(
      iSceneID, ' (JunctionDepthTS = TRUE) ');
    if (Junctions.Count > 0) then begin
      frmFeedbackWithMemo.Caption := 'SWMM 5 Junction Depth Timeseries Import';
      //frmFeedbackWithMemo.OpenForProcessing;
      frmFeedbackWithMemo.feedbackMemo.Clear;
      frmFeedbackWithMemo.DateLabel.Caption := DateTimetoStr(Now);
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('SWMM 5 Junction Depth Timeseries Import for Scenario: ');
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('  ' + ScenarioNameComboBox.Text);
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('Scenario Flow Units: ' + scFlowUnits);
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('Scenario Depth Units: ' + scDepthUnits);
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('Processing SWMM 5 Output file: ');
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('  ' + strOutputFile);
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('Output File Date Stamp: ' +strOutputFileDateStamp);
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('Output File Flow Units: ' + outFlowUnits);
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('Output File Depth Units: ' + outDepthUnits);
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
      if (scFlowUnitID <> outFlowUnitID) then begin
        frmFeedbackWithMemo.feedbackMemo.Lines.Add('********** NOTE: **********');
        frmFeedbackWithMemo.feedbackMemo.Lines.Add('Scenario flow units differ from flow units of SWMM 5 Output.');
        frmFeedbackWithMemo.feedbackMemo.Lines.Add('***************************');
        frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
      end;
      for i := 0 to Junctions.Count -1 do begin
        junctionID := Junctions.Strings[i];
        idx := swmm5_iFace.JuncIndexOf(junctionID);
        j := swmm5_iface.GetSwmmObjectProperty(1, idx, 1, inv, ival);  // 1 = invert
        j := swmm5_iface.GetSwmmObjectProperty(1, idx, 2, depth, ival);  // 2 = mh depth
        idxJunMaster := DatabaseModule.AddSWMM5ResultJuncDepthTSMaster(
          iSceneID, junctionID, inv, depth, outDepthUnitID);
        if (idxJunMaster > -1) then begin
          frmFeedbackWithMemo.feedbackMemo.Lines.Add('Importing Junction Depth Timeseries for Junction: ' + junctionID);
          for j := 0 to swmm5_iFace.SWMM_Nperiods - 1 do begin
            k := swmm5_iFace.GetSwmmResult(1, idx, 0, j, val);   //0 for depth above invert
            DatabaseModule.AddSWMM5ResultJuncDepthTSDetail(iSceneID, idxJunMaster,
              swmm5_iFace.StartDate + j * (swmm5_iface.SWMM_ReportStep / 86400), val);
          end;
        end;
      end;
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('Done Importing Junction Depth Timeseries');
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('This window may be closed.');
      //frmFeedbackWithMemo.DoneProcessing;
      frmFeedbackWithMemo.OpenAfterProcessing;
      // - Update the ImportLog
      DatabaseModule.LogImport(9, iSceneID, -1, SWMM5OutputFileEdit.Text, Now, frmFeedbackWithMemo.feedbackMemo.Text);
    end;
  finally
    Screen.Cursor := crDefault;
    swmm5_iface.CloseSwmmOutFile;
  end;
end;

procedure TfrmSWMM5ResultsImport1.ScenarioNameComboBoxChange(Sender: TObject);
var sFileName: string;
    iSceneID : integer;
begin
  iSceneID := DatabaseModule.GetScenarioIDForName(ScenarioNameComboBox.Text);
  scenarioDescription.Text := DatabaseModule.GetScenarioDesciption(ScenarioNameComboBox.Text);
//rm 2009-05-22 - some changes here
  sFileName := DataBaseModule.GetScenarioInpFileName(iSceneID);
  if Length(sFileName) > 0 then begin
    SWMM5InputFileEdit.Text := sFileName;
  end;
  sFileName := DataBaseModule.GetScenarioOutFileName(iSceneID);
  if Length(sFileName) > 0 then begin
    SWMM5OutputFileEdit.Text := sFileName;
  end else begin
    sFileName := DataBaseModule.GetScenarioInpFileName(iSceneID);
    SWMM5OutputFileEdit.Text := '';
    if Length(sFileName) > 0 then
      SWMM5OutputFileEdit.Text := ChangeFileExt(sFileName,'.out');
  end;
end;

procedure TfrmSWMM5ResultsImport1.UpdateScenario_SWMM5_Output(iSceneID: integer;
  sSWMM5Output: string);
var
    queryStr: string;
    recSet:   _recordSet;
begin
//Update Scenarios set SWMM5_Output = "' + sSWMM5Output + '" +
//Where ScenarioID = ' + inttostr(iSceneID)
//changed Scenarios.SWMM5_Ouput field width to 250 in seed mdb file.
  queryStr := 'SELECT scenarioID, SWMM5_Output ' +
              'FROM Scenarios WHERE (ScenarioID = ' + inttostr(iSceneID) + ');';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if not recSet.EOF then
  begin
    try
      recSet.MoveFirst;
      recSet.Fields.Item[1].Value := sSWMM5Output;
      recSet.UpdateBatch(1);
    finally
      recSet.Close;
    end;
  end;
end;

procedure TfrmSWMM5ResultsImport1.BrowseSWMMfileClick(Sender: TObject);
begin
  if Length(SWMM5OutputFileEdit.Text) > 0 then
    dlgOpenSWMM5Output.FileName := SWMM5OutputFileEdit.Text;
  if dlgOpenSWMM5Output.Execute  then begin
    SWMM5OutputFileEdit.text := dlgOpenSWMM5Output.FileName;
  end;
end;

procedure TfrmSWMM5ResultsImport1.cancelButtonClick(Sender: TObject);
begin
  Close;
end;


procedure TfrmSWMM5ResultsImport1.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  existingScenarioNames.Free;
end;


procedure TfrmSWMM5ResultsImport1.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmSWMM5ResultsImport1.FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0) then exit;
    Key := #0;
  end;
end;


end.
