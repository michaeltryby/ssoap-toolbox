unit mainform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, jpeg, ADODB_TLB, DBTables, Db, Variants, ExtActns,
  Registry, StrUtils, ActnList, ShellAPI, StdCtrls, Hotspot
  {$IFDEF VER140 }  {$ENDIF};


const
    //rm 2009-10-15 incrementing requiredDatabaseVersion to accommodate new field in
    //Meters table - the AreaUnitID
    //To convert a SSOAP database from Version 5 to Version 6:
    //  Add a numeric (Integer) field named AreaUnitID to the Meters table
    //  and set the field value to 1 for every existing record
    //then change the value of Databaseversion in the Metadata table to 6.
    //requiredDatabaseVersion = 5;   //SSOAP Toolbox Version 1.0
    //requiredDatabaseVersion = 6;   //SSOAP Toolbox Version 1.0.1
    //requiredDatabaseVersion = 7;   //SSOAP Toolbox Version 1.0.2f
    //requiredDatabaseVersion = 8;   //SSOAP Toolbox Version 1.0.2g
    requiredDatabaseVersion = 9;   //SSOAP Toolbox Version 1.0.2j
type
  TfrmMain = class(TForm)
    OpenDatabaseDialog: TOpenDialog;
    NewDatabaseDialog: TSaveDialog;
    Image1: TImage;
    SaveDialog1: TSaveDialog;
    OpenDialogSWMM5InpFile: TOpenDialog;
    MainMenu2: TMainMenu;
    MenuItemFile: TMenuItem;
    MenuItemFileNew: TMenuItem;
    MenuItemFileOpen: TMenuItem;
    MenuItemFileClose: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItemFileExit: TMenuItem;
    MenuItemDataManagementTool: TMenuItem;
    MenuItemUtilities: TMenuItem;
    MenuItemFillInMissingFlowData: TMenuItem;
    MenuItemFlowScatterPlot: TMenuItem;
    MenuItemRainfallDataReview: TMenuItem;
    MenuItemRainfallDataAnalysis: TMenuItem;
    MenuItemHolidays: TMenuItem;
    MenuItemRDIIAnalysisTool: TMenuItem;
    MenuItemAnalysisManagement: TMenuItem;
    MenuItemDWFAnalysis: TMenuItem;
    MenuItemAutomaticDWFDay: TMenuItem;
    MenuItemManualWeekdayDWFDayRemoval: TMenuItem;
    MenuItemManualWeekendDWFDayRemoval: TMenuItem;
    MenuItem51: TMenuItem;
    MenuItemViewDryWeatherHydrographs: TMenuItem;
    MenuItemViewDryWeatherFlowStatistics: TMenuItem;
    MenuItemIDMinimumNighttimeFlows: TMenuItem;
    MenuItemWWFAnalysis: TMenuItem;
    MenuItemAutoGWIAdjustment: TMenuItem;
    MenuItemGWIAdjuctmentTable: TMenuItem;
    MenuItem58: TMenuItem;
    MenuItemAutoRDIIEventID: TMenuItem;
    MenuItemRDIIEventTable: TMenuItem;
    MenuItemExportRDIIEvents: TMenuItem;
    MenuItemImportRDIIEvents: TMenuItem;
    MenuItem63: TMenuItem;
    MenuItemRDIIEventStatistics: TMenuItem;
    MenuItemRainfallIntensityStatistics: TMenuItem;
    MenuItemSimulatedvsObservedRDII: TMenuItem;
    MenuItem67: TMenuItem;
    MenuItemWriteAllFlows: TMenuItem;
    MenuItemWriteDailyAverageFlows: TMenuItem;
    MenuItemRDIIGraph: TMenuItem;
    MenuItemStatisticalAnalysis: TMenuItem;
    MenuItemMedianAverageRAnalysis: TMenuItem;
    MenuItemLinearRegression: TMenuItem;
    MenuItemHydrographGenerationTool: TMenuItem;
    MenuItemScenarioManagement: TMenuItem;
    MenuItemScenarioSetup: TMenuItem;
    MenuItemScenarioComparison: TMenuItem;
    MenuItemRTKPatternManagement2: TMenuItem;
    MenuItemRTKPatternAssignment: TMenuItem;
    MenuItemRDIIHydrographGeneration: TMenuItem;
    MenuItemSWMM5InterfacingTool: TMenuItem;
    MenuItemExport2SWMM5: TMenuItem;
    MenuItemSWMM5ExportHydrographSections: TMenuItem;
    MenuItemSWMM5ExportInterfaceFile: TMenuItem;
    MenuItemRunSWMM5: TMenuItem;
    MenuItemSWMM5LaunchInterface: TMenuItem;
    MenuItemSWMM5RunEngine: TMenuItem;
    MenuItemImportFromSWMM5: TMenuItem;
    MenuItemSWMM5ImportHydrograph: TMenuItem;
    MenuItemSWMM5ImportOutput: TMenuItem;
    MenuItemHelp: TMenuItem;
    MenuItemHelpContents: TMenuItem;
    MenuItemHelpSearch: TMenuItem;
    MenuItemHelpHowTo: TMenuItem;
    MenuItemHelpAbout: TMenuItem;
    MenuItem97: TMenuItem;
    MenuItemHelpSendFeedback: TMenuItem;
    MenuItem99: TMenuItem;
    MenuItemFlowMonitorData: TMenuItem;
    MenuItemRainfallData: TMenuItem;
    MenuItemSewershedData: TMenuItem;
    MenuItemRDIIAreaData: TMenuItem;
    MenuItemRTKPatternData: TMenuItem;
    MenuItemFlowMonitorManagement: TMenuItem;
    MenuItemFlowMonitorConverterSetup: TMenuItem;
    MenuItemFlowMonitorImport: TMenuItem;
    MenuItemFlowMonitorExport: TMenuItem;
    MenuItemRainfallManagement: TMenuItem;
    MenuItemRainfallConverterSetup: TMenuItem;
    MenuItemRainfallImport: TMenuItem;
    MenuItemRainfallExport: TMenuItem;
    MenuItemSewershedManagement: TMenuItem;
    MenuItemSewershedConverterSetup: TMenuItem;
    MenuItemSewershedImport: TMenuItem;
    MenuItemSewershedExport: TMenuItem;
    MenuItemRDIIAreaManagement: TMenuItem;
    MenuItemRDIIAreaConverterSetup: TMenuItem;
    MenuItemRDIIAreaImport: TMenuItem;
    MenuItemRDIIAreaExport: TMenuItem;
    MenuItemRTKPatternManagement: TMenuItem;
    MenuItemRTKPatternConverterSetup: TMenuItem;
    MenuItemRTKPatternImport: TMenuItem;
    MenuItemRTKPatternExport: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    PopupMenuHotSpot: TPopupMenu;
    N18: TMenuItem;
    MenuItemRainfallConvertTimestep: TMenuItem;
    MenuItemVisitEPASSOWebsite: TMenuItem;
    MenuItemLinktoTechnicalReport: TMenuItem;
    N1: TMenuItem;
    ColorDialog1: TColorDialog;
    ConfigureSSOsandJunctionDepthTimeseries1: TMenuItem;
    Graphs1: TMenuItem;
    DataImportLog1: TMenuItem;
    Image4: TImage;
    MenuItemSupportforMultipleVariableRegression: TMenuItem;
    FlowDataReview1: TMenuItem;
    MenuItemConditionAssessmentTool: TMenuItem;
    MenuItemConditionAnalysis: TMenuItem;
    RehabAnalysisManagement: TMenuItem;
    PreandPostRehabilitationAnalysis1: TMenuItem;
    RDIIPrioritizationAnalysis1: TMenuItem;
    RDIIPrioritizationAnalysisSetupScenarioSetup1: TMenuItem;
    RDIIPrioritizationAnalyze1: TMenuItem;
    procedure testoldroutine1Click(Sender: TObject);
    procedure RDIIPrioritizationAnalyze1Click(Sender: TObject);
    procedure RDIIPrioritizationAnalysisSetupScenarioSetup1Click(
      Sender: TObject);
    procedure PreandPostRehabilitationAnalysis1Click(Sender: TObject);
    procedure RehabAnalysisManagementClick(Sender: TObject);
    procedure MenuItemRDIIRankingClick(Sender: TObject);
    procedure MenuItemSingleVariableRegressionClick(Sender: TObject);
    procedure MenuItemConditionAnalysisBreakpointAnalysisClick(Sender: TObject);
    procedure MenuItemConditionAnalysisRDIIComparisonClick(Sender: TObject);
    procedure MenuItemConditionAnalysisClick(Sender: TObject);
    procedure MenuItemSupportforMultipleVariableRegressionClick(Sender: TObject);
    procedure DVScatterGraph1Click(Sender: TObject);
    procedure FlowConverterManagement1Click(Sender: TObject);
    procedure RainConverterManagement1Click(Sender: TObject);
    procedure UsingConverter1Click(Sender: TObject);
    procedure UsingConverter2Click(Sender: TObject);
    procedure RainUnitManagement1Click(Sender: TObject);
    procedure FlowUnitManagement1Click(Sender: TObject);
    procedure RemoveDaysAutomatically1Click(Sender: TObject);
    procedure RemoveWeekendsManually1Click(Sender: TObject);
    procedure RemoveWeekdaysManually1Click(Sender: TObject);
    procedure AutomaticEventIdentification1Click(Sender: TObject);
    procedure EventTable1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure OpenDatabase1Click(Sender: TObject);
    procedure CloseDatabase1Click(Sender: TObject);
    procedure MeterDatabaseLogin(Database: TDatabase;LoginParams: TStrings);
    procedure CONFile1Click(Sender: TObject);
    procedure FillInMissingFlowData1Click(Sender: TObject);
    procedure ViewA1Click(Sender: TObject);
    procedure ConvertTimeStep1Click(Sender: TObject);
    procedure AnalysisManagement1Click(Sender: TObject);
    procedure GWIAdjustmentTable1Click(Sender: TObject);
    procedure IIGraph1Click(Sender: TObject);
    procedure ASCIIFormat1Click(Sender: TObject);
    procedure MMADYSummary1Click(Sender: TObject);
    procedure EditMeters1Click(Sender: TObject);
    procedure FlowMeterManagement1Click(Sender: TObject);
    procedure RaingaugeManagement1Click(Sender: TObject);
    procedure CONFile3Click(Sender: TObject);
    procedure FreeFormASCII1Click(Sender: TObject);
    procedure AutomaticGWIAdjustmentCalculation1Click(Sender: TObject);
    procedure IdentifyMinimumNighttimeFlowsClick(Sender: TObject);
    procedure EventStatistics1Click(Sender: TObject);
    procedure WriteAllFlows1Click(Sender: TObject);
    procedure WriteDailyFlows1Click(Sender: TObject);
    procedure NewDatabase1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExportEvents1Click(Sender: TObject);
    procedure ImportEvents1Click(Sender: TObject);
    procedure RainfallIntensityStatistics1Click(Sender: TObject);
    procedure CalculatedvsSimulatedRDIISummaryStatistics1Click(
      Sender: TObject);
    procedure ViewDryWeatherFlowStatistics1Click(Sender: TObject);
    procedure Contents1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RDIIConverterManagement1Click(Sender: TObject);
    procedure UsingConverter3Click(Sender: TObject);
    procedure SewershedManagement1Click(Sender: TObject);
//rm 2010-10-07    procedure RDIIHydrograph1Click(Sender: TObject);
    procedure RainfallAnalysis1Click(Sender: TObject);
    procedure MediumRvalues1Click(Sender: TObject);
    procedure LinearRegression1Click(Sender: TObject);
    procedure testingClick(Sender: TObject);
    procedure FlowMonitoringData1Click(Sender: TObject);
    procedure RainfallData1Click(Sender: TObject);
    procedure SanitarySewerSystemData1Click(Sender: TObject);
    procedure CreateaFlowMonitor1Click(Sender: TObject);
    procedure CreateaRainGage1Click(Sender: TObject);
    procedure CreateSewershed1Click(Sender: TObject);
    procedure FlowMonitoringData2Click(Sender: TObject);
    procedure RainfallData2Click(Sender: TObject);
    procedure SanitarySewerSystemData2Click(Sender: TObject);
    procedure FlowMonitoringData3Click(Sender: TObject);
    procedure RainfallData3Click(Sender: TObject);
    procedure ScenarioSetup1Click(Sender: TObject);
    procedure Postprocessing1Click(Sender: TObject);
    procedure ScenarioComparison1Click(Sender: TObject);
    procedure Preprocessing1Click(Sender: TObject);
    procedure RainfallDataAnalysis1Click(Sender: TObject);
    procedure Fill1Click(Sender: TObject);
    procedure DepthvsVelocityScatterPlot1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SewershedData2Click(Sender: TObject);
    procedure SewershedData1Click(Sender: TObject);
    procedure RainfallDataReview1Click(Sender: TObject);
    procedure DepthvsFlowScatterPlot1Click(Sender: TObject);
    procedure RDIIAreaSetup1Click(Sender: TObject);
    procedure RDIIAreaData2Click(Sender: TObject);
    procedure RDIIAreaData1Click(Sender: TObject);
    procedure testmenuClick(Sender: TObject);
    procedure RDIIPatternAdjustment1Click(Sender: TObject);
    procedure RDIIPatternAssignment1Click(Sender: TObject);
    procedure RDIIExport1Click(Sender: TObject);
    procedure RTKPatternSetup1Click(Sender: TObject);
    procedure RTKPatternData1Click(Sender: TObject);
    procedure RTKPatternData2Click(Sender: TObject);
    procedure RTKPatterns1Click(Sender: TObject);
    procedure RDIIHydrographs1Click(Sender: TObject);
    procedure LaunchSWMM51Click(Sender: TObject);
    procedure RunSWMM5dll1Click(Sender: TObject);
    procedure SWMM5RDIIHydrographSection1Click(Sender: TObject);
    procedure RTKPatternAssignment1Click(Sender: TObject);
    procedure SendMail1Hint(var HintStr: string; var CanShow: Boolean);
    procedure Feedback1Click(Sender: TObject);
    procedure Holidays1Click(Sender: TObject);
    procedure MenuItemVisitEPASSOWebsiteClick(Sender: TObject);
    procedure MenuItemLinktoTechnicalReportClick(Sender: TObject);
    procedure MenuItemSecondOrderRegressionClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure ConfigureSSOsandJunctionDepthTimeseries1Click(Sender: TObject);
    procedure DataImportLog1Click(Sender: TObject);
    procedure FlowDataReview1Click(Sender: TObject);
  private { Private declarations }
    FChartRGBBK, FChartRGBText, FChartRGBFlow, FChartRGBRain, FChartRGBYell, FChartRGBGree:
      Array[0..1] of TColor;
    FChartLineWidth: Array[0..1] of Integer;
    startupDirectory: string;
    FColorScheme: integer;
    hotspots: Array[0..11] of THotSpot;
    function GetEPASwmm5Folder: string;
    procedure OpenDatabase(filename: string);
    procedure CloseDatabase();
    procedure enableMenusAfterOpeningDatabase();
    procedure ExecuteSWMM5;
    function GetChartRGBBK: TColor;
    procedure SetColorScheme(const Value: integer);
    function GetChartRGBFlow: TColor;
    function GetChartRGBRain: TColor;
    function GetChartRGBText: TColor;
    function GetChartRGBYell: TColor;
    function GetChartRGBGree: TColor;
    function GetChartLineWidth: Integer;
    function GetRainGaugeCount: Integer;
    function GetSewerShedCount: Integer;
    Function GetFlowMeterCount: Integer;
    function GetRDIIAreaCount: Integer;
    Function GetRTKPatternCount: Integer;
    Function GetScenarioCount: Integer;
    function GetAnalysisCount: integer;
    procedure SetHotSpot(hotspType:string;num1:integer;num2:integer);

  public { Public declarations }
    fname: string;
    connection: _Connection;
    connectionString: string;
    FSWMM5InpFileName: string;
    FSWMM5InpFileName2: string;
    FRainGaugeName: string;
    FFlowUnitLabel: string;
    FScenarioID, FRainGaugeID: integer;
    FStart, FEnd: TDateTime;
    //rm 2012-11-16 const TechReportPDFLink = 'http://www.epa.gov/nrmrl/pubs/600r07111/600r07111.pdf';
    const TechReportPDFLink = 'http://nepis.epa.gov/Exe/ZyPURL.cgi?Dockey=P1008BBP.txt';
    procedure ToggleChartColors;
    property ChartRGBBK: TColor read GetChartRGBBK;
    property ChartRGBText: TColor read GetChartRGBText;
    property ChartRGBFlow: TColor read GetChartRGBFlow;
    property ChartRGBRain: TColor read GetChartRGBRain;
    property ChartRGBYell: TColor read GetChartRGBYell;
    property ChartRGBGree: TColor read GetChartRGBGree;
    property ChartLineWidth: Integer read GetChartLineWidth;
    property iColorScheme: integer read FColorScheme write SetColorScheme;
    procedure SetupMenuItemsforIndex(menuitems: Array  of TMenuItem);
    procedure RunSWMM5Interface(sFileName: string);
    procedure HelpHandler_Universal(Sender: TObject);
  end;


