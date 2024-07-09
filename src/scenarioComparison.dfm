object frmScenarioComparison: TfrmScenarioComparison
  Left = 309
  Top = 140
  Caption = 'Scenario Comparison - Summary'
  ClientHeight = 567
  ClientWidth = 658
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    658
    567)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelStatus: TLabel
    Left = 303
    Top = 516
    Width = 56
    Height = 13
    Caption = 'LabelStatus'
  end
  object LabelFind: TLabel
    Left = 8
    Top = 511
    Width = 23
    Height = 13
    Caption = 'Find:'
  end
  object Label7: TLabel
    Left = 8
    Top = 543
    Width = 175
    Height = 13
    Caption = 'Flooding Criteria (Absolute Elevation):'
    Visible = False
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 317
    Height = 492
    Caption = 'Scenario A'
    DockSite = True
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 108
      Width = 53
      Height = 13
      Caption = 'Description'
    end
    object Label2: TLabel
      Left = 10
      Top = 22
      Width = 73
      Height = 13
      Caption = 'Scenario Name'
    end
    object Label5: TLabel
      Left = 10
      Top = 198
      Width = 94
      Height = 13
      Caption = 'Simulation Summary'
    end
    object Label9: TLabel
      Left = 10
      Top = 67
      Width = 77
      Height = 13
      Caption = 'Output Filename'
    end
    object ScenarioDescription1: TMemo
      Left = 10
      Top = 127
      Width = 295
      Height = 65
      Lines.Strings = (
        'ScenarioDescription')
      ReadOnly = True
      TabOrder = 0
    end
    object ScenarioNameComboBox1: TComboBox
      Left = 10
      Top = 41
      Width = 295
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      Sorted = True
      TabOrder = 1
      OnChange = ScenarioNameComboBox1Change
    end
    object Summarylistbox1: TListBox
      Left = 10
      Top = 217
      Width = 295
      Height = 264
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 2
      OnClick = Summarylistbox1Click
    end
    object EditOutFileName1: TEdit
      Left = 10
      Top = 81
      Width = 295
      Height = 21
      ReadOnly = True
      TabOrder = 3
    end
    object btnEditScenario: TButton
      Left = 232
      Top = 17
      Width = 73
      Height = 25
      Caption = 'Edit'
      TabOrder = 4
      OnClick = btnEditScenarioClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 335
    Top = 8
    Width = 317
    Height = 492
    Caption = 'Scenario B'
    TabOrder = 1
    object Label3: TLabel
      Left = 10
      Top = 108
      Width = 53
      Height = 13
      Caption = 'Description'
    end
    object Label4: TLabel
      Left = 10
      Top = 22
      Width = 73
      Height = 13
      Caption = 'Scenario Name'
    end
    object Label6: TLabel
      Left = 10
      Top = 198
      Width = 94
      Height = 13
      Caption = 'Simulation Summary'
    end
    object Label8: TLabel
      Left = 10
      Top = 67
      Width = 77
      Height = 13
      Caption = 'Output Filename'
    end
    object ScenarioDescription2: TMemo
      Left = 10
      Top = 127
      Width = 295
      Height = 65
      Lines.Strings = (
        'ScenarioDescription')
      ReadOnly = True
      TabOrder = 0
    end
    object ScenarioNameComboBox2: TComboBox
      Left = 10
      Top = 41
      Width = 295
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      OnChange = ScenarioNameComboBox2Change
    end
    object summarylistbox2: TListBox
      Left = 10
      Top = 217
      Width = 295
      Height = 264
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 2
    end
    object EditOutFileName2: TEdit
      Left = 10
      Top = 81
      Width = 295
      Height = 21
      ReadOnly = True
      TabOrder = 3
    end
    object Button1: TButton
      Left = 232
      Top = 17
      Width = 73
      Height = 25
      Caption = 'Edit'
      TabOrder = 4
      OnClick = Button1Click
    end
  end
  object cbxFind: TComboBox
    Left = 48
    Top = 508
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 2
  end
  object btnFind: TButton
    Left = 200
    Top = 506
    Width = 25
    Height = 25
    Caption = 'Go'
    TabOrder = 3
    OnClick = btnFindClick
  end
  object SpinEditFloodCritera: TSpinEdit
    Left = 189
    Top = 540
    Width = 108
    Height = 22
    MaxValue = 60
    MinValue = 1
    TabOrder = 4
    Value = 15
    Visible = False
    OnChange = SpinEditFloodCriteraChange
  end
  object btnViewTS: TButton
    Left = 345
    Top = 534
    Width = 136
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'View Timeseries Graph'
    TabOrder = 5
    OnClick = btnViewTSClick
  end
  object btnCapComp: TButton
    Left = 504
    Top = 534
    Width = 136
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'View Other Graphs'
    TabOrder = 6
    OnClick = btnCapCompClick
  end
end
