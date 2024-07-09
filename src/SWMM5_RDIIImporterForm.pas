unit SWMM5_RDIIImporterForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, modDatabase, ADODB_TLB, Uutils, StdCtrls;

type
  TfrmSWMM5_RDIIImporter = class(TForm)
    Button1: TButton;
    EditSWMM5InputFileName: TEdit;
    LabelScenarioID: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    //FSWMM5InpFileName: string;
    //FScenarioID: integer;
    FTextFile: TextFile;
    SewerShedList: TStringList;
    HydrographList: TStringList;
    RaingageList: TStringList;
    TimeSeriesList: TStringList;
    SewerShedIDList: TStringList;
    RDIIAreaIDList: TStringList;
    RaingageIDList: TStringList;
    RaingageStartEndList: TStringList;
    RTKPatternIDList: TStringList;
    SewerShed_Raingauge_Mapping_List: TStringList;
    TokList: TStringList;
    NToks: Integer;
    flowunitlabel, sRainGaugeID: string;
    areaUnitID,rainUnitID: integer; //depends on flowunitlabel in the SWMM5 input file
    boOK: boolean;
    procedure Execute;
    procedure OpenSWMM5InpFile;
    procedure ReadOptionSection(S: string);
    procedure ReadRDIISection(S: string);
    procedure ReadHydrographSection_Pre_Ver_5020(S: string);
    procedure ReadRaingagesSection(S: string);
    procedure ReadTimeseriesSection(S: string);
    procedure CloseSWMM5InpFile;
    procedure AddSewerSheds;
    procedure AddRainGauges;
    procedure AddRTKPatterns;
    procedure AddRTKLinks;
    procedure AddRainfall;
    procedure GetRainGaugeID(strSewerShed:string);
    procedure UpdateRainGaugeStartEndDates;
    procedure UpdateScenarioFlowUnits;

    procedure ReadHydrographSection(S: string);
  public
    { Public declarations }
    FSWMM5InpFileName: string;
    FScenarioID: integer;
  end;

var
  frmSWMM5_RDIIImporter: TfrmSWMM5_RDIIImporter;

implementation
uses mainform;//, feedbackWithMemo;

{$R *.dfm}

{ TfrmSWMM5_RDIIImporter }

procedure TfrmSWMM5_RDIIImporter.AddRainfall;
var boResult, boFirstRecord: boolean;
    i,j: integer;
    sqlStr: string;
    recordsAffected: OleVariant;
    strTimeSeries,strRainGageID,strType,strFreq: string;
    fctr,freq,rain: double;
    sdate1,stime1,sdate2,stime2: string;
begin
  boResult := false;
  for i := 0 to RaingageList.Count - 1 do begin
    //addrainfallrecord - get raingageIDs first
    //timeseriesname, date, time, value
//    Uutils.Tokenize(RaingageList[i], TokList, Ntoks);
    Tokenize(RaingageList[i], TokList, Ntoks);
    if (Ntoks > 3) then begin
      fctr := 1.0;
      strType := TokList[3];
      if strType = 'INTENSITY' then try
        strFreq := TokList[1];
        if pos(':',strFreq) > 0 then
          strFreq := copy(strFreq,pos(':',strFreq)+1,1000);
        freq := strtoFloat(strFreq);
        fctr := freq / 60.0;
      except
        fctr:=1.0;
      end;
      strTimeSeries := TokList[2];
      strRainGageID := RainGageIDList[i];
      if (strtoint(strRainGageID) > -1) then begin
//rm 2007-11-26 - get first and last datetimes in this file for this raingauge
        sdate1 := '0';
        stime1 := '0';
        for j := 0 to TimeSeriesList.Count - 1 do begin
          Tokenize(TimeSeriesList[j], TokList, Ntoks);
          if TokList[0] = strTimeSeries then begin
            try
              if Length(sdate1) <= 1 then
                sdate1 := TokList[1];
              if Length(stime1) <= 1 then
                stime1 := TokList[2];
              sdate2 := TokList[1];
              stime2 := TokList[2];
            except
              sdate1 := '0';
              stime1 := '0';
              sdate2 := '0';
              stime2 := '0';
            end;
          end;
        end;
        sqlStr := 'Delete from Rainfall where (RainGaugeID = ' + strRainGageID + ')';
//rm 2007-11-26 add whereclause
if (Length(sDate1) > 1) then begin
        sqlStr := sqlStr + ' AND ([DateTime] BETWEEN #' + sdate1 + ' ' + stime1 +
        '# AND #' + sdate2 + ' ' + stime2 + '#)';
end;
Memo1.Lines.Add(sqlStr);
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
        for j := 0 to TimeSeriesList.Count - 1 do begin
          boFirstRecord := true; //always want to store first record - even if 0 rainfall
          //Uutils.Tokenize(TimeSeriesList[j], TokList, Ntoks);
          Tokenize(TimeSeriesList[j], TokList, Ntoks);
          if TokList[0] = strTimeSeries then begin
            try
              rain := strToFloat(TokList[3]);
            except
              rain := 0;
            end;
            if ((rain > 0) or boFirstRecord) then begin //store only non-zero values - much much faster
              boFirstRecord := false;
              //add a new record to Rainfall Table
              if fctr = 1.0 then begin
                sqlStr := 'Insert into Rainfall (RainGaugeID, [DateTime], Volume, Code) ' +
                          ' Values (' + strRainGageID + ',"' + TokList[1] + ' ' +
                          TokList[2] + '",' + TokList[3] + ',0);';
              end else try
                //rain := strToFloat(TokList[3]);
                rain := rain * fctr;
                sqlStr := 'Insert into Rainfall (RainGaugeID, [DateTime], Volume, Code) ' +
                          ' Values (' + strRainGageID + ',"' + TokList[1] + ' ' +
                          TokList[2] + '",' + floattoStr(rain) + ',0);';

              except
                sqlStr := 'Insert into Rainfall (RainGaugeID, [DateTime], Volume, Code) ' +
                          ' Values (' + strRainGageID + ',"' + TokList[1] + ' ' +
                          TokList[2] + '",' + TokList[3] + ',0);';
              end;
Memo1.Lines.Add(sqlStr);
              frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
            end;
          end;
        end;
      end;
      boResult := true;
    end;
  end;
  boOK := boResult;
end;

procedure TfrmSWMM5_RDIIImporter.AddRainGauges;
var boResult: boolean;
    i: integer;
    iRaingageID: integer;
    sqlStr: string;
    recordsAffected: OleVariant;
    strTimeStep: string;
begin
  boResult := false;
Memo1.Lines.Add(inttostr(RaingageList.Count) + ' raingauges');
  for i := 0 to RaingageList.Count - 1 do begin
    //addraingagerecord - get raingageIDs as we go
    //raingageList has raingagename, timestep, timeseriesname
Memo1.Lines.Add(RaingageList[i]);
    Uutils.Tokenize(RaingageList[i], TokList, Ntoks);
Memo1.Lines.Add('List(0) = ' + TokList[0]);
    if (Ntoks > 2) then begin
      strTimeStep := TokList[1];
      if pos(':',strTimeStep) > 0 then
        strTimeStep := copy(strTimeStep,pos(':',strTimeStep)+1,1000);
      iRaingageID := modDatabase.DatabaseModule.GetRaingaugeIDForName(TokList[0]);
      if iRaingageID < 0 then begin //add a new one
        sqlStr := 'INSERT INTO Raingauges (RaingaugeName,RaingaugeLocationX,' +
              'RaingaugeLocationY,RainUnitID,TimeStep,StartDateTime,' +
              'endDateTime) VALUES (' +
              '"' + TokList[0] + '",0,0,' + inttostr(rainUnitID) + ',' +
              strTimeStep + ',' +
              '2.0' + ',' +
              '2.0' + ');';
