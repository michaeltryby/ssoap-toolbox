unit RDIIGraphFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ChartfxLib_TLB, Analysis, StormEvent, StormEventCollection,
  rdiiutils, Math, ADODB_TLB, mainform, RTKPatternFrame;

type
  TFrameRDIIGraph = class(TFrame)
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    totalRDII : array of array of double;
    rdiiCurve: array of array of double;
    rdiiTotal: array of double;
    rainfall: array of array of double;
    rainTotal, rainMax: array of double;
    ChartFX1: TChartFX;
    boHasEdits_in_RTKs: boolean;
    startDay, endDay, days: integer;
    timestamp: TDateTime;
    rtimestamp: TTimeStamp;
    iSewerShedID, iMeterID, iAnalysisID: integer;
    sMeterName: string;
    dSewerShedArea: double;
    segmentsPerDay: integer;
//    timestepsToAverage,
//    totalSegments: integer;
//    runningAverageDuration: double;
    decimalPlaces: integer;
    rdeltime: integer;
    FNumAreas : integer;  //number of areas
    FNumGauges : integer; //number of raingauges
    RainGaugeIndices: array[0..99] of integer; //array of RainGauge IDs
    RainGaugeIndexLookup: array of integer; //[0..NumAreas] - array of pointers to above
    FR, FT, FK: array of array of double; //[0..2,0..NumAreas]
    FA: array of double;  //areas
    FS: array of string;  //sewershed names
    FL: array of string;  //loadpoints
    FG: array of integer; //raingauge ids
  //rm 2010-10-01 - now array of array
    //FAI: array of double; //Initial Abstraction Used
    //FAM: array of double; //Max Abstraction
    //FAR: array of double; //Abstraction Recovery
    FAI: array of array of double; //Initial Abstraction Used   //[0..2,0..NumAreas]
    FAM: array of array of double; //Max Abstraction            //[0..2,0..NumAreas]
    FAR: array of array of double; //Abstraction Recovery       //[0..2,0..NumAreas]
    //rm 2010-09-27
    FM: array of integer;
    FAnalysis: TAnalysis;
    FSewerShedName: string;
    FAnalysisName: string;
    FFlowUnitLabel: string;
    FRainUnitLabel: string;
    FAreaUnitLabel: string;
    FTimeStep: integer;
    FConversion2MGD: double;
    FConversion2Inches: double;
    FConversion2Acres: double;
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FTitle: string;
    FRaingaugeName: string;
    FNumTimeSteps: integer;
    FUseRGDates: boolean;
    procedure PutR (Index1, Index2: integer; value: double);
    function GetR (Index1, Index2: integer): double;
    procedure PutT (Index1, Index2: integer; value: double);
    function GetT (Index1, Index2: integer): double;
    procedure PutK (Index1, Index2: integer; value: double);
    function GetK (Index1, Index2: integer): double;
    procedure SetSewerShedName(const Value: string);
    procedure SetAnalysisName(const Value: string);
    procedure SetFlowUnitLabel(const Value: string);
    procedure SetRainUnitLabel(const Value: string);
    procedure SetAreaUnitLabel(const Value: string);
    procedure CalculateRDIICurve(idx : integer);
    procedure SetTimeStep(const Value: integer);
    procedure SetConversion2MGD(const Value: double);
    procedure SetConversion2Inches(const Value: double);
    procedure FillChart();
    procedure SetStartDate(const Value: TDateTime);
    procedure SetEndDate(const Value: TDateTime);
    procedure SetArea(const Value: double);
    procedure SetTitle(const Value: string);
    procedure SetRaingaugeName(const Value: string);
    function GetA(Index2: integer): double;
    procedure PutA(Index2: integer; const Value: double);
    function GetS(Index2: integer): string;
    procedure PutS(Index2: integer; const Value: string);
    function GetL(Index2: integer): string;
    procedure PutL(Index2: integer; const Value: string);
    procedure SetNumAreas(const Value: integer);
    function GetFlow(areaNum, timeNum: integer): double;
//rm 2010-10-05    function GetAI(Index2: integer): double;
//rm 2010-10-05    function GetAM(Index2: integer): double;
//rm 2010-10-05    function GetAR(Index2: integer): double;
//rm 2010-10-05    procedure PutAI(Index2: integer; const Value: double);
//rm 2010-10-05    procedure PutAM(Index2: integer; const Value: double);
//rm 2010-10-05    procedure PutAR(Index2: integer; const Value: double);
    function GetAI(Index1, Index2: integer): double;
    function GetAM(Index1, Index2: integer): double;
    function GetAR(Index1, Index2: integer): double;
    procedure PutAI(Index1, Index2: integer; const Value: double);
    procedure PutAM(Index1, Index2: integer; const Value: double);
    procedure PutAR(Index1, Index2: integer; const Value: double);
    //procedure SetNumGauges(const Value: integer);
    function GetG(Index2: integer): integer;
    procedure PutG(Index2: integer; const Value: integer);
    procedure SetUseRGDates(const Value: boolean);
    //rm 2009-11-02 - new function to set precision of the Y-Axis
    function GetDecimals: integer;
    //rm 2010-09-27 - RTK Pattern month
    procedure PutM(Index2: integer; const Value: integer);
    function GetM(Index2: integer): integer;
  public
    { Public declarations }
    function KTMax: double;
    procedure SetRTKPatternFromRTKPatternFrame(
      rtkPatternFrame: TFrameRTKPattern; n: integer);
    property R[Index1, Index2: integer]: double       //[0..2,0..n]
      read GetR write PutR;
    property T[Index1, Index2: integer]: double
      read GetT write PutT;
    property K[Index1, Index2: integer]: double
      read GetK write PutK;
    property A[Index2: integer]: double
      read GetA write PutA;
    property S[Index2: integer]: string
      read GetS write PutS;
    property L[Index2: integer]: string
      read GetL write PutL;
    property G[Index2: integer]: integer
      read GetG write PutG;
