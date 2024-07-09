unit editscenario;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ADODB_TLB;

type
  TfrmEditScenario = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ScenarioNameEdit: TEdit;
    DescriptionEdit: TEdit;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    Button1: TButton;
    GroupBoxFlowUnits: TGroupBox;
    RadioButton_MGD: TRadioButton;
    RadioButton_CFS: TRadioButton;
    RadioButton_GPM: TRadioButton;
    RadioButton_CMS: TRadioButton;
    RadioButton_LPS: TRadioButton;
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    recSet: _recordSet;
    otherScenarioNames: TStringList;
  public { Public declarations }
    scenarioName: string;
  end;

var
  frmEditScenario: TfrmEditScenario;

implementation

uses scenarioManager, modDatabase, mainform, RTKPatternAssignment;

{$R *.DFM}

procedure TfrmEditScenario.FormShow(Sender: TObject);
var
  queryStr, flowunitName: string;
  flowunitID: integer;
begin
  //scenarioName := frmScenarioManagement.SelectedScenarioName;
  ScenarioNameEdit.Text := scenarioName;

  queryStr := 'SELECT scenarioName, scenarioDescription, FlowUnitID ' +
              'FROM Scenarios WHERE (ScenarioName = "' + scenarioName + '");';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;

  scenarioNameEdit.Text := recSet.Fields.Item[0].Value;
  DescriptionEdit.Text := recSet.Fields.Item[1].Value;

  otherScenarioNames := DatabaseModule.GetScenarioNames();
  otherScenarioNames.Delete(otherScenarioNames.IndexOf(scenarioName));

  flowunitName := 'MGD';
  try
    flowunitID := recSet.Fields.Item[2].Value;
    flowunitName := DatabaseModule.GetFlowUnitLabelForID(flowunitID);
  finally
    if flowunitName = 'MGD' then
      RadioButton_MGD.Checked := true
    else if flowunitName = 'CFS' then
      RadioButton_CFS.Checked := true
    else if flowunitName = 'GPM' then
      RadioButton_GPM.Checked := true
    else if flowunitName = 'CMS' then
      RadioButton_CMS.Checked := true
//rm 2009-11-03 - error! it is "LPS" not "L/S"    else if flowunitName = 'L/S' then
    else if flowunitName = 'LPS' then
      RadioButton_LPS.Checked := true;
    end;
end;


procedure TfrmEditScenario.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEditScenario.okButtonClick(Sender: TObject);
var
  flowunitID: integer;
  flowunit:string;
  okToAdd: boolean;
begin
  okToAdd := true;
  if (otherScenarioNames.IndexOf(ScenarioNameEdit.Text) <> -1) then begin
    okToAdd := false;
    MessageDlg('Another scenario with this name already exists.',mtError,[mbOK],0);
  end;
  if (Length(ScenarioNameEdit.Text) = 0) then begin
    okToAdd := false;
    MessageDlg('The scenario name cannot be blank.',mtError,[mbOK],0);
  end;
  if (okToAdd) then begin
    flowunit := 'MGD';
    if RadioButton_MGD.Checked then
      flowunit := 'MGD'
    else if RadioButton_CFS.Checked  then
      flowunit := 'CFS'
    else if RadioButton_GPM.Checked  then
      flowunit := 'GPM'
    else if RadioButton_CMS.Checked  then
      flowunit := 'CMS'
    else if RadioButton_LPS.Checked  then
//rm 2009-11-03 - error! it is "LPS" not "L/S"      flowunit := 'L/S';
      flowunit := 'LPS';
    flowunitID := DatabaseModule.GetFlowUnitID(flowunit);
    recSet.Fields.Item[0].Value := ScenarioNameEdit.Text;
    recSet.Fields.Item[1].Value := DescriptionEdit.Text;
    recSet.Fields.Item[2].Value := flowunitID;
    recSet.UpdateBatch(1);
    {recSet is closed in FormClose procedure}
    Close;
  end;
end;


procedure TfrmEditScenario.FormClose(Sender: TObject;var Action: TCloseAction);
begin
  otherScenarioNames.Free;
  recSet.Close
end;

procedure TfrmEditScenario.Button1Click(Sender: TObject);
begin
  frmRTKPatternAssignment.ScenarioName := scenarioName;
   frmRTKPAtternAssignment.ShowModal;
end;

procedure TfrmEditScenario.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditScenario.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmEditScenario.FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0) then exit;
    Key := #0;
  end;
end;

end.
