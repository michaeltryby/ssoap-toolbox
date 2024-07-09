unit HolidayTableForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Math, StormEvent;

type
  TfrmHolidayTable = class(TForm)
    ListBoxLabel: TLabel;
    editButton: TButton;
    addButton: TButton;
    helpButton: TButton;
    deleteButton: TButton;
    closeButton: TButton;
    HolidayStringGrid: TStringGrid;
    procedure closeButtonClick(Sender: TObject);
    procedure addButtonClick(Sender: TObject);
    procedure editButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure deleteButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateList;
    procedure SelectCurrentEntry(HolidayName: string;
      HolidayDate: TDate);

    function GetSelectedHolidayName: string;
    function GetSelectedHolidayDate: TDate;
  public
    { Public declarations }
  end;

var
  frmHolidayTable: TfrmHolidayTable;

implementation

uses modDatabase, AddEditHolidayForm, mainform;

{$R *.dfm}

procedure TfrmHolidayTable.addButtonClick(Sender: TObject);
var previousItemIndex, oldCount, i: integer;
begin
  oldCount := HolidayStringGrid.RowCount;
  previousItemIndex := HolidayStringGrid.Row;
  frmAddEditHoliday.AddingNew := true;
  if frmAddEditHoliday.ShowModal = mrOK then begin
    UpdateList();
    if HolidayStringGrid.RowCount > oldCount then begin
      SelectCurrentEntry(frmAddEditHoliday.NewName, frmAddEditHoliday.NewDate);
    end else
      HolidayStringGrid.Row := previousItemIndex;
  end;
end;

procedure TfrmHolidayTable.closeButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmHolidayTable.deleteButtonClick(Sender: TObject);
var
  previousIndex, result: integer;
  HolidayName: String;
  HolidayDate: TDate;
begin
  HolidayName := GetSelectedHolidayName;
  HolidayDate := GetSelectedHolidayDate;
  result := MessageDlg('Are you sure you want to delete holiday "' +
    HolidayName + '" : ' + DateTimeToStr(HolidayDate) + '?',mtWarning,[mbYes,mbNo],0);
  if (result = mrYes) then begin
      previousIndex := HolidayStringGrid.Row;
      Screen.Cursor := crHourglass;
      DatabaseModule.RemoveHoliday(HolidayName, HolidayDate);
      UpdateList();
      Screen.Cursor := crDefault;
      if (HolidayStringGrid.RowCount < previousIndex + 1)
        then HolidayStringGrid.Row := HolidayStringGrid.RowCount - 1
        else HolidayStringGrid.Row := previousIndex;
  end;
end;

procedure TfrmHolidayTable.editButtonClick(Sender: TObject);
var previousItemIndex: integer;
begin
  previousItemIndex := HolidayStringGrid.Row;
  frmAddEditHoliday.AddingNew := false;
  frmAddEditHoliday.OldName := GetSelectedHolidayName;
  frmAddEditHoliday.OldDate := GetSelectedHolidayDate;
  if (frmAddEditHoliday.ShowModal = mrOK) then begin
//  frmAddEditHoliday.ShowModal;
//  if frmAddEditHoliday.ModalResult = mrOK then begin
    UpdateList();
    SelectCurrentEntry(frmAddEditHoliday.NewName, frmAddEditHoliday.NewDate);
  end;
//   else
//    MessageDlg('Canceled',mtinformation,[mbok],0);
//  HolidayStringGrid.Row := previousItemIndex;
end;

procedure TfrmHolidayTable.FormShow(Sender: TObject);
begin
  UpdateList;
//rm 2007-10-29 - safe fail for no holidays casse:
  if HolidayStringGrid.RowCount > 1 then
    HolidayStringGrid.Row := 1;
  HolidayStringGrid.SetFocus;
end;

function TfrmHolidayTable.GetSelectedHolidayDate: TDate;
begin
  Result := Floor(StrToDate(HolidayStringGrid.Cells[1,HolidayStringGrid.Row]));
end;

function TfrmHolidayTable.GetSelectedHolidayName: string;
begin
  Result := HolidayStringGrid.Cells[0,HolidayStringGrid.Row];
end;

procedure TfrmHolidayTable.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmHolidayTable.SelectCurrentEntry(HolidayName: string;
  HolidayDate: TDate);
begin
  HolidayStringGrid.Row := 1;
  while ((HolidayStringGrid.Row <= HolidayStringGrid.RowCount -2)
  and (GetSelectedHolidayDate <> HolidayDate)) do begin
    HolidayStringGrid.Row := HolidayStringGrid.Row + 1;
  end;
end;

procedure TfrmHolidayTable.UpdateList;
var HolidayLabels:TStringList;
    Holidays: daysArray;
    i: integer;
    aDate: TDate;
begin
  HolidayStringGrid.RowCount := 2;
  HolidayStringGrid.Rows[1].Clear;
  HolidayStringGrid.Cells[0,0] := 'Name';
  HolidayStringGrid.Cells[1,0] := 'Date';
  HolidayLabels := DatabaseModule.GetHolidayLabels;
  Holidays := DatabaseModule.Getholidays;
  if HolidayLabels.Count > 0 then begin
  HolidayStringGrid.RowCount := HolidayLabels.Count + 1;
  //HolidayListBox.Items := DatabaseModule.GetHolidays;
  for i := 1 to HolidayLabels.Count do begin
    HolidayStringGrid.Cells[0,i] := HolidayLabels[i-1];
    aDate := Holidays[i-1];
    HolidayStringGrid.Cells[1,i] := DateTimeToStr(aDate);
  end;
  end;
  deleteButton.Enabled := HolidayStringGrid.RowCount > 1;
  editButton.Enabled := HolidayStringGrid.RowCount > 0;
end;

end.
