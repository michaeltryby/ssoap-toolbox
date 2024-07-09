unit obsvssim;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, ChartfxLib_TLB, StormEventCollection, Menus;

type
  TfrmObsVsSimPlot = class(TForm)
//    ChartFX1: TChartFX;
    MainMenu1: TMainMenu;
    Graph1: TMenuItem;
    Close1: TMenuItem;
    Print1: TMenuItem;
    PrintPreview1: TMenuItem;
    Print2: TMenuItem;
    Edit1: TMenuItem;
    CopytoClipboard1: TMenuItem;
    AsaBitmap1: TMenuItem;
    AsaMetafile1: TMenuItem;
    AsTextdataonly1: TMenuItem;
    Help1: TMenuItem;
    oggleColorScheme1: TMenuItem;
    View1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure ChartFX1PostPaint(Sender: TObject; w, h: Smallint;
      lPaint: integer; var nRes: Smallint);
    procedure PrintPreview1Click(Sender: TObject);
    procedure Print2Click(Sender: TObject);
    procedure AsaBitmap1Click(Sender: TObject);
    procedure AsaMetafile1Click(Sender: TObject);
    procedure AsTextdataonly1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure oggleColorScheme1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
  private
    axisMax: real;
    events: TStormEventCollection;
    handle: HDC;
    printing: boolean;
    procedure DrawEvents(x,y,w,h: Smallint);
  public
    { Public declarations }
  end;

var
  frmObsVsSimPlot: TfrmObsVsSimPlot;
  ChartFX1: TChartFX;

implementation

uses computedVsSimulatedRDIISummaryStatistics, StormEvent, mainform;

{$R *.DFM}

procedure TfrmObsVsSimPlot.FormCreate(Sender: TObject);
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
    //Chartfx1.
    //OnLButtonDblClk := ChartFX1LButtonDblClk;
    OnPostPaint := ChartFX1PostPaint;
    //OnLButtonDown := ChartFX1LButtonDown;
    //OnLButtonUp := ChartFX1LButtonUp;
    //OnRButtonUp := ChartFX1RButtonUp;
    //OnMouseMoving := ChartFX1MouseMoving;
  end;

end;

procedure TfrmObsVsSimPlot.FormShow(Sender: TObject);
var
  i: integer;
begin
  events := frmComparisonSummary.events;

  axisMax := 0.0;
  for i := 0 to events.count -1 do begin
    if (frmComparisonSummary.obsIIPeak[i] > axisMax)
      then axisMax := frmComparisonSummary.obsIIPeak[i];
    if (frmComparisonSummary.simIIPeak[i] > axisMax)
      then axisMax := frmComparisonSummary.simIIPeak[i];
  end;
  with ChartFX1 do begin
    Align := alClient;
    RightGap := 15;
    TopGap := 15;
    AllowEdit := False;
    AllowDrag := False;
    AllowResize := False;
    Scrollable := False;
//    RGBBK := clBlack;
    MenuBarObj.Visible := False;
    TypeMask := TypeMask OR CT_TRACKMOUSE;
    TypeEx := TypeEx OR CTE_SMOOTH;

    Printer.ForceColors := true;
    AllowEdit := False;
    AllowDrag := False;
    AllowResize := False;
    Scrollable := False;
    RGBBK := frmMain.ChartRGBBK;//clBlack;
    RGBFont[CHART_TOPFT ] := frmMain.ChartRGBText;
    RGBFont[CHART_XLEGFT] := frmMain.ChartRGBText;
    MenuBarObj.Visible := False;
    MarkerShape := MK_NONE;
    ChartType := LINES;
    ChartFX1.AxesStyle := 3;

    with Axis[AXIS_X] do begin
      Min := 0.0;
      Max := axisMax;
      TextColor := frmMain.ChartRGBText;
      TitleColor := frmMain.ChartRGBText;   {Hide the markers by using the same color as background}
      GridColor := frmMain.ChartRGBText;
      Title := 'OBSERVED PEAK FLOW ('+frmComparisonSummary.flowUnitLabel+')';
      Step := 1.0;
      Decimals := 1;
    end;
    with Axis[AXIS_Y] do begin
      Min := 0.0;
      Max := axisMax;
      TextColor := frmMain.ChartRGBText;
      TitleColor := frmMain.ChartRGBText;
      GridColor := frmMain.ChartRGBText;
      Title := 'SIMULATED PEAK FLOW ('+frmComparisonSummary.flowUnitLabel+')';
      Step := 1.0;
      Decimals := 1;
    end;
    with Series[0] do begin
      MarkerShape := 0;
      Color := clBlue;
    end;

    OpenDataEx(COD_VALUES,1,2);
    OpenDataEx(COD_XVALUES,1,2);
    Series[0].XValue[0] := 0.0;
    Series[0].YValue[0] := 0.0;
    Series[0].XValue[1] := axisMax;
    Series[0].YValue[1] := axisMax;
    CloseData(COD_VALUES);
    CloseData(COD_XVALUES);
  end;
  ChartFX1.OnPostPaint := ChartFX1PostPaint;