//rm 2010-10-05    property AI[Index2: integer]: double
//rm 2010-10-05      read GetAI write PutAI;
//rm 2010-10-05    property AM[Index2: integer]: double
//rm 2010-10-05      read GetAM write PutAM;
//rm 2010-10-05    property AR[Index2: integer]: double
//rm 2010-10-05      read GetAR write PutAR;
    property AI[Index1, Index2: integer]: double
      read GetAI write PutAI;
    property AM[Index1, Index2: integer]: double
      read GetAM write PutAM;
    property AR[Index1, Index2: integer]: double
      read GetAR write PutAR;
    //2010-09-27 RTK pattern Month
    property M[Index2: integer]: integer
      read GetM write PutM;
    property SewerShedName: string read FSewerShedName write SetSewerShedName;
    property AnalysisName: string read FAnalysisName write SetAnalysisName;
    property RainGaugeName: string read FRaingaugeName write SetRaingaugeName;
    property FlowUnitLabel: string read FFlowUnitLabel write SetFlowUnitLabel;
    property RainUnitLabel: string read FRainUnitLabel write SetRainUnitLabel;
    property AreaUnitLabel: string read FAreaUnitLabel write SetAreaUnitLabel;
    property TimeStep: integer read FTimeStep write SetTimeStep;
    property NumTimeSteps: integer read FNumTimeSteps;
    property StartDate: TDateTime read FStartDate write SetStartDate;
    property EndDate: TDateTime read FEndDate write SetEndDate;
    property Area: double write SetArea;
    property Title: string read FTitle write SetTitle;
    property NumAreas: integer read FNumAreas write SetNumAreas;
    property Flow[areaNum, timeNum: integer]: double read GetFlow;// write SetFlow;
    procedure ClearAll();
    procedure UpdateData();
    procedure RedrawChart();
  end;

implementation

uses modDatabase;

{$R *.dfm}

procedure TFrameRDIIGraph.FrameResize(Sender: TObject);
begin
  //use this as the oncreate - only once
  if not Assigned(ChartFX1) then
  begin
    ChartFX1:=TChartFX.Create(Self);
    with ChartFX1 do begin
      Parent := Self;
      Left := Parent.Padding.Left;
      Top := Parent.Padding.Top;
      TabOrder := 0;
      visible := true;
      Chart3D := false;
    end;
    //default to one area
    NumAreas := 1;
    FNumGauges := 0;
    FConversion2MGD := 1.0;
    FConversion2Inches := 1.0;
    FConversion2Acres := 1.0;
  end;
  if Assigned(ChartFX1) then begin
    ChartFX1.Width := Self.ClientWidth;
    ChartFX1.Height := Self.ClientHeight;
  end;
end;

procedure TFrameRDIIGraph.RedrawChart();
var
    //titleChart : string;
    //txt : string;
    i: integer;
begin
  if Assigned(ChartFX1) then begin
  with ChartFX1 do begin
{    Align := alClient;}
    {Align := alRight;}
    RightGap := 5;
    TopGap := 5;
    AllowEdit := False;
    AllowDrag := False;
    AllowResize := False;
    Scrollable := true;
    RGBFont[CHART_TOPFT] := frmMain.ChartRGBText;
    RGBBK := frmMain.ChartRGBBK;//clBlack;
    BorderColor := frmMain.ChartRGBText;
    ChartFX1.AxesStyle := 2;
    MenuBarObj.Visible := False;
    {TypeMask := TypeMask OR CT_TRACKMOUSE;}
    TypeEx := TypeEx OR CTE_SMOOTH;
    MarkerShape := MK_NONE;
    ChartType := LINES;
    Title[CHART_TOPTIT] := FTitle;

    with Axis[AXIS_X] do begin
      Min := startDay;
      Max := endDay;
      //Format := 'XM/d/yy';
      Format := 'XM/d/yy HH:mm';
      PixPerUnit := 100;
      Step := 1;
      Grid := True;
      TextColor := frmMain.ChartRGBText; //clWhite;   {Hide the markers by using the same color as background}
    end;

    with Axis[AXIS_Y] do begin
      TextColor := frmMain.ChartRGBText; //clWhite;
