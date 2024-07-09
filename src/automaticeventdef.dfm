object frmAutomaticEventIdentification: TfrmAutomaticEventIdentification
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Automatic Event Identification'
  ClientHeight = 338
  ClientWidth = 314
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
    Width = 160
    Height = 13
    Caption = 'Number of Time Steps to Average'
  end
  object MinimumPeakIILabel: TLabel
    Left = 7
    Top = 91
    Width = 83
    Height = 13
    Caption = 'Minimum Peak I/I'
  end
  object Label3: TLabel
    Left = 7
    Top = 133
    Width = 152
    Height = 13
    Caption = 'Minimum Event Duration (Hours)'
  end
  object MinimumRainfallVolumeLabel: TLabel
    Left = 7
    Top = 175
    Width = 117
    Height = 13
    Caption = 'Minimum Rainfall Volume'
  end
  object Label5: TLabel
    Left = 7
    Top = 217
    Width = 142
    Height = 13
    Caption = 'Hours to Add to Start of Event'
  end
  object Label6: TLabel
    Left = 7
    Top = 259
    Width = 139
    Height = 13
    Caption = 'Hours to Add to End of Event'
  end
  object Label7: TLabel
    Left = 7
    Top = 8
    Width = 69
    Height = 13
    Caption = 'Analysis Name'
  end
  object TimeStepsToAverageSpinEdit: TSpinEdit
    Left = 7
    Top = 66
    Width = 300
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 1
    Value = 1
  end
  object HoursToAddToStartSpinEdit: TSpinEdit
    Left = 7
    Top = 234
    Width = 300
    Height = 22
    MaxValue = 100
    MinValue = 0
    TabOrder = 5
    Value = 0
  end
  object HoursToAddToEndSpinEdit: TSpinEdit
    Left = 7
    Top = 276
    Width = 300
    Height = 22
    MaxValue = 100
    MinValue = 0
    TabOrder = 6
    Value = 0
  end
  object AnalysisNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 300
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = AnalysisNameComboBoxChange
  end
  object okButton: TButton
    Left = 16
    Top = 305
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 7
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 120
    Top = 305
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 8
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 224
    Top = 305
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 9
    OnClick = cancelButtonClick
  end
  object MinimumPeakIIEdit: TEdit
    Left = 7
    Top = 108
    Width = 300
    Height = 21
    TabOrder = 2
    Text = '0'
    OnKeyPress = FloatEdtKeyPress
  end
  object MinimumEventDurationEdit: TEdit
    Left = 7
    Top = 150
    Width = 300
    Height = 21
    TabOrder = 3
    Text = '6'
    OnKeyPress = FloatEdtKeyPress
  end
  object MinimumRainfallVolumeEdit: TEdit
    Left = 7
    Top = 192
    Width = 300
    Height = 21
    TabOrder = 4
    Text = '0.5'
    OnKeyPress = FloatEdtKeyPress
  end
end
