object frmExportPRNTRAINTabular: TfrmExportPRNTRAINTabular
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Export Rainfall to a PRNTRAIN Output File'
  ClientHeight = 493
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
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
    Width = 24
    Height = 13
    Caption = 'Units'
  end
  object Label3: TLabel
    Left = 7
    Top = 7
    Width = 83
    Height = 13
    Caption = 'Raingauge Name'
  end
  object GroupBox2: TGroupBox
    Left = 7
    Top = 388
    Width = 337
    Height = 65
    Caption = 'Time Output Options'
    TabOrder = 6
    object separateHoursMinutesRadioButton: TRadioButton
      Left = 8
      Top = 16
      Width = 161
      Height = 17
      Caption = 'Separate Hours/Minutes'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object separateHoursRadioButton: TRadioButton
      Left = 8
      Top = 40
      Width = 113
      Height = 17
      Caption = 'Decimal Hours'
      TabOrder = 1
    end
  end
  object FilenameEdit: TEdit
    Left = 7
    Top = 66
    Width = 337
    Height = 21
    TabOrder = 1
  end
  object browseButton: TButton
    Left = 268
    Top = 95
    Width = 75
    Height = 25
    Caption = 'Browse...'
    TabOrder = 2
    OnClick = browseButtonClick
  end
  object UnitsComboBox: TComboBox
    Left = 7
    Top = 141
    Width = 337
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
  end
  object DateTimeGroupBox: TGroupBox
    Left = 7
    Top = 166
    Width = 337
    Height = 117
    Caption = 'Date/Time Range'
    TabOrder = 4
    object entireRangeRadioButton: TRadioButton
      Left = 13
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
      Left = 13
      Top = 42
      Width = 92
      Height = 13
      Caption = 'Specify Range'
      TabOrder = 1
      OnClick = specifyRangeRadioButtonClick
    end
    object StartDateTimeCheckBox: TCheckBox
      Left = 38
      Top = 61
      Width = 98
      Height = 14
      Caption = 'Start Date/Time'
      Enabled = False
      TabOrder = 2
      OnClick = StartDateTimeCheckBoxClick
    end
    object EndDateTimeCheckBox: TCheckBox
      Left = 38
      Top = 87
      Width = 98
      Height = 14
      Caption = 'End Date/Time'
      Enabled = False
      TabOrder = 5
      OnClick = EndDateTimeCheckBoxClick
    end
    object StartDatePicker: TDateTimePicker
      Left = 136
      Top = 61
      Width = 97
      Height = 21
      Date = 36892.000000000000000000
      Time = 36892.000000000000000000
      DateMode = dmUpDown
      Enabled = False
      TabOrder = 3
    end
    object EndDatePicker: TDateTimePicker
      Left = 136
      Top = 87
      Width = 97
      Height = 21
      Date = 36892.000000000000000000
      Time = 36892.000000000000000000
      DateMode = dmUpDown
      Enabled = False
      TabOrder = 6
    end
    object EndTimePicker: TDateTimePicker
      Left = 224
      Top = 87
      Width = 91
      Height = 21
      Date = 2.000000000000000000
      Time = 2.000000000000000000
      DateMode = dmUpDown
      Enabled = False
      Kind = dtkTime
      TabOrder = 7
    end
    object StartTimePicker: TDateTimePicker
      Left = 224
      Top = 61
      Width = 91
      Height = 21
      Date = 2.000000000000000000
      Time = 2.000000000000000000
      DateMode = dmUpDown
      Enabled = False
      Kind = dtkTime
      TabOrder = 4
    end
  end
  object okButton: TButton
    Left = 31
    Top = 461
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 7
    OnClick = okButtonClick
  end
  object cancelButton: TButton
    Left = 235
    Top = 461
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 9
    OnClick = cancelButtonClick
  end
  object helpButton: TButton
    Left = 133
    Top = 461
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 8
    Visible = False
    OnClick = helpButtonClick
  end
  object RaingaugeNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 337
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = RaingaugeNameComboBoxChange
    Items.Strings = (
      '')
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 287
    Width = 337
    Height = 97
    Caption = 'Rainfall Output Options'
    TabOrder = 5
    object outputTimeStepLabel: TLabel
      Left = 40
      Top = 67
      Width = 152
      Height = 13
      Caption = 'Output Time Step (1-60 minutes)'
      Enabled = False
    end
    object nonzeroObservationsRadioButton: TRadioButton
      Left = 8
      Top = 16
      Width = 137
      Height = 17
      Caption = 'Non-zero Observations'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = nonzeroObservationsRadioButtonClick
    end
    object allObservationsRadioButton: TRadioButton
      Left = 8
      Top = 40
      Width = 113
      Height = 17
      Caption = 'All Observations'
      TabOrder = 1
      OnClick = allObservationsRadioButtonClick
    end
    object outputTimeStepSpinEdit: TSpinEdit
      Left = 200
      Top = 64
      Width = 121
      Height = 22
      Enabled = False
      MaxValue = 60
      MinValue = 1
      TabOrder = 2
      Value = 5
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'TXT'
    Filter = '*.TXT|*.TXT|All Files (*.*)|*.*'
    Left = 224
    Top = 80
  end
end