if rainMax[0] > 0 then ResetScale;
      Title := 'Flow ('+FlowUnitLabel+')';
      TitleColor := frmMain.ChartRGBText; //clWhite;
      //Decimals := 1;
      Decimals := 4;
    end;
    // - rainfall axis
    with Axis[AXIS_Y2] do begin
      TextColor := frmMain.ChartRGBText; //clWhite;
if rainMax[0] > 0 then ResetScale;
      Title := 'Rainfall ('+RainUnitLabel+')';
      TitleColor := frmMain.ChartRGBText; //clWhite;
      //Min := ceil(rainMax);
      Min := ceil(rainMax[0]);
      if Min = 0 then Min := 0.001;
      Max := 0;
      Decimals := 1;
    end;

    FillChart();
    OpenDataEx(COD_COLORS,FNumAreas+1,0);//FNumAreas+1);
      for i := 0 to FNumAreas - 1 do
        Series[i].Color := frmMain.ChartRGBFlow;  //clAqua;
      // - rainfall
      with Series[FNumAreas] do begin
        Color := frmMain.ChartRGBRain; //clBlue;
        YAxis := AXIS_Y2;
        Gallery := BAR;
      end;

    CloseData(COD_COLORS);
{
    SetTextAlign(handle,TA_LEFT or TA_TOP);
     font := TFont.Create;
     font.name := 'Arial';
     font.Color := frmMain.ChartRGBText;//clWhite;
     SetTextAlign(handle,TA_CENTER);
     TextOutA(handle,ChartFX1.LeftGap + 10,
     ChartFX1.Height - ChartFX1.TopGap - ChartFX1.BottomGap - 4,
     pchar(FTitle),12);
}
  end;
  end;
end;

procedure TFrameRDIIGraph.PutR(index1, index2: integer; value: double);
begin
  FR[index1, index2] := value;
end;

procedure TFrameRDIIGraph.PutS(Index2: integer; const Value: string);
begin
  FS[index2] := value;
end;

function TFrameRDIIGraph.GetR(index1, index2: integer): double;
begin
  GetR := FR[index1, index2];
end;

function TFrameRDIIGraph.GetS(Index2: integer): string;
begin
  GetS := FS[index2];
end;

procedure TFrameRDIIGraph.PutT(index1, index2: integer; value: double);
begin
  FT[index1, index2] := value;
end;

function TFrameRDIIGraph.GetT(index1, index2: integer): double;
begin
  GetT := FT[index1, index2];
end;

function TFrameRDIIGraph.KTMax: double;
//return the max timebase of the unit hydrograph(s)
var i,j: integer;
  test, maxKT: double;
begin
  maxKT := 0;
  for i := 0 to FNumAreas - 1 do begin
    for j := 0 to 2 do begin
      test := (T[j,i] + 1) * K[j,i];
      if test > maxKT then maxKT := test;
    end;
  end;
  Result := maxKT / 24.0;
end;

procedure TFrameRDIIGraph.PutA(Index2: integer; const Value: double);
begin
  FA[index2] := value;
end;

procedure TFrameRDIIGraph.PutAI(Index1, Index2: integer; const Value: double);
begin
  FAI[Index1, Index2] := Value;
end;

procedure TFrameRDIIGraph.PutAM(Index1, Index2: integer; const Value: double);
begin
  FAM[Index1, Index2] := Value;
end;

procedure TFrameRDIIGraph.PutAR(Index1, Index2: integer; const Value: double);
begin
  FAR[Index1, Index2] := Value;
end;

procedure TFrameRDIIGraph.PutG(Index2: integer; const Value: integer);
var i: integer;
begin
  FG[Index2] := Value;
  RainGaugeIndexLookup[Index2] := -1;
  i := -1;
  repeat
    inc(i);
  until (i = High(RainGaugeIndices)) or (RainGaugeIndices[i] = FG[Index2]);
  if (i = High(RainGaugeIndices)) then begin //this raingaugeid is not in list of indices
    //find the next empty slot for it
    i := -1;
    repeat
      inc(i);
    until (i = High(RainGaugeIndices)) or (RainGaugeIndices[i] = -1);
    if i < High(RainGaugeIndices) then begin
      RainGaugeIndices[i] := FG[Index2];
      RainGaugeIndexLookup[Index2] := i;
      FNumGauges := i + 1;
    end;
  end else if (RainGaugeIndices[i] = FG[Index2]) then begin
    RainGaugeIndexLookup[Index2] := i;
  end;
end;

procedure TFrameRDIIGraph.PutK(index1, index2: integer; value: double);
begin
  FK[index1, index2] := value;
end;

procedure TFrameRDIIGraph.PutL(Index2: integer; const Value: string);
begin
  FL[index2] := value;
end;

procedure TFrameRDIIGraph.PutM(Index2: integer; const Value: integer);
begin
  FM[index2] := value;
end;

