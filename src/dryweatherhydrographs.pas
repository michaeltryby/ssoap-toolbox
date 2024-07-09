unit dryweatherhydrographs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, {chartfx3,} Menus, ComCtrls, ToolWin, ChartfxLib_TLB, Hydrograph;

type
  TfrmDryWeatherHydrographsForm = class(TForm)
    //ChartFX1: TChartFX;
    MainMenu1: TMainMenu;
    Graph1: TMenuItem;
    Weekdays1: TMenuItem;
    Weekends1: TMenuItem;
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
    procedure Weekdays1Click(Sender: TObject);
    procedure Weekends1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrintPreview1Click(Sender: TObject);
    procedure Print2Click(Sender: TObject);
    procedure AsaBitmap1Click(Sender: TObject);
    procedure AsaMetafile1Click(Sender: TObject);
    procedure AsTextdataonly1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Help1Click(Sender: TObject);
  private
    ChartFX1: TChartFX;
  public
  end;

var
  frmDryWeatherHydrographsForm: TfrmDryWeatherHydrographsForm;

implementation

uses modDatabase, chooseFlowMeter, mainform;

{$R *.DFM}

procedure TfrmDryWeatherHydrographsForm.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmDryWeatherHydrographsForm.Weekdays1Click(Sender: TObject);
begin
  Weekdays1.Checked := not Weekdays1.Checked;
  ChartFX1.Series[0].Visible := Weekdays1.Checked;
end;

procedure TfrmDryWeatherHydrographsForm.Weekends1Click(Sender: TObject);
begin
  Weekends1.Checked := not Weekends1.Checked;
  ChartFX1.Series[1].Visible := Weekends1.Checked;
end;

procedure TfrmDryWeatherHydrographsForm.FormShow(Sender: TObject);
var
  flowMeterName, flowUnitLabel: string;
  meterID, i, size: integer;
  weekdayDWF, weekendDWF: THydrograph;
begin
  Screen.Cursor := crHourglass;
  flowMeterName := frmFlowMeterSelector.SelectedMeter;
  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
  meterID := DatabaseModule.GetMeterIDForName(flowMeterName);
  ChartFX1.Axis[AXIS_Y].Title := 'Flow ('+flowUnitLabel+')';
  weekdayDWF := DatabaseModule.GetWeekdayDWF(meterID);
  weekendDWF := DatabaseModule.GetWeekendDWF(meterID);
  size := weekdayDWF.size;
  ChartFX1.Axis[AXIS_Y].ResetScale;
  
  ChartFX1.OpenDataEx(COD_VALUES,2,size);
  ChartFX1.OpenDataEx(COD_XVALUES,2,size);
  for i := 0 to size - 1 do begin
    ChartFX1.Series[0].YValue[i] := weekdayDWF.Flows[i];
    ChartFX1.Series[1].YValue[i] := weekendDWF.Flows[i];
    ChartFX1.Series[0].XValue[i] := (i / size) * 24.0;
    ChartFX1.Series[1].XValue[i] := (i / size) * 24.0;
  end;
  ChartFX1.CloseData(COD_VALUES);
  ChartFX1.CloseData(COD_XVALUES);

  //ChartFX1.LegendBox := true;
  //ChartFX1.LegendBoxObj :=
  //ChartFX1.Legend[0] := 'Weekday';
  //ChartFX1.Legend[1] := 'Weekend';
//  ChartFX1.LegendBox := true;
  ChartFX1.Series[0].Legend := 'Weekday';
  ChartFX1.Series[1].Legend := 'Weekend';
  ChartFX1.SerLegBoxObj.docked := $00000100;//TGFP_TOP;
  //$00000102; //TGFP_BOTTOM;
  ChartFX1.SerLegBox := true;

  //rm 2012-07-16
  ChartFX1.SerLegBoxObj.BkColor := clWhite;

  weekdayDWF.Free;
  weekendDWF.Free;
  Screen.Cursor := crDefault;
end;

procedure TfrmDryWeatherHydrographsForm.Help1Click(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmDryWeatherHydrographsForm.FormCreate(Sender: TObject);
begin
  ChartFX1:=TChartFX.Create(Self);
  with ChartFX1 do begin
    Parent := Self;
    Left := 8;
    Top := 8;
    //Width := ClientWidth - 16;
    //Height := ClientHeight - 16;
    TabOrder := 8;
    visible := true;
    Chart3D := false;
    TypeEx := TypeEx OR CTE_SMOOTH;
    MarkerShape := MK_NONE;
    ChartType := LINES;
  end;
  ChartFX1.Title[0] := 'Dry Weather Hydrographs';
  with ChartFX1.Axis[AXIS_X] do begin
    Title := 'Hours';
    Min := 0;
    Step := 1;
    Max := 24;
  end;
end;

procedure TfrmDryWeatherHydrographsForm.FormResize(Sender: TObject);
begin
    ChartFX1.Width := ClientWidth - 16;
    ChartFX1.Height := ClientHeight - 16;
end;

procedure TfrmDryWeatherHydrographsForm.PrintPreview1Click(
  Sender: TObject);
begin
  ChartFX1.ShowDialog(CDIALOG_PAGESETUP,0);
end;

procedure TfrmDryWeatherHydrographsForm.Print2Click(Sender: TObject);
begin
  ChartFX1.ShowDialog(CDIALOG_PRINT,0);
end;

procedure TfrmDryWeatherHydrographsForm.AsaBitmap1Click(Sender: TObject);
begin
  ChartFX1.Export(CHART_BITMAP,'');
end;

procedure TfrmDryWeatherHydrographsForm.AsaMetafile1Click(Sender: TObject);
begin
  ChartFX1.Export(CHART_METAFILE,'');
end;

procedure TfrmDryWeatherHydrographsForm.AsTextdataonly1Click(
  Sender: TObject);
begin
//rm 2010-10-07 - the x-axis is not labeled and is rounded to nearest hour
  //rm 2010-10-07
  //ChartFX1.Export(CHART_DATA,'');
  ChartFX1.Axis[AXIS_X].Decimals := 2;
  ChartFX1.Export(CHART_DATA,'');
  ChartFX1.Axis[AXIS_X].Decimals := 0;

end;

end.

