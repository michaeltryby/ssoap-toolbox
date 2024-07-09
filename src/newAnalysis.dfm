object frmAddNewAnalysis: TfrmAddNewAnalysis
  Left = 287
  Top = 176
  BorderStyle = bsDialog
  Caption = 'New Analysis'
  ClientHeight = 467
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label12: TLabel
    Left = 8
    Top = 356
    Width = 120
    Height = 13
    Caption = 'Running Average (Hours)'
    Visible = False
  end
  object Label1: TLabel
    Left = 7
    Top = 7
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object Label2: TLabel
    Left = 7
    Top = 49
    Width = 83
    Height = 13
    Caption = 'Flow Meter Name'
  end
  object Label3: TLabel
    Left = 7
    Top = 91
    Width = 83
    Height = 13
    Caption = 'Raingauge Name'
  end
  object baseFlowRateLabel: TLabel
    Left = 7
    Top = 133
    Width = 75
    Height = 13
    Caption = 'Base Flow Rate'
  end
  object Label21: TLabel
    Left = 32
    Top = 444
    Width = 139
    Height = 13
    Caption = 'the user-defined RDII events.'
  end
  object Label20: TLabel
    Left = 25
    Top = 429
    Width = 233
    Height = 13
    Caption = '* The default RTK and IA terms will apply outside '
  end
  object GroupBox2: TGroupBox
    Left = 287
    Top = 179
    Width = 265
    Height = 192
    Caption = 'Initial Abstraction Defaults'
    TabOrder = 19
    object Label25: TLabel
      Left = 83
      Top = 19
      Width = 27
      Height = 13
      Caption = 'Dmax'
    end
    object Label26: TLabel
      Left = 148
      Top = 19
      Width = 23
      Height = 13
      Caption = 'Drec'
    end
    object Label27: TLabel
      Left = 217
      Top = 19
      Width = 14
      Height = 13
      Caption = 'Do'
    end
    object InitialValueLabel: TLabel
      Left = 29
      Top = 161
      Width = 146
      Height = 13
      Caption = 'Do = Initial Abstraction (inches)'
    end
    object RateOfReductionLabel: TLabel
      Left = 29
      Top = 146
      Width = 187
      Height = 13
      Caption = 'Drec = Rate of Recovery (inches / day)'
    end
    object MaximumDepressionStorageLabel: TLabel
      Left = 29
      Top = 130
      Width = 179
      Height = 13
      Caption = 'Dmax = Maximum Abstraction (inches)'
    end
    object Label31: TLabel
      Left = 17
      Top = 94
      Width = 24
      Height = 13
      Caption = 'Long'
    end
    object Label32: TLabel
      Left = 16
      Top = 67
      Width = 37
      Height = 13
      Caption = 'Medium'
    end
    object Label33: TLabel
      Left = 16
      Top = 40
      Width = 25
      Height = 13
      Caption = 'Short'
    end
    object Label34: TLabel
      Left = 8
      Top = 19
      Width = 28
      Height = 13
      Caption = 'Curve'
    end
  end
  object AverageIntervalEdit: TEdit
    Left = 8
    Top = 375
    Width = 41
    Height = 21
    Enabled = False
    TabOrder = 15
    Text = '2'
    Visible = False
    OnChange = REditChange
    OnKeyPress = FloatEdtKeyPress
  end
  object FlowMeterNameComboBox: TComboBox
    Left = 8
    Top = 68
    Width = 265
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    OnChange = FlowMeterNameComboBoxChange
  end
  object AnalysisNameEdit: TEdit
    Left = 7
    Top = 24
    Width = 265
    Height = 21
    TabOrder = 0
  end
  object RainGaugeNameComboBox: TComboBox
    Left = 7
    Top = 108
    Width = 265
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 2
    OnChange = RainGaugeNameComboBoxChange
  end
  object okButton: TButton
    Left = 16
    Top = 378
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 16
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 106
    Top = 378
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 17
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 193
    Top = 378
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 18
    OnClick = cancelButtonClick
  end
  object RTKGroupBox: TGroupBox
    Left = 287
    Top = 8
    Width = 265
    Height = 165
    Caption = 'Default RTK Values'
    TabOrder = 5
    object Label4: TLabel
      Left = 92
      Top = 20
      Width = 8
      Height = 13
      Caption = 'R'
    end
    object Label5: TLabel
      Left = 157
      Top = 20
      Width = 7
      Height = 13
      Caption = 'T'
    end
    object Label6: TLabel
      Left = 218
      Top = 20
      Width = 7
      Height = 13
      Caption = 'K'
    end
    object Label7: TLabel
      Left = 8
      Top = 20
      Width = 28
      Height = 13
      Caption = 'Curve'
    end
    object Label8: TLabel
      Left = 16
      Top = 44
      Width = 25
      Height = 13
      Caption = 'Short'
    end
    object Label9: TLabel
      Left = 16
      Top = 68
      Width = 37
      Height = 13
      Caption = 'Medium'
    end
    object Label10: TLabel
      Left = 16
      Top = 92
      Width = 24
      Height = 13
      Caption = 'Long'
    end
    object Label11: TLabel
      Left = 16
      Top = 125
      Width = 24
      Height = 13
      Caption = 'Total'
    end
    object R1Edit: TEdit
      Left = 71
      Top = 39
      Width = 50
      Height = 21
      TabOrder = 0
      Text = '0.0'
      OnChange = REditChange
      OnKeyPress = FloatEdtKeyPress
    end
    object R2Edit: TEdit
      Left = 72
      Top = 62
      Width = 49
      Height = 21
      TabOrder = 3
      Text = '0.0'
      OnChange = REditChange
      OnKeyPress = FloatEdtKeyPress
    end
    object R3Edit: TEdit
      Left = 72
      Top = 86
      Width = 49
      Height = 21
      TabOrder = 6
      Text = '0.0'
      OnChange = REditChange
      OnKeyPress = FloatEdtKeyPress
    end
    object T1Edit: TEdit
      Left = 136
      Top = 39
      Width = 49
      Height = 21
      TabOrder = 1
      Text = '0.0'
      OnKeyPress = FloatEdtKeyPress
    end
    object T2Edit: TEdit
      Left = 136
      Top = 63
      Width = 49
      Height = 21
      TabOrder = 4
      Text = '0.0'
      OnKeyPress = FloatEdtKeyPress
    end
    object T3Edit: TEdit
      Left = 136
      Top = 87
      Width = 49
      Height = 21
      TabOrder = 7
      Text = '0.0'
      OnKeyPress = FloatEdtKeyPress
    end
    object K1Edit: TEdit
      Left = 200
      Top = 40
      Width = 49
      Height = 21
      TabOrder = 2
      Text = '0.0'
      OnKeyPress = FloatEdtKeyPress
    end
    object K2Edit: TEdit
      Left = 200
      Top = 64
      Width = 49
      Height = 21
      TabOrder = 5
      Text = '0.0'
      OnKeyPress = FloatEdtKeyPress
    end
    object K3Edit: TEdit
      Left = 200
      Top = 88
      Width = 49
      Height = 21
      TabOrder = 8
      Text = '0.0'
      OnKeyPress = FloatEdtKeyPress
    end
    object TotalEdit: TEdit
      Left = 72
      Top = 122
      Width = 49
      Height = 21
      ReadOnly = True
      TabOrder = 9
      Text = '0.0'
    end
  end
  object BaseFlowRateEdit: TEdit
    Left = 7
    Top = 150
    Width = 265
    Height = 21
    TabOrder = 3
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object MaxDepressionStorageEdit: TEdit
    Left = 358
    Top = 216
    Width = 50
    Height = 21
    TabOrder = 6
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object RateOfReductionEdit: TEdit
    Left = 423
    Top = 216
    Width = 50
    Height = 21
    TabOrder = 7
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object InitialValueEdit: TEdit
    Left = 487
    Top = 216
    Width = 50
    Height = 21
    TabOrder = 8
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 179
    Width = 265
    Height = 193
    Caption = 'Daily DWF Adjustments'
    TabOrder = 4
    object Label13: TLabel
      Left = 7
      Top = 20
      Width = 38
      Height = 13
      Caption = 'Monday'
    end
    object Label14: TLabel
      Left = 7
      Top = 44
      Width = 41
      Height = 13
      Caption = 'Tuesday'
    end
    object Label15: TLabel
      Left = 7
      Top = 68
      Width = 57
      Height = 13
      Caption = 'Wednesday'
    end
    object Label16: TLabel
      Left = 7
      Top = 92
      Width = 44
      Height = 13
      Caption = 'Thursday'
    end
    object Label17: TLabel
      Left = 7
      Top = 116
      Width = 28
      Height = 13
      Caption = 'Friday'
    end
    object Label18: TLabel
      Left = 7
      Top = 140
      Width = 42
      Height = 13
      Caption = 'Saturday'
    end
    object Label19: TLabel
      Left = 7
      Top = 164
      Width = 76
      Height = 13
      Caption = 'Sunday/Holiday'
    end
    object MondayAdjEdit: TEdit
      Left = 104
      Top = 16
      Width = 150
      Height = 21
      TabOrder = 0
      Text = '0.0'
      OnChange = REditChange
      OnKeyPress = FloatEdtKeyPressAllowNegative
    end
    object TuesdayAdjEdit: TEdit
      Left = 104
      Top = 40
      Width = 150
      Height = 21
      TabOrder = 1
      Text = '0.0'
      OnChange = REditChange
      OnKeyPress = FloatEdtKeyPressAllowNegative
    end
    object WednesdayAdjEdit: TEdit
      Left = 104
      Top = 64
      Width = 150
      Height = 21
      TabOrder = 2
      Text = '0.0'
      OnChange = REditChange
      OnKeyPress = FloatEdtKeyPressAllowNegative
    end
    object ThursdayAdjEdit: TEdit
      Left = 104
      Top = 88
      Width = 150
      Height = 21
      TabOrder = 3
      Text = '0.0'
      OnChange = REditChange
      OnKeyPress = FloatEdtKeyPressAllowNegative
    end
    object FridayAdjEdit: TEdit
      Left = 104
      Top = 112
      Width = 150
      Height = 21
      TabOrder = 4
      Text = '0.0'
      OnChange = REditChange
      OnKeyPress = FloatEdtKeyPressAllowNegative
    end
    object SaturdayAdjEdit: TEdit
      Left = 104
      Top = 136
      Width = 150
      Height = 21
      TabOrder = 5
      Text = '0.0'
      OnChange = REditChange
      OnKeyPress = FloatEdtKeyPressAllowNegative
    end
    object SundayAdjEdit: TEdit
      Left = 104
      Top = 160
      Width = 150
      Height = 21
      TabOrder = 6
      Text = '0.0'
      OnChange = REditChange
      OnKeyPress = FloatEdtKeyPressAllowNegative
    end
  end
  object MaxDepressionStorageEdit2: TEdit
    Left = 358
    Top = 243
    Width = 48
    Height = 21
    TabOrder = 9
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object RateOfReductionEdit2: TEdit
    Left = 423
    Top = 243
    Width = 50
    Height = 21
    TabOrder = 10
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object InitialValueEdit2: TEdit
    Left = 487
    Top = 243
    Width = 50
    Height = 21
    TabOrder = 11
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object MaxDepressionStorageEdit3: TEdit
    Left = 358
    Top = 270
    Width = 50
    Height = 21
    TabOrder = 12
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object RateOfReductionEdit3: TEdit
    Left = 423
    Top = 270
    Width = 50
    Height = 21
    TabOrder = 13
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object InitialValueEdit3: TEdit
    Left = 487
    Top = 270
    Width = 50
    Height = 21
    TabOrder = 14
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object CheckBoxAdvanced: TCheckBox
    Left = 8
    Top = 409
    Width = 529
    Height = 17
    Caption = 'Default RTK and IA terms (for advanced users)'
    TabOrder = 20
    OnClick = CheckBoxAdvancedClick
  end
end
