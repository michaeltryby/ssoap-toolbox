unit RTKPatternAssignment;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Math, ComCtrls, StrUtils, ExtCtrls, Uutils;

type
  TfrmRTKPatternAssignment = class(TForm)
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    Label1: TLabel;
    LabelRDIIAreas: TLabel;
    Label3: TLabel;
    ListBoxSewerSheds: TListBox;
    ListBoxRDIIAreas: TListBox;
    lblSelectedSewerShed: TLabel;
    lblSelectedRDIIArea: TLabel;
    lblSelectedPattern: TLabel;
    Label4: TLabel;
    btnAddLink: TButton;
    btnDeleteLink: TButton;
    btnModifyLink: TButton;
    lblScenarioID: TLabel;
    lblDescription: TLabel;
    StringGridRTKLink: TStringGrid;
    lblSelectedPatternLongName: TLabel;
    btnEditSewerShed: TButton;
    btnEditRDIIArea: TButton;
    btnEditRTKPattern: TButton;
    CheckBoxSelectAllRDIIAreas: TCheckBox;
    CheckBoxFromAnalyses: TCheckBox;
    CheckBoxIgnoreRDIIAreas: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Shape1: TShape;
    CheckBox1: TCheckBox;
    LabelExplanation: TLabel;
    StringGridRTKPatterns: TStringGrid;
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
    procedure ListBoxSewerShedsClick(Sender: TObject);
    procedure ListBoxRDIIAreasClick(Sender: TObject);
    procedure ListBoxRTKPatternsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnAddLinkClick(Sender: TObject);
    procedure btnEditSewerShedClick(Sender: TObject);
    procedure btnEditRDIIAreaClick(Sender: TObject);
    procedure btnEditRTKPatternClick(Sender: TObject);
    procedure CheckBoxSelectAllRDIIAreasClick(Sender: TObject);
    procedure btnDeleteLinkClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckBoxFromAnalysesClick(Sender: TObject);
    procedure CheckBoxIgnoreRDIIAreasClick(Sender: TObject);
    procedure StringGridRTKLinkClick(Sender: TObject);
    procedure ListBoxSewerShedsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CheckBox1Click(Sender: TObject);
    procedure StringGridRTKPatternsClick(Sender: TObject);
  private
    FScenarioName: string;
    FScenarioID: integer;
    function LastPos(substr, s: string): integer;
    function GetRTKPatternNameFromDisplayName(sDisplayName: string): string;
    procedure FillSewerShedList;
    procedure FillRDIIAreaList(iSewerShedID: integer);
    procedure FillRTKPatternList;
    procedure FillRTKLinksList(iSceneID: integer);
    procedure SetScenarioName(const Value: string);
    procedure SetScenarioID(const Value: integer);
    procedure LocateRecordinLinksGrid(sName: string);
    procedure ClearGridSelection;
    function RecordIsInLinksGrid(sName: string): boolean;
    { Private declarations }
  public
    { Public declarations }
    property ScenarioID: integer read FScenarioID write SetScenarioID;
    property ScenarioName: string read FScenarioName write SetScenarioName;
  end;

var
  frmRTKPatternAssignment: TfrmRTKPatternAssignment;

implementation
uses modDatabase, editsewershed, editcatchment, RTKPatternEditor, mainform;

{$R *.dfm}

procedure TfrmRTKPatternAssignment.btnAddLinkClick(Sender: TObject);
var i, iSewerShedID, iRDIIAreaID, iRTKPatternID, iRainGaugeID,
  existingRTKLinkID: integer;
sDescription: string;
boOK : boolean;
begin
//get selected SewerShedName / ID OR RDIIAreaName / ID
//AND selected RTKPatternName / ID
//
//What about a sewershed that already has a linkage for this scenario??
//Must maintain database integrity - only one linkage per sewershed/scenario combination
  iSewerShedID := -1;
  iRDIIAreaID := -1;
  iRTKPatternID := -1;
  iRainGaugeID := -1;
  sDescription := '';
  existingRTKLinkID := -1;
  boOK := true;

  if ListBoxSewerSheds.Itemindex > -1 then begin
    iSewerShedID := DatabaseModule.GetSewerShedIDForName(
      ListBoxSewerSheds.Items[ListBoxSewerSheds.Itemindex]);
    existingRTKLinkID :=
      DatabaseModule.GetRTKLinkIDForSewerShedIDAndScenarioID(
        iSewerShedID,FScenarioID);
  end;

//  if length(lblSelectedPattern.Caption) > 0 then begin
  if lblSelectedPattern.Tag > 0 then begin //there is a selected RTKPattern
//rm 2010-09-29 TODO: factor month in
    iRTKPatternID :=