function TFrameRDIIGraph.GetA(Index2: integer): double;
begin
  GetA := FA[index2];
end;

function TFrameRDIIGraph.GetAI(Index1, Index2: integer): double;
begin
  GetAI := FAI[Index1, Index2];
end;

function TFrameRDIIGraph.GetAM(Index1, Index2: integer): double;
begin
  GetAM := FAM[Index1, Index2];
end;

function TFrameRDIIGraph.GetAR(Index1, Index2: integer): double;
begin
  GetAR := FAR[Index1, Index2];
end;

//rm 2009-11-02 - new function
      //rm 2009-11-02 - just noticed that the default Major Units can be something
      //like 0.11, which, when combined with Decimals of 1 can be misleading.
      //e.g. the Y-axis marker named "0.3" might actually be "0.33"
      //so lets set decimals based on the Log10 of the range of Y-values
function TFrameRDIIGraph.GetDecimals: integer;
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

function TFrameRDIIGraph.GetFlow(areaNum, timeNum: integer): double;
begin
  Result := totalRDII[areaNum, timeNum];
end;

function TFrameRDIIGraph.GetG(Index2: integer): integer;
begin
  GetG := FG[Index2];
end;

function TFrameRDIIGraph.GetK(index1, index2: integer): double;
begin
  GetK := FK[index1, index2];
end;

function TFrameRDIIGraph.GetL(Index2: integer): string;
begin
  GetL := FL[index2];
end;

function TFrameRDIIGraph.GetM(Index2: integer): integer;
begin
   GetM := FM[index2];
end;

procedure TFrameRDIIGraph.SetAnalysisName(const Value: string);
var iRainGaugeID: integer;
begin
  FAnalysisName := Value;
  iAnalysisID := DatabaseModule.GetAnalysisIDForName(FAnalysisName);
  FAnalysis := DatabaseModule.GetAnalysis(FAnalysisName);
  iRainGaugeID := FAnalysis.RaingaugeID;
  SetRainGaugeName(DatabaseModule.GetRaingaugeNameForID(iRainGaugeID));
  iMeterID := FAnalysis.FlowMeterID;
  sMeterName := DatabaseModule.GetFlowMeterNameForID(iMeterID);
  timestep := DatabaseModule.GetFlowTimestep(iMeterID);
  segmentsPerDay := 1440 div timeStep;
//  runningAverageDuration := FAnalysis.RunningAverageDuration;
//  timestepsToAverage := round(runningAverageDuration*60/timestep);
  rdeltime := DatabaseModule.GetRainfallTimestep(iRainGaugeID);
  FConversion2MGD := DatabaseModule.GetConversionForMeter(iMeterID);
  FFlowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(smeterName);
  FConversion2Inches := DatabaseModule.GetConversionForRaingauge(iRaingaugeID);
//TODO:
  FConversion2Acres := DatabaseModule.GetConversionFactorForAreaUnitLabel(FFlowUnitLabel);
  decimalPlaces := DatabaseModule.GetRainfallDecimalPlacesForRaingauge(FRainGaugeName);
  FRainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(FRainGaugeName);

end;

procedure TFrameRDIIGraph.SetArea(const Value: double);
begin
//for those with only one graph
//  FArea := Value;
  FA[0] := Value;
end;

procedure TFrameRDIIGraph.SetAreaUnitLabel(const Value: string);
begin
  FAreaUnitLabel := Value;
//TODO:
  FConversion2Acres := DatabaseModule.GetConversionFactorForAreaUnitLabel(Value);
end;

procedure TFrameRDIIGraph.SetConversion2Inches(const Value: double);
begin
  FConversion2Inches := Value;
end;

procedure TFrameRDIIGraph.SetConversion2MGD(const Value: double);
begin
  FConversion2MGD := Value;
end;

procedure TFrameRDIIGraph.SetEndDate(const Value: TDateTime);
begin
  FEndDate := Value;
end;

procedure TFrameRDIIGraph.SetFlowUnitLabel(const Value: string);
begin
  FFlowUnitLabel := Value;
  FConversion2MGD := DatabaseModule.GetConversionFactorForFlowUnitLabel(Value);
end;

procedure TFrameRDIIGraph.SetNumAreas(const Value: integer);
begin
  FNumAreas := Value;
  setlength(FR,3,FNumAreas);
  setlength(FT,3,FNumAreas);
  setlength(FK,3,FNumAreas);//: array of array of double;
  setlength(FA,FNumAreas);//: array of double;    //areas
  setlength(FS,FNumAreas);//: array of string;  //sewershed names
  setlength(FL,FNumAreas);//: array of string;  //rtk links
  setlength(FG,FNumAreas);//: array of integer; //raingauge ids
  //setlength(FAI,FNumAreas);
  //setlength(FAM,FNumAreas);
  //setlength(FAR,FNumAreas);
  setlength(FAI,3,FNumAreas);
  setlength(FAM,3,FNumAreas);
  setlength(FAR,3,FNumAreas);
  setlength(RainGaugeIndexLookup, FNumAreas);
  //rm 2010-09-27
  setlength(FM, FNumAreas); // array of integers for rtk pattern month
