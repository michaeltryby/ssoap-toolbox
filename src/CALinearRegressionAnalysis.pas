unit CALinearRegressionAnalysis;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OleCtrls, ChartfxLib_TLB, ADODB_TLB, Analysis,
  Menus, ImgList;

type
  TfrmCALinearRegressionAnalysis = class(TForm)
    Label1: TLabel;
    MainMenu1: TMainMenu;
    Options1: TMenuItem;
    MenuItemSwitchRegressionType: TMenuItem;
    oggleColorScheme1: TMenuItem;
    Export1: TMenuItem;
    Close1: TMenuItem;
    N1: TMenuItem;
    View1: TMenuItem;
    PreConstruction1: TMenuItem;
    PostConstruction1: TMenuItem;
    PreConstruction2: TMenuItem;
    PostConstruction2: TMenuItem;
    ImageList1: TImageList;
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure MenuItemSwitchRegressionTypeClick(Sender: TObject);
    procedure oggleColorScheme1Click(Sender: TObject);
    procedure ChartFX1PostPaint(ASender: TObject; w, h: Smallint;
      lPaint: Integer; var nRes: Smallint);
    procedure ChartFX1MouseMoving(ASender: TObject; x, y: Smallint;
      var nRes: Smallint);
    procedure ChartFX1LButtonUp(ASender: TObject; x, y: Smallint;
      var nRes: Smallint);
    procedure ChartFX1LButtonDown(ASender: TObject; x, y: Smallint;
      var nRes: Smallint);
  private
    { Private declarations }
    caName: string;
    caID: integer;
    analysisID : array[1..4] of integer;
    raingaugeID : array[1..4] of integer;
    totalRValue: array of double;
    totalRainfall : array of double;
    totalRainfall2wksBefore : array of double;
    regressionXvalue : array of double;
    regressionYvalue : array of double;
    scatterYvalue : array of double;
    rainfallDuration : array of double;
    peakHourlyRainfallIntensity : array of double;

    analysis: TAnalysis;
//    maxR, maxRainfall, maxRainfall2Wk, maxDuration, maxIntensity : array[1..4] of double;
    maxR, maxRainfall, maxRainfall2Wk, maxDuration, maxIntensity : double;
    recordCounter, vertexCounter : array[1..4] of integer;
    regressionM, regressionB, regressionR : array[1..4] of double;
    //rm 2007-11-13
    regressionM2: array[1..4] of double;
    linearOption : integer;
    yAxisTitle, linearRegressionTitle : string;
    xAxisMax, yAxisMax : double;

    handle: HDC;

    ChartFX1: TChartFX;
    timerStart, timerEnd: TTimeStamp;

    FRegressionType: integer;//0=linear;1=quadratic

    procedure invalidateGraph();
    procedure DrawUserLine();
    procedure GetTotalRValue(idx: integer);
    procedure RedrawChart(idx: integer);
    function GetSlope:double;
    function GetYIntercept:double;
    function GetLineEquation:string;

    procedure regressionCalculation(xArray, yArray: array of double; idx:integer);
    procedure DoQuadraticRegression(xArray, yArray : array of double; idx:integer);
    procedure FillInRegressionValue(idx: integer);
    procedure FillInQuadraticRegressionValue(idx: integer);
    procedure FillInScatterYvalue(idx: integer);
    procedure SetRegressionType(iType:integer);
  public
    { Public declarations }
    boNoData: boolean;
  end;

var
  frmCALinearRegressionAnalysis: TfrmCALinearRegressionAnalysis;
  boDrawingLine,boLineDrawn: boolean;
  VXDn, VYDn, VXUp, VYUp: Double;
    maxreccount, maxvertcount: integer;

implementation
uses moddatabase, chooseAnalysis, chooseCA, mainform, chooseCALinearRegression;

{$R *.dfm}

procedure TfrmCALinearRegressionAnalysis.ChartFX1LButtonDown(ASender: TObject;
  x, y: Smallint; var nRes: Smallint);
begin
  timerStart := DateTimeToTimeStamp(Time);
  boDrawingLine := true;
  ChartFX1.PixelToValue(x,y,VXDn,VYDn,AXIS_Y);
end;

procedure TfrmCALinearRegressionAnalysis.ChartFX1LButtonUp(ASender: TObject; x,
  y: Smallint; var nRes: Smallint);
begin
  timerEnd := DateTimeToTimeStamp(Time);
  boDrawingLine := false;
  ChartFX1.PixelToValue(x,y,VXUp,VYUp,AXIS_Y);
  DrawUserLine;
  invalidateGraph;
