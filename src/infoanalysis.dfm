object frmInfoAnalysis: TfrmInfoAnalysis
  Left = 234
  Top = 143
  BorderStyle = bsDialog
  Caption = 'Information on RDII Analysis'
  ClientHeight = 219
  ClientWidth = 283
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
  object Label12: TLabel
    Left = 8
    Top = 135
    Width = 131
    Height = 13
    Caption = 'Number of Analyzed Events'
  end
  object GroupBox3: TGroupBox
    Left = 288
    Top = 179
    Width = 265
    Height = 188
    Caption = 'Initial Abstraction Defaults'
    TabOrder = 14
    object Label34: TLabel
      Left = 8
      Top = 19
      Width = 28
      Height = 13
      Caption = 'Curve'
    end
    object Label33: TLabel
      Left = 16
      Top = 40
      Width = 25
      Height = 13
      Caption = 'Short'
    end
    object Label32: TLabel
      Left = 16
      Top = 67
      Width = 37
      Height = 13
      Caption = 'Medium'
    end
    object Label31: TLabel
      Left = 17
      Top = 94
      Width = 24
      Height = 13
      Caption = 'Long'
    end
    object MaximumDepressionStorageLabel: TLabel
      Left = 29
      Top = 130
      Width = 179
      Height = 13
      Caption = 'Dmax = Maximum Abstraction (inches)'
    end
    object RateOfReductionLabel: TLabel
      Left = 29
      Top = 146
      Width = 187
      Height = 13
      Caption = 'Drec = Rate of Recovery (inches / day)'
    end
    object InitialValueLabel: TLabel
      Left = 29
      Top = 161
      Width = 146
      Height = 13
      Caption = 'Do = Initial Abstraction (inches)'
    end
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
  end
  object FlowMeterNameComboBox: TComboBox
    Left = 7
    Top = 66
    Width = 265
    Height = 21
    Style = csDropDownList
    Enabled = False
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
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
    Enabled = False
    ItemHeight = 13
    Sorted = True
    TabOrder = 2
  end
  object okButton: TButton
    Left = 8
    Top = 186
    Width = 264
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 13
    OnClick = okButtonClick
  end
  object GroupBox1: TGroupBox
    Left = 288
    Top = 7
    Width = 265
    Height = 161
    Caption = 'Default RTK Values'
    TabOrder = 3
    object Label4: TLabel
      Left = 92
      Top = 20
      Width = 8
      Height = 13
      Caption = 'R'
    end
    object Label5: TLabel
      Left = 156
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
      Top = 90
      Width = 24
      Height = 13
      Caption = 'Long'
    end
    object Label11: TLabel
      Left = 16
      Top = 131
      Width = 24
      Height = 13
      Caption = 'Total'
    end
    object R1Edit: TEdit
      Left = 72
      Top = 39
      Width = 49
      Height = 21
      TabOrder = 0
      Text = '0.0'
      OnKeyPress = FloatEdtKeyPress
    end
    object R2Edit: TEdit
      Left = 72
      Top = 64
      Width = 49
      Height = 21
      TabOrder = 3
      Text = '0.0'
      OnKeyPress = FloatEdtKeyPress
    end
    object R3Edit: TEdit
      Left = 72
      Top = 88
      Width = 49
      Height = 21
      TabOrder = 6
      Text = '0.0'
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
      Top = 39
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
      Top = 87
      Width = 49
      Height = 21
      TabOrder = 8
      Text = '0.0'
      OnKeyPress = FloatEdtKeyPress
    end
    object TotalEdit: TEdit
      Left = 72
      Top = 128
      Width = 49
      Height = 21
      ReadOnly = True
      TabOrder = 9
      Text = '0.0'
    end
  end
  object MaxDepressionStorageEdit: TEdit
    Left = 360
    Top = 216
    Width = 50
    Height = 21
    TabOrder = 4
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object RateOfReductionEdit: TEdit
    Left = 424
    Top = 216
    Width = 50
    Height = 21
    TabOrder = 5
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object InitialValueEdit: TEdit
    Left = 488
    Top = 216
    Width = 50
    Height = 21
    TabOrder = 6
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object MaxDepressionStorageEdit2: TEdit
    Left = 359
    Top = 243
    Width = 50
    Height = 21
    TabOrder = 7
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object RateOfReductionEdit2: TEdit
    Left = 424
    Top = 243
    Width = 50
    Height = 21
    TabOrder = 8
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object InitialValueEdit2: TEdit
    Left = 488
    Top = 243
    Width = 50
    Height = 21
    TabOrder = 9
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object MaxDepressionStorageEdit3: TEdit
    Left = 360
    Top = 270
    Width = 50
    Height = 21
    TabOrder = 10
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object RateOfReductionEdit3: TEdit
    Left = 424
    Top = 270
    Width = 50
    Height = 21
    TabOrder = 11
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object InitialValueEdit3: TEdit
    Left = 488
    Top = 270
    Width = 50
    Height = 21
    TabOrder = 12
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object NumberOfAnalyzedEvents: TEdit
    Left = 8
    Top = 152
    Width = 265
    Height = 21
    Enabled = False
    TabOrder = 15
  end
end
