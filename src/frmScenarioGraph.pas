unit frmScenarioGraph;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ChartfxLib_TLB, ADODB_TLB, Uutils, StdCtrls, Grids;

type
  TScenarioGraphForm = class(TForm)
    Label1: TLabel;
    ComboBoxScenarioA: TComboBox;
    Label2: TLabel;
    ComboBoxScenarioB: TComboBox;
    Label3: TLabel;
    ComboBoxType: TComboBox;
    Label4: TLabel;
    ComboBoxJunction: TComboBox;
    StringGrid1: TStringGrid;
    LabelSCAFlowUnits: TLabel;
    LabelSCADepthUnits: TLabel;
    LabelSCBFlowUnits: TLabel;
    LabelSCBDepthUnits: TLabel;
    CheckBoxScenarioAUnits: TCheckBox;
    LabelTSUnits: TLabel;
    procedure ComboBoxScenarioAChange(Sender: TObject);
    procedure ComboBoxScenarioBChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure ComboBoxJunctionChange(Sender: TObject);
    procedure CheckBoxScenarioAUnitsClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    ChartFX1: TChartFX;
    m_scAID, m_scBID: integer;
    m_junID, m_scAName, m_scBName: string;
    m_depthunitlabel : string;
    m_flowunitlabel : string;
    m_scAdepthunitlabel : string;
    m_scAflowunitlabel : string;
    m_scBdepthunitlabel : string;
    m_scBflowunitlabel : string;
    m_Avalues: array of real;
    m_Bvalues: array of real;
    m_XLabel: string;
    m_YLabel: string;
    procedure SelectDepthJunction(sName: string);
    procedure SelectFlowJunction(sName: string);
    procedure ClearStringGrid;
    procedure FillChart;
    procedure ClearChart;
    procedure SetColors;
  public
    { Public declarations }
    procedure SetJunction(sName: string);
    procedure SetScenarioID(sID:integer;sAB:string);
    procedure SetScenario(sName:string;sAB:string);
    procedure SetScenarioIDs(sAID:integer;sBID:integer);
    procedure SetScenarios(sAName: string; sBName: string);
    procedure SetType(sName:string);
    procedure Initialize();
  end;

var
  ScenarioGraphForm: TScenarioGraphForm;

implementation
uses modDatabase, mainform;

{$R *.dfm}

procedure TScenarioGraphForm.CheckBoxScenarioAUnitsClick(Sender: TObject);
begin
  if Length(ComboBoxJunction.Text) > 0 then begin
    SetJunction(ComboBoxJunction.Text);
  end;
end;

procedure TScenarioGraphForm.ClearChart;
begin
  ChartFX1.Visible := false;
end;

procedure TScenarioGraphForm.ClearStringGrid;
begin
  StringGrid1.RowCount := 2;
  StringGrid1.Rows[0].Clear;
  StringGrid1.Rows[1].Clear;
  ClearChart;
end;

procedure TScenarioGraphForm.ComboBoxJunctionChange(Sender: TObject);
begin
  SetJunction(ComboBoxJunction.Text);
end;

procedure TScenarioGraphForm.ComboBoxScenarioAChange(Sender: TObject);
begin
  SetScenario(ComboBoxScenarioA.Text, 'A');
  SetType(ComboBoxType.Text);
end;

procedure TScenarioGraphForm.ComboBoxScenarioBChange(Sender: TObject);
begin
  SetScenario(ComboBoxScenarioB.Text, 'B');
  SetType(ComboBoxType.Text);
end;

procedure TScenarioGraphForm.ComboBoxTypeChange(Sender: TObject);
begin
  SetType(ComboBoxType.Text);
end;

procedure TScenarioGraphForm.FillChart;
var i, inum, timestep, segmentsperday: integer;
  d: double;
  dt, dt1, dt2: TDateTime;
