unit exportmaxminavgflow;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Spin, ADODB_TLB;

type
  TfrmExportMaxMinAvg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    FilenameEdit: TEdit;
    browseButton: TButton;
    UnitsComboBox: TComboBox;
    DateTimeRangeGroupBox: TGroupBox;
    okButton: TButton;
    cancelButton: TButton;
    helpButton: TButton;
    FlowMeterNameComboBox: TComboBox;
    WriteZeroMaximumsCheckBox: TCheckBox;
    WriteZeroMinimumsCheckBox: TCheckBox;
    WriteZeroAveragesCheckBox: TCheckBox;
    MaximumFlowAveragingDurationSpinEdit: TSpinEdit;
    MinimumFlowAveragingDurationSpinEdit: TSpinEdit;
    entireRangeRadioButton: TRadioButton;
    specifyRangeRadioButton: TRadioButton;
    StartDateTimeCheckBox: TCheckBox;
    EndDateTimeCheckBox: TCheckBox;
    StartDatePicker: TDateTimePicker;
    EndDatePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    SaveDialog1: TSaveDialog;
    procedure browseButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure entireRangeRadioButtonClick(Sender: TObject);
    procedure specifyRangeRadioButtonClick(Sender: TObject);
    procedure StartDateTimeCheckBoxClick(Sender: TObject);
    procedure EndDateTimeCheckBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FlowMeterNameComboBoxChange(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private    { Private declarations }
    procedure fillDialogFromSelectedMeter;
  public  { Public declarations }
  end;

var
  frmExportMaxMinAvg: TfrmExportMaxMinAvg;

implementation

uses modDatabase, feedbackWithMemo, exportMMADYThread, rdiiutils, mainform;

{$R *.DFM}

procedure TfrmExportMaxMinAvg.browseButtonClick(Sender: TObject);
begin
  if (SaveDialog1.Execute) then FilenameEdit.Text := SaveDialog1.Filename;
end;

procedure TfrmExportMaxMinAvg.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmExportMaxMinAvg.entireRangeRadioButtonClick(Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := False;
  EndDateTimeCheckBox.Enabled := False;
  StartDatePicker.Enabled := False;
  EndDatePicker.Enabled := False;
  StartTimePicker.Enabled := False;
  EndTimePicker.Enabled := False;
end;

procedure TfrmExportMaxMinAvg.specifyRangeRadioButtonClick(Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := True;
  EndDateTimeCheckBox.Enabled := True;
  if (StartDateTimeCheckBox.Checked) then begin
    StartDatePicker.Enabled := True;
    StartTimePicker.Enabled := True;
  end;
  if (EndDateTimeCheckBox.Checked) then begin
    EndDatePicker.Enabled := True;
    EndTimePicker.Enabled := True;
  end;
end;

procedure TfrmExportMaxMinAvg.StartDateTimeCheckBoxClick(Sender: TObject);
begin
  StartDatePicker.Enabled := StartDateTimeCheckBox.Checked;
  StartTimePicker.Enabled := StartDateTimeCheckBox.Checked;
end;

procedure TfrmExportMaxMinAvg.EndDateTimeCheckBoxClick(Sender: TObject);
begin
  EndDatePicker.Enabled := EndDateTimeCheckBox.Checked;
  EndTimePicker.Enabled := EndDateTimeCheckBox.Checked;
end;

procedure TfrmExportMaxMinAvg.FormShow(Sender: TObject);
begin
  FlowMeterNameComboBox.Items := DatabaseModule.GetFlowMeterNames;
  FlowMeterNameComboBox.ItemIndex := 0;
  fillDialogFromSelectedMeter();
end;

procedure TfrmExportMaxMinAvg.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmExportMaxMinAvg.fillDialogFromSelectedMeter();
var
  flowMeterName, unitLabel, queryStr: String;
  recSet: _RecordSet;
begin
  flowMeterName := FlowMeterNameComboBox.Items.Strings[FlowMeterNameComboBox.ItemIndex];

  queryStr := 'SELECT StartDateTime, EndDateTime FROM Meters WHERE ' +
              'MeterName = "' + flowMeterName + '";';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    StartDatePicker.Date := TDateTime(recSet.Fields.Item[0].Value);
    EndDatePicker.Date := TDateTime(recSet.Fields.Item[1].Value);
    StartTimePicker.Time := TDateTime(recSet.Fields.Item[0].Value);
    EndTimePicker.Time := TDateTime(recSet.Fields.Item[1].Value);
  end;
  recSet.Close;

  UnitsComboBox.Items := DatabaseModule.GetFlowUnitLabels();
  UnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
  UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(UnitLabel);
end;

procedure TfrmExportMaxMinAvg.FlowMeterNameComboBoxChange(Sender: TObject);
begin
  fillDialogFromSelectedMeter();
end;

procedure TfrmExportMaxMinAvg.okButtonClick(Sender: TObject);
begin
  if fileCanBeWritten(FilenameEdit.Text) then begin
    MMADYExportThread.CreateIt;
    frmFeedbackWithMemo.Caption := 'Exporting Max, Min, Avg Flows';
    frmFeedbackWithMemo.OpenForProcessing;
    Close;
  end;
end;

end.
