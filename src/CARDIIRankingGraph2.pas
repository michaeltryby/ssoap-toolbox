unit CARDIIRankingGraph2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MyChart, AnnotateX_TLB, ChartfxLib_TLB, ADODB_TLB,
  Analysis, Menus, StdCtrls, ExtCtrls, ActiveX, OleCtrls, SfxBar_TLB, ExtDlgs;

type
  TfrmCARDIIRankingGraph2 = class(TForm)
    MainMenu1: TMainMenu;
    Optionx1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    Label1: TLabel;
    test1: TMenuItem;
    SavetoText1: TMenuItem;
    SaveTextFileDialog1: TSaveTextFileDialog;
    procedure SavetoText1Click(Sender: TObject);
    procedure test1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FillingMultipleGraphs(numOfGraphs : integer; numOfBars : integer; comparisonOption : integer;
      comparisonStatsOption : integer; legendTxt1: string);
    procedure FillingSingleGraph(numOfBars : integer; comparisonOption : integer; comparisonStatsOption : integer;
      legendTxt1: string);
    procedure CreatePanels();
    procedure ResizePanels();
    procedure InitializeParameters(numOfBars : integer; cScenarioID : integer);
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
    //rm 2012-04-17
    lstScenarios: TStringList;

  private
    GraphsHorz: integer;
    GraphsVert: integer;
    Panels: array of array of TPanel;
    Graphs: array of array of TChartFX; //MyTChartFX;
    ComparisonBarStats : array of sewershed_Comparison_Stats;
    PrioritizedBarStats: array of sewershed_Stats_for_Plotting;
  end;


var
  frmCARDIIRankingGraph2: TfrmCARDIIRankingGraph2;
  //rm 2012-04-18 - Let's make NumOfBars a global
  NumberOfBars: array[0..2] of integer;

implementation

uses {CAAnalysisChooser2,} modDatabase, mainform, StormEventCollection, EventStatGetter;

{$R *.dfm}

procedure TfrmCARDIIRankingGraph2.Close1Click(Sender: TObject);
begin
  Close;
end;


procedure TfrmCARDIIRankingGraph2.CreatePanels();
var
  i, j: integer;
  pAnnList: AnnotationX;
  ft: TFont;
  dft: ActiveX.IFontDisp;
begin

//rm 2012-04-16
//the AXIS Font
ft:= TFont.Create;
with ft do
begin
Name := 'Arial';
Size := 12;
//Style:= [fsBold];
end;
dft := IFontDisp(IDispatch(FontToOleFont(Ft)));
//Font := IFontDisp(IDispatch(FontToOleFont(Ft)));
//VerticalAlignment := moAlignBottom;
//HorizontalAlignment:= moAlignLeft
//end;
//now we can
//Ft.Free;



  SetLength(Panels,GraphsHorz,GraphsVert);
  SetLength(Graphs,GraphsHorz,GraphsVert);
  for i := 0 to GraphsHorz - 1 do begin
    for j := 0 to GraphsVert - 1 do begin
      Panels[i,j] := TPanel.Create(Self);
      Panels[i,j].Parent := Self;
      Graphs[i,j] := TChartFX.Create(Self); //rm 2012-04-16  MyTChartFX.Create(Self);
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

        //rm 2012-04-16
        LegendFont := self.Font;
        LegendFont.Size := 12;
        SerLegBoxObj.Docked := $00000100; //top

        //rm 2012-07-16 - can we set the background color to white?
        SerLegBoxObj.BkColor := clWhite;

        Axis[AXIS_Y].TitleFont := dft;
        Axis[AXIS_X].TitleFont := dft;

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
        //rm 2012-04-16 - allow the context menus so user may change fonts etc.
        ContextMenus := True; //False;
        AllowEdit := True; //False;
        AllowDrag := False;
        DblClk(2,0);
        //rm 2012-04-16 - what is all this - never used anyway
        //pAnnList := CoAnnotationX.Create;
        //AddExtension(pAnnList);
        //pAnnList.ToolBarObj.Visible := False;
        //rm 2012-04-16 graphs[i,j].Anno := pAnnList;
      end; //end with graphs[i,j]
    end;
  end;
