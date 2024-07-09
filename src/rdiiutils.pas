unit rdiiutils;

interface

  function y2k(year:word):word;
  function getminute(ldate: real): integer;
  function gethour(ldate: real): integer;
  function dateTimeString(dateTime: TDateTime): string;
  function dateString(dateTime: TDateTime): string;
  function leftPad(inString: string; len: integer): string;
  function fileCanBeRead(filename: string): boolean;
  function fileCanBeWritten(filename: string): boolean;

implementation

uses stdctrls, dialogs, fileCtrl, SysUtils, controls;

function y2k(year:word):word;
{ FUNCTION Y2K
   converts 2 digit year to 4 digit year
   based on values of y2kyear}

(* anthing less than or equal to y2kyear is considered 2000*)
const y2kyear = 60;
begin
  if (year <= y2kyear) then year := year + 2000;
  if (year < 100) then year := year + 1900;
  if (year < 1000) then year := year + 1000;
  y2k := year;
end;

function gethour(ldate:real): integer;
var
  rhour: real;
  ihour: integer;
begin
  rhour := frac(ldate+1.0/60.0/60.0/24.0)*24.0;  {add 1 second to ldate}
  ihour := trunc(rhour);
  gethour := ihour;
end;

function getminute(ldate: real): integer;
var
  ihour, iminute: integer;
  rhour, rminute: real;
begin
  rhour := frac(ldate+1.0/60.0/60.0/24.0)*24.0;  {add 1 second to ldate}
  ihour := gethour(ldate);
  rminute := (rhour-ihour)*60.0;
  iminute := round(rminute);
  getminute := iminute;
end;

function dateTimeString(dateTime: TDateTime): string;
var
  res: string;
begin
  dateTimeToString(res,'m/d/yyyy h:nn',dateTime);
  dateTimeString := res;
end;

function dateString(dateTime: TDateTime): string;
var
  res: string;
begin
  dateTimeToString(res,'m/d/yyyy',dateTime);
  dateString := res;
end;

function leftPad(inString: string; len: integer): string;
var
  outString: string;
  i: integer;
begin
  for i := 1 to len - Length(instring) do outString := outString + ' ';
  outString := outString + inString;
  leftPad := outString;
end;

function fileCanBeRead(filename: string): boolean;
begin
  if (Length(filename) = 0) then begin
    fileCanBeRead := false;
    MessageDlg('The filename may not be blank.',mtError,[mbOK],0);
  end
  else begin
    if (not FileExists(filename)) then begin
      fileCanBeRead := false;
      MessageDlg('The file "'+filename+'" does not exist.',mtError,[mbOK],0);
    end
    else
      fileCanBeRead := true;
  end;
end;

function fileCanBeWritten(filename: string): boolean;
var
  directory: string;
  res: integer;
  F: textFile;
begin
  fileCanBeWritten := true;
  if (Length(filename) = 0) then begin
    fileCanBeWritten := false;
    MessageDlg('The filename may not be blank.',mtError,[mbOK],0);
  end
  else begin
    directory := Copy(filename,0,LastDelimiter('\',filename));
    if (length(directory) > 0) and (not directoryExists(directory)) then begin
      fileCanBeWritten := false;
      MessageDlg('The file "'+filename+'" cannot be created'+#13
        +'because the directory "'+directory+'" does not exist.',mtError,[mbOK],0);
    end
    else if (fileExists(filename)) then begin
      res := MessageDlg('The file "'+filename+'" already exists.  Overwrite?'+#13,mtWarning,[mbYes,MbNo],0);
      if (res = mrNo)
        then fileCanBeWritten := false
      else begin
        try
          assignFile(F,filename);
          append(F);
          close(F);
        except
          MessageDlg('Error opening the file "'+filename+'".  It may be open by another application or read-only.',mtError,[mbOK],0);
          fileCanBeWritten := false;
        end;
      end;
    end
  end;
end;

end.
