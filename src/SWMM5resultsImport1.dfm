object frmSWMM5ResultsImport1: TfrmSWMM5ResultsImport1
  Left = 287
  Top = 176
  BorderStyle = bsDialog
  Caption = 'Import SWMM 5 Results'
  ClientHeight = 393
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 73
    Height = 13
    Caption = 'Scenario Name'
  end
  object Label3: TLabel
    Left = 8
    Top = 166
    Width = 99
    Height = 13
    Caption = 'SWMM 5 Output File'
  end
  object Label1: TLabel
    Left = 8
    Top = 52
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object Label4: TLabel
    Left = 8
    Top = 127
    Width = 91
    Height = 13
    Caption = 'SWMM 5 Input File'
  end
  object ScenarioNameComboBox: TComboBox
    Left = 8
    Top = 25
    Width = 319
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    Sorted = True
    TabOrder = 0
    OnChange = ScenarioNameComboBoxChange
  end
  object okButton: TButton
    Left = 32
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Import'
    Default = True
    TabOrder = 1
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 128
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 2
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 222
    Top = 360
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cancelButtonClick
  end
  object SWMM5OutputFileEdit: TEdit
    Left = 8
    Top = 181
    Width = 265
    Height = 21
    TabOrder = 4
    OnKeyPress = FloatEdtKeyPress
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 208
    Width = 319
    Height = 146
    Caption = 'SWMM 5 Output File Summary'
    TabOrder = 5
    Visible = False
    object lblEnd: TLabel
      Left = 144
      Top = 54
      Width = 48
      Height = 13
      Caption = 'End Date:'
    end
    object lblStart: TLabel
      Left = 144
      Top = 35
      Width = 51
      Height = 13
      Caption = 'Start Date:'
    end
    object lblNumPer: TLabel
      Left = 144
      Top = 16
      Width = 63
      Height = 13
      Caption = 'Num Periods:'
    end
    object lblRep: TLabel
      Left = 16
      Top = 70
      Width = 60
      Height = 13
      Caption = 'Report Step:'
    end
    object lblSuccess: TLabel
      Left = 16
      Top = 16
      Width = 44
      Height = 13
      Caption = 'Success:'
    end
    object lblUnits: TLabel
      Left = 16
      Top = 32
      Width = 52
      Height = 13
      Caption = 'Flow Units:'
    end
    object lblVersion: TLabel
      Left = 16
      Top = 51
      Width = 38
      Height = 13
      Caption = 'Version:'
    end
    object lblNumSubc: TLabel
      Left = 16
      Top = 88
      Width = 124
      Height = 13
      Caption = 'Number of Subcatchment:'
    end
    object lblNumCond: TLabel
      Left = 16
      Top = 107
      Width = 96
      Height = 13
      Caption = 'Number of Conduits:'
    end
    object lblNumJunc: TLabel
      Left = 16
      Top = 126
      Width = 100
      Height = 13
      Caption = 'Number of Junctions:'
    end
  end
  object BrowseSWMMfile: TButton
    Left = 279
    Top = 177
    Width = 49
    Height = 25
    Caption = 'Browse'
    TabOrder = 6
    OnClick = BrowseSWMMfileClick
  end
  object ScenarioDescription: TMemo
    Left = 8
    Top = 71
    Width = 319
    Height = 50
    Lines.Strings = (
      'ScenarioDescription')
    ReadOnly = True
    TabOrder = 7
  end
  object SWMM5InputFileEdit: TEdit
    Left = 8
    Top = 142
    Width = 319
    Height = 21
    Enabled = False
    TabOrder = 8
    OnKeyPress = FloatEdtKeyPress
  end
  object dlgOpenSWMM5Output: TOpenDialog
    DefaultExt = '*.out'
    Filter = 'SWMM5 Output|*.out'
    Options = [ofReadOnly, ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Open SWMM5 Output'
    Left = 16
    Top = 358
  end
end
