object frmConvertRainTimeStep: TfrmConvertRainTimeStep
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Convert Rain Time Step'
  ClientHeight = 170
  ClientWidth = 281
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
    Left = 8
    Top = 49
    Width = 130
    Height = 13
    Caption = 'Current Time Step (minutes)'
  end
  object Label2: TLabel
    Left = 8
    Top = 91
    Width = 118
    Height = 13
    Caption = 'New Time Step (minutes)'
  end
  object Label3: TLabel
    Left = 7
    Top = 7
    Width = 83
    Height = 13
    Caption = 'Raingauge Name'
  end
  object CurrentTimeStepEdit: TEdit
    Left = 8
    Top = 66
    Width = 265
    Height = 21
    TabStop = False
    ReadOnly = True
    TabOrder = 1
    Text = '10'
    OnChange = CurrentTimeStepEditChange
  end
  object NewTimeStepSpinEdit_deprecated: TSpinEdit
    Left = 8
    Top = 108
    Width = 265
    Height = 22
    Increment = 5
    MaxValue = 60
    MinValue = 1
    TabOrder = 2
    Value = 15
  end
  object okButton: TButton
    Left = 8
    Top = 137
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 104
    Top = 137
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 4
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 200
    Top = 137
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = cancelButtonClick
  end
  object RainGaugeNameComboBox: TComboBox
    Left = 8
    Top = 24
    Width = 265
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = RainGaugeNameComboBoxChange
    Items.Strings = (
      'RG1'
      'RG2'
      'RG3'
      'RG4')
  end
  object ComboBoxNewTimeStep: TComboBox
    Left = 8
    Top = 107
    Width = 265
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '10'
      '12'
      '15'
      '20'
      '30'
      '60')
  end
end
