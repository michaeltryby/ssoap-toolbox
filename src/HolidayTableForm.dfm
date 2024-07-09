object frmHolidayTable: TfrmHolidayTable
  Left = 0
  Top = 0
  Caption = 'Holidays Table'
  ClientHeight = 382
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    280
    382)
  PixelsPerInch = 96
  TextHeight = 13
  object ListBoxLabel: TLabel
    Left = 7
    Top = 7
    Width = 40
    Height = 13
    Caption = 'Holidays'
  end
  object editButton: TButton
    Left = 48
    Top = 312
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Edit...'
    TabOrder = 0
    OnClick = editButtonClick
  end
  object addButton: TButton
    Left = 10
    Top = 348
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Add...'
    TabOrder = 1
    OnClick = addButtonClick
  end
  object helpButton: TButton
    Left = 102
    Top = 348
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Help'
    TabOrder = 2
    OnClick = helpButtonClick
  end
  object deleteButton: TButton
    Left = 156
    Top = 312
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Delete...'
    TabOrder = 3
    OnClick = deleteButtonClick
  end
  object closeButton: TButton
    Left = 194
    Top = 348
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 4
    OnClick = closeButtonClick
  end
  object HolidayStringGrid: TStringGrid
    Left = 8
    Top = 24
    Width = 265
    Height = 282
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 2
    DefaultColWidth = 130
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goRowSelect]
    TabOrder = 5
  end
end
