unit newmeter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ADODB_TLB;

type
  TfrmAddNewMeter = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MeterNameEdit: TEdit;
    AreaEdit: TEdit;
    EastingEdit: TEdit;
    NorthingEdit: TEdit;
    FlowUnitsComboBox: TComboBox;
    TimeStepSpinEdit: TSpinEdit;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    VelocityUnitsComboBox: TComboBox;
    Label7: TLabel;
    DepthUnitsComboBox: TComboBox;
    Label8: TLabel;
    Label9: TLabel;
    AreaUnitsComboBox: TComboBox;
    Label10: TLabel;
    EditSewerLength: TEdit;
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatEditKeyPress(Sender: TObject; var Key: Char);
    procedure FloatEditKeyPressAllowNegative(Sender: TObject; var Key: Char);
    procedure MeterNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    existingMeterNames: TStringList;
  public { Public declarations }
  end;

var
  frmAddNewMeter: TfrmAddNewMeter;

implementation

uses modDatabase, mainform;

{$R *.DFM}

procedure TfrmAddNewMeter.FormShow(Sender: TObject);
begin
  MeterNameEdit.Text := 'New_Meter';
  FlowUnitsComboBox.Items := DatabaseModule.GetFlowUnitLabels();
  if FlowUnitsComboBox.ItemIndex < 0 then
    FlowUnitsComboBox.ItemIndex := 0;
  VelocityUnitsComboBox.Items := DatabaseModule.GetVelocityUnitLabels();
  if VelocityUnitsComboBox.ItemIndex < 0 then
    VelocityUnitsComboBox.ItemIndex := 0;
  DepthUnitsComboBox.Items := DatabaseModule.GetDepthUnitLabels();
  if DepthUnitsComboBox.ItemIndex < 0 then
    DepthUnitsComboBox.ItemIndex := 0;

  //rm 2009-10-29
  AreaUnitsComboBox.Items := DatabaseModule.GetAreaUnitLabels();
  if AreaUnitsComboBox.ItemIndex < 0 then
    AreaUnitsComboBox.ItemIndex := 0;

  existingMeterNames := DatabaseModule.GetFlowMeterNames();
end;

procedure TfrmAddNewMeter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAddNewMeter.MeterNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  if key = ' '  then key := '_'
  else if key = '"' then key := '''';
end;

procedure TfrmAddNewMeter.okButtonClick(Sender: TObject);
var
  flowUnitID, velocityUnitID, depthUnitID, areaUnitID: integer;
  timestep, meterID: integer;
  unitLabel, flowMeterName, sqlStr, areaUnitLabel: String;
  okToAdd: boolean;
  area: real;
  //rm 2010-10-15
  sewerlength: double;
  recordsAffected: OleVariant;
begin
  flowMeterName := Trim(MeterNameEdit.Text);
  //rm 2007-10-23 - No spaces allowed!
  flowMeterName := stringreplace(flowmetername, ' ', '_', [rfReplaceAll, rfIgnoreCase]);
  okToAdd := true;
  if (existingMeterNames.IndexOf(flowMeterName) <> -1) then begin
    okToAdd := false;
    MessageDlg('A flow meter with this name already exists.',mtError,[mbOK],0);
  end;
  if (Length(flowMeterName) = 0) then begin
    okToAdd := false;
    MessageDlg('The flow meter name cannot be blank.',mtError,[mbOK],0);
  end;
  if (Length(AreaEdit.Text) > 0)
    then area := strtofloat(AreaEdit.Text)
    else area := 0.0;
  if (area <= 0.0) then begin
    okToAdd := false;
    MessageDlg('The contributory area must be greater than zero.',mtError,[mbOK],0);
  end;
//rm 2010-10-15
  if (Length(EditSewerLength.Text) > 0)
    then sewerlength := strtofloat(EditSewerLength.Text)
    else sewerlength := 0.0;
  if (sewerlength <= 0.0) then begin
    okToAdd := false;
    MessageDlg('The sewer length must be greater than zero.',mtError,[mbOK],0);
  end;
//rm
  timestep := TimeStepSpinEdit.Value;
  if ((60 mod timestep) <> 0) then begin
    okToAdd := false;
    MessageDlg('The time step must evenly divide 60.',mtError,[mbOK],0);
  end;
  if (okToAdd) then begin
    Screen.Cursor := crHourglass;
    unitLabel := FlowUnitsComboBox.Items.Strings[FlowUnitsComboBox.ItemIndex];
    flowUnitID := DatabaseModule.GetFlowUnitID(unitLabel);
    unitLabel := VelocityUnitsComboBox.Items.Strings[VelocityUnitsComboBox.ItemIndex];
    velocityUnitID := DatabaseModule.GetVelocityUnitID(unitLabel);
    unitLabel := DepthUnitsComboBox.Items.Strings[DepthUnitsComboBox.ItemIndex];
    depthUnitID := DatabaseModule.GetDepthUnitID(unitLabel);
//rm 2009-10-29
    areaUnitLabel := AreaUnitsComboBox.Items.Strings[AreaUnitsComboBox.ItemIndex];
    areaUnitID := DatabaseModule.GetAreaUnitID(areaUnitLabel);
    sqlStr := 'INSERT INTO Meters (MeterName,MeterLocationX,MeterLocationY,' +
              'StartDateTime,EndDateTime,TimeStep,FlowUnitID,VelocityUnitID,' +
              'DepthUnitID, Area, AreaUnitID, SewerLength) VALUES (' +
//rm 2007-10-23              '"' + MeterNameEdit.Text + '",' +
              '"' + flowMeterName + '",' +
              NorthingEdit.Text + ',' +
              EastingEdit.Text + ',' +
              '0.0' + ',' +
              '0.0' + ',' +
              inttostr(timestep) + ',' +
              inttostr(flowUnitID) + ',' +
              inttostr(velocityUnitID) + ',' +
              inttostr(depthUnitID) + ',' +
//rm 2009-10-29              floattostr(area) + ');';
//rm 2010-10-15              floattostr(area) + ', ' + inttostr(areaUnitID) + ');';
              floattostr(area) + ', ' + inttostr(areaUnitID) + ',' +
              floattostr(sewerlength) + ');';
    frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);

    meterID := DatabaseModule.GetMeterIDForName(flowMeterName);
    DatabaseModule.CreateWeekdayDWFRecordsForMeter(meterID,timestep);
    DatabaseModule.CreateWeekendAndHolidayDWFRecordsForMeter(meterID,timestep);
    Screen.Cursor := crDefault;
    Close;
 end;
end;


procedure TfrmAddNewMeter.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAddNewMeter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  existingMeterNames.Free;
end;


procedure TfrmAddNewMeter.FloatEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in [#3, #22, #8, '0'..'9'] then exit;
  if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
  Key := #0;
end;

procedure TfrmAddNewMeter.FloatEditKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if Key in [#3, #22, #8, '0'..'9'] then exit;
  if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
  if (Key = '-') and (TEdit(sender).SelStart = 0) then exit;
  Key := #0;
end;

end.
