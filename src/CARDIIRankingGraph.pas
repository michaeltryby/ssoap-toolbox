unit CARDIIRankingGraph;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MyChart, AnnotateX_TLB, ChartfxLib_TLB, ADODB_TLB,
  Analysis, Menus, StdCtrls, ExtCtrls;

type
  TfrmCARDIIRankingGraph = class(TForm)
    MainMenu1: TMainMenu;
    Optionx1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    Label1: TLabel;
    EventSimulatedR1R2andR31: TMenuItem;
    ObservedRTotal1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure ObservedRTotal1Click(Sender: TObject);
    procedure EventSimulatedR1R2andR31Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure DrawGraph();
    procedure Filling3Graphs();
    procedure FillingMultipleGraphs(numOfGraphs : integer; numOfBars : integer; comparisonOption : integer; comparisonStatsOption : integer);
    procedure FillingSingleGraph(numOfBars : integer; comparisonOption : integer; comparisonStatsOption : integer);
    procedure FillingONEGraph();
    procedure CreatePanels();
    procedure ResizePanels();
    procedure InitializeParameters(numOfBars : integer; cScenarioID : integer);
    procedure ObtainDataforComparsionBar();
    procedure MultiGraphsHandler();
    procedure SingleGraphHandler();
    procedure DataPrep(cScenarioID: integer; cScenarioName : string; comparisonOption : integer; comparisonStatsOption: integer;
            numOfSewershed : integer);


  private
    { Private declarations }
    ChartFX1: TChartFX;
    //XValues: array of integer;
    //YValues: array of array of double;
    totalR, R1, R2, R3: double;
    FChartType: integer;

    //Get the 'estimated/simulated' average R1, R2, and R3 values
    procedure GetAverageRValues(analysisName: string);

    //Get the 'observed' total R value
    procedure GetTotalRValue(analysisName: string);
    //Get the 'average R2 + R3' combined total value
    procedure GetAverageR2R3Value(analysisName: string);

    //Get the 'peak' R1, R2, R3 values
    procedure GetPeakRValues (analysisName: string);
    //Get the 'peak' R2 + R3 value
    procedure GetPeakR2R3Value(analysisName: string);

    //Get the medium totalR, R1, R2, R3 values
    procedure GetMedianRValues (analysisName: string);

    //Get the medium R2+R3 value
    procedure GetMedianR2R3Value(analysisName: string);

    procedure GetPeakR1_R2_R3Values(analysisName: string);
    procedure GetMedianR1_R2_R3Values(analysisName: string);
    procedure GetRDIIVolumePerSewerLength(analysisName: string);
    procedure GetRDIIPeakFlowPerArea(analysisName: string);
    procedure SortingBars(sortingoption : string; comparisonOption : integer; numOfbars : integer);
    procedure ResetSorting();

  type
    sewershed_Comparison_Stats = record
      sewershed_name : string;
      comparsion_option : integer;
      TRpeak : double;
      TRaverage : double;
      TRmedian : double;
      R1peak : double;
      R1average : double;
      R1median : double;
      R2peak : double;
      R2average : double;
      R2median : double;
      R3peak : double;
      R3average : double;
      R3median : double;
      sorted : boolean;
  end;

  type
    sewershed_Stats_for_Plotting = record
      sewershed_name : string;
      chart_option : integer;
      totalvalueBar : double;
      valueBar1 : double;
      valueBar2 : double;
      valueBar3 : double;
  end;



  public
    { Public declarations }

  private
    GraphsHorz: integer;
    GraphsVert: integer;
    Panels: array of array of TPanel;
    Graphs: array of array of MyTChartFX;
    ComparisonBarStats : array of sewershed_Comparison_Stats;
    PrioritizedBarStats: array of sewershed_Stats_for_Plotting;
  end;


var
  frmCARDIIRankingGraph: TfrmCARDIIRankingGraph;

implementation

uses CAAnalysisChooser, modDatabase, mainform, StormEventCollection, EventStatGetter;

{$R *.dfm}

procedure TfrmCARDIIRankingGraph.Close1Click(Sender: TObject);
begin
  Close;
end;


procedure TfrmCARDIIRankingGraph.CreatePanels();
var
  i, j: integer;
  pAnnList: AnnotationX;
begin
  SetLength(Panels,GraphsHorz,GraphsVert);
  SetLength(Graphs,GraphsHorz,GraphsVert);
  for i := 0 to GraphsHorz - 1 do begin
    for j := 0 to GraphsVert - 1 do begin
      Panels[i,j] := TPanel.Create(Self);
      Panels[i,j].Parent := Self;
      Graphs[i,j] := MyTChartFX.Create(Self);
      with Graphs[i,j] do begin
        Parent := Panels[i,j];
        Align := alClient;
        RightGap := 5;
        TopGap := 5;
        AllowEdit := False;
        ShowTips := False;
        ShowHint := False;
        Gallery := 2;
        Chart3D := False;
        BorderStyle := 0;
        MarkerShape := MK_NONE;
        visible := true;


        with Axis[AXIS_Y] do begin
          Title := '';
          //AutoScale := True;
        end;
        with Axis[AXIS_X] do begin
          Title := 'Sewersheds';
          //Axis[AXIS_X].MinorTickMark := TS_NONE;
          //Axis[AXIS_X].LabelAngle := 90;
          //Axis[AXIS_X].ScaleUnit := timestepsPerHour;
          //Axis[AXIS_X].Step := timestepsPerHour;
        end;
        ContextMenus := False;
        AllowEdit := False;
        AllowDrag := False;
        DblClk(2,0);
        pAnnList := CoAnnotationX.Create;
        AddExtension(pAnnList);
        pAnnList.ToolBarObj.Visible := False;
        graphs[i,j].Anno := pAnnList;
      end; //end with graphs[i,j]
    end;
  end;
end;

procedure TfrmCARDIIRankingGraph.ResizePanels();
var
  GraphWidth, GraphHeight, i ,j: integer;
begin
try
  GraphWidth := ClientWidth div GraphsHorz;
  GraphHeight := ClientHeight div GraphsVert;
  for i := 0 to GraphsHorz - 1 do begin
    for j := 0 to GraphsVert - 1 do begin
      Panels[i,j].Width := GraphWidth;
      Panels[i,j].Height := GraphHeight;
      Panels[i,j].Left := GraphWidth * i;
      Panels[i,j].Top := GraphHeight * j;
    end;
  end;
except on E: Exception do begin
  MessageDlg('Error! ' + E.Message, mtError, [mbOK], 0);
end;



end;
end;

procedure TfrmCARDIIRankingGraph.InitializeParameters(numOfBars : integer; cScenarioID : integer) ;
var
  i : integer;
begin
  setlength (ComparisonBarStats, numOfBars);
  setlength (PrioritizedBarStats, numOfBars);
  for i := 0 to numOfBars - 1 do
    begin
      ComparisonBarStats[i].sewershed_name := frmCAAnalysisChooser.ListBoxSelected.Items[i];
      ComparisonBarStats[i].TRpeak := 0.0;
      ComparisonBarStats[i].TRaverage := 0.0;
      ComparisonBarStats[i].TRmedian := 0.0;
      ComparisonBarStats[i].R1peak := 0.0;
      ComparisonBarStats[i].R1average := 0.0;
      ComparisonBarStats[i].R1median := 0.0;
      ComparisonBarStats[i].R2peak := 0.0;
      ComparisonBarStats[i].R2average := 0.0;
      ComparisonBarStats[i].R2median := 0.0;
      ComparisonBarStats[i].R3peak := 0.0;
      ComparisonBarStats[i].R3average := 0.0;
      ComparisonBarStats[i].R3median := 0.0;
      ComparisonBarStats[i].sorted := false;
    end;
end;


procedure TfrmCARDIIRankingGraph.ResetSorting() ;
var
  i : integer;
begin
  for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do
    begin
      ComparisonBarStats[i].sorted := false;
    end;
end;

procedure TfrmCARDIIRankingGraph.DataPrep (cScenarioID: integer; cScenarioName : string; comparisonOption : integer; comparisonStatsOption: integer;
            numOfSewershed : integer);
var
  i : integer;
  sewershedName : TStringList;

