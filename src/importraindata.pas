unit importraindata;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Spin;

type
  TfrmImportRainDataUsingConverter = class(TForm)
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
    AverageFlowsRadioButton: TRadioButton;
    FirstValueRadioButton: TRadioButton;
    RaingaugeNameComboBox: TComboBox;
    OpenDialog1: TOpenDialog;
    SecondValueRadioButton: TRadioButton;
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
    procedure browseButtonClick(Sender: TObject);
    procedure entireRangeRadioButtonClick(Sender: TObject);
    procedure specifyRangeRadioButtonClick(Sender: TObject);
    procedure StartDateTimeCheckBoxClick(Sender: TObject);
    procedure EndDateTimeCheckBoxClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
  public { Public declarations }
  end;

var
  frmImportRainDataUsingConverter: TfrmImportRainDataUsingConverter;

implementation

uses modDatabase, feedbackWithMemo, rainfallConverterImportThread,
  DataAddReplace, rdiiutils, mainform;

{$R *.DFM}

procedure TfrmImportRainDataUsingConverter.okButtonClick(Sender: TObject);
var
  okToImport: boolean;
  raingaugeName: string;
  res: integer;
begin
  if fileCanBeRead(FilenameEdit.Text) then begin
//    okToImport := true;
    raingaugeName := RaingaugeNameComboBox.Items.Strings[RaingaugeNameComboBox.ItemIndex];
    okToImport := (length(trim(raingaugeName)) > 0);
    if (length(trim(raingaugeName)) < 1) then
      MessageDlg('Please select a rain gauge.',mtError,[mbok],0)
    else if (DatabaseModule.RaingaugeHasRainfallData(raingaugeName)) then begin
      frmDataAddReplace.WarningLabel.Caption := 'Raingauge "'+raingaugeName+'" already has rainfall data.  Do you wish to add to the'+#13
        +'existing data, remove the existing data, or cancel the import?';
      res := frmDataAddReplace.ShowModal;
      case res of
  //      mrAll + 1:;  do nothing special if they want to add
        mrAll + 2: DatabaseModule.RemoveRainfallForRaingauge(raingaugeName);
        mrCancel: okToImport := false
      end;
    end;
    if (okToImport) then begin
      ConverterImportThread.CreateIt();
      frmFeedbackWithMemo.Caption := 'Importing Rainfall Data Using Converter';
      frmFeedbackWithMemo.OpenForProcessing;
//      Close;
    end;
  end;
end;

procedure TfrmImportRainDataUsingConverter.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImportRainDataUsingConverter.FormShow(Sender: TObject);
begin
  ConverterComboBox.Items := DatabaseModule.GetRainConverterNames;
  ConverterComboBox.ItemIndex := 0;
  RaingaugeNameComboBox.Items := DatabaseModule.GetRaingaugeNames();
  RaingaugeNameComboBox.ItemIndex := 0;
end;

procedure TfrmImportRainDataUsingConverter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmImportRainDataUsingConverter.browseButtonClick(Sender: TObject);
begin
  if (OpenDialog1.Execute) then FilenameEdit.Text := OpenDialog1.Filename;
end;

procedure TfrmImportRainDataUsingConverter.entireRangeRadioButtonClick(Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := False;
  EndDateTimeCheckBox.Enabled := False;
  StartDatePicker.Enabled := False;
  EndDatePicker.Enabled := False;
  StartTimePicker.Enabled := False;
  EndTimePicker.Enabled := False;
end;

procedure TfrmImportRainDataUsingConverter.specifyRangeRadioButtonClick(Sender: TObject);
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

procedure TfrmImportRainDataUsingConverter.StartDateTimeCheckBoxClick(
  Sender: TObject);
begin
  StartDatePicker.Enabled := StartDateTimeCheckBox.Checked;
  StartTimePicker.Enabled := StartDateTimeCheckBox.Checked;
end;

procedure TfrmImportRainDataUsingConverter.EndDateTimeCheckBoxClick(
  Sender: TObject);
begin
  EndDatePicker.Enabled := EndDateTimeCheckBox.Checked;
  EndTimePicker.Enabled := EndDateTimeCheckBox.Checked;
end;

end.
