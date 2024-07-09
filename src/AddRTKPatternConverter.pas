unit AddRTKPatternConverter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, ADODB_TLB;

type
  TfrmAddRTKPatternConverter = class(TForm)
    Label1: TLabel;
    NewNameEdit: TEdit;
    Label3: TLabel;
    LinesToSkipSpinEdit: TSpinEdit;
    RadioGroup1: TRadioGroup;
    Label10: TLabel;
    Label11: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    SpinEditK1Column: TSpinEdit;
    SpinEditK1Width: TSpinEdit;
    SpinEditT1Column: TSpinEdit;
    SpinEditT1Width: TSpinEdit;
    SpinEditR1Column: TSpinEdit;
    SpinEditR1Width: TSpinEdit;
    SpinEditCommentsColumn: TSpinEdit;
    SpinEditCommentsWidth: TSpinEdit;
    SpinEditNameColumn: TSpinEdit;
    SpinEditNameWidth: TSpinEdit;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    CSVRadioButton: TRadioButton;
    ColumnWidthRadioButton: TRadioButton;
    Label2: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    SpinEditR2Column: TSpinEdit;
    SpinEditT2Column: TSpinEdit;
    SpinEditK2Column: TSpinEdit;
    SpinEditR2Width: TSpinEdit;
    SpinEditT2Width: TSpinEdit;
    SpinEditK2Width: TSpinEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    SpinEditR3Column: TSpinEdit;
    SpinEditT3Column: TSpinEdit;
    SpinEditK3Column: TSpinEdit;
    SpinEditR3Width: TSpinEdit;
    SpinEditT3Width: TSpinEdit;
    SpinEditK3Width: TSpinEdit;
    gbAdvanced: TGroupBox;
    Label16: TLabel;
    SpinEditAMColumn: TSpinEdit;
    SpinEditAMWidth: TSpinEdit;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    SpinEditARColumn: TSpinEdit;
    SpinEditARWidth: TSpinEdit;
    Label20: TLabel;
    SpinEditAIColumn: TSpinEdit;
    SpinEditAIWidth: TSpinEdit;
    Label21: TLabel;
    SpinEditMonColumn: TSpinEdit;
    SpinEditMonWidth: TSpinEdit;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    SpinEditAM2Column: TSpinEdit;
    SpinEditAR2Column: TSpinEdit;
    SpinEditAI2Column: TSpinEdit;
    SpinEditAM2Width: TSpinEdit;
    SpinEditAR2Width: TSpinEdit;
    SpinEditAI2Width: TSpinEdit;
    Label25: TLabel;
    SpinEditAM3Column: TSpinEdit;
    SpinEditAM3Width: TSpinEdit;
    Label26: TLabel;
    SpinEditAR3Column: TSpinEdit;
    SpinEditAR3Width: TSpinEdit;
    Label27: TLabel;
    SpinEditAI3Column: TSpinEdit;
    SpinEditAI3Width: TSpinEdit;
    procedure CSVRadioButtonClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure helpButtonClick(Sender: TObject);
  private
    { Private declarations }
    existingConverterNames: TStringList;
    recSet: _recordSet;
  public
    { Public declarations }
    boAddingNew: boolean;
    SelectedRTKPatternConverterName: string;
  end;

var
  frmAddRTKPatternConverter: TfrmAddRTKPatternConverter;
  originalConverterName: string;

implementation

uses modDatabase, rtkpatternconvertermanager, mainform;

{$R *.dfm}

procedure TfrmAddRTKPatternConverter.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAddRTKPatternConverter.CSVRadioButtonClick(Sender: TObject);
begin
  SpinEditNameWidth.Enabled := ColumnWidthRadioButton.Checked;
  SpinEditCommentsWidth.Enabled := ColumnWidthRadioButton.Checked;
  SpinEditR1Width.Enabled := ColumnWidthRadioButton.Checked;
  SpinEditT1Width.Enabled := ColumnWidthRadioButton.Checked;
  SpinEditK1Width.Enabled := ColumnWidthRadioButton.Checked;
  SpinEditR2Width.Enabled := ColumnWidthRadioButton.Checked;
  SpinEditT2Width.Enabled := ColumnWidthRadioButton.Checked;
  SpinEditK2Width.Enabled := ColumnWidthRadioButton.Checked;
  SpinEditR3Width.Enabled := ColumnWidthRadioButton.Checked;
  SpinEditT3Width.Enabled := ColumnWidthRadioButton.Checked;
  SpinEditK3Width.Enabled := ColumnWidthRadioButton.Checked;
end;

procedure TfrmAddRTKPatternConverter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  existingConverterNames.Free;
  if not boAddingNew then recSet.close;
end;

