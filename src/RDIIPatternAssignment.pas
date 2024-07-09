unit RDIIPatternAssignment;
//not used.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, RDIIGraphFrame,
  StormEvent, StormEventCollection, rdiiutils, math, Hydrograph;

type
  TfrmRDIIPatternAssignment = class(TForm)
    GroupBoxRTKParameters: TGroupBox;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    R1Edit2: TEdit;
    R2Edit2: TEdit;
    R3Edit2: TEdit;
    T1Edit2: TEdit;
    T2Edit2: TEdit;
    T3Edit2: TEdit;
    K1Edit2: TEdit;
    K2Edit2: TEdit;
    K3Edit2: TEdit;
    RTotalEdit: TEdit;
    Label7: TLabel;
    ComboBoxSewershedName: TComboBox;
    Label5: TLabel;
    ListBoxRDIIAreas: TListBox;
    FrameRDIIGraph1: TFrameRDIIGraph;
    MemoComments: TMemo;
    btnLink: TButton;
    GroupBoxAnalysisPicker: TGroupBox;
    Label6: TLabel;
    ComboBoxAnalysisName: TComboBox;
    Label8: TLabel;
    ListBoxEvents: TListBox;
    Label13: TLabel;
    Label19: TLabel;
    StartDatePicker: TDateTimePicker;
    EndDatePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    Label11: TLabel;
    ComboBoxRainGauges: TComboBox;
    ComboBoxRTKPattern: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    btnEditRTK: TButton;
    procedure FormResize(Sender: TObject);
    procedure ComboBoxSewershedNameChange(Sender: TObject);
    procedure ComboBoxAnalysisNameChange(Sender: TObject);
    procedure ListBoxEventsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure R1Edit2Change(Sender: TObject);
    procedure ComboBoxRTKPatternChange(Sender: TObject);
    procedure btnEditRTKClick(Sender: TObject);
  private
    { Private declarations }
    events: TStormEventCollection;
    event: TStormEvent;
    iSewerShedID, iRaingaugeID, iMeterID: integer;
    sSewerShedName, sRaingaugeName, sMeterName: string;
    area: double;
    SelectedRTKPatternName: string;
    procedure UpdateChart;
  public
    { Public declarations }
  end;

var
  frmRDIIPatternAssignment: TfrmRDIIPatternAssignment;

implementation

uses analysis, moddatabase, RTKPatternEditor;

{$R *.dfm}

procedure TfrmRDIIPatternAssignment.btnEditRTKClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  frmRTKPatternEditor.AddingNewRecord := false;
  previousItemIndex := ComboBoxRTKPattern.ItemIndex;
  frmRTKpatternEditor.RTKPatternName := SelectedRTKPatternName;
  frmRTKPatternEditor.ShowModal;
  ComboBoxRTKPattern.Items := DatabaseModule.GetRTKPatternNames;
  ComboBoxRTKPattern.ItemIndex := previousItemIndex;
end;

procedure TfrmRDIIPatternAssignment.ComboBoxAnalysisNameChange(Sender: TObject);
var i:integer;
    analysis: TAnalysis;
    event: TStormEvent;
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
//  editArea.Text := Floattostr(area);
//  labelAreaUnits.Caption := 'ac';//databaseModule.getare
//  labelMaxUnits.Caption := DatabaseModule.GetRainUnitShortLabelForRaingauge(sRaingaugeName);
//  LabelVolUnits.Caption := labelMaxUnits.Caption;

  FrameRDIIGraph1.FlowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(sMeterName);
  FrameRDIIGraph1.RainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(sRaingaugeName);

  if ListBoxEvents.Count > 0 then
    ListBoxEvents.ItemIndex := 0
  else
    ListBoxEvents.ItemIndex := -1;
  ListBoxEventsClick(Sender);
end;

procedure TfrmRDIIPatternAssignment.ComboBoxRTKPatternChange(Sender: TObject);
var s: string; i: integer;
    RTKPatternList: TStringList;
begin
  s := ComboBoxRTKPattern.text;
  i := Pos(':',s);
  s := Copy(s,1,i-1);
  SelectedRTKPatternName := s;
  MemoComments.Clear;
//rm 2010-09-29    RTKPatternList := DatabaseModule.GetRTKPatternforName(SelectedRTKPatternName);
    RTKPatternList := DatabaseModule.GetRTKPatternforNameAndMonth(SelectedRTKPatternName, 0);
    if RTKPatternList.Count >8 then begin
       R1Edit2.Text := RTKPatternList[0];
       T1Edit2.Text := RTKPatternList[1];
       K1Edit2.Text := RTKPatternList[2];
       R2Edit2.Text := RTKPatternList[3];
       T2Edit2.Text := RTKPatternList[4];
       K2Edit2.Text := RTKPatternList[5];
       R3Edit2.Text := RTKPatternList[6];
       T3Edit2.Text := RTKPatternList[7];
       K3Edit2.Text := RTKPatternList[8];
      if RTKPatternList.Count >12 then begin
         MemoComments.Lines.Add(RTKPatternList[12])
      end;
    end;
  UpdateChart;
end;

procedure TfrmRDIIPatternAssignment.ComboBoxSewershedNameChange(
  Sender: TObject);
