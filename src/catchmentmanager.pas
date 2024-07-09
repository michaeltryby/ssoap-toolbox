unit catchmentmanager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmRDIIAreaManagement = class(TForm)
    ListBoxLabel: TLabel;
    addButton: TButton;
    closeButton: TButton;
    helpButton: TButton;
    editButton: TButton;
    deleteButton: TButton;
    CatchmentListBox: TListBox;
    procedure closeButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure addButtonClick(Sender: TObject);
    procedure editButtonClick(Sender: TObject);
    procedure deleteButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    procedure UpdateList();
  public { Public declarations }
    function SelectedRDIIAreaName(): String;
  end;

var
  frmRDIIAreaManagement: TfrmRDIIAreaManagement;

implementation

uses editcatchment, modDatabase, mainform;

{$R *.DFM}

procedure TfrmRDIIAreaManagement.FormShow(Sender: TObject);
begin
  UpdateList();
  CatchmentListBox.ItemIndex := 0;
end;

procedure TfrmRDIIAreaManagement.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmRDIIAreaManagement.addButtonClick(Sender: TObject);
begin
  // - Add New and Edit Existing from same form:
  //frmAddNewSewershed.ShowModal;
  //frmEditSewershed.boAddingNew := true;
  //frmEditSewershed.ShowModal;

  frmEditCatchment.boAddingNew := true;
  frmEditCatchment.ShowModal;

  UpdateList();
  CatchmentListBox.ItemIndex := CatchmentListBox.Items.Count - 1;
end;

procedure TfrmRDIIAreaManagement.editButtonClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  previousItemIndex := CatchmentListBox.ItemIndex;

  frmEditCatchment.boAddingNew := false;
  frmEditCatchment.RDIIAreaName := SelectedRDIIAreaName;
  frmEditCatchment.ShowModal;

  UpdateList();
  CatchmentListBox.ItemIndex := previousItemIndex;
end;

procedure TfrmRDIIAreaManagement.deleteButtonClick(Sender: TObject);
var
  previousIndex, result: integer;
  catchmentName: String;
  rdiiNames: TStringList;
begin
  catchmentName := SelectedRDIIAreaName;
  previousIndex := CatchmentListBox.ItemIndex;
  Screen.Cursor := crHourglass;
  DatabaseModule.RemoveRDIIArea(catchmentName);
  Screen.Cursor := crDefault;
  UpdateList();
  if (CatchmentListBox.Items.Count < previousIndex + 1)
    then CatchmentListBox.ItemIndex := CatchmentListBox.Items.Count - 1
    else CatchmentListBox.ItemIndex := previousIndex;
end;

procedure TfrmRDIIAreaManagement.UpdateList();
begin
  CatchmentListBox.Items := DatabaseModule.GetRDIIAreaNames;
  deleteButton.Enabled := CatchmentListBox.Items.Count > 0;
  editButton.Enabled := CatchmentListBox.Items.Count > 0;
end;

function TfrmRDIIAreaManagement.SelectedRDIIAreaName(): String;
begin
  SelectedRDIIAreaName := CatchmentListBox.Items[CatchmentListBox.ItemIndex];
end;

procedure TfrmRDIIAreaManagement.closeButtonClick(Sender: TObject);
begin
  Close;
end;

end.
