unit iigraph;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, OleCtrls, ChartfxLib_TLB, math, hydrograph, moddatabase, ADODB_TLB,
  StormEvent, StormEventCollection, GWIAdjustment, GWIAdjustmentCollection,
  ExtCtrls, TeeProcs, TeEngine, Chart, Printers, Clipbrd, ImgList;

type
  TfrmIIGraph = class(TForm)
    MainMenu1: TMainMenu;
    Graph1: TMenuItem;
    AverageDWF2: TMenuItem;
    ObservedFlow2: TMenuItem;
    ObservedRDII1: TMenuItem;
    Rainfall2: TMenuItem;
    GWIAdj2: TMenuItem;
    GWI1: TMenuItem;
    RDIICurve11: TMenuItem;
    RDIICurve21: TMenuItem;
    RDIICurve31: TMenuItem;
    SimulatedRDII1: TMenuItem;
    Events2: TMenuItem;
    Close2: TMenuItem;
    File1: TMenuItem;
    PrintPreview1: TMenuItem;
    Print1: TMenuItem;
    Edit1: TMenuItem;
    CopyToClipboard1: TMenuItem;
    Views1: TMenuItem;
    Events3: TMenuItem;
    AsaBitmap1: TMenuItem;
    AsaMetafile1: TMenuItem;
    AsTextdataonly1: TMenuItem;
    Help1: TMenuItem;
    GWIpct90: TMenuItem;
    GWIpct80: TMenuItem;
    GWIpct70: TMenuItem;
    GWIpct60: TMenuItem;
    GWIpct100: TMenuItem;
    GWIpct50: TMenuItem;
    off1: TMenuItem;
    N1: TMenuItem;
    NightlyMinimum1: TMenuItem;
    GWI2: TMenuItem;
    OnOff1: TMenuItem;
    AdjustPercentage1: TMenuItem;
    ToggleColorScheme1: TMenuItem;
    ImageList1: TImageList;
//    ChartFX1: TChartFX;

    procedure Close1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ChartFX1PostPaint(Sender: TObject; w, h: Smallint;
      lPaint: integer; var nRes: Smallint);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ChartFX1LButtonDown(Sender: TObject; x, y: Smallint;
      var nRes: Smallint);
    procedure ChartFX1LButtonUp(Sender: TObject; x, y: Smallint;
      var nRes: Smallint);
    procedure ChartFX1MouseMoving(Sender: TObject; x, y: Smallint;
      var nRes: Smallint);
    procedure ChartFX1LButtonDblClk(Sender: TObject; x, y,
      nSerie: Smallint; nPoint: integer; var nRes: Smallint);
    procedure ChartFX1RButtonUp(Sender: TObject; x, y: Smallint;
      var nRes: Smallint);
    procedure AverageDWF2Click(Sender: TObject);
    procedure ObservedFlow2Click(Sender: TObject);
    procedure ObservedRDII1Click(Sender: TObject);
    procedure Rainfall2Click(Sender: TObject);
    procedure GWIAdj2Click(Sender: TObject);
    procedure GWI1Click(Sender: TObject);
    procedure RDIICurve11Click(Sender: TObject);
    procedure RDIICurve21Click(Sender: TObject);
    procedure RDIICurve31Click(Sender: TObject);
    procedure SimulatedRDII1Click(Sender: TObject);
    procedure Events2Click(Sender: TObject);
    procedure Close2Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Events3Click(Sender: TObject);
    procedure PrintPreview1Click(Sender: TObject);
    procedure AsaBitmap1Click(Sender: TObject);
    procedure AsaMetafile1Click(Sender: TObject);
    procedure AsTextdataonly1Click(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GWIpct100Click(Sender: TObject);
    procedure off1Click(Sender: TObject);
    procedure NightlyMinimum1Click(Sender: TObject);
    procedure OnOff1Click(Sender: TObject);
    procedure AdjustPercentage1Click(Sender: TObject);
    procedure ToggleColorScheme1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);

  private
    holidays: daysArray;
    timerStart, timerEnd: TTimeStamp;
    aperatureWidth: integer;
    analysisID: integer;
    area: real;
    //rm 2010-10-15
    sewerlength: double;
    timestep: integer;
    startDay, endDay, days, maximumMove: integer;
    segmentsPerDay: integer;
    totalSegments: integer;
    rainfall: array of real;
    averageDWF: array of real;
    observedFlow: array of real;
    rdii: array of real;
    conversionToMGD, conversionToInches: real;
    //rm 2009-10-29 - accommodate area units other than acres
    conversionToAcres: double;

    defaultR, defaultT, defaultK : array[0..2] of real;
    rdiiCurve: array of array of real;
    rdiiTotal: array of real;

    dailygwiadj: array of real;
    gwiadj: array of real;
    diurnal: diurnalCurves;

    //rm 2010-10-19
    IACurve: array of double;
    flowUnitLabel: string;
    
    events: TStormEventCollection;
    gwiadjustments: TGWIAdjustmentCollection;

    baseFlowRate, kMax, kRecover, iAbstraction: real;

    //rm 2010-09-29
    kMax2, kRec2, kIni2, kMax3, kRec3, kIni3: double;

    computedGWI: array of real;
    minimumIndicies: array of integer;

    movingGWIPoint: boolean;
    moveDateIndex: integer;
    movingEventEndDate: boolean;
    moveEventEndDateIndex: integer;
    movingEventStartDate: boolean;
    moveEventStartDateIndex: integer;
    movingEventTailDate: boolean;
    newEventStartDate,newEventEndDate: real;

    originalMouseX: integer;
    upperLimit, lowerLimit: TDateTime;
    addingEventStartUp: boolean;
    addEventOnButtonRelease: boolean;

    doubleClicked: boolean;

    timestamp: TDateTime;
    rtimestamp: TTimeStamp;

    printing: boolean;
    handle: HDC;

    ChartFX1: TChartFX;

    GWIPct: double;

    function ChartVisibleWidth: integer;
    function ChartVisibleHeight: integer;
    function ChartDateAtX(x: integer): real;
    function ChartValueAtY(y: integer): real;

    procedure DrawXAxisLabels();
    procedure DrawXAxisLabels2(x,y,w,h: Smallint);
    procedure DrawGWIAdjustmentMarkers(x,y,w,h: Smallint);
    procedure DrawEvents(x,y,w,h: Smallint);
    procedure calculateDailyGWIAdjustments();
    procedure calculateObservedRDII();
    procedure calculateGWI();
    procedure updateGWIAdjustmentDependentArraysAround(adjDate: integer);
    procedure updateGWIAdjustmentDependentGraphSeries();
    procedure invalidateGraph();
    procedure ScrollRight();
    procedure ScrollLeft();
    procedure NextPage();
    procedure PreviousPage();
    function isHoliday(date: TDateTime): boolean;
    function dayOfWeekIndex(date: TDateTime): integer;
    procedure PrintBitmap(bmp: TBitmap);

    //rm 2009-11-02 - new function to set precision of the Y-Axis
    function GetDecimals: integer;
    //rm 2010-04-23
    procedure SetImageIndex(Sender: TObject);

  public { Public declarations }
    procedure calculateSimulatedRDII();
    procedure fillchart();
    procedure SetColors;
    procedure GotoEventNum(idx: integer);
  end;

var
  frmIIGraph: TfrmIIGraph;

implementation

uses chooseAnalysis, eventEdit, mainform, feedbackWithMemo, variants;

{$R *.DFM}

procedure TfrmIIGraph.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmIIGraph.FormShow(Sender: TObject);
var
  i, meterID, raingaugeID: integer;
  analysisName, flowMeterName, {flowUnitLabel,} raingaugeName, rainUnitLabel: string;
  flowStartDateTime, flowEndDateTime: TDateTime;
  maxRainfall: real;
  queryStr: string;
  recSet: _RecordSet;
begin
  Screen.Cursor := crHourglass;
  holidays := DatabaseModule.GetHolidays();
  analysisName := frmAnalysisSelector.SelectedAnalysis;
(* Get all the information about the selected Analsysis *)
  flowMeterName := DatabaseModule.GetFlowMeterNameForAnalysis(analysisName);
  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
  raingaugeName := DatabaseModule.GetRaingaugeNameForAnalysis(analysisName);
  rainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(raingaugeName);

  queryStr := 'SELECT AnalysisID, MeterID, RaingaugeID, BaseFlowRate,' +
              ' MaxDepressionStorage, RateOfReduction, InitialValue,' +
              ' R1, R2, R3, T1, T2, T3, K1, K2, K3, ' +
//rm 2010-10-15 - get the Dmax, Drec and Do for 2 and 3
              ' MaxDepressionStorage2, RateOfReduction2, InitialValue2, ' +
              ' MaxDepressionStorage3, RateOfReduction3, InitialValue3 ' +
              ' FROM Analyses WHERE (AnalysisName = "' + analysisName + '");';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
  analysisID := recSet.Fields.Item[0].Value;
  meterID := recSet.Fields.Item[1].Value;
  raingaugeID := recSet.Fields.Item[2].Value;
  baseFlowRate := recSet.Fields.Item[3].Value;
  kMax := recSet.Fields.Item[4].Value;
//rm 2007-11-01 kRecover not a monthly rate anymore - a daily rate.
//  kRecover := (recSet.Fields.Item[5].Value) / 30.44;
  kRecover := (recSet.Fields.Item[5].Value);
  iAbstraction := recSet.Fields.Item[6].Value;
  //rm 2010-09-29 - for now the default kMax, kRec and kIni are 0 for RTKs 2 and 3
  //rm 2010-10-15 - not anymore
  if varisnull(recSet.Fields.Item[16].Value) then
    kmax2 := 0.0
  else
    kMax2 := recSet.Fields.Item[16].Value;//0;
  if varisnull(recSet.Fields.Item[17].Value) then
    krec2 := 0.0
  else
    krec2 := recSet.Fields.Item[17].Value;//0;
  if varisnull(recSet.Fields.Item[18].Value) then
    kini2 := 0.0
  else
    kini2 := recSet.Fields.Item[18].Value;//0;
  if varisnull(recSet.Fields.Item[19].Value) then
    kmax3 := 0.0
  else
    kmax3 := recSet.Fields.Item[19].Value;//0;
  if varisnull(recSet.Fields.Item[20].Value) then
    krec3 := 0.0
  else
    krec3 := recSet.Fields.Item[20].Value;//0;
  if varisnull(recSet.Fields.Item[21].Value) then
    kini3 := 0.0
  else
    kIni3 := recSet.Fields.Item[21].Value;//0;
  //rm
  for i := 0 to 2 do begin
    defaultR[i] := recSet.Fields.Item[7+i].Value;
    defaultT[i] := recSet.Fields.Item[10+i].Value;
    defaultK[i] := recSet.Fields.Item[13+i].Value;
  end;
  recSet.Close;
(* Get the conversion rates for the flow and rain values *)
  conversionToMGD := DatabaseModule.GetConversionForMeter(meterID);
  conversionToInches := DatabaseModule.GetConversionForRaingauge(raingaugeID);
(* Get metadata about the flow data *)
//rm 2010-10-15 - get sewerlength too  queryStr := 'SELECT StartDateTime, EndDateTime, TimeStep, Area FROM Meters ' +
//              'WHERE (MeterID = ' + inttostr(meterID) + ');';
  queryStr := 'SELECT StartDateTime, EndDateTime, TimeStep, Area, SewerLength FROM Meters ' +
              'WHERE (MeterID = ' + inttostr(meterID) + ');';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //rm 2009-10-28
  if not RecSet.EOF then

  recSet.MoveFirst;
  flowStartDateTime := recSet.Fields.Item[0].Value;
  flowEndDateTime := recSet.Fields.Item[1].Value;
  startDay := trunc(flowStartDateTime);
  endDay := trunc(flowEndDateTime) + 1;        {go to start of next day after last flow value}
  days := endDay - startDay;
  timestep := recSet.Fields.Item[2].Value;
  area := recSet.Fields.Item[3].Value;
  //rm 2010-10-15
  if varisnull(recSet.Fields.Item[4].Value) then
    sewerlength := 0
  else
    sewerlength := recSet.Fields.Item[4].Value;
  //rm 2009-10-29 - Version 1.0.1 accommodates areas in units other than acres
  //we will convert area to acres and then convert back if necessary for display purposes
  //rm 2009-10-29 - get conversion to acres:
  conversionToAcres := DatabaseModule.GetConversionToAcresForMeter('',meterID);
  area := area * conversionToAcres;

  //rm - what to do if area is ZERO?
//  if area <= 0 then area := 1;


  recSet.Close;
(* Configure the graph control based on the data from the analysis *)
  segmentsPerDay := 1440 div timeStep;
  totalSegments := days * segmentsPerDay;
(* These arrays contain values for each segment in a single day *)
  SetLength(diurnal,8,segmentsPerDay);
(* These arrays contain values for each time step *)
  SetLength(averageDWF,totalSegments);
  SetLength(rainfall,totalSegments);
  SetLength(rdii,totalSegments);
  SetLength(observedFlow,totalSegments);
  SetLength(computedGWI,totalSegments);
  SetLength(gwiadj,totalSegments);
  SetLength(rdiiCurve,3,totalSegments);
  SetLength(rdiiTotal,totalSegments);
(* These arrays contain 1 value for each day *)
  SetLength(dailygwiadj,days + 1);
  Setlength(minimumIndicies,days + 1);

  //rm 2010-10-19
  SetLength(IACurve,totalsegments);

(* Get the diurnal DWF hydrographs *)
  diurnal := DatabaseModule.GetDiurnalCurves(analysisName);
(* Get the collection of events *)
  events := DatabaseModule.GetEvents(analysisID);
(* Get the collection of gwi adjustments *)
  gwiAdjustments := DatabaseModule.GetGWIAdjustments(analysisID);
(* The user does not have to specify gwi adjustments for each day.  Here *)
(* calculate the values for all days. *)
  calculateDailyGWIAdjustments;

