unit sewershedconvertermanager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmSewerShedConverterManagement = class(TForm)
    ListBoxLabel: TLabel;
    addButton: TButton;
    closeButton: TButton;
    helpButton: TButton;
    editButton: TButton;
    deleteButton: TButton;
    ConverterListBox: TListBox;
    procedure closeButtonClick(Sender: TObject);
    procedure addButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure deleteButtonClick(Sender: TObject);
    procedure editButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    procedure UpdateList();
  public { Public declarations }
    //function SelectedSewerShedConverterName(): String;
  end;

var
  frmSewerShedConverterManagement: TfrmSewerShedConverterManagement;

implementation

uses addsewershedconverter, editsewersheddataconverter, modDatabase, mainform;

{$R *.DFM}

procedure TfrmSewerShedConverterManagement.FormShow(Sender: TObject);
begin
  UpdateList();
  ConverterListBox.ItemIndex := 0;
end;

procedure TfrmSewerShedConverterManagement.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmSewerShedConverterManagement.addButtonClick(Sender: TObject);
begin
//  frmAddSewershedDataConverter.SelectedSewerShedConverterName :=
//    ConverterListBox.Items[ConverterListBox.ItemIndex];
  frmAddSewershedDataConverter.ShowModal;
  UpdateList();
  ConverterListBox.ItemIndex := ConverterListBox.Items.Count - 1;
end;

procedure TfrmSewerShedConverterManagement.editButtonClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  frmEditSewershedDataConverter.SelectedSewerShedConverterName :=
    ConverterListBox.Items[ConverterListBox.ItemIndex];
  previousItemIndex := ConverterListBox.ItemIndex;
  frmEditSewershedDataConverter.ShowModal;
  UpdateList();
  ConverterListBox.ItemIndex := previousItemIndex;
end;

procedure TfrmSewerShedConverterManagement.deleteButtonClick(Sender: TObject);
var
  previousIndex, result: integer;
  sewershedConverterName: String;
begin
  sewershedConverterName := ConverterListBox.Items[ConverterListBox.ItemIndex];
  result := MessageDlg('Are you sure you want to delete converter "'+sewershedConverterName+'"?',mtWarning,[mbYes,mbNo],0);
  if (result = mrYes) then begin
    DatabaseModule.RemoveSewerShedConverter(sewershedConverterName);
    previousIndex := ConverterListBox.ItemIndex;
    UpdateList();
    if (ConverterListBox.Items.Count < previousIndex + 1)
      then ConverterListBox.ItemIndex := ConverterListBox.Items.Count - 1
      else ConverterListBox.ItemIndex := previousIndex;
  end;
end;

procedure TfrmSewerShedConverterManagement.UpdateList();
begin
  ConverterListBox.Items := DatabaseModule.GetSewerShedConverterNames;
  deleteButton.Enabled := ConverterListBox.Items.Count > 0;
  editButton.Enabled := ConverterListBox.Items.Count > 0;
end;

{
function TfrmSewerShedConverterManagement.SelectedSewerShedConverterName(): String;
begin
  SelectedSewerShedConverterName := ConverterListBox.Items[ConverterListBox.ItemIndex];
end;
}

procedure TfrmSewerShedConverterManagement.closeButtonClick(Sender: TObject);
begin
  Close;
end;

end.