var
  frmMain: TfrmMain;

implementation

uses importflowdata, flowconvertermanager, rainconvertermanager,
  importraindata, flowunitmanager, rainunitmanager, autodayremoval,
  automaticeventdef, fillinmissingdata, convertraintimestep,
  onegraph, dryweatherhydrographs, scattergraph, iigraph, importflowdatafromCONfile,
  exportprntflowcsv, exportmaxminavgflow, flowmetermanager, raingaugemanager,
  importrainfalldatafromCONfile, exportprntraintabular, analysismanager,
  automaticgwiadjcalc, chooseFlowMeter, MinimumNighttimeFlows, eventSummary,
  writeAllFlows, writeDailyAverageFlows, chooseAnalysis, modDatabase,
  eventExport, importevents, rainfallIntensityStatistics,
  computedVsSimulatedRDIISummaryStatistics, Hydrograph, feedbackWithMemo,
  rdiiutils, about, rdiiconvertermanager, importrdiidata,
  sewershedmanager,hydrographGeneration,RainfallCharacteristicAnalysis,
  statisticalRDIIanalysisThread, chooseLinearRegressionMethod,
  LinearRegressionAnalysis,DvsVselector,scenarioManager,SWMM5resultsImport1,SWMM5resultsImport2,
  ScenarioComparison, SW5InterFaceFile, sewershedconvertermanager, importsewersheddata,
  GWIAdjustmentsTable, EventsTable, RainfallDataReview,
  catchmentconvertermanager, catchmentmanager, importcatchmentdata,
  HydrographGeneration2, RDIIExport, RDIIPatterns, RDIIPatternAssignment,
  rtkpatternmanager, RTKPatternConverterManager, ImportRTKPatternData,
  ExportRDIIHydrographs,swmm5rdiireaderthread,
  newscenario, SelectScenariotoLaunchRTKAssignment,
  HolidayTableForm, SWMM5_RDIIImporterForm, DataImportLogForm, 
  statisticalInformationForMultiRegressionThread, FlowMonGraphForm, CAmanager,
  chooseCA, chooseCALinearRegression, StormEventCollection, EventStatGetter,
  CAAnalysisChooser, CARDIIRankingGraph, CAAnalysisSetup, CAAnalysisChooser2,
  CARDIIRankingGraph2;

{$R *.DFM}


procedure TfrmMain.FlowConverterManagement1Click(Sender: TObject);
begin
  frmFlowConverterManagement.ShowModal;
  {on exit from flow converter configuration, update the menu availability}
  if (DatabaseModule.GetFlowConverterNames.Count > 0)
    then MenuItemFlowMonitorImport.Enabled := True
    else MenuItemFlowMonitorImport.Enabled := False;
end;

procedure TfrmMain.FlowDataReview1Click(Sender: TObject);
begin
  while (frmFlowMeterSelector.ShowModal = mrOk) do begin
    frmFlowMonGraph.ShowModal;
  end;
end;

procedure TfrmMain.RainConverterManagement1Click(Sender: TObject);
begin
  frmRainConverterManagement.ShowModal;
  {on exit from rainfall converter configuration, update the menu availability}
  if (DatabaseModule.GetRainConverterNames.Count > 0)
    then MenuItemRainfallImport.Enabled := True
    else MenuItemRainfallImport.Enabled := False;
end;

procedure TfrmMain.UsingConverter1Click(Sender: TObject);
begin
  frmImportFlowDataUsingConverter.ShowModal
end;

procedure TfrmMain.UsingConverter2Click(Sender: TObject);
begin
  frmImportRainDataUsingConverter.ShowModal;
end;

procedure TfrmMain.UsingConverter3Click(Sender: TObject);
begin
  frmImportRdiiDataUsingConverter.ShowModal
end;

procedure TfrmMain.RainUnitManagement1Click(Sender: TObject);
begin
  frmRainUnitManagement.ShowModal;
end;

procedure TfrmMain.RDIIConverterManagement1Click(Sender: TObject);
begin
  frmRdiiConverterManagement.ShowModal;
  {on exit from RDII configuration, update the menu availability}
  {flowMetersDefined := DatabaseModule.GetFlowMeterNames.Count > 0;
  rainGaugesDefined := DatabaseModule.GetRaingaugeNames.Count > 0;
  if (rainGaugesDefined) then begin
    ImportRainData1.Enabled := True;
    ExportRainData1.Enabled := True;
    ConvertTimeStep1.Enabled := True;
    if (flowMetersDefined)
      then AnalysisManagement1.Enabled := True
      else AnalysisManagement1.Enabled := False;
  end
  else begin
    ImportRainData1.Enabled := False;
    ExportRainData1.Enabled := False;
    ConvertTimeStep1.Enabled := False;
    AnalysisManagement1.Enabled := False;
  end;}
end;

procedure TfrmMain.RDIIExport1Click(Sender: TObject);
begin
//present user with form to export RDII hydrographs in SWM5 format
    frmRDIIExport.ShowModal;
end;

{
//rm 2010-10-07
procedure TfrmMain.RDIIHydrograph1Click(Sender: TObject);
begin
//  frmHydrographGeneration.ShowModal;
  frmHydrographGeneration2.ShowModal;

end;
}

procedure TfrmMain.RDIIHydrographs1Click(Sender: TObject);
begin
      FScenarioID := -1;
      frmScenarioManagement.SetDialogMode(2);
      frmScenarioManagement.Caption := 'Please select a Scenario';
      frmScenarioManagement.ShowModal;
      FScenarioID := frmScenarioManagement.SelectedScenarioID;
      if FScenarioID < 0 then begin
        MessageDlg('Please select a scenario to export.',
        mtError,[mbOK],0);
      end else begin
        //FStart :=
        //FEnd :=
        //frmFeedbackWithMemo.Caption := 'SWMM5 Input File RDII HYDROGRAPH Section Export';
        //SWMM5RDIISectionWriterThread.CreateIt;
        //frmFeedbackWithMemo.OpenForProcessing;
  frmExportRDIIHydrographs.ScenarioID := FScenarioID;
  frmExportRDIIHydrographs.RainGaugeID := FRainGaugeID;
//  frmExportRDIIHydrographs.StartDate :=
//    StartDatePicker.Date + frac(StartTimePicker.Time);
//  frmExportRDIIHydrographs.EndDate :=
//    EndDatePicker.Date + frac(EndTimePicker.Time);

  frmExportRDIIHydrographs.ShowModal;
      end;

end;

procedure TfrmMain.RDIIPatternAdjustment1Click(Sender: TObject);
begin
//present user with form to adjust RDII RTK patterns
  frmRDIIPatterns.ShowModal;
end;

procedure TfrmMain.RDIIPatternAssignment1Click(Sender: TObject);
begin
//present user with form to assign RDII RTK patterns to areas
  frmRDIIPatternAssignment.ShowModal;
end;

procedure TfrmMain.RDIIPrioritizationAnalysisSetupScenarioSetup1Click(
  Sender: TObject);
var mr: integer;
begin
//Steps 1 - 3 in RDII Prioritization Analysis
  frmCAAnalysisSetup.InitializeLists;
  //mr := mrOK;
  //while mr = mrOK do begin
    //frmCAAnalysisChooser.InitializeLists;
    mr := frmCAAnalysisSetup.ShowModal;
    //if (mr = mrOK) then begin
    //  // if multiple scenario selected - goto this is .pas/.dfm designed for 2/3 graphs
    //  frmCARDIIRankingGraph.ShowModal;
    //  // if single scenario selected - goto this .pas/.dfm designed for single graph only
    //end;
  //end;
end;

procedure TfrmMain.RDIIPrioritizationAnalyze1Click(Sender: TObject);
var i, mr: integer;
begin
//Steps 4 - 5 in RDII Prioritization Analysis
//note that this routine uses frmCAAnalysisChooser2 and frmCARDIIRankingGraph2
//rank analyses by RDII
  Application.CreateForm(TfrmCAAnalysisChooser2, frmCAAnalysisChooser2);
  try
  frmCAAnalysisChooser2.InitializeLists;
  mr := mrOK;
  while mr = mrOK do begin
    //frmCAAnalysisChooser.InitializeLists;
    mr := frmCAAnalysisChooser2.ShowModal;
    if (mr = mrOK) then begin
      // if multiple scenario selected - goto this is .pas/.dfm designed for 2/3 graphs
      //rm 2012-04-17 - check for error where no scenarios are selected
      if frmCAAnalysisChooser2.ScenarioToDisplayListBox.Count > 0 then begin
        Application.CreateForm(TfrmCARDIIRankingGraph2, frmCARDIIRankingGraph2);
        try
          //frmCARDIIRankingGraph2.
          //rm 2012-04-17 - make it so frmCARDIIRankingGraph2 does not have to read from frmCAAnalysisChooser2
          for i := 0 to frmCAAnalysisChooser2.ScenarioToDisplayListBox.Count - 1 do
            frmCARDIIRankingGraph2.lstScenarios.Add(frmCAAnalysisChooser2.ScenarioToDisplayListBox.Items[i]);
          frmCARDIIRankingGraph2.ShowModal;
        finally
          FreeAndNil(frmCARDIIRankingGraph2);
        end;
      end else begin
        messagedlg('No Scenario Selected!', mtError, [mbok], 0);
      end;
      //frmCARDIIRankingGraph2.Free;
      // if single scenario selected - goto this .pas/.dfm designed for single graph only
    end;
  end;
  finally
    FreeAndNil(frmCAAnalysisChooser2);
  end;
  //frmCAAnalysisChooser2.Free;
end;

procedure TfrmMain.FlowUnitManagement1Click(Sender: TObject);
begin
  frmFlowUnitManagement.ShowModal;
end;

procedure TfrmMain.RehabAnalysisManagementClick(Sender: TObject);
begin
  frmCAManagement.ShowModal;
end;

procedure TfrmMain.RemoveDaysAutomatically1Click(Sender: TObject);
begin
  frmAutomaticDayRemoval.ShowModal;
end;

procedure TfrmMain.RemoveWeekendsManually1Click(Sender: TObject);
begin
//  if (frmFlowMeterSelector.ShowModal = mrOK) then frmManualDWFDaySelection.ShowWeekends;
//  frmFlowMeterSelector.LabelProcessName.Caption := 'Manual Weekday DWF Day Removal';
  frmFlowMeterSelector.Caption :=
    stringreplace((Sender as TMenuItem).Caption, '&', '', [rfReplaceAll, rfIgnoreCase]);
  while (frmFlowMeterSelector.ShowModal = mrOK) do frmManualDWFDaySelection.ShowWeekends;
end;

procedure TfrmMain.RTKPatternAssignment1Click(Sender: TObject);
var numScenarios: integer;
begin
//call up the scenario editor part that has the RTK Pattern Assignment
  frmSelScenario4RTKAssignment.ShowModal;
  numScenarios := GetScenarioCount;
end;

procedure TfrmMain.RTKPatternData1Click(Sender: TObject);
begin
//Define the attributes of a RTK Pattern Data Converter
  frmRTKPatternConverterManager.ShowModal;
  MenuItemRTKPatternImport.Enabled := (DatabaseModule.GetRTKPatternConverterNames.Count > 0)
end;

procedure TfrmMain.RTKPatternData2Click(Sender: TObject);
var numRTKPatterns: integer;
begin
//Import RTK Pattern Data Using a RTKPattern Data onverter
  frmImportRTKPatternData.ShowModal;
  numRTKPatterns := GetRTKPatternCount;
end;

procedure TfrmMain.RTKPatterns1Click(Sender: TObject);
var
  sFileName: string;
begin
  SaveDialog1.Filter := '*.CSV|*.CSV';
  SaveDialog1.DefaultExt := 'CSV';
  SaveDialog1.Title := 'Save as';
  if SaveDialog1.Execute then begin
    sFileName := SaveDialog1.FileName;
    if DatabaseModule.ExportRTKPatterns2CSV(sFileName) then
      messagedlg('Exported RTK Patterns to ' + sFileName,mtInformation,[mbok],0)
    else
      messagedlg('An error ocurred exporting to ' + sFileName,mtError,[mbok],0);
  end;
end;

procedure TfrmMain.RTKPatternSetup1Click(Sender: TObject);
var num: integer;
begin
  frmRTKPatternManager.ShowModal;
  num := GetRTKPatternCount;
end;

procedure TfrmMain.RunSWMM5dll1Click(Sender: TObject);
begin
//run the simulation using the SWMM5 exe
  ExecuteSWMM5;
end;

