object frmAutomaticDayRemoval: TfrmAutomaticDayRemoval
  Left = 245
  Top = 149
  BorderStyle = bsDialog
  Caption = 'Automatic DWF Day Determination'
  ClientHeight = 561
  ClientWidth = 592
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
  object Label7: TLabel
    Left = 8
    Top = 8
    Width = 83
    Height = 13
    Caption = 'Flow Meter Name'
  end
  object Label8: TLabel
    Left = 312
    Top = 8
    Width = 121
    Height = 13
    Caption = 'Averaging Interval (hours)'
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 56
    Width = 288
    Height = 466
    TabOrder = 2
    object WeekdaysCheckBox: TCheckBox
      Left = 7
      Top = 0
      Width = 72
      Height = 14
      Caption = 'Weekdays'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = WeekdaysCheckBoxClick
    end
    object GroupBox2: TGroupBox
      Left = 7
      Top = 20
      Width = 272
      Height = 65
      TabOrder = 0
      object WeekdayMinimumPercentageLabel: TLabel
        Left = 7
        Top = 20
        Width = 169
        Height = 13
        Caption = 'Minimum Percentage of Data Points'
      end
      object WeekdayRemoveDaysMissingDataCheckBox: TCheckBox
        Left = 7
        Top = 0
        Width = 156
        Height = 14
        Caption = 'Remove Days Missing Data'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = WeekdayRemoveDaysMissingDataCheckBoxClick
      end
      object WeekdayMinimumPercentageEdit: TEdit
        Left = 7
        Top = 34
        Width = 257
        Height = 21
        TabOrder = 1
        Text = '100'
        OnKeyPress = FloatEdtKeyPress
      end
    end
    object GroupBox3: TGroupBox
      Left = 3
      Top = 359
      Width = 272
      Height = 94
      TabOrder = 2
      object WeekdayStandardDeviationLabel: TLabel
        Left = 7
        Top = 20
        Width = 91
        Height = 13
        Caption = 'Standard Deviation'
      end
      object WeekdayRemoveDaysStatisticallyCheckBox: TCheckBox
        Left = 7
        Top = 0
        Width = 150
        Height = 14
        Caption = 'Remove Days Statistically'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = WeekdayRemoveDaysStatisticallyCheckBoxClick
      end
      object WeekdayOnlyGreaterCheckBox: TCheckBox
        Left = 8
        Top = 64
        Width = 241
        Height = 17
        Caption = 'Only When Greater than the Standard Dev.'
        TabOrder = 2
      end
      object WeekdayStandardDeviationEdit: TEdit
        Left = 6
        Top = 37
        Width = 257
        Height = 21
        TabOrder = 1
        Text = '1.0'
        OnKeyPress = FloatEdtKeyPress
      end
    end
    object weekdayRainfallRemovalGroupBox: TGroupBox
      Left = 3
      Top = 91
      Width = 272
      Height = 262
      TabOrder = 1
      object WeekdaySomeSortLabel: TLabel
        Left = 7
        Top = 20
        Width = 83
        Height = 13
        Caption = 'Raingauge Name'
      end
      object WeekdayCurrentDayMaxRainLabel: TLabel
        Left = 8
        Top = 67
        Width = 104
        Height = 13
        Caption = 'Current Day Max Rain'
      end
      object WeekdayPreviousDayMaxRainLabel: TLabel
        Left = 8
        Top = 91
        Width = 111
        Height = 13
        Caption = 'Previous Day Max Rain'
      end
      object WeekdayTwoDaysPreviousMaxRainLabel: TLabel
        Left = 8
        Top = 115
        Width = 140
        Height = 13
        Caption = 'Two Days Previous Max Rain'
      end
      object WeekdayThreeDaysPreviousMaxRainLabel: TLabel
        Left = 8
        Top = 139
        Width = 147
        Height = 13
        Caption = 'Three Days Previous Max Rain'
      end
      object WeekdayFourDaysPreviousMaxRainLabel: TLabel
        Left = 8
        Top = 163
        Width = 140
        Height = 13
        Caption = 'Four Days Previous Max Rain'
      end
      object WeekdayFiveDaysPreviousMaxRainLabel: TLabel
        Left = 8
        Top = 187
        Width = 139
        Height = 13
        Caption = 'Five Days Previous Max Rain'
      end
      object WeekdaySixDaysPreviousMaxRainLabel: TLabel
        Left = 8
        Top = 211
        Width = 133
        Height = 13
        Caption = 'Six Days Previous Max Rain'
      end
      object WeekdaySevenDaysPreviousMaxRainLabel: TLabel
        Left = 8
        Top = 235
        Width = 150
        Height = 13
        Caption = 'Seven Days Previous Max Rain'
      end
      object WeekdayRemoveDaysBasedOnRainfallCheckBox: TCheckBox
        Left = 7
        Top = 0
        Width = 182
        Height = 14
        Caption = 'Remove Days based on Rainfall'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = WeekdayRemoveDaysBasedOnRainfallCheckBoxClick
      end
      object WeekdayRainGaugeComboBox: TComboBox
        Left = 8
        Top = 34
        Width = 257
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = WeekdayRainGaugeComboBoxChange
      end
      object WeekdayCurrentDayMaxRainEdit: TEdit
        Left = 204
        Top = 61
        Width = 65
        Height = 21
        TabOrder = 2
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
      object WeekdayPreviousDayMaxRainEdit: TEdit
        Left = 204
        Top = 85
        Width = 65
        Height = 21
        TabOrder = 3
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
      object WeekdayTwoDaysPreviousMaxRainEdit: TEdit
        Left = 204
        Top = 112
        Width = 65
        Height = 21
        TabOrder = 4
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
      object WeekdayThreeDaysPreviousMaxRainEdit: TEdit
        Left = 204
        Top = 136
        Width = 65
        Height = 21
        TabOrder = 5
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
      object WeekdayFourDaysPreviousMaxRainEdit: TEdit
        Left = 204
        Top = 160
        Width = 65
        Height = 21
        TabOrder = 6
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
      object WeekdayFiveDaysPreviousMaxRainEdit: TEdit
        Left = 204
        Top = 184
        Width = 65
        Height = 21
        TabOrder = 7
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
      object WeekdaySixDaysPreviousMaxRainEdit: TEdit
        Left = 204
        Top = 208
        Width = 65
        Height = 21
        TabOrder = 8
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
      object WeekdaySevenDaysPreviousMaxRainEdit: TEdit
        Left = 204
        Top = 232
        Width = 65
        Height = 21
        TabOrder = 9
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
    end
  end
  object GroupBox5: TGroupBox
    Left = 298
    Top = 56
    Width = 288
    Height = 466
    TabOrder = 3
    object WeekendCheckBox: TCheckBox
      Left = 7
      Top = 0
      Width = 98
      Height = 14
      Caption = 'Weekend Days'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = WeekendCheckBoxClick
    end
    object GroupBox6: TGroupBox
      Left = 7
      Top = 20
      Width = 272
      Height = 65
      TabOrder = 0
      object WeekendMinimumPercentageLabel: TLabel
        Left = 7
        Top = 20
        Width = 169
        Height = 13
        Caption = 'Minimum Percentage of Data Points'
      end
      object WeekendRemoveDaysMissingDataCheckBox: TCheckBox
        Left = 7
        Top = 0
        Width = 156
        Height = 14
        Caption = 'Remove Days Missing Data'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = WeekendRemoveDaysMissingDataCheckBoxClick
      end
      object WeekendMinimumPercentageEdit: TEdit
        Left = 7
        Top = 34
        Width = 257
        Height = 21
        TabOrder = 1
        Text = '100'
        OnKeyPress = FloatEdtKeyPress
      end
    end
    object GroupBox7: TGroupBox
      Left = 3
      Top = 359
      Width = 272
      Height = 94
      TabOrder = 2
      object WeekendStandardDeviationLabel: TLabel
        Left = 7
        Top = 20
        Width = 91
        Height = 13
        Caption = 'Standard Deviation'
      end
      object WeekendRemoveDaysStatisticallyCheckBox: TCheckBox
        Left = 7
        Top = 0
        Width = 150
        Height = 14
        Caption = 'Remove Days Statistically'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = WeekendRemoveDaysStatisticallyCheckBoxClick
      end
      object WeekendOnlyGreaterCheckBox: TCheckBox
        Left = 8
        Top = 64
        Width = 241
        Height = 17
        Caption = 'Only When Greater than the Standard Dev.'
        TabOrder = 2
      end
      object WeekendStandardDeviationEdit: TEdit
        Left = 8
        Top = 35
        Width = 257
        Height = 21
        TabOrder = 1
        Text = '1.0'
        OnKeyPress = FloatEdtKeyPress
      end
    end
    object GroupBox8: TGroupBox
      Left = 3
      Top = 91
      Width = 272
      Height = 262
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
      object WeekendSomeSortLabel: TLabel
        Left = 7
        Top = 20
        Width = 83
        Height = 13
        Caption = 'Raingauge Name'
      end
      object WeekendCurrentDayMaxRainLabel: TLabel
        Left = 8
        Top = 67
        Width = 104
        Height = 13
        Caption = 'Current Day Max Rain'
      end
      object WeekendPreviousDayMaxRainLabel: TLabel
        Left = 8
        Top = 91
        Width = 111
        Height = 13
        Caption = 'Previous Day Max Rain'
      end
      object WeekendTwoDaysPreviousMaxRainLabel: TLabel
        Left = 8
        Top = 115
        Width = 140
        Height = 13
        Caption = 'Two Days Previous Max Rain'
      end
      object WeekendThreeDaysPreviousMaxRainLabel: TLabel
        Left = 8
        Top = 139
        Width = 147
        Height = 13
        Caption = 'Three Days Previous Max Rain'
      end
      object WeekendFourDaysPreviousMaxRainLabel: TLabel
        Left = 11
        Top = 166
        Width = 140
        Height = 13
        Caption = 'Four Days Previous Max Rain'
      end
      object WeekendFiveDaysPreviousMaxRainLabel: TLabel
        Left = 11
        Top = 190
        Width = 139
        Height = 13
        Caption = 'Five Days Previous Max Rain'
      end
      object WeekendSixDaysPreviousMaxRainLabel: TLabel
        Left = 11
        Top = 214
        Width = 133
        Height = 13
        Caption = 'Six Days Previous Max Rain'
      end
      object WeekendSevenDaysPreviousMaxRainLabel: TLabel
        Left = 11
        Top = 238
        Width = 150
        Height = 13
        Caption = 'Seven Days Previous Max Rain'
      end
      object WeekendRemoveDaysBasedOnRainfallCheckBox: TCheckBox
        Left = 7
        Top = 0
        Width = 182
        Height = 14
        Caption = 'Remove Days based on Rainfall'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = WeekendRemoveDaysBasedOnRainfallCheckBoxClick
      end
      object WeekendRainGaugeComboBox: TComboBox
        Left = 8
        Top = 34
        Width = 257
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = WeekendRainGaugeComboBoxChange
      end
      object WeekendCurrentDayMaxRainEdit: TEdit
        Left = 198
        Top = 64
        Width = 65
        Height = 21
        TabOrder = 2
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
      object WeekendPreviousDayMaxRainEdit: TEdit
        Left = 198
        Top = 88
        Width = 65
        Height = 21
        TabOrder = 3
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
      object WeekendTwoDaysPreviousMaxRainEdit: TEdit
        Left = 198
        Top = 115
        Width = 65
        Height = 21
        TabOrder = 4
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
      object WeekendFourDaysPreviousMaxRainEdit: TEdit
        Left = 198
        Top = 157
        Width = 65
        Height = 21
        TabOrder = 5
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
      object WeekendThreeDaysPreviousMaxRainEdit: TEdit
        Left = 198
        Top = 136
        Width = 65
        Height = 21
        TabOrder = 6
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
      object WeekendFiveDaysPreviousMaxRainEdit: TEdit
        Left = 198
        Top = 184
        Width = 65
        Height = 21
        TabOrder = 7
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
      object WeekendSixDaysPreviousMaxRainEdit: TEdit
        Left = 198
        Top = 208
        Width = 65
        Height = 21
        TabOrder = 8
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
      object WeekendSevenDaysPreviousMaxRainEdit: TEdit
        Left = 198
        Top = 232
        Width = 65
        Height = 21
        TabOrder = 9
        Text = '0.0'
        OnKeyPress = FloatEdtKeyPress
      end
    end
  end
  object okButton: TButton
    Left = 144
    Top = 528
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 4
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 256
    Top = 528
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 5
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 368
    Top = 528
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 6
    OnClick = cancelButtonClick
  end
  object FlowMeterNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 282
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object AverageIntervalEdit: TEdit
    Left = 308
    Top = 24
    Width = 277
    Height = 21
    TabOrder = 1
    Text = '2'
    OnKeyPress = FloatEdtKeyPress
  end
end