Memo1.Lines.Add(sqlStr);
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
        iRaingageID := modDatabase.DatabaseModule.GetRaingaugeIDForName(TokList[0]);
      end else begin //update existing one
        sqlStr := 'Update Raingauges set RaingaugeName = ' +
              '"' + TokList[0] + '", Timestep = ' +
              strTimeStep +
              ' Where RaingaugeID = ' + inttostr(iRaingageID);
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
      end;
      RaingageIDList.Add(inttostr(iRaingageID));
      boResult := true;
    end else begin
      RaingageIDList.Add('-1'); //placeholder for invalid entry
      boResult := false;
    end;
Memo1.Lines.Add(RaingageIDList[i] + ';' +RaingageList[i]);
  end;
  boOK := boResult;
end;

procedure TfrmSWMM5_RDIIImporter.AddRTKLinks;
//add a record to RTKLinks for each RTKPattern
var boResult: boolean;
    i, j, iRTKLinkID, iRTKPatternID, iSewershedID, iRDIIAreaID: integer;
    sqlStr, sSewerShedName, sRDIIAreaName: string;
    recordsAffected: OleVariant;
begin
  //hydname = sewershedname
  // scenarioID from frmmain
  // rtkpatternID from rtkpatternidlist where
  // raingaugeID from
  boResult := false;
  //for i := 0 to SewershedIDList.Count - 1 do begin
  for i := 0 to RDIIAreaIDList.Count - 1 do begin
    Uutils.Tokenize(SewerShedList[i], TokList, Ntoks);
    sSewerShedName := TokList[0];
    iSewerShedID := strtoint(SewershedIDList[i]);
    sRDIIAreaName := TokList[1];
    iRDIIAreaID := strtoint(RDIIAreaIDList[i]);
//    sRaingaugeID := GetRainGaugeID(sSewerShedName);
    GetRainGaugeID(sSewerShedName);
Memo1.Lines.Add('Sewershed ID: ' + SewerShedIDList[i] + ', ' + sSewerShedName);
    iRTKPatternID := -1;
    j := -1;
    repeat
      inc(j)
    until (j >= HydrographList.Count) or (
      (Length(HydrographList[j]) > Length(sSewerShedName))
      and
      (Copy(HydrographList[j],1,Length(sSewerShedName)) = sSewerShedName)
      and
      (RTKPatternIDList[j] <> '-1'));
    if (j < HydrographList.Count) then begin
      //add a new record to the RTKLinks table
      iRTKPatternID := strtoint(RTKPatternIDList[j]);
Memo1.Lines.Add(RTKPatternIDList[j] + ', ' +
  'RDIIAreaName = ' + sRDIIAreaName + ', ' +
  'SewerShedName = ' + sSewerShedName + ', ' + HydrographList[j]);
      sqlStr := 'INSERT into RTKLinks (SewerShedID, RDIIAreaID, ' +
                ' RTKPatternID, RaingaugeID, ScenarioID) ' +
                ' VALUES (' +
                //rm 2007-11-26 - set sewershedid = -1 where rdiiareaid > 0
                //inttostr(iSewerShedID) + ', ' +
                ' -1, ' +
                inttostr(iRDIIAreaID) + ', ' +
                RTKPatternIDList[j] + ', ' +
                sRaingaugeID + ', ' +
                inttostr(FScenarioID) + ');';
Memo1.Lines.Add(sqlStr);
      frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
    end;
  end;
  boResult := true;
  boOK := boResult;
end;


