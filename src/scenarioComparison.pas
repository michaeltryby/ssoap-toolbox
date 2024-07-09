unit ScenarioComparison;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ADODB_TLB, SWMM5_IFACE, Spin, frmScenarioGraph, frmScenarioConduitGraph;

type
  TfrmScenarioComparison = class(TForm)
    GroupBox1: TGroupBox;
    ScenarioDescription1: TMemo;
    Label1: TLabel;
    ScenarioNameComboBox1: TComboBox;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    ScenarioDescription2: TMemo;
    Label5: TLabel;
    Label6: TLabel;
    ScenarioNameComboBox2: TComboBox;
    Summarylistbox1: TListBox;
    summarylistbox2: TListBox;
    LabelStatus: TLabel;
    LabelFind: TLabel;
    cbxFind: TComboBox;
    btnFind: TButton;
    Label7: TLabel;
    SpinEditFloodCritera: TSpinEdit;
    EditOutFileName2: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    EditOutFileName1: TEdit;
    btnEditScenario: TButton;
    Button1: TButton;
    btnViewTS: TButton;
    btnCapComp: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
    procedure ScenarioNameComboBox1Change(Sender: TObject);
    procedure ScenarioNameComboBox2Change(Sender: TObject);
    procedure UpdateSummary(scenarioID : integer;listbox : TListBox);
    procedure Summarylistbox1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpinEditFloodCriteraChange(Sender: TObject);
    procedure btnEditScenarioClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnViewTSClick(Sender: TObject);
    procedure btnCapCompClick(Sender: TObject);
  private { Private declarations }
    existingScenarioNames: TStringList;
    m_scenarioID1: integer;
    m_scenarioID2: integer;
    procedure SyncListBoxes(sName:string;istart,iend:integer;listbox:TListBox);
  public { Public declarations }
  end;

var
  frmScenarioComparison: TfrmScenarioComparison;
  flood_1a, flood_na, surch_1a, surch_na, outl_1a, outl_na, capa_1a, capa_na: Integer;
  flood_1b, flood_nb, surch_1b, surch_nb, outl_1b, outl_nb, capa_1b, capa_nb: Integer;

  flood_1, flood_n, surch_1, surch_n, outl_1, outl_n, capa_1, capa_n: Array[0..1] of Integer;

implementation

uses modDatabase, mainform, editscenario;

{$R *.DFM}
function LeftPad(S: string; Ch: Char; Len: Integer): string;
var
  RestLen: Integer;
begin
  Result  := S;
  RestLen := Len - Length(s);
  if RestLen < 1 then Exit;
  Result := S + StringOfChar(Ch, RestLen);
end;
function RightPad(S: string; Ch: Char; Len: Integer): string;
var
  RestLen: Integer;
begin
  Result  := S;
  RestLen := Len - Length(s);
  if RestLen < 1 then Exit;
  Result := StringOfChar(Ch, RestLen) + S;
end;
function MyFormattedString(s1,s2,s3:string): string;
begin
  Result := LeftPad(s1,' ',16) + RightPad(s2,' ',16);
  if Length(s3) > 0 then
    Result := Result + RightPad(s3,' ',16);
end;

procedure TfrmScenarioComparison.FormShow(Sender: TObject);
var
  scenarioID1, scenarioID2 : integer;
begin
  ScenarioNameComboBox1.Items := DatabaseModule.GetScenarioNames();
  ScenarioNameComboBox1.ItemIndex := 0;
  existingScenarioNames := DatabaseModule.GetScenarioNames;
  scenarioDescription1.Text := DatabaseModule.GetScenarioDesciption(ScenarioNameComboBox1.Text);
  ScenarioNameComboBox2.Items := DatabaseModule.GetScenarioNames();
  ScenarioNameComboBox2.ItemIndex := 0;
  scenarioDescription2.Text := DatabaseModule.GetScenarioDesciption(ScenarioNameComboBox2.Text);
  scenarioID1 := databasemodule.GetScenarioIDForName(ScenarioNameComboBox1.text);
  updatesummary(scenarioID1,summarylistbox1);
  scenarioID2 := databasemodule.GetScenarioIDForName(ScenarioNameComboBox2.text);
  updatesummary(scenarioID2,summarylistbox2);

  EditOutFileName1.Text := DataBaseModule.GetScenarioOutFileName(scenarioID1);
  EditOutFileName2.Text := DataBaseModule.GetScenarioOutFileName(scenarioID2);

end;



procedure TfrmScenarioComparison.ScenarioNameComboBox2Change(Sender: TObject);
//var
  //scenarioID2 : integer;
