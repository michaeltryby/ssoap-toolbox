unit exportprntraintabular;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Spin, ADODB_TLB;

type
  TfrmExportPRNTRAINTabular = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    FilenameEdit: TEdit;
    browseButton: TButton;
    UnitsComboBox: TComboBox;
    DateTimeGroupBox: TGroupBox;
    okButton: TButton;
    cancelButton: TButton;
    helpButton: TButton;
    RaingaugeNameComboBox: TComboBox;
    GroupBox1: TGroupBox;
    nonzeroObservationsRadioButton: TRadioButton;
    allObservationsRadioButton: TRadioButton;
    outputTimeStepLabel: TLabel;
    outputTimeStepSpinEdit: TSpinEdit;
    GroupBox2: TGroupBox;
    separateHoursMinutesRadioButton: TRadioButton;
    separateHoursRadioButton: TRadioButton;
    entireRangeRadioButton: TRadioButton;
    specifyRangeRadioButton: TRadioButton;
    StartDateTimeCheckBox: TCheckBox;
    EndDateTimeCheckBox: TCheckBox;
    StartDatePicker: TDateTimePicker;
    EndDatePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    SaveDialog1: TSaveDialog;
    procedure browseButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure entireRangeRadioButtonClick(Sender: TObject);
    procedure specifyRangeRadioButtonClick(Sender: TObject);
    procedure StartDateTimeCheckBoxClick(Sender: TObject);
    procedure EndDateTimeCheckBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RaingaugeNameComboBoxChange(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure allObservationsRadioButtonClick(Sender: TObject);
    procedure nonzeroObservationsRadioButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    DefStartDateTime, DefEndDateTime: TDateTime;
    procedure fillDialogFromSelectedRaingauge();
  public { Public declarations }
  end;

var
  frmExportPRNTRAINTabular: TfrmExportPRNTRAINTabular;

implementation

uses modDatabase, feedbackWithMemo, exportPRNTRAINThread,
     rdiiutils, mainform;

{$R *.DFM}

procedure TfrmExportPRNTRAINTabular.browseButtonClick(Sender: TObject);
begin
  if (SaveDialog1.Execute) then FilenameEdit.Text := SaveDialog1.Filename;
end;

procedure TfrmExportPRNTRAINTabular.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmExportPRNTRAINTabular.entireRangeRadioButtonClick(Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := False;
  EndDateTimeCheckBox.Enabled := False;
  StartDatePicker.Enabled := False;
  EndDatePicker.Enabled := False;
  StartTimePicker.Enabled := False;
  EndTimePicker.Enabled := False;

  StartDatePicker.DateTime := trunc(DefStartDateTime);
  StartTimePicker.DateTime := frac(DefStartDateTime);

  EndDatePicker.DateTime := trunc(DefEndDateTime);
  EndTimePicker.DateTime := frac(DefEndDateTime);
end;

procedure TfrmExportPRNTRAINTabular.specifyRangeRadioButtonClick(Sender: TObject);
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

procedure TfrmExportPRNTRAINTabular.StartDateTimeCheckBoxClick(Sender: TObject);
begin
  StartDatePicker.Enabled := StartDateTimeCheckBox.Checked;
  StartTimePicker.Enabled := StartDateTimeCheckBox.Checked;
end;

procedure TfrmExportPRNTRAINTabular.EndDateTimeCheckBoxClick(Sender: TObject);
begin
  EndDatePicker.Enabled := EndDateTimeCheckBox.Checked;
  EndTimePicker.Enabled := EndDateTimeCheckBox.Checked;
end;

procedure TfrmExportPRNTRAINTabular.FormShow(Sender: TObject);
begin
  RaingaugeNameComboBox.Items := DatabaseModule.GetRaingaugeNames();
  RaingaugeNameComboBox.ItemIndex := 0;
  fillDialogFromSelectedRaingauge();
end;

procedure TfrmExportPRNTRAINTabular.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmExportPRNTRAINTabular.fillDialogFromSelectedRaingauge();
var
  raingaugeName, unitLabel, queryStr: string;
  recSet: _RecordSet;
begin
  raingaugeName := raingaugeNameComboBox.Items.Strings[raingaugeNameComboBox.ItemIndex];

  queryStr := 'SELECT StartDateTime, EndDateTime, TimeStep FROM Raingauges WHERE ' +
              'RaingaugeName = "' + raingaugeName + '";';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    StartDatePicker.Date := TDateTime(recSet.Fields.Item[0].Value);
    EndDatePicker.Date := TDateTime(recSet.Fields.Item[1].Value);
    StartTimePicker.Time := TDateTime(recSet.Fields.Item[0].Value);
    EndTimePicker.Time := TDateTime(recSet.Fields.Item[1].Value);
    outputTimeStepSpinEdit.Value := recSet.Fields.Item[2].Value;

    DefStartDateTime:= trunc(StartDatePicker.Date) + frac(StartTimePicker.Time);
    DefEndDateTime:= trunc(EndDatePicker.Date) + frac(EndTimePicker.Time);
  end;
  recSet.Close;
  UnitsComboBox.Items := DatabaseModule.GetRainUnitLabels();
  UnitLabel := DatabaseModule.GetRainUnitLabelForRaingauge(raingaugeName);
  UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(UnitLabel);
end;

procedure TfrmExportPRNTRAINTabular.RaingaugeNameComboBoxChange(Sender: TObject);
begin
  fillDialogFromSelectedRaingauge();
end;

procedure TfrmExportPRNTRAINTabular.okButtonClick(Sender: TObject);
begin
  if fileCanBeWritten(FilenameEdit.Text) then begin
    PRNTRAINExportThread.CreateIt;
    frmFeedbackWithMemo.Caption := 'Exporting Rainfall Data in PRNTRAIN Format';
    frmFeedbackWithMemo.OpenForProcessing;
//    Close;
  end;
end;

procedure TfrmExportPRNTRAINTabular.allObservationsRadioButtonClick(Sender: TObject);
begin
//rm 2007-10-22 - I don't think this feature is working:
//  outputTimeStepLabel.Enabled := True;
//  outputTimeStepSpinEdit.Enabled := True;
end;

procedure TfrmExportPRNTRAINTabular.nonzeroObservationsRadioButtonClick(Sender: TObject);
begin
  outputTimeStepLabel.Enabled := False;
  outputTimeStepSpinEdit.Enabled := False;
end;

end.
