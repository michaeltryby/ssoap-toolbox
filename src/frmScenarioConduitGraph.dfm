object ScenarioConduitGraphForm: TScenarioConduitGraphForm
  Left = 0
  Top = 0
  Caption = 'Scenario Comparison: Additional Data'
  ClientHeight = 468
  ClientWidth = 606
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
    606
    468)
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
  object LabelID: TLabel
    Left = 8
    Top = 93
    Width = 41
    Height = 13
    Caption = 'Conduit:'
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
    Width = 53
    Height = 13
    Caption = 'Flow Units:'
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
    Text = 'Conduit Max Capacity'
    OnChange = ComboBoxTypeChange
    Items.Strings = (
      'Conduit Max Capacity'
      'Junction Max Depth'
      'Outfall Volume'
      'SSO Volume'
      'Junction Flooding')
  end
  object ComboBoxConduit: TComboBox
    Left = 80
    Top = 90
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    OnChange = ComboBoxConduitChange
  end
  object CheckBoxScenarioAUnits: TCheckBox
    Left = 240
    Top = 89
    Width = 153
    Height = 17
    Caption = 'Use Scenario A Units'
    TabOrder = 4
    Visible = False
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 128
    Width = 329
    Height = 332
    Anchors = [akLeft, akTop, akBottom]
    ColCount = 3
    DefaultColWidth = 24
    DefaultRowHeight = 20
    DefaultDrawing = False
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 5
    OnDrawCell = StringGrid1DrawCell
    ColWidths = (
      24
      138
      135)
  end
end