end;

(*
procedure TFrameRDIIGraph.SetNumGauges(const Value: integer);
var i: integer;
begin
  FNumGauges := Value;
  setlength(rainTotal, FNumGauges);
  setlength(rainMax, FNumGauges);
  //setlength(RainGaugeIndices, FNumGauges);
  for i := 0 to high(RainGaugeIndices) do RainGaugeIndices[i] := -1;
end;
*)
procedure TFrameRDIIGraph.SetRaingaugeName(const Value: string);
var i,iRainGaugeID: integer;
begin
  FRaingaugeName := Value;
  iRainGaugeID := DatabaseModule.GetRaingaugeIDForName(FRaingaugeName);
  FNumGauges := 1;
  //FG[0] := iRainGaugeID;
  for i := 0 to high(RainGaugeIndices) do RainGaugeIndices[i] := -1;
  PutG(0,iRainGaugeID);
  timestep := DatabaseModule.GetRainfallTimestep(iRainGaugeID);
  segmentsPerDay := 1440 div timeStep;
//  runningAverageDuration := FAnalysis.RunningAverageDuration;
//  timestepsToAverage := round(runningAverageDuration*60/timestep);
  rdeltime := DatabaseModule.GetRainfallTimestep(iRainGaugeID);
  FConversion2Inches := DatabaseModule.GetConversionForRaingauge(iRaingaugeID);
  FRainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(FRaingaugeName);
  decimalPlaces := DatabaseModule.GetRainfallDecimalPlacesForRaingauge(FRainGaugeName);
end;

procedure TFrameRDIIGraph.SetRainUnitLabel(const Value: string);
begin
  FRainUnitLabel := Value;
  FConversion2Inches := DatabaseModule.GetConversionFactorForRainUnitLabel(Value); 
end;

procedure TFrameRDIIGraph.SetRTKPatternFromRTKPatternFrame(
  rtkPatternFrame: TFrameRTKPattern; n: integer);
begin
  R[0,n] := rtkPatternFrame.R1;
  T[0,n] := rtkPatternFrame.T1;
  K[0,n] := rtkPatternFrame.K1;
  R[1,n] := rtkPatternFrame.R2;
  T[1,n] := rtkPatternFrame.T2;
  K[1,n] := rtkPatternFrame.K2;
  R[2,n] := rtkPatternFrame.R3;
  T[2,n] := rtkPatternFrame.T3;
  K[2,n] := rtkPatternFrame.K3;
  AI[0,n] := rtkPatternFrame.AI;
  AM[0,n] := rtkPatternFrame.AM;
  AR[0,n] := rtkPatternFrame.AR;
  //rm 2010-10-5
  AI[1,n] := rtkPatternFrame.AI2;
  AM[1,n] := rtkPatternFrame.AM2;
  AR[1,n] := rtkPatternFrame.AR2;
  AI[2,n] := rtkPatternFrame.AI3;
  AM[2,n] := rtkPatternFrame.AM3;
  AR[2,n] := rtkPatternFrame.AR3;
  //rm 2010-09-27
  M[n] := rtkPatternFrame.Mon;
end;

procedure TFrameRDIIGraph.SetSewerShedName(const Value: string);
var iRainGaugeID, iAreaUnitID: integer;
begin
  FSewerShedName := Value;
  iSewerShedID := DatabaseModule.GetSewershedIDForName(FSewerShedName);
  iRainGaugeID := DatabaseModule.GetRainGaugeIDforSewershedID(iSewerShedID);
  SetRainGaugeName(DatabaseModule.GetRaingaugeNameForID(iRainGaugeID));
  dSewerShedArea := DatabaseModule.GetSewerShedArea(iSewerShedID);
  iAreaUnitID := DatabaseModule.GetAreaUnitIDForSewershed(iSewerShedID);
  //TODO:
  FConversion2Acres := DatabaseModule.GetConversionFactorForAreaUnitID(iAreaUnitID);
end;

procedure TFrameRDIIGraph.SetStartDate(const Value: TDateTime);
begin
  FStartDate := Value;
end;

procedure TFrameRDIIGraph.SetTimeStep(const Value: integer);
begin
  FTimeStep := Value;
end;

procedure TFrameRDIIGraph.SetTitle(const Value: string);
begin
  FTitle := Value;

end;

procedure TFrameRDIIGraph.SetUseRGDates(const Value: boolean);
begin
  FUseRGDates := Value;
end;

procedure TFrameRDIIGraph.UpdateData;
var
  i,j: integer;
  queryStr: string;
  recSet: _RecordSet;

