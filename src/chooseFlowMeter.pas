unit chooseFlowMeter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmFlowMeterSelector = class(TForm)
    FlowMeterNameComboBox: TComboBox;
    Label1: TLabel;
    OKButton: TButton;
    HelpButton: TButton;
    btnClose: TButton;
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
  private { Private declarations }
  public { Public declarations }
    function SelectedMeter(): string;
  end;

var
  frmFlowMeterSelector: TfrmFlowMeterSelector;

implementation

uses modDatabase, mainform;

{$R *.DFM}

procedure TfrmFlowMeterSelector.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmFlowMeterSelector.FormShow(Sender: TObject);
var i: integer;
  oldval: string;
begin
  i := FlowMeterNameComboBox.ItemIndex;
  if (i > -1) and (i < FlowMeterNameComboBox.Items.Count) then
    oldval := FlowMeterNameComboBox.Items[i]
  else
    oldval := '';
  FlowMeterNameComboBox.Items := DatabaseModule.GetFlowMeterNames;
  if (i > -1) and (i < FlowMeterNameComboBox.Items.Count) then begin
    FlowMeterNameComboBox.ItemIndex := i;
  end else begin
    FlowMeterNameComboBox.ItemIndex := 0;
  end;
end;

procedure TfrmFlowMeterSelector.HelpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmFlowMeterSelector.OKButtonClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

function TfrmFlowMeterSelector.SelectedMeter(): string;
begin
  SelectedMeter := FlowMeterNameComboBox.Items.Strings[FlowMeterNameComboBox.ItemIndex];
end;


end.
