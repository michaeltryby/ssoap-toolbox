unit editcatchment;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ADODB_TLB, Variants;

type
  TfrmEditCatchment = class(TForm)
    Label1: TLabel;
    Label5: TLabel;
    RDIIAreaNameEdit: TEdit;
    UnitsComboBox: TComboBox;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    Label2: TLabel;
    EditArea: TEdit;
    Label3: TLabel;
    ComboBoxSewerShed: TComboBox;
    Label4: TLabel;
    EditLoadPoint: TEdit;
    Label6: TLabel;
    EditTag: TEdit;
    btnEditSewerShed: TButton;
    Label7: TLabel;
    Label8: TLabel;
    lblSewerShedArea: TLabel;
    lblSumRDIIAreas: TLabel;
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
    procedure ComboBoxSewerShedChange(Sender: TObject);
    procedure RDIIAreaNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure btnEditSewerShedClick(Sender: TObject);
    procedure EditAreaChange(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    FRDIIAreaName: string;
    FArea: double;
    FSewerShedName: string;
    FSewerShedID: integer;
    FOriginalSewerShedID: integer;
    recSet: _recordSet;
    otherRDIIAreaNames: TStringList;
    procedure SetRDIIAreaName(const Value: string);
    procedure UpdateAreaStats;
  public { Public declarations }
    boAddingNew: boolean; //flag for adding a new one or editing an existing one
    property RDIIAreaName: string read FRDIIAreaName write SetRDIIAreaName;
  end;

var
  frmEditCatchment: TfrmEditCatchment;
  originalRDIIAreaName: string;

implementation

uses catchmentmanager, modDatabase, mainform, editsewershed;

{$R *.DFM}

procedure TfrmEditCatchment.FormShow(Sender: TObject);
var
  RDIIAreaName, unitLabel, queryStr: string;
  SewerShedLabel: string;
  p: OleVariant;
begin
  originalRDIIAreaName := '';
  otherRDIIAreaNames := DatabaseModule.GetRDIIAreaNames();
  ComboBoxSewerShed.Items := DatabaseModule.GetSewerShedNames;
  UnitsComboBox.Items := DatabaseModule.GetAreaUnitLabels();
  FArea := 0.0;
  FSewerShedName := '';
  FSewerShedID := -1;
  FOriginalSewerShedID := -1;
  if boAddingNew then begin
    RDIIAreaNameEdit.Text := 'New_RDII_Area';
    UnitsComboBox.ItemIndex := 0;
    ComboBoxSewerShed.Text := '';
    EditArea.Text := '0.0';
    EditLoadPoint.Text := '';
    EditTag.Text := '';
  end else begin
    RDIIAreaName := FRDIIAreaName; //frmRDIIAreaManagement.SelectedRDIIAreaName;
    otherRDIIAreaNames.Delete(otherRDIIAreaNames.IndexOf(RDIIAreaName));
    RDIIAreaNameEdit.Text := RDIIAreaName;
    originalRDIIAreaName := RDIIAreaName;

  queryStr := 'SELECT RDIIAreaName, SewerShedID, AreaUnitID, Area, ' +
              ' JunctionID, Tag ' +
              ' FROM RDIIAreas WHERE (RDIIAreaName = "' + RDIIAreaName + '");';
    recSet := CoRecordSet.Create;
    recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
    // - catch empty recordset
    if recSet.EOF then begin
    end else begin
      recSet.MoveFirst;
      //SewershedNameEdit.Text := recSet.Fields.Item[0].Value;
      {recSet is used for updating and thus is closed in FormClose procedure}
      unitLabel := DatabaseModule.GetAreaUnitLabelForRDIIArea(RDIIAreaName);
      UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(UnitLabel);
      if VarIsNull(recSet.Fields.Item[1].Value) then begin
        ComboBoxSewerShed.Text := '';
      end else begin
        FSewerShedID := recSet.Fields.Item[1].Value;
        FOriginalSewerShedID := FSewerShedID;
        FSewerShedName := DatabaseModule.GetSewerShedNameForID(FSewerShedID);
        SewerShedLabel := FSewerShedName;
        ComboBoxSewerShed.ItemIndex := ComboBoxSewerShed.Items.IndexOf(SewerShedLabel);
      end;
      if VarIsNull(recSet.Fields.Item[3].Value) then begin
        EditArea.Text := '0.0';
        FArea := 0.0;
      end else begin
        FArea := recSet.Fields.Item[3].Value;
        EditArea.Text := FloattoStr(FArea);
      end;
      if VarIsNull(recSet.Fields.Item[4].Value) then
        EditLoadPoint.Text := ''
      else
        EditLoadPoint.Text := recSet.Fields.Item[4].Value;
      if VarIsNull(recSet.Fields.Item[5].Value) then
        EditTag.Text := ''
      else
        EditTag.Text := recSet.Fields.Item[5].Value;
    end;
  end;
  UpdateAreaStats;
end;

procedure TfrmEditCatchment.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEditCatchment.okButtonClick(Sender: TObject);
var
  UnitID, timestep: integer;
  RDIIAreaName, UnitLabel, sqlStr: String;
  okToAdd: boolean;
  area, easting, northing: real;

  SewerShedLabel: string;
  SewerShedID: integer;

  recordsAffected: OleVariant;

begin
  RDIIAreaName := RDIIAreaNameEdit.Text;
  okToAdd := true;
  if (Length(RDIIAreaName) = 0) then begin
    okToAdd := false;
    MessageDlg('The RDII Area name cannot be blank.',mtError,[mbOK],0);
    exit;
  end;
  if (otherRDIIAreaNames.IndexOf(RDIIAreaName) <> -1) then begin
    //OK if editing a record and not changing the sewershed name of course
    if boAddingNew or (RDIIAreaName <> originalRDIIAreaName) then begin
      okToAdd := false;
      MessageDlg('Another RDII Area with this name already exists.',mtError,[mbOK],0);
      exit;
    end;
  end;
  if (okToAdd) then begin
    if boAddingNew then begin
      Screen.Cursor := crHourglass;
      try
        unitLabel := UnitsComboBox.Text;
        UnitID := DatabaseModule.GetRdiiUnitID(unitLabel);
        SewerShedLabel := ComboBoxSewerShed.Text;
        SewerShedID := DataBaseModule.GetSewerShedIDForName(SewerShedLabel);
        sqlStr := 'INSERT INTO RDIIAreas (RDIIAreaName,' +
                  'SewerShedID, AreaUnitID, Area, ' +
                  'JunctionID, Tag) VALUES (' +
                  '"' + RDIIAreaNameEdit.Text + '",' +
                  inttostr(FSewerShedID) + ',' +
                  inttostr(UnitID)+ ',' +
                  EditArea.Text + ',' +
                  '"' + EditLoadPoint.Text + '",' +
                  '"' + EditTag.Text + '")';
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
      finally
        Screen.Cursor := crDefault;
      end;
    end else begin
      recSet.Fields.Item[0].Value := RDIIAreaNameEdit.Text;
      SewerShedLabel := ComboBoxSewerShed.Text;
      SewerShedID := DatabaseModule.GetSewerShedIDForName(SewerShedLabel);
      recset.Fields.Item[1].Value := SewerShedID;
      unitLabel := UnitsComboBox.Items.Strings[UnitsComboBox.ItemIndex];
      unitID := DatabaseModule.GetRdiiUnitID(unitLabel);
      recSet.Fields.Item[2].Value := unitID;
      area := StrToFloat(EditArea.Text);
      recset.Fields.Item[3].Value := area;
      recset.Fields.Item[4].Value := EditLoadPoint.Text;
      recset.Fields.Item[5].Value := EditTag.Text;
      recSet.UpdateBatch(1);
    end;
    Close;
  end;
end;

procedure TfrmEditCatchment.RDIIAreaNameEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = ' '  then key := '_'
  else if key = '"' then key := '''';
end;

procedure TfrmEditCatchment.SetRDIIAreaName(const Value: string);
begin
  FRDIIAreaName := Value;
end;

procedure TfrmEditCatchment.UpdateAreaStats;
var dArea: double;
begin
  dArea := DatabaseModule.GetRDIIAreasAreaForSewerShedID(FSewerShedID);
  if FSewerShedID = FOriginalSewerShedID then
    dArea := dArea - FArea;
  dArea := dArea + StrToFloat(EditArea.Text);
  lblSumRDIIAreas.Caption := floattostr(dArea);
  dArea := DatabaseModule.GetSewerShedAreaInNativeUnits(FSewerShedID);
  lblSewerShedArea.Caption := floattostr(dArea);
end;

procedure TfrmEditCatchment.FormClose(Sender: TObject;var Action: TCloseAction);
begin
  otherRDIIAreaNames.Free;
  if not boAddingNew then if recSet.State <> adStateClosed then recSet.Close;
end;

procedure TfrmEditCatchment.btnEditSewerShedClick(Sender: TObject);
var sSewerShedName, sUnitLabel: string;
    iSewerShedID: integer;
begin
//edit selected SewerShed
  if ComboBoxSewerShed.ItemIndex > -1 then begin
    sSewerShedName := ComboBoxSewerShed.Items[ComboBoxSewerShed.ItemIndex];
    iSewerShedID := DatabaseModule.GetSewershedIDForName(sSewerShedName);
    frmEditSewershed.sewershedName := sSewerShedName;
    frmEditSewershed.boAddingNew := false;
    frmEditSewershed.ShowModal;
    sUnitLabel := DatabaseModule.GetAreaUnitLabelForRDIIArea(RDIIAreaName);
    UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(sUnitLabel);
    UpdateAreaStats;
  end;
end;

procedure TfrmEditCatchment.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditCatchment.ComboBoxSewerShedChange(Sender: TObject);
var unitLabel: string;
begin
  FSewerShedName := ComboBoxSewerShed.Items[ComboBoxSewerShed.ItemIndex];
  FSewerShedID := DatabaseModule.GetSewerShedIDForName(FSewerShedName);
  unitLabel := DatabaseModule.GetAreaUnitLabelForSewerShed(FSewerShedName);
  UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(UnitLabel);
  UpdateAreaStats;
end;

procedure TfrmEditCatchment.EditAreaChange(Sender: TObject);
begin
  updateAreaStats;
end;

procedure TfrmEditCatchment.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmEditCatchment.FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0) then exit;
    Key := #0;
  end;
end;

end.
