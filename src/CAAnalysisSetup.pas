unit CAAnalysisSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmCAAnalysisSetup = class(TForm)
    okButton: TButton;
    helpButton: TButton;
    btnClose: TButton;
    ListBoxAvailable: TListBox;
    ListBoxSelected: TListBox;
    btnAdd: TButton;
    btnRemove: TButton;
    btnAddAll: TButton;
    btnRemoveAll: TButton;
    Label1: TLabel;
    Label2: TLabel;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    AddScenarioButton: TButton;
    RadioGroupStatOptions: TRadioGroup;
    Label5: TLabel;
    ListBoxScenarios: TListBox;
    Label3: TLabel;
    Label4: TLabel;
    btnQuickView: TButton;
    RadioButton9: TRadioButton;
    procedure ListBoxScenariosClick(Sender: TObject);
    procedure btnQuickViewClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddScenarioButtonClick(Sender: TObject);

    procedure btnCloseClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure btnRemoveAllClick(Sender: TObject);
    procedure btnAddAllClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure SetOptionsForSelectedAnalyses;

  public
    { Public declarations }
    function ChartType: integer;
    procedure LoadListBoxAvailable;
    procedure LoadComparisonScenarioList;
    procedure InitializeLists;
    procedure MoveItem(lst1: TListBox; lst2: TListBox; idx: integer);
    //rm 2012-04-17
    procedure QuickViewCAScenario(sName: string);
    procedure QuickViewCAScenario_Test(sName: string);

  end;

var
  frmCAAnalysisSetup: TfrmCAAnalysisSetup;
    existingCScenarioNames: TStringList;

implementation
uses modDatabase, newComparisonScenario, CARDIIRankingGraph2;
{$R *.dfm}

procedure TfrmCAAnalysisSetup.btnAddAllClick(Sender: TObject);
var i: integer;
begin
//add all to listboxselected
//and remove from listBoxAvailable
  for i := 0 to ListBoxAvailable.Count - 1 do begin
    MoveItem(ListBoxAvailable, ListBoxSelected, 0);
  end;
  SetOptionsForSelectedAnalyses;
end;

procedure TfrmCAAnalysisSetup.btnAddClick(Sender: TObject);
var
  idx: integer;
  sAnalysis: string;
begin
//add the selected analyses in listBoxAvailable to listBoxSelected
//and remove from listboxAvailable
  if (ListBoxAvailable.ItemIndex > -1) then begin
    sAnalysis := ListBoxAvailable.Items[ListBoxAvailable.ItemIndex];
    idx := ListBoxAvailable.ItemIndex;
    MoveItem(ListBoxAvailable, ListBoxSelected, ListBoxAvailable.ItemIndex);
    if ListBoxAvailable.Items.Count > 0 then begin
      if ListBoxAvailable.Items.Count > idx then
        ListBoxAvailable.ItemIndex := idx
      else
        ListBoxAvailable.ItemIndex := ListBoxAvailable.Items.Count - 1;
    end;
    SetOptionsForSelectedAnalyses;
  end;
end;

//Loading scenario to the listbox
procedure TfrmCAAnalysisSetup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    //ListBoxAvailable.Items.Clear;
    //ListBoxSelected.Items.Clear;
    //ComparisonScenarioListBox.Items.Clear;
    //ScenarioToDisplayListBox.items.clear;
end;

procedure TfrmCAAnalysisSetup.FormDestroy(Sender: TObject);
begin
    ListBoxAvailable.Items.Clear;
    ListBoxSelected.Items.Clear;

end;

procedure TfrmCAAnalysisSetup.FormShow(Sender: TObject);
begin
  //ComparisonScenarioNameEdit.Text := 'New_Comparison_Scenario'; //Spaces are not allowed!
  //existingRaingaugeNames := DatabaseModule.GetRaingaugeNames();
  //existingCScenarioNames := DatabaseModule.GetComparsionScenarioNames();
  LoadComparisonScenarioList;
