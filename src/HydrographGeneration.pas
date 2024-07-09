unit hydrographgeneration;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mask, StdCtrls, Spin, ChartfxLib_TLB,Analysis, StormEvent, StormEventCollection, rdiiutils,
  math, Hydrograph, GWIAdjustmentCollection, ADODB_TLB, mainform, DateUtils,
  OleCtrls, ExtCtrls;

type
  TfrmHydrographGeneration = class(TForm)
    Label7: TLabel;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    SewershedNameComboBox: TComboBox;
    Label1: TLabel;
    AnalysisNameComboBox: TComboBox;
    EventGroupBox1: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    StatBasedHydrographGroupBox1: TGroupBox;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    R1Edit2: TEdit;
    R2Edit2: TEdit;
    R3Edit2: TEdit;
    T1Edit2: TEdit;
    T2Edit2: TEdit;
    T3Edit2: TEdit;
    K1Edit2: TEdit;
    K2Edit2: TEdit;
    K3Edit2: TEdit;
    EventSpinEdit: TSpinEdit;
    EventsMemo: TMemo;
    SaveStatsDialog: TSaveDialog;
    //ChartFX1: TChartFX;
    RadioGroup1: TRadioGroup;
    RadioEventBased1: TRadioButton;
    RadioUserBased1: TRadioButton;
    Button1: TButton;
    Label3: TLabel;
    Label5: TLabel;
    ListBoxRDIIAreas: TListBox;
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure UpdateDialogBasedOnSelectedWeekdayRaingauge();
    procedure UpdateDialogBasedOnSelectedWeekendRaingauge();
    procedure WeekdayRaingaugeComboBoxChange(Sender: TObject);
    procedure WeekendRaingaugeComboBoxChange(Sender: TObject);
    procedure UpdateDataBasedOnSelectedAnalysis;
    procedure OutputStatsToMemo;
    procedure UpdateDataBasedOnSelectedEvent;
    procedure EventSpinEditChange(Sender: TObject);
    procedure CalculateRDIICurve(contributeArea : real; node : string;
                RTKmethod : integer);
    procedure okButtonClick(Sender: TObject);
    procedure SewershedNameComboBoxChange(Sender: TObject);
    procedure RadioUserBased1Click(Sender: TObject);
    procedure RadioEventBased1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ListBoxRDIIAreasClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
    //procedure ComboBoxCatchmentNamesChange(Sender: TObject);



  private  { Private declarations }
    //raingaugeNames: TStringlist;
    analysis: TAnalysis;
    analysisID, meterID: integer;
    runningAverageDuration: real;
    events: TStormEventCollection;
    event: TStormEvent;
    raingaugeName, flowMeterName, rainUnitLabel, volumeUnitLabel: string;
    raingaugeID: integer;
    rainStartDate, rainEndDate: TDateTime;
    decimalPlaces: integer;
    rdeltime: integer;
    eventTotalR, rdiiEventTotalR: array of real;
    conversionToMGD, conversionToInches: real;
    startDay, endDay, days: integer;
    timestamp: TDateTime;
    rtimestamp: TTimeStamp;
    timestep, segmentsPerDay: integer;
    timestepsToAverage, totalSegments: integer;
    rdiiCurve: array of array of real;
    rdiiTotal: array of real;
    rainfall: array of real;
    rainVolume: array of real;
    maxRain : array of real;
    kMax, kRecover, iAbstraction: real;
    defaultR, defaultT, defaultK : array[0..2] of real;
    testDay : TDateTime;
    totalRDII : array of array of real;
    nodeID : array of string;
    counter : integer;

        ChartFX1: TChartFX;


    procedure UpdateRDIIHydrograph(RTKmethod : integer);
    procedure fillchart();
    procedure RedrawChart();
    procedure resetmemory();

  public { Public declarations }
    flowUnitLabel : string;

  end;

const
  chartLeft: integer = 296;
  chartTop: integer = 8;

var
  frmHydrographGeneration: TfrmHydrographGeneration;

implementation

uses modDatabase, feedbackWithMemo, autodayremovalThread;

{$R *.DFM}


