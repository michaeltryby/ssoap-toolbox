unit editsewersheddataconverter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, ADODB_TLB;

type
  TfrmEditSewerShedDataConverter = class(TForm)
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
    NameEdit: TEdit;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    LinesToSkipSpinEdit: TSpinEdit;
    NameColumnSpinEdit: TSpinEdit;
    NameWidthSpinEdit: TSpinEdit;
    AreaUnitColumnSpinEdit: TSpinEdit;
    AreaUnitWidthSpinEdit: TSpinEdit;
    SpinEditAreaColumn: TSpinEdit;
    SpinEditAreaWidth: TSpinEdit;
    SpinEditRainGaugeIDColumn: TSpinEdit;
    SpinEditRainGaugeIDWidth: TSpinEdit;
    SpinEditLoadPointColumn: TSpinEdit;
    SpinEditLoadPointWidth: TSpinEdit;
    SpinEditTagColumn: TSpinEdit;
    SpinEditTagWidth: TSpinEdit;
    RadioGroup1: TRadioGroup;
    ColumnWidthRadioButton: TRadioButton;
    CSVRadioButton: TRadioButton;
    UnitsComboBox: TComboBox;
    Label12: TLabel;
    SpinEditFlowMonitorColumn: TSpinEdit;
    SpinEditFlowMonitorWidth: TSpinEdit;
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure ColumnWidthRadioButtonClick(Sender: TObject);
    procedure CSVRadioButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    otherConverterNames: TStringList;
    recSet: _recordSet;
  public { Public declarations }
    SelectedSewerShedConverterName : string;
  end;

var
  frmEditSewerShedDataConverter: TfrmEditSewerShedDataConverter;

implementation

uses SewerShedconvertermanager, modDatabase, mainform;
{$R *.DFM}

procedure TfrmEditSewerShedDataConverter.FormShow(Sender: TObject);
var
  SewerShedConverterName, queryStr: string;
  unitLabel: string;
begin
//  SewerShedConverterName := frmSewerShedConverterManagement.SelectedSewerShedConverterName;
  SewerShedConverterName := SelectedSewerShedConverterName;
  NameEdit.Text := SewerShedConverterName;

  queryStr := 'SELECT LinesToSkip, NameColumn, NameWidth, ' +
              ' AreaUnitColumn, AreaUnitWidth,'+
              ' AreaColumn, AreaWidth,' +
              ' RainGaugeIDColumn, RainGaugeIDWidth,' +
              ' FlowMeterIDColumn, FlowMeterIDWidth,' +
              ' LoadPointColumn, LoadPointWidth, TagColumn, TagWidth, ' +
              ' [Format], SewerShedConverterName, AreaUnitID' +
              ' FROM SewerShedConverters WHERE (SewerShedConverterName = "' + SewerShedConverterName + '");';

  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;

  LinesToSkipSpinEdit.Value := recSet.Fields.Item[0].Value;
  NameColumnSpinEdit.Value := recSet.Fields.Item[1].Value;
  NameWidthSpinEdit.Value := recSet.Fields.Item[2].Value;
  AreaUnitColumnSpinEdit.Value := recSet.Fields.Item[3].Value;
  AreaUnitWidthSpinEdit.Value := recSet.Fields.Item[4].Value;
  SpinEditAreaColumn.Value := recSet.Fields.Item[5].Value;
  SpinEditAreaWidth.Value := recSet.Fields.Item[6].Value;
  SpinEditRainGaugeIDColumn.Value := recSet.Fields.Item[7].Value;
  SpinEditRainGaugeIDWidth.Value := recSet.Fields.Item[8].Value;
  SpinEditFlowMonitorColumn.Value := recSet.Fields.Item[9].Value;
  SpinEditFlowMonitorWidth.Value := recSet.Fields.Item[10].Value;

  SpinEditLoadPointColumn.Value := recSet.Fields.Item[11].Value;
  SpinEditLoadPointWidth.Value := recSet.Fields.Item[12].Value;
  SpinEditTagColumn.Value := recSet.Fields.Item[13].Value;
  SpinEditTagWidth.Value := recSet.Fields.Item[14].Value;

  unitLabel := DatabaseModule.GetAreaUnitLabelForSewerShedConverter(SewerShedConverterName);
  UnitsComboBox.Items := DatabaseModule.GetAreaUnitLabels();
  UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(UnitLabel);

  otherConverterNames := DatabaseModule.GetSewerShedConverterNames();
  otherConverterNames.Delete(otherConverterNames.IndexOf(SewerShedConverterName));
