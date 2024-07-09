unit FlowMonGraphForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Menus,  OleCtrls, ChartfxLib_TLB, math, hydrograph, moddatabase, ADODB_TLB,
  Dialogs, Chart, Printers, Clipbrd, ImgList, StormEvent;

type
  TfrmFlowMonGraph = class(TForm)
    MainMenu1: TMainMenu;
    Graph1: TMenuItem;
    Close2: TMenuItem;
    File1: TMenuItem;
    PrintPreview1: TMenuItem;
    Print1: TMenuItem;
    Edit1: TMenuItem;
    CopyToClipboard1: TMenuItem;
    AsaBitmap1: TMenuItem;
    AsaMetafile1: TMenuItem;
    AsTextdataonly1: TMenuItem;
    Views1: TMenuItem;
    ToggleColorScheme1: TMenuItem;
    Help1: TMenuItem;
    Flow1: TMenuItem;
    Velocity1: TMenuItem;
    Depth1: TMenuItem;
    Rainfall1: TMenuItem;
    ImageList1: TImageList;
    test: TMenuItem;
    procedure Close2Click(Sender: TObject);
    procedure PrintPreview1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure AsaBitmap1Click(Sender: TObject);
    procedure AsaMetafile1Click(Sender: TObject);
    procedure AsTextdataonly1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ToggleColorScheme1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Rainfall1Click(Sender: TObject);
    procedure Depth1Click(Sender: TObject);
    procedure Velocity1Click(Sender: TObject);
    procedure Flow1Click(Sender: TObject);
    procedure testClick(Sender: TObject);
  private
    { Private declarations }
    metername: string;
    meterid: integer;
    raingaugeid: integer;
    holidays: daysArray;
    timerStart, timerEnd: TTimeStamp;
    aperatureWidth: integer;
    area: double;
    areaunitLabel, flowunitLabel, velunitLabel, depunitLabel, rainunitLabel: string;
    sewerlength: double;
    timestep: integer;
    startDay, endDay, days, maximumMove: integer;
    segmentsPerDay: integer;
    totalSegments: integer;
    rainfall: array of double;
    averageDWF: array of double;
    observedFlow: array of double;
    observedVel: array of double;
    observedDep: array of double;
    conversionToMGD, conversionToInches: double;
    //rm 2009-10-29 - accommodate area units other than acres
    conversionToAcres: double;

    doubleClicked: boolean;

    timestamp: TDateTime;
    rtimestamp: TTimeStamp;

    printing: boolean;
    handle: HDC;

    ChartFX1: TChartFX;

    private function isHoliday(date: TDateTime): boolean;
    private function dayOfWeekIndex(date: TDateTime): integer;
    private function GetDecimals(): integer;
    function ChartVisibleHeight: integer;
    function ChartVisibleWidth: integer;

    procedure ScrollLeft();
    procedure ScrollRight();
    procedure NextPage();
    procedure PreviousPage();
    procedure fillchart();
    procedure invalidateGraph();
    procedure SetColors();
    procedure DrawXAxisLabels();
    procedure DrawXAxisLabels2(x, y, w, h: Smallint);
    procedure ChartFX1PostPaint(Sender: TObject; w, h: Smallint;
  lPaint: integer; var nRes: Smallint);
    procedure SetImageIndex(Sender: TObject);

  public
    { Public declarations }
  end;

var
  frmFlowMonGraph: TfrmFlowMonGraph;

implementation

uses mainform, chooseFlowMeter;

{$R *.dfm}

procedure TfrmFlowMonGraph.AsaBitmap1Click(Sender: TObject);
begin
  ChartFX1.Export(CHART_BITMAP,'');

end;

procedure TfrmFlowMonGraph.AsaMetafile1Click(Sender: TObject);
begin
  ChartFX1.Export(CHART_METAFILE,'');

end;

procedure TfrmFlowMonGraph.AsTextdataonly1Click(Sender: TObject);
begin
  ChartFX1.Export(CHART_DATA,'');

end;

procedure TfrmFlowMonGraph.Close2Click(Sender: TObject);
begin
  Close;

end;

