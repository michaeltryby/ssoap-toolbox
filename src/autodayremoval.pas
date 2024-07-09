unit autodayremoval;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mask, StdCtrls, Spin;

type
  TfrmAutomaticDayRemoval = class(TForm)
    WeekendCurrentDayMaxRainLabel: TLabel;
    WeekendPreviousDayMaxRainLabel: TLabel;
    WeekendTwoDaysPreviousMaxRainLabel: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    GroupBox1: TGroupBox;
    WeekdaysCheckBox: TCheckBox;
    GroupBox2: TGroupBox;
    WeekdayRemoveDaysMissingDataCheckBox: TCheckBox;
    WeekdayMinimumPercentageLabel: TLabel;
    WeekdayMinimumPercentageEdit: TEdit;
    GroupBox3: TGroupBox;
    WeekdayRemoveDaysStatisticallyCheckBox: TCheckBox;
    WeekdayStandardDeviationLabel: TLabel;
    weekdayRainfallRemovalGroupBox: TGroupBox;
    WeekdayRemoveDaysBasedOnRainfallCheckBox: TCheckBox;
    WeekdaySomeSortLabel: TLabel;
    GroupBox5: TGroupBox;
    WeekendCheckBox: TCheckBox;
    GroupBox6: TGroupBox;
    WeekendMinimumPercentageLabel: TLabel;
    WeekendRemoveDaysMissingDataCheckBox: TCheckBox;
    WeekendMinimumPercentageEdit: TEdit;
    GroupBox7: TGroupBox;
    WeekendStandardDeviationLabel: TLabel;
    WeekendRemoveDaysStatisticallyCheckBox: TCheckBox;
    GroupBox8: TGroupBox;
    WeekendSomeSortLabel: TLabel;
    WeekendRemoveDaysBasedOnRainfallCheckBox: TCheckBox;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    WeekdayRaingaugeComboBox: TComboBox;
    WeekendRaingaugeComboBox: TComboBox;
    WeekdayCurrentDayMaxRainLabel: TLabel;
    WeekdayPreviousDayMaxRainLabel: TLabel;
    WeekdayTwoDaysPreviousMaxRainLabel: TLabel;
    FlowMeterNameComboBox: TComboBox;
    AverageIntervalEdit: TEdit;
    WeekdayOnlyGreaterCheckBox: TCheckBox;
    WeekendOnlyGreaterCheckBox: TCheckBox;
    WeekdayStandardDeviationEdit: TEdit;
    WeekendStandardDeviationEdit: TEdit;
    WeekdayCurrentDayMaxRainEdit: TEdit;
    WeekdayPreviousDayMaxRainEdit: TEdit;
    WeekdayTwoDaysPreviousMaxRainEdit: TEdit;
    WeekendCurrentDayMaxRainEdit: TEdit;
    WeekendPreviousDayMaxRainEdit: TEdit;
    WeekendTwoDaysPreviousMaxRainEdit: TEdit;
    WeekdayThreeDaysPreviousMaxRainLabel: TLabel;
    WeekdayFourDaysPreviousMaxRainLabel: TLabel;
    WeekdayFiveDaysPreviousMaxRainLabel: TLabel;
    WeekdaySixDaysPreviousMaxRainLabel: TLabel;
    WeekdaySevenDaysPreviousMaxRainLabel: TLabel;
    WeekdayThreeDaysPreviousMaxRainEdit: TEdit;
    WeekdayFourDaysPreviousMaxRainEdit: TEdit;
    WeekdayFiveDaysPreviousMaxRainEdit: TEdit;
    WeekdaySixDaysPreviousMaxRainEdit: TEdit;
    WeekdaySevenDaysPreviousMaxRainEdit: TEdit;
    WeekendThreeDaysPreviousMaxRainLabel: TLabel;
    WeekendFourDaysPreviousMaxRainLabel: TLabel;
    WeekendFiveDaysPreviousMaxRainLabel: TLabel;
    WeekendSixDaysPreviousMaxRainLabel: TLabel;
    WeekendSevenDaysPreviousMaxRainLabel: TLabel;
    WeekendFourDaysPreviousMaxRainEdit: TEdit;
    WeekendThreeDaysPreviousMaxRainEdit: TEdit;
    WeekendFiveDaysPreviousMaxRainEdit: TEdit;
    WeekendSixDaysPreviousMaxRainEdit: TEdit;
    WeekendSevenDaysPreviousMaxRainEdit: TEdit;
    procedure WeekdaysCheckBoxClick(Sender: TObject);
    procedure WeekdayRemoveDaysMissingDataCheckBoxClick(Sender: TObject);
    procedure WeekdayRemoveDaysBasedOnRainfallCheckBoxClick(Sender: TObject);
    procedure WeekdayRemoveDaysStatisticallyCheckBoxClick(Sender: TObject);
    procedure WeekendCheckBoxClick(Sender: TObject);
    procedure WeekendRemoveDaysMissingDataCheckBoxClick(Sender: TObject);
    procedure WeekendRemoveDaysBasedOnRainfallCheckBoxClick(Sender: TObject);
    procedure WeekendRemoveDaysStatisticallyCheckBoxClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure UpdateDialogBasedOnSelectedWeekdayRaingauge();
    procedure UpdateDialogBasedOnSelectedWeekendRaingauge();
    procedure WeekdayRaingaugeComboBoxChange(Sender: TObject);
    procedure WeekendRaingaugeComboBoxChange(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private  { Private declarations }
    raingaugeNames: TStringlist;
  public { Public declarations }
  end;

var
  frmAutomaticDayRemoval: TfrmAutomaticDayRemoval;

implementation

uses modDatabase, feedbackWithMemo, autodayremovalThread, mainform;

{$R *.DFM}

procedure TfrmAutomaticDayRemoval.WeekdaysCheckBoxClick(Sender: TObject);
begin
  WeekdayRemoveDaysMissingDataCheckBox.Enabled := WeekdaysCheckBox.Checked;
  WeekdayMinimumPercentageLabel.Enabled := WeekdayRemoveDaysMissingDataCheckBox.Enabled
    and WeekdayRemoveDaysMissingDataCheckBox.Checked;
  WeekdayMinimumPercentageEdit.Enabled := WeekdayRemoveDaysMissingDataCheckBox.Enabled
    and WeekdayRemoveDaysMissingDataCheckBox.Checked;

  WeekdayRemoveDaysBasedOnRainfallCheckBox.Enabled := WeekdaysCheckBox.Checked;
  WeekdaySomeSortLabel.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekdayRaingaugeComboBox.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekdayCurrentDayMaxRainLabel.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekdayPreviousDayMaxRainLabel.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekdayTwoDaysPreviousMaxRainLabel.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekdayCurrentDayMaxRainEdit.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekdayPreviousDayMaxRainEdit.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekdayTwoDaysPreviousMaxRainEdit.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;

  WeekdayRemoveDaysStatisticallyCheckBox.Enabled := WeekdaysCheckBox.Checked;
  WeekdayStandardDeviationLabel.Enabled := WeekdayRemoveDaysStatisticallyCheckBox.Enabled
    and WeekdayRemoveDaysStatisticallyCheckBox.Checked;
  WeekdayStandardDeviationEdit.Enabled := WeekdayRemoveDaysStatisticallyCheckBox.Enabled
    and WeekdayRemoveDaysStatisticallyCheckBox.Checked;
  WeekdayOnlyGreaterCheckBox.Enabled := WeekdayRemoveDaysStatisticallyCheckBox.Enabled
    and WeekdayRemoveDaysStatisticallyCheckBox.Checked;
end;

procedure TfrmAutomaticDayRemoval.WeekdayRemoveDaysMissingDataCheckBoxClick(
  Sender: TObject);
begin
  WeekdayMinimumPercentageLabel.Enabled := WeekdayRemoveDaysMissingDataCheckBox.Checked;
  WeekdayMinimumPercentageEdit.Enabled := WeekdayRemoveDaysMissingDataCheckBox.Checked;
end;

procedure TfrmAutomaticDayRemoval.WeekdayRemoveDaysBasedOnRainfallCheckBoxClick(
  Sender: TObject);
begin
  WeekdaySomeSortLabel.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekdayRaingaugeComboBox.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekdayCurrentDayMaxRainLabel.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekdayPreviousDayMaxRainLabel.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekdayTwoDaysPreviousMaxRainLabel.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekdayCurrentDayMaxRainEdit.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekdayPreviousDayMaxRainEdit.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekdayTwoDaysPreviousMaxRainEdit.Enabled := WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked;
end;

procedure TfrmAutomaticDayRemoval.WeekdayRemoveDaysStatisticallyCheckBoxClick(
  Sender: TObject);
begin
  WeekdayStandardDeviationLabel.Enabled := WeekdayRemoveDaysStatisticallyCheckBox.Checked;
  WeekdayStandardDeviationEdit.Enabled := WeekdayRemoveDaysStatisticallyCheckBox.Checked;
  WeekdayOnlyGreaterCheckBox.Enabled := WeekdayRemoveDaysStatisticallyCheckBox.Checked;
end;

procedure TfrmAutomaticDayRemoval.WeekendCheckBoxClick(Sender: TObject);
begin
  WeekendRemoveDaysMissingDataCheckBox.Enabled := WeekendCheckBox.Checked;
  WeekendMinimumPercentageLabel.Enabled := WeekendRemoveDaysMissingDataCheckBox.Enabled
    and WeekendRemoveDaysMissingDataCheckBox.Checked;
  WeekendMinimumPercentageEdit.Enabled := WeekendRemoveDaysMissingDataCheckBox.Enabled
    and WeekendRemoveDaysMissingDataCheckBox.Checked;

  WeekendRemoveDaysBasedOnRainfallCheckBox.Enabled := WeekendCheckBox.Checked;
  WeekendSomeSortLabel.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekendRaingaugeComboBox.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekendCurrentDayMaxRainLabel.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekendPreviousDayMaxRainLabel.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekendTwoDaysPreviousMaxRainLabel.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekendCurrentDayMaxRainEdit.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekendPreviousDayMaxRainEdit.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekendTwoDaysPreviousMaxRainEdit.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Enabled
    and WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;

  WeekendRemoveDaysStatisticallyCheckBox.Enabled := WeekendCheckBox.Checked;
  WeekendStandardDeviationLabel.Enabled := WeekendRemoveDaysStatisticallyCheckBox.Enabled
    and WeekendRemoveDaysStatisticallyCheckBox.Checked;
  WeekendStandardDeviationEdit.Enabled := WeekendRemoveDaysStatisticallyCheckBox.Enabled
    and WeekendRemoveDaysStatisticallyCheckBox.Checked;
 WeekendOnlyGreaterCheckBox.Enabled := WeekendRemoveDaysStatisticallyCheckBox.Enabled
    and WeekendRemoveDaysStatisticallyCheckBox.Checked;
end;

procedure TfrmAutomaticDayRemoval.WeekendRemoveDaysMissingDataCheckBoxClick(
  Sender: TObject);
begin
  WeekendMinimumPercentageLabel.Enabled := WeekendRemoveDaysMissingDataCheckBox.Checked;
  WeekendMinimumPercentageEdit.Enabled := WeekendRemoveDaysMissingDataCheckBox.Checked;
end;

procedure TfrmAutomaticDayRemoval.WeekendRemoveDaysBasedOnRainfallCheckBoxClick(
  Sender: TObject);
begin
  WeekendSomeSortLabel.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekendRaingaugeComboBox.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekendCurrentDayMaxRainLabel.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekendPreviousDayMaxRainLabel.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekendTwoDaysPreviousMaxRainLabel.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekendCurrentDayMaxRainEdit.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekendPreviousDayMaxRainEdit.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
  WeekendTwoDaysPreviousMaxRainEdit.Enabled := WeekendRemoveDaysBasedOnRainfallCheckBox.Checked;
end;

procedure TfrmAutomaticDayRemoval.WeekendRemoveDaysStatisticallyCheckBoxClick(
  Sender: TObject);
begin
  WeekendStandardDeviationLabel.Enabled := WeekendRemoveDaysStatisticallyCheckBox.Checked;
  WeekendStandardDeviationEdit.Enabled := WeekendRemoveDaysStatisticallyCheckBox.Checked;
  WeekendOnlyGreaterCheckBox.Enabled := WeekendRemoveDaysStatisticallyCheckBox.Checked;
end;

procedure TfrmAutomaticDayRemoval.okButtonClick(Sender: TObject);
var
  okToProcess: boolean;
  weekdaySTDDEV, weekendSTDDEV, interval: real;
begin
  oktoProcess := true;
  if (Length(AverageIntervalEdit.Text) > 0)
    then interval := strtofloat(AverageIntervalEdit.Text)
    else interval := 0.0;
  if (interval <= 0.0) then begin
    okToProcess := false;
    MessageDlg('The averaging interval must be greater than zero.',mtError,[mbOk],0);
  end;
  if (WeekdayRemoveDaysStatisticallyCheckBox.Checked) then begin
    if (Length(WeekdayStandardDeviationEdit.Text) > 0)
      then weekdaySTDDEV := strtofloat(WeekdayStandardDeviationEdit.Text)
      else weekdaySTDDEV := 0.0;
    if (weekdaySTDDEV <= 0.0) then begin
      okToProcess := false;
      MessageDlg('The Weekday Standard Deviation value must be greater than zero.',mtError,[mbOk],0);
    end;
  end;
  if (WeekendRemoveDaysStatisticallyCheckBox.Checked) then begin
    if (Length(WeekendStandardDeviationEdit.Text) > 0)
      then weekendSTDDEV := strtofloat(WeekendStandardDeviationEdit.Text)
      else weekendSTDDEV := 0.0;
    if (weekendSTDDEV <= 0.0) then begin
      okToProcess := false;
      MessageDlg('The Weekend Standard Deviation value must be greater than zero.',mtError,[mbOk],0);
    end;
  end;
  if (okToProcess) then begin
    AutomaticDayRemovalThread.CreateIt;
    frmFeedbackWithMemo.Caption := 'Automatic DWF Day Determination';
    frmFeedbackWithMemo.OpenForProcessing;
//    Close;
  end;
end;

procedure TfrmAutomaticDayRemoval.FormShow(Sender: TObject);
begin
  FlowMeterNameComboBox.Items := DatabaseModule.GetFlowMeterNames;
  FlowMeterNameComboBox.ItemIndex := 0;
  raingaugeNames := DatabaseModule.GetRaingaugeNames();
  WeekdayRaingaugeComboBox.Items := raingaugeNames;
  WeekendRaingaugeComboBox.Items := raingaugeNames;
  WeekdayRaingaugeComboBox.ItemIndex := 0;
  WeekendRaingaugeComboBox.ItemIndex := 0;
  if ((raingaugeNames.count) > 0) then begin
    UpdateDialogBasedOnSelectedWeekdayRaingauge();
    UpdateDialogBasedOnSelectedWeekendRaingauge();
    WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked := True;
    WeekendRemoveDaysBasedOnRainfallCheckBox.Checked := True;
    WeekdayRemoveDaysBasedOnRainfallCheckBox.Enabled := True;
    WeekendRemoveDaysBasedOnRainfallCheckBox.Enabled := True;
  end
  else begin
    WeekdayRemoveDaysBasedOnRainfallCheckBox.Checked := False;
    WeekendRemoveDaysBasedOnRainfallCheckBox.Checked := False;
    WeekdayRemoveDaysBasedOnRainfallCheckBox.Enabled := False;
    WeekendRemoveDaysBasedOnRainfallCheckBox.Enabled := False;
  end;
end;

procedure TfrmAutomaticDayRemoval.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAutomaticDayRemoval.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAutomaticDayRemoval.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmAutomaticDayRemoval.UpdateDialogBasedOnSelectedWeekdayRaingauge();
var
  raingaugeName, rainUnitLabel: string;
begin
  raingaugeName := WeekdayRaingaugeComboBox.Text;
  rainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(raingaugeName);
  WeekdayCurrentDayMaxRainLabel.Caption := 'Current Day Max Rain ('+rainUnitLabel+')';
  WeekdayPreviousDayMaxRainLabel.Caption := 'Previous Day Max Rain ('+rainUnitLabel+')';
  WeekdayTwoDaysPreviousMaxRainLabel.Caption := 'Two Days Previous Max Rain ('+rainUnitLabel+')';
end;

procedure TfrmAutomaticDayRemoval.UpdateDialogBasedOnSelectedWeekendRaingauge();
var
  raingaugeName, rainUnitLabel: string;
begin
  raingaugeName := WeekendRaingaugeComboBox.Text;
  rainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(raingaugeName);
  WeekendCurrentDayMaxRainLabel.Caption := 'Current Day Max Rain ('+rainUnitLabel+')';
  WeekendPreviousDayMaxRainLabel.Caption := 'Previous Day Max Rain ('+rainUnitLabel+')';
  WeekendTwoDaysPreviousMaxRainLabel.Caption := 'Two Days Previous Max Rain ('+rainUnitLabel+')';
end;

procedure TfrmAutomaticDayRemoval.WeekdayRaingaugeComboBoxChange(
  Sender: TObject);
begin
  UpdateDialogBasedOnSelectedWeekdayRaingauge();
end;

procedure TfrmAutomaticDayRemoval.WeekendRaingaugeComboBoxChange(
  Sender: TObject);
begin
  UpdateDialogBasedOnSelectedWeekendRaingauge();
end;

end.
