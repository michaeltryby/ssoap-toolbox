unit newAnalysis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ADODB_TLB;

type
  TfrmAddNewAnalysis = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    FlowMeterNameComboBox: TComboBox;
    AnalysisNameEdit: TEdit;
    RaingaugeNameComboBox: TComboBox;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    RTKGroupBox: TGroupBox;
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
    BaseFlowRateEdit: TEdit;
    baseFlowRateLabel: TLabel;
    MaxDepressionStorageEdit: TEdit;
    RateOfReductionEdit: TEdit;
    InitialValueEdit: TEdit;
    Label12: TLabel;
    AverageIntervalEdit: TEdit;
    GroupBox1: TGroupBox;
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
    MaxDepressionStorageEdit2: TEdit;
    RateOfReductionEdit2: TEdit;
    InitialValueEdit2: TEdit;
    MaxDepressionStorageEdit3: TEdit;
    RateOfReductionEdit3: TEdit;
    InitialValueEdit3: TEdit;
    GroupBox2: TGroupBox;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    InitialValueLabel: TLabel;
    RateOfReductionLabel: TLabel;
    MaximumDepressionStorageLabel: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    CheckBoxAdvanced: TCheckBox;
    Label21: TLabel;
    Label20: TLabel;
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
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
    existingAnalysisNames: TStringList;
    procedure updateTotalR();
  public { Public declarations }
  end;

var
  frmAddNewAnalysis: TfrmAddNewAnalysis;

implementation

uses modDatabase, mainform;

{$R *.DFM}

procedure TfrmAddNewAnalysis.FormShow(Sender: TObject);
begin
  AnalysisNameEdit.Text := 'New Analysis';
  FlowMeterNameComboBox.Items := DatabaseModule.GetFlowMeterNames();
  FlowMeterNameComboBox.ItemIndex := 0;
  UpdateFormBasedOnSelectedFlowMeter();
  RaingaugeNameComboBox.Items := DatabaseModule.GetRaingaugeNames();
  RaingaugeNameComboBox.ItemIndex := 0;
  UpdateFormBasedOnSelectedRaingauge();
  existingAnalysisNames := DatabaseModule.GetAnalysisNames;
end;

procedure TfrmAddNewAnalysis.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAddNewAnalysis.okButtonClick(Sender: TObject);
var
  flowMeterName, raingaugeName: string;
  meterID, raingaugeID, flowTimestep, rainTimestep: integer;
  baseFlowRateStr, maxDepressionStorageStr, RateOfReductionStr: string;
  MondayAdjStr, TuesdayAdjStr, WednesdayAdjStr,ThursdayAdjStr: string;
  FridayAdjStr, SaturdayAdjStr, SundayAdjStr: string;
  initialValueStr, averageIntervalStr, sqlStr: string;
  R, T, K: array[1..3] of string;
  okToAdd: boolean;
  recordsAffected: OleVariant;
  //rm 2010-10-07
  maxDepressionStorageStr2, RateOfReductionStr2, initialValueStr2: string;
  maxDepressionStorageStr3, RateOfReductionStr3, initialValueStr3: string;
begin
  flowMeterName := FlowMeterNameComboBox.Items.Strings[FlowMeterNameComboBox.ItemIndex];
  meterID := DatabaseModule.GetMeterIDForName(flowMeterName);
  raingaugeName := RaingaugeNameComboBox.Items.Strings[RaingaugeNameComboBox.ItemIndex];
  raingaugeID := DatabaseModule.GetRaingaugeIDForName(raingaugeName);
  okToAdd := true;
  if (existingAnalysisNames.IndexOf(AnalysisNameEdit.Text) <> -1) then begin
    okToAdd := false;
    MessageDlg('An analysis with this name already exists.',mtError,[mbOK],0);
  end;
  if (Length(AnalysisNameEdit.Text) = 0) then begin
    okToAdd := false;
    MessageDlg('The analysis name cannot be blank.',mtError,[mbOK],0);
  end;
  flowTimestep := DatabaseModule.GetFlowTimestep(meterID);
  rainTimestep := DatabaseModule.GetRainfallTimestep(raingaugeID);
  if (flowTimestep <> rainTimestep) then begin
    okToAdd := false;
    MessageDlg('The time step of the flow data must equal the time step of the rainfall data.',mtWarning,[mbOK],0);
  end;
  if (okToAdd) then begin
    Screen.Cursor := crHourglass;
    if (Length(BaseFlowRateEdit.Text) > 0)
      then baseFlowRateStr := BaseFlowRateEdit.Text
      else baseFlowRateStr := '0.0';
    if (Length(MaxDepressionStorageEdit.Text) > 0)
      then maxDepressionStorageStr := MaxDepressionStorageEdit.Text
      else maxDepressionStorageStr := '0.0';
    if (Length(RateOfReductionEdit.Text) > 0)
      then rateOfReductionStr := RateOfReductionEdit.Text
      else rateOfReductionStr := '0.0';
    if (Length(InitialValueEdit.Text) > 0)
      then initialValueStr := InitialValueEdit.Text
      else initialValueStr := '0.0';
