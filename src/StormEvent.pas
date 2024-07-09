unit StormEvent;

interface

type
  TStormEvent = class(TObject)
    constructor Create(s,e : real; a : integer); overload;
  private
    FAnalysisID: integer;
    FMeterID: integer;
    FRaingaugeID: integer;
    FEventID: integer;

    FStart: real;
    FEnd: real;
    FRTKPatternID: integer;
    FR, FT, FK: array[0..2] of real;
    FAI, FAM, FAR: double;  //abstraction terms
    //rm 2010-09-29
    FAI2, FAM2, FAR2: double;  //abstraction terms
    FAI3, FAM3, FAR3: double;  //abstraction terms

    FRTKName, FRTKDescription: string;


    procedure PutR (Index: integer; value: real);
    function GetR (Index: integer): real;
    procedure PutT (Index: integer; value: real);
    function GetT (Index: integer): real;
    procedure PutK (Index: integer; value: real);
    function GetK (Index: integer): real;
//rm 2010-09-29   function GetAI: double;
//rm 2010-09-29    function GetAM: double;
//rm 2010-09-29    function GetAR: double;
    function GetAI(Index: integer): double;
    function GetAM(Index: integer): double;
    function GetAR(Index: integer): double;
//rm 2010-09-29    procedure SetAI(const Value: double);
//rm 2010-09-29    procedure SetAM(const Value: double);
//rm 2010-09-29    procedure SetAR(const Value: double);
    procedure SetAI(Index: integer; const Value: double);
    procedure SetAM(Index: integer; const Value: double);
    procedure SetAR(Index: integer; const Value: double);
    procedure SetRTKPatternDescription(const Value: string);
    procedure SetRTKPatternName(const Value: string);
    procedure SetRTKPatternID(const Value: integer);

  public
    property AnalysisID: integer
      read FAnalysisID write FAnalysisID;
    property EventID: integer
      read FEventID write FEventID;
    property StartDate: real
      read FStart write FStart;
    property EndDate: real
      read FEnd write FEnd;
    property RTKPatternID: integer read FRTKPatternID write SetRTKPatternID;
    property R[Index: integer]: real
      read GetR write PutR;
    property T[Index: integer]: real
      read GetT write PutT;
    property K[Index: integer]: real
      read GetK write PutK;
    property AI[Index: integer]: double read GetAI write SetAI;
    property AM[Index: integer]: double read GetAM write SetAM;
    property AR[Index: integer]: double read GetAR write SetAR;
    property RTKDesc: string read FRTKDescription write SetRTKPatternDescription;
    //rm 2009-06-09
    property RTKName: string read FRTKName write SetRTKPatternName;
    function duration(): real;
    function overlaps(secondEvent: TStormEvent): boolean;
    function overlapswtolerance(secondEvent: TStormEvent; tol: integer): boolean;
  end;


implementation
uses mainForm, moddatabase, ADODB_TLB;

//rm 2011-03-30 - modified to include AnalysisID
constructor TStormEvent.Create(s,e: real; a: integer);
var
  i: integer;
begin
  FStart := s;
  FEnd := e;
  FRTKPatternID := -1;
  for i := 0 to 2 do begin
    FR[i] := 0.0;
    FT[i] := 0.0;
    FK[i] := 0.0;
  end;
  FAI := 0.0;
  FAM := 0.0;
  FAR := 0.0;
  FAI2 := 0.0;
  FAM2 := 0.0;
  FAR2 := 0.0;
  FAI3 := 0.0;
  FAM3 := 0.0;
  FAR3 := 0.0;
  FRTKName := '';
  FRTKDescription := '';
  FAnalysisID := a;
  FMeterID := 0;
  FRaingaugeID := 0;
end;

procedure TStormEvent.PutR(index: integer; value: real);
begin
  FR[index] := value;
end;

function TStormEvent.GetR(index: integer): real;
begin
  GetR := FR[index];
end;

procedure TStormEvent.PutT(index: integer; value: real);
begin
  FT[index] := value;
end;

procedure TStormEvent.SetAI(Index: integer; const Value: double);
begin
  if Index = 1  then
       FAI := Value
  else if Index = 2 then
       FAI2 := Value
  else if Index = 3 then
       FAI3 := Value;
end;

procedure TStormEvent.SetAM(Index: integer; const Value: double);
begin
  if Index = 1  then
       FAM := Value
  else if Index = 2 then
       FAM2 := Value
  else if Index = 3 then
       FAM3 := Value;
end;

procedure TStormEvent.SetAR(Index: integer; const Value: double);
begin
  if Index = 1  then
       FAR := Value
  else if Index = 2 then
       FAR2 := Value
  else if Index = 3 then
       FAR3 := Value;
end;

procedure TStormEvent.SetRTKPatternDescription(const Value: string);
begin
  FRTKDescription := Value;
end;

procedure TStormEvent.SetRTKPatternName(const Value: string);
begin
  FRTKName := Value;
end;


procedure TStormEvent.SetRTKPatternID(const Value: integer);
begin
  FRTKPatternID := Value;
end;

function TStormEvent.GetT(index: integer): real;
begin
  GetT := FT[index];
end;

procedure TStormEvent.PutK(index: integer; value: real);
begin
  FK[index] := value;
end;

{
function TStormEvent.GetAI: double;
begin
  Result := FAI;
end;

function TStormEvent.GetAM: double;
begin
  Result := FAM;
end;

function TStormEvent.GetAR: double;
begin
  Result := FAR;
end;
}
function TStormEvent.GetAI(index: integer): double;
begin
  if index = 1 then
       Result := FAI
  else if index = 2 then
       Result := FAI2
  else if index = 3 then
       Result := FAI3;
end;

function TStormEvent.GetAM(index: integer): double;
begin
  if index = 1 then
       Result := FAM
  else if index = 2 then
       Result := FAM2
  else if index = 3 then
       Result := FAM3;
end;

function TStormEvent.GetAR(index: integer): double;
begin
  if index = 1 then
       Result := FAR
  else if index = 2 then
       Result := FAR2
  else if index = 3 then
       Result := FAR3;
end;

function TStormEvent.GetK(index: integer): real;
begin
  GetK := FK[index];
end;

function TStormEvent.duration(): real;
begin
  duration := FEnd - FStart;
end;

function TStormEvent.overlaps(secondEvent: TStormEvent): boolean;
begin
  overlaps := false;
  if (self.startDate >= secondEvent.startDate) and
     (self.startDate <= secondEvent.endDate) then overlaps := true;
  if (self.endDate >= secondEvent.startDate) and
     (self.endDate <= secondEvent.endDate) then overlaps := true;
end;

//New function 2011-03-28 to find overlapping events with an overlap tolerance
//tol in hours
function TStormEvent.overlapswtolerance(secondEvent: TStormEvent;
  tol: integer): boolean;
var toldays: double;
begin
  toldays := (tol)/24.0; //convert hours to days
  overlapswtolerance := false;
  if (self.startDate >= secondEvent.startDate - toldays) and
     (self.startDate <= secondEvent.endDate + toldays) then overlapswtolerance := true;
  if (self.endDate >= secondEvent.startDate - toldays) and
     (self.endDate <= secondEvent.endDate + toldays) then overlapswtolerance := true;
end;

end.
