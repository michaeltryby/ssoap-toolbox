unit feedbackWithMemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

const
  WM_ThreadDoneMsg = WM_User + 8;

type
  TfrmFeedbackWithMemo = class(TForm)
    StatusLabel: TLabel;
    DateLabel: TLabel;
    feedbackMemo: TMemo;
    CloseButton: TButton;
    saveToFileButton: TButton;
    MemoSaveDialog: TSaveDialog;
    Button1: TButton;
    procedure CloseButtonClick(Sender: TObject);
    procedure saveToFileButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    procedure ThreadDone(var AMessage : TMessage); message WM_ThreadDoneMsg;
  public
    procedure OpenForProcessing;
    procedure OpenAfterProcessing;
    procedure DoneProcessing;
  end;

var
  frmFeedbackWithMemo: TfrmFeedbackWithMemo;

implementation

uses mainform;

{$R *.DFM}

procedure TfrmFeedbackWithMemo.ThreadDone(var AMessage: TMessage);
begin
  CloseButton.Enabled := true;
  StatusLabel.Caption := 'Processing Complete';
  DateLabel.Caption := '';
  Screen.Cursor := crDefault;
end;

procedure TfrmFeedbackWithMemo.Button1Click(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmFeedbackWithMemo.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFeedbackWithMemo.DoneProcessing;
begin
  StatusLabel.Caption := 'Processing Complete';
  DateLabel.Caption := '';
  Screen.Cursor := crDefault;
end;

procedure TfrmFeedbackWithMemo.OpenForProcessing;
begin
  Screen.Cursor := crHourglass;
  Self.Width := 500;
  Self.Height := 500;
  FeedbackMemo.Clear;
  CloseButton.Enabled := false;
  StatusLabel.Caption := 'Processing Date:';
  DateLabel.Caption := '00/00/00';
  Self.ShowModal;
end;

procedure TfrmFeedbackWithMemo.OpenAfterProcessing;
begin
  Self.Width := 500;
  Self.Height := 500;
  CloseButton.Enabled := true;
  Self.ShowModal;
end;


procedure TfrmFeedbackWithMemo.saveToFileButtonClick(
  Sender: TObject);
begin
  if (MemoSaveDialog.Execute) then
    FeedbackMemo.Lines.SaveToFile(MemoSaveDialog.Filename);
end;

procedure TfrmFeedbackWithMemo.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  canClose := CloseButton.Enabled;
end;

end.