end;

procedure TfrmCARDIIRankingGraph2.ResizePanels();
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

procedure TfrmCARDIIRankingGraph2.InitializeParameters(numOfBars : integer; cScenarioID : integer) ;
var
  i : integer;
  lst : TStringList;
begin
  setlength (ComparisonBarStats, numOfBars);
  setlength (PrioritizedBarStats, numOfBars);
  //rm 2012-04-16
  //lst := TStringList.Create();
  lst := DatabaseModule.GetAnalysisNamesForComparisonScenario(cScenarioID);
  // if lst.Count <> numOfBars then there is a problem
  if (lst.Count <> numOfBars) then begin
    messagedlg('Warning: Number of  Bars (' + IntToStr(numOfBars) + ') <> Number of Sewersheds (' + IntToStr(lst.Count) + ')', mtWarning, [mbok], 0);
  end;
  //messagedlg('Number of  Bars =' + IntToStr(numOfBars) + '; Number of Sewersheds =' + IntToStr(lst.Count), mtInformation, [mbok], 0);

  for i := 0 to numOfBars - 1 do
    begin
      //rm 2012-04-16 - bombs here:
//rm added GetAnalysisNamesForComparisonScenario      ComparisonBarStats[i].sewershed_name := frmCAAnalysisChooser2.ListBoxSelected.Items[i];
      ComparisonBarStats[i].sewershed_name := lst[i];
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


procedure TfrmCARDIIRankingGraph2.ResetSorting() ;
var
  i : integer;
begin
  //rm 2012-04-16 can be wrong: for i := 0 to frmCAAnalysisChooser2.ListBoxSelected.Items.Count - 1 do
  for i := Low(ComparisonBarStats) to High(ComparisonBarStats) do
    begin
      ComparisonBarStats[i].sorted := false;
    end;
end;

