unit editsewershed;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ADODB_TLB, Variants;

type
  TfrmEditSewershed = class(TForm)
    Label1: TLabel;
    Label5: TLabel;
    SewershedNameEdit: TEdit;
    UnitsComboBox: TComboBox;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    Label2: TLabel;
    EditArea: TEdit;
    Label3: TLabel;
    ComboBoxRainGauge: TComboBox;
    Label4: TLabel;
    EditLoadPoint: TEdit;
    Label6: TLabel;
    EditTag: TEdit;
    Label7: TLabel;
    ComboBoxFlowMeter: TComboBox;
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
    procedure SewershedNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    recSet: _recordSet;
    otherSewershedNames: TStringList;
  public { Public declarations }
    boAddingNew: boolean; //flag for adding a new one or editing an existing one
    sewershedname: string;
  end;

var
  frmEditSewershed: TfrmEditSewershed;
  originalSewershedName: string;

implementation

uses sewershedmanager, modDatabase, mainform;

{$R *.DFM}

procedure TfrmEditSewershed.FormShow(Sender: TObject);
var
  //sewershedName,
  unitLabel, queryStr: string;
  RainGaugeLabel, FlowMeterLabel: string;
  p: OleVariant;
  RainGaugeID, FlowMeterID: integer;
begin
  originalSewerShedName := '';
  otherSewershedNames := DatabaseModule.GetSewershedNames();
  ComboBoxRainGauge.Items := DatabaseModule.GetRaingaugeNames;
  ComboBoxFlowMeter.Items := DatabaseModule.GetFlowMeterNames;
  UnitsComboBox.Items := DatabaseModule.GetAreaUnitLabels();

  if boAddingNew then begin
    SewershedNameEdit.Text := 'New_Sewershed';
    UnitsComboBox.ItemIndex := 0;
    ComboBoxRainGauge.Text := '';
    ComboBoxFlowMeter.Text := '';
    EditArea.Text := '0.0';
    EditLoadPoint.Text := '';
    EditTag.Text := '';
  end else begin
    //sewershedName := frmSewershedManagement.SelectedSewerShedName;
    otherSewershedNames.Delete(otherSewershedNames.IndexOf(sewershedName));
    SewershedNameEdit.Text := sewershedName;
    originalSewerShedName := sewershedName;

  queryStr := 'SELECT SewershedName, AreaUnitID, Area, RainGaugeID, ' +
              ' MeterID, JunctionID, Tag ' +
              ' FROM Sewersheds WHERE (SewershedName = "' + sewershedName + '");';
    recSet := CoRecordSet.Create;
    recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
    //- catch empty recordset
    if recSet.EOF then begin
    end else begin
      recSet.MoveFirst;
      //SewershedNameEdit.Text := recSet.Fields.Item[0].Value;
      {recSet is used for updating and thus is closed in FormClose procedure}
      unitLabel := DatabaseModule.GetAreaUnitLabelForSewershed(sewershedName);
      UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(UnitLabel);
      if VarIsNull(recSet.Fields.Item[3].Value) then begin
        RainGaugeID := -1;
        ComboBoxRainGauge.Text := '';
      end else begin
        RainGaugeID := recSet.Fields.Item[3].Value;
        RainGaugeLabel := DatabaseModule.GetRaingaugeNameForID(RainGaugeID);
        ComboBoxRainGauge.ItemIndex := ComboBoxRainGauge.Items.IndexOf(RainGaugeLabel);
      end;
      if VarIsNull(recSet.Fields.Item[4].Value) then begin
        FlowMeterID := -1;
        ComboBoxFlowMeter.Text := '';
      end else begin
        FlowMeterID := recSet.Fields.Item[4].Value;
        FlowMeterLabel := DatabaseModule.GetFlowMeterNameForID(FlowMeterID);
        ComboBoxFlowMeter.ItemIndex := ComboBoxFlowMeter.Items.IndexOf(FlowMeterLabel);
      end;
      if VarIsNull(recSet.Fields.Item[2].Value) then
        EditArea.Text := '0.0'
      else
        EditArea.Text := FloattoStr(recSet.Fields.Item[2].Value);
      if VarIsNull(recSet.Fields.Item[5].Value) then
        EditLoadPoint.Text := ''
      else
        EditLoadPoint.Text := recSet.Fields.Item[5].Value;
      if VarIsNull(recSet.Fields.Item[6].Value) then
        EditTag.Text := ''
      else
        EditTag.Text := recSet.Fields.Item[6].Value;
    end;
  end;
end;