begin
  sSewerShedName := ComboBoxSewershedName.Text;
  iSewerShedID := DatabaseModule.GetSewershedIDForName(sSewerShedName);
  iRainGaugeID := DatabaseModule.GetRainGaugeIDforSewershedID(iSewerShedID);
  sRainGaugeName := DatabaseModule.GetRaingaugeNameForID(iRainGaugeID);
  //EditArea.Text := FloattoStr(DatabaseModule.GetSewerShedArea(iSewerShedID));

  ListBoxRDIIAreas.Items := DatabaseModule.GetRDIIAreaNamesforSewershedID(iSewerShedID);
  ListBoxRDIIAreas.ItemIndex := 0;

  ComboBoxAnalysisName.Items := DatabaseModule.GetAnalysisNames;
  ComboBoxAnalysisName.ItemIndex := 0;
  ComboBoxAnalysisNameChange(Sender);

end;

procedure TfrmRDIIPatternAssignment.FormResize(Sender: TObject);
begin
  GroupBoxRTKParameters.Left := Self.ClientWidth - GroupBoxRTKParameters.Width - 4;
  GroupBoxAnalysisPicker.Left := Self.ClientWidth - GroupBoxAnalysisPicker.Width - 4;
  FrameRDIIGraph1.Width := Self.ClientWidth - GroupBoxRTKParameters.Width - 16;
  FrameRDIIGraph1.Height := Self.ClientHeight - FrameRDIIGraph1.Top - 8;
  FrameRDIIGraph1.FrameResize(Sender);
end;

procedure TfrmRDIIPatternAssignment.FormShow(Sender: TObject);
begin

  ComboBoxSewershedName.Items := DatabaseModule.GetSewershedNames;
  ComboBoxSewershedName.ItemIndex := 0;
  ComboBoxSewershedNameChange(Sender);

  ComboBoxRTKPattern.Items := DatabaseModule.GetRTKPatternNames;
  ComboBoxRTKPattern.ItemIndex := 0;
{
  ComboBoxAnalysisName.Items := DatabaseModule.GetAnalysisNames;
  ComboBoxAnalysisName.ItemIndex := 0;
  ComboBoxAnalysisNameChange(Sender);
}
end;

procedure TfrmRDIIPatternAssignment.ListBoxEventsClick(Sender: TObject);
var //event: TStormEvent;
    i: integer;
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
      R1Edit2.Text := floattostr(event.R[0]);
      R2Edit2.Text := floattostr(event.R[1]);
      R3Edit2.Text := floattostr(event.R[2]);
      T1Edit2.Text := floattostr(event.T[0]);
      T2Edit2.Text := floattostr(event.T[1]);
      T3Edit2.Text := floattostr(event.T[2]);
      K1Edit2.Text := floattostr(event.K[0]);
      K2Edit2.Text := floattostr(event.K[1]);
      K3Edit2.Text := floattostr(event.K[2]);
    end;
    {
    rainmax := databaseModule.GetMaximumRainfallBetweenDates(
      iRainGaugeID,event.StartDate,event.EndDate);
    raintot := databaseModule.RainfallTotalForRaingaugeBetweenDates(
      iRainGaugeID,event.StartDate,event.EndDate);
    EditPeak.Text := floattostr(rainmax);
    EditVolume.Text := floattostr(raintot);
    EditDuration.Text := floattostrF(event.duration*24,ffFixed,8,2);
    }
    UpdateChart;
  end;
end;

procedure TfrmRDIIPatternAssignment.R1Edit2Change(Sender: TObject);
var TotalR: double;
begin
  //boHasEdits_in_RTKs := true;
  //Changed one of the Rs
  //Calculate total R
  TotalR := 0.0;
  try
    TotalR := TotalR + strtofloat(R1Edit2.Text);
    TotalR := TotalR + strtofloat(R2Edit2.Text);
    TotalR := TotalR + strtofloat(R3Edit2.Text);
  finally
    RTotalEdit.Text := floattostrF(TotalR,ffFixed,8,4);
  end;
end;

procedure TfrmRDIIPatternAssignment.UpdateChart;
begin
//update the Chart
  FrameRDIIGraph1.R[0,0] := strtoFloat(R1Edit2.Text);
  FrameRDIIGraph1.R[1,0] := strtoFloat(R2Edit2.Text);
  FrameRDIIGraph1.R[2,0] := strtoFloat(R3Edit2.Text);
  FrameRDIIGraph1.T[0,0] := strtoFloat(T1Edit2.Text);
  FrameRDIIGraph1.T[1,0] := strtoFloat(T2Edit2.Text);
  FrameRDIIGraph1.T[2,0] := strtoFloat(T3Edit2.Text);
  FrameRDIIGraph1.K[0,0] := strtoFloat(K1Edit2.Text);
  FrameRDIIGraph1.K[1,0] := strtoFloat(K2Edit2.Text);
  FrameRDIIGraph1.K[2,0] := strtoFloat(K3Edit2.Text);

//  FrameRDIIGraph1.StartDate := Event.StartDate;
//  FrameRDIIGraph1.EndDate := Event.EndDate;
FrameRDIIGraph1.StartDate := StartDatePicker.Date + StartTimePicker.Time;
FrameRDIIGraph1.EndDate := EndDatePicker.Date + EndTimePicker.Time;
  FrameRDIIGraph1.Area := area;
  FrameRDIIGraph1.UpdateData;
  FrameRDIIGraph1.RedrawChart;

end;

end.
