unit RTKPatternConverterManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmRTKPatternConverterManager = class(TForm)
    ListBoxLabel: TLabel;
    ConverterListBox: TListBox;
    editButton: TButton;
    deleteButton: TButton;
    addButton: TButton;
    helpButton: TButton;
    closeButton: TButton;
    procedure closeButtonClick(Sender: TObject);
    procedure editButtonClick(Sender: TObject);
    procedure addButtonClick(Sender: TObject);
    procedure deleteButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateList();
  public
    { Public declarations }
  end;

var
  frmRTKPatternConverterManager: TfrmRTKPatternConverterManager;

implementation

uses addrtkpatternconverter, modDatabase, mainform;

{$R *.dfm}

procedure TfrmRTKPatternConverterManager.addButtonClick(Sender: TObject);
begin
  frmAddRTKPatternConverter.boAddingNew := True;
  frmAddRTKPatternConverter.ShowModal;
  UpdateList();
  ConverterListBox.ItemIndex := ConverterListBox.Items.Count - 1;
end;

procedure TfrmRTKPatternConverterManager.closeButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRTKPatternConverterManager.deleteButtonClick(Sender: TObject);
var
  previousIndex, result: integer;
  RTKPatternConverterName: String;
begin
  RTKPatternConverterName := ConverterListBox.Items[ConverterListBox.ItemIndex];
  result := MessageDlg('Are you sure you want to delete converter "'+
    RTKPatternConverterName+'"?',mtWarning,[mbYes,mbNo],0);
  if (result = mrYes) then begin
    DatabaseModule.RemoveRTKPatternConverter(RTKPatternConverterName);
    previousIndex := ConverterListBox.ItemIndex;
    UpdateList();
    if (ConverterListBox.Items.Count < previousIndex + 1)
      then ConverterListBox.ItemIndex := ConverterListBox.Items.Count - 1
      else ConverterListBox.ItemIndex := previousIndex;
  end;
end;

procedure TfrmRTKPatternConverterManager.editButtonClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  frmAddRTKPatternConverter.boAddingNew := False;
  frmAddRTKPatternConverter.SelectedRTKPatternConverterName :=
    ConverterListBox.Items[ConverterListBox.ItemIndex];
  previousItemIndex := ConverterListBox.ItemIndex;
  frmAddRTKPatternConverter.ShowModal;
  UpdateList();
  ConverterListBox.ItemIndex := previousItemIndex;
end;

procedure TfrmRTKPatternConverterManager.FormShow(Sender: TObject);
begin
  UpdateList();
  ConverterListBox.ItemIndex := 0;
end;

procedure TfrmRTKPatternConverterManager.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmRTKPatternConverterManager.UpdateList;
begin
  ConverterListBox.Items := DatabaseModule.GetRTKPatternConverterNames;
  deleteButton.Enabled := ConverterListBox.Items.Count > 0;
  editButton.Enabled := ConverterListBox.Items.Count > 0;
end;

end.
