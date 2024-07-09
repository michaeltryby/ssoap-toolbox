unit importflowdatafromCONFile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmImportFlowFromCONFile = class(TForm)
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
    GroupBox2: TGroupBox;
    ConsiderZeroFlowsMissingDataCheckBox: TCheckBox;
    ConsiderNegativeFlowsMissingDataCheckBox: TCheckBox;
    AverageFlowsRadioButton: TRadioButton;
    FirstFlowRadioButton: TRadioButton;
    SecondFlowRadioButton: TRadioButton;
    FlowMeterNameComboBox: TComboBox;
    OpenDialog1: TOpenDialog;
    entireRangeRadioButton: TRadioButton;
    specifyRangeRadioButton: TRadioButton;
    StartDateTimeCheckBox: TCheckBox;
    EndDateTimeCheckBox: TCheckBox;
    EndDatePicker: TDateTimePicker;
    StartDatePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    y2kCheckBox: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure browseButtonClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure entireRangeRadioButtonClick(Sender: TObject);
    procedure specifyRangeRadioButtonClick(Sender: TObject);
    procedure StartDateTimeCheckBoxClick(Sender: TObject);
    procedure EndDateTimeCheckBoxClick(Sender: TObject);
    procedure FlowMeterNameComboBoxChange(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    procedure fillDialogFromSelectedMeter();
  public { Public declarations }
  end;

var
  frmImportFlowFromCONFile: TfrmImportFlowFromCONFile;

implementation

uses feedbackWithMemo, conFlowImportThread, modDatabase, DataAddReplace,
     rdiiutils, mainform;

{$R *.DFM}

procedure TfrmImportFlowFromCONFile.FormShow(Sender: TObject);
begin
  FlowMeterNameComboBox.Items := DatabaseModule.GetFlowMeterNames;
  FlowMeterNameComboBox.ItemIndex := 0;
  fillDialogFromSelectedMeter();
end;

procedure TfrmImportFlowFromCONFile.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmImportFlowFromCONFile.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImportFlowFromCONFile.browseButtonClick(Sender: TObject);
begin
  if (OpenDialog1.Execute) then FilenameEdit.Text := OpenDialog1.Filename;
end;

procedure TfrmImportFlowFromCONFile.okButtonClick(Sender: TObject);
var
  flowMeterName: string;
  okToImport: boolean;
  res: integer;
begin
  if fileCanBeRead(FilenameEdit.Text) then begin
    okToImport := true;
    flowMeterName := FlowMeterNameComboBox.Items.Strings[FlowMeterNameComboBox.ItemIndex];
    if (DatabaseModule.MeterHasFlowData(flowMeterName)) then begin
      frmDataAddReplace.WarningLabel.Caption := 'Flow Meter "'+flowMeterName+'" already has flow data.  Do you wish to add to the'+#13
        +'existing data, remove the existing data, or cancel the import?';
      res := frmDataAddReplace.ShowModal;
      case res of
 //       mrAll + 1:;   do nothing special if they want to add
        mrAll + 2: DatabaseModule.RemoveFlowsForMeter(flowMeterName);
        mrCancel: okToImport := false
      end;
    end;
    if (okToImport) then begin
      ImportY2KFlowThread.CreateIt();
      frmFeedbackWithMemo.Caption := 'Importing Flow Data from a .CON File';
      frmFeedbackWithMemo.OpenForProcessing;
      Close;
    end;
  end;
end;

procedure TfrmImportFlowFromCONFile.fillDialogFromSelectedMeter();
var
  flowMeterName, unitLabel: String;
begin
  flowMeterName := FlowMeterNameComboBox.Items.Strings[FlowMeterNameComboBox.ItemIndex];
  UnitsComboBox.Items := DatabaseModule.GetFlowUnitLabels();
  UnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
  UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(UnitLabel);
end;

procedure TfrmImportFlowFromCONFile.entireRangeRadioButtonClick(Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := False;
  EndDateTimeCheckBox.Enabled := False;
  StartDatePicker.Enabled := False;
  EndDatePicker.Enabled := False;
  StartTimePicker.Enabled := False;
  EndTimePicker.Enabled := False;
end;

procedure TfrmImportFlowFromCONFile.specifyRangeRadioButtonClick(Sender: TObject);
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

procedure TfrmImportFlowFromCONFile.StartDateTimeCheckBoxClick(
  Sender: TObject);
begin
  StartDatePicker.Enabled := StartDateTimeCheckBox.Checked;
  StartTimePicker.Enabled := StartDateTimeCheckBox.Checked;
end;

procedure TfrmImportFlowFromCONFile.EndDateTimeCheckBoxClick(
  Sender: TObject);
begin
  EndDatePicker.Enabled := EndDateTimeCheckBox.Checked;
  EndTimePicker.Enabled := EndDateTimeCheckBox.Checked;
end;

procedure TfrmImportFlowFromCONFile.FlowMeterNameComboBoxChange(
  Sender: TObject);
begin
  fillDialogFromSelectedMeter();
end;

end.
