unit chooseLinearRegressionMethod;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmChooseLinearRegressionMethod = class(TForm)
    helpButton: TButton;
    okButton: TButton;
    RadioGroup1: TRadioGroup;
    RadioButton4: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton1: TRadioButton;
    AnalysisNameComboBox: TComboBox;
    Label1: TLabel;
    RadioGroupRegressionType: TRadioGroup;
    btnClose: TButton;
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    function SelectedAnalysis() : string;
    procedure btnCloseClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmChooseLinearRegressionMethod: TfrmChooseLinearRegressionMethod;

implementation

uses moddatabase,LinearRegressionAnalysis, mainform, CALinearRegressionAnalysis;

{$R *.dfm}
procedure TfrmChooseLinearRegressionMethod.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmChooseLinearRegressionMethod.FormShow(Sender: TObject);
begin
  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames;
  AnalysisNameComboBox.ItemIndex := 0;
  radiobutton1.Checked := true;
end;

procedure TfrmChooseLinearRegressionMethod.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmChooseLinearRegressionMethod.okButtonClick(Sender: TObject);
begin
    frmLinearRegressionAnalysis.ShowModal;
    //frmCALinearRegressionAnalysis.ShowModal;
end;

function TfrmChooseLinearRegressionMethod.SelectedAnalysis(): string;
begin
  SelectedAnalysis := AnalysisNameComboBox.Items.Strings[AnalysisNameComboBox.ItemIndex];
end;

end.
