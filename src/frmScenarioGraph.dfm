object ScenarioGraphForm: TScenarioGraphForm
  Left = 0
  Top = 0
  Caption = 'Scenario Comparison: Timeseries'
  ClientHeight = 467
  ClientWidth = 590
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  DesignSize = (
    590
    467)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 51
    Height = 13
    Caption = 'Scenario A'
  end
  object Label2: TLabel
    Left = 8
    Top = 39
    Width = 50
    Height = 13
    Caption = 'Scenario B'
  end
  object Label3: TLabel
    Left = 8
    Top = 67
    Width = 24
    Height = 13
    Caption = 'Type'
  end
  object Label4: TLabel
    Left = 8
    Top = 93
    Width = 40
    Height = 13
    Caption = 'Junction'
  end
  object LabelSCAFlowUnits: TLabel
    Left = 240
    Top = 11
    Width = 107
    Height = 13
    Caption = 'Scenario A Flow Units:'
  end
  object LabelSCADepthUnits: TLabel
    Left = 389
    Top = 11
    Width = 114
    Height = 13
    Caption = 'Scenario A Depth Units:'
  end
  object LabelSCBFlowUnits: TLabel
    Left = 240
    Top = 39
    Width = 106
    Height = 13
    Caption = 'Scenario B Flow Units:'
  end
  object LabelSCBDepthUnits: TLabel
    Left = 389
    Top = 39
    Width = 113
    Height = 13
    Caption = 'Scenario B Depth Units:'
  end
  object LabelTSUnits: TLabel
    Left = 240
    Top = 67
    Width = 106
    Height = 13
    Caption = 'Timeseries Flow Units:'
  end
  object ComboBoxScenarioA: TComboBox
    Left = 80
    Top = 8
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnChange = ComboBoxScenarioAChange
  end
  object ComboBoxScenarioB: TComboBox
    Left = 80
    Top = 36
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    OnChange = ComboBoxScenarioBChange
  end
  object ComboBoxType: TComboBox
    Left = 80
    Top = 63
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = 'Junction Depth'
    OnChange = ComboBoxTypeChange
    Items.Strings = (
      'Junction Depth'
      'Outfall Flow'
      'SSO Flow')
  end
  object ComboBoxJunction: TComboBox
    Left = 80
    Top = 90
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    OnChange = ComboBoxJunctionChange
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 128
    Width = 329
    Height = 331
    Anchors = [akLeft, akTop, akBottom]
    ColCount = 4
    DefaultColWidth = 24
    DefaultRowHeight = 20
    DefaultDrawing = False
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 4
    OnDrawCell = StringGrid1DrawCell
    ColWidths = (
      24
      124
      80
      75)
  end
  object CheckBoxScenarioAUnits: TCheckBox
    Left = 240
    Top = 92
    Width = 153
    Height = 17
    Caption = 'Use Scenario A Units'
    TabOrder = 5
    Visible = False
    OnClick = CheckBoxScenarioAUnitsClick
  end
end
