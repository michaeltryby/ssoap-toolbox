unit editraindataconverter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, ADODB_TLB;

type
  TfrmEditRainDataConverter = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    NameEdit: TEdit;
    UnitsComboBox: TComboBox;
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
    RainColumnSpinEdit: TSpinEdit;
    RainWidthSpinEdit: TSpinEdit;
    RadioGroup1: TRadioGroup;
    ColumnWidthRadioButton: TRadioButton;
    CSVRadioButton: TRadioButton;
    MilitaryTimeCheckBox: TCheckBox;
    AMPMSpinEdit: TSpinEdit;
    CodeColumnSpinEdit: TSpinEdit;
    CodeWidthSpinEdit: TSpinEdit;
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ColumnWidthRadioButtonClick(Sender: TObject);
    procedure CSVRadioButtonClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure helpButtonClick(Sender: TObject);
    procedure MilitaryTimeCheckBoxClick(Sender: TObject);
  private { Private declarations }
    recSet: _recordSet;
    otherConverterNames: TStringList;
    procedure SetAMPMSpinEnabled;
  public { Public declarations }
  end;

var
  frmEditRainDataConverter: TfrmEditRainDataConverter;

implementation

uses rainconvertermanager, modDatabase, mainform;

{$R *.DFM}

procedure TfrmEditRainDataConverter.FormShow(Sender: TObject);
var
  rainConverterName, unitLabel, queryStr: String;
begin
  rainConverterName := frmRainConverterManagement.SelectedRainConverterName;
  NameEdit.Text := rainConverterName;

  queryStr := 'SELECT LinesToSkip, MonthColumn, MonthWidth, DayColumn, DayWidth,' +
              'YearColumn, YearWidth, HourColumn, HourWidth, MinuteColumn,' +
              'MinuteWidth, RainColumn, RainWidth, CodeColumn, CodeWidth, Format, ' +
              'AMPMColumn, MilitaryTime, RainConverterName, RainUnitID ' +
              'FROM RainConverters WHERE (RainConverterName = "' + rainConverterName + '");';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;

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
  RainColumnSpinEdit.Value := recSet.Fields.Item[11].Value;
  RainWidthSpinEdit.Value := recSet.Fields.Item[12].Value;
  //rm 2009-06-09 - Beta 1 review - Code not used, confusing
  //not importing code anymore
  //CodeColumnSpinEdit.Value := recSet.Fields.Item[13].Value;
  //CodeWidthSpinEdit.Value := recSet.Fields.Item[14].Value;
  if (recSet.Fields.Item[15].Value = 'CSV') then begin
    CSVRadioButton.Checked := True;
    CSVRadioButtonClick(Self);
  end
  else begin
    ColumnWidthRadioButton.Checked := True;
    ColumnWidthRadioButtonClick(Self);
  end;
  AMPMSpinEdit.Value := recSet.Fields.Item[16].Value;

  if (recSet.Fields.Item[17].Value)
    then MilitaryTimeCheckBox.Checked := True
    else MilitaryTimeCheckBox.Checked := False;

  //rm 2009-06-09
  SetAMPMSpinEnabled;

  unitLabel := DatabaseModule.GetRainUnitLabelForRainConverter(rainConverterName);
  UnitsComboBox.Items := DatabaseModule.GetRainUnitLabels();
  UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(unitLabel);

  otherConverterNames := DatabaseModule.GetRainConverterNames();
  otherConverterNames.Delete(otherConverterNames.IndexOf(rainConverterName));
end;

procedure TfrmEditRainDataConverter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEditRainDataConverter.MilitaryTimeCheckBoxClick(Sender: TObject);
begin
  SetAMPMSpinEnabled;
end;

procedure TfrmEditRainDataConverter.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditRainDataConverter.okButtonClick(Sender: TObject);
var
  unitID: integer;
  unitLabel: String;
  okToAdd: boolean;
begin
  okToAdd := true;
  if (otherConverterNames.IndexOf(NameEdit.Text) <> -1) then begin
    okToAdd := false;
    MessageDlg('Another rain converter with this name already exists.',mtError,[mbOK],0);
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
    recSet.Fields.Item[11].Value := RainColumnSpinEdit.Value;
    recSet.Fields.Item[12].Value := RainWidthSpinEdit.Value;
    //rm 2009-06-09 - Beta 1 review - Code not used, confusing
    //not importing code anymore
    //recSet.Fields.Item[13].Value := CodeColumnSpinEdit.Value;
    //recSet.Fields.Item[14].Value := CodeWidthSpinEdit.Value;
    recSet.Fields.Item[13].Value := 0;
    recSet.Fields.Item[14].Value := 0;
    //rm
    if (CSVRadioButton.Checked)
      then recSet.Fields.Item[15].Value := 'CSV'
      else recSet.Fields.Item[15].Value := 'C/W';
    recSet.Fields.Item[16].Value := AMPMSpinEdit.Value;
    if (MilitaryTimeCheckBox.Checked)
      then recSet.Fields.Item[17].Value := 1
      else recSet.Fields.Item[17].Value := 0;
    recSet.Fields.Item[18].Value := NameEdit.Text;
    unitLabel := UnitsComboBox.Items.Strings[UnitsComboBox.ItemIndex];
    unitID := DatabaseModule.GetRainUnitID(unitLabel);
    recSet.Fields.Item[19].Value := unitID;

    recSet.UpdateBatch(1);
    {recSet is closed in FormClose procedure}
    Close;
  end;
end;

procedure TfrmEditRainDataConverter.SetAMPMSpinEnabled;
begin
  //rm 2009-06-08 - Beta 1 review says AM/PM selector is still selectable when set to Military time
  AMPMSpinEdit.Enabled := not MilitaryTimeCheckBox.Checked;
end;

procedure TfrmEditRainDataConverter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  otherConverterNames.Free;
  recSet.Close
end;

procedure TfrmEditRainDataConverter.ColumnWidthRadioButtonClick(Sender: TObject);
begin
  MonthWidthSpinEdit.Enabled := True;
  DayWidthSpinEdit.Enabled := True;
  YearWidthSpinEdit.Enabled := True;
  HourWidthSpinEdit.Enabled := True;
  MinuteWidthSpinEdit.Enabled := True;
  RainWidthSpinEdit.Enabled := True;
  CodeWidthSpinEdit.Enabled := True;
end;

procedure TfrmEditRainDataConverter.CSVRadioButtonClick(Sender: TObject);
begin
  MonthWidthSpinEdit.Enabled := False;
  DayWidthSpinEdit.Enabled := False;
  YearWidthSpinEdit.Enabled := False;
  HourWidthSpinEdit.Enabled := False;
  MinuteWidthSpinEdit.Enabled := False;
  RainWidthSpinEdit.Enabled := False;
  CodeWidthSpinEdit.Enabled := False;
end;

end.
