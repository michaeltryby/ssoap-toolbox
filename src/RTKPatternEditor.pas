unit RTKPatternEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, RDIIGraphFrame,
  StormEvent, StormEventCollection, rdiiutils, math, Hydrograph, RTKPatternFrame;

type
  TfrmRTKPatternEditor = class(TForm)
    Label11: TLabel;
    ComboBoxRainGauges: TComboBox;
    GroupBoxRTKParameters: TGroupBox;
    Label6: TLabel;
    LabelAreaUnits: TLabel;
    Label8: TLabel;
    LabelVolUnits: TLabel;
    Label9: TLabel;
    LabelMaxUnits: TLabel;
    EditArea: TEdit;
    EditPeak: TEdit;
    EditVolume: TEdit;
    btnSaveRTKs: TButton;
    btnUpdate: TButton;
    Label13: TLabel;
    Label19: TLabel;
    StartDatePicker: TDateTimePicker;
    EndDatePicker: TDateTimePicker;
    StartTimePicker: TDateTimePicker;
    EndTimePicker: TDateTimePicker;
    FrameRDIIGraph1: TFrameRDIIGraph;
    helpButton: TButton;
    closeButton: TButton;
    Label1: TLabel;
    RTKPatternNameEdit: TEdit;
    FrameRTKPattern1: TFrameRTKPattern;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure ComboBoxRainGaugesChange(Sender: TObject);
    procedure closeButtonClick(Sender: TObject);
    procedure btnSaveRTKsClick(Sender: TObject);
    procedure RTKPatternNameEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FrameRTKPattern1MouseLeave(Sender: TObject);
    procedure RTKPatternNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure helpButtonClick(Sender: TObject);
  private
    { Private declarations }
    //FStartDate,FEndDate: double;
    FRTKPatternName, FRaingaugeName: string;
    FEndDateTime: double;
    FStartDateTime: double;
    boHasEdits_in_RTKs: boolean;
    originalRTKPatternName: string;
    iRTKPatternID: integer;
    FAddingNewRecord: boolean;
    FRTKPatternList: TStringList;
    FUseRGDates: boolean;
    FCopyingRecord: boolean;
    FArea: double;
    //rm 2010-09-29
    FRTKPatternMonth: Integer;
    procedure SetRTKPatternMonth(const Value: Integer);
    //FStartTime: Double;
    //FEndTime: Double;
    procedure UpdateChart;
    procedure SetRTKPatternName(const Value: string);
    procedure SetEndDateTime(const Value: double);
    procedure SetStartDateTime(const Value: double);
    procedure SetAddRecordMode(const Value: boolean);
    //procedure SetComments(const Value: string);
    procedure SetRTKPatternList(const Value: TStringList);
    procedure SetRaingaugeName(const Value: string);
    procedure SetUseRGDates(const Value: boolean);
    procedure SetCopyRecordMode(const Value: boolean);
    procedure SetArea(const Value: double);
  public
    { Public declarations }
    property RTKPatternName: string read FRTKPatternName write SetRTKPatternName;
    property StartDate: double read FStartDateTime write SetStartDateTime;
    property EndDate: double read FEndDateTime write SetEndDateTime;
    property AddingNewRecord: boolean read FAddingNewRecord write SetAddRecordMode;
    property CopyingRecord: boolean read FCopyingRecord write SetCopyRecordMode;
    property RTKPatternList: TStringList read FRTKPatternList write SetRTKPatternList;
    property RainGaugeName: string read FRaingaugeName write SetRaingaugeName;
    property UseRainGaugeDates: boolean read FUseRGDates write SetUseRGDates;
    property AreaInAcres: double read FArea write SetArea;
    //rm 2010-09-29
    property RTKPatternMonth: Integer read FRTKPatternMonth write SetRTKPatternMonth;
  end;

var
  frmRTKPatternEditor: TfrmRTKPatternEditor;

implementation

uses analysis, moddatabase, mainform;

{$R *.dfm}

procedure TfrmRTKPatternEditor.btnSaveRTKsClick(Sender: TObject);
var iResult:boolean;
  s: string;
begin
//rm 2008-11-13 - implement new validation
  s := FrameRTKPattern1.ValidateInitialDepth;
  if (length(s) > 0) then
    messagedlg(s,mtError,[mbOK],0)
  else begin
  if FCopyingRecord then begin
    iResult := FrameRTKPattern1.SaveRTKPattern(True);

  end else begin
    iResult := FrameRTKPattern1.SaveRTKPattern(AddingNewRecord);

  end;
  //FrameRTKPattern1.SaveRTKPattern(AddingNewRecord);
  if iResult then begin
    CopyingRecord := false;
    AddingNewRecord := false;
    boHasEdits_in_RTKs := false;
    btnSaveRTKs.Enabled := false;
  end;
  end;
end;

procedure TfrmRTKPatternEditor.btnUpdateClick(Sender: TObject);
var s: string;
begin
  s := FrameRTKPattern1.ValidateInitialDepth;
  if (length(s) > 0) then
    messagedlg(s,mtError,[mbOK],0)
  else
    UpdateChart;
