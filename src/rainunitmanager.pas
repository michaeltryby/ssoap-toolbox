unit rainunitmanager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmRainUnitManagement = class(TForm)
    Label1: TLabel;
    addButton: TButton;
    closeButton: TButton;
    helpButton: TButton;
    editButton: TButton;
    deleteButton: TButton;
    procedure closeButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
  public { Public declarations }
  end;

var
  frmRainUnitManagement: TfrmRainUnitManagement;

implementation

uses mainform;

{$R *.DFM}

procedure TfrmRainUnitManagement.closeButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRainUnitManagement.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

end.