//      DatabaseModule.GetRTKPAtternIDforName(lblSelectedPattern.Caption);
      DatabaseModule.GetRTKPAtternIDforNameAndMonth(lblSelectedPattern.Caption, 0); //rm 0 - is a placeholder
    if (iRTKPatternID > -1) then begin //the selected RTKPattern is in db
      if ListBoxRDIIAreas.SelCount > 0 then begin //linking to RDIIArea(s)
        //rm 2007-12-06 - if sewershed is linked to an RTKPattern
        //remove that link or you will have both sewershed and rdiiareas
        //in scenario
        boOK := true;
        if (existingRTKLinkID > -1) then begin
          boOK := (MessageDlg('The parent sewershed is in this Scenario.' +
          ' Do you want to replace this sewershed with the selected RDII Areas?',
          mtConfirmation,[mbYes, mbNo],0) = mrYes);
          if boOK then begin
            DatabaseModule.RemoveRTKLink(existingRTKLinkID);
            FillRTKLinksList(FScenarioID);
          end;
        end;
        if boOK then begin
          for i := 0 to ListBoxRDIIAreas.Count - 1 do begin
            if ListBoxRDIIAreas.Selected[i] then begin
              iRDIIAreaID := DatabaseModule.GetRDIIAreaIDForName(
                ListBoxRDIIAreas.Items[i]);
              if (iRDIIAreaID > -1) then begin
                //rm 2007-11-26 - set sewershedID = -1 if RDIIAreaID > 0
                //DataBaseModule.AddRTKLink(FScenarioID, iSewerShedID, iRDIIAreaID, iRTKPatternID, iRainGaugeID, sDescription);
                DataBaseModule.AddRTKLink(FScenarioID, -1, iRDIIAreaID, iRTKPatternID, iRainGaugeID, sDescription);
                //FillRTKLinksList(FScenarioID);
                //ListBoxRDIIAreasClick(Sender);
              end;
            end;
          end;
          FillRTKLinksList(FScenarioID);
          ListBoxRDIIAreasClick(Sender);
        end;
{}
      end else if ListBoxRDIIAreas.Itemindex > -1 then begin  //just one selected
        iRDIIAreaID := DatabaseModule.GetRDIIAreaIDForName(
          ListBoxRDIIAreas.Items[ListBoxRDIIAreas.Itemindex]);
        if (iRDIIAreaID > -1) then begin
          boOK := true;
          if (existingRTKLinkID > -1) then begin
            boOK := (MessageDlg('The parent sewershed is in this Scenario.' +
            ' Do you want to replace this sewershed with the selected RDII Area?',
            mtConfirmation,[mbYes, mbNo],0) = mrYes);
            if boOK then begin
              DatabaseModule.RemoveRTKLink(existingRTKLinkID);
              FillRTKLinksList(FScenarioID);
            end;
          end;
          if boOK then begin
            //rm 2007-11-26 - set sewershedID = -1 if RDIIAreaID > 0
            //DataBaseModule.AddRTKLink(FScenarioID, iSewerShedID, iRDIIAreaID, iRTKPatternID, iRainGaugeID, sDescription);
            DataBaseModule.AddRTKLink(FScenarioID, -1, iRDIIAreaID, iRTKPatternID, iRainGaugeID, sDescription);
            FillRTKLinksList(FScenarioID);
            ListBoxRDIIAreasClick(Sender);
          end;
        end;
{}
      end else if ListBoxSewerSheds.SelCount > 0 then begin //several selected
        iRDIIAreaID := -1;
        for i := 0 to ListBoxSewerSheds.Count - 1 do begin
          if ListBoxSewerSheds.Selected[i] then begin
            iSewerShedID := DatabaseModule.GetSewerShedIDForName(
              ListBoxSewerSheds.Items[i]);
            if (iSewerShedID > -1) then begin
              DataBaseModule.AddRTKLink(FScenarioID, iSewerShedID, iRDIIAreaID, iRTKPatternID, iRainGaugeID, sDescription);
            end;
          end;
        end;
        FillRTKLinksList(FScenarioID);
        ListBoxSewerShedsClick(Sender);
{}
      end else if ListBoxSewerSheds.Itemindex > -1 then begin //just one selected
        iRDIIAreaID := -1;
        iSewerShedID := DatabaseModule.GetSewerShedIDForName(
          ListBoxSewerSheds.Items[ListBoxSewerSheds.Itemindex]);
        if (iSewerShedID > -1) then begin
          boOK := true;
          //any child rdii areas with an RTKLink for this scenario
          //must be removed.
          if ListBoxRDIIAreas.Count > 0 then begin
            for i := 0 to ListBoxRDIIAreas.Count - 1 do begin
              if boOK then begin
                iRDIIAreaID := DatabaseModule.GetRDIIAreaIDForName(
                  ListBoxRDIIAreas.Items[i]);
                existingRTKLinkID := DatabaseModule.GetRTKLinkIDForRDIIAreaIDAndScenarioID(
                  iRDIIAreaID,FScenarioID);
                boOK := (existingRTKLinkID < 0);
              end;
            end;
          end;
          if not boOK then begin //we have child rdii area with rtklink
            boOK := (MessageDlg('This Sewershed has child RDII Area(s) in this Scenario.' +
            ' Do you want to replace the RDII Area(s) with this Sewershed?',
            mtConfirmation,[mbYes, mbNo],0) = mrYes);
            if boOK then begin
              for i := 0 to ListBoxRDIIAreas.Count - 1 do begin
                iRDIIAreaID := DatabaseModule.GetRDIIAreaIDForName(
                  ListBoxRDIIAreas.Items[i]);
                existingRTKLinkID := DatabaseModule.GetRTKLinkIDForRDIIAreaIDAndScenarioID(
                  iRDIIAreaID,FScenarioID);
                if existingRTKLinkID > -1 then
                  DatabaseModule.RemoveRTKLink(existingRTKLinkID);
              end;
              FillRTKLinksList(FScenarioID);
            end;
          end;
          if boOK then begin
            DataBaseModule.AddRTKLink(FScenarioID, iSewerShedID, -1, iRTKPatternID, iRainGaugeID, sDescription);
            FillRTKLinksList(FScenarioID);
            ListBoxSewerShedsClick(Sender);
          end;
        end;
{}
      end;
    end;
    ListBoxSewerSheds.Repaint;
    ListBoxRDIIAreas.Repaint;
  end;
  {
  if length(lblSelectedRDIIArea.caption) > 0 then begin
    iRDIIAreaID := DatabaseModule.GetRDIIAreaIDForName(lblSelectedRDIIARea.Caption);
  end else if length(lblSelectedSewerShed.Caption) > 0 then begin
    iSewerShedID := DatabaseModule.GetSewershedIDForName(lblSelectedSewerShed.Caption);
  end;
  if (iSewerShedID > -1) or (iRDIIAreaID > -1) then begin
    if length(lblSelectedPattern.Caption) > 0 then begin
      iRTKPatternID :=
        DatabaseModule.GetRTKPAtternIDforName(lblSelectedPattern.Caption);
      if (iRTKPatternID > -1) then begin
        DataBaseModule.AddRTKLink(FScenarioID, iSewerShedID, iRDIIAreaID, iRTKPatternID, iRainGaugeID, sDescription);
      end;
    end;
  end;
  }