end;

procedure TfrmRTKPatternEditor.closeButtonClick(Sender: TObject);
begin
  if boHasEdits_in_RTKs then begin
    if messagedlg('Are you sure you want to exit without saving your changes?',
      mtConfirmation,[mbYes, mbCancel],0) = mrYes then Close;
  end else Close;
end;

procedure TfrmRTKPatternEditor.ComboBoxRainGaugesChange(Sender: TObject);
var iRainGaugeID: integer;
rainmax, raintot: double;
rainstep: integer;
begin
//
  FRaingaugeName := ComboBoxRainGauges.Text;
  iRainGaugeID := DatabaseModule.GetRaingaugeIDForName(FRainGaugeName);
  labelAreaUnits.Caption := 'ac';//databaseModule.getare
  rainstep := DatabaseModule.GetRainTimestep(iRainGaugeID);
  LabelVolUnits.Caption := DatabaseModule.GetRainUnitShortLabelForRaingauge(FRaingaugeName);
  labelMaxUnits.Caption :=  LabelVolUnits.Caption +
    ' / ' + IntToStr(rainstep) + ' min. interval';

  if FUseRGDates then begin
    StartDate := DatabaseModule.GetStartDateTime4RainGaugeID(iRainGaugeID);
    EndDate := DatabaseModule.GetEndDateTime4RainGaugeID(iRainGaugeID);
  end;

    rainmax := databaseModule.GetMaximumRainfallBetweenDates(
      iRainGaugeID,FStartDateTime,FEndDateTime);
    raintot := databaseModule.RainfallTotalForRaingaugeBetweenDates(
      iRainGaugeID,FStartDateTime,FEndDateTime);
    EditPeak.Text := formatfloat('0.00',rainmax); //floattostr(rainmax);
    EditVolume.Text := formatfloat('0.00',raintot); //floattostr(raintot);
    //EditDuration.Text := floattostrF(event.duration*24,ffFixed,8,2);
  UpdateChart;
end;

procedure TfrmRTKPatternEditor.FormCreate(Sender: TObject);
begin
  FRaingaugeName := '';
  FStartDateTime := 0.0;
  FEndDateTime := 0.0;
  FUseRGDates := true;
end;

procedure TfrmRTKPatternEditor.FormResize(Sender: TObject);
begin
  FrameRDIIGraph1.Width := Self.ClientWidth - FrameRDIIGraph1.Left - 4;
  FrameRDIIGraph1.Height := Self.ClientHeight - 2 * FrameRDIIGraph1.Top;
  FrameRDIIGraph1.FrameResize(Sender);
end;

procedure TfrmRTKPatternEditor.FormShow(Sender: TObject);
var i: integer;
begin
  FrameRDIIGraph1.NumAreas := 1;
  ComboBoxRainGauges.Items := DatabaseModule.GetRaingaugeNames;
  if Length(FRaingaugename) > 0 then begin
    i := -1;
    repeat
      inc(i);
      if ComboboxRainGauges.Items[i] = FRaingaugename then
        comboBoxRaingauges.ItemIndex := i;
    until i = ComboBoxRainGauges.Items.count;
    ComboBoxRainGauges.Text := FRaingaugename;
    ComboBoxRainGaugesChange(Sender);
  end else begin
    ComboBoxRainGauges.Itemindex := 0;
    ComboBoxRainGaugesChange(Sender);
  end;
  FrameRDIIGraph1.Title := FRTKPatternName;
  boHasEdits_in_RTKs := AddingNewRecord;
  btnSaveRTKs.Enabled := AddingNewRecord;
  originalRTKPatternName := FRTKPatternName;
  if AddingNewRecord then begin
    iRTKPatternID := -1;
    FrameRTKPattern1.HasEdits := true;
  end else begin       //FRTKPatternMonth
//rm 2010-09-29    iRTKPatternID := DatabaseModule.GetRTKPAtternIDforName(originalRTKPatternName);
    iRTKPatternID := DatabaseModule.GetRTKPAtternIDforNameAndMonth(originalRTKPatternName, FRTKPatternMonth);
    FrameRTKPattern1.RTKPatternName := originalRTKPAtternName;
    FrameRTKPattern1.HasEdits := false;
  end;
  if FStartDateTime > 0 then
    SetStartDateTime(FStartDateTime);
  if FEndDateTime > 0 then
    SetEndDateTime(FEndDateTime);
  UpdateChart;
  FUseRGDates := true;
  if CopyingRecord then begin
    Caption := 'RTK Pattern Editor - Copying ' + originalRTKPatternName;
  end else begin
    Caption := 'RTK Pattern Editor';
  end;
end;

procedure TfrmRTKPatternEditor.FrameRTKPattern1MouseLeave(Sender: TObject);
begin
//synchronize edit-state
  boHasEdits_in_RTKs := FrameRTKPattern1.HasEdits;
  btnSaveRTKs.Enabled := boHasEdits_in_RTKs;
end;

