unit newGauge;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ADODB_TLB;

type
  TfrmAddNewGauge = class(TForm)
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
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatEditKeyPressAllowNegative(Sender: TObject; var Key: Char);
    procedure GaugeNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    existingRaingaugeNames: TStringList;
  public { Public declarations }
  end;

var
  frmAddNewGauge: TfrmAddNewGauge;

implementation

uses modDatabase, mainform;

{$R *.DFM}

procedure TfrmAddNewGauge.FormShow(Sender: TObject);
begin
  GaugeNameEdit.Text := 'New_Raingage'; //Spaces are not allowed!
  UnitsComboBox.Items := DatabaseModule.GetRainUnitLabels();
  UnitsComboBox.ItemIndex := 0;
  existingRaingaugeNames := DatabaseModule.GetRaingaugeNames();
end;

procedure TfrmAddNewGauge.GaugeNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  if key = ' '  then key := '_'
  else if key = '"' then key := '''';
end;

procedure TfrmAddNewGauge.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAddNewGauge.okButtonClick(Sender: TObject);
var
  timestep: integer;
  okToAdd: boolean;
  eastingStr, northingStr, unitLabel, unitIDStr, sqlStr: string;
  recordsAffected: OleVariant;
begin
  GaugeNameEdit.Text := StringReplace(GaugeNameEdit.Text,' ','_',[rfReplaceAll]);
  okToAdd := true;
  if (existingRaingaugeNames.IndexOf(GaugeNameEdit.Text) <> -1) then begin
    okToAdd := false;
    MessageDlg('A raingauge with this name already exists.',mtError,[mbOK],0);
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
    Screen.Cursor := crHourglass;
    if (Length(EastingEdit.Text) > 0)
      then eastingStr := EastingEdit.Text
      else eastingStr := '0.0';
    if (Length(NorthingEdit.Text) > 0)
      then northingStr := NorthingEdit.Text
      else northingStr := '0.0';
    UnitLabel := UnitsComboBox.Items.Strings[UnitsComboBox.ItemIndex];
    unitIDStr := inttostr(DatabaseModule.GetRainUnitID(unitLabel));
    sqlStr := 'INSERT INTO Raingauges (RaingaugeName,RaingaugeLocationX,' +
              'RaingaugeLocationY,RainUnitID,TimeStep,StartDateTime,' +
              'endDateTime) VALUES (' +
              '"' + GaugeNameEdit.Text + '",' +
              eastingStr + ',' +
              northingStr + ',' +
              unitIDStr + ',' +
              inttostr(timestep) + ',' +
              '2.0' + ',' +
              '2.0' + ');';
    frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
    Screen.Cursor := crDefault;
    Close;
  end;
end;

procedure TfrmAddNewGauge.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAddNewGauge.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  existingRaingaugeNames.Free;
end;

procedure TfrmAddNewGauge.FloatEditKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0) then  exit;
    Key := #0;
  end;
end;


end.