end;

procedure TfrmCALinearRegressionAnalysis.ChartFX1MouseMoving(ASender: TObject;
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

procedure TfrmCALinearRegressionAnalysis.ChartFX1PostPaint(ASender: TObject; w,
  h: Smallint; lPaint: Integer; var nRes: Smallint);
begin
  DrawUserLine;
end;

procedure TfrmCALinearRegressionAnalysis.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmCALinearRegressionAnalysis.DoQuadraticRegression(xArray,
  yArray: array of double; idx: integer);
var sumX, sumY, sumXY, sumX2, Sumx2y, Sumx3, Sumx4: Double;
    s1y,s22,s2y,s12,s11,xmean,ymean, x2mean: extended;
  i,j: Integer;
begin
(*
  if (FData = nil) or (FData^.next = nil) or (FData^.next^.next = nil)
              or (XStats.SD = 0)  then
      { more checks for more degrees of freedom! }
  begin
    FCompStats.RegSlope2 := 0;
    if XStats.sd = 0 then FCompStats.Regslope := 0 else
    FCompStats.regintercept := 0;
  end
*)
  i := 0;
  if recordcounter[idx] < 3 then begin
    regressionM2[idx] := 0;
    regressionM[idx] := 0;
    regressionB[idx] := 0;
  end else begin
    j := 0;
    sumX := 0;
    sumY := 0;
    sumX2 := 0;
    sumXY := 0;
    sumx2y := 0;
    sumx3 := 0;
    sumx4 := 0;
    while j < recordcounter[idx] do begin
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
    regressionM[idx] := ((sumxy * sumx4) - (sumx2y * sumx3)) / ((sumx2 * sumx4) - (sumx3 * sumx3));
    regressionM2[idx] := ((sumx2 * sumx2y) - (sumxy * sumx3)) / ((sumx2 * sumx4) - (sumx3 * sumx3));
    regressionB[idx] := 0;
  end;
  // y = regressionM2 * x^2 + regressionM * x + regressionB
end;

procedure TfrmCALinearRegressionAnalysis.DrawUserLine();
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

procedure TfrmCALinearRegressionAnalysis.Export1Click(Sender: TObject);
begin
//do nothing
end;

procedure TfrmCALinearRegressionAnalysis.FillInQuadraticRegressionValue(idx: integer);
var
  i : integer;
  forCounter : real;
begin
  vertexCounter[idx] := 100; //20;
  setlength(regressionYvalue,vertexCounter[idx]);
  setlength(regressionXvalue,vertexCounter[idx]);
  forCounter := 0;
  for i := 0 to vertexCounter[idx] - 1 do begin
    regressionYvalue[i] := forCounter * forCounter * regressionM2[idx] +
                            forCounter * regressionM[idx] + regressionB[idx];
    regressionXvalue[i] := forCounter;
    forCounter := forCounter + (1.0 / vertexCounter[idx]);
  end;
end;

procedure TfrmCALinearRegressionAnalysis.FillInRegressionValue(idx: integer);
var
  i : integer;
  forCounter : real;
begin
{  setlength(regressionYvalue,20);
  setlength(regressionXvalue,20);}
  if FRegressionType = 1 then
    FillInQuadraticRegressionValue(idx)
  else begin
    vertexCounter[idx] := recordCounter[idx];

    setlength(regressionXvalue,recordcounter[idx]);
    setlength(regressionYvalue,recordcounter[idx]);

    //forCounter := 0;

    regressionXvalue[0] := 0;
    for i := 1 to recordcounter[idx] - 1 do
      regressionXvalue[i] := (1 / (recordcounter[idx]-1)) * (i+1);

    for i := 0 to recordcounter[idx] - 1 do begin
      regressionYvalue[i] := regressionXvalue[i] * regressionM[idx] + regressionB[idx];
    end;
  end;
  {for i := 0 to 19 do begin
    regressionYvalue[i] := forCounter * regressionM + regressionB;
    regressionXvalue[i] := forCounter;
    forCounter := forCounter + 0.05;
  end;}
end;

procedure TfrmCALinearRegressionAnalysis.FillInScatterYvalue(idx: integer);
var
  i : integer;
begin
  setlength(scatterYvalue,recordcounter[idx]);
  case linearOption of
    1 : begin
      for i := 0 to recordcounter[idx] - 1 do begin
        scatterYvalue[i] := totalRainfall[i];
        yAxisTitle := 'Total Rainfall Volume (inches)';
        yAxisMax := maxRainfall * 1.2;
        xAxisMax := maxR * 1.2;
        linearRegressionTitle := 'Total R Value vs. Total Rainfall Volume';
      end;
    end;

    2 : begin
      for i := 0 to recordcounter[idx] - 1 do begin
        scatterYvalue[i] := totalRainfall2wksBefore[i];
        yAxisTitle := 'Total Rainfall Volume 2 Weeks Prior To Event(inches)';
        yAxisMax := maxRainfall2Wk * 1.2;
        xAxisMax := maxR * 1.2;
        linearRegressionTitle := 'Total R Value vs. Total Rainfall Volume 2 Weeks Prior to Event';
      end;
    end;

    3 : begin
      for i := 0 to recordcounter[idx] - 1 do begin
        scatterYvalue[i] := peakHourlyRainfallIntensity[i];
        yAxisTitle := 'Peak Hourly Rainfall Intensity (in/hr)';
        yAxisMax := maxIntensity * 1.2;
        xAxisMax := maxR * 1.2;
        linearRegressionTitle := 'Total R Value vs. Peak Hourly Rainfall Intensity';
      end;
    end;


    4 : begin
      for i := 0 to recordcounter[idx] - 1 do begin
        scatterYvalue[i] := rainfallDuration[i];
        yAxisTitle := 'Rainfall Duration (Day)';
        yAxisMax := maxDuration * 1.2;
        xAxisMax := maxR * 1.2;
        linearRegressionTitle := 'Total R Value vs. Rainfall Duration';
      end;
    end;
  end;
end;

procedure TfrmCALinearRegressionAnalysis.FormCreate(Sender: TObject);
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
end;

procedure TfrmCALinearRegressionAnalysis.FormDestroy(Sender: TObject);
begin
//  ChartFX1.Free;
end;

procedure TfrmCALinearRegressionAnalysis.FormKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var i: integer;
begin
  if (key = VK_RIGHT) or (key = VK_LEFT) or (key = VK_UP) or (key = VK_DOWN) then begin
    linearOption := linearOption + 1;
    if linearOption > 4 then linearOption := 1;

  maxR := 0;
  maxRainfall := 0;
  maxRainfall2Wk := 0;
  maxDuration := 0;
maxreccount := 0;
maxvertcount := 0;

    for i := 1 to 4 do begin

  GetTotalRValue(i);

      case linearOption of
        1: regressionCalculation(totalRvalue, totalRainfall, i);
        2: regressionCalculation(totalRvalue, totalRainfall2wksBefore, i);
        3: regressionCalculation(totalRvalue, peakHourlyRainfallIntensity, i);
        4: regressionCalculation(totalRvalue, rainfallDuration, i);
      end;
      FillInRegressionValue(i);
      //FillInQuadraticRegressionValue();
      FillInScatterYvalue(i);
      RedrawChart(i);
    end;
  end;
end;

procedure TfrmCALinearRegressionAnalysis.FormResize(Sender: TObject);
begin
  if ClientWidth > 16 then
    ChartFX1.Width := ClientWidth - 16;
  if Clientheight > 16 then
    ChartFX1.Height := ClientHeight - 16;
end;

procedure TfrmCALinearRegressionAnalysis.FormShow(Sender: TObject);
var
  analysisName : string;
  i: integer;
begin
//rm 2007-11-13 - new regressiontype
  SetRegressionType(frmCAChooseLinearRegression.RadioGroupRegressionType.ItemIndex);
  setlength(regressionXvalue,0);
  setlength(regressionYvalue,0);
  caName := frmCAChooseLinearRegression.SelectedConditionAssessment;
  caID := DatabaseModule.GetCAID4Name(caName);


  maxR := 0;
  maxRainfall := 0;
  maxRainfall2Wk := 0;
  maxDuration := 0;
maxreccount := 0;
maxvertcount := 0;

  for i := 1 to 4 do begin
    analysisName := DatabaseModule.GetAnalysisName4CAID(caID,i);
    analysis := DatabaseModule.GetAnalysis(analysisName);
    analysisID[i] := analysis.analysisID;
    raingaugeID[i] := analysis.raingaugeID;
  //analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);

  GetTotalRValue(i);
  if boNoData then begin
    ChartFX1.Visible := false;
  end else begin
    ChartFX1.BringToFront;
    ChartFX1.Visible := true;
    if frmCAChooseLinearRegression.RadioButton1.Checked then begin
      linearOption := 1;
      regressionCalculation(totalRvalue, totalRainfall, i);
    end;
    if frmCAChooseLinearRegression.RadioButton2.Checked then begin
      linearOption := 2;
      regressionCalculation(totalRvalue, totalRainfall2wksBefore, i);
    end;
    if frmCAChooseLinearRegression.RadioButton3.Checked then begin
      linearOption := 3;
      regressionCalculation(totalRvalue, peakHourlyRainfallIntensity, i);
    end;
    if frmCAChooseLinearRegression.RadioButton4.Checked then begin
      linearOption := 4;
      regressionCalculation(totalRvalue, rainfallDuration, i);
    end;
    // - required to track mousemove
    ChartFX1.TypeMask := ChartFX1.TypeMask OR CT_TRACKMOUSE;
    boDrawingLine := false;
    FillInRegressionValue(i);
    //FillInQuadraticRegressionValue();
    FillInScatterYvalue(i);
    with ChartFX1 do begin
      with Axis[AXIS_X] do begin
        Min := 0.0;
        Max := 1.0;
        {Format := 'XM/d/yy';}
        TextColor := frmMain.ChartRGBText;
        Decimals := 1;
        PixPerUnit := 100;
        Step := 0.1;
        Grid := True;
        Title := 'Total R Values';
        TitleColor := frmMain.ChartRGBText;   {Hide the markers by using the same color as background}
      end;
    end;
    RedrawChart(i);
  end;
    invalidateGraph;
    ChartFX1.SetFocus;
  end;
end;

function TfrmCALinearRegressionAnalysis.GetLineEquation: string;
begin
  Result := 'y = ' + FormatFloat('0.###',GetSlope) +
            'x + ' + FormatFloat('0.###',GetYIntercept);
end;

function TfrmCALinearRegressionAnalysis.GetSlope: double;
begin
  if (VXUp-VXDn = 0) then
    Result := 9999999999
  else
    Result := ((VYUp-VYDn)/(VXUp-VXDn));
end;

procedure TfrmCALinearRegressionAnalysis.GetTotalRValue(idx: integer);
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
              inttostr(analysisID[idx]) + ') ORDER BY b.[R1]+b.[R2]+b.[R3];';

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

  setlength(totalRValue,counter); //FillChar(totalRValue,counter,0);
  setlength(totalRainfall,counter);  //FillChar(totalRainfall,counter,0);
  setlength(totalRainfall2wksBefore,counter); //FillChar(totalRainfall2wksBefore,counter,0);
  setlength(rainfallDuration,counter); //FillChar(rainfallDuration,counter,0);
  setlength(peakHourlyRainfallIntensity,counter); //FillChar(peakHourlyRainfallIntensity,counter,0);

  //rm 2007-10-18 - prevent crash if no records
  //if not localRecSet.EOF then
  if counter > 0 then
    localRecSet.MoveFirst;
  counter := 0;
  while not(localRecSet.EOF) do begin
    counter := counter + 1;

    if localRecSet.Fields.Item[1].Value > maxR then maxR := localRecSet.Fields.Item[1].Value;
    totalRValue[counter-1] := localRecSet.Fields.Item[1].Value;

    totalRainfall[counter-1] := DatabaseModule.RainfallTotalForRaingaugeBetweenDates(raingaugeID[idx],localRecSet.Fields.Item[2].value,localRecSet.Fields.Item[3].value);
    if totalRainfall[counter-1] > maxRainfall then maxRainfall := totalRainfall[counter-1];

 // - get a null conversion error here:
    if VarIsNull(localRecSet.Fields.Item[2].value) then
      totalRainfall2wksBefore[counter-1] := 0
    else
      totalRainfall2wksBefore[counter-1] :=
    DatabaseModule.RainfallTotalPreceding2Wks(localRecSet.Fields.Item[2].value,raingaugeID[idx]);

    if totalRainfall2wksBefore[counter-1] > maxRainfall2Wk then maxRainfall2Wk := totalRainfall2wksBefore[counter-1];

    rainfallDuration[counter-1] := localRecSet.Fields.Item[3].value - localRecSet.Fields.Item[2].value;
    if rainfallDuration[counter - 1] > maxDuration then maxDuration := rainfallDuration[counter - 1];

    peakHourlyRainfallIntensity[counter-1] := DatabaseModule.GetPeakHourlyRainIntensityBetweenDates(raingaugeID[idx],localRecSet.Fields.Item[2].value,localRecSet.Fields.Item[3].value);
    if peakHourlyRainfallIntensity[counter-1] > maxIntensity then maxIntensity := peakHourlyRainfallIntensity[counter-1];

    localRecSet.MoveNext;
  end;
  //messagedlg(Inttostr(counter) + ' events',mtinformation,[mbok],0);
  boNoData := (counter < 1);
  localRecSet.Close;
  recordCounter[idx] := counter;
end;

function TfrmCALinearRegressionAnalysis.GetYIntercept: double;
begin
  Result := VYDn - (GetSlope * VXDn);
end;

procedure TfrmCALinearRegressionAnalysis.invalidateGraph;
begin
  if boNoData then begin
    ChartFX1.Visible := false;
    exit;
  end else ChartFX1.Visible := true;

  ChartFX1.OpenDataEx(COD_CONSTANTS,1,0);
  ChartFX1.CloseData(COD_CONSTANTS);
end;

procedure TfrmCALinearRegressionAnalysis.MenuItemSwitchRegressionTypeClick(
  Sender: TObject);
var i: integer;
begin

  if FRegressionType = 0 then
    SetRegressionType(1)
  else
    SetRegressionType(0);
  maxR := 0;
  maxRainfall := 0;
  maxRainfall2Wk := 0;
  maxDuration := 0;
maxreccount := 0;
maxvertcount := 0;

    for i := 1 to 4 do begin

  GetTotalRValue(i);

    case linearOption of
      1: regressionCalculation(totalRvalue, totalRainfall, i);
      2: regressionCalculation(totalRvalue, totalRainfall2wksBefore, i);
      3: regressionCalculation(totalRvalue, peakHourlyRainfallIntensity, i);
      4: regressionCalculation(totalRvalue, rainfallDuration, i);
    end;
    FillInRegressionValue(i);
    //FillInQuadraticRegressionValue();
    FillInScatterYvalue(i);
    RedrawChart(i);
    end;

end;

procedure TfrmCALinearRegressionAnalysis.oggleColorScheme1Click(
  Sender: TObject);
var i: integer;
begin
//toggle color scheme
  frmMain.ToggleChartColors;

  maxR := 0;
  maxRainfall := 0;
  maxRainfall2Wk := 0;
  maxDuration := 0;
maxreccount := 0;
maxvertcount := 0;

  for i := 1 to 4 do begin

  GetTotalRValue(i);
    case linearOption of
      1: regressionCalculation(totalRvalue, totalRainfall, i);
      2: regressionCalculation(totalRvalue, totalRainfall2wksBefore, i);
      3: regressionCalculation(totalRvalue, peakHourlyRainfallIntensity, i);
      4: regressionCalculation(totalRvalue, rainfallDuration, i);
    end;
    FillInRegressionValue(i);
    //FillInQuadraticRegressionValue();
    FillInScatterYvalue(i);

    RedrawChart(i);
  end;
end;

procedure TfrmCALinearRegressionAnalysis.RedrawChart(idx: integer);
var
    titleChart : string;
    txt : string;
    I : integer;
    input, output: OLEVariant;
begin

if recordCounter[idx] > maxreccount then maxreccount := recordCounter[idx];
if vertexCounter[idx] > maxvertcount then maxvertcount := vertexCounter[idx];


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
      Step := 0.01;

      PixPerUnit := 100;
      //Step := 0.1;
      //Grid := True;
      Title := 'Total R Values';
      TitleColor := frmMain.ChartRGBText;   {Hide the markers by using the same color as background}
    end;
    OpenDataEx(COD_COLORS,8,0);
    Series[0 + 2*(idx-1)].Color := frmMain.ChartRGBYell;
    Series[1 + 2*(idx-1)].Color := frmMain.ChartRGBText;

    CloseData(COD_COLORS);
    with Axis[AXIS_Y] do begin
      TextColor := frmMain.ChartRGBText;
      PixPerUnit := 100;
      Grid := True;
      ResetScale;
      Title := yAxisTitle;
      TitleColor := frmMain.ChartRGBText;
      Decimals := 1;
      {AdjustScale;}
      Min := 0.0;
      Max := yAxisMax;
    end;
//    if recordCounter[idx] > vertexCounter[idx] then begin
    if maxreccount > maxvertcount then begin
      OpenDataEx(COD_VALUES,8,maxreccount); //recordCounter[idx]);
      OpenDataEx(COD_XVALUES,8,maxreccount); //recordCounter[idx]);
//      for I := 0 to recordCounter[idx] - 1 do begin
      for I := 0 to maxreccount - 1 do begin
        Series[0 + 2*(idx - 1)].XValue[I]:= -1;
        Series[0 + 2*(idx - 1)].YValue[I]:= -1;
        Series[1 + 2*(idx - 1)].XValue[I]:= -1;
        Series[1 + 2*(idx - 1)].YValue[I]:= -1;
      end;
    end else begin
      OpenDataEx(COD_VALUES,8,maxvertcount); //vertexCounter[idx]);
      OpenDataEx(COD_XVALUES,8,maxvertcount); //vertexCounter[idx]);
//      for I := 0 to vertexCounter[idx] - 1 do begin
      for I := 0 to maxvertcount - 1 do begin
        Series[0 + 2*(idx - 1)].XValue[I]:= -1;
        Series[0 + 2*(idx - 1)].YValue[I]:= -1;
        Series[1 + 2*(idx - 1)].XValue[I]:= -1;
        Series[1 + 2*(idx - 1)].YValue[I]:= -1;
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
    for I := 0 to recordCounter[idx] - 1 do begin
      Series[0 + 2*(idx - 1)].XValue[I]:= totalRValue[I];
      Series[0 + 2*(idx - 1)].YValue[I]:= scatterYValue[I];
    end;
    for I := 0 to vertexCounter[idx] - 1 do begin
      Series[1 + 2*(idx - 1)].XValue[I]:= regressionXvalue[I];
      Series[1 + 2*(idx - 1)].YValue[I]:= regressionYvalue[I];
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
    with Series[0 + 2*(idx - 1)] do begin
      Color := clOlive;
      if idx = 1 then begin Color := clBlue; end
      else if idx = 2 then begin Color := clGreen; end
      else if idx = 3 then begin Color := clMaroon; end
      else if idx = 4 then begin Color := clRed; end;
      //Gallery := 0;
      MarkerShape := idx; //MK_NONE;
    end;

    with Series[1 + 2*(idx - 1)] do begin
      if idx = 1 then begin Color := clBlue; end
      else if idx = 2 then begin Color := clGreen; end
      else if idx = 3 then begin Color := clMaroon; end
      else if idx = 4 then begin Color := clRed; end;

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

  //messageDlg(IntToStr(idx),mtInformation, [mbok], 0);

end;

procedure TfrmCALinearRegressionAnalysis.regressionCalculation(xArray,
  yArray: array of double; idx: integer);
var
  sumX, sumY : real;
  sumXsq, sumYsq : real;
  sumXY : real;
  i : integer;
begin
  if FRegressionType = 1 then
    DoQuadraticRegression(xArray, yArray, idx)
  else begin
  sumX := 0;
  sumY := 0;
  sumXsq := 0;
  sumYsq := 0;
  sumXY := 0;
  for i := 0 to recordcounter[idx] - 1 do begin
    sumX := sumX + xArray[i];
    sumY := sumY + yArray[i];
    sumXsq := sumXsq + xArray[i] * xArray[i];
    sumYsq := sumYsq + yArray[i] * yArray[i];
    sumXY := sumXY + xArray[i] * yArray[i];
  end;
  // - divide by zero when recordcount = 1
  if ((recordcounter[idx] * sumXsq) - (sumX * sumX)) = 0 then begin
    regressionM[idx] := 1e10; //some very large number
    regressionB[idx] := (sumY - regressionM[idx] * sumX) / recordcounter[idx];
    regressionR[idx] := 1;
  end else begin
    regressionM[idx] := ((recordcounter[idx] * sumXY) - (sumX * sumY))/((recordcounter[idx] * sumXsq) - (sumX * sumX));
    regressionB[idx] := (sumY - regressionM[idx] * sumX) / recordcounter[idx];
    regressionR[idx] := ((recordcounter[idx] * sumXY) - (sumX * sumY))/ sqrt((recordcounter[idx] * sumXsq - (sumX * sumX))*((recordcounter[idx]*sumYsq - (sumY * sumY))));
  end;
  end;
end;

procedure TfrmCALinearRegressionAnalysis.SetRegressionType(iType: integer);
begin
  FRegressionType := iType;
  if FRegressionType = 0 then begin
    Caption := 'CA Linear Regression Analysis';
    MenuItemSwitchRegressionType.Caption := 'Switch to Second-Order Regression';
  end else begin
    Caption := 'CA Second-Order Regression Analysis';
    MenuItemSwitchRegressionType.Caption := 'Switch to Linear Regression';
  end;

end;

end.
