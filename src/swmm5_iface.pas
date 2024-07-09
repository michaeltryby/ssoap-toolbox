// swmm5_iface.pas
//
// Example code for interfacing SWMM5 with Delphi Pascal programs.
//
// Remember to add this unit to the Uses clause of the calling program.

Unit SWMM5_IFACE;

Interface

Uses SysUtils, Classes, Consts, WinTypes, WinProcs;

Var
  SWMM_Nperiods: LongInt;              // number of reporting periods
  SWMM_FlowUnits: LongInt;             // flow units code
  SWMM_Nsubcatch: LongInt;             // number of subcatchments
  SWMM_Nnodes: LongInt;                // number of drainage system nodes
  SWMM_Nlinks: LongInt;                // number of drainage system links
  SWMM_Npolluts: LongInt;              // number of pollutants tracked
  SWMM_StartDate: Double;              // start date of simulation
  SWMM_ReportStep: LongInt;            // reporting time step (seconds)

  SWMM_Version: LongInt;

  //Function  RunSwmmExe(cmdLine : String): Integer;
  //Function  RunSwmmDll(inpFile: String; rptFile: String; outFile: String): Integer;
  Function  OpenSwmmOutFile(outFile: String): Integer;
  Function  GetSwmmResult(iType, iIndex, vIndex, period: Integer; var value: Single):
            Integer;
  Procedure CloseSwmmOutFile;
  Function Units: String;
  Function StartDate: TDateTime;
  Function EndDate: TDateTime;
  Function SubcName(idx:integer):String;
  Function CondName(idx:integer):String;
  Function JuncName(idx:integer):String;

  Function SubcIndexOf(s:string):Integer;
  Function JuncIndexOf(s:string):Integer;
  Function CondIndexOf(s:string):Integer;

  Function GetSwmmObjectProperty(iType, iIndex, vIndex: Integer; var value: Single; var ivalue:Integer):
           Integer;

Implementation

uses Windows;

//Uses swmm5;

Const
 SUBCATCH = 0;
 NODE     = 1;
 LINK     = 2;
 SYS      = 3;
//rm 2010-04-22 - these are now variables (from version 5.0.016 onwards)
//rm 2010-04-22  SUBCATCHVARS = 6;                     // number of subcatch reporting variable
//rm 2010-04-22  NODEVARS = 6;                         // number of node reporting variables
//rm 2010-04-22  LINKVARS = 5;                         // number of link reporting variables
//rm 2010-04-22  SYSVARS = 13;                         // number of system reporting variables
 RECORDSIZE = 4;                       // number of bytes per file record

 OP_SUBCATCHVARS = 1;                  // rm number of Object Property vars
 OP_NODEVARS = 3;                      //
 OP_LINKVARS = 5;                      //

Var
  Fout: File;                          // file handle
  StartPos: LongInt;                   // file position where results start
  BytesPerPeriod: LongInt;             // bytes used for results in each period

  OID_StartPos: Longint;                // rm Start Pos of Object ID Names
  OP_StartPos: Longint;                // rm Start Pos of Object Properties
  SubcList, JuncList, CondList: TStringList;  // rm Lists of Object Names
//rm 2010-04-22 - added from revised swmm5_iface
  SubcatchVars: Integer;               // number of subcatch reporting variable
  NodeVars: Integer;                   // number of node reporting variables
  LinkVars: Integer;                   // number of link reporting variables
  SysVars: Integer;                    // number of system reporting variables


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
Function OpenSwmmOutFile(outFile: String): Integer;
//-----------------------------------------------------------------------------
Var
  magic1, magic2, errCode, version, offset: LongInt;
  err: Integer;
  i,j:integer;
  n: longint;
  k: byte;
  s:string;
Begin
  // --- open the output file
  AssignFile(Fout, outFile);
  {$I-}
  Reset(Fout, 1);
  {$I+}
  if IOResult <> 0 Then
  Begin
    Result := 2;
    Exit;
  End;

  // --- check that file contains at least 14 records
  If FileSize(Fout) < 14*RECORDSIZE Then
  Begin
    Result := 1;
    CloseFile(Fout);
    Exit;
  End;

  // --- read parameters from end of file
  //-----rm modification to get the start pos of OBJECT ID Names and OBJEctProperties
