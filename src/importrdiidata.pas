unit importrdiidata;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Spin;

type
  TfrmImportRdiiDataUsingConverter = class(TForm)
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
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure browseButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
  public { Public declarations }
  end;

var
  frmImportRdiiDataUsingConverter: TfrmImportRdiiDataUsingConverter;

implementation

uses modDatabase, feedbackWithMemo, rdiiConverterImportThread,
  DataAddReplace, rdiiutils, mainform;

{$R *.DFM}

procedure TfrmImportRdiiDataUsingConverter.okButtonClick(Sender: TObject);
var
  okToImport: boolean;
  sewershedName: string;
  res: integer;
begin
  if fileCanBeRead(FilenameEdit.Text) then begin
    okToImport := true;
    sewershedName := SewershedNameComboBox.Items.Strings[SewershedNameComboBox.ItemIndex];
    if (okToImport) then begin
      rdiiConvertandImportThread.CreateIt();
      frmFeedbackWithMemo.Caption := 'Importing RDII Data Using Converter';
      frmFeedbackWithMemo.OpenForProcessing;
      Close;
    end;
  end;
end;

procedure TfrmImportRdiiDataUsingConverter.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImportRdiiDataUsingConverter.FormShow(Sender: TObject);
begin
  ConverterComboBox.Items := DatabaseModule.GetRdiiConverterNames;
  ConverterComboBox.ItemIndex := 0;
  SewershedNameComboBox.Items := DatabaseModule.GetSewershedNames;
  SewershedNameComboBox.ItemIndex := 0;
end;


procedure TfrmImportRdiiDataUsingConverter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmImportRdiiDataUsingConverter.browseButtonClick(Sender: TObject);
begin
  if (OpenDialog1.Execute) then FilenameEdit.Text := OpenDialog1.Filename;
end;

end.
