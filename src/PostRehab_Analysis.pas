unit PostRehab_Analysis;
// copy from LinearRegressionAnalysis.pas and start modifying 06/05/11 CCC
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OleCtrls, ChartfxLib_TLB, ADODB_TLB, Analysis,
  Menus, StormEventCollection, StormEvent, Math;

type
  TfrmPostRehab_Analysis = class(TForm)
    MainMenu1: TMainMenu;
    Options1: TMenuItem;
    oggleColorScheme1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    Export1: TMenuItem;
    Label1: TLabel;
    MenuItemSwitchRegressionType: TMenuItem;
    Label2: TLabel;
    TotalRobserved1: TMenuItem;
    RDIIperLF1: TMenuItem;
    N2: TMenuItem;
    PeakRDIIperArea1: TMenuItem;
    R11: TMenuItem;
    R21: TMenuItem;
    R31: TMenuItem;
    R2R31: TMenuItem;
    TotalRsimulated1: TMenuItem;
    RDIIperAverageDWF1: TMenuItem;
    procedure RDIIperAverageDWF1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    //ChartFX1: TChartFX;
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);

    procedure ChartFX1PostPaint(ASender: TObject; w, h: Smallint;
      lPaint: Integer; var nRes: Smallint);
    procedure ChartFX1MouseMoving(ASender: TObject; x, y: Smallint;
      var nRes: Smallint);
    procedure ChartFX1LButtonUp(ASender: TObject; x, y: Smallint;
      var nRes: Smallint);
    procedure ChartFX1LButtonDown(ASender: TObject; x, y: Smallint;
      var nRes: Smallint);
    procedure Close1Click(Sender: TObject);
    procedure oggleColorScheme1Click(Sender: TObject);
    procedure MenuItemSwitchRegressionTypeClick(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure TotalRobserved1Click(Sender: TObject);
    procedure RDIIperLF1Click(Sender: TObject);
    procedure PeakRDIIperArea1Click(Sender: TObject);
    procedure TotalRsimulated1Click(Sender: TObject);
    procedure R11Click(Sender: TObject);
    procedure R21Click(Sender: TObject);
    procedure R31Click(Sender: TObject);
    procedure R2R31Click(Sender: TObject);


  private

    analysisID : integer;
    regressionXvalue_pre : array of double;
    regressionYvalue_pre : array of double;
    regressionXvalue_post : array of double;
    regressionYvalue_post : array of double;
    preRehabX, preRehabY, postRehabX, postRehabY : array of double;
    regressionSlope_preRehab, regressionSlope_postRehab : double;
    regressionIntercept_preRehab, regressionIntercept_postRehab : double;
    analysis: TAnalysis;
    recordCounter, vertexCounter, postRehabRecordCounter : integer;

    //rm 2012-04-18 raingaugeID : integer;
    //rm 2012-04-18 totalRValue: array of double;
    //rm 2012-04-18 totalRainfall : array of double;
    //rm 2012-04-18 totalRainfall2wksBefore : array of double;
    //rm 2012-04-18 regressionXvalue : array of double;
    //rm 2012-04-18 regressionYvalue : array of double;

    //rm 2012-04-18 scatterYvalue : array of double;
    //rm 2012-04-18 rainfallDuration : array of double;
    //rm 2012-04-18 peakHourlyRainfallIntensity : array of double;

    //maxR, maxRainfall, maxRainfall2Wk, maxDuration, maxIntensity : double;
    //rm 2012-04-18 regressionM, regressionB, regressionR : double;
    //rm 2007-11-13
    //rm 2012-04-18 regressionM2: double;
    correlationOption : integer;
    yAxisTitle, linearRegressionTitle : string;
    xAxisMax, yAxisMax : double;

    handle: HDC;

    ChartFX1: TChartFX;
    timerStart, timerEnd: TTimeStamp;

    caID : integer;
    
    FRegressionType: integer;//0=linear;1=quadratic

    procedure invalidateGraph();
    procedure DrawUserLine();
    procedure DrawText();
    //rm 2012-04-18 procedure GetTotalRValue();
    //rm 2012-04-18 procedure RedrawChart();
    procedure RedrawChart2();
    function GetSlope:double;
    function GetYIntercept:double;
    function GetLineEquation:string;

    //rm 2012-04-18 procedure regressionCalculation(xArray, yArray: array of double);
    //rm 2012-04-18 procedure simpleLinearRegressionCalculation(xArray, yArray : array of double);
    procedure totalLeastSquaresRegressionCalculation(xArray, yArray : array of double; pre_post: integer);
    //rm 2012-04-18 procedure DoQuadraticRegression(xArray, yArray : array of double);
    //rm 2012-04-18 procedure FillInRegressionValue();
    procedure FillInRegressionValue2();
    //rm 2012-04-18 procedure FillInQuadraticRegressionValue;
    //rm 2012-04-18 procedure FillInScatterYvalue();
    procedure SetRegressionType(iType:integer);
    //rm 2012-07-03
    procedure FillInRegressionValue3();

    //rm 2012-07-09
    function GetDecimals(val: double):integer;

    procedure GetData;

    //rm 2012-07-03
    function GetMaxX: double;
    function GetMaxY: double;

    { Private declarations }
  public
    boNoData: boolean;
    { Public declarations }
  end;

var
  frmPostRehab_Analysis: TfrmPostRehab_Analysis;
  boDrawingLine,boLineDrawn: boolean;
  VXDn, VYDn, VXUp, VYUp: Double;
const
  maxCorrelationOption : integer = 9; //rm 2012-07-03 8;

implementation

uses moddatabase, chooseAnalysis, mainform, chooseLinearRegressionMethod, chooseCA, EventStatGetter, RDIIRankingStatGetterUnit;
{$R *.dfm}


procedure TfrmPostRehab_Analysis.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//rm 2012-07-03 trying to solve memory error / pointer error on closing
  //MessageDlg('Closing', mtInformation, [mbok], 0);
  try
  begin
    ChartFX1.Free;
    //FreeAndNil(preRehabX);
    //FreeAndNil(preRehabY);
    //FreeAndNil(postRehabX);
    //FreeAndNil(postRehabY);
    SetLength(preRehabX, 0);
    SetLength(preRehabY, 0);
    SetLength(postRehabX, 0);
    SetLength(postRehabY, 0);
    preRehabX := nil;
    preRehabY := nil;
    postRehabX := nil;
    postRehabY := nil;
    Finalize(preRehabX);
    Finalize(preRehabY);
    Finalize(postRehabX);
    Finalize(postRehabY);

  end;
  except on E: Exception do begin
      MessageDlg('Error in TfrmPostRehab_Analysis.FormClose! ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
  //MessageDlg('Closed', mtInformation, [mbok], 0);
end;

procedure TfrmPostRehab_Analysis.FormCreate(Sender: TObject);
begin
{
  ChartFX1:=TChartFX.Create(Self);
  with ChartFX1 do begin
    Parent := Self;
    Left := 8;
    Top := 8;
    Width := ClientWidth - 16;
    Height := ClientHeight - 16;
    TabOrder := 0;
    visible := true;
    Chart3D := false;
    OnPostPaint := ChartFX1PostPaint;
    onMouseMoving := ChartFX1MouseMoving;
    onLButtonUp := ChartFX1LButtonUp;
    onLButtonDown := ChartFX1LButtonDown;
  end;
  }
  correlationOption := 1;
end;

procedure TfrmPostRehab_Analysis.FormDestroy(Sender: TObject);
begin
//rm 2012-04-09
//this is causing error:
{
try
//ChartFX1.Free;
  except on E: Exception do begin
      MessageDlg('Error in TfrmPostRehab_Analysis.FormDestroy! ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
}
end;

procedure TfrmPostRehab_Analysis.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_RIGHT) or (key = VK_LEFT) or (key = VK_UP) or (key = VK_DOWN) then begin
    correlationOption := correlationOption + 1;
    if correlationOption > maxCorrelationOption then correlationOption := 1;
    case correlationOption of
      1: TotalRobserved1.Checked := true;
      2: TotalRsimulated1.Checked := true;
      3: R11.Checked := true;
      4: R21.Checked := true;
      5: R31.Checked := true;
      6: R2R31.Checked := true;
      7: PeakRDIIperArea1.Checked := true;
      8: RDIIperLF1.Checked := true;
      9: RDIIperAverageDWF1.Checked := true;
    end;
    GetData;
    {
    case linearOption of
      1: regressionCalculation(totalRvalue, totalRainfall);
      2: regressionCalculation(totalRvalue, totalRainfall2wksBefore);
      3: regressionCalculation(totalRvalue, peakHourlyRainfallIntensity);
      4: regressionCalculation(totalRvalue, rainfallDuration);
    end;
    }
    //FillInRegressionValue();
    //FillInQuadraticRegressionValue();
    //FillInScatterYvalue();
    //RedrawChart();
    //RedrawChart2;
  end;
end;


procedure TfrmPostRehab_Analysis.FormResize(Sender: TObject);
begin
  try
    if  Assigned(ChartFX1) then
    begin
      if ClientWidth > 16 then
        ChartFX1.Width := ClientWidth - 16;
      if Clientheight > 16 then
        ChartFX1.Height := ClientHeight - 16;
    end;
  except on E: Exception do
    begin
        // MessageDlg('Error in TfrmPostRehab_Analysis.FormResize! ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmPostRehab_Analysis.FormShow(Sender: TObject);
begin
  ChartFX1:=TChartFX.Create(Self);
  with ChartFX1 do begin
    Parent := Self;
    Left := 8;
    Top := 8;
    Width := ClientWidth - 16;
    Height := ClientHeight - 16;
    TabOrder := 0;
    visible := true;
    Chart3D := false;
    OnPostPaint := ChartFX1PostPaint;
    onMouseMoving := ChartFX1MouseMoving;
    onLButtonUp := ChartFX1LButtonUp;
    onLButtonDown := ChartFX1LButtonDown;
  end;
  correlationOption := 1;
  GetData;
end;

{
procedure TfrmPostRehab_Analysis.GetTotalRValue();
var
  queryStr: string;
  localRecSet: _RecordSet;
  counter : integer;

begin
//rm 2009-06-08 - rejigged for RTKs in RTKPatterns table
// queryStr := 'SELECT Events.AnalysisID, [R1]+[R2]+[R3] AS Expr1, Events.StartDateTime, Events.EndDateTime ' +
//              'FROM Events WHERE (((Events.AnalysisID) = ' +
//              inttostr(analysisID) + ')) ORDER BY [R1]+[R2]+[R3];';
 queryStr := 'SELECT a.AnalysisID, b.[R1]+b.[R2]+b.[R3] AS Expr1, ' +
              ' a.StartDateTime, a.EndDateTime ' +
              ' FROM Events a inner join RTKPatterns b ' +
              ' on a.RTKPatternID = b.RTKPatternID ' +
              ' WHERE (a.AnalysisID = ' +
              inttostr(analysisID) + ') ORDER BY b.[R1]+b.[R2]+b.[R3];';

  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if no records
  if not localRecSet.EOF then
    localRecSet.MoveFirst;

  counter := 0;

  while not(localRecSet.EOF) do begin
    counter := counter + 1;
    localRecSet.MoveNext;
  end;

  setlength(totalRValue,counter);
  setlength(totalRainfall,counter);
  setlength(totalRainfall2wksBefore,counter);
  setlength(rainfallDuration,counter);
  setlength(peakHourlyRainfallIntensity,counter);

  //rm 2007-10-18 - prevent crash if no records
  //if not localRecSet.EOF then
  if counter > 0 then
    localRecSet.MoveFirst;
  counter := 0;
  while not(localRecSet.EOF) do begin
    counter := counter + 1;

    if localRecSet.Fields.Item[1].Value > maxR then maxR := localRecSet.Fields.Item[1].Value;
    totalRValue[counter-1] := localRecSet.Fields.Item[1].Value;

    totalRainfall[counter-1] := DatabaseModule.RainfallTotalForRaingaugeBetweenDates(raingaugeID,localRecSet.Fields.Item[2].value,localRecSet.Fields.Item[3].value);
    if totalRainfall[counter-1] > maxRainfall then maxRainfall := totalRainfall[counter-1];

 // - get a null conversion error here:
    if VarIsNull(localRecSet.Fields.Item[2].value) then
      totalRainfall2wksBefore[counter-1] := 0
    else
      totalRainfall2wksBefore[counter-1] :=
    DatabaseModule.RainfallTotalPreceding2Wks(localRecSet.Fields.Item[2].value,raingaugeID);

    if totalRainfall2wksBefore[counter-1] > maxRainfall2Wk then maxRainfall2Wk := totalRainfall2wksBefore[counter-1];

    rainfallDuration[counter-1] := localRecSet.Fields.Item[3].value - localRecSet.Fields.Item[2].value;
    if rainfallDuration[counter - 1] > maxDuration then maxDuration := rainfallDuration[counter - 1];

    peakHourlyRainfallIntensity[counter-1] := DatabaseModule.GetPeakHourlyRainIntensityBetweenDates(raingaugeID,localRecSet.Fields.Item[2].value,localRecSet.Fields.Item[3].value);
    if peakHourlyRainfallIntensity[counter-1] > maxIntensity then maxIntensity := peakHourlyRainfallIntensity[counter-1];

    localRecSet.MoveNext;
  end;
  //messagedlg(Inttostr(counter) + ' events',mtinformation,[mbok],0);
  boNoData := (counter < 1);
  localRecSet.Close;
  recordCounter := counter;
end;
}


procedure TfrmPostRehab_Analysis.invalidateGraph;
begin
  if boNoData then begin
    ChartFX1.Visible := false;
    exit;
  end else ChartFX1.Visible := true;

  ChartFX1.OpenDataEx(COD_CONSTANTS,1,0);
  ChartFX1.CloseData(COD_CONSTANTS);
end;
procedure TfrmPostRehab_Analysis.oggleColorScheme1Click(Sender: TObject);
begin
//toggle color scheme
  frmMain.ToggleChartColors;
  //RedrawChart();
  RedrawChart2;
end;

procedure TfrmPostRehab_Analysis.TotalRsimulated1Click(Sender: TObject);
begin
  if correlationOption <> 2 then begin
    correlationOption := 2;
    GetData;
  end;
end;

procedure TfrmPostRehab_Analysis.PeakRDIIperArea1Click(Sender: TObject);
begin
  if correlationOption <> 7 then begin
    correlationOption := 7;
    GetData;
  end;
end;

procedure TfrmPostRehab_Analysis.MenuItemSwitchRegressionTypeClick(
  Sender: TObject);
begin

  if FRegressionType = 0 then
    SetRegressionType(1)
  else
    SetRegressionType(0);
    {
    case linearOption of
      1: regressionCalculation(totalRvalue, totalRainfall);
      2: regressionCalculation(totalRvalue, totalRainfall2wksBefore);
      3: regressionCalculation(totalRvalue, peakHourlyRainfallIntensity);
      4: regressionCalculation(totalRvalue, rainfallDuration);
    end;
    }
    //FillInRegressionValue();
    //FillInQuadraticRegressionValue();
    //FillInScatterYvalue();
    //RedrawChart();
    RedrawChart2;

end;

function TfrmPostRehab_Analysis.GetSlope: double;
begin
  if (VXUp-VXDn = 0) then
    Result := 9999999999
  else
    Result := ((VYUp-VYDn)/(VXUp-VXDn));
end;
function TfrmPostRehab_Analysis.GetYIntercept: double;
begin
  Result := VYDn - (GetSlope * VXDn);
end;

procedure TfrmPostRehab_Analysis.GetData;
var
  analysisName : string;
  analysisID1, analysisID2, analysisID3, analysisID4: integer;
  events1, events2, events3, events4: TStormEventCollection;
  meterID1, meterID2, meterID3, meterID4: integer;
  rdiiAnalysisName : string;
  myEventStatGetter1, myEventStatGetter2: TEventStatGetter;
  i, j, preoverlapEvent, postoverlapEvent: integer;
  event1, event2, event3, event4: TStormEvent;
  overlapTol : string;
  arraycount: integer;
//  foundMatch : boolean;

begin
//rm 2007-11-13 - new regressiontype
// CCC - 2011-06-06
// Get condition analysis from chooseCA -
//  there are 2 pairs: 1 pre- and 1 post
//  there are 2 RDII analysis for each pair
//  no checking needs because all the checking is done in Management
//  Get all 4 RDII analysis
//  Identify # of events that can be used for each pre- and post-
//  Get observed R and fill in raw X and Y values for plotting
//  Perform linear regression based on raw values
//

  analysisName := frmCASelector.SelectedCA;   //Obtain condition analysis name
  caID := databaseModule.GetCAID4Name(analysisName);
  overlapTol := databaseModule.GetOlapTol4CAID(caID);


  preoverlapEvent := databaseModule.GetOlapEvent4CAID(caID, 0); //Pre-rehab
  SetLength(preRehabX,preoverlapEvent);
  SetLength(preRehabY,preoverlapEvent);

  postoverlapEvent := databaseModule.GetOlapEvent4CAID(caID, 1); //Post-rehab
  SetLength(postRehabX,postoverlapEvent);
  SetLength(postRehabY,postoverlapEvent);

  //rm 2012-04-19 - I think it might help to set everything to 0 at this point
  //in the rehabX and Y arrays
  for i := 0 to preoverlapEvent - 1 do begin
    preRehabX[i] := 0;
    preRehabY[i] := 0;
    //rm 2012-07-03 postRehabX[i] := 0;
    //rm 2012-07-03 postRehabY[i] := 0;
  end;
  //rm 2012-07-03
  for i := 0 to postoverlapEvent - 1 do begin
    postRehabX[i] := 0;
    postRehabY[i] := 0;
  end;

  rdiiAnalysisName := DatabaseModule.GetAnalysisName4CAID(caID,1);
  analysis := DatabaseModule.GetAnalysis(rdiianalysisName);
  analysisID1 := analysis.analysisID;
  meterID1 := analysis.FlowMeterID;
  events1 := DatabaseModule.GetEvents(analysisID1);

  rdiiAnalysisName := DatabaseModule.GetAnalysisName4CAID(caID,2);
  analysis := DatabaseModule.GetAnalysis(rdiianalysisName);
  analysisID2 := analysis.analysisID;
  meterID2 := analysis.FlowMeterID;
  events2 := DatabaseModule.GetEvents(analysisID2);

  rdiiAnalysisName := DatabaseModule.GetAnalysisName4CAID(caID,3);
  analysis := DatabaseModule.GetAnalysis(rdiianalysisName);
  analysisID3 := analysis.analysisID;
  meterID3 := analysis.FlowMeterID;
  events3 := DatabaseModule.GetEvents(analysisID3);

  rdiiAnalysisName := DatabaseModule.GetAnalysisName4CAID(caID,4);
  analysis := DatabaseModule.GetAnalysis(rdiianalysisName);
  analysisID4 := analysis.analysisID;
  meterID4 := analysis.FlowMeterID;
  events4 := DatabaseModule.GetEvents(analysisID4);


    //-------- EVENT BASED -------------
    //MemoOlapAnalyzer.Lines.Add('EVENTS---');
    myEventStatGetter1 := TEventStatGetter.Create(analysisID1);  //Pre-Rehab Meter
    myEventStatGetter2 := TEventStatGetter.Create(analysisID2);  //Control Meter


    arraycount := 1;

    for i := 1 to events1.Count do begin
      event1 := events1.items[i-1];
      //startDate1 := event1.StartDate;
      //endDate1 := event1.EndDate;
      //eventDuration1 := endDate1 - startDate1;
//rm 2012-04-19 I think we can move this up out of the j loop for efficiency
      myEventStatGetter1.GetEventStats(i);

      for j := 1 to events2.Count do begin
        event2 := events2.items[j-1];
        //startDate2 := event2.StartDate;
        //endDate2 := event2.EndDate;
        //eventDuration2 := endDate2 - startDate2;
          if event1.overlapswtolerance(event2, strtoint(overlaptol)) then begin  //when 2 events falls into same time frame and can be used for comparison
//rm 2012-04-19 I think we can move this up out of the j loop for efficiency            myEventStatGetter1.GetEventStats(i);
            myEventStatGetter2.GetEventStats(j);

            //rm 2012-08-13 add a little range checking here: (just like postrehab)
            //rm why the "-1" ??? if ((arraycount -1) < High(prerehabX)) then begin
            if ((arraycount -1) <= High(prerehabX)) then begin

  case correlationOption of
    1 : begin
            prerehabX[arraycount-1] := myEventStatGetter2.eventTotalR;
            prerehabY[arraycount-1] := myEventStatGetter1.eventTotalR;
            linearRegressionTitle := 'Total R';
    end;
    2 : begin
            prerehabX[arraycount-1] := event2.R[0] + event2.R[1] + event2.R[2];
            prerehabY[arraycount-1] := event1.R[0] + event1.R[1] + event1.R[2];
            linearRegressionTitle := 'Total R (with R1, R2, & R3 Distribution)';
    end;
    3 : begin
            prerehabX[arraycount-1] := event2.R[0];
            prerehabY[arraycount-1] := event1.R[0];
            linearRegressionTitle := 'R1';
    end;
    4 : begin
            prerehabX[arraycount-1] := event2.R[1];
            prerehabY[arraycount-1] := event1.R[1];
            linearRegressionTitle := 'R2';
    end;
    5 : begin
            prerehabX[arraycount-1] := event2.R[2];
            prerehabY[arraycount-1] := event1.R[2];
            linearRegressionTitle := 'R3';
    end;
    6 : begin
            prerehabX[arraycount-1] := event2.R[1] + event2.R[2];
            prerehabY[arraycount-1] := event1.R[1] + event1.R[2];
            linearRegressionTitle := 'R2 + R3';
    end;
    7 : begin
            if (myEventStatGetter2.Area = 0) then
              prerehabX[arraycount-1] := 0
            else
              prerehabX[arraycount-1] := myEventStatGetter2.peakIIFlow / myEventStatGetter2.Area;
            if (myEventStatGetter1.Area = 0) then
              prerehabY[arraycount-1] := 0
            else
              prerehabY[arraycount-1] := myEventStatGetter1.peakIIFlow / myEventStatGetter1.Area;
            linearRegressionTitle := 'Peak RDII / Area';
    end;
    8 : begin
            prerehabX[arraycount-1] := myEventStatGetter2.RDIIperLF;
            prerehabY[arraycount-1] := myEventStatGetter1.RDIIperLF;
            linearRegressionTitle := 'RDII per LF';
    end;
    //rm 2012-07-03 - new one Total R / average weekday DWF
    9: begin
            prerehabX[arraycount-1] := myEventStatGetter2.RDIIperADWF;
            prerehabY[arraycount-1] := myEventStatGetter1.RDIIperADWF;
            linearRegressionTitle := 'RDII per Average Weekday DWF';
    end;
  end;
            //s := DateTimeToStr(StartDate1) + ' Event ' + IntToStr(i);
            //s := s + 'Observed R: ' + FormatFloat('0.000', myEventStatGetter1.eventTotalR);
            //s := s + ' Event ' + IntToStr(j) + 'Observed R: ' + FormatFloat('0.000', myEventStatGetter2.eventTotalR);
            arraycount := arraycount + 1;
            //MemoOlapAnalyzer.lines.Add(s);
            //MemoOlapAnalyzer.lines.Add('');
            end;//rm 2012-08-13
          end;
      end;
    end;
    recordCounter := arraycount - 1;
    //rm 2012-08-13 - why not just use High(prerehabX)??
    recordCounter := High(prerehabX);

    myEventStatGetter1.AllDone;
    myEventStatGetter2.AllDone;


    //Post-Rehab
    myEventStatGetter1 := TEventStatGetter.Create(analysisID3);  //Post-Rehab Meter
    myEventStatGetter2 := TEventStatGetter.Create(analysisID4);  //Control Meter

    arraycount := 1;

    for i := 1 to events3.Count do begin
      event3 := events3.items[i-1];
      //rm 2012-04-19 - why is this different than the loop above?
      //not sure if working
//      foundmatch := false;
//      j := 1;
//      while ((j <= events4.count) and (foundmatch = false)) do begin
//rm 2012-04-19 I think we can move this up out of the j loop for efficiency
      myEventStatGetter1.GetEventStats(i);
      for j := 1 to events4.Count do begin
        event4 := events4.items[j-1];
          if event3.overlapswtolerance(event4, strtoint(overlaptol)) then begin  //when 4 events falls into same time frame and can be used for comparison
//            foundmatch := true;
//rm 2012-04-19 I think we can move this up out of the j loop for efficiency            myEventStatGetter1.GetEventStats(i);
            myEventStatGetter2.GetEventStats(j);
            
            //rm 2012-07-03 add a little range checking here:
            //rm should it be <= ???   if ((arraycount -1) < High(postrehabX)) then begin
            if ((arraycount -1) <= High(postrehabX)) then begin

  case correlationOption of
    1 : begin
            postrehabX[arraycount-1] := myEventStatGetter2.eventTotalR;
            postrehabY[arraycount-1] := myEventStatGetter1.eventTotalR;
    end;
    2 : begin
            postrehabX[arraycount-1] := event4.R[0] + event4.R[1] + event4.R[2];
            postrehabY[arraycount-1] := event3.R[0] + event3.R[1] + event3.R[2];
    end;
    3 : begin
            postrehabX[arraycount-1] := event4.R[0];
            postrehabY[arraycount-1] := event3.R[0];
    end;
    4 : begin
            postrehabX[arraycount-1] := event4.R[1];
            postrehabY[arraycount-1] := event3.R[1];
    end;
    5 : begin
            postrehabX[arraycount-1] := event4.R[2];
            postrehabY[arraycount-1] := event3.R[2];
    end;
    6 : begin
            postrehabX[arraycount-1] := event4.R[1] + event4.R[2];
            postrehabY[arraycount-1] := event3.R[1] + event3.R[2];
    end;
    7 : begin
            if (myEventStatGetter2.Area = 0) then
              postrehabX[arraycount-1] := 0
            else
              postrehabX[arraycount-1] := myEventStatGetter2.peakIIFlow / myEventStatGetter2.Area;
            if (myEventStatGetter1.Area = 0) then
              postrehabY[arraycount-1] := 0
            else
              postrehabY[arraycount-1] := myEventStatGetter1.peakIIFlow / myEventStatGetter1.Area;
    end;
    8 : begin
            postrehabX[arraycount-1] := myEventStatGetter2.RDIIperLF;
            postrehabY[arraycount-1] := myEventStatGetter1.RDIIperLF;
    end;
    //rm 2012-07-03 - new one Total R / average weekday DWF
    9: begin
            postrehabX[arraycount-1] := myEventStatGetter2.RDIIperADWF;
            postrehabY[arraycount-1] := myEventStatGetter1.RDIIperADWF;
            //linearRegressionTitle := 'RDII per Average DWF';
    end;
  end;
            //rm 2012-08-13 move this down below arraycount + 1 end;//rm 2012-07-03

            arraycount := arraycount + 1;
            end;//rm 2012-008-13
          end;
//rm 2012-04-19        inc(j);
      end;
    end;
    postRehabRecordCounter := arraycount - 1;
    //rm 2012-07-03 - why not use High(postrehabX)??
    postRehabRecordCounter := High(postrehabX);

    myEventStatGetter1.AllDone;
    myEventStatGetter2.AllDone;


    totalLeastSquaresRegressionCalculation(prerehabX,prerehabY,0);  //pre
    totalLeastSquaresRegressionCalculation(postrehabX,postrehabY,1); //post

    xAxisMax := GetMaxX;
    yAxisMax := GetMaxY;

    FillInRegressionValue2();
    //FillInRegressionValue3();


    ChartFX1.BringToFront;
    ChartFX1.Visible := true;
    ChartFX1.TypeMask := ChartFX1.TypeMask OR CT_TRACKMOUSE;
    boDrawingLine := false;
    with ChartFX1 do begin
      with Axis[AXIS_X] do begin
        Min := 0.0;
        Max := 1.0;
        //Format := 'XM/d/yy';
        TextColor := frmMain.ChartRGBText;
        Decimals := GetDecimals(xAxisMax);//rm 2012-07-09 1;
        PixPerUnit := 100;
        //rm 2012-07-09 Step := 0.1;
        Grid := True;
        Title := 'R-Value for Control Sewershed';
        TitleColor := frmMain.ChartRGBText;   //Hide the markers by using the same color as background
        if (correlationOption > 6) then begin
          Max := xAxisMax;
          //rm 2012-07-09 Step := 1;
        end;

      end;
      with Axis[AXIS_Y] do begin
        Min := 0.0;
        Max := 1.0;
        Grid := True;
        Title := 'R-Value for Rehab Sewershed';
        if (correlationOption > 6) then begin
          Max := yAxisMax;
        end;
        Decimals := GetDecimals(yAxisMax);//rm 2012-07-09
      end;
    end;
    RedrawChart2();
    invalidateGraph;
    ChartFX1.SetFocus;
end;

function TfrmPostRehab_Analysis.GetDecimals(val: double): integer;
var iResult: integer;
    dLog: double;
begin
  iResult := 1; //default to the old global value of 1
  try
    if (val <= 0) then begin
      val := 0 - val;
    end;
    if (val <> 0) then begin
      dLog :=  Math.Log10(val);
      iResult := 2 - Math.Floor(dLog);
      if iResult < 0 then iResult := 0;
    //end else begin
    //  iResult := 0;
    end;
  finally

  end;
  Result := iResult;
end;

function TfrmPostRehab_Analysis.GetLineEquation: string;
begin
  Result := 'y = ' + FormatFloat('0.###',GetSlope) +
            'x + ' + FormatFloat('0.###',GetYIntercept);
end;

function TfrmPostRehab_Analysis.GetMaxX: double;
var max: double;
i: integer;
begin
  max := 0.0;
  for i := 0 to High(preRehabX) do begin
    if (preRehabX[i] > max) then max := preRehabX[i];
  end;
  for i := 0 to High(postRehabX) do begin
    if (postRehabX[i] > max) then max := postRehabX[i];
  end;

  Result := max;
end;

function TfrmPostRehab_Analysis.GetMaxY: double;
var max: double;
i: integer;
begin
  max := 0.0;
  for i := 0 to High(preRehabY) do begin
    if (preRehabY[i] > max) then max := preRehabY[i];
  end;
  for i := 0 to High(postRehabY) do begin
    if (postRehabY[i] > max) then max := postRehabY[i];
  end;

  Result := max;
end;

(*
procedure TfrmPostRehab_Analysis.RedrawChart();
var
    titleChart : string;
    txt : string;
    I : integer;
    input, output: OLEVariant;
begin

//rm 2011-06-07 testing
RedrawChart2;
exit;

  if boNoData then begin
    ChartFX1.Visible := false;
    exit;
  end else ChartFX1.Visible := true;

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
    Fonts[CHART_TOPTIT] := CF_ARIAL Or CF_BOLD Or 14;
    {Title := linearRegressionTitle;}
    Title[CHART_TOPTIT] := linearRegressionTitle;

    with Axis[AXIS_X] do begin
      Min := 0.0;
      Max := xAxisMax;
      {Format := 'XM/d/yy';}
      TextColor := frmMain.ChartRGBText;
      //rm 2010-03-23 - need more decimals! Decimals := 1;
      Decimals := 3;
      Step := 0.001;

      PixPerUnit := 100;
      //Step := 0.1;
      //Grid := True;
      Title := 'R-Value for Rehabilitation Sewershed';
      TitleColor := frmMain.ChartRGBText;   {Hide the markers by using the same color as background}
    end;

    //OpenDataEx(COD_COLORS,2,0);
    OpenDataEx(COD_COLORS,4,0);
    Series[0].Color := frmMain.ChartRGBYell;
    Series[1].Color := frmMain.ChartRGBText;
    Series[2].Color := frmMain.ChartRGBGree;
    Series[3].Color := frmMain.ChartRGBRain;

    CloseData(COD_COLORS);
    with Axis[AXIS_Y] do begin
      TextColor := frmMain.ChartRGBText;
      PixPerUnit := 100;
      Grid := True;
      ResetScale;
      Title := yAxisTitle;
      TitleColor := frmMain.ChartRGBText;
      Decimals := 3;
      {AdjustScale;}
      Min := 0.0;
      Max := yAxisMax;
    end;
    if recordCounter > vertexCounter then begin
      OpenDataEx(COD_VALUES,2,recordCounter);
      OpenDataEx(COD_XVALUES,2,recordCounter);
      for I := 0 to recordCounter - 1 do begin
        Series[0].XValue[I]:= -1;
        Series[0].YValue[I]:= -1;
        Series[1].XValue[I]:= -1;
        Series[1].YValue[I]:= -1;
      end;
    end else begin
      OpenDataEx(COD_VALUES,2,vertexCounter);
      OpenDataEx(COD_XVALUES,2,vertexCounter);
      for I := 0 to vertexCounter - 1 do begin
        Series[0].XValue[I]:= -1;
        Series[0].YValue[I]:= -1;
        Series[1].XValue[I]:= -1;
        Series[1].YValue[I]:= -1;
      end;
    end;
    {
    for I := 0 to recordCounter - 1 do begin
      Series[0].XValue[I]:= totalRValue[I];
      Series[0].YValue[I]:= scatterYValue[I];
      Series[1].XValue[I]:= regressionXvalue[I];
      Series[1].YValue[I]:= regressionYvalue[I];
    end;
    }
    for I := 0 to recordCounter - 1 do begin
      Series[0].XValue[I]:= totalRValue[I];
      Series[0].YValue[I]:= scatterYValue[I];
    end;
    for I := 0 to vertexCounter - 1 do begin
      //Series[1].XValue[I]:= regressionXvalue[I];
      //Series[1].YValue[I]:= regressionYvalue[I];
    end;
{    if recordcounter > 20 then begin
      OpenDataEx(COD_VALUES,2,recordCounter);
      OpenDataEx(COD_XVALUES,2,recordCounter);
    end
    else begin
      OpenDataEx(COD_VALUES,2,20);
      OpenDataEx(COD_XVALUES,2,20);
    end;

    if recordcounter > 19 then begin
      for I := 0 to 19 do begin
        Series[0].XValue[I]:= totalRValue[I];
        Series[0].YValue[I]:= scatterYValue[I];
        Series[1].XValue[I]:= regressionXvalue[I];
        Series[1].YValue[I]:= regressionYvalue[I];
      end;
      for I := 20 to recordCounter - 1 do begin
        Series[0].XValue[I]:= totalRValue[I];
        Series[0].YValue[I]:= totalRainfall[I];
      end;
    end
    else begin
      for I := 0 to recordCounter - 1 do begin
        Series[0].XValue[I]:= totalRValue[I];
        Series[0].YValue[I]:= scatterYValue[I];
        Series[1].XValue[I]:= regressionXvalue[I];
        Series[1].YValue[I]:= regressionYvalue[I];
      end;
      for I := recordCounter to 19 do begin
        Series[0].XValue[I]:= -1;
        Series[0].YValue[I]:= -1;
        Series[1].XValue[I]:= regressionXvalue[I];
        Series[1].YValue[I]:= regressionYvalue[I];
      end;
    end;
}

    with Series[1] do begin
      Color := clBlue;
      Gallery := LINES;
      MarkerShape := MK_NONE;
    end;
    CloseData(COD_VALUES);
    CloseData(COD_XVALUES);
  end;
  Screen.Cursor := crDefault;


   ChartFX1.PaintInfo2(CPI_GETDC,0,output);
   Handle := output;
   ChartFX1.PaintInfo2(CPI_PRINTINFO,0,output);
  {*Call SetFocus, so that the form will accept key strokes without requiring
   the user to click on the form *}
{
  txt := 'y = mx + b';
TextOutA(Handle,ChartFX1.LeftGap + 10,
                  ChartFX1.Height - ChartFX1.TopGap -
                  ChartFX1.BottomGap - 4,
                  pChar(txt),
                  length(txt));
}
  {SetTextAlign(handle,TA_LEFT or TA_BOTTOM);
  txt := pchar('Event');
  TextOutA(handle,10,10,'testing',7);}
  SetFocus;
end;
 *)

procedure TfrmPostRehab_Analysis.DrawText();
begin
{
      SetTextColor(handle,clBlue);
      txt := pchar(' Rain Depth '+ floattostr(rainDepth)+ ' in');
      TextOutA(handle,rightX,topY+140,txt,length(txt));
      txt := pchar(' Rain Volume '+ floattostrF(rainVolume,ffFixed,10,0)+ ' cf');
      TextOutA(handle,rightX,topY+150,txt,length(txt));

}
end;

procedure TfrmPostRehab_Analysis.R11Click(Sender: TObject);
begin
  if correlationOption <> 3 then begin
    correlationOption := 3;
    GetData;
  end;
end;

procedure TfrmPostRehab_Analysis.R21Click(Sender: TObject);
begin
  if correlationOption <> 4 then begin
    correlationOption := 4;
    GetData;
  end;
end;

procedure TfrmPostRehab_Analysis.R2R31Click(Sender: TObject);
begin
  if correlationOption <> 6 then begin
    correlationOption := 6;
    GetData;
  end;
end;

procedure TfrmPostRehab_Analysis.R31Click(Sender: TObject);
begin
  if correlationOption <> 5 then begin
    correlationOption := 5;
    GetData;
  end;
end;

procedure TfrmPostRehab_Analysis.RDIIperAverageDWF1Click(Sender: TObject);
begin
//rm 2012-07-03 - Total RDII per average weekday DWF
  if correlationOption <> 9 then begin
    correlationOption := 9;
    GetData;
  end;

end;

procedure TfrmPostRehab_Analysis.RDIIperLF1Click(Sender: TObject);
begin
  if correlationOption <> 8 then begin
    correlationOption := 8;
    GetData;
  end;
end;

procedure TfrmPostRehab_Analysis.RedrawChart2();
var
    titleChart : string;
    txt : string;
    I : integer;
    input, output: OLEVariant;
begin
  if boNoData then begin
    ChartFX1.Visible := false;
    exit;
  end else ChartFX1.Visible := true;

  titleChart := 'testing';
  txt := 'Rehabilitation Sewershed : ' + DatabaseModule.GetFlowMeterNameForAnalysis(DatabaseModule.GetAnalysisName4CAID(caID,1));
  //label2.Caption := floattostrf(1 - (regressionslope_postrehab / regressionslope_prerehab), ffFixed, 4, 0);

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
    Fonts[CHART_TOPTIT] := CF_ARIAL Or CF_BOLD Or 14;

    //Title[] := linearRegressionTitle;

    //Title[CHART_TOPTIT] := 'Pre- and Post- Rehabilitation Conditions Analysis';
    Title[CHART_TOPTIT] := txt;
    //rm 2011-06-16  - add another line to title
    //SubTitle[CHART_TOPTIT] := titleChart;
    if (regressionslope_postrehab > regressionslope_prerehab) then begin
      txt := 'More RDII found in postrehab period - Please recheck raw data and RDII Analysis';
    end else begin
      //rm 2012-04-17 error checking
      if (regressionslope_prerehab = 0) then
        txt := 'Pre-Rehab regression slope = 0'
      else
        txt := floattostrf(((-1 * ((regressionslope_postrehab - regressionslope_prerehab) / regressionslope_prerehab)) * 100), ffFixed, 4, 0) + '%';
    end;
    Title[CHART_TOPTIT] := Title[CHART_TOPTIT] + sLineBreak + 'Trend of RDII Reduction (' + linearRegressionTitle + ' based) : ' + txt;

    xAxisMax := GetMaxX;
    yAxisMax := GetMaxY;

    with Axis[AXIS_X] do begin
      if (correlationOption > 6) then begin
        Min := 0.0;
        Max := 1.2 * GetMaxX;
        //Max := GetMaxX; //10.0;
        {Format := 'XM/d/yy';}
        TextColor := frmMain.ChartRGBText;
        //rm 2010-03-23 - need more decimals! Decimals := 1;
        Decimals := GetDecimals(xAxisMax);//rm 2012-07-09 1;
        //Step := 1.0;
      end else begin
        Min := 0.0;
        Max := 1.2 * GetMaxX; //1.0;
        {Format := 'XM/d/yy';}
        TextColor := frmMain.ChartRGBText;
        //rm 2010-03-23 - need more decimals! Decimals := 1;
        Decimals := 3;
        //Step := 0.1;
      end;

      PixPerUnit := 100;
      //Step := 0.1;
      //Grid := True;
      Title := 'R Value in Control Area';
      TitleColor := frmMain.ChartRGBText;   {Hide the markers by using the same color as background}
    end;


    //OpenDataEx(COD_COLORS,2,0);
    // CC 06/06/11
    //OpenDataEx(COD_COLORS,4,0);
    //Series[0].Color := frmMain.ChartRGBYell;
    //Series[1].Color := frmMain.ChartRGBText;
    //Series[2].Color := frmMain.ChartRGBGree;
    //Series[3].Color := frmMain.ChartRGBText;
    //CloseData(COD_COLORS);

    with Axis[AXIS_Y] do begin
      ResetScale;
      if (correlationOption > 6) then begin
        //Decimals := 1;
        {AdjustScale;}
        Min := 0.0;
        //Max := GetMaxY; //10.0;
        Max := 1.2 * GetMaxY;
      end else begin
        //Decimals := 3;
        {AdjustScale;}
        Min := 0.0;
        Max := 1.2 * GetMaxY; //1.0;
      end;
      Decimals := GetDecimals(yAxisMax);//rm 2012-07-09
      Grid := True;
      TextColor := frmMain.ChartRGBText;
      PixPerUnit := 100;
      Title := 'R-Value in Sewer Rehabilitation Sewershed';
      TitleColor := frmMain.ChartRGBText;
    end;


    if recordCounter > postrehabrecordCounter then begin
      OpenDataEx(COD_VALUES,4,recordCounter);
      OpenDataEx(COD_XVALUES,4,recordCounter);
      for I := 0 to recordCounter - 1 do begin
        Series[0].XValue[I]:= 0;
        Series[0].YValue[I]:= 0;
        Series[1].XValue[I]:= 0;
        Series[1].YValue[I]:= 0;
        Series[2].XValue[I]:= 0;
        Series[2].YValue[I]:= 0;
        Series[3].XValue[I]:= 0;
        Series[3].YValue[I]:= 0;

        Series[1].XValue[I]:= regressionXvalue_pre[I];
        Series[1].YValue[I]:= regressionYvalue_pre[I];
        Series[3].XValue[I]:= regressionXvalue_post[I];
        Series[3].YValue[I]:= regressionYvalue_post[I];

      end;
    end else begin
      OpenDataEx(COD_VALUES,4,postrehabrecordCounter);
      OpenDataEx(COD_XVALUES,4,postrehabrecordCounter);
      for I := 0 to postrehabrecordCounter - 1 do begin
        Series[0].XValue[I]:= 0;
        Series[0].YValue[I]:= 0;
        Series[1].XValue[I]:= 0;
        Series[1].YValue[I]:= 0;
        Series[2].XValue[I]:= 0;
        Series[2].YValue[I]:= 0;
        Series[3].XValue[I]:= 0;
        Series[3].YValue[I]:= 0;

        Series[1].XValue[I]:= regressionXvalue_pre[I];
        Series[1].YValue[I]:= regressionYvalue_pre[I];
        Series[3].XValue[I]:= regressionXvalue_post[I];
        Series[3].YValue[I]:= regressionYvalue_post[I];

      end;
    end;

    //OpenDataEx(COD_VALUES,2,recordCounter);
    //OpenDataEx(COD_XVALUES,2,recordCounter);

    //for I := 0 to recordCounter - 1 do begin
    //    Series[0].XValue[I]:= -1;
    //    Series[0].YValue[I]:= -1;
    //    Series[1].XValue[I]:= -1;
    //    Series[1].YValue[I]:= -1;
    //end;

    for I := 0 to recordCounter - 1 do begin
      Series[0].XValue[I]:= preRehabX[I];
      Series[0].YValue[I]:= preRehabY[I];
    end;

    for I := 0 to postrehabrecordCounter - 1 do begin
      Series[2].XValue[I]:= postRehabX[I];
      Series[2].YValue[I]:= postRehabY[I];
    end;
    CloseData(COD_VALUES);
    CloseData(COD_XVALUES);
    {
    OpenDataEx(COD_VALUES,4,2);
    OpenDataEx(COD_XVALUES,4,2);

    Series[1].Xvalue[0] := regressionXvalue_pre[0];
    Series[1].Yvalue[0] := regressionYvalue_pre[0];
    Series[1].Xvalue[1] := regressionXvalue_pre[1];
    Series[1].Yvalue[1] := regressionYvalue_pre[1];

    Series[3].Xvalue[0] := regressionXvalue_post[0];
    Series[3].Yvalue[0] := regressionYvalue_post[0];
    Series[3].Xvalue[1] := regressionXvalue_post[1];
    Series[3].Yvalue[1] := regressionYvalue_post[1];

    CloseData(COD_VALUES);
    CloseData(COD_XVALUES);
    }
    {    if recordcounter > 20 then begin
      OpenDataEx(COD_VALUES,2,recordCounter);
      OpenDataEx(COD_XVALUES,2,recordCounter);
    end
    else begin
      OpenDataEx(COD_VALUES,2,20);
      OpenDataEx(COD_XVALUES,2,20);
    end;

    if recordcounter > 19 then begin
      for I := 0 to 19 do begin
        Series[0].XValue[I]:= totalRValue[I];
        Series[0].YValue[I]:= scatterYValue[I];
        Series[1].XValue[I]:= regressionXvalue[I];
        Series[1].YValue[I]:= regressionYvalue[I];
      end;
      for I := 20 to recordCounter - 1 do begin
        Series[0].XValue[I]:= totalRValue[I];
        Series[0].YValue[I]:= totalRainfall[I];
      end;
    end
    else begin
      for I := 0 to recordCounter - 1 do begin
        Series[0].XValue[I]:= totalRValue[I];
        Series[0].YValue[I]:= scatterYValue[I];
        Series[1].XValue[I]:= regressionXvalue[I];
        Series[1].YValue[I]:= regressionYvalue[I];
      end;
      for I := recordCounter to 19 do begin
        Series[0].XValue[I]:= -1;
        Series[0].YValue[I]:= -1;
        Series[1].XValue[I]:= regressionXvalue[I];
        Series[1].YValue[I]:= regressionYvalue[I];
      end;
    end;
}
//rm 2011-06-07 - put changes to symbology between OpenDataEx(COD_COLORS and CloseData(COD_COLORS
    OpenDataEx(COD_COLORS,4,0);

    with Series[0] do begin
      Color := clRed;
      MarkerShape := MK_INVERTEDTRIANGLE; //MK_Circle;
    end;

    with Series[1] do begin
      Color := clRed; //clBlue;
      Gallery := LINES;
      MarkerShape := MK_NONE;
    end;

    with Series[2] do begin
      Color := clBlue; //clYellow;
      MarkerShape := MK_Triangle;
    end;

    with Series[3] do begin
      Color := clBlue; //clYellow; //clblack;
      Gallery := LINES;
      MarkerShape := MK_NONE;
    end; 

    CloseData(COD_COLORS);


    //rm 2011-06-07 - add legend:
    Series[1].Legend := 'Pre-Rehab  : y = ' + floattostrF(regressionSlope_preRehab, ffFixed, 4, 2) + 'x';
    Series[3].Legend := 'Post-Rehab : y = ' + floattostrF(regressionSlope_postRehab, ffFixed, 4, 2) + 'x';

    SerLegBoxObj.docked := $00000100; //$00000100;//TGFP_TOP;

    //rm 2012-07-16
    SerLegBoxObj.BkColor := clWhite;

    //$00000102; //TGFP_BOTTOM;
    SerLegBox := true;

  end;
  Screen.Cursor := crDefault;

  //SetTextColor(handle,clAqua);
//  txt := pchar(' Pre-Rehabilitation: y= '+ floattostr(regressionslope_preRehab) + 'x');
//  TextOutA(Handle,ChartFX1.LeftGap + 10,
//                  ChartFX1.Height - ChartFX1.TopGap -
//                  ChartFX1.BottomGap - 4,
//                  pChar(txt),
//                  length(txt));
//  TextOutA(Handle, 1,1,pChar(txt),length(txt));


   ChartFX1.PaintInfo2(CPI_GETDC,0,output);
   Handle := output;
   ChartFX1.PaintInfo2(CPI_PRINTINFO,0,output);
  {*Call SetFocus, so that the form will accept key strokes without requiring
   the user to click on the form *}

  SetTextColor(handle,clRed);
  txt := 'y = mx + b';
  TextOutA(Handle,ChartFX1.LeftGap + 10,
                  ChartFX1.Height - ChartFX1.TopGap -
                  ChartFX1.BottomGap - 4,
                  pChar(txt),
                  length(txt));

  {SetTextAlign(handle,TA_LEFT or TA_BOTTOM);
  txt := pchar('Event');
  TextOutA(handle,10,10,'testing',7);}
  SetFocus;
end;

(*
procedure TfrmPostRehab_Analysis.regressionCalculation(xArray, yArray : array of double);
var
  sumX, sumY : real;
  sumXsq, sumYsq : real;
  sumXY : real;
  i : integer;
begin
  if FRegressionType = 1 then
    DoQuadraticRegression(xArray, yArray)
  else begin
  sumX := 0;
  sumY := 0;
  sumXsq := 0;
  sumYsq := 0;
  sumXY := 0;
  for i := 0 to recordcounter - 1 do begin
    sumX := sumX + xArray[i];
    sumY := sumY + yArray[i];
    sumXsq := sumXsq + xArray[i] * xArray[i];
    sumYsq := sumYsq + yArray[i] * yArray[i];
    sumXY := sumXY + xArray[i] * yArray[i];
  end;
  // - divide by zero when recordcount = 1
  if ((recordcounter * sumXsq) - (sumX * sumX)) = 0 then begin
    regressionM := 1e10; //some very large number
    regressionB := (sumY - regressionM * sumX) / recordcounter;
    regressionR := 1;
  end else begin
    regressionM := ((recordcounter * sumXY) - (sumX * sumY))/((recordcounter * sumXsq) - (sumX * sumX));
    regressionB := (sumY - regressionM * sumX) / recordcounter;
    regressionR := ((recordcounter * sumXY) - (sumX * sumY))/ sqrt((recordcounter * sumXsq - (sumX * sumX))*((recordcounter*sumYsq - (sumY * sumY))));
  end;
  end;
end;
*)
(*
procedure TfrmPostRehab_Analysis.simpleLinearRegressionCalculation(xArray, yArray : array of double);
var
  sumX, sumY : real;
  sumXsq, sumYsq : real;
  sumXY : real;
  i : integer;
begin
  sumX := 0;
  sumY := 0;
  sumXsq := 0;
  sumYsq := 0;
  sumXY := 0;
  for i := 0 to recordcounter - 1 do begin
    sumX := sumX + xArray[i];
    sumY := sumY + yArray[i];
    sumXsq := sumXsq + xArray[i] * xArray[i];
    sumYsq := sumYsq + yArray[i] * yArray[i];
    sumXY := sumXY + xArray[i] * yArray[i];
  end;
  {// - divide by zero when recordcount = 1
  if ((recordcounter * sumXsq) - (sumX * sumX)) = 0 then begin
    regressionM := 1e10; //some very large number
    regressionB := (sumY - regressionM * sumX) / recordcounter;
    regressionR := 1;
  end else begin
    regressionM := ((recordcounter * sumXY) - (sumX * sumY))/((recordcounter * sumXsq) - (sumX * sumX));
    regressionB := (sumY - regressionM * sumX) / recordcounter;
    regressionR := ((recordcounter * sumXY) - (sumX * sumY))/ sqrt((recordcounter * sumXsq - (sumX * sumX))*((recordcounter*sumYsq - (sumY * sumY))));
  end;
  end;}

  //Slope(b) = (N * sum of XY - (sum of X)(sum of Y)) / (N x sum of X^2 - sum of X^2)
  regressionSlope_preRehab := (recordcounter * sumXY - sumX * sumY) / (recordcounter * sumXsq - sumXsq);
  // Intercept(a) = (sum of Y - b(sum of X)) / N
  regressionIntercept_preRehab := (sumY - regressionSlope_preRehab * sumX) / recordcounter;

end;
*)

procedure TfrmPostRehab_Analysis.totalLeastSquaresRegressionCalculation(xArray, yArray : array of double; pre_post: integer);
var
  sumX, sumY : real;
  sumXsq, sumYsq : real;
  sumXY : real;
  sumDiffXsqYsq : real; //sum of (X^2 - Y^2)
  i : integer;
  arraycount : integer;
begin
  sumX := 0;
  sumY := 0;
  sumXsq := 0;
  sumYsq := 0;
  sumXY := 0;
  sumDiffXsqYsq := 0;

  //rm 20112-04-19 : default to recordcounter if (pre_post = 0) then
    arraycount := recordcounter;
  if (pre_post = 1) then
    arraycount := postrehabrecordcounter;
//rm 2012-07-03 range check error here when switching to a different analysis:
//if ((arraycount -1) > High(xArray)) then begin
//  MessageDlg('Error - arraycount > High(xArray)', mtError, [mbok], 0);
//  arraycount = High(xArray);
//end;

//rm 2012-07-03 why not just use High(xArray)??  for i := 0 to arraycount - 1 do begin
  for i := 0 to High(xArray) do begin
    sumX := sumX + xArray[i];
    sumY := sumY + yArray[i];
    sumXsq := sumXsq + xArray[i] * xArray[i];
    sumYsq := sumYsq + yArray[i] * yArray[i];
    sumXY := sumXY + xArray[i] * yArray[i];
    sumDiffXsqYsq := sumDiffXsqYsq + ((xArray[i] * xArray[i])- (yArray[i] * yArray[i]));
  end;
  {// - divide by zero when recordcount = 1
  if ((recordcounter * sumXsq) - (sumX * sumX)) = 0 then begin
    regressionM := 1e10; //some very large number
    regressionB := (sumY - regressionM * sumX) / recordcounter;
    regressionR := 1;
  end else begin
    regressionM := ((recordcounter * sumXY) - (sumX * sumY))/((recordcounter * sumXsq) - (sumX * sumX));
    regressionB := (sumY - regressionM * sumX) / recordcounter;
    regressionR := ((recordcounter * sumXY) - (sumX * sumY))/ sqrt((recordcounter * sumXsq - (sumX * sumX))*((recordcounter*sumYsq - (sumY * sumY))));
  end;
  end;}

  //Linear regression without the intercept term
  {
  Total least squares method
  The above equations assume that (xi) data are known exactly whereas (yi)
  data have random distribution. In case that both (xi) & (yi) are random
  we can minimize the orthogonal distances from the observations to the
  regression line (total least squares method). Here we will show equation
  for simple linear regression model without the intercept term y = bx under
  the assumption that x and y have equal variances. For general case please
  see Deming regression.

  slope = (- sum (X^2 - Y^2) +/- sqrt ([(sum (X^2 - Y^2)]^2 + 4 (sum of XY)^2] ) / 2 * sum XY
  }
  if (pre_post = 0) then begin
    //rm 2012-04-17 - error checking
    if (sumxy = 0) then
      regressionslope_preRehab := 0
    else
      regressionslope_preRehab := (-1 * sumDiffXsqYsq + sqrt(sumDiffXsqYsq*sumDiffXsqYsq+4*sumXY*sumXY))/(2 * sumxy);
    regressionintercept_preRehab := 0;
  end else begin
    //rm 2012-04-17 - error checking
    if (sumxy = 0) then
      //rm 2012-07-03 - a bug fix here: regressionslope_preRehab := 0
      regressionslope_postRehab := 0
    else
      regressionslope_postRehab := (-1 * sumDiffXsqYsq + sqrt(sumDiffXsqYsq*sumDiffXsqYsq+4*sumXY*sumXY))/(2 * sumxy);
    regressionintercept_postRehab := 0;
  end;
end;



procedure TfrmPostRehab_Analysis.TotalRobserved1Click(Sender: TObject);
begin
//toggle correlationOption
//  if TotalRobserved1.Checked then correlationOption := 1
//  else if RDIIperLF1.Checked then correlationOption := 2;
//  //RedrawChart2;
//  GetData;
  if correlationOption <> 1 then begin
    correlationOption := 1;
    GetData;
  end;
end;

procedure TfrmPostRehab_Analysis.SetRegressionType(iType: integer);
begin
  FRegressionType := iType;
  if FRegressionType = 0 then begin
    Caption := 'Linear Regression Analysis';
    MenuItemSwitchRegressionType.Caption := 'Switch to Second-Order Regression';
  end else begin
    Caption := 'Second-Order Regression Analysis';
    MenuItemSwitchRegressionType.Caption := 'Switch to Linear Regression';
  end;

end;

(*
{2. Quadratic Regression.
  reference, Devore, JL.: "Probability and Statistics for the engineering
  and Scientists", Duxbury Press, Belmont, Ca. 1990, pp516 - 517}
procedure TfrmPostRehab_Analysis.DoQuadraticRegression(xArray, yArray : array of double);
var sumX, sumY, sumXY, sumX2, Sumx2y, Sumx3, Sumx4: Double;
    s1y,s22,s2y,s12,s11,xmean,ymean, x2mean: extended;
  i,j: Integer;
begin
{
  if (FData = nil) or (FData^.next = nil) or (FData^.next^.next = nil)
              or (XStats.SD = 0)  then
  begin
    FCompStats.RegSlope2 := 0;
    if XStats.sd = 0 then FCompStats.Regslope := 0 else
    FCompStats.regintercept := 0;
  end
}
  i := 0;
  if recordcounter < 3 then begin
    regressionM2 := 0;
    regressionM := 0;
    regressionB := 0;
  end else begin
    j := 0;
    sumX := 0;
    sumY := 0;
    sumX2 := 0;
    sumXY := 0;
    sumx2y := 0;
    sumx3 := 0;
    sumx4 := 0;
    while j < recordcounter do begin
      if xArray[j] > 0 then begin
        inc(i);
        sumX := sumX + xArray[j];
        sumY := sumY + yArray[j];
        sumX2 := sumX2 + (xArray[j] * xArray[j]);
        sumXY := sumXY + (xArray[j] * yArray[j]);
        sumx2y := sumx2y + (xArray[j] * xArray[j] * yArray[j]);
        sumx3 := sumx3 + (xArray[j] * xArray[j] * xArray[j]);
        sumx4 := sumx4 + (xArray[j] * xArray[j] * xArray[j] * xArray[j]);
      end;
      Inc(j);
    end;
    j := i; //ignore where X = 0
    xmean := sumx/j;
    ymean := sumy/j;
    x2mean := sumx2/j;
    s1y := sumxy - j * xmean * ymean;
    s2y := sumx2y - j * xmean * xmean * ymean;
    s11 := sumx2 - j * xmean * xmean;
    s12 := sumx3 - j * xmean * x2mean;
    s22 := sumx4 - j * x2mean * x2mean;
    {
    regressionM2 := (s2y*s11 - s1y*s12) / (s11*s22 - s12*s12);
    regressionM := (s1y*s22 - s2y*s12) / (s11*s22 - s12*s12);
    regressionB := (sumY / j) - regressionM * (sumX / j) -
                             (regressionM2 * (sumX2 / j));
    }
    regressionM := ((sumxy * sumx4) - (sumx2y * sumx3)) / ((sumx2 * sumx4) - (sumx3 * sumx3));
    regressionM2 := ((sumx2 * sumx2y) - (sumxy * sumx3)) / ((sumx2 * sumx4) - (sumx3 * sumx3));
    regressionB := 0;                        
  end;
  // y = regressionM2 * x^2 + regressionM * x + regressionB
end;
*)

procedure TfrmPostRehab_Analysis.ChartFX1LButtonDown(ASender: TObject;
  x, y: Smallint; var nRes: Smallint);
begin
  timerStart := DateTimeToTimeStamp(Time);
  boDrawingLine := true;
  ChartFX1.PixelToValue(x,y,VXDn,VYDn,AXIS_Y);
  //AnnoText.Text := 'Mouse Down ' + InttoStr(x) + ', ' +
  //InttoStr(y) + '  ' +
  //FormatFloat('#.###',VXDn) + ', ' +
  //FormatFloat('#.###',VYDn);
  //AnnoText.Refresh(true);
end;

procedure TfrmPostRehab_Analysis.ChartFX1LButtonUp(ASender: TObject; x,
  y: Smallint; var nRes: Smallint);
begin
  timerEnd := DateTimeToTimeStamp(Time);
  boDrawingLine := false;
  ChartFX1.PixelToValue(x,y,VXUp,VYUp,AXIS_Y);
  DrawUserLine;
  invalidateGraph;
end;

procedure TfrmPostRehab_Analysis.ChartFX1MouseMoving(ASender: TObject;
  x, y: Smallint; var nRes: Smallint);
begin
  if boDrawingLine then
  begin
    timerEnd := DateTimeToTimeStamp(Time);
    if (timerEnd.time - timerStart.time) > 200 then begin
      ChartFX1.PixelToValue(x,y,VXUp,VYUp,AXIS_Y);
      //AnnoText.Text := 'y = ' +
      //  FormatFloat('#.####',GetSlope) +  'x + ' +
      //  FormatFloat('#.####',GetYIntercept);
      //AnnoText.Refresh(true);
      boLineDrawn := true;
      DrawUserLine;
      invalidateGraph;
    end;
  end;
end;

procedure TfrmPostRehab_Analysis.ChartFX1PostPaint(ASender: TObject; w,
  h: Smallint; lPaint: Integer; var nRes: Smallint);
begin
  DrawUserLine;
  //rm 2011-06-07 added DrawText;
  DrawText;
end;
procedure TfrmPostRehab_Analysis.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmPostRehab_Analysis.DrawUserLine;
var x1,y1,x2,y2: integer;
  oldpen,pen: HPEN;
  myHandle: HDC;
  input, output: OLEVariant;
  strEQ: string;
begin
  if boLineDrawn then
  begin
    ChartFX1.ValueToPixel(VXDn,VYDn,x1,y1,AXIS_Y);
    ChartFX1.ValueToPixel(VXUp,VYUp,x2,y2,AXIS_Y);
//check to see if user drew a line, if it is just a point click, then no line
    if ((abs(x1-x2) < 3) and (abs(y1-y2) < 3)) then
      boLineDrawn := false
    else begin
      ChartFX1.PaintInfo2(CPI_GETDC,0,output);
      myHandle := output;
      ChartFX1.PaintInfo2(CPI_PRINTINFO,0,output);
      pen := CreatePen(PS_SOLID,0,frmMain.ChartRGBYell);
      oldPen := SelectObject(myHandle,pen);
      moveToEx(myHandle,x1,y1,nil);
      lineTo(myHandle,x2,y2);
      strEQ := GetLineEquation;
//  TextOutA(myHandle,ChartFX1.LeftGap + 10,
//                    ChartFX1.Height - ChartFX1.TopGap -
//                    ChartFX1.BottomGap - 4,
//                    pChar(strEQ),
//                    length(strEQ));
  TextOutA(myHandle,ChartFX1.LeftGap + 4,
                    ChartFX1.Height - ChartFX1.BottomGap +14,
                    pChar(strEQ),
                    length(strEQ));

      SelectObject(myHandle,oldPen);
      DeleteObject(pen);
      input := OleVariant(myHandle);
      ChartFX1.PaintInfo2(CPI_RELEASEDC,input,output);
    end;
  end;
end;

procedure TfrmPostRehab_Analysis.Export1Click(Sender: TObject);
begin
//do nothing
end;
{
procedure TfrmPostRehab_Analysis.FillInRegressionValue;
var
  i : integer;
  forCounter : real;
begin

  if FRegressionType = 1 then
    FillInQuadraticRegressionValue
  else begin
    vertexCounter := recordCounter;

    setlength(regressionXvalue,recordcounter);
    setlength(regressionYvalue,recordcounter);

    //forCounter := 0;

    regressionXvalue[0] := 0;
    for i := 1 to recordcounter - 1 do
      regressionXvalue[i] := (1 / (recordcounter-1)) * (i+1);

    for i := 0 to recordcounter - 1 do begin
      regressionYvalue[i] := regressionXvalue[i] * regressionM + regressionB;
    end;
  end;

end;
}

procedure TfrmPostRehab_Analysis.FillInRegressionValue3;
var
  i : integer;
  forCounter : real;
begin

      setlength(regressionXvalue_pre,2);
      setlength(regressionYvalue_pre,2);
      setlength(regressionXvalue_post,2);
      setlength(regressionYvalue_post,2);

      regressionXvalue_pre[0] := 0;
      regressionXvalue_post[0] := 0;
      regressionYvalue_pre[0] := 0;
      regressionYvalue_post[0] := 0;

      regressionXvalue_pre[1] := xAxisMax * 1.2;
      regressionXvalue_post[1] := xAxisMax * 1.2;
      regressionYvalue_pre[1] := regressionXvalue_pre[1] * regressionSlope_preRehab
        + regressionIntercept_preRehab;
      regressionYvalue_post[1] := regressionXvalue_post[1] * regressionSlope_postRehab
        + regressionIntercept_postRehab;


{
    if (recordcounter >= postrehabrecordcounter) then begin
      setlength(regressionXvalue_pre,recordcounter);
      setlength(regressionYvalue_pre,recordcounter);

      setlength(regressionXvalue_post,recordcounter);
      setlength(regressionYvalue_post,recordcounter);

      for i := 0 to recordcounter - 1 do begin
        regressionXvalue_pre[i] := i * 1 / recordcounter;
        regressionXvalue_post[i] := i * 1 / recordcounter;
      end;

      for i := 0 to recordcounter - 1 do begin
        regressionYvalue_pre[i] := regressionXvalue_pre[i] * regressionSlope_preRehab
        + regressionIntercept_preRehab;

        regressionYvalue_post[i] := regressionXvalue_post[i] * regressionSlope_postRehab
        + regressionIntercept_postRehab;

      end;

    end else begin
      setlength(regressionXvalue_pre,postrehabrecordcounter);
      setlength(regressionYvalue_pre,postrehabrecordcounter);

      setlength(regressionXvalue_post,postrehabrecordcounter);
      setlength(regressionYvalue_post,postrehabrecordcounter);

      for i := 0 to postrehabrecordcounter - 1 do begin
        regressionXvalue_pre[i] := i * 1 / postrehabrecordcounter;
        regressionXvalue_post[i] := i * 1 / postrehabrecordcounter;
      end;

      for i := 0 to postrehabrecordcounter - 1 do begin
        regressionYvalue_pre[i] := regressionXvalue_pre[i] * regressionSlope_preRehab
        + regressionIntercept_preRehab;

        regressionYvalue_post[i] := regressionXvalue_post[i] * regressionSlope_postRehab
        + regressionIntercept_postRehab;
      end;
    end;
}
end;

procedure TfrmPostRehab_Analysis.FillInRegressionValue2;
var
  i : integer;
  forCounter : real;
begin

    if (recordcounter >= postrehabrecordcounter) then begin
      setlength(regressionXvalue_pre,recordcounter);
      setlength(regressionYvalue_pre,recordcounter);

      setlength(regressionXvalue_post,recordcounter);
      setlength(regressionYvalue_post,recordcounter);

      for i := 0 to recordcounter - 1 do begin
        //regressionXvalue_pre[i] := i * 1 / recordcounter;
        //regressionXvalue_post[i] := i * 1 / recordcounter;
        regressionXvalue_pre[i] := (i * (xAxisMax * 1.2)) / recordcounter;
        regressionXvalue_post[i] := (i * (xAxisMax * 1.2)) / recordcounter;
      end;

      for i := 0 to recordcounter - 1 do begin
        regressionYvalue_pre[i] := regressionXvalue_pre[i] * regressionSlope_preRehab
        + regressionIntercept_preRehab;

        regressionYvalue_post[i] := regressionXvalue_post[i] * regressionSlope_postRehab
        + regressionIntercept_postRehab;

      end;

    end else begin
      setlength(regressionXvalue_pre,postrehabrecordcounter);
      setlength(regressionYvalue_pre,postrehabrecordcounter);

      setlength(regressionXvalue_post,postrehabrecordcounter);
      setlength(regressionYvalue_post,postrehabrecordcounter);

      for i := 0 to postrehabrecordcounter - 1 do begin
        //regressionXvalue_pre[i] := i * 1 / postrehabrecordcounter;
        //regressionXvalue_post[i] := i * 1 / postrehabrecordcounter;
        regressionXvalue_pre[i] := (i * (xAxisMax * 1.2)) / postrehabrecordcounter;
        regressionXvalue_post[i] := (i * (xAxisMax * 1.2)) / postrehabrecordcounter;
      end;

      for i := 0 to postrehabrecordcounter - 1 do begin
        regressionYvalue_pre[i] := regressionXvalue_pre[i] * regressionSlope_preRehab
        + regressionIntercept_preRehab;

        regressionYvalue_post[i] := regressionXvalue_post[i] * regressionSlope_postRehab
        + regressionIntercept_postRehab;
      end;
    end;

    {setlength(regressionXvalue_pre,recordcounter);
    setlength(regressionYvalue_pre,recordcounter);

    setlength(regressionXvalue_post,postrehabrecordcounter);
    setlength(regressionYvalue_post,postrehabrecordcounter);
    }
    {setlength(regressionXvalue_pre,11);
    setlength(regressionYvalue_pre,11);

    setlength(regressionXvalue_post,11);
    setlength(regressionYvalue_post,11);}

    //pre
    {regressionXvalue_pre[0] := 0;
    for i := 1 to recordcounter - 1do
      regressionXvalue_pre[i] := (1 / (recordcounter-1)) * (i+1);

    for i := 0 to recordcounter - 1 do begin
      regressionYvalue_pre[i] := regressionXvalue_pre[i] * regressionSlope_preRehab
        + regressionIntercept_preRehab;
    end;}

    {for i := 1 to recordcounter - 1 do
      regressionXvalue_pre[i-1] := i * 0.1;

    for i := 0 to recordcounter - 1 do begin
      regressionYvalue_pre[i] := regressionXvalue_pre[i] * regressionSlope_preRehab
        + regressionIntercept_preRehab;
    end;}

    {for i := 0 to 10 do
      regressionXvalue_pre[i] := i * 0.1;

    for i := 0 to 10 do begin
      regressionYvalue_pre[i] := regressionXvalue_pre[i] * regressionSlope_preRehab
        + regressionIntercept_preRehab;
    end;}


    //post
    {regressionXvalue_post[0] := 0;
    for i := 1 to recordcounter - 1 do
      regressionXvalue_post[i] := (1 / (postrehabrecordcounter-1)) * (i+1);

    for i := 0 to recordcounter - 1 do begin
      regressionYvalue_post[i] := regressionXvalue_post[i] * regressionSlope_postRehab
        + regressionIntercept_postRehab;
    end;}

    {for i := 1 to postrehabrecordcounter do
      regressionXvalue_post[i-1] := (i-1)*0.1;

    for i := 0 to postrehabrecordcounter - 1 do begin
      regressionYvalue_post[i] := regressionXvalue_post[i] * regressionSlope_postRehab
        + regressionIntercept_postRehab;
    end;}

   {for i := 0 to 10 do
      regressionXvalue_post[i] := i*0.1;

    for i := 0 to 10 do begin
      regressionYvalue_post[i] := regressionXvalue_post[i] * regressionSlope_postRehab
        + regressionIntercept_postRehab;
    end;}

end;

{
procedure TfrmPostRehab_Analysis.FillInQuadraticRegressionValue;
var
  i : integer;
  forCounter : real;
begin
  vertexCounter := 100; //20;
  setlength(regressionYvalue,vertexCounter);
  setlength(regressionXvalue,vertexCounter);
  forCounter := 0;
  for i := 0 to vertexCounter - 1 do begin
    regressionYvalue[i] := forCounter * forCounter * regressionM2 +
                            forCounter * regressionM + regressionB;
    regressionXvalue[i] := forCounter;
    forCounter := forCounter + (1.0 / vertexCounter);
  end;
end;
}
{
procedure TfrmPostRehab_Analysis.FillInScatterYvalue() ;
var
  i : integer;
begin

  setlength(scatterYvalue,recordcounter);
  case linearOption of
    1 : begin
      for i := 0 to recordcounter - 1 do begin
        scatterYvalue[i] := totalRainfall[i];
        yAxisTitle := 'Total Rainfall Volume (inches)';
        yAxisMax := maxRainfall * 1.2;
        xAxisMax := maxR * 1.2;
        linearRegressionTitle := 'Total R Value vs. Total Rainfall Volume';
      end;
    end;

    2 : begin
      for i := 0 to recordcounter - 1 do begin
        scatterYvalue[i] := totalRainfall2wksBefore[i];
        yAxisTitle := 'Total Rainfall Volume 2 Weeks Prior To Event(inches)';
        yAxisMax := maxRainfall2Wk * 1.2;
        xAxisMax := maxR * 1.2;
        linearRegressionTitle := 'Total R Value vs. Total Rainfall Volume 2 Weeks Prior to Event';
      end;
    end;

    3 : begin
      for i := 0 to recordcounter - 1 do begin
        scatterYvalue[i] := peakHourlyRainfallIntensity[i];
        yAxisTitle := 'Peak Hourly Rainfall Intensity (in/hr)';
        yAxisMax := maxIntensity * 1.2;
        xAxisMax := maxR * 1.2;
        linearRegressionTitle := 'Total R Value vs. Peak Hourly Rainfall Intensity';
      end;
    end;


    4 : begin
      for i := 0 to recordcounter - 1 do begin
        scatterYvalue[i] := rainfallDuration[i];
        yAxisTitle := 'Rainfall Duration (Day)';
        yAxisMax := maxDuration * 1.2;
        xAxisMax := maxR * 1.2;
        linearRegressionTitle := 'Total R Value vs. Rainfall Duration';
      end;
    end;
  end;

end;
}
end.