//rm 2010-10-07
    if (Length(MaxDepressionStorageEdit2.Text) > 0)
      then maxDepressionStorageStr2 := MaxDepressionStorageEdit2.Text
      else maxDepressionStorageStr2 := '0.0';
    if (Length(RateOfReductionEdit2.Text) > 0)
      then rateOfReductionStr2 := RateOfReductionEdit2.Text
      else rateOfReductionStr2 := '0.0';
    if (Length(InitialValueEdit2.Text) > 0)
      then initialValueStr2 := InitialValueEdit2.Text
      else initialValueStr2 := '0.0';
    if (Length(MaxDepressionStorageEdit3.Text) > 0)
      then maxDepressionStorageStr3 := MaxDepressionStorageEdit3.Text
      else maxDepressionStorageStr3 := '0.0';
    if (Length(RateOfReductionEdit3.Text) > 0)
      then rateOfReductionStr3 := RateOfReductionEdit3.Text
      else rateOfReductionStr3 := '0.0';
    if (Length(InitialValueEdit3.Text) > 0)
      then initialValueStr3 := InitialValueEdit3.Text
      else initialValueStr3 := '0.0';
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
//rm 2010-10-07
{
    sqlStr := 'INSERT INTO Analyses (AnalysisName,MeterID,RaingaugeID,' +
              'BaseFlowRate,MaxDepressionStorage,RateOfReduction,' +
              'InitialValue,R1,R2,R3,T1,T2,T3,K1,K2,K3,RunningAverageDuration,' +
              'MondayDWFAdj,TuesdayDWFAdj,WednesdayDWFAdj,ThursdayDWFAdj,' +
              'FridayDWFAdj,SaturdayDWFAdj,SundayDWFAdj) VALUES (' +
              '"' + AnalysisNameEdit.Text + '",' +
              inttostr(meterID) + ',' +
              inttostr(raingaugeID) + ',' +
              baseFlowRateStr + ',' +
              maxDepressionStorageStr + ',' +
              rateOfReductionStr + ',' +
              initialValueStr + ',' +
              R[1] + ',' +
              R[2] + ',' +
              R[3] + ',' +
              T[1] + ',' +
              T[2] + ',' +
              T[3] + ',' +
              K[1] + ',' +
              K[2] + ',' +
              K[3] + ',' +
              averageIntervalStr + ',' +
              MondayAdjStr + ',' +
              TuesdayAdjStr + ',' +
              WednesdayAdjStr + ',' +
              ThursdayAdjStr + ',' +
              FridayAdjStr + ',' +
              SaturdayAdjStr + ',' +
              SundayAdjStr + ');';
}
    sqlStr := 'INSERT INTO Analyses (AnalysisName,MeterID,RaingaugeID,' +
              'BaseFlowRate, ' +
              ' MaxDepressionStorage,RateOfReduction,InitialValue, ' +
              ' MaxDepressionStorage2,RateOfReduction2,InitialValue2, ' +
              ' MaxDepressionStorage3,RateOfReduction3,InitialValue3, ' +
              ' R1,R2,R3,T1,T2,T3,K1,K2,K3,RunningAverageDuration,' +
              'MondayDWFAdj,TuesdayDWFAdj,WednesdayDWFAdj,ThursdayDWFAdj,' +
              'FridayDWFAdj,SaturdayDWFAdj,SundayDWFAdj) VALUES (' +
              '"' + AnalysisNameEdit.Text + '",' +
              inttostr(meterID) + ',' +
              inttostr(raingaugeID) + ',' +
              baseFlowRateStr + ',' +
              maxDepressionStorageStr + ',' +
              rateOfReductionStr + ',' +
              initialValueStr + ',' +
              maxDepressionStorageStr2 + ',' +
              rateOfReductionStr2 + ',' +
              initialValueStr2 + ',' +
              maxDepressionStorageStr3 + ',' +
              rateOfReductionStr3 + ',' +
              initialValueStr3 + ',' +
              R[1] + ',' +
              R[2] + ',' +
              R[3] + ',' +
              T[1] + ',' +
              T[2] + ',' +
              T[3] + ',' +
              K[1] + ',' +
              K[2] + ',' +
              K[3] + ',' +
              averageIntervalStr + ',' +
              MondayAdjStr + ',' +
              TuesdayAdjStr + ',' +
              WednesdayAdjStr + ',' +
              ThursdayAdjStr + ',' +
              FridayAdjStr + ',' +
              SaturdayAdjStr + ',' +
              SundayAdjStr + ');';
    frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
    Screen.Cursor := crDefault;
    Close;
  end;
end;

procedure TfrmAddNewAnalysis.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAddNewAnalysis.updateTotalR();
var
  total: real;
