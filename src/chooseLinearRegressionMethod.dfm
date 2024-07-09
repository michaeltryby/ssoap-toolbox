object frmChooseLinearRegressionMethod: TfrmChooseLinearRegressionMethod
  Left = 0
  Top = 0
  Caption = 'Choose Regression Method'
  ClientHeight = 261
  ClientWidth = 318
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
    Width = 69
    Height = 13
    Caption = 'Analysis Name'
  end
  object helpButton: TButton
    Left = 120
    Top = 230
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 4
    OnClick = helpButtonClick
  end
  object okButton: TButton
    Left = 16
    Top = 230
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = okButtonClick
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 112
    Width = 301
    Height = 112
    Caption = 'Total R Values vs.'
    TabOrder = 2
  end
  object RadioButton4: TRadioButton
    Left = 16
    Top = 197
    Width = 161
    Height = 17
    Caption = 'Rainfall Event Duration (hr)'
    TabOrder = 6
  end
  object RadioButton3: TRadioButton
    Left = 16
    Top = 174
    Width = 193
    Height = 17
    Caption = 'Rainfall Event Peak Intensity (in/hr)'
    TabOrder = 7
  end
  object RadioButton2: TRadioButton
    Left = 16
    Top = 151
    Width = 285
    Height = 17
    Caption = 'Total Rainfall Volume 2 Weeks Prior To The Events (in)'
    TabOrder = 8
  end
  object RadioButton1: TRadioButton
    Left = 16
    Top = 128
    Width = 153
    Height = 17
    Caption = 'Total Rainfall Volume (in)'
    Checked = True
    TabOrder = 9
    TabStop = True
  end
  object AnalysisNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 302
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object RadioGroupRegressionType: TRadioGroup
    Left = 8
    Top = 48
    Width = 302
    Height = 65
    Caption = 'Regression Type:'
    ItemIndex = 0
    Items.Strings = (
      'Linear Regression'
      'Second-Order Regression')
    TabOrder = 1
  end
  object btnClose: TButton
    Left = 224
    Top = 230
    Width = 75
    Height = 25
    Caption = 'Close'
    Default = True
    TabOrder = 5
    OnClick = btnCloseClick
  end
end