{* GET RAIN DATA *}
  maxRainfall := 0.0;
  for i := 0 to totalSegments - 1 do rainfall[i] := 0.0;
  queryStr := 'SELECT DateTime, Volume FROM Rainfall WHERE ' +
              '((RaingaugeID = ' + inttostr(raingaugeID) + ') AND ' +
              '(DateTime >= ' + floattostr(flowStartDateTime) + ' AND ' +
              'DateTime <= ' + floattostr(flowEndDateTime) + ')) ' +
              'Order by DateTime;';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if no data
  if not recSet.EOF then
    recSet.MoveFirst;
  while (not recSet.EOF) do begin
    timestamp := recSet.Fields.Item[0].Value;
    rtimestamp := DateTimeToTimeStamp(timestamp);
    i := (trunc(timestamp) - startday) * segmentsPerDay;
    i := i + trunc((rtimestamp.time / MSecsPerDay) * segmentsPerDay);
    rainfall[i] := recSet.Fields.Item[1].Value;
    if (rainfall[i] > maxRainfall) then maxRainfall := rainfall[i];
    recSet.MoveNext;
  end;
  recSet.Close;
{* FILL IN OBSERVED FLOW *}
  queryStr := 'SELECT DateTime, Flow FROM Flows WHERE ' +
              '(MeterID = ' + inttostr(meterID) + ') ORDER BY DateTime;';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if no data
  if not recSet.EOF then
    recSet.MoveFirst;
  while (not recSet.Eof) do begin
    timestamp := recSet.Fields.Item[0].Value;
    rtimestamp := DateTimeToTimeStamp(timestamp);
    i := (trunc(timestamp) - startday) * segmentsPerDay;
    i := i + trunc((rtimestamp.time / MSecsPerDay) * segmentsPerDay);
    //rm 2008-03-20 - check for start of flow Meters.StartDateTime:
    if (i >= 0) and (i < totalsegments) then begin
      observedFlow[i] := recSet.Fields.Item[1].Value;
    end else begin
      //MessageDlg('i = ' + inttostr(i) +
      //  ' / totalsegments = ' + inttostr(totalsegments),mtinformation,[mbok],0);
    end;
    recSet.MoveNext;
  end;
  recSet.Close;

  movingGWIPoint := False;
  movingEventEndDate := False;
  movingEventStartDate := False;
  addingEventStartUp := False;
  addEventOnButtonRelease := False;

  aperatureWidth := min(days,5);

  with ChartFX1 do begin
    Printer.ForceColors := true;
    Align := alClient;
    RightGap := 5;
    TopGap := 5;
    AllowEdit := False;
    AllowDrag := False;
    AllowResize := False;
    Scrollable := False;
    RGBBK := frmMain.ChartRGBBK;//clBlack;
    MenuBarObj.Visible := False;
    TypeMask := TypeMask OR CT_TRACKMOUSE;
    TypeEx := TypeEx OR CTE_SMOOTH;
    MarkerShape := MK_NONE;
    ChartType := LINES;


    with Axis[AXIS_X] do begin
      Min := startDay;
      Max := Min + aperatureWidth;
      Format := 'XM/d/yy';
      PixPerUnit := 100;
      Step := 1;
      Grid := True;
      TextColor := frmMain.ChartRGBBK;//clBlack;   {Hide the markers by using the same color as background}
    end;
 {   OpenDataEx(COD_COLORS,10,10);
    Series[0].Color := clAqua;
    Series[1].Color := clLime;
    Series[2].Color := clRed;
    with Series[3] do begin
      Color := clBlue;
      YAxis := AXIS_Y2;
      Gallery := BAR;
    end;
    Series[4].Color := clBlue;
    Series[5].Color := clNavy;
    Series[6].Color := RGB(0,128,128);
    Series[7].Color := RGB(255,128,128);
    Series[8].Color := clFuchsia;
    Series[9].Color := clYellow;
    CloseData(COD_COLORS);}
    with Axis[AXIS_Y] do begin
      TextColor := frmMain.ChartRGBText;//clWhite;
      ResetScale;
      Title := 'Flow ('+flowUnitLabel+')';
      TitleColor := frmMain.ChartRGBText;//clWhite;
      Decimals := 1;
    end;
    with Axis[AXIS_Y2] do begin
      TextColor := frmMain.ChartRGBText;//clWhite;
      Title := 'Rainfall ('+rainUnitLabel+')';
      TitleColor := frmMain.ChartRGBText;//clWhite;
      Min := ceil(maxRainfall);
      Max := 0;
      Decimals := 1;
    end;

    calculateDailyGWIAdjustments();
    calculateObservedRDII();
    calculateSimulatedRDII();
    calculateGWI();

//rm 2010-10-23 - draw a box around the graph area
  ChartFX1.AxesStyle := 2;

//rm 2010-10-23 - found a way to fix the right Y-Axis flow unit label
//overlapping the scale

  ChartFX1.Axis[AXIS_Y2].Visible := false;
  fillchart;
  ChartFX1.Axis[AXIS_Y2].Visible := true;
  fillChart;

    {
    OpenDataEx(COD_COLORS,11,11);
    Series[0].Color := frmMain.ChartRGBFlow;//clAqua;
    Series[1].Color := clLime;
    Series[2].Color := clRed;
    with Series[3] do begin
      Color := clBlue;
      YAxis := AXIS_Y2;
      Gallery := BAR;
    end;
    Series[4].Color := clBlue;
    Series[5].Color := clNavy;
    Series[6].Color := RGB(0,128,128);
    Series[7].Color := RGB(255,128,128);
    Series[8].Color := clFuchsia;
    Series[9].Color := clYellow;
    Series[10].Color := clOlive;
    CloseData(COD_COLORS);
    }
  end;
  Screen.Cursor := crDefault;
  {*Call SetFocus, so that the form will accept key strokes without requiring
   the user to click on the form *}
  //ChartFX1.SetFocus;
  SetFocus;
end;


procedure TfrmIIGraph.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  { 107 and 187 are plus sign }
  if (key = 107) or (key = 187) then begin
    if (ChartFX1.Axis[AXIS_X].Max < endDay) then begin
      ChartFX1.Axis[AXIS_X].Max := ChartFX1.Axis[AXIS_X].Max + 1;
      fillchart;
    end;
  end;
  { 109 and 189 are the minus sign}
  if (key = 109) or (key = 189) then begin
    if ((ChartFX1.Axis[AXIS_X].Max - ChartFX1.Axis[AXIS_X].Min) > 1) then begin
      ChartFX1.Axis[AXIS_X].Max := ChartFX1.Axis[AXIS_X].Max - 1;
      fillchart;
    end;
  end;

    if (key = 102) then ScrollRight;
    if (key = 100) then ScrollLeft;
end;

//rm 2010-10-19
procedure TfrmIIGraph.GotoEventNum(idx: integer);
var
  visibleMin, visibleMax, visibleWidth, newMin, newMax: double;
  event: TStormEvent;
begin
      ChartFX1.Axis[AXIS_X].GetScrollView(visibleMin,visibleMax);
      if (idx >=0) and (idx < events.Count) then begin

        event := events.Items[idx];
        if (event.StartDate > visibleMax) or (event.EndDate < visibleMin) then begin

              newMin := trunc(event.StartDate);
              newMax := trunc(event.StartDate+visibleMax-visibleMin);
              if (newMax > endDay) then begin
                newMin := newMin - (newMax - endDay);
                newMax := endDay;
              end;
              ChartFX1.Axis[AXIS_X].Min := newMin;
              ChartFX1.Axis[AXIS_X].Max := newMax;
              fillchart;

        end;
      end;
end;

procedure TfrmIIGraph.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  visibleMin, visibleMax, visibleWidth, newMin, newMax: double;
  i: integer;
  found: boolean;
  event: TStormEvent;
begin
  if (ssCtrl in Shift) then begin
    if (key = VK_RIGHT) or (key = VK_LEFT) then begin
      found := false;
      ChartFX1.Axis[AXIS_X].GetScrollView(visibleMin,visibleMax);
      if (key = VK_RIGHT) then begin
        for i := 0 to events.count - 1 do begin
          event := events.Items[i];
          if (event.StartDate > visibleMax) then begin
            if (not found) then begin
              newMin := trunc(event.StartDate);
              newMax := trunc(event.StartDate+visibleMax-visibleMin);
              if (newMax > endDay) then begin
                newMin := newMin - (newMax - endDay);
                newMax := endDay;
              end;
              ChartFX1.Axis[AXIS_X].Min := newMin;
              ChartFX1.Axis[AXIS_X].Max := newMax;
              fillchart;
              found := true;
            end;
          end;
        end;
      end;
      if (key = VK_LEFT) then begin
        for i := events.count - 1 downto 0 do begin
          event := events.Items[i];
          if (event.EndDate < visibleMin) then begin
            if (not found) then begin
              newMin := round(event.EndDate + 0.5)-visibleMax+visibleMin;
              newMax := round(event.EndDate + 0.5);
              if (newMin < startDay) then begin
                newMin := startDay;
                newMax := newMin + (visibleMax-visibleMin);
              end;
              ChartFX1.Axis[AXIS_X].Min := newMin;
              ChartFX1.Axis[AXIS_X].Max := newMax;
              fillchart;
              found := true;
            end;
          end;
        end;
      end;
    end;
  end
  else begin
  {}
    if (key = VK_RIGHT) then ScrollRight;
    if (key = VK_LEFT) then ScrollLeft;
    if (key = VK_NEXT) then NextPage;
    if (key = VK_PRIOR) then PreviousPage;
  {}
    if (key = VK_HOME) then begin
      visibleWidth := ChartFX1.Axis[AXIS_X].Max - ChartFX1.Axis[AXIS_X].Min;
      ChartFX1.Axis[AXIS_X].Min := startDay;
      ChartFX1.Axis[AXIS_X].Max := ChartFX1.Axis[AXIS_X].Min + visibleWidth;
      fillchart;
    end;
    if (key = VK_END) then begin
      visibleWidth := ChartFX1.Axis[AXIS_X].Max - ChartFX1.Axis[AXIS_X].Min;
      ChartFX1.Axis[AXIS_X].Max := startDay + days;
      ChartFX1.Axis[AXIS_X].Min := ChartFX1.Axis[AXIS_X].Max - visibleWidth;
      fillchart;
    end;
  end;
end;

procedure TfrmIIGraph.ChartFX1PostPaint(Sender: TObject; w, h: Smallint;
  lPaint: integer; var nRes: Smallint);
var
  input, output: OLEVariant;
  origX, origY: integer;
begin
  ChartFX1.PaintInfo2(CPI_GETDC,0,output);
  handle := output;

  ChartFX1.PaintInfo2(CPI_PRINTINFO,0,output);
  //rm printing := (output and $FFFF) <> 0;

  ChartFX1.PaintInfo2(CPI_POSITION,0,output);
  origX := output and $0000FFFF;
  origY := output shr 16;

  if (GWIAdj2.Checked) then DrawGWIAdjustmentMarkers(origX, origY, w, h);
  if (Events2.Checked) then DrawEvents(origX, origY, w, h);
  try
    if (not printing) then
      DrawXAxisLabels()
    else if ChartFX1.Printer.ForceColors then
      DrawXAxislabels2(origX, origY, w, h);
  finally
    input := OleVariant(handle);
    ChartFX1.PaintInfo2(CPI_RELEASEDC,input,output);
  end;
end;

procedure TfrmIIGraph.DrawXAxisLabels();
var
  txt: PChar;
  font: TFont;
  oldFont: HFONT;
  i, xPos,yPos, visibleWidth, visibleDays, dow: integer;
  visibleMin, visibleMax: double;

begin
  font := TFont.Create;
  font.name := 'Arial';
  oldFont := SelectObject(handle,font.handle);
  SetTextAlign(handle,TA_CENTER);

  yPos := ChartVisibleHeight + 10;
  ChartFX1.Axis[AXIS_X].GetScrollView(visibleMin,visibleMax);
  visibleDays := trunc(visibleMax - VisibleMin);
  visibleWidth := ChartVisibleWidth();
  if (visibledays > 0) then begin
    for i := trunc(visibleMin) to trunc(visibleMax) do begin
      dow := dayOfWeekIndex(i);
      if (dow in [1,2,3,4,5])
        then SetTextColor(handle,frmMain.ChartRGBText{clWhite})
        else begin
          if (dow in [0,6])
            then SetTextColor(handle,frmMain.ChartRGBGree{Yell})
            else SetTextColor(handle,clGreen);
        end;
      txt := pchar(datetostr(i));
      xPos := ChartFX1.LeftGap + 1 +
              trunc((visibleWidth * (i - trunc(visibleMin)) / visibleDays));
      TextOutA(handle,xPos,yPos,txt,length(txt));
    end;
  end;
  SelectObject(handle,oldFont);
  font.Free;
end;

procedure TfrmIIGraph.DrawXAxisLabels2(x, y, w, h: Smallint);
var
  txt: PChar;
  font: TFont;
  oldFont: HFONT;
  i, xPos,yPos, visibleWidth, visibleHeight, visibleDays, dow: integer;
  visibleMin, visibleMax: double;
  fontSize, spacing: integer;
  output: OLEVariant;
begin

  font := TFont.Create;
  font.name := 'Arial';
  font.size := 8;
  spacing := 10;

//  if (printing) then begin
    fontSize := font.size;
    ChartFX1.PaintInfo2(CPI_PRINTINFO,fontSize,output);
    fontSize := output shr 16;
    font.Size := fontSize;
    ChartFX1.PaintInfo2(CPI_PRINTINFO,spacing,output);
    spacing := output shr 16;
//  end;

  oldFont := SelectObject(handle,font.handle);

  ChartFX1.Axis[AXIS_X].GetScrollView(visibleMin,visibleMax);
  visibleDays := trunc(visibleMax - VisibleMin);

  visibleWidth := w - ChartFX1.LeftGap - ChartFX1.RightGap;
  visibleHeight := h - ChartFX1.TopGap - ChartFX1.BottomGap;


  yPos := trunc(h + (3.5 * spacing));// - ChartFX1.BottomGap;//ChartVisibleHeight + 10;
  ChartFX1.Axis[AXIS_X].GetScrollView(visibleMin,visibleMax);
  visibleDays := trunc(visibleMax - VisibleMin);
  //visibleWidth := ChartFX1.Width;    //ChartVisibleWidth();
  if (visibledays > 0) then begin
    for i := trunc(visibleMin) to trunc(visibleMax) do begin
      dow := dayOfWeekIndex(i);
      if (dow in [1,2,3,4,5])
        then SetTextColor(handle,frmMain.ChartRGBText{clWhite})
        else begin
          if (dow in [0,6])
            then SetTextColor(handle,frmMain.ChartRGBGree{Yell})
            else SetTextColor(handle,clGreen);
        end;
      txt := pchar(datetostr(i));
      xPos := ChartFX1.LeftGap + spacing * 4 +
              trunc((visibleWidth * (i - trunc(visibleMin)) / visibleDays));
      TextOutA(handle,xPos,yPos,txt,length(txt));
    end;
  end;
  SelectObject(handle,oldFont);
  font.Free;

