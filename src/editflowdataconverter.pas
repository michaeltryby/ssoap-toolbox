unit editflowdataconverter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, ADODB_TLB;

type
  TfrmEditFlowMeterDataConverter = class(TForm)
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
    NameEdit: TEdit;
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
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure ColumnWidthRadioButtonClick(Sender: TObject);
    procedure CSVRadioButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure helpButtonClick(Sender: TObject);
    procedure MilitaryTimeCheckBoxClick(Sender: TObject);
  private { Private declarations }
    otherConverterNames: TStringList;
    recSet: _recordSet;
    procedure SetAMPMSpinEnabled;
  public { Public declarations }
  end;

var
  frmEditFlowMeterDataConverter: TfrmEditFlowMeterDataConverter;

implementation

uses flowconvertermanager, modDatabase, mainform, variants;
{$R *.DFM}

procedure TfrmEditFlowMeterDataConverter.FormShow(Sender: TObject);
var
  flowConverterName, queryStr: string;
  unitLabel: string;
begin
  flowConverterName := frmFlowConverterManagement.SelectedFlowConverterName;
  NameEdit.Text := flowConverterName;

  queryStr := 'SELECT LinesToSkip, MonthColumn, MonthWidth, DayColumn, DayWidth,' +
              'YearColumn, YearWidth, HourColumn, HourWidth, MinuteColumn,' +
              'MinuteWidth, FlowColumn, FlowWidth, VelocityColumn, VelocityWidth,' +
              'DepthColumn, DepthWidth, CodeColumn, CodeWidth, Format, FlowConverterName,' +
              'FlowUnitID ' +
  //rm 2009-08-26 - two new fields:' +
              ', MilitaryTime, AMPMColumn ' +
              'FROM FlowConverters WHERE (FlowConverterName = "' + flowConverterName + '");';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
//rm 2007-10-31 - fix the sync issue with checkboxes:
  velocityCheckBox.Checked := (recSet.Fields.Item[13].Value > 0);
  depthCheckbox.Checked := (recSet.Fields.Item[15].Value > 0);

  LinesToSkipSpinEdit.Value := recSet.Fields.Item[0].Value;
  MonthColumnSpinEdit.Value := recSet.Fields.Item[1].Value;
  MonthWidthSpinEdit.Value := recSet.Fields.Item[2].Value;
  DayColumnSpinEdit.Value := recSet.Fields.Item[3].Value;
  DayWidthSpinEdit.Value := recSet.Fields.Item[4].Value;
  YearColumnSpinEdit.Value := recSet.Fields.Item[5].Value;
  YearWidthSpinEdit.Value := recSet.Fields.Item[6].Value;
  HourColumnSpinEdit.Value := recSet.Fields.Item[7].Value;
  HourWidthSpinEdit.Value := recSet.Fields.Item[8].Value;
  MinuteColumnSpinEdit.Value := recSet.Fields.Item[9].Value;
  MinuteWidthSpinEdit.Value := recSet.Fields.Item[10].Value;
  FlowColumnSpinEdit.Value := recSet.Fields.Item[11].Value;
  FlowWidthSpinEdit.Value := recSet.Fields.Item[12].Value;
  VelocityColumnSpinEdit.Value := recSet.Fields.Item[13].Value;
  VelocityWidthSpinEdit.Value := recSet.Fields.Item[14].Value;
  DepthColumnSpinEdit.Value := recSet.Fields.Item[15].Value;
  DepthWidthSpinEdit.Value := recSet.Fields.Item[16].Value;

  //rm 2009-06-09 - Beta 1 review - Code not used, confusing
  //not importing code anymore
  //CodeColumnSpinEdit.Value := recSet.Fields.Item[17].Value;
  //CodeWidthSpinEdit.Value := recSet.Fields.Item[18].Value;

  if (recSet.Fields.Item[19].Value = 'CSV') then begin
    CSVRadioButton.Checked := True;
    CSVRadioButtonClick(Self);
  end
  else begin
    ColumnWidthRadioButton.Checked := True;
    ColumnWidthRadioButtonClick(Self);
  end;

  //rm 2009-09-04 - two new fields
  //rm 2009-11-03 - new fields might be null  - if so set to default
  if VarIsNull(recSet.Fields.Item[22].Value) then
    MilitaryTimeCheckbox.Checked := true
  else
    MilitaryTimeCheckbox.Checked := recSet.Fields.Item[22].Value;
  if VarIsNull(recSet.Fields.Item[23].Value) then
    AMPMSpinEdit.Value := 0
  else
    AMPMSpinEdit.Value := recSet.Fields.Item[23].Value;


  unitLabel := DatabaseModule.GetFlowUnitLabelForFlowConverter(flowConverterName);
  UnitsComboBox.Items := DatabaseModule.GetFlowUnitLabels();
  UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(UnitLabel);

  otherConverterNames := DatabaseModule.GetFlowConverterNames();
  otherConverterNames.Delete(otherConverterNames.IndexOf(flowConverterName));