procedure TfrmFlowMonGraph.Flow1Click(Sender: TObject);
begin
  Flow1.Checked := not Flow1.Checked;
  ChartFX1.Series[0].Visible := Flow1.Checked;
  SetImageIndex(Sender);

end;

procedure TfrmFlowMonGraph.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ChartFX1.ClearData(CD_VALUES AND CD_XVALUES);

  Finalize(holidays);
  Finalize(averageDWF);
  Finalize(rainfall);
  Finalize(observedFlow);
  Finalize(observedVel);
  Finalize(observedDep);

end;

procedure TfrmFlowMonGraph.FormCreate(Sender: TObject);
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
    OnPostPaint := ChartFX1PostPaint;
    (*
    OnLButtonDblClk := ChartFX1LButtonDblClk;
    OnPostPaint := ChartFX1PostPaint;
    OnLButtonDown := ChartFX1LButtonDown;
    OnLButtonUp := ChartFX1LButtonUp;
    OnRButtonUp := ChartFX1RButtonUp;
    OnMouseMoving := ChartFX1MouseMoving;
    *)
  end;
end;

procedure TfrmFlowMonGraph.FormDestroy(Sender: TObject);
begin
  ChartFX1.Free;
end;

procedure TfrmFlowMonGraph.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmFlowMonGraph.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  visibleMin, visibleMax, visibleWidth, newMin, newMax: double;
  i: integer;
  found: boolean;
begin
  if (ssCtrl in Shift) then begin
    if (key = VK_RIGHT) or (key = VK_LEFT) then begin
      found := false;
      ChartFX1.Axis[AXIS_X].GetScrollView(visibleMin,visibleMax);
      if (key = VK_RIGHT) then begin
      end;
      if (key = VK_LEFT) then begin
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

procedure TfrmFlowMonGraph.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if (ssMiddle in Shift)
    then NextPage
    else ScrollRight;
  Handled := True;
end;

procedure TfrmFlowMonGraph.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if (ssMiddle in Shift)
    then PreviousPage
    else ScrollLeft;
  Handled := True;
end;

procedure TfrmFlowMonGraph.FormShow(Sender: TObject);
var
  flowStartDateTime, flowEndDateTime: TDateTime;
  maxRainfall: real;
  queryStr, raingaugename: string;
  recSet: _RecordSet;
  i: integer;
begin
  Screen.Cursor := crHourglass;
  holidays := DatabaseModule.GetHolidays();
  meterName := frmFlowMeterSelector.SelectedMeter;
  Caption := meterName;
  meterid := DatabaseModule.GetMeterIDForName(meterName);
  raingaugeid := DatabaseModule.GetRainGaugeIDForMeterID(meterid);

  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(meterName);
//  raingaugeName := DatabaseModule.
  velUnitLabel := DatabaseModule.GetVelocityUnitLabelForMeter(meterName);
  depUnitLabel := DatabaseModule.GetDepthUnitLabelForMeter(meterName);

  conversionToMGD := DatabaseModule.GetConversionForMeter(meterID);
  if (raingaugeID > -1) then begin
    conversionToInches := DatabaseModule.GetConversionForRaingauge(raingaugeID);
    raingaugename := DatabaseModule.GetRaingaugeNameForID(raingaugeID);
    rainunitLabel := DatabaseModule.GetRainUnitLabelForRaingauge(raingaugeName);
  end else begin
    conversionToInches := 1.0;
    raingaugename := '';
    rainunitLabel := 'in';
  end;

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
(* These arrays contain values for each time step *)
  //SetLength(averageDWF,totalSegments);
  SetLength(rainfall,totalSegments);
  SetLength(observedFlow,totalSegments);
  SetLength(observedVel,totalSegments);
  SetLength(observedDep,totalSegments);

{* GET RAIN DATA *}
  maxRainfall := 0.0;
  for i := 0 to totalSegments - 1 do rainfall[i] := 0.0;
  if (raingaugeid > -1) then begin
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
  end;
{* FILL IN OBSERVED FLOW *}
  queryStr := 'SELECT DateTime, Flow, Velocity, Depth FROM Flows WHERE ' +
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
      observedVel[i] := recSet.Fields.Item[2].Value;
      observedDep[i] := recSet.Fields.Item[3].Value;
    end else begin
    end;
    recSet.MoveNext;
  end;
  recSet.Close;

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
    with Axis[AXIS_Y] do begin
      TextColor := frmMain.ChartRGBText;//clWhite;
      ResetScale;