end;

procedure TfrmIIGraph.DrawGWIAdjustmentMarkers(x,y,w,h: Smallint);
var
  visibleMin, VisibleMax: double;
  i, xPos, yPos, visibleDays, date, visibleWidth, visibleHeight: integer;
  radius : integer;
  yMax, yRange, adj : real;
  adjustment: TGWIAdjustment;
  output: OLEVariant;
begin
  ChartFX1.Axis[AXIS_X].GetScrollView(visibleMin,visibleMax);
  visibleDays := trunc(visibleMax - VisibleMin);
  yMax := ChartFX1.Axis[AXIS_Y].Max;
  yRange := yMax - ChartFX1.Axis[AXIS_Y].Min;
//rm 2007-12-19 - a little error-checking here:
 if (yRange > 0) and (visibleDays > 0) then begin
  radius := 5;
  if (printing) then begin
    ChartFX1.PaintInfo2(CPI_PRINTINFO,radius,output);
    radius := output shr 16;
  end;
  visibleWidth := w - ChartFX1.LeftGap - ChartFX1.RightGap;
  visibleHeight := h - ChartFX1.TopGap - ChartFX1.BottomGap;
  for i := 0 to gwiadjustments.count - 1 do begin
    adjustment := gwiadjustments.items[i];
    date := adjustment.Date;
    adj := adjustment.Value;
    if (date >= visibleMin) and (date <= visibleMax) then begin
      xPos := x + ChartFX1.LeftGap + round((visibleWidth * (date - trunc(visibleMin)) / visibleDays));
      yPos := y + ChartFX1.TopGap + round((visibleHeight * (yMax - adj) / yRange));
      Ellipse(handle,xPos-radius,yPos-radius,xPos+radius,yPos+radius);
    end;
  end;
 end;
end;

procedure TfrmIIGraph.DrawEvents(x,y,w,h: Smallint);
var
  oldPen, pen: HPEN;
  font: TFont;
  oldFont: HFONT;
  leftX, rightX, topY, bottomY, iprec{, tailX }: integer;
  visibleMin, VisibleMax, observedPeak,totalRDIIPeak,rdiiPeak,gwiSum,rdiiVolume: double;
  rainDepth,dwfSum,observedSum,totalRDIISum,rdiiSum,rainvolume,rvalue,iidepth: double;
  startDate, endDate, eventDuration{, tailDate}: real;
  i, j, visibleDays, visibleWidth, visibleHeight, fontSize, spacing: integer;
  txt: PChar;
  event: TStormEvent;
  dateHolder: string;
  output: OLEVariant;

  testDate : TDateTime;
  //rm 2010-10-20
  sRDIIperLFlabel, sVollabel: string;
  dRDIIperLF, dVol: double;

begin
  iprec := 0;
  font := TFont.Create;
  font.name := 'Arial';
  font.size := 8;
  spacing := 10;

  if (printing) then begin
    fontSize := font.size;
    ChartFX1.PaintInfo2(CPI_PRINTINFO,fontSize,output);
    fontSize := output shr 16;
    font.Size := fontSize;
    ChartFX1.PaintInfo2(CPI_PRINTINFO,spacing,output);
    spacing := output shr 16;
  end;

  oldFont := SelectObject(handle,font.handle);

  ChartFX1.Axis[AXIS_X].GetScrollView(visibleMin,visibleMax);
  visibleDays := trunc(visibleMax - VisibleMin);

  visibleWidth := w - ChartFX1.LeftGap - ChartFX1.RightGap;
  visibleHeight := h - ChartFX1.TopGap - ChartFX1.BottomGap;

  for i := 0 to events.Count - 1 do begin
    SetTextColor(handle,clFuchsia);
    event := events.items[i];
    startDate := event.StartDate;
    endDate := event.EndDate;
    if ((startDate <= visibleMax) and (startDate >= visibleMin)) or
       ((endDate <= visibleMax) and (endDate >= visibleMin)) or
       ((startDate <= visibleMin) and (endDate >= visibleMax)) then begin

      pen := CreatePen(PS_SOLID,0,clFuchsia);
      oldPen := SelectObject(handle,pen);

      topY := y + ChartFX1.TopGap;
      bottomY := y + ChartFX1.TopGap + visibleHeight;
      leftX := x + ChartFX1.LeftGap + trunc((visibleWidth * (startDate - trunc(visibleMin)) / visibleDays));
      leftX := max(leftX,x+ChartFX1.LeftGap);
      rightX := x + ChartFX1.LeftGap + trunc((visibleWidth * (endDate - trunc(visibleMin)) / visibleDays));
      rightX := min(rightX,w - ChartFX1.RightGap);
      if (startDate >= visibleMin) then begin
        moveToEx(handle,leftX,topY,nil);
        lineTo(handle,leftX,bottomY+1);
      end;
      if (endDate <= visibleMax) then begin
        moveToEx(handle,rightX,topY,nil);
        lineTo(handle,rightX,bottomY+1);
      end;
      moveToEx(handle,leftX,topY,nil);
      lineTo(handle,rightX+1,topY);
      moveToEx(handle,leftX,bottomY,nil);
      lineTo(handle,rightX+1,bottomY);
      selectObject(handle,oldPen);
      DeleteObject(pen);

      SetTextAlign(handle,TA_LEFT or TA_BOTTOM);
      txt := pchar(' Event '+inttostr(i+1));
      TextOutA(handle,rightX,bottomY,txt,length(txt));

      SetTextAlign(handle,TA_LEFT or TA_TOP);
      txt := pchar(' Event '+inttostr(i+1));
      TextOutA(handle,rightX,topY,txt,length(txt));

      eventDuration := (endDate - startDate) * SecsPerDay;

      observedPeak := 0.0;
      totalRDIIPeak := 0.0;
      rdiiPeak := 0.0;
      gwiSum := 0.0;
      rainDepth := 0.0;
      dwfSum := 0.0;
      observedSum := 0.0;
      totalRDIISum := 0.0;
      rdiiSum := 0.0;
//rm 2008-10-27

//showmessage('Start = ' + inttostr(Round((startDate - startDay) * segmentsPerDay)));
//showmessage('End = ' + inttostr(Round((endDate - startDay) * segmentsPerDay)));
//frmFeedbackWithMemo.feedbackMemo.Clear;
//    for j := trunc((startDate - startDay) * segmentsPerDay) to trunc((endDate - startDay) * segmentsPerDay) do begin
      for j := trunc((startDate * segmentsPerDay) - (startDay * segmentsPerDay))
      to trunc((endDate * segmentsPerDay) - (startDay * segmentsPerDay)) do begin
      //a little range-checking here:
//rm 2009-08-18 - it is possible that an event may be defined such that it starts before
// the flow data starts. The start of flow data controls the startDay
//        if j < high(rainfall) then begin
        if (j < high(rainfall)) and (j > -1) then begin
          testDate := StartDay + (j / segmentsPerDay);
          rainDepth := rainDepth + rainfall[j];
          rdiiSum := rdiiSum + rdii[j];
          totalRDIISum := totalRDIISum + rdiitotal[j];
          observedSum := observedSum + observedFlow[j];
          dwfSum := dwfSum + averageDWF[j];
          gwiSum := gwiSum + computedGWI[j];
          if (observedFlow[j] > observedPeak) then observedPeak := observedFlow[j];
          if (rdii[j] > rdiiPeak) then rdiiPeak := rdii[j];
          if (rdiitotal[j] > totalRDIIPeak) then totalRDIIPeak := rdiitotal[j];
//rm 2009-06-12
//frmFeedbackWithMemo.feedbackMemo.Lines.Add('Date = ' +
//          DateTimeToStr(StartDay + (j / segmentsPerDay)) + ' ' +
//          FloatToStr(rainfall[j]) + ' total = ' + FloatToStr(rainDepth));
        end else begin
          //ShowMessage('j = ' + IntToStr(j));
        end;
      end;
//frmFeedbackWithMemo.Show;
      rainVolume := (rainDepth / 12.0) * (area * 43560.0);  (* CFS *)
{      rdiiVolume := rdiiSum * eventDuration / ((endDate - startDate) * segmentsPerDay);  }
      rdiiVolume := rdiiSum / segmentsPerDay;
      //rm 2007-12-19 - prevent divide-by-zero for case where area = 0
      //iiDepth := rdiiVolume*conversionToMGD*12.0/(area*43560.0)*1000000.0/7.481/conversionToInches;
      if area > 0 then
        iiDepth := rdiiVolume*conversionToMGD*12.0/(area*43560.0)*1000000.0/7.481/conversionToInches
      else
        iiDepth := 0;
{      totalRDIIVolume := totalRDIISum * eventDuration / ((endDate - startDate) * segmentsPerDay);
      observedVolume := observedSum * eventDuration / ((endDate - startDate) * segmentsPerDay);
      dwfVolume := dwfSum * eventDuration / ((endDate - startDate) * segmentsPerDay);
      gwiVolume := gwiSum * eventDuration / ((endDate - startDate) * segmentsPerDay);
}
      dateTimeToString(dateHolder,'m-d-yyyy hh:mm',startDate);
      txt := pchar(' Start Date '+dateHolder);
      TextOutA(handle,rightX,topY+spacing,txt,length(txt));
{      dateTimeToString(dateHolder,'m-d-yyyy hh:mm',tailDate);
      txt := pchar(' Recession Date '+dateHolder);
      TextOutA(handle,rightX,topY+spacing*2,txt,length(txt));        }
      dateTimeToString(dateHolder,'m-d-yyyy hh:mm',endDate);
      txt := pchar(' End Date '+dateHolder);
      TextOutA(handle,rightX,topY+spacing*2,txt,length(txt));
      txt := pchar(' Duration: '+floatToStrF(eventDuration / 3600.0,ffFixed,10,2)+' hrs');
      TextOutA(handle,rightX,topY+spacing*3,txt,length(txt));

{      SetTextColor(handle,clAqua);
      txt := pchar(' DWF Flow Volume '+ floattostrF(dwfVolume,ffFixed,10,0)+ ' cf');
      TextOutA(handle,rightX,topY+50,txt,length(txt));
      txt := pchar(' DWF Flow Avg '+ floattostrF(dwfVolume/eventDuration,ffFixed,10,2)+ ' cfs');
      TextOutA(handle,rightX,topY+60,txt,length(txt));

      SetTextColor(handle,clBlue);
      txt := pchar(' GWI Flow Volume '+ floattostrF(gwiVolume,ffFixed,10,0)+ ' cf');
      TextOutA(handle,rightX,topY+70,txt,length(txt));
      txt := pchar(' GWI Flow Avg '+ floattostrF(gwiVolume/eventDuration,ffFixed,10,2)+ ' cfs');
      TextOutA(handle,rightX,topY+80,txt,length(txt));
      txt := pchar(' BWW Flow Volume '+ floattostrF(dwfVolume-gwiVolume,ffFixed,10,0)+ ' cf');
      TextOutA(handle,rightX,topY+90,txt,length(txt));
      txt := pchar(' BWW Flow Avg '+ floattostrF((dwfVolume-gwiVolume)/eventDuration,ffFixed,10,2)+ ' cfs');
      TextOutA(handle,rightX,topY+100,txt,length(txt));

      SetTextColor(handle,clLime);
      txt := pchar(' Observed Flow Volume '+ floattostrF(observedVolume,ffFixed,10,0)+ ' cf');
      TextOutA(handle,rightX,topY+110,txt,length(txt));
      txt := pchar(' Observed Flow Avg '+ floattostrF(observedVolume/eventDuration,ffFixed,10,2)+ ' cfs');
      TextOutA(handle,rightX,topY+120,txt,length(txt));
      txt := pchar(' Observed Flow Peak '+ floattostrF(observedPeak,ffFixed,10,2)+ ' cfs');
      TextOutA(handle,rightX,topY+130,txt,length(txt));
}

{      SetTextColor(handle,clBlue);
      txt := pchar(' Rain Depth '+ floattostr(rainDepth)+ ' in');
      TextOutA(handle,rightX,topY+140,txt,length(txt));
      txt := pchar(' Rain Volume '+ floattostrF(rainVolume,ffFixed,10,0)+ ' cf');
      TextOutA(handle,rightX,topY+150,txt,length(txt));

      SetTextColor(handle,clRed);
      txt := pchar(' Observed RDII Volume '+ floattostrF(rdiiVolume,ffFixed,10,0)+ ' cf');
      TextOutA(handle,rightX,topY+160,txt,length(txt));
      txt := pchar(' Observed RDII Avg '+ floattostrF(rdiiVolume/eventDuration,ffFixed,10,2)+ ' cfs');
      TextOutA(handle,rightX,topY+170,txt,length(txt));
      txt := pchar(' Observed RDII Peak '+ floattostrF(rdiiPeak,ffFixed,10,3)+ ' cfs');
      TextOutA(handle,rightX,topY+180,txt,length(txt));
}

{      if (rainVolume > 0.0)
        then RValue := rdiiVolume / rainVolume
        else RValue := 0.0;        }
//rm 2007-12-19 - a little error-checking here
//      if (rainVolume > 0.0)
RValue := 0.0;
if area > 0 then begin
      if (rainDepth > 0) and (rainVolume > 0.0)
        then RValue := iiDepth / rainDepth
      else RValue := 0.0;
      txt := pchar(' Observed R Value '+ floattostrF(RValue,ffFixed,8,4));
end else begin
      txt := pchar(' (Error - Flow Meter has area of 0.)');
end;
      TextOutA(handle,rightX,topY+spacing*5,txt,length(txt));
