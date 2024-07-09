object frmCAManagement: TfrmCAManagement
  Left = 500
  Top = 220
  Caption = 'Pre- & Post-Sewer Rehabilitation Analysis Management'
  ClientHeight = 225
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
  Position = poDesigned
  OnShow = FormShow
  DesignSize = (
    280
    225)
  PixelsPerInch = 96
  TextHeight = 13
  object ListBoxLabel: TLabel
    Left = 7
    Top = 7
    Width = 91
    Height = 13
    Caption = 'Available Analyzes:'
  end
  object editButton: TButton
    Left = 48
    Top = 155
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Edit...'
    TabOrder = 1
    OnClick = editButtonClick
    ExplicitTop = 170
  end
  object deleteButton: TButton
    Left = 156
    Top = 155
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Delete...'
    TabOrder = 2
    OnClick = deleteButtonClick
    ExplicitTop = 170
  end
  object addButton: TButton
    Left = 8
    Top = 192
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Add...'
    TabOrder = 3
    OnClick = addButtonClick
    ExplicitTop = 207
  end
  object helpButton: TButton
    Left = 102
    Top = 191
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Help'
    TabOrder = 4
    OnClick = helpButtonClick
    ExplicitTop = 206
  end
  object closeButton: TButton
    Left = 194
    Top = 191
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 5
    OnClick = closeButtonClick
    ExplicitTop = 206
  end
  object CAListBox: TListBox
    Left = 7
    Top = 24
    Width = 265
    Height = 125
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
    ExplicitHeight = 140
  end
end
