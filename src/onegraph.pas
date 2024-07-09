unit onegraph;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, Menus, ExtCtrls, ChartfxLib_TLB, StdCtrls, MyChart, AnnotateX_TLB,
  hydrograph, database, math, modDatabase, ADODB_TLB, Variants, StormEvent;

type
  TfrmManualDWFDaySelection = class(TForm)
    MainMenu1: TMainMenu;
    Graph1: TMenuItem;
    KeepMenuOption: TMenuItem;
    DiscardMenuOption: TMenuItem;
    StopMenuOption: TMenuItem;
    Navigation1: TMenuItem;
    PreviousMenuOption: TMenuItem;
    NextMenuOption: TMenuItem;
    HelpMenuOption: TMenuItem;
    View1: TMenuItem;
    N1x1MenuOption: TMenuItem;
    N1x2MenuOption: TMenuItem;
    n1x3MenuOption: TMenuItem;
    BeginingMenuOption: TMenuItem;
    EndMenuOption: TMenuItem;
    N2x2MenuOption: TMenuItem;
    N2x3MenuOption: TMenuItem;
    N3x3MenuOption: TMenuItem;
    UpdateADWF1: TMenuItem;
    procedure FormResize(Sender: TObject);
    procedure ResizePanels;
    procedure CreatePanels;
    procedure FillGraphs;
    procedure RemovePanels;
    procedure N1x1MenuOptionClick(Sender: TObject);
    procedure N1x2MenuOptionClick(Sender: TObject);
    procedure n1x3MenuOptionClick(Sender: TObject);
    procedure N2x2MenuOptionClick(Sender: TObject);
    procedure N2x3MenuOptionClick(Sender: TObject);
    procedure N3x3MenuOptionClick(Sender: TObject);
    procedure LButtonDblClk(Sender: TObject;
                            X: Smallint;
                            Y: Smallint;
                            nSerie: Smallint;
                            nPoint: integer;
                            var nRes: Smallint);
    procedure StopMenuOptionClick(Sender: TObject);
    procedure KeepMenuOptionClick(Sender: TObject);
    procedure DiscardMenuOptionClick(Sender: TObject);
    procedure PreviousMenuOptionClick(Sender: TObject);
    procedure NextMenuOptionClick(Sender: TObject);
    procedure BeginingMenuOptionClick(Sender: TObject);
    procedure EndMenuOptionClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure ShowWeekdays();
    procedure ShowWeekends();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure HelpMenuOptionClick(Sender: TObject);
    procedure UpdateADWF1Click(Sender: TObject);
  private
    weekdayOrWeekend: integer;
    GraphsHorz: integer;
    GraphsVert: integer;
    Panels: array of array of TPanel;
    Graphs: array of array of MyTChartFX;
    meterID, numDays, upperLeftIndex: integer;
    days: daysArray;
    include: array of boolean;
    dwf: THydrograph;
    flowUnitLabel: string;
    timestepsPerHour: integer;
    procedure Stop();
    procedure Keep();
    procedure Discard();
    procedure Previous();
    procedure Next();
    procedure Beginning();
    procedure ToEnd();
    procedure N1x1();
    procedure N1x2();
    procedure N1x3();
    procedure N2x2();
    procedure N2x3();
    procedure N3x3();
    //rm 2010-10-07
    procedure ToggleInclude(idx: integer);
  public
  end;

var
  frmManualDWFDaySelection: TfrmManualDWFDaySelection;

implementation

uses chooseFlowMeter, mainform;

{$R *.DFM}

procedure TfrmManualDWFDaySelection.FormResize(Sender: TObject);
begin
  if (self.Visible) then begin
    ResizePanels;
    FillGraphs;
  end;
end;

procedure TfrmManualDWFDaySelection.CreatePanels();
var
  i, j: integer;
  pAnnList: AnnotationX;
