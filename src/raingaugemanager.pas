unit raingaugemanager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmRaingaugeManagement = class(TForm)
    ListBoxLabel: TLabel;
    addButton: TButton;
    closeButton: TButton;
    helpButton: TButton;
    editButton: TButton;
    deleteButton: TButton;
    RaingaugesListBox: TListBox;
    procedure closeButtonClick(Sender: TObject);
    procedure deleteButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure addButtonClick(Sender: TObject);
    procedure editButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    procedure UpdateList();
  public { Public declarations }
    function SelectedRaingaugeName(): String;
  end;

var
  frmRaingaugeManagement: TfrmRaingaugeManagement;

implementation

uses newGauge, editraingauge, modDatabase, mainform;

{$R *.DFM}

procedure TfrmRaingaugeManagement.FormShow(Sender: TObject);
begin
  UpdateList();
  RaingaugesListBox.ItemIndex := 0;
end;

procedure TfrmRaingaugeManagement.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmRaingaugeManagement.addButtonClick(Sender: TObject);
begin
  frmAddNewGauge.ShowModal;
  UpdateList();
  RaingaugesListBox.ItemIndex := RaingaugesListBox.Items.Count - 1;
end;

procedure TfrmRaingaugeManagement.editButtonClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  previousItemIndex := RaingaugesListBox.ItemIndex;
  frmEditRaingauge.ShowModal;
  UpdateList();
  RaingaugesListBox.ItemIndex := previousItemIndex;
end;

procedure TfrmRaingaugeManagement.deleteButtonClick(Sender: TObject);
var
  previousIndex, result : integer;
  raingaugeName: String;
  analysisNames: TStringList;
begin
  raingaugeName := SelectedRaingaugeName;
  analysisNames := DatabaseModule.AnalysesUsingRaingauge(raingaugeName);
  if (analysisNames.count = 0) then begin
    result := MessageDlg('Are you sure you want to delete raingauge "'+raingaugeName+'"?',mtWarning,[mbYes,mbNo],0);
    if (result = mrYes) then begin
      previousIndex := RaingaugesListBox.ItemIndex;
      DatabaseModule.RemoveRaingauge(raingaugeName);
      UpdateList();
      if (RaingaugesListBox.Items.Count < previousIndex + 1)
        then RaingaugesListBox.ItemIndex := RaingaugesListBox.Items.Count - 1
        else RaingaugesListBox.ItemIndex := previousIndex;
    end;
  end
  else
    MessageDlg('This raingauge cannot be deleted because it is used in the following analyses:'+#13#13+analysisNames.Text,mtError,[mbOK],0);
end;

procedure TfrmRaingaugeManagement.UpdateList();
begin
  RaingaugesListBox.Items := DatabaseModule.GetRaingaugeNames;
  deleteButton.Enabled := RaingaugesListBox.Items.Count > 0;
  editButton.Enabled := RaingaugesListBox.Items.Count > 0;
end;

function TfrmRaingaugeManagement.SelectedRaingaugeName(): String;
begin
  SelectedRaingaugeName := RaingaugesListBox.Items[RaingaugesListBox.ItemIndex];
end;

procedure TfrmRaingaugeManagement.closeButtonClick(Sender: TObject);
begin
  Close;
end;

end.
