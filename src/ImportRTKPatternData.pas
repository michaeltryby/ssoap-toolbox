unit ImportRTKPatternData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmImportRTKPatternData = class(TForm)
    Label3: TLabel;
    RTKPatternNameComboBox: TComboBox;
    Label1: TLabel;
    FilenameEdit: TEdit;
    OpenDialog1: TOpenDialog;
    browseButton: TButton;
    Label2: TLabel;
    ConverterComboBox: TComboBox;
    Label4: TLabel;
    TagEdit: TEdit;
    ButtonViewConverter: TButton;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    procedure FormShow(Sender: TObject);
    procedure browseButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure ButtonViewConverterClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmImportRTKPatternData: TfrmImportRTKPatternData;

implementation
uses modDatabase, feedbackWithMemo, rtkPatternConverterImportThread,
  DataAddReplace, rdiiutils, addrtkpatternconverter, mainform;

{$R *.dfm}

procedure TfrmImportRTKPatternData.browseButtonClick(Sender: TObject);
begin
  if (OpenDialog1.Execute) then FilenameEdit.Text := OpenDialog1.Filename;
end;

procedure TfrmImportRTKPatternData.ButtonViewConverterClick(Sender: TObject);
begin
  if Length(ConverterComboBox.Text) > 0 then begin
    frmAddRTKPAtternConverter.boAddingNew := False;
    frmAddRTKPAtternConverter.SelectedRTKPAtternConverterName :=
      ConverterComboBox.Text;
    frmAddRTKPAtternConverter.ShowModal;
  end;
end;

procedure TfrmImportRTKPatternData.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImportRTKPatternData.FormShow(Sender: TObject);
begin
  ConverterComboBox.Items := DatabaseModule.GetRTKPatternConverterNames;
  ConverterComboBox.ItemIndex := 0;
  RTKPatternNameComboBox.Items := DatabaseModule.GetRTKPatternNames;
  RTKPatternNameComboBox.ItemIndex := 0;
end;

procedure TfrmImportRTKPatternData.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmImportRTKPatternData.okButtonClick(Sender: TObject);
var
  okToImport: boolean;
  res: integer;
begin
  if fileCanBeRead(FilenameEdit.Text) then begin
    okToImport := true;
    if (okToImport) then begin
      ConverterImportThread.CreateIt();
      frmFeedbackWithMemo.Caption := 'Importing RTK Pattern Data Using Converter';
      frmFeedbackWithMemo.OpenForProcessing;
//      Close;
    end;
  end;
end;

end.
