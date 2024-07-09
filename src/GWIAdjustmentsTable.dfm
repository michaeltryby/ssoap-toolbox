object frmGWIAdjustmentTable: TfrmGWIAdjustmentTable
  Left = 0
  Top = 0
  Caption = 'DWF Adjustment Table'
  ClientHeight = 351
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    368
    351)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 57
    Height = 13
    Caption = 'Analysis ID:'
  end
  object AnalysisNameComboBox: TComboBox
    Left = 80
    Top = 13
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnChange = AnalysisNameComboBoxChange
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 56
    Width = 352
    Height = 282
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 3
    DefaultColWidth = 24
    TabOrder = 1
    ExplicitWidth = 410
    ExplicitHeight = 377
    ColWidths = (
      24
      151
      167)
    RowHeights = (
      24
      24
      24
      24
      24)
  end
end
