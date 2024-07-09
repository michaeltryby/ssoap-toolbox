object frmFeedbackWithMemo: TfrmFeedbackWithMemo
  Left = 320
  Top = 160
  Caption = 'THIS CAPTION SHOULD BE REPLACED PROGRAMATICALLY'
  ClientHeight = 467
  ClientWidth = 492
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 320
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    492
    467)
  PixelsPerInch = 96
  TextHeight = 13
  object StatusLabel: TLabel
    Left = 7
    Top = 7
    Width = 81
    Height = 13
    Caption = 'Processing Date:'
  end
  object DateLabel: TLabel
    Left = 120
    Top = 7
    Width = 46
    Height = 13
    Caption = '00/00/00'
  end
  object feedbackMemo: TMemo
    Left = 7
    Top = 28
    Width = 480
    Height = 405
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object CloseButton: TButton
    Left = 412
    Top = 440
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 2
    OnClick = CloseButtonClick
  end
  object saveToFileButton: TButton
    Left = 7
    Top = 440
    Width = 95
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Save To File...'
    TabOrder = 1
    OnClick = saveToFileButtonClick
  end
  object Button1: TButton
    Left = 208
    Top = 440
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Help'
    TabOrder = 3
    Visible = False
    OnClick = Button1Click
  end
  object MemoSaveDialog: TSaveDialog
    DefaultExt = '.TXT'
    Filter = 'Text Files|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 112
    Top = 432
  end
end
