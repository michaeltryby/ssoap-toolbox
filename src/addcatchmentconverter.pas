
{-------------------------------------------------------------------}
{                    Unit:    Addcatchmentcoverter.pas                             }
{                    Project: EPA SSOAP Toolbox                     }
{                    Version: 1.0.0                                 }
{                    Date:    Sept 2009                             }
{                    Author:  CDM Smith                             }
{                                                                   }
{ Form unit containing the format of "catchment area informatio"    }
{ for importing function in DMT                                     )  
{-------------------------------------------------------------------}
unit addcatchmentconverter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, ADODB_TLB;

type
  TfrmAddRDIIAreaDataConverter = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    NewNameEdit: TEdit;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    LinesToSkipSpinEdit: TSpinEdit;
    SpinEditNameColumn: TSpinEdit;
    SpinEditNameWidth: TSpinEdit;
    SpinEditAreaUnitsColumn: TSpinEdit;
    SpinEditAreaUnitsWidth: TSpinEdit;
    SpinEditAreaColumn: TSpinEdit;
    SpinEditAreaWidth: TSpinEdit;
    SpinEditLoadPointColumn: TSpinEdit;
    SpinEditLoadPointWidth: TSpinEdit;
    SpinEditTagColumn: TSpinEdit;
    SpinEditTagWidth: TSpinEdit;
    RadioGroup1: TRadioGroup;
    ColumnWidthRadioButton: TRadioButton;
    CSVRadioButton: TRadioButton;
    UnitsComboBox: TComboBox;
    Label7: TLabel;
    SpinEditSewerShedNameColumn: TSpinEdit;
    SpinEditSewerShedNameWidth: TSpinEdit;
    Label12: TLabel;
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure CSVRadioButtonClick(Sender: TObject);
    procedure ColumnWidthRadioButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    existingConverterNames: TStringList;
    recSet: _recordSet;
  public { Public declarations }
    boAddingNew: boolean;
    SelectedRDIIAreaConverterName: string;
  end;

var
  frmAddRDIIAreaDataConverter: TfrmAddRDIIAreaDataConverter;
  originalConverterName: string;

implementation

uses modDatabase, catchmentconvertermanager, mainform;

{$R *.DFM}

procedure TfrmAddRDIIAreaDataConverter.FormShow(Sender: TObject);
var
  RDIIAreaConverterName, queryStr: string;
  unitLabel: string;
begin
  UnitsComboBox.Items := DatabaseModule.GetAreaUnitLabels();
  UnitsComboBox.ItemIndex := 0;
  existingConverterNames := DatabaseModule.GetRDIIAreaConverterNames();
  if boAddingNew then begin
    Caption := 'Add RDIIArea Data Converter';
    NewNameEdit.Text := 'New Converter';
    originalconverterName := ''
  end else begin
    Caption := 'Edit RDIIArea Data Converter';
  RDIIAreaConverterName := SelectedRDIIAreaConverterName;
  originalConverterName := RDIIAreaConverterName;
  NewNameEdit.Text := RDIIAreaConverterName;

  queryStr := 'SELECT LinesToSkip, NameColumn, NameWidth, ' +
              ' SewerShedColumn, SewerShedWidth,' +
              ' AreaUnitColumn, AreaUnitWidth,'+
              ' AreaColumn, AreaWidth,' +
              ' LoadPointColumn, LoadPointWidth, TagColumn, TagWidth, ' +
              ' [Format], RDIIAreaConverterName, AreaUnitID' +
              ' FROM RDIIAreaConverters WHERE (RDIIAreaConverterName = "' + RDIIAreaConverterName + '");';

  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;

  LinesToSkipSpinEdit.Value := recSet.Fields.Item[0].Value;
  SpinEditNameColumn.Value := recSet.Fields.Item[1].Value;
  SpinEditNameWidth.Value := recSet.Fields.Item[2].Value;
  SpinEditSewerShedNameColumn.Value := recSet.Fields.Item[3].Value;
  SpinEditSewerShedNameWidth.Value := recSet.Fields.Item[4].Value;
  SpinEditAreaUnitsColumn.Value := recSet.Fields.Item[5].Value;
  SpinEditAreaUnitsWidth.Value := recSet.Fields.Item[6].Value;
  SpinEditAreaColumn.Value := recSet.Fields.Item[7].Value;
  SpinEditAreaWidth.Value := recSet.Fields.Item[8].Value;
  SpinEditLoadPointColumn.Value := recSet.Fields.Item[9].Value;
  SpinEditLoadPointWidth.Value := recSet.Fields.Item[10].Value;
  SpinEditTagColumn.Value := recSet.Fields.Item[11].Value;
  SpinEditTagWidth.Value := recSet.Fields.Item[12].Value;

  unitLabel := DatabaseModule.GetAreaUnitLabelForRDIIAreaConverter(RDIIAreaConverterName);
  UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(UnitLabel);

  end;
end;

procedure TfrmAddRDIIAreaDataConverter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAddRDIIAreaDataConverter.okButtonClick(Sender: TObject);
var
  unitID: integer;
  unitLabel, format, sqlStr: String;
  okToAdd: boolean;
  recordsAffected: OleVariant;
