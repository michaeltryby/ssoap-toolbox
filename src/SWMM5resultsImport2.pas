unit SWMM5resultsImport2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ADODB_TLB, SWMM5_IFACE, Uutils;

type
  TfrmSWMM5ResultsImport2 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    ScenarioNameComboBox: TComboBox;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    SWMM5OutputFileEdit: TEdit;
    dlgOpenSWMM5Output: TOpenDialog;
    ScenarioDescription: TMemo;
    Label1: TLabel;
    Label4: TLabel;
    SWMM5InputFileEdit: TEdit;
    btnSSOs: TButton;
    btnDepths: TButton;
    LabelSSOCount: TLabel;
    LabelJunctionCount: TLabel;
    LabelSSOStatus: TLabel;
    LabelJunctionStatus: TLabel;
    LabelNumJunctions: TLabel;
    btnGraphs: TButton;
    procedure FormShow(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
    procedure ScenarioNameComboBoxChange(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
    procedure btnSSOsClick(Sender: TObject);
    procedure btnDepthsClick(Sender: TObject);
    procedure btnGraphsClick(Sender: TObject);
    procedure SWMM5OutputFileEditKeyPress(Sender: TObject; var Key: Char);
  private { Private declarations }
    iNumJunctions: integer;
    existingScenarioNames: TStringList;
    bo_Changed_SSO_List: boolean;
    bo_Changed_Junction_List: boolean;

  public { Public declarations }

  end;

var
  frmSWMM5ResultsImport2: TfrmSWMM5ResultsImport2;

implementation

uses modDatabase, mainform,
frmSSOOutfallSelector, frmNodeDepthSelector, frmTSGrapher, feedbackWithMemo;

{$R *.DFM}

procedure TfrmSWMM5ResultsImport2.FormShow(Sender: TObject);
begin
//- I went and set this to 'OK' upon successful import
  cancelButton.Caption := 'Cancel';
  existingScenarioNames := DatabaseModule.GetScenarioNames;
  ScenarioNameComboBox.Items := existingScenarioNames; //DatabaseModule.GetScenarioNames();
  if ScenarioNameComboBox.Items.Count > 0 then begin
    ScenarioNameComboBox.ItemIndex := 0;
    ScenarioNameComboBoxChange(Self);
  end;
//  scenarioDescription.Text := DatabaseModule.GetScenarioDesciption(ScenarioNameComboBox.Text);
end;


procedure TfrmSWMM5ResultsImport2.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
//  SSOOutfallForm.m_scID := DatabaseModule.GetScenarioIDForName(ScenarioNameComboBox.Text);
//  SSOOutfallForm.ShowModal;
end;

procedure TfrmSWMM5ResultsImport2.okButtonClick(Sender: TObject);
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
  //flowUnitID, depthUnitID : integer;
  scFlowUnitID, scDepthUnitID, scRainUnitID, scVelUnitID, scAreaUnitID,
  outFlowUnitID, outDepthUnitID : integer;
  scFlowUnits, outFlowUnits, scDepthUnits, outDepthUnits: string;
  conversionFactor : double;
  volume, duration : double;
  pipeSize, pipelength : double;
  strInputFile, strOutputFile, strOutputFileDateStamp: string;
  idxJun, idxJunMaster: integer;
  inv, depth, maxdepth: single;
  Junctions: TStringList;
  iSceneID: integer;
  fdt: TDateTime;
begin
  iSceneID := DatabaseModule.GetScenarioIDForName(ScenarioNameComboBox.Text);
  if (iSceneID < 0) then begin
    MessageDlg('Could not find selected scenario in database.',mtError, [mbok], 0);
    exit;
  end;
  DatabaseModule.GetUnitIDs4Scenario(iSceneID,
    scRainUnitID, scFlowUnitID, scDepthUnitID, scVelUnitID, scAreaUnitID);
  scFlowUnits := DatabaseModule.GetFlowUnitLabelForID(scFlowUnitID);
  scDepthUnits := DatabaseModule.GetDepthUnitLabelForID(scDepthUnitID);
  strOutputFile := SWMM5OutputFileEdit.Text;
  if (Length(strOutputFile) < 1) then begin
    MessageDlg('No SWMM5 output file selected for this scenario.',mtInformation,[mbok],0);
    exit;
  end;
  if not FileExists(strOutputFile) then begin
    MessageDlg('Could not find the SWMM5 output file specified.',mtError,[mbok],0);
    exit;
  end;
  iresult := swmm5_iface.OpenSwmmOutFile(strOutputFile);
  if iresult <> 0 then begin
    MessageDlg('There was a problem reading "' + strOutputFile +
    '" as a SWMM5 Output file.', mtError, [mbOK],0);
    Exit;
  end;
  fdt := Uutils.FileDateTime(strOutputFile);
  strOutputFileDateStamp := FormatDateTime('',fdt);
  outFlowUnitID := DatabaseModule.GetFlowUnitID(swmm5_iface.Units);
  outDepthUnitID := DatabaseModule.GetDepthUnitIDForSWMM5FlowUnitLabel(swmm5_iface.Units);
  outFlowUnits := DatabaseModule.GetFlowUnitLabelForID(outFlowUnitID);
  outDepthUnits := DatabaseModule.GetDepthUnitLabelForID(outDepthUnitID);
  //flowUnitID := DatabaseModule.GetFlowUnitID(swmm5_iface.Units);
  //depthUnitID := DatabaseModule.GetDepthUnitIDForSWMM5FlowUnitLabel(swmm5_iface.Units);
  //rm 2009-06-15 - Let's store the data in same units as in OUT file
  //conversionFactor := DatabaseModule.GetFlowConversionFactor(flowUnitID);
  conversionFactor := 1.0;
  //start with SSOs
  //if (SSOOutfallForm.GetSSOCount > 0) then begin
    if (bo_Changed_SSO_List) or (MessageDlg('SSO selections have not changed. ' +
        'Do you want to import timeseries for outfalls and the selected SSOs now anyway?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
      //remove all SSO TS detail records for this scenario and then reload them
      DatabaseModule.RemoveJunctionFlowTS(iSceneID, '');
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
          frmFeedbackWithMemo.feedbackMemo.Lines.Add('Importing Outfall Flow Timeseries for Junction: ' + OutfallID);
          //add TS Master record to TSMaster table
          idxJunMaster := DatabaseModule.AddSWMM5ResultJuncFlowTSMaster(iSceneID, OutfallID, true, false, outflowUnitID);
          if (idxJunMaster > -1) then begin

          end;

          idx := swmm5_iFace.JuncIndexOf(OutfallID);
          //outfallVolume := 0;
          for j := 0 to swmm5_iFace.SWMM_Nperiods - 1 do
          begin
            k := swmm5_iFace.GetSwmmResult(1, idx, 4, j, val); //4 for total inflows
            //conversionFactor - convert the flow into MGD
            //swmm5_iface.SWMM_ReportStep / 86400 = x day
            //volume = MGD * day
            //volume := val * conversionFactor * (swmm5_iface.SWMM_ReportStep / 86400);
            //outfallvolume := outfallvolume + volume; //in MG
            //add TS flow record to TSDetails table
            DatabaseModule.AddSWMM5ResultJuncFlowTSDetail(iSceneID, idxJunMaster,
              swmm5_iFace.StartDate + j * (swmm5_iface.SWMM_ReportStep / 86400),
              val * conversionFactor);
          end;
          //Save outfallID and outfallVolume to database
          //DatabaseModule.AddSWMM5ResultOutletVolume(iSceneID,OutfallID,outfallVolume);
        end;
      end;
      //reset changed flag
      bo_Changed_SSO_List := false;
      labelSSOStatus.Caption := 'Done importing.';
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('Done Importing Outfall Flow Timeseries');
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
      frmFeedbackWithMemo.feedbackMemo.Lines.Add('This window may be closed.');
      frmFeedbackWithMemo.OpenAfterProcessing;
      // - Update the ImportLog
      DatabaseModule.LogImport(8, iSceneID, -1, SWMM5OutputFileEdit.Text, Now, frmFeedbackWithMemo.feedbackMemo.Text);
    end;
  //end;
  //now do the Selected Junction Depth TSs
  if (NodeSelectorForm.GetSelectedJunctionCount > 0) then begin
    if (bo_Changed_Junction_List) or (MessageDlg('Junction Depth selections have not changed. ' +
        'Do you want to re-import depth timeseries for the selected Junctions now anyway?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
      //remove all Junction Depth TS detail records for this scenario and then reload them
      DatabaseModule.RemoveJunctionDepthTS(iSceneID, '');
      //now import node depth timeseries for the junctions selected in previous
      Junctions := DataBaseModule.GetJunctionsbyScenario(
        iSceneID, ' (JunctionDepthTS = TRUE) ');
      if (Junctions.Count > 0) then begin
        labelJunctionStatus.Caption := 'Importing.';
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
          labelJunctionStatus.Caption := 'Processing Junction ' + junctionID;
          idx := swmm5_iFace.JuncIndexOf(junctionID);
          //j := swmm5_iface.GetSwmmObjectProperty(1, idx, 1, inv, ival);  // 1 = invert
          //j := swmm5_iface.GetSwmmObjectProperty(1, idx, 2, depth, ival);  // 2 = mh depth
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
      //reset changed flag
      bo_Changed_Junction_List := false;
      labelJunctionStatus.Caption := 'Done importing.';
    end;
  end;
  swmm5_iface.CloseSwmmOutFile;



cancelbutton.Caption := 'Close';
//  Close;

end;

procedure TfrmSWMM5ResultsImport2.ScenarioNameComboBoxChange(Sender: TObject);
var sFileName: string;
    iSceneID : integer;
begin
  iSceneID := DatabaseModule.GetScenarioIDForName(ScenarioNameComboBox.Text);
  if (iSceneID < 0) then begin
    MessageDlg('Could not find selected scenario in database.',mtError, [mbok], 0);
    exit;
  end;
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
  SSOOutfallForm.SetScenarioID(iSceneID, false);
  NodeSelectorForm.SetScenarioID(iSceneID, false);
  LabelSSOCount.Caption := inttostr( SSOOutfallForm.GetSSOCount) + ' SSOs';
  labelJunctionCount.Caption := inttostr( NodeSelectorForm.GetSelectedJunctionCount) + ' Junctions';

  iNumJunctions := NodeSelectorForm.GetJunctionCount;
  LabelNumJunctions.Caption := inttostr(iNumJunctions) + ' junctions have been imported.';

end;

procedure TfrmSWMM5ResultsImport2.SWMM5OutputFileEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := #0;
end;

procedure TfrmSWMM5ResultsImport2.btnDepthsClick(Sender: TObject);
var
  iSceneID: integer;
begin
  iSceneID := DatabaseModule.GetScenarioIDForName(ScenarioNameComboBox.Text);
  if (iSceneID < 0) then begin
    MessageDlg('Could not find selected scenario in database.',mtError, [mbok], 0);
    exit;
  end;
  if (iNumJunctions < 1) then begin
    MessageDlg('Results have not been imported for this scenario.' +
      ' Please import SWMM5 results for this scenario using the Import From SWMM5 Output menu choice.',
      mtError, [mbok],0);
    exit;
  end;
  bo_Changed_Junction_List := false;
//  NodeSelectorForm.SetScenarioID(iSceneID);
  NodeSelectorForm.ShowModal;
  labelJunctionCount.Caption := inttostr( NodeSelectorForm.GetSelectedJunctionCount) + ' Junctions';
  bo_Changed_Junction_List := NodeSelectorForm.m_bo_Changed_Junction_List;
end;

procedure TfrmSWMM5ResultsImport2.btnGraphsClick(Sender: TObject);
var
  iSceneID: integer;
begin
//select graphs for display
//
//
  iSceneID := DatabaseModule.GetScenarioIDForName(ScenarioNameComboBox.Text);
  if (iSceneID < 0) then begin
    MessageDlg('Could not find selected scenario in database.',mtError, [mbok], 0);
    exit;
  end;
  if (iNumJunctions < 1) then begin
    MessageDlg('Results have not been imported for this scenario.' +
      ' Please import SWMM5 results for this scenario using the Import From SWMM5 Output menu choice.',
      mtError, [mbok],0);
    exit;
  end;
  TSGrapherForm.SetScenarioID(iSceneID);
  TSGrapherForm.ShowModal;
end;

procedure TfrmSWMM5ResultsImport2.btnSSOsClick(Sender: TObject);
var
  iSceneID: integer;
begin
  iSceneID := DatabaseModule.GetScenarioIDForName(ScenarioNameComboBox.Text);
  if (iSceneID < 0) then begin
    MessageDlg('Could not find selected scenario in database.',mtError, [mbok], 0);
    exit;
  end;
  if (iNumJunctions < 1) then begin
    MessageDlg('Results have not been imported for this scenario.' +
      ' Please import SWMM5 results for this scenario using the Import From SWMM5 Output menu choice.',
      mtError, [mbok],0);
    exit;
  end;
  bo_Changed_SSO_List := false;
//  SSOOutfallForm.SetScenarioID(iSceneID);
  SSOOutfallForm.ShowModal;
  LabelSSOCount.Caption := inttostr( SSOOutfallForm.GetSSOCount) + ' SSOs';
  bo_Changed_SSO_List := SSOOutfallForm.m_bo_Changed_SSO_List;
end;

procedure TfrmSWMM5ResultsImport2.cancelButtonClick(Sender: TObject);
begin
  Close;
end;


procedure TfrmSWMM5ResultsImport2.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  existingScenarioNames.Free;
end;


procedure TfrmSWMM5ResultsImport2.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmSWMM5ResultsImport2.FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0) then exit;
    Key := #0;
  end;
end;


end.
