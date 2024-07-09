unit scenarioManager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmScenarioManagement = class(TForm)
    ListBoxLabel: TLabel;
    addButton: TButton;
    closeButton: TButton;
    helpButton: TButton;
    editButton: TButton;
    deleteButton: TButton;
    ScenarioListBox: TListBox;
    Label1: TLabel;
    ScenarioDesciption: TMemo;
    CopyButton: TButton;
    procedure closeButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure addButtonClick(Sender: TObject);
    procedure editButtonClick(Sender: TObject);
    procedure deleteButtonClick(Sender: TObject);
    procedure listclick(Sender: TObject);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);

  private { Private declarations }
    FMode: integer;
    procedure UpdateList();
  public { Public declarations }
    function SelectedScenarioName(): String;
    function SelectedScenarioID(): Integer;
    procedure SetDialogMode(imode: integer);
  end;

var
  frmScenarioManagement: TfrmScenarioManagement;

implementation

uses newmeter, editmeter, modDatabase, newscenario, editscenario, mainform;

{$R *.DFM}

procedure TfrmScenarioManagement.FormShow(Sender: TObject);
begin
  ScenarioListBox.ItemIndex := 0;
  UpdateList();
  // - force update of Description
  listclick(Sender);
end;

procedure TfrmScenarioManagement.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmScenarioManagement.addButtonClick(Sender: TObject);
begin
  frmAddNewScenario.boCopying := false;
  frmAddNewScenario.ShowModal;
  UpdateList();
  ScenarioListBox.ItemIndex := ScenarioListBox.Items.Count - 1;
  // - force update of Description
  listclick(Sender);
end;

procedure TfrmScenarioManagement.editButtonClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  previousItemIndex := ScenarioListBox.ItemIndex;
  frmEditScenario.scenarioName := SelectedScenarioName;
  frmEditScenario.ShowModal;
  UpdateList();
  ScenarioListBox.ItemIndex := previousItemIndex;
  // - force update of Description
  listclick(Sender);
end;

procedure TfrmScenarioManagement.deleteButtonClick(Sender: TObject);
var
  previousIndex, result: integer;
  scenarioName: String;
begin
  scenarioName := SelectedScenarioName;
  result := MessageDlg('Are you sure you want to delete scenario "'+scenarioName+'"?',mtWarning,[mbYes,mbNo],0);
  if (result = mrYes) then begin
      previousIndex := ScenarioListBox.ItemIndex;
      Screen.Cursor := crHourglass;
      DatabaseModule.RemoveScenario(scenarioName);
      Screen.Cursor := crDefault;
      UpdateList();
      if (ScenarioListBox.Items.Count < previousIndex + 1)
        then ScenarioListBox.ItemIndex := ScenarioListBox.Items.Count - 1
        else ScenarioListBox.ItemIndex := previousIndex;
  end;
end;

procedure TfrmScenarioManagement.UpdateList();
begin
  ScenarioListBox.Items := DatabaseModule.GetScenarioNames;
  deleteButton.Enabled := ScenarioListBox.Items.Count > 0;
  editButton.Enabled := ScenarioListBox.Items.Count > 0;
  if scenarioListBox.Items.Count > 0 then
  begin
    //ScenarioDesciption.Text := DatabaseModule.GetScenarioDesciption(SelectedScenarioName);}
    ScenarioListBox.ItemIndex := 0;
    listclick(self);
  end;
end;


function TfrmScenarioManagement.SelectedScenarioID: Integer;
begin
  SelectedScenarioID := DatabaseModule.GetScenarioIDForName(SelectedScenarioName);
end;

function TfrmScenarioManagement.SelectedScenarioName(): String;
begin
  if ScenarioListBox.ItemIndex >-1 then
    SelectedScenarioName := ScenarioListBox.Items[ScenarioListBox.ItemIndex]
  else
    SelectedScenarioName := '';
end;

procedure TfrmScenarioManagement.SetDialogMode(imode: integer);
begin
  FMode := imode;
  if FMode = 1 then begin //selecting or creating new
    CloseButton.Caption := 'OK';
    CloseButton.Enabled := false;
    AddButton.Enabled := true;
  end else if FMode = 2 then begin //selecting not creating
    CloseButton.Caption := 'OK';
    CloseButton.Enabled := false;
    AddButton.Enabled := false;
  end else begin //default - adding/deleting/etc
    CloseButton.Caption := 'Close';
    AddButton.Enabled := true;
  end;
end;

procedure TfrmScenarioManagement.CopyButtonClick(Sender: TObject);
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
      listclick(Sender);
    end;
  end;
end;

procedure TfrmScenarioManagement.closeButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmScenarioManagement.FormCreate(Sender: TObject);
begin
  FMode := 0;
end;

procedure TfrmScenarioManagement.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
begin
  ScenarioDesciption.Text := DatabaseModule.GetScenarioDesciption(SelectedScenarioName);
end;

procedure TfrmScenarioManagement.listclick(Sender: TObject);
begin
  if scenarioListBox.Items.Count > 0 then begin
    ScenarioDesciption.Text := DatabaseModule.GetScenarioDesciption(SelectedScenarioName);
    //if FMode = 1 then
    CloseButton.Enabled := true;
  end;
end;

end.