//rm 2008-09-03 - display rain depth
      txt := pchar(' Rain Depth '+ floattostrF(rainDepth,ffFixed,8,4)+ ' in');
      TextOutA(handle,rightX,topY+spacing*6,txt,length(txt));
      //rm 2009-10-30 - maybe something better than cf??
      //rm 2010-10-20 - yes
//      txt := pchar(' Rain Volume '+ floattostrF(rainVolume,ffFixed,10,0)+ ' cf');
      dVol := rainVolume;
      sVollabel := DatabaseModule.GetVollabel(flowUnitLabel, dVol);
      txt := pchar(' Rain Volume '+ floattostrF(dVol,ffFixed,10,3)+ sVollabel);
      TextOutA(handle,rightX,topY+spacing*7,txt,length(txt));
//rm 2008-09-03 - end
//rm 2010-10-15 - Total R / sewerlength
if sewerlength > 0 then begin
//      txt := pchar(' Observed R / LF Sewer '+ floattostrF((rainVolume * RValue) / sewerlength,ffFixed,10,0)+ ' cf/LF');
      dRDIIperLF := (rainVolume * RValue) / sewerlength;
      sRDIIperLFlabel:= DatabaseModule.GetRDIIperLFlabel(flowUnitLabel, dRDIIperLF);
      if dRDIIperLF < 1 then iprec := 2
      else if dRDIIperLF < 10 then iprec := 1
      else iprec := 0;
//rm 2010-11-23      txt := pchar(' Observed R / LF Sewer '+ floattostrF(dRDIIperLF,ffFixed,10,3)+ sRDIIperLFlabel);
      txt := pchar(' Observed RDII: '+ floattostrF(dRDIIperLF,ffFixed,10,iprec)+ sRDIIperLFlabel);
end else begin
//rm 2010-11-23      txt := pchar(' (Error - Flow Meter has sewer length of 0.)');
      txt := pchar(' Observed RDII: Did not calculate. No sewer length input.');
end;
      TextOutA(handle,rightX,topY+spacing*8,txt,length(txt));
{
      SetTextColor(handle,clYellow);
      txt := pchar(' Simulated RDII Volume '+ floattostrF(totalRDIIVolume,ffFixed,10,0)+ ' cf');
      TextOutA(handle,rightX,topY+200,txt,length(txt));
      txt := pchar(' Simulated RDII Avg '+ floattostrF(totalRDIIVolume/eventDuration,ffFixed,10,2)+ ' cfs');
      TextOutA(handle,rightX,topY+210,txt,length(txt));
      txt := pchar(' Simulated RDII Peak '+ floattostrF(totalRDIIPeak,ffFixed,10,2)+ ' cfs');
      TextOutA(handle,rightX,topY+220,txt,length(txt));
      if (rainVolume > 0.0)
        then RValue := totalRDIIVolume / rainVolume
        else RValue := 0.0;
      txt := pchar(' Simulated R Value '+ floattostrF(RValue,ffFixed,10,3));
      TextOutA(handle,rightX,topY+230,txt,length(txt));
}
    end;
  end;

  if (addingEventStartUp) then begin
    leftX := ChartFX1.LeftGap + 1 +
             trunc((visibleWidth * (newEventStartDate - trunc(visibleMin)) / visibleDays));
    rightX := ChartFX1.LeftGap + 1 +
              trunc((visibleWidth * (newEventEndDate - trunc(visibleMin)) / visibleDays));
{    tailX := ChartFX1.LeftGap + 1 +
               trunc((visibleWidth * (newEventTailDate - trunc(visibleMin)) / visibleDays));     }
    topY := ChartFX1.TopGap;
    bottomY := ChartFX1.TopGap+visibleHeight;
    pen := CreatePen(PS_DASH,0,clFuchsia);
    oldPen := SelectObject(handle,pen);
    moveToEx(handle,leftX,topY,nil);
    lineTo(handle,rightX,topY);
    moveToEx(handle,rightX,topY,nil);
    lineTo(handle,rightX,bottomY);
    moveToEx(handle,leftX,bottomY,nil);
    lineTo(handle,rightX,bottomY);
    moveToEx(handle,leftX,topY,nil);
    lineTo(handle,leftX,bottomY);
{    moveToEx(handle,tailX,topY,nil);
    lineTo(handle,tailX,bottomY);          }
    SelectObject(handle,oldPen);
    DeleteObject(pen);
  end;
  SelectObject(handle,oldFont);
  font.Free;
end;

procedure TfrmIIGraph.ChartFX1LButtonDown(Sender: TObject; x, y: Smallint;
  var nRes: Smallint);
var
  i, j, visibleWidth, pointerPixelsFromLeft, datePixelsFromLeft: integer;
  visibleHeight, pointerPixelsFromTop, valuePixelsFromTop: integer;
  datePercentFromLeft, valuePercentFromTop: real;
  minDate,maxDate, minValue, maxValue: double;
  xRange, yRange, date, value: real;
  event: TStormEvent;
  adjustment: TGWIAdjustment;
  potentialLimitingDate: TDateTime;
begin
  timerStart := DateTimeToTimeStamp(Time);
  movingGWIPoint := False;
  if (GWIAdj2.Checked) then begin
    visibleWidth := ChartVisibleWidth();
    pointerPixelsFromLeft  := x - ChartFX1.LeftGap;
    ChartFX1.Axis[AXIS_X].GetScrollView(minDate,maxDate);
    xRange := maxDate - minDate;

    visibleHeight := ChartVisibleHeight();
    pointerPixelsFromTop  := y - ChartFX1.TopGap;
    ChartFX1.Axis[AXIS_Y].GetScrollView(minValue,maxValue);
    yRange := maxValue - minValue;
//rm 2007-12-19 - prevent divide-by-zero
   if (xRange > 0) and (yRange > 0) then begin
    for i := 0 to gwiAdjustments.count - 1 do begin
      adjustment := gwiAdjustments.items[i];
      date := adjustment.Date;
      value := adjustment.Value;
      if (date >= minDate) and (date <= maxDate) then begin
        datePercentFromLeft := (date - minDate) / xRange;
        datePixelsFromLeft := trunc(datePercentFromLeft * visibleWidth);

        valuePercentFromTop := (maxValue - value) / yRange;
        valuePixelsFromTop := trunc(valuePercentFromTop * visibleHeight);

        if (abs(datePixelsFromLeft-pointerPixelsFromLeft) < 5) and
           (abs(valuePixelsFromTop-pointerPixelsFromTop) < 5) then begin
          movingGWIPoint := True;
          moveDateIndex := i;
        end;
      end;
    end;
   end;
  end;
  if (Events2.Checked) and (not movingGWIPoint) then begin
    visibleWidth := ChartVisibleWidth();
    pointerPixelsFromLeft  := x - ChartFX1.LeftGap;
    ChartFX1.Axis[AXIS_X].GetScrollView(minDate,maxDate);
    xRange := maxDate - minDate;
//rm 2007-12-19 - prevent divide-by-zero
   if (xRange > 0) then begin
    for i := 0 to events.Count - 1 do begin
      event := events.items[i];
      date := event.EndDate;
      if ((date >= minDate) and (date <= maxDate)) then begin
        datePercentFromLeft := (date - minDate) / xRange;
        datePixelsFromLeft := trunc(datePercentFromLeft * visibleWidth);
        if (abs(datePixelsFromLeft-pointerPixelsFromLeft) < 5) then begin
          movingEventEndDate := True;
          moveEventEndDateIndex := i;

          lowerLimit := TStormEvent(events.items[i]).startDate+(timestep/1440);
          upperLimit := endDay;
          for j := events.Count - 1 downto 0 do begin
            potentialLimitingDate := TStormEvent(events.items[j]).StartDate;
            if (potentialLimitingDate > date) then upperLimit := potentialLimitingDate;
          end;

        end;
      end;
    end;
    if (not movingEventEndDate) then begin
      for i := 0 to events.Count - 1 do begin
        event := events.items[i];
        date := event.StartDate;
        if ((date >= minDate) and (date <= maxDate)) then begin
          datePercentFromLeft := (date - minDate) / xRange;
          datePixelsFromLeft := trunc(datePercentFromLeft * visibleWidth);
          if (abs(datePixelsFromLeft-pointerPixelsFromLeft) < 5) then begin
            movingEventStartDate := True;
            moveEventStartDateIndex := i;

            upperLimit := TStormEvent(events.items[i]).endDate-(timestep/1440);
            lowerLimit := startDay;
            for j := 0 to events.Count - 1 do begin
              potentialLimitingDate := TStormEvent(events.items[j]).EndDate;
              if (potentialLimitingDate < date) then lowerLimit := potentialLimitingDate;
            end;

          end;
        end;
      end;
    end;
{    if ((not movingEventStartDate) and (not movingEventEndDate)) then begin
      for i := 0 to events.Count - 1 do begin
        event := events.items[i];
        date := event.TailDate;
        if ((date >= visibleMin) and (date <= visibleMax)) then begin
          datePercentFromLeft := (date - visibleMin) / xRange;
          datePixelsFromLeft := trunc(datePercentFromLeft * visibleWidth);
          if (abs(datePixelsFromLeft-pointerPixelsFromLeft) < 5) then begin
            movingEventTailDate := True;
            moveEventTailDateIndex := i;
          end;
        end;
      end;
    end;    }
    if ((not movingEventStartDate) and (not movingEventEndDate)) and
       (not movingEventTailDate) then begin
      originalMouseX := x;
      newEventStartDate := ChartDateAtX(originalMouseX);
      addingEventStartUp := True;
      { check that the user is not adding an event within an existing event }
      for i := 0 to events.Count - 1 do begin
        event := events.items[i];
        if ((newEventStartDate >= event.StartDate) and
            (newEventStartDate <= event.EndDate)) then addingEventStartUp := false;
      end;
      if (addingEventStartUp) then begin
        upperLimit := endDay;
        for i := events.Count - 1 downto 0 do begin
          date := TStormEvent(events.items[i]).StartDate;
          if (date > newEventStartDate) then upperLimit := date - (timestep/1440);
        end;
      end;
    end;
   end;
  end;
  nRes := 1;
end;

procedure TfrmIIGraph.ChartFX1LButtonUp(Sender: TObject; x, y: Smallint;
  var nRes: Smallint);
var
  newStartDate, newEndDate{, newTailDate}: real;
  event, previousEvent, nextEvent: TStormEvent;
  adjustment: TGWIAdjustment;
  sPatternName: string;
begin

timerEnd := DateTimeToTimeStamp(Time);
if (timerEnd.time - timerStart.time) > 200 then begin

  if (movingEventStartDate) then begin
    event := events.Items[moveEventStartDateIndex];
    if ((moveEventStartDateIndex > 0) and
        (event.StartDate = TStormEvent(events.Items[moveEventStartDateIndex-1]).EndDate)) then begin
      previousEvent := events.Items[moveEventStartDateIndex-1];
      previousEvent.EndDate := event.EndDate;
      DatabaseModule.RemoveEvent(event);
      DatabaseModule.UpdateEvent(previousEvent);
      events.Delete(moveEventStartDateIndex);
      event.Free;
    end
    else DatabaseModule.UpdateEvent(event);
    calculateSimulatedRDII;
    fillChart;
    movingEventStartDate := False;
    frmEventEdit.UpdateFromGraph;
  end;
  if (movingEventEndDate) then begin
    event := events.Items[moveEventEndDateIndex];
    if ((moveEventEndDateIndex < (events.Count - 1)) and
        (event.EndDate = TStormEvent(events.Items[moveEventEndDateIndex+1]).StartDate)) then begin
      nextEvent := events.Items[moveEventEndDateIndex+1];
      event.EndDate := nextEvent.EndDate;
      DatabaseModule.RemoveEvent(nextEvent);
      DatabaseModule.UpdateEvent(event);
      events.Delete(moveEventEndDateIndex+1);
      nextEvent.Free;
    end
    else DatabaseModule.UpdateEvent(event);
    calculateSimulatedRDII;
    fillChart;
    movingEventEndDate := False;
    frmEventEdit.UpdateFromGraph;
  end;
  if (addEventOnButtonRelease) then begin
    if (originalMouseX < x) then begin
      newStartDate := ChartDateAtX(originalMouseX);
      newEndDate := ChartDateAtX(x);
      if (newEndDate > upperLimit) then newEndDate := upperLimit;
      event := TStormEvent.Create(newStartDate,newEndDate,analysisID);
      DatabaseModule.AddEvent(analysisID,event);
      events.AddEvent(event);
      calculateSimulatedRDII;
      fillChart;
      frmEventEdit.UpdateFromGraph;
      //rm 2009-07-27 - add blank RTKPattern when adding event
        sPatternName := DatabaseModule.GetDefaultRTKPatternName(AnalysisID, newStartDate);
        DatabaseModule.CreateNewRTKPattern4Event(event, sPatternName);
        DatabaseModule.UpdateEvent(event);
      //
    end
    else invalidateGraph;
    addingEventStartUp := False;
    addEventOnButtonRelease := False;
  end;
  if (movingGWIPoint) then begin
    adjustment := gwiadjustments.Items[moveDateIndex];
    DatabaseModule.UpdateAdjustmentValueForGWIAdjustment(analysisID,adjustment);
    movingGWIPoint := False;
  end;
end
else begin
  movingEventStartDate := false;
  movingEventEndDate := false;
  addEventOnButtonRelease := false;
  addingEventStartUp := false;
end;
  nRes := 1;
end;

procedure TfrmIIGraph.ChartFX1MouseMoving(Sender: TObject; x, y: Smallint;
  var nRes: Smallint);
var
  newDate: real;
  event: TStormEvent;
  adjustment: TGWIAdjustment;
begin