end;

procedure TfrmRTKPatternAssignment.btnDeleteLinkClick(Sender: TObject);
var iRTKLinkID: integer;
    RDIIAreaName, RTKPatternName: string;
    SelRect : TGridRect;
    i, icount : integer;
begin
//delete the link(s) selected in the StringGrid
  SelRect := StringGridRTKLink.Selection;
  if SelRect.Top > 0 then begin
    i := SelRect.Top;
    icount := SelRect.Bottom - SelRect.Top + 1;
    if icount = 1 then begin
      RDIIAreaName :=
        StringGridRTKLink.Cells[1,i];
      RTKPatternName :=
        GetRTKPatternNameFromDisplayName(
          StringGridRTKLink.Cells[2,i]);
      iRTKLinkID := strtoInt(StringGridRTKLink.Cells[3,i]);
      if (MessageDlg('Area you sure you want to delete the RTKLink ' +
        RDIIAreaName + ' to ' + RTKPatternName,
        mtConfirmation,[mbYes,mbNo],0) = mrYes)
      then begin
        DatabaseModule.RemoveRTKLink(iRTKLinkID);
        FillRTKLinksList(FScenarioID);
      end;
    end else if icount > 1 then begin
      if (MessageDlg('Area you sure you want to delete the selected RTKLinks?',
        mtConfirmation,[mbYes,mbNo],0) = mrYes)
      then begin
        while i <= SelRect.Bottom do begin
          iRTKLinkID := strtoInt(StringGridRTKLink.Cells[3,i]);
          DatabaseModule.RemoveRTKLink(iRTKLinkID);
          inc(i);
        end;
        FillRTKLinksList(FScenarioID);
      end;
    end;
    ListBoxSewerSheds.Repaint;
    ListBoxRDIIAreas.Repaint;
  end;
(*
//delete the link selected in the StringGrid
  if StringGrid1.Row > 0 then begin
    //showmessage('Deleting RTKLink on Row ' + inttostr(StringGrid1.Row));
    RDIIAreaName :=
      StringGrid1.Cells[1,StringGrid1.Row];
    RTKPatternName :=
      GetRTKPatternNameFromDisplayName(
        StringGrid1.Cells[2,StringGrid1.Row]);
{
    iRTKLinkID := DatabaseModule.GetRTKLinkID4ScenarioAreaPattern(
      ScenarioID, RDIIAreaName, RTKPatternName);
    //iRTKLinkID := strtoint(RTKLinkIDList[StringGrid1.Row - 1]);
}
    iRTKLinkID := strtoInt(StringGrid1.Cells[3,StringGrid1.Row]);
    if (MessageDlg('Area you sure you want to delete the RTKLink ' +
    inttostr(iRTKLinkID) + ', ' + RDIIAreaName + ', ' + RTKPatternName,
    mtConfirmation,[mbYes,mbNo],0) = mrYes) then begin
      DatabaseModule.RemoveRTKLink(iRTKLinkID);
      FillRTKLinksList(FScenarioID);
    end;
  end;
*)
end;

