object frmEventsTable: TfrmEventsTable
  Left = 0
  Top = 0
  Caption = 'Events Table'
  ClientHeight = 351
  ClientWidth = 924
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    924
    351)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 53
    Width = 46
    Height = 13
    Caption = 'Event ID:'
    Visible = False
  end
  object Label2: TLabel
    Left = 13
    Top = 16
    Width = 57
    Height = 13
    Caption = 'Analysis ID:'
  end
  object EventNameComboBox: TComboBox
    Left = 96
    Top = 50
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'EventNameComboBox'
    Visible = False
    OnChange = EventNameComboBoxChange
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 40
    Width = 909
    Height = 302
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 22
    DefaultColWidth = 24
    TabOrder = 0
    ExplicitWidth = 762
    ColWidths = (
      24
      75
      98
      89
      43
      37
      40
      39
      37
      39
      37
      33
      34
      33
      34
      31
      24
      24
      24
      24
      24
      24)
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object AnalysisNameComboBox: TComboBox
    Left = 85
    Top = 13
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = 'AnalysisNameComboBox'
    OnChange = AnalysisNameComboBoxChange
  end
end
