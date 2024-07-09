object frmRTKPatternManager: TfrmRTKPatternManager
  Left = 320
  Top = 160
  Caption = 'RTK Pattern Manager'
  ClientHeight = 245
  ClientWidth = 798
  Color = clBtnFace
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
    798
    245)
  PixelsPerInch = 96
  TextHeight = 13
  object ListBoxLabel: TLabel
    Left = 8
    Top = 7
    Width = 64
    Height = 13
    Caption = 'RTK Patterns'
  end
  object addButton: TButton
    Left = 92
    Top = 212
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Add...'
    TabOrder = 4
    OnClick = addButtonClick
    ExplicitLeft = 87
  end
  object closeButton: TButton
    Left = 630
    Top = 212
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    ModalResult = 2
    TabOrder = 6
    OnClick = closeButtonClick
    ExplicitLeft = 605
  end
  object helpButton: TButton
    Left = 359
    Top = 211
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Help'
    TabOrder = 5
    OnClick = helpButtonClick
    ExplicitLeft = 344
  end
  object editButton: TButton
    Left = 91
    Top = 175
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Edit...'
    TabOrder = 1
    OnClick = editButtonClick
    ExplicitLeft = 87
  end
  object deleteButton: TButton
    Left = 630
    Top = 175
    Width = 75
    Height = 24
    Anchors = [akBottom]
    Caption = 'Delete...'
    TabOrder = 3
    OnClick = deleteButtonClick
    ExplicitLeft = 605
  end
  object RTKPatternsListBox: TListBox
    Left = 8
    Top = 24
    Width = 783
    Height = 58
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
    ExplicitWidth = 753
  end
  object copyButton: TButton
    Left = 359
    Top = 175
    Width = 75
    Height = 24
    Anchors = [akBottom]
    Caption = 'Copy...'
    TabOrder = 2
    OnClick = copyButtonClick
    ExplicitLeft = 344
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 24
    Width = 782
    Height = 145
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 22
    DefaultColWidth = 24
    DefaultRowHeight = 20
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    TabOrder = 7
    OnSelectCell = StringGrid1SelectCell
    ExplicitWidth = 752
    ColWidths = (
      24
      150
      34
      39
      31
      24
      24
      29
      24
      24
      29
      24
      24
      29
      28
      29
      28
      29
      29
      28
      28
      29)
  end
end