procedure TfrmRTKPatternAssignment.btnEditRDIIAreaClick(Sender: TObject);
var sRDIIAreaName: string;
    iRDIIAreaID: integer;
begin
//Edit Selected RDIIArea
  if ListBoxRDIIAreas.ItemIndex > -1 then begin
    sRDIIAreaName := ListBoxRDIIAreas.Items[ListBoxRDIIAreas.ItemIndex];
    iRDIIAreaID := DatabaseModule.GetRDIIAreaIDForName(sRDIIAreaName);
    frmEditCatchment.RDIIAreaName := sRDIIAreaName;
    frmEditCatchment.boAddingNew := false;
    frmEditCatchment.ShowModal;
  end;
end;

procedure TfrmRTKPatternAssignment.btnEditRTKPatternClick(Sender: TObject);
var rtkPatternLongName, rtkPatternName, newrtkPatternName: string;
    idx1, irow, itoprow: integer;
    SelRect: TGridRect;
begin
//Edit Selected RTKPattern
  //if ListBoxRTKPatterns.ItemIndex > -1 then begin
  idx1 := -1;
  if StringGridRTKPatterns.Row > 0 then begin
    //rtkPatternLongName := ListBoxRTKPatterns.Items[ListBoxRTKPatterns.ItemIndex];
    //rtkPatternName := GetRTKPatternNameFromDisplayName(rtkPatternLongName);
    rtkPatternName := StringGridRTKPatterns.Cells[0,StringGridRTKPAtterns.Row];
    frmRTKPatternEditor.AddingNewRecord := false;
    frmRTKpatternEditor.RTKPatternName := rtkPatternName;
    //idx1 := ListBoxRTKPatterns.ItemIndex;
    idx1 := StringGridRTKPAtterns.Row;
    irow := StringGridRTKLink.Row;
    itoprow := StringGridRTKLink.TopRow;
    SelRect := StringGridRTKLink.Selection;

    //frmRTKpatternEditor.RainGaugeName := sRaingaugeName;
    frmRTKPatternEditor.ShowModal;
//    newRTKPatternName := frmRTKPatternEditor.RTKPatternNameEdit.text;
    FillRTKPatternList;
    //if idx1 > -1 then ListBoxRTKPatterns.ItemIndex := idx1;
    if idx1 > -1 then StringGridRTKPatterns.Row := idx1;
    FillRTKLinksList(FScenarioID);
    if irow > -1 then begin
      SelRect.Top := irow;
      SelRect.Bottom := irow;
      SelRect.Left := 1;
      SelRect.Right := StringGridRTKLink.ColCount - 1;
      StringGridRTKLink.Selection := SelRect;
      StringGridRTKLink.TopRow := itoprow;
    end;
  end;
end;

procedure TfrmRTKPatternAssignment.btnEditSewerShedClick(Sender: TObject);
var sSewerShedName: string;
    iSewerShedID: integer;
begin
//edit selected SewerShed
  if ListBoxSewerSheds.ItemIndex > -1 then begin
    sSewerShedName := ListBoxSewerSheds.Items[ListBoxSewerSheds.ItemIndex];
    iSewerShedID := DatabaseModule.GetSewershedIDForName(sSewerShedName);
    frmEditSewershed.sewershedName := sSewerShedName;
    frmEditSewershed.boAddingNew := false;
    frmEditSewershed.ShowModal;
  end;
end;

procedure TfrmRTKPatternAssignment.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRTKPatternAssignment.CheckBoxIgnoreRDIIAreasClick(Sender: TObject);
var i: integer;
begin
  if CheckBoxIgnoreRDIIAreas.Checked then begin
    CheckBoxSelectAllRDIIAreas.checked := false;
    ListBoxRDIIAreas.ClearSelection;
    ListBoxRDIIAreas.Enabled := false;
    ListBoxSewerShedsClick(Sender);
  end else begin
    //i := ListBoxRTKPatterns.ItemIndex;
    i := StringGridRTKPatterns.Row;
    ListBoxRDIIAreas.Enabled := true;
    if ListBoxRDIIAreas.Count > 0 then
      ListBoxRDIIAreas.ItemIndex := 0;
    ListBoxRDIIAreasClick(Sender);
    if i > -1 then begin
      //ListBoxRTKPatterns.ItemIndex := i;
      //ListBoxRTKPatternsClick(ListBoxRTKPatterns);
      StringGridRTKPatterns.Row := i;
      StringGridRTKPatternsClick(StringGridRTKPatterns);
    end;
  end;
end;