end;

procedure TfrmEditFlowMeterDataConverter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEditFlowMeterDataConverter.MilitaryTimeCheckBoxClick(
  Sender: TObject);
begin
  SetAMPMSpinEnabled;
end;

procedure TfrmEditFlowMeterDataConverter.okButtonClick(Sender: TObject);
var
  unitID: integer;
  unitLabel: String;
  okToAdd: boolean;
begin
  okToAdd := true;
  if (otherConverterNames.IndexOf(NameEdit.Text) <> -1) then begin
    okToAdd := false;
    MessageDlg('Another flow converter with this name already exists.',mtError,[mbOK],0);
  end;
  if (Length(NameEdit.Text) = 0) then begin
    okToAdd := false;
    MessageDlg('The converter name cannot be blank.',mtError,[mbOK],0);
  end;
  if (okToAdd) then begin
    recSet.Fields.Item[0].Value := LinesToSkipSpinEdit.Value;
    recSet.Fields.Item[1].Value := MonthColumnSpinEdit.Value;
    recSet.Fields.Item[2].Value := MonthWidthSpinEdit.Value;
    recSet.Fields.Item[3].Value:= DayColumnSpinEdit.Value;
    recSet.Fields.Item[4].Value := DayWidthSpinEdit.Value;
    recSet.Fields.Item[5].Value := YearColumnSpinEdit.Value;
    recSet.Fields.Item[6].Value := YearWidthSpinEdit.Value;
    recSet.Fields.Item[7].Value := HourColumnSpinEdit.Value;
    recSet.Fields.Item[8].Value := HourWidthSpinEdit.Value;
    recSet.Fields.Item[9].Value := MinuteColumnSpinEdit.Value;
    recSet.Fields.Item[10].Value := MinuteWidthSpinEdit.Value;
    recSet.Fields.Item[11].Value := FlowColumnSpinEdit.Value;
    recSet.Fields.Item[12].Value := FlowWidthSpinEdit.Value;
    recSet.Fields.Item[13].Value := VelocityColumnSpinEdit.Value;
    recSet.Fields.Item[14].Value := VelocityWidthSpinEdit.Value;
    recSet.Fields.Item[15].Value := DepthColumnSpinEdit.Value;
    recSet.Fields.Item[16].Value := DepthWidthSpinEdit.Value;
    //rm 2009-06-09 - Beta 1 review - Code not used, confusing
    //not importing code anymore
    //recSet.Fields.Item[17].Value := CodeColumnSpinEdit.Value;
    //recSet.Fields.Item[18].Value := CodeWidthSpinEdit.Value;
    recSet.Fields.Item[17].Value := 0;
    recSet.Fields.Item[18].Value := 0;
    //rm
    if (CSVRadioButton.Checked)
      then recSet.Fields.Item[19].Value := 'CSV'
      else recSet.Fields.Item[19].Value := 'C/W';
    recSet.Fields.Item[20].Value := NameEdit.Text;
//rm 2009-09-04 - new fields
    recSet.Fields.Item[22].Value := MilitaryTimeCheckBox.Checked;
    recSet.Fields.Item[23].Value := AMPMSpinEdit.Value;


    unitLabel := UnitsComboBox.Items.Strings[UnitsComboBox.ItemIndex];
    unitID := DatabaseModule.GetFlowUnitID(unitLabel);
    recSet.Fields.Item[21].Value := unitID;

    recSet.UpdateBatch(1);
    {recSet is closed in FormClose procedure}
    Close;
  end;
end;

procedure TfrmEditFlowMeterDataConverter.SetAMPMSpinEnabled;
begin
  //rm 2009-06-08 - Beta 1 review says AM/PM selector is still selectable when set to Military time
  AMPMSpinEdit.Enabled := not MilitaryTimeCheckBox.Checked;
end;

procedure TfrmEditFlowMeterDataConverter.VelocityCheckBoxClick(Sender: TObject);
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

procedure TfrmEditFlowMeterDataConverter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  otherConverterNames.Free;
  recSet.Close
end;

procedure TfrmEditFlowMeterDataConverter.ColumnWidthRadioButtonClick(
  Sender: TObject);
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

procedure TfrmEditFlowMeterDataConverter.CSVRadioButtonClick(
  Sender: TObject);
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

procedure TfrmEditFlowMeterDataConverter.DepthCheckBoxClick(Sender: TObject);
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

procedure TfrmEditFlowMeterDataConverter.cancelButtonClick(
  Sender: TObject);
begin
  Close;
end;

end.
