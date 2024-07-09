object frmSWMM5ResultsImport2: TfrmSWMM5ResultsImport2
  Left = 287
  Top = 176
  BorderStyle = bsDialog
  Caption = 'Configure SWMM 5 Results'
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
  object LabelSSOCount: TLabel
    Left = 8
    Top = 245
    Width = 82
    Height = 13
    Caption = '0 SSOs selected.'
  end
  object LabelJunctionCount: TLabel
    Left = 8
    Top = 283
    Width = 100
    Height = 13
    Caption = '0 Junctions selected.'
  end
  object LabelSSOStatus: TLabel
    Left = 8
    Top = 264
    Width = 30
    Height = 13
    Caption = '          '
  end
  object LabelJunctionStatus: TLabel
    Left = 8
    Top = 302
    Width = 30
    Height = 13
    Caption = '          '
  end
  object LabelNumJunctions: TLabel
    Left = 8
    Top = 216
    Width = 15
    Height = 13
    Caption = '     '
  end
  object ScenarioNameComboBox: TComboBox
    Left = 8
    Top = 25
    Width = 319
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnChange = ScenarioNameComboBoxChange
  end
  object okButton: TButton
    Left = 32
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Re-Import'
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
    Width = 319
    Height = 21
    TabOrder = 4
    OnKeyPress = SWMM5OutputFileEditKeyPress
  end
  object ScenarioDescription: TMemo
    Left = 8
    Top = 71
    Width = 319
    Height = 50
    Lines.Strings = (
      'ScenarioDescription')
    ReadOnly = True
    TabOrder = 5
  end
  object SWMM5InputFileEdit: TEdit
    Left = 8
    Top = 142
    Width = 319
    Height = 21
    Enabled = False
    TabOrder = 6
    OnKeyPress = FloatEdtKeyPress
  end
  object btnSSOs: TButton
    Left = 142
    Top = 240
    Width = 185
    Height = 25
    Caption = 'Select SSO Junctions'
    TabOrder = 7
    OnClick = btnSSOsClick
  end
  object btnDepths: TButton
    Left = 142
    Top = 278
    Width = 185
    Height = 25
    Caption = 'Select Junctions for Depth Timeseries'
    TabOrder = 8
    OnClick = btnDepthsClick
  end
  object btnGraphs: TButton
    Left = 78
    Top = 329
    Width = 185
    Height = 25
    Caption = 'Select Graphs'
    TabOrder = 9
    OnClick = btnGraphsClick
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