begin
  scenarioDescription2.Text := DatabaseModule.GetScenarioDesciption(ScenarioNameComboBox2.Text);
  m_scenarioID2 := databasemodule.GetScenarioIDForName(ScenarioNameComboBox2.text);
  UpdateSummary(m_scenarioID2,summarylistbox2);
  EditOutFileName2.Text := DataBaseModule.GetScenarioOutFileName(m_scenarioID2);
end;

procedure TfrmScenarioComparison.SpinEditFloodCriteraChange(Sender: TObject);
begin
//user sets Flooding Criteria absolute elevation
end;

procedure TfrmScenarioComparison.Summarylistbox1Click(Sender: TObject);
var
  idx : integer;
begin
  idx := (Sender as TListBox).Itemindex;
  labelStatus.caption := IntToStr(idx) + '/' + IntToStr(flood_1[0]) + '  ' + IntToStr(surch_1[0]) + '/' + IntToStr(outl_1[0]) + '/' + IntToStr(capa_1[0])
     + '//' + IntToStr(flood_n[0]) + '/' + IntToStr(surch_n[0]) + '/' + IntToStr(outl_n[0]) + '/' + IntToStr(capa_n[0]);
  if (idx <= flood_1[0]) then begin
    SummaryListBox2.ItemIndex := idx;
  end else
  if ((idx > flood_1[0]) and (idx <= flood_n[0])) then begin
    labelStatus.caption := 'Flooding Node number ' + IntToStr(idx - flood_1[0]);
    SyncListBoxes((Sender as TListBox).Items[(Sender as TListBox).itemindex],
      flood_1[1],flood_n[1],SummaryListBox2);
  end else
  if (idx <= surch_1[0]) then begin
    SummaryListBox2.ItemIndex := surch_1[1] - surch_1[0] + idx;
  end else
  if ((idx > surch_1[0]) and (idx <= surch_n[0])) then begin
    labelStatus.caption := 'Surcharge Conduit number ' + IntToStr(idx - surch_1[0]);
    SyncListBoxes((Sender as TListBox).Items[(Sender as TListBox).itemindex],
      surch_1[1],surch_n[1],SummaryListBox2);
  end else
  if (idx <= outl_1[0]) then begin
    SummaryListBox2.ItemIndex := outl_1[1] - outl_1[0] + idx;
  end else
  if ((idx > outl_1[0]) and (idx <= outl_n[0])) then begin
    labelStatus.caption := 'Outlet Node number ' + IntToStr(idx - outl_1[0]);
    SyncListBoxes((Sender as TListBox).Items[(Sender as TListBox).itemindex],
      outl_1[1],outl_n[1],SummaryListBox2);
  end else
  if (idx <= capa_1[0]) then begin
    SummaryListBox2.ItemIndex := capa_1[1] - capa_1[0] + idx;
  end else
  if ((idx > capa_1[0]) and (idx <= capa_n[0])) then begin
    labelStatus.caption := 'Capacity Conduit number ' + IntToStr(idx - capa_1[0]);
    SyncListBoxes((Sender as TListBox).Items[(Sender as TListBox).itemindex],
      capa_1[1],capa_n[1],SummaryListBox2);
  end else begin
    SummaryListBox2.ItemIndex := capa_n[1] - capa_n[0] + idx;
  end;
end;

procedure TfrmScenarioComparison.SyncListBoxes(sName: string; istart,
  iend: integer; listbox: TListBox);
var
  i, j, idx, separatorPosition: integer;
  boDone: bool;
  starget, line: string;
begin
  if listbox = SummaryListBox2 then idx := 1 else idx := 0;
  i := istart + 1;
  starget := TrimLeft(sName);
  separatorPosition := Pos(' ',starget);
  starget := copy(starget,1,separatorPosition-1);
  labelStatus.Caption := 'Searching for "' + starget + '"';
  boDone := false;
  while not boDone do begin
    line := TrimLeft(listbox.Items[i]);
    separatorPosition := Pos(' ',line);
    line := copy(line,1,separatorPosition-1);
    //labelStatus.Caption := labelStatus.Caption + ' "' + line + '"';
    if UpperCase(line) = UpperCase(starget) then begin
      listbox.ItemIndex := i;
      labelStatus.Caption := labelStatus.Caption + ' Found.';
      boDone := true;
    end;
    inc(i);
    if (i > iend) and not boDone then begin
      boDone := true;
      listbox.itemindex := -1;//istart;
      labelStatus.Caption := labelStatus.Caption + ' Not Found.';
    end;
  end;
end;