procedure TfrmRTKPatternAssignment.CheckBox1Click(Sender: TObject);
begin
  LabelRDIIAreas.Visible := CheckBox1.Checked;
  CheckBoxSelectAllRDIIAreas.Visible := CheckBox1.Checked;
  CheckBoxIgnoreRDIIAreas.Visible := CheckBox1.Checked;
  ListBoxRDIIAreas.Visible := CheckBox1.Checked;
  //lblSelectedRDIIArea.Visible := CheckBox1.Checked;
  LabelExplanation.Visible := not CheckBox1.Checked;
  if not (CheckBox1.Checked) then begin
    CheckBoxSelectAllRDIIAreas.Checked := false;
    CheckBoxIgnoreRDIIAreas.Checked := true;
  end;
end;

procedure TfrmRTKPatternAssignment.CheckBoxFromAnalysesClick(Sender: TObject);
begin
  FillRTKPatternList;
end;

procedure TfrmRTKPatternAssignment.CheckBoxSelectAllRDIIAreasClick(
  Sender: TObject);
begin
  if CheckBoxSelectAllRDIIAreas.checked then begin
    CheckBoxIgnoreRDIIAreas.Checked := false;
    ListBoxRDIIAreas.MultiSelect := true;
    ListBoxRDIIAreas.SelectAll;
  end else begin
    ListBoxRDIIAreas.MultiSelect := false;
  end;
end;

procedure TfrmRTKPatternAssignment.ClearGridSelection;
var SelRect : TGridRect;
begin
  SelRect.Top := -1;
  SelRect.Left := -1;
  SelRect.Right := -1;
  SelRect.Bottom := -1;
  StringGridRTKLink.Selection := SelRect;
  btnDeleteLink.Enabled := false;
end;

procedure TfrmRTKPatternAssignment.FillRDIIAreaList(iSewerShedID: integer);
begin
  ListBoxRDIIAreas.Items := DatabaseModule.GetRDIIAreaNamesforSewershedID(iSewerShedID);
  if CheckBoxSelectAllRDIIAreas.checked then
    ListBoxRDIIAreas.SelectAll;
end;

procedure TfrmRTKPatternAssignment.FillRTKLinksList(iSceneID: integer);
var i:integer;
    inStringGrid: TStringGrid;
begin
  StringGridRTKLink.RowCount := 2;
  StringGridRTKLink.Rows[1].Clear;
  DatabaseModule.GetRTKLinkGrid(iSceneID, inStringGrid);
//rm 2008-11-12 - add column header to first column and revise second column header
  StringGridRTKLink.Cells[0,0] := 'Sewershed/RDIIArea';
  StringGridRTKLink.ColWidths[0] := 110;
//  StringGridRTKLink.Cells[1,0] := 'Sewershed/RDIIArea';
  StringGridRTKLink.Cells[1,0] := 'Load Point';
  StringGridRTKLink.ColWidths[1] := 140;
  StringGridRTKLink.Cells[2,0] := 'RTKPattern Name';
  StringGridRTKLink.RowCount := Max(inStringGrid.RowCount-1,2);
  for i := 1 to inStringGrid.RowCount - 1 do begin
    //rm 2008-11-12
    if (inStringGrid.Cells[0,i] = 'R') then
      StringGridRTKLink.Cells[0,i] := 'RDII Area'
    else
      StringGridRTKLink.Cells[0,i] := 'Sewershed';
//    StringGridRTKLink.Cells[0,i] := inStringGrid.Cells[0,i];
    //rm 2007-10-08
    StringGridRTKLink.Cells[1,i] := inStringGrid.Cells[1,i];
    StringGridRTKLink.Cells[2,i] := inStringGrid.Cells[2,i];
    StringGridRTKLink.Cells[3,i] := inStringGrid.Cells[3,i];
  end;
  ClearGridSelection;
end;

procedure TfrmRTKPatternAssignment.FillRTKPatternList;
var i,j: integer;
    tempStringList: TStringList;
    TokList: TStringList;
    NToks: integer;
begin
  //rm 2009-07-20 - uning StringGrid instead of ListBoxRTKPatterns
