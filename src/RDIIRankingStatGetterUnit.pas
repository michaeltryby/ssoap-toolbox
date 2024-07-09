unit RDIIRankingStatGetterUnit;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes,
  Dialogs, ADODB_TLB;

    type RTKPatt = class
      R : double;
      T : double;
      K : double;
    end;
    type RStat = class
      R1 : double;
      R2 : double;
      R3 : double;
      RT : double;
    end;

    //Get the 'estimated/simulated' average R1, R2, and R3 values
    function GetAverageRValues(analysisName: string) : RStat;
    //Get the 'peak' R1, R2, R3 values
    function GetPeakRValues (analysisName: string) : RStat;
    //Get the medium totalR, R1, R2, R3 values
    function GetMedianRValues (analysisName: string) : RStat;
    //Get the 'observed' total R value
    function GetTotalRValue(analysisName: string) : double;
    //Get the 'average R2 + R3' combined total value
    function GetAverageR2R3Value(analysisName: string) : double;
    //Get the 'peak' R2 + R3 value
    function GetPeakR2R3Value(analysisName: string) : double;
    //Get the medium R2+R3 value
    function GetMedianR2R3Value(analysisName: string) : double;

    //function GetPeakR1_R2_R3Values(analysisName: string) : RStat;
    //function GetMedianR1_R2_R3Values(analysisName: string) : RStat;
    function GetRDIIVolumePerSewerLength(analysisName: string) : RStat;
    function GetRDIIPeakFlowPerArea(analysisName: string) : RStat;

implementation

uses modDatabase, mainform, StormEventCollection, EventStatGetter;

//Get the 'estimated/simulated' average R1, R2, and R3 values
function GetAverageRValues(analysisName: string) : RStat;
var
  queryStr: string;
  analysisID: integer;
  localRecSet: _RecordSet;
  counter: integer;
  Rs : RStat;
begin
//get the average R1, R2, and R3 for the selected analysis
    Initialize(Rs);
    Rs.R1 := 0.0;
    Rs.R2 := 0.0;
    Rs.R3 := 0.0;
    Rs.RT := 0.0;
    analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ');'; // Group by a.AnalysisID;';
    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    counter :=0 ;
    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      while not localRecSet.EOF do begin
        Rs.R1 := Rs.R1 + localRecSet.Fields.Item[1].Value; //* Rainfall; //fixed this
        Rs.R2 := Rs.R2 + localRecSet.Fields.Item[2].Value; //* Rainfall; //fixed this
        Rs.R3 := Rs.R3 + localRecSet.Fields.Item[3].Value; //* Rainfall; //fixed this
        Rs.RT := Rs.RT + Rs.R1 + Rs.R2 + Rs.R3;
        localRecSet.MoveNext;
        counter := counter + 1;
      end;
    end;
    localRecSet.Close;
    if counter > 0 then
    begin
      Rs.R1 := Rs.R1 / counter;
      Rs.R2 := Rs.R2 / counter;
      Rs.R3 := Rs.R3 / counter;
      Rs.RT := Rs.RT / counter;
    end;
    result := Rs;
end;

//Get the 'peak' R1, R2, R3 values
function GetPeakRValues (analysisName: string) : RStat;
var
  queryStr: string;
  analysisID: integer;
  localRecSet: _RecordSet;
  counter: integer;
  Rs : RStat;
begin
//get the peak R1, R2, and R3 for the selected analysis
    Initialize(Rs);
    Rs.R1 := 0.0;
    Rs.R2 := 0.0;
    Rs.R3 := 0.0;
    Rs.RT := 0.0;
  analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ');'; // Group by a.AnalysisID;';
    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    counter :=0 ;
    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      while not localRecSet.EOF do begin
        if localRecSet.Fields.Item[1].Value > Rs.R1 then Rs.R1 := localRecSet.Fields.Item[1].Value;
        if localRecSet.Fields.Item[2].Value > Rs.R2 then Rs.R2 := localRecSet.Fields.Item[2].Value;
        if localRecSet.Fields.Item[3].Value > Rs.R3 then Rs.R3 := localRecSet.Fields.Item[3].Value;
        if localRecSet.Fields.Item[1].Value + localRecSet.Fields.Item[2].Value +
         localRecSet.Fields.Item[3].Value > Rs.RT then Rs.RT := localRecSet.Fields.Item[1].Value +
         localRecSet.Fields.Item[2].Value + localRecSet.Fields.Item[3].Value;

        localRecSet.MoveNext;
        counter := counter + 1;
      end;
    end;
    localRecSet.Close;
    result := Rs;
end;

//Get the medium totalR, R1, R2, R3 values
function GetMedianRValues (analysisName: string) : RStat;
var
  queryStr: string;
  analysisID: integer;
  localRecSet: _RecordSet;
  counter, i: integer;
  Rs: RStat;
