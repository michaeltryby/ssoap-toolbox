unit RainfallCharacteristicAnalysis;

interface

uses
  {Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, ComCtrls, StdCtrls, ExtCtrls, Spin, ADODB_TLB;}

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Spin, ADODB_TLB;

type
  TfrmRainfallCharacteristicAnalysis = class(TForm)
    Label3: TLabel;
    DateTimeGroupBox: TGroupBox;
    cancelButton: TButton;
    helpButton: TButton;
    RaingaugeNameComboBox: TComboBox;
    entireRangeRadioButton: TRadioButton;
    specifyRangeRadioButton: TRadioButton;
    StartDateTimeCheckBox: TCheckBox;
    EndDateTimeCheckBox: TCheckBox;
    StartDatePicker: TDateTimePicker;
    EndDatePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    UserOptions: TGroupBox;
    mit_hour: TSpinEdit;
    Label4: TLabel;
    RainfallAnaysis: TButton;
    rainfallTimeStepSpinEdit: TSpinEdit;
    DryPeriodDefinitionSpinEdit: TSpinEdit;
    Label1: TLabel;
    procedure cancelButtonClick(Sender: TObject);
    procedure entireRangeRadioButtonClick(Sender: TObject);
    procedure specifyRangeRadioButtonClick(Sender: TObject);
    procedure StartDateTimeCheckBoxClick(Sender: TObject);
    procedure EndDateTimeCheckBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RaingaugeNameComboBoxChange(Sender: TObject);
    procedure RainfallAnaysisClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
    //procedure DryPeriodDefinitionSpinEditChange(Sender: TObject);
    //procedure SWMM4buttonClick(Sender: TObject);
    //procedure helpButtonClick(Sender: TObject);

  private { Private declarations }
    procedure fillDialogFromSelectedRaingauge();
  public { Public declarations }
  end;

var
  frmRainfallCharacteristicAnalysis: TfrmRainfallCharacteristicAnalysis;

implementation

uses modDatabase, feedbackWithMemo, RainfallCharacteristicAnalysisThrd, mainform,
     rdiiutils;

{$R *.DFM}


procedure TfrmRainfallCharacteristicAnalysis.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRainfallCharacteristicAnalysis.entireRangeRadioButtonClick(Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := False;
  EndDateTimeCheckBox.Enabled := False;
  StartDatePicker.Enabled := False;
  EndDatePicker.Enabled := False;
  StartTimePicker.Enabled := False;
  EndTimePicker.Enabled := False;
end;

procedure TfrmRainfallCharacteristicAnalysis.specifyRangeRadioButtonClick(Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := True;
  EndDateTimeCheckBox.Enabled := True;
  {if (StartDateTimeCheckBox.Checked) then begin}
    StartDatePicker.Enabled := True;
    StartTimePicker.Enabled := True;
  {end;}
  {if (EndDateTimeCheckBox.Checked) then begin}
    EndDatePicker.Enabled := True;
    EndTimePicker.Enabled := True;
  {end;}
end;

procedure TfrmRainfallCharacteristicAnalysis.StartDateTimeCheckBoxClick(Sender: TObject);
begin
  StartDatePicker.Enabled := StartDateTimeCheckBox.Checked;
  StartTimePicker.Enabled := StartDateTimeCheckBox.Checked;
end;

procedure TfrmRainfallCharacteristicAnalysis.EndDateTimeCheckBoxClick(Sender: TObject);
begin
  EndDatePicker.Enabled := EndDateTimeCheckBox.Checked;
  EndTimePicker.Enabled := EndDateTimeCheckBox.Checked;
end;

procedure TfrmRainfallCharacteristicAnalysis.FormShow(Sender: TObject);
begin
  RaingaugeNameComboBox.Items := DatabaseModule.GetRaingaugeNames();
  RaingaugeNameComboBox.ItemIndex := 0;
  fillDialogFromSelectedRaingauge();

end;

procedure TfrmRainfallCharacteristicAnalysis.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmRainfallCharacteristicAnalysis.fillDialogFromSelectedRaingauge();
var
  raingaugeName, UnitLabel, queryStr: String;
  recSet: _RecordSet;

begin
  raingaugeName := raingaugeNameComboBox.Items.Strings[raingaugeNameComboBox.ItemIndex];

  queryStr := 'SELECT StartDateTime, EndDateTime, TimeStep FROM Raingauges WHERE ' +
              'RainGaugeName = "' + raingaugeName + '";';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    StartDatePicker.Date := TDateTime(recSet.Fields.Item[0].Value);
    EndDatePicker.Date := TDateTime(recSet.Fields.Item[1].Value);
    StartTimePicker.Time := TDateTime(recSet.Fields.Item[0].Value);
    EndTimePicker.Time := TDateTime(recSet.Fields.Item[1].Value);
    rainfallTimeStepSpinEdit.value := recSet.Fields.item[2].Value;
  end;
  recSet.Close;

  UnitLabel := DatabaseModule.GetRainUnitLabelForRaingauge(raingaugeName);

end;

procedure TfrmRainfallCharacteristicAnalysis.RaingaugeNameComboBoxChange(Sender: TObject);
begin
  fillDialogFromSelectedRaingauge();
end;

//procedure TfrmRainfallCharacteristicAnalysis.SWMM4buttonClick(Sender: TObject);
//begin
//  if fileCanBeWritten(FilenameEdit.Text) then begin
//    RAINtoSWMMThread.CreateIt;
//    frmFeedbackWithMemo.Caption := 'Exporting Rainfall Data in PRNTRAIN Format';
//    frmFeedbackWithMemo.OpenForProcessing;
//    Close;
//  end;
//end;



//procedure TfrmRainfallCharacteristicAnalysis.helpButtonClick(Sender: TObject);
//begin
//    rainfallcharacteristicanalysisthread.CreateIt;
//    frmFeedbackWithMemo.Caption := 'Exporting Rainfall Data in PRNTRAIN Format';
//    frmFeedbackWithMemo.OpenForProcessing;
//    Close;

//end;






procedure TfrmRainfallCharacteristicAnalysis.RainfallAnaysisClick(
  Sender: TObject);
begin
  RainfallCharacteristicAnalysisThread.CreateIt;
  frmFeedbackWithMemo.Caption := 'Analyzing Rainfall Data ...';
  frmFeedbackWithMemo.OpenForProcessing;
end;

end.