begin
  m_XLabel := 'Date / Time';
  inum := StringGrid1.RowCount - 2;
  dt1 := StrToDateTime(StringGrid1.Cells[1,1]);
  dt2 := StrToDateTime(StringGrid1.Cells[1,2]);
  d := (dt2 - dt1) * 24 * 60;
  timestep := Round(d);
  segmentsPerDay := 1440 div timeStep;
  dt2 := StrToDateTime(StringGrid1.Cells[1,inum]);
  with ChartFX1 do begin
    Axis[AXIS_Y].ResetScale;
    Axis[AXIS_X].ResetScale;
    Axis[AXIS_X].Title := m_XLabel;
    Axis[AXIS_Y].Title := m_YLabel;
    OpenDataEx(COD_VALUES,2,inum);
    OpenDataEx(COD_XVALUES,2,inum);
    for i := 0 to inum-1 do begin
      dt := StrToDateTime(StringGrid1.Cells[1,i+1]);

      Series[0].XValue[i] := dt1 + ((i+1) / segmentsperday);//dt;
      d := StrToFloat(StringGrid1.Cells[2,i+1]);
      Series[0].YValue[i] := d;

      Series[1].XValue[i] := dt1 + ((i+1) / segmentsperday);//dt;
      d := StrToFloat(StringGrid1.Cells[3,i+1]);
      Series[1].YValue[i] := d;
    end;
    CloseData(COD_VALUES);
      ChartFX1.Axis[AXIS_X].Min := dt1 * 288;
    CloseData(COD_XVALUES);
    with Axis[AXIS_X] do begin
      AutoScale := true;
      Format := 'XM/d/yy H:mm';
      Grid := True;
      ScaleUnit := segmentsPerDay;
      Min := dt1 * segmentsperDay;
      Max := dt2 * segmentsperDay;
    end;
  end;
  //SetColors;
  ChartFX1.Visible := (inum > 0);
  SetColors;
end;

procedure TScenarioGraphForm.FormCreate(Sender: TObject);
begin
  ChartFX1:=TChartFX.Create(Self);
  with ChartFX1 do begin
    Parent := Self;
    Left := StringGrid1.Left + StringGrid1.Width + 8;//chartLeft;
    Top := StringGrid1.Top; //chartTop;
    Width := ClientWidth - Left - 8;
    Height := ClientHeight - Top - 8;
    TabOrder := 8;
    //visible := true;
    Chart3D := false;
    visible := false;
  end;
end;

procedure TScenarioGraphForm.FormResize(Sender: TObject);
begin
  ChartFX1.Width := Self.ClientWidth - ChartFX1.Left - 8;
  ChartFX1.Height := Self.ClientHeight - ChartFX1.Top - 8;
end;

procedure TScenarioGraphForm.Initialize;
var
  scList:TStringList;
  i: integer;
begin
//load scenario names into ComboBoxScenarios;
  scList := DatabaseModule.GetScenarioNames;
  comboBoxScenarioA.Clear;
  comboBoxScenarioB.Clear;
  for i := 0 to scList.Count - 1 do begin
    ComboBoxScenarioA.Items.Add(scList.Strings[i]);
    ComboBoxScenarioB.Items.Add(scList.Strings[i]);
  end;
end;

procedure TScenarioGraphForm.SelectDepthJunction(sName: string);
var i,j: integer;
  theAList, theAVals, theBList, theBVals: TStringList;