end;



procedure TfrmCAAnalysisSetup.btnCloseClick(Sender: TObject);
begin
//Cancel
  ModalResult := mrCancel;
  ListBoxAvailable.Items.Clear;
  ListBoxSelected.Items.Clear;
end;

procedure TfrmCAAnalysisSetup.btnQuickViewClick(Sender: TObject);
begin
  if (ListBoxScenarios.ItemIndex > -1) then
    QuickViewCAScenario_Test(ListBoxScenarios.Items[ListBoxScenarios.ItemIndex]);
end;

procedure TfrmCAAnalysisSetup.btnRemoveAllClick(Sender: TObject);
begin
//remove all from listboxselected
  InitializeLists;
  SetOptionsForSelectedAnalyses;
end;

procedure TfrmCAAnalysisSetup.btnRemoveClick(Sender: TObject);
var idx: integer;
begin
//add the selected analyses in listBoxSelected to listBoxAvailable
//and remove from listBoxSelected
  if (ListBoxSelected.ItemIndex > -1) then begin
    idx := ListBoxSelected.ItemIndex;
    MoveItem(ListBoxSelected, ListBoxAvailable, ListBoxSelected.ItemIndex);
    if ListBoxSelected.Items.Count > 0 then begin
      if ListBoxSelected.Items.Count > idx then
        ListBoxSelected.ItemIndex := idx
      else
        ListBoxSelected.ItemIndex := ListBoxSelected.Items.Count - 1;
    end;
    SetOptionsForSelectedAnalyses;
  end;
end;

procedure TfrmCAAnalysisSetup.AddScenarioButtonClick(Sender: TObject);
var
  proceed : boolean;  //error check
  mres: TModalResult;
begin
  proceed := true;
  if listboxselected.Items.Count < 2 then begin
    proceed := false;
    // Send a message about needing to have more than 2 FM for comparison
    //rm 2012-04-17
    MessageDlg('Please select at least 2 analysis results sets for comparison.', mtError, [mbok], 0);
  end;

//rm 2012-04-17 changed to radiogroupbox  if (CheckBox_OptionAvg.Checked = false) and (checkbox_optionPeak.Checked = false) and (checkbox_optionMed.Checked = false) then
  if proceed and (RadioGroupStatOptions.ItemIndex < 0) then
  begin
    proceed := false;
    // Send a message about needing to have a stats option
    //rm 2012-04-17
    MessageDlg('Please select statistics options (Step 3).', mtError, [mbok], 0);
  end;

  if proceed and (radiobutton1.checked = false) and (radiobutton2.checked = false) and (radiobutton3.checked = false)
    and (radiobutton4.checked = false) and (radiobutton5.checked = false) and (radiobutton6.checked = false)
    and (radiobutton7.checked = false) and (radiobutton8.checked = false) then begin
    proceed := false;
    //rm 2012-04-17
    MessageDlg('Please select comparison options (Step 3).', mtError, [mbok], 0);
  end;

  if proceed = true then begin
    //rm 2012-04-17 - check modalresult before launching new scenario graph
    //frmAddComparisonScenario.ShowModal;
    mres := frmAddComparisonScenario.ShowModal;
    //messagedlg('ModalREsult = ' + IntToStr(mres), mtInformation, [mbok], 0);
    if mres <> mrCancel then begin
      //UpdateList();
      //AnalysisListBox.ItemIndex := AnalysisListBox.Items.Count - 1;
      //SetSelectedAnalysisName;
      LoadComparisonScenarioList();
      //lauch a Quickview of the new scenario:
      ListBoxScenarios.ItemIndex := ListBoxScenarios.Count - 1;
      btnQuickViewClick(btnQuickView);
    end;
  end;
end;

function TfrmCAAnalysisSetup.ChartType: integer;
begin
  ChartType := 1;
  if RadioButton1.checked then  ChartType := 0
  else if RadioButton2.Checked then ChartType := 1;
  // if RadioButton3.Checked - then ChartType := 1;

