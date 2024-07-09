unit StormEventCollection;

interface

uses classes, StormEvent;

function StormEventCompare(item1, item2: Pointer): integer;

type
  TStormEventCollection = class(TList)
     function AddEvent(event: TStormEvent): integer;

  private

  public

  end;


implementation

function StormEventCompare(item1, item2: Pointer): integer;
begin
  if (TStormEvent(item1).StartDate > TStormEvent(item2).StartDate)
    then result := 1
    else if (TStormEvent(item1).StartDate < TStormEvent(item2).StartDate)
      then result := -1
      else result := 0;
end;

function TStormEventCollection.AddEvent(event: TStormEvent): integer;
begin
  result := Add(event);
  Sort(StormEventCompare);
end;

end.