begin
  ClearStringGrid;
  if (Length(Trim(sName)) > 0) then begin
    StringGrid1.Visible := False;
    try
      m_junID := sName;
      m_depthunitlabel := DatabaseModule.GetJuncDepthTSUnitLabel(m_scAID, m_junID, i);
      LabelTSUnits.Caption := 'Timeseries Units: ' + m_depthunitlabel;
      m_YLabel := 'Depth (' + m_depthunitlabel + ')';
      StringGrid1.Cells[1,0] := 'Date_Time';
      //rm 2009-07-16 - change headers
      StringGrid1.Cells[2,0] := 'Scenario A';
      StringGrid1.Cells[3,0] := 'Scenario B';
      //StringGrid1.Cells[2,0] := 'A Depth (' + m_depthunitlabel + ')';
      //StringGrid1.Cells[3,0] := 'B Depth (' + m_depthunitlabel + ')';
      theAList := DatabaseModule.GetJuncDepthTS(m_scAID,
        m_junID, (CheckBoxScenarioAUnits.Visible and CheckBoxScenarioAUnits.Checked));
      theBList := DatabaseModule.GetJuncDepthTS(m_scBID,
        m_junID, (CheckBoxScenarioAUnits.Visible and CheckBoxScenarioAUnits.Checked));
      for i := 0 to theAList.Count - 1 do begin
        StringGrid1.RowCount := i + 2;
        theAVals := TSTringList.Create;
        theAVals.CommaText := theAList.Strings[i];
        if (theAVals.Count > 3) then begin
          StringGrid1.Cells[1, i+1] := theAVals[0] +
            ' ' + theAVals[1] + ' ' + theAVals[2];
          StringGrid1.Cells[2, i+1] := theAVals[3];
        end else if (theAVals.Count > 2) then begin
          StringGrid1.Cells[1, i+1] := theAVals[0] + ' ' + theAVals[1];
          StringGrid1.Cells[2, i+1] := theAVals[2];
        end else if (theAVals.Count > 1) then begin
          StringGrid1.Cells[1, i+1] := theAVals[0];
          StringGrid1.Cells[2, i+1] := theAVals[1];
        end;
      end;
      for i := 0 to theBList.Count - 1 do begin
        StringGrid1.RowCount := i + 2;
        theBVals := TSTringList.Create;
        theBVals.CommaText := theBList.Strings[i];
        if (theBVals.Count > 3) then begin
          StringGrid1.Cells[3, i+1] := theBVals[3];
        end else if (theBVals.Count > 2) then begin
          StringGrid1.Cells[3, i+1] := theBVals[2];
        end else if (theBVals.Count > 1) then begin
          StringGrid1.Cells[3, i+1] := theBVals[1];
        end;
      end;
    finally
      StringGrid1.Visible := true;
    end;
  end;
  if StringGrid1.RowCount > 2 then FillChart;

end;

procedure TScenarioGraphForm.SelectFlowJunction(sName: string);
var i,j: integer;
  theAList, theAVals, theBList, theBVals: TStringList;
begin
  ClearStringGrid;
  if (Length(Trim(sName)) > 0) then begin
    StringGrid1.Visible := False;
    try
      m_junID := sName;
      m_flowunitlabel := DatabaseModule.GetJuncFlowTSUnitLabel(m_scAID, m_junID, i);
      LabelTSUnits.Caption := 'Timeseries Units: ' + m_flowunitlabel;
      m_YLabel := 'Flow (' + m_flowunitlabel + ')';
      StringGrid1.Cells[1,0] := 'Date_Time';
      //rm 2009-07-16 - change headers
      StringGrid1.Cells[2,0] := 'Scenario A';
      StringGrid1.Cells[3,0] := 'Scenario B';
      //StringGrid1.Cells[2,0] := 'A Flow (' + m_flowunitlabel + ')';
      //StringGrid1.Cells[3,0] := 'B Flow (' + m_flowunitlabel + ')';
      theAList := DatabaseModule.GetJuncFlowTS(m_scAID,
        m_junID, (CheckBoxScenarioAUnits.Visible and CheckBoxScenarioAUnits.Checked));
      theBList := DatabaseModule.GetJuncFlowTS(m_scBID,
        m_junID, (CheckBoxScenarioAUnits.Visible and CheckBoxScenarioAUnits.Checked));
      for i := 0 to theAList.Count - 1 do begin
        StringGrid1.RowCount := i + 2;
        theAVals := TSTringList.Create;
        theAVals.CommaText := theAList.Strings[i];
        theBVals := TSTringList.Create;
        theBVals.CommaText := theBList.Strings[i];
        if (theAVals.Count > 3) then begin
          StringGrid1.Cells[1, i+1] := theAVals[0] +
            ' ' + theAVals[1] + ' ' + theAVals[2];
          StringGrid1.Cells[2, i+1] := theAVals[3];
        end else if (theAVals.Count > 2) then begin
          StringGrid1.Cells[1, i+1] := theAVals[0] + ' ' + theAVals[1];
          StringGrid1.Cells[2, i+1] := theAVals[2];
        end else if (theAVals.Count > 1) then begin
          StringGrid1.Cells[1, i+1] := theAVals[0];
          StringGrid1.Cells[2, i+1] := theAVals[1];
        end;
        if (theBVals.Count > 3) then begin
          StringGrid1.Cells[3, i+1] := theBVals[3];
        end else if (theBVals.Count > 2) then begin
          StringGrid1.Cells[3, i+1] := theBVals[2];
        end else if (theBVals.Count > 1) then begin
          StringGrid1.Cells[3, i+1] := theBVals[1];
        end;
      end;
    finally
      StringGrid1.Visible := true;
    end;
  end;
  if StringGrid1.RowCount > 2 then FillChart;