procedure TfrmHydrographGeneration.RadioEventBased1Click(Sender: TObject);
begin
  EventGroupBox1.Enabled := true;
  StatBasedHydrographGroupBox1.Enabled := false;
  EventSpinEdit.Enabled := true;
  AnalysisNameComboBox.enabled := true;
  SewershedNameComboBox.Items := DatabaseModule.GetSewershedNames;
  SewershedNameComboBox.ItemIndex := 0;

  ListBoxRDIIAreas.Items := DatabaseModule.GetRDIIAreaNames;
  ListBoxRDIIAreas.ItemIndex := 0;

  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames;
  AnalysisNameComboBox.ItemIndex := 0;
  UpdateDataBasedOnSelectedAnalysis();
  UpdateRDIIHydrograph(1);
  RedrawChart();


  R1Edit2.enabled := false;
  R2Edit2.enabled := false;
  R3Edit2.enabled := false;
  T1Edit2.enabled := false;
  T2Edit2.enabled := false;
  T3Edit2.enabled := false;
  K1Edit2.enabled := False;
  K2Edit2.enabled := false;
  K3Edit2.enabled := false;
end;

procedure TfrmHydrographGeneration.RadioUserBased1Click(Sender: TObject);
begin
  EventGroupBox1.Enabled := false;
  StatBasedHydrographGroupBox1.Enabled := true;
  EventSpinEdit.Enabled := false;
  EventsMemo.Clear;
  AnalysisNameComboBox.Enabled := false;

  R1Edit2.enabled := true;
  R2Edit2.enabled := true;
  R3Edit2.enabled := true;
  T1Edit2.enabled := true;
  T2Edit2.enabled := true;
  T3Edit2.enabled := true;
  K1Edit2.enabled := true;
  K2Edit2.enabled := true;
  K3Edit2.enabled := true;
  end;

procedure TfrmHydrographGeneration.RedrawChart();
var
    titleChart : string;
    txt : string;
begin
    with ChartFX1 do begin
{    Align := alClient;}
    {Align := alRight;}
    RightGap := 5;
    TopGap := 5;
    AllowEdit := False;
    AllowDrag := False;
    AllowResize := False;
    Scrollable := true;
    RGBBK := clBlack;
    MenuBarObj.Visible := False;
    {TypeMask := TypeMask OR CT_TRACKMOUSE;}
    TypeEx := TypeEx OR CTE_SMOOTH;
    MarkerShape := MK_NONE;
    ChartType := LINES;

    title[2] := SewershedNameComboBox.Text;

    with Axis[AXIS_X] do begin
      Min := startDay;
      Max := endDay;
      Format := 'XM/d/yy';
      PixPerUnit := 100;
      Step := 1;
      Grid := True;
      TextColor := clWhite;   {Hide the markers by using the same color as background}
    end;

    with Axis[AXIS_Y] do begin
      TextColor := clWhite;
      ResetScale;
      Title := 'Flow ('+flowUnitLabel+')';
      TitleColor := clWhite;
      Decimals := 1;
    end;
    fillchart();
    OpenDataEx(COD_COLORS,1,1);
      Series[0].Color := clAqua;
    CloseData(COD_COLORS);
    {showballoon('Hello World', 100, 100);}
    end;
    {SetTextAlign(handle,TA_LEFT or TA_TOP);}
    {txt := pchar(' Event ');}
     {font := TFont.Create;
     font.name := 'Arial';
     SetTextAlign(handle,TA_CENTER);
     TextOutA(handle,ChartFX1.LeftGap + 10,ChartFX1.Height - ChartFX1.TopGap - ChartFX1.BottomGap - 4,'testtesttest',12);}

end;



procedure TfrmHydrographGeneration.FormCreate(Sender: TObject);
begin
  ChartFX1:=TChartFX.Create(Self);
  with ChartFX1 do begin
    Parent := Self;
    //Left := 296;
    //Top := 8;
    Left := chartLeft;
    Top := chartTop;
    Width := 577;
    Height := 583;
    TabOrder := 8;
    visible := true;
    Chart3D := false;
  end;
end;

procedure TfrmHydrographGeneration.FormResize(Sender: TObject);
begin
  if ClientWidth > chartLeft then
    ChartFX1.Width := ClientWidth - chartLeft - 8;
  if Clientheight > chartTop then
    ChartFX1.Height := ClientHeight - chartTop - 8;
end;

