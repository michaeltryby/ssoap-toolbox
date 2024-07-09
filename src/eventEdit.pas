unit eventEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Spin, StormEventCollection, StormEvent, RTKPatternFrame;

type
  TfrmEventEdit = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    EventSpinEdit: TSpinEdit;
    StartDatePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    EndDatePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    Label1: TLabel;
    Label3: TLabel;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    applyButton: TButton;
    AutoApplyCheckBox: TCheckBox;
    btnDefaults: TButton;
    edPatternName: TEdit;
    FrameRTKPattern1: TFrameRTKPattern;
    Label12: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    //procedure REditChange(Sender: TObject);
    procedure NonREditChange(Sender: TObject);
    procedure UpdateTotalR();
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure EventSpinEditChange(Sender: TObject);
    procedure applyButtonClick(Sender: TObject);
    procedure AutoApplyCheckBoxClick(Sender: TObject);
    procedure btnDefaultsClick(Sender: TObject);
    //procedure FrameRTKPattern1T1Edit2Change(Sender: TObject);
    //procedure FrameRTKPattern1K1Edit2Change(Sender: TObject);
    //procedure FrameRTKPattern1EditAIChange(Sender: TObject);
    //procedure FrameRTKPattern1R1Edit2Change(Sender: TObject);
    //procedure FrameRTKPattern1MemoDescriptionChange(Sender: TObject);
    procedure edPatternNameKeyPress(Sender: TObject; var Key: Char);
    procedure helpButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FrameRTKPattern1CheckBox1Click(Sender: TObject);
    procedure FrameRTKPattern1R1Edit2Change(Sender: TObject);
    procedure FrameRTKPattern1T1Edit2Change(Sender: TObject);
    procedure FrameRTKPattern1K1Edit2Change(Sender: TObject);
    procedure FrameRTKPattern1EditAMChange(Sender: TObject);
    procedure FrameRTKPattern1MemoDescriptionChange(Sender: TObject);
  private
    events: TStormEventCollection;
    eventNumber: integer;
    event: TStormEvent;
    //function GetDefaultRTKPatternName: string;
    HasNonRTKEdits: boolean;
    function HasEdits: boolean;
    procedure UpdateDataBasedOnSelectedEvent;
    procedure UpdateEventBasedOnRTKPatternFrame(RTKFrame:TFrameRTKPattern);
//rm 2009-06-08 - recast as function to capture error condition and not close form
//    procedure UpdateCurrentEvent;
    function UpdateCurrentEvent: boolean;
    procedure UpdateIIGraph();
  public
    analysisID: integer;
    rtkPatternID: integer;
    hitcount: integer; //debug - count number of db updates - autoupdate issue
    //hasedits: boolean;
    procedure OpenDialog(eventsIn: TStormEventCollection;
      eventNumberIn: integer; iAnalysisID:integer);
    procedure UpdateFromGraph();
  end;

var
  frmEventEdit: TfrmEventEdit;

implementation

uses iigraph, modDatabase, mainform, eventStatGetter;

{$R *.DFM}

function TfrmEventEdit.HasEdits: boolean;
begin
  Result := FrameRTKPattern1.HasEdits or HasNonRTKEdits;
end;


procedure TfrmEventEdit.okButtonClick(Sender: TObject);
begin
  if UpdateCurrentEvent then begin
    ModalResult := mrOK;
    Close;
  end;
end;

procedure TfrmEventEdit.cancelButtonClick(Sender: TObject);
begin
  if hasedits then begin
    if MessageDlg('Do you want to save changes to the current event?',
      mtConfirmation, [mbYes,mbNo],0 ) = mrYes then
        UpdateCurrentEvent;
  end;
  ModalResult := mrCancel;
  Close;
end;

