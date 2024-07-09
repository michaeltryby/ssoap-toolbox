unit importevents;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmEventImport = class(TForm)
    AnalysisLabel: TLabel;
    Filename: TLabel;
    AnalysisNameComboBox: TComboBox;
    FilenameEdit: TEdit;
    BrowseButton: TButton;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    OpenDialog1: TOpenDialog;
    procedure BrowseButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEventImport: TfrmEventImport;

implementation

uses modDatabase, stormEvent, rdiiutils, mainform;

{$R *.DFM}

procedure TfrmEventImport.BrowseButtonClick(Sender: TObject);
begin
  if (OpenDialog1.Execute) then FilenameEdit.Text := OpenDialog1.Filename;
end;

procedure TfrmEventImport.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEventImport.FormShow(Sender: TObject);
begin
  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames;
  AnalysisNameComboBox.ItemIndex := 0;
end;

procedure TfrmEventImport.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEventImport.okButtonClick(Sender: TObject);
var
  F: TextFile;
  line, sPatternName: String;
  startDate, endDate: TDateTime;
  i, spacePos, analysisID: integer;
  Event: TStormEvent;
begin
  if fileCanBeRead(FilenameEdit.Text) then begin
    analysisID := DatabaseModule.GetAnalysisIDForName(AnalysisNameComboBox.Items.Strings[AnalysisNameComboBox.ItemIndex]);
    AssignFile(F,FilenameEdit.Text);
    Reset(F);
    //rm 2009-08-14 - skip the first line (header)
    readln(F,line);
    while (not eof(f)) do begin
      readln(F,line);
      line := TrimLeft(line)+' ';
      spacePos := Pos(' ',line);
      startDate := StrToDate(copy(line,1,spacePos-1));
      line := copy(line,spacePos+1,length(line)-spacePos);
      spacePos := Pos(' ',line);
      startDate := startDate + StrToTime(copy(line,1,spacePos-1));
      line := copy(line,spacePos+1,length(line)-spacePos);
      spacePos := Pos(' ',line);
      endDate := StrToDate(copy(line,1,spacePos-1));
      line := copy(line,spacePos+1,length(line)-spacePos);
      spacePos := Pos(' ',line);
      endDate := endDate + StrToTime(copy(line,1,spacePos-1));
      event := TStormEvent.Create(startDate,endDate,analysisID);
      for i := 0 to 2 do begin
        line := copy(line,spacePos+1,length(line)-spacePos);
        spacePos := Pos(' ',line);
        event.R[i] := strToFloat(copy(line,1,spacePos-1));

        line := copy(line,spacePos+1,length(line)-spacePos);
        spacePos := Pos(' ',line);
        event.T[i] := strToFloat(copy(line,1,spacePos-1));

        line := copy(line,spacePos+1,length(line)-spacePos);
        spacePos := Pos(' ',line);
        event.K[i] := strToFloat(copy(line,1,spacePos-1));
      end;
      //rm 2009-08-14 - now including am, ar, and ai
      line := copy(line,spacePos+1,length(line)-spacePos);
      spacePos := Pos(' ',line);
//rm 2010-09-29      event.AM := strToFloat(copy(line,1,spacePos-1));
      event.AM[1] := strToFloat(copy(line,1,spacePos-1));
      line := copy(line,spacePos+1,length(line)-spacePos);
      spacePos := Pos(' ',line);
//rm 2010-09-29      event.AR := strToFloat(copy(line,1,spacePos-1));
      event.AR[1] := strToFloat(copy(line,1,spacePos-1));
      line := copy(line,spacePos+1,length(line)-spacePos);
      spacePos := Pos(' ',line);
//rm 2010-09-29      event.AI := strToFloat(copy(line,1,spacePos-1));
      event.AI[1] := strToFloat(copy(line,1,spacePos-1));
      DatabaseModule.AddEvent(analysisID,event);

      //rm 2009-08-14 - add blank RTKPattern when adding event
        sPatternName := DatabaseModule.GetDefaultRTKPatternName(AnalysisID, startDate);
        DatabaseModule.CreateNewRTKPattern4Event(event, sPatternName);
        DatabaseModule.UpdateEvent(event);
      //

    end;
    CloseFile(F);
    i := MessageDlg('Done importing from ' + FilenameEdit.Text + '.',
      mtInformation, [mbok],0);
//    Close;
  end;
end;

end.