procedure TfrmHydrographGeneration.FormShow(Sender: TObject);
begin
  SewershedNameComboBox.Items := DatabaseModule.GetSewershedNames;
  SewershedNameComboBox.ItemIndex := 0;

  ListBoxRDIIAreas.Items := DatabaseModule.GetRDIIAreaNames;
  ListBoxRDIIAreas.ItemIndex := 0;

  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames;
  AnalysisNameComboBox.ItemIndex := 0;
  UpdateDataBasedOnSelectedAnalysis();
  UpdateRDIIHydrograph(1);
  RedrawChart();

  {testTextOutA(Canvas, 100, 400, 'Hello world!');}

  {font := TFont.Create;
  font.size := 24;
  font.name := 'Arial';
  SetTextAlign(handle,TA_CENTER);
  TextOutA(handle,ChartFX1.LeftGap + 10,ChartFX1.TopGap - ChartFX1.BottomGap - 4,'testtesttest',12);
  }

   {UpdateDataBasedOnSelectedEvent;}
end;


procedure TfrmHydrographGeneration.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmHydrographGeneration.ListBoxRDIIAreasClick(Sender: TObject);
var
  sRDIIAreaName,sSewerShedName: string;
  i: integer;
begin
  sRDIIAreaName := ListBoxRDIIAreas.Items[ListBoxRDIIAreas.ItemIndex];
  sSewerShedName := DatabaseModule.GetSewerShedNameForRDIIAreaName(sRDIIAreaName);
  i := SewershedNameComboBox.Items.IndexOf(sSewerShedName);
  if i>-1  then
    SewershedNameComboBox.ItemIndex := i;

end;

procedure TfrmHydrographGeneration.okButtonClick(Sender: TObject);
var
  //sewershedName, queryStr: string;
  //sewershedID : integer;
  //recSet: _RecordSet;
  F: textfile;
  i, j : integer;
{  totalRDII : array of array of real;}
{  counter : integer;}
{  nodeID : array of string;}

  yearStamp, monthStamp, dayStamp, hourStamp, minuteStamp : word;
  secStamp, milliStamp : word;

  begin
{  sewershedName := SewershedNameComboBox.Text;
  sewershedID := DatabaseModule.GetSewershedIDForName(sewershedName);

  queryStr := 'SELECT Node, Area FROM RDII WHERE (SewershedID = ' + inttostr(sewershedID) + ');';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;}

  SaveStatsDialog.Filter := 'TXT Files|*.txt';
  SaveStatsDialog.DefaultExt := '.TXT';
  if (SaveStatsDialog.Execute) then begin
    Screen.Cursor := crHourglass;
    AssignFile(F,SaveStatsDialog.Filename);
    Rewrite(F);
//  end;

 { counter := 0;}
{  while (not recSet.EOF) do begin
    CalculateRDIICurve(recSet.Fields.Item[1].Value,recSet.Fields.Item[0].Value);
    counter := counter + 1;
    setLength(totalRDII,counter,totalSegments);
    for i := 0 to totalSegments - 1 do
      totalRDII[counter-1,i] := rdiitotal[i];
    recSet.MoveNext;
  end;}

  writeln(F,'SWMM5');
  writeln(F,'FROM SSOAP-RDII HYDROGRAPH GENERATION TOOL: Hydrographs for ' + SewershedNameComboBox.Text);
  writeln(F, inttostr(timestep*60));
  writeln(F, '1');
  writeln(F, 'FLOW CFS');
  writeln(F, inttostr(counter));

  {recSet.MoveFirst;}

{  setLength(nodeID,counter);

  i := 0;
  while (not recSet.EOF) do begin
    writeln(F, recSet.Fields.Item[0].Value);
    nodeID[i] := recSet.Fields.Item[0].Value;
    recSet.MoveNext;
    i := i + 1;
  end;}
  writeln(F, 'Node Year Mon Day Hr Min Sec Flow');

  timestamp := testday;

  for i := 0 to totalSegments - 1 do begin
    DecodeDateTime(timestamp, yearstamp, Monthstamp, DayStamp, hourStamp, minuteStamp,secStamp, milliStamp);
    timestamp := IncMinute(timestamp, timestep);
    for j := 0 to counter - 1 do begin
         writeln(F,nodeID[j],' ',yearstamp,' ',monthstamp,' ',daystamp,' ',hourstamp,' ',
            minutestamp,' 0 ',floattostrF(totalRDII[j,i],ffFixed,15,5));
    end;
  end;

   {for j := 0 to counter - 1 do begin
      for i  := 0 to totalSegments - 1 do begin
          writeln(F,nodeID[j], '   ', startday + timestep*i ,'  ',floattostrF(totalRDII[j,i],ffFixed,15,5));
      end;
   end;}


   Screen.Cursor := crDefault;

    CloseFile(F);

  end;
end;

procedure TfrmHydrographGeneration.cancelButtonClick(Sender: TObject);
begin
  Close;
end;


