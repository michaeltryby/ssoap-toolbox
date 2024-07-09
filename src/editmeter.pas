unit editmeter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ADODB_TLB;

type
  TfrmEditMeter = class(TForm)
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
    UnitsComboBox: TComboBox;
    TimeStepSpinEdit: TSpinEdit;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    Label7: TLabel;
    VelocityUnitsComboBox: TComboBox;
    Label8: TLabel;
    DepthUnitsComboBox: TComboBox;
    Label9: TLabel;
    AreaUnitsComboBox: TComboBox;
    Label10: TLabel;
    EditSewerLength: TEdit;
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
    procedure MeterNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    recSet: _recordSet;
    otherMeterNames: TStringList;
  public { Public declarations }
  end;

var
  frmEditMeter: TfrmEditMeter;

implementation

uses flowmetermanager, modDatabase, mainform;

{$R *.DFM}

procedure TfrmEditMeter.FormShow(Sender: TObject);
var
  flowMeterName, unitLabel, queryStr: string;
//rm 2008-11-11 - added Velocity Units and Depth Units to the form
  VelUnitLabel, DepUnitLabel: string;
//rm 2009-10-29 - added Area Units to the form
  AreaUnitLabel: string;
begin
  flowMeterName := frmFlowMeterManagement.SelectedMeterName;
  MeterNameEdit.Text := flowMeterName;

  queryStr := 'SELECT MeterName,Area,TimeStep,MeterLocationX,MeterLocationY,FlowUnitID, ' +
//rm 2008-11-11 - need to add velocityunitid and depthunitid to the recordset
              ' VelocityUnitID, DepthUnitID, ' +
//rm 2009-10-29 - need to add areaunitid to the recordset
              ' AreaUnitID, ' +
//rm 2010-10-15
              ' SewerLength ' +
              'FROM Meters WHERE (MeterName = "' + flowMeterName + '");';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
  AreaEdit.Text := recSet.Fields.Item[1].Value;
  TimeStepSpinEdit.Value := recSet.Fields.Item[2].Value;
  EastingEdit.Text := recSet.Fields.Item[3].Value;
  NorthingEdit.Text := recSet.Fields.Item[4].Value;
  {recSet is used for updating and thus is closed in FormClose procedure}

  //rm 2010-10-15
  EditSewerLength.Text := recSet.Fields.Item[9].Value;
  //rm

  unitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
  UnitsComboBox.Items := DatabaseModule.GetFlowUnitLabels();
  UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(UnitLabel);

//rm 2008-11-11
  VelocityUnitsComboBox.Items := DatabaseModule.GetVelocityUnitLabels();
  VelocityUnitsComboBox.ItemIndex := 0;
  DepthUnitsComboBox.Items := DatabaseModule.GetDepthUnitLabels();
  DepthUnitsComboBox.ItemIndex := 0;
  VelUnitLabel := DatabaseModule.GetVelocityUnitLabelForMeter(flowMeterName);
  DepUnitLabel := DatabaseModule.GetDepthUnitLabelForMeter(flowMeterName);
  VelocityUnitsComboBox.ItemIndex := VelocityUnitsComboBox.Items.IndexOf(VelUnitLabel);
  DepthUnitsComboBox.ItemIndex := DepthUnitsComboBox.Items.IndexOf(DepUnitLabel);
//rm

//rm 2009-10-28
  AreaUnitsComboBox.Items := DatabaseModule.GetAreaUnitLabels();
  AreaUnitsComboBox.ItemIndex := 0;
  AreaUnitLabel := DatabaseModule.GetAreaUnitLabelForMeter(flowMeterName,-1);
  AreaUnitsComboBox.ItemIndex := AreaUnitsComboBox.Items.IndexOf(AreaUnitLabel);
//

  otherMeterNames := DatabaseModule.GetFlowMeterNames();
  otherMeterNames.Delete(otherMeterNames.IndexOf(flowMeterName));

  if (DatabaseModule.MeterHasFlowData(flowMeterName)) then begin
    UnitsComboBox.Enabled := false;
    TimeStepSpinEdit.Enabled := false;
  end
  else begin
    UnitsComboBox.Enabled := true;
    TimeStepSpinEdit.Enabled := true;
  end;
  //rm 2008-11-11
  DepthUnitsComboBox.Enabled := UnitsComboBox.Enabled;
  VelocityUnitsComboBox.Enabled := UnitsComboBox.Enabled;
  //rm