procedure TfrmMain.SanitarySewerSystemData1Click(Sender: TObject);
begin
  frmRdiiConverterManagement.ShowModal;
  {on exit from RDII configuration, update the menu availability}
  {flowMetersDefined := DatabaseModule.GetFlowMeterNames.Count > 0;
  rainGaugesDefined := DatabaseModule.GetRaingaugeNames.Count > 0;
  if (rainGaugesDefined) then begin
    ImportRainData1.Enabled := True;
    ExportRainData1.Enabled := True;
    ConvertTimeStep1.Enabled := True;
    if (flowMetersDefined)
      then AnalysisManagement1.Enabled := True
      else AnalysisManagement1.Enabled := False;
  end
  else begin
    ImportRainData1.Enabled := False;
    ExportRainData1.Enabled := False;
    ConvertTimeStep1.Enabled := False;
    AnalysisManagement1.Enabled := False;
  end;}
end;

procedure TfrmMain.SanitarySewerSystemData2Click(Sender: TObject);
begin
  frmImportRdiiDataUsingConverter.ShowModal

end;

procedure TfrmMain.ScenarioComparison1Click(Sender: TObject);
begin
  frmScenarioComparison.ShowModal;
end;

procedure TfrmMain.ScenarioSetup1Click(Sender: TObject);
begin
  frmScenarioManagement.SetDialogMode(1);
  frmScenarioManagement.ShowModal;
end;

procedure TfrmMain.SendMail1Hint(var HintStr: string; var CanShow: Boolean);
begin
  HintStr := 'Send Feedback';
end;

procedure TfrmMain.SetColorScheme(const Value: integer);
begin
  FColorScheme := Value;
end;


procedure TfrmMain.SewershedData1Click(Sender: TObject);
var numSewerSheds: integer;
begin
//Import Sewershed Data Using a Sewershed Data onverter
  frmImportSewerShedDataUsingConverter.ShowModal;
  numSewerSheds := GetSewerShedCount;
end;

procedure TfrmMain.SewershedData2Click(Sender: TObject);
begin
//Define the attributes of a Sewershed Data Converter
  frmSewerShedConverterManagement.ShowModal;
  MenuItemSewershedImport.Enabled := (DatabaseModule.GetSewerShedConverterNames.Count > 0);
end;

procedure TfrmMain.SewershedManagement1Click(Sender: TObject);
var numSewerSheds: integer;
begin
  frmSewershedManagement.ShowModal;
  numSewerSheds := GetSewerShedCount;
end;

procedure TfrmMain.MenuItemSingleVariableRegressionClick(Sender: TObject);
begin
  frmCAChooseLinearRegression.ShowModal;

end;

procedure TfrmMain.MenuItemSupportforMultipleVariableRegressionClick(Sender: TObject);
begin
  frmAnalysisSelector.Caption :=
    stringreplace((Sender as TMenuItem).Caption, '&', '', [rfReplaceAll, rfIgnoreCase]);
  while (frmAnalysisSelector.ShowModal = mrOK) do begin
//  if (frmAnalysisSelector.ShowModal = mrOK) then begin

    statisticsForMultiRegressionThread.CreateIt;

    frmFeedbackWithMemo.Caption := 'Statistical Information To Support Multiple Varialbles Regression';
    frmFeedbackWithMemo.OpenForProcessing;

  end;

end;

procedure TfrmMain.SWMM5RDIIHydrographSection1Click(Sender: TObject);
//var numSewerSheds, numRDIIAreas: integer;
begin
  if OpenDialogSWMM5InpFile.Execute then begin
    FSWMM5InpFileName := OpenDialogSWMM5InpFile.FileName;
    FScenarioID := -1;
    frmScenarioManagement.Caption := 'Please select a Scenario';
    frmScenarioManagement.SetDialogMode(1); //select/create
    frmScenarioManagement.ShowModal;
    FScenarioID := frmScenarioManagement.SelectedScenarioID;
    if FScenarioID < 0 then begin
      MessageDlg('Please select or create a new scenario to associate with this input file.',
      mtError,[mbOK],0);
    end else begin
      Screen.Cursor := crHourglass;
      try
        frmFeedbackWithMemo.Caption := 'SWMM5 Input File RDII Import';
        //frmFeedbackWithMemo.OpenForProcessing;
{}
        SWMM5RDIISectionReaderThread.CreateIt;
        frmFeedbackWithMemo.OpenForProcessing;
{}
{
        frmSWMM5_RDIIImporter.FScenarioID:= FScenarioID;
        frmSWMM5_RDIIImporter.FSWMM5InpFileName:= FSWMM5InpFileName;
        frmSWMM5_RDIIImporter.ShowModal;
}
      finally
        Screen.Cursor := crDefault;
      end;
      //rm 2007-10-18 - ver 0.0.1.5 addition
      GetSewerShedCount;
      GetRainGaugeCount;
      GetFlowMeterCount;
      GetRTKPatternCount;
    end;
  end;
end;

procedure TfrmMain.testmenuClick(Sender: TObject);
begin
//  frmHydrographGeneration.ShowModal;
//   frmMenuItem.ShowModal;
end;

procedure TfrmMain.testoldroutine1Click(Sender: TObject);
var mr: integer;
begin
//rank analyses by RDII
  frmCAAnalysisChooser.InitializeLists;
  mr := mrOK;
  while mr = mrOK do begin
    //frmCAAnalysisChooser.InitializeLists;
    mr := frmCAAnalysisChooser.ShowModal;
    if (mr = mrOK) then begin
      // if multiple scenario selected - goto this is .pas/.dfm designed for 2/3 graphs
      frmCARDIIRankingGraph.ShowModal;
      // if single scenario selected - goto this .pas/.dfm designed for single graph only
    end;
  end;
end;

procedure TfrmMain.testingClick(Sender: TObject);
begin
  {chooseLinearRegression.frmLinearRegressionSelector.FormShow();}
  {frmLinearRegressionSelector.ShowModal();}
  frmChooseLinearRegressionMethod.showModal();
end;

procedure TfrmMain.ToggleChartColors;
begin
  if iColorScheme = 0 then
    iColorScheme := 1 else iColorScheme := 0;
end;

procedure TfrmMain.RemoveWeekdaysManually1Click(Sender: TObject);
begin
//  if (frmFlowMeterSelector.ShowModal = mrOK) then frmManualDWFDaySelection.ShowWeekdays;
  frmFlowMeterSelector.Caption :=
    stringreplace((Sender as TMenuItem).Caption, '&', '', [rfReplaceAll, rfIgnoreCase]);
  while (frmFlowMeterSelector.ShowModal = mrOK) do frmManualDWFDaySelection.ShowWeekdays;
end;

procedure TfrmMain.AutomaticEventIdentification1Click(Sender: TObject);
begin
  frmAutomaticEventIdentification.ShowModal
end;

procedure TfrmMain.EventTable1Click(Sender: TObject);
begin
  frmEventsTable.ShowModal;
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
var
  sdate1, stime1, sdate2,stime2 : string;
  datetime1,datetime2: TDateTime;
begin
  Close;
end;

procedure TfrmMain.OpenDatabase1Click(Sender: TObject);
begin
  if (OpenDatabaseDialog.Execute) then OpenDatabase(OpenDatabaseDialog.Filename);
end;


procedure TfrmMain.Postprocessing1Click(Sender: TObject);
begin
  frmSWMM5resultsImport1.ShowModal
end;

procedure TfrmMain.PreandPostRehabilitationAnalysis1Click(Sender: TObject);

{var
  sAnalysis: array[0..3] of string;
  i, j, CAID: integer;
  events: TStormEventCollection;
  myEventStatGetter: TEventStatGetter;
  analysisID: integer;
  Ravg, RFtot: double;

  procedure Addline(s: string);
  begin
    frmFeedbackWithMemo.feedbackMemo.Lines.Add(s);
  end;  }

begin
///new 2011-03-10
//compare RDII statistics one analysis to another. . . .
//allow user to select Analyses and / or Condition Assessments
  frmCASelector.Caption :=
    'Select Condition Assessment';
  while (frmCASelector.ShowModal = mrOK) do begin


    {
    frmFeedbackWithMemo.Caption := 'Condition Assessment: ' + frmCASelector.SelectedCA;
    CAID := databaseModule.GetCAID4Name(frmCASelector.SelectedCA);
    for i := 0 to 3 do begin
      sAnalysis[i] := databaseModule.GetAnalysisName4CAID(CAID, i+1);
      analysisID := DatabaseModule.GetAnalysisIDForName(sAnalysis[i]);
      Addline('Analysis ' + sAnalysis[i]);
      Addline('------------------------------------');
      events := DatabaseModule.GetEvents(analysisID);
      myEventStatGetter := TEventStatGetter.Create(analysisID);
      Ravg := 0.0;
      RFtot := 0.0;
      for j := 1 to events.count do begin
        myEventStatGetter.GetEventStats(j);
        Addline(' Event number ' + inttostr(j) +
          ' Start Date: ' + FormatDateTime('ddddd hh:MM',myEventStatGetter.StartDate) +
          ' End Date: ' + FormatDateTime('ddddd hh:MM',myEventStatGetter.EndDate));
        Addline(' Total Event Rain Depth:   ' + FormatFloat('0.00', myEventStatGetter.rainVolume));
        Addline(' Total Event R (observed): ' + FormatFloat('0.000', myEventStatGetter.eventTotalR));
        Addline(' Total Event II Vol (obs): ' + FormatFloat('0.00', myEventStatGetter.iiVolume));
        Addline(' Total Event II Depth(obs):' + FormatFloat('0.00', myEventStatGetter.iiDepth));
        Addline(' Peak Event II Flow): ' + FormatFloat('0.00', myEventStatGetter.peakIIFlow));
        Addline(' Peak Event Flow: ' + FormatFloat('0.00', myEventStatGetter.peakObservedFlow));
        Addline(' Average Event Flow: ' + FormatFloat('0.00', myEventStatGetter.averageObservedFlow));
//        peakfctr
//        peakwwf
//        fbwwsum
//        RDIIperLF
//        RDIIgalperLF
        //Addline(' Event Peak Factor: ' + FormatFloat('0.00', myEventStatGetter.peakfctr));
        //Addline(' Event Peak WW Flow: ' + FormatFloat('0.00', myEventStatGetter.peakwwf));
        //Addline(' Event BWW Flow: ' + FormatFloat('0.00', myEventStatGetter.fbwwsum));
        Addline(' Event RDII per LF Sewer: ' + FormatFloat('0.00', myEventStatGetter.RDIIperLF));
        Addline(' Event RDII gal per LF Sewer: ' + FormatFloat('0.00', myEventStatGetter.RDIIgalperLF));
        Addline('------------------------------------');
        Ravg := Ravg + myEventStatGetter.eventTotalR * myEventStatGetter.rainVolume;
        RFTot := RFTot + myEventStatGetter.rainVolume;
      end;
      myEventStatGetter.AllDone;
      if RFTot > 0 then Ravg := Ravg / RFTot;
      AddLine('Analysis Total Event Rain Depth:   ' + FormatFloat('0.000', RFTot));
      AddLine('Analysis Total Event R (observed): ' + FormatFloat('0.000', Ravg));
      Addline('------------------------------------');
    end;
    //Addline('------------------------------------');
    frmFeedbackWithMemo.OpenAfterProcessing;
    }
  end;

end;

procedure TfrmMain.Preprocessing1Click(Sender: TObject);
begin
//  SW5InterFaceFile.TestSWMM5InterFaceFile;
end;

procedure TFrmMain.OpenDatabase(filename: string);
var
//  DatabaseProperties, DriverProperties: TStringList;
  databaseVersion: integer;
  databaseHasCorrectForm, correctVersion: boolean;
  tableRecSet: _RecordSet;
  constraints: OleVariant;
  boHasConditionAssessments: boolean;
  boHasComparisonScenario: boolean;
  sSQL : string;
begin
  boHasConditionAssessments := false;
  boHasComparisonScenario := false;
  fname := '';
  connectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;' +
    'Data Source='+ filename + ';';
  connection := CoConnection.Create;
  connection.Open(connectionString,'','',-1);