timerEnd := DateTimeToTimeStamp(Time);
if (timerEnd.time - timerStart.time) > 200 then begin

  if (movingGWIPoint) then begin
    adjustment := gwiadjustments.Items[moveDateIndex];
    adjustment.Value := ChartValueAtY(y);
    dailygwiadj[adjustment.Date-startDay] := adjustment.Value;
    updateGWIAdjustmentDependentArraysAround(adjustment.Date);
    updateGWIAdjustmentDependentGraphSeries;
  end;
  if (movingEventEndDate) then begin
    newDate := ChartDateAtX(x);
    if (newDate < lowerLimit)
      then newDate := lowerLimit
      else if (newDate > upperLimit) then newDate := upperLimit;
    event := events.items[moveEventEndDateIndex];
    event.EndDate := newDate;
    invalidateGraph();
  end;
  if (movingEventStartDate) then begin
    newDate := ChartDateAtX(x);
    if (newDate < lowerLimit)
      then newDate := lowerLimit
      else if (newDate > upperLimit) then newDate := upperLimit;
    event := events.items[moveEventStartDateIndex];
    event.StartDate := newDate;
    invalidateGraph();
  end;
  if (addingEventStartup) then begin
    newEventEndDate := ChartDateAtX(x);
    if (newEventEndDate > upperLimit) then newEventEndDate := upperLimit;
{    newEventTailDate :=
      trunc((((newEventStartDate + newEventEndDate) * 0.5) * segmentsPerDay) + 0.5) / segmentsPerDay;  }
    addEventOnButtonRelease := true;
    invalidateGraph();
  end;

end;

end;

procedure TfrmIIGraph.calculateDailyGWIAdjustments();
var
  i, j, k, firstDayIndex, secondDayIndex, dow: integer;
  deltaValue, fraction: real;
  adjustment, nextAdjustment: TGWIAdjustment;
begin
  {reset all daily gwi adjustment array values to zero}
  for i := 0 to days do dailygwiadj[i] := 0.0;
  {fill in the daily gwi adjustment array with the user defined adjustments}
  for i := 0 to gwiadjustments.count - 1 do begin
    adjustment := gwiadjustments.items[i];
    dailygwiadj[adjustment.Date-startDay] := adjustment.Value;
  end;
  {fill in the daily gwi adjustment array where there are no user defined
   adjustments by interpolating between the user defined adjustments}
  if (gwiadjustments.count > 1) then begin
    for i := 0 to gwiadjustments.count - 2 do begin
      adjustment := gwiadjustments.items[i];
      nextAdjustment := gwiadjustments.items[i+1];
      firstDayIndex := adjustment.Date - startDay;
      secondDayIndex := nextAdjustment.Date - startDay;
      deltaValue := nextAdjustment.Value - adjustment.Value;
      for j := firstDayIndex to secondDayIndex do begin
      //rm 2007-10-22 - a little error-checking needed here:
        if secondDayIndex <> firstDayIndex then
          fraction := (j - firstDayIndex) / (secondDayIndex - firstDayIndex)
        else fraction := 0;
        dailygwiadj[j] := adjustment.Value + (deltaValue * fraction);
      end;
    end;
  end;
  {fill in the array that holds gwi adjustments for each data point by
   interpolating between the daily gwi adjustments.  Use these adjustments
   to alter the average DWF array by adding the gwi adjustment.  Account
   for weekend and weekend days slightly differently.}
  for i := 0 to days - 1 do begin
    dow := dayOfWeekIndex(startDay + i);
    for j := 0 to segmentsPerDay - 1 do begin
      k := (i * segmentsPerDay) + j;
      gwiadj[k] := dailygwiadj[i] + ((dailygwiadj[i+1]-dailygwiadj[i]) * j / segmentsPerDay);
      averageDWF[k] := diurnal[dow,j] + gwiadj[k];
    end;
  end;
end;

procedure TfrmIIGraph.calculateGWI();
var
  i, j, k: integer;
  minFlow: real;
begin
  { for each day, calculate the index (overall) that corresponds to the minimum
    DWF flow rate that day and store the index in the minimumIndicies array.}
  for i := 0 to days - 1 do begin
    minFlow := averageDWF[i*segmentsPerDay];
    for j := 1 to segmentsPerDay - 1 do begin   {start with 1, since the value at 0 is used to seed minimum}
      k := (i * segmentsPerDay) + j;
      if (averageDWF[k] < minFlow) then begin
        minimumIndicies[i] := k;
        minFlow := averageDWF[k];
      end;
    end;
  end;
  { fill in values up until the first minimum, with the value at that first minimum }
  for i := 0 to minimumIndicies[0] do
    computedGWI[i] := averageDWF[minimumIndicies[0]] - baseFlowRate;
  { fill in the values between all the minimums }
  try
  for i := 0 to days - 2 do begin
    for j := minimumIndicies[i] to minimumIndicies[i+1] do begin
      computedGWI[j] := averageDWF[minimumIndicies[i]] +
                        ((averageDWF[minimumIndicies[i+1]]-averageDWF[minimumIndicies[i]]) *
                        (j - minimumIndicies[i]) /
                        (minimumIndicies[i+1] - minimumIndicies[i])) -
                        baseFlowRate;
    end;
  end;
  except
  on E: Exception do begin

  end;

  end;
  { fill in values from the last minimum to the end, with the value at that last minimum }
  for i := minimumIndicies[days-1] to (segmentsPerDay * days) - 1 do
    computedGWI[i] := averageDWF[minimumIndicies[days-1]] - baseFlowRate;
end;

procedure TfrmIIGraph.calculateObservedRDII();
var
  i: integer;
begin
  for i := 0 to totalSegments - 1 do
    rdii[i] := observedflow[i] - averageDWF[i];
end;

procedure TfrmIIGraph.updateGWIAdjustmentDependentArraysAround(adjDate: integer);
var
  i, j, k, firstDayIndex, secondDayIndex, startDate, endDate, dow: integer;
  deltaValue, fraction, minFlow: real;
  adjustment, nextAdjustment: TGWIAdjustment;
  priorGWIIndex, nextGWIIndex: integer;
begin
  priorGWIIndex := 0;
  startDate := 0;
  for i := 0 to gwiadjustments.count - 1 do begin
    adjustment := gwiadjustments.items[i];
    if (adjustment.date < adjDate) then begin
      priorGWIIndex := i;
      startDate := adjustment.date;
    end;
  end;
  if (startDate = 0) then begin
    startDate := adjDate - 1;
    if (startDate < startDay) then startDate := startDay;
    if (gwiadjustments.count > 0) then
      for i := startDate to TGwiAdjustment(gwiadjustments[0]).date - 1 do dailygwiadj[i-startDay] := 0.0;
  end;

  nextGWIIndex := gwiadjustments.count - 1;
  endDate := 0;
  for i := gwiadjustments.count - 1 downto 0 do begin
    adjustment := gwiadjustments.items[i];
    if (adjustment.date > adjDate) then begin
      nextGWIIndex := i;
      endDate := adjustment.date;
    end;
  end;
  if (endDate = 0) then begin
    endDate := adjDate + 1;
    if (endDate > endDay) then endDate := endDay;
    if (gwiadjustments.count > 0) then
      for i := TGWIAdjustment(gwiadjustments[gwiadjustments.count-1]).date + 1 to endDate do dailygwiadj[i-startDay] := 0.0;
  end;
  for i := priorGWIIndex to nextGWIIndex - 1 do begin
    adjustment := gwiadjustments.items[i];
    nextAdjustment := gwiadjustments.items[i+1];
    firstDayIndex := adjustment.Date - startDay;
    secondDayIndex := nextAdjustment.Date - startDay;
    deltaValue := nextAdjustment.Value - adjustment.Value;
    //rm
    if (secondDayIndex <> firstDayIndex) then
    for j := firstDayIndex to secondDayIndex do begin
      fraction := (j - firstDayIndex) / (secondDayIndex - firstDayIndex);
      dailygwiadj[j] := adjustment.Value + (deltaValue * fraction);
    end;
  end;
  {calculate the gwi adjustments for all data points influence by the
   adjustment of interest }
  for i := startDate - startDay to (endDate - startDay) - 1 do begin
    dow := dayOfWeekIndex(startDay + i);
    for j := 0 to segmentsPerDay - 1 do begin
      k := (i * segmentsPerDay) + j;
      gwiadj[k] := dailygwiadj[i] + ((dailygwiadj[i+1]-dailygwiadj[i]) * j / segmentsPerDay);
      averageDWF[k] := diurnal[dow,j] + gwiadj[k];
    end;
  end;
  {calculate the rdii values for all the data points influenced by the
  adjustment of interest}
  for i := ((startDate - startDay) * segmentsPerDay) to
           ((endDate - startDay) * segmentsPerDay) - 1 do
    rdii[i] := observedflow[i] - averageDWF[i];
{--------------------------------------------------------------}

  { for each day, calculate the index (overall) that corresponds to the minimum
    DWF flow rate that day and store the index in the minimumIndicies array.}
  for i := startDate - startDay to (endDate - startDay) - 1 do begin
    minFlow := averageDWF[i*segmentsPerDay];
    for j := 1 to segmentsPerDay - 1 do begin   {start with 1, since the value at 0 is used to seed minimum}
      k := (i * segmentsPerDay) + j;
      if (averageDWF[k] < minFlow) then begin
        minimumIndicies[i] := k;
        minFlow := averageDWF[k];
      end;
    end;
  end;

  { fill in values up until the first minimum, with the value at that first minimum }
  { this needs to be done only when the first day of the flow data is influenced. }
  { right now it happens whenever any gwi point is changed }
  for i := 0 to minimumIndicies[0] do
    computedGWI[i] := averageDWF[minimumIndicies[0]] - baseFlowRate;
  { fill in the values between all the minimums }
  //rm 2008-10-06 - Bombs here:
  for i := startDate - startDay to (endDate - startDay) - 1 do begin
    for j := minimumIndicies[i] to minimumIndicies[i+1] do begin
  //rm 2008-10-06 - somehow the two minimumIndicies can be the same?
    //rm - avoid the divide-by-zero case:
if minimumIndicies[i] = minimumIndicies[i +1] then
      computedGWI[j] := averageDWF[minimumIndicies[i]] - baseFlowRate
else
try
      computedGWI[j] := averageDWF[minimumIndicies[i]] +
                        ((averageDWF[minimumIndicies[i+1]]-averageDWF[minimumIndicies[i]]) *
                        (j - minimumIndicies[i]) /
                        (minimumIndicies[i+1] - minimumIndicies[i])) -
                        baseFlowRate;

  except
      on E: Exception do begin

      //showmessage('ERROR: i = ' + inttostr(i) + ', j = ' + inttostr(j) + '/' + inttostr(k));
      //showmessage('ERROR: minimumIndicies[i] = ' + Floattostr(minimumIndicies[i]));
      //showmessage('ERROR: minimumIndicies[i+1] = ' + Floattostr(minimumIndicies[i+1]));
      //showmessage('ERROR: averageDWF[minimumIndicies[i]] = ' + Floattostr(averageDWF[minimumIndicies[i]]));
      //showmessage('ERROR: averageDWF[minimumIndicies[i+1]] ' + Floattostr(averageDWF[minimumIndicies[i+1]]));

      end;

end;
     end;
   end;
  { fill in values from the last minimum to the end, with the value at that last minimum }
  { this needs to be done only when the last day of the flow data is influenced. }
  { right now it happens whenever any gwi point is changed }
  for i := minimumIndicies[days-1] to (segmentsPerDay * days) - 1 do
    computedGWI[i] := averageDWF[minimumIndicies[days-1]] - baseFlowRate;

end;



procedure TfrmIIGraph.calculateSimulatedRDII();
//re-jigged by rm on 2007-11-01
//set abstraction calculations to match SWMM5
//challenge was to set initial abstraction used term only once at start of a defined event
//and then to set initial abstractiion used back to analysis default at end of defined event
//You can't just set all parameters to analysis defaults and then check to see if you are
// in an event because then you would be setting the initial term at every timestep
//So you have to use some state variables that let you know
//  a) exactly when you have entered an event, and
//  b) exactly when you have exited and are no longer in any event
//
//In a) you set abstraction_used to the event initial value
//  (unless current abstraction_used is higher)
//In b) you set abstraction_used to the analysis default value
//  (unless current abstraction_used is higher)
//
//rm 2010-09-29 rejigged again to accommodate initial abstraction terms for each of the 3 RTK sets
const
  conversionFromAcreInchesPerHourToMGD = (43560.0*7.481*24.0)/(12.0*1000000.0);
var
  i, j, m, n, index, timestepsPerHour, oldEventNum, inEventNum, lastEventNum : integer;
  day, qpeak, flow, rain, {prevRainDate, abstraction,} {absmax, absrecover,} excess: double;
  //rm 2007-11-01 - Fix for the initial abstraction issue
  //absmax, absrecover,abstraction_available, abstraction_used: double;
  event: TStormEvent;
  R,T,K : array[0..2] of real;
  //rm 2010-09-29
  AM, AR, AI, AA, AU : array[0..2] of double; //Abstraction Max, Recover, Init, and Used
{  F: textfile;   }
dummy: double;
begin
{  assignfile(f,'e:\wincalc.txt');
  rewrite(F);  }

  { DETERMINE SIMULATED RDII }
  for i := 0 to totalSegments - 1 do begin
    for j := 0 to 2 do begin
      rdiiCurve[j,i] := 0.0;
    end;
    //rm 2010-10-19
    IACurve[i] := 0.0;
  end;
  timestepsPerHour := 60 div timestep;
//rm 2007-11-01
//  abstraction := iabstraction;
//  prevRainDate := 0;
  for n := 0 to 2 do begin
    R[n] := defaultR[n];
    T[n] := defaultT[n];
    K[n] := defaultK[n];
  end;
  //rm 2010-09-29 - REFACTORing Initial Abstraction Terms
  // absmax => AM[0..2]
  // absrecover => AR[0..2]
  // iabstraction => AI[0..2]
  // abstraction_available => AA[0..2]
  // abstraction_used => AU[0..2]
  {
  absmax := kmax;             //default analysis kmax
  absrecover := krecover;     //default analysis krecover
  abstraction_available := absmax - iabstraction;    //default analysis iabstraction
  abstraction_available := max(abstraction_available, 0.0);
  abstraction_used := absmax - abstraction_available;
  }
  AM[0] := kmax;         //default read from Analysis table
  AR[0] := krecover;     //default read from Analysis table
  AI[0] := iabstraction; //default read from Analysis table
  AM[1] := kMax2;
  AR[1] := kRec2;
  AI[1] := kIni2;
  AM[2] := kMax3;
  AR[2] := kRec3;
  AI[2] := kIni3;
