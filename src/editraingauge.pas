unit editraingauge;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ADODB_TLB;

type
  TfrmEditRaingauge = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    GaugeNameEdit: TEdit;
    EastingEdit: TEdit;
    NorthingEdit: TEdit;
    UnitsComboBox: TComboBox;
    TimeStepSpinEdit: TSpinEdit;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
    procedure GaugeNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    otherRaingaugeNames: TStringList;
  public { Public declarations }
  end;

var
  frmEditRaingauge: TfrmEditRaingauge;
  recSet: _RecordSet;

implementation

uses raingaugeManager, modDatabase, mainform;

{$R *.DFM}

procedure TfrmEditRaingauge.FormShow(Sender: TObject);
var
  raingaugeName, unitLabel, queryStr: String;
begin
  raingaugeName := frmRaingaugeManagement.SelectedRaingaugeName;
  GaugeNameEdit.Text := raingaugeName;

  queryStr := 'SELECT RaingaugeName,TimeStep,RaingaugeLocationX,' +
              'RaingaugeLocationY,RainUnitID FROM Raingauges WHERE ' +
              '(RaingaugeName = "' + raingaugeName + '");';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
  TimeStepSpinEdit.Value := recSet.Fields.Item[1].Value;
  EastingEdit.Text := recSet.Fields.Item[2].Value;
  NorthingEdit.Text := recSet.Fields.Item[3].Value;

  UnitsComboBox.Items := DatabaseModule.GetRainUnitLabels();
  UnitLabel := DatabaseModule.GetRainUnitLabelForRaingauge(raingaugeName);
  UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(UnitLabel);

  otherRaingaugeNames := DatabaseModule.GetRaingaugeNames();
  otherRaingaugeNames.Delete(otherRaingaugeNames.IndexOf(raingaugeName));

  if (DatabaseModule.RaingaugeHasRainfallData(raingaugeName)) then begin
    UnitsComboBox.Enabled := false;
    TimeStepSpinEdit.Enabled := false;
  end
  else begin
    UnitsComboBox.Enabled := true;
    TimeStepSpinEdit.Enabled := true;
  end;
end;

procedure TfrmEditRaingauge.GaugeNameEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = ' '  then key := '_'
  else if key = '"' then key := '''';
end;

procedure TfrmEditRaingauge.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEditRaingauge.okButtonClick(Sender: TObject);
var
  unitID, timestep: integer;
  unitLabel: String;
  okToAdd: boolean;
  easting, northing: real;
begin
  okToAdd := true;
  if (otherRaingaugeNames.IndexOf(GaugeNameEdit.Text) <> -1) then begin
    okToAdd := false;
    MessageDlg('Another raingauge with this name already exists.',mtError,[mbOK],0);
  end;
  if (Length(GaugeNameEdit.Text) = 0) then begin
    okToAdd := false;
    MessageDlg('The raingauge name cannot be blank.',mtError,[mbOK],0);
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
    unitID := DatabaseModule.GetRainUnitID(UnitLabel);

    recSet.Fields.Item[0].Value := GaugeNameEdit.Text;
    recSet.Fields.Item[1].Value := timestep;
    recSet.Fields.Item[2].Value := easting;
    recSet.Fields.Item[3].Value := northing;
    recSet.Fields.Item[4].Value := unitID;
    recSet.UpdateBatch(1);
   {recSet is closed in FormClose procedure}
    Close;
  end;
end;

procedure TfrmEditRaingauge.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  otherRaingaugeNames.Free;
  recSet.Close
end;

procedure TfrmEditRaingauge.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditRaingauge.FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0) then  exit;
    Key := #0;
  end;
end;

end.
