unit importsewersheddata;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Spin;

type
  TfrmImportSewerShedDataUsingConverter = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    FilenameEdit: TEdit;
    browseButton: TButton;
    ConverterComboBox: TComboBox;
    okButton: TButton;
    cancelButton: TButton;
    helpButton: TButton;
    SewershedNameComboBox: TComboBox;
    OpenDialog1: TOpenDialog;
    TagEdit: TEdit;
    Label4: TLabel;
    ButtonViewConverter: TButton;
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure browseButtonClick(Sender: TObject);
    procedure ButtonViewConverterClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
  public { Public declarations }
  end;

var
  frmImportSewerShedDataUsingConverter: TfrmImportSewerShedDataUsingConverter;

implementation

uses modDatabase, feedbackWithMemo, sewershedConverterImportThread,
  DataAddReplace, rdiiutils, editsewersheddataconverter, mainform;

{$R *.DFM}

procedure TfrmImportSewerShedDataUsingConverter.okButtonClick(Sender: TObject);
var
  okToImport: boolean;
  sewershedName: string;
  res: integer;
begin
  if fileCanBeRead(FilenameEdit.Text) then begin
    okToImport := true;
    sewershedName := SewershedNameComboBox.Items.Strings[SewershedNameComboBox.ItemIndex];
    if (okToImport) then begin
      ConverterImportThread.CreateIt();
      frmFeedbackWithMemo.Caption := 'Importing Sewershed Data Using Converter';
      frmFeedbackWithMemo.OpenForProcessing;
//      Close;
    end;
  end;
end;

procedure TfrmImportSewerShedDataUsingConverter.ButtonViewConverterClick(
  Sender: TObject);
begin
  if length(ConverterComboBox.Text) > 0 then begin
    frmEditSewershedDataConverter.SelectedSewerShedConverterName :=
      ConverterComboBox.Text;
    frmEditSewershedDataConverter.ShowModal;
  end;
end;

procedure TfrmImportSewerShedDataUsingConverter.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImportSewerShedDataUsingConverter.FormShow(Sender: TObject);
begin
  ConverterComboBox.Items := DatabaseModule.GetSewerShedConverterNames;
  ConverterComboBox.ItemIndex := 0;
  SewershedNameComboBox.Items := DatabaseModule.GetSewershedNames;
  SewershedNameComboBox.ItemIndex := 0;
end;


procedure TfrmImportSewerShedDataUsingConverter.helpButtonClick(
  Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmImportSewerShedDataUsingConverter.browseButtonClick(Sender: TObject);
begin
  if (OpenDialog1.Execute) then FilenameEdit.Text := OpenDialog1.Filename;
end;

end.
