unit chooseCA;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmCASelector = class(TForm)
    Label1: TLabel;
    CANameComboBox: TComboBox;
    okButton: TButton;
    helpButton: TButton;
    btnClose: TButton;
    btnDetails: TButton;
    procedure btnDetailsClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
  public { Public declarations }
    function SelectedCA(): string;
  end;

var
  frmCASelector: TfrmCASelector;

implementation

uses modDatabase, mainform, CAChooseAnalyses,PostRehab_Analysis;

{$R *.DFM}

procedure TfrmCASelector.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmCASelector.btnDetailsClick(Sender: TObject);
begin
//
    frmCAAnalysesSelector.Mode := 'View';
    frmCAAnalysesSelector.CAID := databaseModule.GetCAID4Name(CANameComboBox.Text);
    frmCAAnalysesSelector.SetCA;
    frmCAAnalysesSelector.ShowModal;
end;

procedure TfrmCASelector.FormShow(Sender: TObject);
var i: integer;
  oldval: string;
begin
  i := CANameComboBox.ItemIndex;
  if (i > -1) and (i < CANameComboBox.Items.Count) then
    oldval := CANameComboBox.Items[i]
  else
    oldval := '';
  CANameComboBox.Items := DatabaseModule.GetConditionAssessmentNames;
  if (i > -1) and (i < CANameComboBox.Items.Count) then begin
    CANameComboBox.ItemIndex := i;
  end else begin
    CANameComboBox.ItemIndex := 0;
  end;
  frmCASelector.Caption := 'Pre- & Post-Sewer Rehabilitation RDII Correlation Analysis';
//begin
//  CANameComboBox.Items := DatabaseModule.GetCANames;
//  CANameComboBox.ItemIndex := 0;
end;

procedure TfrmCASelector.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmCASelector.okButtonClick(Sender: TObject);
begin
  // ModalResult := mrOK;
   //frmPostRehab_Analysis := TfrmPostRehab_Analysis.Create(self);
   frmPostRehab_Analysis.ShowModal;
   //frmPostRehab_Analysis := nil;

end;

function TfrmCASelector.SelectedCA(): string;
begin
  SelectedCA := CANameComboBox.Items.Strings[CANameComboBox.ItemIndex];
end;


end.
