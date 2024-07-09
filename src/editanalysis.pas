unit editanalysis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ADODB_TLB;

type
  TfrmEditAnalysis = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    FlowMeterNameComboBox: TComboBox;
    AnalysisNameEdit: TEdit;
    RaingaugeNameComboBox: TComboBox;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    R1Edit: TEdit;
    R2Edit: TEdit;
    R3Edit: TEdit;
    T1Edit: TEdit;
    T2Edit: TEdit;
    T3Edit: TEdit;
    K1Edit: TEdit;
    K2Edit: TEdit;
    K3Edit: TEdit;
    TotalEdit: TEdit;
    baseFlowRateLabel: TLabel;
    BaseFlowRateEdit: TEdit;
    MaxDepressionStorageEdit: TEdit;
    RateOfReductionEdit: TEdit;
    InitialValueEdit: TEdit;
    GroupBox2: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    MondayAdjEdit: TEdit;
    TuesdayAdjEdit: TEdit;
    WednesdayAdjEdit: TEdit;
    ThursdayAdjEdit: TEdit;
    FridayAdjEdit: TEdit;
    SaturdayAdjEdit: TEdit;
    SundayAdjEdit: TEdit;
    Label12: TLabel;
    AverageIntervalEdit: TEdit;
    MaxDepressionStorageEdit2: TEdit;
    RateOfReductionEdit2: TEdit;
    InitialValueEdit2: TEdit;
    MaxDepressionStorageEdit3: TEdit;
    RateOfReductionEdit3: TEdit;
    InitialValueEdit3: TEdit;
    GroupBox3: TGroupBox;
    Label34: TLabel;
    Label33: TLabel;
    Label32: TLabel;
    Label31: TLabel;
    MaximumDepressionStorageLabel: TLabel;
    RateOfReductionLabel: TLabel;
    InitialValueLabel: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    CheckBoxAdvanced: TCheckBox;
    Label20: TLabel;
    Label21: TLabel;
    procedure FormShow(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure REditChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
    procedure UpdateFormBasedOnSelectedFlowMeter();
    procedure UpdateFormBasedOnSelectedRaingauge();
    procedure FlowMeterNameComboBoxChange(Sender: TObject);
    procedure RaingaugeNameComboBoxChange(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
    procedure CheckBoxAdvancedClick(Sender: TObject);
  private { Private declarations }
    otherAnalysisNames: TStringList;
    recSet: _recordSet;
    procedure updateTotalR();
  public { Public declarations }
  end;

var
  frmEditAnalysis: TfrmEditAnalysis;

implementation

uses analysisManager, modDatabase, mainform;
var boIgnoreAdvancedCheck: boolean;

{$R *.DFM}

procedure TfrmEditAnalysis.FormShow(Sender: TObject);
var
  analysisName, flowMeterName, raingaugeName, queryStr: String;

  procedure SetAdvancedCheckBoxStatus;
  var boHasData: boolean;
  begin
    boHasData := false;
    try
      boHasData := boHasData or (recSet.Fields.Item[1].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[2].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[3].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[4].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[5].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[6].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[7].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[8].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[9].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[10].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[11].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[12].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[24].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[25].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[26].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[27].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[28].Value > 0);
      boHasData := boHasData or (recSet.Fields.Item[29].Value > 0);
    finally
    end;
    boIgnoreAdvancedCheck := true;
    checkBoxAdvanced.Checked := boHasData;
    boIgnoreAdvancedCheck := false;
  end;


begin
  analysisName := frmAnalysisManagement.SelectedAnalysisName;
  AnalysisNameEdit.Text := analysisName;

  flowMeterName := DatabaseModule.GetFlowMeterNameForAnalysis(analysisName);
  FlowMeterNameComboBox.Items := DatabaseModule.GetFlowMeterNames();
  FlowMeterNameComboBox.ItemIndex := FlowMeterNameComboBox.Items.IndexOf(flowMeterName);
  UpdateFormBasedOnSelectedFlowMeter();

  raingaugeName := DatabaseModule.GetRaingaugeNameForAnalysis(analysisName);
  RaingaugeNameComboBox.Items := DatabaseModule.GetRaingaugeNames();
  RaingaugeNameComboBox.ItemIndex := RaingaugeNameComboBox.Items.IndexOf(raingaugeName);
  UpdateFormBasedOnSelectedRaingauge();

  queryStr := 'SELECT BaseFlowRate, MaxDepressionStorage, RateOfReduction, ' +
              'InitialValue, R1, R2, R3, T1, T2, T3, K1, K2, K3, ' +
              'RunningAverageDuration, MondayDWFAdj, TuesdayDWFAdj, WednesdayDWFAdj,' +
              'ThursdayDWFAdj, FridayDWFAdj, SaturdayDWFAdj, SundayDWFAdj, ' +
              'AnalysisName, MeterID, RaingaugeID, ' +
//rm 2010-10-07
              ' MaxDepressionStorage2, RateOfReduction2, InitialValue2, ' +
              ' MaxDepressionStorage3, RateOfReduction3, InitialValue3 ' +
              'FROM Analyses WHERE (AnalysisName = "' + analysisName + '");';
  recSet := CoRecordSet.Create;
//MessageDlg(queryStr, mtInformation, [mbok],0);
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;

  BaseFlowRateEdit.Text := recSet.Fields.Item[0].Value;
  MaxDepressionStorageEdit.Text := recSet.Fields.Item[1].Value;
  RateOfReductionEdit.Text := recSet.Fields.Item[2].Value;
  InitialValueEdit.Text := recSet.Fields.Item[3].Value;
  R1Edit.Text := recSet.Fields.Item[4].Value;
  R2Edit.Text := recSet.Fields.Item[5].Value;
  R3Edit.Text := recSet.Fields.Item[6].Value;
  T1Edit.Text := recSet.Fields.Item[7].Value;
  T2Edit.Text := recSet.Fields.Item[8].Value;
  T3Edit.Text := recSet.Fields.Item[9].Value;
  K1Edit.Text := recSet.Fields.Item[10].Value;
  K2Edit.Text := recSet.Fields.Item[11].Value;
  K3Edit.Text := recSet.Fields.Item[12].Value;
  AverageIntervalEdit.Text := recSet.Fields.Item[13].Value;
  MondayAdjEdit.Text := recSet.Fields.Item[14].Value;
  TuesdayAdjEdit.Text := recSet.Fields.Item[15].Value;
  WednesdayAdjEdit.Text := recSet.Fields.Item[16].Value;
  ThursdayAdjEdit.Text := recSet.Fields.Item[17].Value;
  FridayAdjEdit.Text := recSet.Fields.Item[18].Value;
  SaturdayAdjEdit.Text := recSet.Fields.Item[19].Value;
  SundayAdjEdit.Text := recSet.Fields.Item[20].Value;
  {recSet is used for updating and thus is closed in FormClose procedure}
  //rm 2010-10-07
  MaxDepressionStorageEdit2.Text := recSet.Fields.Item[24].Value;
  RateOfReductionEdit2.Text := recSet.Fields.Item[25].Value;
  InitialValueEdit2.Text := recSet.Fields.Item[26].Value;

  MaxDepressionStorageEdit3.Text := recSet.Fields.Item[27].Value;
  RateOfReductionEdit3.Text := recSet.Fields.Item[28].Value;
  InitialValueEdit3.Text := recSet.Fields.Item[29].Value;
  //rm
  otherAnalysisNames := DatabaseModule.GetAnalysisNames;
  otherAnalysisNames.Delete(otherAnalysisNames.indexof(analysisName));
  //rm 2010-10-19
  SetAdvancedCheckBoxStatus;
end;

procedure TfrmEditAnalysis.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEditAnalysis.okButtonClick(Sender: TObject);
var
  flowMeterName, raingaugeName: String;
  meterID, raingaugeID: integer;
  flowTimestep, rainTimestep: integer;
  okToAdd: boolean;
  BaseFlowRateStr, MaxDepressionStorageStr, RateOfReductionStr: string;
  InitialValueEditStr, averageIntervalStr, MondayAdjStr, TuesdayAdjStr: string;
  WednesdayAdjStr, ThursdayAdjStr, FridayAdjStr, SaturdayAdjStr, SundayAdjStr: string;
  R, T, K: array[1..3] of string;
  //rm 2010-10-07
  MaxDepressionStorageStr2, RateOfReductionStr2, InitialValueEditStr2: string;
  MaxDepressionStorageStr3, RateOfReductionStr3, InitialValueEditStr3: string;
begin
  flowMeterName := FlowMeterNameComboBox.Items.Strings[FlowMeterNameComboBox.ItemIndex];
  meterID := DatabaseModule.GetMeterIDForName(flowMeterName);
  raingaugeName := RaingaugeNameComboBox.Items.Strings[RaingaugeNameComboBox.ItemIndex];
  raingaugeID := DatabaseModule.GetRaingaugeIDForName(raingaugeName);
  okToAdd := true;
  if (otherAnalysisNames.IndexOf(AnalysisNameEdit.Text) <> -1) then begin
    okToAdd := false;
    MessageDlg('Another analysis with this name already exists.',mtError,[mbOK],0);
  end;
  if (Length(AnalysisNameEdit.Text) = 0) then begin
    okToAdd := false;
    MessageDlg('The analysis name cannot be blank.',mtError,[mbOK],0);
  end;
  flowTimestep := DatabaseModule.GetFlowTimestep(meterID);
  rainTimestep := DatabaseModule.GetRainfallTimestep(raingaugeID);
  if (flowTimestep <> rainTimestep) then begin
    okToAdd := false;
    MessageDlg('The time step of the flow data must equal the time step of the rainfall data.',mtError,[mbOK],0);
  end;
  if (okToAdd) then begin
    if (Length(BaseFlowRateEdit.Text) > 0)
      then BaseFlowRateStr := BaseFlowRateEdit.Text
      else BaseFlowRateStr := '0.0';
    if (Length(MaxDepressionStorageEdit.Text) > 0)
      then MaxDepressionStorageStr := MaxDepressionStorageEdit.Text
      else MaxDepressionStorageStr := '0.0';
    if (Length(RateOfReductionEdit.Text) > 0)
      then RateOfReductionStr := RateOfReductionEdit.Text
      else RateOfReductionStr := '0.0';
    if (Length(InitialValueEdit.Text) > 0)
      then InitialValueEditStr := InitialValueEdit.Text
      else InitialValueEditStr := '0.0';
//rm 2010-10-07
    if (Length(MaxDepressionStorageEdit2.Text) > 0)
      then MaxDepressionStorageStr2 := MaxDepressionStorageEdit2.Text
      else MaxDepressionStorageStr2 := '0.0';
    if (Length(RateOfReductionEdit2.Text) > 0)
      then RateOfReductionStr2 := RateOfReductionEdit2.Text
      else RateOfReductionStr2 := '0.0';
    if (Length(InitialValueEdit2.Text) > 0)
      then InitialValueEditStr2 := InitialValueEdit2.Text
      else InitialValueEditStr2 := '0.0';
    if (Length(MaxDepressionStorageEdit3.Text) > 0)
      then MaxDepressionStorageStr3 := MaxDepressionStorageEdit3.Text
      else MaxDepressionStorageStr3 := '0.0';
    if (Length(RateOfReductionEdit3.Text) > 0)
      then RateOfReductionStr3 := RateOfReductionEdit3.Text
      else RateOfReductionStr3 := '0.0';
    if (Length(InitialValueEdit3.Text) > 0)
      then InitialValueEditStr3 := InitialValueEdit3.Text
      else InitialValueEditStr3 := '0.0';
//rm
    if (Length(R1Edit.Text) > 0) then R[1] := R1Edit.Text else R[1] := '0.0';
    if (Length(R2Edit.Text) > 0) then R[2] := R2Edit.Text else R[2] := '0.0';
    if (Length(R3Edit.Text) > 0) then R[3] := R3Edit.Text else R[3] := '0.0';
    if (Length(T1Edit.Text) > 0) then T[1] := T1Edit.Text else T[1] := '0.0';
    if (Length(T2Edit.Text) > 0) then T[2] := T2Edit.Text else T[2] := '0.0';
    if (Length(T3Edit.Text) > 0) then T[3] := T3Edit.Text else T[3] := '0.0';
    if (Length(K1Edit.Text) > 0) then K[1] := K1Edit.Text else K[1] := '0.0';
    if (Length(K2Edit.Text) > 0) then K[2] := K2Edit.Text else K[2] := '0.0';
    if (Length(K3Edit.Text) > 0) then K[3] := K3Edit.Text else K[3] := '0.0';
    if (Length(AverageIntervalEdit.Text) > 0)
      then averageIntervalStr := AverageIntervalEdit.Text
      else averageIntervalStr := '1.0';
    if (Length(MondayAdjEdit.Text) > 0)
      then MondayAdjStr := MondayAdjEdit.Text
      else MondayAdjStr := '0.0';
    if (Length(TuesdayAdjEdit.Text) > 0)
      then TuesdayAdjStr := TuesdayAdjEdit.Text
      else TuesdayAdjStr := '0.0';
    if (Length(WednesdayAdjEdit.Text) > 0)
      then WednesdayAdjStr := WednesdayAdjEdit.Text
      else WednesdayAdjStr := '0.0';
    if (Length(ThursdayAdjEdit.Text) > 0)
      then ThursdayAdjStr := ThursdayAdjEdit.Text
      else ThursdayAdjStr := '0.0';
    if (Length(FridayAdjEdit.Text) > 0)
      then FridayAdjStr := FridayAdjEdit.Text
      else FridayAdjStr := '0.0';
    if (Length(SaturdayAdjEdit.Text) > 0)
      then SaturdayAdjStr := SaturdayAdjEdit.Text
      else SaturdayAdjStr := '0.0';
    if (Length(SundayAdjEdit.Text) > 0)
      then SundayAdjStr := SundayAdjEdit.Text
      else SundayAdjStr := '0.0';

    recSet.Fields.Item[0].Value := BaseFlowRateStr;
    recSet.Fields.Item[1].Value := MaxDepressionStorageStr;
    recSet.Fields.Item[2].Value := RateOfReductionStr;
    recSet.Fields.Item[3].Value := InitialValueEditStr;
    recSet.Fields.Item[4].Value := R[1];
    recSet.Fields.Item[5].Value := R[2];
    recSet.Fields.Item[6].Value := R[3];
    recSet.Fields.Item[7].Value := T[1];
    recSet.Fields.Item[8].Value := T[2];
    recSet.Fields.Item[9].Value := T[3];
    recSet.Fields.Item[10].Value := K[1];
    recSet.Fields.Item[11].Value := K[2];
    recSet.Fields.Item[12].Value := K[3];
    recSet.Fields.Item[13].Value := averageIntervalStr;
    recSet.Fields.Item[14].Value := mondayAdjStr;
    recSet.Fields.Item[15].Value := tuesdayAdjStr;
    recSet.Fields.Item[16].Value := wednesdayAdjStr;
    recSet.Fields.Item[17].Value := thursdayAdjStr;
    recSet.Fields.Item[18].Value := fridayAdjStr;
    recSet.Fields.Item[19].Value := saturdayAdjStr;
    recSet.Fields.Item[20].Value := sundayAdjStr;
    recSet.Fields.Item[21].Value := analysisNameEdit.Text;
    recSet.Fields.Item[22].Value := meterID;
    recSet.Fields.Item[23].Value := raingaugeID;
//rm 2010-10-07
    recSet.Fields.Item[24].Value := MaxDepressionStorageStr2;
    recSet.Fields.Item[25].Value := RateOfReductionStr2;
    recSet.Fields.Item[26].Value := InitialValueEditStr2;
    recSet.Fields.Item[27].Value := MaxDepressionStorageStr3;
    recSet.Fields.Item[28].Value := RateOfReductionStr3;
    recSet.Fields.Item[29].Value := InitialValueEditStr3;
//rm
    recSet.UpdateBatch(1);
    {recSet is closed in FormClose procedure}
    Close;
  end;
end;

procedure TfrmEditAnalysis.updateTotalR();
var
  total: real;
begin
  total := 0.0;
  if (Length(R1Edit.Text) > 0) then total := total + strtofloat(R1Edit.Text);
  if (Length(R2Edit.Text) > 0) then total := total + strtofloat(R2Edit.Text);
  if (Length(R3Edit.Text) > 0) then total := total + strtofloat(R3Edit.Text);
  TotalEdit.Text := floattostr(total);
end;

procedure TfrmEditAnalysis.REditChange(Sender: TObject);
begin
  updateTotalR();
end;

procedure TfrmEditAnalysis.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  otherAnalysisNames.Free;
  //rm 2010-10-07
  try
  recSet.Close
  finally

  end;
end;

procedure TfrmEditAnalysis.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditAnalysis.CheckBoxAdvancedClick(Sender: TObject);
  function CheckB4WipingDefaultRTKs: boolean;
  var boResult: boolean;
      boHasData: boolean;
  begin
    boResult := false; //set to True if OK to Zero Out advanced terms
    boHasData := false;
    if boIgnoreAdvancedCheck then begin
      boResult := true
    end else begin
    //prompt user if there is any data that will be wiped out
    if R1Edit.Text <> '0' then boHasData := true;
    if R2Edit.Text <> '0' then boHasData := true;
    if R3Edit.Text <> '0' then boHasData := true;
    if T1Edit.Text <> '0' then boHasData := true;
    if T2Edit.Text <> '0' then boHasData := true;
    if T3Edit.Text <> '0' then boHasData := true;
    if K1Edit.Text <> '0' then boHasData := true;
    if K2Edit.Text <> '0' then boHasData := true;
    if K3Edit.Text <> '0' then boHasData := true;
    if MaxDepressionStorageEdit.Text <> '0' then boHasData := true;
    if RateOfReductionEdit.Text <> '0' then boHasData := true;
    if InitialValueEdit.Text <> '0' then boHasData := true;
    if MaxDepressionStorageEdit2.Text <> '0' then boHasData := true;
    if RateOfReductionEdit2.Text <> '0' then boHasData := true;
    if InitialValueEdit2.Text <> '0' then boHasData := true;
    if MaxDepressionStorageEdit3.Text <> '0' then boHasData := true;
    if RateOfReductionEdit3.Text <> '0' then boHasData := true;
    if InitialValueEdit3.Text <> '0' then boHasData := true;
    if boHasData then begin
      if (MessageDlg('Are you sure you want to clear the RTK and IA terms?',mtConfirmation, [mbYes,mbNo], 0) = mrYes) then begin
        boResult := true;
        R1Edit.Text := '0';
        R2Edit.Text := '0';
        R3Edit.Text := '0';
        T1Edit.Text := '0';
        T2Edit.Text := '0';
        T3Edit.Text := '0';
        K1Edit.Text := '0';
        K2Edit.Text := '0';
        K3Edit.Text := '0';
        MaxDepressionStorageEdit.Text := '0';
        RateOfReductionEdit.Text := '0';
        InitialValueEdit.Text := '0';
        MaxDepressionStorageEdit2.Text := '0';
        RateOfReductionEdit2.Text := '0';
        InitialValueEdit2.Text := '0';
        MaxDepressionStorageEdit3.Text := '0';
        RateOfReductionEdit3.Text := '0';
        InitialValueEdit3.Text := '0';
      end;
    end else begin
      boResult := true
    end;
    end;
    result := boResult;
  end;
begin
  if checkboxAdvanced.Checked then begin
    frmEditAnalysis.Width := 566
  end else begin
    if CheckB4WipingDefaultRTKs then
      frmEditAnalysis.Width := 287
    else
      checkboxAdvanced.Checked := true;
  end;
end;

procedure TfrmEditAnalysis.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmEditAnalysis.FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmEditAnalysis.UpdateFormBasedOnSelectedFlowMeter();
var
  flowMeterName, flowUnitLabel: string;
begin
  flowMeterName := FlowMeterNameComboBox.Text;
  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
  baseFlowRateLabel.caption := 'Base Flow Rate ('+flowUnitLabel+')';
end;

procedure TfrmEditAnalysis.UpdateFormBasedOnSelectedRaingauge();
var
  raingaugeName, rainfallUnitLabel: string;
begin
  raingaugeName := RaingaugeNameComboBox.Text;
  rainfallUnitLabel := DatabaseModule.GetRainUnitLabelForRaingauge(raingaugeName);
  MaximumDepressionStorageLabel.Caption := 'Dmax = Maximum Depression Storage ('+rainfallUnitLabel+')';
  RateOfReductionLabel.Caption := 'Drec = Rate Of Recovery ('+rainfallUnitLabel+'/day)';
  InitialValueLabel.Caption := 'Do = Initial Value ('+rainfallUnitLabel+')';
end;

procedure TfrmEditAnalysis.FlowMeterNameComboBoxChange(Sender: TObject);
begin
  UpdateFormBasedOnSelectedFlowMeter();
end;

procedure TfrmEditAnalysis.RaingaugeNameComboBoxChange(Sender: TObject);
begin
  UpdateFormBasedOnSelectedRaingauge();
end;

end.
