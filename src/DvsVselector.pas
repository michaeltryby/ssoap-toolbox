unit DvsVselector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ADODB_TLB, ExtCtrls;

type
  TfrmScatterGraphSelector = class(TForm)
    DateTimeRangeGroupBox: TGroupBox;
    entireRangeRadioButton: TRadioButton;
    specifyRangeRadioButton: TRadioButton;
    StartDateTimeCheckBox: TCheckBox;
    EndDateTimeCheckBox: TCheckBox;
    StartDatePicker: TDateTimePicker;
    EndDatePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    FlowMeterNameComboBox: TComboBox;
    Label1: TLabel;
    weeklyDisplayRadioButton: TRadioButton;
    dailyDisplayRadioButton: TRadioButton;
    okButton: TButton;
    cancelButton: TButton;
    RadioGroupType: TRadioGroup;
    
    procedure fillDialogFromSelectedMeter();
    procedure FormShow(Sender: TObject);
    procedure specifyRangeRadioButtonClick(Sender: TObject);
    procedure StartDateTimeCheckBoxClick(Sender: TObject);
    procedure EndDateTimeCheckBoxClick(Sender: TObject);
    procedure entireRangeRadioButtonClick(Sender: TObject);
    procedure weeklyDisplayRadioButtonClick(Sender: TObject);
    procedure dailyDisplayRadioButtonClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure setSelectedGraphType;
  public
    SelectedGraphType: string;
    function SelectedMeter(): string;
    { Public declarations }
  end;

var
  frmScatterGraphSelector: TfrmScatterGraphSelector;

implementation

uses moddatabase, mainform, scattergraph, scattergraphDF;

{$R *.dfm}

procedure TfrmScatterGraphSelector.FormShow(Sender: TObject);
begin
  FlowMeterNameComboBox.Items := DatabaseModule.GetFlowMeterNames;
  FlowMeterNameComboBox.ItemIndex := 0;
  fillDialogFromSelectedMeter();
  setSelectedGraphType;
end;

procedure TfrmScatterGraphSelector.okButtonClick(Sender: TObject);
begin
  if flowmeternamecombobox.ItemIndex < 0 then begin
    MessageDlg('No Flow Meter selected.',mtError,[mbok],0);
  end else begin
    if RadioGroupType.ItemIndex = 0 then
      frmScatterGraphDF.ShowModal
    else
      frmScatterGraph.ShowModal;
  end;
end;

procedure TfrmScatterGraphSelector.setSelectedGraphType;
begin
  if SelectedGraphType = 'DF' then
    RadioGroupType.ItemIndex := 0
  else
    RadioGroupType.ItemIndex := 1;
end;

procedure TfrmScatterGraphSelector.specifyRangeRadioButtonClick(
  Sender: TObject);
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

procedure TfrmScatterGraphSelector.StartDateTimeCheckBoxClick(Sender: TObject);
begin
  StartDatePicker.Enabled := StartDateTimeCheckBox.Checked;
  StartTimePicker.Enabled := StartDateTimeCheckBox.Checked;
end;

procedure TfrmScatterGraphSelector.weeklyDisplayRadioButtonClick(
  Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := False;
  EndDateTimeCheckBox.Enabled := False;
  StartDatePicker.Enabled := False;
  EndDatePicker.Enabled := False;
  StartTimePicker.Enabled := False;
  EndTimePicker.Enabled := False;
  fillDialogFromSelectedMeter();

end;

procedure TfrmScatterGraphSelector.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmScatterGraphSelector.dailyDisplayRadioButtonClick(
  Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := False;
  EndDateTimeCheckBox.Enabled := False;
  StartDatePicker.Enabled := False;
  EndDatePicker.Enabled := False;
  StartTimePicker.Enabled := False;
  EndTimePicker.Enabled := False;
  fillDialogFromSelectedMeter();
end;

procedure TfrmScatterGraphSelector.EndDateTimeCheckBoxClick(Sender: TObject);
begin
  EndDatePicker.Enabled := EndDateTimeCheckBox.Checked;
  EndTimePicker.Enabled := EndDateTimeCheckBox.Checked;
end;

procedure TfrmScatterGraphSelector.entireRangeRadioButtonClick(Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := False;
  EndDateTimeCheckBox.Enabled := False;
  StartDatePicker.Enabled := False;
  EndDatePicker.Enabled := False;
  StartTimePicker.Enabled := False;
  EndTimePicker.Enabled := False;
  fillDialogFromSelectedMeter();
end;

procedure TfrmScatterGraphSelector.fillDialogFromSelectedMeter();
var
  flowMeterName, queryStr: string;
  recSet: _RecordSet;
begin
  flowMeterName := FlowMeterNameComboBox.Items.Strings[FlowMeterNameComboBox.ItemIndex];

  queryStr := 'SELECT StartDateTime, EndDateTime FROM Meters WHERE ' +
              'MeterName = "' + flowMeterName + '";';
  recSet := CoRecordSet.Create;
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
  recSet.Close;

end;

function TfrmScatterGraphSelector.SelectedMeter(): string;
begin
  SelectedMeter := FlowMeterNameComboBox.Items.Strings[FlowMeterNameComboBox.ItemIndex];
end;


end.
