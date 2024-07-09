unit rtkpatternmanager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, StrUtils;

type
  TfrmRTKPatternManager = class(TForm)
    ListBoxLabel: TLabel;
    addButton: TButton;
    closeButton: TButton;
    helpButton: TButton;
    editButton: TButton;
    deleteButton: TButton;
    RTKPatternsListBox: TListBox;
    copyButton: TButton;
    StringGrid1: TStringGrid;
    procedure closeButtonClick(Sender: TObject);
    procedure deleteButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure addButtonClick(Sender: TObject);
    procedure editButtonClick(Sender: TObject);
    procedure copyButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private { Private declarations }
    function LastPos(substr:string; s:string): integer;
    procedure UpdateList();
  public { Public declarations }
    function SelectedRTKPatternName(): String;
    //rm 2010-09-29
    function SelectedRTKPatternMonth(): Integer;
  end;

var
  frmRTKPatternManager: TfrmRTKPatternManager;

implementation

uses newGauge, editraingauge, modDatabase, RTKPatternEditor, mainform;

{$R *.DFM}

procedure TfrmRTKPatternManager.FormShow(Sender: TObject);
begin
  StringGrid1.RowCount := 2;
  StringGrid1.Cells[1,0] := 'Pattern Name';
  //rm 2010-09-29 - put month in here
  StringGrid1.Cells[2,0] := 'Mon';
  StringGrid1.Cells[3,0] := 'Total R';
  StringGrid1.Cells[4,0] := 'R1';
  StringGrid1.Cells[5,0] := 'T1';
  StringGrid1.Cells[6,0] := 'K1';
  StringGrid1.Cells[7,0] := 'R2';
  StringGrid1.Cells[8,0] := 'T2';
  StringGrid1.Cells[9,0] := 'K2';
  StringGrid1.Cells[10,0] := 'R3';
  StringGrid1.Cells[11,0] := 'T3';
  StringGrid1.Cells[12,0] := 'K3';
  //rm 2010-10-05 - rename fields to match SWMM5 help
  StringGrid1.Cells[13,0] := 'Dm1'; //'IAM1';
  StringGrid1.Cells[14,0] := 'Dr1'; //'IAR1';
  StringGrid1.Cells[15,0] := 'Do1'; //'IAI1';
  StringGrid1.Cells[16,0] := 'Dm2'; //'IAM2';
  StringGrid1.Cells[17,0] := 'Dr2'; //'IAR2';
  StringGrid1.Cells[18,0] := 'Do2'; //'IAI2';
  StringGrid1.Cells[19,0] := 'Dm3'; //'IAM3';
  StringGrid1.Cells[20,0] := 'Dr3'; //'IAR3';
  StringGrid1.Cells[21,0] := 'Do3'; //'IAI3';
  UpdateList();
  RTKPatternsListBox.ItemIndex := 0;
  StringGrid1.Row := 1;
//  StringGrid1.Sel
end;

procedure TfrmRTKPatternManager.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

function TfrmRTKPatternManager.LastPos(substr, s: string): integer;
begin
  Result := Pos(ReverseString(substr), ReverseString(s));
  if (Result <> 0) then begin
    Result := ((Length(s) - Length(substr)) + 1) - Result + 1;
  end;
end;

procedure TfrmRTKPatternManager.addButtonClick(Sender: TObject);
begin
  frmRTKPatternEditor.AddingNewRecord := true;
  frmRTKPatternEditor.CopyingRecord := false;
  //frmRTKpatternEditor.RTKPatternName := SelectedRTKPatternName;
  frmRTKpatternEditor.RTKPatternName := 'New_RTK_Pattern';
  frmRTKPatternEditor.ShowModal;
  UpdateList();
//  RTKPatternsListBox.ItemIndex := previousItemIndex;
//  frmAddNewGauge.ShowModal;
//  UpdateList();
  RTKPatternsListBox.ItemIndex := RTKPatternsListBox.Items.Count - 1;
  StringGrid1.Row := RTKPatternsListBox.Items.Count;
end;

