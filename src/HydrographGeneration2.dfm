object frmHydrographGeneration2: TfrmHydrographGeneration2
  Left = 0
  Top = 0
  Caption = 'RDII Hydrograph Analysis'
  ClientHeight = 692
  ClientWidth = 897
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
    Width = 83
    Height = 13
    Caption = 'Sewershed Name'
  end
  object Label5: TLabel
    Left = 8
    Top = 52
    Width = 53
    Height = 13
    Caption = 'RDII Areas'
  end
  object Label1: TLabel
    Left = 8
    Top = 146
    Width = 43
    Height = 13
    Caption = 'Analyses'
  end
  object Label2: TLabel
    Left = 8
    Top = 192
    Width = 33
    Height = 13
    Caption = 'Events'
  end
  object Label11: TLabel
    Left = 8
    Top = 350
    Width = 60
    Height = 13
    Caption = 'Rain Gauges'
  end
  object Label13: TLabel
    Left = 8
    Top = 294
    Width = 86
    Height = 13
    Caption = 'Start Date / Time:'
  end
  object Label19: TLabel
    Left = 8
    Top = 320
    Width = 80
    Height = 13
    Caption = 'End Date / Time:'
  end
  object ComboBoxSewershedName: TComboBox
    Left = 8
    Top = 25
    Width = 282
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 0
    OnChange = ComboBoxSewershedNameChange
  end
  object ListBoxRDIIAreas: TListBox
    Left = 8
    Top = 71
    Width = 281
    Height = 69
    ItemHeight = 13
    TabOrder = 1
    OnClick = ListBoxRDIIAreasClick
  end
  object ComboBoxAnalysisName: TComboBox
    Left = 8
    Top = 165
    Width = 282
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 2
    OnChange = ComboBoxAnalysisNameChange
  end
  object ListBoxEvents: TListBox
    Left = 8
    Top = 211
    Width = 281
    Height = 69
    ItemHeight = 13
    TabOrder = 3
    OnClick = ListBoxEventsClick
  end
  object GroupBoxRTKParameters: TGroupBox
    Left = 8
    Top = 396
    Width = 282
    Height = 262
    TabOrder = 4
    object Label12: TLabel
      Left = 80
      Top = 21
      Width = 7
      Height = 13
      Caption = 'R'
    end
    object Label14: TLabel
      Left = 150
      Top = 21
      Width = 6
      Height = 13
      Caption = 'T'
    end
    object Label15: TLabel
      Left = 220
      Top = 21
      Width = 6
      Height = 13
      Caption = 'K'
    end
    object Label16: TLabel
      Left = 13
      Top = 41
      Width = 6
      Height = 13
      Caption = '1'
    end
    object Label17: TLabel
      Left = 13
      Top = 66
      Width = 6
      Height = 13
      Caption = '2'
    end
    object Label18: TLabel
      Left = 13
      Top = 93
      Width = 6
      Height = 13
      Caption = '3'
    end
    object Label3: TLabel
      Left = 13
      Top = 6
      Width = 77
      Height = 13
      Caption = 'RTK Parameters'
    end
    object Label4: TLabel
      Left = 13
      Top = 127
      Width = 38
      Height = 13
      Caption = 'Total R:'
    end
    object Label6: TLabel
      Left = 13
      Top = 155
      Width = 27
      Height = 13
      Caption = 'Area:'
    end
    object LabelAreaUnits: TLabel
      Left = 131
      Top = 155
      Width = 11
      Height = 13
      Caption = 'ac'
    end
    object Label8: TLabel
      Left = 13
      Top = 182
      Width = 51
      Height = 13
      Caption = 'Rain Peak:'
    end
    object LabelVolUnits: TLabel
      Left = 159
      Top = 206
      Width = 9
      Height = 13
      Caption = 'cf'
    end
    object Label9: TLabel
      Left = 13
      Top = 208
      Width = 60
      Height = 13
      Caption = 'Total Depth:'
    end
    object LabelMaxUnits: TLabel
      Left = 159
      Top = 182
      Width = 9
      Height = 13
      Caption = 'cf'
    end
    object Label10: TLabel
      Left = 13
      Top = 234
      Width = 45
      Height = 13
      Caption = 'Duration:'
    end
    object Label20: TLabel
      Left = 159
      Top = 232
      Width = 16
      Height = 13
      Caption = 'Hrs'
    end
    object R1Edit2: TEdit
      Left = 58
      Top = 37
      Width = 49
      Height = 21
      TabOrder = 0
      Text = '0.01'
      OnChange = R1Edit2Change
      OnKeyPress = R1Edit2KeyPress
    end
    object R2Edit2: TEdit
      Left = 58
      Top = 64
      Width = 49
      Height = 21
      TabOrder = 1
      Text = '0.02'
      OnChange = R1Edit2Change
      OnKeyPress = R1Edit2KeyPress
    end
    object R3Edit2: TEdit
      Left = 58
      Top = 91
      Width = 49
      Height = 21
      TabOrder = 2
      Text = '0.03'
      OnChange = R1Edit2Change
      OnKeyPress = R1Edit2KeyPress
    end
    object T1Edit2: TEdit
      Left = 131
      Top = 37
      Width = 49
      Height = 21
      TabOrder = 3
      Text = '1'
      OnChange = T1Edit2Change
      OnKeyPress = R1Edit2KeyPress
    end
    object T2Edit2: TEdit
      Left = 132
      Top = 64
      Width = 49
      Height = 21
      TabOrder = 4
      Text = '2'
      OnChange = T1Edit2Change
      OnKeyPress = R1Edit2KeyPress
    end
    object T3Edit2: TEdit
      Left = 132
      Top = 91
      Width = 49
      Height = 21
      TabOrder = 5
      Text = '3'
      OnChange = T1Edit2Change
      OnKeyPress = R1Edit2KeyPress
    end
    object K1Edit2: TEdit
      Left = 204
      Top = 37
      Width = 49
      Height = 21
      TabOrder = 6
      Text = '1'
      OnChange = T1Edit2Change
      OnKeyPress = R1Edit2KeyPress
    end
    object K2Edit2: TEdit
      Left = 204
      Top = 64
      Width = 49
      Height = 21
      TabOrder = 7
      Text = '2'
      OnChange = T1Edit2Change
      OnKeyPress = R1Edit2KeyPress
    end
    object K3Edit2: TEdit
      Left = 204
      Top = 91
      Width = 49
      Height = 21
      TabOrder = 8
      Text = '3'
      OnChange = T1Edit2Change
      OnKeyPress = R1Edit2KeyPress
    end
    object RTotalEdit: TEdit
      Left = 58
      Top = 124
      Width = 49
      Height = 21
      ReadOnly = True
      TabOrder = 9
      Text = '0.06'
    end
    object EditArea: TEdit
      Left = 58
      Top = 152
      Width = 65
      Height = 21
      ReadOnly = True
      TabOrder = 10
      Text = '2448.02'
    end
    object EditPeak: TEdit
      Left = 88
      Top = 179
      Width = 65
      Height = 21
      ReadOnly = True
      TabOrder = 11
      Text = '2448.02'
    end
    object EditVolume: TEdit
      Left = 88
      Top = 205
      Width = 65
      Height = 21
      ReadOnly = True
      TabOrder = 12
      Text = '2448.02'
    end
    object btnSaveRTKs: TButton
      Left = 204
      Top = 118
      Width = 75
      Height = 37
      Caption = 'Save RTKs'
      TabOrder = 13
      OnClick = btnSaveRTKsClick
    end
    object EditDuration: TEdit
      Left = 88
      Top = 231
      Width = 65
      Height = 21
      ReadOnly = True
      TabOrder = 14
      Text = '2448.02'
    end
  end
  object ComboBoxRainGauges: TComboBox
    Left = 8
    Top = 369
    Width = 282
    Height = 21
    Style = csDropDownList
    Enabled = False
    ItemHeight = 0
    TabOrder = 5
  end
  object StartDatePicker: TDateTimePicker
    Left = 96
    Top = 290
    Width = 97
    Height = 21
    Date = 36892.000000000000000000
    Time = 36892.000000000000000000
    DateMode = dmUpDown
    TabOrder = 6
  end
  object StartTimePicker: TDateTimePicker
    Left = 199
    Top = 290
    Width = 91
    Height = 21
    Date = 2.000000000000000000
    Time = 2.000000000000000000
    DateMode = dmUpDown
    Kind = dtkTime
    TabOrder = 7
  end
  object EndDatePicker: TDateTimePicker
    Left = 96
    Top = 316
    Width = 97
    Height = 21
    Date = 36892.000000000000000000
    Time = 36892.000000000000000000
    DateMode = dmUpDown
    TabOrder = 8
  end
  object EndTimePicker: TDateTimePicker
    Left = 198
    Top = 316
    Width = 91
    Height = 21
    Date = 2.000000000000000000
    Time = 2.000000000000000000
    DateMode = dmUpDown
    Kind = dtkTime
    TabOrder = 9
  end
  object okButton: TButton
    Left = 8
    Top = 664
    Width = 75
    Height = 25
    Caption = 'Export'
    Default = True
    TabOrder = 10
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 110
    Top = 664
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 11
    Visible = False
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 214
    Top = 664
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 12
    OnClick = cancelButtonClick
  end
  object btnUpdate: TButton
    Left = 136
    Top = 514
    Width = 75
    Height = 37
    Caption = 'Update Chart'
    TabOrder = 13
    OnClick = btnUpdateClick
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 376
    Top = 512
  end
  object SaveStatsDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 376
    Top = 544
  end
end
