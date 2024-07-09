unit RDIIPatterns;
//not used.
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RDIIGraphFrame, ComCtrls, StdCtrls,
  StormEvent, StormEventCollection, rdiiutils, math, Hydrograph, RTKPatternFrame;

type
  TfrmRDIIPatterns = class(TForm)
    GroupBoxRTKParameters: TGroupBox;
    Label6: TLabel;
    LabelAreaUnits: TLabel;
    Label8: TLabel;
    LabelVolUnits: TLabel;
    Label9: TLabel;
    LabelMaxUnits: TLabel;
    Label10: TLabel;
    Label20: TLabel;
    EditArea: TEdit;
    EditPeak: TEdit;
    EditVolume: TEdit;
    btnSaveRTKs: TButton;
    EditDuration: TEdit;
    btnUpdate: TButton;
    Label1: TLabel;
    ComboBoxAnalysisName: TComboBox;
    Label2: TLabel;
    ListBoxEvents: TListBox;
    Label13: TLabel;
    StartDatePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    Label19: TLabel;
    EndDatePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    Label11: TLabel;
    ComboBoxRainGauges: TComboBox;
    FrameRDIIGraph1: TFrameRDIIGraph;
    FrameRTKPattern1: TFrameRTKPattern;
    procedure FormResize(Sender: TObject);
    procedure ComboBoxAnalysisNameChange(Sender: TObject);
    procedure ListBoxEventsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  private
    { Private declarations }
    events: TStormEventCollection;
    event: TStormEvent;
    iRaingaugeID, iMeterID: integer;
    sRaingaugeName, sMeterName: string;
    procedure UpdateChart;
  public
    { Public declarations }
  end;

var
  frmRDIIPatterns: TfrmRDIIPatterns;

implementation

uses analysis, moddatabase;

{$R *.dfm}


procedure TfrmRDIIPatterns.btnUpdateClick(Sender: TObject);
begin
  UpdateChart;
end;

procedure TfrmRDIIPatterns.ComboBoxAnalysisNameChange(Sender: TObject);
var i:integer;
    analysis: TAnalysis;
    event: TStormEvent;
    area: double;
begin
//change active analysisname
//get events for the selected analysis

  FrameRDIIGraph1.AnalysisName := ComboBoxAnalysisName.Text;
  FrameRDIIGraph1.Title := ComboBoxAnalysisName.Text;
  analysis := DatabaseModule.GetAnalysis(ComboBoxAnalysisName.Text);
  events := DatabaseModule.GetEvents(analysis.AnalysisID);
  ListBoxEvents.Clear;
  StartDatePicker.DateTime := 0.0;
  StartTimePicker.DateTime := 0.0;
  EndDatePicker.DateTime := 0.0;
  EndTimePicker.DateTime := 0.0;
  for i := 0 to events.Count - 1 do begin
    event := TStormEvent(events[i]);
    ListBoxEvents.Items.Add(DateTimetoStr(event.StartDate) + ' to ' + DateTimetoStr(event.EndDate));
  end;
  ComboBoxRainGauges.Items := DatabaseModule.GetRaingaugeNames;
  iRaingaugeID := analysis.RaingaugeID;
  sRaingaugeName := databaseModule.GetRaingaugeNameForAnalysis(ComboBoxAnalysisName.Text);
  for i := 0 to comboBoxRainGauges.Items.Count - 1 do begin
    if sRainGaugeName = ComboBoxRainGauges.Items[i] then
      comboboxRainGauges.ItemIndex := i;
  end;
  iMeterID := analysis.FlowMeterID;
  sMeterName := databaseModule.GetFlowMeterNameForID(iMeterID);
  area := databaseModule.GetAreaForAnalysis(ComboBoxAnalysisName.Text);
  editArea.Text := Floattostr(area);

  labelAreaUnits.Caption := 'ac';//databaseModule.getare
  labelMaxUnits.Caption := DatabaseModule.GetRainUnitShortLabelForRaingauge(sRaingaugeName);
  LabelVolUnits.Caption := labelMaxUnits.Caption;

  FrameRDIIGraph1.FlowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(sMeterName);
  FrameRDIIGraph1.RainUnitLabel := labelMaxUnits.Caption;

  if ListBoxEvents.Count > 0 then
    ListBoxEvents.ItemIndex := 0
  else
    ListBoxEvents.ItemIndex := -1;
  ListBoxEventsClick(Sender);
end;

procedure TfrmRDIIPatterns.FormResize(Sender: TObject);
begin
  FrameRDIIGraph1.Width := Self.ClientWidth - FrameRDIIGraph1.Left - 4;
  FrameRDIIGraph1.Height := Self.ClientHeight - 2 * FrameRDIIGraph1.Top;
  FrameRDIIGraph1.FrameResize(Sender);
end;

procedure TfrmRDIIPatterns.FormShow(Sender: TObject);
begin
  ComboBoxAnalysisName.Items := DatabaseModule.GetAnalysisNames;
  ComboBoxAnalysisName.ItemIndex := 0;
  ComboBoxAnalysisNameChange(Sender);
end;

procedure TfrmRDIIPatterns.ListBoxEventsClick(Sender: TObject);
var //event: TStormEvent;
    i: integer;
    rainmax, raintot: real;
begin
//set start and end datetimes
  i := ListBoxEvents.ItemIndex;
  if i>-1 then begin
    event := events[i];
    StartDatePicker.Date := event.StartDate;
    StartTimePicker.DateTime := event.StartDate;
    EndDatePicker.Date := event.EndDate;
    EndTimePicker.DateTime := event.EndDate;
    //now fill in the RTKs from the event
    if (event.T[0] >=0) and (event.T[1] >=0) and (event.T[2]>=0)  then
    begin
      FrameRTKPattern1.SetRTKPatternFromEvent(event);
    {
      FrameRTKPattern1.R1 := event.R[0];
      R2Edit2.Text := floattostr(event.R[1]);
      R3Edit2.Text := floattostr(event.R[2]);
      T1Edit2.Text := floattostr(event.T[0]);
      T2Edit2.Text := floattostr(event.T[1]);
      T3Edit2.Text := floattostr(event.T[2]);
      K1Edit2.Text := floattostr(event.K[0]);
      K2Edit2.Text := floattostr(event.K[1]);
      K3Edit2.Text := floattostr(event.K[2]);
    }
    end;
    rainmax := databaseModule.GetMaximumRainfallBetweenDates(
      iRainGaugeID,event.StartDate,event.EndDate);
    raintot := databaseModule.RainfallTotalForRaingaugeBetweenDates(
      iRainGaugeID,event.StartDate,event.EndDate);
    EditPeak.Text := floattostr(rainmax);
    EditVolume.Text := floattostr(raintot);
    EditDuration.Text := floattostrF(event.duration*24,ffFixed,8,2);
  UpdateChart;
  end;
end;

procedure TfrmRDIIPatterns.UpdateChart;
begin
//update the Chart
  FrameRDIIGraph1.SetRTKPatternFromRTKPatternFrame(FrameRTKPattern1,0);

  FrameRDIIGraph1.StartDate := Event.StartDate;
  FrameRDIIGraph1.EndDate := Event.EndDate;
  FrameRDIIGraph1.Area := strtoFloat(EditArea.Text);
  FrameRDIIGraph1.UpdateData;
  FrameRDIIGraph1.RedrawChart;

end;

end.