(*
  DriverProperties := TStringList.Create;
  DriverProperties.Add('DLL32=IDDA3532.DLL');
  Session.ModifyDriver('MSACCESS',DriverProperties);
  DatabaseProperties := TStringList.Create;
  DatabaseProperties.Add('DATABASE NAME=' + filename);
  DatabaseProperties.Add('OPEN MODE=READ/WRITE');
  Session.AddAlias('meter_database_alias','MSACCESS',DatabaseProperties);
  DatabaseProperties.Free;
  MeterDatabase.AliasName := 'meter_database_alias';
*)
  try
    {Check here that the database is of the correct form.  For now, just check}
    {that the Metadata table is present.  A future enhancement would check the
    {presence and definition of each required table}
    databaseHasCorrectForm := false;
    constraints := VarArrayCreate([0,3],varVariant);
    constraints[3] := 'TABLE';
    tableRecSet := connection.OpenSchema(adSchemaTables,constraints,EmptyParam);
    if (not tableRecSet.EOF) then tableRecSet.MoveFirst;
    while (not tableRecSet.EOF) do begin
      if (tableRecSet.Fields['TABLE_NAME'].Value = 'Metadata') then begin
        databaseHasCorrectForm := true;
        //rm 2011-03-20
      end;
        if (tableRecSet.Fields['TABLE_NAME'].Value = 'ConditionAssessments') then begin
          boHasConditionAssessments := true;
        end;
        if (tableRecSet.Fields['TABLE_NAME'].Value = 'ComparisonScenarios') then begin
          boHasComparisonScenario := true;
        end;
      tableRecSet.MoveNext;
    end;
    if (boHasConditionAssessments = false) then begin
      DataBaseModule.UpdateDatabase;
    end;
    if (boHasComparisonScenario = false) then begin
      DataBaseModule.UpdateDatabase_ComparisonScenario;
    end;
    {if the database has the correct structure, check that it is the correct version}
    if (databaseHasCorrectForm) then begin
      correctVersion := true;
      databaseVersion := DatabaseModule.databaseVersion;
      if (databaseVersion > requiredDatabaseVersion) then begin
        correctVersion := false;
        MessageDlg('The version of the database is newer that what is is expected.' + #13 +
                   'It was created by a more recent version of the SSOAP program.',mtError,[mbOK],0);
      end;
      if (databaseVersion < requiredDatabaseVersion) then begin
        {calls to procedures to upgrade the database could go here}
        {if an external upgrade process is done, the error code below should remain}

        if (databaseVersion >= 5) then begin //5 was Version 1.0 release DatabaseVersion
          if DatabaseModule.upgradeDatabase(startupDirectory, databaseVersion, requiredDatabaseVersion) then begin
            correctVersion := true;
          end else begin
            correctVersion := false;
            MessageDlg('The version of the database is older that what is is expected.' + #13 +
                       'An attempt was made to upgrade it, but unfortunately this attempt failed.',mtError,[mbOK],0);
          end;
        end else begin
          correctVersion := false;
          MessageDlg('The version of the database is older that what is is expected.' + #13 +
                     'It was created by an older version of the SSOAP program.',mtError,[mbOK],0);
        end;
      end;
      if (correctVersion) then begin
        fname := filename;
        frmMain.Caption := 'SSOAP Toolbox - ' + filename;
        enableMenusAfterOpeningDatabase;
      end
      else CloseDatabase;
    end
    else begin
      MessageDlg('This database does not have the expected structure.',mtError,[mbOK],0);
      CloseDatabase;
    end;
  except
    on E: Exception do begin
//      Session.DeleteAlias('meter_database_alias');
      MessageDlg('Error opening "' + filename + '".  File may not be an Access Database.',mtError,[mbOK],0);
    end;
  end;

end;

procedure TfrmMain.CloseDatabase();
begin
//rm 2012-04-09 - check status of connection - only close if already open. . . .
if (connection.State = 1) then begin
  connection.Close;
end;
  connection := nil;
// The line below can be removed, once complete conversion to ADO is achieved.
//  Session.DeleteAlias('meter_database_alias');
//
end;


procedure TfrmMain.CloseDatabase1Click(Sender: TObject);
begin
  fname := '';
  CloseDatabase;
  frmMain.Caption := 'SSOAP Toolbox';

  MenuItemFileNew.Enabled := True;
  MenuItemFileOpen.Enabled:= True;
  MenuItemFileClose.Enabled := False;

  MenuItemDataManagementTool.Enabled := false;
  MenuItemRDIIAnalysisTool.Enabled := false;
  MenuItemHydrographGenerationTool.Enabled := false;
  MenuItemSWMM5InterfacingTool.Enabled := false;
  MenuItemFlowMonitorData.Enabled := false;
  MenuItemRainfallData.Enabled := false;
  MenuItemSewershedData.Enabled := false;

  MenuItemFlowMonitorImport.Enabled := False;
  MenuItemFlowMonitorExport.Enabled := False;
  //FillInMissingFlowData1.Enabled := False;
  MenuItemFillInMissingFlowData.Enabled := false;
  //IdentifyMinimumNighttimeFlows.Enabled := False;
  MenuItemIDMinimumNighttimeFlows.Enabled := False;

  MenuItemRainfallData.Enabled := False;
  MenuItemRainfallImport.Enabled := False;
  MenuItemRainfallExport.Enabled := False;
  MenuItemRainfallConvertTimestep.Enabled := False;
  MenuItemRainfallDataReview.Enabled := false;

  MenuItemSewershedData.Enabled := false;
  MenuItemSewershedImport.Enabled := false;
  MenuItemSewershedExport.Enabled := false;

  MenuItemRDIIAreaData.Enabled := false;
  MenuItemRDIIAreaImport.Enabled := false;
  MenuItemRDIIAreaExport.Enabled := false;

  //AnalysisManagement1.Enabled := False;
  //DWFAnalysis1.Enabled := False;
  //WWFAnalysis1.Enabled := False;
  MenuItemAnalysisManagement.Enabled := false;
  MenuItemDWFAnalysis.Enabled := false;
  MenuItemWWFAnalysis.Enabled := false;
  MenuItemStatisticalAnalysis.Enabled := false;

  {}
  hotspots[0].Hint := '';
  hotspots[1].Hint := '';
  hotspots[2].Hint := '';
  hotspots[3].Hint := '';
  hotspots[5].Hint := '';
  hotspots[6].Hint := '';
  hotspots[9].Hint := '';

  hotspots[0].Enabled := false;
  hotspots[1].Enabled := false;
  hotspots[2].Enabled := false;
  hotspots[5].Enabled := false;
  hotspots[6].Enabled := false;
  hotspots[9].Enabled := false;
  hotspots[11].Enabled := false;
  {}

{  AutomaticGWIAdjustmentCalculation1.Enabled := False;
  GWIAdjustmentTable1.Enabled := False;
  AutomaticEventIdentification1.Enabled := False;
  EventTable1.Enabled := False;
  EventStatistics1.Enabled := False;
  RainfallIntensityStatistics1.Enabled := False;
  CalculatedvsSimulatedRDIISummaryStatistics1.Enabled := False;

  ExportEvents1.Enabled := False;
  ImportEvents1.Enabled := False;
  WriteAllFlows1.Enabled := False;
  WriteDailyFlows1.Enabled := False;
  IIGraph1.Enabled := False;

  FlowConverterManagement1.Enabled := False;
  RainConverterManagement1.Enabled := False;    }
//  Holidays1.Enabled := False;

  //UsingConverter1.Enabled := False;
  //UsingConverter2.Enabled := False;

  MenuItemConditionAssessmentTool.Enabled := false;
end;

procedure TfrmMain.ConfigureSSOsandJunctionDepthTimeseries1Click(
  Sender: TObject);
begin
  frmSWMM5resultsImport2.ShowModal
end;

procedure TfrmMain.MediumRvalues1Click(Sender: TObject);
begin
  frmAnalysisSelector.Caption :=
    stringreplace((Sender as TMenuItem).Caption, '&', '', [rfReplaceAll, rfIgnoreCase]);
  while (frmAnalysisSelector.ShowModal = mrOK) do begin
//  if (frmAnalysisSelector.ShowModal = mrOK) then begin

    statisticalanalysisThread.CreateIt(frmAnalysisSelector.SelectedAnalysis);
    frmFeedbackWithMemo.Caption := 'Statistical RDII Analysis';
    frmFeedbackWithMemo.OpenForProcessing;

  end;
end;


procedure TfrmMain.MenuItemVisitEPASSOWebsiteClick(Sender: TObject);
var myFileRunner: TFileRun;
begin
  myFileRunner := TFileRun.Create(Self);
  //rm 2012-11-16 myFileRunner.FileName := 'http://cfpub1.epa.gov/npdes/home.cfm?program_id=4';
  myFileRunner.FileName := 'http://www.epa.gov/nrmrl/wswrd/wq/models/ssoap/';
  myFileRunner.Execute;
  myFileRunner.Free;
end;

procedure TfrmMain.MeterDatabaseLogin(Database: TDatabase;
  LoginParams: TStrings);
begin
  LoginParams.Values['USER NAME'] := '';
  LoginParams.Values['PASSWORD'] := '';
end;

procedure TfrmMain.CONFile1Click(Sender: TObject);
begin
  frmImportFlowFromCONFile.ShowModal;
end;

procedure TfrmMain.Feedback1Click(Sender: TObject);
begin
  //frmFeedback.showModal;
end;

procedure TfrmMain.Fill1Click(Sender: TObject);
begin
  frmFillInMissingDataForm.ShowModal;
end;

procedure TfrmMain.FillInMissingFlowData1Click(Sender: TObject);
begin
  frmFillInMissingDataForm.ShowModal;
end;

procedure TfrmMain.ViewA1Click(Sender: TObject);
begin
//  if (frmFlowMeterSelector.ShowModal = mrOK) then frmDryWeatherHydrographsForm.ShowModal;
  frmFlowMeterSelector.Caption :=
    stringreplace((Sender as TMenuItem).Caption, '&', '', [rfReplaceAll, rfIgnoreCase]);
  while (frmFlowMeterSelector.ShowModal = mrOK) do frmDryWeatherHydrographsForm.ShowModal;
end;

procedure TfrmMain.ConvertTimeStep1Click(Sender: TObject);
begin
  frmConvertRainTimeStep.ShowModal;
end;

procedure TfrmMain.CreateaFlowMonitor1Click(Sender: TObject);
var
  flowMetersDefined, rainGaugesDefined: boolean;
  numFlowMeters, numRainGauges: integer;
begin
  frmFlowMeterManagement.ShowModal;
  {on exit from flow meter configuration, update the menu availability}
  numFlowMeters := GetFlowMeterCount;
  numRainGauges := GetRaingaugeCount;
  flowMetersDefined := numFlowMeters > 0;
  rainGaugesDefined := numRainGauges > 0;
  if (flowMetersDefined) then begin
    MenuItemFlowMonitorImport.Enabled := True;
    MenuItemFlowMonitorExport.Enabled := True;
    //FillInMissingFlowData1.Enabled := True;
    MenuItemFillInMissingFlowData.Enabled := true;
    //IdentifyMinimumNighttimeFlows.Enabled := True;
    MenuItemIDMinimumNighttimeFlows.Enabled := true;
    if (raingaugesDefined)
      //then AnalysisManagement1.Enabled := True
      //else AnalysisManagement1.Enabled := False;
      then MenuItemAnalysisManagement.Enabled := true
      else MenuItemAnalysisManagement.Enabled := false;
  end
  else begin
    //Import2.Enabled := False;
    MenuItemFlowMonitorExport.Enabled := False;
    //FillInMissingFlowData1.Enabled := False;
    MenuItemFillInMissingFlowData.Enabled := false;
    //IdentifyMinimumNighttimeFlows.Enabled := False;
    MenuItemIDMinimumNighttimeFlows.Enabled := False;
    //AnalysisManagement1.Enabled := False;
    MenuItemAnalysisManagement.Enabled := false;
  end;
end;

procedure TfrmMain.CreateaRainGage1Click(Sender: TObject);
var
  flowMetersDefined, rainGaugesDefined: boolean;
  numFlowMeters, numRainGauges: integer;
begin
  frmRaingaugeManagement.ShowModal;
  {on exit from raingauge configuration, update the menu availability}
//  flowMetersDefined := DatabaseModule.GetFlowMeterNames.Count > 0;
//  rainGaugesDefined := DatabaseModule.GetRaingaugeNames.Count > 0;
  numFlowMeters := GetFlowMeterCount;
  numRainGauges := GetRaingaugeCount;
  flowMetersDefined := numFlowMeters > 0;
  rainGaugesDefined := numRainGauges > 0;

  if (rainGaugesDefined) then begin
    MenuItemRainfallImport.Enabled := True;
    MenuItemRainfallExport.Enabled := True;
    MenuItemRainfallConvertTimestep.Enabled := True;
    if (flowMetersDefined)
      //then AnalysisManagement1.Enabled := True
      //else AnalysisManagement1.Enabled := False;
      then MenuItemAnalysisManagement.Enabled := true
      else MenuItemAnalysisManagement.Enabled := false;
  end
  else begin
    //Import3.Enabled := False;
    MenuItemRainfallExport.Enabled := False;
    MenuItemRainfallConvertTimestep.Enabled := False;
    //AnalysisManagement1.Enabled := False;
    MenuItemAnalysisManagement.Enabled := false;
  end;
end;

procedure TfrmMain.CreateSewershed1Click(Sender: TObject);
var numSewerSheds, numRDIIAreas: integer;
begin
  frmSewershedManagement.ShowModal;
  numSewerSheds := GetSewerShedCount;
end;

procedure TfrmMain.DataImportLog1Click(Sender: TObject);
begin
  frmDataImportLog.ShowModal;
end;

procedure TfrmMain.DepthvsFlowScatterPlot1Click(Sender: TObject);
begin
  frmScatterGraphSelector.SelectedGraphType := 'DF';
  if (frmScatterGraphSelector.ShowModal = mrOK) then ;
end;

procedure TfrmMain.DepthvsVelocityScatterPlot1Click(Sender: TObject);
begin
  frmScatterGraphSelector.SelectedGraphType := 'DV';
  if (frmScatterGraphSelector.ShowModal = mrOK) then ;
  //frmScatterGraph.ShowModal;
end;

procedure TfrmMain.DVScatterGraph1Click(Sender: TObject);
begin
  if (frmScatterGraphSelector.ShowModal = mrOK) then frmScatterGraph.ShowModal;
end;

procedure TfrmMain.AnalysisManagement1Click(Sender: TObject);
var
  num: integer;
begin
  frmAnalysisManagement.ShowModal;
  {on exit from analysis configuration, update the menu availability}
  num := GetAnalysisCount;
end;

function TfrmMain.GetAnalysisCount: integer;
var num: integer;
    boEnabled: boolean;
begin
  num := DatabaseModule.GetAnalysisNames.Count;
  SetHotSpot('Analysis',num,0);
  boEnabled := (num > 0);
  MenuItemDWFAnalysis.Enabled := boEnabled;
  MenuItemWWFAnalysis.Enabled := boEnabled;
  MenuItemStatisticalAnalysis.Enabled := boEnabled;
  MenuItemRainfallIntensityStatistics.Enabled := boEnabled;
  MenuItemSimulatedvsObservedRDII.Enabled := boEnabled;

{
  if (num > 0) then begin
    AutomaticGWIAdjustmentCalculation1.Enabled := True;
//    GWIAdjustmentTable1.Enabled := True;
    AutomaticEventIdentification1.Enabled := True;
//    EventTable1.Enabled := True;
    EventStatistics1.Enabled := True;
    RainfallIntensityStatistics1.Enabled := True;
    CalculatedvsSimulatedRDIISummaryStatistics1.Enabled := True;
    ExportEvents1.Enabled := True;
    ImportEvents1.Enabled := True;
    WriteAllFlows1.Enabled := True;
    WriteDailyFlows1.Enabled := True;
    IIGraph1.Enabled := True;
  end
  else begin
    AutomaticGWIAdjustmentCalculation1.Enabled := False;
    GWIAdjustmentTable1.Enabled := False;
    AutomaticEventIdentification1.Enabled := False;
    EventTable1.Enabled := False;
    EventStatistics1.Enabled := False;
    RainfallIntensityStatistics1.Enabled := False;
    CalculatedvsSimulatedRDIISummaryStatistics1.Enabled := False;
    ExportEvents1.Enabled := False;
    ImportEvents1.Enabled := False;
    WriteAllFlows1.Enabled := False;
    WriteDailyFlows1.Enabled := False;
    IIGraph1.Enabled := False;
  end;
}
  Result := num;
end;

function TfrmMain.GetChartLineWidth: Integer;
begin
  Result := FChartLineWidth[iColorScheme];
end;

function TfrmMain.GetChartRGBBK: TColor;
begin
  Result := FChartRGBBK[iColorScheme];
end;

function TfrmMain.GetChartRGBFlow: TColor;
begin
  Result := FChartRGBFlow[iColorScheme];
end;

function TfrmMain.GetChartRGBGree: TColor;
begin
  Result := FChartRGBGree[iColorScheme];
end;

function TfrmMain.GetChartRGBRain: TColor;
begin
  Result := FChartRGBRain[iColorScheme];
end;

function TfrmMain.GetChartRGBText: TColor;
begin
  Result := FChartRGBText[iColorScheme];
end;

function TfrmMain.GetChartRGBYell: TColor;
begin
  Result := FChartRGBYell[iColorScheme];
end;

function TfrmMain.GetEPASwmm5Folder: string;
var
  myRegistryReader: TRegistry;
  strResult, strKey, strPath: string;
begin
//default to the default
  strResult := '"C:\Program Files\EPA SWMM 5.0\Epaswmm5.exe"';
  myRegistryReader := TRegistry.Create(KEY_READ);
//the only place in registry I could find installation location was:
//HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Currentversion\Uninstall\EPA SWMM 5.0
//UninstallString=C:\Windows\GPInstall.exe "/UNINST=D:\Program Files\SWMM 5\UnInst.log" "/APPNAME=EPA SWMM 5.0"
  strKey := 'SOFTWARE\Microsoft\Windows\Currentversion\Uninstall\EPA SWMM 5.0';
  strPath := '';
  try
    myRegistryReader.RootKey := HKEY_LOCAL_MACHINE;
    myRegistryReader.OpenKey(strKey, false);
    strPath := myRegistryReader.ReadString('UninstallString');
    if  Pos('/UNINST=',strPath) > 0 then begin
      strPath := MidStr(strPath,Pos('/UNINST=',strPath) + 8, 1000);
      //strPath := ExtractFilePath(strPath);
    end else begin
      strPath := '';
    end;
  finally
    myRegistryReader.Free;
  end;
  if Length(strPath) > 0 then
    strResult := ExtractFilePath(strPath);
  Result := strResult;
end;

function TfrmMain.GetFlowMeterCount: Integer;
var num: integer; boEnabled: boolean;
begin
  num := DatabaseModule.GetFlowMeterNames.Count;
  SetHotSpot('Flow Meter',num,0);
  boEnabled := (num > 0);
  MenuItemFlowMonitorExport.Enabled := boEnabled;
  //FillInMissingFlowData1.Enabled := True;
  MenuItemFillInMissingFlowData.Enabled := boEnabled;
  //FlowDataReview
  MenuItemFlowScatterPlot.Enabled := boEnabled;
  //IdentifyMinimumNighttimeFlows.Enabled := True;
  MenuItemIDMinimumNighttimeFlows.Enabled := boEnabled;
  Result := num;
end;

function TfrmMain.GetRainGaugeCount: Integer;
var num:integer; boEnabled: boolean;
begin
  num := DatabaseModule.GetRaingaugeNames.Count;
  SetHotSpot('Rain Gauge',num,0);
  boEnabled := (num > 0);
  MenuItemRainfallExport.Enabled := boEnabled;
  MenuItemRainfallConvertTimestep.Enabled := boEnabled;
  MenuItemRainfallDataReview.Enabled := boEnabled;
  MenuItemRainfallDataAnalysis.Enabled := boEnabled;
  Result := num;
end;

function TfrmMain.GetRDIIAreaCount: Integer;
var num: integer;
begin
  num := DatabaseModule.GetRDIIAreaNames.Count;
  Result := num;
end;

function TfrmMain.GetRTKPatternCount: Integer;
var num: integer;
begin
  num := DatabaseModule.GetRTKPatternNames.Count;
  SetHotSpot('RTK Pattern',num,0);
  MenuItemRTKPatternExport.Enabled := (num > 0);
  Result := num;
end;

function TfrmMain.GetScenarioCount: Integer;
var num: integer;
begin
  num := DatabaseModule.GetScenarioNames.Count;
  SetHotSpot('Scenario',num,0);
  Result := num;
end;

function TfrmMain.GetSewerShedCount: Integer;
var numSewerSheds, numRDIIAreas: integer;
begin
  numSewerSheds := DatabaseModule.GetSewerShedNames.Count;
  numRDIIAreas := DatabaseModule.GetRDIIAreaNames.Count;
  SetHotSpot('Sewershed', numSewerSheds, numRDIIAreas);
  MenuItemSewershedExport.Enabled := (numSewerSheds > 0);
  MenuItemRDIIAreaExport.Enabled := (numRDIIAreas > 0);
  Result := numSewerSheds;
end;

procedure TfrmMain.GWIAdjustmentTable1Click(Sender: TObject);
begin
  frmGWIAdjustmentTable.ShowModal;
end;

procedure TfrmMain.IIGraph1Click(Sender: TObject);
begin
  frmAnalysisSelector.Caption :=
    stringreplace((Sender as TMenuItem).Caption, '&', '', [rfReplaceAll, rfIgnoreCase]);
  while (frmAnalysisSelector.ShowModal = mrOK) do begin
    frmIIGraph.ShowModal;
  end;
end;

procedure TfrmMain.ASCIIFormat1Click(Sender: TObject);
begin
  frmExportPRNTFLOWCSV.ShowModal;
end;

procedure TfrmMain.MMADYSummary1Click(Sender: TObject);
begin
  frmExportMaxMinAvg.ShowModal;
end;

procedure TfrmMain.EditMeters1Click(Sender: TObject);
begin
  frmFlowMeterManagement.ShowModal;
end;

procedure TfrmMain.FlowMeterManagement1Click(Sender: TObject);
var
  flowMetersDefined, rainGaugesDefined: boolean;
  numFlowMeters, numRainGauges: integer;
begin
  frmFlowMeterManagement.ShowModal;
  {on exit from flow meter configuration, update the menu availability}
//  flowMetersDefined := DatabaseModule.GetFlowMeterNames.Count > 0;
//  rainGaugesDefined := DatabaseModule.GetRaingaugeNames.Count > 0;
  numFlowMeters := GetFlowMeterCount;
  numRainGauges := GetRaingaugeCount;
  flowMetersDefined := numFlowMeters > 0;
  rainGaugesDefined := numRainGauges > 0;
  if (flowMetersDefined) then begin
    MenuItemFlowMonitorImport.Enabled := True;
    MenuItemFlowMonitorExport.Enabled := True;
//    FillInMissingFlowData1.Enabled := True;
    MenuItemFillInMissingFlowData.Enabled := true;
    //IdentifyMinimumNighttimeFlows.Enabled := True;
    MenuItemIDMinimumNighttimeFlows.Enabled := true;
    //if (raingaugesDefined)
      //then AnalysisManagement1.Enabled := True
      //else AnalysisManagement1.Enabled := False;
    MenuItemAnalysisManagement.Enabled := raingaugesDefined;
  end
  else begin
    //Import2.Enabled := False;
    MenuItemFlowMonitorExport.Enabled := False;
    //FillInMissingFlowData1.Enabled := False;
    //IdentifyMinimumNighttimeFlows.Enabled := False;
    MenuItemIDMinimumNighttimeFlows.Enabled := False;
    //AnalysisManagement1.Enabled := False;
    MenuItemAnalysisManagement.Enabled := false;
  end;
end;

procedure TfrmMain.FlowMonitoringData1Click(Sender: TObject);
begin
  frmFlowConverterManagement.ShowModal;
  {on exit from flow converter configuration, update the menu availability}
  if (DatabaseModule.GetFlowConverterNames.Count > 0)
    then MenuItemFlowMonitorImport.Enabled := True
    else MenuItemFlowMonitorImport.Enabled := False;

end;

procedure TfrmMain.FlowMonitoringData2Click(Sender: TObject);
begin
  frmImportFlowDataUsingConverter.Enabled := true;
  frmImportFlowDataUsingConverter.ShowModal;
end;

procedure TfrmMain.FlowMonitoringData3Click(Sender: TObject);
begin
  frmExportPRNTFLOWCSV.ShowModal;
end;

procedure TfrmMain.RaingaugeManagement1Click(Sender: TObject);
var
  flowMetersDefined, rainGaugesDefined: boolean;
  numFlowMeters, numRainGauges: integer;
begin
  frmRaingaugeManagement.ShowModal;
  {on exit from raingauge configuration, update the menu availability}
//  flowMetersDefined := DatabaseModule.GetFlowMeterNames.Count > 0;
//  rainGaugesDefined := DatabaseModule.GetRaingaugeNames.Count > 0;
  numFlowMeters := GetFlowMeterCount;
  numRainGauges := GetRaingaugeCount;
  flowMetersDefined := numFlowMeters > 0;
  rainGaugesDefined := numRainGauges > 0;
  if (rainGaugesDefined) then begin
    MenuItemRainfallImport.Enabled := True;
    MenuItemRainfallExport.Enabled := True;
    MenuItemRainfallConvertTimestep.Enabled := True;
//    if (flowMetersDefined)
//      then AnalysisManagement1.Enabled := True
//      else AnalysisManagement1.Enabled := False;
    MenuItemAnalysisManagement.Enabled := flowMetersDefined;
  end
  else begin
    //Import3.Enabled := False;
    MenuItemRainfallExport.Enabled := False;
    MenuItemRainfallConvertTimestep.Enabled := False;
    //AnalysisManagement1.Enabled := False;
    MenuItemAnalysisManagement.Enabled := false;
  end;
end;

procedure TfrmMain.CONFile3Click(Sender: TObject);
begin
  frmImportRainfallFromCONFile.ShowModal;
end;

procedure TfrmMain.FreeFormASCII1Click(Sender: TObject);
begin
  frmExportPRNTRAINTabular.ShowModal;
end;

procedure TfrmMain.AutomaticGWIAdjustmentCalculation1Click(
  Sender: TObject);
begin
  frmAutomaticGWIAdjustmentCalculation.ShowModal
end;

procedure TfrmMain.IdentifyMinimumNighttimeFlowsClick(Sender: TObject);
begin
  frmMinimumNighttimeFlows.ShowModal;
end;

procedure TfrmMain.EventStatistics1Click(Sender: TObject);
begin
  frmEventStatisitics.ShowModal;
end;

procedure TfrmMain.WriteAllFlows1Click(Sender: TObject);
begin
  frmWriteAllFlows.ShowModal;
end;

procedure TfrmMain.WriteDailyFlows1Click(Sender: TObject);
begin
  frmWriteDailyAverageFlows.ShowModal;
end;

procedure TfrmMain.NewDatabase1Click(Sender: TObject);
var
  source, filename: string;
  res: boolean;
begin
  if (NewDatabaseDialog.Execute) then begin
    //if (frmDatabaseFormat.ShowModal = mrOK) then begin
    //Don't need the access97 reference anymore
      //if (frmDatabaseFormat.access97RadioButton.checked)
        //then source := startupDirectory + '\emptyAccess97rdii.___'
        //else
//      source := startupDirectory + '\emptyAccess2000rdii.___';
      source := startupDirectory + '\ssoaptoolbox.___';
      filename := NewdatabaseDialog.Filename;
      res := CopyFile(pchar(source),pchar(filename),false);
      if (res)
        then OpenDatabase(filename)
        else MessageDlg('Database "' + filename + '" could not be created.',mtError,[mbOK],0);
    //end;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  cmd, apppath: string;
  databasename: string;
  dtToday, dtSunset: TDateTime;
  i: integer;
begin
  {no files are opened for reading and writing so set FileMode = 0 here for}
  {application-wide read-only opening when using the RESET procedure}
  FileMode := 0;
  //self.Width := 1008;
  //self.Height := 640;
  //self.Width := 968;
  //self.Height := 774;
  self.Left := 0;
  self.Top := 0;
  self.Width := 800;
  self.Height := 600;

  //rm 2009-06-01 - modify sunset date so we can keep working
  //dtSunset := StrToDate('06/01/2009');
  //rm 2009-06-29 - new sunset
  //dtSunset := StrToDate('07/01/2009');
  //dtSunset := StrToDate('10/01/2009');
    dtSunset := StrToDate('10/01/3009');
    dtToday := Now();
    if (dtToday > dtSunset) then begin
//    Label1.Caption := Label1.Caption + ' - THIS VERSION HAS EXPIRED Please check with EPA for an update.';
      self.Color := clWhite;
      Mainmenu2.Items.Clear;
      for i := 0 to {10} high(hotspots) do  begin
      if (i = 4) then begin
        //leave the link to EPA website intact
      end else begin
        Hotspots[i].Enabled := false;
        Hotspots[i].Free;
      end;
    end;

    exit;
  end;
  //filenames may have spaces in them - parameters are delimited by spaces
  cmd := CmdLine;
  //Showmessage(cmd);
  cmd := Copy(cmd, Length(paramstr(0))+4, 256);
  //Showmessage('"' + cmd + '"');
  databasename := Trim(cmd);
  //label1.Caption := inttostr(ClientWidth) + ', ' + inttostr(ClientHeight);
  //label1.Visible := true;
  //databasename := paramStr(1);
  //messageDlg('Opening database "' + databasename,mtinformation,[mbok],0);
  if (length(databaseName) > 0 ) then begin
    if (LastDelimiter('\',databasename) = 0) then databasename := startupDirectory + '\' + databasename;
    if (fileexists(databasename))
      then OpenDatabase(databasename)
      else MessageDlg('The database "' + databasename + '" specified'+#13
                      +'on the command line does not exist.',mtWarning,[mbOK],0);
  end;
  //rm 2009-06-24
  //locate the Help file SSOAP_OnlineHelp-BETA.chm
  apppath := ExtractFilePath(Application.ExeName);
  if FileExists(apppath + '\SSOAP_OnlineHelp.chm') then begin
    Application.HelpFile := apppath + '\SSOAP_OnlineHelp.chm';
  end;

end;

procedure TfrmMain.About1Click(Sender: TObject);
begin
//rm 2009-06-30 - new About box  frmAbout.ShowModal;
  AboutBoxForm.ShowModal;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
//rm 2007-10-29 - shortcuts from desktop or menu may have
//another folder as the "Current Directory"
//so get the Application.EXEName
//  startupDirectory := GetCurrentDir;
startupDirectory := ExtractFilePath(Application.ExeName);

  //color scheme settings:
  FChartRGBBK[0] := clWhite;
  FChartRGBText[0] := clBlack;
  FChartRGBFlow[0] := clTeal;
  FChartRGBRain[0] := clBlue;
  FChartRGBYell[0] := RGB(210,210,10);
  FChartRGBGree[0] := RGB(20,220,20);
  FChartLineWidth[0] := 2;
  FChartRGBBK[1] := clBlack;
  FChartRGBText[1] := clWhite;
  FChartRGBFlow[1] := clAqua;
  FChartRGBRain[1] := clBlue;
  FChartRGBYell[1] := clYellow;
  FChartRGBGree[1] := clLime;
  FChartLineWidth[1] := 1;
  SetColorScheme(0);
  //mainform hotspot settings: (like menu buttons)
  //make one for each box in the figure even if not using
  //false for not using
  //set tag to corresponding menu item index
{
  HotSpots[0] := THotSpot.Create(150,295,53,137,960,720,[MenuItemSewershedData],
    //true, 'Sewer System' + Chr(13) + 'GIS Database','',clLime,6,stRectangle,self);
    true, 'Sewershed' + Chr(13) + 'Data','',clLime,6,stRectangle,self);
}
  HotSpots[0] := THotSpot.Create(150,295,53,137,960,720,[MenuItemRainfallData],
    true, 'Rainfall' + Chr(13) + 'Data','',clLime,8,stRectangle,self);

  HotSpots[1] := THotSpot.Create(378,524,53,137,960,720,[MenuItemFlowMonitorData],
    true, 'Flow Monitoring' + Chr(13) + 'Data','',clLime,7,stRectangle,self);
{
  HotSpots[2] := THotSpot.Create(608,753,53,137,960,720,[MenuItemRainfallData],
    true, 'Rainfall' + Chr(13) + 'Data','',clLime,8,stRectangle,self);
}

  HotSpots[2] := THotSpot.Create(608,753,53,137,960,720,[MenuItemSewershedData],
    //true, 'Sewer System' + Chr(13) + 'GIS Database','',clLime,6,stRectangle,self);
    true, 'Sewershed' + Chr(13) + 'Data','',clLime,6,stRectangle,self);


//  HotSpots[3] := THotSpot.Create(150,295,224,307,960,720,
//    false, '',clWhite,0,stRectangle,self);
  HotSpots[3] := THotSpot.Create(378,524,224,307,960,720,[MenuItemFile,MenuItemDataManagementTool],
    true, 'Database' + Chr(13) + 'Management' + Chr(13) + 'Tool','',clYellow,1,stRectangle,self);
  HotSpots[4] := THotSpot.Create(700,932,211,319,960,720,[MenuItemLinktoTechnicalReport,MenuItemVisitEPASSOWebsite],
    true, 'SSO Analysis && Planning','Visit EPA SSO Website',clAqua,-10,stEllipse,self);
  HotSpots[5] := THotSpot.Create(150,295,392,476,960,720,[MenuItemRDIIAnalysisTool],
    true, 'RDII Analysis' + Chr(13) + 'Tool','',clYellow,2,stRectangle,self);
  HotSpots[6] := THotSpot.Create(378,524,392,476,960,720,[MenuItemHydrographGenerationTool],
    true, 'Hydrograph' + Chr(13) + 'Generation' + Chr(13) + 'Tool ','',clYellow,3,stRectangle,self);

//  HotSpots[7] := THotSpot.Create(641,747,381,487,960,720,[],
//    false, 'Other RDII' + Chr(13) + 'Tools','',clGray,0,stCircle,self);
  HotSpots[7] := THotSpot.Create(681,707,421,447,960,720,[],
    false, 'Other RDII' + Chr(13) + 'Tools','',clGray,0,stCircle,self);

//rm 2007-11-28 - if SWMM is actually part of the "toolbox," then
//shouldn't its hotspot be like the other "tools?"
//  HotSpots[8] := THotSpot.Create(169,276,550,658,960,720,[MenuItemSWMM5LaunchInterface],
//    true, 'SWMM5','Launch EPA SWMM5',clAqua,-5,stEllipse,self);
  HotSpots[8] := THotSpot.Create(150,295,563,646,960,720,[MenuItemSWMM5LaunchInterface],
    true, 'SWMM5','Launch EPA SWMM5',clYellow,-5,stRectangle,self);

  HotSpots[9] := THotSpot.Create(378,524,563,646,960,720,[MenuItemSWMM5InterfacingTool],
    true, 'SWMM5' + Chr(13) + 'Interfacing' + Chr(13) + 'Tool','',clYellow,4,stRectangle,self);

  HotSpots[10] := THotSpot.Create(641,747,550,658,960,720, [],
    false, 'Other Hydraulic' + Chr(13) + 'Model Engines','',clGray,0,stEllipse,self);

//  Hotspots[11] := THotSpot.Create(700,932,211,319,960,720, [MenuItemConditionAnalysis],
//    true, 'Condition Assessment','',clAqua,0,stEllipse,self);

//rm 2011-06-07 - grab the menu item up one level: MenuItemConditionAssessmentTool
//  Hotspots[11] := THotSpot.Create(608,753,392,476,960,720, [MenuItemConditionAnalysis],
//    true, 'Condition' + Chr(13) + 'Assessment','',clYellow,0,stRectangle,self);
//  Hotspots[11] := THotSpot.Create(608,753,392,476,960,720, [MenuItemConditionAssessmentTool],
//    true, 'Condition' + Chr(13) + 'Assessment','',clYellow,0,stRectangle,self);
//OR
//  Hotspots[11] := THotSpot.Create(608,753,392,476,960,720, [MenuItemConditionAnalysis,MenuItemConditionAnalysisCompare],
  Hotspots[11] := THotSpot.Create(608,753,392,476,960,720, [MenuItemConditionAssessmentTool],
    true, 'Condition' + Chr(13) + 'Assessment' + Chr(13) + 'Support Tool','',clYellow,0,stRectangle,self);



  HotSpots[11].Enabled := false;

  HotSpots[3].Enabled := true;
  HotSpots[4].Enabled := true;
  HotSpots[8].Enabled := true;

  DoubleBuffered := true; //prevents flickering of hotspot shapes
end;

procedure TfrmMain.FormResize(Sender: TObject);
var i: integer;
begin
//position the epa logo image
//  Image2.Left := ClientWidth - Image2.Width;
//  Image2.Top := ClientHeight - Image2.Height;
//position the background image
//  Image1.Top := 10;
//  Image1.Left := 20;//Image2.Width;
//  Image1.Top := 0;
//  Image1.Left := 0;
//  Image1.Width := ClientWidth - Image1.Left;
//  Image1.Height := ClientHeight - Image1.Top;
//position the hotspots
  for i := 0 to High(hotspots) {- 1} do begin
    hotspots[i].RePosition(Image1.Width, Image1.Height);
  end;

end;

procedure TfrmMain.ExportEvents1Click(Sender: TObject);
begin
//another form calls frmEventExport and needs a modalresult
//so we can't just keep the OK button from closing the form,
//yet we want the form to "stay open" effectively so the user
//can execute multiple operations without having to go back to
//the main menu. . . .
  repeat until (frmEventExport.ShowModal <> mrOK);
end;



procedure TfrmMain.Image2Click(Sender: TObject);
var i,j: integer;
    s: string;
    l: TStringList;
begin
//set color of the background IMage1
  ColorDialog1.Color := self.Color;
  if (ColorDialog1.Execute) then
    self.Color := ColorDialog1.Color;
{* //rm 2009-03-13 - for forcing a recalc of DWFs
l := DatabaseModule.GetFlowMeterNames;
for i := 0 to l.Count - 1 do begin
  s := l[i];
  j := DatabaseModule.GetMeterIDForName(s);
  messagedlg('Processing ' + s, mtinformation, [mbok], 0);
  DatabaseModule.CalculateWeekdayDWF(j);
  DatabaseModule.CalculateWeekendDWF(j);
end;
*}
end;

procedure TfrmMain.ImportEvents1Click(Sender: TObject);
begin
  frmEventImport.ShowModal;
end;

procedure TfrmMain.SetupMenuItemsforIndex(menuitems: Array of TMenuItem);
var i, j, ilow, ihigh: integer;
  newMenuItem,sourceMenuItem:TMenuItem;

  //recursive procedure
  procedure AddMenuChildren(Parent, Child: TMenuItem);
  var i: integer;
    aMenuItem:TMenuItem;
  begin
    aMenuItem := TMenuItem.Create(PopupMenuHotSpot);
    aMenuItem.Caption := Child.Caption;
    aMenuItem.OnClick := Child.onClick;
    aMenuItem.Enabled := Child.Enabled;
    Parent.Add(aMenuItem);
    for i := 0 to Child.Count - 1 do begin
      if Child.Items[i].Visible then
        AddMenuChildren(aMenuItem,Child.Items[i]);  //recursion
    end;
  end;

begin
  PopupMenuHotSpot.Items.Clear;
  for i := 0 to High(menuitems) do  begin
    if (menuitems[i] <> nil) then begin
      sourceMenuItem := menuitems[i];
      newMenuItem := TMenuItem.Create(PopupMenuHotSpot);
      newMenuItem.Caption := sourceMenuItem.Caption;
      newMenuItem.Enabled := sourceMenuItem.Enabled;
      newMenuItem.OnClick := sourceMenuItem.OnClick;
      PopupMenuHotSpot.Items.Add(newMenuItem);
      for j := 0 to sourceMenuItem.Count - 1 do begin
        if sourceMenuItem.Items[j].visible then
          AddMenuChildren(newMenuItem,sourceMenuItem.Items[j]); //recursive
      end;
    end;
  end;
end;

procedure TfrmMain.RunSWMM5Interface(sFileName: string);
const
  strEXEName = 'EPASwmm5.exe';
var
  strPath: string;
  myFileRunner: TFileRun;
begin
  strPath := GetEPASwmm5Folder;
  myFileRunner := TFileRun.Create(Self);
  myFileRunner.FileName := '"' + strPath + strEXEName + '"';
  myFileRunner.Parameters :=  '/f "' + sFileName + '"';
  myFileRunner.Execute;
  myFileRunner.Free;
end;

procedure TfrmMain.LaunchSWMM51Click(Sender: TObject);
const
  strEXEName = 'EPASwmm5.exe';
var
  strPath: string;
  myFileRunner: TFileRun;
begin
  strPath := GetEPASwmm5Folder;
  myFileRunner := TFileRun.Create(Self);
  myFileRunner.FileName := '"' + strPath + strEXEName + '"';
  //let user browse for input file to open
  myFileRunner.BrowseDlg.Title := 'Launch SWMM5 Graphical Interface';
  myFileRunner.BrowseDlg.Filter := 'SWMM5 Input Files (*.INP)|*.INP';
  if myFileRunner.BrowseDlg.Execute then begin
    myFileRunner.Parameters :=  '/f "' + myFileRunner.BrowseDlg.FileName + '"';
    //messagedlg(myFileRunner.FileName,mtInformation,[mbok],0);
    myFileRunner.Execute;
  end else begin
    if (MessageDlg('No input file selected. Do you want to launch EPA SWMM5 without an input file?',
    mtConfirmation, [mbYes,mbNo], 0) = mrYes) then
    myFileRunner.Execute;
  end;
  myFileRunner.Free;
end;

procedure TfrmMain.LinearRegression1Click(Sender: TObject);
begin
  {if (frmLinearRegressionSelector.ShowModal = mrOK) then begin
    frmLinearRegressionAnalysis.ShowModal;
  end;}
  frmChooseLinearRegressionMethod.ShowModal;
end;

///
///new 2011-03-10
procedure TfrmMain.MenuItemConditionAnalysisBreakpointAnalysisClick(
  Sender: TObject);
begin
///new 2011-03-10

end;

procedure TfrmMain.MenuItemConditionAnalysisClick(Sender: TObject);
begin
///new 2011-03-10
//  frmCAManagement.ShowModal;
{var
  sAnalysis: array[0..3] of string;
  i, j, CAID: integer;
  events: TStormEventCollection;
  myEventStatGetter: TEventStatGetter;
  analysisID: integer;
  Ravg, RFtot: double;

  procedure Addline(s: string);
  begin
    frmFeedbackWithMemo.feedbackMemo.Lines.Add(s);
  end;

begin
///new 2011-03-10
//compare RDII statistics one analysis to another. . . .
//allow user to select Analyses and / or Condition Assessments
  frmCASelector.Caption :=
    'Select Condition Assessment';
  while (frmCASelector.ShowModal = mrOK) do begin
(*
    //MessageDlg('You chose Condition Assessment "' + frmCASelector.SelectedCA + '" for processing.',
    //mtInformation,[mbok],0);
    frmFeedbackWithMemo.feedbackMemo.Clear;
    frmFeedbackWithMemo.Caption := 'Statistical RDII Analysis for Condition Assessment ' + frmCASelector.SelectedCA;
    CAID := databaseModule.GetCAID4Name(frmCASelector.SelectedCA);
    for i := 0 to 3 do begin
      sAnalysis[i] := databaseModule.GetAnalysisName4CAID(CAID, i+1);
      statisticalanalysisThread.CreateIt(sAnalysis[i]);
      frmFeedbackWithMemo.OpenForProcessing;
    end;
//      frmFeedbackWithMemo.OpenAfterProcessing;
*)
    frmFeedbackWithMemo.Caption := 'Condition Assessment: ' + frmCASelector.SelectedCA;
    CAID := databaseModule.GetCAID4Name(frmCASelector.SelectedCA);
    for i := 0 to 3 do begin
      sAnalysis[i] := databaseModule.GetAnalysisName4CAID(CAID, i+1);
      analysisID := DatabaseModule.GetAnalysisIDForName(sAnalysis[i]);
      Addline('Analysis ' + sAnalysis[i]);
      Addline('------------------------------------');
      events := DatabaseModule.GetEvents(analysisID);
      myEventStatGetter := TEventStatGetter.Create(analysisID);
      Ravg := 0.0;
      RFtot := 0.0;
      for j := 1 to events.count do begin
        myEventStatGetter.GetEventStats(j);
        Addline(' Event number ' + inttostr(j) +
          ' Start Date: ' + FormatDateTime('ddddd hh:MM',myEventStatGetter.StartDate) +
          ' End Date: ' + FormatDateTime('ddddd hh:MM',myEventStatGetter.EndDate));
        Addline(' Total Event Rain Depth:   ' + FormatFloat('0.00', myEventStatGetter.rainVolume));
        Addline(' Total Event R (observed): ' + FormatFloat('0.000', myEventStatGetter.eventTotalR));
        Addline(' Total Event II Vol (obs): ' + FormatFloat('0.00', myEventStatGetter.iiVolume));
        Addline(' Total Event II Depth(obs):' + FormatFloat('0.00', myEventStatGetter.iiDepth));
        Addline(' Peak Event II Flow): ' + FormatFloat('0.00', myEventStatGetter.peakIIFlow));
        Addline(' Peak Event Flow: ' + FormatFloat('0.00', myEventStatGetter.peakObservedFlow));
        Addline(' Average Event Flow: ' + FormatFloat('0.00', myEventStatGetter.averageObservedFlow));
//        peakfctr
//        peakwwf
//        fbwwsum
//        RDIIperLF
//        RDIIgalperLF
        //Addline(' Event Peak Factor: ' + FormatFloat('0.00', myEventStatGetter.peakfctr));
        //Addline(' Event Peak WW Flow: ' + FormatFloat('0.00', myEventStatGetter.peakwwf));
        //Addline(' Event BWW Flow: ' + FormatFloat('0.00', myEventStatGetter.fbwwsum));
        Addline(' Event RDII per LF Sewer: ' + FormatFloat('0.00', myEventStatGetter.RDIIperLF));
        Addline(' Event RDII gal per LF Sewer: ' + FormatFloat('0.00', myEventStatGetter.RDIIgalperLF));
        Addline('------------------------------------');
        Ravg := Ravg + myEventStatGetter.eventTotalR * myEventStatGetter.rainVolume;
        RFTot := RFTot + myEventStatGetter.rainVolume;
      end;
      myEventStatGetter.AllDone;
      if RFTot > 0 then Ravg := Ravg / RFTot;
      AddLine('Analysis Total Event Rain Depth:   ' + FormatFloat('0.000', RFTot));
      AddLine('Analysis Total Event R (observed): ' + FormatFloat('0.000', Ravg));
      Addline('------------------------------------');
    end;
    //Addline('------------------------------------');
    frmFeedbackWithMemo.OpenAfterProcessing;

  end; }

end;

procedure TfrmMain.MenuItemConditionAnalysisRDIIComparisonClick(
  Sender: TObject);
var
  sAnalysis: array[0..3] of string;
  i, j, CAID: integer;
  events: TStormEventCollection;
  myEventStatGetter: TEventStatGetter;
  analysisID: integer;
  Ravg, RFtot: double;

  procedure Addline(s: string);
  begin
    frmFeedbackWithMemo.feedbackMemo.Lines.Add(s);
  end;

begin
///new 2011-03-10
//compare RDII statistics one analysis to another. . . .
//allow user to select Analyses and / or Condition Assessments
  frmCASelector.Caption :=
    'Select Condition Assessment';
  while (frmCASelector.ShowModal = mrOK) do begin
(*
    //MessageDlg('You chose Condition Assessment "' + frmCASelector.SelectedCA + '" for processing.',
    //mtInformation,[mbok],0);
    frmFeedbackWithMemo.feedbackMemo.Clear;
    frmFeedbackWithMemo.Caption := 'Statistical RDII Analysis for Condition Assessment ' + frmCASelector.SelectedCA;
    CAID := databaseModule.GetCAID4Name(frmCASelector.SelectedCA);
    for i := 0 to 3 do begin
      sAnalysis[i] := databaseModule.GetAnalysisName4CAID(CAID, i+1);
      statisticalanalysisThread.CreateIt(sAnalysis[i]);
      frmFeedbackWithMemo.OpenForProcessing;
    end;
//      frmFeedbackWithMemo.OpenAfterProcessing;
*)
    frmFeedbackWithMemo.Caption := 'Condition Assessment: ' + frmCASelector.SelectedCA;
    CAID := databaseModule.GetCAID4Name(frmCASelector.SelectedCA);
    for i := 0 to 3 do begin
      sAnalysis[i] := databaseModule.GetAnalysisName4CAID(CAID, i+1);
      analysisID := DatabaseModule.GetAnalysisIDForName(sAnalysis[i]);
      Addline('Analysis ' + sAnalysis[i]);
      Addline('------------------------------------');
      events := DatabaseModule.GetEvents(analysisID);
      myEventStatGetter := TEventStatGetter.Create(analysisID);
      Ravg := 0.0;
      RFtot := 0.0;
      for j := 1 to events.count do begin
        myEventStatGetter.GetEventStats(j);
        Addline(' Event number ' + inttostr(j) +
          ' Start Date: ' + FormatDateTime('ddddd hh:MM',myEventStatGetter.StartDate) +
          ' End Date: ' + FormatDateTime('ddddd hh:MM',myEventStatGetter.EndDate));
        Addline(' Total Event Rain Depth:   ' + FormatFloat('0.00', myEventStatGetter.rainVolume));
        Addline(' Total Event R (observed): ' + FormatFloat('0.000', myEventStatGetter.eventTotalR));
        Addline(' Total Event II Vol (obs): ' + FormatFloat('0.00', myEventStatGetter.iiVolume));
        Addline(' Total Event II Depth(obs):' + FormatFloat('0.00', myEventStatGetter.iiDepth));
        Addline(' Peak Event II Flow): ' + FormatFloat('0.00', myEventStatGetter.peakIIFlow));
        Addline(' Peak Event Flow: ' + FormatFloat('0.00', myEventStatGetter.peakObservedFlow));
        Addline(' Average Event Flow: ' + FormatFloat('0.00', myEventStatGetter.averageObservedFlow));
//        peakfctr
//        peakwwf
//        fbwwsum
//        RDIIperLF
//        RDIIgalperLF
        //Addline(' Event Peak Factor: ' + FormatFloat('0.00', myEventStatGetter.peakfctr));
        //Addline(' Event Peak WW Flow: ' + FormatFloat('0.00', myEventStatGetter.peakwwf));
        //Addline(' Event BWW Flow: ' + FormatFloat('0.00', myEventStatGetter.fbwwsum));
        Addline(' Event RDII per LF Sewer: ' + FormatFloat('0.00', myEventStatGetter.RDIIperLF));
        Addline(' Event RDII gal per LF Sewer: ' + FormatFloat('0.00', myEventStatGetter.RDIIgalperLF));
        Addline('------------------------------------');
        Ravg := Ravg + myEventStatGetter.eventTotalR * myEventStatGetter.rainVolume;
        RFTot := RFTot + myEventStatGetter.rainVolume;
      end;
      myEventStatGetter.AllDone;
      if RFTot > 0 then Ravg := Ravg / RFTot;
      AddLine('Analysis Total Event Rain Depth:   ' + FormatFloat('0.000', RFTot));
      AddLine('Analysis Total Event R (observed): ' + FormatFloat('0.000', Ravg));
      Addline('------------------------------------');
    end;
    //Addline('------------------------------------');
    frmFeedbackWithMemo.OpenAfterProcessing;

  end;

end;

procedure TfrmMain.MenuItemLinktoTechnicalReportClick(Sender: TObject);
var myFileRunner: TFileRun;
begin
{
messagedlg('Link to Technical Report: Computer Tools ' +
'for Sanitary Sewer System Capacity Analysis and Planning.pdf',
mtinformation,[mbok],0);
}
  myFileRunner := TFileRun.Create(Self);
  myFileRunner.FileName := TechReportPDFLink;
  myFileRunner.Execute;
  myFileRunner.Free;
end;

procedure TfrmMain.MenuItemRDIIRankingClick(Sender: TObject);
var mr: integer;
begin
//rank analyses by RDII
  frmCAAnalysisChooser.InitializeLists;
  mr := mrOK;
  while mr = mrOK do begin
    //frmCAAnalysisChooser.InitializeLists;
    mr := frmCAAnalysisChooser.ShowModal;
    if (mr = mrOK) then begin
      // if multiple scenario selected - goto this is .pas/.dfm designed for 2/3 graphs
      frmCARDIIRankingGraph.ShowModal;
      // if single scenario selected - goto this .pas/.dfm designed for single graph only
    end;
  end;
end;

procedure TfrmMain.MenuItemSecondOrderRegressionClick(Sender: TObject);
begin
//new 2007-11-12 Perform a Second-Order Linear Regression

end;

procedure TfrmMain.RainfallAnalysis1Click(Sender: TObject);
begin
  frmRainfallCharacteristicAnalysis.ShowModal;
end;

procedure TfrmMain.RainfallData1Click(Sender: TObject);
begin
  frmRainConverterManagement.ShowModal;
  {on exit from rainfall converter configuration, update the menu availability}
  if (DatabaseModule.GetRainConverterNames.Count > 0)
    then MenuItemRainfallImport.Enabled := True
    else MenuItemRainfallImport.Enabled := False;
end;

procedure TfrmMain.RainfallData2Click(Sender: TObject);
begin
  frmImportRainDataUsingConverter.ShowModal;
end;

procedure TfrmMain.RainfallData3Click(Sender: TObject);
begin
  frmExportPRNTRAINTabular.ShowModal;

end;

procedure TfrmMain.RainfallDataAnalysis1Click(Sender: TObject);
begin
  frmRainfallCharacteristicAnalysis.ShowModal;
end;

procedure TfrmMain.RainfallDataReview1Click(Sender: TObject);
begin
  frmRainfallReview.ShowModal;
end;

procedure TfrmMain.RainfallIntensityStatistics1Click(Sender: TObject);
begin
  frmRainfallIntensityStatistics.ShowModal;
end;

procedure TfrmMain.CalculatedvsSimulatedRDIISummaryStatistics1Click(
  Sender: TObject);
begin
  frmComparisonSummary.ShowModal;
end;

procedure TfrmMain.RDIIAreaData1Click(Sender: TObject);
var numSewerSheds, numRDIIAreas: integer;
begin
//Import RDII Area Data Using a RDIIArea Data converter
  frmImportRDIIAreaDataUsingConverter.ShowModal;
  numSewerSheds := GetSewerShedCount;
end;

procedure TfrmMain.RDIIAreaData2Click(Sender: TObject);
begin
//Define the attributes of a RDIIArea Data Converter
  frmRDIIAreaConverterManagement.ShowModal;
  if (DatabaseModule.GetRDIIAreaConverterNames.Count > 0)
    then MenuItemRDIIAreaImport.Enabled := True
    else MenuItemRDIIAreaImport.Enabled := False;
end;

procedure TfrmMain.RDIIAreaSetup1Click(Sender: TObject);
var numSewerSheds, numRDIIAreas: integer;
begin
  frmRDIIAreaManagement.ShowModal;
  numRDIIAreas := GetRDIIAreaCount;
end;

procedure TfrmMain.ViewDryWeatherFlowStatistics1Click(Sender: TObject);
var
  meterName, flowUnitLabel: string;
  meterID: integer;
  maxAvg, avg, minAvg: real;
begin
//  if (frmFlowMeterSelector.ShowModal = mrOK) then begin
  frmFlowMeterSelector.Caption :=
    stringreplace((Sender as TMenuItem).Caption, '&', '', [rfReplaceAll, rfIgnoreCase]);
  while (frmFlowMeterSelector.ShowModal = mrOK) do begin
    meterName := frmFlowMeterSelector.SelectedMeter;
    meterID := DatabaseModule.GetMeterIDForName(meterName);
    flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(meterName);
    frmFeedbackWithMemo.Caption := 'DWF Statistics';
    frmFeedbackWithMemo.feedbackMemo.Clear;
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('Dry Weather Flow Statistics for Meter '+meterName);
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('Flows are in '+flowUnitLabel);
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('');
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('           Average Maximum   Average   Average Minimum');
    DataBaseModule.GetDryWeatherFlowStatistics(meterID,0,maxAvg,avg,minAvg);
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('Weekday'+
      leftpad(floattostrF(maxAvg,ffFixed,15,4),14)+
      leftpad(floattostrF(avg,ffFixed,15,4),14)+
      leftpad(floattostrF(minAvg,ffFixed,15,4),14));

    DataBaseModule.GetDryWeatherFlowStatistics(meterID,1,maxAvg,avg,minAvg);
    frmFeedbackWithMemo.feedbackMemo.Lines.Add('Weekend'+
      leftpad(floattostrF(maxAvg,ffFixed,15,4),14)+
      leftpad(floattostrF(avg,ffFixed,15,4),14)+
      leftpad(floattostrF(minAvg,ffFixed,15,4),14));
    frmFeedbackWithMemo.StatusLabel.Caption := '';
    frmFeedbackWithMemo.DateLabel.Caption := '';
    frmFeedbackWithMemo.OpenAfterProcessing;
  end;
end;

procedure TfrmMain.HelpHandler_Universal(Sender: TObject);
var str_Name, str_html, str_Cmd: string;
    p_html: PAnsiChar;
begin
//this is the Global Help Handler
//each form with a HELP button on it calls this from that button
//Sender is the FORM that the button is on.Self
//  with Sender as TForm do
    //MessageDlg('So you need help on the ' + Name + ' form?',
//    MessageDlg('Help is under development. Thank you for your patience.',
//    mtInformation, [mbok], 0);

{
  str_Cmd := 'hh ' + Application.HelpFile + '::/';
  str_html := 'introduction.htm';
  with Sender as TForm do begin
    if Name = 'frmIIGraph' then
      str_html := 'rdii_graph.htm'
    else if Name = 'frmRTKPatternManager' then
      str_html := 'rtk_data_pattern_management.htm'
    else if Name = 'frmRTKPatternConverterManager' then
      str_html := 'rtk_data_pattern_management.htm'
    else if Name = 'frmAddRDIIAreaDataConverter' then
      str_html := ''
    else if Name = 'frmAddEditHoliday' then
      str_html := 'define_holiday.htm'
    else if Name = 'frmHolidayTable' then
      str_html := 'define_holiday.htm'
    else if Name = 'frmImportFlowDataUsingConverter' then
      str_html := 'importing_the_flow_monitoring_.htm'
    else if Name = 'frmAddFlowMeterDataConverter' then
      str_html := 'define_input_flow_data_format.htm'
    else if Name = 'addrainconverter' then
      str_html := ''
    else if Name = 'addrdiiconverter' then
      str_html := ''
    else if Name = 'AddRTKPatternConverter' then
      str_html := ''
    else if Name = 'addsewershedconverter' then
      str_html := ''
    else if Name = 'analysismanager' then
      str_html := ''
    else if Name = 'autodayremoval' then
      str_html := ''
    else if Name = 'frmAutomaticEventIdentification' then
      str_html := 'automatic_rdii_event_identific.htm'
    else if Name = 'automaticgwiadjcalc' then
      str_html := 'refin_dwf_adjustment_data.htm'
    else if Name = 'frmRTKPatternAssignment' then
      str_html := ''
    else if Name = 'frmImportSewerShedDataUsingConverter' then
      str_html := 'import_sewershed_data.htm'
    else if Name = '' then
      str_html := ''
    else if Name = '' then
      str_html := ''
    else if Name = '' then
      str_html := ''
    else if Name = '' then
      str_html := ''
    else if Name = '' then
      str_html := ''
    else if Name = '' then
      str_html := ''
    else if Name = '' then
      str_html := ''
    else if Name = '' then
      str_html := ''
    else if Name = '' then
      str_html := ''
    else if Name = '' then
      str_html := ''
    else if Name = '' then
      str_html := '';
  end;

}
  str_Name := (Sender as TForm).Name;
  str_Cmd := 'hh ' + Application.HelpFile + '::/';
  //str_html := 'introduction.htm';
  str_html := '';
  with Sender as TForm do begin
    if Name = 'frmMain' then
      str_html := 'introduction.htm'
    else if Name = 'frmIIGraph' then
      str_html := 'rdii_graph.htm'
    else if str_Name = 'frmRTKPatternManager' then
      str_html := 'rtk_data_pattern_management.htm'
    else if str_Name = 'frmRTKPatternConverterManager' then
      str_html := 'rtk_data_pattern_management.htm'
    else if str_Name = 'frmAddRDIIAreaDataConverter' then
      str_html := 'define_input_sewershed_data_fo.htm'
    else if str_Name = 'frmAddEditHoliday' then
      str_html := 'define_holiday.htm'
    else if str_Name = 'frmHolidayTable' then
      str_html := 'define_holiday.htm'
    else if str_Name = 'frmImportFlowDataUsingConverter' then
      str_html := 'importing_the_flow_monitoring_.htm'
    else if str_Name = 'frmAddFlowMeterDataConverter' then
      str_html := 'define_input_flow_data_format.htm'
    else if str_Name = 'frmAddRainDataConverter' then
      str_html := 'define_input_rainfall_data_for.htm'
    else if str_Name = 'frmAddRdiiDataConverter' then
      str_html := 'define_input_sewershed_data_fo.htm'
    else if str_Name = 'frmAddRTKPatternConverter' then
      str_html := 'rtk_data_pattern_management.htm'
    else if str_Name = 'frmAddSewerShedDataConverter' then
      str_html := 'define_input_sewershed_data_fo.htm'
    else if str_Name = 'frmAnalysisManagement' then
      str_html := 'analysis_management.htm'
    else if str_Name = 'autodayremoval' then
      str_html := 'automatic_dwf_day_determinatio.htm'
    else if str_Name = 'frmAutomaticEventIdentification' then
      str_html := 'automatic_rdii_event_identific.htm'
    else if str_Name = 'frmAutomaticGWIAdjustmentCalculation' then
      str_html := 'refin_dwf_adjustment_data.htm'
    else if str_Name = 'frmRTKPatternAssignment' then
      str_html := 'linking_sewersheds_rdii_areas_.htm'
    else if str_Name = 'frmImportSewerShedDataUsingConverter' then
      str_html := 'import_sewershed_data.htm'
    else if str_Name = 'frmAddSewerShedDataConverter' then
      str_html := 'define_input_sewershed_data_fo.htm'
    else if str_Name = 'frmAddFlowMeterDataConverter' then
      str_html := 'define_input_flow_data_format.htm'
    else if str_Name = 'frmAddRdiiDataConverter' then
      str_html := 'define_input_sewershed_data_fo.htm'
    else if str_Name = 'frmAddRTKPatternConverter' then
      str_html := 'rtk_data_pattern_management.htm'
    else if str_Name = 'frmAddSewerShedDataConverter' then
      str_html := 'define_input_sewershed_data_fo.htm'
    else if str_Name = 'frmAnalysisManagement' then
      str_html := 'analysis_management.htm'
    else if str_Name = 'frmAutomaticDayRemoval' then
      str_html := 'automatic_dwf_day_determinatio.htm'
    else if str_Name = 'frmRDIIAreaConverterManagement' then
      str_html := 'define_input_sewershed_data_fo.htm'
    else if str_Name = 'frmRDIIAreaManagement' then
      str_html := 'contributory_area__sewersheds_.htm'
    else if str_Name = 'frmAnalysisSelector' then
      str_html := 'analysis_management.htm'
    //else if str_Name = 'frmFlowMeterSelector' then
    //  str_html := ''
    //else if str_Name = 'frmComparisonSummary' then
    //  str_html := ''
    else if str_Name = 'frmDryWeatherHydrographsForm' then
      str_html := 'viewing_average_dwf_hydrograph.htm'
    else if str_Name = 'frmAddNewAnalysis' then
      str_html := 'add_an_analysis.htm'
    else if str_Name = 'frmEditAnalysis' then
      str_html := 'add_an_analysis.htm'
    else if str_Name = 'frmEditCatchment' then
      str_html := 'add_define_sewershed_dataset.htm'
    else if str_Name = 'frmEditFlowMeterDataConverter' then
      str_html := 'define_input_flow_data_format.htm'
    else if str_Name = 'frmEditMeter' then
      str_html := 'define_input_flow_data_format.htm'
    else if str_Name = 'frmEditRaingauge' then
      str_html := 'define_input_rainfall_data_for.htm'
    else if str_Name = 'frmEditRdiiDataConverter' then
      str_html := 'define_input_sewershed_data_fo.htm'
    else if str_Name = 'frmEditScenario' then
      str_html := 'edit_an_existing_scenario.htm'
    else if str_Name = 'frmEditSewershed' then
      str_html := 'add_define_sewershed_dataset.htm'
    else if str_Name = 'frmEditSewerShedDataConverter' then
      str_html := 'define_input_sewershed_data_fo.htm'
    else if str_Name = 'frmEventEdit' then
      str_html := 'rdii_event_edit_window.htm'
    //else if str_Name = 'frmEventStatisitics' then
    //  str_html := ''
    else if str_Name = 'frmExportRDIIHydrographs' then
      str_html := 'export_rdii_hydrograph.htm'
    else if str_Name = 'frmFillInMissingDataForm' then
      str_html := 'fill_in_missing_flow_data.htm'
    else if str_Name = 'frmFlowConverterManagement' then
      str_html := 'define_input_flow_data_format.htm'
    else if str_Name = 'frmFlowMeterManagement' then
      str_html := 'flow_data_management.htm'
    //else if str_Name = 'frmFlowUnitManagement' then
    //  str_html := ''
    //else if str_Name = 'frmGWIAdjustmentTable' then
    //  str_html := ''
    //else if str_Name = 'frmHydrographGeneration' then
    //  str_html := ''
    //else if str_Name = 'frmHydrographGeneration2' then
    //  str_html := ''
    else if str_Name = 'frmImportRDIIAreaDataUsingConverter' then
      str_html := 'importing_the_sewershed_data.htm'
    else if str_Name = 'frmImportRainDataUsingConverter' then
      str_html := 'importing_the_rainfall_data.htm'
    else if str_Name = 'frmImportRdiiDataUsingConverter' then
      str_html := 'importing_the_sewershed_data.htm'
    else if str_Name = 'frmImportRTKPatternData' then
      str_html := 'rtk_data_pattern_management.htm'   //???
    else if str_Name = 'frmMinimumNighttimeFlows' then
      str_html := 'determining_minimum_nighttime_.htm'
    else if str_Name = 'frmAddNewGauge' then
      str_html := 'add_rain_gauge.htm'
    else if str_Name = 'frmAddNewMeter' then
      str_html := 'add_flow_meter.htm'
    else if str_Name = 'frmAddNewScenario' then
      str_html := 'scenario.htm'
    //else if str_Name = 'frmObsVsSimPlot' then
    //  str_html := ''
    else if str_Name = 'frmRainConverterManagement' then
      str_html := 'define_input_rainfall_data_for.htm'
    else if str_Name = 'frmRainfallCharacteristicAnalysis' then
      str_html := 'rainfall_data_analysis_utility.htm'
    //else if str_Name = 'frmRainfallReview' then
    //  str_html := ''
    else if str_Name = 'frmRainfallIntensityStatistics' then
      str_html := 'rainfall_data_analysis_utility.htm'
    else if str_Name = 'frmRDIIExport' then
      str_html := 'working_with_rdii_hydrograph_g.htm'
    else if str_Name = 'frmRTKPatternEditor' then
      str_html := 'create_or_modify_rtk_pattern.htm'
    //else if str_Name = 'frmScenarioComparison' then
    //  str_html := ''
    else if str_Name = 'frmScenarioManagement' then
      str_html := 'scenario_utility.htm'
    else if str_Name = 'frmSelScenario4RTKAssignment' then
      str_html := 'scenario.htm'
    //else if str_Name = 'frmSW5Exporter' then
    //  str_html := ''
    else if str_Name = 'frmSWMM5ResultsImport1' then
      str_html := 'importing_hydraulic_routing_re.htm'
    else if str_Name = 'frmWriteAllFlows' then
      str_html := 'write_all_flows.htm'
    //else if str_Name = 'TSGrapherForm' then
    //  str_html := ''
    else if str_Name = 'frmRaingaugeManagement' then
      str_html := 'rainfall_data_management.htm'
    else if str_Name = 'frmSewershedManagement' then
      str_html := 'sewershed_data_management.htm'
    else if str_Name = 'frmSewershedConverterManagement' then
      str_html := 'define_input_sewershed_data_fo.htm'
    else if str_Name = 'frmAnalysisManagement' then
      str_html := 'analysis_management.htm'
    else if str_Name = 'frmEventExport' then
      str_html := 'export_rdii_hydrograph.htm'
    else if str_Name = 'frmEventImport' then
      str_html := 'import_rdii_events.htm'
    else if str_Name = 'frmWriteDailyAverageFlows' then
      str_html := 'write_all_flows.htm'
    else if str_Name = 'frmScenarioMangement' then
      str_html := 'scenario_utility.htm'
    else if str_Name = 'frmSWMM5ResultsImport2' then
      str_html := 'importing_hydraulic_routing_re.htm'
    else if str_Name = 'frmRDIIConverterManagement' then
      str_html := 'define_input_sewershed_data_fo.htm'
    else if str_Name = 'frmExportPRINTRAINTabular' then
      str_html := 'rainfall_intensity_statistics.htm'
    else if str_Name = 'frmMinimumNighttimeFlows' then
      str_html := 'determining_minimum_nighttime_.htm'
    else if str_Name = 'frmSWMM5ImportResults1' then
      str_html := 'importing_hydraulic_routing_re.htm'
    else if str_Name = 'frmManualDWFDaySelection' then
      str_html := 'manual_dwf_day_removal.htm'
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := ''
    else if str_Name = '' then
      str_html := '';

  end;

  {
  if (str_html = '') then begin
    MessageDlg('Links to specific Help Pages are under development. Thank you for your patience.',
      mtInformation, [mbok], 0);
    showmessage('Form Name = "' + str_Name + '"' + Char(13) + char(10) +
      'Help Page Name = "' + str_html + '"');
    str_html := 'introduction.htm';
  end else begin
    showmessage('Form Name = "' + str_Name + '"' + Char(13) + char(10) +
      'Help Page Name = "' + str_html + '"');
  end;
  }

  WinExec(PChar(str_Cmd + str_html), SW_SHOW);

end;

procedure TfrmMain.Holidays1Click(Sender: TObject);
begin
  frmHolidayTable.ShowModal;
end;

procedure TfrmMain.Contents1Click(Sender: TObject);
begin
////  MessageDlg('Integrated online help is not available in this version'+#13
////            +'of Windows RDII.  Please refer to the electronic manual'+#13
////            +'that was installed with the program.',mtCustom,[mbOK],0);
//  MessageDlg('Integrated online help is under development'+#13
//            +'Please refer to the electronic manual'+#13
//            +'that was installed with the program.',mtCustom,[mbOK],0);
  HelpHandler_Universal(Self);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not (connection = nil) then begin
    CloseDatabase;
    //messageDlg('sdfsdfsfsfd',mtError,[mbOK],0);
  end;
end;


//following is from Fmain.pas of EPA SWMM 5.0 GUI Source:
//=============================================================================
//                    Procedures for Running a Simulation
//=============================================================================

procedure TfrmMain.ExecuteSWMM5;
//-----------------------------------------------------------------------------
// Executes the command line (console) version of the SWMM engine.
//-----------------------------------------------------------------------------
const
  strEXEName = 'swmm5.exe';
var
  myFileRunner: TFileRun;
  strPath, mySWMM5Input, strRPTFile, strOUTFile: String;
begin
  strPath := GetEPASwmm5Folder;
  myFileRunner := TFileRun.Create(Self);
  myFileRunner.FileName := '"' + strPath + strEXEName + '"';
  //let user browse for input file to open
  myFileRunner.BrowseDlg.Filter := 'SWMM5 Input Files (*.INP)|*.INP';
  myFileRunner.BrowseDlg.Title := 'Run SWMM5.EXE';
  if myFileRunner.BrowseDlg.Execute then begin
    strRPTFile := ChangeFileExt(myFileRunner.BrowseDlg.FileName, '.RPT');
    strOUTFile := ChangeFileExt(myFileRunner.BrowseDlg.FileName, '.OUT');
    myFileRunner.Parameters :=  '"' + myFileRunner.BrowseDlg.FileName + '" ' +
    ' "' + strRPTFile + '" "' + strOUTFile + '"';
    //messagedlg(myFileRunner.Parameters,mtInformation,[mbok],0);
    myFileRunner.Execute;
  end;
  myFileRunner.Free;

end;
procedure TfrmMain.enableMenusAfterOpeningDatabase();
var
  flowMetersDefined, raingaugesDefined: boolean;
  numFlowMeters, numRainGauges, numAnalyses,
  numSewerSheds, numRTKPAtterns, numScenarios: integer;
begin
  MenuItemFileNew.Enabled := False;
  MenuItemFileOpen.Enabled:= False;
  MenuItemFileClose.Enabled := True;
  MenuItemDataManagementTool.Enabled := true;
  MenuItemRDIIAnalysisTool.Enabled := true;
  MenuItemHydrographGenerationTool.Enabled := true;
  MenuItemSWMM5InterfacingTool.Enabled := true;
  MenuItemFlowMonitorData.Enabled := true;
  MenuItemRainfallData.Enabled := true;
  MenuItemSewershedData.Enabled := true;
  MenuItemRDIIAreaData.Enabled := true;
  //rm 2007-10-15 - get counts
  numFlowMeters := GetFlowMeterCount;
  numRainGauges := GetRaingaugeCount;
  numAnalyses := GetAnalysisCount;
  numSewerSheds := GetSewershedCount;
  numRTKPatterns := GetRTKPatternCount;
  numScenarios := GetScenarioCount;
  //Data Management Tool - central button -
  hotspots[3].Hint := ExtractFileName(fname);
  hotspots[3].Enabled := true;
  flowMetersDefined := numFlowMeters > 0;
  rainGaugesDefined := numRainGauges > 0;
  MenuItemFlowMonitorImport.Enabled := (DatabaseModule.GetFlowConverterNames.Count > 0);
  MenuItemRainfallImport.Enabled := (DatabaseModule.GetRainConverterNames.Count > 0);
  MenuItemSewershedImport.Enabled := (DatabaseModule.GetSewerShedConverterNames.Count > 0);
  MenuItemRDIIAreaImport.Enabled := (DatabaseModule.GetRDIIAreaConverterNames.Count > 0);
  MenuItemRTKPatternImport.Enabled := (DatabaseModule.GetRTKPatternConverterNames.Count > 0);
  if (raingaugesDefined and flowMetersDefined) then begin
    MenuItemAnalysisManagement.Enabled := true;
  end else begin
    MenuItemAnalysisManagement.Enabled := false;
  end;
  MenuItemConditionAssessmentTool.Enabled := true;

end;


procedure TfrmMain.SetHotSpot(hotspType: string; num1, num2: integer);
begin
  if hotspType = 'Sewershed' then begin
    hotspots[2].Hint := inttostr(num1) + ' ' + hotspType;
    if num1 <> 1 then
      hotspots[2].Hint := hotspots[2].Hint + 's';
    hotspots[2].Hint := hotspots[2].Hint + Chr(13) +
      inttostr(num2) + ' RDII Area';
    if num2 <> 1 then
      hotspots[2].Hint := hotspots[2].Hint + 's';
    hotspots[2].Enabled := ((num1 > 0) or (num2 > 0));
  end else if hotspType = 'Flow Meter' then begin
    hotspots[1].Hint := inttostr(num1) + ' ' + hotspType;
    if num1 <> 1 then
      hotspots[1].Hint := hotspots[1].Hint + 's';
    hotspots[1].Enabled := (num1 > 0);
  end else if hotspType = 'Rain Gauge' then begin
    hotspots[0].Hint := inttostr(num1) + ' ' + hotspType;
    if num1 <> 1 then
      hotspots[0].Hint := hotspots[0].Hint + 's';
    hotspots[0].Enabled := (num1 > 0);
  end else if hotspType = 'Analysis' then begin
    if num1 <> 1 then
      hotspots[5].Hint := inttostr(num1) + ' Analyses'
    else
      hotspots[5].Hint := inttostr(num1) + ' ' + hotspType;
    hotspots[5].Enabled := (num1 > 0);
    hotspots[11].Enabled := hotspots[5].Enabled;
  end else if hotspType = 'RTK Pattern' then begin
    hotspots[6].Hint := inttostr(num1) + ' ' + hotspType;
    if num1 <> 1 then
      hotspots[6].Hint := hotspots[6].Hint + 's';
    hotspots[6].Enabled := (num1 > 0);
  end else if hotspType = 'Scenario' then begin
    hotspots[9].Hint := inttostr(num1) + ' ' + hotspType;
    if num1 <> 1 then
      hotspots[9].Hint := hotspots[9].Hint + 's';
    hotspots[9].Enabled := (num1 > 0);
  end;
end;


end.
