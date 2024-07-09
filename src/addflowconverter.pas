{-------------------------------------------------------------------  }
{                    Unit:    Addflowconverter.pas                    }
{                    Project: EPA SSOAP Toolbox                       }
{                    Version: 1.0.0                                   }
{                    Date:    Sept 2009                               }
{                    Author:  CDM Smith                               }
{                                                                     }
{ Form unit containing the "Add Flow Converter" dialog box in DMT     }
{-------------------------------------------------------------------  }
unit addflowconverter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, ADODB_TLB;

type
  TfrmAddFlowMeterDataConverter = class(TForm)
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
    NewNameEdit: TEdit;
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
    FlowColumnSpinEdit: TSpinEdit;
    FlowWidthSpinEdit: TSpinEdit;
    RadioGroup1: TRadioGroup;
    ColumnWidthRadioButton: TRadioButton;
    CSVRadioButton: TRadioButton;
    CodeColumnSpinEdit: TSpinEdit;
    CodeWidthSpinEdit: TSpinEdit;
    UnitsComboBox: TComboBox;
    Label13: TLabel;
    VelocityColumnSpinEdit: TSpinEdit;
    VelocityWidthSpinEdit: TSpinEdit;
    Label14: TLabel;
    DepthColumnSpinEdit: TSpinEdit;
    DepthWidthSpinEdit: TSpinEdit;
    RadioGroup2: TRadioGroup;
    VelocityCheckBox: TCheckBox;
    DepthCheckBox: TCheckBox;
    MilitaryTimeCheckBox: TCheckBox;
    Label15: TLabel;
    AMPMSpinEdit: TSpinEdit;
    procedure DepthCheckBoxClick(Sender: TObject);
    procedure VelocityCheckBoxClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure CSVRadioButtonClick(Sender: TObject);
    procedure ColumnWidthRadioButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure helpButtonClick(Sender: TObject);
    procedure MilitaryTimeCheckBoxClick(Sender: TObject);
  private { Private declarations }
    existingConverterNames: TStringList;
    procedure SetAMPMSpinEnabled;
  public { Public declarations }
  end;

var
  frmAddFlowMeterDataConverter: TfrmAddFlowMeterDataConverter;

implementation

uses modDatabase, mainform;

{$R *.DFM}

procedure TfrmAddFlowMeterDataConverter.FormShow(Sender: TObject);
begin
  NewNameEdit.Text := 'New Converter';
  UnitsComboBox.Items := DatabaseModule.GetFlowUnitLabels();
  UnitsComboBox.ItemIndex := 0;
  existingConverterNames := DatabaseModule.GetFlowConverterNames();
end;

procedure TfrmAddFlowMeterDataConverter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAddFlowMeterDataConverter.MilitaryTimeCheckBoxClick(
  Sender: TObject);
begin
  SetAMPMSpinEnabled;
end;

procedure TfrmAddFlowMeterDataConverter.okButtonClick(Sender: TObject);
var
  unitID: integer;
  unitLabel, format, sqlStr: String;
  okToAdd: boolean;
  recordsAffected: OleVariant;
begin
  okToAdd := true;
  if (existingConverterNames.IndexOf(NewNameEdit.Text) <> -1) then begin
    okToAdd := false;
    MessageDlg('A flow converter with this name already exists.',mtError,[mbOK],0);
  end;
  if (Length(NewNameEdit.Text) = 0) then begin
    okToAdd := false;
    MessageDlg('The converter name cannot be blank.',mtError,[mbOK],0);
  end;
  if (okToAdd) then begin
    Screen.Cursor := crHourglass;
    unitLabel := UnitsComboBox.Items.Strings[UnitsComboBox.ItemIndex];
    unitID := DatabaseModule.GetFlowUnitID(unitLabel);
    if (CSVRadioButton.Checked) then format := 'CSV' else format := 'C/W';
    sqlStr := 'INSERT INTO FlowConverters (FlowConverterName,FlowUnitID,Format,' +
              'LinesToSkip,MonthColumn,MonthWidth,DayColumn,DayWidth,' +
              'YearColumn,YearWidth,HourColumn,HourWidth,MinuteColumn,MinuteWidth,' +
              'FlowColumn,FlowWidth,VelocityColumn,VelocityWidth,DepthColumn,' +
              'DepthWidth,CodeColumn,CodeWidth' +
