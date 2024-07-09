unit eventExport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmEventExport = class(TForm)
    AnalysisLabel: TLabel;
    AnalysisNameComboBox: TComboBox;
    Filename: TLabel;
    FilenameEdit: TEdit;
    BrowseButton: TButton;
    SaveDialog1: TSaveDialog;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    procedure FormShow(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure BrowseButtonClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEventExport: TfrmEventExport;

implementation

uses modDatabase, StormEventCollection, StormEvent, rdiiutils, mainform;

{$R *.DFM}

procedure TfrmEventExport.FormShow(Sender: TObject);
var i: integer;
  oldval: string;
//  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames;
//  AnalysisNameComboBox.ItemIndex := 0;
begin
  i := AnalysisNameComboBox.ItemIndex;
  if (i > -1) and (i < AnalysisNameComboBox.Items.Count) then
    oldval := AnalysisNameComboBox.Items[i]
  else
    oldval := '';
  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames;
  if (i > -1) and (i < AnalysisNameComboBox.Items.Count) then begin
    AnalysisNameComboBox.ItemIndex := i;
  end else begin
    AnalysisNameComboBox.ItemIndex := 0;
  end;
end;

procedure TfrmEventExport.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEventExport.cancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmEventExport.BrowseButtonClick(Sender: TObject);
begin
  if (SaveDialog1.Execute) then FilenameEdit.Text := SaveDialog1.Filename;
end;

procedure TfrmEventExport.okButtonClick(Sender: TObject);
var
  filename, txt: string;
  analysisID, i: integer;
  F: TextFile;
  events: TStormEventCollection;
  event: TStormEvent;

begin
  filename := FilenameEdit.Text;
  if fileCanBeWritten(filename) then begin
    AssignFile(F,filename);
    Rewrite(F);
    //rm 2009-06-09 - Beta 1 review comments - add header row:
//rm 2010-09-29    Writeln(F, 'StartDate StartTime EndDate EndTime r1 t1 k1 r2 t2 k2 r3 t3 k3 am ar ai');
    Writeln(F, 'StartDate StartTime EndDate EndTime r1 t1 k1 r2 t2 k2 r3 t3 k3 am1 ar1 ai1 am2 ar2 ai2 am3 ar3 ai3');
    analysisID := DatabaseModule.GetAnalysisIDForName(AnalysisNameComboBox.Items.Strings[AnalysisNameComboBox.ItemIndex]);
    events := DatabaseModule.GetEvents(analysisID);
    for i := 0 to events.count - 1 do begin
      event := events.items[i];
      DateTimeToString(txt,'MM/DD/YYYY HH:MM',event.startDate);
      write(F,txt,' ');
      DateTimeToString(txt,'MM/DD/YYYY HH:MM',event.endDate);
      write(F,txt,' ');
      write(F,FloatToStrF(event.R[0],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.T[0],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.K[0],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.R[1],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.T[1],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.K[1],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.R[2],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.T[2],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.K[2],ffGeneral,8,4),' ');
//rm 2010-09-29      write(F,FloatToStrF(event.AM,ffGeneral,8,4),' ');
//rm 2010-09-29      write(F,FloatToStrF(event.AR,ffGeneral,8,4),' ');
//rm 2010-09-29      write(F,FloatToStrF(event.AI,ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.AM[1],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.AR[1],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.AI[1],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.AM[2],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.AR[2],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.AI[2],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.AM[3],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.AR[3],ffGeneral,8,4),' ');
      write(F,FloatToStrF(event.AI[3],ffGeneral,8,4),' ');
      writeln(F);
    end;
    Closefile(F);
    events.Free;
    i := MessageDlg('Done exporting to ' + filename + '.',
      mtInformation, [mbok],0);
    ModalResult := mrOK; //mrAll + 1;
  end;
end;

end.
