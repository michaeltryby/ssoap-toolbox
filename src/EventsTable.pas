unit EventsTable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StormEventCollection, StormEvent, moddatabase, Grids;

type
  TfrmEventsTable = class(TForm)
    StringGrid1: TStringGrid;
    Label1: TLabel;
    EventNameComboBox: TComboBox;
    Label2: TLabel;
    AnalysisNameComboBox: TComboBox;
    procedure AnalysisNameComboBoxChange(Sender: TObject);
    procedure EventNameComboBoxChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    stormEvents: TStormEventCollection;
    analysisID: integer;
    eventID: integer;
    stormEvent: TStormEvent;
    Procedure LoadEvents;
    procedure LoadEventIDs;
  public
    { Public declarations }
  end;

Const
  FLAG_ALL_EVENTS = -99;
  FLAG_ALL_EVENTS_LABEL = '<All Events>';

var
  frmEventsTable: TfrmEventsTable;

implementation

{$R *.dfm}

{ TfrmEventsTable }

procedure TfrmEventsTable.AnalysisNameComboBoxChange(Sender: TObject);
begin
// analysisID := StrtoInt(Copy(AnalysisNameComboBox.Text,9,Length(AnalysisNameComboBox.Text)-8));
  analysisID := DatabaseModule.GetAnalysisIDForName(AnalysisNameComboBox.Text);
  LoadEventIDs;
end;

procedure TfrmEventsTable.EventNameComboBoxChange(Sender: TObject);
begin
  if EventNameComboBox.Text = FLAG_ALL_EVENTS_LABEL then begin
    eventID := FLAG_ALL_EVENTS;  //event ID flag for "All Events"
  end else begin
    eventID := StrtoInt(Copy(EventNameComboBox.Text,6,Length(EventNameComboBox.Text)-5));
  end;
  LoadEvents;
end;

procedure TfrmEventsTable.FormShow(Sender: TObject);
begin
  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames();
  AnalysisNameComboBox.ItemIndex := 0;
  //analysisID := StrtoInt(Copy(AnalysisNameComboBox.Text,9,Length(AnalysisNameComboBox.Text)-8));
  analysisID := DatabaseModule.GetAnalysisIDForName(AnalysisNameComboBox.Text);
  LoadEventIDs;
  EventNameComboBox.Text := FLAG_ALL_EVENTS_LABEL;
  eventID := FLAG_ALL_EVENTS; //event ID flag for "All Events"
  LoadEvents;
end;

procedure TfrmEventsTable.LoadEventIDs;
var i: integer;
begin
  EventNameComboBox.Items.Clear;
  EventNameComboBox.Text := '';
  stormEvents := DatabaseModule.GetEvents(analysisID);
  EventNameComboBox.Items.Add(FLAG_ALL_EVENTS_LABEL);  //option to show all events for the selected analysis
  for i := 1 to stormEvents.Count do
  begin
    stormEvent := stormEvents.items[i-1];
    EventNameComboBox.Items.Add('Event ' + InttoStr(stormEvent.EventID));
  end;
  if EventNameComboBox.Items.Count > 0 then begin
    EventNameComboBox.ItemIndex := 0;
    EventNameComboBoxChange(EventNameComboBox);
  end;
end;