//  Seek(Fout, FileSize(Fout) - 4*RECORDSIZE);
//rm 2010-04-22 - no changes needed here?
  Seek(Fout, FileSize(Fout) - 6*RECORDSIZE);
  BlockRead(Fout, OID_StartPos, RECORDSIZE);
  BlockRead(Fout, OP_StartPos, RECORDSIZE);   //offset0
  BlockRead(Fout, StartPos, RECORDSIZE);
  BlockRead(Fout, SWMM_Nperiods, RECORDSIZE);
  BlockRead(Fout, errCode, RECORDSIZE);
  BlockRead(Fout, magic2, RECORDSIZE);

  // --- read magic number from beginning of file
  Seek(Fout, 0);
  BlockRead(Fout, magic1, RECORDSIZE);

  // --- perform error checks
  If magic1 <> magic2 Then err := 1
  Else If errCode <> 0 Then err := 1
  Else If SWMM_Nperiods = 0 Then err := 1
  Else err := 0;

  // --- quit if errors found
  if (err > 0 ) then begin
    Result := err;
    CloseFile(Fout);
    Exit;
  end;

  // --- otherwise read additional parameters from start of file

  BlockRead(Fout, version, RECORDSIZE);
  BlockRead(Fout, SWMM_FlowUnits, RECORDSIZE);
  BlockRead(Fout, SWMM_Nsubcatch, RECORDSIZE);
  BlockRead(Fout, SWMM_Nnodes, RECORDSIZE);
  BlockRead(Fout, SWMM_Nlinks, RECORDSIZE);
  BlockRead(Fout, SWMM_Npolluts, RECORDSIZE);

  //read subc, junc, and cond lists
  SubcList := TSTringList.Create;
  for i := 0 to SWMM_Nsubcatch - 1 do
  begin
    BlockRead(Fout, n, Sizeof(n));
    s := '';
    for j := 0 to n - 1 do
    begin
      BlockRead(Fout, k, Sizeof(k));
      s := s + Chr(k);
    end;
    SubcList.Add(s)
  end;
  JuncList := TSTringList.Create;
  for i := 0 to SWMM_Nnodes - 1 do
  begin
    BlockRead(Fout, n, Sizeof(n));
    s := '';
    for j := 0 to n - 1 do
    begin
      BlockRead(Fout, k, Sizeof(k));
      s := s + Chr(k);
    end;
    JuncList.Add(s)
  end;
  CondList := TSTringList.Create;
  for i := 0 to SWMM_Nlinks - 1 do
  begin
    BlockRead(Fout, n, Sizeof(n));
    s := '';
    for j := 0 to n - 1 do
    begin
      BlockRead(Fout, k, Sizeof(k));
      s := s + Chr(k);
    end;
    CondList.Add(s)
  end;

//rm 2010-04-22 - insert from revised swmm5_iface.pas
  // Read number & codes of computed variables
  // Skip over saved subcatch/node/link input values
  offset := (SWMM_Nsubcatch+2) * RECORDSIZE     // Subcatchment area
             + (3*SWMM_Nnodes+4) * RECORDSIZE  // Node type, invert & max depth
             + (5*SWMM_Nlinks+6) * RECORDSIZE; // Link type, z1, z2, max depth & length
  offset := OP_StartPos + offset;
  Seek(Fout, offset);
  BlockRead(Fout, SubcatchVars, RECORDSIZE); // # Subcatch variables
  Seek(Fout, FilePos(Fout)+(SubcatchVars*RECORDSIZE));
  BlockRead(Fout, NodeVars, RECORDSIZE);     // # Node variables
  Seek(Fout, FilePos(Fout)+(NodeVars*RECORDSIZE));
  BlockRead(Fout, LinkVars, RECORDSIZE);     // # Link variables
  Seek(Fout, FilePos(Fout)+(LinkVars*RECORDSIZE));
  BlockRead(Fout, SysVars, RECORDSIZE);     // # System variables
  //rm 2010-04-22 - Sysvars is now 14! as of version 5.0.016
//rm 2010-04-22 end insert

  // --- read data just before start of output results
  offset := StartPos - 3*RECORDSIZE;
  Seek(Fout, offset);
  BlockRead(Fout, SWMM_StartDate, 2*RECORDSIZE);
  BlockRead(Fout, SWMM_ReportStep, RECORDSIZE);

  // --- compute number of bytes of results values used per time period
  BytesPerPeriod := 2*RECORDSIZE +      // date value (a double)
                    (SWMM_Nsubcatch*(SUBCATCHVARS+SWMM_Npolluts) +
                     SWMM_Nnodes*(NODEVARS+SWMM_Npolluts) +
                     SWMM_Nlinks*(LINKVARS+SWMM_Npolluts) +
                     SYSVARS)*RECORDSIZE;

  SWMM_Version := version;
  // --- return with file left open
  Result := err;
End;


//-----------------------------------------------------------------------------
Function GetSwmmResult(iType, iIndex, vIndex, period: Integer; var value: Single):
         Integer;
