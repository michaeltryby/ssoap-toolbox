unit flowconvertermanager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmFlowConverterManagement = class(TForm)
    ListBoxLabel: TLabel;
    addButton: TButton;
    closeButton: TButton;
    helpButton: TButton;
    editButton: TButton;
    deleteButton: TButton;
    FlowConverterListBox: TListBox;
    procedure closeButtonClick(Sender: TObject);
    procedure addButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure deleteButtonClick(Sender: TObject);
    procedure editButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    procedure UpdateList();
  public { Public declarations }
    function SelectedFlowConverterName(): String;
  end;

var
  frmFlowConverterManagement: TfrmFlowConverterManagement;

implementation

uses addflowconverter, editflowdataconverter, modDatabase, mainform;

{$R *.DFM}


procedure TfrmFlowConverterManagement.FormShow(Sender: TObject);
begin
  UpdateList();
  FlowConverterListBox.ItemIndex := 0;
end;

procedure TfrmFlowConverterManagement.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmFlowConverterManagement.addButtonClick(Sender: TObject);
begin
  frmAddFlowMeterDataConverter.ShowModal;
  UpdateList();
  FlowConverterListBox.ItemIndex := FlowConverterListBox.Items.Count - 1;
end;

procedure TfrmFlowConverterManagement.editButtonClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  previousItemIndex := FlowConverterListBox.ItemIndex;
  frmEditFlowMeterDataConverter.ShowModal;
  UpdateList();
  FlowConverterListBox.ItemIndex := previousItemIndex;
end;

procedure TfrmFlowConverterManagement.deleteButtonClick(Sender: TObject);
var
  previousIndex, result: integer;
  flowConverterName: String;
begin
  flowConverterName := SelectedFlowConverterName;
  result := MessageDlg('Are you sure you want to delete converter "'+flowConverterName+'"?',mtWarning,[mbYes,mbNo],0);
  if (result = mrYes) then begin
    DatabaseModule.RemoveFlowConverter(flowConverterName);
    previousIndex := FlowConverterListBox.ItemIndex;
    UpdateList();
    if (FlowConverterListBox.Items.Count < previousIndex + 1)
      then FlowConverterListBox.ItemIndex := FlowConverterListBox.Items.Count - 1
      else FlowConverterListBox.ItemIndex := previousIndex;
  end;
end;

procedure TfrmFlowConverterManagement.UpdateList();
begin
  FlowConverterListBox.Items := DatabaseModule.GetFlowConverterNames;
  deleteButton.Enabled := FlowConverterListBox.Items.Count > 0;
  editButton.Enabled := FlowConverterListBox.Items.Count > 0;
end;

function TfrmFlowConverterManagement.SelectedFlowConverterName(): String;
begin
  SelectedFlowConverterName := FlowConverterListBox.Items[FlowConverterListBox.ItemIndex];
end;

procedure TfrmFlowConverterManagement.closeButtonClick(Sender: TObject);
begin
  Close;
end;

end.
