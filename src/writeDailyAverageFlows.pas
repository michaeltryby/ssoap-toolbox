unit writeDailyAverageFlows;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmWriteDailyAverageFlows = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    AnalysisNameComboBox: TComboBox;
    DateTimeRangeGroupBox: TGroupBox;
    entireRangeRadioButton: TRadioButton;
    specifyRangeRadioButton: TRadioButton;
    StartDateTimeCheckBox: TCheckBox;
    EndDateTimeCheckBox: TCheckBox;
    StartDatePicker: TDateTimePicker;
    EndDatePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    FilenameEdit: TEdit;
    browseButton: TButton;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    SaveDialog1: TSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure browseButtonClick(Sender: TObject);
    procedure entireRangeRadioButtonClick(Sender: TObject);
    procedure specifyRangeRadioButtonClick(Sender: TObject);
    procedure StartDateTimeCheckBoxClick(Sender: TObject);
    procedure EndDateTimeCheckBoxClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    //rm 2007-10-18 - check for no data
    //procedure fillDialogFromAnalysis();
    Function fillDialogFromAnalysis(): boolean;
  public
    { Public declarations }
  end;

var
  frmWriteDailyAverageFlows: TfrmWriteDailyAverageFlows;

implementation

uses rdiiutils, modDatabase, hydrograph, GWIAdjustmentCollection,
     feedbackWithMemo, writeDailyAverageFlowsThrd, mainform;

{$R *.DFM}

procedure TfrmWriteDailyAverageFlows.FormShow(Sender: TObject);
begin
  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames();
  AnalysisNameComboBox.ItemIndex := 0;
  if not fillDialogFromAnalysis then
    MessageDlg('No flow data!', mtError, [mbok], 0);
end;

procedure TfrmWriteDailyAverageFlows.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmWriteDailyAverageFlows.browseButtonClick(Sender: TObject);
begin
  if (SaveDialog1.Execute) then FilenameEdit.Text := SaveDialog1.Filename;
end;

procedure TfrmWriteDailyAverageFlows.entireRangeRadioButtonClick(Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := False;
  EndDateTimeCheckBox.Enabled := False;
  StartDatePicker.Enabled := False;
  EndDatePicker.Enabled := False;
  StartTimePicker.Enabled := False;
  EndTimePicker.Enabled := False;
end;

procedure TfrmWriteDailyAverageFlows.specifyRangeRadioButtonClick(Sender: TObject);
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

procedure TfrmWriteDailyAverageFlows.StartDateTimeCheckBoxClick(
  Sender: TObject);
begin
  StartDatePicker.Enabled := StartDateTimeCheckBox.Checked;
  StartTimePicker.Enabled := StartDateTimeCheckBox.Checked;
end;

procedure TfrmWriteDailyAverageFlows.EndDateTimeCheckBoxClick(
  Sender: TObject);
begin
  EndDatePicker.Enabled := EndDateTimeCheckBox.Checked;
  EndTimePicker.Enabled := EndDateTimeCheckBox.Checked;
end;

procedure TfrmWriteDailyAverageFlows.okButtonClick(Sender: TObject);
begin
  if fileCanBeWritten(FilenameEdit.Text) then begin
    WriteDailyAverageFlowsThread.CreateIt();
    frmFeedbackWithMemo.Caption := 'Write Daily Average Flows';
    frmFeedbackWithMemo.OpenForProcessing;
//    Close;
  end;
end;

Function TfrmWriteDailyAverageFlows.fillDialogFromAnalysis(): boolean;
var
  flowMeterName: String;
  startDateTime, endDateTime: TDateTime;
  meterID: integer;
begin
  flowMeterName := DatabaseModule.GetFlowMeterNameForAnalysis(AnalysisNameComboBox.Text);
  meterID := DatabaseModule.GetMeterIDForName(flowMeterName);
  startDateTime := DatabaseModule.GetStartDateTime(meterID);
  endDateTime := DatabaseModule.GetEndDateTime(meterID);
  //rm 2007-10-18 - prevent crash if no data
  if startDateTime > 0 then begin
    StartDatePicker.Date := startDateTime;
    StartTimePicker.Time := startDateTime;
    EndDatePicker.Date := endDateTime;
    EndTimePicker.Time := endDateTime;
    Result := true;
  end else begin
    Result := false;
  end;
end;

procedure TfrmWriteDailyAverageFlows.cancelButtonClick(Sender: TObject);
begin
//  Close;
  modalresult := mrCancel;
end;

end.