procedure TfrmEventsTable.LoadEvents;
var i,j: integer;
begin
  stormEvents := DatabaseModule.GetEvents(analysisID);
  StringGrid1.RowCount := 1;
  StringGrid1.ColCount := 16;
  StringGrid1.Cells[1,0] := 'Event ID';
  StringGrid1.Cells[2,0] := 'Start Date';
  StringGrid1.Cells[3,0] := 'End Date';
  StringGrid1.Cells[4,0] := 'R1';
  StringGrid1.Cells[5,0] := 'T1';
  StringGrid1.Cells[6,0] := 'K1';
  StringGrid1.Cells[7,0] := 'R2';
  StringGrid1.Cells[8,0] := 'T2';
  StringGrid1.Cells[9,0] := 'K2';
  StringGrid1.Cells[10,0] := 'R3';
  StringGrid1.Cells[11,0] := 'T3';
  StringGrid1.Cells[12,0] := 'K3';
  //rm 2010-09-29
  //StringGrid1.Cells[13,0] := 'AM';
  //StringGrid1.Cells[14,0] := 'AR';
  //StringGrid1.Cells[15,0] := 'AI';
  StringGrid1.Cells[13,0] := 'AM1';
  StringGrid1.Cells[14,0] := 'AR1';
  StringGrid1.Cells[15,0] := 'AI1';
  StringGrid1.Cells[16,0] := 'AM2';
  StringGrid1.Cells[17,0] := 'AR2';
  StringGrid1.Cells[18,0] := 'AI2';
  StringGrid1.Cells[19,0] := 'AM3';
  StringGrid1.Cells[20,0] := 'AR3';
  StringGrid1.Cells[21,0] := 'AI3';
  j := 0; //row counter
  for i := 1 to stormEvents.Count do
  begin
    stormEvent := stormEvents.items[i-1];
    if (stormEvent.EventID = eventID) or (eventID = FLAG_ALL_EVENTS) then begin
      inc(j); //add row
      StringGrid1.RowCount := StringGrid1.Rowcount + 1;
      StringGrid1.FixedRows := 1;
      //rm 2009-06-08 - iigraph numbers events based on order, not eventid
      //StringGrid1.Cells[1,j] := 'Event ' + IntToStr(stormEvent.EventID);
      StringGrid1.Cells[1,j] := 'Event ' + IntToStr(i);
      StringGrid1.Cells[2,j] := FormatDateTime('ddddd',stormEvent.StartDate);
      StringGrid1.Cells[3,j] := FormatDateTime('ddddd',stormEvent.EndDate);
      StringGrid1.Cells[4,j] := FormatFloat('#.000',stormEvent.R[0]);
      StringGrid1.Cells[5,j] := FormatFloat('#.0',stormEvent.T[0]);
      StringGrid1.Cells[6,j] := FormatFloat('#.0',stormEvent.K[0]);
      StringGrid1.Cells[7,j] := FormatFloat('#.000',stormEvent.R[1]);
      StringGrid1.Cells[8,j] := FormatFloat('#.0',stormEvent.T[1]);
      StringGrid1.Cells[9,j] := FormatFloat('#.0',stormEvent.K[1]);
      StringGrid1.Cells[10,j] := FormatFloat('#.000',stormEvent.R[2]);
      StringGrid1.Cells[11,j] := FormatFloat('#.0',stormEvent.T[2]);
      StringGrid1.Cells[12,j] := FormatFloat('#.0',stormEvent.K[2]);
      //rm 2010-09-29 new AI factors
      //StringGrid1.Cells[13,j] := FormatFloat('#.000',stormEvent.AM);
      //StringGrid1.Cells[14,j] := FormatFloat('#.000',stormEvent.AR);
      //StringGrid1.Cells[15,j] := FormatFloat('#.000',stormEvent.AI);
      StringGrid1.Cells[13,j] := FormatFloat('#.000',stormEvent.AM[1]);
      StringGrid1.Cells[14,j] := FormatFloat('#.000',stormEvent.AR[1]);
      StringGrid1.Cells[15,j] := FormatFloat('#.000',stormEvent.AI[1]);
      StringGrid1.Cells[16,j] := FormatFloat('#.000',stormEvent.AM[2]);
      StringGrid1.Cells[17,j] := FormatFloat('#.000',stormEvent.AR[2]);
      StringGrid1.Cells[18,j] := FormatFloat('#.000',stormEvent.AI[2]);
      StringGrid1.Cells[19,j] := FormatFloat('#.000',stormEvent.AM[3]);
      StringGrid1.Cells[20,j] := FormatFloat('#.000',stormEvent.AR[3]);
      StringGrid1.Cells[21,j] := FormatFloat('#.000',stormEvent.AI[3]);
    end;
  end;
end;

end.
