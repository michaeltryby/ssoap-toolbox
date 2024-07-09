unit RainfallDataReview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ChartfxLib_TLB, Grids, StdCtrls, ADODB_TLB;

type
  TfrmRainfallReview = class(TForm)
    Label7: TLabel;
    RaingaugeNameComboBox: TComboBox;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblLargestEvent: TLabel;
    lblVolume: TLabel;
    lblStart: TLabel;
    lblDuration: TLabel;
    Button1: TButton;
    Label1: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure RaingaugeNameComboBoxChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    ChartFX1: TChartFX;
    FRainGaugeName: string;
    FRainGaugeID: integer;
    FConversionToInches: real;

    startDateTime, endDateTime: TDateTime;

    startDay, endDay, days, maximumMove: integer;
    timestep, segmentsPerDay: integer;
    totalSegments: integer;
    rainfall: array of real;

    timestamp: TDateTime;
    rtimestamp: TTimeStamp;

    procedure DrawXAxisLabels();
    procedure DrawXAxisLabels2(x,y,w,h: Smallint);

    procedure SetRainGauge(sRainGaugeName: string);

    function GetAnalysisID: integer;
    procedure fillchart;
    procedure clearchart;
    procedure SetColors;
    procedure SetStatistics;
    procedure InvalidateGraph;
  public
    { Public declarations }
  end;

const
  chartLeft: integer = 230;
  chartTop: integer = 176;
  FLAG_ALL_GAUGES = -99;
  FLAG_ALL_GAUGES_LABEL = '<All Gauges>';

var
  frmRainfallReview: TfrmRainfallReview;
  iStep: integer;
  iPPU: integer;

implementation

uses modDatabase, mainform, StormEventCollection, StormEvent;

{$R *.dfm}

function TfrmRainfallReview.GetAnalysisID: integer;
var AnalysisNames: TStringList;
begin
  AnalysisNames := DatabaseModule.GetAnalysisNamesforRainGaugeID(FRainGaugeID);
  if AnalysisNames.Count > 0 then
    Result := DatabaseModule.GetAnalysisIDForName(AnalysisNames[0])
  else
    Result := -1;
end;

procedure TfrmRainfallReview.InvalidateGraph;
begin
  ChartFX1.OpenDataEx(COD_CONSTANTS,1,0);
  ChartFX1.CloseData(COD_CONSTANTS);
end;

procedure TfrmRainfallReview.Button1Click(Sender: TObject);
var i: integer;
begin
  //iStep := strtoint(InputBox('Please enter the step','Step:',inttostr(iStep)));
//  iPPU := strtoint(InputBox('Please enter the pixels per unit','PPU:',inttostr(iPPU)));
//  fillchart;

//ChartFX1.OpenDataEx(COD_XVALUES,1,totalSegments);

//for i := 0 to 9 do
//messagedlg('X = ' + FloattoStr(ChartFX1.Series[0].Xvalue[1]),mtinformation,[mbok],0);

ChartFX1.OpenDataEx(COD_XVALUES,1,totalSegments);
messagedlg('Min = ' + floattostr(ChartFX1.Axis[AXIS_X].Min),mtinformation,[mbok],0);
ChartFX1.Axis[AXIS_X].Min := startday * 288;//10618848 + 365 * 288;
messagedlg('Min = ' + floattostr(ChartFX1.Axis[AXIS_X].Min),mtinformation,[mbok],0);
ChartFX1.CloseData(COD_XVALUES);


end;

procedure TfrmRainfallReview.clearchart;
begin
  ChartFX1.Visible := false;
end;

procedure TfrmRainfallReview.DrawXAxisLabels;
begin

end;

procedure TfrmRainfallReview.DrawXAxisLabels2(x, y, w, h: Smallint);
begin

end;

procedure TfrmRainfallReview.fillchart;

var
  dataIndex, graphIndex, startIndex, endIndex: integer;
  commonXValue: double;
  timestepsperhour: integer;
begin
  startIndex := 0;
  endIndex := totalSegments - 1;
  with ChartFX1 do begin
    Axis[AXIS_Y].ResetScale;
    Axis[AXIS_X].ResetScale;
    OpenDataEx(COD_VALUES,1,endIndex-startIndex+1);
    OpenDataEx(COD_XVALUES,1,endIndex-startIndex+1);
    for dataIndex := startIndex to endIndex do begin
      graphIndex := dataIndex - startIndex;
      commonXValue := startDay + (dataIndex / segmentsPerDay);