//rm 2010-10-15 - set au to ai
  AU[0] := iabstraction; //0;
  AU[1] := kIni2; //0;
  AU[2] := kIni3; //0;

  oldEventNum := -1; //set to current eventnum upon entering an event
  inEventNum := -1; //set back to -1 upon leaving an event
  lastEventNum := inEventNum;  //tracks changes in inEventNum
  for i := 0 to days - 1 do begin
    for j := 0 to segmentsPerDay - 1 do begin
      index := (i * segmentsPerDay) + j;
//rm 2007-11-01 Moved "for m" block up above "if (rain > 0)" block due to initial abstraction terms
      day := (startDay + i) + (j / segmentsPerDay);
      { determine the RTK values at this instant }
      inEventNum := -1;  //reset inEventNum, but not lastEventNum
      for m := 0 to events.count - 1 do begin
        event := events.Items[m];
        if ((day >= event.startDate) and (day <= event.endDate)) then begin
        //we are in an event - update parameters
          inEventNum := m;
          lastEventNum := inEventNum;
          //only need to set these once - first time we are in event
          //need to do this only once or initial depth will get reset every time
          if m > oldEventNum then begin //first time to this event
            oldEventNum := m;
            if ((event.R[0] > 0.0) or (event.R[1] > 0.0) or (event.R[2] > 0.0)) then begin
            //if any R is > 0, then assume user has assigned parameters for this event
              for n := 0 to 2 do begin
                R[n] := event.R[n];
                T[n] := event.T[n];
                K[n] := event.K[n];
              end;
              {
              absmax := event.AM;
              absrecover := event.AR;
              abstraction_used := max(abstraction_used, event.AI);
              }
              for n := 0 to 2 do  begin
                AM[n] := event.AM[n+1];
                AR[n] := event.AR[n+1];
                AI[n] := event.AI[n+1];
                //rm 2010-10-15 - set initial abstraction used to event-defined ia used
                //AU[n] := Max(AU[n], AI[n]);
                AU[n] := AI[n];
              end;
            end else begin
            //if all Rs are 0, then perhaps user has not assigned parameters
            //for this event - set parameters to analysis defaults
              for n := 0 to 2 do begin
                R[n] := defaultR[n];
                T[n] := defaultT[n];
                K[n] := defaultK[n];
              end;
              {
              absmax := kmax;             //default analysis kmax
              absrecover := krecover;     //default analysis krecover
              abstraction_used := max(abstraction_used, iabstraction);
              }
              AM[0] := kmax;         //default read from Analysis table
              AR[0] := krecover;     //default read from Analysis table
              AI[0] := iabstraction; //default read from Analysis table
              //rm 2010-10-15 - set initial abstraction used to analysis-defined ia used
              //AU[0] := Max(AU[0], AI[0]);
              //rm 2010-10-15a - no - not if user has not set event RTKs etc. - if using default do not reset AU
              //AU[0] := AI[0];
              AM[1] := kMax2;
              AR[1] := kRec2;
              AI[1] := kIni2;
              //rm 2010-10-15 - set initial abstraction used to analysis-defined ia used
              //AU[1] := Max(AU[1], AI[1]);
              //rm 2010-10-15a - no - not if user has not set event RTKs etc. - if using default do not reset AU
              //AU[1] := AI[1];
              AM[2] := kMax3;
              AR[2] := kRec3;
              AI[2] := kIni3;
              //rm 2010-10-15 - set initial abstraction used to analysis-defined ia used
              //AU[2] := Max(AU[2], AI[2]);
              //rm 2010-10-15a - no - not if user has not set event RTKs etc. - if using default do not reset AU
              //AU[2] := AI[2];
            end;
            {
            abstraction_available := absmax - abstraction_used;
            abstraction_available := max(abstraction_available, 0.0);
            abstraction_used := absmax - abstraction_available;
            }
            for n := 0 to 2 do begin
              AA[n] := AM[n] - AU[n];
              AA[n] := Max(AA[n], 0.0);
              AU[n] := AM[n] - AA[n];
            end;
          end; //if m > oldEventNum
          break; //don't need to check any more events -can't be in more than one
        end; //if ((day >= event.startDate) and (day <= event.endDate))
      end; //for m := 0 to events.count - 1
      if lastEventNum > inEventNum then begin //we just left an event and are no longer in one
      //inEventNum is -1 if not in an event
      //lastEventNum is still the number of the last event if we just left an event
        lastEventNum := inEventNum;
        //for this non-event - set parameters to analysis defaults
        for n := 0 to 2 do begin
          R[n] := defaultR[n];
          T[n] := defaultT[n];
          K[n] := defaultK[n];
        end;
        {
        absmax := kmax;             //default analysis kmax
        absrecover := krecover;     //default analysis krecover
        abstraction_used := max(abstraction_used, iabstraction);
        abstraction_available := absmax - abstraction_used;
        abstraction_available := max(abstraction_available, 0.0);
        abstraction_used := absmax - abstraction_available;
        }
              {
              absmax := kmax;             //default analysis kmax
              absrecover := krecover;     //default analysis krecover
              abstraction_used := max(abstraction_used, iabstraction);
              }
              //rm 2010-10-15 - upon leaving an event, set AM (Dmax) and AR (Drec), but not AI (Do) or AU
              AM[0] := kmax;         //default read from Analysis table
              AR[0] := krecover;     //default read from Analysis table
              AI[0] := iabstraction; //default read from Analysis table
              AM[1] := kMax2;
              AR[1] := kRec2;
              AI[1] := kIni2;
              AM[2] := kMax3;
              AR[2] := kRec3;
              AI[2] := kIni3;
              //rm 2010-10-15 - do not touch AU
              {
              for n := 0 to 2 do begin
                AU[n] := Max(AU[n], AI[n]);
                AA[n] := AM[n] - AU[n];
                AA[n] := Max(AA[n], 0.0);
                AU[n] := AM[n] - AA[n];
              end;
              }
      end;
      //done setting parameters - now process the rain
      rain := rainfall[index];
//rm 2007-11-01
//ia = UnitHyd[j].ia[m][IA_MAX] - UHData[j].iaUsed;
//ia = MAX(ia, 0.0);
      {
      abstraction_available := absmax - abstraction_used;
      abstraction_available := max(abstraction_available, 0.0);
      }
              for n := 0 to 2 do begin
                AA[n] := AM[n] - AU[n];
                AA[n] := Max(AA[n], 0.0);
                AU[n] := AM[n] - AA[n];
              end;
//rm 2010-09-29 - need to move the "m:=0..2" loop up here
  for m := 0 to 2 do begin
    if ((R[m] > 0.0) and (T[m] > 0.0)) then begin

      if (rain > 0) then begin
//        day := (startDay + i) + (j / segmentsPerDay);
//        if (prevRainDate = 0) then prevRainDate := day;
        {calculate each composite RDII curve at this instant}
//        abstraction := min(absmax,(abstraction+absrecover*(day-prevRainDate-timestep/(24.0*60.0))));
//        abstraction := max(abstraction,0.0);
//        prevRainDate := day;
//        excess := max(rain-abstraction,0.0);
//        abstraction := abstraction-(rain-excess);
// --- reduce rain depth by unused IA
//netRainDepth = rainDepth - ia;
//rm 2010-09-29        excess := rain - abstraction_available;
        excess := rain - AA[m]; //abstraction_available;
        excess := max(excess, 0.0);
//netRainDepth = MAX(netRainDepth, 0.0);
// --- update amount of IA used up
//ia = rainDepth - netRainDepth;
//rm 2010-09-29        abstraction_available := rain - excess; //additional volume added this timestep
        AA[m] := rain - excess; //additional volume added this timestep
//UHData[j].iaUsed += ia;
//rm 2010-09-29        abstraction_used := abstraction_used + abstraction_available;
        AU[m] := AU[m] + AA[m]; //abstraction_available;
//rm 2010-10-15 - left this bad boy out: - 2010-10-19 - NOT NEEDED
        AU[m] := min(AU[m], AM[m]);
//rm 2010-10-19
IACurve[index] := IACurve[index] + AA[m] * (R[m] / (R[0] + R[1] + R[2]));
//        abstraction_used := abstraction_used + rain - excess;
//        abstraction_used := min(abstraction_used, absmax);
{        writeln(F,'***  ',floattostrF(prevRainDate,ffFixed,15,5),'   '
                         ,floattostrF(abstraction,ffFixed,15,5),'   '
                         ,floattostrF(excess,ffFixed,15,5));   }
        if (excess > 0.0) then begin
//rm 2010-09-29          for m := 0 to 2 do begin
//rm 2010-09-29            if ((R[m] > 0.0) and (T[m] > 0.0)) then begin
              qpeak := R[m]*2.0*area/(T[m]*(1+K[m]))
                       *conversionFromAcreInchesPerHourToMGD
                       /conversionToMGD
                       *conversionToInches;
                       //rm 2009-10-29 Note that area has been converted to acres already if necessary
              for n := 0 to trunc(T[m] * (K[m] + 1) * timestepsPerHour) do begin
                if (index + n < totalSegments) then begin
                  if (n <= T[m] * timestepsPerHour)
                    then flow := (n / (T[m] * timestepsPerHour)) * qpeak * excess
                    else flow := (1.0 - ((n-(T[m]*timestepsPerHour) )/(K[m]*T[m]*timestepsPerHour))) * qpeak * excess;
                  rdiiCurve[m,index+n] := rdiiCurve[m,index+n] + flow;
                end;
              end;
//rm 2010-09-29            end;
//rm 2010-09-29          end;
        end; {if (excess > 0.0)}
      end {if (rain > 0)} else begin //no rain - recover some abstraction volume
// --- recover a portion of the IA already used
//UHData[j].iaUsed -= dt / 86400. * UnitHyd[j].ia[m][IA_REC];
//UHData[j].iaUsed = MAX(UHData[j].iaUsed, 0.0);
//rm 2010-09-29        abstraction_used := abstraction_used - ((timestep/1440.0) * absrecover);
        AU[m] := AU[m] - ((timestep/1440.0) * AR[m]);   //timestep in minutes Drec in inches/day
//rm 2010-09-29        abstraction_used := max(abstraction_used, 0.0);
        AU[m] := max(AU[m], 0.0);
      end; {}
    end; {if ((R[m] > 0.0) and (T[m] > 0.0))}
  end; {for m := 0 to 2}
end; {for j := 0 to segmentsPerDay - 1}
end; {for i := 0 to days - 1}
  for i := 0 to totalSegments - 1 do  begin
    rdiiTotal[i] := rdiiCurve[0,i] + rdiiCurve[1,i] + rdiiCurve[2,i];
    //rm 2010-10-19
    //no - factoring in ratio of R[m]/RT - IACurve[i] := IACurve[i] / 3.0;
  end;
{  for i := 0 to totalSegments - 1 do begin
    day := startDay + (i / segmentsPerDay);
    writeln(F,floattostrF(day,ffFixed,15,5),'   ',
              floattostrF(rdiiCurve[0,i],ffFixed,15,5),'   ',
              floattostrF(rdiiCurve[1,i],ffFixed,15,5),'   ',
              floattostrF(rdiiCurve[2,i],ffFixed,15,5));
  end;       }
{  closefile(F);  }

//rm 2010-10-19

end;

procedure TfrmIIGraph.fillchart();
var
  dataIndex, graphIndex, startIndex, endIndex: integer;
  commonXValue: double;
begin
  startIndex := trunc(ChartFX1.Axis[AXIS_X].Min - startDay) * segmentsPerDay;
  endIndex := (trunc(ChartFX1.Axis[AXIS_X].Max - startDay) * segmentsPerDay) - 1;
  with ChartFX1 do begin
    Axis[AXIS_Y].ResetScale;
//rm 2010-10-19    OpenDataEx(COD_VALUES,11,endIndex-startIndex+1);
//rm 2010-10-19    OpenDataEx(COD_XVALUES,11,endIndex-startIndex+1);
    OpenDataEx(COD_VALUES,12,endIndex-startIndex+1);
    OpenDataEx(COD_XVALUES,12,endIndex-startIndex+1);
    for dataIndex := startIndex to endIndex do begin
      graphIndex := dataIndex - startIndex;
      commonXValue := startDay + (dataIndex / segmentsPerDay);
      Series[0].XValue[graphIndex] := commonXValue;
      Series[0].YValue[graphIndex] := averageDWF[dataIndex];
      Series[1].XValue[graphIndex] := commonXValue;
      Series[1].YValue[graphIndex] := observedFlow[dataIndex];
      Series[2].XValue[graphIndex] := commonXValue;
      Series[2].YValue[graphIndex] := rdii[dataIndex];
      Series[3].XValue[graphIndex] := commonXValue;
      Series[3].YValue[graphIndex] := rainfall[dataIndex];
      Series[4].XValue[graphIndex] := commonXValue;
      Series[4].YValue[graphIndex] := gwiadj[dataIndex];
      Series[5].XValue[graphIndex] := commonXValue;
      //Series[5].YValue[graphIndex] := GWIPct * computedGWI[dataIndex];
      Series[5].YValue[graphIndex] := computedGWI[dataIndex];
      Series[6].XValue[graphIndex] := commonXValue;
      Series[6].YValue[graphIndex] := rdiiCurve[0,dataIndex];
      Series[7].XValue[graphIndex] := commonXValue;
      Series[7].YValue[graphIndex] := rdiiCurve[1,dataIndex];
      Series[8].XValue[graphIndex] := commonXValue;
      Series[8].YValue[graphIndex] := rdiiCurve[2,dataIndex];
      Series[9].XValue[graphIndex] := commonXValue;
      Series[9].YValue[graphIndex] := rdiiTotal[dataIndex];

      Series[10].XValue[graphIndex] := commonXValue;
      Series[10].YValue[graphIndex] := (GWIPct / 100.0) * computedGWI[dataIndex];

      //rm 2010-10-19
      Series[11].Xvalue[graphIndex] := commonXValue;
      Series[11].Yvalue[graphIndex] := IACurve[dataIndex];

    end;
    //rm 2008-02-29 - catch error when no data
    try
      CloseData(COD_VALUES);
    except
      on E: Exception do begin

      end;
    end;
    try
      CloseData(COD_XVALUES);
    except
      on E: Exception do begin

      end;
    end;
  end;
  ChartFX1.Axis[AXIS_Y].Decimals := GetDecimals;
  SetColors;