procedure TfrmScenarioComparison.ScenarioNameComboBox1Change(Sender: TObject);
//var
//  scenarioID1 : integer;
begin
  scenarioDescription1.Text := DatabaseModule.GetScenarioDesciption(ScenarioNameComboBox1.Text);
  m_scenarioID1 := databasemodule.GetScenarioIDForName(ScenarioNameComboBox1.text);
  UpdateSummary(m_scenarioID1, summarylistbox1);
  EditOutFileName1.Text := DataBaseModule.GetScenarioOutFileName(m_scenarioID1);
end;


procedure TfrmScenarioComparison.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  existingScenarioNames.Free;
end;


procedure TfrmScenarioComparison.FormCreate(Sender: TObject);
begin
  LabelStatus.Caption := '';
end;

procedure TfrmScenarioComparison.FormResize(Sender: TObject);
begin
//Resize / Reposition Controls
  GroupBox1.Width := (ClientWidth -24) div 2;
  GroupBox2.Width := GroupBox1.Width;
  GroupBox2.Left := GroupBox1.Left + GroupBox1.Width + 8;
  //Groupbox1.Height := ClientHeight - 32;
  Groupbox1.Height := ClientHeight - 56;
  GroupBox2.Height := Groupbox1.Height;

  ScenarioNamecombobox1.width := GroupBox1.Width - (2 * ScenarioNameComboBox1.Left);
  ScenarioDescription1.Width :=  ScenarioNamecombobox1.width;
  SummaryListBox1.width := ScenarioNamecombobox1.width;
  ScenarioNamecombobox2.width := ScenarioNamecombobox1.width;
  ScenarioDescription2.Width :=  ScenarioNamecombobox1.width;
  SummaryListBox2.width := ScenarioNamecombobox1.width;

  EditOutFileName1.Width := ScenarioNamecombobox1.width;
  EditOutFileName2.Width := ScenarioNamecombobox1.width;

  SummaryListBox1.Height := GroupBox1.Height - SummaryListBox1.Top - 12;
  SummaryListBox2.Height := SummaryListBox1.Height;

  LabelStatus.Top := GroupBox1.Top + GroupBox1.Height + 2;

  LabelFind.Top := LabelStatus.Top;
  cbxFind.Top := LabelFind.Top - 2;
  btnFind.Top := cbxFind.Top;

  label7.Top := LabelStatus.Top +24;
  SpinEditFloodCritera.Top := Label7.top; 
end;

procedure TfrmScenarioComparison.btnCapCompClick(Sender: TObject);
begin
//rm 2009-06-29 - Allow user to select two scenarios and one conduit
  ScenarioConduitGraphForm.Initialize;
  ScenarioConduitGraphForm.SetScenarioIDs(m_scenarioID1, m_scenarioID2);
  ScenarioConduitGraphForm.ShowModal;
end;

procedure TfrmScenarioComparison.btnEditScenarioClick(Sender: TObject);
begin
//edit selected scenariio
  if Length(ScenarioNameComboBox1.Text) > 0 then begin
    frmEditScenario.scenarioName :=
      ScenarioNameComboBox1.Text;
    frmEditScenario.ShowModal;
  end;
end;

procedure TfrmScenarioComparison.btnFindClick(Sender: TObject);
var
  boDone:bool;
  line: string;
  listbox: TListbox;
  i,separatorPosition:integer;
begin
  listbox := SummaryListBox1;
  boDone := false;
  i := listbox.itemindex + 1;
//  if i<0 then i:=0;
  labelStatus.Caption := 'Searching for "' + cbxFind.Text + '"';
  if cbxFind.Items.IndexOf(cbxFind.Text) < 0 then
    cbxFind.Items.Add(cbxFind.Text);
  while not boDone do begin
    if (i < listbox.Items.Count) then begin
    line := TrimLeft(listbox.Items[i]);
    separatorPosition := Pos(' ',line);
    line := copy(line,1,separatorPosition-1);
    //labelStatus.Caption := labelStatus.Caption + ' "' + line + '"';
    if UpperCase(line) = UpperCase(cbxFind.Text) then begin
      listbox.ItemIndex := i;
      labelStatus.Caption := labelStatus.Caption + ' Found.';
      boDone := true;
      Summarylistbox1Click(listbox);
    end;
    inc(i);
    end;
    if (i >= listbox.Items.Count) and not boDone then begin
      boDone := true;
      listbox.itemindex := -1;//istart;
      labelStatus.Caption := labelStatus.Caption + ' Not Found.';
    end;
  end;
end;