procedure TfrmAddRTKPatternConverter.FormShow(Sender: TObject);
var
  RTKPatternConverterName, queryStr, formatStr: string;
begin
  existingConverterNames := DatabaseModule.GetRTKPatternConverterNames();
  if boAddingNew then begin
    Caption := 'Add RTK Pattern Data Converter';
    NewNameEdit.Text := 'New Converter';
    originalconverterName := ''
  end else begin
    Caption := 'Edit RTK Pattern Data Converter';
    RTKPatternConverterName := SelectedRTKPatternConverterName;
    originalConverterName := RTKPatternConverterName;
    NewNameEdit.Text := RTKPatternConverterName;

    queryStr := 'SELECT LinesToSkip, [Format], NameColumn, NameWidth, ' +
              ' CommentsColumn, CommentsWidth,' +
              ' R1Column, R1Width,'+
              ' T1Column, T1Width,' +
              ' K1Column, K1Width, ' +
              ' R2Column, R2Width,'+
              ' T2Column, T2Width,' +
              ' K2Column, K2Width, ' +
              ' R3Column, R3Width,'+
              ' T3Column, T3Width,' +
              ' K3Column, K3Width, ' +
              //rm 2010-10-07
              ' AMColumn, AMWidth,'+
              ' ARColumn, ARWidth,' +
              ' AIColumn, AIWidth, ' +
              ' AM2Column, AM2Width,'+
              ' AR2Column, AR2Width,' +
              ' AI2Column, AI2Width, ' +
              ' AM3Column, AM3Width,'+
              ' AR3Column, AR3Width,' +
              ' AI3Column, AI3Width, ' +
              ' MonColumn, MonWidth ' +
              //rm
              ' FROM RTKPatternConverters WHERE (RTKPatternConverterName = "' + RTKPatternConverterName + '");';

    recSet := CoRecordSet.Create;
    recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
    recSet.MoveFirst;

    LinesToSkipSpinEdit.Value := recSet.Fields.Item[0].Value;
    formatStr := recSet.Fields.Item[1].Value;
    SpinEditNameColumn.Value := recSet.Fields.Item[2].Value;
    SpinEditNameWidth.Value := recSet.Fields.Item[3].Value;
    SpinEditCommentsColumn.Value := recSet.Fields.Item[4].Value;
    SpinEditCommentsWidth.Value := recSet.Fields.Item[5].Value;
    SpinEditR1Column.Value := recSet.Fields.Item[6].Value;
    SpinEditR1Width.Value := recSet.Fields.Item[7].Value;
    SpinEditT1Column.Value := recSet.Fields.Item[8].Value;
    SpinEditT1Width.Value := recSet.Fields.Item[9].Value;
    SpinEditK1Column.Value := recSet.Fields.Item[10].Value;
    SpinEditK1Width.Value := recSet.Fields.Item[11].Value;

    SpinEditR2Column.Value := recSet.Fields.Item[12].Value;
    SpinEditR2Width.Value := recSet.Fields.Item[13].Value;
    SpinEditT2Column.Value := recSet.Fields.Item[14].Value;
    SpinEditT2Width.Value := recSet.Fields.Item[15].Value;
    SpinEditK2Column.Value := recSet.Fields.Item[16].Value;
    SpinEditK2Width.Value := recSet.Fields.Item[17].Value;

    SpinEditR3Column.Value := recSet.Fields.Item[18].Value;
    SpinEditR3Width.Value := recSet.Fields.Item[19].Value;
    SpinEditT3Column.Value := recSet.Fields.Item[20].Value;
    SpinEditT3Width.Value := recSet.Fields.Item[21].Value;
    SpinEditK3Column.Value := recSet.Fields.Item[22].Value;
    SpinEditK3Width.Value := recSet.Fields.Item[23].Value;

    //rm 2010-10-07
    SpinEditAMColumn.Value := recSet.Fields.Item[24].Value;
    SpinEditAMWidth.Value := recSet.Fields.Item[25].Value;
    SpinEditARColumn.Value := recSet.Fields.Item[26].Value;
    SpinEditARWidth.Value := recSet.Fields.Item[27].Value;
    SpinEditAIColumn.Value := recSet.Fields.Item[28].Value;
    SpinEditAIWidth.Value := recSet.Fields.Item[29].Value;

    SpinEditAM2Column.Value := recSet.Fields.Item[30].Value;
    SpinEditAM2Width.Value := recSet.Fields.Item[31].Value;
    SpinEditAR2Column.Value := recSet.Fields.Item[32].Value;
    SpinEditAR2Width.Value := recSet.Fields.Item[33].Value;
    SpinEditAI2Column.Value := recSet.Fields.Item[34].Value;
    SpinEditAI2Width.Value := recSet.Fields.Item[35].Value;

    SpinEditAM3Column.Value := recSet.Fields.Item[36].Value;
    SpinEditAM3Width.Value := recSet.Fields.Item[37].Value;
    SpinEditAR3Column.Value := recSet.Fields.Item[38].Value;
    SpinEditAR3Width.Value := recSet.Fields.Item[39].Value;
    SpinEditAI3Column.Value := recSet.Fields.Item[40].Value;
    SpinEditAI3Width.Value := recSet.Fields.Item[41].Value;

    SpinEditMonColumn.Value := recSet.Fields.Item[42].Value;
    SpinEditMonWidth.Value := recSet.Fields.Item[43].Value;
    //rm

    if UpperCase(formatStr) = 'CSV' then
      CSVRadioButton.Checked := true
    else
      ColumnWidthRadioButton.Checked := true;

  end;
