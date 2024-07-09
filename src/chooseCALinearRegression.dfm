object frmCAChooseLinearRegression: TfrmCAChooseLinearRegression
  Left = 0
  Top = 0
  Caption = 'Choose Regression Method'
  ClientHeight = 263
  ClientWidth = 317
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
    Width = 157
    Height = 13
    Caption = 'Choose a Condition Assessment:'
  end
  object CANameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 239
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object btnDetails: TButton
    Left = 252
    Top = 22
    Width = 57
    Height = 25
    Caption = 'Details'
    TabOrder = 1
    OnClick = btnDetailsClick
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
    TabOrder = 2
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 112
    Width = 301
    Height = 112
    Caption = 'Total R Values vs.'
    TabOrder = 3
  end
  object RadioButton4: TRadioButton
    Left = 16
    Top = 197
    Width = 161
    Height = 17
    Caption = 'Rainfall Event Duration (hr)'
    TabOrder = 4
  end
  object RadioButton3: TRadioButton
    Left = 16
    Top = 174
    Width = 193
    Height = 17
    Caption = 'Rainfall Event Peak Intensity (in/hr)'
    TabOrder = 5
  end
  object RadioButton2: TRadioButton
    Left = 16
    Top = 151
    Width = 285
    Height = 17
    Caption = 'Total Rainfall Volume 2 Weeks Prior To The Events (in)'
    TabOrder = 6
  end
  object RadioButton1: TRadioButton
    Left = 16
    Top = 128
    Width = 153
    Height = 17
    Caption = 'Total Rainfall Volume (in)'
    Checked = True
    TabOrder = 7
    TabStop = True
  end
  object okButton: TButton
    Left = 16
    Top = 230
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 8
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 120
    Top = 230
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 9
    OnClick = helpButtonClick
  end
  object btnClose: TButton
    Left = 224
    Top = 230
    Width = 75
    Height = 25
    Caption = 'Close'
    Default = True
    TabOrder = 10
    OnClick = btnCloseClick
  end
end
