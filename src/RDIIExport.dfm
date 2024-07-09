object frmRDIIExport: TfrmRDIIExport
  Left = 0
  Top = 0
  Caption = 'RDII Hydrograph Generation'
  ClientHeight = 532
  ClientWidth = 755
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 8
    Top = 125
    Width = 58
    Height = 13
    Caption = 'Sewersheds'
  end
  object Label5: TLabel
    Left = 8
    Top = 213
    Width = 53
    Height = 13
    Caption = 'RDII Areas'
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 71
    Height = 13
    Caption = 'Scenario Name'
  end
  object Label3: TLabel
    Left = 8
    Top = 52
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object Label11: TLabel
    Left = 8
    Top = 304
    Width = 60
    Height = 13
    Caption = 'Rain Gauges'
  end
  object Label4: TLabel
    Left = 8
    Top = 350
    Width = 33
    Height = 13
    Caption = 'Events'
  end
  object Label13: TLabel
    Left = 8
    Top = 417
    Width = 86
    Height = 13
    Caption = 'Start Date / Time:'
  end
  object Label19: TLabel
    Left = 8
    Top = 443
    Width = 80
    Height = 13
    Caption = 'End Date / Time:'
  end
  object ListBoxRDIIAreas: TListBox
    Left = 8
    Top = 232
    Width = 281
    Height = 63
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBoxRDIIAreasClick
  end
  inline FrameRDIIGraph1: TFrameRDIIGraph
    Left = 304
    Top = 8
    Width = 372
    Height = 511
    TabOrder = 1
    TabStop = True
    ExplicitLeft = 304
    ExplicitTop = 8
    ExplicitWidth = 372
    ExplicitHeight = 511
  end
  object btnExport2RDIISections: TButton
    Left = 345
    Top = 408
    Width = 119
    Height = 27
    Caption = 'Export to RDII Sections'
    TabOrder = 2
    Visible = False
    OnClick = btnExport2RDIISectionsClick
  end
  object ListBoxSewerSheds: TListBox
    Left = 8
    Top = 144
    Width = 281
    Height = 63
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 3
    OnClick = ListBoxSewerShedsClick
  end
  object ScenarioNameComboBox: TComboBox
    Left = 8
    Top = 25
    Width = 281
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    Sorted = True
    TabOrder = 4
    OnChange = ScenarioNameComboBoxChange
  end
  object ScenarioDescription: TMemo
    Left = 8
    Top = 71
    Width = 281
    Height = 48
    Lines.Strings = (
      'ScenarioDescription')
    ReadOnly = True
    TabOrder = 5
  end
  object ComboBoxRainGauges: TComboBox
    Left = 8
    Top = 323
    Width = 281
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 6
    OnChange = ComboBoxRainGaugesChange
  end
  object ComboBoxEvents: TComboBox
    Left = 8
    Top = 369
    Width = 281
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 7
    OnChange = ComboBoxEventsChange
  end
  object EndDatePicker: TDateTimePicker
    Left = 96
    Top = 439
    Width = 97
    Height = 21
    Date = 36892.000000000000000000
    Time = 36892.000000000000000000
    DateMode = dmUpDown
    TabOrder = 8
  end
  object StartDatePicker: TDateTimePicker
    Left = 95
    Top = 412
    Width = 97
    Height = 21
    Date = 36892.000000000000000000
    Time = 36892.000000000000000000
    DateMode = dmUpDown
    TabOrder = 9
  end
  object StartTimePicker: TDateTimePicker
    Left = 198
    Top = 412
    Width = 91
    Height = 21
    Date = 2.000000000000000000
    Time = 2.000000000000000000
    DateMode = dmUpDown
    Kind = dtkTime
    TabOrder = 10
  end
  object EndTimePicker: TDateTimePicker
    Left = 199
    Top = 439
    Width = 91
    Height = 21
    Date = 2.000000000000000000
    Time = 2.000000000000000000
    DateMode = dmUpDown
    Kind = dtkTime
    TabOrder = 11
  end
  object btnUpdate: TButton
    Left = 8
    Top = 466
    Width = 75
    Height = 27
    Caption = 'Update Chart'
    TabOrder = 12
    OnClick = btnUpdateClick
  end
  object btnClose: TButton
    Left = 214
    Top = 499
    Width = 75
    Height = 27
    Caption = 'Close'
    TabOrder = 13
    OnClick = btnCloseClick
  end
  object btnExport2InterfaceFile: TButton
    Left = 345
    Top = 441
    Width = 119
    Height = 27
    Caption = 'Export to Interface File'
    TabOrder = 14
    Visible = False
    OnClick = btnExport2InterfaceFileClick
  end
  object CheckBoxAssignedGauge: TCheckBox
    Left = 80
    Top = 303
    Width = 224
    Height = 17
    Caption = 'Auto Switch to Gauge for Selected Area'
    TabOrder = 15
    OnClick = CheckBoxAssignedGaugeClick
  end
  object btnEditScenario: TButton
    Left = 216
    Top = 0
    Width = 73
    Height = 25
    Caption = 'Edit'
    TabOrder = 16
    OnClick = btnEditScenarioClick
  end
  object btnEditSewerShed: TButton
    Left = 216
    Top = 119
    Width = 73
    Height = 25
    Caption = 'Edit'
    Enabled = False
    TabOrder = 17
    OnClick = btnEditSewerShedClick
  end
  object btnEditRTKs: TButton
    Left = 112
    Top = 466
    Width = 75
    Height = 27
    Caption = 'Edit RTKs'
    TabOrder = 18
    OnClick = btnEditRTKsClick
  end
  object btnEditRDIIArea: TButton
    Left = 216
    Top = 207
    Width = 73
    Height = 25
    Caption = 'Edit'
    Enabled = False
    TabOrder = 19
    OnClick = btnEditRDIIAreaClick
  end
  object btnHelp: TButton
    Left = 112
    Top = 499
    Width = 75
    Height = 27
    Caption = 'Help'
    TabOrder = 20
    OnClick = btnHelpClick
  end
  object chkbxAllSewerSheds: TCheckBox
    Left = 96
    Top = 125
    Width = 97
    Height = 17
    Caption = 'Draw All'
    TabOrder = 21
    Visible = False
    OnClick = chkbxAllSewerShedsClick
  end
  object chkbxAllRDIIArea: TCheckBox
    Left = 96
    Top = 213
    Width = 97
    Height = 17
    Caption = 'Draw All'
    TabOrder = 22
    Visible = False
    OnClick = chkbxAllRDIIAreaClick
  end
  object btnExport: TButton
    Left = 8
    Top = 499
    Width = 75
    Height = 27
    Caption = 'Export'
    TabOrder = 23
    OnClick = btnExportClick
  end
  object btnToggleColors: TButton
    Left = 214
    Top = 466
    Width = 75
    Height = 27
    Caption = 'Toggle Colors'
    TabOrder = 24
    OnClick = btnToggleColorsClick
  end
  object CheckBoxFreezeTime: TCheckBox
    Left = 8
    Top = 396
    Width = 81
    Height = 17
    Caption = 'Freeze Times'
    TabOrder = 25
    OnClick = CheckBoxFreezeTimeClick
  end
  object SaveDialog1: TSaveDialog
    Filter = '*.CSV|*.CSV'
    Left = 112
    Top = 65528
  end
  object OpenDialogSWMM5InpFile: TOpenDialog
    DefaultExt = '*.inp'
    Filter = 'SWMM 5 Input Files (*.inp)|*.inp|All Files (*.*)|*.*'
    Left = 80
    Top = 65528
  end
end
