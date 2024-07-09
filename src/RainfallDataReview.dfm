object frmRainfallReview: TfrmRainfallReview
  Left = 0
  Top = 0
  Caption = 'Rainfall Review'
  ClientHeight = 593
  ClientWidth = 954
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 8
    Top = 8
    Width = 81
    Height = 13
    Caption = 'Raingauge Name'
  end
  object Label2: TLabel
    Left = 522
    Top = 8
    Width = 84
    Height = 13
    Caption = 'Largest Event for'
  end
  object Label3: TLabel
    Left = 555
    Top = 27
    Width = 38
    Height = 13
    Caption = 'Volume:'
  end
  object Label4: TLabel
    Left = 539
    Top = 46
    Width = 54
    Height = 13
    Caption = 'Start Date:'
  end
  object Label5: TLabel
    Left = 724
    Top = 46
    Width = 45
    Height = 13
    Caption = 'Duration:'
  end
  object lblLargestEvent: TLabel
    Left = 610
    Top = 8
    Width = 3
    Height = 13
  end
  object lblVolume: TLabel
    Left = 610
    Top = 27
    Width = 3
    Height = 13
  end
  object lblStart: TLabel
    Left = 610
    Top = 46
    Width = 3
    Height = 13
  end
  object lblDuration: TLabel
    Left = 786
    Top = 46
    Width = 3
    Height = 13
  end
  object Label1: TLabel
    Left = 320
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Label1'
    Visible = False
  end
  object Label6: TLabel
    Left = 594
    Top = 280
    Width = 43
    Height = 13
    Caption = 'No Data.'
  end
  object RaingaugeNameComboBox: TComboBox
    Left = 8
    Top = 27
    Width = 282
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = RaingaugeNameComboBoxChange
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 58
    Width = 505
    Height = 109
    ColCount = 6
    DefaultColWidth = 24
    DefaultRowHeight = 20
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    TabOrder = 1
    Visible = False
    OnSelectCell = StringGrid1SelectCell
    ColWidths = (
      24
      119
      74
      64
      96
      101)
  end
  object StringGrid2: TStringGrid
    Left = 8
    Top = 65
    Width = 282
    Height = 512
    ColCount = 4
    DefaultColWidth = 24
    DefaultRowHeight = 20
    TabOrder = 2
    ColWidths = (
      24
      127
      65
      40)
  end
  object Button1: TButton
    Left = 336
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
    Visible = False
    OnClick = Button1Click
  end
end
