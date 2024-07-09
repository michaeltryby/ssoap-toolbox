unit automaticeventdef;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin;

type
  TfrmAutomaticEventIdentification = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    MinimumPeakIILabel: TLabel;
    MinimumRainfallVolumeLabel: TLabel;
    TimeStepsToAverageSpinEdit: TSpinEdit;
    HoursToAddToStartSpinEdit: TSpinEdit;
    HoursToAddToEndSpinEdit: TSpinEdit;
    AnalysisNameComboBox: TComboBox;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    MinimumPeakIIEdit: TEdit;
    MinimumEventDurationEdit: TEdit;
    MinimumRainfallVolumeEdit: TEdit;
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure UpdateDialogBasedOnSelectedAnalysis();
    procedure AnalysisNameComboBoxChange(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private
  public
  end;

var
  frmAutomaticEventIdentification: TfrmAutomaticEventIdentification;

implementation

uses modDatabase, feedbackWithMemo, autoeventdefThread, existEventsWarning,
     eventExport, mainform;

{$R *.DFM}

procedure TfrmAutomaticEventIdentification.FormShow(Sender: TObject);
begin
  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames();
  AnalysisNameComboBox.ItemIndex := 0;
  UpdateDialogBasedOnSelectedAnalysis();
end;

procedure TfrmAutomaticEventIdentification.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAutomaticEventIdentification.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAutomaticEventIdentification.okButtonClick(Sender: TObject);
var
  analysisName: string;
  okToProcess: boolean;
  res: integer;
begin
  analysisName := AnalysisNameComboBox.Items.Strings[AnalysisNameComboBox.ItemIndex];
  okToProcess := true;
  if (DatabaseModule.AnalysisHasEvents(analysisName)) then begin
    res := frmEventsExistWarning.ShowModal;
    if (res = mrCancel) then
      okToProcess := false
    else begin
      if (res = mrAll + 2) then res := frmEventExport.ShowModal;
      if (res = mrCancel) then okToProcess := false;
    end;
  end;
  if (okToProcess) then begin
    automaticEventDefThread.CreateIt();
    frmFeedbackWithMemo.Caption := 'Automatic Event Identification';
    frmFeedbackWithMemo.OpenForProcessing;
//    Close;
  end;
end;

procedure TfrmAutomaticEventIdentification.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmAutomaticEventIdentification.UpdateDialogBasedOnSelectedAnalysis();
var
  analysisName, flowMeterName, flowUnitLabel, raingaugeName, rainfallUnitLabel: string;
begin
  analysisName := AnalysisNameComboBox.Text;
  flowMeterName := DatabaseModule.GetFlowMeterNameForAnalysis(analysisName);
  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
  MinimumPeakIILabel.Caption := 'Minimum Peak I/I ('+flowUnitLabel+')';
  raingaugeName := DatabaseModule.GetRaingaugeNameForAnalysis(analysisName);
  rainfallUnitLabel := DatabaseModule.GetRainUnitLabelForRaingauge(raingaugeName);
  MinimumRainfallVolumeLabel.Caption := 'Minimum Rainfall Volume ('+rainfallUnitLabel+')';
end;

procedure TfrmAutomaticEventIdentification.AnalysisNameComboBoxChange(
  Sender: TObject);
begin
  UpdateDialogBasedOnSelectedAnalysis();
end;

end.
