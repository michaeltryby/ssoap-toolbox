object frmScatterGraphSelector: TfrmScatterGraphSelector
  Left = 0
  Top = 0
  Caption = 'Scatter Graph Options'
  ClientHeight = 248
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 7
    Width = 83
    Height = 13
    Caption = 'Flow Meter Name'
  end
  object DateTimeRangeGroupBox: TGroupBox
    Left = 8
    Top = 51
    Width = 337
    Height = 158
    Caption = 'Date/Time Range'
    TabOrder = 0
    object entireRangeRadioButton: TRadioButton
      Left = 8
      Top = 18
      Width = 92
      Height = 14
      Caption = 'Entire Range'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = entireRangeRadioButtonClick
    end
    object specifyRangeRadioButton: TRadioButton
      Left = 8
      Top = 38
      Width = 92
      Height = 13
      Caption = 'Specify Range'
      TabOrder = 1
      OnClick = specifyRangeRadioButtonClick
    end
    object StartDateTimeCheckBox: TCheckBox
      Left = 30
      Top = 60
      Width = 98
      Height = 14
      Caption = 'Start Date/Time'
      Enabled = False
      TabOrder = 2
      OnClick = StartDateTimeCheckBoxClick
    end
    object EndDateTimeCheckBox: TCheckBox
      Left = 32
      Top = 92
      Width = 98
      Height = 14
      Caption = 'End Date/Time'
      Enabled = False
      TabOrder = 5
      OnClick = EndDateTimeCheckBoxClick
    end
    object StartDatePicker: TDateTimePicker
      Left = 136
      Top = 56
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
      Top = 88
      Width = 97
      Height = 21
      Date = 36892.000000000000000000
      Time = 36892.000000000000000000
      DateMode = dmUpDown
      Enabled = False
      TabOrder = 6
    end
    object StartTimePicker: TDateTimePicker
      Left = 238
      Top = 56
      Width = 91
      Height = 21
      Date = 2.000000000000000000
      Time = 2.000000000000000000
      DateMode = dmUpDown
      Enabled = False
      Kind = dtkTime
      TabOrder = 4
    end
    object EndTimePicker: TDateTimePicker
      Left = 238
      Top = 88
      Width = 91
      Height = 21
      Date = 2.000000000000000000
      Time = 2.000000000000000000
      DateMode = dmUpDown
      Enabled = False
      Kind = dtkTime
      TabOrder = 7
    end
    object weeklyDisplayRadioButton: TRadioButton
      Left = 8
      Top = 112
      Width = 105
      Height = 17
      Caption = 'Weekly'
      TabOrder = 8
      Visible = False
      OnClick = weeklyDisplayRadioButtonClick
    end
    object dailyDisplayRadioButton: TRadioButton
      Left = 8
      Top = 135
      Width = 105
      Height = 17
      Caption = 'Daily'
      TabOrder = 9
      Visible = False
      OnClick = dailyDisplayRadioButtonClick
    end
  end
  object FlowMeterNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 234
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object okButton: TButton
    Left = 79
    Top = 215
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = okButtonClick
  end
  object cancelButton: TButton
    Left = 197
    Top = 215
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cancelButtonClick
  end
  object RadioGroupType: TRadioGroup
    Left = 247
    Top = 7
    Width = 98
    Height = 42
    Caption = 'Type'
    ItemIndex = 0
    Items.Strings = (
      'Depth-Flow'
      'Depth-Velocity')
    TabOrder = 4
  end
end
