object frmAutomaticGWIAdjustmentCalculation: TfrmAutomaticGWIAdjustmentCalculation
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Automatic DWF Adjustment Calculation'
  ClientHeight = 86
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
    Top = 7
    Width = 69
    Height = 13
    Caption = 'Analysis Name'
  end
  object AnalysisNameComboBox: TComboBox
    Left = 8
    Top = 24
    Width = 300
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object okButton: TButton
    Left = 16
    Top = 53
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 120
    Top = 53
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 2
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 224
    Top = 53
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 3
    OnClick = cancelButtonClick
  end
end