//rm 2009-09-04 some new fields
              ',MilitaryTime,AMPMColumn'+
              ') VALUES (' +
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
              inttostr(FlowColumnSpinEdit.Value) + ',' +
              inttostr(FlowWidthSpinEdit.Value) + ',' +
              inttostr(VelocityColumnSpinEdit.Value) + ',' +
              inttostr(VelocityWidthSpinEdit.Value) + ',' +
              inttostr(DepthColumnSpinEdit.Value) + ',' +
              inttostr(DepthWidthSpinEdit.Value) + ',' +
              inttostr(CodeColumnSpinEdit.Value) + ',' +
              inttostr(CodeWidthSpinEdit.Value) +
//rm 2009-09-04 new columns
              ',' +
              BoolToStr(MilitaryTimeCheckBox.Checked) + ',' +
              inttostr(AMPMSpinEdit.Value) +
              ');';
    frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
    Screen.Cursor := crDefault;
    Close;
  end;
end;

procedure TfrmAddFlowMeterDataConverter.SetAMPMSpinEnabled;
begin
  //rm 2009-06-08 - Beta 1 review says AM/PM selector is still selectable when set to Military time
  AMPMSpinEdit.Enabled := not MilitaryTimeCheckBox.Checked;
end;

procedure TfrmAddFlowMeterDataConverter.VelocityCheckBoxClick(Sender: TObject);
begin
  if VelocityCheckBox.Checked then begin
    VelocityColumnSpinEdit.Enabled := True;
    VelocityColumnSpinEdit.Value := 7;
    if columnwidthradiobutton.Checked then
      VelocityWidthSpinEdit.Enabled := True
  end
  else begin
      VelocityColumnSpinEdit.Enabled := false;
      VelocityColumnSpinEdit.Value := 0;
      if columnwidthradiobutton.Checked then
        VelocityWidthSpinEdit.Enabled := false
  end;
end;

procedure TfrmAddFlowMeterDataConverter.CSVRadioButtonClick(Sender: TObject);
begin
  MonthWidthSpinEdit.Enabled := False;
  DayWidthSpinEdit.Enabled := False;
  YearWidthSpinEdit.Enabled := False;
  HourWidthSpinEdit.Enabled := False;
  MinuteWidthSpinEdit.Enabled := False;
  FlowWidthSpinEdit.Enabled := False;
  VelocityWidthSpinEdit.Enabled := False;
  DepthWidthSpinEdit.Enabled := False;
  CodeWidthSpinEdit.Enabled := False;
end;

procedure TfrmAddFlowMeterDataConverter.DepthCheckBoxClick(Sender: TObject);
begin
  if DepthCheckBox.Checked then begin
    DepthColumnSpinEdit.Enabled := True;
    DepthColumnSpinEdit.Value := 8;
    if columnwidthradiobutton.Checked then
      DepthWidthSpinEdit.Enabled := True
  end
  else begin
      DepthColumnSpinEdit.Enabled := false;
      DepthColumnSpinEdit.Value := 0;
      if columnwidthradiobutton.Checked then
        DepthWidthSpinEdit.Enabled := false
  end;

end;

procedure TfrmAddFlowMeterDataConverter.ColumnWidthRadioButtonClick(Sender: TObject);
begin
  MonthWidthSpinEdit.Enabled := True;
  DayWidthSpinEdit.Enabled := True;
  YearWidthSpinEdit.Enabled := True;
  HourWidthSpinEdit.Enabled := True;
  MinuteWidthSpinEdit.Enabled := True;
  FlowWidthSpinEdit.Enabled := True;
  VelocityWidthSpinEdit.Enabled := True;
  DepthWidthSpinEdit.Enabled := True;
  CodeWidthSpinEdit.Enabled := True;
end;

procedure TfrmAddFlowMeterDataConverter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  existingConverterNames.Free;
end;

procedure TfrmAddFlowMeterDataConverter.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

end.
