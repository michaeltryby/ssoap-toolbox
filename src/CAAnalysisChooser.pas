unit CAAnalysisChooser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmCAAnalysisChooser = class(TForm)
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
    ComparisonScenarioListBox: TListBox;
    Label3: TLabel;
    AddScenarioButton: TButton;
    RadioGroup2: TRadioGroup;
    CheckBox_OptionAvg: TCheckBox;
    CheckBox_OptionPeak: TCheckBox;
    CheckBox_OptionMed: TCheckBox;
    ScenarioToDisplayListBox: TListBox;
    Label4: TLabel;
    SelectScenarioForDisplay: TButton;
    RemoveScenarioFromDisplay: TButton;
    Label5: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RemoveScenarioFromDisplayClick(Sender: TObject);
    procedure SelectScenarioForDisplayClick(Sender: TObject);
    procedure CheckBox_OptionMedClick(Sender: TObject);
    procedure CheckBox_OptionPeakClick(Sender: TObject);
    procedure CheckBox_OptionAvgClick(Sender: TObject);
    procedure ComparisonScenarioListBoxClick(Sender: TObject);
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
  public
    { Public declarations }
    function ChartType: integer;
    procedure LoadListBoxAvailable;
    procedure LoadComparisonScenarioList;
    procedure InitializeLists;
    procedure MoveItem(lst1: TListBox; lst2: TListBox; idx: integer);
  end;

var
  frmCAAnalysisChooser: TfrmCAAnalysisChooser;

implementation
uses modDatabase, newComparisonScenario;
{$R *.dfm}

procedure TfrmCAAnalysisChooser.btnAddAllClick(Sender: TObject);
var i: integer;
begin
//add all to listboxselected
//and remove from listBoxAvailable
  for i := 0 to ListBoxAvailable.Count - 1 do begin
    MoveItem(ListBoxAvailable, ListBoxSelected, 0);
  end;
end;

procedure TfrmCAAnalysisChooser.btnAddClick(Sender: TObject);
var
  idx: integer;
begin
//add the selected analyses in listBoxAvailable to listBoxSelected
//and remove from listboxAvailable
  if (ListBoxAvailable.ItemIndex > -1) then begin
    idx := ListBoxAvailable.ItemIndex;
    MoveItem(ListBoxAvailable, ListBoxSelected, ListBoxAvailable.ItemIndex);
    if ListBoxAvailable.Items.Count > 0 then begin
      if ListBoxAvailable.Items.Count > idx then
        ListBoxAvailable.ItemIndex := idx
      else
        ListBoxAvailable.ItemIndex := ListBoxAvailable.Items.Count - 1;
    end;
  end;
end;

//Loading scenario to the listbox
procedure TfrmCAAnalysisChooser.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    //ListBoxAvailable.Items.Clear;
    //ListBoxSelected.Items.Clear;
    //ComparisonScenarioListBox.Items.Clear;
    //ScenarioToDisplayListBox.items.clear;
end;

procedure TfrmCAAnalysisChooser.FormDestroy(Sender: TObject);
begin
    ListBoxAvailable.Items.Clear;
    ListBoxSelected.Items.Clear;
    ComparisonScenarioListBox.Items.Clear;
    ScenarioToDisplayListBox.items.clear;

end;

procedure TfrmCAAnalysisChooser.FormShow(Sender: TObject);
begin
  //ComparisonScenarioNameEdit.Text := 'New_Comparison_Scenario'; //Spaces are not allowed!
  //existingRaingaugeNames := DatabaseModule.GetRaingaugeNames();
  //existingCScenarioNames := DatabaseModule.GetComparsionScenarioNames();
end;



procedure TfrmCAAnalysisChooser.btnCloseClick(Sender: TObject);
begin
//Cancel
  ModalResult := mrCancel;
  ListBoxAvailable.Items.Clear;
  ListBoxSelected.Items.Clear;
  ComparisonScenarioListBox.Items.Clear;
  ScenarioToDisplayListBox.items.clear;
end;

procedure TfrmCAAnalysisChooser.btnRemoveAllClick(Sender: TObject);
begin
//remove all from listboxselected
  InitializeLists;
end;