//rm 2009-10-28
  AreaUnitsComboBox.Enabled := UnitsComboBox.Enabled;
//

end;

procedure TfrmEditMeter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEditMeter.MeterNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  if key = ' '  then key := '_'
  else if key = '"' then key := '''';
end;

procedure TfrmEditMeter.okButtonClick(Sender: TObject);
var
  UnitID, timestep: integer;
  UnitLabel: String;
  okToAdd: boolean;
  area, easting, northing: real;
  flowMeterName: String;
  //rm 2008-11-11
  velunitLabel, depunitLabel: string;
  velunitID, depunitID: integer;
  //rm 2009-10-29
  areaunitLabel: string;
  areaunitID: integer;
  //rm 2010-10-15
  sewerlength: double;
begin
  flowMeterName := Trim(MeterNameEdit.Text);
  //rm 2007-10-23 - No spaces allowed!
  flowMeterName := stringreplace(flowmetername, ' ', '_', [rfReplaceAll, rfIgnoreCase]);
  okToAdd := true;
  if (otherMeterNames.IndexOf(flowMeterName) <> -1) then begin
    okToAdd := false;
    MessageDlg('Another flow meter with this name already exists.',mtError,[mbOK],0);
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

  if (Length(EditSewerLength.Text) > 0)
    then sewerlength := strtofloat(EditSewerLength.Text)
    else sewerlength := 0.0;
  if (sewerlength <= 0.0) then begin
    okToAdd := false;
    MessageDlg('The total sewer length must be greater than zero.',mtError,[mbOK],0);
  end;

  timestep := TimeStepSpinEdit.Value;
  if ((60 mod timestep) <> 0) then begin
    okToAdd := false;
    MessageDlg('The time step must evenly divide 60.',mtError,[mbOK],0);
  end;
  if (okToAdd) then begin
    if (Length(EastingEdit.Text) > 0)
      then easting := strtofloat(EastingEdit.Text)
      else easting := 0.0;
    if (Length(NorthingEdit.Text) > 0)
      then northing := strtofloat(NorthingEdit.Text)
      else northing := 0.0;
    unitLabel := UnitsComboBox.Items.Strings[UnitsComboBox.ItemIndex];
    unitID := DatabaseModule.GetFlowUnitID(unitLabel);

    //rm 2008-11-11
    velunitLabel := VelocityUnitsComboBox.Items.Strings[VelocityUnitsComboBox.ItemIndex];
    depunitLabel := DepthUnitsComboBox.Items.Strings[DepthUnitsComboBox.ItemIndex];
    velunitID := DatabaseModule.GetVelocityUnitID(velunitLabel);
    depunitID := DatabaseModule.GetDepthUnitID(depunitLabel);

    recSet.Fields.Item[0].Value := flowMeterName;
    recSet.Fields.Item[1].Value := area;
    recSet.Fields.Item[2].Value := timestep;
    recSet.Fields.Item[3].Value := easting;
    recSet.Fields.Item[4].Value := northing;
    recSet.Fields.Item[5].Value := unitID;
    //rm 2008-11-11
    recSet.Fields.Item[6].Value := velunitID;
    recSet.Fields.Item[7].Value := depunitID;

    //rm 2008-11-11
    areaunitLabel := AreaUnitsComboBox.Items.Strings[AreaUnitsComboBox.ItemIndex];
    areaunitID := DatabaseModule.GetAreaUnitID(areaunitLabel);
    recSet.Fields.Item[8].Value := areaunitID;

    //rm 2010-10-15
    recSet.Fields.Item[9].Value := sewerlength;

    recSet.UpdateBatch(1);
   {recSet is closed in FormClose procedure}
    Close;
  end;
end;

procedure TfrmEditMeter.FormClose(Sender: TObject;var Action: TCloseAction);
begin
  otherMeterNames.Free;
  recSet.Close
end;

procedure TfrmEditMeter.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditMeter.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmEditMeter.FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0) then exit;
    Key := #0;
  end;
end;

end.
