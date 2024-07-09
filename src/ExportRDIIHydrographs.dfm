object frmExportRDIIHydrographs: TfrmExportRDIIHydrographs
  Left = 0
  Top = 0
  Caption = 'Export RDII Hydrographs'
  ClientHeight = 454
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblScenarioName: TLabel
    Left = 12
    Top = 2
    Width = 71
    Height = 13
    Caption = 'Scenario Name'
  end
  object rgExportOptions: TRadioGroup
    Left = 8
    Top = 19
    Width = 321
    Height = 73
    Caption = 'Export RDII Hydrographs to:'
    ItemIndex = 0
    Items.Strings = (
      'SWMM 5 Interface File'
      'RDII Hydrograph Sections of a SWMM 5 Input File'
      'CSV')
    TabOrder = 0
    OnClick = rgExportOptionsClick
  end
  object rgRainGauge: TRadioGroup
    Left = 9
    Top = 98
    Width = 321
    Height = 57
    Caption = 'Rain Gage Options:'
    ItemIndex = 0
    Items.Strings = (
      'Use Selected Raingage'
      'Use Assigned Raingage for each RDII Area / Sewershed')
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 9
    Top = 161
    Width = 321
    Height = 67
    Caption = 'Dates:'
    TabOrder = 2
    object Label13: TLabel
      Left = 20
      Top = 19
      Width = 86
      Height = 13
      Caption = 'Start Date / Time:'
    end
    object Label19: TLabel
      Left = 20
      Top = 43
      Width = 80
      Height = 13
      Caption = 'End Date / Time:'
    end
    object EndDatePicker: TDateTimePicker
      Left = 108
      Top = 38
      Width = 97
      Height = 21
      Date = 36892.000000000000000000
      Time = 36892.000000000000000000
      DateMode = dmUpDown
      TabOrder = 0
      OnChange = EndDatePickerChange
    end
    object StartDatePicker: TDateTimePicker
      Left = 107
      Top = 14
      Width = 97
      Height = 21
      Date = 36892.000000000000000000
      Time = 36892.000000000000000000
      DateMode = dmUpDown
      TabOrder = 1
      OnChange = StartDatePickerChange
    end
    object StartTimePicker: TDateTimePicker
      Left = 206
      Top = 14
      Width = 91
      Height = 21
      Date = 2.000000000000000000
      Time = 2.000000000000000000
      DateMode = dmUpDown
      Kind = dtkTime
      TabOrder = 2
      OnChange = StartDatePickerChange
    end
    object EndTimePicker: TDateTimePicker
      Left = 207
      Top = 38
      Width = 91
      Height = 21
      Date = 2.000000000000000000
      Time = 2.000000000000000000
      DateMode = dmUpDown
      Kind = dtkTime
      TabOrder = 3
      OnChange = EndDatePickerChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 9
    Top = 235
    Width = 321
    Height = 180
    Caption = 'Files:'
    TabOrder = 3
    object lblOutFileName: TLabel
      Left = 8
      Top = 16
      Width = 166
      Height = 13
      Caption = 'Output Interface or CSV Filename:'
      Enabled = False
    end
    object lblInSWMM5: TLabel
      Left = 8
      Top = 59
      Width = 134
      Height = 13
      Caption = 'SWMM 5 Input File to Read:'
    end
    object lblOutSWMM5: TLabel
      Left = 8
      Top = 110
      Width = 135
      Height = 13
      Caption = 'SWMM 5 Input File to Write:'
    end
    object edOutFileName: TEdit
      Left = 8
      Top = 32
      Width = 281
      Height = 21
      Enabled = False
      TabOrder = 0
    end
    object btnOutFileName: TButton
      Left = 291
      Top = 32
      Width = 22
      Height = 21
      Hint = 'Browse for Output File'
      Caption = '. . .'
      Enabled = False
      TabOrder = 1
      OnClick = btnOutFileNameClick
    end
    object edInSWMM5: TEdit
      Left = 8
      Top = 75
      Width = 281
      Height = 21
      TabOrder = 2
      OnChange = edInSWMM5Change
    end
    object btnInSWMM5: TButton
      Left = 291
      Top = 75
      Width = 22
      Height = 21
      Hint = 'Browse for Input File'
      Caption = '. . .'
      TabOrder = 3
      OnClick = btnInSWMM5Click
    end
    object edOutSWMM5: TEdit
      Left = 8
      Top = 126
      Width = 281
      Height = 21
      TabOrder = 4
      OnChange = edOutSWMM5Change
    end
    object btnOutSWMM5: TButton
      Left = 291
      Top = 126
      Width = 22
      Height = 21
      Hint = 'Browse'
      Caption = '. . .'
      TabOrder = 5
      OnClick = btnOutSWMM5Click
    end
  end
  object okButton: TButton
    Left = 34
    Top = 421
    Width = 75
    Height = 25
    Caption = 'Export'
    Default = True
    TabOrder = 4
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 134
    Top = 421
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 5
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 234
    Top = 421
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 6
    OnClick = cancelButtonClick
  end
  inline FrameRDIIGraph1: TFrameRDIIGraph
    Left = 367
    Top = 19
    Width = 355
    Height = 276
    TabOrder = 7
    TabStop = True
    ExplicitLeft = 367
    ExplicitTop = 19
    ExplicitWidth = 355
    ExplicitHeight = 276
  end
  object btnSWMM5_in: TButton
    Left = 223
    Top = 330
    Width = 75
    Height = 25
    Caption = 'SWMM 5'
    Enabled = False
    TabOrder = 8
    OnClick = btnSWMM5_inClick
  end
  object btnSWMM5_out: TButton
    Left = 223
    Top = 382
    Width = 75
    Height = 25
    Caption = 'SWMM 5'
    Enabled = False
    TabOrder = 9
    OnClick = btnSWMM5_inClick
  end
  object OpenDialogSWMM5InpFile: TOpenDialog
    DefaultExt = 'inp'
    Filter = 'SWMM 5 Input Files (*.inp)|*.inp|All Files (*.*)|*.*'
    Left = 232
    Top = 65528
  end
  object SaveDialog1: TSaveDialog
    Filter = '*.CSV|*.CSV'
    Left = 264
    Top = 65528
  end
end
