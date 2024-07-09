object frmSW5Exporter: TfrmSW5Exporter
  Left = 0
  Top = 0
  Caption = 'frmSW5Exporter'
  ClientHeight = 286
  ClientWidth = 352
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 7
    Width = 58
    Height = 13
    Caption = 'Event Name'
  end
  object Label2: TLabel
    Left = 7
    Top = 49
    Width = 46
    Height = 13
    Caption = 'File Name'
  end
  object Label3: TLabel
    Left = 8
    Top = 93
    Width = 46
    Height = 13
    Caption = 'Precision:'
  end
  object AnalysisNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 337
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object DateTimeRangeGroupBox: TGroupBox
    Left = 7
    Top = 123
    Width = 337
    Height = 117
    Caption = 'Date/Time Range'
    TabOrder = 1
    object entireRangeRadioButton: TRadioButton
      Left = 5
      Top = 18
      Width = 92
      Height = 14
      Caption = 'Entire Range'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object specifyRangeRadioButton: TRadioButton
      Left = 5
      Top = 40
      Width = 92
      Height = 13
      Caption = 'Specify Range'
      TabOrder = 1
    end
    object StartDateTimeCheckBox: TCheckBox
      Left = 30
      Top = 60
      Width = 98
      Height = 14
      Caption = 'Start Date/Time'
      Enabled = False
      TabOrder = 2
    end
    object EndDateTimeCheckBox: TCheckBox
      Left = 30
      Top = 90
      Width = 98
      Height = 14
      Caption = 'End Date/Time'
      Enabled = False
      TabOrder = 5
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
  end
  object FilenameEdit: TEdit
    Left = 7
    Top = 66
    Width = 337
    Height = 21
    TabOrder = 2
  end
  object browseButton: TButton
    Left = 269
    Top = 94
    Width = 75
    Height = 25
    Caption = 'Browse...'
    TabOrder = 3
  end
  object okButton: TButton
    Left = 31
    Top = 248
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 4
  end
  object helpButton: TButton
    Left = 133
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 5
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 235
    Top = 248
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 6
  end
  object UpDown1: TUpDown
    Left = 133
    Top = 92
    Width = 17
    Height = 25
    Min = -32768
    Max = 32767
    TabOrder = 7
  end
  object EdPrecision: TEdit
    Left = 60
    Top = 93
    Width = 75
    Height = 21
    TabOrder = 8
    Text = '0.0000'
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.CSV'
    Filter = '*.CSV|*.CSV|*.TXT|*.TXT|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 192
    Top = 88
  end
end
