program SSOAPToolbox;

{%Icon 'Epa2.ico'}

uses
  Forms,
  mainform in 'mainform.pas' {frmMain},
  addflowconverter in 'addflowconverter.pas' {frmAddFlowMeterDataConverter},
  addrainconverter in 'addrainconverter.pas' {frmAddRainDataConverter},
  flowconvertermanager in 'flowconvertermanager.pas' {frmFlowConverterManagement},
  rainconvertermanager in 'rainconvertermanager.pas' {frmRainConverterManagement},
  importflowdata in 'importflowdata.pas' {frmImportFlowDataUsingConverter},
  importraindata in 'importraindata.pas' {frmImportRainDataUsingConverter},
  flowunitmanager in 'flowunitmanager.pas' {frmFlowUnitManagement},
  rainunitmanager in 'rainunitmanager.pas' {frmRainUnitManagement},
  autodayremoval in 'autodayremoval.pas' {frmAutomaticDayRemoval},
  automaticeventdef in 'automaticeventdef.pas' {frmAutomaticEventIdentification},
  newmeter in 'newmeter.pas' {frmAddNewMeter},
  fillinmissingdata in 'fillinmissingdata.pas' {frmFillInMissingDataForm},
  newGauge in 'newGauge.pas' {frmAddNewGauge},
  convertraintimestep in 'convertraintimestep.pas' {frmConvertRainTimeStep},
  newAnalysis in 'newAnalysis.pas' {frmAddNewAnalysis},
  StormEvent in 'StormEvent.pas',
  StormEventCollection in 'StormEventCollection.pas',
  gwiadjustmentcollection in 'gwiadjustmentcollection.pas',
  dryweatherhydrographs in 'dryweatherhydrographs.pas' {frmDryWeatherHydrographsForm},
  iigraph in 'iigraph.pas' {frmIIGraph},
  onegraph in 'onegraph.pas' {frmManualDWFDaySelection},
  editflowdataconverter in 'editflowdataconverter.pas' {frmEditFlowMeterDataConverter},
  editraindataconverter in 'editraindataconverter.pas' {frmEditRainDataConverter},
  importflowdatafromCONFile in 'importflowdatafromCONFile.pas' {frmImportFlowFromCONFile},
  exportprntflowcsv in 'exportprntflowcsv.pas' {frmExportPRNTFLOWCSV},
  exportmaxminavgflow in 'exportmaxminavgflow.pas' {frmExportMaxMinAvg},
  editmeter in 'editmeter.pas' {frmEditMeter},
  flowmetermanager in 'flowmetermanager.pas' {frmFlowMeterManagement},
  rtkpatternmanager in 'rtkpatternmanager.pas' {frmRTKPatternManager},
  editraingauge in 'editraingauge.pas' {frmEditRaingauge},
  importrainfalldatafromCONfile in 'importrainfalldatafromCONfile.pas' {frmImportRainfallFromCONFile},
  exportprntraintabular in 'exportprntraintabular.pas' {frmExportPRNTRAINTabular},
  CAmanager in 'CAmanager.pas' {frmCAManagement},
  editanalysis in 'editanalysis.pas' {frmEditAnalysis},
  automaticgwiadjcalc in 'automaticgwiadjcalc.pas' {frmAutomaticGWIAdjustmentCalculation},
  hydrograph in 'hydrograph.pas',
  chooseFlowMeter in 'chooseFlowMeter.pas' {frmFlowMeterSelector},
  conFlowImportThread in 'conFlowImportThread.pas',
  conRainImportThread in 'conRainImportThread.pas',
  flowConverterImportThread in 'flowConverterImportThread.pas',
  rainfallConverterImportThread in 'rainfallConverterImportThread.pas',
  ExportPRNTFLOWThread in 'ExportPRNTFLOWThread.pas',
  ExportMMADYThread in 'ExportMMADYThread.pas',
  ExportPRNTRAINThread in 'ExportPRNTRAINThread.pas',
  feedbackWithMemo in 'feedbackWithMemo.pas' {frmFeedbackWithMemo},
  autodayremovalthread in 'autodayremovalthread.pas',
  MinimumNighttimeFlows in 'MinimumNighttimeFlows.pas' {frmMinimumNighttimeFlows},
  nighttimeFlowsThread in 'nighttimeFlowsThread.pas',
  autowiadjcalcthread in 'autowiadjcalcthread.pas',
  autoeventdefThread in 'autoeventdefThread.pas',
  eventSummary in 'eventSummary.pas' {frmEventStatisitics},
  writeAllFlows in 'writeAllFlows.pas' {frmWriteAllFlows},
  writeDailyAverageFlows in 'writeDailyAverageFlows.pas' {frmWriteDailyAverageFlows},
  chooseAnalysis in 'chooseAnalysis.pas' {frmAnalysisSelector},
  writeAllFlowsThrd in 'writeAllFlowsThrd.pas',
  writeDailyAverageFlowsThrd in 'writeDailyAverageFlowsThrd.pas',
  fillinMissingFlowDataThrd in 'fillinMissingFlowDataThrd.pas',
  rdiiutils in 'rdiiutils.pas',
  convertraintimestepThrd in 'convertraintimestepThrd.pas',
  DataAddReplace in 'DataAddReplace.pas' {frmDataAddReplace},
  eventExport in 'eventExport.pas' {frmEventExport},
  importevents in 'importevents.pas' {frmEventImport},
  existEventsWarning in 'existEventsWarning.pas' {frmEventsExistWarning},
  rainfallIntensityStatistics in 'rainfallIntensityStatistics.pas' {frmRainfallIntensityStatistics},
  computedVsSimulatedRDIISummaryStatistics in 'computedVsSimulatedRDIISummaryStatistics.pas' {frmComparisonSummary},
  obsvssim in 'obsvssim.pas' {frmObsVsSimPlot},
  HolidayCollection in 'HolidayCollection.pas',
  eventEdit in 'eventEdit.pas' {frmEventEdit},
  analysis in 'analysis.pas',
  ADODB_TLB in 'ADODB_TLB.pas',
  GWIAdjustment in 'GWIAdjustment.pas',
  modDatabase in 'modDatabase.pas' {DataModule1: TDataModule},
  scattergraph in 'scattergraph.pas' {frmScatterGraph},
  catchmentconvertermanager in 'catchmentconvertermanager.pas' {frmRDIIAreaConverterManagement},
  addrdiiconverter in 'addrdiiconverter.pas' {frmAddRdiiDataConverter},
  editrdiidataconverter in 'editrdiidataconverter.pas' {frmEditRdiiDataConverter},
  rdiiConverterImportThread in 'rdiiConverterImportThread.pas',
  importrdiidata in 'importrdiidata.pas' {frmImportRdiiDataUsingConverter},
  importcatchmentdata in 'importcatchmentdata.pas' {frmImportRDIIAreaDataUsingConverter},
  catchmentmanager in 'catchmentmanager.pas' {frmRDIIAreaManagement},
  editcatchment in 'editcatchment.pas' {frmEditCatchment},
  ChartfxLib_TLB in 'ChartfxLib_TLB.pas',
  RainfallCharacteristicAnalysisThrd in 'RainfallCharacteristicAnalysisThrd.pas',
  RainfallCharacteristicAnalysis in 'RainfallCharacteristicAnalysis.pas' {frmRainfallCharacteristicAnalysis},
  LinearRegressionAnalysis in 'LinearRegressionAnalysis.pas' {frmLinearRegressionAnalysis},
  DvsVselector in 'DvsVselector.pas' {frmScatterGraphSelector},
  scenariomanager in 'scenariomanager.pas' {frmScenarioManagement},
  newscenario in 'newscenario.pas' {frmAddNewScenario},
  editscenario in 'editscenario.pas' {frmEditScenario},
  SWMM5resultsImport1 in 'SWMM5resultsImport1.pas' {frmSWMM5ResultsImport1},
  swmm5_iface in 'swmm5_iface.pas',
  scenarioComparison in 'scenarioComparison.pas' {frmScenarioComparison},
  rdiiconvertermanager in 'rdiiconvertermanager.pas',
  addcatchmentconverter in 'addcatchmentconverter.pas' {frmAddRDIIAreaDataConverter},
  editsewersheddataconverter in 'editsewersheddataconverter.pas' {frmEditSewerShedDataConverter},
  catchmentConverterImportThread in 'catchmentConverterImportThread.pas',
  GWIAdjustmentsTable in 'GWIAdjustmentsTable.pas' {frmGWIAdjustmentTable},
  EventsTable in 'EventsTable.pas' {frmEventsTable},
  RainfallDataReview in 'RainfallDataReview.pas' {frmRainfallReview},
  scattergraphDF in 'scattergraphDF.pas' {frmScatterGraphDF},
  sewershedconvertermanager in 'sewershedconvertermanager.pas' {frmSewershedConverterManagement},
  addsewershedconverter in 'addsewershedconverter.pas' {frmAddSewerShedDataConverter},
  sewershedmanager in 'sewershedmanager.pas' {frmSewershedManagement},
  editsewershed in 'editsewershed.pas' {frmEditSewershed},
  importsewersheddata in 'importsewersheddata.pas' {frmImportSewerShedDataUsingConverter},
  sewershedConverterImportThread in 'sewershedConverterImportThread.pas',
  SW5Exporter in 'SW5Exporter.pas' {frmSW5Exporter},
  RDIIGraphFrame in 'RDIIGraphFrame.pas' {FrameRDIIGraph: TFrame},
  RDIIExport in 'RDIIExport.pas' {frmRDIIExport},
  raingaugemanager in 'raingaugemanager.pas' {frmRaingaugeManagement},
  RTKPatternEditor in 'RTKPatternEditor.pas' {frmRTKPatternEditor},
  RTKPatternConverterManager in 'RTKPatternConverterManager.pas' {frmRTKPatternConverterManager},
  AddRTKPatternConverter in 'AddRTKPatternConverter.pas' {frmAddRTKPatternConverter},
  ImportRTKPatternData in 'ImportRTKPatternData.pas' {frmImportRTKPatternData},
  rtkPatternConverterImportThread in 'rtkPatternConverterImportThread.pas',
  RTKPatternFrame in 'RTKPatternFrame.pas' {FrameRTKPattern: TFrame},
  ExportRDIIHydrographs in 'ExportRDIIHydrographs.pas' {frmExportRDIIHydrographs},
  swmm5rdiireaderthread in 'swmm5rdiireaderthread.pas',
  Uutils in 'Uutils.pas',
  swmm5INPrdiiExporterThread in 'swmm5INPrdiiExporterThread.pas',
  SW5InterFaceFile in 'SW5InterFaceFile.pas',
  RTKPatternAssignment in 'RTKPatternAssignment.pas' {frmRTKPatternAssignment},
  SelectScenariotoLaunchRTKAssignment in 'SelectScenariotoLaunchRTKAssignment.pas' {frmSelScenario4RTKAssignment},
  HotSpot in 'HotSpot.pas',
  HolidayTableForm in 'HolidayTableForm.pas' {frmHolidayTable},
  AddEditHolidayForm in 'AddEditHolidayForm.pas' {frmAddEditHoliday},
  frmNodeDepthSelector in 'frmNodeDepthSelector.pas' {NodeSelectorForm},
  frmSSOOutfallSelector in 'frmSSOOutfallSelector.pas' {SSOOutfallForm},
  SWMM5resultsImport2 in 'SWMM5resultsImport2.pas' {frmSWMM5ResultsImport2},
  SWMM5_RDIIImporterForm in 'SWMM5_RDIIImporterForm.pas' {frmSWMM5_RDIIImporter},
  DataImportLogForm in 'DataImportLogForm.pas' {frmDataImportLog},
  frmScenarioGraph in 'frmScenarioGraph.pas' {ScenarioGraphForm},
  frmScenarioConduitGraph in 'frmScenarioConduitGraph.pas' {ScenarioConduitGraphForm},
  about in 'about.pas' {AboutBoxForm},
  statisticalRDIIanalysisThread in 'statisticalRDIIanalysisThread.pas',
  statisticalInformationForMultiRegressionThread in 'statisticalInformationForMultiRegressionThread.pas',
  FlowMonGraphForm in 'FlowMonGraphForm.pas' {frmFlowMonGraph},
  CAChooseAnalyses in 'CAChooseAnalyses.pas' {frmCAAnalysesSelector},
  analysismanager in 'analysismanager.pas' {frmAnalysisManagement},
  chooseCA in 'chooseCA.pas' {frmCASelector},
  CALinearRegressionAnalysis in 'CALinearRegressionAnalysis.pas' {frmCALinearRegressionAnalysis},
  chooseCALinearRegression in 'chooseCALinearRegression.pas' {frmCAChooseLinearRegression},
  frmCAAnalysisAnalyzer in 'frmCAAnalysisAnalyzer.pas' {frmCAAnalysesAnalyzer},
  EventStatGetter in 'EventStatGetter.pas',
  PostRehab_Analysis in 'PostRehab_Analysis.pas' {frmPostRehab_Analysis},
  infoanalysis in 'infoanalysis.pas' {frmInfoAnalysis},
  newComparisonScenario in 'newComparisonScenario.pas' {frmAddComparisonScenario},
  CAAnalysisSetup in 'CAAnalysisSetup.pas' {frmCAAnalysisSetup},
  CAAnalysisChooser2 in 'CAAnalysisChooser2.pas' {frmCAAnalysisChooser2},
  CARDIIRankingGraph2 in 'CARDIIRankingGraph2.pas' {frmCARDIIRankingGraph2},
  RDIIRankingStatGetterUnit in 'RDIIRankingStatGetterUnit.pas',
  CAAnalysisChooser in 'CAAnalysisChooser.pas' {frmCAAnalysisChooser},
  frmTSGrapher in 'frmTSGrapher.pas' {TSGrapherForm},
  frmTSGraph in 'frmTSGraph.pas' {TSGraphForm},
  mychart in 'mychart.PAS';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'SSOAP Toolbox';
  Application.HelpFile := 'C:\Program Files\EPA SSOAP Toolbox\SSOAP_OnlineHelp.chm';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAddFlowMeterDataConverter, frmAddFlowMeterDataConverter);
  Application.CreateForm(TfrmAddRainDataConverter, frmAddRainDataConverter);
  Application.CreateForm(TfrmFlowConverterManagement, frmFlowConverterManagement);
  Application.CreateForm(TfrmRainConverterManagement, frmRainConverterManagement);
  Application.CreateForm(TfrmImportFlowDataUsingConverter, frmImportFlowDataUsingConverter);
  Application.CreateForm(TfrmImportRainDataUsingConverter, frmImportRainDataUsingConverter);
  Application.CreateForm(TfrmFlowUnitManagement, frmFlowUnitManagement);
  Application.CreateForm(TfrmRainUnitManagement, frmRainUnitManagement);
  Application.CreateForm(TfrmAutomaticDayRemoval, frmAutomaticDayRemoval);
  Application.CreateForm(TfrmAutomaticEventIdentification, frmAutomaticEventIdentification);
  Application.CreateForm(TfrmAddNewMeter, frmAddNewMeter);
  Application.CreateForm(TfrmFillInMissingDataForm, frmFillInMissingDataForm);
  Application.CreateForm(TfrmAddNewGauge, frmAddNewGauge);
  Application.CreateForm(TfrmConvertRainTimeStep, frmConvertRainTimeStep);
  Application.CreateForm(TfrmAddNewAnalysis, frmAddNewAnalysis);
  Application.CreateForm(TfrmImportFlowFromCONFile, frmImportFlowFromCONFile);
  Application.CreateForm(TfrmExportPRNTFLOWCSV, frmExportPRNTFLOWCSV);
  Application.CreateForm(TfrmIIGraph, frmIIGraph);
  Application.CreateForm(TfrmExportMaxMinAvg, frmExportMaxMinAvg);
  Application.CreateForm(TfrmEditMeter, frmEditMeter);
  Application.CreateForm(TfrmDryWeatherHydrographsForm, frmDryWeatherHydrographsForm);
  Application.CreateForm(TfrmEditFlowMeterDataConverter, frmEditFlowMeterDataConverter);
  Application.CreateForm(TfrmEditRainDataConverter, frmEditRainDataConverter);
  Application.CreateForm(TfrmFlowMeterManagement, frmFlowMeterManagement);
  Application.CreateForm(TfrmRTKPatternManager, frmRTKPatternManager);
  Application.CreateForm(TfrmEditRaingauge, frmEditRaingauge);
  Application.CreateForm(TfrmImportRainfallFromCONFile, frmImportRainfallFromCONFile);
  Application.CreateForm(TfrmExportPRNTRAINTabular, frmExportPRNTRAINTabular);
  Application.CreateForm(TfrmCAManagement, frmCAManagement);
  Application.CreateForm(TfrmEditAnalysis, frmEditAnalysis);
  Application.CreateForm(TfrmAutomaticGWIAdjustmentCalculation, frmAutomaticGWIAdjustmentCalculation);
  Application.CreateForm(TfrmFlowMeterSelector, frmFlowMeterSelector);
  Application.CreateForm(TfrmFeedbackWithMemo, frmFeedbackWithMemo);
  Application.CreateForm(TfrmMinimumNighttimeFlows, frmMinimumNighttimeFlows);
  Application.CreateForm(TfrmEventStatisitics, frmEventStatisitics);
  Application.CreateForm(TfrmWriteAllFlows, frmWriteAllFlows);
  Application.CreateForm(TfrmWriteDailyAverageFlows, frmWriteDailyAverageFlows);
  Application.CreateForm(TfrmCAAnalysesSelector, frmCAAnalysesSelector);
  Application.CreateForm(TfrmDataAddReplace, frmDataAddReplace);
  Application.CreateForm(TfrmEventExport, frmEventExport);
  Application.CreateForm(TfrmEventImport, frmEventImport);
  Application.CreateForm(TfrmEventsExistWarning, frmEventsExistWarning);
  Application.CreateForm(TfrmRainfallIntensityStatistics, frmRainfallIntensityStatistics);
  Application.CreateForm(TfrmComparisonSummary, frmComparisonSummary);
  Application.CreateForm(TfrmObsVsSimPlot, frmObsVsSimPlot);
  Application.CreateForm(TfrmEventEdit, frmEventEdit);
  Application.CreateForm(TfrmManualDWFDaySelection, frmManualDWFDaySelection);
  Application.CreateForm(TfrmScatterGraph, frmScatterGraph);
  Application.CreateForm(TfrmRdiiConverterManagement, frmRdiiConverterManagement);
  Application.CreateForm(TfrmAddRdiiDataConverter, frmAddRdiiDataConverter);
  Application.CreateForm(TfrmEditRdiiDataConverter, frmEditRdiiDataConverter);
  Application.CreateForm(TfrmImportRdiiDataUsingConverter, frmImportRdiiDataUsingConverter);
  Application.CreateForm(TfrmImportRDIIAreaDataUsingConverter, frmImportRDIIAreaDataUsingConverter);
  Application.CreateForm(TfrmRDIIAreaManagement, frmRDIIAreaManagement);
  Application.CreateForm(TfrmEditCatchment, frmEditCatchment);
  Application.CreateForm(TfrmRainfallCharacteristicAnalysis, frmRainfallCharacteristicAnalysis);
  Application.CreateForm(TfrmLinearRegressionAnalysis, frmLinearRegressionAnalysis);
  Application.CreateForm(TfrmScatterGraphSelector, frmScatterGraphSelector);
  Application.CreateForm(TfrmScenarioManagement, frmScenarioManagement);
  Application.CreateForm(TfrmAddNewScenario, frmAddNewScenario);
  Application.CreateForm(TfrmEditScenario, frmEditScenario);
  Application.CreateForm(TfrmSWMM5ResultsImport1, frmSWMM5ResultsImport1);
  Application.CreateForm(TfrmScenarioComparison, frmScenarioComparison);
  Application.CreateForm(TfrmAddRDIIAreaDataConverter, frmAddRDIIAreaDataConverter);
  Application.CreateForm(TfrmEditSewerShedDataConverter, frmEditSewerShedDataConverter);
  Application.CreateForm(TfrmRDIIAreaConverterManagement, frmRDIIAreaConverterManagement);
  Application.CreateForm(TfrmGWIAdjustmentTable, frmGWIAdjustmentTable);
  Application.CreateForm(TfrmEventsTable, frmEventsTable);
  Application.CreateForm(TfrmRainfallReview, frmRainfallReview);
  Application.CreateForm(TfrmScatterGraphDF, frmScatterGraphDF);
  Application.CreateForm(TfrmSewershedConverterManagement, frmSewershedConverterManagement);
  Application.CreateForm(TfrmAddSewerShedDataConverter, frmAddSewerShedDataConverter);
  Application.CreateForm(TfrmSewershedManagement, frmSewershedManagement);
  Application.CreateForm(TfrmEditSewershed, frmEditSewershed);
  Application.CreateForm(TfrmImportSewerShedDataUsingConverter, frmImportSewerShedDataUsingConverter);
  Application.CreateForm(TfrmSW5Exporter, frmSW5Exporter);
  Application.CreateForm(TfrmRDIIExport, frmRDIIExport);
  Application.CreateForm(TfrmRaingaugeManagement, frmRaingaugeManagement);
  Application.CreateForm(TfrmRTKPatternEditor, frmRTKPatternEditor);
  Application.CreateForm(TfrmRTKPatternConverterManager, frmRTKPatternConverterManager);
  Application.CreateForm(TfrmAddRTKPatternConverter, frmAddRTKPatternConverter);
  Application.CreateForm(TfrmImportRTKPatternData, frmImportRTKPatternData);
  Application.CreateForm(TfrmExportRDIIHydrographs, frmExportRDIIHydrographs);
  Application.CreateForm(TfrmRTKPatternAssignment, frmRTKPatternAssignment);
  Application.CreateForm(TfrmSelScenario4RTKAssignment, frmSelScenario4RTKAssignment);
  Application.CreateForm(TfrmHolidayTable, frmHolidayTable);
  Application.CreateForm(TfrmAddEditHoliday, frmAddEditHoliday);
  Application.CreateForm(TNodeSelectorForm, NodeSelectorForm);
  Application.CreateForm(TSSOOutfallForm, SSOOutfallForm);
  Application.CreateForm(TfrmSWMM5ResultsImport2, frmSWMM5ResultsImport2);
  Application.CreateForm(TTSGrapherForm, TSGrapherForm);
  Application.CreateForm(TfrmSWMM5_RDIIImporter, frmSWMM5_RDIIImporter);
  Application.CreateForm(TfrmDataImportLog, frmDataImportLog);
  Application.CreateForm(TTSGraphForm, TSGraphForm);
  Application.CreateForm(TScenarioGraphForm, ScenarioGraphForm);
  Application.CreateForm(TScenarioConduitGraphForm, ScenarioConduitGraphForm);
  Application.CreateForm(TAboutBoxForm, AboutBoxForm);
  Application.CreateForm(TfrmFlowMonGraph, frmFlowMonGraph);
  Application.CreateForm(TfrmAnalysisManagement, frmAnalysisManagement);
  Application.CreateForm(TfrmCASelector, frmCASelector);
  Application.CreateForm(TfrmAnalysisSelector, frmAnalysisSelector);
  Application.CreateForm(TfrmCALinearRegressionAnalysis, frmCALinearRegressionAnalysis);
  Application.CreateForm(TfrmCAChooseLinearRegression, frmCAChooseLinearRegression);
  Application.CreateForm(TfrmCAAnalysesAnalyzer, frmCAAnalysesAnalyzer);
  Application.CreateForm(TfrmCAAnalysisSetup, frmCAAnalysisSetup);
  Application.CreateForm(TfrmCAAnalysisChooser, frmCAAnalysisChooser);
  Application.CreateForm(TTSGrapherForm, TSGrapherForm);
  Application.CreateForm(TTSGraphForm, TSGraphForm);
  //Application.CreateForm(TfrmCAAnalysisChooser2, frmCAAnalysisChooser2);
  //Application.CreateForm(TfrmCARDIIRankingGraph2, frmCARDIIRankingGraph2);
  //rm 2012-04-09 the following form is causing the error upon closing SSOAP
  Application.CreateForm(TfrmPostRehab_Analysis, frmPostRehab_Analysis);

  Application.CreateForm(TfrmInfoAnalysis, frmInfoAnalysis);
  Application.CreateForm(TfrmAddComparisonScenario, frmAddComparisonScenario);

  Application.Run;
end.
