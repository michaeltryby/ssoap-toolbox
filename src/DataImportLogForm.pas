unit DataImportLogForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Tabs, ExtCtrls, ADODB_TLB, feedbackwithmemo;

type
  TfrmDataImportLog = class(TForm)
    Panel1: TPanel;
    TabSet1: TTabSet;
    StringGrid1: TStringGrid;
    procedure TabSet1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    const
    SQLRAINFALL = 'SELECT d.RainGaugeID, d.RainGaugeName, ' +
       ' c.RainConverterID, c.RainConverterName, ' +
       ' b.ImportTypeName, a.Filename, a.ImportDate, ' +
       ' a.FileDateStamp, a.ImportDetails ' +
       ' FROM ((ImportLog AS a INNER JOIN ImportTypes AS b ' +
       ' ON a.ImportTypeID = b.ImportTypeID) INNER JOIN RainConverters AS c ' +
       ' ON a.ConverterID = c.RainConverterID) INNER JOIN Raingauges as d ' +
       ' ON a.ForeignID = d.RainGaugeID ' +
       ' WHERE b.Tablename = "RainConverters" ORDER BY a.ImportDate ';
    SQLFLOWS = 'SELECT d.MeterID, d.MeterName, ' +
       ' c.FlowConverterID, c.FlowConverterName, ' +
       ' b.ImportTypeName, a.Filename, a.ImportDate, ' +
       ' a.FileDateStamp, a.ImportDetails ' +
       ' FROM ((ImportLog AS a INNER JOIN ImportTypes AS b ' +
       ' ON a.ImportTypeID = b.ImportTypeID) INNER JOIN FlowConverters AS c ' +
       ' ON a.ConverterID = c.FlowConverterID) INNER JOIN Meters as d ' +
       ' ON a.ForeignID = d.MeterID ' +
       ' WHERE b.Tablename = "FlowConverters" ORDER BY a.ImportDate ';
    SQLSEWERSHEDS = 'SELECT d.SewershedID, d.SewershedName, ' +
       ' c.SewershedConverterID, c.SewershedConverterName, ' +
       ' b.ImportTypeName, a.Filename, a.ImportDate, ' +
       ' a.FileDateStamp, a.ImportDetails ' +
       ' FROM ((ImportLog AS a INNER JOIN ImportTypes AS b ' +
       ' ON a.ImportTypeID = b.ImportTypeID) INNER JOIN SewershedConverters AS c ' +
       ' ON a.ConverterID = c.SewershedConverterID) INNER JOIN Sewersheds as d ' +
       ' ON a.ForeignID = d.SewershedID ' +
       ' WHERE b.Tablename = "SewershedConverters" ORDER BY a.ImportDate ';
    SQLRDIIAREAS = 'SELECT d.RDIIAreaID, d.RDIIAreaName, ' +
       ' c.RDIIAreaConverterID, c.RDIIAreaConverterName, ' +
       ' b.ImportTypeName, a.Filename, a.ImportDate, ' +
       ' a.FileDateStamp, a.ImportDetails ' +
       ' FROM ((ImportLog AS a INNER JOIN ImportTypes AS b ' +
       ' ON a.ImportTypeID = b.ImportTypeID) INNER JOIN RDIIAreaConverters AS c ' +
       ' ON a.ConverterID = c.RDIIAreaConverterID) INNER JOIN RDIIAreas as d ' +
       ' ON a.ForeignID = d.RDIIAreaID ' +
       ' WHERE b.Tablename = "RDIIAreaConverters" ORDER BY a.ImportDate ';
    SQLRTKPATTERNS = 'SELECT d.RTKPatternID, d.RTKPatternName, ' +
       ' c.RTKPatternConverterID, c.RTKPatternConverterName, ' +
       ' b.ImportTypeName, a.Filename, a.ImportDate, ' +
       ' a.FileDateStamp, a.ImportDetails ' +
       ' FROM ((ImportLog AS a INNER JOIN ImportTypes AS b ' +
       ' ON a.ImportTypeID = b.ImportTypeID) INNER JOIN RTKPatternConverters AS c ' +
       ' ON a.ConverterID = c.RTKPatternConverterID) INNER JOIN RTKPatterns as d ' +
       ' ON a.ForeignID = d.RTKPatternID ' +
       ' WHERE b.Tablename = "RTKPatternConverters" ORDER BY a.ImportDate ';
    SQLSWMM5IMPORTS = 'SELECT c.ScenarioID, c.ScenarioName, ' +
       ' 0 as ConverterID, "None" as ConverterName, ' +
       ' b.ImportTypeName, a.Filename, a.ImportDate, ' +
       ' a.FileDateStamp, a.ImportDetails ' +
       ' FROM (ImportLog AS a INNER JOIN ImportTypes AS b ' +
       ' ON a.ImportTypeID = b.ImportTypeID) ' +
       ' INNER JOIN Scenarios AS c ON a.foreignID = c.ScenarioID ' +
       ' WHERE b.Tablename = "Scenarios" ORDER BY a.ImportDate ';
    var
    FSQLString: string;
    FShowAll: boolean;
    FX, FY: integer;
    procedure FillStringGrid;
    procedure SetActiveTab(idx: integer);
    procedure SetColumnWidth2MaxStringWidth(idx: integer);
  public
    { Public declarations }
  end;

