object frmSWMM5_RDIIImporter: TfrmSWMM5_RDIIImporter
  Left = 0
  Top = 0
  Caption = 'SWMM5 RDII/Hydrograph Importer'
  ClientHeight = 365
  ClientWidth = 456
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LabelScenarioID: TLabel
    Left = 24
    Top = 8
    Width = 77
    Height = 13
    Caption = 'LabelScenarioID'
  end
  object Button1: TButton
    Left = 24
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 0
    OnClick = Button1Click
  end
  object EditSWMM5InputFileName: TEdit
    Left = 24
    Top = 32
    Width = 409
    Height = 21
    TabOrder = 1
    Text = 'EditSWMM5InputFileName'
  end
  object Memo1: TMemo
    Left = 24
    Top = 96
    Width = 409
    Height = 249
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
