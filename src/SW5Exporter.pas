unit SW5Exporter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TfrmSW5Exporter = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
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
    UpDown1: TUpDown;
    EdPrecision: TEdit;
    SaveDialog1: TSaveDialog;
    procedure helpButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSW5Exporter: TfrmSW5Exporter;

implementation

uses mainform;

{$R *.dfm}

procedure TfrmSW5Exporter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

end.
