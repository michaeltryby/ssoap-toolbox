unit RTKPatternFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, StormEvent;

type
  TFrameRTKPattern = class(TFrame)
    Label3: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label4: TLabel;
    RTotalEdit: TEdit;
    R3Edit2: TEdit;
    R2Edit2: TEdit;
    R1Edit2: TEdit;
    Label12: TLabel;
    T3Edit2: TEdit;
    T2Edit2: TEdit;
    T1Edit2: TEdit;
    Label14: TLabel;
    K3Edit2: TEdit;
    K2Edit2: TEdit;
    K1Edit2: TEdit;
    Label15: TLabel;
    MemoDescription: TMemo;
    lblDescription: TLabel;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    EditAI: TEdit;
    EditAM: TEdit;
    EditAR: TEdit;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EditMonth: TEdit;
    CheckBox1: TCheckBox;
    EditAI2: TEdit;
    EditAM2: TEdit;
    EditAR2: TEdit;
    EditAI3: TEdit;
    EditAM3: TEdit;
    EditAR3: TEdit;
    procedure R1Edit2Change(Sender: TObject);
    procedure T1Edit2Change(Sender: TObject);
    procedure K1Edit2Change(Sender: TObject);
    procedure R1Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure MemoDescriptionChange(Sender: TObject);
    procedure MemoDescriptionKeyPress(Sender: TObject; var Key: Char);
    procedure EditAIChange(Sender: TObject);
    procedure EditMonthChange(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure EditMonthKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FHasEdits: boolean;
    FR2: double;
    FR3: double;
    FR1: double;
    FT2: double;
    FT3: double;
    FK2: double;
    FT1: double;
    FK3: double;
    FK1: double;
    FAI: double;
    FAM: double;
    FAR: double;
    FAI2: double;
    FAM2: double;
    FAR2: double;
    FAI3: double;
    FAM3: double;
    FAR3: double;
    FRTKPatternName: string;
    FRTKPatternDescription: string;
    FDescriptionVisible: boolean;
    FRTKPatternID: integer;
    FMon: integer;
    FAutoApply: boolean;
    FSuspendUpdates: boolean;
    procedure SetHasEdits(const Value: boolean);
    procedure SetK1(const Value: double);
    procedure SetK2(const Value: double);
    procedure SetK3(const Value: double);
    procedure SetR1(const Value: double);
    procedure SetR2(const Value: double);
    procedure SetR3(const Value: double);
    procedure SetT1(const Value: double);
    procedure SetT2(const Value: double);
    procedure SetT3(const Value: double);
    function GetUHTimebase: double;
    procedure SetRTKPatternName(const Value: string);
    procedure SetRTKPatternDescription(const Value: string);
    procedure SetDescriptionVisible(const Value: boolean);
    procedure SetAI(const Value: double);
    procedure SetAM(const Value: double);
    procedure SetAR(const Value: double);
    procedure SetMon(const Value: integer);
    procedure SetAI2(const Value: double);
    procedure SetAM2(const Value: double);
    procedure SetAR2(const Value: double);
    procedure SetAI3(const Value: double);
    procedure SetAM3(const Value: double);
    procedure SetAR3(const Value: double);
    procedure SetAutoApply(const Value: boolean);
    procedure SetSuspendUpdates(const Value: boolean);
  public
    { Public declarations }
    function GetRTKPatternID: integer;
    function GetRTKPatternList: TStringList;
    procedure SetRTKPatternFromList(rtkPatternList: TStringList);
    procedure SetRTKPatternFromEvent(event: TStormEvent);
    procedure SetRTKPatternFromAnalysis(analysisID: integer);
    procedure SetRTKPatternByName(sName: string);
    procedure SetRTKPatternByNameAndMonth(sName: string; iMon: Integer);
    procedure SetAdvanced(bo: boolean);
    function ValidateInitialDepth: string;
    function SaveRTKPattern(AddingNewRecord:boolean): boolean;
    property HasEdits: boolean read FHasEdits write SetHasEdits;
    property DescriptionVisible: boolean read FDescriptionVisible write SetDescriptionVisible;
    property RTKPatternName: string read FRTKPatternName write SetRTKPatternName;
    property Description: string read FRTKPatternDescription write SetRTKPatternDescription;
    property R1:double read FR1 write SetR1;
    property T1:double read FT1 write SetT1;
    property K1:double read FK1 write SetK1;
    property R2:double read FR2 write SetR2;
    property T2:double read FT2 write SetT2;
    property K2:double read FK2 write SetK2;
    property R3:double read FR3 write SetR3;
    property T3:double read FT3 write SetT3;
    property K3:double read FK3 write SetK3;
    property AI: double read FAI write SetAI;
    property AM: double read FAM write SetAM;
    property AR: double read FAR write SetAR;
    property AI2: double read FAI2 write SetAI2;
    property AM2: double read FAM2 write SetAM2;
    property AR2: double read FAR2 write SetAR2;
    property AI3: double read FAI3 write SetAI3;
    property AM3: double read FAM3 write SetAM3;
    property AR3: double read FAR3 write SetAR3;
    property Mon: integer read FMon write SetMon;
    property UHTimeBase: double read GetUHTimebase;
    property AutoApplyChanges: boolean read FAutoApply write SetAutoApply;
    property SuspendUpdates: boolean read FSuspendUpdates write SetSuspendUpdates;
  end;

implementation
 uses Math, moddatabase, ADODB_TLB, mainform;
{$R *.dfm}

procedure TFrameRTKPattern.SetAdvanced(bo: boolean);
begin
  Label1.Visible := bo;
  Label2.Visible := bo;
  Label5.Visible := bo;
  Label6.Visible := bo;
  EditAI.Visible := bo;
  EditAM.Visible := bo;
  EditAR.Visible := bo;
  EditAI2.Visible := bo;
  EditAM2.Visible := bo;
  EditAR2.Visible := bo;
  EditAI3.Visible := bo;
  EditAM3.Visible := bo;
  EditAR3.Visible := bo;
end;

procedure TFrameRTKPattern.CheckBox1Click(Sender: TObject);
begin
  SetAdvanced(CheckBox1.Checked);
//  if CheckBox1.Checked then begin
    //rm 2010-09-30 CheckBox1.Width := Label2.Left - CheckBox1.Left - 6;
    //rm 2010-09-30 CheckBox1.Caption := 'Adv';
//  end else begin
    //rm 2010-09-30 CheckBox1.Width := Label2.Left + Label2.Width - CheckBox1.Left;
    //rm 2010-09-30 CheckBox1.Caption := 'Advanced';
//  end;
end;

procedure TFrameRTKPattern.EditAIChange(Sender: TObject);
//var _fai, _fam: double;
begin
//rm 2008-05-15 - a little validation
//AI may not be larger than AM
//rm 2008-11-13 - move validation to public function
{*
try
  _fai := strtofloat(EditAI.Text);
  _fam := strtofloat(EditAM.Text);
  if (_fai > _fam) then begin
    MessageDlg('Initial Abstraction cannot be larger than Max.',
      mtError,[mbok],0);
    exit;
  end;
finally

end;
*}
  //
  //FHasEdits := true;
  //Changed one of the Abstraction Terms
  try
  //rm 2010-09-29 rejigged
    if sender = EditAI then begin
      FAI := strtofloat(EditAI.Text);
    end else if sender = EditAM then begin
      FAM := strtofloat(EditAM.Text);
    end else if sender = EditAR then begin
      FAR := strtofloat(EditAR.Text);
    end else if sender = EditAI2 then begin
      FAI2 := strtofloat(EditAI2.Text);
    end else if sender = EditAM2 then begin
      FAM2 := strtofloat(EditAM2.Text);
    end else if sender = EditAR2 then begin
      FAR2 := strtofloat(EditAR2.Text);
    end else if sender = EditAI3 then begin
      FAI3 := strtofloat(EditAI3.Text);
    end else if sender = EditAM3 then begin
      FAM3 := strtofloat(EditAM3.Text);
    end else if sender = EditAR3 then begin
      FAR3 := strtofloat(EditAR3.Text);
    end;
  finally

  end;
  if FSuspendUpdates then exit;
  FHasEdits := true;
  //rm 2010-09-30
  if FAutoApply then SaveRTKPattern(false);
end;

function TFrameRTKPattern.ValidateInitialDepth: string;
var _fai, _fam: double;
strReturn: string;
begin
strReturn := '';
if CheckBox1.Checked then
try
//rm 2010-09-29 - rejigged slightly
  _fai := strtofloat(EditAI.Text);
  _fam := strtofloat(EditAM.Text);
  if (_fai > _fam) then begin
    strReturn := 'Initial Depth 1 cannot be larger than Maximum Depth 1.';
  end;
  _fai := strtofloat(EditAI2.Text);
  _fam := strtofloat(EditAM2.Text);
  if (_fai > _fam) then begin
    strReturn := 'Initial Depth 2 cannot be larger than Maximum Depth 2.';
  end;
  _fai := strtofloat(EditAI3.Text);
  _fam := strtofloat(EditAM3.Text);
  if (_fai > _fam) then begin
    strReturn := 'Initial Depth 3 cannot be larger than Maximum Depth 3.';
  end;
finally

end;
Result := strReturn;
end;

procedure TFrameRTKPattern.EditMonthChange(Sender: TObject);
begin
  FHasEdits := true;
  try
    FMon := StrtoInt(EditMonth.Text);
  except
    MessageDlg('Error converting "' +
      EditMonth.Text + '" to integer.' +
      ' Please enter 0 for ALL Months, 1 for JAN, 2 for FEB, etc.',
      mtError,[mbok],0);
  end;
  if ((FMon > 12) or (FMon < 0)) then begin
    MessageDlg('Error.' +
      ' Please enter 0 for ALL Months, 1 for JAN, 2 for FEB, etc.',
      mtError,[mbok],0);
  end;
end;

procedure TFrameRTKPattern.EditMonthKeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #8, #22, '0'..'9'] then exit;
    Key := #0;
  end;
end;

function TFrameRTKPattern.GetRTKPatternID: integer;
begin
  Result := FRTKPatternID;
end;

function TFrameRTKPattern.GetRTKPatternList: TStringList;
var ResultStringList: TStringList;
begin
  ResultStringList := TStringList.Create;
  ResultStringList.Add(R1Edit2.Text);
  ResultStringList.Add(T1Edit2.Text);
  ResultStringList.Add(K1Edit2.Text);
  ResultStringList.Add(R2Edit2.Text);
  ResultStringList.Add(T2Edit2.Text);
  ResultStringList.Add(K2Edit2.Text);
  ResultStringList.Add(R3Edit2.Text);
  ResultStringList.Add(T3Edit2.Text);
  ResultStringList.Add(K3Edit2.Text);
  if CheckBox1.Checked then begin
    ResultStringList.Add(EditAI.Text);
    ResultStringList.Add(EditAM.Text);
    ResultStringList.Add(EditAR.Text);
    //rm 2010-09-29 - added initial abstraction terms for the other two sets of RTKs
    ResultStringList.Add(EditAI2.Text);
    ResultStringList.Add(EditAM2.Text);
    ResultStringList.Add(EditAR2.Text);
    ResultStringList.Add(EditAI3.Text);
    ResultStringList.Add(EditAM3.Text);
    ResultStringList.Add(EditAR3.Text);
  end else begin
    ResultStringList.Add('0');
    ResultStringList.Add('0');
    ResultStringList.Add('0');
    //rm 2010-09-29 - added initial abstraction terms for the other two sets of RTKs
    ResultStringList.Add('0');
    ResultStringList.Add('0');
    ResultStringList.Add('0');
    ResultStringList.Add('0');
    ResultStringList.Add('0');
    ResultStringList.Add('0');
  end;
  ResultStringList.Add(EditMonth.Text);
  ResultStringList.Add(Trim(MemoDescription.Text));
  Result := ResultStringList;
end;

function TFrameRTKPattern.GetUHTimebase: double;
//get the unit hydrograph timebase
//add this (hours) to the time of the last rainfall in your event
//to get end of RDII hydrograph
var TB1, TB2, TB3: double;
begin
  TB1 := T1 + T1 * K1;
  TB2 := T2 + T2 * K2;
  TB3 := T3 + T3 * K3;
  Result := Max(Max(TB1,TB2),TB3);
end;

procedure TFrameRTKPattern.K1Edit2Change(Sender: TObject);
begin
  try
  //rm 2009-07-27 - do not convert if zero length
  if (Length(K1Edit2.Text) > 0) then
    FK1 := strtofloat(K1Edit2.Text)
  else FK1 := 0;
  if (Length(K2Edit2.Text) > 0) then
    FK2 := strtofloat(K2Edit2.Text)
  else FK2 := 0;
  if (Length(K3Edit2.Text) > 0) then
    FK3 := strtofloat(K3Edit2.Text)
  else FK3 := 0;
  finally

  end;
  if FSuspendUpdates then exit;
  FHasEdits := true;
  //rm 2010-09-30
  if FAutoApply then SaveRTKPattern(false);
end;

procedure TFrameRTKPattern.MemoDescriptionChange(Sender: TObject);
begin
//  FHasEdits := true;
  FRTKPatternDescription := Trim(MemoDescription.Text);
  if FSuspendUpdates then exit;
  FHasEdits := true;
  //rm 2010-09-30
  if FAutoApply then SaveRTKPattern(false);
end;

procedure TFrameRTKPattern.MemoDescriptionKeyPress(Sender: TObject;
  var Key: Char);
begin
//no double-quotes or carriage returns or linefeeds
  if sender is TMemo then begin
    if Key in [#10, #13] then
      Key := #0;
    if Key = '"' then
      Key := '''';
  end;
end;

procedure TFrameRTKPattern.R1Edit2Change(Sender: TObject);
var TotalR: double;
begin
  //Changed one of the Rs
  //Calculate total R
  TotalR := 0.0;
  try
    //TotalR := TotalR + strtofloat(R1Edit2.Text);
    //TotalR := TotalR + strtofloat(R2Edit2.Text);
    //TotalR := TotalR + strtofloat(R3Edit2.Text);
  //rm 2009-07-27 - do not convert if zero length
  if (Length(R1Edit2.Text) > 0) then
    FR1 := strtofloat(R1Edit2.Text)
  else FR1 := 0;
  if (Length(R2Edit2.Text) > 0) then
    FR2 := strtofloat(R2Edit2.Text)
  else FR2 := 0;
  if (Length(R3Edit2.Text) > 0) then
    FR3 := strtofloat(R3Edit2.Text)
  else FR3 := 0;
    TotalR := FR1 + FR2 + FR3;
  finally
    RTotalEdit.Text := floattostrF(TotalR,ffFixed,8,4);
  end;
  if FSuspendUpdates then exit;
  FHasEdits := true;
  //rm 2010-09-30
  if FAutoApply then SaveRTKPattern(false);

end;

procedure TFrameRTKPattern.R1Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #8, #22, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0) then exit;
    Key := #0;
  end;
end;

function TFrameRTKPattern.SaveRTKPattern(AddingNewRecord:boolean): boolean;
var iTest: integer;
  PatternList: TStringList;
  iResult : boolean;
begin
  iResult := false;
  PatternList := GetRTKPatternList;
  PatternList.Insert(0,FRTKPatternName);
  //PatternList.Add(Description);

  if AddingNewRecord then begin
//rm 2010-09-29    iTest := DatabaseModule.GetRTKPatternIDforName(FRTKPatternName);
    iTest := DatabaseModule.GetRTKPatternIDforNameAndMonth(FRTKPatternName, FMon);
    if iTest < 0 then begin  //unique pattern name
      DatabaseModule.AddRTKPattern(PatternList);
//rm 2010-09-29      FRTKPatternID := DatabaseModule.GetRTKPAtternIDforName(FRTKPatternName);
      FRTKPatternID := DatabaseModule.GetRTKPAtternIDforNameAndMonth(FRTKPatternName, FMon);
      iResult := true;
    end else begin  //duplicate
      MessageDlg('An RTK Pattern named "' + FRTKPatternName + '" already exists. ' +
      ' Please enter a unique name.',mtError,[mbok],0);
      Result := false;
      exit;
    end;
  end else begin
    PatternList.Add(IntToStr(FRTKPatternID));
    DatabaseModule.UpdateRTKPattern(PatternList);
    iResult := true;
  end;
  FHasEdits := false;
  Result := iResult;
end;

procedure TFrameRTKPattern.SetAI(const Value: double);
begin
  FAI := Value;
  EditAI.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetAM(const Value: double);
begin
  FAM := Value;
  EditAM.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetAR(const Value: double);
begin
  FAR := Value;
  EditAR.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetAI2(const Value: double);
begin
  FAI2 := Value;
  EditAI2.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetAM2(const Value: double);
begin
  FAM2 := Value;
  EditAM2.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetAR2(const Value: double);
begin
  FAR2 := Value;
  EditAR2.Text := floattostr(Value);
end;
procedure TFrameRTKPattern.SetAI3(const Value: double);
begin
  FAI3 := Value;
  EditAI3.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetAM3(const Value: double);
begin
  FAM3 := Value;
  EditAM3.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetAR3(const Value: double);
begin
  FAR3 := Value;
  EditAR3.Text := floattostr(Value);
end;
procedure TFrameRTKPattern.SetAutoApply(const Value: boolean);
begin
  FAutoApply := Value;
  if FAutoApply then
  
end;

procedure TFrameRTKPattern.SetDescriptionVisible(const Value: boolean);
begin
  FDescriptionVisible := Value;
  MemoDescription.Visible := Value;
end;

procedure TFrameRTKPattern.SetHasEdits(const Value: boolean);
begin
  FHasEdits := Value;
end;

procedure TFrameRTKPattern.SetK1(const Value: double);
begin
  FK1 := Value;
  K1Edit2.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetK2(const Value: double);
begin
  FK2 := Value;
  K2Edit2.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetK3(const Value: double);
begin
  FK3 := Value;
  K3Edit2.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetMon(const Value: integer);
begin
  FMon := Value;
  EditMonth.Text := inttostr(FMon);
end;

procedure TFrameRTKPattern.SetR1(const Value: double);
begin
  FR1 := Value;
  R1Edit2.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetR2(const Value: double);
begin
  FR2 := Value;
  R2Edit2.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetR3(const Value: double);
begin
  FR3 := Value;
  R3Edit2.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetRTKPatternByName(sName: string);
var RTKPatternList:TStringList;
//i: integer;
begin
  RTKPatternName := sName;
//rm 2010-09-29  RTKPatternList := DatabaseModule.GetRTKPatternforName(RTKPatternName);
//rm 2010-09-29  FRTKPAtternID :=  DatabaseModule.GetRTKPAtternIDforName(RTKPatternName);
  RTKPatternList := DatabaseModule.GetRTKPatternforNameAndMonth(RTKPatternName, FMon);
  FRTKPAtternID :=  DatabaseModule.GetRTKPAtternIDforNameAndMonth(RTKPatternName, FMon);
  //if RTKPatternList.Count < 12 then
  //  for i:=RTKPatternList.Count to 12 do RTKPatternList.Add('0');
  SetRTKPatternFromList(RTKPatternList);
//  if RTKPatternList.Count > 13 then
//    Description := RTKPatternList[13]
  if RTKPatternList.Count > 19 then
    Description := RTKPatternList[19]
  else
    Description := '';
end;
//rm 2010-09-29
procedure TFrameRTKPattern.SetRTKPatternByNameAndMonth(sName: string; iMon: INteger);
var RTKPatternList:TStringList;
//i: integer;
begin
  RTKPatternName := sName;
  Mon := iMon;
//rm 2010-09-29  RTKPatternList := DatabaseModule.GetRTKPatternforName(RTKPatternName);
  RTKPatternList := DatabaseModule.GetRTKPatternforNameAndMonth(RTKPatternName, Mon);
//rm 2010-09-29  FRTKPAtternID :=  DatabaseModule.GetRTKPAtternIDforName(RTKPatternName);
  FRTKPAtternID :=  DatabaseModule.GetRTKPAtternIDforNameAndMonth(RTKPatternName, Mon);
  //if RTKPatternList.Count < 12 then
  //  for i:=RTKPatternList.Count to 12 do RTKPatternList.Add('0');
  SetRTKPatternFromList(RTKPatternList);
//  if RTKPatternList.Count > 13 then
//    Description := RTKPatternList[13]
  if RTKPatternList.Count > 19 then
    Description := RTKPatternList[19]
  else
    Description := '';
end;

procedure TFrameRTKPattern.SetRTKPatternDescription(const Value: string);
begin
  FRTKPatternDescription := Value;
  MemoDescription.Clear;
  if (Length(Trim(FRTKPatternDescription)) > 0) then
    MemoDescription.Lines.Add(Trim(FRTKPatternDescription));
end;

procedure TFrameRTKPattern.SetRTKPatternFromAnalysis(analysisID: integer);
var
  queryStr: String;
//  i: integer;
  localRecSet: _RecordSet;
begin
//load rtks from Analysis where AnalysisID = analysisID
  queryStr := 'SELECT R1, R2, R3, T1, T2, T3, K1, K2, K3, ' +
              ' InitialValue, MaxDepressionStorage, ' +
              ' RateofReduction, ' +
//rm 2010-10-13 - extra initial abstraction terms
              ' InitialValue2, MaxDepressionStorage2, ' +
              ' RateofReduction2, ' +
              ' InitialValue3, MaxDepressionStorage3, ' +
              ' RateofReduction3 ' +
              ' FROM Analyses WHERE ' +
              '(AnalysisID = ' + inttostr(analysisID) + ');';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  localRecSet.MoveFirst;
    setR1(localRecSet.Fields.Item[0].Value);
    setR2(localRecSet.Fields.Item[1].Value);
    setR3(localRecSet.Fields.Item[2].Value);
    setT1(localRecSet.Fields.Item[3].Value);
    setT2(localRecSet.Fields.Item[4].Value);
    setT3(localRecSet.Fields.Item[5].Value);
    setK1(localRecSet.Fields.Item[6].Value);
    setK2(localRecSet.Fields.Item[7].Value);
    setK3(localRecSet.Fields.Item[8].Value);
    if VarIsNull(localRecSet.Fields.Item[10].Value) then
      setAM(0.0)
    else
      setAM(localRecSet.Fields.Item[10].Value);
    if VarIsNull(localRecSet.Fields.Item[11].Value) then
      setAR(0.0)
    else
      setAR(localRecSet.Fields.Item[11].Value);
    if VarIsNull(localRecSet.Fields.Item[9].Value) then
      setAI(0.0)
    else
      setAI(localRecSet.Fields.Item[9].Value);
  //rm 2010-09-30 - defaults are 0 for now:
  //rm 2010-10-13 - fixed now
  //    setAI2(0.0);
  //    setAM2(0.0);
  //    setAR2(0.0);
  //    setAI3(0.0);
  //    setAM3(0.0);
  //    setAR3(0.0);
    if VarIsNull(localRecSet.Fields.Item[13].Value) then
      setAM2(0.0)
    else
      setAM2(localRecSet.Fields.Item[13].Value);
    if VarIsNull(localRecSet.Fields.Item[14].Value) then
      setAR2(0.0)
    else
      setAR2(localRecSet.Fields.Item[14].Value);
    if VarIsNull(localRecSet.Fields.Item[12].Value) then
      setAI2(0.0)
    else
      setAI2(localRecSet.Fields.Item[12].Value);
    if VarIsNull(localRecSet.Fields.Item[16].Value) then
      setAM3(0.0)
    else
      setAM3(localRecSet.Fields.Item[16].Value);
    if VarIsNull(localRecSet.Fields.Item[17].Value) then
      setAR3(0.0)
    else
      setAR3(localRecSet.Fields.Item[17].Value);
    if VarIsNull(localRecSet.Fields.Item[15].Value) then
      setAI3(0.0)
    else
      setAI3(localRecSet.Fields.Item[15].Value);
  localRecSet.Close;
  HasEdits := true;
end;

procedure TFrameRTKPattern.SetRTKPatternFromEvent(event: TStormEvent);
begin
  FSuspendUpdates := true;
  try
  R1 := event.R[0];
  T1 := event.T[0];
  K1 := event.K[0];
  R2 := event.R[1];
  T2 := event.T[1];
  K2 := event.K[1];
  R3 := event.R[2];
  T3 := event.T[2];
  K3 := event.K[2];
//rm 2010-09-29  AI := event.AI;
//rm 2010-09-29  AM := event.AM;
//rm 2010-09-29  AR := event.AR;
  AI := event.AI[1];
  AM := event.AM[1];
  AR := event.AR[1];
  AI2 := event.AI[2];
  AM2 := event.AM[2];
  AR2 := event.AR[2];
  AI3 := event.AI[3];
  AM3 := event.AM[3];
  AR3 := event.AR[3];
  Description := event.RTKDesc;
  finally
    FSuspendUpdates := false;
  end;
end;

procedure TFrameRTKPattern.SetRTKPatternFromList(rtkPatternList: TStringList);
begin
  FSuspendUpdates := true;
  try
  R1 := 0.0;
  T1 := 0.0;
  K1 := 0.0;
  R2 := 0.0;
  T2 := 0.0;
  K2 := 0.0;
  R3 := 0.0;
  T3 := 0.0;
  K3 := 0.0;
  AI := 0.0;
  AM := 0.0;
  AR := 0.0;
  //rm 2010-09-29
  AI2 := 0.0;
  AM2 := 0.0;
  AR2 := 0.0;
  AI3 := 0.0;
  AM3 := 0.0;
  AR3 := 0.0;
  Mon := 0;
  if rtkPatternList.Count > 0 then begin
    R1 := strtofloat(rtkPatternList[0]);
    T1 := strtofloat(rtkPatternList[1]);
    K1 := strtofloat(rtkPatternList[2]);
    R2 := strtofloat(rtkPatternList[3]);
    T2 := strtofloat(rtkPatternList[4]);
    K2 := strtofloat(rtkPatternList[5]);
    R3 := strtofloat(rtkPatternList[6]);
    T3 := strtofloat(rtkPatternList[7]);
    K3 := strtofloat(rtkPatternList[8]);
    if rtkPatternList.Count > 11 then begin
      AI := strtofloat(rtkPatternList[9]);
      AM := strtofloat(rtkPatternList[10]);
      AR := strtofloat(rtkPatternList[11]);
//rm 2010-09-29      if rtkPatternList.Count > 12 then begin
//rm 2010-09-29        Mon := strtoint(rtkPatternList[12]);
      if rtkPatternList.Count > 17 then begin
        AI2 := strtofloat(rtkPatternList[12]);
        AM2 := strtofloat(rtkPatternList[13]);
        AR2 := strtofloat(rtkPatternList[14]);
        AI3 := strtofloat(rtkPatternList[15]);
        AM3 := strtofloat(rtkPatternList[16]);
        AR3 := strtofloat(rtkPatternList[17]);
        if rtkPatternList.Count > 18 then begin
          Mon := strtoint(rtkPatternList[18]);
        end;
        if rtkPatternList.Count > 19 then begin
          Description := rtkPatternList[19];
        end;
      end;
    end;
  end;
  finally
    FSuspendUpdates := false;
  end;
end;

procedure TFrameRTKPattern.SetRTKPatternName(const Value: string);
begin
//rm 2007-10-30 - No spaces allowed!
//  FRTKPatternName := stringreplace(Value, ' ', '_', [rfReplaceAll, rfIgnoreCase]);
//rm 2008-10-13 test
  FRTKPAtternName := Value;
end;

procedure TFrameRTKPattern.SetSuspendUpdates(const Value: boolean);
begin
  FSuspendUpdates := Value;
end;

procedure TFrameRTKPattern.SetT1(const Value: double);
begin
  FT1 := Value;
  T1Edit2.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetT2(const Value: double);
begin
  FT2 := Value;
  T2Edit2.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.SetT3(const Value: double);
begin
  FT3 := Value;
  T3Edit2.Text := floattostr(Value);
end;

procedure TFrameRTKPattern.T1Edit2Change(Sender: TObject);
begin
  try
  //rm 2009-07-27 - do not convert if zero length
  if (Length(T1Edit2.Text) > 0) then
    FT1 := strtofloat(T1Edit2.Text)
  else FT1 := 0;
  if (Length(T2Edit2.Text) > 0) then
    FT2 := strtofloat(T2Edit2.Text)
  else FT2 := 0;
  if (Length(T3Edit2.Text) > 0) then
    FT3 := strtofloat(T3Edit2.Text)
  else FT3 := 0;
  finally

  end;
  if FSuspendUpdates then exit;
  FHasEdits := true;
  //rm 2010-09-30
  if FAutoApply then SaveRTKPattern(false);
end;

end.