begin
  okToAdd := true;
  if (Length(NewNameEdit.Text) = 0) then begin
    okToAdd := false;
    MessageDlg('The converter name cannot be blank.',mtError,[mbOK],0);
  end;
  if boAddingNew then begin
    if (existingConverterNames.IndexOf(NewNameEdit.Text) <> -1) then begin
      okToAdd := false;
      MessageDlg('A RDIIArea converter with this name already exists.',mtError,[mbOK],0);
    end;
  end else begin
    if ((originalConverterName <> NewNameEdit.Text) and
      (existingConverterNames.IndexOf(NewNameEdit.Text) <> -1)) then begin
        okToAdd := false;
        MessageDlg('A RDIIArea converter with this name already exists.',mtError,[mbOK],0);
      end;
  end;
  if (okToAdd) then begin
    Screen.Cursor := crHourglass;
    unitLabel := UnitsComboBox.Items.Strings[UnitsComboBox.ItemIndex];
    unitID := DatabaseModule.GetAreaUnitID(unitLabel);
    if (CSVRadioButton.Checked) then format := 'CSV' else format := 'C/W';
    if boAddingNew then begin
      sqlStr := 'INSERT INTO RDIIAreaConverters (RDIIAreaConverterName,'+
              'AreaUnitID,Format,LinesToSkip,' +
              'NameColumn,NameWidth,' +
              'SewershedColumn,SewershedWidth,' +
              'AreaUnitColumn,AreaUnitWidth,AreaColumn,AreaWidth,' +
              'LoadPointColumn,LoadPointWidth,' +
              'TagColumn,TagWidth) VALUES (' +
              '"' + NewNameEdit.Text + '",' +
              inttostr(unitID) + ',' +
              '"' + format + '",' +
              inttostr(LinesToSkipSpinEdit.Value) + ',' +
              inttostr(SpinEditNameColumn.Value) + ',' +
              inttostr(SpinEditNameWidth.Value) + ',' +
              inttostr(SpinEditSewerShedNameColumn.Value) + ',' +
              inttostr(SpinEditSewerShedNameWidth.Value) + ',' +
              //inttostr(SpinEditAreaUnitsColumn.Value) + ',' +
              //inttostr(SpinEditAreaUnitsWidth.Value) + ',' +
              inttostr(0) + ',' +
              inttostr(0) + ',' +
              inttostr(SpinEditAreaColumn.Value) + ',' +
              inttostr(SpinEditAreaWidth.Value) + ',' +
              inttostr(SpinEditLoadPointColumn.Value) + ',' +
              inttostr(SpinEditLoadPointWidth.Value) + ',' +
              inttostr(SpinEditTagColumn.Value) + ',' +
              inttostr(SpinEditTagWidth.Value) + ');';
      frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
      Screen.Cursor := crDefault;
    end else begin
      recSet.Fields.Item[0].Value := LinesToSkipSpinEdit.Value;
      recSet.Fields.Item[1].Value := SpinEditNameColumn.Value;
      recSet.Fields.Item[2].Value := SpinEditNameWidth.Value;
      recSet.Fields.Item[3].Value := SpinEditSewerShedNameColumn.Value;
      recSet.Fields.Item[4].Value := SpinEditSewerShedNameWidth.Value;
      recSet.Fields.Item[5].Value:= 0; //SpinEditAreaUnitsColumn.Value;
      recSet.Fields.Item[6].Value := 0; //SpinEditAreaUnitsWidth.Value;
      recSet.Fields.Item[7].Value := SpinEditAreaColumn.Value;
      recSet.Fields.Item[8].Value := SpinEditAreaWidth.Value;
      recSet.Fields.Item[9].Value := SpinEditLoadPointColumn.Value;
      recSet.Fields.Item[10].Value := SpinEditLoadPointWidth.Value;
      recSet.Fields.Item[11].Value := SpinEditTagColumn.Value;
      recSet.Fields.Item[12].Value := SpinEditTagWidth.Value;
      if (CSVRadioButton.Checked)
        then recSet.Fields.Item[13].Value := 'CSV'
        else recSet.Fields.Item[13].Value := 'C/W';
      recSet.Fields.Item[14].Value := NewNameEdit.Text;
      unitLabel := UnitsComboBox.Items.Strings[UnitsComboBox.ItemIndex];
      unitID := DatabaseModule.GetAreaUnitID(unitLabel);
      recSet.Fields.Item[15].Value := unitID;
      recSet.UpdateBatch(1);
      {recSet is closed in FormClose procedure}
    end;
    Close;
  end;
end;

procedure TfrmAddRDIIAreaDataConverter.CSVRadioButtonClick(Sender: TObject);
begin
  SpinEditNameWidth.Enabled := False;
  SpinEditAreaUnitsWidth.Enabled := False;
  SpinEditAreaWidth.Enabled := False;
  SpinEditLoadPointWidth.Enabled := False;
  SpinEditTagWidth.Enabled := False;
  SpinEditSewerShedNameWidth.Enabled := False;
end;


procedure TfrmAddRDIIAreaDataConverter.ColumnWidthRadioButtonClick(Sender: TObject);
begin
  SpinEditNameWidth.Enabled := True;
  SpinEditAreaUnitsWidth.Enabled := True;
  SpinEditAreaWidth.Enabled := True;
  SpinEditLoadPointWidth.Enabled := True;
  SpinEditTagWidth.Enabled := True;
  SpinEditSewerShedNameWidth.Enabled := true;
end;

procedure TfrmAddRDIIAreaDataConverter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  existingConverterNames.Free;
  if not boAddingNew then recSet.close;
end;

procedure TfrmAddRDIIAreaDataConverter.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

end.