begin
//CC 2012-03-11
//get the median total R value for the selected analysis
    Initialize(Rs);
    Rs.R1 := 0.0;
    Rs.R2 := 0.0;
    Rs.R3 := 0.0;
    Rs.RT := 0.0;
    analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ') ORDER BY b.[R1]+ b.[R2] + b.[R3];';  // Group by sum of total R;';

    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);

    Rs.RT := 0.0;
    counter :=0 ;

    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      counter := 0;
      while not(localRecSet.EOF) do begin
        counter := counter + 1;
        localRecSet.MoveNext;
      end;
      localrecset.MoveFirst;
      if (counter mod 2 = 0) then begin
        for i := 0 to counter div 2 - 2 do begin
          localrecset.movenext;
        end;
        Rs.RT := localRecSet.Fields.Item[1].Value +
                  localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
        localrecset.MoveNext;
        Rs.RT := Rs.RT + localRecSet.Fields.Item[1].Value +
                  localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
        Rs.RT := Rs.RT / 2;
      end
      else begin
        for i := 0 to counter div 2 - 1 do localrecset.MoveNext;
        Rs.RT := localRecSet.Fields.Item[1].Value +
                  localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
      end;
    end else begin
      Rs.RT := 0;
    end;
    localRecSet.Close;

//get the median R1 value for the selected analysis
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ') ORDER BY b.[R1];';  // Group by sum of total R;';

    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);

    Rs.R1 := 0.0;
    counter :=0 ;

    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      counter := 0;
      while not(localRecSet.EOF) do begin
        counter := counter + 1;
        localRecSet.MoveNext;
      end;
      localrecset.MoveFirst;
      if (counter mod 2 = 0) then begin
        for i := 0 to counter div 2 - 2 do begin
          localrecset.movenext;
        end;
        Rs.R1 := localRecSet.Fields.Item[1].Value;
        localrecset.MoveNext;
        Rs.R1 := Rs.R1 + localRecSet.Fields.Item[1].Value;
        Rs.R1 := Rs.R1 / 2;
      end
      else begin
        for i := 0 to counter div 2 - 1 do localrecset.MoveNext;
        Rs.R1 := localRecSet.Fields.Item[1].Value;
      end;
    end else begin
      Rs.R1 := 0;
    end;
    localRecSet.Close;


//get the median R2 value for the selected analysis
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ') ORDER BY b.[R2];';  // Group by sum of total R;';

    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);

    Rs.R2 := 0.0;
    counter :=0 ;

    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      counter := 0;
      while not(localRecSet.EOF) do begin
        counter := counter + 1;
        localRecSet.MoveNext;
      end;
      localrecset.MoveFirst;
      if (counter mod 2 = 0) then begin
        for i := 0 to counter div 2 - 2 do begin
          localrecset.movenext;
        end;
        Rs.R2 := localRecSet.Fields.Item[2].Value;
        localrecset.MoveNext;
        Rs.R2 := Rs.R2 + localRecSet.Fields.Item[2].Value;
        Rs.R2 := Rs.R2 / 2;
      end
      else begin
        for i := 0 to counter div 2 - 1 do localrecset.MoveNext;
        Rs.R2 := localRecSet.Fields.Item[2].Value;
      end;
    end else begin
      Rs.R2 := 0;
    end;
    localRecSet.Close;

//get the median R3 value for the selected analysis
   queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ') ORDER BY b.[R3];';  // Group by sum of total R;';

    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);

    Rs.R3 := 0.0;
    counter :=0 ;

    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      counter := 0;
      while not(localRecSet.EOF) do begin
        counter := counter + 1;
        localRecSet.MoveNext;
      end;
      localrecset.MoveFirst;
      if (counter mod 2 = 0) then begin
        for i := 0 to counter div 2 - 2 do begin
          localrecset.movenext;
        end;
        Rs.R3 := localRecSet.Fields.Item[3].Value;
        localrecset.MoveNext;
        Rs.R3 := Rs.R3 + localRecSet.Fields.Item[3].Value;
        Rs.R3 := Rs.R3 / 2;
      end
      else begin
        for i := 0 to counter div 2 - 1 do localrecset.MoveNext;
        Rs.R3 := localRecSet.Fields.Item[3].Value;
      end;
    end else begin
      Rs.R3 := 0;
    end;
    localRecSet.Close;
    result := Rs;
end;

function GetTotalRValue(analysisName: string) : double;
var
  analysisID, i: integer;
  events: TStormEventCollection;
  myEventStatGetter: TEventStatGetter;
  runningR: double;