end;

procedure TScenarioGraphForm.SetColors;
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
    OpenDataEx(COD_COLORS,2,2);
    Series[0].Color := frmMain.ChartRGBGree;//clLime;
    Series[1].Color := clRed;
    Series[0].Gallery := LINES;
    Series[0].MarkerShape := 0;
    Series[1].Gallery := LINES;
    Series[1].MarkerShape := 0;
    Series[0].LineWidth := frmMain.ChartLineWidth;
    Series[1].LineWidth := frmMain.ChartLineWidth;
    Series[0].YAxis := AXIS_Y;
    Series[1].YAxis := AXIS_Y;
    CloseData(COD_COLORS);

  end;
end;

procedure TScenarioGraphForm.SetJunction(sName: string);
begin
  m_junID := sName;
  ComboBoxJunction.Text := sName;
  if ComboBoxType.Text = 'Junction Depth' then begin
    SelectDepthJunction(sName);
    //CheckBoxScenarioUnits.Visible := (m_depthunitlabel <> m_scdepthunitlabel);
  end else begin
    SelectFlowJunction(sName);
    //CheckBoxScenarioUnits.Visible := (m_flowunitlabel <> m_scflowunitlabel);
  end;
end;

procedure TScenarioGraphForm.SetScenario(sName, sAB: string);
//var
//  i,j:integer;
//  queryStr : string;
//  recSet: _RecordSet;
begin
  ClearStringGrid;
  if (sAB = 'A') then begin
    m_scAName := sName;
    ComboBoxScenarioA.Text := sName;
    m_scAID := DatabaseModule.GetScenarioIDForName(sName);
    if (m_scAID > 0) then begin
      m_scAflowunitlabel := DatabaseModule.GetFlowUnitLabelForScenario(m_scAID);
      LabelSCAFlowUnits.Caption := 'Scenario A Flow Units: ' +
        m_scAflowunitlabel;
      m_scAdepthunitlabel := DatabaseModule.GetDepthUnitLabelForScenario(m_scAID);
      LabelSCADepthUnits.Caption := 'Scenario A Depth Units: ' +
        m_scAdepthunitlabel;
      SetType(ComboBoxType.Text);
    end;
  end else begin
    m_scBName := sName;
    ComboBoxScenarioB.Text := sName;
    m_scBID := DatabaseModule.GetScenarioIDForName(sName);
    if (m_scBID > 0) then begin
      m_scBflowunitlabel := DatabaseModule.GetFlowUnitLabelForScenario(m_scBID);
      LabelSCBFlowUnits.Caption := 'Scenario B Flow Units: ' +
        m_scBflowunitlabel;
      m_scBdepthunitlabel := DatabaseModule.GetDepthUnitLabelForScenario(m_scBID);
      LabelSCBDepthUnits.Caption := 'Scenario B Depth Units: ' +
        m_scBdepthunitlabel;
      SetType(ComboBoxType.Text);
    end;
  end;
end;

