unit editrdiidataconverter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, ADODB_TLB;

type
  TfrmEditRdiiDataConverter = class(TForm)
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
    NodeColumnSpinEdit: TSpinEdit;
    NodeWidthSpinEdit: TSpinEdit;
    AreaColumnSpinEdit: TSpinEdit;
    AreaWidthSpinEdit: TSpinEdit;
    NodeLocationXColumnSpinEdit: TSpinEdit;
    NodeLocationXWidthSpinEdit: TSpinEdit;
    NodeLocationYColumnSpinEdit: TSpinEdit;
    NodeLocationYWidthSpinEdit: TSpinEdit;
    TagColumnSpinEdit: TSpinEdit;
    TagWidthSpinEdit: TSpinEdit;
    CodeColumnSpinEdit: TSpinEdit;
    CodeWidthSpinEdit: TSpinEdit;
    RadioGroup1: TRadioGroup;
    ColumnWidthRadioButton: TRadioButton;
    CSVRadioButton: TRadioButton;
    UnitsComboBox: TComboBox;
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
  end;

var
  frmEditRdiiDataConverter: TfrmEditRdiiDataConverter;

implementation

uses rdiiconvertermanager, modDatabase, mainform;
{$R *.DFM}

procedure TfrmEditRdiiDataConverter.FormShow(Sender: TObject);
var
  rdiiConverterName, queryStr: string;
  unitLabel: string;
begin
  rdiiConverterName := frmRdiiConverterManagement.SelectedrdiiConverterName;
  NameEdit.Text := rdiiConverterName;

  queryStr := 'SELECT LinesToSkip, NodeColumn, NodeWidth, AreaColumn, AreaWidth,' +
              'NodeLocationXColumn, NodeLocationXWidth, NodeLocationYColumn, NodeLocationYWidth, TagColumn,' +
              'TagWidth,' +
              'CodeColumn, CodeWidth, Format, rdiiConverterName,' +
              'AreaUnitID ' +
              'FROM RdiiConverters WHERE (rdiiConverterName = "' + rdiiConverterName + '");';

  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;

  LinesToSkipSpinEdit.Value := recSet.Fields.Item[0].Value;
  NodeColumnSpinEdit.Value := recSet.Fields.Item[1].Value;
  NodeWidthSpinEdit.Value := recSet.Fields.Item[2].Value;
  AreaColumnSpinEdit.Value := recSet.Fields.Item[3].Value;
  AreaWidthSpinEdit.Value := recSet.Fields.Item[4].Value;
  NodeLocationXColumnSpinEdit.Value := recSet.Fields.Item[5].Value;
  NodeLocationXWidthSpinEdit.Value := recSet.Fields.Item[6].Value;
  NodeLocationYColumnSpinEdit.Value := recSet.Fields.Item[7].Value;
  NodeLocationYWidthSpinEdit.Value := recSet.Fields.Item[8].Value;
  TagColumnSpinEdit.Value := recSet.Fields.Item[9].Value;
  TagWidthSpinEdit.Value := recSet.Fields.Item[10].Value;
  CodeColumnSpinEdit.Value := recSet.Fields.Item[11].Value;
  CodeWidthSpinEdit.Value := recSet.Fields.Item[12].Value;

  unitLabel := DatabaseModule.GetAreaUnitLabelForRdiiConverter(rdiiConverterName);
  UnitsComboBox.Items := DatabaseModule.GetAreaUnitLabels();
  UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(UnitLabel);

  otherConverterNames := DatabaseModule.GetrdiiConverterNames();
  otherConverterNames.Delete(otherConverterNames.IndexOf(rdiiConverterName));
end;

procedure TfrmEditRdiiDataConverter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEditRdiiDataConverter.okButtonClick(Sender: TObject);
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
    recSet.Fields.Item[1].Value := NodeColumnSpinEdit.Value;
    recSet.Fields.Item[2].Value := NodeWidthSpinEdit.Value;
    recSet.Fields.Item[3].Value:= AreaColumnSpinEdit.Value;
    recSet.Fields.Item[4].Value := AreaWidthSpinEdit.Value;
    recSet.Fields.Item[5].Value := NodeLocationXColumnSpinEdit.Value;
    recSet.Fields.Item[6].Value := NodeLocationXWidthSpinEdit.Value;
    recSet.Fields.Item[7].Value := NodeLocationYColumnSpinEdit.Value;
    recSet.Fields.Item[8].Value := NodeLocationYWidthSpinEdit.Value;
    recSet.Fields.Item[9].Value := TagColumnSpinEdit.Value;
    recSet.Fields.Item[10].Value := TagWidthSpinEdit.Value;
    recSet.Fields.Item[11].Value := CodeColumnSpinEdit.Value;
    recSet.Fields.Item[12].Value := CodeWidthSpinEdit.Value;
    if (CSVRadioButton.Checked)
      then recSet.Fields.Item[13].Value := 'CSV'
      else recSet.Fields.Item[13].Value := 'C/W';
    recSet.Fields.Item[14].Value := NameEdit.Text;

    unitLabel := UnitsComboBox.Items.Strings[UnitsComboBox.ItemIndex];
    unitID := DatabaseModule.GetRdiiUnitID(unitLabel);
    recSet.Fields.Item[15].Value := unitID;

    recSet.UpdateBatch(1);
    {recSet is closed in FormClose procedure}
    Close;
  end;
end;

procedure TfrmEditRdiiDataConverter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  otherConverterNames.Free;
  recSet.Close
end;

procedure TfrmEditRdiiDataConverter.ColumnWidthRadioButtonClick(
  Sender: TObject);
begin
  NodeWidthSpinEdit.Enabled := True;
  AreaWidthSpinEdit.Enabled := True;
  NodeLocationXWidthSpinEdit.Enabled := True;
  NodeLocationYWidthSpinEdit.Enabled := True;
  TagWidthSpinEdit.Enabled := True;
  CodeWidthSpinEdit.Enabled := True;
end;

procedure TfrmEditRdiiDataConverter.CSVRadioButtonClick(
  Sender: TObject);
begin
  NodeWidthSpinEdit.Enabled := False;
  AreaWidthSpinEdit.Enabled := False;
  NodeLocationXWidthSpinEdit.Enabled := False;
  NodeLocationYWidthSpinEdit.Enabled := False;
  TagWidthSpinEdit.Enabled := False;
  CodeWidthSpinEdit.Enabled := False;
end;


procedure TfrmEditRdiiDataConverter.cancelButtonClick(
  Sender: TObject);
begin
  Close;
end;

end.
