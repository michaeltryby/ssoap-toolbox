unit newscenario;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ADODB_TLB, ExtCtrls;

type
  TfrmAddNewScenario = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ScenarioNameEdit: TEdit;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    DescriptionEdit: TEdit;
    PanelCopyOptions: TPanel;
    CheckBoxMakeCopies: TCheckBox;
    Label3: TLabel;
    LabelSuffix: TLabel;
    EditSuffix: TEdit;
    CheckBoxFactor: TCheckBox;
    LabelSuffix2: TLabel;
    LabelFactor: TLabel;
    LabelFactor2: TLabel;
    EditRFactor: TEdit;
    function GetSuffix: string;
    function GetFactor: double;
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatEditKeyPress(Sender: TObject; var Key: Char);
    procedure FloatEditKeyPressAllowNegative(Sender: TObject; var Key: Char);
    procedure helpButtonClick(Sender: TObject);
    procedure CheckBoxFactorClick(Sender: TObject);
    procedure CheckBoxMakeCopiesClick(Sender: TObject);
    procedure EditSuffixKeyPress(Sender: TObject; var Key: Char);
  private { Private declarations }
    existingScenarioName: TStringList;
  public { Public declarations }
    boCopying:boolean;
    scenarioName: string;
    description: string;
    oldScenarioID: integer;
  end;

var
  frmAddNewScenario: TfrmAddNewScenario;

implementation

uses modDatabase, mainform;

{$R *.DFM}

procedure TfrmAddNewScenario.FormShow(Sender: TObject);
begin
  if boCopying then begin
    ScenarioNameEdit.Text := scenarioName;
    oldScenarioID := DatabaseModule.getScenarioIDForName(scenarioName);
    DescriptionEdit.Text := description;
    Caption := 'Copy ' + scenarioName  + ' to New Scenario';
    label1.Caption := 'Destination Scenario Name:';
    PanelCopyOptions.Visible := true;
    Height := 434;
    CheckBoxMakeCopiesClick(nil);
    CheckBoxFactorClick(nil);
  end else begin
    Caption := 'Add New Scenario';
    ScenarioNameEdit.Text := 'New Scenario';
    oldScenarioID := -1;
    DescriptionEdit.Text := '';
    label1.Caption := 'Scenario Name:';
    PanelCopyOptions.Visible := false;
    Height := 182;
  end;
  existingScenarioName := DatabaseModule.GetScenarioNames();
end;

function TfrmAddNewScenario.GetFactor: double;
begin
  if CheckBoxMakeCopies.Checked and
  CheckBoxFactor.Visible and CheckBoxFactor.Checked then
    Result := strtoFloat(EditRFactor.Text)
  else
    Result := 1.0;
end;

function TfrmAddNewScenario.GetSuffix: string;
begin
  if CheckBoxMakeCopies.Checked then
    Result := EditSuffix.Text
  else
    Result := '';
end;

procedure TfrmAddNewScenario.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAddNewScenario.okButtonClick(Sender: TObject);
var
  //scenarioID: integer;
  sqlStr: String;
  scenarioMemo: String;
  okToAdd: boolean;
  recordsAffected: OleVariant;
  newScenarioID, dupeCount: integer;
begin
  scenarioName := ScenarioNameEdit.Text;
  okToAdd := true;
  if (existingScenarioName.IndexOf(scenarioName) <> -1) then begin
    okToAdd := false;
    MessageDlg('A scenario with this name already exists.',mtError,[mbOK],0);
  end;
  if (Length(scenarioName) = 0) then begin
    okToAdd := false;
    MessageDlg('The scenario name cannot be blank.',mtError,[mbOK],0);
  end;
  if (okToAdd) then begin
  try
    Screen.Cursor := crHourglass;
 {   unitLabel := FlowUnitsComboBox.Items.Strings[FlowUnitsComboBox.ItemIndex];
    flowUnitID := DatabaseModule.GetFlowUnitID(unitLabel);
    unitLabel := VelocityUnitsComboBox.Items.Strings[VelocityUnitsComboBox.ItemIndex];
    velocityUnitID := DatabaseModule.GetVelocityUnitID(unitLabel);
    unitLabel := DepthUnitsComboBox.Items.Strings[DepthUnitsComboBox.ItemIndex];
    depthUnitID := DatabaseModule.GetDepthUnitID(unitLabel);}
{    sqlStr := 'INSERT INTO Meters (ScenarioName,ScenarioDescription) VALUES (' +
              '"' + ScenarioNameEdit.Text + '",' +
              DescriptionMemo.Text + ');';}
    sqlStr := 'INSERT INTO Scenarios (ScenarioName,ScenarioDescription,FlowUnitID) VALUES (' +
              '"' + ScenarioNameEdit.Text + '",' +
              '"' + DescriptionEdit.Text + '"' + ',1);';

    frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);

    //scenarioID := DatabaseModule.getScenarioIDForName(scenarioName);

    if recordsAffected > 0 then begin
      if boCopying then begin
        newscenarioID := DatabaseModule.getScenarioIDForName(scenarioname);
        if CheckBoxMakeCopies.Checked then begin
          //copy records in RTKPatterns Table for oldscenarioID
          //and add records to RTKLinks Table for newscenarioID
          dupeCount := DataBaseModule.CopyScenario(oldScenarioID,newScenarioID,true,
            GetSuffix, GetFactor);
          if dupeCount > 0 then begin
            MessageDlg(inttostr(dupeCount) + ' duplicate RTK Patterns names encountered.',mtError,[mbok],0);
          end;
        end else begin
          //copy records in RTKLinks Table for oldscenarioID to newscenarioID
          DataBaseModule.CopyScenario(oldScenarioID,newScenarioID,false,
            '', 1.00);
        end;
      end;
      modalResult := mrOK;
    end;

  finally
    Screen.Cursor := crDefault;

  end;

 end;
end;


procedure TfrmAddNewScenario.cancelButtonClick(Sender: TObject);
begin
//do not close - modalresult is set to mrCancel  Close;
end;

procedure TfrmAddNewScenario.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  existingScenarioName.Free;
end;


procedure TfrmAddNewScenario.CheckBoxFactorClick(Sender: TObject);
begin
  LabelFactor2.Visible := CheckBoxFactor.Checked;
  EditRFactor.Visible := LabelFactor2.Visible;
end;

procedure TfrmAddNewScenario.CheckBoxMakeCopiesClick(Sender: TObject);
begin
  LabelSuffix.Visible := CheckBoxMakeCopies.Checked;
  LabelSuffix2.Visible := LabelSuffix.Visible;
  EditSuffix.Visible := LabelSuffix.Visible;
  CheckBoxFactor.Visible := LabelSuffix.Visible;
  LabelFactor.Visible := LabelSuffix.Visible;
  LabelFactor2.Visible := CheckBoxFactor.Checked and LabelSuffix.Visible;
  EditRFactor.Visible := LabelFactor2.Visible;
end;

procedure TfrmAddNewScenario.EditSuffixKeyPress(Sender: TObject; var Key: Char);
begin
  if key = ' '  then key := '_'
  else if key = '"' then key := '''';
end;

procedure TfrmAddNewScenario.FloatEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in [#3, #22, #8, '0'..'9'] then exit;
  if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
  Key := #0;
end;

procedure TfrmAddNewScenario.FloatEditKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if Key in [#3, #22, #8, '0'..'9'] then exit;
  if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
  if (Key = '-') and (TEdit(sender).SelStart = 0) then exit;
  Key := #0;
end;

end.