procedure TfrmRTKPatternManager.editButtonClick(Sender: TObject);
var
  previousItemIndex: integer;
begin
  frmRTKPatternEditor.AddingNewRecord := false;
  frmRTKPatternEditor.CopyingRecord := false;
  //frmRTKPatternEditor.
  previousItemIndex := RTKPatternsListBox.ItemIndex;
  //rm 2010-10-05
  frmRTKPatternEditor.RTKPatternMonth := SelectedRTKPatternMonth;

  frmRTKpatternEditor.RTKPatternName := SelectedRTKPatternName;
  frmRTKPatternEditor.ShowModal;
  UpdateList();
  RTKPatternsListBox.ItemIndex := previousItemIndex;
  StringGrid1.Row := previousItemIndex + 1;
end;

procedure TfrmRTKPatternManager.deleteButtonClick(Sender: TObject);
var
  previousIndex, result : integer;
  rtkPatternName, analysisName: String;
  scenarioNames: TStringList;
begin
  rtkPatternName := SelectedRTKPatternName;
  result := MessageDlg('Are you sure you want to delete RTK Pattern "'+rtkPatternName+'"?',mtWarning,[mbYes,mbNo],0);
  if (result = mrYes) then begin
    scenarioNames := DatabaseModule.GetScenarioNames4RTKPatternName(rtkPatternName);
    if scenarioNames.Count < 1 then begin
      analysisName := DatabaseModule.GetAnalysisName4RTKPatternName(rtkPatternName);
      if Length(analysisName) < 1 then begin
        previousIndex := RTKPatternsListBox.ItemIndex;
        DatabaseModule.RemoveRTKPattern(rtkPatternName);
        UpdateList();
        if (RTKPatternsListBox.Items.Count < previousIndex + 1) then begin
          RTKPatternsListBox.ItemIndex := RTKPatternsListBox.Items.Count - 1;
          StringGrid1.Row := RTKPatternsListBox.Items.Count;
        end else begin
          RTKPatternsListBox.ItemIndex := previousIndex;
          StringGrid1.Row := previousIndex + 1;
        end;
      end else
        MessageDlg('This RTK Pattern cannot be deleted because it is used in the following analysis:' +
          #13#13 + analysisName,mtError,[mbOK],0);
    end else
      MessageDlg('This RTK Pattern cannot be deleted because it is used in the following scenarios:' +
        #13#13 + scenarioNames.Text,mtError,[mbOK],0);
  end;
end;

procedure TfrmRTKPatternManager.UpdateList();
var i: integer;
  varList: TStringList;
  r1, r2, r3, rT: double;

  function sTrim(s:string):string;
  begin
    Result := StringReplace(s, ';', '', [rfReplaceAll]);
  end;

begin
//rm 2010-09-28  RTKPatternsListBox.Items := DatabaseModule.GetRTKPatternNames;
  RTKPatternsListBox.Items := DatabaseModule.GetRTKPatternNames_with_IA;
  deleteButton.Enabled := RTKPatternsListBox.Items.Count > 0;
  editButton.Enabled := RTKPatternsListBox.Items.Count > 0;
  copyButton.Enabled := RTKPatternsListBox.Items.Count > 0;

  //rm 2009-06-22 - Move to new StringGrid;
  varList := TStringList.Create;
  for i := 0 to RTKPatternsListBox.Items.Count - 1 do begin
    varList.CommaText := RTKPatternsListBox.Items[i];
    rT := 0.0;
    StringGrid1.RowCount := i + 2;
    StringGrid1.Cells[0,i+1] := IntToStr(i+1);
    StringGrid1.Cells[1,i+1] := sTrim(varList.Strings[0]);
    StringGrid1.Cells[2,i+1] := sTrim(varList.Strings[19]);
    StringGrid1.Cells[4,i+1] := sTrim(varList.Strings[1]);
    StringGrid1.Cells[5,i+1] := sTrim(varList.Strings[2]);
    StringGrid1.Cells[6,i+1] := sTrim(varList.Strings[3]);
    StringGrid1.Cells[7,i+1] := sTrim(varList.Strings[4]);
    StringGrid1.Cells[8,i+1] := sTrim(varList.Strings[5]);
    StringGrid1.Cells[9,i+1] := sTrim(varList.Strings[6]);
    StringGrid1.Cells[10,i+1] := sTrim(varList.Strings[7]);
    StringGrid1.Cells[11,i+1] := sTrim(varList.Strings[8]);
    StringGrid1.Cells[12,i+1] := sTrim(varList.Strings[9]);
    StringGrid1.Cells[13,i+1] := sTrim(varList.Strings[10]);
    StringGrid1.Cells[14,i+1] := sTrim(varList.Strings[11]);
    StringGrid1.Cells[15,i+1] := sTrim(varList.Strings[12]);
    StringGrid1.Cells[16,i+1] := sTrim(varList.Strings[13]);
    StringGrid1.Cells[17,i+1] := sTrim(varList.Strings[14]);
    StringGrid1.Cells[18,i+1] := sTrim(varList.Strings[15]);
    StringGrid1.Cells[19,i+1] := sTrim(varList.Strings[16]);
    StringGrid1.Cells[20,i+1] := sTrim(varList.Strings[17]);
    StringGrid1.Cells[21,i+1] := sTrim(varList.Strings[18]);
    try
      r1 := StrToFloat(StringGrid1.Cells[4,i+1]);
      r2 := StrToFloat(StringGrid1.Cells[7,i+1]);
      r3 := StrToFloat(StringGrid1.Cells[10,i+1]);
      rT := r1 + r2 + r3;
    finally
      StringGrid1.Cells[3,i+1] := FormatFloat('0.000',rT);
    end;
  end;

end;

//rm 2010-09-29
function TfrmRTKPatternManager.SelectedRTKPatternMonth(): Integer;
var s: string; i: integer;
begin
//  StringGrid1.Cells[2,0] := 'Mon';
  if RTKPatternsListBox.ItemIndex > -1 then  begin
//    s := RTKPatternsListBox.Items[RTKPatternsListBox.ItemIndex][1];
    s := StringGrid1.Cells[2,RTKPatternsListBox.ItemIndex + 1];
    SelectedRTKPatternMonth := StrToInt(s);
  end else
    SelectedRTKPatternMonth := 0;
  //MessageDlg('Selected = ''' + s + '''',mtinformation,[mbok],0);
end;

function TfrmRTKPatternManager.SelectedRTKPatternName(): String;
var s: string; i: integer;
begin
  if RTKPatternsListBox.ItemIndex > -1 then  begin
    s := RTKPatternsListBox.Items[RTKPatternsListBox.ItemIndex];
    i := LastPos(':',s);
    s := Copy(s,1,i-1);
    SelectedRTKPatternName := s;
  end else
    SelectedRTKPatternName := '';
  //MessageDlg('Selected = ''' + s + '''',mtinformation,[mbok],0);
end;

procedure TfrmRTKPatternManager.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  RTKPatternsListBox.Selected[ARow-1] := true;
end;

procedure TfrmRTKPatternManager.copyButtonClick(Sender: TObject);
var
  oldCount,oldItemIndex: integer;
begin
  frmRTKPatternEditor.AddingNewRecord := false;
  frmRTKPatternEditor.CopyingRecord := true;
  //frmRTKPatternEditor.
  oldCount := RTKPatternsListBox.Items.Count;
  oldItemIndex := RTKPatternsListBox.ItemIndex;
  frmRTKpatternEditor.RTKPatternName := SelectedRTKPatternName;
  frmRTKPatternEditor.ShowModal;
  UpdateList();
  if RTKPatternsListBox.Items.Count > oldCount then begin
    RTKPatternsListBox.ItemIndex := RTKPatternsListBox.Count - 1;
    StringGrid1.Row := RTKPatternsListBox.Count;
  end else begin
    RTKPatternsListBox.ItemIndex := oldItemIndex;
    StringGrid1.Row := oldItemIndex + 1;
  end;
end;

procedure TfrmRTKPatternManager.closeButtonClick(Sender: TObject);
begin
//rm do not close = modalresult set to mrCancel  Close;
end;

end.