procedure TfrmEditSewershed.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEditSewershed.okButtonClick(Sender: TObject);
var
  UnitID, timestep: integer;
  sewershedName, UnitLabel, sqlStr: String;
  okToAdd: boolean;
  area, easting, northing: real;

  RainGaugeLabel: string;
  RainGaugeID: integer;
  FlowMeterLabel: string;
  FlowMeterID: integer;

  recordsAffected: OleVariant;

begin
  sewershedName := SewershedNameEdit.Text;
  okToAdd := true;
  if (Length(sewershedName) = 0) then begin
    okToAdd := false;
    MessageDlg('The sewershed name cannot be blank.',mtError,[mbOK],0);
  end;
  if (otherSewershedNames.IndexOf(sewershedName) <> -1) then begin
    //OK if editing a record and not changing the sewershed name of course
    if boAddingNew or (sewershedName <> originalSewershedName) then begin
      okToAdd := false;
      MessageDlg('Another sewershed with this name already exists.',mtError,[mbOK],0);
    end;
  end else if (Length(EditArea.Text) = 0) then begin
    okToAdd := false;
    MessageDlg('The area cannot be blank.',mtError,[mbOK],0);
  end;

  if (okToAdd) then begin
    if boAddingNew then begin
      Screen.Cursor := crHourglass;
      try
        unitLabel := UnitsComboBox.Text;
        UnitID := DatabaseModule.GetRdiiUnitID(unitLabel);
        rainGaugeLabel := ComboBoxRainGauge.Text;
        RainGaugeID := DataBaseModule.GetRaingaugeIDForName(RainGaugeLabel);
        FlowMeterLabel := ComboBoxFlowMeter.text;
        FlowMeterID := DataBaseModule.GetMeterIDForName(FlowMeterLabel);
        sqlStr := 'INSERT INTO Sewersheds (SewershedName,' +
                  'AreaUnitID, Area, RainGaugeID, MeterID, ' +
                  'JunctionID, Tag) VALUES (' +
                  '"' + SewershedNameEdit.Text + '",' +
                  inttostr(UnitID)+ ',' +
                  EditArea.Text + ',' +
                  inttostr(RainGaugeID) + ',' +
                  inttostr(FlowMeterID) + ',' +
                  '"' + EditLoadPoint.Text + '",' +
                  '"' + EditTag.Text + '")';
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
      finally
        Screen.Cursor := crDefault;
      end;
    end else begin
      unitLabel := UnitsComboBox.Items.Strings[UnitsComboBox.ItemIndex];
      unitID := DatabaseModule.GetRdiiUnitID(unitLabel);
      recSet.Fields.Item[0].Value := SewershedNameEdit.Text;
      recSet.Fields.Item[1].Value := unitID;
      area := StrToFloat(EditArea.Text);
      recset.Fields.Item[2].Value := area;
      RainGaugeLabel := ComboBoxRainGauge.Text;
      RainGaugeID := DatabaseModule.GetRaingaugeIDForName(RainGaugeLabel);
      FlowMeterLabel := ComboBoxFlowMeter.Text;
      FlowMeterID := DatabaseModule.GetMeterIDForName(FlowMeterLabel);
      recset.Fields.Item[3].Value := RainGaugeID;
      recset.Fields.Item[4].Value := FlowMeterID;
      recset.Fields.Item[5].Value := EditLoadPoint.Text;
      recset.Fields.Item[6].Value := EditTag.Text;
      recSet.UpdateBatch(1);
      //update raingaugeid for all rdiiareas related to this sewershed
      DatabaseModule.UpdateRainGaugeIDForRDIIAreasInSewerShed(
        SewershedNameEdit.Text);
      //update flowmeterid for all rdiiareas related to this sewershed
      DatabaseModule.UpdateFlowMeterIDForRDIIAreasInSewerShed(
        SewershedNameEdit.Text);
      //update areaunits for all rdiiareas related to this sewershed
      DatabaseModule.UpdateAreaUnitIDForRDIIAreasInSewerShed(
        SewershedNameEdit.Text);
    end;
    Close;
  end;
end;

procedure TfrmEditSewershed.SewershedNameEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = ' '  then key := '_'
  else if key = '"' then key := '''';
end;

procedure TfrmEditSewershed.FormClose(Sender: TObject;var Action: TCloseAction);
begin
  otherSewershedNames.Free;
  if not boAddingNew then recSet.Close;
end;

procedure TfrmEditSewershed.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditSewershed.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmEditSewershed.FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0) then exit;
    Key := #0;
  end;
end;

end.