//      Title := 'Flow ('+flowUnitLabel+')';
      Title := 'Flow ('+flowUnitLabel+' - '+velUnitLabel+' - '+depUnitLabel+')';
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

    fillChart;
  end;
  Screen.Cursor := crDefault;
  SetFocus;

//rm 2010-10-23 - draw a box around the graph area
  ChartFX1.AxesStyle := 2;

//rm 2010-10-23 - found a way to fix the right Y-Axis flow unit label
//overlapping the scale
  ChartFX1.Axis[AXIS_Y2].Visible := false;
  fillchart;
  ChartFX1.Axis[AXIS_Y2].Visible := true;

end;

procedure TfrmFlowMonGraph.Help1Click(Sender: TObject);
begin
//Help!
  frmMain.HelpHandler_Universal(Self);

end;

procedure TfrmFlowMonGraph.Print1Click(Sender: TObject);
begin
  printing := true;
  try
    ChartFX1.Visible := false;
    ChartFX1.ShowDialog(CDIALOG_PRINT,0);
  finally
    printing := false;
    ChartFX1.Visible := true;
  end;

end;

procedure TfrmFlowMonGraph.PrintPreview1Click(Sender: TObject);
begin
  ChartFX1.ShowDialog(CDIALOG_PAGESETUP,0);

end;

procedure TfrmFlowMonGraph.Rainfall1Click(Sender: TObject);
begin
  Rainfall1.Checked := not Rainfall1.Checked;
  ChartFX1.Series[3].Visible := Rainfall1.Checked;
  SetImageIndex(Sender);
end;

function TfrmFlowMonGraph.isHoliday(date: TDateTime): boolean;
var
  i: integer;
begin
  isHoliday := false;
  for i := 0 to length(holidays) - 1 do begin
    if (trunc(date) = holidays[i]) then isHoliday := true;
  end;
end;


function TfrmFlowMonGraph.dayOfWeekIndex(date: TDateTime): integer;
(* returns day of week 0 = sun, 1 = mon, 2 = tues..... 6 = saturday *)
(* holidays are returned as 7 *)
var
  dow: integer;
begin
  dow := dayofweek(date) - 1;
  if (isholiday(date)) then dow := 7;
  dayOfWeekIndex := dow;
end;

procedure TfrmFlowMonGraph.fillchart;
var
  dataIndex, graphIndex, startIndex, endIndex, numseries: integer;
  commonXValue: double;
begin
  numseries := 4;
  startIndex := trunc(ChartFX1.Axis[AXIS_X].Min - startDay) * segmentsPerDay;
  endIndex := (trunc(ChartFX1.Axis[AXIS_X].Max - startDay) * segmentsPerDay) - 1;
  with ChartFX1 do begin
    Axis[AXIS_Y].ResetScale;
    OpenDataEx(COD_VALUES,numseries,endIndex-startIndex+1);
    OpenDataEx(COD_XVALUES,numseries,endIndex-startIndex+1);
    for dataIndex := startIndex to endIndex do begin
      graphIndex := dataIndex - startIndex;
      commonXValue := startDay + (dataIndex / segmentsPerDay);
      Series[0].XValue[graphIndex] := commonXValue;
      Series[0].YValue[graphIndex] := observedFlow[dataIndex];
      Series[1].XValue[graphIndex] := commonXValue;
      Series[1].YValue[graphIndex] := observedVel[dataIndex];
      Series[2].XValue[graphIndex] := commonXValue;
      Series[2].YValue[graphIndex] := observedDep[dataIndex];
      Series[3].XValue[graphIndex] := commonXValue;
      Series[3].YValue[graphIndex] := rainfall[dataIndex];
    end;
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

procedure TfrmFlowMonGraph.ScrollRight();
begin
  if (ChartFX1.Axis[AXIS_X].Max < endDay) then begin
    ChartFX1.Axis[AXIS_X].Max := ChartFX1.Axis[AXIS_X].Max + 1;
    ChartFX1.Axis[AXIS_X].Min := ChartFX1.Axis[AXIS_X].Min + 1;
    fillchart();
  end;
