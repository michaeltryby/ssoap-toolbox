unit SW5InterFaceFile;
//
//unit for creating SWMM5 Interface files
// and inserting
// interface filenames into SWMM5 input files
//
interface

Uses SysUtils, Classes, Consts, WinTypes, WinProcs, Dialogs;

var
  IFaceFile: TextFile;    //the new interface file handle


  SWMM5InputFileName: string;  //the existing SW5 input file
  InterFaceFileName: string;   //the NEW interface file to be created
  SWMM5InputFile: TextFile; //the existing SW5 input file handle

  TITLELINE: string;   //title line
  REPSTEP: integer;    //reporting timestep
  NUMCONST: integer;   //number of consituents
  CONSTITS: TStringList;  //list of constituents
  NUMELEM: integer;    //number of nodes
  ELEMENTS: TStringList;  //list of element (NODE) names
  NUMDATES: integer;      //number of timesteps
  DATES: TStringList;     //list of formated datetimes
  //VALUES: Array of Array of Array of Double; //the big Array
  VALUES: Array of Array of Double; //the big Array

  R: Array of Array of Double;
  T: Array of Array of Double;
  K: Array of Array of Double;
  A: Array of double;
  P: Array of double;
{
  //function to return the timebase of a unit hydrograph with T,K, and rainfall interval in minutes m
  function Hlength(T:double; K:double; m:integer): integer;
  //function to return Unit Hydrograph value for a given timestep, T, K, and rain interval
  function Qunit(i:integer; T:double; K:double; m:integer): double;
  //function to return the RDII hydrograph value given R,T,K,A,P, and m
  function QRDII_Increm(i:integer; A:double; R:double; T:double; K:double; m:integer; P:double): double;
}
  //function to insert the new Interface File Name into an
  //existing SW5 File
  function InsertSWMM5InterFaceFile(s5filename,sAction,sType,iffilename:string): bool;
  //routine to write out a new interface file
  procedure WriteSWMM5InterFaceFile(iffilename:string);
{  procedure WriteSWMM5RdiiInterFaceFile(RDIIdata : array of array of real; filename:string;
                                arrayx : integer; arrayy : integer);}
  //testing routine - call this from your main form for testing
  //procedure TestSWMM5InterFaceFile;

implementation

uses Windows,rdiiutils,ADODB_TLB,mainform;

{procedure WriteSWMM5RdiiInterFaceFile(RDIIdata : array of array of real; filename:string;
                                arrayx : integer; arrayy : integer);
var
  i,j : integer;
  parser : TStringList;
  outstr : string;
begin
  assignFile(IFaceFile,filename);
  rewrite(IFaceFile);
  writeln(IFaceFile,'SWMM5 Interface File');
  writeln(IFaceFile,'RDII Demo');
  //writeln(IFaceFile,REPSTEP,' - reporting time step in sec');
  writeln(IFaceFile,'300');
  //writeln(IFaceFile,IntToStr(NUMCONST),'    - number of constituents as listed below:');
  writeln(IFaceFile,'1');
  outstr := 'Node             Year Mon Day Hr  Min Sec ';
  parser := TStringList.Create;
  parser.Delimiter := ' ';
  writeln(IFaceFile,'FLOW CFS');
  writeln(IFaceFile,outstr);
  writeln(IFaceFile,inttostr(arrayx)); //Numbers of Node

end;    }



//write out a new interface file
//after setting all of the globals, that is
procedure WriteSWMM5InterFaceFile(iffilename:string);
var i,j,k: integer;
    parser: TStringList;
    outstr: string;
