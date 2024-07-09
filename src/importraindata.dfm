object frmImportRainDataUsingConverter: TfrmImportRainDataUsingConverter
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Import Rain Data Using Converter'
  ClientHeight = 416
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 49
    Width = 47
    Height = 13
    Caption = 'File Name'
  end
  object Label2: TLabel
    Left = 7
    Top = 124
    Width = 46
    Height = 13
    Caption = 'Converter'
  end
  object Label3: TLabel
    Left = 7
    Top = 7
    Width = 83
    Height = 13
    Caption = 'Raingauge Name'
  end
  object FilenameEdit: TEdit
    Left = 7
    Top = 66
    Width = 345
    Height = 21
    TabOrder = 1
  end
  object browseButton: TButton
    Left = 277
    Top = 95
    Width = 75
    Height = 25
    Caption = 'Browse...'
    TabOrder = 2
    OnClick = browseButtonClick
  end
  object ConverterComboBox: TComboBox
    Left = 7
    Top = 141
    Width = 345
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    Items.Strings = (
      'NCDC Rain Format'
      'Brand X (IN/HOUR)'
      'Philadelphia Water Department')
  end
  object DateTimeRangeGroupBox: TGroupBox
    Left = 7
    Top = 166
    Width = 345
    Height = 117
    Caption = 'Date/Time Range'
    TabOrder = 4
    object entireRangeRadioButton: TRadioButton
      Left = 5
      Top = 22
      Width = 92
      Height = 14
      Caption = 'Entire Range'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = entireRangeRadioButtonClick
    end
    object specifyRangeRadioButton: TRadioButton
      Left = 5
      Top = 42
      Width = 92
      Height = 13
      Caption = 'Specify Range'
      TabOrder = 1
      OnClick = specifyRangeRadioButtonClick
    end
    object StartDateTimeCheckBox: TCheckBox
      Left = 30
      Top = 61
      Width = 98
      Height = 14
      Caption = 'Start Date/Time'
      Enabled = False
      TabOrder = 2
      OnClick = StartDateTimeCheckBoxClick
    end
    object EndDateTimeCheckBox: TCheckBox
      Left = 30
      Top = 87
      Width = 98
      Height = 14
      Caption = 'End Date/Time'
      Enabled = False
      TabOrder = 5
      OnClick = EndDateTimeCheckBoxClick
    end
    object EndDatePicker: TDateTimePicker
      Left = 128
      Top = 87
      Width = 97
      Height = 21
      Date = 36892.000000000000000000
      Time = 36892.000000000000000000
      DateMode = dmUpDown
      Enabled = False
      TabOrder = 6
    end
    object StartDatePicker: TDateTimePicker
      Left = 128
      Top = 61
      Width = 97
      Height = 21
      Date = 36892.000000000000000000
      Time = 36892.000000000000000000
      DateMode = dmUpDown
      Enabled = False
      TabOrder = 3
    end
    object StartTimePicker: TDateTimePicker
      Left = 230
      Top = 61
      Width = 91
      Height = 21
      Date = 36542.000000000000000000
      Time = 36542.000000000000000000
      DateMode = dmUpDown
      Enabled = False
      Kind = dtkTime
      TabOrder = 4
    end
    object EndTimePicker: TDateTimePicker
      Left = 230
      Top = 87
      Width = 91
      Height = 21
      Date = 36847.000000000000000000
      Time = 36847.000000000000000000
      DateMode = dmUpDown
      Enabled = False
      Kind = dtkTime
      TabOrder = 7
    end
  end
  object okButton: TButton
    Left = 31
    Top = 384
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 6
    OnClick = okButtonClick
  end
  object cancelButton: TButton
    Left = 251
    Top = 384
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 8
    OnClick = cancelButtonClick
  end
  object helpButton: TButton
    Left = 141
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 7
    OnClick = helpButtonClick
  end
  object GroupBox2: TGroupBox
    Left = 7
    Top = 287
    Width = 345
    Height = 89
    Caption = 'Options'
    TabOrder = 5
    object AverageFlowsRadioButton: TRadioButton
      Left = 8
      Top = 16
      Width = 313
      Height = 17
      Caption = 'Average Values when Duplicate Date/Times are encountered'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object FirstValueRadioButton: TRadioButton
      Left = 8
      Top = 40
      Width = 313
      Height = 17
      Caption = 'Use First Value when Duplicate Date/Times are encountered'
      TabOrder = 1
    end
    object SecondValueRadioButton: TRadioButton
      Left = 8
      Top = 64
      Width = 329
      Height = 17
      Caption = 'Use Second Value when Duplicate Date/Times are encountered'
      TabOrder = 2
    end
  end
  object RainGaugeNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 345
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.CSV; *.TXT;*.RLO|*.CSV;*.TXT;*.RLO|All Files (*.*)|*.*'
    Left = 216
    Top = 80
  end
end
