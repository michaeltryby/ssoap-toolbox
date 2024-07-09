unit SelectScenariotoLaunchRTKAssignment;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmSelScenario4RTKAssignment = class(TForm)
    btnSelect: TButton;
    ScenarioDesciption: TMemo;
    Label1: TLabel;
    ScenarioListBox: TListBox;
    ListBoxLabel: TLabel;
    btnAddNew: TButton;
    closeButton: TButton;
    helpButton: TButton;
    Label2: TLabel;
    btnCopy: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ScenarioListBoxClick(Sender: TObject);
    procedure closeButtonClick(Sender: TObject);
    procedure btnAddNewClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateList();
  public
    { Public declarations }
    function SelectedScenarioName(): String;
    function SelectedScenarioID(): Integer;
  end;

var
  frmSelScenario4RTKAssignment: TfrmSelScenario4RTKAssignment;

implementation
uses modDatabase, newscenario, editscenario, RTKPatternAssignment, mainform;
{$R *.dfm}

procedure TfrmSelScenario4RTKAssignment.btnAddNewClick(
  Sender: TObject);
begin
  frmAddNewScenario.ShowModal;
  UpdateList();
  ScenarioListBox.ItemIndex := ScenarioListBox.Items.Count - 1;
  ScenarioListBoxClick(Sender);
end;

procedure TfrmSelScenario4RTKAssignment.btnSelectClick(
  Sender: TObject);
begin
  frmRTKPatternAssignment.ScenarioName := SelectedScenarioName;
   frmRTKPAtternAssignment.ShowModal;
end;

procedure TfrmSelScenario4RTKAssignment.btnCopyClick(Sender: TObject);
var oldsceneName,newsceneName: string;
    oldscenarioID,newscenarioID: integer;
begin
  oldsceneName := SelectedScenarioName;
  oldscenarioID := DatabaseModule.getScenarioIDForName(oldsceneName);
  if Length(oldsceneName) > 0 then begin
    frmAddNewScenario.scenarioName := oldsceneName;
    frmAddNewScenario.description := ScenarioDesciption.Text;
    frmAddNewScenario.boCopying := true;
    if frmAddNewScenario.ShowModal = mrOK then begin
      UpdateList();
      ScenarioListBox.ItemIndex := ScenarioListBox.Items.Count - 1;
      // - force update of description
      ScenarioListBoxClick(Sender);
    end;
  end;
end;

procedure TfrmSelScenario4RTKAssignment.closeButtonClick(
  Sender: TObject);
begin
  Close;
end;

procedure TfrmSelScenario4RTKAssignment.FormCreate(
  Sender: TObject);
begin
//
end;

procedure TfrmSelScenario4RTKAssignment.FormShow(
  Sender: TObject);
begin
  UpdateList();
  ScenarioListBoxClick(Sender);
end;

procedure TfrmSelScenario4RTKAssignment.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmSelScenario4RTKAssignment.ScenarioListBoxClick(
  Sender: TObject);
begin
  if scenarioListBox.Items.Count > 0 then begin
    ScenarioDesciption.Text := DatabaseModule.GetScenarioDesciption(SelectedScenarioName);
    CloseButton.Enabled := true;
  end;
end;

function TfrmSelScenario4RTKAssignment.SelectedScenarioID: Integer;
begin
  SelectedScenarioID := DatabaseModule.GetScenarioIDForName(SelectedScenarioName);
end;

function TfrmSelScenario4RTKAssignment.SelectedScenarioName: String;
begin
  if ScenarioListBox.ItemIndex >-1 then
    SelectedScenarioName := ScenarioListBox.Items[ScenarioListBox.ItemIndex]
  else
    SelectedScenarioName := '';
end;

procedure TfrmSelScenario4RTKAssignment.UpdateList;
begin
  ScenarioListBox.Items := DatabaseModule.GetScenarioNames;
  if ScenarioListBox.Items.Count > 0 then begin
    btnSelect.Enabled := true;
    ScenarioListBox.ItemIndex := 0;
  end else begin
    btnSelect.Enabled := false;
    ScenarioListBox.ItemIndex := -1;
  end;
end;

end.
