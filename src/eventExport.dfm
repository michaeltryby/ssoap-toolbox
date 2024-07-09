object frmEventExport: TfrmEventExport
  Left = 329
  Top = 286
  BorderStyle = bsDialog
  Caption = 'Export I/I Events'
  ClientHeight = 168
  ClientWidth = 343
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AnalysisLabel: TLabel
    Left = 7
    Top = 7
    Width = 69
    Height = 13
    Caption = 'Analysis Name'
  end
  object Filename: TLabel
    Left = 7
    Top = 49
    Width = 47
    Height = 13
    Caption = 'File Name'
  end
  object AnalysisNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 329
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
  object FilenameEdit: TEdit
    Left = 7
    Top = 66
    Width = 329
    Height = 21
    TabOrder = 1
  end
  object BrowseButton: TButton
    Left = 261
    Top = 95
    Width = 75
    Height = 25
    Caption = 'Browse...'
    TabOrder = 2
    OnClick = BrowseButtonClick
  end
  object okButton: TButton
    Left = 31
    Top = 136
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 133
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 4
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 235
    Top = 136
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 5
    OnClick = cancelButtonClick
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.txt'
    Filter = 'Text Files|*.txt|All Files|*.*'
    Left = 208
    Top = 104
  end
end