end;

procedure TfrmObsVsSimPlot.Help1Click(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmObsVsSimPlot.oggleColorScheme1Click(Sender: TObject);
begin
  frmMain.ToggleChartColors;
  FormShow(Self);
end;

procedure TfrmObsVsSimPlot.ChartFX1PostPaint(Sender: TObject; w,
  h: Smallint; lPaint: integer; var nRes: Smallint);
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

  DrawEvents(origX, origY, w, h);

  input := OleVariant(handle);
  ChartFX1.PaintInfo2(CPI_RELEASEDC,input,output);
end;

procedure TfrmObsVsSimPlot.DrawEvents(x,y,w,h: Smallint);
var
  i, xPos, yPos, pixelWidth, pixelHeight, vertAdjust, fontSize: integer;
  dataXmin, dataXmax, dataYmin, dataYmax, dataXrange, dataYrange: real;
  obsIIPeak, simIIPeak: real;
  txt: PChar;
  font: TFont;
  oldFont: HFONT;
  output: OLEVariant;
  normalColor, outlierColor: COLORREF;
begin
  font := TFont.Create;
  font.name := 'Arial';
  fontSize := 8;
  outlierColor := clRed;
  if (printing) then begin
    ChartFX1.PaintInfo2(CPI_PRINTINFO,fontSize,output);
    fontSize := output shr 16;
    normalColor := clBlue;
  end
  else normalColor := frmMain.ChartRGBText;
  font.Size := fontSize;

  oldFont := SelectObject(handle,font.handle);
  SetTextAlign(handle,TA_CENTER or TA_BOTTOM);

  dataXmin := ChartFX1.Axis[AXIS_X].Min;
  dataXmax := ChartFX1.Axis[AXIS_X].Max;
  dataXrange := dataXmax - dataXmin;
  dataYmin := ChartFX1.Axis[AXIS_Y].Min;
  dataYmax := ChartFX1.Axis[AXIS_Y].Max;
  dataYrange := dataYMax - dataYMin;

  pixelWidth := w - ChartFX1.LeftGap - ChartFX1.RightGap;
  pixelHeight := h - ChartFX1.TopGap - ChartFX1.BottomGap;

  vertAdjust := abs(font.height div 2);
  for i := 0 to events.Count - 1 do begin
    obsIIPeak := frmComparisonSummary.obsIIPeak[i];
    simIIPeak := frmComparisonSummary.simIIPeak[i];
    xPos := x + ChartFX1.LeftGap +
            round(pixelWidth * (obsIIPeak - dataXmin) / dataXrange);
    yPos := y + ChartFX1.TopGap +
            round(pixelHeight * (dataYmax - simIIPeak) / dataYRange) + vertAdjust;
    if (abs(simIIPeak - obsIIPeak) < frmComparisonSummary.allstandardError)
      then SetTextColor(handle,normalColor)
      else SetTextColor(handle,outlierColor);
    txt := pchar(inttostr(i+1));
    TextOutA(handle,xPos,yPos,txt,length(txt));
  end;
  SelectObject(handle,oldFont);
  font.Free;
end;

procedure TfrmObsVsSimPlot.PrintPreview1Click(Sender: TObject);
begin
  ChartFX1.ShowDialog(CDIALOG_PAGESETUP,0);
end;

procedure TfrmObsVsSimPlot.Print2Click(Sender: TObject);
begin
  ChartFX1.ShowDialog(CDIALOG_PRINT,0);
end;

procedure TfrmObsVsSimPlot.AsaBitmap1Click(Sender: TObject);
begin
  ChartFX1.Export(CHART_BITMAP,'');
end;

procedure TfrmObsVsSimPlot.AsaMetafile1Click(Sender: TObject);
begin
  ChartFX1.Export(CHART_METAFILE,'');
end;

procedure TfrmObsVsSimPlot.AsTextdataonly1Click(Sender: TObject);
begin
  ChartFX1.Export(CHART_DATA,'');
end;

procedure TfrmObsVsSimPlot.Close1Click(Sender: TObject);
begin
  Close;
end;

end.
