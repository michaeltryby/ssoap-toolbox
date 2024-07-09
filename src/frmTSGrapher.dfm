object TSGrapherForm: TTSGrapherForm
  Left = 0
  Top = 0
  Caption = 'Timeseries Graphs'
  ClientHeight = 354
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 17
    Top = 37
    Width = 130
    Height = 13
    Caption = 'Depth Timeseries Junctions'
  end
  object Label3: TLabel
    Left = 16
    Top = 8
    Width = 175
    Height = 13
    Caption = 'Please Select the Junctions to Graph'
  end
  object Label1: TLabel
    Left = 17
    Top = 157
    Width = 127
    Height = 13
    Caption = 'SSO  and Outfall Junctions'
  end
  object LabelGraphName: TLabel
    Left = 200
    Top = 37
    Width = 24
    Height = 13
    Caption = '        '
  end
  object ListBoxSelectedNodes: TListBox
    Left = 17
    Top = 54
    Width = 161
    Height = 97
    ItemHeight = 13
    MultiSelect = True
    Sorted = True
    TabOrder = 0
    OnClick = ListBoxSelectedNodesClick
    OnDblClick = ListBoxSelectedNodesDblClick
  end
  object btnOK: TButton
    Left = 72
    Top = 321
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnHelp: TButton
    Left = 176
    Top = 321
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 2
    Visible = False
    OnClick = btnHelpClick
  end
  object btnCancel: TButton
    Left = 280
    Top = 321
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object Memo1: TMemo
    Left = 200
    Top = 56
    Width = 209
    Height = 217
    ScrollBars = ssVertical
    TabOrder = 4
    WantReturns = False
    WordWrap = False
  end
  object ListBoxSSOs: TListBox
    Left = 16
    Top = 176
    Width = 161
    Height = 97
    ItemHeight = 13
    MultiSelect = True
    Sorted = True
    TabOrder = 5
    OnClick = ListBoxSSOsClick
    OnDblClick = ListBoxSSOsDblClick
  end
  object btnCopy2Clipboard: TButton
    Left = 296
    Top = 279
    Width = 113
    Height = 25
    Caption = 'Copy to Clipboard'
    TabOrder = 6
    OnClick = btnCopy2ClipboardClick
  end
  object CheckBoxSSOsOnly: TCheckBox
    Left = 17
    Top = 279
    Width = 97
    Height = 17
    Caption = 'SSOs Only'
    TabOrder = 7
    OnClick = CheckBoxSSOsOnlyClick
  end
  object btnGraph: TButton
    Left = 199
    Top = 279
    Width = 75
    Height = 25
    Caption = 'Graph'
    TabOrder = 8
    OnClick = btnGraphClick
  end
  object CheckBoxScenarioUnits: TCheckBox
    Left = 256
    Top = 8
    Width = 153
    Height = 17
    Caption = 'Use Scenario Units'
    TabOrder = 9
    OnClick = CheckBoxScenarioUnitsClick
  end
end