begin
  SetLength(Panels,GraphsHorz,GraphsVert);
  SetLength(Graphs,GraphsHorz,GraphsVert);
  for i := 0 to GraphsHorz - 1 do begin
    for j := 0 to GraphsVert - 1 do begin
      Panels[i,j] := TPanel.Create(Self);
      Panels[i,j].Parent := Self;
      Graphs[i,j] := MyTChartFX.Create(Self);
      with Graphs[i,j] do begin
        Parent := Panels[i,j];
        Align := alClient;
        RightGap := 5;
        TopGap := 5;
        AllowEdit := False;
        ShowTips := False;
        ShowHint := False;
        Gallery := 1;
        Chart3D := False;
        BorderStyle := 0;
        MarkerShape := MK_NONE;
        with Axis[AXIS_Y] do begin
          Title := 'Flow ('+flowUnitLabel+')';
          AutoScale := True;
        end;
        with Axis[AXIS_X] do begin
          Axis[AXIS_X].MinorTickMark := TS_NONE;
          Axis[AXIS_X].LabelAngle := 90;
          Axis[AXIS_X].ScaleUnit := timestepsPerHour;
          Axis[AXIS_X].Step := timestepsPerHour;
        end;
        ContextMenus := False;
        AllowEdit := False;
        AllowDrag := False;
        DblClk(2,0);
        OnLButtonDblClk := LButtonDblClk;
        pAnnList := CoAnnotationX.Create;
        AddExtension(pAnnList);
        pAnnList.ToolBarObj.Visible := False;
        graphs[i,j].Anno := pAnnList;
      end; { end with graphs[i,j] }
    end;
  end;
end;

procedure TfrmManualDWFDaySelection.RemovePanels();
var
  i, j: integer;
begin
  for i := 0 to GraphsHorz - 1 do begin
    for j := 0 to GraphsVert - 1 do begin
      Graphs[i,j].Parent := nil;
      Graphs[i,j].Free;
      Panels[i,j].Parent := nil;
      Panels[i,j].Free;
    end;
  end;
end;

procedure TfrmManualDWFDaySelection.ResizePanels();
var
  GraphWidth, GraphHeight, i ,j: integer;
begin
  GraphWidth := ClientWidth div GraphsHorz;
  GraphHeight := ClientHeight div GraphsVert;
  for i := 0 to GraphsHorz - 1 do begin
    for j := 0 to GraphsVert - 1 do begin
      Panels[i,j].Width := GraphWidth;
      Panels[i,j].Height := GraphHeight;
      Panels[i,j].Left := GraphWidth * i;
      Panels[i,j].Top := GraphHeight * j;
    end;
  end;
end;

procedure TfrmManualDWFDaySelection.LButtonDblClk(Sender: TObject;
                                        X: Smallint;
                                        Y: Smallint;
                                        nSerie: Smallint;
                                        nPoint: integer;
                                        var nRes: Smallint);
var
  pAnnList: AnnotationX;
  pAnnLine,pAnnLine2: AnnArrow;
begin
  if (N1x1MenuOption.Checked) then begin
    //rm 2010-10-07
    //include[upperLeftIndex] := not include[upperLeftIndex];
    ToggleInclude(upperLeftIndex);
    if (upperLeftIndex < numDays - 1) then inc(upperLeftIndex);
    FillGraphs;
  end
  else begin
    frmManualDWFDaySelection.FormDblClick(Sender);
    pAnnList := (Sender as MyTChartFX).Anno;
    if (pAnnlist.Count = 0) then begin
      pAnnLine := AnnArrow(pAnnList.Add(OBJECT_TYPE_ARROW,0));
      pAnnLine.HeadStyle := 0;
      pAnnLine.AllowMove := False;
      pAnnLine.AllowModify := False;
      pAnnLine.Color := RGB(255,0,0);
      pAnnLine.BorderWidth := 10;
      pAnnLine.Width := (Sender as MyTChartFX).ClientWidth;
      pAnnLine.Height := (Sender as MyTChartFX).ClientHeight;

      pAnnLine2 := AnnArrow(pAnnList.Add(OBJECT_TYPE_ARROW,0));
      pAnnLine2.HeadStyle := 0;
      pAnnLine2.AllowMove := False;
      pAnnLine2.AllowModify := False;
      pAnnLine2.Color := RGB(255,0,0);
      pAnnLine2.BorderWidth := 10;
      pAnnLine2.Width := -((Sender as MyTChartFX).ClientWidth);
      pAnnLine2.Height := (Sender as MyTChartFX).ClientHeight;
      pAnnLine2.Left := 0;
    end
    else begin
      pAnnList.Remove(-1);
    end;
    (Sender as MyTChartFX).Refresh;
  end;
