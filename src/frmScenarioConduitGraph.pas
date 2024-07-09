unit frmScenarioConduitGraph;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ChartfxLib_TLB, ADODB_TLB, Uutils, Math;

type
  TScenarioConduitGraphForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelID: TLabel;
    ComboBoxScenarioA: TComboBox;
    ComboBoxScenarioB: TComboBox;
    ComboBoxType: TComboBox;
    ComboBoxConduit: TComboBox;
    LabelSCAFlowUnits: TLabel;
    LabelSCADepthUnits: TLabel;
    LabelSCBFlowUnits: TLabel;
    LabelSCBDepthUnits: TLabel;
    CheckBoxScenarioAUnits: TCheckBox;
    LabelTSUnits: TLabel;
    StringGrid1: TStringGrid;
    procedure ComboBoxScenarioAChange(Sender: TObject);
    procedure ComboBoxScenarioBChange(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure ComboBoxConduitChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    ChartFX1: TChartFX;
    m_scAID, m_scBID: integer;
    m_conID, m_scAName, m_scBName: string;
    m_depthunitlabel : string;
    m_flowunitlabel : string;
    m_volunitlabel : string;
    m_scAdepthunitlabel : string;
    m_scAflowunitlabel : string;
    m_scBdepthunitlabel : string;
    m_scBflowunitlabel : string;
    m_Avalues: array of real;
    m_Bvalues: array of real;
    m_XLabel: string;
    m_YLabel: string;
    procedure SelectMaxCapConduit(sName: string);
    procedure SelectMaxDepthJunction(sName: string);
    procedure SelectOutfallVolumeJunction(sName: string);
    procedure SelectFloodingJunction(sName: string);
    //procedure SelectFlowJunction(sName: string);
    procedure ClearStringGrid;
    procedure FillChart;
    procedure ClearChart;
    procedure SetColors;
  public
    { Public declarations }
    procedure SetConduit(sName: string);
    procedure SetScenarioID(sID:integer;sAB:string);
    procedure SetScenario(sName:string;sAB:string);
    procedure SetScenarioIDs(sAID:integer;sBID:integer);
    procedure SetScenarios(sAName: string; sBName: string);
    procedure SetType(sName:string);
    procedure Initialize();
  end;

var
  ScenarioConduitGraphForm: TScenarioConduitGraphForm;

implementation
uses modDatabase, mainform;

{$R *.dfm}

{ TScenarioConduitGraphForm }

procedure TScenarioConduitGraphForm.ClearChart;
begin
  ChartFX1.Visible := false;
end;

procedure TScenarioConduitGraphForm.ClearStringGrid;
begin
  StringGrid1.RowCount := 2;
  StringGrid1.Rows[0].Clear;
  StringGrid1.Rows[1].Clear;
  ClearChart;
end;

procedure TScenarioConduitGraphForm.ComboBoxConduitChange(Sender: TObject);
begin
  SetConduit(ComboBoxConduit.Text);
end;

procedure TScenarioConduitGraphForm.ComboBoxScenarioAChange(Sender: TObject);
begin
  SetScenario(ComboBoxScenarioA.Text, 'A');
  SetType(ComboBoxType.Text);
end;

procedure TScenarioConduitGraphForm.ComboBoxScenarioBChange(Sender: TObject);
begin
  SetScenario(ComboBoxScenarioB.Text, 'B');
  SetType(ComboBoxType.Text);
end;

procedure TScenarioConduitGraphForm.ComboBoxTypeChange(Sender: TObject);
begin
  SetType(ComboBoxType.Text);
end;

procedure TScenarioConduitGraphForm.FillChart;
var i, inum: integer;
  dA, dB: double;
begin
  inum := 1;
  m_XLabel := 'Scenario';
  with ChartFX1 do begin
    //Axis[AXIS_Y].ResetScale;
    //Axis[AXIS_X].ResetScale;
    OpenDataEx(COD_VALUES,2,inum);
    OpenDataEx(COD_XVALUES,2,inum);
    for i := 0 to inum-1 do begin

      Series[0].XValue[i] := 1;//dt;
      dA := StrToFloat(StringGrid1.Cells[1,i+1]);
      Series[0].YValue[i] := dA;

      Series[1].XValue[i] := 1;
      dB := StrToFloat(StringGrid1.Cells[2,i+1]);
      Series[1].YValue[i] := dB;
    end;
    CloseData(COD_VALUES);
    CloseData(COD_XVALUES);
    with Axis[AXIS_X] do begin
      AutoScale := false;
      Format := '';
      Grid := True;
      ScaleUnit := 1;
      Min := 2.0;
      Max := 2.0;
      Axis[AXIS_X].Title := m_XLabel;
    end;
    with Axis[AXIS_Y] do begin
      Format := '';
      Grid := True;
      ScaleUnit := 1;
      Axis[AXIS_Y].Title := m_YLabel;
      if (ComboBoxType.Text = 'Conduit Max Capacity') then begin
        AutoScale := false;
        Min := 0.0;
        Max := 1.0;
      end else begin
        AutoScale := false;
        Min := 0.0;
        if (dA > dB) then begin
          Max := Math.Ceil(dA);
        end else begin
          if (dB > 0.00) then begin
            Max := Math.Ceil(dB);
          end else begin
            Max := 1.0;
          end;
        end;
        //Min := 0.0;
        //Max := 1.0;
      end;
    end;
  end;
  //SetColors;
  ChartFX1.Visible := (inum > 0);
  SetColors;
end;

procedure TScenarioConduitGraphForm.FormCreate(Sender: TObject);
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

procedure TScenarioConduitGraphForm.FormResize(Sender: TObject);
begin
  ChartFX1.Width := Self.ClientWidth - ChartFX1.Left - 8;
  ChartFX1.Height := Self.ClientHeight - ChartFX1.Top - 8;
end;

procedure TScenarioConduitGraphForm.Initialize;
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

procedure TScenarioConduitGraphForm.SelectFloodingJunction(sName: string);
var i, iUnitsA, iUnitsB: integer;
  dCapA, dCapB: double;
  sCapA, sCapB, sUnits: string;
begin
  ClearStringGrid;
  if (Length(Trim(sName)) > 0) then begin
    StringGrid1.Visible := False;
    try
      m_conID := sName;
      //m_flowunitlabel := DatabaseModule.GetCondMaxCapUnitLabel(m_scAID,
      //  m_conID, i);
      //LabelTSUnits.Caption := 'Volume Units: ' + m_flowunitlabel;
      //rm 2009-07-16 - change headers
      //rm 2009-07-16 - change headers
      StringGrid1.Cells[1,0] := 'Scenario A';
      StringGrid1.Cells[2,0] := 'Scenario B';
      //StringGrid1.Cells[1,0] := 'A Flooding Vol';// (' + m_flowunitlabel + ')';
      //StringGrid1.Cells[2,0] := 'B Flooding Vol';// (' + m_flowunitlabel + ')';
      dCapA := DatabaseModule.GetJuncFlooding(m_scAID, m_conID, iUnitsA);
      dCapB := DatabaseModule.GetJuncFlooding(m_scBID, m_conID, iUnitsB);
      sCapA := formatfloat('0.0000', dCapA);
      sCapB := formatfloat('0.0000', dCapB);
      StringGrid1.Cells[1, 1] := sCapA;
      StringGrid1.Cells[2, 1] := sCapB;
      m_flowunitlabel := DatabaseModule.GetFlowUnitLabelForID(iUnitsA);
      m_volunitlabel := DatabaseModule.GetVolUnitLabel4FlowUnitLabel(m_flowunitlabel);
      m_YLabel := 'Volume (' + m_volunitlabel + ')';
      LabelTSUnits.Caption := 'Volume Units: ' + m_volunitlabel;
    finally
      StringGrid1.Visible := true;
    end;
  end;
  if StringGrid1.RowCount > 1 then FillChart;

end;

procedure TScenarioConduitGraphForm.SelectMaxCapConduit(sName: string);
var i: integer;
  dCapA, dCapB: double;
  sCapA, sCapB: string;
begin
  ClearStringGrid;
  if (Length(Trim(sName)) > 0) then begin
    StringGrid1.Visible := False;
    try
      m_conID := sName;
      m_flowunitlabel := DatabaseModule.GetCondMaxCapUnitLabel(m_scAID,
        m_conID, i);
      //rm 2009-07-16 - change units to ratio
      //LabelTSUnits.Caption := 'Flow Units: ' + m_flowunitlabel;
      LabelTSUnits.Caption := 'Ratio';
      //rm 2009-07-16 - change headers
      StringGrid1.Cells[1,0] := 'Scenario A';
      StringGrid1.Cells[2,0] := 'Scenario B';
      //StringGrid1.Cells[1,0] := 'A Max Cap Ratio';// (' + m_flowunitlabel + ')';
      //StringGrid1.Cells[2,0] := 'B Max Cap Ratio';// (' + m_flowunitlabel + ')';
      dCapA := DatabaseModule.GetCondMaxCap(m_scAID, m_conID);
      dCapB := DatabaseModule.GetCondMaxCap(m_scBID, m_conID);
      sCapA := formatfloat('0.0000', dCapA);
      sCapB := formatfloat('0.0000', dCapB);
      StringGrid1.Cells[1, 1] := sCapA;
      StringGrid1.Cells[2, 1] := sCapB;
      m_YLabel := 'Ratio';

    finally
      StringGrid1.Visible := true;
    end;
  end;
  if StringGrid1.RowCount > 1 then FillChart;

end;

procedure TScenarioConduitGraphForm.SelectMaxDepthJunction(sName: string);
var i: integer;
  dCapA, dCapB: double;
  sCapA, sCapB: string;
begin
  ClearStringGrid;
  if (Length(Trim(sName)) > 0) then begin
    StringGrid1.Visible := False;
    try
      m_conID := sName;
      m_depthunitlabel := DatabaseModule.GetJuncMaxDepthUnitLabel(m_scAID,
        m_conID, i);
      LabelTSUnits.Caption := 'Depth Units: ' + m_depthunitlabel;
      //rm 2009-07-16 - change headers
      StringGrid1.Cells[1,0] := 'Scenario A';
      StringGrid1.Cells[2,0] := 'Scenario B';
      //StringGrid1.Cells[1,0] := 'A Max Depth (' + m_depthunitlabel + ')';
      //StringGrid1.Cells[2,0] := 'B Max Depth (' + m_depthunitlabel + ')';
      dCapA := DatabaseModule.GetJuncMaxDepth(m_scAID, m_conID);
      dCapB := DatabaseModule.GetJuncMaxDepth(m_scBID, m_conID);
      sCapA := formatfloat('0.0000', dCapA);
      sCapB := formatfloat('0.0000', dCapB);
      StringGrid1.Cells[1, 1] := sCapA;
      StringGrid1.Cells[2, 1] := sCapB;
      m_YLabel := 'Depth (' + m_depthunitlabel + ')';
    finally
      StringGrid1.Visible := true;
    end;
  end;
  if StringGrid1.RowCount > 1 then FillChart;
end;

procedure TScenarioConduitGraphForm.SelectOutfallVolumeJunction(sName: string);
var i: integer;
  dCapA, dCapB: double;
  sCapA, sCapB: string;
begin
  ClearStringGrid;
  if (Length(Trim(sName)) > 0) then begin
    StringGrid1.Visible := False;
    try
      m_conID := sName;
      m_flowunitlabel := DatabaseModule.GetOutfallVolumeUnitLabel(m_scAID,
        m_conID, i);
      m_volunitlabel := DatabaseModule.GetVolUnitLabel4FlowUnitLabel(m_flowunitlabel);
      LabelTSUnits.Caption := 'Volume Units: ' + m_volunitlabel;
      //rm 2009-07-16 - change headers
      StringGrid1.Cells[1,0] := 'Scenario A';
      StringGrid1.Cells[2,0] := 'Scenario B';
      //StringGrid1.Cells[1,0] := 'A Volume ';// + m_depthunitlabel + ')';
      //StringGrid1.Cells[2,0] := 'B Volume ';// + m_depthunitlabel + ')';
      dCapA := DatabaseModule.GetOutfallVolume(m_scAID, m_conID);
      dCapB := DatabaseModule.GetOutfallVolume(m_scBID, m_conID);
      sCapA := formatfloat('0.0000', dCapA);
      sCapB := formatfloat('0.0000', dCapB);
      StringGrid1.Cells[1, 1] := sCapA;
      StringGrid1.Cells[2, 1] := sCapB;
      m_YLabel := 'Volume (' + m_volunitlabel + ')';
    finally
      StringGrid1.Visible := true;
    end;
  end;
  if StringGrid1.RowCount > 1 then FillChart;
end;

procedure TScenarioConduitGraphForm.SetColors;
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
    Series[0].Gallery := BAR;
    Series[1].Gallery := BAR;
    //Series[0].LineWidth := frmMain.ChartLineWidth;
    //Series[1].LineWidth := frmMain.ChartLineWidth;
    Series[0].YAxis := AXIS_Y;
    Series[1].YAxis := AXIS_Y;
    CloseData(COD_COLORS);

  end;
end;

procedure TScenarioConduitGraphForm.SetConduit(sName: string);
begin
  m_conID := sName;
  ComboBoxConduit.Text := sName;
  if ComboBoxType.Text = 'Conduit Max Capacity' then begin
    SelectMaxCapConduit(sName);
    //CheckBoxScenarioUnits.Visible := (m_depthunitlabel <> m_scdepthunitlabel);
  //end else begin
  //  SelectFlowJunction(sName);
  //  //CheckBoxScenarioUnits.Visible := (m_flowunitlabel <> m_scflowunitlabel);
  end else if (ComboBoxType.Text = 'Junction Max Depth') then begin
    SelectMaxDepthJunction(sName);
  end else if (ComboBoxType.Text = 'Outfall Volume') then begin
    SelectOutfallVolumeJunction(sName);
  end else if (ComboBoxType.Text = 'SSO Volume') then begin
    SelectOutfallVolumeJunction(sName);
  end else if (ComboBoxType.Text = 'Junction Flooding') then begin
    SelectFloodingJunction(sName);
  end;
end;

procedure TScenarioConduitGraphForm.SetScenario(sName, sAB: string);
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

procedure TScenarioConduitGraphForm.SetScenarioID(sID: integer; sAB: string);
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

procedure TScenarioConduitGraphForm.SetScenarioIDs(sAID, sBID: integer);
begin
  m_scAID := sAID;
  m_scAName := DatabaseModule.GetScenarioNameForID(m_scAID);
  m_scBID := sBID;
  m_scBName := DatabaseModule.GetScenarioNameForID(m_scBID);
  SetScenarios(m_scAName, m_scBName);
end;

procedure TScenarioConduitGraphForm.SetScenarios(sAName, sBName: string);
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

procedure TScenarioConduitGraphForm.SetType(sName: string);
begin
  if (Length(Trim(sName)) > 0) then begin
    ClearStringGrid;
    ComboBoxConduit.Clear;
    ComboBoxType.Text := sName;
    if (sName = 'Conduit Max Capacity') then begin
      labelID.Caption := 'Conduit:';
      ComboBoxConduit.Items :=
        DatabaseModule.GetConduitsbyScenario(m_scAID, '');
      //rm 2009-07-16 - change headers
      LabelTSUnits.Caption := 'Ratio';
      StringGrid1.Cells[1,0] := 'Scenario A';
      StringGrid1.Cells[2,0] := 'Scenario B';
      //StringGrid1.Cells[1,0] := 'A Max Cap Ratio';// (' + m_flowunitlabel + ')';
      //StringGrid1.Cells[2,0] := 'B Max Cap Ratio';// (' + m_flowunitlabel + ')';
    end else if (sName = 'Junction Max Depth') then begin
      labelID.Caption := 'Junction:';
      ComboBoxConduit.Items :=
        DataBaseModule.GetJunctionsbyScenario(m_scAID, '');
      //rm 2009-07-16 - change headers
      LabelTSUnits.Caption := 'Depth Units:';
      StringGrid1.Cells[1,0] := 'Scenario A';
      StringGrid1.Cells[2,0] := 'Scenario B';
      //StringGrid1.Cells[1,0] := 'A Max Depth (' + m_depthunitlabel + ')';
      //StringGrid1.Cells[2,0] := 'B Max Depth (' + m_depthunitlabel + ')';
    end else if (sName = 'Outfall Volume') then begin
      labelID.Caption := 'Outfall:';
      ComboBoxConduit.Items :=
        DataBaseModule.GetOutfallJunctionsbyScenario(m_scAID, true, false);
      //rm 2009-07-16 - change headers
      LabelTSUnits.Caption := 'Volume Units:';
      StringGrid1.Cells[1,0] := 'Scenario A';
      StringGrid1.Cells[2,0] := 'Scenario B';
      //StringGrid1.Cells[1,0] := 'A Volume ';// + m_depthunitlabel + ')';
      //StringGrid1.Cells[2,0] := 'B Volume ';// + m_depthunitlabel + ')';
    end else if (sName = 'SSO Volume') then begin
      labelID.Caption := 'SSO:';
      ComboBoxConduit.Items :=
        DataBaseModule.GetOutfallJunctionsbyScenario(m_scAID, false, true);
      //rm 2009-07-16 - change headers
      LabelTSUnits.Caption := 'Volume Units:';
      StringGrid1.Cells[1,0] := 'Scenario A';
      StringGrid1.Cells[2,0] := 'Scenario B';
      //StringGrid1.Cells[1,0] := 'A Volume ';// + m_depthunitlabel + ')';
      //StringGrid1.Cells[2,0] := 'B Volume ';// + m_depthunitlabel + ')';
    end else if (sName = 'Junction Flooding') then begin
      labelID.Caption := 'Junction:';
      ComboBoxConduit.Items :=
        DataBaseModule.GetFloodingJunctionsbyScenario(m_scAID, '');
      //rm 2009-07-16 - change headers
      LabelTSUnits.Caption := 'Volume Units:';
      StringGrid1.Cells[1,0] := 'Scenario A';
      StringGrid1.Cells[2,0] := 'Scenario B';
      //StringGrid1.Cells[1,0] := 'A Volume ';// + m_depthunitlabel + ')';
      //StringGrid1.Cells[2,0] := 'B Volume ';// + m_depthunitlabel + ')';
    end;
  end;
end;

procedure TScenarioConduitGraphForm.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if ARow > 0 then begin
    if (ACol = 0) then begin
      StringGrid1.Canvas.Brush.Color := clBtnFace;
    end else if (ACol = 1) then begin
      StringGrid1.Canvas.Brush.Color := frmMain.ChartRGBGree;
    end else if (ACol = 2) then begin
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