begin
  total := 0.0;
  if (Length(R1Edit.Text) > 0) then total := total + strtofloat(R1Edit.Text);
  if (Length(R2Edit.Text) > 0) then total := total + strtofloat(R2Edit.Text);
  if (Length(R3Edit.Text) > 0) then total := total + strtofloat(R3Edit.Text);
  TotalEdit.Text := floattostr(total);
end;

procedure TfrmAddNewAnalysis.REditChange(Sender: TObject);
begin
  updateTotalR();
end;

procedure TfrmAddNewAnalysis.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  existingAnalysisNames.Free;
end;

procedure TfrmAddNewAnalysis.CheckBoxAdvancedClick(Sender: TObject);
  function CheckB4WipingDefaultRTKs: boolean;
  var boResult: boolean;
      boHasData: boolean;
  begin
    boResult := false; //set to True if OK to Zero Out advanced terms
    boHasData := false;
    //prompt user if there is any data that will be wiped out
    if R1Edit.Text <> '0.0' then boHasData := true;
    if R2Edit.Text <> '0.0' then boHasData := true;
    if R3Edit.Text <> '0.0' then boHasData := true;
    if T1Edit.Text <> '0.0' then boHasData := true;
    if T2Edit.Text <> '0.0' then boHasData := true;
    if T3Edit.Text <> '0.0' then boHasData := true;
    if K1Edit.Text <> '0.0' then boHasData := true;
    if K2Edit.Text <> '0.0' then boHasData := true;
    if K3Edit.Text <> '0.0' then boHasData := true;
    if MaxDepressionStorageEdit.Text <> '0.0' then boHasData := true;
    if RateOfReductionEdit.Text <> '0.0' then boHasData := true;
    if InitialValueEdit.Text <> '0.0' then boHasData := true;
    if MaxDepressionStorageEdit2.Text <> '0.0' then boHasData := true;
    if RateOfReductionEdit2.Text <> '0.0' then boHasData := true;
    if InitialValueEdit2.Text <> '0.0' then boHasData := true;
    if MaxDepressionStorageEdit3.Text <> '0.0' then boHasData := true;
    if RateOfReductionEdit3.Text <> '0.0' then boHasData := true;
    if InitialValueEdit3.Text <> '0.0' then boHasData := true;
    if boHasData then begin
      if (MessageDlg('Are you sure you want to clear the RTK and IA terms?',mtConfirmation, [mbYes,mbNo], 0) = mrYes) then begin
        boResult := true;
        R1Edit.Text := '0.0';
        R2Edit.Text := '0.0';
        R3Edit.Text := '0.0';
        T1Edit.Text := '0.0';
        T2Edit.Text := '0.0';
        T3Edit.Text := '0.0';
        K1Edit.Text := '0.0';
        K2Edit.Text := '0.0';
        K3Edit.Text := '0.0';
        MaxDepressionStorageEdit.Text := '0.0';
        RateOfReductionEdit.Text := '0.0';
        InitialValueEdit.Text := '0.0';
        MaxDepressionStorageEdit2.Text := '0.0';
        RateOfReductionEdit2.Text := '0.0';
        InitialValueEdit2.Text := '0.0';
        MaxDepressionStorageEdit3.Text := '0.0';
        RateOfReductionEdit3.Text := '0.0';
        InitialValueEdit3.Text := '0.0';
      end;
    end else begin
      boResult := true
    end;
    result := boResult;
  end;
begin
  if checkboxAdvanced.Checked then begin
    frmAddNewAnalysis.Width := 566
  end else begin
    if CheckB4WipingDefaultRTKs then
      frmAddNewAnalysis.Width := 287
    else
      checkboxAdvanced.Checked := true;
  end;
end;

procedure TfrmAddNewAnalysis.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmAddNewAnalysis.FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmAddNewAnalysis.UpdateFormBasedOnSelectedFlowMeter();
var
  flowMeterName, flowUnitLabel: string;
begin
  flowMeterName := FlowMeterNameComboBox.Text;
  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
  baseFlowRateLabel.caption := 'Base Flow Rate ('+flowUnitLabel+')';
end;

procedure TfrmAddNewAnalysis.UpdateFormBasedOnSelectedRaingauge();
var
  raingaugeName, rainfallUnitLabel: string;
begin
  raingaugeName := RaingaugeNameComboBox.Text;
  rainfallUnitLabel := DatabaseModule.GetRainUnitLabelForRaingauge(raingaugeName);
  MaximumDepressionStorageLabel.Caption := 'Dmax = Maximum Depression Storage ('+rainfallUnitLabel+')';
  RateOfReductionLabel.Caption := 'Drec = Rate Of Recovery ('+rainfallUnitLabel+'/day)';
  InitialValueLabel.Caption := 'Do = Initial Value ('+rainfallUnitLabel+')';
end;

procedure TfrmAddNewAnalysis.FlowMeterNameComboBoxChange(Sender: TObject);
begin
  UpdateFormBasedOnSelectedFlowMeter;
end;

procedure TfrmAddNewAnalysis.RaingaugeNameComboBoxChange(Sender: TObject);
begin
  UpdateFormBasedOnSelectedRaingauge();
end;

end.
