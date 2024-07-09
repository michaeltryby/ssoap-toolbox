unit HydrographGeneration2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, StdCtrls, Spin, ChartfxLib_TLB,Analysis, StormEvent, StormEventCollection, rdiiutils,
  math, Hydrograph, GWIAdjustmentCollection, ADODB_TLB, mainform, DateUtils,
  OleCtrls, ExtCtrls, ComCtrls;

type
  TfrmHydrographGeneration2 = class(TForm)
    Label7: TLabel;
    ComboBoxSewershedName: TComboBox;
    Label5: TLabel;
    ListBoxRDIIAreas: TListBox;
    Label1: TLabel;
    ComboBoxAnalysisName: TComboBox;
    Label2: TLabel;
    ListBoxEvents: TListBox;
    GroupBoxRTKParameters: TGroupBox;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label3: TLabel;
    R1Edit2: TEdit;
    R2Edit2: TEdit;
    R3Edit2: TEdit;
    T1Edit2: TEdit;
    T2Edit2: TEdit;
    T3Edit2: TEdit;
    K1Edit2: TEdit;
    K2Edit2: TEdit;
    K3Edit2: TEdit;
    Label4: TLabel;
    RTotalEdit: TEdit;
    Label6: TLabel;
    EditArea: TEdit;
    LabelAreaUnits: TLabel;
    Label8: TLabel;
    EditPeak: TEdit;
    LabelVolUnits: TLabel;
    Label9: TLabel;
    EditVolume: TEdit;
    LabelMaxUnits: TLabel;
    Label11: TLabel;
    ComboBoxRainGauges: TComboBox;
    StartDatePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    EndDatePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    Label13: TLabel;
    Label19: TLabel;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    SaveDialog1: TSaveDialog;
    SaveStatsDialog: TSaveDialog;
    btnUpdate: TButton;
    btnSaveRTKs: TButton;
    Label10: TLabel;
    EditDuration: TEdit;
    Label20: TLabel;
    procedure okButtonClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveRTKsClick(Sender: TObject);
    procedure R1Edit2Change(Sender: TObject);
    procedure T1Edit2Change(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBoxSewershedNameChange(Sender: TObject);
    procedure ComboBoxAnalysisNameChange(Sender: TObject);
    procedure ListBoxEventsClick(Sender: TObject);
    procedure ListBoxRDIIAreasClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure R1Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure helpButtonClick(Sender: TObject);
  private
    { Private declarations }
    raingaugeNames: TStringlist;
    analysis: TAnalysis;
    analysisID, meterID: integer;
    runningAverageDuration: real;
    events: TStormEventCollection;
    raingaugeName, flowMeterName, rainUnitLabel, volumeUnitLabel: string;
    raingaugeID: integer;
    rainStartDate, rainEndDate: TDateTime;
    decimalPlaces: integer;
    rdeltime: integer;
    //eventTotalR, rdiiEventTotalR: array of real;
    conversionToMGD, conversionToInches: real;
    startDay, endDay, days: integer;
    timestamp: TDateTime;
    rtimestamp: TTimeStamp;
    timestep, segmentsPerDay: integer;
    timestepsToAverage, totalSegments: integer;
    rdiiCurve: array of array of real;
    rdiiTotal: array of real;
    rainfall: array of real;
    //rainVolume: array of real;
    //maxRain : array of real;
    rainTotal,rainMax: double;
    kMax, kRecover, iAbstraction: real;
//    defaultR, defaultT, defaultK : array[0..2] of real;
    testDay : TDateTime;
    totalRDII : array of array of real;
    //nodeID : array of string;
    counter : integer;
    ChartFX1: TChartFX;
    boHasEdits_in_RTKs: boolean;
    loadpts: array of string;
    //procedure UpdateRDIIHydrograph(RTKmethod : integer);
    procedure UpdateRDIIHydrograph2;
    procedure fillchart();
    procedure RedrawChart();
    procedure resetmemory();
    procedure CalculateRDIICurve(contributeArea : real; node : string);
    procedure UpdateDataBasedOnSelectedAnalysis;
    //procedure UpdateDataBasedOnDisplayedParameters;
    //procedure OutputStatsToMemo;
    procedure UpdateDataBasedOnSelectedEvent(iEvent:Integer);
  public
    { Public declarations }
    flowUnitLabel : string;
  end;

const
  chartLeft: integer = 296;
  chartTop: integer = 8;

var
  frmHydrographGeneration2: TfrmHydrographGeneration2;

implementation

uses modDatabase, RTKPatternEditor, feedbackWithMemo, autodayremovalThread;

{$R *.dfm}

procedure TfrmHydrographGeneration2.btnSaveRTKsClick(Sender: TObject);
var RTKPattern: TStringList;
begin
//Save RTKs
RTKPattern := TStringList.Create;
RTKPattern.Add(R1Edit2.Text);
RTKPattern.Add(T1Edit2.Text);
RTKPattern.Add(K1Edit2.Text);
RTKPattern.Add(R2Edit2.Text);
RTKPattern.Add(T2Edit2.Text);
RTKPattern.Add(K2Edit2.Text);
RTKPattern.Add(R3Edit2.Text);
RTKPattern.Add(T3Edit2.Text);
RTKPattern.Add(K3Edit2.Text);
if ListBoxRDIIAreas.ItemIndex > -1 then begin
  RTKPattern.Add('Custom RTK Pattern for RDII Area ' + ListBoxRDIIAreas.Items[ListBoxRDIIAreas.ItemIndex]);
  //RTKPattern.Add('Custom RTK Pattern for RDII Area ' + ListBoxRDIIAreas.Items[ListBoxRDIIAreas.ItemIndex])
end else begin
  RTKPattern.Add('Custom RTK Pattern for RDII Area ' + ComboBoxSewershedName.Text);
  //RTKPattern.Add('Custom RTK Pattern for RDII Area ' + ComboBoxSewershedName.Text)
end;
frmRTKPatternEditor.RTKPatternList := RTKPattern;
  frmRTKPatternEditor.AddingNewRecord := true;
  //frmRTKpatternEditor.RTKPatternName := SelectedRTKPatternName;
  frmRTKpatternEditor.RTKPatternName := 'New_RTK_Pattern';
{
  if ListBoxRDIIAreas.ItemIndex > -1 then begin
  frmRTKPatternEditor.Comments := 'Custom RTK Pattern for RDII Area ' + ListBoxRDIIAreas.Items[ListBoxRDIIAreas.ItemIndex];
  //RTKPattern.Add('Custom RTK Pattern for RDII Area ' + ListBoxRDIIAreas.Items[ListBoxRDIIAreas.ItemIndex])
end else begin
  frmRTKPatternEditor.Comments := 'Custom RTK Pattern for RDII Area ' + ComboBoxSewershedName.Text;
  //RTKPattern.Add('Custom RTK Pattern for RDII Area ' + ComboBoxSewershedName.Text)
end;
}
frmRTKPatternEditor.RainGaugeName := ComboBoxRainGauges.Text;
frmRTKPatternEditor.StartDate := StartDatePicker.DateTime;
frmRTKPatternEditor.EndDate := EndDatePicker.DateTime;
  frmRTKPatternEditor.ShowModal;
end;

procedure TfrmHydrographGeneration2.btnUpdateClick(Sender: TObject);
begin
  //UpdateDataBasedOnSelectedAnalysis;
  //UpdateDataBasedOnDisplayedParameters;
  UpdateRDIIHydrograph2;
  //UpdateRDIIHydrograph(2);
  redrawchart();
end;

procedure TfrmHydrographGeneration2.okButtonClick(Sender: TObject);
var
  sewershedName, queryStr: string;
  sewershedID : integer;
  recSet: _RecordSet;
  F: textfile;
  i, j : integer;
  yearStamp, monthStamp, dayStamp, hourStamp, minuteStamp : word;
  secStamp, milliStamp : word;
begin
  SaveStatsDialog.Filter := 'TXT Files|*.txt';
  SaveStatsDialog.DefaultExt := '.TXT';
  if (SaveStatsDialog.Execute) then begin
    Screen.Cursor := crHourglass;
    AssignFile(F,SaveStatsDialog.Filename);
    Rewrite(F);
    writeln(F,'SWMM5');
    writeln(F,'FROM SSOAP-RDII HYDROGRAPH GENERATION TOOL: Hydrographs for ' + ComboBoxSewershedName.Text);
    writeln(F, inttostr(timestep*60));
    writeln(F, '1');
//- use flow unit label    writeln(F, 'FLOW CFS');
    writeln(F, 'FLOW ' + flowUnitLabel);
    writeln(F, inttostr(counter));
    //- write out node names, one per line
    for i := 0 to counter - 1 do begin
      writeln(F, loadpts[i]);
    end;
    writeln(F, 'Node Year Mon Day Hr Min Sec Flow');
    timestamp := testday;

    for i := 0 to totalSegments - 1 do begin
      DecodeDateTime(timestamp, yearstamp, Monthstamp, DayStamp, hourStamp, minuteStamp,secStamp, milliStamp);
      timestamp := IncMinute(timestamp, timestep);
      for j := 0 to counter - 1 do begin
           writeln(F,loadpts[j],' ',yearstamp,' ',monthstamp,' ',daystamp,' ',hourstamp,' ',
              minutestamp,' 0 ',floattostrF(totalRDII[j,i],ffFixed,15,5));
      end;
    end;
    Screen.Cursor := crDefault;
    CloseFile(F);
  end;
end;
(*
procedure TfrmHydrographGeneration2.UpdateRDIIHydrograph(RTKmethod : integer);
var
  sewershedName, queryStr: string;
  sewershedID : integer;
  recSet: _RecordSet;
  i, j : integer;

begin
  sewershedName := ComboBoxSewershedName.Text;
  sewershedID := DatabaseModule.GetSewershedIDForName(sewershedName);

  queryStr := 'SELECT Node, Area FROM RDII WHERE (SewershedID = ' + inttostr(sewershedID) + ');';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
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
//  setLength(nodeID,counter);

  end;

  i := 0;
  Screen.Cursor := crDefault;
end;
*)

procedure TfrmHydrographGeneration2.UpdateRDIIHydrograph2;
var
  sewershedName, queryStr: string;
  sewershedID : integer;
  recSet: _RecordSet;
  i, j : integer;

begin
  sewershedName := ComboBoxSewershedName.Text;
  sewershedID := DatabaseModule.GetSewershedIDForName(sewershedName);

  //get rdiiareas from rdiiareas table associated with this sewershed
  queryStr := 'SELECT JunctionID, Area FROM RDIIAreas WHERE (SewershedID = ' + inttostr(sewershedID) + ');';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //if there are no rdiiareas - get the whole sewershed
  if recSet.EOF then begin
    recset.close;
    queryStr := 'SELECT JunctionID, Area FROM Sewersheds WHERE (SewershedID = ' + inttostr(sewershedID) + ');';
    recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  end;

  counter := 0;
  setLength(totalRDII,0,0);
  setLength(loadpts,0);
  if recSet.EOF then begin
    MessageDlg('Sewershed ' + sewershedName + ' not found.', mtinformation,[mbok],0);
  end else begin
    recSet.MoveFirst;
    while (not recSet.EOF) do begin
      CalculateRDIICurve(recSet.Fields.Item[1].Value,recSet.Fields.Item[0].Value);
      {add export to file}
      counter := counter + 1;
      setLength(totalRDII,counter,totalSegments);
      for i := 0 to totalSegments - 1 do
        totalRDII[counter-1,i] := rdiitotal[i];
      setLength(loadpts,counter);
      loadpts[counter-1] := recSet.Fields.Item[0].Value;
      recSet.MoveNext;
    end;
    recSet.Close;
//    recSet.MoveFirst;
//  setLength(nodeID,counter);
  end;
  i := 0;
  Screen.Cursor := crDefault;
end;

procedure TfrmHydrographGeneration2.fillchart();
var
  dataIndex, graphIndex, startIndex, endIndex: integer;
  commonXValue: double;
  i: integer;
begin
  {startIndex := trunc(ChartFX1.Axis[AXIS_X].Min - startDay) * segmentsPerDay;
  endIndex := (trunc(ChartFX1.Axis[AXIS_X].Max - startDay) * segmentsPerDay) - 1;}
  //if totalSegments > 0 then begin

  with ChartFX1 do begin
    Axis[AXIS_Y].ResetScale;
    //OpenDataEx(COD_VALUES,1,totalSegments);
    //OpenDataEx(COD_XVALUES,1,totalSegments);
    OpenDataEx(COD_VALUES,counter+1,totalSegments);
    OpenDataEx(COD_XVALUES,counter+1,totalSegments);

    for dataIndex := 0 to totalSegments-1 do begin
      {graphIndex := dataIndex - startIndex;}
      commonXValue := startDay + (dataIndex / segmentsPerDay);
      for i := 0 to counter - 1 do begin
        Series[i].XValue[dataIndex] := commonXValue;
        Series[i].YValue[dataIndex] := totalRDII[i,dataIndex];
      end;
      Series[counter].XValue[dataIndex] := commonXValue;
      Series[counter].YValue[dataIndex] := rainfall[dataIndex];
    end;

    CloseData(COD_VALUES);
    CloseData(COD_XVALUES);
  end;
  //end;
end;


procedure TfrmHydrographGeneration2.FormCreate(Sender: TObject);
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

procedure TfrmHydrographGeneration2.FormResize(Sender: TObject);
begin
  if ClientWidth > chartLeft then
    ChartFX1.Width := ClientWidth - chartLeft - 8;
  if Clientheight > chartTop then
    ChartFX1.Height := ClientHeight - chartTop - 8;
end;

procedure TfrmHydrographGeneration2.FormShow(Sender: TObject);
begin
  ComboBoxSewershedName.Items := DatabaseModule.GetSewershedNames;
  ComboBoxSewershedName.ItemIndex := 0;
  ComboBoxSewershedNameChange(Sender);
//  UpdateDataBasedOnSelectedAnalysis();
//  UpdateRDIIHydrograph(1);
//  RedrawChart();

end;

procedure TfrmHydrographGeneration2.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmHydrographGeneration2.ListBoxEventsClick(Sender: TObject);
var     event: TStormEvent;
      i: integer;
begin
//set start and end datetimes
  i := ListBoxEvents.ItemIndex;
  if i>-1 then begin
    UpdateDataBasedOnSelectedEvent(i);
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
    //now fill in misc
    EditPeak.Text := floattostr(rainMax);
    EditVolume.Text := floattostr(rainTotal);
    labelMaxUnits.Caption := rainUnitLabel;
    labelVolUnits.Caption := rainUnitLabel;//flowunitlabel;
    EditDuration.Text := floattostrF(event.duration*24,ffFixed,8,2);
    //depth = floattostrF(rainVolume[eventIndex],ffFixed,8,decimalPlaces)+' '+rainUnitLabel
    //duration = floattostrF(event.duration*24,ffFixed,8,2)+ ' Hours'
    //'Max '+inttostr(rdeltime)+' Minute Rain    = '+floattostrF(maxRain[eventIndex],ffFixed,8,decimalPlaces)+' '+rainUnitLabel

    //draw chart - but only if some rtks are > 0
//    if (event.T[0] >0) or (event.T[1] >0) or (event.T[2]>0)  then
//    begin
      UpdateRDIIHydrograph2;
      redrawchart();
//    end else begin

//    end;
  end;
end;

procedure TfrmHydrographGeneration2.ListBoxRDIIAreasClick(Sender: TObject);
var i: integer;
    idx: integer;
    dArea: double;
begin
  i := ListBoxRDIIAreas.ItemIndex;
  if i>-1 then begin
    idx := DatabaseModule.GetRDIIAreaIDForName(ListBoxRDIIAreas.Items[i]);
    dArea := DatabaseModule.GetRDIIAreaArea(idx);
    EditArea.Text := floattostr(dArea);
  end;
end;

procedure TfrmHydrographGeneration2.resetMemory();

begin
   {testing}
   setLength(totalRDII,0,0);
   SetLength(loadpts,0);
   counter := 0;
end;

procedure TfrmHydrographGeneration2.T1Edit2Change(Sender: TObject);
begin
  //A T or K has changed
  boHasEdits_in_RTKs := true;
end;

procedure TfrmHydrographGeneration2.CalculateRDIICurve(contributeArea : real; node : string);
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
  for i := 0 to totalSegments - 1 do begin
    for j := 0 to 2 do begin
      rdiiCurve[j,i] := 0.0;
      //rdiiCurve[j,i] := 0.0;
      //rdiiCurve[j,i] := 0.0;
    end;
  end;
  //if timestep <=0 then timestep := 1;
  timestepsPerHour := 60 div timestep;
  abstraction := iabstraction;
  prevRainDate := 0;

  //- do RTKs vary throughout storm?
          //get default RTKs
          //for m := 0 to 2 do begin
          //  R[m] := defaultR[m]; //these be from the Analyses table
          //  T[m] := defaultT[m];
          //  K[m] := defaultK[m];
          //end;
          //override with user-defined - if desired

           R[0] := strtofloat(R1Edit2.Text); //these be from the form
           R[1] := strtofloat(R2Edit2.Text); //which were originally from the event
           R[2] := strtofloat(R3Edit2.Text); //but may have been changed by user
           T[0] := strtofloat(T1Edit2.Text);
           T[1] := strtofloat(T2Edit2.Text);
           T[2] := strtofloat(T3Edit2.Text);
           K[0] := strtofloat(K1Edit2.Text);
           K[1] := strtofloat(K2Edit2.Text);
           K[2] := strtofloat(K3Edit2.Text);


  for i := 0 to days - 1 do begin
    for j := 0 to segmentsPerDay - 1 do begin
      index := (i * segmentsPerDay) + j;
      rain := rainfall[index];
      if (rain > 0) then begin
        { determine the RTK values at this instant }
        //if RTKmethod = 1 then begin
        //  for m := 0 to 2 do begin
        //    R[m] := defaultR[m];
        //    T[m] := defaultT[m];
        //    K[m] := defaultK[m];
        //  end;
          day := (startDay + i) + (j / segmentsPerDay);
          if (prevRainDate = 0) then prevRainDate := day;
          {
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
          }
        //end
        //else begin
        //   R[0] := strtofloat(R1Edit2.Text);
        //   R[1] := strtofloat(R2Edit2.Text);
        //   R[2] := strtofloat(R3Edit2.Text);
        //   T[0] := strtofloat(T1Edit2.Text);
        //   T[1] := strtofloat(T2Edit2.Text);
        //   T[2] := strtofloat(T3Edit2.Text);
        //   K[0] := strtofloat(K1Edit2.Text);
        //   K[1] := strtofloat(K2Edit2.Text);
        //   K[2] := strtofloat(K3Edit2.Text);
        //end;
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
            if ((R[m] > 0.0) and (T[m] > 0.0) and (K[m] > 0.0)) then begin
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
procedure TfrmHydrographGeneration2.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmHydrographGeneration2.ComboBoxAnalysisNameChange(Sender: TObject);
var i:integer;
    analysis: TAnalysis;
    iRaingaugeID: integer;
    sRaingaugeName: string;
    event: TStormEvent;

begin
//change active analysisname
//get events for the selected analysis
  analysisID := DatabaseModule.GetAnalysisIDForName(ComboBoxAnalysisName.Text);
  analysis := DatabaseModule.GetAnalysis(ComboBoxAnalysisName.Text);
  events := DatabaseModule.GetEvents(analysisID);
  ListBoxEvents.Clear;
  StartDatePicker.DateTime := 0.0;
  StartTimePicker.DateTime := 0.0;
  EndDatePicker.DateTime := 0.0;
  EndTimePicker.DateTime := 0.0;
  for i := 0 to events.Count - 1 do
    begin
      event := TStormEvent(events[i]);
      ListBoxEvents.Items.Add(DateTimetoStr(event.StartDate) + ' to ' + DateTimetoStr(event.EndDate));
    end;

  ComboBoxRainGauges.Items := DatabaseModule.GetRaingaugeNames;

  iRaingaugeID := analysis.RaingaugeID;
  sRaingaugeName := databaseModule.GetRaingaugeNameForAnalysis(ComboBoxAnalysisName.Text);
  for i := 0 to comboBoxRainGauges.Items.Count - 1 do
  begin
       //messagedlg('"' + sRainGaugeName + '"/"' +ComboBoxRainGauges.Items[i] + '"',
       // mtInformation,[mbok],0);
       if sRainGaugeName = ComboBoxRainGauges.Items[i] then
       begin
        //messagedlg('True',mtinformation,[mbok],0);
        comboboxRainGauges.ItemIndex := i;
       end;
  end;
  //ComboBoxRainGauges.ItemIndex :=
  //  ComboBoxRainGauges.Items.IndexOfName(sRaingaugeName);
    //messagedlg(sRaingaugeName + ': ' + inttostr(ComboBoxRainGauges.ItemIndex),
    //  mtInformation,[mbOK],0);

  //comboBoxRainGauges.Text := sRaingaugeName;
//    Databasemodule.GetRaingaugeNameForAnalysis(ComboBoxAnalysisName.Text);

  UpdateDataBasedOnSelectedAnalysis();

  if ListBoxEvents.Count > 0 then
    ListBoxEvents.ItemIndex := 0
  else
    ListBoxEvents.ItemIndex := -1;
  ListBoxEventsClick(Sender);
end;

procedure TfrmHydrographGeneration2.ComboBoxSewershedNameChange(
  Sender: TObject);
var iSewerShedID: integer;
    iRaingaugeID: integer;
    sRaingaugeName: string;
begin
  resetmemory();
  iSewerShedID := DatabaseModule.GetSewershedIDForName(ComboBoxSewershedName.Text);
  iRainGaugeID := DatabaseModule.GetRainGaugeIDforSewershedID(iSewerShedID);
  sRainGaugeName := DatabaseModule.GetRaingaugeNameForID(iRainGaugeID);
  EditArea.Text := FloattoStr(DatabaseModule.GetSewerShedArea(iSewerShedID));

  ListBoxRDIIAreas.Items := DatabaseModule.GetRDIIAreaNamesforSewershedID(iSewerShedID);
  ListBoxRDIIAreas.ItemIndex := 0;

  //ComboBoxAnalysisName.Items := DatabaseModule.GetAnalysisNamesforRainGaugeID(iRainGaugeID);
  ComboBoxAnalysisName.Items := DatabaseModule.GetAnalysisNames;
  ComboBoxAnalysisName.ItemIndex := 0;
  ComboBoxAnalysisNameChange(Sender);

//  EditArea.Text := FloattoStr(DatabaseModule.GetSewerShedArea(iSewerShedID));
  //UpdateDataBasedOnSelectedAnalysis();
  //UpdateRDIIHydrograph(1);
  //RedrawChart();

end;

procedure TfrmHydrographGeneration2.R1Edit2Change(Sender: TObject);
var TotalR: double;
begin
  boHasEdits_in_RTKs := true;
  //Changed one of the Rs
  //Calculate total R
  TotalR := 0.0;
  try
    TotalR := TotalR + strtofloat(R1Edit2.Text);
    TotalR := TotalR + strtofloat(R2Edit2.Text);
    TotalR := TotalR + strtofloat(R3Edit2.Text);
  finally
    RTotalEdit.Text := floattostrF(TotalR,ffFixed,5,2);
  end;
end;

procedure TfrmHydrographGeneration2.R1Edit2KeyPress(Sender: TObject;
  var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmHydrographGeneration2.RedrawChart();
var
    titleChart : string;
    txt : string;
    i: integer;
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

    title[2] := ComboBoxSewershedName.Text;

    with Axis[AXIS_X] do begin
      Min := startDay;
      Max := endDay;
      //Format := 'XM/d/yy';
      Format := 'XM/d/yy HH:mm';
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
      //Decimals := 1;
      Decimals := 4;
    end;
    // - rainfall axis
    with Axis[AXIS_Y2] do begin
      TextColor := clWhite;
      Title := 'Rainfall ('+rainUnitLabel+')';
      TitleColor := clWhite;
      Min := ceil(rainMax);
      Max := 0;
      Decimals := 1;
    end;

    fillchart();
    OpenDataEx(COD_COLORS,counter+1,counter+1);
      //Series[0].Color := clAqua;
      for i := 0 to counter - 1 do begin
        Series[i].Color := clAqua;
        Series[i].YAxis := AXIS_Y;
        Series[i].Gallery := LINES;
      end;
      // - rainfall
      with Series[counter] do begin
        Color := clBlue;
        YAxis := AXIS_Y2;
        Gallery := BAR;
      end;

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
//procedure TfrmHydrographGeneration2.UpdateDataBasedOnDisplayedParameters;
//begin
//
//end;

procedure TfrmHydrographGeneration2.UpdateDataBasedOnSelectedAnalysis;
var
  analysisName: string;
  weekdayDWF, weekendDWF: THydrograph;

begin
  Screen.Cursor := crHourglass;
  analysisName := ComboBoxAnalysisName.Text;
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
  //gwiAdjustments := DatabaseModule.GetGWIAdjustments(analysisID);
  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
  rainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(raingaugeName);
  decimalPlaces := DatabaseModule. GetRainfallDecimalPlacesForRaingauge(raingaugeName);
  volumeUnitLabel := DatabaseModule.GetFlowVolumeLabelForMeter(flowMeterName);
  {
  weekdayDWF := DatabaseModule.GetWeekdayDWF(meterID);
  weekendDWF := DatabaseModule.GetWeekendDWF(meterID);
  minWeekdayDWFIndex := weekdayDWF.indexOfMinimum;
  minWeekendDWFIndex := weekdayDWF.indexOfMinimum;
  weekdayDWFMinimum := weekdayDWF.Minimum;
  weekendDWFMinimum := weekendDWF.Minimum;
  weekdayDWF.Free;
  weekendDWF.Free;
  }
  timestep := DatabaseModule.GetFlowTimestep(meterID);
  if (timestep < 1) then
    timestep := DatabaseModule.GetRainTimestep(raingaugeID);
  if (timestep < 1) then
    timestep := 15;

  segmentsPerDay := 1440 div timeStep;
  timestepsToAverage := round(runningAverageDuration*60/timestep);
{
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
}
  Screen.Cursor := crDefault;
end;

procedure TfrmHydrographGeneration2.UpdateDataBasedOnSelectedEvent(iEvent:integer);
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
  event: TStormEvent;

begin
  Screen.Cursor := crHourglass;
  analysisName := ComboBoxAnalysisName.Text;
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
  decimalPlaces := DatabaseModule.GetRainfallDecimalPlacesForRaingauge(raingaugeName);

  {kRecover := analysis.RateOfReduction;
  kMax := analysis.MaxDepressionStorage;}

  //event := events[eventSpinEdit.Value - 1];
  event := events[iEvent];

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

  // - large T or K can make rdii hydrograph extend beyond this default length
  // - added one day - but maybe should use T and K to nail down timebase
  // - last rainfall time + K3*(T3+1) should be end of RDII event
  startDay := trunc(event.StartDate);
  // - endDay := trunc(event.EndDate) + 1;
  endDay := trunc(event.EndDate) + 2;
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
  rainTotal := 0.0;
  rainMax := 0.0;

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
  if recset.EOF then
  begin
    MessageDlg('No rainfall in the specified time period.',mtInformation,[mbok],0);
  end else
  begin
    recSet.MoveFirst;
    while (not recSet.EOF) do begin
      timestamp := recSet.Fields.Item[0].Value;
      rtimestamp := DateTimeToTimeStamp(timestamp);
      i := (trunc(timestamp) - startday) * segmentsPerDay;
      i := i + trunc((rtimestamp.time / MSecsPerDay) * segmentsPerDay);
      rainfall[i] := recSet.Fields.Item[1].Value;
      rainTotal := rainTotal + rainfall[i];
      if (rainfall[i] > rainMax) then
        rainMax := rainfall[i];
      recSet.MoveNext;
    end;
  end;
  recSet.Close;

(*
  events := DatabaseModule.GetEvents(analysisID);
  numEvents := events.count;
  if (numEvents > 0) then begin
    {gwiAdjustments := DatabaseModule.GetGWIAdjustments(analysisID);}
    flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
    rainUnitLabel := DatabaseModule.GetRainUnitShortLabelForRaingauge(raingaugeName);
    volumeUnitLabel := DatabaseModule.GetFlowVolumeLabelForMeter(flowMeterName);

{
    SetLength(rainVolume,0);
    SetLength(maxRain,0);
    SetLength(eventTotalR,0);
    SetLength(rdiiEventTotalR,0);
    SetLength(rainVolume,numEvents);
    SetLength(maxRain,numEvents);
    SetLength(eventTotalR,numEvents);
    SetLength(rdiiEventTotalR,numEvents);
}
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


    DatabaseModule.GetMaximumRainfallBetweenDates(raingaugeID,event.startDate,event.endDate);
*)
    {calculate the simulated RDII arrays}
    {calculateSimulatedRDII();}
    {for each event determine observed and simulated II statistics}
(*
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
  end;
*)
  Screen.Cursor := crDefault;
end;


end.