procedure TfrmCAAnalysisChooser.btnRemoveClick(Sender: TObject);
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
  end;
end;

procedure TfrmCAAnalysisChooser.AddScenarioButtonClick(Sender: TObject);
var
  proceed : boolean;  //error check
begin
  proceed := true;
  if listboxselected.Items.Count < 2 then begin
    proceed := false;
    // Send a message about needing to have more than 2 FM for comparison
  end;

  if (CheckBox_OptionAvg.Checked = false) and (checkbox_optionPeak.Checked = false) and (checkbox_optionMed.Checked = false) then
  begin
    proceed := false;
    // Send a message about needing to have a stats option
  end;

  if (radiobutton1.checked = false) and (radiobutton2.checked = false) and (radiobutton3.checked = false)
    and (radiobutton4.checked = false) and (radiobutton5.checked = false) and (radiobutton6.checked = false)
    and (radiobutton7.checked = false) and (radiobutton8.checked = false) then begin
    proceed := false;
  end;

  if proceed = true then begin

  frmAddComparisonScenario.ShowModal;
  //UpdateList();
  //AnalysisListBox.ItemIndex := AnalysisListBox.Items.Count - 1;
  //SetSelectedAnalysisName;
  LoadComparisonScenarioList();
  end;
end;

function TfrmCAAnalysisChooser.ChartType: integer;
begin
  ChartType := 1;
  if RadioButton1.checked then  ChartType := 0
  else if RadioButton2.Checked then ChartType := 1;
  // if RadioButton3.Checked - then ChartType := 1;

end;

procedure TfrmCAAnalysisChooser.CheckBox_OptionAvgClick(Sender: TObject);
begin
  checkBox_OptionPeak.Checked := false;
  checkBox_OptionMed.Checked := false;
  //checkBox_Optionavg.Checked := true;
end;

procedure TfrmCAAnalysisChooser.CheckBox_OptionMedClick(Sender: TObject);
begin
  checkBox_OptionPeak.Checked := false;
  checkBox_Optionavg.Checked := false;
  //checkBox_Optionmed.Checked := true;
end;

procedure TfrmCAAnalysisChooser.CheckBox_OptionPeakClick(Sender: TObject);
begin
  checkBox_Optionavg.Checked := false;
  checkBox_OptionMed.Checked := false;
  //checkBox_Optionpeak.Checked := true;
end;

procedure TfrmCAAnalysisChooser.ComparisonScenarioListBoxClick(Sender: TObject);
var
  i,j : integer;
  selectedCScenarioName : string;
  analysisInSelectedComparisonScenario: TStringList;
  locationInListBoxAvailable : integer;
  idx: integer;
  testing1 : string;
  listboxavailablecount : integer;
  comparisonOption, comparisonStatsOption : integer;
begin
    //refresh everything
    //Reload ListBox
    /////////
    ListBoxSelected.Clear;
    ListBoxAvailable.Clear;
    LoadListBoxAvailable;
    //idx := listboxavailable.itemindex;
    selectedCScenarioName := comparisonScenarioListBox.Items[comparisonScenarioListBox.ItemIndex];
    //get analysis from selectec CS, then updated the list box.
    analysisInSelectedComparisonScenario := DatabaseModule.GetAnalysisfromComparisonScenario(selectedCScenarioName);
    for i  := 0 to analysisInSelectedComparisonScenario.Count - 1 do
    begin
      j := 0;
      listboxavailablecount := ListBoxAvailable.count;
      While (j <= ListBoxAvailablecount - 1) do
        begin
          //testing1 := listboxavailable.Items[19];
          if analysisInSelectedComparisonScenario[i] = listboxavailable.Items[j] then
            begin
              MoveItem(ListBoxAvailable, ListBoxSelected, j);
              Listboxavailablecount := Listboxavailablecount - 1;
            end;
          j := j + 1;
        end;
    end;
    //select comparison option
    comparisonOption := databaseModule.GetCOptionfromComparisonScenario(selectedCScenarioName);
    if comparisonOption = 1 then RadioButton1.Checked := true;
    if comparisonOption = 2 then RadioButton2.Checked := true;
    if comparisonOption = 3 then RadioButton3.Checked := true;
    if comparisonOption = 4 then RadioButton4.Checked := true;
    if comparisonOption = 5 then RadioButton5.Checked := true;
    if comparisonOption = 6 then RadioButton6.Checked := true;
    if comparisonOption = 7 then RadioButton7.Checked := true;
    if comparisonOption = 8 then RadioButton8.Checked := true;
    comparisonStatsOption := databaseModule.GetComparisonOptionForComparisonScenarioName(selectedCScenarioName);
    if comparisonStatsOption = 1 then begin
      CheckBox_OptionAvg.Checked := true;
      CheckBox_OptionPeak.Checked := false;
      CheckBox_OptionMed.Checked := false;
    end;

    if comparisonStatsOption = 2 then begin
      CheckBox_OptionAvg.Checked := false;
      CheckBox_OptionPeak.Checked := true;
      CheckBox_OptionMed.Checked := false;
    end;

    if comparisonStatsOption = 3 then begin
      CheckBox_OptionAvg.Checked := false;
      CheckBox_OptionPeak.Checked := false;
      CheckBox_OptionMed.Checked := true;
    end;