end;

procedure TfrmFlowMonGraph.ScrollLeft();
begin
  if (ChartFX1.Axis[AXIS_X].Min > startDay) then begin
    ChartFX1.Axis[AXIS_X].Max := ChartFX1.Axis[AXIS_X].Max - 1;
    ChartFX1.Axis[AXIS_X].Min := ChartFX1.Axis[AXIS_X].Min - 1;
    fillchart();
  end;
end;

procedure TfrmFlowMonGraph.NextPage();
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

procedure TfrmFlowMonGraph.PreviousPage();
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

procedure TfrmFlowMonGraph.invalidateGraph();
begin
  ChartFX1.OpenDataEx(COD_CONSTANTS,1,0);
  ChartFX1.CloseData(COD_CONSTANTS);
end;

procedure TfrmFlowMonGraph.SetColors;
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

    OpenDataEx(COD_COLORS,4,4);
    Series[0].Color := frmMain.ChartRGBGree;//clLime;
    Series[1].Color := frmMain.ChartRGBFlow;//clAqua;
    Series[2].Color := clRed;
    with Series[3] do begin
      Color := frmMain.ChartRGBRain;//clBlue;
      BorderColor := Color;
      YAxis := AXIS_Y2;
      Gallery := BAR;
    end;
    for i := 0 to 3 do
      Series[i].LineWidth := frmMain.ChartLineWidth;
    CloseData(COD_COLORS);

    //ChartFX1.Border := true;
    //ChartFX1.BorderColor := clBlack;

  end;
end;

procedure TfrmFlowMonGraph.ToggleColorScheme1Click(Sender: TObject);
begin
  frmMain.ToggleChartColors;
  fillchart;
end;

procedure TfrmFlowMonGraph.Velocity1Click(Sender: TObject);
begin
  Velocity1.Checked := not Velocity1.Checked;
  ChartFX1.Series[1].Visible := Velocity1.Checked;
  SetImageIndex(Sender);

end;

function TfrmFlowMonGraph.GetDecimals: integer;
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

procedure TfrmFlowMonGraph.Depth1Click(Sender: TObject);
begin
  Depth1.Checked := not Depth1.Checked;
  ChartFX1.Series[2].Visible := Depth1.Checked;
  SetImageIndex(Sender);

end;

procedure TfrmFlowMonGraph.DrawXAxisLabels();
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

procedure TfrmFlowMonGraph.DrawXAxisLabels2(x, y, w, h: Smallint);
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

function TfrmFlowMonGraph.ChartVisibleWidth: integer;
begin
 result := ChartFX1.Width - ChartFX1.LeftGap - ChartFX1.RightGap - 4;
end;

function TfrmFlowMonGraph.ChartVisibleHeight: integer;
begin
  result := ChartFX1.Height - ChartFX1.TopGap - ChartFX1.BottomGap - 4;
  if ((ChartFX1.MenuBarObj.Visible) and (ChartFX1.MenuBarObj.Docked = 256))
    then result := result - 27;
 {   if ((ChartFX1.Axis[AXIS_X].Max - ChartFX1.Axis[AXIS_X].Min) * ChartFX1.Axis[AXIS_X].PixPerUnit)
      >= (ChartFX1.Width - ChartFX1.LeftGap - ChartFX1.RightGap) then result := result - 16;     }
end;

procedure TfrmFlowMonGraph.ChartFX1PostPaint(Sender: TObject; w, h: Smallint;
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

procedure TfrmFlowMonGraph.SetImageIndex(Sender: TObject);
var mi: TMenuItem;
begin
  mi := TMenuItem(Sender);
  if mi.Checked  then begin
    mi.ImageIndex := mi.Tag * 2 - 1;
  end else begin
    mi.ImageIndex := mi.Tag * 2;
  end;
end;

procedure TfrmFlowMonGraph.testClick(Sender: TObject);
begin
//rm 2010-10-23 - found a way to fix the right Y-Axis flow unit label
//overlapping the scale
  ChartFX1.Axis[AXIS_Y2].Visible := false;
  fillchart;
  ChartFX1.Axis[AXIS_Y2].Visible := true;
end;

end.
