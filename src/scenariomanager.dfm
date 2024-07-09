object frmScenarioManagement: TfrmScenarioManagement
  Left = 320
  Top = 160
  Caption = 'Scenario Management'
  ClientHeight = 342
  ClientWidth = 280
  Color = clBtnFace
  Constraints.MaxWidth = 288
  Constraints.MinHeight = 180
  Constraints.MinWidth = 288
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    280
    342)
  PixelsPerInch = 96
  TextHeight = 13
  object ListBoxLabel: TLabel
    Left = 7
    Top = 7
    Width = 42
    Height = 13
    Caption = 'Scenario'
  end
  object Label1: TLabel
    Left = 8
    Top = 159
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object addButton: TButton
    Left = 8
    Top = 309
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Add...'
    TabOrder = 4
    OnClick = addButtonClick
  end
  object closeButton: TButton
    Left = 197
    Top = 309
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 6
    OnClick = closeButtonClick
  end
  object helpButton: TButton
    Left = 102
    Top = 309
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Help'
    TabOrder = 5
    OnClick = helpButtonClick
  end
  object editButton: TButton
    Left = 8
    Top = 271
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Edit...'
    TabOrder = 1
    OnClick = editButtonClick
  end
  object deleteButton: TButton
    Left = 197
    Top = 271
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Delete...'
    TabOrder = 3
    OnClick = deleteButtonClick
  end
  object ScenarioListBox: TListBox
    Left = 7
    Top = 24
    Width = 265
    Height = 129
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
    OnClick = listclick
  end
  object ScenarioDesciption: TMemo
    Left = 8
    Top = 176
    Width = 265
    Height = 89
    Lines.Strings = (
      'ScenarioDesciption')
    TabOrder = 7
  end
  object CopyButton: TButton
    Left = 102
    Top = 271
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Copy...'
    TabOrder = 2
    OnClick = CopyButtonClick
  end
end