{
procedure TfrmHydrographGeneration.ComboBoxCatchmentNamesChange(
  Sender: TObject);
var
  sSewerShedName: string;
  i: integer;
begin
  sSewerShedName := DatabaseModule.GetSewerShedNameForCatchMentName(ComboBoxCatchmentNames.Text);
  i := SewershedNameComboBox.Items.IndexOf(sSewerShedName);
  if i>-1  then
    SewershedNameComboBox.ItemIndex := i;
end;
}

procedure TfrmHydrographGeneration.EventSpinEditChange(Sender: TObject);
begin
  if (events.count > 0) then begin
    event := events[eventSpinEdit.Value - 1];
    UpdateDataBasedOnSelectedEvent;
    UpdateRDIIHydrograph(1);
    OutputStatsToMemo;
    RedrawChart();
    {fillchart();}

  end;
end;

procedure TfrmHydrographGeneration.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;



procedure TfrmHydrographGeneration.UpdateDataBasedOnSelectedEvent;
const
  conversionFromAcreInchesPerHourToMGD = (43560.0*7.481*24.0)/(12.0*1000000.0);
var
  i, j, k, numEvents, startIndex, endIndex, eventIndex, dow: integer;
  flowStartDateTime, flowEndDateTime: TDateTime;
  hour, minute, second, ms: word;
  fbww, fgwi, sumerror, sse, err, iidepth, rdiiDepth: real;
  weekdayDWF, weekendDWF: THydrograph;
  analysisName, queryStr: string;
  recSet: _RecordSet;


begin
  Screen.Cursor := crHourglass;
  analysisName := AnalysisNameComboBox.Text;
  analysis := DatabaseModule.GetAnalysis(analysisName);
  analysisID := analysis.analysisID;
  meterID := analysis.flowMeterID;
  raingaugeID := analysis.raingaugeID;

  {area := DatabaseModule.GetAreaForAnalysis(analysisName);}
  flowMeterName := DatabaseModule.GetFlowMeterNameForAnalysis(analysisName);
  raingaugeName := DatabaseModule.GetRaingaugeNameForAnalysis(analysisName);
  {minbwwf := DatabaseModule.GetBaseFlowRateForAnalysis(analysisName);}
  rdeltime := DatabaseModule.GetRainfallTimestep(raingaugeID);
  conversionToMGD := DatabaseModule.GetConversionForMeter(meterID);
  decimalPlaces := DatabaseModule. GetRainfallDecimalPlacesForRaingauge(raingaugeName);

  {kRecover := analysis.RateOfReduction;
  kMax := analysis.MaxDepressionStorage;}

  event := events[eventSpinEdit.Value - 1];

  queryStr := 'SELECT StartDateTime, EndDateTime, TimeStep, Area FROM Meters ' +
           'WHERE (MeterID = ' + inttostr(meterID) + ');';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
  flowStartDateTime := recSet.Fields.Item[0].Value;
  flowEndDateTime := recSet.Fields.Item[1].Value;
  {startDay := trunc(flowStartDateTime);
  endDay := trunc(flowEndDateTime) + 1;}

  testDay := trunc(event.StartDate);

  startDay := trunc(event.StartDate);
  endDay := trunc(event.EndDate) + 1;
  days := endDay - startDay;

  timestep := recSet.Fields.Item[2].Value;
  if (timestep <= 0) then
  timestep := 1;
  {recSet.Close;}

  segmentsPerDay := 1440 div timeStep;
  totalSegments := days * segmentsPerDay;
  timestepsToAverage := round(analysis.runningAverageDuration*60/timestep);

  SetLength(rainfall,0);
  SetLength(rdiiCurve,0,0);
  SetLength(rdiiTotal,0);


  SetLength(rainfall,totalSegments);
  SetLength(rdiiCurve,3,totalSegments);
  SetLength(rdiiTotal,totalSegments);
   (* Get the conversion rates for the flow and rain values *)
  conversionToMGD := DatabaseModule.GetConversionForMeter(meterID);
  conversionToInches := DatabaseModule.GetConversionForRaingauge(raingaugeID);
   { get rainfall data }
  for i := 0 to totalSegments - 1 do rainfall[i] := 0.0;

  {queryStr := 'SELECT DateTime, Volume FROM Rainfall WHERE ' +
              '((RaingaugeID = ' + inttostr(raingaugeID) + ') AND ' +
              '(DateTime >= ' + floattostr(flowStartDateTime) + ' AND ' +
              'DateTime <= ' + floattostr(flowEndDateTime) + '));';}

  queryStr := 'SELECT DateTime, Volume FROM Rainfall WHERE ' +
              '((RaingaugeID = ' + inttostr(raingaugeID) + ') AND ' +
              '(DateTime >= ' + floattostr(event.StartDate) + ' AND ' +
              'DateTime <= ' + floattostr(event.EndDate) + ')) order by DateTime;';

  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
  while (not recSet.EOF) do begin
    timestamp := recSet.Fields.Item[0].Value;
    rtimestamp := DateTimeToTimeStamp(timestamp);
    i := (trunc(timestamp) - startday) * segmentsPerDay;
    i := i + trunc((rtimestamp.time / MSecsPerDay) * segmentsPerDay);
    rainfall[i] := recSet.Fields.Item[1].Value;
    recSet.MoveNext;
  end;
  recSet.Close;


  events := DatabaseModule.GetEvents(analysisID);
  numEvents := events.count;
  if (numEvents > 0) then begin
    {gwiAdjustments := DatabaseModule.GetGWIAdjustments(analysisID);}
    flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
    rainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(raingaugeName);
    volumeUnitLabel := DatabaseModule.GetFlowVolumeLabelForMeter(flowMeterName);

    SetLength(rainVolume,0);
    SetLength(maxRain,0);
    SetLength(eventTotalR,0);
    SetLength(rdiiEventTotalR,0);


    SetLength(rainVolume,numEvents);
    SetLength(maxRain,numEvents);
    SetLength(eventTotalR,numEvents);
    SetLength(rdiiEventTotalR,numEvents);

    for i := 0 to numEvents - 1 do begin
      with TStormEvent(events[i]) do begin
        if (R[0] = 0) then begin
          for j := 0 to 2 do begin
            R[j] := analysis.defaultR[j];
            T[j] := analysis.defaultT[j];
            K[j] := analysis.defaultK[j];
          end;
        end;
      end;
    end;

    {calculate the simulated RDII arrays}
    {calculateSimulatedRDII();}
    {for each event determine observed and simulated II statistics}

