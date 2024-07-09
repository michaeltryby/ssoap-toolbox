unit flowmetermanager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmFlowMeterManagement = class(TForm)
    ListBoxLabel: TLabel;
    addButton: TButton;
    closeButton: TButton;
    helpButton: TButton;
    editButton: TButton;
    deleteButton: TButton;
    FlowMeterListBox: TListBox;
    procedure closeButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure addButtonClick(Sender: TObject);
    procedure editButtonClick(Sender: TObject);
    procedure deleteButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    procedure UpdateList();
  public { Public declarations }
    function SelectedMeterName(): String;
  end;

var
  frmFlowMeterManagement: TfrmFlowMeterManagement;

implementation

uses newmeter, editmeter, modDatabase, mainform;

{$R *.DFM}

procedure TfrmFlowMeterManagement.FormShow(Sender: TObject);
begin
  UpdateList();
  FlowMeterListBox.ItemIndex := 0;
end;

procedure TfrmFlowMeterManagement.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmFlowMeterManagement.addButtonClick(Sender: TObject);
begin
  frmAddNewMeter.ShowModal;
  UpdateList();
  FlowMeterListBox.ItemIndex := FlowMeterListBox.Items.Count - 1;
end;

procedure TfrmFlowMeterManagement.editButtonClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  previousItemIndex := FlowMeterListBox.ItemIndex;
  frmEditMeter.ShowModal;
  UpdateList();
  FlowMeterListBox.ItemIndex := previousItemIndex;
end;

procedure TfrmFlowMeterManagement.deleteButtonClick(Sender: TObject);
var
  previousIndex, result: integer;
  flowMeterName: String;
  analysisNames: TStringList;
begin
  flowMeterName := SelectedMeterName;
  analysisNames := DatabaseModule.AnalysesUsingFlowMeter(flowMeterName);
  if (analysisNames.count = 0) then begin
    result := MessageDlg('Are you sure you want to delete meter "'+flowMeterName+'"?',mtWarning,[mbYes,mbNo],0);
    if (result = mrYes) then begin
      previousIndex := FlowMeterListBox.ItemIndex;
      Screen.Cursor := crHourglass;
      DatabaseModule.RemoveMeter(flowMeterName);
      Screen.Cursor := crDefault;
      UpdateList();
      if (FlowMeterListBox.Items.Count < previousIndex + 1)
        then FlowMeterListBox.ItemIndex := FlowMeterListBox.Items.Count - 1
        else FlowMeterListBox.ItemIndex := previousIndex;
    end;
  end
  else
    MessageDlg('This flow meter cannot be deleted because it is used in the following analyses:'+#13#13+analysisNames.Text,mtError,[mbOK],0);
end;

procedure TfrmFlowMeterManagement.UpdateList();
begin
  FlowMeterListBox.Items := DatabaseModule.GetFlowMeterNames;
  deleteButton.Enabled := FlowMeterListBox.Items.Count > 0;
  editButton.Enabled := FlowMeterListBox.Items.Count > 0;
end;

function TfrmFlowMeterManagement.SelectedMeterName(): String;
begin
  SelectedMeterName := FlowMeterListBox.Items[FlowMeterListBox.ItemIndex];
end;

procedure TfrmFlowMeterManagement.closeButtonClick(Sender: TObject);
begin
  Close;
end;

end.
