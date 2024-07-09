unit ScatterGraphDF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, OleCtrls, ChartfxLib_TLB, math, hydrograph, moddatabase, ADODB_TLB,
  DateUtils, StormEvent;
  {StormEvent, StormEventCollection, GWIAdjustment, GWIAdjustmentCollection;}

type
  TfrmScatterGraphDF = class(TForm)
    {ChartFX1: TChartFX;}
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    PrintPreview1: TMenuItem;
    Print1: TMenuItem;
    Edit1: TMenuItem;
    CopyToClipboard1: TMenuItem;
    AsaBitmap1: TMenuItem;
    AsaMetafile1: TMenuItem;
    AsTextdataonly1: TMenuItem;
    Help1: TMenuItem;
    ToggleColorScheme1: TMenuItem;

    procedure Close1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ChartFX1PostPaint(Sender: TObject; w, h: Smallint;
      lPaint: integer; var nRes: Smallint);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Print1Click(Sender: TObject);
    procedure PrintPreview1Click(Sender: TObject);
    procedure AsaBitmap1Click(Sender: TObject);
    procedure AsaMetafile1Click(Sender: TObject);
    procedure AsTextdataonly1Click(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ToggleColorScheme1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    {procedure ChartFX1RButtonUp(Sender: TObject; x, y : Smallint;
      var nRes: Smallint);}


  private

    currentStartDateTime, currentEndDateTime : TDateTime;
    displayOption : integer;
    depth: array of real;
    flow: array of real;

    holidays: daysArray;
    timerStart, timerEnd: TTimeStamp;
    aperatureWidth: integer;
    analysisID: integer;
    area: real;
    timestep: integer;
    startDay, endDay, days, maximumMove: integer;
    segmentsPerDay: integer;
    totalSegments: integer;
    rainfall: array of real;
    averageDWF: array of real;
    observedFlow: array of real;
    rdii: array of real;
    conversionToMGD, conversionToInches: real;

    defaultR, defaultT, defaultK : array[0..2] of real;
    rdiiCurve: array of array of real;
    rdiiTotal: array of real;

    dailygwiadj: array of real;
    gwiadj: array of real;
    diurnal: diurnalCurves;

    baseFlowRate, kMax, kRecover, iAbstraction: real;

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

    function ChartVisibleWidth: integer;
    function ChartVisibleHeight: integer;
    function ChartDateAtX(x: integer): real;
    function ChartValueAtY(y: integer): real;

    procedure DrawXAxisLabels();
    procedure invalidateGraph();
    procedure ScrollRight();
    procedure ScrollLeft();
    procedure NextPage();
    procedure PreviousPage();
    procedure DefineDisplayRange();
    procedure DefineDisplayOption();

  public { Public declarations }
    procedure fillchart();
    procedure SetColors;
  end;

var
  frmScatterGraphDF: TfrmScatterGraphDF;

implementation

uses chooseFlowMeter, eventEdit, mainform, DvsVselector;

{$R *.DFM}

procedure TfrmScatterGraphDF.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmScatterGraphDF.FormShow(Sender: TObject);
var
  i, meterID, raingaugeID: integer;
  analysisName, flowMeterName, flowUnitLabel,
  depthUnitLabel, raingaugeName, rainUnitLabel: string;
  flowStartDateTime, flowEndDateTime: TDateTime;
  maxDepth, maxFlow: real;
  queryStr: string;
  recSet: _RecordSet;
begin
  Screen.Cursor := crHourglass;
  DefineDisplayOption();
  DefineDisplayRange();


  flowMeterName := frmScatterGraphSelector.SelectedMeter;
  meterID := DatabaseModule.GetMeterIDForName(flowMeterName);
  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
  depthUnitLabel := DatabaseModule.GetDepthUnitLabelForMeter(flowMeterName);

(* Get the conversion rates for the flow and rain values *)
{  conversionToMGD := DatabaseModule.GetConversionForMeter(meterID);}
(* Get metadata about the flow data *)

  queryStr := 'SELECT StartDateTime, EndDateTime, TimeStep, Area FROM Meters ' +
              'WHERE (MeterID = ' + inttostr(meterID) + ');';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if recSet.EOF  then begin
    MessageDlg('No data for MeterID = ' + inttostr(MeterID),
      mtError,[mbok],0);
  end else begin

  recSet.MoveFirst;
  flowStartDateTime := recSet.Fields.Item[0].Value;
  flowEndDateTime := recSet.Fields.Item[1].Value;

  //rm 2008-03-05 - the following query returns flow data for ALL Meters!
  //someone left out the (MeterID = ' + inttostr(meterID) + ')' part!
//  queryStr := 'SELECT Flows.DateTime, Flows.Flow, Flows.Depth FROM FLOWS WHERE ' +
//              '(((Flows.DateTime)>' + floattostr(currentStartDateTime) + ')) AND (((Flows.DateTime)<' +
//              floattostr(currentEndDateTime) + '))';
  queryStr := 'SELECT DateTime, Flow, Depth FROM FLOWS WHERE ' +
              '((DateTime > ' + floattostr(currentStartDateTime) +
              ') AND (DateTime < ' +
              floattostr(currentEndDateTime) +
//rm 2010-05-04 - ORDER BY DATETIME
//              ') AND (MeterID = ' + inttostr(MeterID) + '))';
              ') AND (MeterID = ' + inttostr(MeterID) + ')) ORDER BY DATETIME;';

  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if no data
  if recSet.EOF then begin
     showmessage('No Data.');
     ChartFX1.Visible := false;
     Screen.Cursor := crDefault;
     exit;
  end else begin

  recSet.MoveFirst;

  i := 0;
  while (not recSet.EOF) do begin
    i := i + 1;
    recSet.MoveNext;
  end;
  recSet.MoveFirst;
  setlength(flow,i);
  setlength(depth,i);
  i := 0;
  maxDepth := 0.0;
  maxFlow := 0.0;
  while (not recSet.EOF) do begin
    depth[i] := recSet.Fields.Item[2].Value;
    if (depth[i] > maxDepth) then maxDepth := depth[i];
    flow[i] := recSet.Fields.Item[1].Value;
    if (flow[i] > maxFlow) then maxFlow := flow[i];
    recSet.MoveNext;
    i := i + 1;
  end;
  recSet.Close;

  with ChartFX1 do begin
    Align := alClient;
    RightGap := 5;
    TopGap := 5;
    AllowEdit := False;
    AllowDrag := False;
    AllowResize := False;
    Scrollable := False;
    RGBBK := frmMain.ChartRGBBK;
    MenuBarObj.Visible := False;
    {TypeMask := TypeMask OR CT_TRACKMOUSE;
    TypeEx := TypeEx OR CTE_SMOOTH;
    MarkerShape := MK_NONE;}
    ChartType := SCATTER;
    RGBFont[CHART_TOPFT ] := frmMain.ChartRGBText;
    RGBFont[CHART_XLEGFT] := frmMain.ChartRGBText;
    ChartFX1.AxesStyle := 2;

    with Axis[AXIS_X] do begin
      Min := 0.0;
      Max := maxDepth;
      {Format := 'XM/d/yy';}
      TextColor := frmMain.ChartRGBText;
      Decimals := 1;
      PixPerUnit := 100;
      Step := 1;
      Grid := True;
      Title := 'Depth ('+depthUnitLabel+ ')';
      TitleColor := frmMain.ChartRGBText;   {Hide the markers by using the same color as background}
    end;
    OpenDataEx(COD_COLORS,1,0);
    Series[0].Color := frmMain.ChartRGBYell;
    CloseData(COD_COLORS);
    with Axis[AXIS_Y] do begin
      TextColor := frmMain.ChartRGBText;
      PixPerUnit := 100;
      Grid := True;
      ResetScale;
      //Title := 'Velocity ('+flowUnitLabel+')';
      Title := 'Flow ('+flowUnitLabel+')';
      TitleColor := frmMain.ChartRGBText;
      Decimals := 1;
      {AdjustScale;}
      Min := 0.0;
      Max := (maxFlow * 1.2);
    end;

    OpenDataEx(COD_VALUES,1,i);
    OpenDataEx(COD_XVALUES,1,i);
    for I := 0 to i - 1 do begin
      Series[0].XValue[I]:= depth[I];
      Series[0].YValue[I]:= flow[I];
    end;
    CloseData(COD_VALUES);
    CloseData(COD_XVALUES);
  end;
  end;
  //rm 2009-06-24 - put in try block
  //end;
  try
    ChartFX1.Enabled := true;
    ChartFX1.Visible := true;
    ChartFX1.SetFocus;
  except
    on E: Exception do begin
      showmessage('Error in ChartFX1.SetFocus.');
      Raise E;
    end;
  end;
  end;
  Screen.Cursor := crDefault;
  {*Call SetFocus, so that the form will accept key strokes without requiring
   the user to click on the form *}
  {TextOutA(handle,ChartFX1.LeftGap + 10,ChartFX1.Height - ChartFX1.TopGap - ChartFX1.BottomGap - 4,'testtesttest',12);
  }
end;


procedure TfrmScatterGraphDF.Help1Click(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmScatterGraphDF.FormKeyDown(Sender: TObject; var Key: Word;
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
end;


procedure TfrmScatterGraphDF.ChartFX1PostPaint(Sender: TObject; w, h: Smallint;
  lPaint: integer; var nRes: Smallint);
var
  input, output: OLEVariant;
  origX, origY: integer;
begin
  ChartFX1.PaintInfo2(CPI_GETDC,0,output);
  handle := output;

  ChartFX1.PaintInfo2(CPI_PRINTINFO,0,output);
  printing := (output and $FFFF) <> 0;

  ChartFX1.PaintInfo2(CPI_POSITION,0,output);
  origX := output and $0000FFFF;
  origY := output shr 16;

{  if (not printing) then DrawXAxisLabels();
  if (GWIAdj2.Checked) then DrawGWIAdjustmentMarkers(origX, origY, w, h);
  if (Events2.Checked) then DrawEvents(origX, origY, w, h);

  input := OleVariant(handle);
  ChartFX1.PaintInfo2(CPI_RELEASEDC,input,output);}
end;

procedure TfrmScatterGraphDF.DrawXAxisLabels();
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
//rm TODO: set dow
dow := 1;
  yPos := ChartVisibleHeight + 10;
  ChartFX1.Axis[AXIS_X].GetScrollView(visibleMin,visibleMax);
  visibleDays := trunc(visibleMax - VisibleMin);
  visibleWidth := ChartVisibleWidth();
  if (visibledays > 0) then begin
    for i := trunc(visibleMin) to trunc(visibleMax) do begin
      if (dow in [1,2,3,4,5]) //rm dow is not initialized!
        then SetTextColor(handle,frmMain.ChartRGBText)
        else begin
          if (dow in [0,6])
            then SetTextColor(handle,frmMain.ChartRGBYell)
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



procedure TfrmScatterGraphDF.fillchart();
var
  dataIndex, graphIndex, startIndex, endIndex: integer;
  commonXValue: double;
begin
  startIndex := trunc(ChartFX1.Axis[AXIS_X].Min - startDay) * segmentsPerDay;
  endIndex := (trunc(ChartFX1.Axis[AXIS_X].Max - startDay) * segmentsPerDay) - 1;
  with ChartFX1 do begin
    Axis[AXIS_Y].ResetScale;
    OpenDataEx(COD_VALUES,10,endIndex-startIndex+1);
    OpenDataEx(COD_XVALUES,10,endIndex-startIndex+1);
    for dataIndex := startIndex to endIndex do begin
      graphIndex := dataIndex - startIndex;
      commonXValue := startDay + (dataIndex / segmentsPerDay);
      Series[0].XValue[graphIndex] := depth[dataIndex];
      Series[0].YValue[graphIndex] := flow[dataIndex];
    end;
    CloseData(COD_VALUES);
    CloseData(COD_XVALUES);
  end;
  SetColors;
end;



function TfrmScatterGraphDF.ChartVisibleWidth: integer;
begin
 result := ChartFX1.Width - ChartFX1.LeftGap - ChartFX1.RightGap - 4;
end;

function TfrmScatterGraphDF.ChartVisibleHeight: integer;
begin
  result := ChartFX1.Height - ChartFX1.TopGap - ChartFX1.BottomGap - 4;
  if ((ChartFX1.MenuBarObj.Visible) and (ChartFX1.MenuBarObj.Docked = 256))
    then result := result - 27;
 {   if ((ChartFX1.Axis[AXIS_X].Max - ChartFX1.Axis[AXIS_X].Min) * ChartFX1.Axis[AXIS_X].PixPerUnit)
      >= (ChartFX1.Width - ChartFX1.LeftGap - ChartFX1.RightGap) then result := result - 16;     }
end;

function TfrmScatterGraphDF.ChartDateAtX(x: integer): real;
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

function TfrmScatterGraphDF.ChartValueAtY(y: integer): real;
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

procedure TfrmScatterGraphDF.invalidateGraph();
begin
  ChartFX1.OpenDataEx(COD_CONSTANTS,1,0);
  ChartFX1.CloseData(COD_CONSTANTS);
end;




procedure TfrmScatterGraphDF.PrintPreview1Click(Sender: TObject);
begin
  ChartFX1.ShowDialog(CDIALOG_PAGESETUP,0);
end;

procedure TfrmScatterGraphDF.Print1Click(Sender: TObject);
begin
  ChartFX1.ShowDialog(CDIALOG_PRINT,0);
end;

procedure TfrmScatterGraphDF.AsaBitmap1Click(Sender: TObject);
begin
  ChartFX1.Export(CHART_BITMAP,'');
end;

procedure TfrmScatterGraphDF.AsaMetafile1Click(Sender: TObject);
begin
  ChartFX1.Export(CHART_METAFILE,'');
end;

procedure TfrmScatterGraphDF.AsTextdataonly1Click(Sender: TObject);
begin
  ChartFX1.Export(CHART_DATA,'');
end;

procedure TfrmScatterGraphDF.ScrollRight();
begin
  if (ChartFX1.Axis[AXIS_X].Max < endDay) then begin
    ChartFX1.Axis[AXIS_X].Max := ChartFX1.Axis[AXIS_X].Max + 1;
    ChartFX1.Axis[AXIS_X].Min := ChartFX1.Axis[AXIS_X].Min + 1;
    fillchart();
  end;
end;

procedure TfrmScatterGraphDF.SetColors;
begin
  with ChartFX1 do begin
    RGBBK := frmMain.ChartRGBBK;
    RGBFont[CHART_TOPFT ] := frmMain.ChartRGBText;
    RGBFont[CHART_XLEGFT] := frmMain.ChartRGBText;
    with Axis[AXIS_X] do begin
      TextColor := frmMain.ChartRGBText;
      TitleColor := frmMain.ChartRGBText;   {Hide the markers by using the same color as background}
    end;
    with Axis[AXIS_Y] do begin
      TextColor := frmMain.ChartRGBText;
      TitleColor := frmMain.ChartRGBText;
    end;
    OpenDataEx(COD_COLORS,1,0);
    Series[0].Color := frmMain.ChartRGBYell;
    CloseData(COD_COLORS);
  end;

end;

procedure TfrmScatterGraphDF.ToggleColorScheme1Click(Sender: TObject);
begin
  frmMain.ToggleChartColors;
  SetColors;
end;

procedure TfrmScatterGraphDF.ScrollLeft();
begin
  if (ChartFX1.Axis[AXIS_X].Min > startDay) then begin
    ChartFX1.Axis[AXIS_X].Max := ChartFX1.Axis[AXIS_X].Max - 1;
    ChartFX1.Axis[AXIS_X].Min := ChartFX1.Axis[AXIS_X].Min - 1;
    fillchart();
  end;
end;

procedure TfrmScatterGraphDF.NextPage();
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

procedure TfrmScatterGraphDF.PreviousPage();
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

procedure TfrmScatterGraphDF.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if (ssMiddle in Shift)
    then NextPage
    else ScrollRight;
  Handled := True;
end;


procedure TfrmScatterGraphDF.FormResize(Sender: TObject);
begin
  if ClientWidth > 8 then
    ChartFX1.Width := ClientWidth - 16;
  if Clientheight > 8 then
    ChartFX1.Height := ClientHeight - 16;
end;

procedure TfrmScatterGraphDF.DefineDisplayRange();
begin
  currentstartDateTime := frmScatterGraphSelector.StartDatePicker.Date +
                   frac(frmScatterGraphSelector.StartTimePicker.Time);
  case displayOption of
    1,2: currentEndDateTime := frmScatterGraphSelector.EndDatePicker.Date +
                 frac(frmScatterGraphSelector.EndTimePicker.Time);
    3: currentEndDateTime := incday(currentStartDateTime,7);
    4: currentEndDateTime := incday(currentStartDateTime,1);
  end;


end;


procedure TfrmScatterGraphDF.DefineDisplayOption();

begin
  if frmScatterGraphselector.entireRangeRadioButton.checked then begin
     displayOption := 1;
  end;
  if frmScatterGraphselector.specifyRangeRadioButton.checked then begin
     displayOption := 2;
  end;
  if frmScatterGraphselector.weeklyDisplayRadioButton.checked then begin
     displayOption := 3;
  end;
  if frmScatterGraphselector.dailyDisplayRadioButton.checked then begin
     displayOption := 4;
  end;
end;





procedure TfrmScatterGraphDF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (frmEventEdit.visible) then frmEventEdit.Close;

  ChartFX1.ClearData(CD_VALUES AND CD_XVALUES);


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

end;




procedure TfrmScatterGraphDF.FormCreate(Sender: TObject);
begin
  ChartFX1:=TChartFX.Create(Self);
  with ChartFX1 do begin
    Parent := Self;
    Left := 8;
    Top := 8;
    Width := 577;
    Height := 583;
    TabOrder := 8;
    visible := true;
    Chart3D := false;
  end;
  ChartFX1.Title[0] := 'Depth vs Flow Scattergraph';
end;

procedure TfrmScatterGraphDF.FormDestroy(Sender: TObject);
begin
//  ChartFX1.Free;
end;

end.
