unit importrainfalldatafromCONfile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmImportRainfallFromCONFile = class(TForm)
    Label1: TLabel;
    FilenameEdit: TEdit;
    browseButton: TButton;
    DateTimeRangeGroupBox: TGroupBox;
    okButton: TButton;
    cancelButton: TButton;
    helpButton: TButton;
    GroupBox2: TGroupBox;
    AverageFlowsRadioButton: TRadioButton;
    FirstValueRadioButton: TRadioButton;
    SecondValueRadioButton: TRadioButton;
    OpenDialog1: TOpenDialog;
    entireRangeRadioButton: TRadioButton;
    specifyRangeRadioButton: TRadioButton;
    StartDateTimeCheckBox: TCheckBox;
    EndDateTimeCheckBox: TCheckBox;
    StartDatePicker: TDateTimePicker;
    EndDatePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    Label3: TLabel;
    RaingaugeNameComboBox: TComboBox;
    y2kCheckBox: TCheckBox;
    procedure browseButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure entireRangeRadioButtonClick(Sender: TObject);
    procedure specifyRangeRadioButtonClick(Sender: TObject);
    procedure StartDateTimeCheckBoxClick(Sender: TObject);
    procedure EndDateTimeCheckBoxClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
  public { Public declarations }
  end;

var
  frmImportRainfallFromCONFile: TfrmImportRainfallFromCONFile;

implementation

uses modDatabase, feedbackWithMemo, conRainImportThread,
  DataAddReplace, rdiiutils, mainform;

{$R *.DFM}

procedure TfrmImportRainfallFromCONFile.browseButtonClick(Sender: TObject);
begin
  if (OpenDialog1.Execute) then FilenameEdit.Text := OpenDialog1.Filename;
end;

procedure TfrmImportRainfallFromCONFile.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImportRainfallFromCONFile.FormShow(Sender: TObject);
begin
  RaingaugeNameComboBox.Items := DatabaseModule.GetRaingaugeNames();
  RaingaugeNameComboBox.ItemIndex := 0;
end;

procedure TfrmImportRainfallFromCONFile.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmImportRainfallFromCONFile.entireRangeRadioButtonClick(Sender: TObject);
begin
  StartDateTimeCheckBox.Enabled := False;
  EndDateTimeCheckBox.Enabled := False;
  StartDatePicker.Enabled := False;
  EndDatePicker.Enabled := False;
  StartTimePicker.Enabled := False;
  EndTimePicker.Enabled := False;
end;

procedure TfrmImportRainfallFromCONFile.specifyRangeRadioButtonClick(Sender: TObject);
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

procedure TfrmImportRainfallFromCONFile.StartDateTimeCheckBoxClick(Sender: TObject);
begin
  StartDatePicker.Enabled := StartDateTimeCheckBox.Checked;
  StartTimePicker.Enabled := StartDateTimeCheckBox.Checked;
end;

procedure TfrmImportRainfallFromCONFile.EndDateTimeCheckBoxClick(Sender: TObject);
begin
  EndDatePicker.Enabled := EndDateTimeCheckBox.Checked;
  EndTimePicker.Enabled := EndDateTimeCheckBox.Checked;
end;

procedure TfrmImportRainfallFromCONFile.okButtonClick(Sender: TObject);
var
  raingaugeName: string;
  okToImport: boolean;
  res: integer;
begin
  if fileCanBeRead(FilenameEdit.Text) then begin
    okToImport := true;
    raingaugeName := RaingaugeNameComboBox.Items.Strings[RaingaugeNameComboBox.ItemIndex];
    if (DatabaseModule.RaingaugeHasRainfallData(raingaugeName)) then begin
      frmDataAddReplace.WarningLabel.Caption := 'Raingauge "'+raingaugeName+'" already has rainfall data.  Do you wish to add to the'+#13
        +'existing data, remove the existing data, or cancel the import?';
      res := frmDataAddReplace.ShowModal;
      case res of
 //       mrAll + 1:;   do nothing special if they want to add
        mrAll + 2: DatabaseModule.RemoveRainfallForRaingauge(raingaugeName);
        mrCancel: okToImport := false
      end;
    end;
    if (okToImport) then begin
      ImportCONRainThread.CreateIt();
      frmFeedbackWithMemo.Caption := 'Importing Rainfall Data from a .CON File';
      frmFeedbackWithMemo.OpenForProcessing;
      Close;
    end;
  end;
end;

end.
