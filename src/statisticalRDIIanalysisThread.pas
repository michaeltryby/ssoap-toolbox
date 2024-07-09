unit statisticalRDIIanalysisThread;

interface

uses
  Classes, ADODB_TLB;

type
  statisticalanalysisThread = class(TThread)
    day: integer;
    analysisName, textToAdd: string;
    analysisID, meterID: integer;
    dailyAverage, average: real;
    AvgT1, AvgT2, AvgT3 : double;
    AvgK1, AvgK2, AvgK3 : double;
    ratioR1, ratioR2, ratioR3 : double;
    mediumR, averageR : double;
    eventCount : integer;
    tempMonthlyMediumR : double;
    monthlyMediumR : array[0..11] of double;

    constructor CreateIt(aName: string);
  private
    procedure GetAverageTK();
    procedure GetRratio();
    procedure GetMediumR();
    procedure GetAverageR();
    procedure GetMonthlyMediumR();

    {procedure GetAverageFlows();
    procedure OpenQuery();
    procedure GetNextRecord();
    procedure CloseAndFreeQuery();
    procedure GetDailyAverage();
    procedure AddGWIAdjustment();
    procedure UpdateStatus();}
    procedure AddToFeedbackMemo();
    procedure Feedback(line: string);
  protected
    procedure Execute; override;
  published
    destructor Destroy; override;
    //procedure SetAnalysisName(aName: string);
  end;

implementation

uses sysutils, windows, feedbackWithMemo, modDatabase,
     rdiiutils, mainform, chooseAnalysis;

constructor statisticalanalysisThread.CreateIt(aName: string);
begin
  inherited Create(true);      // Create thread suspended
  FreeOnTerminate := true;     // Thread Free Itself when terminated
  //rm 2011-03-15
  analysisName := aName;
  Suspended := false;          // Continue the thread
  eventcount := 0;
end;

destructor statisticalanalysisThread.Destroy;
begin
  PostMessage(frmFeedbackWithMemo.Handle,wm_ThreadDoneMsg,self.ThreadID,0);
  inherited destroy;
end;

procedure statisticalanalysisThread.Execute;
var
  value: real;
  i: integer;
  line: string;
  recSet : _RecordSet;
