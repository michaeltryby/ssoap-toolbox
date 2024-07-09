unit chooseAnalysis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmAnalysisSelector = class(TForm)
    Label1: TLabel;
    AnalysisNameComboBox: TComboBox;
    okButton: TButton;
    helpButton: TButton;
    btnClose: TButton;
    procedure okButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
  public { Public declarations }
    function SelectedAnalysis(): string;
  end;

var
  frmAnalysisSelector: TfrmAnalysisSelector;

implementation

uses modDatabase, mainform;

{$R *.DFM}

procedure TfrmAnalysisSelector.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmAnalysisSelector.FormShow(Sender: TObject);
var i: integer;
  oldval: string;
begin
  i := AnalysisNameComboBox.ItemIndex;
  if (i > -1) and (i < AnalysisNameComboBox.Items.Count) then
    oldval := AnalysisNameComboBox.Items[i]
  else
    oldval := '';
  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames;
  if (i > -1) and (i < AnalysisNameComboBox.Items.Count) then begin
    AnalysisNameComboBox.ItemIndex := i;
  end else begin
    AnalysisNameComboBox.ItemIndex := 0;
  end;
//begin
//  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames;
//  AnalysisNameComboBox.ItemIndex := 0;
end;

procedure TfrmAnalysisSelector.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAnalysisSelector.okButtonClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

function TfrmAnalysisSelector.SelectedAnalysis(): string;
begin
  SelectedAnalysis := AnalysisNameComboBox.Items.Strings[AnalysisNameComboBox.ItemIndex];
end;


end.