(*
procedure TfrmSWMM5_RDIIImporter.AddRTKPatterns;
var boResult: boolean;
    i, iRTKPatternID: integer;
    sqlStr, sRTKPAtternName: string;
    recordsAffected: OleVariant;
    //rm 2010-09-29
    sMon: string;
    iMon: integer;
    sResp: string;
    iResp, iRsp: string;
begin
  boResult := false;
  for i := 0 to HydrographList.Count - 1 do begin
    //add RTKPattern for those with >10 tokens in string
    //hydname, month, r1, t1, k1, r2, t2, k2, r3, t3, k3
    Uutils.Tokenize(HydrographList[i], TokList, Ntoks);
//    if (Ntoks > 10) then begin
    if (Ntoks = 6) then begin {ver 5020 style with no Initial Abstraction}
      sRTKPatternName := TokList[0];
      sMon := TokList[1];
      sResp := TokList[2];
      if (AnsiUpperCase(sResp) = 'SHORT') then
        iResp := '1'
      else if (AnsiUpperCase(sResp) = 'MEDIUM') then
        iResp := '2'
      else if (AnsiUpperCase(sResp) = 'LONG') then
        iResp := '3'
      else
        iResp := '-1';
      iMon := modDatabase.DatabaseModule.GetMonthNumberForName(sMon);
      iRTKPatternID := modDatabase.DatabaseModule.GetRTKPatternIDForNameAndMonth(sRTKPatternName, iMon);
      if iRTKPatternID < 0 then begin  //add a new record
          sqlStr := 'INSERT INTO RTKPatterns (RTKPatternName, Description, ' +
                  ' R' + iResp + ', T' + iResp + ', K' + iResp + ', Mon) VALUES ("' +
                  sRTKPatternName + '", "' + TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                  TokList[3] + ',' + TokList[4] + ',' + TokList[5] + ',' +
                  inttostr(iMon) + ');';
Memo1.Lines.Add(sqlStr);
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
        iRTKPatternID := modDatabase.DatabaseModule.GetRTKPatternIDForNameAndMonth(sRTKPatternName, iMon);
      end else begin //edit existing record
          sqlStr := 'UPDATE RTKPatterns SET ' +
                  ' R' + iResp + ' = ' + TokList[3] +
                  ', T' + iResp + ' = ' + TokList[4] +
                  ', K' + iResp + ' = ' + TokList[5];
Memo1.Lines.Add(sqlStr);
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
        iRTKPatternID := modDatabase.DatabaseModule.GetRTKPatternIDForNameAndMonth(sRTKPatternName, iMon);
      end;
    end else if (Ntoks = 9) then begin {ver 5020 style with Initial Abstraction}
      sRTKPatternName := TokList[0];
      sMon := TokList[1];
      sResp := TokList[2];
      if (AnsiUpperCase(sResp) = 'SHORT') then
        iResp := '1'
      else if (AnsiUpperCase(sResp) = 'MEDIUM') then
        iResp := '2'
      else if (AnsiUpperCase(sResp) = 'LONG') then
        iResp := '3'
      else
        iResp := '-1';
      //rm 2010-09-29 - no "1" on initial abstraction field names
      iRsp := iResp;
      if iResp = '1' then iRsp := '';
      iMon := modDatabase.DatabaseModule.GetMonthNumberForName(sMon);
      iRTKPatternID := modDatabase.DatabaseModule.GetRTKPatternIDForNameAndMonth(sRTKPatternName, iMon);
      if iRTKPatternID < 0 then begin  //add a new record
          sqlStr := 'INSERT INTO RTKPatterns (RTKPatternName, Description, ' +
                  ' R' + iResp + ', T' + iResp + ', K' + iResp +
                  ' AM' + iRsp + ', AR' + iRsp + ', AI' + iRsp +
                  ', Mon) VALUES ("' +
                  sRTKPatternName + '", "' + TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                  TokList[3] + ',' + TokList[4] + ',' + TokList[5] + ',' +
                  TokList[6] + ',' + TokList[7] + ',' + TokList[8] + ',' +
                  inttostr(iMon) + ');';
Memo1.Lines.Add(sqlStr);
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
        iRTKPatternID := modDatabase.DatabaseModule.GetRTKPatternIDForNameAndMonth(sRTKPatternName, iMon);
      end else begin //edit existing record
          sqlStr := 'UPDATE RTKPatterns SET ' +
                  ' R' + iResp + ' = ' + TokList[3] +
                  ', T' + iResp + ' = ' + TokList[4] +
                  ', K' + iResp + ' = ' + TokList[5] +
                  ', AM' + iRsp + ' = ' + TokList[6] +
                  ', AR' + iRsp + ' = ' + TokList[7] +
                  ', AI' + iRsp + ' = ' + TokList[8];
Memo1.Lines.Add(sqlStr);
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
        iRTKPatternID := modDatabase.DatabaseModule.GetRTKPatternIDForNameAndMonth(sRTKPatternName, iMon);
      end;
    end else if (Ntoks > 10) then begin
      sRTKPatternName := TokList[0];
      sMon := TokList[1];
      iMon := modDatabase.DatabaseModule.GetMonthNumberForName(sMon);
//rm 2010-09-29      iRTKPatternID := modDatabase.DatabaseModule.GetRTKPatternIDForName(sRTKPatternName);
      iRTKPatternID := modDatabase.DatabaseModule.GetRTKPatternIDForNameAndMonth(sRTKPatternName, iMon);
      if iRTKPatternID < 0 then begin  //add a new record
        if TokList.Count > 13 then //include Abstraction Terms
          sqlStr := 'INSERT INTO RTKPatterns (RTKPatternName, Description, ' +
                  ' R1, T1, K1, R2, T2, K2, R3, T3, K3, ' +
                  ' AM, AR, AI) VALUES ("' +
                  sRTKPatternName + '", "' + TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                  TokList[2] + ',' + TokList[3] + ',' + TokList[4] + ',' +
                  TokList[5] + ',' + TokList[6] + ',' + TokList[7] + ',' +
                  TokList[8] + ',' + TokList[9] + ',' + TokList[10] + ',' +
                  TokList[11] + ',' + TokList[12] + ',' + TokList[13] + ');'
        else //no Abstraction Terms
          sqlStr := 'INSERT INTO RTKPatterns (RTKPatternName, Description, ' +
                  ' R1, T1, K1, R2, T2, K2, R3, T3, K3) VALUES ("' +
                  sRTKPatternName + '", "' + TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                  TokList[2] + ',' + TokList[3] + ',' + TokList[4] + ',' +
                  TokList[5] + ',' + TokList[6] + ',' + TokList[7] + ',' +
                  TokList[8] + ',' + TokList[9] + ',' + TokList[10] + ');';
Memo1.Lines.Add(sqlStr);
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
        iRTKPatternID := modDatabase.DatabaseModule.GetRTKPatternIDForNameAndMonth(sRTKPatternName, iMon);
      end else begin //edit the existing record
        if TokList.Count > 13 then //include Abstraction Terms
          sqlStr := 'UPDATE RTKPatterns set Description = "' +
                  TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                  ' R1 = ' + TokList[2] + ',' +
                  ' T1 = ' + TokList[3] + ',' +
                  ' K1 = ' + TokList[4] + ',' +
                  ' R2 = ' + TokList[5] + ',' +
                  ' T2 = ' + TokList[6] + ',' +
                  ' K2 = ' + TokList[7] + ',' +
                  ' R3 = ' + TokList[8] + ',' +
                  ' T3 = ' + TokList[9] + ',' +
                  ' K3 = ' + TokList[10] + ',' +
                  ' AM = ' + TokList[11] + ',' +
                  ' AR = ' + TokList[12] + ',' +
                  ' AI = ' + TokList[13] +
                  ' WHERE RTKPatternID = ' + inttostr(iRTKPatternID) + ';'
        else
          sqlStr := 'UPDATE RTKPatterns set Description = "' +
                  TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                  ' R1 = ' + TokList[2] + ',' +
                  ' T1 = ' + TokList[3] + ',' +
                  ' K1 = ' + TokList[4] + ',' +
                  ' R2 = ' + TokList[5] + ',' +
                  ' T2 = ' + TokList[6] + ',' +
                  ' K2 = ' + TokList[7] + ',' +
                  ' R3 = ' + TokList[8] + ',' +
                  ' T3 = ' + TokList[9] + ',' +
                  ' K3 = ' + TokList[10] +
                  ' WHERE RTKPatternID = ' + inttostr(iRTKPatternID) + ';';
Memo1.Lines.Add(sqlStr);
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
      end;
Memo1.Lines.Add(sqlStr);
      //frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
      RTKPatternIDList.Add(inttostr(iRTKPatternID));
      boResult := true;
    end else begin //placeholder
      RTKPatternIDList.Add('-1');
      boResult := false;
    end;
  end;
  boOK := boResult;
end;
*)
procedure TfrmSWMM5_RDIIImporter.AddRTKPatterns;
//rm 2010-09-28 revised to accommodate new SWMM5 format with Initial Abstraction terms for each component set of RTKs
{
;;SWMM5 Version 5.0.13 [Hydrographs] Section Format Example:
[HYDROGRAPHS]
;;              	Rain Gage/      
;;Name          	Month           	R1      	T1      	K1      	R2      	T2      	K2      	R3      	T3      	K3      	IA_max  	IA_rec  	IA_init 
;;--------------	----------------	--------	--------	--------	--------	--------	--------	--------	--------	--------	--------	--------	--------
A-62              A-62
A-62              Jan             	0.019   	0.25    	1.5     	0.032   	0.5     	6       	0.061   	3       	10      	0       	0       	0
A-62              Feb             	0.011   	0.25    	1.5     	0.018   	0.5     	6       	0.046   	3       	10      	0       	0       	0
A-62              Mar             	0.011   	0.25    	1.5     	0.025   	0.5     	5       	0.049   	3       	10      	0       	0       	0
A-62              Apr             	0.007   	0.25    	1.5     	0.007   	0.5     	5       	0.026   	3       	10      	0       	0       	0
A-62              May             	0.007   	0.25    	1.5     	0.011   	0.5     	4       	0.034   	3       	10      	0       	0       	0
A-62              Jun             	0.003   	0.25    	1.5     	0.005   	0.5     	5       	0.019   	3       	10      	0       	0       	0
A-62              Jul             	0.002   	0.25    	1.5     	0.002   	0.5     	5       	0.015   	3       	10      	0       	0       	0
A-62              Aug             	0.002   	0.25    	1.5     	0.002   	0.5     	5       	0.007   	3       	10      	0       	0       	0
A-62              Sep             	0.003   	0.25    	1.25    	0.002   	0.5     	5       	0.011   	3       	10      	0       	0       	0
A-62              Oct             	0.006   	0.25    	1.5     	0.003   	0.5     	5       	0.015   	3       	10      	0       	0       	0
A-62              Nov             	0.015   	0.25    	1.5     	0.012   	0.5     	5       	0.027   	3       	10      	0       	0       	0
A-62              Dec             	0.012   	0.25    	1.5     	0.019   	0.5     	5       	0.034   	3       	10      	0       	0       	0       

;;SWMM5 Version 5.0.20 [Hydrographs] Section Format Example:
[HYDROGRAPHS]
;;               Rain Gage/      
;;Name           Month            Response R        T        K        IA_max   IA_rec   IA_ini  
;;-------------- ---------------- -------- -------- -------- -------- -------- -------- --------
LO_O01_S         GAGEO01S        
LO_O01_S         Jan              Short    0.001    0.5      1        0        0        0       
LO_O01_S         Jan              Medium   0.001    2.5      2.75     0        0        0       
LO_O01_S         Jan              Long     0.31     4.25     2.75     0        0        0       
LO_O01_S         Feb              Short    0.001    0.5      1        0        0        0       
LO_O01_S         Feb              Medium   0.15     2.5      2        0        0        0       
LO_O01_S         Feb              Long     0.35     5.5      4        0        0        0       
LO_O01_S         Mar              Short    0.001    0.25     1.25     0        0        0       
LO_O01_S         Mar              Medium   0.008    1        2.75     0        0        0       
LO_O01_S         Mar              Long     0.026    3        3        0        0        0       
LO_O01_S         Apr              Short    0.001    0.5      0.75     0        0        0
LO_O01_S         Apr              Medium   0.012    2        2.25     0        0        0       
LO_O01_S         Apr              Long     0.037    5.25     3.75     0        0        0       
LO_O01_S         May              Short    0.001    0.25     1        0        0        0       
LO_O01_S         May              Medium   0.007    1        1.5      0        0        0       
LO_O01_S         May              Long     0.021    3.5      2.5      0        0        0       
LO_O01_S         Jun              Short    0.001    0.25     2.5      0        0        0       
LO_O01_S         Jun              Medium   0.002    1        3        0        0        0       
LO_O01_S         Jun              Long     0.012    4.5      4        0        0        0       
LO_O01_S         Jul              Short    0.001    0.25     0.75     0        0        0       
LO_O01_S         Jul              Medium   0.003    0.75     2        0        0        0       
LO_O01_S         Jul              Long     0.011    3        1.75     0        0        0       
LO_O01_S         Aug              Short    0.001    0.25     0.75     0        0        0       
LO_O01_S         Aug              Medium   0.005    0.75     2        0        0        0       
LO_O01_S         Aug              Long     0.015    1.75     3        0        0        0       
LO_O01_S         Sep              Short    0.001    0.25     1        0        0        0       
LO_O01_S         Sep              Medium   0.007    0.5      1.5      0        0        0       
LO_O01_S         Sep              Long     0.019    2.25     2.75     0        0        0       
LO_O01_S         Oct              Short    0.001    0.5      0.75     0        0        0       
LO_O01_S         Oct              Medium   0.008    2.25     1.25     0        0        0       
LO_O01_S         Oct              Long     0.045    3.75     3        0        0        0       
LO_O01_S         Nov              Short    0.001    0.5      0.75     0        0        0       
LO_O01_S         Nov              Medium   0.002    2        2.5      0        0        0       
LO_O01_S         Nov              Long     0.018    5        2.5      0        0        0       
LO_O01_S         Dec              Short    0.001    0.5      1        0        0        0       
LO_O01_S         Dec              Medium   0.005    2        3.25     0        0        0       
LO_O01_S         Dec              Long     0.22     3        3.5      0        0        0       
}
var boResult: boolean;
    i, j, iRTKPatternID, iMon, iResp: integer;
    sqlStr, sRTKPAtternName, sMon, sResp: string;
    recordsAffected: OleVariant;
