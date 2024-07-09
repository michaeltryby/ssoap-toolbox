unit chooseCALinearRegression;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmCAChooseLinearRegression = class(TForm)
    Label1: TLabel;
    CANameComboBox: TComboBox;
    btnDetails: TButton;
    RadioGroupRegressionType: TRadioGroup;
    RadioGroup1: TRadioGroup;
    RadioButton4: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton1: TRadioButton;
    okButton: TButton;
    helpButton: TButton;
    btnClose: TButton;
    procedure btnDetailsClick(Sender: TObject);
    function SelectedConditionAssessment() : string;
    procedure helpButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCAChooseLinearRegression: TfrmCAChooseLinearRegression;

implementation

uses moddatabase,LinearRegressionAnalysis, mainform, CALinearRegressionAnalysis,
  CAChooseAnalyses;

{$R *.dfm}

procedure TfrmCAChooseLinearRegression.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmCAChooseLinearRegression.btnDetailsClick(Sender: TObject);
begin
    frmCAAnalysesSelector.Mode := 'View';
    frmCAAnalysesSelector.CAID := databaseModule.GetCAID4Name(CANameComboBox.Text);
    frmCAAnalysesSelector.SetCA;
    frmCAAnalysesSelector.ShowModal;

end;

procedure TfrmCAChooseLinearRegression.FormShow(Sender: TObject);
begin
  CANameComboBox.Items := DatabaseModule.GetConditionAssessmentNames;
  if (CANameComboBox.Items.Count > 0) then
    CANameComboBox.ItemIndex := 0;
  radiobutton1.Checked := true;
end;

procedure TfrmCAChooseLinearRegression.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmCAChooseLinearRegression.okButtonClick(Sender: TObject);
begin
    frmCALinearRegressionAnalysis.ShowModal;
end;

function TfrmCAChooseLinearRegression.SelectedConditionAssessment: string;
begin
  if (CANameComboBox.Items.Count > 0) then
    SelectedConditionAssessment := CANameComboBox.Items.Strings[CANameComboBox.ItemIndex]
  else
    SelectedConditionAssessment := '';
end;

end.