end;

procedure TfrmManualDWFDaySelection.StopMenuOptionClick(Sender: TObject);
begin
  Stop();
end;

procedure TfrmManualDWFDaySelection.KeepMenuOptionClick(Sender: TObject);
begin
  Keep();
end;

procedure TfrmManualDWFDaySelection.DiscardMenuOptionClick(Sender: TObject);
begin
  Discard();
end;

procedure TfrmManualDWFDaySelection.PreviousMenuOptionClick(Sender: TObject);
begin
  Previous();
end;

procedure TfrmManualDWFDaySelection.NextMenuOptionClick(Sender: TObject);
begin
  Next();
end;

procedure TfrmManualDWFDaySelection.BeginingMenuOptionClick(Sender: TObject);
begin
  Beginning();
end;

procedure TfrmManualDWFDaySelection.EndMenuOptionClick(Sender: TObject);
begin
  ToEnd();
end;

procedure TfrmManualDWFDaySelection.N1x1MenuOptionClick(Sender: TObject);
begin
  N1x1MenuOption.Checked := True;
  N1x1();
end;

procedure TfrmManualDWFDaySelection.N1x2MenuOptionClick(Sender: TObject);
begin
  N1x2MenuOption.Checked := True;
  N1x2();
end;

procedure TfrmManualDWFDaySelection.n1x3MenuOptionClick(Sender: TObject);
begin
  N1x3MenuOption.Checked := True;
  N1x3();
end;

procedure TfrmManualDWFDaySelection.N2x2MenuOptionClick(Sender: TObject);
begin
  N2x2MenuOption.Checked := True;
  N2x2();
end;

procedure TfrmManualDWFDaySelection.N2x3MenuOptionClick(Sender: TObject);
begin
  N2x3MenuOption.Checked := True;
  N2x3();
end;

procedure TfrmManualDWFDaySelection.N3x3MenuOptionClick(Sender: TObject);
begin
  N3x3MenuOption.Checked := True;
  N3x3();
end;

procedure TfrmManualDWFDaySelection.FormShow(Sender: TObject);
begin
  GraphsHorz := 1;
  GraphsVert := 1;
  N1x1MenuOption.Checked := true;
  upperLeftIndex := 0;
  if (numDays >= 2)
    then N1x2MenuOption.Enabled := True
    else N1x2MenuOption.Enabled := False;
  if (numDays >= 3)
    then N1x3MenuOption.Enabled := True
    else N1x3MenuOption.Enabled := False;
  if (numDays >= 4)
    then N2x2MenuOption.Enabled := True
    else N2x2MenuOption.Enabled := False;
  if (numDays >= 6)
    then N2x3MenuOption.Enabled := True
    else N2x3MenuOption.Enabled := False;
  if (numDays >= 9)
    then N3x3MenuOption.Enabled := True
    else N3x3MenuOption.Enabled := False;
  CreatePanels;
  ResizePanels;
  FillGraphs;
end;

procedure TfrmManualDWFDaySelection.HelpMenuOptionClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmManualDWFDaySelection.FormDblClick(Sender: TObject);
var
  i, j, dayIndex: integer;
begin
  for i := 0 to GraphsHorz - 1 do begin
    for j := 0 to GraphsVert - 1 do begin
      if (Graphs[i,j] = sender) then begin
        dayIndex := upperLeftIndex + (j * GraphsHorz) + i;
        //rm 2010-10-07
        //include[dayIndex] := not include[dayIndex];
        ToggleInclude(dayIndex);
      end;
    end;
  end;
end;

procedure TfrmManualDWFDaySelection.FillGraphs();
var
  i, j, k, dayIndex,numPoints: integer;
  flow: real;
  pAnnList: AnnotationX;
  pAnnLine,pAnnLine2: AnnArrow;
  queryStr: string;
  recSet: _RecordSet;
