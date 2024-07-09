
{-------------------------------------------------------------------  }
{                    Unit:    AddEditHolidayForm.pas                  }
{                    Project: EPA SSOAP Toolbox                       }
{                    Version: 1.0.0                                   }
{                    Date:    Sept 2009                               }
{                    Author:  CDM Smith                               }
{                                                                     }
{ Form unit containing the "Add/Edit" dialog box for setting holidays }
{-------------------------------------------------------------------  }
unit AddEditHolidayForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Math, StormEvent;

type
  TfrmAddEditHoliday = class(TForm)
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    PanelExisting: TPanel;
    lblExistingName: TLabel;
    EditExistingName: TEdit;
    lblExistingDate: TLabel;
    DateTimePickerExisting: TDateTimePicker;
    PanelNew: TPanel;
    lblNewName: TLabel;
    EditNewName: TEdit;
    lblNewDate: TLabel;
    DateTimePickerNew: TDateTimePicker;
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure EditNewNameKeyPress(Sender: TObject; var Key: Char);
    procedure helpButtonClick(Sender: TObject);
  private
    FAddingNew: boolean;
    FOldName: string;
    FOldDate: TDate;
    function GetAddingNew: boolean;
    procedure SetAddingNew(const Value: boolean);
    function GetOldName: string;
    procedure SetOldName(const Value: string);
    function GetOldDate: TDate;
    procedure SetOldDate(const Value: TDate);
    function GetNewDate: TDate;
    function GetNewName: string;
    procedure SetNewDate(const Value: TDate);
    procedure SetNewName(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property AddingNew: boolean
      read GetAddingNew write SetAddingNew;
    property OldName: string
      read GetOldName write SetOldName;
    property OldDate: TDate
      read GetOldDate write SetOldDate;
    property NewName: string
      read GetNewName;
    property NewDate: TDate
      read GetNewDate;
  end;

var
  frmAddEditHoliday: TfrmAddEditHoliday;

implementation

uses modDatabase, mainform;

{$R *.dfm}

{ TfrmAddEditHoliday }

procedure TfrmAddEditHoliday.cancelButtonClick(Sender: TObject);
begin
//  ModalResult := mrCancel;
  Close;
end;

procedure TfrmAddEditHoliday.EditNewNameKeyPress(Sender: TObject;
  var Key: Char);
begin
//no double-quotes!
  if sender is TEdit then begin
    if Key = '"' then
      Key := '''';
  end;
end;

procedure TfrmAddEditHoliday.FormShow(Sender: TObject);
begin
  ModalResult := mrNone;
  EditNewName.SetFocus;
end;

function TfrmAddEditHoliday.GetAddingNew: boolean;
begin
  Result := FAddingNew;
end;

function TfrmAddEditHoliday.GetNewDate: TDate;
begin
  Result := Floor(DateTimePickerNew.Date);
end;

function TfrmAddEditHoliday.GetNewName: string;
begin
  Result := EditNewName.Text;
end;

function TfrmAddEditHoliday.GetOldDate: TDate;
begin
  Result := Floor(FOldDate);
end;

function TfrmAddEditHoliday.GetOldName: string;
begin
  Result := FOldName;
end;

procedure TfrmAddEditHoliday.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAddEditHoliday.okButtonClick(Sender: TObject);
var HolidayName, OldHolidayName: string;
    HolidayDate, OldHolidayDate: TDate;
    Holidays: daysArray;
    i: integer;
    boOKtoAdd: boolean;
begin
  HolidayName := EditNewName.Text;
  HolidayDate := Floor(DateTimePickerNew.Date);
  if FAddingNew then begin //add a new holiday if not already there
    Holidays := DatabaseModule.Getholidays;
    boOKtoAdd := true;
//rm 2012-08-17 why the " - 1" ???    for i := 0 to High(Holidays) - 1 do
    for i := 0 to High(Holidays) do
      if Holidays[i] = HolidayDate then boOKtoAdd := false;
    if boOKtoAdd then begin //add it
      DatabaseModule.AddHoliday(HolidayName, HolidayDate);
    end else begin
      MessageDlg('Another holiday with this date already exists.',mtError,[mbOK],0);
    end;
  end else begin //editng an existing holiday
    OldHolidayName := EditExistingName.Text;
    OldHolidayDate := Floor(DateTimePickerExisting.Date);
    DatabaseModule.UpdateHoliday(OldHolidayName, OldHolidayDate, HolidayName, HolidayDate);
  end;
  ModalResult := mrOK;
  //DO NOT Close;
end;

procedure TfrmAddEditHoliday.SetAddingNew(const Value: boolean);
begin
  FAddingNew := Value;
  if FAddingNew then begin
    caption := 'Add Holiday';
    PanelExisting.Visible := false;
    PanelNew.Top := PanelExisting.Top;
    EditNewName.Text := '';
  end else begin
    caption := 'Edit Holiday';
    PanelExisting.Visible := True;
    PanelNew.Top := 2 * PanelExisting.Top + PanelExisting.Height;
  end;
end;

procedure TfrmAddEditHoliday.SetNewDate(const Value: TDate);
begin

end;

procedure TfrmAddEditHoliday.SetNewName(const Value: string);
begin

end;

procedure TfrmAddEditHoliday.SetOldDate(const Value: TDate);
begin
  FOldDate := Value;
  DateTimePickerExisting.Date := Floor(FOldDate);
  DateTimePickerExisting.Enabled := false;
  DateTimePickerNew.Date := Floor(FOldDate);
  DateTimePickerNew.Enabled := True;
end;

procedure TfrmAddEditHoliday.SetOldName(const Value: string);
begin
  FOldName := Value;
  EditExistingName.Text := FOldName;
  EditExistingName.Enabled := false;
  EditNewName.Text := FOldName;
  EditNewName.Enabled := True;
end;

end.
