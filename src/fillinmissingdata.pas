unit fillinmissingdata;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmFillInMissingDataForm = class(TForm)
    Label3: TLabel;
    FlowMeterNameComboBox: TComboBox;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    FillInMethodGroupBox: TGroupBox;
    Label1: TLabel;
    LargestGapEdit: TEdit;
    AutomaticRadioButton: TRadioButton;
    ManualRadioButton: TRadioButton;
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
  public { Public declarations }
  end;

var
  frmFillInMissingDataForm: TfrmFillInMissingDataForm;

implementation

uses modDatabase, fillinMissingFlowDataThrd, feedbackWithMemo, rdiiUtils,
  mainform;

{$R *.DFM}

procedure TfrmFillInMissingDataForm.FormShow(Sender: TObject);
begin
  FlowMeterNameComboBox.Items := DatabaseModule.GetFlowMeterNames;
  FlowMeterNameComboBox.ItemIndex := 0;
end;

procedure TfrmFillInMissingDataForm.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmFillInMissingDataForm.okButtonClick(Sender: TObject);
begin
  FillinMissingFlowDataThread.CreateIt;
  frmFeedbackWithMemo.Caption := 'Fill In Missing Flow Data';
  frmFeedbackWithMemo.OpenForProcessing;
//  Close;
end;

procedure TfrmFillInMissingDataForm.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFillInMissingDataForm.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

end.