begin
  //Obtain a list of sewershed/RDII Analysis name, ORDER by NAME
  //Loop through each sewershed in a CScenario
  //For each sewershed/RDII analysis, obtain the following:
  // 1. based on comparison option and comparsion stats option
  //    Get stats for plots - that's all
  sewershedName := Databasemodule.GetAnalysisfromComparisonScenario(cScenarioName);
  for i := 0 to numOfSewershed - 1 do begin
    ComparisonBarStats[i].sewershed_name := sewershedName[i];
    // Comparison Option 1 ------------------------------------
    if comparisonOption = 1 then begin
      if comparisonStatsOption = 1 then begin
        GetTotalRValue(sewershedName[i]);
        comparisonbarstats[i].TRaverage := totalR;
      end;
      if comparisonStatsOption = 2 then begin
        GetPeakRValues(sewershedName[i]);
        comparisonbarstats[i].TRpeak := totalR;
      end;
      if comparisonStatsOption = 3 then begin
        GetMedianRValues(sewershedName[i]);
        comparisonbarstats[i].TRmedian := totalR;
      end;
    end;
    // Comparison Option 2 ------------------------------------
    if comparisonOption = 2 then begin
      if comparisonStatsOption = 1 then begin
        GetAverageRValues(sewershedName[i]);
        comparisonbarstats[i].TRaverage := totalR;
        comparisonbarstats[i].R1average := R1;
        comparisonbarstats[i].R2average := R2;
        comparisonbarstats[i].R3average := R3;
      end;
      if comparisonStatsOption = 2 then begin
        GetPeakR1_R2_R3Values(sewershedName[i]);
        comparisonbarstats[i].TRpeak := totalR;
        comparisonbarstats[i].R1peak := R1;
        comparisonbarstats[i].R2peak := R2;
        comparisonbarstats[i].R3peak := R3;
      end;
      if comparisonStatsOption = 3 then begin
        GetMedianR1_R2_R3Values(sewershedName[i]);
        comparisonbarstats[i].TRmedian := totalR;
        comparisonbarstats[i].R1median := R1;
        comparisonbarstats[i].R2median := R2;
        comparisonbarstats[i].R3median := R3;
      end;
    end;
    // Comparison Option 3 ------------------------------------
    if comparisonOption = 3 then begin
      if comparisonStatsOption = 1 then begin
        GetAverageRValues(sewershedName[i]);
        comparisonbarstats[i].R1average := R1;
      end;
      if comparisonStatsOption = 2 then begin
        GetPeakRValues(sewershedName[i]);
        comparisonbarstats[i].R1peak := R1;
      end;
      if comparisonStatsOption = 3 then begin
        GetMedianRValues(sewershedName[i]);
        comparisonbarstats[i].R1median := R1;
      end;
    end;
    // Comparison Option 4 ------------------------------------
    if comparisonOption = 4 then begin
      if comparisonStatsOption = 1 then begin
        GetAverageRValues(sewershedName[i]);
        comparisonbarstats[i].R2average := R2;
      end;
      if comparisonStatsOption = 2 then begin
        GetPeakRValues(sewershedName[i]);
        comparisonbarstats[i].R2peak := R2;
      end;
      if comparisonStatsOption = 3 then begin
        GetMedianRValues(sewershedName[i]);
        comparisonbarstats[i].R2median := R2;
      end;
    end;
    // Comparison Option 5 ------------------------------------
    if comparisonOption = 5 then begin
      if comparisonStatsOption = 1 then begin
        GetAverageRValues(sewershedName[i]);
        comparisonbarstats[i].R3average := R3;
      end;
      if comparisonStatsOption = 2 then begin
        GetPeakRValues(sewershedName[i]);
        comparisonbarstats[i].R3peak := R3;
      end;
      if comparisonStatsOption = 3 then begin
        GetMedianRValues(sewershedName[i]);
        comparisonbarstats[i].R3median := R3;
      end;
    end;
    // Comparison Option 6 ------------------------------------
    if comparisonOption = 6 then begin
      if comparisonStatsOption = 1 then begin
        GetAverageR2R3Value(sewershedName[i]);
        comparisonbarstats[i].TRaverage := totalR;
      end;
      if comparisonStatsOption = 2 then begin
        GetPeakR2R3Value(sewershedName[i]);
        comparisonbarstats[i].TRpeak := totalR;
      end;
      if comparisonStatsOption = 3 then begin
        GetMedianR2R3Value(sewershedName[i]);
        comparisonbarstats[i].TRmedian := totalR;
      end;
    end;
    // Comparison Option 7 ------------------------------------
    if comparisonOption = 7 then begin
      GetRDIIVolumePerSewerLength(frmCAAnalysisChooser.ListBoxSelected.Items[i]);
      if comparisonStatsOption = 1 then begin
          comparisonbarstats[i].TRaverage := totalR;    //average gallon per sewer length
      end;
      if comparisonStatsOption = 2 then begin
          comparisonbarstats[i].TRpeak := R1;           //peak gallon per sewer length
      end;
      if comparisonStatsOption = 3 then begin
          comparisonbarstats[i].TRmedian := R2;         //median gallon per sewer length
      end;
    end;

    // Comparison Option 8 ------------------------------------
    if comparisonOption = 8 then begin
      GetRDIIPeakFlowPerArea(frmCAAnalysisChooser.ListBoxSelected.Items[i]);
      if comparisonStatsOption = 1 then begin
        comparisonbarstats[i].TRaverage := totalR;    //average RDII MGD per AC.
      end;
      if comparisonStatsOption = 2 then begin
        comparisonbarstats[i].TRpeak := R1;           //peak RDII MGD per AC.
      end;
      if comparisonStatsOption = 3 then begin
        comparisonbarstats[i].TRmedian := R2;         //median RDII MGD per AC.
      end;
    end;

  end;
end;

procedure TfrmCARDIIRankingGraph.ObtainDataforComparsionBar;
var
  i : integer;
begin
  //Total R Observed
  //Obtain
  if frmCAAnalysisChooser.RadioButton1.Checked then begin
      for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
        GetTotalRValue( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        comparisonbarstats[i].TRaverage := totalR;
        GetPeakRValues( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        comparisonbarstats[i].TRpeak := totalR;
        GetMedianRValues( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        comparisonbarstats[i].TRmedian := totalR;
      end;
  end

  //Total R (estimated, R1 + R2 + R3)
  else if frmCAAnalysisChooser.RadioButton2.Checked then begin;
      for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
        GetAverageRValues(frmCAAnalysisChooser.ListBoxSelected.Items[i]);
        comparisonbarstats[i].TRaverage := totalR;
        comparisonbarstats[i].R1average := R1;
        comparisonbarstats[i].R2average := R2;
        comparisonbarstats[i].R3average := R3;

        GetPeakR1_R2_R3Values(frmCAAnalysisChooser.ListBoxSelected.Items[i]);
        comparisonbarstats[i].TRpeak := totalR;
        comparisonbarstats[i].R1peak := R1;
        comparisonbarstats[i].R2peak := R2;
        comparisonbarstats[i].R3peak := R3;


        GetMedianR1_R2_R3Values( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        comparisonbarstats[i].TRmedian := totalR;
        comparisonbarstats[i].R1median := R1;
        comparisonbarstats[i].R2median := R2;
        comparisonbarstats[i].R3median := R3;
      end;
  end

  //R1 (estimated fast response)
  else if frmCAAnalysisChooser.RadioButton3.Checked then begin;
      for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
        GetAverageRValues( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        comparisonbarstats[i].R1average := R1;
        GetPeakRValues( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        comparisonbarstats[i].R1peak := R1;
        GetMedianRValues( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        comparisonbarstats[i].R1median := R1;
      end;
  end

  //R2 (estimated medium response)
  else if frmCAAnalysisChooser.RadioButton4.Checked then begin;
      for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
        GetAverageRValues( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        comparisonbarstats[i].R2average := R2;
        GetPeakRValues( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        comparisonbarstats[i].R2peak := R2;
        GetMedianRValues( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        comparisonbarstats[i].R2median := R2;
      end;
  end

  //R3 (estimated slow response)
  else if frmCAAnalysisChooser.RadioButton5.Checked then begin;
      for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
        GetAverageRValues( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        comparisonbarstats[i].R3average := R3;
        GetPeakRValues( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        comparisonbarstats[i].R3peak := R3;
        GetMedianRValues( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        comparisonbarstats[i].R3median := R3;
      end;
  end

  //R2 + R3 (estimated medium + slow response)
  else if frmCAAnalysisChooser.RadioButton6.Checked then begin;


  end

  //RDII volume per sewer length
  else if frmCAAnalysisChooser.RadioButton7.Checked then begin;
      for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
          GetRDIIVolumePerSewerLength(frmCAAnalysisChooser.ListBoxSelected.Items[i]);
          comparisonbarstats[i].TRaverage := totalR;    //average gallon per sewer length
          comparisonbarstats[i].TRpeak := R1;           //peak gallon per sewer length
          comparisonbarstats[i].TRmedian := R2;         //median gallon per sewer length
      end;
  end

  //RDII Peak flow rate per area
  else if frmCAAnalysisChooser.RadioButton8.Checked then begin;
      for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
          GetRDIIPeakFlowPerArea(frmCAAnalysisChooser.ListBoxSelected.Items[i]);
          comparisonbarstats[i].TRaverage := totalR;    //average RDII MGD per AC.
          comparisonbarstats[i].TRpeak := R1;           //peak RDII MGD per AC.
          comparisonbarstats[i].TRmedian := R2;         //median RDII MGD per AC.
      end;

  end;
end;


procedure TfrmCARDIIRankingGraph.SortingBars(sortingoption : string; comparisonOption: integer; numOfBars : integer);
var
  i, j, k, maxPosition : integer;
  maxValue: double;
  checkValue : double;

begin
  checkValue := 1000;

  if (comparisonOption = 1) or
      (comparisonOption = 7) or
      (comparisonOption = 8)
      then
    begin
    for j := 0 to numOfBars - 1 do
      begin
      maxValue := 0;
      maxPosition := 0;
      for i := 0 to numOfBars - 1 do
        begin
          if sortingoption = 'average' then begin
              if (ComparisonBarStats[i].TRaverage > maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].TRaverage;
                maxPosition := i;
              end;
          end else if sortingoption = 'peak' then begin
              if (ComparisonBarStats[i].TRpeak > maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].TRpeak;
                maxPosition := i;
              end;
          end else if sortingoption = 'median' then begin
              if (ComparisonBarStats[i].TRmedian > maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].TRmedian;
                maxPosition := i;
              end;
          end;
        end;
      checkValue := maxValue;
      PrioritizedBarStats[j].sewershed_name := comparisonbarstats[maxPosition].sewershed_name;
      ComparisonBarStats[maxPosition].sorted := true;
      if sortingoption = 'average' then
        PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].TRaverage;
      if sortingoption = 'peak' then
        PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].TRpeak;
      if sortingoption = 'median' then
        PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].TRmedian;
      end;
    end;

  //R1 + R2 + R3
  if comparisonOption = 2 then
  begin
    for j := 0 to numOfBars - 1 do
      begin
      maxValue := 0;
      maxPosition := 0;
      for i := 0 to numOfBars - 1 do
        begin
          if sortingoption = 'average' then begin
              if (ComparisonBarStats[i].TRaverage >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].TRaverage;
                maxPosition := i;
              end;
          end else if sortingoption = 'peak' then begin
              if (ComparisonBarStats[i].TRpeak >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].TRpeak;
                maxPosition := i;
              end;
          end else if sortingoption = 'median' then begin
              if (ComparisonBarStats[i].TRmedian >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].TRmedian;
                maxPosition := i;
              end;
          end;
        end;
      checkValue := maxValue;
      PrioritizedBarStats[j].sewershed_name := comparisonbarstats[maxPosition].sewershed_name;
      ComparisonBarStats[maxPosition].sorted := true;
      if sortingoption = 'average' then
        begin
          PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].TRaverage;
          PrioritizedBarStats[j].valueBar1 := comparisonbarstats[maxPosition].R1average;
          PrioritizedBarStats[j].valueBar2 := comparisonbarstats[maxPosition].R2average;
          PrioritizedBarStats[j].valueBar3 := comparisonbarstats[maxPosition].R3average;
        end;
      if sortingoption = 'peak' then
        begin
          PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].TRpeak;
          PrioritizedBarStats[j].valueBar1 := comparisonbarstats[maxPosition].R1peak;
          PrioritizedBarStats[j].valueBar2 := comparisonbarstats[maxPosition].R2peak;
          PrioritizedBarStats[j].valueBar3 := comparisonbarstats[maxPosition].R3peak;
        end;
      if sortingoption = 'median' then
        begin
          PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].TRmedian;
          PrioritizedBarStats[j].valueBar1 := comparisonbarstats[maxPosition].R1median;
          PrioritizedBarStats[j].valueBar2 := comparisonbarstats[maxPosition].R2median;
          PrioritizedBarStats[j].valueBar3 := comparisonbarstats[maxPosition].R3median;
        end;
      end;

  end;


  //R1
  if comparisonOption = 3 then
    begin
    for j := 0 to numOfBars - 1 do
      begin
      maxValue := 0;
      maxPosition := 0;
      for i := 0 to numOfBars - 1 do
        begin
          if sortingoption = 'average' then begin
              if (ComparisonBarStats[i].R1average >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then begin
                maxValue :=  comparisonBarStats[i].R1average;
                maxPosition := i;
              end;
          end else if sortingoption = 'peak' then begin
              if (ComparisonBarStats[i].R1peak >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].R1peak;
                maxPosition := i;
              end;
          end else if sortingoption = 'median' then begin
              if (ComparisonBarStats[i].R1median >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].R1median;
                maxPosition := i;
              end;
          end;
        end;
      checkValue := maxValue;
      PrioritizedBarStats[j].sewershed_name := comparisonbarstats[maxPosition].sewershed_name;
      comparisonBarStats[maxPosition].sorted := true;
      if sortingoption = 'average' then
        PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].R1average;
      if sortingoption = 'peak' then
        PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].R1peak;
      if sortingoption = 'median' then
        PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].R1median;
      end;
    end;

    //R2
     if comparisonOption = 4 then
    begin
    for j := 0 to numOfBars - 1 do
      begin
      maxValue := 0;
      maxPosition := 0;
      for i := 0 to numOfBars - 1 do
        begin
          if sortingoption = 'average' then begin
              if (ComparisonBarStats[i].R2average >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].R2average;
                maxPosition := i;
              end;
          end else if sortingoption = 'peak' then begin
              if (ComparisonBarStats[i].R2peak >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].R2peak;
                maxPosition := i;
              end;
          end else if sortingoption = 'median' then begin
              if (ComparisonBarStats[i].R2median >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].R2median;
                maxPosition := i;
              end;
          end;
        end;
      checkValue := maxValue;
      PrioritizedBarStats[j].sewershed_name := comparisonbarstats[maxPosition].sewershed_name;
      comparisonBarStats[maxPosition].sorted := true;
      if sortingoption = 'average' then
        PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].R2average;
      if sortingoption = 'peak' then
        PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].R2peak;
      if sortingoption = 'median' then
        PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].R2median;
      end;
    end;

   //R3
     if comparisonOption = 5 then
    begin
    for j := 0 to numOfBars - 1 do
      begin
      maxValue := 0;
      maxPosition := 0;
      for i := 0 to numOfBars - 1 do
        begin
          if sortingoption = 'average' then begin
              if (ComparisonBarStats[i].R3average >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].R3average;
                maxPosition := i;
              end;
          end else if sortingoption = 'peak' then begin
              if (ComparisonBarStats[i].R3peak >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].R3peak;
                maxPosition := i;
              end;
          end else if sortingoption = 'median' then begin
              if (ComparisonBarStats[i].R3median >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].R3median;
                maxPosition := i;
              end;
          end;
        end;
      checkValue := maxValue;
      PrioritizedBarStats[j].sewershed_name := comparisonbarstats[maxPosition].sewershed_name;
      comparisonBarStats[maxPosition].sorted := true;
      if sortingoption = 'average' then
        PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].R3average;
      if sortingoption = 'peak' then
        PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].R3peak;
      if sortingoption = 'median' then
        PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].R3median;
      end;
    end;

    //R2 + R3
    if comparisonOption = 6 then
    begin
    for j := 0 to numOfBars - 1 do
      begin
      maxValue := 0;
      maxPosition := 0;
      for i := 0 to numOfBars - 1 do
        begin
          if sortingoption = 'average' then begin
              if (ComparisonBarStats[i].TRaverage >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].TRaverage;
                maxPosition := i;
              end;
          end else if sortingoption = 'peak' then begin
              if (ComparisonBarStats[i].TRpeak >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].TRpeak;
                maxPosition := i;
              end;
          end else if sortingoption = 'median' then begin
              if (ComparisonBarStats[i].TRmedian >= maxValue) and
                (ComparisonBarStats[i].sorted = false) then
              begin
                maxValue :=  comparisonBarStats[i].TRmedian;
                maxPosition := i;
              end;
          end;
        end;
      checkValue := maxValue;
      PrioritizedBarStats[j].sewershed_name := comparisonbarstats[maxPosition].sewershed_name;
      ComparisonBarStats[maxPosition].sorted := true;
      if sortingoption = 'average' then
        begin
          PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].TRaverage;
        end;
      if sortingoption = 'peak' then
        begin
          PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].TRpeak;
        end;
      if sortingoption = 'median' then
        begin
          PrioritizedBarStats[j].totalvalueBar := comparisonbarstats[maxPosition].TRmedian;
        end;
      end;

  end;

    resetSorting();