begin
  //rm 2011-03-15 analysisName := frmAnalysisSelector.SelectedAnalysis;

  analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);

  Feedback(analysisName);
  //Feedback(inttostr(AnalysisID));

  Synchronize(GetAverageTK);
  Synchronize(GetRratio);
  Synchronize(GetMediumR);
  Synchronize(GetAverageR);
  Synchronize(GetMonthlyMediumR);

  if eventCount < 1 then begin
    Feedback('NO EVENTS!');
    Feedback('');
  end;

  Feedback('Statistical Analysis Results ... ');
  Feedback('');
  line := 'Number of Events             :     ' + leftPad(inttostr(eventCount),5);
  feedback(line);
  //rm 2007-10-31 "MEDIAN" R - right?
  //line := 'Medium Total-R Value         :     ' + leftPad(floattostrF(MediumR*100,ffFixed,15,2),5) + '%     ';
  line := 'Median Total-R Value         :     ' + leftPad(floattostrF(MediumR*100,ffFixed,15,1),5) + '%     ';
  Feedback(line);
  line := 'Average Total-R Value        :     ' + leftPad(floattostrF(AverageR*100,ffFixed,15,1),5) + '%     ';
  Feedback(line);
  Feedback('');

  line := 'Distribution of RDII Response         (Fast,     Medium,      Slow)';
  Feedback(line);
  line := 'R-Value Distribution (ratio):         ';
  line := line + leftPad(floattostrF(ratioR1*100,ffFixed,15,1),5) + '%     ';
  line := line + leftPad(floattostrF(ratioR2*100,ffFixed,15,1),5) + '%     ';
  line := line + leftPad(floattostrF(ratioR3*100,ffFixed,15,1),5) + '%';
  Feedback(line);
  line := 'T-Value Distribution (actual value):  ';
  line := line + leftPad(floattostrF(avgT1,ffFixed,15,1),5) + '      ';
  line := line + leftPad(floattostrF(avgT2,ffFixed,15,1),5) + '      ';
  line := line + leftPad(floattostrF(avgT3,ffFixed,15,1),5) + '';
  Feedback(line);
  line := 'K-Value Distribution (actual value):  ';
  line := line + leftPad(floattostrF(avgK1,ffFixed,15,1),5) + '      ';
  line := line + leftPad(floattostrF(avgK2,ffFixed,15,1),5) + '      ';
  line := line + leftPad(floattostrF(avgK3,ffFixed,15,1),5) + '';
  Feedback(line);
  Feedback('');
  {line := 'Unit Hydrograph                       1          2         3';
  Feedback(line);
  line := 'Average R Distribution Ratio :     ';
  line := line + leftPad(floattostrF(ratioR1*100,ffFixed,15,2),5) + '%     ';
  line := line + leftPad(floattostrF(ratioR2*100,ffFixed,15,2),5) + '%     ';
  line := line + leftPad(floattostrF(ratioR3*100,ffFixed,15,2),5) + '%';
  Feedback(line);
  //rm 2007-10-31 - "Median" ?
  //line := 'Medium R Values              :     ';
  line := 'Median R Values              :     ';
  line := line + leftPad(floattostrF(MediumR*ratioR1*100,ffFixed,15,2),5) + '%     ';
  line := line + leftPad(floattostrF(MediumR*ratioR2*100,ffFixed,15,2),5) + '%     ';
  line := line + leftPad(floattostrF(MediumR*ratioR3*100,ffFixed,15,2),5) + '%';
  Feedback(line);
  line := 'Average R Values             :     ';
  line := line + leftPad(floattostrF(AverageR*ratioR1*100,ffFixed,15,2),5) + '%     ';
  line := line + leftPad(floattostrF(AverageR*ratioR2*100,ffFixed,15,2),5) + '%     ';
  line := line + leftPad(floattostrF(AverageR*ratioR3*100,ffFixed,15,2),5) + '%';
  Feedback(line);

  line := 'Average T Values             :     ';
  line := line + leftPad(floattostrF(avgT1,ffFixed,15,2),5) + '      ';
  line := line + leftPad(floattostrF(avgT2,ffFixed,15,2),5) + '      ';
  line := line + leftPad(floattostrF(avgT3,ffFixed,15,2),5) + '';
  Feedback(line);

  line := 'Average K Values             :     ';
  line := line + leftPad(floattostrF(avgK1,ffFixed,15,2),5) + '      ';
  line := line + leftPad(floattostrF(avgK2,ffFixed,15,2),5) + '      ';
  line := line + leftPad(floattostrF(avgK3,ffFixed,15,2),5) + '';
  Feedback(line);
  }

  line := 'RDII Representative Parameters           R1         R2         R3';
  Feedback(line);

  line := 'Using Median R-Value Method        :  ';
  line := line + leftPad(floattostrF(MediumR*ratioR1*100,ffFixed,15,1),5) + '%     ';
  line := line + leftPad(floattostrF(MediumR*ratioR2*100,ffFixed,15,1),5) + '%     ';
  line := line + leftPad(floattostrF(MediumR*ratioR3*100,ffFixed,15,1),5) + '%';
  Feedback(line);
  line := 'Using Average R-Value Method       :  ';
  line := line + leftPad(floattostrF(AverageR*ratioR1*100,ffFixed,15,1),5) + '%     ';
  line := line + leftPad(floattostrF(AverageR*ratioR2*100,ffFixed,15,1),5) + '%     ';
  line := line + leftPad(floattostrF(AverageR*ratioR3*100,ffFixed,15,1),5) + '%';
  Feedback(line);
  Feedback('');
  Feedback('');
  line := 'Monthly RDII Parameters (using Median R-Value):    ';
  Feedback(line);
  line := 'Month   Total-R    R1       R2       R3       T1         T2        T3         K1         K2         K3 ';
  Feedback(line);
  if (MonthlyMediumR[0]+MonthlyMediumR[0]+MonthlyMediumR[0]) = 0 then
    line := 'JAN    ' + 'No RDII data for this month'
  else begin
    line := 'JAN     ' + leftPad(floattostrF((MonthlyMediumR[0]*ratioR1+MonthlyMediumR[0]*ratioR2+MonthlyMediumR[0]*ratioR3)*100,ffFixed,15,1),5)+ '%  ';
    line := line + leftPad(floattostrF(MonthlyMediumR[0]*ratioR1*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[0]*ratioR2*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[0]*ratioR3*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(avgT1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT3,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK3,ffFixed,15,1),5) + '';
  end;
  Feedback(line);

  if (MonthlyMediumR[1]+MonthlyMediumR[1]+MonthlyMediumR[1]) = 0 then
    line := 'FEB    ' + 'No RDII data for this month'
  else begin
    line := 'FEB     ' + leftPad(floattostrF((MonthlyMediumR[1]*ratioR1+MonthlyMediumR[1]*ratioR2+MonthlyMediumR[1]*ratioR3)*100,ffFixed,15,1),5)+ '%  ';
    line := line + leftPad(floattostrF(MonthlyMediumR[1]*ratioR1*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[1]*ratioR2*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[1]*ratioR3*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(avgT1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT3,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK3,ffFixed,15,1),5) + '';
  end;
  Feedback(line);

  if (MonthlyMediumR[2]+MonthlyMediumR[2]+MonthlyMediumR[2]) = 0 then
      line := 'MAR    ' + 'No RDII data for this month'
  else begin
    line := 'MAR     ' + leftPad(floattostrF((MonthlyMediumR[2]*ratioR1+MonthlyMediumR[2]*ratioR2+MonthlyMediumR[2]*ratioR3)*100,ffFixed,15,1),5)+ '%  ';
    line := line + leftPad(floattostrF(MonthlyMediumR[2]*ratioR1*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[2]*ratioR2*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[2]*ratioR3*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(avgT1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT3,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK3,ffFixed,15,1),5) + '';
  end;
  Feedback(line);

  if (MonthlyMediumR[3]+MonthlyMediumR[3]+MonthlyMediumR[3]) = 0 then
    line := 'APR    ' + 'No RDII data for this month'
  else begin
    line := 'APR     ' + leftPad(floattostrF((MonthlyMediumR[3]*ratioR1+MonthlyMediumR[3]*ratioR2+MonthlyMediumR[3]*ratioR3)*100,ffFixed,15,1),5)+ '%  ';
    line := line + leftPad(floattostrF(MonthlyMediumR[3]*ratioR1*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[3]*ratioR2*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[3]*ratioR3*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(avgT1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT3,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK3,ffFixed,15,1),5) + '';
  end;
  Feedback(line);

  if (MonthlyMediumR[4]+MonthlyMediumR[4]+MonthlyMediumR[4]) = 0 then
    line := 'MAY    ' + 'No RDII data for this month'
  else begin
    line := 'MAY     ' + leftPad(floattostrF((MonthlyMediumR[4]*ratioR1+MonthlyMediumR[4]*ratioR2+MonthlyMediumR[4]*ratioR3)*100,ffFixed,15,1),5)+ '%  ';
    line := line + leftPad(floattostrF(MonthlyMediumR[4]*ratioR1*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[4]*ratioR2*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[4]*ratioR3*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(avgT1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT3,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK3,ffFixed,15,1),5) + '';
  end;
  Feedback(line);

  if (MonthlyMediumR[5]+MonthlyMediumR[5]+MonthlyMediumR[5]) = 0 then
    line := 'JUN    ' + 'No RDII data for this month'
  else begin
    line := 'JUN     ' + leftPad(floattostrF((MonthlyMediumR[5]*ratioR1+MonthlyMediumR[5]*ratioR2+MonthlyMediumR[5]*ratioR3)*100,ffFixed,15,1),5)+ '%  ';
    line := line + leftPad(floattostrF(MonthlyMediumR[5]*ratioR1*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[5]*ratioR2*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[5]*ratioR3*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(avgT1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT3,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK3,ffFixed,15,1),5) + '';
  end;
  Feedback(line);

  if (MonthlyMediumR[6]+MonthlyMediumR[6]+MonthlyMediumR[6]) = 0 then
    line := 'JUL    ' + 'No RDII data for this month'
  else begin
    line := 'JUL     ' + leftPad(floattostrF((MonthlyMediumR[6]*ratioR1+MonthlyMediumR[6]*ratioR2+MonthlyMediumR[6]*ratioR3)*100,ffFixed,15,1),5)+ '%  ';
    line := line + leftPad(floattostrF(MonthlyMediumR[6]*ratioR1*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[6]*ratioR2*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[6]*ratioR3*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(avgT1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT3,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK3,ffFixed,15,1),5) + '';
  end;
  Feedback(line);


  if (MonthlyMediumR[7]+MonthlyMediumR[7]+MonthlyMediumR[7]) = 0 then
    line := 'AUG    ' + 'No RDII data for this month'
  else begin
    line := 'AUG     ' + leftPad(floattostrF((MonthlyMediumR[7]*ratioR1+MonthlyMediumR[7]*ratioR2+MonthlyMediumR[7]*ratioR3)*100,ffFixed,15,1),5)+ '%  ';
    line := line + leftPad(floattostrF(MonthlyMediumR[7]*ratioR1*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[7]*ratioR2*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[7]*ratioR3*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(avgT1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT3,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK3,ffFixed,15,1),5) + '';
  end;
  Feedback(line);

  if (MonthlyMediumR[8]+MonthlyMediumR[8]+MonthlyMediumR[8]) = 0 then
    line := 'SEP    ' + 'No RDII data for this month'
  else begin
    line := 'SEP     ' + leftPad(floattostrF((MonthlyMediumR[8]*ratioR1+MonthlyMediumR[8]*ratioR2+MonthlyMediumR[8]*ratioR3)*100,ffFixed,15,1),5)+ '%  ';
    line := line + leftPad(floattostrF(MonthlyMediumR[8]*ratioR1*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[8]*ratioR2*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[8]*ratioR3*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(avgT1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT3,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK3,ffFixed,15,1),5) + '';
  end;
  Feedback(line);

  if (MonthlyMediumR[9]+MonthlyMediumR[9]+MonthlyMediumR[9]) = 0 then
    line := 'OCT    ' + 'No RDII data for this month'
  else begin
    line := 'OCT     ' + leftPad(floattostrF((MonthlyMediumR[9]*ratioR1+MonthlyMediumR[9]*ratioR2+MonthlyMediumR[9]*ratioR3)*100,ffFixed,15,1),5)+ '%  ';
    line := line + leftPad(floattostrF(MonthlyMediumR[9]*ratioR1*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[9]*ratioR2*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[9]*ratioR3*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(avgT1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT3,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK3,ffFixed,15,1),5) + '';
  end;
  Feedback(line);

  if (MonthlyMediumR[10]+MonthlyMediumR[10]+MonthlyMediumR[10]) = 0 then
    line := 'NOV    ' + 'No RDII data for this month'
  else begin
    line := 'NOV     ' + leftPad(floattostrF((MonthlyMediumR[10]*ratioR1+MonthlyMediumR[10]*ratioR2+MonthlyMediumR[10]*ratioR3)*100,ffFixed,15,1),5)+ '%  ';
    line := line + leftPad(floattostrF(MonthlyMediumR[10]*ratioR1*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[10]*ratioR2*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[10]*ratioR3*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(avgT1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT3,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK3,ffFixed,15,1),5) + '';
  end;
  Feedback(line);

  if (MonthlyMediumR[11]+MonthlyMediumR[11]+MonthlyMediumR[11]) = 0 then
    line := 'DEC    ' + 'No RDII data for this month'
  else begin
    line := 'DEC     ' + leftPad(floattostrF((MonthlyMediumR[11]*ratioR1+MonthlyMediumR[11]*ratioR2+MonthlyMediumR[11]*ratioR3)*100,ffFixed,15,1),5) + '%  ';
    line := line + leftPad(floattostrF(MonthlyMediumR[11]*ratioR1*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[11]*ratioR2*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(MonthlyMediumR[11]*ratioR3*100,ffFixed,15,1),5) + '%   ';
    line := line + leftPad(floattostrF(avgT1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgT3,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK1,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK2,ffFixed,15,1),5) + '      ';
    line := line + leftPad(floattostrF(avgK3,ffFixed,15,1),5) + '';
  end;
  Feedback(line);



  {
  line := 'FEB ' + leftPad(floattostrF(MonthlyMediumR[1]*100,ffFixed,15,2),5) + '%     ';
  Feedback(line);
  line := 'MAR ' + leftPad(floattostrF(MonthlyMediumR[2]*100,ffFixed,15,2),5) + '%     ';
  Feedback(line);
  line := 'APR ' + leftPad(floattostrF(MonthlyMediumR[3]*100,ffFixed,15,2),5) + '%     ';
  Feedback(line);
  line := 'MAY ' + leftPad(floattostrF(MonthlyMediumR[4]*100,ffFixed,15,2),5) + '%     ';
  Feedback(line);
  line := 'JUN ' + leftPad(floattostrF(MonthlyMediumR[5]*100,ffFixed,15,2),5) + '%     ';
  Feedback(line);
  line := 'JUL ' + leftPad(floattostrF(MonthlyMediumR[6]*100,ffFixed,15,2),5) + '%     ';
  Feedback(line);
  line := 'AUG ' + leftPad(floattostrF(MonthlyMediumR[7]*100,ffFixed,15,2),5) + '%     ';
  Feedback(line);
  line := 'SEP ' + leftPad(floattostrF(MonthlyMediumR[8]*100,ffFixed,15,2),5) + '%     ';
  Feedback(line);
  line := 'OCT ' + leftPad(floattostrF(MonthlyMediumR[9]*100,ffFixed,15,2),5) + '%     ';
  Feedback(line);
  line := 'NOV ' + leftPad(floattostrF(MonthlyMediumR[10]*100,ffFixed,15,2),5) + '%     ';
  Feedback(line);
  line := 'DEC ' + leftPad(floattostrF(MonthlyMediumR[11]*100,ffFixed,15,2),5) + '%     ';
  Feedback(line);
  }
  {Synchronize(RemoveAllGWIAdjustmentsForAnalysis);}
{  Feedback('Determing Weekday and Weekend Average Flows...');
  Synchronize(GetAverageFlows);
  Feedback('');
  Feedback('Calculating GWI adjustments for each DWF Day...');
}

  {  Synchronize(OpenQuery);
  adjustments := TGWIAdjustmentCollection.Create;
  while (not recSet.EOF) do begin
    day := trunc(recSet.Fields.Item[0].Value);
    Synchronize(UpdateStatus);
    Synchronize(GetDailyAverage);
    value := round((dailyAverage - average) * 1000.0) / 1000.0;
    adjustment := TGWIAdjustment.Create(day,value);
    adjustments.AddAdjustment(adjustment);
    Synchronize(GetNextRecord);
  end;
  Synchronize(CloseAndFreeQuery);
  Feedback('');
  Feedback('GWI Adj #     Date    Adjustment ('+flowUnitLabel+')');
  Feedback('--------------------------------------');
  for i := 0 to adjustments.count - 1 do begin
    adjustment := adjustments[i];
    Synchronize(AddGWIAdjustment);
    line := leftPad(inttostr(i+1),length(inttostr(adjustments.count)));
    line := line + '      ' + leftPad(datetostr(adjustment.Date),10);
    line := line + '      ' + leftPad(floattostrF(adjustment.value,ffFixed,15,3),8);
    Feedback(line);
  end;
  adjustments.Free;     }
end;





procedure statisticalanalysisThread.GetAverageTK();
var
  queryStr: string;
  localRecSet: _RecordSet;
begin
  //rm 2009-06-24 - redo queries with RTKs in RTKPatterns table
//  queryStr := 'SELECT Avg(Events.T1) AS AvgofT1 FROM Events ' +
//              'GROUP BY Events.AnalysisID ' +
//              'HAVING (((Events.AnalysisID) = ' + inttostr(analysisID) + '));';
  queryStr := 'SELECT Avg(r.T1) AS AvgofT1 FROM Events e inner join RTKPAtterns r on e.RTKPAtternID = r.RTKPAtternID ' +
              'WHERE (r.T1 is not null) GROUP BY e.AnalysisID ' +
              'HAVING (((e.AnalysisID) = ' + inttostr(analysisID) + '));';

  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if empty recordset
  if localRecSet.EOF then begin
    avgT1 := 0;
  end else begin
    localRecSet.MoveFirst;
    avgT1 := localRecSet.Fields.Item[0].Value;
  end;
  localRecSet.Close;

//  queryStr := 'SELECT Avg(Events.T2) AS AvgofT2 FROM Events ' +
//              'GROUP BY Events.AnalysisID ' +
//              'HAVING (((Events.AnalysisID) = ' + inttostr(analysisID) + '));';
  queryStr := 'SELECT Avg(r.T2) AS AvgofT2 FROM Events e inner join RTKPAtterns r on e.RTKPAtternID = r.RTKPAtternID ' +
              'WHERE (r.T2 is not null) GROUP BY e.AnalysisID ' +
              'HAVING (((e.AnalysisID) = ' + inttostr(analysisID) + '));';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if empty recordset
  if localRecSet.EOF then begin
    avgT2 := 0;
  end else begin
    localRecSet.MoveFirst;
    avgT2 := localRecSet.Fields.Item[0].Value;
  end;
  localRecSet.Close;

//  queryStr := 'SELECT Avg(Events.T3) AS AvgofT2 FROM Events ' +
//              'GROUP BY Events.AnalysisID ' +
//              'HAVING (((Events.AnalysisID) = ' + inttostr(analysisID) + '));';
  queryStr := 'SELECT Avg(r.T3) AS AvgofT3 FROM Events e inner join RTKPAtterns r on e.RTKPAtternID = r.RTKPAtternID ' +
              'WHERE (r.T3 is not null) GROUP BY e.AnalysisID ' +
              'HAVING (((e.AnalysisID) = ' + inttostr(analysisID) + '));';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if empty recordset
  if localRecSet.EOF then begin
    avgT3 := 0;
  end else begin
    localRecSet.MoveFirst;
    avgT3 := localRecSet.Fields.Item[0].Value;
  end;
  localRecSet.Close;

//  queryStr := 'SELECT Avg(Events.K1) AS AvgofK1 FROM Events ' +
//              'GROUP BY Events.AnalysisID ' +
//              'HAVING (((Events.AnalysisID) = ' + inttostr(analysisID) + '));';
  queryStr := 'SELECT Avg(r.K1) AS AvgofK1 FROM Events e inner join RTKPAtterns r on e.RTKPAtternID = r.RTKPAtternID ' +
              'WHERE (r.K1 is not null) GROUP BY e.AnalysisID ' +
              'HAVING (((e.AnalysisID) = ' + inttostr(analysisID) + '));';

  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if empty recordset
  if localRecSet.EOF then begin
    avgK1 := 0;
  end else begin
    localRecSet.MoveFirst;
    avgK1 := localRecSet.Fields.Item[0].Value;
  end;
  localRecSet.Close;

//  queryStr := 'SELECT Avg(Events.K2) AS AvgofK2 FROM Events ' +
//              'GROUP BY Events.AnalysisID ' +
//              'HAVING (((Events.AnalysisID) = ' + inttostr(analysisID) + '));';
  queryStr := 'SELECT Avg(r.K2) AS AvgofK2 FROM Events e inner join RTKPAtterns r on e.RTKPAtternID = r.RTKPAtternID ' +
              'WHERE (r.K2 is not null) GROUP BY e.AnalysisID ' +
              'HAVING (((e.AnalysisID) = ' + inttostr(analysisID) + '));';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if empty recordset
  if localRecSet.EOF then begin
    avgK2 := 0;
  end else begin
    localRecSet.MoveFirst;
    avgK2 := localRecSet.Fields.Item[0].Value;
  end;
  localRecSet.Close;

//  queryStr := 'SELECT Avg(Events.K3) AS AvgofK3 FROM Events ' +
//              'GROUP BY Events.AnalysisID ' +
//              'HAVING (((Events.AnalysisID) = ' + inttostr(analysisID) + '));';
  queryStr := 'SELECT Avg(r.K3) AS AvgofK3 FROM Events e inner join RTKPAtterns r on e.RTKPAtternID = r.RTKPAtternID ' +
              'WHERE (r.K3 is not null) GROUP BY e.AnalysisID ' +
              'HAVING (((e.AnalysisID) = ' + inttostr(analysisID) + '));';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if empty recordset
  if localRecSet.EOF then begin
    avgK3 := 0;
  end else begin
    localRecSet.MoveFirst;
    avgK3 := localRecSet.Fields.Item[0].Value;
  end;
  localRecSet.Close;


end;




procedure statisticalanalysisThread.GetRratio();
var
  queryStr: string;
  localRecSet: _RecordSet;
  counter : integer;
begin
//rm 2009-06-24 - RTKs are now in RTKPatterns table
//rm 2007-10-23 - causes an overflow when rs are 0 (events un-defined by user)
//  queryStr := 'SELECT Sum([R1]/([R1]+[R2]+[R3])) AS Expr1, ' +
//              ' Sum([R2]/([R1]+[R2]+[R3])) AS Expr2, ' +
//              ' Sum([R3]/([R1]+[R2]+[R3])) AS Expr3 ' +
//              ' FROM Events ' +
//              //rm 2007-10-23  Where ([r1]+[r2]+[r3] > 0)
//              ' Where ([r1]+[r2]+[r3] > 0) ' +
//              ' GROUP BY Events.AnalysisID ' +
//              ' HAVING (((Events.AnalysisID)= ' + inttostr(analysisID) + '));';
  queryStr := 'SELECT Sum(r.[R1]/(r.[R1]+r.[R2]+r.[R3])) AS Expr1, ' +
              ' Sum(r.[R2]/(r.[R1]+r.[R2]+r.[R3])) AS Expr2, ' +
              ' Sum(r.[R3]/(r.[R1]+r.[R2]+r.[R3])) AS Expr3 ' +
              ' FROM Events e inner join RTKPatterns r on e.RTKPatternID = r.RTKPatternID ' +
              //rm 2007-10-23  Where ([r1]+[r2]+[r3] > 0)
              ' Where (r.[r1]+r.[r2]+r.[r3] > 0) ' +
              ' GROUP BY e.AnalysisID ' +
              ' HAVING (((e.AnalysisID)= ' + inttostr(analysisID) + '));';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash if empty recordset
  if localRecSet.EOF then begin
    ratioR1 := 0;
    ratioR2 := 0;
    ratioR3 := 0;
  end else begin
    localRecSet.MoveFirst;
    ratioR1 := localRecSet.Fields.Item[0].Value;
    ratioR2 := localRecSet.Fields.Item[1].Value;
    ratioR3 := localRecSet.Fields.Item[2].Value;
  end;
  localRecSet.Close;


  queryStr := 'SELECT Events.AnalysisID FROM Events WHERE ((Events.AnalysisID) = ' +
              inttostr(analysisID) + ');';
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //rm 2007-10-18
  if not localRecSet.EOF then
    localRecSet.MoveFirst;
  counter := 0;
  while not(localRecSet.EOF) do begin
    counter := counter + 1;
    localRecSet.MoveNext;
  end;
  //rm 2007-10-18
  if counter > 0 then begin
    ratioR1 := ratioR1 / counter;
    ratioR2 := ratioR2 / counter;
    ratioR3 := ratioR3 / counter;
  end;
  eventCount := counter;
end;


{
procedure statisticalanalysisThread.SetAnalysisName(aName: string);
begin
  analysisName := aName;
end;
}

procedure statisticalanalysisThread.GetMediumR();
var
  queryStr: string;
  localRecSet: _RecordSet;
  counter : integer;
  i : integer;
begin
//rm 2009-06-24 - rtks are in the rtkpatterns table
//  queryStr := 'SELECT Events.AnalysisID, [R1]+[R2]+[R3] AS Expr1 ' +
//              'FROM Events WHERE (((Events.AnalysisID) = ' +
//              inttostr(analysisID) + ')) ORDER BY [R1]+[R2]+[R3];';
  queryStr := 'SELECT e.AnalysisID, r.[R1]+r.[R2]+r.[R3] AS Expr1 ' +
              ' FROM Events e inner join RTKPatterns r on e.RTKPatternID = r.RTKPatternID ' +
              ' WHERE (((e.AnalysisID) = ' +
              inttostr(analysisID) + ')) ORDER BY r.[R1]+r.[R2]+r.[R3];';

  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //rm 2007-10-18
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
      mediumR := localRecSet.Fields.Item[1].Value;
      localrecset.MoveNext;
      mediumR := mediumR + localRecSet.Fields.Item[1].Value;
      mediumR := mediumR / 2;
    end
    else begin
      for i := 0 to counter div 2 - 1 do localrecset.MoveNext;
      mediumR := localRecSet.Fields.Item[1].Value;
    end;
  end else begin
    mediumR := 0;
  end;
  localRecSet.Close;
end;



procedure statisticalanalysisThread.GetAverageR();
var
  queryStr: string;
  localRecSet: _RecordSet;
  counter : integer;
  i : integer;
  accumulatedTotalR : double;

begin
  accumulatedTotalR := 0;
  //rm 2009-06-24 - rtks are now in the rtkpatterns table
//  queryStr := 'SELECT Events.AnalysisID, [R1]+[R2]+[R3] AS Expr1 ' +
//              'FROM Events WHERE (((Events.AnalysisID) = ' +
//              inttostr(analysisID) + ')) ORDER BY [R1]+[R2]+[R3];';
  queryStr := 'SELECT e.AnalysisID, r.[R1]+r.[R2]+r.[R3] AS Expr1 ' +
              ' FROM Events e inner join RTKPatterns r on e.RTKPatternID = r.RTKPatternID ' +
              ' WHERE (((e.AnalysisID) = ' +
              inttostr(analysisID) + ')) ORDER BY r.[R1]+r.[R2]+r.[R3];';

  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //rm 2007-10-18 - prevent crash on empty recordset
  if localRecSet.EOF then begin
    averageR := 0;
  end else begin
    localRecSet.MoveFirst;
    counter := 0;
    while not(localRecSet.EOF) do begin
      counter := counter + 1;
      accumulatedTotalR := accumulatedTotalR + localRecSet.Fields.Item[1].Value;
      localRecSet.MoveNext;
    end;
    averageR := accumulatedTotalR / counter;
  end;
  localRecSet.Close;
end;

{procedure statisticalanalysisThread.OpenQuery();
var
  queryStr: string;
begin
  queryStr := 'SELECT DWFDate FROM DryWeatherFlowDays WHERE ' +
              '((MeterID = ' + inttostr(meterID) + ') AND (Include = True)) ' +
              'ORDER BY DWFDate;';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
end;

procedure statisticalanalysisThread.CloseAndFreeQuery();
begin
  recSet.Close;
end;

procedure statisticalanalysisThread.GetNextRecord();
begin
  recSet.MoveNext;
end;


procedure statisticalanalysisThread.UpdateStatus();
begin
  frmFeedbackWithMemo.DateLabel.caption := datetostr(day);
end;
}
procedure statisticalanalysisThread.AddToFeedbackMemo();
begin
  frmFeedbackWithMemo.feedbackMemo.Lines.Add(textToAdd);
end;

procedure statisticalanalysisThread.Feedback(line: string);
begin
  textToAdd := line;
  Synchronize(AddToFeedbackMemo);
end;



procedure statisticalanalysisThread.GetMonthlyMediumR();
var
  queryStr: string;
  localRecSet: _RecordSet;
  counter : integer;
  monthcounter : integer;
  i : integer;

begin
//rm 2009-06-24 - rtks are in the rtkpatterns table
//  queryStr := 'SELECT Events.AnalysisID, [R1]+[R2]+[R3] AS Expr1 ' +
//              'FROM Events WHERE (((Events.AnalysisID) = ' +
//              inttostr(analysisID) + ')) ORDER BY [R1]+[R2]+[R3];';


//  queryStr := 'SELECT e.AnalysisID, r.[R1]+r.[R2]+r.[R3] AS Expr1 ' +
//              ' FROM Events e inner join RTKPatterns r on e.RTKPatternID = r.RTKPatternID ' +
//              ' WHERE (((e.AnalysisID) = ' +
//              inttostr(analysisID) + ')) ORDER BY r.[R1]+r.[R2]+r.[R3];';





  for monthcounter := 1 to 12 do
  begin
    tempMonthlyMediumR := 0;
    counter := 0;
    queryStr := 'SELECT e.AnalysisID, e.StartDateTime, Month(e.StartDateTime) AS Mon, r.R1 + r.R2 + r.R3 as RTOTAL ' +
                ' FROM Events AS e INNER JOIN RTKPatterns AS r ON e.RTKPatternID = r.RTKPatternID ' +
                ' WHERE Month(e.StartDateTime) = ' +
                inttostr (monthcounter) + ' AND (((e.AnalysisID) = ' +
                inttostr(analysisID) + ')) ORDER by r.R1 + r.R2 + r.R3;';

    localRecSet := CoRecordSet.Create;
    localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);

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
        tempMonthlyMediumR := localRecSet.Fields.Item[3].Value;
        localrecset.MoveNext;
        tempMonthlyMediumR := tempMonthlyMediumR + localRecSet.Fields.Item[3].Value;
        tempMonthlyMediumR := tempMonthlymediumR / 2;
        monthlyMediumR[monthcounter-1] := tempMonthlyMediumR;
      end
      else begin
        for i := 0 to counter div 2 - 1 do localrecset.MoveNext;
        tempMonthlyMediumR := localRecSet.Fields.Item[3].Value;
        monthlyMediumR[monthcounter-1] := tempMonthlyMediumR;
      end;
    end else begin
      tempMonthlyMediumR := 0;
      monthlyMediumR[monthcounter-1] := tempMonthlyMediumR;
    end;
    localRecSet.Close;

  end;

  {
  localRecSet := CoRecordSet.Create;
  localRecSet.Open(queryStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
  //rm 2007-10-18
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
      mediumR := localRecSet.Fields.Item[1].Value;
      localrecset.MoveNext;
      mediumR := mediumR + localRecSet.Fields.Item[1].Value;
      mediumR := mediumR / 2;
    end
    else begin
      for i := 0 to counter div 2 - 1 do localrecset.MoveNext;
      mediumR := localRecSet.Fields.Item[1].Value;
    end;
  end else begin
    mediumR := 0;
  end;
  localRecSet.Close;
  }
end;



end.
