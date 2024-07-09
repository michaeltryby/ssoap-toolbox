object frmAnalysisManagement: TfrmAnalysisManagement
  Left = 367
  Top = 220
  Caption = 'Analysis Management'
  ClientHeight = 245
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
  OnShow = FormShow
  DesignSize = (
    280
    245)
  PixelsPerInch = 96
  TextHeight = 13
  object ListBoxLabel: TLabel
    Left = 7
    Top = 7
    Width = 42
    Height = 13
    Caption = 'Analyses'
  end
  object editButton: TButton
    Left = 48
    Top = 175
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Edit...'
    TabOrder = 1
    OnClick = editButtonClick
  end
  object deleteButton: TButton
    Left = 156
    Top = 175
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Delete...'
    TabOrder = 2
    OnClick = deleteButtonClick
  end
  object addButton: TButton
    Left = 10
    Top = 211
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Add...'
    TabOrder = 3
    OnClick = addButtonClick
  end
  object helpButton: TButton
    Left = 102
    Top = 211
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Help'
    TabOrder = 4
    OnClick = helpButtonClick
  end
  object closeButton: TButton
    Left = 194
    Top = 211
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 5
    OnClick = closeButtonClick
  end
  object AnalysisListBox: TListBox
    Left = 8
    Top = 24
    Width = 265
    Height = 145
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
    OnClick = AnalysisListBoxClick
  end
end
