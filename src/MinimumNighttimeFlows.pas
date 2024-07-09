unit MinimumNighttimeFlows;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin;

type
  TfrmMinimumNighttimeFlows = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    FlowMeterNameComboBox: TComboBox;
    TimeStepsSpinEdit: TSpinEdit;
    okButton: TButton;
    helpButton: TButton;
    closeButton: TButton;
    NumberMinimumFlowsSpinEdit: TSpinEdit;
    procedure closeButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
  public { Public declarations }
  end;

var
  frmMinimumNighttimeFlows: TfrmMinimumNighttimeFlows;

implementation

uses modDatabase, nighttimeFlowsThread, feedbackWithMemo, mainform;

{$R *.DFM}

procedure TfrmMinimumNighttimeFlows.closeButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMinimumNighttimeFlows.FormShow(Sender: TObject);
begin
  FlowMeterNameComboBox.Items := DatabaseModule.GetFlowMeterNames;
  FlowMeterNameComboBox.ItemIndex := 0;
end;

procedure TfrmMinimumNighttimeFlows.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmMinimumNighttimeFlows.okButtonClick(Sender: TObject);
begin
  MinimumNighttimeFlowsThread.CreateIt;
  frmFeedbackWithMemo.Caption := 'Minimum Nighttime Flows';
  frmFeedbackWithMemo.OpenForProcessing;
//  Close;
end;

end.