begin
  boResult := false;
  for i := 0 to HydrographList.Count - 1 do begin
    //add RTKPattern for those with >2 tokens in string
    //hydname, month, r1, t1, k1, r2, t2, k2, r3, t3, k3
    //Uutils.Tokenize(HydrographList[i], TokList, Ntoks);
    Tokenize(HydrographList[i], TokList, Ntoks);
//MessageDlg('"' + HydrographList[i] + '"', mtInformation, [mbok], 0);
//for j := 0 to TokList.Count - 1 do
//MessageDlg(inttostr(j) + ': ' + TokList[j], mtInformation, [mbok],0);

    if (Ntoks > 2) then begin
      sRTKPatternName := TokList[0];
      sMon := TokList[1];
      iMon := modDatabase.DatabaseModule.GetMonthNumberForName(sMon);
      //get the "Response" (Short/Medium/Long)
      sResp := TokList[2];
      iResp := modDatabase.DatabaseModule.GetRTKPatternNumberForResponseName(sResp);
      //rm 2010-10-05 - if sResp ain't "Short" "Medium" or "Long" then this is an older format
      if (iResp > 0) then begin //iResp = -1 if sResp NOT IN ("Short", "Medium", "Long")
        iRTKPatternID := modDatabase.DatabaseModule.GetRTKPatternIDForNameAndMonth(sRTKPatternName, iMon);
        if iRTKPatternID < 0 then begin  //add a new record
          if TokList.Count > 6 then begin //include Abstraction Terms
            if (iResp = 1) then begin
              sqlStr := 'INSERT INTO RTKPatterns (RTKPatternName, Description, ' +
                  ' R1, T1, K1, AM, AR, AI, MON) VALUES ("' +
                  sRTKPatternName + '", "' + TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                  TokList[3] + ',' + TokList[4] + ',' + TokList[5] + ',' +
                  TokList[6] + ',' + TokList[7] + ',' + TokList[8] + ',' + inttostr(iMon) + ');'
            end else begin
              sqlStr := 'INSERT INTO RTKPatterns (RTKPatternName, Description, ' +
                  ' R' + inttostr(iResp) + ', T' + inttostr(iResp) + ', K' + inttostr(iResp) +', ' +
                  ' AM' + inttostr(iResp) + ', AR' + inttostr(iResp) + ', AI' + inttostr(iResp) + ', MON) VALUES ("' +
                  sRTKPatternName + '", "' + TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                  TokList[3] + ',' + TokList[4] + ',' + TokList[5] + ',' +
                  TokList[6] + ',' + TokList[7] + ',' + TokList[8] + ',' + inttostr(iMon) + ');';
            end; //if (iResp = 1)
          end else begin //no Abstraction Terms
              sqlStr := 'INSERT INTO RTKPatterns (RTKPatternName, Description, ' +
                  ' R' + inttostr(iResp) + ', T' + inttostr(iResp) + ', K' + inttostr(iResp) +', MON) ' +
                  ' VALUES ("' +
                  sRTKPatternName + '", "' + TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                  TokList[3] + ',' + TokList[4] + ',' + TokList[5] + ',' + inttostr(iMon) + ');';
          end; //if TokList.Count > 6
        end {if iRTKPatternID < 0} else begin //edit the existing record
          if TokList.Count > 6 then begin //include Abstraction Terms
            if (iResp = 1) then begin
              sqlStr := 'UPDATE RTKPatterns set Description = "' +
                  TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                  ' R1 = ' + TokList[3] + ',' +
                  ' T1 = ' + TokList[4] + ',' +
                  ' K1 = ' + TokList[5] + ',' +
                  ' AM = ' + TokList[6] + ',' +
                  ' AR = ' + TokList[7] + ',' +
                  ' AI = ' + TokList[8] +
                  ' WHERE RTKPatternID = ' + inttostr(iRTKPatternID) +
                  ' AND MON = ' + inttostr(iMon) + ';';
            end else begin
              sqlStr := 'UPDATE RTKPatterns set Description = "' +
                  TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                  ' R' + inttostr(iResp) + ' = ' + TokList[3] + ',' +
                  ' T' + inttostr(iResp) + ' = ' + TokList[4] + ',' +
                  ' K' + inttostr(iResp) + ' = ' + TokList[5] + ',' +
                  ' AM' + inttostr(iResp) + ' = ' + TokList[6] + ',' +
                  ' AR' + inttostr(iResp) + ' = ' + TokList[7] + ',' +
                  ' AI' + inttostr(iResp) + ' = ' + TokList[8] +
                  ' WHERE RTKPatternID = ' + inttostr(iRTKPatternID) +
                  ' AND MON = ' + inttostr(iMon) + ';';
            end;
          end else begin //no abstraction terms
              sqlStr := 'UPDATE RTKPatterns set Description = "' +
                  TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                  ' R' + inttostr(iResp) + ' = ' + TokList[3] + ',' +
                  ' T' + inttostr(iResp) + ' = ' + TokList[4] + ',' +
                  ' K' + inttostr(iResp) + ' = ' + TokList[5] +
                  ' WHERE RTKPatternID = ' + inttostr(iRTKPatternID) +
                  ' AND MON = ' + inttostr(iMon) + ';';
          end;
        end; //if iRTKPatternID < 0
        //FeedbackLine := sqlStr;
        //Synchronize(AddFeedback);
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
        RTKPatternIDList.Add(inttostr(iRTKPatternID));
        boResult := true;
      end {if (iResp > 0)} else begin //OLD Format - R1 T1 K1 R2 T2 K2 R3 T3 K3 AM AR AI - all on same line
        //iRTKPatternID := modDatabase.DatabaseModule.GetRTKPatternIDForName_(sRTKPatternName);
        iRTKPatternID := modDatabase.DatabaseModule.GetRTKPatternIDForNameAndMonth(sRTKPatternName, iMon);
        if iRTKPatternID < 0 then begin  //add a new record
          if TokList.Count > 13 then //include Abstraction Terms
            sqlStr := 'INSERT INTO RTKPatterns (RTKPatternName, Description, ' +
                    ' R1, T1, K1, R2, T2, K2, R3, T3, K3, ' +
                    ' AM, AR, AI, Mon) VALUES ("' +
                    sRTKPatternName + '", "' + TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                    TokList[2] + ',' + TokList[3] + ',' + TokList[4] + ',' +
                    TokList[5] + ',' + TokList[6] + ',' + TokList[7] + ',' +
                    TokList[8] + ',' + TokList[9] + ',' + TokList[10] + ',' +
                    TokList[11] + ',' + TokList[12] + ',' + TokList[13] + ',' +
                    inttostr(iMon) + ');'
          else //no Abstraction Terms