begin
  for i := 0 to GraphsHorz - 1 do begin
    for j := 0 to GraphsVert - 1 do begin
      dayIndex := upperLeftIndex + (j * GraphsHorz) + i;

      queryStr := 'SELECT DateTime, Flow FROM Flows WHERE ' +
                  '((MeterID = ' + inttostr(meterID) + ') AND ' +
                  '(DateTime BETWEEN ' + inttostr(days[dayIndex]) + ' AND ' +
                  '(' + inttostr(days[dayIndex]+ 1) + '))) ORDER BY DateTime;';
      recSet := CoRecordSet.Create;
      recSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      recSet.MoveFirst;

      with Graphs[i,j] do begin
        Title[2] := datetostr(days[dayIndex]);

        numPoints := dwf.size;
        Axis[AXIS_Y].ResetScale;
        OpenDataEx(COD_VALUES,2,numPoints+1);
        for k := 0 to numPoints - 1 do Series[0].YValue[k] := dwf.flows[k];
        Series[0].YValue[numPoints] := Series[0].YValue[0];
        k := 0;
        while (not recSet.EOF) do begin
          flow := recSet.Fields.Item[1].Value;
          Series[1].YValue[k] := flow;
          recSet.MoveNext;
          inc(k);
        end;
        CloseData(COD_VALUES);
      end;

      recSet.Close;
      pAnnList := Graphs[i,j].Anno;
      for k := 0 to pAnnList.count - 1 do begin
        pAnnList.Remove(k);
      end;
      if (not include[dayIndex]) then begin
        pAnnLine := AnnArrow(pAnnList.Add(OBJECT_TYPE_ARROW,0));
        pAnnLine.HeadStyle := 0;
        pAnnLine.AllowMove := False;
        pAnnLine.AllowModify := False;
        pAnnLine.Color := clRed;
        pAnnLine.BorderWidth := 10;
        pAnnLine.Width := Graphs[i,j].ClientWidth;
        pAnnLine.Height := Graphs[i,j].ClientHeight;

        pAnnLine2 := AnnArrow(pAnnList.Add(OBJECT_TYPE_ARROW,0));
        pAnnLine2.HeadStyle := 0;
        pAnnLine2.AllowMove := False;
        pAnnLine2.AllowModify := False;
        pAnnLine2.Color := clRed;
        pAnnLine2.BorderWidth := 10;
        pAnnLine2.Width := -(Graphs[i,j].ClientWidth);
        pAnnLine2.Height := Graphs[i,j].ClientHeight;
        pAnnLine2.Left := 0;
      end;
    end;
  end;
end;

procedure TfrmManualDWFDaySelection.ShowWeekdays();
var
  flowMeterName: string;
  index, timestep: integer;
begin
  flowMeterName := frmFlowMeterSelector.SelectedMeter;
  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
  meterID := DatabaseModule.GetMeterIDForName(flowMeterName);
  days := DatabaseModule.GetWeekdayDWFDays(meterID);
  numDays := length(days);
  if (numDays > 0) then begin
    caption := 'Manual Weekday DWF Day Removal for Flow Meter '+flowMeterName;
    timestep := DatabaseModule.GetFlowTimestep(meterID);
    timestepsPerHour := 60 div timestep;
    SetLength(include,numDays);
    for index := 0 to numDays - 1 do include[index] := true;
    weekdayOrWeekend := 0;
    dwf := DatabaseModule.GetWeekdayDWF(meterID);
    self.ShowModal;
  end
  else MessageDlg('There are no weekdays defining a weekday DWF hydrograph for flow meter '+flowMeterName+'.',mtInformation,[MbOK],0);
end;

procedure TfrmManualDWFDaySelection.ShowWeekends();
var
  flowMeterName: string;
  index, timestep: integer;