end;



procedure TfrmCARDIIRankingGraph.Filling3Graphs;
var
  i,j : integer;
  ymax : double;
begin
  //Total R Observed
  if frmCAAnalysisChooser.RadioButton1.Checked or
    frmCAAnalysisChooser.RadioButton3.Checked or
    frmCAAnalysisChooser.RadioButton4.Checked or
    frmCAAnalysisChooser.RadioButton5.Checked or
    frmCAAnalysisChooser.RadioButton8.Checked then begin
      //For each graph (3):
      //Sort the data, then rearrange them based on field selected.
      //save the sorting results into the graphing array
      //then send the data for plotting.

      //First Graph (Average):
      //Sort based on TotalR_Average
      SortingBars('average',1,1);
      //fill first Graph

      with Graphs[0,0] do begin
        //FChartType := 1;
        ymax := 0;
        ClearData(CD_DATA);
        Axis[AXIS_Y].Decimals := 3;
        Axis[AXIS_X].LabelAngle := 0;
        Axis[AXIS_X].Title := 'Sewershed';
        if frmCAAnalysisChooser.RadioButton1.Checked then Axis[AXIS_Y].Title := 'R-Value';
        if frmCAAnalysisChooser.RadioButton3.Checked then Axis[AXIS_Y].Title := 'R1';
        if frmCAAnalysisChooser.RadioButton4.Checked then Axis[AXIS_Y].Title := 'R2';
        if frmCAAnalysisChooser.RadioButton5.Checked then Axis[AXIS_Y].Title := 'R3';
        if frmCAAnalysisChooser.RadioButton8.Checked then Axis[AXIS_Y].Title := 'Peak RDII Flow Per Area';
        OpenDataEx(COD_Values, 1, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
        Stacked := 0;
        if frmCAAnalysisChooser.RadioButton1.Checked then SerLeg[0] := 'Observed Avg Total R';;
        if frmCAAnalysisChooser.RadioButton3.Checked then SerLeg[0] := 'Estimated Avg R1';;
        if frmCAAnalysisChooser.RadioButton4.Checked then SerLeg[0] := 'Estimated Avg R2';;
        if frmCAAnalysisChooser.RadioButton5.Checked then SerLeg[0] := 'Estimated Avg R3';;
        if frmCAAnalysisChooser.RadioButton8.Checked then SerLeg[0] := 'Estimated Avg Peak RDII Flow Per Area';;
        SerLegBox := true;

        for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
          ValueEx[0, i] := prioritizedbarstats[i].totalvalueBar;
          if (prioritizedbarstats[i].totalvalueBar > ymax) then ymax := prioritizedbarstats[i].totalvalueBar;
          Axis[AXIS_X].Label_[i] := prioritizedbarstats[i].sewershed_name;
        end;
        CloseData(COD_Values);
        Axis[AXIS_Y].Min := 0;
        Axis[AXIS_Y].Max := 1.1 * ymax;
      end;

      //Second Graph (Peak):
      //Sort based on TotalR_Peak
      SortingBars('peak',1,1);
      //fill second Graph
      //code go here.....
     with Graphs[0,1] do begin
        ymax := 0;
        ClearData(CD_DATA);
        Axis[AXIS_Y].Decimals := 3;
        Axis[AXIS_X].LabelAngle := 0;
        Axis[AXIS_X].Title := 'Sewershed';
        if frmCAAnalysisChooser.RadioButton1.Checked then Axis[AXIS_Y].Title := 'R-Value';
        if frmCAAnalysisChooser.RadioButton3.Checked then Axis[AXIS_Y].Title := 'R1';
        if frmCAAnalysisChooser.RadioButton4.Checked then Axis[AXIS_Y].Title := 'R2';
        if frmCAAnalysisChooser.RadioButton5.Checked then Axis[AXIS_Y].Title := 'R3';
        if frmCAAnalysisChooser.RadioButton8.Checked then Axis[AXIS_Y].Title := 'Peak RDII Flow Per Area';
        OpenDataEx(COD_Values, 1, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
        Stacked := 0;
        if frmCAAnalysisChooser.RadioButton1.Checked then SerLeg[0] := 'Observed Peak Total R';;
        if frmCAAnalysisChooser.RadioButton3.Checked then SerLeg[0] := 'Estiamted Peak R1';;
        if frmCAAnalysisChooser.RadioButton4.Checked then SerLeg[0] := 'Estiamted Peak R2';;
        if frmCAAnalysisChooser.RadioButton5.Checked then SerLeg[0] := 'Estiamted Peak R3';;
        if frmCAAnalysisChooser.RadioButton8.Checked then SerLeg[0] := 'Estimated Peak RDII Flow Per Area';;
        SerLegBox := true;
        for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
          ValueEx[0, i] := prioritizedbarstats[i].totalvalueBar;
          if (prioritizedbarstats[i].totalvalueBar > ymax) then ymax := prioritizedbarstats[i].totalvalueBar;
            Axis[AXIS_X].Label_[i] := prioritizedbarstats[i].sewershed_name;
        end;
        CloseData(COD_Values);
        Axis[AXIS_Y].Min := 0;
        Axis[AXIS_Y].Max := 1.1 * ymax;
      end;


      //third Graph (Average):
      //Sort based on TotalR_Median
      SortingBars('median',1,1);
      //fill third Graph
     with Graphs[0,2] do begin
        ymax := 0;
        ClearData(CD_DATA);
        Axis[AXIS_Y].Decimals := 3;
        Axis[AXIS_X].LabelAngle := 0;
        Axis[AXIS_X].Title := 'Sewershed';
        if frmCAAnalysisChooser.RadioButton1.Checked then Axis[AXIS_Y].Title := 'R-Value';
        if frmCAAnalysisChooser.RadioButton3.Checked then Axis[AXIS_Y].Title := 'R1';
        if frmCAAnalysisChooser.RadioButton4.Checked then Axis[AXIS_Y].Title := 'R2';
        if frmCAAnalysisChooser.RadioButton5.Checked then Axis[AXIS_Y].Title := 'R3';
        if frmCAAnalysisChooser.RadioButton8.Checked then Axis[AXIS_Y].Title := 'Peak RDII Flow Per Area';
        OpenDataEx(COD_Values, 1, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
        Stacked := 0;
        if frmCAAnalysisChooser.RadioButton1.Checked then SerLeg[0] := 'Observed Median Total R';;
        if frmCAAnalysisChooser.RadioButton3.Checked then SerLeg[0] := 'Estiamted Median R1';;
        if frmCAAnalysisChooser.RadioButton4.Checked then SerLeg[0] := 'Estiamted Median R2';;
        if frmCAAnalysisChooser.RadioButton5.Checked then SerLeg[0] := 'Estiamted Median R3';;
        if frmCAAnalysisChooser.RadioButton8.Checked then SerLeg[0] := 'Estimated Median Peak RDII Flow Per Area';;
        SerLegBox := true;
        for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
          ValueEx[0, i] := prioritizedbarstats[i].totalvalueBar;
          if (prioritizedbarstats[i].totalvalueBar > ymax) then ymax := prioritizedbarstats[i].totalvalueBar;
            Axis[AXIS_X].Label_[i] := prioritizedbarstats[i].sewershed_name;
        end;
        CloseData(COD_Values);
        Axis[AXIS_Y].Min := 0;
        Axis[AXIS_Y].Max := 1.1 * ymax;
      end;
  end

  //Total R (estimated, R1 + R2 + R3)
  else if frmCAAnalysisChooser.RadioButton2.Checked then begin;

      for j := 0 to 2 do
      begin
        if j = 0 then SortingBars('average',1,1);
        if j = 1 then SortingBars('peak',1,1);
        if j = 2 then SortingBars('median',1,1);

        with Graphs[0,j] do begin
          //FChartType := 1;
          ymax := 0;
          OpenDataEx(COD_Values, 3, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
          SerLeg[0] := 'R1';
          SerLeg[1] := 'R2';
          SerLeg[2] := 'R3';
          SerLegBox := true;
          Stacked := 1;
          Axis[AXIS_Y].Title := 'R-Value';
          Axis[AXIS_X].Title := 'Sewershed';
          for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
            ValueEx[0, i] := PrioritizedBarStats[i].valueBar1;
            ValueEx[1, i] := PrioritizedBarStats[i].valueBar2;
            ValueEx[2, i] := PrioritizedBarStats[i].valueBar3;
            if (PrioritizedBarStats[i].valueBar1 + PrioritizedBarStats[i].valueBar2 + PrioritizedBarStats[i].valueBar3 > ymax) then
              ymax := PrioritizedBarStats[i].valueBar1 + PrioritizedBarStats[i].valueBar2 + PrioritizedBarStats[i].valueBar3;
            Axis[AXIS_X].Label_[i] := PrioritizedBarStats[i].sewershed_name;
          end;
          CloseData(COD_Values);
          Axis[AXIS_Y].Min := 0;
          Axis[AXIS_Y].Max := 1.1 * ymax;
        end;
      end;
  end

  //R1 (estimated fast response)
  else if frmCAAnalysisChooser.RadioButton3.Checked then begin;

  end

  //R2 (estimated medium response)
  else if frmCAAnalysisChooser.RadioButton4.Checked then begin;

  end

  //R3 (estimated slow response)
  else if frmCAAnalysisChooser.RadioButton5.Checked then begin;

  end

  //R2 + R3 (estimated medium + slow response)
  else if frmCAAnalysisChooser.RadioButton6.Checked then begin;

  end

  //RDII volume per sewer length
  else if frmCAAnalysisChooser.RadioButton7.Checked then begin;
     //For each graph (3):
      //Sort the data, then rearrange them based on field selected.
      //save the sorting results into the graphing array
      //then send the data for plotting.

      //First Graph (Average):
      //Sort based on TotalR_Average
      SortingBars('average',1,1);
      //fill first Graph

      with Graphs[0,0] do begin
        //FChartType := 1;
        ymax := 0;
        ClearData(CD_DATA);
        Axis[AXIS_Y].Decimals := 3;
        Axis[AXIS_X].LabelAngle := 0;
        Axis[AXIS_X].Title := 'Sewershed';
        Axis[AXIS_Y].Title := 'gallon per lienar feet';
        OpenDataEx(COD_Values, 1, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
        Stacked := 0;
        SerLeg[0] := 'RDII volume Per Linear Feet';
        SerLegBox := true;

        for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
          ValueEx[0, i] := prioritizedbarstats[i].totalvalueBar;
          if (prioritizedbarstats[i].totalvalueBar > ymax) then ymax := prioritizedbarstats[i].totalvalueBar;
          Axis[AXIS_X].Label_[i] := prioritizedbarstats[i].sewershed_name;
        end;
        CloseData(COD_Values);
        Axis[AXIS_Y].Min := 0;
        Axis[AXIS_Y].Max := 1.1 * ymax;
      end;

      //Second Graph (Peak):
      //Sort based on TotalR_Peak
      SortingBars('peak',1,1);
      //fill second Graph
      //code go here.....
     with Graphs[0,1] do begin
        ymax := 0;
        ClearData(CD_DATA);
        Axis[AXIS_Y].Decimals := 3;
        Axis[AXIS_X].LabelAngle := 0;
        Axis[AXIS_X].Title := 'Sewershed';
        Axis[AXIS_Y].Title := 'gallon per linear feet';
        OpenDataEx(COD_Values, 1, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
        Stacked := 0;
        SerLeg[0] := 'RDII Volume Per Linear Feet';
        SerLegBox := true;
        for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
          ValueEx[0, i] := prioritizedbarstats[i].totalvalueBar;
          if (prioritizedbarstats[i].totalvalueBar > ymax) then ymax := prioritizedbarstats[i].totalvalueBar;
            Axis[AXIS_X].Label_[i] := prioritizedbarstats[i].sewershed_name;
        end;
        CloseData(COD_Values);
        Axis[AXIS_Y].Min := 0;
        Axis[AXIS_Y].Max := 1.1 * ymax;
      end;


      //third Graph (Average):
      //Sort based on TotalR_Median
      SortingBars('median',1,1);
      //fill third Graph
     with Graphs[0,2] do begin
        ymax := 0;
        ClearData(CD_DATA);
        Axis[AXIS_Y].Decimals := 3;
        Axis[AXIS_X].LabelAngle := 0;
        Axis[AXIS_X].Title := 'Sewershed';
        Axis[AXIS_Y].Title := 'gallon per linear feet';
        OpenDataEx(COD_Values, 1, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
        Stacked := 0;
        SerLeg[0] := 'Median RDII Volume Per Linear Feet';
        SerLegBox := true;
        for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
          ValueEx[0, i] := prioritizedbarstats[i].totalvalueBar;
          if (prioritizedbarstats[i].totalvalueBar > ymax) then ymax := prioritizedbarstats[i].totalvalueBar;
            Axis[AXIS_X].Label_[i] := prioritizedbarstats[i].sewershed_name;
        end;
        CloseData(COD_Values);
        Axis[AXIS_Y].Min := 0;
        Axis[AXIS_Y].Max := 1.1 * ymax;
      end;
  end

  //RDII Peak flow rate per area
  else if frmCAAnalysisChooser.RadioButton8.Checked then begin;

  end;
end;


procedure TfrmCARDIIRankingGraph.FillingMultipleGraphs(numOfGraphs : integer;
  numOfBars : integer; comparisonOption : integer; comparisonStatsOption : integer);
var
  i,j : integer;
  ymax : double;
  legendTxt : string;
begin
  if comparisonStatsOption = 1 then legendTxt := 'Average';
  if comparisonStatsOption = 2 then legendTxt := 'Peak';
  if comparisonStatsOption = 3 then legendTxt := 'Median';

  if (comparisonOption = 1) or (comparisonOption = 3) or (comparisonOption = 4)
    or (comparisonOption = 5) or (comparisonOption = 6) or (comparisonOption = 8) then
    begin
      if comparisonStatsOption = 1 then SortingBars('average',comparisonOption,numOfBars);
      if comparisonStatsOption = 2 then SortingBars('peak',comparisonOption,numOfBars);
      if comparisonStatsOption = 3 then SortingBars('median',comparisonOption,numOfBars);

      with Graphs[0,numOfGraphs-1] do begin
        //FChartType := 1;
        ymax := 0;
        ClearData(CD_DATA);
        Axis[AXIS_Y].Decimals := 3;
        Axis[AXIS_X].LabelAngle := 0;
        Axis[AXIS_X].Title := 'Sewershed';
        if comparisonOption = 1 then Axis[AXIS_Y].Title := legendTxt + ' R-Value';
        if comparisonOption = 3 then Axis[AXIS_Y].Title := legendTxt + ' R1';
        if comparisonOption = 4 then Axis[AXIS_Y].Title := legendTxt + ' R2';
        if comparisonOption = 5 then Axis[AXIS_Y].Title := legendTxt + ' R3';
        if comparisonOption = 6 then Axis[AXIS_Y].Title := legendTxt + ' R2 + R3';

        if comparisonOption = 8 then Axis[AXIS_Y].Title := legendTxt + ' Peak RDII Flow Per Area';
        OpenDataEx(COD_Values, 1, numOfBars);
        Stacked := 0;
        if comparisonOption = 1 then SerLeg[0] := legendTxt + ' Total R';
        if comparisonOption = 3 then SerLeg[0] := legendTxt + ' R1';
        if comparisonOption = 4 then SerLeg[0] := legendTxt + ' R2';
        if comparisonOption = 5 then SerLeg[0] := legendTxt +  ' R3';
        if comparisonOption = 6 then SerLeg[0] := legendTxt +  ' R2 + R3';
        if comparisonOption = 8 then SerLeg[0] := legendTxt + ' Avg Peak RDII Flow Per Area';
        SerLegBox := true;

        for i := 0 to numOfBars - 1 do begin
          ValueEx[0, i] := prioritizedbarstats[i].totalvalueBar;
          if (prioritizedbarstats[i].totalvalueBar > ymax) then ymax := prioritizedbarstats[i].totalvalueBar;
          Axis[AXIS_X].Label_[i] := prioritizedbarstats[i].sewershed_name;
        end;
        CloseData(COD_Values);
        Axis[AXIS_Y].Min := 0;
        Axis[AXIS_Y].Max := 1.1 * ymax;
      end;

    end;
  if comparisonOption = 2 then begin
    if comparisonStatsOption = 1 then SortingBars('average',comparisonOption,numOfBars);
    if comparisonStatsOption = 2 then SortingBars('peak',comparisonOption,numOfBars);
    if comparisonStatsOption = 3 then SortingBars('median',comparisonOption,numOfBars);
    with Graphs[0,numOfGraphs-1] do begin
          //FChartType := 1;
          ymax := 0;
          OpenDataEx(COD_Values, 3, numOfBars);
          SerLeg[0] := 'R1';
          SerLeg[1] := 'R2';
          SerLeg[2] := 'R3';
          SerLegBox := true;
          Stacked := 1;
          Axis[AXIS_Y].Title := 'R-Value';
          Axis[AXIS_X].Title := 'Sewershed';
          for i := 0 to numOfBars - 1 do begin
            ValueEx[0, i] := PrioritizedBarStats[i].valueBar1;
            ValueEx[1, i] := PrioritizedBarStats[i].valueBar2;
            ValueEx[2, i] := PrioritizedBarStats[i].valueBar3;
            if (PrioritizedBarStats[i].valueBar1 + PrioritizedBarStats[i].valueBar2 + PrioritizedBarStats[i].valueBar3 > ymax) then
              ymax := PrioritizedBarStats[i].valueBar1 + PrioritizedBarStats[i].valueBar2 + PrioritizedBarStats[i].valueBar3;
            Axis[AXIS_X].Label_[i] := PrioritizedBarStats[i].sewershed_name;
          end;
          CloseData(COD_Values);
          Axis[AXIS_Y].Min := 0;
          Axis[AXIS_Y].Max := 1.1 * ymax;
    end;
  end;
  if comparisonOption = 7 then begin
      if comparisonStatsOption = 1 then SortingBars('average',comparisonOption,numOfBars);
      if comparisonStatsOption = 2 then SortingBars('peak',comparisonOption,numOfBars);
      if comparisonStatsOption = 3 then SortingBars('median',comparisonOption,numOfBars);
      with Graphs[0,numOfGraphs - 1] do begin
        //FChartType := 1;
        ymax := 0;
        ClearData(CD_DATA);
        Axis[AXIS_Y].Decimals := 3;
        Axis[AXIS_X].LabelAngle := 0;
        Axis[AXIS_X].Title := 'Sewershed';
        Axis[AXIS_Y].Title := 'gallon per lienar feet';
        OpenDataEx(COD_Values, 1, numOfBars);
        Stacked := 0;
        SerLeg[0] := 'RDII volume Per Linear Feet';
        SerLegBox := true;

        for i := 0 to numOfBars - 1 do begin
          ValueEx[0, i] := prioritizedbarstats[i].totalvalueBar;
          if (prioritizedbarstats[i].totalvalueBar > ymax) then ymax := prioritizedbarstats[i].totalvalueBar;
          Axis[AXIS_X].Label_[i] := prioritizedbarstats[i].sewershed_name;
        end;
        CloseData(COD_Values);
        Axis[AXIS_Y].Min := 0;
        Axis[AXIS_Y].Max := 1.1 * ymax;
      end;

  end;
end;



procedure TfrmCARDIIRankingGraph.FillingSingleGraph(numOfBars : integer; comparisonOption : integer; comparisonStatsOption : integer);
var
  i: integer;
  ymax: double;
  legendlabel : string;
begin
  if comparisonStatsOption = 1 then begin
    legendlabel := 'Average';
    sortingbars ('average',comparisonOption,numOfBars);
  end;

  if comparisonStatsOption = 2 then begin
    legendlabel := 'Maximum';
    sortingbars ('peak',comparisonOption,numOfBars);
  end;

  if comparisonStatsOption = 3 then begin
    legendlabel := 'Median';
    sortingbars ('median',comparisonOption,numOfBars);
  end;
  ymax := 0;

  FChartType := 0;

  //ChartFX1:=TChartFX.Create(Self);
  with ChartFX1 do begin
    Parent := Self;
    Left := 8;
    Top := 8;
    Width := ClientWidth - 16;
    Height := ClientHeight - 16;
    TabOrder := 0;
    visible := true;
    Chart3D := false;
  end;


  ChartFX1.ClearData(CD_DATA);
  ChartFX1.Axis[AXIS_Y].Decimals := 3;
  ChartFX1.Axis[AXIS_X].LabelAngle := 0;
  ChartFX1.Axis[AXIS_X].Title := 'Sewershed';
  ChartFX1.Axis[AXIS_Y].Title := legendlabel + 'R-Value';
  FChartType := 1;

  if comparisonOption = 2 then
  begin
      FChartType:= 0;
      ChartFX1.OpenDataEx(COD_Values, 3, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
      ChartFX1.SerLeg[0] := 'R1';
      ChartFX1.SerLeg[1] := 'R2';
      ChartFX1.SerLeg[2] := 'R3';
      ChartFX1.SerLegBox := true;
      ChartFX1.Stacked := 1;
      for i := 0 to numOfBars - 1 do begin
        ChartFX1.ValueEx[0, i] := PrioritizedBarStats[i].valueBar1;
        ChartFX1.ValueEx[1, i] := PrioritizedBarStats[i].valueBar2;
        ChartFX1.ValueEx[2, i] := PrioritizedBarStats[i].valueBar3;
        if (PrioritizedBarStats[i].valueBar1 + PrioritizedBarStats[i].valueBar2 + PrioritizedBarStats[i].valueBar3 > ymax) then
          ymax := PrioritizedBarStats[i].valueBar1 + PrioritizedBarStats[i].valueBar2 + PrioritizedBarStats[i].valueBar3;
          ChartFX1.Axis[AXIS_X].Label_[i] := PrioritizedBarStats[i].sewershed_name;
      end;
      ChartFX1.CloseData(COD_Values);
      ChartFX1.Axis[AXIS_Y].Min := 0;
      ChartFX1.Axis[AXIS_Y].Max := 1.1 * ymax;
  end
  else begin
      ChartFX1.OpenDataEx(COD_Values, 1, numOfBars);
      if comparisonOption = 1 then ChartFX1.Axis[AXIS_Y].Title := legendlabel + ' R-Value';
      if comparisonOption = 3 then ChartFX1.Axis[AXIS_Y].Title := legendlabel + ' R1';
      if comparisonOption = 4 then ChartFX1.Axis[AXIS_Y].Title := legendlabel + ' R2';
      if comparisonOption = 5 then ChartFX1.Axis[AXIS_Y].Title := legendlabel + ' R3';
      if comparisonOption = 6 then ChartFX1.Axis[AXIS_Y].Title := legendlabel + ' R2 + R3';
      if comparisonOption = 7 then ChartFX1.Axis[AXIS_Y].Title := legendlabel + ' Gallon per Lienar Feet';
      if comparisonOption = 8 then ChartFX1.Axis[AXIS_Y].Title := legendlabel + ' Peak RDII Flow Per Area (gpm per acre)';
      ChartFX1.SerLegBox := true;
      ChartFX1.Stacked := 0;
      if comparisonOption = 1 then ChartFX1.SerLeg[0] := legendlabel + ' Total R';
      if comparisonOption = 3 then ChartFX1.SerLeg[0] := legendlabel + ' R1';
      if comparisonOption = 4 then ChartFX1.SerLeg[0] := legendlabel + ' R2';
      if comparisonOption = 5 then ChartFX1.SerLeg[0] := legendlabel + ' R3';
      if comparisonOption = 6 then ChartFX1.SerLeg[0] := legendlabel + ' R2 + R3';
      if comparisonOption = 7 then ChartFX1.SerLeg[0] := legendlabel + ' Gallon per Lienar Feet';
      if comparisonOption = 8 then ChartFX1.SerLeg[0] := legendlabel + ' Peak RDII Flow Per Area';

      for i := 0 to numOfBars - 1 do begin
        ChartFX1.ValueEx[0, i] := prioritizedbarstats[i].totalvalueBar;
        if (prioritizedbarstats[i].totalvalueBar > ymax) then ymax := prioritizedbarstats[i].totalvalueBar;
        ChartFX1.Axis[AXIS_X].Label_[i] := prioritizedbarstats[i].sewershed_name;
      end;
      ChartFX1.CloseData(COD_Values);
      ChartFX1.Axis[AXIS_Y].Min := 0;
      ChartFX1.Axis[AXIS_Y].Max := 1.1 * ymax;
  end;
  if ClientWidth > 16 then
    ChartFX1.Width := ClientWidth - 16;
  if Clientheight > 16 then
    ChartFX1.Height := ClientHeight - 16;

end;


procedure TfrmCARDIIRankingGraph.DrawGraph;
var i: integer;
rmax: double;
sewershedarea: double;
begin
//load up the graph with x number of data series, 3 by
  FChartType := 0;
  rmax := 0;
  ChartFX1.ClearData(CD_DATA);
  ChartFX1.Axis[AXIS_Y].Decimals := 3;
  ChartFX1.Axis[AXIS_X].LabelAngle := 0;
  ChartFX1.Axis[AXIS_X].Title := 'Sewershed';
  ChartFX1.Axis[AXIS_Y].Title := 'R-Value';
  if frmCAAnalysisChooser.RadioButton2.Checked or
     frmCAAnalysisChooser.RadioButton3.Checked or
     frmCAAnalysisChooser.RadioButton4.Checked or
     frmCAAnalysisChooser.RadioButton5.Checked
    then FChartType := 1;
    if frmCAAnalysisChooser.RadioButton1.Checked then begin
      ChartFX1.OpenDataEx(COD_Values, 3, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
      ChartFX1.SerLeg[0] := 'R1';
      ChartFX1.SerLeg[1] := 'R2';
      ChartFX1.SerLeg[2] := 'R3';
      ChartFX1.SerLegBox := true;
      ChartFX1.Stacked := 1;
      for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
        GetAverageRValues( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        ChartFX1.ValueEx[0, i] := R1;
        ChartFX1.ValueEx[1, i] := R2;
        ChartFX1.ValueEx[2, i] := R3;
        if (R1 + R2 + R3 > rmax) then rmax := R1 + R2 + R3;
        ChartFX1.Axis[AXIS_X].Label_[i] := frmCAAnalysisChooser.ListBoxSelected.Items[i];
      end;
      ChartFX1.CloseData(COD_Values);
      ChartFX1.Axis[AXIS_Y].Min := 0;
      ChartFX1.Axis[AXIS_Y].Max := 1.1 * rmax;
    end else if frmCAAnalysisChooser.RadioButton2.Checked then begin
      ChartFX1.OpenDataEx(COD_Values, 1, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
      ChartFX1.SerLeg[0] := 'Observed Avg Total R';
      ChartFX1.SerLegBox := true;
      ChartFX1.Stacked := 0;
      for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
        GetTotalRValue( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        ChartFX1.ValueEx[0, i] := R1;
        if (R1 > rmax) then rmax := R1;
        ChartFX1.Axis[AXIS_X].Label_[i] := frmCAAnalysisChooser.ListBoxSelected.Items[i];
      end;
      ChartFX1.CloseData(COD_Values);
      ChartFX1.Axis[AXIS_Y].Min := 0;
      ChartFX1.Axis[AXIS_Y].Max := 1.1 * rmax;
    end else if frmCAAnalysisChooser.RadioButton3.Checked then begin
      ChartFX1.OpenDataEx(COD_Values, 1, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
      ChartFX1.SerLeg[0] := 'Observed Avg RDII Volume Per Sewer Length';
      ChartFX1.SerLegBox := true;
      ChartFX1.Stacked := 0;
      ChartFX1.Axis[AXIS_Y].Title := 'Average Observed RDII Volume (Gallons Per Linear Feet)';
      for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
        GetRDIIVolumePerSewerLength( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        ChartFX1.ValueEx[0, i] := R1/3;  {divided by 3 for example..should take it off}
        if (R1 > rmax) then rmax := R1/3;
        ChartFX1.Axis[AXIS_X].Label_[i] := frmCAAnalysisChooser.ListBoxSelected.Items[i];
      end;
      ChartFX1.CloseData(COD_Values);
      ChartFX1.Axis[AXIS_Y].Min := 0;
      ChartFX1.Axis[AXIS_Y].Max := 1.1 * rmax;
    end else if frmCAAnalysisChooser.RadioButton4.Checked then begin
      ChartFX1.OpenDataEx(COD_Values, 1, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
      ChartFX1.SerLeg[0] := 'Observed Avg RDII Peak Flow Per Area';
      ChartFX1.SerLegBox := true;
      ChartFX1.Stacked := 0;
      ChartFX1.Axis[AXIS_Y].Title := 'Average Observed RDII Peak Flow (MGD Per Acre)';
      for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
        GetRDIIPeakFlowPerArea( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        ChartFX1.ValueEx[0, i] := R1;
        if (R1 > rmax) then rmax := R1;
        ChartFX1.Axis[AXIS_X].Label_[i] := frmCAAnalysisChooser.ListBoxSelected.Items[i];
      end;
      ChartFX1.CloseData(COD_Values);
      ChartFX1.Axis[AXIS_Y].Min := 0;
      ChartFX1.Axis[AXIS_Y].Max := 1.1 * rmax;
    end else if frmCAAnalysisChooser.RadioButton5.Checked then begin
      ChartFX1.OpenDataEx(COD_Values, 1, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
      ChartFX1.SerLeg[0] := 'Simulated Avg R1';
      ChartFX1.SerLegBox := true;
      ChartFX1.Stacked := 0;
      ChartFX1.Axis[AXIS_Y].Title := 'Average Simulated R1 Value';
      for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
        GetAverageRValues( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        ChartFX1.ValueEx[0, i] := R1;
        if (R1 > rmax) then rmax := R1;
        ChartFX1.Axis[AXIS_X].Label_[i] := frmCAAnalysisChooser.ListBoxSelected.Items[i];
      end;
      ChartFX1.CloseData(COD_Values);
      ChartFX1.Axis[AXIS_Y].Min := 0;
      ChartFX1.Axis[AXIS_Y].Max := 1.1 * rmax;
    end else if frmCAAnalysisChooser.RadioButton6.Checked then begin
      ChartFX1.OpenDataEx(COD_Values, 2, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
      ChartFX1.SerLeg[0] := 'R2';
      ChartFX1.SerLeg[1] := 'R3';
      ChartFX1.SerLegBox := true;
      ChartFX1.Stacked := 1;
      ChartFX1.Axis[AXIS_Y].Title := 'Average Simulated R2 + R3 Values';
      for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
        GetAverageRValues( frmCAAnalysisChooser.ListBoxSelected.Items[i] );
        ChartFX1.ValueEx[0, i] := R2;
        ChartFX1.ValueEx[1, i] := R3;
        if (R2 + R3 > rmax) then rmax := R2 + R3;
        ChartFX1.Axis[AXIS_X].Label_[i] := frmCAAnalysisChooser.ListBoxSelected.Items[i];
      end;
    end;
end;

procedure TfrmCARDIIRankingGraph.EventSimulatedR1R2andR31Click(Sender: TObject);
begin
  //
  frmCAAnalysisChooser.RadioButton1.Checked := EventSimulatedR1R2andR31.Checked;
  DrawGraph;
end;

procedure TfrmCARDIIRankingGraph.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//rm 2012-04-09 handled in formdestroy: ChartFX1.Free;
   //chartFX1.destroy;
end;

procedure TfrmCARDIIRankingGraph.FormCreate(Sender: TObject);
begin

  FChartType := 0;
  ChartFX1:=TChartFX.Create(Self);
{
  with ChartFX1 do begin
    Parent := Self;
    Left := 8;
    Top := 8;
    Width := ClientWidth - 16;
    Height := ClientHeight - 16;
    TabOrder := 0;
    visible := true;
    Chart3D := false;
  end;
 }
end;

procedure TfrmCARDIIRankingGraph.FormDestroy(Sender: TObject);
begin
  ChartFX1.Free;
end;

procedure TfrmCARDIIRankingGraph.FormResize(Sender: TObject);
begin
  try
  if  Assigned(ChartFX1) then begin

  if frmCAAnalysisChooser.ScenarioToDisplayListBox.items.count = 1 then
    begin
      if ClientWidth > 16 then
        ChartFX1.Width := ClientWidth - 16;
      if Clientheight > 16 then
        ChartFX1.Height := ClientHeight - 16;
    end
  else
    if (self.Visible) then begin
    ResizePanels;
    //Filling3Graphs;
    //FillingMultipleGraphs(i+1, numOfBars, comparisonOption, comparisonStatsOption);
  end;
  end;
  except on E: Exception do begin
      MessageDlg('Error in TfrmCARDIIRankingGraph.FormResize! ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmCARDIIRankingGraph.FormShow(Sender: TObject);
begin
  //this is where to direct the traffic: 1 plot vs. 3 plots.

  if frmCAAnalysisChooser.ScenarioToDisplayListBox.items.count = 1 then
    SingleGraphHandler();
  if frmCAAnalysisChooser.ScenarioToDisplayListBox.items.count > 1 then
    MultiGraphsHandler();
    // Go to plot multiple graphs "Central"

{
  GraphsHorz := 1;
  GraphsVert := frmCAAnalysisChooser.ScenarioToDisplayListBox.items.count;

  CreatePanels();
  Resizepanels();

  InitializeParameters;
  ObtainDataforComparsionBar;
  //FChartType := 1;
  Filling3graphs;
  //FillingONEgraph;
  //DrawGraph;
  }
end;

procedure TfrmCARDIIRankingGraph.GetAverageRValues(analysisName: string);
var
  queryStr: string;
  analysisID, raingaugeID: integer;
  rainfall, totalrainfall: double;
  localRecSet: _RecordSet;
  counter: integer;
begin

//get the average R1, R2, and R3 for the selected analysis
    analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
    raingaugeID := DatabaseModule.GetRainGaugeIDForAnalysisID(analysisID);
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ');'; // Group by a.AnalysisID;';
    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    //rm 2007-10-18 - prevent crash if no records
    R1 := 0.0;
    R2 := 0.0;
    R3 := 0.0;
    totalrainfall := 0;
    counter :=0 ;
    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      while not localRecSet.EOF do begin
        Rainfall := DatabaseModule.RainfallTotalForRaingaugeBetweenDates(raingaugeID,
          localRecSet.Fields.Item[4].value,localRecSet.Fields.Item[5].value);
        totalRainfall := totalRainfall + Rainfall;
        R1 := R1 + localRecSet.Fields.Item[1].Value; //* Rainfall; //fixed this
        R2 := R2 + localRecSet.Fields.Item[2].Value; //* Rainfall; //fixed this
        R3 := R3 + localRecSet.Fields.Item[3].Value; //* Rainfall; //fixed this
        totalR := totalR + R1 + R2 + R3;
        localRecSet.MoveNext;
        counter := counter + 1;
      end;
    end;
    if counter > 0 then
    begin
      R1 := R1 / counter;
      R2 := R2 / counter;
      R3 := R3 / counter;
      totalR := totalR / counter;
    end;
    //Fixed this
    {if totalRainfall > 0 then begin
      R1 := R1 / totalRainfall;
      R2 := R2 / totalRainfall;
      R3 := R3 / totalRainfall;
    end;}

    localRecSet.Close;
//  end else begin

//  end;
end;

procedure TfrmCARDIIRankingGraph.GetTotalRValue(analysisName: string);
var
  analysisID, i: integer;
  events: TStormEventCollection;
  myEventStatGetter: TEventStatGetter;
  runningR: double;
  runningRF: double;
begin
//get observed R total
  runningR := 0.0;
  //runningRF := 0.0;
  analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
  events := DatabaseModule.GetEvents(analysisID);
  if events.count > 0  then begin
    myEventStatGetter := TEventStatGetter.Create(analysisID);
    for i := 1 to events.count do begin
      myEventStatGetter.GetEventStats(i);
      runningR := runningR + myEventStatGetter.eventTotalR;
    end;
    myEventStatGetter.AllDone;
    totalR := runningR / events.count;
    R1 := 0.0;
    R2 := 0.0;
    R3 := 0.0;
  end;
end;


procedure TfrmCARDIIRankingGraph.GetAverageR2R3Value(analysisName: string);
var
  queryStr: string;
  analysisID, raingaugeID: integer;
  localRecSet: _RecordSet;
  counter: integer;
begin
//get the average, peak, and medium R2, and R3 for the selected analysis
  //totalR := average R2 + R3
  //R1 := peak R2 + R3
  //R2 := medium R2 + R3
  analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
  raingaugeID := DatabaseModule.GetRainGaugeIDForAnalysisID(analysisID);
//  if FChartType = 0 then begin
//    queryStr := 'SELECT a.AnalysisID, Avg(b.[R1]), Avg(b.[R2]), Avg(b.[R3]) ' +
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ');'; // Group by a.AnalysisID;';
    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    //rm 2007-10-18 - prevent crash if no records
    R1 := 0.0;
    R2 := 0.0;
    R3 := 0.0;
    totalR := 0.0;  //Here - totalR means R2 + R3
    counter :=0 ;
    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      while not localRecSet.EOF do begin
        totalR := localRecSet.Fields.Item[2].Value + localRecSet.Fields.Item[3].Value;
        if localRecSet.Fields.Item[2].Value +
         localRecSet.Fields.Item[3].Value > R1 then R1 :=
         localRecSet.Fields.Item[2].Value + localRecSet.Fields.Item[3].Value;
        localRecSet.MoveNext;
        counter := counter + 1;
      end;
    end;
    localRecSet.Close;
    totalR := totalR / counter  //average R2 + R2
end;


procedure TfrmCARDIIRankingGraph.GetPeakR2R3Value(analysisName: string);
var
  queryStr: string;
  analysisID, raingaugeID: integer;
  localRecSet: _RecordSet;
  counter: integer;
begin
//get the peak R2 + R3 for the selected analysis
  //totalR := peak R2 + R3
  analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
  raingaugeID := DatabaseModule.GetRainGaugeIDForAnalysisID(analysisID);
//  if FChartType = 0 then begin
//    queryStr := 'SELECT a.AnalysisID, Avg(b.[R1]), Avg(b.[R2]), Avg(b.[R3]) ' +
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ');'; // Group by a.AnalysisID;';
    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    //rm 2007-10-18 - prevent crash if no records
    R1 := 0.0;
    R2 := 0.0;
    R3 := 0.0;
    totalR := 0.0;  //Here - totalR means R2 + R3
    counter :=0 ;
    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      while not localRecSet.EOF do begin
        if localRecSet.Fields.Item[2].Value +
         localRecSet.Fields.Item[3].Value > totalR then totalR :=
         localRecSet.Fields.Item[2].Value + localRecSet.Fields.Item[3].Value;
        localRecSet.MoveNext;
        counter := counter + 1;
      end;
    end;
    localRecSet.Close;
end;


procedure TfrmCARDIIRankingGraph.GetPeakRValues(analysisName: string);
var
  queryStr: string;
  analysisID, raingaugeID: integer;
  localRecSet: _RecordSet;
  counter: integer;
begin

//get the average R1, R2, and R3 for the selected analysis
  analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
  raingaugeID := DatabaseModule.GetRainGaugeIDForAnalysisID(analysisID);
//  if FChartType = 0 then begin
//    queryStr := 'SELECT a.AnalysisID, Avg(b.[R1]), Avg(b.[R2]), Avg(b.[R3]) ' +
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ');'; // Group by a.AnalysisID;';
    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    //rm 2007-10-18 - prevent crash if no records
    R1 := 0.0;
    R2 := 0.0;
    R3 := 0.0;
    totalR := 0.0;
    counter :=0 ;
    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      while not localRecSet.EOF do begin
        if localRecSet.Fields.Item[1].Value > R1 then R1 := localRecSet.Fields.Item[1].Value;
        if localRecSet.Fields.Item[2].Value > R2 then R2 := localRecSet.Fields.Item[2].Value;
        if localRecSet.Fields.Item[3].Value > R3 then R3 := localRecSet.Fields.Item[3].Value;
        if localRecSet.Fields.Item[1].Value + localRecSet.Fields.Item[2].Value +
         localRecSet.Fields.Item[3].Value > totalR then totalR := localRecSet.Fields.Item[1].Value +
         localRecSet.Fields.Item[2].Value + localRecSet.Fields.Item[3].Value;

        localRecSet.MoveNext;
        counter := counter + 1;
      end;
    end;
    localRecSet.Close;
//  end else begin

//  end;
end;



procedure TfrmCARDIIRankingGraph.GetPeakR1_R2_R3Values(analysisName: string);
var
  queryStr: string;
  analysisID, raingaugeID: integer;
  localRecSet: _RecordSet;
  counter: integer;
begin

//get the peak R+R2+R3, and obtain the R1, R2, and R3 correspond to that peak event for the selected analysis
  analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
  raingaugeID := DatabaseModule.GetRainGaugeIDForAnalysisID(analysisID);
//  if FChartType = 0 then begin
//    queryStr := 'SELECT a.AnalysisID, Avg(b.[R1]), Avg(b.[R2]), Avg(b.[R3]) ' +
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ');'; // Group by a.AnalysisID;';
    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    //rm 2007-10-18 - prevent crash if no records
    R1 := 0.0;
    R2 := 0.0;
    R3 := 0.0;
    totalR := 0.0;
    counter :=0 ;
    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      while not localRecSet.EOF do begin
        if localRecSet.Fields.Item[1].Value + localRecSet.Fields.Item[2].Value +
         localRecSet.Fields.Item[3].Value > totalR then
         begin
           totalR := localRecSet.Fields.Item[1].Value +
             localRecSet.Fields.Item[2].Value + localRecSet.Fields.Item[3].Value;
           R1 := localRecSet.Fields.Item[1].Value;
           R2 := localRecSet.Fields.Item[2].Value;
           R3 := localRecSet.Fields.Item[3].Value;
         end;

        localRecSet.MoveNext;
        counter := counter + 1;
      end;
    end;
    localRecSet.Close;
end;



//Get median totalR, median R1, median R2, and median R3 for the given analysis
procedure TfrmCARDIIRankingGraph.GetMedianRValues(analysisName: string);
var
  queryStr: string;
  analysisID, raingaugeID: integer;
  localRecSet: _RecordSet;
  counter, i: integer;

begin
//CC 2012-03-11
//get the median total R value for the selected analysis
    analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
    raingaugeID := DatabaseModule.GetRainGaugeIDForAnalysisID(analysisID);
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ') ORDER BY b.[R1]+ b.[R2] + b.[R3];';  // Group by sum of total R;';

    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);

    totalR := 0.0;
    counter :=0 ;

    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      counter := 0;
      while not(localRecSet.EOF) do begin
        counter := counter + 1;
        localRecSet.MoveNext;
      end;
      localrecset.MoveFirst;
      if (counter mod 2 = 0) then begin
        for i := 0 to counter div 2 - 2 do begin
          localrecset.movenext;
        end;
        totalR := localRecSet.Fields.Item[1].Value +
                  localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
        localrecset.MoveNext;
        totalR := totalR + localRecSet.Fields.Item[1].Value +
                  localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
        totalR := totalR / 2;
      end
      else begin
        for i := 0 to counter div 2 - 1 do localrecset.MoveNext;
        totalR := localRecSet.Fields.Item[1].Value +
                  localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
      end;
    end else begin
      totalR := 0;
    end;
    localRecSet.Close;

//get the median R1 value for the selected analysis
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ') ORDER BY b.[R1];';  // Group by sum of total R;';

    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);

    R1 := 0.0;
    counter :=0 ;

    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      counter := 0;
      while not(localRecSet.EOF) do begin
        counter := counter + 1;
        localRecSet.MoveNext;
      end;
      localrecset.MoveFirst;
      if (counter mod 2 = 0) then begin
        for i := 0 to counter div 2 - 2 do begin
          localrecset.movenext;
        end;
        R1 := localRecSet.Fields.Item[1].Value;
        localrecset.MoveNext;
        R1 := R1 + localRecSet.Fields.Item[1].Value;
        R1 := R1 / 2;
      end
      else begin
        for i := 0 to counter div 2 - 1 do localrecset.MoveNext;
        R1 := localRecSet.Fields.Item[1].Value;
      end;
    end else begin
      R1 := 0;
    end;
    localRecSet.Close;


//get the median R2 value for the selected analysis
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ') ORDER BY b.[R2];';  // Group by sum of total R;';

    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);

    R2 := 0.0;
    counter :=0 ;

    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      counter := 0;
      while not(localRecSet.EOF) do begin
        counter := counter + 1;
        localRecSet.MoveNext;
      end;
      localrecset.MoveFirst;
      if (counter mod 2 = 0) then begin
        for i := 0 to counter div 2 - 2 do begin
          localrecset.movenext;
        end;
        R2 := localRecSet.Fields.Item[2].Value;
        localrecset.MoveNext;
        R2 := R2 + localRecSet.Fields.Item[2].Value;
        R2 := R2 / 2;
      end
      else begin
        for i := 0 to counter div 2 - 1 do localrecset.MoveNext;
        R2 := localRecSet.Fields.Item[2].Value;
      end;
    end else begin
      R2 := 0;
    end;
    localRecSet.Close;

//get the median R3 value for the selected analysis
   queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ') ORDER BY b.[R3];';  // Group by sum of total R;';

    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);

    R3 := 0.0;
    counter :=0 ;

    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      counter := 0;
      while not(localRecSet.EOF) do begin
        counter := counter + 1;
        localRecSet.MoveNext;
      end;
      localrecset.MoveFirst;
      if (counter mod 2 = 0) then begin
        for i := 0 to counter div 2 - 2 do begin
          localrecset.movenext;
        end;
        R3 := localRecSet.Fields.Item[3].Value;
        localrecset.MoveNext;
        R3 := R3 + localRecSet.Fields.Item[3].Value;
        R3 := R3 / 2;
      end
      else begin
        for i := 0 to counter div 2 - 1 do localrecset.MoveNext;
        R3 := localRecSet.Fields.Item[3].Value;
      end;
    end else begin
      R3 := 0;
    end;
    localRecSet.Close;
end;


procedure TfrmCARDIIRankingGraph.GetMedianR1_R2_R3Values(analysisName: string);
var
  queryStr: string;
  analysisID, raingaugeID: integer;
  localRecSet: _RecordSet;
  counter, i: integer;

begin
//CC 2012-03-11
    analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
    raingaugeID := DatabaseModule.GetRainGaugeIDForAnalysisID(analysisID);
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ') ORDER BY b.[R1]+ b.[R2] + b.[R3];';  // Group by sum of total R;';

    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);

    totalR := 0.0;
    counter :=0 ;

    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      counter := 0;
      while not(localRecSet.EOF) do begin
        counter := counter + 1;
        localRecSet.MoveNext;
      end;
      localrecset.MoveFirst;
      if (counter mod 2 = 0) then begin
        for i := 0 to counter div 2 - 2 do begin
          localrecset.movenext;
        end;
        totalR := localRecSet.Fields.Item[1].Value +
                  localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
        R1 := localRecSet.Fields.Item[1].Value;
        R2 := localRecSet.Fields.Item[2].Value;
        R3 := localRecSet.Fields.Item[3].Value;
        localrecset.MoveNext;
        totalR := totalR + localRecSet.Fields.Item[1].Value +
                  localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
        R1 := R1 + localRecSet.Fields.Item[1].Value;
        R2 := R2 + localRecSet.Fields.Item[2].Value;
        R3 := R3 + localRecSet.Fields.Item[3].Value;

        totalR := totalR / 2;
        R1 := R1 / 2;
        R2 := R2 / 2;
        R3 := R3 / 2;
      end
      else begin
        for i := 0 to counter div 2 - 1 do localrecset.MoveNext;
        totalR := localRecSet.Fields.Item[1].Value +
                  localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
        R1 := localRecSet.Fields.Item[1].Value;
        R2 := localRecSet.Fields.Item[2].Value;
        R3 := localRecSet.Fields.Item[3].Value;
      end;
    end else begin
      totalR := 0;
      R1 := 0;
      R2 := 0;
      R3 := 0;
    end;
    localRecSet.Close;
end;


procedure TfrmCARDIIRankingGraph.GetMedianR2R3Value(analysisName: string);
var
  queryStr: string;
  analysisID, raingaugeID: integer;
  localRecSet: _RecordSet;
  counter, i: integer;

begin
//CC 2012-03-11
//get the median R2+R3 value for the selected analysis
    analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
    raingaugeID := DatabaseModule.GetRainGaugeIDForAnalysisID(analysisID);
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ') ORDER BY b.[R1]+ b.[R2] + b.[R3];';  // Group by sum of total R;';

    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);

    totalR := 0.0;
    counter :=0 ;

    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      counter := 0;
      while not(localRecSet.EOF) do begin
        counter := counter + 1;
        localRecSet.MoveNext;
      end;
      localrecset.MoveFirst;
      if (counter mod 2 = 0) then begin
        for i := 0 to counter div 2 - 2 do begin
          localrecset.movenext;
        end;
        totalR := localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
        localrecset.MoveNext;
        totalR := localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
        totalR := totalR / 2;
      end
      else begin
        for i := 0 to counter div 2 - 1 do localrecset.MoveNext;
        totalR := localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
      end;
    end else begin
      totalR := 0;
    end;
    localRecSet.Close;
end;


procedure TfrmCARDIIRankingGraph.GetRDIIVolumePerSewerLength(analysisName: string);
var
  analysisID, i, j: integer;
  events: TStormEventCollection;
  myEventStatGetter: TEventStatGetter;
  runningR: double;
  runningRF: double;
  max, checkmax : double;
  RdiiData : array of double; //for storing all RDIIVolumePerLength then sort them to get median value
  sortedRdiiData : array of double;

  begin
//get observed R total
  runningR := 0.0;
  max := 0.0;
  //runningRF := 0.0;
  analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
  events := DatabaseModule.GetEvents(analysisID);
  if events.count > 0  then begin
    setlength (RDIIdata, events.count);
    setlength (sortedRdiidata, events.count);
    myEventStatGetter := TEventStatGetter.Create(analysisID);
    for i := 1 to events.count do begin
      myEventStatGetter.GetEventStats(i);
      runningR := runningR + myEventStatGetter.RDIIgalperLF;
      rdiidata[i-1] := myEventStatGetter.RDIIgalperLF;
      if myEventStatGetter.RDIIgalperLF > max then
        max := myEventStatGetter.RDIIgalperLF;
    end;
    myEventStatGetter.AllDone;
    totalR := runningR / events.count;  //average
    R1 := max;  //peak

    //Sort RDIIdata based on RDiIgalperLF and get the median value
    checkmax := 1000000;
    for i := 0 to events.Count - 1 do
    begin
      max := 0;
      for j := 0 to events.Count - 1 do begin
          if (rdiidata[j] > max) and (rdiidata[j] < checkmax) then begin
              max := rdiidata[j];
          end;
      end;
      sortedrdiidata[i] := max;
      checkmax := max;
    end;

    //Median RDII Volumer per linear feet
    if (events.count mod 2 = 0) then begin
      R2 := (sortedrdiidata[events.count div 2] + sortedrdiidata[events.count div 2 + 1])/2
    end else begin
      R2 := sortedrdiidata[events.count div 2];
    end;

    R3 := 0.0;
  end;
end;


procedure TfrmCARDIIRankingGraph.GetRDIIPeakFlowPerArea(analysisName: string);
var
  analysisID, i, j: integer;
  events: TStormEventCollection;
  myEventStatGetter: TEventStatGetter;
  runningR: double;
  runningRF: double;
  sewershedarea: double;
  max, checkmax : double;
  RdiiData : array of double; //for storing all RDIIVolumePerLength then sort them to get median value
  sortedRdiiData : array of double;

begin
//get observed R total
  runningR := 0.0;
  max := 0.0;
  //runningRF := 0.0;
  analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
  events := DatabaseModule.GetEvents(analysisID);
  sewershedarea := DatabaseModule.GetAreaForAnalysis(analysisName);
  if events.count > 0  then begin
    setlength (RDIIdata, events.count);
    setlength (sortedRdiidata, events.count);
    myEventStatGetter := TEventStatGetter.Create(analysisID);
    for i := 1 to events.count do begin
      myEventStatGetter.GetEventStats(i);
      runningR := runningR + myEventStatGetter.peakIIFlow;
      rdiidata[i-1] := myEventStatGetter.peakIIFlow;
      if myEventStatGetter.peakIIFlow > max then
        max := myEventStatGetter.peakIIFlow;
    end;
    myEventStatGetter.AllDone;

    //Average RDII peak per area
    totalR := runningR / events.count / sewershedarea;
    //Peak RDII peak per area
    R1 := max / sewershedarea;

   //Sort RDIIdata based on RDII peak flow per area and get the median value
    checkmax := 1000000;
    for i := 0 to events.Count - 1 do
    begin
      max := 0;
      for j := 0 to events.Count - 1 do begin
          if (rdiidata[j] > max) and (rdiidata[j] < checkmax) then begin
              max := rdiidata[j];
          end;
      end;
      sortedrdiidata[i] := max;
      checkmax := max;
    end;

    //Median RDII Volume per area
    if (events.count mod 2 = 0) then begin
      R2 := (sortedrdiidata[events.count div 2] + sortedrdiidata[events.count div 2 + 1])/2
    end else begin
      R2 := sortedrdiidata[events.count div 2];
    end;

    R3 := 0.0;
  end;
end;


procedure TfrmCARDIIRankingGraph.ObservedRTotal1Click(Sender: TObject);
begin
  //
  frmCAAnalysisChooser.RadioButton2.Checked := ObservedRTotal1.Checked;
  DrawGraph;
end;



procedure TfrmCARDIIRankingGraph.FillingONEGraph;
var
  i,j : integer;
  ymax : double;
begin
  //Total R Observed
  if frmCAAnalysisChooser.RadioButton1.Checked or
    frmCAAnalysisChooser.RadioButton3.Checked or
    frmCAAnalysisChooser.RadioButton4.Checked or
    frmCAAnalysisChooser.RadioButton5.Checked or
    frmCAAnalysisChooser.RadioButton8.Checked then begin
      //For each graph (3):
      //Sort the data, then rearrange them based on field selected.
      //save the sorting results into the graphing array
      //then send the data for plotting.

      //First Graph (Average):
      //Sort based on TotalR_Average
      SortingBars('average',1,1);
      //fill first Graph

      with Graphs[0,0] do begin
        //FChartType := 1;
        ymax := 0;
        ClearData(CD_DATA);
        Axis[AXIS_Y].Decimals := 3;
        Axis[AXIS_X].LabelAngle := 0;
        Axis[AXIS_X].Title := 'Sewershed';
        if frmCAAnalysisChooser.RadioButton1.Checked then Axis[AXIS_Y].Title := 'R-Value';
        if frmCAAnalysisChooser.RadioButton3.Checked then Axis[AXIS_Y].Title := 'R1';
        if frmCAAnalysisChooser.RadioButton4.Checked then Axis[AXIS_Y].Title := 'R2';
        if frmCAAnalysisChooser.RadioButton5.Checked then Axis[AXIS_Y].Title := 'R3';
        if frmCAAnalysisChooser.RadioButton8.Checked then Axis[AXIS_Y].Title := 'Peak RDII Flow Per Area';
        OpenDataEx(COD_Values, 1, frmCAAnalysisChooser.ListBoxSelected.Items.Count);
        Stacked := 0;
        if frmCAAnalysisChooser.RadioButton1.Checked then SerLeg[0] := 'Observed Avg Total R';;
        if frmCAAnalysisChooser.RadioButton3.Checked then SerLeg[0] := 'Estimated Avg R1';;
        if frmCAAnalysisChooser.RadioButton4.Checked then SerLeg[0] := 'Estimated Avg R2';;
        if frmCAAnalysisChooser.RadioButton5.Checked then SerLeg[0] := 'Estimated Avg R3';;
        if frmCAAnalysisChooser.RadioButton8.Checked then SerLeg[0] := 'Estimated Avg Peak RDII Flow Per Area';;
        SerLegBox := true;

        for i := 0 to frmCAAnalysisChooser.ListBoxSelected.Items.Count - 1 do begin
          ValueEx[0, i] := prioritizedbarstats[i].totalvalueBar;
          if (prioritizedbarstats[i].totalvalueBar > ymax) then ymax := prioritizedbarstats[i].totalvalueBar;
          Axis[AXIS_X].Label_[i] := prioritizedbarstats[i].sewershed_name;
        end;
        CloseData(COD_Values);
        Axis[AXIS_Y].Min := 0;
        Axis[AXIS_Y].Max := 1.1 * ymax;
      end;
  end;
end;

procedure TfrmCARDIIRankingGraph.MultiGraphsHandler() ;
var
  i : integer;
  numOfCScenarios, numOfBars : integer;
  comparisonOption, comparisonStatsOption: integer;
  cScenarioID : integer;
  testing1 : string;
begin
  numOfCScenarios := frmCAAnalysisChooser.ScenarioToDisplayListBox.items.count;

  GraphsHorz := 1;
  GraphsVert := numOfCScenarios;

  CreatePanels();
  Resizepanels();

  for i := 0 to numOfCScenarios - 1 do begin
    //check number of sewershed in CScenario_X
    //check the CScenarioID
    numOfBars := DatabaseModule.GetNumofSubsewershedForComparisonScenarioName(
      frmCAAnalysisChooser.ScenarioToDisplayListBox.Items[i]);
    cScenarioID := DatabaseModule.GetComparisonScenarioIDForName(
      frmCAAnalysisChooser.ScenarioToDisplayListBox.Items[i]);
    comparisonOption := DatabaseModule.GetComparisonOptionForComparisonScenarioName(
      frmCAAnalysisChooser.ScenarioToDisplayListBox.Items[i]);
    comparisonStatsOption := DatabaseModule.GetComparisonStatsOptionForComparisonScenarioName(
      frmCAAnalysisChooser.ScenarioToDisplayListBox.Items[i]);

    InitializeParameters(numOfBars,cScenarioID);
    DataPrep(cScenarioID,frmCAAnalysisChooser.ScenarioToDisplayListBox.Items[i],comparisonOption,comparisonStatsOption,numOfBars);
    FillingMultipleGraphs(i+1, numOfBars, comparisonOption, comparisonStatsOption);
    //Fill MultipleGraph (whichGraph)
  end;
end;


procedure TfrmCARDIIRankingGraph.SingleGraphHandler() ;
var
  i : integer;
  numOfBars : integer;
  comparisonOption, comparisonStatsOption: integer;
  cScenarioID : integer;
  testing1 : string;
begin

  //GraphsHorz := 1;
  //GraphsVert := 1;

  //CreatePanels();
  //Resizepanels();

  numOfBars := DatabaseModule.GetNumofSubsewershedForComparisonScenarioName(
    frmCAAnalysisChooser.ScenarioToDisplayListBox.Items[0]);
  cScenarioID := DatabaseModule.GetComparisonScenarioIDForName(
    frmCAAnalysisChooser.ScenarioToDisplayListBox.Items[0]);
  comparisonOption := DatabaseModule.GetComparisonOptionForComparisonScenarioName(
    frmCAAnalysisChooser.ScenarioToDisplayListBox.Items[0]);
  comparisonStatsOption := DatabaseModule.GetComparisonStatsOptionForComparisonScenarioName(
    frmCAAnalysisChooser.ScenarioToDisplayListBox.Items[0]);

    InitializeParameters(numOfBars,cScenarioID);
    DataPrep(cScenarioID,frmCAAnalysisChooser.ScenarioToDisplayListBox.Items[0],comparisonOption,comparisonStatsOption,numOfBars);
    FillingSingleGraph(numOfBars, comparisonOption, comparisonStatsOption);
    //Fill MultipleGraph (whichGraph)
end;

end.
