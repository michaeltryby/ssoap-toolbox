unit rdiiconvertermanager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmRdiiConverterManagement = class(TForm)
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
  private { Private declarations }
    procedure UpdateList();
  public { Public declarations }
    function SelectedRdiiConverterName(): String;
  end;

var
  frmRdiiConverterManagement: TfrmRdiiConverterManagement;

implementation

uses addrdiiconverter, editrdiidataconverter, modDatabase;

{$R *.DFM}

procedure TfrmRdiiConverterManagement.FormShow(Sender: TObject);
begin
  UpdateList();
  ConverterListBox.ItemIndex := 0;
end;

procedure TfrmRdiiConverterManagement.addButtonClick(Sender: TObject);
begin
  frmAddRdiiDataConverter.ShowModal;
  UpdateList();
  ConverterListBox.ItemIndex := ConverterListBox.Items.Count - 1;
end;

procedure TfrmRdiiConverterManagement.editButtonClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  previousItemIndex := ConverterListBox.ItemIndex;
  frmEditRdiiDataConverter.ShowModal;
  UpdateList();
  ConverterListBox.ItemIndex := previousItemIndex;
end;

procedure TfrmRdiiConverterManagement.deleteButtonClick(Sender: TObject);
var
  previousIndex, result: integer;
  rdiiConverterName: String;
begin
  rdiiConverterName := SelectedRdiiConverterName;
  result := MessageDlg('Are you sure you want to delete converter "'+rdiiConverterName+'"?',mtWarning,[mbYes,mbNo],0);
  if (result = mrYes) then begin
    DatabaseModule.RemoveRDIIConverter(rdiiConverterName);
    previousIndex := ConverterListBox.ItemIndex;
    UpdateList();
    if (ConverterListBox.Items.Count < previousIndex + 1)
      then ConverterListBox.ItemIndex := ConverterListBox.Items.Count - 1
      else ConverterListBox.ItemIndex := previousIndex;
  end;
end;

procedure TfrmRdiiConverterManagement.UpdateList();
begin
  ConverterListBox.Items := DatabaseModule.GetRdiiConverterNames;
  deleteButton.Enabled := ConverterListBox.Items.Count > 0;
  editButton.Enabled := ConverterListBox.Items.Count > 0;
end;

function TfrmRdiiConverterManagement.SelectedRdiiConverterName(): String;
begin
  SelectedRdiiConverterName := ConverterListBox.Items[ConverterListBox.ItemIndex];
end;

procedure TfrmRdiiConverterManagement.closeButtonClick(Sender: TObject);
begin
  Close;
end;

end.
