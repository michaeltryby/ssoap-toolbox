unit GWIadjustmentcollection;

interface

uses classes, GWIAdjustment;

function GWIAdjustmentCompare(item1, item2: Pointer): integer;

type
  TGWIAdjustmentCollection = class(TList)
     function AddAdjustment(adjustment: TGWIAdjustment): integer;
  private
  public
    function AdjustmentAt(timestamp: TDateTime): real;
    function AdjustmentNum(i: integer): real;
    function DateNum(i: integer): TDateTime;
  end;


implementation

function GWIAdjustmentCompare(item1, item2: Pointer): integer;
begin
  if (TGWIAdjustment(item1).Date > TGWIAdjustment(item2).Date)
    then result := 1
    else if (TGWIAdjustment(item1).Date < TGWIAdjustment(item2).Date)
      then result := -1
      else result := 0;
end;

function TGWIAdjustmentCollection.AddAdjustment(adjustment: TGWIAdjustment): integer;
begin
  result := Add(adjustment);
  Sort(GWIAdjustmentCompare);
end;

function TGWIAdjustmentCollection.AdjustmentAt(timestamp: TDateTime): real;
//rm 2010-02-09 - This is extrapolating from the last two values for times
//beyond the last user-defined point

//rm 2010-04-19 - This is also way wrong when the user-defined points are
//after the current time

//rm 2010-10-05 - Still don't have it right at the start - between the first user-point
//and the second we are getting zeros, where we should be getting interpolation between
//the two.
var
  gwiAdjustment, earlierAdjustment, laterAdjustment: TGWIAdjustment;
  k: integer;
  ratio: real;
begin
  k := 0;
  if Count > 0 then begin
    //rm 2010-10-05 - new try here - if timestamp is before the first user-supplied point,
    //set to zero
    gwiAdjustment := Items[0];
    if (timestamp < gwiAdjustment.date) then begin //timestamp is before the first user-point
      if ((gwiAdjustment.date -  timestamp) > 1) then begin //over a day before
        AdjustmentAt := 0.0;
      end else begin //under a day before the first user-point
        ratio := 1.0 - (gwiAdjustment.date - timestamp);
        AdjustmentAt := ratio*(gwiAdjustment.Value);
      end;
    end else begin
      repeat
        inc(k);
        gwiAdjustment := Items[k];
      until ((k = Count-1) or (gwiAdjustment.date > trunc(timestamp)));
      //rm 2010-02-09 - if we are beyond Items[k], interpolate to 0 by next 12:00 midnight
      if ((k = Count-1) and (timestamp > gwiAdjustment.date)) then begin
        if (timestamp - gwiAdjustment.date) > 1 then begin
          AdjustmentAt := 0.0;
        end else begin
          earlierAdjustment := Items[k];
          ratio := 1.0 - (timestamp-earlierAdjustment.date);
          AdjustmentAt := ratio*(earlierAdjustment.Value);
        end;
      //rm 2010-04-19 - if we are before Items[k], interpolate to 0 by previous 12:00 midnight
      //end else if ((k = 1) and (timestamp < gwiAdjustment.Date)) then begin
      //  if (gwiAdjustment.date - timestamp) > 1 then begin
      //    AdjustmentAt := 0.0;
      //  end else begin
      //    laterAdjustment := Items[k];
      //    ratio := 1.0 - (laterAdjustment.date-timestamp);
      //    AdjustmentAt := ratio*(laterAdjustment.Value);
      //  end;
      end else begin
        earlierAdjustment := Items[k-1];
        laterAdjustment := Items[k];
        ratio := (timestamp-earlierAdjustment.date)/(laterAdjustment.date-earlierAdjustment.date);
        AdjustmentAt := earlierAdjustment.Value+(ratio*(laterAdjustment.Value-earlierAdjustment.Value));
      end;
    end;
  end else
    AdjustmentAt := 0.0;
end;

function TGWIAdjustmentCollection.AdjustmentNum(i: integer): real;
begin
      AdjustmentNum := TGWIAdjustment(Items[i]).Value;
end;

function TGWIAdjustmentCollection.DateNum(i: integer): TDateTime;
begin
      DateNum := TGWIAdjustment(Items[i]).Date;
end;

end.