{   for eventIndex := 0 to numEvents - 1 do begin}
      eventIndex := eventSpinEdit.Value - 1;
      event := events[eventIndex];

      rainVolume[eventIndex] := DatabaseModule.RainfallTotalForRaingaugeBetweenDates(raingaugeID,event.StartDate,event.EndDate);
      {observedFlowHydrograph := DatabaseModule.ObservedFlowBetweenDateTimes(meterID,event.startDate,event.EndDate);}
      DatabaseModule.GetExtremeRainfallDateTimesBetweenDates(raingaugeID,
                                                             event.startDate,
                                                             event.endDate,
                                                             rainStartDate,
                                                             rainEndDate);
      maxRain[eventIndex] := DatabaseModule.GetMaximumRainfallBetweenDates(raingaugeID,event.startDate,event.endDate);
    {end;}
    event := events[eventSpinEdit.Value - 1];
{    OutputStatsToMemo;}
  end
  else begin
    eventSpinEdit.Enabled := false;
    {saveToCSVFileButton.Enabled := false;}
    EventsMemo.Lines.Clear;
  end;




  Screen.Cursor := crDefault;
end;





procedure TfrmHydrographGeneration.UpdateDialogBasedOnSelectedWeekdayRaingauge();
var
  raingaugeName, rainUnitLabel: string;
begin
{  raingaugeName := WeekdayRaingaugeComboBox.Text;
  rainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(raingaugeName);
  WeekdayCurrentDayMaxRainLabel.Caption := 'Current Day Max Rain ('+rainUnitLabel+')';
  WeekdayPreviousDayMaxRainLabel.Caption := 'Previous Day Max Rain ('+rainUnitLabel+')';
  WeekdayTwoDaysPreviousMaxRainLabel.Caption := 'Two Days Previous Max Rain ('+rainUnitLabel+')';}
end;

procedure TfrmHydrographGeneration.UpdateDialogBasedOnSelectedWeekendRaingauge();
var
  raingaugeName, rainUnitLabel: string;
begin
{  raingaugeName := WeekendRaingaugeComboBox.Text;
  rainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(raingaugeName);
  WeekendCurrentDayMaxRainLabel.Caption := 'Current Day Max Rain ('+rainUnitLabel+')';
  WeekendPreviousDayMaxRainLabel.Caption := 'Previous Day Max Rain ('+rainUnitLabel+')';
  WeekendTwoDaysPreviousMaxRainLabel.Caption := 'Two Days Previous Max Rain ('+rainUnitLabel+')';}
