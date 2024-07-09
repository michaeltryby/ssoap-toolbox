unit convertraintimestep;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin;

type
  integerPointer = ^integer;
  realPointer = ^real;
  TfrmConvertRainTimeStep = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CurrentTimeStepEdit: TEdit;
    NewTimeStepSpinEdit_deprecated: TSpinEdit;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    RaingaugeNameComboBox: TComboBox;
    ComboBoxNewTimeStep: TComboBox;
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RaingaugeNameComboBoxChange(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure CurrentTimeStepEditChange(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private    { Private declarations }
    procedure fillDialogFromSelectedRaingauge();
  public    { Public declarations }
  end;

var
  frmConvertRainTimeStep: TfrmConvertRainTimeStep;

implementation

uses modDatabase, feedbackWithMemo, convertRainTimestepThrd, mainform;

{$R *.DFM}

procedure TfrmConvertRainTimeStep.FormShow(Sender: TObject);
begin
  RaingaugeNameComboBox.Items := DatabaseModule.GetRaingaugeNames;
  RaingaugeNameComboBox.ItemIndex := 0;
  fillDialogFromSelectedRaingauge();
end;

procedure TfrmConvertRainTimeStep.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmConvertRainTimeStep.CurrentTimeStepEditChange(Sender: TObject);
var oldVal, i: integer;
//assemble all of the possible new values for timestep
//these all go into 60 nicely:
const newVals: Array [0..11] of integer =
  (1,2,3,4,5,6,10,12,15,20,30,60);
begin
//get the valid timesteps for the comboboxnewtimestep
  oldVal := strtoint(CurrentTimeStepEdit.text);
  i := 0;
  ComboBoxNewTimeStep.Clear;
  //if smaller, newval must go into oldval
  While (newVals[i] < oldVal) and (i <= High(newVals)) do begin
    if ((oldVal mod newVals[i]) = 0) then
      ComboBoxNewTimeStep.Items.Add(inttostr(newVals[i]));
    inc(i);
  end;
  inc(i);
  //if larger, oldval must go into newval
  While i <= High(newVals) do begin
    if ((newVals[i] mod oldVal) = 0) then
      ComboBoxNewTimeStep.Items.Add(inttostr(newVals[i]));
    inc(i);
  end;
  if ComboBoxNewTimeStep.Items.count > 0 then
    ComboBoxNewTimeStep.ItemIndex := 0;
end;

procedure TfrmConvertRainTimeStep.fillDialogFromSelectedRaingauge();
var
  raingaugeName: string;
  raingaugeID, timestep: integer;
begin
  raingaugeName := raingaugeNameComboBox.Items.Strings[raingaugeNameComboBox.ItemIndex];
  raingaugeID := DatabaseModule.GetRaingaugeIDForName(raingaugeName);
  timestep := DatabaseModule.GetRainfallTimestep(raingaugeID);
  CurrentTimeStepEdit.Text := inttostr(timestep);
end;

procedure TfrmConvertRainTimeStep.RaingaugeNameComboBoxChange(
  Sender: TObject);
begin
  fillDialogFromSelectedRaingauge();
end;

procedure TfrmConvertRainTimeStep.okButtonClick(Sender: TObject);
var
  oldTimeStep, newTimeStep: integer;
  okToProcess: boolean;
  raingaugeName: string;
  analysisNames: TStringList;
begin
  okToProcess := true;
  oldTimeStep := strtoint(CurrentTimeStepEdit.Text);
  //newTimeStep := NewTimeStepSpinEdit.Value;
  newTimeStep := strToInt(ComboBoxNewTimeStep.Text);
  if ((newTimeStep < oldTimeStep) and ((oldTimeStep mod newTimeStep) <> 0)) then begin
    okToProcess := false;
    MessageDlg('The new time step must evenly divide the current time step.',mtError,[mbOK],0);
  end;
  if ((newTimeStep > oldTimeStep) and ((newTimeStep mod oldTimeStep) <> 0)) then begin
    okToProcess := false;
    MessageDlg('The new time step must be an integer multiple of the current time step.',mtError,[mbOK],0);
  end;
  if (newTimeStep = oldTimeStep) then begin
    okToProcess := false;
    MessageDlg('The current and new time steps must be different.',mtError,[mbOK],0);
  end;
  if ((60 mod newTimeStep) <> 0) then begin
    okToProcess := false;
    MessageDlg('The new time step must evenly divide 60.',mtError,[mbOK],0);
  end;
  raingaugeName := raingaugeNameComboBox.Items.Strings[raingaugeNameComboBox.ItemIndex];
  analysisNames := DatabaseModule.AnalysesUsingRaingauge(raingaugeName);
  if (analysisNames.count > 0) then begin
    okToProcess := false;
    MessageDlg('The time step cannot be changed because this rainfall data is used in the following analyses:'+#13#13+analysisNames.Text,mtError,[mbOK],0);
  end;
  if (okToProcess) then begin
    convertRainTimestepThread.CreateIt();
    frmFeedbackWithMemo.Caption := 'Rainfall Timestep Conversion';
    frmFeedbackWithMemo.OpenForProcessing;
    Close;
  end;
end;

procedure TfrmConvertRainTimeStep.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

end.
