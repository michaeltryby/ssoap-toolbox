unit sewershedmanager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmSewershedManagement = class(TForm)
    ListBoxLabel: TLabel;
    addButton: TButton;
    closeButton: TButton;
    helpButton: TButton;
    editButton: TButton;
    deleteButton: TButton;
    SewershedListBox: TListBox;
    procedure closeButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure addButtonClick(Sender: TObject);
    procedure editButtonClick(Sender: TObject);
    procedure deleteButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    procedure UpdateList();
  public { Public declarations }
    function SelectedSewerShedName(): String;
  end;

var
  frmSewershedManagement: TfrmSewershedManagement;

implementation

uses editsewershed, modDatabase, mainform;

{$R *.DFM}

procedure TfrmSewershedManagement.FormShow(Sender: TObject);
begin
  UpdateList();
  SewershedListBox.ItemIndex := 0;
end;

procedure TfrmSewershedManagement.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmSewershedManagement.addButtonClick(Sender: TObject);
begin
  // - Add New and Edit Existing from same form:
  //frmAddNewSewershed.ShowModal;
  frmEditSewershed.boAddingNew := true;
  frmEditSewershed.ShowModal;
  UpdateList();
  SewershedListBox.ItemIndex := SewershedListBox.Items.Count - 1;
end;

procedure TfrmSewershedManagement.editButtonClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  previousItemIndex := SewershedListBox.ItemIndex;
  frmEditSewershed.sewershedName := SelectedSewerShedName;
  frmEditSewershed.boAddingNew := false;
  frmEditSewershed.ShowModal;
  UpdateList();
  SewershedListBox.ItemIndex := previousItemIndex;
end;

procedure TfrmSewershedManagement.deleteButtonClick(Sender: TObject);
var
  previousIndex, result: integer;
  sewerShedName: String;
  rdiiNames: TStringList;
begin
  sewerShedName := SelectedSewerShedName;
  rdiiNames := DatabaseModule.RDIIsUsingSewerShed(sewerShedName);
  if (rdiiNames.count = 0) then begin
    result := MessageDlg('Are you sure you want to delete sewershed "'+sewerShedName+'"?',mtWarning,[mbYes,mbNo],0);
    if (result = mrYes) then begin
      previousIndex := SewershedListBox.ItemIndex;
      Screen.Cursor := crHourglass;
      DatabaseModule.RemoveSewerShed(sewerShedName);
      Screen.Cursor := crDefault;
      UpdateList();
      if (SewershedListBox.Items.Count < previousIndex + 1)
        then SewershedListBox.ItemIndex := SewershedListBox.Items.Count - 1
        else SewershedListBox.ItemIndex := previousIndex;
    end;
  end
  else
    MessageDlg('This sewershed cannot be deleted because it is referenced by the following RDII Areas:'+#13#13+rdiiNames.Text,mtError,[mbOK],0);
end;

procedure TfrmSewershedManagement.UpdateList();
begin
  SewershedListBox.Items := DatabaseModule.GetSewershedNames;
  deleteButton.Enabled := SewershedListBox.Items.Count > 0;
  editButton.Enabled := SewershedListBox.Items.Count > 0;
end;

function TfrmSewershedManagement.SelectedSewerShedName(): String;
begin
  SelectedSewerShedName := SewershedListBox.Items[SewershedListBox.ItemIndex];
end;

procedure TfrmSewershedManagement.closeButtonClick(Sender: TObject);
begin
  Close;
end;

end.
