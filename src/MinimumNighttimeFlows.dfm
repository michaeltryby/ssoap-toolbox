object frmMinimumNighttimeFlows: TfrmMinimumNighttimeFlows
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Determine Minimum Nighttime Flows'
  ClientHeight = 171
  ClientWidth = 295
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
  object TLabel
    Left = 7
    Top = 7
    Width = 83
    Height = 13
    Caption = 'Flow Meter Name'
  end
  object Label1: TLabel
    Left = 7
    Top = 49
    Width = 134
    Height = 13
    Caption = 'Time Steps to Average Over'
  end
  object Label2: TLabel
    Left = 7
    Top = 92
    Width = 172
    Height = 13
    Caption = 'Number of Minimum Flows to Display'
  end
  object FlowMeterNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 281
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object TimeStepsSpinEdit: TSpinEdit
    Left = 7
    Top = 66
    Width = 281
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 1
    Value = 4
  end
  object okButton: TButton
    Left = 16
    Top = 139
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 112
    Top = 139
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 4
    OnClick = helpButtonClick
  end
  object closeButton: TButton
    Left = 208
    Top = 139
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 5
    OnClick = closeButtonClick
  end
  object NumberMinimumFlowsSpinEdit: TSpinEdit
    Left = 7
    Top = 109
    Width = 281
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 2
    Value = 10
  end
end