procedure TfrmEventEdit.edPatternNameKeyPress(Sender: TObject; var Key: Char);
begin
  if key = ' '  then key := '_'
  else if key = '"' then key := '''';
  if key = #13 then key := #9;
  
end;
{
procedure TfrmEventEdit.REditChange(Sender: TObject);
begin
  //updateTotalR();
  //hasedits := true;
  //if (AutoApplyCheckBox.checked) then UpdateCurrentEvent;
end;
}
procedure TfrmEventEdit.NonREditChange(Sender: TObject);
begin
  HasNonRTKEdits := true;
  if (AutoApplyCheckBox.checked) then UpdateCurrentEvent;
end;

procedure TfrmEventEdit.updateTotalR();
var
  total: real;
begin
  //total := 0.0;
  //if (Length(EventR1Edit.Text) > 0) then total := total + strtofloat(EventR1Edit.Text);
  //if (Length(EventR2Edit.Text) > 0) then total := total + strtofloat(EventR2Edit.Text);
  //if (Length(EventR3Edit.Text) > 0) then total := total + strtofloat(EventR3Edit.Text);
  //EventTotalREdit.Text := floattostr(total);
end;

procedure TfrmEventEdit.FloatEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

procedure TfrmEventEdit.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//rm 2009-06-09 - Keep the Enter Key from closing the form
//user must click on Cancel or OK to close the form.
//  if (ModalResult = mrOK) then begin
//    showmessage('Closing');
//  end;
//  if (ModalResult <> mrOK) then begin
//    showmessage('Not Closing');
//    CanClose := false;
//  end;
end;

procedure TfrmEventEdit.FormCreate(Sender: TObject);
begin
  hitcount := 0;
  //hasedits := false;
  HasNonRTKEdits := false;
  FrameRTKPattern1.HasEdits := false;
  ModalREsult := mrNone;
end;

procedure TfrmEventEdit.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then begin
    //Key := #9;
    try
      //if () then begin
        //SelectNext(Sender as TWinControl, true, true);
      //end else begin
        //SelectNext(Sender as TWinControl, false, true);
      //end;
      Perform(WM_NextDlgCtl, 0, 0);
    finally
      Key := #0;
    end;
  end;
end;

procedure TfrmEventEdit.FormShow(Sender: TObject);
begin
try
  //if (Length(edPatternName.Text) < 1) then begin
  //  edPatternName.Text := GetDefaultRTKPatternName;
  //end;
finally

end;
  ModalResult := mrNone;
end;

procedure TfrmEventEdit.FrameRTKPattern1CheckBox1Click(Sender: TObject);
begin
  FrameRTKPattern1.CheckBox1Click(Sender);

end;
procedure TfrmEventEdit.FrameRTKPattern1EditAMChange(Sender: TObject);
begin
  FrameRTKPattern1.EditAIChange(Sender);
  if (AutoApplyCheckBox.checked) then UpdateCurrentEvent;
end;

procedure TfrmEventEdit.FrameRTKPattern1K1Edit2Change(Sender: TObject);
begin
  FrameRTKPattern1.K1Edit2Change(Sender);
  if (AutoApplyCheckBox.checked) then UpdateCurrentEvent;
end;

procedure TfrmEventEdit.FrameRTKPattern1MemoDescriptionChange(Sender: TObject);
begin
  FrameRTKPattern1.MemoDescriptionChange(Sender);
  if (AutoApplyCheckBox.checked) then UpdateCurrentEvent;
end;

procedure TfrmEventEdit.FrameRTKPattern1R1Edit2Change(Sender: TObject);
begin
  FrameRTKPattern1.R1Edit2Change(Sender);
  if (AutoApplyCheckBox.checked) then UpdateCurrentEvent;
end;

procedure TfrmEventEdit.FrameRTKPattern1T1Edit2Change(Sender: TObject);
begin
  FrameRTKPattern1.T1Edit2Change(Sender);
  if (AutoApplyCheckBox.checked) then UpdateCurrentEvent;
end;

{
procedure TfrmEventEdit.FrameRTKPattern1EditAIChange(Sender: TObject);
var s1, s2, s3: string;
begin
  FrameRTKPattern1.EditAIChange(Sender);
  //hasedits := true;
//  if (AutoApplyCheckBox.checked) then UpdateCurrentEvent;
  if (AutoApplyCheckBox.checked) then begin
    //trap error condition where last char is '.' decimal pt
    s1 := FrameRTKPattern1.EditAI.Text;
    s2 := FrameRTKPattern1.EditAM.Text;
    s3 := FrameRTKPattern1.EditAR.Text;
    if (Length(s1) > 0) and (Length(s2) > 0) and (Length(s3) > 0) then begin
      if (s1[Length(s1)] <> '.') and (s2[Length(s2)] <> '.') and (s3[Length(s3)] <> '.') then begin
        UpdateCurrentEvent;
      end;
    end;
  end;
end;

procedure TfrmEventEdit.FrameRTKPattern1K1Edit2Change(Sender: TObject);
var s1, s2, s3: string;
begin
  FrameRTKPattern1.K1Edit2Change(Sender);
  //hasedits := true;
//  if (AutoApplyCheckBox.checked) then UpdateCurrentEvent;
  if (AutoApplyCheckBox.checked) then begin
    //trap error condition where last char is '.' decimal pt
    s1 := FrameRTKPattern1.K1Edit2.Text;
    s2 := FrameRTKPattern1.K2Edit2.Text;
    s3 := FrameRTKPattern1.K3Edit2.Text;
    if (Length(s1) > 0) and (Length(s2) > 0) and (Length(s3) > 0) then begin
      if (s1[Length(s1)] <> '.') and (s2[Length(s2)] <> '.') and (s3[Length(s3)] <> '.') then begin
        UpdateCurrentEvent;
      end;
    end;
  end;
end;

procedure TfrmEventEdit.FrameRTKPattern1MemoDescriptionChange(Sender: TObject);
begin
  FrameRTKPattern1.MemoDescriptionChange(Sender);
  //hasedits := true;
  if (AutoApplyCheckBox.checked) then UpdateCurrentEvent;
end;

procedure TfrmEventEdit.FrameRTKPattern1R1Edit2Change(Sender: TObject);
var s1,s2,s3:string;
begin
  FrameRTKPattern1.R1Edit2Change(Sender);
  //hasedits := true;
  if (AutoApplyCheckBox.checked) then begin
    //trap error condition where last char is '.' decimal pt
    s1 := FrameRTKPattern1.R1Edit2.Text;
    s2 := FrameRTKPattern1.R2Edit2.Text;
    s3 := FrameRTKPattern1.R3Edit2.Text;
    if (Length(s1) > 0) and (Length(s2) > 0) and (Length(s3) > 0) then begin
      if (s1[Length(s1)] <> '.') and (s2[Length(s2)] <> '.') and (s3[Length(s3)] <> '.') then begin
        UpdateCurrentEvent;
      end;
    end;
  end;
end;

procedure TfrmEventEdit.FrameRTKPattern1T1Edit2Change(Sender: TObject);
var s1, s2, s3: string;
begin
  FrameRTKPattern1.T1Edit2Change(Sender);
  //hasedits := true;
  //if (AutoApplyCheckBox.checked) then UpdateCurrentEvent;
  if (AutoApplyCheckBox.checked) then begin
    //trap error condition where last char is '.' decimal pt
    s1 := FrameRTKPattern1.T1Edit2.Text;
    s2 := FrameRTKPattern1.T2Edit2.Text;
    s3 := FrameRTKPattern1.T3Edit2.Text;
    if (Length(s1) > 0) and (Length(s2) > 0) and (Length(s3) > 0) then begin
      if (s1[Length(s1)] <> '.') and (s2[Length(s2)] <> '.') and (s3[Length(s3)] <> '.') then begin
        UpdateCurrentEvent;
      end;
    end;
  end;
end;
}
{*
function TfrmEventEdit.GetDefaultRTKPatternName: string;
var
s, sResult: string;
idx: integer;
begin
  //rm 2008-10-13 - prevent spaces in rtkpattern names
  s := DatabaseModule.GetAnalysisNameForID(AnalysisID);
  s := stringreplace(s, ' ', '_', [rfReplaceAll, rfIgnoreCase]);
//  Result :=
//    DatabaseModule.GetAnalysisNameForID(AnalysisID) +
//      '_' + FormatDateTime('yyyy-mm-dd', event.StartDate);
  sResult := s + '_' + FormatDateTime('yyyy-mm-dd', event.StartDate);
  try
    //rm 2009-06-09 - check for existing RTK pattern of same name
    idx := DatabaseModule.GetRTKPAtternIDforName(sResult);
    if (idx > 0) then begin
      //you could have two events in one day -
      //tack on the military time hour of event -
      sResult := sResult + '_' + FormatDateTime('HH:MM', event.StartDate);
      //rm 2009-06-09 - check for existing RTK pattern of same name
      idx := DatabaseModule.GetRTKPAtternIDforName(sResult);
      if (idx > 0) then begin
        //you could have two events in one day -
        //tack on the minutes of event -
        sResult := sResult + ':' + FormatDateTime('ss', event.StartDate);
      end;
    end;
  finally

  end;
  Result := sResult;
end;
*}
procedure TfrmEventEdit.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEventEdit.EventSpinEditChange(Sender: TObject);
var bo: boolean;
  mr : Tmodalresult;
begin
  bo := FrameRTKPattern1.AutoApplyChanges; //AutoApplyCheckBox.Checked;
  try
    if (AutoApplyCheckBox.checked) then begin
      AutoApplyCheckBox.checked := false;
      FrameRTKPattern1.AutoApplyChanges := false;
      UpdateCurrentEvent;
    end else if hasedits then begin
      mr := MessageDlg('Do you want to save changes to the current event?',
      mtConfirmation, [mbYes,mbNo],0 );
      if mr = mrYes then UpdateCurrentEvent;
    end;
    FrameRTKPattern1.SuspendUpdates := true;
  //rm 2010-10-19 - check for number out of bounds
  if (eventSpinEdit.Value <= events.Count) then begin

    event := events[eventSpinEdit.Value - 1];
    UpdateDataBasedOnSelectedEvent;
  //rm 2010-10-19
  frmIIGraph.GotoEventNum(eventSpinEdit.Value - 1);
  end;
    //hasedits := false;
    HasNonRTKEdits := false;
    FrameRTKPattern1.HasEdits := false;
  finally
    AutoApplyCheckBox.checked := bo;
    FrameRTKPattern1.AutoApplyChanges := bo;
    FrameRTKPattern1.SuspendUpdates := false;
  end;
end;

procedure TfrmEventEdit.UpdateEventBasedOnRTKPatternFrame(
  RTKFrame: TFrameRTKPattern);
begin
//rm 2010-09-29 - rejigged for new initial abstraction terms
    event.R[0] := RTKFrame.R1;
    event.R[1] := RTKFrame.R2;
    event.R[2] := RTKFrame.R3;
    event.T[0] := RTKFrame.T1;
    event.T[1] := RTKFrame.T2;
    event.T[2] := RTKFrame.T3;
    event.K[0] := RTKFrame.K1;
    event.K[1] := RTKFrame.K2;
    event.K[2] := RTKFrame.K3;
    event.AI[1] := RTKFrame.AI;
    event.AM[1] := RTKFrame.AM;
    event.AR[1] := RTKFrame.AR;
    event.AI[2] := RTKFrame.AI2;
    event.AM[2] := RTKFrame.AM2;
    event.AR[2] := RTKFrame.AR2;
    event.AI[3] := RTKFrame.AI3;
    event.AM[3] := RTKFrame.AM3;
    event.AR[3] := RTKFrame.AR3;
    event.RTKDesc := Trim(RTKFrame.Description);
    event.RTKName := Trim(RTKFrame.RTKPatternName);
    //rm 2009-07-27 name not gettting updated properly!
    event.RTKName := Trim(edPatternName.Text);
end;

procedure TfrmEventEdit.UpdateDataBasedOnSelectedEvent;
begin
  //FrameRTKPattern1.SuspendUpdates:= true;
  StartDatePicker.DateTime := event.StartDate;
  StartTimePicker.DateTime := event.StartDate;
  EndDatePicker.DateTime := event.EndDate;
  EndTimePicker.DateTime := event.EndDate;
//rm 2007-10-19 - if rtkpatternid > 0 then
//get the rtkpattern from rtkpatterns table
  rtkPatternID := DatabaseModule.GetRTKPatternID4Event(event.EventID);
  if (rtkPatternID > 0) then begin
    edPatternName.Text := DatabaseModule.GetRTKPatternNameForID(rtkPatternID);
    FrameRTKPattern1.SetRTKPatternByName(edPatternName.Text);
  end else begin
    FrameRTKPattern1.SetRTKPatternFromEvent(event);
    edPatternName.Text := DatabaseModule.GetDefaultRTKPAtternName(AnalysisID, event.StartDate);
  end;
  //rm 2010-10-19 - advance to starttime?

{
  FrameRTKPattern1.SetRTKPatternFromEvent(event);
  rtkPatternID := DatabaseModule.GetRTKPatternID4Event(event.EventID);
  if (rtkPatternID > -1) then begin
    edPatternName.Text := DatabaseModule.GetRTKPatternNameForID(rtkPatternID);
  end else begin
    edPatternName.Text := GetDefaultRTKPAtternName;
  end;
}
{
  EventR1Edit.Text := floatToStr(event.R[0]);
  EventR2Edit.Text := floatToStr(event.R[1]);
  EventR3Edit.Text := floatToStr(event.R[2]);
  EventT1Edit.Text := floatToStr(event.T[0]);
  EventT2Edit.Text := floatToStr(event.T[1]);
  EventT3Edit.Text := floatToStr(event.T[2]);
  EventK1Edit.Text := floatToStr(event.K[0]);
  EventK2Edit.Text := floatToStr(event.K[1]);
  EventK3Edit.Text := floatToStr(event.K[2]);
}
end;

//rm 2009-06-08 - recast as function to capture error condition and not close form
//procedure TfrmEventEdit.UpdateCurrentEvent;
function TfrmEventEdit.UpdateCurrentEvent: boolean;
var sPatternName,s: string;
  bo_Result: boolean;
  idx, idx2: integer;
begin
  bo_Result := false;
//  if not HasNonRTKEdits then begin
{
  if not HasEdits then begin
    //exit;
    result := true;
    exit;
  end;
}
  inc(hitcount);
  label12.Caption := 'Hit Count: ' + inttostr(hitcount);
  event.StartDate := trunc(StartDatePicker.DateTime)+frac(StartTimePicker.DateTime);
  event.EndDate := trunc(EndDatePicker.DateTime)+frac(EndTimePicker.DateTime);

  //some validation here:
  s := FrameRTKPattern1.ValidateInitialDepth;
  if (length(s) > 0) then begin
    messagedlg(s,mtError,[mbOK],0);
    result := false;
  end else begin

  //update event parameters based on the RTKs in the RTKPatternFrame
  UpdateEventBasedOnRTKPatternFrame(FrameRTKPattern1);
{
  if (Length(EventR1Edit.Text) > 0)
    then event.R[0] := strToFloat(EventR1Edit.Text)
    else event.R[0] := 0.0;
  if (Length(EventR2Edit.Text) > 0)
    then event.R[1] := strToFloat(EventR2Edit.Text)
    else event.R[1] := 0.0;
  if (Length(EventR3Edit.Text) > 0)
    then event.R[2] := strToFloat(EventR3Edit.Text)
    else event.R[2] := 0.0;
  if (Length(EventT1Edit.Text) > 0)
    then event.T[0] := strToFloat(EventT1Edit.Text)
    else event.T[0] := 0.0;
  if (Length(EventT2Edit.Text) > 0)
    then event.T[1] := strToFloat(EventT2Edit.Text)
    else event.T[1] := 0.0;
  if (Length(EventT3Edit.Text) > 0)
    then event.T[2] := strToFloat(EventT3Edit.Text)
    else event.T[2] := 0.0;
  if (Length(EventK1Edit.Text) > 0)
    then event.K[0] := strToFloat(EventK1Edit.Text)
    else event.K[0] := 0.0;
  if (Length(EventK2Edit.Text) > 0)
    then event.K[1] := strToFloat(EventK2Edit.Text)
    else event.K[1] := 0.0;
  if (Length(EventK3Edit.Text) > 0)
    then event.K[2] := strToFloat(EventK3Edit.Text)
    else event.K[2] := 0.0;
}
{
  if (((event.R[0] > 0) and (event.T[0] > 0))
    or ((event.R[1] > 0) and (event.T[1] > 0))
     or ((event.R[2] > 0) and (event.T[2] > 0)))
  then begin
}
    sPatternName := Trim(edPatternName.Text);
    if Length(sPatternName) < 1 then begin
      sPatternName := DatabaseModule.GetDefaultRTKPatternName(AnalysisID,event.StartDate);
      edPatternName.Text := sPatternName;
    end;
    UpdateIIGraph;
    //rm 2009-06-09 - Beta testing shows user confusion when
    //adding a new RTKPattern with a Default Name that already
    //exists in the database. All they have to do is supply a new
    //different name - but that is never communicated to them.
    //
    //Two possibilities here:
    //1 - this is an edit to an existing RTKPattern (RTKPattennID > 0)
    //2 - this is a new RTKPattern (RTKPAtternID < 1)
    //
    //rm 2009-06-09 - new handling here -
    //comment out UpdateRTKPattern4Event
    //bo_Result := DatabaseModule.UpdateRTKPattern4Event(sPatternName, event);
    //DatabaseModule.UpdateEvent(event);
    //add
    idx := DatabaseModule.GetRTKPatternID4Event(event.EventID);
    //showmessage('RTKPatternID = ' + IntToStr(idx));
    if (event.RTKPatternID > 0) then begin
      //case 1 - existing RTKPattern begin edited
      //showmessage('Editing old RTKPattern.');
      DatabaseModule.UpdateEvent(event);
      bo_Result := true;
    end else begin
      //case 2 - new RTKPattern - check for unique RTKPattern Name
      //showmessage('New RTKPattern!');
      //check for duplicate patternname
      //rm 2010-09-29 - TODO: factor Month in
//rm 2010-09-29      idx2 := DatabaseModule.GetRTKPAtternIDforName(sPatternName);
      idx2 := DatabaseModule.GetRTKPAtternIDforNameAndMonth(sPatternName, 0);
      if (idx2 > 0) then begin
        MessageDlg('An RTK Pattern named "' + sPatternName + '" already exists.' +
        ' Please change this RTK Pattern name and try again.', mtError, [mbok],0);
        bo_Result := false;
      end else begin
        DatabaseModule.CreateNewRTKPattern4Event(event, sPatternName);
        DatabaseModule.UpdateEvent(event);
        bo_Result := true;
      end;
    end;
    if (bo_Result) then begin
      FrameRTKPattern1.HasEdits := false;
      HasNonRTKEdits := false
    end;
  end;
{
  end;
}
  Result := bo_Result;
end;

procedure TfrmEventEdit.OpenDialog(eventsIn: TStormEventCollection;
    eventNumberIn: integer; iAnalysisID:integer);
var bo: boolean;
begin
  bo := FrameRTKPattern1.AutoApplyChanges;
  AutoApplyCheckBox.Checked := false;
  FrameRTKPattern1.AutoApplyChanges := false;

  events := eventsIn;
  eventNumber := eventNumberIn;
  analysisID := iAnalysisID;
  EventSpinEdit.Value := eventNumber + 1;
  event := events.items[eventNumber];
  eventSpinEdit.MaxValue := events.count;
  UpdateDataBasedOnSelectedEvent;
  //hasedits := false;
  HasNonRTKEdits := false;
  FrameRTKPattern1.HasEdits := false;
  AutoApplyCheckBox.Checked := bo;
  FrameRTKPattern1.AutoApplyChanges := bo;
  FrameRTKPattern1.SuspendUpdates := false;

frmIIGraph.GotoEventNum(eventNumber);
  //ModalResult := nil; //mrNone;
  {
  if ((event.R[0] = 0) and (event.R[1] = 0) and (event.R[2] = 0)
    and (event.T[0] = 0) and (event.T[1] = 0) and (event.T[2] = 0)) then
      FrameRTKPattern1.SetRTKPatternFromAnalysis(analysisID);
  }


  //rm 2009-06-09 - to keep form from closing on Enter key self.Show;
end;

procedure TfrmEventEdit.UpdateIIGraph();
begin
  frmIIGraph.calculateSimulatedRDII;
  frmIIGraph.fillChart;
end;

procedure TfrmEventEdit.UpdateFromGraph();
begin
  if (visible) then begin
    if (EventSpinEdit.Value > events.count) then begin
      eventNumber := events.count - 1;
      EventSpinEdit.Value := events.count;
    end;
    event := events[eventSpinEdit.Value - 1];
    UpdateDataBasedOnSelectedEvent;
    HasNonRTKEdits := false;
    FrameRTKPattern1.HasEdits := false;
    //hasedits := false;
  end;
end;


procedure TfrmEventEdit.applyButtonClick(Sender: TObject);
begin
  UpdateCurrentEvent;
  FrameRTKPattern1.SuspendUpdates := false;
end;

procedure TfrmEventEdit.AutoApplyCheckBoxClick(Sender: TObject);
begin
  if (AutoApplyCheckBox.checked) then UpdateCurrentEvent;
  FrameRTKPattern1.AutoApplyChanges := AutoApplyCheckBox.checked;
  FrameRTKPattern1.SuspendUpdates := false;
end;

procedure TfrmEventEdit.btnDefaultsClick(Sender: TObject);
begin
//load the analysis defaults for this event
  FrameRTKPattern1.SetRTKPatternFromAnalysis(analysisID);
//  hasedits := true;
  FrameRTKPattern1.HasEdits := true;
  if (Length(edPatternName.Text) < 1) then begin
    edPatternName.Text := DataBaseModule.GetDefaultRTKPatternName(AnalysisID, event.StartDate);
  end;
  if AutoApplyCheckBox.Checked then UpdateCurrentEvent

end;

procedure TfrmEventEdit.Button1Click(Sender: TObject);
var
  dObservedRDII: double;
  dTotalRainfall: double;
  eventStatGetter: TEventStatGetter;
  i: integer;
begin
  eventStatGetter := TEventStatGetter.Create(analysisID);
  i := eventStatGetter.GetAnalysisSpecifics;
  eventNumber := StrToInt(eventSpinEdit.Text);
  i := eventStatGetter.GetEventStats(eventNumber);

  dTotalRainfall := eventStatGetter.RainVolume;
  label4.caption := 'Event Rainfall = ' + FormatFloat('0.00',dTotalRainfall);
  dObservedRDII := eventStatGetter.eventTotalR;
  label5.caption := 'Event RDII = ' + FormatFloat('0.0000',dObservedRDII);

  eventStatGetter.Free;

end;

end.