begin
  flowMeterName := frmFlowMeterSelector.SelectedMeter;
  flowUnitLabel := DatabaseModule.GetFlowUnitLabelForMeter(flowMeterName);
  meterID := DatabaseModule.GetMeterIDForName(flowMeterName);
  days := DatabaseModule.GetWeekendDWFDays(meterID);
  numDays := length(days);
  if (numDays > 0) then begin
    caption := 'Manual Weekend DWF Day Removal for Flow Meter '+flowMeterName;
    timestep := DatabaseModule.GetFlowTimestep(meterID);
    timestepsPerHour := 60 div timestep;
    SetLength(include,numDays);
    for index := 0 to numDays - 1 do include[index] := true;
    weekdayOrWeekend := 1;
    dwf := DatabaseModule.GetWeekendDWF(meterID);
    self.ShowModal;
  end
  else MessageDlg('There are no weekend days defining a weekend DWF hydrograph for flow meter '+flowMeterName+'.',mtInformation,[mbOK],0);
end;

procedure TfrmManualDWFDaySelection.Keep();
begin
  include[upperLeftIndex] := true;
  if (upperLeftIndex < numDays - 1) then inc(upperLeftIndex);
  FillGraphs;
end;

procedure TfrmManualDWFDaySelection.Discard();
begin
  include[upperLeftIndex] := false;
  if (upperLeftIndex < numDays - 1) then inc(upperLeftIndex);
  FillGraphs;
end;

procedure TfrmManualDWFDaySelection.Previous();
begin
  if (upperLeftIndex > 0) then begin
    upperLeftIndex := upperLeftIndex - (GraphsHorz * GraphsVert);
    if (upperLeftIndex < 0) then upperLeftIndex := 0;
    FillGraphs;
  end;
end;

procedure TfrmManualDWFDaySelection.Next();
var
  newUpperLeftIndex, newLowerRightIndex: integer;
begin
  newUpperLeftIndex := upperLeftIndex + (GraphsHorz * GraphsVert);
  newLowerRightIndex := newUpperLeftIndex + (GraphsHorz * GraphsVert) - 1;
  if (newlowerRightIndex >= numDays) then
    newUpperLeftIndex := numDays - (GraphsHorz * GraphsVert);
  if (newUpperLeftIndex <> upperLeftIndex) then begin
    upperLeftIndex := newUpperLeftIndex;
    FillGraphs;
  end;
end;

procedure TfrmManualDWFDaySelection.Beginning();
begin
  if (upperLeftIndex <> 0) then begin
    upperLeftIndex := 0;
    FillGraphs;
  end;
end;

procedure TfrmManualDWFDaySelection.ToEnd();
var
  newUpperLeftIndex: integer;
begin
  newUpperLeftIndex := numDays - (GraphsHorz * GraphsVert);
  if (newUpperLeftIndex <> upperLeftIndex) then begin
    upperLeftIndex := newUpperLeftIndex;
    FillGraphs;
  end;
end;

procedure TfrmManualDWFDaySelection.ToggleInclude(idx: integer);
var
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  include[idx] := not include[idx];
      sqlStr := 'UPDATE DryWeatherFlowDays ' +
                ' SET INCLUDE = ' + BoolToStr(include[idx]) +
                ' WHERE ' +
                ' (MeterID = ' + inttostr(meterID) + ') AND ' +
                ' (DWFDate = ' + floattostr(days[idx]) + ');';
      //frmMain.Caption := sqlStr;
      frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
end;

procedure TfrmManualDWFDaySelection.UpdateADWF1Click(Sender: TObject);
var
  index, removedDays: integer;
  sqlStr: string;
  recordsAffected: OleVariant;
begin
//update the ADWF shown in each graph
  removedDays := 0;

  for index := 0 to numDays - 1 do begin
    if (not include[index]) then begin
      //do not delete yet - just set include to false
      //so it will not factor in the recalculation
      sqlStr := 'UPDATE DryWeatherFlowDays ' +
                ' SET INCLUDE = FALSE ' +
                ' WHERE ' +
                ' (MeterID = ' + inttostr(meterID) + ') AND ' +
                ' (DWFDate = ' + floattostr(days[index]) + ');';
      //frmMain.Caption := sqlStr;
      frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
      inc(removedDays);
    end;
  end;

  if (removedDays > 0) then begin
    Screen.Cursor := crHourglass;
    if (weekdayOrWeekend = 0) then begin
      DatabaseModule.CalculateWeekdayDWF(meterID);
      dwf := DatabaseModule.GetWeekdayDWF(meterID);
    end else begin
      DatabaseModule.CalculateWeekendDWF(meterID);;
      dwf := DatabaseModule.GetWeekendDWF(meterID);
    end;
    FillGraphs;
    Screen.Cursor := crDefault;
  end;