(*
  ListBoxRTKPatterns.Clear;
  if CheckBoxFromAnalyses.Checked then begin
    tempStringList := TStringList.Create;
    tempStringList := DatabaseModule.GetRTKPatternNamesFromEvents;
    for i := 0 to tempStringList.Count - 1 do
      ListBoxRTKPatterns.Items.Add(tempStringList[i]);
    tempStringList.free;
    if (Length(lblSelectedSewerShed.Caption) > 0) then
      ListBoxRTKPatterns.Items := DatabaseModule.GetRTKPatternNames4SewerShed(lblSelectedSewerShed.Caption)
    else
      ListBoxRTKPatterns.Items := DatabaseModule.GetRTKPatternNames4Analyses;
  end else begin
    ListBoxRTKPatterns.Items := DatabaseModule.GetRTKPatternNames;
  end;
*)

  tempStringList := TStringList.Create;
  TokList := TStringList.Create;
  if CheckBoxFromAnalyses.Checked then begin
    //tempStringList := DatabaseModule.GetRTKPatternNamesFromEvents;
    if (Length(lblSelectedSewerShed.Caption) > 0) then
      tempStringList := DatabaseModule.GetRTKPatternNames4SewerShed(lblSelectedSewerShed.Caption)
    else
      tempStringList := DatabaseModule.GetRTKPatternNames4Analyses;
  end else begin
    tempStringList := DatabaseModule.GetRTKPatternNames;
  end;
  StringGridRTKPatterns.RowCount := 2;
  StringGridRTKPatterns.Rows[1].Clear;
  StringGridRTKPatterns.Cells[0,0] := 'RTKPattern Name';
  StringGridRTKPatterns.Cells[1,0] := 'R1';
  StringGridRTKPatterns.Cells[2,0] := 'T1';
  StringGridRTKPatterns.Cells[3,0] := 'K1';
  StringGridRTKPatterns.Cells[4,0] := 'R2';
  StringGridRTKPatterns.Cells[5,0] := 'T2';
  StringGridRTKPatterns.Cells[6,0] := 'K2';
  StringGridRTKPatterns.Cells[7,0] := 'R3';
  StringGridRTKPatterns.Cells[8,0] := 'T3';
  StringGridRTKPatterns.Cells[9,0] := 'K3';
  for i := 0 to tempStringList.Count - 1 do begin
    //Tokenize(tempStringList[i], TokList, NToks);
    TokList.CommaText := tempStringList[i];
    NToks := TokList.Count;
    StringGridRTKPatterns.RowCount := 2 + i;
    for j := 0 to NToks - 1 do
      if (Length(TokList[j]) > 0) then
        if ((RightStr(TokList[j],1) = ':') or (RightStr(TokList[j],1) = ';')) then
          StringGridRTKPatterns.Cells[j, i+1] :=
            LeftStr(TokList[j],Length(TokList[j])-1)
        else
          StringGridRTKPatterns.Cells[j, i+1] := TokList[j]
      else
        StringGridRTKPatterns.Cells[j, i+1] := TokList[j];
  end;
  tempStringList.free;
end;

procedure TfrmRTKPatternAssignment.FillSewerShedList;
begin
  ListBoxSewerSheds.Items := DatabaseModule.GetSewerShedNames;
end;

procedure TfrmRTKPatternAssignment.FormCreate(Sender: TObject);
begin
  FScenarioID := -1;
  FScenarioName := '';
  //RTKLinkIDList := TStringList.Create;
end;

procedure TfrmRTKPatternAssignment.FormDestroy(Sender: TObject);
begin
  //RTKLinkIDList.Free;
end;

procedure TfrmRTKPatternAssignment.FormResize(Sender: TObject);
begin
{
  StringGrid1.Height := ClientHeight - StringGrid1.Top - 38;
  okButton.Top := ClientHeight - okButton.Height - 8;
  cancelButton.Top := okButton.Top;
  helpButton.Top := okButton.Top;
  }
end;

procedure TfrmRTKPatternAssignment.FormShow(Sender: TObject);
begin
  ListBoxSewerSheds.Clear;
  ListBoxRDIIAreas.Clear;
  //ListBoxRTKPatterns.Clear;
  StringGridRTKPAtterns.RowCount := 2;
  StringGridRTKPAtterns.Rows[1].Clear;
  lblSelectedSewerShed.Caption := '';
  lblSelectedRDIIArea.Caption := '';
  lblSelectedPattern.Caption := '';
  lblSelectedPattern.Tag := 0;
  FillSewerShedList;
  //FillRDIIAreaList;
  FillRTKPatternList;
  if FScenarioID > -1 then begin
    FillRTKLinksList(FScenarioID);
  end;
end;

function TfrmRTKPatternAssignment.LastPos(substr, s: string): integer;
begin
  Result := Pos(ReverseString(substr), ReverseString(s));
  if (Result <> 0) then begin
    Result := ((Length(s) - Length(substr)) + 1) - Result + 1;
  end;
end;

function TfrmRTKPatternAssignment.GetRTKPatternNameFromDisplayName(
  sDisplayName: string): string;
var s: string; i: integer;
begin
  s := sDisplayName;
  if length(s) > 0 then begin
    i := LastPos(':',s);
    if i > 0 then
      s := Copy(s,1,i-1);
  end;
  Result := s;
end;

procedure TfrmRTKPatternAssignment.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmRTKPatternAssignment.ListBoxSewerShedsClick(Sender: TObject);
var i, iSewerShedID, iRTKPatternID: integer;
    sRTKPatternName: string;
