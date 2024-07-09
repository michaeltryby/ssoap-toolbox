unit CAAnalysisChooser2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmCAAnalysisChooser2 = class(TForm)
    okButton: TButton;
    helpButton: TButton;
    btnClose: TButton;
    ListBoxSelected: TListBox;
    ComparisonScenarioListBox: TListBox;
    Label3: TLabel;
    ScenarioToDisplayListBox: TListBox;
    Label4: TLabel;
    SelectScenarioForDisplay: TButton;
    RemoveScenarioFromDisplay: TButton;
    Label6: TLabel;
    ListBoxAvailable: TListBox;
    btnQuickView: TButton;
    procedure btnQuickViewClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RemoveScenarioFromDisplayClick(Sender: TObject);
    procedure SelectScenarioForDisplayClick(Sender: TObject);
    procedure ComparisonScenarioListBoxClick(Sender: TObject);

    procedure btnCloseClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure btnRemoveAllClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    //function ChartType: integer;
    procedure LoadListBoxAvailable;
    procedure LoadComparisonScenarioList;
    procedure InitializeLists;
    procedure MoveItem(lst1: TListBox; lst2: TListBox; idx: integer);
  end;

var
  frmCAAnalysisChooser2: TfrmCAAnalysisChooser2;

implementation
uses modDatabase, newComparisonScenario, CARDIIRankingGraph2;
{$R *.dfm}

procedure TfrmCAAnalysisChooser2.btnAddClick(Sender: TObject);
begin
end;

//Loading scenario to the listbox
procedure TfrmCAAnalysisChooser2.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    //ListBoxAvailable.Items.Clear;
    //ListBoxSelected.Items.Clear;
    //ComparisonScenarioListBox.Items.Clear;
    //ScenarioToDisplayListBox.items.clear;
end;

procedure TfrmCAAnalysisChooser2.FormDestroy(Sender: TObject);
begin
    ListBoxAvailable.Items.Clear;
    ListBoxSelected.Items.Clear;
    ComparisonScenarioListBox.Items.Clear;
    ScenarioToDisplayListBox.items.clear;

end;

procedure TfrmCAAnalysisChooser2.FormShow(Sender: TObject);
begin
  //ComparisonScenarioNameEdit.Text := 'New_Comparison_Scenario'; //Spaces are not allowed!
  //existingRaingaugeNames := DatabaseModule.GetRaingaugeNames();
  //existingCScenarioNames := DatabaseModule.GetComparsionScenarioNames();
end;



procedure TfrmCAAnalysisChooser2.btnCloseClick(Sender: TObject);
begin
//Cancel
  ModalResult := mrCancel;
  ListBoxAvailable.Items.Clear;
  ListBoxSelected.Items.Clear;
  ComparisonScenarioListBox.Items.Clear;
  ScenarioToDisplayListBox.items.clear;
end;

procedure TfrmCAAnalysisChooser2.btnQuickViewClick(Sender: TObject);
var
  frmCARDIIRankGraph: TfrmCARDIIRankingGraph2;
  sName: string;
begin
  if (ComparisonScenarioListBox.ItemIndex > -1) then begin
    sName := ComparisonScenarioListBox.Items[ComparisonScenarioListBox.ItemIndex];
    Application.CreateForm(TfrmCARDIIRankingGraph2, frmCARDIIRankGraph);
    try
      frmCARDIIRankGraph.lstScenarios.Add(sName);
      frmCARDIIRankGraph.Caption := frmCARDIIRankGraph.Caption + ' - ' + sName;
      frmCARDIIRankGraph.Show;
    finally
      //FreeAndNil(frmCARDIIRankGraph);
    end;

  end;
end;

procedure TfrmCAAnalysisChooser2.btnRemoveAllClick(Sender: TObject);
begin
//remove all from listboxselected
  InitializeLists;
end;

procedure TfrmCAAnalysisChooser2.btnRemoveClick(Sender: TObject);
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

procedure TfrmCAAnalysisChooser2.ComparisonScenarioListBoxClick(Sender: TObject);
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
//rm 2012-04-12
comparisonScenarioListBox.Hint := '';
ScenarioToDisplayListBox.Hint := '';
    //refresh everything
    //Reload ListBox
    /////////
    ListBoxSelected.Clear;
    ListBoxAvailable.Clear;
    LoadListBoxAvailable;
    //idx := listboxavailable.itemindex;
//rm 2012-04-12 WRONG:    selectedCScenarioName := comparisonScenarioListBox.Items[comparisonScenarioListBox.ItemIndex];
    selectedCScenarioName := (Sender as TListBox).Items[(Sender as TListBox).ItemIndex];
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
    //rm 2012-04-16 - set the Hint to the sewershed names in the selected scenario
    if ListBoxSelected.Count > 0 then begin
      (Sender as TListBox).Hint := ListBoxSelected.Items[0];
      for i := 1 to ListBoxSelected.Count - 1 do
        (Sender as TListBox).Hint := (Sender as TListBox).Hint + chr(13) + char(10) + ListBoxSelected.Items[i];
    end else begin
      (Sender as TListBox).Hint := '(no Subcatchments!)';
    end;

end;




procedure TfrmCAAnalysisChooser2.InitializeLists;
begin
  ListBoxSelected.Clear;
  ListBoxAvailable.Clear;
  LoadListBoxAvailable;
  LoadComparisonScenarioList;
end;

procedure TfrmCAAnalysisChooser2.LoadListBoxAvailable;
begin
  //load up the listboxAvailable with all analyses
  ListBoxAvailable.Clear;
  ListBoxAvailable.Items := DatabaseModule.GetAnalysisNames;

end;

procedure TfrmCAAnalysisChooser2.LoadComparisonScenarioList;
begin
  //load up the comparsion scenario
  ComparisonScenarioListBox.Clear;
  ComparisonScenarioListBox.Items := DatabaseModule.GetComparisonScenarioNames;
  //load up the Listbox selected
  comparisonScenarioListBox.Selected[0];
end;

procedure TfrmCAAnalysisChooser2.MoveItem(lst1, lst2: TListBox; idx: integer);
begin
  lst2.Items.Add(lst1.Items[idx]);
  lst1.Items.Delete(idx);
end;

procedure TfrmCAAnalysisChooser2.okButtonClick(Sender: TObject);
begin
//OK
  ModalResult := mrOK;
end;

procedure TfrmCAAnalysisChooser2.RemoveScenarioFromDisplayClick(Sender: TObject);
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

procedure TfrmCAAnalysisChooser2.SelectScenarioForDisplayClick(Sender: TObject);
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