end;

procedure TfrmAddRTKPatternConverter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAddRTKPatternConverter.okButtonClick(Sender: TObject);
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
      MessageDlg('An RTK Pattern converter with this name already exists.',mtError,[mbOK],0);
    end;
  end else begin
    if ((originalConverterName <> NewNameEdit.Text) and
      (existingConverterNames.IndexOf(NewNameEdit.Text) <> -1)) then begin
        okToAdd := false;
        MessageDlg('An RTK Pattern converter with this name already exists.',mtError,[mbOK],0);
      end;
  end;
  if (okToAdd) then begin
    Screen.Cursor := crHourglass;
    if (CSVRadioButton.Checked) then format := 'CSV' else format := 'C/W';
    if boAddingNew then begin
      sqlStr := 'INSERT INTO RTKPatternConverters (RTKPatternConverterName, '+
              ' LinesToSkip, [Format], ' +
              ' NameColumn, NameWidth, ' +
              ' CommentsColumn, CommentsWidth, ' +
              ' R1Column, R1Width, T1Column, T1Width, K1Column, K1Width, ' +
              ' R2Column, R2Width, T2Column, T2Width, K2Column, K2Width, ' +
              ' R3Column, R3Width, T3Column, T3Width, K3Column, K3Width, ' +
              ' AMColumn, AMWidth, ARColumn, ARWidth, AIColumn, AIWidth, ' +
              //rm 2010-10-07
              ' AM2Column, AM2Width, AR2Column, AR2Width, AI2Column, AI2Width, ' +
              ' AM3Column, AM3Width, AR3Column, AR3Width, AI3Column, AI3Width, ' +
              //rm
              ' MonColumn, MonWidth' +
              ') VALUES (' +
              '"' + NewNameEdit.Text + '",' +
              inttostr(LinesToSkipSpinEdit.Value) + ',' +
              '"' + format + '",' +
              inttostr(SpinEditNameColumn.Value) + ',' +
              inttostr(SpinEditNameWidth.Value) + ',' +
              inttostr(SpinEditCommentsColumn.Value) + ',' +
              inttostr(SpinEditCommentsWidth.Value) + ',' +
              inttostr(SpinEditR1Column.Value) + ',' +
              inttostr(SpinEditR1Width.Value) + ',' +
              inttostr(SpinEditT1Column.Value) + ',' +
              inttostr(SpinEditT1Width.Value) + ',' +
              inttostr(SpinEditK1Column.Value) + ',' +
              inttostr(SpinEditK1Width.Value) + ',' +
              inttostr(SpinEditR2Column.Value) + ',' +
              inttostr(SpinEditR2Width.Value) + ',' +
              inttostr(SpinEditT2Column.Value) + ',' +
              inttostr(SpinEditT2Width.Value) + ',' +
              inttostr(SpinEditK2Column.Value) + ',' +
              inttostr(SpinEditK2Width.Value) + ',' +
              inttostr(SpinEditR3Column.Value) + ',' +
              inttostr(SpinEditR3Width.Value) + ',' +
              inttostr(SpinEditT3Column.Value) + ',' +
              inttostr(SpinEditT3Width.Value) + ',' +
              inttostr(SpinEditK3Column.Value) + ',' +
              inttostr(SpinEditK3Width.Value) + ',' +
              inttostr(SpinEditAMColumn.Value) + ',' +
              inttostr(SpinEditAMWidth.Value) + ',' +
              inttostr(SpinEditARColumn.Value) + ',' +
              inttostr(SpinEditARWidth.Value) + ',' +
              inttostr(SpinEditAIColumn.Value) + ',' +
              inttostr(SpinEditAIWidth.Value) + ',' +
              //rm 2010-10-07
              inttostr(SpinEditAM2Column.Value) + ',' +
              inttostr(SpinEditAM2Width.Value) + ',' +
              inttostr(SpinEditAR2Column.Value) + ',' +
              inttostr(SpinEditAR2Width.Value) + ',' +
              inttostr(SpinEditAI2Column.Value) + ',' +
              inttostr(SpinEditAI2Width.Value) + ',' +
              inttostr(SpinEditAM3Column.Value) + ',' +
              inttostr(SpinEditAM3Width.Value) + ',' +
              inttostr(SpinEditAR3Column.Value) + ',' +
              inttostr(SpinEditAR3Width.Value) + ',' +
              inttostr(SpinEditAI3Column.Value) + ',' +
              inttostr(SpinEditAI3Width.Value) + ',' +
              //rm
              inttostr(SpinEditMonColumn.Value) + ',' +
              inttostr(SpinEditMonWidth.Value) + ');';
      frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
      Screen.Cursor := crDefault;
    end else begin
      recSet.Fields.Item[0].Value := LinesToSkipSpinEdit.Value;
      if (CSVRadioButton.Checked) then
        recSet.Fields.Item[1].Value := 'CSV'
      else
        recSet.Fields.Item[1].Value := 'C/W';
      recSet.Fields.Item[2].Value := SpinEditNameColumn.Value;
      recSet.Fields.Item[3].Value := SpinEditNameWidth.Value;
      recSet.Fields.Item[4].Value := SpinEditCommentsColumn.Value;
      recSet.Fields.Item[5].Value := SpinEditCommentsWidth.Value;
      recSet.Fields.Item[6].Value:= SpinEditR1Column.Value;
      recSet.Fields.Item[7].Value := SpinEditR1Width.Value;
      recSet.Fields.Item[8].Value := SpinEditT1Column.Value;
      recSet.Fields.Item[9].Value := SpinEditT1Width.Value;
      recSet.Fields.Item[10].Value := SpinEditK1Column.Value;
      recSet.Fields.Item[11].Value := SpinEditK1Width.Value;
      recSet.Fields.Item[12].Value:= SpinEditR2Column.Value;
      recSet.Fields.Item[13].Value := SpinEditR2Width.Value;
      recSet.Fields.Item[14].Value := SpinEditT2Column.Value;
      recSet.Fields.Item[15].Value := SpinEditT2Width.Value;
      recSet.Fields.Item[16].Value := SpinEditK2Column.Value;
      recSet.Fields.Item[17].Value := SpinEditK2Width.Value;
      recSet.Fields.Item[18].Value:= SpinEditR3Column.Value;
      recSet.Fields.Item[19].Value := SpinEditR3Width.Value;
      recSet.Fields.Item[20].Value := SpinEditT3Column.Value;
      recSet.Fields.Item[21].Value := SpinEditT3Width.Value;
      recSet.Fields.Item[22].Value := SpinEditK3Column.Value;
      recSet.Fields.Item[23].Value := SpinEditK3Width.Value;

      //rm 2010-10-07

      recSet.Fields.Item[24].Value:= SpinEditAMColumn.Value;
      recSet.Fields.Item[25].Value := SpinEditAMWidth.Value;
      recSet.Fields.Item[26].Value := SpinEditARColumn.Value;
      recSet.Fields.Item[27].Value := SpinEditAR3Width.Value;
      recSet.Fields.Item[28].Value := SpinEditAIColumn.Value;
      recSet.Fields.Item[29].Value := SpinEditAIWidth.Value;

      recSet.Fields.Item[30].Value:= SpinEditAM2Column.Value;
      recSet.Fields.Item[31].Value := SpinEditAM2Width.Value;
      recSet.Fields.Item[32].Value := SpinEditAR2Column.Value;
      recSet.Fields.Item[33].Value := SpinEditAR2Width.Value;
      recSet.Fields.Item[34].Value := SpinEditAI2Column.Value;
      recSet.Fields.Item[35].Value := SpinEditAI2Width.Value;

      recSet.Fields.Item[36].Value:= SpinEditAM3Column.Value;
      recSet.Fields.Item[37].Value := SpinEditAM3Width.Value;
      recSet.Fields.Item[38].Value := SpinEditAR3Column.Value;
      recSet.Fields.Item[39].Value := SpinEditAR3Width.Value;
      recSet.Fields.Item[40].Value := SpinEditAI3Column.Value;
      recSet.Fields.Item[41].Value := SpinEditAI3Width.Value;

      recSet.Fields.Item[42].Value := SpinEditMonColumn.Value;
      recSet.Fields.Item[43].Value := SpinEditMonWidth.Value;
      //rm
      recSet.UpdateBatch(1);
      {recSet is closed in FormClose procedure}
    end;
    Close;
  end;
end;

end.
