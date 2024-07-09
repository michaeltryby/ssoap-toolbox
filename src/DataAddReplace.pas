unit DataAddReplace;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmDataAddReplace = class(TForm)
    addButton: TButton;
    removeButton: TButton;
    cancelButton: TButton;
    helpButton: TButton;
    WarningLabel: TLabel;
    procedure addButtonClick(Sender: TObject);
    procedure removeButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
  public { Public declarations }
  end;

var
  frmDataAddReplace: TfrmDataAddReplace;

implementation

uses mainform;

{$R *.DFM}

procedure TfrmDataAddReplace.addButtonClick(Sender: TObject);
begin
  ModalResult := mrAll + 1;
end;

procedure TfrmDataAddReplace.removeButtonClick(Sender: TObject);
begin
  ModalResult := mrAll + 2;
end;

procedure TfrmDataAddReplace.cancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmDataAddReplace.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

end.
