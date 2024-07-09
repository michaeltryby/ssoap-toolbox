unit exportprntflowcsv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, ADODB_TLB;

type
  TfrmExportPRNTFLOWCSV = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    FilenameEdit: TEdit;
    browseButton: TButton;
    UnitsComboBox: TComboBox;
    DateTimeRangeGroupBox: TGroupBox;
    okButton: TButton;
    cancelButton: TButton;
    helpButton: TButton;
    FlowMeterNameComboBox: TComboBox;
    entireRangeRadioButton: TRadioButton;
    specifyRangeRadioButton: TRadioButton;
    StartDateTimeCheckBox: TCheckBox;
    EndDateTimeCheckBox: TCheckBox;
    StartDatePicker: TDateTimePicker;
    EndDatePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    SaveDialog1: TSaveDialog;
    procedure cancelButtonClick(Sender: TObject);
    procedure browseButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure FlowMeterNameComboBoxChange(Sender: TObject);
    procedure entireRangeRadioButtonClick(Sender: TObject);
    procedure specifyRangeRadioButtonClick(Sender: TObject);
    procedure StartDateTimeCheckBoxClick(Sender: TObject);
    procedure EndDateTimeCheckBoxClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private
    procedure fillDialogFromSelectedMeter;
  public
  end;

var
  frmExportPRNTFLOWCSV: TfrmExportPRNTFLOWCSV;

implementation

uses modDatabase, exportPRNTFLOWThread, feedbackWithMemo, rdiiutils, mainform;

{$R *.DFM}

procedure TfrmExportPRNTFLOWCSV.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmExportPRNTFLOWCSV.browseButtonClick(Sender: TObject);
begin
  if (SaveDialog1.Execute) then FilenameEdit.Text := SaveDialog1.Filename;
end;

procedure TfrmExportPRNTFLOWCSV.FormShow(Sender: TObject);
begin
  FlowMeterNameComboBox.Items := DatabaseModule.GetFlowMeterNames;
  FlowMeterNameComboBox.ItemIndex := 0;
  fillDialogFromSelectedMeter();
end;

procedure TfrmExportPRNTFLOWCSV.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmExportPRNTFLOWCSV.okButtonClick(Sender: TObject);
begin
  if fileCanBeWritten(FilenameEdit.Text) then begin
    PRNTFLOWExportThread.CreateIt;
    frmFeedbackWithMemo.Caption := 'Exporting Flow in PRNTFLOW Format';
    frmFeedbackWithMemo.OpenForProcessing;
//    Close;
  end;
end;

procedure TfrmExportPRNTFLOWCSV.FlowMeterNameComboBoxChange(Sender: TObject);
begin
  fillDialogFromSelectedMeter();
end;

procedure TfrmExportPRNTFLOWCSV.fillDialogFromSelectedMeter();
var
  flowMeterName, unitLabel, queryStr: string;
  recSet: _RecordSet;
begin
  flowMeterName := FlowMeterNameComboBox.Items.Strings[FlowMeterNameComboBox.ItemIndex];

  queryStr := 'SELECT StartDateTime, EndDateTime FROM Meters WHERE ' +
              'MeterName = "' + flowMeterName + '";';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    try
      StartDatePicker.Date := TDateTime(recSet.Fields.Item[0].Value);
      EndDatePicker.Date := TDateTime(recSet.Fields.Item[1].Value);
      StartTimePicker.Time := TDateTime(recSet.Fields.Item[0].Value);
      EndTimePicker.Time := TDateTime(recSet.Fields.Item[1].Value);
    except on E: Exception do begin

    end;

    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;

  UnitsComboBox.Items := DatabaseModule.GetFlowUnitLabels();
  UnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
  UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(UnitLabel);
end;

procedure TfrmExportPRNTFLOWCSV.entireRangeRadioButtonClick(Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := False;
  EndDateTimeCheckBox.Enabled := False;
  StartDatePicker.Enabled := False;
  EndDatePicker.Enabled := False;
  StartTimePicker.Enabled := False;
  EndTimePicker.Enabled := False;
end;

procedure TfrmExportPRNTFLOWCSV.specifyRangeRadioButtonClick(Sender: TObject);
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

procedure TfrmExportPRNTFLOWCSV.StartDateTimeCheckBoxClick(
  Sender: TObject);
begin
  StartDatePicker.Enabled := StartDateTimeCheckBox.Checked;
  StartTimePicker.Enabled := StartDateTimeCheckBox.Checked;
end;

procedure TfrmExportPRNTFLOWCSV.EndDateTimeCheckBoxClick(Sender: TObject);
begin
  EndDatePicker.Enabled := EndDateTimeCheckBox.Checked;
  EndTimePicker.Enabled := EndDateTimeCheckBox.Checked;
end;

end.
