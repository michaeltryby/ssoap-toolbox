object frmRainfallIntensityStatistics: TfrmRainfallIntensityStatistics
  Left = 327
  Top = 189
  BorderStyle = bsDialog
  Caption = 'Rainfall Intensity Statistics'
  ClientHeight = 244
  ClientWidth = 352
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
  object Label3: TLabel
    Left = 7
    Top = 125
    Width = 172
    Height = 13
    Caption = 'Minimum Interevent Duration (Hours)'
  end
  object MinimumRainfallVolumeLabel: TLabel
    Left = 7
    Top = 167
    Width = 117
    Height = 13
    Caption = 'Minimum Rainfall Volume'
  end
  object AnalysisNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 337
    Height = 21
    ItemHeight = 0
    TabOrder = 0
  end
  object FilenameEdit: TEdit
    Left = 7
    Top = 66
    Width = 337
    Height = 21
    TabOrder = 1
  end
  object BrowseButton: TButton
    Left = 269
    Top = 94
    Width = 75
    Height = 25
    Caption = 'Browse...'
    TabOrder = 2
    OnClick = BrowseButtonClick
  end
  object okButton: TButton
    Left = 31
    Top = 213
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 5
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 133
    Top = 213
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 6
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 235
    Top = 213
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 7
    OnClick = cancelButtonClick
  end
  object MinimumIntereventDurationEdit: TEdit
    Left = 7
    Top = 142
    Width = 337
    Height = 21
    TabOrder = 3
    Text = '0'
  end
  object MinimumRainfallVolumeEdit: TEdit
    Left = 7
    Top = 184
    Width = 337
    Height = 21
    TabOrder = 4
    Text = '0.0'
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.txt'
    Filter = 'Text Files|*.txt|All Files|*.*'
    Left = 208
    Top = 96
  end
end
