object frmRdiiConverterManagement: TfrmRdiiConverterManagement
  Left = 320
  Top = 160
  Caption = 'RDII Converter Management'
  ClientHeight = 245
  ClientWidth = 280
  Color = clBtnFace
  Constraints.MaxWidth = 288
  Constraints.MinHeight = 180
  Constraints.MinWidth = 288
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
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
    Width = 76
    Height = 13
    Caption = 'RDII Converters'
  end
  object addButton: TButton
    Left = 10
    Top = 213
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Add...'
    TabOrder = 3
    OnClick = addButtonClick
  end
  object closeButton: TButton
    Left = 194
    Top = 213
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 5
    OnClick = closeButtonClick
  end
  object helpButton: TButton
    Left = 102
    Top = 213
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Help'
    TabOrder = 4
  end
  object editButton: TButton
    Left = 48
    Top = 177
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Edit...'
    TabOrder = 1
    OnClick = editButtonClick
  end
  object deleteButton: TButton
    Left = 156
    Top = 177
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Delete...'
    TabOrder = 2
    OnClick = deleteButtonClick
  end
  object ConverterListBox: TListBox
    Left = 7
    Top = 24
    Width = 265
    Height = 147
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
  end
end
