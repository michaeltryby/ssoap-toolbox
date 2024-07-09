object frmRDIIPatterns: TfrmRDIIPatterns
  Left = 0
  Top = 0
  Caption = 'RTK Patterns'
  ClientHeight = 588
  ClientWidth = 916
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 8
    Width = 43
    Height = 13
    Caption = 'Analyses'
  end
  object Label2: TLabel
    Left = 5
    Top = 54
    Width = 33
    Height = 13
    Caption = 'Events'
  end
  object Label13: TLabel
    Left = 5
    Top = 156
    Width = 86
    Height = 13
    Caption = 'Start Date / Time:'
  end
  object Label19: TLabel
    Left = 5
    Top = 182
    Width = 80
    Height = 13
    Caption = 'End Date / Time:'
  end
  object Label11: TLabel
    Left = 5
    Top = 212
    Width = 60
    Height = 13
    Caption = 'Rain Gauges'
  end
  object GroupBoxRTKParameters: TGroupBox
    Left = 8
    Top = 258
    Width = 282
    Height = 321
    TabOrder = 0
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
    object EditArea: TEdit
      Left = 58
      Top = 152
      Width = 65
      Height = 21
      ReadOnly = True
      TabOrder = 0
      Text = '2448.02'
    end
    object EditPeak: TEdit
      Left = 88
      Top = 179
      Width = 65
      Height = 21
      ReadOnly = True
      TabOrder = 1
      Text = '2448.02'
    end
    object EditVolume: TEdit
      Left = 88
      Top = 205
      Width = 65
      Height = 21
      ReadOnly = True
      TabOrder = 2
      Text = '2448.02'
    end
    object btnSaveRTKs: TButton
      Left = 187
      Top = 270
      Width = 75
      Height = 37
      Caption = 'Save RTKs'
      TabOrder = 3
    end
    object EditDuration: TEdit
      Left = 88
      Top = 231
      Width = 65
      Height = 21
      ReadOnly = True
      TabOrder = 4
      Text = '2448.02'
    end
    object btnUpdate: TButton
      Left = 106
      Top = 270
      Width = 75
      Height = 37
      Caption = 'Update Chart'
      TabOrder = 5
      OnClick = btnUpdateClick
    end
    inline FrameRTKPattern1: TFrameRTKPattern
      Left = 11
      Top = 6
      Width = 250
      Height = 143
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 6
      TabStop = True
      ExplicitLeft = 11
      ExplicitTop = 6
      ExplicitHeight = 143
    end
  end
  object ComboBoxAnalysisName: TComboBox
    Left = 5
    Top = 27
    Width = 281
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = ComboBoxAnalysisNameChange
  end
  object ListBoxEvents: TListBox
    Left = 5
    Top = 73
    Width = 281
    Height = 69
    ItemHeight = 13
    TabOrder = 2
    OnClick = ListBoxEventsClick
  end
  object StartDatePicker: TDateTimePicker
    Left = 93
    Top = 152
    Width = 97
    Height = 21
    Date = 36892.000000000000000000
    Time = 36892.000000000000000000
    DateMode = dmUpDown
    TabOrder = 3
  end
  object StartTimePicker: TDateTimePicker
    Left = 196
    Top = 152
    Width = 91
    Height = 21
    Date = 2.000000000000000000
    Time = 2.000000000000000000
    DateMode = dmUpDown
    Kind = dtkTime
    TabOrder = 4
  end
  object EndDatePicker: TDateTimePicker
    Left = 93
    Top = 178
    Width = 97
    Height = 21
    Date = 36892.000000000000000000
    Time = 36892.000000000000000000
    DateMode = dmUpDown
    TabOrder = 5
  end
  object EndTimePicker: TDateTimePicker
    Left = 195
    Top = 178
    Width = 91
    Height = 21
    Date = 2.000000000000000000
    Time = 2.000000000000000000
    DateMode = dmUpDown
    Kind = dtkTime
    TabOrder = 6
  end
  object ComboBoxRainGauges: TComboBox
    Left = 5
    Top = 231
    Width = 282
    Height = 21
    Style = csDropDownList
    Enabled = False
    ItemHeight = 13
    TabOrder = 7
  end
  inline FrameRDIIGraph1: TFrameRDIIGraph
    Left = 296
    Top = 8
    Width = 380
    Height = 572
    TabOrder = 8
    TabStop = True
    ExplicitLeft = 296
    ExplicitTop = 8
    ExplicitWidth = 380
    ExplicitHeight = 572
  end
end