//      commonXValue := startDay + (graphIndex / segmentsPerDay);
      Series[0].XValue[graphIndex] := commonXValue;
      Series[0].YValue[graphIndex] := rainfall[dataIndex];
    end;
    CloseData(COD_VALUES);
      ChartFX1.Axis[AXIS_X].Min := startday * 288;
    CloseData(COD_XVALUES);
    with Axis[AXIS_X] do begin
//      AutoScale := true;
      Format := 'XM/d/yy';
      Grid := True;
      ScaleUnit := segmentsPerDay;
      Min := startDay * segmentsPerDay;
      Max := endday * segmentsPerDay;
    end;
  end;
  //SetColors;
  ChartFX1.Visible := (totalSegments > 0);
end;
(*
  ChartFX1.Visible := false;
  //totalSegments := StringGrid2.RowCount - 1;
  label1.Caption := inttostr(totalSegments);
  if totalSegments > 2 then begin

    startDateTime := StrToDateTime(StringGrid2.Cells[1,1]);
    messagedlg('Start Datetime = ' + Floattostr(startDateTime),mtinformation,[mbok],0);
    endDateTime := StrToDateTime(StringGrid2.Cells[1,totalSegments]);
    messagedlg('End Datetime = ' + Floattostr(endDateTime),mtinformation,[mbok],0);
    timestep := StrToInt(StringGrid1.Cells[3,1]);
    messagedlg('timestep = ' + Inttostr(Timestep),mtinformation,[mbok],0);
    timestepsperhour := 60 div timestep;
    messagedlg('timestepsperhour = ' + inttostr(Timestepsperhour),mtinformation,[mbok],0);

    //messagedlg('totalsegments = ' + inttostr(totalsegments),mtinformation,[mbok],0);

    with ChartFX1 do begin
      Axis[AXIS_Y].ResetScale;
      Axis[AXIS_X].ResetScale;

      OpenDataEx(COD_VALUES,1,totalSegments);
      OpenDataEx(COD_XVALUES,1,totalSegments);
      commonXValue := startDateTime;
      for dataIndex := 1 to totalSegments{-1} do begin
        Series[0].XValue[dataIndex] := commonXValue;  //StrToDateTime(StringGrid2.Cells[1,dataIndex]);
        Series[0].YValue[dataIndex] := StrToFloat(StringGrid2.Cells[2,dataIndex]);
        commonXValue := commonXValue + (dataIndex * (1 / (24 * timestepsperhour)));
        //if ((dataIndex mod timestepsperhour) = 0) then
        //  messagedlg(floattostr(commonXValue),mtinformation,[mbok],0);
      end;
//showmessage(formatdatetime('mm/dd/yyyy hhhh:mm' ,startDateTime));
//showmessage(formatdatetime('mm/dd/yyyy hhhh:mm' ,endDateTime));
    with Axis[AXIS_X] do begin
//      ResetScale;
      //Format := 'XM/d/yy';
      //PixPerUnit := iPPU;
      //Step := iStep;
      //Grid := True;
      //TextColor := clBlack;   {Hide the markers by using the same color as background}
      //ScaleUnit := 10; //(60.0 / 5.0) * 24.0;

      {}
      Min := startDateTime;
      Max := endDateTime;
      Format := AF_DATETIME;
      Format := 'XM/d/yy';
      ResetScale;
      //ScaleUnit := timestepsperhour;
      {}

      //Step := timestepsperhour;
//      ResetScale;

      //PixPerUnit := 100;
{
      Min := startDay;
      Max := Min + aperatureWidth;
      Format := 'XM/d/yy';
      PixPerUnit := 100;
      Step := 1;
      Grid := True;
}
    end;
      CloseData(COD_VALUES);
      CloseData(COD_XVALUES);

    end;
    ChartFX1.Visible := true;
  end;
end;
*)

procedure TfrmRainfallReview.FormCreate(Sender: TObject);
begin
  iStep := 100;
  iPPU := 100;
  ChartFX1:=TChartFX.Create(Self);
  with ChartFX1 do begin
    Parent := Self;
    Left := StringGrid2.Left + StringGrid2.Width + 8;//chartLeft;
    Top := StringGrid2.Top; //chartTop;
    Width := 577;
    Height := 583;
    TabOrder := 8;
    //visible := true;
    Chart3D := false;
    visible := false;
    //Style :=

  end;

end;

procedure TfrmRainfallReview.FormResize(Sender: TObject);
begin
  ChartFX1.Width := Self.ClientWidth - ChartFX1.Left - 8;
  ChartFX1.Height := Self.ClientHeight - ChartFX1.Top - 8;
  StringGrid2.Height := Self.ClientHeight - StringGrid2.Top - 8;
end;

