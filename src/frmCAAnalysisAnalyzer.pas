unit frmCAAnalysisAnalyzer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StormEventCollection, StormEvent;

type
  TfrmCAAnalysesAnalyzer = class(TForm)
    MemoOlapAnalyzer: TMemo;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    //procedure PlotEvents(meterID: integer; events: TStormEventCollection);
    procedure PlotEvents2(sA1: string; iA1: integer; meterID1: integer; events1: TStormEventCollection;
                          sA2: string; iA2: integer; meterID2: integer; events2: TStormEventCollection;
                          tol: integer; boClear: boolean);
  public
    { Public declarations }
    sIN: string;
    sOUT: string;
    events1: TStormEventCollection;
    events2: TStormEventCollection;
    events3: TStormEventCollection;
    events4: TStormEventCollection;
    analysisID1, analysisID2, analysisID3, analysisID4: integer;
    meterID1, meterID2, meterID3, meterID4: integer;
    procedure SetAnalyses(sA1:string; sA2:string; sA3:string; sA4:string; tol: integer);

  end;

var
  frmCAAnalysesAnalyzer: TfrmCAAnalysesAnalyzer;

implementation
uses modDatabase, mainform, ADODB_TLB, EventStatGetter, CAChooseAnalyses;
{$R *.dfm}

procedure TfrmCAAnalysesAnalyzer.ButtonCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmCAAnalysesAnalyzer.ButtonOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfrmCAAnalysesAnalyzer.FormCreate(Sender: TObject);
begin
  sIN:= '=';
  sOUT:= '_';

end;


procedure TfrmCAAnalysesAnalyzer.PlotEvents2(
  sA1: string; iA1,
  meterID1: integer; events1: TStormEventCollection;
  sA2: string; iA2,
  meterID2: integer; events2: TStormEventCollection; tol: integer; boClear: boolean);
var i,j: integer;
  event1, event2, nextevent: TStormEvent;
  startDate1, endDate1, eventDuration1, curtime, hr : double;
  startDate2, endDate2, eventDuration2 : double;
  queryStr: string;
  recSet: _RecordSet;
  startDay, endDay, days, maximumMove: integer;
  flowStartDateTime1, flowEndDateTime1: TDateTime;
  flowStartDateTime2, flowEndDateTime2: TDateTime;
  overlapStartDateTime1, overlapEndDateTime1: TDateTime;
  myEventStatGetter1, myEventStatGetter2: TEventStatGetter;

  curhour, hours: Longint;
  s, ss, flowmeterName1, flowmeterName2: string;
  numOverlapEvent : integer;
  foundMatch : boolean;