//for j := 0 to 10 do
//MessageDlg(inttostr(j) + ': ' + TokList[j], mtInformation, [mbok],0);

            sqlStr := 'INSERT INTO RTKPatterns (RTKPatternName, Description, ' +
                    ' R1, T1, K1, R2, T2, K2, R3, T3, K3) VALUES ("' +
                    sRTKPatternName + '", "' + TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                    TokList[2] + ',' + TokList[3] + ',' + TokList[4] + ',' +
                    TokList[5] + ',' + TokList[6] + ',' + TokList[7] + ',' +
                    TokList[8] + ',' + TokList[9] + ',' + TokList[10] + ', ' +
                    inttostr(iMon) + ');';
          frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
          //iRTKPatternID := modDatabase.DatabaseModule.GetRTKPatternIDForName_(sRTKPatternName);
          iRTKPatternID := modDatabase.DatabaseModule.GetRTKPatternIDForNameAndMonth(sRTKPatternName, iMon);
        end else begin //edit the existing record
          if TokList.Count > 13 then //include Abstraction Terms
            sqlStr := 'UPDATE RTKPatterns set Description = "' +
                    TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                    ' R1 = ' + TokList[2] + ',' +
                    ' T1 = ' + TokList[3] + ',' +
                    ' K1 = ' + TokList[4] + ',' +
                    ' R2 = ' + TokList[5] + ',' +
                    ' T2 = ' + TokList[6] + ',' +
                    ' K2 = ' + TokList[7] + ',' +
                    ' R3 = ' + TokList[8] + ',' +
                    ' T3 = ' + TokList[9] + ',' +
                    ' K3 = ' + TokList[10] + ',' +
                    ' AM = ' + TokList[11] + ',' +
                    ' AR = ' + TokList[12] + ',' +
                    ' AI = ' + TokList[13] +
                    ' WHERE RTKPatternID = ' + inttostr(iRTKPatternID) + //';'
                    ' AND MON = ' + inttostr(iMon) + ';'
          else
            sqlStr := 'UPDATE RTKPatterns set Description = "' +
                    TokList[1] + ' from ' + FSWMM5InpFileName + '", ' +
                    ' R1 = ' + TokList[2] + ',' +
                    ' T1 = ' + TokList[3] + ',' +
                    ' K1 = ' + TokList[4] + ',' +
                    ' R2 = ' + TokList[5] + ',' +
                    ' T2 = ' + TokList[6] + ',' +
                    ' K2 = ' + TokList[7] + ',' +
                    ' R3 = ' + TokList[8] + ',' +
                    ' T3 = ' + TokList[9] + ',' +
                    ' K3 = ' + TokList[10] +
                    ' WHERE RTKPatternID = ' + inttostr(iRTKPatternID) + //';';
                    ' AND MON = ' + inttostr(iMon) + ';';
          frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
        end;
        //frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
        RTKPatternIDList.Add(inttostr(iRTKPatternID));
        boResult := true;
      end;
    end {if (Ntoks > 2)} else begin //placeholder
      //FeedbackLine := TokList[0];
      //Synchronize(AddFeedBack);
      RTKPatternIDList.Add('-1');
      boResult := false;
    end;
  end;
  boOK := boResult;
end;

procedure TfrmSWMM5_RDIIImporter.AddSewerSheds;
var boResult: boolean;
    i,j: integer;
    strSewerShed,sqlStr: string;
    iSewerShedID,iRDIIAreaID: integer;
    recordsAffected: OleVariant;
begin
//rm 2007-11-26 Problem: when multiple items in SewerShedList have same sewershedname
//  the area in the db is set to the area of the last sewershed in the list with that name.
//  Need to keep a running tally of areas for each sewershedname.
  boResult := false;
  for i := 0 to SewerShedList.Count - 1 do begin
    //addsewershedrecord - get raingage ID first
    //sewershedname, node loadpoint, sewered area
    Uutils.Tokenize(SewerShedList[i], TokList, Ntoks);
    if (Ntoks > 2) then begin
      strSewerShed := TokList[0];
      iSewerShedID := modDatabase.DatabaseModule.GetSewershedIDForName(TokList[0]);
      //strRainGaugeID := GetRainGaugeID(strSewerShed);
      GetRainGaugeID(strSewerShed);
      Uutils.Tokenize(SewerShedList[i], TokList, Ntoks);
      if iSewerShedID < 0 then begin //add a new one
        //get the raingage id from raingagelist and raingageidlist
        sqlStr := 'INSERT into Sewersheds (SewershedName, AreaUnitID, ' +
          ' Area, RainGaugeID, MeterID, JunctionID, Tag) ' +
          ' VALUES ("' +
          strSewerShed + '",' + inttostr(areaUnitID) + ',' + TokList[2] + ',' + sRainGaugeID + ',' +
          '-1,"' + TokList[1] + '","' + frmMain.FSWMM5InpFileName + '");';
