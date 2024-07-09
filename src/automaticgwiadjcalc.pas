unit automaticgwiadjcalc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmAutomaticGWIAdjustmentCalculation = class(TForm)
    Label1: TLabel;
    AnalysisNameComboBox: TComboBox;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    procedure FormShow(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
  public { Public declarations }
  end;

var
  frmAutomaticGWIAdjustmentCalculation: TfrmAutomaticGWIAdjustmentCalculation;

implementation

uses modDatabase, autowiadjcalcthread, feedbackWithMemo, mainform;

{$R *.DFM}

procedure TfrmAutomaticGWIAdjustmentCalculation.FormShow(Sender: TObject);
begin
  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames();
  AnalysisNameComboBox.ItemIndex := 0;
end;

procedure TfrmAutomaticGWIAdjustmentCalculation.helpButtonClick(
  Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmAutomaticGWIAdjustmentCalculation.cancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAutomaticGWIAdjustmentCalculation.okButtonClick(Sender: TObject);
var
  analysisName: string;
  okToProcess: boolean;
  res: integer;
begin
  analysisName := AnalysisNameComboBox.Items.Strings[AnalysisNameComboBox.ItemIndex];
  okToProcess := true;
  if (DatabaseModule.AnalysisHasGWIAdjustments(analysisName)) then begin
    res := MessageDlg('Analysis "'+analysisName+'" has DWF Adjustments defined.  Do you'+#13
                     +'wish to remove these DWF adjustments and continue?',mtWarning,[mbYes,mbNo],0);
    if (res = mrNo) then okToProcess := false;
  end;
  if (okToProcess) then begin
    automaticGWIAdjCalcThread.CreateIt();
    frmFeedbackWithMemo.Caption := 'Automatic DWF Adjustment Calculation';
    frmFeedbackWithMemo.OpenForProcessing;
//    Close;
  end;
end;

end.
