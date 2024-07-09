object TSGraphForm: TTSGraphForm
  Left = 0
  Top = 0
  Caption = 'Timeseries Graph'
  ClientHeight = 350
  ClientWidth = 518
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
    518
    350)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 41
    Height = 13
    Caption = 'Scenario'
  end
  object Label2: TLabel
    Left = 8
    Top = 39
    Width = 24
    Height = 13
    Caption = 'Type'
  end
  object Label3: TLabel
    Left = 8
    Top = 65
    Width = 40
    Height = 13
    Caption = 'Junction'
  end
  object LabelSCFlowUnits: TLabel
    Left = 240
    Top = 11
    Width = 97
    Height = 13
    Caption = 'Scenario Flow Units:'
  end
  object LabelSCDepthUnits: TLabel
    Left = 389
    Top = 11
    Width = 104
    Height = 13
    Caption = 'Scenario Depth Units:'
  end
  object LabelTSUnits: TLabel
    Left = 240
    Top = 65
    Width = 106
    Height = 13
    Caption = 'Timeseries Flow Units:'
  end
  object ComboBoxScenario: TComboBox
    Left = 80
    Top = 8
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnChange = ComboBoxScenarioChange
  end
  object ComboBoxType: TComboBox
    Left = 80
    Top = 35
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'Junction Depth'
    OnChange = ComboBoxTypeChange
    Items.Strings = (
      'Junction Depth'
      'Outfall Flow'
      'SSO Flow')
  end
  object ComboBoxJunction: TComboBox
    Left = 80
    Top = 62
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    OnChange = ComboBoxJunctionChange
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 96
    Width = 249
    Height = 246
    Anchors = [akLeft, akTop, akBottom]
    ColCount = 4
    DefaultColWidth = 24
    DefaultRowHeight = 20
    TabOrder = 3
    ColWidths = (
      24
      124
      63
      24)
  end
  object CheckBoxScenarioUnits: TCheckBox
    Left = 240
    Top = 38
    Width = 153
    Height = 17
    Caption = 'Use Scenario Units'
    TabOrder = 4
    Visible = False
    OnClick = CheckBoxScenarioUnitsClick
  end
end