begin
  queryStr := 'SELECT MeterName, StartDateTime, EndDateTime FROM Meters ' +
              'WHERE (MeterID = ' + inttostr(meterID1) + ');';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if not RecSet.EOF then begin
    recSet.MoveFirst;
    flowmeterName1 := recSet.Fields.Item[0].Value;
    flowStartDateTime1 := recSet.Fields.Item[1].Value;
    flowEndDateTime1 := recSet.Fields.Item[2].Value;
  end;
  recset.Close;
  queryStr := 'SELECT MeterName, StartDateTime, EndDateTime FROM Meters ' +
              'WHERE (MeterID = ' + inttostr(meterID2) + ');';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  if not RecSet.EOF then begin
    recSet.MoveFirst;
    flowmeterName2 := recSet.Fields.Item[0].Value;
    flowStartDateTime2 := recSet.Fields.Item[1].Value;
    flowEndDateTime2 := recSet.Fields.Item[2].Value;
  end;
  recset.Close;
  //do not display stats (for debugging purpose only)
  //comment out all memoOlapAnalyzer.Lies.X (06/21/2012 CC)
    if boClear then begin
      //MemoOlapAnalyzer.Lines.Clear;
      //MemoOlapAnalyzer.Lines.Add('---------- PRE-REHABILITATION CONDITIONS -----------');
    end else begin
      //MemoOlapAnalyzer.Lines.Add('---------- POST-REHABILITATION CONDITIONS -----------');
    end;

    //MemoOlapAnalyzer.Lines.Add('');
    //MemoOlapAnalyzer.Lines.Add('-- Monitoring Period --------');


    if flowStartDateTime1 > flowStartDateTime2 then begin
      s := 'Start - ' + DateTimeToStr(flowStartDateTime1);
      overlapStartDateTime1 := flowStartDateTime1;
      //MemoOlapAnalyzer.lines.Add(s);
    end else begin
      s := 'Start - ' + DateTimeToStr(flowStartDateTime2);
      overlapStartDateTime1 := flowStartDateTime2;
      //MemoOlapAnalyzer.lines.Add(s);
    end;

    if flowEndDateTime1 < flowEndDateTime2 then begin
      s := 'End - ' + DateTimeToStr(flowEndDateTime1);
      overlapEndDateTime1 := flowEndDateTime1;
      //MemoOlapAnalyzer.lines.Add(s);
    end else begin
      s := 'End - ' + DateTimeToStr(flowEndDateTime2);
      overlapEndDateTime1 := flowEndDateTime2;
      //MemoOlapAnalyzer.lines.Add(s);
    end;

    //MemoOlapAnalyzer.Lines.Add('');
    //MemoOlapAnalyzer.Lines.Add('RDII Events Used For Correlation Analysis:');
    //MemoOlapAnalyzer.Lines.Add('');

    //MemoOlapAnalyzer.Lines.Add('    	Rehabiliated Sewershed		Controled Sewershed');
    //MemoOlapAnalyzer.Lines.Add('Date	Event ID	     R-value		Event ID	  R-Value');

    myEventStatGetter1 := TEventStatGetter.Create(iA1);  //Pre-Rehab Meter
    myEventStatGetter2 := TEventStatGetter.Create(iA2);  //Control Meter

    numOverlapEvent := 0;

    for i := 1 to events1.Count do begin
      foundMatch := false;
      event1 := events1.items[i-1];
      startDate1 := event1.StartDate;
      endDate1 := event1.EndDate;
      eventDuration1 := endDate1 - startDate1;
      j := 1;
      while ((j <= events2.count) and (foundMatch = false)) do begin
        event2 := events2.items[j-1];
        startDate2 := event2.StartDate;
        endDate2 := event2.EndDate;
        eventDuration2 := endDate2 - startDate2;
          //we have an overlap
          if event1.overlapswtolerance(event2, tol) then begin  //when 2 events falls into same time frame and can be used for comparison
            foundMatch := true;
            numOverlapEvent := numOverlapEvent + 1;
            myEventStatGetter1.GetEventStats(i);
            myEventStatGetter2.GetEventStats(j);
            s := DateTimeToStr(StartDate1) + ' Event ' + IntToStr(i) + ' ';
            s := s + FormatFloat('0.000', myEventStatGetter1.eventTotalR);
            s := s + ' Event ' + IntToStr(j) + ' ' + FormatFloat('0.000', myEventStatGetter2.eventTotalR);
            //MemoOlapAnalyzer.lines.Add(s);
          end;
        inc(j);
      end;
    end;

    //MemoOlapAnalyzer.lines.Add('');
    s := 'Number of RDII Events Used for RDII Correlation: ' + inttostr(numOverlapEvent);
    //MemoOlapAnalyzer.lines.Add(s);

    // save numOverlapEvent to database
    if boClear then begin
      databasemodule.UpdateOlapEvent4CAID(frmCAAnalysesSelector.CAID,0,numOverlapEvent);
    end else begin
      databasemodule.UpdateOlapEvent4CAID(frmCAAnalysesSelector.CAID,1,numOverlapEvent);
    end;

    if boClear then begin
      databasemodule.UpdateOlapEvent4CAID(frmCAAnalysesSelector.CAID,0,numOverlapEvent);
    end else begin
      databasemodule.UpdateOlapEvent4CAID(frmCAAnalysesSelector.CAID,1,numOverlapEvent);
    end;

    //MemoOlapAnalyzer.lines.Add('');
    //MemoOlapAnalyzer.lines.Add('');
    //MemoOlapAnalyzer.lines.Add('');

    myEventStatGetter1.AllDone;
    myEventStatGetter2.AllDone;
end;

procedure TfrmCAAnalysesAnalyzer.SetAnalyses(sA1:string; sA2:string; sA3:string; sA4:string; tol:integer);
var meterName: string;
begin
  analysisID1 := DatabaseModule.GetAnalysisIDForName(sA1);
  events1 := DatabaseModule.GetEvents(analysisID1);
  meterName := DatabaseModule.GetFlowMeterNameForAnalysis(sA1);
  meterID1 := DatabaseModule.GetMeterIDForName(meterName);
  analysisID2 := DatabaseModule.GetAnalysisIDForName(sA2);
  events2 := DatabaseModule.GetEvents(analysisID2);
  meterName := DatabaseModule.GetFlowMeterNameForAnalysis(sA2);
  meterID2 := DatabaseModule.GetMeterIDForName(meterName);
  analysisID3 := DatabaseModule.GetAnalysisIDForName(sA3);
  events3 := DatabaseModule.GetEvents(analysisID3);
  meterName := DatabaseModule.GetFlowMeterNameForAnalysis(sA3);
  meterID3 := DatabaseModule.GetMeterIDForName(meterName);
  analysisID4 := DatabaseModule.GetAnalysisIDForName(sA4);
  events4 := DatabaseModule.GetEvents(analysisID4);
  meterName := DatabaseModule.GetFlowMeterNameForAnalysis(sA4);
  meterID4 := DatabaseModule.GetMeterIDForName(meterName);
  //PlotEvents(meterID1, events1);
  //PlotEvents(meterID2, events2);
  PlotEvents2(sA1, analysisID1, meterID1, events1, sA2, analysisID2, meterID2, events2, tol, true);
  PlotEvents2(sA3, analysisID3, meterID3, events3, sA4, analysisID4, meterID4, events4, tol, false);
end;

end.