procedure TfrmRainfallReview.FormShow(Sender: TObject);
begin
  RaingaugeNameComboBox.Items := DatabaseModule.GetRaingaugeNames;
  //RaingaugeNameComboBox.Items.Insert(0, FLAG_ALL_GAUGES_LABEL);
  //RaingaugeNameComboBox.Text := FLAG_ALL_GAUGES_LABEL;

  StringGrid1.RowCount := 2;
  StringGrid1.Rows[0].Clear;
  StringGrid1.Rows[1].Clear;
  StringGrid1.ColCount := 6;
  StringGrid1.Cells[1,0] := 'Raingauge ID';
  StringGrid1.Cells[2,0] := 'Rain Units';
  StringGrid1.Cells[3,0] := 'Timestep';
  StringGrid1.Cells[4,0] := 'Start DateTime';
  StringGrid1.Cells[5,0] := 'End DateTime';
  StringGrid1.FixedRows := 1;

  StringGrid2.RowCount := 2;
  StringGrid2.Rows[0].Clear;
  StringGrid2.Rows[1].Clear;
  StringGrid2.ColCount := 4;
  StringGrid2.Cells[1,0] := 'DateTime';
  StringGrid2.Cells[2,0] := 'Volume';
  StringGrid2.Cells[3,0] := 'Code';

  if RaingaugeNameComboBox.Items.Count > 0 then
  begin
    RaingaugeNameComboBox.ItemIndex := 0;
    RaingaugeNameComboBoxChange(sender);
  end;
end;

procedure TfrmRainfallReview.RaingaugeNameComboBoxChange(Sender: TObject);
(*
var
  i, raingaugeID: integer;
  raingaugeName, unitLabel, queryStr: String;
  recSet: _RecordSet;
  bo:boolean;
*)
begin
  SetRainGauge(RaingaugeNameComboBox.Text);

(*
//select raingauge by name
  raingaugeID := -1;
  raingaugeName := RaingaugeNameComboBox.Text;
  if raingaugeName = FLAG_ALL_GAUGES_LABEL then begin
    queryStr := 'SELECT RaingaugeName,TimeStep,StartDateTime,' +
                'EndDateTime,RainUnitID,RainGaugeID FROM Raingauges;';
  end else begin
    FRainGaugeName := raingaugeName;
    FRainGaugeID := DatabaseModule.GetRaingaugeIDForName(FRainGaugeName);
    SetStatistics;
    queryStr := 'SELECT RaingaugeName,TimeStep,StartDateTime,' +
                'EndDateTime,RainUnitID,RainGaugeID FROM Raingauges WHERE ' +
                '(RaingaugeName = "' + FRainGaugeName + '");';
  end;
  //messagedlg(querystr,mtinformation,[mbok],0);
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if not recset.EOF then Begin

  recSet.MoveFirst;
  StringGrid1.RowCount := 2;
  //StringGrid1.Rows[0].Clear;
  StringGrid1.Rows[1].Clear;
{
  StringGrid1.ColCount := 6;
  StringGrid1.Cells[1,0] := 'Raingauge ID';
  StringGrid1.Cells[2,0] := 'Rain Units';
  StringGrid1.Cells[3,0] := 'Timestep';
  StringGrid1.Cells[4,0] := 'Start DateTime';
  StringGrid1.Cells[5,0] := 'End DateTime';
  StringGrid1.FixedRows := 1;
}
  i := 1;
  while not recSet.EOF do begin
    StringGrid1.RowCount := i + 1;
    raingaugeName := recSet.Fields.Item[0].Value;
    raingaugeID := recSet.Fields.Item[5].Value;
    UnitLabel := DatabaseModule.GetRainUnitLabelForRaingauge(raingaugeName);
    StringGrid1.Cells[1,i] := raingaugeName;
    StringGrid1.Cells[2,i] := UnitLabel;
    StringGrid1.Cells[3,i] := recSet.Fields.Item[1].Value;
    StringGrid1.Cells[4,i] := recSet.Fields.Item[2].Value;
    StringGrid1.Cells[5,i] := recSet.Fields.Item[3].Value;
    inc(i);
    recSet.MoveNext;
  end;
  recSet.Close;

  StringGrid2.RowCount := 2;
  //StringGrid2.Rows[0].Clear;
  StringGrid2.Rows[1].Clear;
{
  StringGrid2.ColCount := 4;
  StringGrid2.Cells[1,0] := 'DateTime';
  StringGrid2.Cells[2,0] := 'Volume';
  StringGrid2.Cells[3,0] := 'Code';
}
  if RaingaugeNameComboBox.Text <> FLAG_ALL_GAUGES_LABEL then begin
    queryStr := 'SELECT RaingaugeID, DateTime, Volume, Code ' +
                ' FROM Rainfall WHERE ' +
                ' (RaingaugeID = ' + IntToStr(raingaugeID) + ') ' +
                ' ORDER BY DateTime;';
    recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
    recSet.MoveFirst;
    i := 1;
    while not recSet.EOF do begin
      StringGrid2.RowCount := i + 1;
      StringGrid2.Cells[1,i] := recSet.Fields.Item[1].Value;
      StringGrid2.Cells[2,i] := recSet.Fields.Item[2].Value;
      StringGrid2.Cells[3,i] := recSet.Fields.Item[3].Value;
      inc(i);
      recSet.MoveNext;
    end;
//    if StringGrid2.RowCount > 1 then fillchart else ChartFX1.visible := false;
    fillchart;
  end else begin
    bo := true;
    if StringGrid1.RowCount > 1 then
      StringGrid1SelectCell(sender, 1, 1, bo);
  end;


  {
  TimeStepSpinEdit.Value := recSet.Fields.Item[1].Value;
  EastingEdit.Text := recSet.Fields.Item[2].Value;
  NorthingEdit.Text := recSet.Fields.Item[3].Value;

  UnitsComboBox.Items := DatabaseModule.GetRainUnitLabels();
  UnitLabel := DatabaseModule.GetRainUnitLabelForRaingauge(raingaugeName);
  UnitsComboBox.ItemIndex := UnitsComboBox.Items.IndexOf(UnitLabel);

  otherRaingaugeNames := DatabaseModule.GetRaingaugeNames();
  otherRaingaugeNames.Delete(otherRaingaugeNames.IndexOf(raingaugeName));

  if (DatabaseModule.RaingaugeHasRainfallData(raingaugeName)) then begin
    UnitsComboBox.Enabled := false;
    TimeStepSpinEdit.Enabled := false;
  end
  else begin
    UnitsComboBox.Enabled := true;
    TimeStepSpinEdit.Enabled := true;
  end;
  }
  End;
*)
end;