begin
  startDay := Floor(StartDate);
  endDay := Ceil(EndDate);
  days := endDay - startDay;
  if days < 1 then days := 1;

  segmentsPerDay := 1440 div timeStep;
  FNumTimeSteps := days * segmentsPerDay;
  SetLength(rainfall,0,0);
  SetLength(raintotal,0);
  SetLength(rainmax,0);
  SetLength(rdiiCurve,0,0);
  SetLength(rdiiTotal,0);
  SetLength(rainfall,FNumGauges,FNumTimeSteps);
  SetLength(raintotal,FNumGauges);
  SetLength(rainmax,FNumGauges);
  SetLength(rdiiCurve,3,FNumTimeSteps);
  SetLength(rdiiTotal,FNumTimeSteps);
  for i := 0 to FNumTimeSteps - 1 do begin
    rdiiTotal[i] := 0;
  end;
  for j := 0 to FNumGauges - 1 do begin
    for i := 0 to FNumTimeSteps - 1 do rainfall[j,i] := 0.0;
    queryStr := 'SELECT DateTime, Volume FROM Rainfall WHERE ' +
                '((RaingaugeID = ' + inttostr(RainGaugeIndices[j]) + ') AND ' +
                '(DateTime >= ' + floattostr(StartDate) + ' AND ' +
                'DateTime <= ' + floattostr(EndDate) + '))';
                //rm 2007-10-22 ORDER BY DATETIME
    queryStr := queryStr + ' ORDER BY [DATETIME];';
    recSet := CoRecordSet.Create;
    recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
    if recset.EOF then
    begin
      //MessageDlg('No rainfall in the specified time period.',mtInformation,[mbok],0);
    end else
    begin
      recSet.MoveFirst;
      while (not recSet.EOF) do begin
        timestamp := recSet.Fields.Item[0].Value;
        rtimestamp := DateTimeToTimeStamp(timestamp);
        i := (trunc(timestamp) - startday) * segmentsPerDay;
        i := i + trunc((rtimestamp.time / MSecsPerDay) * segmentsPerDay);
        if i < FNumTimeSteps then begin
          rainfall[j,i] := recSet.Fields.Item[1].Value;
          rainTotal[j] := rainTotal[j] + rainfall[j,i];
          if (rainfall[j,i] > rainMax[j]) then
            rainMax[j] := rainfall[j,i];
        end else begin
          //showmessage(inttostr(i) + ' is greater than ' + inttostr(FNumTimeSteps-1));
        end;
        recSet.MoveNext;
      end;
    end;
    recSet.Close;
  end;

  setLength(totalRDII,0,0);
  setLength(totalRDII,FNumAreas,FNumTimeSteps);
  for j := 0 to FNumAreas - 1 do begin
    CalculateRDIICurve(j);
    for i := 0 to FNumTimeSteps - 1 do
      totalRDII[j,i] := rdiitotal[i];
  end;
end;

//rm 2007-11-01 trying to get abstraction to work
//Here is the code from SWMM5 5.0.0.011 dated 2007-07-16:
(*
double  applyIA(int j, DateTime aDate, double dt, double rainDepth)
//
//  Input:   j = UH group index
//           aDate = current date/time
//           dt = time interval (sec)
//           rainDepth = unadjusted rain depth (in or mm)
//  Output:  returns rainfall adjusted for initial abstraction (IA)
//  Purpose: adjusts rainfall for any initial abstraction and updates the
//           amount of available initial abstraction actually used.
//
{
    int m;
    double ia, netRainDepth;

    // --- determine amount of unused IA
    m = datetime_monthOfYear(aDate) - 1;
    ia = UnitHyd[j].ia[m][IA_MAX] - UHData[j].iaUsed;
    ia = MAX(ia, 0.0);

    // --- case where there's some rainfall
    if ( rainDepth > 0.0 )
    {
        // --- reduce rain depth by unused IA
        netRainDepth = rainDepth - ia;
        netRainDepth = MAX(netRainDepth, 0.0);

        // --- update amount of IA used up
        ia = rainDepth - netRainDepth;
        UHData[j].iaUsed += ia;
    }

    // --- case where there's no rainfall
    else
    {
        // --- recover a portion of the IA already used
        UHData[j].iaUsed -= dt / 86400. * UnitHyd[j].ia[m][IA_REC];
        UHData[j].iaUsed = MAX(UHData[j].iaUsed, 0.0);
        netRainDepth = 0.0;
    }
    return netRainDepth;
}
*)

procedure TFrameRDIIGraph.CalculateRDIICurve(idx: integer);
const
  conversionFromAcreInchesPerHourToMGD = (43560.0*7.481*24.0)/(12.0*1000000.0);
var
  i, j, m, n, index, timestepsPerHour : integer;
  day, qpeak, flow, rain: double; //, {prevRainDate,}
//rm 2010-10-05  abstraction_available, abstraction_used, excess, recovery: double;
  abstraction_available, abstraction_used, excess, recovery: array[0..2] of double;
  event: TStormEvent;
  iRGIdx : integer;
  F: textfile;

begin
//rm 2008-05-15
{
  assignfile(f,'c:\temp\IATest.csv');
  rewrite(F);
  writeln(F, 'rainfall, excess, recovery, ia_avail, ia_used');
}
//rm 2010-10-05  recovery := 0;
for m := 0 to 2 do
  recovery[m] := 0;