Memo1.Lines.Add(sqlStr);
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
        iSewerShedID := modDatabase.DatabaseModule.GetSewershedIDForName(TokList[0]);
      end else begin
        //update existing one with area, raingaugeid and loadpoint
        //rm 2007-11-16  -  be sure to set AreaUnitID to 1 (acres)
        sqlStr := 'Update Sewersheds set Area = ' +  TokList[2] + ',' +
          ' AreaUnitID = ' + inttostr(areaUnitID) + ', ' +
          ' Raingaugeid = ' + sRainGaugeID + ',' +
          ' JunctionID = "' + TokList[1] + '"' +
          ' Where SewershedID = ' + inttostr(iSewerShedID) + ';';
Memo1.Lines.Add(sqlStr);
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
      end;
      SewerShedIDList.Add(inttostr(iSewerShedID));
      //added/updated SewerSheds - now add/update RDIIArea record
      iRDIIAreaID := modDatabase.DatabaseModule.GetRDIIAreaIDForName(TokList[1]);
      if iRDIIAreaID < 0 then begin //add a new one
        //get the raingage id from raingagelist and raingageidlist
        sqlStr := 'INSERT into RDIIAreas (RDIIAreaName, SewerShedID, AreaUnitID, ' +
          ' Area, RainGaugeID, MeterID, JunctionID, Tag) ' +
          ' VALUES ("' +
          TokList[1] + '", ' + inttostr(iSewerShedID) + ', ' + inttostr(areaUnitID) + ',' +
          TokList[2] + ',' + sRainGaugeID + ',' +
          '-1,"' + TokList[1] + '","' + frmMain.FSWMM5InpFileName + '");';
Memo1.Lines.Add(sqlStr);
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
        iRDIIAreaID := modDatabase.DatabaseModule.GetRDIIAreaIDForName(TokList[1]);
      end else begin
        //update existing one with area, sewershedid, raingaugeid and loadpoint
        //rm 2007-11-16  -  be sure to set AreaUnitID to 1 (acres)
        sqlStr := 'Update RDIIAreas set Area = ' +  TokList[2] + ',' +
          ' AreaUnitID = ' + inttostr(areaUnitID) + ', ' +
          ' SewershedID = ' + inttostr(iSewerShedID) + ',' +
          ' Raingaugeid = ' + sRainGaugeID + ',' +
          ' JunctionID = "' + TokList[1] + '"' +
          ' Where RDIIAreaID = ' + inttostr(iRDIIAreaID) + ';';
Memo1.Lines.Add(sqlStr);
        frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
      end;
      RDIIAreaIDList.Add(inttostr(iRDIIAreaID));
      boResult := true;
    end else begin
    //add to Sewershed, Raingauge list
      if NToks >1 then begin
        SewerShed_Raingauge_Mapping_List.Add(TokList[0] + ' ' + TokList[1]);
        boResult := true;
      end;
    end;
  end;
  boOK := boResult;
end;

procedure TfrmSWMM5_RDIIImporter.Button1Click(Sender: TObject);
begin
  Execute;
end;

procedure TfrmSWMM5_RDIIImporter.CloseSWMM5InpFile;
{
Close the SWMM5 inp file and free all resources
}
var boResult: boolean;
begin
  boResult := false;
  try
    CloseFile(FTextFile);
    SewerShedList.free;
    HydrographList.free;
    RaingageList.free;
    TimeSeriesList.free;
    TokList.Free;
    SewerShedIDList.Free;
    RDIIAreaIDList.Free;
    RaingageIDList.Free;
    RaingageStartEndList.Free;
    RTKPatternIDList.Free;
    SewerShed_Raingauge_Mapping_List.Free;
    boResult := true;
  finally

  end;
  boOK := boResult;
end;

procedure TfrmSWMM5_RDIIImporter.Execute;
var //boContinue,
  bo1, bo2, bo3, bo4: boolean;
  Line, S: string;
  LineCount: longint;
  Section: string;
  i: integer;

    procedure StripComment(const Line: String; var S: String);
    //-----------------------------------------------------------------------------
    //  Strips comment (text following a ';') from a line of input.
    //-----------------------------------------------------------------------------
    var
      P: Integer;
      N: Integer;
    begin
      S := Trim(Line);
      P := Pos(';', S);
      if P > 0 then
      begin
        N := Length(S);
        Delete(S, P, N);
      end;
    end;

begin
  { Place thread code here }
  Memo1.Lines.Add('Reading ' + FSWMM5InpFileName);
  bo1 := false;
  bo2 := false;
  bo3 := false;
  bo4 := false;
  flowunitlabel := '';
  areaUnitID := 1;  //initialize to default
  rainUnitID := 1;  //initialize to default
  boOK := false;
  OpenSWMM5InpFile;
  if boOK then
  try
    //boContinue := true;
    // Read each line of input file

    Reset(FTextFile);
    LineCount := 0;
    Section := '';
    while not EOF(FTextFile) {boContinue} do
    begin
      Readln(FTextFile, Line);
      Inc(LineCount);
      // Strip out trailing spaces, control characters & comment
      Line := TrimRight(Line);
      StripComment(Line, S);
      // Check if line begins a new input section
      if (Pos('[', S) = 1) then
      begin
        if (Pos('[OPTI', S) = 1) then begin
          Section := '[OPTI';
          Memo1.Lines.Add('Reading Section ' + Section);
        end else if (Pos('[RDII', S) = 1) then begin
          Section := '[RDII';
          Memo1.Lines.Add('Reading Section ' + Section);
        end else if (Pos('[HYDR', S) = 1) then begin
          Section := '[HYDR';
          Memo1.Lines.Add('Reading Section ' + Section);
        end else if (Pos('[RAIN', S) = 1) then begin
          Section := '[RAIN';
          Memo1.Lines.Add('Reading Section ' + Section);
        end else if (Pos('[TIME', S) = 1) then begin
          Section := '[TIME';
          Memo1.Lines.Add('Reading Section ' + Section);
        end else Section := '';
      end else begin
        if (Section = '[OPTI') then ReadOPTIONSection(S)
        else if (Section = '[RDII') then ReadRDIISection(S)
        else if (Section = '[HYDR') then ReadHydrographSection(S)
        else if (Section = '[RAIN') then ReadRaingagesSection(S)
        else if (Section = '[TIME') then ReadTimeseriesSection(S);
        //boContinue := not EOF(FTextFile);
      end;
    end;
    Memo1.Lines.Add('Adding Raingauges');
    AddRainGauges;
    Memo1.Lines.Add('Adding SewerSheds');
    AddSewerSheds;
    Memo1.Lines.Add('Adding Rainfall');
    AddRainfall;
    Memo1.Lines.Add('Adding RTK Patterns');
    Memo1.Lines.Add(Inttostr(HydrographList.Count div 2) + ' Hydrographs ');
