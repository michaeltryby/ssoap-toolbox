unit infoanalysis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ADODB_TLB;

type
  TfrmInfoAnalysis = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    FlowMeterNameComboBox: TComboBox;
    AnalysisNameEdit: TEdit;
    RaingaugeNameComboBox: TComboBox;
    okButton: TButton;
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
    MaxDepressionStorageEdit: TEdit;
    RateOfReductionEdit: TEdit;
    InitialValueEdit: TEdit;
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
    NumberOfAnalyzedEvents: TEdit;
    Label12: TLabel;
    procedure FormShow(Sender: TObject);

    procedure okButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
  private { Private declarations }
    otherAnalysisNames: TStringList;
    recSet: _recordSet;
  public { Public declarations }
  end;

var
  frmInfoAnalysis: TfrmInfoAnalysis;

implementation

uses analysisManager, modDatabase, mainform, StormEventCollection;
var boIgnoreAdvancedCheck: boolean;

{$R *.DFM}

procedure TfrmInfoAnalysis.FormShow(Sender: TObject);
var
  analysisName, flowMeterName, raingaugeName, queryStr: String;
  rdiiEvents : TStormEventCollection;


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
    boIgnoreAdvancedCheck := false;
  end;


begin
  analysisName := frmAnalysisManagement.SelectedAnalysisName;
  AnalysisNameEdit.Text := analysisName;

  flowMeterName := DatabaseModule.GetFlowMeterNameForAnalysis(analysisName);
  FlowMeterNameComboBox.Items := DatabaseModule.GetFlowMeterNames();
  FlowMeterNameComboBox.ItemIndex := FlowMeterNameComboBox.Items.IndexOf(flowMeterName);

  raingaugeName := DatabaseModule.GetRaingaugeNameForAnalysis(analysisName);
  RaingaugeNameComboBox.Items := DatabaseModule.GetRaingaugeNames();
  RaingaugeNameComboBox.ItemIndex := RaingaugeNameComboBox.Items.IndexOf(raingaugeName);



  queryStr := 'SELECT BaseFlowRate, MaxDepressionStorage, RateOfReduction, ' +
              'InitialValue, R1, R2, R3, T1, T2, T3, K1, K2, K3, ' +
              'RunningAverageDuration, MondayDWFAdj, TuesdayDWFAdj, WednesdayDWFAdj,' +
              'ThursdayDWFAdj, FridayDWFAdj, SaturdayDWFAdj, SundayDWFAdj, ' +
              'AnalysisName, MeterID, RaingaugeID, ' +
//rm 2010-10-07
              ' MaxDepressionStorage2, RateOfReduction2, InitialValue2, ' +
              ' MaxDepressionStorage3, RateOfReduction3, InitialValue3 ' +
              'FROM Analyses WHERE (AnalysisName = "' + analysisName + '");';
{  recSet := CoRecordSet.Create;
//MessageDlg(queryStr, mtInformation, [mbok],0);
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;

  //rm 2010-10-19
  SetAdvancedCheckBoxStatus;}

  rdiievents := DatabaseModule.GetEvents(databasemodule.GetAnalysisIDForName(analysisName));
  numberOfAnalyzedEvents.text := inttostr(rdiievents.Count);

end;


procedure TfrmInfoAnalysis.okButtonClick(Sender: TObject);

begin
    Close;
end;


procedure TfrmInfoAnalysis.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//  otherAnalysisNames.Free;
  //rm 2010-10-07
  try
  finally

  end;
end;


procedure TfrmInfoAnalysis.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmInfoAnalysis.FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0) then exit;
    Key := #0;
  end;
end;

end.

