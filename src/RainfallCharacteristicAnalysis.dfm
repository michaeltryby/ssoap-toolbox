object frmRainfallCharacteristicAnalysis: TfrmRainfallCharacteristicAnalysis
  Left = 461
  Top = 274
  HelpContext = 270
  BorderStyle = bsDialog
  Caption = 'Rainfall Characteristic Analysis'
  ClientHeight = 295
  ClientWidth = 355
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
  object Label3: TLabel
    Left = 7
    Top = 7
    Width = 83
    Height = 13
    Caption = 'Raingauge Name'
  end
  object DateTimeGroupBox: TGroupBox
    Left = 7
    Top = 54
    Width = 337
    Height = 117
    Caption = 'Date/Time Range'
    TabOrder = 1
    object entireRangeRadioButton: TRadioButton
      Left = 13
      Top = 22
      Width = 92
      Height = 14
      Caption = 'Entire Range'
      Checked = True
      TabOrder = 0
      TabStop = True
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
    end
    object EndDateTimeCheckBox: TCheckBox
      Left = 38
      Top = 87
      Width = 98
      Height = 14
      Caption = 'End Date/Time'
      Enabled = False
      TabOrder = 5
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
  object cancelButton: TButton
    Left = 267
    Top = 261
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 3
    OnClick = cancelButtonClick
  end
  object helpButton: TButton
    Left = 13
    Top = 261
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 2
    OnClick = helpButtonClick
  end
  object RaingaugeNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 338
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = RaingaugeNameComboBoxChange
    Items.Strings = (
      '')
  end
  object UserOptions: TGroupBox
    Left = 8
    Top = 176
    Width = 337
    Height = 73
    Caption = 'User Options'
    TabOrder = 4
    object Label4: TLabel
      Left = 152
      Top = 16
      Width = 48
      Height = 13
      Caption = 'MIT (hrs) :'
    end
    object Label1: TLabel
      Left = 72
      Top = 48
      Width = 133
      Height = 13
      Caption = 'Dry Period Definition (days) :'
    end
    object mit_hour: TSpinEdit
      Left = 208
      Top = 11
      Width = 121
      Height = 22
      MaxValue = 60
      MinValue = 1
      TabOrder = 0
      Value = 6
    end
    object rainfallTimeStepSpinEdit: TSpinEdit
      Left = 16
      Top = 19
      Width = 33
      Height = 22
      Enabled = False
      MaxValue = 60
      MinValue = 1
      TabOrder = 1
      Value = 6
      Visible = False
    end
    object DryPeriodDefinitionSpinEdit: TSpinEdit
      Left = 208
      Top = 43
      Width = 121
      Height = 22
      MaxValue = 60
      MinValue = 1
      TabOrder = 2
      Value = 6
    end
  end
  object RainfallAnaysis: TButton
    Left = 181
    Top = 261
    Width = 75
    Height = 25
    Caption = 'Begin'
    TabOrder = 5
    OnClick = RainfallAnaysisClick
  end
end