begin
  InterFaceFileName := iffilename;
  assignFile(IFaceFile,InterFaceFileName);
  rewrite(IFaceFile);
  writeln(IFaceFile,'SWMM5 Interface File');
  writeln(IFaceFile,TITLELINE);
  writeln(IFaceFile,REPSTEP,' - reporting time step in sec');
  writeln(IFaceFile,IntToStr(NUMCONST),'    - number of constituents as listed below:');
  outstr := 'Node             Year Mon Day Hr  Min Sec ';
  parser := TStringList.Create;
  parser.Delimiter := ' ';
  for i := 0 to NUMCONST - 1 do
  begin
    writeln(IFaceFile,CONSTITS[i]);
    parser.DelimitedText := CONSTITS[i];
    outstr := outstr + ' ' + rdiiutils.leftPad(parser[0],12);
  end;
  parser.Free;
  writeln(IFaceFile,NUMELEM,' - number of nodes as listed below:');
  for i := 0 to ELEMENTS.Count - 1 do
  begin
    writeln(IFaceFile,rdiiutils.leftPad(ELEMENTS[i],12));
  end;
  writeln(IFaceFile,outstr);
  for j  := 0 to DATES.Count - 1 do
  begin
    for i := 0 to ELEMENTS.Count - 1 do
    begin
      //compose output string with node name, data, and first constituent value:
      outstr := rdiiutils.leftPad(ELEMENTS[i],12) +
        '     ' + DATES[j] + '         ' +
        FormatFloat('0.00000',VALUES[i,j]);
        //FormatFloat('0.00000',VALUES[i,j,0]);
      //tack on the other constituent values
      //if NUMCONST = 1, we are done and the for loop will do nothing
      //for k := 1 to NUMCONST - 1 do
        outstr := outstr + '   ' +
          FormatFloat('0.00000',VALUES[i,j]);
          //FormatFloat('0.00000',VALUES[i,j,k]);
      writeln(IFaceFile,outstr);
    end;
  end;
  CloseFile(IFaceFile);
end;

//insert the name of the interfacefile into the SWMM5 input file
//sAction = USE or SAVE
//sType = Rainfall, Runoff, Hotstart, or RDII
function InsertSWMM5InterFaceFile(s5filename,sAction,sType,iffilename:string):bool;
var inFILESsection:boolean;
    inpline: string;
    NewFile:TextFile;
    NewFileName:string;
    iLen: integer;
begin
  SWMM5InputFileName := s5filename;
  InterFaceFileName := iffilename;
  //see if the file exists
  if not rdiiutils.fileCanBeRead(SWMM5InputFileName) then
  begin
    Result := false;
    exit;
  end;
  //see if the file is writeable
  if not rdiiutils.fileCanBeWritten(SWMM5InputFileName) then
  begin
    Result := false;
    exit;
  end;
  //open the SWM5 Input file and look for the [FILES] position
  AssignFile(SWMM5InputFile,SWMM5InputFileName);
  {$I-}
  Reset(SWMM5InputFile);
  {$I+}
  if IOResult <> 0 Then
  Begin
    Result := false;
    Exit;
  End;
  inFILESsection := false;
  while not (inFILESsection or EOF(SWMM5InputFile)) do
  begin
    ReadLn(SWMM5InputFile,inpline);
    if (Pos('[FILE', UpperCase(inpLine)) = 1) then
      inFILESsection :=true;
  end;
  //if no [FILES] in input file, just append ours and we are done
  if EOF(SWMM5InputFile) then
  begin
    CloseFile(SWMM5InputFile);
    Append(SWMM5InputFile);
    Writeln(SWMM5InputFile,'[FILES]');
    Writeln(SWMM5InputFile,' ',sAction,' ',sType,' "',iffilename,'"');
    Writeln(SWMM5InputFile);
    CloseFile(SWMM5InputFile);
    Result := true;
    //done with the easy case
    Exit;
  end else
  //if [FILES] section was found we have work to do:
  begin
    CloseFile(SWMM5InputFile);
    //make a new textfile in the temp folder
    NewFileName := GetEnvironmentVariable('TEMP') + '\' +
      ExtractFileName(SWMM5InputFileName);
    AssignFile(NewFile,NewFileName);
    {$I-}
    Rewrite(NewFile);
    //start over with the existing SW5 input file
    Reset(SWMM5InputFile);
    {$I+}
    if IOResult <> 0 Then
    Begin
      Result := false;
      Exit;
    End;
    inFILESsection := false;
    //read in existing file and write new one
    //up until the [FILES] section
    while not (EOF(SWMM5InputFile)) do
    begin
      ReadLn(SWMM5InputFile,inpline);
      if (Pos('[FILE', UpperCase(inpLine)) = 1) then
      begin
        inFILESsection := true;
        writeln(NewFile,inpLine);
        //write out our new entry within the [FILES] section
        Writeln(NewFile,' ',sAction,' ',sType,' "',iffilename,'"');
        // must remove any existing entry of the same Action (USE/SAVE)
        //  and Type (Rainfall, Runoff, Hotstart, RDII)
        ReadLn(SWMM5InputFile,inpline);
        iLen := Length(sAction) + Length(sType) + 1;
        While inFILESsection do begin
          if length(inpline) > 0 then begin
            if (copy(Trim(UpperCase(inpLine)),1,1) = '[') then begin
              inFILESsection := false;
              writeln(NewFile,inpLine);
            end else begin
              if (Length(inpLine) > iLen) and (copy(Trim(UpperCase(inpLine)),1,iLen) =
                (UpperCase(sAction) + ' ' + UpperCase(sType))) then begin
                //do not write this line out - it is replaced by our new one
              end else begin
                writeln(NewFile,inpLine);
              end;
            end;
          end else begin
            writeln(NewFile,inpLine);
          end;
          if EOF(SWMM5InputFile) then
            inFILESsection := false
          else
            ReadLn(SWMM5InputFile,inpline);
        end;
      end else
        writeln(NewFile,inpLine);
    end;
    CloseFile(NewFile);
    CloseFile(SWMM5InputFile);
    //overwrite the existing input file with our new file
    CopyFile(pAnsiChar(NewFileName), pAnsiChar(SWMM5InputFileName), false);
    //delete the new file we created
    DeleteFile(pAnsiChar(NewFileName));
    Result := true;
  end;