for i := 0 to HydrographList.Count - 1 do
  Memo1.Lines.Add(HydrographList[i]);
    AddRTKPatterns;
    Memo1.Lines.Add('Adding RTK Links');
    AddRTKLinks;
    UpdateRainGaugeStartEndDates;
    UpdateScenarioFlowUnits;
  finally
    Memo1.Lines.Add(Inttostr(SewershedList.Count) + ' Sewersheds ');
    for i := 0 to SewershedList.Count - 1 do
      Memo1.Lines.Add(SewerShedList[i]);
    Memo1.Lines.Add(Inttostr(HydrographList.Count div 2) + ' Hydrographs ');
    for i := 0 to HydrographList.Count - 1 do
      Memo1.Lines.Add(HydrographList[i]);
    Memo1.Lines.Add(Inttostr(RaingageList.Count) + ' Raingages ');
    for i := 0 to RaingageList.Count - 1 do
      Memo1.Lines.Add(RaingageList[i]);
    Memo1.Lines.Add(Inttostr(TimeSeriesList.Count) + ' TimeSeries Lines.');
    //for i := 0 to TimeSeriesList.Count - 1 do
    //  Memo1.Lines.Add(TimeSeriesList[i]);

    CloseSWMM5InpFile;
    Memo1.Lines.Add('Success.');
  end;
end;

procedure TfrmSWMM5_RDIIImporter.GetRainGaugeID(strSewerShed: string);
var i,j:integer;
  strRainGauge,strTestName: string;
  strResult: string;
begin
  strResult := '-1';
  //get the raingaugeid for this sewershed
  //first get raingaugename from hydrographlist
  for i := 0 to HydrographList.Count - 1 do begin
    Uutils.Tokenize(HydrographList[i], TokList, Ntoks);
    if (Ntoks = 2) then begin
      strTestName := TokList[0];
      strRainGauge := TokList[1];
      if strTestName = strSewerShed then begin
        for j := 0 to RainGageList.Count - 1 do begin
          Uutils.Tokenize(RainGageList[j], TokList, Ntoks);
          if (Ntoks > 2) then begin
            if TokList[0] = strRainGauge then begin
              strResult := RaingageIDList[j];
              break;
            end;
          end;
        end;
      end;
    end;
  end;
  sRainGaugeID := strResult;
end;

procedure TfrmSWMM5_RDIIImporter.OpenSWMM5InpFile;
{
Open and validate the SWMM5 Input file
and initialize required data structures
}
var boResult: boolean;
begin
  boResult := false;
  if FileExists(FSWMM5InpFileName) then begin
    AssignFile(FTextFile, FSWMM5InpFileName);
    Reset(FTextFile);
    if not EOF(FTextFile) then begin
      SewerShedList := TStringList.Create;
      HydrographList := TStringList.Create;
      RaingageList := TStringList.Create;
      TimeSeriesList := TStringList.Create;
      TokList := TStringList.Create;
      SewerShedIDList := TStringList.Create;
      RDIIAreaIDList := TStringList.Create;
      RaingageIDList := TStringList.Create;
      RaingageStartEndList := TStringList.Create;
      RTKPatternIDList := TStringList.Create;
      SewerShed_Raingauge_Mapping_List := TStringList.Create;
      boResult := true;
    end;
  end else
    Memo1.Lines.Add('File not found.');
  boOK := boResult;
end;

procedure TfrmSWMM5_RDIIImporter.ReadHydrographSection(S: string);
{
Read [HYDROGRAPHS] section and load Raingauges with new records:
  RaingaugeName = Rain Gage
Also load RTKPatterns with new records:
  RTKPatternName = Hydrograph Name
  R1, T1, K1, . . . K3
}
//rm 2010-09-28 - accommodate new initial abstraction terms in new version of SWMM5
//NAME | RainGauge/Month | Short/Medium/Long | R | T | K | IAMax | IAREC | IAINI
//2 tokens for NAME | RainGauge
//9 tokens for NAME | Month | Short/Medium/Long | R | T | K | IAMax | IAREC | IAINI
var boResult: boolean;
i: integer;
s2: string;
begin
  boResult := false;
  try
    Tokenize(S, TokList, Ntoks);
    //rm 2010-10-05 - Why not just add them all????
    if (Ntoks >1) then  begin
      s2:=TokList[0];
      for i := 1 to TokList.Count - 1 do
        s2 := s2 + ' ' + TokList[i];
      HydrographList.Add(s2);
      boResult := true;
    end;

    {
    if (Ntoks >1) then  begin
      if (Ntoks < 3) then
        HydrographList.Add(TokList[0] + ' ' + TokList[1]) //hydname, raingagename
      else if (NToks > 8) then begin
        HydrographList.Add(TokList[0] + ' ' + TokList[1] + ' ' + TokList[2] + ' ' + //hydname, month, response
        TokList[3] + ' ' + TokList[4] + ' ' + TokList[5] + ' ' + //rtk
        TokList[6] + ' ' + TokList[7] + ' ' + TokList[8]); //iam, iar, iai
      end else begin
        HydrographList.Add(TokList[0] + ' ' + TokList[1] + ' ' + TokList[2] + ' ' + //hydname, month, response
        TokList[3] + ' ' + TokList[4] + ' ' + TokList[5]); //rtk
      end;
      boResult := true;
    end;
    }
  finally

  end;
  boOK := boResult;
end;
(*
procedure TfrmSWMM5_RDIIImporter.ReadHydrographSection(S: string);
{
Read [HYDROGRAPHS] section and load Raingauges with new records:
  RaingaugeName = Rain Gage
Also load RTKPatterns with new records:
  RTKPatternName = Hydrograph Name
  R1, T1, K1, . . . K3
}
//rm 2010-09-28 - accommodate new initial abstraction terms in new version of SWMM5
//NAME | RainGauge/Month | Short/Medium/Long | R | T | K | IAMax | IAREC | IAINI
//2 tokens for NAME | RainGauge
//9 tokens for NAME | Month | Short/Medium/Long | R | T | K | IAMax | IAREC | IAINI
var boResult: boolean;
begin
  boResult := false;
  try
    Tokenize(S, TokList, Ntoks);
    if (Ntoks >1) then  begin
      if (Ntoks < 3) then
        HydrographList.Add(TokList[0] + ' ' + TokList[1]) //hydname, raingagename
      else if (NToks > 8) then begin
        HydrographList.Add(TokList[0] + ' ' + TokList[1] + ' ' + TokList[2] + ' ' + //hydname, month, response
        TokList[3] + ' ' + TokList[4] + ' ' + TokList[5] + ' ' + //rtk
        TokList[6] + ' ' + TokList[7] + ' ' + TokList[8]); //iam, iar, iai
      end else begin
        HydrographList.Add(TokList[0] + ' ' + TokList[1] + ' ' + TokList[2] + ' ' + //hydname, month, response
        TokList[3] + ' ' + TokList[4] + ' ' + TokList[5]); //rtk
      end;
      boResult := true;
    end;
  finally

  end;
  boOK := boResult;

end;
*)
procedure TfrmSWMM5_RDIIImporter.ReadHydrographSection_Pre_Ver_5020(S: string);
{
Read [HYDROGRAPHS] section and load Raingauges with new records:
  RaingaugeName = Rain Gage
Also load RTKPatterns with new records:
  RTKPatternName = Hydrograph Name
  R1, T1, K1, . . . K3
}
var boResult: boolean;
begin
  boResult := false;
  try
    Uutils.Tokenize(S, TokList, Ntoks);
    if (Ntoks >1) then  begin
      if (Ntoks < 11) then
        HydrographList.Add(TokList[0] + ' ' + TokList[1]) //hydname, raingagename
      else if (NToks > 13) then begin
        HydrographList.Add(TokList[0] + ' ' + TokList[1] + ' ' + //hydname, month
        TokList[2] + ' ' + TokList[3] + ' ' + TokList[4] + ' ' + //rtk1
        TokList[5] + ' ' + TokList[6] + ' ' + TokList[7] + ' ' + //rtk2
        TokList[8] + ' ' + TokList[9] + ' ' + TokList[10] + ' ' + //rtk3
        TokList[11] + ' ' + TokList[12] + ' ' + TokList[13]); //abstraction terms
      end else begin
        HydrographList.Add(TokList[0] + ' ' + TokList[1] + ' ' + //hydname, month
        TokList[2] + ' ' + TokList[3] + ' ' + TokList[4] + ' ' + //rtk1
        TokList[5] + ' ' + TokList[6] + ' ' + TokList[7] + ' ' + //rtk2
        TokList[8] + ' ' + TokList[9] + ' ' + TokList[10]); //rtk3
      end;
      boResult := true;
    end;
  finally

  end;
  boOK := boResult;