end;

procedure TfrmEditSewerShedDataConverter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEditSewerShedDataConverter.okButtonClick(Sender: TObject);
var
  unitID: integer;
  unitLabel: String;
  okToAdd: boolean;
begin
  okToAdd := true;
  if (otherConverterNames.IndexOf(NameEdit.Text) <> -1) then begin
    okToAdd := false;
    MessageDlg('Another sewershed converter with this name already exists.',mtError,[mbOK],0);
  end;
  if (Length(NameEdit.Text) = 0) then begin
    okToAdd := false;
    MessageDlg('The converter name cannot be blank.',mtError,[mbOK],0);
  end;
  if (okToAdd) then begin
    recSet.Fields.Item[0].Value := LinesToSkipSpinEdit.Value;
    recSet.Fields.Item[1].Value := NameColumnSpinEdit.Value;
    recSet.Fields.Item[2].Value := NameWidthSpinEdit.Value;
    recSet.Fields.Item[3].Value:= AreaUnitColumnSpinEdit.Value;
    recSet.Fields.Item[4].Value := AreaUnitWidthSpinEdit.Value;
    recSet.Fields.Item[5].Value := SpinEditAreaColumn.Value;
    recSet.Fields.Item[6].Value := SpinEditAreaWidth.Value;
    recSet.Fields.Item[7].Value := SpinEditRainGaugeIDColumn.Value;
    recSet.Fields.Item[8].Value := SpinEditRainGaugeIDWidth.Value;
    recSet.Fields.Item[9].Value := SpinEditFlowMonitorColumn.Value;
    recSet.Fields.Item[10].Value := SpinEditFlowMonitorWidth.Value;
    recSet.Fields.Item[11].Value := SpinEditLoadPointColumn.Value;
    recSet.Fields.Item[12].Value := SpinEditLoadPointWidth.Value;
    recSet.Fields.Item[13].Value := SpinEditTagColumn.Value;
    recSet.Fields.Item[14].Value := SpinEditTagWidth.Value;
    if (CSVRadioButton.Checked)
      then recSet.Fields.Item[15].Value := 'CSV'
      else recSet.Fields.Item[15].Value := 'C/W';
    recSet.Fields.Item[16].Value := NameEdit.Text;

    unitLabel := UnitsComboBox.Items.Strings[UnitsComboBox.ItemIndex];
    unitID := DatabaseModule.GetAreaUnitID(unitLabel);
    recSet.Fields.Item[17].Value := unitID;

    recSet.UpdateBatch(1);
    {recSet is closed in FormClose procedure}
    Close;
  end;
end;

procedure TfrmEditSewerShedDataConverter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  otherConverterNames.Free;
  recSet.Close
end;

procedure TfrmEditSewerShedDataConverter.ColumnWidthRadioButtonClick(
  Sender: TObject);
begin
  NameWidthSpinEdit.Enabled := True;
  AreaUnitWidthSpinEdit.Enabled := True;
  SpinEditAreaWidth.Enabled := True;
  SpinEditRainGaugeIDWidth.Enabled := True;
  SpinEditFlowMonitorWidth.Enabled := True;
  SpinEditLoadPointWidth.Enabled := True;
  SpinEditTagWidth.Enabled := True;
end;

procedure TfrmEditSewerShedDataConverter.CSVRadioButtonClick(
  Sender: TObject);
begin
  NameWidthSpinEdit.Enabled := False;
  AreaUnitWidthSpinEdit.Enabled := False;
  SpinEditAreaWidth.Enabled := False;
  SpinEditRainGaugeIDWidth.Enabled := False;
  SpinEditFlowMonitorWidth.Enabled := False;
  SpinEditLoadPointWidth.Enabled := False;
  SpinEditTagWidth.Enabled := False;
end;


procedure TfrmEditSewerShedDataConverter.cancelButtonClick(
  Sender: TObject);
begin
  Close;
end;

end.