end;

(*
//a Test routine you can call from the Applications Mainform's main menu
procedure TestSWMM5InterFaceFile;
var i,j : integer;
  theDate: TDateTime;
    recSet: _RecordSet;
    queryStr: string;
    startDate,EndDate:TDateTime;
    gaugeID: integer;
begin
  TITLELINE := 'This is a test of the SW5InterFaceFile Unit.';
  REPSTEP := 300; //seconds
  NUMCONST := 1; //3; //would you even have more than one for RDII?
  CONSTITS := TStringList.Create; //make the Constituents list
  CONSTITS.Add('FLOW CFS'); //make sure you add NUMCONST constituents
  //CONSTITS.Add('ANOTHER parsecs per Nanosecond per acre');
  //CONSTITS.Add('THIRD_CONSTITUENT Whatever.'); //NO SPACES in constituent name
  //NUMELEM := 2;//500; //number of NODES or whatever - arbitrary number here
  ELEMENTS := TStringList.Create; //List of NODES or whatever
  //Fill the list of NODES with dummy names
  //for i := 1 to NUMELEM do
    //ELEMENTS.Add('Nd812');
    //ELEMENTS.Add('NdABCDEFG');




  queryStr :=
'SELECT e.EventID, a.AnalysisID, a.RainGaugeID, e.StartDateTime, e.EndDateTime,' +
' e.R1, e.T1, e.K1, e.R2, e.T2, e.K2, e.R3, e.T3, e.K3, s.Area, s.JunctionID, r.TimeStep' +
' FROM ((Analyses AS a INNER JOIN Events AS e ON a.AnalysisID = e.AnalysisID) ' +
' INNER JOIN SewerSheds AS s ON a.RainGaugeID = s.RainGaugeID) ' +
' INNER JOIN RainGauges r on s.RainGaugeID = r.RainGaugeID ';// +
//' WHERE e.EventID = 1;';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  recSet.MoveFirst;
  REPSTEP := 60 * recSet.Fields.Item[16].Value;
  NUMELEM := 0;
  While not recSet.EOF do
  begin
    inc(NUMELEM);
    ELEMENTS.Add(recSet.Fields.Item[15].Value);
    StartDate := recSet.Fields.Item[3].Value;
    EndDate := recSet.Fields.Item[4].Value;
    gaugeID := recSet.Fields.Item[2].Value;
    recSet.MoveNext
  end;
  NUMDates := Round((EndDate - StartDate) / (REPSTEP / 86400.0)) + 1;

  SetLength(R, NUMELEM, 3);
  SetLength(T, NUMELEM, 3);
  SetLength(K, NUMELEM, 3);
  SetLength(A, NUMELEM);
//messagedlg(inttostr(NumDates), mtinformation, [mbok], 0);
  SetLength(P, NUMDates);
//    messagedlg (inttostr(Low(P)), mtInformation, [mbok], 0);
//    messagedlg (inttostr(High(P)), mtInformation, [mbok], 0);
  //FillChar(P, High(P), 0);    //this seems to destroy the array
//    messagedlg (inttostr(Low(P)), mtInformation, [mbok], 0);
//    messagedlg (inttostr(High(P)), mtInformation, [mbok], 0);

  recSet.MoveFirst;
  i := 0;
  While not recSet.EOF do
  begin
    R[i,0] := recSet.Fields.Item[5].Value;
    T[i,0] := recSet.Fields.Item[6].Value;
    K[i,0] := recSet.Fields.Item[7].Value;
    R[i,1] := recSet.Fields.Item[8].Value;
    T[i,1] := recSet.Fields.Item[9].Value;
    K[i,1] := recSet.Fields.Item[10].Value;
    R[i,2] := recSet.Fields.Item[11].Value;
    T[i,2] := recSet.Fields.Item[12].Value;
    K[i,2] := recSet.Fields.Item[13].Value;
    A[i] := recSet.Fields.Item[14].Value;
    inc(i);
    recSet.MoveNext
  end;
  recSet.Close;

  DATES := TStringList.Create;
  theDate := StartDate;
  //fill the DATES list with formated timestamps
  //ready for output to the interface file
  for j := 1 to NUMDATES do
  begin
    DATES.Add(FormatDateTime('yyyy MM  dd  hh  mm  ss',theDate));
    theDate := theDate + (REPSTEP / 86400.0);//REPSTEP is in seconds
  end;

  queryStr :=
  'SELECT r.DateTime, r.Volume ' +
//  ' FROM Rainfall ' +
//  ' WHERE Rainfall.DateTime >= e.StartDateTime and r.DateTime <= e.EndDateTime ' +
//  ' AND RainGaugeID = ' + inttostr(gaugeID);
  ' FROM (Rainfall AS r INNER JOIN Analyses AS a ON r.RainGaugeID = a.RainGaugeID) ' +
  ' INNER JOIN Events AS e ON a.AnalysisID = e.AnalysisID ' +
  ' WHERE r.DateTime >= e.StartDateTime and r.DateTime <= e.EndDateTime ';// +
//  ' and e.EventID = 1 ORDER BY r.DateTime;';
  recSet := CoRecordSet.Create;
  recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
  //check for null set
  if (recSet.EOF) then begin
    MessageDlg('No records returned in query ' + queryStr, mtError, [mbOK], 0);
  end else begin
  recSet.MoveFirst;
  While not recSet.EOF do
  begin
    theDate := recSet.Fields.Item[0].Value;
    i := Round((theDate - StartDate) * (86400.0 / REPSTEP));
//    messagedlg ( inttostr(i), mtinformation, [mbok], 0);
//    messagedlg ( recSet.Fields.Item[1].Value, mtinformation, [mbok], 0 );

//    messagedlg (inttostr(Low(P)), mtInformation, [mbok], 0);
//    messagedlg (inttostr(High(P)), mtInformation, [mbok], 0);
    if (i>-1) and (i < NUMDATES) then begin
      P[i] := recSet.Fields.Item[1].Value;
    end;
    recSet.MoveNext
  end;
  end;
  recSet.Close;

  //dimension the values array for number of elements, timesteps, and constituents
  //SetLength(VALUES,NUMELEM,NUMDATES,NUMCONST);
  SetLength(VALUES,NUMELEM,NUMDATES);
  //fill in the values array with dummy data
  //here we should see incrementing numbers in output
  for j := 0 to DATES.Count - 1 do
  begin
    for i := 0 to ELEMENTS.Count - 1 do
    begin
      //for k := 0 to CONSTITS.Count - 1 do
      //begin
      //  VALUES[i,j,k] := //(j * ELEMENTS.Count * CONSTITS.Count) + (i * CONSTITS.Count) + k + 1;
      //end;
      VALUES[i,j] := P[j];
    end;
  end;
  //make up a new interface file name here:
  WriteSWMM5InterFaceFile('C:\temp\TESTSW5IFACEFILE2.DAT');
  //provide an existing SW5 input file here:
  InsertSWMM5InterFaceFile('C:\temp\WhitesCreek5Year5year.inp','USE','RDII','C:\temp\TESTSW5IFACEFILE2.DAT');

  Elements.Clear;
  Elements.Free;
  CONSTITS.Clear;
  CONSTITS.Free;
  Dates.Clear;
  Dates.Free;
  //SetLength(VALUES,0,0,0);
  SetLength(VALUES,0,0);
end;
*)
end.
