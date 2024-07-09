unit newComparisonScenario;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ADODB_TLB;

type
  TfrmAddComparisonScenario = class(TForm)
    Label1: TLabel;
    ComparisonScenarioNameEdit: TEdit;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatEditKeyPressAllowNegative(Sender: TObject; var Key: Char);
    procedure ComparisonScenarioNameEditKeyPress(Sender: TObject; var Key: Char);
    //procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    //existingRaingaugeNames: TStringList;
    existingCScenarioNames: TStringList;
  public { Public declarations }
  end;

var
  frmAddComparisonScenario: TfrmAddComparisonScenario;

implementation

uses modDatabase, mainform, CAAnalysisSetup; //, CAAnalysisChooser;

{$R *.DFM}

procedure TfrmAddComparisonScenario.FormShow(Sender: TObject);
begin
  ComparisonScenarioNameEdit.Text := 'New_Comparison_Scenario'; //Spaces are not allowed!
  //existingRaingaugeNames := DatabaseModule.GetRaingaugeNames();
  existingCScenarioNames := DatabaseModule.GetComparisonScenarioNames();
end;

procedure TfrmAddComparisonScenario.ComparisonScenarioNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  if key = ' '  then key := '_'
  else if key = '"' then key := '''';
end;

//procedure TfrmAddComparisonScenario.helpButtonClick(Sender: TObject);
//begin
//  frmMain.HelpHandler_Universal(Self);
//end;

procedure TfrmAddComparisonScenario.okButtonClick(Sender: TObject);
var
  okToAdd: boolean;
  recordsAffected: OleVariant;
  sqlStr : string;
  comparisonOption, comparisonStatsOption, i : integer;
  scenarioID, analysisID : integer;
  analysisName : string;

begin
  ComparisonScenarioNameEdit.Text := StringReplace(ComparisonScenarioNameEdit.Text,' ','_',[rfReplaceAll]);
  okToAdd := true;

  if (existingCScenarioNames.IndexOf(ComparisonScenarioNameEdit.Text) <> -1) then begin
    okToAdd := false;
    MessageDlg('A comparison scenario with this name already exists.',mtError,[mbOK],0);
  end;

  if (Length(ComparisonScenarioNameEdit.Text) = 0) then begin
    okToAdd := false;
    MessageDlg('The comparsion scenario name cannot be blank.',mtError,[mbOK],0);
  end;
  //rm 2012-04-17 - not referencing frmCAAnalysisChooser any more
  (*
  if frmCAAnalysisChooser.RadioButton1.Checked then comparisonOption := 1;
  if frmCAAnalysisChooser.RadioButton2.Checked then comparisonOption := 2;
  if frmCAAnalysisChooser.RadioButton3.Checked then comparisonOption := 3;
  if frmCAAnalysisChooser.RadioButton4.Checked then comparisonOption := 4;
  if frmCAAnalysisChooser.RadioButton5.Checked then comparisonOption := 5;
  if frmCAAnalysisChooser.RadioButton6.Checked then comparisonOption := 6;
  if frmCAAnalysisChooser.RadioButton7.Checked then comparisonOption := 7;
  if frmCAAnalysisChooser.RadioButton8.Checked then comparisonOption := 8;
  if frmCAAnalysisChooser.CheckBox_OptionAvg.Checked then comparisonStatsOption := 1;
  if frmCAAnalysisChooser.CheckBox_OptionPeak.Checked then comparisonStatsOption := 2;
  if frmCAAnalysisChooser.CheckBox_OptionMed.Checked then comparisonStatsOption := 3;
  *)
  //rm 2012-04-17 - referencing CAAnalysisSetup instead
  //rm 2012-04-17 - 1 is the default. . . if frmCAAnalysisSetup.RadioButton1.Checked then
  comparisonOption := 1;
  if frmCAAnalysisSetup.RadioButton2.Checked then comparisonOption := 2;
  if frmCAAnalysisSetup.RadioButton3.Checked then comparisonOption := 3;
  if frmCAAnalysisSetup.RadioButton4.Checked then comparisonOption := 4;
  if frmCAAnalysisSetup.RadioButton5.Checked then comparisonOption := 5;
  if frmCAAnalysisSetup.RadioButton6.Checked then comparisonOption := 6;
  if frmCAAnalysisSetup.RadioButton7.Checked then comparisonOption := 7;
  if frmCAAnalysisSetup.RadioButton8.Checked then comparisonOption := 8;
  comparisonStatsOption := frmCAAnalysisSetup.RadioGroupStatOptions.ItemIndex + 1;
  //RadioButton8.Checked then comparisonOption := 8;

  if (okToAdd) then begin
    Screen.Cursor := crHourglass;
    sqlStr := 'INSERT INTO ComparisonScenarios (ComparisonScenarioName,ComparisonOption,ComparisonStatsOption,NumSubSewershed) VALUES (' +
              '"' + ComparisonScenarioNameEdit.Text + '",' +
              inttostr(comparisonOption) + ',' +
              inttostr(comparisonStatsOption) + ',' +
              inttostr(frmCAAnalysisSetup.ListBoxSelected.Items.Count) + ');';
              //inttostr(frmCAAnalysisChooser.ListBoxSelected.Items.Count) + ');';
    frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
    Screen.Cursor := crDefault;
    //rm 2012-04-17 ????? Close;
    scenarioID := DatabaseModule.GetComparisonScenarioIDForName(ComparisonScenarioNameEdit.Text);
    //for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do
    for i := 0 to frmCAAnalysisSetup.ListBoxSelected.Items.Count - 1 do
    begin
      //analysisName := frmCAAnalysisChooser.ListBoxSelected.Items[i];
      analysisName := frmCAAnalysisSetup.ListBoxSelected.Items[i];
      analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);

      sqlStr := 'INSERT INTO ComparisonScenarioDetails (ComparisonScenarioID, AnalysisID, AnalysisName) VALUES (' +
              inttostr(scenarioID) + ',' +
              inttostr(analysisID) + ',"' + analysisName +'");';
      frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
      Screen.Cursor := crDefault;
      //rm 2012-04-17 ????? Close;
    end;
    self.ModalResult := mrOK;    //form closes when ModalREsult is set.
    //self.Close;
  end;
end;

procedure TfrmAddComparisonScenario.cancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  //Close;
end;

procedure TfrmAddComparisonScenario.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  existingCScenarioNames.Free;
end;

procedure TfrmAddComparisonScenario.FloatEditKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0) then  exit;
    Key := #0;
  end;
end;


end.