end;

procedure TfrmManualDWFDaySelection.N1x1();
begin
  RemovePanels;
  GraphsHorz := 1;
  GraphsVert := 1;
  CreatePanels;
  ResizePanels;
  FillGraphs;
  KeepMenuOption.Enabled := True;
  DiscardMenuOption.Enabled := True;
end;

procedure TfrmManualDWFDaySelection.N1x2();
begin
  RemovePanels;
  GraphsHorz := 2;
  GraphsVert := 1;
  CreatePanels;
  ResizePanels;
  FillGraphs;
  KeepMenuOption.Enabled := False;
  DiscardMenuOption.Enabled := False;
end;

procedure TfrmManualDWFDaySelection.N1x3();
begin
  RemovePanels;
  GraphsHorz := 3;
  GraphsVert := 1;
  CreatePanels;
  ResizePanels;
  FillGraphs;
  KeepMenuOption.Enabled := False;
  DiscardMenuOption.Enabled := False;
end;

procedure TfrmManualDWFDaySelection.N2x2();
begin
  RemovePanels;
  GraphsHorz := 2;
  GraphsVert := 2;
  CreatePanels;
  ResizePanels;
  FillGraphs;
  KeepMenuOption.Enabled := False;
  DiscardMenuOption.Enabled := False;
end;

procedure TfrmManualDWFDaySelection.N2x3();
begin
  RemovePanels;
  GraphsHorz := 3;
  GraphsVert := 2;
  CreatePanels;
  ResizePanels;
  FillGraphs;
  KeepMenuOption.Enabled := False;
  DiscardMenuOption.Enabled := False;
end;

procedure TfrmManualDWFDaySelection.N3x3();
begin
  RemovePanels;
  GraphsHorz := 3;
  GraphsVert := 3;
  CreatePanels;
  ResizePanels;
  FillGraphs;
  KeepMenuOption.Enabled := False;
  DiscardMenuOption.Enabled := False;
end;

procedure TfrmManualDWFDaySelection.Stop();
begin
  Close;
end;

procedure TfrmManualDWFDaySelection.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  index, removedDays: integer;
  sqlStr: string;
  recordsAffected: OleVariant;
begin
  removedDays := 0;

  for index := 0 to numDays - 1 do begin
    if (not include[index]) then begin
      sqlStr := 'DELETE FROM DryWeatherFlowDays WHERE ' +
                '(MeterID = ' + inttostr(meterID) + ') AND ' +
                '(DWFDate = ' + floattostr(days[index]) + ');';
      //frmMain.Caption := sqlStr;                
      frmMain.Connection.Execute(sqlStr, recordsAffected, adCmdText);
      inc(removedDays);
    end;
  end;

  if (removedDays > 0) then begin
    Screen.Cursor := crHourglass;
    if (weekdayOrWeekend = 0)
      then DatabaseModule.CalculateWeekdayDWF(meterID)
      else DatabaseModule.CalculateWeekendDWF(meterID);
    Screen.Cursor := crDefault;
  end;

end;

procedure TfrmManualDWFDaySelection.FormKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (key = VK_NEXT) then Next();
  if (key = VK_PRIOR) then Previous();
  if (key = VK_HOME) then Beginning();
  if (key = VK_END) then ToEnd();
end;

procedure TfrmManualDWFDaySelection.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
//rm 2010-10-05 - This is getting run Three times upon one click of the mousewheel
//added check of var Handled to reduce this to One per mousewheeldown
  if not Handled then
    Next;
  Handled := true;
end;

procedure TfrmManualDWFDaySelection.FormMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
//rm 2010-10-05 - This is getting run Three times upon one click of the mousewheel
//added check of var Handled to reduce this to One per mousewheeldown
  if not Handled then
    Previous;
  Handled := true;
end;

end.