end;


procedure TfrmHydrographGeneration.WeekdayRaingaugeComboBoxChange(
  Sender: TObject);
begin
  UpdateDialogBasedOnSelectedWeekdayRaingauge();
end;

procedure TfrmHydrographGeneration.WeekendRaingaugeComboBoxChange(
  Sender: TObject);
begin
  UpdateDialogBasedOnSelectedWeekendRaingauge();
end;


procedure TfrmHydrographGeneration.UpdateDataBasedOnSelectedAnalysis;
var
  analysisName: string;
  weekdayDWF, weekendDWF: THydrograph;

begin
  Screen.Cursor := crHourglass;
  analysisName := AnalysisNameComboBox.Text;
  analysis := DataBaseModule.GetAnalysis(analysisName);
  analysisID := analysis.AnalysisID;
  meterID := analysis.FlowMeterID;
  raingaugeID := analysis.RaingaugeID;
  runningAverageDuration := analysis.RunningAverageDuration;


  {area := DatabaseModule.GetAreaForAnalysis(analysisName);}
  flowMeterName := DatabaseModule.GetFlowMeterNameForAnalysis(analysisName);
  raingaugeName := DatabaseModule.GetRaingaugeNameForAnalysis(analysisName);
  {minbwwf := DatabaseModule.GetBaseFlowRateForAnalysis(analysisName);
  rdeltime := DatabaseModule.GetRainfallTimestep(raingaugeID);
  conversionToMGD := DatabaseModule.GetConversionForMeter(meterID);
  conversionToInches := DatabaseModule.GetConversionForRaingauge(raingaugeID);
  diurnal := DatabaseModule.GetDiurnalCurves(analysisName);}
  events := DatabaseModule.GetEvents(analysisID);
  {gwiAdjustments := DatabaseModule.GetGWIAdjustments(analysisID);
  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);}
  rainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(raingaugeName);
  decimalPlaces := DatabaseModule. GetRainfallDecimalPlacesForRaingauge(raingaugeName);
  {volumeUnitLabel := DatabaseModule.GetFlowVolumeLabelForMeter(flowMeterName);
  weekdayDWF := DatabaseModule.GetWeekdayDWF(meterID);
  weekendDWF := DatabaseModule.GetWeekendDWF(meterID);
  minWeekdayDWFIndex := weekdayDWF.indexOfMinimum;
  minWeekendDWFIndex := weekdayDWF.indexOfMinimum;
  weekdayDWFMinimum := weekdayDWF.Minimum;
  weekendDWFMinimum := weekendDWF.Minimum;
  weekdayDWF.Free;
  weekendDWF.Free;

  timestep := DatabaseModule.GetFlowTimestep(meterID);
  segmentsPerDay := 1440 div timeStep;
  timestepsToAverage := round(runningAverageDuration*60/timestep);}

  if (events.count > 0) then begin
    eventSpinEdit.Value := 1;
    eventSpinEdit.Enabled := true;
    eventSpinEdit.MaxValue := events.count;
    event := events[eventSpinEdit.Value - 1];
    UpdateDataBasedOnSelectedEvent;
    OutputStatsToMemo;
  end
  else begin
    eventSpinEdit.Enabled := false;
    EventsMemo.Lines.Clear;
  end;

  Screen.Cursor := crDefault;
end;


procedure TfrmHydrographGeneration.OutputStatsToMemo;
var
  r1, r2, r3 : real;
  k1, k2, k3 : real;
  t1, t2, t3 : real;
  i, eventIndex : integer;
  totalR : real;

