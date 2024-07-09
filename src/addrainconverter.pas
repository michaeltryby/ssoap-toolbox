{-------------------------------------------------------------------  }
{                    Unit:    Addrainconverter.pas                    }
{                    Project: EPA SSOAP Toolbox                       }
{                    Version: 1.0.0                                   }
{                    Date:    Sept 2009                               }
{                    Author:  CDM Smith                               }
{                                                                     }
{ Form unit containing the "Add Rain Converter" dialog box in DMT     }
{-------------------------------------------------------------------  }

unit addrainconverter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, ADODB_TLB;

type
  TfrmAddRainDataConverter = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    NewNameEdit: TEdit;
    UnitsComboBox: TComboBox;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    LinesToSkipSpinEdit: TSpinEdit;
    MonthColumnSpinEdit: TSpinEdit;
    MonthWidthSpinEdit: TSpinEdit;
    DayColumnSpinEdit: TSpinEdit;
    DayWidthSpinEdit: TSpinEdit;
    YearColumnSpinEdit: TSpinEdit;
    YearWidthSpinEdit: TSpinEdit;
    HourColumnSpinEdit: TSpinEdit;
    HourWidthSpinEdit: TSpinEdit;
    MinuteColumnSpinEdit: TSpinEdit;
    MinuteWidthSpinEdit: TSpinEdit;
    RainColumnSpinEdit: TSpinEdit;
    RainWidthSpinEdit: TSpinEdit;
    RadioGroup1: TRadioGroup;
    ColumnWidthRadioButton: TRadioButton;
    CSVRadioButton: TRadioButton;
    MilitaryTimeCheckBox: TCheckBox;
    AMPMSpinEdit: TSpinEdit;
    CodeColumnSpinEdit: TSpinEdit;
    CodeWidthSpinEdit: TSpinEdit;
    procedure cancelButtonClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure CSVRadioButtonClick(Sender: TObject);
    procedure ColumnWidthRadioButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure helpButtonClick(Sender: TObject);
    procedure MilitaryTimeCheckBoxClick(Sender: TObject);
  private { Private declarations }
    existingConverterNames: TStringList;
    procedure SetAMPMSpinEditEnabled;
  public { Public declarations }
  end;

var
  frmAddRainDataConverter: TfrmAddRainDataConverter;

implementation

uses modDatabase, mainform;

{$R *.DFM}

procedure TfrmAddRainDataConverter.FormShow(Sender: TObject);
begin
  NewNameEdit.Text := 'New Converter';
  UnitsComboBox.Items := DatabaseModule.GetRainUnitLabels();
  UnitsComboBox.ItemIndex := 0;
  existingConverterNames := DatabaseModule.GetRainConverterNames();
  SetAMPMSpinEditEnabled;
end;

procedure TfrmAddRainDataConverter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAddRainDataConverter.MilitaryTimeCheckBoxClick(Sender: TObject);
begin
  SetAMPMSpinEditEnabled;
end;

procedure TfrmAddRainDataConverter.okButtonClick(Sender: TObject);
var
  unitID: integer;
  unitLabel, format, militaryTimeStr, sqlStr: String;
  okToAdd: boolean;
  recordsAffected: OleVariant;
begin
  okToAdd := true;
  if (existingConverterNames.IndexOf(NewNameEdit.Text) <> -1) then begin
    okToAdd := false;
    MessageDlg('A rain converter with this name already exists.',mtError,[mbOK],0);
  end;
  if (Length(NewNameEdit.Text) = 0) then begin
    okToAdd := false;
    MessageDlg('The converter name cannot be blank.',mtError,[mbOK],0);
  end;
  if (okToAdd) then begin
    Screen.Cursor := crHourglass;
    unitLabel := UnitsComboBox.Items.Strings[UnitsComboBox.ItemIndex];
    unitID := DatabaseModule.GetRainUnitID(unitLabel);
    if (CSVRadioButton.Checked) then format := 'CSV' else format := 'C/W';
    if (MilitaryTimeCheckBox.Checked)
      then militaryTimeStr := '1'
      else militaryTimeStr := '0';
    sqlStr := 'INSERT INTO RainConverters (RainConverterName,RainUnitID,Format,' +
              'LinesToSkip,MonthColumn,MonthWidth,DayColumn,DayWidth,' +
              'YearColumn,YearWidth,HourColumn,HourWidth,MinuteColumn,MinuteWidth,' +
              'RainColumn,RainWidth,CodeColumn,CodeWidth,MilitaryTime,AMPMColumn) VALUES (' +
              '"' + NewNameEdit.Text + '",' +
              inttostr(unitID) + ',' +
              '"' + format + '",' +
              inttostr(LinesToSkipSpinEdit.Value) + ',' +
              inttostr(MonthColumnSpinEdit.Value) + ',' +
              inttostr(MonthWidthSpinEdit.Value) + ',' +
              inttostr(DayColumnSpinEdit.Value) + ',' +
              inttostr(DayWidthSpinEdit.Value) + ',' +
              inttostr(YearColumnSpinEdit.Value) + ',' +
              inttostr(YearWidthSpinEdit.Value) + ',' +
              inttostr(HourColumnSpinEdit.Value) + ',' +
              inttostr(HourWidthSpinEdit.Value) + ',' +
              inttostr(MinuteColumnSpinEdit.Value) + ',' +
              inttostr(MinuteWidthSpinEdit.Value) + ',' +
              inttostr(RainColumnSpinEdit.Value) + ',' +
              inttostr(RainWidthSpinEdit.Value) + ',' +
              inttostr(CodeColumnSpinEdit.Value) + ',' +
              inttostr(CodeWidthSpinEdit.Value) + ',' +
              militaryTimeStr + ',' +
              inttostr(AMPMSpinEdit.Value) + ');';
    frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
    Screen.Cursor := crDefault;
    Close;
  end;
end;

procedure TfrmAddRainDataConverter.SetAMPMSpinEditEnabled;
begin
  AMPMSpinEdit.Enabled := not MilitaryTimeCheckBox.Checked;
end;

procedure TfrmAddRainDataConverter.CSVRadioButtonClick(Sender: TObject);
begin
  MonthWidthSpinEdit.Enabled := False;
  DayWidthSpinEdit.Enabled := False;
  YearWidthSpinEdit.Enabled := False;
  HourWidthSpinEdit.Enabled := False;
  MinuteWidthSpinEdit.Enabled := False;
  RainWidthSpinEdit.Enabled := False;
  CodeWidthSpinEdit.Enabled := False;
end;

procedure TfrmAddRainDataConverter.ColumnWidthRadioButtonClick(Sender: TObject);
begin
  MonthWidthSpinEdit.Enabled := True;
  DayWidthSpinEdit.Enabled := True;
  YearWidthSpinEdit.Enabled := True;
  HourWidthSpinEdit.Enabled := True;
  MinuteWidthSpinEdit.Enabled := True;
  RainWidthSpinEdit.Enabled := True;
  CodeWidthSpinEdit.Enabled := True;
end;

procedure TfrmAddRainDataConverter.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAddRainDataConverter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  existingConverterNames.Free;
end;

end.