end;




procedure TfrmCAAnalysisChooser.InitializeLists;
begin
  ListBoxSelected.Clear;
  ListBoxAvailable.Clear;
  LoadListBoxAvailable;
  LoadComparisonScenarioList;
end;

procedure TfrmCAAnalysisChooser.LoadListBoxAvailable;
begin
  //load up the listboxAvailable with all analyses
  ListBoxAvailable.Clear;
  ListBoxAvailable.Items := DatabaseModule.GetAnalysisNames;

end;

procedure TfrmCAAnalysisChooser.LoadComparisonScenarioList;
begin
  //load up the comparsion scenario
  ComparisonScenarioListBox.Clear;
  ComparisonScenarioListBox.Items := DatabaseModule.GetComparisonScenarioNames;
  //load up the Listbox selected
  comparisonScenarioListBox.Selected[0];
end;

procedure TfrmCAAnalysisChooser.MoveItem(lst1, lst2: TListBox; idx: integer);
begin
  lst2.Items.Add(lst1.Items[idx]);
  lst1.Items.Delete(idx);
end;

procedure TfrmCAAnalysisChooser.okButtonClick(Sender: TObject);
begin
//OK
  ModalResult := mrOK;
end;

procedure TfrmCAAnalysisChooser.RemoveScenarioFromDisplayClick(Sender: TObject);
var
  idx : integer;
begin
//add the selected scenario from ScenarioToDisplaylistBox to comparisonscenariolistbox
//and remove from ScenarioToDisplaylistbox

  if (ScenarioToDisplaylistbox.ItemIndex > -1) then begin
    idx := ScenarioToDisplaylistbox.ItemIndex;
    MoveItem(ScenarioToDisplaylistbox, comparisonscenariolistbox, ScenarioToDisplaylistbox.ItemIndex);
    if ScenarioToDisplaylistbox.Items.Count > 0 then begin
      if ScenarioToDisplaylistbox.Items.Count > idx then
        ScenarioToDisplaylistbox.ItemIndex := idx
      else
        ScenarioToDisplaylistbox.ItemIndex := ScenarioToDisplaylistbox.Items.Count - 1;
    end;
  end;

end;

procedure TfrmCAAnalysisChooser.SelectScenarioForDisplayClick(Sender: TObject);
var
  idx : integer;
begin
//add the selected scenario from comparisonscenariolistbox to ScenarioToDisplaylistBox
//and remove from comparisonscenariolistbox

  if (ScenarioToDisplaylistbox.Items.Count < 3) then  //cannot display more than 3 scenarios
  begin
    if (comparisonscenarioListBox.ItemIndex > -1) then begin
      idx := comparisonscenarioListBox.ItemIndex;
      MoveItem(comparisonscenarioListBox, ScenarioToDisplaylistbox, comparisonscenarioListBox.ItemIndex);
      if comparisonscenarioListBox.Items.Count > 0 then begin
        if comparisonscenarioListBox.Items.Count > idx then
          comparisonscenarioListBox.ItemIndex := idx
        else
          comparisonscenarioListBox.ItemIndex := comparisonscenarioListBox.Items.Count - 1;
      end;
    end;
  end;
end;

end.