begin
//get observed R total
  runningR := 0.0;
  analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
  events := DatabaseModule.GetEvents(analysisID);
  if events.count > 0  then begin
    myEventStatGetter := TEventStatGetter.Create(analysisID);
    for i := 1 to events.count do begin
      myEventStatGetter.GetEventStats(i);
      runningR := runningR + myEventStatGetter.eventTotalR;
    end;
    myEventStatGetter.AllDone;
    runningR := runningR / events.count;
  end;
  result := runningR;
end;

//Get the 'average R2 + R3' combined total value
function GetAverageR2R3Value(analysisName: string) : double;
var
  queryStr: string;
  analysisID: integer;
  localRecSet: _RecordSet;
  counter: integer;
  Rs: RStat;
begin
//get the 'average R2 + R3' combined total value for the selected analysis
    Initialize(Rs);
    Rs.R1 := 0.0;
    Rs.R2 := 0.0;
    Rs.R3 := 0.0;
    Rs.RT := 0.0;//totalR := average R2 + R3
    analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ');'; // Group by a.AnalysisID;';
    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    counter :=0 ;
    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      while not localRecSet.EOF do begin
        Rs.RT := localRecSet.Fields.Item[2].Value + localRecSet.Fields.Item[3].Value;
        if localRecSet.Fields.Item[2].Value + localRecSet.Fields.Item[3].Value > Rs.R1
          then Rs.R1 := localRecSet.Fields.Item[2].Value + localRecSet.Fields.Item[3].Value;
        localRecSet.MoveNext;
        counter := counter + 1;
      end;
    end;
    localRecSet.Close;
    Rs.RT := Rs.RT / counter;  //average R2 + R2
    result := Rs.RT;
end;

//Get the 'peak' R2 + R3 value
function GetPeakR2R3Value(analysisName: string) : double;
var
  queryStr: string;
  analysisID: integer;
  localRecSet: _RecordSet;
  counter: integer;
  Rs: RStat;
begin
//get the peak R2 + R3 for the selected analysis
    Initialize(Rs);
    Rs.R1 := 0.0;
    Rs.R2 := 0.0;
    Rs.R3 := 0.0;
    Rs.RT := 0.0;//totalR := peak R2 + R3
    analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
                inttostr(analysisID) + ');'; // Group by a.AnalysisID;';
    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
    counter :=0 ;
    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      while not localRecSet.EOF do begin
        if localRecSet.Fields.Item[2].Value + localRecSet.Fields.Item[3].Value > Rs.RT
          then Rs.RT := localRecSet.Fields.Item[2].Value + localRecSet.Fields.Item[3].Value;
        localRecSet.MoveNext;
        counter := counter + 1;
      end;
    end;
    localRecSet.Close;
    result := Rs.RT;
end;

//Get the medium R2+R3 value
function GetMedianR2R3Value(analysisName: string) : double;
var
  queryStr: string;
  analysisID: integer;
  localRecSet: _RecordSet;
  counter, i: integer;
  Rs: RStat;
begin
//CC 2012-03-11
//get the median R2+R3 value for the selected analysis
    Initialize(Rs);
    Rs.R1 := 0.0;
    Rs.R2 := 0.0;
    Rs.R3 := 0.0;
    Rs.RT := 0.0;//totalR := median R2 + R3
    analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
    queryStr := 'SELECT a.AnalysisID, b.[R1], b.[R2], b.[R3], ' +
                ' a.StartDateTime, a.EndDateTime ' +
                ' FROM Events a inner join RTKPatterns b ' +
                ' on a.RTKPatternID = b.RTKPatternID ' +
                ' WHERE (a.AnalysisID = ' +
//                inttostr(analysisID) + ') ORDER BY b.[R1]+ b.[R2] + b.[R3];';  // Group by sum of total R;';
                inttostr(analysisID) + ') ORDER BY b.[R2] + b.[R3];';  // Group by sum of total R;';

    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);

    Rs.RT := 0.0;
    counter :=0 ;

    if not localRecSet.EOF then begin
      localRecSet.MoveFirst;
      counter := 0;
      while not(localRecSet.EOF) do begin
        counter := counter + 1;
        localRecSet.MoveNext;
      end;
      localrecset.MoveFirst;
      if (counter mod 2 = 0) then begin
        for i := 0 to counter div 2 - 2 do begin
          localrecset.movenext;
        end;
        Rs.RT := localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
        localrecset.MoveNext;
        Rs.RT := Rs.RT + localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
        Rs.RT := Rs.RT / 2;
      end
      else begin
        for i := 0 to counter div 2 - 1 do localrecset.MoveNext;
        Rs.RT := localRecSet.Fields.Item[2].Value +
                  localRecSet.Fields.Item[3].Value;
      end;
    end else begin
      Rs.RT := 0;
    end;
    localRecSet.Close;
    result := Rs.RT;
end;

