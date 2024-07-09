{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O-,P+,Q+,R+,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
unit modDatabase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  hydrograph, StormEvent, StormEventCollection, GWIAdjustment, Grids,
  GWIAdjustmentCollection, Analysis, ADODB_TLB, Variants, DateUtils, Math;
  {$IFDEF VER140 }  {$ENDIF}

type
  daysArray = array of integer;
  diurnalCurves = array of array of real;

  integerPointer = ^integer;
  realPointer = ^real;
  TDataModule1 = class(TDataModule)

    function GetFlowConverterNames(): TStringList;                                  // ADO
    function GetRainConverterNames(): TStringList;                                  // ADO
    function GetRdiiConverterNames(): TStringList;                                  // ADO
    function GetSewerShedConverterNames(): TStringList;                                  // ADO
    function GetRDIIAreaConverterNames(): TStringList;                                  // ADO
    function GetRTKPatternConverterNames(): TStringList;
                                                                                    // ADO
    function databaseVersion(): integer;                                            // ADO
    function GetAnalysis(analysisName: string): TAnalysis;                          // ADO
                                                                                    // ADO
    function GetFlowMeterNames(): TStringList;                                      // ADO
    function GetScenarioNames(): TStringList;
    function GetComparisonScenarioIDForName(cScenarioName: string): integer;                   // ADO
    function GetComparisonScenarioNames() : TStringList;
    function GetNumofSubsewershedForComparisonScenarioName(cScenarioName:string) : integer;
    function GetComparisonOptionForComparisonScenarioName(cScenarioName:string) : integer;
    function GetComparisonStatsOptionForComparisonScenarioName(cScenarioName:string) : integer;
    function GetCOptionfromComparisonScenario (CScenarioName : string) : integer;
    function GetAnalysisfromComparisonScenario (cScenarioName : string) : TStringList;
    function GetSewershedNames(): TStringList;
    function GetRDIIAreaNames(): TStringList;
    function GetMeterIDForName(flowMeterName: string): integer;                 // ADO
    function GetScenarioIDForName(scenarioName: string): integer;                   // ADO
    function GetScenarioNameForID(scenarioID: integer): string;
    function GetSewershedIDForName(sewershedName: string): integer;                     // ADO
    function GetRDIIAreaIDForName(RDIIAreaName: string): integer;                     // ADO
    function GetScenarioDesciption(scenarioName: string): string;
    function GetScenarioOutFileName(scenarioID: integer): string;
    function GetScenarioInpFileName(scenarioID: integer): string;
    function GetScenarioSWMM5ResultsCount(scenarioID: integer): integer;
    procedure ClearScenarioSWMM5Results(scenarioID: integer);
    function GetFlowTimestep(meterID: integer): integer;                            // ADO
    function GetRainTimestep(gaugeID: integer): integer;
    function GetStartDateTime(meterID: integer): TDateTime;                         // ADO
    function GetEndDateTime(meterID: integer): TDateTime;                           // ADO
                                                                                    // ADO
    function AverageFlowForMeterAndDay(meterID: integer; day: TDate): real;         // ADO
    function AverageFlowForMeterDuringWeekdayDWF(meterID: integer): real;           // ADO
    function AverageFlowForMeterDuringWeekendDWF(meterID: integer): real;           // ADO
                                                                                    // ADO
    function GetWeekdayDWFDays(meterID: integer): daysArray;                        // ADO
    function GetWeekendDWFDays(meterID: integer): daysArray;                        // ADO
    procedure CalculateWeekdayDWF(meterID: integer);                                // ADO
    procedure CalculateWeekendDWF(meterID: integer);                                // ADO
    function GetWeekdayDWF(meterID: integer): THydrograph;                          // ADO
    function GetWeekendDWF(meterID: integer): THydrograph;                          // ADO
    function GetDiurnalCurves(analysisName: string): diurnalCurves;                 // ADO
                                                                                    // ADO
    procedure GetDryWeatherFlowStatistics(meterID, wdwe: integer;                   // ADO
                                          var avgMax, avg, avgMin: real);           // ADO
                                                                                    // ADO
    procedure UpdateMinMaxFlowTimes(meterID: integer);                              // ADO
    function GetConversionFactorToUnitForMeter(meterID: integer;                    // ADO
                                               unitLabel: string): double;//real;            // ADO
    function GetConversionFactorToUnitForRdiiArea(sewershedID: integer;
                                                unitLabel: string): real;
    function GetConversionForMeter(meterID: integer): real;                         // ADO
    procedure RemoveWeekendDWFDays(flowMeterName: string);                          // ADO
    procedure RemoveWeekdayDWFDays(flowMeterName: string);                          // ADO
    function ObservedFlowBetweenDateTimes(meterID: integer;                         // ADO
                                          startDateTime,                            // ADO
                                          endDateTime: TDateTime): THydrograph;     // ADO
                                                                                    // ADO
    function GetEvents(analysisID: integer): TStormEventCollection;                 // ADO
    procedure AddEvent(analysisID: integer; event: TStormEvent);                    // ADO
    procedure AddEvents(analysisID: integer; events: TStormEventCollection);        // ADO
    procedure RemoveEvent(event: TStormEvent);                                      // ADO
    procedure UpdateEvent(event: TStormEvent);
    //procedure
    function UpdateRTKPattern4Event(
      sPatternName: string; var event:TStormEvent): boolean;
    // ADO
    procedure RemoveAllEventsForAnalysis(analysisID: integer);                      // ADO
                                                                                    // ADO
    function GetGWIAdjustments(analysisID: integer): TGWIAdjustmentCollection;      // ADO
    procedure AddGWIAdjustment(analysisID: integer; adjustment: TGWIAdjustment);    // ADO
    procedure RemoveGWIAdjustment(analysisID: integer; adjustment: TGWIAdjustment); // ADO
    procedure UpdateAdjustmentValueForGWIAdjustment(analysisID: integer;            // ADO
                                                    adjustment: TGWIAdjustment);    // ADO
    procedure RemoveAllGWIAdjustmentsForAnalysis(analysisID: integer);              // ADO
                                                                                    // ADO
    function GetRaingaugeNames(): TStringList;                                      // ADO
    function GetRaingaugeIDForName(raingaugeName: string): integer;                 // ADO
    function RainfallTotalForRaingaugeAndDay(raingaugeID: integer;                  // ADO
                                             day: TDate): real;                     // ADO
    function RainfallTotalForRaingaugeBetweenDates(raingaugeID: integer;            // ADO
                                                   startDate,                       // ADO
                                                   endDate: TDateTime): real;       // ADO
    function RainfallTotalPreceding2Wks(startDateTime: TDateTime;
                                                    raingaugeID : integer) : real;
    procedure GetExtremeRainfallDateTimesBetweenDates(raingaugeID: integer;         // ADO
                                                      startDateTime,                // ADO
                                                      endDateTime: TDateTime;       // ADO
                                                      var earliestDateTime,         // ADO
                                                          latestDateTime: TDateTime);// ADO
    function GetMaximumRainfallBetweenDates(raingaugeID: integer;                   // ADO
                                            startDateTime,                          // ADO
                                            endDateTime: TDateTime): real;          // ADO

    function GetPeakHourlyRainIntensityBetweenDates(raingaugeID : integer;
                                            startDateTime,
                                            endDateTime: TDateTime): real;
                                                                                    // ADO
    function GetAnalysisNames(): TStringList;                                       // ADO
    function GetAnalysisIDForName(analysisName: string): integer;                   // ADO
    function GetRaingaugeNameForAnalysis(analysisName: string): string;             // ADO
    function GetFlowMeterNameForAnalysis(analysisName: string): string;             // ADO
    function GetAreaForAnalysis(analysisName: string): real;                        // ADO
    function GetBaseFlowRateForAnalysis(analysisName: string): real;                // ADO
                                                                                    // ADO
    function GetFlowUnitLabels(): TStringList;                                      // ADO
    function GetVelocityUnitLabels(): TStringList;                                      // ADO
    function GetDepthUnitLabels(): TStringList;                                      // ADO
    function GetAreaUnitLabels(): TStringList;

    function GetFlowUnitID(flowUnitLabel: string): integer;                       // ADO
    function GetFlowUnitLabelForID(flowUnitID: integer): String;
    function GetAreaUnitID(areaUnitLabel: string): integer;                       // ADO
    function GetVelocityUnitID(velocityUnitLabel: string): integer;                         // ADO
    function GetDepthUnitID(depthUnitLabel: string): integer;                         // ADO
    function GetDepthUnitLabelForID(depthUnitID: integer): String;
    function GetRdiiUnitID(rdiiUnitLabel: string): integer;                         // ADO

    //function GetSewerShedUnitID(sewershedUnitLabel: string): integer;                         // ADO

    function GetFlowUnitIDForFlowMeter(meterID: integer): integer;                  // ADO
    function GetAreaUnitIDForSewershed(sewershedID: integer): integer;                  // ADO
    function GetFlowUnitLabelForMeter(meterName: string): string;                   // ADO
    function GetAreaUnitLabelForSewershed(sewershedName: string): string;                   // ADO
    function GetAreaUnitLabelForRDIIArea(RDIIAreaName: string): string;                   // ADO
    function GetFlowVolumeLabelForMeter(meterName: string): string;                 // ADO
    function GetFlowUnitLabelForFlowConverter(flowConverterName: string): string;   // ADO
    function GetAreaUnitLabelForRdiiConverter(rdiiConverterName: string): string;   // ADO
    function GetAreaUnitLabelForSewerShedConverter(sewershedConverterName: string): string;   // ADO
    function GetAreaUnitLabelForRDIIAreaConverter(RDIIAreaConverterName: string): string;   // ADO

    function GetFlowUnitLabelForScenario(iScenarioID:integer): string;
    function GetDepthUnitLabelForScenario(iScenarioID:integer): string;
                                                                                        // ADO
    function GetRainUnitLabels(): TStringList;                                      // ADO
    function GetRainUnitID(rainUnitLabel: string): integer;                         // ADO
    function GetRainfallTimestep(raingaugeID: integer): integer;                    // ADO
    function GetRainUnitIDForRaingauge(raingaugeID: integer): integer;              // ADO
    function GetRainUnitLabelForRaingauge(raingaugeName: string): string;           // ADO
    function GetRainUnitShortLabelForRaingauge(raingaugeName: string): string;      // ADO
    function GetRainUnitLabelForRainConverter(rainConverterName: string): string;   // ADO
    function GetRainfallDecimalPlacesForRaingauge(raingaugeName: string): integer;  // ADO
                                                                                    // ADO
    function GetConversionForRaingauge(raingaugeID: integer): real;                 // ADO
    function GetConversionFactorToUnitForRaingauge(raingaugeID: integer;            // ADO
                                                   unitLabel: string): real;        // ADO
    procedure UpdateMinMaxRainTimes(raingaugeID: integer);                          // ADO
                                                                                    // ADO
    procedure RemoveFlowConverter(flowConverterName: string);                       // ADO
    procedure RemoveRainConverter(rainConverterName: string);                       // ADO
    procedure RemoveMeter(flowMeterName: string);                                   // ADO
    procedure RemoveFlowsForMeter(flowMeterName: string);                           // ADO
    procedure RemoveRaingauge(raingaugeName: string);                               // ADO
    procedure RemoveRainfallForRaingauge(raingaugeName: string);                    // ADO
    procedure RemoveAnalysis(analysisName: string);                                 // ADO
    procedure RemoveScenario(scenarioName: string);
    procedure RemoveHoliday(HolidayName:string; HolidayDate: TDateTime);
    procedure UpdateHoliday(OldHolidayName: string; OldHolidayDate: TDate;
      HolidayName:string; HolidayDate:TDate);                                                                                // ADO
    procedure AddHoliday(HolidayName:string; HolidayDate:TDate);

    function AnalysesUsingFlowMeter(flowMeterName: string): TStringList;            // ADO
    function AnalysesUsingRaingauge(raingaugeName: string): TStringList;            // ADO
    function MeterHasFlowData(flowMeterName: string): boolean;                      // ADO
    function RaingaugeHasRainfallData(raingaugeName: string): boolean;              // ADO
    function AnalysisHasEvents(analysisName: string): boolean;                      // ADO
    function AnalysisHasGWIAdjustments(analysisName: string): boolean;              // ADO
                                                                                    // ADO
    function GetHolidays(): daysArray;                                              // ADO
    function GetHolidayLabels(): TStringList;                                              // ADO
                                                                                    // ADO
    procedure CreateWeekdayDWFRecordsForMeter(meterID, timestep: integer);          // ADO
    procedure CreateWeekendAndHolidayDWFRecordsForMeter(meterID, timestep: integer);// ADO

    procedure AddSWMM5ResultCondCaps(scenarioID: integer; conduitID: string;
                        condCaps : double; duration : double; size : double;
                        length:double;flowunitid:integer);
    procedure AddSWMM5ResultFloodingVolume(scenarioID: integer; nodeID: string;
                        volume: double; duration: double; flowunitID:integer);
    procedure AddSWMM5ResultOutletVolume(scenarioID: integer; outletID: string;
                        volume : double; flowUnitID: integer);
    function GetFlowConversionFactor(unitID: integer): real;

    function RDIIsUsingSewerShed(sewerShedName: string): TStringList;
    procedure RemoveSewerShed(sewershedName: string);
    procedure RemoveRDIIConverter(rdiiConverterName: string);
    procedure RemoveSewerShedConverter(sewershedConverterName: string);                       // ADO
    procedure RemoveRDIIAreaConverter(RDIIAreaConverterName: string);                       // ADO
    procedure RemoveRDIIArea(RDIIAreaName: string);
    procedure RemoveRTKPatternConverter(RTKPatternConverterName: string);
    procedure RemoveRTKLink(iRTKLinkID: integer);

    function GetVelocityUnitLabelForMeter(meterName: string): string;                   // ADO
    function GetDepthUnitLabelForMeter(meterName: string): string;                   // ADO

    function GetRaingaugeNameForID(raingaugeID: integer): string;
    function GetFlowMeterNameForID(flowmeterID:integer): string;
    function GetSewerShedNameForID(sewershedID:integer): string;

    function GetSewerShedIDForRDIIAreaID(RDIIAreaID: integer): integer;
    function GetSewerShedNameForRDIIAreaName(RDIIAreaName: string): string;
    function GetRDIIAreaNamesforSewershedID(iSewerShedID:integer): TStringList;
    function GetRDIIAreaNamesforSewershedIDandScenarioID(iSewerShedID,
      iScenarioID: integer): TStringList;
    function GetAnalysisNamesforRainGaugeID(iRainGaugeID:integer): TStringList;
    function GetSewerShedArea(sewershedID:integer): double;
    function GetSewerShedAreaInNativeUnits(sewershedID:integer): double;
    function GetRDIIAreaArea(rdiiareaID:integer): double;
    function GetRainGaugeIDforSewershedID(iSewerShedID:integer): integer;
    function GetMeterIDForSewershedID(iSewerShedID:integer): integer;                 // ADO
    function GetRainGaugeIDforRDIIAreaID(iRDIIAreaID:integer): integer;

    procedure RemoveRTKPattern(rtkPatternName: string);
    function GetRTKPatternNames(): TStringList;
    function GetRTKPatternNames4Analyses(): TStringList;
    function GetRTKPatternNames4SewerShed(sSewerShedName: string): TStringList;
    function GetRTKPatternNamesFromEvents(): TStringList;
    procedure GetRTKLinkGrid(iSceneID: integer;var inStringGrid:TStringGrid);
    function GetStartDateTime4RainGaugeID(gaugeID: integer): TDateTime;                         // ADO
    function GetEndDateTime4RainGaugeID(gaugeID: integer): TDateTime;
    function GetRTKPatternforName_(RTKPatternName: string): TStringList;
    function GetRTKPatternforNameAdjustedbyFactor_(RTKPatternName: string; factor: double): TStringList;
    procedure AddRTKPattern(RTKPatternList: TStringList);
    procedure UpdateRTKPattern(RTKPatternList: TStringList);
    function GetRTKPAtternIDforName_(RTKPatternName: string): integer;
    function GetRTKPatternNameForID(iRTKPatternID: integer): string;
    function GetRTKPatternID4Event(iEventID: integer): integer;
    function ExportRTKPatterns2CSV(CSVFilename:string):boolean;
    procedure SetScenarioInpFileName(iSceneID:integer; sInpFileName: string);
    procedure SetScenarioOutFileName(iSceneID:integer; sOutFileName: string);
    function CopyScenario(oldID,newID:integer; copyRTKs: boolean;
        strSuffix: string; dblFactor: double): integer;

    function GetRTKPatternIDForSewerShedIDAndScenarioID(iSewerShedID:integer; iScenarioID:integer): integer;
    function GetRTKPatternIDForRDIIAreaIDAndScenarioID(iRDIIAreaID:integer; iScenarioID:integer): integer;

    function GetRTKLinkIDForSewerShedIDAndScenarioID(iSewerShedID:integer; iScenarioID:integer): integer;
    function GetRTKLinkIDForRDIIAreaIDAndScenarioID(iRDIIAreaID:integer; iScenarioID:integer): integer;

    function GetJunctionIDforSewerShedID(iSewerShedID:Integer): string;
    function GetJunctionIDforRDIIAreaID(iRDIIAreaID:Integer): string;

    function GetConversionFactorForFlowUnitLabel(flowUnitLabel:string):double;
    function GetConversionFactorForFlowUnitID(flowUnitID:integer):double;
    function GetConversionFactorForRainUnitLabel(rainUnitLabel:string):double;
    function GetConversionFactorForAreaUnitID(areaUnitID: integer): double;
    function GetConversionFactorForAreaUnitLabel(areaUnitLabel:string):double;
    procedure AddRTKLink(iScenarioID, iSewerShedID, iRDIIAreaID, iRTKPatternID, iRainGaugeID: integer; sDescription: string);
    procedure UpdateRainGaugeIDForRDIIAreasInSewerShed(sSewerShedName: string);
    procedure UpdateFlowMeterIDForRDIIAreasInSewerShed(sSewerShedName: string);
    procedure UpdateAreaUnitIDForRDIIAreasInSewerShed(sSewerShedName: string);

    function GetDWFStrings4MeterID(iMeterID: integer;
       boWeekEnd: boolean; sFlowUnitLabel: string): TStringList;
//    procedure logSQL(sqlStr:string);
    function GetAreaUnitIDForSWMM5FlowUnitLabel(flowLabel: string): integer;
    function GetFlowUnitIDForSWMM5FlowUnitLabel(flowLabel: string): integer;
    function GetDepthUnitIDForSWMM5FlowUnitLabel(flowLabel: string): integer;
    function GetRainUnitIDForSWMM5FlowUnitLabel(flowLabel: string): integer;
    procedure ShowADOErrors(ErrorList: ADODB_TLB.Errors);
    function GetRDIIAreaAreasForSewerShed(SewerShedName: string): double;
    function GetRDIIAreasAreaForSewerShedID(iSewerShedID: integer): double;
    function GetAnalysisNameForID(AnalysisID: integer): string;
    procedure FactorRTKPattern(var PatternList: TStringList; dblFactor:double);
    function GetScenarioNames4RTKPatternName(rtkPatternName: string): TStringList;
    function GetAnalysisName4RTKPatternName(rtkPatternName: string): string;
    function AddSWMM5ResultConduitTSMaster(iSc: integer; sConID: string;
      boIsOutfall: Boolean; boIsSSO: Boolean; iFlowUnitID: integer): integer;
    //idxConMaster := DatabaseModule.AddSWMM5ResultConduitTSMaster(iSceneID, tokList[2], true, false);
    function AddSWMM5ResultConduitTSDetail(iSc: integer; iConID: integer; dt: TDateTime; val: double): integer;
    //AddSWMM5ResultConduitTSDetail(iSceneID, idxConMaster,
    //                    swmm5_iFace.StartDate + k * (swmm5_iface.SWMM_ReportStep / 86400), val);
    function GetOutfallJunctionsbyScenario(scID:integer; boNonSSO: boolean; boSSO: boolean): TStringList;
    function AddSWMM5ResultJuncFlowTSMaster(iSc: integer; sJunID: string;
      boIsOutfall: Boolean; boIsSSO: Boolean; iFlowUnitID: integer): integer;
    function AddSWMM5ResultJuncFlowTSDetail(iSc: integer; iJunID: integer; dt: TDateTime; val: double): integer;
    procedure AddSWMM5ResultJuncDepths(scenarioID: integer; junctionID: string;
                        invert: double; depth: double; waterdepth: double; depthunitID: integer);
    procedure SetJunctionSSO(scID:integer; junID: string; boIsSSO: boolean);
    procedure RemoveJunctionFlowTS(scID:integer; junID: string);
    function GetJunctionsbyScenario(scID:integer; sWhereClause: string): TStringList;
    function GetFloodingJunctionsbyScenario(scID:integer; sWhereClause: string): TStringList;
    function GetConduitsbyScenario(scID:integer; sWhereClause: string): TStringList;
    procedure SetJunctionDepthTS(scID:integer; junID: string; boIsSelected: boolean);
    procedure RemoveJunctionDepthTS(scID:integer; junID: string);
    function AddSWMM5ResultJuncDepthTSMaster(iSc: integer; sJunID: string; dInv: double;
      dDep: double; iDepthUnitID: integer): integer;
    function AddSWMM5ResultJuncDepthTSDetail(iSc: integer; iJunID: integer; dt: TDateTime; val: double): integer;
    procedure LogImport(iType: integer; iFID: integer; iCID:integer;
      sFilename: string; dt: TDateTime; memo: System.string);
    function GetRainConverterIndexForName(sName: string): integer;
    function GetFlowConverterIndexForName(sName: string): integer;
    function GetSewershedConverterIndexForName(sName: string): integer;
    function GetRDIIAreaConverterIndexForName(sName: string): integer;
    function GetRTKPatternConverterIndexForName(sName: string): integer;

    function GetJuncDepthTS(scID:integer; junID: string; boScenUnits: boolean): TStringList;
    function GetJuncFlowTSUnitLabel(scID:integer; junID: string; var iUnitID:integer): String;
    function GetJuncFlowTS(scID:integer; junID: string; boScenUnits: boolean): TStringList;
    function GetJuncDepthTSUnitLabel(scID:integer; junID: string; var iUnitID:integer): String;
    function CreateNewRTKPattern4Event(event: TStormEvent; sRTKName: string): boolean;
    function GetCondMaxCapUnitLabel(scID:integer; conID: string; var iUnitID:integer): String;
    function GetCondMaxCap(scID:integer; conID: string): double;
    function GetJuncFlooding(scID:integer; junID: string; var iUnits: integer): double;
    function GetJuncMaxDepth(scID:integer; junID: string): double;
    function GetOutfallVolume(scID:integer; junID: string): double;
    function GetJuncMaxDepthUnitLabel(scID:integer; junID: string; var iUnitID:integer): String;
    function GetOutfallVolumeUnitLabel(scID:integer; junID: string; var iUnitID:integer): String;
    function GetVolUnitLabel4FlowUnitLabel(flowlabel: string): String;

    procedure ValidateRainfall4RainGauge(raingaugeID: integer; var iNumDupes: integer);

    procedure GetUnitIDs4Scenario(iSCID: integer; var iRUID: integer; var iFUID: integer;
      var iDUID: integer; var iVUID: integer; var iAUID: integer);
    function GetFlowUnitID4Scenario(iSCID: integer): integer;
    function GetDepthUnitID4Scenario(iSCID: integer): integer;
    function GetRainUnitID4Scenario(iSCID: integer): integer;
    function GetAreaUnitID4Scenario(iSCID: integer): integer;

    function GetDefaultRTKPatternName(AnalysisID:integer; dtStart:TDateTime): string;

//rm 2009-10-26 - new function to update SSOAP Toolbox Databases to new structure
    function upgradeDatabase(sDir: string; iFromVer: integer; iToVer: integer): boolean;
//rm 2009-10-28 - new function to accommodate area units other than acres
    function GetConversionToAcresForMeter(meterName: string; meterID: integer): double;
    function GetAreaUnitLabelForMeter(meterName: string; meterID: integer): string;
//rm 2010-05-06 Round DateTimes to nearest minute
    function RoundDateTimesToNearestMinute(sTableName: string): boolean;
//rm 2010-09-28
    function GetMonthNumberForName(sMon: string): integer;
    function GetRTKPAtternIDforNameAndMonth(RTKPatternName: string; iMon: integer): integer;
    function GetRTKPatternNumberForResponseName(sName: string): integer;
    function GetRTKPatternNames_with_IA(): TStringList;
    function GetRTKPatternforNameAndMonth(RTKPatternName: string; iMon: Integer): TStringList;
    function GetRTKPatternforNameAndMonthAdjustedbyFactor(RTKPatternName: string; iMon: Integer; factor: double): TStringList;
    function AnyRTKParametersAreBlank(RTKPatternList: TStringList): boolean;
//rm 2010-10-20
    function GetSewerLengthForMeter(meterID: integer): double;
    function GetRDIIperLFlabel(sFlowUnitLabel: string; var dVol: double): string;
    function GetVollabel(sFlowUnitLabel: string; var dVol: double): string;
    function GetRainGaugeIDForMeterID(meterid: integer): integer;
    function GetRainGaugeIDForAnalysisID(analysisid: integer): integer;
    function GetMeterIDForAnalysisID(analysisid: integer): integer;

//rm 2011-03-15
    function GetConditionAssessmentNames: TStringList;
    function RemoveConditionAssessment(caName: string): integer;
    function GetCAID4Name(caName: string): integer;
    function GetCAName4CAID(caID: integer): string;
    function GetAnalysisName4CAID(caID:integer; idx: integer): string;
    function GetOlapTol4CAID(caID:integer): string;
    function GetOlapEvent4CAID(caID: integer; pre_post: integer): integer;
    procedure UpdateOlapEvent4CAID(caID: integer; pre_post: integer; OverlapEvents:integer);
    function AddConditionAssessment(caName: string): integer;
    procedure UpdateConditionAssessment(caID: integer; sField: string; sValue: string);
    procedure UpdateDatabase;
    procedure UpdateDatabase_ComparisonScenario;

    //rm 2012-04-16
    function GetAnalysisNamesForComparisonScenario(caID: integer): TStringList;
    //rm 2012-04-17
    function GetSumR1ForAnalysisID(idx: integer): double;

  private { Private declarations }

  public { Public declarations }

  end;

var
  DatabaseModule: TDataModule1;

implementation

uses mainform, Uutils;

{$R *.DFM}

function TDataModule1.GetFlowMeterNameForID(flowmeterID: integer): string;
var
  queryStr: string;
  recSet: _recordSet;
begin
  queryStr := 'SELECT MeterName FROM Meters WHERE (MeterID = ' +
    inttostr(flowMeterID) + ')';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF  then begin
    GetFlowMeterNameForID := '';
  end else begin
    recSet.MoveFirst;
    GetFlowMeterNameForID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetMeterIDForAnalysisID(analysisid: integer): integer;
var
  analysisIDStr, queryStr: string;
  recSet: _RecordSet;
  iResult: integer;
begin
  iResult := -1;
  analysisIDStr := inttostr(analysisid);
  queryStr := 'SELECT MeterID FROM ' +
  ' Analyses WHERE AnalysisID = ' + analysisIDStr + ';';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then begin
      recSet.MoveFirst;
      iResult := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  result := iResult;
end;

function TDataModule1.GetMeterIDForName(flowMeterName: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  getMeterIDForName := -1;
  queryStr := 'SELECT MeterID FROM Meters WHERE (MeterName = "' + flowMeterName + '")';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF  then begin
    getMeterIDForName := -1
  end else begin
    recSet.MoveFirst;
    getMeterIDForName := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetMeterIDForSewershedID(iSewerShedID: integer): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  GetMeterIDForSewershedID := -1;
  queryStr := 'SELECT MeterID FROM SewerSheds WHERE (SewerShedID = ' + inttostr(iSewerShedID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then begin
    GetMeterIDForSewershedID := -1;
  end else begin
    recSet.MoveFirst;
    GetMeterIDForSewershedID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetMonthNumberForName(sMon: string): integer;
var iResult: integer;
begin
  sMon := AnsiUpperCase(sMon);
  if (sMon = 'ALL') then
     iResult := 0
  else if (sMon = 'JAN') then
     iResult := 1
  else if (sMon = 'FEB') then
     iResult := 2
  else if (sMon = 'MAR') then
     iResult := 3
  else if (sMon = 'APR') then
     iResult := 4
  else if (sMon = 'MAY') then
     iResult := 5
  else if (sMon = 'JUN') then
     iResult := 6
  else if (sMon = 'JUL') then
     iResult := 7
  else if (sMon = 'AUG') then
     iResult := 8
  else if (sMon = 'SEP') then
     iResult := 9
  else if (sMon = 'OCT') then
     iResult := 10
  else if (sMon = 'NOV') then
     iResult := 11
  else if (sMon = 'DEC') then
     iResult := 12
  else
    iResult := 0;
  result := iResult;
end;


function TDataModule1.GetOlapTol4CAID(caID: integer): string;
var
  queryStr: string;
  recSet: _RecordSet;
  iResult: integer;
  strResult : string;
  //s: string;
begin
  iResult := 0;
  //s := IntToStr(idx);
  queryStr := 'SELECT OverlapTol FROM ConditionAssessments ' +
    ' WHERE CAID = ' + inttostr(caID) + ';';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    if (varisnull(recSet.Fields.Item[0].Value)) then
      iResult := 0
    else
      iResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := IntToStr(iResult);
end;



function TDataModule1.GetOlapEvent4CAID(caID: integer; pre_post: integer): integer;
var
  queryStr: string;
  recSet: _RecordSet;
  iResult: integer;
  strResult : string;
  //s: string;
begin
  iResult := 0;
  //s := IntToStr(idx);
  //Pre or Post-Rehab
  if pre_post = 0 then
    queryStr := 'SELECT OverlapEvents_Pre FROM ConditionAssessments ' +
      ' WHERE CAID = ' + inttostr(caID) + ';'
  else
    queryStr := 'SELECT OverlapEvents_Post FROM ConditionAssessments ' +
      ' WHERE CAID = ' + inttostr(caID) + ';';

  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    if (varisnull(recSet.Fields.Item[0].Value)) then
      iResult := 0
    else
      iResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iResult;
end;

procedure TDataModule1.UpdateOlapEvent4CAID(caID: integer; pre_post: integer; OverlapEvents: integer);
{

 queryStr := 'SELECT MIN(DateTime), MAX(DateTime) FROM Flows WHERE ' +
              '(MeterID = ' + inttostr(meterID) + ');';
  recSet := CoRecordSet.Create;

  queryStr := 'SELECT StartDateTime, EndDateTime FROM Meters WHERE ' +
              '(MeterID = ' + inttostr(meterID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
  recSet.Fields.Item[0].Value := minDateTime;
  recSet.Fields.Item[1].Value := maxDateTime;
  recSet.UpdateBatch(1);
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;

}

var                                           
  queryStr: string;
  recordsAffected: OleVariant;

  recSet: _RecordSet;
  iResult: integer;
  strResult : string;
  //s: string;
begin
  if pre_post = 0 then
    queryStr := 'SELECT OverlapEvents_Pre FROM ConditionAssessments ' +
      ' WHERE CAID = ' + inttostr(caID) + ';'
  else
    queryStr := 'SELECT OverlapEvents_Post FROM ConditionAssessments ' +
      ' WHERE CAID = ' + inttostr(caID) + ';';

  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    recSet.Fields.Item[0].Value := OverlapEvents;
    recSet.UpdateBatch(1);
  end;
  finally
      if (recSet.State <> adStateClosed) then recSet.Close;
  end;

end;



function TDataModule1.GetOutfallJunctionsbyScenario(scID: integer; boNonSSO,
  boSSO: boolean): TStringList;
  var
  queryStr, sID: string;
  recSet: _RecordSet;
  returnStringList: TStringList;
begin
//return list of junction IDs
//if boNonSSO = True include non-SSO outfalls
//if boSSO = true include SSO outfalls
  returnStringList := TStringList.Create;
  if (boNonSSO and boSSO) then begin   //all outfalls
    queryStr := 'Select JunctionID from JuncFlowTSMaster ' +
    ' where ScenarioID = ' + IntToStr(scID) + ' and (isOutfall = TRUE)';
  end else if (boNonSSO) then begin   //only non-sso
    queryStr := 'Select JunctionID from JuncFlowTSMaster ' +
    ' where ScenarioID = ' + IntToStr(scID) + ' and (isOutfall = TRUE and isSSO = FALSE)';
  end else if (boSSO) then begin      //only sso
    queryStr := 'Select JunctionID from JuncFlowTSMaster ' +
    ' where ScenarioID = ' + IntToStr(scID) + ' and (isOutfall = TRUE and isSSO = TRUE)';
  end else begin
    Result := returnStringList;
    exit;
  end;
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    while not recSet.EOF do begin
      sID := recSet.Fields.Item[0].Value;
      returnStringList.Add(sID);
      recSet.MoveNext;
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := returnStringList;
end;

function TDataModule1.GetOutfallVolume(scID: integer; junID: string): double;
var
  dResult: double;
  queryStr: string;
  recSet: _recordSet;
begin
  dResult := 0.0;
  if Length(junID) > 0 then begin
    queryStr := 'SELECT Volume FROM OutletVolume ' +
    ' WHERE (NodeID = "' + junID + '") ' +
    ' AND (ScenarioID = ' + inttostr(scID) + ')';
    recSet := CoRecordSet.Create;
    try
      recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      if not recSet.EOF then begin
        recSet.MoveFirst;
        dResult := recSet.Fields.Item[0].Value;
      end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  Result := dResult;
end;

function TDataModule1.GetOutfallVolumeUnitLabel(scID: integer; junID: string;
  var iUnitID: integer): String;
var
  queryStr, sReturn: string;
  recSet: _RecordSet;
begin
  sReturn := 'MG';  //default
  iUnitID := 1;
  recSet := CoRecordSet.Create;
  queryStr := 'SELECT a.FlowUnitID, b.ShortLabel ' +
    ' FROM OutletVolume a inner join FlowUnits b ' +
    ' on a.FlowUnitID = b.FlowUnitID ' +
    ' where a.ScenarioID = ' + IntToStr(scID) +
    ' and a.NodeID = "' + junID + '"';
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    iUnitID := recSet.Fields.Item[0].Value;
    sReturn := recSet.Fields.Item[1].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := sReturn;
end;

function TDataModule1.GetSewerShedNameForRDIIAreaName(RDIIAreaName: string): string;
var
  queryStr: string;
  recSet: _recordSet;
begin
  GetSewerShedNameForRDIIAreaName := '';
  queryStr := 'SELECT SewerShedName FROM SewerSheds, RDIIAreas ' +
  ' WHERE (SewerSheds.SewerShedID = ' +
   '(Select SewerShedID from RDIIAreas where RDIIAreaName = "' + RDIIAreaName + '"))';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF  then begin
    GetSewerShedNameForRDIIAreaName := '';
  end else begin
    recSet.MoveFirst;
    GetSewerShedNameForRDIIAreaName := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetSewerShedNameForID(sewershedID: integer): string;
var
  queryStr: string;
  recSet: _recordSet;
begin
  GetSewerShedNameForID := '';
  queryStr := 'SELECT SewerShedName FROM SewerSheds WHERE (SewerShedID = ' +
    inttostr(sewershedID) + ')';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF  then begin
    GetSewerShedNameForID := '';
  end else begin
    recSet.MoveFirst;
    GetSewerShedNameForID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetComparisonScenarioIDForName(cScenarioName: string) : integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
if Length(cScenarioName) > 0 then
  begin
    queryStr := 'SELECT ComparisonScenarioID FROM ComparisonScenarios WHERE (ComparisonScenarioName = "' + cScenarioName + '")';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      getComparisonScenarioIDForName := recSet.Fields.Item[0].Value;
    end else Result := -1;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end else Result := -1;
end;

function TDataModule1.GetScenarioIDForName(scenarioName: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
if Length(scenarioName) > 0 then
  begin
    queryStr := 'SELECT ScenarioID FROM Scenarios WHERE (ScenarioName = "' + scenarioName + '")';
    //messageDlg(queryStr, mtInformation, [mbok],0);
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      getScenarioIDForName := recSet.Fields.Item[0].Value;
    end else Result := -1;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end else Result := -1;
end;

function TDataModule1.GetScenarioNameForID(scenarioID: integer): string;
var
  queryStr: string;
  recSet: _recordSet;
begin
  if scenarioID > -1 then begin
    queryStr := 'SELECT ScenarioName FROM Scenarios WHERE (ScenarioID = ' +
                inttostr(scenarioID) + ')';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then begin
      recSet.MoveFirst;
      Result := recSet.Fields.Item[0].Value;
    end else Result := '';
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end else Result := '';
end;

function TDataModule1.GetScenarioInpFileName(scenarioID: integer): string;
var
  queryStr, resultStr: string;
  recSet: _recordSet;
begin
  resultStr := '';
  if scenarioID > -1 then
  begin
    queryStr := 'SELECT SWMM5_Input FROM Scenarios WHERE ScenarioID = ' +
      IntToStr(scenarioID) + ';';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      resultStr := vartostr(recSet.Fields.Item[0].Value);
    end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  Result := resultStr;
end;

function TDataModule1.GetScenarioOutFileName(scenarioID: integer): string;
var
  queryStr, resultStr: string;
  recSet: _recordSet;
begin
  resultStr := '';
  if scenarioID > -1 then
  begin
    queryStr := 'SELECT SWMM5_Output FROM Scenarios WHERE ScenarioID = ' +
      IntToStr(scenarioID) + ';';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      if not VarIsNull(recSet.Fields.Item[0].Value) then
        resultStr := recSet.Fields.Item[0].Value;
    end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  Result := resultStr;
end;


function TDataModule1.GetScenarioSWMM5ResultsCount(scenarioID: integer): integer;
var
  queryStr: string;
  recSet: _recordSet;
  iResult: integer;
begin
  iResult := 0;
  queryStr := 'SELECT Count(-1) FROM ConduitMaxCapacity WHERE ' +
  ' (ScenarioID = ' + inttostr(scenarioID) + ')';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    iResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iResult;
end;

function TDataModule1.GetScenarioDesciption(scenarioName: string): string;
var
  queryStr: string;
  recSet: _recordSet;
begin
  if Length(scenarioName) > 0 then
  begin
    queryStr := 'SELECT ScenarioDescription FROM Scenarios WHERE (ScenarioName = "' + scenarioName + '")';
    //messageDlg(queryStr, mtInformation, [mbok],0);
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      GetScenarioDesciption := recSet.Fields.Item[0].Value;
    end else Result := '';
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end else
    Result := '';
end;


function TDataModule1.GetSewershedIDForName(sewershedName: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
  iResult: integer;
begin
  iResult := -1;
  queryStr := 'SELECT SewershedID FROM Sewersheds WHERE (SewershedName = "' + sewershedName + '")';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recset.eof then begin
    iResult := -1;
  end else begin
    recSet.MoveFirst;
     iResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  getSewershedIDForName := iResult;
end;

function TDataModule1.GetRDIIAreaIDForName(RDIIAreaName: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
  iResult: integer;
begin
  iResult := -1;
  queryStr := 'SELECT RDIIAreaID FROM RDIIAreas WHERE (RDIIAreaName = "' + RDIIAreaName + '")';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recset.eof then begin
    iResult := -1;
  end else begin
    recSet.MoveFirst;
    iResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetRDIIAreaIDForName := iResult;
end;

function TDataModule1.GetFlowTimestep(meterID: integer): integer;
var
  queryStr: string;
  recSet: _RecordSet;
  iResult: integer;
begin
  iResult := -1;
  queryStr := 'SELECT TimeStep FROM Meters WHERE (MeterID = ' + inttostr(meterID) +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recset.eof then begin
    iResult := -1;
  end else begin
    recSet.MoveFirst;
    iResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetFlowTimestep := iResult;
end;

function TDataModule1.GetRainTimestep(gaugeID: integer): integer;
var
  queryStr: string;
  recSet: _RecordSet;
  iResult: integer;
begin
  iResult := -1;
  queryStr := 'SELECT TimeStep FROM Raingauges WHERE (RaingaugeID = ' + inttostr(gaugeID) +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recset.eof then begin
    iResult := -1;
  end else begin
    recSet.MoveFirst;
    iResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetRainTimestep := iResult;
end;

function TDataModule1.GetDepthUnitLabelForID(depthUnitID: integer): String;
var
  queryStr, sResult: string;
  recSet: _recordSet;
begin
  sResult := '';
  queryStr := 'SELECT ShortLabel FROM DepthUnits WHERE (DepthUnitID = ' +
    inttostr(depthUnitID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then
    sResult := ''
  else begin
    recSet.MoveFirst;
    sResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := sResult;
end;

function TDataModule1.GetDepthUnitLabelForMeter(meterName: string): string;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  GetDepthUnitLabelForMeter := '';
  queryStr := 'SELECT ShortLabel FROM Meters, DepthUnits ' +
              'WHERE ((MeterName = "' + meterName + '") AND ' +
              '(Meters.DepthUnitID = DepthUnits.DepthUnitID));';
//rm 2008-06-27              '(Meters.FlowUnitID = DepthUnits.DepthUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then
  begin
    recSet.MoveFirst;
    GetDepthUnitLabelForMeter := recSet.Fields.Item[0].Value;
  end else
    GetDepthUnitLabelForMeter := '';
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetDepthUnitLabelForScenario(
  iScenarioID: integer): string;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  queryStr := 'SELECT DepthUnits.ShortLabel FROM Scenarios, DepthUnits ' +
              'WHERE ' +
              '((Scenarios.ScenarioID = ' + inttostr(iScenarioID) + ') ' +
              ' AND ' +
              '(Scenarios.DepthUnitID = DepthUnits.DepthUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then
  begin
    recSet.MoveFirst;
    Result := recSet.Fields.Item[0].Value;
  end else
    Result := '';
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetVelocityUnitLabelForMeter(meterName: string): string;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  GetVelocityUnitLabelForMeter := '';
  queryStr := 'SELECT ShortLabel FROM Meters, VelocityUnits ' +
              'WHERE ((MeterName = "' + meterName + '") AND ' +
              '(Meters.VelocityUnitID = VelocityUnits.VelocityUnitID));';
//rm 2008-06-27              '(Meters.FlowUnitID = VelocityUnits.VelocityUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then
  begin
    recSet.MoveFirst;
    GetVelocityUnitLabelForMeter := recSet.Fields.Item[0].Value;
  end else
    GetVelocityUnitLabelForMeter := '';
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetFlowUnitLabelForMeter(meterName: string): string;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  GetFlowUnitLabelForMeter := '';
  queryStr := 'SELECT ShortLabel FROM Meters, FlowUnits ' +
              'WHERE ((MeterName = "' + meterName + '") AND ' +
              '(Meters.FlowUnitID = FlowUnits.FlowUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then
  begin
    recSet.MoveFirst;
    GetFlowUnitLabelForMeter := recSet.Fields.Item[0].Value;
  end else
    GetFlowUnitLabelForMeter := '';
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;


function TDataModule1.GetFlowUnitLabelForScenario(iScenarioID: integer): string;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  queryStr := 'SELECT FlowUnits.ShortLabel FROM Scenarios, FlowUnits ' +
              'WHERE ' +
              '((Scenarios.ScenarioID = ' + inttostr(iScenarioID) + ') ' +
              ' AND ' +
              '(Scenarios.FlowUnitID = FlowUnits.FlowUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then
  begin
    recSet.MoveFirst;
    Result := recSet.Fields.Item[0].Value;
  end else
    Result := '';
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetAreaUnitLabelForSewershed(sewershedName: string): string;
var
  queryStr, sResult: string;
  recSet: _RecordSet;
begin
  sResult := 'ac';
  queryStr := 'SELECT ShortLabel FROM AreaUnits, Sewersheds ' +
              'WHERE ((SewershedName = "' + sewershedName + '") AND ' +
              '(Sewersheds.AreaUnitID = AreaUnits.AreaUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
// - bombs if areaunitid not assigned correctly
  if not (recSet.EOF) then begin
    recSet.MoveFirst;
    sResult := recSet.Fields.Item[0].Value;
  end else begin
    sResult := 'ac';
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetAreaUnitLabelForSewershed := sResult;
end;

function TDataModule1.GetAreaUnitLabelForMeter(meterName: string; meterID: integer): string;
var
  queryStr, sResult: string;
  recSet: _RecordSet;
begin
  sResult := 'ac';
  if (Length(meterName) > 0) then
    queryStr := 'SELECT a.ShortLabel FROM AreaUnits a inner join Meters m ' +
                ' on a.AreaUnitID = m.AreaUnitID ' +
                ' WHERE m.MeterName = "' + meterName + '";'
  else
    queryStr := 'SELECT a.ShortLabel FROM AreaUnits a inner join Meters m ' +
                ' on a.AreaUnitID = m.AreaUnitID ' +
                ' WHERE m.MeterID = ' + inttostr(meterID) + ';';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not (recSet.EOF) then begin
      recSet.MoveFirst;
      sResult := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetAreaUnitLabelForMeter := sResult;
end;

function TDataModule1.GetAreaUnitLabelForRDIIArea(RDIIAreaName: string): string;
var
  queryStr, sResult: string;
  recSet: _RecordSet;
begin
  sResult := 'ac';
  queryStr := 'SELECT ShortLabel FROM AreaUnits, RDIIAreas ' +
              'WHERE ((RDIIAreaName = "' + RDIIAreaName + '") AND ' +
              '(RDIIAreas.AreaUnitID = AreaUnits.AreaUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
// - bombs if areaunitid not assigned correctly
  if not (recSet.EOF) then begin
    recSet.MoveFirst;
    sResult := recSet.Fields.Item[0].Value;
  end else begin
    sResult := 'ac';
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetAreaUnitLabelForRDIIArea := sResult;
end;

function TDataModule1.GetAreaUnitLabelForSewerShedConverter(
  sewershedConverterName: string): string;
var
  queryStr, sResult: string;
  recSet: _RecordSet;
begin
  GetAreaUnitLabelForSewerShedConverter := '';
  queryStr := 'SELECT ShortLabel FROM SewerShedConverters, AreaUnits ' +
              'WHERE ((SewerShedConverterName = "' + sewershedConverterName + '") AND ' +
              '(SewerShedConverters.AreaUnitID = AreaUnits.AreaUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then begin
    GetAreaUnitLabelForSewerShedConverter := '';
  end else begin
    recSet.MoveFirst;
    GetAreaUnitLabelForSewerShedConverter := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetAreaUnitLabelForRDIIAreaConverter(
  RDIIAreaConverterName: string): string;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  GetAreaUnitLabelForRDIIAreaConverter := '';
  queryStr := 'SELECT ShortLabel FROM RDIIAreaConverters, AreaUnits ' +
              'WHERE ((RDIIAreaConverterName = "' + RDIIAreaConverterName + '") AND ' +
              '(RDIIAreaConverters.AreaUnitID = AreaUnits.AreaUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then begin
    GetAreaUnitLabelForRDIIAreaConverter := '';
  end else begin
    recSet.MoveFirst;
    GetAreaUnitLabelForRDIIAreaConverter := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetFlowVolumeLabelForMeter(meterName: string): string;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  GetFlowVolumeLabelForMeter := '';
  queryStr := 'SELECT VolumeLabel FROM Meters, FlowUnits ' +
              'WHERE ((MeterName = "' + meterName + '") AND ' +
              '(Meters.FlowUnitID = FlowUnits.FlowUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.eof then begin
    GetFlowVolumeLabelForMeter := '';
  end else begin
    recSet.MoveFirst;
    GetFlowVolumeLabelForMeter := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetFlowUnitLabelForFlowConverter(flowConverterName: string): string;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  GetFlowUnitLabelForFlowConverter := '';
  queryStr := 'SELECT ShortLabel FROM FlowConverters, FlowUnits ' +
              'WHERE ((FlowConverterName = "' + flowConverterName + '") AND ' +
              '(FlowConverters.FlowUnitID = FlowUnits.FlowUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetFlowUnitLabelForFlowConverter := ''
  else begin
    recSet.MoveFirst;
    GetFlowUnitLabelForFlowConverter := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;


function TDataModule1.GetAreaUnitLabelForRdiiConverter(rdiiConverterName: string): string;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  GetAreaUnitLabelForRdiiConverter := '';
  queryStr := 'SELECT ShortLabel FROM RdiiConverters, AreaUnits ' +
              'WHERE ((RdiiConverterName = "' + rdiiConverterName + '") AND ' +
              '(RdiiConverters.AreaUnitID = AreaUnits.AreaUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetAreaUnitLabelForRdiiConverter := ''
  else begin
    recSet.MoveFirst;
    GetAreaUnitLabelForRdiiConverter := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.AverageFlowForMeterAndDay(meterID: integer; day: TDate): real;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  AverageFlowForMeterAndDay := 0.0;
  queryStr := 'SELECT AVG(Flow) FROM Flows ' +
              'WHERE ((Int(DateTime) = ' + floattostr(day) + ') AND (MeterID = ' +
              inttostr(meterID) + '));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then AverageFlowForMeterAndDay := 0
  else begin
    recSet.MoveFirst;
    AverageFlowForMeterAndDay := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.AverageFlowForMeterDuringWeekdayDWF(meterID: integer): real;
var
  hydrograph: THydrograph;
begin
  hydrograph := GetWeekdayDWF(meterID);
  AverageFlowForMeterDuringWeekdayDWF := hydrograph.average;
  hydrograph.Free;
end;

function TDataModule1.AverageFlowForMeterDuringWeekendDWF(meterID: integer): real;
var
  hydrograph: THydrograph;
begin
  hydrograph := GetWeekendDWF(meterID);
  AverageFlowForMeterDuringWeekendDWF := hydrograph.average;
  hydrograph.Free;
end;

function TDataModule1.GetWeekdayDWFDays(meterID: integer): daysArray;
var
  queryStr: string;
  recSet: _RecordSet;
  dwfDate: TDateTime;
  dwfDays: daysArray;
  arraySize, index: integer;
  holidays: daysArray;

  function isHoliday(date: TDateTime): boolean;
  var
    i: integer;
  begin
    isHoliday := false;
    for i := 0 to length(holidays) - 1 do begin
      if (trunc(date) = holidays[i]) then isHoliday := true;
    end;
  end;

begin
  holidays := GetHolidays();
  arraySize := 20;
  SetLength(dwfDays,arraySize);

  queryStr := 'SELECT DWFDate FROM DryWeatherFlowDays WHERE ' +
              '((MeterID = ' + inttostr(meterID) + ') AND (Include = True)' +
              '  AND ((INT(DWFDate) MOD 7) IN (2,3,4,5,6))) ORDER BY DWFDate;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  index := 0;
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    dwfDate := recSet.Fields.Item[0].Value;
    {if the day is not a holiday, add it to the array of DWF days}
    if (not isHoliday(dwfDate)) then begin
      if (index >= arraySize) then begin
        arraySize := arraySize + 20;
        SetLength(dwfDays,arraySize);
      end;
      dwfDays[index] := trunc(dwfDate);
      inc(index);
    end;
    recSet.MoveNext;
  end;
  arraySize := index;
  SetLength(dwfDays,arraySize);
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetWeekdayDWFDays := dwfDays;
end;

function TDataModule1.GetWeekendDWFDays(meterID: integer): daysArray;
var
  queryStr: string;
  recSet: _RecordSet;
  dwfDate: TDateTime;
  dwfDays: daysArray;
  arraySize, index: integer;
  holidays: daysArray;

  function isHoliday(date: TDateTime): boolean;
  var
    i: integer;
  begin
    isHoliday := false;
    for i := 0 to length(holidays) - 1 do begin
      if (trunc(date) = holidays[i]) then isHoliday := true;
    end;
  end;

begin
  holidays := GetHolidays();
  arraySize := 20;
  SetLength(dwfDays,arraySize);

  queryStr := 'SELECT DWFDate FROM DryWeatherFlowDays WHERE ' +
              '((MeterID = ' + inttostr(meterID) + ') AND (Include = True)) ORDER BY DWFDate;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  index := 0;
  while (not recSet.EOF) do begin
    dwfDate := recSet.Fields.Item[0].Value;
    {if the day is a holiday, or a weekend day use it in the calculation of the average DWF}
    if (dayOfWeek(dwfDate) in [1,7]) or isHoliday(dwfDate) then begin
      if (index >= arraySize) then begin
        arraySize := arraySize + 20;
        SetLength(dwfDays,arraySize);
      end;
      dwfDays[index] := trunc(dwfDate);
      inc(index);
    end;
    recSet.MoveNext;
  end;
  arraySize := index;
  SetLength(dwfDays,arraySize);
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetWeekendDWFDays := dwfDays;
end;

procedure TDataModule1.LogImport(iType, iFID: integer; iCID:integer; sFilename: string;
  dt: TDateTime; memo: System.string);
//log an entry in the ImportLog table
//iTypes are from the ImportTypes Table
// 1 rainfall from converter
// 2 flows from converter
// 3 sewersheds from converter
// 4 rdii areas from converter
// 5 rtkpatterns from converter
// 6 rtkpatterns and rdiiareas from swmm5 file
// 7 swmm5 output file
// 8 sso flow from swmm5 output file
// 9 junction depth from swmm5 output file
var
  sqlStr, s: string;
  recordsAffected: OleVariant;
  fdt: TDateTime;
begin
  //rm 2009-06-09 - try to get the datestamp of the sFileName
  s := '';
  try
    //replace double-quotes with two single-quotes for SQL insertion
    s := StringReplace(memo,'"','''',[rfReplaceAll, rfIgnoreCase]);
    //get datestamp of input filename
    fdt := Uutils.FileDateTime(sFileName);
  finally

  end;
  sqlStr := 'INSERT INTO ImportLog (ImportTypeID, ForeignID, ConverterID, ' +
            ' Filename, ImportDate, FileDateStamp, ImportDetails) ' +
            ' VALUES (' + inttostr(iType) + ',' + inttostr(iFID) + ',' +
            inttostr(iCID) + ', "' + sFilename + '", ' +
            floattostr(dt) + ', ' + floattostr(fdt)+ ', "' + s + '");';
  frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
end;

(*
procedure TDataModule1.logSQL(sqlStr: string);
var logFile:TextFile;
logFileName: string;
begin
  logFileName := 'c:\sqlLog.txt';
    AssignFile(logFile,logFileName);
    {$I-}
    Reset(logFile);
    {$I+}
    if IOResult <> 0 Then
    Begin
      //Result := false;
      //MessageDlg('Error creating new input file ' + logFile,mtError,[mbok],0);
      Exit;
    End;
    Append(logFile);
    Writeln(logFile,'[' + FormatDateTime('yyyy/mm/dd hh:MM',Now) + ']');
    Writeln(logFile,sqlStr);
  CloseFile(logFile);
end;
*)

function TDataModule1.GetDWFStrings4MeterID(
  iMeterID: integer; boWeekEnd: boolean; sFlowUnitLabel: string): TStringList;
var
  queryStr, sTableName, sTableName2: string;
  recSet: _RecordSet;
  returnStringList: TStringList;
  s,stest: string;
  i: integer;
  d,v,v2: double;
begin
//get a list of strings composed like:
//[PATTERNS]
//;;Name             Type       Multipliers
//;;----------------------------------------------------------------------
//  DWF              HOURLY     .0151 .01373 .01812 .01098 .01098 .01922
//  DWF                         .02773 .03789 .03515 .03982 .02059 .02471
//  DWF                         .03021 .03789 .03350 .03158 .03954 .02114
//  DWF                         .02801 .03680 .02911 .02334 .02499 .02718
//but just the 4 lines of 6 numbers - the rest is put together in
//need to get hourly WeekDay or WeekEnd/Holiday DWF values
//SELECT (minute \ 60), sum(flow)
//FROM WeekendAndHolidayDWF where MeterID = 1 group by (minute \ 60)
  returnStringList := TStringList.Create;
  //first get the conversion factor for the meter:
  //d := GetConversionForMeter(iMeterID); //convert to CFS with this factor
//rm - are dwfs already in MGD?
//rm - or are they in same units as meter????
//rm  d := GetConversionFactorToUnitForMeter(iMeterID,sFlowUnitLabel);
//rm WRONG:  d := GetConversionForMeter(iMeterID);
  d := GetConversionFactorForFlowUnitLabel(sFlowUnitLabel);
  sTableName := 'WeekDayDWF';
//rm 2007-11-20 - In SWMM 5 Weekend hourly flows are got by multiplying the
//regular weekday hourly flows by a factor
//(all factors are applied - Monthly, Daily, Hourly, and then Weekend if day is a weekend)
// - NOT by substituting the weekday hourly pattern with the weekend
// - so we need to divide our weekend hourly flows by the weekday hourly flows
// - AND we need to check for divide-by-zero error
  //if boWeekEnd then sTableName := 'WeekEndAndHolidayDWF';
  sTableName2 := 'WeekEndAndHolidayDWF';
  if boWeekEnd then begin
{
    queryStr := 'SELECT (a.minute \ 60), (avg(b.Flow) / avg(a.Flow)) ' +
                ' FROM ' + sTableName + ' as a inner join ' + sTableName2 + ' as b ' +
                ' on a.MeterID = b.MeterID and a.Minute = b.Minute ' +
                ' where (a.MeterID = ' + inttostr(iMeterID) +') ' +
                ' group by (a.minute \ 60);';
}
//rm - need to prevent divide-by-zero - so get weekday and weekend flows separately:
    queryStr := 'SELECT (a.minute \ 60), avg(a.Flow), avg(b.Flow) ' +
                ' FROM ' + sTableName + ' as a inner join ' + sTableName2 + ' as b ' +
                ' on a.MeterID = b.MeterID and a.Minute = b.Minute ' +
                ' where (a.MeterID = ' + inttostr(iMeterID) +') ' +
                ' group by (a.minute \ 60);';
  end else begin
    queryStr := 'SELECT (minute \ 60), avg(flow) ' +
                ' FROM ' + sTableName +
                ' where (MeterID = ' + inttostr(iMeterID) +') ' +
                ' group by (minute \ 60);';
  end;
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    i := 0;
    s := '';
    while not recSet.EOF do begin
      if i = 6 then begin
        returnStringList.Add(s);
        i := 0;
        s := '';
      end;
      //s := s + ' ' + vartostr(recSet.Fields.Item[1].Value);
      //s := s + ' ' + formatfloat('0.000000',(d * recSet.Fields.Item[1].Value));
      try
        if boWeekEnd then begin
          v := recSet.Fields.Item[1].Value;   //weekday multiplier
          v2 := recSet.Fields.Item[2].Value;  //weekend multiplier
          if v > 0.0 then
            v := v2 / v  //divide weekend by weekday - because SWMM 5 will multiply them together
          else
            v := 0.0;  //1 or 0, doesnt matter - will get multiplied by zero anyway
        end else begin
          v := recSet.Fields.Item[1].Value;  //weekday multiplier
        end;
      except
        on E: Exception do begin
          v := 0.0;
          Raise E;
        end;
      end;
      s := s + ' ' + formatfloat('0.000000',(d * v));
      inc(i);
      recSet.MoveNext;
    end;
    returnStringList.Add(s);
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := returnStringList;
end;

procedure TDataModule1.CalculateWeekdayDWF(meterID: integer);
var
  queryStr, sqlStr: string;
  recSet: _RecordSet;
  fields, values, recordsAffected: OleVariant;
  dayIndex, index, timestep, numberOfPoints, numDays: integer;
  avgSum: array of real;
  flow: real;
  dwfDate: TDateTime;
  dwfDays: daysArray;
begin
  dwfDays := GetWeekdayDWFDays(meterID);
  numDays := length(dwfDays);
//rm 2008-11-11  if (numdays > 0) then begin
    timestep := GetFlowTimestep(meterID);
    numberOfPoints := 1440 div timestep;
    SetLength(avgSum,numberOfPoints);
    for index := 0 to numberOfPoints - 1 do avgSum[index] := 0.0;
    for dayIndex := 0 to numDays - 1 do begin
      dwfDate := dwfDays[dayIndex];
      queryStr := 'SELECT Flow FROM Flows WHERE ' +
                  '(INT(DateTime) = ' + floattostr(dwfDate) + ') AND ' +
                  //rm 2012-09-24 ORDER BY DATETIME
                  //'(MeterID = ' + inttostr(meterID) +');';
                  '(MeterID = ' + inttostr(meterID) +') ORDER BY DATETIME;';
      recSet := CoRecordSet.Create;
      try
      recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);

      index := 0;
      //while (not recSet.EOF) do begin
      while (not recSet.EOF) and (index < numberofPoints) do begin
        flow := recSet.Fields.Item[0].Value;
        avgSum[index] := avgSum[index] + flow;     // - bombs here
        inc(index);
        recSet.MoveNext;
      end;
      finally
        if (recSet.State <> adStateClosed) then recSet.Close;
      end;
    end;

    sqlStr := 'DELETE FROM WeekdayDWF WHERE (MeterID = ' + inttostr(meterID) + ');';
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);

    recSet := CoRecordSet.Create;
    try
    recSet.Open('WeekdayDWF',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
    fields := VarArrayCreate([1,3],varVariant);
    values := VarArrayCreate([1,3],varVariant);
    fields[1] := 'MeterID';
    fields[2] := 'Minute';
    fields[3] := 'Flow';

    values[1] := meterID;
    for index := 0 to numberOfPoints - 1 do begin
      values[2] := index * timestep;
      if numDays > 0 then
        values[3] := avgSum[index] / numDays
      else
        values[3] := 0;
      recSet.AddNew(fields,values);
    end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
//  end;
end;

procedure TDataModule1.CalculateWeekendDWF(meterID: integer);
var
  queryStr, sqlStr: string;
  recSet: _RecordSet;
  fields, values, recordsAffected: OleVariant;
  dayIndex, index, timestep, numberOfPoints, numDays: integer;
  avgSum: array of real;
  flow: real;
  dwfDate: TDateTime;
  dwfDays: daysArray;
begin
  dwfDays := GetWeekendDWFDays(meterID);
  numDays := length(dwfDays);
//rm 2008-11-11  if (numdays > 0) then begin
    timestep := GetFlowTimestep(meterID);
    numberOfPoints := 1440 div timestep;
    SetLength(avgSum,numberOfPoints);
    for index := 0 to numberOfPoints - 1 do avgSum[index] := 0.0;
    for dayIndex := 0 to numDays - 1 do begin
      dwfDate := dwfDays[dayIndex];
      queryStr := 'SELECT Flow FROM Flows WHERE ' +
                  '(INT(DateTime) = ' + floattostr(dwfDate) + ') AND ' +
                  //rm 2012-09-24 ORDER BY DATETIME
                  //'(MeterID = ' + inttostr(meterID) +');';
                  '(MeterID = ' + inttostr(meterID) +') ORDER BY DATETIME;';
      recSet := CoRecordSet.Create;
      try
      recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);

      index := 0;
//while (not recSet.EOF) do begin
      while (not recSet.EOF) and (index < numberOfPoints) do begin
        flow := recSet.Fields.Item[0].Value;
        avgSum[index] := avgSum[index] + flow;
        inc(index);
        recSet.MoveNext;
      end;
      finally
        if (recSet.State <> adStateClosed) then recSet.Close;
      end;
    end;

    sqlStr := 'DELETE FROM WeekendAndHolidayDWF WHERE (MeterID = ' + inttostr(meterID) + ');';
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);

    recSet := CoRecordSet.Create;
    try
    recSet.Open('WeekendAndHolidayDWF',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
    fields := VarArrayCreate([1,3],varVariant);
    values := VarArrayCreate([1,3],varVariant);
    fields[1] := 'MeterID';
    fields[2] := 'Minute';
    fields[3] := 'Flow';

    values[1] := meterID;
    for index := 0 to numberOfPoints - 1 do begin
      values[2] := index * timestep;
      if (numDays > 0) then
        values[3] := avgSum[index] / numDays
      else
        values[3] := 0;
      recSet.AddNew(fields,values);
    end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
//  end;
end;

procedure TDataModule1.ClearScenarioSWMM5Results(scenarioID: integer);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'DELETE FROM ConduitMaxCapacity WHERE (ScenarioID = ' +
    inttostr(scenarioID) + ');';
  try
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  finally
  end;
  sqlStr := 'DELETE FROM OutletVolume WHERE (ScenarioID = ' +
    inttostr(scenarioID) + ');';
  try
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  finally
  end;
  sqlStr := 'DELETE FROM Flooding WHERE (ScenarioID = ' +
    inttostr(scenarioID) + ');';
  try
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  finally
  end;

  //rm 2009-05-26
  sqlStr := 'DELETE d.* FROM JuncFlowTSMaster m INNER JOIN ' +
    ' JuncFlowTSDetail d ON m.JuncFlowTSMasterID = d.JuncFlowTSMasterID ' +
    ' where (m.ScenarioID = ' +
    inttostr(scenarioID) + ');';
  try
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  finally
  end;
  sqlStr := 'DELETE FROM JuncFlowTSMaster WHERE (ScenarioID = ' +
    inttostr(scenarioID) + ');';
  try
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  finally
  end;
  sqlStr := 'DELETE FROM JunctionDepths WHERE (ScenarioID = ' +
    inttostr(scenarioID) + ');';
  try
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  finally
  end;
  sqlStr := 'DELETE d.* FROM JuncDepthTSMaster m INNER JOIN ' +
    ' JuncDepthTSDetail d ON m.JuncDepthTSMasterID = d.JuncDepthTSMasterID ' +
    ' where (m.ScenarioID = ' +
    inttostr(scenarioID) + ');';
  try
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  finally
  end;
  sqlStr := 'DELETE FROM JuncDepthTSMaster WHERE (ScenarioID = ' +
    inttostr(scenarioID) + ');';
  try
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  finally
  end;
end;

function TDataModule1.CopyScenario(oldID, newID: integer; copyRTKs: boolean;
  strSuffix: string; dblFactor: double): integer;
var
  sqlStr: string;
  recordsAffected: OleVariant;
  recSet: _recordSet;
  oldname,newname: string;
  oldPatternID, newPatternID, dupeCount: integer;
  PatternList: TStringList;
  iMon: integer;
begin
  dupeCount := 0;
//first update the new record's FlowUnitID with the old one's
  sqlStr := 'UPDATE Scenarios as a, Scenarios as b ' +
  ' set a.FlowUnitID = b.FlowUnitID ' +
  ' WHERE (a.FlowUnitID = ' + inttostr(newID) +
  ') AND (b.FlowUnitID = ' + inttostr(oldID) + ');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
//now, if copyRTKs = true, make copies of all of the RTK Patterns in the source scenario
  if copyRTKs then begin
//    sqlStr := 'Select p.* FROM RTKPatterns as p ' +
//rm 2010-09-29    sqlStr := 'Select p.RTKPatternID, p.RTKPatternName FROM RTKPatterns as p ' +
    sqlStr := 'Select p.RTKPatternID, p.RTKPatternName, p.Mon FROM RTKPatterns as p ' +
    ' INNER JOIN RTKLinks as l ' +
    ' ON p.RTKPatternID = l.RTKPatternID '  +
    ' WHERE l.ScenarioID = ' + inttostr(oldID) + ';';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(sqlStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF  then begin
      recSet.MoveFirst;
      while not recSet.EOF do begin
        oldPatternID := recSet.Fields.Item[0].Value;
        oldname := recSet.Fields.Item[1].Value;
        newname := oldname + strSuffix;
        if (VarIsNull(recset.Fields.Item[2].Value)) then
          iMon := 0
        else
          iMon := recset.Fields.Item[2].Value;
        if (GetRTKPAtternIDforNameAndMonth(newname, iMon) < 0) then begin
          PatternList := GetRTKPatternforNameAndMonth(oldname, iMon);
          PatternList.Insert(0,newname);
          FactorRTKPattern(PatternList,dblFactor);
          AddRTKPattern(PatternList);
          newPatternID := GetRTKPAtternIDforNameAndMonth(newname, iMon);
          if (newPatternID > 0) then begin
            sqlStr := 'insert into RTKLinks ' +
            ' (ScenarioID, SewershedID, RDIIAreaID, RTKPatternID) ' +
            ' Select ' + inttostr(newID) + ', SewershedID, RDIIAreaID, ' + inttostr(newPatternID) +
            ' from RTKLinks where (ScenarioID = ' + inttostr(oldID) + ') ' +
//            ' AND (RTKPatternID = ' + inttostr(oldPatternID) + ');';
            ' AND (RTKPatternID = ' + inttostr(oldPatternID) + ');';
            frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
            //MessageDlg(sqlStr + ' Records: ' + inttostr(recordsAffected), mtInformation,[mbok],0);
          end;
        end else
          inc(dupeCount);
        recSet.MoveNext;
      end;
    end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end else begin
//else insert new records into RTKLinks based on those for the old scenario
    sqlStr := 'insert into RTKLinks ' +
    ' (ScenarioID, SewershedID, RDIIAreaID, RTKPatternID) ' +
    ' Select ' + inttostr(newID) + ', SewershedID, RDIIAreaID, RTKPatternID ' +
    ' from RTKLinks where (ScenarioID = ' + inttostr(oldID) + ');';
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  end;
  Result := dupeCount;
end;

function TDataModule1.GetWeekdayDWF(meterID: integer): THydrograph;
var
  queryStr: string;
  recSet: _RecordSet;
  index, timestep, numberOfPoints: integer;
  hydrograph: THydrograph;
begin
  timestep := GetFlowTimestep(meterID);
  numberOfPoints := 1440 div timestep;
  hydrograph := THydrograph.createWithSize(numberOfPoints,timestep);

  queryStr := 'SELECT Flow FROM WeekdayDWF WHERE (MeterID = ' + inttostr(meterID) +
              ') ORDER BY Minute;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if recSet.EOF then
  else begin
    recSet.MoveFirst;
    for index := 0 to numberOfPoints - 1 do begin
      //rm 2009-02-02 - error checking
      if recSet.EOF then begin
        break;
      end else begin
        hydrograph.flows[index] := recSet.Fields.Item[0].Value;
        recSet.MoveNext;
      end;
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  getWeekdayDWF := hydrograph;
end;

function TDataModule1.GetWeekendDWF(meterID: integer): THydrograph;
var
  queryStr: string;
  recSet: _RecordSet;
  index, timestep, numberOfPoints: integer;
  hydrograph: THydrograph;
begin
  timestep := GetFlowTimestep(meterID);
  numberOfPoints := 1440 div timestep;
  hydrograph := THydrograph.createWithSize(numberOfPoints,timestep);

  queryStr := 'SELECT Flow FROM WeekendAndHolidayDWF WHERE (MeterID = ' + inttostr(meterID) +
              ') ORDER BY Minute;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    for index := 0 to numberOfPoints - 1 do begin
      //rm 2009-02-02 - error checking
      if recSet.EOF then begin
        break;
      end else begin
        hydrograph.flows[index] := recSet.Fields.Item[0].Value;
        recSet.MoveNext;
      end;
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetWeekendDWF := hydrograph;
end;

procedure TDataModule1.UpdateMinMaxFlowTimes(meterID: integer);
var
  queryStr: string;
  recSet: _RecordSet;
  minDateTime, maxDateTime: TDateTime;
begin
  queryStr := 'SELECT MIN(DateTime), MAX(DateTime) FROM Flows WHERE ' +
              '(MeterID = ' + inttostr(meterID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
  minDateTime := recSet.Fields.Item[0].Value;
  maxDateTime := recSet.Fields.Item[1].Value;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;

  queryStr := 'SELECT StartDateTime, EndDateTime FROM Meters WHERE ' +
              '(MeterID = ' + inttostr(meterID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
  recSet.Fields.Item[0].Value := minDateTime;
  recSet.Fields.Item[1].Value := maxDateTime;
  recSet.UpdateBatch(1);
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

procedure TDataModule1.RemoveEvent(event: TStormEvent);
var
  sqlStr: string;
  recordsAffected: OleVariant;
  //rm 2009-07-27 - remove RTKPattern if it exists and if it is not used in any scenarios
  iRTKPAtternID: integer;
  sRTKPAtternName: string;
  ScenarioNames: TStringList;
begin
  //rm 2009-06-08 - remove any rtkpattern associated with the event as well?
  //rm - there is the chance that an event RTKPattern is in use in a scenario (RTKLinks)
  //check for this RTKPAtternID in RTKLinks table
  try
    iRTKPAtternID := GetRTKPatternID4Event(event.eventID);
    if (iRTKPatternID > -1) then begin //there is an RTKPAttern for this event
      sRTKPAtternName := GetRTKPatternNameForID(iRTKPatternID);
      ScenarioNames := GetScenarioNames4RTKPatternName(sRTKPAtternName);
      if (ScenarioNames.Count < 1) then begin //go ahead and delete RTKPattern
        sqlStr := 'DELETE FROM RTKPatterns WHERE (RTKPatternID = ' + inttostr(event.RTKPatternID) + ');';
        frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
      end;
      ScenarioNames.Free;
    end;
  finally
    sqlStr := 'DELETE FROM Events WHERE (EventID = ' + inttostr(event.eventID) + ');';
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  end;
end;


procedure TDataModule1.UpdateEvent(event: TStormEvent);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
//rm 2009-06-08 - rejigged for storing RTKs only in RTKPatterns table
(*
  sqlStr := 'UPDATE Events SET ' +
            'StartDateTime = ' + floattostr(event.StartDate) + ', ' +
            'EndDateTime = ' + floattostr(event.EndDate) + ', ' +
            'RTKPatternID = ' + inttostr(event.RTKPatternID) + ',' +
//            'MON = ' + inttostr(event.Mon) + ', ' +
            'AI = ' + floattostr(event.AI) + ', ' +
            'AM = ' + floattostr(event.AM) + ', ' +
            'AR = ' + floattostr(event.AR) + ', ' +
            'R1 = ' + floattostr(event.R[0]) + ', ' +
            'R2 = ' + floattostr(event.R[1]) + ', ' +
            'R3 = ' + floattostr(event.R[2]) + ', ' +
            'T1 = ' + floattostr(event.T[0]) + ', ' +
            'T2 = ' + floattostr(event.T[1]) + ', ' +
            'T3 = ' + floattostr(event.T[2]) + ', ' +
            'K1 = ' + floattostr(event.K[0]) + ', ' +
            'K2 = ' + floattostr(event.K[1]) + ', ' +
            'K3 = ' + floattostr(event.K[2]) + ' WHERE ' +
            '(EventID = ' + inttostr(event.eventID) + ');';
*)
  sqlStr := 'UPDATE Events SET ' +
            ' StartDateTime = ' + floattostr(event.StartDate) + ', ' +
            ' EndDateTime = ' + floattostr(event.EndDate) + ', ' +
            ' RTKPatternID = ' + inttostr(event.RTKPatternID) +
            ' WHERE ' +
            ' (EventID = ' + inttostr(event.eventID) + ');';
  //showmessage(sqlstr);
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
//rm 2010-09-29 additional initial abstraction terms
  sqlStr := 'UPDATE RTKPatterns SET ' +
            ' AI = ' + floattostr(event.AI[1]) + ', ' +
            ' AM = ' + floattostr(event.AM[1]) + ', ' +
            ' AR = ' + floattostr(event.AR[1]) + ', ' +
            ' AI2 = ' + floattostr(event.AI[2]) + ', ' +
            ' AM2 = ' + floattostr(event.AM[2]) + ', ' +
            ' AR2 = ' + floattostr(event.AR[2]) + ', ' +
            ' AI3 = ' + floattostr(event.AI[3]) + ', ' +
            ' AM3 = ' + floattostr(event.AM[3]) + ', ' +
            ' AR3 = ' + floattostr(event.AR[3]) + ', ' +
            ' R1 = ' + floattostr(event.R[0]) + ', ' +
            ' R2 = ' + floattostr(event.R[1]) + ', ' +
            ' R3 = ' + floattostr(event.R[2]) + ', ' +
            ' T1 = ' + floattostr(event.T[0]) + ', ' +
            ' T2 = ' + floattostr(event.T[1]) + ', ' +
            ' T3 = ' + floattostr(event.T[2]) + ', ' +
            ' K1 = ' + floattostr(event.K[0]) + ', ' +
            ' K2 = ' + floattostr(event.K[1]) + ', ' +
            ' K3 = ' + floattostr(event.K[2]) +
            ' WHERE ' +
            ' (RTKPatternID = ' + inttostr(event.RTKPatternID) + ');';
  //showmessage(sqlstr);
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  //illegal characters may make the description update fail:
//  sqlStr := 'UPDATE Events SET RTKDescription = ' +
//            '"' + Trim(event.RTKDesc) + '" WHERE ' +
//            '(EventID = ' + inttostr(event.eventID) + ');';
//TODO: strip out any characters that would cause the SQL Update to fail
  sqlStr := 'UPDATE RTKPatterns SET RTKPatternName = ' +
            '"' + Trim(event.RTKName) + '" WHERE ' +
            '(RTKPatternID = ' + inttostr(event.RTKPatternID) + ');';
  //showmessage(sqlstr);
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'UPDATE RTKPatterns SET Description = ' +
            '"' + Trim(event.RTKDesc) + '" WHERE ' +
            '(RTKPatternID = ' + inttostr(event.RTKPatternID) + ');';
  //showmessage(sqlstr);
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;


procedure TDataModule1.UpdateFlowMeterIDForRDIIAreasInSewerShed(
  sSewerShedName: string);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'update RDIIAreas as a INNER JOIN Sewersheds as b ' +
            ' ON a.SewershedID = b.SewershedID ' +
            ' set a.MeterID = b.MeterID ' +
            ' Where b.SewerShedName = "' + sSewerShedName + '";';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.UpdateHoliday(OldHolidayName: string;
  OldHolidayDate: TDate; HolidayName: string; HolidayDate: TDate);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'update Holidays set Label = "' + HolidayName +
            '" , HolidayDate = ' + floattostr(Floor(HolidayDate)) +
            ' Where Label = "' + OldHolidayName +
            '" and HolidayDate = ' + floattostr(Floor(OldHolidayDate)) + ';';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

function TDataModule1.GetEvents(analysisID: integer): TStormEventCollection;
var
  queryStr : string;
  recSet: _RecordSet;
  index: integer;
  events: TStormEventCollection;
  event: TStormEvent;
begin
  events := TStormEventCollection.Create;
  events.Capacity := 50;
//rm 2009-06-08 - Redoing this with join to RTKPatterns
//  queryStr := 'SELECT EventID, StartDateTime, EndDateTime, ' +
//              ' R1, R2, R3, T1, T2, T3, K1, K2, K3, ' +
//              ' AI, AM, AR, RTKDescription, RTKPatternID ' +
//              ' FROM Events WHERE (AnalysisID = ' + inttostr(analysisID) + ');';
//rm 2010-09-29 - redoing with the extra initial abstraction terms
{
  queryStr := 'SELECT a.EventID, a.StartDateTime, a.EndDateTime, ' +
              ' b.R1, b.R2, b.R3, b.T1, b.T2, b.T3, b.K1, b.K2, b.K3, ' +
              ' b.AI, b.AM, b.AR, b.Description, b.RTKPatternID, b.RTKPatternName ' +
              ' FROM Events a left join RTKPatterns b ' +
              ' on a.RTKPatternID = b.RTKPatternID ' +
              ' WHERE (a.AnalysisID = ' + inttostr(analysisID) + ')' +
              ' ORDER BY a.EventID;';
  }
  queryStr := 'SELECT a.EventID, a.StartDateTime, a.EndDateTime, ' +
              ' b.R1, b.R2, b.R3, b.T1, b.T2, b.T3, b.K1, b.K2, b.K3, ' +
              ' b.AI, b.AM, b.AR, b.AI2, b.AM2, b.AR2, b.AI3, b.AM3, b.AR3, ' +
              ' b.Description, b.RTKPatternID, b.RTKPatternName ' +
              ' FROM Events a left join RTKPatterns b ' +
              ' on a.RTKPatternID = b.RTKPatternID ' +
              ' WHERE (a.AnalysisID = ' + inttostr(analysisID) + ')' +
              ' ORDER BY a.EventID;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    event := TStormEvent.Create;
    event.EventID := recSet.Fields.Item[0].Value;
    event.StartDate := recSet.Fields.Item[1].Value;
    event.EndDate   := recSet.Fields.Item[2].Value;
    for index := 0 to 2 do begin
      if not VarIsNull(recSet.Fields.Item[3+index].Value) then
        event.R[index] := recSet.Fields.Item[3+index].Value
      else event.R[index] := 0;
      if not VarIsNull(recSet.Fields.Item[6+index].Value) then
        event.T[index] := recSet.Fields.Item[6+index].Value
      else event.T[index] := 0;
      if not VarIsNull(recSet.Fields.Item[9+index].Value) then
        event.K[index] := recSet.Fields.Item[9+index].Value
      else event.K[index] := 0;
    end;
    if not VarIsNull(recSet.Fields.Item[12].Value) then
      event.AI[1] := recSet.Fields.Item[12].Value
    else event.AI[1] := 0;
    if not VarIsNull(recSet.Fields.Item[13].Value) then
      event.AM[1] := recSet.Fields.Item[13].Value
    else event.AM[1] := 0;
    if not VarIsNull(recSet.Fields.Item[14].Value) then
      event.AR[1] := recSet.Fields.Item[14].Value
    else event.AR[1] := 0;
//rm 2010-09-29
    if not VarIsNull(recSet.Fields.Item[15].Value) then
      event.AI[2] := recSet.Fields.Item[15].Value
    else event.AI[2] := 0;
    if not VarIsNull(recSet.Fields.Item[16].Value) then
      event.AM[2] := recSet.Fields.Item[16].Value
    else event.AM[2] := 0;
    if not VarIsNull(recSet.Fields.Item[17].Value) then
      event.AR[2] := recSet.Fields.Item[17].Value
    else event.AR[2] := 0;
    if not VarIsNull(recSet.Fields.Item[18].Value) then
      event.AI[3] := recSet.Fields.Item[18].Value
    else event.AI[3] := 0;
    if not VarIsNull(recSet.Fields.Item[19].Value) then
      event.AM[3] := recSet.Fields.Item[19].Value
    else event.AM[3] := 0;
    if not VarIsNull(recSet.Fields.Item[20].Value) then
      event.AR[3] := recSet.Fields.Item[20].Value
    else event.AR[3] := 0;
//rm
    if not VarIsNull(recSet.Fields.Item[21].Value) then
      event.RTKDesc := recSet.Fields.Item[21].Value
    else event.RTKDesc := '';
    if not VarIsNull(recSet.Fields.Item[22].Value) then
      event.RTKPatternID := recSet.Fields.Item[22].Value
    else event.RTKPatternID := -1;
    if not VarIsNull(recSet.Fields.Item[23].Value) then
      event.RTKName := recSet.Fields.Item[23].Value
    else event.RTKName := '';
//rm 2011-03-28
    event.AnalysisID := analysisID;
    events.AddEvent(event);
    recSet.moveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  getEvents := events;
end;

procedure TDataModule1.AddGWIAdjustment(analysisID: integer; adjustment: TGWIAdjustment);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'INSERT INTO GWIAdjustments (AnalysisID,AdjustmentDate,AdjustmentValue) ' +
            'VALUES (' + inttostr(analysisID) + ',' + floattostr(adjustment.Date) + ',' +
            floattostr(adjustment.Value) + ');';
  frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
end;

procedure TDataModule1.AddHoliday(HolidayName: string; HolidayDate: TDate);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'INSERT INTO Holidays (Label, HolidayDate) ' +
            'VALUES ("' + HolidayName + '",' +
            floattostr(HolidayDate) + ');';
  frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
end;

procedure TDataModule1.AddRTKLink(iScenarioID, iSewerShedID, iRDIIAreaID,
  iRTKPatternID, iRainGaugeID: integer; sDescription: string);
var
  sqlStr,queryStr: string;
  recSet: _RecordSet;
  recordsAffected: OleVariant;
  ExRTKLinkID : integer;
begin
  if iRDIIAreaID < 0 then
  queryStr := 'Select RTKLinkID from RTKLinks ' +
            ' Where ((ScenarioID = ' + inttostr(iScenarioID) + ') ' +
            ' And (SewerShedID = ' + inttostr(iSewerShedID) + '));'
  else
  queryStr := 'Select RTKLinkID from RTKLinks ' +
            ' Where ((ScenarioID = ' + inttostr(iScenarioID) + ') ' +
            ' And (RDIIAreaID = ' + inttostr(iRDIIAreaID) + '));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    ExRTKLinkID := recSet.Fields.Item[0].Value;
    sqlStr := 'DELETE From RTKLinks ' +
              ' WHERE RTKLinkID = ' + inttostr(ExRTKLinkID);
    frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  sqlStr := 'INSERT INTO RTKLinks ' +
    ' (ScenarioID, SewerShedID, RDIIAreaID, RTKPatternID, ' +
    ' RaingaugeID, Description) ' +
    ' VALUES( ' +
    inttostr(iScenarioID) + ',' +
    inttostr(iSewerShedID) + ',' +
    inttostr(iRDIIAreaID) + ',' +
    inttostr(iRTKPAtternID) + ',' +
    inttostr(iRainGaugeID) + ',' +
    ' "' + sDescription + '");';
  frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
end;

procedure TDataModule1.AddRTKPattern(RTKPatternList: TStringList);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
//rm 2010-09-29 - updated to include initial abstraction for the other two RTK sets
{
  sqlStr := 'INSERT INTO RTKPatterns ' +
            ' (RTKPatternName, ' +
            ' R1, T1, K1, ' +
            ' R2, T2, K2, ' +
            ' R3, T3, K3, ' +
            ' AI, AM, AR, Mon, ' +
            ' Description) ' +
            'VALUES ("' +
            RTKPatternList[0] + '",' +
            RTKPatternList[1] + ',' + RTKPatternList[2] + ',' + RTKPatternList[3] + ',' +
            RTKPatternList[4] + ',' + RTKPatternList[5] + ',' + RTKPatternList[6] + ',' +
            RTKPatternList[7] + ',' + RTKPatternList[8] + ',' + RTKPatternList[9] + ',' +
            RTKPatternList[10] + ',' + RTKPatternList[11] + ',' + RTKPatternList[12] + ',' +
            RTKPatternList[13] + ',' +
            '"' + RTKPatternList[14] +
            '");';
}
  sqlStr := 'INSERT INTO RTKPatterns ' +
            ' (RTKPatternName, ' +
            ' R1, T1, K1, ' +
            ' R2, T2, K2, ' +
            ' R3, T3, K3, ' +
            ' AI, AM, AR, ' +
            ' AI2, AM2, AR2, ' +
            ' AI3, AM3, AR3, ' +
            ' Mon, ' +
            ' Description) ' +
            'VALUES ("' +
            RTKPatternList[0] + '",' +
            RTKPatternList[1] + ',' + RTKPatternList[2] + ',' + RTKPatternList[3] + ',' +
            RTKPatternList[4] + ',' + RTKPatternList[5] + ',' + RTKPatternList[6] + ',' +
            RTKPatternList[7] + ',' + RTKPatternList[8] + ',' + RTKPatternList[9] + ',' +
            RTKPatternList[10] + ',' + RTKPatternList[11] + ',' + RTKPatternList[12] + ',' +
            RTKPatternList[13] + ',' + RTKPatternList[14] + ',' + RTKPatternList[15] + ',' +
            RTKPatternList[16] + ',' + RTKPatternList[17] + ',' + RTKPatternList[18] + ',' +
            RTKPatternList[19] + ',' +
            '"' + RTKPatternList[20] +
            '");';
  frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
end;

procedure TDataModule1.RemoveGWIAdjustment(analysisID: integer; adjustment: TGWIAdjustment);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'DELETE FROM GWIAdjustments WHERE (AnalysisID = ' +
             inttostr(analysisID) + ') AND (AdjustmentDate = ' +
             floattostr(adjustment.date) + ');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;


procedure TDataModule1.RemoveHoliday(HolidayName: string;
  HolidayDate: TDateTime);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'DELETE FROM Holidays WHERE (Label = "' +
             HolidayName + '") AND (HolidayDate = ' +
             floattostr(HolidayDate) + ');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.RemoveJunctionDepthTS(scID: integer; junID: string);
var sSQL: string;
    sBool: string;
    recordsAffected: OleVariant;
begin
//step 1 - remove ts details
  if (Length(junID) < 1) then begin //delete all for the entire scenario
    sSQL := 'Delete d.* FROM JuncDepthTSDetail AS d INNER JOIN JuncDepthTSMaster AS m ' +
      ' ON d.JuncDepthTSMasterID = m.JuncDepthTSMasterID ' +
      ' where m.ScenarioID = ' + IntToStr(scID);
  end else begin
    sSQL := 'Delete d.* FROM JuncDepthTSDetail AS d INNER JOIN JuncDepthTSMaster AS m ' +
      ' ON d.JuncDepthTSMasterID = m.JuncDepthTSMasterID ' +
      ' where m.JunctionID = "' + junID +
      '" and m.ScenarioID = ' + IntToStr(scID);
  end;
  frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
//step 2 - remove ts master(s)
  if (Length(junID) < 1) then begin //delete all for the entire scenario
    sSQL := 'Delete FROM JuncDepthTSMaster ' +
      ' where ScenarioID = ' + IntToStr(scID);
  end else begin
    sSQL := 'Delete FROM JuncDepthTSMaster ' +
      ' where JunctionID = "' + junID +
      '" and ScenarioID = ' + IntToStr(scID);
  end;
  frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
end;

procedure TDataModule1.RemoveJunctionFlowTS(scID: integer; junID: string);
var sSQL: string;
    sBool: string;
    recordsAffected: OleVariant;
begin
//step 1 - remove ts details
  if (Length(junID) < 1) then begin //delete all for the entire scenario
    sSQL := 'Delete d.* FROM JuncFlowTSDetail AS d INNER JOIN JuncFlowTSMaster AS m ' +
      ' ON d.JuncFlowTSMasterID = m.JuncFlowTSMasterID ' +
      ' where m.ScenarioID = ' + IntToStr(scID);
  end else begin
    sSQL := 'Delete d.* FROM JuncFlowTSDetail AS d INNER JOIN JuncFlowTSMaster AS m ' +
      ' ON d.JuncFlowTSMasterID = m.JuncFlowTSMasterID ' +
      ' where m.JunctionID = "' + junID +
      '" and m.ScenarioID = ' + IntToStr(scID);
  end;
  frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
//step 2 - remove ts master(s)
  if (Length(junID) < 1) then begin //delete all for the entire scenario
    sSQL := 'Delete FROM JuncFlowTSMaster ' +
      ' where ScenarioID = ' + IntToStr(scID);
  end else begin
    sSQL := 'Delete FROM JuncFlowTSMaster ' +
      ' where JunctionID = "' + junID +
      '" and ScenarioID = ' + IntToStr(scID);
  end;
  frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
end;

procedure TDataModule1.UpdateAdjustmentValueForGWIAdjustment(analysisID: integer; adjustment: TGWIAdjustment);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'UPDATE GWIAdjustments SET AdjustmentValue = ' +
            floattostr(adjustment.value) + ' WHERE ' +
            '(AnalysisID = ' + inttostr(analysisID) + ') AND ' +
            '(AdjustmentDate = ' + floattostr(adjustment.date) + ');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.UpdateAreaUnitIDForRDIIAreasInSewerShed(
  sSewerShedName: string);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'update RDIIAreas as a INNER JOIN Sewersheds as b ' +
            ' ON a.SewershedID = b.SewershedID ' +
            ' set a.AreaUnitID = b.AreaUnitID ' +
            ' Where b.SewerShedName = "' + sSewerShedName + '";';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.UpdateConditionAssessment(caID: integer; sField,
  sValue: string);
var
  sqlStr: string;
  recordsAffected: OleVariant;
  sFld: string;
begin
  sqlStr := 'update ConditionAssessments ' +
            ' set ' + sField + ' = ' + sValue +
            ' Where CAID = ' + IntToStr(caID) + ';';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.UpdateDatabase;
var
  sSQL: string;
  recordsAffected: OleVariant;
begin
//rm 2011-03-20
  sSQL := 'Create table ConditionAssessments (CAID autoincrement NOT NULL PRIMARY KEY, CAName text(50), Analysis1 text(50), Analysis2 text(50), Analysis3 text(50), Analysis4 text(50), OverlapTol integer, OverlapEvents_Pre integer, OverlapEvents_Post integer)';
  frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
//rm 2012-04-09
  sSQL := 'Create Unique Index pIndex0 on ConditionAssessments (CAName)';
  frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);

end;

procedure TDataModule1.UpdateDatabase_ComparisonScenario;
var
  sSQL: string;
  recordsAffected: OleVariant;
begin
//rm 2012-04-09
  sSQL := 'Create table ComparisonScenarios (ComparisonScenarioID autoincrement NOT NULL PRIMARY KEY, ComparisonScenarioName text(50), ComparisonOption integer, ComparisonStatsOption integer, NumSubSewershed integer)';
  frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);

  sSQL := 'Create table ComparisonScenarioDetails (ComparisonScenarioDetailsID autoincrement NOT NULL PRIMARY KEY, ComparisonScenarioID integer, AnalysisID integer, AnalysisName text(50))';
  frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);

  //CREATE INDEX index_name
  //ON table_name (column_name)

  sSQL := 'Create Unique Index pIndex1 on ComparisonScenarios (ComparisonScenarioName)';
  frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);

  sSQL := 'Create Index pIndex2 on ComparisonScenarios (NumSubSewershed)';
  frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);

  sSQL := 'Create Index pIndex3 on ComparisonScenarioDetails (ComparisonScenarioID)';
  frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);

  sSQL := 'Create Index pIndex4 on ComparisonScenarioDetails (AnalysisID)';
  frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);


end;


function TDataModule1.GetGWIAdjustments(analysisID: integer): TGWIAdjustmentCollection;
var
  queryStr : string;
  recSet: _RecordSet;
  date: integer;
  adjustment: real;
  gwiAdjustments: TGWIAdjustmentCollection;
begin
  gwiAdjustments := TGWIAdjustmentCollection.Create;
  gwiAdjustments.Capacity := 50;
  queryStr := 'SELECT AdjustmentDate, AdjustmentValue FROM GWIAdjustments ' +
              'WHERE (AnalysisID = ' + inttostr(analysisID) + ') ' +
              'ORDER BY AdjustmentDate;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    date := recSet.Fields.Item[0].Value;
    adjustment := recSet.Fields.Item[1].Value;
    gwiAdjustments.Add(TGWIAdjustment.Create(date,adjustment));
    recSet.moveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  getGWIAdjustments := gwiAdjustments;
end;

function TDataModule1.RainfallTotalForRaingaugeAndDay(raingaugeID: integer; day: TDate): real;
var
  queryStr : string;
  recSet: _RecordSet;
  volume: double;
begin
  volume := 0.0;
  queryStr := 'SELECT Sum(Volume) FROM Rainfall WHERE ' +
              '((RaingaugeID = ' + inttostr(raingaugeID) + ') AND ' +
              '(Int(DateTime)= ' + floattostr(day) + '));';
  try
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if (not recSet.EOF) then begin
      recSet.MoveFirst;
      if VarIsNull(recSet.Fields.Item[0].Value) then begin
        volume := 0.0;
      end
      else begin
        volume := recSet.Fields.Item[0].Value;
      end;
    end
    else begin
      volume := 0.0;
    end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  except
    volume := 0.0;
  end;
  RainfallTotalForRaingaugeAndDay := volume;
end;

function TDataModule1.RainfallTotalForRaingaugeBetweenDates(raingaugeID: integer; startDate, endDate: TDateTime): real;
var
  queryStr: string;
  recSet: _recordSet;
begin
  RainfallTotalForRaingaugeBetweenDates := 0.0;
  queryStr := 'SELECT Sum(Volume) FROM Rainfall WHERE ' +
              '(((DateTime >= ' + floattostr(startDate) + ') AND ' +
              '(DateTime <= ' + floattostr(endDate) + ')) AND ' +
              '(RaingaugeID = ' + inttostr(raingaugeID) + '));';
  recSet := CoRecordSet.Create;
  {if there are no rainfall records in the time period, the recSet.Open query
   will fail.  Wrap it in an exception handler for now.  Later consider using
   a parameterized query which may or may not have the same problem!}
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if (not recSet.EOF) then begin
      recSet.MoveFirst;
      // - check for null
      if VarIsNull(recSet.Fields.Item[0].Value) then
        RainfallTotalForRaingaugeBetweenDates := 0.0
      else
        RainfallTotalForRaingaugeBetweenDates := recSet.Fields.Item[0].Value;
    end
    else begin
      RainfallTotalForRaingaugeBetweenDates := 0.0;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.RainfallTotalPreceding2Wks(startDateTime: TDateTime; raingaugeID: integer): real;
var
  queryStr: string;
  recSet: _recordSet;
  twoWeeksDateTimeBegin : TDateTime;
begin
  RainfallTotalPreceding2Wks := 0.0;
  twoWeeksDateTimeBegin := IncDay(startDateTime, -14);
  queryStr := 'SELECT Sum(Volume) FROM Rainfall WHERE ' +
              '(((DateTime >= ' + floattostr(twoWeeksDateTimeBegin) + ') AND ' +
              '(DateTime <= ' + floattostr(startDateTime) + ')) AND ' +
              '(RaingaugeID = ' + inttostr(raingaugeID) + '));';
  recSet := CoRecordSet.Create;
  {if there are no rainfall records in the time period, the recSet.Open query
   will fail.  Wrap it in an exception handler for now.  Later consider using
   a parameterized query which may or may not have the same problem!}
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if (not recSet.EOF) then begin
      recSet.MoveFirst;
      if VarIsNull(recSet.Fields.Item[0].value) then
        RainfallTotalPreceding2Wks := 0.0
      else
        RainfallTotalPreceding2Wks := recSet.Fields.Item[0].Value;
    end
    else begin
      RainfallTotalPreceding2Wks := 0.0;
    end;
  except
    RainfallTotalPreceding2Wks := 0.0;
  end;
  if (recSet.State <> adStateClosed) then recSet.Close;
end;

{GetRainfallTotalPreceding2Wks(startDateTime: TDateTime) : real;}
function TDataModule1.GetAnalysisIDForName(analysisName: string): integer;
var
  iResult: integer;
  queryStr: string;
  recSet: _recordSet;
begin
  iResult := -1;
  if Length(analysisName) > 0 then
  begin
    queryStr := 'SELECT AnalysisID FROM Analyses WHERE (AnalysisName = "' + analysisName + '")';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      iResult := recSet.Fields.Item[0].Value;
    end else iResult := -1;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  Result := iResult;
end;

function TDataModule1.GetCAID4Name(caName: string): integer;
var
  iResult: integer;
  queryStr: string;
  recSet: _recordSet;
begin
  iResult := -1;
  if Length(caName) > 0 then
  begin
    queryStr := 'SELECT CAID FROM ConditionAssessments WHERE (CAName = "' + caName + '")';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      iResult := recSet.Fields.Item[0].Value;
    end else iResult := -1;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  Result := iResult;
end;

function TDataModule1.GetCAName4CAID(caID: integer): string;
var
  sResult: string;
  queryStr: string;
  recSet: _recordSet;
  s: string;
begin
  sResult := '';
  s := IntToStr(caID);
  if Length(s) > 0 then
  begin
    queryStr := 'SELECT CAName FROM ConditionAssessments WHERE (CAID = ' + s + ')';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      sResult := recSet.Fields.Item[0].Value;
    end else sResult := '';
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  Result := sResult;
end;

function TDataModule1.GetConditionAssessmentNames: TStringList;
var
  caNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  caNames := TStringList.Create;
  queryStr := 'SELECT CAName FROM ConditionAssessments;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    if (not recSet.EOF) then recSet.MoveFirst;
    while (not recSet.EOF) do begin
      caNames.Add(vartostr(recSet.Fields.Item[0].Value));
      recSet.MoveNext;
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  result := caNames;
end;

function TDataModule1.GetCondMaxCap(scID: integer; conID: string): double;
var
  dResult: double;
  queryStr: string;
  recSet: _recordSet;
begin
  dResult := 0.0;
  if Length(conID) > 0 then begin
    queryStr := 'SELECT MaxCapacity FROM ConduitMaxCapacity ' +
    ' WHERE (ConduitID = "' + conID + '") ' +
    ' AND (ScenarioID = ' + inttostr(scID) + ')';
    recSet := CoRecordSet.Create;
    try
      recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      if not recSet.EOF then begin
        recSet.MoveFirst;
        dResult := recSet.Fields.Item[0].Value;
      end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  Result := dResult;
end;

function TDataModule1.GetCondMaxCapUnitLabel(scID: integer; conID: string;
  var iUnitID: integer): String;
var
  queryStr, sReturn: string;
  recSet: _RecordSet;
begin
  sReturn := 'MGD';  //default
  iUnitID := 1;
  recSet := CoRecordSet.Create;
  queryStr := 'SELECT a.FlowUnitID, b.ShortLabel ' +
    ' FROM ConduitMaxCapacity a inner join FlowUnits b ' +
    ' on a.FlowUnitID = b.FlowUnitID ' +
    ' where a.ScenarioID = ' + IntToStr(scID) +
    ' and a.ConduitID = "' + conID + '"';
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    iUnitID := recSet.Fields.Item[0].Value;
    sReturn := recSet.Fields.Item[1].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := sReturn;
end;

function TDataModule1.GetConduitsbyScenario(scID: integer;
  sWhereClause: string): TStringList;
var
  returnStringList: TStringList;
  queryStr, sID: string;
  recSet: _RecordSet;
begin
  returnStringList := TStringList.Create;
  recSet := CoRecordSet.Create;
  queryStr := 'Select ConduitID from ConduitMaxCapacity ' +
    ' where ScenarioID = ' + IntToStr(scID);
  if (Length(sWhereClause) > 0) then
    queryStr := queryStr + ' and ' + sWhereClause;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    while not recSet.EOF do begin
      sID := recSet.Fields.Item[0].Value;
      returnStringList.Add(sID);
      recSet.MoveNext;
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := returnStringList;
end;

function TDataModule1.GetConversionFactorForAreaUnitID(
  areaUnitID: integer): double;
var
  dResult: double;
  queryStr: string;
  recSet: _recordSet;
begin
  dResult := 1.0;
  if areaUnitID > 0 then begin
    queryStr := 'SELECT ConversionFactor FROM AreaUnits WHERE (AreaUnitID = ' +
      inttostr(areaUnitID) + ')';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      dResult := recSet.Fields.Item[0].Value;
    end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  Result := dResult;
end;

function TDataModule1.GetConversionFactorForFlowUnitID(
  flowUnitID: integer): double;
var
  dResult: double;
  queryStr: string;
  recSet: _recordSet;
begin
  dResult := 1.0;
  if flowUnitID > 0 then begin
    queryStr := 'SELECT ConversionFactor FROM FlowUnits ' +
      ' WHERE (FlowUnitID = ' + IntToStr(flowUnitID) + ')';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      dResult := recSet.Fields.Item[0].Value;
    end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  Result := dResult;
end;

function TDataModule1.GetConversionFactorForFlowUnitLabel(
  flowUnitLabel: string): double;
var
  dResult: double;
  queryStr: string;
  recSet: _recordSet;
begin
  dResult := 1.0;
  if Length(flowUnitLabel) > 0 then begin
    queryStr := 'SELECT ConversionFactor FROM FlowUnits WHERE (ShortLabel = "' + flowUnitLabel + '")';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      dResult := recSet.Fields.Item[0].Value;
    end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  Result := dResult;
end;

function TDataModule1.GetConversionFactorForAreaUnitLabel(
  areaUnitLabel: string): double;
var
  dResult: double;
  queryStr: string;
  recSet: _recordSet;
begin
  dResult := 1.0;
  if Length(areaUnitLabel) > 0 then begin
    queryStr := 'SELECT ConversionFactor FROM AreaUnits WHERE (ShortLabel = "' + areaUnitLabel + '")';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      dResult := recSet.Fields.Item[0].Value;
    end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  Result := dResult;
end;

function TDataModule1.GetConversionFactorForRainUnitLabel(
  rainUnitLabel: string): double;
var
  dResult: double;
  queryStr: string;
  recSet: _recordSet;
begin
  dResult := 1.0;
  if Length(rainUnitLabel) > 0 then
  begin
    queryStr := 'SELECT ConversionFactor FROM RainUnits WHERE (ShortLabel = "' + rainUnitLabel + '")';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      dResult := recSet.Fields.Item[0].Value;
    end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  Result := dResult;
end;

function TDataModule1.GetConversionFactorToUnitForMeter(meterID: integer; unitLabel: string): double;//real;
var
  meterFlowUnitID, destFlowUnitID: integer;
  meterConversionFactor, destConversionFactor: real;
  queryStr: string;
  recSet1, recSet2: _RecordSet;
  dResult: double;
begin
  dResult := 1.0;
  meterFlowUnitID := GetFlowUnitIDForFlowMeter(meterID);
  destFlowUnitID := GetFlowUnitID(unitLabel);
  //rm 2009-06-11 - some change here
  if (meterFlowUnitID <> destFlowUnitID) then begin
    meterConversionFactor := 0;
    queryStr := 'SELECT ConversionFactor FROM FlowUnits WHERE ' +
                '(FlowUnitID = ' + inttostr(meterFlowUnitID) + ');';
    recSet1 := CoRecordSet.Create;
    try
      recSet1.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      if not recSet1.EOF then begin
        meterConversionFactor := recSet1.Fields.Item[0].Value;
      end;
    finally
      if (recSet1.State <> adStateClosed) then recSet1.Close;
    end;
    if destFlowUnitID > 0 then begin
      destConversionFactor := 0;
      queryStr := 'SELECT ConversionFactor FROM FlowUnits WHERE ' +
                  '(FlowUnitID = ' + inttostr(destFlowUnitID) + ');';
      recSet2 := CoRecordSet.Create;
      try
        recSet2.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
        if not recSet2.EOF then begin
          destConversionFactor := recSet2.Fields.Item[0].Value;
        end else begin
          destConversionFactor := meterConversionFactor;
        end;
      finally
        if (recSet2.State <> adStateClosed) then recSet2.Close;
      end;
    end else begin
      destConversionFactor := meterConversionFactor;
    end;
    dResult :=  meterConversionFactor / destConversionFactor;
  end;
  GetConversionFactorToUnitForMeter := dResult;
  //rm 2009-06-11 - testing
  //showmessage('Unit ID / Dest Unit ID Factor = ' +  inttostr(meterFlowUnitID) + '/' +
  //  inttostr(destFlowUnitID) + ' = ' + floattostr(dResult));
end;


function TDataModule1.GetConversionFactorToUnitForRdiiArea(sewershedID: integer; unitLabel: string): real;
var
  sewershedAreaUnitID, destAreaUnitID: integer;
  areaConversionFactor, destConversionFactor: real;
  queryStr: string;
  recSet: _RecordSet;
begin
  sewershedAreaUnitID := GetAreaUnitIDForSewershed(sewershedID);
  destAreaUnitID := GetAreaUnitID(unitLabel);

  if (sewershedAreaUnitID = destAreaUnitID) then
    GetConversionFactorToUnitForRdiiArea := 1.0
  else begin
    queryStr := 'SELECT ConversionFactor FROM AreaUnits WHERE ' +
                '(AreaUnitID = ' + inttostr(sewershedAreaUnitID) + ');';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    areaConversionFactor := recSet.Fields.Item[0].Value;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;

    queryStr := 'SELECT ConversionFactor FROM AreaUnits WHERE ' +
                '(AreaUnitID = ' + inttostr(destAreaUnitID) + ');';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    destConversionFactor := recSet.Fields.Item[0].Value;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
    GetConversionFactorToUnitForRdiiArea :=  areaConversionFactor / destConversionFactor;
  end;
end;

function TDataModule1.GetFlowUnitLabels(): TStringList;
var
  unitLabels: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  unitLabels := TStringList.Create;
  queryStr := 'SELECT ShortLabel FROM FlowUnits;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    unitLabels.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetFlowUnitLabels := unitLabels;
end;

function TDataModule1.GetVelocityUnitLabels(): TStringList;
var
  unitLabels: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  unitLabels := TStringList.Create;
  queryStr := 'SELECT ShortLabel FROM VelocityUnits;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    unitLabels.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetVelocityUnitLabels := unitLabels;
end;

function TDataModule1.GetVollabel(sFlowUnitLabel: string;
  var dVol: double): string;
var sResult: string;
begin
//rm 2010-10-20 converting from Cubic Feet to either MG or L
  if sFlowUnitLabel = 'CFS' then begin
    sResult := ' CF';
  end else if sFlowUnitLabel = 'CMS' then begin
    dVol := dVol * 0.0283168;
    sResult := ' m3';
  end else if sFlowUnitLabel = 'GPM' then begin
    dVol := dVol * 0.00000748051;
    sResult := ' MG';
  end else if sFlowUnitLabel = 'LPS' then begin
    dVol := dVol * 28.3168;
    sResult := ' L';
  end else if sFlowUnitLabel = 'MGD' then begin
    dVol := dVol * 0.00000748051;
    sResult := ' MG';
  end else if sFlowUnitLabel = 'MLD' then begin
    dVol := dVol * 0.0000283168;
    sResult := ' ML';
  end else begin
    sResult := sFlowUnitLabel;
  end;
  Result := sResult;
end;

function TDataModule1.GetVolUnitLabel4FlowUnitLabel(flowlabel: string): String;
var sReturn: string;
begin
    //generally take the first two characters of flowunits label to get volume units
    //except for GPM -> "G" and "LPS" -> "L"
  sReturn := UpperCase(flowlabel);
  if (sReturn = 'GPM') then sReturn := 'G'
  else if (sReturn = 'LPS') then sReturn := 'L'
  else sReturn := Copy(sReturn,1,2);
  Result := sReturn;
end;

function TDataModule1.GetDepthUnitLabels(): TStringList;
var
  unitLabels: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  unitLabels := TStringList.Create;
  queryStr := 'SELECT ShortLabel FROM DepthUnits;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    unitLabels.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetDepthUnitLabels := unitLabels;
end;

function TDataModule1.GetAreaUnitLabels(): TStringList;
var
  unitLabels: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  unitLabels := TStringList.Create;
  queryStr := 'SELECT ShortLabel FROM AreaUnits;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    unitLabels.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetAreaUnitLabels := unitLabels;
end;

function TDataModule1.GetRainUnitLabels(): TStringList;
var
  unitLabels: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  unitLabels := TStringList.Create;
  queryStr := 'SELECT Label FROM RainUnits;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    unitLabels.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetRainUnitLabels := unitLabels;
end;

function TDataModule1.GetFlowMeterNames(): TStringList;
var
  meterNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  meterNames := TStringList.Create;
  queryStr := 'SELECT MeterName FROM Meters;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    meterNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetFlowMeterNames := meterNames;
end;

function TDataModule1.GetScenarioNames(): TStringList;
var
  scenarioNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  scenarioNames := TStringList.Create;
  queryStr := 'SELECT ScenarioName FROM Scenarios order by ScenarioID;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    scenarioNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetScenarioNames := scenarioNames;
end;

function TDataModule1.GetComparisonScenarioNames(): TStringList;
var
  comparsionScenarioNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  comparsionScenarioNames := TStringList.Create;
  queryStr := 'SELECT ComparisonScenarioName FROM ComparisonScenarios order by ComparisonScenarioID;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    comparsionScenarioNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetComparisonScenarioNames := comparsionScenarioNames;
end;



function TDataModule1.GetNumofSubsewershedForComparisonScenarioName(cScenarioName: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
if Length(cScenarioName) > 0 then
  begin
    queryStr := 'SELECT NumSubSewershed FROM ComparisonScenarios WHERE (ComparisonScenarioName = "' + cScenarioName + '")';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      GetNumofSubsewershedForComparisonScenarioName := recSet.Fields.Item[0].Value;
    end else Result := -1;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end else Result := -1;
end;


function TDataModule1.GetComparisonOptionForComparisonScenarioName(cScenarioName: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
if Length(cScenarioName) > 0 then
  begin
    queryStr := 'SELECT ComparisonOption FROM ComparisonScenarios WHERE (ComparisonScenarioName = "' + cScenarioName + '")';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      GetComparisonOptionForComparisonScenarioName := recSet.Fields.Item[0].Value;
    end else Result := -1;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end else Result := -1;
end;


function TDataModule1.GetComparisonStatsOptionForComparisonScenarioName(cScenarioName: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
if Length(cScenarioName) > 0 then
  begin
    queryStr := 'SELECT ComparisonStatsOption FROM ComparisonScenarios WHERE (ComparisonScenarioName = "' + cScenarioName + '")';
    recSet := CoRecordSet.Create;
    try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then
    begin
      recSet.MoveFirst;
      GetComparisonStatsOptionForComparisonScenarioName := recSet.Fields.Item[0].Value;
    end else Result := -1;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end else Result := -1;
end;


function TDataModule1.GetAnalysisfromComparisonScenario (CScenarioName : string) : TStringList;
var
  analysisfromComparsionScenarioNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
  comparisonScenarioID : integer;
begin
  analysisfromcomparsionScenarioNames := TStringList.Create;
//  queryStr := 'SELECT MeterName FROM Meters WHERE (MeterID = ' +
//    inttostr(flowMeterID) + ')';
 comparisonScenarioID := GetComparisonScenarioIDForName(cScenarioName);
  queryStr := 'SELECT AnalysisName FROM ComparisonScenarioDetails WHERE (ComparisonScenarioID = ' +
      inttostr(comparisonScenarioID) + ') ORDER BY AnalysisName;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    analysisfromComparsionScenarioNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetAnalysisfromComparisonScenario := analysisfromComparsionScenarioNames;
end;



function TDataModule1.GetCOptionfromComparisonScenario (CScenarioName : string) : integer;
var
  comparisonOption: integer;
  queryStr: string;
  recSet: _RecordSet;
  comparisonScenarioID : integer;
begin
  comparisonScenarioID := GetComparisonScenarioIDForName(cScenarioName);
  queryStr := 'SELECT ComparisonOption FROM ComparisonScenarios WHERE (ComparisonScenarioID = ' +
      inttostr(comparisonScenarioID) + ')';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    comparisonOption := (recSet.Fields.Item[0].Value);
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetCOptionfromComparisonScenario := comparisonOption;
end;


function TDataModule1.GetScenarioNames4RTKPatternName(
  rtkPatternName: string): TStringList;
var
  scenarioNames: TStringList;
  raingaugeIDStr, queryStr: string;
  recSet: _RecordSet;
begin
  scenarioNames := TStringList.Create;
  queryStr := 'SELECT DISTINCT S.ScenarioName FROM ' +
              ' (RTKLinks L INNER JOIN RTKPatterns P ON L.RTKPatternID = P.RTKPatternID) ' +
              ' INNER JOIN Scenarios S on L.ScenarioID = S.ScenarioID ' +
              ' WHERE P.RTKPatternName = ''' + rtkPatternName + ''';';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    scenarioNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := scenarioNames;
end;

function TDataModule1.GetRTKPatternforName_(
  RTKPatternName: string): TStringList;
  //return empty list if RTKPatternName not found
var
  rtkPatterns: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  rtkPatterns := TStringList.Create;
  queryStr := 'SELECT R1, T1, K1, R2, T2, K2, R3, T3, K3, AI, AM, AR, ' +
    ' Mon, Description FROM RTKPatterns ' +
    ' where RTKPatternName = "' + RTKPatternName + '";';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    rtkPatterns.Add(vartostr(recSet.Fields.Item[0].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[1].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[2].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[3].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[4].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[5].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[6].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[7].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[8].Value));
    if VarIsNull(recSet.Fields.Item[9].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[9].Value));
    if VarIsNull(recSet.Fields.Item[10].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[10].Value));
    if VarIsNull(recSet.Fields.Item[11].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[11].Value));
    if VarIsNull(recSet.Fields.Item[12].Value) then
      rtkPatterns.Add('0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[12].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[13].Value));
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := rtkPatterns;
end;

function TDataModule1.GetRTKPatternforNameAndMonth(
  RTKPatternName: string; iMon: Integer): TStringList;
  //return empty list if RTKPatternName not found
var
  rtkPatterns: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  rtkPatterns := TStringList.Create;
  queryStr := 'SELECT R1, T1, K1, R2, T2, K2, R3, T3, K3, AI, AM, AR, ' +
    ' AI2, AM2, AR2, AI3, AM3, AR3, ' +
    ' Mon, Description FROM RTKPatterns ' +
    ' where RTKPatternName = "' + RTKPatternName + '" ' +
    ' and Mon = ' + inttostr(iMon) + ';';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    rtkPatterns.Add(vartostr(recSet.Fields.Item[0].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[1].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[2].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[3].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[4].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[5].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[6].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[7].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[8].Value));
    if VarIsNull(recSet.Fields.Item[9].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[9].Value));
    if VarIsNull(recSet.Fields.Item[10].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[10].Value));
    if VarIsNull(recSet.Fields.Item[11].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[11].Value));

    if VarIsNull(recSet.Fields.Item[12].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[12].Value));
    if VarIsNull(recSet.Fields.Item[13].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[13].Value));
    if VarIsNull(recSet.Fields.Item[14].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[14].Value));

    if VarIsNull(recSet.Fields.Item[15].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[15].Value));
    if VarIsNull(recSet.Fields.Item[16].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[16].Value));
    if VarIsNull(recSet.Fields.Item[17].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[17].Value));

    if VarIsNull(recSet.Fields.Item[18].Value) then
      rtkPatterns.Add('0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[18].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[19].Value));
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := rtkPatterns;
end;
function TDataModule1.GetRTKPatternforNameAndMonthAdjustedbyFactor(
  RTKPatternName: string; iMon: Integer; factor: double): TStringList;
  //return empty list if RTKPatternName not found
var
  rtkPatterns: TStringList;
  queryStr: string;
  recSet: _RecordSet;
  sf: string;
begin
  sf := floattostr(factor);
  rtkPatterns := TStringList.Create;
  queryStr := 'SELECT ' + sf + '*R1, T1, K1, ' +
    sf + '*R2, T2, K2, ' +
    sf + '*R3, T3, K3, AI, AM, AR, ' +
    ' AI2, AM2, AR2, AI3, AM3, AR3, ' +
    ' Mon, Description FROM RTKPatterns ' +
    ' where RTKPatternName = "' + RTKPatternName + '" ' +
    ' and Mon = ' + inttostr(iMon) + ';';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    rtkPatterns.Add(vartostr(recSet.Fields.Item[0].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[1].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[2].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[3].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[4].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[5].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[6].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[7].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[8].Value));
    if VarIsNull(recSet.Fields.Item[9].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[9].Value));
    if VarIsNull(recSet.Fields.Item[10].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[10].Value));
    if VarIsNull(recSet.Fields.Item[11].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[11].Value));

    if VarIsNull(recSet.Fields.Item[12].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[12].Value));
    if VarIsNull(recSet.Fields.Item[13].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[13].Value));
    if VarIsNull(recSet.Fields.Item[14].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[14].Value));

    if VarIsNull(recSet.Fields.Item[15].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[15].Value));
    if VarIsNull(recSet.Fields.Item[16].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[16].Value));
    if VarIsNull(recSet.Fields.Item[17].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[17].Value));

    if VarIsNull(recSet.Fields.Item[18].Value) then
      rtkPatterns.Add('0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[18].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[19].Value));
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := rtkPatterns;
end;

function TDataModule1.GetRTKPatternforNameAdjustedbyFactor_(
  RTKPatternName: string; factor: double): TStringList;
  //return empty list if RTKPatternName not found
var
  rtkPatterns: TStringList;
  queryStr: string;
  recSet: _RecordSet;
  sf: string;
begin
  sf := floattostr(factor);
  rtkPatterns := TStringList.Create;
  queryStr := 'SELECT ' + sf + '*R1, T1, K1, ' +
    sf + '*R2, T2, K2, ' +
    sf + '*R3, T3, K3, AI, AM, AR, ' +
    ' Mon, Description FROM RTKPatterns ' +
    ' where RTKPatternName = "' + RTKPatternName + '";';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    rtkPatterns.Add(vartostr(recSet.Fields.Item[0].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[1].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[2].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[3].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[4].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[5].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[6].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[7].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[8].Value));
    if VarIsNull(recSet.Fields.Item[9].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[9].Value));
    if VarIsNull(recSet.Fields.Item[10].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[10].Value));
    if VarIsNull(recSet.Fields.Item[11].Value) then
      rtkPatterns.Add('0.0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[11].Value));
    if VarIsNull(recSet.Fields.Item[12].Value) then
      rtkPatterns.Add('0')
    else
      rtkPatterns.Add(vartostr(recSet.Fields.Item[12].Value));
    rtkPatterns.Add(vartostr(recSet.Fields.Item[13].Value));
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := rtkPatterns;
end;

function TDataModule1.GetRTKPatternID4Event(iEventID: integer): integer;
//return -1 for RTKPattenID not found
var
  iRTKPatternID: integer;
  queryStr: string;
  recSet: _RecordSet;
begin
  iRTKPatternID := -1;
  queryStr := 'SELECT RTKPatternID FROM Events ' +
              ' Where EventID = ' + inttostr(iEventID) + ';';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if (recSet.EOF) then begin
      iRTKPatternID := -1; //not found
    end else begin
      recSet.MoveFirst;
      iRTKPatternID := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iRTKPatternID;
end;

function TDataModule1.GetRTKPatternNameForID(iRTKPatternID: integer): string;
//return '' for RTKPattenID not found
var
  sRTKPatternName: string;
  queryStr: string;
  recSet: _RecordSet;
begin
  sRTKPatternName := '';
  queryStr := 'SELECT RTKPatternName FROM RTKPatterns ' +
              ' Where RTKPatternID = ' + inttostr(iRTKPatternID) + ';';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if (recSet.EOF) then begin
      sRTKPatternName := ''; //not found
    end else begin
      recSet.MoveFirst;
      sRTKPatternName := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := sRTKPatternName;
end;

function TDataModule1.GetRTKPatternIDforName_(RTKPatternName: string): integer;
//return -1 for RTKPatternName not found
var
  iRTKPatternID: integer;
  queryStr, sName: string;
  recSet: _RecordSet;
begin
  //rm 2009-06-10 - remove quotes
  sName := StringReplace(RTKPatternName, '"', '', [rfReplaceAll, rfIgnoreCase]);
  iRTKPatternID := -1;
  queryStr := 'SELECT RTKPatternID FROM RTKPatterns ' +
              ' Where RTKPatternName = "' + sName + '";';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if (recSet.EOF) then begin
      iRTKPatternID := -1; //not found
    end else begin
      recSet.MoveFirst;
      iRTKPatternID := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iRTKPatternID;
end;

function TDataModule1.GetRTKPatternIDforNameAndMonth(RTKPatternName: string; iMon: Integer): integer;
//return -1 for RTKPatternName not found
var
  iRTKPatternID: integer;
  queryStr, sName: string;
  recSet: _RecordSet;
begin
  //rm 2009-06-10 - remove quotes
  sName := StringReplace(RTKPatternName, '"', '', [rfReplaceAll, rfIgnoreCase]);
  iRTKPatternID := -1;
  queryStr := 'SELECT RTKPatternID FROM RTKPatterns ' +
              ' Where RTKPatternName = "' + sName + '" ' +
              ' And Mon = ' + inttostr(iMon) + ';';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if (recSet.EOF) then begin
      iRTKPatternID := -1; //not found
    end else begin
      recSet.MoveFirst;
      iRTKPatternID := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  result := iRTKPatternID;
end;

function TDataModule1.GetRTKPatternIDForRDIIAreaIDAndScenarioID(iRDIIAreaID,
  iScenarioID: integer): integer;
//return -1 for RTKPattenName not found
var
  iRTKPatternID: integer;
  queryStr: string;
  recSet: _RecordSet;
begin
  iRTKPatternID := -1;
  queryStr := 'SELECT RTKPatternID FROM RTKLinks ' +
              ' Where (RDIIAreaID = ' + inttostr(iRDIIAreaID) + ') ' +
              ' AND (ScenarioID = ' + inttostr(iScenarioID) + ');';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if (recSet.EOF) then begin
      iRTKPatternID := -1; //not found
    end else begin
      recSet.MoveFirst;
      iRTKPatternID := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iRTKPatternID;
end;

function TDataModule1.GetRTKPatternIDForSewerShedIDAndScenarioID(iSewerShedID,
  iScenarioID: integer): integer;
//return -1 for RTKPattenName not found
var
  iRTKPatternID: integer;
  queryStr: string;
  recSet: _RecordSet;
begin
  iRTKPatternID := -1;
  queryStr := 'SELECT RTKPatternID FROM RTKLinks ' +
              ' Where (SewerShedID = ' + inttostr(iSewerShedID) + ') ' +
              ' AND (ScenarioID = ' + inttostr(iScenarioID) + ');';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if (recSet.EOF) then begin
      iRTKPatternID := -1; //not found
    end else begin
      recSet.MoveFirst;
      iRTKPatternID := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iRTKPatternID;
end;

function TDataModule1.GetRTKPatternNames(): TStringList;
var
  rtkPatternNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  rtkPatternNames := TStringList.Create;
  queryStr := 'SELECT RTKPatternName, R1, T1, K1, R2, T2, K2, R3, T3, K3 FROM RTKPatterns;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    rtkPatternNames.Add(vartostr(recSet.Fields.Item[0].Value) + ':  ' +
    vartostr(recSet.Fields.Item[1].Value) + ', ' +
    vartostr(recSet.Fields.Item[2].Value) + ', ' +
    vartostr(recSet.Fields.Item[3].Value) + ';  ' +
    vartostr(recSet.Fields.Item[4].Value) + ', ' +
    vartostr(recSet.Fields.Item[5].Value) + ', ' +
    vartostr(recSet.Fields.Item[6].Value) + ';  ' +
    vartostr(recSet.Fields.Item[7].Value) + ', ' +
    vartostr(recSet.Fields.Item[8].Value) + ', ' +
    vartostr(recSet.Fields.Item[9].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetRTKPatternNames := rtkPatternNames;
end;
function TDataModule1.GetRTKPatternNames_with_IA(): TStringList;
var
  rtkPatternNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  rtkPatternNames := TStringList.Create;
  queryStr := 'SELECT RTKPatternName, R1, T1, K1, R2, T2, K2, R3, T3, K3, AM, AR, AI, AM2, AR2, AI2, AM3, AR3, AI3, MON FROM RTKPatterns;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    rtkPatternNames.Add(vartostr(recSet.Fields.Item[0].Value) + ':  ' +
    vartostr(recSet.Fields.Item[1].Value) + ', ' +
    vartostr(recSet.Fields.Item[2].Value) + ', ' +
    vartostr(recSet.Fields.Item[3].Value) + ';  ' +
    vartostr(recSet.Fields.Item[4].Value) + ', ' +
    vartostr(recSet.Fields.Item[5].Value) + ', ' +
    vartostr(recSet.Fields.Item[6].Value) + ';  ' +
    vartostr(recSet.Fields.Item[7].Value) + ', ' +
    vartostr(recSet.Fields.Item[8].Value) + ', ' +
    vartostr(recSet.Fields.Item[9].Value) + ', ' +
    vartostr(recSet.Fields.Item[10].Value) + ', ' +
    vartostr(recSet.Fields.Item[11].Value) + ', ' +
    vartostr(recSet.Fields.Item[12].Value) + ', ' +
    vartostr(recSet.Fields.Item[13].Value) + ', ' +
    vartostr(recSet.Fields.Item[14].Value) + ', ' +
    vartostr(recSet.Fields.Item[14].Value) + ', ' +
    vartostr(recSet.Fields.Item[16].Value) + ', ' +
    vartostr(recSet.Fields.Item[17].Value) + ', ' +
    vartostr(recSet.Fields.Item[18].Value) + ', ' +
    vartostr(recSet.Fields.Item[19].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := rtkPatternNames;
end;

function TDataModule1.GetRTKPatternNames4Analyses: TStringList;
var
  rtkPatternNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  rtkPatternNames := TStringList.Create;
  queryStr := 'SELECT distinct a.RTKPatternName, a.R1, a.T1, a.K1, a.R2, a.T2, a.K2, ' +
  ' a.R3, a.T3, a.K3 ' +
  ' FROM RTKPatterns as a INNER JOIN Events as b ' +
  ' on a.RTKPAtternID = b.RTKPAtternID ' +
  ' WHERE b.AnalysisID > 0;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    rtkPatternNames.Add(vartostr(recSet.Fields.Item[0].Value) + ':  ' +
    vartostr(recSet.Fields.Item[1].Value) + ', ' +
    vartostr(recSet.Fields.Item[2].Value) + ', ' +
    vartostr(recSet.Fields.Item[3].Value) + ';  ' +
    vartostr(recSet.Fields.Item[4].Value) + ', ' +
    vartostr(recSet.Fields.Item[5].Value) + ', ' +
    vartostr(recSet.Fields.Item[6].Value) + ';  ' +
    vartostr(recSet.Fields.Item[7].Value) + ', ' +
    vartostr(recSet.Fields.Item[8].Value) + ', ' +
    vartostr(recSet.Fields.Item[9].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := rtkPatternNames;
end;

function TDataModule1.GetRTKPatternNames4SewerShed(sSewerShedName: string): TStringList;
var
  rtkPatternNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
  iSewerShedID, iMeterID, iRainGaugeID: integer;
begin
//return the list of RTKPatternnames that were generated with the same Meter and Raingauge
//as the selected sewershed
  iSewerShedID := GetSewerShedIDforName(sSewerShedName);
  iMeterID := GetMeterIDforSewershedID(iSewerShedID);
  iRainGaugeID := GetRainGaugeIDforSewershedID(iSewerShedID);
  rtkPatternNames := TStringList.Create;
  queryStr := 'SELECT distinct a.RTKPatternName, a.R1, a.T1, a.K1, a.R2, a.T2, a.K2, ' +
  ' a.R3, a.T3, a.K3, c.MeterID, c.RaingaugeID ' +
  ' FROM (RTKPatterns as a INNER JOIN Events as b ' +
  ' on a.RTKPAtternID = b.RTKPAtternID) ' +
  ' inner join Analyses as c on b.AnalysisID = c.AnalysisID ' +
  ' WHERE (b.AnalysisID > 0) and ' +
  ' (c.Meterid = ' + inttostr(iMeterID) + ') and ' +
  ' (c.RaingaugeID = ' + inttostr(iRaingaugeID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    rtkPatternNames.Add(vartostr(recSet.Fields.Item[0].Value) + ':  ' +
    vartostr(recSet.Fields.Item[1].Value) + ', ' +
    vartostr(recSet.Fields.Item[2].Value) + ', ' +
    vartostr(recSet.Fields.Item[3].Value) + ';  ' +
    vartostr(recSet.Fields.Item[4].Value) + ', ' +
    vartostr(recSet.Fields.Item[5].Value) + ', ' +
    vartostr(recSet.Fields.Item[6].Value) + ';  ' +
    vartostr(recSet.Fields.Item[7].Value) + ', ' +
    vartostr(recSet.Fields.Item[8].Value) + ', ' +
    vartostr(recSet.Fields.Item[9].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := rtkPatternNames;
end;

function TDataModule1.GetRTKPatternNamesFromEvents: TStringList;
var
  rtkPatternNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
  theDate: TDateTime;
  theDateString: string;
begin
  rtkPatternNames := TStringList.Create;
  queryStr := 'SELECT a.AnalysisName, e.StartDateTime, ' +
              ' p.R1, p.T1, p.K1, p.R2, p.T2, p.K2, p.R3, p.T3, p.K3 FROM ' +
              ' (Analyses as a inner join ' +
              ' (Events as e inner join RTKLinks as r on e.EventID = r.EventID) ' +
              ' on a.AnalysisID = e.AnalysisID) Left Join RTKPatterns as p ' +
              ' on e.RTKPatternID = p.RTKPatternID';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    theDate := recSet.Fields.Item[1].Value;
    theDateString := FormatDateTime('M/d/yyy H',theDate);
    rtkPatternNames.Add(vartostr(recSet.Fields.Item[0].Value) + ' ' +
    theDateString + ':  ' +
    vartostr(recSet.Fields.Item[2].Value) + ', ' +
    vartostr(recSet.Fields.Item[3].Value) + ', ' +
    vartostr(recSet.Fields.Item[4].Value) + ';  ' +
    vartostr(recSet.Fields.Item[5].Value) + ', ' +
    vartostr(recSet.Fields.Item[6].Value) + ', ' +
    vartostr(recSet.Fields.Item[7].Value) + ';  ' +
    vartostr(recSet.Fields.Item[8].Value) + ', ' +
    vartostr(recSet.Fields.Item[9].Value) + ', ' +
    vartostr(recSet.Fields.Item[10].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := rtkPatternNames;
end;

function TDataModule1.GetRTKPatternNumberForResponseName(sName: string): integer;
var iResult: integer;
begin
  iResult := -1;
  sName := AnsiUpperCase(sName);
  if (sName = 'SHORT') then
    iResult := 1
  else if (sName = 'MEDIUM') then
    iResult := 2
  else if (sName = 'LONG') then
    iResult := 3;
  result := iResult;
end;

function TDataModule1.GetRaingaugeNames(): TStringList;
var
  raingaugeNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  raingaugeNames := TStringList.Create;
  queryStr := 'SELECT RaingaugeName FROM Raingauges;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    raingaugeNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetRaingaugeNames := raingaugeNames;
end;

function TDataModule1.GetAnalysisNameForID(AnalysisID: integer): string;
var
  queryStr: string;
  recSet: _RecordSet;
  strResult : string;
begin
  strResult := '';
  queryStr := 'SELECT AnalysisName FROM Analyses ' +
    ' WHERE AnalysisID = ' + inttostr(AnalysisID) + ';';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    strResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := strResult;
end;

function TDataModule1.GetAnalysisNames(): TStringList;
var
  analysisNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  analysisNames := TStringList.Create;
  queryStr := 'SELECT AnalysisName FROM Analyses;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //rm 2007-10-23
  if not recSet.EOF then begin
    if (not recSet.EOF) then recSet.MoveFirst;
    while (not recSet.EOF) do begin
      analysisNames.Add(vartostr(recSet.Fields.Item[0].Value));
      recSet.MoveNext;
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetAnalysisNames := analysisNames;
end;

function TDataModule1.GetAnalysisNamesForComparisonScenario(
  caID: integer): TStringList;
//rm 2012-04-16
var
  theStringList: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  theStringList := TStringList.Create();
  queryStr := 'SELECT AnalysisName FROM ComparisonScenarioDetails where ComparisonScenarioID = ' + IntToStr(caID) + ';';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    if (not recSet.EOF) then recSet.MoveFirst;
    while (not recSet.EOF) do begin
      theStringList.Add(vartostr(recSet.Fields.Item[0].Value));
      recSet.MoveNext;
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  result := theStringList;
end;

function TDataModule1.GetAnalysisNamesforRainGaugeID(
  iRainGaugeID: integer): TStringList;
var
  analysisNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  analysisNames := TStringList.Create;
  queryStr := 'SELECT AnalysisName FROM Analyses where RaingaugeID = ' +
   inttostr(iRainGaugeID) + ';';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    analysisNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetAnalysisNamesforRainGaugeID := analysisNames;
end;

function TDataModule1.GetAnalysisName4CAID(caID, idx: integer): string;
var
  queryStr: string;
  recSet: _RecordSet;
  strResult : string;
  s: string;
begin
  strResult := '';
  s := IntToStr(idx);
  queryStr := 'SELECT Analysis' + s + ' FROM ConditionAssessments ' +
    ' WHERE CAID = ' + inttostr(caID) + ';';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    if (varisnull(recSet.Fields.Item[0].Value)) then
      strResult := ''
    else
      strResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := strResult;
end;


function TDataModule1.GetAnalysisName4RTKPatternName(
  rtkPatternName: string): string;
var
  analysisname, queryStr: string;
  recSet: _RecordSet;
begin
  analysisName := '';
  queryStr := 'SELECT A.AnalysisName FROM ' +
              ' (Events E INNER JOIN RTKPatterns P ON E.RTKPatternID = P.RTKPatternID) ' +
              ' INNER JOIN Analyses A on E.AnalysisID = A.AnalysisID ' +
              ' WHERE P.RTKPatternName = ''' + rtkPatternName + ''';';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    analysisName := vartostr(recSet.Fields.Item[0].Value);
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := analysisName;
end;




function TDataModule1.GetSewershedNames(): TStringList;
var
  sewershedNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
  //id: integer;
  //obj: TObject;
begin
  sewershedNames := TStringList.Create;
  queryStr := 'SELECT SewerShedID, SewershedName FROM Sewersheds order by SewerShedID;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    sewershedNames.Add(vartostr(recSet.Fields.Item[1].Value));
//    id := recSet.Fields.Item[0].Value;
//    obj := TObject(id);
//    sewershedNames.AddObject(vartostr(recSet.Fields.Item[1].Value),obj);
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetSewershedNames := sewershedNames;
end;
{
function TDataModule1.GetSewershedIDs(): TStringList;
var
  sewershedNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  sewershedNames := TStringList.Create;
  queryStr := 'SELECT SewershedID FROM Sewersheds order by SewerShedID;';
  recSet := CoRecordSet.Create;
  if not (recSet = nil) then begin

  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    sewershedNames.AddObject .Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  recSet.Close;
  end;
  GetSewershedNames := sewershedNames;
end;
}
function TDataModule1.GetRDIIAreaNames(): TStringList;
var
  RDIIAreaNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  RDIIAreaNames := TStringList.Create;
  queryStr := 'SELECT RDIIAreaName FROM RDIIAreas;';
  recSet := CoRecordSet.Create;
  if not (recSet = nil) then begin
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    RDIIAreaNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  end;
  GetRDIIAreaNames := RDIIAreaNames;
end;
function TDataModule1.GetRDIIAreaNamesforSewershedID(iSewerShedID:integer): TStringList;
var
  RDIIAreaNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  RDIIAreaNames := TStringList.Create;
  queryStr := 'SELECT RDIIAreaName FROM RDIIAreas where SewerShedID = ' + inttostr(iSewerShedID);
  recSet := CoRecordSet.Create;
  if not (recSet = nil) then begin
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    RDIIAreaNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  end;
  GetRDIIAreaNamesforSewershedID := RDIIAreaNames;
end;
function TDataModule1.GetRDIIAreaNamesforSewershedIDandScenarioID(iSewerShedID,iScenarioID: integer): TStringList;
var
  RDIIAreaNames: TStringList;
  queryStr: string;
  recSet: _RecordSet;
begin
  RDIIAreaNames := TStringList.Create;
  queryStr := 'SELECT a.RDIIAreaName FROM RDIIAreas as a ' +
  ' Inner Join RTKLinks as b on a.RDIIAreaID = b.RDIIAreaID ' +
  ' where a.SewerShedID = ' + inttostr(iSewerShedID) +
  ' AND b.ScenarioID = ' + inttostr(iScenarioID) + ';';
  recSet := CoRecordSet.Create;
  if not (recSet = nil) then begin
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    RDIIAreaNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  end;
  GetRDIIAreaNamesforSewershedIDandScenarioID := RDIIAreaNames;
end;

function TDataModule1.GetRDIIAreasAreaForSewerShedID(
  iSewerShedID: integer): double;
var dResult: double;
  queryStr: string;
  recSet: _recordSet;
begin
  dResult := 0.0;
  queryStr := 'SELECT sum(Area) FROM RDIIAreas ' +
    ' WHERE (SewerShedID = ' + inttostr(iSewerShedID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    if varisnull(recSet.Fields.Item[0].Value) then
      dResult := 0
    else
      dResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := dResult;
end;

{*
function TDataModule1.GetSewerShedUnitID(sewershedUnitLabel: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  queryStr := 'SELECT AreaUnitID FROM AreaUnits WHERE (ShortLabel = "' + sewershedUnitLabel + '");';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
  GetSewerShedUnitID := recSet.Fields.Item[0].Value;
  recSet.Close;
end;
*}

function TDataModule1.GetRainUnitLabelForRaingauge(raingaugeName: string): string;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  queryStr := 'SELECT Label FROM Raingauges, RainUnits ' +
              'WHERE ((RaingaugeName = "' + raingaugeName + '") AND ' +
              '(Raingauges.RainUnitID = RainUnits.RainUnitID));';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not (recSet.EOF) then begin
      recSet.MoveFirst;
      GetRainUnitLabelForRaingauge := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetRainUnitShortLabelForRaingauge(raingaugeName: string): string;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  queryStr := 'SELECT ShortLabel FROM Raingauges, RainUnits ' +
              'WHERE ((RaingaugeName = "' + raingaugeName + '") AND ' +
              '(Raingauges.RainUnitID = RainUnits.RainUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then begin
    Result := '';
  end else begin
    recSet.MoveFirst;
    GetRainUnitShortLabelForRaingauge := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;


function TDataModule1.GetRainfallDecimalPlacesForRaingauge(raingaugeName: string): integer;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  queryStr := 'SELECT DecimalPlaces FROM Raingauges, RainUnits ' +
              'WHERE ((RaingaugeName = "' + raingaugeName + '") AND ' +
              '(Raingauges.RainUnitID = RainUnits.RainUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then begin
    Result := 2;
  end else begin
    recSet.MoveFirst;
    GetRainfallDecimalPlacesForRaingauge := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;


function TDataModule1.GetRainUnitLabelForRainConverter(rainConverterName: string): string;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  GetRainUnitLabelForRainConverter := '';
  queryStr := 'SELECT Label FROM RainConverters, RainUnits ' +
              'WHERE ((RainConverterName = "' + rainConverterName + '") AND ' +
              '(RainConverters.RainUnitID = RainUnits.RainUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetRainUnitLabelForRainConverter := ''
  else begin
    recSet.MoveFirst;
    GetRainUnitLabelForRainConverter := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetConversionFactorToUnitForRaingauge(raingaugeID: integer; unitLabel: string): real;
var
  raingaugeRainUnitID, destRainUnitID: integer;
  raingaugeConversionFactor, destConversionFactor: real;
  queryStr: string;
  recSet1, recSet2: _RecordSet;
  dResult: double;
begin
//rm 2009-06-11 - some changes here
  dResult := 1.0;
  raingaugeConversionFactor := 1.0;
  destConversionFactor := 1.0;
  raingaugeRainUnitID := GetRainUnitIDForRaingauge(raingaugeID);
  destRainUnitID := GetRainUnitID(unitLabel);
  if (raingaugeRainUnitID <> destRainUnitID) then begin
    queryStr := 'SELECT ConversionFactor FROM RainUnits WHERE ' +
                '(RainUnitID = ' + inttostr(raingaugeRainUnitID) + ');';
    recSet1 := CoRecordSet.Create;
    try
      recSet1.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      raingaugeConversionFactor := recSet1.Fields.Item[0].Value;
    finally
      if (recSet1.State <> adStateClosed) then recSet1.Close;
    end;

    queryStr := 'SELECT ConversionFactor FROM RainUnits WHERE ' +
                '(RainUnitID = ' + inttostr(destRainUnitID) + ');';
    recSet2 := CoRecordSet.Create;
    try
      recSet2.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      if not recSet2.EOF then begin
        recSet2.MoveFirst;
        destConversionFactor := recSet2.Fields.Item[0].Value;
      end else begin
        destConversionFactor := 1.0;
      end;
    finally
      if (recSet2.State <> adStateClosed) then recSet2.Close;
    end;
    dResult :=  raingaugeConversionFactor /destConversionFactor;
  end;
  //rm 2009-06-11
  //showmessage('Unit ID / Dest Unit ID Factor = ' +  inttostr(raingaugeRainUnitID) + '/' +
  //  inttostr(destRainUnitID) + ' = ' + floattostr(dResult));
  GetConversionFactorToUnitForRaingauge := dResult;
end;

procedure TDataModule1.UpdateMinMaxRainTimes(raingaugeID: integer);
var
  queryStr: string;
  recSet: _RecordSet;
  minDateTime, maxDateTime: TDateTime;
begin
  queryStr := 'SELECT MIN(DateTime), MAX(DateTime) FROM Rainfall WHERE ' +
              '(RainGaugeID = ' + inttostr(raingaugeID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
  minDateTime := recSet.Fields.Item[0].Value;
  maxDateTime := recSet.Fields.Item[1].Value;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;

  queryStr := 'SELECT StartDateTime, EndDateTime FROM Raingauges WHERE ' +
              '(RainGaugeID = ' + inttostr(raingaugeID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
  recSet.Fields.Item[0].Value := minDateTime;
  recSet.Fields.Item[1].Value := maxDateTime;
  recSet.UpdateBatch(1);
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;


procedure TDataModule1.UpdateRainGaugeIDForRDIIAreasInSewerShed(
  sSewerShedName: string);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
//update RDIIAreas as a INNER JOIN Sewersheds as b
//ON a.SewershedID = b.SewershedID
//set a.RainGaugeID = b.RainGaugeID
//Where b.SewerShedName = 'North_Basin'

  sqlStr := 'update RDIIAreas as a INNER JOIN Sewersheds as b ' +
            ' ON a.SewershedID = b.SewershedID ' +
            ' set a.RainGaugeID = b.RainGaugeID ' +
            ' Where b.SewerShedName = "' + sSewerShedName + '";';

  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

function TDataModule1.AnyRTKParametersAreBlank(RTKPatternList: TStringList): boolean;
var
  boResult: boolean;
  i: integer;
begin
  boResult := false;
  //OK if description is blank
//  for i := 0 to RTKPatternList.Count - 1 do
  for i := 0 to 19 do
    if (Length(RTKPatternList[i]) < 1) then
      boResult := true;
  result := boResult;
end;

procedure TDataModule1.UpdateRTKPattern(RTKPatternList: TStringList);
var
  sqlStr: string;
  //recSet: _RecordSet;
  recordsAffected: OleVariant;
begin
  if AnyRTKParametersAreBlank(RTKPatternList) then begin
     //do nothing
  end else begin

//rm 2010-09-29 - added new initial abstraction parameter
    sqlStr := 'Update RTKPatterns set ' +
            ' RTKPatternName = "' + RTKPatternList[0] + '", ' +
            ' R1 = ' + RTKPatternList[1] + ', ' +
            ' T1 = ' + RTKPatternList[2] + ', ' +
            ' K1 = ' + RTKPatternList[3] + ', ' +
            ' R2 = ' + RTKPatternList[4] + ', ' +
            ' T2 = ' + RTKPatternList[5] + ', ' +
            ' K2 = ' + RTKPatternList[6] + ', ' +
            ' R3 = ' + RTKPatternList[7] + ', ' +
            ' T3 = ' + RTKPatternList[8] + ', ' +
            ' K3 = ' + RTKPatternList[9] + ', ' +
            ' AI = ' + RTKPatternList[10] + ', ' +
            ' AM = ' + RTKPatternList[11] + ', ' +
            ' AR = ' + RTKPatternList[12] + ', ' +
            ' AI2 = ' + RTKPatternList[13] + ', ' +
            ' AM2 = ' + RTKPatternList[14] + ', ' +
            ' AR2 = ' + RTKPatternList[15] + ', ' +
            ' AI3 = ' + RTKPatternList[16] + ', ' +
            ' AM3 = ' + RTKPatternList[17] + ', ' +
            ' AR3 = ' + RTKPatternList[18] + ', ' +
            ' Mon = ' + RTKPAtternList[19] + ', ' +
            ' Description = "' + RTKPatternList[20] + '" ' +
            ' Where RTKPatternID = ' + RTKPatternList[21] + ';';
//            ' AND Mon = ' + RTKPAtternList[19] + ';';
//MessageDlg(sqlStr, mtInformation, [mbok], 0);
    try
      frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
    finally

    end;
  end;
end;

//rm 2009-06-08 - recast as function
//procedure TDataModule1.UpdateRTKPattern4Event(
//  sPatternName: string;
//  var event:TStormEvent);
function TDataModule1.UpdateRTKPattern4Event(
  sPatternName: string;
  var event:TStormEvent): boolean;
var
  queryStr, sqlStr{, PatternName}: string;
  recSet1, recSet2: _recordSet;
  recordsAffected: OleVariant;
  iRTKPatternID: integer;
  bo_Result: boolean;
begin
//see if this one is already logged in RTKPAtterns:
//if event.RTKPatternID > 0 then begin
  bo_Result := false;
  queryStr := 'SELECT RTKPatternID FROM RTKPatterns ' +
              ' WHERE ' +
              ' (RTKPAtternID = ' + inttostr(event.RTKPatternID) + ');';
  recSet1 := CoRecordSet.Create;
  try
  recSet1.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
//  recSet.MoveFirst;
  if recSet1.eof then begin
//rm 2010-09-29    iRTKPatternID := GetRTKPatternIDforName(sPatternName);
    iRTKPatternID := GetRTKPatternIDforNameAndMonth(sPatternName, 0);
    if iRTKPatternID > -1 then begin
      //there is already a pattern with this name!
      MessageDlg('An RTK Pattern named "' + sPAtternName +
      '" already exists.',mtError,[mbok],0);
      //Result := bo_Result;
      //recSet1.Close;
    end else begin

      //create a new record in RTKPAtterns for this event
      //PatternName := 'Analysis_' + inttostr(iAnalysisID) +
      //                '_Event_' + inttostr(event.EventID);
      sqlStr := 'INSERT INTO RTKPatterns (' +
              'RTKPatternName,'+
//              'r1,t1,k1,r2,t2,k2,r3,t3,k3,ai,am,ar,description)' +
              'r1,t1,k1,r2,t2,k2,r3,t3,k3,ai,am,ar,ai2,am2,ar2,ai3,am3,ar3,description)' +
              ' VALUES (' +
              '"' + sPatternName + '", ' +
              floattostr(event.R[0]) + ', ' +
              floattostr(event.T[0]) + ', ' +
              floattostr(event.K[0]) + ', ' +
              floattostr(event.R[1]) + ', ' +
              floattostr(event.T[1]) + ', ' +
              floattostr(event.K[1]) + ', ' +
              floattostr(event.R[2]) + ', ' +
              floattostr(event.T[2]) + ', ' +
              floattostr(event.K[2]) + ', ' +
//rm 2010-09-29              floattostr(event.AI) + ', ' +
//rm 2010-09-29              floattostr(event.AM) + ', ' +
//rm 2010-09-29              floattostr(event.AR) + ', ' +
              floattostr(event.AI[1]) + ', ' +
              floattostr(event.AM[1]) + ', ' +
              floattostr(event.AR[1]) + ', ' +
              floattostr(event.AI[2]) + ', ' +
              floattostr(event.AM[2]) + ', ' +
              floattostr(event.AR[2]) + ', ' +
              floattostr(event.AI[3]) + ', ' +
              floattostr(event.AM[3]) + ', ' +
              floattostr(event.AR[3]) + ', ' +
              '"' + Trim(event.RTKDesc) + '")';
      frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
      queryStr := 'SELECT RTKPatternID FROM RTKPatterns ' +
                ' WHERE ' +
                //' ((AnalysisID = ' + inttostr(iAnalysisID) + ') AND ' +
                //' (EventID=' + inttostr(event.EventID) + ') AND ' +
                ' (RTKPAtternName = "' + sPatternName + '");';
      recSet2 := CoRecordSet.Create;
      try
      recSet2.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      recSet2.MoveFirst;
      event.RTKPatternID := recSet2.Fields.Item[0].Value;
      finally
        if (recSet2.State <> adStateClosed) then recSet2.Close;
      end;
      bo_Result := true;
    end;
  end else begin
//rm 2010-09-29    iRTKPatternID := GetRTKPatternIDforName(sPatternName);
    iRTKPatternID := GetRTKPatternIDforNameAndMonth(sPatternName, 0);
    if (iRTKPatternID > -1) and (iRTKPatternID <> event.RTKPatternID) then begin
      //there is already a pattern with this name!
      MessageDlg('The RTK Pattern name "' + sPAtternName +
      '" is already in use. Please enter a unuque pattern name.',mtError,[mbok],0);
    end else begin
      //update the existing RTKs
      sqlStr := 'UPDATE RTKPatterns set ' +
              ' RTKPatternName = "' + sPatternName + '", ' +
              ' R1 = ' + floattostr(event.R[0]) + ', ' +
              ' T1 = ' + floattostr(event.T[0]) + ', ' +
              ' K1 = ' + floattostr(event.K[0]) + ', ' +
              ' R2 = ' + floattostr(event.R[1]) + ', ' +
              ' T2 = ' + floattostr(event.T[1]) + ', ' +
              ' K2 = ' + floattostr(event.K[1]) + ', ' +
              ' R3 = ' + floattostr(event.R[2]) + ', ' +
              ' T3 = ' + floattostr(event.T[2]) + ', ' +
              ' K3 = ' + floattostr(event.K[2]) + ', ' +
//rm 2010-09-29              ' AI = ' + floattostr(event.AI) + ', ' +
//rm 2010-09-29              ' AM = ' + floattostr(event.AM) + ', ' +
//rm 2010-09-29              ' AR = ' + floattostr(event.AR) + ', ' +
              ' AI = ' + floattostr(event.AI[1]) + ', ' +
              ' AM = ' + floattostr(event.AM[1]) + ', ' +
              ' AR = ' + floattostr(event.AR[1]) + ', ' +
              ' AI2 = ' + floattostr(event.AI[2]) + ', ' +
              ' AM2 = ' + floattostr(event.AM[2]) + ', ' +
              ' AR2 = ' + floattostr(event.AR[2]) + ', ' +
              ' AI3 = ' + floattostr(event.AI[3]) + ', ' +
              ' AM3 = ' + floattostr(event.AM[3]) + ', ' +
              ' AR3 = ' + floattostr(event.AR[3]) + ', ' +
              ' Description = "' + event.RTKDesc + '"' +
              ' WHERE (RTKPatternID = ' + inttostr(event.RTKPatternID) + ');';
      frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
      bo_Result := true;
    end;
  end;
  finally
    if (recSet1.State <> adStateClosed) then recSet1.Close;
  end;
  Result := bo_Result;
end;

function TDataModule1.upgradeDatabase(sDir: string; iFromVer: integer; iToVer: integer): boolean;
var boResult: boolean;
  sSQL: string;
  recordsAffected: OleVariant;
begin
  //rm - sDir is the location of the seed database in case we need to copy anything from it
  //rm 2009-10-26 - Version 1.0.1 accommodates areas in units other than acres
  //requiring a new field in the Meters table - "AreaUnitID"
  //MetaData.DatabaseVersion = 6 for Version 1.0.1 of the SSOAP Toolbox
  boResult := false;
  if (iFromVer <= 5) and (iToVer > 5) then begin  //upgrade from 5 to 6
    try
      sSQL :=
        'Alter table Meters ADD COLUMN AreaUnitID INTEGER;'; // DEFAULT 1';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      sSQL :=
        'Update Meters set AreaUnitID = 1';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      sSQL :=
        'Update Metadata set DatabaseVersion = 6';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      boResult := true;
    finally

    end;
    if not boResult then Result := boResult; //exit function
  end;
  //rm 2010-09-27 - Version 1.0.2 has initial abstraction terms for each of the 3 sets of unit hydrographs
  //MetaData.DatabaseVersion = 7 for Version 1.0.2f of the SSOAP Toolbox
  if (iFromVer <= 6) and (iToVer > 6) then begin  //upgrade from 6 to 7
    boResult := false;
    try
      //remove the unique constraint on RTKPatternName
      sSQL :=
        'Alter Table RTKPatterns Drop Constraint RTKPatternName;';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
    finally
    end;
    try
      sSQL :=
        'Alter Table RTKPatternConverters Add Column ' +
        ' AM2Column INTEGER, ' +
        ' AM2Width INTEGER, ' +
        ' AR2Column INTEGER, ' +
        ' AR2Width INTEGER, ' +
        ' AI2Column INTEGER, ' +
        ' AI2Width INTEGER;';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      sSQL :=
        'Alter Table RTKPatternConverters Add Column ' +
        ' AM3Column INTEGER, ' +
        ' AM3Width INTEGER, ' +
        ' AR3Column INTEGER, ' +
        ' AR3Width INTEGER, ' +
        ' AI3Column INTEGER, ' +
        ' AI3Width INTEGER;';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      sSQL :=
        'Update RTKPatternConverters set ' +
        ' AM2Column = 0, ' +
        ' AM2Width = 0, ' +
        ' AM3Column = 0, ' +
        ' AM3Width = 0, ' +
        ' AR2Column = 0, ' +
        ' AR2Width = 0, ' +
        ' AR3Column = 0, ' +
        ' AR3Width = 0, ' +
        ' AI2Column = 0, ' +
        ' AI2Width = 0, ' +
        ' AI3Column = 0, ' +
        ' AI3Width = 0;';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      sSQL :=
        'Alter Table RTKPatterns Add Column ' +
        ' AI2 DOUBLE, ' +
        ' AM2 DOUBLE, ' +
        ' AR2 DOUBLE, ' +
        ' AI3 DOUBLE, ' +
        ' AM3 DOUBLE, ' +
        ' AR3 DOUBLE;';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      sSQL :=
        'Update RTKPatterns set ' +
        ' AM2 = 0, ' +
        ' AM3 = 0, ' +
        ' AR2 = 0, ' +
        ' AR3 = 0, ' +
        ' AI2 = 0, ' +
        ' AI3 = 0;';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      sSQL :=
        'Update Metadata set DatabaseVersion = 7';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      boResult := true;
    finally
    end;
    try
      //add a duplicates-OK index on RTKPatternName
      sSQL :=
        'Create Index RTKPatternName on RTKPatterns (RTKPatternName);';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
    finally
    end;
    if not boResult then Result := boResult; //exit function
  end;
  //rm 2010-10-07 - Version 1.0.2 has initial abstraction terms for each of the 3 sets of unit hydrographs
  //MetaData.DatabaseVersion = 8 for Version 1.0.2g of the SSOAP Toolbox
  if (iFromVer <= 7) and (iToVer > 7) then begin  //upgrade from 7 to 8
    boResult := false;
    try
      sSQL :=
        'Alter Table Analyses Add Column ' +
        ' MaxDepressionStorage2 DOUBLE, ' +
        ' RateOfReduction2 DOUBLE, ' +
        ' InitialValue2 DOUBLE, ' +
        ' MaxDepressionStorage3 DOUBLE, ' +
        ' RateOfReduction3 DOUBLE, ' +
        ' InitialValue3 DOUBLE;';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      sSQL :=
        'Update Analyses set ' +
        ' MaxDepressionStorage2 = 0, ' +
        ' RateOfReduction2 = 0, ' +
        ' InitialValue2 = 0, ' +
        ' MaxDepressionStorage3 = 0, ' +
        ' RateOfReduction3 = 0, ' +
        ' InitialValue3 = 0;';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      sSQL :=
        'Update Metadata set DatabaseVersion = 8';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      boResult := true;
    finally
    end;
  end;
  //version 1.0.2j - now has a SewerLength in the Meters table
  if (iFromVer <= 8) and (iToVer > 8) then begin  //upgrade from 8 to 9
    boResult := false;
    try
      sSQL :=
        'Alter Table Meters Add Column ' +
        ' SewerLength DOUBLE;';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      sSQL :=
//rm 2010-10-20 - set default to 0        'Update Meters set SewerLength = 10000';
        'Update Meters set SewerLength = 0';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      sSQL :=
        'Update Metadata set DatabaseVersion = 9';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      boResult := true;
    finally
    end;
  end;
{FUTURE:
  if (iFromVer <= 6) and (iToVer > 6) then begin  //upgrade from 6 to 7
    boResult := false;
    try
      //example copy just structure of a new table from the seed db:
      sSQL :=
        'Select * into NewTableExample from [MS Access;Database=' + sDir +
          '\ssoaptoolbox.___].NewTableExample where 1=0';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      sSQL :=
        'Update Metadata set DatabaseVersion = 7';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      boResult := true;
    finally

    end;
    if not boResult then Result := boResult; //exit function
  end;
  if (iFromVer <= 7) and (iToVer > 7) then begin  //upgrade from 7 to 8
    boResult := false;
    try
      sSQL :=
        'Whatever needs updating';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      sSQL :=
        'Update Metadata set DatabaseVersion = 8';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      boResult := true;
    finally

    end;
    if not boResult then Result := boResult; //exit
  end;
  if (iFromVer <= 8) and (iToVer > 8) then begin  //upgrade from 8 to 9
    boResult := false;
    try
      sSQL :=
        'Whatever needs updating';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      sSQL :=
        'Update Metadata set DatabaseVersion = 9';
      frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
      boResult := true;
    finally

    end;
    if not boResult then Result := boResult; //exit function
  end;
}
  Result := boResult;
end;

procedure TDataModule1.ValidateRainfall4RainGauge(raingaugeID: integer; var iNumDupes: integer);
var
  queryStr: string;
  recSet: _RecordSet;
  iResult : integer;
begin
  iNumDupes := 0;
  queryStr := 'SELECT COUNT(-1) FROM (SELECT Distinct RainGaugeID, [DateTime] FROM Rainfall ' +
              ' WHERE (RainGaugeID = ' + inttoStr(raingaugeID) + ') ' +
              ' GROUP BY RaingaugeID, [DateTime] ' +
              ' HAVING COUNT(*) > 1);';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then begin
      recSet.MoveFirst;
      iNumDupes := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

procedure TDataModule1.RemoveWeekendDWFDays(flowMeterName: string);
var
  dwfdays: daysArray;
  meterID, index: integer;
  meterIDStr, sqlStr: string;
  recordsAffected: OleVariant;
begin
  meterID := GetMeterIDForName(flowMeterName);
  meterIDStr := inttostr(meterID);
  dwfdays := GetWeekendDWFDays(meterID);
  for index := 0 to length(dwfdays) - 1 do begin
    sqlStr := 'DELETE FROM DryWeatherFlowDays WHERE ' +
              '((MeterID = ' + meterIDStr + ') AND ' +
              '(DWFDate = ' + floattostr(dwfdays[index]) + '));';
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  end;
end;

function TDataModule1.RoundDateTimesToNearestMinute(sTableName: string): boolean;
var
  meterID: integer;
  sqlStr: string;
  recordsAffected: OleVariant;
begin
//rm 2010-05-06 Round DateTime field to nearest minute - helps when joining on the DateTime field
//like esp. WriteAllFlows
  sqlStr := 'Update ' + sTableName + ' set [DateTime] = CDate(Round(1440*[DateTime])/1440);';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.SetJunctionDepthTS(scID: integer; junID: string;
  boIsSelected: boolean);
var sSQL: string;
    sBool: string;
  recordsAffected: OleVariant;
begin
  if boIsSelected then sBool := 'TRUE' else sBool := 'FALSE';
  sSQL := 'Update JunctionDepths set JunctionDepthTS = ' + sBool +
    ' where JunctionID = "' + junID +
    '" and ScenarioID = ' + IntToStr(scID);
    frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
  //if setting to FALSE, then remove any TS from db
  if (not boIsSelected) then  
    RemoveJunctionDepthTS(scID, junID);
  //MessageDlg(sSQL, mtInformation, [mbok], 0);
end;

procedure TDataModule1.SetJunctionSSO(scID:integer; junID: string; boIsSSO: boolean);
var sSQL: string;
    sBool: string;
  recordsAffected: OleVariant;
begin
  if boIsSSO then sBool := 'TRUE' else sBool := 'FALSE';
  sSQL := 'Update JuncFlowTSMaster set IsSSO = ' + sBool +
    ' where JunctionID = "' + junID +
    '" and ScenarioID = ' + IntToStr(scID);
  frmMain.Connection.Execute(sSQL, recordsAffected, adCmdText);
  //if setting to FALSE, then remove any TS from db
  //if (not boIsSSO) then
  //  RemoveJunctionFlowlTS(scID, junID);
  //MessageDlg(sSQL, mtInformation, [mbok], 0);
end;

procedure TDataModule1.SetScenarioInpFileName(iSceneID: integer;
  sInpFileName: string);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'UPDATE Scenarios set SWMM5_Input = "' +
    sInpFileName + '" WHERE ScenarioID = ' + inttostr(iSceneID);
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.SetScenarioOutFileName(iSceneID: integer;
  sOutFileName: string);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'UPDATE Scenarios set SWMM5_Output = "' +
    sOutFileName + '" WHERE ScenarioID = ' + inttostr(iSceneID);
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.RemoveWeekdayDWFDays(flowMeterName: string);
var
  dwfdays: daysArray;
  meterID, index: integer;
  meterIDStr, sqlStr: string;
  recordsAffected: OleVariant;
begin
  meterID := GetMeterIDForName(flowMeterName);
  meterIDStr := inttostr(meterID);
  dwfdays := GetWeekdayDWFDays(meterID);
  for index := 0 to length(dwfdays) - 1 do begin
    sqlStr := 'DELETE FROM DryWeatherFlowDays WHERE ' +
              '((MeterID = ' + meterIDStr + ') AND ' +
              '(DWFDate = ' + floattostr(dwfdays[index]) + '));';
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  end;
end;

function TDataModule1.GetRaingaugeNameForAnalysis(analysisName: string): string;
var
  queryStr: string;
  recSet: _recordSet;
begin
  GetRaingaugeNameForAnalysis := '';
  queryStr := 'SELECT RaingaugeName FROM Raingauges, Analyses ' +
              'WHERE ((AnalysisName = "' + analysisName + '") AND ' +
              '(Raingauges.RaingaugeID=Analyses.RaingaugeID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recset.EOF then begin
    GetRaingaugeNameForAnalysis := '';
  end else begin
    recSet.MoveFirst;
    GetRaingaugeNameForAnalysis := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetFlowMeterNameForAnalysis(analysisName: string): string;
var
  queryStr: string;
  recSet: _recordSet;
begin
  GetFlowMeterNameForAnalysis := '';
  queryStr := 'SELECT MeterName FROM Meters, Analyses ' +
              'WHERE ((AnalysisName = "' + analysisName + '") AND ' +
              '(Meters.MeterID=Analyses.MeterID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if Recset.EOF then begin
    GetFlowMeterNameForAnalysis := '';
  end else begin
    recSet.MoveFirst;
    GetFlowMeterNameForAnalysis := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetAreaForAnalysis(analysisName: string): real;
var
  queryStr: string;
  recSet: _recordSet;
begin
  GetAreaForAnalysis := -1;
  queryStr := 'SELECT Area FROM Meters, Analyses ' +
              'WHERE ((AnalysisName = "' + analysisName + '") AND ' +
              '(Meters.MeterID=Analyses.MeterID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.eof then begin
    GetAreaForAnalysis := -1;
  end else begin
    recSet.MoveFirst;
    GetAreaForAnalysis := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetRaingaugeIDForName(raingaugeName: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  GetRaingaugeIDForName := -1;
  queryStr := 'SELECT RaingaugeID FROM Raingauges WHERE (RaingaugeName = "' + raingaugeName + '")';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  // - catch an empty recordset
  if recSet.EOF then begin
    GetRaingaugeIDForName := -1;
  end else begin
    recSet.MoveFirst;
    GetRaingaugeIDForName := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetRainGaugeIDforSewershedID(
  iSewerShedID: integer): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  GetRainGaugeIDforSewershedID := -1;
  queryStr := 'SELECT RainGaugeID FROM SewerSheds WHERE (SewerShedID = ' + inttostr(iSewerShedID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then begin
    GetRainGaugeIDforSewershedID := -1;
  end else begin
    recSet.MoveFirst;
    GetRainGaugeIDforSewershedID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetRainGaugeIDforRDIIAreaID(
  iRDIIAreaID: integer): integer;
var
  queryStr: string;
  recSet: _recordSet;
  iSewerShedID: integer;
  iResult: integer;
begin
  iResult := -1;
  queryStr := 'SELECT RainGaugeID FROM RDIIAreas WHERE (RDIIAreaID = ' + inttostr(iRDIIAreaID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    iResult := recSet.Fields.Item[0].Value;
    if iResult < 1 then begin
      iSewerShedID := GetSewerShedIDForRDIIAreaID(iRDIIAreaID);
      iResult := GetRainGaugeIDforSewershedID(iSewerShedID);
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iResult;
end;

function TDataModule1.GetRaingaugeNameForID(raingaugeID: integer): string;
var
  queryStr: string;
  recSet: _recordSet;
begin
  GetRaingaugeNameForID := '';
  queryStr := 'SELECT RaingaugeName FROM Raingauges WHERE (RaingaugeID = ' +
    IntToStr(raingaugeID) + ')';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  // - catch an empty recordset
  if recSet.EOF then begin
    GetRaingaugeNameForID := '';
  end else begin
    recSet.MoveFirst;
    GetRaingaugeNameForID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetRainUnitID(rainUnitLabel: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  GetRainUnitID := -1;
  queryStr := 'SELECT RainUnitID FROM RainUnits WHERE (Label = "' + rainUnitLabel + '");';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetRainUnitID := -1
  else begin
    recSet.MoveFirst;
    GetRainUnitID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetFlowUnitID(flowUnitLabel: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  GetFlowUnitID := -1;
  queryStr := 'SELECT FlowUnitID FROM FlowUnits WHERE (ShortLabel = "' + flowUnitLabel + '");';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then
    GetFlowUnitID := -1
  else begin
    recSet.MoveFirst;
    GetFlowUnitID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetFlowUnitLabelForID(flowUnitID: integer): String;
var
  queryStr, sResult: string;
  recSet: _recordSet;
begin
  sResult := '';
  queryStr := 'SELECT ShortLabel FROM FlowUnits WHERE (FlowUnitID = ' +
    inttostr(flowUnitID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then
    sResult := ''
  else begin
    recSet.MoveFirst;
    sResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := sResult;
end;

function TDataModule1.GetAreaUnitID(areaUnitLabel: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  GetAreaUnitID := -1;
  queryStr := 'SELECT AreaUnitID FROM AreaUnits WHERE (ShortLabel = "' + areaUnitLabel + '");';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetAreaUnitID := -1
  else begin
    recSet.MoveFirst;
    GetAreaUnitID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetVelocityUnitID(velocityUnitLabel: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  queryStr := 'SELECT VelocityUnitID FROM VelocityUnits WHERE (ShortLabel = "' + velocityUnitLabel + '");';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetVelocityUnitID := -1
  else begin
    recSet.MoveFirst;
    GetVelocityUnitID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetDefaultRTKPatternName(AnalysisID:integer; dtStart:TDateTime): string;
var
s, sResult: string;
idx: integer;
begin
  //rm 2008-10-13 - prevent spaces in rtkpattern names
  s := GetAnalysisNameForID(AnalysisID);
  s := stringreplace(s, ' ', '_', [rfReplaceAll, rfIgnoreCase]);
//  Result :=
//    DatabaseModule.GetAnalysisNameForID(AnalysisID) +
//      '_' + FormatDateTime('yyyy-mm-dd', event.StartDate);
  sResult := s + '_' + FormatDateTime('yyyy-mm-dd', dtStart);
  try
    //rm 2009-06-09 - check for existing RTK pattern of same name
//rm 2010-09-29    idx := GetRTKPAtternIDforName(sResult);
    idx := GetRTKPAtternIDforNameAndMonth(sResult,0);
    if (idx > 0) then begin
      //you could have two events in one day -
      //tack on the military time hour of event -
      sResult := sResult + '_' + FormatDateTime('HH_MM', dtStart);
      //rm 2009-06-09 - check for existing RTK pattern of same name
//rm 2010-09029      idx := GetRTKPAtternIDforName(sResult);
      idx := GetRTKPAtternIDforNameAndMonth(sResult,0);
      if (idx > 0) then begin
        //you could have two events in one hour? -
        //tack on the minutes of event -
        sResult := sResult + '_' + FormatDateTime('ss', dtStart);
      end;
    end;
  finally

  end;
  Result := sResult;

end;

function TDataModule1.GetDepthUnitID(depthUnitLabel: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  GetDepthUnitID := -1;
  queryStr := 'SELECT DepthUnitID FROM DepthUnits WHERE (ShortLabel = "' + depthUnitLabel + '");';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetDepthUnitID := -1
  else begin
    recSet.MoveFirst;
    GetDepthUnitID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetRdiiUnitID(rdiiUnitLabel: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  queryStr := 'SELECT AreaUnitID FROM AreaUnits WHERE (ShortLabel = "' + rdiiUnitLabel + '");';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //- protect against empty recordset
  if recSet.EOF then begin
    GetRdiiUnitID := -1;
  end else begin
    recSet.MoveFirst;
    GetRdiiUnitID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

procedure TDataModule1.RemoveAllEventsForAnalysis(analysisID: integer);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  //rm 2009-06-08 - remove all RTKPatterns associated with the removed events too??
  //rm - there is the chance that an event RTKPattern is in use in a scenario (RTKLinks)
  //TODO: check for this RTKPAtternID in RTKLinks table
  sqlStr := 'DELETE DistinctRow b.* FROM Events a inner join RTKPatterns b ' +
  ' on a.RTKPatternID = b.RTKPatternID ' +
  ' WHERE (a.AnalysisID = ' + inttostr(analysisID) + ');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'DELETE FROM Events WHERE (AnalysisID = ' + inttostr(analysisID) + ');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.RemoveAllGWIAdjustmentsForAnalysis(analysisID: integer);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'DELETE FROM GWIAdjustments WHERE (AnalysisID = ' + inttostr(analysisID) + ');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

function TDataModule1.ObservedFlowBetweenDateTimes(meterID: integer; startDateTime, endDateTime: TDateTime): THydrograph;
var
  queryStr: string;
  recSet: _RecordSet;
  hydrograph: THydrograph;
  index, timestep, numberOfPoints: integer;
  sTimeStamp, eTimeStamp: TTimeStamp;
begin
  timestep := GetFlowTimestep(meterID);
  sTimeStamp := DateTimeToTimeStamp(startDateTime);
  eTimeStamp := DateTimeToTimeStamp(endDateTime);
  numberOfPoints := round((eTimeStamp.Date - sTimeStamp.Date +
                     (eTimeStamp.Time - sTimeStamp.Time) / MSecsPerDay) * 1440 / timestep) + 1;
  //rm 2007-10-22 - a little range checking
  if numberOfPoints < 0 then numberofPoints := 1;
  hydrograph := THydrograph.createWithSize(numberOfPoints,timestep);
  queryStr := 'SELECT Flow FROM Flows WHERE ' +
              '((MeterID = ' + inttostr(meterID) + ') AND ' +
              '(DateTime BETWEEN ' + floattostr(startDateTime) + ' AND ' +
  //            floattostr(endDateTime) + '));';
  //rm 2012-09-19 ORDER BY DATETIME  !!!!
              floattostr(endDateTime) + ')) ORDER BY DATETIME;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then recSet.MoveFirst;
  index := 0;
  while (not recSet.EOF) do begin
{    if (index < numberOfPoints) then   }
      hydrograph.flows[index] := recSet.Fields.Item[0].Value;
    recSet.MoveNext;
    inc(index);
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  ObservedFlowBetweenDateTimes := hydrograph;
end;

procedure TDataModule1.GetExtremeRainfallDateTimesBetweenDates(raingaugeID: integer;
  startDateTime, endDateTime: TDateTime;
  var earliestDateTime,
  latestDateTime: TDateTime);
var
  queryStr: string;
  recSet: _RecordSet;
begin
  queryStr := 'SELECT Min(DateTime), Max(DateTime) FROM Rainfall WHERE ' +
              '(((DateTime >= ' + floattostr(startDateTime) + ') AND ' +
              '(DateTime < ' + floattostr(endDateTime) + ')) AND ' +
              '(RaingaugeID = ' + inttostr(raingaugeID) + '));';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if recSet.EOF then begin
      earliestDateTime := startDateTime;
      latestDateTime := endDateTime;
    end else begin
      recSet.MoveFirst;
      if VarIsNull(recSet.Fields.Item[0].Value) then begin
        earliestDateTime := 0.0;
        latestDateTime := 0.0;
      end else begin
        earliestDateTime := recSet.Fields.Item[0].Value;
        latestDateTime := recSet.Fields.Item[1].Value;
      end;
    end;
  except
    earliestDateTime := startDateTime;
    latestDateTime := endDateTime;
  end;
  if (recSet.State <> adStateClosed) then recSet.Close;
end;

function TDataModule1.GetMaximumRainfallBetweenDates(raingaugeID: integer;
                                                     startDateTime,
                                                     endDateTime: TDateTime): real;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  GetMaximumRainfallBetweenDates := 0.0;
  queryStr := 'SELECT Max(Volume) FROM Rainfall WHERE ' +
              '(((DateTime >= ' + floattostr(startDateTime) + ') AND ' +
              '(DateTime < ' + floattostr(endDateTime) + ')) AND ' +
              '(RaingaugeID = ' + inttostr(raingaugeID) + '));';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if recSet.EOF then
        GetMaximumRainfallBetweenDates := 0.0
    else begin
      recSet.MoveFirst;
      if VarIsNull(recSet.Fields.Item[0].Value) then
        GetMaximumRainfallBetweenDates := 0.0
      else
        GetMaximumRainfallBetweenDates := recSet.Fields.Item[0].Value;
    end;
  except
     GetMaximumRainfallBetweenDates := 0.0;
  end;
  if (recSet.State <> adStateClosed) then recSet.Close;
end;

function TDataModule1.GetPeakHourlyRainIntensityBetweenDates(raingaugeID : integer;
                                            startDateTime,
                                            endDateTime: TDateTime): real;
var
  queryStr : string;
  recSet2: _RecordSet;
  recSet1: _RecordSet;
  maxPeakIntensity : real;
  tempEndDateTime : TDateTime;
  //hourlyRainfall : real;
  //exitNow : boolean;
  //recordcounter, i : integer;

begin
  maxPeakIntensity := 0;
  //exitNow := false;
  queryStr := 'SELECT Volume, DateTime FROM Rainfall WHERE ' +
              '(((DateTime >= ' + floattostr(startDateTime) + ') AND ' +
              '(DateTime < ' + floattostr(endDateTime) + ')) AND ' +
              //rm 2012-09-24 ORDER BY DATETIME
              //'(RaingaugeID = ' + inttostr(raingaugeID) + '));';
              '(RaingaugeID = ' + inttostr(raingaugeID) + ')) ORDER BY DATETIME;';
  recSet1 := CoRecordSet.Create;
  recSet2 := CoRecordSet.Create;

  try
    recSet1.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
//    if recSet1.EOF then begin
    if not recSet1.EOF then
      recSet1.MoveFirst;
    While (not recSet1.EOF) do begin
      tempEndDateTime := inchour(recSet1.Fields.Item[1].Value,1);
      queryStr := 'SELECT Sum(Volume) FROM Rainfall WHERE ' +
              '(((DateTime >= ' + floattostr(recSet1.Fields.Item[1].Value) + ') AND ' +
              '(DateTime < ' + floattostr(tempEndDateTime) + ')) AND ' +
              '(RaingaugeID = ' + inttostr(raingaugeID) + '));';
      try
      recSet2.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      if not recSet2.EOF then
        if recSet2.Fields.Item[0].Value > maxPeakIntensity then maxPeakIntensity := recSet2.Fields.Item[0].Value;
      finally
        if (recSet2.State <> adStateClosed) then recSet2.Close;
      end;
      recSet1.MoveNext;
    end;
    GetPeakHourlyRainIntensityBetweenDates := maxPeakIntensity;
  except
    GetPeakHourlyRainIntensityBetweenDates := 0;
  end;
  if (recSet1.State <> adStateClosed) then recSet1.Close;
end;



function TDataModule1.GetBaseFlowRateForAnalysis(analysisName: string): real;
var
  queryStr: string;
  recSet: _recordSet;
begin
  queryStr := 'SELECT BaseFlowRate FROM Meters, Analyses ' +
              'WHERE ((AnalysisName = "' + analysisName + '") AND ' +
              '(Meters.MeterID=Analyses.MeterID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetBaseFlowRateForAnalysis := 0
  else begin
    recSet.MoveFirst;
    GetBaseFlowRateForAnalysis := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetStartDateTime(meterID: integer): TDateTime;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  queryStr := 'SELECT StartDateTime FROM Meters WHERE (MeterID = ' + inttostr(meterID) +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetStartDateTime := 0
  else begin
    recSet.MoveFirst;
    GetStartDateTime := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetStartDateTime4RainGaugeID(gaugeID: integer): TDateTime;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  queryStr := 'SELECT StartDateTime FROM Raingauges WHERE (RaingaugeID = ' + inttostr(gaugeID) +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetStartDateTime4RainGaugeID := 0
  else begin
    recSet.MoveFirst;
    GetStartDateTime4RainGaugeID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetSumR1ForAnalysisID(idx: integer): double;
//rm 2012-04-17 return the sum of R1 for the Analysis give by AnalysisID = idx
var
  queryStr: string;
  recSet: _RecordSet;
  dResult: double;
begin
  dResult := 0;
  queryStr := 'SELECT Sum(RTKPatterns.R1) FROM ' +
  ' (Analyses INNER JOIN Events ON Analyses.AnalysisID = Events.AnalysisID) ' +
  ' INNER JOIN RTKPatterns ON Events.RTKPatternID = RTKPatterns.RTKPatternID ' +
  ' WHERE (Analyses.AnalysisID = ' + inttostr(idx) +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetSumR1ForAnalysisID := 0
  else begin
    recSet.MoveFirst;
    if varisnull(recSet.Fields.Item[0].Value) then
      dResult := 0.0
    else
      dResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  result := dResult;
end;

procedure TDataModule1.GetUnitIDs4Scenario(iSCID: integer;
  var iRUID, iFUID, iDUID, iVUID, iAUID: integer);
var
  queryStr: string;
  recSet: _RecordSet;
begin
  iRUID := 1;
  iFUID := 1;
  iDUID := 1;
  iVUID := 1;
  iAUID := 1;
  queryStr := 'SELECT RainUnitID, FlowUnitID, DepthUnitID, VelocityUnitID, AreaUnitID ' +
              ' FROM Scenarios WHERE (ScenarioID = ' + inttostr(iSCID) +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    iRUID := recSet.Fields.Item[0].Value;
    iFUID := recSet.Fields.Item[1].Value;
    iDUID := recSet.Fields.Item[2].Value;
    iVUID := recSet.Fields.Item[3].Value;
    iAUID := recSet.Fields.Item[4].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;
function TDataModule1.GetFlowUnitID4Scenario(iSCID: integer): integer;
var
  queryStr: string;
  recSet: _RecordSet;
  var iFUID: integer;
begin
  iFUID := 1;
  queryStr := 'SELECT FlowUnitID ' +
              ' FROM Scenarios WHERE (ScenarioID = ' + inttostr(iSCID) +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    iFUID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iFUID;
end;
function TDataModule1.GetDepthUnitID4Scenario(iSCID: integer): integer;
var
  queryStr: string;
  recSet: _RecordSet;
  var iDUID: integer;
begin
  iDUID := 1;
  queryStr := 'SELECT DepthUnitID ' +
              ' FROM Scenarios WHERE (ScenarioID = ' + inttostr(iSCID) +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    iDUID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iDUID;
end;
function TDataModule1.GetRainUnitID4Scenario(iSCID: integer): integer;
var
  queryStr: string;
  recSet: _RecordSet;
  var iRUID: integer;
begin
  iRUID := 1;
  queryStr := 'SELECT RainUnitID ' +
              ' FROM Scenarios WHERE (ScenarioID = ' + inttostr(iSCID) +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    iRUID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iRUID;
end;
function TDataModule1.GetAreaUnitID4Scenario(iSCID: integer): integer;
var
  queryStr: string;
  recSet: _RecordSet;
  var iAUID: integer;
begin
  iAUID := 1;
  queryStr := 'SELECT AreaUnitID ' +
              ' FROM Scenarios WHERE (ScenarioID = ' + inttostr(iSCID) +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    iAUID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iAUID;
end;

function TDataModule1.GetEndDateTime(meterID: integer): TDateTime;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  queryStr := 'SELECT EndDateTime FROM Meters WHERE (MeterID = ' + inttostr(meterID) +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetEndDateTime := 0
  else begin
    recSet.MoveFirst;
    GetEndDateTime := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetEndDateTime4RainGaugeID(gaugeID: integer): TDateTime;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  queryStr := 'SELECT EndDateTime FROM Raingauges WHERE (RaingaugeID = ' + inttostr(gaugeID) +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetEndDateTime4RainGaugeID := 0
  else begin
    recSet.MoveFirst;
    GetEndDateTime4RainGaugeID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

procedure TDataModule1.RemoveFlowConverter(flowConverterName: string);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'DELETE FROM FlowConverters WHERE (FlowConverterName = "'+flowConverterName+'");';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.RemoveRainConverter(rainConverterName: string);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'DELETE FROM RainConverters WHERE (RainConverterName = "'+rainConverterName+'");';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;


function TDataModule1.GetFlowConverterIndexForName(sName: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
  iResult: integer;
begin
  iResult := -1;
  queryStr := 'SELECT FlowConverterID FROM FlowConverters WHERE (FlowConverterName = "' + sName + '")';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  // - catch an empty recordset
  if recSet.EOF then begin
  end else begin
    recSet.MoveFirst;
    iResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iResult;
end;

function TDataModule1.GetFlowConverterNames(): TStringList;
var
  converterNames: TStringList;
  recSet: _RecordSet;
begin
  converterNames := TStringList.Create;
  recSet := CoRecordSet.Create;
  try
  recSet.Open('SELECT FlowConverterName FROM FlowConverters',
              frmMain.connection,
              adOpenForwardOnly,
              adLockOptimistic,
              adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    converterNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetFlowConverterNames := converterNames;
end;

function TDataModule1.GetRainConverterIndexForName(sName: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  GetRainConverterIndexForName := -1;
  queryStr := 'SELECT RainConverterID FROM RainConverters WHERE (RainConverterName = "' + sName + '")';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  // - catch an empty recordset
  if recSet.EOF then begin
    GetRainConverterIndexForName := -1;
  end else begin
    recSet.MoveFirst;
    GetRainConverterIndexForName := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetRainConverterNames(): TStringList;
var
  converterNames: TStringList;
  recSet: _RecordSet;
begin
  converterNames := TStringList.Create;
  recSet := CoRecordSet.Create;
  try
  recSet.Open('SELECT RainConverterName FROM RainConverters',
              frmMain.connection,
              adOpenForwardOnly,
              adLockOptimistic,
              adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    converterNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetRainConverterNames := converterNames;
end;

function TDataModule1.GetRdiiConverterNames(): TStringList;
var
  converterNames: TStringList;
  recSet: _RecordSet;
begin
  converterNames := TStringList.Create;
  recSet := CoRecordSet.Create;
  try
  recSet.Open('SELECT RdiiConverterName FROM RdiiConverters',
              frmMain.connection,
              adOpenForwardOnly,
              adLockOptimistic,
              adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    converterNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetRdiiConverterNames := converterNames;
end;

function TDataModule1.GetRDIIperLFlabel(sFlowUnitLabel: string;
  var dVol: double): string;
var sResult: string;
begin
//rm 2010-10-20 converting from Cubic Feet to either Gal or L
  if sFlowUnitLabel = 'CFS' then begin
    sResult := ' CF/LF';
  end else if sFlowUnitLabel = 'CMS' then begin
    dVol := dVol * 28.3168;
    sResult := ' L/LF';
  end else if sFlowUnitLabel = 'GPM' then begin
    dVol := dVol * 7.48051;
    sResult := ' Gal/LF';
  end else if sFlowUnitLabel = 'LPS' then begin
    dVol := dVol * 28.3168;
    sResult := ' L/LF';
  end else if sFlowUnitLabel = 'MGD' then begin
    dVol := dVol * 7.48051;
    sResult := ' Gal/LF';
  end else if sFlowUnitLabel = 'MLD' then begin
    dVol := dVol * 28.3168;
    sResult := ' L/LF';
  end else begin
    sResult := sFlowUnitLabel;
  end;
  Result := sResult;
end;

function TDataModule1.GetSewerLengthForMeter(meterID: integer): double;
var
  dResult: double;
  queryStr: string;
  recSet: _recordSet;
begin
  dResult := 0.0;
  queryStr := 'SELECT SewerLength FROM Meters WHERE (MeterID = ' +
    inttostr(meterID) + ')';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF  then begin
      recSet.MoveFirst;
      dResult := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  result := dResult;
end;

function TDataModule1.GetSewerShedArea(sewershedID: integer): double;
var
  queryStr: string;
  recSet: _recordSet;
begin
  queryStr := 'SELECT s.Area * a.ConversionFactor FROM Sewersheds as s ' +
  ' inner join AreaUnits as a on s.AreaUnitID = a.AreaUnitID ' +
  ' WHERE (SewershedID = ' + inttostr(sewershedID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then begin
    GetSewerShedArea := 0;
  end else begin
    recSet.MoveFirst;
    GetSewerShedArea := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetSewerShedAreaInNativeUnits(sewershedID: integer): double;
var
  queryStr: string;
  recSet: _recordSet;
begin
  queryStr := 'SELECT Area FROM Sewersheds ' +
  ' WHERE (SewershedID = ' + inttostr(sewershedID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then begin
    GetSewerShedAreaInNativeUnits := 0;
  end else begin
    recSet.MoveFirst;
    GetSewerShedAreaInNativeUnits := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetSewershedConverterIndexForName(sName: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
  iResult: integer;
begin
  iResult := -1;
  queryStr := 'SELECT SewershedConverterID FROM SewershedConverters ' +
  ' WHERE (SewershedConverterName = "' + sName + '")';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  // - catch an empty recordset
  if recSet.EOF then begin
  end else begin
    recSet.MoveFirst;
    iResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iResult;
end;

function TDataModule1.GetSewerShedConverterNames(): TStringList;
var
  converterNames: TStringList;
  recSet: _RecordSet;
begin
  converterNames := TStringList.Create;
  recSet := CoRecordSet.Create;
  try
  recSet.Open('SELECT SewerShedConverterName FROM SewerShedConverters',
              frmMain.connection,
              adOpenForwardOnly,
              adLockOptimistic,
              adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    converterNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetSewerShedConverterNames := converterNames;
end;

function TDataModule1.GetSewerShedIDForRDIIAreaID(RDIIAreaID: integer): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  queryStr := 'SELECT SewerShedID FROM RDIIAreas WHERE (RDIIAreaID = ' +
    inttostr(RDIIAreaID) + ')';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  // catch empty recordset
  if recSet.EOF  then begin
    GetSewerShedIDForRDIIAreaID := -1;
  end else begin
    recSet.MoveFirst;
    GetSewerShedIDForRDIIAreaID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetRDIIAreaArea(rdiiareaID: integer): double;
var
  queryStr: string;
  recSet: _recordSet;
begin
//  queryStr := 'SELECT Area FROM RDIIAreas WHERE (RDIIAreaID = ' + inttostr(rdiiareaID) + ');';
  queryStr := 'SELECT r.Area * a.ConversionFactor FROM RDIIAreas as r ' +
  ' inner join AreaUnits as a on r.AreaUnitID = a.AreaUnitID ' +
  ' WHERE (RDIIAreaID = ' + inttostr(rdiiareaID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then begin
    GetRDIIAreaArea := 0;
  end else begin
    recSet.MoveFirst;
    GetRDIIAreaArea := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetRDIIAreaAreasForSewerShed(
  SewerShedName: string): double;
var dResult: double;
  queryStr: string;
  recSet: _recordSet;
begin
  dResult := 0.0;
  queryStr := 'SELECT sum(r.Area) FROM RDIIAreas as r ' +
  ' inner join SewerSheds as s on r.SewerShedID = s.SewerShedID ' +
  ' WHERE (s.SewerShedName = "' + SewerShedName + '");';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    if varisnull(recSet.Fields.Item[0].Value) then
      dResult := 0.0
    else
      dResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := dResult;
end;

procedure TDataModule1.GetRTKLinkGrid(iSceneID: integer; var inStringGrid: TStringGrid);
var queryStr: string;
    recSet: _RecordSet;
    iRow: integer;
begin
(*
  SELECT a.RTKLinkID, b.RDIIAreaName, c.RTKPatternName, b.Area from
    (RTKLinks as a
    inner join
    RDIIAreas as b
    on a.RDIIAreaID = b.RDIIAreaID)
      inner join RTKPatterns as c
      on a.RTKPatternID = c.RTKPatternID
        where a.ScenarioID = 1
*)
//
  inStringGrid := TStringGrid.Create(frmMain);
  inStringGrid.ColCount := 4;
  inStringGrid.RowCount := 2;
  iRow := 1;
  queryStr := 'SELECT a.RTKLinkID, b.SewerShedName, ' +
            ' c.RTKPatternName + ":  " ' +
            ' + CStr(c.R1) + ", " + CStr(c.T1) + ", " + CStr(c.K1) + ", " ' +
            ' + CStr(c.R2) + ", " + CStr(c.T2) + ", " + CStr(c.K2) + ", " ' +
            ' + CStr(c.R3) + ", " + CStr(c.T3) + ", " + CStr(c.K3) as LongName ' +
            ' From (RTKLinks as a inner join ' +
            ' SewerSheds as b on a.SewerShedID = b.SewerShedID) ' +
            ' inner join RTKPatterns as c ' +
            ' on a.RTKPatternID = c.RTKPatternID ' +
            ' WHERE (a.ScenarioID = ' + inttostr(iSceneID) + ') ' +
            ' AND (a.RDIIAreaID < 0)';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    while not recSet.EOF do begin
      inStringGrid.Cells[0,iRow] := 'S';
      inStringGrid.Cells[1,iRow] := vartostr(recSet.Fields.Item[1].Value);
      inStringGrid.Cells[2,iRow] := vartostr(recSet.Fields.Item[2].Value);
      inStringGrid.Cells[3,iRow] := vartostr(recSet.Fields.Item[0].Value);
      inStringGrid.RowCount := inStringGrid.RowCount + 1;
      iRow := iRow + 1;
      recSet.MoveNext;
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  queryStr := 'SELECT a.RTKLinkID, b.RDIIAreaName, ' +
            ' c.RTKPatternName + ":  " ' +
            ' + CStr(c.R1) + ", " + CStr(c.T1) + ", " + CStr(c.K1) + ", " ' +
            ' + CStr(c.R2) + ", " + CStr(c.T2) + ", " + CStr(c.K2) + ", " ' +
            ' + CStr(c.R3) + ", " + CStr(c.T3) + ", " + CStr(c.K3) as LongName ' +
            ' From (RTKLinks as a inner join ' +
            ' RDIIAreas as b on a.RDIIAreaID = b.RDIIAreaID) ' +
            ' inner join RTKPatterns as c ' +
            ' on a.RTKPatternID = c.RTKPatternID ' +
            ' WHERE a.ScenarioID = ' + inttostr(iSceneID);
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    while not recSet.EOF do begin
      inStringGrid.Cells[0,iRow] := 'R';
      inStringGrid.Cells[1,iRow] := vartostr(recSet.Fields.Item[1].Value);
      inStringGrid.Cells[2,iRow] := vartostr(recSet.Fields.Item[2].Value);
      inStringGrid.Cells[3,iRow] := vartostr(recSet.Fields.Item[0].Value);
      inStringGrid.RowCount := inStringGrid.RowCount + 1;
      iRow := iRow + 1;
      recSet.MoveNext;
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
(*
  queryStr := 'SELECT a.RTKLinkID, b.RDIIAreaName, c.RTKPatternName ' +
            ' From (RTKLinks as a inner join ' +
            ' RDIIAreas as b on a.RDIIAreaID = b.RDIIAreaID) ' +
            ' inner join RTKPatterns as c ' +
            ' on a.RTKPatternID = c.RTKPatternID ' +
            ' WHERE a.ScenarioID = ' + inttostr(iSceneID);
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    while not recSet.EOF do begin
      inStringGrid.Cells[0,iRow] := 'S';
      inStringGrid.Cells[1,iRow] := vartostr(recSet.Fields.Item[1].Value);
      inStringGrid.Cells[2,iRow] := vartostr(recSet.Fields.Item[2].Value);
      inStringGrid.Cells[3,iRow] := vartostr(recSet.Fields.Item[0].Value);
      inStringGrid.RowCount := inStringGrid.RowCount + 1;
      iRow := iRow + 1;
      recSet.MoveNext;
    end;
  end;
*)
end;

function TDataModule1.GetRTKLinkIDForRDIIAreaIDAndScenarioID(iRDIIAreaID,
  iScenarioID: integer): integer;
//return -1 for RTKLink not found
var
  iRTKLinkID: integer;
  queryStr: string;
  recSet: _RecordSet;
begin
  iRTKLinkID := -1;
  queryStr := 'SELECT RTKLinkID FROM RTKLinks ' +
              ' Where (RDIIAreaID = ' + inttostr(iRDIIAreaID) + ') ' +
              ' AND (ScenarioID = ' + inttostr(iScenarioID) + ');';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if (recSet.EOF) then begin
      iRTKLinkID := -1; //not found
    end else begin
      recSet.MoveFirst;
      iRTKLinkID := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iRTKLinkID;
end;

function TDataModule1.GetRTKLinkIDForSewerShedIDAndScenarioID(iSewerShedID,
  iScenarioID: integer): integer;
//return -1 for RTKLink not found
var
  iRTKLinkID: integer;
  queryStr: string;
  recSet: _RecordSet;
begin
  iRTKLinkID := -1;
  queryStr := 'SELECT RTKLinkID FROM RTKLinks ' +
              ' Where (SewerShedID = ' + inttostr(iSewerShedID) + ') ' +
              ' AND (ScenarioID = ' + inttostr(iScenarioID) + ');';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if (recSet.EOF) then begin
      iRTKLinkID := -1; //not found
    end else begin
      recSet.MoveFirst;
      iRTKLinkID := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iRTKLinkID;
end;

function TDataModule1.GetRTKPatternConverterIndexForName(
  sName: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
  iResult: integer;
begin
  iResult := -1;
  queryStr := 'SELECT RTKPatternConverterID FROM RTKPatternConverters ' +
  ' WHERE (RTKPatternConverterName = "' + sName + '")';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  // - catch an empty recordset
  if recSet.EOF then begin
  end else begin
    recSet.MoveFirst;
    iResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iResult;
end;

function TDataModule1.GetRTKPatternConverterNames(): TStringList;
var
  converterNames: TStringList;
  recSet: _RecordSet;
begin
  converterNames := TStringList.Create;
  recSet := CoRecordSet.Create;
  try
  recSet.Open('SELECT RTKPAtternConverterName FROM RTKPatternConverters',
              frmMain.connection,
              adOpenForwardOnly,
              adLockOptimistic,
              adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    converterNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetRTKPatternConverterNames := converterNames;
end;

function TDataModule1.GetRDIIAreaConverterIndexForName(sName: string): integer;
var
  queryStr: string;
  recSet: _recordSet;
  iResult: integer;
begin
  iResult := -1;
  queryStr := 'SELECT RDIIAreaConverterID FROM RDIIAreaConverters ' +
  ' WHERE (RDIIAreaConverterName = "' + sName + '")';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  // - catch an empty recordset
  if recSet.EOF then begin
  end else begin
    recSet.MoveFirst;
    iResult := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iResult;
end;

function TDataModule1.GetRDIIAreaConverterNames(): TStringList;
var
  converterNames: TStringList;
  recSet: _RecordSet;
begin
  converterNames := TStringList.Create;
  recSet := CoRecordSet.Create;
  try
  recSet.Open('SELECT RDIIAreaConverterName FROM RDIIAreaConverters',
              frmMain.connection,
              adOpenForwardOnly,
              adLockOptimistic,
              adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    converterNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetRDIIAreaConverterNames := converterNames;
end;

procedure TDataModule1.RemoveRaingauge(raingaugeName: string);
var
  raingaugeIDStr, sqlStr: string;
  recordsAffected: OleVariant;
begin
  raingaugeIDStr := inttostr(GetRaingaugeIDForName(raingaugeName));
  sqlStr := 'DELETE FROM Rainfall WHERE (RaingaugeID = '+raingaugeIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'DELETE FROM Raingauges WHERE (RaingaugeID = '+raingaugeIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.RemoveSewerShed(sewershedName: string);
var
  sewershedIDStr, sqlStr: string;
  recordsAffected: OleVariant;
begin
  sewershedIDStr := inttostr(GetSewerShedIDForName(sewershedName));
  sqlStr := 'DELETE FROM SewerSheds WHERE (SewerShedID = '+sewershedIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'DELETE FROM RDIIAreas WHERE (SewerShedID = '+sewershedIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  //sqlStr := 'DELETE FROM RDII WHERE (SewerShedID = '+sewershedIDStr+');';
  //frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;
procedure TDataModule1.RemoveRDIIArea(RDIIAreaName: string);
var
  RDIIAreaIDStr, sqlStr: string;
  recordsAffected: OleVariant;
begin
  RDIIAreaIDStr := inttostr(GetRDIIAreaIDForName(RDIIAreaName));
  sqlStr := 'DELETE FROM RDIIAreas WHERE (RDIIAreaID = '+RDIIAreaIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.RemoveRTKPAtternConverter(RTKPatternConverterName: string);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'DELETE FROM RTKPatternConverters WHERE (RTKPatternConverterName = "'+RTKPatternConverterName+'");';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.RemoveSewerShedConverter(sewershedConverterName: string);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'DELETE FROM SewershedConverters WHERE (SewerShedConverterName = "'+sewershedConverterName+'");';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;
procedure TDataModule1.RemoveRDIIAreaConverter(RDIIAreaConverterName: string);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'DELETE FROM RDIIAreaConverters WHERE (RDIIAreaConverterName = "'+RDIIAreaConverterName+'");';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.RemoveRDIIConverter(rdiiConverterName: string);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'DELETE FROM RDIIConverters WHERE (RDIIConverterName = "'+rdiiConverterName+'");';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.RemoveRTKLink(iRTKLinkID: integer);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'DELETE FROM RTKLinks WHERE (rtkLinkID = ' + inttostr(iRTKLinkID) + ');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TDataModule1.RemoveRTKPattern(rtkPatternName: string);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  Screen.Cursor := crHourglass;
  sqlStr := 'DELETE FROM RTKPAtterns WHERE (rtkPatternName = '''+rtkPatternName+''');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  Screen.Cursor := crDefault;
end;

procedure TDataModule1.RemoveRainfallForRaingauge(raingaugeName: string);
var
  raingaugeIDStr, sqlStr: string;
  recordsAffected: OleVariant;
begin
  Screen.Cursor := crHourglass;
  raingaugeIDStr := inttostr(GetRaingaugeIDForName(raingaugeName));
  sqlStr := 'DELETE FROM Rainfall WHERE (RaingaugeID = '+raingaugeIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  Screen.Cursor := crDefault;
end;


procedure TDataModule1.RemoveMeter(flowMeterName: string);
var
  meterIDStr, sqlStr: string;
  recordsAffected: OleVariant;
begin
  meterIDStr := inttostr(GetMeterIDForName(flowMeterName));
  sqlStr := 'DELETE FROM Flows WHERE (MeterID = '+meterIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'DELETE FROM DryWeatherFlowDays WHERE (MeterID = '+meterIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'DELETE FROM Meters WHERE (MeterID = '+meterIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'DELETE FROM WeekdayDWF WHERE (MeterID = '+meterIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'DELETE FROM WeekendAndHolidayDWF WHERE (MeterID = '+meterIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;


procedure TDataModule1.RemoveScenario(scenarioName: string);
var
  scenarioIDStr, sqlStr: string;
  recordsAffected: OleVariant;
begin
  scenarioIDStr := inttostr(GetScenarioIDForName(scenarioName));
  sqlStr := 'DELETE FROM ConduitMaxCapacity WHERE (ScenarioID = '+scenarioIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'DELETE FROM Flooding WHERE (ScenarioID = '+scenarioIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'DELETE FROM OutletVolume WHERE (ScenarioID = '+scenarioIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'DELETE FROM RTKLinks WHERE (ScenarioID = '+scenarioIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'DELETE FROM Scenarios WHERE (ScenarioID = '+ScenarioIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;


procedure TDataModule1.RemoveFlowsForMeter(flowMeterName: string);
var
  meterIDStr, sqlStr: string;
  recordsAffected: OleVariant;
begin
  Screen.Cursor := Controls.crHourGlass;
  try
  meterIDStr := inttostr(GetMeterIDForName(flowMeterName));
  sqlStr := 'DELETE FROM Flows WHERE (MeterID = '+meterIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  finally
    Screen.Cursor := crDefault;
  end;
end;


procedure TDataModule1.RemoveAnalysis(analysisName: string);
var
  analysisIDStr, sqlStr: string;
  recordsAffected: OleVariant;
begin
  analysisIDStr := inttostr(GetAnalysisIDForName(analysisName));
  sqlStr := 'DELETE FROM Events WHERE (AnalysisID = '+analysisIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'DELETE FROM GWIAdjustments WHERE (AnalysisID = '+analysisIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'DELETE FROM Analyses WHERE (AnalysisID = '+analysisIDStr+');';
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;


function TDataModule1.RemoveConditionAssessment(caName: string): integer;
var iResult: integer;
  IDStr, sqlStr: string;
  recordsAffected: OleVariant;
begin
//rm 2011-03-15
  iResult := -1;
  IDStr := inttostr(GetCAID4Name(caName));
  sqlStr := 'DELETE FROM ConditionAssessments WHERE (CAID = '+IDStr+');';
  try
    frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
    iResult := 0;
  finally

  end;
  result := iResult;
end;

function TDataModule1.AnalysesUsingFlowMeter(flowMeterName: string): TStringList;
var
  analysisNames: TStringList;
  meterIDStr, queryStr: string;
  recSet: _RecordSet;
begin
  analysisNames := TStringList.Create;
  meterIDStr := inttostr(GetMeterIDForName(flowMeterName));
  queryStr := 'SELECT AnalysisName FROM Analyses WHERE (MeterID = '+meterIDStr+');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    analysisNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  AnalysesUsingFlowMeter := analysisNames;
end;

function TDataModule1.AnalysesUsingRaingauge(raingaugeName: string): TStringList;
var
  analysisNames: TStringList;
  raingaugeIDStr, queryStr: string;
  recSet: _RecordSet;
begin
  analysisNames := TStringList.Create;
  raingaugeIDStr := inttostr(GetRaingaugeIDForName(raingaugeName));
  queryStr := 'SELECT AnalysisName FROM Analyses WHERE (RaingaugeID = '+raingaugeIDStr+');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    analysisNames.Add(vartostr(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  AnalysesUsingRaingauge := analysisNames;
end;

function TDataModule1.RDIIsUsingSewerShed(sewerShedName: string): TStringList;
var
  rdiiNames: TStringList;
  sewershedIDStr, queryStr: string;
  recSet: _RecordSet;
begin
  rdiiNames := TStringList.Create;
  sewershedIDStr := inttostr(GetSewerShedIDForName(sewerShedName));
  //queryStr := 'SELECT Node FROM RDII WHERE (SewershedID = '+sewershedIDStr+');';
  queryStr := 'SELECT JunctionID FROM RDIIAreas WHERE (SewershedID = '+sewershedIDStr+');';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if (not recSet.EOF) then recSet.MoveFirst;
    while (not recSet.EOF) do begin
      rdiiNames.Add(vartostr(recSet.Fields.Item[0].Value));
      recSet.MoveNext;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  RDIIsUsingSewerShed := rdiiNames;
end;

function TDataModule1.AddConditionAssessment(caName: string): integer;
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  sqlStr := 'INSERT INTO ConditionAssessments (CAName) ' +
            'VALUES ("' + caName + '");';
  frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
  result := GetCAID4Name(caName);
end;

procedure TDataModule1.AddEvent(analysisID: integer; event: TStormEvent);
var
  fields, values: OleVariant;
  recSet: _RecordSet;
begin
  recSet := CoRecordSet.Create;
  try
  recSet.Open('Events',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  //rm 2009-06-09 - no longer storing RTKs in Events Table
  //fields := VarArrayCreate([1,12],varVariant);
  //values := VarArrayCreate([1,12],varVariant);
  fields := VarArrayCreate([1,3],varVariant);
  values := VarArrayCreate([1,3],varVariant);
  fields[1] := 'AnalysisID';
  fields[2] := 'StartDateTime';
  fields[3] := 'EndDateTime';
  //fields[4] := 'R1';
  //fields[5] := 'R2';
  //fields[6] := 'R3';
  //fields[7] := 'T1';
  //fields[8] := 'T2';
  //fields[9] := 'T3';
  //fields[10] := 'K1';
  //fields[11] := 'K2';
  //fields[12] := 'K3';

  values[1] := analysisID;
  values[2] := event.StartDate;
  values[3] := event.EndDate;
  //values[4] := event.R[0];
  //values[5] := event.R[1];
  //values[6] := event.R[2];
  //values[7] := event.T[0];
  //values[8] := event.T[1];
  //values[9] := event.T[2];
  //values[10] := event.K[0];
  //values[11] := event.K[1];
  //values[12] := event.K[2];

  recSet.AddNew(fields,values);
  {after the new record is added, retrieve the eventID generated by the DB}
  event.eventID := recSet.Fields.Item[0].Value;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  //rm 2009-08-14 - we need to add a new RTK pattern now for the new event

end;

procedure TDataModule1.AddEvents(analysisID: integer; events: TStormEventCollection);
var
  index: integer;
  fields, values: OleVariant;
  recSet: _RecordSet;
  event: TStormEvent;
begin
  //rm 2009-08-14 - big problem here - -
  recSet := CoRecordSet.Create;
  try
  recSet.Open('Events',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
//  fields := VarArrayCreate([1,12],varVariant);
//  values := VarArrayCreate([1,12],varVariant);
  fields := VarArrayCreate([1,3],varVariant);
  values := VarArrayCreate([1,3],varVariant);

  fields[1] := 'AnalysisID';
  fields[2] := 'StartDateTime';
  fields[3] := 'EndDateTime';
  //fields[4] := 'R1';
  //fields[5] := 'R2';
  //fields[6] := 'R3';
  //fields[7] := 'T1';
  //fields[8] := 'T2';
  //fields[9] := 'T3';
  //fields[10] := 'K1';
  //fields[11] := 'K2';
  //fields[12] := 'K3';

  values[1] := analysisID;

  for index := 0 to events.count - 1 do begin
    event := events[index];
    values[2] := event.StartDate;
    values[3] := event.EndDate;
    //values[4] := event.R[0];
    //values[5] := event.R[1];
    //values[6] := event.R[2];
    //values[7] := event.T[0];
    //values[8] := event.T[1];
    //values[9] := event.T[2];
    //values[10] := event.K[0];
    //values[11] := event.K[1];
    //values[12] := event.K[2];

    recSet.AddNew(fields,values);
    {after the new record is added, retrieve the eventID generated by the DB}
    event.eventID := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetConversionForMeter(meterID: integer): real;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  queryStr := 'SELECT ConversionFactor FROM Meters, FlowUnits WHERE ' +
              '((MeterID = ' + inttostr(meterID) + ') AND ' +
              '(Meters.FlowUnitID = FlowUnits.FlowUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recset.eof then begin
    GetConversionForMeter := -1;
  end else begin
    recSet.MoveFirst;
    GetConversionForMeter := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

//new one for Version 1.0.1 - now accommodating area units other than acres
function TDataModule1.GetConversionToAcresForMeter(meterName: string; meterID: integer): double;
var
  queryStr: string;
  recSet: _RecordSet;
  dResult: double;
begin
  dResult := 1.0;
  if Length(meterName) > 0 then
    queryStr := 'SELECT a.ConversionFactor FROM AreaUnits a inner join Meters m ' +
                ' on a.AreaUnitID = m.AreaUnitID ' +
                ' WHERE (m.MeterName = "' + meterName + '");'
  else
    queryStr := 'SELECT a.ConversionFactor FROM AreaUnits a inner join Meters m ' +
                ' on a.AreaUnitID = m.AreaUnitID ' +
                ' WHERE (m.MeterID = ' + inttostr(meterID) + ');';
{
  if Length(meterName) > 0 then
    queryStr := 'SELECT ConversionFactor FROM Meters, AreaUnits WHERE ' +
                '((MeterName = "' + meterName + '") AND ' +
                '(Meters.AreaUnitID = AreaUnits.AreaUnitID));'
  else
    queryStr := 'SELECT ConversionFactor FROM Meters, AreaUnits WHERE ' +
                '((MeterID = ' + inttostr(meterID) + ') AND ' +
                '(Meters.AreaUnitID = AreaUnits.AreaUnitID));';
}
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recset.eof then begin
      recSet.MoveFirst;
      dResult := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetConversionToAcresForMeter := dResult;
end;

function TDataModule1.GetConversionForRaingauge(raingaugeID: integer): real;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  queryStr := 'SELECT ConversionFactor FROM Raingauges, RainUnits ' +
              'WHERE ((RaingaugeID = ' + inttostr(raingaugeID) + ') AND ' +
              '(Raingauges.RainUnitID = RainUnits.RainUnitID));';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.eof then begin
    GetConversionForRaingauge := -1;
  end else begin
    recSet.MoveFirst;
    GetConversionForRaingauge := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetRainfallTimestep(raingaugeID: integer): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  queryStr := 'SELECT TimeStep FROM Raingauges WHERE (RaingaugeID = ' + inttostr(raingaugeID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recset.eof then begin
    GetRainfallTimestep := -1;
  end else begin
    recSet.MoveFirst;
    GetRainfallTimestep := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetRainGaugeIDForAnalysisID(analysisid: integer): integer;
var
  analysisIDStr, queryStr: string;
  recSet: _RecordSet;
  iResult: integer;
begin
  iResult := -1;
  analysisIDStr := inttostr(analysisid);
  queryStr := 'SELECT raingaugeid FROM ' +
  ' Analyses WHERE AnalysisID = ' + analysisIDStr + ';';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then begin
      recSet.MoveFirst;
      iResult := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  result := iResult;
end;

function TDataModule1.GetRainGaugeIDForMeterID(meterid: integer): integer;
var
  meterIDStr, queryStr: string;
  recSet: _RecordSet;
  iResult: integer;
begin
//SELECT raingaugeid from analyses a inner join meters b on a.meterid = b.meterid
//where b.meterid =1
  iResult := -1;
  meterIDStr := inttostr(meterid);
  queryStr := 'SELECT TOP 1 raingaugeid FROM ' +
  ' analyses a inner join meters b on a.meterid = b.meterid ' +
  ' WHERE (b.MeterID = ' + meterIDStr +');';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    if not recSet.EOF then begin
      recSet.MoveFirst;
      iResult := recSet.Fields.Item[0].Value;
    end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  result := iResult;
end;

function TDataModule1.MeterHasFlowData(flowMeterName: string): boolean;
var
  meterIDStr, queryStr: string;
  recSet: _RecordSet;
begin
  meterIDStr := inttostr(GetMeterIDForName(flowMeterName));
  queryStr := 'SELECT TOP 1 MeterID FROM Flows WHERE (MeterID = ' + meterIDStr +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  MeterHasFlowData := not recSet.EOF;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.RaingaugeHasRainfallData(raingaugeName: string): boolean;
var
  raingaugeIDStr, queryStr: string;
  recSet: _RecordSet;
begin
  raingaugeIDStr := inttostr(GetRaingaugeIDForName(raingaugeName));
  queryStr := 'SELECT TOP 1 RaingaugeID FROM Rainfall WHERE (RaingaugeID = ' + raingaugeIDStr +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  RaingaugeHasRainfallData := not recSet.EOF;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetRainUnitIDForRaingauge(raingaugeID: integer): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  queryStr := 'SELECT RainUnitID FROM Raingauges WHERE (RaingaugeID = ' + inttostr(raingaugeID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetRainUnitIDForRaingauge := -1
  else begin
    recSet.MoveFirst;
    GetRainUnitIDForRaingauge := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetFlowUnitIDForFlowMeter(meterID: integer): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  queryStr := 'SELECT FlowUnitID FROM Meters WHERE (MeterID = ' + inttostr(meterID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetFlowUnitIDForFlowMeter := -1
  else begin
    recSet.MoveFirst;
    GetFlowUnitIDForFlowMeter := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetAreaUnitIDForSewershed(sewershedID: integer): integer;
var
  queryStr: string;
  recSet: _recordSet;
begin
  queryStr := 'SELECT AreaUnitID FROM Sewersheds WHERE (SewershedID = ' + inttostr(sewershedID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then GetAreaUnitIDForSewershed := -1
  else begin
    recSet.MoveFirst;
    GetAreaUnitIDForSewershed := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetAreaUnitIDForSWMM5FlowUnitLabel(
  flowLabel: string): integer;
var
  iResult: integer;
  sLabel: string;
begin
  iResult := 1; //default
  sLabel := Trim(UpperCase(flowLabel));
  if (sLabel = 'CMS')
  or (sLabel = 'LPS')
  or (sLabel = 'MLD') then  //metric units
    //iResult := 5; //hectares
    iResult := GetAreaUnitID('ha');
  Result := iResult;
end;
function TDataModule1.GetDepthUnitIDForSWMM5FlowUnitLabel(
  flowLabel: string): integer;
var
  iResult: integer;
  sLabel: string;
begin
  iResult := 1; //default
  sLabel := Trim(UpperCase(flowLabel));
  if (sLabel = 'CMS')
  or (sLabel = 'LPS')
  or (sLabel = 'MLD') then  //metric units
    //iResult := 3; //meters
    iResult := GetDepthUnitID('m');
  Result := iResult;
end;
function TDataModule1.GetFlowUnitIDForSWMM5FlowUnitLabel(
  flowLabel: string): integer;
var
  iResult: integer;
  sLabel: string;
begin
  iResult := 1; //default
  sLabel := Trim(UpperCase(flowLabel));
  iResult := GetFlowUnitID(sLabel);
  Result := iResult;
end;
function TDataModule1.GetRainUnitIDForSWMM5FlowUnitLabel(
  flowLabel: string): integer;
var
  iResult: integer;
  sLabel: string;
begin
  iResult := 1; //default
  sLabel := Trim(UpperCase(flowLabel));
  if (sLabel = 'CMS')
  or (sLabel = 'LPS')
  or (sLabel = 'MLD') then  //metric
    //iResult := 3; //mm
    iResult := GetRainUnitID('Millimeters');
  Result := iResult;
end;


function TDataModule1.AnalysisHasEvents(analysisName: string): boolean;
var
  analysisIDStr, queryStr: string;
  recSet: _RecordSet;
begin
  analysisIDStr := inttostr(GetAnalysisIDForName(analysisName));
  queryStr := 'SELECT TOP 1 AnalysisID FROM Events WHERE (AnalysisID = ' + analysisIDStr +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  AnalysisHasEvents := not recSet.EOF;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.AnalysisHasGWIAdjustments(analysisName: string): boolean;
var
  analysisIDStr, queryStr: string;
  recSet: _RecordSet;
begin
  analysisIDStr := inttostr(GetAnalysisIDForName(analysisName));
  queryStr := 'SELECT TOP 1 AnalysisID FROM GWIAdjustments WHERE (AnalysisID = ' + analysisIDStr +');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  AnalysisHasGWIAdjustments := not recSet.EOF;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

procedure TDataModule1.GetDryWeatherFlowStatistics(meterID, wdwe: integer;
                                                   var avgMax, avg, avgMin: real);
{var
  count, timestep, index: integer;
  hmin, hmax, havg, avgMinSum, avgMaxSum, avgSum: real;
  date, startDateTime, endDateTime: TDateTime;
  dwf, hydrograph: THydrograph;
  dwfDays: daysArray;
begin
  timestep := GetFlowTimestep(meterID);
  if (wdwe = 0)
    then dwfDays := DatabaseModule.GetWeekdayDWFDays(meterID)
    else dwfDays := DatabaseModule.GetWeekendDWFDays(meterID);

  count := 0;
  avgMinSum := 0.0;
  avgMaxSum := 0.0;
  avgSum := 0.0;
  for index := 0 to length(dwfdays) - 1 do begin
    date := dwfDays[index];
    startDateTime := date;
    endDateTime := startDateTime + 1 - (timestep / 1440);
    hydrograph := ObservedFlowBetweenDateTimes(meterID,startDateTime,endDateTime);
    inc(count);
    hmin := hydrograph.runningAverageMinimum(8);
    hmax := hydrograph.runningAverageMaximum(8);
    havg := hydrograph.average;
    avgMinSum := avgMinSum + hmin;
    avgMaxSum := avgMaxSum + hmax;
    avgSum := avgSum + havg;
    hydrograph.Free;
  end;
  if (count > 0) then begin
    avgMin := avgMinSum / count;
    avgMax := avgMaxSum / count;
    avg := avgSum / count;
  end
  else begin
    avgMin := 0.0;
    avgMax := 0.0;
    avg := 0.0;
  end;
}
var
  dwf: THydrograph;
begin
  if (wdwe = 0)
    then dwf := DatabaseModule.GetWeekdayDWF(meterID)
    else dwf := DatabaseModule.GetWeekendDWF(meterID);
  avgMin := dwf.Minimum;
  avgMax := dwf.Maximum;
  avg := dwf.average;
  dwf.free;
end;

function TDataModule1.databaseVersion(): integer;
var
  queryStr: string;
  recSet: _RecordSet;
begin
  queryStr := 'SELECT DatabaseVersion FROM Metadata';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then databaseVersion := -1
  else begin
    recSet.MoveFirst;
    databaseVersion := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.ExportRTKPatterns2CSV(CSVFilename: string): boolean;
var
  queryStr, sOutPath, sTBName, sExt: string;
  recordsAffected: OleVariant;
  boResult: boolean;
begin
//    sQry = "SELECT * INTO [TEXT;DATABASE=" & sOutPath + "].[" & sTBName + "#CSV" & _
//         "] FROM [" & sPrefix & sTBName & sSuffix & "]"
//remove carriage returns and linefeeds with
//SELECT Trim(replace(replace(description,Chr(10)," "),Chr(13)," ")) FROM RTKPatterns;
  boResult := false;
  try
    if FileExists(CSVFilename) then
      DeleteFile(CSVFilename);
    sOutPath := ExtractFilePath(CSVFileName);
    sTBName := ExtractFileName(CSVFileName);
    sExt := ExtractFileExt(CSVFileName);
    sTBName := Copy(sTBName,1,Length(sTBName) - Length(sExt));

    queryStr := 'SELECT * INTO [TEXT;DATABASE=' +
      sOutPath + '].[' + sTBName + '#CSV] From RTKPatterns;';
    frmMain.Connection.Execute(queryStr,recordsAffected,adCmdText);
    boResult := true;

  finally

  end;
  Result := boResult;
end;

procedure TDataModule1.FactorRTKPattern(var PatternList: TStringList;
  dblFactor: double);
var R1,R2,R3: double;
begin
//factor the Rs by dblFactor
  R1 := strtoFloat(PatternList[1]);
  R2 := strtoFloat(PatternList[4]);
  R3 := strtoFloat(PatternList[7]);
  PatternList[1] := floattoStr(R1 * dblFactor);
  PatternList[4] := floattoStr(R2 * dblFactor);
  PatternList[7] := floattoStr(R3 * dblFactor);
end;

function TDataModule1.GetHolidayLabels: TStringList;
//rm 2007-10-25 - fill in an oversite here to include holidays
var
  holidays: TStringList;
  recSet: _RecordSet;
  queryStr: string;
begin
  holidays := TStringList.Create;
  queryStr := 'SELECT Label FROM Holidays ORDER BY HOLIDAYDATE;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    holidays.Add(trim(recSet.Fields.Item[0].Value));
    recSet.MoveNext;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetHolidayLabels := holidays;
end;

function TDataModule1.GetHolidays(): daysArray;
var
  holidays: daysArray;
  arraySize, index: integer;
  recSet: _RecordSet;
  queryStr: string;
begin
  arraySize := 20;
  SetLength(holidays,arraySize);
  queryStr := 'SELECT HolidayDate FROM Holidays ORDER BY HOLIDAYDATE;';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  index := 0;
  if (not recSet.EOF) then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    if (index >= arraySize) then begin
      arraySize := arraySize + 20;
      SetLength(holidays,arraySize);
    end;
    holidays[index] := trunc(recSet.Fields.Item[0].Value);
    recSet.MoveNext;
    inc(index);
  end;
  arraySize := index;
  SetLength(holidays,arraySize);
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetHolidays := holidays;
end;

function TDataModule1.GetJuncDepthTS(scID: integer; junID: string; boScenUnits: boolean): TStringList;
var
  returnStringList: TStringList;
  queryStr, sID, sVal: string;
  recSet: _RecordSet;
begin
//rm - if boScenUnits then return ts in Scenario Depth Units
  returnStringList := TStringList.Create;
  recSet := CoRecordSet.Create;
  queryStr := 'SELECT CStr(d.[DateTime]), CStr(d.Value) ' +
    ' FROM JuncDepthTSDetail d inner join JuncDepthTSMaster m ' +
    ' on d.JuncDepthTSMasterID = m.JuncDepthTSMasterID ' +
    ' where m.ScenarioID = ' + IntToStr(scID) +
    ' and m.JunctionID = "' + junID + '" ORDER by [DATETIME]';
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    while not recSet.EOF do begin
      //sID := recSet.Fields.Item[0].Value + ',' + recSet.Fields.Item[1].Value;
      sID := recSet.Fields.Item[0].Value;
      sVal := formatfloat('0.000000',recSet.Fields.Item[1].Value);
      returnStringList.Add(sID + ',' + sVal);
      recSet.MoveNext;
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := returnStringList;
end;

function TDataModule1.GetJuncDepthTSUnitLabel(scID: integer; junID: string;
  var iUnitID: integer): String;
var
  queryStr, sReturn: string;
  recSet: _RecordSet;
begin
  sReturn := '';
  iUnitID := -1;
  recSet := CoRecordSet.Create;
  queryStr := 'SELECT a.DepthUnitID, b.ShortLabel ' +
    ' FROM JuncDepthTSMaster a inner join DepthUnits b ' +
    ' on a.DepthUnitID = b.DepthUnitID ' +
    ' where a.ScenarioID = ' + IntToStr(scID) +
    ' and a.JunctionID = "' + junID + '"';
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    iUnitID := recSet.Fields.Item[0].Value;
    sReturn := recSet.Fields.Item[1].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := sReturn;
end;

function TDataModule1.GetJuncFlooding(scID: integer; junID: string; var iUnits:integer): double;
var
  dResult: double;
  queryStr: string;
  recSet: _recordSet;
begin
  dResult := 0.0;
  iUnits := 1;
  if Length(junID) > 0 then begin
    queryStr := 'SELECT Volume, FlowUnitID FROM Flooding ' +
    ' WHERE (NodeID = "' + junID + '") ' +
    ' AND (ScenarioID = ' + inttostr(scID) + ')';
    recSet := CoRecordSet.Create;
    try
      recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      if not recSet.EOF then begin
        recSet.MoveFirst;
        dResult := recSet.Fields.Item[0].Value;
        iUnits := recSet.Fields.Item[1].Value;
      end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  Result := dResult;
end;

function TDataModule1.GetJuncFlowTS(scID: integer; junID: string; boScenUnits: boolean): TStringList;
var
  returnStringList: TStringList;
  queryStr, sID, sVal: string;
  recSet: _RecordSet;
  fctr: double;
  mUnitLabel, sUnitLabel: string;
  mUnitID, sUnitID: integer;
begin
//rm - if boScenUnits then return ts in Scenario Depth Units
  fctr := 1.0;
  if (boScenUnits) then begin
    //determine what factor is needed to convert from native to Scenario flow units
    mUnitLabel := GetJuncFlowTSUnitLabel(scID, junID, mUnitID);
    sUnitID := GetFlowUnitID4Scenario(scID);
    //don't do anything if they are the same
    if (mUnitID <> sUnitID) then begin
      //first divide fctr by model conversionfactor
      //then divide fctr by scenario conversionfactor
      fctr := fctr / GetConversionFactorForFlowUnitID(mUnitID);
      fctr := fctr / GetConversionFactorForFlowUnitID(sUnitID);
    end;
  end;
  returnStringList := TStringList.Create;
  recSet := CoRecordSet.Create;
  queryStr := 'SELECT CStr(d.[DateTime]), CStr(' +
    FormatFloat('0.00000000000000',fctr) + ' * d.Value) ' +
    ' FROM JuncFlowTSDetail d inner join JuncFlowTSMaster m ' +
    ' on d.JuncFlowTSMasterID = m.JuncFlowTSMasterID ' +
    ' where m.ScenarioID = ' + IntToStr(scID) +
    ' and m.JunctionID = "' + junID + '" ORDER by [DATETIME]';
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    while not recSet.EOF do begin
      //sID := recSet.Fields.Item[0].Value + ',' + recSet.Fields.Item[1].Value;
      sID := recSet.Fields.Item[0].Value;
      sVal := formatfloat('0.000000',recSet.Fields.Item[1].Value);
      returnStringList.Add(sID + ',' + sVal);
      recSet.MoveNext;
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := returnStringList;
end;

function TDataModule1.GetJuncFlowTSUnitLabel(scID: integer; junID: string;
  var iUnitID: integer): String;
var
  queryStr, sReturn: string;
  recSet: _RecordSet;
begin
  sReturn := '';
  iUnitID := -1;
  recSet := CoRecordSet.Create;
  queryStr := 'SELECT a.FlowUnitID, b.ShortLabel ' +
    ' FROM JuncFlowTSMaster a inner join FlowUnits b ' +
    ' on a.FlowUnitID = b.FlowUnitID ' +
    ' where a.ScenarioID = ' + IntToStr(scID) +
    ' and a.JunctionID = "' + junID + '"';
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    iUnitID := recSet.Fields.Item[0].Value;
    sReturn := recSet.Fields.Item[1].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := sReturn;
end;

function TDataModule1.GetJuncMaxDepth(scID: integer; junID: string): double;
var
  dResult: double;
  queryStr: string;
  recSet: _recordSet;
begin
  dResult := 0.0;
  if Length(junID) > 0 then begin
    queryStr := 'SELECT MaxWaterDepth FROM JunctionDepths ' +
    ' WHERE (JunctionID = "' + junID + '") ' +
    ' AND (ScenarioID = ' + inttostr(scID) + ')';
    recSet := CoRecordSet.Create;
    try
      recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      if not recSet.EOF then begin
        recSet.MoveFirst;
        dResult := recSet.Fields.Item[0].Value;
      end;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  Result := dResult;
end;

function TDataModule1.GetJuncMaxDepthUnitLabel(scID: integer; junID: string;
  var iUnitID: integer): String;
var
  queryStr, sReturn: string;
  recSet: _RecordSet;
begin
  sReturn := 'ft';  //default
  iUnitID := 1;
  recSet := CoRecordSet.Create;
  queryStr := 'SELECT a.DepthUnitID, b.ShortLabel ' +
    ' FROM JunctionDepths a inner join DepthUnits b ' +
    ' on a.DepthUnitID = b.DepthUnitID ' +
    ' where a.ScenarioID = ' + IntToStr(scID) +
    ' and a.JunctionID = "' + junID + '"';
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    iUnitID := recSet.Fields.Item[0].Value;
    sReturn := recSet.Fields.Item[1].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := sReturn;
end;

function TDataModule1.GetJunctionIDforRDIIAreaID(
  iRDIIAreaID: Integer): string;
var
  queryStr: string;
  recSet: _recordSet;
begin
  queryStr := 'SELECT JunctionID FROM RDIIAreas WHERE (RDIIAreaID = ' + inttostr(iRDIIAreaID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then begin
    Result := '';
  end else begin
    recSet.MoveFirst;
    Result := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetJunctionIDforSewerShedID(
  iSewerShedID: Integer): string;
var
  queryStr: string;
  recSet: _recordSet;
begin
  queryStr := 'SELECT JunctionID FROM SewerSheds WHERE (SewerShedID = ' + inttostr(iSewerShedID) + ');';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if recSet.EOF then begin
    Result := '';
  end else begin
    recSet.MoveFirst;
    if varisnull(recSet.Fields.Item[0].Value) then
      Result := ''
    else
      Result := recSet.Fields.Item[0].Value;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetJunctionsbyScenario(scID: integer; sWhereClause: string): TStringList;
var
  returnStringList: TStringList;
  queryStr, sID: string;
  recSet: _RecordSet;
begin
  returnStringList := TStringList.Create;
  recSet := CoRecordSet.Create;
  queryStr := 'Select JunctionID from JunctionDepths ' +
    ' where ScenarioID = ' + IntToStr(scID);
  if (Length(sWhereClause) > 0) then
    queryStr := queryStr + ' and ' + sWhereClause;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    while not recSet.EOF do begin
      sID := recSet.Fields.Item[0].Value;
      returnStringList.Add(sID);
      recSet.MoveNext;
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := returnStringList;
end;

function TDataModule1.GetDiurnalCurves(analysisName: string): diurnalCurves;
var
  meterName, queryStr: string;
  recSet: _RecordSet;
  meterID, timestep, segmentsPerDay, index: integer;
  diurnal: diurnalCurves;
  dayadj: array[0..6] of real;
  weekdayDWF, weekendDWF: THydrograph;
begin
  meterName := GetFlowMeterNameForAnalysis(analysisName);
  meterID := GetMeterIDForName(meterName);
  timestep := DatabaseModule.GetFlowTimestep(meterID);
  segmentsPerDay := 1440 div timeStep;

  queryStr := 'SELECT SundayDWFAdj, MondayDWFAdj, TuesdayDWFAdj, ' +
              'WednesdayDWFAdj, ThursdayDWFAdj, FridayDWFAdj, SaturdayDWFAdj ' +
              'FROM Analyses WHERE (AnalysisName = "' + analysisName + '");';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then begin
    recSet.MoveFirst;
    try
    for index := 0 to 6 do dayadj[index] := recSet.Fields.Item[index].Value;
    finally
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
  end;
  weekdayDWF := DatabaseModule.GetWeekdayDWF(meterID);
  weekendDWF := DatabaseModule.GetWeekendDWF(meterID);

  SetLength(diurnal,8,segmentsPerDay);
  for index := 0 to segmentsPerDay - 1 do begin
    diurnal[0,index] := weekendDWF.flows[index] + dayadj[0];   // sunday
    diurnal[1,index] := weekdayDWF.flows[index] + dayadj[1];   // monday
    diurnal[2,index] := weekdayDWF.flows[index] + dayadj[2];   // tuesday
    diurnal[3,index] := weekdayDWF.flows[index] + dayadj[3];   // wednesday
    diurnal[4,index] := weekdayDWF.flows[index] + dayadj[4];   // thursday
    diurnal[5,index] := weekdayDWF.flows[index] + dayadj[5];   // friday
    diurnal[6,index] := weekendDWF.flows[index] + dayadj[6];   // saturday
    diurnal[7,index] := weekendDWF.flows[index] + dayadj[0];   // holiday (same as sunday)
  end;
  weekdayDWF.Free;
  weekendDWF.Free;

  GetDiurnalCurves := diurnal;
end;



function TDataModule1.GetAnalysis(analysisName: string): TAnalysis;
var
  newAnalysis: TAnalysis;
  index: integer;
  recSet: _RecordSet;
  queryStr: string;
begin
  newAnalysis := TAnalysis.Create();
  newAnalysis.Name := analysisName;

  queryStr := 'SELECT BaseFlowRate, MaxDepressionStorage, RateOfReduction,' +
              ' InitialValue, R1, R2, R3, T1, T2, T3, K1, K2, K3,' +
              ' RunningAverageDuration, AnalysisID, MeterID, RainGaugeID, ' +
//rm 2010-10-07
              ' MaxDepressionStorage2, RateOfReduction2, InitialValue2, ' +
              ' MaxDepressionStorage3, RateOfReduction3, InitialValue3 ' +
              ' FROM Analyses WHERE (AnalysisName = "' + analysisName + '");';
  recSet := CoRecordSet.Create;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if not recSet.EOF then
  begin
  recSet.MoveFirst;
  with (newAnalysis) do begin
    BaseFlowRate := recSet.Fields.Item[0].Value;
//rm 2010-10-07    MaxDepressionStorage := recSet.Fields.Item[1].Value;
//rm 2010-10-07    RateOfReduction := (recSet.Fields.Item[2].Value) / 30.44;
//rm 2010-10-07    initialDepressionStorage := recSet.Fields.Item[3].Value;
    MaxDepressionStorage[0] := recSet.Fields.Item[1].Value;
    RateOfReduction[0] := (recSet.Fields.Item[2].Value) / 30.44;
    InitialDepressionStorage[0] := recSet.Fields.Item[3].Value;
    for index := 0 to 2 do begin
      defaultR[index] := recSet.Fields.Item[4+index].Value;
      defaultT[index] := recSet.Fields.Item[7+index].Value;
      defaultK[index] := recSet.Fields.Item[10+index].Value;
    end;
    runningAverageDuration := recSet.Fields.Item[13].Value;
    analysisID := recSet.Fields.Item[14].Value;
    flowMeterID := recSet.Fields.Item[15].Value;
    raingaugeID := recSet.Fields.Item[16].Value;
//rm 2010-10-07
    MaxDepressionStorage[1] := recSet.Fields.Item[17].Value;
    RateOfReduction[1] := (recSet.Fields.Item[18].Value) / 30.44;
    InitialDepressionStorage[1] := recSet.Fields.Item[19].Value;
    MaxDepressionStorage[2] := recSet.Fields.Item[20].Value;
    RateOfReduction[2] := (recSet.Fields.Item[21].Value) / 30.44;
    InitialDepressionStorage[2] := recSet.Fields.Item[22].Value;

  end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  GetAnalysis := newAnalysis;
end;

function TDataModule1.CreateNewRTKPattern4Event(event: TStormEvent; sRTKName: string): boolean;
var
  sqlStr: string;
  recSet: _recordSet;
  recordsAffected: OleVariant;
  bo_Result: boolean;
begin
  //check for a unique RTK Pattern Name before calling this
  //create a new record in RTKPAtterns for this event
  bo_Result := false;
  event.RTKPatternID := -1;
  event.RTKName := '';
  sqlStr := 'INSERT INTO RTKPatterns ' +
            ' (RTKPatternName) '+
            ' VALUES ("' + Trim(sRTKName) + '")';
  //showmessage(sqlStr);
  frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
  sqlStr := 'SELECT RTKPatternID FROM RTKPatterns ' +
            ' WHERE ' +
            ' (RTKPAtternName = "' + Trim(sRTKName) + '");';
  recSet := CoRecordSet.Create;
  try
    //showmessage(sqlStr);
    recSet.Open(sqlStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    recSet.MoveFirst;
    event.RTKPatternID := recSet.Fields.Item[0].Value;
    event.RTKName := Trim(sRTKName);
    bo_Result := true;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := bo_Result;
end;

procedure TDataModule1.CreateWeekdayDWFRecordsForMeter(meterID, timestep: integer);
var
  fields, values: OleVariant;
  recSet: _RecordSet;
  numberOfPoints, index: integer;
begin
  recSet := CoRecordSet.Create;
  try
  recSet.Open('WeekdayDWF',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  fields := VarArrayCreate([1,3],varVariant);
  values := VarArrayCreate([1,3],varVariant);

  fields[1] := 'MeterID';
  fields[2] := 'Minute';
  fields[3] := 'Flow';

  values[1] := meterID;
  values[3] := 0.0;

  numberOfPoints := 1440 div timestep;
  for index := 0 to numberOfPoints - 1 do begin
    values[2] := index * timestep;
    recSet.AddNew(fields,values);
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

procedure TDataModule1.CreateWeekendAndHolidayDWFRecordsForMeter(meterID, timestep: integer);
var
  fields, values: OleVariant;
  recSet: _RecordSet;
  numberOfPoints, index: integer;
begin
  recSet := CoRecordSet.Create;
  try
  recSet.Open('WeekendAndHolidayDWF',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  fields := VarArrayCreate([1,3],varVariant);
  values := VarArrayCreate([1,3],varVariant);

  fields[1] := 'MeterID';
  fields[2] := 'Minute';
  fields[3] := 'Flow';

  values[1] := meterID;
  values[3] := 0.0;

  numberOfPoints := 1440 div timestep;
  for index := 0 to numberOfPoints - 1 do begin
    values[2] := index * timestep;
    recSet.AddNew(fields,values);
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

procedure TDataModule1.AddSWMM5ResultCondCaps(scenarioID: integer; conduitID: string;
                  condCaps : double; duration : double; size : double;length:double;
                  flowunitid:integer);
var
  //index: integer;
  fields, values: OleVariant;
  recSet: _RecordSet;
  //event: TStormEvent;
begin
  recSet := CoRecordSet.Create;
  try
  recSet.Open('ConduitMaxCapacity',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  fields := VarArrayCreate([1,7],varVariant);
  values := VarArrayCreate([1,7],varVariant);

  fields[1] := 'ConduitID';
  fields[2] := 'MaxCapacity';
  fields[3] := 'ScenarioID';
  fields[4] := 'Duration';
  fields[5] := 'Size';
  fields[6] := 'Length';
  //rm 2009-06-29 - added field
  fields[7] := 'FlowUnitID';

  values[1] := conduitID;
  values[2] := condCaps;
  values[3] := scenarioID;
  values[4] := duration;
  values[5] := size;
  values[6] := length;
  values[7] := flowunitid;

  recSet.AddNew(fields,values);
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

procedure TDataModule1.AddSWMM5ResultJuncDepths(scenarioID: integer; junctionID: string;
                  invert: double; depth: double; waterdepth: double; depthunitID:integer);
var
  //index: integer;
  fields, values: OleVariant;
  recSet: _RecordSet;
  //event: TStormEvent;
begin
  recSet := CoRecordSet.Create;
  try
  recSet.Open('JunctionDepths',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  fields := VarArrayCreate([1,6],varVariant);
  values := VarArrayCreate([1,6],varVariant);

  fields[1] := 'JunctionID';
  fields[2] := 'ScenarioID';
  fields[3] := 'JunctionInvert';
  fields[4] := 'JunctionDepth';
  fields[5] := 'MaxWaterDepth';
  fields[6] := 'DepthUnitID';

  values[1] := junctionID;
  values[2] := scenarioID;
  values[3] := invert;
  values[4] := depth;
  values[5] := waterdepth;
  values[6] := depthunitID;

  recSet.AddNew(fields,values);
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.AddSWMM5ResultJuncDepthTSDetail(iSc: integer; iJunID: integer;
  dt: TDateTime; val: double): integer;
var
  fields, values: OleVariant;
  recSet: _RecordSet;
  iResult: integer;
begin
  iResult := -1;
  recSet := CoRecordSet.Create;
  try
    recSet.Open('JuncDepthTSDetail',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
    fields := VarArrayCreate([1,3],varVariant);
    values := VarArrayCreate([1,3],varVariant);

    fields[1] := 'JuncDepthTSMasterID';
    fields[2] := 'DateTime';
    fields[3] := 'Value';

    values[1] := iJunID;
    values[2] := dt;
    values[3] := val;

    recSet.AddNew(fields,values);
    iResult := 0;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iResult;
end;

function TDataModule1.AddSWMM5ResultJuncDepthTSMaster(iSc: integer;
  sJunID: string; dInv: double; dDep: double; iDepthUnitID: integer): integer;
var
  queryStr: string;
  fields, values: OleVariant;
  recSet: _RecordSet;
  iResult: integer;
begin
  iResult := -1;
  recSet := CoRecordSet.Create;
  try
    recSet.Open('JuncDepthTSMaster',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
    fields := VarArrayCreate([1,5],varVariant);
    values := VarArrayCreate([1,5],varVariant);

    fields[1] := 'JunctionID';
    fields[2] := 'ScenarioID';
    fields[3] := 'JunctionInvert';
    fields[4] := 'JunctionDepth';
    fields[5] := 'DepthUnitID';

    values[1] := sJunID;
    values[2] := iSc;
    values[3] := dInv;
    values[4] := dDep;
    values[5] := iDepthUnitID;

    recSet.AddNew(fields,values);
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  try
    queryStr := 'SELECT Max(JuncDepthTSMasterID) FROM JuncDepthTSMaster WHERE ' +
                '(JunctionID = "' + sJunID + '") and (ScenarioID = ' + IntToStr(iSc) + ');';
    recSet := CoRecordSet.Create;
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    iResult := recSet.Fields.Item[0].Value;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iResult;
end;

function TDataModule1.AddSWMM5ResultJuncFlowTSDetail(iSc, iJunID: integer;
  dt: TDateTime; val: double): integer;
var
  fields, values: OleVariant;
  recSet: _RecordSet;
  iResult: integer;
begin
  iResult := -1;
  recSet := CoRecordSet.Create;
  try
    recSet.Open('JuncFlowTSDetail',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
    fields := VarArrayCreate([1,3],varVariant);
    values := VarArrayCreate([1,3],varVariant);

    fields[1] := 'JuncFlowTSMasterID';
    fields[2] := 'DateTime';
    fields[3] := 'Value';

    values[1] := iJunID;
    values[2] := dt;
    values[3] := val;

    recSet.AddNew(fields,values);
    iResult := 0;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iResult;
end;

function TDataModule1.AddSWMM5ResultJuncFlowTSMaster(iSc: integer;
  sJunID: string; boIsOutfall, boIsSSO: Boolean; iFlowUnitID: integer): integer;
var
  queryStr: string;
  fields, values: OleVariant;
  recSet: _RecordSet;
  iResult: integer;
begin
  iResult := -1;
  recSet := CoRecordSet.Create;
  try
    recSet.Open('JuncFlowTSMaster',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
    fields := VarArrayCreate([1,5],varVariant);
    values := VarArrayCreate([1,5],varVariant);

    fields[1] := 'JunctionID';
    fields[2] := 'ScenarioID';
    fields[3] := 'IsOutfall';
    fields[4] := 'IsSSO';
    fields[5] := 'FlowUnitID';

    values[1] := sJunID;
    values[2] := iSc;
    values[3] := boIsOutfall;
    values[4] := boIsSSO;
    values[5] := iFlowUnitID;

    recSet.AddNew(fields,values);
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  queryStr := 'SELECT Max(JuncFlowTSMasterID) FROM JuncFlowTSMaster WHERE ' +
              '(JunctionID = "' + sJunID + '") and (ScenarioID = ' + IntToStr(iSc) + ');';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    iResult := recSet.Fields.Item[0].Value;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := iResult;
end;

function TDataModule1.AddSWMM5ResultConduitTSDetail(iSc, iConID: integer;
  dt: TDateTime; val: double): integer;
begin
//rm 2009-05-22
  MessageDlg('Got Detail for conduit master number ' + inttostr(iConID) + ' at datetime ' +
    datetimetostr(dt) + ' Flow = ' + FormatFloat('0.00',val),mtInformation,[mbok],0);
  Result := 0;
end;

function TDataModule1.AddSWMM5ResultConduitTSMaster(iSc: integer;
  sConID: string; boIsOutfall, boIsSSO: Boolean; iFlowUnitID: integer): integer;
begin
//rm 2009-05-22
  MessageDlg('Got Master for Scenario number: ' + inttostr(iSc) + ' Conduit name: ' +
    sConID, mtInformation, [mbok], 0);
  Result := 0;
end;

procedure TDataModule1.AddSWMM5ResultFloodingVolume(scenarioID: integer;
  nodeID: string; volume : double; duration : double; flowunitID:integer);
var
  fields, values: OleVariant;
  recSet: _RecordSet;
begin
  recSet := CoRecordSet.Create;
  try
  recSet.Open('Flooding',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  fields := VarArrayCreate([1,5],varVariant);
  values := VarArrayCreate([1,5],varVariant);

  fields[1] := 'NodeID';
  fields[2] := 'Volume';
  fields[3] := 'ScenarioID';
  fields[4] := 'Duration';
  fields[5] := 'FlowUnitID';

  values[1] := nodeID;
  values[2] := volume;
  values[3] := scenarioID;
  values[4] := duration;
  values[5] := flowunitID;

  recSet.AddNew(fields,values);
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

procedure TDataModule1.AddSWMM5ResultOutletVolume(scenarioID: integer;
  outletID: string; volume : double; flowUnitID: integer);
var
  //index: integer;
  fields, values: OleVariant;
  recSet: _RecordSet;
  //event: TStormEvent;
begin
  recSet := CoRecordSet.Create;
  try
  recSet.Open('OutletVolume',frmMain.connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  fields := VarArrayCreate([1,4],varVariant);
  values := VarArrayCreate([1,4],varVariant);

  fields[1] := 'NodeID';
  fields[2] := 'Volume';
  fields[3] := 'ScenarioID';
  fields[4] := 'FlowUnitID';

  values[1] := outletID;
  values[2] := volume;
  values[3] := scenarioID;
  values[4] := flowUnitID;

  recSet.AddNew(fields,values);
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

function TDataModule1.GetFloodingJunctionsbyScenario(scID: integer;
  sWhereClause: string): TStringList;
var
  returnStringList: TStringList;
  queryStr, sID: string;
  recSet: _RecordSet;
begin
  returnStringList := TStringList.Create;
  recSet := CoRecordSet.Create;
  queryStr := 'Select NodeID from Flooding ' +
    ' where ScenarioID = ' + IntToStr(scID);
  if (Length(sWhereClause) > 0) then
    queryStr := queryStr + ' and ' + sWhereClause;
  try
  recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  if (not recSet.EOF) then begin
    recSet.MoveFirst;
    while not recSet.EOF do begin
      sID := recSet.Fields.Item[0].Value;
      returnStringList.Add(sID);
      recSet.MoveNext;
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
  Result := returnStringList;
end;

function TDataModule1.GetFlowConversionFactor(unitID: integer): real;
//Get Flow Conversion Factor to MGD
var
  queryStr: string;
  recSet: _RecordSet;
begin
  GetFlowConversionFactor := 1.0;
  queryStr := 'SELECT ConversionFactor FROM FlowUnits WHERE ' +
              '(FlowUnitID = ' + inttostr(unitID) + ');';
  recSet := CoRecordSet.Create;
  try
    recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    GetFlowConversionFactor := recSet.Fields.Item[0].Value;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

procedure TDataModule1.ShowADOErrors(ErrorList: ADODB_TLB.Errors);
var
  I: Integer;
  E: ADODB_TLB.Error;
  S: String;
begin
  for i := 0 to ErrorList.Count - 1 do begin
    E := ErrorList[i];
    S := Format('ADO Error %d of %d:'#13#13'%s',
      [i+1,ErrorList.count,e.description]);
    MessageDlg(s,mtError,[mbok],0);
  end;
end;

end.