procedure TfrmRainfallReview.SetColors;
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
    OpenDataEx(COD_COLORS,1,1);
    with Series[0] do begin
      Color := frmMain.ChartRGBRain;//clBlue;
      YAxis := AXIS_Y2;
      Gallery := BAR;
    end;
    CloseData(COD_COLORS);
  end;
end;

procedure TfrmRainfallReview.SetRainGauge(sRainGaugeName: string);
var
  i,j:integer;
  queryStr : string;
  recSet: _RecordSet;
  maxRainfall: double;
begin
  FRainGaugeName := sRainGaugeName;
  FRainGaugeID := DatabaseModule.GetRaingaugeIDForName(FRainGaugeName);
  FConversionToInches := DatabaseModule.GetConversionForRaingauge(FRainGaugeID);
  SetStatistics;
  StringGrid2.RowCount := 2;
  StringGrid2.Rows[1].Clear;
  queryStr := 'SELECT TimeStep,StartDateTime,' +
              'EndDateTime,RainUnitID FROM Raingauges WHERE ' +
              '(RaingaugeID = ' + inttostr(FRainGaugeID) + ');';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
  timestep := recSet.Fields.Item[0].Value;
  StartDateTime := recSet.Fields.Item[1].Value;
  EndDateTime := recSet.Fields.Item[2].Value;
  startDay := trunc(StartDateTime);
  endDay := trunc(EndDateTime) + 1;        {go to start of next day after last flow value}
  days := endDay - startDay;
  recSet.Close;
  segmentsPerDay := 1440 div timeStep;
  totalSegments := days * segmentsPerDay;
  SetLength(rainfall,totalSegments);
{* GET RAIN DATA *}
  maxRainfall := 0.0;
  for i := 0 to totalSegments - 1 do rainfall[i] := 0.0;
  queryStr := 'SELECT [DateTime], Volume, Code FROM Rainfall WHERE ' +
              '((RaingaugeID = ' + inttostr(FRaingaugeID) + ') AND ' +
              '(DateTime >= ' + floattostr(StartDateTime) + ' AND ' +
              'DateTime <= ' + floattostr(EndDateTime) + '))';
