object frmComparisonSummary: TfrmComparisonSummary
  Left = 227
  Top = 117
  Caption = 'Simulated vs. Observed RDII Summary Statistics'
  ClientHeight = 504
  ClientWidth = 576
  Color = clBtnFace
  Constraints.MinHeight = 310
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
    576
    504)
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
    Left = 216
    Top = 7
    Width = 38
    Height = 13
    Caption = 'Event #'
  end
  object AnalysisNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 177
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = AnalysisNameComboBoxChange
  end
  object StatisticsMemo: TMemo
    Left = 7
    Top = 53
    Width = 561
    Height = 268
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
    Left = 493
    Top = 474
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 6
    OnClick = closeButtonClick
  end
  object EventSpinEdit: TSpinEdit
    Left = 216
    Top = 24
    Width = 161
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 1
    Value = 1
    OnChange = EventSpinEditChange
  end
  object saveToCSVFileButton: TButton
    Left = 8
    Top = 474
    Width = 105
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Save To CSV File...'
    TabOrder = 4
    OnClick = saveToCSVFileButtonClick
  end
  object SummaryMemo: TMemo
    Left = 7
    Top = 329
    Width = 561
    Height = 138
    Anchors = [akLeft, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object Button1: TButton
    Left = 119
    Top = 473
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Show Plot...'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 328
    Top = 474
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Help'
    Enabled = False
    TabOrder = 7
    Visible = False
    OnClick = Button2Click
  end
  object MemoDebug: TMemo
    Left = 8
    Top = 96
    Width = 560
    Height = 115
    Anchors = [akLeft, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 8
    Visible = False
  end
  object SaveStatsDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 264
    Top = 464
  end
end