var
  frmDataImportLog: TfrmDataImportLog;

implementation
uses MainForm;
{$R *.dfm}

procedure TfrmDataImportLog.FillStringGrid;
var
  recSet: _recordSet;
  i: integer;
  s: string;
begin
  StringGrid1.RowCount := 2;
  StringGrid1.Rows[0].Clear;
  StringGrid1.Rows[1].Clear;
  recSet := CoRecordSet.Create;
  try
  recSet.Open(FSQLString,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  for i := 0 to recSet.Fields.Count - 1 do begin
    StringGrid1.Cells[i + 1,0] := recSet.Fields[i].Name;
  end;
  if (FShowAll) then begin
    StringGrid1.Cells[1,0] := 'ID';
    StringGrid1.Cells[2,0] := 'Name';
    StringGrid1.Cells[3,0] := 'ConverterID';
    StringGrid1.Cells[4,0] := 'ConverterName';
  end;
  StringGrid1.Cells[9,0] := StringGrid1.Cells[9,0] + ' (Dbl-Click to View)';
  if recSet.EOF  then begin
  end else begin
    recSet.MoveFirst;
    i := 1; //row counter
    while not recSet.EOF do begin
      //add a row if necessary
      if i > StringGrid1.RowCount - 1 then StringGrid1.RowCount := i + 1;
      //first col is just a counter
      StringGrid1.Cells[0,i] := IntToStr(i);
      //Class ID field - eg RaingaugeID, etc
      if VarIsNull(recSet.Fields.Item[0].Value) then
        s := ''
      else
        s := InttoStr(recSet.Fields.Item[0].Value);
      StringGrid1.Cells[1,i] := s;
      //Class Name Field
      if VarIsNull(recSet.Fields.Item[1].Value) then
        s := ''
      else
        s := recSet.Fields.Item[1].Value;
      StringGrid1.Cells[2,i] := s;

      //ConverterID field
      if VarIsNull(recSet.Fields.Item[2].Value) then
        s := ''
      else
        s := InttoStr(recSet.Fields.Item[2].Value);
      StringGrid1.Cells[3,i] := s;
      //Converter Name Field
      if VarIsNull(recSet.Fields.Item[3].Value) then
        s := ''
      else
        s := recSet.Fields.Item[3].Value;
      StringGrid1.Cells[4,i] := s;
      //Import Type Field
      if VarIsNull(recSet.Fields.Item[4].Value) then
        s := ''
      else
        s := recSet.Fields.Item[4].Value;
      StringGrid1.Cells[5,i] := s;
      //Import FileName Field
      if VarIsNull(recSet.Fields.Item[5].Value) then
        s := ''
      else
        s := recSet.Fields.Item[5].Value;
      StringGrid1.Cells[6,i] := s;
      //Import Date Field
      if VarIsNull(recSet.Fields.Item[6].Value) then
        s := ''
      else
        DateTimeToString(s,'m/d/yyyy h:nn', recSet.Fields.Item[6].Value);
      StringGrid1.Cells[7,i] := s;
      //File Date Field
      if VarIsNull(recSet.Fields.Item[7].Value) then
        s := ''
      else
        DateTimeToString(s,'m/d/yyyy h:nn', recSet.Fields.Item[7].Value);
      StringGrid1.Cells[8,i] := s;
      //Import Details Field
      if VarIsNull(recSet.Fields.Item[8].Value) then
        s := ''
      else
        s := recSet.Fields.Item[8].Value;
      StringGrid1.Cells[9,i] := s;

      inc(i);
      recSet.MoveNext;
    end;
  end;
  finally
    if (recSet.State <> adStateClosed) then recSet.Close;
  end;
end;

procedure TfrmDataImportLog.FormCreate(Sender: TObject);
begin
  StringGrid1.ColCount := 10;
  StringGrid1.ColWidths[0] := 19;
  StringGrid1.ColWidths[1] := 0; //not showing the ID fields
  StringGrid1.ColWidths[2] := 104;
  StringGrid1.ColWidths[3] := 0; //do we need to see the ConverterID?
  StringGrid1.ColWidths[4] := 104;
  StringGrid1.ColWidths[5] := 164;
  StringGrid1.ColWidths[6] := 224;
  StringGrid1.ColWidths[7] := 84;
  StringGrid1.ColWidths[8] := 84;
  StringGrid1.ColWidths[9] := 164;
end;

procedure TfrmDataImportLog.FormShow(Sender: TObject);
begin
  TabSet1.TabIndex := 0;
  SetActiveTab(TabSet1.TabIndex);
end;

procedure TfrmDataImportLog.SetActiveTab(idx: integer);
begin
  FShowAll := false;
  case idx of
    0:begin //ALL
       FShowAll := true;
       FSQLString := SQLRAINFALL +
       ' union all ' + SQLFLOWS +
       ' union all ' + SQLSEWERSHEDS +
       ' union all ' + SQLRDIIAREAS +
       ' union all ' + SQLRTKPATTERNS +
       ' union all ' + SQLSWMM5IMPORTS;
    end;
    1:begin //Rainfall
       FSQLString := SQLRAINFALL;
    end;
    2:begin //Flows
       FSQLString := SQLFLOWS;
    end;
    3:begin //Sewersheds
       FSQLString := SQLSEWERSHEDS;
    end;
    4:begin //RDII Areas
       FSQLString := SQLRDIIAREAS;
    end;
    5:begin //RTK Patterns
       FSQLString := SQLRTKPATTERNS;
    end;
    6:begin //SWMM 5 Imports
       FSQLString := SQLSWMM5IMPORTS;
    end;
  end;
  FillStringGrid;
end;

procedure TfrmDataImportLog.SetColumnWidth2MaxStringWidth(idx: integer);
var j, itest, imax: integer;
begin
  //fit column width to max string width in column - including header
  if idx < 9 then begin  //last column is a memo - skip it

  imax := 0;
  for j := 0 to StringGrid1.RowCount - 1 do  begin
    itest := StringGrid1.Canvas.TextWidth(StringGrid1.Cells[idx,j]);
    if (itest > imax) then imax := itest;
  end;
  StringGrid1.ColWidths[idx] := imax + 4;  //plus some padding

  end;
end;

procedure TfrmDataImportLog.StringGrid1DblClick(Sender: TObject);
var i, itest: integer;
  s: string;
begin
  //fit column width to max string width if user double-clicks on column header
  if (FY < StringGrid1.RowHeights[0]) then begin
    itest := 0;
    for i := 0 to StringGrid1.ColCount - 1 do begin
      //factor in leftcol (first col showing if grid is scrolled)
      if (i = 0) or (i>=StringGrid1.LeftCol) then begin
        itest := itest + StringGrid1.ColWidths[i] + 1;
        if (FX < itest) then begin
          //showmessage('Got column number ' + inttostr(i));
          SetColumnWidth2MaxStringWidth(i);
          exit;
        end;
      end;
    end;
  end else begin
    //show Details stored in Memo-type field if double-click on ImportDetails Cell
    if (StringGrid1.Col = 9) then begin
      s := StringGrid1.Cells[9,StringGrid1.Row];
      if (Length(s) > 0) then begin
        frmFeedbackWithMemo.Caption := 'Data Import Log Details';
        frmFeedbackWithMemo.StatusLabel.Caption := 'Processing Date:';
        frmFeedbackWithMemo.DateLabel.caption := StringGrid1.Cells[7,StringGrid1.Row];
        frmFeedbackWithMemo.feedbackMemo.Text := s;
        frmFeedbackWithMemo.OpenAfterProcessing;
      end;
    end;
  end;
end;

procedure TfrmDataImportLog.StringGrid1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //store X and Y for double-click purposes
  FX := X;
  FY := Y;
end;

procedure TfrmDataImportLog.TabSet1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  SetActiveTab(NewTab);
end;

end.
