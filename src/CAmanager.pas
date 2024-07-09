unit CAmanager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmCAManagement = class(TForm)
    ListBoxLabel: TLabel;
    editButton: TButton;
    deleteButton: TButton;
    addButton: TButton;
    helpButton: TButton;
    closeButton: TButton;
    CAListBox: TListBox;
    procedure FormShow(Sender: TObject);
    procedure closeButtonClick(Sender: TObject);
    procedure addButtonClick(Sender: TObject);
    procedure editButtonClick(Sender: TObject);
    procedure deleteButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    procedure UpdateList();
  public  { Public declarations }
    function SelectedCAName(): String;
  end;

var
  frmCAManagement: TfrmCAManagement;

implementation

uses CAChooseAnalyses, modDatabase, mainform, editanalysis, chooseAnalysis;

{$R *.DFM}

procedure TfrmCAManagement.FormShow(Sender: TObject);
begin
  UpdateList();
  CAListBox.ItemIndex := 0;
end;

procedure TfrmCAManagement.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmCAManagement.addButtonClick(Sender: TObject);
begin
  frmCAAnalysesSelector.Mode := 'Add';
  frmCAAnalysesSelector.ShowModal;
  UpdateList();
  CAListBox.ItemIndex := CAListBox.Items.Count - 1;
end;

procedure TfrmCAManagement.editButtonClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  previousItemIndex := CAListBox.ItemIndex;
  if (previousItemIndex > -1) then begin
    frmCAAnalysesSelector.Mode := 'Edit';
    frmCAAnalysesSelector.CAID := databaseModule.GetCAID4Name(CAListBox.Items[CAListBox.ItemIndex]);
    frmCAAnalysesSelector.SetCA;
    frmCAAnalysesSelector.ShowModal;
    UpdateList();
    CAListBox.ItemIndex := previousItemIndex;
  end;
end;

procedure TfrmCAManagement.deleteButtonClick(Sender: TObject);
var
  previousIndex, result: integer;
  caName: String;
begin
  caName := SelectedCAName();
  result := MessageDlg('Are you sure you want to delete condition assessment "'+caName+'"?',mtWarning,[mbYes,mbNo],0);
  if (result = mrYes) then begin
    DatabaseModule.RemoveConditionAssessment(caName);
    previousIndex := CAListBox.ItemIndex;
    UpdateList();
    if (CAListBox.Items.Count < previousIndex + 1)
      then CAListBox.ItemIndex := CAListBox.Items.Count - 1
      else CAListBox.ItemIndex := previousIndex;
  end;
end;

procedure TfrmCAManagement.UpdateList();
begin
  CAListBox.Items := DatabaseModule.GetConditionAssessmentNames;
  deleteButton.Enabled := CAListBox.Items.Count > 0;
  editButton.Enabled := CAListBox.Items.Count > 0;
end;

function TfrmCAManagement.SelectedCAName(): String;
begin
  SelectedCAName := CAListBox.Items[CAListBox.ItemIndex];
end;

procedure TfrmCAManagement.closeButtonClick(Sender: TObject);
begin
  Close;
end;

end.
