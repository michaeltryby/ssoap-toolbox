object frmEventStatisitics: TfrmEventStatisitics
  Left = 317
  Top = 160
  Caption = 'Summary of I/I Event Statistics'
  ClientHeight = 486
  ClientWidth = 509
  Color = clBtnFace
  Constraints.MinHeight = 210
  Constraints.MinWidth = 420
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    509
    486)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 7
    Width = 69
    Height = 13
    Caption = 'Analysis Name'
  end
  object Label2: TLabel
    Left = 184
    Top = 7
    Width = 38
    Height = 13
    Caption = 'Event #'
  end
  object AnalysisNameComboBox: TComboBox
    Left = 8
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = AnalysisNameComboBoxChange
  end
  object StatisticsMemo: TMemo
    Left = 8
    Top = 51
    Width = 494
    Height = 395
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object closeButton: TButton
    Left = 428
    Top = 455
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 5
    OnClick = closeButtonClick
  end
  object EventSpinEdit: TSpinEdit
    Left = 184
    Top = 24
    Width = 121
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 1
    Value = 1
    OnChange = EventSpinEditChange
  end
  object saveToTextFileButton: TButton
    Left = 8
    Top = 455
    Width = 105
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Save To Text File...'
    TabOrder = 3
    OnClick = saveToTextFileButtonClick
  end
  object saveToCSVFileButton: TButton
    Left = 120
    Top = 455
    Width = 105
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Save To CSV File...'
    TabOrder = 4
    OnClick = saveToCSVFileButtonClick
  end
  object Button1: TButton
    Left = 296
    Top = 455
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Help'
    Enabled = False
    TabOrder = 6
    Visible = False
    OnClick = Button1Click
  end
  object SaveStatsDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 232
    Top = 448
  end
end