procedure TfrmScenarioComparison.btnViewTSClick(Sender: TObject);
begin
//rm 2009-06-29 - allow user to select a junction
// and draw timeseries graph from both scenarios
  ScenarioGraphForm.Initialize;

  //ScenarioGraphForm.SetScenarioID(m_scenarioID1,'A');
  //ScenarioGraphForm.SetScenarioID(m_scenarioID2,'B');
  ScenarioGraphForm.SetScenarioIDs(m_scenarioID1, m_scenarioID2);
  //ScenarioGraphForm.SetType('Junction Depth');
  //ScenarioGraphForm.SetJunction(ListBoxSelectedNodes.Items[ListBoxSelectedNodes.ItemIndex]);
  ScenarioGraphForm.ShowModal;
end;

procedure TfrmScenarioComparison.Button1Click(Sender: TObject);
begin
//edit selected scenariio
  if Length(ScenarioNameComboBox2.Text) > 0 then begin
    frmEditScenario.scenarioName :=
      ScenarioNameComboBox2.Text;
    frmEditScenario.ShowModal;
  end;
end;

procedure TfrmScenarioComparison.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmScenarioComparison.FloatEdtKeyPressAllowNegative(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmScenarioComparison.UpdateSummary(scenarioID : integer; listbox : TListBox);
var
  queryStr: string;
  recSet: _RecordSet;
  recordcount : integer;
  displayStr : string;
  temp_cap : double;
  found_recond : boolean;
  idx : integer;
  i : integer;
begin
  listbox.clear;

  if listbox = SummaryListBox1 then
    idx := 0
  else
    idx := 1;
  flood_1[idx] := 0;
  flood_n[idx] := 0;
  surch_1[idx] := 0;
  surch_n[idx] := 0;
  outl_1[idx] := 0;
  outl_n[idx] := 0;
  capa_1[idx] := 0;
  capa_n[idx] := 0;

  //Obtain Flooding Information
  querystr := 'SELECT NodeID, Volume, Duration FROM Flooding WHERE ' +
              '(((ScenarioID)=' + inttostr(scenarioID) +
              ') AND ((Volume)>0)) ORDER BY NodeID;';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //recSet.MoveFirst;
  recordcount := 0;
  found_recond := false;
  while (not recSet.EOF) do begin
    recordcount := recordcount + 1;
    recSet.MoveNext;
    found_recond := true;
  end;
  // - choose correct ScenarioNameComboBox - 1 or 2
  if listbox = Summarylistbox1 then
    listbox.Items.Add('Scenario: ' + ScenarioNameComboBox1.text)
  else
    listbox.Items.Add('Scenario: ' + ScenarioNameComboBox2.text);
  listbox.Items.add('');
  i := 1; //current line number

  //Display Flooding Summary
  listbox.Items.Add('-----------------------------------------------------------------');
  listbox.Items.Add('Flooding: ' + inttostr(recordcount) + ' junction(s)');
  listbox.Items.Add('-----------------------------------------------------------------');
  inc(i,3);
  //listbox.Items.Add('');
  listbox.Items.Add(
    MyFormattedString(
      'Flooding','Flooding','Flooding'));
  listbox.Items.Add(
    MyFormattedString(
      'Junction ID','Volume(MG)','Duration (hr)'));
  inc(i,2);

  flood_1[idx] := i;
  if found_recond = true then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    listbox.Items.Add(
      MyFormattedString(
        recSet.Fields.Item[0].Value,
        floattostrF(recSet.Fields.Item[1].Value,ffFixed,8,2),
        floattostrF(recSet.Fields.Item[2].Value,ffFixed,8,2)));
    inc(i,1);
    recSet.MoveNext;
  end;
  recSet.Close;
  flood_n[idx] := i;
  listbox.Items.Add('');
  inc(i,1);

  //Obtain Surcharge Information
  querystr := 'SELECT ConduitID, Duration FROM ConduitMaxCapacity ' +
              'WHERE (((MaxCapacity)>=1) AND ' +
              '(ScenarioID=' +
              inttostr(scenarioID) + ')) Order by ConduitID;';

  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //recSet.MoveFirst;
  recordcount := 0;
  found_recond := false;
  while (not recSet.EOF) do begin
    recordcount := recordcount + 1;
    recSet.MoveNext;
    found_recond := true;
  end;

  //Display Surcharge Summary
  listbox.Items.Add('-----------------------------------------------------------------');
  listbox.Items.Add('Surcharge: ' + inttostr(recordcount) + ' conduit(s)');
  listbox.Items.Add('-----------------------------------------------------------------');
  inc(i,3);
  //listbox.Items.Add('');
  listbox.Items.Add(
    MyFormattedString(
      'Surcharge','Surcharge',''));
  listbox.Items.Add(
    MyFormattedString(
      'Conduit ID','Duration (hr)',''));
  inc(i,2);

  surch_1[idx] := i;
  if found_recond = true then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    listbox.Items.Add(
      MyFormattedString(
        recSet.Fields.Item[0].Value,
        floattostrF(recSet.Fields.Item[1].Value,ffFixed,8,2),
        ''));
    inc(i,1);
    recSet.MoveNext;
  end;
  recSet.Close;
  surch_n[idx] := i;
  listbox.Items.Add('');
  inc(i,1);

 //Obtain Outlet Information
  querystr := 'SELECT NodeID, Volume FROM OutletVolume ' +
              'WHERE (((Volume)>0) AND ' +
              '(ScenarioID=' +
              inttostr(scenarioID) + ')) Order by NodeID;';

  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
//  recSet.MoveFirst;
  recordcount := 0;
  found_recond := false;
  while (not recSet.EOF) do begin
    recordcount := recordcount + 1;
    recSet.MoveNext;
    found_recond := true;
  end;
  //Display Outlet Summary
  listbox.Items.Add('-----------------------------------------------------------------');
  listbox.Items.Add('Outlet: ' + inttostr(recordcount) + ' junction(s)');
  listbox.Items.Add('-----------------------------------------------------------------');
  inc(i,3);
  //listbox.Items.Add('');
  listbox.Items.Add(
    MyFormattedString(
      'Outlet','Outflow',''));
  listbox.Items.Add(
    MyFormattedString(
      'Junction ID','Volume(MG)',''));
  inc(i,2);

  outl_1[idx] := i;
  if found_recond = true then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    listbox.Items.Add(
      MyFormattedString(
        recSet.Fields.Item[0].Value,
        floattostrF(recSet.Fields.Item[1].Value,ffFixed,8,2),
        ''));
//      floattostrF(recSet.Fields.Item[3].Value,ffFixed,8,2));
    inc(i,1);
    recSet.MoveNext;
  end;
  recSet.Close;
  outl_n[idx] := i;
  listbox.Items.Add('');
  inc(i,1);


 //Obtain Capacity Information
  querystr := 'SELECT ConduitID, [Size], MaxCapacity FROM ConduitMaxCapacity ' +
              'WHERE (ScenarioID=' +
              inttostr(scenarioID) + ') Order by ConduitID;';

  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if not recSet.EOF then
    recSet.MoveFirst;
  recordcount := 0;
  temp_cap := 0;
  found_recond := false;
  //rm 2009-07-20 - dropping "Avewrage Capacity" for now
  while (not recSet.EOF) do begin
    recordcount := recordcount + 1;
    //rm 2009-07-20 - get Item[2] instead of Item[1]
    //temp_cap := temp_cap + recSet.Fields.Item[1].Value;
//    temp_cap := temp_cap + recSet.Fields.Item[2].Value;
    recSet.MoveNext;
    found_recond := true;
  end;
  //Display Capacity Summary
  listbox.Items.Add('-----------------------------------------------------------------');
  listbox.Items.Add('Capacity: ');
  //rm 2009-07-20 - dropping "Avewrage Capacity" for now
  //if recordcount > 0 then begin
  //  listbox.Items.Add('Average System Capacity - ' + floattostrF(temp_cap/recordcount*100,ffFixed,8,2) + '%');
  //  inc(i,1)
  //end;
  listbox.Items.Add('-----------------------------------------------------------------');
  inc(i,3);
  //listbox.Items.Add('');
  //listbox.Items.Add('Average System Capacity:' + floattostrF(temp_cap/recordcount*100,ffFixed,8,2) + '%');
  listbox.Items.Add(
    MyFormattedString('Conduit','Conduit','Conduit'));
  listbox.Items.Add(
    MyFormattedString('ID','Size(ft)','Capacity(%)'));
  inc(i,2);

  capa_1[idx] := i;
  if found_recond = true then recSet.MoveFirst;
  while (not recSet.EOF) do begin
    listbox.Items.Add(
      MyFormattedString(recSet.Fields.Item[0].Value,
        floattostrF(recSet.Fields.Item[1].Value,ffFixed,8,2),
        floattostrF(recSet.Fields.Item[2].Value*100,ffFixed,8,2)));
    inc(i,1);
    recSet.MoveNext;
  end;
  recSet.Close;
  capa_n[idx] := i;
  listbox.Items.Add('');
  inc(i,1);
end;

end.
