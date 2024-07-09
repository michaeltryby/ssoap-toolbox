object frmEditScenario: TfrmEditScenario
  Left = 320
  Top = 217
  BorderStyle = bsDialog
  Caption = 'Edit Scenario'
  ClientHeight = 248
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
  object Label2: TLabel
    Left = 7
    Top = 49
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object ScenarioNameEdit: TEdit
    Left = 6
    Top = 22
    Width = 277
    Height = 21
    TabOrder = 0
  end
  object okButton: TButton
    Left = 8
    Top = 215
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 104
    Top = 215
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 2
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 208
    Top = 216
    Width = 75
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cancelButtonClick
  end
  object DescriptionEdit: TEdit
    Left = 8
    Top = 68
    Width = 273
    Height = 21
    TabOrder = 4
  end
  object Button1: TButton
    Left = 8
    Top = 167
    Width = 113
    Height = 25
    Caption = 'RTK Pattern Setup'
    TabOrder = 5
    OnClick = Button1Click
  end
  object GroupBoxFlowUnits: TGroupBox
    Left = 8
    Top = 96
    Width = 273
    Height = 65
    Caption = 'Flow Units'
    TabOrder = 6
    object RadioButton_MGD: TRadioButton
      Left = 16
      Top = 16
      Width = 73
      Height = 17
      Caption = 'MGD'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton_CFS: TRadioButton
      Left = 104
      Top = 16
      Width = 75
      Height = 17
      Caption = 'CFS'
      TabOrder = 1
    end
    object RadioButton_GPM: TRadioButton
      Left = 185
      Top = 16
      Width = 73
      Height = 17
      Caption = 'GPM'
      TabOrder = 2
    end
    object RadioButton_CMS: TRadioButton
      Left = 16
      Top = 39
      Width = 66
      Height = 17
      Caption = 'CMS'
      TabOrder = 3
    end
    object RadioButton_LPS: TRadioButton
      Left = 104
      Top = 39
      Width = 59
      Height = 17
      Caption = 'L/S'
      TabOrder = 4
    end
  end
end
