unit existEventsWarning;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmEventsExistWarning = class(TForm)
    removeButton: TButton;
    saveButton: TButton;
    cancelButton: TButton;
    Label1: TLabel;
    Image1: TImage;
    Button1: TButton;
    procedure removeButtonClick(Sender: TObject);
    procedure saveButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private { Private declarations }
  public { Public declarations }
  end;

var
  frmEventsExistWarning: TfrmEventsExistWarning;

implementation

uses mainform;

{$R *.DFM}

procedure TfrmEventsExistWarning.removeButtonClick(Sender: TObject);
begin
  ModalResult := mrAll + 1;
end;

procedure TfrmEventsExistWarning.saveButtonClick(Sender: TObject);
begin
  ModalResult := mrAll + 2;
end;

procedure TfrmEventsExistWarning.Button1Click(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmEventsExistWarning.cancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