end;

procedure TfrmSWMM5_RDIIImporter.ReadOptionSection(S: string);
{
Read [OPTIONS] section and update Scenario with
  flowunitlabel
}
var boResult: boolean;
begin
  boResult := false;
  Uutils.Tokenize(S, TokList, Ntoks);
  if (Ntoks > 1) then begin
    if TokList[0] = 'FLOW_UNITS' then begin
      flowunitlabel := TokList[1];    //Area units will depend on this!
      areaUnitID := DatabaseModule.GetAreaUnitIDForSWMM5FlowUnitLabel(flowUnitLabel);
      rainUnitID := DatabaseModule.GetRainUnitIDForSWMM5FlowUnitLabel(flowUnitLabel);
      boResult := true;
    end;
  end;
  boOK := boResult;
end;

procedure TfrmSWMM5_RDIIImporter.ReadRaingagesSection(S: string);
{
Read [RAINGAGES] section and update Raingauges with
  Timestep = freq
}
var boResult: boolean;
begin
  boResult := false;
  Uutils.Tokenize(S, TokList, Ntoks);
  if (Ntoks > 5) then begin
    //raingagename, timestep, timeseriesname, type
    //RaingageList.Add(TokList[0] + ',' + TokList[2] + ',' + TokList[5] + ',' + TokList[1]);
    //rm 2009-06-05
//    if (TokList[4] = 'FILE') then
//Memo1.Lines.Add(S)
//    else
      RaingageList.Add(TokList[0] + ' ' + TokList[2] + ' ' + TokList[5] + ' ' + TokList[1] + ' ' + TokList[4]);
memo1.lines.add(TokList[0] + ' ' + TokList[2] + ' ' + TokList[5] + ' ' + TokList[1] + ' ' + TokList[4]);
    boResult := true;
  end;
  boOK := boResult;
end;

procedure TfrmSWMM5_RDIIImporter.ReadRDIISection(S: string);
{
Read [RDII] section and load Sewersheds with new records:
  SewershedName = Hydrograph Name
  Area = RDII Area
  JunctionID = Node
  //rm 2007-11-16  be sure to set AreaUnitID to 1 (acres)
}
var boResult: boolean;

begin
  boResult := false;
  // Break line into string tokens
  Uutils.Tokenize(S, TokList, Ntoks);
  if (Ntoks > 2) then begin
    SewerShedList.Add(TokList[1] + ' ' + TokList[0] + ' ' + TokList[2]);
    //sewershedname, node loadpoint, sewered area
    boResult := true;
  end;
  boOK := boResult;
end;

procedure TfrmSWMM5_RDIIImporter.ReadTimeseriesSection(S: string);
{
Read [TIMESERIES] section and load each into Rainfall table
  Get RaingaugeID by RaingaugeName
  DateTime = Date + Time
  Volume = Value
}
var boResult: boolean;
//    TokList: TStringList;
//    NToks: Integer;
begin
  boResult := false;
  //Uutils.Tokenize(S, TokList, Ntoks);
  Tokenize(S, TokList, Ntoks);
  if (Ntoks > 3) then begin
    if TokList[3] <> '0' then
      TimeSeriesList.Add(TokList[0] + ' ' + TokList[1] + ' ' + TokList[2] + ' ' + TokList[3]);
    //timeseriesname, date, time, value
    boResult := true;
  end;
  boOK := boResult;
end;

procedure TfrmSWMM5_RDIIImporter.UpdateRainGaugeStartEndDates;
var boResult: boolean;
    i:integer;
    s1,s2, sqlStr, strRainGaugeID: string;
    recordsAffected: OleVariant;
    recSet: _RecordSet;
begin
//update startdatetime and enddatetime for each raingauge imported
  boResult := false;
  //for i := 0 to RaingageList.Count - 1 do begin
  //  Uutils.Tokenize(RaingageList[i], TokList, Ntoks);
  //  if (Ntoks > 2) then begin
  //    iRainGaugeID := modDatabase.DatabaseModule.GetRaingaugeIDForName(TokList[0]);
  for i := 0 to RaingageIDList.Count - 1 do begin
    strRainGaugeID := RainGageIDList[i];
    if (strtoint(strRainGaugeID) > -1) then begin
      sqlStr := 'Select Format(min([DateTime]),"mm/dd/yyyy hh:MM"), ' +
                ' Format(max(DateTime),"mm/dd/yyyy hh:MM") from Rainfall ' +
                ' where (RainGaugeID = ' + strRainGaugeID + ');';
      recSet := CoRecordSet.Create;
      recSet.Open(sqlStr,frmMain.connection,adOpenForwardOnly,adLockOptimistic,adCmdText);
      try
        if not recSet.EOF then begin
          recSet.MoveFirst;
          s1 := recSet.Fields.Item[0].Value;
          s2 := recSet.Fields.Item[1].Value;
          if (Length(s1) > 1) then   begin
          sqlStr := 'Update RainGauges set StartDateTime = "' + s1 + '", ' +
                    ' EndDateTime = "' + s2 + '"' +
                    ' WHERE RainGaugeID = ' + strRainGaugeID;
Memo1.Lines.Add(sqlStr);
          frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
          end;
          boResult := true;
        end;
      finally
        recSet.Close;
      end;
    end;
  end;
  boOK := boResult;
end;

procedure TfrmSWMM5_RDIIImporter.UpdateScenarioFlowUnits;
var boResult: boolean;
    i, iFlowUnitID:integer;
    sqlStr: string;
    recordsAffected: OleVariant;
    recSet: _RecordSet;
begin
  boResult := false;
  sqlStr := 'blank sql';
  if (Length(flowunitlabel) > 0) then begin
    iFlowUnitID := DatabaseModule.GetFlowUnitID(flowunitlabel);
    if iFlowUnitID > -1 then begin
      sqlStr := 'Update Scenarios set FlowUnitID = ' + inttostr(iFlowUnitID) +
        ' WHERE ScenarioID = ' + inttostr(FScenarioID);
      frmMain.Connection.Execute(sqlStr,recordsAffected,adCmdText);
    end;
  end;
Memo1.Lines.Add('FlowUnitLabel = "' + flowunitlabel + '"');
Memo1.Lines.Add(sqlStr);
  boOK := boResult;
end;

end.