begin
  eventIndex := eventSpinEdit.Value - 1;

  EventsMemo.Lines.Clear;

  EventsMemo.Lines.Add('Start Date & Hour     = '+datetostr(event.StartDate)+ ' ' +timetostr(event.StartDate));
  EventsMemo.Lines.Add('End Date & Hour      = '+datetostr(event.EndDate)+ ' ' +timetostr(event.EndDate));
  EventsMemo.Lines.Add('Duration                   = '+floattostrF(event.duration*24,ffFixed,8,2)+ ' Hours');
  EventsMemo.Lines.Add('');
{  EventsMemo.Lines.Add('Curve Number        R  T(hours)       K');
  for i := 0 to 2 do begin
    EventsMemo.Lines.Add('         '+inttostr(i+1)+'    '+
      floattostrF(event.R[i],ffFixed,15,5)+'       '+
      floattostrF(event.T[i],ffFixed,15,1)+'     '+
      floattostrF(event.K[i],ffFixed,15,1));
  end;}

  totalR := event.R[0] + event.R[1] + event.R[2];

  EventsMemo.Lines.Add('        R        T        K');
  EventsMemo.Lines.Add('1      ' + floattostr(event.R[0]) + '        '+floattostr(event.T[0])+'        '+floattostr(event.K[0]));
  EventsMemo.Lines.Add('2      ' + floattostr(event.R[1]) + '        '+floattostr(event.T[1])+'        '+floattostr(event.K[1]));
  EventsMemo.Lines.Add('3      ' + floattostr(event.R[2]) + '        '+floattostr(event.T[2])+'        '+floattostr(event.K[2]));
  EventsMemo.Lines.Add('');


  EventsMemo.Lines.Add('Event Rainfall Volume = '+floattostrF(rainVolume[eventIndex],ffFixed,8,decimalPlaces)+' '+rainUnitLabel);
  EventsMemo.Lines.Add('Max '+inttostr(rdeltime)+' Minute Rain    = '+floattostrF(maxRain[eventIndex],ffFixed,8,decimalPlaces)+' '+rainUnitLabel);
  EventsMemo.Lines.Add('');
  EventsMemo.Lines.Add('(Total R)' +
                            leftPad(floattostrF(totalR,ffFixed,15,3),10));
                            {leftPad(floattostrF(rdiiEventTotalR[eventIndex],ffFixed,15,3),14));}
end;







procedure TfrmHydrographGeneration.SewershedNameComboBoxChange(Sender: TObject);
begin
  resetmemory();
  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames;
  AnalysisNameComboBox.ItemIndex := 0;

  ListBoxRDIIAreas.Items := DatabaseModule.GetRDIIAreaNames;
  ListBoxRDIIAreas.ItemIndex := 0;

  UpdateDataBasedOnSelectedAnalysis();
  UpdateRDIIHydrograph(1);
  RedrawChart();
end;


procedure TfrmHydrographGeneration.Button1Click(Sender: TObject);
begin
  UpdateRDIIHydrograph(2);
  redrawchart();
end;

procedure TfrmHydrographGeneration.CalculateRDIICurve(contributeArea : real; node : string; RTKmethod : integer);
//RTKmethod
// 1 = event based RTK
// 2 = user-defined RTK
const
  conversionFromAcreInchesPerHourToMGD = (43560.0*7.481*24.0)/(12.0*1000000.0);
var
  i, j, m, n, index, timestepsPerHour : integer;
  day, qpeak, flow, rain, prevRainDate, abstraction, excess: real;
  event: TStormEvent;
  R,T,K : array[0..2] of real;