end;

procedure TfrmIIGraph.updateGWIAdjustmentDependentGraphSeries();
var
  dataIndex, graphIndex, startIndex, endIndex: integer;
begin
  startIndex := trunc(ChartFX1.Axis[AXIS_X].Min - startDay) * segmentsPerDay;
  endIndex := (trunc(ChartFX1.Axis[AXIS_X].Max - startDay) * segmentsPerDay) - 1;
  with ChartFX1 do begin
    OpenDataEx(COD_VALUES,COD_UNCHANGE,COD_UNCHANGE);
    for dataIndex := startIndex to endIndex do begin
      graphIndex := dataIndex - startIndex;
      Series[0].YValue[graphIndex] := averageDWF[dataIndex];
      Series[2].YValue[graphIndex] := rdii[dataIndex];
      Series[4].YValue[graphIndex] := gwiadj[dataIndex];
      Series[5].YValue[graphIndex] := computedGWI[dataIndex];
      Series[10].YValue[graphIndex] := (GWIPct / 100.0) * computedGWI[dataIndex];
    end;
    CloseData(COD_VALUES)
  end;
end;

procedure TfrmIIGraph.ChartFX1LButtonDblClk(Sender: TObject; x, y,
  nSerie: Smallint; nPoint: integer; var nRes: Smallint);
type
  integerPointer = ^integer;
  realPointer = ^real;
var
  visibleWidth, visibleHeight: integer;
  pointerPixelsFromLeft, pointerPixelsFromTop: integer;
  datePixelsFromLeft, valuePixelsFromTop: integer;
  datePercentFromLeft, valuePercentFromTop: real;
  minDate, maxDate, minValue, maxValue: double;
  xRange, yRange: real;
  date, value: real;
  i, adjustmentToRemoveIndex: integer;
  removeDate, addDate: boolean;
  dateToAdd : integer;
  insertionIndex: integer;
  eventToRemove, event: TStormEvent;
  adjustment, previousAdjustment, nextAdjustment, adjustmentToRemove: TGWIAdjustment;
  insertionValue: real;
