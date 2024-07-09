{-------------------------------------------------------------------  }
{                    Unit:    AddRainconverter.pas                    }
{                    Project: EPA SSOAP Toolbox                       }
{                    Version: 1.0.0                                   }
{                    Date:    Sept 2009                               }
{                    Author:  CDM Smith                               }
{                                                                     }
{ Form unit containing the "Add Rain Converter" dialog box in DMT     }
{-------------------------------------------------------------------  }
unit addrdiiconverter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, ADODB_TLB;

type
  TfrmAddRdiiDataConverter = class(TForm)
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
    NewNameEdit: TEdit;
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
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure CSVRadioButtonClick(Sender: TObject);
    procedure ColumnWidthRadioButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    existingConverterNames: TStringList;
  public { Public declarations }
  end;

var
  frmAddRdiiDataConverter: TfrmAddRdiiDataConverter;

implementation

uses modDatabase, mainform;

{$R *.DFM}

procedure TfrmAddRdiiDataConverter.FormShow(Sender: TObject);
begin
  NewNameEdit.Text := 'New Converter';
  UnitsComboBox.Items := DatabaseModule.GetAreaUnitLabels();
  UnitsComboBox.ItemIndex := 0;
  existingConverterNames := DatabaseModule.GetRdiiConverterNames();
end;

procedure TfrmAddRdiiDataConverter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAddRdiiDataConverter.okButtonClick(Sender: TObject);
var
  unitID: integer;
  unitLabel, format, sqlStr: String;
  okToAdd: boolean;
  recordsAffected: OleVariant;
begin
  okToAdd := true;
  if (existingConverterNames.IndexOf(NewNameEdit.Text) <> -1) then begin
    okToAdd := false;
    MessageDlg('A flow converter with this name already exists.',mtError,[mbOK],0);
  end;
  if (Length(NewNameEdit.Text) = 0) then begin
    okToAdd := false;
    MessageDlg('The converter name cannot be blank.',mtError,[mbOK],0);
  end;
  if (okToAdd) then begin
    Screen.Cursor := crHourglass;
    unitLabel := UnitsComboBox.Items.Strings[UnitsComboBox.ItemIndex];
    unitID := DatabaseModule.GetRdiiUnitID(unitLabel);
    if (CSVRadioButton.Checked) then format := 'CSV' else format := 'C/W';
    sqlStr := 'INSERT INTO RdiiConverters (RdiiConverterName,AreaUnitID,Format,' +
              'LinesToSkip,NodeColumn,NodeWidth,AreaColumn,AreaWidth,' +
              'NodeLocationXColumn,NodeLocationXWidth,NodeLocationYColumn,NodeLocationYWidth,TagColumn,TagWidth,' +
              'CodeColumn,CodeWidth) VALUES (' +
              '"' + NewNameEdit.Text + '",' +
              inttostr(unitID) + ',' +
              '"' + format + '",' +
              inttostr(LinesToSkipSpinEdit.Value) + ',' +
              inttostr(NodeColumnSpinEdit.Value) + ',' +
              inttostr(NodeWidthSpinEdit.Value) + ',' +
              inttostr(AreaColumnSpinEdit.Value) + ',' +
              inttostr(AreaWidthSpinEdit.Value) + ',' +
              inttostr(NodeLocationXColumnSpinEdit.Value) + ',' +
              inttostr(NodeLocationXWidthSpinEdit.Value) + ',' +
              inttostr(NodeLocationYColumnSpinEdit.Value) + ',' +
              inttostr(NodeLocationYWidthSpinEdit.Value) + ',' +
              inttostr(TagColumnSpinEdit.Value) + ',' +
              inttostr(TagWidthSpinEdit.Value) + ',' +
              inttostr(CodeColumnSpinEdit.Value) + ',' +
              inttostr(CodeWidthSpinEdit.Value) + ');';
    frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
    Screen.Cursor := crDefault;
    Close;
  end;
end;

procedure TfrmAddRdiiDataConverter.CSVRadioButtonClick(Sender: TObject);
begin
  NodeWidthSpinEdit.Enabled := False;
  AreaWidthSpinEdit.Enabled := False;
  NodeLocationXWidthSpinEdit.Enabled := False;
  NodeLocationYWidthSpinEdit.Enabled := False;
  TagWidthSpinEdit.Enabled := False;
  CodeWidthSpinEdit.Enabled := False;
end;


procedure TfrmAddRdiiDataConverter.ColumnWidthRadioButtonClick(Sender: TObject);
begin
  NodeWidthSpinEdit.Enabled := True;
  AreaWidthSpinEdit.Enabled := True;
  NodeLocationXWidthSpinEdit.Enabled := True;
  NodeLocationYWidthSpinEdit.Enabled := True;
  TagWidthSpinEdit.Enabled := True;
  CodeWidthSpinEdit.Enabled := True;
end;

procedure TfrmAddRdiiDataConverter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  existingConverterNames.Free;
end;

procedure TfrmAddRdiiDataConverter.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

end.
