unit analysis;

interface

uses StormEventCollection;

type
  TAnalysis = class(TObject)
  private
    FName: string;
    FAnalysisID: integer;
    FDefaultR, FDefaultT, FDefaultK: array[0..2] of real;
    FBaseFlowRate: real;
//rm 2010-10-07 - now implementing arrays of initial abstraction terms
{
    FMaxDepressionStorage: real;
    FRateOfReduction: real;
    FInitialDepressionStorage: real;
}
    FMaxDepressionStorage: array[0..2] of double;
    FRateOfReduction: array[0..2] of double;
    FInitialDepressionStorage: array[0..2] of double;

    FRunningAverageDuration: real;
    FRaingaugeID: integer;
    FFlowMeterID: integer;

    procedure PutR (Index: integer; value: real);
    function GetR (Index: integer): real;
    procedure PutT (Index: integer; value: real);
    function GetT (Index: integer): real;
    procedure PutK (Index: integer; value: real);
    function GetK (Index: integer): real;
    function GetInitialDepressionStorage(Index: integer): double;
    function GetMaxDepressionStorage(Index: integer): double;
    function GetRateOfReduction(Index: integer): double;
    procedure PutInitialDepressionStorage(Index: integer; const Value: double);
    procedure PutMaxDepressionStorage(Index: integer; const Value: double);
    procedure PutRateOfReduction(Index: integer; const Value: double);

  public
    property AnalysisID: integer
      read FAnalysisID write FAnalysisID;
    property Name: string
      read FName write FName;
    property DefaultR[Index: integer]: real
      read GetR write PutR;
    property DefaultT[Index: integer]: real
      read GetT write PutT;
    property DefaultK[Index: integer]: real
      read GetK write PutK;
    property BaseFlowRate: real
      read FBaseFlowRate write FBaseFlowRate;
//rm 2010-10-07 - now implementing arrays of initial abstraction terms
{
    property MaxDepressionStorage: real
      read FMaxDepressionStorage write FMaxDepressionStorage;
    property RateOfReduction: real
      read FRateOfReduction write FRateOfReduction;
    property InitialDepressionStorage: real
      read FInitialDepressionStorage write FInitialDepressionStorage;
}
    property MaxDepressionStorage[Index: integer]: double
      read GetMaxDepressionStorage write PutMaxDepressionStorage;
    property RateOfReduction[Index: integer]: double
      read GetRateOfReduction write PutRateOfReduction;
    property InitialDepressionStorage[Index: integer]: double
      read GetInitialDepressionStorage write PutInitialDepressionStorage;

    property RunningAverageDuration: real
      read FRunningAverageDuration write FRunningAverageDuration;
    property RaingaugeID: integer
      read FRaingaugeID write FRaingaugeID;
    property FlowMeterID: integer
      read FFlowMeterID write FFlowMeterID;

  end;

implementation

procedure TAnalysis.PutR(index: integer; value: real);
begin
  FDefaultR[index] := value;
end;

function TAnalysis.GetMaxDepressionStorage(Index: integer): double;
begin
  GetMaxDepressionStorage := FMaxDepressionStorage[index];
end;

procedure TAnalysis.PutRateOfReduction(Index: integer; const Value: double);
begin
  FRateOfReduction[index] := Value;
end;

function TAnalysis.GetR(index: integer): real;
begin
  GetR := FDefaultR[index];
end;

function TAnalysis.GetRateOfReduction(Index: integer): double;
begin
  GetRateOfReduction := FRateOfReduction[Index];
end;

procedure TAnalysis.PutT(index: integer; value: real);
begin
  FDefaultT[index] := value;
end;

function TAnalysis.GetT(index: integer): real;
begin
  GetT := FDefaultT[index];
end;

procedure TAnalysis.PutInitialDepressionStorage(Index: integer;
  const Value: double);
begin
//rm 2010-10-13 - Oops - left the leading "F" off the variable name
//  InitialDepressionStorage[Index] := Value;
//resulting in a stack overflow
  FInitialDepressionStorage[Index] := Value;
end;

procedure TAnalysis.PutK(index: integer; value: real);
begin
  FDefaultK[index] := value;
end;

function TAnalysis.GetInitialDepressionStorage(Index: integer): double;
begin
  GetInitialDepressionStorage := FInitialDepressionStorage[Index];
end;

procedure TAnalysis.PutMaxDepressionStorage(Index: integer; const Value: double);
begin
  FMaxDepressionStorage[Index] := Value;
end;

function TAnalysis.GetK(index: integer): real;
begin
  GetK := FDefaultK[index];
end;


end.
 