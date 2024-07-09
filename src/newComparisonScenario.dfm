object frmAddComparisonScenario: TfrmAddComparisonScenario
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Add New Comparison Scenario'
  ClientHeight = 86
  ClientWidth = 292
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
  object ComparisonScenarioNameEdit: TEdit
    Left = 7
    Top = 24
    Width = 277
    Height = 21
    TabOrder = 0
    OnKeyPress = ComparisonScenarioNameEditKeyPress
  end
  object okButton: TButton
    Left = 16
    Top = 51
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 112
    Top = 51
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 2
    Visible = False
  end
  object cancelButton: TButton
    Left = 208
    Top = 51
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cancelButtonClick
  end
end