begin
  if ListBoxSewerSheds.ItemIndex > -1 then begin
    lblSelectedSewerShed.Caption := ListBoxSewerSheds.Items[ListBoxSewerSheds.ItemIndex];
    if CheckBoxFromAnalyses.Checked then begin
      FillRTKPatternList;
    end;
    //ListBox1.Ad
    //i := int(ListBox1.
    iSewerShedID := DatabaseModule.GetSewershedIDForName(lblSelectedSewerShed.Caption);
    lblSelectedRDIIArea.Caption := '';
    FillRDIIAreaList(iSewerShedID);
    ClearGridSelection;

    //highlight RTKPattern linked to - if any
    iRTKPatternID := DatabaseModule.GetRTKPatternIDForSewerShedIDAndScenarioID(iSewerShedID, FScenarioID);
    //if there is one, set CheckBoxIgnoreRDIIAreas.Checked
    if iRTKPatternID > 0 then begin
      if ListBoxRDIIAreas.Items.Count > 0 then
        CheckBoxIgnoreRDIIAreas.Checked := true;
      sRTKPatternName := DatabaseModule.GetRTKPatternNameForID(iRTKPatternID);
      if Length(sRTKPatternName) > 0 then begin
        //if ListBoxRTKPatterns.Items.Count > 0 then begin
        if StringGridRTKPatterns.RowCount > 2 then begin
          i := 0;
          repeat
            //if (UpperCase(GetRTKPatternNameFromDisplayName(ListBoxRTKPatterns.Items[i])) = UpperCase(sRTKPAtternName)) then begin
            if (UpperCase(StringGridRTKPatterns.Cells[0,i+1]) = UpperCase(sRTKPAtternName)) then begin
              //ListBoxRTKPatterns.ItemIndex := i;
              //ListBoxRTKPatternsClick(Sender);
              StringGridRTKPatterns.Row := i + 1;
              StringGridRTKPatternsClick(Sender);
            end;
            inc(i);
          //until i = ListBoxRTKPatterns.Items.Count;
          until i = StringGridRTKPatterns.RowCount - 2;
        end;
      end;
      LocateRecordinLinksGrid(lblSelectedSewerShed.Caption);
    end else if (ListBoxRDIIAreas.Items.Count > 0) then begin
      if not (CheckBoxIgnoreRDIIAreas.Checked) then begin
        ListBoxRDIIAreas.ItemIndex := 0;
        ListBoxRDIIAreasClick(Sender);
      end;
    end;
  end else begin
    lblSelectedSewerShed.Caption := '';
  end;
end;