begin
  movingGWIPoint := False;
  doubleClicked := True;
  addDate := False;
  removeDate := False;
  if (GWIAdj2.Checked) then begin
    visibleWidth := ChartVisibleWidth();
    pointerPixelsFromLeft  := x - ChartFX1.LeftGap;
    ChartFX1.Axis[AXIS_X].GetScrollView(minDate,maxDate);
    xRange := maxDate - minDate;

    visibleHeight := ChartVisibleHeight();
    pointerPixelsFromTop  := y - ChartFX1.TopGap;
    ChartFX1.Axis[AXIS_Y].GetScrollView(minValue,maxValue);
    yRange := maxValue - minValue;

    adjustmentToRemoveIndex := -1;
    for i := 0 to gwiadjustments.count - 1 do begin
      adjustment := gwiAdjustments[i];
      date := adjustment.Date;
      value := adjustment.Value;

      if ((date >= minDate) and (date <= maxDate)) then begin
        datePercentFromLeft := (date - minDate) / xRange;
        datePixelsFromLeft := trunc(datePercentFromLeft * visibleWidth);

        valuePercentFromTop := (maxValue - value) / yRange;
        valuePixelsFromTop := trunc(valuePercentFromTop * visibleHeight);
        if ((abs(datePixelsFromLeft-pointerPixelsFromLeft) < 5) and
            (abs(valuePixelsFromTop-pointerPixelsFromTop) < 5)) then begin
          adjustmentToRemoveIndex := i;
          removeDate := True;
        end;
      end;
    end;
    if (removeDate) then begin
      adjustmentToRemove := gwiAdjustments[adjustmentToRemoveIndex];
      DatabaseModule.RemoveGWIAdjustment(analysisID,adjustmentToRemove);
      gwiAdjustments.Remove(adjustmentToRemove);
      dailygwiadj[adjustmentToRemove.Date-startDay] := 0.0;
      updateGWIAdjustmentDependentArraysAround(adjustmentToRemove.date);
      adjustmentToRemove.Free;
      updateGWIAdjustmentDependentGraphSeries();
    end
    else begin   {let's try adding a point if one is not already there}
      dateToAdd := 0;
      for i := trunc(minDate) to trunc(maxDate) do begin
        datePercentFromLeft := (i - minDate) / xRange;
        datePixelsFromLeft := trunc(datePercentFromLeft * visibleWidth);
        if (abs(datePixelsFromLeft-pointerPixelsFromLeft) < 5) then begin
          addDate := True;
          dateToAdd := i;
        end;
      end;
      for i := 0 to gwiadjustments.count - 1 do begin
        if (TGWIAdjustment(gwiAdjustments.Items[i]).Date = dateToAdd) then addDate := False;
      end;
      if (addDate) then begin
        adjustment := TGWIAdjustment.Create(dateToAdd,0.0);
        gwiAdjustments.AddAdjustment(adjustment);
        insertionIndex := gwiAdjustments.IndexOf(adjustment);
        if ((insertionIndex > 0) and (insertionIndex < gwiadjustments.count - 1)) then begin
          previousAdjustment := gwiAdjustments.items[insertionIndex-1];
          nextAdjustment := gwiAdjustments.items[insertionIndex+1];
          insertionValue := previousAdjustment.Value +
                            ((nextAdjustment.Value - previousAdjustment.Value) *
                             (dateToAdd - previousAdjustment.Date) /
                             (nextAdjustment.Date - previousAdjustment.Date));
          adjustment.Value := insertionValue;
        end;
        DatabaseModule.AddGWIAdjustment(analysisID,adjustment);
        updateGWIAdjustmentDependentArraysAround(adjustment.date);
        updateGWIAdjustmentDependentGraphSeries();
      end;
    end;
  end;

  if ((Events2.Checked) and ((not removeDate) and (not addDate))) then begin
    visibleWidth := ChartVisibleWidth();
    pointerPixelsFromLeft  := x - ChartFX1.LeftGap;
    ChartFX1.Axis[AXIS_X].GetScrollView(minDate,maxDate);
    xRange := maxDate - minDate;
    eventToRemove := nil;
    for i := 0 to events.Count - 1 do begin
      event := events.items[i];
      date := event.StartDate;
      if ((date >= minDate) and (date <= maxDate)) then begin
        datePercentFromLeft := (date - minDate) / xRange;
        datePixelsFromLeft := trunc(datePercentFromLeft * visibleWidth);
        if (abs(datePixelsFromLeft-pointerPixelsFromLeft) < 5) then begin
          eventToRemove := events.items[i];
        end;
      end;
    end;
    for i := 0 to events.Count - 1 do begin
      event := events.items[i];
      date := event.EndDate;
      if ((date >= minDate) and (date <= maxDate)) then begin
        datePercentFromLeft := (date - minDate) / xRange;
        datePixelsFromLeft := trunc(datePercentFromLeft * visibleWidth);
        if (abs(datePixelsFromLeft-pointerPixelsFromLeft) < 5) then begin
          eventToRemove := events.items[i];
        end;
      end;
    end;
    if (eventToRemove <> nil) then begin
      DatabaseModule.RemoveEvent(eventToRemove);
      events.remove(eventToRemove);
      eventToRemove.Free;
      invalidateGraph();
      frmEventEdit.UpdateFromGraph;
      //rm 2010-10-15 - must refresh graph data too - as initial abstraction must be reset
      //invalidateGraph();
      calculateSimulatedRDII;
      fillChart;
      //rm
    end;
  end;
  nRes := 1;
end;

function TfrmIIGraph.ChartVisibleWidth: integer;
begin
 result := ChartFX1.Width - ChartFX1.LeftGap - ChartFX1.RightGap - 4;
end;

function TfrmIIGraph.ChartVisibleHeight: integer;
begin
  result := ChartFX1.Height - ChartFX1.TopGap - ChartFX1.BottomGap - 4;
  if ((ChartFX1.MenuBarObj.Visible) and (ChartFX1.MenuBarObj.Docked = 256))
    then result := result - 27;
 {   if ((ChartFX1.Axis[AXIS_X].Max - ChartFX1.Axis[AXIS_X].Min) * ChartFX1.Axis[AXIS_X].PixPerUnit)
      >= (ChartFX1.Width - ChartFX1.LeftGap - ChartFX1.RightGap) then result := result - 16;     }
end;

function TfrmIIGraph.ChartDateAtX(x: integer): real;
var
  visibleWidth, pixelsFromLeft: integer;
  xMin, xMax: double;
  xRange, fractionFromLeft: real;
begin
  visibleWidth := ChartVisibleWidth();
  ChartFX1.Axis[AXIS_X].GetScrollView(xMin,xMax);
  xRange := xMax - xMin;
  pixelsFromLeft := x - ChartFX1.LeftGap;
  fractionFromLeft := pixelsFromLeft / visibleWidth;
  result := xMin + (trunc((xRange * fractionFromLeft) * segmentsPerDay)) / segmentsPerDay;
end;

function TfrmIIGraph.ChartValueAtY(y: integer): real;
var
  visibleHeight: integer;
  pixelsFromTop: integer;
  fractionFromTop: real;
  yMin, yMax: double;
  yRange: real;
begin
  visibleHeight := ChartVisibleHeight();
  pixelsFromTop := y - ChartFX1.TopGap;
  fractionFromTop := pixelsFromTop / visibleHeight;
  ChartFX1.Axis[AXIS_Y].GetScrollView(yMin,yMax);
  yRange := yMax - yMin;
  result := yMax - (yRange * fractionFromTop);
end;

procedure TfrmIIGraph.invalidateGraph();
begin
  ChartFX1.OpenDataEx(COD_CONSTANTS,1,0);
  ChartFX1.CloseData(COD_CONSTANTS);
end;

procedure TfrmIIGraph.ChartFX1RButtonUp(Sender: TObject; x, y: Smallint;
  var nRes: Smallint);
var
  i, visibleWidth, pointerPixelsFromLeft, datePixelsFromLeft: integer;
  minDate, maxDate, date: double;
  datePercentFromLeft, xRange: real;
  event: TStormEvent;
begin
  if (Events2.Checked) then begin
    visibleWidth := ChartVisibleWidth();
    pointerPixelsFromLeft  := x - ChartFX1.LeftGap;
    ChartFX1.Axis[AXIS_X].GetScrollView(minDate,maxDate);
    xRange := maxDate - minDate;
    for i := 0 to events.Count - 1 do begin
      event := events.items[i];
      date := event.EndDate;
      if ((date >= minDate) and (date <= maxDate)) then begin
        datePercentFromLeft := (date - minDate) / xRange;
        datePixelsFromLeft := trunc(datePercentFromLeft * visibleWidth);
        if (abs(datePixelsFromLeft-pointerPixelsFromLeft) < 5) then begin
          frmEventEdit.OpenDialog(events,i,analysisID);
//rm 2009-07-22
    frmEventEdit.Show;
          nRes := 1;
        end;
      end;
      date := event.StartDate;
      if ((date >= minDate) and (date <= maxDate)) then begin
        datePercentFromLeft := (date - minDate) / xRange;
        datePixelsFromLeft := trunc(datePercentFromLeft * visibleWidth);
        if (abs(datePixelsFromLeft-pointerPixelsFromLeft) < 5) then begin
          frmEventEdit.OpenDialog(events,i,analysisID);
//rm 2009-07-22
    frmEventEdit.Show;
          nRes := 1;
        end;
      end;
    end;
  end;
end;

procedure TfrmIIGraph.SetImageIndex(Sender: TObject);
var mi: TMenuItem;
begin
  mi := TMenuItem(Sender);
  if mi.Checked  then begin
    mi.ImageIndex := mi.Tag * 2 - 1;
  end else begin
    mi.ImageIndex := mi.Tag * 2;
  end;
end;

procedure TfrmIIGraph.AverageDWF2Click(Sender: TObject);
begin
  AverageDWF2.Checked := not AverageDWF2.Checked;
  ChartFX1.Series[0].Visible := AverageDWF2.Checked;
  //rm 2010-04-23
  SetImageIndex(Sender);
end;

procedure TfrmIIGraph.ObservedFlow2Click(Sender: TObject);
begin
  ObservedFlow2.Checked := not ObservedFlow2.Checked;
  ChartFX1.Series[1].Visible := ObservedFlow2.Checked;
  //rm 2010-04-23
  SetImageIndex(Sender);
end;

procedure TfrmIIGraph.ObservedRDII1Click(Sender: TObject);
begin
  ObservedRDII1.Checked := not ObservedRDII1.Checked;
  ChartFX1.Series[2].Visible := ObservedRDII1.Checked;
  //rm 2010-04-23
  SetImageIndex(Sender);
end;

procedure TfrmIIGraph.off1Click(Sender: TObject);
begin
  off1.checked := not off1.checked;
  GWI1.Checked := off1.checked;
  ChartFX1.Series[5].Visible := GWI1.Checked;
  //rm 2010-04-23
  SetImageIndex(GWI1);
end;

procedure TfrmIIGraph.ToggleColorScheme1Click(Sender: TObject);
begin
  frmMain.ToggleChartColors;
  fillchart;
end;

procedure TfrmIIGraph.OnOff1Click(Sender: TObject);
begin
  OnOff1.checked := not OnOff1.checked;
  GWI2.Checked := OnOff1.checked;
  ChartFX1.Series[10].Visible := GWI2.Checked;
  //rm 2010-04-23
  SetImageIndex(GWI2);
end;

procedure TfrmIIGraph.Rainfall2Click(Sender: TObject);
begin
  Rainfall2.Checked := not Rainfall2.Checked;
  ChartFX1.Series[3].Visible := Rainfall2.Checked;
//rm 2010-10-19
  ChartFX1.Series[11].Visible := Rainfall2.Checked;

  //rm 2010-04-23
  SetImageIndex(Sender);
end;

procedure TfrmIIGraph.GWIAdj2Click(Sender: TObject);
begin
  GWIAdj2.Checked := not GWIAdj2.Checked;
  ChartFX1.Series[4].Visible := GWIAdj2.Checked;
  //rm 2010-04-23
  SetImageIndex(Sender);
end;

procedure TfrmIIGraph.GWIpct100Click(Sender: TObject);
begin
  TMenuItem(Sender).Checked := true;
  if Sender = GWIpct100 then begin
    GWIPct := 100;
  end else if Sender = GWIpct90 then begin
    GWIPct := 90;
  end else if Sender = GWIpct80 then begin
    GWIPct := 80;
  end else if Sender = GWIpct70 then begin
    GWIPct := 70;
  end else if Sender = GWIpct60 then begin
    GWIPct := 60;
  end else if Sender = GWIpct50 then begin
    GWIPct := 50;
  end;
  fillchart;
  off1.Checked := true;
  GWI1.Checked := true;
  ChartFX1.Series[5].Visible := GWI1.Checked;
  //rm 2010-04-23
  SetImageIndex(GWI1);
end;

procedure TfrmIIGraph.Help1Click(Sender: TObject);
begin
//Help!
  frmMain.HelpHandler_Universal(Self);
end;


//rm 2009-11-02 - new function
      //rm 2009-11-02 - just noticed that the default Major Units can be something
      //like 0.11, which, when combined with Decimals of 1 can be misleading.
      //e.g. the Y-axis marker named "0.3" might actually be "0.33"
      //so lets set decimals based on the Log10 of the range of Y-values
function TfrmIIGraph.GetDecimals: integer;
var iResult: integer;
    yRange, dLog: double;
begin
  iResult := 1; //default to the old global value of 1
  try
    yRange := ChartFX1.Axis[AXIS_Y].Max - ChartFX1.Axis[AXIS_Y].Min;
    //rm 2010-10-23 - prevent error with log(0)
    if (yRange <= 0) then begin
      iResult :=0
    end else begin
      dLog :=  Math.Log10(yRange);
      iResult := -1 * Math.Floor(dLog-2);
      if iResult < 0 then iResult := 0;
    end;
  finally

  end;
  Result := iResult;
end;

procedure TfrmIIGraph.GWI1Click(Sender: TObject);
begin
//
end;

procedure TfrmIIGraph.RDIICurve11Click(Sender: TObject);
begin
  RDIICurve11.Checked := not RDIICurve11.Checked;
  ChartFX1.Series[6].Visible := RDIICurve11.Checked;
  //rm 2010-04-23
  SetImageIndex(Sender);
end;

procedure TfrmIIGraph.RDIICurve21Click(Sender: TObject);
begin
  RDIICurve21.Checked := not RDIICurve21.Checked;
  ChartFX1.Series[7].Visible := RDIICurve21.Checked;
  //rm 2010-04-23
  SetImageIndex(Sender);
end;

procedure TfrmIIGraph.RDIICurve31Click(Sender: TObject);
begin
  RDIICurve31.Checked := not RDIICurve31.Checked;
  ChartFX1.Series[8].Visible := RDIICurve31.Checked;
  //rm 2010-04-23
  SetImageIndex(Sender);
end;

procedure TfrmIIGraph.SimulatedRDII1Click(Sender: TObject);
begin
  SimulatedRDII1.Checked := not SimulatedRDII1.Checked;
  ChartFX1.Series[9].Visible := SimulatedRDII1.Checked;
  //rm 2010-04-23
  SetImageIndex(Sender);
end;

procedure TfrmIIGraph.Events2Click(Sender: TObject);
begin
  Events2.Checked := not Events2.Checked;
  invalidateGraph;
  //rm 2010-04-23
  SetImageIndex(Sender);
end;

procedure TfrmIIGraph.Close2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmIIGraph.Events3Click(Sender: TObject);
begin
  if (events.count > 0) then begin
    frmEventEdit.OpenDialog(events,0,analysisID);
    frmEventEdit.Show;
  end else
    MessageDlg('There are no events defined.',mtWarning,[MBOK],0);
end;

procedure TfrmIIGraph.PrintPreview1Click(Sender: TObject);
begin
  ChartFX1.ShowDialog(CDIALOG_PAGESETUP,0);
end;

procedure TfrmIIGraph.PrintBitmap(bmp: TBitmap);
var
  Info      : PBitmapInfo;
  InfoSize  : DWORD;
  Image     : Pointer;
  ImageSize : DWORD;
  Bits      : HBITMAP;
begin
     Bits := bmp.Handle;  // bmp is passed as a parameter
     GetDIBSizes(Bits, InfoSize, ImageSize);
     Info := AllocMem(InfoSize);
     try
       Image := AllocMem(ImageSize);
       try
         GetDIB(Bits, 0, Info^, Image^);

         StretchDIBits(Printer.Canvas.Handle,
             Printer.Canvas.ClipRect.Left,
             Printer.Canvas.ClipRect.Top,
             Printer.Canvas.ClipRect.Right,
             Printer.Canvas.ClipRect.Bottom,
             0,  0, bmp.Width, bmp.Height,
             Image, Info^, DIB_RGB_COLORS, SRCCOPY);

       finally
         FreeMem(Image, ImageSize);
       end;
     finally
       FreeMem(Info, InfoSize);
     end;
end;


procedure TfrmIIGraph.Print1Click(Sender: TObject);
//var myClipbrd: TClipboard;
//    myBitmap: TBitmap;
begin
(*
if PrintDialog1.Execute then begin
  ChartFX1.PrintIt(0,0);
end;
*)
(*
//if PrinterSetupDialog1.Execute then
if PrintDialog1.Execute then begin
//  myClipbrd := TClipBoard.Create;
  //ChartFX1.PaintTo(Printer.Canvas,0,0);
  ChartFX1.Export(CHART_Bitmap,'');
  //ChartFX1.PaintTo(Printer.Handle,0,0);
  //Printer.Canvas.CopyRect(Printer.Canvas.ClipRect,ChartFX1.TBBitmap.Bitmap.Canvas,ChartFX1.TBBitmap.Bitmap.Canvas.ClipRect);
  //myClipbrd.Open;
  Printer.BeginDoc;
  myBitmap := TBitmap.Create;
  myBitmap.Assign(Clipboard);
  PrintBitmap(myBitmap);
  Printer.EndDoc;
  myBitmap.Free;
end;
*)
  printing := true;
  try
    ChartFX1.Visible := false;
    ChartFX1.ShowDialog(CDIALOG_PRINT,0);
  finally
    printing := false;
    ChartFX1.Visible := true;
  end;
end;

procedure TfrmIIGraph.AdjustPercentage1Click(Sender: TObject);
var sInput: string;
begin
//prompt user for GWI %
  sInput := InputBox('GWI Percentage',
  'Please enter the GWI percentage (0 .. 100%)',
  floattostr(GWIPct));
  try
    GWIPct := strtofloat(sInput);
  finally
    AdjustPercentage1.Caption :=
    'Adjust Percentage (currently ' + floattostr(GWIPct) + '%)';
    fillchart;
  end;
end;

procedure TfrmIIGraph.AsaBitmap1Click(Sender: TObject);
begin
  ChartFX1.Export(CHART_BITMAP,'');
end;

procedure TfrmIIGraph.AsaMetafile1Click(Sender: TObject);
begin
  ChartFX1.Export(CHART_METAFILE,'');
end;

procedure TfrmIIGraph.AsTextdataonly1Click(Sender: TObject);
begin
  ChartFX1.Export(CHART_DATA,'');
end;

procedure TfrmIIGraph.ScrollRight();
begin
  if (ChartFX1.Axis[AXIS_X].Max < endDay) then begin
    ChartFX1.Axis[AXIS_X].Max := ChartFX1.Axis[AXIS_X].Max + 1;
    ChartFX1.Axis[AXIS_X].Min := ChartFX1.Axis[AXIS_X].Min + 1;
    fillchart();
  end;
end;

procedure TfrmIIGraph.SetColors;
var i: integer;
begin
  with ChartFX1 do begin
    RGBBK := frmMain.ChartRGBBK;//clBlack;
    with Axis[AXIS_X] do begin
      TextColor := frmMain.ChartRGBBK;//clBlack;   {Hide the markers by using the same color as background}
    end;
    with Axis[AXIS_Y] do begin
      TextColor := frmMain.ChartRGBText;//clWhite;
      TitleColor := frmMain.ChartRGBText;//clWhite;
    end;
    with Axis[AXIS_Y2] do begin
      TextColor := frmMain.ChartRGBText;//clWhite;
      TitleColor := frmMain.ChartRGBText;//clWhite;
    end;
//rm 2010-10-19    OpenDataEx(COD_COLORS,11,11);
    OpenDataEx(COD_COLORS,12,12);
    Series[0].Color := frmMain.ChartRGBFlow;//clAqua;
    Series[1].Color := frmMain.ChartRGBGree;//clLime;
    Series[2].Color := clRed;
    with Series[3] do begin
      Color := frmMain.ChartRGBRain;//clBlue;
      //rm 2010-10-19
      BorderColor := Color;
      YAxis := AXIS_Y2;
      Gallery := BAR;
    end;
    Series[4].Color := clBlue;
    Series[5].Color := clNavy;
    Series[6].Color := RGB(0,128,128);
    Series[7].Color := RGB(255,128,128);
    Series[8].Color := clFuchsia;
    Series[9].Color := frmMain.ChartRGBYell;
    Series[10].Color := clOlive;
    for i := 0 to 10 do
      Series[i].LineWidth := frmMain.ChartLineWidth;
//rm 2010-10-19
    with Series[11] do begin
      LineWidth := 2*frmMain.ChartLineWidth;
      Color := clYellow;
      //Series[11].
      BorderColor := Series[3].BorderColor;// clYellow;
      YAxis := AXIS_Y2;
      Gallery := BAR;
    end;

    CloseData(COD_COLORS);

  end;
end;

procedure TfrmIIGraph.ScrollLeft();
begin
  if (ChartFX1.Axis[AXIS_X].Min > startDay) then begin
    ChartFX1.Axis[AXIS_X].Max := ChartFX1.Axis[AXIS_X].Max - 1;
    ChartFX1.Axis[AXIS_X].Min := ChartFX1.Axis[AXIS_X].Min - 1;
    fillchart();
  end;
end;

procedure TfrmIIGraph.NextPage();
var
  visibleWidth: real;
begin
  visibleWidth := ChartFX1.Axis[AXIS_X].Max - ChartFX1.Axis[AXIS_X].Min;
  maximumMove := Min(trunc(visibleWidth),trunc(endDay-ChartFX1.Axis[AXIS_X].Max));
  if (maximumMove > 0) then begin
    ChartFX1.Axis[AXIS_X].Max := ChartFX1.Axis[AXIS_X].Max + maximumMove;
    ChartFX1.Axis[AXIS_X].Min := ChartFX1.Axis[AXIS_X].Max - visibleWidth;
    fillchart();
  end;
end;

procedure TfrmIIGraph.NightlyMinimum1Click(Sender: TObject);
begin
  NightlyMinimum1.Checked := not NightlyMinimum1.Checked;
  ChartFX1.Series[5].Visible := NightlyMinimum1.Checked;
  //rm 2010-04-23
  SetImageIndex(Sender);
end;

procedure TfrmIIGraph.PreviousPage();
var
  visibleWidth: real;
begin
  visibleWidth := ChartFX1.Axis[AXIS_X].Max - ChartFX1.Axis[AXIS_X].Min;
  maximumMove := Min(trunc(visibleWidth),trunc(ChartFX1.Axis[AXIS_X].Min-startDay));
  if (maximumMove > 0) then begin
    ChartFX1.Axis[AXIS_X].Min := ChartFX1.Axis[AXIS_X].Min - maximumMove;
    ChartFX1.Axis[AXIS_X].Max := ChartFX1.Axis[AXIS_X].Min + visibleWidth;
    fillchart();
  end;
end;

procedure TfrmIIGraph.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if (ssMiddle in Shift)
    then NextPage
    else ScrollRight;
  Handled := True;
end;

procedure TfrmIIGraph.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if (ssMiddle in Shift)
    then PreviousPage
    else ScrollLeft;
  Handled := True;
end;


procedure TfrmIIGraph.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (frmEventEdit.visible) then frmEventEdit.Close;

  ChartFX1.ClearData(CD_VALUES AND CD_XVALUES);

  events.Free;
  gwiadjustments.Free;

  Finalize(holidays);
  Finalize(diurnal);
  Finalize(averageDWF);
  Finalize(rainfall);
  Finalize(rdii);
  Finalize(observedFlow);
  Finalize(computedGWI);
  Finalize(gwiadj);
  Finalize(rdiiCurve);
  Finalize(rdiiTotal);
  Finalize(dailygwiadj);
  Finalize(minimumIndicies);

  //rm 2010-10-19
  Finalize(IACurve);

end;

procedure TfrmIIGraph.FormCreate(Sender: TObject);
begin
//create chart on-the-fly
  ChartFX1:=TChartFX.Create(Self);
  with ChartFX1 do begin
    Parent := Self;
    Left := Self.Padding.Left;
    Top := Self.Padding.Top;
    Width := Self.ClientWidth;
    Height := Self.ClientHeight;
    TabOrder := 0;
    visible := true;
    Chart3D := false;
    OnLButtonDblClk := ChartFX1LButtonDblClk;
    OnPostPaint := ChartFX1PostPaint;
    OnLButtonDown := ChartFX1LButtonDown;
    OnLButtonUp := ChartFX1LButtonUp;
    OnRButtonUp := ChartFX1RButtonUp;
    OnMouseMoving := ChartFX1MouseMoving;
  end;
  GWIPct := 100;
end;

procedure TfrmIIGraph.FormDestroy(Sender: TObject);
begin
  ChartFX1.Free;
end;

function TfrmIIGraph.isHoliday(date: TDateTime): boolean;
var
  i: integer;
begin
  isHoliday := false;
  for i := 0 to length(holidays) - 1 do begin
    if (trunc(date) = holidays[i]) then isHoliday := true;
  end;
end;


function TfrmIIGraph.dayOfWeekIndex(date: TDateTime): integer;
(* returns day of week 0 = sun, 1 = mon, 2 = tues..... 6 = saturday *)
(* holidays are returned as 7 *)
var
  dow: integer;
begin
  dow := dayofweek(date) - 1;
  if (isholiday(date)) then dow := 7;
  dayOfWeekIndex := dow;
end;

end.
