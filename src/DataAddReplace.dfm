object frmDataAddReplace: TfrmDataAddReplace
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Warning'
  ClientHeight = 110
  ClientWidth = 449
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object WarningLabel: TLabel
    Left = 16
    Top = 16
    Width = 66
    Height = 13
    Caption = 'WarningLabel'
  end
  object addButton: TButton
    Left = 56
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 0
    OnClick = addButtonClick
  end
  object removeButton: TButton
    Left = 144
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Remove'
    TabOrder = 1
    OnClick = removeButtonClick
  end
  object cancelButton: TButton
    Left = 320
    Top = 80
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cancelButtonClick
  end
  object helpButton: TButton
    Left = 232
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 2
    OnClick = helpButtonClick
  end
end
