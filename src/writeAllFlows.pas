unit writeAllFlows;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmWriteAllFlows = class(TForm)
    Label1: TLabel;
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
    Label2: TLabel;
    FilenameEdit: TEdit;
    browseButton: TButton;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    SaveDialog1: TSaveDialog;
    UpDown1: TUpDown;
    EdPrecision: TEdit;
    Label3: TLabel;
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure entireRangeRadioButtonClick(Sender: TObject);
    procedure specifyRangeRadioButtonClick(Sender: TObject);
    procedure StartDateTimeCheckBoxClick(Sender: TObject);
    procedure EndDateTimeCheckBoxClick(Sender: TObject);
    procedure browseButtonClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure helpButtonClick(Sender: TObject);
    procedure AnalysisNameComboBoxChange(Sender: TObject);
  private { Private declarations }
    //rm 2007-10-18 - check for no data
    //procedure fillDialogFromAnalysis();
    Function fillDialogFromAnalysis(): boolean;
  public { Public declarations }
    function GetPrecision: Integer;
  end;

var
  frmWriteAllFlows: TfrmWriteAllFlows;

implementation

uses modDatabase, hydrograph, GWIAdjustmentCollection,
     StormEventCollection, StormEvent, feedbackWithMemo, writeAllFlowsThrd,
     rdiiutils, mainform;

{$R *.DFM}

procedure TfrmWriteAllFlows.FormShow(Sender: TObject);
begin
  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames();
  if AnalysisNameComboBox.Items.Count > 0 then
    AnalysisNameComboBox.ItemIndex := 0;
  if not fillDialogFromAnalysis then
    MessageDlg('No flow data!',mtError,[mbok],0);
end;

function TfrmWriteAllFlows.GetPrecision: Integer;
var i:integer;
begin
  i := Pos('.',EdPrecision.Text);
  if i > 0 then begin
    i := Length(EdPrecision.Text) - i;
  end else begin
    i := 0;
  end;
  Result := i;
end;

procedure TfrmWriteAllFlows.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmWriteAllFlows.entireRangeRadioButtonClick(Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := False;
  EndDateTimeCheckBox.Enabled := False;
  StartDatePicker.Enabled := False;
  EndDatePicker.Enabled := False;
  StartTimePicker.Enabled := False;
  EndTimePicker.Enabled := False;
end;

procedure TfrmWriteAllFlows.specifyRangeRadioButtonClick(Sender: TObject);
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

procedure TfrmWriteAllFlows.StartDateTimeCheckBoxClick(Sender: TObject);
begin
  StartDatePicker.Enabled := StartDateTimeCheckBox.Checked;
  StartTimePicker.Enabled := StartDateTimeCheckBox.Checked;
end;

procedure TfrmWriteAllFlows.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var s:string;
begin
  if Button = btNext then begin
    if pos('.',EdPrecision.Text) > 0 then begin
      EdPrecision.Text := EdPrecision.Text + '0';
    end else begin
      EdPrecision.Text := '0.0';
    end;
  end else begin
    if pos('.',EdPrecision.Text) > 0 then begin
      s := EdPrecision.Text;
      SetLength(s,Length(EdPrecision.Text)-1);
      EdPrecision.Text := s;
    end else begin
      EdPrecision.Text := '0.';
    end;
    if Length(EdPrecision.Text) < 2 then EdPrecision.text := '0.';
  end;
end;

procedure TfrmWriteAllFlows.EndDateTimeCheckBoxClick(Sender: TObject);
begin
  EndDatePicker.Enabled := EndDateTimeCheckBox.Checked;
  EndTimePicker.Enabled := EndDateTimeCheckBox.Checked;
end;

procedure TfrmWriteAllFlows.AnalysisNameComboBoxChange(Sender: TObject);
begin
  if not fillDialogFromAnalysis then
    MessageDlg('No flow data!',mtError,[mbok],0);
end;

procedure TfrmWriteAllFlows.browseButtonClick(Sender: TObject);
begin
  if (SaveDialog1.Execute) then
    FilenameEdit.Text := SaveDialog1.Filename;
end;

procedure TfrmWriteAllFlows.okButtonClick(Sender: TObject);
begin
  if fileCanBeWritten(FilenameEdit.Text) then begin
    writeAllFlowsThread.CreateIt();
    frmFeedbackWithMemo.Caption := 'Write All Flows';
    frmFeedbackWithMemo.OpenForProcessing;
//    Close;
  end;
end;

function TfrmWriteAllFlows.fillDialogFromAnalysis(): boolean;
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

procedure TfrmWriteAllFlows.cancelButtonClick(Sender: TObject);
begin
  //Close;
  ModalResult := mrCancel;
end;

end.