procedure TfrmRTKPatternAssignment.ListBoxSewerShedsDrawItem(
  Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var oldColor: TColor;
begin
  with (Control as TListBox) do
  begin
    oldColor := Canvas.Font.Color;
    if not Enabled then begin
      Canvas.Font.Style := Font.Style - [fsbold];
      Canvas.Font.Color := clGrayText;
    end else if RecordIsInLinksGrid(Items[Index]) then begin
      Canvas.Font.Style := Font.Style - [fsbold];
    end else begin
      Canvas.Font.Style := Font.Style + [fsBold];
    end;
    Canvas.FillRect(Rect);
    Canvas.TextOut(Rect.Left, Rect.Top, Items[Index]) ;
    Canvas.Font.Color := oldColor;
  end;
end;

procedure TfrmRTKPatternAssignment.LocateRecordinLinksGrid(sName: string);
var i : integer;
  SelRect: TGridRect;
begin
  ClearGridSelection;
  if StringGridRTKLink.RowCount > 1 then begin
    i := 0;
    while (i < StringGridRTKLink.RowCount) and (StringGridRTKLink.Cells[1,i] <> sName) do
      inc(i);
    if i < StringGridRTKLink.RowCount then begin
      SelRect.Top := i;
      SelRect.Bottom := i;
      SelRect.Left := 1;
      SelRect.Right := StringGridRTKLink.ColCount - 1;
      StringGridRTKLink.Selection := SelRect;
      btnAddLink.Enabled := false;
      btnDeleteLink.Enabled := true;
      if i < StringGridRTKLink.TopRow  then
        StringGridRTKLink.TopRow := i;
      if i > StringGridRTKLink.TopRow + StringGridRTKLink.VisibleRowCount -1 then
        StringGridRTKLink.TopRow := i - StringGridRTKLink.VisibleRowCount +1;
    end;
  end;
end;

procedure TfrmRTKPatternAssignment.ListBoxRDIIAreasClick(Sender: TObject);
var i, iRDIIAreaID, iRTKPatternID: integer;
    sRTKPatternName: string;
begin
  if ListBoxRDIIAreas.ItemIndex > -1 then begin
    lblSelectedRDIIArea.Caption := ListBoxRDIIAreas.Items[ListBoxRDIIAreas.ItemIndex];
    lblSelectedSewerShed.Caption := '';
    iRDIIAreaID := DatabaseModule.GetRDIIAreaIDForName(lblSelectedRDIIArea.Caption);
    //highlight RTKPattern linked to - if any
    iRTKPatternID := DatabaseModule.GetRTKPatternIDForRDIIAreaIDAndScenarioID(iRDIIAreaID, FScenarioID);
    //ListBoxRTKPatterns.ItemIndex := -1;
    //ListBoxRTKPatternsClick(Sender);
    StringGridRTKPatterns.Row := 0;
    StringGridRTKPatternsClick(Sender);
    if (iRTKPatternID > -1) then begin
      sRTKPatternName := DatabaseModule.GetRTKPatternNameForID(iRTKPatternID);
      if Length(sRTKPatternName) > 0 then begin
        i := 0;
        repeat
          //if (UpperCase(GetRTKPatternNameFromDisplayName(ListBoxRTKPatterns.Items[i])) = UpperCase(sRTKPAtternName)) then begin
          //  ListBoxRTKPatterns.ItemIndex := i;
          //  ListBoxRTKPatternsClick(Sender);
          if (UpperCase(StringGridRTKPatterns.Cells[0,i+1]) = UpperCase(sRTKPAtternName)) then begin
            StringGridRTKPatterns.Row := i + 1;
            StringGridRTKPatternsClick(Sender);
          end;
          inc(i);
        //until i = ListBoxRTKPatterns.Items.Count;
        until i = StringGridRTKPatterns.RowCount - 1;
      end;
      LocateRecordinLinksGrid(lblSelectedRDIIArea.Caption);
    end;
  end else begin
    lblSelectedRDIIArea.Caption := '';
  end;
end;

procedure TfrmRTKPatternAssignment.ListBoxRTKPatternsClick(Sender: TObject);
begin
(*
  if ListBoxRTKPatterns.ItemIndex > -1 then begin
    //lblSelectedPattern.Caption := ListBox3.Items[ListBox3.ItemIndex];
    lblSelectedPattern.Caption :=
      GetRTKPatternNameFromDisplayName(ListBoxRTKPatterns.Items[ListBoxRTKPatterns.ItemIndex]);
    lblSelectedPatternLongName.Caption :=
      ListBoxRTKPatterns.Items[ListBoxRTKPatterns.ItemIndex];
    lblSelectedPattern.Tag := 1;
    btnAddLink.Enabled := true;
  end else begin
    lblSelectedPattern.Caption := 'No Pattern Selected.';
    lblSelectedPatternLongName.Caption := '';
    lblSelectedPattern.Tag := 0;
    ClearGridSelection;
    btnAddLink.Enabled := false;
  end;
*)
end;

procedure TfrmRTKPatternAssignment.okButtonClick(Sender: TObject);
begin
  Close;
end;

function TfrmRTKPatternAssignment.RecordIsInLinksGrid(sName: string): boolean;
var i : integer;
  boResult: boolean;
begin
  boResult := false;
  if StringGridRTKLink.RowCount > 1 then begin
    i := 0;
    while (i < StringGridRTKLink.RowCount) and (StringGridRTKLink.Cells[1,i] <> sName) do
      inc(i);
    if i < StringGridRTKLink.RowCount then begin
      boResult := true;
    end;
  end;
  Result := boResult;
end;

procedure TfrmRTKPatternAssignment.SetScenarioID(const Value: integer);
begin
  FScenarioID := Value;
  FScenarioName := DatabaseModule.GetScenarioNameforID(FScenarioID);
  lblScenarioID.Caption := 'Scenario: ' + FScenarioName;
  lblDescription.Caption := 'Description:' + DatabaseModule.GetScenarioDesciption(FScenarioName);
end;

procedure TfrmRTKPatternAssignment.SetScenarioName(const Value: string);
begin
  FScenarioName := Value;
  FScenarioID := DatabaseModule.GetScenarioIDForName(FScenarioName);
  lblScenarioID.Caption := 'Scenario: ' + FScenarioName;
  lblDescription.Caption := 'Description:' + DatabaseModule.GetScenarioDesciption(FScenarioName);
end;

procedure TfrmRTKPatternAssignment.StringGridRTKLinkClick(Sender: TObject);
begin
  btnDeleteLink.Enabled := true;
end;

procedure TfrmRTKPatternAssignment.StringGridRTKPatternsClick(Sender: TObject);
begin
//TODO
  if StringGridRTKPatterns.Row > 0 then begin
    //lblSelectedPattern.Caption := ListBox3.Items[ListBox3.ItemIndex];
    lblSelectedPattern.Caption :=
      //GetRTKPatternNameFromDisplayName(ListBoxRTKPatterns.Items[ListBoxRTKPatterns.ItemIndex]);
      StringGridRTKPAtterns.Cells[0,StringGridRTKPatterns.Row];
    //lblSelectedPatternLongName.Caption :=
      //ListBoxRTKPatterns.Items[ListBoxRTKPatterns.ItemIndex];
    lblSelectedPattern.Tag := 1;
    btnAddLink.Enabled := true;
  end else begin
    lblSelectedPattern.Caption := 'No Pattern Selected.';
    lblSelectedPatternLongName.Caption := '';
    lblSelectedPattern.Tag := 0;
    ClearGridSelection;
    btnAddLink.Enabled := false;
  end;
end;

end.
