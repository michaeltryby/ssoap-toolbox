unit rainconvertermanager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmRainConverterManagement = class(TForm)
    ListBoxLabel: TLabel;
    addButton: TButton;
    closeButton: TButton;
    helpButton: TButton;
    editButton: TButton;
    deleteButton: TButton;
    RainConverterListBox: TListBox;
    procedure closeButtonClick(Sender: TObject);
    procedure addButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure deleteButtonClick(Sender: TObject);
    procedure editButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    procedure UpdateList();
  public { Public declarations }
    function SelectedRainConverterName(): String;
  end;

var
  frmRainConverterManagement: TfrmRainConverterManagement;

implementation

uses addrainconverter, editraindataconverter, modDatabase, mainform;

{$R *.DFM}

procedure TfrmRainConverterManagement.FormShow(Sender: TObject);
begin
  UpdateList();
  RainConverterListBox.ItemIndex := 0;
end;

procedure TfrmRainConverterManagement.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmRainConverterManagement.addButtonClick(Sender: TObject);
begin
  frmAddRainDataConverter.ShowModal;
  UpdateList();
  RainConverterListBox.ItemIndex := RainConverterListBox.Items.Count - 1;
end;

procedure TfrmRainConverterManagement.editButtonClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  previousItemIndex := RainConverterListBox.ItemIndex;
  frmEditRainDataConverter.ShowModal;
  UpdateList();
  RainConverterListBox.ItemIndex := previousItemIndex;
end;

procedure TfrmRainConverterManagement.deleteButtonClick(Sender: TObject);
var
  previousIndex, result: integer;
  rainConverterName: String;
begin
  rainConverterName := SelectedRainConverterName;
  result := MessageDlg('Are you sure you want to delete converter "'+rainConverterName+'"?',mtWarning,[mbYes,mbNo],0);
  if (result = mrYes) then begin
    DatabaseModule.RemoveRainConverter(rainConverterName);
    previousIndex := RainConverterListBox.ItemIndex;
    UpdateList();
    if (RainConverterListBox.Items.Count < previousIndex + 1)
      then RainConverterListBox.ItemIndex := RainConverterListBox.Items.Count - 1
      else RainConverterListBox.ItemIndex := previousIndex;
  end;
end;

procedure TfrmRainConverterManagement.UpdateList();
begin
  RainConverterListBox.Items := DatabaseModule.GetRainConverterNames;
  deleteButton.Enabled := RainConverterListBox.Items.Count > 0;
  editButton.Enabled := RainConverterListBox.Items.Count > 0;
end;

function TfrmRainConverterManagement.SelectedRainConverterName(): String;
begin
  SelectedRainConverterName := RainConverterListBox.Items[RainConverterListBox.ItemIndex];
end;

procedure TfrmRainConverterManagement.closeButtonClick(Sender: TObject);
begin
  Close;
end;

end.