//rm
  for i := 0 to FNumTimeSteps - 1 do begin
    for j := 0 to 2 do begin
      rdiiCurve[j,i] := 0.0;
    end;
  end;
  timestepsPerHour := 60 div timestep;
//rm 2010-10-05  abstraction_available := FAM[idx] - FAI[idx];   //max - initial abstraction
//rm 2010-10-05  abstraction_available := max(abstraction_available, 0.0);
//rm 2010-10-05  abstraction_used := FAM[idx] - abstraction_available;
for m := 0 to 2 do begin
  abstraction_available[m] := FAM[m,idx] - FAI[m,idx];   //max - initial abstraction
  abstraction_available[m] := max(abstraction_available[m], 0.0);
  abstraction_used[m] := FAM[m,idx] - abstraction_available[m];
end;
//  prevRainDate := 0;
  iRGIdx := RainGaugeIndexLookup[idx];
  //rm 2007-10-22 - what if iRGIdx <= 0 ???   (unassigned)
  if iRGIdx > High(rainfall) then begin
    MessageDlg('Raingauge unassigned!',mtinformation,[mbok],0);
  end else begin
  for i := 0 to days - 1 do begin
    for j := 0 to segmentsPerDay - 1 do begin
      index := (i * segmentsPerDay) + j;
      rain := rainfall[iRGIdx,index];
//rm 2010-10-05
//ia = UnitHyd[j].ia[m][IA_MAX] - UHData[j].iaUsed;
//ia = MAX(ia, 0.0);
//rm 2010-10-05      abstraction_available := FAM[idx] - abstraction_used;
//rm 2010-10-05      abstraction_available := max(abstraction_available, 0.0);
for m := 0 to 2 do begin
      abstraction_available[m] := FAM[m,idx] - abstraction_used[m];
      abstraction_available[m] := max(abstraction_available[m], 0.0);
end;
      if (rain > 0) then begin
//rm 2010-10-05        recovery := 0;
for m := 0 to 2 do begin
        recovery[m] := 0;
//        day := (startDay + i) + (j / segmentsPerDay);
//        if (prevRainDate = 0) then prevRainDate := day;
// --- reduce rain depth by unused IA
//netRainDepth = rainDepth - ia;
//rm 2010-10-05        excess := rain - abstraction_available;
//rm 2010-10-05        excess := max(excess, 0.0);
        excess[m] := rain - abstraction_available[m];
        excess[m] := max(excess[m], 0.0);
//netRainDepth = MAX(netRainDepth, 0.0);
// --- update amount of IA used up
//ia = rainDepth - netRainDepth;
//        abstraction_available := rain - excess;
//UHData[j].iaUsed += ia;
//        abstraction_used := abstraction_used + abstraction_available;
//rm 2010-10-05        abstraction_used := abstraction_used + rain - excess;
        abstraction_used[m] := abstraction_used[m] + rain - excess[m];
//rm 2010-10-15 - left this bad boy out:
        abstraction_used[m] := min(abstraction_used[m], FAM[m,idx]);
//        abstraction_used := min(abstraction_used, FAM[idx]);
end;
        {calculate each composite RDII curve at this instant}
//rm 2010-10-05        if (excess > 0.0) then begin
//rm 2010-10-05          for m := 0 to 2 do begin
        for m := 0 to 2 do begin
          if (excess[m] > 0.0) then begin
            if ((R[m,idx] > 0.0) and (T[m,idx] > 0.0) and (K[m,idx] > 0.0)) then begin
              qpeak := R[m,idx]*2.0*A[idx]/(T[m,idx]*(1+K[m,idx]))
                       *conversionFromAcreInchesPerHourToMGD
                       /FConversion2MGD
                       *FConversion2Inches
                       *FConversion2Acres;
              for n := 0 to trunc(T[m,idx] * (K[m,idx] + 1) * timestepsPerHour) do begin
                if (index + n < FNumTimeSteps) then begin
                  if (n <= T[m,idx] * timestepsPerHour)
//rm 2010-10-05                    then flow := (n / (T[m,idx] * timestepsPerHour)) * qpeak * excess
//rm 2010-10-05                    else flow := (1.0 - ((n-(T[m,idx]*timestepsPerHour) )/(K[m,idx]*T[m,idx]*timestepsPerHour))) * qpeak * excess;
                    then flow := (n / (T[m,idx] * timestepsPerHour)) * qpeak * excess[m]
                    else flow := (1.0 - ((n-(T[m,idx]*timestepsPerHour) )/(K[m,idx]*T[m,idx]*timestepsPerHour))) * qpeak * excess[m];
                  rdiiCurve[m,index+n] := rdiiCurve[m,index+n] + flow;
                end;
              end;
            end;
          end;
        end;
      end else begin //no rain - recover some abstraction volume
