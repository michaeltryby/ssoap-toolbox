object frmFlowMeterSelector: TfrmFlowMeterSelector
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Choose a Flow Meter'
  ClientHeight = 107
  ClientWidth = 376
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
    Top = 12
    Width = 103
    Height = 13
    Caption = 'Choose a Flow Meter:'
  end
  object FlowMeterNameComboBox: TComboBox
    Left = 8
    Top = 31
    Width = 265
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object OKButton: TButton
    Left = 48
    Top = 74
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = OKButtonClick
  end
  object HelpButton: TButton
    Left = 152
    Top = 74
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 2
    Visible = False
    OnClick = HelpButtonClick
  end
  object btnClose: TButton
    Left = 256
    Top = 74
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 3
    OnClick = btnCloseClick
  end
end