//rm 2007-11-14 - ORDER BY DATETIME
  queryStr :=   queryStr + ' ORDER BY [DATETIME];';
  //MessageDlg(queryStr, mtinformation, [mbok],0);
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if no data
  if not recSet.EOF then
    recSet.MoveFirst;
  j := 1;
  while (not recSet.EOF) do begin
    timestamp := recSet.Fields.Item[0].Value;
    rtimestamp := DateTimeToTimeStamp(timestamp);
    i := (trunc(timestamp) - startday) * segmentsPerDay;
    i := i + trunc((rtimestamp.time / MSecsPerDay) * segmentsPerDay);
    rainfall[i] := recSet.Fields.Item[1].Value;
    if (rainfall[i] > maxRainfall) then maxRainfall := rainfall[i];
      StringGrid2.RowCount := j + 1;
      StringGrid2.Cells[1,j] := recSet.Fields.Item[0].Value;
      StringGrid2.Cells[2,j] := recSet.Fields.Item[1].Value;
      StringGrid2.Cells[3,j] := recSet.Fields.Item[2].Value;
      inc(j);
    recSet.MoveNext;
  end;
  recSet.Close;
  label1.caption := 'Max Rainfall = ' + floattostr(maxrainfall);
  if j > 1 then begin
    fillchart;
  end else begin
    clearchart;
    MessageDlg('No rainfall for the selected raingauge.', mtWarning, [mbok],0);
  end;
(*
ChartFX1.OpenDataEx(COD_XVALUES,1,totalSegments);
//messagedlg('Min = ' + floattostr(ChartFX1.Axis[AXIS_X].Min),mtinformation,[mbok],0);
ChartFX1.Axis[AXIS_X].Min := startday * 288;//10618848 + 365 * 288;
//messagedlg('Min = ' + floattostr(ChartFX1.Axis[AXIS_X].Min),mtinformation,[mbok],0);
ChartFX1.CloseData(COD_XVALUES);
*)
end;

procedure TfrmRainfallReview.SetStatistics;
var i, iAnalysisID : integer;
    events : TStormEventCollection;
    event, maxEvent : TStormEvent;
    rainVolume, maxVolume : double;
    sanalysisname: string;
begin
  lblVolume.Caption := '(no events defined)';
  lblStart.Caption := '';
  lblDuration.Caption := '';
  iAnalysisID := GetAnalysisID;
  sanalysisname := DatabaseModule.GetAnalysisNameForID(iAnalysisID);
  events := DatabaseModule.GetEvents(iAnalysisID);
  maxEvent := nil;
  maxVolume := -1;
  for i := 0 to events.Count - 1 do begin
    event := events[i];
    rainVolume := DatabaseModule.RainfallTotalForRaingaugeBetweenDates(
      FRainGaugeID,event.StartDate,event.EndDate);
    if rainVolume > maxVolume then begin
      maxVolume := rainVolume;
      maxEvent := event;
    end;
  end;
  if Length(sanalysisname) > 0 then
    lblLargestEvent.Caption := FRainGaugeName +
    ' from Analysis ' + sanalysisname
  else
    lblLargestEvent.Caption := FRainGaugeName;

  if maxVolume > -1 then begin
    lblVolume.Caption := formatfloat('0.00',maxVolume); //floattostr(maxVolume);
    lblStart.Caption := formatdatetime('mm/dd/yyyy hhhh:mm' ,
        maxEvent.StartDate);
    lblDuration.Caption := formatdatetime('hhhh:mm',
        (maxEvent.StartDate - maxEvent.EndDate));
  end;
end;

procedure TfrmRainfallReview.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
(*
var
  i{, raingaugeID}: integer;
  {raingaugeName,} unitLabel, queryStr: String;
  recSet: _RecordSet;
*)
begin
  SetRainGauge(StringGrid1.Cells[1,ARow]);
(*
//select raingauge by name
  FRainGaugeName := StringGrid1.Cells[1,ARow];
  FRainGaugeID := DatabaseModule.GetRaingaugeIDForName(FRainGaugeName);
  SetStatistics;
  StringGrid2.RowCount := 2;
  StringGrid2.Rows[1].Clear;
//  raingaugeID := ARow;

    queryStr := 'SELECT RaingaugeID, DateTime, Volume, Code ' +
                ' FROM Rainfall WHERE ' +
                ' (RaingaugeID = ' + IntToStr(FRainGaugeID) + ') ' +
                ' ORDER BY DateTime;';

  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if not recset.EOF then Begin
    recSet.MoveFirst;
    i := 1;
    while not recSet.EOF do begin
      StringGrid2.RowCount := i + 1;
      StringGrid2.Cells[1,i] := recSet.Fields.Item[1].Value;
      StringGrid2.Cells[2,i] := recSet.Fields.Item[2].Value;
      StringGrid2.Cells[3,i] := recSet.Fields.Item[3].Value;
      inc(i);
      recSet.MoveNext;
    end;
  end;
  fillchart;

  //if StringGrid2.RowCount > 1 then fillchart else ChartFX1.visible := false;
*)
end;

end.