// --- recover a portion of the IA already used
//UHData[j].iaUsed -= dt / 86400. * UnitHyd[j].ia[m][IA_REC];
//UHData[j].iaUsed = MAX(UHData[j].iaUsed, 0.0);
//showmessage( 'timestep = ' + floattostr(timestep) + ' abs_used = ' + floattostr(abstraction_used));
//rm 2010-10-05        excess := 0;
//rm 2010-10-05        recovery := ((timestep/1440.0) * FAR[idx]);
//rm 2010-10-05        abstraction_used := abstraction_used - recovery;
//rm 2010-10-05        abstraction_used := max(abstraction_used, 0.0);
for m := 0 to 2 do begin
        excess[m] := 0;
        recovery[m] := ((timestep/1440.0) * FAR[m,idx]);
        abstraction_used[m] := abstraction_used[m] - recovery[m];
        abstraction_used[m] := max(abstraction_used[m], 0.0);
end;
//showmessage( 'timestep = ' + floattostr(timestep) + ' abs_used = ' + floattostr(abstraction_used));
      end;
      //rm 2008-05-15
      {
      writeln(F,
                floattostrF(rainfall[iRGIdx,index],ffFixed,15,5),', ',
                floattostrF(excess,ffFixed,15,5),', ',
                floattostrF(recovery,ffFixed,15,5),', ',
                floattostrF(abstraction_available,ffFixed,15,5),', ',
                floattostrF(abstraction_used,ffFixed,15,5));
      }
    end;
  end;
  for i := 0 to FNumTimeSteps - 1 do
    rdiiTotal[i] := rdiiCurve[0,i] + rdiiCurve[1,i] + rdiiCurve[2,i];
  end;
  //closefile(F);
end;

procedure TFrameRDIIGraph.ClearAll;
var im:integer;
begin
{
  ChartFX1.Free;
    ChartFX1:=TChartFX.Create(Self);
    with ChartFX1 do begin
      Parent := Self;
      Left := Parent.Padding.Left;
      Top := Parent.Padding.Top;
      TabOrder := 0;
      visible := true;
      Chart3D := false;
      Width := Self.ClientWidth;
      Height := Self.ClientHeight;
    end;
}
im:=2000;
//showmessage(inttostr(im));inc(im);
try
if Assigned(ChartFX1) then

  ChartFX1.ClearData(CD_ALLDATA);

finally

end;
//showmessage(inttostr(im));inc(im);
  timeStep := -1;
//showmessage(inttostr(im));inc(im);
  SetLength(totalRDII,0,0);
//showmessage(inttostr(im));inc(im);
  SetLength(rainfall,0,0);
//showmessage(inttostr(im));inc(im);
  SetLength(raintotal,0);
//showmessage(inttostr(im));inc(im);
  SetLength(rainmax,0);
//showmessage(inttostr(im));inc(im);
  SetLength(rdiiCurve,0,0);
//showmessage(inttostr(im));inc(im);
  SetLength(rdiiTotal,0);
//showmessage(inttostr(im));inc(im);
  SetNumAreas(0);
//showmessage(inttostr(im));inc(im);
  SetNumAreas(1);
//showmessage(inttostr(im));inc(im);

end;

procedure TFrameRDIIGraph.FillChart();
var
  dataIndex, graphIndex, startIndex, endIndex: integer;
  commonXValue: double;
  i: integer;
begin
  {startIndex := trunc(ChartFX1.Axis[AXIS_X].Min - startDay) * segmentsPerDay;
  endIndex := (trunc(ChartFX1.Axis[AXIS_X].Max - startDay) * segmentsPerDay) - 1;}
  //if totalSegments > 0 then begin
  if Assigned(ChartFX1) then begin
    ChartFX1.ClearData(CD_ALLDATA);
    with ChartFX1 do begin
      Title[CHART_TOPTIT] := FTitle;
      if rainMax[0] > 0 then Axis[AXIS_Y].ResetScale;
      Axis[AXIS_Y].Title := 'Flow (' + FlowUnitLabel + ')';
      Axis[AXIS_Y2].Title := 'Rainfall ('+RainUnitLabel+')';
      //OpenDataEx(COD_VALUES,1,totalSegments);
      //OpenDataEx(COD_XVALUES,1,totalSegments);
      OpenDataEx(COD_VALUES,FNumAreas+1,FNumTimeSteps);
      OpenDataEx(COD_XVALUES,FNumAreas+1,FNumTimeSteps);

      for dataIndex := 0 to FNumTimeSteps-1 do begin
        {graphIndex := dataIndex - startIndex;}
        commonXValue := startDay + (dataIndex / segmentsPerDay);
        for i := 0 to FNumAreas - 1 do begin
          Series[i].XValue[dataIndex] := commonXValue;
          Series[i].YValue[dataIndex] := totalRDII[i,dataIndex];// + 0.00001;
        end;
        Series[FNumAreas].XValue[dataIndex] := commonXValue;
        Series[FNumAreas].YValue[dataIndex] := rainfall[0,dataIndex];  //just the first rainfall
      end;

      CloseData(COD_VALUES);
      CloseData(COD_XVALUES);
    end;
    ChartFX1.Axis[AXIS_Y].Decimals := GetDecimals;
  end;
end;


end.