procedure TScenarioGraphForm.SetScenarioID(sID: integer;sAB: string);
begin
  if (sAB = 'A') then begin
    m_scAID := sID;
    m_scAName := DatabaseModule.GetScenarioNameForID(m_scAID);
    SetScenario(m_scAName, sAB);
  end else begin
    m_scBID := sID;
    m_scBName := DatabaseModule.GetScenarioNameForID(m_scBID);
    SetScenario(m_scBName, sAB);
  end;
end;

procedure TScenarioGraphForm.SetScenarioIDs(sAID, sBID: integer);
begin
  m_scAID := sAID;
  m_scAName := DatabaseModule.GetScenarioNameForID(m_scAID);
  m_scBID := sBID;
  m_scBName := DatabaseModule.GetScenarioNameForID(m_scBID);
  SetScenarios(m_scAName, m_scBName);
end;

procedure TScenarioGraphForm.SetScenarios(sAName, sBName: string);
//var
//  i,j:integer;
//  queryStr : string;
//  recSet: _RecordSet;
begin
  ClearStringGrid;
  m_scAName := sAName;
  ComboBoxScenarioA.Text := sAName;
  m_scAID := DatabaseModule.GetScenarioIDForName(sAName);
  if (m_scAID > 0) then begin
    m_scAflowunitlabel := DatabaseModule.GetFlowUnitLabelForScenario(m_scAID);
    LabelSCAFlowUnits.Caption := 'Scenario A Flow Units: ' +
      m_scAflowunitlabel;
    m_scAdepthunitlabel := DatabaseModule.GetDepthUnitLabelForScenario(m_scAID);
    LabelSCADepthUnits.Caption := 'Scenario A Depth Units: ' +
      m_scAdepthunitlabel;
  end;
  m_scBName := sBName;
  ComboBoxScenarioB.Text := sBName;
  m_scBID := DatabaseModule.GetScenarioIDForName(sBName);
  if (m_scBID > 0) then begin
    m_scBflowunitlabel := DatabaseModule.GetFlowUnitLabelForScenario(m_scBID);
    LabelSCBFlowUnits.Caption := 'Scenario B Flow Units: ' +
      m_scBflowunitlabel;
    m_scBdepthunitlabel := DatabaseModule.GetDepthUnitLabelForScenario(m_scBID);
    LabelSCBDepthUnits.Caption := 'Scenario B Depth Units: ' +
      m_scBdepthunitlabel;
  end;
  SetType(ComboBoxType.Text);
end;

procedure TScenarioGraphForm.SetType(sName: string);
begin
  if (Length(Trim(sName)) > 0) then begin
    ClearStringGrid;
    ComboBoxJunction.Clear;
    ComboBoxType.Text := sName;
    if (sName = 'Junction Depth') then begin
      ComboBoxJunction.Items :=
        DatabaseModule.GetJunctionsbyScenario(m_scAID, ' (JunctionDepthTS = TRUE) ');
    end else if (sName = 'SSO Flow') then begin
      ComboBoxJunction.Items :=
        DataBaseModule.GetOutfallJunctionsbyScenario(m_scAID, false, true);
    end else begin
      ComboBoxJunction.Items :=
        DataBaseModule.GetOutfallJunctionsbyScenario(m_scAID, true, true);
    end;
  end;
end;

procedure TScenarioGraphForm.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if ARow > 0 then begin
    if (ACol = 0) then begin
      StringGrid1.Canvas.Brush.Color := clBtnFace;
    end else if (ACol = 2) then begin
      StringGrid1.Canvas.Brush.Color := frmMain.ChartRGBGree;
    end else if (ACol = 3) then begin
      StringGrid1.Canvas.Brush.Color := clRed;
    end else begin
      StringGrid1.Canvas.Brush.Color := clWhite;
    end;
  end else begin
    StringGrid1.Canvas.Brush.Color := clBtnFace;
  end;
  StringGrid1.Canvas.FillRect(Rect);
  StringGrid1.Canvas.TextOut(Rect.Left+2, Rect.Top+2, StringGrid1.Cells[ACol,ARow])
end;

end.
