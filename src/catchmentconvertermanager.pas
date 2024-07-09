unit catchmentconvertermanager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmRDIIAreaConverterManagement = class(TForm)
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
  end;

var
  frmRDIIAreaConverterManagement: TfrmRDIIAreaConverterManagement;

implementation

uses addcatchmentconverter, modDatabase, mainform;

{$R *.DFM}

procedure TfrmRDIIAreaConverterManagement.FormShow(Sender: TObject);
begin
  UpdateList();
  ConverterListBox.ItemIndex := 0;
end;

procedure TfrmRDIIAreaConverterManagement.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmRDIIAreaConverterManagement.addButtonClick(Sender: TObject);
begin
  frmAddRDIIAreaDataConverter.boAddingNew := True;
  frmAddRDIIAreaDataConverter.ShowModal;
  UpdateList();
  ConverterListBox.ItemIndex := ConverterListBox.Items.Count - 1;
end;

procedure TfrmRDIIAreaConverterManagement.editButtonClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  frmAddRDIIAreaDataConverter.boAddingNew := False;
  frmAddRDIIAreaDataConverter.SelectedRDIIAreaConverterName :=
    ConverterListBox.Items[ConverterListBox.ItemIndex];
  previousItemIndex := ConverterListBox.ItemIndex;
  frmAddRDIIAreaDataConverter.ShowModal;
  UpdateList();
  ConverterListBox.ItemIndex := previousItemIndex;
end;

procedure TfrmRDIIAreaConverterManagement.deleteButtonClick(Sender: TObject);
var
  previousIndex, result: integer;
  RDIIAreaConverterName: String;
begin
  RDIIAreaConverterName := ConverterListBox.Items[ConverterListBox.ItemIndex];
  result := MessageDlg('Are you sure you want to delete converter "'+
    RDIIAreaConverterName+'"?',mtWarning,[mbYes,mbNo],0);
  if (result = mrYes) then begin
    DatabaseModule.RemoveRDIIAreaConverter(RDIIAreaConverterName);
    previousIndex := ConverterListBox.ItemIndex;
    UpdateList();
    if (ConverterListBox.Items.Count < previousIndex + 1)
      then ConverterListBox.ItemIndex := ConverterListBox.Items.Count - 1
      else ConverterListBox.ItemIndex := previousIndex;
  end;
end;

procedure TfrmRDIIAreaConverterManagement.UpdateList();
begin
  ConverterListBox.Items := DatabaseModule.GetRDIIAreaConverterNames;
  deleteButton.Enabled := ConverterListBox.Items.Count > 0;
  editButton.Enabled := ConverterListBox.Items.Count > 0;
end;

{
function TfrmCatchmentConverterManagement.SelectedCatchmentConverterName(): String;
begin
  SelectedCatchmentConverterName := ConverterListBox.Items[ConverterListBox.ItemIndex];
end;
}

procedure TfrmRDIIAreaConverterManagement.closeButtonClick(Sender: TObject);
begin
  Close;
end;

end.