begin
  day := startDay;
  for i := 0 to totalSegments - 1 do begin
    for j := 0 to 2 do begin
      rdiiCurve[j,i] := 0.0;
      rdiiCurve[j,i] := 0.0;
      rdiiCurve[j,i] := 0.0;
    end;
  end;
  if timestep <=0 then timestep := 1;
  
  timestepsPerHour := 60 div timestep;
  abstraction := iabstraction;
  prevRainDate := 0;

    for i := 0 to days - 1 do begin
    for j := 0 to segmentsPerDay - 1 do begin
      index := (i * segmentsPerDay) + j;
      rain := rainfall[index];
      if (rain > 0) then begin
        { determine the RTK values at this instant }
        if RTKmethod = 1 then begin
          for m := 0 to 2 do begin
            R[m] := defaultR[m];
            T[m] := defaultT[m];
            K[m] := defaultK[m];
          end;
          day := (startDay + i) + (j / segmentsPerDay);
          if (prevRainDate = 0) then prevRainDate := day;
          for m := 0 to events.count - 1 do begin
            event := events.Items[m];
            if ((day >= event.startDate) and (day <= event.endDate)) then begin
              if (event.R[0] > 0.0) then
                for n := 0 to 2 do begin
                  R[n] := event.R[n];
                  T[n] := event.T[n];
                  K[n] := event.K[n];
                end;
              end;
          end;
        end
        else begin
           R[0] := strtofloat(R1Edit2.Text);
           R[1] := strtofloat(R2Edit2.Text);
           R[2] := strtofloat(R3Edit2.Text);
           T[0] := strtofloat(T1Edit2.Text);
           T[1] := strtofloat(T2Edit2.Text);
           T[2] := strtofloat(T3Edit2.Text);
           K[0] := strtofloat(K1Edit2.Text);
           K[1] := strtofloat(K2Edit2.Text);
           k[2] := strtofloat(K3Edit2.Text);
        end;
        {calculate each composite RDII curve at this instant}
        abstraction := min(kmax,(abstraction+krecover*(day-prevRainDate-timestep/(24.0*60.0))));
        abstraction := max(abstraction,0.0);
        prevRainDate := day;
        excess := max(rain-abstraction,0.0);
        abstraction := abstraction-(rain-excess);
{        writeln(F,'***  ',floattostrF(prevRainDate,ffFixed,15,5),'   '
                         ,floattostrF(abstraction,ffFixed,15,5),'   '
                         ,floattostrF(excess,ffFixed,15,5));   }
        if (excess > 0.0) then begin
          for m := 0 to 2 do begin
            if ((R[m] > 0.0) and (T[m] > 0.0)) then begin
              qpeak := R[m]*2.0*contributeArea/(T[m]*(1+K[m]))
                       *conversionFromAcreInchesPerHourToMGD
                       /conversionToMGD
                       *conversionToInches;
              for n := 0 to trunc(T[m] * (K[m] + 1) * timestepsPerHour) do begin
                if (index + n < totalSegments) then begin
                  if (n <= T[m] * timestepsPerHour)
                    then flow := (n / (T[m] * timestepsPerHour)) * qpeak * excess
                    else flow := (1.0 - ((n-(T[m]*timestepsPerHour) )/(K[m]*T[m]*timestepsPerHour))) * qpeak * excess;
                  rdiiCurve[m,index+n] := rdiiCurve[m,index+n] + flow;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  for i := 0 to totalSegments - 1 do
    rdiiTotal[i] := rdiiCurve[0,i] + rdiiCurve[1,i] + rdiiCurve[2,i];
end;


procedure TfrmHydrographGeneration.UpdateRDIIHydrograph(RTKmethod : integer);
var
  sewershedName, queryStr: string;
  sewershedID : integer;
  recSet: _RecordSet;
  i, j : integer;

  begin
  sewershedName := SewershedNameComboBox.Text;
  sewershedID := DatabaseModule.GetSewershedIDForName(sewershedName);

  //queryStr := 'SELECT Node, Area FROM RDII WHERE (SewershedID = ' + inttostr(sewershedID) + ');';
  queryStr := 'SELECT JunctionID, Area FROM RDIIArea WHERE (SewershedID = ' + inttostr(sewershedID) + ');';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //check for null set
  if recSet.EOF then begin

  end else begin;

  recSet.MoveFirst;

  counter := 0;
  setLength(totalRDII,0,0);
  while (not recSet.EOF) do begin
    CalculateRDIICurve(recSet.Fields.Item[1].Value,recSet.Fields.Item[0].Value,RTKmethod);
    {add export to file}
    counter := counter + 1;
    setLength(totalRDII,counter,totalSegments);
    for i := 0 to totalSegments - 1 do
      totalRDII[counter-1,i] := rdiitotal[i];
    recSet.MoveNext;
  end;

  recSet.MoveFirst;
  setLength(nodeID,counter);

  end;

  i := 0;
  Screen.Cursor := crDefault;
end;


procedure TfrmHydrographGeneration.fillchart();
var
  dataIndex, graphIndex, startIndex, endIndex: integer;
  commonXValue: double;
begin
  {startIndex := trunc(ChartFX1.Axis[AXIS_X].Min - startDay) * segmentsPerDay;
  endIndex := (trunc(ChartFX1.Axis[AXIS_X].Max - startDay) * segmentsPerDay) - 1;}
  if totalSegments > 0 then begin

  with ChartFX1 do begin
    Axis[AXIS_Y].ResetScale;
    OpenDataEx(COD_VALUES,1,totalSegments);
    OpenDataEx(COD_XVALUES,1,totalSegments);



    for dataIndex := 0 to totalSegments-1 do begin
      {graphIndex := dataIndex - startIndex;}
      commonXValue := startDay + (dataIndex / segmentsPerDay);
      Series[0].XValue[dataIndex] := commonXValue;
      Series[0].YValue[dataIndex] := totalRDII[0,dataIndex];
    end;
    CloseData(COD_VALUES);
    CloseData(COD_XVALUES);
  end;
  end;
end;


procedure TfrmHydrographGeneration.resetMemory();

begin
   {testing}
   setLength(totalRDII,0,0);

end;

end.