function GetRDIIVolumePerSewerLength(analysisName: string) : RStat;
var
  analysisID, i, j: integer;
  events: TStormEventCollection;
  myEventStatGetter: TEventStatGetter;
  runningR: double;
  max, checkmax : double;
  RdiiData : array of double; //for storing all RDIIVolumePerLength then sort them to get median value
  sortedRdiiData : array of double;
  Rs: RStat;
begin
//get observed R total
    Initialize(Rs);
    Rs.R1 := 0.0;  //peak
    Rs.R2 := 0.0;  //Median RDII Volumer per linear feet
    Rs.R3 := 0.0;  //intentionally left = 0
    Rs.RT := 0.0;  //average
  runningR := 0.0;
  max := 0.0;
  analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
  events := DatabaseModule.GetEvents(analysisID);
  if events.count > 0  then begin
    setlength (RDIIdata, events.count);
    setlength (sortedRdiidata, events.count);
    myEventStatGetter := TEventStatGetter.Create(analysisID);
    for i := 1 to events.count do begin
      myEventStatGetter.GetEventStats(i);
      runningR := runningR + myEventStatGetter.RDIIgalperLF;
      rdiidata[i-1] := myEventStatGetter.RDIIgalperLF;
      if myEventStatGetter.RDIIgalperLF > max then
        max := myEventStatGetter.RDIIgalperLF;
    end;
    myEventStatGetter.AllDone;
    Rs.RT := runningR / events.count;  //average
    Rs.R1 := max;  //peak

    //Sort RDIIdata based on RDiIgalperLF and get the median value
    checkmax := 1000000;
    for i := 0 to events.Count - 1 do
    begin
      max := 0;
      for j := 0 to events.Count - 1 do begin
          if (rdiidata[j] > max) and (rdiidata[j] < checkmax) then begin
              max := rdiidata[j];
          end;
      end;
      sortedrdiidata[i] := max;
      checkmax := max;
    end;

    //Median RDII Volumer per linear feet
    if (events.count mod 2 = 0) then begin
      Rs.R2 := (sortedrdiidata[events.count div 2] + sortedrdiidata[events.count div 2 + 1])/2
    end else begin
      Rs.R2 := sortedrdiidata[events.count div 2];
    end;
  end;
  result := Rs;
end;

function GetRDIIPeakFlowPerArea(analysisName: string) : RStat;
var
  analysisID, i, j: integer;
  events: TStormEventCollection;
  myEventStatGetter: TEventStatGetter;
  runningR: double;
  runningRF: double;
  sewershedarea: double;
  max, checkmax : double;
  RdiiData : array of double; //for storing all RDIIVolumePerLength then sort them to get median value
  sortedRdiiData : array of double;
  Rs: RStat;

begin
//get observed R total
    Initialize(Rs);
    Rs.R1 := 0.0;  //Peak RDII peak per area
    Rs.R2 := 0.0;  //Median RDII Volume per area
    Rs.R3 := 0.0;  //intentionally left = 0
    Rs.RT := 0.0;  //Average RDII peak per area
  runningR := 0.0;
  max := 0.0;
  //runningRF := 0.0;
  analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
  events := DatabaseModule.GetEvents(analysisID);
  sewershedarea := DatabaseModule.GetAreaForAnalysis(analysisName);
  if sewershedarea > 0 then begin

  if events.count > 0  then begin
    setlength (RDIIdata, events.count);
    setlength (sortedRdiidata, events.count);
    myEventStatGetter := TEventStatGetter.Create(analysisID);
    for i := 1 to events.count do begin
      myEventStatGetter.GetEventStats(i);
      runningR := runningR + myEventStatGetter.peakIIFlow;
      rdiidata[i-1] := myEventStatGetter.peakIIFlow;
      if myEventStatGetter.peakIIFlow > max then
        max := myEventStatGetter.peakIIFlow;
    end;
    myEventStatGetter.AllDone;

    //Average RDII peak per area
    Rs.RT := runningR / events.count / sewershedarea;
    //Peak RDII peak per area
    Rs.R1 := max / sewershedarea;

   //Sort RDIIdata based on RDII peak flow per area and get the median value
    checkmax := 1000000;
    for i := 0 to events.Count - 1 do
    begin
      max := 0;
      for j := 0 to events.Count - 1 do begin
          if (rdiidata[j] > max) and (rdiidata[j] < checkmax) then begin
              max := rdiidata[j];
          end;
      end;
      sortedrdiidata[i] := max;
      checkmax := max;
    end;

    //Median RDII Volume per area
    if (events.count mod 2 = 0) then begin
      Rs.R2 := (sortedrdiidata[events.count div 2] + sortedrdiidata[events.count div 2 + 1])/2
    end else begin
      Rs.R2 := sortedrdiidata[events.count div 2];
    end;
  end;
  end;
  result := Rs;
end;

end.
