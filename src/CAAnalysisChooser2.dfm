object frmCAAnalysisChooser2: TfrmCAAnalysisChooser2
  Left = 0
  Top = 0
  Caption = 'RDII Prioritization Analysis Results'
  ClientHeight = 295
  ClientWidth = 553
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  DesignSize = (
    553
    295)
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 93
    Height = 13
    Caption = 'Available Analyzes:'
  end
  object Label4: TLabel
    Left = 304
    Top = 8
    Width = 185
    Height = 13
    Caption = 'Select up to 3 analyzes for comparison'
  end
  object Label6: TLabel
    Left = 568
    Top = 8
    Width = 241
    Height = 26
    AutoSize = False
    Caption = 'These are the Sewersheds in the Selected Scenario:'
    WordWrap = True
  end
  object okButton: TButton
    Left = 140
    Top = 266
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'View Results'
    Default = True
    TabOrder = 0
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 244
    Top = 266
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Help'
    TabOrder = 1
    Visible = False
  end
  object btnClose: TButton
    Left = 356
    Top = 266
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Close'
    Default = True
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object ListBoxSelected: TListBox
    Left = 568
    Top = 40
    Width = 241
    Height = 138
    ItemHeight = 13
    TabOrder = 3
  end
  object ComparisonScenarioListBox: TListBox
    Left = 8
    Top = 27
    Width = 241
    Height = 233
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = ComparisonScenarioListBoxClick
  end
  object ScenarioToDisplayListBox: TListBox
    Left = 304
    Top = 27
    Width = 241
    Height = 233
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = ComparisonScenarioListBoxClick
  end
  object SelectScenarioForDisplay: TButton
    Left = 257
    Top = 41
    Width = 41
    Height = 25
    Caption = ' --->'
    TabOrder = 6
    OnClick = SelectScenarioForDisplayClick
  end
  object RemoveScenarioFromDisplay: TButton
    Left = 256
    Top = 81
    Width = 41
    Height = 25
    Caption = ' X'
    TabOrder = 7
    OnClick = RemoveScenarioFromDisplayClick
  end
  object ListBoxAvailable: TListBox
    Left = 832
    Top = 40
    Width = 241
    Height = 138
    ItemHeight = 13
    TabOrder = 8
    Visible = False
  end
  object btnQuickView: TButton
    Left = 8
    Top = 266
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '^-Quick View'
    Enabled = False
    TabOrder = 9
    Visible = False
    OnClick = btnQuickViewClick
  end
end
