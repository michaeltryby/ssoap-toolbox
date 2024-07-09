object frmExportPRNTFLOWCSV: TfrmExportPRNTFLOWCSV
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Export Flow Data to a PRNTFLOW CSV File'
  ClientHeight = 323
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
    Width = 69
    Height = 13
    Caption = 'Export to Units'
  end
  object Label3: TLabel
    Left = 7
    Top = 7
    Width = 83
    Height = 13
    Caption = 'Flow Meter Name'
  end
  object FilenameEdit: TEdit
    Left = 7
    Top = 66
    Width = 337
    Height = 21
    TabOrder = 1
  end
  object browseButton: TButton
    Left = 269
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
  object DateTimeRangeGroupBox: TGroupBox
    Left = 7
    Top = 166
    Width = 337
    Height = 117
    Caption = 'Date/Time Range'
    TabOrder = 4
    object entireRangeRadioButton: TRadioButton
      Left = 5
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
      Left = 5
      Top = 40
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
      Left = 30
      Top = 90
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
  end
  object okButton: TButton
    Left = 31
    Top = 291
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 5
    OnClick = okButtonClick
  end
  object cancelButton: TButton
    Left = 235
    Top = 291
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 7
    OnClick = cancelButtonClick
  end
  object helpButton: TButton
    Left = 133
    Top = 291
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 6
    Visible = False
    OnClick = helpButtonClick
  end
  object FlowMeterNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 337
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = FlowMeterNameComboBoxChange
    Items.Strings = (
      '')
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'CSV'
    Filter = '*.CSV; *.TXT|*.CSV;*.TXT|All Files (*.*)|*.*'
    Left = 232
    Top = 80
  end
end
