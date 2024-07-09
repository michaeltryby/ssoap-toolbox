unit importcatchmentdata;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Spin;

type
  TfrmImportRDIIAreaDataUsingConverter = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    FilenameEdit: TEdit;
    browseButton: TButton;
    ConverterComboBox: TComboBox;
    okButton: TButton;
    cancelButton: TButton;
    helpButton: TButton;
    RDIIAreaNameComboBox: TComboBox;
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
  frmImportRDIIAreaDataUsingConverter: TfrmImportRDIIAreaDataUsingConverter;

implementation

uses modDatabase, feedbackWithMemo, catchmentConverterImportThread,
  DataAddReplace, rdiiutils, addcatchmentconverter, mainform;

{$R *.DFM}

procedure TfrmImportRDIIAreaDataUsingConverter.okButtonClick(Sender: TObject);
var
  okToImport: boolean;
  RDIIAreaName: string;
  res: integer;
begin
  if fileCanBeRead(FilenameEdit.Text) then begin
    okToImport := true;
    RDIIAreaName := RDIIAreaNameComboBox.Items.Strings[RDIIAreaNameComboBox.ItemIndex];
    if (okToImport) then begin
      ConverterImportThread.CreateIt();
      frmFeedbackWithMemo.Caption := 'Importing RDIIArea Data Using Converter';
      frmFeedbackWithMemo.OpenForProcessing;
      Close;
    end;
  end;
end;

procedure TfrmImportRDIIAreaDataUsingConverter.ButtonViewConverterClick(
  Sender: TObject);
begin
  if Length(ConverterComboBox.Text) > 0 then begin
    frmAddRDIIAreaDataConverter.boAddingNew := False;
    frmAddRDIIAreaDataConverter.SelectedRDIIAreaConverterName :=
      ConverterComboBox.Text;
    frmAddRDIIAreaDataConverter.ShowModal;
  end;
end;

procedure TfrmImportRDIIAreaDataUsingConverter.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImportRDIIAreaDataUsingConverter.FormShow(Sender: TObject);
begin
  ConverterComboBox.Items := DatabaseModule.GetRDIIAreaConverterNames;
  ConverterComboBox.ItemIndex := 0;
  RDIIAreaNameComboBox.Items := DatabaseModule.GetRDIIAreaNames;
  RDIIAreaNameComboBox.ItemIndex := 0;
end;


procedure TfrmImportRDIIAreaDataUsingConverter.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmImportRDIIAreaDataUsingConverter.browseButtonClick(Sender: TObject);
begin
  if (OpenDialog1.Execute) then FilenameEdit.Text := OpenDialog1.Filename;
end;

end.
