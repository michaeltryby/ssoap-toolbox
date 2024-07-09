unit frmTSGraph;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ChartfxLib_TLB, ADODB_TLB, Uutils;

type
  TTSGraphForm = class(TForm)
    ComboBoxScenario: TComboBox;
    ComboBoxType: TComboBox;
    ComboBoxJunction: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StringGrid1: TStringGrid;
    LabelSCFlowUnits: TLabel;
    LabelSCDepthUnits: TLabel;
    LabelTSUnits: TLabel;
    CheckBoxScenarioUnits: TCheckBox;
    procedure ComboBoxScenarioChange(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure ComboBoxJunctionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CheckBoxScenarioUnitsClick(Sender: TObject);
  private
    { Private declarations }
    ChartFX1: TChartFX;
    m_scID: integer;
    m_junID, m_scName: string;
    m_depthunitlabel : string;
    m_flowunitlabel : string;
    m_scdepthunitlabel : string;
    m_scflowunitlabel : string;
    values: array of real;

    procedure SelectDepthJunction(sName: string);
    procedure SelectFlowJunction(sName: string);
    procedure ClearStringGrid;
    procedure FillChart;
    procedure ClearChart;
  public
    { Public declarations }
    procedure SetJunction(sName: string);
    procedure SetScenarioID(sID:integer);
    procedure SetScenario(sName:string);
    procedure SetType(sName:string);
    procedure Initialize();
  end;

var
  TSGraphForm: TTSGraphForm;

implementation
uses modDatabase, mainform;

{$R *.dfm}

procedure TTSGraphForm.CheckBoxScenarioUnitsClick(Sender: TObject);
begin
  if Length(ComboBoxJunction.Text) > 0 then begin
    SetJunction(ComboBoxJunction.Text);
  end;
end;

procedure TTSGraphForm.ClearChart;
begin
  ChartFX1.Visible := false;
end;

procedure TTSGraphForm.ClearStringGrid;
begin
  StringGrid1.RowCount := 2;
  StringGrid1.Rows[0].Clear;
  StringGrid1.Rows[1].Clear;
end;

procedure TTSGraphForm.ComboBoxJunctionChange(Sender: TObject);
begin
  SetJunction(ComboBoxJunction.Text);
end;

procedure TTSGraphForm.ComboBoxScenarioChange(Sender: TObject);
begin
  SetScenario(ComboBoxScenario.Text);
  SetType(ComboBoxType.Text);
end;

procedure TTSGraphForm.ComboBoxTypeChange(Sender: TObject);
begin
  SetType(ComboBoxType.Text);
end;

procedure TTSGraphForm.FillChart;
var i, inum, timestep, segmentsperday: integer;
  d: double;
  dt, dt1, dt2: TDateTime;
begin
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
    OpenDataEx(COD_VALUES,1,inum);
    OpenDataEx(COD_XVALUES,1,inum);
    for i := 1 to inum do begin
      dt := StrToDateTime(StringGrid1.Cells[1,i]);
      Series[0].XValue[i] := dt1 + (i / segmentsperday);//dt;
      d := StrToFloat(StringGrid1.Cells[2,i]);
      Series[0].YValue[i] := d;
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

end;

procedure TTSGraphForm.FormCreate(Sender: TObject);
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

procedure TTSGraphForm.FormResize(Sender: TObject);
begin
  ChartFX1.Width := Self.ClientWidth - ChartFX1.Left - 8;
  ChartFX1.Height := Self.ClientHeight - ChartFX1.Top - 8;
end;

procedure TTSGraphForm.Initialize;
var
  scList:TStringList;
  i: integer;
begin
//load scenario names into ComboBoxScenarios;
  scList := DatabaseModule.GetScenarioNames;
  comboBoxScenario.Clear;
  for i := 0 to scList.Count - 1 do
    ComboBoxScenario.Items.Add(scList.Strings[i]);
end;

procedure TTSGraphForm.SelectDepthJunction(sName: string);
var i,j: integer;
  theList, theVals: TStringList;
begin
  ClearStringGrid;
  if (Length(Trim(sName)) > 0) then begin
    StringGrid1.Visible := False;
    try
      m_junID := sName;
      m_depthunitlabel := DatabaseModule.GetJuncDepthTSUnitLabel(m_scID, m_junID, i);
      LabelTSUnits.Caption := 'Timeseries Units: ' + m_depthunitlabel;
      StringGrid1.Cells[1,0] := 'Date_Time';
      StringGrid1.Cells[2,0] := 'Depth (' + m_depthunitlabel + ')';
      theList := DatabaseModule.GetJuncDepthTS(m_scID,
        m_junID, (CheckBoxScenarioUnits.Visible and CheckBoxScenarioUnits.Checked));
      for i := 0 to theList.Count - 1 do begin
        StringGrid1.RowCount := i + 2;
        theVals := TSTringList.Create;
        theVals.CommaText := theList.Strings[i];
        if (theVals.Count > 3) then begin
          StringGrid1.Cells[1, i+1] := theVals[0] +
            ' ' + theVals[1] + ' ' + theVals[2];
          StringGrid1.Cells[2, i+1] := theVals[3];
        end else if (theVals.Count > 2) then begin
          StringGrid1.Cells[1, i+1] := theVals[0] + ' ' + theVals[1];
          StringGrid1.Cells[2, i+1] := theVals[2];
        end else if (theVals.Count > 1) then begin
          StringGrid1.Cells[1, i+1] := theVals[0];
          StringGrid1.Cells[2, i+1] := theVals[1];
        end;
      end;
    finally
      StringGrid1.Visible := true;
    end;
  end;
  if StringGrid1.RowCount > 2 then FillChart;

end;

procedure TTSGraphForm.SelectFlowJunction(sName: string);
var i,j: integer;
  theList, theVals: TStringList;
begin
  ClearStringGrid;
  if (Length(Trim(sName)) > 0) then begin
    StringGrid1.Visible := False;
    try
      m_junID := sName;
      m_flowunitlabel := DatabaseModule.GetJuncFlowTSUnitLabel(m_scID, m_junID, i);
      LabelTSUnits.Caption := 'Timeseries Units: ' + m_flowunitlabel;
      StringGrid1.Cells[1,0] := 'Date_Time';
      StringGrid1.Cells[2,0] := 'Flow (' + m_flowunitlabel + ')';
      theList := DatabaseModule.GetJuncFlowTS(m_scID,
      m_junID, (CheckBoxScenarioUnits.Visible and CheckBoxScenarioUnits.Checked));
      for i := 0 to theList.Count - 1 do begin
        StringGrid1.RowCount := i + 2;
        theVals := TSTringList.Create;
        theVals.CommaText := theList.Strings[i];
        if (theVals.Count > 3) then begin
          StringGrid1.Cells[1, i+1] := theVals[0] +
            ' ' + theVals[1] + ' ' + theVals[2];
          StringGrid1.Cells[2, i+1] := theVals[3];
        end else if (theVals.Count > 2) then begin
          StringGrid1.Cells[1, i+1] := theVals[0] + ' ' + theVals[1];
          StringGrid1.Cells[2, i+1] := theVals[2];
        end else if (theVals.Count > 1) then begin
          StringGrid1.Cells[1, i+1] := theVals[0];
          StringGrid1.Cells[2, i+1] := theVals[1];
        end;
      end;
    finally
      StringGrid1.Visible := true;
    end;
  end;
  if StringGrid1.RowCount > 2 then FillChart;
end;

procedure TTSGraphForm.SetJunction(sName: string);
begin
  m_junID := sName;
  ComboBoxJunction.Text := sName;
  if ComboBoxType.Text = 'Junction Depth' then begin
    SelectDepthJunction(sName);
    CheckBoxScenarioUnits.Visible := (m_depthunitlabel <> m_scdepthunitlabel);
  end else begin
    SelectFlowJunction(sName);
    CheckBoxScenarioUnits.Visible := (m_flowunitlabel <> m_scflowunitlabel);
  end;
end;

procedure TTSGraphForm.SetScenario(sName: string);
var
  i,j:integer;
  queryStr : string;
  recSet: _RecordSet;
begin
  ClearStringGrid;
  m_scName := sName;
  ComboBoxScenario.Text := sName;
  m_scID := DatabaseModule.GetScenarioIDForName(sName);
  if (m_scID > 0) then begin
    m_scflowunitlabel := DatabaseModule.GetFlowUnitLabelForScenario(m_scID);
    LabelSCFlowUnits.Caption := 'Scenario Flow Units: ' +
      m_scflowunitlabel;
    m_scdepthunitlabel := DatabaseModule.GetDepthUnitLabelForScenario(m_scID); 
    LabelSCDepthUnits.Caption := 'Scenario Depth Units: ' +
      m_scdepthunitlabel;
    SetType(ComboBoxType.Text);
  end;
end;

procedure TTSGraphForm.SetScenarioID(sID: integer);
begin
  m_scID := sID;
  m_scName := DatabaseModule.GetScenarioNameForID(m_scID);
  SetScenario(m_scName);
end;

procedure TTSGraphForm.SetType(sName: string);
begin
  if (Length(Trim(sName)) > 0) then begin
    ClearStringGrid;
    ComboBoxJunction.Clear;
    ComboBoxType.Text := sName;
    if (sName = 'Junction Depth') then begin
      ComboBoxJunction.Items :=
        DatabaseModule.GetJunctionsbyScenario(m_scID, ' (JunctionDepthTS = TRUE) ');
    end else if (sName = 'SSO Flow') then begin
      ComboBoxJunction.Items :=
        DataBaseModule.GetOutfallJunctionsbyScenario(m_scID, false, true);
    end else begin
      ComboBoxJunction.Items :=
        DataBaseModule.GetOutfallJunctionsbyScenario(m_scID, true, true);
    end;
  end;
end;

end.