//-----------------------------------------------------------------------------
Var
  offset: LongInt;
Begin
  // --- compute offset into output file
  Result := 0;
  value := 0.0;
  offset := StartPos + period*BytesPerPeriod + 2*RECORDSIZE;
  if ( iType = SUBCATCH ) Then
    offset := offset + RECORDSIZE*(iIndex*(SUBCATCHVARS+SWMM_Npolluts) + vIndex)
  else if (iType = NODE) Then
    offset := offset +  RECORDSIZE*(SWMM_Nsubcatch*(SUBCATCHVARS+SWMM_Npolluts) +
                                    iIndex*(NODEVARS+SWMM_Npolluts) + vIndex)
  else if (iType = LINK) Then
    offset := offset + RECORDSIZE*(SWMM_Nsubcatch*(SUBCATCHVARS+SWMM_Npolluts) +
                                   SWMM_Nnodes*(NODEVARS+SWMM_Npolluts) +
                                   iIndex*(LINKVARS+SWMM_Npolluts) + vIndex)
  else if (iType = SYS) Then
    offset := offset + RECORDSIZE*(SWMM_Nsubcatch*(SUBCATCHVARS+SWMM_Npolluts) +
                                   SWMM_Nnodes*(NODEVARS+SWMM_Npolluts) +
                                   SWMM_Nlinks*(LINKVARS+SWMM_Npolluts) + vIndex)
  else Exit;

  // --- re-position the file and read the result
  Seek(Fout, offset);
  BlockRead(Fout, value, RECORDSIZE);
  Result := 1;
End;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
Procedure CloseSwmmOutFile;
Begin
  {$I-}
  CloseFile(Fout);
  {$I+}
  if IOResult <> 0 Then
  Begin
     //You must call the System.IOResult function to clear
     //an error, even if you aren't interested in the error.
     //If you don't clear an error and {$I-} is the current
     //state, the next I/O function call will fail with the
     //lingering System.IOResult error.
  End;
  SubcList.Free;
  JuncList.Free;
  CondList.Free;
End;


Function Units: String;
begin
  case SWMM_FlowUnits of
    0: Result := 'CFS';
    1: Result := 'GPM';
    2: Result := 'MGD';
    3: Result := 'CMS';
    4: Result := 'LPS';
    5: Result := 'MLD';
  end;
end;

Function StartDate: TDateTime;
begin
  Result :=  SWMM_StartDate;
end;

Function EndDate: TDateTime;
begin
  Result := SWMM_StartDate + (SWMM_Nperiods * SWMM_ReportStep / 86400.0);
end;


Function SubcName(idx:integer): string;
begin
  Result := SubcList[idx];
end;
Function JuncName(idx:integer): string;
begin
  Result := JuncList[idx];
end;
Function CondName(idx:integer): string;
begin
  Result := CondList[idx];
end;

Function SubcIndexOf(s:string):Integer;
begin
  Result := SubcList.IndexOf(s);
end;
Function JuncIndexOf(s:string):Integer;
begin
  Result := JuncList.IndexOf(s);
end;
Function CondIndexOf(s:string):Integer;
begin
  Result := CondList.IndexOf(s);
end;

//-----------------------------------------------------------------------------
// rm Get Object property from Object Properties Section
Function GetSwmmObjectProperty(iType, iIndex, vIndex: Integer; var value:Single; var ivalue: Longint):
         Integer;
//-----------------------------------------------------------------------------
Var
  offset: LongInt;
Begin
  // --- compute offset into output file
  Result := 0;
  value := 0;
  ivalue := 0;
  offset := OP_StartPos;
  if ( iType = SUBCATCH ) Then
    offset := offset + RECORDSIZE*((iIndex+1)*OP_SUBCATCHVARS + 1 + vIndex)
  else if (iType = NODE) Then
    offset := offset +  RECORDSIZE*((SWMM_Nsubcatch+1)*OP_SUBCATCHVARS + 1 +
                                    (iIndex+1)*OP_NODEVARS + 1 + vIndex)
  else if (iType = LINK) Then
    offset := offset + RECORDSIZE*((SWMM_Nsubcatch+1)*OP_SUBCATCHVARS + 1 +
                                   (SWMM_Nnodes+1)*OP_NODEVARS + 1 +
                                   (iIndex+1)*OP_LINKVARS + 1 + vIndex)
  else Exit;

  // --- re-position the file and read the result
  Seek(Fout, offset);
  if (vIndex = 0) and (iType > 0) then
    BlockRead(Fout, ivalue, RECORDSIZE)
  else
    BlockRead(Fout, value, RECORDSIZE);
  Result := 1;
End;


End.

