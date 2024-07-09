unit importflowdata;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Spin;

type
  TfrmImportFlowDataUsingConverter = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    FilenameEdit: TEdit;
    browseButton: TButton;
    ConverterComboBox: TComboBox;
    DateTimeRangeGroupBox: TGroupBox;
    okButton: TButton;
    cancelButton: TButton;
    helpButton: TButton;
    GroupBox2: TGroupBox;
    ConsiderZeroFlowsMissingDataCheckBox: TCheckBox;
    ConsiderNegativeFlowsMissingDataCheckBox: TCheckBox;
    AverageFlowsRadioButton: TRadioButton;
    FirstFlowRadioButton: TRadioButton;
    FlowMeterNameComboBox: TComboBox;
    OpenDialog1: TOpenDialog;
    SecondFlowRadioButton: TRadioButton;
    entireRangeRadioButton: TRadioButton;
    specifyRangeRadioButton: TRadioButton;
    StartDateTimeCheckBox: TCheckBox;
    EndDateTimeCheckBox: TCheckBox;
    EndDatePicker: TDateTimePicker;
    StartDatePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure specifyRangeRadioButtonClick(Sender: TObject);
    procedure entireRangeRadioButtonClick(Sender: TObject);
    procedure StartDateTimeCheckBoxClick(Sender: TObject);
    procedure EndDateTimeCheckBoxClick(Sender: TObject);
    procedure browseButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
  public { Public declarations }
  end;

var
  frmImportFlowDataUsingConverter: TfrmImportFlowDataUsingConverter;

implementation

uses modDatabase, feedbackWithMemo, flowConverterImportThread,
  DataAddReplace, rdiiutils, mainform;

{$R *.DFM}

procedure TfrmImportFlowDataUsingConverter.okButtonClick(Sender: TObject);
var
  okToImport: boolean;
  flowMeterName: string;
  res: integer;
begin
  if fileCanBeRead(FilenameEdit.Text) then begin
    flowMeterName := FlowMeterNameComboBox.Items.Strings[FlowMeterNameComboBox.ItemIndex];
    okToImport := (length(trim(flowmeterName)) > 0);
    if (length(trim(flowmeterName)) < 1) then
      MessageDlg('Please select a flow meter.',mtError,[mbok],0)
    else if (DatabaseModule.MeterHasFlowData(flowMeterName)) then begin
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
      ConverterImportThread.CreateIt();
      frmFeedbackWithMemo.Caption := 'Importing Flow Data Using Converter';
      frmFeedbackWithMemo.OpenForProcessing;
//      Close;
    end;
  end;
end;

procedure TfrmImportFlowDataUsingConverter.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImportFlowDataUsingConverter.FormShow(Sender: TObject);
begin
  ConverterComboBox.Items := DatabaseModule.GetFlowConverterNames;
  ConverterComboBox.ItemIndex := 0;
  FlowMeterNameComboBox.Items := DatabaseModule.GetFlowMeterNames;
  FlowMeterNameComboBox.ItemIndex := 0;
end;

procedure TfrmImportFlowDataUsingConverter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmImportFlowDataUsingConverter.specifyRangeRadioButtonClick(Sender: TObject);
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

procedure TfrmImportFlowDataUsingConverter.entireRangeRadioButtonClick(Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := False;
  EndDateTimeCheckBox.Enabled := False;
  StartDatePicker.Enabled := False;
  EndDatePicker.Enabled := False;
  StartTimePicker.Enabled := False;
  EndTimePicker.Enabled := False;
end;

procedure TfrmImportFlowDataUsingConverter.StartDateTimeCheckBoxClick(
  Sender: TObject);
begin
  StartDatePicker.Enabled := StartDateTimeCheckBox.Checked;
  StartTimePicker.Enabled := StartDateTimeCheckBox.Checked;
end;

procedure TfrmImportFlowDataUsingConverter.EndDateTimeCheckBoxClick(
  Sender: TObject);
begin
  EndDatePicker.Enabled := EndDateTimeCheckBox.Checked;
  EndTimePicker.Enabled := EndDateTimeCheckBox.Checked;
end;

procedure TfrmImportFlowDataUsingConverter.browseButtonClick(Sender: TObject);
begin
  if (OpenDialog1.Execute) then FilenameEdit.Text := OpenDialog1.Filename;
end;

end.
