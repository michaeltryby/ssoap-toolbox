unit analysismanager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmAnalysisManagement = class(TForm)
    ListBoxLabel: TLabel;
    editButton: TButton;
    deleteButton: TButton;
    addButton: TButton;
    helpButton: TButton;
    closeButton: TButton;
    AnalysisListBox: TListBox;
    procedure AnalysisListBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure closeButtonClick(Sender: TObject);
    procedure addButtonClick(Sender: TObject);
    procedure editButtonClick(Sender: TObject);
    procedure deleteButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    FSelectedAnalysisName: string;
    procedure UpdateList();
    procedure SetSelectedAnalysisName();
  public  { Public declarations }
    //function SelectedAnalysisName(): String;
    property SelectedAnalysisName: string
      read FSelectedAnalysisName write FSelectedAnalysisName;
  end;

var
  frmAnalysisManagement: TfrmAnalysisManagement;

implementation

uses newAnalysis, editanalysis, modDatabase, mainform;

{$R *.DFM}

procedure TfrmAnalysisManagement.FormShow(Sender: TObject);
begin
  UpdateList();
  AnalysisListBox.ItemIndex := 0;
  SetSelectedAnalysisName;
end;

procedure TfrmAnalysisManagement.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAnalysisManagement.SetSelectedAnalysisName;
begin
  if (AnalysisListBox.ItemIndex > -1) then
    FSelectedAnalysisName := AnalysisListBox.Items[AnalysisListBox.ItemIndex]
  else
    FSelectedAnalysisName := '';
end;

procedure TfrmAnalysisManagement.addButtonClick(Sender: TObject);
begin
  frmAddNewAnalysis.ShowModal;
  UpdateList();
  AnalysisListBox.ItemIndex := AnalysisListBox.Items.Count - 1;
  SetSelectedAnalysisName;
end;

procedure TfrmAnalysisManagement.editButtonClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  previousItemIndex := AnalysisListBox.ItemIndex;
  frmEditAnalysis.ShowModal;
  UpdateList();
  AnalysisListBox.ItemIndex := previousItemIndex;
  SetSelectedAnalysisName;
end;

procedure TfrmAnalysisManagement.deleteButtonClick(Sender: TObject);
var
  previousIndex, result: integer;
  analysisName: String;
begin
  analysisName := SelectedAnalysisName;
  result := MessageDlg('Are you sure you want to delete analysis "'+analysisName+'"?',mtWarning,[mbYes,mbNo],0);
  if (result = mrYes) then begin
    DatabaseModule.RemoveAnalysis(analysisName);
    previousIndex := AnalysisListBox.ItemIndex;
    UpdateList();
    if (AnalysisListBox.Items.Count < previousIndex + 1)
      then AnalysisListBox.ItemIndex := AnalysisListBox.Items.Count - 1
      else AnalysisListBox.ItemIndex := previousIndex;
  SetSelectedAnalysisName;
  end;
end;

procedure TfrmAnalysisManagement.UpdateList();
begin
  AnalysisListBox.Items := DatabaseModule.GetAnalysisNames;
  deleteButton.Enabled := AnalysisListBox.Items.Count > 0;
  editButton.Enabled := AnalysisListBox.Items.Count > 0;
end;

(*
function TfrmAnalysisManagement.SelectedAnalysisName(): String;
begin
  SelectedAnalysisName := AnalysisListBox.Items[AnalysisListBox.ItemIndex];
end;
*)

procedure TfrmAnalysisManagement.AnalysisListBoxClick(Sender: TObject);
begin
  SetSelectedAnalysisName;
end;

procedure TfrmAnalysisManagement.closeButtonClick(Sender: TObject);
begin
  Close;
end;

end.