procedure TfrmRTKPatternEditor.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmRTKPatternEditor.RTKPatternNameEditChange(Sender: TObject);
begin
//messagedlg('changing name',mtinformation,[mbok],0);
//rm 2008-10-13  FRTKPatternName := RTKPatternNameEdit.Text;
  FRTKPatternName := stringreplace(RTKPatternNameEdit.Text, ' ', '_', [rfReplaceAll, rfIgnoreCase]);
//rm
  boHasEdits_in_RTKs := true;
  btnSaveRTKs.Enabled := true;
  //synchronoze with the Frame
  FrameRTKPattern1.HasEdits := true;
  FrameRTKPattern1.RTKPatternName := FRTKPatternName;
end;

procedure TfrmRTKPatternEditor.RTKPatternNameEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = ' '  then key := '_'
  else if key = '"' then key := '''';
end;

procedure TfrmRTKPatternEditor.SetAddRecordMode(const Value: boolean);
begin
  FAddingNewRecord := Value;
end;
procedure TfrmRTKPatternEditor.SetArea(const Value: double);
begin
  FArea := Value;
  EditArea.Text := FloattoStr(Value);
end;

procedure TfrmRTKPatternEditor.SetCopyRecordMode(const Value: boolean);
begin
  FCopyingRecord := Value;
end;

{
procedure TfrmRTKPatternEditor.SetComments(const Value: string);
begin
end;
}
procedure TfrmRTKPatternEditor.SetEndDateTime(const Value: double);
begin
  FEndDateTime := Value;
  EndDatePicker.DateTime := FEndDateTime;
  EndTimePicker.DateTime := FEndDateTime;
end;

procedure TfrmRTKPatternEditor.SetRaingaugeName(const Value: string);
begin
  FRaingaugeName := Value;
  //ComboBoxRainGauges.Text := FRaingaugeName;
  //ComboBoxRainGaugesChange(Self);
end;

//rm 2010-09-29
procedure TfrmRTKPatternEditor.SetRTKPatternMonth(const Value: Integer);
begin
  FRTKPatternMonth := Value;
  FrameRTKPattern1.Mon := FRTKPatternMonth;
end;

procedure TfrmRTKPatternEditor.SetRTKPatternList(const Value: TStringList);
begin
  FRTKPatternList := Value;
  FrameRTKPattern1.SetRTKPatternFromList(FRTKPatternList);
  //rm 2010-09-29 - description moved!
  //if FRTKPatternList.Count >12 then
  //  FrameRTKPattern1.Description := FRTKPatternList[12]
  //else
  //  FrameRTKPattern1.Description := '';
  if FRTKPatternList.Count > 20 then
    FrameRTKPattern1.Description := FRTKPatternList[20]
  else
    FrameRTKPattern1.Description := '';
  boHasEdits_in_RTKs := true;
  btnSaveRTKs.Enabled := true;
end;

procedure TfrmRTKPatternEditor.SetRTKPatternName(const Value: string);
//var RTKPatternList:TStringList;
begin
  FRTKPatternName := Value;
  RTKPatternNameEdit.Text := FRTKPatternName;
  //rm 2008-10-13  FrameRTKPattern1.SetRTKPatternByName(FRTKPatternName);
  //  FrameRTKPattern1.SetRTKPatternByName(Value);
  //rm  2010-09-29
   FrameRTKPattern1.SetRTKPatternByNameAndMonth(FRTKPatternName, FRTKPatternMonth);
end;

procedure TfrmRTKPatternEditor.SetStartDateTime(const Value: double);
begin
  FStartDateTime := Value;
  StartDatePicker.DateTime := FStartDateTime;
  StartTimePicker.DateTime := FStartDateTime;
end;

procedure TfrmRTKPatternEditor.SetUseRGDates(const Value: boolean);
begin
  FUseRGDates := Value;
end;

procedure TfrmRTKPatternEditor.UpdateChart;
begin
//update the Chart
  FrameRDIIGraph1.ClearAll;
  FrameRDIIGraph1.NumAreas := 1;
  Screen.Cursor := crHourglass;
  try
    FrameRDIIGraph1.RainGaugeName := FRaingaugeName;
    FrameRDIIGraph1.Title := FRTKPatternName;
    FrameRDIIGraph1.FlowUnitLabel := 'MGD';//DatabaseModule.GetFlowUnitLabelForMeter(sMeterName);
    FrameRDIIGraph1.RainUnitLabel := labelMaxUnits.Caption;
    FrameRDIIGraph1.SetRTKPatternFromRTKPatternFrame(FrameRTKPattern1,0);
    FrameRDIIGraph1.StartDate := StartDate;
    FrameRDIIGraph1.EndDate := EndDate + (FrameRTKPattern1.UHTimeBase/24.0);
    FrameRDIIGraph1.Area := strtoFloat(EditArea.Text);
    FrameRDIIGraph1.UpdateData;
    if (Length(FRaingaugeName) > 0) then
      FrameRDIIGraph1.RedrawChart;
  finally
    Screen.Cursor := crDefault;
  end;
end;

end.