end;

procedure TfrmCAAnalysisSetup.InitializeLists;
begin
  ListBoxSelected.Clear;
  ListBoxAvailable.Clear;
  LoadListBoxAvailable;
  LoadComparisonScenarioList;
end;

procedure TfrmCAAnalysisSetup.LoadListBoxAvailable;
begin
  //load up the listboxAvailable with all analyses
  ListBoxAvailable.Clear;
  ListBoxAvailable.Items := DatabaseModule.GetAnalysisNames;

end;

procedure TfrmCAAnalysisSetup.ListBoxScenariosClick(Sender: TObject);
begin
  btnQuickView.Enabled := ListBoxScenarios.ItemIndex > -1;
end;

procedure TfrmCAAnalysisSetup.LoadComparisonScenarioList;
var i: integer;
begin
//rm 2012-04-17 - stubbed out - filled in 2012-04-17
  existingCScenarioNames := DatabaseModule.GetComparisonScenarioNames();
  ListBoxScenarios.Clear;
  for i := 0 to existingCScenarioNames.Count - 1 do begin
    ListBoxScenarios.Items.add(existingCScenarioNames.Strings[i]);
  end;

end;

procedure TfrmCAAnalysisSetup.MoveItem(lst1, lst2: TListBox; idx: integer);
begin
  lst2.Items.Add(lst1.Items[idx]);
  lst1.Items.Delete(idx);
end;

procedure TfrmCAAnalysisSetup.okButtonClick(Sender: TObject);
begin
//OK
  ModalResult := mrOK;
end;

procedure TfrmCAAnalysisSetup.QuickViewCAScenario_Test(sName: string);
var frmCARDIIRankGraph: TfrmCARDIIRankingGraph2;
begin
  Application.CreateForm(TfrmCARDIIRankingGraph2, frmCARDIIRankGraph);
  try
    frmCARDIIRankGraph.lstScenarios.Add(sName);
    frmCARDIIRankGraph.Caption := frmCARDIIRankGraph.Caption + ' - ' + sName;
    frmCARDIIRankGraph.Show;
  finally
    //FreeAndNil(frmCARDIIRankGraph);
  end;
end;

procedure TfrmCAAnalysisSetup.QuickViewCAScenario(sName: string);
begin
  Application.CreateForm(TfrmCARDIIRankingGraph2, frmCARDIIRankingGraph2);
  try
    frmCARDIIRankingGraph2.lstScenarios.Add(sName);
    frmCARDIIRankingGraph2.Show;
  finally
    FreeAndNil(frmCARDIIRankingGraph2);
  end;
end;

procedure TfrmCAAnalysisSetup.SetOptionsForSelectedAnalyses;
var
  boHasRTKs: boolean;
  i, idx: integer;
  sumR1: double;
begin
//rm 2012-04-17 set the options buttons based on the Analysis
//i.e. options 2 - 8 are not available if hydrographs (RTKs) were generated
//RadioButton2 - RadioButton8.enabled
//combine settings so if any one lacks RTKs, the options are disabled
  boHasRTKs := true;
  for i := 0 to ListBoxSelected.Count - 1 do begin
    idx := DatabaseModule.GetAnalysisIDForName(ListBoxSelected.Items[i]);
    sumR1 := DatabaseModule.GetSumR1ForAnalysisID(idx);
    label4.Caption := 'Sum(R1) = ' + floattostr(sumR1);
    boHasRTKs := boHasRTKs and (sumR1 > 0); //one false and they are all false
  end;
  RadioButton2.Enabled := boHasRTKs;
  RadioButton3.Enabled := boHasRTKs;
  RadioButton4.Enabled := boHasRTKs;
  RadioButton5.Enabled := boHasRTKs;
  RadioButton6.Enabled := boHasRTKs;
  RadioButton7.Enabled := boHasRTKs;
  RadioButton8.Enabled := boHasRTKs;
end;

end.