procedure TfrmCARDIIRankingGraph2.DataPrep (cScenarioID: integer; cScenarioName : string; comparisonOption : integer; comparisonStatsOption: integer;
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
        //GetTotalRValue(sewershedName[i]);
        GetAverageRValues(sewershedName[i]);
        comparisonbarstats[i].TRaverage := R1+R2+R3;
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
        comparisonbarstats[i].TRaverage := R1 + R2 + R3;
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
//rm 2012-04-16 WRONG:      GetRDIIVolumePerSewerLength(frmCAAnalysisChooser2.ListBoxSelected.Items[i]);
      GetRDIIVolumePerSewerLength(sewershedName[i]);
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
//rm 2012-04-16 WRONG:            GetRDIIPeakFlowPerArea(frmCAAnalysisChooser2.ListBoxSelected.Items[i]);
      GetRDIIPeakFlowPerArea(sewershedName[i]);
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


procedure TfrmCARDIIRankingGraph2.SortingBars(sortingoption : string; comparisonOption: integer; numOfBars : integer);
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
      //rm 2012-07-16 set maxValue to -1 to handle Rs of 0 (zero) maxValue := 0;
      maxValue := -1;
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
      //rm 2012-07-16 set maxValue to -1 to handle Rs of 0 (zero) maxValue := 0;
      maxValue := -1;
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
      //rm 2012-07-16 set maxValue to -1 to handle Rs of 0 (zero) maxValue := 0;
      maxValue := -1;
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
      //rm 2012-07-16 set maxValue to -1 to handle Rs of 0 (zero) maxValue := 0;
      maxValue := -1;
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
      //rm 2012-07-16 set maxValue to -1 to handle Rs of 0 (zero) maxValue := 0;
      maxValue := -1;
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
      //rm 2012-07-16 set maxValue to -1 to handle Rs of 0 (zero) maxValue := 0;
      maxValue := -1;
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



procedure TfrmCARDIIRankingGraph2.test1Click(Sender: TObject);
var
  s: string;
begin
  s := IntToStr(ChartFX1.SerLegBoxObj.Docked);
  MessageDlg('SerLegBoxObj.Docked = ' + s, mtInformation, [mbok], 0);
end;


procedure TfrmCARDIIRankingGraph2.FillingMultipleGraphs(numOfGraphs : integer;
  numOfBars : integer; comparisonOption : integer; comparisonStatsOption : integer;
  legendTxt1: string);
var
  i,j : integer;
  ymax : double;
  legendTxt : string;
begin
//rm 2012-04-17 defaults
if comparisonStatsOption < 1 then comparisonStatsOption := 1;
if comparisonOption < 1 then comparisonOption := 1;

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
        Axis[AXIS_Y].Decimals := 2;
        Axis[AXIS_X].LabelAngle := 0;
        Axis[AXIS_X].Title := 'Sewershed';
        //if comparisonOption = 1 then Axis[AXIS_Y].Title := legendTxt + ' R-Value';
        //if comparisonOption = 3 then Axis[AXIS_Y].Title := legendTxt + ' R1';
        //if comparisonOption = 4 then Axis[AXIS_Y].Title := legendTxt + ' R2';
        //if comparisonOption = 5 then Axis[AXIS_Y].Title := legendTxt + ' R3';
        //if comparisonOption = 6 then Axis[AXIS_Y].Title := legendTxt + ' R2 + R3';

        //if comparisonOption = 8 then Axis[AXIS_Y].Title := legendTxt + ' Peak RDII Flow Per Area';

        if comparisonOption = 1 then Axis[AXIS_Y].Title := 'Total R';
        if comparisonOption = 3 then Axis[AXIS_Y].Title := 'R1';
        if comparisonOption = 4 then Axis[AXIS_Y].Title := 'R2';
        if comparisonOption = 5 then Axis[AXIS_Y].Title := 'R3';
        if comparisonOption = 6 then Axis[AXIS_Y].Title := 'R2 + R3';

        if comparisonOption = 8 then Axis[AXIS_Y].Title := 'Peak RDII Flow Per Area';

        OpenDataEx(COD_Values, 1, numOfBars);
        Stacked := 0;
        //rm 2012-04-17 - added legendTx1 to SerLeg
        if comparisonOption = 1 then SerLeg[0] := 'Analysis Name: ' + legendTxt1 + '; RDII Parameter Option: Total R (' + legendTxt+ ')';
        if comparisonOption = 3 then SerLeg[0] := 'Analysis Name: ' + legendTxt1 + '; RDII Parameter: R1 (' + legendTxt+ ')';
        if comparisonOption = 4 then SerLeg[0] := 'Analysis Name: ' + legendTxt1 + '; RDII Parameter: R2 (' + legendTxt+ ')';
        if comparisonOption = 5 then SerLeg[0] := 'Analysis Name: ' + legendTxt1 +  '; RDII Parameter: R3 (' + legendTxt+ ')';
        if comparisonOption = 6 then SerLeg[0] := 'Analysis Name: ' + legendTxt1 +  '; RDII Parameter: R2 + R3 (' + legendTxt+ ')';
        if comparisonOption = 8 then SerLeg[0] := 'Analysis Name: ' + legendTxt1 + '; RDII Parameter: Peak RDII Flow Per Area (' + legendTxt + ')';
        SerLegBox := true;

  //rm 2012-04-17
  if (numOfBars = 0) then begin

    messagedlg('Warning: Number of Sewersheds in Scenario ' + legendTxt1 + ' = 0', mtWarning, [mbok], 0);

  end;// else begin
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
          Axis[AXIS_Y].Title := 'R Values';
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



procedure TfrmCARDIIRankingGraph2.FillingSingleGraph(numOfBars : integer; comparisonOption : integer;
  comparisonStatsOption : integer; legendTxt1: string);
var
  i: integer;
  ymax: double;
  legendlabel : string;
  ft: TFont;
  dft: ActiveX.IFontDisp;
begin
//rm 2012-04-16
//the AXIS Font
ft:= TFont.Create;
with ft do
begin
Name := 'Arial';
Size := 12;
//Style:= [fsBold];
end;
dft := IFontDisp(IDispatch(FontToOleFont(Ft)));

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

  //rm 2012-04-16
  ChartFX1.LegendFont := self.Font;
  ChartFX1.LegendFont.Size := 12;
  ChartFX1.SerLegBoxObj.Docked := $00000100;
  //ChartFX1.LegendBoxObj.Docked := __MIDL___MIDL_itf_sfxbar_0000_0001  TGFP_TOP;
  //ChartFX1.LegStyle := 9;
    //rm 2012-07-16
    ChartFX1.SerLegBoxObj.BkColor := clWhite;


  ChartFX1.ClearData(CD_DATA);
  ChartFX1.Axis[AXIS_Y].Decimals := 2;
  ChartFX1.Axis[AXIS_X].LabelAngle := 0;
  ChartFX1.Axis[AXIS_X].Title := 'Sewershed';
  ChartFX1.Axis[AXIS_Y].Title := 'R-Value';

  //rm 2012-04-16
  Chartfx1.Axis[AXIS_X].TitleFont := dft;
  Chartfx1.Axis[AXIS_Y].TitleFont := dft;
  FChartType := 1;

  if comparisonOption = 2 then
  begin
      FChartType:= 0;
//rm 2012-04-16 WRONG:      ChartFX1.OpenDataEx(COD_Values, 3, frmCAAnalysisChooser2.ListBoxSelected.Items.Count);
      ChartFX1.OpenDataEx(COD_Values, 3, numOfBars);
      //ChartFX1.SerLeg[0] := legendTxt1 + ' R1';
      //ChartFX1.SerLeg[1] := legendTxt1 + ' R2';
      //ChartFX1.SerLeg[2] := legendTxt1 + ' R3';

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
{      if comparisonOption = 1 then ChartFX1.Axis[AXIS_Y].Title := legendlabel + ' R-Value';
      if comparisonOption = 3 then ChartFX1.Axis[AXIS_Y].Title := legendlabel + ' R1';
      if comparisonOption = 4 then ChartFX1.Axis[AXIS_Y].Title := legendlabel + ' R2';
      if comparisonOption = 5 then ChartFX1.Axis[AXIS_Y].Title := legendlabel + ' R3';
      if comparisonOption = 6 then ChartFX1.Axis[AXIS_Y].Title := legendlabel + ' R2 + R3';
      if comparisonOption = 7 then ChartFX1.Axis[AXIS_Y].Title := legendlabel + ' Gallon per Linear Feet';
      if comparisonOption = 8 then ChartFX1.Axis[AXIS_Y].Title := legendlabel + ' Peak RDII Flow Per Area (gpm per acre)';}
      if comparisonOption = 1 then ChartFX1.Axis[AXIS_Y].Title := 'Total R';
      if comparisonOption = 3 then ChartFX1.Axis[AXIS_Y].Title := 'R1';
      if comparisonOption = 4 then ChartFX1.Axis[AXIS_Y].Title := 'R2';
      if comparisonOption = 5 then ChartFX1.Axis[AXIS_Y].Title := 'R3';
      if comparisonOption = 6 then ChartFX1.Axis[AXIS_Y].Title := 'R2 + R3';
      if comparisonOption = 7 then ChartFX1.Axis[AXIS_Y].Title := 'RDII Volume (Gallons) per Linear Feet';
      if comparisonOption = 8 then ChartFX1.Axis[AXIS_Y].Title := 'Peak RDII Flow per Area (gpm per acre)';
      ChartFX1.SerLegBox := true;
      ChartFX1.Stacked := 0;
      if comparisonOption = 1 then ChartFX1.SerLeg[0] := 'Analysis Name: ' + legendTxt1 + '; RDII Parameter Option: Total R (' + legendlabel + ')';
      if comparisonOption = 3 then ChartFX1.SerLeg[0] := 'Analysis Name: ' + legendTxt1 + '; RDII Parameter: R1 (' + legendlabel + ')';
      if comparisonOption = 4 then ChartFX1.SerLeg[0] := 'Analysis Name: ' + legendTxt1 + '; RDII Parameter: R2 (' + legendlabel + ')';
      if comparisonOption = 5 then ChartFX1.SerLeg[0] := 'Analysis Name: ' + legendTxt1 +  '; RDII Parameter: R3 (' + legendlabel + ')';
      if comparisonOption = 6 then ChartFX1.SerLeg[0] := 'Analysis Name: ' + legendTxt1 +  '; RDII Parameter: R2 + R3 (' + legendlabel + ')';
      if comparisonOption = 7 then ChartFX1.SerLeg[0] := 'Analysis Name: ' + legendTxt1 + '; RDII Parameter: RDII Volume per Linear Feet (' + legendlabel + ')';
      if comparisonOption = 8 then ChartFX1.SerLeg[0] := 'Analysis Name: ' + legendTxt1 + '; RDII Parameter: Peak RDII Flow per Area (' + legendlabel + ')';

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


procedure TfrmCARDIIRankingGraph2.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//rm 2012-04-09 handled in formdestroy: ChartFX1.Free;
   //chartFX1.destroy;
end;

procedure TfrmCARDIIRankingGraph2.FormCreate(Sender: TObject);
begin

  FChartType := 0;
  ChartFX1:=TChartFX.Create(Self);
  //rm 2012-04-17
  lstScenarios := TStringList.Create;
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

procedure TfrmCARDIIRankingGraph2.FormDestroy(Sender: TObject);
begin
  ChartFX1.Free;
end;

procedure TfrmCARDIIRankingGraph2.FormResize(Sender: TObject);
begin
  try
  if  Assigned(ChartFX1) then begin
  //rm 2012-04-16 this is a valid reference to frmCAAnalysisChooser2 replaced with lstScenarios
  //if frmCAAnalysisChooser2.ScenarioToDisplayListBox.items.count = 1 then
  if lstScenarios.Count = 1 then
    begin
      if ClientWidth > 16 then
        ChartFX1.Width := ClientWidth - 16;
      if Clientheight > 16 then
        ChartFX1.Height := ClientHeight - 16;
    end
  else
    if (self.Visible) then begin
    ResizePanels;
  end;
  end;
  except on E: Exception do begin
      MessageDlg('Error in TfrmCARDIIRankingGraph2.FormResize! ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmCARDIIRankingGraph2.FormShow(Sender: TObject);
begin
  //this is where to direct the traffic: 1 plot vs. 3 plots.

  //rm 2012-04-16 this is a valid reference to frmCAAnalysisChooser2 replaced with lstScenarios
  //if frmCAAnalysisChooser2.ScenarioToDisplayListBox.items.count = 1 then
  if lstScenarios.Count = 1 then
    SingleGraphHandler()
  //else if frmCAAnalysisChooser2.ScenarioToDisplayListBox.items.count > 1 then
  else if lstScenarios.Count > 1 then
    MultiGraphsHandler();
    // Go to plot multiple graphs "Central"

{
  GraphsHorz := 1;
  GraphsVert := frmCAAnalysisChooser2.ScenarioToDisplayListBox.items.count;

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

procedure TfrmCARDIIRankingGraph2.GetAverageRValues(analysisName: string);
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
    //rm 2012-04-19 - I think we need to set totalR to zero here as well
    totalR := 0;
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

procedure TfrmCARDIIRankingGraph2.GetTotalRValue(analysisName: string);
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
  //rm 2012-04-19 - why not set totalR to zero here - in case there are no events
  totalR := 0;
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


procedure TfrmCARDIIRankingGraph2.GetAverageR2R3Value(analysisName: string);
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
        totalR := totalR + localRecSet.Fields.Item[2].Value + localRecSet.Fields.Item[3].Value;
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


procedure TfrmCARDIIRankingGraph2.GetPeakR2R3Value(analysisName: string);
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


procedure TfrmCARDIIRankingGraph2.GetPeakRValues(analysisName: string);
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
//MessageDlg(queryStr, mtInformation, [mbok], 0);
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



procedure TfrmCARDIIRankingGraph2.GetPeakR1_R2_R3Values(analysisName: string);
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
procedure TfrmCARDIIRankingGraph2.GetMedianRValues(analysisName: string);
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


procedure TfrmCARDIIRankingGraph2.GetMedianR1_R2_R3Values(analysisName: string);
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


procedure TfrmCARDIIRankingGraph2.GetMedianR2R3Value(analysisName: string);
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
//rm 2012-04-19 leave R1 out                inttostr(analysisID) + ') ORDER BY b.[R1]+ b.[R2] + b.[R3];';  // Group by sum of total R;';
                inttostr(analysisID) + ') ORDER BY b.[R2] + b.[R3];';  // Group by sum of total R;';
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
//rm 2012-04-19 - add to totalR here:
        totalR := totalR + localRecSet.Fields.Item[2].Value +
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


procedure TfrmCARDIIRankingGraph2.GetRDIIVolumePerSewerLength(analysisName: string);
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


procedure TfrmCARDIIRankingGraph2.GetRDIIPeakFlowPerArea(analysisName: string);
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


procedure TfrmCARDIIRankingGraph2.MultiGraphsHandler() ;
var
  i : integer;
  numOfCScenarios, numOfBars : integer;
  comparisonOption, comparisonStatsOption: integer;
  cScenarioID : integer;
  testing1 : string;
begin
  //rm 2012-04-16 this is a valid reference to frmCAAnalysisChooser2 replaced with lstScenarios
  //numOfCScenarios := frmCAAnalysisChooser2.ScenarioToDisplayListBox.items.count;
  numOfCScenarios := lstScenarios.Count;

  GraphsHorz := 1;
  GraphsVert := numOfCScenarios;

  CreatePanels();
  Resizepanels();

  //rm 2012-04-16 these are valid references to frmCAAnalysisChooser2
  for i := 0 to numOfCScenarios - 1 do begin
    //check number of sewershed in CScenario_X
    //check the CScenarioID
    numOfBars := DatabaseModule.GetNumofSubsewershedForComparisonScenarioName(
      //frmCAAnalysisChooser2.ScenarioToDisplayListBox.Items[i]);
      lstScenarios[i]);

    NumberOfBars[i] := numOfBars;

    cScenarioID := DatabaseModule.GetComparisonScenarioIDForName(
      //frmCAAnalysisChooser2.ScenarioToDisplayListBox.Items[i]);
      lstScenarios[i]);
    comparisonOption := DatabaseModule.GetComparisonOptionForComparisonScenarioName(
      //frmCAAnalysisChooser2.ScenarioToDisplayListBox.Items[i]);
      lstScenarios[i]);
    comparisonStatsOption := DatabaseModule.GetComparisonStatsOptionForComparisonScenarioName(
      //frmCAAnalysisChooser2.ScenarioToDisplayListBox.Items[i]);
      lstScenarios[i]);

    InitializeParameters(numOfBars,cScenarioID);
    //DataPrep(cScenarioID,frmCAAnalysisChooser2.ScenarioToDisplayListBox.Items[i],comparisonOption,comparisonStatsOption,numOfBars);
    //FillingMultipleGraphs(i+1, numOfBars, comparisonOption, comparisonStatsOption, frmCAAnalysisChooser2.ScenarioToDisplayListBox.Items[i]);
    DataPrep(cScenarioID,lstScenarios[i],comparisonOption,comparisonStatsOption,numOfBars);
    FillingMultipleGraphs(i+1, numOfBars, comparisonOption, comparisonStatsOption, lstScenarios[i]);
    //Fill MultipleGraph (whichGraph)
  end;
end;


procedure TfrmCARDIIRankingGraph2.SavetoText1Click(Sender: TObject);
var sFilename, s,v: string;
    F: TextFile;
    i,j,k: integer;
begin
//rm 2012-04-17 export to text file (*.txt)
  s := '';
  if SaveTextFileDialog1.Execute then begin
    sFilename := SaveTextFileDialog1.FileName;
    AssignFile(F, sFilename);
    Rewrite(F);
    Writeln(F, self.Caption);
    if lstScenarios.Count = 1 then begin
      i := 0;
      s := 'Scenario = ' + lstScenarios[i];
      WriteLn(F, s);
      s := 'Y Parameter = ' + ChartFX1.Axis[AXIS_Y].Title;
      WriteLn(F, s);

      for j := 0 to ChartFX1.Series.Count - 1 do begin
          s := ChartFX1.SerLeg[j];
          WriteLn(F, s);
        for k := 0 to NumberOfBars[i] - 1 do begin

          s := ChartFX1.Axis[AXIS_X].Label_[k];
          //WriteLn(F, s);
          v := floattostr(ChartFX1.ValueEX[j, k]);
          //WriteLn(F, s);
          WriteLn(F, s + ' = ' + v);

        end;
      end;

    end else begin

    for i := 0 to lstScenarios.Count -1 do begin
      s := 'Scenario = ' + lstScenarios[i];
      WriteLn(F, s);
      s := 'Y Parameter = ' + Graphs[0,i].Axis[AXIS_Y].Title;
      WriteLn(F, s);

      for j := 0 to Graphs[0,i].Series.Count - 1 do begin
          s := Graphs[0,i].SerLeg[j];
          WriteLn(F, s);
        for k := 0 to NumberOfBars[i] - 1 do begin

          s := Graphs[0,i].Axis[AXIS_X].Label_[k];
          //WriteLn(F, s);
          v := floattostr(Graphs[0,i].ValueEX[j, k]);
          //WriteLn(F, s);
          WriteLn(F, s + ' = ' + v);

        end;
      end;
    end;

    end;

    CloseFile(F);
    messagedlg('Done exporting to ' + sFilename, mtInformation, [mbok], 0);
  end;
end;

procedure TfrmCARDIIRankingGraph2.SingleGraphHandler() ;
var
  i,j : integer;
  numOfBars : integer;
  comparisonOption, comparisonStatsOption: integer;
  cScenarioID : integer;
  testing1 : string;
begin

  //GraphsHorz := 1;
  //GraphsVert := 1;

  //CreatePanels();
  //Resizepanels();
  //rm 2012-04-16 make sure any existing panels are not visible
  for i := 0 to GraphsHorz - 1 do begin
    for j := 0 to GraphsVert - 1 do begin
      Panels[i,j].Visible := false;
    end;
  end;

  numOfBars := DatabaseModule.GetNumofSubsewershedForComparisonScenarioName(
    //frmCAAnalysisChooser2.ScenarioToDisplayListBox.Items[0]);
    lstScenarios[0]);
  //rm 2012-04-16
  NumberOfBars[0] := numOfBars;
  if (numOfBars = 0) then begin

    messagedlg('Warning: Number of  Sewersheds in Scenario ' + lstScenarios[0] + ' = 0', mtWarning, [mbok], 0);

  end;// else begin

    cScenarioID := DatabaseModule.GetComparisonScenarioIDForName(
      //frmCAAnalysisChooser2.ScenarioToDisplayListBox.Items[0]);
      lstScenarios[0]);
    comparisonOption := DatabaseModule.GetComparisonOptionForComparisonScenarioName(
      //frmCAAnalysisChooser2.ScenarioToDisplayListBox.Items[0]);
      lstScenarios[0]);
    comparisonStatsOption := DatabaseModule.GetComparisonStatsOptionForComparisonScenarioName(
      //frmCAAnalysisChooser2.ScenarioToDisplayListBox.Items[0]);
      lstScenarios[0]);
    InitializeParameters(numOfBars,cScenarioID);
    //DataPrep(cScenarioID,frmCAAnalysisChooser2.ScenarioToDisplayListBox.Items[0],comparisonOption,comparisonStatsOption,numOfBars);
    //FillingSingleGraph(numOfBars, comparisonOption, comparisonStatsOption, frmCAAnalysisChooser2.ScenarioToDisplayListBox.Items[0]);
    DataPrep(cScenarioID,lstScenarios[0],comparisonOption,comparisonStatsOption,numOfBars);
    FillingSingleGraph(numOfBars, comparisonOption, comparisonStatsOption, lstScenarios[0]);
  //end;
end;

end.
